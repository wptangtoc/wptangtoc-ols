#!/bin/bash

. /etc/wptt/bao-mat/nftables/install-nftables.sh
cat <(crontab -l) | sed "/bao-mat/d" | crontab -
cat <(crontab -l) | sed "/truncate/d" | crontab -
rm -rf /usr/local/lsws/*/bao-mat
systemctl stop ddos-blocker-nftables
systemctl disable ddos-blocker-nftables
rm -f /usr/local/bin/anti
rm -f /etc/systemd/system/ddos-blocker-nftables.service
if [[ -f /etc/systemd/system/layer7-ddos-blocker-nftables.service ]]; then
  systemctl stop layer7-ddos-blocker-nftables
  systemctl disable layer7-ddos-blocker-nftables
  rm -f /etc/systemd/system/layer7-ddos-blocker-nftables.service
fi

if [[ -f /etc/systemd/system/layer7-lsws-litmit-ddos-blocker-nftables.service ]]; then
  systemctl stop layer7-lsws-litmit-ddos-blocker-nftables
  systemctl disable layer7-ddos-blocker-nftables
  rm -f /etc/systemd/system/layer7-lsws-litmit-ddos-blocker-nftables.service
fi

sudo systemctl daemon-reload
systemctl restart nftables
systemctl unmask fail2ban
systemctl start fail2ban
systemctl enable fail2ban
systemctl unmask iptables
echo "Hoàn tất"
