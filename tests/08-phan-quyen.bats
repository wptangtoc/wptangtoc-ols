#!/usr/bin/env bats

setup() {
  export CI="true"
  export SCRIPT_GOC="/etc/wptt/wptt-phanquyen"
  export SCRIPT_TEST="/tmp/wptt-phanquyen-test.sh"
  
  # 1. TẠO FILE NHÁP VÀ CHỐT CHẶN BASH GOTCHA
  # (Không cần sed vô hiệu hóa menu nữa vì tầng CI đã "san phẳng" chúng rồi)
  cp "$SCRIPT_GOC" "$SCRIPT_TEST"
  echo "exit 0" >> "$SCRIPT_TEST"
  chmod +x "$SCRIPT_TEST" || true
  
  # 2. MÔI TRƯỜNG GIẢ LẬP RIÊNG CHO PHÂN QUYỀN
  mkdir -p /etc/wptt/tmp
  mkdir -p /etc/wptt/php
  if [ ! -f "/etc/wptt/php/php-cli-domain-config" ]; then
      echo 'phien_ban_php_domain_thuc_thi="83"' > /etc/wptt/php/php-cli-domain-config
      echo 'return 0' >> /etc/wptt/php/php-cli-domain-config
  fi
}

teardown() {
  # Dọn dẹp chiến trường
  rm -f "$SCRIPT_TEST" 2>/dev/null || true
  rm -rf "/usr/local/lsws/test-pq-normal.com" 2>/dev/null || true
  rm -rf "/usr/local/lsws/test-pq-lockdown.com" 2>/dev/null || true
  rm -f "/etc/wptt/vhost/.test-pq-normal.com.conf" 2>/dev/null || true
  rm -f "/etc/wptt/vhost/.test-pq-lockdown.com.conf" 2>/dev/null || true
}

# --- HÀM VŨ KHÍ GỠ LỖI ---
in_log_neu_loi() {
  local ma_ky_vong="$1"
  if [ "$status" -ne "$ma_ky_vong" ]; then
      echo -e "\n[LỖI TEST] Kịch bản không trả về mã $ma_ky_vong như kỳ vọng!" >&3
      echo "Mã trạng thái thực tế : $status" >&3
      echo -e "Nội dung in ra màn hình:\n$output" >&3
  fi
}

# =================================================================
# NHÓM 1: KIỂM THỬ LỖI ĐẦU VÀO
# =================================================================

@test "Integration: Chặn phân quyền nếu Website không tồn tại" {
  run bash "$SCRIPT_TEST" "domain-khong-ton-tai.com"
  
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không tồn tại trên hệ thống" ]]
}

# =================================================================
# NHÓM 2: KIỂM THỬ THỰC CHIẾN BẢO MẬT (CHMOD / CHOWN)
# =================================================================

@test "Integration: Phân quyền CHẾ ĐỘ THƯỜNG (Normal Mode) & Diệt SetUID" {
  local DOMAIN="test-pq-normal.com"

  # 1. FIXTURE: Cấu hình Vhost giả
  echo "User_name_vhost=nobody" > "/etc/wptt/vhost/.$DOMAIN.conf"
  
  # 2. FIXTURE: Tạo cây thư mục rác với quyền nguy hiểm (777) và quyền SetUID (4777)
  mkdir -p "/usr/local/lsws/$DOMAIN/html"
  touch "/usr/local/lsws/$DOMAIN/html/wp-config.php"
  touch "/usr/local/lsws/$DOMAIN/html/index.php"
  touch "/usr/local/lsws/$DOMAIN/html/file-thuong.php"
  chmod 777 "/usr/local/lsws/$DOMAIN/html/"*
  
  touch "/usr/local/lsws/$DOMAIN/html/hacker.php"
  chmod 4777 "/usr/local/lsws/$DOMAIN/html/hacker.php"

  # 3. HÀNH ĐỘNG
  run bash "$SCRIPT_TEST" "$DOMAIN"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  
  # 4. KIỂM CHỨNG BẢO MẬT
  [ "$(stat -c "%a" "/usr/local/lsws/$DOMAIN/html/wp-config.php")" -eq 600 ]
  [ "$(stat -c "%a" "/usr/local/lsws/$DOMAIN/html/index.php")" -eq 444 ]
  [ "$(stat -c "%a" "/usr/local/lsws/$DOMAIN/html/file-thuong.php")" -eq 644 ]
  
  run stat -c "%A" "/usr/local/lsws/$DOMAIN/html/hacker.php"
  [[ ! "$output" =~ "s" ]]
}

@test "Integration: Phân quyền CHẾ ĐỘ THIẾT QUÂN LUẬT (Lockdown Mode)" {
  local DOMAIN="test-pq-lockdown.com"

  # 1. FIXTURE: Bơm cờ lock_down vào file cấu hình
  echo -e "User_name_vhost=nobody\nlock_down=1" > "/etc/wptt/vhost/.$DOMAIN.conf"
  
  mkdir -p "/usr/local/lsws/$DOMAIN/html"
  touch "/usr/local/lsws/$DOMAIN/html/wp-config.php"
  touch "/usr/local/lsws/$DOMAIN/html/index.php"
  touch "/usr/local/lsws/$DOMAIN/html/file-thuong.php"
  chmod 777 "/usr/local/lsws/$DOMAIN/html/"*

  # 2. HÀNH ĐỘNG
  run bash "$SCRIPT_TEST" "$DOMAIN"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  
  # 3. KIỂM CHỨNG CHUẨN LOCKDOWN
  [ "$(stat -c "%a" "/usr/local/lsws/$DOMAIN/html/wp-config.php")" -eq 400 ]
  [ "$(stat -c "%a" "/usr/local/lsws/$DOMAIN/html/file-thuong.php")" -eq 404 ]
  [ "$(stat -c "%a" "/usr/local/lsws/$DOMAIN/html")" -eq 515 ]
}

@test "Integration: Test vòng lặp Tất cả website" {
  run bash "$SCRIPT_TEST" "Tất cả website"
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "DASHBOARD THAO TÁC HÀNG LOẠT" || "$output" =~ "Phân quyền toàn bộ website" ]]
}
