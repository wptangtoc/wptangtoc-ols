#!/bin/bash
. /etc/wptt/core-functions 2>/dev/null
nft flush set ip blackblock blackaction >/dev/null 2>&1

# 2. Tái tạo: Bơm ngay cái IP neo (Dummy IP) 0.0.0.0 trở lại để giữ cấu trúc

if grep -q "Ubuntu" /etc/*release 2>/dev/null; then
  path_nftables_config="/etc/nftables.conf"
else
  path_nftables_config="/etc/sysconfig/nftables.conf"
fi

# nft list ruleset > "$path_nftables_config"

if ! nft add element ip blackblock blackaction '{ 0.0.0.0 }' 2>/etc/wptt/tmp/nft_err.log; then
  echo "Lỗi: Không thể thêm IP vào blacklist (xem /etc/wptt/tmp/nft_err.log)"
  cat /etc/wptt/tmp/nft_err.log
  return 1 2>/dev/null || exit 1
fi

tmp_conf=$(mktemp -p "/etc/wptt/tmp" wptt_nftables_XXXXXX.txt)
if nft list ruleset > "$tmp_conf" && [[ -s "$tmp_conf" ]]; then
	mv -f "$tmp_conf" "$path_nftables_config"
	chmod 600 "$path_nftables_config"
	systemctl restart nftables >/dev/null 2>&1
	return 0
else
	echo "Lỗi: Không thể xuất ruleset — GIỮ NGUYÊN file cấu hình cũ để tránh mất firewall khi reboot!"
	rm -f "$tmp_conf"
	return 1
fi


