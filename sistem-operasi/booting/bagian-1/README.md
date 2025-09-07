## **[Fase 1: Pondasi (Beginner)][0]**

### **Modul 1: Pengantar Proses _Booting_ dan _Firmware_**

<details>
  <summary>📃 Daftar Isi</summary>

---

#### **Struktur Pembelajaran Internal**

- **Deskripsi Konkret & Peran dalam Kurikulum**
- **Konsep Kunci & Filosofi Mendalam**
- **Terminologi Esensial & Penjelasan Detil**
  - **Proses _Booting_**
  - **_Firmware_**
  - **BIOS (Basic Input/Output System)**
  - **UEFI (Unified Extensible Firmware Interface)**
  - **Skema Partisi**
    - **MBR (Master Boot Record)**
    - **GPT (GUID Partition Table)**
  - **Partisi ESP (EFI System Partition)**
- **Alur Kerja & Visualisasi**
  - **Alur _Booting_ Tradisional (BIOS/MBR)**
  - **Alur _Booting_ Modern (UEFI/GPT)**
- **Sintaks Dasar / Contoh Implementasi Inti**
  - **Mengecek Jenis _Firmware_ dan Skema Partisi**
- **Hubungan dengan Modul Lain**
- **Tips dan Praktik Terbaik**
- **Potensi Kesalahan Umum & Solusi**
- **Sumber Referensi Lengkap**

</details>

---

### **Deskripsi Konkret & Peran dalam Kurikulum**

Modul ini adalah titik awal yang krusial. Perannya adalah memberikan fondasi yang kuat tentang bagaimana komputer memulai dirinya sendiri. Tanpa pemahaman yang mendalam tentang proses ini, _troubleshooting_ di tingkat yang lebih tinggi (seperti memperbaiki _bootloader_ atau menangani enkripsi) akan menjadi sangat sulit.

Anda akan mempelajari dua arsitektur _firmware_ utama yang digunakan komputer saat ini: **BIOS** yang lebih lama dan **UEFI** yang lebih modern. Anda juga akan memahami skema partisi yang terkait erat dengan masing-masing _firmware_ tersebut, yaitu **MBR** untuk BIOS dan **GPT** untuk UEFI. Memahami peran setiap komponen ini adalah kunci untuk dapat membaca dokumentasi teknis dan mengelola sistem Anda secara profesional.

### **Konsep Kunci & Filosofi Mendalam**

Bayangkan komputer Anda seperti sebuah kendaraan. Proses **_booting_** adalah proses "menyalakan mesin" dari kendaraan tersebut. Saat Anda menekan tombol daya, ada serangkaian langkah yang harus diikuti secara otomatis untuk mempersiapkan kendaraan agar siap dikendarai.

- **_Firmware_** adalah "sistem manajemen mesin" yang terprogram di dalam kendaraan. Tugasnya adalah memeriksa semua komponen vital (mesin, ban, baterai) apakah berfungsi dengan baik, lalu menyerahkan kendali kepada "sopir" (yaitu, sistem operasi) untuk memulai perjalanan.

- **BIOS (Basic Input/Output System):** Ini adalah teknologi lama, layaknya sistem manajemen mesin manual. Filosofinya sederhana: **sequential and linear**. BIOS akan melakukan _self-check_ (_POST_) dan mencari satu lokasi tetap di _disk_ (yaitu, **_Master Boot Record_** atau **MBR**) untuk menemukan instruksi awal. Jika MBR rusak atau hilang, seluruh proses berhenti.

- **UEFI (Unified Extensible Firmware Interface):** Ini adalah evolusi dari BIOS, layaknya sistem manajemen mesin digital dengan fitur pintar. Filosofinya adalah **modular dan fleksibel**. UEFI tidak lagi bergantung pada satu lokasi tetap. Sebaliknya, ia dapat membaca sebuah partisi khusus (yaitu, **_EFI System Partition_** atau **ESP**) dan mengeksekusi program _bootloader_ (`.efi file`) yang ada di dalamnya. Ini membuatnya jauh lebih tangguh, cepat, dan memungkinkan fitur keamanan seperti **_Secure Boot_**.

### **Terminologi Esensial & Penjelasan Detil**

- **Proses _Booting_**

  - **Definisi:** Serangkaian langkah yang dilakukan oleh komputer saat dinyalakan untuk memuat sistem operasi ke dalam memori kerja (RAM). Ini adalah transisi dari keadaan "mati" (tidak ada program yang berjalan) ke keadaan "hidup" (sistem operasi beroperasi).
  - **Analogi:** Proses ini seperti urutan _startup_ pesawat, dari _power-on_ hingga lepas landas, di mana setiap sistem harus diverifikasi dan diaktifkan secara berurutan.

- **_Firmware_**

  - **Definisi:** Perangkat lunak tingkat rendah (_low-level software_) yang tertanam langsung di _chip_ _motherboard_ komputer.
  - **Fungsi:** Menginisialisasi komponen _hardware_ utama (CPU, RAM, _hard disk_, GPU) dan memulai proses pencarian _bootloader_.

