package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"os/exec"
	"regexp"
	"strings"
	"time"
)

// Cấu trúc Nftables chuẩn của WPTangToc OLS
const (
	logFile       = "/usr/local/lsws/logs/error.log"
	nftTableName  = "blackblock"
	nftSetV4      = "blackaction_v4"
	nftSetV6      = "blackaction_v6"
	blockDuration = "8h" // Thời gian khóa
)

// Bắt IP tấn công từ log OLS (ví dụ: [1.2.3.4] connection closed!)
var logRegex = regexp.MustCompile(`\[(?P<ip>[0-9a-fA-F:\.]+)\]\s.*(?:close connection|Drop connection|abort request)`)

// Whitelist động (Bypass IP từ WPTangToc sẽ được inject vào đây)
var whitelistIPs = []string{
	"127.0.0.1",
	"::1",
	// IP_VPS_HERE
}

func isWhitelisted(ip string) bool {
	for _, wIP := range whitelistIPs {
		if ip == wIP {
			return true
		}
	}
	return false
}

func blockIP(ipAddress string) {
	// Làm sạch IP (Bỏ port nếu có dính vào)
	ip := strings.Split(ipAddress, ":")[0]

	// Kiểm tra IPv6 (có dấu : nhưng không phải port)
	isIPv6 := strings.Contains(ipAddress, ":") && strings.Count(ipAddress, ":") > 1
	if isIPv6 {
		ip = ipAddress // IPv6 giữ nguyên
	}

	if isWhitelisted(ip) {
		// Bỏ qua IP tĩnh trong Whitelist cứng
		return
	}

	// Chặn bằng Nftables Set O(1)
	element := fmt.Sprintf("{ %s timeout %s }", ip, blockDuration)
	family := "inet" // Bảng blackblock dùng type inet
	setName := nftSetV4

	if isIPv6 {
		setName = nftSetV6
	}

	cmd := exec.Command("nft", "add", "element", family, nftTableName, setName, element)
	
	output, err := cmd.CombinedOutput()
	if err != nil {
		if !strings.Contains(string(output), "File exists") {
			log.Printf("[!] Lỗi chặn IP %s: %v", ip, string(output))
		}
		return
	}
	log.Printf("[+] DDoS Blocker: Đã khóa họng IP %s", ip)
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
	// Đợi file log xuất hiện nếu OpenLiteSpeed chưa tạo
	for {
		if _, err := os.Stat(logFile); err == nil {
			break
		}
		time.Sleep(5 * time.Second)
	}

	log.Printf("[*] WPTangToc Anti-DDoS Go đang theo dõi: %s", logFile)

	cmd := exec.Command("tail", "-F", "-n", "0", logFile)
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		log.Fatalf("Lỗi tạo pipe: %v", err)
	}

	if err := cmd.Start(); err != nil {
		log.Fatalf("Lỗi chạy tail: %v", err)
	}

	scanner := bufio.NewScanner(stdout)
	for scanner.Scan() {
		processLine(scanner.Text())
	}

	cmd.Wait()
}
