#!/usr/bin/env bats

setup() {
  export CI="true"
  export SCRIPT_GOC="/etc/wptt/domain/wptt-xoa-domain-chuyen-huong"
  export SCRIPT_TEST="/tmp/wptt-xoa-chuyen-huong-test.sh"
  
  # 1. BẢO VỆ MÔI TRƯỜNG & MOCKING
  cp /etc/wptt/core-functions /tmp/core-functions.bak 2>/dev/null || true
  
  # Cô lập thư mục cấu hình thật, tạo không gian sạch sẽ 100% cho bài Test
  if [ -d "/etc/wptt/chuyen-huong" ]; then
     mv /etc/wptt/chuyen-huong /etc/wptt/chuyen-huong.bats.bak
  fi
  mkdir -p /etc/wptt/chuyen-huong

  cp "$SCRIPT_GOC" "$SCRIPT_TEST"
  
  # 2. VÔ HIỆU HÓA MENU CHÍNH
  sed -i 's/exec \/etc\/wptt\/wptt-domain-main.*/exit 0/g' "$SCRIPT_TEST"
  
  # 3. MOCKING LỆNH PHÁ HỦY (Cực kỳ quan trọng để bảo vệ Server và chạy test nhanh)
  sed -i 's|bash /etc/wptt/domain/wptt-xoa-website|echo "[MOCK_SAFE] Đã gọi wptt-xoa-website"|g' "$SCRIPT_TEST"
  
  # 4. CHỐT CHẶN BẢO MẬT (BASH GOTCHA)
  echo "exit 0" >> "$SCRIPT_TEST"
  chmod +x "$SCRIPT_TEST" || true
} 

teardown() {
  # 1. KHÔI PHỤC NGUYÊN TRẠNG CORE
  mv /tmp/core-functions.bak /etc/wptt/core-functions 2>/dev/null || true
  
  # 2. TRẢ LẠI THƯ MỤC CẤU HÌNH THẬT CHO MÁY CHỦ
  rm -rf /etc/wptt/chuyen-huong
  if [ -d "/etc/wptt/chuyen-huong.bats.bak" ]; then
     mv /etc/wptt/chuyen-huong.bats.bak /etc/wptt/chuyen-huong
  fi

  # 3. DỌN DẸP RÁC FIXTURE
  rm -f "$SCRIPT_TEST" 2>/dev/null || true
  rm -rf "/usr/local/lsws/test-del-full.com" 2>/dev/null || true
  rm -rf "/usr/local/lsws/test-keep-source.com" 2>/dev/null || true
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
# NHÓM 1: KIỂM THỬ NGOẠI LỆ (EXCEPTION TESTS)
# =================================================================

@test "Integration: Báo lỗi từ chối nếu VPS chưa từng thiết lập chuyển hướng" {
  # Lúc này thư mục /etc/wptt/chuyen-huong đang trống rỗng nhờ setup()
  run bash "$SCRIPT_TEST"
  
  in_log_neu_loi 0
  [ "$status" -eq 0 ] # Nhờ lệnh exit 0 ta đã chèn
  [[ "$output" =~ "chưa từng thiết lập chuyển hướng domain nào" || "$output" =~ "Không có domain nào tồn tại" ]]
}

# =================================================================
# NHÓM 2: KIỂM THỬ THỰC CHIẾN (LOGIC XOÁ MÃ NGUỒN)
# =================================================================

@test "Integration: Xóa chuyển hướng VÀ Xóa sạch mã nguồn (Luồng CI Auto-Yes)" {
  local DOMAIN="test-del-full.com"

  # 1. TIỀN ĐIỀU KIỆN (FIXTURE): Giả lập một website đang chuyển hướng và có mã nguồn PHP
  touch "/etc/wptt/chuyen-huong/.$DOMAIN.conf"
  mkdir -p "/usr/local/lsws/$DOMAIN/html"
  touch "/usr/local/lsws/$DOMAIN/html/index.php" # Mồi nhử để kích hoạt câu hỏi xóa mã nguồn

  # 2. HÀNH ĐỘNG: Bơm phím "1" qua ống dẫn (Pipe) để chọn website đầu tiên trong Menu
  # Biến CI="true" sẽ tự động trả lời "Có (Xóa sạch)" ở câu hỏi xác nhận.
  run bash -c "echo '1' | bash $SCRIPT_TEST"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  
  # 3. KIỂM CHỨNG:
  [[ "$output" =~ "Xóa hoàn toàn Mã nguồn" ]]
  
  # Xác nhận lệnh gọi "wptt-xoa-website" đã được kích hoạt thành công (dựa vào cờ Mock)
  [[ "$output" =~ "[MOCK_SAFE] Đã gọi wptt-xoa-website" ]]
}

@test "Integration: Chỉ gỡ chuyển hướng, GIỮ LẠI mã nguồn (Từ chối Xóa)" {
  local DOMAIN="test-keep-source.com"

  # 1. TIỀN ĐIỀU KIỆN (FIXTURE)
  touch "/etc/wptt/chuyen-huong/.$DOMAIN.conf"
  mkdir -p "/usr/local/lsws/$DOMAIN/html"
  touch "/usr/local/lsws/$DOMAIN/html/index.php"
  
  # Giả lập file .htaccess đang chứa đoạn code Redirect 301
  echo "#begin-chuyen-huong-domain-wptangtoc
Redirect 301
#end-chuyen-huong-domain-wptangtoc" > "/usr/local/lsws/$DOMAIN/html/.htaccess"

  # 2. MOCKING TẠM THỜI: Ép hàm wptt_xac_nhan trả về False (Mã 1 - Không đồng ý)
  # Việc này ghi đè logic CI=true chỉ riêng trong bài test này để kiểm tra nhánh Else.
  cat << 'EOF' > /etc/wptt/core-functions
source /tmp/core-functions.bak
wptt_xac_nhan() { return 1; }
EOF

  # 3. HÀNH ĐỘNG: Chọn website số 1
  run bash -c "echo '1' | bash $SCRIPT_TEST"

  in_log_neu_loi 0
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Giữ lại dữ liệu. Chỉ gỡ bỏ luật Chuyển hướng" ]]
  
  # 4. KIỂM CHỨNG: 
  # File htaccess phải bị dọn sạch (Grep không tìm thấy đoạn block chuyển hướng nữa)
  run grep "#begin-chuyen-huong-domain-wptangtoc" "/usr/local/lsws/$DOMAIN/html/.htaccess"
  [ "$status" -eq 1 ] # Mã 1 = Lệnh grep trả về rỗng (Đã xóa thành công)
}