- **BIOS (Basic Input/Output System)**

  - **Definisi:** _Firmware_ tradisional yang menggunakan mode 16-bit. Sangat terbatas, lambat, dan hanya bisa membaca _disk_ dengan kapasitas terbatas.
  - **Cara Kerja:** Mencari **MBR** di sektor pertama _hard disk_ dan mengeksekusi kode di sana.
  - **Keterbatasan:** Tidak mendukung _booting_ dari _disk_ berkapasitas besar ($\>$2TB), tidak mendukung _Secure Boot_, dan memiliki antarmuka pengguna yang sangat sederhana (teks biru).

- **UEFI (Unified Extensible Firmware Interface)**

  - **Definisi:** _Firmware_ modern yang lebih canggih, menggunakan mode 32-bit atau 64-bit.
  - **Cara Kerja:** Mencari partisi **ESP** (EFI System Partition) dan membaca _file_ _bootloader_ di dalamnya. Ini memungkinkan _bootloader_ disimpan di _disk_ mana pun, bahkan di _network drive_.
  - **Keunggulan:** Mendukung _disk_ besar ($\>$2TB), _boot_ yang lebih cepat, antarmuka grafis yang lebih baik, dan fitur keamanan canggih seperti **_Secure Boot_**.

- **Skema Partisi**

  - **Definisi:** Cara sebuah _hard disk_ atau SSD dibagi-bagi menjadi beberapa bagian logis (partisi) untuk penyimpanan data.

  - **Hubungan dengan _Firmware_:** Skema partisi harus sesuai dengan jenis _firmware_ yang digunakan.

  - **MBR (Master Boot Record)**

    - **Definisi:** Struktur data di sektor pertama _hard disk_.
    - **Fungsi:** Menyimpan tabel partisi dan kode _boot_ awal.
    - **Keterbatasan:** Hanya bisa mendukung hingga 4 partisi utama dan _disk_ hingga 2 TB.

  - **GPT (GUID Partition Table)**

    - **Definisi:** Skema partisi modern yang terkait dengan UEFI.
    - **Fungsi:** Menyimpan informasi partisi di seluruh _disk_, membuatnya lebih tangguh.
    - **Keunggulan:** Mendukung hingga 128 partisi (secara _default_) dan _disk_ berkapasitas sangat besar.

- **Partisi ESP (EFI System Partition)**

  - **Definisi:** Partisi khusus yang diformat dengan sistem _file_ FAT32, yang digunakan oleh UEFI untuk menyimpan _file_ _bootloader_ (.efi) dan _file_ konfigurasi lainnya.
  - **Peran:** Bertindak sebagai "ruang tunggu" di mana UEFI dapat dengan mudah menemukan dan mengeksekusi _bootloader_ yang tepat.

### **Alur Kerja & Visualisasi**

Memahami alur _booting_ secara visual akan sangat membantu. Mari kita lihat perbedaannya.

#### **Alur _Booting_ Tradisional (BIOS/MBR)**

```
┌──────────────────┐
│   Tekan Tombol   │
│      Daya        │
└──────────┬───────┘
           │
┌──────────▼───────┐
│      BIOS        │──────────┐
│  (Firmware Lama) │          │
└──────────┬───────┘          ▼
           │           Periksa Hardware (POST)
           │           Inisialisasi Hardware
           │
┌──────────▼───────┐
│ Cari Sektor Awal │──────────┐
│  Disk (MBR)      │          │
└──────────┬───────┘          ▼
           │           Baca MBR dan Kode Boot Pertama
┌──────────▼───────┐
│     Bootloader   │──────────┐
│  (misal GRUB)    │          │
└──────────┬───────┘          ▼
           │           Muat Kernel Linux
           │
┌──────────▼───────┐
│    Kernel Linux  │
│     & initramfs  │
└──────────┬───────┘
           │
┌──────────▼───────┐
│   Sistem Siap    │
│      Login       │
└──────────────────┘
```

#### **Alur _Booting_ Modern (UEFI/GPT)**

```
┌──────────────────┐
│   Tekan Tombol   │
│      Daya        │
└──────────┬───────┘
           │
┌──────────▼───────┐
│      UEFI        │──────────┐
│ (Firmware Modern)│          │
└──────────┬───────┘          ▼
           │           Periksa Hardware (POST)
           │           Inisialisasi Hardware
           │
┌──────────▼───────┐
│  Cari Partisi    │──────────┐
│      ESP         │          │
└──────────┬───────┘          ▼
           │           Partisi Khusus (FAT32)
           │           untuk file .efi
┌──────────▼───────┐
│     Bootloader   │──────────┐
│  (misal GRUB.efi)│          │
└──────────┬───────┘          ▼
           │           Muat Kernel Linux
           │
┌──────────▼───────┐
│    Kernel Linux  │
│     & initramfs  │
└──────────┬───────┘
           │
┌──────────▼───────┐
│   Sistem Siap    │
│      Login       │
└──────────────────┘
```

Kedua diagram ini menunjukkan perbedaan utama dalam cara _firmware_ menemukan dan mengeksekusi _bootloader_.

