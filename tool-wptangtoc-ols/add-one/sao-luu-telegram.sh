#!/bin/bash
# @author: Gia Tuấn
# @website: https://wptangtoc.com
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
    . /etc/wptt/tenmien-them-lua-chon-tat-ca-website
    echo -e "\n${C_CYAN}╭──────────────────────────────────────────────────────────────────────────────╮${C_RESET}"
    center_text "${C_YELLOW}BACKUP & RESTORE ➜ Chọn website sao lưu lên Telegram:${C_RESET}"
    echo -e "${C_CYAN}╰──────────────────────────────────────────────────────────────────────────────╯${C_RESET}"
    lua_chon_NAME
fi

# ==============================================================================
# XỬ LÝ VÒNG LẶP CHO "TẤT CẢ WEBSITE"
# ==============================================================================
if [[ "$NAME" == 'Tất cả website' ]]; then
    if [ "$(ls -A /etc/wptt/vhost 2>/dev/null)" ]; then
        for entry in $(ls -A /etc/wptt/vhost | grep -E '\.conf$' | grep -v '^\.\.conf$' | sort -uV); do
            domain=$(echo "$entry" | sed 's/^.//' | sed 's/.conf//')
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

# ==============================================================================
# TIẾN HÀNH SAO LƯU WEBSITE CHỈ ĐỊNH
# ==============================================================================
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

# ==============================================================================
# HÀM GỬI FILE LÊN TELEGRAM
# ==============================================================================
telegram_uploads_backup() {
    local file_path=$1
    local domain_name=$2
    local date_time="$(date "+%d-%m-%Y %H:%M")"
    
    local type="Mã nguồn (Source)"
    [[ "$file_path" == *".sql.gz"* ]] && type="Cơ sở dữ liệu (Database)"
    
    # KHẮC PHỤC LỖI XUỐNG DÒNG: Dùng printf -v để tạo ký tự newline chuẩn của Bash
    printf -v caption "📦 *Backup %s*\n🌐 Tên miền: \`%s\`\n🖥 Máy chủ: \`%s\`\n⏰ Thời gian: %s" "$type" "$domain_name" "$IP_VPS" "$date_time"
    
    local worker_url="https://worker-soft-shape-e788.hoangtuan0137.workers.dev/bot${telegram_api}/sendDocument"
    
    local max_retries=3
    local attempt=1
    local success=0
    
    while (( attempt <= max_retries && success == 0 )); do
        local response=$(curl -4 -s -S -X POST "$worker_url" \
            -F document=@"${file_path}" \
            -F parse_mode='Markdown' \
            -F caption="${caption}" \
            -F disable_notification=true \
            -F chat_id="${telegram_id}")
            
        local file_id=$(echo "$response" | jq -r '.result.document.file_id // empty')
        local file_name=$(echo "$response" | jq -r '.result.document.file_name // empty')
        
        if [[ -n "$file_id" && -n "$file_name" ]]; then
            echo "$file_id $file_name" >> "$temp_file"
            success=1
        else
            echo -e "   ${C_RED}[!] Lỗi API Telegram (Thử lại $attempt/$max_retries sau 5s)...${C_RESET}"
            sleep 5
            ((attempt++))
        fi
    done
}

timedate=$(date +\_%Mphut\_%Hgio\_%d\_%m\_%Y)
. "/etc/wptt/vhost/.$domain.conf"

# Kiểm tra Disk xem đủ chỗ chứa file backup không
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
TEMP_CNF=$(mktemp)
chmod 600 "$TEMP_CNF"
cat >"$TEMP_CNF" <<EOF
[client]
user=${DB_User_web}
password=${DB_Password_web}
host=localhost
max_allowed_packet=1G
default-character-set=utf8mb4
EOF

db_path="/usr/local/backup-website/$domain/${domain}${timedate}.sql.gz"
mariadb-dump --defaults-extra-file="$TEMP_CNF" "$DB_Name_web" | gzip > "$db_path"
rm -rf "$TEMP_CNF"

if [[ -s "$db_path" ]]; then
    _rundone "Sao lưu Database thành công"
    
    file_size_sql=$(stat -c %s "$db_path")
    file_size_mb_sql=$(echo "scale=2; $file_size_sql/1024/1024" | bc)
    
    echo -e "${C_CYAN}➜ Đang đẩy Database ($file_size_mb_sql MB) lên Telegram...${C_RESET}"
    if (( $(echo "$file_size_mb_sql > 19" | bc -l) )); then
        split -b 19m -d -a 4 --numeric-suffixes=1 "$db_path" "${db_path}.part_"
        for sql_part in $(ls -A "/usr/local/backup-website/$domain" | grep "${domain}${timedate}.sql.gz.part_" | sort -u); do
            echo "  - Uploading phần $sql_part..."
            telegram_uploads_backup "/usr/local/backup-website/$domain/$sql_part" "$domain"
            rm -f "/usr/local/backup-website/$domain/$sql_part"
        done
    else
        telegram_uploads_backup "$db_path" "$domain"
    fi
else
    _runloi "Lỗi kết xuất Database!"
fi
rm -f "$db_path"


# 2. SAO LƯU MÃ NGUỒN (SOURCE CODE)
_runing "Đang nén Mã nguồn (Source Code)..."
zip_path="/usr/local/backup-website/$domain/${domain}${timedate}.zip"
cd "$path" && zip -r -q "$zip_path" * -x "wp-content/ai1wm-backups/*" -x "wp-content/cache/*" -x "wp-content/updraft/*" -x "error_log" -x "wp-content/debug.log" -x "wp-content/uploads/backupbuddy_backups/*" -x "wp-content/backups-dup-*/*"

if [[ -s "$zip_path" ]]; then
    _rundone "Nén Mã nguồn thành công"
    
    file_size=$(stat -c %s "$zip_path")
    file_size_mb=$(echo "scale=2; $file_size/1024/1024" | bc)
    
    echo -e "${C_CYAN}➜ Đang đẩy Mã nguồn ($file_size_mb MB) lên Telegram...${C_RESET}"
    if (( $(echo "$file_size_mb > 19" | bc -l) )); then
        split -b 19m -d -a 4 --numeric-suffixes=1 "$zip_path" "${zip_path}.part_"
        for zip_part in $(ls -A "/usr/local/backup-website/$domain" | grep "${domain}${timedate}.zip.part_" | sort -u); do
            echo "  - Uploading phần $zip_part..."
            telegram_uploads_backup "/usr/local/backup-website/$domain/$zip_part" "$domain"
            rm -f "/usr/local/backup-website/$domain/$zip_part"
        done
    else
        telegram_uploads_backup "$zip_path" "$domain"
    fi
else
    _runloi "Lỗi nén Mã nguồn!"
fi
rm -f "$zip_path"


# 3. GỬI DỮ LIỆU ĐỊNH DANH JSON LÊN MÁY CHỦ API (NO DRM)
if [[ -s "$temp_file" ]]; then
    json_payload=$(cat "$temp_file" | jq -R 'split(" ") | {file_id: .[0], file_name: .[1]}' | jq -s '.' | jq -c '.')
    API_URL="https://key.wptangtoc.com/backup.php" 
    curl -s -X POST -H "Content-Type: application/json" -d "$json_payload" "$API_URL" -A 'Activate Backup Restore WPTangToc' >/dev/null 2>&1
fi

rm -f "$temp_file"
echo ""

[[ "$2" != "skip_menu" && "${1:-}" == "98" ]] && . /etc/wptt/wptt-add-one-main 1
