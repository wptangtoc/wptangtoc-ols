<div align="center">
    <img src="https://wptangtoc.com/wp-content/uploads/2021/06/logo-wp-tang-toc.png" alt="WPTangToc OLS Logo" width="300">
    <h1>🚀 WPTangToc OLS</h1>
    <p><b>Giải pháp Thiết lập & Quản trị Webserver Miễn phí, Siêu tốc độ, Dành riêng cho WordPress</b></p>
    <p>
        <img src="https://img.shields.io/badge/License-GPLv3-blue.svg" alt="License GPLv3">
        <img src="https://img.shields.io/badge/Optimized%20for-WordPress-21759b.svg" alt="Optimized for WordPress">
        <img src="https://img.shields.io/badge/Architecture-x86__64%20%7C%20ARM-success.svg" alt="Architecture">
    </p>
</div>

<hr>

<h2>🌟 Sứ mệnh của chúng tôi</h2>
<p>Sứ mệnh của WPTangToc OLS là mang đến một hệ sinh thái máy chủ hoàn hảo, nơi hiệu năng chạm đỉnh và bảo mật được đặt lên hàng đầu. Đây không chỉ là một Bash Script cài đặt đơn thuần, mà là kết tinh của hàng ngàn giờ tối ưu hóa chuyên sâu. Chúng tôi tập trung <b>100% nguồn lực vào mã nguồn WordPress</b>, giúp các Sysadmin từ tay ngang đến chuyên nghiệp quản trị máy chủ một cách mượt mà, nhàn nhã và mạnh mẽ nhất.</p>

<h2>🔥 Tại sao bạn nên chọn WPTangToc OLS?</h2>
<ul>
    <li>⚡ <b>Hiệu năng xé gió:</b> Tích hợp OpenLiteSpeed, LSPHP tùy biến (nhanh hơn PHP-FPM thuần), Giao thức HTTP/3 QUIC, và tối ưu Object Cache (Redis/Memcached/Valkey) ở mức tầng UNIX Socket sâu nhất.</li>
    <li>🛡️ <b>Bảo mật cô lập tuyệt đối:</b> Sử dụng công nghệ <code>PhpSuExec + Chroot + Namespace</code> để giam lỏng (cô lập) từng website. Nếu một trang web trên máy chủ bị hack, hacker cũng vĩnh viễn không thể "cháy lan" sang các trang web khác.</li>
    <li>🤖 <b>Tự động hóa thông minh:</b> Mọi thao tác cấu hình phức tạp, tối ưu Database, hay quản lý Firewall đều được giải quyết tự động chỉ bằng phím bấm.</li>
    <li>☁️ <b>Bảo vệ dữ liệu toàn diện (Zero Data Loss):</b> Hệ thống sao lưu thông minh vận hành hoàn toàn tự động đóng gói và đẩy thẳng dữ liệu của bạn lên đa nền tảng Cloud (Amazon S3, Google Drive, OneDrive, Telegram, Cloudflare R2...). Giải phóng bạn khỏi nỗi lo rủi ro phần cứng, đảm bảo website luôn có sẵn phương án khôi phục thần tốc trước mọi sự cố hay thảm họa không lường trước.</li>
</ul>

<hr>

<h2>💻 Hệ điều hành & Cấu hình hỗ trợ</h2>

<h3>🐧 Hệ điều hành Linux (Kiến trúc x86_64 & ARM)</h3>
<ul>
    <li><b>AlmaLinux:</b> 8, 9, 10 <i>(Khuyên dùng: AlmaLinux 9)</i> 🏆</li>
    <li><b>Rocky Linux:</b> 8, 9, 10</li>
    <li><b>Red Hat Enterprise Linux (RHEL):</b> 8, 9, 10</li>
    <li><b>Oracle Linux Server:</b> 8, 9</li>
    <li><b>Ubuntu:</b> 22.04, 24.04 <i>(Thử nghiệm)</i></li>
</ul>

<h3>⚙️ Cấu hình yêu cầu</h3>
<ul>
    <li><b>Tối thiểu:</b> CPU 1 vCore | RAM > 512MB | Ổ cứng > 8GB</li>
    <li><b>Khuyến nghị:</b> CPU 1 vCore | RAM > 2GB | Ổ cứng > 20GB</li>
</ul>
<p><i>💡 Lời khuyên: Nếu bạn chưa có VPS, hãy chọn các nhà cung cấp uy tín để có trải nghiệm tốt nhất với phần mềm.</i></p>

<hr>

<h2>⚡ Hướng dẫn cài đặt</h2>

