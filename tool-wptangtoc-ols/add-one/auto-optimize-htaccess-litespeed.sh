#!/bin/bash
# shellcheck disable=SC1091
for entry_path in /etc/wptt/vhost/.*.conf; do
	# Bỏ qua nếu không có file nào khớp
	[[ -e "$entry_path" ]] || continue
	
	entry=$(basename "$entry_path")
	
	# Bỏ qua thư mục hiện tại (.) và thư mục cha (..)
	[[ "$entry" == "." || "$entry" == ".." ]] && continue
	
	domain_optimize_htaccess="${entry#.}"
	domain_optimize_htaccess="${domain_optimize_htaccess%.conf}"
	
	if [ "$domain_optimize_htaccess" != "${domain_optimize_htaccess/./}" ] && [ "$domain_optimize_htaccess" != '.' ]; then #điều kiện domain phải có dấu . và lỗi chỉ có only .
		vhost_FILE="/usr/local/lsws/conf/vhosts/$domain_optimize_htaccess/$domain_optimize_htaccess.conf"
		htaccess_path="/usr/local/lsws/$domain_optimize_htaccess/html/.htaccess"
		
		# Bọc ngoặc kép cho biến đường dẫn để an toàn tuyệt đối
		if [[ -f "$htaccess_path" && -f "$vhost_FILE" ]];then
			if [ "$htaccess_path" -nt "$vhost_FILE" ]; then
				. /etc/wptt/wptt-htaccess-tat-chuyen-doi-vhost "$domain_optimize_htaccess" >/dev/null 2>&1
			fi
		fi
	fi
done
