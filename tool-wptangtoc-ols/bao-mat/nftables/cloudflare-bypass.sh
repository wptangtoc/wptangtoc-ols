#!/bin/bash

check=$(nft list ruleset |grep 'cloudflarev4')

nft add set inet filter cloudflarev4 { type ipv4_addr\; flags interval\; }
ip_elements_cloudflare=$(nft list set inet filter cloudflarev4 | awk '/{ /,/}/' | cut -d '=' -f 2)
nft delete element inet filter cloudflarev4 ${ip_elements_cloudflare}

cloudflare_ip=$(curl https://www.cloudflare.com/ips-v4)
cloudflare_ip=$(echo $cloudflare_ip | sed 's/ /, /g')
cloudflare_ip=$(echo $cloudflare_ip | sed 's/^/{ /g' | sed 's/$/ }/g')
nft add element inet filter cloudflarev4 $cloudflare_ip

if [[ $check = '' ]];then
	#add vào input
nft add rule inet filter input ip saddr @cloudflarev4 accept
fi


nft list ruleset > /etc/sysconfig/nftables.conf
systemctl restart nftables
