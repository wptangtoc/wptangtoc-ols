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
    "/etc/wptt/wptt-jemalloc-mariadb"; do
    if [[ -f "$cand" ]]; then
      export E2E_SCRIPT="$cand"
      break
    fi
  done

  if [[ -z "${E2E_SCRIPT:-}" || ! -f "$E2E_SCRIPT" ]]; then
    skip "Không tìm thấy script wptt-jemalloc-mariadb để chạy E2E"
  fi

  # Lưu lại bản sao cấu hình drop-in cũ (nếu có) để trả lại nguyên trạng sau khi test
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

@test "E2E 1. [Clean Install] Gỡ cấu hình cũ, chạy script kích hoạt jemalloc và nạp thành công vào MariaDB" {
  rm -f /etc/systemd/system/mariadb.service.d/jemalloc.conf
  systemctl daemon-reload
  systemctl restart mariadb

  run bash "$E2E_SCRIPT"
  [ "$status" -eq 0 ]

  # 1. Kiểm tra file drop-in được tạo với quyền chuẩn 644
  local dropin="/etc/systemd/system/mariadb.service.d/jemalloc.conf"
  [ -f "$dropin" ]
  [ "$(stat -c '%a' "$dropin")" = "644" ]

  # 2. Bóc tách chính xác đường dẫn sau LD_PRELOAD= và xóa sạch dấu ngoặc kép / khoảng trắng
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

  # Kiểm tra trực tiếp trong /proc/<PID>/maps của Kernel
  run grep "libjemalloc" "/proc/${pid}/maps"
  [ "$status" -eq 0 ]
}

@test "E2E 3. [SQL Verification] Truy vấn SQL SHOW VARIABLES xác nhận version_malloc_library là jemalloc" {
  if ! command -v mariadb >/dev/null 2>&1; then
    skip "Không tìm thấy lệnh client mariadb"
  fi

  run mariadb -NBe "SHOW VARIABLES LIKE 'version_malloc_library';"
  [ "$status" -eq 0 ]
  [[ "$output" == *"jemalloc"* ]]
}

@test "E2E 4. [Zero-Downtime Idempotency] Chạy lại script lần 2 KHÔNG làm thay đổi MainPID của MariaDB" {
  local pid_before=""
  local pid_after=""

  pid_before="$(systemctl show -p MainPID --value mariadb)"
  [ "$pid_before" -gt 1 ]

  run bash "$E2E_SCRIPT"
  [ "$status" -eq 0 ]

  pid_after="$(systemctl show -p MainPID --value mariadb)"
  # MainPID giữ nguyên 100% chứng tỏ MariaDB không bị restart thừa
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

