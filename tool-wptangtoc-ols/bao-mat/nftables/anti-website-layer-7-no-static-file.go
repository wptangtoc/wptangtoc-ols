package main

import (
    "bufio"
    "fmt" 
    "log"
    "os"
    "os/exec"
    "regexp"
    "strings"
    "sync"
    "time"
)

// --- CẤU HÌNH ---
const (
	logFile       = "/usr/local/lsws/wptangtoc.com/logs/access.log"
	nftFamily     = "ip"           
	nftTableName  = "blackblock"   
	nftSetName    = "blackaction"  
	blockDuration = "1h"
    
	maxRequests = 30
	timeWindow  = 10 * time.Second

    // Đường dẫn đến file whitelist
    whitelistFile = "/etc/go_blocker/whitelist.txt"
)

// Whitelist: Các IP không bao giờ bị chặn. Sẽ được nạp từ file.
var whitelistIPs = make(map[string]bool)

// Regex để lấy IP và request path từ access.log
var logRegex = regexp.MustCompile(`^(?P<ip>\S+) \S+ \S+ \[.*?\] \"\S+ (?P<path>\S+) \S+\"`)

// Regex để nhận diện các file tĩnh
var staticFileRegex = regexp.MustCompile(`(?i)\.(css|js|jpe?g|png|gif|webp|svg|ico|woff2?|ttf|eot|mp4|webm)$`)

// Biến toàn cục để lưu trữ request của các IP
var (
	ipRequests = make(map[string][]int64)
	mu         sync.Mutex
)
// --- KẾT THÚC CẤU HÌNH ---

// Hàm nạp whitelist từ file
func loadWhitelist() {
    file, err := os.Open(whitelistFile)
    if err != nil {
        log.Printf("[WARN] Không tìm thấy file whitelist tại '%s'. Bỏ qua.", whitelistFile)
        return
    }
    defer file.Close()

    scanner := bufio.NewScanner(file)
    count := 0
    for scanner.Scan() {
        line := strings.TrimSpace(scanner.Text())
        // Bỏ qua các dòng trống và dòng ghi chú
        if line != "" && !strings.HasPrefix(line, "#") {
            whitelistIPs[line] = true
            count++
        }
    }
    log.Printf("[INFO] Đã nạp %d IP từ danh sách trắng.", count)
}


func blockIP(ipAddress string) {
	ip := strings.Split(ipAddress, ":")[0]
    
    if _, isWhitelisted := whitelistIPs[ip]; isWhitelisted {
        log.Printf("[WHITELISTED] Bỏ qua yêu cầu chặn IP trong danh sách trắng: %s", ip)
        return
    }
	
	log.Printf("[ATTACK DETECTED] Đang chặn IP: %s", ip)
	
	element := fmt.Sprintf("{ %s timeout %s }", ip, blockDuration)
	cmd := exec.Command("nft", "add", "element", nftFamily, nftTableName, nftSetName, element)

	output, err := cmd.CombinedOutput()
	if err != nil {
		if !strings.Contains(string(output), "File exists") {
			log.Printf("[!] Lỗi khi chặn IP %s: %v, Output: %s", ip, err, string(output))
		}
	} else {
		log.Printf("[+] Đã chặn thành công IP: %s", ip)
	}
}

func trackAndBlock(ip string) {
    if _, isWhitelisted := whitelistIPs[ip]; isWhitelisted {
        return
    }

    currentTime := time.Now().Unix()
    
    mu.Lock()
    defer mu.Unlock()

    timestamps := ipRequests[ip]
    firstValidIndex := 0
    for i, ts := range timestamps {
        if currentTime-ts < int64(timeWindow.Seconds()) {
            break
        }
        firstValidIndex = i + 1
    }
    ipRequests[ip] = timestamps[firstValidIndex:]

    ipRequests[ip] = append(ipRequests[ip], currentTime)
    if len(ipRequests[ip]) > maxRequests {
        go blockIP(ip)
        delete(ipRequests, ip)
    }
}

func processLine(line string) {
    matches := logRegex.FindStringSubmatch(line)
    
    result := make(map[string]string)
    for i, name := range logRegex.SubexpNames() {
        if i != 0 && name != "" && i < len(matches) {
            result[name] = matches[i]
        }
    }

    ip, ip_ok := result["ip"]
    path, path_ok := result["path"]

    if ip_ok && path_ok {
        if staticFileRegex.MatchString(path) {
            return 
        }
        
        trackAndBlock(ip)
    }
}

func main() {
    // Nạp whitelist ngay khi chương trình bắt đầu
    loadWhitelist()

    if _, err := os.Stat(logFile); os.IsNotExist(err) {
        log.Fatalf("[!] Lỗi: File log '%s' không tồn tại.", logFile)
    }

	log.Printf("Bắt đầu theo dõi file log động: %s", logFile)

	cmd := exec.Command("tail", "-F", "-n", "0", logFile)
	stdout, _ := cmd.StdoutPipe()
	cmd.Start()
	scanner := bufio.NewScanner(stdout)
	for scanner.Scan() {
		line := scanner.Text()
		processLine(line)
	}
	cmd.Wait()
}

