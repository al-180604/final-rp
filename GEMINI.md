# GEMINI.md — Project Rules (BẮT BUỘC TUÂN THỦ)

> **MỌI AGENT** khi làm việc với dự án này **PHẢI** đọc và tuân thủ 100% các quy tắc bên dưới.
> Không được bỏ qua, không được "tóm tắt rồi bỏ". Vi phạm = output sai.

---

## Dự án

- **Loại**: Báo cáo Đồ án Tốt nghiệp (ĐATN) cử nhân — LaTeX
- **Đề tài**: Hệ thống IoT Zigbee Smart Building (thiết bị Zigbee, Gateway, Cloud Backend, API, App/Dashboard, Rule Automation)
- **Template**: HUST (Đại học Bách khoa Hà Nội)
- **Compiler**: pdfLaTeX (mặc định), xelatex nếu user yêu cầu
- **Entry point**: `main.tex`
- **Sections**: `sections/*.tex` via `\input` hoặc `\include`

---

## ⚠️ QUY TẮC BẮT BUỘC — 2 FILE GỐC

Mọi agent **PHẢI** đọc và tuân thủ **NGUYÊN VĂN** 2 file sau trước khi viết/sửa/audit bất kỳ nội dung nào trong báo cáo:

### 1. OUTLINE GUIDE (Cấu trúc đề mục)
- **File**: [`OUTLINE_GUIDE_IOT_ZIGBEE_THESIS.md`](file:///D:/CODE/Latex/DATN_rp/final-rp/OUTLINE_GUIDE_IOT_ZIGBEE_THESIS.md)
- **Nội dung**: Hướng dẫn đề mục báo cáo ĐATN — quyết định báo cáo nên có những đề mục nào, từng mục viết gì, nội dung đặt ở chương nào
- **Phạm vi áp dụng**:
  - Cấu trúc quyển theo template HUST (bìa → lời cảm ơn → tóm tắt → mục lục → danh mục → nội dung → TLTK → phụ lục)
  - Cấu trúc 6 chương: Tổng quan → Cơ sở lý thuyết → Phân tích & Thiết kế → Triển khai → Kiểm thử & Đánh giá → Kết luận & Hướng phát triển
  - Chi tiết nội dung từng chương, từng mục
  - Bảng quyết định nhanh "nội dung này đặt ở đâu?"
  - Template viết cho từng mục
  - Checklist cho Agent khi viết outline

### 2. GLOBAL REPORT RULES (Quy tắc viết)
- **File**: [`GLOBAL_REPORT_RULES_IOT_ZIGBEE.md`](file:///D:/CODE/Latex/DATN_rp/final-rp/GLOBAL_REPORT_RULES_IOT_ZIGBEE.md)
- **Nội dung**: Bộ luật cho AI Agent khi viết, sửa, audit hoặc tái cấu trúc báo cáo
- **Phạm vi áp dụng**:
  - Thứ tự ưu tiên khi xung đột: Template trường > Mentor > File rule này > Nguồn ngoài
  - Nguyên tắc cốt lõi: báo cáo phải trả lời Làm gì / Vì sao / Như thế nào / Kết quả
  - Văn phong học thuật kỹ thuật (không cảm tính, không bullet dày đặc)
  - Quy tắc thuật ngữ tiếng Anh, acronym, viết tắt
  - Quy tắc cấu trúc đoạn văn
  - Quy tắc hình vẽ, bảng, phương trình (caption, giới thiệu, diễn giải)
  - Quy tắc citation IEEE numeric
  - Quy tắc evidence/test (không bịa kết quả, thiếu thì ghi TODO)
  - Quy tắc đặt nội dung đúng chương
  - Quy tắc tách 3 lớp Device/Gateway/Cloud khi mô tả tính năng
  - Quy tắc phân biệt "thiết kế" vs "triển khai"
  - Không dùng context lỗi thời
  - Checklist audit trước khi viết
  - Checklist final trước khi nộp

---

## Quy trình bắt buộc cho Agent

1. **Trước khi viết/sửa bất kỳ section nào**: Đọc `OUTLINE_GUIDE_IOT_ZIGBEE_THESIS.md` để xác định nội dung thuộc chương nào, viết gì.
2. **Trong khi viết**: Tuân thủ `GLOBAL_REPORT_RULES_IOT_ZIGBEE.md` về văn phong, thuật ngữ, hình/bảng, citation, evidence.
3. **Sau khi viết**: Chạy checklist audit từ `GLOBAL_REPORT_RULES_IOT_ZIGBEE.md` mục 10.
4. **Không tự build LaTeX** trong chat trừ khi user yêu cầu.
5. **Không bịa dữ liệu test**, không ghi Pass khi chưa có actual output và evidence.
6. **Không đưa tính năng chưa làm thành kết quả** đã hoàn thành.

---

## Context bổ sung

- File [`CONTEXT.md`](file:///D:/CODE/Latex/DATN_rp/final-rp/CONTEXT.md) chứa context kỹ thuật chi tiết về hệ thống (codebase, architecture, MQTT contract, v.v.)
- Đọc `CONTEXT.md` khi cần hiểu chi tiết kỹ thuật để viết chính xác.

---

## Tóm tắt cho Agent

```
KHI LÀM VIỆC VỚI DỰ ÁN NÀY:
├── ĐỌC NGUYÊN VĂN: OUTLINE_GUIDE_IOT_ZIGBEE_THESIS.md
├── ĐỌC NGUYÊN VĂN: GLOBAL_REPORT_RULES_IOT_ZIGBEE.md
├── ĐỌC NẾU CẦN: CONTEXT.md
├── TUÂN THỦ: Mọi quy tắc trong 2 file trên
├── KHÔNG: Bịa dữ liệu, bỏ qua evidence, trộn chương, dùng context cũ
└── KHI XUNG ĐỘT: Template trường > Mentor > Rules file > Nguồn ngoài
```
