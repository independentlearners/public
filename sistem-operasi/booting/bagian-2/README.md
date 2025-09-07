## **[Fase 2: Menengah (Intermediate)][0]**

Sekarang kita akan mendalami **Fase 2: Menengah (Intermediate)**, yang akan berfokus pada **Memahami _Bootloader_ - GRUB dan _Systemd-boot_**.

---

<details>
  <summary>📃 Daftar Isi</summary>

#### **Struktur Pembelajaran Internal**

- **Deskripsi Konkret & Peran dalam Kurikulum**
- **Konsep Kunci & Filosofi Mendalam**
  - Fungsi Esensial _Bootloader_
  - GRUB: Fleksibilitas dan Kekuatan
  - _Systemd-boot_: Kesederhanaan dan Kecepatan
- **Terminologi Esensial & Penjelasan Detil**
  - **GRUB (Grand Unified Bootloader)**
  - **_Systemd-boot_**
  - **_Boot Menu_**
  - **_Kernel_**
  - **_initramfs_**
  - **_EFI_ Stub Loader**
- **Sintaks Dasar / Contoh Implementasi Inti**
  - **Instalasi GRUB (UEFI)**
  - **Konfigurasi GRUB**
  - **Instalasi _Systemd-boot_**
  - **Konfigurasi _Systemd-boot_**
- **Hubungan dengan Modul Lain**
- **Tips dan Praktik Terbaik**
- **Potensi Kesalahan Umum & Solusi**
- **Sumber Referensi Lengkap**

</details>

---

### **Modul 2: Memahami _Bootloader_ - GRUB dan _Systemd-boot_**

### **Deskripsi Konkret & Peran dalam Kurikulum**

Modul ini adalah jembatan antara **_firmware_** dan **_kernel_** sistem operasi. Jika _firmware_ ibarat "pilot otomatis" yang menghidupkan mesin pesawat, maka **_bootloader_** adalah "pilihan rute penerbangan" yang Anda tentukan. Perannya sangat penting: ia yang akan menampilkan menu pilihan sistem operasi (jika Anda memiliki _dual-boot_) dan memuat _kernel_ yang Anda pilih ke dalam memori.

Di modul ini, Anda akan menguasai dua _bootloader_ terpopuler di lingkungan Linux: **GRUB** dan **_Systemd-boot_**. Memahami cara kerja keduanya akan memberi Anda kontrol penuh atas proses _booting_ dan kemampuan untuk mengelola sistem operasi yang berbeda pada satu perangkat.

### **Konsep Kunci & Filosofi Mendalam**

Fungsi utama dari _bootloader_ adalah untuk memuat **_kernel_** Linux ke dalam RAM dan menyerahkan kendali penuh kepada _kernel_ tersebut. Tanpa _bootloader_, _firmware_ tidak akan tahu apa yang harus dilakukan setelah menginisialisasi _hardware_.

- **GRUB: Fleksibilitas dan Kekuatan**
  - **Filosofi:** **"Grand Unified"**—sebuah _bootloader_ universal yang dirancang untuk bekerja dengan hampir semua sistem operasi dan arsitektur, baik di sistem BIOS maupun UEFI. Filosofi ini menjadikannya pilihan yang paling umum dan serbaguna, terutama untuk skenario **_dual-boot_** atau **_multi-boot_** yang kompleks. GRUB memiliki _shell_ sendiri yang kuat untuk _troubleshooting_.
- **_Systemd-boot_: Kesederhanaan dan Kecepatan**
  - **Filosofi:** **"Sederhana itu terbaik."** _Systemd-boot_ (dulunya dikenal sebagai Gummiboot) dirancang khusus untuk lingkungan **UEFI** saja. Filosofinya adalah minimalis, ringan, dan cepat. Ia tidak memiliki fitur yang kompleks seperti GRUB dan hanya berfungsi untuk memuat _kernel_ dari partisi **ESP** (EFI System Partition) yang sama. Ini menjadikannya pilihan ideal untuk sistem yang tidak memerlukan _multi-boot_ yang rumit dan mengutamakan kecepatan.

### **Terminologi Esensial & Penjelasan Detil**

- **GRUB (Grand Unified Bootloader)**

  - **Definisi:** _Bootloader_ multi-platform yang digunakan secara luas. Dikenal karena kemampuannya dalam mengelola _dual-boot_ dan fitur-fitur yang lengkap.
  - **Hubungan:** GRUB berkomunikasi dengan _firmware_ (BIOS atau UEFI) dan memuat _kernel_ Linux.

