#!/usr/bin/env bats

#Kiểm thử tính năng Sao lưu (Backup) của WPTangToc OLS

export SCRIPT_GOC="${WPTT_SAOLUU_SCRIPT:-/etc/wptt/backup-restore/wptt-saoluu}"
export SCRIPT_THEM="${WPTT_THEMWEBSITE_SCRIPT:-/etc/wptt/domain/wptt-themwebsite}"
export SCRIPT_XOA="${WPTT_XOAWEBSITE_SCRIPT:-/etc/wptt/domain/wptt-xoa-website}"
export SCRIPT_CAI_WP="${WPTT_CAI_WP_SCRIPT:-/etc/wptt/wptt-install-wordpress2}"
export BACKUP_ROOT="/usr/local/backup-website"
export FILE_DUNG_CHUNG="/tmp/wptt_bats_bien_dung_chung_$$.sh"

# --- HÀM VŨ KHÍ GỠ LỖI ---
in_log_neu_loi() {
  local ma_ky_vong="$1"
  if [ "$status" -ne "$ma_ky_vong" ]; then
    echo -e "\n[LỖI TEST] Kịch bản không trả về mã $ma_ky_vong như kỳ vọng!" >&3
    echo "Mã trạng thái thực tế : $status" >&3
    echo -e "Nội dung in ra màn hình:\n$output" >&3
  fi
}

# =================================================================
# PHẦN A — UNIT TEST (Độc lập, siêu tốc)
# =================================================================

setup_file() {
  export UNIT_TMP
  UNIT_TMP="$(mktemp -d)"

  export TEST_DOMAIN="wptest-saoluu-$(date +\%s)-$$.com"

  echo "export TEST_DOMAIN=\"$TEST_DOMAIN\"" > "$FILE_DUNG_CHUNG"
  return 0
}

teardown_file() {
  rm -rf "${UNIT_TMP:-/tmp/dummy_wptt}" 2>/dev/null || true
  
  # Dùng IF thuần túy thay cho logic phẳng để tương thích mọi bản Bash
  if [ -f "$FILE_DUNG_CHUNG" ]; then
    source "$FILE_DUNG_CHUNG" 2>/dev/null || true
    if [ -n "$TEST_DOMAIN" ]; then
      if [ -x "$SCRIPT_XOA" ]; then
        cp /etc/wptt/core-functions /tmp/core-functions.bak 2>/dev/null || true
        cat <<'EOF' > /etc/wptt/core-functions
source /tmp/core-functions.bak
wptt_xac_nhan() { return 0; }
EOF
        bash "$SCRIPT_XOA" "$TEST_DOMAIN" >/dev/null 2>&1 || true
        mv /tmp/core-functions.bak /etc/wptt/core-functions 2>/dev/null || true
      fi
    fi
    rm -f "$FILE_DUNG_CHUNG" 2>/dev/null || true
  fi
  return 0
}

# =================================================================
# PHẦN B — INTEGRATION TEST (Cần môi trường OS / CI thực tế)
# =================================================================

setup() {
  if [ -f "$FILE_DUNG_CHUNG" ]; then
      source "$FILE_DUNG_CHUNG" 2>/dev/null || true
  fi

  # Dùng lệnh GREP siêu lành tính thay vì [[ ... =~ ... ]] gây lỗi syntax
  if echo "$BATS_TEST_DESCRIPTION" | grep -q "Integration"; then
    if [ ! -x "$SCRIPT_GOC" ] \vert{}\vert{} [ ! -x "$SCRIPT_THEM" ] || [ ! -x "$SCRIPT_XOA" ] \vert{}\vert{} [ ! -x "$SCRIPT_CAI_WP" ]; then
      skip "Thiếu script môi trường (Thêm/Xóa/Cài/Sao Lưu). Bỏ qua Integration Test"
    fi
  fi
  return 0
}

teardown() {
  if [ -f "/tmp/core-functions.bak" ]; then
    if [ -f "/etc/wptt/core-functions" ]; then
      mv "/tmp/core-functions.bak" "/etc/wptt/core-functions" 2>/dev/null || true
    fi
  fi

  if [ -f "/tmp/wptt-check-disk.bak" ]; then
    if [ -f "/etc/wptt/backup-restore/wptt-check-disk-dieu-kien-backup" ]; then
      mv "/tmp/wptt-check-disk.bak" "/etc/wptt/backup-restore/wptt-check-disk-dieu-kien-backup" 2>/dev/null || true
    fi
  fi

  if [ -f "/tmp/vhost_conf.bak" ]; then
    if [ -f "/etc/wptt/vhost/.${TEST_DOMAIN}.conf" ]; then
      mv "/tmp/vhost_conf.bak" "/etc/wptt/vhost/.${TEST_DOMAIN}.conf" 2>/dev/null || true
    fi
  fi

  rm -f "/etc/wptt/tmp/wptt_lock_sao_luu_khoi_phuc_${TEST_DOMAIN}.lock" 2>/dev/null || true
  rm -f "/tmp/wptt_bats_bg_backup.log" 2>/dev/null || true
  return 0
}

