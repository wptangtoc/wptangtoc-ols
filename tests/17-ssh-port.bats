#!/usr/bin/env bats

#test tình huống thay đổi port ssh
setup() {
  # 1. Sao lưu nguyên trạng file cấu hình gốc của hệ thống
  cp /etc/ssh/sshd_config /tmp/sshd_config.bats.bak

  # 2. Xóa các cấu hình Port nhiễu và thiết lập Port 22 làm mốc kiểm thử
  sed -i '/^[[:space:]]*#\?[[:space:]]*Port[[:space:]]/d' /etc/ssh/sshd_config
  echo "Port 22" >>/etc/ssh/sshd_config

  # 3. Đảm bảo thư mục tmp sạch sẽ trước khi test
  rm -rf /etc/wptt/tmp/ssh_port.* 2>/dev/null || true
}

teardown() {
  # 1. Rollback hệ thống về trạng thái nguyên thủy sau mỗi test case
  mv -f /tmp/sshd_config.bats.bak /etc/ssh/sshd_config

  # 2. Xóa các hàm mock hoặc unmount nếu có sử dụng trong bài test
  if mount | grep -q "/usr/sbin/sshd"; then
    umount /usr/sbin/sshd 2>/dev/null || true
  fi
  rm -rf /tmp/mock_sshd 2>/dev/null || true

  # 3. Quét và dọn dẹp rác (Đảm bảo bẫy trap EXIT của script hoạt động)
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

@test "[Enterprise] Thực thi đổi Port nguyên tử và dọn dẹp Workspace tự động" {
  # Bơm chuỗi "1" qua stdin để tự động pass qua hàm wptt_xac_nhan
  run bash /etc/wptt/ssh/wptt-ssh-port 22222 <<<"1"

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
