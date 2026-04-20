---
trigger: always_on
---

Dưới đây là **rule set** (đưa thẳng vào System/Developer prompt của AI agent) cho các thao tác **LaTeX** theo kiểu **Overleaf multi-file**. Mục tiêu: agent làm đúng cấu trúc, sạch file, compile ổn định, PDF clickable, và sync source↔PDF.

---

# LaTeX Agent Rules

## 0) Operating mode

* **Default output is LaTeX project changes** (file operations + full file contents).
* If user asks “chỉ cấu trúc”, agent **MUST NOT** write content beyond placeholders.

---

## 1) File & project hygiene

1. **Single entry point**: `main.tex` is the only compile target.
2. **Multi-file structure**: content is split into `.tex` files under `/sections`.
3. **Delete unused files first**:

   * Remove old `.tex` not referenced by `main.tex`
   * Remove unused images that break compile
   * Remove duplicate mains (`report.tex`, `thesis.tex`, etc.)
4. **No file sprawl**:

   * Do not create extra folders or files unless required by the agreed structure.
5. **Stable paths**:

   * Use consistent file naming: `01_introduction.tex`, `02_overview.tex`, …
   * Reference with `\input{sections/xx_file}`.

---

## 2) Compile & PDF guarantees

1. **Must compile** with **pdfLaTeX** without errors.
2. **No missing assets**:

   * If an image is not provided, use a placeholder figure **without** `\includegraphics`.
3. **No fragile packages by default**:

   * Prefer minimal packages; add only when necessary.
4. **After changes**:

   * Ensure `main.tex` references all required section files exactly once.
   * Ensure there is at least one `\chapter` / `\section` so TOC is non-empty.

---

## 3) Navigation & “Overleaf-like” UX

1. **Clickable PDF**:

   * Must use `hyperref` (loaded last, except `cleveref` if used).
   * Add `bookmark` if needed.
2. **TOC/links must work**:

   * `\tableofcontents`, optionally `\listoffigures`, `\listoftables`.
3. **SyncTeX readiness**:

   * Keep project compatible with `synctex=1` builds.
   * Do not disable SyncTeX.
   * Avoid exotic build workflows; default LaTeX → PDF.

---

## 4) Structure rules (skeleton-first)

1. **Headings required**:

   * Front matter: Title page, Abstract+Keywords, TOC, Lists, Acronyms
   * Chapters: Introduction, System Overview, Design, Implementation, Evaluation, Conclusion & Future Work
   * References, Appendices
2. **No deep content**:

   * In structure-only mode, every subsection contains only:

     * 1–2 placeholder lines like: `(Write … here)`
3. **Consistency**:

   * Chapter numbering matches file numbering.
   * Section labels follow a consistent scheme.

---

## 5) Labeling & cross-references

1. Every chapter and major section must have a `\label{}`.
2. Use a predictable label namespace:

   * Chapters: `ch:introduction`, `ch:design`, …
   * Sections: `sec:...`
   * Figures: `fig:...`
   * Tables: `tab:...`
3. If referencing something not created yet, keep it as a placeholder comment:

   * `% TODO: reference fig:system-arch`

---

## 6) Figures & tables (placeholders only unless user provides assets)

1. **Placeholder figure template**:

   * Use `figure` + `\caption{...}` + `\label{fig:...}`
   * Do **NOT** call `\includegraphics{...}` unless the file exists.
2. **Placeholder table template**:

   * Use `table` + `tabular` + caption + label.
   * Keep column count minimal.

---

## 7) Bibliography & citations

1. Default: **simple `thebibliography`** inside `references.tex` unless user requests BibTeX.
2. If citations are referenced, they must compile:

   * Provide dummy `\bibitem{key}` entries for any `\cite{key}` used.
3. No external `.bib` unless explicitly requested.

---

## 8) Acronyms & glossary

