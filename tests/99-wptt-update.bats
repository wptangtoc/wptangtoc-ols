#!/usr/bin/env bats

# =================================================================
# WPTangToc OLS - Update & Zero-Downtime Integration Tests
# =================================================================

export SCRIPT_GOC="/etc/wptt/wptt-update"
export CI="true"
export TEST_DOMAIN="test-update-ols.com"
export WPTT_ALLOW_REAL_UPDATE="${WPTT_ALLOW_REAL_UPDATE:-0}"

# =================================================================
# TẠO WEBSITE MỒI ĐỂ TEST ZERO-DOWNTIME (Chạy 1 lần duy nhất)
# =================================================================
setup_file() {
  echo "Đang tạo Website Fixture để test Zero-Downtime Update..." >&3
  
  # Tạo 1 website mẫu thực tế
  bash /etc/wptt/domain/wptt-themwebsite "$TEST_DOMAIN" >/dev/null 2>&1 || true
  mkdir -p "/usr/local/lsws/$TEST_DOMAIN/html"
  echo "<?php echo 'ALIVE_8205'; ?>" > "/usr/local/lsws/$TEST_DOMAIN/html/index.php"
  chown -R root:root "/usr/local/lsws/$TEST_DOMAIN/html" 2>/dev/null || true

  # Ép Local DNS để lệnh curl chạy mượt mà
  SERVER_IP=$(ip -4 route get 8.8.8.8 | awk '{print $7}' | head -n 1)
  echo "$SERVER_IP $TEST_DOMAIN #wptt_test_dns" >> /etc/hosts
}

teardown_file() {
  bash /etc/wptt/domain/wptt-xoa-website "$TEST_DOMAIN" >/dev/null 2>&1 || true
  sed -i '/#wptt_test_dns/d' /etc/hosts 2>/dev/null || true
}

# =================================================================
# KHỞI TẠO & DỌN DẸP MÔI TRƯỜNG (CHẠY TRƯỚC VÀ SAU MỖI BÀI TEST)
# =================================================================
setup() {
  # 1. SAO LƯU FILE GỐC (Bảo vệ dữ liệu thật)
  cp /etc/wptt/.wptt.conf /tmp/wptt.conf.bak 2>/dev/null || true
  cp /etc/wptt/core-functions /tmp/core-functions.bak 2>/dev/null || true
  
  # 2. VÔ HIỆU HÓA LỆNH EXEC CUỐI FILE (Chống treo BATS)
  mv /etc/wptt/wptt-status2 /tmp/wptt-status2.bak 2>/dev/null || true
  echo '#!/bin/bash' > /etc/wptt/wptt-status2
  echo 'exit 0' >> /etc/wptt/wptt-status2
  chmod +x /etc/wptt/wptt-status2
}

teardown() {
  # 3. KHÔI PHỤC NGUYÊN TRẠNG SAU KHI TEST XONG
  mv /tmp/wptt.conf.bak /etc/wptt/.wptt.conf 2>/dev/null || true
  mv /tmp/core-functions.bak /etc/wptt/core-functions 2>/dev/null || true
  mv /tmp/wptt-status2.bak /etc/wptt/wptt-status2 2>/dev/null || true
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

# =================================================================
# CÁC BÀI TEST TÍCH HỢP
# =================================================================

@test "Update: Báo thành công khi Đang ở Phiên bản Mới nhất" {
  # Lấy phiên bản mới nhất từ server gốc để làm mồi nhử
  local LATEST_VERSION=$(curl -sL https://wptangtoc.com/share/version-wptangtoc-ols.txt | head -n 1)
  
  # Ép config máy chủ cục bộ bằng đúng version mới nhất
  echo "version_wptangtoc_ols=$LATEST_VERSION" > /etc/wptt/.wptt.conf

  run bash "$SCRIPT_GOC"
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "BẠN ĐANG SỬ DỤNG PHIÊN BẢN MỚI NHẤT" ]]
}

@test "Update: Hủy cập nhật khi người dùng chọn 'Để sau'" {
  echo "version_wptangtoc_ols=0.0.1" > /etc/wptt/.wptt.conf

  # MOCKING PROXY (Tuyệt chiêu của bác): Ghi đè file, chèn hàm giả (Trả về 1 = Từ chối)
  cat << 'EOF' > /etc/wptt/core-functions
source /tmp/core-functions.bak
wptt_xac_nhan() { return 1; }
EOF

  # Ép đóng băng STDIN (</dev/null) để không bị treo
  run bash -c "bash $SCRIPT_GOC < /dev/null"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Đã hủy thao tác cập nhật" ]]
}

@test "Security: Kịch bản update không bị leak log (Không có set -x)" {
  run grep -nE '^[[:space:]]*set[[:space:]]+-[a-zA-Z]*x' "$SCRIPT_GOC"
  [ "$status" -ne 0 ]
}

@test "Update: Cập nhật thành công & Website Không Bị Sập (Zero-Downtime)" {
  if [[ "$WPTT_ALLOW_REAL_UPDATE" != "1" ]]; then
    skip "Bỏ qua test Update thật. Chạy 'WPTT_ALLOW_REAL_UPDATE=1 bats...' để kích hoạt."
  fi

  echo "version_wptangtoc_ols=0.0.1" > /etc/wptt/.wptt.conf

  # 1. KIỂM TRA SỨC KHỎE WEB TRƯỚC KHI UPDATE
  local web_truoc=$(curl -s http://$TEST_DOMAIN)
  [[ "$web_truoc" == *"ALIVE_8205"* ]]

  # 2. MOCKING PROXY: Chèn hàm giả (Trả về 0 = Đồng ý Update)
  cat << 'EOF' > /etc/wptt/core-functions
source /tmp/core-functions.bak
wptt_xac_nhan() { return 0; }
EOF

  # 3. THỰC THI LỆNH UPDATE THẬT
  run bash -c "bash $SCRIPT_GOC < /dev/null"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Xác thực GPG Thành Công" ]]
  [[ "$output" =~ "WPTangToc OLS đã cập nhật Hệ thống lên bản" ]]

  # 4. [CHÉN THÁNH] KIỂM TRA ZERO-DOWNTIME SAU UPDATE
  # Nếu OLS hoặc PHP bị chết trong quá trình update, lệnh curl này sẽ văng lỗi 503 hoặc Timeout
  local web_sau=$(curl -s --max-time 5 http://$TEST_DOMAIN)
  [[ "$web_sau" == *"ALIVE_8205"* ]]
}

@test "Production safety: File Update luôn phải có quyền thực thi (Executable)" {
  [ -f "$SCRIPT_GOC" ]
  [ -x "$SCRIPT_GOC" ] # Đơn giản và chính xác nhất: Chỉ cần check file có quyền thực thi
}
