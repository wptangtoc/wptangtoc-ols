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

var logRegex = regexp.MustCompile(`\[(?P<ip>[0-9a-fA-F:\.]+)\]\s.*(?:close connection|Drop connection|abort request)`)

var whitelistIPs = map[string]bool{
	"127.0.0.1": true,
	"::1":       true,
	// IP_VPS_HERE
}

func init() {
	addrs, err := net.InterfaceAddrs()
	if err == nil {
		for _, addr := range addrs {
			if ipnet, ok := addr.(*net.IPNet); ok {
				// Chuẩn hóa IP nội bộ ngay khi khởi động
				whitelistIPs[ipnet.IP.String()] = true
			}
		}
	}
}

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
	for {
		if _, err := os.Stat(logFile); err == nil {
			break
		}
		time.Sleep(5 * time.Second)
	}

	log.Printf("[*] WPTangToc Anti-DDoS (Netlink API) đang bảo vệ hệ thống...")

	conn := &nftables.Conn{}
	table := &nftables.Table{Name: nftTableName, Family: nftables.TableFamilyINet}
	setV4 := &nftables.Set{Table: table, Name: nftSetV4}
	setV6 := &nftables.Set{Table: table, Name: nftSetV6}

	ipChan := make(chan string, 100000)

	go func() {
		for ipStr := range ipChan {
			ip := net.ParseIP(ipStr)
			if ip == nil {
				continue
			}

			var elements []nftables.SetElement
			var targetSet *nftables.Set

			if ip.To4() != nil {
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

			if err := conn.SetAddElements(targetSet, elements); err != nil {
				log.Printf("[!] Lỗi chuẩn bị IP %s: %v", ipStr, err)
				continue
			}

			if err := conn.Flush(); err != nil {
				if !strings.Contains(err.Error(), "file exists") && !strings.Contains(err.Error(), "exist") {
					log.Printf("[!] Lỗi Syscall chặn IP %s: %v", ipStr, err)
				}
			} else {
				log.Printf("[+] DDoS Blocker (Netlink): Khóa họng IP %s", ipStr)
			}
		}
	}()

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
			
			// Bóc tách Port khỏi IPv4
			if strings.Count(ipStr, ":") == 1 {
				ipStr = strings.Split(ipStr, ":")[0]
			}
			
			// Parse để loại rác và chuẩn bị định dạng
			parsedIP := net.ParseIP(ipStr)
			if parsedIP == nil {
				continue
			}

			// CHUẨN HÓA TUYỆT ĐỐI (Ép mọi biến thể như 0:0...1 hay ::ffff:127.0.0.1 về chuẩn)
			normalizedIP := parsedIP.String()

			if !whitelistIPs[normalizedIP] {
				// Truyền chuỗi đã chuẩn hóa vào Worker
				ipChan <- normalizedIP
			}
		}
	}
	cmd.Wait()
}
