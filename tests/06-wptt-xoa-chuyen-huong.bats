#!/usr/bin/env bats
# ==============================================================================
# Test tích hợp: /etc/wptt/domain/wptt-xoa-domain-chuyen-huong
# ==============================================================================

setup() {
  export CI="true"
  export SCRIPT_GOC="/etc/wptt/domain/wptt-xoa-domain-chuyen-huong"
  export TMP_DIR="${BATS_TEST_TMPDIR:-/tmp}"
  export SCRIPT_TEST="$TMP_DIR/wptt-xoa-chuyen-huong-test.sh"
  export CORE_BAK="$TMP_DIR/core-functions.bak"
  export DIR_CH="/etc/wptt/chuyen-huong"
  export DIR_CH_BAK="/etc/wptt/chuyen-huong.bats.bak"

  # Danh sách domain fixture để teardown dọn sạch
  export DOM_FULL="test-del-full.com"
  export DOM_KEEP="test-keep-source.com"
  export DOM_GHOST="test-ghost-vhost.com"

  # 1. BẢO VỆ MÔI TRƯỜNG
  cp /etc/wptt/core-functions "$CORE_BAK" 2>/dev/null || true

  # Cô lập thư mục cấu hình thật (không ghi đè bản backup cũ nếu lần chạy trước bị ngắt)
  if [ -d "$DIR_CH" ] && [ ! -d "$DIR_CH_BAK" ]; then
    mv "$DIR_CH" "$DIR_CH_BAK"
  fi
  rm -rf "$DIR_CH"
  mkdir -p "$DIR_CH" /etc/wptt/vhost

  # 2. TẠO BẢN SAO SCRIPT ĐỂ MOCK
  cp "$SCRIPT_GOC" "$SCRIPT_TEST"

  # 3. MOCK LỆNH PHÁ HỦY
  # 3a. wptt-xoa-website
  sed -i 's|/bin/bash /etc/wptt/domain/wptt-xoa-website|echo "[MOCK_SAFE] Đã gọi wptt-xoa-website"|g' "$SCRIPT_TEST"

  # 3b. wptt_xoa_vhost_ao_chuyen_huong: return sớm ngay đầu hàm (không userdel/umount/rm -rf thật)
  sed -i 's|^function wptt_xoa_vhost_ao_chuyen_huong() {|&\n  echo "[MOCK_SAFE] Đã gọi wptt_xoa_vhost_ao_chuyen_huong $1"; return 0|' "$SCRIPT_TEST"

  # 3c. Reload LSWS và sleep: bỏ qua cho nhanh và an toàn
  sed -i 's|^wptt_smart_reload_lsws .*|:|' "$SCRIPT_TEST"
  sed -i -E 's/^[[:space:]]*sleep [0-9.]+[[:space:]]*$/  :/' "$SCRIPT_TEST"

  # 4. CHỐT CHẶN: nếu mock không áp dụng được thì dừng ngay, tuyệt đối không chạy code thật
  grep -q 'MOCK_SAFE.*wptt-xoa-website' "$SCRIPT_TEST" || {
    echo "Mock wptt-xoa-website không áp dụng được, dừng test để bảo vệ server" >&2
    return 1
  }
  grep -q 'MOCK_SAFE.*wptt_xoa_vhost_ao_chuyen_huong' "$SCRIPT_TEST" || {
    echo "Mock wptt_xoa_vhost_ao_chuyen_huong không áp dụng được, dừng test để bảo vệ server" >&2
    return 1
  }

  chmod +x "$SCRIPT_TEST" || true
}

teardown() {
  # 1. KHÔI PHỤC CORE
  if [ -f "$CORE_BAK" ]; then
    cp -f "$CORE_BAK" /etc/wptt/core-functions 2>/dev/null || true
  fi

  # 2. TRẢ LẠI THƯ MỤC CẤU HÌNH THẬT
  rm -rf "$DIR_CH"
  if [ -d "$DIR_CH_BAK" ]; then
    mv "$DIR_CH_BAK" "$DIR_CH"
  fi

  # 3. DỌN FIXTURE
  local d
  for d in "$DOM_FULL" "$DOM_KEEP" "$DOM_GHOST"; do
    rm -f "/etc/wptt/vhost/.$d.conf" 2>/dev/null || true
    rm -rf "/usr/local/lsws/$d" 2>/dev/null || true
  done
  rm -f "$SCRIPT_TEST" "$CORE_BAK" 2>/dev/null || true
}

