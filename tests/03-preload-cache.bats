#!/usr/bin/env bats
#
# Kiểm thử tích hợp: Tính năng Preload Cache (WPTangToc OLS)
# Đảm bảo logic quét sitemap động của WordPress, kích hoạt công cụ cache, chế độ Spider Crawl dự phòng và nghiệm thu CACHE HIT thực tế.
#

setup_file() {
  export TEST_DOMAIN="wptest-auto.com"
  export SCRIPT_GOC="/etc/wptt/wptt-preload-cache2"
  export SCRIPT_TEST="/tmp/wptt-preload-cache-test.sh"
  
  # Tạo file Test độc lập
  cp "$SCRIPT_GOC" "$SCRIPT_TEST"
  sed -i 's/exec \/usr\/bin\/wptangtoc.*/exit 0/g' "$SCRIPT_TEST"
  echo "exit 0" >> "$SCRIPT_TEST"
  chmod +x "$SCRIPT_TEST" || true
}

teardown_file() {
  # Dọn dẹp website mồi (Chuyển giao từ file 03 sang file 04)
  export SCRIPT_XOA="/etc/wptt/domain/wptt-xoawebsite"
  if [ -x "$SCRIPT_XOA" ]; then
      echo -e "y\ny\n" | bash "$SCRIPT_XOA" "$TEST_DOMAIN" >/dev/null 2>&1 || true
  fi
  rm -f "$SCRIPT_TEST" 2>/dev/null || true
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
# NHÓM 1: KIỂM THỬ NGOẠI LỆ (EXCEPTIONS)
# =================================================================

@test "Preload Cache: Chặn tên miền sai định dạng" {
  run bash "$SCRIPT_TEST" "tenmiensai"
  
  in_log_neu_loi 0 
  [[ "$output" =~ "không đúng định dạng" || -z "$output" ]] 
}

@test "Preload Cache: Bắt lỗi Website không tồn tại" {
  run bash "$SCRIPT_TEST" "web-khong-ton-tai.com"
  
  in_log_neu_loi 0
  [[ "$output" =~ "không tồn tại trên hệ thống" ]]
}

# =================================================================
# NHÓM 2: KIỂM THỬ THỰC CHIẾN CHẾ ĐỘ SITEMAP NATIVE
# =================================================================

@test "Preload Cache: Chạy thành công thông qua WP Sitemap (Nhận diện LSCache)" {
  # Đảm bảo sitemap gốc của WP đang bật
  rm -f "/usr/local/lsws/$TEST_DOMAIN/html/wp-content/mu-plugins/disable-sitemap.php" 2>/dev/null || true

  # Bắn luồng
  run bash "$SCRIPT_TEST" "$TEST_DOMAIN"
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  
  # 1. Nhận diện được wp-sitemap.xml tự động của WordPress Core
  [[ "$output" =~ "Tìm thấy Sitemap" ]]
  
  # 2. Nhận diện được công nghệ LiteSpeed Cache (từ bài test số 03 để lại)
  [[ "$output" =~ "Xác nhận bạn đang sử dụng công nghệ" && "$output" =~ "LiteSpeed Cache" ]]
  
  # 3. Hoàn tất tiến trình
  [[ "$output" =~ "Hoàn tất tạo bộ nhớ đệm cho: $TEST_DOMAIN" ]]
}


@test "Preload Cache: Nghiệm thu CACHE HIT có sitemap.xml thực tế trên bài viết Hello World" {
  local UA_DESKTOP="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
  local URL="https://${TEST_DOMAIN}/hello-world/"
  local CURL_CMD="curl -s -D - -o /dev/null -L -k -A \"$UA_DESKTOP\" --http1.1 --resolve ${TEST_DOMAIN}:443:127.0.0.1 ${URL}"

  local max_attempts=15
  local attempt=1
  local REQ_HEADERS=""
  local is_hit=false

  # SMART POLLING: Chờ tối đa 30s để tiến trình Preload (chạy nền) ghi xong cache
  while [ $attempt -le $max_attempts ]; do
      REQ_HEADERS=$($CURL_CMD | tr -d '\r')
      
      if echo "$REQ_HEADERS" | grep -iq "x-litespeed-cache: hit"; then
          is_hit=true
          break
      fi
      
      sleep 2
      ((attempt++))
  done

  if [ "$is_hit" = false ]; then
      echo -e "\n[LỖI PRELOAD] Đã chờ 30s nhưng không thấy CACHE HIT.\n--- HEADERS THỰC TẾ CUỐI CÙNG ---\n$REQ_HEADERS" >&3
      false
  fi

  echo "[PASSED] Tuyệt vời! Bài viết /hello-world/ đã được Preload sẵn và trả về CACHE HIT!" >&3
}



# =================================================================
# NHÓM 3: KIỂM THỬ CHẾ ĐỘ SPIDER CRAWL (FALLBACK KHI MẤT SITEMAP)
# =================================================================

@test "Preload Cache: Chạy Fallback Spider Crawl khi WordPress bị tắt Sitemap" {
  # Dùng tuyệt chiêu Must-Use Plugin để ép WordPress tắt hoàn toàn Sitemap động từ bản 5.5
  local MU_PLUGIN_DIR="/usr/local/lsws/$TEST_DOMAIN/html/wp-content/mu-plugins"
  mkdir -p "$MU_PLUGIN_DIR"
  echo "<?php add_filter( 'wp_sitemaps_enabled', '__return_false' );" > "$MU_PLUGIN_DIR/disable-sitemap.php"
  
  # FIX: Chỉ cần chmod 644 (Read-only) để đảm bảo tiến trình PHP của Vhost tự do đọc được file
  chmod -R 755 "$MU_PLUGIN_DIR"
  chmod 644 "$MU_PLUGIN_DIR/disable-sitemap.php"

  
  # XÓA VẬT LÝ ĐỀ PHÒNG CÓ FILE TỒN ĐỌNG VÀ XOÁ SẠCH CACHE LITESPEED
  rm -f /usr/local/lsws/$TEST_DOMAIN/html/*.xml 2>/dev/null || true
  run /etc/wptt/cache/wptt-xoacache "$TEST_DOMAIN" >/dev/null 2>&1 || true
  run /etc/wptt/wptt-phanquyen "$TEST_DOMAIN" >/dev/null 2>&1 || true

	rm -rf -- /usr/local/lsws/$TEST_DOMAIN/html/wp-content/litespeed/* 2>/dev/null || true
	rm -rf -- /usr/local/lsws/$TEST_DOMAIN/luucache 2>/dev/null || true
  
  # KHỞI ĐỘNG LẠI OLS: Ép xả bóng ma OPcache trên RAM để nhận lệnh tắt Sitemap
  /usr/local/lsws/bin/lswsctrl restart >/dev/null 2>&1 || true
  
  # Flush lại rewrite để WordPress clear cache route
  /usr/local/bin/wp rewrite flush --path="/usr/local/lsws/$TEST_DOMAIN/html" --allow-root >/dev/null 2>&1 || true
	sleep 20
  # Bắn luồng
  run bash "$SCRIPT_TEST" "$TEST_DOMAIN"
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  
  # 1. Báo lỗi mất sitemap và tự động bật Spider Crawl
  [[ "$output" =~ "Tự động kích hoạt chế độ Spider Crawl" ]]
  
  # 2. Bật quá trình WGET chạy ẩn
  [[ "$output" =~ "Cào liên kết chế độ mặc định" ]]
  [[ "$output" =~ "Hoàn tất tạo bộ nhớ đệm cho: $TEST_DOMAIN" ]]
}


# =================================================================
# NHÓM 4: NGHIỆM THU KẾT QUẢ THỰC TẾ
# =================================================================

@test "Preload Cache: Nghiệm thu CACHE HIT Không có sitemap.xml thực tế trên bài viết Hello World" {
  local UA_DESKTOP="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
  local URL="https://${TEST_DOMAIN}/hello-world/"
  local CURL_CMD="curl -s -D - -o /dev/null -L -k -A \"$UA_DESKTOP\" --http1.1 --resolve ${TEST_DOMAIN}:443:127.0.0.1 ${URL}"

  local max_attempts=15
  local attempt=1
  local REQ_HEADERS=""
  local is_hit=false

  # SMART POLLING: Chờ tối đa 30s để tiến trình Preload (chạy nền) ghi xong cache

  while [ $attempt -le $max_attempts ]; do
      REQ_HEADERS=$($CURL_CMD | tr -d '\r')
      
      if echo "$REQ_HEADERS" | grep -iq "x-litespeed-cache: hit"; then
          is_hit=true
          break
      fi
      
      sleep 2
      ((attempt++))
  done

  if [ "$is_hit" = false ]; then
      echo -e "\n[LỖI PRELOAD] Đã chờ 30s nhưng không thấy CACHE HIT.\n--- HEADERS THỰC TẾ CUỐI CÙNG ---\n$REQ_HEADERS" >&3
      false
  fi

  echo "[PASSED] Tuyệt vời! Bài viết /hello-world/ đã được Preload sẵn và trả về CACHE HIT!" >&3
}