# -----------------------------------------------------------------
# A1. Cơ chế khóa (flock)
# -----------------------------------------------------------------

@test "Unit: Lock chặn được tiến trình backup thứ 2 trên CÙNG 1 domain" {
  local lock_file="$UNIT_TMP/wptt_lock_sao_luu_khoi_phuc_${TEST_DOMAIN}.lock"

  (
    exec 200>"$lock_file"
    flock -n 200 || exit 1
    sleep 3
  ) 3>&- &
  local pid_proc1=$!
  sleep 0.5

  run bash -c "
    exec 200>\"$lock_file\"
    flock -n 200
  "

  kill "$pid_proc1" 2>/dev/null || true
  wait "$pid_proc1" 2>/dev/null || true

  [ "$status" -ne 0 ]
}

@test "Unit: Lock của domain A không ảnh hưởng domain B (chạy song song OK)" {
  local lock_a="$UNIT_TMP/wptt_lock_sao_luu_khoi_phuc_domain-a.com.lock"
  local lock_b="$UNIT_TMP/wptt_lock_sao_luu_khoi_phuc_domain-b.com.lock"

  (
    exec 200>"$lock_a"
    flock -n 200 || exit 1
    sleep 2
  ) 3>&- &
  local pid_proc1=$!
  sleep 0.3

  run bash -c "
    exec 201>\"$lock_b\"
    flock -n 201
  "

  kill "$pid_proc1" 2>/dev/null || true
  wait "$pid_proc1" 2>/dev/null || true

  [ "$status" -eq 0 ]
}

@test "Unit: Lock được giải phóng sau khi tiến trình kết thúc bình thường" {
  local lock_file="$UNIT_TMP/wptt_lock_sao_luu_khoi_phuc_release-test.com.lock"

  bash -c "
    exec 200>\"$lock_file\"
    flock -n 200 || exit 1
  "

  run bash -c "
    exec 200>\"$lock_file\"
    flock -n 200
  "

  [ "$status" -eq 0 ]
}

# -----------------------------------------------------------------
# A2. Chống SQL/Shell Injection
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
# A3. Exclude pattern — file nhạy cảm / rác
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
# A4. Cú pháp bash hợp lệ
# -----------------------------------------------------------------

@test "Unit: Script sao lưu không có lỗi cú pháp bash (bash -n)" {
  if [ ! -f "$SCRIPT_GOC" ]; then
    skip "Không tìm thấy $SCRIPT_GOC trên môi trường này — bỏ qua"
  fi
  run bash -n "$SCRIPT_GOC"
  [ "$status" -eq 0 ]
}

# -----------------------------------------------------------------
# B. INTEGRATION TESTS
# -----------------------------------------------------------------

@test "Integration: Chuẩn bị Môi trường — Tạo Website & Cài WordPress" {
  run bash "$SCRIPT_THEM" "$TEST_DOMAIN"
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [ -d "/usr/local/lsws/$TEST_DOMAIN/html" ]

  export SCRIPT_TEST="/tmp/wptt-install-wp-test.sh"
  cp /etc/wptt/core-functions /tmp/core-functions.bak 2>/dev/null || true
  cat << 'EOF' > /etc/wptt/core-functions
source /tmp/core-functions.bak
wptt_xac_nhan() { return 0; }
EOF

  cp "$SCRIPT_CAI_WP" "$SCRIPT_TEST"
  sed -i 's/exec \/etc\/wptt\/wptt-wordpress-main.*/exit 0/g' "$SCRIPT_TEST"
  sed -i 's/exec \/usr\/bin\/wptangtoc.*/exit 0/g' "$SCRIPT_TEST"
  echo "exit 0" >> "$SCRIPT_TEST"
  chmod +x "$SCRIPT_TEST"

  local WP_TITLE="Website Test Auto"
  local WP_USER="admin_$(date +%s)"
  local WP_PASS="PassKh0_$(date +%N)"
  local WP_EMAIL="admin@$TEST_DOMAIN"
  local INPUTS="${WP_TITLE}\n${WP_USER}\n${WP_PASS}\n${WP_EMAIL}\n"

  run bash -c "echo -e \"$INPUTS\" | bash $SCRIPT_TEST \"$TEST_DOMAIN\""
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  
  rm -f "$SCRIPT_TEST"
}

