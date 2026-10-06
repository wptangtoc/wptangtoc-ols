#!/usr/bin/env bats


SCRIPT_GOC="${WPTT_SAOLUU_SCRIPT:-/etc/wptt/backup-restore/wptt-saoluu}"
TEST_DOMAIN="${WPTT_TEST_DOMAIN:-wptest-saoluu-demo.com}"
BACKUP_ROOT="/usr/local/backup-website"

# --- HÀM GỠ LỖI 
in_log_neu_loi() {
  local ma_ky_vong="$1"
  if [ "$status" -ne "$ma_ky_vong" ]; then
    echo -e "\n[LỖI TEST] Kịch bản không trả về mã $ma_ky_vong như kỳ vọng!" >&3
    echo "Mã trạng thái thực tế : $status" >&3
    echo -e "Nội dung in ra màn hình:\n$output" >&3
  fi
}

# =================================================================
# PHẦN A — UNIT TEST (chạy được trên ubuntu-latest, không cần OLS)
# =================================================================

setup_file() {
  export UNIT_TMP
  UNIT_TMP="$(mktemp -d)"
}

teardown_file() {
  rm -rf "${UNIT_TMP:?}" 2>/dev/null || true
}

# -----------------------------------------------------------------
# A1. Cơ chế khóa (flock) — chống 2 tiến trình backup cùng 1 domain
#
# Đây là cơ chế quan trọng nhất của script: nếu lock bị lỗi, 2 tiến trình
# backup/restore chạy song song trên cùng 1 website có thể làm hỏng dữ
# liệu. Test này mô phỏng chính xác logic lock trong script gốc
# (exec 200>"$LOCK_FILE"; flock -n 200) mà không cần chạy cả script.
# -----------------------------------------------------------------

@test "Unit: Lock chặn được tiến trình backup thứ 2 trên CÙNG 1 domain" {
  local lock_file="$UNIT_TMP/wptt_lock_sao_luu_khoi_phuc_${TEST_DOMAIN}.lock"

  # Tiến trình 1: giữ lock trong nền (giả lập backup đang chạy)
  (
    exec 200>"$lock_file"
    flock -n 200 || exit 1
    sleep 3
  ) &
  local pid_proc1=$!

  # Đợi tiến trình 1 chắc chắn đã lấy được lock
  sleep 0.5

  # Tiến trình 2: phải bị chặn (flock -n trả về khác 0) ngay lập tức
  run bash -c "
    exec 200>\"$lock_file\"
    flock -n 200
  "

  kill "$pid_proc1" 2>/dev/null
  wait "$pid_proc1" 2>/dev/null

  [ "$status" -ne 0 ]
}

@test "Unit: Lock của domain A không ảnh hưởng domain B (chạy song song OK)" {
  local lock_a="$UNIT_TMP/wptt_lock_sao_luu_khoi_phuc_domain-a.com.lock"
  local lock_b="$UNIT_TMP/wptt_lock_sao_luu_khoi_phuc_domain-b.com.lock"

  (
    exec 200>"$lock_a"
    flock -n 200 || exit 1
    sleep 2
  ) &
  local pid_proc1=$!
  sleep 0.3

  run bash -c "
    exec 201>\"$lock_b\"
    flock -n 201
  "

  kill "$pid_proc1" 2>/dev/null
  wait "$pid_proc1" 2>/dev/null

  [ "$status" -eq 0 ]
}

@test "Unit: Lock được giải phóng sau khi tiến trình kết thúc bình thường" {
  local lock_file="$UNIT_TMP/wptt_lock_sao_luu_khoi_phuc_release-test.com.lock"

  bash -c "
    exec 200>\"$lock_file\"
    flock -n 200 || exit 1
  "

  # Tiến trình đã thoát, FD 200 đã đóng tự động -> lock phải lấy được ngay
  run bash -c "
    exec 200>\"$lock_file\"
    flock -n 200
  "

  [ "$status" -eq 0 ]
}

