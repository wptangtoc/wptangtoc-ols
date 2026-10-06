# WPTangToc OLS v8.1.2.8

## 🚀 Tính năng mới & Bảo mật
- Tăng cường bảo mật toàn diện bằng cách tự động `unset` các biến môi trường nhạy cảm (`LD_PRELOAD`, `LD_LIBRARY_PATH`, `BASH_ENV`, `ENV`, `CDPATH`).
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
# WPTangToc OLS - Phiên bản 8.1.2.7

## 🚀 Tính năng mới
- **Chuẩn hóa hệ thống Logging & Output CLI:** Cải tiến và đồng bộ hóa cơ chế ghi system log cùng định dạng in log (print log) nhất quán trên giao diện dòng lệnh, giúp quản trị viên dễ dàng giám sát vận hành (monitoring) và truy vết sự cố (troubleshooting) chính xác hơn.

## 🛠️ Tối ưu hệ thống
- **Thắt chặt an ninh môi trường thực thi (Security Hardening):** Tự động dọn dẹp (`unset`) các biến môi trường nhạy cảm (`LD_PRELOAD`, `LD_LIBRARY_PATH`, `BASH_ENV`, `ENV`, `CDPATH`), triệt tiêu nguy cơ leo thang đặc quyền và tấn công can thiệp thư viện động (Shared Library Injection / Command Hijacking).
- **Tái cấu trúc luồng cài đặt OpenLiteSpeed (nhánh RedHat/AlmaLinux):** Loại bỏ phương thức tải và thực thi trực tiếp qua pipeline thiếu xác thực (`curl | bash`); chuyển đổi sang quy trình triển khai an toàn, bảo vệ tính toàn vẹn của hệ thống.
- **Tối ưu hóa mã nguồn lõi:** Cập nhật và tinh chỉnh các module vận hành nội bộ, gia tăng độ ổn định tổng thể cho bộ công cụ quản trị.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
