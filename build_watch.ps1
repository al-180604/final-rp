# ============================================================
# build_watch.ps1 - Auto-build LaTeX + SyncTeX
# ============================================================
# Chuc nang:
#   1) Build pdfLaTeX voi synctex=1 (bat SyncTeX tracking)
#   2) Tu dong rebuild khi bat ky file .tex nao thay doi
#   3) Ho tro Ctrl+Click tren PDF -> nhay vao source code
#
# Cach dung:
#   .\build_watch.ps1           # Watch mode (auto-rebuild)
#   .\build_watch.ps1 -Once     # Build 1 lan roi thoat
#
# Yeu cau: pdflatex (MiKTeX), latexmk
# Tat: Ctrl+C
# ============================================================

param(
    [switch]$Once
)

$ErrorActionPreference = "Stop"

# ===== CONFIG =====
$PROJECT_DIR  = $PSScriptRoot
$MAIN_TEX     = "main.tex"
$OUT_DIR      = "build"
$PDF_FILE     = Join-Path $OUT_DIR "main.pdf"

# Tao thu muc build neu chua co
if (-not (Test-Path $OUT_DIR)) {
    New-Item -ItemType Directory -Path $OUT_DIR | Out-Null
}

# ===== FUNCTIONS =====

function Write-Header {
    param([string]$msg)
    Write-Host ""
    Write-Host ("=" * 60) -ForegroundColor DarkGray
    Write-Host "  $msg" -ForegroundColor Cyan
    Write-Host ("=" * 60) -ForegroundColor DarkGray
}

function Build-LaTeX {
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-Header "Building... [$timestamp]"
    
    $buildArgs = @(
        "-synctex=1",
        "-interaction=nonstopmode",
        "-file-line-error",
        "-output-directory=$OUT_DIR",
        $MAIN_TEX
    )
    
    # Pass 1
    Write-Host "  [1/2] pdflatex (pass 1)..." -ForegroundColor Yellow
    $stdOut1 = Join-Path $OUT_DIR "build_stdout_1.log"
    $stdErr1 = Join-Path $OUT_DIR "build_stderr_1.log"
    $proc1 = Start-Process -FilePath "pdflatex" -ArgumentList $buildArgs `
        -WorkingDirectory $PROJECT_DIR -NoNewWindow -Wait -PassThru `
        -RedirectStandardOutput $stdOut1 `
        -RedirectStandardError $stdErr1
    
    if ($proc1.ExitCode -ne 0) {
        Write-Host "  X Loi build (pass 1)! Xem log:" -ForegroundColor Red
        $logFile = Join-Path $OUT_DIR "main.log"
        if (Test-Path $logFile) {
            $errors = Select-String -Path $logFile -Pattern "^!" -Context 0,3
            if ($errors) {
                Write-Host ""
                foreach ($err in $errors) {
                    Write-Host "    $($err.Line)" -ForegroundColor Red
                    foreach ($ctx in $err.Context.PostContext) {
                        Write-Host "    $ctx" -ForegroundColor DarkRed
                    }
                }
            }
        }
        return $false
    }
    
    # Pass 2 - Update TOC, refs, bookmarks
    Write-Host "  [2/2] pdflatex (pass 2 - TOC/refs)..." -ForegroundColor Yellow
    $stdOut2 = Join-Path $OUT_DIR "build_stdout_2.log"
    $stdErr2 = Join-Path $OUT_DIR "build_stderr_2.log"
    $proc2 = Start-Process -FilePath "pdflatex" -ArgumentList $buildArgs `
        -WorkingDirectory $PROJECT_DIR -NoNewWindow -Wait -PassThru `
        -RedirectStandardOutput $stdOut2 `
        -RedirectStandardError $stdErr2
    
    if ($proc2.ExitCode -ne 0) {
        Write-Host "  X Loi build (pass 2)!" -ForegroundColor Red
        return $false
    }
    
    # Kiem tra ket qua
    if (Test-Path $PDF_FILE) {
        $pdfSizeKB = [math]::Round((Get-Item $PDF_FILE).Length / 1KB, 1)
        $syncFile = Join-Path $OUT_DIR "main.synctex.gz"
        $hasSyncTeX = Test-Path $syncFile
        
        Write-Host ""
        Write-Host "  OK Build thanh cong!" -ForegroundColor Green
        Write-Host "    PDF: $PDF_FILE ($pdfSizeKB KB)" -ForegroundColor DarkCyan
        
        if ($hasSyncTeX) {
            Write-Host "    SyncTeX: OK - San sang Ctrl+Click tren PDF" -ForegroundColor Green
        } else {
            Write-Host "    SyncTeX: MISSING - Khong tim thay .synctex.gz" -ForegroundColor Red
        }
    } else {
        Write-Host "  X Khong tim thay PDF output!" -ForegroundColor Red
        return $false
    }
    
    return $true
}

