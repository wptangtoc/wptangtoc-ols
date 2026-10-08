#!/usr/bin/env bats

# ==============================================================================
# WPTangToc OLS - Kiểm thử wptt-ssh-port
# ==============================================================================

SSHD_CONFIG="/etc/ssh/sshd_config"
SSHD_DROPIN="/etc/ssh/sshd_config.d"
WPTT_CONF="/etc/wptt/.wptt.conf"
WPTT_SSH_SCRIPT="/etc/wptt/ssh/wptt-ssh-port"
# Các port mà bài test sẽ thử đổi sang (dùng để dọn firewall/SELinux nếu bị rò rỉ)
TEST_PORTS="22222 33333"

# ------------------------------------------------------------------------------
# HÀM TIỆN ÍCH
# ------------------------------------------------------------------------------

# Chụp lại toàn bộ trạng thái hệ thống vào thư mục $1
_snapshot_state() {
  local dir="$1"
  mkdir -p "$dir"

  # File cấu hình SSH + thư mục drop-in (OpenSSH mới ưu tiên file trong .d/)
  cp -a "$SSHD_CONFIG" "$dir/sshd_config"
  if [ -d "$SSHD_DROPIN" ]; then
    rm -rf "$dir/sshd_config.d"
    cp -a "$SSHD_DROPIN" "$dir/sshd_config.d"
  else
    touch "$dir/no_dropin"
  fi

  # File cấu hình chính của WPTangToc (nếu có)
  if [ -f "$WPTT_CONF" ]; then
    cp -a "$WPTT_CONF" "$dir/wptt.conf"
  else
    touch "$dir/no_wptt_conf"
  fi

  # Firewall: iptables / firewalld / ufw
  if command -v iptables-save >/dev/null 2>&1; then
    iptables-save >"$dir/iptables.rules" 2>/dev/null || true
  fi
  if command -v firewall-cmd >/dev/null 2>&1 && firewall-cmd --state >/dev/null 2>&1; then
    firewall-cmd --permanent --list-ports >"$dir/firewalld.ports" 2>/dev/null || true
  fi
  if command -v ufw >/dev/null 2>&1; then
    ufw status 2>/dev/null >"$dir/ufw.status" || true
  fi

  # SELinux: danh sách port được gán nhãn ssh_port_t
  if command -v semanage >/dev/null 2>&1; then
    semanage port -l 2>/dev/null | awk '/^ssh_port_t/' >"$dir/selinux.ssh_port_t" || true
  fi

  # Các file backup mà script có thể sinh ra cạnh sshd_config
  ls -1 /etc/ssh 2>/dev/null >"$dir/etc_ssh.listing" || true
}

# Khôi phục trạng thái từ thư mục $1 (idempotent, không bao giờ làm teardown sập)
_restore_state() {
  local dir="$1"
  [ -d "$dir" ] || return 0

  # 1. sshd_config: ghi đè bằng cp để giữ nguyên quyền/owner
  if [ -f "$dir/sshd_config" ]; then
    cp -a "$dir/sshd_config" "$SSHD_CONFIG" 2>/dev/null || true
  fi

  # 2. Thư mục drop-in
  if [ -d "$dir/sshd_config.d" ]; then
    rm -rf "$SSHD_DROPIN" 2>/dev/null || true
    cp -a "$dir/sshd_config.d" "$SSHD_DROPIN" 2>/dev/null || true
  elif [ -f "$dir/no_dropin" ]; then
    rm -rf "$SSHD_DROPIN" 2>/dev/null || true
  fi

  # 3. Xóa các file rác mà script có thể tạo trong /etc/ssh (backup, .tmp, ...)
  if [ -f "$dir/etc_ssh.listing" ]; then
    local f
    for f in $(ls -1 /etc/ssh 2>/dev/null); do
      grep -qxF "$f" "$dir/etc_ssh.listing" || rm -rf "/etc/ssh/$f" 2>/dev/null || true
    done
  fi

  # 4. File cấu hình WPTangToc
  if [ -f "$dir/wptt.conf" ]; then
    cp -a "$dir/wptt.conf" "$WPTT_CONF" 2>/dev/null || true
  fi

  # 5. iptables
  if [ -f "$dir/iptables.rules" ] && [ -s "$dir/iptables.rules" ] &&
    command -v iptables-restore >/dev/null 2>&1; then
    iptables-restore <"$dir/iptables.rules" 2>/dev/null || true
  fi

  # 6. firewalld / ufw / SELinux: chỉ gỡ port TEST mà baseline không có
  local p
  for p in $TEST_PORTS; do
    if [ -f "$dir/firewalld.ports" ] && ! grep -qw "${p}/tcp" "$dir/firewalld.ports"; then
      firewall-cmd --permanent --remove-port="${p}/tcp" >/dev/null 2>&1 || true
      firewall-cmd --remove-port="${p}/tcp" >/dev/null 2>&1 || true
    fi
    if [ -f "$dir/ufw.status" ] && ! grep -qw "${p}/tcp" "$dir/ufw.status"; then
      ufw --force delete allow "${p}/tcp" >/dev/null 2>&1 || true
    fi
    if [ -f "$dir/selinux.ssh_port_t" ] && ! grep -qw "$p" "$dir/selinux.ssh_port_t"; then
      semanage port -d -t ssh_port_t -p tcp "$p" >/dev/null 2>&1 || true
    fi
  done
}

