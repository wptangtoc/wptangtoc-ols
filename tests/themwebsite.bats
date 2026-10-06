#!/usr/bin/env bats

@test "Hộp đen: Chặn đứng Tên miền thiếu dấu chấm" {
  # Đóng vai người dùng, gọi thẳng file cài đặt thật và truyền tham số sai
  run bash tool-wptangtoc-ols/domain/wptt-themwebsite "wptangtoc"
  
  # Đo lường kết quả in ra màn hình
  [ "$status" -eq 1 ]
  [[ "$output" =~ "thiếu dấu chấm" ]]
}

@test "Hộp đen: Chặn đứng Tên miền có ký tự đặc biệt" {
  run bash tool-wptangtoc-ols/domain/wptt-themwebsite "wptangtoc@.com"
  
  [ "$status" -eq 1 ]
  [[ "$output" =~ "sai cấu trúc" ]]
}

@test "Hộp đen: Chặn đứng Domain đã tồn tại trên hệ thống" {
  # Tạo file ảo lừa script rằng domain này đã được thêm trước đó
  touch /etc/wptt/vhost/.wptangtoc.com.conf
  
  run bash tool-wptangtoc-ols/domain/wptt-themwebsite "wptangtoc.com"
  
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Tên miền đã tồn tại trên hệ thống" ]]
}
