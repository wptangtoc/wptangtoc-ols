#!/usr/bin/env bats
#
# Kiểm thử tích hợp cho wptt-modecurity (bật/tắt ModSecurity + OWASP CRS trên OpenLiteSpeed)
#
# Quy trình:
#   setup_file : tạo website + cài WordPress tự động (1 lần cho cả file)
#   Nhóm 1     : kiểm tra đối số đầu vào
#   Nhóm 2     : baseline khi WAF TẮT (tấn công phải LỌT QUA, đo độ trễ gốc)
#   Nhóm 3     : bật WAF, kiểm tra cấu hình, idempotent, bộ luật đã tinh gọn
#   Nhóm 4     : tấn công thật (SQLi, XSS, LFI, RCE, PHP injection, scanner...) => phải bị 403
#   Nhóm 5     : chống chặn nhầm (false positive) + đo độ trễ khi bật WAF
#   Nhóm 6     : rollback khi reload OpenLiteSpeed thất bại (mock)
#   Nhóm 7     : khóa chạy đồng thời (flock)
#   Nhóm 8     : tắt WAF, tấn công lại phải LỌT QUA
#   teardown_file : trả WAF về trạng thái ban đầu
#
# Chạy:  bats wptt-modecurity.bats        (cần quyền root, curl, wp-cli, flock)
# Biến môi trường tùy chọn:
#   SCRIPT_MODSEC        đường dẫn script cần test
#   WAF_TEST_BASE        mặc định http://127.0.0.1 (đổi nếu OLS không nghe cổng 80)
#   WAF_MAX_OVERHEAD_MS  ngưỡng chậm thêm tối đa khi bật WAF (mặc định 800ms)
#   WAF_TEST_CLEANUP=1   xóa website test sau khi xong (cần script xóa website tồn tại)

TEST_DOMAIN="wptest-waf.com"
CORE_BAK="/tmp/core-functions.bak"
BASELINE_FILE="/tmp/wptt-waf-baseline-ms"
LOCK_FILE="/var/lock/wptt-modsecurity.lock"
CONFIG_FILE="/usr/local/lsws/conf/httpd_config.conf"
OWASP_DIR="/usr/local/lsws/modsec/owasp"

# =================================================================
# HÀM TIỆN ÍCH
# =================================================================

in_log_neu_loi() {
  local ma_ky_vong="$1"
  if [ "$status" -ne "$ma_ky_vong" ]; then
    echo -e "\n[LỖI TEST] Kịch bản không trả về mã $ma_ky_vong như kỳ vọng!" >&3
    echo "Mã trạng thái thực tế : $status" >&3
    echo -e "Nội dung in ra màn hình:\n$output" >&3
  fi
}

tim_script() {
  local c
  for c in "${SCRIPT_MODSEC:-}" /etc/wptt/bao-mat/wptt-modsecurity; do
    [[ -n "$c" && -f "$c" ]] && { echo "$c"; return 0; }
  done
  return 1
}

# Gửi GET với 1 tham số (curl tự URL-encode), trả về HTTP code. Tham số thừa truyền thẳng cho curl.
code_get() {
  local name="$1" value="$2"; shift 2
  curl -s -o /dev/null -w '%{http_code}' --connect-timeout 3 --max-time 10 -k -G \
    -H "Host: ${TEST_DOMAIN}" --data-urlencode "${name}=${value}" "$@" \
    "${WAF_TEST_BASE:-http://127.0.0.1}${WAF_TARGET_PATH:-/}"
}

# Gửi GET thường tới một đường dẫn
code_path() {
  local path="$1"; shift
  curl -s -o /dev/null -w '%{http_code}' --connect-timeout 3 --max-time 10 -k \
    -H "Host: ${TEST_DOMAIN}" "$@" "${WAF_TEST_BASE:-http://127.0.0.1}${path}"
}

# Gửi POST form, trả về HTTP code
code_post() {
  local path="$1"; shift
  curl -s -o /dev/null -w '%{http_code}' --connect-timeout 3 --max-time 10 -k -X POST \
    -H "Host: ${TEST_DOMAIN}" "$@" "${WAF_TEST_BASE:-http://127.0.0.1}${path}"
}

