package main

import (
	"bufio"
	"encoding/binary"
	"log"
	"net"
	"os"
	"os/exec"
	"regexp"
	"strings"
	"time"
	"github.com/cilium/ebpf"
)

// ... (phần const và var giữ nguyên) ...
const (
	logFile       = "/usr/local/lsws/logs/error.log"
	blockDuration = 4 * time.Hour
	bpfMapPinPath = "/sys/fs/bpf/log_blacklist"
)

var (
	logRegex = regexp.MustCompile(`\[(?P<ip>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\]\s.*close connection!`)
	whitelistIPs = []string{
		"103.106.105.75",
	}
	bpfMap *ebpf.Map
)


func blockIP(ipAddress string) {
	ipStr := strings.Split(ipAddress, ":")[0]

	for _, whitelistedIP := range whitelistIPs {
		if ipStr == whitelistedIP {
			log.Printf("[*] Bỏ qua IP trong whitelist: %s", ipStr)
			return
		}
	}

	parsedIP := net.ParseIP(ipStr)
	if parsedIP == nil || parsedIP.To4() == nil {
		log.Printf("[*] Bỏ qua địa chỉ không phải IPv4: %s", ipStr)
		return
	}

	// === THAY ĐỔI CUỐI CÙNG Ở ĐÂY ===
	// Đổi về LittleEndian để khớp với cách XDP trên CPU x86 đọc IP
	var ipKey uint32 = binary.LittleEndian.Uint32(parsedIP.To4())
	
	banUntil := time.Now().Add(blockDuration).UnixNano()
	var banUntilVal uint64 = uint64(banUntil)

	err := bpfMap.Put(ipKey, banUntilVal)
	if err != nil {
		log.Printf("[!] Lỗi khi cập nhật BPF map cho IP %s: %v", ipStr, err)
		return
	}

	log.Printf("[+] Đã thêm/cập nhật IP vào danh sách chặn XDP: %s (chặn trong %v)", ipStr, blockDuration)
}

// ... (các hàm còn lại giữ nguyên, không cần thay đổi) ...
func processLine(line string) {
	matches := logRegex.FindStringSubmatch(line)
	if matches == nil { return }
	ipIndex := logRegex.SubexpIndex("ip")
	if ipIndex != -1 {
		ip := matches[ipIndex]
		go blockIP(ip)
	}
}

func main() {
	var err error
	bpfMap, err = ebpf.LoadPinnedMap(bpfMapPinPath, nil)
	if err != nil {
		log.Fatalf("[!] Lỗi: Không thể tải BPF map tại '%s'. Lỗi: %v", bpfMapPinPath, err)
	}
	defer bpfMap.Close()
	log.Printf("Đã tải thành công BPF map: %s", bpfMap.String())
	if _, err := os.Stat(logFile); os.IsNotExist(err) {
		log.Fatalf("[!] Lỗi: File log '%s' không tồn tại.", logFile)
	}
	log.Printf("Bắt đầu theo dõi file log: %s", logFile)
	cmd := exec.Command("tail", "-F", "-n", "0", logFile)
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		log.Fatalf("Lỗi khi tạo pipe: %v", err)
	}
	if err := cmd.Start(); err != nil {
		log.Fatalf("Lỗi khi bắt đầu lệnh tail: %v", err)
	}
	scanner := bufio.NewScanner(stdout)
	for scanner.Scan() {
		line := scanner.Text()
		processLine(line)
	}
	if err := cmd.Wait(); err != nil {
		log.Printf("Lệnh tail kết thúc với lỗi: %v", err)
	}
}
