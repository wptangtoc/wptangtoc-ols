#!/usr/bin/env bats

setup() {
  # BATS sẽ lấy thẳng file mã nguồn MỚI NHẤT mà bác vừa push lên nhánh để test
  export SCRIPT_GOC="/etc/wptt/domain/wptt-themwebsite"
  chmod +x "$SCRIPT_GOC"
}

# =================================================================
# NHÓM 1: KIỂM THỬ BỘ LỌC ĐẦU VÀO (VALIDATION)
# =================================================================

@test "Integration: Chặn Tên miền thiếu dấu chấm" {
  run bash "$SCRIPT_GOC" "wptangtoc"
  
  [ "$status" -eq 1 ]
  # SỬA Ở ĐÂY: Tìm chữ "đúng định dạng" thay vì "thiếu dấu chấm"
  [[ "$output" =~ "đúng định dạng" ]]
}


@test "Integration: Chặn Tên miền chứa ký tự đặc biệt" {
  run bash "$SCRIPT_GOC" "wptangtoc@.com"
  
  [ "$status" -eq 1 ]
  [[ "$output" =~ "sai cấu trúc" ]]
}

@test "Integration: Tự động làm sạch khoảng trắng (CRLF, Space)" {
  # Cố tình truyền vào một domain rác rưởi để xem kịch bản có tự dọn dẹp và chạy tiếp được không
  # Vì kịch bản sẽ chạy thật nên ta dùng tên miền test1
  run bash "$SCRIPT_GOC" "   test-sach-khoang-trang.com  "
  
  # Lệnh phải chạy thành công (0)
  [ "$status" -eq 0 ]
  
  # Kiểm chứng xem nó có tạo ra thư mục đúng chuẩn tên miền đã làm sạch chưa
  [ -d "/usr/local/lsws/test-sach-khoang-trang.com" ]
}

# =================================================================
# NHÓM 2: KIỂM THỬ THỰC CHIẾN TRÊN HỆ THỐNG THẬT (MÔI TRƯỜNG OLS)
# =================================================================

@test "Integration: CHẶN THÀNH CÔNG Domain đã tồn tại (Trùng Domain chính)" {
  # Ở bước Khởi tạo CI/CD, ta đã ép hệ thống cài đặt domain chính là "wptangtoc.com"
  # Bây giờ BATS thò tay thêm nó một lần nữa, hệ thống PHẢI phát hiện ra và chặn lại!
  run bash "$SCRIPT_GOC" "gihub.wptangtoc.com"
  
  [ "$status" -eq 1 ]
  [[ "$output" =~ "tồn tại trên hệ thống" ]]
}

@test "Integration: THÊM MỚI THÀNH CÔNG một Website thật" {
  # Gọi kịch bản để tạo một website hoàn toàn mới
  run bash "$SCRIPT_GOC" "khachhang-demo.com"
  
  # 1. Kịch bản phải chạy thành công không văng lỗi
  [ "$status" -eq 0 ]
  
  # 2. KIỂM CHỨNG MÁY CHỦ: File cấu hình Vhost ĐÃ TỒN TẠI chưa?
  [ -f "/usr/local/lsws/conf/vhosts/khachhang-demo.com/khachhang-demo.com.conf" ]
  
  # 3. KIỂM CHỨNG MÁY CHỦ: Thư mục Home của user ĐÃ TỒN TẠI chưa?
  [ -d "/usr/local/lsws/khachhang-demo.com/html" ]
  
  # 4. KIỂM CHỨNG OLS: Domain mới đã được chèn vào file httpd_config.conf chính chưa?
  run grep "khachhang-demo.com" /usr/local/lsws/conf/httpd_config.conf
  [ "$status" -eq 0 ]
}
