#!/bin/bash

NAME=$1
if [[ $1 ]]; then
  if [[ ! -f /etc/wptt/vhost/.$NAME.conf ]]; then
    NAME=''
  fi
fi

if [[ $NAME = '' ]]; then
  pwd=$(pwd)
  NAME=$(echo $pwd | cut -f1-6 -d '/' | cut -f5 -d '/')
fi

if [[ $NAME = '' ]]; then
  echo "Không xác định được tên website cần thực thi"
  exit
fi
if [[ -f /usr/local/lsws/$NAME/html/wp-content/plugins/wptangtoc/class/PreloadAllPHP.php ]]; then
  unset phien_ban_php_domain
  . /etc/wptt/vhost/.$NAME.conf
  if [[ -z $phien_ban_php_domain ]]; then
    phien_ban_php_domain=$(php -v | grep cli | grep -oP 'PHP \K[0-9]+\.[0-9]+')
  fi

  if [[ $(echo $phien_ban_php_domain | grep '^lsphp') ]]; then #tương thích ngươcj với thời xưa đặt phiên bản php là lsphp
    phien_ban_php_domain=$(echo $phien_ban_php_domain | sed 's/^lsphp//g')
  fi

  phien_ban_php_domain=${phien_ban_php_domain//[-._]/}
  /usr/local/lsws/lsphp${phien_ban_php_domain}/bin/php /usr/local/bin/wp eval 'WPTangToc\PreloadAllPHP::preload_cache();' --allow-root --path=/usr/local/lsws/$NAME/html >/dev/null 2>&1
  chown "$User_name_vhost":"$User_name_vhost" /usr/local/lsws/$NAME/html/wp-content/preload-wptangtoc-url.txt
  random=$(shuf -i 0-9 -n 10 -r | tr -d '\n')
  curl -s https://$NAME/?wptangtoc_cache=${random} -A "WPTangToc OLS preload cache"
  echo "Triển khai Preload Cache PHP"
fi
