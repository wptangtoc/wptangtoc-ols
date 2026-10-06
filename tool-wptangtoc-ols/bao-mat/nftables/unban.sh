#!/bin/bash
ip="$1"

if [[ $ip = '' ]];then
	read -p "Nhập địa chỉ ip bạn muốn block" ip
fi

if [[ $(echo $ip |grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)') = '' ]];then
	echo "nhập ip không đúng định dạng"
exit
fi

nft delete element blackblock blackaction "{$ip}"

if $(cat /etc/*release | grep -q "Ubuntu") ; then
	path_nftables_config="/etc/nftables.conf"
else
	path_nftables_config="/etc/sysconfig/nftables.conf"
fi

nft list ruleset > $path_nftables_config

