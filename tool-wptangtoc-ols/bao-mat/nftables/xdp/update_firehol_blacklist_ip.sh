#!/bin/bash

#cat <(crontab -l) <(echo "10 0,6,12,18 * * * /bin/bash /đường/dẫn/tới/script/update_firehol_blacklist_ip.sh >/dev/null 2>&1") | crontab -
#systemctl restart crond
#đoạn để 6 tiếng nó tự động update firehol list

# Exit ngay lập tức nếu có lệnh thất bại
set -e

nftables_service=$(systemctl status nftables.service 2>/dev/null | grep 'Active' | cut -f2 -d':' | xargs | cut -f1 -d' ' | xargs)
if [[ "$nftables_service" != "active" ]]; then
  exit
fi
# --- CẤU HÌNH ---
FIREHOL_URL="https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level1.netset"
NFT_TABLE="ip blackblock"
NFT_SET="blackaction"
BAN_DURATION="6h" # nftables hiểu các định dạng như '6h', '360m', '21600s'

# --- LOGIC CHÍNH ---

# 1. Kiểm tra quyền root và các công cụ cần thiết
if [ "$EUID" -ne 0 ]; then
  echo "Lỗi: Vui lòng chạy script này với quyền root (sudo)."
  exit 1
fi

if ! command -v curl &>/dev/null || ! command -v nft &>/dev/null; then
  echo "Lỗi: Vui lòng cài đặt 'curl' và 'nftables'."
  exit 1
fi

echo "Bắt đầu quá trình cập nhật danh sách chặn Firehol cho nftables..."

# 2. Tải danh sách IP/dải mạng
#    - curl -s: Tải file một cách im lặng
#    - grep -v "^#": Lọc bỏ các dòng comment
echo "-> Đang tải danh sách từ Firehol..."
IP_LIST=$(curl -s "$FIREHOL_URL" | grep -v "^#")

if [ -z "$IP_LIST" ]; then
  echo "Lỗi: Không thể tải hoặc danh sách IP rỗng. Hủy bỏ."
  exit 1
fi

# 3. Chuẩn bị danh sách các element để thêm vào nftables
#    Định dạng: { ip1 timeout 6h, ip2 timeout 6h, cidr1 timeout 6h, ... }
ELEMENTS=""
COUNT=0
while read -r ENTRY; do
  # Bỏ qua các dòng trống
  if [ -n "$ENTRY" ]; then
    # Thêm dấu phẩy nếu đây không phải là element đầu tiên
    if [ "$COUNT" -gt 0 ]; then
      ELEMENTS+=", "
    fi
    ELEMENTS+="$ENTRY timeout $BAN_DURATION"
    COUNT=$((COUNT + 1))
  fi
done <<<"$IP_LIST"

# 4. Cập nhật vào nftables
#    Chiến lược: Xóa sạch set cũ và thêm toàn bộ list mới.
#    Điều này đảm bảo các IP đã được gỡ khỏi Firehol cũng sẽ được gỡ khỏi set của bạn.
echo "-> Xóa các entry cũ trong set '${NFT_SET}'..."
sudo nft flush set $NFT_TABLE $NFT_SET

# Chỉ thêm khi danh sách element không rỗng
if [ -n "$ELEMENTS" ]; then
  echo "-> Thêm $COUNT IP/dải mạng mới vào set '${NFT_SET}' với thời gian chặn là ${BAN_DURATION}..."
  sudo nft add element $NFT_TABLE $NFT_SET "{ $ELEMENTS }"
  echo "✅ Cập nhật thành công!"
else
  echo "ℹ️ Danh sách Firehol rỗng, không có IP nào được thêm."
fi

echo "--- Quá trình hoàn tất ---"
