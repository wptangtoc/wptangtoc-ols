#!/usr/bin/env bats

# ==============================================================================
# FILE: 00-service-health-check.bats
# MỤC ĐÍCH: dịch vụ lõi (Core Services) sau khi cài đặt.
# ==============================================================================

@test "✅ Dịch vụ Webserver OpenLiteSpeed (lsws) đang chạy (Active)" {
  run systemctl is-active lsws
  [ "$status" -eq 0 ]
  [ "$output" == "active" ]
}

@test "✅ Dịch vụ Cơ sở dữ liệu MariaDB đang chạy (Active)" {
  # Tùy hệ điều hành có thể tên service là mariadb hoặc mysql, ta check cả hai
  run bash -c "systemctl is-active mariadb || systemctl is-active mysql"
  [ "$status" -eq 0 ]
  [ "$output" == "active" ]
}

@test "✅ Cổng 80 (HTTP) đang mở và lắng nghe" {
  # Dùng lệnh ss (socket statistics) để tìm port 80 đang LISTEN
  run bash -c "ss -tln | grep -qE ':(80)\s'"
  [ "$status" -eq 0 ]
}

@test "✅ Cổng 443 (HTTPS) đang mở và lắng nghe" {
  # Dùng lệnh ss để tìm port 443 đang LISTEN
  run bash -c "ss -tln | grep -qE ':(443)\s'"
  [ "$status" -eq 0 ]
}

@test "✅ Dịch vụ LSPHP (PHP Processor) đã sẵn sàng" {
  # OpenLiteSpeed thường gọi lsphp dưới dạng tiến trình, ta check xem nó có tồn tại file nhị phân không
  run bash -c "ls -l /usr/local/lsws/lsphp*/bin/lsphp | wc -l"
  [ "$status" -eq 0 ]
  # Kết quả đếm số lượng bản PHP phải lớn hơn 0
  [ "$output" -gt 0 ]
}
