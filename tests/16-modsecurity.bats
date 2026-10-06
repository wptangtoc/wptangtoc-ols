#!/usr/bin/env bats
#
# Kiểm thử tích hợp Tối Thượng cho wptt-modsecurity trên WPTangToc OLS
# Kịch bản: Tự động cài đặt 100% WordPress thật -> Tấn công -> Bật/Tắt WAF -> Dọn dẹp
#

TEST_DOMAIN="wptest-waf.com"
CORE_BAK="/tmp/core-functions.bak"
BASELINE_FILE="/tmp/wptt-waf-baseline-ms"
LOCK_FILE="/var/lock/wptt-modsecurity.lock"
CONFIG_FILE="/usr/local/lsws/conf/httpd_config.conf"
OWASP_DIR="/usr/local/lsws/modsec/owasp"

# Tuyệt chiêu Curl CI/CD: Dùng mảng và --resolve để mô phỏng DNS hoàn hảo (Bỏ qua SSL)
CURL_BASE_OPTS=(
  -s -o /dev/null -w "%{http_code}" -k
  --connect-timeout 3 --max-time 10
  -A "WPTangToc OLS preload cache"
  --resolve "${TEST_DOMAIN}:443:127.0.0.1"
  --resolve "${TEST_DOMAIN}:80:127.0.0.1"
)

# =================================================================
# HÀM TIỆN ÍCH BẮN PAYLOAD
# =================================================================

in_log_neu_loi() {
  local ma_ky_vong="$1"
  if [ "$status" -ne "$ma_ky_vong" ]; then
    echo -e "\n[Modsecurity Test][LỖI] Kịch bản không trả về mã $ma_ky_vong như kỳ vọng!" >&3
    echo "Mã trạng thái thực tế : $status" >&3
    echo -e "Nội dung in ra:\n$output" >&3
  fi
}

# Gửi GET có params
code_get() {
  local name="$1" value="$2"; shift 2
  curl "${CURL_BASE_OPTS[@]}" -G --data-urlencode "${name}=${value}" "$@" "https://${TEST_DOMAIN}/"
}

# Gửi GET path
code_path() {
  local path="$1"; shift
  curl "${CURL_BASE_OPTS[@]}" "$@" "https://${TEST_DOMAIN}${path}"
}

# Gửi POST form
code_post() {
  local path="$1"; shift
  curl "${CURL_BASE_OPTS[@]}" -X POST "$@" "https://${TEST_DOMAIN}${path}"
}

# Đo độ trễ
avg_ms() {
  local n="${1:-10}" i out code t total=0
  for ((i = 0; i < n; i++)); do
    # Hàm avg_ms dùng lệnh curl gốc thay vì truyền mảng để tránh lỗi escape chuỗi %{http_code}
    out=$(curl -s -o /dev/null -w "%{http_code} %{time_total}" -k --connect-timeout 3 --max-time 10 -A "WPTangToc OLS preload cache" --resolve "${TEST_DOMAIN}:443:127.0.0.1" "https://${TEST_DOMAIN}/")
    code="${out%% *}"
    t="${out##* }"
    if [[ "$code" == "000" ]]; then echo "-1"; return 0; fi
    total=$(awk -v a="$total" -v b="$t" 'BEGIN{print a+b}')
  done
  awk -v t="$total" -v n="$n" 'BEGIN{printf "%d", (t/n)*1000}'
}

# Khẳng định request bị chặn (403)
assert_blocked() {
  local code="$1" ten="$2"
  if [ "$code" != "403" ]; then
    echo "[Modsecurity Test][LỖI] '$ten' KHÔNG bị chặn. HTTP code thực tế: $code (kỳ vọng 403)" >&3
    return 1
  fi
}

# Khẳng định request lọt qua (2xx hoặc 3xx)
assert_passed() {
  local code="$1" ten="$2"
  if ! [[ "$code" =~ ^[23][0-9][0-9]$ ]]; then
    echo "[Modsecurity Test][LỖI] '$ten' không lọt qua. HTTP code: $code (kỳ vọng 2xx/3xx)" >&3
    return 1
  fi
}

# =================================================================
# SETUP / TEARDOWN (CÀI ĐẶT WORDPRESS THẬT)
# =================================================================

