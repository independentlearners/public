**Chocolatey** (choco) memiliki lebih banyak item dibandingkan dengan **winget**. Chocolatey adalah package manager yang lebih matang dan memiliki lebih banyak aplikasi yang tersedia.

Berikut adalah beberapa tool lain yang menyediakan tempat download seperti Chocolatey atau winget tetapi fokus pada item gratis:

1. **Scoop**: Package manager untuk Windows yang memudahkan instalasi aplikasi open-source.
2. **Ninite**: Situs yang memungkinkan instalasi banyak aplikasi sekaligus dengan mudah.
3. **FileHippo**: Situs download software gratis yang menyediakan berbagai aplikasi untuk Windows.
4. **SourceForge**: Platform untuk mengembangkan dan mendistribusikan software open-source.
5. **Softpedia**: Situs download yang menyediakan aplikasi gratis dan open-source.

Item di Chocolatey bisa gratis atau berbayar, tergantung pada aplikasi yang diinstal. Banyak aplikasi yang tersedia secara gratis, tetapi ada juga aplikasi berbayar yang dapat diinstal melalui Chocolatey.

[Reddit](https://www.reddit.com/r/chocolatey/comments/nzqgt1/winget_vs_choco/)
[Reddit](https://www.reddit.com/r/Windows10/comments/19aqmmc/scoop_choco_or_winget/)
[Eka Wirya](https://ekawirya.com/cari-install-dan-update-aplikasi-di-windows-dengan-mudah-menggunakan-chocolatey/)
[Home](../../README.md)


Situasi di mana pembaruan perangkat dinonaktifkan dan perangkat adalah instalasi Windows yang baru (meskipun Anda menggunakan versi Windows yang lebih lama yaitu Windows 10/Server 2019 berdasarkan `BuildVersion`) menandakan bahwa Anda mungkin perlu melakukan **instalasi *offline*** untuk **Chocolatey** dan paket-paketnya di masa mendatang, terutama jika perangkat tidak memiliki akses internet atau memiliki akses yang sangat terbatas.

## Persyaratan Sistem

Berdasarkan informasi PowerShell Anda:

  * **PSVersion:** `5.1.19041.3031` (PowerShell v5.1, sudah memenuhi persyaratan minimum Chocolatey yaitu PowerShell v2.0+).
  * **BuildVersion:** `10.0.19041.3031` (Ini adalah build Windows 10, versi 20H2 atau yang lebih baru, yang memenuhi persyaratan minimum Chocolatey yaitu Windows 7+ atau Windows Server 2003+).
  * **CLRVersion:** `4.0.30319.42000` (Sudah memenuhi persyaratan .NET Framework 4.0+).

Secara teknis, perangkat Anda memenuhi semua **persyaratan minimum** untuk menginstal Chocolatey.

-----

## Langkah-Langkah Instalasi Chocolatey (Mode Normal/Online)

Jika perangkat Anda masih memiliki akses internet saat ini, ikuti langkah instalasi standar (yang lebih mudah). Anda harus menjalankan langkah ini sebagai **Administrator**.

1.  **Buka PowerShell sebagai Administrator.**

      * Tekan tombol **Windows**, ketik `powershell`.
      * Klik kanan pada **Windows PowerShell** dan pilih **Run as administrator** (Jalankan sebagai administrator).

2.  **Atur Kebijakan Eksekusi (Execution Policy).**
    Untuk mengizinkan skrip instalasi berjalan, Anda perlu mengatur `ExecutionPolicy`.

    ```powershell
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    ```

      * *Catatan:* `Set-ExecutionPolicy Bypass -Scope Process -Force` mengesampingkan kebijakan eksekusi hanya untuk sesi PowerShell saat ini (Scope Process), memungkinkan skrip instalasi berjalan, kemudian secara otomatis kembali ke pengaturan semula setelah sesi ditutup.

3.  **Jalankan Skrip Instalasi Chocolatey.**
    Tempel dan jalankan perintah berikut:

    ```powershell
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    ```

4.  **Verifikasi Instalasi.**
    Setelah instalasi selesai (biasanya tidak lebih dari 60 detik), tutup dan buka kembali PowerShell sebagai Administrator, lalu jalankan:

    ```powershell
    choco -?
    ```

    Jika Anda melihat informasi bantuan Chocolatey, instalasi berhasil.

-----

## Persiapan Khusus untuk Lingkungan Offline/Terbatas

Karena Anda menyebutkan bahwa pembaruan dinonaktifkan dan perangkat baru diinstal (mengisyaratkan akses internet yang mungkin terputus/terbatas di masa mendatang), Anda harus mempertimbangkan **Instalasi Offline/Internal** untuk Chocolatey dan semua paket yang akan Anda gunakan.

Instalasi offline memerlukan langkah-langkah berikut:

### 1\. Dapatkan File Chocolatey (Di Perangkat Berinternet)

Anda perlu mengunduh file paket Chocolatey **sebelum** perangkat Anda kehilangan akses internet.

  * **Unduh Paket NuGet Chocolatey (.nupkg):** Kunjungi repositori komunitas Chocolatey dari perangkat dengan internet dan unduh versi terbaru dari paket `chocolatey.nupkg`.
      * Cari "Download the latest chocolatey nupkg" di situs Chocolatey atau langsung ke `https://community.chocolatey.org/packages/chocolatey`.
  * **Unduh Skrip Instalasi:** Unduh skrip `install.ps1` dari `https://community.chocolatey.org/install.ps1`.

### 2\. Pindahkan File ke Perangkat Target

Salin `chocolatey.nupkg` dan `install.ps1` ke suatu lokasi, misalnya `C:\choco-setup`, di perangkat yang Anda ingin instal (perangkat dengan pembaruan dinonaktifkan).

### 3\. Instal Chocolatey Secara Lokal (Offline)

Di perangkat target, **Buka PowerShell sebagai Administrator**, navigasikan ke folder tempat Anda menyimpan file, dan jalankan perintah berikut untuk menginstal menggunakan file lokal:

```powershell
# Ganti path sesuai lokasi Anda
cd C:\choco-setup 
Set-ExecutionPolicy Bypass -Scope Process -Force 
.\install.ps1 -ChocolateyDownloadUrl "C:\choco-setup\chocolatey.nupkg"
```

### 4\. Strategi Paket Offline (Masa Depan)

Karena perangkat akan terbatas, setiap kali Anda ingin menginstal paket baru (misalnya Chrome, VS Code) menggunakan `choco install <nama_paket>`, Chocolatey akan mencoba mengunduh dari internet.

Untuk instalasi paket yang benar-benar offline, Anda harus:

1.  **Mengunduh paket `.nupkg` dan semua sumber daya terkaitnya** (termasuk *installer* aplikasi yang sebenarnya, karena paket `.nupkg` hanyalah definisi) dari perangkat yang memiliki internet.
2.  **Menyimpan paket-paket** tersebut di repositori lokal di perangkat target (misalnya `D:\ChocoOfflineRepo`).
3.  **Menambahkan sumber lokal** ke Chocolatey:
    ```powershell
    choco source add -n=OfflineRepo -s='D:\ChocoOfflineRepo' --priority 1
    ```
4.  **Menginstal paket** dari sumber lokal:
    ```powershell
    choco install <nama_paket> --source OfflineRepo -y
    ```
      * **Penting:** Proses internalisasi paket ini bisa rumit. Untuk lingkungan offline yang disarankan, biasanya Anda perlu menggunakan fitur **Package Internalizer** dari Chocolatey for Business atau membuat paket kustom Anda sendiri yang sudah menyertakan *installer* aplikasi (bukan mengunduhnya saat instalasi).
