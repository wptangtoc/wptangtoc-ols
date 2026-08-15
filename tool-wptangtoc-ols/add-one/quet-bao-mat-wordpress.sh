#!/bin/bash
# @author: Gia Tuấn
# @website: https://wptangtoc.com
# @email: giatuan@wptangtoc.com
# @description: Quét lỗ hổng bảo mật & Mã độc WordPress 
# @since: 2026

. /etc/wptt/echo-color 2>/dev/null
. /etc/wptt/.wptt.conf 2>/dev/null
. /etc/wptt/core-functions 2>/dev/null

export box_inner_width=78

NAME=$1
[[ "$NAME" == "98" ]] && NAME=""

# ==============================================================================
# MENU CHỌN DOMAIN NẾU CHẠY ĐỘC LẬP
# ==============================================================================
if [[ -z "$NAME" ]]; then
  . /etc/wptt/tenmien-them-lua-chon-tat-ca-website-by-wordpress
  echo -e "\n${C_CYAN}╭──────────────────────────────────────────────────────────────────────────────╮${C_RESET}"
  center_text "${C_YELLOW}TỐI ƯU & BẢO MẬT ➜ Lựa chọn website quét bảo mật:${C_RESET}"
  echo -e "${C_CYAN}╰──────────────────────────────────────────────────────────────────────────────╯${C_RESET}"
  lua_chon_NAME
fi

# ==============================================================================
# XỬ LÝ VÒNG LẶP CHO "TẤT CẢ WEBSITE"
# ==============================================================================
if [[ "$NAME" == 'Tất cả website' ]]; then
  if [ "$(ls -A /etc/wptt/vhost 2>/dev/null)" ]; then
    for entry in $(ls -A /etc/wptt/vhost | grep -v '^\.\.conf$' | sort -uV); do
      domain=$(echo "$entry" | sed 's/^.//' | sed 's/.conf//')
      path_html="/usr/local/lsws/$domain/html"
      
      # Chỉ quét các website là WordPress
      if [[ -f "$path_html/wp-config.php" ]]; then
        echo -e "\n${C_YELLOW}➜ Đang tiến hành quét bảo mật hàng loạt: ${C_GREEN}$domain${C_RESET}"
        # SỬ DỤNG BASH ĐỂ TRÁNH TRÀN BIẾN MÔI TRƯỜNG
        bash /etc/wptt/add-one/quet-bao-mat-wordpress.sh "$domain" "skip_menu"
      fi
    done
  fi

  [[ "$2" != "skip_menu" && "${1:-}" == "98" ]] && . /etc/wptt/wptt-add-one-main 1
  exit 0
fi

[[ "$NAME" == "0" || -z "$NAME" ]] && { [[ "${1:-}" == "98" ]] && . /etc/wptt/wptt-add-one-main 1; exit 0; }

# ==============================================================================
# ĐIỀU KIỆN KIỂM TRA ĐẦU VÀO
# ==============================================================================
pathcheck="/etc/wptt/vhost/.$NAME.conf"
if [[ ! -f "$pathcheck" ]]; then
  echo -e "\n${C_RED}❌ Tên miền không tồn tại trên hệ thống này!${C_RESET}"
  sleep 3
  [[ "${1:-}" == "98" ]] && . /etc/wptt/wptt-add-one-main 1
  exit 0
fi

wp_config="/usr/local/lsws/$NAME/html/wp-config.php"
if [[ ! -f "$wp_config" ]]; then
  echo -e "\n${C_RED}❌ Hệ thống xác nhận $NAME không sử dụng WordPress!${C_RESET}"
  echo -e "${C_YELLOW}Tính năng này chỉ hoạt động trên nền tảng mã nguồn WordPress.${C_RESET}"
  sleep 3
  [[ "${1:-}" == "98" ]] && . /etc/wptt/wptt-add-one-main 1
  exit 0
fi

# ==============================================================================
# BẮT ĐẦU QUÁ TRÌNH QUÉT
# ==============================================================================
echo -e "\n${C_CYAN}╭──────────────────────────────────────────────────────────────────────────────╮${C_RESET}"
center_text "BẮT ĐẦU QUÉT BẢO MẬT: ${C_YELLOW}$NAME${C_RESET}"
echo -e "${C_CYAN}╰──────────────────────────────────────────────────────────────────────────────╯${C_RESET}"