# Gỡ mount --bind giả lập sshd (lazy để không bị lỗi "target is busy")
_cleanup_mock_sshd() {
  while mount | grep -q " on /usr/sbin/sshd "; do
    umount -l /usr/sbin/sshd 2>/dev/null || break
  done
  rm -rf "$MOCK_DIR/sshd" 2>/dev/null || true
}

# Kiểm tra hệ thống đã sạch hoàn toàn chưa; trả về != 0 nếu còn rò rỉ
_assert_clean() {
  local dir="$1" rc=0

  if ! cmp -s "$dir/sshd_config" "$SSHD_CONFIG"; then
    echo "RÒ RỈ: $SSHD_CONFIG khác với bản gốc" >&2
    diff "$dir/sshd_config" "$SSHD_CONFIG" >&2 || true
    rc=1
  fi
  if mount | grep -q " on /usr/sbin/sshd "; then
    echo "RÒ RỈ: /usr/sbin/sshd vẫn đang bị mount giả lập" >&2
    rc=1
  fi
  if ls -d /etc/wptt/tmp/ssh_port.* >/dev/null 2>&1; then
    echo "RÒ RỈ: còn thư mục tạm /etc/wptt/tmp/ssh_port.*" >&2
    rc=1
  fi
  return $rc
}

# ==============================================================================
# KHỞI TẠO / DỌN DẸP CẤP FILE (LƯỚI AN TOÀN CUỐI CÙNG)
# ==============================================================================
setup_file() {
  export BASELINE_DIR="$BATS_FILE_TMPDIR/baseline"
  _snapshot_state "$BASELINE_DIR"

  # Ghi nhận host keys: nếu chưa có thì sau cùng sẽ xóa các key do test sinh ra
  if ls /etc/ssh/ssh_host_*_key >/dev/null 2>&1; then
    echo "yes" >"$BASELINE_DIR/had_hostkeys"
  else
    echo "no" >"$BASELINE_DIR/had_hostkeys"
  fi
}

teardown_file() {
  # Dù từng test đã tự hoàn nguyên, vẫn khôi phục lần cuối từ baseline gốc
  while mount | grep -q " on /usr/sbin/sshd "; do
    umount -l /usr/sbin/sshd 2>/dev/null || break
  done
  _restore_state "$BASELINE_DIR"

  # Xóa host keys ảo do test sinh ra (chỉ khi trước đó hệ thống chưa có)
  if [ "$(cat "$BASELINE_DIR/had_hostkeys" 2>/dev/null)" = "no" ]; then
    rm -f /etc/ssh/ssh_host_* 2>/dev/null || true
  fi

  rm -rf /etc/wptt/tmp/ssh_port.* 2>/dev/null || true
}

