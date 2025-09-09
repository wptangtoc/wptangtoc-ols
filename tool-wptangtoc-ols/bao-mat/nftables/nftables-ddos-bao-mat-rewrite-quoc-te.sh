#!/bin/bash

#hỗ trợ OverConnHardLimit và cấu trúc htaccess bảo mật

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

dnf install jq golang -y
systemctl mask iptables
systemctl stop fail2ban
systemctl disable fail2ban
systemctl mask fail2ban

if [[ ! -f /etc/systemd/system/ddos-blocker-xdp.service ]]; then
  if [[ ! -f /etc/systemd/system/ddos-blocker-nftables.service ]]; then
    mkdir -p /usr/local/lsws/$NAME/bao-mat
    cp -f /etc/wptt/bao-mat/nftables/anti.go /usr/local/lsws/$NAME/bao-mat/anti.go

    ip=$(curl -skf --connect-timeout 5 --max-time 10 https://ipv4.icanhazip.com | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' || curl -skf --connect-timeout 5 --max-time 10 https://checkip.amazonaws.com | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)')

    sed -i "/var whitelistIPs/a \"$ip\"," /usr/local/lsws/$NAME/bao-mat/anti.go
    chmod +x /usr/local/lsws/$NAME/bao-mat/anti.go
    cd /usr/local/lsws/$NAME/bao-mat && go build anti.go && chmod +x anti
    rm -f /usr/local/bin/anti
    mv /usr/local/lsws/$NAME/bao-mat/anti /usr/local/bin/
    # rm -rf /usr/local/lsws/$NAME/bao-mat
    echo '
[Unit]
Description=Go Lang Log Blocker for Litespeed
Documentation=https://your-doc-link.com
After=network.target nftables.service

[Service]
ExecStart=/usr/local/bin/anti

Restart=always

User=root
Group=root

RestartSec=5s

[Install]
WantedBy=multi-user.target
' >/etc/systemd/system/ddos-blocker-nftables.service
    setenforce 0
    sed -i 's/=enforcing/=disabled/g' /etc/selinux/config
    systemctl daemon-reload
    systemctl start ddos-blocker-nftables
    systemctl enable ddos-blocker-nftables
  fi
fi
# sed -i '/log_file_path =/d' /usr/local/lsws/$NAME/bao-mat/anti.py
# sed -i "/__main__/a\ \ \ \ log_file_path = \"/usr/local/lsws/$NAME/logs/access.log\"" /usr/local/lsws/$NAME/bao-mat/anti.py

cat <(crontab -l) | sed "/bao-mat/d" | crontab -
cat <(crontab -l) | sed "/truncate/d" | crontab -

cat <(crontab -l) <(echo "*/2 * * * * truncate -s 0 /usr/local/lsws/logs/error.log") | crontab -

if $(cat /etc/*release | grep -q "Ubuntu"); then
  path_nftables_config="/etc/nftables.conf"
else
  path_nftables_config="/etc/sysconfig/nftables.conf"
fi

#file config /etc/sysconfig/nftables.conf

if [[ $(cat $path_nftables_config | grep 'ipvietnam') = '' ]]; then

  if $(cat /etc/*release | grep -q "ubuntu"); then
    cp -f /etc/wptt/bao-mat/nftables/nftables-khong-block-quoc-gia.conf $path_nftables_config
  else
    cp -f /etc/wptt/bao-mat/nftables/nftables-khong-block-quoc-gia.conf $path_nftables_config
  fi

  chmod 600 $path_nftables_config

  #mở port ssh
  port_checkssh=$(cat /etc/ssh/sshd_config | grep "Port " | grep -o '[0-9]\+$')
  if [[ $port_checkssh = '' ]]; then
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

#google=$(curl -s  https://developers.google.com/static/search/apis/ipranges/googlebot.json | jq '.prefixes| .[]|.ipv4Prefix' | sed '/null/d'|  sed 's/"//g' | sed 's/ /\n/g'| sed '/^$/d')
#google=$(echo $google | sed 's/ /, /g')
#google=$(echo $google | sed 's/^/{ /g' | sed 's/$/ }/g')

#nft add element inet filter GGv4 $google

#ip_elements_bing=$(nft list set inet filter BINGv4 | awk '/{ /,/}/' | cut -d '=' -f 2)
#nft delete element inet filter BINGv4 ${ip_elements_bing}
#bing_ip=$(curl -s https://www.bing.com/toolbox/bingbot.json | jq '.prefixes| .[]|.ipv4Prefix' | sed '/null/d'|  sed 's/"//g'|sed 's/ /\n/g' | sed 's/^/\n/g'|sed '/^$/d')
#bing_ip=$(echo $bing_ip | sed 's/ /, /g')
#bing_ip=$(echo $bing_ip | sed 's/^/{ /g' | sed 's/$/ }/g')
#nft add element inet filter BINGv4 $bing_ip

##chặn tấn công SYN food
##nft add rule inet filter input tcp flags syn limit rate 100/second burst 200 packets accept

#nft list ruleset > $path_nftables_config

. /etc/wptt/logs/error-chuyen-warn-log-server

systemctl restart nftables

if $(cat /etc/*release | grep -q "AlmaLinux\|Rocky\|CentOS"); then
  systemctl restart crond
else
  systemctl restart cron
fi
echo "hoàn tất thiết lập nftables chống ddos"