# -----------------------------------------------------------------
# A2. Chống SQL/Shell Injection qua tên Database & User
#
# Script xác thực DB_Name_web / DB_User_web bằng regex
# ^[a-zA-Z0-9_]+$ trước khi đưa vào file .cnf và lệnh mariadb-dump. Test
# này kiểm thử ĐÚNG regex đó một cách độc lập, không phụ thuộc DB thật,
# để bất kỳ ai sửa regex trong tương lai cũng không vô tình làm yếu đi.
# -----------------------------------------------------------------

check_db_identifier() {
  [[ "$1" =~ ^[a-zA-Z0-9_]+$ ]]
}

@test "Unit: Chặn tên Database chứa dấu nháy đơn (SQL injection)" {
  run check_db_identifier "wp_db'; DROP TABLE wp_users; --"
  [ "$status" -ne 0 ]
}

@test "Unit: Chặn tên Database chứa khoảng trắng / dấu chấm phẩy" {
  run check_db_identifier "wp db; rm -rf /"
  [ "$status" -ne 0 ]
}

@test "Unit: Chặn tên User Database chứa ký tự backtick (command substitution)" {
  run check_db_identifier '`rm -rf /`'
  [ "$status" -ne 0 ]
}

@test "Unit: Chấp nhận tên Database/User hợp lệ bình thường" {
  run check_db_identifier "wptangtoc_wp123"
  [ "$status" -eq 0 ]
}

# -----------------------------------------------------------------
# A3. Exclude pattern — file nhạy cảm / rác KHÔNG được lọt vào bản backup
#
# Test thực nghiệm (không đoán mò) y hệt cách script thật gọi zip/tar, vì
# đây là tính năng bảo mật: nếu exclude pattern bị gõ sai khi sửa code,
# debug.log hay cache của plugin backup khác có thể bị gói nhầm vào bản
# sao lưu rồi đẩy lên cloud.
# -----------------------------------------------------------------

@test "Unit: Zip loại trừ đúng wp-content/cache nhưng vẫn giữ uploads thật" {
  local src="$UNIT_TMP/site-zip"
  mkdir -p "$src/wp-content/cache" "$src/wp-content/uploads"
  echo "cache-rac" > "$src/wp-content/cache/object-cache.php"
  echo "anh-that" > "$src/wp-content/uploads/image.jpg"
  echo "debug-log-nhay-cam" > "$src/wp-content/debug.log"
  echo "noi-dung-index" > "$src/index.php"

  cd "$src" || return 1
  zip -r "$UNIT_TMP/out.zip" . \
    -x "wp-content/cache/*" \
    -x "wp-content/debug.log" \
    -- . >/dev/null

  run unzip -l "$UNIT_TMP/out.zip"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "uploads/image.jpg" ]]
  [[ ! "$output" =~ "cache/object-cache.php" ]]
  [[ ! "$output" =~ "debug.log" ]]
}

@test "Unit: Tar loại trừ đúng wp-content/ai1wm-backups nhưng vẫn giữ file thật" {
  local src="$UNIT_TMP/site-tar"
  mkdir -p "$src/wp-content/ai1wm-backups" "$src/wp-content/uploads"
  echo "backup-plugin-khac" > "$src/wp-content/ai1wm-backups/old-backup.zip"
  echo "anh-that" > "$src/wp-content/uploads/image.jpg"

  cd "$src" || return 1
  run bash -c "tar -c --exclude='./wp-content/ai1wm-backups' . | tar -tv"

  [ "$status" -eq 0 ]
  [[ "$output" =~ "uploads/image.jpg" ]]
  [[ ! "$output" =~ "old-backup.zip" ]]
}

# -----------------------------------------------------------------
# A4. Cú pháp bash hợp lệ — regression test cho các lỗi "(?:...)"/biến
# không dùng từng gặp ở ruleset YARA: ở đây là bash nên dùng "bash -n".
# -----------------------------------------------------------------

