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
  local monit_svc_name="$2"
  local max_ticks=90 # 90 * 0.5s = 45 giây
  local tick=0

  # Đảm bảo dịch vụ đang ở chế độ được Monit giám sát (phòng trường hợp bị unmonitor trước đó)
  monit monitor "$monit_svc_name" >/dev/null 2>&1 || true
  sleep 1
  monit validate >/dev/null 2>&1 || true

  while ((tick < max_ticks)); do
    if eval "$check_cmd" >/dev/null 2>&1; then
      return 0
    fi
    if ((tick > 0 && tick % 10 == 0)); then
      monit validate >/dev/null 2>&1 || true
    fi
    sleep 0.5
    ((tick++))
  done

  printf '\n[THẤT BẠI] Monit không tự khởi động lại được "%s" sau 45 giây!\n' "$monit_svc_name" >&3
  printf '--- CHI TIẾT MONIT STATUS (%s) ---\n' "$monit_svc_name" >&3
  monit status "$monit_svc_name" 2>&1 >&3 || true
  printf '--- LOG MONIT GẦN NHẤT ---\n' >&3
  journalctl -u monit -n 15 --no-pager 2>&1 >&3 || tail -n 15 /var/log/monit.log 2>/dev/null >&3 || true
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

@test "✅ Cổng điều khiển nội bộ Monit HTTP (127.0.0.1:2812) đang lắng nghe" {
  local ss_out=""
  ss_out="$(ss -tln)"
  if ! grep -qE '127\.0\.0\.1:2812[[:space:]]' <<<"$ss_out"; then
    printf '\n[LỖI] Monit HTTP port 2812 không mở trên 127.0.0.1!\n%s\n' "$ss_out" >&3
    return 1
  fi

  run monit summary
  if [[ "$status" -ne 0 ]]; then
    printf '\n[LỖI] Lệnh "monit summary" không kết nối được tới Monit daemon:\n%s\n' "$output" >&3
    return 1
  fi
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
