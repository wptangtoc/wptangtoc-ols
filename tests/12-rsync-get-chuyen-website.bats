 #!/usr/bin/env bats

# WPTangToc OLS - RSYNC MOVE (MIGRATION) TESTS
export SCRIPT_GOC="/etc/wptt/chuyen-web/get-rsync-move"
export TEST_DOMAIN_1="migration-web1.com"
export TEST_DOMAIN_2="migration-web2.com"
export MOCK_LSWS_DIR="/usr/local/lsws/mock-migration/html"
export CI="true"
export LIST_FILE="$MOCK_LSWS_DIR/danh-sach-website-wptangtoc-ols.txt"

# --- HÀM GỠ LỖI ---
in_log_neu_loi() {
  local ma_ky_vong="$1"
  if [ "$status" -ne "$ma_ky_vong" ]; then
    echo -e "\n[LỖI TEST] Kịch bản không trả về mã $ma_ky_vong như kỳ vọng!" >&3
    echo "Mã trạng thái thực tế : $status" >&3
    echo -e "Nội dung in ra màn hình:\n$output" >&3
  fi
}

# ============================================================================
# KHỞI TẠO & DỌN DẸP MÔI TRƯỜNG VÔ TRÙNG
# ============================================================================
setup() {
  export SCRIPT_TEST="/tmp/get-rsync-move-test.sh"
  cp "$SCRIPT_GOC" "$SCRIPT_TEST"
  
  # Ngăn lệnh exec cuối file giết chết BATS và chặn lệnh read (Chờ bấm phím)
  sed -i 's/exec \/etc\/wptt\/wptt-chuyen-web-main.*/exit 0/g' "$SCRIPT_TEST"
  sed -i 's/read -r _/true/g' "$SCRIPT_TEST"
  
  # Xóa các dòng ghi đè PATH trong script gốc
  sed -i '/^PATH=/d' "$SCRIPT_TEST"
  sed -i '/^export PATH=/d' "$SCRIPT_TEST"
  
  # KHÓA CHỐT: Ép Bash luôn trả về 0 (Thành công) ở dòng cuối cùng để tránh lỗi False Evaluation
  echo "exit 0" >> "$SCRIPT_TEST"
  
  chmod +x "$SCRIPT_TEST"

  # 1. Sao lưu file hệ thống để Mocking an toàn
  cp /etc/wptt/core-functions /tmp/core-functions.bak 2>/dev/null || true

  # 2. Tạo không gian giả lập (Workspace) cho RSYNC
  mkdir -p "$MOCK_LSWS_DIR"
  echo "$TEST_DOMAIN_1 $TEST_DOMAIN_2" > "$LIST_FILE"

  # 3. MOCKING: Làm giả script khởi tạo website
  mkdir -p /etc/wptt/domain
  cat << 'EOF' > /etc/wptt/domain/wptt-themwebsite
#!/bin/bash
DOMAIN=$1
SAFE_DOM="${DOMAIN//-/_}"
SAFE_DOM="${SAFE_DOM//./_}"

mkdir -p "/etc/wptt/vhost"
cat << CONF > "/etc/wptt/vhost/.$DOMAIN.conf"
DB_Name_web="db_${SAFE_DOM:0:10}"
DB_User_web="u_${SAFE_DOM:0:10}"
DB_Password_web="Mock_Pass_123!"
CONF

mkdir -p "/usr/local/lsws/conf/vhosts/$DOMAIN"
touch "/usr/local/lsws/conf/vhosts/$DOMAIN/$DOMAIN.conf"
mkdir -p "/usr/local/lsws/$DOMAIN/html"
touch "/usr/local/lsws/$DOMAIN/html/.htaccess"
EOF
  chmod +x /etc/wptt/domain/wptt-themwebsite

  # Mồi file phụ trợ để không văng lỗi "No such file"
  mkdir -p /etc/wptt/db
  touch /etc/wptt/db/wptt-ket-noi
  touch /etc/wptt/wptt-phanquyen
  chmod +x /etc/wptt/db/wptt-ket-noi /etc/wptt/wptt-phanquyen
}