- **_Systemd-boot_**

  - **Definisi:** _Bootloader_ sederhana dan ringan yang merupakan bagian dari _suite_ _systemd_. Hanya bekerja pada sistem UEFI.
  - **Hubungan:** Terintegrasi erat dengan _systemd_, sistem _init_ yang bertanggung jawab mengelola proses _startup_ di banyak distribusi Linux, termasuk Arch Linux.

- **_Boot Menu_**

  - **Definisi:** Antarmuka interaktif yang ditampilkan oleh _bootloader_, memungkinkan pengguna untuk memilih sistem operasi atau _kernel_ yang ingin dimuat.

- **_Kernel_**

  - **Definisi:** Inti dari sistem operasi. _Kernel_ mengelola sumber daya _hardware_ komputer dan menjembatani komunikasi antara _hardware_ dan _software_.
  - **Analogi:** _Kernel_ adalah "otak" sistem operasi. _Bootloader_ adalah "pemandu" yang mengarahkan _firmware_ ke "otak" ini.

- **_initramfs_ (_initial RAM filesystem_)**

  - **Definisi:** Sebuah _filesystem_ kecil yang dimuat ke dalam RAM oleh _bootloader_ bersamaan dengan _kernel_.
  - **Fungsi:** Mengandung program dan _driver_ esensial yang diperlukan untuk memuat sistem _file_ utama, terutama jika sistem _file_ tersebut berada di _hardware_ yang rumit atau terenkripsi.

- **_EFI_ Stub Loader**

  - **Definisi:** Sebuah fitur modern di mana _kernel_ Linux itu sendiri dapat bertindak sebagai _bootloader_ dasar.
  - **Hubungan:** Dengan **_EFI_ Stub Loader\_**, Anda bisa mengabaikan _bootloader_ eksternal seperti GRUB atau _Systemd-boot_ dan meminta UEFI untuk memuat _kernel_ langsung dari partisi **ESP**. Ini adalah metode _booting_ yang paling minimalis dan cepat.

### **Sintaks Dasar / Contoh Implementasi Inti**

#### **Instalasi GRUB (UEFI)**

Instalasi GRUB melibatkan dua langkah utama: instalasi _executable_ ke partisi ESP dan pembuatan _file_ konfigurasi.

**Langkah 1: Instal paket GRUB**

Pastikan paket `grub` dan `efibootmgr` sudah terinstal di Arch Linux Anda.

```bash
# Perintah untuk menginstal GRUB dan efibootmgr
sudo pacman -S grub efibootmgr
```

**Langkah 2: Instal GRUB ke Partisi ESP**

Ini adalah langkah kritis di mana _executable_ GRUB (`grubx64.efi`) ditempatkan di partisi ESP Anda.

```bash
# Sintaks:
# --target=x86_64-efi: Menentukan target arsitektur (UEFI 64-bit).
# --efi-directory=/boot/efi: Menentukan lokasi partisi ESP.
# --bootloader-id=grub: Memberi nama entri boot di firmware UEFI.

sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub
```

**Langkah 3: Buat _File_ Konfigurasi GRUB**

GRUB membaca pengaturannya dari `grub.cfg`. _File_ ini dibuat secara otomatis dari _template_ di `/etc/default/grub` dan `/etc/grub.d/`.

```bash
# Sintaks:
# -o: Menentukan file output (grub.cfg).
# Perintah ini akan memindai sistem Anda untuk kernel yang terinstal dan membuat menu boot.

sudo grub-mkconfig -o /boot/grub/grub.cfg
```

#### **Instalasi _Systemd-boot_**

**Langkah 1: Instalasi _bootloader_**

_Systemd-boot_ sudah termasuk dalam paket `systemd` di Arch Linux. Anda hanya perlu menjalankannya untuk menginstal _file_ esensialnya ke partisi ESP.

```bash
# Perintah untuk menginstal systemd-boot
sudo bootctl install
```

**Langkah 2: Konfigurasi Entri _Boot_**

_Systemd-boot_ menggunakan _file_ teks sederhana untuk konfigurasinya, yang berada di dalam partisi ESP.

- **`loader.conf`:** Untuk konfigurasi global (_timeout_, _default entry_).

  - Lokasi: `/boot/efi/loader/loader.conf`
  - Contoh konten:

  <!-- end list -->

  ```ini
  default  arch.conf
  timeout  3
  # editor  no
  ```

