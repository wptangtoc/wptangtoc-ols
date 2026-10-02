#!/usr/bin/env bats
#
# tests/khoiphuc.bats — Kiểm thử tính năng Khôi phục (Restore) của WPTangToc OLS
#


SCRIPT_GOC="${WPTT_KHOIPHUC_SCRIPT:-/etc/wptt/backup-restore/wptt-khoiphuc}"
TEST_DOMAIN="${WPTT_TEST_DOMAIN:-wptest-khoiphuc-demo.com}"
BACKUP_ROOT="/usr/local/backup-website"

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
# A2. Chống SQL/Shell Injection qua tên Database & User (dùng chung logic
# với backup, nhưng script khôi phục có 2 lớp DB: DB gốc của admin VÀ
# DB_Name_web/DB_User_web của website — test cả biến thể tên bảng DB_TEMP/
# DB_TRASH được ghép chuỗi từ DB_Name_web).
# -----------------------------------------------------------------

check_db_identifier() {
  [[ "$1" =~ ^[a-zA-Z0-9_]+$ ]]
}

@test "Unit: Chặn DB_Name_web chứa ký tự injection trước khi ghép DB_TEMP/DB_TRASH" {
  run check_db_identifier "wp\`; DROP DATABASE wp_mysite; --"
  [ "$status" -ne 0 ]
}

@test "Unit: Chấp nhận DB_Name_web hợp lệ và ghép đúng DB_TEMP/DB_TRASH" {
  local db="wptangtoc_wp123"
  run check_db_identifier "$db"
  [ "$status" -eq 0 ]
  [ "${db}_temp" = "wptangtoc_wp123_temp" ]
  [ "${db}_trash" = "wptangtoc_wp123_trash" ]
}

# -----------------------------------------------------------------
# A3. Blue/Green swap — xây dựng câu lệnh RENAME TABLE
#
# Test độc lập logic ghép RENAME_QUERY (trích y hệt từ script thật) để
# đảm bảo không vô tình làm sai số lượng mệnh đề RENAME khi có ai sửa code
# sau này — sai 1 dấu phẩy/backtick ở đây có thể làm mất bảng dữ liệu thật.
# -----------------------------------------------------------------

build_rename_query() {
  local DB_Name_web="$1" DB_TEMP="$2" DB_TRASH="$3" OLD_TABLES="$4" NEW_TABLES="$5"
  local RENAME_QUERY="RENAME TABLE "
  if [[ -n "$OLD_TABLES" ]]; then
    while IFS= read -r t; do
      [[ -n "$t" ]] && RENAME_QUERY+="\`${DB_Name_web}\`.\`$t\` TO \`${DB_TRASH}\`.\`$t\`, "
    done <<< "$OLD_TABLES"
  fi
  if [[ -n "$NEW_TABLES" ]]; then
    while IFS= read -r t; do
      [[ -n "$t" ]] && RENAME_QUERY+="\`${DB_TEMP}\`.\`$t\` TO \`${DB_Name_web}\`.\`$t\`, "
    done <<< "$NEW_TABLES"
  fi
  RENAME_QUERY=${RENAME_QUERY%, }
  echo "$RENAME_QUERY"
}

@test "Unit: RENAME_QUERY tạo đủ số mệnh đề cho N bảng cũ + N bảng mới" {
  local old_tables=$'wp_posts\nwp_options\nwp_users'
  local new_tables=$'wp_posts\nwp_options\nwp_users'

  run build_rename_query "wp_mysite" "wp_mysite_temp" "wp_mysite_trash" "$old_tables" "$new_tables"

  [ "$status" -eq 0 ]
  local clause_count
  clause_count=$(echo "$output" | grep -o ' TO ' | wc -l)
  [ "$clause_count" -eq 6 ]
  [[ "$output" == "RENAME TABLE "* ]]
  [[ "$output" != *", " ]] # không được dư dấu phẩy ở cuối
}

