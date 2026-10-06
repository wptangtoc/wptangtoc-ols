# 🛡️ Chính Sách Bảo Mật (Security Policy) - WPTangToc OLS

Cảm ơn bạn đã quan tâm đến việc đóng góp và bảo vệ sự an toàn của dự án **WPTangToc OLS**. Quản trị máy chủ là một công việc đòi hỏi mức độ bảo mật cao nhất, vì vậy chúng tôi cực kỳ trân trọng những báo cáo từ cộng đồng bảo mật và người dùng.

## 📌 Các Phiên Bản Được Hỗ Trợ (Supported Versions)

Chúng tôi chỉ cung cấp các bản vá bảo mật cho những phiên bản mới nhất đang được hỗ trợ. Huớng cập nhật của wptangtoc ols lên theo huớng cuốn chiếu.
Vui lòng thường xuyên cập nhật WPTangToc OLS trên máy chủ của bạn để đảm bảo an toàn.

| Phiên bản (Version) | Trạng thái hỗ trợ bảo mật |
| :--- | :--- |
| **Bản mới nhất (Latest/Main)** | : Được hỗ trợ |

*Lưu ý: Bạn có thể cập nhật script lên phiên bản mới nhất bằng cách chạy tính năng Cập nhật ngay trong menu của WPTangToc OLS.*

## 🚨 Hướng Dẫn Báo Cáo Lỗ Hổng Bảo Mật (Reporting a Vulnerability)

**VUI LÒNG KHÔNG TẠO GITHUB ISSUES CÔNG KHAI CHO CÁC LỖ HỔNG BẢO MẬT.** 

Việc công khai lỗ hổng trước khi có bản vá có thể gây nguy hiểm cho hàng ngàn máy chủ đang sử dụng WPTangToc OLS. Thay vào đó, vui lòng báo cáo riêng tư cho chúng tôi qua email:

*   **Email liên hệ:** [giatuan@wptangtoc.com](mailto:giatuan@wptangtoc.com)
*   **Tiêu đề thư:** `[Security WPTangToc OLS] - <Tóm tắt ngắn gọn lỗ hổng>`
Hoặc
*   ** Liên hệ trao đổi trực tiếp:** tiếp qua Zalo 0866880462 (Gia Tuấn)

### 📝 Thông tin cần có trong báo cáo của bạn:
Để chúng tôi có thể tái tạo và khắc phục vấn đề nhanh nhất, vui lòng cung cấp:
1.  **Loại lỗ hổng:** (VD: SQL Injection, Command Injection, Privilege Escalation, Path Traversal...).
2.  **Môi trường tái tạo:** Hệ điều hành (Ubuntu/AlmaLinux/Rocky), phiên bản Bash, phiên bản OpenLiteSpeed.
3.  **Chi tiết các bước tái tạo (Steps to reproduce):** Từng bước cụ thể để kích hoạt lỗ hổng. Bạn có thể đính kèm video, ảnh chụp màn hình hoặc mã khai thác (PoC - Proof of Concept).
4.  **Tác động dự kiến:** Lỗ hổng này có thể gây ra hậu quả gì cho máy chủ?

### ⏱️ Thời gian phản hồi dự kiến:
*   Chúng tôi sẽ xác nhận việc nhận được báo cáo của bạn trong vòng **48 giờ**.
*   Sau khi xác minh lỗ hổng, chúng tôi sẽ cung cấp tiến độ dự kiến để tung ra bản vá.
*   Khi bản vá được phát hành, chúng tôi sẽ vinh danh bạn (nếu bạn đồng ý) trong phần Release Notes.

## 🔍 Phạm Vi Bảo Mật (Scope)

### ✅ Thuộc phạm vi xử lý của chúng tôi (In Scope):
*   Các lỗi bảo mật xuất phát trực tiếp từ mã nguồn Bash Script của `WPTangToc OLS` (Command Injection,  rò rỉ dữ liệu qua file log...).
*   Các file cấu hình mặc định (vhost, PHP, MariaDB, Fail2ban) do script tự động sinh ra có cấu hình sai dẫn đến nguy cơ bảo mật.

### ❌ Không thuộc phạm vi xử lý (Out of Scope):
*   Lỗ hổng bảo mật lõi (Core vulnerabilities) của phần mềm bên thứ 3 như **OpenLiteSpeed**, **MariaDB**, **PHP**, hay **WordPress**. (Vui lòng báo cáo trực tiếp cho các nhà phát triển tương ứng).
*   Lỗi bảo mật do người dùng tự thay đổi cấu hình sai, hoặc do cài đặt Plugin/Theme WordPress null nhiễm mã độc.
*   Các báo cáo quét tự động (Automated scanner reports) không có bằng chứng khai thác thực tế (PoC).

## 🛡️ Miễn Trừ Trách Nhiệm (Disclaimer)
**WPTangToc OLS** được cung cấp dưới dạng mã nguồn mở "NGUYÊN BẢN" (AS-IS) và không có bất kỳ hình thức bảo hành nào. Các tệp script này thực thi bằng quyền `root`, do đó người quản trị máy chủ (Sysadmin) phải chịu trách nhiệm hoàn toàn về dữ liệu và an toàn của hệ thống. Chúng tôi luôn khuyến nghị bạn thực hiện **Sao lưu (Backup) toàn bộ hệ thống** trước khi chạy bất kỳ công cụ can thiệp hệ thống nào.
