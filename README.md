<h1 align="center">
  <img src="./images/thingsboard-logo.png" alt="ThingsBoard Logo" width="480" style="margin-bottom: 1.5rem;"/>
</h1>

<div align="center">
  <h1>Aplikasi ThingsBoard (IoT Platform)</h1>
  <p>Projek Akhir Praktikum Komunikasi Data dan Jaringan Komputer (KDJK)</p>
  <p>Disusun oleh:</p>
  <table align="center" style="margin-top: 1rem; text-align: left; border-collapse: collapse;">
    <tr>
      <th style="padding: 6px 16px; border-bottom: 2px solid #ccc;">Nama</th>
      <th style="padding: 6px 16px; border-bottom: 2px solid #ccc;">NIM</th>
    </tr>
    <tr>
      <td style="padding: 6px 16px; font-weight: bold;">Apta Adi Nur Fiansah</td>
      <td style="padding: 6px 16px;">M0403241003</td>
    </tr>
    <tr>
      <td style="padding: 6px 16px; font-weight: bold;">Candra Agung Alief Prasetyo</td>
      <td style="padding: 6px 16px;">M0403241006</td>
    </tr>
    <tr>
      <td style="padding: 6px 16px; font-weight: bold;">Muhammad Hikmal Fadhil Agis</td>
      <td style="padding: 6px 16px;">M0403241014</td>
    </tr>
    <tr>
      <td style="padding: 6px 16px; font-weight: bold;">Muhammad Farrel Alfachrezi</td>
      <td style="padding: 6px 16px;">M0403241015</td>
    </tr>
    <tr>
      <td style="padding: 6px 16px; font-weight: bold;">Raihanah Azka Zhafira</td>
      <td style="padding: 6px 16px;">M0403241016</td>
    </tr>
  </table>
  <br>
</div>

<div align="center">