# Trung bình thời gian phản hồi (ms) của N request hợp lệ.
# Trả về -1 ngay khi gặp lỗi kết nối (không để test bị treo).
avg_ms() {
  local n="${1:-10}" i out code t total=0
  for ((i = 0; i < n; i++)); do
    out=$(curl -s -o /dev/null -w '%{http_code} %{time_total}' --connect-timeout 3 --max-time 10 -k \
      -H "Host: ${TEST_DOMAIN}" "${WAF_TEST_BASE:-http://127.0.0.1}${WAF_TARGET_PATH:-/}")
    code="${out%% *}"
    t="${out##* }"
    if [[ "$code" == "000" ]]; then echo "-1"; return 0; fi
    total=$(awk -v a="$total" -v b="$t" 'BEGIN{print a+b}')
  done
  awk -v t="$total" -v n="$n" 'BEGIN{printf "%d", (t/n)*1000}'
}

# Dò địa chỉ mà OpenLiteSpeed thật sự trả lời (thử nhiều ứng viên, có retry)
chon_base_url() {
  local attempt c code ip
  local -a cands=()
  [[ -n "${WAF_TEST_BASE:-}" ]] && cands+=("$WAF_TEST_BASE")
  cands+=("http://127.0.0.1" "http://localhost" "http://[::1]")
  for ip in $(hostname -I 2>/dev/null); do cands+=("http://$ip"); done
  cands+=("https://127.0.0.1" "http://127.0.0.1:8088")

  for attempt in 1 2 3; do
    for c in "${cands[@]}"; do
      # Thăm dò bằng FILE TĨNH (không cần PHP/DB) và cho thời gian chờ dài hơn cho lần gọi đầu
      code=$(curl -s -k -o /dev/null -w '%{http_code}' --connect-timeout 3 --max-time 15 \
        -H "Host: ${TEST_DOMAIN}" "$c/waf-probe.html" 2>/dev/null)
      if [[ -n "$code" && "$code" != "000" ]]; then
        echo "$c"
        return 0
      fi
    done
    sleep 2
  done
  return 1
}

chan_doan_ket_noi() {
  local rc
  echo "[CHẨN ĐOÁN] Không nhận được phản hồi HTTP từ OpenLiteSpeed qua bất kỳ địa chỉ nào." >&3

  echo "--- Cổng đang lắng nghe (rút gọn):" >&3
  { ss -ltn 2>/dev/null | grep -E ':(80|443|8088)\b' | sort -u; } >&3 || echo "(không có cổng nào)" >&3

  echo "--- Biến proxy trong môi trường (nếu có sẽ làm curl đi vòng qua proxy):" >&3
  { env | grep -i proxy; } >&3 || echo "(không có)" >&3

  echo "--- Vhost của ${TEST_DOMAIN}:" >&3
  { ls -d "/usr/local/lsws/conf/vhosts/${TEST_DOMAIN}" 2>&1; } >&3 || true
  { grep -c "${TEST_DOMAIN}" "$CONFIG_FILE" 2>&1 | sed 's/^/số lần xuất hiện trong httpd_config.conf: /'; } >&3 || true

  echo "--- curl http://127.0.0.1/ CÓ header Host:" >&3
  curl -sS -v -o /dev/null --noproxy '*' --connect-timeout 3 --max-time 8 \
    -H "Host: ${TEST_DOMAIN}" http://127.0.0.1/ 2>&1 | tail -n 12 >&3
  rc="${PIPESTATUS[0]}"
  echo "(curl exit code: $rc)" >&3

  echo "--- curl http://127.0.0.1/ KHÔNG có header Host:" >&3
  curl -sS -v -o /dev/null --noproxy '*' --connect-timeout 3 --max-time 8 \
    http://127.0.0.1/ 2>&1 | tail -n 12 >&3
  rc="${PIPESTATUS[0]}"
  echo "(curl exit code: $rc)" >&3

  echo "--- curl https://${TEST_DOMAIN}/ (ép phân giải về 127.0.0.1):" >&3
  curl -sS -v -k -o /dev/null --noproxy '*' --connect-timeout 3 --max-time 8 \
    --resolve "${TEST_DOMAIN}:443:127.0.0.1" "https://${TEST_DOMAIN}/" 2>&1 | tail -n 12 >&3
  rc="${PIPESTATUS[0]}"
  echo "(curl exit code: $rc)" >&3

  echo "--- curl file tĩnh /waf-probe.html (không cần PHP/DB):" >&3
  curl -sS -v -o /dev/null --noproxy '*' --connect-timeout 3 --max-time 15 \
    -H "Host: ${TEST_DOMAIN}" http://127.0.0.1/waf-probe.html 2>&1 | tail -n 8 >&3
  rc="${PIPESTATUS[0]}"
  echo "(curl exit code: $rc)" >&3

  echo "--- Tiến trình lsphp và dịch vụ DB:" >&3
  { pgrep -a lsphp | head -n 5; } >&3 || echo "(không có tiến trình lsphp nào)" >&3
  { systemctl is-active mariadb mysql mysqld 2>&1; } >&3 || true

  echo "--- File probe và quyền thư mục site:" >&3
  { ls -la "/usr/local/lsws/${TEST_DOMAIN}/html/waf-probe.html" "/usr/local/lsws/${TEST_DOMAIN}/" 2>&1 | head -n 12; } >&3 || true

  echo "--- 10 dòng cuối log của vhost:" >&3
  { tail -n 10 "/usr/local/lsws/${TEST_DOMAIN}/logs/error.log" 2>&1; } >&3 || true

  echo "--- Trạng thái lsws:" >&3
  { /usr/local/lsws/bin/lswsctrl status 2>&1; } >&3 || true
  echo "--- 15 dòng cuối error.log:" >&3
  { tail -n 15 /usr/local/lsws/logs/error.log 2>/dev/null; } >&3 || true
}