<h3>Cách 1: Cài đặt tiêu chuẩn (Có tương tác)</h3>
<p>Bạn chỉ cần dán đoạn mã này vào Terminal (quyền <code>root</code>), hệ thống sẽ chạy và có menu hỏi bạn một số thiết lập cơ bản:</p>
<pre><code>curl -sO https://wptangtoc.com/share/wptangtoc-ols && bash wptangtoc-ols</code></pre>
<p><i>Link dự phòng từ GitHub:</i></p>
<pre><code>curl -sO https://raw.githubusercontent.com/wptangtoc/wptangtoc-ols/refs/heads/main/wptangtoc-ols && bash wptangtoc-ols</code></pre>

<h3>Cách 2: 🤖 Cài đặt Không Chạm (Unattended / Zero-Touch)</h3>
<p>Tuyệt chiêu dành cho các Sysadmin muốn triển khai hạ tầng hàng loạt (Mass Deployment) qua Ansible, Cloud-Init, hãng VPS đóng template hoặc đơn giản là bạn "lười" bấm phím. Chỉ cần thêm cờ <code>--auto</code>, phần mềm sẽ <b>tự động bỏ qua mọi câu hỏi</b>, áp dụng ngay cấu hình mặc định an toàn, ổn định và nhanh nhất do tác giả định chuẩn (PHP 8.3, MariaDB Stable 10.11, Port mặc định).</p>
<pre><code>curl -sO https://wptangtoc.com/share/wptangtoc-ols && bash wptangtoc-ols --auto</code></pre>

<hr>

<h2>🛠️ Danh sách Tính năng Đồ sộ</h2>
<p>WPTangToc OLS bao gồm đầy đủ các tính năng mà một System Admin chuyên nghiệp cần tới:</p>
<ul>
    <li><b>Nền tảng lõi:</b> OpenLiteSpeed + LSPHP (Hỗ trợ nhiều phiên bản từ 7.1 đến 8.5 chạy song song) + MariaDB (10.6 đến 12.3).</li>
    <li><b>Quản lý Website:</b> Thêm không giới hạn Domain/Subdomain, Sao chép nhân bản website (Clone), Giả lập môi trường test (Staging).</li>
    <li><b>Cache Đa tầng:</b> Hỗ trợ đầy đủ OPcache, Page Cache HTML, Browser Cache, Object Cache (Redis, Memcached, Valkey, KeyDB).</li>
    <li><b>Bảo mật toàn diện:</b> Cài đặt SSL Let's Encrypt miễn phí tự động gia hạn vĩnh viễn, Tường lửa 8G Firewall, CSF/Firewalld/NFtables, ClamAV Antivirus, Chống Brute Force, Khóa IP, Chặn truy cập theo Quốc gia.</li>
    <li><b>Quản trị Database & File:</b> Tích hợp PHPMyAdmin và TinyFileManager an toàn trực tiếp trên trình duyệt. Chuyển đổi siêu tốc Engine MySQL (InnoDB, MyISAM, Aria).</li>
    <li><b>Tự động hóa hệ thống:</b> Tự động sao lưu Database & Source Code, Đẩy Backup lên Cloud, Cảnh báo đăng nhập SSH qua Telegram, Tự động restart dịch vụ khi bị treo.</li>
    <li><b>Giám sát:</b> Theo dõi lưu lượng mạng, CPU, RAM theo thời gian thực (wtop).</li>
</ul>

<hr>

<h2>📚 Nguồn tài liệu & Cộng đồng hỗ trợ</h2>
<ul>
    <li><b>Trang chủ & Hướng dẫn chi tiết:</b> <a href="https://wptangtoc.com/wptangtoc-ols/">Tại đây</a></li>
    <li><b>Nhật ký cập nhật (Changelog):</b> <a href="https://wptangtoc.com/changelog-wptangtoc-ols/">Tại đây</a></li>
    <li><b>Cộng đồng hỗ trợ:</b> Tham gia <a href="https://www.facebook.com/groups/wptangtoc/">Group Tăng Tốc WordPress</a> trên Facebook để được giải đáp thắc mắc.</li>
</ul>

<h3>Các đối tác công nghệ mở:</h3>
<p>
    <a href="https://openlitespeed.org/">OpenLiteSpeed</a> | 
    <a href="https://downloads.mariadb.org/">MariaDB</a> | 
    <a href="https://www.php.net/">PHP</a> | 
    <a href="https://wp-cli.org/">WP-CLI</a> | 
    <a href="https://rclone.org/">Rclone</a> | 
    <a href="https://www.fail2ban.org/">Fail2ban</a>
