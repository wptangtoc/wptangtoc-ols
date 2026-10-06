#!/usr/bin/env bats
#
# Kiểm thử tích hợp: Giao thức HTTP/3 (QUIC) trên OpenLiteSpeed
# Áp dụng chiến thuật kiểm tra Cổng UDP và Header Alt-Svc
#

setup_file() {
  export TEST_DOMAIN="quic-test-protocol.com"
  export SCRIPT_THEM="/etc/wptt/domain/wptt-themwebsite"
  export SCRIPT_XOA="/etc/wptt/domain/wptt-xoawebsite"

  # 1. Tạo Website mồi
  bash "$SCRIPT_THEM" "$TEST_DOMAIN" >/dev/null 2>&1 || true

  # 2. Bơm file index.html tĩnh để ép OLS nhả mã HTTP 200 OK
  echo "QUIC E2E TEST" > "/usr/local/lsws/$TEST_DOMAIN/html/index.html"
  #chown -R lsadm:nobody "/usr/local/lsws/$TEST_DOMAIN/html/" 2>/dev/null || true

  # 3. Khởi động lại OLS để nạp Vhost
  /usr/local/lsws/bin/lswsctrl restart >/dev/null 2>&1 || true
  sleep 3
}

teardown_file() {
  # Dọn dẹp trả lại môi trường sạch sẽ
  if [ -x "$SCRIPT_XOA" ]; then
      echo -e "y\ny\n" | bash "$SCRIPT_XOA" "$TEST_DOMAIN" >/dev/null 2>&1 || true
  fi
}

# --- HÀM GỠ LỖI ---
in_log_neu_loi() {
  local ma_ky_vong="$1"
  if [ "$status" -ne "$ma_ky_vong" ]; then
      echo -e "\n[LỖI TEST QUIC] Kịch bản không trả về mã $ma_ky_vong như kỳ vọng!" >&3
      echo "Mã trạng thái thực tế : $status" >&3
      echo -e "Nội dung output:\n$output" >&3
  fi
}

# =================================================================
# NHÓM 1: KIỂM THỬ INFRASTRUCTURE (GIAO THỨC UDP)
# =================================================================

@test "QUIC: Cổng 443 UDP đang mở và lắng nghe (HTTP/3 Core)" {
  run bash -c "ss -uln | grep -qE ':(443)\s'"
  
  if [ "$status" -ne 0 ]; then
      echo -e "\n[LỖI CRITICAL] Cổng 443 UDP đang đóng! OpenLiteSpeed chưa bind được QUIC." >&3
      run bash -c "ss -uln"
      echo "Danh sách cổng UDP hiện tại: $output" >&3
      false
  fi
  [ "$status" -eq 0 ]
}

# =================================================================
# NHÓM 2: KIỂM THỬ TÍN HIỆU HEADER (ALT-SVC)
# =================================================================

@test "QUIC: Web Server phản hồi Header Alt-Svc báo hiệu hỗ trợ HTTP/3" {
  # CÚ ĐẤM THÉP: Bắn curl -k để bỏ qua lỗi SSL tự cấp phát, xin Header của file index.html
  local REQ_HEADERS=$(curl -s -I -k -H "Host: $TEST_DOMAIN" https://127.0.0.1/ | tr -d '\r')
  
  # Chốt chặn 1: Đảm bảo không bị lỗi 404 như bản cũ
  if ! echo "$REQ_HEADERS" | grep -iq "HTTP/.* 200"; then
      echo -e "\n[LỖI TIỀN ĐIỀU KIỆN] Không thể lấy được mã 200 OK. Web mồi bị lỗi.\n--- HEADERS THỰC TẾ ---\n$REQ_HEADERS" >&3
      false
  fi

  # Chốt chặn 2: Tìm kiếm cờ h3 (HTTP/3) trong Header
  if ! echo "$REQ_HEADERS" | grep -iq "alt-svc:.*h3="; then
      echo -e "\n[LỖI GIAO THỨC] OpenLiteSpeed KHÔNG phát tín hiệu Alt-Svc cho HTTP/3!" >&3
      echo -e "--- FULL HEADERS THỰC TẾ ---\n$REQ_HEADERS" >&3
      false
  fi

  # Chốt chặn nâng cao: Kiểm tra thời gian max-age của QUIC
  if ! echo "$REQ_HEADERS" | grep -iq "ma=2592000"; then
      echo -e "\n[CẢNH BÁO] Header Alt-Svc có h3 nhưng thiếu max-age chuẩn (ma=2592000). Cấu hình QUIC có thể chưa tối ưu." >&3
  fi

  echo "[HTTP/3 PASSED] Mã 200 OK! OpenLiteSpeed đã nhả Header QUIC thành công!" >&3
}
