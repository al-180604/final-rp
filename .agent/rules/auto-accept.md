# Auto-Accept Rules

> Các thao tác sau được coi là **an toàn** và agent PHẢI đặt `SafeToAutoRun: true` (không cần chờ user approve).

## 1) Đọc file
- Mọi lệnh đọc/xem nội dung file: `cat`, `type`, `Get-Content`, `head`, `tail`, v.v.
- Lệnh liệt kê thư mục: `ls`, `dir`, `Get-ChildItem`, `tree`.

## 2) Viết / chỉnh sửa file LaTeX
- Tạo mới hoặc ghi đè file `.tex`, `.bib`, `.sty`, `.cls`, `.latexmkrc`.
- Chỉnh sửa nội dung file LaTeX (replace/multi-replace).
- **Lưu ý**: chỉ áp dụng trong workspace LaTeX hiện tại (`d:\CODE\Latex\DATN_rp`).

## 3) Build / Compile LaTeX
- Các lệnh compile: `pdflatex`, `xelatex`, `lualatex`, `latexmk`.
- Lệnh clean build artifacts: `latexmk -c`, `latexmk -C`, hoặc script `clean.ps1`.
- Lệnh build watch: `build_watch.ps1` hoặc tương đương.

## 4) Các lệnh hỗ trợ khác (safe)
- `grep`, `rg`, `findstr`, `Select-String` — tìm kiếm trong file.
- `git status`, `git log`, `git diff` — chỉ đọc, không thay đổi state.
- `echo`, `Write-Output` — in thông tin ra console.

## 5) KHÔNG auto-accept (vẫn cần user approve)
- Lệnh xóa file/thư mục: `rm`, `del`, `Remove-Item`.
- Lệnh cài đặt package: `npm install`, `pip install`, `choco install`, v.v.
- Lệnh git write: `git commit`, `git push`, `git checkout`, `git reset`.
- Bất kỳ lệnh nào chạy ngoài workspace.
- Lệnh mạng / download: `curl`, `wget`, `Invoke-WebRequest` (trừ khi đọc doc).
