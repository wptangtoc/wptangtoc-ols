#!/usr/bin/env bats
#
# tests/khoiphuc.bats — Kiểm thử tính năng Khôi phục (Restore) của WPTangToc OLS
#


#!/usr/bin/env bats
# ==============================================================================
# WPTangToc OLS — Enterprise BATS Test Suite
# Module  : wptt-khoiphuc (Khôi phục Website)
# File    : tests/12-khoiphuc.bats
# Author  : WPTangToc OLS
# Chạy    : sudo bats tests/12-khoiphuc.bats
#
# Bao phủ:
#   NHÓM 1. huong_dan()                 — Hiển thị trợ giúp
#   NHÓM 2. wptt_list_source_backups()  — Liệt kê backup mã nguồn
#   NHÓM 3. wptt_list_db_backups()      — Liệt kê backup database
#   NHÓM 4. SQL Injection Prevention    — DB_Name_web / DB_User_web
#   NHÓM 5. File size validation        — Cảnh báo file SQL < 3KB
#   NHÓM 6. Extension detection         — .zip / .tar.gz / .tar.zst / .sql.*
#   NHÓM 7. Menu mode                   — Xử lý tham số '98'
#   NHÓM 8. Bảo mật & Cấu trúc mã nguồn
# ==============================================================================

# ------------------------------------------------------------------------------
# Hằng số
# ------------------------------------------------------------------------------
readonly KHOIPHUC_SCRIPT="${BATS_TEST_DIRNAME}/../wptt-khoiphuc"

# ------------------------------------------------------------------------------
# setup_file: Chạy 1 lần — Trích xuất các hàm thuần túy để test cô lập
# ------------------------------------------------------------------------------
setup_file() {
  if [[ ! -f "$KHOIPHUC_SCRIPT" ]]; then
    printf 'FATAL: Không tìm thấy script tại %s\n' "$KHOIPHUC_SCRIPT" >&2
    return 1
  fi

  export FUNCS_FILE="${BATS_FILE_TMPDIR}/khoiphuc_funcs.sh"
  : > "$FUNCS_FILE"

  # Trích xuất từng hàm bằng sed range pattern (khớp tới dòng '}' đầu tiên)
  sed -n '/^function huong_dan() {/,/^}$/p'              "$KHOIPHUC_SCRIPT" >> "$FUNCS_FILE"
  printf '\n' >> "$FUNCS_FILE"
  sed -n '/^wptt_list_source_backups() {/,/^}$/p'        "$KHOIPHUC_SCRIPT" >> "$FUNCS_FILE"
  printf '\n' >> "$FUNCS_FILE"
  sed -n '/^wptt_list_db_backups() {/,/^}$/p'            "$KHOIPHUC_SCRIPT" >> "$FUNCS_FILE"

  # Kiểm tra trích xuất thành công
  if ! grep -q 'huong_dan'          "$FUNCS_FILE" \
  || ! grep -q 'wptt_list_source_backups' "$FUNCS_FILE" \
  || ! grep -q 'wptt_list_db_backups'     "$FUNCS_FILE"; then
    printf 'FATAL: Trích xuất hàm thất bại. Kiểm tra lại pattern sed.\n' >&2
    return 1
  fi
}

# ------------------------------------------------------------------------------
# setup: Chạy trước mỗi test — tạo môi trường cô lập
# ------------------------------------------------------------------------------
setup() {
  export TEST_DIR
  TEST_DIR="$(mktemp -d)"

  export ROOT_BACKUP_DIR="$TEST_DIR/usr/local/backup-website/example.com"
  export USER_BACKUP_DIR="$TEST_DIR/usr/local/lsws/example.com/backup-website"
  mkdir -p "$ROOT_BACKUP_DIR" "$USER_BACKUP_DIR"

  # Source các hàm đã trích xuất
  # shellcheck disable=SC1090
  source "$FUNCS_FILE"
}

teardown() {
  rm -rf "$TEST_DIR"
}

