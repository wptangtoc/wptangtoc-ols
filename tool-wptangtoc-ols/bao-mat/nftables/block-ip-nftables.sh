#!/bin/bash
# shellcheck disable=SC2317

ip="$1"
if [[ -z "$ip" ]]; then
  read -rp "Nhập địa chỉ ip bạn muốn block: " ip
fi

# Khởi tạo mặc định là có lỗi
error_block_ipv4='1'
error_block_ipv6='1'

# Nếu khớp IPv4 chuẩn -> Xóa cờ lỗi IPv4
if echo "$ip" | grep -qxE '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'; then
  error_block_ipv4='0'
fi

# Nếu khớp IPv6 chuẩn -> Xóa cờ lỗi IPv6
if echo "$ip" | grep -qxE '([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])'; then
  error_block_ipv6='0'
fi

# Nếu CẢ HAI đều bị lỗi (không khớp cái nào) -> Báo sai định dạng
if [[ "$error_block_ipv4" == '1' && "$error_block_ipv6" == '1' ]]; then
  echo "Bạn không nhập đúng định dạng IP"
  /etc/wptt/wptt-khoa-ip-main 1
  return 2>/dev/null || exit 0
fi

# Chỗ này em sửa lại dấu ngoặc nhọn để không bị lỗi cú pháp nftables
nft add element ip blackblock blackaction "{ $ip }" 2>/dev/null

if grep -q "Ubuntu" /etc/*release 2>/dev/null; then
  path_nftables_config="/etc/nftables.conf"
else
  path_nftables_config="/etc/sysconfig/nftables.conf"
fi

nft list ruleset > "$path_nftables_config"
