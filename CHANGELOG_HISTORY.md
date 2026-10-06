## WPTangToc OLS v8.2.0.6

### 🛠️ Tối ưu hệ thống
- **Hoàn thiện cơ chế kiểm định và quản lý tên miền:** Nâng cấp hệ thống xác thực đầu vào, tự động chuẩn hóa định dạng ký tự và kiểm soát chặt chẽ xung đột tên miền, đảm bảo các thao tác quản trị website diễn ra mượt mà, an toàn và chính xác tuyệt đối.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS v8.2.0.5

### 🛠️ Tối ưu hệ thống
- **Nâng cao chất lượng và độ ổn định:** Hoàn thiện bộ kịch bản kiểm thử tự động, giúp kiểm soát chất lượng mã nguồn chặt chẽ hơn và đảm bảo các tiến trình hệ thống luôn vận hành ổn định, chính xác.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS v8.2.0.4

### 🛠️ Tối ưu hệ thống
- **Nâng cao độ ổn định khi tải lên qua Rclone:** Bổ sung cơ chế tự động thử lại (retry) thông minh và kiểm soát lỗi chặt chẽ hơn trong quá trình tải dữ liệu lên dịch vụ đám mây, đảm bảo các tác vụ sao lưu hoạt động liền mạch, không bị gián đoạn ngay cả khi đường truyền mạng chập chờn.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## [8.2.0.3]

### 🛠️ Tối ưu hệ thống
- **Cải tiến tiến trình tải xuống qua Rclone:** Tối ưu hóa tốc độ và độ ổn định khi tải dữ liệu từ các nền tảng lưu trữ đám mây, giúp các tác vụ sao lưu, khôi phục và đồng bộ website diễn ra mượt mà, nhanh chóng hơn.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## [8.2.0.2]

### 🛠️ Tối ưu hệ thống
- **Nâng cấp bộ lọc Smart Exclude thông minh:** Tích hợp đối chiếu checksum toàn diện qua WP-CLI cho Core, Plugins, Themes cùng nhận diện tệp ngôn ngữ (`.l10n.php`), giúp tự động bỏ qua tệp sạch và tập trung tối đa vào các tệp tin nghi vấn.
- **Tối ưu hóa đa luồng quét YARA:** Cải tiến tiến trình quét mã độc với cơ chế đa luồng kết hợp giới hạn mức ưu tiên tài nguyên thấp nhất (`nice` / `ionice`), đảm bảo máy chủ vận hành ổn định tuyệt đối, không gây chậm trễ hay quá tải CPU.
- **Hoàn thiện báo cáo tổng kết bảo mật:** Tinh chỉnh giao diện hiển thị kết quả kiểm tra mã độc toàn hệ thống, giúp quản trị viên dễ dàng nắm bắt trực quan trạng thái an toàn của từng website.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## [8.2.0.2]

### 🛠️ Tối ưu hệ thống
- **Nâng cấp bộ lọc Smart Exclude thông minh:** Tích hợp đối chiếu checksum toàn diện qua WP-CLI cho Core, Plugins, Themes cùng nhận diện tệp ngôn ngữ (`.l10n.php`), giúp tự động bỏ qua tệp sạch và tập trung tối đa vào các tệp tin nghi vấn.
- **Tối ưu hóa đa luồng quét YARA:** Cải tiến tiến trình quét mã độc với cơ chế đa luồng kết hợp giới hạn mức ưu tiên tài nguyên thấp nhất (`nice` / `ionice`), đảm bảo máy chủ vận hành ổn định tuyệt đối, không gây chậm trễ hay quá tải CPU.
- **Hoàn thiện báo cáo tổng kết bảo mật:** Tinh chỉnh giao diện hiển thị kết quả kiểm tra mã độc toàn hệ thống, giúp quản trị viên dễ dàng nắm bắt trực quan trạng thái an toàn của từng website.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## [8.2.0.1]

### 🛠️ Tối ưu hệ thống
- **Tối ưu hóa công cụ quét mã độc YARA:** Tinh chỉnh bộ quy tắc quét mã độc trên mã nguồn WordPress, giúp tăng tốc độ rà soát webshell/backdoor và tiết kiệm tối đa tài nguyên CPU/RAM khi chạy định kỳ.
- **Cải thiện độ ổn định hệ thống:** Nâng cấp cơ chế xử lý ngoại lệ trong các tiến trình tự động hóa, đảm bảo các tác vụ quản trị máy chủ vận hành mượt mà và an toàn tuyệt đối.

### 🐛 Sửa lỗi
- **Khắc phục lỗi quét mã nguồn:** Xử lý triệt để sự cố xung đột quyền hạn khi tiến hành rà soát các tệp tin có cấu trúc bảo mật đặc thù trên môi trường Chroot, giúp quá trình kiểm tra bảo mật diễn ra hoàn toàn trơn tru.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
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
