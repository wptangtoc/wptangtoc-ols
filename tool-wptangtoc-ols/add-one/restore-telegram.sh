#!/bin/bash
# @author: Gia Tuấn
# @website: https://wptangtoc.com
# @email: giatuan@wptangtoc.com
# @since: 2026
# shellcheck disable=SC2154,SC1090,SC1091

function huong_dan() {
  Tính năng tải [download] file sao lưu từ hệ thống Telegram Bot về máy chủ của bạn.
  Hệ thống sẽ tự động tìm kiếm, tải xuống và ghép nối các file bị phân mảnh [split parts]
  trở thành một file hoàn chỉnh [Zip/SQL] để chuẩn bị cho quá trình khôi phục.
}

. /etc/wptt/.wptt.conf 2>/dev/null
[[ -z "$ngon_ngu" ]] && ngon_ngu='vi'
# Vá lỗi SC2086: Bọc ngoặc kép cho đường dẫn chứa biến
. "/etc/wptt/lang/$ngon_ngu.sh" 2>/dev/null
. /etc/wptt/echo-color 2>/dev/null
. /etc/wptt/core-functions 2>/dev/null # Nạp thư viện UI Xác nhận

export box_inner_width=78

clear
echo -e "${C_CYAN}╭──────────────────────────────────────────────────────────────────────────────╮${C_RESET}"
center_text "${C_YELLOW}SAO LƯU & KHÔI PHỤC ➜ Tải file backup từ Telegram${C_RESET}"
echo -e "${C_CYAN}╰──────────────────────────────────────────────────────────────────────────────╯\n${C_RESET}"
echo "Tải file backup từ Telegram: $(date '+%d-%m-%Y %H:%M')" >>/var/log/wptangtoc-ols.log

. /etc/wptt/tenmien
lua_chon_NAME "Download file backup từ Telegram"

# Vá lỗi SC2317: Tách logic để ShellCheck không bị nhầm lẫn
if [[ "$NAME" == "0" || -z "$NAME" ]]; then
  if [[ "${1:-}" == "98" ]]; then
    exec /etc/wptt/wptt-backup-restore-main 1
  fi
  return 2>/dev/null || exit 0
fi

pathcheck="/etc/wptt/vhost/.$NAME.conf"
if [[ ! -f "$pathcheck" ]]; then
  echo -e "\n${C_RED}Tên miền không tồn tại trên hệ thống này!${C_RESET}"
  sleep 3
  # Vá lỗi SC2317
  if [[ "${1:-}" == "98" ]]; then
    exec /etc/wptt/wptt-backup-restore-main 1
  fi
  return 2>/dev/null || exit 0
fi

TG_BASE_URL="https://api.telegram.org"
if ! curl -I -s -m 3 "$TG_BASE_URL" > /dev/null 2>&1; then
    API_PROXY=$(curl -sL -m 10 -H "User-Agent: wptangtoc ols get telegram" "https://hub.wptangtoc.com/get-telegram-work" | tr -d '\r\n[:space:]')
    [[ "$API_PROXY" == *"workers.dev"* ]] && TG_BASE_URL="https://$API_PROXY"
fi

echo ""
_runing "Đang kết nối đến máy chủ WPTangToc để lấy danh sách file..."
log_file=$(mktemp -p /dev/shm)
selects=()

curl -X POST -s "https://hub.wptangtoc.com/restore" -H "Content-Type: application/json" -A 'Activate Backup Restore WPTangToc' > "$log_file"

danh_sach=$(cat "$log_file" | cut -f2 -d ' ' | sed 's/\.part_[0-9]\+$//' | grep "^${NAME}_" | uniq | head -n 100)

if [[ -z "$danh_sach" ]]; then
  _runloi "Truy xuất danh sách thất bại"
  echo -e "${C_YELLOW}Không tìm thấy bản sao lưu nào cho domain $NAME trên Telegram!${C_RESET}"
  rm -f "$log_file"
  sleep 3
  [[ "${1:-}" == "98" ]] && exec /etc/wptt/wptt-backup-restore-main 1
  exit 0
fi

_rundone "Đã lấy danh sách file thành công!"
echo ""