@test "Integration: Chặn sao lưu khi MariaDB đang sập" {
  if [ ! -d "/usr/local/lsws/$TEST_DOMAIN/html" ]; then
     skip "Website $TEST_DOMAIN chưa được tạo thành công."
  fi

  cp /etc/wptt/core-functions /tmp/core-functions.bak 2>/dev/null || true
  cat <<'EOF' >> /etc/wptt/core-functions
wptt_check_mariadb() { return 1; }
EOF

  run bash "$SCRIPT_GOC" "$TEST_DOMAIN"

  in_log_neu_loi 1
  [ "$status" -ne 0 ]
  [[ "$output" =~ "MariaDB" ]]
}

@test "Integration: SAO LƯU THÀNH CÔNG tạo đủ file .zip và .sql với quyền 600" {
  if [ ! -d "/usr/local/lsws/$TEST_DOMAIN/html" ]; then
     skip "Website $TEST_DOMAIN chưa được tạo thành công."
  fi

  rm -f "${BACKUP_ROOT:?}/${TEST_DOMAIN:?}"/*.zip "${BACKUP_ROOT:?}/${TEST_DOMAIN:?}"/*.sql 2>/dev/null || true

  run bash "$SCRIPT_GOC" "$TEST_DOMAIN"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "thành công" ]]

  local zip_file sql_file
  zip_file=$(find "$BACKUP_ROOT/$TEST_DOMAIN" -maxdepth 1 -name "*.zip" -print -quit 2>/dev/null)
  sql_file=$(find "$BACKUP_ROOT/$TEST_DOMAIN" -maxdepth 1 -name "*.sql" -print -quit 2>/dev/null)

  [ -s "$zip_file" ]
  [ -s "$sql_file" ]

	# Code đúng phải là thế này:
  [ "$(stat -c '%a' "$zip_file")" = "600" ]
  [ "$(stat -c '%a' "$sql_file")" = "600" ]

  run unzip -tq "$zip_file"
  [ "$status" -eq 0 ]
}

@test "Integration: Bản sao lưu KHÔNG chứa debug.log hay wp-content/cache" {
  if [ ! -d "/usr/local/lsws/$TEST_DOMAIN/html" ]; then
     skip "Website $TEST_DOMAIN chưa được tạo thành công."
  fi

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

@test "Integration: Hai lệnh sao lưu đồng thời trên CÙNG domain — lệnh 2 bị chặn" {
  if [ ! -d "/usr/local/lsws/$TEST_DOMAIN/html" ]; then
     skip "Website $TEST_DOMAIN chưa được tạo thành công."
  fi

  bash "$SCRIPT_GOC" "$TEST_DOMAIN" >/tmp/wptt_bats_bg_backup.log 2>&1 3>&- &
  local pid_proc1=$!
  sleep 1 # đợi tiến trình 1 lấy lock

  run bash "$SCRIPT_GOC" "$TEST_DOMAIN"

  kill "$pid_proc1" 2>/dev/null || true
  wait "$pid_proc1" 2>/dev/null || true

  in_log_neu_loi 1
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Đụng Độ Tiến Trình" ]]
}

@test "Integration: Không đủ dung lượng đĩa — từ chối sao lưu VÀ giải phóng lock ngay" {
  if [ ! -d "/usr/local/lsws/$TEST_DOMAIN/html" ]; then
     skip "Website $TEST_DOMAIN chưa được tạo thành công."
  fi

  local check_script="/etc/wptt/backup-restore/wptt-check-disk-dieu-kien-backup"
  cp "$check_script" "/tmp/wptt-check-disk.bak" 2>/dev/null || true
  echo 'dieu_kien_disk="0"' > "$check_script"

  run bash "$SCRIPT_GOC" "$TEST_DOMAIN"

  in_log_neu_loi 1
  [ "$status" -ne 0 ]

  run bash -c "
    exec 200>\"/etc/wptt/tmp/wptt_lock_sao_luu_khoi_phuc_${TEST_DOMAIN}.lock\"
    flock -n 200
  "
  [ "$status" -eq 0 ]
}

@test "Integration: Test backup nén mã nguồn tar.zst tạo đúng đuôi .tar.zst" {
  if [ ! -d "/usr/local/lsws/$TEST_DOMAIN/html" ]; then
     skip "Website $TEST_DOMAIN chưa được tạo thành công."
  fi

	# --- BỔ SUNG: KIỂM TRA VÀ TỰ ĐỘNG CÀI ĐẶT ZSTD NẾU THIẾU ---
  if ! command -v zstd >/dev/null 2>&1; then
    if command -v apt-get >/dev/null 2>&1; then
      apt-get update -y >/dev/null 2>&1 || true
      apt-get install -y zstd >/dev/null 2>&1
    elif command -v dnf >/dev/null 2>&1; then
      dnf install -y zstd >/dev/null 2>&1
    elif command -v yum >/dev/null 2>&1; then
      yum install -y zstd >/dev/null 2>&1
    else
      skip "Không thể tự động cài zstd (không tìm thấy apt/dnf/yum). Bỏ qua test."
    fi
  fi


	if ! command -v tar >/dev/null 2>&1; then
		if command -v apt-get >/dev/null 2>&1; then
			apt-get install -y tar >/dev/null 2>&1
		elif command -v dnf >/dev/null 2>&1; then
			dnf install -y tar >/dev/null 2>&1
		elif command -v yum >/dev/null 2>&1; then
			yum install -y tar >/dev/null 2>&1
		else
			skip "Không thể tự động cài tar (không tìm thấy apt/dnf/yum). Bỏ qua test."
		fi
	fi


  local vhost_conf="/etc/wptt/vhost/.${TEST_DOMAIN}.conf"
  if [ ! -f "$vhost_conf" ]; then
    skip "Không tìm thấy vhost conf thật của domain test"
  fi

  cp "$vhost_conf" "/tmp/vhost_conf.bak"
  if grep -q '^dinh_dang_nen_ma_nguon=' "$vhost_conf"; then
    sed -i "s/^dinh_dang_nen_ma_nguon=.*/dinh_dang_nen_ma_nguon='1'/" "$vhost_conf"
  else
    echo "dinh_dang_nen_ma_nguon='1'" >> "$vhost_conf"
  fi

  run bash "$SCRIPT_GOC" "$TEST_DOMAIN"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]

  local zst_file
  zst_file=$(find "$BACKUP_ROOT/$TEST_DOMAIN" -maxdepth 1 -name "*.tar.zst" -print -quit 2>/dev/null)
  [ -n "$zst_file" ]
  [ -s "$zst_file" ]
}


