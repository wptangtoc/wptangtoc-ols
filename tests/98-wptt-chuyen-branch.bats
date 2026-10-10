#!/usr/bin/env bats

# =================================================================
# WPTangToc OLS - Switch Branch & Self-Healing Integration Tests
# =================================================================

export SCRIPT_GOC="/etc/wptt/wptt-update2"
export CI="true"
export WPTT_ALLOW_REAL_UPDATE="${WPTT_ALLOW_REAL_UPDATE:-1}"

# =================================================================
# KHỞI TẠO & DỌN DẸP MÔI TRƯỜNG BẢO ĐẢM AN TOÀN DATA
# =================================================================
setup() {
  # 1. SAO LƯU CẤU HÌNH GỐC (Bảo vệ biến môi trường hiện tại)
  cp /etc/wptt/.wptt.conf /tmp/wptt.conf.bak 2>/dev/null || true
  cp /etc/wptt/core-functions /tmp/core-functions.bak 2>/dev/null || true

  # 2. VÔ HIỆU HÓA LỆNH EXEC CUỐI FILE (Chống treo tiến trình BATS)
  mv /etc/wptt/wptt-status2 /tmp/wptt-status2.bak 2>/dev/null || true
  mv /etc/wptt/wptt-update-main /tmp/wptt-update-main.bak 2>/dev/null || true

  echo '#!/bin/bash' >/etc/wptt/wptt-status2
  echo 'exit 0' >>/etc/wptt/wptt-status2
  chmod +x /etc/wptt/wptt-status2

  echo '#!/bin/bash' >/etc/wptt/wptt-update-main
  echo 'exit 0' >>/etc/wptt/wptt-update-main
  chmod +x /etc/wptt/wptt-update-main
}

teardown() {
  # 3. KHÔI PHỤC NGUYÊN TRẠNG SAU KHI TEST XONG
  cat /tmp/wptt.conf.bak >/etc/wptt/.wptt.conf 2>/dev/null || true
  cat /tmp/core-functions.bak >/etc/wptt/core-functions 2>/dev/null || true
  mv /tmp/wptt-status2.bak /etc/wptt/wptt-status2 2>/dev/null || true
  mv /tmp/wptt-update-main.bak /etc/wptt/wptt-update-main 2>/dev/null || true
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

@test "Security: Chặn đứng cài đặt nhánh nếu sai chữ ký số GPG (Spoofing Attack)" {
  # MOCKING: Tiêm hàm gpg ảo để giả lập tấn công (Không nhả ra cờ GOODSIG)
  cat <<'EOF' >/etc/wptt/core-functions
source /tmp/core-functions.bak
gpg() {
  if [[ "$*" == *"--verify"* ]]; then
    echo "[GNUPG:] BADSIG (Lỗi được tiêm từ BATS)!" >&1
    return 0 # Cố tình trả Exit Code 0 để test cơ chế ống nối --status-fd 1
  fi
  command gpg "$@"
}
EOF

  # THỰC THI CHUYỂN NHÁNH BẤT KỲ
  run bash "$SCRIPT_GOC" "beta"

  # KIỂM ĐỊNH LỖI (Kỳ vọng trả về 1 vì status-fd 1 tóm được lỗi)
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "GPG AUTHENTICATION FAILED" ]]
}