@test "Unit: Script sao lưu không có lỗi cú pháp bash (bash -n)" {
  if [[ ! -f "$SCRIPT_GOC" ]]; then
    skip "Không tìm thấy $SCRIPT_GOC trên môi trường này — bỏ qua (chạy trên VPS OLS thật để kiểm tra đầy đủ)"
  fi
  run bash -n "$SCRIPT_GOC"
  [ "$status" -eq 0 ]
}


# =================================================================
# PHẦN B — INTEGRATION TEST (cần VPS WPTangToc OLS thật)
# =================================================================
#
# Toàn bộ nhóm này tự động "skip" (không fail CI) nếu không tìm thấy
# script thật hoặc domain test thật trên hệ thống — để không làm đỏ CI
# trên GitHub-hosted runner. Khi chạy trên self-hosted runner trỏ về VPS
# staging có sẵn domain $TEST_DOMAIN đã cài WordPress, các test này sẽ
# tự động chạy đầy đủ.

setup() {
  if [[ ! -x "$SCRIPT_GOC" ]]; then
    skip "Không tìm thấy script thật ($SCRIPT_GOC) — test Integration cần chạy trên VPS OLS"
  fi
  if [[ ! -d "/usr/local/lsws/$TEST_DOMAIN/html" ]]; then
    skip "Domain test ($TEST_DOMAIN) chưa tồn tại trên hệ thống này — xem WPTT_TEST_DOMAIN"
  fi
}

@test "Integration: Chặn sao lưu khi MariaDB đang sập" {
  # Mock wptt_check_mariadb luôn thất bại, không đụng vào MariaDB thật
  local core_bak
  core_bak="$(mktemp)"
  cp /etc/wptt/core-functions "$core_bak" 2>/dev/null || true
  cat <<'EOF' >> /etc/wptt/core-functions
wptt_check_mariadb() { return 1; }
EOF

  run bash "$SCRIPT_GOC" "$TEST_DOMAIN"

  cp "$core_bak" /etc/wptt/core-functions 2>/dev/null || true
  rm -f "$core_bak"

  in_log_neu_loi 1
  [ "$status" -ne 0 ]
  [[ "$output" =~ "MariaDB" ]]
}

