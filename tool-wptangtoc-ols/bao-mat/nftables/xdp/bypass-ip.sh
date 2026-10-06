#!/bin/bash

# Script để thêm IP vào whitelist_map một cách dễ dàng

# Kiểm tra xem IP có được cung cấp không
if [ -z "$1" ]; then
  echo "Lỗi: Vui lòng cung cấp địa chỉ IP."
  echo "Ví dụ sử dụng: $0 1.1.1.1"
  exit 1
fi

IP=$1

if [[ $(echo $IP | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)') ]]; then #kiểm tra có phải ipv4 không
  # Chuyển đổi IP sang định dạng hexa (ví dụ: 1.1.1.1 -> 0x1 0x1 0x1 0x1)
  HEX_KEY=$(echo "$IP" | awk -F. '{ printf "0x%x 0x%x 0x%x 0x%x\n", $1, $2, $3, $4 }')
  echo "Dang them IP: $IP (Hex: $HEX_KEY) vao whitelist..."
  # Chạy lệnh bpftool với key đã được định dạng
  sudo bpftool map update name whitelist_map key $HEX_KEY value 1
else
  echo "$IP không phải ipv4"
fi
