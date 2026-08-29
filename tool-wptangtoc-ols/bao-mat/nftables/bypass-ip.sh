#!/bin/bash

ip="$1"
if [[ -z "$ip" ]]; then
	read -rp "Nhập địa chỉ ip bạn muốn bypass: " ip
fi

if ! echo "$ip" | grep -qxE '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'; then
	echo "Nhập IP không đúng định dạng"
	exit 1
fi

if grep -q "Ubuntu" /etc/*release 2>/dev/null; then
	path_nftables_config="/etc/nftables.conf"
else
	path_nftables_config="/etc/sysconfig/nftables.conf"
fi

sed -i "/chain input /a\ \ ip saddr $ip accept #bypassip" "$path_nftables_config"
systemctl restart nftables
echo "Hoàn tất bypass ip $ip"
