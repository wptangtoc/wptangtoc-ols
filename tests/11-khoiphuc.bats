#!/usr/bin/env bats

# ==============================================================================
# FILE: 11-khoi-phuc.bats
# MỤC ĐÍCH: Kiểm thử Toàn diện Cơ chế Khôi phục (Restore) Website & Database
# ==============================================================================

export CI="true"
export SCRIPT_KHOIPHUC="${WPTT_RESTORE_SCRIPT:-/etc/wptt/backup-restore/wptt-khoiphuc}"
export SCRIPT_SAOLUU="${WPTT_SAOLUU_SCRIPT:-/etc/wptt/backup-restore/wptt-saoluu}"
export SCRIPT_THEM="${WPTT_THEMWEBSITE_SCRIPT:-/etc/wptt/domain/wptt-themwebsite}"
export SCRIPT_XOA="${WPTT_XOAWEBSITE_SCRIPT:-/etc/wptt/domain/wptt-xoa-website}"
export SCRIPT_CAI_WP="${WPTT_CAI_WP_SCRIPT:-/etc/wptt/wptt-install-wordpress2}"
export BACKUP_ROOT="/usr/local/backup-website"
export FILE_DUNG_CHUNG="/tmp/wptt_bats_khoiphuc_$$.sh"

# --- CÁC HÀM TIỆN ÍCH ENTERPRISE ---
in_log_neu_loi() {
  local ma_ky_vong="$1"
  if [ "$status" -ne "$ma_ky_vong" ]; then
    echo -e "\n[LỖI TEST] Kịch bản khôi phục không trả về mã $ma_ky_vong như kỳ vọng!" >&3
    echo "Mã trạng thái thực tế : $status" >&3
    echo -e "Nội dung in ra màn hình:\n$output" >&3
  fi
}

# Đổi config chuẩn theo file .wptt.conf toàn cầu
set_backup_format() {
  local source_format="$1"
  local db_format="$2"
  local conf="/etc/wptt/.wptt.conf"
  
  # Xóa sạch config cũ tránh lặp dòng
  sed -i '/dinh_dang_nen_ma_nguon=/d' "$conf" 2>/dev/null || true
  sed -i '/sql_gz=/d' "$conf" 2>/dev/null || true
  
  # Bơm config mới vào cuối
  echo "dinh_dang_nen_ma_nguon='$source_format'" >> "$conf"
  echo "sql_gz='$db_format'" >> "$conf"
}

# =================================================================
# PHẦN A — SETUP & TEARDOWN
# =================================================================

setup_file() {
  export UNIT_TMP
  UNIT_TMP="$(mktemp -d)"
  export TEST_DOMAIN="wptest-restore-$(date +%s)-$$.com"
  echo "export TEST_DOMAIN=\"$TEST_DOMAIN\"" > "$FILE_DUNG_CHUNG"
  return 0
}

