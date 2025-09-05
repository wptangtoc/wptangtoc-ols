// 1. Khai báo package luôn là dòng đầu tiên
package main

// 2. Khối import
import (
	"bufio"
	"fmt"
	"log"
	"os"
	"os/exec"
	"regexp"
	"strings"
)

// 3. Cấu hình đã được sửa lại để khớp với lệnh bash của bạn
const (
	logFile       = "/usr/local/lsws/logs/error.log"
	nftFamily     = "ip"           // Đổi từ "inet" thành "ip"
	nftTableName  = "blackblock"   // Tên table của bạn
	nftSetName    = "blackaction"  // Tên set của bạn
	blockDuration = "8h"
)

// Regex đã được cập nhật để khớp với định dạng log mới của bạn
var logRegex = regexp.MustCompile(`\[(?P<ip>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\]\s.*close connection!`)

// == CẢI TIẾN: Thêm danh sách IP không bao giờ chặn (Whitelist) ==
var whitelistIPs = []string{
	"103.106.105.75",
	// Bạn có thể thêm các IP khác vào đây, ví dụ: "8.8.8.8"
}


// 4. Các hàm chức năng
func blockIP(ipAddress string) {
	// Chỉ lấy phần IP, loại bỏ port nếu có
	ip := strings.Split(ipAddress, ":")[0]

	// == CẢI TIẾN: Kiểm tra IP trong whitelist trước khi chặn ==
	for _, whitelistedIP := range whitelistIPs {
		if ip == whitelistedIP {
			log.Printf("[*] Bỏ qua IP trong whitelist: %s", ip)
			return // Thoát khỏi hàm, không thực hiện hành động chặn
		}
	}

	// Chỉ xử lý nếu là địa chỉ IPv4 hợp lệ
	if matched, _ := regexp.MatchString(`^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$`, ip); !matched {
		log.Printf("[*] Bỏ qua địa chỉ không phải IPv4: %s", ip)
		return
	}

	log.Printf("[*] Đang kiểm tra IP: %s", ip)
	
	element := fmt.Sprintf("{ %s timeout %s }", ip, blockDuration)

	// Lệnh 'nft' được xây dựng chính xác theo cấu hình của bạn (đã bỏ sudo)
	cmd := exec.Command("nft", "add", "element", nftFamily, nftTableName, nftSetName, element)
	
	output, err := cmd.CombinedOutput()
	if err != nil {
		if strings.Contains(string(output), "File exists") {
			log.Printf("[*] IP %s đã bị chặn trước đó. Bỏ qua.", ip)
		} else {
			log.Printf("[!] Lỗi khi chặn IP %s: %v, Output: %s", ip, err, string(output))
		}
		return
	}
	log.Printf("[+] Đã chặn thành công IP: %s", ip)
}

func processLine(line string) {
	matches := logRegex.FindStringSubmatch(line)
	if matches == nil {
		return
	}
	
	ipIndex := logRegex.SubexpIndex("ip")
	if ipIndex != -1 {
		ip := matches[ipIndex]
		// Chạy việc chặn trong một goroutine để không làm nghẽn luồng đọc log
		go blockIP(ip)
	}
}

// Hàm main - Nơi chương trình bắt đầu
func main() {
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


