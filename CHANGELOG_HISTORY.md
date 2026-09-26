# WPTangToc OLS - Phiên bản 8.1.2.7

## 🚀 Tính năng mới
- **Chuẩn hóa hệ thống Logging:** Cải tiến và đồng bộ hóa cơ chế ghi system log cùng định dạng xuất log (print log) trực quan trên CLI, hỗ trợ quản trị viên giám sát trạng thái vận hành và truy vết sự cố chính xác hơn.

## 🛠️ Tối ưu hệ thống
- **Tăng cường an ninh môi trường thực thi (Hardening):** Tự động dọn dẹp (`unset`) các biến môi trường nhạy cảm (`LD_PRELOAD`, `LD_LIBRARY_PATH`, `BASH_ENV`, `ENV`, `CDPATH`), triệt tiêu các rủi ro leo thang đặc quyền và tấn công can thiệp thư viện động (DLL/Shared Library hijacking).
- **Tái cấu trúc luồng cài đặt OpenLiteSpeed (nhánh RedHat/AlmaLinux):** Loại bỏ phương thức thực thi trực tiếp `curl | bash` thiếu xác thực; chuyển sang quy trình triển khai an toàn, bảo vệ tính toàn vẹn của gói cài đặt trên hệ điều hành.
- **Đồng bộ hóa mã nguồn:** Cập nhật các module lõi nhằm đảm bảo tính ổn định và hiệu năng vận hành cho toàn bộ hệ thống.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