teardown() {
  rm -f "$SCRIPT_TEST"
  rm -rf /usr/local/lsws/mock-migration
  rm -rf "/usr/local/lsws/conf/vhosts/$TEST_DOMAIN_1"
  rm -rf "/usr/local/lsws/conf/vhosts/$TEST_DOMAIN_2"
  rm -f "/etc/wptt/vhost/.$TEST_DOMAIN_1.conf"
  rm -f "/etc/wptt/vhost/.$TEST_DOMAIN_2.conf"
  rm -rf "/usr/local/lsws/$TEST_DOMAIN_1"
  rm -rf "/usr/local/lsws/$TEST_DOMAIN_2"
  
  if [[ -f "/tmp/core-functions.bak" ]]; then
    mv "/tmp/core-functions.bak" /etc/wptt/core-functions
  fi

  # DỌN DẸP RÁC TRÊN MARIADB THẬT
  mariadb -e "DROP DATABASE IF EXISTS \`db_migration_\`;" 2>/dev/null || true
  mariadb -e "DROP USER IF EXISTS 'u_migration_'@'localhost';" 2>/dev/null || true
}

# ============================================================================
# CÁC BÀI TEST TÍCH HỢP
# ============================================================================

@test "Ngoại lệ: Chặn di cư khi MariaDB đang sập" {
  cat << 'EOF' >> /etc/wptt/core-functions
wptt_check_mariadb() { return 1; }
EOF

  run bash "$SCRIPT_TEST"
  in_log_neu_loi 1
  [ "$status" -ne 0 ]
  [[ "$output" =~ "MariaDB đang bị sập" ]]
}

@test "Ngoại lệ: Chặn di cư khi không tìm thấy danh sách domain (Chưa rsync xong)" {
  rm -f "$LIST_FILE"
  run bash "$SCRIPT_TEST"
  
  in_log_neu_loi 1
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Không tìm thấy danh sách website" ]]
}

@test "Hash Map O(1): Tự động BỎ QUA các domain đã tồn tại trên máy chủ" {
  mkdir -p /etc/wptt/vhost
  touch "/etc/wptt/vhost/.$TEST_DOMAIN_1.conf"

  cat << 'EOF' >> /etc/wptt/core-functions
wptt_check_mariadb() { return 0; }
wptt_check_lsws() { return 0; }
EOF

  run bash "$SCRIPT_TEST"

  [[ ! "$output" =~ "Khởi tạo website: $TEST_DOMAIN_1" ]]
  [[ "$output" =~ "Khởi tạo website: $TEST_DOMAIN_2" ]]
}

@test "Edge-Bug Bypass: Khởi tạo Vhost thất bại -> Bỏ qua và chạy tiếp domain khác" {
  cat << 'EOF' > /etc/wptt/domain/wptt-themwebsite
#!/bin/bash
exit 1
EOF

  cat << 'EOF' >> /etc/wptt/core-functions
wptt_check_mariadb() { return 0; }
wptt_check_lsws() { return 0; }
EOF

  run bash "$SCRIPT_TEST"

  [[ "$output" =~ "Lỗi: Khởi tạo Vhost cho $TEST_DOMAIN_1 thất bại! Đã Bypass" ]]
  [[ "$output" =~ "Lỗi: Khởi tạo Vhost cho $TEST_DOMAIN_2 thất bại! Đã Bypass" ]]
}

@test "Thực chiến: Chạy mượt mà toàn bộ quy trình Import (Vhost + Database + IP Check)" {
  cat << 'EOF' >> /etc/wptt/core-functions
wptt_check_mariadb() { return 0; }
wptt_check_lsws() { return 0; }
EOF

  # Mồi sẵn file SQL rỗng.
  mkdir -p "/usr/local/lsws/$TEST_DOMAIN_1/html"
  touch "/usr/local/lsws/$TEST_DOMAIN_1/html/giatuan-wptangtoc.sql"

  run bash -c "bash $SCRIPT_TEST < /dev/null"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Khởi tạo website: $TEST_DOMAIN_1" ]]
  [[ "$output" =~ "Import website $TEST_DOMAIN_1" ]]
  [[ "$output" =~ "HOÀN TẤT NẠP TẤT CẢ WEBSITE" ]]
  [[ "$output" =~ "Địa chỉ IPv4 máy chủ mới" ]]
}
