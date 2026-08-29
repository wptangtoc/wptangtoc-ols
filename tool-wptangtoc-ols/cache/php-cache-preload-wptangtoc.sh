#!/bin/bash
# shellcheck disable=SC1090,SC1091,SC2154,SC2317

NAME="$1"
if [[ -n "$1" ]]; then
  # Bọc ngoặc kép toàn bộ đường dẫn
  if [[ ! -f "/etc/wptt/vhost/.${NAME}.conf" ]]; then
    NAME=''
  fi
fi

if [[ -z "$NAME" ]]; then
  # Dùng biến nội tại $PWD an toàn hơn gọi pwd
  CURRENT_DIR="$PWD"
  NAME=$(echo "$CURRENT_DIR" | cut -f1-6 -d '/' | cut -f5 -d '/')
fi

if [[ -z "$NAME" ]]; then
  echo "Không xác định được tên website cần thực thi"
  return 2>/dev/null || exit 1
fi

if [[ -f "/usr/local/lsws/$NAME/html/wp-content/plugins/wptangtoc/class/PreloadAllPHP.php" ]]; then
  PATH='/root/.local/bin:/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin' #bien moi truong full day du
  
  # Bọc ngoặc kép an toàn cho đường dẫn include
  . "/etc/wptt/vhost/.${NAME}.conf" 2>/dev/null
  . "/etc/wptt/php/php-cli-domain-config" "$NAME" 2>/dev/null
  
  echo "Preload Cache PHP html cache website $NAME: $(date '+%d-%m-%Y %H:%M')" >> /var/log/wptangtoc-ols.log

  # Bọc ngoặc kép chuẩn chỉ cho các biến của Runuser và WP-CLI
  /sbin/runuser -u "$User_name_vhost" -- /usr/local/lsws/lsphp"${phien_ban_php_domain_thuc_thi}"/bin/php /usr/local/bin/wp eval 'WPTangToc\PreloadAllPHP::preload_cache();' --allow-root --path="/usr/local/lsws/$NAME/html" >/dev/null 2>&1

  random=$(tr -dc '0-9' </dev/urandom | head -c 10)
  
  # Bọc toàn bộ URL vào một cặp ngoặc kép duy nhất
  curl -s "https://${NAME}/?wptangtoc_cache=${random}" -A "WPTangToc OLS preload cache" >/dev/null 2>&1
  
  echo "Triển khai Preload Cache PHP"
fi
