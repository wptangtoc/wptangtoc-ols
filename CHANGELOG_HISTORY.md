## [8.2.0.0]

### 🛠️ Tối ưu hệ thống
- **Nâng cấp công cụ quét mã độc WordPress (Chuyển sang YARA):** Thay thế engine ClamAV bằng YARA với bộ quy tắc chuyên sâu dành riêng cho mã nguồn WordPress, giúp tăng tốc độ quét, nâng cao độ chính xác khi phát hiện webshell/backdoor và tiết kiệm đáng kể tài nguyên RAM, CPU cho máy chủ.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## [8.2.0]

### 🛠️ Tối ưu hệ thống
- **Nâng cấp công cụ quét mã độc WordPress (Chuyển sang YARA):** Thay thế engine ClamAV bằng YARA với bộ quy tắc chuyên sâu cho mã nguồn WordPress, giúp tăng tốc độ quét, nâng cao độ chính xác khi phát hiện webshell/backdoor và tiết kiệm đáng kể tài nguyên RAM, CPU cho máy chủ.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## [8.1.4.6]

### 🛠️ Tối ưu hệ thống
- **Nâng cấp cơ chế cập nhật hệ thống:** Tinh chỉnh quy trình nâng cấp phần mềm, đảm bảo quá trình update diễn ra an toàn, mượt mà và hạn chế tối đa rủi ro gián đoạn dịch vụ.
- **Tối ưu kiểm tra kết nối mạng (Ping):** Cải tiến công cụ kiểm tra ping internet, giúp đo lường độ trễ mạng chính xác và ổn định hơn trong quá trình vận hành máy chủ.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## [8.1.4.5]

### 🛠️ Tối ưu hệ thống
- **Tăng cường bảo mật Rclone:** Nâng cấp cơ chế xác thực và mã hóa thông tin kết nối, đảm bảo dữ liệu sao lưu đám mây luôn an toàn tuyệt đối.

### 🐛 Sửa lỗi
- **Sao lưu đám mây S3:** Khắc phục lỗi kết nối và đồng bộ dữ liệu tới các dịch vụ lưu trữ tương thích S3 (AWS S3, Cloudflare R2, Wasabi...), giúp tiến trình backup tự động vận hành ổn định và chính xác.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## 📌 Lịch sử cập nhật WPTangToc OLS 8.1.4.4

- 71c1797a cải tiến bảo mật


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## [8.1.4.3]

### 🛠️ Tối ưu hệ thống
- **Nâng cấp công cụ chẩn đoán:** Tối ưu hóa cơ chế rà soát và kiểm tra lỗi hệ thống, giúp quản trị viên phát hiện sớm các sự cố tiềm ẩn và định vị nguyên nhân chính xác, nhanh chóng hơn.
- **Cải thiện tiện ích kiểm tra mạng (Ping):** Tinh chỉnh công cụ đo độ trễ mạng; xử lý tín hiệu dừng lệnh (`Ctrl + C`) mượt mà và hiển thị thông số thống kê trực quan, sạch đẹp, loại bỏ hoàn toàn các đoạn mã lỗi thô trên màn hình terminal.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS v8.1.4.2

### 🛠️ Tối ưu hệ thống
- **Cảnh báo mở port Cloud Firewall cho WebAdmin:** Nâng cấp cơ chế chẩn đoán truy cập WebAdmin, tự động phát hiện và thông báo mở cổng dịch vụ trên tường lửa đám mây (Cloud Firewall / Security Group) khi gặp sự cố kết nối, giúp quản trị viên xử lý nhanh lỗi chặn truy cập.
- **Cải tiến quy trình kiểm tra kết nối mạng:** Tự động kiểm tra và xác thực các thư viện Python cần thiết trước khi ping internet, đảm bảo quá trình chẩn đoán môi trường mạng diễn ra ổn định, chính xác và không bị lỗi phụ thuộc.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS 8.1.4.1

### 🐛 Sửa lỗi
- **Kiểm tra tính toàn vẹn mã nguồn WordPress:** Tăng cường cơ chế xác thực gói dữ liệu khi tải về, chủ động phát hiện và xử lý lỗi giải nén do đường truyền mạng chập chờn hoặc tải thiếu file.

### 🛠️ Tối ưu hệ thống
- **Tinh gọn lịch sử thay đổi (Changelog History):** Tối ưu hóa dung lượng lưu trữ bằng cách duy trì 10 phiên bản phát hành gần nhất, giúp việc tra cứu thông tin nhanh chóng và thuận tiện hơn.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
# WPTangToc OLS v8.1.4.0

### 🚀 Tính năng mới
- **Hỗ trợ trở lại AlmaLinux 10:** Khôi phục khả năng tương thích toàn diện với AlmaLinux 10, giúp quản trị viên tự tin triển khai hệ thống trên nền tảng hệ điều hành thế hệ mới nhất.

### 🐛 Sửa lỗi
- **Khắc phục lỗi thư viện Certbot:** Xử lý triệt để xung đột phụ thuộc gói của Certbot, đảm bảo quy trình cấp phát và tự động gia hạn chứng chỉ SSL/TLS Let's Encrypt luôn hoạt động ổn định, không bị gián đoạn.

### 🛠️ Tối ưu hệ thống
- **Tối ưu hóa bộ cài đặt:** Tinh chỉnh luồng kịch bản cài đặt tự động, giúp rút ngắn thời gian thiết lập máy chủ và loại bỏ triệt để nguy cơ xung đột gói phần mềm trong quá trình khởi tạo.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
# WPTangToc OLS v8.1.4.0

### 🚀 Tính năng mới
- **Hỗ trợ trở lại AlmaLinux 10:** Khôi phục khả năng tương thích toàn diện với nền tảng AlmaLinux 10, giúp quản trị viên tự tin triển khai hệ thống trên phiên bản hệ điều hành thế hệ mới.

### 🐛 Sửa lỗi
- **Khắc phục lỗi thư viện Certbot:** Xử lý triệt để sự cố phụ thuộc gói của Certbot trên môi trường mới, đảm bảo tính năng cấp phát và tự động gia hạn chứng chỉ bảo mật SSL/TLS hoạt động hoàn toàn ổn định.

### 🛠️ Tối ưu hệ thống
- **Nâng cấp bộ cài đặt:** Tinh chỉnh và tối ưu hóa luồng kịch bản cài đặt tự động, giúp rút ngắn thời gian khởi tạo và hạn chế tối đa nguy cơ xung đột gói phần mềm.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
# WPTangToc OLS v8.1.4

### 🛠️ Tối ưu hệ thống
* **Tái cấu trúc bộ cài đặt tiêu chuẩn:** Tối ưu và chuẩn hóa toàn bộ kịch bản cài đặt theo kiến trúc mới, nâng cao tiêu chuẩn bảo mật, gia tăng độ ổn định và giúp quá trình thiết lập máy chủ diễn ra nhanh chóng, mượt mà hơn.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
