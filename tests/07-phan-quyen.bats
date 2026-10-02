#!/usr/bin/env bats

setup() {
  export CI="true"
  export SCRIPT_GOC="/etc/wptt/wptt-phanquyen"
  export SCRIPT_TEST="/tmp/wptt-phanquyen-test.sh"
  
  # 1. TẠO FILE NHÁP VÀ CHỐT CHẶN BASH GOTCHA
  # (Không cần sed vô hiệu hóa menu nữa vì tầng CI đã "san phẳng" chúng rồi)
  cp "$SCRIPT_GOC" "$SCRIPT_TEST"
  echo "exit 0" >> "$SCRIPT_TEST"
  chmod +x "$SCRIPT_TEST" || true
  
  # 2. MÔI TRƯỜNG GIẢ LẬP RIÊNG CHO PHÂN QUYỀN
  mkdir -p /etc/wptt/tmp
  mkdir -p /etc/wptt/php
  if [ ! -f "/etc/wptt/php/php-cli-domain-config" ]; then
      echo 'phien_ban_php_domain_thuc_thi="83"' > /etc/wptt/php/php-cli-domain-config
      echo 'return 0' >> /etc/wptt/php/php-cli-domain-config
  fi
}

teardown() {
  # Dọn dẹp chiến trường
  rm -f "$SCRIPT_TEST" 2>/dev/null || true
  rm -rf "/usr/local/lsws/test-pq-normal.com" 2>/dev/null || true
  rm -rf "/usr/local/lsws/test-pq-lockdown.com" 2>/dev/null || true
  rm -f "/etc/wptt/vhost/.test-pq-normal.com.conf" 2>/dev/null || true
  rm -f "/etc/wptt/vhost/.test-pq-lockdown.com.conf" 2>/dev/null || true
}

# --- HÀM VŨ KHÍ GỠ LỖI ---
in_log_neu_loi() {
  local ma_ky_vong="$1"
  if [ "$status" -ne "$ma_ky_vong" ]; then
      echo -e "\n[LỖI TEST] Kịch bản không trả về mã $ma_ky_vong như kỳ vọng!" >&3
      echo "Mã trạng thái thực tế : $status" >&3
      echo -e "Nội dung in ra màn hình:\n$output" >&3
  fi
}

# =================================================================
# NHÓM 1: KIỂM THỬ LỖI ĐẦU VÀO
# =================================================================

@test "Integration: Chặn phân quyền nếu Website không tồn tại" {
  run bash "$SCRIPT_TEST" "domain-khong-ton-tai.com"
  
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không tồn tại trên hệ thống" ]]
}


@test "Integration: Test vòng lặp Tất cả website" {
  run bash "$SCRIPT_TEST" "Tất cả website"
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "DASHBOARD THAO TÁC HÀNG LOẠT" || "$output" =~ "Phân quyền toàn bộ website" ]]
}
