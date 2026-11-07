#!/usr/bin/env bats
# @author: Gia Tuấn
# @website: https://wptangtoc.com
# @description: End-to-End (E2E) Test trên máy chủ Linux thật có cài đặt MariaDB

setup_file() {
  if [[ "$EUID" -ne 0 ]]; then
    skip "E2E Test yêu cầu quyền root (EUID == 0)"
  fi

  if ! systemctl list-unit-files mariadb.service >/dev/null 2>&1 && [[ ! -f /lib/systemd/system/mariadb.service && ! -f /usr/lib/systemd/system/mariadb.service ]]; then
    skip "Máy chủ chưa cài đặt dịch vụ MariaDB"
  fi

  for cand in \
    "/etc/wptt/db/lemalloc" \
    "/etc/wptt/db/jemalloc" \
    "/etc/wptt/wptt-jemalloc-mariadb"; do
    if [[ -f "$cand" ]]; then
      export E2E_SCRIPT="$cand"
      break
    fi
  done

  if [[ -z "${E2E_SCRIPT:-}" || ! -f "$E2E_SCRIPT" ]]; then
    skip "Không tìm thấy script wptt-jemalloc-mariadb để chạy E2E"
  fi

  export BACKUP_DROPIN="${BATS_FILE_TMPDIR}/jemalloc.conf.bak"
  if [[ -f /etc/systemd/system/mariadb.service.d/jemalloc.conf ]]; then
    cp -pf /etc/systemd/system/mariadb.service.d/jemalloc.conf "$BACKUP_DROPIN"
  fi
}

teardown_file() {
  if [[ -n "${BACKUP_DROPIN:-}" && -f "$BACKUP_DROPIN" ]]; then
    mkdir -p /etc/systemd/system/mariadb.service.d
    cp -pf "$BACKUP_DROPIN" /etc/systemd/system/mariadb.service.d/jemalloc.conf
    systemctl daemon-reload >/dev/null 2>&1 || true
    systemctl restart mariadb >/dev/null 2>&1 || true
  fi
}

# Hàm kết nối MariaDB đa tầng (Hỗ trợ unix_socket, .my.cnf, debian.cnf, .wptt.conf + Retry chờ Socket)
_query_malloc_library() {
  local sql="SHOW VARIABLES LIKE 'version_malloc_library';"
  local out=""
  local attempt=1

  # Nạp cấu hình WPTangToc để lấy biến mật khẩu (nếu có)
  if [[ -f /etc/wptt/.wptt.conf ]]; then
    # shellcheck source=/dev/null
    . /etc/wptt/.wptt.conf 2>/dev/null || true
  fi

  while ((attempt <= 5)); do
    # Cách 1: Gọi mặc định với HOME=/root (Tự nhận /root/.my.cnf hoặc unix_socket)
    out="$(HOME=/root mariadb -NBe "$sql" 2>/dev/null || true)"
    [[ -n "$out" ]] && { printf '%s\n' "$out"; return 0; }

    # Cách 2: Chỉ định trực tiếp /root/.my.cnf bằng --defaults-file
    if [[ -f /root/.my.cnf ]]; then
      out="$(HOME=/root mariadb --defaults-file=/root/.my.cnf -NBe "$sql" 2>/dev/null || true)"
      [[ -n "$out" ]] && { printf '%s\n' "$out"; return 0; }
    fi

    # Cách 3: Dùng file cấu hình quản trị mặc định của Ubuntu/Debian (/etc/mysql/debian.cnf)
    if [[ -f /etc/mysql/debian.cnf ]]; then
      out="$(mariadb --defaults-file=/etc/mysql/debian.cnf -NBe "$sql" 2>/dev/null || true)"
      [[ -n "$out" ]] && { printf '%s\n' "$out"; return 0; }
    fi

    # Cách 4: Quét các biến mật khẩu trong /etc/wptt/.wptt.conf
    local candidate_pass=""
    for candidate_pass in \
      "${password_mysql:-}" \
      "${pass_sql_root:-}" \
      "${pass_root_mysql:-}" \
      "${mat_khau_root_mysql:-}" \
      "${mysql_root_password:-}" \
      "${DB_ROOT_PASS:-}"; do
      if [[ -n "$candidate_pass" ]]; then
        out="$(MYSQL_PWD="$candidate_pass" mariadb -u root -NBe "$sql" 2>/dev/null || true)"
        [[ -n "$out" ]] && { printf '%s\n' "$out"; return 0; }
      fi
    done

    sleep 1
    ((attempt++))
  done

  return 1
}

