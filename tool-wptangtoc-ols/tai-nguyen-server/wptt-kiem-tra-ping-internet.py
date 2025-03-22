import subprocess
import re
import time
import statistics
import sys

def xac_dinh_isp(ip):
    """Xác định nhà cung cấp dịch vụ (ISP) dựa trên địa chỉ IP."""
    isp_mapping = {
        "8.8.8.8": "Google",
        "1.1.1.1": "Cloudflare",
        "203.162.4.191": "VNPT",
        "203.113.131.1": "Viettel",
        "4.2.2.1": "Verizon",
    }
    return isp_mapping.get(ip, "ISP không xác định")

def kiem_tra_ping(host, so_goi_tin, khoang_cach, thoi_gian_cho):
    """
    Thực hiện kiểm tra ping đến host, trả về tỉ lệ mất gói, độ trễ, jitter.
    """
    isp = xac_dinh_isp(host)
    do_tre_cac_lan = []

    try:
        # Lệnh ping cho Linux
        lenh = ["ping", "-c", str(so_goi_tin), "-i", str(khoang_cach), "-W", str(thoi_gian_cho), host]

        # Chạy lệnh, bắt output/error
        ket_qua = subprocess.run(lenh, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=False)
        output = ket_qua.stdout.decode('utf-8', 'ignore')
        error_output = ket_qua.stderr.decode('utf-8', 'ignore')

        if ket_qua.returncode != 0:
            if "Unknown host" in output or "Name or service not known" in output or "could not find host" in output.lower():
                print(f"Lỗi: Không thể phân giải tên miền cho {host} ({isp})")
            else:
                print(f"Lỗi ping đến {host} ({isp}): {error_output}")  # Sửa ở đây
            return None, None, None

        # Trích xuất tỉ lệ mất gói
        mat_goi_tin_match = re.search(r"(\d+(\.\d+)?)% packet loss", output)
        if mat_goi_tin_match:
            ti_le_mat_goi = float(mat_goi_tin_match.group(1))
        else:
            print(f"Lỗi: Không thể trích xuất tỉ lệ mất gói cho {host} ({isp})")
            return None, None, None

        # Trích xuất độ trễ trung bình
        rtt_match = re.search(r"min/avg/max/(stddev|mdev) = (\d+(\.\d+)?)/(\d+(\.\d+)?)/(\d+(\.\d+)?)/(\d+(\.\d+)?)", output)
        if rtt_match:
            do_tre_trung_binh = float(rtt_match.group(4))
        else:
            print(f"Lỗi: Không thể trích xuất độ trễ trung bình cho {host} ({isp})")
            return None, None, None

        # Lấy các giá trị độ trễ để tính jitter
        for line in output.splitlines():
            match = re.search(r"time=([\d\.]+) ms", line)
            if match:
                do_tre_cac_lan.append(float(match.group(1)))

        # Tính jitter
        jitter = statistics.pstdev(do_tre_cac_lan) if len(do_tre_cac_lan) >= 2 else 0.0

        print(f"Kết quả ping đến {host} ({isp}):")
        print(f"  Tỉ lệ mất gói: {ti_le_mat_goi:.2f}%")
        print(f"  Độ trễ trung bình: {do_tre_trung_binh:.2f} ms")
        print(f"  Jitter: {jitter:.2f} ms")

        return ti_le_mat_goi, do_tre_trung_binh, jitter

    except FileNotFoundError:
        print("Lỗi: Không tìm thấy lệnh 'ping'. Hãy cài đặt 'ping'.")
        return None, None, None
    except Exception as e:
        print(f"Lỗi không mong đợi: {e}") # Sửa ở đây
        return None, None, None