# 1. CÀI ĐẶT THƯ VIỆN GÓI WP-CLI NẾU THIẾU
_runing "Kiểm tra và chuẩn bị thư viện Vulnerability Scanner..."
if ! wp package list --allow-root 2>/dev/null | grep -q -i 'wpcli-vulnerability-scanner'; then
  wp package install 10up/wpcli-vulnerability-scanner:dev-stable --allow-root >/dev/null 2>&1
fi
_rundone "Chuẩn bị thư viện WP-CLI hoàn tất"

# Tải cấu hình PHP của domain và cấu hình vhost
. /etc/wptt/php/wptt-php-service-cli-theo-domain "$NAME" 2>/dev/null
. "$pathcheck" 2>/dev/null

# 2. BYPASS LOCKDOWN & CẤU HÌNH WORDFENCE API
is_locked=0
if [[ "$lock_down" == "1" ]]; then
  is_locked=1
  # Mở khóa tạm thời để lệnh sed hoạt động
  chattr -i "$wp_config" 2>/dev/null
fi

sed -i "/VULN_API_PROVIDER/d" "$wp_config"
sed -i "/<?php/a define( 'VULN_API_PROVIDER', 'wordfence' );" "$wp_config"

# 3. THỰC THI QUÉT LỖ HỔNG (WORDFENCE VULNERABILITY SCANNER)
echo -e "\n${C_CYAN}➜ Đang quét lỗ hổng Plugin/Theme/Core bằng dữ liệu Wordfence...${C_RESET}"
echo -e "${C_YELLOW}------------------------------------------------------------------------------${C_RESET}"
wp vuln status --allow-root --path="/usr/local/lsws/$NAME/html"
echo -e "${C_YELLOW}------------------------------------------------------------------------------${C_RESET}"

# 4. LỚP KHIÊN 1: KIỂM TRA MÃ BĂM (CHECKSUM) CORE & PLUGIN
echo -e "\n${C_CYAN}➜ Đang kiểm tra tính toàn vẹn của mã nguồn gốc (Checksum)...${C_RESET}"
echo -e "${C_YELLOW}------------------------------------------------------------------------------${C_RESET}"
wp core verify-checksums --allow-root --path="/usr/local/lsws/$NAME/html"

# Quét checksum plugin (lọc bỏ các cảnh báo của plugin trả phí không có trên repo WP)
wp plugin verify-checksums --all --allow-root --path="/usr/local/lsws/$NAME/html" 2>&1 | grep -v 'Warning: Plugin not found' | grep -v 'Success: Plugin verifies'
echo -e "${C_YELLOW}------------------------------------------------------------------------------${C_RESET}"

# 5. LỚP KHIÊN 2: QUÉT MÃ ĐỘC (BACKDOOR/EVAL) BẰNG REGEX HỆ THỐNG
echo -e "\n${C_CYAN}➜ Đang truy quét mã độc (Backdoor/Base64) bằng lõi hệ điều hành...${C_RESET}"

# Quét tập trung vào thư mục wp-content để lùng sục các hàm nguy hiểm
malware_files=$(grep -Rn --include=\*.php -E "eval\s*\(\s*base64_decode|eval\s*\(\s*gzinflate|base64_decode\s*\(\s*str_rot13|shell_exec\s*\(|system\s*\(|passthru\s*\(" "/usr/local/lsws/$NAME/html/wp-content")

if [[ -n "$malware_files" ]]; then
    echo -e "${C_RED}[!] CẢNH BÁO BẢO MẬT: Phát hiện các đoạn code khả nghi (Có thể là Backdoor/Webshell):${C_RESET}"
    echo "$malware_files" | awk -F: '{print "   - Bị nghi ngờ tại file: " $1 " (Dòng " $2 ")"}'
else
    echo -e "${C_GREEN}✔ An toàn: Không phát hiện các hàm mã độc phổ biến trong thư mục wp-content.${C_RESET}"
fi

# 6. DỌN DẸP & ĐÓNG KHÓA LẠI (RESTORE)
sed -i "/VULN_API_PROVIDER/d" "$wp_config"

if [[ "$is_locked" -eq 1 ]]; then
  chattr +i "$wp_config" 2>/dev/null
fi

_rundone "Hoàn tất quá trình Quét bảo mật toàn diện cho $NAME"
echo ""

[[ "$2" != "skip_menu" && "${1:-}" == "98" ]] && . /etc/wptt/wptt-add-one-main 1
