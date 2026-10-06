#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <arpa/inet.h>
#include <bpf/bpf.h>
#include <time.h>
#include <unistd.h>
#include <regex.h>

// --- CẤU HÌNH ---
const char *map_pin_path = "/sys/fs/bpf/log_blacklist";
const unsigned long long ban_duration_ns = 4ULL * 3600ULL * 1000000000ULL; // 4 giờ
// Sửa lại thành 1 phút
/* const unsigned long long ban_duration_ns = 60ULL * 1000000000ULL; // 1 phút */
// --- CÁC HÀM TIỆN ÍCH ---

unsigned long long get_monotonic_time_ns() {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (unsigned long long)ts.tv_sec * 1000000000ULL + ts.tv_nsec;
}

void block_ip(int map_fd, const char *ip_str) {
    unsigned int ip_key;
    unsigned long long ban_until_val;
    struct in_addr addr;

    if (inet_pton(AF_INET, ip_str, &addr) != 1) return;
    
    ip_key = ntohl(addr.s_addr);
    ban_until_val = get_monotonic_time_ns() + ban_duration_ns;

    if (bpf_map_update_elem(map_fd, &ip_key, &ban_until_val, BPF_ANY) == 0) {
        // Ghi ra stderr để log của systemd có thể thấy
        fprintf(stderr, "[+] Đã thêm/cập nhật IP %s vào danh sách đen.\n", ip_str);
    }
}

void process_line(int map_fd, regex_t *regex, const char *line) {
    regmatch_t pmatch[2];
    if (regexec(regex, line, 2, pmatch, 0) == 0) {
        char ip_buffer[16];
        int start = pmatch[1].rm_so;
        int end = pmatch[1].rm_eo;
        snprintf(ip_buffer, end - start + 1, "%s", line + start);
        block_ip(map_fd, ip_buffer);
    }
}

// --- HÀM CHÍNH ĐÃ THAY ĐỔI ---
int main(void) {
    int map_fd;
    char *line = NULL;
    size_t len = 0;
    regex_t regex;

    // Mở BPF map
    map_fd = bpf_obj_get(map_pin_path);
    if (map_fd < 0) {
        fprintf(stderr, "Lỗi: Không thể mở BPF map: %s\n", strerror(errno));
        return 1;
    }

    // Biên dịch Regex
    if (regcomp(&regex, "\\[((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))\\]", REG_EXTENDED) != 0) {
        fprintf(stderr, "Lỗi: Không thể biên dịch regex\n");
        close(map_fd);
        return 1;
    }

    // Vòng lặp chính: ĐỌC TỪ STANDARD INPUT (stdin)
    fprintf(stderr, "Chuong trinh san sang, dang cho du lieu tu stdin...\n");
    while (getline(&line, &len, stdin) != -1) {
        process_line(map_fd, &regex, line);
    }

    // Dọn dẹp
    if (line) free(line);
    regfree(&regex);
    close(map_fd);

    return 0;
}
