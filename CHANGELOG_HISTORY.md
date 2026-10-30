# WPTangToc OLS 8.3.2.4

🛠️ **Tối ưu hệ thống**
- **Cải tiến an toàn tệp cấu hình:** Nâng cấp cơ chế ghi và chỉnh sửa cấu hình hệ thống (httpd, vhost, MariaDB, PHP.ini) với tính năng bảo vệ toàn diện, đảm bảo dữ liệu không bị hỏng hóc hoặc mất mát ngay cả khi xảy ra sự cố gián đoạn nguồn điện đột ngột.
- **Kiểm tra tính hợp lệ trước khi khởi động dịch vụ:** Tự động kiểm tra kỹ lưỡng cú pháp và tính toàn vẹn của tệp cấu hình trước khi tiến hành khởi động lại các dịch vụ, giúp ngăn chặn triệt để tình trạng lỗi downtime hệ thống do cấu hình không hợp lệ.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
🛠️ Tối ưu hệ thống
- Nâng cấp công cụ giám sát tài nguyên `wtop` giúp theo dõi hệ thống trực quan và chính xác hơn.
- Cải thiện quy trình chuyển đổi phiên bản PHP, giúp thao tác mượt mà, nhanh chóng và ổn định hơn.
- Tối ưu hiệu năng tìm kiếm với cơ chế Debounce, giúp giảm tải tài nguyên và tăng tốc độ phản hồi cho máy chủ.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
# WPTangToc OLS 8.3.2.2

🛠️ **Tối ưu hệ thống**
- **Cải tiến hiệu năng tìm kiếm:** Tích hợp cơ chế debounce giúp tối ưu hóa tốc độ phản hồi và giảm tải tài nguyên hệ thống, mang lại trải nghiệm thao tác mượt mà và chính xác hơn cho quản trị viên.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
# WPTangToc OLS 8.3.2.1

🚀 **Tính năng mới & Cải tiến**
- Tích hợp cơ chế nhân Linux chuyên sâu chống DDoS, giúp bảo vệ webserver vững chắc trước các cuộc tấn công mạng quy mô lớn.
- Tinh chỉnh trải nghiệm dòng lệnh, bổ sung cơ chế xử lý chờ thông minh cho tính năng tìm kiếm (`search wptangtoc`) giúp thao tác của quản trị viên mượt mà và chính xác ngay cả khi dữ liệu chưa tải xong.

🛠️ **Tối ưu hệ thống**
- Tối ưu hóa hiệu năng nhân Linux chuyên sâu dành riêng cho các dòng máy chủ sử dụng vi xử lý AMD Ryzen, khai thác tối đa sức mạnh phần cứng.
- Nâng cấp thuật toán cân bằng tải NUMA, giúp cải thiện hiệu suất xử lý và phân phối tài nguyên trên hệ thống phần cứng đa socket.
- Cải tiến hệ thống tường lửa `nftables` với khả năng quản lý traffic đầu ra (output) chặt chẽ và tối ưu hóa mạng lưới tốt hơn.

🐛 **Sửa lỗi**
- Khắc phục triệt để lỗi xung đột thông báo trong quá trình chạy bộ cài đặt WPTangToc OLS.
- Sửa lỗi kiểm tra phiên bản `nftables` trong mô-đun quản lý dịch vụ, đảm bảo các service vận hành ổn định không bị gián đoạn.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## 📌 Lịch sử cập nhật WPTangToc OLS 8.3.2.1

- 6f7c65ab Cân bằng tải NUMA tối ưu
- 4361aab5 optimize kernel linux cho wptangtoc ols


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS v8.3.2.0

### 🚀 Tính năng mới
- **Tích hợp NFtables làm tường lửa mặc định:** Thay thế Firewalld bằng NFtables, mang lại hiệu năng xử lý mạng vượt trội, tăng cường bảo mật và tiết kiệm đáng kể tài nguyên hệ thống cho máy chủ.

