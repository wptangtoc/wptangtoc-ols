## 🚀 Phiên bản 8.4.2.1

### 🛠️ Tối ưu hệ thống
- Nâng cấp và cải tiến cơ chế kết nối Redis Cache, giúp tăng tốc độ phản hồi và duy trì sự ổn định tối đa cho hệ thống dưới tải cao.
- Bổ sung hệ thống cảnh báo thông minh khi VPS vận hành trên 10 website có sử dụng chế độ relay, giúp quản trị viên chủ động điều chỉnh cấu hình để đạt hiệu năng tốt nhất.

### 🐛 Sửa lỗi
- Vá lỗ hổng bảo mật liên quan đến việc xử lý tệp tạm của `/etc/fstab` (CWE-377).
- Khắc phục sự cố tiềm ẩn gây trống tệp `fstab` khi kích hoạt tính năng `disk_noatime`.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*


---

## 🚀 Phiên bản 8.4.2.0

## 🚀 Tính năng mới
- **Tích hợp extension Relay**: Nâng cấp hiệu năng xử lý cache vượt trội cho Valkey, Redis và KeyDB, giúp tăng tốc độ truy vấn dữ liệu và giảm tải tài nguyên cho máy chủ.

## 🐛 Sửa lỗi
- **Khắc phục lỗi xung đột câu lệnh Terminal**: Sửa triệt để lỗi gõ các lệnh hệ thống thông thường (ví dụ: `ip a`) bị chuyển hướng nhầm thành lệnh quản trị WPTangToc, giúp quản trị viên thao tác dòng lệnh chính xác và không bị gián đoạn.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*


---

## 🚀 Tính năng mới
- **Tích hợp extension Relay**: Nâng cấp hiệu năng xử lý cache vượt trội cho Valkey, Redis và KeyDB, giúp tăng tốc độ truy vấn dữ liệu và giảm tải tài nguyên cho máy chủ.

## 🐛 Sửa lỗi
- **Khắc phục lỗi xung đột câu lệnh Terminal**: Sửa triệt để lỗi gõ các lệnh hệ thống thông thường (ví dụ: `ip a`) bị chuyển hướng nhầm thành lệnh quản trị WPTangToc, giúp quản trị viên thao tác dòng lệnh chính xác và không bị gián đoạn.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## 🚀 Phiên bản 8.4.1.9

### 🛠️ Tối ưu hệ thống & Điều hướng
- **Nâng cấp bảo mật và ổn định menu:** Loại bỏ việc sử dụng thư mục tạm `/dev/shm` nhằm tăng cường bảo mật hệ thống và cải thiện độ mượt mà khi thao tác.
- **Cải thiện trải nghiệm điều hướng:** Hỗ trợ phím `ESC` giúp quản trị viên dễ dàng thoát menu linh hoạt và trực quan hơn.
- **Khắc phục lỗi nhập liệu tốc độ cao:** Xử lý triệt để tình trạng rớt phím khi thao tác nhanh trong quá trình gửi nhịp tim DSR.
- **Tối ưu cơ chế DSR Heartbeat:** Đảm bảo nhịp tim DSR luôn hoạt động ổn định, ngăn chặn hoàn toàn nguy cơ lặp vô hạn (infinite loop) bất kể cấu trúc phân cấp shell (`SHLVL`) của môi trường phức tạp đến đâu.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS v8.4.1.8

🛠️ Tối ưu hệ thống
- Nâng cấp toàn diện tính năng bật/tắt XML-RPC trên WordPress với cơ chế bảo mật 2 lớp (chặn đồng thời ở cấp độ máy chủ web và PHP), giúp ngăn chặn triệt để các cuộc tấn công brute-force, khai thác lỗ hổng và tối ưu hóa tài nguyên hệ thống.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## 🚀 Tính năng mới
- **Hỗ trợ PHP 8.6:** Cập nhật khả năng tương thích hoàn chỉnh với PHP 8.6, giúp quản trị viên dễ dàng cài đặt và vận hành website WordPress trên nền tảng PHP mới nhất với hiệu suất tối ưu.

