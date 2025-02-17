#!/bin/bash

modprobe nf_synproxy_core
echo 0 > /proc/sys/net/netfilter/nf_conntrack_tcp_loose
echo 1 > /proc/sys/net/ipv4/tcp_syncookies
echo 1 > /proc/sys/net/ipv4/tcp_timestamps
echo 1000000 > /sys/module/nf_conntrack/parameters/hashsize
/sbin/sysctl -w net/netfilter/nf_conntrack_max=2000000

# set service synproxy interface ethX <input|forward>
# set service synproxy rule 10 destination port 443
# set service synproxy rule 10 tcp-mss 1460
# set service synproxy rule 10 window-scale 7
