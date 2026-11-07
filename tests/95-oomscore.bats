#!/usr/bin/env bats
# @author: Gia Tuấn
# @website: https://wptangtoc.com
# @description: Kiểm thử E2E cơ chế bảo vệ OOM (Out Of Memory) phân cấp (Tương thích cả Full-Privilege & Container/Fallback)

setup_file() {
  if [[ "$EUID" -ne 0 ]]; then
    skip "Test OOM yêu cầu quyền root (EUID == 0)"
  fi

  # Tự động tìm script thiết lập OOM trong hệ thống
  for cand in \
    "/etc/wptt/oom-score" \
    "./oomscore.sh" ; do
    if [[ -f "$cand" ]]; then
      export OOM_SCRIPT="$cand"
      break
    fi
  done
}

@test "1. [Apply Check] Chạy script OOM và xác minh file systemd drop-in được khởi tạo chuẩn xác" {
  if [[ -n "${OOM_SCRIPT:-}" && -f "$OOM_SCRIPT" ]]; then
    run bash "$OOM_SCRIPT"
    [ "$status" -eq 0 ]
  fi

  # Kiểm tra MariaDB bắt buộc phải có file oom-protect.conf và có khai báo OOMScoreAdjust
  [ -f "/etc/systemd/system/mariadb.service.d/oom-protect.conf" ]
  grep -q "^OOMScoreAdjust=" "/etc/systemd/system/mariadb.service.d/oom-protect.conf"
}

@test "2. [Runtime Kernel Check] Điểm oom_score_adj của MariaDB luôn được bảo vệ tốt hơn PHP worker" {
  local mariadb_pid=""
  mariadb_pid="$(systemctl show -p MainPID --value mariadb 2>/dev/null || echo 0)"
  [ "$mariadb_pid" -gt 1 ]

  local mariadb_adj=""
  mariadb_adj="$(cat "/proc/${mariadb_pid}/oom_score_adj")"

  # Kiểm tra PHP worker (nếu đang chạy) để đối chiếu phân cấp
  local php_adj=9999
  local php_pid=""
  php_pid="$(pgrep -f "lsphp" | head -n 1 || true)"
  if [[ -n "$php_pid" ]]; then
    php_adj="$(cat "/proc/${php_pid}/oom_score_adj" 2>/dev/null || echo 9999)"
  fi

  # Đảm bảo điểm oom_score_adj của MariaDB luôn NHỎ HƠN (hoặc ưu tiên hơn) worker PHP
  [ "$mariadb_adj" -le "$php_adj" ]
}

@test "3. [Service Active Check] Đảm bảo các dịch vụ lõi vẫn hoạt động ổn định sau khi áp dụng chính sách OOM" {
  run systemctl is-active mariadb
  [ "$status" -eq 0 ]
}

@test "4. [OOM Protection Logic Verification] Kiểm tra tỷ lệ ưu tiên OOM Score thực tế giữa Database và Webserver" {
  local mariadb_pid=""
  mariadb_pid="$(systemctl show -p MainPID --value mariadb 2>/dev/null || echo 0)"
  [ "$mariadb_pid" -gt 1 ]

  # Nếu PHP worker đang chạy, điểm thực tế (oom_score) của PHP worker phải cao hơn MariaDB khi đầy RAM
  local php_pid=""
  php_pid="$(pgrep -f "lsphp" | head -n 1 || true)"
  if [[ -n "$php_pid" ]]; then
    local db_score=""
    local php_score=""
    db_score="$(cat "/proc/${mariadb_pid}/oom_score" 2>/dev/null || echo 0)"
    php_score="$(cat "/proc/${php_pid}/oom_score" 2>/dev/null || echo 0)"

    # Kernel sẽ giết tiến trình có oom_score cao hơn trước -> PHP worker phải cao hơn MariaDB
    [ "$php_score" -ge "$db_score" ]
  else
    skip "Không có tiến trình lsphp nào đang chạy để so sánh score thực tế"
  fi
}

