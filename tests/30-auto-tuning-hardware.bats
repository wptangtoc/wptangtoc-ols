#!/usr/bin/env bats
#
# Kiểm thử tích hợp: Tự động tối ưu cấu hình khi thay đổi phần cứng (RAM)
# Mô phỏng việc VPS được nâng cấp/hạ cấp cấu hình.
#

setup_file() {
  export SCRIPT_TUNE="/etc/wptt/cau-hinh/wptt-auto-tune"
  export RAM_CACHE_FILE="/etc/wptt/.ram_hien_tai"
  export BACKUP_DIR="/tmp/wptt-tune-backup-$(date +%s)"
  
  mkdir -p "$BACKUP_DIR"

  # 1. Sao lưu cấu hình RAM hiện tại
  if [[ -f "$RAM_CACHE_FILE" ]]; then
      cp "$RAM_CACHE_FILE" "$BACKUP_DIR/ram_hien_tai.bak"
  fi

  # 2. Sao lưu cấu hình OLS
  cp -f /usr/local/lsws/conf/httpd_config.conf "$BACKUP_DIR/" 2>/dev/null || true
  cp -rf /usr/local/lsws/conf/vhosts "$BACKUP_DIR/" 2>/dev/null || true

  # 3. Sao lưu cấu hình MariaDB (Tự động nhận diện Ubuntu/RHEL)
  if grep -qi "ubuntu" /etc/os-release 2>/dev/null; then
      export DB_CONF="/etc/mysql/my.cnf"
  else
      export DB_CONF="/etc/my.cnf.d/server.cnf"
  fi
  cp -f "$DB_CONF" "$BACKUP_DIR/db.cnf.bak" 2>/dev/null || true
}

teardown_file() {
  # 1. Khôi phục nguyên trạng để không ảnh hưởng hệ thống
  cp -f "$BACKUP_DIR/httpd_config.conf" /usr/local/lsws/conf/ 2>/dev/null || true
  cp -rf "$BACKUP_DIR/vhosts" /usr/local/lsws/conf/ 2>/dev/null || true
  
  if [[ -f "$BACKUP_DIR/db.cnf.bak" ]]; then
      cp -f "$BACKUP_DIR/db.cnf.bak" "$DB_CONF" 2>/dev/null || true
  fi

  if [[ -f "$BACKUP_DIR/ram_hien_tai.bak" ]]; then
      cp "$BACKUP_DIR/ram_hien_tai.bak" "$RAM_CACHE_FILE"
  fi

  rm -rf "$BACKUP_DIR"

  # 2. Restart lại dịch vụ với cấu hình gốc
  systemctl restart mariadb >/dev/null 2>&1 || systemctl restart mysql >/dev/null 2>&1 || true
  /usr/local/lsws/bin/lswsctrl restart >/dev/null 2>&1 || true
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
# NHÓM 1: KIỂM THỬ LOGIC KÍCH HOẠT (TRIGGER LOGIC)
# =================================================================

@test "AutoTune: Bỏ qua (Không chạy) nếu RAM thay đổi dưới 500MB" {
  local REAL_RAM=$(free -m | awk '/^Mem:/{print $2}')
  # Giả lập RAM cũ chỉ kém RAM thật 100MB
  local FAKE_OLD_RAM=$((REAL_RAM - 100))
  echo "$FAKE_OLD_RAM" > "$RAM_CACHE_FILE"

  # Chạy script Auto-Tune
  run bash "$SCRIPT_TUNE"
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  
  # Đoán chắc chắn script không thèm chạy lệnh lưu RAM mới vào file vì DIFF < 500
  local CHECK_RAM=$(cat "$RAM_CACHE_FILE")
  if [[ "$CHECK_RAM" != "$FAKE_OLD_RAM" ]]; then
      echo "[LỖI LOGIC] Script đã chạy Auto-Tune dù RAM thay đổi dưới 500MB!" >&3
      false
  fi
}

@test "AutoTune: KÍCH HOẠT THÀNH CÔNG khi phát hiện RAM chênh lệch > 500MB" {
  # Giả lập máy chủ trước đây chỉ có 128MB RAM (Đảm bảo độ lệch > 500MB)
  echo "128" > "$RAM_CACHE_FILE"

  # Chạy script Auto-Tune
  run bash "$SCRIPT_TUNE"
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ]

  # Kiểm tra xem file cache RAM đã được cập nhật thành số RAM thực tế chưa
  local REAL_RAM=$(free -m | awk '/^Mem:/{print $2}')
  local CHECK_RAM=$(cat "$RAM_CACHE_FILE")
  
  if [[ "$CHECK_RAM" != "$REAL_RAM" ]]; then
      echo "[LỖI LOGIC] Script không cập nhật lại RAM mới vào file .ram_hien_tai sau khi Tune xong!" >&3
      false
  fi
}