# Khẳng định request bị chặn
assert_blocked() {
  local code="$1" ten="$2"
  if [ "$code" != "403" ]; then
    echo "[LỖI TEST] '$ten' KHÔNG bị chặn. HTTP code thực tế: $code (kỳ vọng 403)" >&3
    return 1
  fi
}

# Khẳng định request lọt qua (không bị WAF chặn, server vẫn trả lời)
assert_passed() {
  local code="$1" ten="$2"
  if [ "$code" = "403" ] || [ "$code" = "000" ]; then
    echo "[LỖI TEST] '$ten' bị chặn hoặc không có phản hồi. HTTP code: $code" >&3
    return 1
  fi
}

mock_reload_fail() {
  cat << EOF > /etc/wptt/core-functions
source $CORE_BAK
wptt_smart_reload_lsws() { return 1; }
EOF
}

modsec_block_present() {
  grep -Eq '^[[:space:]]*module[[:space:]]+mod_security' "$CONFIG_FILE"
}

# =================================================================
# SETUP / TEARDOWN
# =================================================================

setup_file() {
  [ "$(id -u)" -eq 0 ] || { echo "Cần chạy bằng root" >&3; return 1; }

  export CI="true"
  export TEST_DOMAIN
  # Không đi qua proxy khi gọi localhost (proxy trong môi trường là nguyên nhân phổ biến gây mã 000)
  export no_proxy="*" NO_PROXY="*"
  export SCRIPT_MODSEC
  SCRIPT_MODSEC="$(tim_script)" || { echo "Không tìm thấy script wptt-modecurity" >&3; return 1; }

  # Sao lưu core-functions để tiêm mock khi cần
  cp /etc/wptt/core-functions "$CORE_BAK" 2>/dev/null || true

  # Ghi nhớ trạng thái ban đầu để trả lại khi kết thúc
  if bash "$SCRIPT_MODSEC" status >/dev/null 2>&1; then
    echo "on" > /tmp/wptt-waf-original-state
  else
    echo "off" > /tmp/wptt-waf-original-state
  fi

  # Luôn bắt đầu từ trạng thái TẮT cho kết quả xác định
  bash "$SCRIPT_MODSEC" off >/dev/null 2>&1 || true

  # 1. Thêm website (hệ thống tự sinh DB)
  bash /etc/wptt/domain/wptt-themwebsite "$TEST_DOMAIN" >/dev/null 2>&1 || true

  # 2. Cài WordPress tự động (mô phỏng cách file install-wordpress.bats)
  local script_goc="/etc/wptt/wptt-install-wordpress2"
  local script_test="/tmp/wptt-install-wp-waf-test.sh"
  if [[ -f "$script_goc" ]]; then
    cp "$script_goc" "$script_test"
    sed -i 's/exec \/etc\/wptt\/wptt-wordpress-main.*/exit 0/g' "$script_test"
    sed -i 's/exec \/usr\/bin\/wptangtoc.*/exit 0/g' "$script_test"
    echo "exit 0" >> "$script_test"
    chmod +x "$script_test"

    cat << EOF > /etc/wptt/core-functions
source $CORE_BAK
wptt_xac_nhan() { return 0; }
EOF
    local inputs="Website WAF Test\nadmin_$(date +%s)\nPassKh0_$(date +%N)\nadmin@${TEST_DOMAIN}\n"
    echo -e "$inputs" | bash "$script_test" "$TEST_DOMAIN" >/dev/null 2>&1 || true
    cp "$CORE_BAK" /etc/wptt/core-functions 2>/dev/null || true
    rm -f "$script_test"
  fi

  # 3. Đảm bảo luôn có ít nhất một ứng dụng PHP để tấn công thử (kể cả khi cài WP lỗi)
  local docroot="/usr/local/lsws/${TEST_DOMAIN}/html"
  mkdir -p "$docroot"
  [[ -f "$docroot/index.php" || -f "$docroot/index.html" ]] || echo '<?php echo "ok";' > "$docroot/index.php"
  echo '<?php echo "probe-ok";' > "$docroot/waf-probe.php"
  # File TĨNH làm mục tiêu tấn công: không phụ thuộc PHP/DB nên chạy ổn định trên CI.
  # ModSecurity vẫn kiểm tra đầy đủ URL/header/body của request tới file tĩnh.
  echo "probe-ok" > "$docroot/waf-probe.html"
  chown --reference="$docroot" "$docroot/waf-probe.html" "$docroot/waf-probe.php" 2>/dev/null || true
  chmod 644 "$docroot/waf-probe.html" "$docroot/waf-probe.php" 2>/dev/null || true
  export WAF_TARGET_PATH="/waf-probe.html"

  # 4. Dò địa chỉ truy cập được; không có thì dừng ngay kèm chẩn đoán (không để test treo)
  if ! WAF_TEST_BASE="$(chon_base_url)"; then
    chan_doan_ket_noi
    return 1
  fi
  export WAF_TEST_BASE
  echo "[INFO] URL kiểm thử: $WAF_TEST_BASE (Host: $TEST_DOMAIN, mục tiêu: $WAF_TARGET_PATH)" >&3

  # 5. WordPress (PHP + DB) có thật sự phản hồi không? Nếu không thì các test WordPress sẽ được bỏ qua.
  local wp_code
  wp_code="$(curl -s -k -o /dev/null -w '%{http_code}' --connect-timeout 3 --max-time 15 \
    -H "Host: ${TEST_DOMAIN}" "${WAF_TEST_BASE}/" 2>/dev/null)" || true
  if [[ "$wp_code" =~ ^(200|301|302)$ ]]; then
    export WP_HTTP_OK=1
  else
    export WP_HTTP_OK=0
  fi
}

