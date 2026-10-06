#!/usr/bin/env bats
#
# Kiểm thử tích hợp: Tính năng Thay đổi Username (WPTangToc OLS)
# Đảm bảo logic kiểm tra đầu vào, dọn dẹp user cũ, cấp quyền user mới, tính toàn vẹn OLS & thực thi PHP CLI.
#

setup_file() {
  export TEST_DOMAIN="rename-test-auto.com"
  export SCRIPT_THEM="/etc/wptt/domain/wptt-themwebsite"
  export SCRIPT_XOA="/etc/wptt/domain/wptt-xoawebsite"
  export SCRIPT_GOC="/etc/wptt/domain/wptt-thay-doi-user"
  export SCRIPT_TEST="/tmp/wptt-thay-doi-user-test.sh"

  # --- Bơm thuốc giải: Dọn sạch tàn dư của các lần test lỗi trước đó ---
  userdel -f newuserauto123 >/dev/null 2>&1 || true
  userdel -f dummytontai >/dev/null 2>&1 || true
  # ---------------------------------------------------------------------

  # 1. Tạo file nháp để bypass lệnh 'clear'
  cp "$SCRIPT_GOC" "$SCRIPT_TEST"
  sed -i 's/^clear//g' "$SCRIPT_TEST"
  
  # Vô hiệu hóa prompt xác nhận UI để chống treo CI/CD
  sed -i 's/if ! wptt_xac_nhan.*/if false; then/g' "$SCRIPT_TEST"
  
  # Ép script bỏ qua Menu chọn, nhận thẳng Tên miền từ BATS truyền vào
  sed -i 's/lua_chon_NAME.*/NAME=$1/g' "$SCRIPT_TEST"
  
  chmod +x "$SCRIPT_TEST"

  # 2. TIỀN ĐIỀU KIỆN: Tạo một website mồi để test
  bash "$SCRIPT_THEM" "$TEST_DOMAIN" >/dev/null 2>&1 || true
  
  # Restart OLS để nạp Vhost mới
  /usr/local/lsws/bin/lswsctrl restart >/dev/null 2>&1 || true
  sleep 2
}

teardown_file() {
  # Dọn dẹp website test
  if [ -x "$SCRIPT_XOA" ]; then
      echo -e "y\ny\n" | bash "$SCRIPT_XOA" "$TEST_DOMAIN" >/dev/null 2>&1 || true
  fi
  
  # --- Dọn sạch rác User vừa test để không làm ảnh hưởng lần chạy sau ---
  userdel -f newuserauto123 >/dev/null 2>&1 || true
  userdel -f dummytontai >/dev/null 2>&1 || true
  # ----------------------------------------------------------------------
  
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
# NHÓM 1: KIỂM THỬ BỘ LỌC ĐẦU VÀO (VALIDATION)
# =================================================================

@test "Đổi User: Bắt lỗi nhập ký tự đặc biệt (!@#$)" {
  run bash -c "echo -e 'user!@#\n' | bash $SCRIPT_TEST $TEST_DOMAIN"
  
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không hợp lệ" ]]
}

@test "Đổi User: Bắt lỗi nhập Username đã tồn tại trên hệ thống" {
  useradd -M dummytontai >/dev/null 2>&1 || true

  run bash -c "echo -e 'dummytontai\n' | bash $SCRIPT_TEST $TEST_DOMAIN"
  
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "đã tồn tại" ]]
}

@test "Đổi User: Bắt lỗi nhập Username vượt quá 32 ký tự" {
  local LONG_USER="username_nay_thuc_su_dai_hon_32_ky_tu_cuc_ky_dai_luon"
  
  run bash -c "echo -e '$LONG_USER\n' | bash $SCRIPT_TEST $TEST_DOMAIN"
  
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Yêu cầu nhập nhỏ hơn dưới 32 ký tự" || "$output" =~ "không hợp lệ" ]]
}

# =================================================================
# NHÓM 2: KIỂM THỬ THỰC CHIẾN ĐỔI USER (HAPPY PATH)
# =================================================================

