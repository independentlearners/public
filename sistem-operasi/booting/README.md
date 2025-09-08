# **[Kurikulum Bootloader][0]**

Selamat! Ini adalah peta jalan yang komprehensif dan mendalam untuk memahami proses _booting_ dan komponen-komponennya di lingkungan Linux/Unix-like, yang dirancang untuk mengubah pengguna biasa menjadi seorang _superuser_ atau ahli yang profesional. Kurikulum ini akan membimbing Anda dari konsep dasar hingga kemampuan mengelola sistem _boot_ yang kompleks, termasuk sistem yang terenkripsi penuh.

> **Catatan:** Kurikulum ini disusun dengan fokus pada **Arch Linux** dan **Sway Window Manager** sesuai dengan preferensi Anda, sambil tetap memberikan konsep universal yang berlaku di seluruh distribusi Linux lainnya. Pendekatan ini akan memanfaatkan keunggulan Arch Linux sebagai sistem _rolling release_ yang menawarkan fleksibilitas dan kontrol penuh.

### **Prasyarat & Alat Esensial**

Untuk memulai perjalanan ini, Anda perlu mempersiapkan beberapa hal:

- **Penguasaan Dasar Linux:** Familiaritas dengan _command-line interface_ (CLI), navigasi _file system_ (misalnya, `cd`, `ls`), dan manajemen paket dasar (`pacman` untuk Arch Linux).
- **Pengetahuan Jaringan Dasar:** Pemahaman dasar tentang IP, DNS, dan konsep _client-server_ akan sangat membantu.
- **Alat Esensial:**
  - **Sistem Operasi:** **Arch Linux** diinstal pada _physical machine_ atau _virtual machine_ (misalnya, **QEMU**, **VirtualBox**, atau **VMware**). Menggunakan _virtual machine_ sangat disarankan untuk eksperimen tanpa risiko merusak sistem utama.
  - **Teks Editor:** **Vim** atau **Neovim** untuk mengedit _file_ konfigurasi dari CLI.
  - **Terminal Emulator:** **Alacritty** atau **foot** untuk pengalaman CLI yang ringan.

---

### **[Fase 1: Pondasi (Beginner)][1]**

Fase ini akan membangun pemahaman dasar Anda tentang apa itu _booting_, komponen-komponennya, dan bagaimana proses tersebut dimulai dari momen Anda menekan tombol daya hingga munculnya _prompt_ login.

#### **Modul 1: Pengantar Proses _Booting_ dan _Firmware_**

- **Deskripsi Konkret:** Anda akan memahami alur dasar dari **Power On Self Test** (POST) hingga eksekusi program pertama, serta perbedaan mendasar antara **BIOS** dan **UEFI**.
- **Konsep Dasar dan Filosofi:**
  - Proses _booting_ adalah urutan langkah-langkah yang dilakukan komputer untuk memuat sistem operasi ke dalam memori kerja (RAM).
  - **Firmware** adalah perangkat lunak _low-level_ yang tertanam dalam _chip_ di _motherboard_ Anda. Fungsinya untuk menginisialisasi _hardware_ dan memulai proses _booting_.
  - **BIOS (_Basic Input/Output System_)** adalah _firmware_ lama yang menggunakan **_Master Boot Record_ (MBR)** sebagai skema partisi. Filosofinya sederhana: mencari sektor _boot_ pertama di _disk_ dan mengeksekusinya.
  - **UEFI (_Unified Extensible Firmware Interface_)** adalah pengganti modern. Filosofinya lebih kompleks dan fleksibel. UEFI menggunakan **_GUID Partition Table_ (GPT)** dan dapat langsung memuat _bootloader_ dari sebuah partisi khusus bernama **_EFI System Partition_ (ESP)**, yang merupakan partisi FAT32.
- **Contoh Implementasi Inti:**
  - Pada **UEFI**, _bootloader_ disimpan sebagai _file_ `.efi` di partisi ESP. Anda bisa melihatnya dengan perintah `ls /boot/efi/EFI/`.
  - Pada **BIOS**, Anda bisa menggunakan perintah `sudo fdisk -l` untuk melihat partisi MBR dengan _flag_ `*` yang menandakan partisi _bootable_.
