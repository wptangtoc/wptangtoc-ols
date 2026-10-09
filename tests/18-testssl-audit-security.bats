#!/usr/bin/env bats

# ==============================================================================
# KIỂM THỬ AN NINH TLS/SSL BẰNG TESTSSL.SH (LOCAL AUDIT)
# ==============================================================================

setup_file() {
  export TEST_DOMAIN="github.wptangtoc.com"

  # Cài đặt testssl.sh siêu tốc nếu chưa có (chỉ là 1 file bash script + bin)
  if ! command -v testssl.sh >/dev/null 2>&1 && [ ! -f /usr/local/bin/testssl.sh ]; then
    git clone --depth 1 https://github.com/drwetter/testssl.sh.git /opt/testssl 2>/dev/null || true
    ln -sf /opt/testssl/testssl.sh /usr/local/bin/testssl.sh
  fi
}

setup() {
  if ! command -v testssl.sh >/dev/null 2>&1 && [ ! -x /usr/local/bin/testssl.sh ]; then
    skip "Chưa cài đặt testssl.sh trên môi trường test."
  fi

  # Kiểm tra OpenLiteSpeed có đang mở cổng 443 không
  if ! ss -tln | grep -qE ':(443)\s'; then
    skip "Cổng 443 chưa mở, bỏ qua bài test SSL audit."
  fi
}

@test "SSL Security: Đã khóa triệt để các giao thức cũ (SSLv2, SSLv3, TLS 1.0, TLS 1.1)" {
  # Quét nhanh danh sách giao thức (-p), chạy batch mode không hỏi tương tác
  run testssl.sh --warnings batch --ip 127.0.0.1 -p "https://${TEST_DOMAIN}:443"

  # Đảm bảo các giao thức cũ bị từ chối (not offered)
  [[ "$output" =~ "SSLv2" ]]
  [[ "$output" =~ "SSLv3" ]]
  [[ "$output" =~ "TLS 1 "[[:space:]]+"not offered" || "$output" =~ "TLS 1.0"[[:space:]]+"not offered" ]]
  [[ "$output" =~ "TLS 1.1"[[:space:]]+"not offered" ]]
}

@test "SSL Security: Bắt buộc hỗ trợ TLS 1.2 và TLS 1.3" {
  run testssl.sh --warnings batch --ip 127.0.0.1 -p "https://${TEST_DOMAIN}:443"

  [[ "$output" =~ "TLS 1.2"[[:space:]]+"offered" ]]
  [[ "$output" =~ "TLS 1.3"[[:space:]]+"offered" ]]
}

@test "SSL Security: Kiểm tra lỗ hổng nguy hiểm (Heartbleed, CCS Injection, POODLE)" {
  # Quét lỗ hổng cơ bản (-U) với tốc độ nhanh
  run testssl.sh --warnings batch --ip 127.0.0.1 -U --fast "https://${TEST_DOMAIN}:443"

  [[ "$output" =~ "Heartbleed"[[:space:]]+"not vulnerable" ]]
  [[ "$output" =~ "CCS"[[:space:]]+"not vulnerable" ]]
  [[ "$output" =~ "POODLE, SSL"[[:space:]]+"not vulnerable" ]]
}
