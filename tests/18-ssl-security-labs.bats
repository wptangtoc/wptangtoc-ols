#!/usr/bin/env bats

# KIỂM THỬ AN NINH TLS/SSL BẰNG OPENSSL

setup() {
  export TEST_DOMAIN="github.wptangtoc.com"

  if ! ss -tln | grep -qE ':(443)\s'; then
    skip "Cổng 443 chưa mở, bỏ qua bài test SSL."
  fi
}

# --- TEST 1: CÁC GIAO THỨC CŨ PHẢI BỊ CHẶN TUYỆT ĐỐI ---
@test "SSL Security: Đã khóa triệt để giao thức SSLv3, TLS 1.0, TLS 1.1" {
  local protocols=("-ssl3" "-tls1" "-tls1_1")

  for proto in "${protocols[@]}"; do
    run bash -c "echo '' | openssl s_client $proto -connect 127.0.0.1:443 -servername $TEST_DOMAIN 2>&1"
    
    # 1. Bắt buộc status khác 0 (Handshake không thể thành công) HOẶC không có dòng Cipher nào được đàm phán
    if [[ "$output" =~ "Cipher    : 0000" ]] || [[ ! "$output" =~ "Cipher    :" ]] || [ "$status" -ne 0 ]; then
      true
    else
      echo "LỖI: Giao thức $proto vẫn kết nối thành công!" >&2
      echo "$output" >&2
      return 1
    fi
  done
}

# --- TEST 2: BẮT BUỘC HỖ TRỢ TLS 1.2 VÀ TLS 1.3 ---
@test "SSL Security: Bắt buộc hỗ trợ TLS 1.2 và TLS 1.3" {
  # 1. Kiểm tra TLS 1.2
  run bash -c "echo '' | openssl s_client -tls1_2 -connect 127.0.0.1:443 -servername $TEST_DOMAIN 2>&1"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "TLSv1.2" ]]

  # 2. Kiểm tra TLS 1.3 (Dùng cờ -tls1_3)
  run bash -c "echo '' | openssl s_client -tls1_3 -connect 127.0.0.1:443 -servername $TEST_DOMAIN 2>&1"
  
  if [ "$status" -ne 0 ] || [[ ! "$output" =~ "TLSv1.3" ]]; then
    echo -e "\n=== THÔNG BÁO TEST TLS 1.3 ===" >&3
    echo "$output" | grep -iE "(protocol|cipher|error)" >&3 || true
  fi

  [ "$status" -eq 0 ]
  [[ "$output" =~ "TLSv1.3" ]]
}

# --- TEST 3: KIỂM TRA CHỨNG CHỈ CÓ HIỆU LỰC & HTTP/2 (ALPN) ---

#HTTP/3 (h3): Chạy trên giao thức QUIC, vốn nằm trên nền UDP. openssl s_client mặc định không hỗ trợ QUIC over UDP. khi nào hỗ trợ UDP thì mới test được cụ thế sau
@test "SSL Security: ALPN đàm phán thành công giao thức HTTP/2 (h2)" {
  run bash -c "echo '' | openssl s_client -alpn h2 -connect 127.0.0.1:443 -servername $TEST_DOMAIN 2>&1"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "ALPN protocol: h2" ]]
}
