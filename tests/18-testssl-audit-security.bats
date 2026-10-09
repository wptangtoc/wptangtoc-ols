#!/usr/bin/env bats

# ==============================================================================
# KIỂM THỬ AN NINH TLS/SSL BẰNG TESTSSL.SH (LOCAL AUDIT)
# ==============================================================================

setup_file() {
  export TEST_DOMAIN="github.wptangtoc.com"
  export SSL_JSON="/tmp/wptangtoc-testssl.json"
  export SSL_TXT="/tmp/wptangtoc-testssl.txt"
  export HAVE_JQ=0

  # Xóa file cũ tránh dùng nhầm dữ liệu từ lần chạy trước
  rm -f "$SSL_JSON" "$SSL_TXT"

  # 1. Cài đặt jq nếu thiếu (chỉ apt hoặc dnf, có sudo nếu không phải root)
  if command -v jq >/dev/null 2>&1; then
    HAVE_JQ=1
  else
    local sudo=""
    [ "$(id -u)" -ne 0 ] && command -v sudo >/dev/null 2>&1 && sudo="sudo"

    if command -v apt-get >/dev/null 2>&1; then
      $sudo apt-get update -qq && $sudo apt-get install -y -qq jq
    elif command -v dnf >/dev/null 2>&1; then
      $sudo dnf install -y -q jq
    fi
    command -v jq >/dev/null 2>&1 && HAVE_JQ=1
  fi

  # 2. Cài đặt testssl.sh (clone đầy đủ để có thư mục etc/ và bin/)
  if ! command -v testssl.sh >/dev/null 2>&1 && [ ! -x /usr/local/bin/testssl.sh ]; then
    git clone --depth 1 https://github.com/drwetter/testssl.sh.git /opt/testssl 2>/dev/null || true
    if [ -x /opt/testssl/testssl.sh ]; then
      ln -sf /opt/testssl/testssl.sh /usr/local/bin/testssl.sh
    fi
  fi

  # 3. Chạy testssl.sh MỘT LẦN DUY NHẤT cho cả bộ test (Tắt phone-out để không phụ thuộc internet)
  if command -v testssl.sh >/dev/null 2>&1 || [ -x /usr/local/bin/testssl.sh ]; then
    if ss -tlnH '( sport = :443 )' 2>/dev/null | grep -q .; then
      timeout 300 testssl.sh --quiet --color 0 --warnings batch --fast \
        -p -U \
        --phone-out off \
        --ip 127.0.0.1 --nodns none \
        --connect-timeout 5 --openssl-timeout 5 \
        --jsonfile-pretty "$SSL_JSON" \
        "https://${TEST_DOMAIN}:443" >"$SSL_TXT" 2>&1 || true
    fi
  fi
}

setup() {
  if ! command -v testssl.sh >/dev/null 2>&1 && [ ! -x /usr/local/bin/testssl.sh ]; then
    skip "Chưa cài đặt testssl.sh trên môi trường test."
  fi

  if ! ss -tlnH '( sport = :443 )' 2>/dev/null | grep -q .; then
    skip "Cổng 443 chưa mở, bỏ qua bài test SSL audit."
  fi

  if [ ! -s "$SSL_TXT" ]; then
    skip "testssl.sh không tạo được output."
  fi
}

teardown_file() {
  rm -f "$SSL_JSON" "$SSL_TXT"
}

# ==============================================================================
# TEST 1: Giao thức cũ phải bị khóa
# ==============================================================================
@test "SSL Security: Đã khóa triệt để các giao thức cũ (SSLv2, SSLv3, TLS 1.0, TLS 1.1)" {
  if [ "$HAVE_JQ" -eq 1 ] && [ -s "$SSL_JSON" ]; then
    run jq -r '.scanResult[]?
               | select(.id=="SSLv2" or .id=="SSLv3" or .id=="TLS1" or .id=="TLS1_1")
               | .finding' "$SSL_JSON"
    [ "$status" -eq 0 ]
    [ -n "$output" ] || skip "Không tìm thấy mục giao thức trong JSON."
    while IFS= read -r line; do
      [ "$line" = "not offered" ] || {
        echo "Giao thức cũ vẫn được bật: $line" >&2
        return 1
      }
    done <<<"$output"
  else
    run cat "$SSL_TXT"
    [[ "$output" =~ SSLv2[[:space:]]+not\ offered ]]
    [[ "$output" =~ SSLv3[[:space:]]+not\ offered ]]
    [[ "$output" =~ TLS\ 1[[:space:]]+not\ offered ]]
    [[ "$output" =~ TLS\ 1\.1[[:space:]]+not\ offered ]]
  fi
}

# ==============================================================================
# TEST 2: TLS 1.2 và TLS 1.3 phải được bật (cả hai, không chỉ một)
# ==============================================================================
@test "SSL Security: Bắt buộc hỗ trợ TLS 1.2 và TLS 1.3" {
  if [ "$HAVE_JQ" -eq 1 ] && [ -s "$SSL_JSON" ]; then
    run jq -r '.scanResult[]?
               | select(.id=="TLS1_2" or .id=="TLS1_3")
               | "\(.id)=\(.finding)"' "$SSL_JSON"
    [ "$status" -eq 0 ]
    [ -n "$output" ] || skip "Không tìm thấy mục TLS 1.2/1.3 trong JSON."

    local has12=0 has13=0
    while IFS= read -r line; do
      case "$line" in
      TLS1_2=offered) has12=1 ;;
      TLS1_3=offered) has13=1 ;;
      esac
    done <<<"$output"

    [ "$has12" -eq 1 ] || {
      echo "TLS 1.2 KHÔNG được bật" >&2
      return 1
    }
    [ "$has13" -eq 1 ] || {
      echo "TLS 1.3 KHÔNG được bật" >&2
      return 1
    }
  else
    run cat "$SSL_TXT"
    [[ "$output" =~ TLS\ 1\.2[[:space:]]+offered ]]
    [[ "$output" =~ TLS\ 1\.3[[:space:]]+offered ]]
  fi
}

# ==============================================================================
# TEST 3: Không dính lỗ hổng nguy hiểm
# ==============================================================================
@test "SSL Security: Kiểm tra lỗ hổng nguy hiểm (Heartbleed, CCS Injection, POODLE)" {
  if [ "$HAVE_JQ" -eq 1 ] && [ -s "$SSL_JSON" ]; then
    run jq -r '.scanResult[]?
               | select(.id=="heartbleed" or .id=="CCS" or .id=="POODLE_SSL")
               | .finding' "$SSL_JSON"
    [ "$status" -eq 0 ]
    [ -n "$output" ] || skip "Không tìm thấy mục lỗ hổng trong JSON."
    while IFS= read -r line; do
      [ "$line" = "not vulnerable" ] || {
        echo "Phát hiện lỗ hổng: $line" >&2
        return 1
      }
    done <<<"$output"
  else
    run cat "$SSL_TXT"
    [[ "$output" =~ Heartbleed[[:space:]]+not\ vulnerable ]]
    [[ "$output" =~ CCS[[:space:]]+not\ vulnerable ]]
    [[ "$output" =~ POODLE.*not\ vulnerable ]]
  fi
}
