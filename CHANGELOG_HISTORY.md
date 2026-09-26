## WPTangToc OLS v8.1.3.0

### 🛠️ Tối ưu hệ thống
- **Nâng cấp cơ chế kiểm tra lỗi khi cập nhật Plugin WordPress:** Tăng độ chính xác trong việc phát hiện và xử lý sự cố phát sinh khi nâng cấp plugin, ngăn ngừa tình trạng treo tiến trình và giảm thiểu tối đa rủi ro gây gián đoạn hoạt động của website.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
# WPTangToc OLS v8.1.3

### 🛠️ Tối ưu hệ thống & Bảo mật
* **Cơ chế Atomic Delete cho LSCache:** Chuyển đổi sang phương thức xóa nguyên tử (atomic) khi dọn dẹp bộ nhớ đệm dung lượng lớn, loại bỏ hoàn toàn tình trạng nghẽn I/O (Disk I/O Spike) gây đơ máy chủ.
* **Tối ưu dọn dẹp Cache WordPress:** Tăng tốc quy trình xóa cache website mượt mà, hạn chế chiếm dụng tài nguyên hệ thống.
* **Khóa biến môi trường thực thi:** Tự động loại bỏ các biến nhạy cảm (`LD_PRELOAD`, `LD_LIBRARY_PATH`, `BASH_ENV`, `ENV`, `CDPATH`) nhằm ngăn chặn nguy cơ chèn mã độc và tấn công leo thang đặc quyền.
* **Bảo mật cài đặt OpenLiteSpeed (nhánh RHEL/AlmaLinux):** Loại bỏ cơ chế tải/thực thi shell trực tiếp (`curl | bash`), chuyển sang phương thức xác thực an toàn nhằm phòng chống giả mạo nguồn tải.
* **Chuẩn hóa System & Print Log:** Đồng bộ định dạng log hệ thống và giao diện hiển thị, giúp quản trị viên dễ dàng theo dõi trạng thái máy chủ cũng như xử lý sự cố (troubleshooting) nhanh chóng.

### 🐛 Sửa lỗi
* **Kiểm soát cấu hình PHP-CLI Domain:** Bổ sung cơ chế phát hiện và xử lý ngoại lệ cho `php-cli-domain-config`, tránh xung đột hoặc gián đoạn tiến trình khi cấu hình môi trường PHP riêng lẻ cho từng tên miền.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
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
