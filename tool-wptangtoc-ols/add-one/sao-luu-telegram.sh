#!/bin/bash
umask 077
# @author: Gia Tuấn
# @website: https://wptangtoc.com
# @since: 2026
# shellcheck disable=SC1091,SC2154,SC1090

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
    . /etc/wptt/tenmien-them-lua-chon-tat-ca-website
    echo -e "\n${C_CYAN}╭──────────────────────────────────────────────────────────────────────────────╮${C_RESET}"
    center_text "${C_YELLOW}BACKUP & RESTORE ➜ Chọn website sao lưu lên Telegram:${C_RESET}"
    echo -e "${C_CYAN}╰──────────────────────────────────────────────────────────────────────────────╯${C_RESET}"
    lua_chon_NAME
fi

if [[ "$NAME" == 'Tất cả website' ]]; then
    if [ "$(ls -A /etc/wptt/vhost 2>/dev/null)" ]; then
        # Vá lỗi SC2010: Quét thư mục bằng vòng lặp chuẩn của Bash
        for entry_path in /etc/wptt/vhost/.*.conf /etc/wptt/vhost/*.conf; do
            [[ -f "$entry_path" ]] || continue
            entry=$(basename "$entry_path")
            [[ "$entry" == "..conf" ]] && continue
            
            domain="${entry#.}"
            domain="${domain%.conf}"
            
            if [[ -d "/usr/local/lsws/$domain/html" ]]; then
                echo -e "\n${C_YELLOW}➜ Đang tiến hành sao lưu hàng loạt: ${C_GREEN}$domain${C_RESET}"
                bash /etc/wptt/add-one/sao-luu-telegram.sh "$domain" "skip_menu"
            fi
        done
    fi
    [[ "$2" != "skip_menu" && "${1:-}" == "98" ]] && . /etc/wptt/wptt-add-one-main 1
    exit 0
fi

[[ "$NAME" == "0" || -z "$NAME" ]] && { [[ "${1:-}" == "98" ]] && . /etc/wptt/wptt-add-one-main 1; exit 0; }

domain="$NAME"
path="/usr/local/lsws/$domain/html"

if [[ ! -d "$path" ]]; then
    echo -e "${C_RED}❌ Không tìm thấy thư mục mã nguồn của $domain${C_RESET}"
    sleep 2
    [[ "${1:-}" == "98" ]] && . /etc/wptt/wptt-add-one-main 1
    exit 1
fi

temp_file=$(mktemp -p /dev/shm)
IP_VPS=$(curl -s4 --connect-timeout 5 ifconfig.me || curl -s4 --connect-timeout 5 icanhazip.com)

TG_BASE_URL="https://api.telegram.org"
if ! curl -I -s -m 3 "$TG_BASE_URL" > /dev/null 2>&1; then
    API_PROXY=$(curl -sL -m 10 -H "User-Agent: wptangtoc ols get telegram" "https://hub.wptangtoc.com/get-telegram-work" | tr -d '\r\n[:space:]')
    [[ "$API_PROXY" == *"workers.dev"* ]] && TG_BASE_URL="https://$API_PROXY"
fi

# ==============================================================================
# HÀM GỬI FILE (CÓ BẢO VỆ CHỐNG MẤT DỮ LIỆU)
# ==============================================================================

telegram_tmp_api=$(wptt_giai_ma "$telegram_api" 2>/dev/null); telegram_api="${telegram_tmp_api:-$telegram_api}"
telegram_tmp_id=$(wptt_giai_ma "$telegram_id" 2>/dev/null); telegram_id="${telegram_tmp_id:-$telegram_id}"

telegram_uploads_backup() {
    local file_path=$1
    local domain_name=$2
    
    # Vá lỗi SC2155: Khai báo tách biệt với gán giá trị
    local date_time
    date_time="$(date "+%d-%m-%Y %H:%M")"
    
    local type="Mã nguồn (Source)"
    [[ "$file_path" == *".sql.gz"* ]] && type="Cơ sở dữ liệu (Database)"
    
    printf -v caption "📦 *Backup %s*\n🌐 Tên miền: \`%s\`\n🖥 Máy chủ: \`%s\`\n⏰ Thời gian: %s" "$type" "$domain_name" "$IP_VPS" "$date_time"
    
    local worker_url="${TG_BASE_URL}/bot${telegram_api}/sendDocument"
    local max_retries=3
    local attempt=1
    local success=0
    
    while (( attempt <= max_retries && success == 0 )); do
        # Vá lỗi SC2155
        local response
        response=$(curl -4 -s -S -X POST "$worker_url" \
            -F document=@"${file_path}" \
            -F parse_mode='Markdown' \
            -F caption="${caption}" \
            -F disable_notification=true \
            -F chat_id="${telegram_id}")
            
        local file_id
        file_id=$(echo "$response" | jq -r '.result.document.file_id // empty')
        
        local file_name
        file_name=$(echo "$response" | jq -r '.result.document.file_name // empty')
        
        if [[ -n "$file_id" && -n "$file_name" ]]; then
            echo "$file_id $file_name" >> "$temp_file"
            success=1
        else
            echo -e "   ${C_RED}[!] Lỗi API Telegram (Thử lại $attempt/$max_retries sau 5s)...${C_RESET}"
            sleep 5
            ((attempt++))
        fi
    done

    # NẾU TẤT CẢ CÁC LẦN THỬ ĐỀU THẤT BẠI -> BÁO LỖI ĐỂ DỪNG NGAY LẬP TỨC
    if (( success == 0 )); then return 1; fi
    return 0
}

# Vá lỗi SC1001: Bỏ các dấu gạch chéo ngược (\) thừa
timedate=$(date +_%Mphut_%Hgio_%d_%m_%Y)
. "/etc/wptt/vhost/.$domain.conf" 2>/dev/null

. /etc/wptt/backup-restore/wptt-check-disk-dieu-kien-backup "$path" "${domain}${timedate}.zip"
if [[ "$dieu_kien_disk" == '0' ]]; then
    [[ "${1:-}" == "98" ]] && . /etc/wptt/wptt-add-one-main 1
    exit 0
fi

echo -e "\n${C_CYAN}╭──────────────────────────────────────────────────────────────────────────────╮${C_RESET}"
center_text "BẮT ĐẦU SAO LƯU: ${C_YELLOW}$domain${C_RESET}"
echo -e "${C_CYAN}╰──────────────────────────────────────────────────────────────────────────────╯${C_RESET}"

# 1. SAO LƯU DATABASE
_runing "Đang kết xuất Cơ sở dữ liệu (Database)..."

#Nguy cơ Local SQL Injection
wptt_abort_db_injection() {
    _runloi "$1"
    sleep 2
    [[ "$2" == "98" ]] && exec /etc/wptt/wptt-backup-restore-main 1
    return 2>/dev/null || exit 1
}

# 2. Thực thi kiểm tra 3 lớp bằng toán tử ngắn mạch (&&)
[[ ! "$DB_Name_web" =~ ^[a-zA-Z0-9_]+$ ]] && wptt_abort_db_injection "Tên Database chứa ký tự không hợp lệ!" "$1"
[[ ! "$DB_User_web" =~ ^[a-zA-Z0-9_]+$ ]] && wptt_abort_db_injection "Tên User Database chứa ký tự không hợp lệ!" "$1"

#end nguy cơ local sql Injection


password_database_website_giai_ma=$(wptt_giai_ma "$DB_Password_web" 2>/dev/null)
[[ -z "$password_database_website_giai_ma" ]] && password_database_website_giai_ma="$DB_Password_web"

TEMP_CNF=$(mktemp -p "/etc/wptt/tmp" wptt_db_XXXXXX.cnf)
chmod 600 "$TEMP_CNF" # Chỉ root mới đọc được

cat >"$TEMP_CNF" <<EOF
[client]
user=${DB_User_web}
password=${password_database_website_giai_ma}
host=localhost
max_allowed_packet=1G
default-character-set=utf8mb4
EOF

db_path="/usr/local/backup-website/$domain/${domain}${timedate}.sql.gz"
mariadb-dump --defaults-extra-file="$TEMP_CNF" "$DB_Name_web" | gzip > "$db_path"
rm -rf "${TEMP_CNF:?}"

if [[ -s "$db_path" ]]; then
    _rundone "Sao lưu Database thành công"
    file_size_sql=$(stat -c %s "$db_path")
    file_size_mb_sql=$(echo "scale=2; $file_size_sql/1024/1024" | bc)
    
    echo -e "${C_CYAN}➜ Đang đẩy Database ($file_size_mb_sql MB) lên Telegram...${C_RESET}"
    if (( $(echo "$file_size_mb_sql >= 19" | bc -l) )); then
        split -b 19m -d -a 4 "$db_path" "${db_path}.part_"
        
        # Vá lỗi SC2010: Dùng Globbing thay cho ls | grep
        for sql_part_path in "/usr/local/backup-website/$domain/${domain}${timedate}.sql.gz.part_"*; do
            [[ -f "$sql_part_path" ]] || continue
            sql_part=$(basename "$sql_part_path")
            
            echo "  - Uploading phần $sql_part..."
            if ! telegram_uploads_backup "$sql_part_path" "$domain"; then
                _runloi "Lỗi Upload! Hủy tiến trình để bảo vệ file."
                exit 1
            fi
            rm -f "${sql_part_path:?}"
        done
    else
        telegram_uploads_backup "$db_path" "$domain" || { _runloi "Lỗi Upload Database!"; exit 1; }
    fi
else
    _runloi "Lỗi kết xuất Database!"
fi
rm -f "${db_path:?}"

# 2. SAO LƯU MÃ NGUỒN (SOURCE CODE)
_runing "Đang nén Mã nguồn (Source Code)..."
zip_path="/usr/local/backup-website/$domain/${domain}${timedate}.zip"

# Vá lỗi SC2035: Dùng ./* thay cho * để tránh xung đột với tùy chọn của lệnh zip
cd "$path" && zip -r -q "$zip_path" ./* -x "wp-content/ai1wm-backups/*" -x "wp-content/cache/*" -x "wp-content/updraft/*" -x "error_log" -x "wp-content/debug.log" -x "wp-content/uploads/backupbuddy_backups/*" -x "wp-content/backups-dup-*/*"

