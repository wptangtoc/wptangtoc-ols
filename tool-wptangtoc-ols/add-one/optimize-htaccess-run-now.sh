#!/bin/bash
. /etc/wptt/core-functions 2>/dev/null
# @author: Gia Tuấn
# @website: https://wptangtoc.com

shopt -s nullglob
for filepath in /etc/wptt/vhost/.*.conf; do
    domain="${filepath##*/}"
    domain="${domain%.conf}"
    domain="${domain#.}"

    if [[ "$domain" == ?*.?* ]]; then
        /bin/bash /etc/wptt/wptt-htaccess-tat-chuyen-doi-vhost "$domain" --no-reload >/dev/null 2>&1
    fi
done
shopt -u nullglob

wptt_smart_reload_lsws