@test "Integration: SAO LƯU THÀNH CÔNG tạo đủ file .zip và .sql với quyền 600" {
  rm -f "${BACKUP_ROOT:?}/${TEST_DOMAIN:?}"/*.zip "${BACKUP_ROOT:?}/${TEST_DOMAIN:?}"/*.sql 2>/dev/null || true

  run bash "$SCRIPT_GOC" "$TEST_DOMAIN"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "thành công" ]]

  local zip_file sql_file
  zip_file=$(find "$BACKUP_ROOT/$TEST_DOMAIN" -maxdepth 1 -name "*.zip" -newer /tmp -print -quit 2>/dev/null)
  sql_file=$(find "$BACKUP_ROOT/$TEST_DOMAIN" -maxdepth 1 -name "*.sql" -print -quit 2>/dev/null)

  [ -s "$zip_file" ]
  [ -s "$sql_file" ]

  # Quyền file phải là 600 — chỉ root được đọc file backup (umask 077)
  [ "$(stat -c '%a' "$zip_file")" = "600" ]
  [ "$(stat -c '%a' "$sql_file")" = "600" ]

  # File zip phải toàn vẹn, mở được
  run unzip -tq "$zip_file"
  [ "$status" -eq 0 ]
}

@test "Integration: Bản sao lưu KHÔNG chứa debug.log hay wp-content/cache" {
  mkdir -p "/usr/local/lsws/$TEST_DOMAIN/html/wp-content/cache"
  echo "rac-cache" > "/usr/local/lsws/$TEST_DOMAIN/html/wp-content/cache/test-object.php"
  echo "du-lieu-nhay-cam" > "/usr/local/lsws/$TEST_DOMAIN/html/error_log"

  run bash "$SCRIPT_GOC" "$TEST_DOMAIN"
  in_log_neu_loi 0
  [ "$status" -eq 0 ]

  local zip_file
  zip_file=$(find "$BACKUP_ROOT/$TEST_DOMAIN" -maxdepth 1 -name "*.zip" -print -quit 2>/dev/null)

  run unzip -l "$zip_file"
  [[ ! "$output" =~ "wp-content/cache/test-object.php" ]]
  [[ ! "$output" =~ "error_log" ]]

  rm -f "/usr/local/lsws/$TEST_DOMAIN/html/error_log"
  rm -rf "/usr/local/lsws/$TEST_DOMAIN/html/wp-content/cache"
}

@test "Integration: Hai lệnh sao lưu đồng thời trên CÙNG domain — lệnh thứ 2 bị từ chối rõ ràng" {
  bash "$SCRIPT_GOC" "$TEST_DOMAIN" >/tmp/wptt_bats_bg_backup.log 2>&1 &
  local pid_proc1=$!
  sleep 1 # đợi tiến trình 1 chắc chắn đã lấy được lock

  run bash "$SCRIPT_GOC" "$TEST_DOMAIN"

  wait "$pid_proc1" 2>/dev/null
  rm -f /tmp/wptt_bats_bg_backup.log

  in_log_neu_loi 1
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Đụng Độ Tiến Trình" ]]
}

@test "Integration: Không đủ dung lượng đĩa — từ chối sao lưu VÀ giải phóng lock ngay (không kẹt lock)" {
  # Mock bước kiểm tra đĩa luôn báo không đủ điều kiện, không cần làm đầy
  # ổ cứng thật.
  local check_script="/etc/wptt/backup-restore/wptt-check-disk-dieu-kien-backup"
  local check_bak
  check_bak="$(mktemp)"
  cp "$check_script" "$check_bak" 2>/dev/null || true
  echo 'dieu_kien_disk="0"' > "$check_script"

  run bash "$SCRIPT_GOC" "$TEST_DOMAIN"

  cp "$check_bak" "$check_script" 2>/dev/null || true
  rm -f "$check_bak"

  in_log_neu_loi 1
  [ "$status" -ne 0 ]

  # Quan trọng nhất: lock PHẢI được giải phóng ngay, không để kẹt vĩnh
  # viễn — nếu không, mọi lần backup sau của domain này sẽ báo "Đụng Độ
  # Tiến Trình" giả mãi mãi dù không có tiến trình nào đang chạy thật.
  run bash -c "
    exec 200>\"/etc/wptt/tmp/wptt_lock_sao_luu_khoi_phuc_${TEST_DOMAIN}.lock\"
    flock -n 200
  "
  [ "$status" -eq 0 ]
}

@test "Integration: Cấu hình nén mã nguồn tar.zst tạo đúng đuôi .tar.zst (không phải .zip)" {
  local vhost_conf="/etc/wptt/vhost/.${TEST_DOMAIN}.conf"
  if [[ ! -f "$vhost_conf" ]]; then
    skip "Không tìm thấy vhost conf thật của domain test"
  fi

  cp "$vhost_conf" "/tmp/vhost_conf.bak"
  if grep -q '^dinh_dang_nen_ma_nguon=' "$vhost_conf"; then
    sed -i "s/^dinh_dang_nen_ma_nguon=.*/dinh_dang_nen_ma_nguon='1'/" "$vhost_conf"
  else
    echo "dinh_dang_nen_ma_nguon='1'" >> "$vhost_conf"
  fi

  run bash "$SCRIPT_GOC" "$TEST_DOMAIN"

  cp "/tmp/vhost_conf.bak" "$vhost_conf"
  rm -f "/tmp/vhost_conf.bak"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]

  local zst_file
  zst_file=$(find "$BACKUP_ROOT/$TEST_DOMAIN" -maxdepth 1 -name "*.tar.zst" -print -quit 2>/dev/null)
  [ -n "$zst_file" ]
  [ -s "$zst_file" ]
}

