#!/usr/bin/env bats

setup() {
  export CI="true"
  export SCRIPT_GOC="/etc/wptt/wptt-phanquyen"
  export SCRIPT_TEST="/tmp/wptt-phanquyen-test.sh"
  
  # 1. TẠO FILE NHÁP VÀ CHỐT CHẶN BASH GOTCHA
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


@test "Integration: Chặn phân quyền nếu Website không tồn tại" {
  run bash "$SCRIPT_TEST" "domain-khong-ton-tai.com"
  
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không tồn tại trên hệ thống" ]]
}


@test "Integration: Phân quyền Website đơn lẻ và xác minh tính chính xác (github.wptangtoc.com)" {
  local domain="github.wptangtoc.com"
  local doc_root="/usr/local/lsws/$domain/html"

  # Bỏ qua test nếu domain chưa được tạo (Tránh gây lỗi trên môi trường CI trắng)
  if [ ! -d "$doc_root" ]; then
    skip "Website $domain chưa tồn tại để test phân quyền."
  fi

  # Lấy thông tin user chuẩn của thư mục
  local vhost_user
  vhost_user=$(stat -c '%U' "$doc_root")

  # 1. TIÊM LỖI (SABOTAGE): Cố tình làm sai phân quyền và chủ sở hữu
  local test_file="$doc_root/index_test_bats.php"
  local test_dir="$doc_root/dir_test_bats"
  
  touch "$test_file"
  mkdir -p "$test_dir"
  
  # Gán quyền sai bét nhè (777) và chủ sở hữu là root thay vì vhost_user
  chmod 777 "$test_file" "$test_dir"
  chown root:root "$test_file" "$test_dir"

  # Chốt chặn kiểm tra: Đảm bảo tiêm lỗi thành công trước khi test
  [ "$(stat -c '%U' "$test_file")" == "root" ]
  [ "$(stat -c '%a' "$test_file")" == "777" ]

  # 2. CHẠY SCRIPT PHÂN QUYỀN
  run bash "$SCRIPT_TEST" "$domain"
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  
  # 3. KIỂM TRA LẠI (ASSERTIONS)
  # 3.1. Kịch bản phải trả lại đúng user của website
  local new_file_owner
  new_file_owner=$(stat -c '%U' "$test_file")
  [ "$new_file_owner" == "$vhost_user" ]

  local new_dir_owner
  new_dir_owner=$(stat -c '%U' "$test_dir")
  [ "$new_dir_owner" == "$vhost_user" ]

  # 3.2. Kịch bản phải thiết lập lại quyền chuẩn bảo mật (644 cho file, 755 cho folder)
  local new_file_perm
  new_file_perm=$(stat -c '%a' "$test_file")
  [ "$new_file_perm" == "644" ]

  local new_dir_perm
  new_dir_perm=$(stat -c '%a' "$test_dir")
  [ "$new_dir_perm" == "755" ]

  # 4. DỌN DẸP
  rm -rf "$test_file" "$test_dir"
}

@test "Integration: Test vòng lặp Tất cả website phân quyền toàn bộ" {
  run bash "$SCRIPT_TEST" "Tất cả website"
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "DASHBOARD THAO TÁC HÀNG LOẠT" || "$output" =~ "Phân quyền toàn bộ website" ]]
}