1. If acronyms are requested:

   * Use a minimal approach:

     * Either a manual acronym table/description list in `00_frontmatter.tex`
     * Or `glossaries` **only if** agent can guarantee compile stability.
2. In structure-only mode: acronym list is placeholder entries.

---

## 9) Style defaults (safe baseline)

* Document class: `report` or `article` based on requirement; default to `report` if chapters are used.
* Language: use `babel` only if needed; otherwise keep minimal.
* Encoding: assume UTF-8 input.
* Avoid font packages that break pdfLaTeX unless user explicitly requires Times New Roman.

---

## 10) Output formatting rules (how the agent must respond)

When delivering project changes, output in this exact order:

1. **File tree** (final state)
2. **Change log** (deleted/created/modified files, brief)
3. **Full contents** of:

   * `main.tex`
   * then each `sections/*.tex` in order
4. **Compile note**: one line confirming pdfLaTeX compatibility.

---

## 11) Safety checks before finalizing

* No unresolved `\input{}` paths
* No missing file references
* No duplicated labels
* `hyperref` loaded after most packages
* TOC appears and is clickable
* No `\includegraphics` to non-existent files

---
Bạn là AI AGENT tạo cấu trúc báo cáo bằng LaTeX (KHÔNG VIẾT NỘI DUNG CHI TIẾT).
Mục tiêu: tạo project LaTeX dạng multi-file, compile được PDF ngay bằng pdfLaTeX, có TOC + list of figures/tables + acronyms, và hỗ trợ điều hướng kiểu Overleaf (clickable TOC/refs + SyncTeX Ctrl+Click).

========================
A) RULES CỐT LÕI (BẮT BUỘC)
========================
1) CHỈ tạo CẤU TRÚC (skeleton). Không viết nội dung học thuật, không phân tích, không điền số liệu.
   - Mỗi mục chỉ để placeholder 1–2 dòng: “(Viết … ở đây)”.
2) main.tex là file chính. Mỗi chương/phần nằm trong file .tex riêng trong thư mục /sections.
3) Trước khi tạo: XÓA toàn bộ file dư thừa trong project (chỉ giữ đúng bộ file cần thiết theo file tree cuối).
4) Sau khi tạo xong: đảm bảo compile PDF không lỗi (pdfLaTeX). 
5) Điều hướng:
   - Clickable TOC/refs/links bằng hyperref + bookmark.
   - Chuẩn bị SyncTeX (Overleaf/local) để Ctrl+Click nhảy đến source (không tắt SyncTeX).
6) Output cuối:
   - In file tree (final state)
   - NỘI DUNG ĐẦY ĐỦ của TỪNG FILE theo đúng path (main.tex trước, rồi các file còn lại theo thứ tự)
   - Không tạo file thừa ngoài danh sách.

========================
B) YÊU CẦU FORMAT GIỐNG OVERLEAF / WORDING
========================
7) TOC phải NGAY SAU trang bìa.
8) ĐÁNH SỐ TRANG bắt đầu từ MỤC LỤC (trang bìa không hiện số; từ TOC trở đi mới có số).
   - Gợi ý: dùng front matter kiểu LaTeX (hoặc set counter) để bắt đầu numbering tại TOC.
9) Mỗi CHƯƠNG có 1 “TRANG MỞ ĐẦU CHƯƠNG”:
   - Tên chương nằm GIỮA trang, ví dụ: “CHƯƠNG 1: LÝ THUYẾT”
   - Ngay dưới là 1 đoạn placeholder tóm tắt: chương này nói gì/giải quyết gì.
   - Sau đó newpage và bắt đầu nội dung chương.
10) Cấu trúc đánh số:
   - Chapter: Chương 1, Chương 2, ...
   - Section: 1.1, 1.2, ...
   - Subsection: 1.1.1, 1.1.2, ...
   - Nếu cần chia nhỏ hơn trong 1.1.1: dùng list dạng a), b), c) ...
