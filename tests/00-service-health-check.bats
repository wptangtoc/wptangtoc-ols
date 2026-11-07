#!/usr/bin/env bats
# ==============================================================================
# FILE: 00-service-health-check.bats
# MỤC ĐÍCH: Kiểm tra trạng thái và sức khỏe của các dịch vụ lõi (Core Services)
#           bao gồm kiểm tra tính toàn vẹn của file cấu hình và E2E HTTP/PHP/DB.
# ==============================================================================

export LC_ALL=C.UTF-8 2>/dev/null || export LC_ALL=en_US.UTF-8 2>/dev/null || true
export LANG=C.UTF-8 2>/dev/null || export LANG=en_US.UTF-8 2>/dev/null || true

setup() {
  export TEST_DOMAIN="github.wptangtoc.com"
  export TEST_DOCROOT="/usr/local/lsws/${TEST_DOMAIN}/html"
  export TEST_HTML_FILE="${TEST_DOCROOT}/bats-test.html"
  export TEST_PHP_FILE="${TEST_DOCROOT}/bats-test.php"
}

# Tự động dọn dẹp file test kể cả khi bài test bị fail giữa chừng
teardown() {
  rm -f -- "${TEST_HTML_FILE:-}" "${TEST_PHP_FILE:-}" 2>/dev/null || true
}

# --- HÀM TIỆN ÍCH IN LỖI ---
in_log_neu_loi() {
  local ma_ky_vong="$1"
  if [[ "$status" -ne "$ma_ky_vong" ]]; then
    printf '\n[LỖI TEST] Mã thoát thực tế: %s (kỳ vọng: %s)\n' "$status" "$ma_ky_vong" >&3
    printf 'Nội dung output:\n%s\n' "$output" >&3
  fi
}

# ==============================================================================
# NHÓM 1: OPENLITESPEED (OLS)
# ==============================================================================

@test "✅ Dịch vụ Webserver OpenLiteSpeed (lsws) đang chạy (Active)" {
  run systemctl is-active lsws
  in_log_neu_loi 0
  [[ "$status" -eq 0 ]]
  [[ "$output" == "active" ]]
}

@test "✅ Cú pháp file cấu hình OpenLiteSpeed hợp lệ (Config Syntax Test)" {
  run /usr/local/lsws/bin/openlitespeed -t
  in_log_neu_loi 0
  [[ "$status" -eq 0 ]]
  [[ "$output" =~ "Syntax OK" || "$output" =~ "ok" || -z "$output" ]]
}

@test "✅ Cổng 80 (HTTP) và 443 (HTTPS) đang mở và lắng nghe" {
  local ss_out=""
  ss_out="$(ss -tln)"

  if ! grep -qE ':80[[:space:]]' <<<"$ss_out"; then
    printf '\n[LỖI] Cổng 80 không lắng nghe!\n%s\n' "$ss_out" >&3
    return 1
  fi

  if ! grep -qE ':443[[:space:]]' <<<"$ss_out"; then
    printf '\n[LỖI] Cổng 443 không lắng nghe!\n%s\n' "$ss_out" >&3
    return 1
  fi
}

# ==============================================================================
# NHÓM 2: CƠ SỞ DỮ LIỆU MARIADB
# ==============================================================================

@test "✅ Dịch vụ Cơ sở dữ liệu MariaDB đang chạy và phản hồi Ping" {
  if ! systemctl is-active --quiet mariadb 2>/dev/null && ! systemctl is-active --quiet mysql 2>/dev/null; then
    printf '\n[LỖI] Service mariadb/mysql không ở trạng thái active!\n' >&3
    return 1
  fi

  # Kiểm tra thêm phản hồi thực tế qua Unix Socket (tránh trường hợp systemd active nhưng DB bị treo deadlock)
  if command -v mariadb-admin >/dev/null 2>&1; then
    run mariadb-admin ping --connect-timeout=3
    # Ngay cả khi bị từ chối quyền (Access denied) thì vẫn chứng tỏ mysqld daemon đang sống và phản hồi
    [[ "$status" -eq 0 || "$output" == *"alive"* || "$output" == *"Access denied"* ]]
  fi
}

@test "✅ Cấu hình my.cnf của MariaDB hợp lệ, không có tham số rác" {
  local db_daemon=""
  if command -v mariadbd >/dev/null 2>&1; then
    db_daemon="$(command -v mariadbd)"
  elif command -v mysqld >/dev/null 2>&1; then
    db_daemon="$(command -v mysqld)"
  elif [[ -x /usr/libexec/mariadbd ]]; then
    db_daemon="/usr/libexec/mariadbd"
  elif [[ -x /usr/sbin/mysqld ]]; then
    db_daemon="/usr/sbin/mysqld"
  fi

  if [[ -z "$db_daemon" ]]; then
    skip "Không tìm thấy nhị phân mariadbd/mysqld để kiểm tra"
  fi

  # Chỉ thu thập stderr (bỏ qua stdout của --help --verbose)
  run bash -c "\"$db_daemon\" --help --verbose 2>&1 >/dev/null"

  if [[ -n "$output" ]] && grep -qiE '(\[ERROR\]|unknown variable|unknown option|fatal error)' <<<"$output"; then
    printf '\n=== LỖI CẤU HÌNH MARIADB (my.cnf) ===\n%s\n' "$output" >&3
    return 1
  fi
  [[ "$status" -eq 0 ]]
}