def main():
    """Hàm chính thực hiện kiểm tra mạng."""
    cac_may_chu = ["8.8.8.8", "1.1.1.1", "203.162.4.191", "203.113.131.1", "4.2.2.1"]
    so_goi_tin_ping = 10
    khoang_cach_ping = 0.2
    thoi_gian_cho_ping = 1
    ti_le_mat_goi_toi_da = 10
    do_tre_toi_da = 200
    jitter_toi_da = 20  # Jitter tối đa
    thoi_gian_chay = 60

    print("=" * 72)
    print("| Kiểm tra độ ổn định của mạng                                    |")
    print("=" * 72)
    print(f"Chạy kiểm tra ping đến các máy chủ DNS trong {thoi_gian_chay} giây.")
    print("Kiểm tra: mất gói, độ trễ, và jitter...")

    thoi_diem_bat_dau = time.time()
    thoi_diem_ket_thuc = thoi_diem_bat_dau + thoi_gian_chay

    ket_qua_tong_hop = {host: {"mat_goi": [], "do_tre": [], "jitter": []} for host in cac_may_chu}
    so_lan_test = {host: 0 for host in cac_may_chu}

    while time.time() < thoi_diem_ket_thuc:
        for may_chu in cac_may_chu:
            ti_le_mat_goi, do_tre_trung_binh, jitter = kiem_tra_ping(may_chu, so_goi_tin_ping, khoang_cach_ping, thoi_gian_cho_ping)
            if ti_le_mat_goi is not None and do_tre_trung_binh is not None and jitter is not None:
                ket_qua_tong_hop[may_chu]["mat_goi"].append(ti_le_mat_goi)
                ket_qua_tong_hop[may_chu]["do_tre"].append(do_tre_trung_binh)
                ket_qua_tong_hop[may_chu]["jitter"].append(jitter)
                so_lan_test[may_chu] += 1
        time.sleep(1)

    print("=" * 72)
    print("--- Kết quả tổng kết ---")
    print("=" * 72)

    mang_khong_on_dinh = False # Cờ kiểm tra tổng thể

    for may_chu in cac_may_chu:
        isp = xac_dinh_isp(may_chu)
        if so_lan_test[may_chu] > 0:
            trung_binh_mat_goi = statistics.mean(ket_qua_tong_hop[may_chu]["mat_goi"])
            trung_binh_do_tre = statistics.mean(ket_qua_tong_hop[may_chu]["do_tre"])
            trung_binh_jitter = statistics.mean(ket_qua_tong_hop[may_chu]["jitter"])

            print(f"Kết quả trung bình cho {may_chu} ({isp}):")
            print(f"  Tỉ lệ mất gói trung bình: {trung_binh_mat_goi:.2f}%")
            print(f"  Độ trễ trung bình: {trung_binh_do_tre:.2f} ms")
            print(f"  Jitter trung bình: {trung_binh_jitter:.2f} ms")

            # Kiểm tra TỪNG máy chủ, nếu vượt ngưỡng thì báo không ổn định
            if trung_binh_mat_goi > ti_le_mat_goi_toi_da or trung_binh_do_tre > do_tre_toi_da or trung_binh_jitter > jitter_toi_da:
                print(f"  CẢNH BÁO: Kết nối đến {may_chu} ({isp}) có thể KHÔNG ỔN ĐỊNH.")
                mang_khong_on_dinh = True  # Bất kỳ host nào không ổn định thì mạng tổng thể cũng không ổn định
            else:
                print(f"  Kết nối đến {may_chu} ({isp}) ổn định.")
            print("-" * 25)
        else:
            print(f"Không có kết quả kiểm tra cho {may_chu} ({isp}).")
            print("-" * 25)

    # Kết luận tổng thể
    if mang_khong_on_dinh:
        print("KẾT LUẬN CHUNG: Mạng có dấu hiệu KHÔNG ỔN ĐỊNH.")
    else:
        print("KẾT LUẬN CHUNG: Mạng ỔN ĐỊNH.")

     # --- Phần thêm vào để xử lý logic từ Bash ---
    if len(sys.argv) > 1:
        check_menu_wptangtoc_active = sys.argv[1]
        if check_menu_wptangtoc_active == "98":
            try:
                subprocess.run(["/etc/wptt/wptt-tai-nguyen-main", "1"], check=True)
            except FileNotFoundError:
                print("Lỗi: Không tìm thấy file /etc/wptt/wptt-tai-nguyen-main")
            except subprocess.CalledProcessError as e:
                print(f"Lỗi khi chạy wptt-tai-nguyen-main: {e}")
            except Exception as e:
                print(f"Lỗi không xác định: {e}")

if __name__ == "__main__":
    main()
