# WPTangToc OLS
Sứ mệnh của chúng tôi trong việc xây dựng một phần mềm thiết lập và quản trị webserver miễn phí mà hiệu suất tốt nhất.

<h2>Hướng dẫn cài đặt</h2>
Yêu cầu hệ điều hành (AlmaLinux 8 | Rocky linux 8|Centos 7) để có thể sử dụng được phần mềm, bạn paste đoạn mã này vào terminal của bạn rồi phần mềm sẽ tự động thiết lập.

<pre>curl -sO https://wptangtoc.com/share/wptangtoc-ols && bash wptangtoc-ols</pre>

Nếu bạn muốn cài đặt luôn sẵn mã nguồn WordPress vào domain luôn thì có thể dùng đoạn này:

<pre>curl -sO https://wptangtoc.com/share/wptangtoc-ols && bash wptangtoc-ols wp</pre>

Nếu bạn chưa có VPS: thì bạn có thể tìm kiếm một đơn vị cung cấp VPS nào đó mà bạn cảm thấy uy tín bạn có thể thuê ở đó. Để có thể sử dụng công cụ này.

Đây là phần mềm script cài đặt thiết lập webserver và giúp bạn dễ dàng quản trị webserver, phầm mềm này mình phát triển tập trung vào mã nguồn WordPress là chủ yếu, chỉ đơn vì công việc của mình liên quan rất nhiều về WordPress và WordPress là sở trưởng của mình vì vậy mình chỉ tập trung toàn bộ nguồn lực tối ưu webserver dành cho WordPress.

Phần mềm này hỗ trợ: OpenLiteSpeed + LSPHP (8.2 & 8.1 & 8.0 & 7.4 & 7.3) + MariaDB (10.11 & 10.6 & 10.5 & 10.4)... có rất nhiều tính năng khác.

<h3>Hướng dẫn sử dụng</h3>

Vui lòng truy cập: <a href="https://wptangtoc.com/wptangtoc-ols/">https://wptangtoc.com/wptangtoc-ols/</a>

<h3>Các nguồn hỗ trợ cho WPTangToc OLS</h3>

<ul>
<li>OpenLiteSpeed: <a href="https://openlitespeed.org/">https://openlitespeed.org/</a></li>
<li>MariaDB: <a href="https://downloads.mariadb.org/">https://downloads.mariadb.org/</a></li>
<li>PHP: <a href="https://www.php.net/">https://www.php.net/</a></li>
<li>Rclone: <a href="https://rclone.org/">https://rclone.org/</a></li>
<li>WP-CLI: <a href="https://wp-cli.org/">https://wp-cli.org/</a></li>
<li>Fail2ban: <a href="https://www.fail2ban.org/">https://www.fail2ban.org/</a></li>
<li>ClamAV: <a href="https://www.clamav.net/">https://www.clamav.net/</a></li>
<li>PhpMyAdmin: <a href="https://www.phpmyadmin.net/">https://www.phpmyadmin.net/</a></li>
<li>tinyfilemanager: <a href="https://tinyfilemanager.github.io/">https://tinyfilemanager.github.io/</a></li>
</ul>

<h3>Liên hệ với tác giả</h3>
<ul>
<li>Trang chủ: <a href="https://wptangtoc.com">WP Tăng Tốc</a></li>
<li>Email: <a href="mailto:giatuan@wptangtoc.com">giatuan@wptangtoc.com</a></li>
<li>Số Điện Thoại: 0866880462</li>
</ul>

<h3>Tác giả phần mềm</h3>
<ul>
<li>Người phát triển dự án : <a href="https://wptangtoc.com/gia-tuan/">Gia Tuấn</a> và cộng đồng Tăng Tốc WordPress</li>
</ul>

<h3>Thảo luận giải đáp các thắc mắc: </h3>

<ul>
<li>Group facebook : <a href="https://www.facebook.com/groups/wptangtoc/">Cộng đồng tăng tốc WordPress 2023</a></li>
</ul>


<h3>ChangeLog: </h3>
<ul>
<li>Nhật ký cập nhật phát triển : <a href="https://wptangtoc.com/changelog-wptangtoc-ols/">Changelog – WPTangToc OLS</a></li>
</ul>


<h3>Tính năng gồm có: </h3>
<ul>
<li>Sao lưu và khôi phục website</li>
<li>Sao lưu website tự động</li>
<li>Sao lưu database</li>
<li>Hỗ trợ Google Drive và Onedrive lưu trữ đám mây backup website</li>
<li>Preload Cache</li>
<li>Không giới hạn thêm domain</li>
<li>Cài đặt SSL miễn phí và gia hạn tự động vĩnh viễn</li>
<li>Hỗ trợ cài đặt SSL trả phí</li>
<li>Có thể thêm không giới hạn website</li>
<li>PhpSuExec mỗi một website một user, để nâng cao bảo mật và dễ dùng quản lý tài nguyên</li>
<li>Hỗ trợ: opacache, object cache, page cache html, trình duyệt cache</li>
<li>Tối ưu wp cron</li>
<li>Tối ưu database</li>
<li>Hỗ trợ nhiều phiên bản PHP cùng lúc</li>
<li>Hỗ trợ PHPMyAdmin và FileManager</li>
<li>Hỗ trợ php ioncube</li>
<li>Sử dụng LSPHP tùy biến hiệu suất tốt hơn PHP Thuần</li>
<li>Hỗ trợ kích hoạt giao thức QUIC http/3 mới nhất</li>
<li>Chống brute force WordPress</li>
<li>Chống DDOS</li>
<li>Hỗ trợ nhiều IP cùng lúc trên máy chủ</li>
<li>Đăng nhập username riêng domain</li>
<li>LockDown WordPress</li>
<li>Quét virus</li>
<li>Khóa IP</li>
<li>Chống ddos</li>
<li>Sao chép website</li>
<li>Giả lập website</li>
<li>Chuyển MYISAM sang INNODB</li>
<li>Chống scan port</li>
<li>Quản lý Database</li>
<li>Quản lý PHP</li>
<li>Quản lý SSH</li>
<li>Quản lý Cache</li>
<li>Thiết lập SSL trả phí</li>
<li>Quản lý Swap</li>
<li>Mod Security</li>
<li>Hỗ trợ backup đám mây(Google Drive hoặc Onedrive)</li>
<li>Quản lý Wordpress</li>
<li>Hỗ trợ tự động update WPTangToc OLS</li>
<li>Hỗ trợ chặn quốc gia truy cập website hoặc chỉ cho quốc gia nào đó được phép truy cập thôi</li>
<li>Cảnh báo login ssh</li>
<li>Cảnh báo service webserver quan trọng và tự động reboot lại service đó nếu nó dừng hoạt động</li>
<li>Vân vân và mây mây...</li>
</ul>

<h3>License: GPLv3</h3>

Đây là phần mềm miễn phí cống hiến cho cộng đồng đặc biệt dành cho cộng đồng Việt Nam; bạn có thể phân phối lại và hoặc sửa đổi nó theo các điều khoản của Giấy phép Công cộng GNU GPLv3 theo tiêu chuẩn quốc tế.

Phần mềm này bạn được phép phân phối sửa đổi với hy vọng rằng nó sẽ hữu ích hơn cho cộng đồng.

