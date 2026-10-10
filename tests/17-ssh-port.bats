#!/usr/bin/env bats

# ==============================================================================
# WPTangToc OLS - Kiểm thử wptt-ssh-port (phiên bản hoàn nguyên cả TIẾN TRÌNH sshd)
# ==============================================================================

# Lưu PATH gốc TRƯỚC khi setup() chèn thư mục mock vào đầu PATH.
# Dùng để gọi systemctl/sshd thật trong teardown.
ORIG_PATH="$PATH"
export CI="true"
SSHD_CONFIG="/etc/ssh/sshd_config"
SSHD_DROPIN="/etc/ssh/sshd_config.d"
WPTT_CONF="/etc/wptt/.wptt.conf"
WPTT_SSH_SCRIPT="/etc/wptt/ssh/wptt-ssh-port"
TEST_PORTS="22222 33333"

# ------------------------------------------------------------------------------
# HÀM TIỆN ÍCH
# ------------------------------------------------------------------------------

# Danh sách port mà tiến trình sshd ĐANG THỰC SỰ lắng nghe (khác với port trong file)
_sshd_listen_ports() {
  ss -Hltnp 2>/dev/null | awk '/"sshd"/ { n = split($4, a, ":"); print a[n] }' | sort -un
}

# Tên unit systemd của sshd (sshd trên RHEL/Alma, ssh trên Debian/Ubuntu)
_sshd_unit() {
  local u
  for u in sshd ssh; do
    if PATH="$ORIG_PATH" systemctl list-unit-files "${u}.service" 2>/dev/null | grep -q "^${u}.service"; then
      echo "$u"
      return 0
    fi
  done
  return 1
}

# Chụp lại toàn bộ trạng thái hệ thống vào thư mục $1
_snapshot_state() {
  local dir="$1"
  mkdir -p "$dir"

  # --- Lớp 1: file ---
  cp -a "$SSHD_CONFIG" "$dir/sshd_config"
  if [ -d "$SSHD_DROPIN" ]; then
    rm -rf "$dir/sshd_config.d"
    cp -a "$SSHD_DROPIN" "$dir/sshd_config.d"
  else
    touch "$dir/no_dropin"
  fi

  if [ -f "$WPTT_CONF" ]; then
    cp -a "$WPTT_CONF" "$dir/wptt.conf"
  else
    touch "$dir/no_wptt_conf"
  fi

  ls -1 /etc/ssh 2>/dev/null >"$dir/etc_ssh.listing" || true

  # --- Lớp 2: firewall ---
  if command -v iptables-save >/dev/null 2>&1; then
    iptables-save >"$dir/iptables.rules" 2>/dev/null || true
  fi
  if command -v firewall-cmd >/dev/null 2>&1 && firewall-cmd --state >/dev/null 2>&1; then
    firewall-cmd --permanent --list-ports >"$dir/firewalld.ports" 2>/dev/null || true
    firewall-cmd --permanent --list-services >"$dir/firewalld.services" 2>/dev/null || true
    touch "$dir/firewalld.active"
  fi
  if command -v ufw >/dev/null 2>&1; then
    ufw status 2>/dev/null >"$dir/ufw.status" || true
  fi
  if command -v semanage >/dev/null 2>&1; then
    semanage port -l 2>/dev/null | awk '/^ssh_port_t/' >"$dir/selinux.ssh_port_t" || true
  fi

  # --- Lớp 3: tiến trình sshd đang chạy ---
  _sshd_listen_ports >"$dir/sshd.listen" || true
}

