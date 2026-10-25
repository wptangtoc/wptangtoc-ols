#!/bin/bash
# @author: Gia Tuấn
# @website: https://wptangtoc.com
# @since: 2026
# @description: Mở khóa toàn bộ IP trên tất cả các lớp khiên Nftables (blackaction + ddos + synflood/httpflood)

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
      /etc/wptt/tmp/nft_unbanall_*|/tmp/nft_unbanall_*)
        /bin/rm -f -- "${tmp_nft:?}"
        ;;
    esac
  fi
  exit "$rc"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM HUP

# 1. Kiểm tra dịch vụ và bảng blackblock
if ! command -v nft >/dev/null 2>&1 || ! nft list table inet blackblock >/dev/null 2>&1; then
  echo "Lỗi: Bảng Nftables 'inet blackblock' chưa được kích hoạt." >&2
  exit 1
fi

# 2. Xả sạch toàn bộ 8 Set trên cả 4 lớp khiên (Chặn tay + Anti-DDoS Go + Phạt SYN/HTTP Flood + Bộ đếm Rate-limit)
target_sets=(
  "blackaction_v4"
  "blackaction_v6"
  "ddos_v4"
  "ddos_v6"
  "denylist_v4"
  "denylist_v6"
  "httpdlist_v4"
  "httpdlist_v6"
)

for set_name in "${target_sets[@]}"; do
  if nft list set inet blackblock "$set_name" >/dev/null 2>&1; then
    nft flush set inet blackblock "$set_name" >/dev/null 2>&1 || true
  fi
done

# 3. Reset bộ đếm gói tin (Counter) trên chuỗi blackblock-chain-input và synflood_chain (nếu có)
nft reset rules table inet blackblock >/dev/null 2>&1 || true

# 4. Làm mới bộ nhớ đệm Dedup Cache (seenIPs) trong RAM của daemon Golang (nếu đang chạy)
if systemctl is-active --quiet wptt-anti-ddos.service 2>/dev/null; then
  systemctl restart wptt-anti-ddos.service >/dev/null 2>&1 || true
fi

# 5. Lưu vĩnh viễn trạng thái sạch xuống /etc/nftables.conf nguyên tử (Atomic Save)
/bin/mkdir -p /etc/wptt/tmp 2>/dev/null
chmod 700 /etc/wptt/tmp 2>/dev/null
tmp_nft="$(mktemp -p /etc/wptt/tmp nft_unbanall_XXXXXX.conf 2>/dev/null || mktemp /tmp/nft_unbanall_XXXXXX.conf)"
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
  echo "Thành công: Đã mở khóa toàn bộ IP trên tất cả các lớp khiên và lưu cấu hình vĩnh viễn."
  exit 0
else
  /bin/rm -f -- "${tmp_nft:?}"
  tmp_nft=""
  echo "Lỗi: Lưu cấu hình thất bại do sai cú pháp." >&2
  exit 1
fi
