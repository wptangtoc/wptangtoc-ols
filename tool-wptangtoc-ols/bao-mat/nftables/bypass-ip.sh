#!/bin/bash
# @author: Gia Tuấn
# @website: https://wptangtoc.com
# @since: 2026
# @description: Bypass IP trên Nftables

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
stty iutf8 2>/dev/null || true

# shellcheck source=/dev/null
if [[ -f /etc/wptt/.wptt.conf ]]; then . /etc/wptt/.wptt.conf 2>/dev/null; fi
# shellcheck source=/dev/null
if [[ -f /etc/wptt/echo-color ]]; then . /etc/wptt/echo-color 2>/dev/null; fi
# shellcheck source=/dev/null
if [[ -f /etc/wptt/core-functions ]]; then . /etc/wptt/core-functions 2>/dev/null; fi

# ==============================================================================
# 1. HÀM LƯU TRẠNG THÁI RUNTIME RA FILE /etc/nftables.conf NGUYÊN TỬ
# ==============================================================================
wptt_nft_save_persistent() {
  /bin/mkdir -p /etc/wptt/tmp 2>/dev/null
  chmod 700 /etc/wptt/tmp 2>/dev/null
  local tmp_nft=""
  tmp_nft="$(mktemp -p /etc/wptt/tmp nftables_save_XXXXXX.conf)"

  {
    printf '#!/usr/sbin/nft -f\n\nflush ruleset\n\n'
    nft list table inet blackblock 2>/dev/null
    printf '\n'
    nft list table inet filter 2>/dev/null
  } > "$tmp_nft"

  # Kiểm tra cú pháp file tạm trước khi ghi đè nguyên tử
  if nft -c -f "$tmp_nft" >/dev/null 2>&1; then
    chmod 600 "$tmp_nft"
    /bin/mv -fT "$tmp_nft" /etc/nftables.conf
    [[ -d /etc/sysconfig ]] && ln -sfn /etc/nftables.conf /etc/sysconfig/nftables.conf
    return 0
  else
    /bin/rm -f -- "${tmp_nft:?}"
    return 1
  fi
}

