#!/usr/bin/env bats
# @author: Gia Tuấn
# @website: https://wptangtoc.com
# @since: 2026
# @description: Kiểm định trực tiếp trên /etc/wptt

export LC_ALL=C.UTF-8 2>/dev/null || export LC_ALL=en_US.UTF-8 2>/dev/null || true
export LANG=C.UTF-8 2>/dev/null || export LANG=en_US.UTF-8 2>/dev/null || true

_wptt_prepare_script_list() {
  export WPTT_ENGINE_DIR="/etc/wptt"
  export SCRIPT_LIST_FILE="${BATS_TMPDIR:-/tmp}/wptt_bats_audit_list.txt"

  if [[ -s "$SCRIPT_LIST_FILE" ]]; then
    return 0
  fi

  if [[ ! -d "$WPTT_ENGINE_DIR" ]]; then
    echo "Lỗi: Không tìm thấy thư mục /etc/wptt!" >&2
    return 1
  fi

  : >"$SCRIPT_LIST_FILE"
  [[ -f "/usr/bin/wptangtoc" ]] && printf '/usr/bin/wptangtoc\n' >>"$SCRIPT_LIST_FILE"

  local fpath first_line
  while IFS= read -r -d '' fpath; do
    first_line=""
    IFS= read -r -n 128 first_line <"$fpath" 2>/dev/null || true

    # Bỏ qua ngay nếu là file nhị phân biên dịch (ELF Binary: C / Go / eBPF)
    [[ "$first_line" == $'\x7f'* ]] && continue

    # Chỉ thu thập các Bash script hoặc thư viện của WPTangToc OLS
    if [[ "$first_line" == "#!"*"sh"* || "$first_line" == "# @"* || "$first_line" == "# "* || "$fpath" == *.sh ]]; then
      printf '%s\n' "$fpath" >>"$SCRIPT_LIST_FILE"
    fi
  done < <(find "$WPTT_ENGINE_DIR" \
    \( -path "${WPTT_ENGINE_DIR}/.git" \
    -o -path "${WPTT_ENGINE_DIR}/tmp" \
    -o -path "${WPTT_ENGINE_DIR}/vhost" \
    -o -path "${WPTT_ENGINE_DIR}/logs" \
    -o -path "${WPTT_ENGINE_DIR}/tests" \) -prune -o \
    -type f \
    ! -name '*.c' ! -name '*.go' ! -name '*.mod' ! -name '*.sum' ! -name '*.yar' \
    ! -name '*.md' ! -name '*.txt' ! -name '*.json' ! -name '*.yml' ! -name '*.yaml' \
    ! -name '*.png' ! -name '*.jpg' ! -name '*.zip' ! -name '*.tar*' ! -name '*.gz' \
    ! -name '*.sig' ! -name '*.key' ! -name '*.idx' ! -name '*.tsv' ! -name '*.awk' \
    ! -name '*.sed' ! -name '*.conf' ! -name '*.cnf' ! -name '*.service' ! -name '*.timer' \
    ! -name '*.o' ! -name '*.so' ! -name '*.php' ! -name '*.sql' ! -name '*.bats' \
    -print0)
}

# ==============================================================================
# TEST 1: KIỂM TRA CÚ PHÁP BASH -N SIÊU TỐC (BATCH XARGS + TIMEOUT)
# ==============================================================================
@test "[Enterprise Gate 1] Toàn bộ scripts trong /etc/wptt phải chuẩn cú pháp (bash -n)" {
  _wptt_prepare_script_list
  [[ -s "$SCRIPT_LIST_FILE" ]]

  local err_out=""
  err_out="$(timeout 10 xargs -r -P 4 -n 50 bash -n <"$SCRIPT_LIST_FILE" 2>&1)" || {
    printf '\n[LỖI CÚ PHÁP BASH -N]:\n%s\n' "$err_out" >&2
    return 1
  }
}