# ==============================================================================
# KHỞI TẠO MÔI TRƯỜNG CÔ LẬP (SETUP / TEARDOWN) CHO TỪNG TEST
# ==============================================================================
setup() {
  # Tiền điều kiện: cần root và có sshd_config, nếu không thì bỏ qua thay vì làm hỏng máy
  [ "$(id -u)" -eq 0 ] || skip "Cần quyền root để chạy bộ test này"
  [ -f "$SSHD_CONFIG" ] || skip "Không tìm thấy $SSHD_CONFIG"
  [ -x "$WPTT_SSH_SCRIPT" ] || [ -f "$WPTT_SSH_SCRIPT" ] || skip "Không tìm thấy $WPTT_SSH_SCRIPT"

  # Thư mục mock riêng cho từng test (không dùng đường dẫn cố định dễ đụng nhau)
  MOCK_DIR="${BATS_TEST_TMPDIR:-$(mktemp -d)}/mock"
  export MOCK_DIR
  mkdir -p "$MOCK_DIR/bin"

  # 1. Giả lập systemctl/service để không restart sshd thật trong Docker/GitHub Actions
  printf '#!/bin/bash\nexit 0\n' >"$MOCK_DIR/bin/systemctl"
  printf '#!/bin/bash\nexit 0\n' >"$MOCK_DIR/bin/service"
  chmod +x "$MOCK_DIR/bin/systemctl" "$MOCK_DIR/bin/service"
  export PATH="$MOCK_DIR/bin:$PATH"

  # 2. Sinh Host Keys ảo để vượt qua bài test cú pháp sshd -t
  ssh-keygen -A >/dev/null 2>&1 || true

  # 3. Chụp lại TOÀN BỘ trạng thái gốc của test này (không chỉ sshd_config)
  TEST_BASELINE="$MOCK_DIR/baseline"
  export TEST_BASELINE
  _snapshot_state "$TEST_BASELINE"

  # 4. Xóa cấu hình Port nhiễu (cả file chính lẫn drop-in) và đặt Port 22 làm mốc
  sed -i '/^[[:space:]]*#\?[[:space:]]*Port[[:space:]]/d' "$SSHD_CONFIG"
  if [ -d "$SSHD_DROPIN" ]; then
    sed -i '/^[[:space:]]*Port[[:space:]]/d' "$SSHD_DROPIN"/*.conf 2>/dev/null || true
  fi
  echo "Port 22" >>"$SSHD_CONFIG"

  # 5. Đảm bảo thư mục tmp sạch sẽ trước khi test
  rm -rf /etc/wptt/tmp/ssh_port.* 2>/dev/null || true
}

teardown() {
  # Bắt buộc chạy được cả khi test FAIL hoặc setup bị skip giữa chừng
  [ -n "${TEST_BASELINE:-}" ] || return 0

  # 1. Gỡ mount giả lập TRƯỚC (nếu không, việc khôi phục có thể chạm vào sshd giả)
  _cleanup_mock_sshd

  # 2. Hoàn nguyên toàn bộ: sshd_config, drop-in, wptt.conf, firewall, SELinux
  _restore_state "$TEST_BASELINE"

  # 3. Dọn rác của script (bẫy trap EXIT có thể không chạy nếu script bị kill)
  rm -rf /etc/wptt/tmp/ssh_port.* 2>/dev/null || true

  # 4. Kiểm chứng: nếu còn rò rỉ thì test này bị đánh FAIL để lộ ngay trên CI
  local rc=0
  _assert_clean "$TEST_BASELINE" || rc=1

  # 5. Cuối cùng mới xóa mock
  rm -rf "$MOCK_DIR" 2>/dev/null || true
  return $rc
}

# ==============================================================================
# NHÓM KIỂM THỬ 1: RÀ SOÁT TÍNH TOÀN VẸN DỮ LIỆU ĐẦU VÀO (VALIDATION)
# ==============================================================================

@test "[Validation] Từ chối Port chứa chữ cái hoặc ký tự đặc biệt" {
  run bash "$WPTT_SSH_SCRIPT" "22abc"
  [ "$status" -eq 1 ]
  [[ "$output" == *"không hợp lệ"* ]]
}

@test "[Validation] Từ chối Port nằm ngoài không gian cho phép (1-65535)" {
  run bash "$WPTT_SSH_SCRIPT" "99999"
  [ "$status" -eq 1 ]
  [[ "$output" == *"không hợp lệ"* ]]
}

@test "[Validation] Từ chối Port bằng 0 hoặc rỗng" {
  run bash "$WPTT_SSH_SCRIPT" "0"
  [ "$status" -eq 1 ]
  run bash "$WPTT_SSH_SCRIPT" ""
  [ "$status" -eq 1 ]
}

@test "[Validation] Khóa cứng bảo vệ các Port mặc định của Webserver (80, 443)" {
  run bash "$WPTT_SSH_SCRIPT" "443"
  [ "$status" -eq 1 ]
  [[ "$output" == *"đang được sử dụng bởi hệ thống Webserver"* ]]
}

@test "[Validation] Hủy tiến trình nếu Port mới trùng Port hiện tại" {
  run bash "$WPTT_SSH_SCRIPT" "22"
  [ "$status" -eq 1 ]
  # Thông báo có thể là "trùng"/"đang được sử dụng": chấp nhận cả hai để test không giòn
  [[ "$output" == *"đang được sử dụng"* || "$output" == *"trùng"* ]]
}

@test "[Validation] Đầu vào lỗi không được làm thay đổi sshd_config" {
  run bash "$WPTT_SSH_SCRIPT" "99999"
  [ "$status" -eq 1 ]
  run grep -E "^Port 22$" "$SSHD_CONFIG"
  [ "$status" -eq 0 ]
}

# ==============================================================================
# NHÓM KIỂM THỬ 2: GIAO DỊCH NGUYÊN TỬ VÀ KHẢ NĂNG TỰ CHỮA LÀNH
# ==============================================================================

@test "[Enterprise] Thực thi đổi Port nguyên tử và dọn dẹp Workspace tự động" {
  # Bơm chuỗi "1" qua stdin để tự động pass qua hàm wptt_xac_nhan
  run bash "$WPTT_SSH_SCRIPT" 22222 <<<"1"

  # --- ĐOẠN DEBUG (IN LOG NẾU LỖI ĐỂ TÌM NGUYÊN NHÂN TRÊN GITHUB ACTIONS) ---
  if [ "$status" -ne 0 ]; then
    echo -e "\n=== 🚨 DỮ LIỆU DEBUG (OUTPUT CỦA SCRIPT) ===" >&3
    echo "$output" >&3
    echo -e "=============================================\n" >&3
  fi

  # Kịch bản phải trả về status 0 (Thành công hoàn toàn)
  [ "$status" -eq 0 ]

  # File sshd_config phải chứa đúng 1 dòng Port 22222 và không còn Port 22
  run grep -E "^Port 22222$" "$SSHD_CONFIG"
  [ "$status" -eq 0 ]
  [ "$(grep -cE '^Port[[:space:]]' "$SSHD_CONFIG")" -eq 1 ]

  # Bẫy trap EXIT phải xóa sạch thư mục tạm
  run ls -d /etc/wptt/tmp/ssh_port.*
  [ "$status" -ne 0 ]

  # teardown() sẽ tự hoàn nguyên Port 22 và FAIL test nếu còn rò rỉ
}

@test "[Fail-Safe] Bắt buộc Rollback khi file cấu hình nháp không vượt qua Syntax Check" {
  # Giả lập sshd -t luôn lỗi bằng mount --bind lên đường dẫn tuyệt đối
  mkdir -p "$MOCK_DIR/sshd"
  cat <<'EOF' >"$MOCK_DIR/sshd/sshd_fake"
#!/bin/bash
# Nếu gọi cờ -t (test syntax), ép văng lỗi
if [[ "$*" == *"-t"* ]]; then
  exit 1
fi
EOF
  chmod +x "$MOCK_DIR/sshd/sshd_fake"
  mount --bind "$MOCK_DIR/sshd/sshd_fake" /usr/sbin/sshd

  # Khởi chạy script đổi sang cổng 33333
  run bash "$WPTT_SSH_SCRIPT" 33333 <<<"1"

  # Tháo mount NGAY và không phụ thuộc kết quả (teardown vẫn sẽ gỡ lại lần nữa)
  umount -l /usr/sbin/sshd 2>/dev/null || true

  # Kịch bản phải phát hiện lỗi và ép dừng khẩn cấp (Exit 1)
  [ "$status" -eq 1 ]

  # Giao diện phải in ra cảnh báo Rollback
  [[ "$output" == *"Lỗi cú pháp bị phát hiện trên file tạm"* ]]

  # Zero-Trust: file gốc tuyệt đối không bị suy xuyển (vẫn đúng Port 22)
  run grep -E "^Port 22$" "$SSHD_CONFIG"
  [ "$status" -eq 0 ]

  # Cổng 33333 không được phép xuất hiện trong file gốc
  run grep -q "33333" "$SSHD_CONFIG"
  [ "$status" -ne 0 ]
}

@test "[Isolation] Sau test đổi Port, hệ thống phải trở về Port 22 (kiểm chứng teardown)" {
  run bash "$WPTT_SSH_SCRIPT" 22222 <<<"1"
  [ "$status" -eq 0 ]

  # Mô phỏng chính thao tác của teardown rồi xác nhận baseline được khôi phục
  _restore_state "$TEST_BASELINE"
  run grep -E "^Port 22222" "$SSHD_CONFIG"
  [ "$status" -ne 0 ]
  cmp -s "$TEST_BASELINE/sshd_config" "$SSHD_CONFIG"
}
