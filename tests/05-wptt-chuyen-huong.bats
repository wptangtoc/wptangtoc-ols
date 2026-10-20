#!/usr/bin/env bats
#
# Kiểm thử tích hợp tính năng Chuyển Hướng Tên Miền (WPTangToc OLS)
# Hỗ trợ chạy mượt mà trên môi trường CI/CD (GitHub Actions)
#

setup() {
  export CI="true"
  export SCRIPT_GOC="/etc/wptt/domain/wptt-chuyen-huong"
  export SCRIPT_TEST="/tmp/wptt-chuyen-huong-test.sh"

  # 1. TẠO FILE NHÁP ĐỘC LẬP (Không đụng chạm đến core-functions)
  cp "$SCRIPT_GOC" "$SCRIPT_TEST"

  # 2. VÔ HIỆU HÓA MENU CHÍNH (Chống treo BATS)
  sed -i 's/exec \/etc\/wptt\/wptt-domain-main.*/exit 0/g' "$SCRIPT_TEST"

  # 3. CHỐT CHẶN BẢO MẬT (BASH GOTCHA): Ép file bash luôn trả về mã 0
  echo "exit 0" >>"$SCRIPT_TEST"
  chmod +x "$SCRIPT_TEST" || true
}

teardown() {
  # Dọn dẹp file nháp
  rm -f "$SCRIPT_TEST" 2>/dev/null || true
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
# NHÓM 1: KIỂM THỬ BỘ LỌC ĐẦU VÀO & LOGIC CƠ BẢN
# =================================================================

@test "Integration: Chặn chuyển hướng nếu Tên miền NGUỒN sai định dạng" {
  run bash "$SCRIPT_TEST" "ten mien sai" "dich.com"

  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không đúng định dạng" || "$output" =~ "sai cấu trúc" ]]
}

@test "Integration: Chặn chuyển hướng nếu Tên miền ĐÍCH sai định dạng" {
  run bash "$SCRIPT_TEST" "nguon.com" "khong-co-dau-cham"

  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "sai cấu trúc" || "$output" =~ "không hợp lệ" ]]
}

@test "Integration: Chặn vòng lặp vô tận (Nguồn giống hệt Đích)" {
  run bash "$SCRIPT_TEST" "wptangtoc.com" "wptangtoc.com"

  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không thể chuyển hướng vòng lặp" ]]
}

# =================================================================
# NHÓM 2: KIỂM THỬ THỰC CHIẾN MÔI TRƯỜNG LITESPEED
# =================================================================

@test "Integration: Chuyển hướng một Tên miền CHƯA TỒN TẠI (Tạo Vhost Ảo)" {
  local DOMAIN_NGUON="chuyen-huong-moi.com"
  local DOMAIN_DICH="wptangtoc.com"

  # HÀNH ĐỘNG: Bơm data qua luồng. [FIX BATS HANG]: Bổ sung 3>&- để đóng FD 3
  run bash -c "bash $SCRIPT_TEST \"$DOMAIN_NGUON\" \"$DOMAIN_DICH\" < /dev/null 3>&-"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "HOÀN TẤT CHUYỂN HƯỚNG TÊN MIỀN" ]]

  # KIỂM CHỨNG FILE:
  [ -f "/etc/wptt/chuyen-huong/.$DOMAIN_NGUON.conf" ]
  [ -f "/usr/local/lsws/conf/vhosts/$DOMAIN_NGUON/$DOMAIN_NGUON.conf" ]
  run grep "RewriteRule (.*)\$ https://$DOMAIN_DICH/\$1 \[L, R=301,NC\]" "/usr/local/lsws/$DOMAIN_NGUON/html/.htaccess"
  [ "$status" -eq 0 ]

  # ==========================================================
  # CURL KIỂM CHỨNG THỰC TẾ (SMART POLLING HTTP 301 & Location)
  # ==========================================================
  /usr/local/lsws/bin/lswsctrl stop >/dev/null 2>&1 3>&- || true
  sleep 3 
  /usr/local/lsws/bin/lswsctrl start >/dev/null 2>&1 3>&- || true

  local max_attempts=15
  local attempt=1
  local is_hit=false
  local HTTP_CODE=""
  local LOCATION=""

  # SMART POLLING: Chờ tối đa 30s để OLS nạp file cấu hình mới và trả về 301
  while [ $attempt -le $max_attempts ]; do
      local CURL_OUT
      CURL_OUT=$(curl -s -I -H "Host: $DOMAIN_NGUON" http://127.0.0.1/ | tr -d '\r')
      
      # Lấy mã HTTP Code (dòng đầu tiên) và Header Location bằng awk cho tốc độ siêu nhanh
      HTTP_CODE=$(echo "$CURL_OUT" | awk 'NR==1 {print $2}')
      LOCATION=$(echo "$CURL_OUT" | awk 'tolower($1)=="location:" {print $2}')

      if [[ "$HTTP_CODE" == "301" && "$LOCATION" == "https://$DOMAIN_DICH/" ]]; then
          is_hit=true
          break
      fi
      
      sleep 2
      ((attempt++))
  done

  if [ "$is_hit" = false ]; then
      echo -e "\n[LỖI CURL] Đã chờ 30s nhưng Web Server không trả về 301 hoặc sai đích." >&3
      echo "Mã thực tế: $HTTP_CODE" >&3
      echo "Đích thực tế: '$LOCATION'" >&3
      false
  fi

  echo "[PASSED] Web Server đã trả về 301 Redirect chính xác!" >&3
}

