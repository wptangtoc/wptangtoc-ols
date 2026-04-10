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

if [[ -z $NAME ]]; then
  echo "Không xác định được tên website cần thực thi"
  return 2>/dev/null || exit
fi

if [[ -f /usr/local/lsws/$NAME/html/wp-content/plugins/wptangtoc/class/PreloadAllPHP.php ]]; then
  PATH='/root/.local/bin:/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin' #bien moi truong full day du
  . /etc/wptt/vhost/.$NAME.conf
  . /etc/wptt/php/php-cli-domain-config $NAME
  # /usr/local/lsws/lsphp${phien_ban_php_domain}/bin/php /usr/local/bin/wp eval 'WPTangToc\PreloadAllPHP::preload_cache();' --allow-root --path=/usr/local/lsws/$NAME/html >/dev/null 2>&1
  echo "Preload Cache PHP html cache website $NAME: $(date '+%d-%m-%Y %H:%M')" >>/var/log/wptangtoc-ols.log

  sudo -u $User_name_vhost /usr/local/lsws/lsphp${phien_ban_php_domain_thuc_thi}/bin/php /usr/local/bin/wp eval 'WPTangToc\PreloadAllPHP::preload_cache();' --allow-root --path=/usr/local/lsws/$NAME/html >/dev/null 2>&1

  # chown "$User_name_vhost":"$User_name_vhost" /usr/local/lsws/$NAME/html/wp-content/preload-wptangtoc-url.txt
  # random=$(shuf -i 0-9 -n 10 -r | tr -d '\n')
  random=$(tr -dc '0-9' </dev/urandom | head -c 10)
  curl -s https://"$NAME"/?wptangtoc_cache=${random} -A "WPTangToc OLS preload cache"
  echo "Triển khai Preload Cache PHP"
fi
