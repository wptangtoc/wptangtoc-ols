#!/usr/bin/env bats

setup_file() {
  export CI="true"
  export TEST_DOMAIN="test-cache-ols.com"
  export TEST_NO_WP="no-wp-cache.com"
  
  echo "Đang khởi tạo môi trường WordPress thực tế... Vui lòng đợi!" >&3
  
  # 1. TẠO WEBSITE 1: Cài đặt Full WordPress (Dành cho test Xóa Cache)
  bash /etc/wptt/domain/wptt-themwebsite "$TEST_DOMAIN" >/dev/null 2>&1 || true
  cat <<EOF > /tmp/wp-answers-cache.txt
Website Test Cache
admin_cache
PassKh0_123!@#
admin@${TEST_DOMAIN}
EOF
  cat /tmp/wp-answers-cache.txt | bash /etc/wptt/wptt-install-wordpress2 "$TEST_DOMAIN" >/dev/null 2>&1 || true
  rm -f /tmp/wp-answers-cache.txt

  # Tạo sẵn thư mục plugin litespeed-cache để đánh lừa Fallback
  mkdir -p "/usr/local/lsws/$TEST_DOMAIN/html/wp-content/plugins/litespeed-cache"

  # 2. TẠO WEBSITE 2: Chỉ thêm Vhost, KHÔNG CÀI WORDPRESS (Dành cho test ngoại lệ)
  bash /etc/wptt/domain/wptt-themwebsite "$TEST_NO_WP" >/dev/null 2>&1 || true
}

teardown_file() {
  # Dọn dẹp sạch sẽ
  bash /etc/wptt/domain/wptt-xoa-website "test-cache-ols.com" >/dev/null 2>&1 || true
  bash /etc/wptt/domain/wptt-xoa-website "no-wp-cache.com" >/dev/null 2>&1 || true
}

# =================================================================
# SETUP CHO TỪNG BÀI TEST
# =================================================================
setup() {
  export CI="true"
  export SCRIPT_GOC="/etc/wptt/cache/wptt-xoacache"
  export SCRIPT_TEST="/tmp/wptt-xoacache-test.sh"
  
  cp "$SCRIPT_GOC" "$SCRIPT_TEST"
  
  # Ngăn script thoát về menu chính làm treo CI (Ép nó trả về mã 1 khi gặp lỗi chặn)
  sed -i 's/exec \/etc\/wptt\/wptt-cache-main.*/exit 1/g' "$SCRIPT_TEST"
  
  # Chặn gọi chéo file gốc trong vòng lặp "Tất cả website"
  sed -i "s|/etc/wptt/cache/wptt-xoacache|$SCRIPT_TEST|g" "$SCRIPT_TEST"
  
  echo "exit 0" >> "$SCRIPT_TEST"
  chmod +x "$SCRIPT_TEST"
}

teardown() {
  rm -f "$SCRIPT_TEST" 2>/dev/null || true
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
# NHÓM 1: KIỂM THỬ NGOẠI LỆ
# =================================================================

@test "Integration: Chặn xóa cache nếu Tên miền không tồn tại" {
  run bash "$SCRIPT_TEST" "domain-khong-ton-tai.com"
  
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không tồn tại trên hệ thống" ]]
}

@test "Integration: Chặn xóa cache nếu Không phải mã nguồn WordPress" {
  # Dùng Website 2 (Đã có Vhost nhưng wp-load.php không hề tồn tại vì chưa cài WP)
  run bash "$SCRIPT_TEST" "no-wp-cache.com"
  
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không sử dụng mã nguồn" || "$output" =~ "dành cho mã nguồn WordPress" ]]
}

# =================================================================
# NHÓM 2: KIỂM THỬ THỰC CHIẾN (FALLBACK & ZERO-DOWNTIME)
# =================================================================

@test "Integration: Cơ chế Fallback đọc Plugin và Xóa Litespeed Cache Vật Lý" {
  # 1. FIXTURE: Tạo thư mục cache vật lý để test Atomic Swap (Tráo đổi bằng lệnh mv)
  mkdir -p "/usr/local/lsws/test-cache-ols.com/lscache/test-data"
  
  # 2. MOCKING WP-CLI (BẰNG PHP!): Làm giả bằng mã PHP để hệ thống đọc hiểu
  cp /usr/local/bin/wp /tmp/wp-cli.bak
  cat << 'EOF' > /usr/local/bin/wp
<?php
$args = implode(" ", $argv);
// Bắt WP-CLI phải sập (exit 1) để script của bác bật chế độ Fallback
if (strpos($args, 'plugin list') !== false) {
    exit(1); 
}
// Ép lệnh purge ném ra lỗi cURL để kích hoạt "Cú Đấm Thép" Xóa vật lý
if (strpos($args, 'litespeed-purge') !== false) {
    echo "cURL error 28: Connection timed out\n";
    exit(0);
}
EOF
  chmod +x /usr/local/bin/wp

  # 3. HÀNH ĐỘNG
  run bash "$SCRIPT_TEST" "test-cache-ols.com"
  
  # 4. PHỤC HỒI NGAY LẬP TỨC CHO CÁC TEST SAU
  mv /tmp/wp-cli.bak /usr/local/bin/wp

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  
  # 5. KIỂM CHỨNG
  # Kiểm tra kịch bản đã nhận diện thư mục Litespeed và xóa file vật lý
  [[ "$output" =~ "cache LiteSpeed cache" ]]
  [[ "$output" =~ "Bằng File vật lý" ]]
  
  # Thư mục lscache vật lý phải biến mất (đã đổi tên thành trash)
  [ ! -d "/usr/local/lsws/test-cache-ols.com/lscache/test-data" ]
}

@test "Integration: Test vòng lặp Xóa Cache Tất cả website" {
  run bash "$SCRIPT_TEST" "Tất cả website"
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "DASHBOARD THAO TÁC HÀNG LOẠT" ]]
  # Đảm bảo nó đã quét qua test-cache-ols.com
  [[ "$output" =~ "test-cache-ols.com" ]]
}