@test "Branch Switch: Đổi sang nhánh BETA (Kiểm chứng Self-Healing & Zero-Downtime)" {
  if [[ "$WPTT_ALLOW_REAL_UPDATE" != "1" ]]; then
    skip "Bỏ qua test Update thật."
  fi

  # Đảm bảo môi trường đang ở trạng thái KHÔNG PHẢI BETA
  sed -i "/beta_wptangtoc_ols/d" /etc/wptt/.wptt.conf

  # 1. KIỂM THỬ SELF-HEALING: Cố tình xóa file lõi Core và file User
  local TEST_CORE_DIR="/etc/wptt/backup-restore"

  rm -rf "$TEST_CORE_DIR"

  # 2. THỰC THI LỆNH CHUYỂN SANG BETA
  run bash "$SCRIPT_GOC" "beta"

  local STATUS_UPDATE=$status
  local OUT_UPDATE="$output"

  # 3. [CHÉN THÁNH] KIỂM TRA TÍNH CHÍNH XÁC (SELF-HEALING)
  if [ ! -d "$TEST_CORE_DIR" ]; then
    echo -e "\n[LỖI CẬP NHẬT] Thư mục Core '$TEST_CORE_DIR' KHÔNG được phục hồi!" >&3
    false
  fi

  # 4. KIỂM TRA XEM BIẾN CẤU HÌNH ĐÃ ĐƯỢC GHI CHUẨN CHƯA
  if ! grep -q "beta_wptangtoc_ols=1" /etc/wptt/.wptt.conf; then
    echo -e "\n[LỖI NHÁNH] Không tìm thấy biến beta_wptangtoc_ols=1 trong cấu hình!" >&3
    false
  fi

  # Đánh giá kết quả Update tổng quát
  status=$STATUS_UPDATE
  output="$OUT_UPDATE"
  in_log_neu_loi 0
  [ "$STATUS_UPDATE" -eq 0 ]
  [[ "$OUT_UPDATE" =~ "THỬ NGHIỆM (Beta)" ]]
  [[ "$OUT_UPDATE" =~ "Xác thực GPG thành công" ]]
}

@test "Branch Switch: Đổi sang nhánh CHÍNH THỨC (Kiểm chứng Self-Healing & Gỡ cờ Beta)" {
  if [[ "$WPTT_ALLOW_REAL_UPDATE" != "1" ]]; then
    skip "Bỏ qua test Update thật."
  fi

  # Đảm bảo môi trường đang BỊ GẮN CỜ BETA
  echo "beta_wptangtoc_ols=1" >>/etc/wptt/.wptt.conf

  # 1. KIỂM THỬ SELF-HEALING: Cố tình xóa file
  local TEST_CORE_DIR="/etc/wptt/backup-restore"
  local TEST_USER_BIN="/usr/bin/wptangtoc"

  rm -rf "$TEST_CORE_DIR"
  rm -f "$TEST_USER_BIN"

  # 2. THỰC THI LỆNH CHUYỂN SANG CHÍNH THỨC
  run bash "$SCRIPT_GOC" "chinhthuc"

  local STATUS_UPDATE=$status
  local OUT_UPDATE="$output"

  # 3. [CHÉN THÁNH] KIỂM TRA TÍNH CHÍNH XÁC (SELF-HEALING)
  if [ ! -d "$TEST_CORE_DIR" ]; then
    echo -e "\n[LỖI CẬP NHẬT] Thư mục Core '$TEST_CORE_DIR' KHÔNG được phục hồi!" >&3
    false
  fi

  if [ ! -f "$TEST_USER_BIN" ]; then
    echo -e "\n[LỖI CẬP NHẬT] File Binary User '$TEST_USER_BIN' KHÔNG được phục hồi!" >&3
    false
  fi

  # 4. KIỂM TRA XEM CỜ BETA ĐÃ BỊ XÓA HAY CHƯA
  if grep -q "beta_wptangtoc_ols=1" /etc/wptt/.wptt.conf; then
    echo -e "\n[LỖI NHÁNH] Đã về nhánh Chính thức nhưng cờ Beta vẫn chưa bị xóa khỏi cấu hình!" >&3
    false
  fi

  # Đánh giá kết quả Update tổng quát
  status=$STATUS_UPDATE
  output="$OUT_UPDATE"
  in_log_neu_loi 0
  [ "$STATUS_UPDATE" -eq 0 ]
  [[ "$OUT_UPDATE" =~ "ỔN ĐỊNH (Stable/Main)" ]]
  [[ "$OUT_UPDATE" =~ "Xác thực GPG thành công" ]]
}

@test "Reinstall: Cài lại nhánh hiện tại mà không đổi cấu hình" {
  if [[ "$WPTT_ALLOW_REAL_UPDATE" != "1" ]]; then
    skip "Bỏ qua test Update thật."
  fi

  # Giả sử đang ở nhánh Ổn định
  sed -i "/beta_wptangtoc_ols/d" /etc/wptt/.wptt.conf

  run bash "$SCRIPT_GOC" "999"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Cài đặt lại" ]]
  [[ "$output" =~ "Xác thực GPG thành công" ]]
}
