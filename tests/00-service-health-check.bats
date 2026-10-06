#!/usr/bin/env bats

# ==============================================================================
# FILE: 00-service-health-check.bats
# MỤC ĐÍCH: Kiểm tra trạng thái và sức khỏe của các dịch vụ lõi (Core Services)
#           bao gồm kiểm tra tính toàn vẹn của file cấu hình.
# ==============================================================================

# --- HÀM TIỆN ÍCH IN LỖI ---
in_log_neu_loi() {
  local ma_ky_vong="$1"
  if [ "$status" -ne "$ma_ky_vong" ]; then
      echo -e "\n[LỖI TEST] Mã thoát thực tế: $status (kỳ vọng: $ma_ky_vong)" >&3
      echo -e "Nội dung output:\n$output" >&3
  fi
}

# ==============================================================================
# NHÓM 1: OPENLITESPEED (OLS)
# ==============================================================================

@test "✅ Dịch vụ Webserver OpenLiteSpeed (lsws) đang chạy (Active)" {
  run systemctl is-active lsws
  [ "$status" -eq 0 ]
  [ "$output" == "active" ]
}

@test "✅ Cú pháp file cấu hình OpenLiteSpeed hợp lệ (Config Syntax Test)" {
  # Dùng nhị phân gốc của OLS để kiểm tra toàn bộ vhost/httpd_config
  run /usr/local/lsws/bin/openlitespeed -t
  
  if [ "$status" -ne 0 ]; then
      echo -e "\n=== LỖI CÚ PHÁP OLS ===" >&3
      echo "$output" >&3
  fi
  
  [ "$status" -eq 0 ]
  # Output thường có chữ "Syntax OK" hoặc báo lỗi cụ thể
  [[ "$output" =~ "Syntax OK" || "$output" =~ "ok" \vert{}\vert{} "$output" == *""* ]] 
}

@test "✅ Cổng 80 (HTTP) và 443 (HTTPS) đang mở và lắng nghe" {
  # Gộp check 2 cổng vào 1 bài để tiết kiệm thời gian CI
  run bash -c "ss -tln | grep -qE ':(80)\s'"
  [ "$status" -eq 0 ]
  
  run bash -c "ss -tln | grep -qE ':(443)\s'"
  [ "$status" -eq 0 ]
}

# ==============================================================================
# NHÓM 2: CƠ SỞ DỮ LIỆU MARIADB
# ==============================================================================

@test "✅ Dịch vụ Cơ sở dữ liệu MariaDB đang chạy (Active)" {
  run bash -c "systemctl is-active mariadb || systemctl is-active mysql"
  [ "$status" -eq 0 ]
  [ "$output" == "active" ]
}

@test "✅ Cấu hình my.cnf của MariaDB hợp lệ, không có tham số rác" {
  # Tự động tìm đường dẫn file nhị phân mariadbd hoặc mysqld
  local db_daemon=""
  if command -v mariadbd >/dev/null 2>&1; then db_daemon="$(command -v mariadbd)";
  elif command -v mysqld >/dev/null 2>&1; then db_daemon="$(command -v mysqld)";
  elif [ -x /usr/libexec/mariadbd ]; then db_daemon="/usr/libexec/mariadbd";
  elif [ -x /usr/sbin/mysqld ]; then db_daemon="/usr/sbin/mysqld"; fi

  if [ -z "$db_daemon" ]; then 
      skip "Không tìm thấy nhị phân mariadbd/mysqld để kiểm tra"
  fi

  # KỸ THUẬT: Ép DB đọc my.cnf và ném output thừa đi. 
  # Nếu có biến lạ (unknown variable), nó sẽ văng lỗi ra stderr.
  run bash -c "$db_daemon --help --verbose 2>&1 >/dev/null"
  
  # Đọc output. Nếu chứa từ khóa lỗi, đánh fail ngay.
  if [[ -n "$output" && "$output" =~ (error|unknown[[:space:]]variable|warning) ]]; then
      echo -e "\n=== LỖI CẤU HÌNH MARIADB (my.cnf) ===" >&3
      echo "$output" >&3
      false
  fi
  [ "$status" -eq 0 ]
}

