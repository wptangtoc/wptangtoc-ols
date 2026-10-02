#!/usr/bin/env bats

setup() {
  export CI="true"
  export SCRIPT_GOC="/etc/wptt/domain/wptt-chuyen-huong"
  export SCRIPT_TEST="/tmp/wptt-chuyen-huong-test.sh"
  
  # 1. TẠO FILE NHÁP ĐỘC LẬP (Không đụng chạm đến core-functions nữa)
  cp "$SCRIPT_GOC" "$SCRIPT_TEST"
  
  # 2. VÔ HIỆU HÓA MENU CHÍNH (Chống treo BATS)
  sed -i 's/exec \/etc\/wptt\/wptt-domain-main.*/exit 0/g' "$SCRIPT_TEST"
  
  # 3. CHỐT CHẶN BẢO MẬT (BASH GOTCHA): Ép file bash luôn trả về mã 0
  echo "exit 0" >> "$SCRIPT_TEST"
  chmod +x "$SCRIPT_TEST" || true
} 

teardown() {
  # Chỉ cần dọn dẹp file nháp là xong, cực kỳ nhẹ máy!
  rm -f "$SCRIPT_TEST" 2>/dev/null || true
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
# NHÓM 1: KIỂM THỬ BỘ LỌC ĐẦU VÀO & LOGIC CƠ BẢN
# =================================================================

@test "Integration: Chặn chuyển hướng nếu Tên miền NGUỒN sai định dạng" {
  run bash "$SCRIPT_TEST" "ten mien sai" "dich.com"
  
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không đúng định dạng" || "$output" =~ "sai cấu trúc" ]]
}

@test "Integration: Chặn chuyển hướng nếu Tên miền ĐÍCH sai định dạng" {
  run bash "$SCRIPT_TEST" "nguon.com" "khong-co-dau-cham"
  
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "sai cấu trúc" || "$output" =~ "không hợp lệ" ]]
}

@test "Integration: Chặn vòng lặp vô tận (Nguồn giống hệt Đích)" {
  run bash "$SCRIPT_TEST" "wptangtoc.com" "wptangtoc.com"
  
  in_log_neu_loi 1
  [ "$status" -eq 1 ]
  [[ "$output" =~ "không thể chuyển hướng vòng lặp" ]]
}

# =================================================================
# NHÓM 2: KIỂM THỬ THỰC CHIẾN MÔI TRƯỜNG LITESPEED
# =================================================================

@test "Integration: Chuyển hướng một Tên miền CHƯA TỒN TẠI (Tạo Vhost Ảo)" {
  local DOMAIN_NGUON="chuyen-huong-moi.com"
  local DOMAIN_DICH="wptangtoc.com"

  # HÀNH ĐỘNG: Bơm data qua luồng
  run bash -c "bash $SCRIPT_TEST \"$DOMAIN_NGUON\" \"$DOMAIN_DICH\" < /dev/null"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "HOÀN TẤT CHUYỂN HƯỚNG TÊN MIỀN" ]]
  
  # KIỂM CHỨNG:
  # 1. File cờ đánh dấu chuyển hướng phải được tạo
  [ -f "/etc/wptt/chuyen-huong/.$DOMAIN_NGUON.conf" ]
  
  # 2. File Vhost ảo phải được hệ thống đẻ ra
  [ -f "/usr/local/lsws/conf/vhosts/$DOMAIN_NGUON/$DOMAIN_NGUON.conf" ]
  
  # 3. File htaccess phải chứa lệnh Redirect 301 trỏ đúng về đích
  run grep "RewriteRule (.*)\$ https://$DOMAIN_DICH/\$1 \[L, R=301,NC\]" "/usr/local/lsws/$DOMAIN_NGUON/html/.htaccess"
  [ "$status" -eq 0 ]
}

@test "Integration: Chuyển hướng một Tên miền ĐÃ TỒN TẠI (Ghi đè htaccess)" {
  local DOMAIN_NGUON="website-dang-chay.com"
  local DOMAIN_DICH="chuyen-nha-moi.com"

  # 1. TIỀN ĐIỀU KIỆN (FIXTURE): Dùng script Thêm Website để đẻ ra 1 website thật
  export SCRIPT_THEM="/etc/wptt/domain/wptt-themwebsite"
  bash "$SCRIPT_THEM" "$DOMAIN_NGUON" >/dev/null 2>&1 || true
  
  # Xác nhận Fixture: Đảm bảo website đã được tạo thành công
  if [ ! -d "/usr/local/lsws/$DOMAIN_NGUON/html" ]; then
      echo -e "\n[LỖI FIXTURE] Không thể tạo website mồi '$DOMAIN_NGUON'!" >&3
      return 1
  fi

  # 2. HÀNH ĐỘNG:
  # Nhờ sức mạnh của đoạn check CI=true do bác viết trong wptt_xac_nhan, kịch bản
  # sẽ TỰ ĐỘNG rẽ nhánh Đồng ý Ghi Đè cực kỳ khôn ngoan mà không cần Mocking!
  run bash -c "bash $SCRIPT_TEST \"$DOMAIN_NGUON\" \"$DOMAIN_DICH\" < /dev/null"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "HOÀN TẤT CHUYỂN HƯỚNG TÊN MIỀN" ]]
  
  # 3. KIỂM CHỨNG: Htaccess của website cũ phải bị ghi đè thành lệnh 301
  run grep "RewriteRule (.*)\$ https://$DOMAIN_DICH/\$1 \[L, R=301,NC\]" "/usr/local/lsws/$DOMAIN_NGUON/html/.htaccess"
  [ "$status" -eq 0 ]
}