# --- HELPERS -----------------------------------------------------------------
in_log_neu_loi() {
  local ma_ky_vong="$1"
  if [ "$status" -ne "$ma_ky_vong" ]; then
    echo -e "\n[LỖI TEST] Kịch bản không trả về mã $ma_ky_vong như kỳ vọng!" >&3
    echo "Mã trạng thái thực tế : $status" >&3
    echo -e "Nội dung in ra màn hình:\n$output" >&3
  fi
}

# Tạo website giả đang chuyển hướng, có mã nguồn PHP
tao_fixture_co_ma_nguon() {
  local dom="$1"
  touch "$DIR_CH/.$dom.conf"
  mkdir -p "/usr/local/lsws/$dom/html"
  touch "/usr/local/lsws/$dom/html/index.php"
}

# Ghi đè wptt_xac_nhan để luôn trả về "Không đồng ý"
ep_xac_nhan_tu_choi() {
  printf 'source %q\nwptt_xac_nhan() { return 1; }\n' "$CORE_BAK" >/etc/wptt/core-functions
}

# =================================================================
# NHÓM 1: NGOẠI LỆ & ĐẦU VÀO (mọi trường hợp đều phải exit 1)
# =================================================================

@test "Exception: VPS chưa từng thiết lập chuyển hướng (thiếu thư mục) -> exit 1" {
  rm -rf "$DIR_CH"

  run bash "$SCRIPT_TEST"

  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "chưa từng thiết lập chuyển hướng domain nào" ]]
}

@test "Exception: Có thư mục nhưng chưa có domain nào chuyển hướng -> exit 1" {
  run bash "$SCRIPT_TEST"

  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "chưa có domain nào được kích hoạt" ]]
}

@test "Exception: File cấu hình có tên domain không hợp lệ bị bỏ qua -> exit 1" {
  touch "$DIR_CH/.bad_domain!.conf"
  touch "$DIR_CH/.abc.conf"          # thiếu TLD hợp lệ

  run bash "$SCRIPT_TEST"

  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "chưa có domain nào được kích hoạt" ]]
}

@test "Exception: Chọn 0 để thoát -> exit 1, không xóa gì" {
  tao_fixture_co_ma_nguon "$DOM_FULL"

  run bash -c "echo '0' | bash $SCRIPT_TEST"

  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [ -f "$DIR_CH/.$DOM_FULL.conf" ]
  [ -f "/usr/local/lsws/$DOM_FULL/html/index.php" ]
}

@test "Exception: Nhập lựa chọn sai rồi thoát -> báo không hợp lệ, exit 1" {
  tao_fixture_co_ma_nguon "$DOM_FULL"

  run bash -c "printf '9\nabc\n0\n' | bash $SCRIPT_TEST"

  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Lựa chọn không hợp lệ" ]]
  [ -f "$DIR_CH/.$DOM_FULL.conf" ]
}

@test "Exception: stdin đóng đột ngột (EOF) -> exit 1, không treo" {
  tao_fixture_co_ma_nguon "$DOM_FULL"

  run bash -c "bash $SCRIPT_TEST </dev/null"

  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [ -f "$DIR_CH/.$DOM_FULL.conf" ]
}

# =================================================================
# NHÓM 2: LUỒNG XÓA THỰC CHIẾN
# =================================================================

@test "Integration: Xóa chuyển hướng VÀ xóa sạch mã nguồn (CI Auto-Yes, chọn từ menu)" {
  tao_fixture_co_ma_nguon "$DOM_FULL"
  touch "/etc/wptt/vhost/.$DOM_FULL.conf"   # có hồ sơ vhost gốc -> TRƯỜNG HỢP 1

  run bash -c "echo '1' | bash $SCRIPT_TEST"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Xóa hoàn toàn Mã nguồn" ]]
  [[ "$output" =~ "[MOCK_SAFE] Đã gọi wptt-xoa-website" ]]
  [[ ! "$output" =~ "Đã gọi wptt_xoa_vhost_ao_chuyen_huong" ]]
  [ ! -f "$DIR_CH/.$DOM_FULL.conf" ]        # file đánh dấu chuyển hướng đã bị dọn
}

