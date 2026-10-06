#!/usr/bin/env bats
#
# Sự ăn khớp giữa Certbot và WPTangToc OLS (Zero-Downtime SSL)
# Giả lập luồng chạy thực tế của Cronjob để xử lý sự cố.
#

setup_file() {
  export SCRIPT_RESET="/etc/wptt/ssl/auto-reset-ssl"
  
  # Tạo môi trường mồi
  mkdir -p /etc/letsencrypt/archive/wptest-ssl.com
  mkdir -p /usr/local/lsws
  
  # Lấy file thật ra một chỗ an toàn
  if [ -f /usr/bin/certbot ]; then
      mv /usr/bin/certbot /usr/bin/certbot_real.bak
  fi
}

teardown_file() {
  # Trả lại Certbot thật
  if [ -f /usr/bin/certbot_real.bak ]; then
      mv /usr/bin/certbot_real.bak /usr/bin/certbot
  else
      rm -f /usr/bin/certbot
  fi
  rm -rf /etc/letsencrypt/archive/wptest-ssl.com
}

setup() {
  export CI="true"
  export MOCK_CORE="/tmp/core-functions.mock"
  export TEST_RESET="/tmp/test-auto-reset-ssl.sh"
  export RELOAD_FLAG="/tmp/ols_reloaded.flag"
  export BEHAVIOR_FILE="/tmp/certbot_behavior"

  # 1. MOCKING CORE-FUNCTIONS (Bắt tín hiệu Reload của OLS)
  cat << 'EOF' > "$MOCK_CORE"
wptt_logs() { echo "[LOG] $1: $2"; }
wptt_smart_reload_lsws() { touch /tmp/ols_reloaded.flag; echo "[HÀNH ĐỘNG] Đã gọi Reload OLS!"; }
EOF

  cp /etc/wptt/ssl/auto-reset-ssl "$TEST_RESET" 2>/dev/null || true
  sed -i "s|\. /etc/wptt/core-functions|\. $MOCK_CORE|g" "$TEST_RESET"
  chmod +x "$TEST_RESET"

  # 2. DIỄN VIÊN ĐÓNG THẾ: /usr/bin/certbot
  # Nó sẽ đọc file BEHAVIOR_FILE để biết đạo diễn (BATS) muốn nó diễn cảnh gì
  cat << 'EOF' > /usr/bin/certbot
#!/bin/bash
BEHAVIOR=$(cat /tmp/certbot_behavior 2>/dev/null || echo "success")

if [ "$BEHAVIOR" == "fail" ]; then
    echo "Certbot Mock: Mất kết nối đến API Let's Encrypt (Lỗi 500)!" >&2
    exit 1
elif [ "$BEHAVIOR" == "skip" ]; then
    echo "Certbot Mock: Chứng chỉ còn hạn 60 ngày. Bỏ qua không gia hạn."
    exit 0
elif [ "$BEHAVIOR" == "success" ]; then
    echo "Certbot Mock: Gia hạn thành công!"
    # Đóng vai tải file chứng chỉ mới về (Cập nhật thời gian thực)
    touch /etc/letsencrypt/archive/wptest-ssl.com/cert.pem
    touch /etc/letsencrypt/archive/wptest-ssl.com/privkey.pem
    exit 0
fi
EOF
  chmod +x /usr/bin/certbot

  # Đặt thời gian gốc: OLS đã chạy từ 2 ngày trước, SSL cũ cũng từ 2 tháng trước
  touch -d "2 days ago" /usr/local/lsws/cgid
  touch -d "60 days ago" /etc/letsencrypt/archive/wptest-ssl.com/cert.pem
}

teardown() {
  rm -f "$TEST_RESET" "$MOCK_CORE" "$RELOAD_FLAG" "$BEHAVIOR_FILE" 2>/dev/null
}

# --- HÀM GỠ LỖI ---
in_log_neu_loi() {
  local ma_ky_vong="$1"
  if [ "$status" -ne "$ma_ky_vong" ]; then
      echo -e "\n[LỖI TEST] Kịch bản không trả về mã $ma_ky_vong như kỳ vọng!" >&3
      echo "Mã trạng thái thực tế : $status" >&3
      echo -e "Nội dung output:\n$output" >&3
  fi
}

# =================================================================
# KIỂM THỬ SỰ CỐ & SỰ ĂN KHỚP (PIPELINE)
# Giả lập luồng chạy thực tế của Cronjob: certbot renew && auto-reset-ssl
# =================================================================

@test "SSL Pipeline: [SỰ CỐ] Certbot sập mạng, Hệ thống không bị ảnh hưởng" {
  # Đạo diễn chỉ định cảnh quay: Lỗi mạng
  echo "fail" > "$BEHAVIOR_FILE"

  # Chạy Pipeline như Cronjob
  run bash -c "/usr/bin/certbot renew --quiet; bash $TEST_RESET"
  
  # Kiểm chứng: Cờ Reload OLS tuyệt đối KHÔNG ĐƯỢC sinh ra. 
  # Không có SSL mới thì không được phép reload làm chớp server vô cớ.
  if [ -f "$RELOAD_FLAG" ]; then
      echo "[LỖI LOGIC] Certbot thất bại mà hệ thống vẫn mù quáng Reload OLS!" >&3
      false
  fi
}

@test "SSL Pipeline: [BÌNH THƯỜNG] Chứng chỉ chưa hết hạn, Hệ thống bỏ qua mượt mà" {
  # Đạo diễn chỉ định cảnh quay: Chứng chỉ còn dài hạn
  echo "skip" > "$BEHAVIOR_FILE"

  # Chạy Pipeline
  run bash -c "/usr/bin/certbot renew --quiet; bash $TEST_RESET"
  
  # Kiểm chứng: SSL cũ không đổi timestamp, Auto-Reset phải thông minh nhận ra và KHÔNG reload
  if [ -f "$RELOAD_FLAG" ]; then
      echo "[LỖI LOGIC] SSL không có file mới nhưng script vẫn bắt OLS Reload tốn CPU!" >&3
      false
  fi
}

@test "SSL Pipeline: [THÀNH CÔNG] Certbot lấy file mới -> OLS nạp tức thì (Ăn khớp 100%)" {
  # Đạo diễn chỉ định cảnh quay: Thành công mĩ mãn
  echo "success" > "$BEHAVIOR_FILE"

  # Chạy Pipeline
  run bash -c "/usr/bin/certbot renew --quiet; bash $TEST_RESET"
  
  # KIỂM CHỨNG 1: Certbot phải sinh ra file .pem mới hơn cgid
  if [[ /etc/letsencrypt/archive/wptest-ssl.com/cert.pem -ot /usr/local/lsws/cgid ]]; then
      echo "[LỖI MOCK] File SSL chưa được cập nhật thời gian!" >&3
      false
  fi

  # KIỂM CHỨNG 2: Mảnh ghép cuối cùng - Auto-Reset phải bắt được tín hiệu và gọi Reload!
  if [ ! -f "$RELOAD_FLAG" ]; then
      echo "[LỖI] Certbot ĐÃ TẢI FILE MỚI, nhưng script 'auto-reset-ssl' lại bị mù, KHÔNG CHỊU RELOAD OLS!" >&3
      false
  fi
}
