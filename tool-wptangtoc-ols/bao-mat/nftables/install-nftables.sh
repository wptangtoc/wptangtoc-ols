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


port_checkssh=$(cat /etc/ssh/sshd_config | grep "Port " | grep -o '[0-9]\+$')
if [[ $port_checkssh = '' ]];then
port_checkssh=22
fi
sed -i "/chain input /a\ \ tcp dport $port_checkssh accept" /etc/sysconfig/nftables.conf

chmod 600 /etc/sysconfig/nftables.conf
systemctl restart nftables



path_webgui="/usr/local/lsws/conf/disablewebconsole"
if [[ -f $path_webgui ]]; then
. /etc/wptt/.wptt.conf
nft add rule inet filter input tcp dport $port_webgui_openlitespeed accept
sudo nft list ruleset > /etc/sysconfig/nftables.conf
chmod 600 /etc/sysconfig/nftables.conf
systemctl restart nftables
fi


echo "hoàn tất cài nftables"

#file config /etc/sysconfig/nftables.conf