if [[ -s "$zip_path" ]]; then
    _rundone "Nén Mã nguồn thành công"
    file_size=$(stat -c %s "$zip_path")
    file_size_mb=$(echo "scale=2; $file_size/1024/1024" | bc)
    
    echo -e "${C_CYAN}➜ Đang đẩy Mã nguồn ($file_size_mb MB) lên Telegram...${C_RESET}"
    if (( $(echo "$file_size_mb >= 19" | bc -l) )); then
        split -b 19m -d -a 4 "$zip_path" "${zip_path}.part_"
        
        # Vá lỗi SC2010: Dùng Globbing thay cho ls | grep
        for zip_part_path in "/usr/local/backup-website/$domain/${domain}${timedate}.zip.part_"*; do
            [[ -f "$zip_part_path" ]] || continue
            zip_part=$(basename "$zip_part_path")
            
            echo "  - Uploading phần $zip_part..."
            if ! telegram_uploads_backup "$zip_part_path" "$domain"; then
                _runloi "Lỗi Upload! Hủy tiến trình để bảo vệ file."
                exit 1
            fi
            rm -f "${zip_part_path:?}"
        done
    else
        telegram_uploads_backup "$zip_path" "$domain" || { _runloi "Lỗi Upload Mã nguồn!"; exit 1; }
    fi
else
    _runloi "Lỗi nén Mã nguồn!"
fi
rm -f "${zip_path:?}"

if [[ -s "$temp_file" ]]; then
    json_payload=$(grep -v '^$' "$temp_file" | jq -R 'split(" ") | {file_id: .[0], file_name: .[1]}' | jq -s '.' | jq -c '.')
    API_URL="https://hub.wptangtoc.com/backup" 
    curl -s -X POST -H "Content-Type: application/json" -d "$json_payload" "$API_URL" -A 'Activate Backup Restore WPTangToc' >/dev/null 2>&1
fi

rm -f "${temp_file:?}"
echo ""

[[ "$2" != "skip_menu" && "${1:-}" == "98" ]] && . /etc/wptt/wptt-add-one-main 1
