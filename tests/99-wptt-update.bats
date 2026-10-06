#!/usr/bin/env bats

# =================================================================
# WPTangToc OLS - Update & Zero-Downtime Integration Tests
# =================================================================

export SCRIPT_GOC="/etc/wptt/wptt-update"
export CI="true"
export WPTT_ALLOW_REAL_UPDATE="${WPTT_ALLOW_REAL_UPDATE:-1}"

# =================================================================
# KHỞI TẠO & DỌN DẸP MÔI TRƯỜNG BẢO ĐẢM AN TOÀN DATA
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
  cat /tmp/wptt.conf.bak > /etc/wptt/.wptt.conf 2>/dev/null || true
  cat /tmp/core-functions.bak > /etc/wptt/core-functions 2>/dev/null || true
  mv /tmp/wptt-status2.bak /etc/wptt/wptt-status2 2>/dev/null || true
}

# --- HÀM GỠ LỖI TRỰC QUAN ---
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
  local LATEST_VERSION=$(curl -sL https://wptangtoc.com/share/version-wptangtoc-ols.txt | head -n 1)
  echo "version_wptangtoc_ols=$LATEST_VERSION" > /etc/wptt/.wptt.conf

  run bash "$SCRIPT_GOC"
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "BẠN ĐANG SỬ DỤNG PHIÊN BẢN MỚI NHẤT" ]]
}

@test "Update: Hủy cập nhật khi người dùng chọn 'Để sau'" {
  echo "version_wptangtoc_ols=0.0.1" > /etc/wptt/.wptt.conf

  # MOCKING PROXY: Ghi đè file, chèn hàm giả (Trả về 1 = Từ chối)
  cat << 'EOF' > /etc/wptt/core-functions
source /tmp/core-functions.bak
wptt_xac_nhan() { return 1; }
EOF

  run bash -c "bash $SCRIPT_GOC < /dev/null"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Đã hủy thao tác cập nhật" ]]
}

@test "Security: Kịch bản update không bị leak log (Không có set -x)" {
  run grep -nE '^[[:space:]]*set[[:space:]]+-[a-zA-Z]*x' "$SCRIPT_GOC"
  [ "$status" -ne 0 ]
}

@test "Security: Chặn đứng cập nhật nếu sai chữ ký số (Fake GPG / MITM Attack)" {
  echo "version_wptangtoc_ols=0.0.1" > /etc/wptt/.wptt.conf

  # MOCKING: Tiêm hàm gpg ảo
  cat << 'EOF' > /etc/wptt/core-functions
source /tmp/core-functions.bak
wptt_xac_nhan() { return 0; }

gpg() {
  if [[ "$*" == *"--verify"* ]]; then
    echo "gpg: BAD signature from WPTangToc (Lỗi được tiêm từ BATS)!" >&2
    return 1 # Báo lỗi xác thực GPG
  fi
  command gpg "$@"
}
EOF

  # THỰC THI
  run bash -c "bash $SCRIPT_GOC < /dev/null"

  # KIỂM ĐỊNH LỖI (Kỳ vọng trả về 1 vì bác đã thêm chốt chặn 'exit 1' cho môi trường CI)
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  
  [[ "$output" =~ "GPG AUTHENTICATION FAILED" ]]
}

@test "Update: Cập nhật thành công & Website Không Bị Sập (Zero-Downtime)" {
  if [[ "$WPTT_ALLOW_REAL_UPDATE" != "1" ]]; then
    skip "Bỏ qua test Update thật."
  fi

  echo "version_wptangtoc_ols=0.0.1" > /etc/wptt/.wptt.conf

  # 1. KIỂM TRA SỨC KHỎE TRƯỚC UPDATE (Chỉ lấy HTTP Code: 200, 404, 403 đều là web đang SỐNG)
  # Lỗi 000 = Sập/Không phản hồi. Lỗi 503 = OLS bị ngưng trệ.
  local http_truoc=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://127.0.0.1)
  
  if [[ "$http_truoc" == "000" || "$http_truoc" == "503" ]]; then
    echo -e "\n[CURL ERROR] OLS đang bị sập trước cả khi Update! (Mã HTTP: $http_truoc)" >&3
    false
  fi

  # 2. MOCKING PROXY: Chèn hàm giả để Đồng ý Update tự động
  cat << 'EOF' > /etc/wptt/core-functions
source /tmp/core-functions.bak
wptt_xac_nhan() { return 0; }
EOF

  # 3. THỰC THI LỆNH UPDATE THẬT
  run bash -c "bash $SCRIPT_GOC < /dev/null"
  
  # Giữ lại log để kiểm định
  local STATUS_UPDATE=$status
  local OUT_UPDATE="$output"

  # 4. [CHÉN THÁNH] KIỂM TRA ZERO-DOWNTIME SAU UPDATE
  local http_sau=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://127.0.0.1)

  # Đánh giá kết quả Update (Phải là mã 0 vì CI exit 0 khi update thành công)
  status=$STATUS_UPDATE
  output="$OUT_UPDATE"
  in_log_neu_loi 0
  [ "$STATUS_UPDATE" -eq 0 ]
  [[ "$OUT_UPDATE" =~ "Xác thực GPG Thành Công" ]]
  [[ "$OUT_UPDATE" =~ "đã cập nhật Hệ thống lên bản" ]]
  
  # Đánh giá kết quả Zero-Downtime
  if [[ "$http_sau" == "000" || "$http_sau" == "503" ]]; then
    echo -e "\n[CURL ERROR] Update xong làm sập OpenLiteSpeed! (Mã HTTP trả về: $http_sau)" >&3
    false
  fi
}

@test "Production safety: File Update luôn phải có quyền thực thi (Executable)" {
  [ -f "$SCRIPT_GOC" ]
  [ -x "$SCRIPT_GOC" ]
}
