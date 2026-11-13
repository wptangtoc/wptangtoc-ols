#!/bin/bash
. /etc/wptt/core-functions 2>/dev/null
# shellcheck disable=SC1090,SC1091,SC2154,SC2317

NAME="$1"
if [[ -n "$NAME" ]]; then
	if [[ ! -f "/etc/wptt/vhost/.${NAME}.conf" ]]; then
		NAME=""
	fi
fi

if [[ -z "$NAME" ]]; then
	# Bóc tách tên domain từ $PWD thuần Bash (ví dụ: /usr/local/lsws/domain.com/html -> domain.com) mà không tốn subshell cut
	if [[ "$PWD" =~ ^/usr/local/lsws/([^/]+) ]]; then
		NAME="${BASH_REMATCH[1]}"
	fi
fi

if [[ -z "$NAME" || ! -f "/etc/wptt/vhost/.${NAME}.conf" ]]; then
	echo "Không xác định được tên website cần thực thi"
	return 1 2>/dev/null || exit 1
fi

WP_PATH="/usr/local/lsws/${NAME}/html"
PRELOAD_CLASS="${WP_PATH}/wp-content/plugins/wptangtoc/class/PreloadAllPHP.php"

if [[ -f "$PRELOAD_CLASS" ]]; then
	export PATH="/root/.local/bin:/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"

	wptt_load_vhost_conf "/etc/wptt/vhost/.${NAME}.conf" 2>/dev/null

	if ! . /etc/wptt/php/php-cli-domain-config "$NAME"; then
		wptt_logs "ERROR" "Không thể lấy cấu hình PHP cho domain $NAME (thư viện php-cli-domain-config thất bại)."
		_runloi "Không xác định được phiên bản PHP"
		return 1 2>/dev/null || exit 1
	fi

	PHP_BIN="/usr/local/lsws/lsphp${phien_ban_php_domain_thuc_thi}/bin/php"
	WP_CLI="/usr/local/bin/wp"

	# 1. Khởi tạo danh sách URL vào preload-wptangtoc-url.txt và đặt lịch Cron với đúng quyền User sở hữu web
	# Truyền --url="https://${NAME}" để WP-CLI luôn tạo đúng Permalink theo tên miền thật (không bao giờ dính localhost)
	if /sbin/runuser -u "$User_name_vhost" -- "$PHP_BIN" "$WP_CLI" eval 'if (class_exists("WPTangToc\\PreloadAllPHP")) { WPTangToc\PreloadAllPHP::preload_cache(); }' --path="$WP_PATH" >/dev/null 2>&1; then
		wptt_logs "INFO" "Preload Cache PHP html cache website $NAME"
	else
		wptt_logs "ERROR" "Preload Cache PHP html cache website $NAME"
	fi

	echo "Triển khai Preload Cache PHP hoàn tất cho $NAME"
fi
