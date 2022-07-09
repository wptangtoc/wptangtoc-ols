#!/bin/bash

echo ""
echo ""
echo ""
echo "========================================================================="
echo "|Giả lập => Nhân bản giả lập website                                     |"
echo "========================================================================="
. /etc/wptt/tenmien
echo ""
echo ""
echo "Lựa chọn website bạn muốn nhân bản giả lập: "
lua_chon_NAME

. /etc/wptt/echo-color

domain_phuc_vu="wptangtoc-ols.com"

ten_ngau_nhien=$(date +%s | sha256sum | base64 | head -c 3 ; echo)
ten_mien_random=${NAME//[-._]/$ten_ngau_nhien}
subdomain_ten_mien=$(echo $ten_mien_random | tr '[:upper:]' '[:lower:]')


ip=$(curl -s myip.directadmin.com)
if [[ "$ip" = "" ]]; then
  ip=$(curl -s ifconfig.me)
fi

_runing "Cấu hình domain giả lập ${subdomain_ten_mien}.${domain_phuc_vu}"
. /etc/wptt/gia-lap-website/cf-dns.sh -d "$domain_phuc_vu" -n "$subdomain_ten_mien" -t A -c "$ip" -p 0 -l 1 -x n >/dev/null 2>&1
_rundone "Cấu hình domain giả lập ${subdomain_ten_mien}.${domain_phuc_vu}"

_runing "Sao chép website $NAME sang website giả lập ${subdomain_ten_mien}.${domain_phuc_vu}"
. /etc/wptt/wptt-sao-chep-website $NAME ${ten_mien}.wptangtoc-ols.com >/dev/null 2>&1
_rundone "Sao chép website $NAME sang website giả lập ${subdomain_ten_mien}.${domain_phuc_vu}"


wp option set blog_public 0 --allow-root --path=/usr/local/lsws/${subdomain_ten_mien}.${domain_phuc_vu}/html >/dev/null 2>&1


check_dns=$(ping -c 1 ${subdomain_ten_mien}.${domain_phuc_vu}) 

while [ $check_dns = '' ];do
_runing "Xác thực dns domain ${subdomain_ten_mien}.${domain_phuc_vu}"
sleep 5
check_dns=$(ping -c 1 ${subdomain_ten_mien}.${domain_phuc_vu}) 
done

_rundone "Xác thực dns domain ${subdomain_ten_mien}.${domain_phuc_vu}"


_runing "Tiến hành cài SSL cho website giả lập"
wptt ssl ${subdomain_ten_mien}.wptangtoc-ols.com >/dev/null 2>&1
_rundone "Tiến hành cài SSL cho website giả lập"
echo "domain_gia_lap=1" >> /etc/wptt/vhost/.${subdomain_ten_mien}.${domain_phuc_vu}.conf
echo "==================================================================="
echo "Hoàn tất giả lập website $NAME sang ${subdomain_ten_mien}.${domain_phuc_vu}"
echo "==================================================================="
echo "truy cập: https://${subdomain_ten_mien}.${domain_phuc_vu}"
echo "Mọi tài khoản WordPress thì vẫn như domain gốc"
echo "==================================================================="

