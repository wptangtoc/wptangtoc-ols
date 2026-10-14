## WPTangToc OLS 8.2.3.3

🐛 **Sửa lỗi**
- Khắc phục các lỗi phát sinh trên hệ thống, nâng cao độ ổn định và an toàn khi vận hành máy chủ.

🛠️ **Tối ưu hệ thống**
- Cải tiến và chuẩn hóa biểu thức chính quy (regex) xử lý phần mở rộng tệp tin, giúp hệ thống hoạt động hiệu quả hơn và dễ dàng bảo trì, mở rộng trong tương lai.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS 8.2.3.2

🛠️ **Tối ưu hệ thống**
- Tối ưu thứ tự `indexFiles` ưu tiên `index.php` cho WordPress, giúp giảm lượt gọi hệ thống (`stat() syscall`) và tăng tốc độ phản hồi của OpenLiteSpeed.
- Tinh chỉnh cấu hình PHP mặc định bằng cách chuyển sang sử dụng thư viện `GD` thay vì `Imagick`, giúp tiết kiệm tài nguyên và tăng hiệu năng tổng thể; đồng thời cho phép quản trị viên chủ động cài đặt lại `Imagick` khi có nhu cầu chuyên biệt.

🐛 **Sửa lỗi**
- Khắc phục các vấn đề tương thích extension PHP, giúp hệ thống vận hành ổn định và tối ưu hơn trên các kiến trúc ARM, AlmaLinux 10 và RedHat 10.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS 8.2.3.1

🛠️ Tối ưu hệ thống:
- Tinh chỉnh và tối ưu hóa hiệu năng, giúp vận hành mượt mà và ổn định trên các máy chủ ảo (VPS) có dung lượng RAM nhỏ (512MB).
- Bổ sung cơ chế tự động chuyển đổi dự phòng sang cổng 443, đảm bảo kết nối luôn thông suốt và không bị gián đoạn.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
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
