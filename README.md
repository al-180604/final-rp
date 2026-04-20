# 📄 Báo cáo Đồ án Tốt nghiệp

**Đề tài:** Nền tảng điều phối thiết bị Smart Home dựa trên Zigbee

**Trường:** Đại học Bách khoa Hà Nội — Trường Điện-Điện tử

---

## 📖 Xem báo cáo

👉 [**Xem PDF trực tiếp trên GitHub**](build/main.pdf)

---

## 🏗️ Cấu trúc project

```
main.tex                  ← Entry point (pdfLaTeX)
sections/
  00_cover.tex            ← Trang bìa
  00a_loicamon.tex        ← Lời cảm ơn
  01_acronyms.tex         ← Danh mục viết tắt
  02_duty_roster.tex      ← Phân chia công việc
  03_modau.tex            ← Mở đầu
  04_ch1_tongquan.tex     ← Chương 1: Tổng quan & Lý thuyết
  05_ch2_thietke.tex      ← Chương 2: Thiết kế hệ thống
  06_ch3_trienkhai.tex    ← Chương 3: Triển khai hệ thống
  07_ch4_ketqua.tex       ← Chương 4: Kết quả & Đánh giá
  08_ch5_ketluan.tex      ← Chương 5: Kết luận
  09_references.tex       ← Tài liệu tham khảo
Images/                   ← Hình ảnh
build/main.pdf            ← PDF output
```

## 🔧 Build

Yêu cầu: pdfLaTeX + latexmk

```bash
latexmk -pdf -outdir=build main.tex
```