# ==============================================================================
# TEST 2: QUÉT KÝ TỰ RƠI DÒNG, LỆCH NHÁY SED & LỖI CHÍNH TẢ HÀM
# ==============================================================================
@test "[Enterprise Gate 2] Không có từ khóa rớt dòng (thành, loop):), lỗi sed '@g\"" {
  _wptt_prepare_script_list
  [[ -s "$SCRIPT_LIST_FILE" ]]

  local report=""
  report="$(
    LC_ALL=C.UTF-8 timeout 10 xargs -r awk '
      FNR == 1 { in_heredoc = 0; h_delim = "" }
      {
        if (in_heredoc) {
          if ($0 == h_delim) in_heredoc = 0
          next
        }
        if (match($0, /<<-?[ \t]*[\x27"]?[A-Za-z0-9_]+[\x27"]?/)) {
          h_str = substr($0, RSTART, RLENGTH)
          gsub(/<<-?[ \t]*|[\x27"]/, "", h_str)
          if (h_str != "") { in_heredoc = 1; h_delim = h_str }
        }

        line = $0
        sub(/^[ \t]+/, "", line)
        if (line ~ /^#/ || line == "") next

        if (line ~ /^(thành|loop\):)([ \t]|$)/) {
          printf "%s:%d: Từ khóa bị rớt dòng thành lệnh thực thi -> %s\n", FILENAME, FNR, line
        }
        if (line ~ /\x27@g"/) {
          printf "%s:%d: Lỗi biểu thức sed bị dính đuôi \x27@g\" -> %s\n", FILENAME, FNR, line
        }
      }
    ' <"$SCRIPT_LIST_FILE"
  )"

  if [[ -n "$report" ]]; then
    printf '\n[PHÁT HIỆN LỖI CÂU LỆNH RÁC / TYPO]:\n%s\n' "$report" >&2
    return 1
  fi
}

# ==============================================================================
# TEST 3: KIỂM TOÁN LIÊN KẾT ĐIỀU HƯỚNG MENU (DEAD EXEC ROUTE AUDIT)
# ==============================================================================
@test "[Enterprise Gate 3] Mọi đường dẫn điều hướng 'exec /etc/wptt/...' phải trỏ tới file tồn tại" {
  _wptt_prepare_script_list
  [[ -s "$SCRIPT_LIST_FILE" ]]

  local raw_routes=""
  raw_routes="$(
    LC_ALL=C.UTF-8 timeout 10 xargs -r awk '
      {
        line = $0
        sub(/^[ \t]+/, "", line)
        if (line ~ /^#/) next

        while (match(line, /exec[ \t]+["\x27]?\/etc\/wptt\/[a-zA-Z0-9_.\/-]+/)) {
          matched = substr(line, RSTART, RLENGTH)
          line = substr(line, RSTART + RLENGTH)

          if (substr(line, 1, 1) == "$") continue

          sub(/^exec[ \t]+["\x27]?\/etc\/wptt\//, "", matched)
          gsub(/["\x27]/, "", matched)

          if (matched ~ /^tmp\// || matched ~ /^vhost\//) continue

          printf "%s:%d:%s\n", FILENAME, FNR, matched
        }
      }
    ' <"$SCRIPT_LIST_FILE"
  )"

  local broken_routes="" src_file line_no rel_target
  while IFS=: read -r src_file line_no rel_target; do
    [[ -z "$rel_target" ]] && continue
    if [[ ! -f "/etc/wptt/${rel_target}" ]]; then
      broken_routes+="${src_file}:${line_no} -> Đường dẫn exec không tồn tại: /etc/wptt/${rel_target}"$'\n'
    fi
  done <<<"$raw_routes"

  if [[ -n "$broken_routes" ]]; then
    printf '\n[PHÁT HIỆN ĐƯỜNG DẪN EXEC KHÔNG TỒN TẠI]:\n%s\n' "$broken_routes" >&2
    return 1
  fi
}

# ==============================================================================
# TEST 4: KIỂM TRA ĐỨT CHUỖI THÔNG BÁO (_runing / _rundone / _runloi)
# ==============================================================================
@test "[Enterprise Gate 4] Không bị đứt chuỗi nháy đơn (Let's Encrypt) trong _runing/_rundone/_runloi" {
  _wptt_prepare_script_list
  [[ -s "$SCRIPT_LIST_FILE" ]]

  local broken_quotes=""
  broken_quotes="$(
    LC_ALL=C.UTF-8 timeout 10 xargs -r awk '
      {
        line = $0
        sub(/^[ \t]+/, "", line)
        if (line ~ /^#/) next

        if (line ~ /^(_runing|_rundone|_runloi)[ \t]+/) {
          if (line ~ /\x27[^\x27]*Let\x27s/) {
            printf "%s:%d: Đứt chuỗi nháy đơn tại chữ Let\x27s -> %s\n", FILENAME, FNR, line
          }
        }
      }
    ' <"$SCRIPT_LIST_FILE"
  )"

  if [[ -n "$broken_quotes" ]]; then
    printf '\n[PHÁT HIỆN ĐỨT CHUỖI UI TRONG _runing/_rundone/_runloi]:\n%s\n' "$broken_quotes" >&2
    return 1
  fi
}

# ==============================================================================
# TEST 5: KIỂM TOÁN BẢO VỆ TRẠNG THÁI TERMINAL (STTY -ECHO & TPUT CIVIS)
# ==============================================================================
@test "[Enterprise Gate 5] Mọi file tắt 'stty -echo' hoặc ẩn con trỏ 'tput civis' đều phải khôi phục lại" {
  _wptt_prepare_script_list
  [[ -s "$SCRIPT_LIST_FILE" ]]

  local leaky_files=""
  leaky_files="$(
    LC_ALL=C.UTF-8 timeout 10 xargs -r awk '
      FNR == 1 {
        if (NR > 1) {
          if (has_noecho && !has_echo_restore) {
            printf "%s: Có gọi \"stty -echo\" nhưng thiếu \"stty echo\" hoặc \"stty sane\"!\n", prev_file
          }
          if (has_civis && !has_cnorm_restore) {
            printf "%s: Có gọi \"tput civis\" nhưng thiếu \"tput cnorm\"!\n", prev_file
          }
        }
        prev_file = FILENAME
        has_noecho = 0; has_echo_restore = 0
        has_civis = 0; has_cnorm_restore = 0
      }
      {
        line = $0
        sub(/^[ \t]+/, "", line)
        if (line ~ /^#/) next

        if (line ~ /stty[ \t]+-echo/) has_noecho = 1
        if (line ~ /stty[ \t]+(echo|sane)/ || line ~ /_cleanup/) has_echo_restore = 1

        if (line ~ /tput[ \t]+civis/) has_civis = 1
        if (line ~ /tput[ \t]+cnorm/ || line ~ /\?25h/ || line ~ /_cleanup/) has_cnorm_restore = 1
      }
      END {
        if (NR > 0) {
          if (has_noecho && !has_echo_restore) {
            printf "%s: Có gọi \"stty -echo\" nhưng thiếu \"stty echo\" hoặc \"stty sane\"!\n", prev_file
          }
          if (has_civis && !has_cnorm_restore) {
            printf "%s: Có gọi \"tput civis\" nhưng thiếu \"tput cnorm\"!\n", prev_file
          }
        }
      }
    ' <"$SCRIPT_LIST_FILE"
  )"

  if [[ -n "$leaky_files" ]]; then
    printf '\n[PHÁT HIỆN RÒ RỈ TRẠNG THÁI TERMINAL]:\n%s\n' "$leaky_files" >&2
    return 1
  fi
}

# ==============================================================================
# TEST 6: KIỂM TRA KÝ TỰ CRLF (\r) CỦA WINDOWS TRÊN DÒNG SHEBANG
# ==============================================================================
@test "[Enterprise Gate 6] Mã nguồn sạch 100% ký tự xuống dòng Windows (CRLF) trên dòng Shebang" {
  _wptt_prepare_script_list
  [[ -s "$SCRIPT_LIST_FILE" ]]

  local crlf_files=""
  crlf_files="$(
    LC_ALL=C timeout 10 xargs -r awk '
      FNR == 1 && /\r$/ {
        printf "%s:1: Chứa ký tự CRLF (\\r) ở dòng Shebang gây lỗi bad interpreter\n", FILENAME
      }
    ' <"$SCRIPT_LIST_FILE"
  )"

  if [[ -n "$crlf_files" ]]; then
    printf '\n[PHÁT HIỆN LỖI CRLF WINDOWS]:\n%s\n' "$crlf_files" >&2
    return 1
  fi
}

# ==============================================================================
# TEST 7: CHỐT CHẶN AN TOÀN DỮ LIỆU (CHỐNG XÓA MÙ RM -RF)
# ==============================================================================
@test "[Enterprise Gate 7] Tuyệt đối không tồn tại lệnh xóa mù 'rm -rf /\$VAR' thiếu bảo vệ" {
  _wptt_prepare_script_list
  [[ -s "$SCRIPT_LIST_FILE" ]]

  local unsafe_rm=""
  unsafe_rm="$(
    LC_ALL=C.UTF-8 timeout 10 xargs -r awk '
      {
        line = $0
        sub(/^[ \t]+/, "", line)
        if (line ~ /^#/) next

        if (line ~ /(^|[ \t;])(\/bin\/)?rm[ \t]+-[rRfF]+[ \t]+(--[ \t]+)?["\x27]?\/?\$(\{?[a-zA-Z0-9_]+\}?)\/\*/) {
          if (line !~ /:\?/ && line !~ /\/etc\/wptt\/tmp/ && line !~ /\/usr\/local\/lsws/) {
            printf "%s:%d: Cảnh báo lệnh xóa rm -rf biến gốc thiếu chốt chặn ${VAR:?} -> %s\n", FILENAME, FNR, line
          }
        }
      }
    ' <"$SCRIPT_LIST_FILE"
  )"

  if [[ -n "$unsafe_rm" ]]; then
    printf '\n[PHÁT HIỆN LỆNH RM -RF TIỀM ẨN RỦI RO]:\n%s\n' "$unsafe_rm" >&2
    return 1
  fi
}

# ==============================================================================
# TEST 8: CHỐNG RÒ RỈ TIẾN TRÌNH CON (SHLVL LEAK) TRONG HỆ THỐNG MENU (*-main)
# ==============================================================================
@test "[Enterprise Gate 8] Các file Menu (*-main) điều hướng phải dùng 'exec' để giữ SHLVL không tăng" {
  _wptt_prepare_script_list
  [[ -s "$SCRIPT_LIST_FILE" ]]

  local shlvl_leaks=""
  shlvl_leaks="$(
    LC_ALL=C.UTF-8 timeout 10 xargs -r awk '
      FNR == 1 {
        in_heredoc = 0
        h_delim = ""
        in_run_action = 0
        is_menu_file = (FILENAME ~ /(-main|\/wptangtoc|wptt-callback-menu-chon)$/)
      }
      {
        # 1. Bỏ qua nội dung nằm trong khối Heredoc (huong_dan, cat <<EOF)
        if (in_heredoc) {
          if ($0 == h_delim) in_heredoc = 0
          next
        }
        if (match($0, /<<-?[ \t]*[\x27"]?[A-Za-z0-9_]+[\x27"]?/)) {
          h_str = substr($0, RSTART, RLENGTH)
          gsub(/<<-?[ \t]*|[\x27"]/, "", h_str)
          if (h_str != "") { in_heredoc = 1; h_delim = h_str }
        }

        line = $0
        sub(/^[ \t]+/, "", line)
        if (line ~ /^#/ || line == "") next

        # Theo dõi phạm vi bên trong hàm run_action() của các file *-main
        if (line ~ /^(function[ \t]+)?run_action[ \t]*\(\)/) {
          in_run_action = 1
          next
        }
        if (in_run_action && line ~ /^\}/) {
          in_run_action = 0
        }

        # Gọt bỏ nhãn nhánh case ở đầu dòng nếu có (VD: "0) script_path=..." -> "script_path=...")
        cmd_line = line
        if (cmd_line ~ /^[a-zA-Z0-9_*|"-]+\)[ \t]+/) {
          sub(/^[a-zA-Z0-9_*|"-]+\)[ \t]+/, "", cmd_line)
        }

        # Bỏ qua mọi dòng gán biến (VD: script_path="/etc/wptt/...", local x=...)
        if (cmd_line ~ /^(local[ \t]+|export[ \t]+|declare[ \t]+)?[A-Za-z_][A-Za-z0-9_]*=/) next

        # Bỏ qua các dòng in văn bản, điều kiện if/while/case hoặc nạp thư viện (source / .)
        if (cmd_line ~ /^(echo|printf|left_text|center_text|buf_|_run|wptt_logs|if[ \t]|elif[ \t]|while[ \t]|case[ \t]|for[ \t]|\.|source[ \t])/) next

        # [LUẬT 1]: Bên trong hàm run_action() của file *-main: gọi bash "$script_path" hoặc "$script_path" mà thiếu exec
        if (is_menu_file && in_run_action) {
          if (cmd_line ~ /^(\/bin\/|\/usr\/bin\/)?bash[ \t]+/ && cmd_line !~ /^exec[ \t]+/) {
            printf "%s:%d: [SHLVL Leak] Gọi bash trong run_action() nhưng thiếu '\''exec'\'' -> %s\n", FILENAME, FNR, line
            next
          }
          if (cmd_line ~ /^"?\$(script_path|cmd_path)/ && cmd_line !~ /^exec[ \t]+/) {
            printf "%s:%d: [SHLVL Leak] Thực thi trực tiếp $script_path trong run_action() thiếu '\''exec'\'' -> %s\n", FILENAME, FNR, line
            next
          }
        }

        # [LUẬT 2]: Thực thi trực tiếp file *-main ở vị trí câu lệnh (Command Position) nhưng thiếu exec
        if (cmd_line ~ /^(((\/bin\/|\/usr\/bin\/)?(ba)?sh[ \t]+)?["\x27]?\/etc\/wptt\/([a-zA-Z0-9_-]+\/)?[a-zA-Z0-9_-]*-main)([ \t"\x27;]|$)/) {
          printf "%s:%d: [SHLVL Leak] Điều hướng về Menu *-main nhưng thiếu '\''exec'\'' -> %s\n", FILENAME, FNR, line
          next
        }

        # [LUẬT 3]: Thực thi trực tiếp /usr/bin/wptangtoc ở vị trí câu lệnh nhưng thiếu exec
        if (cmd_line ~ /^(((\/bin\/|\/usr\/bin\/)?(ba)?sh[ \t]+)?["\x27]?\/usr\/bin\/wptangtoc)([ \t"\x27;]|$)/) {
          printf "%s:%d: [SHLVL Leak] Gọi /usr/bin/wptangtoc nhưng thiếu '\''exec'\'' -> %s\n", FILENAME, FNR, line
          next
        }
      }
    ' <"$SCRIPT_LIST_FILE"
  )"

  if [[ -n "$shlvl_leaks" ]]; then
    printf '\n[PHÁT HIỆN LỖI THIẾU EXEC GÂY TĂNG SHLVL (NESTED SUBSHELL)]:\n%s\n' "$shlvl_leaks" >&2
    return 1
  fi
}
