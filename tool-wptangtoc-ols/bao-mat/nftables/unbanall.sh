#!/bin/bash
nft flush set inet blackblock blackaction_v4 >/dev/null 2>&1 || true
nft flush set inet blackblock blackaction_v6 >/dev/null 2>&1 || true

# Lưu vĩnh viễn xuống /etc/nftables.conf để sau khi reboot vẫn giữ nguyên danh sách IP bị chặn
tmp_nft="$(mktemp -p /etc/wptt/tmp nft_ban_XXXXXX.conf 2>/dev/null || mktemp /tmp/nft_ban_XXXXXX.conf)"
{
  printf '#!/usr/sbin/nft -f\n\nflush ruleset\n\n'
  nft list table inet blackblock 2>/dev/null
  printf '\n'
  nft list table inet filter 2>/dev/null
} > "$tmp_nft"

if nft -c -f "$tmp_nft" >/dev/null 2>&1; then
  chmod 600 "$tmp_nft"
  /bin/mv -fT "$tmp_nft" /etc/nftables.conf
else
  /bin/rm -f -- "${tmp_nft:?}"
fi