while IFS= read -r line; do selects+=("$line"); done <<<"$danh_sach"

echo -e "${C_CYAN}╭──────────────────────────────────────────────────────────────────────────────╮${C_RESET}"
center_text "${C_YELLOW}DANH SÁCH CÁC BẢN SAO LƯU TRÊN TELEGRAM${C_RESET}"
echo -e "${C_CYAN}├──────────────────────────────────────────────────────────────────────────────┤${C_RESET}"

 i=1
for file_bk in "${selects[@]}"; do
   item_text=$(printf "  ${C_CYAN}%3d)${C_RESET} ${C_BOLD_WHITE}%s${C_RESET}" "$i" "$file_bk")
   clean_text=$(printf "  %3d) %s" "$i" "$file_bk")
   item_len=$(echo -n "$clean_text" | awk '{print length($0)}')
   pad=$((box_inner_width - item_len))
  [[ $pad -lt 0 ]] && pad=0
  echo -e "${C_CYAN}│${C_RESET}${item_text}$(printf '%*s' "$pad" "")${C_CYAN}│${C_RESET}"
  ((i++))
done
echo -e "${C_CYAN}╰──────────────────────────────────────────────────────────────────────────────╯${C_RESET}"

fzf_installed=false
if command -v fzf &>/dev/null; then
  fzf_installed=true
  PROMPT_TEXT="Nhập bản cần tải (1-${#selects[@]}) [00=Tìm nhanh] [0=Thoát]: "
else
  PROMPT_TEXT="Nhập bản cần tải (1-${#selects[@]}) [0=Thoát]: "
fi

