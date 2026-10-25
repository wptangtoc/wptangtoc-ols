package main

import (
	"bufio"
	"context"
	"fmt"
	"log"
	"net"
	"os"
	"os/exec"
	"os/signal"
	"strconv"
	"strings"
	"syscall"
	"time"

	"github.com/google/nftables"
)

const (
	logFile          = "/usr/local/lsws/logs/error.log"
	nftTableName     = "blackblock"
	nftSetV4         = "ddos_v4"
	nftSetV6         = "ddos_v6"
	blockDuration    = 8 * time.Hour
	blockDurationStr = "8h"
	dedupTTL         = 30 * time.Minute       // Thời gian nhớ IP trong RAM để không gọi Syscall lặp lại
	batchSize        = 100                    // Gom tối đa 100 IP mới mỗi lần Flush
	flushInterval    = 150 * time.Millisecond // Chu kỳ xả Batch xuống Kernel
	cleanupInterval  = 5 * time.Minute        // Chu kỳ dọn dẹp bộ nhớ đệm Dedup
	maxCacheSize     = 100000                 // Giới hạn cứng bộ nhớ đệm (~5MB RAM)
)

// Các từ khóa nhận diện kết nối bất thường từ OpenLiteSpeed error.log
var triggerKeywords = []string{
	"close connection",
	"Drop connection",
	"abort request",
	"Access denied",
	"over limit",
}

// Danh sách Miễn trừ (Bypass)
var whitelistIPs = map[string]bool{
	"127.0.0.1": true,
	"::1":       true,
	// IP_VPS_HERE
}

func init() {
	// Chuẩn hóa lại toàn bộ IP có sẵn trong whitelistIPs
	normalizedMap := make(map[string]bool, len(whitelistIPs)+16)
	for rawIP := range whitelistIPs {
		if ip := net.ParseIP(strings.TrimSpace(rawIP)); ip != nil {
			if ip4 := ip.To4(); ip4 != nil {
				normalizedMap[ip4.String()] = true
			} else {
				normalizedMap[ip.String()] = true
			}
		}
	}

	// Tự động quét và nạp toàn bộ IP của mọi Card mạng trên VPS vào Whitelist
	if addrs, err := net.InterfaceAddrs(); err == nil {
		for _, addr := range addrs {
			if ipnet, ok := addr.(*net.IPNet); ok && ipnet.IP != nil {
				if ip4 := ipnet.IP.To4(); ip4 != nil {
					normalizedMap[ip4.String()] = true
				} else {
					normalizedMap[ipnet.IP.String()] = true
				}
			}
		}
	}
	whitelistIPs = normalizedMap
}

func isAllOnesIP(ip net.IP) bool {
	for _, b := range ip {
		if b != 0xff {
			return false
		}
	}
	return len(ip) > 0
}

func hasTriggerKeyword(line string) bool {
	for _, kw := range triggerKeywords {
		if strings.Contains(line, kw) {
			return true
		}
	}
	return false
}

// Bóc tách IP từ cụm ngoặc vuông OLS: "1.2.3.4:54321#domain.com", "[2001:db8::1]:54321", "2001:db8::1:54321"
func parseOLSBracketToken(token string) net.IP {
	if hashIdx := strings.IndexByte(token, '#'); hashIdx != -1 {
		token = token[:hashIdx]
	}
	token = strings.TrimSpace(token)

	if !strings.ContainsAny(token, ".:") {
		return nil
	}

	if strings.HasPrefix(token, "[") {
		if host, _, err := net.SplitHostPort(token); err == nil {
			return net.ParseIP(strings.Trim(host, "[]"))
		}
		return net.ParseIP(strings.Trim(token, "[]"))
	}

	if strings.Count(token, ":") == 1 {
		colonIdx := strings.IndexByte(token, ':')
		return net.ParseIP(token[:colonIdx])
	}

	if ip := net.ParseIP(token); ip != nil {
		return ip
	}

	if lastColon := strings.LastIndexByte(token, ':'); lastColon != -1 {
		portPart := token[lastColon+1:]
		if portNum, err := strconv.Atoi(portPart); err == nil && portNum >= 1 && portNum <= 65535 {
			return net.ParseIP(token[:lastColon])
		}
	}

	return nil
}