teardown_file() {
  rm -rf "${UNIT_TMP:-/tmp/dummy_wptt}" 2>/dev/null || true
  
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

setup() {
  if [ -f "$FILE_DUNG_CHUNG" ]; then
      source "$FILE_DUNG_CHUNG" 2>/dev/null || true
  fi

  if echo "$BATS_TEST_DESCRIPTION" | grep -q "Integration"; then
    if [ ! -x "$SCRIPT_KHOIPHUC" ] || [ ! -x "$SCRIPT_SAOLUU" ] || [ ! -x "$SCRIPT_THEM" ] || [ ! -x "$SCRIPT_CAI_WP" ]; then
      skip "Thiếu script môi trường. Bỏ qua Integration Test"
    fi
  fi
  return 0
}

teardown() {
  rm -f "/etc/wptt/tmp/wptt_lock_sao_luu_khoi_phuc_${TEST_DOMAIN}.lock" 2>/dev/null || true
  rm -f "/usr/local/lsws/$TEST_DOMAIN/html/.maintenance" 2>/dev/null || true
  return 0
}

# =================================================================
# PHẦN B — UNIT TEST
# =================================================================

@test "Unit: Chặn khôi phục nếu tên miền không tồn tại trên máy chủ" {
  run bash "$SCRIPT_KHOIPHUC" "domain-ao-khong-ton-tai.com"
  in_log_neu_loi 1
  [ "$status" -ne 0 ]
  [[ "$output" =~ "không tồn tại trên hệ thống" ]]
}

# =================================================================
# PHẦN C — INTEGRATION TEST: END-TO-END RESTORE CYCLE
# =================================================================

@test "Integration: Chuẩn bị Môi trường — Cài WordPress & Cài công cụ nén" {
  run bash "$SCRIPT_THEM" "$TEST_DOMAIN"
  [ "$status" -eq 0 ]

  export SCRIPT_TEST="/tmp/wptt-install-wp-test-restore.sh"
  cp "$SCRIPT_CAI_WP" "$SCRIPT_TEST"
  sed -i 's/exec \/etc\/wptt\/wptt-wordpress-main.*/exit 0/g' "$SCRIPT_TEST"
  sed -i 's/exec \/usr\/bin\/wptangtoc.*/exit 0/g' "$SCRIPT_TEST"
  echo "exit 0" >> "$SCRIPT_TEST"
  chmod +x "$SCRIPT_TEST"

  local INPUTS="Web Restore\nadmin_$RANDOM\nPassKh0_$RANDOM\nadmin@$TEST_DOMAIN\n"
  
  cp /etc/wptt/core-functions /tmp/core-functions.bak 2>/dev/null || true
  cat << 'EOF' > /etc/wptt/core-functions
source /tmp/core-functions.bak
wptt_xac_nhan() { return 0; }
EOF

  run bash -c "echo -e \"$INPUTS\" | bash $SCRIPT_TEST \"$TEST_DOMAIN\""
  mv /tmp/core-functions.bak /etc/wptt/core-functions 2>/dev/null || true

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  rm -f "$SCRIPT_TEST"
}

@test "Integration: Khôi phục thành công định dạng truyền thống [.zip] & [.sql]" {
  set_backup_format '0' '0'
  rm -rf -- "$BACKUP_ROOT/$TEST_DOMAIN"/* 2>/dev/null || true
  bash "$SCRIPT_SAOLUU" "$TEST_DOMAIN" >/dev/null

  rm -f "/usr/local/lsws/$TEST_DOMAIN/html/wp-config.php"
  
  run bash "$SCRIPT_KHOIPHUC" "$TEST_DOMAIN"
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  
  [ -f "/usr/local/lsws/$TEST_DOMAIN/html/wp-config.php" ]
}

@test "Integration: Khôi phục thành công định dạng siêu tốc GZIP [.tar.gz] & [.sql.gz]" {
  set_backup_format '2' '1'
  rm -rf -- "$BACKUP_ROOT/$TEST_DOMAIN"/* 2>/dev/null || true
  bash "$SCRIPT_SAOLUU" "$TEST_DOMAIN" >/dev/null

  echo "FILE_BI_HONG" > "/usr/local/lsws/$TEST_DOMAIN/html/wp-load.php"

  run bash "$SCRIPT_KHOIPHUC" "$TEST_DOMAIN"
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  
  run cat "/usr/local/lsws/$TEST_DOMAIN/html/wp-load.php"
  [[ ! "$output" =~ "FILE_BI_HONG" ]]
}

@test "Integration: Khôi phục thành công định dạng siêu tốc ZSTD [.tar.zst] & [.sql.zst]" {
  set_backup_format '1' '2'
  rm -rf -- "$BACKUP_ROOT/$TEST_DOMAIN"/* 2>/dev/null || true
  bash "$SCRIPT_SAOLUU" "$TEST_DOMAIN" >/dev/null

  echo "FILE_BI_HONG" > "/usr/local/lsws/$TEST_DOMAIN/html/wp-load.php"

  run bash "$SCRIPT_KHOIPHUC" "$TEST_DOMAIN"
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  
  run cat "/usr/local/lsws/$TEST_DOMAIN/html/wp-load.php"
  [[ ! "$output" =~ "FILE_BI_HONG" ]]
}

@test "Integration: Bẫy Bảo Mật — Chặn khôi phục nếu file Database dưới 3KB" {
  rm -f -- "$BACKUP_ROOT/$TEST_DOMAIN"/*.sql* 2>/dev/null || true
  # SỬ DỤNG TOUCH ĐỂ TẠO FILE ĐÚNG 0 BYTES (Tránh lỗi phân mảnh ổ cứng 4KB)
  touch "$BACKUP_ROOT/$TEST_DOMAIN/db_corrupt.sql"

  run bash "$SCRIPT_KHOIPHUC" "$TEST_DOMAIN"
  in_log_neu_loi 1
  [ "$status" -ne 0 ]
  [[ "$output" =~ "quá nhỏ" ]] || [[ "$output" =~ "Dưới 3KB" ]]
}

# =================================================================
# FAULT INJECTION (TIÊM LỖI KIỂM THỬ ĐỘ BỀN)
# =================================================================

@test "Integration: Bẫy Bảo Mật — Bảo toàn Mã nguồn nếu ZIP bị hỏng" {
  set_backup_format '0' '0'
  rm -rf -- "$BACKUP_ROOT/$TEST_DOMAIN"/* 2>/dev/null || true
  bash "$SCRIPT_SAOLUU" "$TEST_DOMAIN" >/dev/null

  local zip_file
  zip_file=$(find "$BACKUP_ROOT/$TEST_DOMAIN" -maxdepth 1 -name "*.zip" -print -quit 2>/dev/null)
  [ -n "$zip_file" ] 
  
  echo "DAY_LA_DU_LIEU_RAC_GAY_CORRUPT_FILE" > "$zip_file"
  echo "// DONG_CHU_NAY_PHAI_CON_NGUYEN_VEN" >> "/usr/local/lsws/$TEST_DOMAIN/html/wp-load.php"

  run bash "$SCRIPT_KHOIPHUC" "$TEST_DOMAIN"
  
  in_log_neu_loi 1
  [ "$status" -ne 0 ]
  [[ "$output" =~ "bị hỏng" ]] || [[ "$output" =~ "Lỗi giải nén" ]]

  run cat "/usr/local/lsws/$TEST_DOMAIN/html/wp-load.php"
  [[ "$output" =~ "// DONG_CHU_NAY_PHAI_CON_NGUYEN_VEN" ]]
}

@test "Integration: Bẫy Bảo Mật — Bảo toàn Mã nguồn nếu TAR.GZ bị hỏng" {
  set_backup_format '2' '1'
  rm -rf -- "$BACKUP_ROOT/$TEST_DOMAIN"/* 2>/dev/null || true
  bash "$SCRIPT_SAOLUU" "$TEST_DOMAIN" >/dev/null

  local gz_file
  gz_file=$(find "$BACKUP_ROOT/$TEST_DOMAIN" -maxdepth 1 -name "*.tar.gz" -print -quit 2>/dev/null)
  [ -n "$gz_file" ]
  
  echo "DAY_LA_DU_LIEU_RAC_GAY_CORRUPT_FILE_GZIP" > "$gz_file"
  echo "// DONG_CHU_NAY_PHAI_CON_NGUYEN_VEN_GZ" >> "/usr/local/lsws/$TEST_DOMAIN/html/wp-load.php"

  run bash "$SCRIPT_KHOIPHUC" "$TEST_DOMAIN"
  
  in_log_neu_loi 1
  [ "$status" -ne 0 ]

  run cat "/usr/local/lsws/$TEST_DOMAIN/html/wp-load.php"
  [[ "$output" =~ "// DONG_CHU_NAY_PHAI_CON_NGUYEN_VEN_GZ" ]]
}

@test "Integration: Bẫy Bảo Mật — Bảo toàn Mã nguồn nếu TAR.ZST bị hỏng" {
  set_backup_format '1' '2'
  rm -rf -- "$BACKUP_ROOT/$TEST_DOMAIN"/* 2>/dev/null || true
  bash "$SCRIPT_SAOLUU" "$TEST_DOMAIN" >/dev/null

  local zst_file
  zst_file=$(find "$BACKUP_ROOT/$TEST_DOMAIN" -maxdepth 1 -name "*.tar.zst" -print -quit 2>/dev/null)
  [ -n "$zst_file" ]
  
  echo "DAY_LA_DU_LIEU_RAC_GAY_CORRUPT_FILE_ZSTD" > "$zst_file"
  echo "// DONG_CHU_NAY_PHAI_CON_NGUYEN_VEN_ZST" >> "/usr/local/lsws/$TEST_DOMAIN/html/wp-load.php"

  run bash "$SCRIPT_KHOIPHUC" "$TEST_DOMAIN"
  
  in_log_neu_loi 1
  [ "$status" -ne 0 ]

  run cat "/usr/local/lsws/$TEST_DOMAIN/html/wp-load.php"
  [[ "$output" =~ "// DONG_CHU_NAY_PHAI_CON_NGUYEN_VEN_ZST" ]]
}

@test "Integration: Bẫy Bảo Mật — Bảo toàn Database nếu file SQL bị hỏng" {
  set_backup_format '0' '0'
  rm -rf -- "$BACKUP_ROOT/$TEST_DOMAIN"/* 2>/dev/null || true
  bash "$SCRIPT_SAOLUU" "$TEST_DOMAIN" >/dev/null

  local database_file_sql
  database_file_sql=$(find "$BACKUP_ROOT/$TEST_DOMAIN" -maxdepth 1 -name "*.sql" -print -quit 2>/dev/null)
  [ -n "$database_file_sql" ]

  # Tiêm lỗi
  rm -f "$database_file_sql"
  for i in {1..100}; do echo "DAY_LA_FILE_GZ_GIA_MAO_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" >> "$database_file_sql"; done

  run bash "$SCRIPT_KHOIPHUC" "$TEST_DOMAIN"
  
  in_log_neu_loi 1
  [ "$status" -ne 0 ]
  [[ "$output" =~ "hỏng cấu trúc" ]] || [[ "$output" =~ "Corrupt" ]] || [[ "$output" =~ "lỗi" ]]
}


@test "Integration: Bẫy Bảo Mật — Bảo toàn Database nếu file SQL.GZ bị hỏng" {
  set_backup_format '2' '1'
  rm -rf -- "$BACKUP_ROOT/$TEST_DOMAIN"/* 2>/dev/null || true
  bash "$SCRIPT_SAOLUU" "$TEST_DOMAIN" >/dev/null

  local gz_db
  gz_db=$(find "$BACKUP_ROOT/$TEST_DOMAIN" -maxdepth 1 -name "*.sql.gz" -print -quit 2>/dev/null)
  [ -n "$gz_db" ]

  # Tiêm lỗi
  rm -f "$gz_db"
  for i in {1..100}; do echo "DAY_LA_FILE_GZ_GIA_MAO_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" >> "$gz_db"; done

  run bash "$SCRIPT_KHOIPHUC" "$TEST_DOMAIN"
  
  in_log_neu_loi 1
  [ "$status" -ne 0 ]
  [[ "$output" =~ "hỏng cấu trúc" ]] || [[ "$output" =~ "Corrupt" ]] || [[ "$output" =~ "lỗi" ]]
}

@test "Integration: Bẫy Bảo Mật — Bảo toàn Database nếu file SQL.ZST bị hỏng" {
  set_backup_format '1' '2'
  rm -rf -- "$BACKUP_ROOT/$TEST_DOMAIN"/* 2>/dev/null || true
  bash "$SCRIPT_SAOLUU" "$TEST_DOMAIN" >/dev/null

  local zst_db
  zst_db=$(find "$BACKUP_ROOT/$TEST_DOMAIN" -maxdepth 1 -name "*.sql.zst" -print -quit 2>/dev/null)
  [ -n "$zst_db" ]

  # Tiêm lỗi
  rm -f "$zst_db"
  for i in {1..100}; do echo "DAY_LA_FILE_ZST_GIA_MAO_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" >> "$zst_db"; done

  run bash "$SCRIPT_KHOIPHUC" "$TEST_DOMAIN"
  
  in_log_neu_loi 1
  [ "$status" -ne 0 ]
  [[ "$output" =~ "hỏng cấu trúc" ]] || [[ "$output" =~ "Corrupt" ]] || [[ "$output" =~ "lỗi" ]]
}
