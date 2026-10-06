#!/usr/bin/env bats
#
# Kiểm thử tích hợp: Tính năng Tạm Khóa / Mở Khóa Domain (WPTangToc OLS)
# Đảm bảo tính toàn vẹn của mã nguồn (chmod 000) và cú pháp cấu hình OLS.
#

setup_file() {
  export TEST_DOMAIN="lock-test-auto-bat-tat-domain.com"
  export SCRIPT_THEM="/etc/wptt/domain/wptt-themwebsite"
  export SCRIPT_XOA="/etc/wptt/domain/wptt-xoawebsite"
  export SCRIPT_MOKHOA="/etc/wptt/domain/wptt-bat-tat-domain"

  # 1. TIỀN ĐIỀU KIỆN: Tạo một website mồi để test
  bash "$SCRIPT_THEM" "$TEST_DOMAIN" >/dev/null 2>&1 || true

  # 2. Tạo một file index mồi để check quyền truy cập
  echo "WEBSITE IS ALIVE" > "/usr/local/lsws/$TEST_DOMAIN/html/index.html"
  
  # Restart OLS để nạp Vhost mới
  /usr/local/lsws/bin/lswsctrl restart >/dev/null 2>&1 || true
  sleep 2
}

teardown_file() {
  # Dọn dẹp: BẮT BUỘC phải "Mở khóa" trước khi xóa, nếu không script xóa sẽ báo lỗi vì không có quyền (chmod 000)
  bash "$SCRIPT_MOKHOA" "$TEST_DOMAIN" on >/dev/null 2>&1 || true
  
  if [ -x "$SCRIPT_XOA" ]; then
      echo -e "y\ny\n" | bash "$SCRIPT_XOA" "$TEST_DOMAIN" >/dev/null 2>&1 || true
  fi
}

# --- HÀM GỠ LỖI ---
in_log_neu_loi() {
  local ma_ky_vong="$1"
  if [ "$status" -ne "$ma_ky_vong" ]; then
      echo -e "\n[LỖI TEST] Kịch bản không trả về mã $ma_ky_vong như kỳ vọng!" >&3
      echo "Mã trạng thái thực tế : $status" >&3
      echo -e "Nội dung output:\n$output" >&3
  fi
}

# =================================================================
# NHÓM 1: KIỂM THỬ LUỒNG TẠM KHÓA (LOCK - OFF)
# =================================================================

@test "Domain Lock: TẠM KHÓA website và Đóng băng mã nguồn (chmod 000)" {
  # 1. Thực thi lệnh Khóa (CLI Mode)
  run bash "$SCRIPT_MOKHOA" "$TEST_DOMAIN" off
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "TẠM KHÓA cho $TEST_DOMAIN" ]]

  # 2. KIỂM CHỨNG CẤU HÌNH OLS (Đã bị vô hiệu hóa)
  # - File conf phải bị đổi đuôi
  [ -f "/usr/local/lsws/conf/vhosts/$TEST_DOMAIN/$TEST_DOMAIN.conf.bkwptt" ]
  [ ! -f "/usr/local/lsws/conf/vhosts/$TEST_DOMAIN/$TEST_DOMAIN.conf" ]
  
  # - httpd_config.conf phải bị gắn prefix #bkwptt_
  run grep "^#bkwptt_virtualhost $TEST_DOMAIN" /usr/local/lsws/conf/httpd_config.conf
  [ "$status" -eq 0 ]

  # 3. KIỂM CHỨNG BẢO MẬT (Chmod 000 và Root Ownership)
  local HTML_DIR="/usr/local/lsws/$TEST_DOMAIN/html"
  
  # Lấy quyền (octal) và chủ sở hữu
  local PERMS=$(stat -c "%a" "$HTML_DIR")
  local OWNER=$(stat -c "%U" "$HTML_DIR")
  
  if [[ "$PERMS" != "0" && "$PERMS" != "000" ]]; then
      echo -e "\n[LỖI BẢO MẬT] Thư mục mã nguồn chưa bị khóa quyền 000! Quyền hiện tại: $PERMS" >&3
      false
  fi
  
  if [[ "$OWNER" != "root" ]]; then
      echo -e "\n[LỖI BẢO MẬT] Thư mục mã nguồn chưa được chuyển cho Root! Owner hiện tại: $OWNER" >&3
      false
  fi

  # 4. CHỐT CHẶN CÚ PHÁP: Việc dùng 'sed' comment out cấu hình TUYỆT ĐỐI KHÔNG ĐƯỢC làm hỏng file OLS
  run /usr/local/lsws/bin/openlitespeed -t
  if [ "$status" -ne 0 ]; then
      echo -e "\n=== [LỖI CRITICAL] SCRIPT KHÓA DOMAIN ĐÃ LÀM HỎNG CÚ PHÁP OLS ===" >&3
      echo "$output" >&3
      false
  fi
}

