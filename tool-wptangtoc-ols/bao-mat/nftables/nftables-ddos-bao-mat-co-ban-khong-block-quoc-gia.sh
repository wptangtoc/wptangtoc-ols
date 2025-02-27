#!/bin/bash

nftables_service=$(systemctl status nftables.service 2>/dev/null | grep 'Active' | cut -f2 -d':' | xargs | cut -f1 -d' ' | xargs)
if [[ "$nftables_service" != "active" ]]; then
echo "nftables chưa được cài đặt vui lòng cài đặt nftables"
exit
fi

. /etc/wptt/tenmien
echo ""
echo ""
echo "Lựa chọn triển khai ddos nftables:"
echo ""
lua_chon_NAME
. /etc/wptt/echo-color
if [[ "$NAME" = "0" || "$NAME" = "" ]]; then
    . /etc/wptt/wptt-wordpress-main 1
fi

pathcheck="/etc/wptt/vhost/.$NAME.conf"
if [[ ! -f "$pathcheck" ]]; then
    clear
	echoDo "Tên miền không tồn tại trên hệ thống này"
    sleep 3
    . /etc/wptt/wptt-wordpress-main 1
    exit
fi


dnf install python3 jq -y

systemctl mask iptables
systemctl stop fail2ban
systemctl disable fail2ban
systemctl mask fail2ban

mkdir -p /usr/local/lsws/$NAME/bao-mat
cp -f /etc/wptt/bao-mat/nftables/anti2.py /usr/local/lsws/$NAME/bao-mat/anti.py

if $(cat /etc/*release | grep -q "AlmaLinux\|Rocky\|CentOS") ; then
systemctl restart crond
else
systemctl restart cron
fi

chmod +x /usr/local/lsws/$NAME/bao-mat/anti.py

# sed -i '/log_file_path =/d' /usr/local/lsws/$NAME/bao-mat/anti.py
# sed -i "/__main__/a\ \ \ \ log_file_path = \"/usr/local/lsws/$NAME/logs/access.log\"" /usr/local/lsws/$NAME/bao-mat/anti.py

cat <(crontab -l) | sed "/bao-mat/d" | crontab -
cat <(crontab -l) | sed "/truncate/d" | crontab -


cat <(crontab -l) <(echo "* * * * * /usr/bin/python3 /usr/local/lsws/$NAME/bao-mat/anti.py >/dev/null 2>&1") | crontab -
cat <(crontab -l) <(echo "* * * * * sleep 10; /usr/bin/python3 /usr/local/lsws/$NAME/bao-mat/anti.py >/dev/null 2>&1") | crontab -
cat <(crontab -l) <(echo "* * * * * sleep 20; /usr/bin/python3 /usr/local/lsws/$NAME/bao-mat/anti.py >/dev/null 2>&1") | crontab -
cat <(crontab -l) <(echo "* * * * * sleep 30; /usr/bin/python3 /usr/local/lsws/$NAME/bao-mat/anti.py >/dev/null 2>&1") | crontab -
cat <(crontab -l) <(echo "* * * * * sleep 40; /usr/bin/python3 /usr/local/lsws/$NAME/bao-mat/anti.py >/dev/null 2>&1") | crontab -
cat <(crontab -l) <(echo "* * * * * sleep 50; /usr/bin/python3 /usr/local/lsws/$NAME/bao-mat/anti.py >/dev/null 2>&1") | crontab -
cat <(crontab -l) <(echo "*/2 * * * * truncate -s 0 /usr/local/lsws/logs/error.log") | crontab -


	if $(cat /etc/*release | grep -q "Ubuntu") ; then
		path_nftables_config="/etc/nftables.conf"
	else
		path_nftables_config="/etc/sysconfig/nftables.conf"
	fi

#file config /etc/sysconfig/nftables.conf


if [[ $(cat $path_nftables_config | grep 'ipvietnam') = '' ]];then

	if $(cat /etc/*release | grep -q "ubuntu") ; then
		cp -f /etc/wptt/bao-mat/nftables/nftables-khong-block-quoc-gia.conf $path_nftables_config
	else
		cp -f /etc/wptt/bao-mat/nftables/nftables-khong-block-quoc-gia.conf $path_nftables_config
	fi

	chmod 600 $path_nftables_config

#mở port ssh
port_checkssh=$(cat /etc/ssh/sshd_config | grep "Port " | grep -o '[0-9]\+$')
if [[ $port_checkssh = '' ]];then
port_checkssh=22
fi

sed -i "/chain input /a\ \ tcp dport $port_checkssh accept #port ssh" $path_nftables_config
systemctl restart nftables

path_webgui="/usr/local/lsws/conf/disablewebconsole"
if [[ ! -f $path_webgui ]]; then
port_webgui_openlitespeed=$(cat /usr/local/lsws/admin/conf/admin_config.conf | grep "address" | grep -o '[0-9]\+$')
sed -i "/chain input /a\ \ tcp dport $port_webgui_openlitespeed accept #port webguiadmin" $path_nftables_config
systemctl restart nftables
fi


fi




nft list ruleset > /etc/sysconfig/nftables.conf

ip=$(curl -s myip.directadmin.com)
if [[ "$ip" = "" ]]; then
	ip=$(curl -s ifconfig.me)
fi

. /etc/wptt/logs/error-chuyen-warn-log-server


systemctl restart nftables

echo "hoàn tất thiết lập nftables chống ddos"