### 🛠️ Tối ưu hệ thống
- **Cải tiến hệ thống tường lửa NFtables:** Nâng cao độ ổn định, tối ưu hóa khả năng lọc gói tin và vận hành mượt mà cho tường lửa mới.
- **Tối ưu cơ chế SSHGuard:** Nâng cấp tính năng quản lý và mở khóa IP, giúp quản trị viên xử lý linh hoạt, chính xác và nhanh chóng hơn đối với các địa chỉ IP bị chặn.
- **Bảo mật và ổn định phiên kết nối SSH:** Xử lý an toàn và tự động từ chối kết nối khi ngắt kết nối SSH đột ngột trong quá trình xác thực; vô hiệu hóa hiển thị ký tự (echo) và tự động làm sạch bộ đệm bàn phím trong thời gian chờ, ngăn chặn triệt để tình trạng nhập ký tự rác do thao tác vô ý.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
🛠️ Tối ưu hệ thống
- Xử lý an toàn và tự động từ chối kết nối khi ngắt kết nối SSH đột ngột trong quá trình xác thực, nâng cao tính bảo mật và ổn định.
- Vô hiệu hóa hiển thị ký tự (echo) và tự động làm sạch bộ đệm bàn phím trong thời gian chờ, ngăn chặn tình trạng nhập ký tự rác do vô tình thao tác.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## 📌 Lịch sử cập nhật WPTangToc OLS 8.3.2

- Không có thay đổi cụ thể nào được ghi nhận.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## 📌 Lịch sử cập nhật WPTangToc OLS 8.3.2

- Không có thay đổi cụ thể nào được ghi nhận.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS v8.3.2

### 🚀 Tính năng mới
- **Tích hợp NFtables mặc định:** Thay thế Firewalld bằng NFtables làm tường lửa mặc định, mang lại hiệu năng xử lý mạng vượt trội, tăng cường bảo mật và tiết kiệm đáng kể tài nguyên hệ thống cho máy chủ.

### 🛠️ Tối ưu hệ thống
- **Cải tiến NFtables:** Nâng cao độ ổn định, khả năng lọc gói tin và tối ưu hóa vận hành cho hệ thống tường lửa mới.
- **Cải thiện cơ chế SSHGuard:** Tối ưu hóa tính năng mở khóa IP với SSHGuard, giúp quản trị viên thao tác linh hoạt, chính xác và nhanh chóng hơn khi xử lý các địa chỉ IP bị chặn.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS 8.3.1

🛡️ **Bảo mật & Tối ưu hệ thống**
- **Tích hợp SSHGuard:** Bổ sung và thay thế hoàn hảo cho Fail2Ban bằng SSHGuard, giúp khắc phục triệt để các điểm yếu về hiệu suất và khả năng xử lý, mang lại lớp phòng thủ mạnh mẽ, ổn định và an toàn hơn trước các cuộc tấn công quét cổng, brute-force vào dịch vụ SSH.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS 8.3.0.2

🛠️ Tối ưu hệ thống:
- **Cải tiến tính năng sao chép website:** Tối ưu hóa toàn diện quy trình nhân bản dữ liệu, giúp thao tác sao chép website diễn ra nhanh chóng và ổn định hơn.
- **Tăng tốc quản lý extension PHP:** Rút ngắn đáng kể thời gian thêm mới hoặc gỡ bỏ các extension PHP, giúp quản trị viên tùy chỉnh môi trường máy chủ linh hoạt và tiết kiệm thời gian.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS 8.3.0.1

🚀 **Tính năng mới**
* **Nâng cấp WordPress Multisite:** Tối ưu hóa khả năng tương thích và quản lý cho hệ thống WordPress Multisite, giúp vận hành mượt mà và ổn định hơn.

🛠️ **Tối ưu hệ thống & Bảo mật**
* **Tương thích Python mới:** Cải tiến hệ thống Fail2Ban hoạt động hoàn hảo với Python từ phiên bản 3.11 trở lên.
* **Cải thiện quản lý IP:** Nâng cấp các tính năng khóa, mở khóa, liệt kê danh sách và gỡ chặn toàn bộ (unban all) đối với các IP độc hại, giúp quản trị viên kiểm soát bảo mật máy chủ nhanh chóng và chính xác hơn.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## Phiên bản 8.3.0.0

