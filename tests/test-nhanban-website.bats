#!/usr/bin/env bats

setup() {
  export SCRIPT_THEM="/etc/wptt/domain/wptt-themwebsite"
  export SCRIPT_CLONE="/etc/wptt/wptt-sao-chep-website" # Bác sửa lại tên file gốc nếu khác nhé
  chmod +x "$SCRIPT_THEM" 2>/dev/null || true
  chmod +x "$SCRIPT_CLONE" 2>/dev/null || true
}

# =================================================================
# NHÓM 1: CHUẨN BỊ MÔI TRƯỜNG
# =================================================================

@test "Integration [Clone]: Khởi tạo Website Nguồn để làm mẫu" {
  # Tạo trước một website nguồn. Nếu bài test này Fail, các bài test sau cũng vô nghĩa.
  run bash "$SCRIPT_THEM" "nguon-clone.com"
  [ "$status" -eq 0 ]
  [ -d "/usr/local/lsws/nguon-clone.com/html" ]
}

# =================================================================
# NHÓM 2: KIỂM THỬ BỘ LỌC ĐẦU VÀO (VALIDATION)
# =================================================================

@test "Integration [Clone]: Chặn nhân bản từ Tên miền Nguồn KHÔNG TỒN TẠI" {
  run bash "$SCRIPT_CLONE" "domain-khong-co-that.com" "dich-clone.com"
  
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không tồn tại" ]]
}

@test "Integration [Clone]: Chặn Website Đích thiếu dấu chấm" {
  run bash "$SCRIPT_CLONE" "nguon-clone.com" "webdich"
  
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không đúng định dạng" ]]
}

@test "Integration [Clone]: Chặn Website Đích chứa ký tự đặc biệt" {
  run bash "$SCRIPT_CLONE" "nguon-clone.com" "dich@clone.com"
  
  [ "$status" -eq 1 ]
  [[ "$output" =~ "sai cấu trúc" ]]
}

# =================================================================
# NHÓM 3: KIỂM THỬ THỰC CHIẾN (EXECUTION)
# =================================================================

@test "Integration [Clone]: NHÂN BẢN THÀNH CÔNG sang Website Đích" {
  # Chạy script với $1 là Nguồn và $2 là Đích
  run bash "$SCRIPT_CLONE" "nguon-clone.com" "dich-clone.com"
  
  # 1. Kịch bản phải chạy qua hết không báo lỗi
  [ "$status" -eq 0 ]
  
  # 2. KIỂM CHỨNG HỆ THỐNG: Vhost của Đích đã được sinh ra chưa?
  [ -f "/usr/local/lsws/conf/vhosts/dich-clone.com/dich-clone.com.conf" ]
  
  # 3. KIỂM CHỨNG THƯ MỤC: Source code đã được chép sang chưa?
  [ -d "/usr/local/lsws/dich-clone.com/html" ]
  
  # 4. KIỂM CHỨNG CONFIG: Đã nối thành công vào httpd_config chưa?
  run grep "dich-clone.com" /usr/local/lsws/conf/httpd_config.conf
  [ "$status" -eq 0 ]
}

@test "Integration [Clone]: GHI ĐÈ THÀNH CÔNG khi dùng cờ 'no-config'" {
  # Cố tình nhân bản đè lên cái Đích vừa tạo ở bài test trên
  # Truyền thêm tham số thứ 3 "no-config" để kích hoạt tính năng tự động xóa/ghi đè của bác
  run bash "$SCRIPT_CLONE" "nguon-clone.com" "dich-clone.com" "no-config"
  
  [ "$status" -eq 0 ]
  
  # Đảm bảo sau khi ghi đè, hệ thống đích vẫn sống khỏe mạnh
  [ -f "/usr/local/lsws/conf/vhosts/dich-clone.com/dich-clone.com.conf" ]
  [ -d "/usr/local/lsws/dich-clone.com/html" ]
}
