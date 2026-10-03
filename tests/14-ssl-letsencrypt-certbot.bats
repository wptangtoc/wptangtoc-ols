#!/usr/bin/env bats

setup_file() {
  export SCRIPT_THEM="/etc/wptt/domain/wptt-themwebsite"
  export SCRIPT_XOA="/etc/wptt/domain/wptt-xoa-website"

  # Sinh domain NGẪU NHIÊN DUY NHẤT MỘT LẦN cho toàn bộ file, rồi lưu lại để
  # mọi @test và teardown_file() dùng chung chính xác một domain.
  local domain_test="ssl-ci-$(date +%s)-$$.wptangtoc.com"
  {
    echo "export SCRIPT_THEM=\"$SCRIPT_THEM\""
    echo "export SCRIPT_XOA=\"$SCRIPT_XOA\""
    echo "export DOMAIN_TEST=\"$domain_test\""
    echo "export WEBROOT_TEST=\"/usr/local/lsws/$domain_test/html\""
  } > "$BATS_FILE_TMPDIR/bien_dung_chung.sh"
}

setup() {
  # Mỗi test nạp lại ĐÚNG domain đã sinh một lần duy nhất ở setup_file().
  source "$BATS_FILE_TMPDIR/bien_dung_chung.sh"

  # Tự động bỏ qua TỪNG test nếu không có script thật (máy không phải VPS
  # WPTangToc OLS, ví dụ chạy trên GitHub-hosted runner thông thường).
  # Đặt ở setup() (không phải setup_file()) để tránh bug nêu ở LƯU Ý #2.
  if [ ! -x "$SCRIPT_THEM" ] || [ ! -x "$SCRIPT_XOA" ]; then
    skip "Cần môi trường VPS WPTangToc OLS thật (thiếu $SCRIPT_THEM hoặc $SCRIPT_XOA)"
  fi
}

# --- HÀM VŨ KHÍ GỠ LỖI ---
in_log_neu_loi() {
  local ma_ky_vong="$1"
  if [ "$status" -ne "$ma_ky_vong" ]; then
      echo -e "\n[LỖI TEST] Kịch bản không trả về mã $ma_ky_vong như kỳ vọng!" >&3
      echo "Mã trạng thái thực tế : $status" >&3
      echo -e "Nội dung in ra màn hình:\n$output" >&3
  fi
}
# -------------------------

@test "Integration: 1. Tạo Website mồi để chuẩn bị Test SSL let Encrypt" {
  run bash "$SCRIPT_THEM" "$DOMAIN_TEST"

  in_log_neu_loi 0

  # Yêu cầu thành công và thư mục webroot phải tồn tại
  [ "$status" -eq 0 ]
  [ -d "$WEBROOT_TEST" ]
}

@test "Integration: 2. Test xin cấp SSL let Encrypt (Certbot Staging Dry-run) cho Website vừa tạo" {
  # --dry-run, -staging (giả lập).
  run certbot certonly --webroot -w "$WEBROOT_TEST" -d "$DOMAIN_TEST" \
      --dry-run --staging --agree-tos --no-eff-email -m ci-test@wptangtoc.com \
      --non-interactive

  # LƯU Ý KỸ THUẬT:
  # Vì máy ảo CI GitHub không có DNS trỏ về $DOMAIN_TEST, Certbot CHẮC CHẮN SẼ BÁO LỖI.
  # Do đó, kỳ vọng lệnh này thất bại (status khác 0).
  # Nếu status = 0 (xin được SSL) ở môi trường không có DNS thì lại là chuyện vô lý.
  if [ "$status" -eq 0 ]; then
      echo -e "\n[LỖI TEST] Bất ngờ xin được SSL? (Cực kỳ bất thường trên CI)" >&3
      echo "Output: $output" >&3
  fi

  [ "$status" -ne 0 ]

  [[ "$output" =~ "Simulating a certificate request" || \
     "$output" =~ "Requesting a certificate" || \
     "$output" =~ "Performing the following challenges" || \
     "$output" =~ "Challenge failed for domain" ]]
}

@test "Integration: 3. Dọn dẹp hệ thống - Xóa Website mồi test ssl let Encrypt" {
  run bash "$SCRIPT_XOA" "$DOMAIN_TEST"

  in_log_neu_loi 0

  [ "$status" -eq 0 ]
  [ ! -d "$WEBROOT_TEST" ]
}

teardown_file() {
  # LƯỚI AN TOÀN: nếu Test 1 hoặc Test 2 fail giữa đường (ví dụ Test 3 không
  # chạy tới, hoặc DOMAIN_TEST còn sót lại do lỗi bất ngờ), vẫn phải đảm bảo
  # KHÔNG để sót website rác trên máy chủ sau khi chạy xong cả file.
  # teardown_file() của bats-core LUÔN được gọi dù test trong file có fail hay
  # không (đã verify thực tế: test fail giữa file, teardown_file vẫn chạy).
  if [ -f "$BATS_FILE_TMPDIR/bien_dung_chung.sh" ]; then
    source "$BATS_FILE_TMPDIR/bien_dung_chung.sh"
    if [ -x "$SCRIPT_XOA" ] && [ -n "$WEBROOT_TEST" ] && [ -d "$WEBROOT_TEST" ]; then
      bash "$SCRIPT_XOA" "$DOMAIN_TEST" >/dev/null 2>&1 || true
    fi
  fi
}

