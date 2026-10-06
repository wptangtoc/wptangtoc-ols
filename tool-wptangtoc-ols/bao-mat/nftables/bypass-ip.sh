#!/bin/bash

ip="$1"
if [[ $ip = '' ]];then
	read -p "Nhập địa chỉ ip bạn muốn bypass: " ip
fi

if [[ $(echo $ip |grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)') = '' ]];then
	echo "nhập ip không đúng định dạng"
exit
fi

if $(cat /etc/*release | grep -q "Ubuntu") ; then
	path_nftables_config="/etc/nftables.conf"
else
	path_nftables_config="/etc/sysconfig/nftables.conf"
fi

sed -i "/chain input /a\ \ ip saddr $ip accept #bypassip" $path_nftables_config
systemctl restart nftables
echo "hoàn tất bypass ip $ip"

