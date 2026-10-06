# ThingsBoard IoT Dashboard (Docker Deployment)

Deployment lokal [ThingsBoard Community Edition](https://thingsboard.io/) menggunakan Docker Compose di Windows.

---

## Prasyarat
1. **Docker Desktop**: Pastikan Docker Desktop sudah terpasang dan dalam status **Running**.
2. **Resource**: Alokasikan minimal 4 GB RAM pada Docker Desktop (Settings -> Resources).

---

## Port Default
| Port | Protokol | Fungsi |
| :--- | :--- | :--- |
| **9090** | HTTP | Web UI Dashboard & REST API (`http://localhost:9090`) |
| **1883** | TCP | MQTT Broker (koneksi sensor / IoT hardware) |
| **5683** | UDP | CoAP Protocol |
| **7070** | TCP | Edge RPC (koneksi ThingsBoard Edge) |

*Port dapat disesuaikan pada file `.env` jika diperlukan.*

---

## Kredensial Default (Community Edition)
ThingsBoard menyediakan akun default untuk pengujian:

| Role | Username | Password |
| :--- | :--- | :--- |
| **System Administrator** | `sysadmin@thingsboard.org` | `sysadmin` |
| **Tenant Administrator** | `tenant@thingsboard.org` | `tenant` |
| **Customer User** | `customer@thingsboard.org` | `customer` |

> *Penting: Ubah password default segera setelah login pertama kali untuk keamanan.*

---

## Cara Menjalankan

### Menggunakan Skrip PowerShell
```powershell
# Jalankan container
.\scripts\start.ps1

# Hentikan container
.\scripts\stop.ps1
```

### Menggunakan Perintah Docker Compose Manual
```powershell
# 1. Jalankan container di latar belakang
docker compose up -d

# 2. Pantau log proses inisialisasi (butuh sekitar 1-2 menit pada cold start)
docker compose logs -f

# 3. Hentikan container
docker compose down
```

---

## Akses Publik (Pilih Salah Satu untuk Demo Presentasi)

### Opsi A: Cloudflare Quick Tunnel (Tanpa Password / Paling Stabil)
```powershell
.\scripts\tunnel.ps1
```
*Menghasilkan link publik acak: `https://xxxx.trycloudflare.com`.*

### Opsi B: Localtunnel (Bisa Custom Nama Subdomain Sendiri)
```powershell
.\scripts\localtunnel.ps1 -Subdomain "nama-pilihan-anda"
```
*Menghasilkan link sesuai nama yang Anda minta: `https://nama-pilihan-anda.loca.lt` (jika nama belum dipakai orang lain).*
*Catatan: Saat pertama kali dibuka di browser pengunjung, Localtunnel akan meminta "Tunnel Password". Skrip di atas sudah otomatis menampilkan password IP publik Anda di terminal.*


---

## Panduan Uji Coba Demo ESP32

Contoh sketch Arduino ESP32 tersedia di [`examples/esp32_demo/esp32_demo.ino`](./examples/esp32_demo/esp32_demo.ino).

### Langkah-langkah:
1. Buka ThingsBoard di browser (`http://localhost:9090`).
2. Login sebagai Tenant Admin (`tenant@thingsboard.org` / `tenant`).
3. Buka menu **Entities** -> **Devices** -> Klik tombol **+** (Add device) -> **Add new device**.
4. Beri nama device (misal `ESP32-Sensor`), lalu simpan.
5. Klik device yang baru dibuat, lalu salin **Device Access Token** (ada di tab Details -> *Copy access token*).
6. Buka file `examples/esp32_demo/esp32_demo.ino` di Arduino IDE:
   - Masukkan SSID & Password Wi-Fi.
   - Tempel `ACCESS_TOKEN`.
   - Atur `TB_SERVER` ke URL Quick Tunnel (`https://xxxx.trycloudflare.com`) atau IP lokal laptop (`http://192.168.x.x:9090`).
7. Upload ke ESP32.
8. Buka kembali ThingsBoard UI -> Device -> Tab **Latest telemetry** untuk melihat data `temperature` dan `humidity` masuk secara berkala.

---

## Troubleshooting
- **Error: `failed to connect to the docker API`**: Docker Desktop belum dijalankan di Windows. Buka aplikasi Docker Desktop dan tunggu hingga statusnya *Engine running*.
- **Waktu startup lama**: Pada booting pertama kali (cold start), ThingsBoard menginisialisasi database PostgreSQL dan rule chain Java, yang membutuhkan waktu sekitar 1 hingga 2 menit sebelum port 9090 merespons.