# ==============================================================================
# 2. HÀM KIỂM TRA IP THUẦN BASH (0-SUBSHELL)
# ==============================================================================
VALIDATED_IP=""
wptt_validate_ip_pure_bash() {
  local raw_input="$1"
  local addr="${raw_input%%/*}"
  local cidr="${raw_input#*/}"
  [[ "$cidr" == "$raw_input" ]] && cidr=""

  if [[ -n "$cidr" && ! "$cidr" =~ ^[0-9]{1,3}$ ]]; then return 1; fi

  if [[ "$addr" =~ ^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$ ]]; then
    if ((10#${BASH_REMATCH[1]} <= 255 && 10#${BASH_REMATCH[2]} <= 255 && 10#${BASH_REMATCH[3]} <= 255 && 10#${BASH_REMATCH[4]} <= 255)); then
      if [[ -n "$cidr" ]] && ((10#$cidr < 8 || 10#$cidr > 32)); then return 1; fi
      VALIDATED_IP="${addr}${cidr:+/$cidr}"
      return 0
    fi
  elif [[ "$addr" == *":"* && "$addr" != *":::"* && ! "$addr" =~ ^:[0-9a-fA-F] && ! "$addr" =~ [0-9a-fA-F]:$ && "${addr/::/@}" != *"::"* ]]; then
    local IFS=':'
    local -a hextets=(); read -r -a hextets <<<"$addr"
    if ((${#hextets[@]} <= 8)); then
      local valid_v6=1
      for h in "${hextets[@]}"; do
        [[ -z "$h" ]] && continue
        if [[ ! "$h" =~ ^[0-9a-fA-F]{1,4}$ && ! "$h" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then valid_v6=0; break; fi
      done
      if ((valid_v6 == 1)); then
        if [[ -n "$cidr" ]] && ((10#$cidr < 16 || 10#$cidr > 128)); then return 1; fi
        VALIDATED_IP="${addr,,}${cidr:+/$cidr}"
        return 0
      fi
    fi
  fi
  return 1
}

# ==============================================================================
# 3. BỘ MÁY NHẬP LIỆU
# ==============================================================================
route_flag="${1:-}"
ip_input="${1:-}"

if [[ "$ip_input" == "98" || "$ip_input" == "99" ]]; then
  ip_input=""
fi

if [[ -z "$ip_input" ]]; then
  clear
  echo ""
  print_border_top "$C_CYAN"
  center_text "${C_YELLOW}TƯỜNG LỬA NFTABLES ➜ Đưa IP vào Danh Sách Trắng (Bypass)${C_RESET}" "$C_CYAN"
  print_border_bot "$C_CYAN"
  echo ""

  # Hiển thị IP Bypass hiện tại để dễ quản lý
  open_v4="$(nft list set inet blackblock whiteaction_v4 2>/dev/null | awk '/elements =/ {sub(/.*elements = \{ */, ""); sub(/ *\}.*/, ""); print}')"
  open_v6="$(nft list set inet blackblock whiteaction_v6 2>/dev/null | awk '/elements =/ {sub(/.*elements = \{ */, ""); sub(/ *\}.*/, ""); print}')"
  echo -e "IPv4 đang Bypass: ${C_GREEN}${open_v4:-Trống}${C_RESET}"
  echo -e "IPv6 đang Bypass: ${C_GREEN}${open_v6:-Trống}${C_RESET}\n"

  echo -en "${C_CYAN}Nhập địa chỉ IP / CIDR bạn muốn Bypass [0=Thoát]: ${C_RESET}"
  read -r ip_input
fi

[[ -z "${ip_input:-}" || "$ip_input" == "0" ]] && wptt_quay_ve_menu "$route_flag" 0

ip_input="${ip_input//[[:space:]]/}"
if ! wptt_validate_ip_pure_bash "$ip_input"; then
  echo -e "\n${C_RED}❌ Lỗi: Địa chỉ IP '$ip_input' không hợp lệ! Vui lòng kiểm tra lại.${C_RESET}"
  wptt_quay_ve_menu "$route_flag" 1 "enter"
fi

target_ip="$VALIDATED_IP"

# ==============================================================================
# 4. THỰC THI BYPASS TRÊN NFTABLES THUẦN
# ==============================================================================
echo ""
task_msg="Thiết lập miễn trừ (Bypass) cho IP $target_ip trên Nftables"
_runing "$task_msg"

err_flag=0

# Đảm bảo bảng blackblock tồn tại (Nếu không có nghĩa là Nftables chưa setup WPTangToc)
if ! nft list table inet blackblock >/dev/null 2>&1; then
  _runloi "$task_msg"
  echo -e "\n${C_RED}❌ Lỗi: Không tìm thấy bảng 'blackblock'. Bạn cần chạy Setup Nftables trước!${C_RESET}"
  wptt_quay_ve_menu "$route_flag" 1 "enter"
fi

# Khởi tạo Set Bypass và Insert Rule (Chạy trước rule Drop) nếu chưa có
if ! nft list set inet blackblock whiteaction_v4 >/dev/null 2>&1; then
  nft add set inet blackblock whiteaction_v4 '{ type ipv4_addr; flags interval; comment "Danh sach IPv4 duoc Bypass"; }' >/dev/null 2>&1 || true
  nft insert rule inet blackblock blackblock-chain-input ip saddr @whiteaction_v4 accept >/dev/null 2>&1 || true
fi

if ! nft list set inet blackblock whiteaction_v6 >/dev/null 2>&1; then
  nft add set inet blackblock whiteaction_v6 '{ type ipv6_addr; flags interval; comment "Danh sach IPv6 duoc Bypass"; }' >/dev/null 2>&1 || true
  nft insert rule inet blackblock blackblock-chain-input ip6 saddr @whiteaction_v6 accept >/dev/null 2>&1 || true
fi

# Nạp IP vào Set
if [[ "$target_ip" == *":"* ]]; then
  if ! nft add element inet blackblock whiteaction_v6 "{ $target_ip }" >/dev/null 2>&1; then
    err_flag=1
  fi
else
  if ! nft add element inet blackblock whiteaction_v4 "{ $target_ip }" >/dev/null 2>&1; then
    err_flag=1
  fi
fi

# Lưu cấu hình vĩnh viễn
if ((err_flag == 0)) && wptt_nft_save_persistent; then
  _rundone "$task_msg"
  wptt_logs "INFO" "Nftables: Đã Bypass IP $target_ip"
  
  if [[ -z "${1:-}" || "${1:-}" == "98" || "${1:-}" == "99" ]]; then
    echo -e "\n${C_GREEN}✔ Đã cấp 'Miễn tử kim bài' cho IP $target_ip và lưu cấu hình vĩnh viễn!${C_RESET}"
    wptt_quay_ve_menu "$route_flag" 0 "enter"
  fi
else
  _runloi "$task_msg"
  echo -e "\n${C_RED}❌ Lỗi: Không thể cập nhật cấu hình Nftables!${C_RESET}"
  wptt_quay_ve_menu "$route_flag" 1 "enter"
fi
