#!/usr/bin/env bats

setup() {
  export CI="true"
  export SCRIPT_THEM="/etc/wptt/domain/wptt-themwebsite"
  export SCRIPT_XOA="/etc/wptt/domain/wptt-xoa-website"
  
  chmod +x "$SCRIPT_THEM" 2>/dev/null || true
  chmod +x "$SCRIPT_XOA" 2>/dev/null || true
}

in_log_neu_loi() {
  local ma_ky_vong="$1"
  if [ "$status" -ne "$ma_ky_vong" ]; then
      echo -e "\n[LỖI TEST] Kịch bản không trả về mã $ma_ky_vong như kỳ vọng!" >&3
      echo "Mã trạng thái thực tế : $status" >&3
      echo -e "Nội dung in ra màn hình:\n$output" >&3
  fi
}


# =================================================================
# NHÓM 1: KIỂM THỬ BỘ LỌC ĐẦU VÀO & BẢO VỆ (VALIDATION)
# =================================================================

@test "Integration: Chặn lệnh xóa với Tên miền không hợp lệ / không tồn tại" {
  # Test với domain gõ linh tinh không có dấu chấm
  run bash "$SCRIPT_XOA" "khong-co-dau-cham"

	in_log_neu_loi 1
	[ "$status" -eq 1 ]
	[[ "$output" =~ "không tồn tại" ]]

  # Test với domain gõ đúng chuẩn nhưng chưa được cài đặt
  run bash "$SCRIPT_XOA" "website-khong-ton-tai.com"
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không tồn tại" ]]
}

# =================================================================
# NHÓM 2: KIỂM THỬ THỰC CHIẾN - TẠO VÀ XÓA SẠCH SẼ (TEARDOWN)
# =================================================================

@test "Integration: XÓA SẠCH SẼ toàn bộ dữ liệu của một Website" {
  local TEST_DOMAIN="website-demo.com"

  # 1. TIỀN ĐIỀU KIỆN (PREPARE): Thêm mới website để có dữ liệu mà xóa
  run bash "$SCRIPT_THEM" "$TEST_DOMAIN"
	in_log_neu_loi 0
  [ "$status" -eq 0 ]
  # Đảm bảo "nạn nhân" đã thực sự được tạo ra trên ổ cứng
  [ -d "/usr/local/lsws/$TEST_DOMAIN" ] 

  # 2. HÀNH ĐỘNG (ACTION): Gọi kịch bản tiêu diệt
  run bash "$SCRIPT_XOA" "$TEST_DOMAIN"
	in_log_neu_loi 0

  [ "$status" -eq 0 ]

  # 3. KIỂM CHỨNG (ASSERT 1): Thư mục Home của user PHẢI BỊ XÓA (Toàn bộ source code/HTML)
  # [ ! -d ... ] có nghĩa là "Thư mục này KHÔNG CÒN tồn tại"
  [ ! -d "/usr/local/lsws/$TEST_DOMAIN" ]

  # 4. KIỂM CHỨNG (ASSERT 2): File cấu hình Vhost PHẢI BỊ XÓA
  [ ! -f "/usr/local/lsws/conf/vhosts/$TEST_DOMAIN/$TEST_DOMAIN.conf" ]

  # 5. KIỂM CHỨNG (ASSERT 3): Thư mục chứa Vhost PHẢI BỊ XÓA
  [ ! -d "/usr/local/lsws/conf/vhosts/$TEST_DOMAIN" ]

  # 6. KIỂM CHỨNG (ASSERT 4): Domain PHẢI BỊ GỠ KHỎI file httpd_config.conf chính của OLS
  run grep "$TEST_DOMAIN" /usr/local/lsws/conf/httpd_config.conf
  # Trạng thái grep trả về 1 khi KHÔNG tìm thấy kết quả (chứng tỏ đã xóa sạch)
  [ "$status" -eq 1 ]
}
