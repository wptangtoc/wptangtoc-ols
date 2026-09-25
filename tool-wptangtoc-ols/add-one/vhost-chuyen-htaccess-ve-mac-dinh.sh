#!/bin/bash
. /etc/wptt/core-functions 2>/dev/null
# @author: Gia Tuấn
# @website: https://wptangtoc.com

# 1. Dọn dẹp Cronjob cũ (Đề phòng hệ thống chưa sạch)
  
# rm -f /etc/cron.d/optimize-htaccess-wptangtoc-ols-premium* 2>/dev/null
  
# cat <(crontab -l 2>/dev/null | grep -v 'wptt_smart_reload_lsws') | crontab - 2>/dev/null

# if grep -q "Ubuntu" /etc/*release 2>/dev/null; then
#     systemctl restart cron.service >/dev/null 2>&1
# else
#     systemctl restart crond.service >/dev/null 2>&1
# fi

# 2. Vòng lặp Khôi phục .htaccess (Sử dụng shopt nullglob chống lỗi)
shopt -s nullglob
for filepath in /etc/wptt/vhost/.*.conf; do
    domain="${filepath##*/}"
    domain="${domain%.conf}"
    domain="${domain#.}"

    if [[ "$domain" == ?*.?* ]]; then
        . /etc/wptt/wptt-vhost-chuyen-ve-htaccess "$domain" >/dev/null 2>&1
    fi
done

# 3. Reload lại Watcher
(/etc/wptt/cau-hinh/htaccess-apply)
systemctl restart wptt-htaccess >/dev/null 2>&1
