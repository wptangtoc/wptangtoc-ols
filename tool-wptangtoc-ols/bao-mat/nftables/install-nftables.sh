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

cat /etc/wptt/bao-mat/nftables/nftables-co-ban.conf > /etc/sysconfig/nftables.conf

if $(cat /etc/*release | grep -q "Ubuntu") ; then
		path_nftables_config="/etc/nftables.conf"
	else
		path_nftables_config="/etc/sysconfig/nftables.conf"
fi

port_checkssh=$(cat /etc/ssh/sshd_config | grep "Port " | grep -o '[0-9]\+$')
if [[ $port_checkssh = '' ]];then
port_checkssh=22
fi
sed -i "/chain input /a\ \ tcp dport $port_checkssh accept #port ssh" $path_nftables_config

chmod 600 /etc/sysconfig/nftables.conf
systemctl restart nftables



path_webgui="/usr/local/lsws/conf/disablewebconsole"
if [[ -f $path_webgui ]]; then
port_webgui_openlitespeed=$(cat /usr/local/lsws/admin/conf/admin_config.conf | grep "address" | cut -f2 -d":")
sed -i "/chain input /a\ \ tcp dport $port_webgui_openlitespeed accept #port webguiadmin" $path_nftables_config
systemctl restart nftables
fi


echo "hoàn tất cài nftables"

#file config /etc/sysconfig/nftables.conf
