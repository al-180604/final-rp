# QUY TẮC TRÌNH BÀY BÁO CÁO/ĐATN - HUST

> Tổng hợp quy định trình bày theo template chính thức HUST + hướng dẫn chèn hình/bảng cho Ch4–Ch5.

---

## 1) Bố cục khi đóng quyển (thứ tự phần)

* Bìa trước
* Phiếu "Đề tài tốt nghiệp" (có chữ ký GVHD) *(nếu ĐATN)*
* Lời cảm ơn + Tóm tắt (trong 1 trang; SV ký và ghi rõ họ tên)
* Mục lục
* Danh mục hình vẽ
* Danh mục bảng biểu
* Danh mục từ viết tắt *(nếu có)*
* Nội dung các chương
* Phụ lục (nếu có)
* Tài liệu tham khảo
* Bìa cuối

---

## 2) Lời cảm ơn & Tóm tắt

* **Lời cảm ơn**: tùy chọn, **100–150 từ**
* **Tóm tắt**: tối đa **300 chữ**, nêu:
  - Vấn đề cần giải quyết
  - Phương pháp thực hiện
  - Công cụ (phần mềm/phần cứng)
  - Kết quả đạt yêu cầu chưa
  - Tính thực tế & hướng mở rộng
  - Kỹ năng đạt được

---

## 3) Quy định định dạng trang và chữ

### 3.1. Khổ giấy, lề, in ấn, số trang

* Khổ giấy: **A4**
* Lề: **trên 2.5 cm**, **dưới 2 cm**, **trái 3 cm**, **phải 2 cm**
* Đánh số trang: **cuối trang, bên phải** (bottom-right)
* Nếu in 2 mặt: dùng **Mirror margins**; có thể cần chèn 1 trang trắng sau bìa để "Lời cảm ơn" rơi vào trang lẻ
* Không tẩy xoá; trình bày rõ ràng, mạch lạc
* Đóng bìa mềm theo mẫu

### 3.2. Font và cỡ chữ (Unicode)

* Nội dung: **Times New Roman 13pt**
* Đoạn văn: **justify**, dòng đầu **thụt 1 cm**, giãn dòng **1.0 line**
* Không nén/kéo giãn khoảng cách chữ

### 3.3. Đánh số chương/mục/tiểu mục

* Dùng tối đa **3 cấp tiêu đề** (ví dụ 1 / 1.1 / 1.1.1)
* Chương: 1,2,3…; **sang trang mới**, **TNR 18pt Bold**, canh giữa
* Mục: 1.1, 1.2…; **TNR 16pt Bold**, canh trái
* Tiểu mục: 1.1.1…; **TNR 14pt Bold**, canh trái
* Chỉ chia tiểu mục khi thực sự cần (tránh một mục chỉ có 1 tiểu mục)
* Nội dung các đoạn dùng đúng style và **không tự ý sửa thuộc tính style**

---

## 4) Quy tắc hình/bảng/phương trình và tham chiếu chéo

### 4.1. Hình vẽ/đồ thị

* Hình nên rộng **không quá 75%** bề rộng vùng chữ, **căn giữa**
* **Caption đặt DƯỚI hình**, căn giữa
* **Đánh số theo chương** (Hình 4.1, 4.2…)
* Cách tạo caption trong LaTeX: `\caption{...}` + `\label{fig:...}`

### 4.2. Bảng biểu

* Bảng nên rộng **không quá 75%**, và **tránh bị ngắt sang trang khác**
* **Caption đặt TRÊN bảng**
* Đánh số theo chương (Bảng 3.1, 3.2…)

### 4.3. Phương trình

* Đánh số theo chương: (4.1), (4.2)…
* Dùng environment `equation` hoặc `align`

### 4.4. Tham chiếu chéo (cross-reference)

* Có thể tham chiếu tới heading/hình/bảng/phương trình bằng `\ref{...}` để số tự cập nhật
* **Hình xuất hiện lần đầu ở đâu thì đặt ở đó**, chương sau chỉ **tham chiếu chéo**, không dán lại ảnh

### 4.5. Nguồn trích dẫn cho hình/bảng từ bên ngoài

