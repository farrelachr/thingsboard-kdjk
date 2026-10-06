Write-Host "Menghentikan ThingsBoard container..." -ForegroundColor Yellow
docker compose down

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nThingsBoard berhasil dihentikan." -ForegroundColor Green
} else {
    Write-Host "`nGagal menghentikan container." -ForegroundColor Red
}
