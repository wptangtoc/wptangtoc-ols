package main

import (
	"log"
	"os"
	"os/exec"
	"regexp"
	"strings"
	"time"
    "fmt" // Thêm fmt vào để sử dụng Sprintf

	"github.com/fsnotify/fsnotify"
)

// --- CẤU HÌNH ---
const (
	watchDir      = "/tmp/lshttpd/"
	nftFamily     = "inet"
	nftTableName  = "blackblock"
	nftSetName    = "blackaction"
	blockDuration = "16h"
)

// Regex để trích xuất chuỗi IP từ dòng "BLOCKED_IP:"
var reportRegex = regexp.MustCompile(`BLOCKED_IP:([0-9.,]+)`)
// --- KẾT THÚC CẤU HÌNH ---

func blockIP(ip string) {
	// Kiểm tra xem IP có rỗng không
	trimmedIP := strings.TrimSpace(ip)
	if trimmedIP == "" {
		return
	}

	log.Printf("[ACTION] Đang chặn IP: %s", trimmedIP)
    // SỬA LỖI: "Fmt" đã được đổi thành "fmt" (viết thường)
	element := fmt.Sprintf("{ %s timeout %s }", trimmedIP, blockDuration)
	cmd := exec.Command("nft", "add", "element", nftFamily, nftTableName, nftSetName, element)


	output, err := cmd.CombinedOutput()
	if err != nil {
		if !strings.Contains(string(output), "File exists") {
			log.Printf("[!] Lỗi khi chặn IP %s: %v, Output: %s", trimmedIP, err, string(output))
		}
	} else {
		log.Printf("[+] Đã chặn thành công IP: %s", trimmedIP)
	}
}

// Hàm đọc file report và xử lý các IP bị chặn
func processReportFile(filePath string) {
	// Đợi một chút để đảm bảo LiteSpeed đã ghi xong file
	time.Sleep(100 * time.Millisecond)

	content, err := os.ReadFile(filePath)
	if err != nil {
		log.Printf("[WARN] Không thể đọc file: %s, lỗi: %v", filePath, err)
		return
	}

	// Tìm chuỗi IP trong nội dung file
	matches := reportRegex.FindSubmatch(content)
	if len(matches) < 2 {
		return // Không tìm thấy dòng BLOCKED_IP
	}

	// Tách chuỗi thành các IP riêng lẻ
	ipListStr := string(matches[1])
	ips := strings.Split(ipListStr, ",")

	log.Printf("[EVENT] Phát hiện %d IP bị chặn trong file %s", len(ips), filePath)
	for _, ip := range ips {
		// Chạy việc chặn trong một goroutine để không làm nghẽn watcher
		go blockIP(ip)
	}
}

func main() {
	// Tạo một watcher mới
	watcher, err := fsnotify.NewWatcher()
	if err != nil {
		log.Fatal("Lỗi khi tạo watcher:", err)
	}
	defer watcher.Close()

	// Bắt đầu một goroutine để lắng nghe các sự kiện
	go func() {
		for {
			select {
			case event, ok := <-watcher.Events:
				if !ok {
					return
				}
				// Chỉ hành động khi file được tạo mới hoặc được ghi đè
				if (event.Op&fsnotify.Create == fsnotify.Create || event.Op&fsnotify.Write == fsnotify.Write) && strings.HasPrefix(event.Name, watchDir+".rtreport") {
					go processReportFile(event.Name)
				}
			case err, ok := <-watcher.Errors:
				if !ok {
					return
				}
				log.Println("Lỗi watcher:", err)
			}
		}
	}()

	// Thêm thư mục cần theo dõi vào watcher
	err = watcher.Add(watchDir)
	if err != nil {
		log.Fatalf("Lỗi khi thêm thư mục vào watcher: %v. Hãy đảm bảo thư mục '%s' tồn tại.", err, watchDir)
	}

	log.Printf("Bắt đầu theo dõi thư mục '%s' theo thời gian thực...", watchDir)
	// Chặn hàm main lại để chương trình chạy mãi mãi
	<-make(chan struct{})
}

