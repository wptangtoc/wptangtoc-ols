#!/bin/bash

nftables_service=$(systemctl status nftables.service 2>/dev/null | grep 'Active' | cut -f2 -d':' | xargs | cut -f1 -d' ' | xargs)
if [[ "$nftables_service" != "active" ]]; then
echo "nftables chưa được cài đặt"
exit
fi

dnf install firewalld -y
nft flush ruleset
systemctl stop nftables
systemctl disable nftables
systemctl unmask firewalld
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --zone=public --add-service=http --add-service=https --permanent
firewall-cmd --zone=public --add-port=443/udp --permanent
port_ssh=$(cat /etc/ssh/sshd_config | grep "Port " | grep -o '[0-9]\+$')
if [[ $port_ssh = "" ]];then
port_ssh=22
fi
firewall-cmd --zone=public --add-port=${port_ssh}/tcp --permanent

path_webgui="/usr/local/lsws/conf/disablewebconsole"
if [[ ! -f $path_webgui ]]; then
port_webgui_openlitespeed=$(cat /usr/local/lsws/admin/conf/admin_config.conf | grep "address" | grep -o '[0-9]\+$')
firewall-cmd --zone=public --add-port=${port_webgui_openlitespeed}/tcp --permanent
fi


#remote mariadb
if $(cat /etc/*release | grep -q "Ubuntu") ; then
	duong_dan_cau_hinh_mariadb="/etc/mysql/my.cnf"
else
	duong_dan_cau_hinh_mariadb="/etc/my.cnf.d/server.cnf"
fi

port_mariadb_remote=$(cat $duong_dan_cau_hinh_mariadb | grep 'port='| grep -o '[0-9]\+$')
if [[ $port_mariadb_remote ]];then
firewall-cmd --zone=public --add-port=${port_mariadb_remote}/tcp --permanent
fi


if $(cat /etc/*release | grep -q "Ubuntu") ; then
		path_nftables_config="/etc/nftables.conf"
	else
		path_nftables_config="/etc/sysconfig/nftables.conf"
fi

rm -f $path_nftables_config


sed -i '/%(action_)s/!s/^action = .*/action = firewallcmd-allports/'  /etc/fail2ban/jail.local
sed -i '/%(banaction_allports)s/!s/^banaction = .*/banaction = firewallcmd-allports/'  /etc/fail2ban/jail.local
sed -i "s/^banaction_allports = .*/banaction_allports = firewallcmd-allports/" /etc/fail2ban/jail.local
systemctl restart fail2ban

firewall-cmd --reload
echo "Hoàn tất remove nftables và bật lại firewalld"

