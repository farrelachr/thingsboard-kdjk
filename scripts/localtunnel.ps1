param(
    [string]$Subdomain = "tb-iot-demo"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Memulai Localtunnel untuk ThingsBoard..." -ForegroundColor Cyan
Write-Host " Target lokal: http://localhost:9090" -ForegroundColor Cyan
Write-Host " Subdomain diminta: $Subdomain" -ForegroundColor Yellow
Write-Host " Tekan Ctrl+C untuk menghentikan kapan saja." -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

# Dapatkan IP Publik (dibutuhkan jika muncul halaman reminder localtunnel di browser)
try {
    $TunnelPassword = (Invoke-WebRequest -Uri "https://loca.lt/mytunnelpassword" -UseBasicParsing -TimeoutSec 3).Content.Trim()
    Write-Host "[Catatan Penting]" -ForegroundColor Magenta
    Write-Host "Jika browser meminta 'Tunnel Password', masukkan IP ini:" -ForegroundColor White
    Write-Host ">>> $TunnelPassword <<<" -ForegroundColor Green
    Write-Host ""
} catch {
    # Abaikan jika timeout
}

npx -y localtunnel --port 9090 --subdomain $Subdomain
