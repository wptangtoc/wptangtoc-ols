#!/usr/bin/env bats

# =================================================================
# E2E: /etc/wptt/cache/wptt-xoacache
# định dạng màu/spinner của _runing/_rundone/_runloi.
# =================================================================

setup_file() {
  export CI="true"
  export TEST_DOMAIN="test-cache-ols.com"
  export TEST_NO_WP="no-wp-cache.com"
  export WP_BIN="/usr/local/bin/wp"
  export WP_BAK="/tmp/wptt-wp-cli.bak"

  # Nếu lần chạy trước bị ngắt giữa chừng khi đang mock WP-CLI -> phục hồi bản gốc trước
  if [ -f "$WP_BAK" ]; then
    cp -p "$WP_BAK" "$WP_BIN" && rm -f "$WP_BAK"
  fi

  # 1. WEBSITE 1: Full WordPress (test xóa cache thật)
  bash /etc/wptt/domain/wptt-themwebsite "$TEST_DOMAIN" >/dev/null 2>&1 || true
  cat <<EOF >/tmp/wp-answers-cache.txt
Website Test Cache
admin_cache
PassKh0_123!@#
admin@${TEST_DOMAIN}
EOF
  bash /etc/wptt/wptt-install-wordpress2 "$TEST_DOMAIN" </tmp/wp-answers-cache.txt >/dev/null 2>&1 || true
  rm -f /tmp/wp-answers-cache.txt

  # 2. WEBSITE 2: chỉ có Vhost, KHÔNG có WordPress (test ngoại lệ)
  bash /etc/wptt/domain/wptt-themwebsite "$TEST_NO_WP" >/dev/null 2>&1 || true

  # Fail sớm, nói rõ nguyên nhân: tránh các test phía sau fail mơ hồ
  if [ ! -f "/usr/local/lsws/$TEST_DOMAIN/html/wp-load.php" ] || [ ! -f "/usr/local/lsws/$TEST_DOMAIN/html/wp-config.php" ]; then
    echo "[SETUP LỖI] Cài WordPress cho $TEST_DOMAIN thất bại (thiếu wp-load.php/wp-config.php)" >&3
    return 1
  fi
  if [ ! -f "/etc/wptt/vhost/.$TEST_NO_WP.conf" ]; then
    echo "[SETUP LỖI] Tạo vhost $TEST_NO_WP thất bại" >&3
    return 1
  fi

  # Plugin giả để Fallback quét thư mục nhận diện được LiteSpeed Cache
  mkdir -p "/usr/local/lsws/$TEST_DOMAIN/html/wp-content/plugins/litespeed-cache"
}

teardown_file() {
  # Phòng hờ: luôn trả WP-CLI gốc nếu còn bản backup
  if [ -f "/tmp/wptt-wp-cli.bak" ]; then
    cp -p /tmp/wptt-wp-cli.bak /usr/local/bin/wp && rm -f /tmp/wptt-wp-cli.bak
  fi
  bash /etc/wptt/domain/wptt-xoa-website "test-cache-ols.com" >/dev/null 2>&1 || true
  bash /etc/wptt/domain/wptt-xoa-website "no-wp-cache.com" >/dev/null 2>&1 || true
}

# =================================================================
# SETUP / TEARDOWN TỪNG TEST
# =================================================================
setup() {
  export CI="true"
  export SCRIPT_GOC="/etc/wptt/cache/wptt-xoacache"
  export SCRIPT_TEST="/tmp/wptt-xoacache-test.sh"
  export SCRIPT_CHILD="/tmp/wptt-xoacache-child.sh"
  export CALL_LOG="/tmp/wptt-xoacache-calls.log"
  export WP_MOCK_LOG="/tmp/wptt-wp-mock.log"

  : >"$CALL_LOG"
  : >"$WP_MOCK_LOG"
  chmod 666 "$WP_MOCK_LOG" # mock WP-CLI chạy bằng user vhost (runuser) nên cần quyền ghi

  cp "$SCRIPT_GOC" "$SCRIPT_TEST"

  # Không cho script thoát về menu chính làm treo CI
  sed -i 's/exec \/etc\/wptt\/wptt-cache-main.*/exit 1/g' "$SCRIPT_TEST"

  # Vòng lặp "Tất cả website" gọi chéo file gốc -> chuyển hướng qua wrapper,
  # wrapper ghi lại domain được xử lý rồi mới chạy bản test
  sed -i "s|/etc/wptt/cache/wptt-xoacache|$SCRIPT_CHILD|g" "$SCRIPT_TEST"
  echo "exit 0" >>"$SCRIPT_TEST"
  chmod +x "$SCRIPT_TEST"

  cat >"$SCRIPT_CHILD" <<EOF
#!/bin/bash
echo "\$1" >> "$CALL_LOG"
exec /bin/bash "$SCRIPT_TEST" "\$@"
EOF
  chmod +x "$SCRIPT_CHILD"
}

teardown() {
  # Luôn phục hồi WP-CLI thật, kể cả khi test fail giữa chừng
  if [ -f "$WP_BAK" ]; then
    cp -p "$WP_BAK" "$WP_BIN" && rm -f "$WP_BAK"
  fi
  rm -f "$SCRIPT_TEST" "$SCRIPT_CHILD" "$CALL_LOG" "$WP_MOCK_LOG" 2>/dev/null || true
}

