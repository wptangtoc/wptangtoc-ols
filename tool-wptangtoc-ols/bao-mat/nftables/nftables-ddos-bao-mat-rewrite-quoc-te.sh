#!/bin/bash
# shellcheck disable=SC1091

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
  exec /etc/wptt/wptt-wordpress-main 1
fi

pathcheck="/etc/wptt/vhost/.$NAME.conf"
if [[ ! -f "$pathcheck" ]]; then
  clear
  echoDo "Tên miền không tồn tại trên hệ thống này"
  sleep 3
  exec /etc/wptt/wptt-wordpress-main 1
  exit
fi

dnf install jq golang -y
systemctl mask iptables
systemctl stop fail2ban
systemctl disable fail2ban
systemctl mask fail2ban

if [[ ! -f /etc/systemd/system/ddos-blocker-xdp.service ]]; then
  if [[ ! -f /etc/systemd/system/ddos-blocker-nftables.service ]]; then
    # Bọc ngoặc kép cho biến $NAME
    mkdir -p "/usr/local/lsws/$NAME/bao-mat"
    cp -f /etc/wptt/bao-mat/nftables/anti.go "/usr/local/lsws/$NAME/bao-mat/anti.go"

    ip=$(curl -skf --connect-timeout 5 --max-time 10 https://ipv4.icanhazip.com | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' || curl -skf --connect-timeout 5 --max-time 10 https://checkip.amazonaws.com | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)')

    sed -i "/var whitelistIPs/a \"$ip\"," "/usr/local/lsws/$NAME/bao-mat/anti.go"
    chmod +x "/usr/local/lsws/$NAME/bao-mat/anti.go"
    cd "/usr/local/lsws/$NAME/bao-mat" && go build anti.go && chmod +x anti
    rm -f /usr/local/bin/anti
    mv "/usr/local/lsws/$NAME/bao-mat/anti" /usr/local/bin/
    
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

cat <(crontab -l) | sed "/bao-mat/d" | crontab -
cat <(crontab -l) | sed "/truncate/d" | crontab -

cat <(crontab -l) <(echo "*/2 * * * * truncate -s 0 /usr/local/lsws/logs/error.log") | crontab -

if grep -q "Ubuntu" /etc/*release 2>/dev/null; then
  path_nftables_config="/etc/nftables.conf"
else
  path_nftables_config="/etc/sysconfig/nftables.conf"
fi

#file config /etc/sysconfig/nftables.conf

if [[ $(cat "$path_nftables_config" | grep 'ipvietnam') = '' ]]; then

  # Vá lỗi SC2091: Dùng if grep -qi
  if grep -qi "ubuntu" /etc/*release 2>/dev/null; then
    cp -f /etc/wptt/bao-mat/nftables/nftables-khong-block-quoc-gia.conf "$path_nftables_config"
  else
    cp -f /etc/wptt/bao-mat/nftables/nftables-khong-block-quoc-gia.conf "$path_nftables_config"
  fi

  chmod 600 "$path_nftables_config"

  #mở port ssh
  port_checkssh=$(cat /etc/ssh/sshd_config | grep "Port " | grep -o '[0-9]\+$')
  if [[ -z "$port_checkssh" ]]; then
    port_checkssh=22
  fi

  sed -i "/chain input /a\ \ tcp dport $port_checkssh accept #port ssh" "$path_nftables_config"
  systemctl restart nftables

  path_webgui="/usr/local/lsws/conf/disablewebconsole"
  if [[ ! -f "$path_webgui" ]]; then
    port_webgui_openlitespeed=$(cat /usr/local/lsws/admin/conf/admin_config.conf | grep "address" | grep -o '[0-9]\+$')
    sed -i "/chain input /a\ \ tcp dport $port_webgui_openlitespeed accept #port webguiadmin" "$path_nftables_config"
    systemctl restart nftables
  fi

fi

. /etc/wptt/logs/error-chuyen-warn-log-server

systemctl restart nftables

# Vá lỗi SC2091: Dùng if grep -q trực tiếp
if grep -q "AlmaLinux\|Rocky\|CentOS" /etc/*release 2>/dev/null; then
  systemctl restart crond
else
  systemctl restart cron
fi
echo "hoàn tất thiết lập nftables chống ddos"
