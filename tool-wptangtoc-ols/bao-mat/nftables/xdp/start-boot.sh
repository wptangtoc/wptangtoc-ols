#!/bin/bash
if [[ $(bpftool map list) = '' ]]; then
  sudo bpftool net detach xdp dev eth0 || true
  sudo rm -f /sys/fs/bpf/xdp_ddos_protection_prog
  sudo rm -f /sys/fs/bpf/log_blacklist

  # Bước 3: Chỉ TẢI chương trình và các map của nó vào kernel
  # Ở bước này, map chưa được pin.
  sudo bpftool prog load xdp_ddos_protection.o /sys/fs/bpf/xdp_ddos_protection_prog

  # Bước 4: Tìm ID của map và PIN nó ra file
  # Đây là bước quan trọng để script Go có thể thấy map.
  MAP_ID=$(sudo bpftool map list | grep log_blacklist | awk '{print $1}' | sed 's/://')
  sudo bpftool map pin id $MAP_ID /sys/fs/bpf/log_blacklist
  sudo bpftool net attach xdp pinned /sys/fs/bpf/xdp_ddos_protection_prog dev eth0
fi