# =================================================================
# NHÓM 2: KIỂM THỬ LUỒNG MỞ KHÓA (UNLOCK - ON)
# =================================================================

@test "Domain Unlock: MỞ KHÓA website và Phục hồi quyền truy cập (chmod 755)" {
  # 1. Thực thi lệnh Mở Khóa (CLI Mode)
  run bash "$SCRIPT_MOKHOA" "$TEST_DOMAIN" on
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "MỞ KHÓA cho $TEST_DOMAIN" ]]

  # 2. KIỂM CHỨNG CẤU HÌNH OLS (Đã được khôi phục)
  # - File conf phải trở về bình thường
  [ -f "/usr/local/lsws/conf/vhosts/$TEST_DOMAIN/$TEST_DOMAIN.conf" ]
  [ ! -f "/usr/local/lsws/conf/vhosts/$TEST_DOMAIN/$TEST_DOMAIN.conf.bkwptt" ]
  
  # - Dấu #bkwptt_ trong httpd_config.conf phải bị xóa sạch (grep sẽ thất bại trả về 1)
  run grep "^#bkwptt_virtualhost $TEST_DOMAIN" /usr/local/lsws/conf/httpd_config.conf
  [ "$status" -eq 1 ]

  # 3. KIỂM CHỨNG BẢO MẬT (Rã đông mã nguồn)
  local HTML_DIR="/usr/local/lsws/$TEST_DOMAIN/html"
  
  # Lấy quyền (octal) và chủ sở hữu
  local PERMS=$(stat -c "%a" "$HTML_DIR")
  local OWNER=$(stat -c "%U" "$HTML_DIR")
  
  if [[ "$PERMS" != "755" ]]; then
      echo -e "\n[LỖI PHỤC HỒI] Thư mục mã nguồn chưa được trả về quyền 755! Quyền hiện tại: $PERMS" >&3
      false
  fi
  
  if [[ "$OWNER" == "root" ]]; then
      echo -e "\n[LỖI PHỤC HỒI] Thư mục mã nguồn vẫn đang bị Root giam giữ!" >&3
      false
  fi

  # 4. CHỐT CHẶN CÚ PHÁP: Quá trình khôi phục bằng 'sed' không sinh ra lỗi
  run /usr/local/lsws/bin/openlitespeed -t
  if [ "$status" -ne 0 ]; then
      echo -e "\n=== [LỖI CRITICAL] SCRIPT MỞ KHÓA ĐÃ LÀM HỎNG CÚ PHÁP OLS ===" >&3
      echo "$output" >&3
      false
  fi
}

# =================================================================
# NHÓM 3: BẪY LỖI & MASS ACTION (THAO TÁC HÀNG LOẠT)
# =================================================================

@test "Domain Mass Action: Tạm Khóa TOÀN BỘ hệ thống (all off) không gây lỗi cú pháp" {
  # Bắn lệnh khóa toàn bộ
  run bash "$SCRIPT_MOKHOA" all off
  [ "$status" -eq 0 ]
  
  # OLS vẫn phải Sống (Syntax OK) dù tất cả Vhosts bị comment out
  run /usr/local/lsws/bin/openlitespeed -t
  [ "$status" -eq 0 ]
}

@test "Domain Mass Action: Mở Khóa TOÀN BỘ hệ thống (all on) khôi phục an toàn" {
  # Bắn lệnh mở khóa toàn bộ
  run bash "$SCRIPT_MOKHOA" all on
  [ "$status" -eq 0 ]
  
  # Cú pháp OLS phải hoàn hảo
  run /usr/local/lsws/bin/openlitespeed -t
  [ "$status" -eq 0 ]
}