// Quét toàn bộ các cụm [...] trên dòng log để tìm IP hợp lệ (Zero-Regex)
func extractIPFromOLSLog(line string) string {
	if !hasTriggerKeyword(line) {
		return ""
	}

	n := len(line)
	for i := 0; i < n; i++ {
		if line[i] != '[' {
			continue
		}

		start := i + 1
		end := -1
		depth := 1
		for j := start; j < n; j++ {
			if line[j] == '[' {
				depth++
			} else if line[j] == ']' {
				depth--
				if depth == 0 {
					end = j
					break
				}
			}
		}

		if end == -1 {
			break
		}

		ip := parseOLSBracketToken(line[start:end])
		if ip != nil {
			if ip.IsLoopback() || ip.IsUnspecified() || ip.IsMulticast() ||
				ip.IsLinkLocalUnicast() || ip.IsLinkLocalMulticast() ||
				ip.Equal(net.IPv4bcast) {
				return ""
			}

			if ip4 := ip.To4(); ip4 != nil {
				if isAllOnesIP(ip4) {
					return ""
				}
				return ip4.String()
			}
			if ip16 := ip.To16(); ip16 != nil {
				if isAllOnesIP(ip16) {
					return ""
				}
				return ip16.String()
			}
		}

		i = end
	}
	return ""
}

func fallbackCLI(setName string, ips []string) {
	if len(ips) == 0 {
		return
	}
	var parts []string
	for _, ip := range ips {
		parts = append(parts, fmt.Sprintf("%s timeout %s", ip, blockDurationStr))
	}
	elemExpr := fmt.Sprintf("{ %s }", strings.Join(parts, ", "))
	cmd := exec.Command("nft", "add", "element", "inet", nftTableName, setName, elemExpr)
	if err := cmd.Run(); err == nil {
		log.Printf("[+] DDoS Blocker (Fallback %s): Đã khóa %d IP (%s)", setName, len(ips), blockDurationStr)
	}
}

func flushBatch(setV4, setV6 *nftables.Set, batch []string) {
	if len(batch) == 0 {
		return
	}

	var elemsV4 []nftables.SetElement
	var elemsV6 []nftables.SetElement
	var listV4 []string
	var listV6 []string

	for _, ipStr := range batch {
		ip := net.ParseIP(ipStr)
		if ip == nil {
			continue
		}
		if ip4 := ip.To4(); ip4 != nil {
			if isAllOnesIP(ip4) {
				continue
			}
			listV4 = append(listV4, ip4.String())
			elemsV4 = append(elemsV4, nftables.SetElement{
				Key:     ip4,
				Timeout: blockDuration,
			})
		} else if ip16 := ip.To16(); ip16 != nil {
			if isAllOnesIP(ip16) {
				continue
			}
			listV6 = append(listV6, ip16.String())
			elemsV6 = append(elemsV6, nftables.SetElement{
				Key:     ip16,
				Timeout: blockDuration,
			})
		}
	}

	if len(elemsV4) == 0 && len(elemsV6) == 0 {
		return
	}

	conn := &nftables.Conn{}
	if len(elemsV4) > 0 {
		_ = conn.SetAddElements(setV4, elemsV4)
	}
	if len(elemsV6) > 0 {
		_ = conn.SetAddElements(setV6, elemsV6)
	}

	if err := conn.Flush(); err != nil {
		if len(listV4) > 0 {
			fallbackCLI(nftSetV4, listV4)
		}
		if len(listV6) > 0 {
			fallbackCLI(nftSetV6, listV6)
		}
		return
	}

	log.Printf("[+] DDoS Blocker (Netlink O(1)): Đã khóa %d IP trong %s (v4: %d, v6: %d)",
		len(listV4)+len(listV6), blockDurationStr, len(listV4), len(listV6))
}