# ==============================================================================
# NHÓM 3: PHP & MODULES (LSPHP)
# ==============================================================================

@test "✅ Dịch vụ LSPHP (PHP Processor) đã sẵn sàng" {
  run bash -c "ls -l /usr/local/lsws/lsphp*/bin/lsphp | wc -l"
  [ "$status" -eq 0 ]
  [ "$output" -gt 0 ]
}

@test "✅ Cấu hình php.ini và các Module (.so) không bị lỗi, cảnh báo hay Fatal Error" {
  # Quét qua toàn bộ các phiên bản lsphp đang được cài trên hệ thống
  local php_bins=(/usr/local/lsws/lsphp*/bin/lsphp)
  local has_error=0

  for php_bin in "${php_bins[@]}"; do
      if [ -x "$php_bin" ]; then
          # KỸ THUẬT: Lệnh `php -v` sẽ nạp php.ini và toàn bộ extension. 
          # Ta pipe qua grep. Nếu grep TÌM THẤY lỗi (exit code 0), bài test SẼ FAIL.
          run bash -c "$php_bin -v 2>&1 | grep -iE 'warning|error|exception|fatal'"
          
          # Status = 0 nghĩa là grep ĐÃ BẮT ĐƯỢC từ khóa lỗi
          if [ "$status" -eq 0 ]; then
              echo -e "\n=== LỖI MODULE/PHP.INI TẠI PHIÊN BẢN: $php_bin ===" >&3
              echo "$output" >&3
              has_error=1
          fi
      fi
  done

  # Đánh dấu tổng kết
  [ "$has_error" -eq 0 ]
}

# ==============================================================================
# NHÓM 4: KIỂM THỬ XỬ LÝ REQUEST THỰC TẾ (E2E HTTP)
# ==============================================================================

@test "✅ Website github.wptangtoc.com (CI Test) đã nhận diện đúng HTML tĩnh" {
  run bash -c "echo 'GiaTuanDz' > /usr/local/lsws/github.wptangtoc.com/html/bats-test.html"
  [ "$status" -eq 0 ]

  run bash -c "curl -m 5 -sS -H 'Host: github.wptangtoc.com' http://127.0.0.1/bats-test.html"
  rm -f /usr/local/lsws/github.wptangtoc.com/html/bats-test.html
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" == "GiaTuanDz" ]]
}

@test "✅ Website github.wptangtoc.com (CI Test) đã thực thi chính xác file PHP (CGI/LSAPI)" {
  run bash -c "echo '<?php echo \"GiaTuan_\" . \"PHP_Active\"; ?>' > /usr/local/lsws/github.wptangtoc.com/html/bats-test.php"
  [ "$status" -eq 0 ]

  run bash -c "curl -m 5 -sS -H 'Host: github.wptangtoc.com' http://127.0.0.1/bats-test.php"
  rm -f /usr/local/lsws/github.wptangtoc.com/html/bats-test.php
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" == "GiaTuan_PHP_Active" ]]
}

@test "✅ Website github.wptangtoc.com (CI Test) thực thi thành công mã PHP CLI qua User riêng" {
  local doc_root="/usr/local/lsws/github.wptangtoc.com/html"
  local test_file="$doc_root/bats-test.php"

  local vhost_user
  vhost_user=$(stat -c '\%U' "$doc_root")

  run bash -c "echo '<?php echo \"GiaTuanDz_PHP_CLI\"; ?>' > $test_file"
  [ "$status" -eq 0 ]
  
  run bash -c "chown $vhost_user$test_file"

  run bash -c "sudo -u $vhost_user /usr/local/lsws/lsphp*/bin/lsphp$test_file"
  rm -f -- "$test_file"
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" == *"GiaTuanDz_PHP_CLI"* ]]
}