setup_file() {
  export CI="true"
  export SCRIPT_MODSEC="/etc/wptt/bao-mat/wptt-modsecurity"

  # 1. Sao lưu core-functions
  cp /etc/wptt/core-functions "$CORE_BAK" 2>/dev/null || true

  # Đưa WAF về OFF trước khi test
  bash "$SCRIPT_MODSEC" off >/dev/null 2>&1 || true

  # 2. Xóa sạch rác nếu có domain này từ trước
  echo -e "y\ny" | bash /etc/wptt/domain/wptt-xoawebsite "$TEST_DOMAIN" >/dev/null 2>&1 || true

  # 3. Thêm website mới tinh
  bash /etc/wptt/domain/wptt-themwebsite "$TEST_DOMAIN" >/dev/null 2>&1 || true

  # 4. CÀI ĐẶT WORDPRESS TỰ ĐỘNG BẰNG PIPELINE
  local script_test="/tmp/wptt-install-wp-waf.sh"
  cp /etc/wptt/wptt-install-wordpress2 "$script_test"
  sed -i 's/exec \/etc\/wptt\/wptt-wordpress-main.*/exit 0/g' "$script_test"
  sed -i 's/exec \/usr\/bin\/wptangtoc.*/exit 0/g' "$script_test"
  
  # Tiêm Mock xác nhận (Luôn Yes)
  cat << EOF > /etc/wptt/core-functions
source $CORE_BAK
wptt_xac_nhan() { return 0; }
EOF

  # Bơm data: Site Title -> Username -> Password -> Email
  local inputs="WAF WP Test\nwafadmin\nMatKhauSieuKho123!\nadmin@${TEST_DOMAIN}\n"
  echo -e "$inputs" | bash "$script_test" "$TEST_DOMAIN" >/dev/null 2>&1 || true

  rm -f "$script_test"
  cp "$CORE_BAK" /etc/wptt/core-functions 2>/dev/null || true

  # 5. Restart OLS để ăn cấu hình mới
  systemctl restart lshttpd
  sleep 3

  echo "[Modsecurity Test] Đã Setup WordPress thật trên domain $TEST_DOMAIN (HTTPS Port 443 + Resolve)" >&3
}

teardown_file() {
  # Xóa sạch WordPress và Vhost sau khi test xong
  echo -e "y\ny" | bash /etc/wptt/domain/wptt-xoawebsite "$TEST_DOMAIN" >/dev/null 2>&1 || true
  
  cp "$CORE_BAK" /etc/wptt/core-functions 2>/dev/null || true
  bash "$SCRIPT_MODSEC" off >/dev/null 2>&1 || true
  rm -f "$BASELINE_FILE" "$CORE_BAK"
}

teardown() {
  if [[ -f "$CORE_BAK" ]]; then cp "$CORE_BAK" /etc/wptt/core-functions 2>/dev/null || true; fi
}

# =================================================================
# NHÓM 1: BỘ LỌC ĐỐI SỐ
# =================================================================

@test "Nhóm 1: Đối số không hợp lệ trả về mã 2" {
  run bash "$SCRIPT_MODSEC" "bat-tum-lum"
  in_log_neu_loi 2
  [ "$status" -eq 2 ]
}

# =================================================================
# NHÓM 2: BASELINE KHI WAF TẮT
# =================================================================

@test "Nhóm 2: Website WordPress phục vụ bình thường (HTTP 200/301) khi WAF TẮT" {
  local code="$(code_path "/")"
  [[ "$code" =~ ^[23][0-9][0-9]$ ]]
}

@test "Nhóm 2: Khi WAF TẮT, mã độc SQLi/XSS lọt thẳng vào WordPress (HTTP 2xx/3xx)" {
  assert_passed "$(code_get id "1' OR '1'='1' -- -")" "SQLi (WAF tắt)"
  assert_passed "$(code_get s "<script>alert(1)</script>")" "XSS Tìm kiếm (WAF tắt)"
}

@test "Nhóm 2: Đo độ trễ gốc của WordPress khi WAF TẮT" {
  local ms="$(avg_ms 10)"
  echo "$ms" > "$BASELINE_FILE"
  [ "$ms" -ge 0 ]
}

# =================================================================
# NHÓM 3: BẬT WAF VÀ KIỂM TRA CẤU HÌNH
# =================================================================

@test "Nhóm 3: Bật ModSecurity thành công (mã 0)" {
  run bash "$SCRIPT_MODSEC" on
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  sleep 2
}

