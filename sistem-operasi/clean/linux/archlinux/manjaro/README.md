# Kurikulum Komprehensif: Menguasai Manjaro Sway i3

Kurikulum ini dirancang untuk membimbing Anda dari nol hingga menjadi ahli dalam penggunaan dan kustomisasi Manjaro Linux dengan _Window Manager_ Sway dan _Tiling Window Manager_ i3. Pendekatan ini akan sangat mendalam, mencakup filosofi di balik setiap komponen, dan memberikan contoh praktis untuk memastikan pemahaman yang kokoh.

## Prasyarat

Sebelum memulai kurikulum ini, disarankan untuk memiliki:

- **Pemahaman Dasar Sistem Operasi:** Familiaritas dengan konsep dasar sistem operasi seperti _file system_, direktori, perintah baris, dan dasar navigasi. Meskipun kurikulum ini akan berusaha menjelaskan dari dasar, memiliki pondasi ini akan sangat membantu.
- **Literasi Komputer Dasar:** Kemampuan dasar menggunakan komputer, menginstal perangkat lunak, dan memahami konsep jaringan dasar (misalnya, alamat IP, Wi-Fi).
- **Kemampuan Membaca Dokumentasi:** Kesiapan untuk membaca dan memahami dokumentasi teknis.
- **Motivasi Tinggi:** Kurikulum ini mendalam dan membutuhkan dedikasi.

## Alat Esensial

Untuk mengikuti kurikulum ini, Anda memerlukan alat-alat berikut:

- **Komputer Fisik atau Virtual Machine:** Disarankan menggunakan _Virtual Machine_ (misalnya, VirtualBox, VMWare Workstation, atau GNOME Boxes) untuk eksperimen awal guna menghindari risiko pada sistem utama Anda. Setelah familiar, Anda dapat mempertimbangkan instalasi dual-boot atau instalasi langsung.
- **Media Instalasi Manjaro Linux:** Unduh _ISO image_ Manjaro Linux versi Sway dari situs web resmi Manjaro.
- **USB Drive atau DVD:** Untuk membuat media instalasi bootable.
- **Koneksi Internet Stabil:** Diperlukan untuk unduhan, pembaruan, dan akses referensi online.
- **Editor Teks:** Anda akan banyak bekerja dengan file konfigurasi teks. Editor teks seperti **NeoVim**, **VS Code**, atau bahkan editor sederhana seperti **Nano** atau **Vi** akan sangat berguna.

## Hasil Pembelajaran (Learning Outcomes)

Setelah menyelesaikan kurikulum ini, peserta akan mampu:

1.  **Memahami Filosofi Linux & Window Manager:** Menjelaskan perbedaan antara berbagai jenis _Window Manager_ dan filosofi di balik _tiling window manager_ seperti Sway dan i3.
2.  **Menginstal & Mengkonfigurasi Manjaro Sway i3:** Melakukan instalasi bersih Manjaro dengan lingkungan Sway, serta mengonfigurasi pengaturan dasar sistem dan _desktop_.
3.  **Mengelola Sistem dengan Baris Perintah:** Menggunakan perintah dasar Linux untuk navigasi _file system_, manajemen paket, dan operasi sistem dasar.
4.  **Menguasai Konfigurasi Sway & i3:** Memahami dan memodifikasi file konfigurasi Sway/i3 untuk menyesuaikan _keybindings_, tampilan, dan perilaku _workspace_.
5.  **Mengkustomisasi Tampilan & Pengalaman Pengguna:** Menggunakan berbagai alat dan utilitas untuk mengubah _status bar_ (Waybar/i3status), _launcher_ (Rofi/dmenu), _wallpaper_, dan tema.
6.  **Mengelola Aplikasi & Layanan:** Menginstal, menghapus, dan mengelola aplikasi serta layanan sistem dengan efisien.
7.  **Meningkatkan Produktivitas:** Mengembangkan alur kerja yang efisien dengan _tiling window manager_ untuk multitasking dan navigasi yang cepat.
8.  **Memecahkan Masalah Umum:** Mengidentifikasi dan menyelesaikan masalah umum yang mungkin terjadi dalam lingkungan Manjaro Sway i3.
9.  **Mengintegrasikan Aplikasi Penting:** Mengkonfigurasi aplikasi-aplikasi esensial seperti terminal, browser, _file manager_, dan editor teks agar berjalan optimal dalam lingkungan Sway/i3.
10. **Berkontribusi pada Komunitas:** Memanfaatkan sumber daya komunitas dan berpotensi memberikan kontribusi.

## Estimasi Waktu & Level

Kurikulum ini diperkirakan akan memakan waktu sebagai berikut:

- **Fase 1: Pondasi (Pemula):** 30-40 jam
- **Fase 2: Menengah (Menengah):** 50-60 jam
- **Fase 3: Lanjutan (Mahir):** 40-50 jam
- **Fase 4: Ahli (Expert/Enterprise):** 30-40+ jam (pembelajaran berkelanjutan)

**Total Estimasi Waktu:** Sekitar **150-190 jam** atau lebih, tergantung kecepatan belajar individu dan kedalaman eksplorasi.

---

## Fase 1: Pondasi (Foundation)

**Estimasi Waktu:** 30-40 jam
**Level:** Pemula

### Deskripsi Fase

Fase ini akan memperkenalkan Anda pada konsep dasar Linux, Manjaro, dan filosofi _tiling window manager_. Anda akan belajar cara menginstal Manjaro Sway i3 dan melakukan konfigurasi awal yang esensial.

---

### Modul 1.1: Pengenalan Linux dan Distribusi Manjaro

**Deskripsi Konkret:**
Modul ini membahas apa itu Linux, sejarahnya, dan mengapa Manjaro menjadi pilihan yang bagus, terutama bagi pemula dan mereka yang mencari stabilitas dengan akses ke perangkat lunak terbaru.

**Konsep Dasar dan Filosofi:**
Linux adalah keluarga sistem operasi _open source_ yang berdasarkan kernel Linux. Filosofi di baliknya adalah **kebebasan (freedom)**, **transparansi**, dan **kolaborasi**. Setiap orang bebas menggunakan, mempelajari, memodifikasi, dan mendistribusikan ulang perangkat lunak. **Distribusi Linux** adalah kumpulan kernel Linux, sistem utilitas GNU, pustaka, perangkat lunak tambahan, dan _desktop environment_ atau _window manager_. Manjaro adalah distribusi berbasis **Arch Linux** yang berfokus pada kemudahan penggunaan dan stabilitas, sambil tetap menyediakan akses ke repositori perangkat lunak Arch yang luas (AUR).

**Sintaks Dasar/Contoh Implementasi Inti:**
Tidak ada sintaks kode spesifik di sini, namun konsepnya adalah pemilihan sistem operasi dan pemahaman struktur dasar.

**Terminologi Kunci:**

- **Kernel:** Inti dari sistem operasi yang mengelola sumber daya perangkat keras dan perangkat lunak.
- **GNU:** Kumpulan perangkat lunak bebas yang digunakan bersama kernel Linux untuk membentuk sistem operasi yang berfungsi penuh.
- **Distribusi Linux:** Sistem operasi lengkap yang dibangun di atas kernel Linux dan komponen GNU, seperti Ubuntu, Fedora, Manjaro.
- **Open Source:** Perangkat lunak yang kode sumbernya tersedia untuk umum, dapat dimodifikasi, dan didistribusikan ulang.
- **Arch Linux:** Distribusi Linux _rolling release_ yang dikenal karena kesederhanaan, fleksibilitas, dan pendekatan "do-it-yourself".
- **Manjaro Linux:** Distribusi Linux berbasis Arch yang berorientasi pada pengguna, menyediakan instalasi yang lebih mudah dan stabilitas yang lebih baik daripada Arch murni.
- **AUR (Arch User Repository):** Repositori yang dikelola komunitas untuk paket-paket yang tidak tersedia di repositori resmi Arch, seringkali digunakan di Manjaro.

**Daftar Isi:**

- Apa itu Linux dan mengapa menggunakannya?
- Sejarah Singkat Linux.
- Memahami Konsep Distribusi Linux.
- Mengapa Memilih Manjaro? Kelebihan dan Kekurangan.
- Perbedaan antara _Rolling Release_ dan _Fixed Release_.

**Sumber Referensi:**

