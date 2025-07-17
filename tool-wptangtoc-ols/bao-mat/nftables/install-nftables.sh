#!/bin/bash

systemctl mask iptables
systemctl stop iptables
systemctl disable iptables
systemctl stop firewalld
systemctl mask firewalld
systemctl disable firewalld

dnf install nftables -y
systemctl unmask nftables
systemctl start nftables
systemctl enable nftables

if $(cat /etc/*release | grep -q "Ubuntu"); then
  path_nftables_config="/etc/nftables.conf"
else
  path_nftables_config="/etc/sysconfig/nftables.conf"
fi

nft flush ruleset #xoa clean hết mode cũ

cat /etc/wptt/bao-mat/nftables/nftables-co-ban.conf >$path_nftables_config

port_checkssh=$(cat /etc/ssh/sshd_config | grep "Port " | grep -o '[0-9]\+$')
if [[ $port_checkssh = '' ]]; then
  port_checkssh=22
fi
sed -i "/chain input /a\ \ tcp dport $port_checkssh accept #port ssh" $path_nftables_config

chmod 600 $path_nftables_config
systemctl restart nftables

path_webgui="/usr/local/lsws/conf/disablewebconsole"
if [[ ! -f $path_webgui ]]; then
  port_webgui_openlitespeed=$(cat /usr/local/lsws/admin/conf/admin_config.conf | grep "address" | cut -f2 -d":")
  sed -i "/chain input /a\ \ tcp dport $port_webgui_openlitespeed accept #port webguiadmin" $path_nftables_config
  systemctl restart nftables
fi

#remote mariadb port
if $(cat /etc/*release | grep -q "Ubuntu"); then
  duong_dan_cau_hinh_mariadb="/etc/mysql/my.cnf"
else
  duong_dan_cau_hinh_mariadb="/etc/my.cnf.d/server.cnf"
fi

port_mariadb_remote=$(cat $duong_dan_cau_hinh_mariadb | grep 'port=' | grep -o '[0-9]\+$')
if [[ $port_mariadb_remote ]]; then
  sed -i "/chain input /a\ \ tcp dport $port_mariadb_remote accept #port remote mariadb" $path_nftables_config
fi

sed -i '/%(action_)s/!s/^action = .*/action = nftables-allports/' /etc/fail2ban/jail.local
sed -i '/%(banaction_allports)s/!s/^banaction = .*/banaction = nftables-allports/' /etc/fail2ban/jail.local
sed -i "s/^banaction_allports = .*/banaction_allports = nftables-allports/" /etc/fail2ban/jail.local

systemctl restart fail2ban
echo "hoàn tất cài nftables"

#file config /etc/sysconfig/nftables.conf
