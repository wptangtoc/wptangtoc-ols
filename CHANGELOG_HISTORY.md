## 🔖 WPTangToc OLS v8.1.2.9 Release Notes

Bản phát hành **WPTangToc OLS v8.1.2.9** tập trung vào việc gia cố bảo mật môi trường thực thi, chuẩn hóa cơ chế ghi log hệ thống và tối ưu hóa hiệu năng xử lý cache cho WordPress.

---

### 🚀 Tính năng & Cải tiến

* **Tối ưu cơ chế xóa Cache WordPress:** Cải tiến thuật toán dọn dẹp và purge cache WordPress, đảm bảo xóa sạch dữ liệu đệm nhanh chóng mà không gây nghẽn I/O hay ảnh hưởng đến tài nguyên máy chủ.
* **Chuẩn hóa System & Output Log:** Nâng cấp cấu trúc in log theo chuẩn tập trung, giúp quản trị viên dễ dàng theo dõi, trích xuất dữ liệu và giám sát trạng thái vận hành của hệ thống.

---

### 🛠️ Tối ưu hệ thống & Bảo mật

* **Tăng cường bảo mật môi trường thực thi (Hardening Shell Environment):** Tự động `unset` các biến môi trường nhạy cảm (`LD_PRELOAD`, `LD_LIBRARY_PATH`, `BASH_ENV`, `ENV`, `CDPATH`) trước khi chạy script, ngăn chặn nguy cơ tấn công chèn thư viện độc hại (DLL/SO hijacking) và leo thang đặc quyền.
* **Cải tiến quy trình cài đặt OpenLiteSpeed (RHEL/AlmaLinux):** Chuyển đổi phương thức tải và cài đặt thay thế cho cơ chế `curl | bash` trực tiếp không xác thực, nâng cao độ an toàn và tính toàn vẹn gói cài đặt trên các bản phân phối họ RedHat.

---

### 🐛 Sửa lỗi

* **Kiểm tra cấu hình PHP-CLI:** Nâng cấp và sửa lỗi bộ kiểm tra `php-cli-domain-config`, khắc phục triệt để các xung đột môi trường CLI giữa các domain và phiên bản PHP khác nhau.

---

### 📦 Hướng dẫn cập nhật

Chạy lệnh sau trên terminal với quyền `root` để nâng cấp lên phiên bản mới nhất:

```bash
wptt
```
*(Chọn mục **Cập nhật hệ thống** để hoàn tất quá trình nâng cấp).*


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
# WPTangToc OLS v8.1.2.8

## 🚀 Tính năng mới & Bảo mật
- Nâng cao bảo mật và tối ưu hóa quy trình cài đặt/thực thi OpenLiteSpeed qua `curl | bash`, cải tiến tốt hơn đặc biệt cho nhánh RedHat.

## 🛠️ Tối ưu hệ thống & Sửa lỗi
- Chuẩn hóa hệ thống `system log` và định dạng log của WPTangToc OLS giúp quản lý và theo dõi dễ dàng hơn.
- Cải tiến cơ chế kiểm tra lỗi cấu hình `php-cli-domain-config`.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
# WPTangToc OLS - Phiên bản 8.1.2.7

## 🚀 Tính năng mới
- **Chuẩn hóa hệ thống Logging:** Cải tiến và đồng bộ hóa cơ chế ghi system log cùng định dạng xuất log (print log) trực quan trên CLI, hỗ trợ quản trị viên giám sát trạng thái vận hành và truy vết sự cố chính xác hơn.

## 🛠️ Tối ưu hệ thống
- **Tăng cường an ninh môi trường thực thi (Hardening):** Tự động dọn dẹp (`unset`) các biến môi trường nhạy cảm (`LD_PRELOAD`, `LD_LIBRARY_PATH`, `BASH_ENV`, `ENV`, `CDPATH`), triệt tiêu các rủi ro leo thang đặc quyền và tấn công can thiệp thư viện động (DLL/Shared Library hijacking).
- **Tái cấu trúc luồng cài đặt OpenLiteSpeed (nhánh RedHat/AlmaLinux):** Loại bỏ phương thức thực thi trực tiếp `curl | bash` thiếu xác thực; chuyển sang quy trình triển khai an toàn, bảo vệ tính toàn vẹn của gói cài đặt trên hệ điều hành.
- **Đồng bộ hóa mã nguồn:** Cập nhật các module lõi nhằm đảm bảo tính ổn định và hiệu năng vận hành cho toàn bộ hệ thống.


---

*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
