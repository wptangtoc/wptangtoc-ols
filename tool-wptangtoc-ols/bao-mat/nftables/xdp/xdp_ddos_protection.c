#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/in.h>
#include <linux/tcp.h>
#include <bpf/bpf_helpers.h>

#define THRESHOLD 50
#define TIME_WINDOW_NS 1000000000ULL
#define BAN_DURATION_NS (30 * 60 * 1000000000ULL)

struct rate_limit_entry {
    __u64 last_update;
    __u32 packet_count;
};

// Map 1: Whitelist
struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 256);
    __type(key, __u32);
    __type(value, __u8);
} whitelist_map SEC(".maps");

// Map 2: Log blacklist
struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 65535);
    __type(key, __u32);
    __type(value, __u64);
} log_blacklist SEC(".maps");

// Map 3: Rate limit counters
struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 65535);
    __type(key, __u32);
    __type(value, struct rate_limit_entry);
} rl_counters SEC(".maps");

// Map 4: Rate limit blacklist
struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 65535);
    __type(key, __u32);
    __type(value, __u64);
} rl_blacklist SEC(".maps");

SEC("xdp")
int ddos_and_log_protection(struct xdp_md *ctx) {
    void *data_end = (void *)(long)ctx->data_end;
    void *data = (void *)(long)ctx->data;
    struct ethhdr *eth = data;
    struct iphdr *iph;
    struct tcphdr *tcph;

    // Kiểm tra và bỏ qua các gói không phải IP
    if ((void *)(eth + 1) > data_end || eth->h_proto != __constant_htons(ETH_P_IP))
        return XDP_PASS;

    iph = (void *)(eth + 1);
    if ((void *)(iph + 1) > data_end)
        return XDP_PASS;

    __u32 src_ip = iph->saddr;

    // BƯỚC 1: KIỂM TRA WHITELIST TRƯỚC TIÊN
    if (bpf_map_lookup_elem(&whitelist_map, &src_ip)) {
        return XDP_PASS;
    }
    
    // BƯỚC 2: Kiểm tra các gói tin đã thuộc về một kết nối TCP đã thiết lập
    // Logic này tương tự với "ct state established" của nftables
    if (iph->protocol == IPPROTO_TCP) {
        tcph = (void *)iph + iph->ihl * 4;
        if ((void *)(tcph + 1) <= data_end) {
            // Kiểm tra cờ ACK để xác định gói tin đã thuộc về một kết nối thiết lập.
            // Đồng thời bỏ qua các gói SYN-ACK để cho phép thiết lập kết nối mới.
            if (tcph->ack && !(tcph->syn)) {
                return XDP_PASS;
            }
        }
    }

    // BƯỚC 3: Kiểm tra danh sách đen từ LOG
    __u64 current_time = bpf_ktime_get_ns();
    __u64 *log_ban_ts = bpf_map_lookup_elem(&log_blacklist, &src_ip);
    if (log_ban_ts) {
        if (current_time < *log_ban_ts) return XDP_DROP;
        else bpf_map_delete_elem(&log_blacklist, &src_ip);
    }

    // BƯỚC 4: Kiểm tra danh sách đen do RATE-LIMIT
    __u64 *rate_ban_ts = bpf_map_lookup_elem(&rl_blacklist, &src_ip);
    if (rate_ban_ts) {
        if (current_time < *rate_ban_ts) return XDP_DROP;
        else bpf_map_delete_elem(&rl_blacklist, &src_ip);
    }

    // BƯỚC 5: Logic giới hạn tốc độ gói tin
    // Chỉ thực hiện trên các gói tin không phải là một phần của kết nối đã thiết lập.
    struct rate_limit_entry *entry = bpf_map_lookup_elem(&rl_counters, &src_ip);
    if (entry) {
        if (current_time - entry->last_update < TIME_WINDOW_NS) {
            __sync_fetch_and_add(&entry->packet_count, 1);
            if (entry->packet_count > THRESHOLD) {
                __u64 ban_until = current_time + BAN_DURATION_NS;
                bpf_map_update_elem(&rl_blacklist, &src_ip, &ban_until, BPF_ANY);
                bpf_map_delete_elem(&rl_counters, &src_ip);
                return XDP_DROP;
            }
        } else {
            entry->last_update = current_time;
            entry->packet_count = 1;
        }
    } else {
        struct rate_limit_entry new_entry = {};
        new_entry.last_update = current_time;
        new_entry.packet_count = 1;
        bpf_map_update_elem(&rl_counters, &src_ip, &new_entry, BPF_ANY);
    }

    return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
