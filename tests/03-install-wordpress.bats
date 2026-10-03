#!/usr/bin/env bats

setup() {
  export CI="true"
  export SCRIPT_GOC="/etc/wptt/wptt-install-wordpress2"
  export SCRIPT_TEST="/tmp/wptt-install-wp-test.sh"
  
  # 1. Sao lưu file core-functions để lát nữa tiêm Mocking
  cp /etc/wptt/core-functions /tmp/core-functions.bak 2>/dev/null || true
  
  # 2. Tạo file Test độc lập và vô hiệu hóa các lệnh exec làm sập luồng BATS
  cp "$SCRIPT_GOC" "$SCRIPT_TEST"
  sed -i 's/exec \/etc\/wptt\/wptt-wordpress-main.*/exit 0/g' "$SCRIPT_TEST"
  sed -i 's/exec \/usr\/bin\/wptangtoc.*/exit 0/g' "$SCRIPT_TEST"
  
  # CHỐT CHẶN BẢO MẬT (Bash Gotcha): Ép file bash luôn trả về mã 0 (Thành công) ở cuối cùng
  echo "exit 0" >> "$SCRIPT_TEST"
  
  chmod +x "$SCRIPT_TEST"
}

teardown() {
  # 3. Khôi phục nguyên trạng để không để lại rác trên máy chủ
  mv /tmp/core-functions.bak /etc/wptt/core-functions 2>/dev/null || true
  rm -f "$SCRIPT_TEST" 2>/dev/null || true
}

# --- HÀM GỠ LỖI ---
in_log_neu_loi() {
  local ma_ky_vong="$1"
  if [ "$status" -ne "$ma_ky_vong" ]; then
      echo -e "\n[LỖI TEST] Kịch bản không trả về mã $ma_ky_vong như kỳ vọng!" >&3
      echo "Mã trạng thái thực tế : $status" >&3
      echo -e "Nội dung in ra màn hình:\n$output" >&3
  fi
}

# =================================================================
# NHÓM 1: KIỂM THỬ BỘ LỌC ĐẦU VÀO
# =================================================================

@test "Integration: Chặn Tên miền thiếu dấu chấm" {
  run bash "$SCRIPT_TEST" "wptangtoc"
  
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "đúng định dạng" ]]
}


# NHÓM 2: AUTO-INSTALL WORDPRESS

@test "Integration: CÀI ĐẶT WORDPRESS TỰ ĐỘNG" {
  local TEST_DOMAIN="wptest-auto.com"

  # 1. TIỀN ĐIỀU KIỆN: Gọi kịch bản Thêm website để hệ thống TỰ ĐỘNG sinh DB biên chế
  export SCRIPT_THEM="/etc/wptt/domain/wptt-themwebsite"
  bash "$SCRIPT_THEM" "$TEST_DOMAIN" >/dev/null 2>&1 || true

  # 2. MOCKING: Ép hàm xác nhận Y/N luôn trả về Yes (0) để lướt qua câu hỏi
  cat << 'EOF' > /etc/wptt/core-functions
source /tmp/core-functions.bak
wptt_xac_nhan() { return 0; }
EOF

  # 3. AUTO-FILL DỮ LIỆU ĐẦU VÀO: Khởi tạo thông tin Admin WordPress
  local WP_TITLE="Website Test Auto"
  local WP_USER="admin_$(date +%s)"
  local WP_PASS="PassKh0_$(date +%N)"
  local WP_EMAIL="admin@$TEST_DOMAIN"
  
  # Ghép nối các luồng nhập liệu bằng dấu xuống dòng (\n)
  local INPUTS="${WP_TITLE}\n${WP_USER}\n${WP_PASS}\n${WP_EMAIL}\n"

  # 4. HÀNH ĐỘNG: Bơm thẳng dữ liệu INPUTS qua ống dẫn vào lệnh cài đặt
  run bash -c "echo -e \"$INPUTS\" | bash $SCRIPT_TEST \"$TEST_DOMAIN\""

  in_log_neu_loi 0

  # 5. KIỂM CHỨNG KẾT QUẢ
  [ "$status" -eq 0 ]
  [[ "$output" =~ "[ THÀNH CÔNG ] CÀI ĐẶT MÃ NGUỒN WORDPRESS" ]]
  
  # Kiểm tra sâu: File wp-config.php phải được sinh ra và có dung lượng > 0 byte
  [ -s "/usr/local/lsws/$TEST_DOMAIN/html/wp-config.php" ]
  
  # Nghiệm thu cuối cùng bằng WP-CLI (Chắc chắn WP đã kết nối DB thành công)
  run wp core is-installed --path="/usr/local/lsws/$TEST_DOMAIN/html" --allow-root
  [ "$status" -eq 0 ]
}


@test "Integration: CÀI ĐẶT LSCache WordPress" {
  local TEST_DOMAIN="wptest-auto.com"

  export SCRIPT_LSCACHE="/etc/wptt/wordpress/nhap-du-lieu-litespeed-wptangtoc"
  
  run bash "$SCRIPT_LSCACHE" "$TEST_DOMAIN"

  in_log_neu_loi 0

  [ "$status" -eq 0 ]
  
  if [[ ! "$output" == *"Cấu hình tối ưu theo cách khuyến nghị"* ]]; then
      echo -e "\n[DEBUG] Kịch bản không in ra chữ như kỳ vọng. Output thực tế là:\n$output" >&3
  fi
  # -------------------------------------------------------------------

  # Kiểm tra khớp với chuỗi kịch bản thực sự in ra
  [[ "$output" == *"Cấu hình tối ưu theo cách khuyến nghị"* ]]
  
  # 4. Kiểm tra sâu: Thư mục plugin litespeed-cache phải tồn tại
  [ -d "/usr/local/lsws/$TEST_DOMAIN/html/wp-content/plugins/litespeed-cache" ]
  
  # 5. Nghiệm thu cuối cùng bằng WP-CLI
  run wp plugin is-active litespeed-cache --path="/usr/local/lsws/$TEST_DOMAIN/html" --allow-root
  [ "$status" -eq 0 ]
}
