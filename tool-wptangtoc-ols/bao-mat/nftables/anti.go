package main

import (
	"bufio"
	"log"
	"net"
	"os"
	"os/exec"
	"regexp"
	"strings"
	"time"

	"github.com/google/nftables"
)

const (
	logFile       = "/usr/local/lsws/logs/error.log"
	nftTableName  = "blackblock"
	nftSetV4      = "blackaction_v4"
	nftSetV6      = "blackaction_v6"
	blockDuration = 8 * time.Hour
)

// Regex bắt IP từ Log OpenLiteSpeed
var logRegex = regexp.MustCompile(`\[(?P<ip>[0-9a-fA-F:\.]+)\]\s.*(?:close connection|Drop connection|abort request)`)

// Danh sách Miễn trừ (Bypass)
var whitelistIPs = map[string]bool{
	"127.0.0.1": true,
	"::1":       true,
	// IP_VPS_HERE
}

// Hàm tịnh tiến IP (Cần thiết cho Netlink API khi nạp vào Interval Set)
func incIP(ip net.IP) net.IP {
	inc := make(net.IP, len(ip))
	copy(inc, ip)
	for j := len(inc) - 1; j >= 0; j-- {
		inc[j]++
		if inc[j] > 0 {
			break
		}
	}
	return inc
}

func main() {
	// 1. Chờ OLS khởi tạo file log
	for {
		if _, err := os.Stat(logFile); err == nil {
			break
		}
		time.Sleep(5 * time.Second)
	}

	log.Printf("[*] WPTangToc Anti-DDoS (Netlink API) đang bảo vệ hệ thống...")

	// 2. Mở kết nối Netlink duy nhất tới Kernel (ZERO-FORK)
	conn := &nftables.Conn{}
	table := &nftables.Table{Name: nftTableName, Family: nftables.TableFamilyINet}
	setV4 := &nftables.Set{Table: table, Name: nftSetV4}
	setV6 := &nftables.Set{Table: table, Name: nftSetV6}

	// 3. Khởi tạo Channel hàng đợi IP (Xử lý hàng vạn IP cùng lúc không nghẽn)
	ipChan := make(chan string, 100000)

	// Worker Goroutine: Chuyên giao tiếp với Kernel
	go func() {
		for ipStr := range ipChan {
			ip := net.ParseIP(ipStr)
			if ip == nil {
				continue
			}

			var elements []nftables.SetElement
			var targetSet *nftables.Set

			if ip.To4() != nil {
				// Cấu trúc Interval Element [IP, IP+1)
				elements = []nftables.SetElement{{
					Key:     ip.To4(),
					KeyEnd:  incIP(ip.To4()),
					Timeout: blockDuration,
				}}
				targetSet = setV4
			} else {
				elements = []nftables.SetElement{{
					Key:     ip.To16(),
					KeyEnd:  incIP(ip.To16()),
					Timeout: blockDuration,
				}}
				targetSet = setV6
			}

			// Bơm IP vào RAM
			if err := conn.SetAddElements(targetSet, elements); err != nil {
				log.Printf("[!] Lỗi chuẩn bị IP %s: %v", ipStr, err)
				continue
			}

			// Thực thi Atomic Syscall
			if err := conn.Flush(); err != nil {
				// Kernel báo 'file exists' nghĩa là IP đã bị chặn trước đó -> Bỏ qua im lặng
				if !strings.Contains(err.Error(), "file exists") && !strings.Contains(err.Error(), "exist") {
					log.Printf("[!] Lỗi Syscall chặn IP %s: %v", ipStr, err)
				}
			} else {
				log.Printf("[+] DDoS Blocker (Netlink): Khóa mõm IP %s", ipStr)
			}
		}
	}()

	// 4. Tiến trình đọc Log siêu tốc
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
		matches := logRegex.FindStringSubmatch(scanner.Text())
		if matches != nil {
			ipStr := matches[logRegex.SubexpIndex("ip")]
			
			// Làm sạch (Bỏ Port nếu dính vào IPv4)
			if !strings.Contains(ipStr, ":") {
				ipStr = strings.Split(ipStr, ":")[0]
			} else if strings.Count(ipStr, ":") > 1 {
				// Khôi phục lại nếu là IPv6 chuẩn
				ipStr = matches[logRegex.SubexpIndex("ip")]
			}

			if !whitelistIPs[ipStr] {
				// Tống IP vào hàng đợi
				ipChan <- ipStr
			}
		}
	}

	cmd.Wait()
}
