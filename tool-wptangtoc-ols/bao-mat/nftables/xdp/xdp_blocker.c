#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <bpf/bpf_helpers.h>

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 65535);
    __type(key, __u32);
    __type(value, __u64); 
} blacklist_map SEC(".maps");

SEC("xdp_blocker")
int block_ip(struct xdp_md *ctx) {
    void *data_end = (void *)(long)ctx->data_end;
    void *data = (void *)(long)ctx->data;
    struct ethhdr *eth = data;
    struct iphdr *iph;

    if ((void *)(eth + 1) > data_end || eth->h_proto != __constant_htons(ETH_P_IP)) {
        return XDP_PASS;
    }

    iph = (void *)(eth + 1);
    if ((void *)(iph + 1) > data_end) {
        return XDP_PASS;
    }
    
    __u32 src_ip = iph->saddr;

    __u64 *ban_until_ts = bpf_map_lookup_elem(&blacklist_map, &src_ip);
    
    if (ban_until_ts) {
        __u64 current_time = bpf_ktime_get_ns();
        
        // Nếu thời gian chặn vẫn còn hiệu lực -> HỦY GÓI TIN
        if (current_time < *ban_until_ts) {
            return XDP_DROP;
        } else {
            // *** PHẦN THAY ĐỔI ***
            // ĐÃ HẾT HẠN: Tự động xóa IP khỏi danh sách đen và cho phép gói tin đi qua
            bpf_map_delete_elem(&blacklist_map, &src_ip);
            return XDP_PASS;
        }
    }
    
    return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
