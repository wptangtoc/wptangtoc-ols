#!/bin/bash

NAME=$1
if [[ $1 ]];then
	if [[ ! -f /etc/wptt/vhost/.$NAME.conf ]];then
		NAME=''
	fi
fi

if [[ $NAME = '' ]];then
pwd=$(pwd)
NAME=$(echo $pwd | cut -f1-6 -d '/'|cut -f5 -d '/')
fi


if [[ $NAME = '' ]];then
	echo "Không xác định được tên website cần thực thi"
	exit
fi
if [[ -f /usr/local/lsws/$NAME/html/wp-content/plugins/wptangtoc/class/PreloadAllPHP.php ]];then
	. /etc/wptt/vhost/.$NAME.conf
	if [[ $phien_ban_php_domain = '' ]];then
		phien_ban_php_domain=$(php -v |grep cli | cut -c 4-7| sed 's/ //g')
	fi
	phien_ban_php_domain=${phien_ban_php_domain//[-._]/}
/usr/local/lsws/lsphp${phien_ban_php_domain}/bin/php /usr/local/bin/wp eval 'WPTangToc\PreloadAllPHP::preload_cache();' --allow-root --path=/usr/local/lsws/$NAME/html >/dev/null 2>&1
chown "$User_name_vhost":"$User_name_vhost" /usr/local/lsws/$NAME/html/wp-content/preload-wptangtoc-url.txt
    random=$(
      date +%s | sha256sum | base64 | head -c 12
      echo
    )
curl -s https://$NAME/?wptangtoc_cache=$random 
echo "Triển khai Preload Cache PHP"
fi