# --- HÀM GỠ LỖI ---
in_log_neu_loi() {
  local ma_ky_vong="$1"
  if [ "$status" -ne "$ma_ky_vong" ]; then
    echo -e "\n[LỖI TEST] Kịch bản không trả về mã $ma_ky_vong như kỳ vọng!" >&3
    echo "Mã trạng thái thực tế : $status" >&3
    echo -e "Nội dung in ra màn hình:\n$output" >&3
  fi
}

# Mock WP-CLI bằng PHP: ghi lại mọi lệnh được gọi để kiểm chứng
mock_wp_cli() {
  cp -p "$WP_BIN" "$WP_BAK"
  cat <<'EOF' >"$WP_BIN"
<?php
$args = implode(" ", array_slice($argv, 1));
file_put_contents("/tmp/wptt-wp-mock.log", $args . "\n", FILE_APPEND);
// Ép WP-CLI "sập" khi đọc plugin -> kích hoạt Fallback quét thư mục
if (strpos($args, 'plugin list') !== false) {
    exit(1);
}
// Ép purge ném lỗi cURL -> kích hoạt xóa vật lý (Atomic Swap)
if (strpos($args, 'litespeed-purge') !== false) {
    echo "cURL error 28: Connection timed out\n";
    exit(0);
}
exit(0);
EOF
  chmod 755 "$WP_BIN"
}

restore_wp_cli() {
  if [ -f "$WP_BAK" ]; then
    cp -p "$WP_BAK" "$WP_BIN" && rm -f "$WP_BAK"
  fi
}

# =================================================================
# NHÓM 1: NGOẠI LỆ
# =================================================================

@test "Integration: Chặn xóa cache nếu Tên miền không tồn tại" {
  run bash "$SCRIPT_TEST" "domain-khong-ton-tai.com"

  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không tồn tại trên hệ thống" ]]
}

@test "Integration: Chặn xóa cache nếu Không phải mã nguồn WordPress" {
  run bash "$SCRIPT_TEST" "$TEST_NO_WP"

  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không sử dụng mã nguồn" || "$output" =~ "dành cho mã nguồn WordPress" ]]
  # Không được đụng tới WP-CLI khi không phải WordPress
  [ ! -s "$WP_MOCK_LOG" ]
}

# =================================================================
# NHÓM 2: THỰC CHIẾN (FALLBACK & ZERO-DOWNTIME)
# =================================================================

@test "Integration: Fallback đọc Plugin và Xóa LiteSpeed Cache vật lý (Atomic Swap)" {
  local lscache="/usr/local/lsws/$TEST_DOMAIN/lscache"

  # FIXTURE: dữ liệu cache vật lý
  mkdir -p "$lscache/test-data"
  echo "stale" >"$lscache/test-data/page.html"

  mock_wp_cli
  run bash "$SCRIPT_TEST" "$TEST_DOMAIN"
  restore_wp_cli

  in_log_neu_loi 0
  [ "$status" -eq 0 ]

  # Hành vi 1: script đã gọi đúng chuỗi lệnh (plugin list thất bại -> purge qua WP-CLI)
  grep -q "plugin list" "$WP_MOCK_LOG"
  grep -q "litespeed-purge all" "$WP_MOCK_LOG"

  # Hành vi 2: nhận diện LiteSpeed Cache từ Fallback và báo xóa vật lý
  # (khớp đúng chuỗi script in ra: "... cache LiteSpeed Cache (Vật lý)")
  [[ "$output" =~ "LiteSpeed Cache" ]]
  [[ "$output" =~ "Vật lý" ]]

  # Hành vi 3: dữ liệu cũ biến mất nhưng thư mục lscache được tái tạo ngay (zero-downtime)
  [ ! -e "$lscache/test-data" ]
  [ -d "$lscache" ]
  [ -z "$(ls -A "$lscache")" ]

  # Hành vi 4: thư mục rác được dọn nền, không để lại rác
  for _ in {1..20}; do
    [ -z "$(compgen -G "/usr/local/lsws/$TEST_DOMAIN/lscache_trash_*" || true)" ] && break
    sleep 0.25
  done
  [ -z "$(compgen -G "/usr/local/lsws/$TEST_DOMAIN/lscache_trash_*" || true)" ]
}

@test "Integration: Không có plugin LiteSpeed thì không đụng thư mục lscache" {
  local lscache="/usr/local/lsws/$TEST_DOMAIN/lscache"
  local plugin_dir="/usr/local/lsws/$TEST_DOMAIN/html/wp-content/plugins/litespeed-cache"

  mkdir -p "$lscache/keep-me"
  mv "$plugin_dir" "${plugin_dir}.off"

  mock_wp_cli
  run bash "$SCRIPT_TEST" "$TEST_DOMAIN"
  restore_wp_cli
  mv "${plugin_dir}.off" "$plugin_dir"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [ -d "$lscache/keep-me" ]
  ! grep -q "litespeed-purge" "$WP_MOCK_LOG"
}

@test "Integration: Xóa cache Tất cả website chỉ quét website WordPress" {
  run bash "$SCRIPT_TEST" "Tất cả website"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "DASHBOARD THAO TÁC HÀNG LOẠT" ]]

  # Kiểm chứng bằng log gọi chéo (không phụ thuộc cách _runing in tên miền)
  grep -qx "$TEST_DOMAIN" "$CALL_LOG"
  ! grep -qx "$TEST_NO_WP" "$CALL_LOG"
}