- [What is Linux? (Linux Foundation)](https://www.linuxfoundation.org/about/who-we-are/what-is-linux)
- [Manjaro Website (Official)](https://manjaro.org/)
- [Arch Wiki: Arch User Repository (AUR)](https://wiki.archlinux.org/title/Arch_User_Repository)

---

### Modul 1.2: Mengenal Window Manager (WM) dan Filosofi Tiling WM (i3/Sway)

**Deskripsi Konkret:**
Modul ini menjelaskan apa itu _Window Manager_ dan bagaimana _tiling window manager_ seperti i3 dan Sway berbeda dari _desktop environment_ tradisional (misalnya, GNOME, KDE).

**Konsep Dasar dan Filosofi:**
_Window Manager_ adalah perangkat lunak yang mengontrol penempatan dan tampilan jendela aplikasi di layar. Berbeda dengan _Desktop Environment_ (DE) yang merupakan kumpulan perangkat lunak yang lebih besar (termasuk _file manager_, panel, dan utilitas lainnya) yang menyediakan lingkungan _desktop_ lengkap, WM hanya berfokus pada manajemen jendela.

**Tiling Window Manager (TWM)**, seperti i3 dan Sway, memiliki filosofi **efisiensi**, **minimalisme**, dan **kontrol penuh melalui keyboard**. Alih-alih membiarkan pengguna menempatkan jendela secara bebas (floating), TWM secara otomatis mengatur jendela dalam tata letak non-tumpang tindih (tiling) di layar. Ini bertujuan untuk memaksimalkan ruang layar yang tersedia dan mengurangi ketergantungan pada _mouse_.

- **i3 (i3-gaps):** TWM untuk X11 (sistem _display_ tradisional Linux). Dikenal karena kesederhanaan, kecepatan, dan konfigurasi berbasis teks yang mudah dipahami.
- **Sway:** TWM untuk Wayland (generasi berikutnya dari sistem _display_ Linux), yang kompatibel dengan konfigurasi i3. Ini menawarkan pengalaman yang serupa dengan i3 tetapi dengan teknologi _display_ yang lebih modern dan aman.

**Sintaks Dasar/Contoh Implementasi Inti:**
Tidak ada kode spesifik, namun pemahaman tentang bagaimana TWM mengelola jendela akan membentuk dasar bagi konfigurasi nantinya. Konsep utama adalah pembagian layar menjadi "tile" yang otomatis.

**Terminologi Kunci:**

- **Window Manager (WM):** Perangkat lunak yang mengelola posisi dan tampilan jendela aplikasi.
- **Desktop Environment (DE):** Lingkungan _desktop_ lengkap yang mencakup WM, _file manager_, panel, dll. (contoh: GNOME, KDE, XFCE).
- **Tiling Window Manager (TWM):** WM yang secara otomatis mengatur jendela dalam tata letak non-tumpang tindih (tiling).
- **Floating Window:** Jendela yang dapat dipindahkan dan diubah ukurannya secara bebas, seperti di DE tradisional.
- **X11 (X Window System):** Protokol _display_ grafis tradisional di sebagian besar sistem Linux.
- **Wayland:** Protokol _display_ grafis modern yang dirancang untuk menggantikan X11, menawarkan keamanan dan kinerja yang lebih baik.

**Daftar Isi:**

- Peran _Window Manager_ dalam Sistem Operasi.
- Perbedaan WM vs. _Desktop Environment_.
- Pengenalan _Tiling Window Manager_: Apa itu dan mengapa menggunakannya?
- Filosofi di Balik i3 dan Sway.
- X11 vs. Wayland: Perbedaan dan Relevansinya untuk i3/Sway.

**Sumber Referensi:**

- [i3 User's Guide (Official)](https://i3wm.org/docs/userguide.html)
- [Sway User's Wiki (Official)](https://github.com/swaywm/sway/wiki)
- [What is a Window Manager? (MakeUseOf)](https://www.makeuseof.com/what-is-a-window-manager/)

---

### Modul 1.3: Persiapan Instalasi Manjaro Sway i3

**Deskripsi Konkret:**
Modul ini memandu Anda melalui langkah-langkah persiapan sebelum instalasi, termasuk pengunduhan ISO, pembuatan _bootable drive_, dan persiapan partisi.

**Konsep Dasar dan Filosofi:**
Persiapan yang matang adalah kunci instalasi yang sukses. Memahami cara membuat media instalasi dan mengelola partisi _disk_ sangat penting untuk menghindari kehilangan data dan memastikan sistem berjalan dengan baik. **Partisi** adalah pembagian _disk_ fisik menjadi beberapa bagian logis, masing-masing dapat diformat dengan _file system_ yang berbeda dan digunakan untuk tujuan yang berbeda (misalnya, partisi sistem, partisi _swap_, partisi data).

**Sintaks Dasar/Contoh Implementasi Inti:**

- **Perintah untuk memeriksa _checksum_ (di Linux/macOS):**

  ```bash
  sha256sum /path/to/manjaro-sway-iso.iso
  ```

  Memastikan integritas file ISO yang diunduh.

- **Contoh perintah untuk membuat _bootable USB_ dengan `dd` (di Linux/macOS - GUNAKAN DENGAN HATI-HATI\!):**

  ```bash
  sudo dd if=/path/to/manjaro-sway-iso.iso of=/dev/sdX bs=4M status=progress
  ```

  (Ganti `/dev/sdX` dengan _device_ USB yang benar, misalnya `/dev/sdb`. Periksa dengan `lsblk` atau `fdisk -l` terlebih dahulu.)

**Terminologi Kunci:**

- **ISO Image (.iso):** File arsip yang berisi salinan lengkap dari _file system_ cakram optik, sering digunakan untuk distribusi sistem operasi.
- **Bootable Drive:** Media penyimpanan (USB, DVD) yang dapat digunakan untuk memulai komputer dan menjalankan sistem operasi atau _installer_.
- **Checksum (SHA256):** Nilai yang dihitung dari _file_ untuk memverifikasi integritasnya, memastikan _file_ tidak rusak atau dimodifikasi.
- **Partisi Disk:** Bagian logis dari _hard disk_ yang bertindak sebagai _disk_ terpisah.
- **Partisi Root (`/`):** Partisi utama di Linux tempat semua _file_ sistem disimpan.
- **Partisi Home (`/home`):** Partisi opsional untuk menyimpan _file_ pengguna, terpisah dari _file_ sistem. Ini berguna jika Anda ingin menginstal ulang OS tanpa kehilangan data pribadi.
- **Partisi Swap:** Area di _hard disk_ yang digunakan sebagai memori virtual ketika RAM fisik penuh.
- **UEFI/BIOS:** _Firmware_ yang menginisialisasi perangkat keras saat komputer dinyalakan. UEFI adalah pengganti modern dari BIOS.
- **Legacy Boot/CSM:** Mode kompatibilitas di UEFI untuk booting sistem yang lebih lama yang dirancang untuk BIOS.

**Daftar Isi:**

- Mengunduh Manjaro Sway ISO.
- Verifikasi Integritas ISO dengan _Checksum_.
- Membuat _Bootable USB Drive_ (Etcher/Ventoy/dd).
- Memahami Partisi Disk: Root, Home, Swap.
- Pengaturan BIOS/UEFI untuk Booting dari USB.
- Pertimbangan untuk _Dual Boot_ (opsional).

**Sumber Referensi:**

- [Manjaro Download Page (Official)](https://manjaro.org/download/)
- [Etcher (Official Website)](https://etcher.balena.io/)
- [Ventoy (Official Website)](https://www.ventoy.net/)
- [Arch Wiki: Partitioning](https://wiki.archlinux.org/title/Partitioning)
- [Arch Wiki: UEFI](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface)

**Visualisasi (Opsional tapi Direkomendasikan):**
Gambar visual direkomendasikan di sini untuk menjelaskan skema partisi disk (misalnya, diagram yang menunjukkan partisi `/`, `/home`, dan `swap` pada _disk_).

---

### Modul 1.4: Instalasi Manjaro Sway i3

**Deskripsi Konkret:**
Modul ini memandu Anda langkah demi langkah melalui proses instalasi Manjaro Sway i3, dari boot media instalasi hingga pengaturan pengguna awal.

**Konsep Dasar dan Filosofi:**
Proses instalasi adalah jembatan antara _hardware_ kosong dan sistem operasi yang berfungsi. Memahami setiap langkah memastikan Anda dapat mengonfigurasi sistem sesuai kebutuhan Anda. Manjaro menggunakan _installer_ grafis bernama **Calamares**, yang mempermudah proses instalasi yang biasanya rumit pada Arch Linux.

**Sintaks Dasar/Contoh Implementasi Inti:**
Selama instalasi, Anda akan memilih opsi yang relevan. Tidak ada sintaks yang perlu dimasukkan secara manual, namun penting untuk memahami opsi-opsi yang disajikan.

**Terminologi Kunci:**

- **Live Environment:** Sistem operasi yang berjalan langsung dari media instalasi (USB/DVD) tanpa perlu instalasi ke _hard disk_. Ini berguna untuk mencoba sistem atau memecahkan masalah.
- **Calamares:** _Installer_ grafis yang digunakan oleh Manjaro (dan banyak distribusi Linux lainnya) untuk mempermudah proses instalasi.
- **Locale:** Pengaturan yang menentukan bahasa, format tanggal, waktu, dan mata uang untuk suatu sistem.
- **Timezone:** Zona waktu sistem.
- **Hostname:** Nama yang diberikan kepada komputer dalam jaringan.
- **Password:** Kata sandi untuk akun pengguna dan akun _root_ (administrator).
- **Bootloader (GRUB):** Program yang bertanggung jawab untuk memuat kernel sistem operasi saat komputer dinyalakan.
- **Kernel Linux:** Bagian inti dari sistem operasi yang berkomunikasi langsung dengan _hardware_.

**Daftar Isi:**

- Booting dari Media Instalasi.
- Menjalankan _Installer_ Calamares.
- Memilih Bahasa, Lokasi, dan Zona Waktu.
- Pengaturan Keyboard.
- Partisi Disk: Otomatis vs. Manual (Pembahasan Mendalam).
- Membuat Akun Pengguna dan Mengatur Kata Sandi.
- Ringkasan dan Proses Instalasi Akhir.
- Reboot dan Login Pertama.

**Sumber Referensi:**

- [Manjaro Installation Guide (Manjaro Wiki)](https://wiki.manjaro.org/index.php/Installation_Guides)
- [How To Install Manjaro Linux with Sway (Video Tutorial - Cari yang terbaru)](https://www.youtube.com/results%3Fsearch_query%3Dinstall%2Bmanjaro%2Bsway)

**Visualisasi (Opsional tapi Direkomendasikan):**
Gambar visual direkomendasikan di sini untuk menunjukkan _screenshot_ setiap langkah _installer_ Calamares, terutama bagian partisi _disk_.

---

### Modul 1.5: Pengenalan Lingkungan Sway/i3 Dasar

**Deskripsi Konkret:**
Modul ini memperkenalkan Anda pada antarmuka dasar Sway/i3 setelah instalasi, menjelaskan bagaimana jendela diatur dan cara berinteraksi dengannya menggunakan _keyboard_.

**Konsep Dasar dan Filosofi:**
Filosofi utama di sini adalah **"Keyboard-Centric Workflow"**. Hampir semua interaksi dalam TWM dilakukan melalui kombinasi tombol (_keybindings_). Memahami _keybindings_ dasar adalah kunci untuk menjadi efisien. Sway dan i3 menggunakan konsep **Workspace** (ruang kerja virtual) untuk mengelompokkan jendela, memungkinkan Anda mengatur banyak aplikasi tanpa layar yang berantakan.

**Sintaks Dasar/Contoh Implementasi Inti:**

- **Contoh `config` i3/Sway (biasanya di `~/.config/i3/config` atau `~/.config/sway/config`):**

  ```yml
  # Perintah untuk membuka terminal
  bindsym $mod+Return exec alacritty

  # Perintah untuk menutup jendela aktif
  bindsym $mod+Shift+q kill

  # Pindah ke workspace 1
  bindsym $mod+1 workspace number 1

  # Pindah jendela aktif ke workspace 2
  bindsym $mod+Shift+2 move container to workspace number 2

  # Mode floating
  bindsym $mod+Shift+space floating toggle

  # Mengubah ukuran jendela (mode resize)
  mode "resize" {
      bindsym h resize shrink width 10px
      bindsym l resize grow width 10px
      bindsym k resize shrink height 10px
      bindsym j resize grow height 10px

      bindsym Return mode "default"
      bindsym Escape mode "default"
  }
  bindsym $mod+r mode "resize"
  ```

  **Catatan:** `$mod` adalah _modifier key_, biasanya `Alt` atau `Super` (tombol Windows).

- **Membuka terminal (biasanya `mod + Return`):**
  Tekan tombol `Super` (Windows) dan `Enter` secara bersamaan.

- **Menutup jendela (biasanya `mod + Shift + q`):**
  Tekan tombol `Super`, `Shift`, dan `q` secara bersamaan.

**Terminologi Kunci:**

- **Keybinding:** Kombinasi tombol keyboard yang memicu suatu tindakan atau perintah.
- **Modifier Key ($mod):** Tombol yang digunakan dalam kombinasi _keybinding_ (misalnya, `Alt`, `Super`/Windows Key).
- **Workspace (Ruang Kerja):** Lingkungan _desktop_ virtual terpisah tempat jendela dikelompokkan.
- **Container:** Istilah di i3/Sway untuk jendela atau kelompok jendela.
- **Tiling:** Mode default di mana jendela diatur secara otomatis tanpa tumpang tindih.
- **Floating:** Mode di mana jendela dapat dipindahkan dan diubah ukurannya secara bebas.
- **Bar (i3bar/Waybar):** Panel di bagian bawah (atau atas) layar yang menampilkan informasi sistem, status _workspace_, dll.
- **Launcher (dmenu/Rofi):** Aplikasi kecil yang memungkinkan Anda mencari dan meluncurkan program dengan cepat menggunakan _keyboard_.

**Daftar Isi:**

- Navigasi Dasar Menggunakan _Keybindings_.
- Memahami Konsep _Workspaces_ dan Cara Beralih.
- Membuka dan Menutup Aplikasi.
- Mengelola Jendela: Pindah, Mengubah Ukuran, _Floating_ vs. _Tiling_.
- Penggunaan _Default Bar_ (i3bar/Waybar).
- Meluncurkan Aplikasi dengan `dmenu` atau Rofi (jika terinstal).
- Keluar dan Restart Sway/i3.

**Sumber Referensi:**

- [i3 User's Guide: Usage (Official)](https://i3wm.org/docs/userguide.html%23usage)
- [Sway Wiki: Basic Usage (Official)](https://github.com/swaywm/sway/wiki/Basic-Usage)
- [Manjaro i3/Sway User Guide (Manjaro Wiki - jika ada yang spesifik)](https://wiki.manjaro.org/index.php%3Ftitle%3DI3)

**Visualisasi (Opsional tapi Direkomendasikan):**
Gambar visual direkomendasikan di sini untuk menunjukkan _screenshot_ _desktop_ Sway/i3 dengan beberapa jendela yang diatur dalam mode _tiling_ dan _floating_, serta _status bar_.

---

### Modul 1.6: Pengenalan Dasar Command Line Interface (CLI)

**Deskripsi Konkret:**
Modul ini memperkenalkan Anda pada dasar-dasar penggunaan Terminal atau _Command Line Interface_ (CLI) di Linux, yang sangat penting untuk manajemen Manjaro Sway i3.

**Konsep Dasar dan Filosofi:**
CLI adalah antarmuka berbasis teks untuk berinteraksi dengan sistem operasi. Filosofi di baliknya adalah **efisiensi**, **otomatisasi**, dan **kontrol presisi**. Banyak tugas di Linux, terutama di lingkungan seperti i3/Sway, lebih mudah dan cepat dilakukan melalui CLI daripada antarmuka grafis. Memahami perintah dasar akan membuka pintu untuk kustomisasi dan _troubleshooting_ yang lebih dalam.

**Sintaks Dasar/Contoh Implementasi Inti:**

- **Navigasi Direktori:**
  ```bash
  pwd             # Menampilkan direktori kerja saat ini (Print Working Directory)
  ls              # Daftar isi direktori
  cd Documents    # Pindah ke direktori Documents
  cd ..           # Pindah ke direktori induk
  cd ~            # Pindah ke direktori home pengguna
  ```
- **Manajemen File:**
  ```bash
  mkdir my_folder     # Membuat direktori baru
  touch new_file.txt  # Membuat file kosong
  cp file1.txt /tmp/  # Menyalin file
  mv old_name.txt new_name.txt # Memindahkan atau mengganti nama file
  rm file_to_delete.txt # Menghapus file
  rm -r my_folder     # Menghapus direktori dan isinya secara rekursif
  ```
- **Melihat Isi File:**
  ```bash
  cat my_file.txt     # Menampilkan seluruh isi file
  less large_file.log # Menampilkan isi file besar dengan navigasi
  head my_file.txt    # Menampilkan beberapa baris pertama file
  tail my_file.txt    # Menampilkan beberapa baris terakhir file
  ```
- **Perintah Penting Lainnya:**
  ```bash
  man ls          # Menampilkan manual page untuk perintah ls
  history         # Menampilkan riwayat perintah yang pernah dimasukkan
  sudo apt update # Contoh perintah dengan superuser do (untuk update sistem di distro berbasis Debian, bukan Manjaro)
  ```
  **Catatan:** Untuk Manjaro, gunakan `sudo pacman -Syu` untuk _update_ sistem.

**Terminologi Kunci:**

- **Terminal/Konsole/Shell:** Program yang menyediakan antarmuka baris perintah untuk berinteraksi dengan sistem operasi (misalnya, Bash, Zsh).
- **Prompt:** Indikator di terminal yang menunjukkan bahwa sistem siap menerima perintah.
- **Command (Perintah):** Instruksi yang diberikan kepada sistem operasi (misalnya, `ls`, `cd`).
- **Argument:** Informasi tambahan yang diberikan kepada perintah (misalnya, `ls -l` di mana `-l` adalah argumen).
- **Flag/Option:** Argumen khusus yang mengubah perilaku perintah, biasanya diawali dengan `-` atau `--`.
- **Current Working Directory (CWD):** Direktori tempat Anda berada saat ini di _file system_.
- **Absolute Path:** Jalur lengkap ke _file_ atau direktori dimulai dari _root directory_ (misalnya, `/home/user/Documents`).
- **Relative Path:** Jalur ke _file_ atau direktori relatif terhadap _current working directory_.
- **Root Directory (`/`):** Direktori paling atas di _file system_ Linux.
- **Home Directory (`~` atau `/home/username`):** Direktori pribadi setiap pengguna.
- **Superuser (root):** Akun administrator dengan semua hak akses.
- **sudo (superuser do):** Perintah untuk menjalankan perintah sebagai _superuser_.

**Daftar Isi:**

- Apa itu CLI dan mengapa penting?
- Membuka dan Menutup Terminal.
- Navigasi Dasar _File System_: `pwd`, `ls`, `cd`.
- Manajemen File dan Direktori: `mkdir`, `touch`, `cp`, `mv`, `rm`.
- Melihat Isi File: `cat`, `less`, `head`, `tail`.
- Memahami `man` pages untuk Bantuan.
- Penggunaan `sudo` untuk Hak Akses Administrator.

**Sumber Referensi:**

- [The Linux Command Line (Book - William Shotts Jr. - Online Version)](http://linuxcommand.org/tlcl.php)
- [Learn the Command Line (Codecademy - Kursus Interaktif)](https://www.codecademy.com/learn/learn-the-command-line)
- [Basic Linux Commands (TutorialsPoint)](https://www.tutorialspoint.com/linux_commands/index.htm)

---

## Fase 2: Menengah (Intermediate)

**Estimasi Waktu:** 50-60 jam
**Level:** Menengah

### Deskripsi Fase

Pada fase ini, Anda akan menyelami lebih dalam konfigurasi i3/Sway, memahami manajemen paket di Manjaro, dan mulai mengkustomisasi tampilan serta fungsionalitas sistem Anda.

---

### Modul 2.1: Memahami dan Mengkustomisasi Konfigurasi i3/Sway

**Deskripsi Konkret:**
Modul ini adalah inti dari kustomisasi i3/Sway. Anda akan belajar bagaimana membaca, memahami, dan memodifikasi file konfigurasi utama untuk mengubah _keybindings_, perilaku jendela, dan aspek-aspek lain dari _desktop_ Anda.

**Konsep Dasar dan Filosofi:**
File konfigurasi i3/Sway adalah teks biasa yang dapat dibaca dan dimodifikasi dengan editor teks apa pun. Filosofi di baliknya adalah **transparansi** dan **kontrol penuh**. Setiap aspek _Window Manager_ dapat dikustomisasi dengan mengedit file ini. Perubahan bersifat **imperatif**: Anda secara eksplisit menentukan bagaimana Anda ingin sistem berperilaku. Memahami struktur dan sintaks file konfigurasi adalah kunci untuk benar-benar menguasai Sway/i3.

**Sintaks Dasar/Contoh Implementasi Inti:**
File konfigurasi utama biasanya terletak di `~/.config/i3/config` untuk i3 atau `~/.config/sway/config` untuk Sway.

- **Definisi Modifier Key:**

  ```shell
  set $mod Mod4 # Mod4 adalah tombol Super (Windows Key)
  # set $mod Mod1 # Mod1 adalah tombol Alt
  ```

- **Menjalankan Aplikasi Saat Startup:**

  ```shell
  exec --no-startup-id nm-applet # Contoh: menjalankan network manager applet
  exec_always --no-startup-id swayidle -w ... # Untuk Sway: idle management
  ```

- **Mengatur Aplikasi Default untuk Tipe File:**

  ```shell
  for_window [class="Alacritty"] focus
  for_window [class="firefox"] move to workspace $ws2
  ```

- **Mode Pengaturan Kustom (seperti `resize` yang sudah dibahas):**

  ```yml
  mode "system_actions" {
      bindsym l exec i3lock && systemctl suspend
      bindsym e exec "exec swaymsg exit"
      bindsym r exec "exec systemctl reboot"
      bindsym s exec "exec systemctl poweroff"

      # back to default mode
      bindsym Return mode "default"
      bindsym Escape mode "default"
  }
  bindsym $mod+Shift+e mode "system_actions"
  ```

- **Mengatur Layout Jendela:**

  ```
  bindsym $mod+s layout stacking # Mengatur layout ke stacking
  bindsym $mod+w layout tabbed   # Mengatur layout ke tabbed
  bindsym $mod+e layout toggle split # Mengubah antara horizontal dan vertikal split
  ```

**Terminologi Kunci:**

- **Configuration File:** File teks yang berisi pengaturan dan instruksi untuk suatu program.
- **Keybinding:** Kombinasi tombol yang memicu perintah.
- **`set`:** Perintah dalam konfigurasi untuk mendefinisikan variabel.
- **`bindsym`:** Perintah untuk mengikat kombinasi tombol dengan suatu aksi.
- **`exec`:** Perintah untuk menjalankan program atau _script_.
- **`exec_always`:** Perintah untuk menjalankan program setiap kali i3/Sway di-restart.
- **`for_window`:** Aturan yang berlaku untuk jendela tertentu berdasarkan properti (misalnya, kelas aplikasi).
- **Layout (Tiling, Stacking, Tabbed):** Cara jendela diatur secara otomatis oleh TWM.
  - **Tiling:** Jendela mengisi ruang tanpa tumpang tindih.
  - **Stacking:** Jendela ditumpuk di atas satu sama lain, hanya judul jendela yang terlihat.
  - **Tabbed:** Jendela ditumpuk dengan _tab_ di bagian atas, mirip dengan _tab_ browser.
- **Modifier Key ($mod):** Tombol pengubah seperti Super (Windows), Alt, Ctrl, Shift.
- **`i3-msg` / `swaymsg`:** Utilitas baris perintah untuk mengirim perintah ke _running instance_ i3/Sway. Berguna untuk _scripting_.
- **`i3-reload` / `swaymsg reload`:** Perintah untuk memuat ulang konfigurasi i3/Sway tanpa harus keluar dan masuk lagi.

**Daftar Isi:**

- Lokasi dan Struktur File Konfigurasi i3/Sway.
- Memahami Sintaks Konfigurasi: `set`, `bindsym`, `exec`, `for_window`.
- Mengubah dan Menambahkan _Keybindings_ Kustom.
- Mengatur Aplikasi yang Berjalan Saat Startup.
- Mengelola Layout Jendela: _Tiling_, _Stacking_, _Tabbed_.
- Membuat Aturan untuk Jendela Spesifik (`for_window`).
- Menggunakan `$mod` dan `$ws` (variabel _workspace_).
- Reloading Konfigurasi dan _Troubleshooting_ Awal.
- Contoh Konfigurasi Populer dan Kustomisasi Umum.

**Sumber Referensi:**

- [i3 User's Guide: Configuration (Official)](https://i3wm.org/docs/userguide.html%23configuration)
- [Sway Wiki: Configuration (Official)](https://github.com/swaywm/sway/wiki/Configuration)
- [Dotfiles Repositories (GitHub - Cari "i3 dotfiles" atau "sway dotfiles")](https://github.com/search%3Fq%3Di3%2Bdotfiles%26type%3Drepositories) (Lihat contoh konfigurasi dari pengguna lain untuk inspirasi).

---

### Modul 2.2: Manajemen Paket di Manjaro dengan Pacman dan AUR

**Deskripsi Konkret:**
Modul ini mengajarkan cara menginstal, memperbarui, dan menghapus perangkat lunak di Manjaro menggunakan `pacman` (manajer paket resmi Arch) dan `yay` (untuk akses AUR).

**Konsep Dasar dan Filosofi:**
Manajemen paket adalah fondasi setiap distribusi Linux. Di Manjaro, `pacman` adalah alat baris perintah yang kuat dan cepat untuk mengelola perangkat lunak dari repositori resmi. Filosofi Arch Linux adalah **"Keep it Simple, Stupid" (KISS)**, yang tercermin dalam kesederhanaan dan kekuatan `pacman`. **Arch User Repository (AUR)** memperluas ini dengan memungkinkan pengguna berbagi _build scripts_ untuk perangkat lunak yang tidak ada di repositori resmi, mendorong kolaborasi komunitas.

**Sintaks Dasar/Contoh Implementasi Inti:**

- **`pacman` (Manajer Paket Resmi):**

  ```bash
  sudo pacman -Syu         # Sinkronisasi dan update sistem penuh
  sudo pacman -S [package_name] # Instal paket
  sudo pacman -R [package_name] # Hapus paket
  sudo pacman -Ss [keyword]     # Cari paket
  sudo pacman -Qi [package_name] # Informasi tentang paket yang terinstal
  sudo pacman -Qdt          # Daftar paket yatim (orphans)
  sudo pacman -Rns [package_name] # Hapus paket dan dependensinya yang tidak lagi dibutuhkan
  ```

- **`yay` (AUR Helper - Biasanya sudah terinstal di Manjaro):**

  ```bash
  yay -Syu         # Update sistem penuh (termasuk AUR)
  yay -S [package_name] # Instal paket dari repositori atau AUR
  yay -R [package_name] # Hapus paket
  yay -Ss [keyword]     # Cari paket (termasuk AUR)
  yay -Yc          # Bersihkan cache pacman dan yay
  ```

**Terminologi Kunci:**

- **Package Manager:** Perangkat lunak yang mengelola instalasi, pembaruan, dan penghapusan paket perangkat lunak.
- **`pacman`:** Manajer paket default untuk Arch Linux dan turunannya seperti Manjaro.
- **Repository:** Tempat penyimpanan sentral untuk paket-paket perangkat lunak.
  - **Official Repositories:** Repositori yang dikelola oleh tim Arch/Manjaro, berisi perangkat lunak yang stabil dan teruji.
- **AUR (Arch User Repository):** Repositori yang dikelola komunitas yang berisi _build scripts_ (_PKGBUILDs_) untuk mengkompilasi perangkat lunak dari sumber.
- **AUR Helper:** Utilitas yang menyederhanakan interaksi dengan AUR (misalnya, `yay`, `paru`).
- **Dependency:** Paket lain yang diperlukan agar suatu program dapat berjalan.
- **Orphan Package:** Paket yang terinstal sebagai dependensi tetapi tidak lagi diperlukan oleh paket lain.
- **PKGBUILD:** _Script_ di AUR yang berisi instruksi untuk mengkompilasi dan menginstal perangkat lunak.
- **Cache:** Area penyimpanan sementara untuk _file-file_ yang sering diakses (misalnya, paket yang diunduh).

**Daftar Isi:**

- Pengantar `pacman`: Apa itu dan bagaimana cara kerjanya.
- Perintah Dasar `pacman`: Instalasi, Pembaruan, Penghapusan.
- Mengelola Dependensi dan Paket Yatim.
- Memahami Repositori Resmi Manjaro.
- Pengenalan AUR: Manfaat dan Risiko.
- Menggunakan AUR Helper (`yay`): Instalasi dan Penggunaan Dasar.
- _Best Practices_ untuk Manajemen Paket.

**Sumber Referensi:**

- [Pacman Rosetta (Arch Wiki)](https://wiki.archlinux.org/title/Pacman/Rosetta)
- [Pacman (Arch Wiki)](https://wiki.archlinux.org/title/Pacman)
- [Arch User Repository (Arch Wiki)](https://wiki.archlinux.org/title/Arch_User_Repository)
- [yay GitHub Repository (Official)](https://github.com/Jguer/yay)

---

### Modul 2.3: Kustomisasi Tampilan: Bar (Waybar/i3status) dan Launcher (Rofi/dmenu)

**Deskripsi Konkret:**
Modul ini akan memandu Anda untuk mengkustomisasi _status bar_ (Waybar untuk Sway, i3status/Polybar untuk i3) dan _application launcher_ (Rofi/dmenu) untuk meningkatkan estetika dan fungsionalitas.

**Konsep Dasar dan Filosofi:**
Kustomisasi adalah inti dari pengalaman _tiling window manager_. Filosofinya adalah **personalisasi** dan **efisiensi visual**. Anda tidak hanya membuat sistem terlihat bagus, tetapi juga lebih fungsional dan sesuai dengan alur kerja Anda. _Bar_ memberikan informasi penting secara sekilas, sementara _launcher_ memungkinkan akses aplikasi yang cepat tanpa perlu _mouse_.

**Sintaks Dasar/Contoh Implementasi Inti:**

- **Waybar (untuk Sway) - Konfigurasi di `~/.config/waybar/config` dan `~/.config/waybar/style.css`:**

  ```json
  // Contoh config Waybar
  {
    "layer": "top", // bottom
    "position": "top", // bottom
    "height": 30,
    "spacing": 4,
    "modules-left": ["sway/workspaces", "sway/mode"],
    "modules-center": ["clock"],
    "modules-right": ["network", "pulseaudio", "battery", "tray"]
  }
  ```

  ```css
  /* Contoh style.css untuk Waybar */
  #workspaces button {
    padding: 0 5px;
    background-color: #333333;
    color: #ffffff;
  }
  #clock {
    color: #e6e6fa; /* Light purple */
  }
  ```

- **i3status (untuk i3) - Konfigurasi di `~/.config/i3status/config` atau `~/.i3status.conf`:**

  ```yml
  # Contoh config i3status
  general {
      output_format = "i3bar"
      colors = true
      interval = 5
  }

  order += "disk /"
  order += "cpu_usage"
  order += "memory"
  order += "tztime local"

  tztime local {
      format = "%Y-%m-%d %H:%M:%S"
  }
  ```

- **Rofi (digunakan sebagai _launcher_ atau pengganti dmenu) - Konfigurasi biasanya di `~/.config/rofi/config.rasi`:**

  ```
  # Contoh keybinding Rofi di i3/Sway config
  bindsym $mod+d exec rofi -show drun -modi drun
  ```

  Konfigurasi Rofi sendiri sangat kompleks dan menggunakan bahasa `rasi`.

**Terminologi Kunci:**

- **Status Bar:** Panel di _desktop_ yang menampilkan informasi sistem (waktu, baterai, jaringan, dll.).
- **Waybar:** _Status bar_ yang populer untuk Wayland (digunakan dengan Sway).
- **i3status:** Utilitas yang menghasilkan _output_ teks yang dapat ditampilkan oleh i3bar.
- **Polybar:** _Status bar_ pihak ketiga yang sangat dapat dikustomisasi, populer di lingkungan i3.
- **Application Launcher:** Utilitas untuk mencari dan menjalankan aplikasi dengan cepat.
- **dmenu:** _Application launcher_ minimalis dan efisien.
- **Rofi:** _Application launcher_ yang lebih kaya fitur dan visual dibandingkan dmenu, dapat berfungsi sebagai pengganti dmenu atau _switcher_ jendela.
- **Font Awesome:** _Font_ ikonik yang sering digunakan untuk menampilkan ikon di _status bar_ atau _launcher_.
- **GTK Theme:** Tema untuk aplikasi GTK (umumnya aplikasi non-Qt).
- **Qt Theme:** Tema untuk aplikasi Qt (umumnya aplikasi KDE atau berbasis Qt).

**Daftar Isi:**

- Memahami Peran _Status Bar_ dan _Application Launcher_.
- Kustomisasi Waybar (untuk Sway): Konfigurasi Modul dan Styling CSS.
- Kustomisasi i3status/Polybar (untuk i3): Modul dan Parameter.
- Menginstal dan Mengkonfigurasi Rofi/dmenu.
- Mengintegrasikan _Bar_ dan _Launcher_ ke dalam Konfigurasi i3/Sway.
- Mengganti Tema GTK/Qt dan Ikon (melalui `lxappearance` atau manual).
- Mengatur _Wallpaper_ dengan `swaybg` (untuk Sway) atau `feh` (untuk i3).

**Sumber Referensi:**

- [Waybar GitHub Repository (Official)](https://github.com/Alexays/Waybar)
- [i3status Man Page](https://i3wm.org/i3status/man.html)
- [Polybar GitHub Repository (Official)](https://github.com/polybar/polybar)
- [Rofi GitHub Repository (Official)](https://github.com/davatorium/rofi)
- [dmenu Man Page](https://tools.suckless.org/dmenu/man/)
- [Arch Wiki: Appearance (GTK/Qt Theming)](https://wiki.archlinux.org/title/GTK)
- [swaybg Man Page](https://man.archlinux.org/man/swaybg.1)
- [feh Man Page](https://man.archlinux.org/man/feh.1)

**Visualisasi (Opsional tapi Direkomendasikan):**
Gambar visual direkomendasikan di sini untuk menunjukkan _screenshot_ dari _desktop_ dengan Waybar yang telah dikustomisasi, _launcher_ Rofi yang terbuka, dan berbagai tata letak jendela.

---

### Modul 2.4: Mengelola Audio, Video, dan Jaringan

**Deskripsi Konkret:**
Modul ini mencakup konfigurasi dan manajemen dasar untuk audio, video, dan konektivitas jaringan di Manjaro Sway i3.

**Konsep Dasar dan Filosofi:**
Di lingkungan minimalis seperti Sway/i3, manajemen perangkat keras seringkali memerlukan pendekatan baris perintah atau utilitas kecil. Filosofinya adalah **kontrol modular** dan **efisiensi sumber daya**. Setiap komponen dikelola secara terpisah, memberikan fleksibilitas tinggi dan meminimalkan _overhead_ sistem.

**Sintaks Dasar/Contoh Implementasi Inti:**

- **Audio (PipeWire/PulseAudio):**

  ```bash
  pactl set-sink-volume @DEFAULT_SINK@ +5% # Naikkan volume (PulseAudio/PipeWire)
  pactl set-sink-volume @DEFAULT_SINK@ -5% # Turunkan volume
  pactl set-sink-mute @DEFAULT_SINK@ toggle # Mute/Unmute
  amixer sset Master 5%+ # Atau dengan ALSA
  ```

  (Ini bisa diikat ke _keybinding_ di file `config` i3/Sway)

- **Jaringan (NetworkManager):**

  ```bash
  nmcli device status     # Melihat status perangkat jaringan
  nmcli connection show   # Daftar koneksi jaringan
  nmcli device wifi connect "NamaWiFi" password "pass_wifi" # Menghubungkan ke Wi-Fi
  ```

  (Biasanya ada _applet_ `nm-applet` yang berjalan di _tray_ untuk UI grafis).

- **Pengaturan Display (Xrandr untuk i3, Swaymsg untuk Sway):**

  - **i3 (Xrandr):**
    ```bash
    xrandr --output eDP-1 --mode 1920x1080 --rate 60 --pos 0x0 # Atur resolusi dan refresh rate
    xrandr --output eDP-1 --auto --output HDMI-1 --auto --right-of eDP-1 # Dual monitor
    ```
  - **Sway:**
    ```bash
    swaymsg output eDP-1 resolution 1920x1080 position 0 0 # Atur resolusi
    swaymsg output HDMI-A-1 enable position 1920 0 # Aktifkan monitor eksternal
    ```

  (Ini juga bisa diikat ke _keybinding_ atau otomatis dengan _script_).

**Terminologi Kunci:**

- **PulseAudio:** Server suara yang menyediakan manajemen suara tingkat tinggi dan kemampuan pencampuran suara.
- **PipeWire:** Server multimedia yang lebih modern, dirancang untuk menggantikan PulseAudio dan JACK, serta menangani video.
- **ALSA (Advanced Linux Sound Architecture):** Antarmuka tingkat rendah untuk _hardware_ suara.
- **NetworkManager:** Layanan sistem yang mengelola koneksi jaringan.
- **`nmcli`:** Utilitas baris perintah untuk NetworkManager.
- **`nmtui`:** Antarmuka pengguna berbasis teks untuk NetworkManager.
- **Xrandr:** Utilitas untuk mengkonfigurasi _output_ X (display) di lingkungan X11 (i3).
- **`swaymsg output`:** Perintah Sway untuk mengelola _output_ (display) di Wayland.
- **Screen Tearing:** Artefak visual di mana beberapa _frame_ ditampilkan dalam satu layar karena sinkronisasi yang buruk.

**Daftar Isi:**

- Konfigurasi Audio: Menggunakan PipeWire/PulseAudio dan ALSA.
- Mengatur Volume dan Sumber Audio melalui _Keybindings_.
- Manajemen Jaringan: NetworkManager dan `nmcli`/`nmtui`.
- Menghubungkan ke Wi-Fi dan Jaringan Kabel.
- Pengaturan Multi-Monitor: Xrandr (i3) dan `swaymsg output` (Sway).
- Mengatasi Masalah Umum Audio/Video/Jaringan.

**Sumber Referensi:**

- [PipeWire (Arch Wiki)](https://wiki.archlinux.org/title/PipeWire)
- [PulseAudio (Arch Wiki)](https://wiki.archlinux.org/title/PulseAudio)
- [NetworkManager (Arch Wiki)](https://wiki.archlinux.org/title/NetworkManager)
- [xrandr (Arch Wiki)](https://wiki.archlinux.org/title/Xrandr)
- [Sway Wiki: Multi-monitor (Official)](https://github.com/swaywm/sway/wiki/Multi-monitor)

---

## Fase 3: Lanjutan (Advanced)

**Estimasi Waktu:** 40-50 jam
**Level:** Mahir

### Deskripsi Fase

Fase ini akan membawa Anda ke tingkat kustomisasi dan optimasi yang lebih tinggi, termasuk _scripting_ kustom, manajemen _daemon_, dan integrasi dengan aplikasi-aplikasi produktivitas.

---

### Modul 3.1: Scripting dengan Bash untuk Otomatisasi

**Deskripsi Konkret:**
Modul ini memperkenalkan dasar-dasar _Bash scripting_ dan bagaimana menggunakannya untuk mengotomatisasi tugas-tugas di Manjaro Sway i3, seperti manajemen _power_, _screenshot_, atau notifikasi kustom.

**Konsep Dasar dan Filosofi:**
_Scripting_ Bash adalah kekuatan sejati dari lingkungan Linux. Filosofinya adalah **otomatisasi tugas repetitif** dan **perluasan fungsionalitas**. Dengan _script_ Bash, Anda dapat menggabungkan beberapa perintah, menambahkan logika kondisional, dan membuat solusi kustom yang tidak tersedia secara _out-of-the-box_. Ini memungkinkan Anda untuk menyesuaikan sistem agar benar-benar sesuai dengan alur kerja Anda dan meningkatkan produktivitas secara signifikan.

**Sintaks Dasar/Contoh Implementasi Inti:**

- **Contoh Script Bash untuk _Screenshot_:**
  Simpan sebagai `~/.local/bin/screenshot.sh` dan jadikan _executable_ (`chmod +x`).

  ```bash
  #!/bin/bash

  # Variabel untuk direktori screenshot
  SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
  mkdir -p "$SCREENSHOT_DIR" # Pastikan direktori ada

  # Nama file berdasarkan tanggal dan waktu
  FILENAME="screenshot-$(date +%Y%m%d-%H%M%S).png"
  FILEPATH="$SCREENSHOT_DIR/$FILENAME"

  # Periksa apakah grim (untuk Wayland) atau scrot (untuk X11) terinstal
  if command -v grim >/dev/null 2>&1; then
      grim "$FILEPATH" # Ambil screenshot layar penuh
      notify-send "Screenshot Berhasil" "Screenshot disimpan di $FILENAME"
  elif command -v scrot >/dev/null 2>&1; then
      scrot "$FILEPATH" # Ambil screenshot layar penuh
      notify-send "Screenshot Berhasil" "Screenshot disimpan di $FILENAME"
  else
      notify-send "Error" "grim atau scrot tidak ditemukan."
  fi
  ```

  **Keybinding di i3/Sway config:**

  ```
  bindsym Print exec $HOME/.local/bin/screenshot.sh
  ```

- **Contoh Script Power Management (untuk Sway dengan `swayidle`):**

  ```bash
  #!/bin/bash

  swayidle -w \
      timeout 300 'swaylock -f' \
      timeout 600 'swaymsg "output * dpms off"' \
      resume 'swaymsg "output * dpms on"' \
      before-sleep 'swaylock -f'
  ```

  **Exec di Sway config:**

  ```shell
  exec_always ~/.config/sway/scripts/idle_management.sh
  ```

**Terminologi Kunci:**

- **Bash:** _Shell_ (interpreter baris perintah) yang paling umum di Linux.
- **Scripting:** Menulis urutan perintah dalam _file_ teks untuk dieksekusi secara otomatis oleh _shell_.
- **Shebang (`#!/bin/bash`):** Baris pertama dalam _script_ yang memberi tahu sistem _shell_ mana yang harus digunakan untuk mengeksekusi _script_.
- **Executable Permission:** Izin yang diberikan kepada _file_ yang memungkinkannya untuk dijalankan sebagai program (`chmod +x`).
- **Variables:** Nama yang digunakan untuk menyimpan nilai (misalnya, `SCREENSHOT_DIR`).
- **Conditional Statements (if/else):** Struktur kontrol yang memungkinkan _script_ membuat keputusan berdasarkan kondisi.
- **Loops (for/while):** Struktur kontrol untuk mengulangi serangkaian perintah.
- **Functions:** Blok kode yang dapat digunakan kembali dalam _script_.
- **`notify-send`:** Utilitas baris perintah untuk mengirim notifikasi _pop-up_.
- **`grim`:** Utilitas _screenshot_ untuk Wayland.
- **`scrot`:** Utilitas _screenshot_ untuk X11.
- **`swayidle`:** Daemon yang memungkinkan konfigurasi tindakan saat idle (layar mati, kunci layar, suspend).
- **`swaylock`:** Aplikasi pengunci layar untuk Wayland.

**Daftar Isi:**

- Pengantar _Bash Scripting_: Sintaks Dasar dan Konsep.
- Membuat _Script_ yang Dapat Dieksekusi.
- Variabel, Input Pengguna, dan Output.
- Kontrol Alur: If/Else, Case, Loop For/While.
- Otomatisasi Tugas Umum: _Screenshot_, Pengaturan Daya, Notifikasi.
- Mengintegrasikan _Script_ ke dalam Konfigurasi i3/Sway.
- _Debugging_ dan _Troubleshooting Script_ Bash.

**Sumber Referensi:**

- [Bash Scripting Tutorial (Ryan's Tutorials)](https://ryanstutorials.net/linuxtutorial/bash-scripting.php)
- [Shell Scripting Tutorial (GeeksforGeeks)](https://www.geeksforgeeks.org/shell-scripting-tutorial/)
- [grim GitHub Repository (Official)](https://github.com/emersion/grim)
- [scrot Man Page](https://linux.die.net/man/1/scrot)
- [swayidle GitHub Repository (Official)](https://github.com/swaywm/swayidle)
- [swaylock GitHub Repository (Official)](https://github.com/swaywm/swaylock)

---

### Modul 3.2: Manajemen Daemon dan Layanan Sistem dengan systemd

**Deskripsi Konkret:**
Modul ini akan memperkenalkan Anda pada `systemd`, sistem init dan manajer layanan yang digunakan di sebagian besar distribusi Linux modern, termasuk Manjaro. Anda akan belajar cara mengelola layanan sistem dan membuat _user service_ kustom.

**Konsep Dasar dan Filosofi:**
`systemd` adalah komponen vital dari sistem Linux modern, bertanggung jawab untuk menginisialisasi sistem saat _boot_ dan mengelola semua layanan (_daemon_) yang berjalan di latar belakang. Filosofinya adalah **manajemen terpusat**, **paralelisasi _boot_**, dan **kemudahan konfigurasi layanan**. Memahami `systemd` memungkinkan Anda untuk mengontrol apa yang berjalan di sistem Anda, mengoptimalkan waktu _boot_, dan membuat layanan kustom yang berjalan secara otomatis.

**Sintaks Dasar/Contoh Implementasi Inti:**

- **Perintah Dasar `systemctl`:**

  ```bash
  systemctl status [service_name]   # Memeriksa status layanan
  systemctl start [service_name]    # Memulai layanan
  systemctl stop [service_name]     # Menghentikan layanan
  systemctl enable [service_name]   # Mengaktifkan layanan saat boot
  systemctl disable [service_name]  # Menonaktifkan layanan saat boot
  systemctl restart [service_name]  # Merestart layanan
  systemctl list-units --type=service # Daftar semua layanan
  ```

- **Contoh User Service untuk menjalankan _script_ Sway idle:**
  Buat `~/.config/systemd/user/sway-idle.service`:

  ```ini
  [Unit]
  Description=Sway idle management
  After=sway-session.target

  [Service]
  ExecStart=/usr/bin/swayidle -w timeout 300 'swaylock -f' timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' before-sleep 'swaylock -f'
  Restart=on-failure
  # Alternatif: ExecStart=/home/user/.config/sway/scripts/idle_management.sh
  # Jika menggunakan script yang sudah dibuat sebelumnya

  [Install]
  WantedBy=sway-session.target
  ```

  **Aktifkan service:**

  ```bash
  systemctl --user enable sway-idle.service
  systemctl --user start sway-idle.service
  ```

**Terminologi Kunci:**

- **Daemon:** Program yang berjalan di latar belakang sebagai layanan sistem (misalnya, `httpd` untuk web server, `sshd` untuk SSH).
- **`systemd`:** Sistem init dan manajer layanan untuk Linux.
- **`systemctl`:** Utilitas baris perintah untuk mengontrol `systemd`.
- **Unit File:** File konfigurasi yang mendefinisikan suatu layanan, _mount point_, _timer_, dll. (ekstensi `.service`, `.mount`, `.timer`).
- **Service:** Jenis unit `systemd` yang mengelola _daemon_ atau program.
- **Target:** Jenis unit `systemd` yang mengelompokkan layanan lain (misalnya, `multi-user.target`, `graphical.target`).
- **User Service:** Layanan yang berjalan di bawah kendali pengguna (bukan sebagai _root_) dan dimulai saat pengguna _login_.
- **`journalctl`:** Utilitas untuk melihat log sistem yang dikelola oleh `systemd`.

**Daftar Isi:**

- Pengantar `systemd`: Peran dan Arsitektur.
- Perintah Dasar `systemctl` untuk Mengelola Layanan.
- Memahami Unit Files: `.service`, `.target`, dll.
- Membuat dan Mengaktifkan _User Service_ Kustom.
- Melihat Log Sistem dengan `journalctl`.
- Mengoptimalkan Waktu _Boot_ dengan `systemd-analyze`.
- Manajemen _Power_ Lanjutan dengan `systemd-logind`.

**Sumber Referensi:**

- [Systemd (Arch Wiki)](https://wiki.archlinux.org/title/Systemd)
- [systemctl Man Page](https://linux.die.net/man/1/systemctl)
- [How To Use Systemctl to Manage Systemd Services and Units (DigitalOcean)](https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units)

---

### Modul 3.3: Integrasi Aplikasi Penting dan Produktivitas

**Deskripsi Konkret:**
Modul ini fokus pada mengintegrasikan dan mengkonfigurasi aplikasi-aplikasi esensial untuk produktivitas di lingkungan Manjaro Sway i3, seperti terminal emulator, _file manager_, web browser, dan editor teks.

**Konsep Dasar dan Filosofi:**
Lingkungan _tiling window manager_ memungkinkan Anda memilih setiap komponen sistem Anda. Filosofinya adalah **minimalisme yang fungsional** dan **efisiensi alur kerja**. Dengan memilih alat yang tepat dan mengkonfigurasinya agar selaras dengan i3/Sway, Anda dapat menciptakan lingkungan kerja yang sangat cepat dan personal.

**Sintaks Dasar/Contoh Implementasi Inti:**

- **Terminal Emulator (Alacritty, Kitty, Termite, URXVT):**

  - **Instalasi:** `sudo pacman -S alacritty`
  - **Konfigurasi di `~/.config/alacritty/alacritty.yml` (contoh):**
    ```yaml
    font:
      normal:
        family: FiraCode Nerd Font
        style: Regular
      size: 10.0
    colors:
      primary:
        background: "0x1e1e2e" # Dracula background
        foreground: "0xcdd6f4" # Dracula foreground
    ```
  - **Keybinding di i3/Sway config:** `bindsym $mod+Return exec alacritty`

- **File Manager (Thunar, Ranger, Nemo, PCManFM):**

  - **Instalasi:** `sudo pacman -S thunar`
  - **Keybinding di i3/Sway config:** `bindsym $mod+f exec thunar`

- **Web Browser (Firefox, Brave, Chromium):**

  - **Instalasi:** `sudo pacman -S firefox`
  - **Keybinding di i3/Sway config:** `bindsym $mod+b exec firefox`

- **Text Editor (NeoVim, VS Code, Sublime Text):**

  - **Instalasi NeoVim:** `sudo pacman -S neovim`
  - **Konfigurasi NeoVim:** Sangat kompleks dan membutuhkan pembelajaran terpisah (sering di `~/.config/nvim/init.vim` atau `~/.config/nvim/lua/init.lua`).

- **PDF Viewer (Zathura, Evince):**

  - **Instalasi Zathura:** `sudo pacman -S zathura zathura-pdf-mupdf`
  - **Keybinding untuk membuka PDF dengan Zathura (di i3/Sway config):**
    ```ini
    for_window [instance="zathura"] floating disable
    bindsym $mod+p exec zathura
    ```

**Terminologi Kunci:**

- **Terminal Emulator:** Aplikasi yang menyediakan antarmuka baris perintah grafis (misalnya, Alacritty, Kitty).
- **File Manager:** Aplikasi untuk mengelola _file_ dan direktori (misalnya, Thunar, Ranger, PCManFM).
- **Web Browser:** Aplikasi untuk menjelajahi internet.
- **Text Editor:** Aplikasi untuk mengedit _file_ teks, termasuk kode program.
- **NeoVim:** Editor teks berbasis Vim yang modern dan sangat dapat diperluas.
- **VS Code (Visual Studio Code):** Editor kode populer dari Microsoft dengan banyak ekstensi.
- **PDF Viewer:** Aplikasi untuk melihat dokumen PDF.
- **`xdg-open`:** Utilitas yang membuka _file_ dengan aplikasi _default_ yang sesuai.
- **`mimeapps.list`:** _File_ konfigurasi di Linux yang menentukan aplikasi _default_ untuk berbagai tipe _file_.

**Daftar Isi:**

- Memilih dan Menginstal Terminal Emulator Favorit.
- Kustomisasi Terminal: _Font_, Warna, _Keybindings_.
- Memilih _File Manager_: Grafis vs. Berbasis Teks (Ranger).
- Mengatur Aplikasi Web Browser Default.
- Integrasi Editor Teks: NeoVim, VS Code, atau Pilihan Lain.
- Konfigurasi PDF Viewer (misalnya, Zathura).
- Mengatur Aplikasi Default untuk Tipe File dengan `xdg-open`.
- Tips Produktivitas untuk Lingkungan TWM.

**Sumber Referensi:**

- [Alacritty GitHub Repository (Official)](https://github.com/alacritty/alacritty)
- [Kitty Terminal Emulator (Official)](https://sw.kovidgoyal.net/kitty/)
- [Thunar Wiki (Xfce)](https://docs.xfce.org/xfce/thunar/start)
- [Ranger File Manager (Official)](https://ranger.github.io/)
- [NeoVim (Official Website)](https://neovim.io/)
- [Visual Studio Code (Official Website)](https://code.visualstudio.com/)
- [Zathura (Arch Wiki)](https://wiki.archlinux.org/title/Zathura)
- [Arch Wiki: Default applications](https://wiki.archlinux.org/title/Default_applications)

---

## Fase 4: Ahli (Expert/Enterprise)

**Estimasi Waktu:** 30-40+ jam (pembelajaran berkelanjutan)
**Level:** Expert/Enterprise

### Deskripsi Fase

Fase ini akan membawa Anda ke tingkat penguasaan penuh, berfokus pada optimasi kinerja, _troubleshooting_ mendalam, dan eksplorasi topik-topik lanjutan yang relevan dengan lingkungan _tiling window manager_.

---

### Modul 4.1: Optimasi Kinerja dan Sumber Daya

**Deskripsi Konkret:**
Modul ini membahas cara mengoptimalkan kinerja sistem Manjaro Sway i3 Anda, mengurangi konsumsi sumber daya, dan meningkatkan responsivitas.

**Konsep Dasar dan Filosofi:**
Meskipun Manjaro Sway i3 sudah ringan, selalu ada ruang untuk optimasi. Filosofinya adalah **efisiensi maksimal** dan **manajemen sumber daya proaktif**. Dengan memahami bagaimana sistem menggunakan CPU, memori, dan _disk_, Anda dapat mengidentifikasi _bottleneck_ dan melakukan penyesuaian untuk pengalaman yang lebih lancar, terutama pada _hardware_ lama atau saat menjalankan aplikasi berat.

**Sintaks Dasar/Contoh Implementasi Inti:**

- **Melihat Penggunaan Sumber Daya:**

  ```bash
  htop             # Monitor proses interaktif (lebih baik dari top)
  free -h          # Melihat penggunaan RAM
  df -h            # Melihat penggunaan disk
  iotop            # Melihat penggunaan I/O disk oleh proses
  ```

- **Mengelola Layanan Latar Belakang (systemd):**

  ```bash
  systemctl list-units --type=service --state=running # Daftar layanan yang sedang berjalan
  sudo systemctl disable [service_name] # Nonaktifkan layanan yang tidak perlu
  ```

- **Mengurangi Swappiness (mengurangi penggunaan swap):**
  Edit `/etc/sysctl.d/99-sysctl.conf` (buat jika belum ada):

  ```ini
  vm.swappiness = 10 # Nilai lebih rendah berarti OS lebih jarang menggunakan swap
  ```

  Muat ulang: `sudo sysctl -p`

- **Menggunakan `zram` untuk swap terkompresi (untuk sistem dengan RAM terbatas):**

  ```bash
  sudo pacman -S zram-generator
  sudo systemctl enable --now systemd-zram-setup@zram0
  ```

- **Menggunakan TLP (untuk laptop - manajemen daya):**

  ```bash
  sudo pacman -S tlp
  sudo systemctl enable tlp
  sudo systemctl enable tlp-sleep
  ```

**Terminologi Kunci:**

- **Resource Monitoring:** Memantau penggunaan CPU, RAM, disk I/O, dan jaringan.
- **CPU Throttling:** Penurunan kinerja CPU untuk mencegah _overheating_.
- **Swappiness:** Parameter kernel yang mengontrol seberapa agresif sistem menggunakan _swap space_.
- **zram:** Modul kernel Linux yang menciptakan perangkat blok terkompresi di RAM, digunakan sebagai _swap device_ berkecepatan tinggi.
- **TLP:** Alat optimasi daya Linux untuk laptop.
- **`cpupower`:** Utilitas untuk mengelola frekuensi dan _governor_ CPU.
- **`earlyoom`:** Daemon yang memantau memori dan membunuh proses yang paling banyak memakan memori jika sistem kehabisan RAM.
- **Kernels:** Versi kernel Linux yang berbeda dapat memiliki dampak pada kinerja dan dukungan _hardware_.

**Daftar Isi:**

- Menganalisis Penggunaan Sumber Daya dengan `htop`, `free`, `df`.
- Mengidentifikasi Proses yang Boros Sumber Daya.
- Manajemen Layanan `systemd` untuk Mengurangi _Footprint_.
- Optimasi _Swap_: Mengurangi `swappiness` dan Menggunakan `zram`.
- Manajemen Daya Tingkat Lanjut dengan TLP (untuk Laptop).
- Memilih Kernel yang Tepat untuk Kinerja Optimal.
- Penggunaan _Compositor_ (misalnya, `picom` untuk i3/X11) untuk Efek Visual dan Kinerja.
- _Tweaking_ Kernel dan _Sysctl Parameters_.

**Sumber Referensi:**

- [Arch Wiki: Improving Performance](https://wiki.archlinux.org/title/Improving_performance)
- [Arch Wiki: Zram](https://wiki.archlinux.org/title/Zram)
- [TLP – Linux Advanced Power Management (Official)](https://linrunner.de/tlp/)
- [Arch Wiki: Power management](https://wiki.archlinux.org/title/Power_management)
- [picom GitHub Repository (Official)](https://github.com/yshui/picom)

---

### Modul 4.2: Troubleshooting Lanjutan dan Debugging

**Deskripsi Konkret:**
Modul ini membekali Anda dengan keterampilan untuk mendiagnosis dan memecahkan masalah kompleks di Manjaro Sway i3, menggunakan alat _debugging_ dan memahami _log_ sistem.

**Konsep Dasar dan Filosofi:**
_Troubleshooting_ adalah seni dan sains. Filosofinya adalah **pendekatan sistematis**, **analisis log**, dan **pemecahan masalah berbasis komunitas**. Ketika masalah muncul, kemampuan untuk mengisolasi akar penyebabnya, memahami pesan kesalahan, dan mencari solusi di sumber daya yang relevan adalah keterampilan yang sangat berharga.

**Sintaks Dasar/Contoh Implementasi Inti:**

- **Melihat Log Sistem dengan `journalctl`:**

  ```bash
  journalctl -f          # Melihat log secara real-time
  journalctl -b          # Log dari boot terakhir
  journalctl -u [service] # Log untuk layanan tertentu
  journalctl -p err -b    # Hanya log error dari boot terakhir
  ```

- **Melihat Proses yang Berjalan:**

  ```bash
  ps auxf               # Menampilkan proses dalam format tree
  pstree                # Menampilkan proses dalam format tree
  ```

- **Memeriksa Status Layanan:**

  ```bash
  systemctl --failed    # Daftar layanan yang gagal
  ```

- **Memeriksa Konfigurasi Sway/i3:**

  ```bash
  swaymsg -t get_tree   # Output tree jendela dan container (untuk Sway)
  i3-msg -t get_tree    # Output tree jendela dan container (untuk i3)
  swaymsg -t get_version # Mendapatkan versi Sway
  i3-msg -t get_version # Mendapatkan versi i3
  ```

- **_Debugging_ X11/Wayland:**

  ```bash
  # Untuk X11:
  startx -- -keeptty -logfd 1 2>&1 | less # Memulai sesi X dengan logging detail

  # Untuk Wayland (khususnya Sway):
  sway -d               # Menjalankan Sway dalam mode debug (log ke stderr)
  ```

**Terminologi Kunci:**

- **Log Files:** _File_ yang merekam peristiwa dan kesalahan sistem.
- **`journalctl`:** Utilitas untuk mengelola dan melihat log sistem dari `systemd`.
- **`dmesg`:** Perintah untuk menampilkan pesan _kernel buffer_.
- **`strace`:** Utilitas untuk melacak panggilan sistem dan sinyal yang diterima oleh suatu proses.
- **`lsof`:** Menampilkan _file_ yang terbuka oleh proses.
- **`gdb` (GNU Debugger):** Alat _debugging_ untuk program yang berjalan.
- **Core Dump:** Catatan keadaan suatu proses yang dihentikan secara tidak normal, berguna untuk _debugging_.
- **`coredumpctl`:** Utilitas untuk mengelola _core dump_ oleh `systemd`.
- **Segmentation Fault (Segfault):** Kesalahan di mana program mencoba mengakses memori yang tidak diizinkan.
- **System Hang:** Kondisi di mana sistem berhenti merespons.
- **Race Condition:** Situasi di mana perilaku program bergantung pada urutan yang tidak terkontrol dari kejadian yang bersamaan.

**Daftar Isi:**

- Strategi _Troubleshooting_ Sistematis.
- Menggunakan `journalctl` untuk Menganalisis Log Sistem.
- Memahami Pesan Kesalahan dan Kernel Panic.
- _Debugging_ Konfigurasi Sway/i3 yang Rusak.
- Menggunakan Alat _Debugging_ Lanjutan: `strace`, `lsof`.
- Menganalisis Kinerja dan Sumber Daya untuk Masalah.
- Memecahkan Masalah Jaringan, Audio, dan Display yang Sulit.
- Mencari Bantuan di Komunitas dan Forum.

**Sumber Referensi:**

- [Debugging (Arch Wiki)](https://wiki.archlinux.org/title/Debugging)
- [Journalctl (Arch Wiki)](https://wiki.archlinux.org/title/Journalctl)
- [strace Man Page](https://linux.die.net/man/1/strace)
- [lsof Man Page](https://linux.die.net/man/8/lsof)
- [i3 User's Guide: Debugging (Official)](https://i3wm.org/docs/userguide.html%23debugging)
- [Sway Wiki: Debugging (Official)](https://github.com/swaywm/sway/wiki/Debugging)

---

### Modul 4.3: Kustomisasi Tingkat Lanjut: Dotfiles, Script Hook, dan Integrasi Eksternal

**Deskripsi Konkret:**
Modul ini mengeksplorasi kustomisasi yang sangat mendalam, termasuk manajemen _dotfiles_, penggunaan _hook_ untuk peristiwa sistem, dan integrasi dengan teknologi eksternal atau _script_ kompleks.

**Konsep Dasar dan Filosofi:**
Di tingkat ahli, Anda tidak hanya menggunakan sistem, tetapi juga membentuknya. Filosofinya adalah **pemeliharaan konfigurasi**, **ekstensibilitas modular**, dan **interoperabilitas yang lancar**. Mengelola _dotfiles_ dengan rapi memastikan konfigurasi Anda portabel dan mudah disinkronkan. Menggunakan _hook_ memungkinkan sistem bereaksi secara dinamis. Integrasi eksternal (misalnya, dengan _script_ Python/Perl/Go, API) membuka kemungkinan tak terbatas.

**Sintaks Dasar/Contoh Implementasi Inti:**

- **Manajemen Dotfiles dengan Git (Pendekatan "bare repository"):**

  ```bash
  git init --bare $HOME/.dotfiles        # Inisialisasi bare repo
  alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME' # Alias untuk git
  config config status.showUntrackedFiles no # Sembunyikan untracked files
  config add .config/i3/config           # Tambahkan file konfigurasi ke repo
  config commit -m "Initial i3 config"
  config push origin master              # Push ke remote repository (misalnya, GitHub)
  ```

- **Contoh Script Sway Output Hook (di file Sway config):**

  ```ini
  # Untuk menjalankan script saat output berubah (misalnya, monitor dicolok)
  bindsym --locked XF86Display exec ~/.config/sway/scripts/monitor_toggle.sh
  # Atau menggunakan event:
  # exec_always 'swaymsg -t subscribe 'output' | while read; do ~/.config/sway/scripts/output_monitor.sh; done'
  ```

- **Integrasi dengan Bahasa Pemrograman (Contoh Python script untuk Waybar custom module):**
  File Python: `~/.config/waybar/scripts/weather.py`

  ```python
  #!/usr/bin/env python
  import json
  import requests

  API_KEY = "YOUR_API_KEY"
  CITY_ID = "YOUR_CITY_ID"
  URL = f"http://api.openweathermap.org/data/2.5/weather?id={CITY_ID}&appid={API_KEY}&units=metric"

  try:
      response = requests.get(URL)
      data = response.json()
      temp = data['main']['temp']
      icon = "" # Logic to map weather condition to icon

      print(json.dumps({
          "text": f"{icon} {temp}°C",
          "tooltip": f"{data['weather'][0]['description']}",
          "class": "weather"
      }))
  except Exception as e:
      print(json.dumps({
          "text": "Weather N/A",
          "tooltip": str(e),
          "class": "weather_error"
      }))
  ```

  **Modul Waybar config:**

  ```json
  "custom/weather": {
      "format": "{}",
      "interval": 600,
      "exec": "~/.config/waybar/scripts/weather.py"
  }
  ```

**Terminologi Kunci:**

- **Dotfiles:** _File_ konfigurasi yang diawali dengan titik (`.`) dan biasanya tersembunyi, seperti `.bashrc`, `.zshrc`, `.config/i3/config`.
- **Version Control (Git):** Sistem untuk melacak perubahan pada _file_ dan berkolaborasi (penting untuk _dotfiles_).
- **Bare Repository:** Jenis repositori Git yang hanya menyimpan data Git dan tidak memiliki _working directory_, ideal untuk _dotfiles_.
- **Hooks:** Mekanisme dalam perangkat lunak yang memungkinkan pengguna menjalankan _script_ kustom pada titik-titik tertentu dalam eksekusi program (misalnya, _event hook_ di Sway/i3).
- **IPC (Inter-Process Communication):** Mekanisme yang memungkinkan proses yang berbeda untuk berkomunikasi satu sama lain (misalnya, `i3-msg`/`swaymsg`).
- **DBus:** Sistem IPC yang banyak digunakan di Linux untuk komunikasi antar proses.
- **Scripting Language Integration:** Menggunakan bahasa seperti Python, Perl, Ruby, Go untuk menulis _script_ yang lebih kompleks dan berinteraksi dengan sistem.
- **Web API (Application Programming Interface):** Mekanisme untuk berinteraksi dengan layanan web.

**Daftar Isi:**

- Strategi Manajemen _Dotfiles_ dengan Git (dan tool lain seperti `GNU Stow`).
- Membuat dan Mengelola _Custom Script_ untuk Otomatisasi Lanjut.
- Memahami dan Menggunakan Sway/i3 _IPC_ dan _Event System_.
- Integrasi dengan Aplikasi Pihak Ketiga dan API Eksternal (contoh: modul cuaca di Waybar).
- Membuat _Custom Modules_ untuk Waybar/Polybar.
- Otomatisasi Lanjutan dengan `udev` Rules (mengelola perangkat keras).
- _Security Hardening_ Dasar untuk Lingkungan Minimalis.
- Berbagi dan Mendokumentasikan Konfigurasi Anda.

**Sumber Referensi:**

- [Dotfiles are meant to be forked (Mike C. Smith)](https://www.mikercsmith.com/blog/dotfiles-are-meant-to-be-forked/)
- [The Ultimate Guide to Managing your Dotfiles (Blog Post)](https://www.atlassian.com/git/tutorials/dotfiles)
- [Sway Wiki: IPC (Official)](https://github.com/swaywm/sway/wiki/IPC)
- [Arch Wiki: D-Bus](https://wiki.archlinux.org/title/D-Bus)
- [Arch Wiki: Udev](https://wiki.archlinux.org/title/Udev)
- [Custom Scripting Examples (Cari di GitHub: "dotfiles", "sway scripts", "i3 scripts")](https://github.com/search%3Fq%3Dsway%2Bscripts%26type%3Drepositories)

---

## Sumber Daya Komunitas & Sertifikasi

### Sumber Daya Komunitas

- **Forum Manjaro (Official):** Tempat yang bagus untuk pertanyaan spesifik Manjaro.
  - [Forum Manjaro](https://forum.manjaro.org/)
- **Arch Linux Wiki:** Sumber daya tak ternilai untuk setiap aspek sistem Linux berbasis Arch. Meskipun untuk Arch murni, sebagian besar informasinya relevan untuk Manjaro.
  - [Arch Wiki](https://wiki.archlinux.org/)
- **Reddit (Subreddits):**
  - `/r/unixporn`: Untuk inspirasi kustomisasi _desktop_ dan _dotfiles_.
  - `/r/i3wm`: Komunitas i3 Window Manager.
  - `/r/swaywm`: Komunitas Sway Window Manager.
  - `/r/manjaro`: Komunitas Manjaro Linux.
- **GitHub:** Cari "dotfiles", "i3 config", "sway config" untuk melihat konfigurasi orang lain dan belajar dari mereka.
- **IRC Channels (Freenode):** `#i3` atau `#sway` untuk bantuan _real-time_ (membutuhkan klien IRC).
- **Komunitas Discord:** Beberapa komunitas Linux memiliki server Discord yang aktif.

### Sertifikasi

Untuk bidang spesifik Manjaro Sway i3, tidak ada sertifikasi formal yang diakui secara luas. Penguasaan Anda akan dibuktikan melalui proyek personal, kontribusi _open source_, dan kemampuan Anda untuk memecahkan masalah. Namun, sertifikasi Linux umum dapat melengkapi keahlian Anda:

- **CompTIA Linux+:** Sertifikasi tingkat menengah yang menguji pengetahuan dasar hingga menengah tentang sistem operasi Linux. Ini akan memvalidasi pemahaman Anda tentang konsep Linux fundamental yang menjadi dasar Manjaro.
  - [CompTIA Linux+](https://www.comptia.org/certifications/linux)
- **LPIC (Linux Professional Institute Certification):** Serangkaian sertifikasi multi-tingkat (LPIC-1, LPIC-2, LPIC-3) yang mencakup berbagai aspek administrasi sistem Linux. LPIC-1 sangat relevan untuk memvalidasi kemampuan Anda dalam manajemen sistem dasar.
  - [Linux Professional Institute](https://www.lpi.org/)
- **RHCSA (Red Hat Certified System Administrator) / RHCE (Red Hat Certified Engineer):** Meskipun berfokus pada Red Hat Enterprise Linux, pengetahuan yang diperoleh sangat dapat ditransfer ke distribusi Linux lainnya, termasuk Manjaro, terutama dalam hal administrasi sistem dan _troubleshooting_. Ini adalah sertifikasi tingkat enterprise yang sangat dihormati.
  - [Red Hat Certifications](https://www.redhat.com/en/services/certification)

---

Kurikulum ini dirancang untuk menjadi panduan komprehensif Anda dalam menguasai Manjaro Sway i3. Ingat, belajar adalah proses berkelanjutan. Jangan ragu untuk bereksperimen, membuat kesalahan, dan yang terpenting, menikmati perjalanan Anda dalam dunia Linux yang kaya dan fleksibel!