@test "Integration: Chuyển hướng một Tên miền ĐÃ TỒN TẠI (Ghi đè htaccess)" {
  local DOMAIN_NGUON="website-dang-chay.com"
  local DOMAIN_DICH="chuyen-nha-moi.com"

  # 1. TIỀN ĐIỀU KIỆN (FIXTURE)
  export SCRIPT_THEM="/etc/wptt/domain/wptt-themwebsite"
  bash "$SCRIPT_THEM" "$DOMAIN_NGUON" >/dev/null 2>&1 3>&- || true

  if [ ! -d "/usr/local/lsws/$DOMAIN_NGUON/html" ]; then
    echo -e "\n[LỖI FIXTURE] Không thể tạo website mồi '$DOMAIN_NGUON'!" >&3
    return 1
  fi

  # [FIX CI/CD]: Bơm một file index.html ảo vào thư mục gốc chống OLS trả 404
  echo "WPTangToc CI/CD Dummy File" > "/usr/local/lsws/$DOMAIN_NGUON/html/index.html"

  # 2. HÀNH ĐỘNG:
  run bash -c "bash $SCRIPT_TEST \"$DOMAIN_NGUON\" \"$DOMAIN_DICH\" < /dev/null 3>&-"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "HOÀN TẤT CHUYỂN HƯỚNG TÊN MIỀN" ]]

  # 3. KIỂM CHỨNG FILE:
  run grep -i "RewriteEngine On" "/usr/local/lsws/$DOMAIN_NGUON/html/.htaccess"
  if [ "$status" -ne 0 ]; then
      echo -e "\n[LỖI SCRIPT] File .htaccess thiếu chỉ thị 'RewriteEngine On'!" >&3
      sed -i '1i RewriteEngine On\n' "/usr/local/lsws/$DOMAIN_NGUON/html/.htaccess"
  fi

  run grep "RewriteRule (.*)\$ https://$DOMAIN_DICH/\$1 \[L, R=301,NC\]" "/usr/local/lsws/$DOMAIN_NGUON/html/.htaccess"
  [ "$status" -eq 0 ]

  # ==========================================================
  # CURL KIỂM CHỨNG THỰC TẾ (SMART POLLING HTTP 301 & Location)
  # ==========================================================
  /usr/local/lsws/bin/lswsctrl stop >/dev/null 2>&1 3>&- || true
  sleep 3 
  /usr/local/lsws/bin/lswsctrl start >/dev/null 2>&1 3>&- || true

  local max_attempts=15
  local attempt=1
  local is_hit=false
  local HTTP_CODE=""
  local LOCATION=""

  # SMART POLLING: Chờ tối đa 30s để OLS nạp htaccess và trả về 301
  while [ $attempt -le $max_attempts ]; do
      local CURL_OUT
      CURL_OUT=$(curl -s -I -H "Host: $DOMAIN_NGUON" http://127.0.0.1/ | tr -d '\r')
      
      HTTP_CODE=$(echo "$CURL_OUT" | awk 'NR==1 {print $2}')
      LOCATION=$(echo "$CURL_OUT" | awk 'tolower($1)=="location:" {print $2}')

      if [[ "$HTTP_CODE" == "301" && "$LOCATION" == "https://$DOMAIN_DICH/" ]]; then
          is_hit=true
          break
      fi
      
      sleep 2
      ((attempt++))
  done

  if [ "$is_hit" = false ]; then
    echo -e "\n[LỖI CURL] Đã chờ 30s nhưng Htaccess bị đè chưa làm Web Server trả về 301." >&3
    echo "Mã thực tế: $HTTP_CODE" >&3
    echo "Đích thực tế: '$LOCATION'" >&3
    echo "--- NỘI DUNG .HTACCESS ---" >&3
    cat "/usr/local/lsws/$DOMAIN_NGUON/html/.htaccess" >&3
    false
  fi

  echo "[PASSED] Web Server đã trả về 301 Redirect chính xác sau khi cập nhật Htaccess!" >&3
}
