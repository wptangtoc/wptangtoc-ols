#!/bin/bash

. /etc/wptt/bao-mat/nftables/install-nftables.sh
cat <(crontab -l) | sed "/bao-mat/d" | crontab -
cat <(crontab -l) | sed "/access.log/d" | crontab -
rm -rf /usr/local/lsws/*/bao-mat
systemctl restart nftables
systemctl unmask fail2ban
systemctl start fail2ban
systemctl enable fail2ban
systemctl unmask iptables
echo "Hoàn tất"