- **`arch.conf`:** Untuk entri _boot_ spesifik Arch Linux.

  - Lokasi: `/boot/efi/loader/entries/arch.conf`
  - Contoh konten:

  <!-- end list -->

  ```ini
  # Sintaks:
  # title: Nama yang ditampilkan di menu boot.
  # linux: Lokasi kernel.
  # initrd: Lokasi initramfs.
  # options: Parameter kernel tambahan.

  title   Arch Linux
  linux   /vmlinuz-linux
  initrd  /intel-ucode.img
  initrd  /initramfs-linux.img
  options root="LABEL=Arch_Root" rw
  ```

### **Hubungan dengan Modul Lain**

- **Ke Modul 3 (Sistem Terenkripsi):** Modul ini adalah prasyarat langsung untuk memahami bagaimana _bootloader_ memuat **_initramfs_**. Saat Anda menginstal sistem terenkripsi, Anda akan memodifikasi _file_ konfigurasi _bootloader_ (`grub.cfg` atau `arch.conf`) untuk menambahkan parameter _kernel_ yang memberi tahu _initramfs_ untuk membuka _disk_ terenkripsi.
- **Ke Modul 4 (_Troubleshooting_):** Memahami struktur konfigurasi GRUB dan _Systemd-boot_ adalah langkah pertama dalam proses _troubleshooting_. Saat _booting_ gagal, Anda akan tahu harus memeriksa _file_ mana (`grub.cfg`, `loader.conf`, `arch.conf`) untuk menemukan kesalahan.

### **Tips dan Praktik Terbaik**

- **_Dual-boot_ & GRUB:** Jika Anda berencana untuk _dual-boot_ dengan Windows atau sistem operasi lain, **GRUB** adalah pilihan yang lebih aman karena ia memiliki kemampuan deteksi otomatis yang lebih baik untuk sistem operasi lain.
- **_Single-boot_ & _Systemd-boot_:** Jika Anda hanya akan menggunakan Arch Linux, pertimbangkan **_Systemd-boot_**. Strukturnya yang sederhana mengurangi kemungkinan kesalahan konfigurasi dan menawarkan _boot_ yang sedikit lebih cepat.
- **Sway & _Systemd-boot_:** Karena Anda adalah pengguna Sway WM, _Systemd-boot_ adalah pilihan yang sangat harmonis dengan filosofi **minimalis** dan **kesederhanaan** dari ekosistem _systemd_ dan Wayland.

### **Potensi Kesalahan Umum & Solusi**

- **Masalah:** GRUB gagal mendeteksi sistem operasi lain saat _dual-booting_.
  - **Penyebab:** Paket `os-prober` tidak terinstal atau tidak diaktifkan.
  - **Solusi:** Instal paketnya (`sudo pacman -S os-prober`), pastikan `GRUB_DISABLE_OS_PROBER` tidak disetel ke `true` di `/etc/default/grub`, lalu jalankan kembali `sudo grub-mkconfig -o /boot/grub/grub.cfg`.
- **Masalah:** Setelah menginstal _Systemd-boot_ di sistem UEFI, entri _boot_ baru tidak muncul di menu _firmware_.
  - **Penyebab:** Partisi ESP tidak terpasang (mounted) dengan benar atau Anda tidak menjalankan `bootctl install` dengan hak akses _root_.
  - **Solusi:** Pastikan partisi ESP (`/dev/sdXn`) sudah terpasang ke `/boot/efi` dan coba lagi.

### **Sumber Referensi Lengkap**

- **GRUB:**
  - [ArchWiki: GRUB](https://wiki.archlinux.org/title/GRUB) - Sumber utama untuk instalasi dan konfigurasi GRUB di Arch Linux.
  - [GRUB Manual](https://www.gnu.org/software/grub/manual/grub/grub.html) - Dokumentasi resmi GRUB.
- **_Systemd-boot_:**
  - [ArchWiki: Systemd-boot](https://wiki.archlinux.org/title/Systemd-boot) - Panduan _step-by-step_ untuk _Systemd-boot_ di Arch Linux.
  - [bootctl(1)](https://man.archlinux.org/man/bootctl.1) - Halaman _manual_ resmi untuk perintah `bootctl`.

Kita telah menyelesaikan pendalaman untuk **Fase 2, Modul 2**.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

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
