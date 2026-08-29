#!/bin/bash
# shellcheck disable=SC2317

ip="$1"

if [[ -z "$ip" ]]; then
  # Vá lỗi SC2162: Thêm cờ -r để đọc chuỗi thô (raw)
  read -rp "Nhập địa chỉ IP bạn muốn unblock: " ip
fi

error_block_ipv4='1'
error_block_ipv6='1'

# Vá lỗi SC2143: Dùng grep -qE thay vì so sánh output chuỗi
if echo "$ip" | grep -qE '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'; then
  error_block_ipv4='0'
fi

if echo "$ip" | grep -qxE '([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])'; then
  error_block_ipv6='0'
fi

if [[ "$error_block_ipv6" == '1' && "$error_block_ipv4" == '1' ]]; then
  echo "Bạn không nhập đúng định dạng IP"
  # Vá lỗi SC2317: Bỏ lệnh 'exec' để script tiếp tục chạy xuống dòng return/exit
  /etc/wptt/wptt-khoa-ip-main 1
  return 2>/dev/null || exit 0
fi

nft delete element blackblock blackaction "{ $ip }" 2>/dev/null

if grep -q "Ubuntu" /etc/*release 2>/dev/null; then
  path_nftables_config="/etc/nftables.conf"
else
  path_nftables_config="/etc/sysconfig/nftables.conf"
fi

nft list ruleset > "$path_nftables_config"
