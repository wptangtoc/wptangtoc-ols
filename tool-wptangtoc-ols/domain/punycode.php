<?php
// 1. Lấy dữ liệu và kiểm tra rỗng ngay từ đầu (Chống Notice Error)
$unicodeDomain = isset($_SERVER['argv'][1]) ? trim($_SERVER['argv'][1]) : '';

if (empty($unicodeDomain)) {
    echo ""; // Trả về rỗng để Bash script tự xử lý lỗi
    exit(0);
}

// 2. Fallback (Bảo hiểm): Kiểm tra xem server khách có cài module 'intl' chưa
if (!function_exists('idn_to_ascii')) {
    // Nếu khách quên cài php-intl, thì đành trả về tên miền gốc chưa convert
    // Giúp script không bị chết đứng (Fatal Error)
    echo $unicodeDomain;
    exit(0);
}

// 3. Thực hiện chuyển đổi an toàn
$punycodeDomain = idn_to_ascii($unicodeDomain, 0, INTL_IDNA_VARIANT_UTS46);

// Nếu chuyển đổi thành công thì xuất punycode, nếu lỗi/thất bại thì xuất lại tên miền gốc
echo ($punycodeDomain !== false) ? $punycodeDomain : $unicodeDomain;
exit(0);
?>
