#!/usr/bin/env bats

# ==============================================================================
# KỊCH BẢN KIỂM THỬ BẢO MẬT (SECURITY UNIT TEST) - CHUẨN ENTERPRISE
# Mục đích: Ngăn chặn lỗi chèn mã độc (Command Injection) khi ghi file cấu hình
# ==============================================================================

# Hàm setup chạy trước mỗi bài test, có nhiệm vụ thiết lập "Môi trường giả lập"
setup() {
  # Trỏ đường dẫn về thư mục gốc của project (chứa các file wptangtoc-ols-*)
  REPO_ROOT=$(cd "$BATS_TEST_DIRNAME/.." && pwd)
  
  # Tạo file cấu hình và file bẫy (probe) trong thư mục bộ nhớ tạm của BATS
  export TEST_CONFIG="$BATS_TEST_TMPDIR/wptt.conf"
  export PROBE_FILE="$BATS_TEST_TMPDIR/executed"
  
  # Giả lập các biến môi trường để khi test, code bash không bị crash vì thiếu biến
  export port_ssh=22 password_database_root_ma_hoa_luu_tru=fixture
  export php_version=8.3 NAME=example.com thoi_gian_cai_dat_phan_mem=01-01-2026
}

# Hàm lõi: Bóc tách mã nguồn thực tế và nã mã độc vào để kiểm tra sức chịu đựng
check_writer() {
  local file="$1" writer payload

  # [BẢO MẬT CI/CD] Tự động bỏ qua (Skip) an toàn nếu file chưa được tạo hoặc chưa push lên Github
  if [ ! -f "$REPO_ROOT/$file" ]; then
    skip "Bỏ qua test: File '$file' chưa tồn tại trong mã nguồn gốc."
  fi

  # TỰ ĐỘNG BÓC TÁCH CODE THẬT CỦA BÁC:
  # Nếu là file cài đặt gốc (nằm ngoài cùng), nó dùng sed để cắt khối 'cat <<EOF'
  if [[ "$file" == wptangtoc-ols-* ]]; then
    writer=$(sed -n '/^cat > \/etc\/wptt\/\.wptt.conf <<EOF$/,/^EOF$/p' "$REPO_ROOT/$file")
  # Nếu là các công cụ (nằm trong tool-wptangtoc-ols), nó cắt dòng có chứa 'version_wptangtoc_ols'
  else
    writer=$(awk '/version_wptangtoc_ols/ && /\.wptt.conf/ && /^[[:space:]]*(sed|echo|printf) /' "$REPO_ROOT/$file")
  fi
  
  # Đảm bảo lệnh bóc tách đã bắt trúng đoạn code cần test
  [ -n "$writer" ]
  
  # Đổi hướng ghi file từ /etc/wptt/.wptt.conf (hệ thống) sang $TEST_CONFIG (thư mục ảo)
  printf '%s\n' "$writer" | sed 's@/etc/wptt/\.wptt.conf@"$TEST_CONFIG"@g' > "$BATS_TEST_TMPDIR/write-config"

  # Kho đạn (Payloads): Danh sách các mã độc dùng để tấn công thử nghiệm
  local payloads=(
    '4.0.0'
    '8.2.1.2'
    '8.2.1$(touch "$PROBE_FILE")'      # Chèn lệnh qua Subshell
    '8.2.1`touch "$PROBE_FILE"`'       # Chèn lệnh qua Backtick
    '8.2.1; touch "$PROBE_FILE"'       # Chèn lệnh qua Dấu chấm phẩy
    $'8.2.1\ntouch "$PROBE_FILE"\nWPTT_TRASH_ENABLE=0' # Chèn lệnh qua Ký tự xuống dòng
    "8.2.1'; touch \"\$PROBE_FILE\"; #" # Thoát Dấu nháy đơn
    '8.2.1"; touch "$PROBE_FILE"; #'   # Thoát Dấu nháy kép
    $'8.2.1\\\ntouch "$PROBE_FILE"'    # Chèn lệnh qua Dấu gạch chéo ngược (Escape)
    '8.2.1${UNSET_VARIABLE}'           # Khai thác gọi biến hệ thống
    $' 8.2.1\t\r\n'                    # Khai thác khoảng trắng và ký tự ẩn
    ''                                 # Bỏ trống biến (Null)
  )
  
  # Lặp qua từng viên đạn (mã độc) để bắn vào đoạn code của bác
  for payload in "${payloads[@]}"; do
    # Khởi tạo file cấu hình mẫu gốc
    printf 'WPTT_TRASH_ENABLE=1\nversion_wptangtoc_ols=0.0.1\n' > "$TEST_CONFIG"
    
    # Gán mã độc vào biến phiên bản
    export wptangtocols_version="$payload" version_wptangtoc_ols_rollback="$payload"
    
    # BƯỚC 1: Thực thi đoạn mã ghi file (Kiểm tra xem quá trình ghi có bị lỗi không)
    run bash -eu "$BATS_TEST_TMPDIR/write-config"
    [ "$status" -eq 0 ] # Phải chạy thành công (Exit 0)
    [ ! -e "$PROBE_FILE" ] # KHÔNG được phép tạo ra file "executed". Nếu có tức là Server đã bị hack!

    # BƯỚC 2: Gọi lệnh source lại file cấu hình (Kiểm tra xem lúc hệ thống đọc lại có bị kích nổ không)
    run bash -eu -c '
      . "$TEST_CONFIG"
      [[ "$version_wptangtoc_ols" == "$1" ]]
      [[ "$WPTT_TRASH_ENABLE" == 1 ]]
    ' bash "$payload"
    
    [ ! -e "$PROBE_FILE" ] # Vẫn không được phép tạo ra file bẫy "executed"
    [ "$status" -eq 0 ] # Lệnh source và so sánh phải chạy êm ái
  done
}

# ==============================================================================
# DANH SÁCH BÀI KIỂM THỬ (TEST CASES)
# Nếu đoạn mã nào của bác dùng printf '%q' chuẩn, bài test sẽ báo [OK] màu xanh.
# Nếu lỡ quên dùng echo, bài test sẽ báo [FAIL] màu đỏ và ngắt pipeline ngay.
# ==============================================================================

@test "Bảo mật cấu hình: File Ubuntu lưu biến an toàn, chống chèn mã độc" {
  check_writer wptangtoc-ols-ubuntu
}

@test "Bảo mật cấu hình: File AlmaLinux 8 lưu biến an toàn, chống chèn mã độc" {
  check_writer wptangtoc-ols-almalinux
}

@test "Bảo mật cấu hình: File AlmaLinux 9 lưu biến an toàn, chống chèn mã độc" {
  check_writer wptangtoc-ols-almalinux-9
}

@test "Bảo mật cấu hình: File AlmaLinux 10 lưu biến an toàn, chống chèn mã độc" {
  check_writer wptangtoc-ols-almalinux-10
}

@test "Bảo mật cấu hình: Script cập nhật tương tác (wptt-update) an toàn" {
  check_writer tool-wptangtoc-ols/wptt-update
}

@test "Bảo mật cấu hình: Script chuyển nhánh (wptt-update2) an toàn" {
  check_writer tool-wptangtoc-ols/wptt-update2
}

@test "Bảo mật cấu hình: Script tự động cập nhật (wptt-update-wptangtoc-ols) an toàn" {
  check_writer tool-wptangtoc-ols/wptt-update-wptangtoc-ols
}

@test "Bảo mật cấu hình: Script phục hồi (wptt-rollback-update-wptangtoc) an toàn" {
  check_writer tool-wptangtoc-ols/update/wptt-rollback-update-wptangtoc
}
