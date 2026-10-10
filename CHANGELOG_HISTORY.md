## WPTangToc OLS 8.2.2.1

🛠️ Tối ưu hệ thống
- Tối ưu hóa cơ chế chứng chỉ SSL dự phòng trên cổng 443 với thời hạn 10 năm, giúp đảm bảo kết nối ổn định và liền mạch cho máy chủ trong trường hợp chưa cấu hình SSL chính thức.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
# WPTangToc OLS 8.2.1.9

### 🛠️ Tối ưu hệ thống

- **Cơ chế hoàn tác (Rollback) an toàn khi đổi cổng SSH:** Bổ sung khả năng tự động khôi phục cổng kết nối ban đầu nếu tiến trình thay đổi gặp lỗi, loại bỏ hoàn toàn rủi ro quản trị viên bị mất kết nối hoặc bị khóa ngoài máy chủ (server lockout).
- **Tăng cường bảo mật SSL cho WordPress Multisite:** Cải tiến quy trình cấp phát và thiết lập chứng chỉ SSL cho mô hình mạng đa trang (Multisite), đảm bảo kết nối mã hóa HTTPS chuẩn xác, ngăn ngừa rủi ro xung đột chứng chỉ và thắt chặt an toàn dữ liệu giữa các subsite.
- **Tối ưu hóa cấu hình SSH và tường lửa CSF:** Chuẩn hóa tệp cấu hình SSH kết hợp nâng cấp khả năng tương thích với tường lửa ConfigServer Security & Firewall (CSF), giúp siết chặt an ninh truy cập từ xa và chống dò quét cổng trái phép hiệu quả hơn.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
# WPTangToc OLS 8.2.1.8

### 🛠️ Tối ưu hệ thống

- **Cơ chế ghi cấu hình nguyên tử (Atomic Writes):** Áp dụng ghi file cấu hình nguyên tử toàn diện cho máy chủ web (`httpd_config`) và hệ thống quản trị WPTT, loại bỏ hoàn toàn rủi ro file cấu hình bị hỏng hoặc mất dữ liệu khi xảy ra sự cố gián đoạn đột ngột (mất điện, kill tiến trình).
- **Nâng cao tính toàn vẹn và ổn định:** Tối ưu hóa chu trình lưu và đồng bộ cấu hình WPTT (v3), đảm bảo trạng thái dịch vụ luôn nhất quán và vận hành an toàn tuyệt đối trong quá trình cập nhật.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## Phiên bản 8.2.1.7

### 🛠️ Tối ưu hệ thống
- **Tối ưu bộ cài đặt trên Ubuntu:** Nâng cấp cơ chế cấu hình và nạp kho lưu trữ (repository) LiteSpeed, giúp quá trình triển khai máy chủ diễn ra nhanh chóng, ổn định và tránh lỗi thiếu phụ thuộc khi cài đặt.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS v8.2.1.6

### 🛠️ Tối ưu hệ thống
- **Tăng cường độ tin cậy cho tính năng Preload Cache:** Chuẩn hóa và tự động hóa quy trình kiểm chuẩn cơ chế nạp trước bộ nhớ đệm (Preload Cache), đảm bảo quá trình quét sitemap và kích hoạt cache luôn vận hành chính xác, giúp website đạt tốc độ tải trang tối đa ngay khi có lượt truy cập mới.
- **Củng cố độ ổn định cho tiến trình cập nhật:** Nâng cấp bộ kiểm thử tích hợp cho cơ chế nâng cấp hệ thống (WPTT Update), đảm bảo tính toàn vẹn của tệp cấu hình máy chủ và ngăn ngừa rủi ro gián đoạn dịch vụ trong suốt quá trình cập nhật phiên bản.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS v8.2.1.5

### 🐛 Sửa lỗi
- **Khắc phục lỗi chuyển hướng 301:** Xử lý triệt để lỗi liên quan đến quy tắc chuyển hướng 301, đảm bảo các cấu hình điều hướng URL hoạt động chính xác và ổn định.

### 🛠️ Tối ưu hệ thống
- **Nâng cao tương thích ảo hóa và namespace OpenLiteSpeed:** Tối ưu hóa cơ chế vận hành trên các môi trường ảo hóa giá rẻ và namespace OLS, giúp máy chủ duy trì sự ổn định và hiệu suất cao.
- **Cải tiến quy trình cập nhật và Bootstrapper:** Nâng cấp độ tin cậy của cơ chế nâng cấp phần mềm và trình khởi động hệ thống, đảm bảo tiến trình cập nhật diễn ra an toàn và mượt mà.

---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS v8.2.1.5

### 🛠️ Tối ưu hệ thống
- **Nâng cao độ tin cậy khi chuyển đổi nhánh cập nhật:** Hoàn thiện quy chuẩn kiểm thử tự động cho cơ chế chuyển đổi qua lại giữa các nhánh phiên bản (chính thức, thử nghiệm), đảm bảo tiến trình nâng cấp và chuyển nhánh luôn diễn ra an toàn, mượt mà và duy trì tính toàn vẹn dữ liệu máy chủ.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS v8.2.1.4

### 🚀 Tính năng mới
- **Hỗ trợ kiến trúc ARM trên Rocky Linux 10:** Bổ sung khả năng tương thích toàn diện cho nền tảng vi xử lý ARM (aarch64) chạy hệ điều hành Rocky Linux 10, mang lại sự linh hoạt tối đa cho quản trị viên khi triển khai máy chủ thế hệ mới với hiệu năng cao và chi phí vận hành tối ưu.

### 🛠️ Tối ưu hệ thống
- **Nâng cấp và tinh gọn tường lửa ModSecurity (WAF):** Cập nhật bộ quy tắc bảo mật ứng dụng web mới nhất, đồng thời tối ưu hóa cơ chế nạp luật bằng cách loại bỏ các quy tắc không cần thiết ngoài môi trường Linux/PHP. Giúp gia tăng sức mạnh phòng thủ trước các cuộc tấn công web phổ biến (SQL Injection, XSS...) mà vẫn đảm bảo website tải nhanh, tiết kiệm tài nguyên CPU và RAM.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS v8.2.1.3

### 🛠️ Tối ưu hệ thống
- **Tối ưu tốc độ cài đặt WordPress với Local Cache:** Tích hợp cơ chế lưu bộ nhớ đệm cục bộ (local cache) cho gói mã nguồn tải từ WordPress.org kèm tính năng tự động xác thực toàn vẹn dữ liệu. Giúp rút ngắn tối đa thời gian khởi tạo website mới, tiết kiệm băng thông máy chủ và đảm bảo quá trình cài đặt luôn diễn ra liền mạch ngay cả khi đường truyền quốc tế gặp sự cố.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
