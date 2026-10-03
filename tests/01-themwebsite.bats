#!/usr/bin/env bats

setup() {
  # BATS sẽ lấy thẳng file mã nguồn MỚI NHẤT mà bác vừa push lên nhánh để test
  export CI="true"
  export SCRIPT_GOC="/etc/wptt/domain/wptt-themwebsite"
  chmod +x "$SCRIPT_GOC"
}

# --- HÀM VŨ KHÍ GỠ LỖI (Dùng chung cho toàn bộ bài test) ---
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
  run bash "$SCRIPT_GOC" "   test-sach-khoang-trang.com  "
 
  in_log_neu_loi 0 # Kỳ vọng kịch bản lướt qua êm ru (mã 0)

  [ "$status" -eq 0 ]
  [ -d "/usr/local/lsws/test-sach-khoang-trang.com" ]
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
  run bash "$SCRIPT_GOC" "khachhang-demo.com"
  
  in_log_neu_loi 0 # Kỳ vọng tạo website thành công (mã 0)

  [ "$status" -eq 0 ]
  [ -f "/usr/local/lsws/conf/vhosts/khachhang-demo.com/khachhang-demo.com.conf" ]
  [ -d "/usr/local/lsws/khachhang-demo.com/html" ]
  
  run grep "khachhang-demo.com" /usr/local/lsws/conf/httpd_config.conf
  [ "$status" -eq 0 ]
}