🚀 **Tính năng mới & Nâng cấp**
- **Đại tu và nâng cấp toàn diện WordPress Multisite:** Tối ưu hóa sâu sắc hệ thống quản lý và thiết lập mạng lưới website đa trang (WordPress Multisite) cho cả hai mô hình Subdomain và Sub-directory.
- **Tự động hóa cấu hình chuyên sâu:** Tự động thiết lập listener ký tự đại diện (wildcard listener) trên OpenLiteSpeed kết hợp tinh chỉnh quy tắc `.htaccess` chuẩn xác, giúp quản trị viên dễ dàng triển khai, mở rộng và vận hành hệ thống mạng lưới website một cách ổn định, an toàn và tối ưu hiệu suất tuyệt đối.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## Phiên bản 8.3.0

🚀 **Tính năng mới & Nâng cấp**
- **Đại tu hệ thống Preload Cache:** Nâng cấp toàn diện cơ chế nạp trước bộ nhớ đệm (Preload Cache) với hiệu năng vượt trội, giúp website WordPress tải nhanh chóng, tối ưu hóa tài nguyên máy chủ và mang lại trải nghiệm mượt mà cho người truy cập.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## Phiên bản 8.2.4.6

🐛 **Sửa lỗi**
- **Khắc phục lỗi kiểm tra Preload Cache:** Nâng cấp cơ chế kiểm tra và xử lý ngoại lệ trong tiến trình nạp trước bộ nhớ đệm, giúp hệ thống vận hành chính xác và ngăn ngừa triệt để các lỗi phát sinh trong quá trình quét dữ liệu.

🛠️ **Tối ưu hệ thống**
- **Cải tiến độ ổn định:** Tinh chỉnh các thuật toán kiểm tra lỗi và tối ưu hóa tiến trình nền, đảm bảo hiệu suất hoạt động liên tục, mượt mà và an toàn cho máy chủ.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## Phiên bản 8.2.4.5

🛠️ **Tối ưu hệ thống**
- **Cải tiến công cụ kiểm tra ổ cứng:** Nâng cấp tính năng kiểm tra và đánh giá trạng thái thiết bị lưu trữ, giúp quản trị viên theo dõi hiệu năng ổ đĩa chính xác và chủ động hơn trong việc bảo vệ dữ liệu hệ thống.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
### 🛠️ Tối ưu hệ thống
- **Nâng cấp công cụ kiểm tra tốc độ mạng:** Cải tiến và tối ưu hóa công cụ đo lường tốc độ kết nối internet trên máy chủ, giúp quản trị viên đánh giá nhanh chóng, chính xác và hiệu quả hơn băng thông mạng phục vụ hệ thống.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## Phiên bản 8.2.4.3

🛠️ **Tối ưu hệ thống & Quản trị**
- Tinh gọn và chuẩn hóa cơ chế kiểm tra trạng thái dịch vụ LiteSpeed Web Server (LSWS) và MariaDB, giúp tối ưu hóa tốc độ phản hồi và nâng cao độ ổn định của hệ thống.
- Cải tiến cấu trúc mã nguồn backend, giúp quản trị viên dễ dàng bảo trì và đảm bảo khả năng vận hành lâu dài cho máy chủ.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## Phiên bản 8.2.4.2

🛠️ **Tối ưu hệ thống & Trải nghiệm quản trị**
- Cải thiện cơ chế điều hướng, giúp thao tác quay trở lại menu chính mượt mà và trực quan hơn.
- Nâng cấp hệ thống báo lỗi chi tiết, giúp quản trị viên dễ dàng nhận diện và xử lý sự cố nhanh chóng.
- Tối ưu hóa cấu trúc mã nguồn, hỗ trợ việc bảo trì và phát triển tính năng ổn định hơn trong tương lai.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS 8.2.4.1

🛠️ Tối ưu hệ thống:
- Cải thiện cơ chế quản lý tiến trình shell (SHLVL), nâng cao độ ổn định và chính xác khi thực thi các tập lệnh hệ thống, giúp ngăn ngừa tình trạng lồng lặp tiến trình không mong muốn.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