teardown_file() {
  # Trả WAF về trạng thái ban đầu
  local original="off"
  [[ -f /tmp/wptt-waf-original-state ]] && original="$(cat /tmp/wptt-waf-original-state)"
  cp "$CORE_BAK" /etc/wptt/core-functions 2>/dev/null || true
  bash "$SCRIPT_MODSEC" "$original" >/dev/null 2>&1 || true

  rm -f /tmp/wptt-waf-original-state "$BASELINE_FILE" "$CORE_BAK"

  # Tùy chọn: xóa website test (chỉnh đường dẫn script xóa cho đúng hệ thống của bạn)
  local script_xoa="${SCRIPT_XOA:-/etc/wptt/domain/wptt-xoawebsite}"
  if [[ "${WAF_TEST_CLEANUP:-0}" == "1" && -x "$script_xoa" ]]; then
    bash "$script_xoa" "$TEST_DOMAIN" >/dev/null 2>&1 || true
  fi
}

teardown() {
  # Sau mỗi test, luôn gỡ mock để không ảnh hưởng test kế tiếp
  [[ -f "$CORE_BAK" ]] && cp "$CORE_BAK" /etc/wptt/core-functions 2>/dev/null || true
}

# =================================================================
# NHÓM 1: BỘ LỌC ĐỐI SỐ ĐẦU VÀO
# =================================================================