file1=""
while true; do
  echo -en "${C_CYAN}${PROMPT_TEXT}${C_RESET}"
  if ! read -r REPLY; then exit 1; fi
  REPLY=$(echo "$REPLY" | tr -d ' ' | tr '[:upper:]' '[:lower:]')

  case "$REPLY" in
  0)
    echo -e "\n${C_GREEN}Đang thoát...${C_RESET}"
    rm -f "$log_file"
    [[ "${1:-}" == "98" ]] && exec /etc/wptt/wptt-backup-restore-main 1
    exit 0
    ;;
  00)
    if $fzf_installed; then
      selected_name=$(printf '%s\n' "${selects[@]}" | nl -w 3 -s ': ' | fzf --prompt="Tìm bản sao lưu >> " --height=40% --border=rounded --color=border:red --cycle --reverse)
      # Vá lỗi SC2001: Dùng nội tại Bash để cắt chuỗi thay vì dùng lệnh sed
      selected_name="${selected_name#*: }"
      
      if [[ -n "$selected_name" ]]; then
        file1="$selected_name"
        break
      else echo -e "${C_YELLOW}Đã hủy chọn.${C_RESET}"; fi
    fi
    ;;
  *)
    if [[ "$REPLY" =~ ^[0-9]+$ ]] && [ "$REPLY" -ge 1 ] && [ "$REPLY" -le ${#selects[@]} ]; then
      action_index=$((REPLY - 1))
      file1="${selects[$action_index]}"
      break
    else
      echo -e "\n${C_RED}❌ Lựa chọn không hợp lệ!${C_RESET}"
    fi
    ;;
  esac
done

# ==============================================================================
# HÀM TẢI & GHÉP NỐI (BẢO CHỨNG 100% TOÀN VẸN DATA)
# ==============================================================================
download_and_merge_telegram() {
  local target_file="$1"
  local path_dl="/usr/local/backup-website/$NAME"
  mkdir -p "$path_dl"
  rm -f "$path_dl/$target_file"

  echo -e "\n${C_CYAN}➜ Đang xử lý tải xuống: ${C_YELLOW}$target_file${C_RESET}"
  
  mapfile -t dulieu_all < <(grep "$target_file" "$log_file" | sort -k2,2V)
  
  for du_lieu in "${dulieu_all[@]}"; do
    # Vá lỗi SC2155: Khai báo local riêng, gán giá trị riêng
    local file_id
    file_id=$(echo "$du_lieu" | cut -f1 -d ' ')
    
    local ten_file_part
    ten_file_part=$(echo "$du_lieu" | cut -f2 -d ' ')
    
    local get_file_url="${TG_BASE_URL}/bot${telegram_api}/getFile"
    
    local file_info
    file_info=$(curl -s -X POST "$get_file_url" -d file_id="$file_id")
    
    local file_path
    file_path=$(echo "$file_info" | jq -r '.result.file_path')
    
    local file_size_api
    file_size_api=$(echo "$file_info" | jq -r '.result.file_size')
    
    if [[ "$file_path" == "null" || -z "$file_path" ]]; then
      _runloi "Không thể lấy link tải mảnh: $ten_file_part"
      return 1
    fi

    echo -e "   ${C_CYAN}➜ Đang tải kết nối mảnh:${C_RESET} $ten_file_part"
    local download_url="${TG_BASE_URL}/file/bot${telegram_api}/$file_path"
    
    # Ẩn Progress bar để chống gãy Pipe, chỉ báo trạng thái tải tĩnh
    curl -sL -f -o "$path_dl/$ten_file_part" "$download_url"
    
    if [[ -f "$path_dl/$ten_file_part" ]]; then
      # SIÊU KIỂM TRA CHÉO: Dữ liệu tải về phải khớp 100% Byte với Telegram báo cáo
      local downloaded_size
      downloaded_size=$(stat -c %s "$path_dl/$ten_file_part")
      
      if [[ "$downloaded_size" != "$file_size_api" ]]; then
          _runloi "Lỗi rớt mạng! Dung lượng mảnh $ten_file_part bị thiếu."
          return 1
      fi
      
      # An toàn 100% rồi mới cho phép nối file (cat)
      if [[ "$ten_file_part" == *".part_"* ]]; then
        cat "$path_dl/$ten_file_part" >> "$path_dl/$target_file"
        rm -f "$path_dl/$ten_file_part"
      fi
    else
      _runloi "Tải mảnh thất bại: $ten_file_part"
      return 1
    fi
  done
  
  _rundone "Hoàn tất ghép nối 100% an toàn: $target_file"
  return 0
}

echo ""
dongy_taifile1="n"
if wptt_xac_nhan "Xác nhận để tải File này về máy chủ?" "${C_BOLD_WHITE}Tên file:${C_RESET} ${C_YELLOW}$file1${C_RESET}" "" "Đồng ý Tải" "Hủy bỏ"; then
  dongy_taifile1="y"
  download_and_merge_telegram "$file1"
fi

echo ""
dongy_taifile2="n"
file2=""

filtered_selects=()
for f in "${selects[@]}"; do
  [[ "$f" != "$file1" ]] && filtered_selects+=("$f")
done
selects=("${filtered_selects[@]}")

if [[ ${#selects[@]} -gt 0 && "$dongy_taifile1" == "y" ]]; then
  
  if echo "$file1" | grep -Eq "\.(zip)$"; then
    echo -e "${C_YELLOW}Gợi ý:${C_RESET} Bạn đã tải file Mã nguồn. Nên tải thêm Database để khôi phục đồng bộ."
    ggdrthem="File Database (.sql.gz)"
  elif echo "$file1" | grep -Eq "\.(sql\.gz)$"; then
    echo -e "${C_YELLOW}Gợi ý:${C_RESET} Bạn đã tải file Database. Nên tải thêm Mã nguồn để khôi phục đồng bộ."
    ggdrthem="File Mã nguồn (.zip)"
  fi

  if [[ -n "$ggdrthem" ]]; then
    if wptt_xac_nhan "Bạn có muốn TIẾP TỤC tải thêm $ggdrthem không?" "" "" "Có (Tải thêm)" "Không cần"; then
      echo ""
      echo -e "${C_CYAN}╭──────────────────────────────────────────────────────────────────────────────╮${C_RESET}"
      center_text "${C_YELLOW}CHỌN FILE BỔ SUNG TỪ DANH SÁCH TELEGRAM${C_RESET}"
      echo -e "${C_CYAN}├──────────────────────────────────────────────────────────────────────────────┤${C_RESET}"
      i=1
      for file in "${selects[@]}"; do
        item_text=$(printf "  ${C_CYAN}%3d)${C_RESET} ${C_BOLD_WHITE}%s${C_RESET}" "$i" "$file")
        clean_text=$(printf "  %3d) %s" "$i" "$file")
        item_len=$(echo -n "$clean_text" | awk '{print length($0)}')
        pad=$((box_inner_width - item_len))
        [[ $pad -lt 0 ]] && pad=0
        echo -e "${C_CYAN}│${C_RESET}${item_text}$(printf '%*s' "$pad" "")${C_CYAN}│${C_RESET}"
        ((i++))
      done
      echo -e "${C_CYAN}╰──────────────────────────────────────────────────────────────────────────────╯${C_RESET}"

      while true; do
        echo -en "${C_CYAN}Nhập số thứ tự File cần tải (1-${#selects[@]}) [0=Bỏ qua]: ${C_RESET}"
        read -r REPLY
        if [[ "$REPLY" == "0" ]]; then
          break
        elif [[ "$REPLY" =~ ^[0-9]+$ ]] && [ "$REPLY" -ge 1 ] && [ "$REPLY" -le ${#selects[@]} ]; then
          action_index=$((REPLY - 1))
          file2="${selects[$action_index]}"
          break
        else
          echo -e "${C_RED}❌ Lựa chọn không hợp lệ! Vui lòng chọn lại.${C_RESET}"
        fi
      done

      if [[ -n "$file2" ]]; then
        dongy_taifile2="y"
        download_and_merge_telegram "$file2"
      fi
    fi
  fi
fi

rm -f "$log_file"

echo ""
echo -e "${C_GREEN}╭──────────────────────────────────────────────────────────────────────────────╮${C_RESET}"
center_text "${C_BOLD_WHITE}TIẾN TRÌNH DOWNLOAD TỪ TELEGRAM HOÀN TẤT${C_RESET}"
echo -e "${C_GREEN}├──────────────────────────────────────────────────────────────────────────────┤${C_RESET}"

has_error=false

if [[ "$dongy_taifile1" == "y" ]]; then
  if [[ -f "/usr/local/backup-website/$NAME/$file1" ]]; then
    left_text "▪ Đã lưu & ghép xong: ${C_GREEN}$file1${C_RESET}" 2
  else
    left_text "▪ Lỗi tải xuống     : ${C_RED}$file1${C_RESET}" 2
    has_error=true
  fi
fi

if [[ "$dongy_taifile2" == "y" && -n "$file2" ]]; then
  if [[ -f "/usr/local/backup-website/$NAME/$file2" ]]; then
    left_text "▪ Đã lưu & ghép xong: ${C_GREEN}$file2${C_RESET}" 2
  else
    left_text "▪ Lỗi tải xuống     : ${C_RED}$file2${C_RESET}" 2
    has_error=true
  fi
fi

if ! $has_error && [[ "$dongy_taifile1" == "y" || "$dongy_taifile2" == "y" ]]; then
  echo -e "${C_GREEN}├──────────────────────────────────────────────────────────────────────────────┤${C_RESET}"
  left_text "Khu vực lưu trữ: /usr/local/backup-website/$NAME/"
  echo -e "${C_GREEN}╰──────────────────────────────────────────────────────────────────────────────╯\n${C_RESET}"
  echo -e "${C_CYAN}Ghi chú:${C_RESET} File đã sẵn sàng. Bạn có thể sử dụng Menu Khôi phục ngay bây giờ."
  echo "Nếu bạn cần restore hãy vào menu sao lưu và khôi phục [5] => khôi phục website [2]"
else
  echo -e "${C_GREEN}├──────────────────────────────────────────────────────────────────────────────┤${C_RESET}"
  left_text "${C_YELLOW}Trạng thái: Có file bị lỗi hoặc bạn đã hủy tải xuống!${C_RESET}"
  echo -e "${C_GREEN}╰──────────────────────────────────────────────────────────────────────────────╯\n${C_RESET}"
fi

sleep 3
[[ "${1:-}" == "98" ]] && exec /etc/wptt/wptt-backup-restore-main 1
