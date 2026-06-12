# Thesis Restructure Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Tái cấu trúc báo cáo LaTeX theo luồng Zigbee -> Gateway -> Cloud -> App, bổ sung phân quyền và test case theo thiết bị, đồng thời tách OTA khỏi phần triển khai hiện tại để đưa sang hướng phát triển.

**Architecture:** Chỉnh trực tiếp các section hiện có, không tạo chương độc lập cho App, cơ sở dữ liệu hoặc RBAC. Claim kỹ thuật lấy từ source thật; kết quả kiểm thử thiếu evidence được đánh dấu bằng `\todo{}`.

**Tech Stack:** LaTeX, pdfLaTeX, Mermaid, FastAPI, PostgreSQL, MQTT, Flutter, Zigbee.

---

### Task 1: Viết lại bảng phân chia công việc

**Files:**
- Modify: `sections/02_duty_roster.tex`

- [x] Chia bảng thành `Zigbee cục bộ` và `Cloud và lớp ứng dụng`.
- [x] Gán đầu việc cho Lê Đức Anh và Chu Thiên Phú.
- [x] Đặt caption phía trên bảng và thêm đoạn diễn giải phía dưới.

### Task 2: Chỉnh Chương 2

**Files:**
- Modify: `sections/04a_ch2_lythuyet.tex`
- Modify: `sections/01_acronyms.tex`
- Modify: `sections/09_references.tex`

- [x] Định nghĩa Smart Building ngay đầu chương.
- [x] Việt hóa tiêu đề có từ tương đương rõ ràng.
- [x] Xóa claim firmware/bootloader/OTA khỏi kiến trúc hiện tại; giữ citation cần cho hướng phát triển OTA.
- [x] Kiểm tra thuật ngữ và chữ viết tắt ở lần xuất hiện đầu tiên.

### Task 3: Sắp xếp lại Chương 3

**Files:**
- Modify: `sections/05_ch3_thietke.tex`

- [x] Đặt Gateway trước Cloud Backend.
- [x] Mở rộng phần Cloud thành API, cơ sở dữ liệu, xác thực/RBAC và phạm vi truy cập.
- [x] Giữ Mobile App ở mức vai trò, nhóm màn hình và luồng gọi API.
- [x] Đổi các tiêu đề tiếng Anh không cần thiết sang tiếng Việt.

### Task 4: Viết lại hướng trình bày Chương 4

**Files:**
- Modify: `sections/06_ch4_trienkhai.tex`

- [x] Đổi phần mở đầu sang mô hình mục tiêu -> đầu vào -> xử lý -> đầu ra -> kiểm tra.
- [x] Mở rộng triển khai Cloud Backend, cơ sở dữ liệu và phân quyền.
- [x] Mở rộng triển khai Mobile App theo nhóm chức năng.
- [x] Xóa claim OTA khỏi triển khai hiện tại và biểu đồ sản phẩm hóa.

### Task 5: Tái cấu trúc Chương 5

**Files:**
- Modify: `sections/07_ch5_ketqua.tex`

- [x] Thêm ma trận test theo Coordinator/NCP, đèn, công tắc và cảm biến chuyển động.
- [x] Thêm test Cloud/Mobile/RBAC/automation/reconnect.
- [x] Giữ actual output, result và evidence ở dạng `\todo{}` khi chưa có bằng chứng.
- [x] Đặt một ghi chú ngắn về OTA ngoài phạm vi kiểm thử hiện tại.

### Task 6: Chốt phạm vi tương lai và bổ sung công cụ quản lý

**Files:**
- Modify: `sections/04_ch1_tongquan.tex`
- Modify: `sections/08_ch6_ketluan.tex`
- Modify: `sections/01_acronyms.tex`
- Modify: `sections/09_references.tex`
- Modify: `sections/06_ch4_trienkhai.tex`

- [x] Đưa OTA sang Chương 6 như hướng phát triển, đồng thời nêu các vai trò RBAC và node chấp hành cần bổ sung.
- [x] Bổ sung Jira, Git và GitHub đúng vai trò.
- [x] Kiểm tra không còn claim OTA đã được triển khai trong báo cáo.

### Task 7: Audit và build

**Files:**
- Verify: `main.tex`
- Verify: `build/main.log`
- Verify: `build/main.pdf`

- [x] Quét heading, thuật ngữ, caption, citation, TODO và OTA.
- [x] Chạy `.\build_watch.ps1 -Once`.
- [x] Sửa lỗi LaTeX, reference và bảng tràn trang.
- [x] Build lại và xác nhận không có lỗi bắt đầu bằng `!`.