@test "Đổi User: Thực thi thành công và kiểm chứng toàn vẹn hệ thống Linux & OLS" {
  . "/etc/wptt/vhost/.$TEST_DOMAIN.conf"
  local OLD_USER="$User_name_vhost"
  local NEW_USER="newuserauto123"

  run bash -c "echo -e '$NEW_USER\n' | bash $SCRIPT_TEST $TEST_DOMAIN"
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ]

  # 1. KIỂM CHỨNG TÀI KHOẢN LINUX
  run id "$OLD_USER"
  [ "$status" -ne 0 ]

  run id "$NEW_USER"
  [ "$status" -eq 0 ]

  # 2. KIỂM CHỨNG PHÂN QUYỀN MÃ NGUỒN (CHOWN)
  local HTML_DIR="/usr/local/lsws/$TEST_DOMAIN/html"
  local OWNER=$(stat -c "%U" "$HTML_DIR")
  
  if [[ "$OWNER" != "$NEW_USER" ]]; then
      echo -e "\n[LỖI BẢO MẬT] Thư mục mã nguồn chưa được sang tên cho User mới! Owner hiện tại: $OWNER" >&3
      false
  fi

  # 3. KIỂM CHỨNG CẤU HÌNH OPENLITESPEED
  run grep -A 10 "virtualhost $TEST_DOMAIN {" /usr/local/lsws/conf/httpd_config.conf
  [[ "$output" =~ "user                    $NEW_USER" ]]
  
  run grep "extUser" "/usr/local/lsws/conf/vhosts/$TEST_DOMAIN/$TEST_DOMAIN.conf"
  [[ "$output" =~ "$NEW_USER" ]]

  # 4. KIỂM CHỨNG CÚ PHÁP OLS
  run /usr/local/lsws/bin/openlitespeed -t
  if [ "$status" -ne 0 ]; then
      echo -e "\n=== [LỖI CRITICAL] SCRIPT ĐỔI USER ĐÃ LÀM HỎNG CÚ PHÁP OLS ===" >&3
      echo "$output" >&3
      false
  fi

  # 5. KIỂM CHỨNG BẢO MẬT SSH CHROOT
  run grep "Match User $OLD_USER" /etc/ssh/sshd_config
  [ "$status" -ne 0 ]

  run grep "Match User $NEW_USER" /etc/ssh/sshd_config
  [ "$status" -eq 0 ]
}

# =================================================================
# NHÓM 3: KIỂM CHỨNG TÍNH NĂNG THỰC THI (EXECUTION TEST)
# =================================================================

@test "Đổi User: Website $TEST_DOMAIN thực thi thành công mã PHP CLI qua User mới" {
  local doc_root="/usr/local/lsws/$TEST_DOMAIN/html"
  local test_file="$doc_root/bats-test.php"

  # Lấy linh hoạt tên User đang sở hữu thư mục (Chính là newuserauto123)
  local vhost_user
  vhost_user=$(stat -c '%U' "$doc_root")

  # Tự động tìm đường dẫn PHP mới nhất trên server WPTangToc
  local lsphp_bin
  lsphp_bin=$(ls /usr/local/lsws/lsphp*/bin/lsphp 2>/dev/null | sort -V | tail -n 1)

  # Tạo file nháp PHP
  run bash -c "echo '<?php echo \"GiaTuanDz_PHP_CLI\"; ?>' > $test_file"
  [ "$status" -eq 0 ]
  
  # Cấp quyền cho file nháp đúng với User
  run bash -c "chown $vhost_user:$vhost_user $test_file"
  [ "$status" -eq 0 ]

  # Bắn lệnh thực thi PHP bằng sudo dưới thân phận User Vhost
  run bash -c "sudo -u $vhost_user $lsphp_bin $test_file"
  
  # Xóa dấu vết
  rm -f -- "$test_file"
  
  # Kiểm chứng kết quả text trả về
  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" == *"GiaTuanDz_PHP_CLI"* ]]
}
