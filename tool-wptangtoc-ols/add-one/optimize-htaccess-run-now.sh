#!/bin/bash
for filepath in /etc/wptt/vhost/.*.conf; do
	[[ ! -f "$filepath" || "$filepath" == *"/..conf" ]] && continue

	domain="${filepath##*/}"
	domain="${domain%.conf}"
	domain="${domain#.}"

	if [[ "$domain" == ?*.?* ]]; then
		. /etc/wptt/wptt-htaccess-tat-chuyen-doi-vhost "$domain" >/dev/null 2>&1
	fi
done


