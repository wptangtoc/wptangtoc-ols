#!/bin/bash

# Thêm cờ -s vào curl để ẩn progress bar, tránh làm hỏng định dạng text
cloudflare_raw=$(curl -s https://www.cloudflare.com/ips-v4)

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
nft list ruleset > /etc/sysconfig/nftables.conf
systemctl restart nftables
