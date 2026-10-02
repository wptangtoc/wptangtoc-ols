#!/usr/bin/env bats

# =================================================================
# KHỞI TẠO & DỌN DẸP MÔI TRƯỜNG (CHẠY TRƯỚC VÀ SAU MỖI BÀI TEST)
# =================================================================
setup() {
  export SCRIPT_GOC="/etc/wptt/wptt-update"
  export CI="true"
 
  # 1. SAO LƯU FILE GỐC (Bảo vệ dữ liệu thật)
  cp /etc/wptt/.wptt.conf /tmp/wptt.conf.bak 2>/dev/null || true
  cp /etc/wptt/core-functions /tmp/core-functions.bak 2>/dev/null || true
  
  # 2. VÔ HIỆU HÓA LỆNH EXEC CUỐI FILE
  # Lệnh exec sẽ giết chết tiến trình BATS, ta phải đánh tráo wptt-status2 thành 1 file rỗng tạm thời
  mv /etc/wptt/wptt-status2 /tmp/wptt-status2.bak 2>/dev/null || true
  echo '#!/bin/bash' > /etc/wptt/wptt-status2
  echo 'exit 0' >> /etc/wptt/wptt-status2
  chmod +x /etc/wptt/wptt-status2
}

teardown() {
  # 3. KHÔI PHỤC NGUYÊN TRẠNG SAU KHI TEST XONG
  mv /tmp/wptt.conf.bak /etc/wptt/.wptt.conf 2>/dev/null || true
  mv /tmp/core-functions.bak /etc/wptt/core-functions 2>/dev/null || true
  mv /tmp/wptt-status2.bak /etc/wptt/wptt-status2 2>/dev/null || true
  
  # Tháo bỏ hệ điều hành giả (nếu có) ở bài test CentOS 7
  if mountpoint -q /etc/os-release; then
    umount /etc/os-release || true
  fi
}

# =================================================================
# CÁC BÀI TEST TÍCH HỢP
# =================================================================


@test "Integration: Báo thành công khi Đang ở Phiên bản Mới nhất" {
  # Lấy phiên bản mới nhất từ server gốc để làm mồi nhử
  local LATEST_VERSION=$(curl -sL https://wptangtoc.com/share/version-wptangtoc-ols.txt | head -n 1)
  
  # Ép config máy chủ cục bộ bằng đúng version mới nhất
  echo "version_wptangtoc_ols=$LATEST_VERSION" > /etc/wptt/.wptt.conf

  run bash "$SCRIPT_GOC"
  
  # Kịch bản phải chạy qua êm ru (mã 0) và báo đã là mới nhất
  [ "$status" -eq 0 ]
  [[ "$output" =~ "BẠN ĐANG SỬ DỤNG PHIÊN BẢN MỚI NHẤT" ]]
}

@test "Integration: Hủy cập nhật khi người dùng chọn 'Để sau'" {
  echo "version_wptangtoc_ols=0.0.1" > /etc/wptt/.wptt.conf

  # MOCKING PROXY: Ghi đè file, tải lại file backup và chèn hàm giả (Trả về 1 = Từ chối)
  cat << 'EOF' > /etc/wptt/core-functions
source /tmp/core-functions.bak
wptt_xac_nhan() { return 1; }
EOF

  # Ép đóng băng STDIN (</dev/null) để nếu có lệnh read nào lọt lưới, nó sẽ văng lỗi ngay chứ không bị treo
  run bash -c "bash $SCRIPT_GOC < /dev/null"

  [ "$status" -eq 0 ]
  [[ "$output" =~ "Đã hủy thao tác cập nhật" ]]
}

@test "Integration: TIẾN HÀNH CẬP NHẬT & XÁC THỰC GPG THÀNH CÔNG" {
  echo "version_wptangtoc_ols=0.0.1" > /etc/wptt/.wptt.conf

  # MOCKING PROXY: Chèn hàm giả (Trả về 0 = Đồng ý)
  cat << 'EOF' > /etc/wptt/core-functions
source /tmp/core-functions.bak
wptt_xac_nhan() { return 0; }
EOF

  # Đóng STDIN để chống treo
  run bash -c "bash $SCRIPT_GOC < /dev/null"

  [ "$status" -eq 0 ]
  [[ "$output" =~ "Xác thực GPG Thành Công" ]]
  [[ "$output" =~ "WPTangToc OLS đã cập nhật Hệ thống lên bản" ]]
}
