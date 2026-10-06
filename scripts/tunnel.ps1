# Cloudflare Quick Tunnel untuk ThingsBoard
$CloudflaredBin = if (Get-Command cloudflared -ErrorAction SilentlyContinue) {
    "cloudflared"
} elseif (Test-Path "C:\Program Files (x86)\cloudflared\cloudflared.exe") {
    "C:\Program Files (x86)\cloudflared\cloudflared.exe"
} elseif (Test-Path "C:\Program Files\cloudflared\cloudflared.exe") {
    "C:\Program Files\cloudflared\cloudflared.exe"
} else {
    $null
}

if (-not $CloudflaredBin) {
    Write-Host "Error: cloudflared tidak ditemukan. Jalankan: winget install --id Cloudflare.cloudflared" -ForegroundColor Red
    exit 1
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Memulai Cloudflare Quick Tunnel untuk ThingsBoard..." -ForegroundColor Cyan
Write-Host " Target lokal: http://localhost:9090" -ForegroundColor Cyan
Write-Host " Cari URL publik 'https://xxxx.trycloudflare.com' di bawah" -ForegroundColor Yellow
Write-Host " Tekan Ctrl+C untuk menghentikan tunnel kapan saja." -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

& $CloudflaredBin tunnel --url http://localhost:9090