# =================================================================
# NHÓM 2: KIỂM CHỨNG TÍNH TOÀN VẸN CỦA CẤU HÌNH (ENTERPRISE CHECKS)
# =================================================================

@test "AutoTune: Kiểm tra Cú pháp OLS an toàn sau khi bị sửa đổi" {
  # Chốt chặn tử thần: Đảm bảo các lệnh sed thay RAM/CPU không sinh ra khoảng trắng lỗi hay thiếu dấu
  run /usr/local/lsws/bin/openlitespeed -t
  
  if [ "$status" -ne 0 ]; then
      echo -e "\n=== [LỖI CRITICAL] SCRIPT AUTO-TUNE ĐÃ LÀM HỎNG CÚ PHÁP OLS ===" >&3
      echo "$output" >&3
  fi
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Syntax OK" || "$output" =~ "ok" || -z "$output" ]]

  # Đảm bảo dịch vụ vẫn đang Sống (Active)
  run systemctl is-active lsws
  [ "$status" -eq 0 ]
}

@test "AutoTune: Kiểm tra Cú pháp MariaDB an toàn sau khi phân bổ Buffer Pool" {
  local db_daemon=""
  if command -v mariadbd >/dev/null 2>&1; then db_daemon="$(command -v mariadbd)";
  elif command -v mysqld >/dev/null 2>&1; then db_daemon="$(command -v mysqld)";
  elif [ -x /usr/libexec/mariadbd ]; then db_daemon="/usr/libexec/mariadbd";
  elif [ -x /usr/sbin/mysqld ]; then db_daemon="/usr/sbin/mysqld"; fi

  if [ -z "$db_daemon" ]; then 
      skip "Không tìm thấy nhị phân mariadbd/mysqld để kiểm tra"
  fi

  # KỸ THUẬT ÉP ÉP MARIADB KHAI LỖI
  run bash -c "$db_daemon --help --verbose 2>&1 >/dev/null"
  
  if [[ -n "$output" && "$output" =~ (error|unknown[[:space:]]variable|warning) ]]; then
      echo -e "\n=== [LỖI CRITICAL] SCRIPT AUTO-TUNE LÀM HỎNG CẤU HÌNH MARIADB ===" >&3
      echo "$output" >&3
      false
  fi
  [ "$status" -eq 0 ]

  # Đảm bảo DB vẫn đang Sống
  run bash -c "systemctl is-active mariadb || systemctl is-active mysql"
  [ "$status" -eq 0 ]
}

@test "AutoTune: Cấu hình ZRAM được tạo thành công dựa theo Hệ Điều Hành" {
  if grep -qi "ubuntu" /etc/os-release 2>/dev/null; then
      # Kiểm tra chuẩn Ubuntu
      [ -f "/etc/default/zramswap" ]
      run grep "ALGO=" /etc/default/zramswap
      [ "$status" -eq 0 ]
  else
      # Kiểm tra chuẩn RHEL/AlmaLinux
      [ -f "/etc/systemd/zram-generator.conf" ]
      run grep "zram-size =" /etc/systemd/zram-generator.conf
      [ "$status" -eq 0 ]
  fi
}
