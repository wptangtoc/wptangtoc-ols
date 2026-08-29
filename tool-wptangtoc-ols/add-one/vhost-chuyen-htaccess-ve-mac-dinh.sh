#!/bin/bash

rm -f /etc/cron.d/optimize-htaccess-wptangtoc-ols-premium.cron
# cat <(crontab -l) <(echo '*/3 * * * * if ! find /usr/local/lsws/*/html/ -maxdepth 2 -type f -newer /usr/local/lsws/cgid -name '.htaccess' -exec false {} +; then wptt_smart_reload_lsws >/dev/null 2>&1; fi') | crontab -

cat <(crontab -l 2>/dev/null) <(echo '*/3 * * * * if ! find /usr/local/lsws/*/html/ -maxdepth 2 -type f -newer /usr/local/lsws/cgid -name ".htaccess" -exec false {} +; then /bin/bash -c ". /etc/wptt/core-functions && wptt_smart_reload_lsws" >/dev/null 2>&1; fi') | crontab -

if grep -q "Ubuntu" /etc/*release 2>/dev/null; then
	rm -f /etc/cron.d/optimize-htaccess-wptangtoc-ols-premium_cron
	systemctl restart cron.service
else
	systemctl restart crond.service
fi


for filepath in /etc/wptt/vhost/.*.conf; do
	  [[ ! -f "$filepath" || "$filepath" == *"/..conf" ]] && continue

	  domain="${filepath##*/}"
	  domain="${domain%.conf}"
	  domain="${domain#.}"

	  if [[ "$domain" == ?*.?* ]]; then
		  . /etc/wptt/wptt-vhost-chuyen-ve-htaccess "$domain" >/dev/null 2>&1
	  fi
done



