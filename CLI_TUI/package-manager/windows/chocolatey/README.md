# Instal melalui terminal

Cara ini akan memudahkan dalam sekejap tanpa repot mengekstrak atau mengatur variabel path:

### **Instalasi Chocolatey Melalui Terminal**

1. **Buka PowerShell dengan Hak Administrator**

   - Tekan **Win + X**, lalu pilih **Windows PowerShell (Admin)** atau **Terminal (Admin)**.

2. **Jalankan Perintah Instalasi**

   Masukkan perintah berikut di PowerShell dan tekan **Enter**:

   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force; `
   [System.Net.ServicePointManager]::SecurityProtocol = `
   [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
   iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
   ```

   Perintah di atas akan secara otomatis mengunduh dan menginstal Chocolatey tanpa perlu langkah manual tambahan.

---

### **Menguasai Penggunaan Chocolatey (choco)**

Setelah terinstal, saatnya mengenal perintah-perintah dasar Chocolatey supaya kamu bisa menggunakannya dengan lancar.

#### **1. Instalasi Paket**

Untuk menginstal aplikasi:

```powershell
choco install <nama_paket> -y
```

Contoh, menginstal Google Chrome:

```powershell
choco install googlechrome -y
```

_Catatan:_ Flag `-y` digunakan untuk menjawab "yes" secara otomatis pada semua prompt.

#### **2. Mengupdate Paket**

Update aplikasi tertentu:

```powershell
choco upgrade <nama_paket> -y
```

Atau update semua aplikasi yang terinstal:

```powershell
choco upgrade all -y
```

#### **3. Menghapus Paket**

Untuk menghapus aplikasi:

```powershell
choco uninstall <nama_paket> -y
```

#### **4. Mencari Paket**

Cari paket yang tersedia:

```powershell
choco search <kata_kunci>
```

Contoh:

```powershell
choco search nodejs
```

#### **5. Melihat Informasi Paket**

Untuk melihat detail tentang suatu paket:

```powershell
choco info <nama_paket>
```

---

### **Tips Cepat Memahami Perintah Chocolatey**

- **Eksplorasi Aktif:** Coba instal dan hapus beberapa paket untuk memahami alur kerjanya.
- **Gunakan Bantuan Bawaan:** Tambahkan `-help` setelah perintah untuk melihat opsi yang tersedia. Contoh:

  ```powershell
  choco install -help
  ```

- **Shortcut Penting:**

  | Perintah                         | Fungsi                                 |
  | -------------------------------- | -------------------------------------- |
  | `choco list --local-only`        | Menampilkan daftar paket terinstal     |
  | `choco outdated`                 | Menampilkan paket yang perlu di-update |
  | `choco config get cacheLocation` | Melihat lokasi cache                   |

- **Integrasi dengan Perintah Lain:** Gabungkan perintah choco dengan pipeline PowerShell untuk tugas yang lebih kompleks.

---

### **Mengimplementasikan Choco dengan Baris Perintah Lain**

Kemampuan untuk mengintegrasikan Chocolatey dengan perintah lain membuka banyak peluang:

#### **1. Automasi Instalasi dengan Skrip**

Buat skrip PowerShell untuk menginstal kumpulan aplikasi sekaligus:

```powershell
$apps = @('googlechrome', 'firefox', 'vlc', 'git')

foreach ($app in $apps) {
    choco install $app -y
}
```

#### **2. Menggunakan Kondisional**

Instal aplikasi hanya jika belum terinstal:

```powershell
if (!(choco list --local-only | Select-String 'notepadplusplus')) {
    choco install notepadplusplus -y
}
```

#### **3. Integrasi dengan Tools Lain**

Gunakan choco dalam skrip deployment atau konfigurasi sistem bersama dengan alat seperti Ansible atau Puppet.

---

### **Memahami Lebih Dalam**

Untuk benar-benar mahir, penting memahami konsep di balik manajemen paket:

- **Repositori Paket:** Chocolatey mengambil paket dari repositori resminya. Kamu juga bisa menambahkan sumber lain atau membuat repositori internal.

- **Versi Spesifik:** Instal versi tertentu dari aplikasi:

  ```powershell
  choco install git --version=2.30.0 -y
  ```

- **Parameter Khusus Paket:** Beberapa paket mendukung parameter tambahan. Lihat dokumentasi paket untuk detailnya.

---

### **Eksplorasi Lanjutan**

Setelah nyaman dengan perintah dasar, tantang dirimu dengan hal-hal berikut:

- **Membuat Paket Sendiri:** Pelajari cara membuat dan mengemas aplikasi menjadi paket Chocolatey.

- **Kontribusi ke Komunitas:** Jika menemukan bug atau ingin menambahkan fitur, kontribusikan ke repositori Chocolatey atau paket tertentu.

- **Keamanan dan Best Practices:** Pahami bagaimana Chocolatey menangani keamanan, seperti validasi checksum dan menjalankan skrip dalam lingkungan terbatas.

---

### **Penutup dan Langkah Selanjutnya**

Menguasai Chocolatey akan sangat meningkatkan efisiensi kerjamu di lingkungan Windows. Dengan pemahaman ini, kamu bisa:

- **Automasi Setup Lingkungan Kerja:** Hemat waktu saat menyiapkan PC baru atau mengonfigurasi lingkungan pengembangan.

- **Tetap Up-to-date dengan Mudah:** Pastikan semua alatmu selalu dalam versi terbaru dengan perintah update sederhana.

> **Microsoft Copilot**

[Home](../../../README.md)
