package main

import (
	"bufio"
	"encoding/binary"
	"fmt"
	"log"
	"net"
	"os"
	"os/exec"
	"regexp"
	"strings"
	"time"

	"github.com/cilium/ebpf"
)

// Cấu hình
const (
	logFile       = "/usr/local/lsws/logs/error.log"
	blockDuration = 8 * time.Hour
	// Đường dẫn đến BPF map đã được "pin" trên hệ thống.
	// Chúng ta sẽ tạo ra nó ở bước hướng dẫn chạy.
	bpfMapPinPath = "/sys/fs/bpf/blacklist_map"
)

var logRegex = regexp.MustCompile(`\[(?P<ip>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\]\s.*close connection!`)

var whitelistIPs = []string{
	"103.106.105.75",
}

// Biến toàn cục để giữ tham chiếu đến BPF map
var bpfMap *ebpf.Map

// Hàm blockIP được viết lại hoàn toàn để cập nhật BPF map
func blockIP(ipAddress string) {
	ipStr := strings.Split(ipAddress, ":")[0]

	for _, whitelistedIP := range whitelistIPs {
		if ipStr == whitelistedIP {
			log.Printf("[*] Bỏ qua IP trong whitelist: %s", ipStr)
			return
		}
	}

	// Chuyển đổi địa chỉ IP dạng chuỗi sang dạng số nguyên
	parsedIP := net.ParseIP(ipStr)
	if parsedIP == nil || parsedIP.To4() == nil {
		log.Printf("[*] Bỏ qua địa chỉ không phải IPv4: %s", ipStr)
		return
	}

	// Key của BPF map là số nguyên 32-bit, Big Endian (Network Byte Order)
	var ipKey uint32 = binary.BigEndian.Uint32(parsedIP.To4())
	
	// Value là thời điểm hết hạn chặn (timestamp nano giây)
	banUntil := time.Now().Add(blockDuration).UnixNano()
	var banUntilVal uint64 = uint64(banUntil)

	// Cập nhật (hoặc thêm mới) phần tử vào BPF map
	err := bpfMap.Put(ipKey, banUntilVal)
	if err != nil {
		log.Printf("[!] Lỗi khi cập nhật BPF map cho IP %s: %v", ipStr, err)
		return
	}

	log.Printf("[+] Đã thêm/cập nhật IP vào danh sách chặn XDP: %s", ipStr)
}

func processLine(line string) {
	matches := logRegex.FindStringSubmatch(line)
	if matches == nil {
		return
	}
	
	ipIndex := logRegex.SubexpIndex("ip")
	if ipIndex != -1 {
		ip := matches[ipIndex]
		go blockIP(ip)
	}
}

func main() {
	var err error
	// Tải BPF map đã được pin từ hệ thống file
	bpfMap, err = ebpf.LoadPinnedMap(bpfMapPinPath, nil)
	if err != nil {
		log.Fatalf("[!] Lỗi: Không thể tải BPF map tại '%s'. Hãy chắc chắn bạn đã chạy các lệnh ở Bước 2. Lỗi: %v", bpfMapPinPath, err)
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