* Nếu lấy từ nguồn khác: ghi rõ "Nguồn: …"
* Nguồn đó phải nằm trong **Danh mục tài liệu tham khảo**

---

## 5) Quy tắc viết tắt

* Không lạm dụng viết tắt
* Chỉ viết tắt các thuật ngữ lặp lại nhiều
* Lần đầu xuất hiện: viết đầy đủ + (viết tắt)
* Nếu nhiều viết tắt: làm **Danh mục từ viết tắt** (xếp ABC)

---

## 6) Phụ lục

* Chứa nội dung bổ sung minh hoạ: số liệu, mẫu biểu, ảnh, bảng dài…
* Log dài / nhiều screenshot: đưa vào **Phụ lục**, chương chính chỉ trích 1–2 hình đại diện + tham chiếu phụ lục
* Mục lục nên gọn, lý tưởng trong 1 trang (khuyến nghị)

---

## 7) Trích dẫn và tài liệu tham khảo

### 7.1. Hệ trích dẫn

* Sử dụng style **IEEE** (theo số)
* Tài liệu tham khảo là **tài liệu đã trích dẫn**, không phải "đã đọc"

### 7.2. Nguyên tắc trích dẫn

* Ghi nhận nguồn ngay khi sử dụng
* Nguồn có thể đặt đầu/giữa/cuối câu, hoặc cuối đoạn
* Có 3 kiểu:
  1. **Direct quote** (trích nguyên văn): đặt trong ngoặc kép + [số TLTK]
  2. **Indirect** (diễn giải): khuyến khích, vẫn phải [số TLTK]
  3. **Secondary** (trích thứ cấp): hạn chế, ưu tiên đọc nguồn gốc

### 7.3. Cách ghi số trích dẫn

* Trích dẫn theo số trong ngoặc vuông: `[15]`, có trang thì `[15, 314-315]`
* Nhiều tài liệu: mỗi số trong ngoặc vuông riêng, tăng dần, cách nhau dấu phẩy **không có khoảng trắng**
  Ví dụ: `[19],[25],[41]`

### 7.4. Quy tắc "đối ứng"

* Tài liệu xuất hiện trong bài → phải có trong danh mục tham khảo
* Tài liệu có trong danh mục → phải được trích trong bài
* Không trích dẫn tài liệu chưa đọc/không có trong tay
* Tránh trích chi tiết vụn vặt/ý kiến cá nhân/kiến thức phổ thông
* Khi nhiều nguồn nói giống nhau, ưu tiên nguồn uy tín trong ngành

### 7.5. Danh mục tài liệu tham khảo

* Sắp theo **thứ tự xuất hiện (được trích)**, không phân biệt ngôn ngữ
* Tài liệu tiếng nước ngoài: giữ nguyên (không phiên âm/không dịch)
* Hạn chế dùng: website, đồ án/luận án, sách giáo khoa (khuyến nghị)

---

## 8) Lưu ý phần Kết luận

* Trong phần kết luận **không nên có phương trình, biểu đồ, bảng biểu**

---

## 9) Chèn hình Chương 4 vs Chương 5 (tránh lặp)

### 9.1. Nguyên tắc tách vai trò

* **Chương 4 (Triển khai/Implementation)**: hình trả lời **"Mình đã build như thế nào?"**
  → ưu tiên **hình tĩnh (static)**: kiến trúc triển khai, mapping module–file, sequence/data-flow, ảnh UI tổng quan (1–2 ảnh là đủ)

* **Chương 5 (Kiểm thử/Evaluation)**: hình trả lời **"Build xong chạy có tốt không?"**
  → ưu tiên **bằng chứng (evidence)**: ảnh setup thí nghiệm, log/screenshot đo đạc, đồ thị theo thời gian, bảng tổng hợp metric

### 9.2. Cách tránh lặp

