#!/bin/bash

#cat <(crontab -l) <(echo "10 0,6,12,18 * * * /etc/wptt/bao-mat/nftables/xdp/update_firehol_blacklist_ip.sh") | crontab -
#systemctl restart crond
#đoạn để 6 tiếng nó tự động update firehol list

set -e

# --- CẤU HÌNH ---
FIREHOL_URL="https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level1.netset"
MAP_NAME="log_blacklist"
BAN_DURATION="6 hours"

# --- LOGIC CHÍNH ---

if ! command -v curl &>/dev/null || ! command -v bpftool &>/dev/null; then
  echo "Lỗi: Vui lòng cài đặt 'curl' và các công cụ BPF (bpftool)."
  exit 1
fi

MAP_ID=$(sudo bpftool map list | grep "$MAP_NAME" | awk '{print $1}' | sed 's/://' || true)
if [ -z "$MAP_ID" ]; then
  echo "Lỗi: Không tìm thấy map '$MAP_NAME'."
  exit 1
fi
echo "Tìm thấy map '$MAP_NAME' với ID: $MAP_ID"

BAN_TIMESTAMP=$(sudo date -d "+${BAN_DURATION}" +%s%N)

# === PHẦN SỬA LỖI CUỐI CÙNG ===
# Chuyển đổi timestamp sang 8 byte hexa, little-endian một cách đáng tin cậy
HEX_VALUE=""
HEX_TIMESTAMP=$(printf '%016x' "$BAN_TIMESTAMP")
for ((i = 14; i >= 0; i -= 2)); do
  HEX_VALUE+="0x${HEX_TIMESTAMP:$i:2} "
done

echo "Bắt đầu tải và xử lý danh sách IP từ Firehol..."

IP_COUNT=0
curl -s "$FIREHOL_URL" | grep -v "^#" | while read -r IP_TO_BLOCK; do
  if [ -z "$IP_TO_BLOCK" ]; then
    continue
  fi

  # Bỏ qua các địa chỉ không phải là IPv4 (ví dụ: 0.0.0.0/8)
  if ! [[ "$IP_TO_BLOCK" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} ]]; then
    echo "  -> Bo qua dong khong hop le: $IP_TO_BLOCK"
    continue
  fi

  HEX_KEY=$(echo "$IP_TO_BLOCK" | awk -F. '{ printf "0x%x 0x%x 0x%x 0x%x\n", $1, $2, $3, $4 }')

  echo "  -> Đang thêm IP: $IP_TO_BLOCK (Hex: $HEX_KEY)"

  sudo bpftool map update id "$MAP_ID" key $HEX_KEY value $HEX_VALUE

  IP_COUNT=$((IP_COUNT + 1))
done

echo "--------------------------------------------------"
echo "✅ Hoàn tất! Đã thêm thành công $IP_COUNT địa chỉ IP vào danh sách đen."
