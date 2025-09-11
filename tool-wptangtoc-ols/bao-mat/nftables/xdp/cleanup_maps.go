package main

import (
	"bufio"
	"encoding/binary"
	"fmt"
	"log"
	"net"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/cilium/ebpf"
)

const (
	bpfFsPath           = "/sys/fs/bpf"
	logBlacklistMapName = "log_blacklist"
	rlBlacklistMapName  = "rl_blacklist"
)

// getBootTimeNS đọc thời gian boot của hệ thống từ /proc/stat và trả về dưới dạng nanosecond.
// Điều này rất quan trọng để đồng bộ với đồng hồ CLOCK_MONOTONIC của BPF.
// clean map này để xoá những danh sách ip hết hạn unban ra khỏi danh sách để tránh lãng phí lưu trữ những thông tin ip này
func getBootTimeNS() (uint64, error) {
	file, err := os.Open("/proc/stat")
	if err != nil {
		return 0, err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		if strings.HasPrefix(line, "btime") {
			fields := strings.Fields(line)
			if len(fields) == 2 {
				btime, err := strconv.ParseUint(fields[1], 10, 64)
				if err != nil {
					return 0, fmt.Errorf("không thể phân tích btime: %w", err)
				}
				// btime là giây, chuyển sang nanosecond
				return btime * 1_000_000_000, nil
			}
		}
	}

	if err := scanner.Err(); err != nil {
		return 0, err
	}

	return 0, fmt.Errorf("không tìm thấy 'btime' trong /proc/stat")
}

func intToIP(ipInt uint32) net.IP {
	ip := make(net.IP, 4)
	binary.BigEndian.PutUint32(ip, ipInt)
	return ip
}

func cleanupMap(mapName string, bootTimeNS uint64) {
	mapPath := bpfFsPath + "/" + mapName
	
	m, err := ebpf.LoadPinnedMap(mapPath, nil)
	if err != nil {
		if os.IsNotExist(err) {
			log.Printf("Map %s không tìm thấy tại %s, bỏ qua.", mapName, mapPath)
			return
		}
		log.Fatalf("Không thể mở map %s: %v", mapName, err)
	}
	defer m.Close()

	log.Printf("--- Bắt đầu dọn dẹp map: %s ---", mapName)

	var (
		key         uint32
		value       uint64 // ban timestamp (dựa trên CLOCK_MONOTONIC)
		deletedKeys []uint32
	)

	iter := m.Iterate()
	
	// === SỬA LỖI LOGIC THỜI GIAN ===
	// Tính toán thời gian monotonic hiện tại
	realTimeNowNS := uint64(time.Now().UnixNano())
	monotonicNowNS := realTimeNowNS - bootTimeNS

	for iter.Next(&key, &value) {
		// Bây giờ cả hai giá trị đều dựa trên cùng một gốc (thời điểm boot)
		if monotonicNowNS > value {
			deletedKeys = append(deletedKeys, key)
		}
	}

	if err := iter.Err(); err != nil {
		log.Fatalf("Lỗi khi duyệt map %s: %v", mapName, err)
	}

	if len(deletedKeys) > 0 {
		deletedCount := 0
		for _, k := range deletedKeys {
			err := m.Delete(k)
			if err != nil {
				log.Printf("Lỗi khi xóa IP %s khỏi map %s: %v", intToIP(k).String(), mapName, err)
			} else {
				deletedCount++
			}
		}
		log.Printf("Hoàn thành: Đã xóa %d/%d entry hết hạn khỏi map %s.", deletedCount, len(deletedKeys), mapName)
	} else {
		log.Printf("Không có entry nào hết hạn trong map %s.", mapName)
	}
}

func main() {
	if os.Geteuid() != 0 {
		log.Fatal("Chương trình này cần được chạy với quyền root (sudo) để truy cập BPF maps.")
	}

	bootTimeNS, err := getBootTimeNS()
	if err != nil {
		log.Fatalf("Lỗi nghiêm trọng: không thể lấy thời gian boot của hệ thống: %v", err)
	}

	cleanupMap(logBlacklistMapName, bootTimeNS)
	cleanupMap(rlBlacklistMapName, bootTimeNS)
}
