#!/usr/bin/env bats

setup_file() {
export CI="true"
export TEST_DOMAIN="test-yara-scan.com"
  
  echo "Đang tạo website và cài đặt WordPress mồi. Vui lòng đợi..." >&3
  
  # 1. Khởi tạo Website
bash /etc/wptt/domain/wptt-themwebsite "$TEST_DOMAIN" >/dev/null 2>&1 || true

  # 2. Cài đặt WordPress Tự động (Mô phỏng nhập liệu)
  cat <<EOF > /tmp/wp-answers-yara.txt
Website YARA Scanner
admin_yara
PassKh0_123!@#
admin@${TEST_DOMAIN}
EOF
  cat /tmp/wp-answers-yara.txt | bash /etc/wptt/wptt-install-wordpress2 "$TEST_DOMAIN" >/dev/null 2>&1 || true

  # 3. MOCKING RULE YARA: Tạo một bộ luật giả mạo chuyên dùng cho CI/CD
  mkdir -p /etc/wptt/bao-mat
  export YARA_FILE="/etc/wptt/bao-mat/wptt-scan-wp-malware.yar"
  
  # Nếu file chưa tồn tại (hoặc ghi đè luôn để test), ta cấy 1 luật phát hiện chữ "WPTT_MALWARE_SIGNATURE_123"
  cat << 'EOF' > "$YARA_FILE"
rule WPTT_Fake_Malware {
    meta:
        description = "Mã độc giả lập để test BATS CI/CD"
        author = "WPTangToc CI"
    strings:
        $malware_string = "WPTT_MALWARE_SIGNATURE_123"
    condition:
        $malware_string
}
EOF
}

teardown_file() {
  # Dọn dẹp sạch sẽ chiến trường sau khi tất cả các bài test chạy xong
  bash /etc/wptt/domain/wptt-xoa-website "test-yara-scan.com" >/dev/null 2>&1 || true
  rm -f /tmp/wp-answers-yara.txt 2>/dev/null || true
}

# =================================================================
# SETUP CHO TỪNG BÀI TEST
# =================================================================
setup() {
  export CI="true"
  export SCRIPT_GOC="/etc/wptt/bao-mat/wptt-scan-virus"
  export SCRIPT_TEST="/tmp/wptt-scan-virus-test.sh"
  export TEST_DOMAIN="test-yara-scan.com"
  
  # 1. Tạo file Test độc lập 
  cp "$SCRIPT_GOC" "$SCRIPT_TEST"
  
  # 2. Vô hiệu hóa lệnh thoát về Menu (Tránh treo luồng CI)
  sed -i 's/exec \/etc\/wptt\/wptt-bao-mat-main.*/exit 0/g' "$SCRIPT_TEST"
  
  # 3. Xóa ionice và nice phòng hờ (dù CI đã có bypass, nhưng xóa trong xargs cho chắc cốp)
  sed -i 's/nice -n 19 ionice -c 3 //g' "$SCRIPT_TEST"
  
  # 4. Chốt chặn bảo mật (Bypass Bash Gotcha)
  echo "exit 0" >> "$SCRIPT_TEST"
  chmod +x "$SCRIPT_TEST" || true
}

teardown() {
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
# NHÓM 1: KIỂM THỬ NGOẠI LỆ
# =================================================================

@test "Integration: Chặn quét nếu Website không tồn tại" {
  run bash "$SCRIPT_TEST" "domain-khong-ton-tai.com"
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ] # Kịch bản của bác dùng exit 0 khi không tìm thấy domain
  [[ "$output" =~ "Không tìm thấy cấu hình website" ]]
}

# =================================================================
# NHÓM 2: KIỂM THỬ THỰC CHIẾN (YARA ENGINE)
# =================================================================

@test "Integration: Quét Website SẠCH (Chưa bị nhiễm mã độc)" {
  # Website mồi vừa được cài WP mới tinh, nên 100% phải sạch
  run bash "$SCRIPT_TEST" "$TEST_DOMAIN"
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  
  # Kiểm chứng: Phải in ra thông báo Tối ưu loại trừ file (Smart Exclude) và kết quả sạch sẽ
  [[ "$output" =~ "Tối ưu thành công: Đã bỏ qua các tệp an toàn" ]]
  [[ "$output" =~ "Website Sạch Sẽ: Không phát hiện hành vi mã độc" ]]
}

@test "Integration: YARA Tóm gọn Website NHIỄM MÃ ĐỘC" {
  # 1. HÀNH ĐỘNG HACKER: Cấy 1 file PHP chứa chữ ký mã độc giả lập vào thư mục uploads
  local FAKE_MALWARE_FILE="/usr/local/lsws/$TEST_DOMAIN/html/wp-content/uploads/shell-gia-lap.php"
  mkdir -p "/usr/local/lsws/$TEST_DOMAIN/html/wp-content/uploads"
  echo '<?php echo "Đây là mã độc: WPTT_MALWARE_SIGNATURE_123"; ?>' > "$FAKE_MALWARE_FILE"

  # 2. CHẠY YARA SCAN
  run bash "$SCRIPT_TEST" "$TEST_DOMAIN"

  # 3. DỌN DẸP LẬP TỨC (để không ảnh hưởng bài test sau)
  rm -f "$FAKE_MALWARE_FILE"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  
  # 4. KIỂM CHỨNG: Kịch bản phải hú còi báo động!
  [[ "$output" =~ "CẢNH BÁO BẢO MẬT: Phát hiện 1 dấu hiệu nghi ngờ" ]]
  
  # Phải chỉ đích danh được file bị nhiễm
  [[ "$output" =~ "shell-gia-lap.php" ]]
  
  # Phải chỉ đích danh được Tên Rule YARA đã bắt được nó
  [[ "$output" =~ "WPTT_Fake_Malware" ]]
}

@test "Integration: Chế độ quét Tất cả website" {
  run bash "$SCRIPT_TEST" "Tất cả website"
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "TỔNG KẾT QUÉT MÃ ĐỘC YARA TOÀN BỘ WEBSITE" ]]
}