# ===== MAIN =====

# Build lan dau
$success = Build-LaTeX

if ($Once) {
    if ($success) {
        Write-Host ""
        Write-Host "  Done! (mode: build 1 lan)" -ForegroundColor Green
    }
    if ($success) { exit 0 } else { exit 1 }
}

# ===== WATCH MODE =====
Write-Header "Watch Mode - Tu dong rebuild khi thay doi file"
Write-Host "  Dang theo doi: *.tex, *.bib, *.sty, *.cls" -ForegroundColor DarkCyan
Write-Host "  Nhan Ctrl+C de dung" -ForegroundColor DarkYellow
Write-Host ""

# Tao FileSystemWatcher
$watchers = @()
$eventJobs = @()
$changeQueue = [System.Collections.Concurrent.ConcurrentQueue[string]]::new()

$watchPatterns = @("*.tex", "*.bib", "*.sty", "*.cls")

foreach ($pattern in $watchPatterns) {
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = $PROJECT_DIR
    $watcher.Filter = $pattern
    $watcher.IncludeSubdirectories = $true
    $watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite -bor [System.IO.NotifyFilters]::FileName
    $watcher.EnableRaisingEvents = $true
    
    $job = Register-ObjectEvent -InputObject $watcher -EventName "Changed" -Action {
        $Event.MessageData.Enqueue($Event.SourceEventArgs.FullPath)
    } -MessageData $changeQueue
    
    $watchers += $watcher
    $eventJobs += $job
}

# Debounce loop
$debounceMs = 800
$lastBuildTime = [DateTime]::MinValue

try {
    while ($true) {
        Start-Sleep -Milliseconds 200
        
        $changedFile = $null
        $hasChanges = $false
        
        while ($changeQueue.TryDequeue([ref]$changedFile)) {
            $hasChanges = $true
        }
        
        if ($hasChanges) {
            $elapsed = ([DateTime]::Now - $lastBuildTime).TotalMilliseconds
            if ($elapsed -lt $debounceMs) {
                continue
            }
            
            # Bo qua file trong thu muc build
            if ($changedFile -and ($changedFile -like "*\build\*")) {
                continue
            }
            
            Write-Host ""
            Write-Host "  >> File thay doi, dang rebuild..." -ForegroundColor Magenta
            
            # Doi them de file save xong
            Start-Sleep -Milliseconds 500
            
            # Drain queue
            while ($changeQueue.TryDequeue([ref]$changedFile)) { }
            
            $lastBuildTime = [DateTime]::Now
            Build-LaTeX | Out-Null
        }
    }
}
finally {
    Write-Host ""
    Write-Host "  Dang don dep..." -ForegroundColor DarkGray
    foreach ($job in $eventJobs) {
        Unregister-Event -SourceIdentifier $job.Name -ErrorAction SilentlyContinue
    }
    foreach ($watcher in $watchers) {
        $watcher.EnableRaisingEvents = $false
        $watcher.Dispose()
    }
    Write-Host "  OK Da dung watch mode." -ForegroundColor Green
}
