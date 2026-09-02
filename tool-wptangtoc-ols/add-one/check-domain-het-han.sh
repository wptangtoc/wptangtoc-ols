#!/bin/bash
# shellcheck disable=SC1091,SC2154

# --- Cấu hình ---
DOMAINS=()

# BẢO MẬT/TỐI ƯU (Vá lỗi SC2045): Dùng vòng lặp trực tiếp quét thư mục, tránh lỗi khoảng trắng của lệnh 'ls'
for path in /etc/wptt/vhost/.*; do
  # Bỏ qua nếu là thư mục . hoặc ..
  entry=$(basename "$path")
  [[ "$entry" == "." || "$entry" == ".." ]] && continue
  
  # BẢO MẬT/TỐI ƯU (Vá lỗi SC2086): Dùng tính năng cắt chuỗi gốc của Bash, loại bỏ 'sed' giúp chạy nhanh hơn
  NAME="${entry#.}"
  NAME="${NAME%.conf}"
  
  if [ "$NAME" != "${NAME/./}" ]; then
    DOMAINS+=("$NAME")
  fi
done

. /etc/wptt/.wptt.conf 2>/dev/null

# Telegram Bot API Token (LẤY TỪ BOTFATHER)
BOT_TOKEN=$(wptt_giai_ma "$telegram_api" 2>/dev/null); BOT_TOKEN="${BOT_TOKEN:-$telegram_api}"
CHAT_ID=$(wptt_giai_ma "$telegram_id" 2>/dev/null); CHAT_ID="${CHAT_ID:-$telegram_id}"

if ! command -v whois >/dev/null 2>&1; then
	if grep -q "Ubuntu" /etc/*release 2>/dev/null; then
		apt install whois -y
	else
		dnf install whois -y
	fi
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

  local url_tele_goc="https://api.telegram.org/bot${BOT_TOKEN}/sendMessage"
  
  # LẦN 1: Thử gửi bằng API gốc (Sử dụng cách viết -d tách dòng siêu an toàn của sếp)
  local response
  response=$(curl -s -m 5 -X POST "$url_tele_goc" \
    -d chat_id="$CHAT_ID" \
    -d text="$message" \
    -d disable_web_page_preview="true" \
    -d parse_mode="markdown")
  
  # SIÊU KIỂM TRA TẦNG API: Nếu Telegram không trả về chữ "ok":true
  if [[ "$response" != *"\"ok\":true"* ]]; then
    
    # === BẬT CHẾ ĐỘ DỰ PHÒNG: CHUYỂN QUA PROXY ===
    local API_PROXY
    API_PROXY=$(curl -sL -m 10 -H "User-Agent: wptangtoc ols get telegram" "https://hub.wptangtoc.com/get-telegram-work" | tr -d '\r\n[:space:]')
    
    local url_tele_proxy
    if [[ "$API_PROXY" == *"workers.dev"* ]]; then
      url_tele_proxy="https://$API_PROXY/bot${BOT_TOKEN}/sendMessage"
    fi
    
    # LẦN 2: Bắn lại qua Proxy
    curl -s -m 10 -X POST "$url_tele_proxy" \
      -d chat_id="$CHAT_ID" \
      -d text="$message" \
      -d disable_web_page_preview="true" \
      -d parse_mode="markdown" >/dev/null
  fi
}

# --- Lọc danh sách domain, chỉ giữ lại domain gốc ---
# Vá lỗi SC2128 và SC2068: Sử dụng mapfile để đẩy output thành một mảng (array) chuẩn xác
mapfile -t ROOT_DOMAINS < <(printf "%s\n" "${DOMAINS[@]}" | awk -F. '{OFS="."; print $(NF-1), $NF}' | sort -u)

for domain in "${ROOT_DOMAINS[@]}"; do
  # Vá lỗi SC2086: Bọc ngoặc kép cho $domain
  whois_data=$(/usr/bin/whois "$domain" 2>/dev/null)

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
done

exit 0
