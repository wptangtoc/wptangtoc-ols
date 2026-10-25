#!/bin/bash
# @author: Gia Tuấn
# @website: https://wptangtoc.com
# @since: 2026
# @description: Mở khóa IP thủ công đa tầng bằng Nftables (blackaction + ddos + synflood/httpflood)

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
umask 077

tmp_nft=""
cleanup() {
  local rc=$?
  trap - EXIT INT TERM HUP
  if [[ -n "${tmp_nft:-}" && -f "$tmp_nft" ]]; then
    case "$tmp_nft" in
      /etc/wptt/tmp/nft_unban_*|/tmp/nft_unban_*)
        /bin/rm -f -- "${tmp_nft:?}"
        ;;
    esac
  fi
  exit "$rc"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM HUP

# ==============================================================================
# HÀM KIỂM TRA IP / CIDR HỢP LỆ BẰNG PURE BASH (IPV4 & IPV6 & CIDR)
# ==============================================================================
wptt_validate_ip() {
  local raw_input="$1"
  local addr="${raw_input%%/*}"
  local cidr="${raw_input#*/}"
  [[ "$cidr" == "$raw_input" ]] && cidr=""

  if [[ -n "$cidr" && ! "$cidr" =~ ^[0-9]{1,3}$ ]]; then
    return 1
  fi

  if [[ "$addr" =~ ^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$ ]]; then
    if ((10#${BASH_REMATCH[1]} <= 255 && 10#${BASH_REMATCH[2]} <= 255 && 10#${BASH_REMATCH[3]} <= 255 && 10#${BASH_REMATCH[4]} <= 255)); then
      if [[ -n "$cidr" ]] && ((10#$cidr < 8 || 10#$cidr > 32)); then
        return 1
      fi
      return 0
    fi
  elif [[ "$addr" == *":"* && "$addr" != *":::"* && ! "$addr" =~ ^:[0-9a-fA-F] && ! "$addr" =~ [0-9a-fA-F]:$ && "${addr/::/@}" != *"::"* ]]; then
    local IFS=':'
    local -a hextets=()
    read -r -a hextets <<< "$addr"
    if ((${#hextets[@]} <= 8)); then
      local valid_v6=1
      local h=""
      for h in "${hextets[@]}"; do
        [[ -z "$h" ]] && continue
        if [[ ! "$h" =~ ^[0-9a-fA-F]{1,4}$ && ! "$h" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
          valid_v6=0
          break
        fi
      done
      if ((valid_v6 == 1)); then
        if [[ -n "$cidr" ]] && ((10#$cidr < 16 || 10#$cidr > 128)); then
          return 1
        fi
        return 0
      fi
    fi
  fi
  return 1
}

target_ip="${1:-}"
target_ip="${target_ip//[[:space:]]/}"

# 1. Kiểm tra đầu vào & dịch vụ Nftables
if [[ -z "$target_ip" ]]; then
  echo "Lỗi: Vui lòng cung cấp một địa chỉ IP hoặc dải CIDR." >&2
  exit 1
fi

if ! wptt_validate_ip "$target_ip"; then
  echo "Lỗi: Địa chỉ IP '$target_ip' không hợp lệ." >&2
  exit 1
fi

if ! command -v nft >/dev/null 2>&1 || ! nft list table inet blackblock >/dev/null 2>&1; then
  echo "Lỗi: Bảng Nftables 'inet blackblock' chưa được kích hoạt." >&2
  exit 1
fi

# 2. Tách địa chỉ Host IP và Prefix CIDR
# Các Set Bảng băm (ddos_v4/v6, denylist_v4/v6, httpdlist_v4/v6) chỉ nhận IP đơn (không nhận hậu tố /32 hay /128)
addr_only="${target_ip%%/*}"
prefix_only="${target_ip#*/}"
[[ "$prefix_only" == "$target_ip" ]] && prefix_only=""

is_single_host=0
if [[ "$target_ip" == *":"* ]]; then
  if [[ -z "$prefix_only" ]] || ((10#$prefix_only == 128)); then
    is_single_host=1
    elem_interval="$addr_only"
  else
    elem_interval="${addr_only}/$((10#$prefix_only))"
  fi
else
  if [[ -z "$prefix_only" ]] || ((10#$prefix_only == 32)); then
    is_single_host=1
    elem_interval="$addr_only"
  else
    elem_interval="${addr_only}/$((10#$prefix_only))"
  fi
fi

# 3. Thực hiện gỡ chặn trên tất cả các lớp khiên trong bảng blackblock
declare -a cleared_layers=()

if [[ "$target_ip" == *":"* ]]; then
  # Lớp 1: Chặn thủ công vĩnh viễn (blackaction_v6 - hỗ trợ cả IP lẻ và CIDR)
  if nft list set inet blackblock blackaction_v6 >/dev/null 2>&1; then
    if nft delete element inet blackblock blackaction_v6 "{ $elem_interval }" >/dev/null 2>&1; then
      cleared_layers+=("blackaction_v6")
    fi
  fi

  # Lớp 2 & 3: Anti-DDoS Golang (ddos_v6) và Khiên SYN/HTTP Flood (denylist_v6 + httpdlist_v6)
  if ((is_single_host == 1)); then
    if nft list set inet blackblock ddos_v6 >/dev/null 2>&1; then
      if nft delete element inet blackblock ddos_v6 "{ $addr_only }" >/dev/null 2>&1; then
        cleared_layers+=("ddos_v6")
      fi
    fi

    if nft list set inet blackblock denylist_v6 >/dev/null 2>&1; then
      if nft delete element inet blackblock denylist_v6 "{ $addr_only }" >/dev/null 2>&1; then
        cleared_layers+=("denylist_v6")
      fi
    fi

    # Xóa luôn bộ đếm tốc độ trong httpdlist_v6 để IP không bị khóa lại ngay lập tức
    if nft list set inet blackblock httpdlist_v6 >/dev/null 2>&1; then
      if nft delete element inet blackblock httpdlist_v6 "{ $addr_only }" >/dev/null 2>&1; then
        cleared_layers+=("httpdlist_v6")
      fi
    fi
  fi
else
  # Lớp 1: Chặn thủ công vĩnh viễn (blackaction_v4 - hỗ trợ cả IP lẻ và CIDR)
  if nft list set inet blackblock blackaction_v4 >/dev/null 2>&1; then
    if nft delete element inet blackblock blackaction_v4 "{ $elem_interval }" >/dev/null 2>&1; then
      cleared_layers+=("blackaction_v4")
    fi
  fi

  # Lớp 2 & 3: Anti-DDoS Golang (ddos_v4) và Khiên SYN/HTTP Flood (denylist_v4 + httpdlist_v4)
  if ((is_single_host == 1)); then
    if nft list set inet blackblock ddos_v4 >/dev/null 2>&1; then
      if nft delete element inet blackblock ddos_v4 "{ $addr_only }" >/dev/null 2>&1; then
        cleared_layers+=("ddos_v4")
      fi
    fi

    if nft list set inet blackblock denylist_v4 >/dev/null 2>&1; then
      if nft delete element inet blackblock denylist_v4 "{ $addr_only }" >/dev/null 2>&1; then
        cleared_layers+=("denylist_v4")
      fi
    fi

    # Xóa luôn bộ đếm tốc độ trong httpdlist_v4 để IP không bị khóa lại ngay lập tức
    if nft list set inet blackblock httpdlist_v4 >/dev/null 2>&1; then
      if nft delete element inet blackblock httpdlist_v4 "{ $addr_only }" >/dev/null 2>&1; then
        cleared_layers+=("httpdlist_v4")
      fi
    fi
  fi
fi

if ((${#cleared_layers[@]} == 0)); then
  echo "Lỗi: Không tìm thấy IP '$target_ip' trong bất kỳ danh sách chặn nào (blackaction, ddos, denylist)." >&2
  exit 1
fi

# 4. Lưu vĩnh viễn cấu hình nguyên tử (Atomic Save)
/bin/mkdir -p /etc/wptt/tmp 2>/dev/null
chmod 700 /etc/wptt/tmp 2>/dev/null
tmp_nft="$(mktemp -p /etc/wptt/tmp nft_unban_XXXXXX.conf 2>/dev/null || mktemp /tmp/nft_unban_XXXXXX.conf)"
if [[ -z "$tmp_nft" ]]; then
  echo "Lỗi: Không thể tạo file tạm để lưu cấu hình." >&2
  exit 1
fi

{
  printf '#!/usr/sbin/nft -f\n\nflush ruleset\n\n'
  nft list table inet blackblock 2>/dev/null || true
  printf '\n'
  nft list table inet filter 2>/dev/null || true
} > "$tmp_nft"

if nft -c -f "$tmp_nft" >/dev/null 2>&1; then
  chmod 600 "$tmp_nft"
  /bin/mv -fT -- "$tmp_nft" /etc/nftables.conf
  tmp_nft=""
  [[ -d /etc/sysconfig ]] && ln -sfn /etc/nftables.conf /etc/sysconfig/nftables.conf
  layers_str="${cleared_layers[*]}"
  echo "Thành công: Đã gỡ chặn IP $target_ip khỏi [${layers_str// /, }] và lưu cấu hình."
  exit 0
else
  /bin/rm -f -- "${tmp_nft:?}"
  tmp_nft=""
  echo "Lỗi: Lưu cấu hình thất bại do sai cú pháp." >&2
  exit 1
fi