@test "Nhóm 1: Đối số không hợp lệ trả về mã 2" {
  run bash "$SCRIPT_MODSEC" "bat-tum-lum"
  in_log_neu_loi 2
  [ "$status" -eq 2 ]
  [[ "$output" =~ "Đối số không hợp lệ" ]]
}

@test "Nhóm 1: Gọi không đối số khi không có TTY không bị treo, trả về mã 2" {
  run timeout 15 bash "$SCRIPT_MODSEC" < /dev/null
  in_log_neu_loi 2
  [ "$status" -eq 2 ]
}

@test "Nhóm 1: --help in hướng dẫn và trả về mã 0" {
  run bash "$SCRIPT_MODSEC" --help
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "ModSecurity" ]]
}

# =================================================================
# NHÓM 2: BASELINE KHI WAF TẮT
# =================================================================

@test "Nhóm 2: off đưa hệ thống về trạng thái TẮT (status trả mã 10)" {
  run bash "$SCRIPT_MODSEC" off
  in_log_neu_loi 0
  [ "$status" -eq 0 ]

  run bash "$SCRIPT_MODSEC" status
  [ "$status" -eq 10 ]
  [[ "$output" =~ "OFF" ]]
  ! modsec_block_present
}

@test "Nhóm 2: Khi WAF TẮT, tấn công SQLi/XSS/LFI KHÔNG bị chặn (đối chứng)" {
  assert_passed "$(code_get id "1' OR '1'='1' -- -")" "SQLi (WAF tắt)"
  assert_passed "$(code_get q "<script>alert(1)</script>")" "XSS (WAF tắt)"
  assert_passed "$(code_get file "../../../../etc/passwd")" "LFI (WAF tắt)"
}

@test "Nhóm 2: Đo độ trễ gốc khi WAF TẮT" {
  local ms
  ms="$(avg_ms 10)"
  echo "$ms" > "$BASELINE_FILE"
  [ "$ms" -ge 0 ]
}

# =================================================================
# NHÓM 3: BẬT WAF
# =================================================================

@test "Nhóm 3: on bật ModSecurity thành công (mã 0)" {
  run bash "$SCRIPT_MODSEC" on
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "ON" ]]
}

@test "Nhóm 3: Cấu hình OLS có khối module mod_security và trỏ đúng file luật" {
  modsec_block_present
  grep -q 'modsecurity_rules_file[[:space:]]*/usr/local/lsws/modsec/owasp/crs30/owasp-master.conf' "$CONFIG_FILE"
  grep -q 'SecRuleEngine On' "$CONFIG_FILE"
  # Bắt buộc kiểm tra BODY của request POST, nếu không SQLi/XSS trong form sẽ lọt qua
  grep -q 'SecRequestBodyAccess On' "$CONFIG_FILE"
  # Chỉ có đúng 1 khối module (không bị nhân đôi sau nhiều lần bật)
  [ "$(grep -Ec '^[[:space:]]*module[[:space:]]+mod_security' "$CONFIG_FILE")" -eq 1 ]
}

@test "Nhóm 3: File luật master có include và mọi file được include đều tồn tại" {
  local master="$OWASP_DIR/crs30/owasp-master.conf"
  [ -s "$master" ]
  [ "$(grep -c '^include ' "$master")" -gt 5 ]

  local missing=0 f
  while read -r _ f; do
    [[ -f "$f" ]] || { echo "Thiếu file luật: $f" >&3; missing=1; }
  done < <(grep '^include ' "$master")
  [ "$missing" -eq 0 ]
}

