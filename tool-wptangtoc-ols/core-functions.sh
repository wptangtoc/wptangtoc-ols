#!/bin/bash
# ==============================================================================
# Đường dẫn: . /etc/wptt/core-functions.sh
# Mọi script cần gọi: . /etc/wptt/core-functions.sh để sử dụng
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. HÀM NHẬN DIỆN HỆ ĐIỀU HÀNH (OS DETECTION)
# Trả về: "rhel" (Alma/Rocky/RHEL/Oracle) hoặc Ubuntu
# cách dùng 1: if [[ "$(wptt_get_os_family)" == "ubuntu" ]]; then

#cách 2: # Gán kết quả của hàm vào biến OS
#OS=$(wptt_get_os_family)
# Sau đó lấy biến OS ra dùng thoải mái ở mọi nơi
#if [[ "$OS" == "ubuntu" ]]; then
#  echo 'giatuandz ubuntu'
#elif [[ "$OS" == "rhel" ]]; then
#  echo 'almalinux'
#fi
# ------------------------------------------------------------------------------
function wptt_get_os_family() {
  if grep -qi "ubuntu" /etc/*release; then
    echo "ubuntu"
  elif grep -q "AlmaLinux\|Rocky Linux\|Red Hat Enterprise Linux\|Oracle Linux Server" /etc/*release; then
    echo "rhel"
  else
    echo "unknown"
  fi
}

# ------------------------------------------------------------------------------
# 2. HÀM LẤY IP PUBLIC SIÊU TỐC VÀ CHỐNG LỖI MẠNG
# Tự động thử các API khác nhau, có timeout 3s để không làm treo panel
# ------------------------------------------------------------------------------
function wptt_get_public_ip() {
  local ip
  ip=$(curl -sf -m 3 ipv4.icanhazip.com)
  if [[ -z "$ip" ]]; then
    ip=$(curl -sf -m 3 api.ipify.org)
  fi
  if [[ -z "$ip" ]]; then
    ip=$(curl -sf -m 3 ifconfig.me)
  fi
  echo "$ip"
}

# ------------------------------------------------------------------------------
# 3. HÀM LẤY DUNG LƯỢNG RAM THỰC TẾ (Đơn vị: MB)
# Phục vụ cho việc chia RAM cho OLS, MariaDB, Object Cache tự động
# ------------------------------------------------------------------------------
function wptt_get_ram_mb() {
  local ram_bytes
  ram_bytes=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
  local ram_mb=$(echo "scale=0;${ram_bytes}/1024" | bc)
  if [[ -z "$ram_mb" ]]; then
    echo "2048" # Fallback an toàn nếu lỗi
  else
    echo "$ram_mb"
  fi
}

# ------------------------------------------------------------------------------
# 4. HÀM BẢO VỆ CHỐNG TỰ HỦY KHI XÓA THƯ MỤC (ANTI RM -RF /)
# Rất quan trọng khi xóa Vhost. Nếu domain rỗng hoặc chứa ký tự nguy hiểm sẽ báo lỗi.
# Cách dùng: if wptt_kha_dung_de_xoa_xac_thuc "$domain"; then ...
# ------------------------------------------------------------------------------
function wptt_kha_dung_de_xoa_xac_thuc() {
  local domain="$1"
  # Kiểm tra rỗng, trùng root, hoặc có wildcard nguy hiểm
  if [[ -z "$domain" || "$domain" == "." || "$domain" == "/" || "$domain" == *"*"* ]]; then
    return 1 # Trả về False (Lỗi)
  fi
  # Kiểm tra đúng chuẩn định dạng domain (có dấu chấm, không ký tự lạ)
  if [[ ! "$domain" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    return 1
  fi
  return 0 # Trả về True (Hợp lệ)
}
