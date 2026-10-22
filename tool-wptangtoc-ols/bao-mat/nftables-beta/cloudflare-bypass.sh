#!/bin/bash
. /etc/wptt/core-functions 2>/dev/null

# Thêm cờ -s vào curl để ẩn progress bar, tránh làm hỏng định dạng text
fetch_cloudflare_ips() {
  local cf_url="https://www.cloudflare.com/ips-v4"
  local cloudflare_raw=""
  local max_retries=3
  local retry_delay=2

  # Tải qua curl với timeout chặt chẽ và retry
  # -f: Trả về lỗi nếu HTTP status >= 400
  # -sS: Giữ im lặng nhưng vẫn in lỗi nếu có sự cố mạng
  # --connect-timeout 5: Hủy nếu không kết nối được sau 5 giây
  # --max-time 15: Giới hạn tổng thời gian nhận phản hồi tối đa 15 giây
  for ((attempt = 1; attempt <= max_retries; attempt++)); do
    cloudflare_raw=$(curl -fsSL \
      --connect-timeout 5 \
      --max-time 15 \
      --proto "=https" \
      --tlsv1.2 \
      "$cf_url" 2>/dev/null) && [[ -n "$cloudflare_raw" ]] && break

    echo "⚠ Lần thử $attempt/$max_retries lấy IP Cloudflare thất bại. Thử lại sau ${retry_delay}s..." >&2
    sleep "$retry_delay"
  done

  # 1. Kiểm tra nếu hoàn toàn không có dữ liệu (Rỗng)
  if [[ -z "$cloudflare_raw" ]]; then
    echo -e "❌ Lỗi: Không thể kết nối hoặc dữ liệu IP từ Cloudflare bị rỗng sau ${max_retries} lần thử!" >&2
    wptt_logs "ERROR" "Thất bại khi tải danh sách IP Cloudflare từ $cf_url" 2>/dev/null || true
    return 1
  fi

  # 2. Kiểm định nội dung (Data Validation): Phải chứa ít nhất 1 dòng CIDR IPv4 hợp lệ
  # Chống tình trạng curl thành công nhưng nhận về trang HTML lỗi 403 / DDoS Protection
  local valid_cidr_count
  valid_cidr_count=$(grep -cE '^([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}$' <<<"$cloudflare_raw" || true)

  if ((valid_cidr_count < 5)); then
    echo -e "❌ Lỗi: Dữ liệu tải về từ Cloudflare không đúng định dạng dải IP CIDR hợp lệ!" >&2
    wptt_logs "ERROR" "Dữ liệu Cloudflare IPS không hợp lệ (Số CIDR hợp lệ: $valid_cidr_count)" 2>/dev/null || true
    return 1
  fi

  # Trả kết quả sạch ra stdout
  printf '%s\n' "$cloudflare_raw"
}

# --- CÁCH SỬ DỤNG CHUẨN XÁC NGOÀI SCRIPT CHÍNH ---
cloudflare_raw=$(fetch_cloudflare_ips) || {
  echo -e "❌ Dừng tiến trình do không lấy được danh sách IP Cloudflare tin cậy." >&2
  exit 1
}

# BẢO MẬT/TỐI ƯU (Vá lỗi SC2001): Dùng Bash nội tại thay thế \n (xuống dòng) thành dấu phẩy thay vì gọi 'sed'
cloudflare_ip="${cloudflare_raw//$'\n'/, }"
# Cắt bỏ dấu phẩy thừa ở cuối (nếu API rớt xuống dòng cuối cùng)
cloudflare_ip="${cloudflare_ip%, }"

cloudflare_ip="{ $cloudflare_ip }"

# ==========================================
# 1. XỬ LÝ TABLE INET FILTER
# ==========================================
# Kiểm tra trực tiếp xem rule đã tồn tại trong chain chưa
check_inet=$(nft list chain inet filter input 2>/dev/null | grep '@cloudflarev4')

# Vá lỗi SC1083: Bọc nháy đơn để tránh Bash hiểu lầm ngoặc nhọn, xóa gạch chéo (\) thừa
nft add set inet filter cloudflarev4 '{ type ipv4_addr; flags interval; }' 2>/dev/null

# TỐI ƯU: Thay vì dùng awk để bóc tách rồi xóa từng element, dùng lệnh 'flush' để làm sạch set cũ ngay lập tức
nft flush set inet filter cloudflarev4 2>/dev/null

# Vá lỗi SC2086: Bọc ngoặc kép cho biến
nft add element inet filter cloudflarev4 "$cloudflare_ip" 2>/dev/null

if [[ -z "$check_inet" ]]; then
  # SỬ DỤNG 'insert' THAY VÌ 'add' ĐỂ RULE NẰM Ở TRÊN CÙNG
  nft insert rule inet filter input ip saddr @cloudflarev4 accept 2>/dev/null
fi

# ==========================================
# 2. XỬ LÝ TABLE IP HTTPDGUARD
# ==========================================
check_httpd=$(nft list chain ip httpdGuard input 2>/dev/null | grep '@cloudflarev4')

# Vá lỗi SC1083: Bọc nháy đơn cho khối tham số
nft add set ip httpdGuard cloudflarev4 '{ type ipv4_addr; flags interval; }' 2>/dev/null

# Làm sạch toàn bộ IP cũ trong set
nft flush set ip httpdGuard cloudflarev4 2>/dev/null

# Vá lỗi SC2086: Bọc ngoặc kép cho biến
nft add element ip httpdGuard cloudflarev4 "$cloudflare_ip" 2>/dev/null

if [[ -z "$check_httpd" ]]; then
  # SỬ DỤNG 'insert' THAY VÌ 'add' ĐỂ RULE NẰM Ở TRÊN CÙNG
  nft insert rule ip httpdGuard input ip saddr @cloudflarev4 accept 2>/dev/null
fi

# ==========================================
# 3. LƯU CẤU HÌNH VÀ KHỞI ĐỘNG LẠI
# ==========================================
nft list ruleset >/etc/sysconfig/nftables.conf
systemctl restart nftables
