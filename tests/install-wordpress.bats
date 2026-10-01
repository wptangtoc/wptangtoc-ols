#!/usr/bin/env bats

setup() {
  export SCRIPT_THEM="/etc/wptt/domain/wptt-themwebsite"
  export SCRIPT_INSTALL_WP="/etc/wptt/wptt-install-wordpress2"
  chmod +x "$SCRIPT_THEM" 2>/dev/null || true
  chmod +x "$SCRIPT_INSTALL_WP" 2>/dev/null || true
}

# =================================================================
# NHÓM 1: KIỂM THỬ BỘ LỌC ĐẦU VÀO
# =================================================================

@test "Integration [WP Install]: Chặn cài đặt vào Domain KHÔNG TỒN TẠI" {
  run bash "$SCRIPT_INSTALL_WP" "domain-khong-ton-tai.com"
  
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không tồn tại trên hệ thống này" ]]
}


# =================================================================
# NHÓM 2: KIỂM THỬ THỰC CHIẾN - CÀI ĐẶT WORDPRESS
# =================================================================

@test "Integration [WP Install]: TẢI, GIẢI NÉN và TẠO BASIC AUTH thành công" {
  # TIÊM BIẾN MÔI TRƯỜNG: Ép hàm wptt_xac_nhan trả về 1 (Không đồng ý thiết lập Admin ngay)
  export WPTT_AUTO_CONFIRM=2
  
  run bash "$SCRIPT_THEM" "wp-install-test.com"
  run bash "$SCRIPT_INSTALL_WP" "wp-install-test.com"
  
  # Giải phóng biến môi trường để không ảnh hưởng các test khác (nếu có)
  unset WPTT_AUTO_CONFIRM
  
  # Kịch bản phải chạy qua hết không báo lỗi
  [ "$status" -eq 0 ]
  
  # KIỂM CHỨNG HỆ THỐNG
  
  # 1. File cốt lõi của WordPress phải tồn tại (chứng tỏ đã tải và bung nén thành công)
  [ -f "/usr/local/lsws/wp-install-test.com/html/wp-load.php" ]
  [ -d "/usr/local/lsws/wp-install-test.com/html/wp-admin" ]
  
  # 2. File wp-config.php phải được tạo thành công
  [ -f "/usr/local/lsws/wp-install-test.com/html/wp-config.php" ]
  
  # 3. Kịch bản phải tạo Basic Auth bảo vệ file install.php
  [ -f "/usr/local/lsws/wp-install-test.com/passwd/.mk-setup" ]
  
  # 4. Kiểm tra cronjob tự hủy Basic Auth (chờ 3 phút) đã được tạo chưa
  [ -f "/etc/cron.d/wp-delete-setup-bao-mat-wp-install-test.com.cron" ]
}
