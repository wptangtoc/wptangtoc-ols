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

  # 1. TIỀN ĐIỀU KIỆN (PREPARE): Thêm mới website mồi
  bash "$SCRIPT_THEM" "$TEST_DOMAIN" >/dev/null 2>&1 || true
  
  if [ ! -d "/usr/local/lsws/$TEST_DOMAIN" ]; then
      echo "[LỖI FIXTURE] Không thể tạo website mồi!" >&3
      false
  fi

  # 2. HÀNH ĐỘNG (ACTION): Gọi kịch bản tiêu diệt (Ép phím 'y' qua luồng)
  run bash -c "echo -e 'y\ny\n' | bash $SCRIPT_XOA \"$TEST_DOMAIN\""
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ]

  # 3. KIỂM CHỨNG (ASSERT): Thư mục và File cấu hình phải bay màu
  [ ! -d "/usr/local/lsws/$TEST_DOMAIN" ]
  [ ! -f "/usr/local/lsws/conf/vhosts/$TEST_DOMAIN/$TEST_DOMAIN.conf" ]
  [ ! -d "/usr/local/lsws/conf/vhosts/$TEST_DOMAIN" ]

  run grep "$TEST_DOMAIN" /usr/local/lsws/conf/httpd_config.conf
  [ "$status" -eq 1 ]

  # Kích hoạt quá trình xóa trên RAM (Bypass systemctl)
  /usr/local/lsws/bin/lswsctrl restart >/dev/null 2>&1 || true
  sleep 20
  # =================================================================
  # CHỐT CHẶN ENTERPRISE 1: KIỂM TRA CÚ PHÁP OLS
  # =================================================================
  # Đảm bảo quá trình xóa không cắt lẹm vào ngoặc } của cấu hình khác
  run /usr/local/lsws/bin/openlitespeed -t
  
  if [ "$status" -ne 0 ]; then
      echo -e "\n=== [LỖI CRITICAL] SCRIPT XÓA LÀM HỎNG CÚ PHÁP OLS ===" >&3
      echo "$output" >&3
  fi
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Syntax OK" || "$output" =~ "ok" || -z "$output" ]]

  # =================================================================
  # CHỐT CHẶN ENTERPRISE 2: CURL E2E (ĐẢM BẢO WEBSITE ĐÃ CHẾT THẬT)
  # =================================================================
  

  # Bắn Curl vào Domain vừa xóa
  local HTTP_CODE=$(curl -m 5 -sS -o /dev/null -w "%{http_code}" -H "Host: $TEST_DOMAIN" http://127.0.0.1/)
  
  # Đánh giá: Vì Vhost đã bị gỡ, OpenLiteSpeed KHÔNG ĐƯỢC PHÉP trả về mã 2xx hoặc 3xx
  if [[ "$HTTP_CODE" =~ ^[23][0-9][0-9]$ ]]; then
      echo -e "\n[LỖI E2E] Xóa ảo! Website vẫn còn sống nhăn răng (Mã HTTP: $HTTP_CODE)" >&3
      false
  fi

  echo "[PASSED] Website $TEST_DOMAIN đã bị tiêu diệt hoàn toàn khỏi hệ thống." >&3
}