@test "Nhóm 3: Kiểm tra tính toàn vẹn của File Luật (Chỉ giữ luật PHP)" {
  grep -q 'SecRequestBodyAccess On' "$CONFIG_FILE"
  
  # Không được sót luật Java/Node/IIS
  run bash -c "ls '$OWASP_DIR/crs30/rules/' | grep -E 'JAVA|NODEJS|IIS|WINDOWS|RUBY|PYTHON'"
  [ "$status" -ne 0 ]

  # Luật PHP phải còn
  run bash -c "ls '$OWASP_DIR/crs30/rules/' | grep -E 'PHP.*\.conf$'"
  [ "$status" -eq 0 ]
}

# =================================================================
# NHÓM 4: BẮN PAYLOAD VÀO WORDPRESS (PHẢI BỊ CHẶN 403)
# =================================================================

@test "Nhóm 4: Chặn SQL Injection boolean vào trang chủ" {
  assert_blocked "$(code_get id "1' OR '1'='1' -- -")" "SQLi boolean"
}

@test "Nhóm 4: Chặn XSS thẻ script vào form tìm kiếm của WordPress" {
  assert_blocked "$(code_get s "<script>alert(document.cookie)</script>")" "XSS Search WP"
}

@test "Nhóm 4: Chặn Local File Inclusion (LFI) chọc ngoáy /etc/passwd" {
  assert_blocked "$(code_get file "../../../../etc/passwd")" "LFI traversal"
}

@test "Nhóm 4: Chặn Brute-Force SQLi qua POST thẳng vào wp-login.php" {
  assert_blocked "$(code_post "/wp-login.php" \
    --data-urlencode "log=admin' OR 1=1-- -" --data-urlencode "pwd=x")" "SQLi POST wp-login.php"
}

@test "Nhóm 4: Chặn XSS tiêm vào bình luận (POST wp-comments-post.php)" {
  assert_blocked "$(code_post "/wp-comments-post.php" \
    --data-urlencode "comment=<script>alert('Hacked')</script>" \
    --data-urlencode "author=Hacker" --data-urlencode "email=hacker@evil.com")" "XSS wp-comments-post"
}

@test "Nhóm 4: Chặn User-Agent của công cụ quét lỗ hổng (sqlmap)" {
  assert_blocked "$(code_path "/" -A "sqlmap/1.7.2#stable")" "Scanner sqlmap"
}

# =================================================================
# NHÓM 5: CHỐNG CHẶN NHẦM VÀ ĐO HIỆU NĂNG
# =================================================================

@test "Nhóm 5: Khách truy cập đọc bài viết bình thường không bị chặn" {
  assert_passed "$(code_path "/")" "Trang chủ"
  assert_passed "$(code_path "/wp-login.php")" "Trang Login"
}

@test "Nhóm 5: Đăng nhập Admin hợp lệ (POST) không bị chặn nhầm" {
  assert_passed "$(code_post "/wp-login.php" \
    --data-urlencode "log=wafadmin" --data-urlencode "pwd=MatKhauSieuKho123!")" "POST đăng nhập hợp lệ"
}

@test "Nhóm 5: Độ trễ xử lý PHP của WAF nằm trong ngưỡng an toàn (Dưới 800ms)" {
  local base="$(cat "$BASELINE_FILE" 2>/dev/null || echo 0)"
  local on="$(avg_ms 10)"
  local overhead=$((on - base))
  local max="${WAF_MAX_OVERHEAD_MS:-800}"
  echo "[Modsecurity Test][INFO] Độ trễ WP: TẮT=${base}ms | BẬT=${on}ms | Chênh lệch=${overhead}ms" >&3
  [ "$overhead" -le "$max" ]
}

# =================================================================
# NHÓM 6: TẮT WAF VÀ KIỂM CHỨNG
# =================================================================

@test "Nhóm 6: Tắt ModSecurity thành công" {
  run bash "$SCRIPT_MODSEC" off
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  ! grep -Eq '^[[:space:]]*module[[:space:]]+mod_security' "$CONFIG_FILE"
}

@test "Nhóm 6: Payload tấn công lọt qua bình thường sau khi WAF tắt" {
  assert_passed "$(code_get id "1' OR '1'='1' -- -")" "SQLi sau khi tắt"
}
