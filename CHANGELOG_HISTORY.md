## WPTangToc OLS 8.2.3.0

🚀 **Tính năng mới**
- Bổ sung hỗ trợ toàn diện các định dạng chứng chỉ SSL trả phí (gồm **ECDSA**, **RSA 2048**, và **RSA 4096**), mang lại sự linh hoạt tối đa trong việc lựa chọn chuẩn mã hóa bảo mật theo nhu cầu doanh nghiệp.

🛠️ **Tối ưu hệ thống**
- Nâng cao khả năng tương thích với các môi trường ảo hóa một phần (partial virtualization), giúp hệ thống vận hành ổn định và tối ưu hóa tài nguyên trên các hạ tầng máy chủ ảo giá rẻ.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS v8.2.3

🚀 **Tính năng mới**
- Chuyển đổi thuật toán mã hóa SSL sang **ECDSA**, giúp tăng tốc độ bắt tay kết nối (handshake) bảo mật, tiết kiệm tài nguyên CPU và tối ưu hóa trải nghiệm truy cập.

🛠️ **Tối ưu hệ thống**
- Cải tiến hiệu suất chuyển hướng HTTP sang HTTPS, giảm thiểu đáng kể I/O và tải CPU, giúp máy chủ trả về phản hồi `301 Redirect` nhanh chóng hơn.

🐛 **Sửa lỗi**
- Bổ sung cơ chế kiểm tra phòng thủ khi cài đặt SSL nhằm ngăn chặn lỗi phát sinh trong trường hợp danh sách tên miền trống hoặc không hợp lệ qua bộ lọc, giúp hệ thống vận hành ổn định và an toàn hơn.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
### 🐛 Sửa lỗi
- Vá lỗi bảo mật liên quan đến tính năng quản lý tên miền phụ (`wptt-alias-domain`), nâng cao độ an toàn cho hệ thống.
- Khắc phục triệt để lỗi tương thích của thư viện kiểm tra SSL, giúp quá trình xác thực chứng chỉ hoạt động ổn định và chính xác.

### 🛠️ Tối ưu hệ thống
- Tự động nhận diện và thích ứng linh hoạt với sự thay đổi cấu hình mạng IPv4/IPv6 (chuyển đổi giữa Dual-stack và Single-stack) từ template VPS của nhà cung cấp.
- Nâng cấp cơ chế đồng bộ thời gian hệ thống thông qua dịch vụ Chrony, đảm bảo độ chính xác cao cho các tác vụ lập lịch và bảo mật.
- Tối ưu hiệu năng bằng cách lược bỏ cơ chế khóa (locking) đối với các tác vụ thực thi ngắn, giúp giảm độ trễ và tối ưu tài nguyên máy chủ.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS 8.2.2.5

🐛 Sửa lỗi
- Khắc phục triệt để lỗi tương thích với thư viện kiểm tra SSL mới, đảm bảo quá trình kiểm tra và cấp phát chứng chỉ hoạt động ổn định, không bị gián đoạn.
- Vá các lỗ hổng bảo mật và nâng cao độ an toàn cho hệ thống quản lý tên miền phụ (`wptt-alias-domain`).

🛠️ Tối ưu hệ thống
- Nâng cấp cơ chế nhận diện mạng thông minh, tự động thích ứng với các thay đổi cấu hình mạng (chuyển đổi linh hoạt giữa IPv4, IPv6 hoặc dual-stack) từ phía nhà cung cấp VPS hoặc người dùng, giúp máy chủ luôn vận hành trơn tru trong mọi tình huống triển khai.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS 8.2.2.4

### 🚀 Tính năng mới
- **Cải tiến quản lý Alias Domain:** Nâng cấp cơ chế xử lý và nhận diện tên miền phụ (alias domain), giúp hệ thống liên kết và quản lý đa tên miền linh hoạt, chính xác hơn.

### 🛠️ Tối ưu hệ thống
- **Tối ưu cơ chế xử lý biểu thức chính quy (Regex):** Cải tiến phương thức thay thế và ánh xạ cấu hình bằng regex an toàn tuyệt đối, giúp ngăn chặn triệt để rủi ro xung đột chuỗi hoặc ghi nhầm dữ liệu trong quá trình vận hành tự động.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS 8.2.2.3

### 🛠️ Tối ưu hệ thống
- **Nâng cấp hàng đợi thêm tài khoản thông minh (Smart Username Queue):** Bổ sung cơ chế tự động xử lý và phục hồi an toàn khi xảy ra sự cố mất điện đột ngột hoặc ngắt kết nối giữa chừng, đảm bảo toàn vẹn dữ liệu và nâng cao độ ổn định cho hệ thống máy chủ.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS v8.2.2.2

🛠️ Tối ưu hệ thống:
- Nâng cấp cơ chế ghi file cấu hình theo phương thức atomic, giúp bảo vệ dữ liệu an toàn và ngăn ngừa triệt để tình trạng hỏng file khi máy chủ gặp sự cố đột ngột (như mất điện) trong quá trình chỉnh sửa.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
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
