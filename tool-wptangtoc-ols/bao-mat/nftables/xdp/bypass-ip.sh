#!/bin/bash

# Kịch bản để thêm một địa chỉ IP vào danh sách trắng của XDP

set -e

# --- CẤU HÌNH ---
MAP_NAME="whitelist_map"

# --- LOGIC CHÍNH ---

# 1. Kiểm tra xem người dùng có cung cấp IP không
if [ -z "$1" ]; then
  echo "Lỗi: Vui lòng cung cấp địa chỉ IP cần thêm vào whitelist."
  echo "Ví dụ sử dụng: sudo $0 1.2.3.4"
  exit 1
fi

IP_TO_WHITELIST=$1

# 2. Tìm ID của map
MAP_ID=$(sudo bpftool map list | grep "$MAP_NAME" | awk '{print $1}' | sed 's/://' || true)

if [ -z "$MAP_ID" ]; then
  echo "Lỗi: Không tìm thấy map '$MAP_NAME'. Hãy chắc chắn chương trình XDP đang chạy."
  exit 1
fi

# 3. Chuyển đổi IP sang dạng 4 byte hexa, little-endian
# (Để khớp với `__builtin_bswap32` trong XDP C)
HEX_KEY_BE=$(echo "$IP_TO_WHITELIST" | awk -F. '{ printf "%02x%02x%02x%02x\n", $1, $2, $3, $4 }')
HEX_KEY_LE=$(echo "$HEX_KEY_BE" | fold -w2 | tac | paste -sd '' -)
HEX_KEY=$(echo "$HEX_KEY_LE" | fold -w2 | awk '{printf "0x%s ", $1}')

# 4. Giá trị value không quan trọng, chỉ cần tồn tại. Dùng 1.
VALUE=1

echo "Đang thêm IP: $IP_TO_WHITELIST (Hex: $HEX_KEY) vào whitelist..."

# 5. Thêm IP vào BPF map
sudo bpftool map update id "$MAP_ID" key $HEX_KEY value $VALUE

echo "✅ Đã thêm thành công IP $IP_TO_WHITELIST vào danh sách trắng."

# 6. Kiểm tra lại
echo "--- Nội dung whitelist hiện tại ---"
sudo bpftool map dump id "$MAP_ID"
