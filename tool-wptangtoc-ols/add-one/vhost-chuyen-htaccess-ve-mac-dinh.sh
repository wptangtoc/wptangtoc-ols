#!/bin/bash

rm -f /etc/cron.d/optimize-htaccess-wptangtoc-ols-premium.cron
cat <(crontab -l) <(echo '*/3 * * * * if ! find /usr/local/lsws/*/html/ -maxdepth 2 -type f -newer /usr/local/lsws/cgid -name '.htaccess' -exec false {} +; then /usr/local/lsws/bin/lswsctrl reload >/dev/null 2>&1; fi') | crontab -

if $(cat /etc/*release | grep -q "Ubuntu") ; then
	rm -f /etc/cron.d/optimize-htaccess-wptangtoc-ols-premium_cron
	systemctl restart cron.service
else
	systemctl restart crond.service
fi

for entry in $(ls -A /etc/wptt/vhost); do
	NAME=$(echo $entry | sed 's/^.//' | sed 's/.conf//')
	if [ "$NAME" != "${NAME/./}" ] && [ "$NAME" != '.' ]; then #điều kiện domain phải có dấu . và lỗi chỉ có only .
		. /etc/wptt/wptt-vhost-chuyen-ve-htaccess $NAME >/dev/null 2>&1
	fi
done