1. **Hình xuất hiện lần đầu ở đâu thì đặt ở đó**, chương sau chỉ **tham chiếu chéo (cross-reference)**, không dán lại ảnh
2. Nếu Ch5 cần nhắc lại bối cảnh, dùng **1 hình "topology tổng" duy nhất** (đặt ở Ch4), Ch5 chỉ "xem Hình 4.x"
3. Log dài / nhiều screenshot: đưa vào **Phụ lục**, Ch5 chỉ trích 1–2 hình đại diện + link tham chiếu phụ lục

### 9.3. Trade-off

* Ít hình ở Ch4 giúp Ch5 "đỡ đụng hàng", nhưng Ch4 phải đủ để người đọc hiểu implementation
* Đưa evidence sang phụ lục giúp báo cáo gọn, nhưng người chấm phải lật phụ lục

---

## 10) Outline đề xuất Ch4–Ch5

### Chương 4 – Triển khai (Implementation & Deployment)

* 4.6 Triển khai Dashboard
  * 4.6.1 Cấu hình Subscribe và Buffer (1 hình data-flow)
  * 4.6.2 Ma trận tính năng (1 bảng mapping "tính năng ↔ module/file")
  * 4.6.3 Cơ chế Pending → ACK Resolve (1 hình sequence/state)
* 4.7 Demo end-to-end (mô tả quy trình, *không* đưa số liệu/đồ thị)
  * 4.7.1 Điểm kiểm chứng trên MQTT (liệt kê "điểm quan sát", không kết quả)
  * 4.7.2 Kịch bản demo (1 hình flowchart)

### Chương 5 – Kiểm thử và Đánh giá (Testing & Evaluation)

* 5.1 Kế hoạch kiểm thử (Test Plan): scenarios + metrics
* 5.2 Thiết lập thí nghiệm (Experiment Setup): môi trường + tooling (1 hình setup)
* 5.3 Kết quả (Results): đồ thị theo thời gian + bảng tổng hợp (1–2 hình + 1 bảng)
* 5.4 Thảo luận (Discussion): xu hướng / nguyên nhân / hạn chế

---

## 11) Danh sách hình/bảng gợi ý

### Chương 4 (Implementation)

| # | Loại | Nội dung |
|---|------|----------|
| Hình 4.6.x | Diagram | Pipeline subscribe → buffer → UI update |
| Bảng 4.6.x | Table | Feature matrix (tính năng ↔ module/file/API) |
| Hình 4.6.x | Sequence | Pending–ACK resolve |
| Hình 4.7.x | Flowchart | Flow demo end-to-end |

### Chương 5 (Testing)

| # | Loại | Nội dung |
|---|------|----------|
| Hình 5.2.x | Photo | Setup thí nghiệm (phần cứng + PC/gateway) |
| Hình 5.3.x | Chart | Đồ thị theo thời gian (latency/success rate/packet loss) |
| Bảng 5.3.x | Table | Bảng tổng hợp metric theo scenario |

> **Nhắc lại rule hình/bảng**: rộng ≤75%, căn giữa; caption hình dưới, caption bảng trên; đánh số theo chương.

---

## 12) Checklist cuối cùng

* [ ] Có đủ: Lời cảm ơn + Tóm tắt, Mục lục, Danh mục viết tắt/bảng/hình
* [ ] A4 + lề đúng + số trang bottom-right
* [ ] TNR 13pt, justify, thụt 1cm, line 1.0
* [ ] Dùng tối đa 3 cấp heading (1 / 1.1 / 1.1.1)
* [ ] Đánh số chương/mục/tiểu mục đúng format (18pt/16pt/14pt)
* [ ] Hình/bảng đánh số theo chương; caption đúng vị trí (hình dưới, bảng trên)
* [ ] Hình/bảng rộng ≤75%, căn giữa
* [ ] Hình/bảng lấy ngoài: có "Nguồn: …" và có entry trong References
* [ ] Viết tắt: định nghĩa lần đầu + bảng viết tắt nếu nhiều
* [ ] Citation theo số IEEE: `[n]`, multi-cite: `[1],[2],[3]`
* [ ] References: chỉ gồm tài liệu đã trích; không có "tài liệu mồ côi"
* [ ] Phần Kết luận: không có phương trình/biểu đồ/bảng
* [ ] Ch4 vs Ch5: không lặp hình, dùng cross-reference