@test "Integration: Truyền domain qua tham số CLI -> bỏ qua menu, xóa thành công" {
  tao_fixture_co_ma_nguon "$DOM_FULL"
  touch "/etc/wptt/vhost/.$DOM_FULL.conf"

  run bash "$SCRIPT_TEST" "$DOM_FULL"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ ! "$output" =~ "DANH SÁCH WEBSITE ĐANG CHUYỂN HƯỚNG" ]]
  [[ "$output" =~ "[MOCK_SAFE] Đã gọi wptt-xoa-website" ]]
  [ ! -f "$DIR_CH/.$DOM_FULL.conf" ]
}

@test "Integration: Vhost ảo rỗng (không có hồ sơ vhost gốc) -> gọi hàm tháo dỡ vhost ảo" {
  touch "$DIR_CH/.$DOM_GHOST.conf"
  # Cố ý KHÔNG tạo /etc/wptt/vhost/.$DOM_GHOST.conf và không có mã nguồn .php

  run bash -c "echo '1' | bash $SCRIPT_TEST"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "[MOCK_SAFE] Đã gọi wptt_xoa_vhost_ao_chuyen_huong $DOM_GHOST" ]]
  [[ "$output" =~ "Xóa hoàn toàn Virtual Host chuyển hướng" ]]
  [[ ! "$output" =~ "Đã gọi wptt-xoa-website" ]]
  [ ! -f "$DIR_CH/.$DOM_GHOST.conf" ]
}

@test "Integration: Chỉ gỡ chuyển hướng, GIỮ LẠI mã nguồn (từ chối xóa)" {
  tao_fixture_co_ma_nguon "$DOM_KEEP"
  local htaccess="/usr/local/lsws/$DOM_KEEP/html/.htaccess"

  # .htaccess đang chứa khối Redirect 301
  printf '%s\n' \
    "#begin-chuyen-huong-domain-wptangtoc" \
    "Redirect 301 / https://example.org/" \
    "#end-chuyen-huong-domain-wptangtoc" >"$htaccess"

  ep_xac_nhan_tu_choi

  run bash -c "echo '1' | bash $SCRIPT_TEST"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Giữ lại dữ liệu. Chỉ gỡ bỏ luật Chuyển hướng" ]]
  [[ ! "$output" =~ "Đã gọi wptt-xoa-website" ]]

  # Khối chuyển hướng phải biến mất, .htaccess được phục hồi rewrite WordPress
  run grep -c "begin-chuyen-huong-domain-wptangtoc" "$htaccess"
  [ "$output" = "0" ]
  run grep -q "RewriteEngine On" "$htaccess"
  [ "$status" -eq 0 ]

  # Mã nguồn còn nguyên, file đánh dấu chuyển hướng đã dọn
  [ -f "/usr/local/lsws/$DOM_KEEP/html/index.php" ]
  [ ! -f "$DIR_CH/.$DOM_KEEP.conf" ]
}

@test "Integration: Giữ mã nguồn nhưng .htaccess có luật khác -> chỉ cắt khối chuyển hướng" {
  tao_fixture_co_ma_nguon "$DOM_KEEP"
  local htaccess="/usr/local/lsws/$DOM_KEEP/html/.htaccess"

  printf '%s\n' \
    "RewriteEngine On" \
    "RewriteRule ^custom$ /custom.php [L]" \
    "#begin-chuyen-huong-domain-wptangtoc" \
    "Redirect 301 / https://example.org/" \
    "#end-chuyen-huong-domain-wptangtoc" >"$htaccess"

  ep_xac_nhan_tu_choi

  run bash -c "echo '1' | bash $SCRIPT_TEST"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  run grep -c "begin-chuyen-huong-domain-wptangtoc" "$htaccess"
  [ "$output" = "0" ]
  run grep -q "RewriteRule ^custom\$ /custom.php" "$htaccess"   # luật tùy chỉnh của người dùng còn nguyên
  [ "$status" -eq 0 ]
}

