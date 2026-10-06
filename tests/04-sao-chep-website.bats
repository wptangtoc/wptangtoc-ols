#!/usr/bin/env bats

setup_file() {
  export CI="true"
  export SCRIPT_GOC="/etc/wptt/wptt-sao-chep-website"
  export SCRIPT_XOA="/etc/wptt/domain/wptt-xoawebsite"
  export SCRIPT_THEM="/etc/wptt/domain/wptt-themwebsite"
  
  # Khai báo sẵn 2 domain để dùng chung cho việc dọn dẹp
  export DOMAIN_NGUON="nguon-sao-chep.com"
  export DOMAIN_DICH="dich-sao-chep.com"
}

setup() {
  export CI="true"
  export SCRIPT_TEST="/tmp/wptt-sao-chep-website-test.sh"
  
  # Tạo file Test độc lập
  cp "$SCRIPT_GOC" "$SCRIPT_TEST"
  # Chặn gọi menu chính gây treo CI
  sed -i 's/exec \/etc\/wptt\/wptt-domain-main.*/exit 0/g' "$SCRIPT_TEST"
  echo "exit 0" >> "$SCRIPT_TEST"
  chmod +x "$SCRIPT_TEST" || true
}

teardown() {
  rm -f "$SCRIPT_TEST" 2>/dev/null || true
}

teardown_file() {
  # Quét sạch cả 2 website và Database bằng bạo lực (bơm sẵn 'y')
  echo -e "y\ny" | bash "$SCRIPT_XOA" "$DOMAIN_NGUON" >/dev/null 2>&1 || true
  echo -e "y\ny" | bash "$SCRIPT_XOA" "$DOMAIN_DICH" >/dev/null 2>&1 || true
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
  # FIX: Phải tạo mồi website Nguồn tồn tại thật
  bash "$SCRIPT_THEM" "$DOMAIN_NGUON" >/dev/null 2>&1 || true

  run bash "$SCRIPT_TEST" "$DOMAIN_NGUON" "dich-sai-dinh-dang"
  
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không đúng định dạng" || "$output" =~ "sai cấu trúc" ]]
  
  # Dọn mồi
  echo -e "y\ny" | bash "$SCRIPT_XOA" "$DOMAIN_NGUON" >/dev/null 2>&1 || true
}

# =================================================================
# KIỂM THỬ THỰC CHIẾN SAO CHÉP (CÀI WP -> CLONE -> CHECK)
# =================================================================

