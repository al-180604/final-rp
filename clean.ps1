# clean.ps1 - Xóa file auxiliary để build sạch khi gặp lỗi lạ
# Chạy: .\clean.ps1

$buildDir = "build"

$patterns = @(
    "*.aux", "*.bkm", "*.out", "*.toc", "*.lof", "*.lot",
    "*.log", "*.fls", "*.fdb_latexmk", "*.synctex.gz", "*.bbl", "*.blg"
)

foreach ($pattern in $patterns) {
    Remove-Item "$buildDir\$pattern" -ErrorAction SilentlyContinue
}

Write-Host "✓ Đã xóa file auxiliary trong thư mục build/" -ForegroundColor Green
Write-Host "  Bây giờ Ctrl+S để build lại từ đầu." -ForegroundColor Cyan