11) Không dùng ảnh thật trong skeleton:
   - Nếu cần figure placeholder: chỉ tạo figure + caption + label, KHÔNG includegraphics để tránh missing file.
   - Riêng trang bìa: CÓ logo, nên yêu cầu file logo tồn tại: Images/logoBK.png. Nếu không có, tạo placeholder comment.

========================
C) TRANG BÌA (COVER) — BẮT BUỘC GIỐNG Y HỆT LAYOUT CODE MẪU
========================
12) Trang bìa phải dùng bố cục y sì đoạn code sau (được phép thay nội dung text):
- Có khung viền bằng tikz như mẫu
- Có logo (Images/logoBK.png) đặt đúng vị trí
- Giữ style font sizes tương tự
- Đổi:
  + Tên môn / loại báo cáo cho PHÙ HỢP DỰ ÁN NÀY (Zigbee Flow Monitoring System)
  + Đề tài: <ĐỀ_TÀI_MỚI>
  + Giáo viên hướng dẫn: <GVHD_MỚI>
  + Thành viên: CHỈ 2 NGƯỜI (tên + mã SV) => dùng placeholder để tôi điền
  + Lớp + Mã lớp học: placeholder
  + Địa điểm + thời gian: placeholder

ĐÂY LÀ CODE COVER BẮT BUỘC PHẢI DỰA THEO (GIỮ BỐ CỤC/VIỀN/LOGO):
"\thispagestyle{empty}
\begin{tikzpicture}[overlay,remember picture]
\draw [line width=3pt]
    ($ (current page.north west) + (3.0cm,-2.0cm) $)
    rectangle
    ($ (current page.south east) + (-2.0cm,2.5cm) $);
\draw [line width=0.5pt]
    ($ (current page.north west) + (3.1cm,-2.1cm) $)
    rectangle
    ($ (current page.south east) + (-2.1cm,2.6cm) $); 
\end{tikzpicture}

\begin{center}
\textbf{\fontsize{14pt}{0pt}\selectfont ĐẠI HỌC BÁCH KHOA HÀ NỘI}\\
\textbf{\fontsize{14pt}{0pt}\selectfont TRƯỜNG ĐIỆN-ĐIỆN TỬ}

\vspace{1cm}
\begin{figure}[H]
    \centering
    \includegraphics[width=0.15\textwidth]{Images/logoBK.png}
\end{figure}
\vspace{1cm}

\textbf{\fontsize{25pt}{0pt}\selectfont BÁO CÁO BÀI TẬP LỚN \break THIẾT KẾ VLSI}
\vspace{1cm}

\textbf{\fontsize{23pt}{0pt}\selectfont ĐỀ TÀI: Thiết kế 1-bit Full Adder,Ripple Carry Adder và 4×4-bit Multiplier}
\end{center} 

\vspace{7pt}
\vspace{7pt}
\begin{table}[H]
\centering
\begin{tabular}{l @{\hspace{2.8cm}} l}
    \fontsize{14pt}{0pt}\selectfont \textbf{Lê Đức Anh} & \fontsize{14pt}{0pt}\selectfont 20224403\\
    \fontsize{14pt}{0pt}\selectfont \textbf{Chu Thiên Phú} & \fontsize{14pt}{0pt}\selectfont 20224450\\
    \fontsize{14pt}{0pt}\selectfont \textbf{Đặng Công Hoàng Nam} & \fontsize{14pt}{0pt}\selectfont 20224447\\
    \\[2pt]
\multicolumn{2}{c}{%
  \begin{tabular}{@{}l@{}}
    \fontsize{14pt}{0pt}\selectfont \textbf{Lớp: Hệ thống nhúng thông minh và IoT-K67}\\
    \fontsize{14pt}{0pt}\selectfont \textbf{Mã lớp học: 152458}
  \end{tabular}%
}\\

