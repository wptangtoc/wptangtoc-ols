#!/bin/bash

# ==========================================
# LẤY DANH SÁCH IP CHÍNH THỨC TỪ GOOGLE
# ==========================================
# Lọc dải IPv4 từ file JSON của Google
google_ip_raw=$(curl -sL https://www.gstatic.com/ipranges/goog.json | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/[0-9]+')

# Định dạng lại thành cấu trúc Set { ip1, ip2, ... }
google_ip=$(echo $google_ip_raw | sed 's/ /, /g')
google_ip="{ $google_ip }"

# ==========================================
# 1. XỬ LÝ TABLE INET FILTER
# ==========================================
check_inet=$(nft list chain inet filter input 2>/dev/null | grep '@GGv4')

nft add set inet filter GGv4 { type ipv4_addr\; flags interval\; } 2>/dev/null
nft flush set inet filter GGv4 2>/dev/null
nft add element inet filter GGv4 $google_ip 2>/dev/null

if [[ -z "$check_inet" ]]; then
	nft insert rule inet filter input ip saddr @GGv4 accept 2>/dev/null
fi


# ==========================================
# 2. XỬ LÝ TABLE IP HTTPDGUARD
# ==========================================
check_httpd=$(nft list chain ip httpdGuard input 2>/dev/null | grep '@GGv4')

nft add set ip httpdGuard GGv4 { type ipv4_addr\; flags interval\; } 2>/dev/null
nft flush set ip httpdGuard GGv4 2>/dev/null
nft add element ip httpdGuard GGv4 $google_ip 2>/dev/null

if [[ -z "$check_httpd" ]]; then
	nft insert rule ip httpdGuard input ip saddr @GGv4 accept 2>/dev/null
fi


# ==========================================
# 3. LƯU CẤU HÌNH VÀ KHỞI ĐỘNG LẠI
# ==========================================
nft list ruleset > /etc/sysconfig/nftables.conf
systemctl restart nftables

echo -e "\n\033[0;32mHoàn tất! Đã đưa danh sách IP Google (@GGv4) vào danh sách trắng (Whitelist) của Nftables.\033[0m"
