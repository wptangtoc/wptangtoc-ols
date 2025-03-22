import subprocess
import re
import time
import platform
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

def kiem_tra_ping(host, so_goi_tin, thoi_gian_cho):
    """
    Thực hiện kiểm tra ping đến host và trả về tỉ lệ mất gói,
    độ trễ trung bình.  Xử lý lỗi một cách mềm dẻo.
    """
    isp = xac_dinh_isp(host)

    try:
        lenh = ["ping", "-c", str(so_goi_tin), "-W", str(thoi_gian_cho), host]


        ket_qua = subprocess.run(lenh, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=False)
        output = ket_qua.stdout.decode('utf-8', 'ignore')  # Giải mã thành chuỗi
        error_output = ket_qua.stderr.decode('utf-8', 'ignore') # Giải mã stderr

        if ket_qua.returncode != 0:
            if "Unknown host" in output or "Name or service not known" in output or "could not find host" in output.lower():
                print(f"Lỗi: Không thể phân giải tên miền cho {host} ({isp})")
            else:
                print(f"Lỗi ping đến {host} ({isp}): {error_output}")  # Hiển thị lỗi cụ thể
            return None, None


        # Trích xuất tỉ lệ mất gói tin sử dụng biểu thức chính quy
        mat_goi_tin_match = re.search(r"(\d+(\.\d+)?)% packet loss", output)
        if mat_goi_tin_match:
            ti_le_mat_goi = float(mat_goi_tin_match.group(1))
        else:
            print(f"Lỗi: Không thể trích xuất tỉ lệ mất gói cho {host} ({isp})")
            return None, None


        # Trích xuất độ trễ trung bình sử dụng biểu thức chính quy
        rtt_match = re.search(r"min/avg/max/(stddev|mdev) = (\d+(\.\d+)?)/(\d+(\.\d+)?)/(\d+(\.\d+)?)/(\d+(\.\d+)?)", output)
        if rtt_match:
             do_tre_trung_binh = float(rtt_match.group(4))  # Nhóm 4 là giá trị trung bình
        else:
            print(f"Lỗi: Không thể trích xuất độ trễ trung bình cho {host} ({isp})")
            return None, None


        print(f"Kết quả ping đến {host} ({isp}):")
        print(f"  Tỉ lệ mất gói: {ti_le_mat_goi:.2f}%")
        print(f"  Độ trễ trung bình: {do_tre_trung_binh:.2f} ms")
        return ti_le_mat_goi, do_tre_trung_binh



    except FileNotFoundError:
        print("Lỗi: Không tìm thấy lệnh 'ping'. Đảm bảo rằng nó đã được cài đặt và nằm trong PATH hệ thống của bạn.")
        return None, None
    except Exception as e:
        print(f"Một lỗi không mong đợi đã xảy ra: {e}")
        return None, None



def main():
    """Hàm chính để thực hiện kiểm tra mạng."""
    cac_may_chu = ["8.8.8.8", "1.1.1.1", "203.162.4.191", "203.113.131.1", "4.2.2.1"]
    so_goi_tin_ping = 10
    thoi_gian_cho_ping = 1
    ti_le_mat_goi_toi_da = 10
    do_tre_toi_da = 200
    thoi_gian_chay = 60

    print("=" * 72)
    print("| Kiểm tra độ ổn định của mạng                                             |")
    print("=" * 72)
    print(f"Bài kiểm tra này sẽ ping các máy chủ DNS nổi tiếng trong {thoi_gian_chay} giây.")
    print("Kiểm tra tỉ lệ mất gói và độ trễ...")

    thoi_diem_bat_dau = time.time()
    thoi_diem_ket_thuc = thoi_diem_bat_dau + thoi_gian_chay

    tong_ti_le_mat_goi = 0
    tong_do_tre = 0
    so_lan_kiem_tra = 0

    while time.time() < thoi_diem_ket_thuc:
        for may_chu in cac_may_chu:
            ti_le_mat_goi, do_tre_trung_binh = kiem_tra_ping(may_chu, so_goi_tin_ping, thoi_gian_cho_ping)
            if ti_le_mat_goi is not None and do_tre_trung_binh is not None:
                tong_ti_le_mat_goi += ti_le_mat_goi
                tong_do_tre += do_tre_trung_binh
                so_lan_kiem_tra += 1
        time.sleep(1)  # Chờ 1 giây giữa các lần lặp


    print("=" * 72)
    print("--- Kết quả tổng kết ---")
    print("=" * 72)

    if so_lan_kiem_tra > 0:
        ti_le_mat_goi_trung_binh = tong_ti_le_mat_goi / so_lan_kiem_tra
        do_tre_trung_binh = tong_do_tre / so_lan_kiem_tra

        print(f"Tỉ lệ mất gói trung bình: {ti_le_mat_goi_trung_binh:.2f}%")
        print(f"Độ trễ trung bình: {do_tre_trung_binh:.2f} ms")

        if ti_le_mat_goi_trung_binh > ti_le_mat_goi_toi_da or do_tre_trung_binh > do_tre_toi_da:
            print("CẢNH BÁO: Kết nối mạng có thể không ổn định.")
        else:
            print("Kết nối mạng ổn định.")
    else:
        print("Lỗi: Không có kết quả kiểm tra nào được thực hiện.")
        

if __name__ == "__main__":
    main()


if len(sys.argv) > 1:  # Kiểm tra xem có đối số dòng lệnh nào không
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