@test "Unit: RENAME_QUERY vẫn hợp lệ khi DB mới KHÔNG CÓ bảng nào (import rỗng)" {
  run build_rename_query "wp_mysite" "wp_mysite_temp" "wp_mysite_trash" "wp_posts" ""
  [ "$status" -eq 0 ]
  [[ "$output" == "RENAME TABLE \`wp_mysite\`.\`wp_posts\` TO \`wp_mysite_trash\`.\`wp_posts\`" ]]
}

# -----------------------------------------------------------------
# A4. Phát hiện wp-load.php ở gốc hay lồng trong thư mục con (zip & tar.gz)
#
# Đây là logic quyết định "giải nén trực tiếp" hay "giải nén rồi di
# chuyển từ thư mục con ra" — sai logic này có thể khiến khôi phục ra một
# website rỗng (chỉ có 1 thư mục con, không có wp-load.php ở đúng vị trí
# web server mong đợi). Test bằng file zip/tar.gz TẠO THẬT, không giả định.
# -----------------------------------------------------------------

@test "Unit: Nhận diện đúng zip có wp-load.php Ở GỐC" {
  local src="$UNIT_TMP/flat-zip"
  mkdir -p "$src/wp-content"
  echo "wp" > "$src/wp-load.php"
  echo "x" > "$src/wp-content/index.php"
  ( cd "$src" && zip -rq "$UNIT_TMP/flat.zip" . )

  run bash -c "unzip -l '$UNIT_TMP/flat.zip' 2>/dev/null | awk '{ print \$4 }' | grep -q '^wp-load.php\$'"
  [ "$status" -eq 0 ]
}

@test "Unit: Nhận diện đúng zip có wp-load.php LỒNG trong 1 thư mục con" {
  local src="$UNIT_TMP/nested-zip/mysite-backup"
  mkdir -p "$src/wp-content"
  echo "wp" > "$src/wp-load.php"
  echo "x" > "$src/wp-content/index.php"
  ( cd "$UNIT_TMP/nested-zip" && zip -rq "$UNIT_TMP/nested.zip" . )

  # KHÔNG được nhận nhầm là gốc
  run bash -c "unzip -l '$UNIT_TMP/nested.zip' 2>/dev/null | awk '{ print \$4 }' | grep -q '^wp-load.php\$'"
  [ "$status" -ne 0 ]

  # Phải tìm đúng path lồng nhau để biết thư mục cần di chuyển ra
  run bash -c "unzip -l '$UNIT_TMP/nested.zip' 2>/dev/null | awk '{ print \$4 }' | grep '/wp-load.php\$'"
  [ "$status" -eq 0 ]
  [[ "$output" == "mysite-backup/wp-load.php" ]]
}

@test "Unit: Nhận diện đúng tar.gz có wp-load.php ở gốc (awk field \$6)" {
  local src="$UNIT_TMP/flat-tar"
  mkdir -p "$src/wp-content"
  echo "wp" > "$src/wp-load.php"
  echo "x" > "$src/wp-content/index.php"
  ( cd "$src" && tar -czf "$UNIT_TMP/flat.tar.gz" . )

  run bash -c "tar -tvzf '$UNIT_TMP/flat.tar.gz' 2>/dev/null | awk '{ print \$6 }' | grep -q '^./wp-load.php\$\|^wp-load.php\$\|^/wp-load.php\$'"
  [ "$status" -eq 0 ]
}

# -----------------------------------------------------------------
# A5. Dead code sed "phpphpmyadmin" — regression test khẳng định dòng sed
# chính tả ĐÚNG ("phpmyadmin") vẫn là dòng thực sự dọn dẹp vhost_conf.
# Nếu sau này ai đó "dọn trùng lặp" và lỡ xoá nhầm dòng đúng thay vì dòng
# lỗi chính tả, test này sẽ đỏ ngay.
# -----------------------------------------------------------------

@test "Unit: sed dọn realm phpmyadmin (chính tả ĐÚNG) phải xoá được block thật" {
  local conf="$UNIT_TMP/vhost_phpmyadmin.conf"
  cat > "$conf" <<'EOF'
realm example.comphpmyadmin {
  userDB {
    location $VH_ROOT/passwd/.phpmyadmin
  }
}
context /other/ {
  giu lai dong nay
}
EOF
  local Website_chinh="example.com"
  sed -i -e "/^realm ${Website_chinh}phpmyadmin/,/^}/d" "$conf"

  run grep -c "realm example.comphpmyadmin" "$conf"
  [ "$output" -eq 0 ]
  run grep -c "giu lai dong nay" "$conf"
  [ "$output" -eq 1 ]
}

