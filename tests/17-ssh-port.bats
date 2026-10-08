#!/usr/bin/env bats

setup() {
  # 1. [ENTERPRISE FIX]: Giả lập (Mock) TOÀN BỘ các lệnh nguy hiểm gây mất mạng CI/CD
  mkdir -p /tmp/mock_bin

  # Ép systemctl trả về 0 để lọt qua các bài check điều kiện
  echo -e '#!/bin/bash\nexit 0' >/tmp/mock_bin/systemctl

  # Khóa mỏm tường lửa: Ngăn firewall-cmd, csf, fail2ban flush mạng của GitHub Actions
  echo -e '#!/bin/bash\nexit 0' >/tmp/mock_bin/firewall-cmd
  echo -e '#!/bin/bash\nexit 0' >/tmp/mock_bin/csf
  echo -e '#!/bin/bash\nexit 0' >/tmp/mock_bin/fail2ban-client
  echo -e '#!/bin/bash\nexit 0' >/tmp/mock_bin/semanage

  chmod +x /tmp/mock_bin/*
  export PATH="/tmp/mock_bin:$PATH"

  # 2. Sinh Host Keys ảo để vượt qua bài test cú pháp sshd -t
  ssh-keygen -A >/dev/null 2>&1 || true

  # 3. Sao lưu cấu hình gốc (Backup đa tầng)
  cp -p /etc/ssh/sshd_config /tmp/sshd_config.bats.bak
  cp -p /etc/wptt/.wptt.conf /tmp/wptt.conf.bats.bak 2>/dev/null || true

  # 4. Đặt cấu hình chuẩn để test (Đưa về Port 22)
  sed -i '/^[[:space:]]*#\?[[:space:]]*Port[[:space:]]/d' /etc/ssh/sshd_config
  echo "Port 22" >>/etc/ssh/sshd_config

  # 5. Dọn dẹp rác nháp cũ nếu có
  rm -rf /etc/wptt/tmp/ssh_port.* 2>/dev/null || true
}

teardown() {
  # 1. Phục hồi cấu hình gốc chính xác tới từng byte
  mv -f /tmp/sshd_config.bats.bak /etc/ssh/sshd_config
  if [ -f "/tmp/wptt.conf.bats.bak" ]; then
    mv -f /tmp/wptt.conf.bats.bak /etc/wptt/.wptt.conf
  fi

  # 2. Gỡ bỏ Mount giả lập (Nếu có dùng trong test Fail-Safe)
  if mount | grep -q "/usr/sbin/sshd"; then
    umount /usr/sbin/sshd 2>/dev/null || true
  fi
  rm -rf /tmp/mock_sshd 2>/dev/null || true

  # 3. Gỡ bỏ lớp Mock (Trả lại quyền điều khiển cho lệnh hệ thống gốc)
  rm -rf /tmp/mock_bin 2>/dev/null || true

  # 4. [QUAN TRỌNG] Ép dịch vụ SSH thật khởi động lại với cấu hình đã khôi phục (Port gốc)
  # Dùng đường dẫn tuyệt đối /bin/systemctl để chắc chắn không gọi nhầm file giả lập
  /bin/systemctl restart sshd 2>/dev/null || /usr/bin/systemctl restart sshd 2>/dev/null || true

  # 5. Dọn dẹp rác nháp của kịch bản
  rm -rf /etc/wptt/tmp/ssh_port.* 2>/dev/null || true
}

# ==============================================================================
# NHÓM KIỂM THỬ 1: RÀ SOÁT TÍNH TOÀN VẸN DỮ LIỆU ĐẦU VÀO (VALIDATION)
# ==============================================================================

@test "[Validation] Từ chối Port chứa chữ cái hoặc ký tự đặc biệt" {
  run bash /etc/wptt/ssh/wptt-ssh-port "22abc"
  [ "$status" -eq 1 ]
  [[ "$output" == *"không hợp lệ"* ]]
}

@test "[Validation] Từ chối Port nằm ngoài không gian cho phép (1-65535)" {
  run bash /etc/wptt/ssh/wptt-ssh-port "99999"
  [ "$status" -eq 1 ]
  [[ "$output" == *"không hợp lệ"* ]]
}

@test "[Validation] Khóa cứng bảo vệ các Port mặc định của Webserver (80, 443)" {
  run bash /etc/wptt/ssh/wptt-ssh-port "443"
  [ "$status" -eq 1 ]
  [[ "$output" == *"đang được sử dụng bởi hệ thống Webserver"* ]]
}

@test "[Validation] Hủy tiến trình nếu Port mới trùng Port hiện tại" {
  run bash /etc/wptt/ssh/wptt-ssh-port "22"
  [ "$status" -eq 1 ]
  [[ "$output" == *"đang được sử dụng bởi hệ thống Webserver"* ]]
}

# ==============================================================================
# NHÓM KIỂM THỬ 2: GIAO DỊCH NGUYÊN TỬ VÀ KHẢ NĂNG TỰ CHỮA LÀNH
# ==============================================================================

@test "[Enterprise] Thực thi đổi Port atomic và dọn dẹp Workspace tự động" {
  # Bơm chuỗi "1" qua stdin để tự động pass qua hàm wptt_xac_nhan
  run bash /etc/wptt/ssh/wptt-ssh-port 22222 <<<"1"

  # --- ĐOẠN DEBUG (IN LOG NẾU LỖI ĐỂ TÌM NGUYÊN NHÂN TRÊN GITHUB ACTIONS) ---
  if [ "$status" -ne 0 ]; then
    echo -e "\n=== 🚨 DỮ LIỆU DEBUG (OUTPUT CỦA SCRIPT) ===" >&3
    echo "$output" >&3
    echo -e "=============================================\n" >&3
  fi
  # -----------------------------------

  # Kịch bản phải trả về status 0 (Thành công hoàn toàn)
  [ "$status" -eq 0 ]

  # Xác thực Inode: File sshd_config phải chứa cấu hình Port 22222
  run grep -E "^Port 22222" /etc/ssh/sshd_config
  [ "$status" -eq 0 ]

  # Xác thực Cleanup: Bẫy trap EXIT phải xóa sạch thư mục tạm
  run ls -d /etc/wptt/tmp/ssh_port.*
  [ "$status" -ne 0 ] # Phải văng lỗi vì không được phép còn file nào tồn tại
}

@test "[Fail-Safe] Bắt buộc Rollback khi file cấu hình nháp không vượt qua Syntax Check" {
  # Tấn công giả lập: Đánh lừa đường dẫn tuyệt đối /usr/sbin/sshd bằng mount --bind
  # để ép lệnh `sshd -t` luôn trả về mã lỗi 1 (Crash giả).
  mkdir -p /tmp/mock_sshd
  cat <<'EOF' >/tmp/mock_sshd/sshd_fake
#!/bin/bash
# Nếu gọi cờ -t (test syntax), ép văng lỗi
if [[ "$*" == *"-t"* ]]; then
  exit 1 
fi
EOF
  chmod +x /tmp/mock_sshd/sshd_fake
  mount --bind /tmp/mock_sshd/sshd_fake /usr/sbin/sshd

  # Khởi chạy script đổi sang cổng 33333
  run bash /etc/wptt/ssh/wptt-ssh-port 33333 <<<"1"

  # Tháo mount giả lập ngay lập tức để trả lại hệ thống
  umount /usr/sbin/sshd

  # Kịch bản phải phát hiện lỗi và ép dừng khẩn cấp (Exit 1)
  [ "$status" -eq 1 ]

  # Giao diện phải in ra cảnh báo Rollback
  [[ "$output" == *"Lỗi cú pháp bị phát hiện trên file tạm"* ]]

  # Xác thực Zero-Trust: File sshd_config gốc tuyệt đối không được suy xuyển (Vẫn giữ Port 22)
  run grep -E "^Port 22" /etc/ssh/sshd_config
  [ "$status" -eq 0 ]

  # Cổng 33333 không được phép xuất hiện trong file gốc
  run grep -q "33333" /etc/ssh/sshd_config
  [ "$status" -ne 0 ]
}
