#!/bin/bash
for entry in $(ls -A /etc/wptt/vhost); do
	NAME=$(echo $entry | sed 's/^.//' | sed 's/.conf//')
	if [ "$NAME" != "${NAME/./}" ] && [ "$NAME" != '.' ]; then #điều kiện domain phải có dấu . và lỗi chỉ có only .
		. /etc/wptt/wptt-htaccess-tat-chuyen-doi-vhost $NAME >/dev/null 2>&1
	fi
done


