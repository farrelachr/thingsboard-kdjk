if (-not (Test-Path ".env") -and (Test-Path ".env.example")) {
    Copy-Item ".env.example" ".env"
    Write-Host "File .env otomatis dibuat dari .env.example" -ForegroundColor DarkGray
}

Write-Host "Memulai ThingsBoard container..." -ForegroundColor Cyan
docker compose up -d

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nThingsBoard berhasil dijalankan di latar belakang!" -ForegroundColor Green
    Write-Host "Akses Web UI di: http://localhost:9090 (tunggu 1-2 menit hingga proses inisialisasi selesai)" -ForegroundColor Cyan
    Write-Host "Untuk memantau log, jalankan: docker compose logs -f" -ForegroundColor Yellow
} else {
    Write-Host "`nGagal menjalankan ThingsBoard. Pastikan Docker Desktop sudah aktif." -ForegroundColor Red
}
