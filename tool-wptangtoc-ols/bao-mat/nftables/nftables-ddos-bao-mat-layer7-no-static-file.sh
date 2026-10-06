#!/bin/bash

nftables_service=$(systemctl status nftables.service 2>/dev/null | grep 'Active' | cut -f2 -d':' | xargs | cut -f1 -d' ' | xargs)
if [[ "$nftables_service" != "active" ]]; then
  echo "nftables chưa được cài đặt vui lòng cài đặt nftables"
  exit
fi

. /etc/wptt/tenmien
echo ""
echo ""
echo "Lựa chọn triển khai ddos nftables layer7:"
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

if [[ -f /etc/systemd/system/layer7-ddos-blocker-nftables.service ]]; then
  echo "Đã kích hoạt rồi"
  exit
fi

if [[ $(nft list ruleset | grep 'blackaction') = '' ]]; then
  echo "nftables chưa được thiết lập triển khai chống ddos"
  exit
fi

dnf install golang -y

if [[ ! -f /etc/systemd/system/layer7-ddos-blocker-nftables.service ]]; then
  mkdir -p /usr/local/lsws/$NAME/bao-mat
  cp -f /etc/wptt/bao-mat/nftables/anti-website-layer-7-no-static-file.go /usr/local/lsws/$NAME/bao-mat/anti-website-layer-7.go
  sed -i "s/wptangtoc.com/$NAME/g" /usr/local/lsws/$NAME/bao-mat/anti-website-layer-7.go
  ip=$(curl -skf --connect-timeout 5 --max-time 10 https://ipv4.icanhazip.com | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' || curl -skf --connect-timeout 5 --max-time 10 https://checkip.amazonaws.com | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)')

  mkdir -p /etc/go_blocker/
  echo '103.106.105.75' >>/etc/go_blocker/whitelist.txt
  echo "$ip" >>/etc/go_blocker/whitelist.txt
  sed -i "s/\ /\\n/g" /etc/go_blocker/whitelist.txt
  ip_all=$(cat /etc/go_blocker/whitelist.txt | sort -u)
  echo $ip_all >/etc/go_blocker/whitelist.txt
  sed -i "s/\ /\\n/g" /etc/go_blocker/whitelist.txt

  chmod +x /usr/local/lsws/$NAME/bao-mat/anti-website-layer-7.go
  cd /usr/local/lsws/$NAME/bao-mat && go build anti-website-layer-7.go && chmod +x anti-website-layer-7
  rm -f /usr/local/bin/anti-website-layer-7
  mv /usr/local/lsws/$NAME/bao-mat/anti-website-layer-7 /usr/local/bin/
  # rm -rf /usr/local/lsws/$NAME/bao-mat
  echo '
[Unit]
Description=Go Lang Log Blocker for Litespeed Layer 7
Documentation=https://your-doc-link.com
After=network.target nftables.service

[Service]
ExecStart=/usr/local/bin/anti-website-layer-7

Restart=always

User=root
Group=root

RestartSec=5s

[Install]
WantedBy=multi-user.target
' >/etc/systemd/system/layer7-ddos-blocker-nftables.service
  setenforce 0
  sed -i 's/=enforcing/=disabled/g' /etc/selinux/config
  systemctl daemon-reload
  systemctl start layer7-ddos-blocker-nftables
  systemctl enable layer7-ddos-blocker-nftables
fi

cat <(crontab -l) | sed "/logs\/access.log/d" | crontab -
cat <(crontab -l) <(echo "*/2 * * * * truncate -s 0 /usr/local/lsws/$NAME/logs/access.log") | crontab -
if $(cat /etc/*release | grep -q "AlmaLinux\|Rocky\|CentOS"); then
  systemctl restart crond
else
  systemctl restart cron
fi

echo 'Sử dụng golang kiểm tra access log nếu 3 yêu cầu / 1 giây home page sẽ bị block'
echo "hoàn tất thiết lập nftables chống ddos layer 7"
