#!/bin/bash

# --- Cấu hình ---
DOMAINS=()
for entry in $(ls -A /etc/wptt/vhost); do
  NAME=$(echo $entry | sed 's/^.//' | sed 's/.conf//')
  if [ "$NAME" != "${NAME/./}" ]; then
    DOMAINS+=("$NAME")
  fi
done

. /etc/wptt/.wptt.conf

# Telegram Bot API Token (LẤY TỪ BOTFATHER)
BOT_TOKEN=$(echo $telegram_api)

# Chat ID của người nhận/nhóm nhận tin nhắn (LẤY BẰNG CÁCH GỬI TIN NHẮN CHO BOT)
CHAT_ID=$(echo $telegram_id)

if [[ $(which whois) = '' ]]; then
  yum install whois -y
fi

# Hàm gửi tin nhắn Telegram
send_telegram_message() {
  local domain="$1"
  local expiry_date="$2"
  local days_left="$3"

  local message="Domain: $domain sắp hết hạn
Ngày hết hạn: $expiry_date
Số ngày còn lại: $days_left

Vui lòng gia hạn tên miền để tránh gián đoạn dịch vụ."
  curl -s -X POST "https://worker-soft-shape-e788.hoangtuan0137.workers.dev/bot$BOT_TOKEN/sendMessage" \
    -d chat_id="$CHAT_ID" \
    -d text="$message" >/dev/null
}

# --- Lọc danh sách domain, chỉ giữ lại domain gốc ---
ROOT_DOMAINS=$(for domain in $DOMAINS; do
  echo "$domain" | awk -F. '{OFS="."; print $(NF-1), $NF}' | sort -u
done)

for domain in ${ROOT_DOMAINS[@]}; do
  whois_data=$(/usr/bin/whois $domain)

  expiry_date=$(echo "$whois_data" | grep -E -i "Expiry Date:|Expiration Date:|paid-till" | head -n 1 | awk '{print $NF}')
  # Dự phòng
  if [ -z "$expiry_date" ]; then
    expiry_date=$(host -t soa "$domain" | awk '{print $7}' | tr -d '.')
    if [[ "$expiry_date" =~ ^[0-9]{8}$ ]]; then
      expiry_date=$(date -d "${expiry_date:0:4}-${expiry_date:4:2}-${expiry_date:6:2}" "+%Y-%m-%d")
    else
      expiry_date=""
    fi
  fi

  if [ -z "$expiry_date" ]; then
    echo "LỖI: Không thể xác định ngày hết hạn cho $domain"
    continue
  fi

  expiry_timestamp=$(date -d "$expiry_date" +%s)
  current_timestamp=$(date +%s)
  days_left=$(((expiry_timestamp - current_timestamp) / 86400))

  # Thay đổi điều kiện if ở đây:
  if [[ "$days_left" -le 14 && "$days_left" -gt 0 ]]; then
    send_telegram_message "$domain" "$expiry_date" "$days_left"
  fi
  # Bỏ phần thông báo khi đã hết hạn, hoặc giữ lại nếu bạn muốn:
  # elif [[ "$days_left" -le 0 ]]; then
  #     send_telegram_message "$domain" "$expiry_date" "$days_left"
  # fi
done

exit 0
