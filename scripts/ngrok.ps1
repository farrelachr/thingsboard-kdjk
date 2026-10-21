param(
    [string]$Authtoken = ""
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Memulai ngrok Tunnel untuk ThingsBoard..." -ForegroundColor Cyan
Write-Host " Target lokal: http://localhost:9090" -ForegroundColor Cyan
Write-Host " Tekan Ctrl+C untuk menghentikan kapan saja." -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

if ($Authtoken -ne "") {
    Write-Host "Menyimpan ngrok authtoken..." -ForegroundColor Yellow
    npx -y ngrok config add-authtoken $Authtoken
}

# Jalankan ngrok tunnel
npx -y ngrok http 9090