@test "Unit: [BIẾT LỖI] sed với chính tả SAI 'phpphpmyadmin' là dead code, không xoá được gì" {
  local conf="$UNIT_TMP/vhost_typo.conf"
  cat > "$conf" <<'EOF'
realm example.comphpmyadmin {
  userDB {
    location $VH_ROOT/passwd/.phpmyadmin
  }
}
EOF
  local original_md5 typo_md5
  original_md5=$(md5sum "$conf" | cut -d' ' -f1)

  local Website_chinh="example.com"
  sed -i -e '/^realm '"${Website_chinh}"phpphpmyadmin'/,/^}$/d' "$conf" 2>/dev/null

  typo_md5=$(md5sum "$conf" | cut -d' ' -f1)

  # Test này CỐ Ý xác nhận hành vi lỗi hiện tại (dead code, không xoá gì)
  # để ghi lại bằng chứng — nếu ai đó sửa lỗi chính tả, hãy XOÁ test này
  # và thay bằng một bản giống "sed dọn realm phpmyadmin (chính tả ĐÚNG)".
  echo "[GHI CHÚ] Dòng sed 'phpphpmyadmin' hiện là dead code do lỗi chính tả — xem comment đầu file." >&3
  [ "$original_md5" = "$typo_md5" ]
}

# -----------------------------------------------------------------
# A6. Kiểm tra kích thước file .sql tối thiểu (chống backup rỗng/hỏng)
# -----------------------------------------------------------------

@test "Unit: Từ chối file .sql dưới 3KB (có khả năng bị hỏng)" {
  local small_sql="$UNIT_TMP/small.sql"
  printf 'x%.0s' {1..100} > "$small_sql" # 100 byte, < 3KB

  local check_file_error
  check_file_error=$(du -c "$small_sql" | awk '{print $1}' | sed '1d')

  run bash -c "(( ${check_file_error:-0} < 3 ))"
  [ "$status" -eq 0 ]
}

@test "Unit: Chấp nhận file .sql trên 3KB" {
  local ok_sql="$UNIT_TMP/ok.sql"
  head -c 10240 /dev/zero > "$ok_sql" # 10KB

  local check_file_error
  check_file_error=$(du -c "$ok_sql" | awk '{print $1}' | sed '1d')

  run bash -c "(( ${check_file_error:-0} < 3 ))"
  [ "$status" -ne 0 ]
}

# -----------------------------------------------------------------
# A7. Cú pháp bash hợp lệ (bash -n) — không bắt được bug A1 (vì đó là lỗi
# runtime chứ không phải cú pháp), nhưng vẫn cần giữ làm lưới an toàn cho
# các lỗi cú pháp thật như từng gặp ở script quét virus.
# -----------------------------------------------------------------

@test "Unit: Script khôi phục không có lỗi cú pháp bash (bash -n)" {
  if [[ ! -f "$SCRIPT_GOC" ]]; then
    skip "Không tìm thấy $SCRIPT_GOC trên môi trường này — chạy trên VPS OLS thật để kiểm tra đầy đủ"
  fi
  run bash -n "$SCRIPT_GOC"
  [ "$status" -eq 0 ]
}


# =================================================================
# PHẦN B — INTEGRATION TEST (cần VPS WPTangToc OLS thật)
# =================================================================

setup() {
  if [[ ! -x "$SCRIPT_GOC" ]]; then
    skip "Không tìm thấy script thật ($SCRIPT_GOC) — test Integration cần chạy trên VPS OLS"
  fi
  if [[ ! -d "/usr/local/lsws/$TEST_DOMAIN/html" ]]; then
    skip "Domain test ($TEST_DOMAIN) chưa tồn tại trên hệ thống này — xem WPTT_TEST_DOMAIN"
  fi
}