# Đưa sshd đang chạy về đúng tập port ban đầu. Trả về 1 nếu không làm được.
_restore_sshd_service() {
  local dir="$1" want now unit i pid
  # Baseline không có sshd đang chạy (ví dụ container) thì không động vào
  [ -s "$dir/sshd.listen" ] || return 0

  want="$(tr '\n' ' ' <"$dir/sshd.listen")"
  now="$(_sshd_listen_ports | tr '\n' ' ')"
  [ "$want" = "$now" ] && return 0

  # Chỉ restart khi cấu hình đã khôi phục hợp lệ, tránh tự làm sập sshd
  if ! /usr/sbin/sshd -t 2>/dev/null; then
    echo "CẢNH BÁO: sshd_config sau khi khôi phục không qua được sshd -t, bỏ qua restart" >&2
    return 1
  fi

  unit="$(_sshd_unit)" || unit=""
  if [ -n "$unit" ]; then
    PATH="$ORIG_PATH" systemctl restart "$unit" >/dev/null 2>&1 || true
    # Ubuntu mới dùng socket activation: port nằm ở ssh.socket
    if PATH="$ORIG_PATH" systemctl is-active --quiet ssh.socket 2>/dev/null; then
      PATH="$ORIG_PATH" systemctl restart ssh.socket >/dev/null 2>&1 || true
    fi
  else
    # Không có systemd (container): ép master sshd đọc lại cấu hình
    pid="$(pgrep -o -x sshd 2>/dev/null || true)"
    if [ -n "$pid" ]; then
      kill -HUP "$pid" 2>/dev/null || true
    fi
  fi

  # Chờ sshd bind lại port, tối đa 10 giây
  for i in 1 2 3 4 5 6 7 8 9 10; do
    now="$(_sshd_listen_ports | tr '\n' ' ')"
    [ "$want" = "$now" ] && return 0
    sleep 1
  done
  echo "RÒ RỈ: sshd đang lắng nghe [${now}] nhưng baseline là [${want}]" >&2
  return 1
}

# Khôi phục file + firewall từ thư mục $1 (idempotent, không bao giờ làm teardown sập)
_restore_state() {
  local dir="$1" f p q changed
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

  # 3. Xóa file rác mà script có thể tạo trong /etc/ssh (backup, .tmp, ...)
  if [ -f "$dir/etc_ssh.listing" ]; then
    for f in $(ls -1 /etc/ssh 2>/dev/null); do
      if ! grep -qxF "$f" "$dir/etc_ssh.listing"; then
        rm -rf "/etc/ssh/$f" 2>/dev/null || true
      fi
    done
  fi

  # 4. File cấu hình WPTangToc
  if [ -f "$dir/wptt.conf" ]; then
    cp -a "$dir/wptt.conf" "$WPTT_CONF" 2>/dev/null || true
  fi

  # 5. firewalld: đưa về đúng tập port/service ban đầu (gỡ cái thêm, thêm lại cái bị gỡ)
  if [ -f "$dir/firewalld.active" ] && command -v firewall-cmd >/dev/null 2>&1 &&
    firewall-cmd --state >/dev/null 2>&1; then
    changed=0
    for q in $(firewall-cmd --permanent --list-ports 2>/dev/null); do
      if ! grep -qw -- "$q" "$dir/firewalld.ports"; then
        firewall-cmd --permanent --remove-port="$q" >/dev/null 2>&1 || true
        changed=1
      fi
    done
    for q in $(cat "$dir/firewalld.ports" 2>/dev/null); do
      if ! firewall-cmd --permanent --query-port="$q" >/dev/null 2>&1; then
        firewall-cmd --permanent --add-port="$q" >/dev/null 2>&1 || true
        changed=1
      fi
    done
    for q in $(firewall-cmd --permanent --list-services 2>/dev/null); do
      if ! grep -qw -- "$q" "$dir/firewalld.services"; then
        firewall-cmd --permanent --remove-service="$q" >/dev/null 2>&1 || true
        changed=1
      fi
    done
    for q in $(cat "$dir/firewalld.services" 2>/dev/null); do
      if ! firewall-cmd --permanent --query-service="$q" >/dev/null 2>&1; then
        firewall-cmd --permanent --add-service="$q" >/dev/null 2>&1 || true
        changed=1
      fi
    done
    if [ "$changed" -eq 1 ]; then
      firewall-cmd --reload >/dev/null 2>&1 || true
    fi
  elif [ -s "$dir/iptables.rules" ] && command -v iptables-restore >/dev/null 2>&1 &&
    ! { command -v ufw >/dev/null 2>&1 && ufw status 2>/dev/null | grep -q "Status: active"; }; then
    # Chỉ restore iptables khi không có firewalld/ufw quản lý (tránh xung đột)
    iptables-restore <"$dir/iptables.rules" 2>/dev/null || true
  fi

  # 6. ufw / SELinux: gỡ port TEST mà baseline không có
  for p in $TEST_PORTS; do
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
  local dir="$1" rc=0 want now

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
  # Quan trọng nhất cho CI: sshd phải lắng nghe đúng port ban đầu
  if [ -s "$dir/sshd.listen" ]; then
    want="$(tr '\n' ' ' <"$dir/sshd.listen")"
    now="$(_sshd_listen_ports | tr '\n' ' ')"
    if [ "$want" != "$now" ]; then
      echo "RÒ RỈ: sshd đang lắng nghe [${now}] thay vì [${want}]" >&2
      rc=1
    fi
  fi
  return $rc
}

