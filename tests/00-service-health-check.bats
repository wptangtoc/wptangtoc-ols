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

@test "✅ Website github.wptangtoc.com (CI Test) đã nhận diện đúng nội dung Document" {
  # 1. Tạo file tĩnh độc lập để né xử lý PHP/MySQL nặng nề trên CI
  run bash -c "echo 'GiaTuanDz' > /usr/local/lsws/github.wptangtoc.com/html/bats-test.html"
  [ "$status" -eq 0 ]

  # 2. Curl vào cổng 80 qua localhost để xác minh OLS trả về đúng nội dung
  run bash -c "curl -m 5 -sS -H 'Host: github.wptangtoc.com' http://127.0.0.1/bats-test.html"
  
  # 3. CHỐT CHẶN DỌN DẸP: Xóa luôn file ngay khi curl xong (tránh BATS ngắt ngang không kịp xóa)
  rm -f /usr/local/lsws/github.wptangtoc.com/html/bats-test.html
  
  if [ "$status" -ne 0 ]; then
      echo -e "\n=== LỖI CURL ===" >&3
      echo "Mã thoát: $status | Output: $output" >&3
  fi

  # 4. Chấm điểm đúng/sai
  [ "$status" -eq 0 ]
  # Nếu output đúng bằng chữ GiaTuanDz chứng tỏ domain đã được thêm hoàn hảo
  [[ "$output" == "GiaTuanDz" ]]
}

@test "✅ Website github.wptangtoc.com (CI Test) thực thi mã PHP CLI" {
  local doc_root="/usr/local/lsws/github.wptangtoc.com/html"
  local test_file="$doc_root/bats-test.php"

  # 1. Lấy thông tin username chủ sở hữu của website
  local vhost_user
  vhost_user=$(stat -c '%U' "$doc_root")

  # 2. Tạo file PHP tĩnh độc lập để test
  run bash -c "echo '<?php echo \"GiaTuanDz_PHP_CLI\"; ?>' > $test_file"
  [ "$status" -eq 0 ]
  
  # Cấp quyền đúng cho file để lệnh sudo phía sau có thể đọc được
  run bash -c "chown $vhost_user $test_file"

  # 3. Thực thi trực tiếp qua lsphp CLI dưới quyền của user website
  # Dùng lsphp* để tự động nhận diện phiên bản PHP (vd: lsphp81, lsphp83...)
  run bash -c "sudo -u $vhost_user /usr/local/lsws/lsphp*/bin/lsphp $test_file"
  
  # 4. CHỐT CHẶN DỌN DẸP: Xóa file ngay sau khi chạy xong
  rm -f -- "$test_file"
  
  if [ "$status" -ne 0 ]; then
      echo -e "\n=== LỖI PHP CLI ===" >&3
      echo "Mã thoát: $status | Output: $output" >&3
  fi

  # 5. Chấm điểm đúng/sai
  [ "$status" -eq 0 ]
  # Kiểm tra xem kết quả in ra có chứa chuỗi mong muốn không
  [[ "$output" == *"GiaTuanDz_PHP_CLI"* ]]
}