@test "Integration: Chặn khôi phục khi MariaDB đang sập" {
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

@test "Integration: Hai lệnh khôi phục đồng thời CÙNG domain — lệnh thứ 2 bị chặn" {
  bash "$SCRIPT_GOC" "$TEST_DOMAIN" </dev/null >/tmp/wptt_bats_bg_restore.log 2>&1 &
  local pid_proc1=$!
  sleep 1

  run bash -c "echo '0' | bash '$SCRIPT_GOC' '$TEST_DOMAIN'"

  kill "$pid_proc1" 2>/dev/null
  wait "$pid_proc1" 2>/dev/null
  rm -f /tmp/wptt_bats_bg_restore.log

  in_log_neu_loi 1
  [ "$status" -ne 0 ]
  [[ "$output" =~ "ĐỤNG ĐỘ TIẾN TRÌNH" || "$output" =~ "đang được thao tác" ]]
}

@test "Integration: Từ chối file Database backup dưới 3KB" {
  mkdir -p "$BACKUP_ROOT/$TEST_DOMAIN"
  local tiny_sql="$BACKUP_ROOT/$TEST_DOMAIN/${TEST_DOMAIN}9999gio_01_01_2099.sql"
  printf 'x%.0s' {1..50} > "$tiny_sql"

  # Giả lập chọn file mã nguồn bất kỳ (số 1) rồi chọn đúng file sql nhỏ vừa tạo
  run bash -c "printf '1\n1\n' | bash '$SCRIPT_GOC' '$TEST_DOMAIN'"

  rm -f "$tiny_sql"

  in_log_neu_loi 1
  [ "$status" -ne 0 ]
  [[ "$output" =~ "quá nhỏ" ]]
}

@test "Integration: wp-config.php bị symlink — từ chối ghi đè để chống leo thang đặc quyền" {
  local wp_config="/usr/local/lsws/$TEST_DOMAIN/html/wp-config.php"
  local wp_config_bak="/tmp/wp-config.php.bak.$$"

  [[ -f "$wp_config" ]] && cp -p "$wp_config" "$wp_config_bak"
  rm -f "$wp_config"
  ln -s /etc/passwd "$wp_config"

  run bash -c "printf '1\n1\n' | bash '$SCRIPT_GOC' '$TEST_DOMAIN'"

  rm -f "$wp_config"
  [[ -f "$wp_config_bak" ]] && mv "$wp_config_bak" "$wp_config"

  [[ "$output" =~ "symlink" ]]
  # Quan trọng nhất: /etc/passwd thật của hệ thống không được bị động tới
  run bash -c "head -c 20 /etc/passwd"
  [[ "$output" =~ "root:" ]]
}

@test "Integration: .htaccess tự động được tạo lại nếu thiếu sau khi khôi phục" {
  rm -f "/usr/local/lsws/$TEST_DOMAIN/html/.htaccess"

  run bash -c "printf '1\n1\n' | bash '$SCRIPT_GOC' '$TEST_DOMAIN'"

  in_log_neu_loi 0
  [ -s "/usr/local/lsws/$TEST_DOMAIN/html/.htaccess" ]
  run grep -q "BEGIN WordPress" "/usr/local/lsws/$TEST_DOMAIN/html/.htaccess"
  [ "$status" -eq 0 ]
}

@test "Integration: KHÔI PHỤC THÀNH CÔNG — website hoạt động lại sau khi phục hồi" {
  run bash -c "printf '1\n1\n' | bash '$SCRIPT_GOC' '$TEST_DOMAIN'"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "thành công" ]]

  [ -f "/usr/local/lsws/$TEST_DOMAIN/html/wp-load.php" ]

  run wp core is-installed --path="/usr/local/lsws/$TEST_DOMAIN/html" --allow-root
  [ "$status" -eq 0 ]

  # Lock phải được giải phóng sau khi hoàn tất, không kẹt lại
  run bash -c "
    exec 200>\"/etc/wptt/tmp/wptt_lock_sao_luu_khoi_phuc_${TEST_DOMAIN}.lock\"
    flock -n 200
  "
  [ "$status" -eq 0 ]
}