</p>

<hr>

<h2>🤝 Ủng hộ tác giả (Donate)</h2>
<p>Phần mềm này là tâm huyết được phát triển hoàn toàn miễn phí và sẽ luôn như vậy. Dù vậy, bánh mì trên bàn thì không miễn phí. Nếu công cụ này giúp bạn tiết kiệm thời gian, bảo vệ máy chủ an toàn và mang lại doanh thu tốt, hãy tiếp thêm động lực (và bánh mì) để tác giả tiếp tục nâng cấp dự án nhé:</p>
<p>👉 <b><a href="https://wptangtoc.com/donate">Tài trợ tặng bánh mì cho tác giả tại đây</a></b></p>

<hr>

<h2>📞 Liên hệ & Tác giả</h2>
<ul>
    <li><b>Người phát triển:</b> <a href="https://wptangtoc.com/gia-tuan/">Gia Tuấn</a> và cộng đồng Tăng Tốc WordPress.</li>
    <li><b>Email:</b> <a href="mailto:giatuan@wptangtoc.com">giatuan@wptangtoc.com</a></li>
    <li><b>Hotline/Zalo:</b> 0866.880.462</li>
</ul>

<hr>

<hr>

<h2>⚠️ Tuyên Bố Miễn Trừ Trách Nhiệm & Tinh Thần Mã Nguồn Mở (Disclaimer)</h2>
<p>WPTangToc OLS là một dự án mã nguồn mở (Open Source) được chia sẻ hoàn toàn miễn phí vì cộng đồng. Chúng mình xây dựng phần mềm này với tất cả tâm huyết nhằm mang lại giá trị thực tế, tuy nhiên việc sử dụng phần mềm tuân theo các nguyên tắc cốt lõi của hệ sinh thái mã nguồn mở:</p>
<ul>
    <li><b>Bản chất Có sao dùng vậy:</b> Phần mềm được cung cấp nguyên trạng mà không đi kèm với bất kỳ bảo hành hay cam kết tuyệt đối nào. Sự đa dạng cực lớn về môi trường hạ tầng (nhà cung cấp VPS, phiên bản hệ điều hành, cấu hình mạng riêng...) có thể tạo ra các tình huống ngoại lệ nằm ngoài khả năng dự tính của phần mềm.</li>
    <li><b>Sự minh bạch & Quyền tự chủ:</b> Toàn bộ mã nguồn đều được công khai. Bạn có quyền (và được khuyến khích) kiểm tra mã nguồn trước khi thực thi. Do đó, bạn là người làm chủ 100% hệ thống của mình. Tác giả và những người đóng góp sẽ <b>miễn trừ mọi trách nhiệm pháp lý</b> đối với bất kỳ rủi ro nào liên quan đến gián đoạn dịch vụ, xung đột hệ thống, mất mát dữ liệu hay thiệt hại kinh tế phát sinh trực tiếp hoặc gián tiếp từ việc sử dụng phần mềm.</li>
    <li><b>Quy tắc vàng của System Admin:</b> Dữ liệu là tài sản vô giá của bạn. Dù công cụ đã được kiểm thử khắt khe đến đâu, "cẩn tắc vô áy náy". Chúng tôi đặc biệt yêu cầu bạn <b>luôn chủ động tạo Bản sao lưu (Snapshots/Backup)</b> toàn bộ dữ liệu máy chủ trước khi bắt đầu cài đặt, nâng cấp, hoặc gỡ bỏ bất kỳ thành phần nào.</li>
</ul>
<p><i>Bằng việc chạy các tập lệnh của WPTangToc OLS, bạn đồng ý với tinh thần chia sẻ của cộng đồng mã nguồn mở, thấu hiểu các rủi ro kỹ thuật hiện hữu và tự chịu trách nhiệm hoàn toàn đối với máy chủ cũng như dữ liệu của chính mình.</i></p>

<h2>⚖️ Bản quyền (License)</h2>
<p><b>GPLv3</b></p>
<p>Đây là dự án cống hiến cho cộng đồng mã nguồn mở (đặc biệt là cộng đồng System Admin tại Việt Nam). Bạn hoàn toàn có quyền sử dụng, phân phối lại hoặc sửa đổi nó theo các điều khoản của Giấy phép Công cộng GNU (GPLv3) tiêu chuẩn quốc tế, với hy vọng rằng nó sẽ giúp ích và làm cho môi trường web trở nên tốt đẹp hơn.</p>

