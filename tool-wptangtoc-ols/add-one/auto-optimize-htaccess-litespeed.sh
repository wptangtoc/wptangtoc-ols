#!/bin/bash
for entry in $(ls -A /etc/wptt/vhost); do
	domain_optimize_htaccess=$(echo "$entry" | sed 's/^.//' | sed 's/.conf//')
	if [ "$domain_optimize_htaccess" != "${domain_optimize_htaccess/./}" ] && [ "$domain_optimize_htaccess" != '.' ]; then #điều kiện domain phải có dấu . và lỗi chỉ có only .
		vhost_FILE="/usr/local/lsws/conf/vhosts/$domain_optimize_htaccess/$domain_optimize_htaccess.conf"
		htaccess_path="/usr/local/lsws/$domain_optimize_htaccess/html/.htaccess"
		if [[ -f $htaccess_path && -f $vhost_FILE ]];then
			if [ "$htaccess_path" -nt "$vhost_FILE" ]; then
				. /etc/wptt/wptt-htaccess-tat-chuyen-doi-vhost "$domain_optimize_htaccess" >/dev/null 2>&1
			fi
		fi
	fi
done