func main() {
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	for {
		if _, err := os.Stat(logFile); err == nil {
			break
		}
		select {
		case <-ctx.Done():
			return
		case <-time.After(3 * time.Second):
		}
	}

	log.Printf("[*] WPTangToc Anti-DDoS (Netlink Hash O(1) -> %s/%s, Timeout: %s) đang bảo vệ hệ thống...",
		nftSetV4, nftSetV6, blockDurationStr)

	table := &nftables.Table{Name: nftTableName, Family: nftables.TableFamilyINet}
	setV4 := &nftables.Set{
		Table:      table,
		Name:       nftSetV4,
		HasTimeout: true,
		Timeout:    blockDuration,
	}
	setV6 := &nftables.Set{
		Table:      table,
		Name:       nftSetV6,
		HasTimeout: true,
		Timeout:    blockDuration,
	}

	ipChan := make(chan string, 100000)
	doneChan := make(chan struct{})

	go func() {
		defer close(doneChan)

		seenIPs := make(map[string]time.Time, 4096)
		batch := make([]string, 0, batchSize)

		flushTicker := time.NewTicker(flushInterval)
		defer flushTicker.Stop()

		cleanupTicker := time.NewTicker(cleanupInterval)
		defer cleanupTicker.Stop()

		for {
			select {
			case ipStr, ok := <-ipChan:
				if !ok {
					if len(batch) > 0 {
						flushBatch(setV4, setV6, batch)
					}
					return
				}

				now := time.Now()
				if exp, exists := seenIPs[ipStr]; exists && now.Before(exp) {
					continue
				}

				if len(seenIPs) >= maxCacheSize {
					for k, exp := range seenIPs {
						if now.After(exp) {
							delete(seenIPs, k)
						}
					}
					if len(seenIPs) >= maxCacheSize {
						seenIPs = make(map[string]time.Time, 4096)
					}
				}

				seenIPs[ipStr] = now.Add(dedupTTL)
				batch = append(batch, ipStr)

				if len(batch) >= batchSize {
					flushBatch(setV4, setV6, batch)
					batch = batch[:0]
				}

			case <-flushTicker.C:
				if len(batch) > 0 {
					flushBatch(setV4, setV6, batch)
					batch = batch[:0]
				}

			case <-cleanupTicker.C:
				now := time.Now()
				for k, exp := range seenIPs {
					if now.After(exp) {
						delete(seenIPs, k)
					}
				}
			}
		}
	}()

	for {
		if ctx.Err() != nil {
			break
		}

		cmd := exec.CommandContext(ctx, "tail", "-F", "-n", "0", logFile)
		cmd.SysProcAttr = &syscall.SysProcAttr{
			Pdeathsig: syscall.SIGKILL,
		}

		stdout, err := cmd.StdoutPipe()
		if err != nil {
			log.Printf("[!] Lỗi tạo pipe: %v, thử lại sau 2s...", err)
			time.Sleep(2 * time.Second)
			continue
		}

		if err := cmd.Start(); err != nil {
			log.Printf("[!] Lỗi khởi chạy tail: %v, thử lại sau 2s...", err)
			time.Sleep(2 * time.Second)
			continue
		}

		reader := bufio.NewReaderSize(stdout, 256*1024)
		for {
			lineBytes, isPrefix, err := reader.ReadLine()
			if err != nil {
				break
			}

			if isPrefix {
				for isPrefix && err == nil {
					_, isPrefix, err = reader.ReadLine()
				}
				continue
			}

			if len(lineBytes) == 0 {
				continue
			}

			normalizedIP := extractIPFromOLSLog(string(lineBytes))
			if normalizedIP == "" || whitelistIPs[normalizedIP] {
				continue
			}

			select {
			case ipChan <- normalizedIP:
			default:
			}
		}

		_ = cmd.Wait()
		if ctx.Err() != nil {
			break
		}
		log.Printf("[!] Tiến trình Tail bị ngắt, đang tự động kết nối lại sau 1s...")
		time.Sleep(1 * time.Second)
	}

	close(ipChan)
	<-doneChan
	log.Printf("[*] WPTangToc Anti-DDoS đã dừng an toàn.")
}
