#!/usr/bin/env bats

setup() {
  # BATS sẽ lấy thẳng file mã nguồn MỚI NHẤT mà bác vừa push lên nhánh để test
  export CI="true"
  export SCRIPT_GOC="/etc/wptt/domain/wptt-themwebsite"
  chmod +x "$SCRIPT_GOC"
}

in_log_neu_loi() {
  local ma_ky_vong="$1"
  if [ "$status" -ne "$ma_ky_vong" ]; then
      echo -e "\n[LỖI TEST] Kịch bản không trả về mã $ma_ky_vong như kỳ vọng!" >&3
      echo "Mã trạng thái thực tế : $status" >&3
      echo -e "Nội dung in ra màn hình:\n$output" >&3
  fi
}
# -----------------------------------------------------------

# =================================================================
# NHÓM 1: KIỂM THỬ BỘ LỌC ĐẦU VÀO (VALIDATION)
# =================================================================

@test "Integration: Chặn Tên miền thiếu dấu chấm" {
  run bash "$SCRIPT_GOC" "wptangtoc"
  
  in_log_neu_loi 1 # Gọi hàm và truyền số 1 (Kỳ vọng mã lỗi 1)

  [ "$status" -eq 1 ]
  [[ "$output" =~ "đúng định dạng" ]]
}

@test "Integration: Chặn Tên miền chứa ký tự đặc biệt" {
  run bash "$SCRIPT_GOC" "wptangtoc@.com"
  
  in_log_neu_loi 1

  [ "$status" -eq 1 ]
  [[ "$output" =~ "sai cấu trúc" ]]
}

@test "Integration: Tự động làm sạch khoảng trắng (CRLF, Space)" {
  local DOMAIN="test-sach-khoang-trang.com"
  run bash "$SCRIPT_GOC" "   $DOMAIN  "
 
  in_log_neu_loi 0 # Kỳ vọng kịch bản lướt qua êm ru (mã 0)

  [ "$status" -eq 0 ]
  [ -d "/usr/local/lsws/$DOMAIN" ]
}

# =================================================================
# NHÓM 2: KIỂM THỬ THỰC CHIẾN TRÊN HỆ THỐNG THẬT (MÔI TRƯỜNG OLS)
# =================================================================

@test "Integration: CHẶN THÀNH CÔNG Domain đã tồn tại (Trùng Domain chính)" {
  run bash "$SCRIPT_GOC" "github.wptangtoc.com"
 
  in_log_neu_loi 1

  [ "$status" -eq 1 ]
  [[ "$output" =~ "tồn tại trên hệ thống" ]]
}

@test "Integration: THÊM MỚI THÀNH CÔNG một Website thật" {
  local DOMAIN="khachhang-demo.com"
  run bash "$SCRIPT_GOC" "$DOMAIN"
  
  in_log_neu_loi 0 # Kỳ vọng tạo website thành công (mã 0)
  [ "$status" -eq 0 ]
  
  # 1. KIỂM CHỨNG FILE HỆ THỐNG: Webroot và File cấu hình phải tồn tại
  [ -f "/usr/local/lsws/conf/vhosts/$DOMAIN/$DOMAIN.conf" ]
  [ -d "/usr/local/lsws/$DOMAIN/html" ]
  run grep "$DOMAIN" /usr/local/lsws/conf/httpd_config.conf
  [ "$status" -eq 0 ]

#restart thủ công cơ bản smart reload là tiến trình không đồng bộ mà file bats thực thi quá nhanh nên phải đặt sleep kiểu này
  /usr/local/lsws/bin/lswsctrl restart >/dev/null 2>&1 || true
  sleep 5

  # =================================================================
  # CHỐT CHẶN ENTERPRISE 1: KIỂM TRA CÚ PHÁP OLS
  # =================================================================
  run /usr/local/lsws/bin/openlitespeed -t
  
  if [ "$status" -ne 0 ]; then
      echo -e "\n=== [LỖI CRITICAL] SCRIPT SINH RÁC VÀO CẤU HÌNH OLS ===" >&3
      echo "$output" >&3
  fi
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Syntax OK" || "$output" =~ "ok" || -z "$output" ]]

  
  # # Bơm lệnh Restart và đếm ngược 5 giây cho Worker mới nạp xong cấu hình
  # /usr/local/lsws/bin/lswsctrl restart >/dev/null 2>&1 || true
  # sleep 5

  # Dùng Curl bắn thẳng vào localhost kèm Header Host ảo
  local HTTP_CODE=$(curl -m 5 -sS -o /dev/null -w "%{http_code}" -H "Host: $DOMAIN" http://127.0.0.1/)
  
  # Mã 404 (Không tìm thấy Vhost) hoặc 000 (Chết Webserver) là không thể chấp nhận
  if [ "$HTTP_CODE" == "404" ] || [ "$HTTP_CODE" == "000" ]; then
      echo -e "\n[LỖI] Web Server không nhận diện được website mới. Mã HTTP thực tế: $HTTP_CODE" >&3
      false
  fi
  
  # In thông báo xanh mượt ra log nếu vượt qua 
  echo "[PASSED] Domain $DOMAIN đã phản hồi với mã HTTP: $HTTP_CODE" >&3
}
