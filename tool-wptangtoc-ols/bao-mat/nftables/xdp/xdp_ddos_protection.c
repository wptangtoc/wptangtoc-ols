#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/in.h>
#include <linux/tcp.h>
#include <bpf/bpf_helpers.h>

#define THRESHOLD 50
#define TIME_WINDOW_NS 1000000000ULL      // 1 giây
#define BAN_DURATION_NS (15 * 60 * 1000000000ULL) // 15 phút

struct rate_limit_entry {
    __u64 last_update;
    __u32 packet_count;
};

// Map 1: Vẫn dùng để theo dõi tốc độ gói tin
struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 10240);
    __type(key, __u32);
    __type(value, struct rate_limit_entry);
} rate_limit_map SEC(".maps");

// Map 2: Vẫn dùng để lưu các IP bị chặn
struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 10240);
    __type(key, __u32);
    __type(value, __u64);
} blacklist_map SEC(".maps");

SEC("xdp")
int ddos_protection(struct xdp_md *ctx) {
    void *data_end = (void *)(long)ctx->data_end;
    void *data = (void *)(long)ctx->data;
    struct ethhdr *eth = data;
    struct iphdr *iph;
    struct tcphdr *tcph;
    __u64 current_time;

    if ((void *)(eth + 1) > data_end)
        return XDP_PASS;
    
    if (eth->h_proto != __constant_htons(ETH_P_IP))
        return XDP_PASS;
    
    iph = (void *)(eth + 1);
    if ((void *)(iph + 1) > data_end)
        return XDP_PASS;
        
    __u32 src_ip = iph->saddr;
    current_time = bpf_ktime_get_ns();

    // BƯỚC 1: KIỂM TRA BLACKLIST
    __u64 *ban_until_ts = bpf_map_lookup_elem(&blacklist_map, &src_ip);
    if (ban_until_ts) {
        if (current_time < *ban_until_ts) {
            return XDP_DROP;
        } else {
            bpf_map_delete_elem(&blacklist_map, &src_ip);
        }
    }

    // CẢI TIẾN: MIỄN TRỪ CHO KẾT NỐI SSH ĐÃ THIẾT LẬP
    if (iph->protocol == IPPROTO_TCP) {
        tcph = (void *)iph + iph->ihl * 4;
        if ((void *)(tcph + 1) > data_end)
            return XDP_PASS;

        if (tcph->dest == __constant_htons(22) && tcph->ack) {
            return XDP_PASS;
        }
    }

    // BƯỚC 2: LOGIC GIỚI HẠN TỐC ĐỘ GÓI TIN
    struct rate_limit_entry *entry = bpf_map_lookup_elem(&rate_limit_map, &src_ip);
    if (entry) {
        if (current_time - entry->last_update < TIME_WINDOW_NS) {
            __sync_fetch_and_add(&entry->packet_count, 1);
            
            if (entry->packet_count > THRESHOLD) {
                __u64 ban_until = current_time + BAN_DURATION_NS;
                bpf_map_update_elem(&blacklist_map, &src_ip, &ban_until, BPF_ANY);
                bpf_map_delete_elem(&rate_limit_map, &src_ip);
                return XDP_DROP;
            }
        } else {
            entry->last_update = current_time;
            entry->packet_count = 1;
        }
    } else {
        // *** PHẦN ĐÃ SỬA LỖI ***
        struct rate_limit_entry new_entry = {}; // Khởi tạo tất cả các byte về 0
        new_entry.last_update = current_time;
        new_entry.packet_count = 1;
        bpf_map_update_elem(&rate_limit_map, &src_ip, &new_entry, BPF_ANY);
    }

    return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
