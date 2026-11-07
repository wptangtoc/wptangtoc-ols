#!/usr/bin/env bats
# ==============================================================================
# MỤC ĐÍCH: Kiểm thử thực chiến (Chaos Testing) khả năng tự động phát hiện và
#           khởi động lại dịch vụ bị sập của hệ thống Monit trong WPTangToc OLS.
# ==============================================================================

export LC_ALL=C.UTF-8 2>/dev/null || export LC_ALL=en_US.UTF-8 2>/dev/null || true
export LANG=C.UTF-8 2>/dev/null || export LANG=en_US.UTF-8 2>/dev/null || true

setup_file() {
  if grep -qi "ubuntu" /etc/*release 2>/dev/null; then
    export FILE_MONITRC="/etc/monit/monitrc"
    export DIR_MONIT="/etc/monit/conf.d"
  else
    export FILE_MONITRC="/etc/monitrc"
    export DIR_MONIT="/etc/monit.d"
  fi
}

# Đảm bảo mọi dịch vụ cốt lõi luôn được bật lại an toàn sau mỗi test
teardown() {
  if ! systemctl is-active --quiet lshttpd 2>/dev/null && ! systemctl is-active --quiet lsws 2>/dev/null; then
    systemctl start lshttpd 2>/dev/null || systemctl start lsws 2>/dev/null || /usr/local/lsws/bin/lswsctrl start >/dev/null 2>&1 || true
  fi
  if ! systemctl is-active --quiet mariadb 2>/dev/null && ! systemctl is-active --quiet mysql 2>/dev/null; then
    systemctl start mariadb 2>/dev/null || systemctl start mysql 2>/dev/null || true
  fi
  for svc in valkey keydb redis memcached; do
    if [[ -f "${DIR_MONIT}/${svc}" ]] && ! systemctl is-active --quiet "$svc" 2>/dev/null; then
      systemctl start "$svc" 2>/dev/null || true
    fi
  done
}

# --- HÀM HỖ TRỢ: CHỜ MONIT TỰ CỨU DỊCH VỤ (TỐI ĐA 45 GIÂY) ---
_wait_for_monit_heal() {
  local check_cmd="$1"
  local service_name="$2"
  local timeout=180  # Tăng lên 180 giây để bao trọn 2-3 chu kỳ Monit
  local count=0

  # Đánh thức Monit kiểm tra ngay lập tức
  command -v monit >/dev/null && monit validate >/dev/null 2>&1 || true

  while (( count < timeout )); do
    if eval "$check_cmd"; then
      return 0
    fi
    sleep 3
    ((count+=3))
  done
  
  echo "Timeout: Monit không thể tự cứu sống $service_name sau $timeout giây!" >&3
  return 1
}

# ==============================================================================
# NHÓM 1: KIỂM ĐỊNH CẤU HÌNH & DAEMON MONIT
# ==============================================================================

@test "✅ Dịch vụ Monit đã cài đặt, đang chạy (Active) và cú pháp hợp lệ (monit -t)" {
  command -v monit >/dev/null 2>&1 || {
    printf '\n[LỖI] Chưa cài đặt gói monit!\n' >&3
    return 1
  }

  run systemctl is-active monit
  [[ "$status" -eq 0 ]]
  [[ "$output" == "active" ]]

  run monit -t
  if [[ "$status" -ne 0 ]]; then
    printf '\n=== LỖI CÚ PHÁP CẤU HÌNH MONIT ===\n%s\n' "$output" >&3
    return 1
  fi
}

@test "✅ Giao diện điều khiển Monit dùng Unix Socket bảo mật (0600, chỉ root tương tác được)" {
  # 1. Đảm bảo không mở cổng TCP 2812 ra ngoài network stack
  if ss -tln | grep -qE ':2812[[:space:]]'; then
    printf '\n[LỖI BẢO MẬT] Cổng TCP 2812 vẫn đang mở! Phải dùng Unix Socket để cô lập quyền root.\n' >&3
    return 1
  fi

  # 2. Kiểm tra file /run/monit.sock tồn tại và khóa chặt quyền 600 thuộc root:root
  [[ -S "/run/monit.sock" ]] || {
    printf '\n[LỖI] Không tìm thấy Unix Socket /run/monit.sock!\n' >&3
    return 1
  }

  local sock_perm=""
  sock_perm="$(stat -c '%a:%U:%G' /run/monit.sock)"
  if [[ "$sock_perm" != "600:root:root" ]]; then
    printf '\n[LỖI BẢO MẬT] Quyền của /run/monit.sock là "%s" (kỳ vọng: 600:root:root)!\n' "$sock_perm" >&3
    return 1
  fi

  # 3. Xác nhận root gọi monit summary thành công qua socket
  run monit summary
  [[ "$status" -eq 0 ]]
}

@test "✅ Kiểm tra tính hợp lệ của đường dẫn PID/Socket trong các rule Monit hiện hành" {
  [[ -f "${DIR_MONIT}/lshttpd" ]] || {
    printf '\n[LỖI] Thiếu file rule %s/lshttpd\n' "$DIR_MONIT" >&3
    return 1
  }

  local declared_pidfile=""
  declared_pidfile="$(awk '/with pidfile/ {print $NF}' "${DIR_MONIT}/lshttpd")"
  if [[ -n "$declared_pidfile" && ! -f "$declared_pidfile" ]]; then
    printf '\n[CẢNH BÁO BUG] Rule lshttpd trỏ tới pidfile "%s" nhưng file này KHÔNG TỒN TẠI trên đĩa!\n' "$declared_pidfile" >&3
    return 1
  fi
}

# ==============================================================================
# NHÓM 2: CHAOS TESTING - GIẢ LẬP SẬP DỊCH VỤ & KIỂM TRA TỰ PHỤC HỒI (AUTO-HEAL)
# ==============================================================================

@test "🔥 [Chaos Test] Giả lập sập Webserver OLS -> Monit tự động cứu sống" {
  [[ -f "${DIR_MONIT}/lshttpd" ]] || skip "Chưa cấu hình rule Monit cho lshttpd"

  monit monitor lshttpd >/dev/null 2>&1 || true

  # Tuyệt đối dùng -x (exact process name) hoặc lswsctrl stop, KHÔNG dùng pkill -f để tránh bắn nhầm BATS
  systemctl stop lshttpd 2>/dev/null || /usr/local/lsws/bin/lswsctrl stop >/dev/null 2>&1 || true
  pkill -9 -x lshttpd 2>/dev/null || pkill -9 -x openlitespeed 2>/dev/null || true
  sleep 1

  _wait_for_monit_heal "ss -tln | grep -qE ':80[[:space:]]'" "lshttpd"
}

@test "🔥 [Chaos Test] Giả lập sập Database Server -> Monit tự động cứu sống" {
  [[ -f "${DIR_MONIT}/mariadb" ]] || skip "Chưa cấu hình rule Monit cho mariadb"

  # Lưu ý: Trên RHEL/Ubuntu, systemd mặc định của MariaDB có Restart=on-abort (tự cứu khi bị kill -9).
  # Để test đúng năng lực của Monit, ta dùng systemctl stop mariadb (giả lập dịch vụ bị dừng hẳn).
  monit monitor mariadb >/dev/null 2>&1 || true
  systemctl stop mariadb 2>/dev/null || systemctl stop mysql 2>/dev/null || true
  sleep 1

  _wait_for_monit_heal "systemctl is-active --quiet mariadb || systemctl is-active --quiet mysql" "mariadb"
}

@test "🔥 [Chaos Test] Giả lập sập Object Cache -> Monit tự động cứu sống" {
  local active_cache=""
  for engine in valkey keydb redis; do
    if [[ -f "${DIR_MONIT}/${engine}" ]]; then
      active_cache="$engine"
      break
    fi
  done

  if [[ -z "$active_cache" ]]; then
    skip "Máy chủ không bật rule Monit cho Object Cache (Valkey/KeyDB/Redis)"
  fi

  monit monitor "$active_cache" >/dev/null 2>&1 || true
  systemctl stop "$active_cache" 2>/dev/null || pkill -9 -x "${active_cache}-server" 2>/dev/null || true
  sleep 1

  _wait_for_monit_heal "systemctl is-active --quiet $active_cache" "$active_cache"
}

@test "🔥 [Chaos Test] Giả lập sập Memcached -> Monit tự động cứu sống" {
  if [[ ! -f "${DIR_MONIT}/memcached" ]]; then
    skip "Máy chủ không bật rule Monit cho Memcached"
  fi

  monit monitor memcached >/dev/null 2>&1 || true
  systemctl stop memcached 2>/dev/null || pkill -9 -x memcached 2>/dev/null || true
  sleep 1

  _wait_for_monit_heal "systemctl is-active --quiet memcached" "memcached"
}