## 🛠️ Tối ưu hệ thống
- **Cải tiến ZRAM trên AWS:** Tinh chỉnh cơ chế tối ưu hóa bộ nhớ ảo ZRAM, nâng cao độ ổn định và khả năng tương thích tuyệt đối khi triển khai trên các template máy chủ của Amazon Web Services (AWS).


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS 8.4.1.6

🚀 **Tính năng mới**
- **Nâng cấp toàn diện công cụ quản lý và cập nhật mã nguồn WordPress:** Cải tiến mạnh mẽ các tính năng cập nhật Core WordPress, Plugin và Theme, đồng thời bổ sung khả năng hạ cấp phiên bản WordPress Core, cài đặt lại Core và cài đặt lại toàn bộ WordPress một cách nhanh chóng, an toàn và chính xác, giúp quản trị viên chủ động hoàn toàn trong việc bảo trì, tối ưu và xử lý sự cố website.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS 8.4.1.5

🛠️ **Tối ưu hệ thống**
- **Nâng cấp hệ thống kiểm thử tự động:** Cải tiến toàn diện bộ khung kiểm thử và xác thực kịch bản vận hành, giúp nâng cao độ chính xác, đảm bảo tính ổn định và an toàn tuyệt đối cho mọi tác vụ quản trị máy chủ.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS 8.4.1.4

🚀 **Tính năng mới**
- **Quản lý Object Cache nâng cao (Valkey / KeyDB / Redis):** Tối ưu hóa cấu hình giao tiếp qua Unix Socket tốc độ cao kết hợp hệ thống bảo mật ACL phân quyền độc lập Database ID cho từng website, giúp tăng tốc truy vấn dữ liệu động và bảo vệ dữ liệu toàn diện.
- **Nâng cấp cơ chế Preload Cache thông minh:** Tích hợp cơ chế điều tiết thích ứng (Adaptive Throttling) và tối ưu luồng xử lý, giúp tạo lập bộ nhớ đệm trang web nhanh chóng, mượt mà và tiết kiệm tài nguyên.

🛠️ **Tối ưu hệ thống**
- **Cải tiến quy trình xóa và quản trị website:** Tối ưu hóa toàn diện các tác vụ xử lý tên miền và dọn dẹp tài nguyên, giúp giải phóng không gian lưu trữ chính xác và nâng cao độ mượt mà khi thao tác.
- **Tinh chỉnh hiệu suất thực thi cốt lõi:** Cải tiến tốc độ phản hồi và độ ổn định của các công cụ quản trị dòng lệnh, giảm thiểu tải trọng trong các tác vụ bảo trì hệ thống.

🐛 **Sửa lỗi**
- **Khắc phục sự cố vận hành:** Xử lý triệt để các lỗi xung đột tiềm ẩn trong quá trình quản lý bộ nhớ đệm và tương tác tên miền, đảm bảo máy chủ hoạt động liên tục và ổn định.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS 8.4.1.3

🐛 **Sửa lỗi**
- **Khắc phục lỗi KeyDB Object Cache:** Tối ưu hóa và khắc phục triệt để các sự cố phát sinh trong cơ chế lưu trữ bộ nhớ đệm KeyDB Object Cache, giúp tăng tốc độ truy vấn dữ liệu, giảm tải cho máy chủ và đảm bảo hệ thống WordPress vận hành ổn định, mượt mà.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS 8.4.1.2

🐛 **Sửa lỗi**
- **Khắc phục lỗi cache JavaScript:** Xử lý triệt để sự cố trình duyệt lưu trữ bộ nhớ đệm (cache) tệp JavaScript cũ trên OpenLiteSpeed, giúp đảm bảo khách truy cập luôn nhận được các đoạn mã cập nhật mới nhất mà không gặp tình trạng xung đột hoặc kẹt dữ liệu cũ.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS 8.4.1.1