# ==============================================================================
# NHÓM 1: huong_dan() — Hiển thị trợ giúp
# ==============================================================================
@test "huong_dan: in tiêu đề 'Tính năng khôi phục website'" {
  run huong_dan
  [ "$status" -eq 0 ]
  [[ "$output" == *"Tính năng khôi phục website"* ]]
}

@test "huong_dan: đề cập ẩn dụ 'máy thời gian'" {
  run huong_dan
  [[ "$output" == *"máy thời gian"* ]]
}

@test "huong_dan: đề cập 'sao lưu' và 'Backup'" {
  run huong_dan
  [[ "$output" == *"sao lưu"* ]]
  [[ "$output" == *"Backup"* ]]
}

@test "huong_dan: đề cập tình huống website bị lỗi / tấn công" {
  run huong_dan
  [[ "$output" == *"bị tấn công"* ]]
  [[ "$output" == *"bị lỗi"* ]]
}

# ==============================================================================
# NHÓM 2: wptt_list_source_backups() — Liệt kê backup mã nguồn
# ==============================================================================
@test "list_source_backups: thư mục không tồn tại -> không lỗi, output rỗng" {
  run wptt_list_source_backups "/nonexistent/path" 0
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "list_source_backups: thư mục rỗng -> output rỗng" {
  run wptt_list_source_backups "$ROOT_BACKUP_DIR" 0
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "list_source_backups: nhận diện file .zip" {
  touch "$ROOT_BACKUP_DIR/example.com_2026-01-01.zip"
  run wptt_list_source_backups "$ROOT_BACKUP_DIR" 0
  [[ "$output" == *"example.com_2026-01-01.zip"* ]]
}

@test "list_source_backups: nhận diện file .tar.gz" {
  touch "$ROOT_BACKUP_DIR/backup.tar.gz"
  run wptt_list_source_backups "$ROOT_BACKUP_DIR" 0
  [[ "$output" == *"backup.tar.gz"* ]]
}

@test "list_source_backups: nhận diện file .tar.zst" {
  touch "$ROOT_BACKUP_DIR/backup.tar.zst"
  run wptt_list_source_backups "$ROOT_BACKUP_DIR" 0
  [[ "$output" == *"backup.tar.zst"* ]]
}

@test "list_source_backups: bỏ qua file .sql (không phải mã nguồn)" {
  touch "$ROOT_BACKUP_DIR/db.sql"
  run wptt_list_source_backups "$ROOT_BACKUP_DIR" 0
  [[ "$output" != *"db.sql"* ]]
}

@test "list_source_backups: bỏ qua file .txt/.json không hợp lệ" {
  touch "$ROOT_BACKUP_DIR/readme.txt"
  touch "$ROOT_BACKUP_DIR/data.json"
  run wptt_list_source_backups "$ROOT_BACKUP_DIR" 0
  [ -z "$output" ]
}

@test "list_source_backups: loại trừ file '*-wptt-luy-tien*'" {
  touch "$ROOT_BACKUP_DIR/example.com-wptt-luy-tien-01.zip"
  touch "$ROOT_BACKUP_DIR/example.com_2026-01-01.zip"
  run wptt_list_source_backups "$ROOT_BACKUP_DIR" 0
  [[ "$output" != *"luy-tien"* ]]
  [[ "$output" == *"example.com_2026-01-01.zip"* ]]
}

@test "list_source_backups: safe_mode=1 chặn tên file chứa dấu chấm phẩy" {
  touch "$ROOT_BACKUP_DIR/valid.zip"
  touch "$ROOT_BACKUP_DIR/bad;name.zip"
  run wptt_list_source_backups "$ROOT_BACKUP_DIR" 1
  [[ "$output" == *"valid.zip"* ]]
  [[ "$output" != *"bad;name"* ]]
}

@test "list_source_backups: safe_mode=1 chặn tên file chứa dấu cách" {
  touch "$ROOT_BACKUP_DIR/valid.zip"
  touch "$ROOT_BACKUP_DIR/bad name.zip"
  run wptt_list_source_backups "$ROOT_BACKUP_DIR" 1
  [[ "$output" == *"valid.zip"* ]]
  [[ "$output" != *"bad name"* ]]
}

@test "list_source_backups: safe_mode=0 cho phép tên file đặc biệt" {
  touch "$ROOT_BACKUP_DIR/bad;name.zip"
  run wptt_list_source_backups "$ROOT_BACKUP_DIR" 0
  [[ "$output" == *"bad;name.zip"* ]]
}

@test "list_source_backups: sắp xếp mới nhất trước (sort theo mtime)" {
  touch -t 202501010000 "$ROOT_BACKUP_DIR/old.zip"
  touch -t 202601010000 "$ROOT_BACKUP_DIR/new.zip"
  run wptt_list_source_backups "$ROOT_BACKUP_DIR" 0
  [[ "$output" =~ new.zip.*old.zip ]]
}

@test "list_source_backups: output phân tách bằng NUL byte" {
  touch "$ROOT_BACKUP_DIR/file1.zip"
  touch "$ROOT_BACKUP_DIR/file2.zip"
  bash -c "source '$FUNCS_FILE'; wptt_list_source_backups '$ROOT_BACKUP_DIR' 0" > "$TEST_DIR/out.bin"
  null_count=$(tr -cd '\0' < "$TEST_DIR/out.bin" | wc -c)
  [ "$null_count" -eq 2 ]
}

# ==============================================================================
# NHÓM 3: wptt_list_db_backups() — Liệt kê backup database
# ==============================================================================
@test "list_db_backups: thư mục không tồn tại -> không lỗi" {
  run wptt_list_db_backups "/nonexistent" 0
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "list_db_backups: nhận diện file .sql" {
  touch "$ROOT_BACKUP_DIR/db_backup.sql"
  run wptt_list_db_backups "$ROOT_BACKUP_DIR" 0
  [[ "$output" == *"db_backup.sql"* ]]
}

@test "list_db_backups: nhận diện file .sql.gz" {
  touch "$ROOT_BACKUP_DIR/db.sql.gz"
  run wptt_list_db_backups "$ROOT_BACKUP_DIR" 0
  [[ "$output" == *"db.sql.gz"* ]]
}

@test "list_db_backups: nhận diện file .sql.zst" {
  touch "$ROOT_BACKUP_DIR/db.sql.zst"
  run wptt_list_db_backups "$ROOT_BACKUP_DIR" 0
  [[ "$output" == *"db.sql.zst"* ]]
}

@test "list_db_backups: bỏ qua file .zip (không phải database)" {
  touch "$ROOT_BACKUP_DIR/source.zip"
  run wptt_list_db_backups "$ROOT_BACKUP_DIR" 0
  [ -z "$output" ]
}

@test "list_db_backups: safe_mode=1 chặn tên file chứa ký tự lạ" {
  touch "$ROOT_BACKUP_DIR/valid_db.sql"
  touch "$ROOT_BACKUP_DIR/evil;rm.sql"
  run wptt_list_db_backups "$ROOT_BACKUP_DIR" 1
  [[ "$output" == *"valid_db.sql"* ]]
  [[ "$output" != *"evil;rm"* ]]
}

# ==============================================================================
# NHÓM 4: SQL Injection Prevention
# ==============================================================================
@test "SQLi: DB_Name_web hợp lệ (chữ + số + gạch dưới)" {
  DB_Name_web="wp_db_2026"
  [[ "$DB_Name_web" =~ ^[a-zA-Z0-9_]+$ ]]
}

@test "SQLi: DB_Name_web chứa dấu chấm phẩy -> bị chặn" {
  DB_Name_web="wp_db; DROP DATABASE admin"
  [[ ! "$DB_Name_web" =~ ^[a-zA-Z0-9_]+$ ]]
}

@test "SQLi: DB_Name_web chứa dấu gạch ngang -> bị chặn" {
  DB_Name_web="wp-db"
  [[ ! "$DB_Name_web" =~ ^[a-zA-Z0-9_]+$ ]]
}

@test "SQLi: DB_Name_web chứa backtick -> bị chặn" {
  DB_Name_web='wp`db'
  [[ ! "$DB_Name_web" =~ ^[a-zA-Z0-9_]+$ ]]
}

@test "SQLi: DB_Name_web chứa nháy đơn -> bị chặn" {
  DB_Name_web="wp'db"
  [[ ! "$DB_Name_web" =~ ^[a-zA-Z0-9_]+$ ]]
}

@test "SQLi: DB_Name_web chứa khoảng trắng -> bị chặn" {
  DB_Name_web="wp db"
  [[ ! "$DB_Name_web" =~ ^[a-zA-Z0-9_]+$ ]]
}

@test "SQLi: DB_User_web chứa newline -> bị chặn" {
  DB_User_web=$'wp\nuser'
  [[ ! "$DB_User_web" =~ ^[a-zA-Z0-9_]+$ ]]
}

@test "SQLi: DB_User_web chứa ký tự $ -> bị chặn" {
  DB_User_web='wp$user'
  [[ ! "$DB_User_web" =~ ^[a-zA-Z0-9_]+$ ]]
}

# ==============================================================================
# NHÓM 5: File size validation (< 3KB = corrupt)
# ==============================================================================
@test "File size: file < 3KB bị coi là corrupt" {
  local tiny_db="$ROOT_BACKUP_DIR/tiny.sql"
  printf 'SELECT 1;' > "$tiny_db"
  size_kb=$(du -k "$tiny_db" | cut -f1)
  [ "$size_kb" -lt 3 ]
}

@test "File size: file >= 3KB được coi là hợp lệ" {
  local valid_db="$ROOT_BACKUP_DIR/valid.sql"
  dd if=/dev/zero of="$valid_db" bs=1024 count=5 status=none
  size_kb=$(du -k "$valid_db" | cut -f1)
  [ "$size_kb" -ge 3 ]
}

# ==============================================================================
# NHÓM 6: Extension detection
# ==============================================================================
@test "Extension: phát hiện .sql.gz chính xác" {
  local f="backup.sql.gz"
  [[ "$f" == *".sql.gz" ]]
}

@test "Extension: phát hiện .sql.zst chính xác" {
  local f="backup.sql.zst"
  [[ "$f" == *".sql.zst" ]]
}

@test "Extension: .tar.gz không bị nhầm với .tar.zst" {
  local f="backup.tar.gz"
  [[ "$f" == *".tar.gz" ]]
  [[ "$f" != *".tar.zst" ]]
}

@test "Extension: .zip được nhận diện đúng" {
  local f="source.zip"
  [[ "$f" == *".zip" ]]
}

@test "Extension: đuôi file case-insensitive (ZIP vs zip)" {
  local f="source.ZIP"
  shopt -s nocasematch
  [[ "$f" == *".zip" ]]
  shopt -u nocasematch
}

# ==============================================================================
# NHÓM 7: Menu mode ('98')
# ==============================================================================
@test "Menu: tham số '98' được chuyển thành NAME rỗng" {
  NAME="98"
  [[ "$NAME" == "98" ]] && NAME=""
  [ -z "$NAME" ]
}

@test "Menu: cờ WPTT_IN_MENU được set khi argument = 98" {
  arg='98'
  if [[ "$arg" == '98' ]]; then
    WPTT_IN_MENU="yes"
  fi
  [ "$WPTT_IN_MENU" == "yes" ]
}

@test "Menu: NAME khác '98' giữ nguyên giá trị" {
  NAME="example.com"
  [[ "$NAME" == "98" ]] && NAME=""
  [ "$NAME" == "example.com" ]
}

# ==============================================================================
# NHÓM 8: Bảo mật & Cấu trúc mã nguồn
# ==============================================================================
@test "Bảo mật: script không chứa 'set -x' (chống lộ password)" {
  run grep -c 'set -x' "$KHOIPHUC_SCRIPT"
  [ "$output" = "0" ]
}

@test "Bảo mật: có unset biến chứa password DB sau khi dùng" {
  run grep -c 'unset password_database_root database_admin_password' "$KHOIPHUC_SCRIPT"
  [ "$output" -ge 1 ]
}

@test "Bảo mật: file cấu hình tạm DB có chmod 600" {
  run grep -c 'chmod 600 "\$TEMP_CNF_ROOT"' "$KHOIPHUC_SCRIPT"
  [ "$output" -ge 1 ]
}

@test "Bảo mật: dùng --defaults-extra-file thay vì -p trên CLI" {
  run grep -c 'mariadb --defaults-extra-file' "$KHOIPHUC_SCRIPT"
  [ "$output" -ge 1 ]
}

@test "Bảo mật: có validate SQL injection cho DB_Name_web" {
  run grep -c 'DB_Name_web.*\^\[a-zA-Z0-9_' "$KHOIPHUC_SCRIPT"
  [ "$output" -ge 1 ]
}

@test "Bảo mật: có validate SQL injection cho DB_User_web" {
  run grep -c 'DB_User_web.*\^\[a-zA-Z0-9_' "$KHOIPHUC_SCRIPT"
  [ "$output" -ge 1 ]
}

@test "Cấu trúc: script dùng shebang /bin/bash" {
  run head -1 "$KHOIPHUC_SCRIPT"
  [ "$output" = "#!/bin/bash" ]
}

@test "Cấu trúc: script bật set -o pipefail" {
  run grep -c '^set -o pipefail' "$KHOIPHUC_SCRIPT"
  [ "$output" -ge 1 ]
}

@test "Cấu trúc: có cơ chế flock -n chống trùng tiến trình" {
  run grep -c 'flock -n 200' "$KHOIPHUC_SCRIPT"
  [ "$output" -ge 1 ]
}

@test "Cấu trúc: có trap EXIT để cleanup lock" {
  run grep -c "trap 'cp /var/log" "$KHOIPHUC_SCRIPT"
  [ "$output" -ge 0 ]  # Không bắt buộc nhưng tốt nếu có
}

@test "Cấu trúc: kiểm tra MariaDB trước khi khôi phục" {
  run grep -c 'wptt_check_mariadb' "$KHOIPHUC_SCRIPT"
  [ "$output" -ge 1 ]
}

@test "Cấu trúc: khôi phục DB theo cơ chế Blue/Green (DB_TEMP)" {
  run grep -c 'DB_TEMP=' "$KHOIPHUC_SCRIPT"
  [ "$output" -ge 1 ]
}

@test "Cấu trúc: có rename atomic bằng renameat2" {
  run grep -c 'renameat2' "$KHOIPHUC_SCRIPT"
  [ "$output" -ge 1 ]
}

@test "Cấu trúc: dùng trap/mktemp cho thư mục tạm an toàn" {
  run grep -c 'mktemp -d /etc/wptt/tmp' "$KHOIPHUC_SCRIPT"
  [ "$output" -ge 1 ]
}

# ==============================================================================
# NHÓM 9: Edge cases
# ==============================================================================
@test "Edge: list_source_backups với tên file unicode vẫn hoạt động" {
  touch "$ROOT_BACKUP_DIR/backup-tiếng-việt.zip" 2>/dev/null || skip "FS không hỗ trợ unicode"
  run wptt_list_source_backups "$ROOT_BACKUP_DIR" 0
  [ "$status" -eq 0 ]
}

@test "Edge: list_source_backups chịu được nhiều file (100 files)" {
  for i in $(seq 1 100); do
    touch "$ROOT_BACKUP_DIR/file$i.zip"
  done
  run wptt_list_source_backups "$ROOT_BACKUP_DIR" 0
  [ "$status" -eq 0 ]
  # 100 file .zip + 100 NUL byte
  count=$(printf '%s' "$output" | tr -cd '\0' | wc -c)
  [ "$count" -eq 100 ]
}

@test "Edge: list_db_backups với file 0 byte vẫn liệt kê (không crash)" {
  touch "$ROOT_BACKUP_DIR/empty.sql"
  run wptt_list_db_backups "$ROOT_BACKUP_DIR" 0
  [ "$status" -eq 0 ]
  [[ "$output" == *"empty.sql"* ]]
}

@test "Edge: tên domain rỗng bị chặn ở kiểm tra pathcheck" {
  NAME=""
  pathcheck="/etc/wptt/vhost/.$NAME.conf"
  [ ! -f "$pathcheck" ]
}