[Sekilas Tentang](#sekilas-tentang) | [Instalasi](#instalasi) | [Konfigurasi](#konfigurasi) | [Maintenance](#maintenance) | [Otomatisasi](#otomatisasi) | [Cara Pemakaian](#cara-pemakaian) | [Pembahasan](#pembahasan) | [Referensi](#referensi)

</div>

---

# Sekilas Tentang
[`^ kembali ke atas ^`](#)

**ThingsBoard** adalah platform IoT (*Internet of Things*) *open-source* berbasis web yang digunakan untuk pengumpulan data telemetri, pemrosesan dan visualisasi data, serta manajemen perangkat (*device management*) secara terpusat. Dikembangkan oleh ThingsBoard, Inc., platform ini dirancang dengan skalabilitas tinggi serta mendukung model *multi-tenancy* sehingga siap digunakan dari skala eksperimen laboratorium hingga kebutuhan *smart city* dan industri (*Industrial IoT*).

Dalam konteks mata kuliah **Komunikasi Data dan Jaringan Komputer (KDJK)**, ThingsBoard sangat relevan karena mengimplementasikan berbagai fondasi jaringan secara nyata, antara lain:
- **Protokol Komunikasi Data IoT:** Mendukung protokol **MQTT** (port 1883) berbasis TCP untuk pertukaran pesan *publish/subscribe* yang hemat *bandwidth*, protokol **HTTP/REST API** (port 9090) berbasis model *Request/Response*, serta protokol **CoAP** (port 5683) berbasis UDP untuk perangkat berdaya rendah.
- **Arsitektur Jaringan Client-Server & Pub/Sub:** Mengatur bagaimana ribuan sensor (*node client*) mentransmisikan data telemetri berkala ke server broker terpusat.
- **Reverse Tunneling & NAT Traversal:** Mengintegrasikan **Cloudflare Tunnel (`cloudflared`)** untuk mengekspos Web UI dan endpoint API lokal ke internet publik secara terenkripsi (TLS/HTTPS) tanpa memerlukan IP publik statis atau konfigurasi *port forwarding* pada router NAT.

---

# Instalasi
[`^ kembali ke atas ^`](#)

#### Kebutuhan Sistem :
- **Sistem Operasi:** Windows 10/11 (64-bit) dengan Docker Desktop, atau Linux (Ubuntu 20.04/22.04/24.04 LTS).
- **Virtualisasi:** WSL 2 (Windows Subsystem for Linux) atau Hyper-V aktif.
- **Hardware:**
  - RAM minimal 4 GB dialokasikan untuk Docker (disarankan total RAM fisik 8–16 GB).
  - CPU minimal 2 Cores.
  - Sisa ruang penyimpanan (*Disk Space*) minimal 10 GB.
- **Software Pendukung:**
  - [Docker Engine & Docker Compose](https://www.docker.com/products/docker-desktop/) (v20+).
  - [Cloudflare Tunnel (`cloudflared`)](https://github.com/cloudflare/cloudflared).
  - Web Browser modern (Google Chrome, Firefox, Microsoft Edge).

#### Langkah Instalasi CLI :

1. **Pastikan Docker Desktop Berjalan**  
   Buka aplikasi Docker Desktop di komputer Anda dan pastikan status di sudut kiri bawah berwarna hijau (**Engine running**).

2. **Kloning Repositori Projek**  
   Buka terminal (PowerShell atau Git Bash) lalu kloning repositori projek:
   ```bash
   git clone https://github.com/farrelachr/thingsboard-kdjk.git
   cd thingsboard-kdjk
   ```

3. **Siapkan File Variabel Lingkungan (`.env`)**  
   Salin template `.env.example` menjadi `.env` untuk mengatur konfigurasi port dan alokasi memori JVM:
   ```powershell
   Copy-Item .env.example .env
   ```
   *Isi default `.env`:*
   ```env
   TB_HTTP_PORT=9090
   TB_MQTT_PORT=1883
   TB_COAP_PORT=5683
   TB_EDGE_PORT=7070
   JAVA_OPTS=-Xms1024M -Xmx2048M
   ```

4. **Jalankan Container Menggunakan Docker Compose**  
   Unduh image resmi `thingsboard/tb-postgres:latest` dan jalankan container di latar belakang (*detached mode*):
   ```bash
   docker compose up -d
   ```

5. **Pantau Proses Inisialisasi (*Cold Start*)**  
   Pada saat pertama kali dijalankan, ThingsBoard akan menginisialisasi skema basis data PostgreSQL dan data demo. Proses ini memerlukan waktu 1–2 menit:
   ```bash
   docker compose logs -f
   ```
   Tunggu hingga muncul log:  
   `Started ThingsboardServerApplication in ... seconds`  
   *(Tekan `Ctrl + C` untuk keluar dari pemantauan log).*

6. **Pengujian Akses Web UI Lokal**  
   Buka browser dan akses alamat berikut:
   ```text
   http://localhost:9090
   ```
   Jika halaman login ThingsBoard berhasil terbuka, maka proses instalasi lokal telah sukses.

7. **Menghubungkan ke Cloudflare Quick Tunnel (Akses Publik)**  
   Agar ThingsBoard dapat diakses oleh dosen/asisten lab dari luar jaringan lokal (tanpa satu WiFi), jalankan `cloudflared`:
   ```powershell
   cloudflared tunnel --url http://localhost:9090
   ```
   Terminal akan menghasilkan URL publik sementara berformat HTTPS, misalnya:
   ```text
   +--------------------------------------------------------------------------------------------+
   | Your quick Tunnel has been created! Visit it at:                                           |
   | https://example-random-subdomain.trycloudflare.com                                         |
   +--------------------------------------------------------------------------------------------+
   ```

---

# Konfigurasi
[`^ kembali ke atas ^`](#)

### 1. Pembatasan Memori (JVM Heap Size)
Karena ThingsBoard dibangun menggunakan framework Java Spring Boot, alokasi memori JVM (*Java Virtual Machine*) perlu dibatasi agar container tidak mengalami *Out of Memory* (OOM) atau membebani sistem operasi host.

Pengaturan dilakukan melalui parameter `JAVA_OPTS` di file `.env` atau `docker-compose.yml`:
```yaml
environment:
  JAVA_OPTS: "-Xms1024M -Xmx2048M -XX:+ExitOnOutOfMemoryError"
```
- `-Xms1024M`: Alokasi memori awal saat startup sebesar 1 GB.
- `-Xmx2048M`: Batas maksimum penggunaan memori heap sebesar 2 GB.
- `-XX:+ExitOnOutOfMemoryError`: Memaksa container restart otomatis jika terjadi error memori agar sistem tidak *hang*.

### 2. Kustomisasi Port Jaringan
Untuk menghindari bentrok (*conflict*) dengan layanan lokal lain (seperti web server default port 8080), port Web UI ThingsBoard dialihkan ke port **9090**:
| Port Host | Port Container | Protokol | Keterangan |
| :--- | :--- | :--- | :--- |
| **9090** | 9090 | TCP (HTTP) | Antarmuka Web Dashboard & REST API Ingestion |
| **1883** | 1883 | TCP (MQTT) | Jalur pengiriman data sensor telemetri perangkat |
| **5683** | 5683 | UDP (CoAP) | Protokol CoAP untuk mikrokontroler daya rendah |
| **7070** | 7070 | TCP (gRPC) | ThingsBoard Edge RPC Communication |

### 3. Konfigurasi Akun Pengguna (*Tenant Administrator*)
Setelah instalasi pertama, ThingsBoard menyediakan akun kerja utama (**Tenant Administrator**) untuk mengelola seluruh ekosistem perangkat dan visualisasi:
- **Username:** `tenant@thingsboard.org`
- **Password:** `tenant`

> *Note: Disarankan mengubah kata sandi default melalui menu **Profile Settings** segera setelah login pertama kali.*

---

# Maintenance
[`^ kembali ke atas ^`](#)

ThingsBoard menggunakan PostgreSQL sebagai basis data relasional untuk metadata dan penyimpanan time-series. Pemeliharaan rutin dilakukan guna mencegah kehilangan data dan mencegah disk penuh akibat penumpukan log.

### 1. Pencadangan Basis Data (*Database Backup*) Mingguan
Untuk mencadangkan seluruh skema dan data tabel ThingsBoard, gunakan utilitas `pg_dump` langsung dari dalam container database:

Buat skrip backup `backup-thingsboard.ps1`:
```powershell
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
$BackupDir = ".\backups"
if (!(Test-Path $BackupDir)) { New-Item -ItemType Directory -Path $BackupDir }

# Eksekusi pg_dump dari dalam container thingsboard
docker exec -t thingsboard pg_dump -U postgres -d thingsboard > "$BackupDir\tb_backup_$Timestamp.sql"

# Hapus backup yang lebih lama dari 14 hari
Get-ChildItem $BackupDir -Filter *.sql | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-14) } | Remove-Item
Write-Host "Pencadangan basis data ThingsBoard berhasil: tb_backup_$Timestamp.sql"
```

Untuk menjadwalkan secara otomatis setiap hari Minggu pukul 02.00 WIB pada Windows, jalankan perintah Task Scheduler:
```powershell
schtasks /create /tn "ThingsBoard_Weekly_Backup" /tr "powershell.exe -File C:\path\to\backup-thingsboard.ps1" /sc weekly /d SUN /st 02:00
```

### 2. Pemulihan Data (*Database Restore*)
Jika terjadi kegagalan sistem, data dapat dipulihkan dengan memasukkan file backup SQL ke container:
```bash
cat ./backups/tb_backup_2026-10-16.sql | docker exec -i thingsboard psql -U postgres -d thingsboard
```

### 3. Pembersihan Log & Pengurangan Volume Disk
ThingsBoard menghasilkan file log sistem di `/var/log/thingsboard`. Untuk membersihkan log Docker yang membengkak:
```powershell
# Bersihkan log container tanpa mematikan container
Clear-Content (docker inspect --format='{{.LogPath}}' thingsboard)

# Hapus build cache yang tidak terpakai
docker system prune -f
```

---

# Otomatisasi
[`^ kembali ke atas ^`](#)

Untuk memudahkan operasional tanpa perlu mengetikkan perintah panjang berulang kali, telah disediakan serangkaian skrip otomatisasi PowerShell di dalam folder `scripts/`:

### 1. Menjalankan Layanan (`scripts/start.ps1`)
Skrip ini memeriksa kesiapan Docker Desktop, membaca variabel `.env`, dan menginisialisasi container secara otomatis:
```powershell
.\scripts\start.ps1
```
*Isi perintah skrip:*
```powershell
Write-Host "[ThingsBoard] Menjalankan container via Docker Compose..." -ForegroundColor Cyan
docker compose up -d
Write-Host "[ThingsBoard] Berhasil dijalankan! Buka browser di http://localhost:9090" -ForegroundColor Green
```

### 2. Menjalankan Cloudflare Tunnel Otomatis (`scripts/tunnel.ps1`)
Skrip ini mendeteksi keberadaan executable `cloudflared.exe` di sistem (baik pada PATH maupun direktori instalasi `C:\Program Files (x86)\cloudflared\cloudflared.exe`) lalu membuka jalur HTTPS publik ke port 9090:
```powershell
.\scripts\tunnel.ps1
```

### 3. Menghentikan Layanan (`scripts/stop.ps1`)
Menghentikan container ThingsBoard dengan aman (*graceful shutdown*) agar basis data tidak rusak (*corrupt*):
```powershell
.\scripts\stop.ps1
```
*Isi perintah skrip:*
```powershell
Write-Host "[ThingsBoard] Menghentikan container..." -ForegroundColor Yellow
docker compose down
Write-Host "[ThingsBoard] Layanan telah berhenti." -ForegroundColor Green
```

---

# Cara Pemakaian
[`^ kembali ke atas ^`](#)

Berikut adalah panduan operasional lengkap dari proses login, pendaftaran sensor, pengiriman telemetri, pembuatan dashboard visual, hingga pengujian alarm.

### 1. Login ke Halaman Web
1. Buka URL ThingsBoard (misal: `http://localhost:9090` atau URL Cloudflare Tunnel).
2. Masukkan kredensial akun Tenant Administrator:
   - **Username:** `tenant@thingsboard.org`
   - **Password:** `tenant`
3. Klik tombol **Login**.

### 2. Mengenal Tampilan Antarmuka
Setelah login, antarmuka dashboard utama akan menampilkan beberapa menu di bilah kiri (*sidebar*):
| Menu | Fungsi Utama |
| :--- | :--- |
| **Device Groups / Devices** | Mendaftarkan sensor/perangkat IoT dan mengelola Access Token kredensial |
| **Dashboards** | Membuat antarmuka visual grafik, gauge status, peta GPS, dan panel kendali |
| **Rule Chains** | Memprogram alur logika data, pemfilteran pesan, dan pemicu alarm (*Rule Engine*) |
| **Alarms** | Meninjau riwayat alarm aktif dan konfirmasi penyelesaian masalah (*Acknowledge/Clear*) |
| **Customers** | Mengelompokkan hak akses dashboard untuk pengguna/klien tertentu |

### 3. Mendaftarkan Perangkat (*Device*) & Mendapatkan Access Token
1. Buka menu **Device Groups** $\rightarrow$ klik grup **All** $\rightarrow$ klik ikon **`+`** (Add device) $\rightarrow$ pilih **Add new device**.
2. Masukkan nama perangkat, misalnya: `ESP32-Sensor-Lab`.
3. Biarkan jenis transport default (**Default**).
4. Klik tombol **Add**.
5. Buka perangkat yang baru dibuat, masuk ke tab **Details** $\rightarrow$ klik **Copy Access Token** (simpan token ini, misalnya: `A1_TEST_TOKEN_XYZ`).

### 4. Mengirim Data Telemetri (Simulasi Pengujian)
Data sensor dapat dikirim melalui protokol **HTTP** maupun **MQTT**:

#### Opsi A: Mengirim via HTTP REST API (Menggunakan cURL)
Jalankan perintah berikut di terminal untuk menyimulasikan data sensor suhu dan kelembapan:
```bash
curl -v -X POST http://localhost:9090/api/v1/A1_TEST_TOKEN_XYZ/telemetry \
  --header "Content-Type:application/json" \
  --data "{\"temperature\": 29.5, \"humidity\": 68.2}"
```
*Atau melalui Cloudflare Tunnel publik:*
```bash
curl -v -X POST https://example-subdomain.trycloudflare.com/api/v1/A1_TEST_TOKEN_XYZ/telemetry \
  --header "Content-Type:application/json" \
  --data "{\"temperature\": 36.8, \"humidity\": 72.0}"
```

#### Opsi B: Mengirim via Mikrokontroler ESP32 Fisik
Gunakan sketch Arduino pada `examples/esp32_demo/esp32_demo.ino`. Program ini akan membaca sensor suhu, menghubungkan ESP32 ke WiFi kampus, dan melakukan HTTP POST request berkala setiap 5 detik ke server ThingsBoard.

### 5. Membangun Dashboard Visualisasi Interaktif
1. Buka menu **Dashboards** $\rightarrow$ klik ikon **`+`** $\rightarrow$ **Create new dashboard**.
2. Beri nama dashboard: `Monitoring Suhu & Kelembapan Lab`.
3. Klik **Open Dashboard** $\rightarrow$ masuk ke mode edit (ikon pensil).
4. Buat **Alias Entitas**:
   - Klik ikon *Entity Aliases* $\rightarrow$ **Add Alias**.
   - Beri nama Alias: `SensorUtama`.
   - Filter type: *Single Entity* $\rightarrow$ Type: *Device* $\rightarrow$ Device: `ESP32-Sensor-Lab`.
   - Klik **Save**.
5. Tambahkan Widget:
   - **Widget 1 (Gauge Suhu):** Pilih *Cards / Digital Gauge* $\rightarrow$ Sumber data: `SensorUtama` dengan key `temperature`.
   - **Widget 2 (Grafik Tren Garis):** Pilih *Charts / Timeseries Line Chart* $\rightarrow$ Sumber data: `SensorUtama` dengan key `temperature` dan `humidity`.
   - **Widget 3 (Tabel Alarm Aktif):** Pilih *Alarm Widgets / Alarms Table* $\rightarrow$ Sumber data: `SensorUtama`.
6. Klik tanda centang kuning di pojok kanan bawah untuk **Menyimpan Dashboard**.

### 6. Menguji Alarm Otomatis (*Rule Engine*)
1. Secara default, sistem memiliki Rule Chain bernama `Root Rule Chain`.
2. Ketika sensor mengirimkan data suhu melebihi ambang batas aman (misal `temperature > 35` °C):
   - ThingsBoard secara otomatis memicu status **Alarm Severity: CRITICAL**.
   - Widget tabel alarm di dashboard akan berkedip merah secara *real-time*.
3. Ketika suhu kembali turun di bawah 30 °C, status alarm dapat diatur otomatis menjadi *Cleared*.

---

# Pembahasan
[`^ kembali ke atas ^`](#)

### Analisis Aplikasi ThingsBoard

#### 1. Kelebihan
- **Protokol Standar Komunikasi Data Lengkap:** Mendukung MQTT, HTTP, dan CoAP secara *native* tanpa perlu instalasi broker perantara pihak ketiga. Sangat ideal untuk praktikum Komunikasi Data dan Jaringan Komputer.
- **Visualisasi & Dashboard Kaya Fitur:** Menyediakan puluhan widget siap pakai (gauge, peta GPS, grafik *time-series*, tombol kendali relay balik/RPC) dengan konfigurasi visual *drag-and-drop*.
- **Rule Engine Berbasis Graf Visual:** Logika otomasi, penyaringan anomali, kalkulasi telemetri, dan pemicu notifikasi alarm dapat dirancang dengan menghubungkan *node graph* tanpa perlu melakukan *re-compile* kode backend.
- **Dukungan Multi-Tenancy:** Arsitektur yang memisahkan hak akses antara Administrator Sistem, Pemilik Tenant, dan Pengguna Pelanggan (*Customer*) secara aman dan terisolasi.
- **Skalabilitas Deployment:** Berkat arsitektur berbasis container dan microservices, ThingsBoard dapat dijalankan secara monolitik di laptop lokal maupun dikembangkan menjadi klaster berkapasitas jutaan perangkat dengan Kafka dan Cassandra.

#### 2. Kekurangan
- **Konsumsi Sumber Daya Memori Relatif Tinggi:** Karena dibangun di atas JVM (Java Virtual Machine) dan Spring Boot, ThingsBoard membutuhkan RAM minimal 2–4 GB agar berjalan stabil, lebih berat dibandingkan aplikasi berbasis Go atau C++.
- **Kurva Pembelajaran Awal (*Learning Curve*):** Konsep abstrak seperti *Device Profiles*, *Asset Groups*, *Entity Aliases*, dan *Rule Chains* memerlukan pemahaman konseptual yang cukup mendalam bagi pemula.
- **Waktu Startup (*Cold Start*) Lambat:** Memerlukan waktu antara 60 hingga 120 detik saat pertama kali container dinyalakan untuk memuat dependensi Java dan inisialisasi tabel basis data.

---

### Perbandingan dengan Aplikasi Web Sejenis

Untuk memenuhi agenda evaluasi pada projek praktikum KDJK, berikut adalah perbandingan ThingsBoard dengan platform sejenis (**ThingSpeak** dan **Home Assistant**):

<section align="center">
  <table align="center" style="margin-top: 1rem; text-align: left; border-collapse: collapse; font-size: 0.95em;">
    <thead>
      <tr style="background-color: rgba(0, 0, 0, 0.05);">
        <th style="padding: 8px 14px; border: 1px solid #ddd;">Aspek Evaluasi</th>
        <th style="padding: 8px 14px; border: 1px solid #ddd;">ThingsBoard (CE)</th>
        <th style="padding: 8px 14px; border: 1px solid #ddd;">ThingSpeak</th>
        <th style="padding: 8px 14px; border: 1px solid #ddd;">Home Assistant</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td style="padding: 8px 14px; font-weight: bold; border: 1px solid #ddd;">Pengembang Utama</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">ThingsBoard, Inc.</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">The MathWorks, Inc.</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">Nabu Casa / Komunitas</td>
      </tr>
      <tr>
        <td style="padding: 8px 14px; font-weight: bold; border: 1px solid #ddd;">Target & Fokus Utama</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">Industrial IoT (IIoT), Smart City, Telemetri Industri</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">Akademis, Riset Ilmiah, Integrasi MATLAB</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">Smart Home, Otomasi Peralatan Rumah Tangga</td>
      </tr>
      <tr>
        <td style="padding: 8px 14px; font-weight: bold; border: 1px solid #ddd;">Model Deployment</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">Self-hosted (Docker, Kubernetes, Bare-metal) & Cloud</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">Cloud-hosted SaaS (versi self-hosted terbatas)</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">Self-hosted (Raspberry Pi, Home Assistant OS, Docker)</td>
      </tr>
      <tr>
        <td style="padding: 8px 14px; font-weight: bold; border: 1px solid #ddd;">Dukungan Protokol Jaringan</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">MQTT, HTTP/HTTPS, CoAP, LwM2M, SNMP</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">HTTP REST, MQTT</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">Zigbee, Z-Wave, Matter, MQTT, HTTP, Bluetooth</td>
      </tr>
      <tr>
        <td style="padding: 8px 14px; font-weight: bold; border: 1px solid #ddd;">Mesin Otomasi (*Rules*)</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">Rule Chain interaktif visual berbasis <i>flow-node</i></td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">Skrip analisis komputasi berbasis kode MATLAB</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">Automasi logika YAML dan Trigger-Condition-Action UI</td>
      </tr>
      <tr>
        <td style="padding: 8px 14px; font-weight: bold; border: 1px solid #ddd;">Multi-Tenancy</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;"><b>Mendukung penuh</b> (System Admin, Tenant, Customer)</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">Tidak ada (berbasis akun personal/per-channel)</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">Tidak ada (arsitektur single-household)</td>
      </tr>
      <tr>
        <td style="padding: 8px 14px; font-weight: bold; border: 1px solid #ddd;">Kebutuhan RAM Server</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">2 GB – 4 GB (relatif berat karena Java/Postgres)</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">Ringan (berjalan di cloud MathWorks)</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">1 GB – 2 GB (berbasis Python)</td>
      </tr>
      <tr>
        <td style="padding: 8px 14px; font-weight: bold; border: 1px solid #ddd;">Biaya & Lisensi</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">Open Source (Apache 2.0) gratis 100% untuk Community Edition</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">Freemium (dibatasi batas kuota pesan per menit)</td>
        <td style="padding: 8px 14px; border: 1px solid #ddd;">Open Source (Apache 2.0) gratis</td>
      </tr>
    </tbody>
  </table>
</section>

### Kesimpulan
- **ThingsBoard** adalah pilihan paling komprehensif untuk pengujian arsitektur telemetri jaringan skala luas, manajemen armada perangkat (*device fleet*), serta skenario industri yang membutuhkan isolasi data *multi-tenant* dan visualisasi metrik data berkala.
- **ThingSpeak** lebih cocok jika fokus utama praktikum adalah melakukan analisis kalkulasi matematis berbasis MATLAB terhadap data sensor tanpa memerlukan antarmuka dashboard yang kompleks.
- **Home Assistant** adalah pilihan terbaik apabila skenario proyek difokuskan pada otomatisasi perabot rumah tangga pintar (*smart home automation*) yang berinteraksi dengan protokol nirkabel lokal seperti Zigbee dan Bluetooth.

---

# Referensi
[`^ kembali ke atas ^`](#)

1. [Dokumentasi Resmi ThingsBoard Community Edition](https://thingsboard.io/docs/)
2. [ThingsBoard GitHub Repository](https://github.com/thingsboard/thingsboard)
3. [Panduan Instalasi Docker ThingsBoard](https://thingsboard.io/docs/user-guide/install/docker/)
4. [Dokumentasi Cloudflare Tunnel (`cloudflared`)](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/)
5. [Awesome Self-Hosted - Internet of Things (IoT)](https://github.com/awesome-selfhosted/awesome-selfhosted#internet-of-things-iot)
6. [Dokumentasi Protokol MQTT OASIS Standard](https://mqtt.org/)
7. [Dokumentasi PostgreSQL Backup & Restore (`pg_dump`)](https://www.postgresql.org/docs/current/backup-dump.html)
