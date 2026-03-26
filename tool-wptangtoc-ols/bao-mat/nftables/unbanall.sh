#!/bin/bash
nft flush set ip blackblock blackaction >/dev/null 2>&1

# 2. Tái tạo: Bơm ngay cái IP neo (Dummy IP) 0.0.0.0 trở lại để giữ cấu trúc
nft add element ip blackblock blackaction { 0.0.0.0 } >/dev/null 2>&1

# (Tùy chọn) Kéo theo restart nếu anh có dùng các file nftables.conf tĩnh khác

if $(cat /etc/*release | grep -q "Ubuntu"); then
  path_nftables_config="/etc/nftables.conf"
else
  path_nftables_config="/etc/sysconfig/nftables.conf"
fi
nft list ruleset >$path_nftables_config
systemctl restart nftables >/dev/null 2>&1
