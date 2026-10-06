#!/usr/bin/env bats

setup() {
  export SCRIPT_THEM="/etc/wptt/domain/wptt-themwebsite"
  export SCRIPT_CHUYENHUONG="/etc/wptt/domain/wptt-chuyen-huong"
  
  chmod +x "$SCRIPT_THEM" 2>/dev/null || true
  chmod +x "$SCRIPT_CHUYENHUONG" 2>/dev/null || true
}

# =================================================================
# NHÓM 1: KIỂM THỬ BỘ LỌC ĐẦU VÀO (VALIDATION)
# =================================================================

@test "Integration [Chuyển hướng]: Chặn Domain Nguồn nhập thiếu dấu chấm" {
  run bash "$SCRIPT_CHUYENHUONG" "domainnguon" "domaindich.com"
  
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không đúng định dạng" ]]
}

@test "Integration [Chuyển hướng]: Chặn Domain Đích chứa ký tự đặc biệt" {
  run bash "$SCRIPT_CHUYENHUONG" "nguon.com" "dich@com"
  
  [ "$status" -eq 1 ]
  [[ "$output" =~ "sai cấu trúc" ]]
}

@test "Integration [Chuyển hướng]: Chặn việc chuyển hướng vòng lặp (Nguồn trùng Đích)" {
  run bash "$SCRIPT_CHUYENHUONG" "vonglap.com" "vonglap.com"
  
  [ "$status" -eq 1 ]
  [[ "$output" =~ "chuyển hướng vòng lặp" ]]
}

# =================================================================
# NHÓM 2: KIỂM THỬ NHÁNH 2 - TẠO VHOST MỚI HỨNG CHUYỂN HƯỚNG
# (Chuyển hướng một domain CHƯA TỒN TẠI trên máy chủ)
# =================================================================

@test "Integration [Chuyển hướng]: TẠO VHOST PHỤ cho domain chưa tồn tại" {
  # Chuyển hướng từ một tên miền chưa hề có trên hệ thống
  run bash "$SCRIPT_CHUYENHUONG" "chuatontai-nguon.com" "dich-moi.com"
  
  [ "$status" -eq 0 ]
  
  # 1. Kiểm chứng Virtual Host phụ đã được sinh ra để hứng request chưa
  [ -f "/usr/local/lsws/conf/vhosts/chuatontai-nguon.com/chuatontai-nguon.com.conf" ]
  
  # 2. Kiểm chứng thư mục web (html) đã được tạo để chứa htaccess chưa
  [ -d "/usr/local/lsws/chuatontai-nguon.com/html" ]
  
  # 3. Kiểm chứng OLS chính đã được gán map chưa
  run grep "chuatontai-nguon.com" /usr/local/lsws/conf/httpd_config.conf
  [ "$status" -eq 0 ]
  
  # 4. Kiểm chứng luật 301 đã được tiêm vào .htaccess chưa
  run grep "301" "/usr/local/lsws/chuatontai-nguon.com/html/.htaccess"
  [ "$status" -eq 0 ]
  
  # 5. Kiểm chứng Cờ chuyển hướng của hệ thống WPTangToc
  [ -f "/etc/wptt/chuyen-huong/.chuatontai-nguon.com.conf" ]
}

# =================================================================
# NHÓM 3: KIỂM THỬ NHÁNH 1 - TIÊM VÀO WEBSITE ĐÃ CÓ SẴN
# =================================================================

@test "Integration [Chuyển hướng]: TIÊM HTACCESS vào website đang hoạt động" {
  # BƯỚC 1: Khởi tạo một website hoạt động thật sự trên hệ thống
  run bash "$SCRIPT_THEM" "web-dang-chay.com"
  [ "$status" -eq 0 ]
  [ -d "/usr/local/lsws/web-dang-chay.com/html" ]
  
  # BƯỚC 2: Thực hiện chuyển hướng website đang chạy này sang một đích khác
  run bash "$SCRIPT_CHUYENHUONG" "web-dang-chay.com" "chuyen-toi-day.com"
  [ "$status" -eq 0 ]
  
  # BƯỚC 3: Kiểm chứng
  # Đảm bảo luật chuyển hướng 301 đã được tiêm thẳng vào htaccess của website cũ
  run grep "301" "/usr/local/lsws/web-dang-chay.com/html/.htaccess"
  [ "$status" -eq 0 ]
  
  # Đảm bảo target đích là chính xác
  run grep "chuyen-toi-day.com" "/usr/local/lsws/web-dang-chay.com/html/.htaccess"
  [ "$status" -eq 0 ]
  
  # Đảm bảo file cấu hình cũ đã được backup thành công
  [ -f "/etc/wptt/vhost_bk/.web-dang-chay.com.conf" ]
}