### **Sintaks Dasar / Contoh Implementasi Inti**

Sebagai langkah praktis, mari kita identifikasi jenis _firmware_ dan skema partisi yang digunakan sistem Anda.

- **Untuk mengecek jenis _firmware_:**
  Gunakan perintah `ls /sys/firmware/efi`.

  ```bash
  # Ini adalah perintah yang digunakan untuk memeriksa keberadaan direktori EFI.
  # Jika direktori ini ada, maka sistem sedang berjalan dalam mode UEFI.
  ls /sys/firmware/efi

  # Contoh output jika sistem menggunakan UEFI:
  # (Output akan menampilkan isi direktori, misal 'configfs  efivars  esrt  fw_platform_id  runtime-map')
  # Jika tidak ada output, atau muncul pesan 'No such file or directory',
  # maka kemungkinan besar sistem Anda menggunakan BIOS.
  ```

- **Untuk mengecek skema partisi (MBR atau GPT):**
  Gunakan perintah `sudo fdisk -l /dev/sdX` atau `sudo gdisk -l /dev/sdX` (ganti `sdX` dengan nama _disk_ Anda, misal `sda`).

  ```bash
  # Perintah fdisk dapat menampilkan informasi partisi.
  # Perhatikan bagian "Disklabel type" pada output.
  sudo fdisk -l /dev/sda

  # Contoh output untuk MBR:
  # Disklabel type: dos  <-- 'dos' seringkali mengindikasikan MBR
  #
  # Contoh output untuk GPT:
  # Disklabel type: gpt  <-- 'gpt' secara eksplisit menunjukkan GPT
  ```

### **Hubungan dengan Modul Lain**

Modul ini adalah prasyarat mutlak untuk semua modul berikutnya. Pemahaman tentang **UEFI** dan **GPT** adalah fondasi untuk modul tentang **_Systemd-boot_** (Modul 2), karena _bootloader_ tersebut dirancang khusus untuk lingkungan UEFI. Demikian pula, pemahaman tentang bagaimana _firmware_ dan _bootloader_ bekerja adalah kunci untuk memahami mengapa kita perlu mengonfigurasi **_initramfs_** dalam Modul 3 untuk sistem terenkripsi.

### **Tips dan Praktik Terbaik**

- **Selalu Identifikasi _Firmware_ Anda:** Sebelum menginstal Linux, selalu periksa apakah sistem Anda menggunakan BIOS atau UEFI. Ini akan menentukan langkah-langkah instalasi _bootloader_ yang benar dan menghindari masalah _boot_ di masa depan.
- **Pilih UEFI (jika tersedia):** Jika _motherboard_ Anda mendukung UEFI, sangat disarankan untuk menggunakannya. Ia menawarkan _boot_ yang lebih cepat, keamanan yang lebih baik (_Secure Boot_), dan dukungan untuk _hard disk_ besar.

### **Potensi Kesalahan Umum & Solusi**

- **Masalah:** Menginstal _bootloader_ GRUB dalam mode UEFI, tetapi _motherboard_ dikonfigurasi untuk _boot_ dalam mode Legacy/BIOS.
  - **Solusi:** Pastikan konfigurasi _motherboard_ Anda cocok dengan cara Anda menginstal Linux. Periksa pengaturan _firmware_ (biasanya diakses dengan menekan F2, F10, atau F12 saat _boot_). Cari opsi "Boot Mode" atau "UEFI/Legacy Support" dan pastikan disetel ke "UEFI Only" atau "UEFI First".
- **Masalah:** Menginstal Arch Linux dengan skema partisi MBR di sistem UEFI.
  - **Solusi:** Meskipun secara teknis bisa dilakukan (menggunakan mode _Compatibility Support Module_ atau CSM), ini bukan praktik terbaik. Selalu pasangkan UEFI dengan GPT untuk kompatibilitas dan fitur terbaik.

### **Sumber Referensi Lengkap**

- **ArchWiki:**
  - [ArchWiki: Unified Extensible Firmware Interface](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface)
  - [ArchWiki: Master Boot Record](https://wiki.archlinux.org/title/Master_Boot_Record)
- **Dokumentasi Resmi:**
  - [What is BIOS and UEFI?](https://www.google.com/search?q=https://www.intel.com/content/www/us/en/support/articles/000005934/technologies/intel-motherboard-technologies.html) - Sumber dari Intel.
  - [GUID Partition Table](https://en.wikipedia.org/wiki/GUID_Partition_Table) - Artikel Wikipedia yang mendalam tentang GPT.
  - [What is an MBR?](https://www.google.com/search?q=https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/mbr) - Sumber dari Microsoft tentang MBR.

Kita telah menyelesaikan pendalaman untuk **Fase 1, Modul 1**.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../
[2]: ../
[3]: ../
[4]: ../
[5]: ../
[6]: ../
[7]: ../
[8]: ../
[9]: ../
[10]: ../
[11]: ../
[12]: ../
[13]: ../
[14]: ../
[15]: ../
[16]: ../
[17]: ../
[18]: ../