@test "Nhóm 3: Luật không thuộc hệ sinh thái PHP/Linux đã được lọc bỏ" {
  # Chỉ xét file LUẬT (*.conf). Thư mục rules còn chứa file dữ liệu *.data (java-classes.data,
  # iis-errors.data...) không phải luật, chỉ được nạp khi có luật tham chiếu tới nên bỏ qua.
  local conf_con_sot
  conf_con_sot="$(ls "$OWASP_DIR/crs30/rules/" | grep -E '\.conf$' | grep -E 'JAVA|NODEJS|IIS|WINDOWS|RUBY|PYTHON' || true)"
  if [ -n "$conf_con_sot" ]; then
    echo "[LỖI TEST] File luật còn sót lại sau khi lọc:" >&3
    echo "$conf_con_sot" >&3
  fi
  [ -z "$conf_con_sot" ]

  # File master cũng không được include các luật đó
  run grep -E 'JAVA|NODEJS|IIS|WINDOWS|RUBY|PYTHON' "$OWASP_DIR/crs30/owasp-master.conf"
  [ "$status" -ne 0 ]

  # Luật PHP phải còn
  run bash -c "ls '$OWASP_DIR/crs30/rules/' | grep -E 'PHP.*\.conf$'"
  [ "$status" -eq 0 ]
}

@test "Nhóm 3: Thư mục tạm staging/old đã được dọn sạch" {
  [ ! -d "${OWASP_DIR}.new" ]
  [ ! -d "${OWASP_DIR}.old" ]
}

@test "Nhóm 3: status trả mã 0 khi đang bật" {
  run bash "$SCRIPT_MODSEC" status
  [ "$status" -eq 0 ]
  [[ "$output" =~ "ON" ]]
}

@test "Nhóm 3: on lần nữa là idempotent (không tải lại, mã 0)" {
  run bash "$SCRIPT_MODSEC" on
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "đã được BẬT từ trước" ]]
}

@test "Nhóm 3: Tự phục hồi khi cấu hình bật nhưng thiếu bộ luật" {
  mv "$OWASP_DIR" "${OWASP_DIR}.sabotage"
  run bash "$SCRIPT_MODSEC" on
  in_log_neu_loi 0
  rm -rf "${OWASP_DIR}.sabotage"
  [ "$status" -eq 0 ]
  [ -s "$OWASP_DIR/crs30/owasp-master.conf" ]
}

# =================================================================
# NHÓM 4: TẤN CÔNG THẬT => PHẢI BỊ CHẶN (403)
# =================================================================

@test "Nhóm 4: Chặn SQL Injection kiểu boolean (OR 1=1)" {
  assert_blocked "$(code_get id "1' OR '1'='1' -- -")" "SQLi boolean"
}

@test "Nhóm 4: Chặn SQL Injection kiểu UNION SELECT" {
  assert_blocked "$(code_get id "1 UNION SELECT user_login,user_pass FROM wp_users--")" "SQLi UNION"
}

@test "Nhóm 4: Chặn SQL Injection kiểu time-based (SLEEP)" {
  assert_blocked "$(code_get id "1' AND SLEEP(5)-- -")" "SQLi time-based"
}

@test "Nhóm 4: Chặn XSS thẻ script" {
  assert_blocked "$(code_get s "<script>alert(document.cookie)</script>")" "XSS script"
}

@test "Nhóm 4: Chặn XSS qua thuộc tính sự kiện (onerror)" {
  assert_blocked "$(code_get s "<img src=x onerror=alert(1)>")" "XSS onerror"
}

@test "Nhóm 4: Chặn Local File Inclusion (đọc /etc/passwd)" {
  assert_blocked "$(code_get file "../../../../etc/passwd")" "LFI traversal"
}

@test "Nhóm 4: Chặn Remote File Inclusion" {
  assert_blocked "$(code_get page "http://evil.example.com/shell.txt?")" "RFI"
}

@test "Nhóm 4: Chặn Command Injection (OS command)" {
  assert_blocked "$(code_get cmd ";cat /etc/passwd")" "Command injection"
}

@test "Nhóm 4: Chặn PHP code injection" {
  assert_blocked "$(code_get x "<?php system('id'); ?>")" "PHP injection"
}

@test "Nhóm 4: Chặn công cụ quét lỗ hổng (User-Agent sqlmap)" {
  assert_blocked "$(code_path "${WAF_TARGET_PATH:-/}" -A "sqlmap/1.7.2#stable (https://sqlmap.org)")" "Scanner sqlmap"
}

