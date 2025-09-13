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
const unsigned long long ban_duration_ns = 4ULL * 3600ULL * 1000000000ULL;
const int rate_limit_threshold = 5;
const int rate_limit_window_sec = 1;

#define HASH_TABLE_SIZE 655360
struct ip_tracker {
    unsigned int ip;
    unsigned int count;
    time_t window_start_ts;
    struct ip_tracker *next;
};
static struct ip_tracker *ip_rate_table[HASH_TABLE_SIZE];

// --- CÁC HÀM TIỆN ÍCH ---

unsigned long long get_monotonic_time_ns() {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (unsigned long long)ts.tv_sec * 1000000000ULL + ts.tv_nsec;
}

void block_ip(int map_fd, unsigned int ip_key_bswapped, const char* ip_str) {
    unsigned long long ban_until_val = get_monotonic_time_ns() + ban_duration_ns;
    if (bpf_map_update_elem(map_fd, &ip_key_bswapped, &ban_until_val, BPF_ANY) == 0) {
        fprintf(stderr, "[!!!] IP %s đã vượt ngưỡng (%d reqs/sec). Đã chặn trong BPF map.\n", ip_str, rate_limit_threshold + 1);
    }
}

// --- HÀM is_static_file ĐÃ ĐƯỢC CẢI TIẾN ---
int is_static_file(const char *path) {
    char clean_path[2048];
    const char *query_start = strchr(path, '?');

    // Nếu có query string, chỉ sao chép phần đường dẫn trước dấu '?'
    if (query_start) {
        size_t path_len = query_start - path;
        if (path_len >= sizeof(clean_path)) {
            path_len = sizeof(clean_path) - 1;
        }
        strncpy(clean_path, path, path_len);
        clean_path[path_len] = '\0';
    } else {
        // Nếu không có, sao chép toàn bộ đường dẫn
        strncpy(clean_path, path, sizeof(clean_path) - 1);
        clean_path[sizeof(clean_path) - 1] = '\0';
    }

    const char *dot = strrchr(clean_path, '.');
    if (!dot) {
        return 0; // Không có phần mở rộng, coi là động
    }
    
    const char *static_exts[] = {
        ".css", ".js", ".jpg", ".jpeg", ".png", ".gif", ".webp", ".svg", ".ico", 
        ".woff", ".woff2", ".ttf", ".eot", ".otf", ".mp4", ".webm", ".txt", NULL
    };
    for (int i = 0; static_exts[i] != NULL; i++) {
        if (strcasecmp(dot, static_exts[i]) == 0) {
            return 1; // Là file tĩnh
        }
    }
    return 0; // Là file động
}

// --- process_line và các hàm khác không thay đổi ---
void process_line(int map_fd, regex_t *regex, const char *line) {
    regmatch_t pmatch[3];
    if (regexec(regex, line, 3, pmatch, 0) != 0) return;
    char ip_str[16];
    snprintf(ip_str, pmatch[1].rm_eo - pmatch[1].rm_so + 1, "%s", line + pmatch[1].rm_so);
    char path_str[2048];
    snprintf(path_str, pmatch[2].rm_eo - pmatch[2].rm_so + 1, "%s", line + pmatch[2].rm_so);
    if (is_static_file(path_str)) return;
    struct in_addr addr;
    if (inet_pton(AF_INET, ip_str, &addr) != 1) return;
    unsigned int ip_int = addr.s_addr;
    unsigned int hash_index = ip_int % HASH_TABLE_SIZE;
    time_t current_time = time(NULL);
    struct ip_tracker *entry = ip_rate_table[hash_index];
    while (entry) {
        if (entry->ip == ip_int) {
            if (current_time > entry->window_start_ts + rate_limit_window_sec) {
                entry->window_start_ts = current_time;
                entry->count = 1;
            } else { entry->count++; }
            if (entry->count > rate_limit_threshold) {
                unsigned int ip_key_bswapped = ntohl(ip_int);
                block_ip(map_fd, ip_key_bswapped, ip_str);
                entry->count = 0;
            }
            return;
        }
        entry = entry->next;
    }
    struct ip_tracker *new_entry = malloc(sizeof(struct ip_tracker));
    if (!new_entry) return;
    new_entry->ip = ip_int;
    new_entry->count = 1;
    new_entry->window_start_ts = current_time;
    new_entry->next = ip_rate_table[hash_index];
    ip_rate_table[hash_index] = new_entry;
}

int main(void) {
    int map_fd;
    char *line = NULL;
    size_t len = 0;
    regex_t regex;

    setvbuf(stdout, NULL, _IOLBF, 0);
    setvbuf(stderr, NULL, _IOLBF, 0);
    
    memset(ip_rate_table, 0, sizeof(ip_rate_table));

    map_fd = bpf_obj_get(map_pin_path);
    if (map_fd < 0) {
        fprintf(stderr, "Lỗi: Không thể mở BPF map: %s\n", strerror(errno));
        return 1;
    }
    
    const char *regex_pattern = "^\\[\"[^\"]+\"\\] ([0-9.]+) \\S+ \\S+ \\[[^]]+\\] \"[A-Z]+ (\\S+)[^\"]*\"";
    if (regcomp(&regex, regex_pattern, REG_EXTENDED | REG_ICASE) != 0) {
        fprintf(stderr, "Lỗi: Không thể biên dịch regex: %s\n", strerror(errno));
        close(map_fd);
        return 1;
    }
    
    fprintf(stderr, "Logger anti-access san sang, dang cho du lieu tu stdin...\n");

    while (getline(&line, &len, stdin) != -1) {
        process_line(map_fd, &regex, line);
    }
    
    fprintf(stderr, "Logger anti-access da ket thuc.\n");
    if (line) free(line);
    regfree(&regex);
    close(map_fd);

    return 0;
}