# ==============================================================================
# NHÓM 3: PHP & MODULES (LSPHP)
# ==============================================================================

@test "✅ Dịch vụ LSPHP (PHP Processor) đã sẵn sàng" {
  shopt -s nullglob
  local php_bins=(/usr/local/lsws/lsphp*/bin/lsphp)
  shopt -u nullglob

  if (( ${#php_bins[@]} == 0 )); then
    printf '\n[LỖI] Không tìm thấy bất kỳ nhị phân lsphp nào trong /usr/local/lsws/lsphp*/bin/lsphp\n' >&3
    return 1
  fi
}

@test "✅ Cấu hình php.ini và các Module (.so) không bị lỗi, cảnh báo hay Fatal Error" {
  shopt -s nullglob
  local php_bins=(/usr/local/lsws/lsphp*/bin/lsphp)
  shopt -u nullglob

  [[ ${#php_bins[@]} -gt 0 ]]
  local has_error=0 php_bin err_msg

  for php_bin in "${php_bins[@]}"; do
    if [[ -x "$php_bin" ]]; then
      err_msg="$("$php_bin" -v 2>&1 | grep -iE 'warning|error|exception|fatal|unable to load' || true)"
      if [[ -n "$err_msg" ]]; then
        printf '\n=== LỖI MODULE/PHP.INI TẠI PHIÊN BẢN: %s ===\n%s\n' "$php_bin" "$err_msg" >&3
        has_error=1
      fi
    fi
  done

  [[ "$has_error" -eq 0 ]]
}

# ==============================================================================
# NHÓM 4: KIỂM THỬ XỬ LÝ REQUEST THỰC TẾ (E2E HTTP & PHP CLI)
# ==============================================================================

@test "✅ Website ${TEST_DOMAIN} (CI Test) đã nhận diện đúng HTML tĩnh" {
  [[ -d "$TEST_DOCROOT" ]] || skip "Không có thư mục $TEST_DOCROOT"

  printf 'GiaTuanDz' >"$TEST_HTML_FILE"
  run curl -m 5 -sS -H "Host: ${TEST_DOMAIN}" "http://127.0.0.1/bats-test.html"

  in_log_neu_loi 0
  [[ "$status" -eq 0 ]]
  [[ "$output" == "GiaTuanDz" ]]
}

@test "✅ Website ${TEST_DOMAIN} (CI Test) đã thực thi chính xác file PHP (CGI/LSAPI)" {
  [[ -d "$TEST_DOCROOT" ]] || skip "Không có thư mục $TEST_DOCROOT"

  printf '<?php echo "GiaTuan_" . "PHP_Active"; ?>' >"$TEST_PHP_FILE"
  local vhost_user
  vhost_user="$(stat -c '%U:%G' "$TEST_DOCROOT")"
  chown "$vhost_user" "$TEST_PHP_FILE"

  run curl -m 5 -sS -H "Host: ${TEST_DOMAIN}" "http://127.0.0.1/bats-test.php"

  in_log_neu_loi 0
  [[ "$status" -eq 0 ]]
  [[ "$output" == "GiaTuan_PHP_Active" ]]
}

@test "✅ Website ${TEST_DOMAIN} (CI Test) thực thi thành công mã PHP CLI qua User riêng" {
  [[ -d "$TEST_DOCROOT" ]] || skip "Không có thư mục $TEST_DOCROOT"

  local vhost_user vhost_group
  vhost_user="$(stat -c '%U' "$TEST_DOCROOT")"
  vhost_group="$(stat -c '%G' "$TEST_DOCROOT")"

  # Chọn đúng 1 nhị phân lsphp (ưu tiên /usr/bin/php hoặc bản lsphp mới nhất) để tránh lỗi bung mảng '*'
  shopt -s nullglob
  local php_bins=(/usr/local/lsws/lsphp*/bin/lsphp)
  shopt -u nullglob
  [[ ${#php_bins[@]} -gt 0 ]]
  local target_php="${php_bins[-1]}"

  printf '<?php echo "GiaTuanDz_PHP_CLI:" . get_current_user(); ?>' >"$TEST_PHP_FILE"
  chown "${vhost_user}:${vhost_group}" "$TEST_PHP_FILE"

  run sudo -u "$vhost_user" "$target_php" "$TEST_PHP_FILE"

  in_log_neu_loi 0
  [[ "$status" -eq 0 ]]
  [[ "$output" == *"GiaTuanDz_PHP_CLI:${vhost_user}"* ]]
}
