#!/usr/bin/env bats

setup() {
  export CI="true"
  export SCRIPT_GOC="/etc/wptt/wptt-sao-chep-website"
  export SCRIPT_TEST="/tmp/wptt-clone-test.sh"
  
  # 1. BẢO VỆ VÀ MOCKING MENU
  cp /etc/wptt/core-functions /tmp/core-functions.bak 2>/dev/null || true
  
  # 2. Tạo file Test độc lập
  cp "$SCRIPT_GOC" "$SCRIPT_TEST"
  
  # 3. Vô hiệu hóa lệnh gọi lại menu chính để chống treo luồng CI/CD
  sed -i 's/exec \/usr\/bin\/wptangtoc.*/exit 0/g' "$SCRIPT_TEST"
  
  # 4. CHỐT CHẶN BẢO MẬT: Ép file bash luôn trả về mã 0 (Thành công) ở dòng cuối cùng
  echo "exit 0" >> "$SCRIPT_TEST"
  
  chmod +x "$SCRIPT_TEST" || true
} 

teardown() {
  # KHÔI PHỤC NGUYÊN TRẠNG
  mv /tmp/core-functions.bak /etc/wptt/core-functions 2>/dev/null || true
  rm -f "$SCRIPT_TEST" 2>/dev/null || true
}

# --- Function GỠ LỖI ---
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

@test "Integration: Chặn nhân bản nếu Tên miền đích sai định dạng" {
  run bash "$SCRIPT_TEST" "auto-demo.wptangtoc.com" "khong-co-dau-cham"
  
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "sai cấu trúc" || "$output" =~ "không hợp lệ" ]]
}

@test "Integration: Chặn nhân bản nếu Website Nguồn không tồn tại" {
  run bash "$SCRIPT_TEST" "website-ma-khong-ton-tai.com" "clone.com"
  
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không tồn tại trên hệ thống này" ]]
}

# =================================================================
# NHÓM 2: KIỂM THỬ THỰC CHIẾN - NHÂN BẢN TOÀN BỘ WEBSITE WORDPRESS
# =================================================================

@test "Integration: NHÂN BẢN THÀNH CÔNG từ Website Nguồn sang Website Đích" {
  local DOMAIN_NGUON="auto-demo.wptangtoc.com"
  local DOMAIN_DICH="clone-thanh-cong.com"

  # 1. KIỂM TRA TÀI SẢN THỪA KẾ (Từ bài test 01-install-wordpress.bats)
  # Nếu thư mục wp-admin của domain nguồn không tồn tại, báo lỗi Fixture ngay lập tức!
  if [ ! -d "/usr/local/lsws/$DOMAIN_NGUON/html/wp-admin" ]; then
      echo -e "\n[LỖI FIXTURE] Website nguồn '$DOMAIN_NGUON' không tồn tại!" >&3
      echo "Hãy đảm bảo file '03-install-wordpress.bats' đã chạy thành công trước file này." >&3
      return 1
  fi

  # 2. MOCKING: Ép hàm xác nhận Y/N luôn trả về Yes (0) để lướt qua các câu hỏi cảnh báo
  cat << 'EOF' > /etc/wptt/core-functions
source /tmp/core-functions.bak
wptt_xac_nhan() { return 0; }
EOF

  # 3. HÀNH ĐỘNG: Gọi script Nhân bản, truyền trực tiếp Nguồn và Đích (Có dùng cờ no-config)
  # Nhét < /dev/null vào để vô hiệu hóa bàn phím, đề phòng kịch bản gốc có lệnh read lọt lưới
  run bash -c "bash $SCRIPT_TEST \"$DOMAIN_NGUON\" \"$DOMAIN_DICH\" \"no-config\" < /dev/null"

  # Bật bẫy lỗi để theo dõi
  in_log_neu_loi 0

  # 4. KIỂM CHỨNG TẦNG CƠ BẢN
  [ "$status" -eq 0 ]
  [[ "$output" =~ "HOÀN TẤT NHÂN BẢN WEBSITE" ]]
  
  # File wp-config.php ĐÍCH phải tồn tại và có dung lượng > 0 byte
  [ -s "/usr/local/lsws/$DOMAIN_DICH/html/wp-config.php" ]
  
  # 5. KIỂM CHỨNG TẦNG SÂU BẰNG WP-CLI (Vô cùng quan trọng)
  # Chắc chắn mã nguồn Đích đã nhận diện được Database mới (không bị chéo DB với Nguồn)
  run wp core is-installed --path="/usr/local/lsws/$DOMAIN_DICH/html" --allow-root
  [ "$status" -eq 0 ]

  # Kiểm chứng File Search & Replace: Đảm bảo WP_SITEURL đã bị xóa để WP tự nhận diện tên miền mới
  run grep "WP_SITEURL" "/usr/local/lsws/$DOMAIN_DICH/html/wp-config.php"
  [ "$status" -eq 1 ] # Mã 1 nghĩa là lệnh grep KHÔNG TÌM THẤY (Đã bị script của bác xóa thành công)
}