@test "Nhóm 4: Chặn công cụ quét lỗ hổng (User-Agent nikto)" {
  assert_blocked "$(code_path "${WAF_TARGET_PATH:-/}" -A "Mozilla/5.00 (Nikto/2.5.0) (Evasions:None) (Test:001)")" "Scanner nikto"
}

@test "Nhóm 4: Chặn SQL Injection nằm trong BODY của request POST (file tĩnh)" {
  local code
  code="$(code_post "${WAF_TARGET_PATH:-/}" \
    --data-urlencode "log=admin' OR 1=1-- -" --data-urlencode "pwd=x")"
  if [ "$code" != "403" ]; then
    echo "[GỢI Ý] POST body không bị kiểm tra. Hãy xem httpd_config.conf đã có 'SecRequestBodyAccess On' chưa." >&3
  fi
  assert_blocked "$code" "SQLi trong POST body"
}

@test "Nhóm 4: Chặn XSS nằm trong BODY của request POST (file tĩnh)" {
  local code
  code="$(code_post "${WAF_TARGET_PATH:-/}" \
    --data-urlencode "comment=<script>alert(document.cookie)</script>")"
  if [ "$code" != "403" ]; then
    echo "[GỢI Ý] POST body không bị kiểm tra. Hãy xem httpd_config.conf đã có 'SecRequestBodyAccess On' chưa." >&3
  fi
  assert_blocked "$code" "XSS trong POST body"
}

@test "Nhóm 4: Chặn SQLi qua POST vào wp-login.php (brute-force/injection)" {
  assert_blocked "$(code_post "/wp-login.php" \
    --data-urlencode "log=admin' OR 1=1-- -" --data-urlencode "pwd=x")" "SQLi POST wp-login"
}

@test "Nhóm 4: Chặn tấn công đặt trong header (Referer chứa XSS)" {
  assert_blocked "$(code_path "${WAF_TARGET_PATH:-/}" -H "Referer: <script>alert(1)</script>")" "XSS Referer"
}

@test "Nhóm 4: Chặn tấn công mã hóa URL kép (double-encoding LFI)" {
  assert_blocked "$(code_path "${WAF_TARGET_PATH:-/}?file=%252e%252e%252f%252e%252e%252fetc%252fpasswd")" "Double-encoded LFI"
}

# =================================================================
# NHÓM 5: CHỐNG CHẶN NHẦM + HIỆU NĂNG
# =================================================================

@test "Nhóm 5: Truy cập file tĩnh bình thường vẫn được phép (HTTP 200)" {
  local code
  code="$(code_path "${WAF_TARGET_PATH:-/}")"
  [ "$code" = "200" ]
}

@test "Nhóm 5: Trang chủ WordPress truy cập bình thường vẫn được phép" {
  [ "${WP_HTTP_OK:-0}" = "1" ] || skip "WordPress không phản hồi trong môi trường này"
  local code
  code="$(code_path "/")"
  [[ "$code" =~ ^(200|301|302)$ ]]
}

@test "Nhóm 5: Trang đăng nhập WordPress (GET) vẫn truy cập được" {
  [ "${WP_HTTP_OK:-0}" = "1" ] || skip "WordPress không phản hồi trong môi trường này"
  local code
  code="$(code_path "/wp-login.php")"
  [[ "$code" =~ ^(200|301|302|404)$ ]]
}

@test "Nhóm 5: Tìm kiếm bình thường không bị chặn nhầm" {
  assert_passed "$(code_get s "huong dan cai dat wordpress")" "Tìm kiếm hợp lệ"
}

@test "Nhóm 5: Đăng nhập POST hợp lệ không bị chặn nhầm" {
  [ "${WP_HTTP_OK:-0}" = "1" ] || skip "WordPress không phản hồi trong môi trường này"
  assert_passed "$(code_post "/wp-login.php" \
    --data-urlencode "log=editor" --data-urlencode "pwd=MatKhau123")" "POST đăng nhập hợp lệ"
}