🚀 **Tính năng mới**
- **Trình giả lập Web Simulator:** Tích hợp công cụ giả lập giao diện dòng lệnh trực quan trên nền web, giúp quản trị viên dễ dàng trải nghiệm, làm quen với cấu trúc menu và các tính năng của hệ thống trước khi triển khai thực tế trên VPS.
- **Hệ thống tài liệu trực tuyến:** Tự động hóa biên dịch toàn diện hệ thống tài liệu tra cứu, cung cấp sơ đồ vị trí phím tắt và hướng dẫn chi tiết cho từng tác vụ quản trị.

🛠️ **Tối ưu hệ thống**
- **Cải tiến giao diện điều hướng (UX):** Nâng cấp hệ thống đánh dấu mã màu trực quan tại menu chính, tạo điểm nhấn nổi bật giúp quản trị viên nhận diện nhanh chóng và hạn chế tối đa thao tác nhầm lẫn.
- **Tinh chỉnh luồng thực thi:** Tối ưu hóa cấu trúc mã nguồn và tốc độ phản hồi lệnh, giúp máy chủ vận hành ổn định và mượt mà hơn.

🐛 **Sửa lỗi**
- **Khắc phục sự cố vận hành:** Xử lý triệt để các lỗi phát sinh trong quá trình tương tác menu và thực thi lệnh, nâng cao độ ổn định và an toàn tuyệt đối cho toàn bộ hệ thống.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
## WPTangToc OLS 8.4.1.0

🚀 **Tính năng mới**
- Thêm trình giả lập Simulator trực quan, cho phép người dùng dễ dàng trải nghiệm và làm quen với hệ thống ngay cả khi chưa chuẩn bị máy chủ VPS.

🛠️ **Tối ưu hệ thống**
- Cải tiến trải nghiệm người dùng (UX) tại menu điều hướng bằng hệ thống đánh dấu mã màu khác biệt, giúp tạo điểm nhấn nổi bật và hạn chế tối đa thao tác nhầm lẫn.

🐛 **Sửa lỗi**
- Khắc phục các lỗi phát sinh từ phiên bản trước, nâng cao sự ổn định và mượt mà trong quá trình vận hành.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
# WPTangToc OLS 8.4.1

🐛 **Sửa lỗi**
- **Khắc phục sự cố vận hành:** Xử lý triệt để các lỗi phát sinh trong quá trình quản trị và thực thi tác vụ trên hệ thống, nâng cao độ ổn định và đảm bảo máy chủ hoạt động liên tục, mượt mà.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
# WPTangToc OLS 8.4.0.9

🛠️ **Tối ưu hệ thống**
- **Cải tiến tính năng xóa cache:** Tối ưu hóa cơ chế và tốc độ xử lý khi xóa bộ nhớ đệm (cache), giúp làm sạch dữ liệu nhanh chóng, giải phóng tài nguyên hiệu quả và đảm bảo website luôn hiển thị nội dung mới nhất cho người dùng.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
# WPTangToc OLS 8.4.0.8

🛠️ **Tối ưu hệ thống**
- **Cải tiến giao diện hiển thị tên miền dài:** Tối ưu hóa cách thức trình bày và xử lý giao diện đối với các tên miền có ký tự dài, tự động xuống dòng gọn gàng giúp quản trị viên dễ dàng theo dõi, quan sát và thao tác quản trị máy chủ một cách trực quan và mượt mà hơn.

---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
# WPTangToc OLS 8.4.0.7

🛠️ **Tối ưu hệ thống**
- **Cải tiến tính năng kiểm tra hoạt động website:** Tối ưu hóa độ chính xác và tốc độ phản hồi của công cụ kiểm tra trạng thái website, giúp quản trị viên giám sát tình trạng hoạt động của các trang web nhanh chóng và hiệu quả hơn.
- **Nâng cấp trải nghiệm người dùng (UX):** Tinh chỉnh giao diện và luồng thao tác trực quan, mượt mà hơn, giúp quản trị viên dễ dàng quản lý máy chủ và tiết kiệm thời gian thao tác.


---
*Bản phát hành bao gồm toàn bộ chữ ký xác thực GPG, SHA256SUMS và Full Source Code.*
