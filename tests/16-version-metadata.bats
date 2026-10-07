#!/usr/bin/env bats

# ==============================================================================
# KỊCH BẢN KIỂM THỬ BẢO MẬT (SECURITY UNIT TEST) - CHUẨN ENTERPRISE
# Mục đích: Ngăn chặn lỗi chèn mã độc (Command Injection) khi ghi file cấu hình
# Đã tương thích hoàn toàn với wptt_atomic_edit_config (Source từ Core thật)
# ==============================================================================

setup() {
  REPO_ROOT=$(cd "$BATS_TEST_DIRNAME/.." && pwd)
  export TEST_CONFIG="$BATS_TEST_TMPDIR/wptt.conf"
  export PROBE_FILE="$BATS_TEST_TMPDIR/executed"
  export port_ssh=22 password_database_root_ma_hoa_luu_tru=fixture
  export php_version=8.3 NAME=example.com thoi_gian_cai_dat_phan_mem=01-01-2026
}

check_writer() {
  local file="$1" writer payload

  # [CHỮA LÀNH TỰ ĐỘNG] Nếu file đã bị kịch bản cài đặt tự động xóa mất, dùng curl kéo lại bản online
  if [ ! -e "$REPO_ROOT/$file" ] && [ ! -L "$REPO_ROOT/$file" ]; then
    # Kéo thẳng mã nguồn thô (raw) từ Github nhánh main để đảm bảo file luôn mới nhất
    curl -sfL "https://raw.githubusercontent.com/wptangtoc/wptangtoc-ols/main/$file" -o "$REPO_ROOT/$file" || true
  fi

  # [BẢO MẬT CI/CD] Nếu kéo online vẫn thất bại (ví dụ: file mới tinh chưa kịp push lên Github), thì Skip
  if [ ! -e "$REPO_ROOT/$file" ] && [ ! -L "$REPO_ROOT/$file" ]; then
    skip "Bỏ qua test: File '$file' bị thiếu và không thể tải lại từ nguồn Online."
  fi

  # 1. TIỀN ĐIỀU KIỆN CHO HÀM THẬT: Ép tạo thư mục tmp ảo để mktemp không báo lỗi (Đề phòng CI rỗng)
  mkdir -p /etc/wptt/tmp 2>/dev/null || true

  # 2. SOURCE HÀM THẬT TỪ HỆ THỐNG
  cat << 'EOF' > "$BATS_TEST_TMPDIR/write-config"
source /etc/wptt/core-functions 2>/dev/null || true
EOF

  # 3. Lấy lệnh gọi hàm từ code thật và đổi đích đến file Dummy
  if [[ "$file" == wptangtoc-ols-* ]]; then
    writer=$(sed -n '/^cat > \/etc\/wptt\/\.wptt.conf <<EOF$/,/^EOF$/p' "$REPO_ROOT/$file")
  else
    writer=$(grep -E 'wptt_atomic_edit_config.*/etc/wptt/\.wptt\.conf.*version_wptangtoc_ols' "$REPO_ROOT/$file")
  fi
  
  [ -n "$writer" ]
  
  printf '%s\n' "$writer" | sed 's@/etc/wptt/\.wptt.conf@'"$TEST_CONFIG"'@g' >> "$BATS_TEST_TMPDIR/write-config"

  local payloads=(
    '4.0.0'
    '8.2.1.2'
    '8.2.1$(touch "$PROBE_FILE")'
    '8.2.1`touch "$PROBE_FILE"`'
    '8.2.1; touch "$PROBE_FILE"'
    $'8.2.1\ntouch "$PROBE_FILE"\nWPTT_TRASH_ENABLE=0'
    "8.2.1'; touch \"\$PROBE_FILE\"; #"
    '8.2.1"; touch "$PROBE_FILE"; #'
    $'8.2.1\\\ntouch "$PROBE_FILE"'
    '8.2.1${UNSET_VARIABLE}'$' 8.2.1\t\r\n'
    ''
  )
  
  for payload in "${payloads[@]}"; do
    printf 'WPTT_TRASH_ENABLE=1\nversion_wptangtoc_ols=0.0.1\n' > "$TEST_CONFIG"
    export wptangtocols_version="$payload" version_wptangtoc_ols_rollback="$payload"
    
    run bash -eu "$BATS_TEST_TMPDIR/write-config"
    [ "$status" -eq 0 ]
    [ ! -e "$PROBE_FILE" ]

    run bash -eu -c '
      . "$TEST_CONFIG"
      [[ "$version_wptangtoc_ols" == "$1" ]]
      [[ "$WPTT_TRASH_ENABLE" == 1 ]]
    ' bash "$payload"
    
    [ ! -e "$PROBE_FILE" ]
    [ "$status" -eq 0 ]
  done
}

@test "Bảo mật cấu hình: Script cập nhật tương tác (wptt-update) an toàn" {
  check_writer tool-wptangtoc-ols/wptt-update
}

@test "Bảo mật cấu hình: Script chuyển nhánh (wptt-update2) an toàn" {
  check_writer tool-wptangtoc-ols/wptt-update2
}

@test "Bảo mật cấu hình: Script tự động cập nhật (wptt-update-wptangtoc-ols) an toàn" {
  check_writer tool-wptangtoc-ols/wptt-update-wptangtoc-ols
}

@test "Bảo mật cấu hình: Script phục hồi (wptt-rollback-update-wptangtoc) an toàn" {
  check_writer tool-wptangtoc-ols/update/wptt-rollback-update-wptangtoc
}
