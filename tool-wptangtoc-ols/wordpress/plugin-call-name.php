<?php
if ( ! function_exists( 'get_plugins' ) ) {
    // Kiểm tra xem ABSPATH đã được định nghĩa chưa (chạy qua wp cli thì thường có)
    if ( ! defined('ABSPATH') ) {
         // Cố gắng tìm wp-load.php - điều này có thể không đáng tin cậy 100%
         $wp_load_path = dirname(__FILE__);
         while( ! file_exists( $wp_load_path . '/wp-load.php') ) {
            $wp_load_path = dirname($wp_load_path);
            if( $wp_load_path === '/' || empty($wp_load_path) ) break; // Ngăn vòng lặp vô hạn
         }
         if ( file_exists( $wp_load_path . '/wp-load.php') ) {
            define( 'WP_LOAD_IMPORTER', true ); // Thêm cờ để tránh một số lỗi tiềm ẩn khi load wp-load
            require_once( $wp_load_path . '/wp-load.php' );
         } else {
            echo "Lỗi: Không thể tìm thấy wp-load.php để tải môi trường WordPress.\n";
            exit(1);
         }
    }
    // Bây giờ ABSPATH đã được định nghĩa, chúng ta có thể require file plugin.php
    require_once ABSPATH . 'wp-admin/includes/plugin.php';
}

// Lấy danh sách tất cả plugin
$all_plugins = get_plugins();

// Kiểm tra xem có plugin nào không
if ( empty( $all_plugins ) ) {
    echo "Không tìm thấy plugin nào được cài đặt.\n";
    exit; // Thoát nếu không có plugin
}


// Duyệt qua từng plugin trong danh sách
foreach ( $all_plugins as $plugin_file => $plugin_data ) {

    // Lấy tên hiển thị của plugin, nếu không có thì dùng 'N/A'
    $name = $plugin_data['Name'] ?? 'N/A';

    // Xác định slug (tên thư mục) từ đường dẫn file plugin
    $slug = '';
    if ( strpos( $plugin_file, '/' ) !== false ) {
        // Nếu $plugin_file chứa '/', nó nằm trong thư mục. Slug là tên thư mục.
        $slug = dirname( $plugin_file );
        // dirname('.') có thể trả về '.' nếu file nằm ngay trong wp-content/plugins
        // nên ta xử lý trường hợp này để lấy tên file làm slug
         if ( $slug === '.' ) {
             $slug = basename( $plugin_file, '.php' );
         }
    } else {
        // Nếu không chứa '/', nó là file đơn lẻ. Slug là tên file không có .php.
        $slug = basename( $plugin_file, '.php' );
    }

	echo $name . ' (' . $slug . ')' . "\n";
}

?>