# ==============================================================================
# KHỞI TẠO / DỌN DẸP CẤP FILE (LƯỚI AN TOÀN CUỐI CÙNG)
# ==============================================================================
setup_file() {
  export BASELINE_DIR="$BATS_FILE_TMPDIR/baseline"
  _snapshot_state "$BASELINE_DIR"

  if ls /etc/ssh/ssh_host_*_key >/dev/null 2>&1; then
    echo "yes" >"$BASELINE_DIR/had_hostkeys"
  else
    echo "no" >"$BASELINE_DIR/had_hostkeys"
  fi
}

teardown_file() {
  while mount | grep -q " on /usr/sbin/sshd "; do
    umount -l /usr/sbin/sshd 2>/dev/null || break
  done

  # Dù từng test đã tự hoàn nguyên, vẫn khôi phục lần cuối từ baseline gốc
  _restore_state "$BASELINE_DIR"
  _restore_sshd_service "$BASELINE_DIR" || true

  if [ "$(cat "$BASELINE_DIR/had_hostkeys" 2>/dev/null)" = "no" ]; then
    rm -f /etc/ssh/ssh_host_* 2>/dev/null || true
  fi

  rm -rf /etc/wptt/tmp/ssh_port.* 2>/dev/null || true

  # In trạng thái cuối để dễ debug trên log CI
  echo "# [teardown_file] sshd đang lắng nghe: $(_sshd_listen_ports | tr '\n' ' ')" >&3
}