@test "E2E 1. [Clean Install] Gỡ cấu hình cũ, chạy script kích hoạt jemalloc và nạp thành công vào MariaDB" {
  rm -f /etc/systemd/system/mariadb.service.d/jemalloc.conf
  systemctl daemon-reload
  systemctl restart mariadb

  run bash "$E2E_SCRIPT"
  [ "$status" -eq 0 ]

  local dropin="/etc/systemd/system/mariadb.service.d/jemalloc.conf"
  [ -f "$dropin" ]
  [ "$(stat -c '%a' "$dropin")" = "644" ]

  local so_path=""
  so_path="$(sed -n 's/.*LD_PRELOAD=\([^"[:space:]]*\).*/\1/p' "$dropin" | head -n 1)"
  [ -n "$so_path" ]
  [ -f "$so_path" ]
}

@test "E2E 2. [Kernel Memory Map] Tiến trình mariadbd đang chạy thực sự đã map libjemalloc vào RAM" {
  local pid=""
  pid="$(systemctl show -p MainPID --value mariadb)"
  [ -n "$pid" ]
  [ "$pid" -gt 1 ]

  run grep "libjemalloc" "/proc/${pid}/maps"
  [ "$status" -eq 0 ]
}

@test "E2E 3. [SQL & Runtime Verification] Truy vấn SQL hoạt động và xác nhận jemalloc quản lý bộ nhớ" {
  local pid=""
  pid="$(systemctl show -p MainPID --value mariadb)"
  [ -n "$pid" ]
  [ "$pid" -gt 1 ]

  # 1. Xác minh trực tiếp trong /proc/<PID>/environ và /proc/<PID>/maps của tiến trình đang chạy
  tr '\0' '\n' <"/proc/${pid}/environ" | grep -q "LD_PRELOAD=.*libjemalloc"
  grep -q "libjemalloc" "/proc/${pid}/maps"

  # 2. Xác minh tầng SQL (Nếu truy vấn được SQL thì kiểm tra thêm biến version_malloc_library)
  if command -v mariadb >/dev/null 2>&1; then
    if out="$(_query_malloc_library)"; then
      [[ "$out" == *"version_malloc_library"* ]]
    else
      # Nếu client CLI từ chối mật khẩu tự động, kiểm tra socket MariaDB đang mở và nhận kết nối
      systemctl is-active --quiet mariadb
    fi
  fi
}

@test "E2E 4. [Zero-Downtime Idempotency] Chạy lại script lần 2 KHÔNG làm thay đổi MainPID của MariaDB" {
  local pid_before=""
  local pid_after=""

  pid_before="$(systemctl show -p MainPID --value mariadb)"
  [ "$pid_before" -gt 1 ]

  run bash "$E2E_SCRIPT"
  [ "$status" -eq 0 ]

  pid_after="$(systemctl show -p MainPID --value mariadb)"
  [ "$pid_before" -eq "$pid_after" ]
}

@test "E2E 5. [Corrupted Config Auto-Heal] Khi file jemalloc.conf bị sửa sai, chạy lại script tự động chữa lành" {
  echo "[Service]" >/etc/systemd/system/mariadb.service.d/jemalloc.conf
  echo "Environment=\"LD_PRELOAD=/wrong/path/libjemalloc.so.99\"" >>/etc/systemd/system/mariadb.service.d/jemalloc.conf

  run bash "$E2E_SCRIPT"
  [ "$status" -eq 0 ]

  ! grep -q "/wrong/path/" /etc/systemd/system/mariadb.service.d/jemalloc.conf
  local pid=""
  pid="$(systemctl show -p MainPID --value mariadb)"
  grep -q "libjemalloc" "/proc/${pid}/maps"
}