@test "Integration: NHÂN BẢN THÀNH CÔNG WordPress thật từ Nguồn sang Đích" {
  # 1. FIXTURE (TẠO WEBSITE NGUỒN VÀ CÀI WP THẬT)
  bash "$SCRIPT_THEM" "$DOMAIN_NGUON" >/dev/null 2>&1 || true

  local script_wp_test="/tmp/wptt-install-wp-waf.sh"
  cp /etc/wptt/wptt-install-wordpress2 "$script_wp_test"
  sed -i 's/exec \/etc\/wptt\/wptt-wordpress-main.*/exit 0/g' "$script_wp_test"
  sed -i 's/exec \/usr\/bin\/wptangtoc.*/exit 0/g' "$script_wp_test"
  
  # Bơm data để cài WP tự động: Site Title -> User -> Pass -> Email
  local inputs="WP Nguon Test\nadmin\nPassSieuKho123!\nadmin@${DOMAIN_NGUON}\n"
  echo -e "$inputs" | bash "$script_wp_test" "$DOMAIN_NGUON" >/dev/null 2>&1 || true
  rm -f "$script_wp_test"

  # Đảm bảo website nguồn đã có wp-config.php (Cài đặt thành công)
  if [ ! -f "/usr/local/lsws/$DOMAIN_NGUON/html/wp-config.php" ]; then
      echo -e "\n[LỖI FIXTURE] Không thể cài đặt WordPress lên site Nguồn!" >&3
      false
  fi

  # 2. HÀNH ĐỘNG (SAO CHÉP)
  # Bơm tự động phím Enter hoặc Yes đề phòng script sao chép có hỏi xác nhận
  run bash -c "echo -e 'y\ny\n' | bash $SCRIPT_TEST \"$DOMAIN_NGUON\" \"$DOMAIN_DICH\""

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  
  # 3. KIỂM CHỨNG TỆP TIN & VHOST
  [ -d "/usr/local/lsws/$DOMAIN_DICH/html" ]
  [ -f "/usr/local/lsws/$DOMAIN_DICH/html/wp-config.php" ]
  run grep "$DOMAIN_DICH" /usr/local/lsws/conf/httpd_config.conf
  [ "$status" -eq 0 ]

  # Cú đấm thép: Ép OLS nạp cấu hình (Bypass systemd)
  /usr/local/lsws/bin/lswsctrl restart >/dev/null 2>&1 || true
  
  # ĐÃ XÓA SLEEP 4 CỨNG NHẮC Ở ĐÂY ĐỂ CHUYỂN SANG SMART POLLING
  
  # =================================================================
  # CHỐT CHẶN ENTERPRISE 1: KIỂM TRA CÚ PHÁP OLS
  # =================================================================
  # Xem quá trình nhân bản Vhost có đẻ ra rác cú pháp hay không
  run /usr/local/lsws/bin/openlitespeed -t
  
  if [ "$status" -ne 0 ]; then
      echo -e "\n=== [LỖI CRITICAL] SCRIPT SAO CHÉP TẠO RÁC CÚ PHÁP OLS ===" >&3
      echo "$output" >&3
  fi
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Syntax OK" || "$output" =~ "ok" || -z "$output" ]]

  # =================================================================
  # CHỐT CHẶN ENTERPRISE 2: CURL E2E ĐỂ CHỨNG MINH DB & PHP CHẠY
  # =================================================================
  
  # A. Curl vào tên miền Nguồn (Dùng vòng lặp Polling chống Timeout trên ARM)
  local max_attempts=12
  local attempt=1
  local CODE_NGUON="000"

  while [ $attempt -le $max_attempts ]; do
      CODE_NGUON=$(curl -m 5 -sS -o /dev/null -w "%{http_code}" -H "Host: $DOMAIN_NGUON" http://127.0.0.1/ || echo "000")
      if [[ "$CODE_NGUON" =~ ^[23][0-9][0-9]$ ]]; then
          break
      fi
      sleep 5
      ((attempt++))
  done

  if ! [[ "$CODE_NGUON" =~ ^[23][0-9][0-9]$ ]]; then
      echo -e "\n[LỖI NGUỒN] Website gốc bị lỗi sau khi sao chép. Mã HTTP: $CODE_NGUON" >&3
      false
  fi

  # B. Curl vào tên miền Đích (Dùng vòng lặp Polling chống Timeout trên ARM)
  local attempt_dich=1
  local CODE_DICH="000"
  
  # "Đang chờ OLS phản hồi trên Đích (Tối đa 36s cho ARM)..." >&3 ARM QEMU chạy chậm nó không nhanh như native
  while [ $attempt_dich -le $max_attempts ]; do
      CODE_DICH=$(curl -m 5 -sS -o /dev/null -w "%{http_code}" -H "Host: $DOMAIN_DICH" http://127.0.0.1/ || echo "000")
      if [[ "$CODE_DICH" =~ ^[23][0-9][0-9]$ ]]; then
          break
      fi
      sleep 5
      ((attempt_dich++))
  done

  if ! [[ "$CODE_DICH" =~ ^[23][0-9][0-9]$ ]]; then
      echo -e "\n[LỖI ĐÍCH] Bản sao chép thất bại (Có thể lỗi DB hoặc cấu hình). Mã HTTP: $CODE_DICH" >&3
      false
  fi

  echo "[PASSED] Cả 2 Website (Nguồn: $CODE_NGUON, Đích: $CODE_DICH) đều phản hồi 2xx/3xx!" >&3
}
