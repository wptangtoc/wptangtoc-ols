#!/bin/bash
ip="$1"

if [[ $ip = '' ]];then
	read -p "Nhập địa chỉ ip bạn muốn block" ip
fi


if [[ $(echo $ip |grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)') = '' ]];then #kiểm tra có phải ipv4 không
	error_block_ipv4='1'
fi


if [[ $(echo $ip |grep -oE '\b([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\b|\b([0-9a-fA-F]{1,4}:){1,7}:\b|\b([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}\b|\b([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}\b|\b([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}\b|\b([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}\b|\b([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}\b|\b[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})\b|\b:((:[0-9a-fA-F]{1,4}){1,7}|:)\b|\bfe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}\b|\b::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\b|\b([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\b') = '' ]];then #kiểm tra có phải ipv6 không?
error_block_ipv6='1'
fi


if [[ $error_block_ipv6 = '1' && $error_block_ipv4 = '1' ]];then
echo "Bạn không nhập đúng định dạng IP"
. /etc/wptt/wptt-khoa-ip-main 1
return 2>/dev/null; exit
fi


nft delete element blackblock blackaction "{$ip}"

if $(cat /etc/*release | grep -q "Ubuntu") ; then
	path_nftables_config="/etc/nftables.conf"
else
	path_nftables_config="/etc/sysconfig/nftables.conf"
fi

nft list ruleset > $path_nftables_config