@test "Integration: Test backup nén mã nguồn tar.gz tạo đúng đuôi .tar.gz" {
  if [ ! -d "/usr/local/lsws/$TEST_DOMAIN/html" ]; then
     skip "Website $TEST_DOMAIN chưa được tạo thành công."
  fi

	# --- BỔ SUNG: KIỂM TRA VÀ TỰ ĐỘNG CÀI ĐẶT ZSTD NẾU THIẾU ---
  if ! command -v gzip >/dev/null 2>&1; then
    if command -v apt-get >/dev/null 2>&1; then
      apt-get install -y gzip >/dev/null 2>&1
    elif command -v dnf >/dev/null 2>&1; then
      dnf install -y gzip >/dev/null 2>&1
    elif command -v yum >/dev/null 2>&1; then
      yum install -y gzip >/dev/null 2>&1
    else
      skip "Không thể tự động cài gzip (không tìm thấy apt/dnf/yum). Bỏ qua test."
    fi
  fi


	if ! command -v tar >/dev/null 2>&1; then
		if command -v apt-get >/dev/null 2>&1; then
			apt-get install -y tar >/dev/null 2>&1
		elif command -v dnf >/dev/null 2>&1; then
			dnf install -y tar >/dev/null 2>&1
		elif command -v yum >/dev/null 2>&1; then
			yum install -y tar >/dev/null 2>&1
		else
			skip "Không thể tự động cài tar (không tìm thấy apt/dnf/yum). Bỏ qua test."
		fi
	fi


  local vhost_conf="/etc/wptt/vhost/.${TEST_DOMAIN}.conf"
  if [ ! -f "$vhost_conf" ]; then
    skip "Không tìm thấy vhost conf thật của domain test"
  fi

  cp "$vhost_conf" "/tmp/vhost_conf.bak"
  if grep -q '^dinh_dang_nen_ma_nguon=' "$vhost_conf"; then
    sed -i "s/^dinh_dang_nen_ma_nguon=.*/dinh_dang_nen_ma_nguon='2'/" "$vhost_conf"
  else
    echo "dinh_dang_nen_ma_nguon='2'" >> "$vhost_conf"
  fi

  run bash "$SCRIPT_GOC" "$TEST_DOMAIN"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]

  local zst_file
  zst_file=$(find "$BACKUP_ROOT/$TEST_DOMAIN" -maxdepth 1 -name "*.tar.gz" -print -quit 2>/dev/null)
  [ -n "$zst_file" ]
  [ -s "$zst_file" ]
}