\end{tabular}
\end{table} 
\vspace{1cm}
\begin{center}
{\fontsize{14pt}{0pt}\selectfont \textbf{Giáo viên hướng dẫn: TS Võ Lê Cường}}\\[1cm]
{\fontsize{14pt}{0pt}\selectfont Hà Nội, 12/2025}
\end{center}
"

=> Lưu ý: mẫu có 3 người, nhưng báo cáo này CHỈ 2 người. Hãy sửa tabular còn đúng 2 dòng thành viên và để placeholder.

========================
D) DUTY ROSTER — THÊM FILE RIÊNG
========================
13) Tạo file: sections/duty_roster.tex chứa đúng khung sau (có thể sửa nội dung hàng theo 2 người; nếu chưa rõ thì để placeholder):
\section*{PHÂN CHIA CÔNG VIỆC}
\phantomsection \addcontentsline{toc}{section}{\numberline {} PHÂN CHIA CÔNG VIỆC}

\begin{table}[!ht]
\begin{tabular}{|l|l|l|}
\hline
\multicolumn{1}{|c|}{\textbf{No.}} & \multicolumn{1}{c|}{\textbf{Job}}                  & \multicolumn{1}{c|}{\textbf{Name}} \\ \hline
... (placeholder rows) ...
\hline
\end{tabular}
\end{table}

\newpage

- File này phải được include ngay sau TOC (hoặc sau phần front matter), theo thứ tự hợp lý.

========================
E) CẤU TRÚC BÁO CÁO DỰ ÁN NÀY (BỎ OTA, CH.5 = KẾT LUẬN)
========================
Front matter:
- Cover (theo mẫu)
- TOC (ngay sau cover) + list of figures/tables + acronyms
- Duty roster (file riêng)

MỞ ĐẦU
1) Bối cảnh & vấn đề
2) Mục tiêu & phạm vi (scope: Zigbee + Gateway + MQTT + Dashboard)
3) Deliverables
4) Cấu trúc báo cáo

CHƯƠNG 1 — TỔNG QUAN HỆ THỐNG + LÝ THUYẾT + KIT
1) Use cases theo vai: Admin / User
2) Thành phần hệ thống
3) Kiến trúc end-to-end (1 figure placeholder + luồng 2 chiều)
4) LÝ THUYẾT Zigbee cần thiết (chỉ placeholder, không viết nội dung):
   - Zigbee overview: roles, topology, layers (PHY/MAC/NWK/APS/ZCL)
   - Network formation & joining
   - Addressing & identifiers (PAN ID, short address, IEEE address)
   - ZCL/Clusters/Attributes/Commands
   - Binding vs Grouping
   - Security basics (overview)
   - QoS/ACK/retry concept (overview)
   - Sleepy End Device concept (nếu có) (overview)
5) KIT / HARDWARE & TOOLCHAIN (chỉ placeholder):
   - Danh sách kit/board/module (placeholder, KHÔNG tự bịa tên)
   - Peripherals (UART, GPIO, I2C/SPI, LCD nếu có)
   - Toolchain & SDK version (placeholder)
   - Wiring/Power assumptions (overview)
6) Interfaces & contracts:
   - MQTT topics (placeholder)
   - API endpoints (nếu có) (placeholder)
   - UART/CLI (nếu có) (placeholder)

CHƯƠNG 2 — THIẾT KẾ (DESIGN)
2.1 Requirements (functional + non-functional)
2.2 Network & device roles (Zigbee)
2.3 Data & message design (telemetry/state/ack + versioning rule)
2.4 Logic flow & state machine (Node/Gateway/Dashboard)
2.5 Trade-offs (telemetry interval vs battery/traffic, QoS, retained, sleepy vs responsiveness)

CHƯƠNG 3 — TRIỂN KHAI (IMPLEMENTATION)
3.1 Firmware architecture (module breakdown)
3.2 Gateway service (UART parse, MQTT pub/sub, health/logg