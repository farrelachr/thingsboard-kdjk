/*
 * ESP32 Demo - ThingsBoard Telemetry via HTTP REST API
 * 
 * Cocok untuk pengujian / presentasi melalui:
 * 1. Cloudflare Quick Tunnel (https://xxxx.trycloudflare.com)
 * 2. Atau IP Lokal Laptop (http://192.168.x.x:9090)
 */

#include <WiFi.h>
#include <HTTPClient.h>

// ================= KONFIGURASI WIFI =================
const char* WIFI_SSID     = "NAMA_WIFI_ANDA";
const char* WIFI_PASSWORD = "PASSWORD_WIFI";

// ================= KONFIGURASI THINGSBOARD =================
// Opsi A (Lewat Cloudflare Quick Tunnel):
// const char* TB_SERVER = "https://example-random-subdomain.trycloudflare.com";

// Opsi B (Lewat IP Lokal Laptop saat 1 Wi-Fi):
const char* TB_SERVER = "http://192.168.1.10:9090";

// Access Token didapat dari: ThingsBoard UI -> Device Groups -> All -> [Nama Device] -> Copy Access Token
const char* ACCESS_TOKEN = "MASUKKAN_ACCESS_TOKEN_DEVICE";

// Interval pengiriman data (milidetik)
const unsigned long SEND_INTERVAL_MS = 5000;
unsigned long lastSendTime = 0;

void setup() {
  Serial.begin(115200);
  delay(1000);

  Serial.println("\n[ESP32] Memulai koneksi WiFi...");
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\n[ESP32] WiFi Terhubung!");
  Serial.print("[ESP32] IP Address ESP32: ");
  Serial.println(WiFi.localIP());
}

void loop() {
  unsigned long now = millis();

  // Kirim data setiap SEND_INTERVAL_MS
  if (now - lastSendTime >= SEND_INTERVAL_MS) {
    lastSendTime = now;

    if (WiFi.status() == WL_CONNECTED) {
      sendTelemetry();
    } else {
      Serial.println("[ESP32] WiFi terputus, mencoba menyambung ulang...");
      WiFi.reconnect();
    }
  }
}

void sendTelemetry() {
  HTTPClient http;

  // Endpoint REST API Thingsboard: /api/v1/{ACCESS_TOKEN}/telemetry
  String url = String(TB_SERVER) + "/api/v1/" + ACCESS_TOKEN + "/telemetry";

  http.begin(url);
  http.addHeader("Content-Type", "application/json");

  // Simulasi data sensor (atau ganti dengan pembacaan sensor DHT/BME/analog Anda)
  float temperature = 25.0 + (random(0, 100) / 10.0); // 25.0 - 35.0 C
  float humidity    = 50.0 + (random(0, 300) / 10.0); // 50.0 - 80.0 %

  // Format payload JSON
  String payload = "{\"temperature\":" + String(temperature, 1) + 
                   ",\"humidity\":" + String(humidity, 1) + "}";

  Serial.print("[HTTP POST] Mengirim ke: ");
  Serial.println(url);
  Serial.print("[Payload] ");
  Serial.println(payload);

  int httpCode = http.POST(payload);

  if (httpCode > 0) {
    Serial.print("[Response Code] ");
    Serial.println(httpCode);

    if (httpCode == HTTP_CODE_OK) {
      Serial.println("[SUKSES] Data telemetri berhasil diterima ThingsBoard!");
    } else {
      String response = http.getString();
      Serial.print("[Error Body] ");
      Serial.println(response);
    }
  } else {
    Serial.print("[FAILED] HTTP Request gagal, error: ");
    Serial.println(http.errorToString(httpCode).c_str());
  }

  http.end();
}
