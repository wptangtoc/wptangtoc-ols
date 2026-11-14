# 📚 Tài Liệu Tính Năng Chính Thức WPTangToc OLS (v8.4.0.9)

- **Tác giả:** Gia Tuấn ([@wptangtoc](https://wptangtoc.com))
- **Trang chủ:** https://wptangtoc.com

## 🚀 Cài Đặt Nhanh WPTangToc OLS

```bash
curl -sO [https://wptangtoc.com/share/wptangtoc-ols](https://wptangtoc.com/share/wptangtoc-ols) && bash wptangtoc-ols
```

> Tài liệu này được biên dịch tự động 100% từ các tính năng chính thức trong Menu của **WPTangToc OLS v8.4.0.9**.

---

## Quản lý WordPress (`wptt-wordpress-main`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress  _(bấm lần lượt: 1)_
- **Tệp nguồn:** `/etc/wptt/wptt-wordpress-main`

```text
Tính năng quản lý WordPress của WPTangToc OLS là một bộ công cụ được tích hợp sẵn trong script, giúp đơn giản hóa và tối ưu hóa việc cài đặt, cấu hình và quản trị các website WordPress trên máy chủ OpenLiteSpeed.

Giới thiệu ngắn gọn:

Mục đích: Cung cấp một giao diện hoặc các lệnh thuận tiện để người dùng dễ dàng triển khai và vận hành website WordPress một cách hiệu quả, tận dụng tối đa hiệu suất của OpenLiteSpeed.
Cách hoạt động:
* Cài đặt WordPress nhanh chóng: Cho phép tạo website WordPress mới chỉ với vài thao tác đơn giản, tự động hóa việc tạo database.
* Tối ưu hóa cho WordPress: Tự động cấu hình các thiết lập máy chủ tối ưu cho WordPress, đặc biệt là liên quan đến LiteSpeed Cache để tăng tốc website.
* Quản lý website: Có thể bao gồm các tùy chọn để quản lý các khía cạnh cơ bản của website WordPress từ dòng lệnh hoặc giao diện của script [ví dụ: bật/tắt cache].
* Bảo mật cơ bản: Có thể tích hợp sẵn một số cấu hình bảo mật cơ bản cho WordPress ở cấp độ máy chủ.
* Giúp quản trị WordPress dễ dàng hơn.
* v.v.v

Lợi ích:
* Tiết kiệm thời gian: Tự động hóa nhiều bước cài đặt và cấu hình thủ công.
* Tối ưu hiệu suất: Đảm bảo WordPress chạy nhanh và mượt mà với LiteSpeed Cache.
* Dễ sử dụng: Đơn giản hóa việc quản lý WordPress, ngay cả với người dùng ít kinh nghiệm về quản trị máy chủ.
* Ổn định: Cung cấp một môi trường được tinh chỉnh sẵn cho WordPress.

Tính năng này làm cho WPTangToc OLS trở thành một lựa chọn hấp dẫn cho những ai muốn xây dựng và quản lý website WordPress hiệu suất cao trên nền tảng OpenLiteSpeed mà không cần quá nhiều kiến thức kỹ thuật sâu.
```

---

## Cập nhật WordPress core (`update-core`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 1. Quản lý Cập nhật WordPress › 1. Cập nhật WordPress core  _(bấm lần lượt: 1 → 1 → 1)_
- **Tệp nguồn:** `/etc/wptt/wordpress/update-core`

```text
Tính năng cập nhật core WordPress [hay cập nhật lõi WordPress] là một chức năng cực kỳ quan trọng, được tích hợp sẵn trong wptangtoc ols, cho phép người dùng nâng cấp toàn bộ phần mềm WordPress chính [các file và mã nguồn cốt lõi] lên phiên bản mới nhất do đội ngũ phát triển WordPress phát hành.

Tại sao cần cập nhật core WordPress [lợi ích chính]:
* Bảo mật Tối thượng: Đây là lý do quan trọng nhất. Các bản cập nhật lõi WordPress thường xuyên vá các lỗ hổng bảo mật được phát hiện. Sử dụng phiên bản WordPress lỗi thời là một rủi ro bảo mật nghiêm trọng, có thể khiến website của bạn dễ dàng bị tấn công.
* Tính năng Mới và Cải tiến Lớn: Các phiên bản WordPress mới [đặc biệt là các bản phát hành chính] thường giới thiệu nhiều tính năng mới, cải tiến giao diện người dùng [ví dụ: trình soạn thảo block], nâng cao hiệu suất và mang lại trải nghiệm người dùng tốt hơn.
* Sửa lỗi [Bug Fixes]: Các bản cập nhật sửa các lỗi đã biết từ những phiên bản trước, giúp WordPress hoạt động ổn định, đáng tin cậy hơn và giảm thiểu sự cố.
* Cải thiện Hiệu suất: Các phiên bản mới thường đi kèm với những tối ưu hóa về mã nguồn, giúp website của bạn tải nhanh hơn và hoạt động hiệu quả hơn.
* Đảm bảo Tương thích: Giữ cho WordPress tương thích với các công nghệ web mới nhất, phiên bản PHP mới, đồng thời tạo nền tảng ổn định cho các giao diện [theme] và plugin hoạt động.

Tính năng cập nhật core WordPress là một phần không thể thiếu để đảm bảo website của bạn luôn an toàn, ổn định, có đầy đủ các tính năng mới nhất và hoạt động với hiệu suất tối ưu. Việc cập nhật WordPress core thường xuyên là một trong những trách nhiệm quan trọng nhất của người quản trị website.
```

---

## Cập nhật plugins (`update-plugin`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 1. Quản lý Cập nhật WordPress › 2. Cập nhật plugins  _(bấm lần lượt: 1 → 1 → 2)_
- **Tệp nguồn:** `/etc/wptt/wordpress/update-plugin`

```text
Tính năng cập nhật plugin WordPress là một chức năng cốt lõi của WordPress, cho phép người dùng dễ dàng nâng cấp các plugin đã cài đặt trên website của họ lên phiên bản mới nhất do nhà phát triển plugin cung cấp.

Tại sao cần cập nhật plugin [lợi ích chính]:
* Bảo mật: Đây là lý do quan trọng hàng đầu. Các bản cập nhật plugin thường xuyên vá các lỗ hổng bảo mật đã được phát hiện. Plugin lỗi thời là một trong những nguyên nhân phổ biến nhất khiến website WordPress bị tấn công.
* Thêm Tính năng Mới và Cải tiến: Nhà phát triển liên tục cải thiện plugin bằng cách thêm các chức năng mới, tối ưu hóa hiệu suất, hoặc cải thiện giao diện người dùng.
* Sửa lỗi [Bug Fixes]: Các phiên bản cập nhật khắc phục các lỗi còn tồn tại ở phiên bản trước, giúp plugin hoạt động ổn định và chính xác hơn.
* Đảm bảo Tương thích: Giúp plugin hoạt động tốt với phiên bản WordPress mới nhất, cũng như với các theme và plugin khác, tránh xung đột gây lỗi website.
* Tăng hiệu suất: Đôi khi các bản cập nhật bao gồm việc tối ưu mã nguồn, giúp plugin chạy nhanh hơn và nhẹ hơn.

Tính năng cập nhật plugin WordPress đóng vai trò cực kỳ quan trọng trong việc duy trì một website an toàn, ổn định, đầy đủ tính năng và tương thích tốt. Việc thường xuyên kiểm tra và thực hiện cập nhật là một phần không thể thiếu trong quản trị website WordPress.
```

---

## Cập nhật themes (`update-theme`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 1. Quản lý Cập nhật WordPress › 3. Cập nhật themes  _(bấm lần lượt: 1 → 1 → 3)_
- **Tệp nguồn:** `/etc/wptt/wordpress/update-theme`

```text
Tính năng cập nhật theme WordPress là một chức năng cho phép người dùng dễ dàng nâng cấp giao diện [theme] website của họ lên phiên bản mới nhất do nhà phát triển theme cung cấp.

Tại sao cần cập nhật theme [lợi ích chính]:
* Bảo mật: Đây là lý do quan trọng nhất. Các bản cập nhật theme thường xuyên vá các lỗ hổng bảo mật được phát hiện. Việc không cập nhật có thể khiến website của bạn dễ bị tấn công.
* Thêm Tính năng Mới: Nhà phát triển thường bổ sung các tính năng, tùy chọn tùy chỉnh, hoặc cải tiến thiết kế trong các phiên bản mới, giúp website của bạn hiện đại và tiện dụng hơn.
* Sửa lỗi [Bug Fixes]: Các phiên bản cập nhật sửa các lỗi đã biết từ phiên bản trước, giúp theme hoạt động ổn định và mượt mà hơn.
* Đảm bảo Tương thích: Giúp theme tương thích tốt hơn với phiên bản WordPress mới nhất cũng như các plugin khác, tránh xung đột và lỗi không mong muốn.

Tính năng cập nhật theme WordPress là một phần thiết yếu để duy trì một website an toàn, ổn định, và hiện đại. Việc thường xuyên kiểm tra và áp dụng các bản cập nhật là một thói quen tốt cho mọi chủ sở hữu website WordPress.
```

---

## Cài lại wordpress core (`ghi-de-wordpress-core`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 1. Quản lý Cập nhật WordPress › 4. Cài lại wordpress core  _(bấm lần lượt: 1 → 1 → 4)_
- **Tệp nguồn:** `/etc/wptt/wordpress/ghi-de-wordpress-core`

```text
Tính năng này để cài đặt lại hoặc ghi đè các file lõi [core files] của WordPress.

Mục đích sử dụng chính [tính năng] của lệnh này:

* Sửa chữa lỗi lõi WordPress: Nếu các file lõi của WordPress bị hỏng do cập nhật thất bại, bị nhiễm mã độc, hoặc do sửa đổi file không mong muốn, lệnh này có thể khôi phục chúng về trạng thái gốc sạch sẽ.
* Đảm bảo tính toàn vẹn của file lõi: Giúp chắc chắn rằng các file lõi trên website của bạn hoàn toàn giống với bản phát hành chính thức từ WordPress.org.
* Giải quyết sự cố không rõ nguyên nhân: Đôi khi, đây là một bước khắc phục sự cố khi website gặp lỗi lạ mà nghi ngờ có liên quan đến file lõi.

Tóm lại, lệnh này cung cấp một cách mạnh mẽ để làm mới các file lõi WordPress một cách có kiểm soát, giữ lại nội dung quan trọng của bạn, và thường được dùng để sửa lỗi hoặc đảm bảo tính toàn vẹn của cài đặt WordPress.
```

---

## Cài lại wordpress All (`wptt-update-reinstall-wordpress`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 1. Quản lý Cập nhật WordPress › 5. Cài lại wordpress All  _(bấm lần lượt: 1 → 1 → 5)_
- **Tệp nguồn:** `/etc/wptt/wordpress/wptt-update-reinstall-wordpress`

```text
Tính năng Update và Ghi đè [Force Reinstall] Core, Plugin và Theme của WordPress bằng WP-CLI.

Mục đích chính:
* Cứu hộ Website: Rất hữu ích khi website bị nhiễm mã độc [malware] sửa đổi các file lõi, hoặc khi quá trình cập nhật tự động bị ngắt quãng gây lỗi trắng trang.
* Cập nhật đồng loạt: Ép buộc tải lại và cập nhật phiên bản mới nhất của toàn bộ mã nguồn từ máy chủ WordPress.org.

Quy trình hoạt động:
1. Tải và ghi đè lại toàn bộ mã nguồn WordPress Core [bỏ qua thư mục wp-content].
2. Quét danh sách Plugin hiện có và ép buộc tải lại bản mới nhất từ kho WordPress.org.
3. Quét danh sách Theme hiện có và ép buộc tải lại bản mới nhất từ kho WordPress.org.
4. Tự động sửa lại quyền sở hữu [Ownership] file về chuẩn của OpenLiteSpeed để tránh lỗi Permission Denied.

CẢNH BÁO QUAN TRỌNG:
* Các Plugin và Theme trả phí [Premium - không có trên kho miễn phí của WP.org] sẽ bị bỏ qua và báo lỗi nhẹ [không ảnh hưởng hệ thống].
* Nếu bạn sửa code trực tiếp vào Theme gốc [thay vì dùng Child Theme], việc ghi đè này SẼ LÀM MẤT TOÀN BỘ CODE TÙY CHỈNH CỦA BẠN. Hãy cân nhắc kỹ!
```

---

## Hạ cấp Core WordPress (`ha-cap-phien-ban-wordpress-core`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 1. Quản lý Cập nhật WordPress › 7. Hạ cấp Core WordPress  _(bấm lần lượt: 1 → 1 → 7)_
- **Tệp nguồn:** `/etc/wptt/wordpress/ha-cap-phien-ban-wordpress-core`

```text
Tính năng hạ cấp WordPress core, thì mục đích của nó là cho phép bạn đưa phiên bản lõi [core] của WordPress trên website về một phiên bản cũ hơn.

Mục đích sử dụng của tính năng này:

* Khắc phục sự cố tương thích: Lý do chính thường là khi phiên bản WordPress mới nhất gây ra xung đột nghiêm trọng với một theme hoặc plugin quan trọng nào đó mà bạn chưa thể cập nhật hoặc thay thế.
* Tránh lỗi nghiêm trọng ở phiên bản mới: Trong một số trường hợp hiếm hoi, phiên bản WordPress mới có thể chứa lỗi ảnh hưởng đến hoạt động website của bạn, và việc hạ cấp tạm thời là giải pháp trong khi chờ bản vá.

thì đây là tính năng hữu ích, để giúp bạn có thể hạ cấp phiên bản Core WordPress về đúng với cái ý muốn của mình

Tóm lại: Nếu WPTangToc OLS của bạn có tính năng hạ cấp WordPress core, nó được dùng để đưa website về phiên bản WordPress cũ hơn nhằm giải quyết các vấn đề tương thích khẩn cấp.

Tuy nhiên, đây là một hành động rủi ro cao, đặc biệt về bảo mật, và chỉ nên được thực hiện như một giải pháp cuối cùng sau khi đã sao lưu đầy đủ và hiểu rõ mọi hệ lụy. Hãy tham khảo tài liệu hoặc cộng đồng hỗ trợ.
```

---

## Hạ cấp Plugin WordPress (`ha-cap-phien-ban-plugins`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 1. Quản lý Cập nhật WordPress › 8. Hạ cấp Plugin WordPress  _(bấm lần lượt: 1 → 1 → 8)_
- **Tệp nguồn:** `/etc/wptt/wordpress/ha-cap-phien-ban-plugins`

```text
Tính năng hạ cấp plugin, thì mục đích của nó là cho phép bạn đưa một plugin cụ thể trên website WordPress của bạn trở lại một phiên bản cũ hơn.

Giới thiệu ngắn gọn về tính năng này:
Mục đích sử dụng:
* Khắc phục lỗi do cập nhật plugin: Lý do phổ biến nhất là khi phiên bản mới của một plugin gây ra lỗi, xung đột với theme hoặc các plugin khác, hoặc làm hỏng một chức năng nào đó trên website của bạn.
* Tính năng bị loại bỏ hoặc thay đổi không mong muốn: Đôi khi, phiên bản mới của plugin loại bỏ một tính năng bạn cần hoặc thay đổi cách hoạt động theo hướng bạn không thích.
* Vấn đề tương thích tạm thời: Trong khi chờ nhà phát triển plugin hoặc theme khác cập nhật để tương thích với phiên bản plugin mới nhất.

Tóm lại: WPTangToc OLS tích hợp tính năng hạ cấp plugin giúp bạn quay lại phiên bản cũ hơn của một plugin để giải quyết các vấn đề phát sinh từ bản cập nhật mới. Tuy nhiên, đây nên được coi là một giải pháp tạm thời và cần thực hiện hết sức cẩn trọng do các rủi ro về bảo mật và tương thích.
```

---

## Kiểm tra phiên bản WordPress (`kiem-tra-version-wp`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 1. Quản lý Cập nhật WordPress › 9. Kiểm tra phiên bản WordPress  _(bấm lần lượt: 1 → 1 → 9)_
- **Tệp nguồn:** `/etc/wptt/wordpress/kiem-tra-version-wp`

```text
🔍 TÍNH NĂNG: KIỂM TRA PHIÊN BẢN WORDPRESS (CORE, PLUGINS, THEMES)
Thay vì phải đăng nhập vào trang quản trị (wp-admin) rườm rà và chờ đợi 
tải trang, công cụ này sẽ giao tiếp trực tiếp với hệ sinh thái WordPress 
thông qua WP-CLI để xuất báo cáo toàn diện chỉ trong vài giây.

🚀 NHỮNG GÌ CÔNG CỤ NÀY SẼ BÁO CÁO?
 ➜ WordPress Core: Kiểm tra chính xác phiên bản mã nguồn nền tảng.
 ➜ Danh sách Plugins: Liệt kê toàn bộ Plugin đang có trên website, hiển thị 
    rõ phiên bản đang dùng và BÁO CÁO PHIÊN BẢN MỚI (nếu có bản cập nhật).
 ➜ Danh sách Themes: Hiển thị chi tiết các giao diện (Themes) đang cài đặt 
    và tình trạng cập nhật của chúng.

🛡️ TẠI SAO TÍNH NĂNG NÀY RẤT QUAN TRỌNG?
 - Rà soát bảo mật: Plugin/Theme cũ, không được cập nhật là nguyên nhân 
   số 1 (chiếm 90%) khiến website bị dính mã độc. Bảng báo cáo này giúp 
   bạn "nhìn thấu" ngay lập tức thành phần nào đang lỗi thời.
 - Siêu tốc & Tiện lợi: Chạy hoàn toàn dưới nền dòng lệnh, không tiêu tốn 
   tài nguyên Web Server. Giúp bạn kiểm tra nhanh trước khi quyết định 
   có nên bấm nút "Cập nhật tất cả" hay không.
 - Chuẩn quyền (Isolated): Tự động nhận diện phiên bản PHP riêng biệt của 
   từng website để thực thi lệnh an toàn.
```

---

## Quản lý Cập nhật WordPress (`wptt-update-wordpress-main`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 1. Quản lý Cập nhật WordPress  _(bấm lần lượt: 1 → 1)_
- **Tệp nguồn:** `/etc/wptt/wordpress/wptt-update-wordpress-main`

```text
Tính năng quản lý cập nhật WordPress là một hệ thống toàn diện được tích hợp trong wptangtoc ols để phục vụ hỗ trợ việc quản lý cập nhật của riêng WordPress, giúp người quản trị website dễ dàng theo dõi, kiểm soát và thực hiện việc nâng cấp cho tất cả các thành phần cốt lõi của website, bao gồm: lõi WordPress [core], [themes], và các [plugins].

Tại sao quản lý cập nhật hiệu quả lại quan trọng?
* Bảo mật Vững chắc: Giữ cho mọi thành phần của website luôn được vá lỗi bảo mật mới nhất.
* Ổn định và Tương thích: Đảm bảo các thành phần hoạt động hài hòa với nhau, giảm thiểu xung đột.
* Tiếp cận Tính năng Mới: Giúp bạn tận dụng được những cải tiến và chức năng mới nhất.
* Quy trình Làm việc Tối ưu: Đơn giản hóa và hợp lý hóa công việc bảo trì website.

Tóm lại: Tính năng quản lý cập nhật của WordPress là một công cụ mạnh mẽ và thân thiện, giúp người quản trị website duy trì một trang web an toàn, ổn định, hiện đại và hoạt động hiệu quả bằng cách đơn giản hóa việc theo dõi và áp dụng các bản nâng cấp cần thiết cho toàn bộ hệ thống.
```

---

## Cập nhật Url home && siteurl (`thay-url-option`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 2. Cập nhật Url home && siteurl  _(bấm lần lượt: 1 → 2)_
- **Tệp nguồn:** `/etc/wptt/wordpress/thay-url-option`

```text
🌐 TÍNH NĂNG: CẬP NHẬT HOME URL & SITE URL CHO WORDPRESS
Trong WordPress, "Home URL" (địa chỉ trang chủ) và "Site URL" (địa chỉ 
cài đặt mã nguồn) là hai thông số sống còn quyết định việc website có 
hiển thị đúng giao diện và truy cập được hay không. 

Tính năng này giúp bạn tự động chuẩn hóa và cập nhật lại chính xác 
địa chỉ tên miền vào cơ sở dữ liệu của WordPress chỉ trong 1 giây.

🚀 KHI NÀO BẠN CẦN DÙNG TÍNH NĂNG NÀY?
 ➜ Clone/Chuyển nhà website: Khi bạn chuyển dữ liệu từ Localhost 
    (máy tính cá nhân) lên Server thực tế, hoặc nhân bản từ tên miền cũ 
    sang tên miền mới, bạn bắt buộc phải cập nhật lại URL để web không 
    bị vỡ giao diện hoặc chuyển hướng (redirect) nhầm về web cũ.
 ➜ Lỗi "Too many redirects": Khi website bị lỗi vòng lặp chuyển hướng, 
    thường do thiết lập sai URL trong database. Công cụ này sẽ "nắn" lại.
 ➜ Kích hoạt SSL (HTTPS): Sau khi cài chứng chỉ SSL, bạn cần đổi 
    toàn bộ URL từ HTTP sang HTTPS để có ổ khóa xanh.

🧠 SỰ THÔNG MINH CỦA CÔNG CỤ (SMART DETECTION):
 - Tự động nhận diện HTTPS: Hệ thống tự kiểm tra xem chứng chỉ SSL 
   (Let's Encrypt, ZeroSSL...) của bạn còn hạn không, nếu có sẽ tự 
   động thiết lập URL là `https://`, ngược lại dùng `http://`.
 - Giữ nguyên cấu trúc WWW: Nếu website cũ đang chạy `www.domain.com`, 
   hệ thống sẽ tôn trọng tùy chọn này và cập nhật URL có chứa `www`.
 - Tự động xóa Object Cache ngay sau khi cập nhật (Valkey/Redis) để 
   thay đổi có hiệu lực ngay lập tức.
```

---

## Rewrite permalink (`rewrite`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 3. Rewrite permalink  _(bấm lần lượt: 1 → 3)_
- **Tệp nguồn:** `/etc/wptt/wordpress/rewrite`

```text
tính năng rewrite trong WordPress, hay còn gọi là WordPress Rewrite API và thường được biết đến qua Permalinks [Đường dẫn tĩnh], là một hệ thống mạnh mẽ cho phép WordPress chuyển đổi các URL [địa chỉ web] mặc định khó hiểu thành các URL thân thiện, dễ đọc và tốt cho SEO.

Giải thích ngắn gọn:

Thay vì một URL dạng:
* http://example.com/?p=123 [khó nhớ, không thân thiện với SEO]
WordPress có thể rewrite [viết lại] nó thành dạng:
* http://example.com/ten-bai-viet-cua-ban/ [dễ đọc, dễ nhớ, tốt cho SEO]
hoặc
* http://example.com/chuyen-muc/ten-bai-viet/

Tính năng rewrite của WordPress là một công cụ thiết yếu giúp website của bạn có các đường dẫn URL đẹp mắt, dễ hiểu, thân thiện với người dùng và đặc biệt quan trọng cho việc tối ưu hóa công cụ tìm kiếm [SEO].
```

---

## On/Off chế độ bảo trì (`bao-tri-wordpress`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 4. On/Off chế độ bảo trì  _(bấm lần lượt: 1 → 4)_
- **Tệp nguồn:** `/etc/wptt/wordpress/bao-tri-wordpress`

```text
1. Tính Năng Bật Bảo Trì WordPress [Enable WordPress Maintenance Mode]
Bật bảo trì WordPress là quá trình kích hoạt một trạng thái tạm thời cho website WordPress của bạn, trong đó khách truy cập thông thường sẽ thấy một trang thông báo [ví dụ: Website đang được bảo trì, vui lòng quay lại sau] thay vì nội dung website chính.

Trong khi đó, quản trị viên [admin] thường vẫn có thể truy cập vào khu vực quản trị [backend] để thực hiện các công việc cần thiết.

Mục đích chính:
* Thực hiện cập nhật lớn: An toàn khi cập nhật WordPress core, theme, plugin quan trọng.
* Phát triển/Thiết kế lại: Khi đang có những thay đổi lớn về giao diện hoặc chức năng.
* Sửa lỗi nghiêm trọng: Ngăn người dùng gặp phải lỗi trong khi bạn đang khắc phục.
* Ngăn chặn tương tác không mong muốn: Tránh việc người dùng gửi dữ liệu hoặc thực hiện giao dịch trong quá trình thay đổi có thể ảnh hưởng đến dữ liệu.
Kết quả: Khách truy cập sẽ thấy trang bảo trì [thường với mã trạng thái HTTP 503, tốt cho SEO], trong khi quản trị viên có thể làm việc ở backend.

2. Tính Năng Tắt Bảo Trì WordPress [Disable WordPress Maintenance Mode]
Tắt bảo trì WordPress là quá trình vô hiệu hóa chế độ bảo trì, đưa website WordPress trở lại trạng thái hoạt động bình thường và cho phép tất cả khách truy cập có thể vào xem nội dung.

Mục đích chính:
* Khi công việc bảo trì, cập nhật, hoặc sửa lỗi đã hoàn tất.
* Website đã ổn định và sẵn sàng phục vụ người dùng.

Kết quả: Trang thông báo bảo trì sẽ biến mất, và website của bạn sẽ hoạt động trở lại bình thường, chào đón tất cả khách truy cập.
```

---

## Thiết lập WordPress Multisite (`wordpress-multisite`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 6. Thiết lập WordPress Multisite  _(bấm lần lượt: 1 → 6)_
- **Tệp nguồn:** `/etc/wptt/wordpress/wordpress-multisite`

```text
Tính năng Multisite [đa trang web] là một chức năng mạnh mẽ được tích hợp sẵn trong WordPress, cho phép bạn tạo và quản lý một mạng lưới nhiều website khác nhau từ một lần cài đặt WordPress duy nhất.

🎯 Mục đích sử dụng phổ biến:
* Tạo một mạng lưới blog cá nhân.
* Các trường đại học, tổ chức cung cấp website cho các khoa, phòng ban, hoặc dự án.
* Doanh nghiệp có nhiều chi nhánh hoặc thương hiệu con muốn có website riêng nhưng quản lý tập trung.
* Cung cấp nền tảng cho người dùng tự tạo website [tương tự WordPress.com].

Tính năng thiết lập multisite WordPress bạn có thể dễ dàng thiết lập multisite
Với dạng: subdomain hoặc subfolder
```

---

## Tối ưu hình ảnh (`image`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 8. Tối ưu hình ảnh  _(bấm lần lượt: 1 → 8)_
- **Tệp nguồn:** `/etc/wptt/wordpress/image`

```text
Công cụ tối ưu hóa hình ảnh với 2 chế độ:
1. Lossy: Giảm dung lượng nhiều, giảm chất lượng nhẹ [Khuyên dùng cho Blog/Tin tức].
2. Lossless: Giữ nguyên 100% chất lượng [Khuyên dùng cho Web ảnh]
```

---

## Tái tạo lại Thumbnail (`wptt-render-thumbnail`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 9. Tái tạo lại Thumbnail  _(bấm lần lượt: 1 → 9)_
- **Tệp nguồn:** `/etc/wptt/wordpress/wptt-render-thumbnail`

```text
Tính năng tái tạo thumbnail [hay còn gọi là tái tạo hình ảnh thu nhỏ/ảnh đại diện] trong WordPress là một công cụ hữu ích để tạo lại các phiên bản ảnh với kích thước khác nhau cho những hình ảnh đã được tải lên Thư viện [Media Library] trước đó.

Thumbnail trong WordPress là gì?
Khi bạn tải một hình ảnh lên WordPress, hệ thống [cùng với giao diện [theme] và một số plugin] sẽ tự động tạo ra nhiều bản sao của hình ảnh đó với các kích thước khác nhau [ví dụ: ảnh thu nhỏ, ảnh trung bình, ảnh lớn, và các kích thước tùy chỉnh khác do theme/plugin định nghĩa]. Các phiên bản này được sử dụng ở những vị trí khác nhau trên website để tối ưu hiển thị và tốc độ tải trang.

Tại sao cần tái tạo thumbnail [tính năng/lợi ích]:

Khi Thay đổi Giao diện [Theme]:
* Giao diện mới có thể định nghĩa các kích thước ảnh thumbnail khác với giao diện cũ. Những hình ảnh đã tải lên trước đó sẽ không có các kích thước mới này, dẫn đến việc chúng có thể bị hiển thị sai, mờ, hoặc không khớp với bố cục mới. Tái tạo thumbnail sẽ tạo ra các kích thước ảnh cần thiết cho giao diện mới.

Sau khi Cài đặt/Thay đổi Plugin:
* Một số plugin [ví dụ: plugin thư viện ảnh, WooCommerce] có thể thêm các kích thước ảnh mới. Bạn cần tái tạo thumbnail để các hình ảnh cũ cũng có những kích thước này.

Khi Thay đổi Kích thước Ảnh trong Cài đặt:
* Nếu bạn thay đổi kích thước mặc định của WordPress [trong Cài đặt phương tiện] hoặc một lập trình viên thay đổi các kích thước ảnh tùy chỉnh trong code.

Khắc phục Sự cố Hiển thị Ảnh:
* Đôi khi hình ảnh không hiển thị đúng kích thước mong muốn, việc tái tạo thumbnail có thể giúp khắc phục.

Trong một số trường hợp, các phiên bản ảnh có thể không được chuyển đi đầy đủ hoặc chính xác.

Tính năng tái tạo thumbnail là một công cụ bảo trì quan trọng cho website WordPress, giúp đảm bảo tất cả hình ảnh của bạn được hiển thị đúng cách và tối ưu trên toàn bộ website, đặc biệt sau khi có những thay đổi liên quan đến giao diện hoặc các plugin xử lý hình ảnh.
```

---

## On/Off Tối ưu wp-cron (`wp-cron-job`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 10. On/Off Tối ưu wp-cron  _(bấm lần lượt: 1 → 10)_
- **Tệp nguồn:** `/etc/wptt/wordpress/wp-cron-job`

```text
Kể từ WordPress 3.3 trở đi WordPress đã tính hợp một tính năng cực kì mạnh mẽ, WP-Cron là hệ thống tích hợp sẵn của WordPress để thực hiện các công việc tự động theo lịch như đăng bài đã hẹn giờ, kiểm tra cập nhật, gửi email thông báo, hoặc các tác vụ do plugin lên lịch [ví dụ: sao lưu, quét bảo mật].

Tại Sao Cần Tối Ưu Hóa WP-Cron?
* Hoạt động mặc định của WP-Cron: Theo mặc định, WP-Cron được kích hoạt mỗi khi có người dùng truy cập vào website của bạn.
* Trên website lưu lượng cao: Việc này có thể kích hoạt wp-cron.php quá thường xuyên, gây thêm tải không cần thiết cho máy chủ.
* Trên website lưu lượng thấp: Các tác vụ có thể bị trễ hoặc bỏ lỡ nếu không có ai truy cập website vào thời điểm tác vụ đó được lên lịch.
* Đảm bảo tác vụ chạy đúng giờ: Giúp các công việc quan trọng như đăng bài, gửi email được thực hiện đúng theo lịch trình.

Lợi Ích Của Việc Tối Ưu Hóa WP Cron
* Cải thiện hiệu suất website: Đặc biệt trên các trang có nhiều truy cập, giảm tải cho server.
* Tăng độ tin cậy: Đảm bảo các tác vụ theo lịch được thực thi đúng giờ, kể cả trên các trang ít truy cập.
* Quản lý tài nguyên tốt hơn: Các tác vụ nền chạy một cách có kiểm soát hơn.
Tối ưu hóa WP-Cron là một bước quan trọng để website WordPress của bạn hoạt động mượt mà và ổn định hơn.
```

---

## Tối ưu Heartbeat api (`plugin-heartbeat-wptangtoc`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 11. Tối ưu Heartbeat api  _(bấm lần lượt: 1 → 11)_
- **Tệp nguồn:** `/etc/wptt/wordpress/plugin-heartbeat-wptangtoc`

```text
WPTangToc OLS có tính năng Tối ưu Heartbeat API, thì đây là một chức năng giúp bạn kiểm soát và giảm thiểu tác động của WordPress Heartbeat API lên hiệu suất máy chủ.

🎯 Mục đích của tính năng tối ưu:
* Giảm tải CPU: Hạn chế số lượng yêu cầu AJAX được gửi đi, giúp giảm đáng kể việc sử dụng CPU của máy chủ.
* Tăng tốc Admin: Làm cho khu vực quản trị WordPress hoạt động mượt mà và nhanh hơn.
* Ngăn chặn quá tải: Giúp website ổn định hơn, tiết kiệm tài nguyên máy chủ.

✅ Lợi ích:
* Cải thiện hiệu suất server.
* Tăng tốc độ backend WordPress.

Tóm lại: Tính năng Tối ưu Heartbeat API trong WPTangToc OLS là một công cụ hữu ích giúp bạn kiểm soát các yêu cầu AJAX do WordPress tạo ra, nhằm giảm tải cho máy chủ và tăng tốc độ khu vực quản trị một cách hiệu quả.

link tham khảo chi tiết: https://wptangtoc.com/wordpress-heartbeat-api/
```

---

## Xoá bình luận spam (`xoa-binh-luan-spam`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 12. Xoá bình luận spam  _(bấm lần lượt: 1 → 12)_
- **Tệp nguồn:** `/etc/wptt/wordpress/xoa-binh-luan-spam`

```text
Tính năng Xóa bình luận spam WordPress là quá trình xác định và loại bỏ vĩnh viễn các bình luận không mong muốn, thường là quảng cáo, lừa đảo, hoặc chứa liên kết độc hại, khỏi website WordPress của bạn.

Nói một cách đơn giản, đây là hành động dọn rác trong khu vực bình luận của website để giữ cho nó sạch sẽ, chuyên nghiệp và an toàn cho người đọc.

Mục Đích Chính
* Duy trì chất lượng và uy tín website: Bình luận spam làm website trông thiếu chuyên nghiệp và không đáng tin cậy.
* Cải thiện trải nghiệm người dùng: Người dùng không bị làm phiền bởi các bình luận rác, khuyến khích tương tác thực sự.
* Bảo vệ SEO: Quá nhiều link spam có thể ảnh hưởng xấu đến thứ hạng tìm kiếm của website.
* Tăng cường bảo mật: Một số bình luận spam chứa link độc hại hoặc mã lừa đảo.
* Giảm tải cho database: Loại bỏ bình luận không cần thiết giúp database gọn nhẹ hơn.

Các bình luận spam sẽ bị loại bỏ khỏi website và cơ sở dữ liệu, giúp trang web của bạn trở nên sạch sẽ, an toàn hơn và mang lại trải nghiệm tốt hơn cho người dùng.
```

---

## Thay đổi PassWord WP-Admin (`passwd-wp`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 13. Thay đổi PassWord WP-Admin  _(bấm lần lượt: 1 → 13)_
- **Tệp nguồn:** `/etc/wptt/wordpress/passwd-wp`

```text
Tính năng giúp bạn thay đổi mật khẩu WordPress tài khoản administrator một cách dễ dàng

Tính năng thay đổi mật khẩu administrator WordPress là một chức năng cơ bản và cực kỳ quan trọng để bảo vệ website của bạn. Nó cho phép người quản trị [admin] hoặc người dùng có quyền tương ứng cập nhật mật khẩu đăng nhập vào khu vực quản trị WordPress.

Mục đích chính và tầm quan trọng:

Bảo mật:
* Thay đổi mật khẩu định kỳ hoặc khi nghi ngờ có dấu hiệu bị xâm nhập giúp ngăn chặn truy cập trái phép.
* Đảm bảo chỉ những người được ủy quyền mới có thể vào quản trị website.

Quản lý truy cập:
* Khi bàn giao website hoặc khi có sự thay đổi về nhân sự quản trị, việc đổi mật khẩu là cần thiết.
* Khi người dùng quên mất khẩu WordPress Admin có thể reset khôi phục lại.

Việc thay đổi mật khẩu admin là một thao tác đơn giản nhưng thiết yếu để duy trì bảo đảm bảo mật cho website WordPress của bạn. Nên sử dụng mật khẩu mạnh và thay đổi định kỳ hoặc khi cần thiết.
```

---

## On/Off chỉnh sửa code dashboard (`chinh-sua-truc-tiep-admin-wordpress`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 15. On/Off chỉnh sửa code dashboard  _(bấm lần lượt: 1 → 15)_
- **Tệp nguồn:** `/etc/wptt/wordpress/chinh-sua-truc-tiep-admin-wordpress`

```text
1: Khi bật tính năng chỉnh sửa code trong dashboard wp-admin:
Mục đích chính [Tăng cường bảo mật]:
* Vô hiệu hóa Trình sửa Theme và Plugin: Tính năng này sẽ tắt hoàn toàn các trình soạn thảo mã nguồn cho theme [Giao diện File Editor] và plugin [Plugins File Editor] ngay trong trang quản trị WordPress.  Theme và Plugin
* Ngăn chặn sửa code trực tiếp từ Dashboard: Điều này cản trở việc chỉnh sửa trực tiếp các tệp PHP của theme và plugin thông qua giao diện quản trị.
* Giảm thiểu rủi ro bảo mật: Nếu một tài khoản quản trị viên bị xâm nhập, kẻ tấn công sẽ không thể dễ dàng chèn mã độc vào website thông qua các trình soạn thảo này.
* Tránh lỗi do vô tình sửa code: Ngăn người dùng [kể cả quản trị viên ít kinh nghiệm] vô tình làm hỏng website khi cố gắng sửa code trực tiếp.

2: Khi tắt tính năng chỉnh sửa code trong dashboard wp-admin:
Mục đích chính:
* Kích hoạt lại Trình sửa Theme và Plugin: Cho phép quản trị viên có thể chỉnh sửa tệp theme và plugin trực tiếp từ trang quản trị WordPress.
* Tiện lợi cho việc sửa đổi nhanh [CẨN TRỌNG]: Một số người có thể tạm thời bật lại để thực hiện các chỉnh sửa nhỏ nhanh chóng, đặc biệt nếu không tiện truy cập qua FTP/SFTP.
* Tại sao thường KHÔNG được khuyến nghị cho website đang chạy thật [live site]:
* Tăng rủi ro bảo mật: Mở lại một vectơ tấn công tiềm ẩn nếu tài khoản admin bị lộ.
* Nguy cơ làm hỏng website cao hơn: Sửa code trực tiếp trên live site rất dễ gây lỗi.
```

---

## Truy vấn và thay thế database (`query-truyvan`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 16. Truy vấn và thay thế database  _(bấm lần lượt: 1 → 16)_
- **Tệp nguồn:** `/etc/wptt/wordpress/query-truyvan`

```text
💡 TÍNH NĂNG: TRUY VẤN VÀ THAY THẾ DỮ LIỆU HÀNG LOẠT (SEARCH & REPLACE)
Đây là công cụ cực kỳ mạnh mẽ giúp bạn tự động tìm kiếm và thay thế dữ
liệu trực tiếp bên trong cơ sở dữ liệu (Database) của WordPress.

🎯 TẠI SAO TÍNH NĂNG NÀY LẠI ĐÁNG GIÁ?
Hãy tưởng tượng bạn cần đổi một số điện thoại, email hay tên thương hiệu 
đang nằm rải rác ở hàng trăm, hàng ngàn bài viết và trang sản phẩm. 
Việc mở từng bài ra để sửa thủ công là "nhiệm vụ bất khả thi" và rất dễ 
sai sót. Công cụ này sẽ thay bạn làm điều đó chỉ trong vài giây, quét 
sâu vào database và thay thế chính xác tuyệt đối.

🚀 CÁC ỨNG DỤNG THỰC TẾ TUYỆT VỜI:
 ➜ Đổi thông tin liên hệ: Thay số điện thoại, email, địa chỉ cũ thành mới.
 ➜ Cập nhật thương hiệu: Đổi tên công ty, tên sản phẩm trên toàn bộ web.
 ➜ Đổi tên miền: Chuyển toàn bộ link từ domain cũ sang domain mới, 
    hoặc cập nhật hàng loạt link từ http sang https.
 ➜ Sửa lỗi chính tả hàng loạt hoặc thay thế mã shortcode cũ.

🛡️ AN TOÀN TUYỆT ĐỐI (DRY RUN):
Hệ thống được thiết kế thông minh: luôn quét và "Chạy thử" trước để báo 
cáo có bao nhiêu kết quả được tìm thấy. Chỉ khi bạn xác nhận "Đồng ý", 
dữ liệu mới thực sự được thay thế. Không lo thao tác nhầm!
```

---

## Xoá transient database (`transient`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 17. Xoá transient database  _(bấm lần lượt: 1 → 17)_
- **Tệp nguồn:** `/etc/wptt/wordpress/transient`

```text
Tính năng xóa transient WordPress đề cập đến việc loại bỏ các dữ liệu tạm thời [transients] mà WordPress và các plugin/theme lưu trữ trong cơ sở dữ liệu để tăng tốc độ tải trang hoặc lưu kết quả của các tác vụ tốn thời gian.

Transient WordPress là gì?
Transients là một cơ chế lưu trữ đệm [caching] đơn giản. WordPress sử dụng chúng để lưu trữ thông tin [ví dụ: kết quả từ một API bên ngoài, một truy vấn cơ sở dữ liệu phức tạp, HTML của một widget] trong một khoảng thời gian nhất định. Khi hết hạn, transient đó sẽ tự động bị xóa [hoặc được tạo lại khi cần]. Điều này giúp giảm tải cho server và cải thiện hiệu suất website vì không phải thực hiện lại các tác vụ nặng nề mỗi khi có yêu cầu.

Tại sao cần xóa [tính năng/lợi ích của việc xóa]:

Khắc phục sự cố [Troubleshooting]:
* Đôi khi, transients có thể lưu trữ dữ liệu bị hỏng hoặc đã lỗi thời, gây ra lỗi hiển thị hoặc các vấn đề chức năng trên website. Xóa transients buộc WordPress phải tạo lại dữ liệu mới, thường sẽ giải quyết được các vấn đề này.

Cập nhật Dữ liệu Ngay Lập tức:
* Trong quá trình phát triển hoặc khi bạn vừa thay đổi một cài đặt quan trọng mà dữ liệu của nó được lưu trong transient, việc xóa transient sẽ giúp thay đổi có hiệu lực ngay lập tức thay vì phải chờ nó tự hết hạn.

Giải phóng Dung lượng Cơ sở dữ liệu [Ít phổ biến hơn]:
* Mặc dù transients được thiết kế để tự hết hạn, đôi khi có những transient mồ côi [không tự xóa] hoặc quá nhiều transient được tạo ra có thể làm tăng nhẹ dung lượng bảng wp_options trong cơ sở dữ liệu. Xóa chúng có thể giúp dọn dẹp.

Sau khi Di chuyển Website hoặc Cập nhật Lớn:
* Đôi khi, sau khi di chuyển website sang một server mới hoặc sau một bản cập nhật lớn [WordPress core, theme, plugin], việc xóa transients là một bước tốt để đảm bảo mọi thứ hoạt động với dữ liệu mới nhất.

Tính năng xóa transient trong WordPress là một công cụ hữu ích để khắc phục sự cố, đảm bảo dữ liệu luôn mới và đôi khi để dọn dẹp cơ sở dữ liệu. Nó giúp website hoạt động trơn tru hơn bằng cách buộc làm mới các dữ liệu được lưu trữ tạm thời.
```

---

## Thay đổi tiền tố database (`thay-doi-tien-to`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 18. Thay đổi tiền tố database  _(bấm lần lượt: 1 → 18)_
- **Tệp nguồn:** `/etc/wptt/wordpress/thay-doi-tien-to`

```text
THAY ĐỔI TIỀN TỐ DATABASE WORDPRESS (DATABASE PREFIX)

WordPress mặc định sử dụng tiền tố bảng Database là wp_.
Tính năng này cho phép tự động thay đổi tiền tố mặc định thành
một chuỗi ngẫu nhiên riêng biệt, giúp tăng cường bảo mật cho website.

Việc thay đổi tiền tố giúp giảm khả năng các công cụ khai thác tự động
dựa trên cấu trúc Database mặc định của WordPress.

TÍNH NĂNG NỔI BẬT:
* Tự động tạo tiền tố ngẫu nhiên:
  Hệ thống sinh tiền tố mới gồm các ký tự chữ thường và số,
  hạn chế sử dụng tiền tố mặc định wp_.

* Tự động đổi tên bảng Database:
  Chuyển đổi các bảng WordPress từ tiền tố cũ sang tiền tố mới
  mà không cần thao tác thủ công trên MariaDB/MySQL.

* Cập nhật dữ liệu WordPress:
  Tự động điều chỉnh các khóa option_name và meta_key liên quan
  đến tiền tố cũ trong các bảng Options và Usermeta.

* Cập nhật cấu hình WordPress:
  Tự động sửa biến $table_prefix trong wp-config.php
  để WordPress tiếp tục nhận diện đúng các bảng Database.

* Tự động làm sạch Cache:
  Hỗ trợ xóa OPcache, Object Cache
  nhằm hạn chế sử dụng dữ liệu cấu hình cũ sau khi thay đổi.

* Xác thực kết quả:
  Hệ thống kiểm tra lại tiền tố Database sau khi thực hiện,
  giúp phát hiện trường hợp thay đổi chưa thành công.

* Bảo vệ cấu hình:
  Kiểm tra wp-config.php có phải Symlink hay không
  để hạn chế nguy cơ ghi đè tệp tin ngoài ý muốn.

LỢI ÍCH KHI SỬ DỤNG:
* Hạn chế việc sử dụng tiền tố Database mặc định wp_.
* Giảm khả năng bị khai thác bởi các công cụ tấn công tự động
  nhắm vào cấu trúc Database WordPress phổ biến.
* Tăng tính riêng biệt trong cấu trúc Database của từng website.
* Tự động hóa quá trình thay đổi tiền tố, giảm thao tác thủ công.
* Hạn chế lỗi cấu hình nhờ tự động cập nhật wp-config.php.
* Phù hợp với website WordPress đơn lẻ cần tăng cường bảo mật.

CÁCH SỬ DỤNG:
1. Chọn website WordPress cần thay đổi tiền tố Database.
2. Hệ thống kiểm tra website và cấu hình PHP hiện tại.
3. Kiểm tra tiền tố Database đang sử dụng.
4. Xác nhận thay đổi tiền tố cũ sang tiền tố ngẫu nhiên mới.
5. Chờ hệ thống đổi tên bảng, cập nhật cấu hình và làm sạch Cache.
6. Kiểm tra lại website sau khi hoàn tất.

⚠️ LƯU Ý QUAN TRỌNG
* BẮT BUỘC sao lưu Database và mã nguồn trước khi thực hiện.
* Không nên thực hiện trên website đang có lưu lượng truy cập cao
  nếu chưa có kế hoạch bảo trì phù hợp.
* Nếu quá trình đổi tên bảng hoặc cập nhật cấu hình bị gián đoạn,
  website có thể gặp lỗi kết nối Database hoặc lỗi hiển thị.
* Hãy kiểm tra website sau khi hoàn tất, bao gồm trang chủ,
  trang quản trị WordPress, bài viết và các Plugin quan trọng.
* Tính năng hiện không hỗ trợ WordPress Multisite.
* Tính năng sẽ từ chối thực hiện nếu phát hiện wp-config.php là Symlink.
* Việc thay đổi tiền tố Database KHÔNG thay thế các biện pháp bảo mật
  quan trọng như cập nhật WordPress, Plugin, Theme và sử dụng mật khẩu mạnh.
* Tiền tố Database không phải cơ chế bảo mật tuyệt đối.
  Đây chỉ là một lớp tăng cường bảo mật bổ sung.

Khuyến nghị:
Hãy sao lưu đầy đủ trước khi thay đổi tiền tố Database.
Chỉ thực hiện khi bạn hiểu rõ thao tác và có khả năng khôi phục
website nếu xảy ra sự cố.
```

---

## Unix socket config database (`unix-stocket-wpconfig`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 19. Unix socket config database  _(bấm lần lượt: 1 → 19)_
- **Tệp nguồn:** `/etc/wptt/wordpress/unix-stocket-wpconfig`

```text
⚡ TÍNH NĂNG: TỐI ƯU KẾT NỐI DATABASE BẰNG UNIX SOCKET
Mặc định, WordPress kết nối với cơ sở dữ liệu (MariaDB/MySQL) thông qua
giao thức mạng TCP/IP (localhost hoặc 127.0.0.1). Dù nằm trên cùng một 
máy chủ, dữ liệu vẫn phải "đi vòng" qua nhiều lớp xử lý mạng, gây lãng 
phí tài nguyên và độ trễ.

Tính năng này sẽ cấu hình lại wp-config.php để WordPress giao tiếp 
trực tiếp với MariaDB thông qua Unix Socket (kết nối nội bộ qua file).

🚀 TẠI SAO BẠN NÊN DÙNG TÍNH NĂNG NÀY?
 ➜ Giảm độ trễ (Latency): Bỏ qua toàn bộ overhead của TCP/IP, giúp các 
    truy vấn database phản hồi gần như tức thì.
 ➜ Tiết kiệm CPU: Giảm tải đáng kể cho máy chủ khi phải xử lý hàng nghìn 
    truy vấn cùng lúc (rất tốt cho WooCommerce, website tin tức lớn).
 ➜ Bảo mật hơn: Giới hạn kết nối hoàn toàn ở cấp độ hệ điều hành.

⚙️ TÍNH NĂNG NÀY HOẠT ĐỘNG RA SAO?
 - Tự động dò tìm chính xác file Socket (hỗ trợ cả Ubuntu & AlmaLinux).
 - Hỗ trợ thao tác 1 click cho "Tất cả website" đang chạy trên hệ thống.
 - Xử lý thông minh: Tự động tương thích và mở khóa/khóa file an toàn 
   nếu website của bạn đang được bật chế độ khóa bảo vệ (chattr).
```

---

## Tăng giới hạn ram WordPress (`tang-gioi-han-ram-wordpress`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 20. Tăng giới hạn ram WordPress  _(bấm lần lượt: 1 → 20)_
- **Tệp nguồn:** `/etc/wptt/wordpress/tang-gioi-han-ram-wordpress`

```text
Tính năng Tùy chỉnh RAM WordPress là khả năng điều chỉnh giới hạn bộ nhớ [RAM] mà mỗi kịch bản [script] PHP của website WordPress được phép sử dụng trong quá trình thực thi.

Nói một cách đơn giản, đây là việc bạn nới rộng hoặc thu hẹp không gian bộ nhớ RAM mà WordPress [cùng với theme và plugin của nó] có thể mượn từ máy chủ để chạy các tác vụ. Giới hạn này được gọi là memory_limit trong cấu hình PHP.

Mục Đích Chính
* Khắc phục lỗi Allowed memory size exhausted: Đây là lý do phổ biến nhất. Khi WordPress, theme hoặc plugin thực hiện một tác vụ nặng [ví dụ: xử lý hình ảnh, chạy các plugin phức tạp như WooCommerce, tạo backup], nó có thể cần nhiều RAM hơn mức được phép mặc định, dẫn đến lỗi nghiêm trọng [thường là màn hình trắng hoặc thông báo lỗi cụ thể]. Tăng giới hạn RAM có thể giải quyết vấn đề này.
* Đảm bảo hoạt động của Plugin/Theme: Một số plugin hoặc theme nặng, nhiều tính năng yêu cầu một giới hạn RAM PHP tối thiểu để hoạt động trơn tru.
* Hỗ trợ các tác vụ nặng trong trang quản trị: Các hoạt động trong backend WordPress như cập nhật, quản lý sản phẩm lớn, cũng có thể cần nhiều RAM hơn.
* Cải thiện sự ổn định [gián tiếp]: Khi có đủ RAM, các script ít bị lỗi giữa chừng, giúp website hoạt động ổn định hơn.

Sau khi tùy chỉnh, WordPress sẽ có thêm [hoặc bớt] bộ nhớ để hoạt động, giúp giải quyết các lỗi thiếu bộ nhớ và đảm bảo các tác vụ phức tạp có thể hoàn thành.
```

---

## Kiểm tra Code mã hóa base64 (`check-decode-base64`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 24. Kiểm tra Code mã hóa base64  _(bấm lần lượt: 1 → 24)_
- **Tệp nguồn:** `/etc/wptt/wordpress/check-decode-base64`

```text
Kiểm tra mã nguồn có bị dính mã độc mã hoá base64 không?

để tìm kiếm các đoạn mã độc PHP bị mã hóa phổ biến nhất:
* eval[base64_decode[...]]
* eval[gzinflate[...]]
* assert[base64_decode[...]]

Tốc độ quét siêu tốc, không cần load database, cực kỳ an toàn.
```

---

## On/Off wp debug WordPress (`wp-debug`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 25. On/Off wp debug WordPress  _(bấm lần lượt: 1 → 25)_
- **Tệp nguồn:** `/etc/wptt/wordpress/wp-debug`

```text
1. Tính Năng Bật WP_DEBUG WordPress [Enable WP_DEBUG]
Bật WP_DEBUG là việc kích hoạt chế độ gỡ lỗi [debug mode] của WordPress bằng cách thay đổi một hằng số tên là WP_DEBUG trong tệp tin cấu hình wp-config.php.

Khi WP_DEBUG được bật [true]:

Mục đích chính:
* Hiển thị/Ghi lại lỗi PHP: Giúp Lập trình viên và người quản trị website thấy được tất cả các lỗi PHP [errors], cảnh báo [warnings], và thông báo [notices] mà website đang gặp phải. Điều này cực kỳ hữu ích để tìm và sửa lỗi trong theme, plugin, hoặc code tùy chỉnh.
* Phát hiện code lỗi thời: Giúp nhận diện các hàm hoặc cách sử dụng đã lỗi thời trong WordPress.
* Hỗ trợ gỡ lỗi Màn hình trắng: Khi website bị màn hình trắng chết chóc, bật WP_DEBUG có thể hiển thị lỗi PHP ẩn gây ra vấn đề.
Kết quả: Các lỗi và cảnh báo PHP sẽ được hiển thị hoặc ghi lại, giúp bạn chẩn đoán và khắc phục sự cố website.: file log được ghi trong: mã nguồn/wp-content/debug.log

2. Tính Năng Tắt WP_DEBUG WordPress [Disable WP_DEBUG]
Tắt WP_DEBUG là việc vô hiệu hóa chế độ gỡ lỗi của WordPress, đưa website trở lại trạng thái hoạt động bình thường, không hiển thị thông tin gỡ lỗi.

Mục đích chính [RẤT QUAN TRỌNG cho website đang chạy thật - live site]:
* Bảo mật: Không bao giờ được để WP_DEBUG bật trên website đang chạy thật. Việc hiển thị lỗi chi tiết có thể tiết lộ thông tin nhạy cảm về cấu trúc website và máy chủ, tạo cơ hội cho kẻ tấn công.
* Trải nghiệm người dùng: Các thông báo lỗi trên trang web làm người dùng khó chịu và website trông thiếu chuyên nghiệp.
* Trạng thái hoạt động chuẩn: Đây là cài đặt mặc định và an toàn cho website sản xuất.

Kết quả: Website sẽ không hiển thị các thông báo lỗi PHP ra ngoài, giúp bảo vệ thông tin và mang lại trải nghiệm tốt hơn cho người dùng. Đây là cài đặt tiêu chuẩn cho mọi website WordPress đang hoạt động.
```

---

## Thay đổi salt cookie (`thay-salt`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 26. Thay đổi salt cookie  _(bấm lần lượt: 1 → 26)_
- **Tệp nguồn:** `/etc/wptt/wordpress/thay-salt`

```text
tính năng thay đổi salt WordPress đề cập đến việc cập nhật các Khóa bảo mật và Salt [Security Keys and Salts] trong file wp-config.php của website WordPress. Đây là một biện pháp quan trọng để tăng cường bảo mật cho website của bạn.

Salt WordPress là gì?
Đó là một tập hợp các chuỗi ký tự ngẫu nhiên, dài và phức tạp được WordPress sử dụng để mã hóa thông tin nhạy cảm, đặc biệt là mật khẩu người dùng và cookies [dữ liệu lưu trữ phiên đăng nhập]. Chúng thêm một lớp gia vị [salt] vào quá trình mã hóa, làm cho việc giải mã mật khẩu hoặc giả mạo phiên đăng nhập trở nên khó khăn hơn rất nhiều, ngay cả khi kẻ tấn công có được bản sao cơ sở dữ liệu.

Có 8 khóa và salt: AUTH_KEY, SECURE_AUTH_KEY, LOGGED_IN_KEY, NONCE_KEY, AUTH_SALT, SECURE_AUTH_SALT, LOGGED_IN_SALT, và NONCE_SALT.

Tại sao cần thay đổi [tính năng/lợi ích]:

Tăng cường Bảo mật Nghiêm ngặt:
* Vô hiệu hóa các phiên đăng nhập hiện tại: Khi bạn thay đổi các salt này, tất cả các cookies đăng nhập hiện tại của người dùng sẽ trở nên vô hiệu. Điều này buộc tất cả người dùng [bao gồm cả admin] phải đăng nhập lại.
* Quan trọng sau sự cố bảo mật: Nếu bạn nghi ngờ website đã bị xâm nhập hoặc có khả năng bị lộ thông tin đăng nhập, việc thay đổi salt ngay lập tức sẽ giúp ngăn chặn kẻ tấn công tiếp tục sử dụng các phiên đăng nhập đã bị đánh cắp.
* Khi tiếp quản website: Nếu bạn mới tiếp quản một website WordPress từ người khác, việc thay đổi salt là một bước bảo mật tốt để đảm bảo không có cửa hậu nào tồn tại.

Làm Khó khăn cho Kẻ tấn công:
* Các salt độc nhất làm cho việc sử dụng các kỹ thuật tấn công dựa trên bảng tra cầu vồng [rainbow table attacks] để dò mật khẩu trở nên kém hiệu quả hơn nhiều.

Thay đổi salt WordPress là một tính năng bảo mật quan trọng, giúp bảo vệ thông tin đăng nhập và phiên làm việc của người dùng bằng cách làm cho quá trình mã hóa trở nên mạnh mẽ hơn. Đây là một hành động nên thực hiện định kỳ hoặc ngay khi có dấu hiệu bất thường về bảo mật.
```

---

## Tắt XML RPC WordPress (`plugin-xml-rpc-wptangtoc`)

- **Danh mục:** Quản lý WordPress
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 27. Tắt XML RPC WordPress  _(bấm lần lượt: 1 → 27)_
- **Tệp nguồn:** `/etc/wptt/wordpress/plugin-xml-rpc-wptangtoc`

```text
WPTangToc OLS có tính năng tắt XML-RPC WordPress, thì đây là một biện pháp bảo mật và tối ưu hóa quan trọng, giúp bạn vô hiệu hóa tệp xmlrpc.php trên các website WordPress của mình.

XML-RPC là gì?
* xmlrpc.php là một tệp tin trong WordPress, hoạt động như một Giao diện Lập trình Ứng dụng [API]. Nó cho phép các ứng dụng và dịch vụ bên ngoài kết nối và thực hiện các hành động trên website WordPress của bạn từ xa [ví dụ: đăng bài từ điện thoại, nhận thông báo pingback/trackback, kết nối với các dịch vụ như Jetpack].

🎯 Tại sao cần tắt XML-RPC?
* Tăng cường Bảo mật: Đây là lý do chính. xmlrpc.php là một mục tiêu tấn công rất phổ biến:
* Tấn công Brute-Force: Kẻ tấn công có thể thử hàng ngàn mật khẩu qua xmlrpc.php để dò tài khoản admin.
* Tấn công DDoS [Khuếch đại]: Lợi dụng tính năng pingback để tấn công các website khác.
* Quét và Thu thập Thông tin: Bị lợi dụng để tìm kiếm người dùng hoặc thông tin khác.
* Giảm tải Server: Vô hiệu hóa xmlrpc.php giúp ngăn chặn các truy cập không mong muốn từ bot và kẻ tấn công, giảm bớt gánh nặng không cần thiết cho máy chủ.
* Không còn Cần thiết: Với sự phát triển của REST API trong WordPress, nhiều chức năng của XML-RPC đã trở nên lỗi thời hoặc ít được sử dụng đối với nhiều website hiện đại.

Tóm lại: Tính năng tắt xmlrpc.php trong WPTangToc OLS là một công cụ hữu ích giúp bạn gia cố bảo mật và giảm tải cho website WordPress bằng cách loại bỏ một cổng giao tiếp thường bị lợi dụng để tấn công. Đây là một trong những bước bảo mật cơ bản được khuyến nghị cho hầu hết các website WordPress hiện nay, miễn là bạn không còn phụ thuộc vào các chức năng của XML-RPC.
```

---

## Quản lý Domain (`wptt-domain-main`)

- **Danh mục:** Quản lý Domain
- **Vị trí menu:** Menu chính › 2. Quản lý Domain  _(bấm lần lượt: 2)_
- **Tệp nguồn:** `/etc/wptt/wptt-domain-main`

```text
Tính năng quản lý Domain của WPTangToc OLS là một công cụ tích hợp giúp người dùng dễ dàng thêm, cấu hình và quản lý các tên miền [domain] được sử dụng cho các website trên máy chủ OpenLiteSpeed.

Giới thiệu ngắn gọn:
Mục đích: Đơn giản hóa việc liên kết tên miền với các thư mục website cụ thể trên máy chủ, và quản lý các cấu hình liên quan đến tên miền một cách thuận tiện.

Cách hoạt động:
* Thêm domain mới: Dễ dàng khai báo một tên miền mới và trỏ nó đến một website trên máy chủ.
* Thêm tên miền phụ [subdomain]: Tạo và quản lý các tên miền phụ.
* Quản lý alias domain [domain trỏ về]: Cho phép nhiều tên miền cùng trỏ về một website.
* Liên kết SSL với domain: Kết hợp với tính năng quản lý SSL để cài đặt và cấu hình HTTPS cho từng tên miền.
* Cấu hình cơ bản cho domain: Thiết lập thư mục gốc [document root] cho domain, chọn phiên bản PHP...
* v.v.v

Lợi ích:
* Tổ chức dễ dàng: Quản lý nhiều website với các tên miền khác nhau trên cùng một máy chủ một cách rõ ràng.
* Triển khai nhanh chóng: Nhanh chóng đưa một website mới lên mạng với tên miền đã đăng ký.
* Tích hợp: Hoạt động liền mạch với các tính năng khác như quản lý SSL, quản lý WordPress... để tạo một môi trường web hoàn chỉnh.
* Tiện lợi: Giảm thiểu việc phải cấu hình thủ công các virtual host phức tạp trong OpenLiteSpeed.
Tính năng này giúp người dùng WPTangToc OLS kiểm soát và thiết lập các tên miền cho website của mình một cách hiệu quả, là một phần quan trọng trong việc quản trị máy chủ web.
```

---

## Thêm domain && subdomain (`wptt-themwebsite`)

- **Danh mục:** Quản lý Domain
- **Vị trí menu:** Menu chính › 2. Quản lý Domain › 1. Thêm domain && subdomain  _(bấm lần lượt: 2 → 1)_
- **Tệp nguồn:** `/etc/wptt/domain/wptt-themwebsite`

```text
Đây là tính năng thêm domain website mới vào hệ thống.
Khi khởi tạo: phần mềm sẽ cung cấp cho bạn tài khoản database, đường dẫn đặt mã nguồn... để phục vụ bạn thiết lập website

Tính năng Thêm domain [hay Thêm tên miền] trong quản lý máy chủ là quá trình cấu hình hệ thống để nhận diện và xử lý các yêu cầu truy cập đến một tên miền mới mà bạn muốn sử dụng. Điều này cho phép bạn lưu trữ và chạy một website mới, hoặc trỏ một tên miền mới tới một ứng dụng/website đã có trên máy chủ đó.

Nói một cách đơn giản, đây là bước khai báo với máy chủ rằng tôi có một tên miền mới là tenmienmoi.com, hãy chuẩn bị để phục vụ website cho nó.

Mục Đích Chính
* Lưu trữ [Host] một website mới: Đây là lý do phổ biến nhất, cho phép website của bạn có một địa chỉ riêng trên Internet.
* Chạy nhiều website trên một server: Mỗi tên miền có thể tương ứng với một website riêng biệt.
* Phân tách các ứng dụng hoặc dịch vụ khác nhau: Mỗi tên miền có thể phục vụ một mục đích riêng.

Sau khi thêm thành công, máy chủ sẽ sẵn sàng phục vụ nội dung website khi có người truy cập vào tên miền mới đó.

Ghi chú: WPTangTocOLS không giới hạn số lượng domain bạn thêm vào.
```

---

## Xoá domain (`wptt-xoa-website`)

- **Danh mục:** Quản lý Domain
- **Vị trí menu:** Menu chính › 2. Quản lý Domain › 2. Xoá domain  _(bấm lần lượt: 2 → 2)_
- **Tệp nguồn:** `/etc/wptt/domain/wptt-xoa-website`

```text
Tính năng Xóa domain website [hay Xóa tên miền] trong quản lý máy chủ là quá trình gỡ bỏ một tên miền khỏi cấu hình của máy chủ đó. Sau khi xóa, máy chủ sẽ ngừng phục vụ website và các dịch vụ khác liên quan [mã nguồn, database, ssl, sao lưu...] đến tên miền đó từ máy chủ cụ thể này.

Mục Đích Chính
* Website không còn cần thiết: Ngừng hoạt động hoàn toàn website trên máy chủ.
* Chuyển web sang nhà cung cấp khác: Xóa domain cũ sau khi đã di chuyển thành công.
* Dọn dẹp tài khoản host: Loại bỏ các tên miền phụ không còn sử dụng.
* Giải phóng tài nguyên: Tối ưu dung lượng đĩa và tài nguyên RAM/CPU.
* Sau khi bán hoặc chuyển nhượng tên miền: Không phục vụ domain đã đổi chủ.
```

---

## Danh sách domain (`wptt-list-domain`)

- **Danh mục:** Quản lý Domain
- **Vị trí menu:** Menu chính › 2. Quản lý Domain › 3. Danh sách domain  _(bấm lần lượt: 2 → 3)_
- **Tệp nguồn:** `/etc/wptt/domain/wptt-list-domain`

```text
Tính năng xem danh sách toàn bộ domain và kiểm toán nhanh cấu hình trên hệ thống:
* Thẩm định thực chất chứng chỉ SSL (Phân biệt rõ SSL do CA cấp còn hạn, SSL sắp hết hạn,
  SSL đã quá hạn, SSL tự ký Self-Signed và chưa cài SSL).
* Hiển thị phiên bản PHP, trạng thái Hoạt động/Tạm khóa và các nhãn bảo mật (Chính, Lock, HSTS).
* Tự co giãn cột theo độ dài domain; tự chuyển sang dạng danh sách thuần (TSV) khi
  đầu ra không phải terminal (pipe/cron) hoặc terminal hẹp hơn 80 cột.
```

---

## Thêm Parked Alias domain (`wptt-alias-domain`)

- **Danh mục:** Quản lý Domain
- **Vị trí menu:** Menu chính › 2. Quản lý Domain › 4. Thêm Parked Alias domain  _(bấm lần lượt: 2 → 4)_
- **Tệp nguồn:** `/etc/wptt/domain/wptt-alias-domain`

```text
THIẾT LẬP PARKED DOMAIN / ALIAS DOMAIN (TÊN MIỀN BÍ DANH)

Alias Domain (Parked Domain) là tên miền phụ được gán vào một
website đã tồn tại trên hệ thống. Nhiều tên miền có thể cùng
truy cập một website và sử dụng chung mã nguồn, dữ liệu,
Database WordPress của tên miền chính.

Ví dụ:
➜ Website gốc : wptangtoc.com
➜ Alias Domain: wptangtoc.vn
➜ Alias Domain: wptangtoc.net
➜ Alias Domain: 123.wptangtoc.com

Khi thiết lập thành công, cả 4 tên miền đều truy cập vào cùng
một website WordPress của wptangtoc.com.

1. CHỨC NĂNG CỦA ALIAS DOMAIN
➜ Gán thêm tên miền vào một website WordPress đang hoạt động.
➜ Sử dụng chung Document Root, mã nguồn và Database của website gốc.
➜ Quản lý nhiều tên miền trên cùng một Virtual Host OpenLiteSpeed.
➜ Tự động cập nhật cấu hình vhAliases của Virtual Host.
➜ Tự động đồng bộ Domain Mapping trên Listener HTTP và HTTPS.
➜ Hỗ trợ kiểm tra xung đột tên miền Alias trên toàn bộ Server.
➜ Hỗ trợ cấp mới hoặc mở rộng chứng chỉ SSL Let's Encrypt.
➜ Tự động phát hiện DNS IPv4, IPv6 và tên miền www.
➜ Giữ lại danh sách Alias cũ khi bổ sung tên miền mới.
➜ Tự động loại bỏ Alias trùng lặp trong cấu hình.

2. CHUẨN BỊ DNS TRƯỚC KHI THIẾT LẬP
Trước khi thêm Alias Domain, hãy đăng nhập trang quản lý DNS
của nhà cung cấp tên miền và cấu hình bản ghi trỏ về VPS.

Ví dụ với Alias Domain: wptangtoc.vn

Bản ghi A:
➜ Host: @
➜ Value: IP IPv4 của VPS

Bản ghi A cho www (nếu muốn sử dụng):
➜ Host: www
➜ Value: IP IPv4 của VPS

LƯU Ý:
➜ DNS cần được cập nhật và phân giải về đúng IP máy chủ.
➜ Nếu sử dụng IPv6, bản ghi AAAA phải trỏ đúng IPv6 của VPS.
➜ Nếu IPv6 đang trỏ sai máy chủ, hãy chỉnh sửa hoặc xóa AAAA.
➜ Có thể cần chờ DNS cập nhật sau khi thay đổi bản ghi.
➜ Không bật Proxy/CDN nếu chưa hiểu rõ cách xác thực SSL
  và cấu hình DNS tương ứng.

3. QUY TRÌNH THIẾT LẬP ALIAS DOMAIN
Bước 1:
➜ Chọn website gốc muốn gán thêm tên miền Alias.

Bước 2:
➜ Nhập tên miền Alias mới, ví dụ: wptangtoc.vn

Bước 3:
➜ Hệ thống kiểm tra định dạng tên miền.
➜ Kiểm tra tên miền có bị trùng với website độc lập hay không.
➜ Kiểm tra Alias có đang được Virtual Host khác sử dụng hay không.

Bước 4:
➜ Nếu website gốc đã có SSL Let's Encrypt, hệ thống sẽ hỏi
  người dùng có muốn cấp hoặc mở rộng SSL cho Alias không.

Bước 5:
➜ Hệ thống cập nhật cấu hình Virtual Host và Listener.
➜ Tự động reload OpenLiteSpeed để áp dụng cấu hình.

Bước 6:
➜ Nếu DNS đã trỏ đúng, hệ thống tiến hành mở rộng SSL.
➜ Nếu DNS chưa trỏ đúng, Alias vẫn được cấu hình nhưng SSL
  sẽ được bỏ qua để người dùng thiết lập DNS sau.

4. CẤU HÌNH SSL LET'S ENCRYPT
Hệ thống hỗ trợ mở rộng chứng chỉ SSL cho Alias Domain.

➜ Giữ lại các tên miền SAN đang có trong chứng chỉ hiện tại.
➜ Bổ sung tên miền Alias mới vào chứng chỉ.
➜ Tự động kiểm tra DNS IPv4 và IPv6 trước khi cấp SSL.
➜ Kiểm tra riêng bản ghi www của Alias Domain.
➜ Nếu www đã trỏ đúng VPS, có thể đưa www vào chứng chỉ.
➜ Sử dụng cert-name theo tên miền gốc để hạn chế phát sinh
  nhánh chứng chỉ trùng lặp như -0001.

LƯU Ý:
SSL chỉ được cấp khi điều kiện xác thực DNS phù hợp.
Nếu DNS chưa chính xác, hãy xử lý DNS rồi thực hiện cấp SSL
sau. Không nên cố cấp chứng chỉ khi tên miền đang trỏ sai VPS.

5. NHỮNG ĐIỀU CẦN BIẾT
⚠️ Alias Domain không tạo ra một website WordPress độc lập.

➜ Các Alias dùng chung mã nguồn và Database với website gốc.
➜ Nội dung, tài khoản, plugin, theme và cấu hình WordPress
  đều thuộc cùng một website.
➜ Nếu muốn tạo website riêng biệt, hãy sử dụng chức năng
  thêm website mới thay vì Alias Domain.
➜ Một tên miền không thể đồng thời làm Alias cho nhiều
  Virtual Host trên cùng hệ thống.
➜ Nếu Alias đang tồn tại dưới dạng website độc lập, cần xử lý
  website đó trước khi gán làm Alias.
➜ Việc thêm Alias không tự động thay đổi URL chính trong
  WordPress Database.
➜ Nếu muốn Alias chuyển hướng về tên miền chính, cần cấu hình
  Redirect/Canonical URL riêng phù hợp với nhu cầu SEO.

6. KIỂM TRA SAU KHI THIẾT LẬP
Sau khi hoàn tất, hãy kiểm tra:

➜ Alias Domain đã phân giải DNS về đúng VPS.
➜ Website có truy cập được qua Alias Domain hay không.
➜ HTTPS có hoạt động và chứng chỉ SSL hợp lệ hay không.
➜ Bản ghi www có hoạt động nếu đã cấu hình.
➜ Nội dung website có hiển thị đúng như tên miền gốc.
➜ Không có lỗi redirect vòng lặp hoặc lỗi Mixed Content.

MẸO:
Nếu Alias truy cập được nhưng SSL chưa hoạt động, hãy kiểm tra
DNS A/AAAA, trạng thái chứng chỉ và thực hiện cấp SSL lại.
```

---

## Xóa Parked Alias domain (`wptt-xoa-alias-domain`)

- **Danh mục:** Quản lý Domain
- **Vị trí menu:** Menu chính › 2. Quản lý Domain › 5. Xóa Parked Alias domain  _(bấm lần lượt: 2 → 5)_
- **Tệp nguồn:** `/etc/wptt/domain/wptt-xoa-alias-domain`

```text
XÓA TÊN MIỀN PHỤ (PARKED DOMAIN / ALIAS DOMAIN)

Chức năng này cho phép gỡ bỏ một tên miền Alias đã được
thiết lập trước đó khỏi website WordPress trên OpenLiteSpeed.

Alias Domain là tên miền bổ sung sử dụng chung mã nguồn,
Document Root và Database với website gốc.

Ví dụ:
➜ Website gốc : wptangtoc.com
➜ Alias 1      : wptangtoc.vn
➜ Alias 2      : wptangtoc.net

Khi xóa Alias wptangtoc.vn, tên miền này sẽ được gỡ khỏi
cấu hình Virtual Host và Listener của OpenLiteSpeed.
Website gốc và Alias còn lại vẫn được giữ nguyên.

1. CHỨC NĂNG CHÍNH

➜ Hiển thị danh sách Alias Domain đang được cấu hình.
➜ Cho phép chọn chính xác Alias cần xóa theo số thứ tự.
➜ Yêu cầu xác nhận trước khi thực hiện thao tác.
➜ Gỡ Alias khỏi cấu hình Virtual Host của website gốc.
➜ Cập nhật lại Domain Mapping trên Listener máy chủ.
➜ Tự động xử lý cấu hình khi xóa Alias cuối cùng.
➜ Giữ nguyên các Alias khác chưa được chọn xóa.
➜ Kiểm tra cú pháp cấu hình OpenLiteSpeed trước khi reload.
➜ Tự động sao lưu cấu hình trước khi chỉnh sửa.
➜ Tự động hoàn nguyên cấu hình nếu kiểm tra hoặc reload thất bại.
➜ Ghi nhật ký thao tác để hỗ trợ quản trị và xử lý sự cố.

2. QUY TRÌNH XÓA ALIAS DOMAIN

Bước 1:
➜ Chọn website gốc muốn quản lý Alias Domain.

Bước 2:
➜ Hệ thống hiển thị danh sách Alias đang được thiết lập.

Bước 3:
➜ Nhập số thứ tự Alias muốn xóa.
➜ Nhập 0 để thoát hoặc hủy thao tác.

Bước 4:
➜ Kiểm tra lại tên miền Alias và website gốc.
➜ Xác nhận đồng ý xóa Alias.

Bước 5:
➜ Hệ thống sao lưu cấu hình hiện tại.
➜ Cập nhật cấu hình Virtual Host và Listener.
➜ Kiểm tra cú pháp bằng OpenLiteSpeed.

Bước 6:
➜ Nếu cấu hình hợp lệ, hệ thống reload OpenLiteSpeed.
➜ Nếu phát sinh lỗi, hệ thống sẽ cố gắng hoàn nguyên cấu hình
  trước đó để hạn chế ảnh hưởng đến các website đang hoạt động.

3. LƯU Ý QUAN TRỌNG TRƯỚC KHI XÓA

⚠️ Xóa Alias không đồng nghĩa với xóa website WordPress.

➜ Chỉ gỡ tên miền Alias khỏi cấu hình máy chủ.
➜ Không xóa mã nguồn WordPress của website gốc.
➜ Không xóa Database WordPress.
➜ Không xóa dữ liệu, bài viết, tài khoản hoặc Media.
➜ Không xóa website gốc.
➜ Không chủ động xóa chứng chỉ SSL Let's Encrypt hiện có.
➜ Các Alias khác của website gốc vẫn được giữ lại.

LƯU Ý:
Sau khi xóa Alias, tên miền đó sẽ không còn được ánh xạ
đến website gốc thông qua cấu hình OpenLiteSpeed đã cập nhật.

Nếu DNS vẫn trỏ về VPS, tên miền có thể không còn hiển thị
website này hoặc có thể được phục vụ bởi cấu hình khác
tùy thuộc vào cấu hình máy chủ.

4. TRƯỜNG HỢP XÓA ALIAS CUỐI CÙNG

Nếu website chỉ có một Alias Domain:

➜ Hệ thống gỡ dòng vhAliases khỏi Virtual Host.
➜ Domain Mapping được đưa về trạng thái chỉ sử dụng
  tên miền gốc.
➜ Website gốc tiếp tục hoạt động bình thường nếu cấu hình
  còn lại hợp lệ.

Nếu website còn nhiều Alias:

➜ Chỉ Alias được chọn mới bị loại bỏ.
➜ Danh sách Alias còn lại được cập nhật.
➜ Không chủ động thay đổi các Alias khác.

5. KHUYẾN NGHỊ SAU KHI XÓA
➜ Kiểm tra website gốc vẫn truy cập bình thường.
➜ Kiểm tra các Alias còn lại vẫn hoạt động.
➜ Nếu không còn sử dụng tên miền đã xóa, hãy cân nhắc
  cập nhật hoặc xóa bản ghi DNS tương ứng tại nhà cung cấp.
➜ Nếu Alias được sử dụng trong chiến dịch SEO hoặc quảng cáo,
  hãy kiểm tra các liên kết và cấu hình Redirect liên quan.
➜ Nếu cần sử dụng lại Alias, có thể thiết lập lại sau khi
  đảm bảo tên miền không bị xung đột với website khác.
```

---

## Chuyển hướng Domain (`wptt-chuyen-huong`)

- **Danh mục:** Quản lý Domain
- **Vị trí menu:** Menu chính › 2. Quản lý Domain › 6. Chuyển hướng Domain  _(bấm lần lượt: 2 → 6)_
- **Tệp nguồn:** `/etc/wptt/domain/wptt-chuyen-huong`

```text
Tính năng Chuyển hướng domain [Domain Redirection] là một kỹ thuật tự động điều hướng người dùng và các công cụ tìm kiếm từ một địa chỉ tên miền này sang một địa chỉ tên miền khác.

Nói một cách đơn giản, khi ai đó gõ vào hoặc nhấp vào một tên miền A, thay vì hiển thị nội dung của tên miền A, trình duyệt của họ sẽ tự động được chuyển đến tên miền B [hoặc một trang cụ thể trên tên miền B].

Mục Đích Chính
* Trỏ nhiều tên miền về một website: Nếu bạn sở hữu nhiều biến thể tên miền [ví dụ: tencongty.com, tencongty.vn, ten-cong-ty.com], bạn có thể chuyển hướng tất cả chúng về một tên miền chính duy nhất.
* Sau khi đổi tên miền website: Chuyển hướng từ tên miền cũ sang tên miền mới để không mất khách truy cập và duy trì giá trị SEO.
* Chuyển hướng tên miền phụ [subdomain]: Ví dụ, chuyển blog.tenmien.com sang blog-tenmien.com.
* URL thân thiện/Rút gọn link: Tạo các đường link ngắn, dễ nhớ để chuyển hướng đến các URL dài hơn, phức tạp hơn.
* Thông báo bảo trì website: Tạm thời chuyển hướng người dùng đến một trang thông báo khi website đang được bảo trì.

Tính năng chuyển hướng domain rất quan trọng để quản lý truy cập, đảm bảo trải nghiệm người dùng tốt và duy trì hiệu quả SEO cho website của bạn.
```

---

## Xóa chuyển hướng Domain (`wptt-xoa-domain-chuyen-huong`)

- **Danh mục:** Quản lý Domain
- **Vị trí menu:** Menu chính › 2. Quản lý Domain › 7. Xóa chuyển hướng Domain  _(bấm lần lượt: 2 → 7)_
- **Tệp nguồn:** `/etc/wptt/domain/wptt-xoa-domain-chuyen-huong`

```text
Tính năng Xóa chuyển hướng domain là quá trình gỡ bỏ hoặc vô hiệu hóa một cài đặt đã được thiết lập trước đó để tự động điều hướng người dùng và công cụ tìm kiếm từ một tên miền này sang một tên miền khác.

Nói một cách đơn giản, đây là hành động dừng việc tự động chuyển tiếp từ tên miền A sang tên miền B. Sau khi xóa chuyển hướng, khi người dùng truy cập vào tên miền A, họ sẽ không còn bị tự động đưa đến tên miền B nữa.

Mục Đích Chính
* Khôi phục nội dung gốc: Khi bạn muốn tên miền đang bị chuyển hướng [ví dụ: tên miền A] bắt đầu hiển thị nội dung riêng của nó, thay vì trỏ sang nơi khác.
* Thay đổi đích đến của chuyển hướng: Nếu bạn muốn tên miền A chuyển hướng đến một tên miền C hoàn toàn mới, bạn có thể cần xóa chuyển hướng cũ [sang B] trước khi thiết lập chuyển hướng mới [sang C].
* Hủy bỏ việc gộp tên miền: Nếu trước đó bạn gộp nhiều tên miền về một, nay muốn tách chúng ra hoạt động độc lập.
* Gỡ lỗi: Nếu chuyển hướng đang gây ra lỗi [ví dụ: vòng lặp chuyển hướng, sai đích] thì việc xóa bỏ nó là cần thiết để khắc phục.
* Không còn nhu cầu: Khi việc chuyển hướng không còn cần thiết nữa [ví dụ: tên miền đích không còn tồn tại, chiến dịch marketing đã kết thúc].
```

---

## Thay đổi username (`wptt-thay-doi-user`)

- **Danh mục:** Quản lý Domain
- **Vị trí menu:** Menu chính › 2. Quản lý Domain › 8. Thay đổi username  _(bấm lần lượt: 2 → 8)_
- **Tệp nguồn:** `/etc/wptt/domain/wptt-thay-doi-user`

```text
Đây là tính năng thay đổi username
mỗi một website khi được thêm thì sẽ khởi tạo một username riêng.
Tính năng này để thay đổi username
```

---

## Bật/Tắt đăng nhập username riêng domain (`wptt-khoi-tao-user`)

- **Danh mục:** Quản lý Domain
- **Vị trí menu:** Menu chính › 2. Quản lý Domain › 9. Bật/Tắt đăng nhập username riêng domain  _(bấm lần lượt: 2 → 9)_
- **Vị trí menu:** Menu chính › 9. Quản lý SSH/SFTP › 5. Bật/Tắt đăng nhập username riêng domain  _(bấm lần lượt: 9 → 5)_
- **Tệp nguồn:** `/etc/wptt/domain/wptt-khoi-tao-user`

```text
Đây là tính năng khởi tạo đăng nhập username riêng.
Rất hữu ích ví dụ: trên hệ thống của bạn có 10 website, bạn thuê IT ngoài xử lý công việc gì đó trong 1 website thôi.
Thì đưa cho họ tài khoản root thì quá nguy hiểm họ có toàn quyền kiểm soát cả 10 web. Tính năng này ra đời giải quyết vấn đề đó, bạn chỉ cấp cho họ tài khoản username riêng domain này, họ chỉ có quyền kiểm soát 1 website đó mà thôi và không có quyền tác động vào 9 website còn lại.
Giúp nâng cao bảo mật tuyệt đối bằng công nghệ Chroot Jail.
```

---

## Khởi tạo subfolder website (`wptt-subfolder-website`)

- **Danh mục:** Quản lý Domain
- **Vị trí menu:** Menu chính › 2. Quản lý Domain › 10. Khởi tạo subfolder website  _(bấm lần lượt: 2 → 10)_
- **Tệp nguồn:** `/etc/wptt/domain/wptt-subfolder-website`

```text
Đây là tính năng khởi tạo subfolder website
Ví dụ: bạn có website A.com bạn sử dụng tính năng này để khởi tạo một website A.com/abc [abc là subfolder được tính là một website riêng - abc là do bạn thiết lập - nhìn nó như là một url bình thường của trong 1 domain nhưng thực tế nó là một website riêng biệt]
```

---

## Mở/Khóa Domain (`wptt-bat-tat-domain`)

- **Danh mục:** Quản lý Domain
- **Vị trí menu:** Menu chính › 2. Quản lý Domain › 12. Mở/Khóa Domain  _(bấm lần lượt: 2 → 12)_
- **Tệp nguồn:** `/etc/wptt/domain/wptt-bat-tat-domain`

```text
🔒 TÍNH NĂNG: TẠM KHÓA / KÍCH HOẠT LẠI WEBSITE
Đây là công cụ giúp bạn ngay lập tức NGỪNG HOẠT ĐỘNG hoặc MỞ LẠI một 
website (hoặc toàn bộ website trên máy chủ) chỉ với một thao tác. 

🛡️ AN TOÀN TUYỆT ĐỐI - KHÔNG XÓA DỮ LIỆU:
Tính năng này KHÔNG xóa bất kỳ file mã nguồn hay cơ sở dữ liệu nào của bạn. 
Khi bạn chọn "Tạm khóa", hệ thống sẽ thực hiện các bước bảo mật cấp cao:
 ➜ Đóng băng mã nguồn: Thu hồi quyền của User, chuyển sở hữu về cho 
    `root` và đưa quyền truy cập về `000` (Không đọc - Không ghi - Không chạy).
 ➜ Ngắt kết nối Server: Ẩn cấu hình VHost khỏi OpenLiteSpeed, khiến 
    website lập tức báo lỗi ngắt kết nối (hoặc không tìm thấy) trên trình duyệt.
 ➜ Tiêu diệt tiến trình: Bắt buộc dừng mọi luồng xử lý ngầm (PHP) của 
    website đó để giải phóng hoàn toàn tài nguyên CPU/RAM (pkill).
 ➜ Dọn dẹp bộ nhớ đệm: Xóa sạch LSCache để đảm bảo không bị rò rỉ dữ liệu cũ.

🚀 ỨNG DỤNG THỰC TẾ:
 - Khi website bị tấn công (DDoS, Malware) và bạn cần cách ly gấp.
 - Khi bạn muốn tạm đóng cửa website chưa dùng đến để tiết kiệm RAM/CPU 
   cho các website khác trên máy chủ.
 - Khóa nhanh hàng loạt website khi bàn giao hoặc bảo trì Server.
```

---

## Kiểm tra hoạt động các website (`wptt-kiemtra-hoat-dong`)

- **Danh mục:** Quản lý Domain
- **Vị trí menu:** Menu chính › 2. Quản lý Domain › 13. Kiểm tra hoạt động các website  _(bấm lần lượt: 2 → 13)_
- **Tệp nguồn:** `/etc/wptt/domain/wptt-kiemtra-hoat-dong`

```text
Tính năng Kiểm tra Hoạt động Website thời gian thực (Realtime Uptime & TTFB Monitor):
* Theo dõi liên tục trạng thái Online/Offline, chẩn đoán DNS và độ trễ phản hồi (TTFB) của toàn bộ website.
* Mỗi website cập nhật ngay khi quét xong, kèm biểu đồ lịch sử 10 lần quét gần nhất và % Uptime.
* Hỗ trợ Bộ lọc tức thời (chỉ xem web Lỗi/Offline, Chậm, Online...) và Sắp xếp gom nhóm nhanh.
* Khi nhấn [Space] Tạm dừng, màn hình được đóng băng tĩnh 100% để bôi đen Copy trên Bitvise/PuTTY.
* Phím tắt: [q] thoát | [r] quét ngay | [f] hoặc [0-5] lọc trạng thái | [s] đổi cách sắp xếp
            [i] chú thích | [d] chế độ gọn | [Space] dừng để copy | [←][→] đổi trang.
```

---

## Thiết lập Cloudflare API DNS (`cloudflare-api-dns`)

- **Danh mục:** Quản lý SSL
- **Vị trí menu:** Menu chính › 3. Quản lý SSL › 3. Kết nối Cloudflare DNS API Let’s Encrypt › 1. Thiết lập Cloudflare API DNS  _(bấm lần lượt: 3 → 3 → 1)_
- **Tệp nguồn:** `/etc/wptt/ssl/cloudflare-api-dns`

```text
Tính năng SSL Lets Encrypt [sử dụng] Cloudflare API DNS là một phương pháp tự động hóa việc xin cấp và gia hạn chứng chỉ SSL miễn phí từ Lets Encrypt bằng cách sử dụng API [giao diện lập trình ứng dụng] của Cloudflare để xác thực quyền sở hữu tên miền thông qua bản ghi DNS.

Nói một cách đơn giản, thay vì phải tạo file trên web server để Lets Encrypt kiểm tra [phương pháp HTTP-01], bạn cho phép một công cụ [như Certbot, acme.sh] tự động thêm và xóa các bản ghi TXT đặc biệt trong cài đặt DNS của tên miền bạn trên Cloudflare. Lets Encrypt sẽ kiểm tra các bản ghi DNS này để xác nhận bạn là chủ sở hữu tên miền và cấp chứng chỉ.

Mục Đích Chính và Lợi Ích
* Tự động hóa hoàn toàn: Toàn bộ quá trình từ xác thực, xin cấp đến gia hạn chứng chỉ có thể được tự động hóa hoàn toàn, kể cả với chứng chỉ wildcard.
* Không cần thay đổi web server: Không yêu cầu web server phải truy cập được từ bên ngoài hoặc phải đặt file xác thực lên đó. Hữu ích khi web server nằm sau tường lửa chặt chẽ tường lửa chặn quốc gia hoặc webserver chưa công khai.
* Bảo mật với API Token: Cloudflare cho phép tạo API token với quyền hạn chế [chỉ cho phép sửa đổi bản ghi DNS của một zone cụ thể], an toàn hơn so với việc dùng Global API Key.
* Thuận tiện cho người dùng Cloudflare: Nếu bạn đã sử dụng Cloudflare làm nhà cung cấp DNS, việc này giữ mọi thứ trong cùng một hệ sinh thái.
```

---

## Xóa thiết lập Cloudflare API DNS (`cloudflare-api-dns-xoa`)

- **Danh mục:** Quản lý SSL
- **Vị trí menu:** Menu chính › 3. Quản lý SSL › 3. Kết nối Cloudflare DNS API Let’s Encrypt › 2. Xóa thiết lập Cloudflare API DNS  _(bấm lần lượt: 3 → 3 → 2)_
- **Tệp nguồn:** `/etc/wptt/ssl/cloudflare-api-dns-xoa`

```text
Xoá thiết lập cài ssl letsencrypt miễn phí bằng DNS API Cloudflare
đây là hành động cắt đứt kết nối và quyền hạn mà bạn đã cấp cho công cụ quản lý SSL để nó tương tác với tài khoản Cloudflare của bạn cho việc quản lý bản ghi DNS liên quan đến xác thực SSL.

Mục Đích Chính
* Thay đổi phương thức xác thực: Khi bạn muốn chuyển từ xác thực qua DNS với Cloudflare API sang phương thức khác [ví dụ: HTTP-01] hoặc sử dụng một nhà cung cấp DNS khác.
* Ngừng sử dụng Cloudflare cho việc này: Nếu bạn không còn muốn Cloudflare quản lý DNS cho tên miền đó hoặc không muốn dùng API của họ cho mục đích này nữa.
* Gỡ bỏ tên miền/máy chủ: Khi tên miền hoặc máy chủ sử dụng thiết lập này không còn hoạt động.
* Lo ngại về bảo mật: Nếu API token/key của Cloudflare bị lộ hoặc nghi ngờ bị xâm phạm, bạn cần hủy thiết lập và thu hồi token.
* Không còn cần chứng chỉ wildcard: Nếu bạn không còn nhu cầu sử dụng chứng chỉ wildcard [thường yêu cầu xác thực DNS].
* Dọn dẹp cấu hình: Loại bỏ các thiết lập cũ, không còn sử dụng.

Sau khi thực hiện tính năng này, hệ thống sẽ không còn tự động sử dụng Cloudflare API để xin cấp hay gia hạn SSL Lets Encrypt cho tên miền đó nữa.
```

---

## Quản lý SSL (`wptt-ssl-main`)

- **Danh mục:** Quản lý SSL
- **Vị trí menu:** Menu chính › 3. Quản lý SSL  _(bấm lần lượt: 3)_
- **Tệp nguồn:** `/etc/wptt/wptt-ssl-main`

```text
Tính năng quản lý SSL của WPTangToc OLS là một công cụ tích hợp giúp người dùng dễ dàng cài đặt, cấu hình và tự động gia hạn chứng chỉ SSL cho các website trên máy chủ OpenLiteSpeed.

Giới thiệu ngắn gọn:
Mục đích: Đơn giản hóa việc kích hoạt HTTPS cho website, đảm bảo kết nối được mã hóa an toàn, tăng cường bảo mật và cải thiện uy tín cũng như thứ hạng SEO cho website.
Cách hoạt động:
* Cài đặt SSL miễn phí: Tự động hóa quá trình yêu cầu và cài đặt chứng chỉ SSL từ Lets Encrypt cho một hoặc nhiều tên miền/tên miền phụ.
* Tự động gia hạn: Tự động theo dõi và gia hạn chứng chỉ SSL trước khi hết hạn, đảm bảo website luôn có SSL hợp lệ mà không cần can thiệp thủ công.
* Buộc HTTPS: Dễ dàng cấu hình chuyển hướng tự động từ HTTP sang HTTPS.
* Cài đặt ssl trả phí.
* Kiểm tra chứng chỉ SSL.
* Quản lý chứng chỉ: Có thể bao gồm các tùy chọn để xem thông tin chứng chỉ hoặc gỡ bỏ SSL.

Lợi ích:
* Bảo mật: Mã hóa dữ liệu truyền tải giữa máy chủ và người dùng.
* Tin cậy: Xây dựng lòng tin với khách truy cập thông qua biểu tượng ổ khóa an toàn.
* SEO: HTTPS là một yếu tố xếp hạng của Google.
* Miễn phí và tự động: Tiết kiệm chi phí mua SSL và công sức quản lý, gia hạn thủ công, đặc biệt với Lets Encrypt.
* Dễ sử dụng: Đơn giản hóa quy trình kỹ thuật phức tạp của việc cài đặt và duy trì SSL.

Tính năng này giúp người dùng WPTangToc OLS nhanh chóng bảo mật các website của mình bằng HTTPS một cách hiệu quả và không tốn nhiều công sức.
```

---

## Cài đặt SSL FREE Let’s Encrypt (`wptt-caissl`)

- **Danh mục:** Quản lý SSL
- **Vị trí menu:** Menu chính › 3. Quản lý SSL › 1. Cài đặt SSL FREE Let’s Encrypt  _(bấm lần lượt: 3 → 1)_
- **Tệp nguồn:** `/etc/wptt/ssl/wptt-caissl`

```text
Cài đặt SSL miễn phí: Dễ dàng cài đặt chứng chỉ SSL từ Lets Encrypt cho các tên miền của bạn mà không tốn chi phí.

Tính năng Cài SSL Lets Encrypt là cài đặt chứng chỉ SSL/TLS miễn phí từ Lets Encrypt cho website của bạn, qua đó kích hoạt giao thức HTTPS [kết nối an toàn, mã hóa].

Nói một cách đơn giản, đây là cách để website của bạn có biểu tượng ổ khóa 🔒 trên trình duyệt, đảm bảo dữ liệu truyền đi giữa người dùng và website được bảo mật, và thường được thực hiện một cách tự động hoặc rất đơn giản.

Mục Đích Chính
* Bảo mật dữ liệu: Mã hóa thông tin trao đổi [như mật khẩu, thông tin cá nhân, thẻ tín dụng] giữa trình duyệt của người dùng và website.
* Xác thực website: Giúp khẳng định website là đáng tin cậy, không phải trang giả mạo [đối với loại chứng chỉ Domain Validation - DV mà Lets Encrypt cung cấp].
* Cải thiện SEO: Các công cụ tìm kiếm như Google ưu tiên các website sử dụng HTTPS.
* Tăng uy tín: Người dùng cảm thấy an tâm hơn khi truy cập website có HTTPS.

Tính năng cài đặt SSL Lets Encrypt giúp việc bảo mật website trở nên dễ dàng, miễn phí và tự động, góp phần làm cho Internet an toàn hơn.
```

---

## Mở rộng chứng chỉ SSL FREE Let’s Encrypt (`wptt-mo-rong-ssl-free`)

- **Danh mục:** Quản lý SSL
- **Vị trí menu:** Menu chính › 3. Quản lý SSL › 2. Mở rộng chứng chỉ SSL FREE Let’s Encrypt  _(bấm lần lượt: 3 → 2)_
- **Tệp nguồn:** `/etc/wptt/ssl/wptt-mo-rong-ssl-free`

```text
WPTangToc OLS có khả năng mở rộng SSL Lets Encrypt.

Về cơ bản, tính năng này cho phép bạn:

Cài đặt SSL letsencrypt mở rộng kết hợp chứng chỉ của bạn trước sẵn có.
Giải thích: ví dụ bạn có domain là wptangtoc.com đã được cài chứng chỉ ssl letsencrypt trước đó giờ bạn muốn mở rộng thêm chứng chỉ sub.wptangtoc.com một chứng chỉ có thể hỗ trợ đồng thời cho 2 domain trở lên tận chí là nhiều hơn bạn muốn.

Tóm lại: một chứng chỉ ssl chỉ dành cho một domain như thông lệ mà tính năng này giúp một chứng chỉ có thể dùng chung cho nhiều domain

Mục đich tính năng mở rộng SSL Lets Encrypt trong WPTangToc OLS giúp người dùng dễ dàng triển khai và duy trì mã hóa HTTPS cho website của mình một cách tự động và miễn phí, góp phần tăng cường bảo mật và sự tin cậy cho trang web.

Tính năng này rất hữu ích với anh em sử dụng multisite subdomain
```

---

## Kết nối Cloudflare DNS API Let’s Encrypt (`cloudflare-api-dns-main`)

- **Danh mục:** Quản lý SSL
- **Vị trí menu:** Menu chính › 3. Quản lý SSL › 3. Kết nối Cloudflare DNS API Let’s Encrypt  _(bấm lần lượt: 3 → 3)_
- **Tệp nguồn:** `/etc/wptt/ssl/cloudflare-api-dns-main`

```text
Tính năng SSL Lets Encrypt [sử dụng] Cloudflare API DNS là một phương pháp tự động hóa việc xin cấp và gia hạn chứng chỉ SSL miễn phí từ Lets Encrypt bằng cách sử dụng API [giao diện lập trình ứng dụng] của Cloudflare để xác thực quyền sở hữu tên miền thông qua bản ghi DNS.

Nói một cách đơn giản, thay vì phải tạo file trên web server để Lets Encrypt kiểm tra [phương pháp HTTP-01], bạn cho phép một công cụ [như Certbot, acme.sh] tự động thêm và xóa các bản ghi TXT đặc biệt trong cài đặt DNS của tên miền bạn trên Cloudflare. Lets Encrypt sẽ kiểm tra các bản ghi DNS này để xác nhận bạn là chủ sở hữu tên miền và cấp chứng chỉ.

Mục Đích Chính và Lợi Ích
* Tự động hóa hoàn toàn: Toàn bộ quá trình từ xác thực, xin cấp đến gia hạn chứng chỉ có thể được tự động hóa hoàn toàn, kể cả với chứng chỉ wildcard.
* Không cần thay đổi web server: Không yêu cầu web server phải truy cập được từ bên ngoài hoặc phải đặt file xác thực lên đó. Hữu ích khi web server nằm sau tường lửa chặn quốc gia hoặc webserver chưa công khai.
* Bảo mật với API Token: Cloudflare cho phép tạo API token với quyền hạn chế [chỉ cho phép sửa đổi bản ghi DNS của một zone cụ thể], an toàn hơn so với việc dùng Global API Key.
* Thuận tiện cho người dùng Cloudflare: Nếu bạn đã sử dụng Cloudflare làm nhà cung cấp DNS, việc này giữ mọi thứ trong cùng một hệ sinh thái.
```

---

## Gia hạn thủ công chứng chỉ SSL FREE Let’s Encrypt & Paid ACME EAB (`wptt-gia-han-ssl`)

- **Danh mục:** Quản lý SSL
- **Vị trí menu:** Menu chính › 3. Quản lý SSL › 4. Gia hạn thủ công chứng chỉ SSL FREE Let’s Encrypt & Paid ACME EAB  _(bấm lần lượt: 3 → 4)_
- **Tệp nguồn:** `/etc/wptt/ssl/wptt-gia-han-ssl`

```text
Gia hạn chứng chỉ SSL thủ công: Tính năng này sẽ kiểm tra và yêu cầu gia hạn toàn bộ chứng chỉ SSL Let's Encrypt miễn phí cũng như chứng chỉ Google Trust Services (GTS), ZeroSSL, Sectigo, DigiCert... (ACME EAB) trên máy chủ.

Ghi chú: Mặc định WPTangToc OLS đã có cơ chế tự động gia hạn ngầm vĩnh viễn qua Cron / Systemd Timer.
Nếu vì lý do sự cố mạng tạm thời, tường lửa chặn IP quốc tế hoặc lỗi DNS vừa mới khắc phục xong, bạn có thể sử dụng tính năng này để chủ động kích hoạt gia hạn và kiểm tra báo cáo chi tiết ngay lập tức.
```

---

## Xóa chứng chỉ SSL FREE Let’s Encrypt (`wptt-xoa-ssl`)

- **Danh mục:** Quản lý SSL
- **Vị trí menu:** Menu chính › 3. Quản lý SSL › 5. Xóa chứng chỉ SSL FREE Let’s Encrypt  _(bấm lần lượt: 3 → 5)_
- **Tệp nguồn:** `/etc/wptt/ssl/wptt-xoa-ssl`

```text
Tính năng Xóa SSL Lets Encrypt là quá trình gỡ bỏ một chứng chỉ SSL/TLS của Lets Encrypt đã được cài đặt cho một tên miền [website] cụ thể khỏi máy chủ web. Đồng thời, việc này thường bao gồm cả việc vô hiệu hóa cấu hình HTTPS liên quan đến chứng chỉ đó và có thể dừng tiến trình tự động gia hạn cho chứng chỉ này.

Nói một cách đơn giản, đây là hành động gỡ bỏ ổ khóa 🔒 Lets Encrypt khỏi website của bạn, khiến website đó không còn sử dụng kết nối mã hóa HTTPS thông qua chứng chỉ Lets Encrypt đó nữa.

Mục Đích Chính
* Khi ngừng sử dụng website/tên miền: Nếu website không còn hoạt động, chứng chỉ SSL của nó cũng không còn cần thiết.
* Chuyển sang loại chứng chỉ SSL khác: Khi bạn muốn sử dụng chứng chỉ từ một nhà cung cấp khác [ví dụ: chứng chỉ trả phí có xác thực tổ chức - OV, hoặc xác thực mở rộng - EV].
* Gỡ lỗi sự cố SSL phức tạp: Trong một số trường hợp, việc xóa và cài đặt lại có thể là một bước để khắc phục sự cố.
* Cấu hình lại máy chủ: Khi có những thay đổi lớn về cấu hình máy chủ hoặc chuyển đổi máy chủ.
* Ngừng gia hạn tự động cho một tên miền cụ thể: Nếu bạn không muốn tên miền đó tiếp tục sử dụng HTTPS với Lets Encrypt.

Sau khi xóa, website sẽ không còn phục vụ qua HTTPS bằng chứng chỉ Lets Encrypt đó nữa. Nếu không có chứng chỉ nào khác được cấu hình, truy cập HTTPS sẽ thất bại, và website có thể chỉ truy cập được qua HTTP [không mã hóa].
```

---

## Thiết lập chứng chỉ SSL thương mại (ZeroSSL,GTS,Sectigo...) (`wptt-caissl-traphi`)

- **Danh mục:** Quản lý SSL
- **Vị trí menu:** Menu chính › 3. Quản lý SSL › 6. Thiết lập chứng chỉ SSL thương mại (ZeroSSL,GTS,Sectigo...)  _(bấm lần lượt: 3 → 6)_
- **Tệp nguồn:** `/etc/wptt/ssl/wptt-caissl-traphi`

```text
Tính năng Cài đặt SSL trả phí, Google Trust Services (GTS) & ZeroSSL là quá trình trang bị cho website của bạn một chứng chỉ SSL/TLS thương mại [mua từ DigiCert, Sectigo, GlobalSign, SSL.com hoặc cấp phát qua Google Trust Services / ZeroSSL] để kích hoạt giao thức HTTPS, đảm bảo kết nối mã hóa và xác thực danh tính website ở mức độ cao hơn.

Nói một cách đơn giản, đây là việc bạn đầu tư một giấy phép bảo mật cao cấp hoặc sử dụng nguồn CA thương mại uy tín (Google / ZeroSSL / Sectigo) hoàn toàn độc lập với Let's Encrypt.

Mục Đích Chính
* Cài đặt ZeroSSL Tự động 100% (1-Chạm như Let's Encrypt): Tự động sinh mã EAB qua API và cấp phát ngay lập tức mà không cần đăng ký tài khoản hay nhập liệu thủ công.
* Tích hợp Google Trust Services (GTS - Public CA của Google): Tốc độ xác thực siêu nhanh, độ tin cậy cao nhất trên Chrome/Android, tự động tái sử dụng tài khoản ACME cho các tên miền tiếp theo trên cùng VPS.
* Hỗ trợ Tự động hóa tái cấp & gia hạn SSL Trả phí bằng Certbot qua chuẩn quốc tế ACME EAB [External Account Binding] của Sectigo, DigiCert, GlobalSign, SSL.com...
* Hoạt động song song dưới định danh riêng (${NAME}-paid), tương thích 100% với trình gia hạn tự động của WPTangToc OLS mà không xóa chứng chỉ Let's Encrypt miễn phí sẵn có.
* Tích hợp bộ kiểm tra tiền trạm DNS (IPv4/IPv6 AAAA, Cloudflare Proxy, xung đột Port 80) giúp ngăn chặn lỗi hỏng đơn hàng EAB.
```

---

## Kiểm tra chứng chỉ SSL đang sử dụng (`wptt-kiem-tra-ssl`)

- **Danh mục:** Quản lý SSL
- **Vị trí menu:** Menu chính › 3. Quản lý SSL › 7. Kiểm tra chứng chỉ SSL đang sử dụng  _(bấm lần lượt: 3 → 7)_
- **Tệp nguồn:** `/etc/wptt/ssl/wptt-kiem-tra-ssl`

```text
Tính năng Kiểm tra chứng chỉ SSL website là khả năng xem xét và xác minh các thông tin chi tiết của chứng chỉ SSL/TLS mà một trang web đang sử dụng để thiết lập kết nối HTTPS an toàn. Điều này giúp bạn đánh giá tính hợp lệ và độ tin cậy của kết nối đó.

Nói một cách đơn giản, đây là cách bạn soi xem giấy phép bảo mật [chứng chỉ SSL] của một website có những thông tin gì, có còn hạn hay không, và do ai cấp.

Mục Đích Chính
* Xác minh danh tính website: Đảm bảo bạn đang kết nối đúng với website mình muốn, không phải trang giả mạo.
* Kiểm tra thời hạn chứng chỉ: Xem ngày cấp và quan trọng nhất là ngày hết hạn để biết chứng chỉ có còn hiệu lực không.
* Biết được đơn vị cấp [CA]: Xem tổ chức nào đã cấp chứng chỉ [ví dụ: Lets Encrypt, DigiCert, Sectigo].
* Gỡ lỗi sự cố HTTPS: Khi website báo lỗi kết nối SSL [ví dụ: trình duyệt cảnh báo không an toàn], việc kiểm tra chứng chỉ giúp tìm ra nguyên nhân.
* Đánh giá mức độ bảo mật: Xem các thông tin kỹ thuật của chứng chỉ như thuật toán chữ ký, độ dài khóa.
```

---

## Renew thiết lập lại [HTTP to HTTPS] (`wptt-renew-chuyen-huong`)

- **Danh mục:** Quản lý SSL
- **Vị trí menu:** Menu chính › 3. Quản lý SSL › 8. Renew thiết lập lại [HTTP to HTTPS]  _(bấm lần lượt: 3 → 8)_
- **Tệp nguồn:** `/etc/wptt/ssl/wptt-renew-chuyen-huong`

```text
WPTangToc OLS có tính năng Renew thiết lập lại chuyển hướng HTTP to HTTPS, thì đây là một chức năng quan trọng giúp bạn kiểm tra, sửa chữa và áp dụng lại một cách dứt khoát quy tắc chuyển hướng toàn bộ truy cập từ giao thức http:// không an toàn sang https:// an toàn cho website của bạn.

Nhấn mạnh rằng tính năng này không chỉ tạo mới mà còn có khả năng khôi phục hoặc sửa chữa một cấu hình chuyển hướng có thể đã bị lỗi hoặc thay đổi trước đó.

Tính năng Renew [Làm mới] / Thiết lập lại Chuyển hướng HTTP to HTTPS
🔒 Mục đích chính:
* Sửa lỗi Chuyển hướng: Khắc phục các tình huống mà việc tự động chuyển từ HTTP sang HTTPS bị hỏng, không hoạt động hoặc hoạt động không chính xác do thay đổi cấu hình, cập nhật hoặc lỗi nào đó.
* Đảm bảo Tính Đúng đắn: Xác minh và áp dụng lại quy tắc chuyển hướng theo phương pháp chuẩn [thường là 301 Permanent Redirect] mà công cụ WPTangToc OLS khuyên dùng.
* Tiêu chuẩn hóa Cấu hình: Đảm bảo tất cả các website được quản lý đều áp dụng một cơ chế chuyển hướng HTTPS đồng nhất và hiệu quả.
* Đơn giản hóa Quản lý: Cung cấp một nút bấm hoặc lệnh duy nhất để xử lý toàn bộ việc enforces HTTPS, thay vì phải can thiệp thủ công vào cấu hình OpenLiteSpeed.
* Hỗ trợ Sau khi Cài/Gia hạn SSL: Là một bước cần thiết sau khi bạn cài đặt hoặc gia hạn thành công chứng chỉ SSL để đảm bảo website ngay lập tức sử dụng nó.

Tóm lại: Tính năng Renew thiết lập lại chuyển hướng HTTP to HTTPS trong WPTangToc OLS là một công cụ mạnh mẽ và tiện lợi, giúp bạn đảm bảo rằng website của mình luôn hoạt động một cách an toàn và nhất quán trên giao thức HTTPS, đồng thời dễ dàng sửa chữa các lỗi cấu hình liên quan.
```

---

## Xóa chứng chỉ SSL thương mại (`wptt-caissl-traphi-xoa`)

- **Danh mục:** Quản lý SSL
- **Vị trí menu:** Menu chính › 3. Quản lý SSL › 9. Xóa chứng chỉ SSL thương mại  _(bấm lần lượt: 3 → 9)_
- **Tệp nguồn:** `/etc/wptt/ssl/wptt-caissl-traphi-xoa`

```text
Tính năng Xóa SSL trả phí là quá trình gỡ bỏ một chứng chỉ SSL/TLS thương mại [mà bạn đã mua từ các nhà cung cấp như DigiCert, Sectigo, Comodo] hoặc chứng chỉ cấp qua ACME EAB [Google Trust Services (GTS), ZeroSSL] khỏi máy chủ web cho một tên miền cụ thể.

Nói một cách đơn giản, đây là hành động gỡ bỏ giấy phép bảo mật hiện tại khỏi website của bạn và tự động chuyển đổi an toàn về chứng chỉ Let's Encrypt miễn phí sẵn có (hoặc chứng chỉ Tự ký bảo vệ Socket 443 của OpenLiteSpeed).

Mục Đích Chính
* Chứng chỉ hết hạn và không gia hạn: Chuyển về Let's Encrypt miễn phí hoặc ngừng sử dụng gói trả phí.
* Ngắt chu kỳ gia hạn tự động ACME EAB (${NAME}-paid) của Google Trust Services (GTS) / ZeroSSL / Sectigo / DigiCert.
* Thay đổi nhà cung cấp: Làm sạch cấu hình SSL cũ để nạp chứng chỉ mới.
* Sự cố khóa bí mật: Khóa riêng tư (.key) bị lộ, cần thu hồi và gỡ bỏ ngay lập tức.
```

---

## Quản lý Database (`wptt-db-main`)

- **Danh mục:** Quản lý Database
- **Vị trí menu:** Menu chính › 4. Quản lý Database  _(bấm lần lượt: 4)_
- **Tệp nguồn:** `/etc/wptt/wptt-db-main`

```text
Tính năng quản lý Database của WPTangToc OLS là một công cụ được tích hợp sẵn, giúp người dùng dễ dàng thực hiện các thao tác cơ bản với cơ sở dữ liệu [MariaDB] trực tiếp từ dòng lệnh của script.

Giới thiệu ngắn gọn:

Mục đích: Đơn giản hóa việc tạo, xóa và quản lý cơ sở dữ liệu cũng như người dùng cơ sở dữ liệu cho các website, đặc biệt là website WordPress, mà không cần kiến thức sâu về dòng lệnh MySQL.
Cách hoạt động:
* Cung cấp menu hoặc các lệnh trực quan dễ sử dụng:
* Tạo Database mới: Nhanh chóng tạo một cơ sở dữ liệu mới cho website.
* Tạo User Database: Tạo người dùng mới và gán quyền truy cập cho cơ sở dữ liệu cụ thể.
* Xóa Database/User: Loại bỏ cơ sở dữ liệu hoặc người dùng không còn cần thiết.
* Đặt lại mật khẩu User Database: Thay đổi mật khẩu cho người dùng cơ sở dữ liệu.
* Tự động khởi tạo mariadb khi mariadb gặp sự cố.
* Sao lưu, Khôi phục database...
* v.v.v

Lợi ích:
* Tiện lợi: Thực hiện các tác vụ quản lý database cơ bản một cách nhanh chóng.
* Dễ sử dụng: Phù hợp với cả người dùng không chuyên về quản trị database.
* Tích hợp: Hoạt động liền mạch với quá trình tạo và quản lý website WordPress trong WPTangToc OLS.
* Bảo mật cơ bản: Hỗ trợ tạo người dùng với quyền hạn cụ thể cho từng database, thay vì dùng chung một tài khoản quản trị cao nhất.

Tính năng này giúp người dùng WPTangToc OLS quản lý các khía cạnh thiết yếu của cơ sở dữ liệu một cách hiệu quả, hỗ trợ tốt cho việc vận hành website.
```

---

## Thêm database (`wptt-them-database`)

- **Danh mục:** Quản lý Database
- **Vị trí menu:** Menu chính › 4. Quản lý Database › 1. Thêm database  _(bấm lần lượt: 4 → 1)_
- **Tệp nguồn:** `/etc/wptt/db/wptt-them-database`

```text
🗄️ TÍNH NĂNG: KHỞI TẠO CƠ SỞ DỮ LIỆU (ADD DATABASE)
Đây là công cụ giúp bạn tạo mới hoàn toàn một cơ sở dữ liệu (Database), 
đi kèm với một User độc lập và Mật khẩu siêu bảo mật (36 ký tự ngẫu nhiên) 
dành riêng cho một website cụ thể.

🚀 TÍNH NĂNG NỔI BẬT (SMART DETECTION):
Hệ thống được trang bị "Trạm Kiểm Lâm" thông minh tự động quét và phân 
loại Database khi khởi tạo:

 ➜ Cấp "Biên Chế" (Primary DB): Nếu website của bạn hoàn toàn trắng 
    Database, hoặc DB cũ bị lỗi/xóa mất ("DB Ma"), hệ thống sẽ gán DB 
    mới này làm Database chính thức cho website, mã hóa và lưu trữ tự 
    động vào tệp cấu hình hệ thống.
 ➜ Chế độ "Mồ Côi" (Standby DB): Nếu website đã có sẵn một DB chính 
    đang hoạt động ổn định, hệ thống sẽ bảo vệ DB cũ. DB mới tạo ra 
    sẽ đóng vai trò dự phòng (Standby) phục vụ cho việc clone web, 
    test staging hoặc Import dữ liệu tạm thời.

🛡️ BẢO MẬT TUYỆT ĐỐI: 
Cũng như mọi thao tác Database khác trên WPTangToc, luồng khởi tạo 
này được bảo vệ hoàn toàn khỏi Local SQL Injection và tiến trình lộ pass.
```

---

## Xoá database (`wptt-xoa-database`)

- **Danh mục:** Quản lý Database
- **Vị trí menu:** Menu chính › 4. Quản lý Database › 2. Xoá database  _(bấm lần lượt: 4 → 2)_
- **Tệp nguồn:** `/etc/wptt/db/wptt-xoa-database`

```text
Tính năng Xóa database [hay Xóa cơ sở dữ liệu] là hành động loại bỏ hoàn toàn một cơ sở dữ liệu cụ thể, bao gồm tất cả các bảng [tables], dữ liệu chứa trong đó, các chỉ mục [indexes] và cấu trúc liên quan khỏi máy chủ cơ sở dữ liệu [MariaDB]

Nói một cách đơn giản, đây là việc bạn vứt bỏ toàn bộ một kho chứa dữ liệu cùng với tất cả những gì bên trong nó.

Mục Đích Chính
* Loại bỏ database không còn sử dụng: Khi một website hoặc dự án không còn hoạt động, việc xóa database của nó giúp giải phóng dung lượng lưu trữ và tài nguyên máy chủ.
* Dọn dẹp database thử nghiệm/cũ: Xóa các database đã được tạo cho mục đích kiểm thử hoặc các phiên bản cũ không còn cần thiết.
* Làm lại từ đầu: Đôi khi cần xóa database cũ để tạo lại một database mới hoàn toàn cho một ứng dụng.
* Xóa dữ liệu vĩnh viễn: Khi cần loại bỏ hoàn toàn dữ liệu nhạy cảm không còn được phép lưu trữ.

Lưu ý quan trọng: LUÔN LUÔN SAO LƯU [BACKUP] TRƯỚC KHI XÓA: Hãy chắc chắn bạn có một bản sao lưu đầy đủ và còn tốt của database trước khi quyết định xóa.
```

---

## Danh sách database (`wptt-thongtin-db`)

- **Danh mục:** Quản lý Database
- **Vị trí menu:** Menu chính › 4. Quản lý Database › 3. Danh sách database  _(bấm lần lượt: 4 → 3)_
- **Tệp nguồn:** `/etc/wptt/db/wptt-thongtin-db`

```text
📊 TÍNH NĂNG: XEM DANH SÁCH & KIỂM TRA BIÊN CHẾ DATABASE
Thay vì phải đăng nhập phpMyAdmin hay gõ lệnh SQL thủ công rườm rà, 
tính năng này sẽ quét và cung cấp cho bạn bức tranh toàn cảnh về mọi 
Cơ sở dữ liệu (Database) đang tồn tại trên máy chủ MariaDB.

🚀 TÍNH NĂNG NỔI BẬT (SMART MAPPING):
 ➜ Tự động "Chỉ mặt đặt tên": Hệ thống sẽ rà soát chéo cấu hình Vhost 
    của toàn bộ website để báo cáo chính xác Database nào đang phục vụ 
    (thuộc biên chế) cho Website nào. Tránh tình trạng "nhìn tên DB 
    nhưng không biết của web nào".
 ➜ Phát hiện "Database Mồ Côi": Tự động phân lập các Database tự do, 
    bị bỏ quên hoặc không được gắn với bất kỳ website nào. Rất hữu ích 
    để dọn dẹp rác, giải phóng dung lượng ổ cứng mà không sợ xóa nhầm.
 ➜ Lọc nhiễu thông minh: Tự động ẩn các Database hệ thống (information_schema, 
    mysql, sys...) để bảng báo cáo sạch sẽ và tập trung vào dữ liệu của bạn.

🛡️ BẢO MẬT KẾT NỐI (SECURE CONNECTION):
Giao tiếp với MariaDB thông qua tệp cấu hình tạm thời (Temporary Config File) 
được mã hóa, đảm bảo an toàn tuyệt đối, không rò rỉ mật khẩu Root ra 
danh sách tiến trình máy chủ.
```

---

## Thông tin tài khoản database (`wptt-thongtin-db-tk`)

- **Danh mục:** Quản lý Database
- **Vị trí menu:** Menu chính › 4. Quản lý Database › 4. Thông tin tài khoản database  _(bấm lần lượt: 4 → 4)_
- **Tệp nguồn:** `/etc/wptt/db/wptt-thongtin-db-tk`

```text
Tính năng Xem thông tin tài khoản username database cho phép bạn xem chi tiết về các tài khoản người dùng [username] đã được tạo để truy cập và tương tác với cơ sở dữ liệu [database] trên máy chủ MariaDB.

Mục Đích Chính
* website nào được biến chế database, username database nào.
* Kiểm tra và đối chiếu: Hữu ích khi bạn quản lý nhiều website và cần kiểm tra xem database nào tương ứng với website nào.
* Quản lý người dùng: Biết được danh sách các user đang tồn tại để dễ dàng quản lý.
* Kiểm tra quyền hạn: Xem xét các quyền [ví dụ: SELECT, INSERT, UPDATE, DELETE, CREATE, ALL PRIVILEGES] đã được cấp cho từng username trên các database cụ thể.
* Bảo mật: Rà soát và đảm bảo các username chỉ có những quyền cần thiết, xóa bỏ user không dùng hoặc thu hồi quyền không phù hợp.
* Gỡ lỗi kết nối: Khi ứng dụng không kết nối được database, việc kiểm tra lại thông tin username và host kết nối của nó là rất quan trọng.
* Xác định user cho ứng dụng: Biết được ứng dụng nào đang sử dụng username nào để kết nối vào database.

Tính năng này rất cần thiết cho việc quản trị cơ sở dữ liệu, đảm bảo an toàn
```

---

## Xem dung lượng database (`wptt-dung-luong-database`)

- **Danh mục:** Quản lý Database
- **Vị trí menu:** Menu chính › 4. Quản lý Database › 5. Xem dung lượng database  _(bấm lần lượt: 4 → 5)_
- **Tệp nguồn:** `/etc/wptt/db/wptt-dung-luong-database`

```text
Tính năng Kiểm tra dung lượng database cho phép bạn xem được kích thước hiện tại mà cơ sở dữ liệu của bạn đang chiếm dụng.

Hệ thống sẽ tự động trích xuất thông tin Database từ file cấu hình Vhost tĩnh của tên miền, hỗ trợ xem chi tiết dung lượng của từng Bảng [Tables] bên trong để bạn dễ dàng dọn dẹp và tối ưu.
```

---

## Thay đổi password database (`wptt-thay-doi-passwd-database`)

- **Danh mục:** Quản lý Database
- **Vị trí menu:** Menu chính › 4. Quản lý Database › 6. Thay đổi password database  _(bấm lần lượt: 4 → 6)_
- **Tệp nguồn:** `/etc/wptt/db/wptt-thay-doi-passwd-database`

```text
Tính năng Thay đổi password database là quá trình cập nhật mật khẩu cho một tài khoản người dùng [username] cụ thể đã được tạo để truy cập và tương tác với cơ sở dữ liệu [database] trên máy chủ MariaDB.

Nói một cách đơn giản, đây là cách bạn đổi chìa khóa và ổ khoá cho một người gác cổng [user] của kho chứa dữ liệu [database] của bạn.

Mục Đích Chính
* Tăng cường bảo mật [quan trọng nhất]:
* Thay đổi mật khẩu định kỳ là một thói quen tốt.
* Cần đổi ngay nếu nghi ngờ mật khẩu cũ đã bị lộ.
* Khi nhân viên/người quản lý cũ nghỉ việc: Đổi mật khẩu của user mà họ sử dụng.
* Sau khi thiết lập ban đầu: Đặt một mật khẩu mạnh hơn cho user sau khi tạo.
* Tuân thủ chính sách mật khẩu: Đảm bảo mật khẩu đủ mạnh và phức tạp theo quy định.
```

---

## Kết nối database với Source (`wptt-ket-noi`)

- **Danh mục:** Quản lý Database
- **Vị trí menu:** Menu chính › 4. Quản lý Database › 7. Kết nối database với Source  _(bấm lần lượt: 4 → 7)_
- **Tệp nguồn:** `/etc/wptt/db/wptt-ket-noi`

```text
Tính năng Kết nối database tự động giúp mã nguồn [WordPress, Laravel, Joomla...] kết nối với MariaDB một cách mượt mà thông qua việc tự động chỉnh sửa các tệp tin cấu hình [wp-config.php, .env, configuration.php].

Mục Đích Chính
* Lưu trữ thông tin kết nối database: Tự động tiêm DB_NAME, DB_USER, DB_PASSWORD, DB_HOST vào đúng chuẩn của từng loại mã nguồn.
* Hỗ trợ Đa Mã Nguồn: Không chỉ giới hạn ở WordPress, hệ thống tự động nhận diện và cấu hình cho Laravel và Joomla.
* Giảm thao tác thủ công: Ngăn chặn triệt để lỗi "Error establishing a database connection" do gõ sai pass/user.
```

---

## Tối ưu database ALL (`all-database`)

- **Danh mục:** Quản lý Database
- **Vị trí menu:** Menu chính › 4. Quản lý Database › 10. Tối ưu database ALL  _(bấm lần lượt: 4 → 10)_
- **Tệp nguồn:** `/etc/wptt/wordpress/all-database`

```text
Tối ưu hoá toàn bộ database trong hệ thống
OPTIMIZE TABLE: Giải Pháp Tối Ưu Hóa Không Gian và Hiệu Suất Cơ Sở Dữ Liệu
Mục đích chính của OPTIMIZE TABLE:

* Giảm không gian lưu trữ: Sau nhiều thao tác chèn, cập nhật hoặc xóa dữ liệu, các bảng có thể bị phân mảnh hoặc chứa nhiều không gian không được sử dụng. OPTIMIZE TABLE giúp thu hồi lại không gian thừa này.
* Cải thiện hiệu quả I/O: Bằng cách chống phân mảnh dữ liệu và chỉ mục, lệnh này giúp giảm thiểu số lượng thao tác đọc/ghi [I/O] cần thiết khi truy cập bảng, từ đó tăng tốc độ truy vấn.
Cập nhật thống kê chỉ mục: OPTIMIZE TABLE thường cập nhật các thông tin thống kê về chỉ mục, giúp bộ tối ưu hóa truy vấn của DBMS đưa ra các kế hoạch thực thi hiệu quả hơn.
```

---

## T.Lập Auto tối ưu Database (`wptt-tu-dong-hoa-toi-uu-database`)

- **Danh mục:** Quản lý Database
- **Vị trí menu:** Menu chính › 4. Quản lý Database › 11. T.Lập Auto tối ưu Database  _(bấm lần lượt: 4 → 11)_
- **Tệp nguồn:** `/etc/wptt/db/wptt-tu-dong-hoa-toi-uu-database`

```text
Tính năng Thiết lập tự động tối ưu hóa database là việc cài đặt một lịch trình để hệ thống tự động thực hiện các tác vụ bảo trì trên cơ sở dữ liệu [database] của bạn nhằm duy trì và cải thiện hiệu suất hoạt động cũng như thu hồi không gian lưu trữ không cần thiết.

Nói một cách đơn giản, đây là cách bạn lên lịch dọn dẹp và sắp xếp lại kho dữ liệu [database] của mình một cách tự động, ví dụ như hàng tuần hoặc hàng tháng, để nó luôn hoạt động nhanh nhẹn và hiệu quả.

Mục Đích Chính
* Cải thiện hiệu suất truy vấn: Theo thời gian, việc thêm, sửa, xóa dữ liệu có thể làm các bảng bị phân mảnh và chỉ mục [index] hoạt động kém hiệu quả. Tối ưu hóa giúp sắp xếp lại dữ liệu và chỉ mục, làm cho các truy vấn chạy nhanh hơn.
* Thu hồi dung lượng lưu trữ lãng phí: Khi xóa dữ liệu, không gian trống thường không được giải phóng ngay. Tối ưu hóa có thể giúp gom lại không gian này, giảm kích thước tổng thể của database.
* Cập nhật thống kê bảng: Giúp bộ tối ưu truy vấn của database có thông tin mới nhất về dữ liệu, từ đó đưa ra kế hoạch thực thi truy vấn hiệu quả hơn.
* Bảo trì phòng ngừa: Giúp ngăn chặn các vấn đề về hiệu suất hoặc lỗi phát sinh nghiêm trọng hơn trong tương lai.
* Giảm thiểu công việc thủ công: Bạn không cần phải nhớ và tự chạy các lệnh tối ưu hóa bằng tay.

Tính năng này giúp cơ sở dữ liệu của bạn hoạt động ổn định và hiệu quả hơn về lâu dài với ít sự can thiệp thủ công hơn.
```

---

## Sửa chữa database ALL (`all-database-sua-chua`)

- **Danh mục:** Quản lý Database
- **Vị trí menu:** Menu chính › 4. Quản lý Database › 12. Sửa chữa database ALL  _(bấm lần lượt: 4 → 12)_
- **Tệp nguồn:** `/etc/wptt/wordpress/all-database-sua-chua`

```text
REPAIR TABLE: Công Cụ Sửa Chữa Bảng Dữ Liệu Bị Hỏng
OPTIMIZE TABLE: Giải Pháp Tối Ưu Hóa Không Gian và Hiệu Suất Cơ Sở Dữ Liệu
Mục đích chính của sửa chữa database:

* Kiểm tra tệp dữ liệu và tệp chỉ mục [index] của bảng: Nó sẽ tìm kiếm các lỗi và sự không nhất quán trong cấu trúc lưu trữ của bảng.
* Sửa chữa các lỗi tìm thấy: Tùy thuộc vào loại lỗi và mức độ hỏng hóc, DBMS sẽ cố gắng sửa chữa các khối dữ liệu bị hỏng, xây dựng lại các chỉ mục, hoặc loại bỏ các phần không thể khôi phục.
```

---

## Format trắng dữ liệu database (`wptt-wipe-database`)

- **Danh mục:** Quản lý Database
- **Vị trí menu:** Menu chính › 4. Quản lý Database › 13. Format trắng dữ liệu database  _(bấm lần lượt: 4 → 13)_
- **Tệp nguồn:** `/etc/wptt/db/wptt-wipe-database`

```text
Tính năng Format trắng database [hay Làm trắng/Xóa sạch cơ sở dữ liệu] là hành động xóa bỏ hoàn toàn tất cả các đối tượng [như bảng, view, stored procedure] và toàn bộ dữ liệu bên trong một cơ sở dữ liệu [database] hiện có, đưa nó về trạng thái trống rỗng như lúc mới được tạo.

Nói một cách đơn giản, đây là việc bạn dọn sạch sành sanh một kho chứa dữ liệu, vứt bỏ hết đồ đạc [dữ liệu] và các kệ chứa [bảng], chỉ giữ lại cái vỏ kho [database, username vẫn còn tồn tại].

Mục Đích Chính
* Làm lại từ đầu hoàn toàn: Khi bạn muốn xóa sạch một database [ví dụ: database thử nghiệm, staging] để bắt đầu với một cấu trúc mới hoặc cài đặt lại ứng dụng từ đầu.
* Chuẩn bị cài đặt lại ứng dụng: Một số ứng dụng yêu cầu một database trống khi cài đặt hoặc cài đặt lại.
* Loại bỏ cấu trúc bị lỗi nặng: Trong trường hợp hiếm gặp khi cấu trúc database bị hỏng nặng mà không thể sửa chữa, việc làm trắng có thể là một giải pháp [dù khôi phục từ backup thường được ưu tiên hơn].
* Xóa dữ liệu triệt để: Để đảm bảo mọi dữ liệu trong một database cụ thể bị xóa hoàn toàn trước khi tái sử dụng database đó cho mục đích khác.

LUÔN LUÔN SAO LƯU [BACKUP] TRƯỚC KHI THỰC HIỆN: Đây là điều bắt buộc. Hãy đảm bảo bạn có một bản sao lưu tin cậy trước khi tiến hành.
Hãy thực hiện thao tác này với sự cẩn trọng tối đa và chỉ khi bạn hoàn toàn chắc chắn về việc mình đang làm.
```

---

## Remote Database (`wptt-remote-database`)

- **Danh mục:** Quản lý Database
- **Vị trí menu:** Menu chính › 4. Quản lý Database › 14. Remote Database  _(bấm lần lượt: 4 → 14)_
- **Tệp nguồn:** `/etc/wptt/db/wptt-remote-database`

```text
Tính năng Remote database [hay Truy cập cơ sở dữ liệu từ xa] là khả năng cho phép các ứng dụng, công cụ hoặc người dùng kết nối và tương tác với một máy chủ cơ sở dữ liệu [MariaDB] từ một máy tính hoặc máy chủ khác, không phải là máy chủ đang trực tiếp chứa cơ sở dữ liệu đó, thông qua một kết nối mạng [LAN hoặc Internet]

Nói một cách đơn giản, thay vì website và database phải ở chung một nhà [cùng một server], tính năng này cho phép website ở nhà A có thể nói chuyện và lấy dữ liệu từ database đang ở nhà B.

Mục Đích Chính
* Phân tách kiến trúc ứng dụng: Cho phép máy chủ web [chạy ứng dụng] và máy chủ cơ sở dữ liệu hoạt động riêng biệt, giúp tăng khả năng mở rộng. [Ghi chú sẽ giảm hiệu suất, và rủi ro bảo mật hơn nếu dùng kết nối qua Internet không phải mạng lan]
* Quản lý và phát triển từ xa: Lập trình viên hoặc quản trị viên cơ sở dữ liệu có thể làm việc với database từ máy tính cá nhân của họ bằng các công cụ quản lý database chuyên dụng [như MySQL Workbench, DBeaver, HeidiSQL] mà không cần đăng nhập trực tiếp vào server chứa database.
* Tích hợp dữ liệu: Cho phép các hệ thống hoặc công cụ báo cáo khác nhau truy cập dữ liệu từ một nguồn database tập trung.
* Mô hình microservices: Các dịch vụ nhỏ lẻ có thể chạy trên các server khác nhau nhưng cùng kết nối về một hoặc nhiều database từ xa.
```

---

## Force Restart MariaDB (`wptt-force-restart-mariadb`)

- **Danh mục:** Quản lý Database
- **Vị trí menu:** Menu chính › 4. Quản lý Database › 15. Force Restart MariaDB  _(bấm lần lượt: 4 → 15)_
- **Tệp nguồn:** `/etc/wptt/db/wptt-force-restart-mariadb`

```text
Tính năng Ép buộc khởi động lại MariaDB [Force Restart] là công cụ xử lý sự cố khẩn cấp.
Nó được sử dụng khi dịch vụ MariaDB bị treo cứng, kẹt tiến trình [deadlock] hoặc không thể khởi động lại bằng các lệnh thông thường.

Cơ chế hoạt động:
1. Gửi tín hiệu SIGKILL [-9] để tiêu diệt ngay lập tức mọi tiến trình liên quan đến mysqld/mariadb.
2. Dọn dẹp các file rác [.pid, .sock] bị bỏ lại do tiến trình chết đột ngột.
3. Khởi động lại dịch vụ MariaDB một cách sạch sẽ.

Lưu ý: Chỉ nên sử dụng khi hệ thống thực sự bị treo, vì việc ép kill tiến trình đang ghi dữ liệu có thể mang rủi ro nhỏ về tính toàn vẹn dữ liệu.
```

---

## Thay đổi nhánh MariaDB (`wptt-thay-doi-phien-ban-mariadb`)

- **Danh mục:** Quản lý Database
- **Vị trí menu:** Menu chính › 4. Quản lý Database › 16. Thay đổi nhánh MariaDB  _(bấm lần lượt: 4 → 16)_
- **Tệp nguồn:** `/etc/wptt/db/wptt-thay-doi-phien-ban-mariadb`

```text
là tính năng để thay đổi nhánh phiên bản MariaDB
Ví dụ: bạn đang sử dụng MariaDB phiên bản 10.6 bạn muốn chuyển lên bản 10.11 thì hãy sử dụng tính năng này hoặc ngược lại bạn hoàn toàn có thể hạ cấp phiên bản MariaDB.
Bạn có thể thay đổi lựa chọn phiên bản MariaDB bạn muốn sử dụng
```

---

## Cài lại MariaDB (`wptt-rebuild-mariadb`)

- **Danh mục:** Quản lý Database
- **Vị trí menu:** Menu chính › 4. Quản lý Database › 17. Cài lại MariaDB  _(bấm lần lượt: 4 → 17)_
- **Tệp nguồn:** `/etc/wptt/db/wptt-rebuild-mariadb`

```text
Tính năng Rebuild MariaDB [Xây dựng lại MariaDB] thường đề cập đến các hành động nhằm sửa chữa, tối ưu hóa, hoặc khôi phục lại trạng thái hoạt động tốt cho cơ sở dữ liệu MariaDB, đặc biệt khi nó gặp sự cố, lỗi, hoặc hiệu suất bị suy giảm.

Nói một cách đơn giản, đây là việc làm mới hoặc sửa chữa một phần hoặc toàn bộ cơ sở dữ liệu MariaDB để nó chạy trơn tru và chính xác trở lại.

Lưu ý: Luôn nhớ sao lưu dữ liệu trước khi thực hiện các thao tác rebuild quan trọng.
```

---

## Thực thi MariaDB CLI (`cli-mysql-thuc-thi`)

- **Danh mục:** Quản lý Database
- **Vị trí menu:** Menu chính › 4. Quản lý Database › 18. Thực thi MariaDB CLI  _(bấm lần lượt: 4 → 18)_
- **Tệp nguồn:** `/etc/wptt/db/cli-mysql-thuc-thi`

```text
💡 TÍNH NĂNG: GIAO DIỆN DÒNG LỆNH MYSQL CLI (COMMAND LINE)
Đây là công cụ cấp cao dành cho quản trị viên, cho phép bạn tương tác 
trực tiếp với hệ quản trị cơ sở dữ liệu MariaDB/MySQL thông qua dòng lệnh.

🚀 ĐIỂM NỔI BẬT CỦA CÔNG CỤ NÀY:
 ➜ Đăng nhập 1-Click: Tự động kết nối vào database của bất kỳ website nào 
    hoặc quyền Root (Tối cao) mà KHÔNG cần phải nhớ hay nhập mật khẩu.
 ➜ Bảo mật tuyệt đối: Script sử dụng cơ chế tệp tin cấu hình tạm thời 
    (Temporary Config File) kết hợp mã hóa, đảm bảo mật khẩu không bao 
    giờ bị rò rỉ ra danh sách tiến trình (Process List) của máy chủ.
 ➜ Tích hợp hệ thống khiên chắn chống Local SQL Injection đa lớp.
 ➜ Hỗ trợ tìm kiếm nhanh website thông minh bằng FZF.

🛠️ ỨNG DỤNG THỰC TẾ:
 - Thực thi các câu lệnh SQL phức tạp trực tiếp (SELECT, UPDATE, DELETE).
 - Kiểm tra các tiến trình đang chạy gây nghẽn cổ chai (SHOW PROCESSLIST).
 - Dành cho người dùng nâng cao muốn kiểm soát database 100%.

⚠️ LƯU Ý: 
Thao tác trực tiếp bằng SQL rất mạnh mẽ nhưng cũng đi kèm rủi ro. 
Hãy chắc chắn về câu lệnh của bạn trước khi nhấn Enter để tránh mất dữ liệu!
```

---

## chuyển đổi định dang lưu trữ (INNODB, MYISAM, Aria) (`chuyen-doi-dinh-dang-luu-tru-storage-engine-innodb-myisam-aria`)

- **Danh mục:** Quản lý Database
- **Vị trí menu:** Menu chính › 4. Quản lý Database › 20. chuyển đổi định dang lưu trữ (INNODB, MYISAM, Aria)  _(bấm lần lượt: 4 → 20)_
- **Tệp nguồn:** `/etc/wptt/db/chuyen-doi-dinh-dang-luu-tru-storage-engine-innodb-myisam-aria`

```text
Đây là tính năng chuyển đổi công nghệ lưu trữ database sang [MyISAM, InnoDB, Aria]

Tính năng Chuyển đổi công nghệ lưu trữ database sang [MyISAM, InnoDB, Aria] là khả năng thay đổi cơ chế [storage engine] mà hệ quản trị cơ sở dữ liệu MariaDB sử dụng để lưu trữ, truy xuất và quản lý dữ liệu trong các bảng [table] của bạn. Mỗi công nghệ lưu trữ có những đặc điểm, ưu và nhược điểm riêng về hiệu năng, tính năng và độ tin cậy.

Nói một cách đơn giản, đây là việc bạn chọn một kiểu nhà kho khác cho dữ liệu của mình, tùy thuộc vào nhu cầu sử dụng cụ thể. Ba cái tên bạn đề cập là các storage engine phổ biến:

* InnoDB: Thường là mặc định và được khuyến nghị cho hầu hết các ứng dụng hiện đại. Hỗ trợ giao dịch [transactions ACID], khóa ở cấp độ hàng [row-level locking giúp xử lý đồng thời tốt], ràng buộc khóa ngoại [foreign keys], và khả năng phục hồi sau sự cố [crash recovery] tốt. Rất quan trọng cho tính toàn vẹn dữ liệu.
* MyISAM: Công nghệ cũ hơn, nổi tiếng với tốc độ đọc nhanh trong một số trường hợp nhất định [ít ghi, ít truy cập đồng thời]. Sử dụng khóa ở cấp độ bảng [table-level locking], không hỗ trợ transactions và khóa ngoại. Dễ bị hỏng dữ liệu hơn InnoDB khi có sự cố.
* Aria: Do MariaDB phát triển, được thiết kế như một sự thay thế cải tiến và an toàn hơn MyISAM. Nó cung cấp khả năng phục hồi sau sự cố tốt hơn MyISAM và một số tính năng khác, nhưng vẫn có những đặc điểm riêng.

Mục Đích Chính Của Việc Chuyển Đổi
* Tận dụng tính năng cụ thể:
* Chuyển sang InnoDB để có giao dịch, khóa ngoại, an toàn dữ liệu cao hơn.
* Chuyển từ MyISAM sang InnoDB/Aria để cải thiện độ tin cậy.
* Tối ưu hiệu năng: Chọn engine phù hợp với loại tác vụ của website [đọc nhiều hay ghi nhiều, mức độ truy cập đồng thời].
* Hiện đại hóa: Chuyển từ các engine cũ [như MyISAM] sang các engine mạnh mẽ và nhiều tính năng hơn.
* Yêu cầu của ứng dụng: Một số ứng dụng web hoặc framework có thể yêu cầu hoặc hoạt động tốt nhất với một storage engine cụ thể.
```

---

## Sao lưu & Khôi phục (`wptt-backup-restore-main`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục  _(bấm lần lượt: 5)_
- **Tệp nguồn:** `/etc/wptt/wptt-backup-restore-main`

```text
Tính năng Quản lý Sao lưu và Khôi phục [Backup và Restore] trong WPTangToc OLS là một công cụ thiết yếu giúp bạn bảo vệ dữ liệu website và dễ dàng phục hồi khi có sự cố xảy ra. 🔄🔒

Giới thiệu ngắn gọn:
Mục đích: Đảm bảo an toàn cho dữ liệu website [bao gồm tệp tin mã nguồn và cơ sở dữ liệu] bằng cách tạo các bản sao lưu dự phòng và cho phép khôi phục lại trạng thái trước đó một cách nhanh chóng.

Lợi ích:
* An toàn dữ liệu: Phòng ngừa mất mát dữ liệu do lỗi người dùng, tấn công, hoặc sự cố phần cứng/phần mềm.
* Phục hồi nhanh chóng: Giảm thiểu thời gian website ngừng hoạt động khi gặp sự cố.
* Lưu trữ linh hoạt: Hỗ trợ Local, Google Drive, OneDrive và hệ thống S3 Storage chuyên nghiệp.
```

---

## Sao lưu website (`wptt-saoluu`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 1. Sao lưu website  _(bấm lần lượt: 5 → 1)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/wptt-saoluu`

```text
Tính năng sao lưu website [website backup] là quá trình tạo ra các bản sao của toàn bộ dữ liệu website của bạn và lưu trữ chúng ở một nơi an toàn.

Những bản sao này đóng vai trò như một [phao cứu sinh], cho phép bạn khôi phục lại website về trạng thái hoạt động ổn định trước đó nếu có sự cố xảy ra.

Tính năng này sao lưu mã nguồn [Định dạng .zip theo mặc định hoặc .tar.gz hoặc .tar.zst nếu đã thiết lập] và database website [định dạng .sql theo mặc định hoặc .sql.gz hoặc .sql.zst nếu đã thiết lập]

Hỗ trợ sao lưu tại local máy chủ và đám mây drive.
```

---

## Khôi phục website (`wptt-khoiphuc`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 2. Khôi phục website  _(bấm lần lượt: 5 → 2)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/wptt-khoiphuc`

```text
🔄 TÍNH NĂNG: KHÔI PHỤC WEBSITE (ATOMIC RESTORE)
Nếu website gặp sự cố (mất dữ liệu, cập nhật lỗi, hoặc bị tấn công), 
công cụ này chính là "cỗ máy thời gian" đưa website của bạn quay về 
trạng thái hoạt động hoàn hảo nhất một cách an toàn tuyệt đối.

🚀 CÔNG NGHỆ KHÔI PHỤC ĐỘT PHÁ TỪ WPTANGTOC:
 ➜ Không gián đoạn (Atomic Swap): Thay vì xóa web đi giải nén lại rủi ro cao, 
    hệ thống xử lý mã nguồn/database ở "không gian tạm". Chỉ khi 
    thành công 100%, hệ thống mới tráo đổi (Swap) trong chớp mắt. 
    Nếu file backup bị lỗi giữa chừng -> Website cũ vẫn được giữ nguyên!
 ➜ Khiên chống hỏng dữ liệu (Anti-Corrupt): Tự động quét kiểm tra cấu trúc 
    file nén (.tar.zst, .zip...) và file SQL trước khi khôi phục. 
 ➜ Thông minh & Tự động: Tự động kết nối lại wp-config, sửa lỗi phân quyền 
    (chmod/chown) chuẩn xác, bật/tắt chế độ bảo trì và dọn dẹp LSCache 
    ngay khi hoàn tất.
 ➜ Tốc độ tối đa: Hỗ trợ bung nén đa luồng thế hệ mới với ZSTD và PIGZ.

📦 ĐỊNH DẠNG HỖ TRỢ BẢN SAO LƯU:
 - Mã nguồn: .zip, .tar.gz, .tar.zst (Khuyên dùng)
 - Database : .sql, .sql.gz, .sql.zst (Khuyên dùng)

⚠️ LƯU Ý: Tiến trình khôi phục được bảo vệ chống đụng độ (Process Lock). 
Vui lòng không đóng cửa sổ Terminal/SSH trong suốt quá trình chạy!
```

---

## Sao lưu database (`wptt-saoluu-database`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 3. Sao lưu database  _(bấm lần lượt: 5 → 3)_
- **Vị trí menu:** Menu chính › 4. Quản lý Database › 8. Sao lưu database  _(bấm lần lượt: 4 → 8)_
- **Tệp nguồn:** `/etc/wptt/db/wptt-saoluu-database`

```text
Tính năng Sao lưu database [Database Backup] là quá trình tạo ra một bản sao của toàn bộ cơ sở dữ liệu của bạn – bao gồm cấu trúc [các bảng, cột], dữ liệu chứa trong đó, các chỉ mục [index] – rồi lưu trữ bản sao đó ở một nơi an toàn. Khôi phục là cặp đôi không thể thiếu cho sự an toàn của dữ liệu.

Nói một cách đơn giản, đây là việc bạn chụp lại một bức ảnh toàn bộ kho chứa dữ liệu [database] của mình tại một thời điểm nhất định, để nếu có chuyện không may xảy ra với kho chính, bạn vẫn còn bức ảnh đó để dựng lại.

Mục Đích Chính [Vô Cùng Quan Trọng]
* Phòng chống mất mát dữ liệu: Đây là mục đích hàng đầu. Bảo vệ dữ liệu khỏi lỗi phần cứng, lỗi phần mềm, xóa nhầm bởi con người, tấn công mạng [malware, ransomware], hoặc thiên tai.
* Khôi phục sau sự cố [Disaster Recovery]: Cho phép bạn đưa database trở lại trạng thái hoạt động ổn định sau khi gặp vấn đề.
* Di chuyển dữ liệu [Data Migration]: Sử dụng bản sao lưu để chuyển database sang một máy chủ mới hoặc một môi trường khác.
* Phục vụ thử nghiệm và phát triển: Tạo bản sao của database sản xuất để thử nghiệm tính năng mới hoặc gỡ lỗi mà không ảnh hưởng đến dữ liệu thật.
* Lưu trữ và tuân thủ quy định: Một số ngành nghề yêu cầu phải sao lưu và lưu trữ dữ liệu định kỳ.

Để sẵn sàng để sử dụng khi cần khôi phục.
```

---

## Khôi phục database (`wptt-nhapdatabase`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 4. Khôi phục database  _(bấm lần lượt: 5 → 4)_
- **Vị trí menu:** Menu chính › 4. Quản lý Database › 9. Khôi phục database  _(bấm lần lượt: 4 → 9)_
- **Tệp nguồn:** `/etc/wptt/db/wptt-nhapdatabase`

```text
Tính năng Khôi phục database [Database Restoration] là quá trình đưa một cơ sở dữ liệu [database] trở lại một trạng thái đã được lưu trữ trước đó, thường là từ một tệp tin sao lưu [backup].

Nói một cách đơn giản, nếu database của bạn gặp sự cố [mất dữ liệu, bị lỗi, bị tấn công], tính năng này giống như việc bạn sử dụng một cỗ máy thời gian để quay ngược database về một thời điểm mà nó còn hoạt động tốt, dựa trên bản sao lưu bạn đã có.

Mục Đích Chính
* Phục hồi sau thảm họa/sự cố: Đây là mục đích quan trọng nhất, giúp lấy lại dữ liệu và cấu trúc database sau khi xảy ra lỗi phần cứng, lỗi phần mềm, tấn công mạng, xóa nhầm, hoặc các vấn đề khác gây mất mát dữ liệu.
* Hoàn tác các thay đổi không mong muốn: Khôi phục lại trạng thái trước khi có những thay đổi dữ liệu sai sót hoặc cập nhật ứng dụng gây lỗi.
* Phục hồi tại một thời điểm cụ thể [Point-in-Time Recovery]: Nếu chiến lược sao lưu của bạn hỗ trợ, bạn có thể khôi phục database về chính xác một thời điểm nào đó trước khi sự cố xảy ra.
* Phục vụ môi trường thử nghiệm/phát triển: Tạo một bản sao của database sản xuất trên môi trường thử nghiệm để kiểm tra mà không ảnh hưởng đến dữ liệu thật.
```

---

## Tự động sao lưu website (`wptt-auto-backup`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 5. Tự động sao lưu website  _(bấm lần lượt: 5 → 5)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/wptt-auto-backup`

```text
Tính năng tự động sao lưu website là một yếu tố thiết yếu để đảm bảo an toàn dữ liệu và khả năng phục hồi cho bất kỳ trang web nào. Việc đầu tư vào một giải pháp sao lưu tự động đáng tin cậy là một quyết định khôn ngoan để bảo vệ tài sản website của bạn.

Đúng vậy, tính năng tự động sao lưu website [automatic website backup] là một quy trình được thiết lập để tự động tạo ra các bản sao của dữ liệu và tệp tin website của bạn theo một lịch trình định sẵn mà không cần sự can thiệp thủ công của con người.

Những bản sao này đóng vai trò như một [phao cứu sinh], cho phép bạn khôi phục lại website về trạng thái hoạt động ổn định trước đó nếu có sự cố xảy ra.

Tính năng này sao lưu mã nguồn [Định dạng .zip] và database website [định dạng .sql hoặc .sql.gz - nếu đã thiết lập]

Hỗ trợ sao lưu tại local máy chủ và đám mây drive/s3
```

---

## Tắt tự động sao lưu website (`wptt-tat-auto-backup`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 6. Tắt tự động sao lưu website  _(bấm lần lượt: 5 → 6)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/wptt-tat-auto-backup`

```text
Tính năng tắt tự động sao lưu website là một tùy chọn cho phép bạn dừng hoàn toàn hoặc tạm ngưng việc hệ thống tự động tạo ra các bản sao lưu [backup] cho website của bạn theo lịch trình đã định sẵn.

Nói đơn giản, nếu website của bạn đang được cài đặt để tự động backup mỗi ngày, việc tắt tính năng này sẽ khiến quá trình đó ngừng lại. Website sẽ không còn được tự động sao lưu nữa cho đến khi bạn kích hoạt lại tính năng này.
```

---

## Tự động sao lưu database (`wptt-auto-backup-database`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 7. Tự động sao lưu database  _(bấm lần lượt: 5 → 7)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/wptt-auto-backup-database`

```text
Tính năng tự động sao lưu database là một cơ chế được thiết lập để hệ thống tự động tạo ra các bản sao [backup] của cơ sở dữ liệu [database] website của bạn theo một lịch trình định sẵn mà không cần sự can thiệp thủ công.

Nói đơn giản, thay vì bạn phải nhớ và tự mình chạy lệnh để sao lưu database mỗi ngày hoặc mỗi tuần tận chí là mỗi tháng, hệ thống sẽ tự động làm điều đó. Ví dụ, nó có thể tự động xuất toàn bộ dữ liệu từ MySQL, của bạn ra một tệp tin vào lúc 2 giờ sáng mỗi ngày.

Tại sao nó cực kỳ quan trọng:
* Bảo vệ dữ liệu cốt lõi: Database chứa các thông tin quan trọng như nội dung website, thông tin người dùng, đơn hàng, v.v. Mất database có thể đồng nghĩa với mất trắng website.
* Khôi phục nhanh khi có sự cố: Nếu website gặp lỗi, bị tấn công, hoặc dữ liệu bị hỏng, bản sao lưu database tự động gần nhất giúp bạn khôi phục lại trạng thái ổn định một cách nhanh chóng.
* Giảm thiểu rủi ro do con người: Tránh trường hợp quên sao lưu hoặc sao lưu không đúng cách.

Tính năng thiết lập tự động sao lưu database website [định dạng .sql hoặc .sql.gz - nếu đã thiết lập]
```

---

## Tắt tự động sao lưu database (`wptt-tat-auto-backup-database`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 8. Tắt tự động sao lưu database  _(bấm lần lượt: 5 → 8)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/wptt-tat-auto-backup-database`

```text
Tính năng tắt tự động sao lưu database là một tùy chọn cho phép bạn dừng hoặc tạm ngưng việc hệ thống tự động tạo ra các bản sao lưu [backup] riêng cho cơ sở dữ liệu [database] của website theo lịch trình đã định sẵn.

Nói một cách đơn giản, nếu bạn có một tác vụ tự động chạy mysqldump mỗi đêm để sao lưu cơ sở dữ liệu, việc tắt tính năng này sẽ làm cho tác vụ đó không còn thực hiện nữa. Cơ sở dữ liệu sẽ không được tự động sao lưu riêng lẻ cho đến khi bạn kích hoạt lại.
```

---

## T.lập auto xóa File Backup hết hạn (`wptt-auto-delete-backup`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 9. T.lập auto xóa File Backup hết hạn  _(bấm lần lượt: 5 → 9)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/wptt-auto-delete-backup`

```text
Tính năng tự động dọn dẹp file backup cũ tại ổ cứng máy chủ [Local] theo số lượng bản sao lưu.

Nói đơn giản, bạn thiết lập quy tắc [ví dụ: chỉ giữ lại 10 bản sao lưu mới nhất]. Hệ thống sẽ tự động quét, bảo vệ 10 bản mới này và chỉ xóa những bản cũ hơn vượt quá giới hạn.

Lưu ý quan trọng: "1 Bản" ở đây được hiểu là một bộ sao lưu hoàn chỉnh, bao gồm 1 file Mã Nguồn [.zip/.tar] VÀ 1 file Database [.sql]. Nếu bạn chọn giữ 10 bản, hệ thống sẽ giữ lại đúng 10 file Mã nguồn và 10 file Database tương ứng.

Lợi ích:
* Chống Full Disk: Ngăn chặn triệt để tình trạng file backup sinh ra liên tục làm đầy ổ cứng khiến VPS bị treo, sập database.
* Quản lý khoa học: Luôn có một số lượng mốc thời gian cố định để lựa chọn khi cần khôi phục.

CƠ CHẾ ƯU TIÊN THÔNG MINH [RIÊNG LẺ ĐÈ TOÀN CỤC]:
Hệ thống luôn ưu tiên cấu hình của từng [Website Cụ Thể] cao hơn cấu hình [Tất cả Website].
Ví dụ: Bạn cài đặt "Tất cả website" giữ lại 5 bản.
Nhưng bạn cài đặt riêng cho "wptangtoc.com" giữ lại 15 bản.
=> Kết quả: Hệ thống sẽ bảo vệ 15 bản cho wptangtoc.com, và áp dụng mốc 5 bản cho các web còn lại.
```

---

## Huỷ T.lập auto xóa File Backup hết hạn (`wptt-tat-delete-backup`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 10. Huỷ T.lập auto xóa File Backup hết hạn  _(bấm lần lượt: 5 → 10)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/wptt-tat-delete-backup`

```text
Tính năng tắt tự động dọn dẹp file backup tại ổ cứng máy chủ [Local] là một tùy chọn cho phép bạn vô hiệu hóa hoàn toàn cơ chế tự động loại bỏ các bản sao lưu cũ.

Nói đơn giản, nếu bạn đã cài đặt để hệ thống tự xóa backup dư thừa, thì việc tắt tính năng này có nghĩa là tất cả các bản backup sẽ được giữ lại vĩnh viễn cho đến khi bạn xóa thủ công.

Mục đích sử dụng:
* Lưu trữ dài hạn đột xuất: Khi bạn cần giữ lại tất cả các bản backup trong một khoảng thời gian nhất định [ví dụ, để điều tra sự cố hoặc trước một thay đổi lớn trên website].
* Thay đổi chính sách lưu trữ: Khi bạn muốn thay đổi quy tắc lưu giữ và cần thời gian để cấu hình lại.

Lưu ý: Khi tắt tính năng này, dung lượng lưu trữ sẽ tăng lên theo thời gian. Bạn cần chủ động theo dõi để tránh nguy cơ đầy ổ cứng.
```

---

## Xoá file Backup (`wptt-xoa-file-backup`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 11. Xoá file Backup  _(bấm lần lượt: 5 → 11)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/wptt-xoa-file-backup`

```text
Tính năng xóa file backup thủ công đơn giản là việc bạn tự tay lựa chọn và xóa các tệp tin hoặc thư mục sao lưu [backup] không còn cần thiết nữa.

Khi nào cần dùng:

* Khi bạn cần giải phóng dung lượng lưu trữ ngay lập tức.
* Khi bạn biết chắc chắn một bản sao lưu cụ thể không còn giá trị hoặc bị lỗi.
* Để dọn dẹp đột xuất ngoài lịch trình tự động.

Lưu ý quan trọng: Việc xóa thủ công cần cẩn trọng để tránh vô tình xóa nhầm những bản sao lưu quan trọng mà bạn có thể cần đến sau này.
```

---

## Sao lưu website luỹ tiến từng phần (`wptt-saoluu-luy-tien-tung-phan`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 12. Sao lưu website luỹ tiến từng phần  _(bấm lần lượt: 5 → 12)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/wptt-saoluu-luy-tien-tung-phan`

```text
Tính năng sao lưu website [website backup] là quá trình tạo ra các bản sao của toàn bộ dữ liệu website của bạn và lưu trữ chúng ở một nơi an toàn.

Sao lưu luỹ tiến từng phần là kỹ thuật backup mục đích chính của nó là giảm chi phí lưu trữ giảm dung lượng ổ cứng.

Nguyên lý hoạt động bình thường: giả sử mã nguồn của bạn 1GB khi nén thành 1 file zip để backup bạn sẽ tạo ra được 1 file zip nặng 1GB
Nếu bạn backup liên tục trong 30 ngày thì suy ra bạn phải tốn 30GB dung lượng ổ cứng

Còn với kỹ thuật backup luỹ tiến từng phần: nó sẽ backup full 1 bản riêng phần ảnh [ví dụ nặng 900MB] là 1 file zip riêng loại trừ thư mục uploads hiện hữu.
Và sau đó nó sẽ sao lưu phần 2: sao lưu mã nguồn và loại bỏ toàn bộ file backup ảnh ở phần full ảnh trên chỉ lưu thêm thư mục ảnh hiện hữu: wp-content/uploads/2025/05 thì chỉ tốn 100MB

Thay vì phải tốn 30GB backup thì nhờ kỹ thuật này bạn chỉ tốn 3.9GB tiết kiệm được: 30-3.9 = 26.1GB giảm được 87% dung lượng.
Kỹ thuật này rất hữu ích với mã nguồn có dung lượng lớn.
```

---

## Khôi phục website luỹ tiến từng phần (`wptt-khoiphuc-luy-tien-tung-phan`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 13. Khôi phục website luỹ tiến từng phần  _(bấm lần lượt: 5 → 13)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/wptt-khoiphuc-luy-tien-tung-phan`

```text
Tính năng khôi phục website luỹ tiến từng phần

Khôi phục website là quá trình sửa chữa, phục hồi hoặc đưa trở lại trạng thái hoạt động bình thường cho các chức năng cụ thể của một trang web đã bị lỗi, bị mất hoặc không hoạt động đúng cách. Điều này đảm bảo rằng người dùng có thể tiếp tục tương tác và sử dụng đầy đủ các tiện ích mà website đó cung cấp.

Khôi phục từ bản sao lưu [Backup] sao lưu luỹ tiến trong wptangtoc ols: Nếu bạn thường xuyên sao lưu website, bạn có thể khôi phục toàn bộ website hoặc các thành phần cụ thể về một thời điểm trước khi lỗi xảy ra.
```

---

## Thiết lập Google Drive (`wptt-rclone`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 14. Thiết lập Google Drive  _(bấm lần lượt: 5 → 14)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/wptt-rclone`

```text
Thiết lập Google Drive đám mây là một giải pháp sao lưu website hiệu quả, an toàn và có khả năng tùy biến cao.
OneDrive: Là dịch vụ lưu trữ và đồng bộ hóa tệp tin trên đám mây của Microsoft.
Đây là một giải pháp mạnh mẽ, cho phép bạn lưu trữ các bản sao lưu tách biệt khỏi máy chủ website.
```

---

## Thiết lập Microsoft OneDrive (`wptt-rclone-one-driver`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 15. Thiết lập Microsoft OneDrive  _(bấm lần lượt: 5 → 15)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/wptt-rclone-one-driver`

```text
Thiết lập OneDrive đám mây là một giải pháp sao lưu website hiệu quả, an toàn và có khả năng tùy biến cao.
OneDrive: Là dịch vụ lưu trữ và đồng bộ hóa tệp tin trên đám mây của Microsoft.
Đây là một giải pháp mạnh mẽ, cho phép bạn lưu trữ các bản sao lưu tách biệt khỏi máy chủ website.
```

---

## Thiết lập S3 Storage (R2/AWS...) (`wptt-s3-rclone`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 16. Thiết lập S3 Storage (R2/AWS...)  _(bấm lần lượt: 5 → 16)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/wptt-s3-rclone`

```text
Thiết lập Lưu trữ Đám mây [Cloud Storage] chuẩn S3 Compatible là giải pháp siêu tốc, chuyên nghiệp và tối ưu chi phí nhất.
Hỗ trợ các nền tảng: Cloudflare R2, Amazon S3, DigitalOcean Spaces, MinIO và các hãng S3 Custom...
```

---

## Download File backup cloud (`wptt-download-rclone`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 17. Download File backup cloud  _(bấm lần lượt: 5 → 17)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/wptt-download-rclone`

```text
Tính năng tải [download] file sao lưu từ lưu trữ đám mây để phục vụ khôi phục là quá trình bạn lấy lại các tệp tin mã nguồn và cơ sở dữ liệu website đã được lưu trữ trên dịch vụ đám mây [như Google Drive, OneDrive, S3 v.v.] về máy chủ của mình.

Nói đơn giản, đây là bước quan trọng để mang bản sao lưu từ nơi cất giữ an toàn trên mạng về lại nơi bạn cần [ví dụ: máy chủ web] để có thể tiến hành quá trình phục hồi website sau khi gặp sự cố.

Mục đích chính:

* Chuẩn bị cho việc khôi phục website: Các tệp sao lưu cần phải có mặt trên máy chủ hoặc môi trường phù hợp để bạn có thể sử dụng chúng [giải nén, import cơ sở dữ liệu,...] nhằm đưa website trở lại trạng thái hoạt động trước đó.
* Truy cập dữ liệu offline: Cho phép bạn xem xét, kiểm tra nội dung của bản sao lưu mà không cần kết nối internet [sau khi đã tải về].

Đây là một bước không thể thiếu trong quy trình khôi phục website từ các bản sao lưu được lưu trữ từ xa.
```

---

## Hủy đăng ký Cloud (`wptt-huy-rclone`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 18. Hủy đăng ký Cloud  _(bấm lần lượt: 5 → 18)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/wptt-huy-rclone`

```text
Tính năng Hủy thiết lập Rclone backup lưu trữ đám mây là quá trình xóa bỏ hoặc vô hiệu hóa cấu hình kết nối mà bạn đã tạo trước đó trong Rclone để liên kết với một dịch vụ lưu trữ đám mây [như Google Drive, OneDrive, v.v.] cho mục đích sao lưu website.

Nói một cách đơn giản, đây là hành động gỡ bỏ chìa khóa và địa chỉ mà Rclone dùng để truy cập và gửi file backup của bạn lên một tài khoản lưu trữ đám mây cụ thể.

Mục đích chính của việc này:
* Ngừng sử dụng một dịch vụ đám mây: Khi bạn muốn chuyển sang nhà cung cấp khác hoặc không muốn dùng dịch vụ đó để sao lưu nữa.
Thay đổi cấu hình: Xóa cấu hình cũ để thiết lập lại từ đầu, có thể do lỗi hoặc muốn thay đổi cài đặt.
* Bảo mật: Nếu nghi ngờ thông tin xác thực [token] của Rclone với dịch vụ đám mây bị lộ, việc hủy và tạo lại là cần thiết.
* Dọn dẹp: Loại bỏ các cấu hình không còn sử dụng.

Sau khi hủy thiết lập, Rclone sẽ không còn khả năng tương tác với dịch vụ đám mây đó thông qua cấu hình đã bị xóa, và các hoạt động sao lưu tự động mà uploads lên đám mây nó sẽ dừng lại. cho đến khi bạn thiết lập một dịch vụ lưu trữ đám mây mới thay thế.
```

---

## T.lập auto xóa file backup hết hạn Cloud (`wptt-thiet-lap-auto-delete-google-driver-backup`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 19. T.lập auto xóa file backup hết hạn Cloud  _(bấm lần lượt: 5 → 19)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/wptt-thiet-lap-auto-delete-google-driver-backup`

```text
Tính năng tự động dọn dẹp file backup cũ trên đám mây [OneDrive, Google Drive, S3] theo số lượng bản sao lưu.

Nói đơn giản, bạn thiết lập quy tắc [ví dụ: chỉ giữ lại 10 bản sao lưu mới nhất]. Hệ thống sẽ tự động quét, bảo vệ 10 bản mới này và chỉ xóa những bản cũ hơn vượt quá giới hạn.

Lưu ý quan trọng: "1 Bản" ở đây được hiểu là một bộ sao lưu hoàn chỉnh, bao gồm 1 file Mã Nguồn [.zip/.tar] VÀ 1 file Database [.sql]. Nếu bạn chọn giữ 10 bản, hệ thống sẽ giữ lại đúng 10 file Mã nguồn và 10 file Database tương ứng.

Lợi ích VƯỢT TRỘI so với xóa theo ngày:
* An toàn tuyệt đối: Giả sử Cloud của bạn hết dung lượng hoặc API hết hạn không thể tải bản mới lên. Hệ thống sẽ KHÔNG xóa các bản cũ đi. Bạn luôn có "phao cứu sinh".
* Tiết kiệm dung lượng: Ngăn chặn tích tụ rác quá mức giới hạn đã định.
* Ưu tiên thông minh: Cấu hình của riêng từng Website sẽ luôn được ưu tiên cao nhất, không bị ghi đè bởi cấu hình "Tất cả website".
```

---

## Huỷ T.lập auto xóa file backup hết hạn Cloud (`wptt-tat-auto-delete-backup-google-driver`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 20. Huỷ T.lập auto xóa file backup hết hạn Cloud  _(bấm lần lượt: 5 → 20)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/wptt-tat-auto-delete-backup-google-driver`

```text
Tính năng tắt tự động dọn dẹp file backup trên lưu trữ đám mây là một tùy chọn cho phép bạn vô hiệu hóa hoàn toàn cơ chế tự động loại bỏ các bản sao lưu website cũ đã được lưu trữ trên các dịch vụ đám mây [Google Drive, OneDrive, S3 Storage v.v.].

Nói một cách đơn giản, nếu bạn đã thiết lập để hệ thống tự động dọn dẹp các bản backup trên Cloud [theo số bản], việc tắt tính năng này có nghĩa là mọi bản backup trên đó sẽ được giữ lại vĩnh viễn. Chúng sẽ không bị tự động xóa nữa cho đến khi bạn xóa thủ công hoặc kích hoạt lại cơ chế tự động.
```

---

## Xóa Backup trên cloud (`wptt-xoa-file-backup-google-driver`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 21. Xóa Backup trên cloud  _(bấm lần lượt: 5 → 21)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/wptt-xoa-file-backup-google-driver`

```text
Tính năng xóa file backup thủ công trên lưu trữ đám mây [OneDrive, Google Drive, S3] đơn giản là việc bạn tự tay lựa chọn và xóa các tệp tin hoặc thư mục sao lưu [backup] không còn cần thiết nữa.

Khi nào cần dùng:
* Khi bạn cần giải phóng dung lượng lưu trữ ngay lập tức. Tiết kiệm chi phí lưu trữ đám mây.
* Dọn dẹp đột xuất ngoài lịch trình tự động.

Lưu ý quan trọng: Việc xóa thủ công cần cẩn trọng để tránh vô tình xóa nhầm những bản sao lưu quan trọng.
```

---

## Chuyển đổi định dạng sao lưu database (`wptt-sql-gzip-config`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 22. Chuyển đổi định dạng sao lưu database  _(bấm lần lượt: 5 → 22)_
- **Vị trí menu:** Menu chính › 4. Quản lý Database › 19. Chuyển đổi định dạng sao lưu database  _(bấm lần lượt: 4 → 19)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/wptt-sql-gzip-config`

```text
Thiết lập chuyển đổi định dạng file backup database
Đây là tính năng liên quan đến việc nén và giải nén file sao lưu cơ sở dữ liệu [database] của website:

Chuyển đổi từ .sql hoặc .sql.gz hoặc .sql.zst [Nén file]:

.sql: Là file văn bản thuần túy chứa các lệnh SQL để tạo lại cấu trúc và dữ liệu của database. File này có thể rất lớn.
.sql.gz: Là file .sql đã được nén lại bằng thuật toán gzip. Việc này giúp giảm đáng kể dung lượng file, tiết kiệm không gian lưu trữ và làm cho việc tải lên/tải xuống nhanh hơn.
.sql.zst: Là file .sql đã được nén lại bằng thuật toán zstd. Việc này giúp giảm đáng kể dung lượng file, tiết kiệm không gian lưu trữ và làm cho việc tải lên/tải xuống nhanh hơn.
Cách thực hiện: Sử dụng các công cụ nén như gzip trên dòng lệnh [Linux/macOS] hoặc các phần mềm nén file như 7-Zip, WinRAR trên Windows.

Đây là quá trình lựa chọn công nghệ nén file database sao lưu: .sql.gz và .sql gốc và .sql.zst

Tóm lại: Việc chuyển đổi giữa .sql và .sql.gz và .sql.zst là một bước phổ biến trong quy trình sao lưu và phục hồi database website để lưu trữ và di chuyển hiệu quả.

Mặc định thiết lập là: .sql
```

---

## Chuyển đổi định dạng nén mã nguồn sao lưu (`dinh-dang-backup-ma-nguon-option`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 23. Chuyển đổi định dạng nén mã nguồn sao lưu  _(bấm lần lượt: 5 → 23)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/dinh-dang-backup-ma-nguon-option`

```text
WPTangToc OLS nay cho phép bạn lựa chọn giữa 3 định dạng nén mã nguồn khi sao lưu, giúp tối ưu hóa giữa hiệu suất, tính toàn vẹn và sự tiện lợi.

1. ZIP [.zip]: Lựa chọn Tương Thích Tối Đa
File .zip có thể mở được trên mọi máy tính [Windows, macOS] mà không cần cài đặt thêm phần mềm.
Khuyên dùng: Khi mục đích chính là tải file backup về máy tính cá nhân [đặc biệt là Windows] hoặc chia sẻ cho người dùng không chuyên.

2. ZSTD [.tar.zst]: Lựa chọn Hiệu Suất Tối Đa
Nén và giải nén cực nhanh, tốn ít CPU và thường tạo ra file backup có dung lượng nhỏ nhất.
Khuyên dùng: Cho các tác vụ tự động trên máy chủ khi tốc độ là ưu tiên tuyệt đối, giúp giảm tải cho server và tiết kiệm thời gian.

3. TAR.GZ [.tar.gz]: Lựa chọn Tiêu Chuẩn Vàng
Cân bằng giữa tỉ lệ nén tốt và tính tương thích cao trên mọi môi trường máy chủ [Linux, macOS].
Khuyên dùng: Làm định dạng mặc định cho hầu hết nhu cầu sao lưu. Đảm bảo tính toàn vẹn và dễ dàng phục hồi website nhất.

Mặc định thiết lập là: .zip
```

---

## Cấu hình Google Drive Client ID cá nhân (Nâng cao) (`wptt-rclone-custom-id`)

- **Danh mục:** Sao lưu & Khôi phục
- **Vị trí menu:** Menu chính › 5. Sao lưu & Khôi phục › 24. Cấu hình Google Drive Client ID cá nhân (Nâng cao)  _(bấm lần lượt: 5 → 24)_
- **Tệp nguồn:** `/etc/wptt/backup-restore/wptt-rclone-custom-id`

```text
Tính năng cấu hình Client ID Google Drive cá nhân [Google Drive Custom Client ID] giúp bạn sử dụng giao thức API riêng biệt để kết nối máy chủ với kho lưu trữ Google Drive.

Mặc định hệ thống sử dụng một Client ID dùng chung cho hàng triệu người dùng rclone, dẫn đến việc thường xuyên bị Google bóp băng thông, giới hạn lượt tải [gây ra lỗi 429 Too Many Requests]. Đặc biệt, Client ID mặc định này sẽ bị Google ngừng hỗ trợ hoàn toàn vào năm 2026.

Khi bạn thiết lập thông số này, quá trình sao lưu website lên Google Drive sẽ hoạt động trên một luồng API độc lập của chính bạn. Điều này mang lại lợi ích khổng lồ: bứt tốc độ upload tối đa, ổn định tuyệt đối, không chia sẻ hạn mức với ai và loại bỏ hoàn toàn tình trạng kẹt tiến trình.

Lưu ý: Bạn cần truy cập Google Cloud Console để khởi tạo Client ID và Client Secret riêng, sau đó nạp thông số vào tính năng này.
```

---

## Tải mã nguồn WordPress (`wptt-install-wordpress2`)

- **Danh mục:** Tải mã nguồn WordPress
- **Vị trí menu:** Menu chính › 6. Tải mã nguồn WordPress  _(bấm lần lượt: 6)_
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 5. Reset lại về WordPress mới  _(bấm lần lượt: 1 → 5)_
- **Tệp nguồn:** `/etc/wptt/wptt-install-wordpress2`

```text
Tính năng cài đặt mã nguồn WordPress, thì đây là một chức năng tự động hóa mạnh mẽ, giúp bạn triển khai một website WordPress hoàn toàn mới lên máy chủ một cách nhanh chóng và dễ dàng.

Tính năng Cài đặt Mã nguồn WordPress [WPTangToc OLS]
🚀 Mục đích chính:
* Tiết kiệm Thời gian &
Công sức: Thay vì phải thực hiện hàng loạt bước thủ công [tạo database, tải WordPress, cấu hình wp-config.php, chạy cài đặt], tính năng này sẽ làm tất cả chỉ bằng một vài thao tác hoặc một lệnh.
* Chuẩn hóa Cài đặt: Đảm bảo các website mới được cài đặt theo một cấu trúc và cấu hình chuẩn, có thể đã được tối ưu sẵn cho môi trường OpenLiteSpeed và các tính năng khác của WPTangToc OLS.
* Giảm thiểu Lỗi: Tự động hóa giúp hạn chế tối đa các sai sót có thể xảy ra khi thực hiện thủ công.
* Thân thiện với Người dùng: Giúp cả những người không quá rành về kỹ thuật cũng có thể dễ dàng tạo một website WordPress mới.
* [MỚI] An toàn dữ liệu: Nếu website đã có mã nguồn hoặc Database từ trước, hệ thống sẽ tự động đưa dữ liệu cũ vào Thùng rác ảo thay vì xóa vĩnh viễn ngay lập tức, phòng khi cài nhầm domain.

✅ Lợi ích:
* Triển khai Nhanh: Tạo website mới chỉ trong vài phút.
* Dễ dàng &
Tiện lợi: Quy trình đơn giản hóa.
* Tối ưu Sẵn: Website mới có khả năng được cài đặt với các thiết lập tối ưu cho OLS.
* Có thể khôi phục: Dữ liệu source và database cũ, nếu có, được lưu tạm ở Thùng rác trước khi bị dọn dẹp định kỳ.
Tóm lại: Tính năng cài đặt mã nguồn WordPress trong WPTangToc OLS là một công cụ tự động hóa giúp đơn giản hóa và tăng tốc quá trình tạo một website WordPress mới trên máy chủ OpenLiteSpeed, đồng thời đảm bảo website được thiết lập theo các tiêu chuẩn có thể đã được tối ưu hóa bởi bộ công cụ này.
```

---

## Quản lý Service Application (`wptt-service-main`)

- **Danh mục:** Quản lý Service Application
- **Vị trí menu:** Menu chính › 7. Quản lý Service Application  _(bấm lần lượt: 7)_
- **Tệp nguồn:** `/etc/wptt/wptt-service-main`

```text
Tính năng Quản lý Dịch vụ [Service Management] trong WPTangToc OLS là một công cụ tích hợp giúp người dùng dễ dàng kiểm soát trạng thái hoạt động của các dịch vụ thiết yếu trên máy chủ.

Giới thiệu ngắn gọn:

Mục đích: Cho phép người dùng nhanh chóng khởi động [start], dừng [stop], khởi động lại [restart] và kiểm tra trạng thái [status] của các dịch vụ quan trọng như OpenLiteSpeed, PHP, MariaDB/MySQL, và các dịch vụ khác liên quan mà WPTangToc OLS quản lý.
Cách hoạt động:
* Cung cấp menu hoặc các lệnh đơn giản để người dùng thực hiện các thao tác quản lý dịch vụ mà không cần nhớ các lệnh hệ thống phức tạp của Linux.
* Hiển thị trạng thái hiện tại của dịch vụ [ví dụ: đang chạy, đã dừng].
Lợi ích:
* Tiện lợi: Dễ dàng quản lý các dịch vụ cốt lõi.
* Nhanh chóng: Thực hiện các thao tác start/stop/restart một cách nhanh chóng khi cần thiết, ví dụ như sau khi thay đổi cấu hình.
* Kiểm soát: Giúp người dùng dễ dàng kiểm tra xem các dịch vụ quan trọng có đang hoạt động bình thường hay không.
* Gỡ lỗi: Hỗ trợ quá trình khắc phục sự cố bằng cách cho phép khởi động lại các dịch vụ có vấn đề.

Tính năng này giúp đơn giản hóa việc quản trị các thành phần nền tảng của máy chủ web, làm cho việc vận hành và bảo trì trở nên dễ dàng hơn, đặc biệt với những người không quá quen thuộc với dòng lệnh Linux.
```

---

## Bật Service Application (`wptt-start-main`)

- **Danh mục:** Quản lý Service Application
- **Vị trí menu:** Menu chính › 7. Quản lý Service Application › 1. Bật Service Application  _(bấm lần lượt: 7 → 1)_
- **Vị trí menu:** Menu chính › 7. Quản lý Service Application › 1. Bật Service Application › 1. ${start_mariadb:-Khởi động MariaDB}  _(bấm lần lượt: 7 → 1 → 1)_
- **Vị trí menu:** Menu chính › 7. Quản lý Service Application › 1. Bật Service Application › 2. ${start_lsws:-Khởi động LiteSpeed}  _(bấm lần lượt: 7 → 1 → 2)_
- **Vị trí menu:** Menu chính › 7. Quản lý Service Application › 1. Bật Service Application › 3. ${start_nftables:-Khởi động Nftables}  _(bấm lần lượt: 7 → 1 → 3)_
- **Tệp nguồn:** `/etc/wptt/service/wptt-start-main`

```text
WPTangToc OLS được thiết kế để đơn giản hóa việc cài đặt và quản lý máy chủ web, đặc biệt cho các trang web WordPress. Việc quản lý các dịch vụ [services] của máy chủ, bao gồm cả việc khởi động [start] chúng, là một phần quan trọng trong các tính năng của WPTangToc OLS.

Giới thiệu ngắn gọn về quản lý start service trong WPTangToc OLS:

* Giao diện quản lý tập trung: Tương tự như việc reboot hay stop service, WPTangToc OLS thường cung cấp một mục quản lý dịch vụ chuyên biệt trong menu chính của nó, có thể được gọi là Quản lý Service Application hoặc một tên tương tự. Thông qua giao diện này, người dùng có thể thực hiện thao tác khởi động các dịch vụ cần thiết của webserver.
* Đơn giản hóa thao tác: Thay vì phải sử dụng các lệnh Linux truyền thống để khởi động dịch vụ [ví dụ: sudo systemctl start lsws để khởi động OpenLiteSpeed], WPTangToc OLS cho phép người dùng thực hiện điều này thông qua vài lựa chọn đơn giản trong menu của nó. Điều này giúp người dùng, kể cả những người không chuyên sâu về kỹ thuật, cũng có thể dễ dàng quản lý máy chủ.

Khởi động các dịch vụ cụ thể: WPTangToc OLS cho phép bạn chủ động dừng các dịch vụ quan trọng của webserver khi cần thiết, ví dụ như:
* OpenLiteSpeed [lsws]: Dịch vụ webserver.
* MariaDB/MySQL: Dịch vụ cơ sở dữ liệu.
* Redis/Memcached: Dịch vụ object cache.
* Fail2ban: Dịch vụ đọc log chặn IP.
* CSF: Tường lửa.
* Firewalld: Tường lửa.
* Monit: dịch vụ giám sát restart nếu các service quan trọng bị lỗi.
* Các dịch vụ khác đang chạy trên máy chủ.

Tóm lại, WPTangToc OLS giúp việc khởi động các dịch vụ trên máy chủ trở nên trực quan và dễ dàng hơn, thông qua một menu quản lý tập trung, giúp người dùng tiết kiệm thời gian và giảm thiểu sai sót so với việc sử dụng dòng lệnh thuần túy.
```

---

## Tắt Service Application (`wptt-stop-main`)

- **Danh mục:** Quản lý Service Application
- **Vị trí menu:** Menu chính › 7. Quản lý Service Application › 2. Tắt Service Application  _(bấm lần lượt: 7 → 2)_
- **Vị trí menu:** Menu chính › 7. Quản lý Service Application › 2. Tắt Service Application › 1. ${stop_mariadb:-Dừng MariaDB}  _(bấm lần lượt: 7 → 2 → 1)_
- **Vị trí menu:** Menu chính › 7. Quản lý Service Application › 2. Tắt Service Application › 2. ${stop_lsws:-Dừng LiteSpeed}  _(bấm lần lượt: 7 → 2 → 2)_
- **Vị trí menu:** Menu chính › 7. Quản lý Service Application › 2. Tắt Service Application › 3. ${stop_nftables:-Dừng Nftables}  _(bấm lần lượt: 7 → 2 → 3)_
- **Tệp nguồn:** `/etc/wptt/service/wptt-stop-main`

```text
WPTangToc OLS, bộ script tối ưu hóa việc cài đặt và quản trị máy chủ web cũng cung cấp tính năng quản lý việc dừng [stop] các dịch vụ một cách tiện lợi.

Giới thiệu ngắn gọn về quản lý stop service trong WPTangToc OLS:

* Giao diện quản lý tập trung: Giống như các thao tác khởi động [start] hay khởi động lại [reboot], WPTangToc OLS tích hợp chức năng dừng dịch vụ trong một mục quản lý chung, thường được đặt tên là Quản lý Service Application hoặc tương tự trong menu chính.
* Đơn giản hóa thao tác: Thay vì phải dùng các lệnh phức tạp của Linux để dừng một dịch vụ [ví dụ: sudo systemctl stop lsws để dừng OpenLiteSpeed], người dùng có thể thực hiện việc này thông qua vài lựa chọn đơn giản ngay trong menu của WPTangToc OLS. Điều này đặc biệt hữu ích cho người dùng không quen với dòng lệnh.

Dừng các dịch vụ cụ thể: WPTangToc OLS cho phép bạn chủ động dừng các dịch vụ quan trọng của webserver khi cần thiết, ví dụ như:
* OpenLiteSpeed [lsws]: Dịch vụ webserver.
* MariaDB/MySQL: Dịch vụ cơ sở dữ liệu.
* Redis/Memcached: Dịch vụ object cache.
* Fail2ban: Dịch vụ đọc log chặn IP.
* CSF: Tường lửa.
* Firewalld: Tường lửa.
* Monit: dịch vụ giám sát restart nếu các service quan trọng bị lỗi.
* Các dịch vụ khác đang chạy trên máy chủ.

Tóm lại, WPTangToc OLS cung cấp một phương thức trực quan và dễ sử dụng để dừng các dịch vụ trên máy chủ OpenLiteSpeed, giúp người quản trị kiểm soát tốt hơn hoạt động của server mà không cần phải ghi nhớ nhiều lệnh phức tạp.
```

---

## Reboot Service Application (`wptt-reboot-main`)

- **Danh mục:** Quản lý Service Application
- **Vị trí menu:** Menu chính › 7. Quản lý Service Application › 3. Reboot Service Application  _(bấm lần lượt: 7 → 3)_
- **Vị trí menu:** Menu chính › 7. Quản lý Service Application › 3. Reboot Service Application › 1. ${restart_mariadb:-Khởi động lại MariaDB}  _(bấm lần lượt: 7 → 3 → 1)_
- **Vị trí menu:** Menu chính › 7. Quản lý Service Application › 3. Reboot Service Application › 2. ${restart_lsws:-Khởi động lại LiteSpeed}  _(bấm lần lượt: 7 → 3 → 2)_
- **Vị trí menu:** Menu chính › 7. Quản lý Service Application › 3. Reboot Service Application › 3. ${restart_nftables:-Khởi động lại Nftables}  _(bấm lần lượt: 7 → 3 → 3)_
- **Tệp nguồn:** `/etc/wptt/service/wptt-reboot-main`

```text
Quản lý Reboot Service trong WPTangToc OLS: Đơn giản và Tự động hóa
WPTangToc OLS cung cấp các tính năng giúp đơn giản hóa việc quản lý dịch vụ [service], bao gồm cả việc khởi động lại [reboot] các service quan trọng.

Điểm chính về quản lý reboot service trong WPTangToc OLS:
* Giao diện quản lý chuyên biệt: WPTangToc OLS tích hợp một mục riêng thường được gọi là Quản lý Service Application [hoặc tương tự] trong menu quản trị chính của nó. Thông qua mục này, người dùng có thể dễ dàng thực hiện các thao tác như khởi động lại [restart/reboot] hoặc dừng các dịch vụ quan trọng của webserver, bao gồm cả OpenLiteSpeed.
* Đơn giản hóa thao tác: Thay vì phải nhớ và gõ các dòng lệnh phức tạp của Linux [ví dụ: sudo systemctl restart lsws để khởi động lại OpenLiteSpeed], WPTangToc OLS cung cấp một giao diện lựa chọn hoặc lệnh đơn giản hơn trong menu của nó để thực hiện các tác vụ này.
* Tự động giám sát và khởi động lại: Một tính năng đáng chú ý được đề cập là khả năng cảnh báo service webserver quan trọng và tự động reboot lại service đó nếu nó dừng hoạt động. Điều này có nghĩa là WPTangToc OLS có thể chủ động theo dõi tình trạng của các dịch vụ thiết yếu và tự động khởi động lại chúng nếu phát hiện sự cố, giúp tăng tính ổn định cho website.

Khởi động lại các dịch vụ cụ thể: WPTangToc OLS cho phép bạn chủ động dừng các dịch vụ quan trọng của webserver khi cần thiết, ví dụ như:
* OpenLiteSpeed [lsws]: Dịch vụ webserver.
* MariaDB/MySQL: Dịch vụ cơ sở dữ liệu.
* Redis/Memcached: Dịch vụ object cache.
* Fail2ban: Dịch vụ đọc log chặn IP.
* CSF: Tường lửa.
* Firewalld: Tường lửa.
* Monit: dịch vụ giám sát restart nếu các service quan trọng bị lỗi.
* Các dịch vụ khác đang chạy trên máy chủ.

Tóm lại, WPTangToc OLS đơn giản hóa việc quản lý reboot service cho OpenLiteSpeed bằng cách cung cấp một giao diện thân thiện hơn và các tính năng tự động hóa, giúp người dùng, ngay cả những người ít kinh nghiệm về quản trị máy chủ, cũng có thể dễ dàng duy trì hoạt động ổn định cho webserver của mình.
```

---

## Khởi động lại VPS/Server (`reboot-server`)

- **Danh mục:** Quản lý Service Application
- **Vị trí menu:** Menu chính › 7. Quản lý Service Application › 5. Khởi động lại VPS/Server  _(bấm lần lượt: 7 → 5)_
- **Tệp nguồn:** `/etc/wptt/service/reboot-server`

```text
Tính năng này sẽ thực hiện khởi động lại [Reboot] toàn bộ VPS/Server.
💡 Khi nào nên sử dụng?
1: Khi hệ thống bị treo, giật lag nặng hoặc RAM bị rò rỉ [Memory Leak].
2: Sau khi cập nhật nhân hệ điều hành [Kernel] hoặc các gói phần mềm lõi.
3: Khi Database hoặc Web Server gặp lỗi không thể khởi động lại bằng lệnh thường.

⚠️ CẢNH BÁO QUAN TRỌNG:
- Toàn bộ website trên máy chủ sẽ bị gián đoạn truy cập từ 1 đến 5 phút
tùy thuộc vào tốc độ khởi động của nhà cung cấp VPS.
- Hãy đảm bảo không có tiến trình nào [như Backup] đang chạy dở dang.
```

---

## Kiểm tra phiên bản service (`wptt-kiem-tra-version`)

- **Danh mục:** Quản lý Service Application
- **Vị trí menu:** Menu chính › 7. Quản lý Service Application › 6. Kiểm tra phiên bản service  _(bấm lần lượt: 7 → 6)_
- **Vị trí menu:** Menu chính › 10. Quản lý cập nhật webserver › 10. Kiểm tra phiên bản service  _(bấm lần lượt: 10 → 10)_
- **Tệp nguồn:** `/etc/wptt/update/wptt-kiem-tra-version`

```text
Tính năng kiểm tra phiên bản những service quan trọng, thì đây là một chức năng chẩn đoán và thông tin rất hữu ích, giúp bạn nhanh chóng xem được các phiên bản cụ thể của các phần mềm/dịch vụ cốt lõi đang chạy trên máy chủ của bạn.

Tính năng Kiểm tra Phiên bản Service
Mục đích chính:
Việc biết chính xác phiên bản của các dịch vụ là rất cần thiết cho nhiều mục đích:
* Khắc phục sự cố [Troubleshooting]: Khi website gặp lỗi, biết phiên bản giúp xác định xem có phải do xung đột hoặc lỗi đã biết của một phần mềm cụ thể hay không.
* Kiểm tra Tương thích: Đảm bảo rằng phiên bản máy chủ [PHP, MariaDB] đáp ứng yêu cầu của phiên bản WordPress, theme, và plugin mà bạn đang sử dụng hoặc định cài đặt.
* Đánh giá Bảo mật: Phát hiện các dịch vụ đang chạy phiên bản cũ, có thể chứa lỗ hổng bảo mật chưa được vá.
* Lập kế hoạch Cập nhật: Giúp bạn biết dịch vụ nào cần được nâng cấp lên phiên bản mới hơn.
* Cung cấp Thông tin Hỗ trợ: Khi bạn cần nhờ hỗ trợ kỹ thuật, việc cung cấp chính xác các phiên bản đang dùng là thông tin cơ bản và quan trọng.

Lợi ích khi có tính năng này trong WPTangToc OLS:
* Tiện lợi: Chỉ cần một lệnh hoặc một tùy chọn menu để xem tất cả thông tin quan trọng, thay vì phải gõ nhiều lệnh khác nhau.
* Nhanh chóng: Cung cấp một cái nhìn tổng quan tức thì về sức khỏe và cấu hình phần mềm của máy chủ.
* Dễ dàng: Giúp người dùng không rành về dòng lệnh cũng có thể xem được thông tin cần thiết.

Tóm lại: Tính năng kiểm tra phiên bản dịch vụ trong WPTangToc OLS là một công cụ chẩn đoán và cung cấp thông tin hữu ích, giúp bạn nắm rõ cấu hình phần mềm trên máy chủ, hỗ trợ đắc lực cho việc khắc phục sự cố, lên kế hoạch cập nhật và đảm bảo an ninh, tương thích cho website WordPress của bạn.
```

---

## Thiết lập cảnh báo service ngừng hoạt động (`wptt-auto-reboot-thiet-lap`)

- **Danh mục:** Quản lý Service Application
- **Vị trí menu:** Menu chính › 7. Quản lý Service Application › 7. Thiết lập cảnh báo service ngừng hoạt động  _(bấm lần lượt: 7 → 7)_
- **Tệp nguồn:** `/etc/wptt/service/reboot-app/wptt-auto-reboot-thiet-lap`

```text
Tính năng này giúp bạn nhận ngay tin nhắn báo cáo qua Telegram mỗi khi hệ thống giám sát Monit phát hiện dịch vụ bị sập và tự động cứu hộ [Khởi động lại] thành công.

Lợi ích khi sử dụng:
* Cập nhật thời gian thực: Nắm bắt ngay lập tức tình trạng sức khỏe của máy chủ mọi lúc, mọi nơi ngay trên điện thoại.
* An tâm tuyệt đối: Nhìn thấy bot báo cáo, bạn sẽ biết chắc chắn tính năng Auto-Reboot đang hoạt động bền bỉ để bảo vệ website khỏi thời gian chết [Downtime].
* Phát hiện rủi ro sớm: Nếu thấy một dịch vụ [như MariaDB hay OpenLiteSpeed] liên tục báo sập, bạn sẽ biết ngay để vào server kiểm tra và tối ưu, tránh tình trạng lỗi âm ỉ.
* Tùy biến linh hoạt: Dễ dàng bật/tắt [Chuyển về chế độ cứu hộ im lặng] nếu bạn không muốn bị bot làm phiền.

Lưu ý: Bạn cần phải kết nối Bot Telegram trong mục Bảo mât- trước khi kích hoạt tính năng này. >telegram
```

---

## Quản lý Mở/Khóa IP (`wptt-khoa-ip-main`)

- **Danh mục:** Quản lý Mở/Khóa IP
- **Vị trí menu:** Menu chính › 8. Quản lý Mở/Khóa IP  _(bấm lần lượt: 8)_
- **Tệp nguồn:** `/etc/wptt/wptt-khoa-ip-main`

```text
Tính năng Quản lý Mở Khóa IP / Khóa IP trong WPTangToc OLS là một công cụ giúp bạn dễ dàng kiểm soát việc cho phép hoặc chặn các địa chỉ IP cụ thể truy cập vào máy chủ của mình, thường thông qua việc tương tác với firewall. 🚫✅

Giới thiệu ngắn gọn:
Mục đích: Nâng cao bảo mật máy chủ bằng cách cho phép bạn nhanh chóng chặn các địa chỉ IP đáng ngờ, có hành vi tấn công, hoặc bỏ chặn các IP bị khóa nhầm.
Cách hoạt động:
* Khóa IP [Block IP]: Thêm một hoặc nhiều địa chỉ IP vào danh sách bị chặn của firewall.
* Mở Khóa IP [Unblock IP]: Gỡ bỏ một địa chỉ IP khỏi danh sách bị chặn.
* Kiểm tra IP [có thể]: Xem một IP cụ thể có đang bị chặn hay không.
Lợi ích:
* Phản ứng nhanh với mối đe dọa: Nhanh chóng chặn các IP tấn công hoặc spam.
* Kiểm soát truy cập linh hoạt: Dễ dàng quản lý quyền truy cập cho các IP cụ thể.
* Đơn giản hóa thao tác firewall: Thực hiện các tác vụ chặn/mở IP mà không cần sử dụng các lệnh firewall phức tạp.
* Bảo vệ máy chủ: Giảm thiểu nguy cơ từ các truy cập không mong muốn hoặc độc hại.
Tính năng này là một phần quan trọng của việc quản trị bảo mật máy chủ, giúp bạn duy trì một môi trường an toàn hơn cho website của mình.
```

---

## Khoá ip (`wptt-khoa-ip`)

- **Danh mục:** Quản lý Mở/Khóa IP
- **Vị trí menu:** Menu chính › 8. Quản lý Mở/Khóa IP › 1. Khoá ip  _(bấm lần lượt: 8 → 1)_
- **Tệp nguồn:** `/etc/wptt/fail2ban/wptt-khoa-ip`

```text
Tính năng Chặn IP trong WPTangToc OLS là một công cụ bảo mật quan trọng, cho phép người quản trị máy chủ ngăn chặn truy cập từ các địa chỉ IP cụ thể đến website hoặc toàn bộ máy chủ. Đây là một biện pháp hiệu quả để đối phó với các hoạt động gây hại như tấn công DDoS, brute-force, spam, hoặc truy cập trái phép từ những nguồn đã biết.
```

---

## Mở khoá ip (`wptt-mokhoaip`)

- **Danh mục:** Quản lý Mở/Khóa IP
- **Vị trí menu:** Menu chính › 8. Quản lý Mở/Khóa IP › 2. Mở khoá ip  _(bấm lần lượt: 8 → 2)_
- **Tệp nguồn:** `/etc/wptt/fail2ban/wptt-mokhoaip`

```text
Tính năng Mở khóa IP [hay gỡ chặn IP] trong WPTangToc OLS là chức năng đối ngược với tính năng Chặn IP. Nó cho phép người quản trị máy chủ loại bỏ một địa chỉ IP cụ thể ra khỏi danh sách bị chặn, khôi phục quyền truy cập của IP đó vào website hoặc toàn bộ máy chủ.

Mục đích chính của tính năng Mở khóa IP:
* Sửa lỗi chặn nhầm: Trong một số trường hợp, IP của người dùng hợp lệ hoặc thậm chí IP của chính quản trị viên có thể vô tình bị chặn. Tính năng mở khóa IP giúp khắc phục tình trạng này.
* Thay đổi chính sách truy cập: Khi một IP trước đây bị coi là mối đe dọa nhưng nay đã được xác minh là an toàn.
* Quản lý danh sách chặn linh hoạt: Cho phép quản trị viên duy trì một danh sách IP bị chặn chính xác và cập nhật.
```

---

## Danh sách IP bị khóa (`wptt-list`)

- **Danh mục:** Quản lý Mở/Khóa IP
- **Vị trí menu:** Menu chính › 8. Quản lý Mở/Khóa IP › 3. Danh sách IP bị khóa  _(bấm lần lượt: 8 → 3)_
- **Tệp nguồn:** `/etc/wptt/fail2ban/wptt-list`

```text
Tính năng Xem toàn bộ danh sách IP bị chặn trong WPTangToc OLS là một công cụ quản trị cho phép người dùng kiểm tra và theo dõi tất cả các địa chỉ IP hoặc dải mạng (CIDR) hiện đang bị ngăn chặn truy cập vào máy chủ trên mọi lớp bảo mật (SSHGuard, Fail2ban, CSF, Nftables, Firewalld và OpenLiteSpeed).
```

---

## Mở khoá ip tất cả (`unban-all`)

- **Danh mục:** Quản lý Mở/Khóa IP
- **Vị trí menu:** Menu chính › 8. Quản lý Mở/Khóa IP › 4. Mở khoá ip tất cả  _(bấm lần lượt: 8 → 4)_
- **Tệp nguồn:** `/etc/wptt/fail2ban/unban-all`

```text
Tính năng Mở khóa toàn bộ IP [Unban All] trong WPTangToc OLS giúp người quản trị xóa nhanh toàn bộ danh sách đen (Blacklist) đang bị khóa trên tất cả các lớp bảo vệ của máy chủ (SSHGuard, Fail2ban, CSF, Nftables, Firewalld và OpenLiteSpeed).

Mục đích sử dụng:
* Khắc phục sự cố chặn nhầm hàng loạt sau khi cấu hình sai ngưỡng bảo mật hoặc sau đợt kiểm thử chịu tải (Stress Test).
* Làm sạch toàn bộ bộ nhớ tường lửa để đưa hệ thống về trạng thái ban đầu.
```

---

## Quản lý SSH/SFTP (`wptt-ssh-main`)

- **Danh mục:** Quản lý SSH/SFTP
- **Vị trí menu:** Menu chính › 9. Quản lý SSH/SFTP  _(bấm lần lượt: 9)_
- **Tệp nguồn:** `/etc/wptt/wptt-ssh-main`

```text
Tính năng Quản lý SSH trong WPTangToc OLS là một công cụ giúp bạn cấu hình và tăng cường bảo mật cho dịch vụ SSH [Secure Shell] trên máy chủ của mình một cách thuận tiện. 🔐

Giới thiệu ngắn gọn:

Mục đích: Đơn giản hóa việc thay đổi các cài đặt SSH phổ biến để bảo vệ máy chủ khỏi các truy cập trái phép và làm cho việc quản trị qua SSH an toàn hơn.
Cách hoạt động:
* Thay đổi cổng SSH: Đổi cổng SSH mặc định [22] sang một cổng khác để giảm thiểu các cuộc tấn công tự động.
* Tắt/Bật đăng nhập của root: Vô hiệu hóa quyền đăng nhập trực tiếp của người dùng root qua SSH.
* Thay đổi mật khẩu username.
* v.v.v

Lợi ích:
* Nâng cao bảo mật: Giảm bề mặt tấn công cho máy chủ.
* Quản lý tiện lợi: Dễ dàng thực hiện các thay đổi cấu hình SSH quan trọng mà không cần sửa file thủ công.
* Tuân thủ thực hành tốt nhất: Hỗ trợ người dùng áp dụng các khuyến nghị bảo mật cho SSH.

Tính năng này giúp bạn củng cố một trong những cửa ngõ quan trọng nhất vào máy chủ của mình, đảm bảo an toàn cho hệ thống.
```

---

## Thay đổi password (`wptt-passwd`)

- **Danh mục:** Quản lý SSH/SFTP
- **Vị trí menu:** Menu chính › 9. Quản lý SSH/SFTP › 1. Thay đổi password  _(bấm lần lượt: 9 → 1)_
- **Tệp nguồn:** `/etc/wptt/ssh/wptt-passwd`

```text
Việc thay đổi mật khẩu [password] người dùng trên hệ điều hành Linux là một thao tác cơ bản và cực kỳ quan trọng để đảm bảo an toàn cho tài khoản và dữ liệu của bạn cũng như toàn bộ hệ thống.

Dưới đây là giới thiệu ngắn gọn về tính năng này:

Tại sao cần thay đổi mật khẩu Linux?
* Bảo mật định kỳ: Thay đổi mật khẩu thường xuyên giúp giảm thiểu rủi ro nếu mật khẩu cũ vô tình bị lộ hoặc bị dò đoán.
* Sau khi thiết lập ban đầu: Nếu bạn nhận được máy chủ hoặc tài khoản với mật khẩu mặc định hoặc mật khẩu tạm thời, việc đầu tiên cần làm là đổi mật khẩu.
* Nghi ngờ bị xâm phạm: Nếu có bất kỳ dấu hiệu nào cho thấy tài khoản của bạn có thể đã bị truy cập trái phép, hãy đổi mật khẩu ngay lập tức.
* Tuân thủ chính sách bảo mật: Nhiều tổ chức yêu cầu người dùng thay đổi mật khẩu định kỳ theo chính sách bảo mật.
* Khi quên mật khẩu [đối với quản trị viên]: Quản trị viên có thể cần đặt lại mật khẩu cho người dùng nếu họ quên.

Việc thay đổi mật khẩu là một phần thiết yếu của việc duy trì an ninh cho bất kỳ hệ thống Linux nào.
```

---

## Thay đổi port SSH/SFTP (`wptt-ssh-port`)

- **Danh mục:** Quản lý SSH/SFTP
- **Vị trí menu:** Menu chính › 9. Quản lý SSH/SFTP › 2. Thay đổi port SSH/SFTP  _(bấm lần lượt: 9 → 2)_
- **Tệp nguồn:** `/etc/wptt/ssh/wptt-ssh-port`

```text
Việc thay đổi cổng [port] SSH mặc định [thường là cổng 22] là một trong những biện pháp bảo mật cơ bản và hiệu quả cho máy chủ Linux.

Dưới đây là giới thiệu ngắn gọn về tính năng này:

Tại sao cần thay đổi cổng SSH?
* Giảm thiểu tấn công tự động [Automated Attacks]: Rất nhiều bot và script độc hại tự động quét cổng 22. Việc đổi sang cổng khác làm giảm đáng kể các cuộc tấn công này.
* Tăng cường bảo mật qua việc ẩn náu [Security through obscurity].
* Tránh xung đột cổng [Port Conflicts].

Lợi ích chính:
* Giảm đáng kể log tấn công brute-force.
* Làm cho máy chủ của bạn ít bị chú ý hơn.
```

---

## Quản lý cập nhật webserver (`wptt-update-main`)

- **Danh mục:** Quản lý cập nhật webserver
- **Vị trí menu:** Menu chính › 10. Quản lý cập nhật webserver  _(bấm lần lượt: 10)_
- **Tệp nguồn:** `/etc/wptt/wptt-update-main`

```text
Tính năng Quản lý Cập nhật [Update Management] trong WPTangToc OLS là một chức năng cốt lõi giúp bạn dễ dàng nâng cấp bản thân script WPTangToc OLS, Webserver, Linux... lên phiên bản mới nhất. 🚀

Giới thiệu ngắn gọn:

Mục đích: Đảm bảo bạn luôn sử dụng phiên bản mới nhất, đi kèm với các bản vá lỗi, cải tiến hiệu suất, tính năng mới được bổ sung, và các cập nhật tương thích hoặc bảo mật liên quan đến việc quản lý máy chủ.

Cách hoạt động:
* WPTangToc OLS cung cấp một lệnh hoặc tùy chọn trong menu chính của nó.
* script sẽ kiểm tra phiên bản mới nhất từ nguồn phát hành chính thức và tiến hành tải về, cài đặt bản cập nhật.

Lợi ích:
* An toàn và ổn định: Luôn nhận được các bản vá lỗi và cập nhật bảo mật mới nhất cho chính công cụ quản lý.
* Tính năng mới: Tiếp cận sớm các công cụ và tùy chọn quản lý máy chủ tiên tiến.
* Hiệu suất tối ưu: Hưởng lợi từ các cải tiến giúp script hoạt động hiệu quả hơn.
* Tiện lợi: Quá trình cập nhật thường được tự động hóa, giúp bạn tiết kiệm thời gian và công sức.
Việc thường xuyên sử dụng tính năng này để cập nhật WPTangToc OLS là rất quan trọng để duy trì một môi trường quản lý máy chủ hiện đại, an toàn và hiệu quả.
```

---

## On/OFF auto Update WPTangToc OLS (`wptt-auto-update`)

- **Danh mục:** Quản lý cập nhật webserver
- **Vị trí menu:** Menu chính › 10. Quản lý cập nhật webserver › 2. On/OFF auto Update WPTangToc OLS  _(bấm lần lượt: 10 → 2)_
- **Tệp nguồn:** `/etc/wptt/update/wptt-auto-update`

```text
Tính năng Thiết lập tự động cập nhật WPTangToc OLS là tự động cập nhật lên phiên bản mới nhất khi chúng được phát hành mà không cần bạn can thiệp thủ công.

Mục Đích Chính
* Bảo mật: Đây thường là lý do quan trọng nhất. Các bản cập nhật thường xuyên vá các lỗ hổng bảo mật.
* Tính năng mới và cải tiến: Các phiên bản mới thường mang đến những chức năng mới, cải thiện hiệu suất và sửa lỗi.
* Sửa lỗi: Khắc phục các vấn đề đã được phát hiện ở phiên bản trước.
* Đảm bảo tương thích: Giữ cho các công cụ tăng tốc tương thích với phiên bản WordPress mới nhất, PHP, hoặc máy chủ OpenLiteSpeed.
* Tiện lợi, giảm công sức quản trị: Bạn không cần phải tự mình kiểm tra và cập nhật thủ công thường xuyên.
```

---

## Chuyển nhánh wptangtoc stable (`wptt-update2`)

- **Danh mục:** Quản lý cập nhật webserver
- **Vị trí menu:** Menu chính › 10. Quản lý cập nhật webserver › 3. Chuyển nhánh wptangtoc stable  _(bấm lần lượt: 10 → 3)_
- **Vị trí menu:** Menu chính › 10. Quản lý cập nhật webserver › 4. Chuyển nhánh wptangtoc beta  _(bấm lần lượt: 10 → 4)_
- **Tệp nguồn:** `/etc/wptt/wptt-update2`

```text
Tính năng Chuyển nhánh Beta hoặc Nhánh Chính thức trong WPTangToc OLS cho phép người dùng lựa chọn giữa việc sử dụng phiên bản ổn định [nhánh chính thức] hoặc phiên bản thử nghiệm mới nhất [nhánh beta] của bộ script wptangtoc ols.

Giải thích ngắn gọn:
Nhánh Chính thức [Stable/Main Branch]:
* Đây là phiên bản đã được kiểm thử kỹ lưỡng, được coi là ổn định và đáng tin cậy nhất.
* Khuyến nghị cho hầu hết người dùng, đặc biệt là cho các website quan trọng đang hoạt động [production environment].
* Tập trung vào sự ổn định và các tính năng đã được chứng minh.

Nhánh Beta [Beta Branch]:
* Đây là phiên bản đang trong quá trình phát triển, chứa các tính năng mới nhất, các cải tiến hoặc bản vá lỗi thử nghiệm.
* Người dùng có thể trải nghiệm sớm các cập nhật nhưng cũng có khả năng gặp lỗi hoặc hoạt động chưa ổn định.
* Phù hợp cho người dùng có kinh nghiệm muốn thử nghiệm, đóng góp ý kiến và giúp tác giả phát hiện lỗi trước khi các thay đổi được đưa vào nhánh chính thức.

Tóm lại, tính năng chuyển đổi nhánh trong WPTangToc OLS mang lại sự linh hoạt cho người dùng, cho phép họ lựa chọn giữa sự ổn định của phiên bản chính thức và sự mới mẻ của phiên bản beta, tùy theo nhu cầu và mức độ chấp nhận rủi ro.
```

---

## Rollback WPTangToc OLS (`wptt-rollback-update-wptangtoc`)

- **Danh mục:** Quản lý cập nhật webserver
- **Vị trí menu:** Menu chính › 10. Quản lý cập nhật webserver › 5. Rollback WPTangToc OLS  _(bấm lần lượt: 10 → 5)_
- **Tệp nguồn:** `/etc/wptt/update/wptt-rollback-update-wptangtoc`

```text
Rollback System: Cỗ máy thời gian cho WPTangToc OLS. Cho phép bạn quay lại phiên bản cũ ngay lập tức nếu bản cập nhật mới gặp lỗi hoặc không ưng ý.

An tâm tuyệt đối khi cập nhật! Tính năng Rollback sẽ tự động sao lưu hệ thống trước khi nâng cấp. Bạn có thể khôi phục lại phiên bản ổn định trước đó bất cứ lúc nào chỉ với một phím bấm.
```

---

## Cập nhật toàn bộ webserver (`wptt-update-he-thong`)

- **Danh mục:** Quản lý cập nhật webserver
- **Vị trí menu:** Menu chính › 10. Quản lý cập nhật webserver › 6. Cập nhật toàn bộ webserver  _(bấm lần lượt: 10 → 6)_
- **Tệp nguồn:** `/etc/wptt/update/wptt-update-he-thong`

```text
Tính năng Cập nhật toàn bộ hệ thống Linux là quá trình áp dụng các bản cập nhật phần mềm mới nhất cho toàn bộ hệ điều hành Linux của bạn, bao gồm nhân [kernel], các thư viện hệ thống, các ứng dụng đã cài đặt, và quan trọng nhất là các bản vá bảo mật.

Nói một cách đơn giản, đây là việc bạn làm mới toàn bộ phần mềm trên máy Linux của mình, đưa nó lên phiên bản mới nhất mà nhà phát triển hoặc cộng đồng Linux cung cấp, giống như việc cập nhật Windows hay macOS.

Mục Đích Chính
* Bảo mật [Quan trọng nhất]: Các bản cập nhật thường xuyên vá các lỗ hổng bảo mật mới được phát hiện, giúp bảo vệ hệ thống của bạn khỏi virus, mã độc, và các cuộc tấn công.
* Sửa lỗi [Bug Fixes]: Khắc phục các lỗi đã biết trong phần mềm, giúp hệ thống hoạt động ổn định và đáng tin cậy hơn.
* Tính năng mới và cải tiến: Cập nhật có thể mang đến các chức năng mới, cải thiện hiệu suất, và hỗ trợ phần cứng tốt hơn.
* Đảm bảo tính ổn định: Việc sửa lỗi góp phần vào sự ổn định chung của hệ thống, giảm thiểu nguy cơ treo máy hoặc các hành vi không mong muốn.
* Duy trì hỗ trợ: Các nhà phát triển phần mềm [bao gồm các bản phân phối Linux] sẽ ngừng hỗ trợ các phiên bản cũ. Cập nhật thường xuyên giúp hệ thống của bạn luôn nằm trong diện được hỗ trợ.

Cập nhật toàn bộ hệ thống Linux định kỳ là một trong những việc làm thiết yếu để giữ cho máy tính/máy chủ của bạn an toàn, ổn định và hoạt động hiệu quả.
```

---

## Cập nhật MariaDB (`update-mariadb`)

- **Danh mục:** Quản lý cập nhật webserver
- **Vị trí menu:** Menu chính › 10. Quản lý cập nhật webserver › 7. Cập nhật MariaDB  _(bấm lần lượt: 10 → 7)_
- **Tệp nguồn:** `/etc/wptt/update/update-mariadb`

```text
TÍNH NĂNG CẬP NHẬT MARIADB AN TOÀN [ZERO DATA LOSS]
- Mục đích: Cập nhật máy chủ MariaDB lên bản vá mới nhất để vá lỗ hổng
bảo mật và tăng cường hiệu suất.
- Cơ chế An toàn:
+ Tự động kiểm tra phiên bản: Khước từ chạy nếu DB đã ở bản mới nhất.
+ Tự động kiểm tra ổ cứng và sao lưu vật lý toàn bộ Database trước khi chạy.
+ Tạm ngưng hệ thống giám sát [Monit] để tránh xung đột tiến trình.
+ Bẫy lỗi thông minh [Auto-Rollback]: Nếu quá trình cập nhật bị đứt mạng
hoặc lỗi nhị phân, hệ thống sẽ tự động khôi phục dữ liệu gốc trong tích tắc.
- Lưu ý: Quá trình này hoàn toàn tự động, vui lòng không tắt Terminal.
```

---

## Cập nhật WP CLI (`wptt-wp-cli`)

- **Danh mục:** Quản lý cập nhật webserver
- **Vị trí menu:** Menu chính › 10. Quản lý cập nhật webserver › 9. Cập nhật WP CLI  _(bấm lần lượt: 10 → 9)_
- **Tệp nguồn:** `/etc/wptt/update/wptt-wp-cli`

```text
tính năng cập nhật WP-CLI thì đây là một chức năng tiện ích giúp bạn dễ dàng nâng cấp WP-CLI [WordPress Command-Line Interface] lên phiên bản mới nhất ngay trên máy chủ của mình.

[NÂNG CẤP BẢO MẬT ZERO TRUST]
Tính năng này đã được nâng cấp cơ chế bảo mật GPG. Thay vì tải và cài đặt thông thường, hệ thống sẽ tự động xác thực chữ ký điện tử trực tiếp từ đội ngũ lõi của WP-CLI. Đảm bảo file thực thi an toàn tuyệt đối 100%, không bị giả mạo hay cài cắm mã độc [Man-in-the-Middle].

🎯 Mục đích của tính năng cập nhật WP-CLI:
* Sử dụng Tính năng Mới: WP-CLI liên tục được phát triển.
* Vá lỗi & Tăng Ổn định: Các phiên bản mới sửa các lỗi được phát hiện trong các phiên bản cũ.
* Bảo mật: Đảm bảo tương thích tốt nhất với các phiên bản WordPress mới nhất và PHP.
```

---

## Preload Cache (`wptt-preload-cache2`)

- **Danh mục:** Preload Cache
- **Vị trí menu:** Menu chính › 11. Preload Cache  _(bấm lần lượt: 11)_
- **Tệp nguồn:** `/etc/wptt/wptt-preload-cache2`

```text
Tính năng Preload Cache [Tải trước bộ nhớ đệm] là một kỹ thuật chủ động tạo và lưu trữ các phiên bản đã được cache [lưu tạm] của các trang web [hoặc các tài nguyên khác] trước khi có bất kỳ người dùng nào thực sự truy cập vào những trang đó.

Mục Đích Chính:
* Đảm bảo khách truy cập đầu tiên cũng có trải nghiệm nhanh.
* Cải thiện hiệu suất cảm nhận được & Nâng cao trải nghiệm người dùng.
* Lợi ích SEO [gián tiếp]: Tốc độ website là một yếu tố xếp hạng.
```

---

## Quản lý WebGuiAdmin (`wptt-webadmin-main`)

- **Danh mục:** Quản lý WebGuiAdmin
- **Vị trí menu:** Menu chính › 12. Quản lý WebGuiAdmin  _(bấm lần lượt: 12)_
- **Tệp nguồn:** `/etc/wptt/wptt-webadmin-main`

```text
Tính năng Quản lý WebAdmin GUI trong WPTangToc OLS là một công cụ giúp bạn dễ dàng quản lý quyền truy cập và các thông tin liên quan đến giao diện quản trị web [WebAdmin Console] của OpenLiteSpeed. 🖥️🔐

Giới thiệu ngắn gọn:
Mục đích: Đơn giản hóa việc truy cập và bảo mật cho WebAdmin Console của OpenLiteSpeed [thường chạy trên port 19019], nơi bạn có thể cấu hình chi tiết máy chủ web.

Cách hoạt động :
* Hiển thị thông tin truy cập: Cung cấp nhanh chóng URL và port để truy cập WebAdmin GUI.
* Đặt lại mật khẩu Admin: Cho phép bạn dễ dàng đặt lại mật khẩu cho tài khoản quản trị viên của OpenLiteSpeed WebAdmin nếu bạn quên.
* Thiết lập ban đầu: Trong quá trình cài đặt OpenLiteSpeed, WPTangToc OLS thường sẽ tự động thiết lập tài khoản admin ban đầu cho WebAdmin Console.

Lợi ích:
* Truy cập thuận tiện: Nhanh chóng biết cách vào giao diện quản trị của OpenLiteSpeed.
* Khôi phục dễ dàng: Không lo lắng nếu quên mật khẩu WebAdmin, có thể reset qua WPTangToc OLS.
* Quản lý tập trung: Một số tác vụ cơ bản liên quan đến WebAdmin có thể được thực hiện hoặc hỗ trợ thông qua WPTangToc OLS.
Tính năng này giúp bạn kiểm soát tốt hơn việc truy cập vào khu vực cấu hình quan trọng của OpenLiteSpeed, đồng thời hỗ trợ khi bạn cần lấy lại quyền truy cập.
```

---

## Kích hoạt (`wptt-mo-webgui`)

- **Danh mục:** Quản lý WebGuiAdmin
- **Vị trí menu:** Menu chính › 12. Quản lý WebGuiAdmin › 1. Kích hoạt  _(bấm lần lượt: 12 → 1)_
- **Tệp nguồn:** `/etc/wptt/webadmin/wptt-mo-webgui`

```text
Tính năng WebAdmin GUI [Giao diện Quản trị Web] của OpenLiteSpeed là một công cụ mạnh mẽ và thân thiện, giúp bạn dễ dàng cấu hình và quản lý máy chủ web OpenLiteSpeed mà không cần phải thao tác trực tiếp với các tệp cấu hình qua dòng lệnh.

Dưới đây là giới thiệu về tính năng kích hoạt và sử dụng WebAdmin GUI của OpenLiteSpeed:

Mục đích của WebAdmin GUI:
* Cấu hình trực quan: Cung cấp giao diện đồ họa để bạn có thể xem và chỉnh sửa hầu hết các thiết lập của máy chủ OpenLiteSpeed, từ cài đặt cơ bản đến các tính năng nâng cao.
* Quản lý dễ dàng: Giúp việc quản lý virtual host [các trang web chạy trên cùng máy chủ], listeners [cổng lắng nghe], module, và các thành phần khác trở nên đơn giản hơn.
* Theo dõi thời gian thực: Cung cấp các số liệu thống kê và trạng thái máy chủ theo thời gian thực, giúp bạn giám sát hiệu suất và phát hiện sự cố.
* Giảm thiểu lỗi: Giao diện trực quan giúp hạn chế sai sót so với việc chỉnh sửa thủ công các tệp cấu hình văn bản phức tạp.

WebAdmin GUI là một thành phần không thể thiếu khi làm việc với OpenLiteSpeed, giúp đơn giản hóa đáng kể công việc quản trị máy chủ web, đồng thời cung cấp nhiều công cụ mạnh mẽ để theo dõi và tối ưu hóa hiệu suất.

Ghi chú: sử dụng webguiadmin đồng nghĩa với việc một port được mở ra đồng nghĩa với việc thêm một rủi ro bảo mật.
```

---

## Huỷ kích hoạt (`wptt-dong-webgui`)

- **Danh mục:** Quản lý WebGuiAdmin
- **Vị trí menu:** Menu chính › 12. Quản lý WebGuiAdmin › 2. Huỷ kích hoạt  _(bấm lần lượt: 12 → 2)_
- **Tệp nguồn:** `/etc/wptt/webadmin/wptt-dong-webgui`

```text
mặc dù WebAdmin GUI của OpenLiteSpeed rất hữu ích, có những trường hợp bạn muốn hủy kích hoạt [vô hiệu hóa] nó, chủ yếu vì lý do bảo mật sau khi đã hoàn tất cấu hình ban đầu hoặc nếu bạn chỉ muốn quản lý máy chủ qua dòng lệnh.

Dưới đây là giới thiệu ngắn gọn về tính năng hủy kích hoạt WebAdmin GUI của OpenLiteSpeed:

Mục đích của việc hủy kích hoạt WebAdmin GUI:
* Tăng cường bảo mật: Giảm bề mặt tấn công [attack surface] của máy chủ. Việc không có một giao diện quản trị web chạy công khai sẽ loại bỏ một vectơ tấn công tiềm năng.
* Tuân thủ chính sách: Một số chính sách bảo mật yêu cầu hạn chế tối đa các giao diện quản trị qua web.
* Quản lý tập trung: Nếu bạn quản lý nhiều máy chủ và sử dụng các công cụ quản lý cấu hình tự động [như Ansible, Puppet, Chef], việc phụ thuộc vào WebAdmin GUI có thể không cần thiết.

Việc hủy kích hoạt WebAdmin GUI là một biện pháp bảo mật tốt sau khi bạn đã hoàn tất việc thiết lập ban đầu cho máy chủ OpenLiteSpeed của mình và ưa thích quản lý qua dòng lệnh hoặc các công cụ tự động hóa.
```

---

## Đổi cổng port (`wptt-doi-port-webadmin`)

- **Danh mục:** Quản lý WebGuiAdmin
- **Vị trí menu:** Menu chính › 12. Quản lý WebGuiAdmin › 3. Đổi cổng port  _(bấm lần lượt: 12 → 3)_
- **Tệp nguồn:** `/etc/wptt/webadmin/wptt-doi-port-webadmin`

```text
Việc thay đổi cổng [port] mặc định [thường là 19019] của WebAdmin GUI OpenLiteSpeed là một biện pháp bảo mật hữu ích, giúp ẩn giao diện quản trị khỏi các máy quét cổng tự động và giảm thiểu nguy cơ bị tấn công.

Dưới đây là giới thiệu ngắn gọn về tính năng này:

Tại sao cần đổi cổng WebAdmin GUI?
* Bảo mật qua việc ẩn náu [Security through obscurity]: Hầu hết các bot và kẻ tấn công tự động thường quét các cổng mặc định của những dịch vụ phổ biến. Việc đổi sang một cổng không chuẩn sẽ khiến giao diện quản trị của bạn khó bị phát hiện hơn.
* Tránh xung đột cổng: Nếu cổng 19019 đang được sử dụng bởi một dịch vụ khác trên máy chủ của bạn, việc đổi cổng cho WebAdmin là cần thiết.
* Tuân thủ chính sách: Một số tổ chức có chính sách yêu cầu thay đổi cổng mặc định của các dịch vụ quản trị.

Luôn nhớ sao lưu tệp cấu hình trước khi thực hiện thay đổi và đảm bảo rằng cổng bạn chọn không bị xung đột với các dịch vụ khác đang chạy trên máy chủ.
```

---

## Thay đổi ID va Password (`wptt-thay-doi-password-user`)

- **Danh mục:** Quản lý WebGuiAdmin
- **Vị trí menu:** Menu chính › 12. Quản lý WebGuiAdmin › 4. Thay đổi ID va Password  _(bấm lần lượt: 12 → 4)_
- **Tệp nguồn:** `/etc/wptt/webadmin/wptt-thay-doi-password-user`

```text
thay đổi tài khoản [username] và mật khẩu [password] cho WebAdmin GUI của OpenLiteSpeed là một thao tác quản trị quan trọng để duy trì bảo mật cho máy chủ của bạn.

Dưới đây là giới thiệu ngắn gọn về tính năng này:

Tại sao cần thay đổi tài khoản và mật khẩu WebAdmin?
* Bảo mật định kỳ: Thay đổi mật khẩu thường xuyên là một biện pháp bảo mật tốt để giảm thiểu rủi ro nếu thông tin đăng nhập cũ bị lộ.
* Sau khi người dùng cũ rời đi: Nếu người quản trị trước đó không còn làm việc, bạn cần thay đổi thông tin đăng nhập để đảm bảo chỉ những người được ủy quyền mới có quyền truy cập.
* Nghi ngờ bị xâm phạm: Nếu có bất kỳ nghi ngờ nào về việc tài khoản quản trị có thể đã bị xâm phạm, việc thay đổi ngay lập tức là cần thiết.
* Thiết lập ban đầu không an toàn: Nếu bạn sử dụng mật khẩu yếu trong quá trình cài đặt ban đầu, bạn nên đổi sang một mật khẩu mạnh hơn.

cập nhật thông tin đăng nhập cho giao diện quản trị WebAdmin của OpenLiteSpeed, giúp bạn bảo vệ máy chủ web của mình một cách hiệu quả.
```

---

## Xem lại thông tin tài khoản (`wptt-check-tk-webguiadmin`)

- **Danh mục:** Quản lý WebGuiAdmin
- **Vị trí menu:** Menu chính › 12. Quản lý WebGuiAdmin › 5. Xem lại thông tin tài khoản  _(bấm lần lượt: 12 → 5)_
- **Tệp nguồn:** `/etc/wptt/webadmin/wptt-check-tk-webguiadmin`

```text
Tính năng này để xem lại tài khoản login webguiadmin openlitespeed
```

---

## Cấu hình LiteSpeed (`wptt-sua-websever`)

- **Danh mục:** Cấu hình Webserver
- **Vị trí menu:** Menu chính › 13. Cấu hình Webserver › 1. Cấu hình LiteSpeed  _(bấm lần lượt: 13 → 1)_
- **Tệp nguồn:** `/etc/wptt/cau-hinh/wptt-sua-websever`

```text
Tính năng Sửa cấu hình OpenLiteSpeed là quá trình điều chỉnh các thiết lập và tham số của máy chủ web OpenLiteSpeed để tùy biến cách nó hoạt động, hiệu suất, bảo mật, và cách nó phục vụ các website được lưu trữ trên đó.

Nói một cách đơn giản, OpenLiteSpeed [OLS] là một đầu bếp hiệu suất cao cho website của bạn. Sửa cấu hình là việc bạn hướng dẫn đầu bếp này cách nấu nướng [phục vụ website], bảo quản nguyên liệu [quản lý cache], đảm bảo an toàn vệ sinh [bảo mật], và tối ưu gian bếp [hiệu suất] cho phù hợp nhất.

Mục Đích Chính
* Thiết lập Website [Virtual Hosts]: Định nghĩa cách OLS phục vụ các tên miền [website] khác nhau, bao gồm thư mục gốc chứa website, cổng lắng nghe, và các cài đặt riêng cho từng trang.
* Tối ưu hiệu suất: Điều chỉnh các thông số liên quan đến xử lý kết nối, bộ nhớ đệm [LSCache - một điểm mạnh của LiteSpeed], xử lý PHP, nén GZIP để website chạy nhanh và hiệu quả hơn.
* Tăng cường bảo mật: Cấu hình các tính năng bảo mật như chứng chỉ SSL/TLS [cho HTTPS], kiểm soát truy cập, chống lại các kiểu tấn công web phổ biến.
* Tích hợp và Cấu hình PHP: Thiết lập cách OLS làm việc với PHP [thường qua LSAPI], chọn phiên bản PHP, cấu hình các tiến trình PHP.
* Quản lý Cache [LSCache]: Bật và tinh chỉnh LiteSpeed Cache, một cơ chế cache mạnh mẽ ở cấp độ máy chủ giúp tăng tốc đáng kể các ứng dụng web động [như WordPress].
* Quản lý Log: Cấu hình file log truy cập, log lỗi.
* Thiết lập Listeners: Định nghĩa các địa chỉ IP và cổng mà máy chủ sẽ lắng nghe yêu cầu [ví dụ: cổng 80 cho HTTP, cổng 443 cho HTTPS].

Sau khi cấu hình, máy chủ OpenLiteSpeed sẽ được tối ưu để phục vụ các website cụ thể một cách hiệu quả, an toàn, và với hiệu suất cao theo đúng yêu cầu của bạn.
```

---

## Cấu hình Vhost (`wptt-cau-hinh-vhost`)

- **Danh mục:** Cấu hình Webserver
- **Vị trí menu:** Menu chính › 13. Cấu hình Webserver › 2. Cấu hình Vhost  _(bấm lần lượt: 13 → 2)_
- **Tệp nguồn:** `/etc/wptt/cau-hinh/wptt-cau-hinh-vhost`

```text
Tính năng Sửa cấu hình OpenLiteSpeed vhost website là việc thiết lập hoặc điều chỉnh các cài đặt cho một Virtual Host [viết tắt là vhost] cụ thể trên máy chủ OpenLiteSpeed. Mỗi vhost đại diện cho một website [một tên miền hoặc tên miền phụ] riêng biệt mà bạn muốn máy chủ phục vụ.

Nói một cách đơn giản, nếu OpenLiteSpeed là một chung cư lớn, thì mỗi căn hộ [website] trong đó sẽ có một bảng nội quy [cấu hình vhost] riêng. Sửa cấu hình vhost chính là việc bạn tùy chỉnh bảng nội quy cho từng căn hộ đó.

Mục Đích Chính [Các Cài Đặt Quan Trọng Trong Vhost]
* Định nghĩa Thư mục gốc [Document Root]: Chỉ định thư mục trên máy chủ chứa toàn bộ mã nguồn và tệp tin của website đó.
* Liên kết Tên miền [Domain Name]: Gán một hoặc nhiều tên miền [ví dụ: yourdomain.com, www.yourdomain.com] với cấu hình vhost này.
* Cấu hình PHP [qua LSAPI]: Thiết lập cách PHP được xử lý cho website này, ví dụ: chọn phiên bản PHP, các biến môi trường, giới hạn tài nguyên PHP riêng.
* Thiết lập SSL/TLS [HTTPS]: Gán chứng chỉ SSL [certificate, private key, chain] để kích hoạt kết nối HTTPS an toàn cho tên miền.
* Quy tắc Viết lại URL [Rewrite Rules]: Tạo các quy tắc chuyển hướng URL, URL thân thiện SEO, bắt buộc HTTPS, v.v., áp dụng riêng cho website này [tương thích với mod_rewrite của Apache].
* Kiểm soát Truy cập: Thiết lập các quy tắc chặn/cho phép truy cập dựa trên địa chỉ IP.
* Cấu hình Log: Chỉ định vị trí lưu file log truy cập và log lỗi riêng cho website.
* Cài đặt LiteSpeed Cache [LSCache]: Bật và tùy chỉnh chính sách cache cho website này.

Mỗi website trên máy chủ OpenLiteSpeed sẽ có một bộ cấu hình riêng, cho phép nó hoạt động đúng với các tệp tin, chứng chỉ SSL, quy tắc viết lại URL và cài đặt PHP của riêng mình, tất cả đều được phục vụ bởi cùng một tiến trình OpenLiteSpeed.
```

---

## Cấu hình Maria Database (`wptt-sua-mariadb`)

- **Danh mục:** Cấu hình Webserver
- **Vị trí menu:** Menu chính › 13. Cấu hình Webserver › 3. Cấu hình Maria Database  _(bấm lần lượt: 13 → 3)_
- **Tệp nguồn:** `/etc/wptt/cau-hinh/wptt-sua-mariadb`

```text
Tính năng Cấu hình MariaDB là quá trình điều chỉnh các tham số và cài đặt hoạt động của máy chủ cơ sở dữ liệu MariaDB để tối ưu hóa hiệu suất, tăng cường bảo mật, quản lý tài nguyên và đảm bảo nó hoạt động ổn định theo nhu cầu cụ thể của bạn.

Nói một cách đơn giản, đây là việc bạn tinh chỉnh các nút vặn bên trong MariaDB để nó chạy nhanh nhất, an toàn nhất và phù hợp nhất với website hoặc ứng dụng mà nó phục vụ, cũng như với phần cứng của máy chủ.

Mục Đích Chính
* Tối ưu hiệu suất [Performance Tuning]: Điều chỉnh các cài đặt liên quan đến bộ nhớ đệm [ví dụ: innodb_buffer_pool_size], cách xử lý luồng, query cache,... để MariaDB xử lý truy vấn nhanh hơn.
* Tăng cường bảo mật [Security Hardening]: Cấu hình các tùy chọn bảo mật như giới hạn kết nối mạng, vô hiệu hóa đăng nhập từ xa của user root, kích hoạt SSL/TLS, quản lý quyền người dùng.
* Quản lý tài nguyên: Kiểm soát lượng RAM, dung lượng đĩa, CPU mà MariaDB sử dụng.
* Đảm bảo tính ổn định và tin cậy: Cấu hình cho việc phục hồi sau sự cố tốt hơn [đặc biệt với InnoDB/Aria].
* Thiết lập Logging: Bật và cấu hình các loại log [error log, slow query log, binary log] để theo dõi, gỡ lỗi và phục vụ cho việc sao chép [replication].
* Cấu hình Replication/Clustering: Thiết lập các thông số cho việc nhân bản dữ liệu giữa các server.
* Tùy chỉnh Storage Engine: Đặt storage engine mặc định hoặc tinh chỉnh các tham số riêng cho InnoDB, Aria, MyISAM.

Sau khi cấu hình, máy chủ MariaDB sẽ được điều chỉnh tốt hơn cho khối lượng công việc cụ thể, hoạt động an toàn hơn, ổn định hơn và đáp ứng đúng các yêu cầu của quản trị viên và ứng dụng. Việc cấu hình đòi hỏi hiểu biết về MariaDB và tác động của từng tham số.
```

---

## Cấu hình .htaccess (`wptt-cau-hinh-htaccess`)

- **Danh mục:** Cấu hình Webserver
- **Vị trí menu:** Menu chính › 13. Cấu hình Webserver › 4. Cấu hình .htaccess  _(bấm lần lượt: 13 → 4)_
- **Tệp nguồn:** `/etc/wptt/cau-hinh/wptt-cau-hinh-htaccess`

```text
Tính năng Cấu hình file .htaccess là việc tạo hoặc chỉnh sửa một tệp tin đặc biệt có tên là .htaccess để kiểm soát và tùy chỉnh cách máy chủ web Apache [hoặc các máy chủ tương thích như LiteSpeed] xử lý các yêu cầu truy cập đến một thư mục cụ thể và các thư mục con của nó trên website của bạn.

Nói một cách đơn giản, .htaccess giống như một bộ quy tắc riêng bạn đặt ra cho từng khu vực [thư mục] trên website của mình. Máy chủ Apache sẽ đọc những quy tắc này và hành xử theo đó khi có người truy cập vào khu vực đó.

Mục Đích Chính [Các ứng dụng phổ biến]
* Viết lại URL https://httpd.apache.org/docs/current/mod/mod_rewrite.html: Đây là một trong những công dụng mạnh mẽ nhất. Dùng để tạo URL thân thiện với SEO [ví dụ: example.com/san-pham/ao-thun thay vì example.com/product.php?id=123], chuyển hướng URL, bắt buộc sử dụng HTTPS, chuyển hướng từ www sang không www [hoặc ngược lại].
* Kiểm soát truy cập và Bảo mật:
* Chặn truy cập từ các địa chỉ IP cụ thể.
* Ngăn chặn việc liệt kê nội dung thư mục [directory listing].
* Chống Hotlink: Ngăn chặn các website khác nhúng trực tiếp hình ảnh hoặc tệp của bạn.

File .htaccess là một công cụ mạnh mẽ và linh hoạt.
```

---

## Cấu hình PHP.ini (`wptt-sua-phpini`)

- **Danh mục:** Cấu hình Webserver
- **Vị trí menu:** Menu chính › 13. Cấu hình Webserver › 5. Cấu hình PHP.ini  _(bấm lần lượt: 13 → 5)_
- **Vị trí menu:** Menu chính › 14. Quản lý PHP › 1. Cấu hình PHP.ini  _(bấm lần lượt: 14 → 1)_
- **Tệp nguồn:** `/etc/wptt/php/wptt-sua-phpini`

```text
Tính năng Sửa cấu hình php.ini là khả năng thay đổi các thiết lập hoạt động cốt lõi của PHP bằng cách chỉnh sửa trực tiếp tệp tin cấu hình chính của nó, có tên là php.ini. Tệp này chứa hàng loạt các chỉ thị [directives] điều khiển mọi khía cạnh của PHP, từ giới hạn tài nguyên, cách báo lỗi, đến việc kích hoạt các module mở rộng.

Nói một cách đơn giản, php.ini giống như bảng điều khiển trung tâm của PHP. Việc sửa nó cho phép bạn tùy chỉnh sâu cách PHP vận hành trên máy chủ của mình.

Mục Đích Chính
* Tùy chỉnh hành vi PHP: Điều chỉnh PHP để phù hợp với yêu cầu cụ thể của ứng dụng web hoặc môi trường máy chủ.
* Quản lý tài nguyên: Thiết lập các giới hạn như memory_limit [bộ nhớ tối đa], max_execution_time [thời gian thực thi tối đa], upload_max_filesize [kích thước tệp tải lên tối đa].
* Kích hoạt/Vô hiệu hóa Extensions: Quyết định những module mở rộng nào của PHP [ví dụ: mysqli, gd, curl] sẽ được tải và sử dụng.
* Cấu hình báo lỗi: Kiểm soát cách PHP báo cáo và hiển thị lỗi [ví dụ: error_reporting, display_errors].
* Tăng cường bảo mật: Một số cài đặt trong php.ini có thể giúp cải thiện tính bảo mật cho ứng dụng PHP.
* Tối ưu hiệu suất: Một vài chỉ thị có thể ảnh hưởng đến hiệu năng của PHP.

Việc sửa đổi php.ini đòi hỏi sự cẩn trọng, vì cấu hình sai có thể khiến PHP hoặc website của bạn ngừng hoạt động.
```

---

## Cấu hình Cron JOB (`wptt-cron`)

- **Danh mục:** Cấu hình Webserver
- **Vị trí menu:** Menu chính › 13. Cấu hình Webserver › 6. Cấu hình Cron JOB  _(bấm lần lượt: 13 → 6)_
- **Tệp nguồn:** `/etc/wptt/cau-hinh/wptt-cron`

```text
Tính năng Cấu hình cron [hay Lập lịch cron] là việc thiết lập và quản lý các tác vụ tự động [cron jobs] trên hệ điều hành Linux [và các hệ thống tương tự Unix]. Cron là một trình nền [daemon] chạy ngầm, cho phép bạn lên lịch để các lệnh hoặc kịch bản [script] được thực thi lặp đi lặp lại vào những thời điểm cụ thể [phút, giờ, ngày, tháng, thứ]. ⏰⚙️📜

Nói một cách đơn giản, cron giống như một người thư ký cần mẫn mà bạn có thể dặn dò để tự động làm một việc gì đó cho bạn theo lịch trình đã định, ví dụ: đúng 2 giờ sáng mỗi ngày, hãy chạy script sao lưu này.

Mục Đích Chính
* Tự động hóa các tác vụ lặp đi lặp lại: Đây là công dụng cốt lõi.
* Sao lưu [Backup]: Tự động sao lưu database, file website, hoặc toàn bộ hệ thống.
* Bảo trì hệ thống: Chạy các script dọn dẹp log cũ, file tạm, cập nhật hệ thống, kiểm tra sức khỏe server.
* Tạo báo cáo: Tự động tạo và gửi báo cáo định kỳ.
* Đồng bộ hóa dữ liệu: Tự động đồng bộ file giữa các server.
* Gửi email thông báo, nhắc nhở.
* Thực thi các tác vụ của ứng dụng: Nhiều ứng dụng web [như WordPress, Magento] cần cron để chạy các tác vụ nền [ví dụ: đăng bài theo lịch, cập nhật chỉ mục].

Sau khi cấu hình, cron sẽ tự động thực thi các lệnh hoặc script theo đúng lịch trình bạn đã đặt ra, giúp tự động hóa nhiều công việc quản trị và vận hành hệ thống.
```

---

## Cấu hình Redis/Valkey/KeyDB (`wptt-cau-hinh-redis`)

- **Danh mục:** Cấu hình Webserver
- **Vị trí menu:** Menu chính › 13. Cấu hình Webserver › 7. Cấu hình Redis/Valkey/KeyDB  _(bấm lần lượt: 13 → 7)_
- **Tệp nguồn:** `/etc/wptt/cau-hinh/wptt-cau-hinh-redis`

```text
Tính năng Cấu hình Object Cache [Redis/Valkey/KeyDB] là quá trình điều chỉnh các thiết lập và tham số hoạt động của máy chủ Cache để tối ưu hóa hiệu suất, quản lý bộ nhớ, đảm bảo độ bền dữ liệu [persistence], tăng cường bảo mật, và tùy chỉnh các khía cạnh khác cho phù hợp với nhu Hướng dẫn sử dụng [use case] cụ thể của bạn.

Nói một cách đơn giản, đây là việc bạn tinh chỉnh các nút vặn của bộ nhớ đệm để nó hoạt động hiệu quả nhất, an toàn nhất và đáp ứng đúng yêu cầu của ứng dụng đang sử dụng nó.

Mục Đích Chính
* Tối ưu hiệu suất: Điều chỉnh các cài đặt để phản hồi nhanh nhất có thể.
* Quản lý bộ nhớ [RAM]:
* maxmemory: Đặt giới hạn bộ nhớ tối đa được phép sử dụng.
* maxmemory-policy: Quy định cách xử lý khi đạt đến giới hạn bộ nhớ [ví dụ: xóa các key ít dùng nhất - allkeys-lru].
* Thiết lập Logging: Cấu hình ghi log để theo dõi và gỡ lỗi.

Ghi chú: Phải cài đặt dịch vụ Object Cache trước đó thì bạn mới có thể cấu hình được.
```

---

## Cấu hình Memcached (`wptt-cau-hinh-memcached`)

- **Danh mục:** Cấu hình Webserver
- **Vị trí menu:** Menu chính › 13. Cấu hình Webserver › 8. Cấu hình Memcached  _(bấm lần lượt: 13 → 8)_
- **Tệp nguồn:** `/etc/wptt/cau-hinh/wptt-cau-hinh-memcached`

```text
Tính năng Cấu hình Memcached là quá trình điều chỉnh các thiết lập và tham số hoạt động của máy chủ Memcached để tối ưu hóa hiệu suất, quản lý chặt chẽ bộ nhớ RAM, thiết lập kết nối mạng, và tùy chỉnh các khía cạnh khác cho phù hợp với nhu cầu sử dụng [use case] cụ thể của hệ thống.

Nói một cách đơn giản, đây là việc bạn tinh chỉnh các nút vặn của Memcached – một hệ thống bộ nhớ đệm [cache] phân tán siêu tốc – để nó hoạt động mượt mà nhất, sử dụng RAM hợp lý nhất và phục vụ tốt nhất cho các ứng dụng web [ví dụ: lưu kết quả truy vấn database, object cache cho WordPress].

Mục Đích Chính
* Quản lý bộ nhớ [RAM] và Kích thước Cache:
* -m [Cachesize]: Đặt giới hạn bộ nhớ RAM tối đa [tính bằng MB] mà Memcached được phép sử dụng. Khi bộ nhớ đầy, nó sẽ tự động xóa các dữ liệu cũ nhất theo cơ chế LRU [Least Recently Used].
* -I [Item size]: Điều chỉnh kích thước tối đa của một đối tượng lưu trữ [mặc định là 1MB, có thể tăng lên nếu website có các cục dữ liệu lớn].
* Cấu hình Mạng và Kết nối:
* -s [Unix Socket] hoặc -p [Port]: Ưu tiên sử dụng Unix Socket [/var/run/memcached/memcached.sock] để tăng tốc độ kết nối nội bộ, hoặc mở cổng mạng [mặc định 11211].
* -c [Max connections]: Đặt giới hạn số lượng kết nối đồng thời tối đa từ các client/ứng dụng đến máy chủ Cache.
* Tối ưu Hiệu suất đa luồng [Multi-threading]:
* -t [Threads]: Chỉ định số lượng luồng xử lý yêu cầu, giúp Memcached tận dụng tối đa sức mạnh của CPU đa nhân [multi-core].
* Tăng cường bảo mật và Quyền hạn:
* -u [User]: Chỉ định tài khoản hệ thống chạy tiến trình Memcached [ví dụ: user memcached] để giới hạn quyền hạn, thay vì chạy bằng quyền root.
* -l [Listen]: Giới hạn địa chỉ IP mà Memcached lắng nghe [thường là 127.0.0.1] để ngăn chặn truy cập trái phép từ internet.
* Thiết lập Logging: Định hướng các bản ghi hoạt động và cảnh báo lỗi vào file log [logfile] để dễ dàng theo dõi và gỡ lỗi.

Sau khi cấu hình, máy chủ Memcached sẽ hoạt động với hiệu suất cao nhất, sử dụng tài nguyên RAM một cách có kiểm soát và cung cấp tốc độ phản hồi siêu tốc cho hệ thống website của bạn.

Ghi chú: Phải cài đặt dịch vụ Memcached trước đó thì bạn mới có thể tiến hành cấu hình.
```

---

## Cấu hình Fail2ban (`wptt-cau-hinh-fail2ban`)

- **Danh mục:** Cấu hình Webserver
- **Vị trí menu:** Menu chính › 13. Cấu hình Webserver › 9. Cấu hình Fail2ban  _(bấm lần lượt: 13 → 9)_
- **Tệp nguồn:** `/etc/wptt/cau-hinh/wptt-cau-hinh-fail2ban`

```text
Tính năng Cấu hình Fail2ban là việc bạn tùy chỉnh cách Fail2ban hoạt động để bảo vệ máy chủ của mình, chủ yếu bằng cách dạy nó theo dõi nhật ký [log] của các dịch vụ [như SSH, web server], phát hiện các hành vi đáng ngờ [như đăng nhập sai nhiều lần] và thực hiện hành động [như chặn IP] dựa trên các quy tắc bạn đặt ra.

Sau khi cấu hình, Fail2ban sẽ tự động theo dõi và chặn các địa chỉ IP có hành vi tấn công theo đúng những gì bạn đã thiết lập, giúp tăng cường an ninh cho máy chủ.
```

---

## Cấu hình Hostname (`wptt-hostname`)

- **Danh mục:** Cấu hình Webserver
- **Vị trí menu:** Menu chính › 13. Cấu hình Webserver › 10. Cấu hình Hostname  _(bấm lần lượt: 13 → 10)_
- **Tệp nguồn:** `/etc/wptt/cau-hinh/wptt-hostname`

```text
Tính năng Thay đổi hostname Linux là quá trình cập nhật hoặc đặt lại tên định danh [hostname] cho một máy tính hoặc máy chủ đang chạy hệ điều hành Linux. Hostname là một nhãn mà con người có thể đọc được, được gán cho một thiết bị trong mạng để dễ dàng nhận biết nó.

Nói một cách đơn giản, đây là việc bạn đặt lại tên cho máy Linux của mình, ví dụ từ một tên chung chung như localhost hoặc ubuntu thành một tên cụ thể hơn như webserver01, maytinh-vanphong-cong-ty-a, hay linux-dev-wptangtoc ...

Mục Đích Chính
* Định danh máy chủ/máy tính: Giúp dễ dàng nhận biết vai trò hoặc vị trí của máy trong một mạng lưới, đặc biệt khi quản lý nhiều máy.
* Tạo sự rõ ràng trong mạng: Giúp việc quản lý mạng và các dịch vụ mạng trở nên thuận tiện hơn.
* Yêu cầu của ứng dụng: Một số phần mềm hoặc dịch vụ mạng có thể dựa vào hostname để hoạt động hoặc ghi log.
* Chuẩn hóa theo quy ước: Tuân thủ các quy tắc đặt tên trong một tổ chức.
* Sau khi nhân bản [clone] máy ảo/server: Cần đổi hostname để đảm bảo mỗi máy có một tên duy nhất.
* Sửa tên mặc định/không mong muốn: Thay đổi tên được đặt tự động trong quá trình cài đặt OS.

Thay đổi hostname giúp hệ thống Linux của bạn được định danh rõ ràng hơn cả ở local lẫn trong mạng.
```

---

## Thay đổi công cụ cấu hình (`wptt-editor-cau-hinh`)

- **Danh mục:** Cấu hình Webserver
- **Vị trí menu:** Menu chính › 13. Cấu hình Webserver › 11. Thay đổi công cụ cấu hình  _(bấm lần lượt: 13 → 11)_
- **Tệp nguồn:** `/etc/wptt/cau-hinh/wptt-editor-cau-hinh`

```text
Tính năng Thay đổi công cụ cấu hình editor: vim, nano, vi là khả năng cho phép bạn chọn và đặt trình soạn thảo văn bản [text editor] mặc định sẽ được sử dụng khi bạn cần chỉnh sửa các tệp tin cấu hình hoặc văn bản từ dòng lệnh [command line] trên hệ thống Linux hoặc Unix.

Nói một cách đơn giản, đây là cách bạn chỉ định cho hệ thống biết rằng: Khi tôi cần sửa file bằng dòng lệnh [ví dụ: khi chạy crontab -e], hãy mở file đó bằng nano [hoặc vim, vi] thay vì một trình soạn thảo mặc định khác mà tôi không quen.

Mục Đích Chính
* Sở thích và sự quen thuộc của người dùng: Mỗi người có thể quen và làm việc hiệu quả hơn với một trình soạn thảo nhất định.
* Tăng hiệu quả công việc: Sử dụng trình soạn thảo bạn thành thạo giúp việc chỉnh sửa file nhanh chóng và ít lỗi hơn.
* Đảm bảo tính nhất quán: Có một trình soạn thảo mặc định quen thuộc cho mọi tác vụ chỉnh sửa từ dòng lệnh.

Sau khi thiết lập hệ thống sẽ tự động sử dụng trình soạn thảo mà bạn đã chọn làm mặc định, giúp bạn làm việc thoải mái và hiệu quả hơn.
Mặc định nếu chưa thiết lập sẽ sử dụng: nano
```

---

## Cấu hình Webserver (`wptt-cau-hinh-websever-main`)

- **Danh mục:** Cấu hình Webserver
- **Vị trí menu:** Menu chính › 13. Cấu hình Webserver  _(bấm lần lượt: 13)_
- **Tệp nguồn:** `/etc/wptt/wptt-cau-hinh-websever-main`

```text
Tính năng Cấu hình Webserver trong WPTangToc OLS là một bộ công cụ và tùy chọn giúp bạn điều chỉnh các thiết lập cốt lõi của máy chủ web một cách thuận tiện ngay từ giao diện dòng lệnh của script. ⚙️🌐

Giới thiệu ngắn gọn:
Mục đích: Đơn giản hóa việc tùy chỉnh các khía cạnh quan trọng của OpenLiteSpeed, cho phép người dùng tinh chỉnh hiệu suất, bảo mật, và hành vi của máy chủ web mà không cần phải can thiệp sâu vào các file cấu hình phức tạp hoặc hoàn toàn dựa vào WebAdmin GUI của OLS.
Cách hoạt động [thường thấy có thể bao gồm]:
* Quản lý Virtual Host [vHost]: Hỗ trợ tạo, sửa, xóa cấu hình cho từng website [domain], bao gồm thiết lập thư mục gốc, liên kết tên miền [đã được đề cập trong quản lý domain].
* Cấu hình Listener: Điều chỉnh cơ bản các cổng lắng nghe [ví dụ: port 80, 443] và cách OLS xử lý kết nối đến.
* Tối ưu hóa cơ bản: Cung cấp tùy chọn để áp dụng các thiết lập tối ưu hóa hiệu suất phổ biến cho OLS.
* Rewrite Rules: Có thể cung cấp giao diện để quản lý hoặc thêm các quy tắc viết lại URL [rewrite rules] cho từng vHost hoặc toàn cục.
* Cấu hình PHP Handler: Liên kết các phiên bản PHP với các website cụ thể [đã đề cập trong quản lý PHP].
* Thiết lập bảo mật cơ bản: Áp dụng một số tiêu đề bảo mật [security headers] hoặc các cấu hình bảo mật ở cấp độ máy chủ.
* Truy cập file cấu hình OLS: Có thể cung cấp lối tắt để chỉnh sửa trực tiếp các file cấu hình quan trọng của OLS [với cảnh báo].
Lợi ích:
* Kiểm soát linh hoạt: Cho phép tùy chỉnh máy chủ web theo nhu cầu cụ thể.
* Đơn giản hóa: Giảm độ phức tạp so với việc chỉnh sửa thủ công file cấu hình gốc của OpenLiteSpeed.
* Tiện lợi: Thực hiện các thay đổi nhanh chóng ngay từ WPTangToc OLS.
* Tối ưu hóa: Giúp người dùng áp dụng các cấu hình tốt nhất cho hiệu suất và bảo mật.
Tính năng này là trung tâm của việc quản trị máy chủ web, giúp bạn định hình cách OpenLiteSpeed hoạt động và phục vụ các website của mình một cách hiệu quả.
```

---

## Quản lý PHP (`wptt-php-ini-main`)

- **Danh mục:** Quản lý PHP
- **Vị trí menu:** Menu chính › 14. Quản lý PHP  _(bấm lần lượt: 14)_
- **Tệp nguồn:** `/etc/wptt/wptt-php-ini-main`

```text
Tính năng quản lý PHP của WPTangToc OLS là một công cụ tích hợp giúp người dùng dễ dàng cài đặt, chuyển đổi và cấu hình các phiên bản PHP khác nhau cho website chạy trên máy chủ OpenLiteSpeed.

Giới thiệu ngắn gọn:
Mục đích: Cho phép người dùng linh hoạt lựa chọn và quản lý phiên bản PHP phù hợp với yêu cầu của từng website, tối ưu hóa hiệu suất và đảm bảo tính tương thích.

Cách hoạt động:
* Cài đặt nhiều phiên bản PHP: Dễ dàng cài đặt song song các phiên bản PHP phổ biến [ví dụ: PHP 7.4, 8.0, 8.1, 8.2, 8.3, 8.4, 8.5].
* Chuyển đổi phiên bản PHP cho từng website: Gán một phiên bản PHP cụ thể cho mỗi website riêng biệt trên cùng một máy chủ.
* Gỡ cài đặt phiên bản PHP: Loại bỏ các phiên bản PHP không còn sử dụng.
* Quản lý tiện ích mở rộng PHP [extensions]: Có thể bao gồm khả năng cài đặt hoặc tùy chỉnh các extensions cần thiết.
* Điều chỉnh cấu hình PHP [php.ini]: Cho phép tùy chỉnh một số thông số cơ bản trong file php.ini.
* cấu hình các giá trị php.ini
* v.v.v

Lợi ích:
* Linh hoạt: Chạy các website với yêu cầu PHP khác nhau trên cùng server.
* Tương thích: Đảm bảo website hoạt động tốt với phiên bản PHP được hỗ trợ.
* Tối ưu hiệu suất: Sử dụng phiên bản PHP mới nhất để có hiệu năng tốt hơn.
* Dễ sử dụng: Đơn giản hóa quá trình quản lý PHP phức tạp thông qua giao diện hoặc lệnh trực quan.
Tính năng này giúp người dùng WPTangToc OLS kiểm soát tốt hơn môi trường PHP cho các dự án web của mình mà không cần can thiệp sâu vào cấu hình máy chủ một cách thủ công.
```

---

## Cấu hình Upload Max Filesize (`wptt-php-ini-uploads`)

- **Danh mục:** Quản lý PHP
- **Vị trí menu:** Menu chính › 14. Quản lý PHP › 2. Cấu hình Upload Max Filesize  _(bấm lần lượt: 14 → 2)_
- **Tệp nguồn:** `/etc/wptt/php/wptt-php-ini-uploads`

```text
Tính năng Cấu hình upload_max_filesize PHP là việc điều chỉnh các cài đặt trong PHP để kiểm soát dung lượng tối đa của một tệp tin mà người dùng có thể tải lên máy chủ thông qua các ứng dụng web viết bằng PHP.

Nói một cách đơn giản, đây là cách bạn quy định một file tải lên website không được nặng quá X Megabytes.

Mục đích chính:

* Cho phép tải lên tệp lớn hơn: Mặc định, PHP wptangtoc ols thường giới hạn dung lượng file tải lên ở mức khá nhỏ [là 8MB]. Cấu hình này cho phép bạn tăng giới hạn đó để người dùng có thể tải lên video, hình ảnh chất lượng cao, tài liệu lớn, v.v.
* Ngăn chặn lạm dụng tài nguyên: Giúp bảo vệ máy chủ khỏi việc bị quá tải hoặc hết dung lượng đĩa do người dùng tải lên các tệp quá lớn.
* Đáp ứng yêu cầu ứng dụng: Các ứng dụng web khác nhau có nhu cầu khác nhau về kích thước tệp tải lên.
```

---

## Cấu hình memory_limit (`wptt-php-memory-limit-ram-php`)

- **Danh mục:** Quản lý PHP
- **Vị trí menu:** Menu chính › 14. Quản lý PHP › 3. Cấu hình memory_limit  _(bấm lần lượt: 14 → 3)_
- **Tệp nguồn:** `/etc/wptt/php/wptt-php-memory-limit-ram-php`

```text
Tính năng Cấu hình memory_limit PHP là việc điều chỉnh một cài đặt quan trọng trong PHP để quy định dung lượng bộ nhớ [RAM] tối đa mà một đoạn mã [script] PHP đơn lẻ được phép sử dụng trong quá trình thực thi.

Nói một cách đơn giản, đây là cách bạn đặt ra giới hạn một tác vụ PHP không được phép ngốn quá X Megabytes bộ nhớ.

Mục Đích Chính
* Ngăn chặn lỗi hết bộ nhớ: Giúp các script PHP không sử dụng quá nhiều bộ nhớ, tránh làm cạn kiệt tài nguyên của máy chủ, có thể dẫn đến việc script bị dừng đột ngột hoặc ảnh hưởng đến hoạt động của toàn bộ server.
* Quản lý tài nguyên máy chủ: Đảm bảo mỗi script chỉ sử dụng một phần bộ nhớ hợp lý, giúp máy chủ hoạt động ổn định.
* Cho phép các tác vụ nặng chạy: Đối với các tác vụ cần nhiều bộ nhớ để xử lý [ví dụ: xử lý hình ảnh lớn, làm việc với tập dữ liệu khổng lồ, các thư viện phức tạp], bạn có thể cần tăng memory_limit lên để chúng hoàn thành mà không gặp lỗi.
* Đáp ứng yêu cầu ứng dụng: Nhiều ứng dụng web [như WordPress, Magento] có yêu cầu memory_limit tối thiểu để hoạt động trơn tru.
Nếu một script cố gắng sử dụng nhiều bộ nhớ hơn mức cho phép, nó sẽ gây ra lỗi nghiêm trọng [fatal error] và bị dừng lại.
```

---

## Cấu hình max execution time (`wptt-php-max-execution-time`)

- **Danh mục:** Quản lý PHP
- **Vị trí menu:** Menu chính › 14. Quản lý PHP › 4. Cấu hình max execution time  _(bấm lần lượt: 14 → 4)_
- **Tệp nguồn:** `/etc/wptt/php/wptt-php-max-execution-time`

```text
Tính năng Cấu hình max_execution_time PHP là việc điều chỉnh một cài đặt quan trọng trong PHP để quy định thời gian tối đa [tính bằng giây] mà một đoạn mã [script] PHP được phép chạy trước khi bị máy chủ tự động dừng lại.

Nói một cách đơn giản, đây là cách bạn đặt ra giới hạn một tác vụ PHP không được chạy quá X giây.

Mục đích chính:

* Ngăn chặn script chạy vô hạn: Giúp dừng các script bị lỗi [ví dụ: vòng lặp vô tận] hoặc các tác vụ tốn quá nhiều thời gian, tránh làm treo máy chủ hoặc tiêu tốn tài nguyên quá mức.
* Quản lý tài nguyên máy chủ: Đảm bảo không có script nào chiếm dụng CPU quá lâu, ảnh hưởng đến các tác vụ khác.
* Cho phép các tác vụ dài hơi hợp lệ: Đối với các tác vụ cần nhiều thời gian để hoàn thành [như xử lý file lớn, gửi email hàng loạt, đồng bộ dữ liệu], bạn có thể tăng giá trị này lên để script không bị dừng giữa chừng.

Mặc định là 120 giây.
```

---

## Cấu hình max_input_time (`wptt-php-max-input-time`)

- **Danh mục:** Quản lý PHP
- **Vị trí menu:** Menu chính › 14. Quản lý PHP › 5. Cấu hình max_input_time  _(bấm lần lượt: 14 → 5)_
- **Tệp nguồn:** `/etc/wptt/php/wptt-php-max-input-time`

```text
Tính năng Cấu hình max_input_time PHP là việc điều chỉnh một cài đặt trong PHP để quy định thời gian tối đa [tính bằng giây] mà một đoạn mã [script] PHP được phép sử dụng để phân tích dữ liệu đầu vào nhận được từ yêu cầu của người dùng. Dữ liệu này bao gồm các biến GET, POST và đặc biệt quan trọng là dữ liệu từ việc tải tệp [file uploads].

Nói một cách đơn giản, đây là cách bạn đặt ra giới hạn một script PHP không được tốn quá X giây để nhận và xử lý xong toàn bộ dữ liệu được gửi lên, ví dụ như một file lớn.

Mục đích chính:
* Ngăn chặn tấn công từ chối dịch vụ [DoS]: Giúp bảo vệ máy chủ khỏi các kịch bản mà client [người dùng hoặc bot] gửi dữ liệu lên rất chậm hoặc gửi dữ liệu lớn/lỗi khiến script bị kẹt ở giai đoạn xử lý đầu vào, làm cạn kiệt tài nguyên.
* Cho phép tải lên tệp lớn/dữ liệu POST lớn: Nếu website của bạn cần xử lý việc tải lên các tệp tin có dung lượng lớn hoặc nhận lượng dữ liệu POST lớn, giá trị mặc định [thường là 60 giây] có thể không đủ. Tăng max_input_time cho phép các thao tác này có đủ thời gian hoàn tất.
* Đảm bảo ổn định cho máy chủ: Đặt giới hạn thời gian xử lý đầu vào giúp máy chủ hoạt động ổn định hơn.
```

---

## Cấu hình max_input_vars (`wptt-php-max-input-vars`)

- **Danh mục:** Quản lý PHP
- **Vị trí menu:** Menu chính › 14. Quản lý PHP › 6. Cấu hình max_input_vars  _(bấm lần lượt: 14 → 6)_
- **Tệp nguồn:** `/etc/wptt/php/wptt-php-max-input-vars`

```text
Tính năng Cấu hình max_input_vars PHP là việc điều chỉnh một cài đặt trong PHP để giới hạn số lượng biến [variables] tối đa mà PHP sẽ chấp nhận từ dữ liệu đầu vào của một yêu cầu web [bao gồm dữ liệu từ "$_GET", "$_POST" và "$_COOKIE"].

Nói một cách đơn giản, đây là cách bạn đặt ra giới hạn một yêu cầu gửi lên website không được chứa quá X trường dữ liệu [ví dụ: các ô trong một form].

Mục đích chính:

* Bảo vệ chống tấn công Hash Collision [Denial of Service]: Đây là mục đích chính. Kẻ tấn công có thể gửi một số lượng lớn biến đầu vào để cố tình gây ra xung đột trong bảng băm [hash table] của PHP, làm tiêu tốn CPU và có thể dẫn đến từ chối dịch vụ. max_input_vars giúp giảm thiểu nguy cơ này.
* Cho phép các form phức tạp hoạt động: Một số ứng dụng web có các biểu mẫu [form] rất lớn hoặc gửi đi nhiều dữ liệu [ví dụ: trong các trang quản trị, các thao tác xử lý hàng loạt] có thể vượt qua giới hạn mặc định [thường là 1000]. Tăng giá trị này giúp các ứng dụng đó hoạt động bình thường.
* Đảm bảo ổn định cho máy chủ: Ngăn chặn việc xử lý quá nhiều biến đầu vào cùng lúc, có thể gây quá tải cho máy chủ.
```

---

## Thay đổi version PHP domain (`wptt-domain-php`)

- **Danh mục:** Quản lý PHP
- **Vị trí menu:** Menu chính › 14. Quản lý PHP › 7. Thay đổi version PHP domain  _(bấm lần lượt: 14 → 7)_
- **Tệp nguồn:** `/etc/wptt/php/wptt-domain-php`

```text
Tính năng Thay đổi phiên bản PHP riêng cho domain là khả năng cho phép bạn chọn và áp dụng một phiên bản PHP cụ thể [ví dụ: PHP 8.1, PHP 8.2, PHP 8.3, PHP 8.4, PHP 8.5] để chạy cho một website [tên miền hoặc tên miền phụ] nhất định trên cùng một máy chủ, độc lập với phiên bản PHP mà các website khác hoặc máy chủ đang sử dụng làm mặc định.

Nói đơn giản, nếu bạn có nhiều website trên cùng một hệ thống, bạn có thể cài đặt website A chạy PHP 8.3 trong khi website B vẫn chạy PHP 7.4, mà không ảnh hưởng lẫn nhau.

Mục đích chính:
* Đảm bảo tương thích ứng dụng: Các website, theme, plugin khác nhau có thể yêu cầu các phiên bản PHP khác nhau để hoạt động tối ưu hoặc tránh lỗi.
* Thử nghiệm và nâng cấp an toàn: Cho phép bạn kiểm tra website với một phiên bản PHP mới hơn trước khi áp dụng rộng rãi, giảm thiểu rủi ro.
* Bảo mật và hiệu suất: Giúp bạn sử dụng phiên bản PHP mới nhất, được hỗ trợ và bảo mật tốt hơn cho các website tương thích, trong khi vẫn duy trì hoạt động cho các website cũ hơn chưa thể nâng cấp ngay.
* Tận dụng tính năng mới: Các phiên bản PHP mới thường đi kèm với các tính năng ngôn ngữ mới và cải tiến hiệu suất.

Bài viết kiểm tra hiệu suất PHP: https://wptangtoc.com/php-kiem-tra-toc-do-cac-phien-ban/
```

---

## Thay đổi version PHP All (`wptt-php-version-all-server`)

- **Danh mục:** Quản lý PHP
- **Vị trí menu:** Menu chính › 14. Quản lý PHP › 8. Thay đổi version PHP All  _(bấm lần lượt: 14 → 8)_
- **Tệp nguồn:** `/etc/wptt/php/wptt-php-version-all-server`

```text
Thay đổi phiên bản PHP toàn bộ website server hệ thống là quá trình nâng cấp hoặc hạ cấp phiên bản PHP mặc định mà máy chủ web sử dụng để xử lý mã PHP cho tất cả các trang web được lưu trữ trên máy chủ đó, trừ khi có cấu hình riêng biệt cho từng tên miền cụ thể.

Nói một cách đơn giản, đây là việc đặt một phiên bản PHP [ví dụ: PHP 8.3] làm tiêu chuẩn cho toàn bộ máy chủ. Bất kỳ website nào không có cài đặt PHP riêng sẽ tự động chạy bằng phiên bản tiêu chuẩn này.

Mục đích chính:
* Nâng cao bảo mật và hiệu suất: Cập nhật lên các phiên bản PHP mới hơn, còn được hỗ trợ, để vá lỗi bảo mật và tận dụng các cải tiến về tốc độ cho tất cả các website.
* Chuẩn hóa môi trường: Đảm bảo một môi trường phát triển và vận hành đồng nhất trên toàn máy chủ.
* Loại bỏ phiên bản cũ lỗi thời: Khi một phiên bản PHP cũ đã hết hạn hỗ trợ [End-of-Life], việc nâng cấp toàn hệ thống là cần thiết.
* Cung cấp tính năng mới: Giúp các nhà phát triển có thể sử dụng các tính năng ngôn ngữ mới nhất của PHP làm mặc định.

Khác với việc thay đổi PHP cho từng domain riêng lẻ, thay đổi toàn bộ hệ thống ảnh hưởng đến mặc định chung của cả server.
```

---

## Kiểm tra phiên bản PHP (`wptt-php-version-domain`)

- **Danh mục:** Quản lý PHP
- **Vị trí menu:** Menu chính › 14. Quản lý PHP › 9. Kiểm tra phiên bản PHP  _(bấm lần lượt: 14 → 9)_
- **Tệp nguồn:** `/etc/wptt/php/wptt-php-version-domain`

```text
Tính năng Kiểm tra phiên bản PHP của từng website là khả năng xác định xem một website cụ thể [tên miền hoặc tên miền phụ] trên máy chủ đang thực sự chạy bằng phiên bản PHP nào. Điều này đặc biệt hữu ích trong các môi trường như WPTangToc OLS cho phép mỗi website sử dụng một phiên bản PHP riêng biệt.

Nói một cách đơn giản, đây là cách để bạn biết website A đang dùng PHP phiên bản X, trong khi website B đang dùng PHP phiên bản Y.

Mục Đích Chính
* Gỡ lỗi tương thích: Khi website, theme, hoặc plugin gặp lỗi, việc biết phiên bản PHP đang chạy là một trong những bước chẩn đoán đầu tiên, vì vấn đề không tương thích phiên bản rất phổ biến.
* Xác nhận cấu hình: Đảm bảo website đang sử dụng đúng phiên bản PHP đã được cài đặt.
* Kiểm tra bảo mật: Đảm bảo website đang chạy trên các phiên bản PHP còn được hỗ trợ và cập nhật bảo mật.
* Lên kế hoạch nâng cấp: Biết phiên bản hiện tại giúp bạn lập kế hoạch nâng cấp website lên phiên bản PHP mới hơn một cách phù hợp.
* Đáp ứng yêu cầu ứng dụng: Kiểm tra xem website có đáp ứng yêu cầu về phiên bản PHP của các phần mềm [CMS, framework] mà nó đang sử dụng hay không.

Việc biết được phiên bản PHP của từng website giúp bạn quản lý, bảo trì và phát triển các dự án web của mình một cách hiệu quả và an toàn hơn.
```

---

## Cài thêm PHP extension (`php-extension-them`)

- **Danh mục:** Quản lý PHP
- **Vị trí menu:** Menu chính › 14. Quản lý PHP › 10. Cài thêm PHP extension  _(bấm lần lượt: 14 → 10)_
- **Tệp nguồn:** `/etc/wptt/php/php-extension-them`

```text
Tính năng Cài đặt extension PHP là khả năng thêm các thư viện mở rộng [module hoặc plugin] vào môi trường PHP để bổ sung các chức năng cụ thể mà PHP cốt lõi không có sẵn.

Nói một cách đơn giản, PHP có một bộ chức năng cơ bản. Khi bạn cần PHP làm những việc chuyên biệt hơn như kết nối với một loại cơ sở dữ liệu đặc thù [ví dụ: mysqli, pgsql], xử lý hình ảnh [gd, imagick], làm việc với XML, mã hóa dữ liệu, hay tăng tốc thực thi mã [opcache], bạn cần cài đặt thêm các extension tương ứng.

Mục đích chính:
* Mở rộng khả năng của PHP: Giúp PHP thực hiện được nhiều tác vụ đa dạng hơn.
* Tương thích với ứng dụng: Nhiều ứng dụng web và framework [như WordPress, Laravel], một số plugin WordPress, theme WordPress... yêu cầu phải có một số extension PHP nhất định để hoạt động đúng.
```

---

## Xóa PHP extension (`php-extension-xoa`)

- **Danh mục:** Quản lý PHP
- **Vị trí menu:** Menu chính › 14. Quản lý PHP › 11. Xóa PHP extension  _(bấm lần lượt: 14 → 11)_
- **Tệp nguồn:** `/etc/wptt/php/php-extension-xoa`

```text
Tính năng Xóa extension PHP là quá trình gỡ bỏ hoặc vô hiệu hóa các thư viện mở rộng [module] đã được cài đặt trước đó ra khỏi môi trường PHP của bạn. Khi một extension bị xóa, các chức năng mà nó cung cấp sẽ không còn sẵn có để sử dụng trong các đoạn mã PHP nữa.

Mục đích chính của việc này:

* Tối ưu tài nguyên: Loại bỏ các extension không sử dụng để giải phóng một phần nhỏ tài nguyên máy chủ [bộ nhớ RAM].
* Tăng cường bảo mật: Giảm thiểu bề mặt tấn công bằng cách gỡ bỏ những thành phần không cần thiết, vì mỗi extension đều có thể tiềm ẩn lỗ hổng.
* Giải quyết xung đột: Gỡ bỏ extension có thể giúp khắc phục sự không tương thích giữa các extension với nhau hoặc với phiên bản PHP/ứng dụng.
* Dọn dẹp môi trường: Giữ cho môi trường PHP gọn gàng, chỉ chứa những gì thực sự cần thiết.
* Khi không còn nhu cầu: Nếu một ứng dụng web không còn cần đến một extension cụ thể nữa.

Sau khi xóa hoặc vô hiệu hóa và khởi động lại web server, PHP sẽ không còn tải extension đó nữa, và mọi cố gắng gọi hàm từ extension đó sẽ gây ra lỗi.
```

---

## Reset mặc định PHP.ini (`wptt-khoi-phuc-sua-phpini`)

- **Danh mục:** Quản lý PHP
- **Vị trí menu:** Menu chính › 14. Quản lý PHP › 12. Reset mặc định PHP.ini  _(bấm lần lượt: 14 → 12)_
- **Tệp nguồn:** `/etc/wptt/php/wptt-khoi-phuc-sua-phpini`

```text
Tính năng khôi phục php.ini về trạng thái tối ưu mặc định của WPTangToc OLS.
Trong quá trình vận hành, có thể bạn đã tùy biến file php.ini và vô tình gây ra lỗi [như trắng trang, lỗi 500, quá tải RAM].
Bạn có thể sử dụng tính năng này để reset lại cấu hình, đồng thời hệ thống sẽ tự động Auto-Tune lại OPcache và JIT theo đúng phần cứng hiện tại của VPS.
```

---

## Quản lý Logs (`wptt-logs-main`)

- **Danh mục:** Quản lý Logs
- **Vị trí menu:** Menu chính › 15. Quản lý Logs  _(bấm lần lượt: 15)_
- **Tệp nguồn:** `/etc/wptt/wptt-logs-main`

```text
Tính năng Quản lý Logs trong WPTangToc OLS là một công cụ tích hợp giúp người dùng dễ dàng truy cập, xem và theo dõi các tệp nhật ký [logs] quan trọng của máy chủ OpenLiteSpeed và các website đang hoạt động.

Giới thiệu ngắn gọn:

Mục đích: Hỗ trợ việc theo dõi hoạt động của máy chủ, chẩn đoán lỗi, phân tích lưu lượng truy cập và các vấn đề bảo mật một cách thuận tiện.
Cách hoạt động [thường thấy]:
* Xem logs trực tiếp: Truy cập nhanh các tệp log phổ biến như:
* Log lỗi của OpenLiteSpeed [error.log, stderr.log].
* Log truy cập của website [access.log].
* Log hoạt động của chính script WPTangToc OLS.
* Theo dõi logs theo thời gian thực [tail logs]: Xem các dòng log mới được ghi vào tệp ngay lập tức, hữu ích cho việc gỡ lỗi trực tiếp.
* Tìm kiếm trong logs [có thể]: Một số tiện ích nâng cao có thể cho phép tìm kiếm từ khóa trong tệp log.
* v.v.v

Lợi ích:
* Gỡ lỗi hiệu quả: Nhanh chóng xác định nguyên nhân gây ra sự cố website hoặc máy chủ.
* Theo dõi hoạt động: Hiểu rõ hơn về những gì đang diễn ra trên máy chủ.
* Phân tích bảo mật: Phát hiện các hoạt động đáng ngờ hoặc các cuộc tấn công.
* Tiện lợi: Truy cập logs dễ dàng mà không cần phải điều hướng phức tạp trong cấu trúc thư mục của máy chủ qua SSH.

Tính năng này giúp quản trị viên và người dùng WPTangToc OLS có cái nhìn sâu sắc hơn về hoạt động của hệ thống, từ đó đưa ra các quyết định và hành động khắc phục sự cố kịp thời.
```

---

## Bật/Tắt access && error log domain (`wptt-bat-tat-log-domain`)

- **Danh mục:** Quản lý Logs
- **Vị trí menu:** Menu chính › 15. Quản lý Logs › 1. Bật/Tắt access && error log domain  _(bấm lần lượt: 15 → 1)_
- **Tệp nguồn:** `/etc/wptt/logs/wptt-bat-tat-log-domain`

```text
Tính năng Bật / Tắt ghi access.log và error.log cho phép bạn kiểm soát việc ghi lại nhật ký truy cập và lỗi cho một website cụ thể trên OpenLiteSpeed.

1. Kích hoạt [Bật]:
* access.log: Ghi lại mọi yêu cầu truy cập [IP, thời gian, URL, trình duyệt...]. Rất tốt để phân tích lưu lượng.
* error.log: Ghi lại các lỗi máy chủ, cấu hình, PHP... Là công cụ bắt buộc phải có khi web bị lỗi 500, trắng trang.

2. Hủy kích hoạt [Tắt]:
* Giúp tiết kiệm dung lượng ổ cứng [đặc biệt với web traffic khủng].
* Giảm tải thao tác ghi đĩa [I/O] và tiết kiệm một chút CPU.
* KHÔNG KHUYẾN KHÍCH tắt error.log trừ khi bạn thực sự không bao giờ xem log và muốn tối ưu 100% tài nguyên phần cứng.

Bạn có thể dễ dàng Bật/Tắt bằng 1 cú chạm. Hệ thống sẽ tự động nhận diện trạng thái hiện tại để thao tác đảo ngược [Toggle].
```

---

## Xem access log domain (`wptt-xem-access-log-domain`)

- **Danh mục:** Quản lý Logs
- **Vị trí menu:** Menu chính › 15. Quản lý Logs › 2. Xem access log domain  _(bấm lần lượt: 15 → 2)_
- **Tệp nguồn:** `/etc/wptt/logs/wptt-xem-access-log-domain`

```text
Việc xem access log cho một domain cụ thể thông qua WPTangToc OLS thường sẽ tận dụng các công cụ sẵn có của hệ điều hành Linux.

Tính năng xem access log domain trong wptangtoc ols có thể được hiểu ngắn gọn như sau:

Xác định vị trí file log: OpenLiteSpeed thường lưu access log cho mỗi virtual host [tương ứng với mỗi domain] trong một file riêng biệt. Đường dẫn phổ biến có thể là /usr/local/lsws/domain.com/logs/access.log. Script wptangtoc ols cung cấp một trình đọc Log chuyên nghiệp giúp bạn phân trang và tìm kiếm dễ dàng.

Tính năng này hỗ trợ người dùng dễ dàng hơn trong việc tìm và sử dụng các công cụ có sẵn của hệ thống để xem access log của OpenLiteSpeed cho từng domain. Điều này giúp quản trị viên website nhanh chóng kiểm tra lưu lượng truy cập, phát hiện lỗi hoặc các hoạt động bất thường liên quan đến một website cụ thể.
```

---

## Xem access log domain có truy vấn (`wptt-xem-access-log-domain-truy-van`)

- **Danh mục:** Quản lý Logs
- **Vị trí menu:** Menu chính › 15. Quản lý Logs › 3. Xem access log domain có truy vấn  _(bấm lần lượt: 15 → 3)_
- **Tệp nguồn:** `/etc/wptt/logs/wptt-xem-access-log-domain-truy-van`

```text
Việc xem access log cho một domain cụ thể thông qua WPTangToc OLS thường sẽ tận dụng các công cụ sẵn có của hệ điều hành Linux.

Tính năng xem access log domain trong WPTangToc OLS có thể được hiểu ngắn gọn như sau:

Xác định vị trí file log: OpenLiteSpeed thường lưu access log cho mỗi virtual host [tương ứng với mỗi domain] trong một file riêng biệt. Đường dẫn phổ biến có thể là /usr/local/lsws/domain.com/logs/access.log. Script cung cấp một công cụ tìm kiếm siêu tốc [FZF] để truy vấn nhanh vào file log này.

Tính năng này hỗ trợ người dùng dễ dàng lọc, tìm kiếm IP, mã trạng thái [như 404, 500], hoặc URL truy cập. Điều này giúp quản trị viên website nhanh chóng kiểm tra lưu lượng truy cập, phát hiện lỗi hoặc các hoạt động bất thường [như DDoS, Scan lỗi] liên quan đến một website cụ thể.
```

---

## Xem error log domain (`wptt-xem-error-log-domain`)

- **Danh mục:** Quản lý Logs
- **Vị trí menu:** Menu chính › 15. Quản lý Logs › 4. Xem error log domain  _(bấm lần lượt: 15 → 4)_
- **Tệp nguồn:** `/etc/wptt/logs/wptt-xem-error-log-domain`

```text
việc xem error log cho một domain cụ thể thông qua wptangtoc ols thường sẽ tận dụng các công cụ sẵn có của hệ điều hành Linux.

Tính năng xem access log domain trong wptangtoc ols có thể được hiểu ngắn gọn như sau:

Xác định vị trí file log: OpenLiteSpeed thường lưu error log cho mỗi virtual host [tương ứng với mỗi domain] trong một file riêng biệt. Đường dẫn phổ biến có thể là /usr/local/lsws/domain.com/logs/error.log Script wptangtoc ols có thể cung cấp một lệnh hoặc tùy chọn để nhanh chóng xác định hoặc truy cập vào file log này.

Tính năng này hỗ trợ người dùng dễ dàng hơn trong việc tìm và sử dụng các công cụ có sẵn của hệ thống để xem error log của OpenLiteSpeed cho từng domain. Điều này giúp quản trị viên nhanh chóng kiểm tra, phát hiện lỗi, phục vụ công việc gỡ lỗi hoặc các hoạt động bất thường liên quan đến một website cụ thể.
```

---

## Bật/Tắt access log server (`wptt-bat-tat-access-log-server`)

- **Danh mục:** Quản lý Logs
- **Vị trí menu:** Menu chính › 15. Quản lý Logs › 5. Bật/Tắt access log server  _(bấm lần lượt: 15 → 5)_
- **Tệp nguồn:** `/etc/wptt/logs/wptt-bat-tat-access-log-server`

```text
Access log server giúp ích gì:
* Chức năng: Ghi lại mọi yêu cầu [request] mà máy chủ nhận được cho địa chỉ IP public hiện tại của bạn.
* Thông tin: Thường bao gồm địa chỉ IP của khách truy cập, thời gian truy cập, trang/tệp được yêu cầu, mã trạng thái phản hồi [như 200 - OK, 404 - Not Found, 500 - Server Error], trình duyệt người dùng, v.v.
* Lợi ích: Giúp bạn hiểu được ai đang truy cập địa chỉ IP, họ xem gì, tần suất truy cập, phát hiện các truy cập bất thường.

Lợi ích và cân nhắc:
* Tắt log: Giúp giảm tải I/O cho ổ cứng, tiết kiệm dung lượng lưu trữ. Tuy nhiên, bạn sẽ mất thông tin về các lượt truy cập, gây khó khăn cho việc phân tích traffic, gỡ lỗi hoặc điều tra các vấn đề bảo mật.
* Bật log: Cung cấp dữ liệu chi tiết về mọi yêu cầu đến server, hữu ích cho việc theo dõi, phân tích và bảo mật.

Ghi chú: Access log domain hoàn toàn khác với access log server.
Access log server ghi lại khi ai đó truy cập vào địa chỉ IP của bạn.
Access log domain ghi lại khi ai đó truy cập vào domain của bạn.

Đường dẫn file access log server tại: /usr/local/lsws/logs/access.log
```

---

## Xem access log server (`wptt-xem-access-log-server`)

- **Danh mục:** Quản lý Logs
- **Vị trí menu:** Menu chính › 15. Quản lý Logs › 6. Xem access log server  _(bấm lần lượt: 15 → 6)_
- **Tệp nguồn:** `/etc/wptt/logs/wptt-xem-access-log-server`

```text
Việc xem access log server cho IP public thông qua WPTangToc OLS thường sẽ tận dụng các công cụ sẵn có của hệ điều hành Linux.

Tính năng xem access log server trong WPTangToc OLS có thể được hiểu ngắn gọn như sau:

Xác định vị trí file log: OpenLiteSpeed thường lưu access log server trong một file riêng biệt. Đường dẫn phổ biến có thể là /usr/local/lsws/logs/access.log. Script cung cấp một trình đọc chuyên nghiệp để truy cập vào file log này.

Tính năng này hỗ trợ người dùng dễ dàng hơn trong việc tìm và sử dụng các công cụ có sẵn của hệ thống để xem access log tổng của OpenLiteSpeed. Điều này giúp quản trị viên hệ thống nhanh chóng kiểm tra lưu lượng truy cập toàn cục, phát hiện lỗi hoặc các hoạt động quét cổng/IP bất thường.
```

---

## Xem error log server (`wptt-xem-error-log-server`)

- **Danh mục:** Quản lý Logs
- **Vị trí menu:** Menu chính › 15. Quản lý Logs › 7. Xem error log server  _(bấm lần lượt: 15 → 7)_
- **Tệp nguồn:** `/etc/wptt/logs/wptt-xem-error-log-server`

```text
Việc xem error log cho server litespeed thông qua wptangtoc ols thường sẽ tận dụng các công cụ sẵn có của hệ điều hành Linux.

Tính năng xem error log server trong wptangtoc ols có thể được hiểu ngắn gọn như sau:

Xác định vị trí file log: OpenLiteSpeed thường lưu error log server trong một file riêng biệt. Đường dẫn phổ biến có thể là /usr/local/lsws/logs/error.log. Script wptangtoc ols cung cấp trình đọc chuyên nghiệp để nhanh chóng xác định và truy cập vào file log này.

Tính năng này hỗ trợ người dùng dễ dàng hơn trong việc tìm và sử dụng các công cụ có sẵn của hệ thống để xem error log của OpenLiteSpeed cho hệ thống. Điều này giúp quản trị viên nhanh chóng kiểm tra, phát hiện lỗi, phục vụ công việc gỡ lỗi hoặc các hoạt động bất thường liên quan đến webserver.
```

---

## Xem access log domain thời gian thực (`wptt-tail-f-realtime-xem-access-log-domain`)

- **Danh mục:** Quản lý Logs
- **Vị trí menu:** Menu chính › 15. Quản lý Logs › 9. Xem access log domain thời gian thực  _(bấm lần lượt: 15 → 9)_
- **Tệp nguồn:** `/etc/wptt/logs/wptt-tail-f-realtime-xem-access-log-domain`

```text
Việc xem access log theo thời gian thực cho một domain cụ thể thông qua WPTangToc OLS.

Tính năng xem access log domain theo thời gian thực trong wptangtoc ols có thể được hiểu ngắn gọn như sau:

Xác định vị trí file log: OpenLiteSpeed thường lưu access log cho mỗi virtual host [tương ứng với mỗi domain] trong một file riêng biệt. Đường dẫn phổ biến có thể là /usr/local/lsws/domain.com/logs/access.log. Script wptangtoc ols cung cấp lệnh để xem nhật ký ngay khi có người truy cập vào website.

Tính năng này hỗ trợ người dùng dễ dàng hơn trong việc tìm và sử dụng các công cụ có sẵn của hệ thống để xem access log của OpenLiteSpeed cho từng domain. Điều này giúp quản trị viên website nhanh chóng kiểm tra lưu lượng truy cập, phát hiện lỗi hoặc các hoạt động bất thường liên quan đến một website cụ thể.
```

---

## Kích hoạt / Huỷ kích hoạt Logs Database (`wptt-bat-tat-log-database`)

- **Danh mục:** Quản lý Logs
- **Vị trí menu:** Menu chính › 15. Quản lý Logs › 13. Kích hoạt / Huỷ kích hoạt Logs Database  _(bấm lần lượt: 15 → 13)_
- **Tệp nguồn:** `/etc/wptt/logs/wptt-bat-tat-log-database`

```text
Tính năng Bật / Tắt ghi log database cho phép người dùng cấu hình hệ quản trị cơ sở dữ liệu MariaDB để bật hoặc ngừng việc ghi lại các hoạt động, truy vấn, hoặc lỗi vào các tệp nhật ký.

Các loại log database phổ biến bao gồm:
* General Query Log: Ghi lại mọi truy vấn được gửi đến database.
* Slow Query Log: Ghi lại các truy vấn chạy chậm hơn một ngưỡng thời gian nhất định [giúp tìm ra các plugin hoặc theme làm chậm web].
* Error Log: Ghi lại các lỗi khi khởi động, chạy, hoặc dừng database.
* Binary Log [Binlog]: Ghi lại mọi thay đổi đối với dữ liệu.

Mục đích chính của việc TẮT ghi log database là:
* Cải thiện hiệu suất [Performance]: 🚀 Việc ghi log tiêu tốn tài nguyên I/O và CPU. Tắt chúng giúp database chạy nhanh hơn.
* Tiết kiệm dung lượng ổ cứng: 💾 Các tệp log có thể phình to rất nhanh. Tắt chúng giúp bảo vệ không gian lưu trữ.

Tóm lại, đây là một công cụ giúp tối ưu hiệu suất và dung lượng. Mặc định nên TẮT để web chạy nhanh nhất, chỉ BẬT khi bạn cần bắt bệnh [debug] lỗi truy vấn chậm của website.
```

---

## Xem log database (`wptt-xem-log-db`)

- **Danh mục:** Quản lý Logs
- **Vị trí menu:** Menu chính › 15. Quản lý Logs › 14. Xem log database  _(bấm lần lượt: 15 → 14)_
- **Tệp nguồn:** `/etc/wptt/logs/wptt-xem-log-db`

```text
Việc xem log cho database server thông qua WPTangToc OLS thường sẽ tận dụng các công cụ sẵn có của hệ điều hành Linux.

Tính năng xem log database trong WPTangToc OLS có thể được hiểu ngắn gọn như sau:

Xác định vị trí file log: Đường dẫn phổ biến thường là /var/log/mysql/mysql.log. Script cung cấp trình đọc chuyên nghiệp [Less] để truy cập an toàn vào file log này mà không làm treo máy chủ.

Tính năng này hỗ trợ người dùng dễ dàng hơn trong việc tìm và sử dụng các công cụ có sẵn của hệ thống để xem toàn bộ các truy vấn SQL đang diễn ra. Điều này giúp quản trị viên hệ thống nhanh chóng kiểm tra, phát hiện các truy vấn bất thường hoặc gỡ lỗi [Debug] ứng dụng kết nối tới database.
```

---

## Xem log database truy vấn chậm (`wptt-xem-log-db-truy-van-cham`)

- **Danh mục:** Quản lý Logs
- **Vị trí menu:** Menu chính › 15. Quản lý Logs › 15. Xem log database truy vấn chậm  _(bấm lần lượt: 15 → 15)_
- **Tệp nguồn:** `/etc/wptt/logs/wptt-xem-log-db-truy-van-cham`

```text
Việc xem log truy vấn chậm [Slow Query Log] cho database server thông qua WPTangToc OLS thường sẽ tận dụng các công cụ sẵn có của hệ điều hành Linux.

Tính năng xem log database truy vấn chậm trong WPTangToc OLS có thể được hiểu ngắn gọn như sau:

Xác định vị trí file log: Đường dẫn chuẩn là /var/log/mysql/mysql-slow.log. Script cung cấp một trình đọc chuyên nghiệp [Less] để truy cập an toàn vào file log này.

Tính năng này hỗ trợ người dùng dễ dàng theo dõi các câu lệnh SQL mất nhiều thời gian để thực thi. Điều này giúp quản trị viên website nhanh chóng kiểm tra, phát hiện các plugin/theme hoặc đoạn code gây nghẽn cổ chai [bottleneck] và làm chậm website.
```

---

## Xem kiểm tra tốc độ sử lý PHP hệ thống (`wptt-check-php-load-run-server-call`)

- **Danh mục:** Quản lý Logs
- **Vị trí menu:** Menu chính › 15. Quản lý Logs › 16. Xem kiểm tra tốc độ sử lý PHP hệ thống  _(bấm lần lượt: 15 → 16)_
- **Tệp nguồn:** `/etc/wptt/logs/wptt-check-php-load-run-server-call`

```text
Tính năng kiểm tra tốc độ xử lý PHP bằng lệnh strace -c php index.php trong WPTangToc OLS là một công cụ chẩn đoán và phân tích hiệu suất cấp thấp, giúp bạn hiểu cách một kịch bản PHP [cụ thể là index.php] tương tác với hệ điều hành.

Mục đích và lợi ích của tính năng này:
* Xác định nút cổ chai [Bottlenecks] cấp hệ thống: Nó không đo tốc độ thực thi mã PHP một cách trực tiếp như các công cụ profiling [Xdebug, Blackfire]. Thay vào đó, nó cho bạn biết PHP script đang dành bao nhiêu thời gian để chờ đợi hoặc tương tác với hệ điều hành.
* Phân tích I/O: Bạn có thể thấy rõ script đang tốn nhiều thời gian cho việc đọc [read], ghi [write], mở [openat], hay kiểm tra [stat] tệp tin hay không. Đây là dấu hiệu của các vấn đề liên quan đến ổ cứng chậm hoặc mã nguồn truy cập file không hiệu quả. 💾
* Kiểm tra tương tác mạng: Nếu script có kết nối mạng, bạn sẽ thấy thời gian dành cho các lời gọi như socket, connect, sendto, recvfrom.
* Chẩn đoán sự cố: Giúp phát hiện các vấn đề liên quan đến quyền truy cập tệp, kết nối không thành công, hoặc các lỗi khác ở tầng hệ điều hành.

Tóm lại, đây một công cụ chẩn đoán nâng cao, cung cấp cái nhìn sâu sắc về sự tương tác giữa PHP và hệ điều hành, giúp tìm ra các nguyên nhân gây chậm trễ không nằm trực tiếp trong logic mã PHP.
```

---

## Xoá log (`wptt-xoa-logs`)

- **Danh mục:** Quản lý Logs
- **Vị trí menu:** Menu chính › 15. Quản lý Logs › 17. Xoá log  _(bấm lần lượt: 15 → 17)_
- **Tệp nguồn:** `/etc/wptt/logs/wptt-xoa-logs`

```text
Tính năng Xóa toàn bộ log là một công cụ bảo trì cho phép người dùng nhanh chóng dọn dẹp và loại bỏ tất cả các tệp tin nhật ký [log files] được tạo ra bởi máy chủ web [như OpenLiteSpeed], Máy chủ database [MariaDB], ứng dụng [như PHP], và cả hệ thống linux.

Mục đích chính của tính năng này là:
* Giải phóng dung lượng ổ cứng: Theo thời gian, các tệp log có thể chiếm một dung lượng đáng kể trên máy chủ. Việc xóa chúng đi giúp thu hồi không gian lưu trữ.
* Làm mới [Reset] log: Bắt đầu ghi log từ một trạng thái sạch sẽ, hữu ích khi cần theo dõi một sự cố cụ thể mới phát sinh.
* Bảo mật/Riêng tư [trong một số trường hợp]: Xóa bỏ các thông tin nhạy cảm có thể đã được ghi lại trong log.

Tuy nhiên, cần lưu ý:
* Việc xóa toàn bộ log sẽ làm mất vĩnh viễn các dữ liệu lịch sử về truy cập, lỗi, và hoạt động của máy chủ. Điều này có thể gây khó khăn cho việc phân tích hiệu suất, truy tìm nguyên nhân sự cố trong quá khứ, hoặc điều tra các vấn đề bảo mật.
* Nên cân nhắc sao lưu [backup] log trước khi xóa nếu bạn nghĩ rằng có thể cần đến chúng sau này.

Tóm lại, đây là một tính năng tiện ích để dọn dẹp nhanh chóng, nhưng cần được sử dụng một cách cẩn trọng để tránh mất dữ liệu quan trọng.
```

---

## Duplicate nhân bản website (`wptt-sao-chep-website`)

- **Danh mục:** Duplicate nhân bản website
- **Vị trí menu:** Menu chính › 16. Duplicate nhân bản website  _(bấm lần lượt: 16)_
- **Tệp nguồn:** `/etc/wptt/wptt-sao-chep-website`

```text
Tính năng sao chép website (Website Cloning, Nhân bản website) cho phép bạn nhân bản toàn bộ mã nguồn, cơ sở dữ liệu và cấu hình từ một domain nguồn sang một domain đích hoàn toàn độc lập.

Mục đích:
Tạo nhanh một website hoàn chỉnh gắn liền với domain mới hoặc subdomain thử nghiệm mà không gây gián đoạn hay ảnh hưởng tới hoạt động của website chính.

Lợi ích nổi bật:
* Triển khai tức thì sang domain mới: Tự động tạo Virtual Host, cấp thư mục web root và database riêng cho domain đích.
* Tự động xử lý URL domain: Hệ thống tự động tìm và thay thế (Search & Replace) toàn bộ chuỗi domain cũ sang domain mới.
* An toàn tuyệt đối cho domain gốc: Mọi thao tác đọc, trích xuất dữ liệu đều diễn ra ở chế độ an toàn, Zero-Downtime.
```

---

## Quản lý mã nguồn (`wptt-ma-nguon-main`)

- **Danh mục:** Quản lý mã nguồn
- **Vị trí menu:** Menu chính › 17. Quản lý mã nguồn  _(bấm lần lượt: 17)_
- **Tệp nguồn:** `/etc/wptt/wptt-ma-nguon-main`

```text
Tính năng quản lý mã nguồn
* xoá mã nguồn
* xem dung lượng mã nguồn
* xem tổng quan mã nguồn
```

---

## Kiểm tra dung lượng mã nguồn website (`wptt-kiem-tra-dung-luong`)

- **Danh mục:** Quản lý mã nguồn
- **Vị trí menu:** Menu chính › 17. Quản lý mã nguồn › 2. Kiểm tra dung lượng mã nguồn website  _(bấm lần lượt: 17 → 2)_
- **Tệp nguồn:** `/etc/wptt/ma-nguon/wptt-kiem-tra-dung-luong`

```text
WPTangToc OLS có tính năng kiểm tra dung lượng mã nguồn website, thì đây là một chức năng tiện ích giúp bạn nhanh chóng xem được tổng kích thước [dung lượng đĩa] mà thư mục của một website cụ thể đang chiếm dụng trên máy chủ.

Tính năng Kiểm tra Dung lượng Mã nguồn Website [WPTangToc OLS]
💾 Mục đích chính:
* Quản lý Dung lượng Đĩa: Giúp bạn theo dõi xem website nào đang chiếm nhiều không gian lưu trữ nhất trên máy chủ, đặc biệt hữu ích khi dung lượng đĩa có hạn.
* Xác định Website Phình to: Dễ dàng tìm ra các website có dung lượng lớn bất thường, có thể do chứa nhiều file ảnh/video, file cache lớn, hoặc các file không cần thiết.
* Hỗ trợ Dọn dẹp: Cung cấp thông tin để bạn quyết định website nào cần được dọn dẹp [xóa file rác, tối ưu ảnh, xóa cache cũ].
* Lập kế hoạch Sao lưu/Di chuyển: Biết được dung lượng giúp bạn ước tính thời gian và không gian cần thiết cho việc sao lưu hoặc di chuyển website.

Tóm lại: Tính năng kiểm tra dung lượng mã nguồn website trong WPTangToc OLS là một công cụ hữu ích giúp bạn giám sát và quản lý hiệu quả việc sử dụng không gian lưu trữ trên máy chủ cho từng website WordPress, hỗ trợ việc tối ưu và bảo trì hệ thống.
```

---

## Phân quyền (`wptt-phanquyen`)

- **Danh mục:** Phân quyền
- **Vị trí menu:** Menu chính › 18. Phân quyền  _(bấm lần lượt: 18)_
- **Vị trí menu:** Menu chính › 2. Quản lý Domain › 11. Phân quyền Domain  _(bấm lần lượt: 2 → 11)_
- **Tệp nguồn:** `/etc/wptt/wptt-phanquyen`

```text
Tính năng Phân quyền trong WPTangToc OLS là một công cụ quan trọng giúp thiết lập và quản lý quyền sở hữu [ownership] cũng như quyền truy cập [permissions] cho các tệp tin và thư mục trên máy chủ, đặc biệt là cho các website WordPress. Việc phân quyền chính xác là yếu tố then chốt để đảm bảo an ninh và hoạt động ổn định của website.

Mục đích chính của tính năng Phân quyền:
* Bảo mật: Ngăn chặn các truy cập trái phép hoặc các hành động không mong muốn vào mã nguồn và dữ liệu website. Quyền hạn không đúng có thể tạo lỗ hổng cho hacker khai thác.
* Đảm bảo hoạt động của website: WordPress và các plugin/theme cần có quyền ghi vào một số thư mục nhất định để hoạt động [ví dụ: tải lên media, cập nhật, tạo cache]. Phân quyền sai có thể gây lỗi chức năng.
* Đơn giản hóa quản lý: WPTangToc OLS thường cung cấp các lệnh hoặc tùy chọn tự động để thiết lập quyền hạn chuẩn cho WordPress, giúp người dùng không cần phải nhớ các lệnh chown và chmod phức tạp của Linux.

Lợi ích:
* Tăng cường bảo mật: Giảm thiểu rủi ro từ các cuộc tấn công dựa trên quyền hạn tệp tin.
* Đảm bảo website hoạt động ổn định: Các chức năng như cập nhật, tải lên media hoạt động trơn tru.
* Dễ sử dụng: Ngay cả người dùng ít kinh nghiệm về Linux cũng có thể quản lý quyền hạn một cách chính xác thông qua tính năng wptangtoc ols.

nếu website của bạn không xoá, thêm được plugin, themes hoặc lỗi phần ghi dữ liệu.
Bạn hãy phân quyền, tính năng này sẽ phần quyền lại tự động theo chuẩn bảo mật.
Phần mềm sẽ thay đổi thuộc sở hữu file về đúng username website và phần quyền đúng với bảo mật

Tóm lại, tính năng Phân quyền trong WPTangToc OLS giúp đơn giản hóa và tự động hóa việc thiết lập quyền sở hữu và quyền truy cập tệp tin/thư mục theo chuẩn bảo mật và hoạt động cho website WordPress trên máy chủ OpenLiteSpeed.
```

---

## Quản lý Cache (`wptt-cache-main`)

- **Danh mục:** Quản lý Cache
- **Vị trí menu:** Menu chính › 19. Quản lý Cache  _(bấm lần lượt: 19)_
- **Tệp nguồn:** `/etc/wptt/wptt-cache-main`

```text
Tính năng quản lý Cache của WPTangToc OLS là một công cụ tích hợp giúp người dùng dễ dàng cấu hình và kiểm soát Cache – một cơ chế caching mạnh mẽ đặc biệt hiệu quả cho website WordPress.

Giới thiệu ngắn gọn:

Mục đích: Tối ưu hóa tốc độ tải trang, giảm tải cho máy chủ và cải thiện trải nghiệm người dùng bằng cách lưu trữ các bản sao tĩnh của nội dung website và phân phối chúng nhanh chóng.
Cách hoạt động:
* Để tận dụng tối đa các tính năng caching nâng cao [như object cache, Opcache, CDN Cache...].
* Kích hoạt/Vô hiệu hóa LiteSpeed Cache: Dễ dàng bật hoặc tắt tính năng caching cho toàn bộ máy chủ hoặc từng website cụ thể.
* Xóa Cache [Purge Cache]: Cho phép xóa toàn bộ cache hoặc cache của một website cụ thể khi có cập nhật nội dung mới.
* Cấu hình cơ bản LiteSpeed Cache: Có thể bao gồm các tùy chọn để tinh chỉnh một số thiết lập caching cơ bản mà không cần can thiệp sâu vào file cấu hình.
* v.v.v

Lợi ích:
* Tăng tốc website vượt trội: Giảm đáng kể thời gian tải trang.
* Cải thiện hiệu suất máy chủ: Giảm số lượng yêu cầu cần xử lý động.
* Nâng cao trải nghiệm người dùng: Website nhanh hơn giúp giữ chân khách truy cập.
* Dễ sử dụng: Đơn giản hóa việc quản lý một hệ thống caching mạnh mẽ.

Tính năng này là một trong những điểm mạnh của WPTangToc OLS, giúp người dùng khai thác hiệu quả sức mạnh của LiteSpeed Cache để website WordPress hoạt động nhanh và ổn định.
```

---

## Kích hoạt LScache WP (`nhap-du-lieu-litespeed-wptangtoc`)

- **Danh mục:** Quản lý Cache
- **Vị trí menu:** Menu chính › 19. Quản lý Cache › 1. Kích hoạt LScache WP  _(bấm lần lượt: 19 → 1)_
- **Vị trí menu:** Menu chính › 1. Quản lý WordPress › 7. Auto Tối ưu Plugin LSCache  _(bấm lần lượt: 1 → 7)_
- **Tệp nguồn:** `/etc/wptt/wordpress/nhap-du-lieu-litespeed-wptangtoc`

```text
Tính năng giúp cài đặt plugin litespeed Cache WordPress [Nếu chưa có]
và đồng thời sẽ import tối ưu litespeed cache theo khuyến nghị của wptangtoc.com
giúp cải thiện hiệu suất website
```

---

## Kiểm tra LScache (`real-time-check`)

- **Danh mục:** Quản lý Cache
- **Vị trí menu:** Menu chính › 19. Quản lý Cache › 3. Kiểm tra LScache  _(bấm lần lượt: 19 → 3)_
- **Vị trí menu:** Menu chính › 2. Quản lý Domain › 14. Giám sát hệ thống theo gian thực Domain  _(bấm lần lượt: 2 → 14)_
- **Vị trí menu:** Menu chính › 15. Quản lý Logs › 10. Real-Time Statistics Monitoring domain  _(bấm lần lượt: 15 → 10)_
- **Vị trí menu:** Menu chính › 15. Quản lý Logs › 11. Real-Time Statistics Monitoring ALL domain  _(bấm lần lượt: 15 → 11)_
- **Tệp nguồn:** `/etc/wptt/domain/real-time-check`

```text
Tính năng Giám sát Real-time [Thời gian thực] là công cụ đo lường sức khỏe của website đang chạy trên OpenLiteSpeed ngay tại thời điểm hiện tại.

Mục đích chính:
* Theo dõi lưu lượng: Biết được website đang có bao nhiêu người truy cập [RPS - Yêu cầu/giây].
* Kiểm tra hiệu quả Cache: Xem tỷ lệ Cache Hits để biết WPTangToc OLS đang phục vụ nội dung tĩnh tốt đến mức nào, giảm tải cho CPU/RAM ra sao.
* Phát hiện bất thường: Nếu thông số 'Đang xử lý [Active]' tăng đột biến, rất có thể website đang bị tấn công DDoS hoặc quá tải Database.

Các thông số hiển thị:
- Đang xử lý [Active]: Số lượng kết nối đang được CPU/PHP xử lý trực tiếp.
- Yêu cầu/giây [RPS]: Tổng số lượt truy cập [hit] dội vào máy chủ trong 1 giây.
- Cache chung/riêng: Số lượng truy cập được phục vụ thẳng từ bộ nhớ đệm [siêu nhanh].
- File tĩnh/giây: Số lượng hình ảnh, CSS, JS được tải.

Hướng dẫn: Màn hình sẽ tự động làm mới sau mỗi 1 giây. Để thoát khỏi chế độ giám sát, bạn chỉ cần nhấn phím '0' hoặc tổ hợp phím Ctrl+C.
```

---

## On/Off Redis & Valkey & KeyDB (`wptt-redis-valkey-keydb`)

- **Danh mục:** Quản lý Cache
- **Vị trí menu:** Menu chính › 19. Quản lý Cache › 4. On/Off Redis & Valkey & KeyDB  _(bấm lần lượt: 19 → 4)_
- **Tệp nguồn:** `/etc/wptt/cache/wptt-redis-valkey-keydb`

```text
1. TÍNH NĂNG CÀI ĐẶT [Install Object Cache]
Tự động cài đặt và cấu hình hệ thống Object Cache với các Engine:
Valkey, KeyDB hoặc Redis, giúp WordPress lưu trữ dữ liệu tạm thời
trong bộ nhớ RAM thay vì phải truy vấn Database liên tục.

LỢI ÍCH:
- Tăng tốc xử lý WordPress bằng cách giảm các truy vấn Database lặp lại.
- Giảm tải CPU, MariaDB/MySQL khi website có nhiều lượt truy cập.
- Cải thiện tốc độ phản hồi đối với các trang có nhiều dữ liệu động.
- Hỗ trợ tối ưu WooCommerce, trang quản trị WordPress và website
  có lượng dữ liệu truy vấn lớn.
- Tự động cấu hình Unix Socket nhằm tối ưu kết nối nội bộ trên VPS.
- Thiết lập xác thực và phân quyền ACL để cô lập kết nối giữa
  các website trên cùng hệ thống.
- Tự động tích hợp PHP Extension Redis/igbinary tương thích với
  các phiên bản LiteSpeed PHP hiện có.
- Tự động cấu hình giới hạn bộ nhớ Cache và chính sách dọn dữ liệu
  nhằm hạn chế ảnh hưởng đến tài nguyên VPS.

LƯU Ý:
Object Cache không thay thế Page Cache (như LSCache) và không đảm bảo
website sẽ tăng tốc trong mọi trường hợp. Hiệu quả phụ thuộc vào
cấu hình VPS, plugin, Database và lượng truy cập thực tế.

2. TÍNH NĂNG HỦY CÀI ĐẶT [Uninstall Object Cache]
Tự động dừng dịch vụ, gỡ bỏ Engine Object Cache đã cài đặt và
dọn dẹp các thành phần cấu hình liên quan do WPTangToc quản lý.

CÁC THÀNH PHẦN ĐƯỢC DỌN DẸP:
- Dừng và vô hiệu hóa dịch vụ Valkey/KeyDB/Redis tương ứng.
- Gỡ bỏ Package Engine Object Cache khỏi hệ thống.
- Xóa các tệp cấu hình, dữ liệu lưu trữ và thư mục Runtime
  của Engine được chọn.
- Gỡ bỏ PHP Extension Redis do quá trình cài đặt quản lý.
- Xóa cấu hình Monit liên quan đến Engine.
- Xóa thông tin Master Password và các tài khoản ACL Object Cache
  được WPTangToc lưu trữ trong cấu hình hệ thống và Virtual Host.

CẢNH BÁO:
- Website đang sử dụng Object Cache có thể mất kết nối Cache
  sau khi gỡ bỏ dịch vụ.
- Dữ liệu Cache hiện có sẽ bị xóa; website có thể cần thời gian
  để tái tạo Cache sau khi hoạt động trở lại.
- Các cấu hình hoặc Package dùng chung với ứng dụng khác có thể
  bị ảnh hưởng nếu chúng phụ thuộc vào Engine được gỡ bỏ.
- Khuyến nghị kiểm tra các website đang sử dụng Object Cache
  trước khi xác nhận gỡ bỏ.

3. QUẢN LÝ TÀI KHOẢN ACL & DATABASE ID
Cung cấp thông tin kết nối Object Cache riêng cho từng website,
giúp quản trị viên dễ dàng cấu hình Plugin Cache trên WordPress.

- Hiển thị Username, Password và Database ID riêng biệt.
- Hỗ trợ cấu hình LiteSpeed Cache, Redis Object Cache và
  các Plugin WordPress tương thích Redis.
- Sử dụng Unix Socket để kết nối nội bộ, không cần mở cổng
  TCP Redis/Valkey ra Internet.
- Phân quyền ACL nhằm hạn chế quyền truy cập của từng website.
- Hỗ trợ kiểm tra và quản lý thông tin kết nối Cache.

LƯU Ý BẢO MẬT:
Master Password là khóa quản trị cấp hệ thống.
Tuyệt đối không sử dụng Master Password cho Plugin WordPress.
Chỉ sử dụng tài khoản ACL riêng của từng website.

4. KHUYẾN NGHỊ TÀI NGUYÊN VPS
- VPS RAM thấp có thể không đủ tài nguyên để vận hành Object Cache.
- Redis/Valkey/KeyDB sử dụng RAM để lưu dữ liệu Cache.
- Khi RAM bị thiếu, hệ thống có thể phát sinh OOM hoặc ảnh hưởng
  đến MariaDB, PHP và các dịch vụ khác.
- WooCommerce hoặc website nhiều dữ liệu động cần được theo dõi
  tài nguyên thường xuyên.
- Nên kiểm tra RAM, CPU và mức sử dụng Cache trước khi cài đặt.

5. LƯU Ý VẬN HÀNH
- Object Cache chỉ phát huy hiệu quả khi Plugin WordPress
  được cấu hình kết nối chính xác.
- Không nên cài đặt nhiều Engine Object Cache cùng lúc.
- Không chia sẻ tài khoản ACL giữa nhiều website.
- Không sử dụng Object Cache làm nơi lưu trữ dữ liệu quan trọng
  duy nhất hoặc dữ liệu cần đảm bảo tính toàn vẹn lâu dài.
- Khi thay đổi Engine, hãy kiểm tra lại Plugin Cache và
  thông tin kết nối của các website.
```

---

## Bật/Tắt memcached (`wptt-memcached`)

- **Danh mục:** Quản lý Cache
- **Vị trí menu:** Menu chính › 19. Quản lý Cache › 5. Bật/Tắt memcached  _(bấm lần lượt: 19 → 5)_
- **Tệp nguồn:** `/etc/wptt/cache/wptt-memcached`

```text
1. Tính Năng Cài Đặt Memcached [Install Memcached]
Cài đặt Memcached là quá trình thiết lập và chạy phần mềm máy chủ Memcached trên một hệ thống [thường là máy chủ Linux] để các ứng dụng có thể kết nối và sử dụng nó làm một hệ thống lưu trữ đối tượng trong bộ nhớ [in-memory object caching system] hiệu suất cao. 🚀

Memcached là một công cụ mã nguồn mở, được thiết kế để tăng tốc các ứng dụng web động bằng cách giảm tải cho cơ sở dữ liệu. Nó lưu trữ các cặp key-value [khóa-giá trị] trong RAM, giúp truy xuất dữ liệu cực kỳ nhanh.

Mục đích chính:
* Caching dữ liệu: Lưu kết quả của các truy vấn database tốn kém, các lệnh gọi API, hoặc các đoạn HTML đã được render để tăng tốc độ phản hồi của website.
* Giảm tải cho database: Giảm số lượng truy vấn đọc trực tiếp đến database.
* Cải thiện hiệu suất ứng dụng: Giúp website/ứng dụng tải nhanh hơn và đáp ứng tốt hơn.
Kết quả: Sau khi cài đặt, bạn sẽ có một máy chủ Memcached đang chạy, lắng nghe trên cổng unix stocket path: /var/run/memcached/memcached.sock, sẵn sàng để các ứng dụng kết nối và sử dụng cho việc caching.

2. Tính Năng Hủy Cài Đặt Memcached [Uninstall Memcached]
Hủy cài đặt Memcached là quá trình gỡ bỏ phần mềm máy chủ Memcached và có thể cả các tệp cấu hình của nó khỏi một hệ thống. 🗑️

Mục đích chính:
* Không còn nhu cầu sử dụng: Khi không còn ứng dụng nào cần đến Memcached hoặc chuyển sang giải pháp caching khác.
* Giải phóng tài nguyên: Thu hồi bộ nhớ RAM [vì Memcached chủ yếu dùng RAM] và một ít không gian đĩa.
* Cấu hình lại hoặc dọn dẹp hệ thống: Khi ngừng hoạt động máy chủ hoặc thực hiện thay đổi lớn.
Kết quả: Phần mềm Memcached sẽ được gỡ bỏ khỏi hệ thống, dịch vụ của nó sẽ không còn chạy và các ứng dụng sẽ không thể sử dụng nó để caching nữa.
```

---

## Bật/tắt OPCache PHP (`wptt-opcache`)

- **Danh mục:** Quản lý Cache
- **Vị trí menu:** Menu chính › 19. Quản lý Cache › 6. Bật/tắt OPCache PHP  _(bấm lần lượt: 19 → 6)_
- **Tệp nguồn:** `/etc/wptt/cache/wptt-opcache`

```text
Tính Năng Thiết Lập Bật OPcache và Tắt OpCache

1: Tính Năng Thiết Lập Bật OPcache [Enable OPcache]
OPcache là quá trình kích hoạt phần mở rộng OPcache trong PHP để nó bắt đầu lưu trữ mã kịch bản PHP đã được biên dịch sẵn [bytecode] vào bộ nhớ RAM.
OPcache là một công cụ giúp tăng tốc độ thực thi của các ứng dụng PHP một cách đáng kể.

Mục đích chính:
* Tăng tốc độ website/ứng dụng: Loại bỏ việc PHP phải biên dịch lại mã nguồn mỗi khi có yêu cầu, thay vào đó sử dụng bytecode đã lưu trong bộ nhớ.
* Giảm tải cho CPU: Việc biên dịch PHP tốn tài nguyên CPU, OPcache giúp giảm bớt gánh nặng này.

2: Tính Năng Thiết Lập Tắt OPcache [Disable OPcache]
Thiết lập tắt OPcache [bằng cách set revalidate_freq=0] khiến hệ thống liên tục kiểm tra file thay đổi, ngăn chặn việc nạp code cũ từ bộ đệm.

Mục đích chính [thường dùng tạm thời]:
* Môi trường phát triển [Development]: Đảm bảo code mới nhất luôn được thực thi ngay lập tức sau khi bạn sửa file.
* Gỡ lỗi [Troubleshooting]: Giúp loại trừ các sự cố do cache gây ra.
```

---

## On/Off PHP JIT Compiler (`wptt-jit-php`)

- **Danh mục:** Quản lý Cache
- **Vị trí menu:** Menu chính › 19. Quản lý Cache › 7. On/Off PHP JIT Compiler  _(bấm lần lượt: 19 → 7)_
- **Tệp nguồn:** `/etc/wptt/cache/wptt-jit-php`

```text
Tính Năng Thiết Lập Bật và Tắt JIT Compiler [PHP 8.0+]

JIT [Just-In-Time] là một bộ biên dịch nâng cao được tích hợp từ PHP 8.0.
Nó sẽ lấy mã Bytecode từ OPcache và biên dịch thẳng ra mã máy [Machine Code] để CPU xử lý trực tiếp.

Cảnh báo quan trọng:
* JIT chỉ hoạt động khi bạn ĐÃ BẬT OPcache. Nếu OPcache tắt, JIT sẽ vô tác dụng.
* JIT cực kỳ mạnh mẽ cho các tác vụ tính toán thuật toán, xử lý ảnh nặng [CPU-bound].
* Hệ thống WPTangToc OLS sẽ tự động tính toán cấp phát RAM cho JIT dựa trên cấu hình phần cứng thực tế của bạn để đảm bảo an toàn tuyệt đối.
```

---

## Xóa Cache website WordPress (`wptt-xoacache`)

- **Danh mục:** Quản lý Cache
- **Vị trí menu:** Menu chính › 19. Quản lý Cache › 8. Xóa Cache website WordPress  _(bấm lần lượt: 19 → 8)_
- **Tệp nguồn:** `/etc/wptt/cache/wptt-xoacache`

```text
Đây là tính năng xoá cache website WordPress
Nó sẽ giúp bạn tự động xoá cache: OpCache, Object Cache, Page Cache HTML, CDN Cache
Với điều kiện: website bạn đang sử dụng công nghệ Cache đó

Tính năng Xóa toàn bộ cache WordPress là hành động loại bỏ tất cả các dữ liệu đã được lưu trữ tạm thời [bộ nhớ đệm] mà website WordPress của bạn sử dụng để tăng tốc độ tải trang và giảm tải cho máy chủ.

Nói một cách đơn giản, đây là việc bạn dọn dẹp các bản sao lưu trữ sẵn của trang web, buộc WordPress phải tạo lại nội dung mới nhất từ cơ sở dữ liệu và các tệp gốc khi có người truy cập tiếp theo.

Mục Đích Chính
* Xem các thay đổi mới nhất: Đây là lý do phổ biến nhất. Nếu bạn vừa cập nhật nội dung, thiết kế, cài đặt theme/plugin, hoặc sửa file CSS/JS, những thay đổi này có thể không hiển thị ngay do website đang phục vụ phiên bản cũ từ cache. Xóa cache sẽ buộc website hiển thị phiên bản mới nhất.
* Gỡ lỗi sự cố: Khi website hoạt động không như mong đợi [lỗi giao diện, thông tin cũ, lỗi hiển thị], xóa cache là một trong những bước đầu tiên để kiểm tra xem có phải do cache bị lỗi thời hay hỏng không.
* Sau khi cập nhật: Sau khi cập nhật WordPress, theme, hoặc plugin, việc xóa cache được khuyến nghị để đảm bảo tính tương thích và các tính năng/bản vá mới được áp dụng đúng cách.
* Khắc phục tình trạng website bị kẹt: Đôi khi website bị đóng băng ở một phiên bản cũ, xóa cache có thể giải quyết được vấn đề này.

Sau khi xóa toàn bộ cache, lần truy cập tiếp theo vào website có thể chậm hơn một chút do máy chủ phải tạo lại mọi thứ từ đầu. Tuy nhiên, điều này đảm bảo bạn và người dùng sẽ thấy được phiên bản mới nhất và chính xác nhất của website.
```

---

## Xóa Cache Redis/Valkey/KeyDB (`wptt-xoa-cache-redis-valkey-keydb`)

- **Danh mục:** Quản lý Cache
- **Vị trí menu:** Menu chính › 19. Quản lý Cache › 9. Xóa Cache Redis/Valkey/KeyDB  _(bấm lần lượt: 19 → 9)_
- **Tệp nguồn:** `/etc/wptt/cache/wptt-xoa-cache-redis-valkey-keydb`

```text
Tính năng xóa Object Cache là công cụ dọn dẹp bộ nhớ đệm RAM [Redis/Valkey/KeyDB] của website.

Giải thích đơn giản:
* Object Cache lưu trữ các truy vấn cơ sở dữ liệu [Database] trực tiếp lên RAM, giúp giảm tải cho MariaDB/MySQL và tăng tốc độ xử lý PHP.
* Tại sao cần xóa? Khi bạn cập nhật dữ liệu lớn, đổi theme, hoặc website bị kẹt dữ liệu cũ, việc xóa Object Cache sẽ ép hệ thống phải truy vấn lại Database để lấy dữ liệu mới nhất.
```

---

## Xóa Cache OPCache PHP (`clear-opcache`)

- **Danh mục:** Quản lý Cache
- **Vị trí menu:** Menu chính › 19. Quản lý Cache › 10. Xóa Cache OPCache PHP  _(bấm lần lượt: 19 → 10)_
- **Tệp nguồn:** `/etc/wptt/cache/clear-opcache`

```text
Tính năng xóa OPcache là một công cụ dùng để làm mới bộ nhớ đệm mã lệnh [bytecode cache] của PHP.

Giải thích đơn giản:

* OPcache là gì? PHP OPcache lưu trữ một phiên bản đã được biên dịch sẵn của mã PHP vào bộ nhớ. Điều này giúp website chạy nhanh hơn vì máy chủ không cần phải biên dịch lại mã mỗi khi có người truy cập.
* Tại sao cần xóa OPcache? Khi bạn cập nhật mã nguồn PHP của website [ví dụ: sửa lỗi, thêm tính năng, cập nhật theme/plugin], OPcache có thể vẫn đang sử dụng phiên bản mã cũ đã lưu trước đó. Việc này khiến thay đổi của bạn không hiển thị ngay.
* Tính năng xóa OPcache làm gì? Nó sẽ xóa toàn bộ mã đã biên dịch đang lưu trong OPcache. Sau khi xóa, PHP sẽ phải biên dịch lại mã nguồn từ đĩa ở lần truy cập tiếp theo, đảm bảo rằng phiên bản mới nhất của mã được sử dụng.
Tóm lại: Tính năng xóa OPcache giúp bạn đảm bảo mọi thay đổi mới nhất trong mã PHP của website được áp dụng và hiển thị chính xác, bằng cách buộc PHP đọc và biên dịch lại mã nguồn mới nhất. Các công cụ quản lý máy chủ như WPTangToc OLS thường cung cấp cách dễ dàng để thực hiện việc này.
```

---

## T.Lập giới hạn disk Cache PAGE (`wptt-setup-gioi-han-dung-luong-page-cache-html`)

- **Danh mục:** Quản lý Cache
- **Vị trí menu:** Menu chính › 19. Quản lý Cache › 11. T.Lập giới hạn disk Cache PAGE  _(bấm lần lượt: 19 → 11)_
- **Tệp nguồn:** `/etc/wptt/cache/wptt-setup-gioi-han-dung-luong-page-cache-html`

```text
Tính năng Thiết lập giới hạn dung lượng Page Cache HTML là một cài đặt cho phép bạn quy định dung lượng ổ đĩa tối đa mà bộ nhớ đệm [cache] chứa các trang HTML tĩnh của website được phép sử dụng.

Nói một cách đơn giản, đây là cách bạn đặt ra một ngưỡng cho kho lưu trữ các bản sao trang web đã được tạo sẵn [Page Cache HTML]. Khi kho này đầy đến ngưỡng đó, hệ thống sẽ tự động dọn dẹp bớt các file cache cũ hoặc ít dùng để nhường chỗ cho các file mới, tránh làm đầy ổ cứng của máy chủ.

Mục Đích Chính
* Ngăn chặn việc sử dụng ổ đĩa quá mức: Các tệp HTML được cache, đặc biệt với website có nhiều trang hoặc thay đổi thường xuyên, có thể chiếm nhiều dung lượng. Giới hạn này giúp cache không phình to vô hạn, tránh làm đầy ổ cứng và gây ảnh hưởng đến hoạt động của máy chủ.
* Quản lý tài nguyên hiệu quả: Giúp kiểm soát việc sử dụng không gian lưu trữ, đặc biệt quan trọng với các gói hosting có dung lượng hạn chế.
* Tự động dọn dẹp cache cũ: Khi đạt đến giới hạn, cơ chế cache thường sẽ tự động xóa các tệp cache cũ nhất hoặc ít được truy cập nhất để tạo không gian cho các trang mới được cache.
* Duy trì sức khỏe máy chủ: Tránh tình trạng hết dung lượng ổ đĩa, một yếu tố quan trọng cho sự ổn định chung.

Khi thiết lập giới hạn, Page Cache HTML sẽ hoạt động trong một khuôn khổ dung lượng được kiểm soát. Hệ thống sẽ tự động quản lý kích thước của nó, đảm bảo cache vẫn mang lại lợi ích về tốc độ mà không gây quá tải tài nguyên ổ cứng.
```

---

## T.Lập CloudFlare CDN Cache API (`cloudflare-api-cdn-cache-thiet-lap`)

- **Danh mục:** Quản lý Cache
- **Vị trí menu:** Menu chính › 19. Quản lý Cache › 12. T.Lập CloudFlare CDN Cache API  _(bấm lần lượt: 19 → 12)_
- **Tệp nguồn:** `/etc/wptt/cache/cloudflare-api-cdn-cache-thiet-lap`

```text
Việc sử dụng API của Cloudflare để xóa cache [bộ nhớ đệm] CDN là một tính năng mạnh mẽ và linh hoạt, cho phép bạn tự động hóa và kiểm soát chính xác việc làm mới nội dung trên mạng lưới của Cloudflare.

Dưới đây là giới thiệu về tính năng này:

Tại sao cần xóa cache CDN qua API?

Khi bạn cập nhật nội dung trên máy chủ gốc [origin server], Cloudflare CDN có thể vẫn đang phục vụ phiên bản cũ của nội dung đó từ các máy chủ biên của họ để tăng tốc độ tải trang cho người dùng. Việc xóa cache sẽ buộc Cloudflare lấy phiên bản mới nhất từ máy chủ gốc của bạn.

Sử dụng API cho phép bạn:
* Tự động hóa: Tích hợp việc xóa cache vào quy trình triển khai [deployment pipeline] của bạn. Ví dụ, sau khi cập nhật mã nguồn hoặc nội dung, một script có thể tự động gọi API để xóa cache liên quan.
* Kiểm soát chi tiết: Quản lý việc làm mới nội dung một cách chính xác, đảm bảo người dùng luôn thấy được phiên bản mới nhất khi cần thiết.
* Tích hợp với các hệ thống khác: Kết nối với hệ thống quản lý wptangtoc ols.

Bằng cách tận dụng API của Cloudflare, bạn có thể nâng cao đáng kể hiệu quả quản lý cache cho website của mình, đảm bảo nội dung luôn được cập nhật và trải nghiệm người dùng được tối ưu.
```

---

## Quản lý Disk (`wptt-disk-main`)

- **Danh mục:** Quản lý Disk
- **Vị trí menu:** Menu chính › 20. Quản lý Disk  _(bấm lần lượt: 20)_
- **Tệp nguồn:** `/etc/wptt/wptt-disk-main`

```text
Tính năng Quản lý Disk [Ổ đĩa] trong WPTangToc OLS là một công cụ tích hợp giúp người dùng theo dõi và quản lý dung lượng lưu trữ trên máy chủ một cách hiệu quả.

Giới thiệu ngắn gọn:
Mục đích: Cung cấp thông tin tổng quan về việc sử dụng ổ đĩa, giúp người dùng sớm phát hiện tình trạng đầy ổ cứng và thực hiện các hành động dọn dẹp cần thiết để đảm bảo máy chủ hoạt động ổn định.

Cách hoạt động:
* Hiển thị dung lượng: Hiển thị thông tin về tổng dung lượng, dung lượng đã sử dụng và dung lượng còn trống của ổ đĩa hoặc các phân vùng chính.
* Phân tích sử dụng [có thể]: Một số phiên bản có thể cung cấp thông tin chi tiết hơn về dung lượng sử dụng bởi các thư mục cụ thể [ví dụ: thư mục website, backups, logs].
* Công cụ dọn dẹp cơ bản [có thể]: Có thể bao gồm các tùy chọn để dọn dẹp các tệp tin tạm, logs cũ, hoặc các bản sao lưu không cần thiết do WPTangToc OLS tạo ra.

Lợi ích:
* Theo dõi dễ dàng: Nhanh chóng nắm bắt tình trạng sử dụng ổ đĩa mà không cần dùng lệnh Linux phức tạp.
* Phòng ngừa sự cố: Giúp tránh tình trạng máy chủ ngừng hoạt động do hết dung lượng lưu trữ.
* Tối ưu hóa dung lượng: Hỗ trợ giải phóng không gian ổ đĩa bằng cách loại bỏ các tệp không cần thiết.
Tính năng này giúp người dùng WPTangToc OLS chủ động hơn trong việc quản lý tài nguyên ổ đĩa, đảm bảo hiệu suất và sự ổn định cho máy chủ.
```

---

## Kiểm tra dung lượng website (`wptt-disk-website`)

- **Danh mục:** Quản lý Disk
- **Vị trí menu:** Menu chính › 20. Quản lý Disk › 1. Kiểm tra dung lượng website  _(bấm lần lượt: 20 → 1)_
- **Tệp nguồn:** `/etc/wptt/disk/wptt-disk-website`

```text
Tính năng Kiểm tra dung lượng mã nguồn website trong WPTangToc OLS là một công cụ cho phép bạn xác định tổng kích thước [dung lượng ổ cứng] mà các tệp và thư mục của một website cụ thể đang chiếm dụng trên máy chủ.

🎯 Mục đích chính của tính năng này:
* Quản lý Tài nguyên Ổ cứng: Giúp bạn theo dõi xem mỗi website đang sử dụng bao nhiêu dung lượng, đặc biệt quan trọng nếu bạn có giới hạn về ổ cứng hoặc quản lý nhiều website trên cùng một máy chủ.
* Phát hiện Thành phần Lớn: Có thể giúp bạn nhận biết nếu một website có dung lượng mã nguồn bất thường, có thể do themes/plugins nặng, hoặc các tệp không cần thiết.
* Hỗ trợ Tối ưu hóa: Là bước đầu để xem xét việc dọn dẹp, xóa bỏ các tệp, themes, plugins không sử dụng nhằm giải phóng không gian.
* Lập kế hoạch Sao lưu/Di chuyển: Biết được dung lượng mã nguồn giúp ước tính thời gian và không gian cần thiết cho việc sao lưu hoặc di chuyển website.

Tóm lại, tính năng này trong WPTangToc OLS cung cấp một cách nhanh chóng và tiện lợi để bạn kiểm soát dung lượng mà phần mã nguồn của các website đang chiếm dụng trên máy chủ, hỗ trợ việc quản lý và tối ưu hóa tài nguyên hiệu quả.
```

---

## Kiểm tra dung lượng file lớn nhất (`wptt-larg-file-all-dung-luong-lon`)

- **Danh mục:** Quản lý Disk
- **Vị trí menu:** Menu chính › 20. Quản lý Disk › 2. Kiểm tra dung lượng file lớn nhất  _(bấm lần lượt: 20 → 2)_
- **Tệp nguồn:** `/etc/wptt/disk/wptt-larg-file-all-dung-luong-lon`

```text
Việc kiểm tra dung lượng các file lớn nhất trong Linux là một tác vụ quản trị hệ thống thiết yếu, giúp bạn xác định những tệp tin nào đang chiếm nhiều không gian nhất trên ổ cứng của máy chủ.

🎯 Mục đích chính:
* Giải phóng Dung lượng Ổ cứng: Khi ổ cứng đầy, việc tìm và xử lý các file lớn không cần thiết [như log cũ, backup lỗi thời, file tạm dung lượng lớn] là cách nhanh nhất để lấy lại không gian.
* Quản lý Tài nguyên Hiệu quả: Giúp bạn hiểu rõ hơn về việc sử dụng ổ đĩa, từ đó có kế hoạch lưu trữ và dọn dẹp hợp lý.
* Phát hiện Bất thường: Đôi khi, các file lớn bất thường có thể là dấu hiệu của một lỗi ứng dụng [ví dụ: file log ghi không kiểm soát] hoặc hoạt động không mong muốn.
* Hỗ trợ Tối ưu hóa: Biết được file nào lớn giúp đưa ra quyết định nên xóa, nén, hay di chuyển chúng sang nơi lưu trữ khác.

✨ Tại sao lại quan trọng?
* Trên một máy chủ web, đặc biệt là máy chủ được quản lý qua các script như WPTangToc OLS, việc ổ cứng bị đầy có thể dẫn đến website ngừng hoạt động, không thể tạo backup, hoặc các dịch vụ khác bị lỗi. Khả năng nhanh chóng tìm ra các thủ phạm chiếm dụng dung lượng là rất cần thiết.

Tóm lại, kiểm tra và xác định các file lớn nhất là một kỹ năng quản trị Linux cơ bản giúp duy trì sự ổn định và hiệu quả cho máy chủ của bạn.
```

---

## Kiểm tra dung lượng thư mục lớn nhất (`wptt-larg-thu-muc-all-dung-luong-lon`)

- **Danh mục:** Quản lý Disk
- **Vị trí menu:** Menu chính › 20. Quản lý Disk › 3. Kiểm tra dung lượng thư mục lớn nhất  _(bấm lần lượt: 20 → 3)_
- **Tệp nguồn:** `/etc/wptt/disk/wptt-larg-thu-muc-all-dung-luong-lon`

```text
Việc kiểm tra dung lượng các thư mục lớn nhất trong Linux là một tác vụ quản trị hệ thống quan trọng, giúp bạn nhanh chóng xác định những thư mục nào đang chiếm dụng nhiều không gian đĩa nhất trên máy chủ.

🎯 Mục đích chính:
* Xác định Nguồn Gốc Chiếm Dung Lượng: Khi ổ cứng gần đầy, việc này giúp bạn tìm ra các điểm nóng – những thư mục gốc rễ chứa nhiều dữ liệu nhất [ví dụ: thư mục backups, thư mục logs, thư mục chứa nhiều website, hoặc thư mục home của người dùng nào đó].
* Dọn dẹp Có Mục tiêu: Thay vì tìm từng file lẻ, việc xác định thư mục lớn cho phép bạn tập trung dọn dẹp hoặc tối ưu hóa không gian lưu trữ một cách hiệu quả hơn.
* Hiểu Cấu trúc Sử dụng Đĩa: Cung cấp cái nhìn tổng quan về cách dung lượng ổ cứng được phân bổ giữa các thư mục khác nhau.
* Bảo trì Hệ thống Định kỳ: Là một phần của việc kiểm tra sức khỏe máy chủ, giúp ngăn chặn tình trạng hết dung lượng đột ngột.

✨ Tại sao lại quan trọng?
Trên máy chủ, đặc biệt là máy chủ web được quản lý bằng các script như WPTangToc OLS, việc các thư mục [như thư mục chứa uploads, backups, hoặc logs] phình to không kiểm soát có thể nhanh chóng làm cạn kiệt dung lượng ổ cứng, ảnh hưởng đến hoạt động của website và các dịch vụ khác. Khả năng xác định nhanh các thư mục này là rất cần thiết.

Tóm lại, kiểm tra dung lượng thư mục lớn nhất là một kỹ năng quản trị Linux cơ bản giúp bạn duy trì sự ổn định và hiệu quả cho không gian lưu trữ của máy chủ.
```

---

## Kiểm tra dung lượng file lớn nhất của domain (`wptt-larg-file-website-dung-luong-lon`)

- **Danh mục:** Quản lý Disk
- **Vị trí menu:** Menu chính › 20. Quản lý Disk › 4. Kiểm tra dung lượng file lớn nhất của domain  _(bấm lần lượt: 20 → 4)_
- **Tệp nguồn:** `/etc/wptt/disk/wptt-larg-file-website-dung-luong-lon`

```text
Việc kiểm tra dung lượng các file lớn nhất trong mã nguồn website là một tác vụ quản trị hệ thống thiết yếu, giúp bạn xác định những tệp tin nào đang chiếm nhiều không gian nhất trên ổ cứng của máy chủ.

🎯 Mục đích chính:
* Giải phóng Dung lượng Ổ cứng: Khi ổ cứng đầy, việc tìm và xử lý các file lớn không cần thiết [như log cũ, backup lỗi thời, file tạm dung lượng lớn] là cách nhanh nhất để lấy lại không gian.
* Quản lý Tài nguyên Hiệu quả: Giúp bạn hiểu rõ hơn về việc sử dụng ổ đĩa, từ đó có kế hoạch lưu trữ và dọn dẹp hợp lý.
* Phát hiện Bất thường: Đôi khi, các file lớn bất thường có thể là dấu hiệu của một lỗi ứng dụng [ví dụ: file log ghi không kiểm soát] hoặc hoạt động không mong muốn.
* Hỗ trợ Tối ưu hóa: Biết được file nào lớn giúp đưa ra quyết định nên xóa, nén, hay di chuyển chúng sang nơi lưu trữ khác.

✨ Tại sao lại quan trọng?
* Trên một máy chủ web, đặc biệt là máy chủ được quản lý qua các script như WPTangToc OLS, việc ổ cứng bị đầy có thể dẫn đến website ngừng hoạt động, không thể tạo backup, hoặc các dịch vụ khác bị lỗi. Khả năng nhanh chóng tìm ra các thủ phạm chiếm dụng dung lượng là rất cần thiết.

Tóm lại, kiểm tra và xác định các file lớn nhất là một kỹ năng quản trị Linux cơ bản giúp duy trì sự ổn định và hiệu quả cho máy chủ của bạn.
```

---

## Kiểm tra dung lượng thư mục lớn nhất của domain (`wptt-larg-thu-muc-website-dung-luong-lon`)

- **Danh mục:** Quản lý Disk
- **Vị trí menu:** Menu chính › 20. Quản lý Disk › 5. Kiểm tra dung lượng thư mục lớn nhất của domain  _(bấm lần lượt: 20 → 5)_
- **Tệp nguồn:** `/etc/wptt/disk/wptt-larg-thu-muc-website-dung-luong-lon`

```text
Việc kiểm tra dung lượng các thư mục lớn nhất trong mã nguồn website là một tác vụ quản trị hệ thống quan trọng, giúp bạn nhanh chóng xác định những thư mục nào đang chiếm dụng nhiều không gian đĩa nhất trên máy chủ.

🎯 Mục đích chính:
* Xác định Nguồn Gốc Chiếm Dung Lượng: Khi ổ cứng gần đầy, việc này giúp bạn tìm ra các điểm nóng – những thư mục gốc rễ chứa nhiều dữ liệu nhất [ví dụ: thư mục backups, thư mục logs, thư mục chứa nhiều website, hoặc thư mục home của người dùng nào đó].
* Dọn dẹp Có Mục tiêu: Thay vì tìm từng file lẻ, việc xác định thư mục lớn cho phép bạn tập trung dọn dẹp hoặc tối ưu hóa không gian lưu trữ một cách hiệu quả hơn.
* Hiểu Cấu trúc Sử dụng Đĩa: Cung cấp cái nhìn tổng quan về cách dung lượng ổ cứng được phân bổ giữa các thư mục khác nhau.
* Bảo trì Hệ thống Định kỳ: Là một phần của việc kiểm tra sức khỏe máy chủ, giúp ngăn chặn tình trạng hết dung lượng đột ngột.

✨ Tại sao lại quan trọng?
Trên máy chủ, đặc biệt là máy chủ web được quản lý bằng các script như WPTangToc OLS, việc các thư mục [như thư mục chứa uploads, backups, hoặc logs] phình to không kiểm soát có thể nhanh chóng làm cạn kiệt dung lượng ổ cứng, ảnh hưởng đến hoạt động của website và các dịch vụ khác. Khả năng xác định nhanh các thư mục này là rất cần thiết.

Tóm lại, kiểm tra dung lượng thư mục lớn nhất là một kỹ năng quản trị Linux cơ bản giúp bạn duy trì sự ổn định và hiệu quả cho không gian lưu trữ của máy chủ.
```

---

## Kiểm tra ổ cứng (DISK) (`wptt-kiem-tra-disk`)

- **Danh mục:** Quản lý Disk
- **Vị trí menu:** Menu chính › 20. Quản lý Disk › 6. Kiểm tra ổ cứng (DISK)  _(bấm lần lượt: 20 → 6)_
- **Vị trí menu:** Menu chính › 29. Quản lý tài nguyên server › 3. Kiểm tra ổ cứng (DISK)  _(bấm lần lượt: 29 → 3)_
- **Tệp nguồn:** `/etc/wptt/tai-nguyen-server/wptt-kiem-tra-disk`

```text
Tính năng Kiểm tra Ổ cứng (Disk Benchmark & Health Check) giúp đánh giá toàn diện tình trạng dung lượng, Inodes, cấu hình Filesystem và đo lường hiệu suất Đọc/Ghi thực tế (IOPS, Băng thông MB/s và Độ trễ Latency) của ổ cứng máy chủ.

Mục Đích Chính
* Phân loại chất lượng phần cứng VPS: Nhận diện chính xác ổ cứng đang dùng là NVMe Enterprise, SSD SATA hay HDD truyền thống.
* Chẩn đoán hiệu năng Database (MariaDB): Đo tốc độ truy xuất ngẫu nhiên 4K (4K Random IOPS & Latency) - chỉ số quyết định trực tiếp đến tốc độ truy vấn SQL của WordPress.
* Kiểm tra dung lượng & Inodes: Phát hiện sớm nguy cơ đầy ổ cứng hoặc cạn kiệt Inodes (số lượng file tối đa) gây sập dịch vụ.
* Kiểm tra tối ưu hóa Filesystem: Xác minh các cờ tăng tốc ổ cứng như noatime, I/O Scheduler đã được kích hoạt hay chưa.
```

---

## Kiểm tra thông số server (`wptt-kiemtra`)

- **Danh mục:** Kiểm tra thông số server
- **Vị trí menu:** Menu chính › 21. Kiểm tra thông số server  _(bấm lần lượt: 21)_
- **Tệp nguồn:** `/etc/wptt/wptt-kiemtra`

```text
Tính năng Thông tin Webserver trong WPTangToc OLS là một công cụ tiện ích cung cấp cho người quản trị cái nhìn tổng quan và nhanh chóng về các thông số kỹ thuật cũng như trạng thái hiện tại của máy chủ.
```

---

## Quản lý CSF (`csf-main`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 1. Quản lý CSF  _(bấm lần lượt: 22 → 1)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/csf-main`

```text
Tính năng quản lý CSF [ConfigServer Security & Firewall] trong WPTangToc OLS là một công cụ tích hợp giúp bạn dễ dàng cài đặt, cấu hình và điều khiển firewall CSF ngay từ giao diện hoặc dòng lệnh của WPTangToc OLS.

Nó đơn giản hóa việc bảo vệ máy chủ của bạn bằng cách cho phép thực hiện nhanh các tác vụ như:

* Cài đặt và gỡ bỏ CSF: Triển khai hoặc loại bỏ firewall một cách thuận tiện.
* Quản lý quy tắc IP: Dễ dàng cho phép [allow], chặn [deny/block], hoặc bỏ chặn [unblock] các địa chỉ IP, chặn IP theo quốc gia...
* Mở/Đóng cổng [Ports]: Cấu hình các cổng được phép hoặc bị chặn trên máy chủ.
* Kiểm soát dịch vụ CSF: Khởi động, dừng, hoặc khởi động lại dịch vụ firewall.
* Xem trạng thái và logs: Nhanh chóng kiểm tra tình trạng hoạt động của firewall và xem nhật ký liên quan.
* v.v.v
Về cơ bản, tính năng này giúp bạn quản lý một trong những firewall mạnh mẽ và phổ biến cho Linux một cách trực quan và hiệu quả hơn, tăng cường an ninh cho máy chủ của bạn.
```

---

## On/Off ModSecurity (`wptt-modsecurity`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 2. On/Off ModSecurity  _(bấm lần lượt: 22 → 2)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/wptt-modsecurity`

```text
Kích hoạt/Hủy kích hoạt Modsecurity.

ModSecurity là một tường lửa ứng dụng web [Web Application Firewall - WAF] mã nguồn mở, đa nền tảng, được sử dụng rộng rãi. Nó hoạt động như một module cho các máy chủ web như Apache, Nginx và IIS, LiteSpeed.

Mục đích chính của ModSecurity là bảo vệ các ứng dụng web khỏi một loạt các cuộc tấn công mạng, bao gồm:
* SQL Injection [SQLi]: Kẻ tấn công chèn mã SQL độc hại vào các truy vấn để thao túng cơ sở dữ liệu.
* Cross-Site Scripting [XSS]: Kẻ tấn công chèn mã độc JavaScript vào các trang web mà người dùng khác sẽ xem.
* Local File Inclusion [LFI] / Remote File Inclusion [RFI]: Kẻ tấn công lừa ứng dụng web thực thi hoặc hiển thị các tệp tin không mong muốn trên máy chủ hoặc từ xa.
* Session Hijacking: Kẻ tấn công chiếm đoạt phiên làm việc hợp lệ của người dùng.
* Command Injection: Kẻ tấn công thực thi các lệnh tùy ý trên hệ điều hành của máy chủ.
Và nhiều loại lỗ hổng và tấn công khác.

Ghi chú: Khi kích hoạt ModSecurity sẽ làm giảm khá khá hiệu suất tốc độ của website do máy chủ phải phân tích sâu từng gói tin.
```

---

## On/Off tường lửa 8G (`wptt-firewall-7g`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 3. On/Off tường lửa 8G  _(bấm lần lượt: 22 → 3)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/wptt-firewall-7g`

```text
Kích hoạt tường lửa 8G:

Tường lửa 8G giúp bảo vệ chống lại các mối đe dọa phổ biến:
* Nâng cao bảo mật cho WordPress.
* Bad Bots: Chặn các bot độc hại, trình thu thập dữ liệu rác.
* Malicious Requests: Ngăn chặn các yêu cầu chứa mã độc, dấu hiệu tấn công.
* SQL Injection [SQLi]: Các mẫu tấn công SQL phổ biến.
* Cross-Site Scripting [XSS]: Các mẫu tấn công XSS.
* Directory Traversal: Cố gắng truy cập vào các tệp hoặc thư mục không được phép.
* Remote File Inclusion [RFI] / Local File Inclusion [LFI]: Cố gắng chèn và thực thi tệp từ xa hoặc cục bộ.
* Spam Referrers: Chặn các referrer spam.

Ghi chú: Khi kích hoạt tường lửa 8G sẽ làm giảm một phần nhỏ hiệu suất tốc độ của website do máy chủ phải quét qua các quy tắc này.
```

---

## On/Off Litespeed đang bị DDOS (`mod-ddos-litespeed`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 4. On/Off Litespeed đang bị DDOS  _(bấm lần lượt: 22 → 4)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/mod-ddos-litespeed`

```text
WPTangToc OLS có tính năng chống DDoS LiteSpeed Web Server, thì đây là chức năng giúp bạn cấu hình và tận dụng các cơ chế bảo vệ tích hợp sẵn ngay bên trong máy chủ web OpenLiteSpeed [OLS] để chống lại các cuộc tấn công từ chối dịch vụ [DDoS] hoặc các truy cập quá mức.

Khác với Fail2ban [hoạt động bằng cách đọc log và chặn qua firewall], các tính năng này hoạt động trực tiếp tại tầng web server, thường tập trung vào việc giới hạn kết nối và yêu cầu [throttling].

Tính năng Chống DDoS Tích hợp của LiteSpeed Web Server
🛡️ Mục đích chính:
* Bảo vệ Máy chủ: Ngăn chặn các địa chỉ IP đơn lẻ hoặc các bot tạo ra quá nhiều kết nối hoặc yêu cầu, làm cạn kiệt tài nguyên máy chủ [CPU, RAM, connections].
* Duy trì Ổn định: Giúp website hoạt động ổn định hơn ngay cả khi có lượng truy cập cao hoặc đang bị tấn công ở mức độ nhỏ đến vừa.
* Phản ứng Nhanh: Vì là tính năng tích hợp, OLS có thể phản ứng rất nhanh với các thay đổi về lưu lượng truy cập.

✅ Lợi ích:
* Hiệu suất Cao: Xử lý ngay tại tầng web server, rất nhanh và hiệu quả.
* Tích hợp Sẵn: Không cần cài đặt thêm phần mềm bên ngoài.
* Kiểm soát Trực tiếp: Quản lý trực tiếp cách OLS xử lý các kết nối.

Tóm lại: Tính năng này trong WPTangToc OLS giúp bạn khai thác và quản lý các cơ chế phòng thủ DDoS tích hợp sẵn của OpenLiteSpeed, chủ yếu thông qua việc giới hạn kết nối và yêu cầu từ mỗi IP, tạo thêm một lớp bảo vệ quan trọng cho website của bạn.

Mode limit chống ddos LiteSpeed thiết lập như sau:
Nếu IP đó truy cập gọi file tính static 40 yêu cầu / giây sẽ bị chặn
Nếu IP đó truy cập gọi file tính động [html document] 3 yêu cầu / giây sẽ bị chặn
Nếu IP đó truy cập gọi file tính động [html document] quá 20 giây sẽ bị chặn
```

---

## On/Off chống DDOS IP (`wptt-chong-ddos-ip-thiet-lap`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 5. On/Off chống DDOS IP  _(bấm lần lượt: 22 → 5)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/wptt-chong-ddos-ip-thiet-lap`

```text
Tính năng Chống DDoS IP [Giám sát toàn cục] trong WPTangToc OLS

🛡️ Mục đích:
Đây là lá chắn bảo vệ cấp độ máy chủ. Fail2ban sẽ liên tục giám sát file log tổng của OpenLiteSpeed. Nó phát hiện những IP đang cố gắng rà quét lỗ hổng hoặc truy cập trái phép vào các khu vực bị cấm trên toàn bộ hệ thống máy chủ.

⚙️ Cơ chế hoạt động:
* Theo dõi mã lỗi HTTP 403 [Forbidden - Truy cập bị từ chối].
* Điều kiện Kích hoạt: Nếu một địa chỉ IP bị từ chối truy cập [nhận lỗi 403] 5 lần chỉ trong vòng 10 giây.
* Hành động: IP đó sẽ bị Tường lửa khóa ngay lập tức trên toàn bộ các cổng mạng.
* Thời gian khóa: 2 tiếng.
```

---

## On/Off chống DDOS website (`wptt-canh-bao-ddos-thiet-lap`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 6. On/Off chống DDOS website  _(bấm lần lượt: 22 → 6)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/wptt-canh-bao-ddos-thiet-lap`

```text
Tính năng Chống DDoS [WPTangToc OLS] sử dụng Fail2ban:
🛡️ Mục đích:
Tự động phát hiện và chặn các địa chỉ IP có dấu hiệu truy cập bất thường, đặc biệt là nhắm vào các nội dung động [dynamic content] - những nội dung tốn nhiều tài nguyên xử lý của máy chủ [như PHP, cơ sở dữ liệu].

⚙️ Quy tắc hoạt động cụ thể:
* Công cụ: Sử dụng Fail2ban, một phần mềm giám sát log và chặn IP.
* Điều kiện Kích hoạt [Trigger]: Nếu một địa chỉ IP thực hiện 20 yêu cầu [requests] đến các tệp tin động [html document] trong vòng 30 giây.
* Hành động [Action]: Ngay lập tức, Fail2ban sẽ ra lệnh cho tường lửa chặn [block] địa chỉ IP đó trong vòng 2 tiếng.

Bạn có thể dễ dàng Bật/Tắt tính năng này cho từng website hoặc tất cả website bằng 1 cú chạm.
```

---

## On/Off chống DDOS 404 (`bao-mat-ddos-404`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 7. On/Off chống DDOS 404  _(bấm lần lượt: 22 → 7)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/bao-mat-ddos-404`

```text
Tính năng Chống DDoS 404 trong WPTangToc OLS là một cơ chế phòng vệ giúp máy chủ OpenLiteSpeed của bạn đối phó với các cuộc tấn công từ chối dịch vụ phân tán [DDoS] ở mức độ đơn giản đến trung bình.

Mã lỗi HTTP 404 là một mã trạng thái HTTP trang không tồn tại tiêu chuẩn mà máy chủ web gửi lại cho trình duyệt [hoặc client] khi máy chủ hiểu yêu cầu của bạn.

Nói một cách đơn giản, máy chủ đang nói rằng: Tôi biết bạn muốn gì, nhưng bạn không có quyền truy cập vào tài nguyên đó.

Bằng cách theo dõi các địa chỉ IP bị trả về lỗi 404 là trang động, html không phải là những file static như css, js, png, jpg, woff...
Nếu trong vòng 15 giây mà IP đó yêu cầu và trả về 404 hơn tận 5 lần sẽ bị tạm khoá IP trong vòng 2 tiếng.
[Bản nâng cấp Enterprise: Tích hợp Ipset tốc độ cao, nhận diện HTTP/3 UDP và tối ưu pyinotify]
```

---

## On/Off chống DDOS tìm kiếm (`ddos-search`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 8. On/Off chống DDOS tìm kiếm  _(bấm lần lượt: 22 → 8)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/ddos-search`

```text
Nếu ai đó truy vấn cố tình spam tính năng search sẽ bị chặn lại.
Ví dụ tính năng search khi truy cập: https://domain.com?s=abc
cái query sting là s= thường là giá trị search tính năng của WordPress, hoặc một số nền tảng khác...
Nếu IP nào đó trong 15 giây mà yêu cầu 5 yêu cầu search thì IP sẽ bị khóa trong 2 tiếng.
```

---

## On/Off chống HTTP 403 website ALL (`wptt-ddos-403-bi-pham-block-http`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 9. On/Off chống HTTP 403 website ALL  _(bấm lần lượt: 22 → 9)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/wptt-ddos-403-bi-pham-block-http`

```text
Tính năng Chống DDoS 403 trong WPTangToc OLS là một cơ chế phòng vệ giúp máy chủ OpenLiteSpeed của bạn đối phó với các cuộc tấn công từ chối dịch vụ phân tán [DDoS] ở mức độ đơn giản đến trung bình.

Mã lỗi HTTP 403 Forbidden là một mã trạng thái HTTP tiêu chuẩn mà máy chủ web gửi lại cho trình duyệt [hoặc client] khi máy chủ hiểu yêu cầu của bạn, nhưng từ chối thực hiện yêu cầu đó.

Bằng cách theo dõi các địa chỉ IP bị trả về lỗi 403 Forbidden. Nếu trong vòng 10 giây mà IP đó yêu cầu và bị trả về 403 hơn 5 lần sẽ bị tạm khoá IP trong vòng 2 tiếng.
```

---

## On/Off chống bad bot (`wptt-block-bad-bot`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 10. On/Off chống bad bot  _(bấm lần lượt: 22 → 10)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/wptt-block-bad-bot`

```text
Tính năng Chống Bad Bots [Công cụ cào dữ liệu và Máy quét mã độc]
🛡️ Mục đích:
Các công cụ SEO [Ahrefs, Semrush, MJ12bot...]và các công cụ rà quét của Hacker [sqlmap, Nmap...] liên tục cào dữ liệu website của bạn với tốc độ hàng ngàn truy vấn mỗi phút. Chúng không mang lại khách hàng mà chỉ làm máy chủ cạn kiệt CPU, RAM và Băng thông.

⚙️ Cơ chế hoạt động:
Thay vì dựa vào file robots.txt [thứ mà các bot xấu luôn phớt lờ], tính năng này sử dụng Fail2ban để đọc trực tiếp trong file log.
* Danh sách đen bao gồm: Các bot SEO rác, Bot cào dữ liệu TQ/Nga, Công cụ rà quét lỗ hổng.
* Hành động: Bất kỳ IP nào sử dụng User-Agent nằm trong danh sách đen, CHỈ CẦN TRUY CẬP 1 LẦN DUY NHẤT sẽ bị Tường lửa Ipset khóa ngay lập tức.
* Thời gian khóa: 24 tiếng [86400 giây].
```

---

## On/Off chặn BOT AI Crawlers (`wptt-firewall-bot-ai`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 11. On/Off chặn BOT AI Crawlers  _(bấm lần lượt: 22 → 11)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/wptt-firewall-bot-ai`

```text
Tính năng Bật/Tắt Tường lửa Block AI Crawlers:

* Tiết kiệm tài nguyên: Các Bot AI quét dữ liệu rất hung hãn, gây tốn CPU và làm chậm website. Chặn chúng giúp server nhẹ gánh hơn.
* Bảo vệ bản quyền: Ngăn chặn các công ty AI lấy bài viết chất xám của bạn để huấn luyện miễn phí.
* Ưu tiên người dùng: Dành trọn băng thông cho khách truy cập thật và Google Bot [SEO].
* Hủy kích hoạt [Tắt]: Mở cửa cho phép các Bot AI [ChatGPT, Claude, CCBot...] truy cập lại website. Cần thiết nếu bạn muốn làm SEO cho các mô hình tìm kiếm AI [AI Search].

Đừng để AI xài chùa tài nguyên của bạn! Tính năng này sẽ đá bay các con bot của OpenAI, Anthropic,... ra khỏi server.
Bạn có thể dễ dàng Bật/Tắt bằng 1 cú chạm.
```

---

## On/Off Bẫy ruồi Honeypot (`wptt-bay-ruoi-honneypot`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 12. On/Off Bẫy ruồi Honeypot  _(bấm lần lượt: 22 → 12)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/wptt-bay-ruoi-honneypot`

```text
Tính năng Bẫy Ruồi Honeypot [Bắt Hacker từ trong trứng nước]
🛡️ Mục đích:
Hacker thường sử dụng các công cụ rà quét tự động để tìm kiếm các lỗ hổng lộ lọt thông tin nhạy cảm trước khi chính thức tấn công. Chúng sẽ dò tìm các file như biến môi trường [.env], cấu hình mã nguồn [.git], file backup cơ sở dữ liệu [db.sql], hay file debug [phpinfo.php].

⚙️ Cơ chế hoạt động:
* Người dùng bình thường không bao giờ truy cập vào các đường dẫn này.
* Nếu một địa chỉ IP cố tình truy vấn các đường dẫn nhạy cảm nằm trong "Danh sách Đen" của bẫy ruồi.
* Hành động: IP đó sẽ bị Tường lửa khóa ngay lập tức CHỈ VỚI 1 LẦN TRUY CẬP DUY NHẤT.
* Thời gian khóa: 24 tiếng [86400 giây] - Đánh chặn từ xa trước khi chúng kịp tìm ra lỗ hổng web.
```

---

## On/Off 2FA WordPress WP-Admin (`bao-mat-2lop`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 13. On/Off 2FA WordPress WP-Admin  _(bấm lần lượt: 22 → 13)_
- **Tệp nguồn:** `/etc/wptt/wordpress/bao-mat-2lop`

```text
Tính năng này thiết lập một lớp bảo mật thứ 2 [HTTP Basic Auth] khi truy cập vào wp-admin hoặc wp-login.php.

Tính năng Kích hoạt bảo mật 2 lớp đăng nhập WordPress [Two-Factor Authentication - 2FA] là việc thiết lập một lớp bảo vệ bổ sung cho quá trình đăng nhập vào trang quản trị WordPress, yêu cầu người dùng phải qua một lớp xác thực của máy chủ trước khi vào tới màn hình đăng nhập của WordPress.

Mục Đích Chính [Cực Kỳ Quan Trọng]:
* Tăng cường bảo mật mạnh mẽ: Ngay cả khi hacker có mật khẩu WordPress của bạn, họ cũng không thể truy cập nếu không qua được lớp khiên này.
* Chống tấn công Brute-Force [dò mật khẩu]: Chặn đứng mọi bot quét tự động ngay từ tầng Server [OpenLiteSpeed], giúp tiết kiệm tài nguyên CPU tuyệt đối.
* Bảo vệ tài khoản quản trị [Admin]: Một rào chắn vững chắc cho các website đặc biệt quan trọng.

Bạn có thể dễ dàng Bật/Tắt tính năng này tùy theo nhu cầu vận hành thực tế.
```

---

## Xem lại tài khoản 2FA (`wptt-kiem-tra-tai-khoan-bao-mat-2lop`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 14. Xem lại tài khoản 2FA  _(bấm lần lượt: 22 → 14)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/wptt-kiem-tra-tai-khoan-bao-mat-2lop`

```text
Chức năng xem lại thông tin tài khoản bảo mật 2 lớp trong WordPress cho phép người dùng kiểm tra và quản lý các thiết lập bảo mật đã được kích hoạt. Điều này các phương thức xác thực hai yếu tố khác nhau. Sử dụng chức năng này, bạn có thể đảm bảo rằng thông tin tài khoản của mình luôn an toàn.
```

---

## On/Off chống Brute Force WP (`wptt-admin-bao-mat`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 15. On/Off chống Brute Force WP  _(bấm lần lượt: 22 → 15)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/wptt-admin-bao-mat`

```text
Đây là một tính năng bảo mật rất hữu ích nhằm chống lại các cuộc tấn công Brute Force [dò mật khẩu] vào trang quản trị wp-admin của website WordPress.

Giới thiệu ngắn gọn tính năng:
Tính năng này hoạt động bằng cách theo dõi số lần đăng nhập sai liên tiếp từ một địa chỉ IP cụ thể. Cụ thể, nếu một địa chỉ IP:
* Nhập sai mật khẩu 3 lần
* Trong khoảng thời gian 5 phút
Thì địa chỉ IP đó sẽ tự động bị tạm khóa, không thể truy cập vào toàn bộ hệ thống trong vòng 2 tiếng.

Bạn có thể dễ dàng Bật hoặc Tắt tính năng này tùy theo nhu cầu:
* Kích hoạt [Bật]: Ngăn chặn bot tự động, bảo vệ tài khoản và giảm tải CPU cho máy chủ.
* Hủy kích hoạt [Tắt]: Dành cho các trường hợp bạn hoặc đối tác bị khóa IP nhầm và cần vào quản trị gấp, hoặc khi bạn dùng giải pháp Firewall khác.
```

---

## On/Off LockDown WordPress (`wptt-lock-down`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 16. On/Off LockDown WordPress  _(bấm lần lượt: 22 → 16)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/wptt-lock-down`

```text
Tính năng Lockdown WordPress [bảo mật] nó ám chỉ việc áp dụng một tập hợp các biện pháp và cấu hình bảo mật nghiêm ngặt nhằm khóa chặt và làm cứng [harden] website WordPress của bạn, giảm thiểu tối đa các bề mặt tấn công và nguy cơ bị xâm nhập.

Nói một cách đơn giản, lockdown là bạn triển khai nhiều lớp bảo vệ mạnh mẽ để niêm phong các khu vực nhạy cảm của website, khiến cho kẻ xấu khó có thể đột nhập hoặc gây hại. hoặc dù có đột nhập được nhưng không thể phá hoại được gì.

Mục Đích Chính
* Nâng cao bảo mật tối đa: Tạo ra một hàng rào phòng thủ vững chắc chống lại các cuộc tấn công dò mật khẩu, mã độc, và truy cập trái phép.
* Bảo vệ các khu vực quan trọng: Đặc biệt khóa các phần nhạy cảm như trang quản trị [wp-admin], [Plugin], [Themes] và các tệp tin cốt lõi [như wp-config.php].
* Giảm thiểu bề mặt tấn công: Hạn chế hoặc vô hiệu hóa các tính năng không cần thiết có thể bị lợi dụng.
* Phòng ngừa chủ động: Áp dụng các biện pháp mạnh mẽ để ngăn chặn tấn công thay vì chỉ phản ứng sau khi sự cố xảy ra.
Một website WordPress được lockdown sẽ có khả năng chống chịu tấn công tốt hơn nhiều, giảm thiểu rủi ro và mang lại sự an tâm hơn cho người quản trị.
```

---

## On/Off open_basedir PHP (`bat-tat-open-basedir`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 17. On/Off open_basedir PHP  _(bấm lần lượt: 22 → 17)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/bat-tat-open-basedir`

```text
Kích hoạt hoặc huỷ kích hoạt open_basedir để nâng cao bảo mật PHP để giảm thiểu tối đa việc 1 website bị hack, nó lây ra website còn lại.

open_basedir là đóng phân vùng hoạt động của PHP

Mục đích chính của open_basedir:

* Tăng cường bảo mật: Đây là mục đích cốt lõi. Bằng cách giới hạn phạm vi truy cập tệp tin, open_basedir giúp ngăn chặn các script PHP [đặc biệt là khi website bị tấn công hoặc chứa mã độc] truy cập, đọc hoặc ghi vào các tệp tin nhạy cảm nằm ngoài thư mục gốc của website đó. Điều này đặc biệt hữu ích trong môi trường hosting chia sẻ, nơi nhiều website cùng hoạt động trên một máy chủ. Nếu một website bị xâm nhập, open_basedir sẽ giúp hạn chế khả năng mã độc lây lan sang các website khác hoặc truy cập vào các tệp tin hệ thống của máy chủ.
* Kiểm soát môi trường thực thi của PHP: Nó giúp quản trị viên máy chủ định rõ những khu vực nào trên hệ thống tệp mà các kịch bản PHP được phép tương tác.

Thường anh em sử dụng plugin backup như duplicator hay backupbuddy sẽ bị lỗi.. nếu bạn không sử dụng plugin thì hãy nên bật tính năng này.
Ghi chú: khi bật có thể bị lỗi một số tính năng bạn vui lòng kiểm tra kỹ trước khi triển khai.
```

---

## On/Off hàm nguy hiểm của PHP (`bat-tat-ham-function-php-nguy-hiem`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 18. On/Off hàm nguy hiểm của PHP  _(bấm lần lượt: 22 → 18)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/bat-tat-ham-function-php-nguy-hiem`

```text
Kích hoạt hoặc huỷ kích hoạt chặn thực thi những hàm nguy hiểm về bảo mật PHP:
Kích hoạt hoặc huỷ kích hoạt chặn thực thi những hàm nguy hiểm về bảo mật PHP [Cấp độ Toàn Cục]:

Chặn các hàm PHP như exec, system, passthru, shell_exec, dl, show_source, và các hàm posix_* khác là một biện pháp bảo mật quan trọng trên máy chủ web. Việc này giúp ngăn chặn các cuộc tấn công tiềm ẩn, đặc biệt khi chạy các ứng dụng PHP có thể chứa lỗ hổng.

Gồm những hàm: exec,system,passthru,shell_exec,dl,show_source,posix_kill,posix_mkfifo,posix_getpwuid,posix_setpgid,posix_setsid,posix_setuid,posix_setgid,posix_seteuid,posix_setegid,posix_uname

Tại sao cần chặn các hàm này?
Các hàm bạn liệt kê có khả năng thực hiện những tác vụ nhạy cảm, có thể bị lạm dụng nếu mã PHP bị xâm nhập hoặc chứa lỗ hổng:

Thực thi lệnh hệ thống:
* exec[], system[], passthru[], shell_exec[]: Cho phép PHP chạy các lệnh trực tiếp trên hệ điều hành của máy chủ. Nếu kẻ tấn công kiểm soát được đầu vào của các hàm này, họ có thể thực thi mã độc, chiếm quyền kiểm soát máy chủ.
* Tải thư viện động và hiển thị mã nguồn:
* dl[]: Cho phép tải các phần mở rộng PHP động trong lúc chạy. Kẻ tấn công có thể dùng nó để tải mã độc. [Hàm này thường bị vô hiệu hóa mặc định ở các phiên bản PHP mới hơn].
* show_source[] [còn gọi là highlight_file[]]: Hiển thị mã nguồn của một tệp PHP. Kẻ tấn công có thể lợi dụng để xem mã nguồn, tìm kiếm lỗ hổng.
* Quản lý tiến trình và thông tin POSIX:
* Các hàm posix_* [như posix_kill, posix_setuid, posix_getpwuid, posix_uname]: Cung cấp khả năng tương tác sâu với hệ điều hành dựa trên POSIX, bao gồm việc kết thúc tiến trình, thay đổi quyền sở hữu của tiến trình, hoặc thu thập thông tin chi tiết về hệ thống và người dùng. Việc lạm dụng các hàm này có thể dẫn đến leo thang đặc quyền hoặc phá hoại hệ thống.

Tác động
* Tăng cường bảo mật: Giảm đáng kể nguy cơ máy chủ bị tấn công qua các lỗ hổng trong mã PHP hoặc khi kẻ tấn công tìm cách thực thi mã tùy ý.
* Có thể ảnh hưởng đến một số ứng dụng: Một số plugin, theme hoặc ứng dụng PHP hợp lệ có thể sử dụng các hàm này cho các chức năng cụ thể [ví dụ: một số plugin backup có thể dùng shell_exec]. Nếu bạn chặn chúng, các ứng dụng đó có thể không hoạt động đúng cách. Trong trường hợp này, bạn cần cân nhắc kỹ giữa bảo mật và tính năng, hoặc tìm giải pháp thay thế an toàn hơn.

Ghi chú: khi bật có thể bị lỗi một số tính năng bạn vui lòng kiểm tra kỹ trước khi triển khai.
```

---

## On/Off Hotlinking (`wptt-hotlinking`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 19. On/Off Hotlinking  _(bấm lần lượt: 22 → 19)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/wptt-hotlinking`

```text
1. Tính Năng Bật Chống Hotlinking
Hotlinking [trộm băng thông] là hành động trang web khác dùng trực tiếp link ảnh/tài nguyên trên máy chủ của bạn để hiển thị trên trang của họ.
Khi BẬT tính năng này:
* Bảo vệ băng thông và tài nguyên CPU/RAM của máy chủ.
* Các domain ngoài [trừ google, bing, facebook, zalo...] khi gọi file tĩnh sẽ bị trả về mã lỗi 403 Forbidden.

2. Tính Năng Tắt [Hủy] Chống Hotlinking
Là việc gỡ bỏ cấu hình chặn, đưa website về trạng thái mở hoàn toàn.
Mục đích chính:
* Khi bạn muốn chia sẻ tài nguyên cho các trang vệ tinh, đối tác.
* Khi bạn sử dụng các dịch vụ CDN yêu cầu máy chủ gốc phải mở cửa hoàn toàn để pull ảnh.
```

---

## Thêm domain bypass Hotlinking (`add-domain-hotlinking`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 20. Thêm domain bypass Hotlinking  _(bấm lần lượt: 22 → 20)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/add-domain-hotlinking`

```text
Tính năng bypass domain vượt qua Hotlinking là một công cụ hữu ích để cân bằng giữa việc bảo vệ tài nguyên máy chủ khỏi bị lạm dụng băng thông và việc cho phép các bên được ủy quyền truy cập và sử dụng các tài nguyên đó một cách hợp pháp. Nó tăng cường khả năng kiểm soát của bạn đối với cách nội dung của bạn được chia sẻ và sử dụng trên internet.
```

---

## Quét bảo mật, virus website (Yara) (`wptt-scan-virus`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 21. Quét bảo mật, virus website (Yara)  _(bấm lần lượt: 22 → 21)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/wptt-scan-virus`

```text
YARA Engine
Đây là hệ thống rà quét mã độc cực kỳ tối ưu và thông minh dành riêng cho WordPress.
Lợi ích khi sử dụng công cụ này so với các kiểu quét truyền thống:

* Quét siêu nhanh và không tốn RAM: Vì không cần chạy ngầm bất cứ tiến trình nào như ClamAV nên máy chủ của bạn sẽ luôn nhẹ nhàng, không bao giờ lo bị sập VPS do tốn tài nguyên.

* Không bao giờ làm chậm website: Hệ thống được thiết lập để tự động hạ độ ưu tiên xuống mức thấp nhất, tức là chỉ tận dụng CPU và ổ cứng khi máy chủ đang rảnh rỗi.

* Chính xác tuyệt đối và không báo nhầm: Nhờ kết hợp với WP-CLI để kiểm tra tính toàn vẹn của mã nguồn, hệ thống sẽ bỏ qua những file chuẩn sạch 100 phần trăm từ WordPress và chỉ tập trung vào các thư mục nghi ngờ hoặc file bị sửa đổi.
```

---

## Xóa phần mềm diệt virus (Yara) (`wptt-scan-virus-xoa-phan-mem`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 22. Xóa phần mềm diệt virus (Yara)  _(bấm lần lượt: 22 → 22)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/wptt-scan-virus-xoa-phan-mem`

```text
Tính năng này giúp bạn gỡ bỏ hoàn toàn YARA Engine và các bộ luật [Rules] nhận diện mã độc khỏi hệ thống.
Dù YARA cực kỳ nhẹ và không chạy ngầm, nhưng nếu bạn không còn nhu cầu quét mã độc trên máy chủ, bạn có thể gỡ cài đặt để làm sạch hoàn toàn hệ thống.
```

---

## Thiết lập telegram chat (`wptt-telegram`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 23. Thiết lập telegram chat  _(bấm lần lượt: 22 → 23)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/wptt-telegram`

```text
Thiết lập telegram API để tiền để phục vụ các tính năng có cần sự trợ giúp của telegram API.
Như: thông báo login ssh, thông báo downtime website...
```

---

## Thiết lập cảnh báo login SSH (`thong-bao-login-ssh`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 24. Thiết lập cảnh báo login SSH  _(bấm lần lượt: 22 → 24)_
- **Vị trí menu:** Menu chính › 9. Quản lý SSH/SFTP › 4. Thiết lập cảnh báo login SSH qua telegram  _(bấm lần lượt: 9 → 4)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/thong-bao-login-ssh`

```text
Tính năng thiết lập kích hoạt.
Nếu ai đó truy cập vào SSH của bạn, ngay lập tức nó sẽ thông báo qua telegram về thời gian đăng nhập, ip đăng nhập...
Để bạn dễ dàng kiểm soát hệ thống
```

---

## Tiêu chuẩn bảo mật CIS (`wptt-cis`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 25. Tiêu chuẩn bảo mật CIS  _(bấm lần lượt: 22 → 25)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/wptt-cis`

```text
Tính năng Kiểm Toán Bảo Mật Server [dựa theo CIS Benchmark - 15 Tiêu Chuẩn]

Hệ thống sẽ rà soát 15 tiêu chuẩn quốc tế ở tầng OS &
Kernel:
* File System: Quyền truy cập file nhạy cảm [/etc/passwd, /etc/shadow].
* Kernel Network: Chống DDoS SYN, Spoofing, Smurf Attack, MITM, Source Route.
* Kernel Memory: Khóa Core Dumps [Chống lộ RAM], Bật ASLR [Chống Buffer Overflow].
* SSH Hardening: Khóa X11, Siết số lần thử Pass, Khóa mật khẩu rỗng.

Sử dụng Auto-Fix để hệ thống tự động đổ bê tông Server của bạn trong 1 nốt nhạc.
```

---

## On/Off Bảo Mật HSTS (`hsts`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 26. On/Off Bảo Mật HSTS  _(bấm lần lượt: 22 → 26)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/hsts`

```text
Kích hoạt bảo mật HSTS (HTTP Strict Transport Security):

HSTS giúp bảo vệ kết nối HTTPS của website khỏi các cuộc tấn công hạ cấp giao thức:
* Ép buộc trình duyệt chỉ kết nối tới website thông qua HTTPS an toàn.
* Chống tấn công SSL Stripping và Man-in-the-Middle (MitM).
* Tăng tốc độ tải trang cho lần truy cập sau (bỏ qua bước chuyển hướng 301 từ HTTP sang HTTPS).
* Đạt điểm A+ trên các công cụ đánh giá bảo mật SSL Labs.

Ghi chú: Chỉ nên bật HSTS khi website và các tên miền phụ (Subdomain) đã được cài đặt chứng chỉ SSL hợp lệ.
```

---

## Bảo mật (`wptt-bao-mat-main`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật  _(bấm lần lượt: 22)_
- **Tệp nguồn:** `/etc/wptt/wptt-bao-mat-main`

```text
Tính năng quản lý Bảo mật của WPTangToc OLS là tập hợp các công cụ và cấu hình được tích hợp sẵn, giúp người dùng tăng cường khả năng phòng thủ cho máy chủ OpenLiteSpeed và các website được lưu trữ trên đó.

Giới thiệu ngắn gọn:
Mục đích: Bảo vệ máy chủ và website khỏi các mối đe dọa trực tuyến phổ biến, giảm thiểu rủi ro bị tấn công, xâm nhập và mất dữ liệu.

Cách hoạt động:
* Chống tấn công Brute-force: Có thể tích hợp các công cụ hoặc cấu hình để phát hiện và chặn các cuộc tấn công dò mật khẩu.
* Tích hợp Web Application Firewall [WAF]: OpenLiteSpeed có WAF tích hợp [ví dụ ModSecurity], WPTangToc OLS có thể giúp kích hoạt và quản lý các bộ quy tắc cơ bản.
* Cấu hình Firewall: Thường tích hợp và đơn giản hóa việc cài đặt, cấu hình các firewall như CSF [ConfigServer Security &
Firewall] để kiểm soát truy cập vào/ra máy chủ.
* Quét mã độc [Malware Scanning]: Một số phiên bản [đặc biệt là Premium] có thể cung cấp hoặc hỗ trợ tích hợp công cụ quét mã độc cho website.
* Chống ddos cơ bản.
* v.v.v

Lợi ích:
* Tăng cường an ninh: Tạo lớp phòng thủ vững chắc hơn cho máy chủ và website.
* Phòng chống tấn công: Giảm thiểu nguy cơ từ các cuộc tấn công phổ biến.
* Bảo vệ dữ liệu: Góp phần bảo vệ thông tin nhạy cảm của website và người dùng.
* Đơn giản hóa: Giúp người dùng dễ dàng triển khai các biện pháp bảo mật mà không cần là chuyên gia.

Tính năng này giúp người dùng WPTangToc OLS chủ động hơn trong việc bảo vệ tài sản số của mình, đảm bảo môi trường vận hành website an toàn và ổn định.
```

---

## Kích hoạt CSF (`wptt-cai-dat-csf`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 1. Quản lý CSF › 1. Kích hoạt CSF  _(bấm lần lượt: 22 → 1 → 1)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/csf/wptt-cai-dat-csf`

```text
Tính năng Cài đặt CSF trong WPTangToc OLS cho phép bạn dễ dàng cài đặt và cấu hình ConfigServer Security &
Firewall [CSF], một bộ tường lửa và công cụ bảo mật mạnh mẽ và phổ biến cho máy chủ Linux.

🛡️ CSF là gì?
CSF là một tường lửa ứng dụng stateful [Stateful Packet Inspection - SPI], đi kèm với dịch vụ phát hiện đăng nhập thất bại/xâm nhập [Login Failure Daemon - LFD], và nhiều tính năng bảo mật khác. Nó giúp bảo vệ máy chủ của bạn khỏi nhiều loại tấn công phổ biến.

🎯 Mục đích của việc cài đặt CSF
* Tăng cường An ninh Vượt trội: Cung cấp một lớp bảo vệ mạnh mẽ hơn nhiều so với tường lửa mặc định của hệ điều hành. CSF giúp chống lại các cuộc tấn công như brute-force, quét cổng, và nhiều mối đe dọa khác.
* Cài đặt Đơn giản hóa: WPTangToc OLS tự động hóa quá trình tải về, cài đặt và có thể thực hiện một số cấu hình cơ bản ban đầu cho CSF, giúp bạn tiết kiệm thời gian và đảm bảo thiết lập đúng cách, phù hợp với môi trường OpenLiteSpeed.
* Quản lý Bảo mật Toàn diện: Sau khi cài đặt, CSF cungES cấp nhiều tùy chọn để bạn tinh chỉnh các quy tắc bảo mật, theo dõi hoạt động đáng ngờ, và chủ động bảo vệ máy chủ.

Lợi ích chính khi có CSF
* Bảo vệ chống tấn công brute-force vào SSH, FTP, email, WordPress [thông qua LFD].
* Theo dõi tiến trình đáng ngờ và chặn các kết nối không mong muốn.
* Dễ dàng chặn hoặc cho phép IP/dải IP.
* Thông báo qua email về các sự kiện bảo mật quan trọng.
Tóm lại, tính năng cài đặt CSF trong WPTangToc OLS là một công cụ cực kỳ hữu ích, giúp bạn nhanh chóng trang bị cho máy chủ OpenLiteSpeed của mình một trong những giải pháp tường lửa và bảo mật hàng đầu hiện nay, đảm bảo an toàn hơn cho website và dữ liệu của bạn.
```

---

## Huỷ kích hoạt CSF (`wptt-huy-cai-dat-csf`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 1. Quản lý CSF › 2. Huỷ kích hoạt CSF  _(bấm lần lượt: 22 → 1 → 2)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/csf/wptt-huy-cai-dat-csf`

```text
Tính năng Hủy cài đặt CSF [Uninstall CSF] trong WPTangToc OLS cho phép bạn gỡ bỏ hoàn toàn ConfigServer Security &
Firewall [CSF] và các thành phần liên quan [như Login Failure Daemon - LFD] ra khỏi máy chủ của mình.

🎯 Mục đích của việc hủy cài đặt CSF
Người dùng có thể muốn gỡ bỏ CSF vì một số lý do:
* Khắc phục sự cố: Nếu CSF bị nghi ngờ gây ra xung đột với các dịch vụ khác hoặc chặn nhầm các truy cập hợp lệ mà khó cấu hình lại.
* Chuyển đổi giải pháp tường lửa: Quyết định sử dụng một phần mềm tường lửa khác thay thế cho CSF.
* Đơn giản hóa hệ thống: Nếu không còn nhu cầu sử dụng các tính năng nâng cao của CSF hoặc cảm thấy nó quá phức tạp để quản lý.
* Dọn dẹp trước khi cài đặt lại: Muốn gỡ bỏ hoàn toàn phiên bản hiện tại để thực hiện cài đặt mới CSF.

Tóm lại, tính năng hủy cài đặt CSF trong WPTangToc OLS giúp bạn gỡ bỏ CSF một cách tương đối dễ dàng và sạch sẽ. Tuy nhiên, đây là một hành động cần cân nhắc kỹ lưỡng về mặt an ninh.
```

---

## Chặn quốc gia (`chan-ip-quoc-gia`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 1. Quản lý CSF › 3. Chặn quốc gia  _(bấm lần lượt: 22 → 1 → 3)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/csf/chan-ip-quoc-gia`

```text
Tính năng Thiết lập chặn quốc gia CSF trong WPTangToc OLS cho phép bạn sử dụng tường lửa ConfigServer Security & Firewall [CSF] để cấm hoàn toàn truy cập từ các vùng lãnh thổ cụ thể.

🌍 Cơ chế hoạt động
CSF sẽ tự động từ chối (Drop) tất cả các gói tin đến từ danh sách mã quốc gia (Country Code) mà bạn cấu hình trong biến CC_DENY.

🎯 Mục đích của việc áp dụng chính sách chặn quốc gia
* Giảm thiểu DDoS và Botnet: Chặn đứng các đợt tấn công dò quét mật khẩu, spam từ các quốc gia thường xuyên phát tán mã độc.
* Tối ưu tài nguyên: Loại bỏ truy cập từ các khu vực địa lý không nằm trong tệp khách hàng mục tiêu, giúp tiết kiệm băng thông và giảm tải cho máy chủ.
```

---

## Chỉ cho phép một số quốc gia được truy cập (`chan-ip-quoc-gia-chi-cho-phep`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 1. Quản lý CSF › 4. Chỉ cho phép một số quốc gia được truy cập  _(bấm lần lượt: 22 → 1 → 4)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/csf/chan-ip-quoc-gia-chi-cho-phep`

```text
Tính năng Thiết lập chặn hết quốc gia ngoại trừ quốc gia cụ thể được phép CSF trong WPTangToc OLS là một cấu hình bảo mật rất nghiêm ngặt của tường lửa ConfigServer Security &
Firewall [CSF]. Thay vì liệt kê các quốc gia bị cấm, bạn sẽ chỉ định một danh sách các quốc gia DUY NHẤT được phép truy cập vào máy chủ của mình
tất cả các quốc gia khác sẽ tự động bị chặn.

🌍 Cơ chế hoạt động
CSF sẽ chỉ chấp nhận kết nối từ các địa chỉ IP thuộc những quốc gia này và từ chối tất cả kết nối từ các quốc gia còn lại.

🎯 Mục đích của việc áp dụng chính sách chỉ cho phép
* Bảo mật Tối đa cho Đối tượng Mục tiêu Hẹp: Rất lý tưởng nếu website hoặc dịch vụ của bạn chỉ phục vụ người dùng ở một số ít quốc gia cụ thể.
* Kiểm soát Địa lý Nghiêm ngặt: Đảm bảo rằng chỉ người dùng từ các vùng địa lý được ủy quyền mới có thể truy cập dịch vụ.
* Giảm thiểu Tối đa Lưu lượng Rác: Chặn đứng phần lớn lưu lượng truy cập không mong muốn, spam, bot.

Ghi chú: Tính năng này luôn bypass những ip của google, cloudflare, bing sẽ không bao giờ bị chặn.

Tính năng này cung cấp mức độ kiểm soát truy cập địa lý cao nhất nhưng đòi hỏi sự hiểu biết và cẩn trọng tối đa.
```

---

## Hủy bỏ chặn quốc gia (`huy-bo-chan-ip-quoc-gia`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 1. Quản lý CSF › 5. Hủy bỏ chặn quốc gia  _(bấm lần lượt: 22 → 1 → 5)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/csf/huy-bo-chan-ip-quoc-gia`

```text
Tính năng Hủy thiết lập chặn hết quốc gia CSF trong WPTangToc OLS có mục đích là gỡ bỏ toàn bộ các cấu hình chặn truy cập dựa trên quốc gia đã được thiết lập trước đó trong tường lửa ConfigServer Security &
Firewall [CSF]. Sau khi thực hiện, CSF sẽ không còn áp dụng bất kỳ quy tắc nào để chặn hoặc chỉ cho phép truy cập từ các quốc gia cụ thể nữa.

🎯 Mục đích của việc hủy bỏ hoàn toàn việc chặn theo quốc gia
* Mở hoàn toàn truy cập địa lý: Cho phép tất cả các quốc gia truy cập vào máy chủ của bạn, gỡ bỏ mọi rào cản dựa trên vị trí địa lý đã cài đặt trước đó [dù là chặn một số nước hay chỉ cho phép một số nước].
* Đơn giản hóa tối đa cấu hình: Nếu bạn không còn muốn sử dụng cơ chế lọc theo quốc gia và muốn tường lửa hoạt động mà không có sự phân biệt này.
* Khắc phục sự cố phức tạp: Khi nghi ngờ các quy tắc chặn quốc gia [bất kể là CC_DENY hay CC_ALLOW] đang gây ra các vấn đề truy cập không mong muốn và khó xác định.
* Chuẩn bị cho chiến lược mới: Xóa sạch các cài đặt cũ để thiết lập một chiến lược kiểm soát truy cập hoàn toàn mới không dựa trên quốc gia

Tóm lại, tính năng Hủy thiết lập chặn hết quốc gia CSF trong WPTangToc OLS giúp bạn nhanh chóng đưa CSF về trạng thái không thực hiện bất kỳ việc lọc truy cập nào dựa trên quốc gia, cho phép mọi kết nối địa lý [trừ khi bị chặn bởi các quy tắc khác của CSF].
```

---

## Hủy bỏ chặn toàn bộ quốc gia chỉ được một số quốc gia cho phép (`huy-bo-chan-ip-quoc-gia-chi-cho-phep`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 1. Quản lý CSF › 6. Hủy bỏ chặn toàn bộ quốc gia chỉ được một số quốc gia cho phép  _(bấm lần lượt: 22 → 1 → 6)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/csf/huy-bo-chan-ip-quoc-gia-chi-cho-phep`

```text
Tính năng Hủy thiết lập chặn hết quốc gia ngoại trừ quốc gia cụ thể được phép CSF trong WPTangToc OLS là hành động gỡ bỏ cấu hình tường lửa CSF đang hoạt động ở chế độ chỉ cho phép một số quốc gia truy cập.

Sau khi hủy, máy chủ của bạn sẽ không còn tự động chặn tất cả các quốc gia không nằm trong danh sách được phép trước đó nữa.

🎯 Mục đích của việc hủy bỏ cấu hình nghiêm ngặt này
* Mở rộng phạm vi truy cập: Khi bạn muốn cho phép truy cập từ nhiều quốc gia hơn, không chỉ giới hạn trong danh sách whitelist đã thiết lập.
* Khắc phục sự cố chặn nhầm: Nếu cấu hình chỉ cho phép đang vô tình chặn các người dùng hợp lệ hoặc các dịch vụ quan trọng từ những quốc gia chưa được thêm vào danh sách.
* Thay đổi chiến lược kiểm soát truy cập: Quyết định chuyển sang một phương pháp ít hạn chế hơn, ví dụ như không chặn theo quốc gia nữa, hoặc chuyển sang sử dụng danh sách chặn cụ thể [CC_DENY] thay vì chỉ cho phép [CC_ALLOW].
* Đơn giản hóa lại cấu hình: Nếu việc duy trì danh sách chỉ cho phép trở nên phức tạp hoặc không còn cần thiết.

Tóm lại, tính năng này giúp bạn dễ dàng gỡ bỏ chính sách kiểm soát truy cập địa lý nghiêm ngặt chỉ cho phép một số quốc gia, mở cửa cho truy cập từ nhiều khu vực hơn, đồng thời vẫn giữ lại các lớp bảo vệ khác của tường lửa CSF.
```

---

## Bật chế độ chống DDOS (`mod-csf-chong-ddos`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 1. Quản lý CSF › 7. Bật chế độ chống DDOS  _(bấm lần lượt: 22 → 1 → 7)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/csf/mod-csf-chong-ddos`

```text
Tính năng Cài đặt chống DDoS CSF trong WPTangToc OLS là bước tiếp theo sau khi bạn đã cài đặt tường lửa CSF. Nó tập trung vào việc tinh chỉnh và kích hoạt các cấu hình chuyên biệt bên trong CSF để giúp máy chủ của bạn phòng chống các cuộc tấn công từ chối dịch vụ phân tán [DDoS] ở mức độ cơ bản đến trung bình.

🛡️ CSF và khả năng chống DDoS
Bản thân ConfigServer Security &
Firewall [CSF] đã tích hợp sẵn nhiều cơ chế để giảm thiểu tác động của các cuộc tấn công DDoS nhỏ và vừa, ví dụ:

SYN Flood Protection: Bảo vệ chống lại tấn công SYN flood.
Connection Limiting: Giới hạn số lượng kết nối đồng thời từ một địa chỉ IP đến các cổng dịch vụ.
Port Flood Protection: Chống lại việc một IP cố gắng mở quá nhiều kết nối đến một cổng cụ thể.
Packet Filtering: Lọc các gói tin đáng ngờ

✨ Lợi ích
Tiết kiệm thời gian và công sức: Không cần phải nghiên cứu sâu về từng tùy chọn của CSF.
Giảm thiểu rủi ro cấu hình sai: Script áp dụng các thiết lập đã được kiểm nghiệm hoặc khuyến nghị.
Nâng cao khả năng phòng thủ cơ bản: Giúp máy chủ cứng cáp hơn trước các hình thức tấn công DDoS phổ biến.
Lưu ý quan trọng: Tính năng này giúp cấu hình các biện pháp bảo vệ sẵn có trong CSF. Đối với các cuộc tấn công DDoS quy mô lớn và phức tạp, bạn vẫn cần các giải pháp chống DDoS chuyên nghiệp hơn hoặc từ nhà cung cấp dịch vụ.

Tóm lại, tính năng Cài đặt chống DDoS CSF trong WPTangToc OLS giúp bạn dễ dàng kích hoạt và tối ưu hóa các lớp phòng thủ tích hợp sẵn trong tường lửa CSF để đối phó hiệu quả hơn với các mối đe dọa DDoS ở mức độ nhất định.
```

---

## Tắt chế độ chống DDOS (`tat-mod-csf-chong-ddos`)

- **Danh mục:** Bảo mật
- **Vị trí menu:** Menu chính › 22. Bảo mật › 1. Quản lý CSF › 8. Tắt chế độ chống DDOS  _(bấm lần lượt: 22 → 1 → 8)_
- **Tệp nguồn:** `/etc/wptt/bao-mat/csf/tat-mod-csf-chong-ddos`

```text
Tính năng Hủy cài đặt chống DDoS CSF trong WPTangToc OLS là hành động nhằm đảo ngược hoặc gỡ bỏ các cấu hình chuyên biệt về chống DDoS đã được thiết lập cho tường lửa CSF trước đó [thường là thông qua chính WPTangToc OLS]. Điều quan trọng cần lưu ý là tính năng này thường không gỡ bỏ hoàn toàn tường lửa CSF mà chỉ đưa các cài đặt chống DDoS của nó về trạng thái mặc định hoặc ít nghiêm ngặt hơn.

🎯 Mục đích của việc hủy cài đặt chống DDoS CSF
* Khắc phục sự cố: Nếu các thiết lập chống DDoS quá nghiêm ngặt đang vô tình chặn các truy cập hợp lệ hoặc gây ra các vấn đề về hiệu suất không mong muốn.
* Quay về cấu hình CSF mặc định: Đưa các thông số liên quan đến chống DDoS trong CSF [như SYNFLOOD, CONNLIMIT, PORTFLOOD] trở lại giá trị gốc của CSF khi chưa được WPTangToc OLS tối ưu hóa cho chống DDoS.
* Điều chỉnh thủ công: Người dùng muốn tự mình tinh chỉnh các cài đặt chống DDoS theo ý muốn sau khi đã thử nghiệm các cấu hình tự động.
* Giảm bớt các hạn chế: Khi không còn ưu tiên cao việc chống DDoS ở mức độ đã cài đặt và muốn hệ thống thoáng hơn một chút.

Tóm lại, tính năng Hủy cài đặt chống DDoS CSF trong WPTangToc OLS cung cấp một cách để bạn dễ dàng quay lại trạng thái cấu hình ít nghiêm ngặt hơn cho các tính năng chống DDoS của tường lửa CSF, mà không cần phải gỡ bỏ hoàn toàn CSF.
```

---

## Cập nhật WPTangToc OLS (`wptt-update`)

- **Danh mục:** Cập nhật WPTangToc OLS
- **Vị trí menu:** Menu chính › 23. Cập nhật WPTangToc OLS  _(bấm lần lượt: 23)_
- **Vị trí menu:** Menu chính › 10. Quản lý cập nhật webserver › 1. Cập nhật WPTangToc OLS  _(bấm lần lượt: 10 → 1)_
- **Tệp nguồn:** `/etc/wptt/wptt-update`

```text
Tính năng cập nhật WPTangToc OLS là một chức năng quan trọng giúp người dùng dễ dàng nâng cấp script WPTangToc OLS lên phiên bản mới nhất.

Giới thiệu ngắn gọn:
Mục đích: Đảm bảo người dùng luôn được sử dụng phiên bản WPTangToc OLS mới nhất với các bản vá lỗi, cải tiến hiệu suất, tính năng mới và cập nhật bảo mật cũng như các thành phần liên quan.

wptangtoc ols tích hợp sẵn tính năng cập nhật trong menu tự động kiểm tra phiên bản mới nhất từ nguồn phát hành chính thức.
Người dùng chỉ cần chạy lệnh cập nhật đơn giản, wptangtoc ols sẽ tự động xử lý các bước cần thiết.

Lợi ích:
* An toàn và ổn định: Nhận các bản vá lỗi và cập nhật bảo mật mới nhất.
* Hiệu suất tối ưu: Hưởng lợi từ các cải tiến về tốc độ và tài nguyên.
* Tính năng mới: Trải nghiệm các công cụ và tùy chọn quản lý máy chủ mới được bổ sung.
* Tiện lợi: Quá trình cập nhật được tự động hóa, tiết kiệm thời gian và công sức.

Việc thường xuyên kiểm tra và thực hiện cập nhật WPTangToc OLS giúp máy chủ web của bạn hoạt động hiệu quả, an toàn và luôn được hỗ trợ tốt nhất.
```

---

## Quản lý PhpMyAdmin (`wptt-phpmyadmin-main`)

- **Danh mục:** Quản lý PhpMyAdmin
- **Vị trí menu:** Menu chính › 24. Quản lý PhpMyAdmin  _(bấm lần lượt: 24)_
- **Tệp nguồn:** `/etc/wptt/wptt-phpmyadmin-main`

```text
Tính năng Quản lý phpMyAdmin trong WPTangToc OLS là một công cụ giúp bạn dễ dàng cài đặt, gỡ bỏ và quản lý việc truy cập vào phpMyAdmin – một giao diện web phổ biến để quản trị cơ sở dữ liệu MySQL/MariaDB.

Giới thiệu ngắn gọn:

Mục đích: Cung cấp một cách thuận tiện để người dùng có thể tương tác với cơ sở dữ liệu của họ thông qua một giao diện đồ họa trực quan, thay vì chỉ sử dụng dòng lệnh. Điều này rất hữu ích cho việc xem, sửa, nhập/xuất dữ liệu, và quản lý cấu trúc database.
Cách hoạt động:
* Cài đặt/Gỡ bỏ phpMyAdmin: Cho phép bạn nhanh chóng cài đặt phpMyAdmin lên máy chủ hoặc gỡ bỏ nó nếu không còn nhu cầu sử dụng.
* Bảo mật truy cập: WPTangToc OLS có thể hỗ trợ thiết lập các biện pháp bảo mật cho phpMyAdmin, ví dụ như thay đổi đường dẫn truy cập mặc định hoặc cấu hình thêm lớp bảo vệ [như xác thực HTTP cơ bản] để hạn chế truy cập trái phép.
* Hiển thị thông tin truy cập: Cung cấp URL để bạn có thể truy cập vào giao diện phpMyAdmin sau khi cài đặt.

Lợi ích:
* Quản lý database trực quan: Dễ dàng thực hiện các thao tác phức tạp trên cơ sở dữ liệu mà không cần nhiều kiến thức về SQL.
* Tiện lợi: Cài đặt và cấu hình phpMyAdmin nhanh chóng thông qua WPTangToc OLS.
* Tăng cường bảo mật [nếu có hỗ trợ]: Giúp bảo vệ công cụ quản trị database quan trọng này khỏi các rủi ro an ninh.
Tính năng này làm cho việc quản trị cơ sở dữ liệu trên máy chủ của bạn trở nên đơn giản và dễ tiếp cận hơn.
```

---

## Kích hoạt PhpMyAdmin (`wptt-mo-phpmyadmin`)

- **Danh mục:** Quản lý PhpMyAdmin
- **Vị trí menu:** Menu chính › 24. Quản lý PhpMyAdmin › 1. Kích hoạt PhpMyAdmin  _(bấm lần lượt: 24 → 1)_
- **Tệp nguồn:** `/etc/wptt/phpmyadmin/wptt-mo-phpmyadmin`

```text
Tính năng Kích hoạt phpMyAdmin thường có nghĩa là truy cập và sử dụng công cụ phpMyAdmin, một ứng dụng web phổ biến để quản lý cơ sở dữ liệu MySQL hoặc MariaDB trực tiếp thông qua giao diện đồ họa trên trình duyệt.

Nói một cách đơn giản, đây là cách bạn mở một cánh cửa có giao diện thân thiện để làm việc với database của website mình, thay vì phải dùng các dòng lệnh phức tạp.

Mục Đích Chính [Chức năng của phpMyAdmin]
* Quản lý cơ sở dữ liệu [Database]: Tạo, xóa, sửa đổi database.
* Quản lý bảng [Table]: Tạo, sửa, xóa bảng quản lý cột, chỉ mục [index].
* Thao tác dữ liệu: Xem, tìm kiếm, thêm, sửa, xóa các hàng dữ liệu trong bảng.
* Thực thi lệnh SQL: Cho phép bạn chạy các truy vấn SQL tùy chỉnh.
* Import/Export dữ liệu: Nhập dữ liệu từ file [SQL, CSV] vào database hoặc xuất database/bảng ra các định dạng khác nhau [quan trọng cho việc sao lưu và di chuyển].
* Quản lý người dùng database: Tạo và quản lý quyền của người dùng truy cập database [nếu có đủ quyền].

Sau khi kích hoạt [truy cập], bạn có thể bắt đầu quản lý cơ sở dữ liệu của website một cách trực quan.
```

---

## Huỷ kích hoạt PhpMyAdmin (`wptt-xoa-phpmyadmin`)

- **Danh mục:** Quản lý PhpMyAdmin
- **Vị trí menu:** Menu chính › 24. Quản lý PhpMyAdmin › 2. Huỷ kích hoạt PhpMyAdmin  _(bấm lần lượt: 24 → 2)_
- **Tệp nguồn:** `/etc/wptt/phpmyadmin/wptt-xoa-phpmyadmin`

```text
Tính năng Xóa kích hoạt phpMyAdmin thường có nghĩa là một quản trị viên máy chủ hoặc nhà cung cấp hosting thực hiện các hành động để vô hiệu hóa hoặc hạn chế quyền truy cập vào công cụ quản lý cơ sở dữ liệu phpMyAdmin đối với người dùng hoặc trên toàn bộ hệ thống.

Nói một cách đơn giản, đây là việc đóng cửa hoặc khóa công cụ phpMyAdmin lại, khiến người dùng không thể sử dụng nó để truy cập và thao tác với cơ sở dữ liệu qua giao diện web nữa.

Mục Đích Chính
* Tăng cường bảo mật: phpMyAdmin là một công cụ mạnh mẽ, nếu không được bảo vệ cẩn thận [ví dụ, URL truy cập dễ đoán, tài khoản bị lộ], nó có thể trở thành mục tiêu tấn công. Vô hiệu hóa hoặc hạn chế truy cập là một biện pháp bảo mật.
* Giới hạn quyền của người dùng: Ngăn người dùng thao tác trực tiếp với database qua phpMyAdmin để tránh sai sót hoặc tuân thủ quy định quản lý.
* Khi không cần thiết: Nếu người dùng không có nhu cầu sử dụng hoặc quản lý database qua các công cụ khác, việc vô hiệu hóa phpMyAdmin giúp giảm thiểu bề mặt tấn công của server.
* Tuân thủ chính sách: Áp dụng các chính sách bảo mật hoặc giới hạn của gói dịch vụ.

Sau khi xóa kích hoạt, người dùng sẽ cần các phương thức khác [nếu được phép] như công cụ dòng lệnh hoặc các ứng dụng quản lý database trên máy tính để làm việc với cơ sở dữ liệu của họ.
```

---

## Cập nhật PhpMyAdmin (`wptt-update-phpmyadmin`)

- **Danh mục:** Quản lý PhpMyAdmin
- **Vị trí menu:** Menu chính › 24. Quản lý PhpMyAdmin › 3. Cập nhật PhpMyAdmin  _(bấm lần lượt: 24 → 3)_
- **Vị trí menu:** Menu chính › 10. Quản lý cập nhật webserver › 8. Cập nhật PhpMyAdmin  _(bấm lần lượt: 10 → 8)_
- **Tệp nguồn:** `/etc/wptt/update/wptt-update-phpmyadmin`

```text
Tính năng Cập nhật phpMyAdmin là quá trình nâng cấp phiên bản phần mềm phpMyAdmin [công cụ quản lý cơ sở dữ liệu MySQL/MariaDB qua giao diện web] mà bạn đang sử dụng lên một phiên bản mới hơn do nhà phát triển phát hành.

Nói một cách đơn giản, đây là việc bạn lên đời cho công cụ phpMyAdmin của mình để nó có những tính năng mới nhất, bản vá lỗi và quan trọng nhất là các cập nhật bảo mật.

Mục Đích Chính [Rất Quan Trọng]:
* Bảo mật [Quan trọng nhất]: Vá các lỗ hổng bảo mật được phát hiện trong phiên bản cũ.
* Tính năng mới và cải tiến: Giao diện người dùng được cải thiện, hiệu suất tốt hơn.
* Sửa lỗi [Bug Fixes]: Khắc phục các lỗi ổn định từ phiên bản trước.
* Đảm bảo tương thích: Tương thích tốt hơn với các phiên bản PHP và MySQL/MariaDB mới.

Sau khi cập nhật, cài đặt phpMyAdmin của bạn sẽ được nâng cấp lên phiên bản mới hơn, mang lại các cải tiến về bảo mật và tính năng.
```

---

## Xem thông tin tài khoản bảo mật PhpMyAdmin (`wptt-thongtin-phpmyadmin`)

- **Danh mục:** Quản lý PhpMyAdmin
- **Vị trí menu:** Menu chính › 24. Quản lý PhpMyAdmin › 4. Xem thông tin tài khoản bảo mật PhpMyAdmin  _(bấm lần lượt: 24 → 4)_
- **Tệp nguồn:** `/etc/wptt/phpmyadmin/wptt-thongtin-phpmyadmin`

```text
Tính năng Xem tài khoản đăng nhập phpMyAdmin là khả năng xem danh sách các tài khoản người dùng MySQL/MariaDB đã được tạo trên máy chủ, những tài khoản này có thể được sử dụng để đăng nhập vào phpMyAdmin và quản lý cơ sở dữ liệu và tài khoản bảo mật 2 lớp để truy cập vào trình PhpMyAdmin

Mục Đích Chính
* Quản lý người dùng database: Biết được danh sách các user đang có để quản lý quyền truy cập và bảo mật.
* Xác định user cho từng database: Khi có nhiều database, giúp bạn biết user nào được gán cho database nào.
* Kiểm tra bảo mật: Rà soát các user hiện có, xóa bỏ những user không cần thiết hoặc có quyền quá rộng.
* Gỡ lỗi kết nối: Nếu website không kết nối được database, việc kiểm tra lại username là một bước quan trọng.
* Chuẩn bị thông tin đăng nhập: Biết được username nào có sẵn để sử dụng khi phpMyAdmin yêu cầu đăng nhập.
```

---

## Thay đổi Tài khoản đăng nhập PhpMyAdmin (`wptt-phpmyadmin-doi-password`)

- **Danh mục:** Quản lý PhpMyAdmin
- **Vị trí menu:** Menu chính › 24. Quản lý PhpMyAdmin › 5. Thay đổi Tài khoản đăng nhập PhpMyAdmin  _(bấm lần lượt: 24 → 5)_
- **Tệp nguồn:** `/etc/wptt/phpmyadmin/wptt-phpmyadmin-doi-password`

```text
Tính năng Thay đổi tài khoản đăng nhập PhpMyAdmin cho phép bạn cập nhật thông tin xác thực [tài khoản, mật khẩu] được sử dụng để truy cập vào công cụ PhpMyAdmin

Nói một cách đơn giản, đây là cách bạn đổi mật khẩu hoặc thông tin đăng nhập khác để quản lý PhpMyAdmin, nhằm tăng cường bảo mật hoặc khi có sự thay đổi về người quản lý.

Mục Đích Chính
* Bảo mật: Cập nhật mật khẩu định kỳ, hoặc khi nghi ngờ thông tin đăng nhập cũ bị lộ.
* Khi có thay đổi người dùng: Nếu người khác tiếp quản việc quản lý file.
```

---

## Quản lý Swap (`wptt-swap-main`)

- **Danh mục:** Quản lý Swap
- **Vị trí menu:** Menu chính › 26. Quản lý Swap  _(bấm lần lượt: 26)_
- **Tệp nguồn:** `/etc/wptt/wptt-swap-main`

```text
Tính năng Quản lý swap Linux bao gồm một loạt các hành động và công cụ để bạn thiết lập, điều chỉnh, theo dõi và gỡ bỏ không gian swap [bộ nhớ ảo] trên hệ thống Linux của mình. 🧠⚙️

Nói một cách đơn giản, đây là việc bạn kiểm soát toàn bộ vòng đời của RAM ảo trên ổ cứng: từ việc tạo ra, cho nó hoạt động, xem nó đang được dùng bao nhiêu, tinh chỉnh cách nó được dùng, cho đến khi không cần nữa thì xóa đi.

Mục Đích Của Việc Quản Lý Swap
* Đảm bảo hiệu suất hệ thống: Tránh tình trạng hệ thống quá phụ thuộc vào swap [vì swap chậm hơn RAM nhiều], gây ì ạch.
* Duy trì sự ổn định: Cung cấp đủ bộ nhớ ảo để hệ thống không bị lỗi Out Of Memory khi tải nặng.
* Tối ưu hóa tài nguyên: Sử dụng không gian đĩa và tài nguyên hệ thống một cách hiệu quả.
* Linh hoạt điều chỉnh: Thay đổi cấu hình swap cho phù hợp với sự thay đổi về phần cứng [ví dụ: nâng cấp RAM] hoặc nhu cầu công việc.
Quản lý swap hiệu quả giúp cân bằng giữa việc có đủ bộ nhớ ảo để hệ thống ổn định và việc tránh lạm dụng swap gây ảnh hưởng đến hiệu suất chung.
```

---

## Thêm Swap (`wptt-tao-swap`)

- **Danh mục:** Quản lý Swap
- **Vị trí menu:** Menu chính › 26. Quản lý Swap › 1. Thêm Swap  _(bấm lần lượt: 26 → 1)_
- **Tệp nguồn:** `/etc/wptt/swap/wptt-tao-swap`

```text
Tính năng Tạo swap Linux là quá trình thiết lập một không gian trên ổ cứng [HDD hoặc SSD] để hệ điều hành Linux sử dụng như một bộ nhớ ảo [virtual memory] khi bộ nhớ vật lý [RAM] bị đầy.

Nói một cách đơn giản, khi RAM của bạn không còn đủ chỗ trống để chạy các ứng dụng, Linux sẽ chuyển những dữ liệu ít được sử dụng từ RAM sang không gian swap này trên ổ cứng. Điều này giúp hệ thống tiếp tục hoạt động thay vì bị treo hoặc báo lỗi hết bộ nhớ.

Mục Đích Chính
* Mở rộng bộ nhớ khả dụng: Cho phép hệ thống chạy được nhiều ứng dụng hơn hoặc xử lý các tác vụ nặng hơn so với chỉ dùng RAM vật lý.
* Tăng tính ổn định cho hệ thống: Giúp ngăn chặn tình trạng hệ thống bị sập hoặc không phản hồi khi RAM bị quá tải.
* Hỗ trợ chế độ ngủ đông [Hibernation]: Swap thường cần thiết để lưu trạng thái của hệ thống [nội dung RAM] vào ổ cứng khi máy tính vào chế độ ngủ đông, cho phép khôi phục nhanh chóng sau đó.
* Cải thiện hiệu suất [trong một số trường hợp]: Bằng cách chuyển dữ liệu ít dùng sang swap, RAM sẽ có thêm không gian cho các dữ liệu được truy cập thường xuyên hơn. Tuy nhiên, truy cập swap chậm hơn RAM rất nhiều.

Tạo swap là một kỹ thuật hữu ích để tăng cường khả năng xử lý của hệ thống Linux, đặc biệt khi tài nguyên RAM hạn chế.

Ghi chú: thêm swap nó chỉ là giải pháp tạm thời hoặc eo hẹp về ngân sách máy chủ RAM. Về lâu dài bảo đảm hiệu suất hãy nâng cấp ram thật. Tốc độ swap ổ cứng chậm hơn gấp 3000 lần so với RAM thật.
```

---

## Xóa Swap (`wptt-xoa-swap`)

- **Danh mục:** Quản lý Swap
- **Vị trí menu:** Menu chính › 26. Quản lý Swap › 2. Xóa Swap  _(bấm lần lượt: 26 → 2)_
- **Tệp nguồn:** `/etc/wptt/swap/wptt-xoa-swap`

```text
Tính năng Xóa swap Linux là quá trình vô hiệu hóa và loại bỏ không gian swap [bộ nhớ ảo] đã được thiết lập trước đó trên hệ thống Linux của bạn, cho dù đó là một phân vùng swap [swap partition] hay một tệp swap [swap file].

Nói một cách đơn giản, đây là hành động thu hồi lại phần ổ cứng đã được dùng làm RAM ảo. Sau khi xóa, hệ thống sẽ không còn sử dụng không gian đĩa đó để lưu trữ dữ liệu từ RAM khi RAM đầy nữa.

Mục Đích Chính
* Giải phóng dung lượng ổ đĩa: Nếu bạn cần không gian ổ cứng mà swap đang chiếm giữ cho các mục đích khác [lưu trữ tệp, mở rộng phân vùng khác].
* Cấu hình lại hệ thống: Khi thay đổi sơ đồ phân vùng ổ đĩa hoặc chuyển sang một thiết lập lưu trữ mới.
* Không còn nhu cầu sử dụng: Nếu hệ thống có đủ RAM và swap không được sử dụng đến, hoặc bạn không dùng tính năng ngủ đông [hibernation].
* Thay đổi vị trí/kích thước swap: Xóa swap cũ để tạo một swap mới ở vị trí khác hoặc với kích thước khác.
* Lo ngại về hiệu suất/tuổi thọ SSD [trong một số trường hợp]: Nếu hệ thống thường xuyên dùng swap trên ổ cứng chậm hoặc bạn muốn giảm thiểu ghi lên SSD, có thể cân nhắc xóa swap [nhưng cần đảm bảo đủ RAM].

Sau khi xóa swap thành công, không gian đĩa đó sẽ được giải phóng hoặc sẵn sàng cho mục đích sử dụng khác.
```

---

## Bật / Tắt ZRAM (`zram`)

- **Danh mục:** Quản lý Swap
- **Vị trí menu:** Menu chính › 26. Quản lý Swap › 3. Bật / Tắt ZRAM  _(bấm lần lượt: 26 → 3)_
- **Tệp nguồn:** `/etc/wptt/zram`

```text
1. Tính Năng Cài Đặt ZRAM [Install ZRAM Swap]
Cài đặt ZRAM là quá trình thiết lập một phân vùng Swap [bộ nhớ ảo] hoạt động hoàn toàn trên RAM vật lý, sử dụng thuật toán nén dữ liệu thời gian thực.

ZRAM là một công cụ chuẩn Enterprise giúp máy chủ:
* Tránh sập nguồn [OOM] khi bị quá tải RAM cục bộ.
* Tăng tốc độ đọc/ghi Swap lên gấp hàng nghìn lần so với Swap trên ổ cứng SSD/NVMe.
* Bảo vệ tuổi thọ ổ cứng vật lý do không còn phải ghi/xóa các file rác liên tục.
* Tự động điều chỉnh thông minh: Sử dụng 50% lượng RAM hiện có đối với máy chủ nhỏ, hoặc khóa trần ở mức tối đa 4GB đối với máy chủ lớn để bảo vệ CPU.
* Tự động dọn dẹp và xóa hoàn toàn Swap đĩa cũ để giải phóng dung lượng SSD.

Kết quả: Sau khi cài đặt, hệ thống sẽ có một ổ đĩa nén ZRAM [zram0] siêu tốc. Máy chủ sẽ lỳ lợm hơn khi chịu tải nặng.

2. Tính Năng Hủy Cài Đặt ZRAM [Uninstall ZRAM Swap]
Hủy cài đặt ZRAM là quá trình gỡ bỏ module nén bộ nhớ và trả lại không gian RAM vật lý cũng như trả lại cơ chế Swap đĩa truyền thống của Linux.

Mục đích chính:
* CPU của VPS quá yếu, không thể gánh được thuật toán nén.
* Máy chủ chuyên dụng cho Database [không dùng chung Web Server].

Kết quả: Dịch vụ ZRAM sẽ được dừng, xóa cấu hình và hệ thống sẽ tự động khởi tạo lại một Swap đĩa dung lượng 1GB [/var/swap.1] để đảm bảo an toàn cơ bản.
```

---

## Chuyển website bên ngoài về WPTangToc OLS (`wptt-chuyen-website`)

- **Danh mục:** Chuyển website
- **Vị trí menu:** Menu chính › 27. Chuyển website › 1. Chuyển website bên ngoài về WPTangToc OLS  _(bấm lần lượt: 27 → 1)_
- **Tệp nguồn:** `/etc/wptt/chuyen-web/wptt-chuyen-website`

```text
Tính năng này chuyển website ngoài [Cpanel,plesk,Cyperpanel, AApanel, Larpvs,HocVPs,VPSSim... hệ thống cũ có terminal là được] chuyển về wptangtoc ols

Tính năng Quản lý Chuyển Website [Website Migration] trong WPTangToc OLS là một tập hợp các công cụ và quy trình được thiết kế để giúp bạn di chuyển website [đặc biệt là WordPress] từ một nơi này sang nơi khác một cách dễ dàng và ít lỗi hơn. 🚚💨

Giới thiệu ngắn gọn:
Mục đích: Đơn giản hóa quá trình chuyển website giữa các máy chủ, từ nhà cung cấp này sang nhà cung cấp khác, hoặc từ môi trường phát triển [staging] lên máy chủ chính [production] và ngược lại.

Lợi ích:
* Giảm thiểu lỗi thủ công: Tự động hóa nhiều bước phức tạp trong quá trình di chuyển.
* Tiết kiệm thời gian: Tăng tốc độ di chuyển website so với việc làm thủ công hoàn toàn.
* Đảm bảo tính toàn vẹn: Giúp di chuyển đầy đủ cả tệp tin và cơ sở dữ liệu một cách nhất quán.
* Thuận tiện: Cung cấp một quy trình tích hợp ngay trong công cụ quản lý máy chủ quen thuộc.
```

---

## Chuyển tất cả website WPTangToc OLS về WPTangToc OLS Bằng Rsync (`rsync-move`)

- **Danh mục:** Chuyển website
- **Vị trí menu:** Menu chính › 27. Chuyển website › 2. Chuyển tất cả website WPTangToc OLS về WPTangToc OLS Bằng Rsync  _(bấm lần lượt: 27 → 2)_
- **Tệp nguồn:** `/etc/wptt/chuyen-web/rsync-move`

```text
rsync là một công cụ mạnh mẽ và linh hoạt dùng để đồng bộ hóa [synchronize] và truyền tải [transfer] file/thư mục giữa các máy tính/máy chủ. Khi nói về chuyển website rsync tự động hóa quá trình sao chép dữ liệu website từ một nơi này sang một nơi khác [ví dụ: từ server phát triển sang server sản phẩm, hoặc để sao lưu website].

Các tính năng nổi bật khi dùng rsync để chuyển website tự động:

Đồng bộ hóa thông minh: rsync chỉ sao chép những phần file đã thay đổi hoặc những file mới, giúp tiết kiệm băng thông và thời gian so với việc sao chép toàn bộ.
* Hiệu quả và Nhanh chóng: Nhờ thuật toán delta-transfer, rsync truyền dữ liệu rất hiệu quả.
* Bảo toàn thuộc tính file: rsync có thể giữ nguyên các thuộc tính của file như quyền truy cập, thời gian sửa đổi, v.v.
* Bảo mật: Có thể truyền dữ liệu qua các kênh mã hóa như SSH để đảm bảo an toàn.
* Nén dữ liệu: rsync hỗ trợ nén dữ liệu trong quá trình truyền để giảm dung lượng và tăng tốc độ.
* Linh hoạt: Nhiều tùy chọn cấu hình cho phép bạn tùy chỉnh quá trình đồng bộ hóa theo nhu cầu cụ thể.
Nói tóm lại, sử dụng rsync để tự động hóa việc chuyển website giúp đảm bảo dữ liệu luôn được cập nhật, tiết kiệm thời gian quản trị và giảm thiểu rủi ro lỗi do con người.
```

---

## Chuyển 1 website WPTangToc OLS về WPTangToc OLS Bằng Rsync (`rsync-move-only`)

- **Danh mục:** Chuyển website
- **Vị trí menu:** Menu chính › 27. Chuyển website › 3. Chuyển 1 website WPTangToc OLS về WPTangToc OLS Bằng Rsync  _(bấm lần lượt: 27 → 3)_
- **Tệp nguồn:** `/etc/wptt/chuyen-web/rsync-move-only`

```text
rsync là một công cụ mạnh mẽ và linh hoạt dùng để đồng bộ hóa [synchronize] và truyền tải [transfer] file/thư mục giữa các máy tính/máy chủ. Khi nói về chuyển website rsync tự động hóa quá trình sao chép dữ liệu website từ một nơi này sang một nơi khác [ví dụ: từ server phát triển sang server sản phẩm, hoặc để sao lưu website].

Tính năng này chỉ chuyển từ server nguồn đang dùng [wptangtoc ols] sang hệ thống đích cũng đang wptantoc ols
Bạn thực thi menu server nguồn bắt đầu sử dụng tính năng

Các tính năng nổi bật khi dùng rsync để chuyển website:

Đồng bộ hóa thông minh: rsync chỉ sao chép những phần file đã thay đổi hoặc những file mới, giúp tiết kiệm băng thông và thời gian so với việc sao chép toàn bộ.
* Hiệu quả và Nhanh chóng: Nhờ thuật toán delta-transfer, rsync truyền dữ liệu rất hiệu quả.
* Bảo toàn thuộc tính file: rsync có thể giữ nguyên các thuộc tính của file như quyền truy cập, thời gian sửa đổi, v.v.
* Bảo mật: Có thể truyền dữ liệu qua các kênh mã hóa như SSH để đảm bảo an toàn.
* Nén dữ liệu: rsync hỗ trợ nén dữ liệu trong quá trình truyền để giảm dung lượng và tăng tốc độ.
* Linh hoạt: Nhiều tùy chọn cấu hình cho phép bạn tùy chỉnh quá trình đồng bộ hóa theo nhu cầu cụ thể.
Nói tóm lại, sử dụng rsync để tự động hóa việc chuyển website giúp đảm bảo dữ liệu luôn được cập nhật, tiết kiệm thời gian quản trị và giảm thiểu rủi ro lỗi do con người. Rất phù hợp với mã nguồn lớn
```

---

## GET nhận website phương pháp rsync (`get-rsync-move`)

- **Danh mục:** Chuyển website
- **Vị trí menu:** Menu chính › 27. Chuyển website › 4. GET nhận website phương pháp rsync  _(bấm lần lượt: 27 → 4)_
- **Tệp nguồn:** `/etc/wptt/chuyen-web/get-rsync-move`

```text
Tính năng này là Trái tim của quá trình Chuyển nhà [Migration]. Nó chịu trách nhiệm giải nén và lắp ráp tự động các website vừa được Rsync đưa về máy chủ.

Hệ thống sẽ tự động thực hiện:
1. Nhận diện danh sách tên miền mới được chuyển về.
2. Khởi tạo không gian Web [Vhost] trên LiteSpeed.
3. Tự động tạo Database mới, User mới và bung [Import] file SQL siêu tốc.
4. Tự động kết nối lại file wp-config.php [WordPress] và phân quyền bảo mật.

LƯU Ý QUAN TRỌNG:
- Đảm bảo tiến trình Rsync dữ liệu từ máy chủ cũ đã chạy XONG HOÀN TOÀN trước khi kích hoạt lệnh này.
```

---

## Chuyển website (`wptt-chuyen-web-main`)

- **Danh mục:** Chuyển website
- **Vị trí menu:** Menu chính › 27. Chuyển website  _(bấm lần lượt: 27)_
- **Tệp nguồn:** `/etc/wptt/wptt-chuyen-web-main`

```text
Tính năng Quản lý Chuyển Website [Website Migration] trong WPTangToc OLS là một tập hợp các công cụ và quy trình được thiết kế để giúp bạn di chuyển website [đặc biệt là WordPress] từ một nơi này sang nơi khác một cách dễ dàng và ít lỗi hơn. 🚚💨

Giới thiệu ngắn gọn:
Mục đích: Đơn giản hóa quá trình chuyển website giữa các máy chủ, từ nhà cung cấp này sang nhà cung cấp khác, hoặc từ môi trường phát triển [staging] lên máy chủ chính [production] và ngược lại.

Lợi ích:
* Giảm thiểu lỗi thủ công: Tự động hóa nhiều bước phức tạp trong quá trình di chuyển.
* Tiết kiệm thời gian: Tăng tốc độ di chuyển website so với việc làm thủ công hoàn toàn.
* Đảm bảo tính toàn vẹn: Giúp di chuyển đầy đủ cả tệp tin và cơ sở dữ liệu một cách nhất quán.
* Thuận tiện: Cung cấp một quy trình tích hợp ngay trong công cụ quản lý máy chủ quen thuộc.
Tính năng này giúp quá trình chuyển nhà cho website của bạn trở nên mượt mà và ít căng thẳng hơn, đảm bảo website hoạt động ổn định trên môi trường mới.
```

---

## Quản lý File Manager (`wptt-quan-ly-files-main`)

- **Danh mục:** Quản lý File Manager
- **Vị trí menu:** Menu chính › 28. Quản lý File Manager  _(bấm lần lượt: 28)_
- **Tệp nguồn:** `/etc/wptt/wptt-quan-ly-files-main`

```text
WPTangToc OLS cung cấp tính năng quản lý file [File Manager], cho phép người dùng thực hiện các thao tác với tập tin và thư mục trực tiếp trên trình duyệt web.

Tính năng quản lý file này thường được tích hợp sẵn, dựa trên các giải pháp gọn nhẹ như Tiny File Manager. Nó giúp bạn:
* Duyệt, xem, tải lên [upload] và tải xuống [download] các tệp tin trong thư mục mã nguồn website của bạn.
* Tạo mới, xóa, đổi tên, sao chép, di chuyển các tệp tin và thư mục.
* Chỉnh sửa các tệp tin văn bản trực tiếp.
* Nén và giải nén các tệp tin [thường là định dạng .zip].

WPTangToc OLS quản lý filemanager:
* bật filemanager
* tắt filemanager
* thay đổi tài khoản filemanager
* xem lại tài khoản filemanager

Mặc dù tiện lợi cho các thao tác nhanh, quản lý file tích hợp trong WPTangToc OLS có thể tập trung chủ yếu vào việc quản lý mã nguồn website.

Tuy nhiên, đây là một công cụ hữu ích để quản lý website một cách trực quan mà không cần dùng đến các dòng lệnh phức tạp.
```

---

## Kích hoạt File Manager (`kich-hoat-quan-ly-files`)

- **Danh mục:** Quản lý File Manager
- **Vị trí menu:** Menu chính › 28. Quản lý File Manager › 1. Kích hoạt File Manager  _(bấm lần lượt: 28 → 1)_
- **Tệp nguồn:** `/etc/wptt/trinh-quan-ly-files/kich-hoat-quan-ly-files`

```text
Tính năng Kích hoạt File Manager [Trình quản lý tệp/tập tin] thường có nghĩa là truy cập và sử dụng một công cụ dựa trên giao diện web, cho phép bạn quản lý trực tiếp các tệp tin và thư mục của website trên máy chủ, tương tự như Windows Explorer trên máy tính của bạn.

Nói một cách đơn giản, đây là công cụ giúp bạn xem, tải lên, tải xuống, tạo mới, xóa, đổi tên, sửa đổi tệp tin, và thay đổi quyền truy cập [permissions] cho các tệp và thư mục của website ngay trong trình duyệt web mà không cần dùng phần mềm FTP riêng.

Mục Đích Chính
* Quản lý tệp tin dễ dàng: Cung cấp giao diện đồ họa trực quan để thao tác với file và thư mục trên server.
* Chỉnh sửa nhanh: Cho phép xem và sửa nhanh các tệp văn bản [HTML, CSS, PHP, file cấu hình] trực tiếp.
* Tải lên/Tải xuống: Dễ dàng đưa file website mới lên server hoặc tải về các file hiện có, backup.
* Quản lý quyền: Thay đổi quyền đọc/ghi/thực thi cho file và thư mục, rất quan trọng để website hoạt động đúng.
* Nén/Giải nén: Hỗ trợ tạo file nén [zip] hoặc giải nén các file đã tải lên.

Sau khi kích hoạt bạn có thể thực hiện các thao tác quản lý tệp tin cho website của mình một cách thuận tiện.
```

---

## Huỷ kích hoạt File Manager (`huy-kich-hoat-quan-ly-files`)

- **Danh mục:** Quản lý File Manager
- **Vị trí menu:** Menu chính › 28. Quản lý File Manager › 2. Huỷ kích hoạt File Manager  _(bấm lần lượt: 28 → 2)_
- **Tệp nguồn:** `/etc/wptt/trinh-quan-ly-files/huy-kich-hoat-quan-ly-files`

```text
Tính năng Xóa kích hoạt File Manager [Trình quản lý tệp/tập tin] thường có nghĩa là một quản trị viên máy chủ vô hiệu hóa hoặc thu hồi quyền truy cập vào công cụ File Manager dựa trên web đối với một website cụ thể.

Nói một cách đơn giản, nếu trước đó người dùng có thể sử dụng File Manager để quản lý tệp tin website qua trình duyệt, thì sau khi xóa kích hoạt, họ sẽ không còn truy cập được vào công cụ này nữa.

Mục Đích Chính [Thường Từ Phía Quản Trị Viên]
* Tăng cường bảo mật: Nếu một tài khoản người dùng bị nghi ngờ xâm phạm, việc vô hiệu hóa File Manager có thể là một biện pháp tạm thời để ngăn chặn các hành vi sửa đổi tệp tin trái phép.
* Giới hạn quyền của người dùng: Trong một số trường hợp, quản trị viên có thể muốn hạn chế người dùng truy cập trực tiếp vào hệ thống tệp để tránh những thay đổi không mong muốn hoặc sai sót. Người dùng có thể được yêu cầu sử dụng các phương thức khác như FTP/SFTP.
* Tuân thủ chính sách: Áp dụng các chính sách bảo mật hoặc giới hạn của gói dịch vụ.
* Gỡ lỗi [hiếm khi]: Nếu có nghi ngờ bản thân công cụ File Manager gây ra sự cố.

Sau khi xóa kích hoạt, người dùng sẽ cần sử dụng các phương thức khác [nếu được phép và đã cấu hình] như SFTP để quản lý tệp tin website của họ.
```

---

## Thay đổi ID & PassWord Bảo mật (`thay-doi-tai-khoan-password-quan-ly-files`)

- **Danh mục:** Quản lý File Manager
- **Vị trí menu:** Menu chính › 28. Quản lý File Manager › 3. Thay đổi ID & PassWord Bảo mật  _(bấm lần lượt: 28 → 3)_
- **Tệp nguồn:** `/etc/wptt/trinh-quan-ly-files/thay-doi-tai-khoan-password-quan-ly-files`

```text
Tính năng Thay đổi tài khoản đăng nhập File Manager cho phép bạn cập nhật thông tin xác thực [tài khoản, mật khẩu] được sử dụng để truy cập vào công cụ File Manager [Trình quản lý tệp]

Nói một cách đơn giản, đây là cách bạn đổi mật khẩu hoặc thông tin đăng nhập khác để quản lý file website, nhằm tăng cường bảo mật hoặc khi có sự thay đổi về người quản lý.

Mục Đích Chính
* Bảo mật: Cập nhật mật khẩu định kỳ, hoặc khi nghi ngờ thông tin đăng nhập cũ bị lộ.
* Khi có thay đổi người dùng: Nếu người khác tiếp quản việc quản lý file.
```

---

## Xem lại thông tin tài khoản (`xem-lai-thong-tin-quan-ly-files`)

- **Danh mục:** Quản lý File Manager
- **Vị trí menu:** Menu chính › 28. Quản lý File Manager › 4. Xem lại thông tin tài khoản  _(bấm lần lượt: 28 → 4)_
- **Tệp nguồn:** `/etc/wptt/trinh-quan-ly-files/xem-lai-thong-tin-quan-ly-files`

```text
Tính năng Xem lại tài khoản đăng nhập File Manager hệ thống của bạn đã thiết lập
```

---

## Quản lý tài nguyên server (`wptt-tai-nguyen-main`)

- **Danh mục:** Quản lý tài nguyên server
- **Vị trí menu:** Menu chính › 29. Quản lý tài nguyên server  _(bấm lần lượt: 29)_
- **Tệp nguồn:** `/etc/wptt/wptt-tai-nguyen-main`

```text
Tính năng Quản lý Tài nguyên trong WPTangToc OLS là một công cụ tích hợp giúp bạn theo dõi việc sử dụng các tài nguyên hệ thống quan trọng trên máy chủ của mình. 📊⚙️

Giới thiệu ngắn gọn:

Mục đích: Cung cấp cho người dùng cái nhìn tổng quan về mức độ sử dụng CPU, RAM [bộ nhớ], và có thể cả Disk I/O [hoạt động đọc/ghi của ổ đĩa] và Network I/O [lưu lượng mạng] theo thời gian thực hoặc gần thực. Điều này giúp xác định các điểm nghẽn tiềm ẩn hoặc tình trạng quá tải của máy chủ.

Lợi ích:
* Hiểu rõ hiệu suất máy chủ: Nắm bắt được tình trạng sức khỏe của server.
* Chẩn đoán sự cố: Hỗ trợ tìm ra nguyên nhân gây chậm hoặc treo máy chủ [ví dụ: một tiến trình chiếm quá nhiều CPU/RAM].
* Tối ưu hóa: Cung cấp thông tin để đưa ra quyết định nâng cấp tài nguyên hoặc tối ưu hóa ứng dụng/website.
* Sử dụng thuận tiện: Truy cập thông tin tài nguyên dễ dàng ngay trong WPTangToc OLS mà không cần nhiều lệnh phức tạp.
Tính năng này giúp bạn chủ động hơn trong việc giám sát và đảm bảo máy chủ luôn hoạt động trong điều kiện tốt nhất.
```

---

## Kích hoạt/Huỷ kích hoạt phần mềm thông kê (`install-tool-bang-thong-do-luong`)

- **Danh mục:** Quản lý tài nguyên server
- **Vị trí menu:** Menu chính › 29. Quản lý tài nguyên server › 7. Quản lý băng thông › 1. Kích hoạt/Huỷ kích hoạt phần mềm thông kê  _(bấm lần lượt: 29 → 7 → 1)_
- **Tệp nguồn:** `/etc/wptt/tai-nguyen-server/bang-thong/install-tool-bang-thong-do-luong`

```text
WPTangToc OLS có tính năng Kích hoạt / Hủy kích hoạt theo dõi băng thông, thì đây là một chức năng giúp bạn bật hoặc tắt việc máy chủ web OpenLiteSpeed [OLS] ghi lại và tính toán lượng dữ liệu [bandwidth] mà các website của bạn sử dụng.

🎯 Mục đích của tính năng:
Kích hoạt [Enable]:
* Giám sát Tài nguyên: Giúp bạn biết chính xác website nào đang sử dụng bao nhiêu băng thông. Điều này rất quan trọng để phát hiện các website tiêu tốn nhiều tài nguyên hoặc có lưu lượng truy cập đột biến.
* Quản lý Chi phí: Nếu gói VPS của bạn có giới hạn băng thông, việc theo dõi giúp bạn tránh vượt mức và phát sinh chi phí không mong muốn.
* Phân tích Lưu lượng: Dữ liệu băng thông cung cấp cái nhìn sâu hơn về hoạt động của website, ví dụ: các tệp tin lớn nào đang được tải nhiều.
* Lập kế hoạch Nâng cấp: Dựa vào xu hướng sử dụng băng thông để quyết định khi nào cần nâng cấp máy chủ hoặc gói hosting.

Hủy kích hoạt [Disable]:
* Giảm tải [Rất nhỏ]: Quá trình ghi nhận băng thông có thể tạo ra một lượng tải xử lý và I/O rất nhỏ trên máy chủ. Mặc dù thường không đáng kể, một số người muốn tắt mọi thứ không thật sự cần thiết để tối ưu hóa tối đa.
* Tránh Redundancy: Nếu bạn đã sử dụng các công cụ khác để theo dõi băng thông [ví dụ: từ nhà cung cấp hosting, Cloudflare, hoặc các phần mềm giám sát khác], bạn có thể muốn tắt tính năng này trong OLS để tránh theo dõi trùng lặp.
* Tiết kiệm dung lượng lưu trữ [Rất nhỏ]: Dữ liệu băng thông có thể được lưu lại, việc tắt đi sẽ tiết kiệm một chút không gian.

Tóm lại: Tính năng này trong WPTangToc OLS cung cấp cho bạn quyền kiểm soát việc OpenLiteSpeed có ghi nhận và thống kê dung lượng băng thông mà các website sử dụng hay không. Việc kích hoạt giúp bạn giám sát và quản lý tài nguyên tốt hơn, trong khi việc hủy kích hoạt có thể hữu ích nếu bạn đã có giải pháp theo dõi khác hoặc muốn giảm thiểu mọi tải không cần thiết trên server.
```

---

## Kiểm tra CPU (`wptt-kiem-tra-cpu`)

- **Danh mục:** Quản lý tài nguyên server
- **Vị trí menu:** Menu chính › 29. Quản lý tài nguyên server › 1. Kiểm tra CPU  _(bấm lần lượt: 29 → 1)_
- **Tệp nguồn:** `/etc/wptt/tai-nguyen-server/wptt-kiem-tra-cpu`

```text
Tính năng Kiểm tra CPU là việc sử dụng các công cụ phần mềm hoặc tiện ích hệ thống để thu thập thông tin, theo dõi hoạt động và đánh giá sức khỏe của Bộ xử lý Trung tâm [CPU] trong máy tính hoặc máy chủ của bạn.

Mục Đích Chính
* Theo dõi hiệu suất: Xem CPU đang được sử dụng bao nhiêu %, tiến trình nào đang chiếm nhiều.
* Chẩn đoán sự cố: Kiểm tra Load Average để biết hệ thống có đang quá tải hay nghẽn cổ chai không.
* Kiểm tra phần cứng: Xác nhận model CPU, tốc độ, số nhân, số luồng.
* Tập lệnh tối ưu: Đánh giá sức mạnh của CPU thông qua các công nghệ hỗ trợ như AES [Tăng tốc SSL/HTTPS] và AVX [Tăng tốc Database/PHP].
```

---

## Kiểm tra RAM (`wptt-kiem-tra-ram`)

- **Danh mục:** Quản lý tài nguyên server
- **Vị trí menu:** Menu chính › 29. Quản lý tài nguyên server › 2. Kiểm tra RAM  _(bấm lần lượt: 29 → 2)_
- **Tệp nguồn:** `/etc/wptt/tai-nguyen-server/wptt-kiem-tra-ram`

```text
Tính năng Kiểm tra RAM là tiện ích hệ thống để xem thông tin, theo dõi mức độ sử dụng hiện tại, và quan trọng nhất là kiểm tra lỗi hoặc sự cố của bộ nhớ truy cập ngẫu nhiên [RAM] trong máy tính hoặc máy chủ của bạn.

Nói một cách đơn giản, đây là cách bạn khám sức khỏe cho RAM để biết nó có bao nhiêu dung lượng, đang dùng bao nhiêu, còn trống bao nhiêu, và có đang ốm [bị lỗi] hay không.

Mục Đích Chính
* Phát hiện lỗi RAM: RAM lỗi là nguyên nhân phổ biến gây ra các sự cố như máy tính bị treo.
* Theo dõi hiệu suất: Xem lượng RAM đang sử dụng để biết hệ thống có bị thiếu RAM không.
* Xác minh thông số RAM: Kiểm tra tổng dung lượng RAM đã cài đặt, công nghệ [DDR3,DDR4, DDR5].
* Kiểm tra ZRAM: Theo dõi hiệu suất nén bộ nhớ để tối ưu hóa VPS.
```

---

## Kiểm tra công nghệ ảo hóa VPS (`wptt-kiem-tra-ao-hoa-vps`)

- **Danh mục:** Quản lý tài nguyên server
- **Vị trí menu:** Menu chính › 29. Quản lý tài nguyên server › 4. Kiểm tra công nghệ ảo hóa VPS  _(bấm lần lượt: 29 → 4)_
- **Tệp nguồn:** `/etc/wptt/tai-nguyen-server/wptt-kiem-tra-ao-hoa-vps`

```text
Kiểm tra công nghệ ảo hóa VPS là quá trình xác định xem Máy chủ ảo riêng [VPS] của bạn đang được tạo ra và quản lý bằng công nghệ ảo hóa cụ thể nào [ví dụ: KVM, OpenVZ, Xen, VMware, Hyper-V].

Mục Đích Chính:
* Hiểu rõ khả năng của VPS:
- Ảo hóa đầy đủ [KVM, Xen, VMware]: Tùy chỉnh kernel, độ cô lập cao.
- Ảo hóa cấp độ OS [OpenVZ, LXC]: Chia sẻ kernel, nhẹ hơn nhưng ít cô lập.
* Khắc phục sự cố: Chẩn đoán các vấn đề về tương thích hoặc hiệu suất.
* Lựa chọn cấu hình: Hiểu về ảo hóa giúp tối ưu hóa hệ thống tốt hơn.
```

---

## Xem monitoring(TOP) (`top`)

- **Danh mục:** Quản lý tài nguyên server
- **Vị trí menu:** Menu chính › 29. Quản lý tài nguyên server › 6. Xem monitoring(TOP)  _(bấm lần lượt: 29 → 6)_
- **Tệp nguồn:** `/etc/wptt/tai-nguyen-server/top`

```text
Tính năng truy cập vào ứng dụng: top

top trong Linux là một công cụ dòng lệnh cung cấp một cái nhìn động, cập nhật theo thời gian thực về các tiến trình [processes] đang chạy và tình hình sử dụng tài nguyên hệ thống của bạn.

Nói một cách đơn giản, top giống như bảng điều khiển trung tâm hiển thị trực tiếp những gì đang diễn ra bên trong máy chủ hoặc máy tính Linux của bạn, đặc biệt là những tiến trình nào đang ngốn CPU và RAM nhiều nhất.

Mục Đích Chính
* Theo dõi hệ thống thời gian thực: Xem ngay lập tức các tiến trình đang hoạt động và tài nguyên đang được sử dụng như thế nào.
* Xác định tiến trình nặng gánh: Nhanh chóng tìm ra các ứng dụng hoặc dịch vụ đang chiếm dụng quá nhiều CPU hoặc bộ nhớ, có thể là nguyên nhân gây chậm hệ thống.
* Gỡ lỗi hiệu suất: Giúp chẩn đoán các vấn đề về hiệu suất, tình trạng treo hoặc phản hồi chậm của hệ thống.
* Quản lý tiến trình cơ bản: Cho phép bạn thực hiện một số hành động như kill [dừng] một tiến trình hoặc renice [thay đổi độ ưu tiên] một cách tương tác.
* Hiểu về tải hệ thống: Cung cấp thông tin về mức độ bận rộn của CPU và bộ nhớ.

Hướng dẫn cách xem lệnh top: https://wptangtoc.com/kiem-tra-tai-nguyen-linux-top/
```

---

## Quản lý băng thông (`wptt-bang-thong-main`)

- **Danh mục:** Quản lý tài nguyên server
- **Vị trí menu:** Menu chính › 29. Quản lý tài nguyên server › 7. Quản lý băng thông  _(bấm lần lượt: 29 → 7)_
- **Tệp nguồn:** `/etc/wptt/tai-nguyen-server/wptt-bang-thong-main`

```text
Tính năng Theo dõi băng thông [Bandwidth Monitoring] là quá trình quan sát, đo lường và phân tích lượng dữ liệu được truyền tải [tải lên - upload và tải xuống - download] qua một kết nối mạng hoặc bởi một thiết bị/ứng dụng cụ thể trong một khoảng thời gian nhất định.

Nói một cách đơn giản, đây là cách bạn theo dõi đồng hồ nước của đường truyền Internet hoặc mạng nội bộ để biết ai/cái gì đang xài bao nhiêu dữ liệu, và tốc độ xài hiện tại là bao nhiêu.

Mục Đích Chính
* Phát hiện kẻ ngốn băng thông: Xác định ứng dụng, thiết bị, hoặc người dùng nào đang sử dụng nhiều băng thông nhất, giúp tìm ra nguyên nhân mạng chậm.
* Quản lý giới hạn dữ liệu: Đối với các gói Internet có giới hạn dung lượng [data cap], việc theo dõi giúp bạn không vượt quá hạn mức, tránh phát sinh chi phí hoặc bị giảm tốc độ.
* Chẩn đoán sự cố mạng: Giúp tìm ra điểm nghẽn, lưu lượng bất thường, hoặc các vấn đề làm chậm mạng.
* Lập kế hoạch nâng cấp: Hiểu được xu hướng sử dụng băng thông giúp bạn quyết định khi nào cần nâng cấp gói Internet hoặc băng thông cho máy chủ.
* Giám sát an ninh: Các đột biến hoặc kiểu sử dụng băng thông lạ có thể là dấu hiệu của hoạt động độc hại [ví dụ: máy tính bị nhiễm virus đang gửi dữ liệu ngầm].
* Tối ưu hóa hiệu suất: Biết được ứng dụng nào dùng nhiều băng thông để có thể điều chỉnh cài đặt cho phù hợp.

Việc theo dõi băng thông giúp bạn kiểm soát tốt hơn việc sử dụng Internet và tài nguyên mạng của mình.
```

---

## Kiểm tra tốc độ internet (`wptt-kiem-tra-mang-internet`)

- **Danh mục:** Quản lý tài nguyên server
- **Vị trí menu:** Menu chính › 29. Quản lý tài nguyên server › 8. Kiểm tra tốc độ internet  _(bấm lần lượt: 29 → 8)_
- **Tệp nguồn:** `/etc/wptt/tai-nguyen-server/wptt-kiem-tra-mang-internet`

```text
Tính năng Kiểm tra tốc độ Internet giúp đo lường hiệu suất thực tế của kết nối mạng trên máy chủ VPS/Server (bao gồm Tốc độ Tải xuống - Download, Tốc độ Tải lên - Upload, Ping ICMP và Độ trễ bắt tay TCP).

Mục Đích Chính
* Xác minh băng thông nhà cung cấp [ISP/Datacenter]: Kiểm tra tốc độ cổng mạng (Port Speed) trong nước và quốc tế.
* Chẩn đoán đứt cáp / nghẽn tuyến quốc tế: So sánh độ trễ (Latency) và tốc độ tới Việt Nam, Singapore, Nhật Bản, Châu Âu và Hoa Kỳ.
* Kiểm tra thuật toán TCP Kernel: Nhận diện nhanh máy chủ đã kích hoạt TCP BBR để tối ưu hóa tốc độ truyền tải đường dài hay chưa.
* Đánh giá khả năng chịu tải: Đảm bảo băng thông Upload/Download đáp ứng tốt cho Website WordPress và sao lưu đám mây (Rclone/Telegram).
```

---

## Kiểm tra tốc độ ping internet (`wptt-kiem-tra-ping-internet`)

- **Danh mục:** Quản lý tài nguyên server
- **Vị trí menu:** Menu chính › 29. Quản lý tài nguyên server › 9. Kiểm tra tốc độ ping internet  _(bấm lần lượt: 29 → 9)_
- **Tệp nguồn:** `/etc/wptt/tai-nguyen-server/wptt-kiem-tra-ping-internet`

```text
Tính năng Kiểm tra internet ping trong WPTangToc OLS là một công cụ tiện ích cho phép bạn kiểm tra kết nối mạng từ chính máy chủ của bạn ra internet bằng cách gửi các gói tin nhỏ [ping] đến một địa chỉ IP hoặc tên miền cụ thể.

🎯 Mục đích chính:
* Chẩn đoán Kết nối Mạng của Server: Giúp bạn nhanh chóng xác định xem máy chủ có thể thấy và giao tiếp với các máy chủ khác trên internet hay không.
* Kiểm tra Độ trễ [Latency]: Đo lường thời gian phản hồi [round-trip time] từ máy chủ của bạn đến một đích cụ thể, giúp đánh giá chất lượng đường truyền.
* Xác định Mất gói [Packet Loss]: Xem có gói tin nào bị mất trong quá trình truyền đi và nhận về hay không, một dấu hiệu của sự cố mạng.
* Khắc phục sự cố cơ bản: Nếu website trên server không thể truy cập các dịch vụ bên ngoài [ví dụ: cập nhật, API], ping là một trong những bước đầu tiên để kiểm tra xem vấn đề có phải do kết nối mạng của server hay không.

Tóm lại, tính năng Kiểm tra internet ping trong WPTangToc OLS là một công cụ chẩn đoán mạng cơ bản nhưng rất hữu ích, cho phép bạn đánh giá khả năng kết nối và chất lượng đường truyền internet từ máy chủ của mình.
```

---

## Giả lập từ một website nào đó trong hệ thống này (`gia-lap-website-co-du-lieu`)

- **Danh mục:** Giả lập website
- **Vị trí menu:** Menu chính › 30. Giả lập website › 1. Giả lập từ một website nào đó trong hệ thống này  _(bấm lần lượt: 30 → 1)_
- **Tệp nguồn:** `/etc/wptt/gia-lap-website/gia-lap-website-co-du-lieu`

```text
GIẢ LẬP WEBSITE ➜ NHÂN BẢN MÔI TRƯỜNG THỬ NGHIỆM (STAGING)

Tính năng Giả lập Website của WPTangToc OLS cho phép bạn nhân bản
một website WordPress đang hoạt động thành một môi trường thử nghiệm
độc lập, sử dụng tên miền miễn phí dạng *.wptangtoc-ols.com.

Bạn có thể thoải mái kiểm tra, chỉnh sửa và thử nghiệm trên bản sao
mà không làm ảnh hưởng trực tiếp đến website gốc.

TÍNH NĂNG NỔI BẬT
* Cấp tên miền staging miễn phí:
  Tự động tạo tên miền ngẫu nhiên dạng:
  https://tenwebsite-xxxx.wptangtoc-ols.com

* Nhân bản toàn bộ website WordPress:
  Sao chép mã nguồn và Database từ website gốc sang môi trường mới.

* Tự động cấu hình website:
  Cập nhật URL trong Database, thiết lập WordPress và cấu hình
  môi trường để bản sao hoạt động độc lập với website gốc.

* Tự động cài đặt SSL:
  Hỗ trợ thiết lập HTTPS bảo mật cho tên miền staging.

* Hạn chế lập chỉ mục trên Google:
  Tự động thiết lập Noindex nhằm hạn chế công cụ tìm kiếm
  lập chỉ mục bản sao, giảm nguy cơ nội dung trùng lặp SEO.

* Tự động kiểm tra hoạt động:
  Kiểm tra DNS và khả năng phản hồi của website sau khi nhân bản.
  Nếu quá trình khởi tạo gặp lỗi, hệ thống có cơ chế rollback
  để xử lý môi trường staging bị lỗi.

LỢI ÍCH KHI SỬ DỤNG
* Thử nghiệm Plugin, Theme và các bản cập nhật WordPress.
* Kiểm tra mã nguồn PHP, CSS, JavaScript trước khi triển khai.
* Thử nghiệm tính năng mới mà không tác động trực tiếp đến website gốc.
* Phát hiện và sửa lỗi trong môi trường riêng biệt.
* Kiểm tra giao diện, hiệu năng và các thay đổi trước khi đưa lên Production.
* Phù hợp cho lập trình viên, quản trị viên website và người làm WordPress.

CÁCH SỬ DỤNG
1. Chọn website WordPress cần nhân bản.
2. Xác nhận khởi tạo môi trường giả lập.
3. Chờ hệ thống tự động sao chép mã nguồn và Database.
4. Chờ cấu hình DNS, SSL và kiểm tra trạng thái website.
5. Truy cập tên miền staging được cấp để bắt đầu thử nghiệm.

LƯU Ý QUAN TRỌNG
* Tính năng hiện chỉ hỗ trợ website sử dụng WordPress.
* Máy chủ cần có kết nối IPv4 để khởi tạo tên miền staging.
* Tài khoản và mật khẩu WordPress của bản sao ban đầu giống website gốc.
* Bản staging sử dụng Database và mã nguồn được nhân bản từ website gốc.
* Các thay đổi trên bản staging không tự động đồng bộ ngược về website gốc.
* Không nên sử dụng dữ liệu nhạy cảm trên môi trường thử nghiệm.
* Noindex không đồng nghĩa với việc website được bảo vệ bằng mật khẩu.
  Không chia sẻ thông tin truy cập staging cho người không đáng tin cậy.
* Tên miền staging thuộc *.wptangtoc-ols.com và được sử dụng
  cho mục đích thử nghiệm, phát triển và kiểm tra website.

Hãy sử dụng môi trường staging để kiểm tra kỹ mọi thay đổi trước
khi áp dụng lên website đang hoạt động (Production).
```

---

## Giả lập từ WordPress mới trắng (`gia-lap-website-wordpress-moi-hoan-toan`)

- **Danh mục:** Giả lập website
- **Vị trí menu:** Menu chính › 30. Giả lập website › 2. Giả lập từ WordPress mới trắng  _(bấm lần lượt: 30 → 2)_
- **Tệp nguồn:** `/etc/wptt/gia-lap-website/gia-lap-website-wordpress-moi-hoan-toan`

```text
1. TÍNH NĂNG TẠO WEBSITE WORDPRESS THỬ NGHIỆM
   [Free Staging Domain - *.wptangtoc-ols.com]

Tự động khởi tạo một website WordPress hoàn toàn mới trên VPS
của bạn, đi kèm tên miền phụ miễn phí thuộc hệ thống
wptangtoc-ols.com.

Website được cài đặt từ mã nguồn WordPress gốc, cung cấp một
môi trường độc lập để phát triển, kiểm thử và trải nghiệm
các tính năng WordPress mà không ảnh hưởng đến website chính.

LỢI ÍCH VÀ TÍNH NĂNG:
- Cấp phát tên miền thử nghiệm miễn phí, tự động tạo tên miền
  ngẫu nhiên nhằm hạn chế trùng lặp.
- Tự động cấu hình DNS Cloudflare và Virtual Host OpenLiteSpeed.
- Tự động tải và cài đặt WordPress phiên bản mới nhất.
- Tự động tạo Database, cấu hình wp-config.php và cài đặt
  WordPress thông qua WP-CLI.
- Tự động thiết lập SSL Let's Encrypt, hỗ trợ truy cập HTTPS.
- Tự động cấu hình ngôn ngữ Tiếng Việt và múi giờ Việt Nam.
- Tự động thiết lập đường dẫn bài viết thân thiện SEO.
- Tự động tạo tài khoản quản trị WordPress với thông tin
  đăng nhập ngẫu nhiên.
- Tự động thiết lập Noindex nhằm hạn chế công cụ tìm kiếm
  lập chỉ mục website thử nghiệm.

MỤC ĐÍCH SỬ DỤNG:
- Thử nghiệm Plugin, Theme và các tiện ích WordPress mới.
- Phát triển, kiểm tra mã nguồn PHP và tính năng tùy chỉnh.
- Kiểm tra khả năng tương thích giữa các Plugin.
- Thực hành quản trị WordPress và học tập lập trình website.
- Tạo môi trường Staging trước khi triển khai website chính thức.
- Kiểm tra cấu hình OpenLiteSpeed, PHP, Database và SSL.
- Khắc phục sự cố WordPress trên môi trường độc lập.

ƯU ĐIỂM:
- Không cần mua tên miền riêng để thử nghiệm.
- Không cần cài đặt WordPress thủ công.
- Không làm thay đổi mã nguồn website hiện có.
- Website được vận hành trực tiếp trên VPS của bạn.
- Tiết kiệm thời gian triển khai môi trường phát triển.

LƯU Ý:
- Tên miền miễn phí chỉ phục vụ mục đích thử nghiệm.
- Website sử dụng tài nguyên CPU, RAM và Database
  trực tiếp từ VPS của bạn.
- Tên miền thử nghiệm không phải tên miền sở hữu riêng.
- Noindex chỉ hạn chế lập chỉ mục, không ngăn người khác
  truy cập website nếu biết địa chỉ.
- Không sử dụng môi trường này để lưu trữ dữ liệu nhạy cảm,
  thông tin khách hàng hoặc vận hành website kinh doanh
  chính thức.
- Hãy lưu lại thông tin đăng nhập quản trị WordPress
  ngay sau khi hoàn tất khởi tạo.

2. TÍNH NĂNG XÓA WEBSITE THỬ NGHIỆM
   [Remove Staging Website]

Cho phép xóa website WordPress thử nghiệm đã tạo,
đồng thời giải phóng các tài nguyên liên quan trên VPS.

- Xóa Virtual Host và cấu hình website thử nghiệm.
- Dọn dẹp thư mục mã nguồn WordPress.
- Thu hồi cấu hình tên miền thử nghiệm.
- Giải phóng tài nguyên Database và hệ thống liên quan.

CẢNH BÁO:
Việc xóa website có thể khiến toàn bộ mã nguồn, dữ liệu
và nội dung thử nghiệm không thể khôi phục.
Hãy sao lưu dữ liệu cần thiết trước khi thực hiện.

WPTangToc OLS
Môi trường thử nghiệm WordPress nhanh chóng, tiện lợi
và hoàn toàn tự động ngay trên VPS của bạn.
```

---

## Chuyển website giả lập vào website chính (`gia-lap-website-dua-vao-website-chinh`)

- **Danh mục:** Giả lập website
- **Vị trí menu:** Menu chính › 30. Giả lập website › 3. Chuyển website giả lập vào website chính  _(bấm lần lượt: 30 → 3)_
- **Tệp nguồn:** `/etc/wptt/gia-lap-website/gia-lap-website-dua-vao-website-chinh`

```text
GIẢ LẬP WEBSITE ➜ TRIỂN KHAI BẢN NHÁP LÊN WEBSITE CHÍNH (PRODUCTION)

Tính năng này cho phép bạn đưa toàn bộ thay đổi từ website giả lập
(Staging) lên website chính (Production) sau khi đã kiểm tra và thử nghiệm
thành công.

Đây là quá trình triển khai (Deployment), giúp chuyển phiên bản website
đã hoàn thiện trong môi trường thử nghiệm sang môi trường hoạt động
thực tế dành cho người truy cập.

TÍNH NĂNG HOẠT ĐỘNG NHƯ THẾ NÀO?
* Chọn website giả lập (Nguồn):
  Chọn bản Staging chứa mã nguồn và Database đã được chỉnh sửa,
  thử nghiệm và xác nhận hoạt động tốt.

* Chọn website chính (Đích):
  Chọn website Production sẽ tiếp nhận dữ liệu từ bản giả lập.

* Đồng bộ Database:
  Xuất toàn bộ Database từ bản giả lập và nhập vào Database
  của website chính.

* Đồng bộ mã nguồn:
  Sao chép toàn bộ mã nguồn từ bản giả lập sang thư mục website chính,
  bao gồm Theme, Plugin, Uploads và các tệp WordPress liên quan.

* Tự động cấu hình WordPress:
  Cập nhật thông tin kết nối Database, chuyển đổi URL từ tên miền
  giả lập sang tên miền chính bằng WP-CLI Search & Replace.

* Khôi phục thiết lập SEO:
  Mở lại chế độ cho phép công cụ tìm kiếm lập chỉ mục website chính
  (Index), thay cho trạng thái Noindex của bản giả lập.

* Hoàn tất triển khai:
  Tự động xóa Cache và thiết lập lại quyền sở hữu, phân quyền
  cho mã nguồn website chính.

LỢI ÍCH KHI SỬ DỤNG
* Kiểm tra và hoàn thiện website trước khi đưa lên môi trường thực tế.
* Triển khai các thay đổi về giao diện, Theme và Plugin.
* Đưa các tính năng mới đã thử nghiệm lên website chính.
* Đồng bộ nội dung và dữ liệu từ bản giả lập sang website đang hoạt động.
* Hạn chế thao tác thủ công khi chuyển đổi môi trường Staging sang Production.
* Tiết kiệm thời gian triển khai và giảm nguy cơ cấu hình sai URL,
  Database hoặc quyền truy cập.

CÁCH SỬ DỤNG
1. Chọn website giả lập (Staging) làm nguồn dữ liệu.
2. Chọn website chính (Production) làm đích triển khai.
3. Kiểm tra kỹ tên miền nguồn và tên miền đích trên màn hình xác nhận.
4. Xác nhận đồng ý ghi đè để bắt đầu triển khai.
5. Chờ hệ thống chuyển Database, mã nguồn và cập nhật cấu hình.
6. Sau khi hoàn tất, truy cập website chính để kiểm tra hoạt động.

⚠️ CẢNH BÁO QUAN TRỌNG: GHI ĐÈ DỮ LIỆU
Đây là thao tác có ảnh hưởng trực tiếp đến website Production.

* TOÀN BỘ Database hiện tại của website chính sẽ bị xóa trước khi
  nhập Database từ bản giả lập.
* Các tệp và thư mục hiện tại trong thư mục HTML của website chính
  sẽ bị xóa trước khi chép mã nguồn từ bản giả lập sang.
* Những bài viết, đơn hàng, tài khoản, bình luận, hình ảnh hoặc dữ liệu
  phát sinh trên website chính sau thời điểm tạo bản giả lập có thể
  bị mất khi triển khai.
* Bản giả lập vẫn được giữ nguyên sau khi triển khai.
* Không thực hiện thao tác này nếu chưa chắc chắn bản giả lập là
  phiên bản dữ liệu bạn muốn đưa lên website chính.

KHUYẾN NGHỊ TRƯỚC KHI TRIỂN KHAI:

* Sao lưu đầy đủ Database và mã nguồn website chính.
* Kiểm tra kỹ website giả lập, đảm bảo các tính năng hoạt động ổn định.
* Xác nhận đúng website nguồn và website đích.
* Nếu website có đơn hàng, thành viên hoặc dữ liệu thường xuyên thay đổi,
  hãy cân nhắc thời điểm triển khai để tránh mất dữ liệu mới phát sinh.

Hãy chỉ triển khai khi bạn đã kiểm tra kỹ và sẵn sàng thay thế dữ liệu
hiện tại của website chính bằng dữ liệu từ bản giả lập.
```

---

## Giả lập website (`wptt-gia-lap-main`)

- **Danh mục:** Giả lập website
- **Vị trí menu:** Menu chính › 30. Giả lập website  _(bấm lần lượt: 30)_
- **Tệp nguồn:** `/etc/wptt/wptt-gia-lap-main`

```text
tính năng giả lập website giúp tạo ra một phiên bản mô phỏng của website thật hoặc một phần của nó để thử nghiệm, xem trước hoặc trình bày ý tưởng mà không cần can thiệp vào website đang hoạt động hoặc trước khi bắt đầu xây dựng hoàn chỉnh.

Mục đích: Tạo ra một bản sao của website chính [website đang hoạt động] trên một môi trường riêng biệt [trên cùng server].

Tính năng chính:
* Thử nghiệm thay đổi: Cho phép nhà phát triển, nhà thiết kế hoặc người quản trị web thử nghiệm các thay đổi về mã nguồn, giao diện, plugin, cập nhật phiên bản phần mềm mà không ảnh hưởng đến website thật đang chạy.
* Phát hiện lỗi: Giúp tìm và sửa lỗi trước khi triển khai lên môi trường thật.
* Đào tạo: Dùng để hướng dẫn người dùng mới cách quản trị website.
* Lợi ích: An toàn, giảm thiểu rủi ro khi cập nhật hoặc thay đổi website. Các công cụ quản lý hosting hoặc các plugin WordPress [như WP Staging, Duplicator] thường có tính năng này.
```

---

## Tài trợ dự án (`wptt-donate`)

- **Danh mục:** Tài trợ dự án
- **Vị trí menu:** Menu chính › 31. Tài trợ dự án  _(bấm lần lượt: 31)_
- **Tệp nguồn:** `/etc/wptt/wptt-donate`

```text
Hỗ trợ phát triển phần mềm WPTangToc OLS. rất biết ơn sự đóng góp của bạn nhằm hỗ trợ sứ mệnh của chúng tôi trong việc xây dựng một phần mềm thiết lập và quản trị webserver miễn phí mà hiệu suất tốt nhất.

Bánh mì trên bàn không phải là miễn phí, mặc dù phần mềm này miễn phí, và sẽ luôn như vậy. Mình thích phát triển phần mềm này và hỗ trợ các bạn, nhưng mình cũng cần bánh mì. Vui lòng tạo điều kiện để tôi tiếp tục nỗ lực vào phần mềm này:
```

---

## Nhóm Group thảo luận (`wptt-nhom-fb`)

- **Danh mục:** Nhóm Group thảo luận
- **Vị trí menu:** Menu chính › 32. Nhóm Group thảo luận  _(bấm lần lượt: 32)_
- **Tệp nguồn:** `/etc/wptt/wptt-nhom-fb`

```text
Kết nối với cộng đồng WPTangToc để cùng trao đổi, học hỏi và giải đáp các vấn đề về quản trị máy chủ, tối ưu hóa WordPress.
link: https://www.facebook.com/groups/wptangtoc/
```

---

## Change Language To EngLish (`lang-main`)

- **Danh mục:** Change Language To EngLish
- **Vị trí menu:** Menu chính › 33. Change Language To EngLish  _(bấm lần lượt: 33)_
- **Tệp nguồn:** `/etc/wptt/lang-main`

```text
Tính năng Quản lý Ngôn ngữ trong WPTangToc OLS [nếu có] là một tùy chọn cho phép người dùng thay đổi ngôn ngữ hiển thị của chính giao diện script WPTangToc OLS. 🗣️

Giới thiệu ngắn gọn:
Mục đích: Giúp người dùng từ các quốc gia khác nhau hoặc những người không thông thạo ngôn ngữ mặc định của script [ví dụ: tiếng Việt] có thể sử dụng WPTangToc OLS một cách dễ dàng và thuận tiện hơn.

Cách hoạt động:
* Cung cấp một tùy chọn trong menu cài đặt hoặc cấu hình của WPTangToc OLS.
* Người dùng có thể chọn từ danh sách các ngôn ngữ được hỗ trợ [ví dụ: Tiếng Việt, Tiếng Anh, Tiếng việt không dấu].
* Sau khi chọn, toàn bộ các thông báo, hướng dẫn, và mục menu của script sẽ được hiển thị bằng ngôn ngữ đã chọn.

Lợi ích:
* Tăng khả năng tiếp cận: Mở rộng đối tượng người dùng có thể sử dụng script.
* Nâng cao trải nghiệm người dùng: Giúp người dùng hiểu rõ hơn các tùy chọn và thông báo, giảm thiểu lỗi do rào cản ngôn ngữ.
* Sử dụng thuận tiện: Cho phép người dùng làm việc với script bằng ngôn ngữ mà họ cảm thấy thoải mái nhất.
Tính năng này đặc biệt hữu ích nếu WPTangToc OLS được phát triển với mục tiêu hỗ trợ cộng đồng người dùng quốc tế hoặc đa dạng về ngôn ngữ.
```

---

## Tài liệu hướng dẫn (`search-wptangtoc-huong-dan`)

- **Danh mục:** Tài liệu hướng dẫn
- **Vị trí menu:** Menu chính › 34. Tài liệu hướng dẫn  _(bấm lần lượt: 34)_
- **Tệp nguồn:** `/etc/wptt/search-wptangtoc-huong-dan`

```text
Tính năng tài liệu hướng dẫn, thì đây là một phần rất quan trọng, đóng vai trò như sách hướng dẫn sử dụng hoặc trung tâm trợ giúp tích hợp, giúp người dùng hiểu và sử dụng công cụ một cách hiệu quả.

Giới thiệu ngắn gọn về tính năng này:

Mục đích chính:
- Hướng dẫn sử dụng: Cung cấp các chỉ dẫn chi tiết về cách cài đặt, cấu hình và sử dụng các chức năng khác nhau có trong bộ công cụ WPTangToc OLS.
- Giải thích tính năng: Làm rõ mục đích, cách hoạt động và lợi ích của từng tùy chọn hoặc lệnh mà công cụ cung cấp.
- Hướng dẫn thực hiện tác vụ: Đưa ra các bước cụ thể để thực hiện các công việc phổ biến như tạo website mới, cài đặt cache, quản lý database, v.v.
- Khắc phục sự cố: Cung cấp các giải pháp cho những vấn đề hoặc lỗi thường gặp.

Lợi ích:
- Tự học & Tự giải quyết vấn đề: Giúp người dùng có thể tự tìm hiểu.
- Sử dụng đúng cách: Khai thác tối đa tiềm năng của công cụ.
- Chuẩn hóa kiến thức: Tạo ra nguồn thông tin tham khảo chính thức.

Hướng dẫn tính năng:
- Hỗ trợ tìm kiếm cả Tiếng Việt có dấu, không dấu và tự động sửa lỗi chính tả.
- Di chuyển nút mũi tên (↑ ↓).
- ESC để huỷ.
- Enter để chọn.
- Cuộn trỏ chuột hoặc (Shift + ↑ ↓) để cuộn nội dung.
```

---

## Bật/Tắt kiểm tra thông báo hạn SSL (`thiet-lap-check-ssl`)

- **Danh mục:** Add ons
- **Vị trí menu:** Menu chính › 35. Add ons › 1. Bật/Tắt kiểm tra thông báo hạn SSL  _(bấm lần lượt: 35 → 1)_
- **Tệp nguồn:** `/etc/wptt/add-one/thiet-lap-check-ssl`

```text
Tính năng thông báo sắp hết hạn SSL là một công cụ tự động giám sát và cảnh báo cho bạn khi chứng chỉ SSL/TLS của website sắp hết hiệu lực.

Giới thiệu ngắn gọn:
Mục đích: Đảm bảo website luôn được bảo vệ bởi HTTPS, tránh gián đoạn truy cập, mất lòng tin từ người dùng và các cảnh báo bảo mật từ trình duyệt do SSL hết hạn.
Cách hoạt động: Hệ thống sẽ định kỳ kiểm tra ngày hết hạn của chứng chỉ SSL được cài đặt trên tên miền của bạn.

Cảnh báo sớm: Khi chứng chỉ sắp đến ngày hết hạn [ví dụ: còn 30 ngày, 14 ngày, 7 ngày], hệ thống sẽ tự động gửi thông báo cho bạn qua các kênh như:
Thông báo trong ứng dụng telegram

Lợi ích: Giúp bạn chủ động gia hạn hoặc thay thế chứng chỉ SSL kịp thời, duy trì tính bảo mật và uy tín cho website.
```

---

## Bật/Tắt kiểm tra thông báo hạn Domain (`thiet-lap-check-domain-het-han`)

- **Danh mục:** Add ons
- **Vị trí menu:** Menu chính › 35. Add ons › 2. Bật/Tắt kiểm tra thông báo hạn Domain  _(bấm lần lượt: 35 → 2)_
- **Tệp nguồn:** `/etc/wptt/add-one/thiet-lap-check-domain-het-han`

```text
Tính năng thông báo sắp hết hạn tên miền [domain] cũng là một thành phần cực kỳ quan trọng để đảm bảo hoạt động liên tục và ổn định cho sự hiện diện trực tuyến của bạn.

Dưới đây là giới thiệu chi tiết về tính năng này, bao gồm cả khả năng thông báo qua API:

Theo dõi Ngày Hết Hạn Tên Miền [Domain Expiration Tracking]:

Mục đích: Tên miền là địa chỉ website của bạn trên internet. Nếu tên miền hết hạn mà không được gia hạn kịp thời, website sẽ không thể truy cập được, email liên quan đến tên miền cũng ngừng hoạt động, và tệ hơn là bạn có nguy cơ mất tên miền vào tay người khác. Tính năng này giúp bạn chủ động theo dõi và tránh những rủi ro đó.

Tính năng thông báo sắp hết hạn tên miền, đặc biệt khi được kết hợp với khả năng thông báo qua API, là một công cụ vô giá cho bất kỳ cá nhân hay tổ chức nào sở hữu tên miền. Nó không chỉ giúp bạn tránh được những hậu quả nghiêm trọng do việc quên gia hạn mà còn tối ưu hóa quy trình quản lý tài sản số, tiết kiệm thời gian và công sức. Việc tìm kiếm các nhà cung cấp dịch vụ giám sát hoặc quản lý tên miền có hỗ trợ API cho tính năng này là một lựa chọn thông minh.
```

---

## Bật/Tắt Tăng tốc Htaccess Cache (`thiet-lap-auto-htaccess-optimize`)

- **Danh mục:** Add ons
- **Vị trí menu:** Menu chính › 35. Add ons › 7. Bật/Tắt Tăng tốc Htaccess Cache  _(bấm lần lượt: 35 → 7)_
- **Tệp nguồn:** `/etc/wptt/add-one/thiet-lap-auto-htaccess-optimize`

```text
Cải thiện hiệu suất máy chủ OpenLiteSpeed nâng cao chịu tải máy chủ OpenLiteSpeed.
OpenLiteSpeed không hỗ trợ htaccess cache nhưng với Litespeed Enterprise thì có hỗ trợ.
Tính năng này sẽ giúp OpenLiteSpeed hỗ trợ .htaccess cache, cải thiện tốc độ và chịu tải hơn.
```

---

## Hiển thị IP Log Real bypass Cloudflare (`cloudflare-cdn-ip-show-real`)

- **Danh mục:** Add ons
- **Vị trí menu:** Menu chính › 35. Add ons › 8. Hiển thị IP Log Real bypass Cloudflare  _(bấm lần lượt: 35 → 8)_
- **Tệp nguồn:** `/etc/wptt/cloudflare-cdn-ip-show-real`

```text
Tính năng Hiển thị IP real Cloudflare CDN trong WPTangToc OLS là một công cụ giúp bạn xác minh hoặc cấu hình để máy chủ web OpenLiteSpeed của bạn có thể nhận diện và ghi lại địa chỉ IP thực của người dùng khi website đang sử dụng dịch vụ CDN của Cloudflare.

Tại sao cần quan tâm IP thực khi dùng Cloudflare?
Khi website của bạn sử dụng Cloudflare, tất cả lưu lượng truy cập sẽ đi qua mạng lưới của Cloudflare trước khi đến máy chủ gốc. Do đó, trong log của máy chủ web, địa chỉ IP của người truy cập thường sẽ hiển thị là IP của Cloudflare, chứ không phải IP thực của khách truy cập. Điều này gây khó khăn cho việc:

Phân tích log chính xác.
* Áp dụng các quy tắc bảo mật dựa trên IP [ví dụ: chặn IP, giới hạn truy cập].
* Hoạt động của một số plugin hoặc ứng dụng cần IP thực của người dùng.
* Đảm bảo Dữ liệu Chính xác: Giúp các công cụ phân tích, bảo mật [như Fail2Ban,CSF,Nftables,Firewalld...] và ứng dụng trên website hoạt động chính xác với IP thực của người dùng.

Lợi ích:
* Log chính xác: Ghi lại đúng IP của khách truy cập trong log máy chủ.
* Bảo mật hiệu quả hơn: Các công cụ bảo mật dựa trên IP hoạt động đúng đắn.
* Phân tích dữ liệu tốt hơn: Hiểu rõ hơn về nguồn gốc lưu lượng truy cập.
Tóm lại, tính năng Hiển thị IP real Cloudflare CDN trong WPTangToc OLS rất quan trọng để đảm bảo máy chủ của bạn hoạt động chính xác và hiệu quả khi website được bảo vệ và tăng tốc bởi Cloudflare, bằng cách giúp máy chủ nhận diện đúng địa chỉ IP gốc của khách truy cập.
```

---

## Thiết lập Proxy ngược (Reverse Proxy) (`proxy-setup`)

- **Danh mục:** Add ons
- **Vị trí menu:** Menu chính › 35. Add ons › 10. Thiết lập Proxy ngược (Reverse Proxy)  _(bấm lần lượt: 35 → 10)_
- **Tệp nguồn:** `/etc/wptt/proxy-setup`

```text
Sử dụng Proxy ngược [Reverse Proxy] mang lại nhiều lợi ích quan trọng cho hệ thống máy chủ, đặc biệt là trong các môi trường yêu cầu hiệu suất cao và bảo mật nghiêm ngặt.

Dưới đây là các lợi ích chính:

1. Tăng cường bảo mật
Proxy ngược đóng vai trò như một "tấm khiên" bảo vệ. Thay vì để người dùng kết nối trực tiếp vào máy chủ gốc [Backend Server], mọi yêu cầu đều phải đi qua Proxy. Điều này giúp:
Ẩn địa chỉ IP thật của máy chủ nội bộ.
Ngăn chặn các cuộc tấn công trực tiếp vào hệ thống.

2. Cân bằng tải [Load Balancing]
Đối với các website có lưu lượng truy cập lớn, Proxy ngược có thể phân phối các yêu cầu đến nhiều máy chủ khác nhau.
Giúp hệ thống không bị quá tải tại một điểm.
Tăng tính sẵn sàng: Nếu một máy chủ gặp sự cố, Proxy sẽ tự động chuyển hướng khách hàng sang máy chủ còn hoạt động.

3. Tăng tốc độ với Bộ nhớ đệm [Caching]
Proxy ngược có thể lưu trữ các bản sao của nội dung tĩnh [như hình ảnh, CSS, JavaScript]. khi người dùng yêu cầu, Proxy sẽ trả về ngay lập tức mà không cần làm phiền đến máy chủ gốc, giúp giảm độ trễ đáng kể.

4. Giải mã SSL [SSL Termination]
Việc giải mã các yêu cầu HTTPS tiêu tốn khá nhiều tài nguyên CPU. Proxy ngược có thể đảm nhận nhiệm vụ này [xử lý chứng chỉ SSL/TLS] cho tất cả các máy chủ phía sau.
Giảm tải cho máy chủ Backend.
Quản lý chứng chỉ tập trung tại một nơi duy nhất.

5. Nén dữ liệu
Proxy ngược có thể nén các phản hồi [như sử dụng Gzip hoặc Brotli] trước khi gửi đến người dùng cuối. Việc này giúp giảm băng thông tiêu thụ và đẩy nhanh tốc độ tải trang trên các kết nối mạng yếu.
```

---

## Chặn truy cập trực tiếp HTTP IP (`ip-scan-block`)

- **Danh mục:** Add ons
- **Vị trí menu:** Menu chính › 35. Add ons › 11. Chặn truy cập trực tiếp HTTP IP  _(bấm lần lượt: 35 → 11)_
- **Tệp nguồn:** `/etc/wptt/ip-scan-block`

```text
Tính năng ngăn chặn truy trực tiếp http://IP địa chỉ ip của bạn
🎯 Mục đích chính Tăng cường Bảo mật và tiết kiệm tài nguyên máy chủ
Việc này thường hữu ích khi:
* Chống Bot dò quét tự động: Rất nhiều bot độc hại hoạt động bằng cách quét toàn bộ các dải địa chỉ IP trên Internet để tìm kiếm các máy chủ có lỗ hổng bảo mật. Khi bạn chặn truy cập qua IP, máy chủ của bạn sẽ không phản hồi với một trang web cụ thể. Điều này khiến máy chủ của bạn trở nên vô hình trước các cuộc tấn công tự động ở mức độ cơ bản, làm giảm đáng kể bề mặt tấn công.
* Ngăn chặn tấn công Host Header Injection: Đây là một kỹ thuật tấn công mà kẻ xấu gửi yêu cầu đến IP của bạn nhưng lại giả mạo thông tin tên miền [Host header]. Bằng cách thiết lập một quy tắc mặc định để từ chối tất cả các truy cập không có tên miền hợp lệ, bạn có thể vô hiệu hóa kiểu tấn công này.
* Bảo vệ các trang web đang phát triển: Khi bạn đang xây dựng một trang web mới trên máy chủ nhưng chưa trỏ tên miền chính thức, việc chặn truy cập IP sẽ ngăn người ngoài xem hoặc truy cập vào trang web còn dang dở của bạn.
```

---

## Factory Reset LiteSpeed Webserver (`wptt-reset`)

- **Danh mục:** Add ons
- **Vị trí menu:** Menu chính › 35. Add ons › 12. Factory Reset LiteSpeed Webserver  _(bấm lần lượt: 35 → 12)_
- **Tệp nguồn:** `/etc/wptt/wptt-reset`

```text
Tính năng Factory Reset LiteSpeed Webserver [Khôi phục cài đặt gốc cho LiteSpeed Webserver]
Khôi phục cài đặt gốc toàn bộ cấu hình vhost và httpd.conf của litespeed 
Giúp sửa lỗi máy chủ LiteSpeed Webserver
```

---

## Add ons (`wptt-add-one-main`)

- **Danh mục:** Add ons
- **Vị trí menu:** Menu chính › 35. Add ons  _(bấm lần lượt: 35)_
- **Tệp nguồn:** `/etc/wptt/wptt-add-one-main`

```text
echo "WPTangToc OLS trước đây từng giới hạn các tính năng cao cấp trong phiên bản trả phí. Tuy nhiên, để tri ân cộng đồng và hướng tới một hệ sinh thái mở hoàn toàn, toàn bộ các tính năng nâng cao nay đã được MỞ KHÓA MIỄN PHÍ 100%."
```

---

## Thùng Rác (`wptt-thung-rac-main`)

- **Danh mục:** Thùng Rác
- **Vị trí menu:** Menu chính › 36. Thùng Rác  _(bấm lần lượt: 36)_
- **Tệp nguồn:** `/etc/wptt/wptt-thung-rac-main`

```text
Tính năng Thùng rác ảo [Virtual Trash] trong WPTangToc OLS là lá chắn bảo vệ an toàn dữ liệu, chống lại các sai sót vô tình khi xóa website.

[ Giới thiệu ngắn gọn ]
Mục đích: Cung cấp cơ chế "Soft Delete", thay vì xóa vĩnh viễn [rm -rf], hệ thống sẽ dời mã nguồn và Database vào một khu vực an toàn, cho phép phục hồi khi cần thiết.

[ Cách hoạt động ]
* Lưu trữ tạm thời: Website bị xóa sẽ được dời vào /usr/local/.wptt_trash.
* Bảo toàn Database: Sử dụng kỹ thuật RENAME TABLE để đưa Database vào thùng rác ngay lập tức mà không tốn thêm dung lượng sao lưu.
* Dọn dẹp tự động: Cronjob hệ thống sẽ tự động quét và tiêu hủy vĩnh viễn các dữ liệu nằm trong thùng rác vượt quá số ngày quy định.

[ Lợi ích ]
* An tâm tuyệt đối: Tránh thảm họa "lỡ tay" xóa nhầm website quan trọng.
* Tối ưu I/O: Quá trình đưa vào thùng rác diễn ra dưới 0.1 giây, không gây nghẽn ổ đĩa.
* Linh hoạt: Cho phép bật/tắt hoặc điều chỉnh thời gian lưu trữ phù hợp với mọi cấu hình ổ cứng VPS.
```

---

## Xem danh sách website trong thùng rác (`wptt-trash-list`)

- **Danh mục:** Thùng Rác
- **Vị trí menu:** Menu chính › 36. Thùng Rác › 1. Xem danh sách website trong thùng rác  _(bấm lần lượt: 36 → 1)_
- **Tệp nguồn:** `/etc/wptt/trash/wptt-trash-list`

```text
Tính năng Xem danh sách website trong thùng rác [Virtual Trash List]

[ Mục đích và Lợi ích ]
Hiển thị chi tiết tất cả các website đang được lưu trữ tạm thời trong Thùng rác ảo. Giúp bạn kiểm soát, quản lý dung lượng ổ cứng hiệu quả và dễ dàng tìm lại dữ liệu khi cần.

[ Thông tin cung cấp ]
* Tên miền: Tên website gốc đã bị xóa.
* Thời gian xóa: Ngày giờ chính xác website được đưa vào thùng rác.
* Dung lượng: Kích thước mã nguồn [Source Code] đang chiếm dụng trên ổ đĩa.
* Trạng thái Database: Cho biết bản sao lưu cơ sở dữ liệu có còn nguyên vẹn [Lưu: Code + DB] hay không.
* Tổng quan: Đánh giá tổng dung lượng rác để bạn cân nhắc việc dọn dẹp hoặc khôi phục.
```

---

## Phục hồi website (Restore) (`wptt-trash-restore`)

- **Danh mục:** Thùng Rác
- **Vị trí menu:** Menu chính › 36. Thùng Rác › 2. Phục hồi website (Restore)  _(bấm lần lượt: 36 → 2)_
- **Tệp nguồn:** `/etc/wptt/trash/wptt-trash-restore`

```text
Tính năng Phục hồi website từ Thùng rác ảo [Virtual Trash Restore]

[ Mục đích và Lợi ích ]
Đưa website bị xóa nhầm quay trở lại hoạt động bình thường trên máy chủ. Tính năng tự động hóa hoàn toàn giúp tiết kiệm thời gian, không cần thao tác kỹ thuật phức tạp.

[ Cơ chế hoạt động Tự động hóa ]
Hệ thống sẽ không chỉ lấy lại mã nguồn, mà còn thực hiện quy trình "Hồi sinh" toàn diện:
1. Tự động tái tạo cấu hình máy chủ [Vhost, PHP, Logs].
2. Tự động khôi phục Database siêu tốc.
3. Tự động đồng bộ file wp-config.php với thông tin bảo mật mới nhất.
Bạn không cần phải làm thêm bất cứ thao tác kỹ thuật nào ngoài việc cài lại SSL!

[ Hướng dẫn và Lưu ý ]
Nếu bạn đã tạo lại website với cùng một tên miền đang tồn tại trên hệ thống, kịch bản sẽ chặn khôi phục để bảo vệ dữ liệu mới. Hãy xóa website hiện tại trước khi khôi phục bản cũ.
```

---

## Dọn sạch thùng rác ngay lập tức (`wptt-trash-empty`)

- **Danh mục:** Thùng Rác
- **Vị trí menu:** Menu chính › 36. Thùng Rác › 3. Dọn sạch thùng rác ngay lập tức  _(bấm lần lượt: 36 → 3)_
- **Tệp nguồn:** `/etc/wptt/trash/wptt-trash-empty`

```text
Tính năng Dọn sạch thùng rác [Empty Virtual Trash]

[ Mục đích và Lợi ích ]
Tiêu hủy vĩnh viễn toàn bộ dữ liệu [Mã nguồn và Database] đang nằm trong thùng rác ảo ngay lập tức. Giúp giải phóng triệt để dung lượng ổ cứng cho máy chủ.

[ Cảnh báo an toàn và Hướng dẫn ]
* Hành động này là KHÔNG THỂ HOÀN TÁC. Mọi dữ liệu sau khi dọn dẹp sẽ bị xóa vĩnh viễn khỏi hệ thống.
* Database sẽ được gỡ bỏ an toàn bằng lệnh DROP DATABASE để không để lại rác trong MariaDB.
* Nên sử dụng khi ổ cứng máy chủ [Disk Usage] báo động đầy hoặc bạn chắc chắn không cần khôi phục lại bất kỳ website nào vừa xóa.
```

---

## Bật / Tắt tính năng Thùng rác ảo (`wptt-bat-tat-trash`)

- **Danh mục:** Thùng Rác
- **Vị trí menu:** Menu chính › 36. Thùng Rác › 4. Bật / Tắt tính năng Thùng rác ảo  _(bấm lần lượt: 36 → 4)_
- **Tệp nguồn:** `/etc/wptt/trash/wptt-bat-tat-trash`

```text
Tính năng Bật / Tắt Thùng rác ảo [Virtual Trash Toggle]

[ Mục đích và Lợi ích ]
Quản lý trạng thái hoạt động của hệ thống Thùng rác ảo và tiến trình dọn dẹp ngầm [Cronjob]. Cho phép linh hoạt thay đổi cơ chế xóa website tùy theo nhu cầu và tài nguyên máy chủ.

[ Cơ chế và Hướng dẫn ]
* Khi BẬT: Thao tác xóa website sẽ diễn ra an toàn [Soft Delete]. Dữ liệu được lưu trữ tạm thời và tự động dọn dẹp định kỳ vào ban đêm [từ 4h30 - 5h00 sáng] để không gây nghẽn máy chủ.
* Khi TẮT: Hệ thống gỡ bỏ tiến trình dọn dẹp ngầm. Thao tác xóa website sẽ hoạt động theo cơ chế cũ: Xóa vĩnh viễn ngay lập tức. Phù hợp cho các máy chủ có dung lượng ổ cứng cực thấp.
```

---

## Thay đổi số ngày lưu trữ tự động (`wptt-trash-set-days`)

- **Danh mục:** Thùng Rác
- **Vị trí menu:** Menu chính › 36. Thùng Rác › 5. Thay đổi số ngày lưu trữ tự động  _(bấm lần lượt: 36 → 5)_
- **Tệp nguồn:** `/etc/wptt/trash/wptt-trash-set-days`

```text
Tính năng Thay đổi số ngày lưu trữ tự động [Set Trash Retention Days]

[ Mục đích và Lợi ích ]
Cấu hình thời gian tối đa [tuổi thọ] mà một website bị xóa được phép nằm trong thùng rác trước khi bị hệ thống Cronjob tiêu hủy vĩnh viễn. Giúp cân bằng giữa an toàn dữ liệu và không gian lưu trữ.

[ Lời khuyên thiết lập ]
* Mặc định hệ thống là 3 ngày: Đây là khoảng thời gian lý tưởng để khách hàng kịp thời nhận ra sai sót và yêu cầu khôi phục.
* 1 - 2 ngày: Dành cho máy chủ VPS có dung lượng ổ cứng nhỏ, I/O thấp.
* 7 - 14 ngày: Dành cho hệ thống máy chủ vật lý [Dedicated Server], lưu trữ dư dả, yêu cầu an toàn dữ liệu khắt khe.
```

---

## Mở Terminal / Dòng lệnh CLI (`terminal-cli`)

- **Danh mục:** Mở Terminal / Dòng lệnh CLI
- **Vị trí menu:** Menu chính › 37. Mở Terminal / Dòng lệnh CLI  _(bấm lần lượt: 37)_
- **Tệp nguồn:** `/etc/wptt/terminal-cli`

```text
Tính năng này giúp bạn tạm thời thoát khỏi giao diện Menu của
WPTangToc OLS để trở về môi trường dòng lệnh gốc của máy chủ.

Ứng dụng thực tế:
- Phù hợp khi bạn cần chạy các lệnh Linux thủ công [ping, htop...].
- Giúp Power User quản trị server nâng cao ngoài phạm vi Menu.

Cách quay lại Menu WPTangToc:
- Bạn chỉ cần gõ phím 1 hoặc lệnh wptangtoc rồi ấn Enter.
```

---