@test "Nhóm 5: Độ trễ khi bật WAF nằm trong ngưỡng cho phép" {
  local base on max overhead
  base="$(cat "$BASELINE_FILE" 2>/dev/null || echo 0)"
  on="$(avg_ms 10)"
  [ "$on" -ge 0 ]
  max="${WAF_MAX_OVERHEAD_MS:-800}"
  overhead=$((on - base))
  echo "[INFO] Độ trễ: WAF TẮT=${base}ms | WAF BẬT=${on}ms | chênh lệch=${overhead}ms (ngưỡng ${max}ms)" >&3
  [ "$overhead" -le "$max" ]
}

# =================================================================
# NHÓM 6: ROLLBACK KHI RELOAD OPENLITESPEED THẤT BẠI
# =================================================================

@test "Nhóm 6: off thất bại do reload lỗi => rollback, WAF vẫn BẬT và còn bộ luật" {
  mock_reload_fail
  run bash "$SCRIPT_MODSEC" off
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  modsec_block_present
  [ -s "$OWASP_DIR/crs30/owasp-master.conf" ]
}

@test "Nhóm 6: Sau rollback, WAF thật vẫn chặn tấn công" {
  assert_blocked "$(code_get id "1' OR '1'='1' -- -")" "SQLi sau rollback"
}

@test "Nhóm 6: on thất bại do reload lỗi => rollback, không để lại cấu hình/thư mục rác" {
  # Đưa về TẮT sạch trước
  run bash "$SCRIPT_MODSEC" off
  [ "$status" -eq 0 ]

  mock_reload_fail
  run bash "$SCRIPT_MODSEC" on
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  ! modsec_block_present
  [ ! -d "$OWASP_DIR" ]
  [ ! -d "${OWASP_DIR}.new" ]
  [ ! -d "${OWASP_DIR}.old" ]
}

# =================================================================
# NHÓM 7: KHÓA CHẠY ĐỒNG THỜI
# =================================================================

@test "Nhóm 7: Khi có tiến trình khác giữ khóa, script phải chờ (không chạy chồng)" {
  command -v flock >/dev/null || skip "Không có flock"

  flock "$LOCK_FILE" sleep 6 3>&- >/dev/null 2>&1 &
  local holder=$!
  sleep 1

  run timeout 3 bash "$SCRIPT_MODSEC" status
  wait "$holder" 2>/dev/null || true

  # 124 = bị timeout vì đang chờ khóa
  [ "$status" -eq 124 ]
}

# =================================================================
# NHÓM 8: TẮT WAF VÀ KIỂM CHỨNG LẠI
# =================================================================

@test "Nhóm 8: Bật lại WAF để chuẩn bị kiểm tra vòng tắt cuối" {
  run bash "$SCRIPT_MODSEC" on
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  assert_blocked "$(code_get id "1' OR '1'='1' -- -")" "SQLi trước khi tắt"
}

@test "Nhóm 8: off gỡ cấu hình và xóa bộ luật" {
  run bash "$SCRIPT_MODSEC" off
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "OFF" ]]
  ! modsec_block_present
  [ ! -d "$OWASP_DIR" ]
}

@test "Nhóm 8: off lần nữa là idempotent (mã 0)" {
  run bash "$SCRIPT_MODSEC" off
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "đã được TẮT từ trước" ]]
}

@test "Nhóm 8: Sau khi tắt, tấn công không còn bị WAF chặn" {
  assert_passed "$(code_get id "1' OR '1'='1' -- -")" "SQLi sau khi tắt"
  assert_passed "$(code_get s "<script>alert(1)</script>")" "XSS sau khi tắt"
}

@test "Nhóm 8: status trả mã 10 khi đã tắt" {
  run bash "$SCRIPT_MODSEC" status
  [ "$status" -eq 10 ]
  [[ "$output" =~ "OFF" ]]
}

@test "Nhóm 8: Website vẫn hoạt động bình thường sau toàn bộ chu trình bật/tắt" {
  local code
  code="$(code_path "${WAF_TARGET_PATH:-/}")"
  [ "$code" = "200" ]

  if [[ -f "/usr/local/lsws/${TEST_DOMAIN}/html/wp-config.php" ]]; then
    run wp core is-installed --path="/usr/local/lsws/${TEST_DOMAIN}/html" --allow-root
    [ "$status" -eq 0 ]
  fi
}

