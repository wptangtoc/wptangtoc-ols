#!/bin/bash
# @description: Chặn IP thủ công bằng Nftables (Bản Enterprise)

export LANG=en_US.UTF-8

# Hàm kiểm tra IP hợp lệ bằng Pure Bash (IPv4 & IPv6 & CIDR)
wptt_validate_ip() {
  local raw_input="$1"
  local addr="${raw_input%%/*}"
  local cidr="${raw_input#*/}"
  [[ "$cidr" == "$raw_input" ]] && cidr=""

  if [[ -n "$cidr" && ! "$cidr" =~ ^[0-9]{1,3}$ ]]; then return 1; fi

  if [[ "$addr" =~ ^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$ ]]; then
    if ((10#${BASH_REMATCH[1]} <= 255 && 10#${BASH_REMATCH[2]} <= 255 && 10#${BASH_REMATCH[3]} <= 255 && 10#${BASH_REMATCH[4]} <= 255)); then
      if [[ -n "$cidr" ]] && ((10#$cidr < 8 || 10#$cidr > 32)); then return 1; fi
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
        return 0
      fi
    fi
  fi
  return 1
}

target_ip="${1:-}"

# 1. Bẫy lỗi: Kiểm tra đầu vào
if [[ -z "$target_ip" ]]; then
  echo "Lỗi: Vui lòng cung cấp một địa chỉ IP." >&2
  exit 1
fi

if ! wptt_validate_ip "$target_ip"; then
  echo "Lỗi: Địa chỉ IP '$target_ip' không hợp lệ." >&2
  exit 1
fi

# 2. Xử lý logic Nftables
if [[ "$target_ip" == *":"* ]]; then
  if ! nft add element inet blackblock blackaction_v6 "{ $target_ip }" >/dev/null 2>&1; then
    echo "Lỗi: Không thể chặn IPv6 '$target_ip' trên Nftables." >&2
    exit 1
  fi
else
  if ! nft add element inet blackblock blackaction_v4 "{ $target_ip }" >/dev/null 2>&1; then
    echo "Lỗi: Không thể chặn IPv4 '$target_ip' trên Nftables." >&2
    exit 1
  fi
fi

# 3. Lưu vĩnh viễn cấu hình
/bin/mkdir -p /etc/wptt/tmp 2>/dev/null
tmp_nft="$(mktemp -p /etc/wptt/tmp nft_ban_XXXXXX.conf 2>/dev/null || mktemp /tmp/nft_ban_XXXXXX.conf)"
if [[ -z "$tmp_nft" ]]; then
  echo "Lỗi: Không thể tạo file tạm để lưu cấu hình." >&2
  exit 1
fi

{
  printf '#!/usr/sbin/nft -f\n\nflush ruleset\n\n'
  nft list table inet blackblock 2>/dev/null
  printf '\n'
  nft list table inet filter 2>/dev/null
} > "$tmp_nft"

if nft -c -f "$tmp_nft" >/dev/null 2>&1; then
  chmod 600 "$tmp_nft"
  /bin/mv -fT "$tmp_nft" /etc/nftables.conf
  [[ -d /etc/sysconfig ]] && ln -sfn /etc/nftables.conf /etc/sysconfig/nftables.conf
  echo "Thành công: Đã chặn và lưu vĩnh viễn IP $target_ip"
  exit 0
else
  /bin/rm -f -- "${tmp_nft:?}"
  echo "Lỗi: Lưu cấu hình thất bại do sai cú pháp." >&2
  exit 1
fi
