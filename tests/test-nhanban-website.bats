#!/usr/bin/env bats

setup() {
  export SCRIPT_THEM="/etc/wptt/domain/wptt-themwebsite"
  export SCRIPT_INSTALL_WP="/etc/wptt/wptt-install-wordpress2"
  export SCRIPT_CLONE="/etc/wptt/wptt-sao-chep-website"
  
  chmod +x "$SCRIPT_THEM" 2>/dev/null || true
  chmod +x "$SCRIPT_INSTALL_WP" 2>/dev/null || true
  chmod +x "$SCRIPT_CLONE" 2>/dev/null || true
}

# =================================================================
# NHÓM 1: CHUẨN BỊ MÔI TRƯỜNG
# =================================================================

@test "Integration [Clone]: Khởi tạo 2 Website Nguồn (1 có WP, 1 không có WP)" {
  # 1. Tạo website nguồn số 1: KHÔNG CÓ WordPress (chỉ có vhost rỗng)
  run bash "$SCRIPT_THEM" "nguon-khong-wp.com"
  [ "$status" -eq 0 ]

  # 2. Tạo website nguồn số 2: CÓ WORDPRESS THẬT
  run bash "$SCRIPT_THEM" "nguon-wp.com"
  [ "$status" -eq 0 ]
  
  # Cài đặt WordPress tự động cho web số 2 (Truyền 'y' xác nhận và 'n' bỏ qua cấu hình admin)
  run bash -c '{ echo "y"; echo "n"; } | bash "$SCRIPT_INSTALL_WP" "nguon-wp.com"'
  [ "$status" -eq 0 ]
}

# =================================================================
# NHÓM 2: KIỂM THỬ BỘ LỌC ĐẦU VÀO (VALIDATION)
# =================================================================

@test "Integration [Clone]: Chặn nhân bản nếu Website Nguồn KHÔNG PHẢI WordPress" {
  # Dùng web số 1 (web trắng) làm nguồn để xem script có chặn lại không
  run bash "$SCRIPT_CLONE" "nguon-khong-wp.com" "dich-clone.com"
  
  [ "$status" -eq 1 ]
  # Bác hãy sửa cụm từ "không tìm thấy" hoặc "không phải" cho khớp với câu báo lỗi thực tế trong file bash của bác
  [[ "$output" =~ "không tìm thấy" ]] || [[ "$output" =~ "không phải" ]]
}

@test "Integration [Clone]: Chặn nhân bản từ Tên miền Nguồn KHÔNG TỒN TẠI" {
  run bash "$SCRIPT_CLONE" "domain-khong-co-that.com" "dich-clone.com"
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không tồn tại" ]]
}

@test "Integration [Clone]: Chặn Website Đích thiếu dấu chấm" {
  # Từ bước này trở đi, ta dùng nguồn chuẩn là nguon-wp.com
  run bash "$SCRIPT_CLONE" "nguon-wp.com" "webdich"
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không đúng định dạng" ]]
}

@test "Integration [Clone]: Chặn Website Đích chứa ký tự đặc biệt" {
  run bash "$SCRIPT_CLONE" "nguon-wp.com" "dich@clone.com"
  [ "$status" -eq 1 ]
  [[ "$output" =~ "sai cấu trúc" ]]
}

# =================================================================
# NHÓM 3: KIỂM THỬ THỰC CHIẾN (EXECUTION)
# =================================================================

@test "Integration [Clone]: NHÂN BẢN THÀNH CÔNG sang Website Đích" {
  # Chạy script clone từ nguồn CHUẨN (đã có WP) sang đích
  run bash "$SCRIPT_CLONE" "nguon-wp.com" "dich-clone.com"
  
  [ "$status" -eq 0 ]
  
  # Kiểm chứng Vhost và Thư mục đã được sinh ra
  [ -f "/usr/local/lsws/conf/vhosts/dich-clone.com/dich-clone.com.conf" ]
  [ -d "/usr/local/lsws/dich-clone.com/html" ]
  
  # Đảm bảo mã nguồn WP (ví dụ wp-config.php) đã được chép sang web đích thành công
  [ -f "/usr/local/lsws/dich-clone.com/html/wp-config.php" ]
  
  run grep "dich-clone.com" /usr/local/lsws/conf/httpd_config.conf
  [ "$status" -eq 0 ]
}

@test "Integration [Clone]: GHI ĐÈ THÀNH CÔNG khi dùng cờ 'no-config'" {
  # Nhân bản đè lên chính cái web đích vừa tạo ở trên
  run bash "$SCRIPT_CLONE" "nguon-wp.com" "dich-clone.com" "no-config"
  
  [ "$status" -eq 0 ]
  [ -f "/usr/local/lsws/conf/vhosts/dich-clone.com/dich-clone.com.conf" ]
  [ -d "/usr/local/lsws/dich-clone.com/html" ]
}
