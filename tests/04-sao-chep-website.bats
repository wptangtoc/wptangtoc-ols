#!/usr/bin/env bats

setup() {
  export CI="true"
  export SCRIPT_GOC="/etc/wptt/wptt-sao-chep-website"
  export SCRIPT_TEST="/tmp/wptt-sao-chep-website-test.sh"
  
  # Tạo file Test độc lập
  cp "$SCRIPT_GOC" "$SCRIPT_TEST"
  echo "exit 0" >> "$SCRIPT_TEST"
  chmod +x "$SCRIPT_TEST" || true
}

teardown() {
  rm -f "$SCRIPT_TEST" 2>/dev/null || true
  # Dọn dẹp website mồi nếu có
  bash /etc/wptt/domain/wptt-xoa-website "nguon-sao-chep.com" >/dev/null 2>&1 || true
  bash /etc/wptt/domain/wptt-xoa-website "dich-sao-chep.com" >/dev/null 2>&1 || true
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
# KIỂM THỬ NGOẠI LỆ (EXCEPTIONS)
# =================================================================

@test "Integration: Chặn nhân bản nếu Website Nguồn không tồn tại" {
  run bash "$SCRIPT_TEST" "domain-khong-ton-tai.com" "dich.com"
  
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không tồn tại trên hệ thống" ]]
}

@test "Integration: Chặn nhân bản nếu Tên miền đích sai định dạng" {
  # FIX: Phải tạo mồi website Nguồn tồn tại thật, thì script mới chịu check tiếp tên đích!
  export SCRIPT_THEM="/etc/wptt/domain/wptt-themwebsite"
  bash "$SCRIPT_THEM" "nguon-sao-chep.com" >/dev/null 2>&1 || true

  run bash "$SCRIPT_TEST" "nguon-sao-chep.com" "dich-sai-dinh-dang"
  
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không đúng định dạng" || "$output" =~ "sai cấu trúc" ]]
}

# =================================================================
# KIỂM THỬ THỰC CHIẾN SAO CHÉP
# =================================================================

@test "Integration: NHÂN BẢN THÀNH CÔNG từ Website Nguồn sang Website Đích" {
  local DOMAIN_NGUON="nguon-sao-chep.com"
  local DOMAIN_DICH="dich-sao-chep.com"

  # 1. FIXTURE: Tự tạo website mồi độc lập, không phụ thuộc vào file 03
  export SCRIPT_THEM="/etc/wptt/domain/wptt-themwebsite"
  bash "$SCRIPT_THEM" "$DOMAIN_NGUON" >/dev/null 2>&1 || true

  # Đổ một ít file "rác" vào thư mục Nguồn để kiểm chứng khả năng copy
  echo "Day la file wp-config test" > "/usr/local/lsws/$DOMAIN_NGUON/html/wp-config.php"

  # 2. HÀNH ĐỘNG
  run bash "$SCRIPT_TEST" "$DOMAIN_NGUON" "$DOMAIN_DICH"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  
  # 3. KIỂM CHỨNG
  # Kiểm tra website đích đã được tạo
  [ -d "/usr/local/lsws/$DOMAIN_DICH/html" ]
  
  # Kiểm tra file đã được copy sang
  [ -f "/usr/local/lsws/$DOMAIN_DICH/html/wp-config.php" ]
  
  # Dọn dẹp nhanh
  rm -rf "/usr/local/lsws/$DOMAIN_NGUON"
  rm -rf "/usr/local/lsws/$DOMAIN_DICH"
}
