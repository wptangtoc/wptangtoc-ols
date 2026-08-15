#!/bin/bash

# Số ngày trước khi hết hạn để cảnh báo
THRESHOLD=7

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

# Đường dẫn đến file log (tùy chọn)
LOG_FILE="/var/log/ssl_expiry.log"

# Hàm gửi tin nhắn Telegram
send_telegram_message() {
  local message="$1"
  url_tele="https://worker-soft-shape-e788.hoangtuan0137.workers.dev/bot${BOT_TOKEN}/sendMessage"
  curl -s -d "chat_id=$CHAT_ID&text=${message}&disable_web_page_preview=true&parse_mode=markdown" $url_tele >/dev/null
}

# Hàm kiểm tra chứng chỉ
check_certificate() {
  local domain="$1"
  local expiry_date=$(echo | openssl s_client -servername "$domain" -connect "$domain":443 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f2-)

  # Kiểm tra xem openssl có trả về ngày hợp lệ không
  if [[ -z "$expiry_date" ]]; then
    #   message="Lỗi: Không thể lấy thông tin chứng chỉ cho $domain."
    #   echo "$(date) - $message" >> "$LOG_FILE"  # Ghi log
    #   send_telegram_message "$message"
    return 1 # Trả về lỗi
  fi

  # Chuyển đổi ngày hết hạn sang timestamp
  expiry_timestamp=$(date -d "$expiry_date" +%s)
  current_timestamp=$(date +%s)
  days_remaining=$(((expiry_timestamp - current_timestamp) / 86400))

  if [[ $days_remaining -le $THRESHOLD ]]; then
    # Format message cho đẹp hơn với Markdown
    message="Cảnh báo chứng chỉ SSL $domain Hết hạn sau: $days_remaining ngày $expiry_date Vui lòng gia hạn sớm"
    # Escape các ký tự đặc biệt của Markdown
    #message=$(echo "$message" | sed 's/\([_*\[\]()~`>#+-=|{}\.!]\)/\\\1/g')
    send_telegram_message "$message"
  fi
}

# Vòng lặp qua các domain
for domain in ${DOMAINS[@]}; do
  check_certificate "$domain"
done
