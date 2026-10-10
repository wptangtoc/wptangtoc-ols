#!/bin/bash
. /etc/wptt/core-functions 2>/dev/null

# ==========================================
# LẤY DANH SÁCH IP CHÍNH THỨC TỪ GOOGLE
# ==========================================
# Lọc dải IPv4 từ file JSON của Google

get_google_ip_ranges() {
  local ip_type="${1:-ipv4}" # 'ipv4', 'ipv6', hoặc 'all'
  local url="https://www.gstatic.com/ipranges/goog.json"
  local max_attempts=3
  local attempt=1
  local raw_json=""

  # 1. Tải JSON với TLS 1.2+, Timeout chặt và Retry 3 lần
  while [[ $attempt -le $max_attempts ]]; do
    raw_json=$(curl --tlsv1.2 -sfL --connect-timeout 8 --max-time 20 \
      -A "wptangtoc-ols/ip-sync" "$url" 2>/dev/null || true)

    # Kiểm tra tính toàn vẹn: file JSON của Google luôn chứa chuỗi "prefixes"
    if [[ -n "$raw_json" && "$raw_json" == *"prefixes"* ]]; then
      break
    fi
    sleep 2
    attempt=$((attempt + 1))
  done

  # Nếu tải thất bại hoàn toàn sau 3 lần thử
  if [[ -z "$raw_json" || "$raw_json" != *"prefixes"* ]]; then
    return 1
  fi

  # 2. Phân tích cú pháp: Ưu tiên jq (chuẩn xác nhất), fallback sang Regex chặt
  local ip_list=""

  if command -v jq >/dev/null 2>&1; then
    case "$ip_type" in
    ipv4)
      ip_list=$(echo "$raw_json" | jq -r '.prefixes[].ipv4Prefix // empty')
      ;;
    ipv6)
      ip_list=$(echo "$raw_json" | jq -r '.prefixes[].ipv6Prefix // empty')
      ;;
    all)
      ip_list=$(echo "$raw_json" | jq -r '.prefixes[] | (.ipv4Prefix // .ipv6Prefix // empty)')
      ;;
    esac
  else
    # Fallback POSIX Regex: Bóc tách đúng trường và chặn IP rác
    case "$ip_type" in
    ipv4)
      ip_list=$(echo "$raw_json" | grep -oE '"ipv4Prefix":[[:space:]]*"[0-9]{1,3}(\.[0-9]{1,3}){3}/[0-9]{1,2}"' | cut -d'"' -f4)
      ;;
    ipv6)
      ip_list=$(echo "$raw_json" | grep -oE '"ipv6Prefix":[[:space:]]*"[a-fA-F0-9:]+/[0-9]{1,3}"' | cut -d'"' -f4)
      ;;
    all)
      local v4 v6
      v4=$(echo "$raw_json" | grep -oE '"ipv4Prefix":[[:space:]]*"[0-9]{1,3}(\.[0-9]{1,3}){3}/[0-9]{1,2}"' | cut -d'"' -f4)
      v6=$(echo "$raw_json" | grep -oE '"ipv6Prefix":[[:space:]]*"[a-fA-F0-9:]+/[0-9]{1,3}"' | cut -d'"' -f4)
      ip_list=$(printf "%s\n%s" "$v4" "$v6" | sed '/^$/d')
      ;;
    esac
  fi

  # 3. Chốt chặn validation cuối: Đảm bảo danh sách trích xuất ra không rỗng
  if [[ -z "$ip_list" ]]; then
    return 1
  fi

  echo "$ip_list"
}
#google_ip_raw=$(curl -sL https://www.gstatic.com/ipranges/goog.json | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/[0-9]+')
# Lấy danh sách IPv4 (mặc định)
if ! google_ips=$(get_google_ip_ranges "ipv4"); then
  echo "Lỗi: Không thể lấy danh sách IP Google hoặc dữ liệu trả về không hợp lệ!"
  # Rollback hoặc dùng danh sách fallback tĩnh có sẵn trong /etc/wptt/...
  exit 1
fi

# Đưa vào mảng hoặc lặp qua từng subnet an toàn:
while IFS= read -r subnet; do
  [[ -z "$subnet" ]] && continue
  # Ví dụ: firewall-cmd --permanent --zone=trusted --add-source="$subnet"
  echo "Allowing: $subnet"
done <<<"$google_ips"
# BẢO MẬT/TỐI ƯU (Vá lỗi SC2001 và SC2086): Dùng Bash nội tại thay thế \n (xuống dòng) thành dấu phẩy
google_ip="${google_ip_raw//$'\n'/, }"

# Định dạng lại thành cấu trúc Set { ip1, ip2, ... }
google_ip="{ $google_ip }"

# ==========================================
# 1. XỬ LÝ TABLE INET FILTER
# ==========================================
check_inet=$(nft list chain inet filter input 2>/dev/null | grep '@GGv4')

# Vá lỗi SC1083: Bọc nháy đơn để tránh Bash hiểu lầm ngoặc nhọn, xóa gạch chéo (\) thừa
nft add set inet filter GGv4 '{ type ipv4_addr; flags interval; }' 2>/dev/null
nft flush set inet filter GGv4 2>/dev/null

# Vá lỗi SC2086: Bọc ngoặc kép cho biến
nft add element inet filter GGv4 "$google_ip" 2>/dev/null

if [[ -z "$check_inet" ]]; then
  nft insert rule inet filter input ip saddr @GGv4 accept 2>/dev/null
fi

# ==========================================
# 2. XỬ LÝ TABLE IP HTTPDGUARD
# ==========================================
check_httpd=$(nft list chain ip httpdGuard input 2>/dev/null | grep '@GGv4')

# Vá lỗi SC1083: Bọc nháy đơn cho khối tham số
nft add set ip httpdGuard GGv4 '{ type ipv4_addr; flags interval; }' 2>/dev/null
nft flush set ip httpdGuard GGv4 2>/dev/null

# Vá lỗi SC2086: Bọc ngoặc kép cho biến
nft add element ip httpdGuard GGv4 "$google_ip" 2>/dev/null

if [[ -z "$check_httpd" ]]; then
  nft insert rule ip httpdGuard input ip saddr @GGv4 accept 2>/dev/null
fi

# ==========================================
# 3. LƯU CẤU HÌNH VÀ KHỞI ĐỘNG LẠI
# ==========================================
nft list ruleset >/etc/sysconfig/nftables.conf
systemctl restart nftables

echo -e "\n\033[0;32mHoàn tất! Đã đưa danh sách IP Google (@GGv4) vào danh sách trắng (Whitelist) của Nftables.\033[0m"