# ==============================================================================
# KHỞI TẠO MÔI TRƯỜNG CÔ LẬP (SETUP / TEARDOWN) CHO TỪNG TEST
# ==============================================================================
setup() {
  [ "$(id -u)" -eq 0 ] || skip "Cần quyền root để chạy bộ test này"
  [ -f "$SSHD_CONFIG" ] || skip "Không tìm thấy $SSHD_CONFIG"
  [ -f "$WPTT_SSH_SCRIPT" ] || skip "Không tìm thấy $WPTT_SSH_SCRIPT"

  MOCK_DIR="${BATS_TEST_TMPDIR:-$(mktemp -d)}/mock"
  export MOCK_DIR
  mkdir -p "$MOCK_DIR/bin"

  # 1. Giả lập systemctl/service để script không restart sshd thật (khi gọi qua PATH)
  printf '#!/bin/bash\nexit 0\n' >"$MOCK_DIR/bin/systemctl"
  printf '#!/bin/bash\nexit 0\n' >"$MOCK_DIR/bin/service"
  chmod +x "$MOCK_DIR/bin/systemctl" "$MOCK_DIR/bin/service"
  export PATH="$MOCK_DIR/bin:$PATH"

  # 2. Sinh Host Keys ảo để vượt qua bài test cú pháp sshd -t
  ssh-keygen -A >/dev/null 2>&1 || true

  # 3. Chụp lại TOÀN BỘ trạng thái gốc, gồm cả port sshd đang lắng nghe
  TEST_BASELINE="$MOCK_DIR/baseline"
  export TEST_BASELINE
  _snapshot_state "$TEST_BASELINE"

  # 4. Xóa cấu hình Port nhiễu (file chính + drop-in) và đặt Port 22 làm mốc
  sed -i '/^[[:space:]]*#\?[[:space:]]*Port[[:space:]]/d' "$SSHD_CONFIG"
  if [ -d "$SSHD_DROPIN" ]; then
    sed -i '/^[[:space:]]*Port[[:space:]]/d' "$SSHD_DROPIN"/*.conf 2>/dev/null || true
  fi
  echo "Port 22" >>"$SSHD_CONFIG"

  # 5. Đảm bảo thư mục tmp sạch sẽ trước khi test
  rm -rf /etc/wptt/tmp/ssh_port.* 2>/dev/null || true
}

teardown() {
  [ -n "${TEST_BASELINE:-}" ] || return 0

  # 1. Gỡ mount giả lập trước
  _cleanup_mock_sshd

  # 2. Hoàn nguyên file + firewall
  _restore_state "$TEST_BASELINE"

  # 3. Hoàn nguyên TIẾN TRÌNH sshd (restart bằng systemctl thật qua ORIG_PATH)
  _restore_sshd_service "$TEST_BASELINE" || true

  # 4. Dọn rác của script
  rm -rf /etc/wptt/tmp/ssh_port.* 2>/dev/null || true

  # 5. Kiểm chứng: còn rò rỉ thì test bị FAIL để lộ ngay trên CI
  local rc=0
  _assert_clean "$TEST_BASELINE" || rc=1

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

@test "[Validation] Từ chối Port bằng 0" {
  run bash "$WPTT_SSH_SCRIPT" "0"
  [ "$status" -eq 1 ]
}

@test "[Validation] Khóa cứng bảo vệ các Port mặc định của Webserver (80, 443)" {
  run bash "$WPTT_SSH_SCRIPT" "443"
  [ "$status" -eq 1 ]
  [[ "$output" == *"dành riêng cho máy chủ web"* ]]
}

@test "[Validation] Hủy tiến trình nếu Port mới trùng Port hiện tại" {
  run bash "$WPTT_SSH_SCRIPT" "22"
  [ "$status" -eq 1 ]
  [[ "$output" == *"Không cần thay đổi"* || "$output" == *"trùng"* ]]
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
  run bash "$WPTT_SSH_SCRIPT" 22222 <<<"1"

  if [ "$status" -ne 0 ]; then
    echo -e "\n=== 🚨 DỮ LIỆU DEBUG (OUTPUT CỦA SCRIPT) ===" >&3
    echo "$output" >&3
    echo -e "=============================================\n" >&3
  fi

  [ "$status" -eq 0 ]

  run grep -E "^Port 22222$" "$SSHD_CONFIG"
  [ "$status" -eq 0 ]
  [ "$(grep -cE '^Port[[:space:]]' "$SSHD_CONFIG")" -eq 1 ]

  run ls -d /etc/wptt/tmp/ssh_port.*
  [ "$status" -ne 0 ]

  # Ghi lại để debug: sshd thật có bị đổi port không (teardown sẽ tự khôi phục)
  echo "# sshd lắng nghe sau khi đổi port: $(_sshd_listen_ports | tr '\n' ' ')" >&3
}

@test "[Fail-Safe] Bắt buộc Rollback khi file cấu hình nháp không vượt qua Syntax Check" {
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

  run bash "$WPTT_SSH_SCRIPT" 33333 <<<"1"

  umount -l /usr/sbin/sshd 2>/dev/null || true

  [ "$status" -eq 1 ]
  [[ "$output" == *"Lỗi cú pháp SSHD phát hiện trên bản tạm"* ]]

  run grep -E "^Port 22$" "$SSHD_CONFIG"
  [ "$status" -eq 0 ]

  run grep -q "33333" "$SSHD_CONFIG"
  [ "$status" -ne 0 ]
}

@test "[Isolation] Sau test đổi Port, file + firewall + tiến trình sshd phải về trạng thái ban đầu" {
  run bash "$WPTT_SSH_SCRIPT" 22222 <<<"1"
  [ "$status" -eq 0 ]

  # Mô phỏng chính thao tác của teardown rồi xác nhận mọi lớp đã sạch
  _restore_state "$TEST_BASELINE"
  _restore_sshd_service "$TEST_BASELINE"
  _assert_clean "$TEST_BASELINE"

  run grep -E "^Port 22222" "$SSHD_CONFIG"
  [ "$status" -ne 0 ]
}