- **Terminologi Kunci:**
  - **_Booting_:** Proses memuat sistem operasi.
  - **_Firmware_:** Perangkat lunak yang menginisialisasi _hardware_.
  - **BIOS ( _Basic Input/Output System_):** _Firmware_ tradisional.
  - **UEFI ( _Unified Extensible Firmware Interface_):** _Firmware_ modern.
  - **MBR ( _Master Boot Record_):** Skema partisi untuk BIOS.
  - **GPT ( _GUID Partition Table_):** Skema partisi untuk UEFI.
  - **ESP ( _EFI System Partition_):** Partisi khusus untuk UEFI.
- **Daftar Isi:**
  - Apa itu _Booting_?
  - _Firmware_: BIOS vs. UEFI
  - Skema Partisi: MBR vs. GPT
  - Perbedaan Alur _Boot_ BIOS dan UEFI
  - Mengecek _Firmware_ dan Skema Partisi di Sistem Anda.
- **Sumber Referensi:**
  - [ArchWiki: Unified Extensible Firmware Interface](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface)
  - [ArchWiki: Master Boot Record](https://wiki.archlinux.org/title/Master_Boot_Record)

---

### **[Fase 2: Menengah (Intermediate)][2]**

Fase ini berfokus pada **_bootloader_** dan cara kerjanya, yang merupakan jembatan antara _firmware_ dan kernel sistem operasi.

#### **Modul 2: Memahami _Bootloader_ - GRUB dan _Systemd-boot_**

- **Deskripsi Konkret:** Anda akan mempelajari peran _bootloader_ dan menguasai dua _bootloader_ paling umum di Linux: **GRUB** dan **_Systemd-boot_**.
- **Konsep Dasar dan Filosofi:**
  - _Bootloader_ adalah program yang memuat kernel sistem operasi ke dalam memori. Ini adalah program pertama yang dieksekusi setelah _firmware_ selesai.
  - **GRUB (_Grand Unified Bootloader_)** adalah _bootloader_ yang kuat dan serbaguna. Filosofinya adalah _multi-platform_ dan _multi-OS_, yang membuatnya ideal untuk konfigurasi _dual-boot_ yang kompleks.
  - **_Systemd-boot_** adalah _bootloader_ sederhana, ringan, dan cepat yang dirancang untuk sistem UEFI. Filosofinya adalah kesederhanaan dan integrasi yang erat dengan **_systemd_**, init _system_ di banyak distribusi Linux modern, termasuk Arch Linux.
- **Contoh Implementasi Inti:**
  - **Instalasi GRUB (UEFI):** `sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB`
  - **Konfigurasi GRUB:** _File_ konfigurasi utama berada di `/etc/default/grub`. Anda perlu menjalankan `sudo grub-mkconfig -o /boot/grub/grub.cfg` setelah melakukan perubahan.
  - **Instalasi _Systemd-boot_:** `sudo bootctl install`. Konfigurasinya berada di `/boot/efi/loader/loader.conf` dan `/boot/efi/loader/entries/`.
- **Terminologi Kunci:**
  - **_Bootloader_:** Program yang memuat kernel.
  - **Kernel:** Inti dari sistem operasi.
  - **GRUB:** _Grand Unified Bootloader_, _bootloader_ yang kuat.
  - **_Systemd-boot_:** _Bootloader_ ringan, terintegrasi dengan _systemd_.
- **Daftar Isi:**
  - Apa itu _Bootloader_?
  - GRUB: Arsitektur dan Penggunaan
  - _Systemd-boot_: Kesederhanaan dan Kecepatan
  - Menginstal dan Mengonfigurasi GRUB (UEFI)
  - Menginstal dan Mengonfigurasi _Systemd-boot_
- **Sumber Referensi:**
  - [ArchWiki: GRUB](https://wiki.archlinux.org/title/GRUB)
  - [ArchWiki: Systemd-boot](https://wiki.archlinux.org/title/Systemd-boot)

---

### **[Fase 3: Mahir (Advanced)][3]**

Di fase ini, Anda akan mengintegrasikan pemahaman Anda untuk membangun sistem _boot_ yang kompleks, termasuk sistem terenkripsi penuh.

#### **Modul 3: _Booting_ Sistem Terenkripsi dengan LUKS dan LVM**

- **Deskripsi Konkret:** Anda akan mempelajari cara kerja enkripsi _full-disk_ menggunakan **LUKS** dan bagaimana mengintegrasikannya dengan proses _booting_ melalui **_initramfs_** agar sistem dapat meminta kata sandi sebelum _booting_ kernel.
- **Konsep Dasar dan Filosofi:**
  - **LUKS (_Linux Unified Key Setup_)** adalah standar enkripsi _disk_ untuk Linux. Filosofinya adalah memberikan lapisan enkripsi yang aman pada _disk_ atau partisi.
  - **LVM (_Logical Volume Manager_)** memungkinkan Anda mengelola partisi secara dinamis, menciptakan fleksibilitas yang luar biasa dalam pengelolaan ruang _disk_.
  - Untuk memuat sistem terenkripsi, _bootloader_ perlu memuat sebuah program khusus yang dapat mendekripsi _disk_ sebelum kernel dapat diakses. Program ini disebut **_initramfs_** (_initial RAM filesystem_).
- **Contoh Implementasi Inti:**
  - **Membuat Partisi LUKS:** `cryptsetup luksFormat /dev/sdXn`
  - **Mengintegrasikan dengan _initramfs_:** Anda perlu mengedit _file_ `/etc/mkinitcpio.conf` dan menambahkan _hook_ `encrypt` dan `lvm2` ke dalam array **HOOKS**. Kemudian, buat ulang _initramfs_ dengan `sudo mkinitcpio -P`.
  - **Menambahkan Parameter Kernel:** Tambahkan parameter `cryptdevice=/dev/sdXn:mycrypt` ke dalam konfigurasi _bootloader_ Anda (`GRUB_CMDLINE_LINUX_DEFAULT` di GRUB atau di _file_ `.conf` di _systemd-boot_).
- **Terminologi Kunci:**
  - **LUKS (_Linux Unified Key Setup_):** Standar enkripsi _disk_ Linux.
  - **LVM (_Logical Volume Manager_):** Manajer volume logis.
  - **_Initramfs_ (_initial RAM filesystem_):** Sistem _file_ minimal yang dimuat ke RAM untuk mempersiapkan lingkungan sebelum kernel dimuat.
  - **_Hook_:** Skrip yang dijalankan saat _initramfs_ dibuat.
- **Daftar Isi:**
  - Apa itu Enkripsi _Full-disk_?
  - Mengenal LUKS dan LVM
  - Peran _Initramfs_ dalam Proses _Boot_ Terenkripsi
  - Langkah-langkah Mengonfigurasi _Boot_ dengan LUKS
  - Studi Kasus: _Dual-boot_ dengan Enkripsi Penuh
- **Sumber Referensi:**
  - [ArchWiki: Dm-crypt/Encrypting an entire system](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system)
  - [ArchWiki: mkinitcpio](https://wiki.archlinux.org/title/Mkinitcpio)

---

### **[Fase 4: Ahli (Expert/Enterprise)][4]**

Pada fase ini, Anda akan menjadi seorang ahli, mampu mendiagnosis masalah _boot_ yang paling sulit dan mengintegrasikan teknik _boot_ canggih.

#### **Modul 4: _Boot_ _Recovery_ dan _Troubleshooting_**

- **Deskripsi Konkret:** Anda akan menguasai seni _troubleshooting_ masalah _boot_, mulai dari kesalahan _firmware_ hingga konfigurasi _bootloader_ yang salah, dan mempelajari cara memulihkan sistem yang gagal _boot_.
- **Konsep Dasar dan Filosofi:**
  - Ketika sistem gagal _boot_, Anda memerlukan pendekatan sistematis untuk mengidentifikasi akar masalah. Filosofinya adalah "bekerja mundur": mulai dari pesan kesalahan yang paling baru, periksa _bootloader_ Anda, _file_ konfigurasi, _initramfs_, hingga kernel.
- **Contoh Implementasi Inti:**
  - **Menganalisis Pesan Kesalahan:** Pahami arti dari pesan kesalahan umum seperti `Kernel panic`, `Failed to mount /`, atau `ERROR: device not found`.
  - **Menggunakan _live_ USB:** Gunakan _live_ USB Arch Linux untuk **_chroot_** ke dalam sistem Anda yang rusak.
    - `sudo cryptsetup open /dev/sdXn mycrypt` (untuk sistem terenkripsi)
    - `sudo mount /dev/mapper/mycrypt-root /mnt`
    - `sudo arch-chroot /mnt`
    - `sudo grub-mkconfig -o /boot/grub/grub.cfg` (untuk memperbaiki GRUB)
- **Terminologi Kunci:**
  - **_Troubleshooting_:** Proses memecahkan masalah.
  - **_Chroot_ (_Change Root_):** Mengubah direktori _root_ ke direktori yang berbeda, memungkinkan Anda bekerja di dalam sistem yang tidak _bootable_.
  - **_Kernel panic_:** Pesan kesalahan fatal yang menunjukkan kernel tidak dapat berfungsi.
- **Daftar Isi:**
  - Sistematisasi _Troubleshooting_ _Boot_
  - Memahami Pesan Kesalahan Umum
  - Menggunakan _Live_ USB untuk _Recovery_
  - Menerapkan _chroot_ untuk Perbaikan
- **Sumber Referensi:**
  - [ArchWiki: Chroot](https://wiki.archlinux.org/title/Chroot)
  - [ArchWiki: GRUB/Troubleshooting](https://www.google.com/search?q=https://wiki.archlinux.org/title/GRUB/Troubleshooting)

---

### **Hasil Pembelajaran (Learning Outcomes)**

Setelah menyelesaikan kurikulum ini, Anda akan mampu:

1.  **Membedah Proses _Booting_:** Menjelaskan secara rinci alur _booting_ dari _power-on_ hingga _prompt_ login, baik pada sistem BIOS maupun UEFI.
2.  **Menguasai _Bootloader_:** Menginstal, mengonfigurasi, dan mengelola _bootloader_ seperti GRUB dan _systemd-boot_ secara efektif, termasuk untuk skenario _dual-boot_.
3.  **Menerapkan Keamanan:** Menginstal sistem _full-disk encrypted_ dengan LUKS dan LVM serta mengintegrasikannya dengan _bootloader_ untuk keamanan maksimal.
4.  **Menjadi _Troubleshooter_:** Mendiagnosis dan memperbaiki masalah _boot_ yang paling umum dengan percaya diri, termasuk memulihkan sistem yang rusak.

---

### **Rekomendasi Waktu & Sumber Daya Tambahan**

- **Estimasi Waktu:**
  - Fase 1 (Pondasi): 10-15 jam
  - Fase 2 (Menengah): 20-30 jam
  - Fase 3 (Mahir): 30-40 jam
  - Fase 4 (Ahli): 20+ jam
- **Komunitas:**
  - **Arch Linux Forums:** Forum resmi Arch Linux adalah sumber daya tak ternilai untuk pertanyaan teknis mendalam.
  - **IRC:** Saluran **\#archlinux** di Libera.Chat untuk diskusi _real-time_.
  - **Reddit:** Komunitas r/linux, r/archlinux, dan r/linuxquestions.
- **Sertifikasi:**
  - Tidak ada sertifikasi spesifik untuk _bootloader_. Namun, pemahaman ini adalah bagian fundamental dari sertifikasi Linux tingkat lanjut seperti **LPIC-3** atau **Red Hat Certified Engineer (RHCE)**.

Kurikulum ini dirancang untuk memberikan pemahaman _bottom-up_ yang solid, memungkinkan Anda tidak hanya sekadar mengikuti langkah-langkah, tetapi benar-benar memahami "mengapa" di balik setiap perintah. Selamat belajar! 🚀

[0]: ./../../README.md
[1]: ./bagian-1/README.md
[2]: ./bagian-2/README.md
[3]: ./bagian-3/README.md
[4]: ./bagian-4/README.md
