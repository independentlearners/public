# [Materi Kurikulum: Fase 1 - Pondasi][0]

**Estimasi Waktu Fase:** 30-40 jam
**Level:** Pemula

Fase ini akan memperkenalkan Anda pada konsep dasar Linux, Manjaro, dan filosofi _tiling window manager_. Anda akan belajar cara menginstal Manjaro Sway i3 dan melakukan konfigurasi awal yang esensial.

---

## Modul 1.1: Pengenalan Linux dan Distribusi Manjaro

### Deskripsi Konkret

Modul ini akan memperkenalkan Anda pada **Linux**, menjelaskan apa itu, bagaimana ia berkembang, dan mengapa Linux menjadi pilihan yang sangat populer di berbagai bidang, termasuk server, perangkat _mobile_, dan _desktop_. Kita juga akan membahas mengapa **Manjaro Linux** sering direkomendasikan sebagai titik awal yang baik, terutama bagi mereka yang tertarik pada kekuatan Arch Linux tetapi menginginkan pengalaman yang lebih mudah diakses dan stabil.

### Konsep Dasar dan Filosofi

**Linux** bukanlah sistem operasi tunggal, melainkan keluarga sistem operasi _open source_ yang dibangun di atas **kernel Linux**. Filosofi utama di balik Linux dan perangkat lunak _open source_ secara umum adalah **kebebasan**, **transparansi**, dan **kolaborasi**.

- **Kebebasan:** Pengguna bebas untuk menjalankan program, mempelajari bagaimana program bekerja, memodifikasinya, dan mendistribusikan ulang salinan. Ini memberdayakan pengguna untuk mengontrol perangkat lunak mereka, bukan sebaliknya.
- **Transparansi:** Kode sumber (cetak biru perangkat lunak) terbuka untuk siapa saja. Ini memungkinkan siapa pun untuk memeriksa, belajar, dan berkontribusi, serta membantu mengidentifikasi masalah keamanan atau _bug_.
- **Kolaborasi:** Pengembangan Linux dan banyak proyek _open source_ lainnya didorong oleh komunitas global yang bekerja sama, berbagi ide, dan berkontribusi kode.

Sebuah **Distribusi Linux** adalah sistem operasi lengkap yang terdiri dari **kernel Linux** dan kumpulan perangkat lunak lainnya, seperti utilitas **GNU** (GNU's Not Unix\!), _shell_ (seperti Bash), pustaka (_libraries_), aplikasi, dan mungkin _desktop environment_ atau _window manager_.

**Manjaro Linux** adalah salah satu dari banyak distribusi Linux. Keistimewaannya adalah ia **berbasis Arch Linux**. Ini berarti Manjaro mewarisi banyak keunggulan Arch, seperti model pembaruan **"Rolling Release"** (pembaruan berkelanjutan, bukan versi besar yang terpisah) dan akses ke repositori perangkat lunak yang sangat luas, termasuk **Arch User Repository (AUR)**. Namun, Manjaro menambahkan lapisan kemudahan penggunaan dan stabilitas melalui pengujian paket dan _installer_ grafisnya, menjadikannya pilihan yang lebih ramah bagi pemula Arch.

### Implementasi Inti

Pada modul ini, tidak ada sintaks kode atau perintah yang perlu diimplementasikan secara langsung karena kita berfokus pada konsep. Namun, untuk memulai eksplorasi, Anda akan sering berinteraksi dengan sistem melalui **Terminal** atau **Command Line Interface (CLI)**.

Misalnya, untuk memeriksa versi kernel Linux Anda, Anda dapat menggunakan perintah berikut di Terminal:

```bash
uname -r
```

Ini akan mengeluarkan nomor versi kernel yang sedang berjalan di sistem Anda. Ini adalah contoh sederhana bagaimana Anda akan mulai berinteraksi dengan Linux di tingkat dasar.

### Terminologi Kunci

- **Linux:** Merujuk pada keluarga sistem operasi _Unix-like_ yang menggunakan kernel Linux.
- **Kernel:** Inti dari sistem operasi. Kernel bertanggung jawab untuk mengelola sumber daya perangkat keras komputer dan menjembatani komunikasi antara _hardware_ dan _software_.
- **Open Source:** Model pengembangan perangkat lunak di mana kode sumbernya terbuka untuk publik, dapat diakses, dimodifikasi, dan didistribusikan ulang secara bebas.
- **GNU:** Proyek perangkat lunak bebas yang dimulai oleh Richard Stallman. Banyak alat dan utilitas yang digunakan di Linux, seperti _shell_ Bash, berasal dari proyek GNU.
- **Distribusi Linux (Distro):** Sistem operasi lengkap yang dibangun di atas kernel Linux, mencakup perangkat lunak tambahan yang dikemas bersama. Contohnya adalah Ubuntu, Fedora, Debian, dan Manjaro.
- **Arch Linux:** Sebuah distribusi Linux _rolling release_ yang dikenal karena kesederhanaan, fleksibilitas, dan pendekatan minimalisnya. Pengguna biasanya membangun sistem dari bawah ke atas.
- **Manjaro Linux:** Distribusi Linux berbasis Arch yang berfokus pada kemudahan penggunaan dan aksesibilitas. Ia menawarkan instalasi yang lebih sederhana dan _desktop environment_ yang sudah dikonfigurasi.
- **Rolling Release:** Model pembaruan perangkat lunak di mana sistem terus-menerus menerima pembaruan kecil secara berkala, daripada melalui "versi" besar yang terpisah. Ini berarti Anda selalu menjalankan perangkat lunak terbaru.
- **Fixed Release:** Model pembaruan di mana distribusi mengeluarkan versi besar secara berkala (misalnya, setiap 6 bulan atau 2 tahun) dengan siklus dukungan yang tetap.
- **Repository (Repo):** Tempat penyimpanan sentral di mana paket-paket perangkat lunak (aplikasi, _library_, dll.) disimpan dan dapat diunduh oleh manajer paket.
- **Arch User Repository (AUR):** Repositori yang dikelola komunitas untuk pengguna Arch Linux dan turunannya. Ini berisi _script_ (disebut PKGBUILD) yang memungkinkan pengguna mengkompilasi perangkat lunak dari kode sumber atau menginstal paket yang tidak tersedia di repositori resmi.

### Daftar Isi

- Apa itu Linux? Sejarah Singkat dan Evolusinya.
- Filosofi _Open Source_: Kebebasan, Transparansi, dan Kolaborasi.
- Memahami Konsep Kernel dan Distribusi Linux.
- Mengapa Memilih Manjaro? Keunggulan dan Fitur Khasnya.
- Perbedaan Antara _Rolling Release_ dan _Fixed Release_ dalam Konteks Manjaro.
- Pengenalan Singkat tentang Arch User Repository (AUR) dan Relevansinya.

### Sumber Referensi

- **Apa itu Linux?**
  - [Linux Foundation: What is Linux?](https://www.linuxfoundation.org/about/who-we-are/what-is-linux)
  - [Wikipedia: Linux](https://en.wikipedia.org/wiki/Linux)
- **Manjaro Linux:**
  - [Situs Web Resmi Manjaro](https://manjaro.org/)
  - [Manjaro Wiki](https://wiki.manjaro.org/index.php?title=Main_Page)
- **Rolling Release vs. Fixed Release:**
  - [MakeUseOf: Rolling Release vs. Fixed Release](https://www.makeuseof.com/linux-fixed-rolling-release-explained/)
- **Arch User Repository (AUR):**
  - [Arch Wiki: Arch User Repository](https://wiki.archlinux.org/title/Arch_User_Repository)

---

## Modul 1.2: Mengenal Window Manager (WM) dan Filosofi Tiling WM (i3/Sway)

### Deskripsi Konkret

Modul ini akan membawa Anda memahami salah satu komponen paling fundamental dari lingkungan _desktop_ Linux yang minimalis: **Window Manager (WM)**. Kita akan melihat bagaimana WM berbeda dari _Desktop Environment_ (DE) yang mungkin lebih familiar bagi pengguna baru, dan secara khusus mendalami **Filosofi _Tiling Window Manager_** seperti **i3** dan **Sway**, yang menjadi inti dari pengalaman Manjaro Sway i3 Anda.

### Konsep Dasar dan Filosofi

Ketika Anda menggunakan komputer, Anda berinteraksi dengan **jendela** aplikasi. Program yang bertanggung jawab mengatur bagaimana jendela-jendela ini muncul di layar Anda, bagaimana Anda dapat memindahkannya, mengubah ukurannya, atau meminimalkannya, adalah **Window Manager (WM)**.

Di dunia Linux, ada dua kategori besar untuk "lingkungan _desktop_" Anda:

1.  **Desktop Environment (DE):** Ini adalah paket perangkat lunak lengkap yang menyediakan pengalaman _desktop_ yang kaya fitur. DE biasanya mencakup **Window Manager** itu sendiri, ditambah _file manager_ (penjelajah berkas), panel atau bilah tugas, menu aplikasi, pengaturan sistem yang terintegrasi, dan berbagai utilitas lainnya. Contoh DE yang populer adalah GNOME, KDE Plasma, dan XFCE. Mereka dirancang untuk menyediakan pengalaman yang "siap pakai" dan familiar bagi pengguna yang beralih dari Windows atau macOS.

2.  **Window Manager (WM):** Ini adalah komponen yang jauh lebih fokus. WM hanya mengelola jendela. Ia tidak menyediakan _file manager_, panel, atau menu aplikasi secara bawaan. Anda harus memilih dan menginstal komponen-komponen ini secara terpisah, lalu mengkonfigurasinya agar bekerja sama dengan WM Anda. Pendekatan ini menawarkan **fleksibilitas** dan **kontrol** yang jauh lebih besar, memungkinkan Anda membangun lingkungan _desktop_ persis seperti yang Anda inginkan, tanpa _bloat_ atau fitur yang tidak Anda butuhkan.

**Tiling Window Manager (TWM)** seperti **i3** dan **Sway** adalah sub-kategori dari WM yang memiliki filosofi sangat spesifik:

- **Efisiensi dan Minimalisme:** Tujuan utamanya adalah memaksimalkan ruang layar dan meminimalkan gangguan. Jendela tidak tumpang tindih satu sama lain secara _default_.
- **Kontrol Penuh Melalui Keyboard:** TWM dirancang untuk dikendalikan hampir sepenuhnya dengan _keyboard_. Ini memungkinkan alur kerja yang sangat cepat dan efisien, mengurangi kebutuhan untuk meraih _mouse_ atau _trackpad_.
- **Pengaturan Otomatis (Tiling):** Alih-alih membiarkan Anda menyeret dan menjatuhkan jendela secara bebas (_floating_), TWM secara otomatis menempatkan jendela dalam tata letak non-tumpang tindih yang disebut "tiles" (ubin) saat Anda membukanya. Anda dapat dengan cepat membagi layar menjadi beberapa bagian untuk menampung banyak jendela sekaligus.

### i3 vs. Sway: X11 vs. Wayland

- **i3 (dan variannya i3-gaps):** Ini adalah TWM klasik yang dirancang untuk **X11 (X Window System)**. X11 telah menjadi protokol _display_ grafis standar di sebagian besar sistem Linux selama beberapa dekade. i3 dikenal karena kesederhanaan, kecepatan, dan file konfigurasinya yang berbasis teks dan mudah dipahami, menjadikannya pilihan favorit bagi mereka yang ingin kontrol penuh.

- **Sway:** Ini adalah TWM modern yang dirancang untuk **Wayland**. **Wayland** adalah protokol _display_ grafis generasi berikutnya yang bertujuan untuk menggantikan X11. Wayland menawarkan arsitektur yang lebih sederhana, keamanan yang lebih baik, dan kinerja yang lebih mulus, terutama untuk grafis modern dan layar beresolusi tinggi. Sway adalah "klon" i3 untuk Wayland; ia kompatibel dengan sebagian besar konfigurasi i3, sehingga jika Anda belajar mengkonfigurasi i3, Anda juga akan tahu cara mengkonfigurasi Sway.

Memilih antara i3 dan Sway (dan X11 atau Wayland) bergantung pada preferensi Anda dan kompatibilitas perangkat keras. Manjaro Sway i3 memberikan pengalaman siap pakai dengan Sway di Wayland, namun pemahaman tentang i3 (untuk X11) juga akan sangat relevan karena kesamaan konfigurasinya.

### Implementasi Inti

Karena ini adalah modul konseptual, tidak ada sintaks kode yang akan Anda _eksekusi_. Namun, penting untuk memahami bagaimana i3/Sway secara internal mengelola jendela. Misalnya, saat Anda membuka dua aplikasi, mereka akan otomatis "ditile" (diubinkan) berdampingan:

```
+----------------+----------------+
|    Terminal    |    Browser     |
|                |                |
|                |                |
|                |                |
|                |                |
|                |                |
+----------------+----------------+
```

Jika Anda membuka aplikasi ketiga, ia mungkin akan membagi salah satu jendela yang sudah ada:

```
+----------------+----------------+
|    Terminal    |    Browser     |
|                +----------------+
|                |   Editor Teks  |
|                |                |
|                |                |
|                |                |
+----------------+----------------+
```

Dan ini semua terjadi secara otomatis. Anda akan menggunakan **kombinasi tombol keyboard** (disebut **keybinding**) untuk mengubah tata letak ini, berpindah antar jendela, atau memindahkan jendela ke ruang kerja yang berbeda.

### Terminologi Kunci

- **Window Manager (WM):** Perangkat lunak yang mengelola penempatan, ukuran, dan tampilan jendela aplikasi di layar. WM bisa menjadi bagian dari DE atau berdiri sendiri.
- **Desktop Environment (DE):** Kumpulan perangkat lunak lengkap yang menyediakan lingkungan _desktop_ grafis, termasuk WM, _file manager_, panel, dll. (Contoh: GNOME, KDE Plasma).
- **Tiling Window Manager (TWM):** Jenis WM yang secara otomatis mengatur jendela dalam tata letak non-tumpang tindih ("tiles") untuk memaksimalkan ruang layar.
- **Floating Window:** Jendela yang dapat dipindahkan dan diubah ukurannya secara bebas di layar, mirip dengan perilaku jendela di Windows atau macOS. WM dapat beralih antara mode _tiling_ dan _floating_.
- **Keybinding:** Kombinasi tombol keyboard yang telah ditentukan untuk memicu tindakan atau perintah tertentu. Ini adalah cara utama berinteraksi dengan TWM.
- **Workspace (Ruang Kerja):** Lingkungan _desktop_ virtual terpisah yang digunakan untuk mengelompokkan aplikasi. Anda dapat memiliki banyak _workspace_ dan beralih di antaranya dengan cepat. Ini membantu menjaga _desktop_ tetap rapi.
- **Container:** Istilah yang digunakan dalam i3/Sway untuk merujuk pada jendela individual atau kelompok jendela (misalnya, jendela dalam split horizontal atau vertikal).
- **X11 (X Window System):** Protokol _display_ grafis tradisional yang telah lama menjadi dasar grafis di Linux. i3 beroperasi di atas X11.
- **Wayland:** Protokol _display_ grafis modern yang dirancang untuk menggantikan X11, menawarkan kinerja, keamanan, dan fitur modern yang lebih baik. Sway beroperasi di atas Wayland.
- **Compositor:** Di Wayland, _compositor_ adalah WM yang juga melakukan tugas-tugas _rendering_ grafis. Sway adalah sebuah _compositor_.

### Daftar Isi

- Peran dan Fungsi _Window Manager_.
- Perbedaan Kunci antara _Window Manager_ dan _Desktop Environment_.
- Pengantar _Tiling Window Manager_: Apa itu, dan mengapa pengguna memilihnya.
- Filosofi di Balik Desain i3 dan Sway: Efisiensi dan Kontrol Keyboard.
- Konsep _Tiling_, _Floating_, dan _Workspaces_.
- Perbandingan X11 vs. Wayland dan Relevansinya untuk i3/Sway.

### Sumber Referensi

- **Panduan Pengguna Resmi i3:**
  - [i3 User's Guide: Usage](https://i3wm.org/docs/userguide.html%23usage) (Bagian ini menjelaskan cara interaksi dasar)
- **Wiki Sway (Penggunaan Dasar):**
  - [Sway User's Wiki: Basic Usage](https://github.com/swaywm/sway/wiki/Basic-Usage)
- **Memahami Window Manager:**
  - [MakeUseOf: What Is a Window Manager and Why Would You Use One?](https://www.makeuseof.com/what-is-a-window-manager/)
- **X11 vs. Wayland:**
  - [FreeCodeCamp: X11 vs. Wayland: What's the Difference and Which is Better?](https://www.freecodecamp.org/news/x11-vs-wayland/)

---

## Modul 1.3: Persiapan Instalasi Manjaro Sway i3

### Deskripsi Konkret

Sebelum Anda dapat menyelami dunia Manjaro Sway i3, Anda perlu menyiapkan "landasan" yang kokoh. Modul ini akan memandu Anda melalui semua langkah persiapan krusial sebelum memulai proses instalasi. Ini termasuk **mengunduh _ISO image_** Manjaro yang benar, **memverifikasi integritasnya**, **membuat media instalasi _bootable_**, dan yang terpenting, **merencanakan partisi _disk_** Anda. Persiapan yang cermat di fase ini akan mencegah masalah di kemudian hari dan memastikan pengalaman instalasi yang mulus.

### Konsep Dasar dan Filosofi

Filosofi di balik persiapan instalasi adalah **pencegahan adalah kunci**. Mengambil waktu untuk menyiapkan segala sesuatunya dengan benar akan menghemat banyak frustrasi dan potensi kehilangan data di kemudian hari. Ini seperti mempersiapkan bahan-bahan dan alat sebelum Anda memasak hidangan kompleks; jika bahannya salah atau alatnya tumpul, hasilnya tidak akan optimal.

1.  **ISO Image:** Ini adalah "cetak biru" lengkap dari sistem operasi yang akan Anda instal. Mirip dengan file `.exe` atau `.dmg` untuk menginstal perangkat lunak di Windows atau macOS, tetapi untuk seluruh sistem operasi.
2.  **Verifikasi Integritas:** Mengapa ini penting? Ketika Anda mengunduh file besar dari internet, ada kemungkinan kecil ia bisa rusak selama transmisi atau bahkan sengaja dimodifikasi oleh pihak yang tidak bertanggung jawab. **Checksum** (seperti SHA256) adalah "sidik jari" digital dari sebuah file. Dengan membandingkan _checksum_ dari file yang Anda unduh dengan _checksum_ yang disediakan oleh sumber resmi, Anda dapat memastikan bahwa file Anda 100% utuh dan asli.
3.  **Media Instalasi _Bootable_:** Sistem operasi tidak bisa diinstal dari file di _hard disk_ yang sedang Anda gunakan. Anda memerlukan media terpisah (biasanya _USB drive_) yang dapat "dibaca" oleh komputer Anda saat dinyalakan (boot). Media ini akan memuat _installer_ Manjaro.
4.  **Partisi _Disk_:** Ini adalah langkah yang paling krusial dan membutuhkan pemahaman yang cermat. **Partisi** adalah pembagian logis dari _hard disk_ fisik Anda menjadi beberapa segmen. Setiap segmen ini dapat diformat dengan _file system_ yang berbeda dan digunakan untuk tujuan yang berbeda. Anda perlu memutuskan bagaimana Anda ingin membagi _hard disk_ Anda untuk Manjaro. Pemahaman yang salah di sini bisa menyebabkan kehilangan data atau sistem yang tidak dapat di-_boot_.

### Implementasi Inti

#### 1. Verifikasi Integritas ISO

Setelah Anda mengunduh file ISO Manjaro (misalnya, `manjaro-sway-24.0.4-240608-linux67.iso`), Anda akan menemukan file _checksum_ SHA256 di halaman unduhan resmi Manjaro.

Untuk memverifikasi integritas file ISO di **Terminal Linux atau macOS**:

```bash
sha256sum /path/to/your/manjaro-sway-iso.iso
```

**Contoh Output:**

```ini
89c7d1e2f3g4h5i6j7k8l9m0n1o2p3q4r5s6t7u8v9w0x1y2z3a4b5c6d7e8f901  /path/to/your/manjaro-sway-iso.iso
```

Bandingkan output SHA256 ini dengan nilai yang diberikan di situs web resmi Manjaro. Jika cocok, file Anda aman.

#### 2\. Membuat Media Instalasi Bootable

Ada beberapa alat untuk membuat _bootable USB drive_.

- **Balena Etcher (Rekomendasi untuk Pemula):** Ini adalah alat grafis lintas platform (Windows, macOS, Linux) yang sangat mudah digunakan. Cukup pilih file ISO Anda, pilih _USB drive_ Anda, dan klik "Flash\!".
  ```bash
  # Tidak ada perintah CLI untuk Balena Etcher, gunakan GUI-nya.
  ```
- **Ventoy:** Alat yang sangat direkomendasikan untuk pengguna yang lebih berpengalaman atau ingin memiliki banyak ISO di satu _USB drive_. Ventoy mengubah _USB drive_ Anda menjadi _bootable_ sekali, dan Anda hanya perlu menyalin file ISO ke dalamnya.
  ```bash
  # Tidak ada perintah CLI untuk Ventoy setelah instalasi awal Ventoy pada USB.
  # Cukup drag-and-drop file .iso ke USB drive Ventoy.
  ```
- **Perintah `dd` (Khusus Linux/macOS - GUNAKAN DENGAN HATI-HATI\!):** Ini adalah perintah baris yang kuat tetapi sangat berbahaya jika salah digunakan. Salah menargetkan `of` (_output file_) dapat menghapus seluruh _hard disk_ Anda.
  - **Identifikasi _USB drive_ Anda:**
    ```bash
    lsblk
    # Cari USB drive Anda, misalnya /dev/sdb atau /dev/sdc (BUKAN /dev/sda!)
    ```
  - **Tulis ISO ke USB (ganti `/dev/sdX` dengan nama _device_ USB Anda yang benar):**
    ```bash
    sudo dd if=/path/to/your/manjaro-sway-iso.iso of=/dev/sdX bs=4M status=progress
    # Contoh: sudo dd if=~/Downloads/manjaro-sway.iso of=/dev/sdb bs=4M status=progress
    ```
    `bs=4M` berarti ukuran blok 4 Megabyte, yang mempercepat proses. `status=progress` menunjukkan kemajuan.

#### 3\. Perencanaan Partisi Disk

Ini adalah bagian yang paling kompleks dan paling penting. Anda perlu memutuskan:

- **Apakah Anda akan melakukan _Dual Boot_ (Manjaro bersama Windows/macOS) atau Instalasi Tunggal (Manjaro saja)?**

  - **Dual Boot:** Membutuhkan ruang kosong yang cukup di _hard disk_ Anda. Anda harus mengecilkan partisi sistem operasi yang ada (misalnya, Windows) untuk membuat ruang. Ini seringkali lebih rumit.
  - **Instalasi Tunggal:** Akan menghapus semua data di _disk_ yang Anda pilih. Ini lebih sederhana tetapi pastikan Anda sudah mencadangkan semua data penting.

- **Skema Partisi Dasar yang Direkomendasikan untuk Linux:**

  - **Partisi Root (`/`):** Ini adalah partisi utama tempat seluruh sistem operasi Linux akan diinstal. Semua file sistem, program, dan konfigurasi akan berada di sini. Minimal 25-30GB, tetapi 50GB atau lebih disarankan.
  - **Partisi Home (`/home`):** Ini adalah partisi opsional tetapi sangat disarankan. Di sinilah semua file pribadi Anda (dokumen, gambar, video, _dotfiles_, dll.) akan disimpan. Jika Anda memisahkannya dari partisi _root_, Anda dapat menginstal ulang Manjaro di masa depan tanpa kehilangan data pribadi Anda di `/home`. Berikan sebagian besar ruang _disk_ Anda di sini.
  - **Partisi Swap:** Ini adalah area di _hard disk_ yang digunakan sebagai memori virtual ketika RAM fisik Anda penuh. Ukuran yang disarankan adalah sekitar 1-1.5 kali ukuran RAM Anda (jika RAM Anda 8GB, gunakan 8-12GB untuk _swap_). Untuk sistem dengan RAM sangat besar (16GB ke atas), _swap_ tidak terlalu kritis tetapi tetap direkomendasikan.

#### Contoh Skema Partisi untuk Instalasi Tunggal (contoh untuk _disk_ 250GB):

| Mount Point | Ukuran (Contoh) | Tipe File System | Deskripsi                                         |
| :---------- | :-------------- | :--------------- | :------------------------------------------------ |
| `/`         | 50GB            | `ext4`           | Sistem operasi Manjaro                            |
| `/home`     | 190GB           | `ext4`           | File pribadi Anda                                 |
| `[SWAP]`    | 10GB            | `linuxswap`      | Memori Virtual (sesuai kebutuhan RAM Anda)        |
| `/boot/efi` | 300-500MB       | `fat32`          | **Wajib untuk sistem UEFI\!** Untuk _bootloader_. |

**Penting:**

- **Sistem UEFI:** Komputer modern menggunakan **UEFI** (Unified Extensible Firmware Interface) sebagai pengganti **BIOS** (Basic Input/Output System) lama. Jika komputer Anda menggunakan UEFI, Anda **WAJIB** membuat partisi **EFI System Partition (ESP)** yang diformat sebagai `FAT32` (biasanya 300-500MB) dan di-_mount_ ke `/boot/efi`. Tanpa ini, sistem Anda tidak akan bisa di-_boot_.
- **Backup Data:** Selalu, selalu, **SELALU** cadangkan semua data penting Anda ke _external drive_ sebelum melakukan instalasi sistem operasi. Risiko kehilangan data itu nyata.

### Terminologi Kunci

- **ISO Image:** File tunggal yang berisi salinan lengkap dari seluruh sistem file yang dapat di-_boot_ dari suatu cakram atau media.
- **Bootable Drive:** Media penyimpanan (seperti _USB flash drive_ atau DVD) yang telah dikonfigurasi untuk memulai komputer dan menjalankan sistem operasi atau _installer_.
- **Checksum (SHA256, MD5):** Nilai unik yang dihasilkan dari suatu file. Digunakan untuk memverifikasi bahwa file yang diunduh tidak rusak atau dimodifikasi selama transmisi. SHA256 lebih aman daripada MD5.
- **Partisi Disk:** Pembagian logis dari _hard disk_ menjadi beberapa bagian terpisah. Setiap partisi dapat memiliki _file system_ sendiri.
- **Mount Point:** Direktori di _file system_ Linux tempat partisi atau perangkat lain "dipasang" dan dapat diakses (misalnya, `/`, `/home`, `/boot/efi`).
- **Root Partition (`/`):** Partisi utama di Linux tempat direktori _root_ dan seluruh struktur _file system_ Linux berada. Ini adalah lokasi instalasi sistem operasi.
- **Home Partition (`/home`):** Partisi khusus untuk menyimpan data pengguna. Memisahkannya dari _root_ memudahkan pembaruan atau instalasi ulang OS.
- **Swap Partition:** Area pada _hard disk_ yang digunakan sebagai memori virtual (jika RAM penuh) atau untuk _hibernation_.
- **File System:** Struktur yang digunakan untuk mengatur dan menyimpan file pada media penyimpanan (misalnya, `ext4`, `NTFS`, `FAT32`).
- **ext4 (Fourth Extended Filesystem):** _File system_ jurnalistik yang paling umum digunakan di Linux.
- **FAT32 (File Allocation Table32):** _File system_ yang kompatibel dengan banyak sistem operasi, sering digunakan untuk partisi EFI System Partition (ESP) dan _USB drive_.
- **UEFI (Unified Extensible Firmware Interface):** Antarmuka _firmware_ modern untuk komputer yang menggantikan BIOS. Menangani proses _booting_ sebelum sistem operasi dimuat.
- **BIOS (Basic Input/Output System):** _Firmware_ lama yang digunakan oleh komputer untuk menginisialisasi _hardware_ saat _booting_.
- **EFI System Partition (ESP):** Partisi khusus (FAT32) yang wajib ada pada sistem UEFI untuk menyimpan _bootloader_ dan _file_ yang diperlukan untuk _booting_.
- **Dual Boot:** Konfigurasi di mana dua atau lebih sistem operasi diinstal pada satu komputer, memungkinkan pengguna memilih OS mana yang akan dijalankan saat _boot_.

### Daftar Isi

- Mengunduh Manjaro Sway ISO yang Tepat.
- Pentingnya Verifikasi Integritas ISO dengan SHA256 Checksum.
- Metode Membuat _Bootable USB Drive_: Balena Etcher, Ventoy, atau `dd`.
- Pengenalan Konsep Partisi _Disk_ dan Jenis-Jenis Partisi Kritis (`/`, `/home`, `swap`).
- Memahami Peran Partisi EFI System Partition (ESP) untuk Sistem UEFI.
- Panduan Perencanaan Skema Partisi untuk Instalasi Tunggal dan _Dual Boot_ (Pertimbangan Awal).
- Tips Penting: Cadangkan Data Anda\!
- Pengaturan BIOS/UEFI untuk Booting dari USB.

### Sumber Referensi

- **Halaman Unduhan Resmi Manjaro (Pilih Manjaro Sway):**
  - [Manjaro Download Page](https://manjaro.org/download/)
- **Balena Etcher (Alat Pembuat USB Bootable Grafis):**
  - [Balena Etcher Official Website](https://etcher.balena.io/)
- **Ventoy (Alat Pembuat USB Bootable Multi-ISO):**
  - [Ventoy Official Website](https://www.ventoy.net/)
- **Arch Wiki: Partitioning (Referensi Teknis Mendalam):**
  - [Arch Wiki: Partitioning](https://wiki.archlinux.org/title/Partitioning)
- **Arch Wiki: UEFI (Untuk Pemahaman Lebih Lanjut tentang UEFI/ESP):**
  - [Arch Wiki: Unified Extensible Firmware Interface](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface)
- **Video Tutorial (Cari di YouTube):** Cari "How to create Manjaro bootable USB" atau "Manjaro partition guide" untuk panduan visual yang lebih spesifik. Pastikan video yang Anda tonton relevan dengan versi Manjaro Sway terbaru.

**Visualisasi (Opsional tapi Direkomendasikan):**
Gambar visual sangat direkomendasikan di sini untuk menjelaskan skema partisi disk. Diagram yang menunjukkan bagaimana _hard disk_ dibagi menjadi partisi `/`, `/home`, `swap`, dan `/boot/efi` akan sangat membantu pemahaman. Ilustrasi juga dapat ditambahkan untuk proses Balena Etcher atau `dd`.

---

## Modul 1.4: Instalasi Manjaro Sway i3

### Deskripsi Konkret

Setelah semua persiapan matang, modul ini akan memandu Anda secara langsung melalui proses **instalasi Manjaro Sway i3** pada komputer Anda. Kita akan membahas setiap langkah dalam _installer_ grafis Manjaro, **Calamares**, mulai dari _booting_ media instalasi hingga konfigurasi akun pengguna pertama Anda. Ini adalah langkah paling mendebarkan karena Anda akan melihat sistem Anda mulai terbentuk!

### Konsep Dasar dan Filosofi

Proses instalasi adalah jembatan yang menghubungkan _hardware_ fisik atau virtual Anda dengan sistem operasi yang berfungsi penuh. Filosofinya adalah **membuat fondasi yang benar**. Setiap pilihan yang Anda buat selama instalasi, mulai dari pemilihan bahasa hingga skema partisi, akan memengaruhi bagaimana sistem Anda beroperasi. Manjaro menggunakan _installer_ grafis bernama **Calamares** untuk menyederhanakan prosesnya. Ini adalah kontras yang signifikan dengan instalasi Arch Linux "murni" yang sepenuhnya berbasis teks, membuat Manjaro jauh lebih mudah diakses oleh pemula.

Calamares akan memandu Anda melalui serangkaian layar di mana Anda akan memberikan informasi penting yang diperlukan untuk menyiapkan sistem operasi.

### Implementasi Inti

Dalam modul ini, Anda akan berinteraksi sebagian besar dengan antarmuka grafis _installer_ Calamares, jadi tidak ada sintaks baris perintah yang perlu Anda masukkan secara manual. Namun, memahami pilihan yang disajikan oleh _installer_ adalah kuncinya.

**Langkah-langkah Umum dalam Installer Calamares:**

1.  **Boot dari Media Instalasi:**

    - Nyalakan komputer Anda dan pastikan ia _boot_ dari _USB drive_ atau DVD yang telah Anda buat di Modul 1.3. Anda mungkin perlu menekan tombol tertentu saat _startup_ (misalnya, `F2`, `F10`, `F12`, `Del`) untuk masuk ke menu _boot_ atau pengaturan BIOS/UEFI.
    - Setelah _boot_, Anda akan disambut oleh menu _boot_ Manjaro. Pilih opsi untuk **"Boot Manjaro Architect / Installer"** atau opsi serupa yang mengarahkan Anda ke sesi _live_ Manjaro.

2.  **Manjaro Live Environment:**

    - Anda akan masuk ke **Manjaro Live Environment**. Ini adalah sistem operasi Manjaro yang berjalan langsung dari USB Anda tanpa menginstal apa pun ke _hard disk_. Ini memungkinkan Anda untuk mencoba Manjaro, memeriksa kompatibilitas _hardware_, atau bahkan menjelajahi sistem sebelum menginstalnya.
    - Cari ikon **"Install Manjaro"** di _desktop_ dan klik dua kali untuk memulai _installer_ Calamares.

3.  **Memilih Bahasa:**

    - Pilih bahasa yang akan digunakan oleh _installer_ dan sistem operasi Anda.

4.  **Memilih Lokasi:**

    - Pilih wilayah dan zona waktu Anda. Ini penting agar jam sistem Anda selalu benar.

5.  **Pengaturan Keyboard:**

    - Pilih model _keyboard_ Anda dan tata letak bahasa. Pastikan Anda mengetesnya di kotak teks yang tersedia.

6.  **Partisi Disk (Ini adalah Langkah Krusial\!):**

    - Calamares akan menawarkan beberapa opsi partisi:
      - **"Erase disk" (Hapus disk):** Ini akan menghapus semua data di _hard disk_ yang Anda pilih dan menginstal Manjaro. **Gunakan ini dengan sangat hati-hati dan hanya jika Anda sudah mencadangkan semua data penting.**
      - **"Install alongside" (Instal berdampingan):** Jika Anda memiliki sistem operasi lain (misalnya, Windows), opsi ini akan mencoba mengecilkan partisi OS yang sudah ada dan membuat ruang untuk Manjaro secara otomatis.
      - **"Manual partitioning" (Partisi manual):** **Ini adalah opsi yang disarankan dan paling fleksibel jika Anda sudah memahami konsep partisi dari Modul 1.3.** Anda akan dapat membuat, menghapus, mengubah ukuran, dan menentukan _mount point_ untuk setiap partisi (misalnya, `/`, `/home`, `swap`, `/boot/efi`). Jika Anda berencana menggunakan `/home` terpisah atau memiliki konfigurasi _disk_ khusus, ini adalah jalan yang harus Anda tempuh. Ikuti skema partisi yang Anda rencanakan di Modul 1.3. Pastikan partisi `/boot/efi` (FAT32) diatur jika Anda menggunakan UEFI.

7.  **Membuat Akun Pengguna:**

    - Anda akan diminta untuk membuat nama pengguna, nama lengkap, dan kata sandi untuk akun Anda.
    - Anda juga dapat memilih untuk menggunakan kata sandi yang sama untuk akun administrator (root) atau mengatur kata sandi yang berbeda. Untuk tujuan pembelajaran, menggunakan kata sandi yang sama seringkali lebih mudah, tetapi untuk keamanan lebih baik gunakan yang berbeda.
    - Pilih **hostname** (nama komputer) untuk sistem Anda.

8.  **Ringkasan Instalasi:**

    - Calamares akan menampilkan ringkasan dari semua pilihan yang Anda buat. **Tinjau ini dengan cermat\!** Pastikan tidak ada kesalahan, terutama pada bagian partisi. Jika sudah yakin, klik "Install".

9.  **Proses Instalasi Akhir:**

    - _Installer_ akan mulai menyalin _file_ ke _hard disk_ Anda dan mengkonfigurasi sistem. Proses ini bisa memakan waktu beberapa menit hingga satu jam, tergantung pada kecepatan komputer Anda.
    - Setelah selesai, Anda akan diminta untuk me-restart komputer. Pastikan untuk mencabut _USB drive_ instalasi Anda saat diminta.

10. **Login Pertama:**

    - Setelah _restart_, Anda akan melihat _bootloader_ GRUB (jika Anda memiliki konfigurasi _dual boot_) dan kemudian akan _boot_ ke Manjaro Sway i3 yang baru diinstal.
    - Anda akan melihat layar _login_ (biasanya **Greetd** dengan **Sway Greeter**). Masukkan nama pengguna dan kata sandi yang Anda buat. Selamat, Anda sekarang berada di _desktop_ Manjaro Sway i3 Anda\!

### Terminologi Kunci

- **Live Environment:** Sebuah sistem operasi yang dapat dijalankan langsung dari media _bootable_ (seperti USB atau DVD) tanpa perlu menginstalnya ke _hard disk_ komputer. Berguna untuk mencoba distro, mendiagnosis masalah, atau menyelamatkan data.
- **Calamares:** _Installer_ grafis yang digunakan oleh banyak distribusi Linux (termasuk Manjaro) untuk mempermudah proses instalasi.
- **Bootloader (GRUB):** Program kecil yang memuat sistem operasi Anda saat komputer dinyalakan. Jika Anda melakukan _dual boot_, GRUB akan memberikan Anda pilihan OS mana yang ingin Anda jalankan.
- **Hostname:** Nama unik yang diberikan kepada komputer dalam jaringan. Ini membantu mengidentifikasi perangkat Anda dalam lingkungan jaringan.
- **Account Administrator (Root User):** Akun pengguna dengan hak akses tertinggi dalam sistem Linux. Pengguna _root_ dapat melakukan perubahan apa pun pada sistem.
- **User Account:** Akun pengguna standar dengan hak akses terbatas, yang Anda gunakan untuk aktivitas sehari-hari. Ini adalah praktik keamanan terbaik untuk tidak menggunakan akun _root_ untuk tugas harian.
- **Locale:** Pengaturan sistem yang menentukan format bahasa, negara, waktu, tanggal, dan mata uang yang digunakan di sistem operasi Anda.
- **Timezone:** Pengaturan yang menunjukkan zona waktu geografis Anda, memastikan waktu sistem Anda akurat.

### Daftar Isi

- Booting dari Media Instalasi dan Memulai Manjaro Live Environment.
- Menjalankan _Installer_ Calamares.
- Langkah-langkah Konfigurasi Awal: Pemilihan Bahasa, Lokasi, dan Tata Letak Keyboard.
- **Panduan Mendalam tentang Opsi Partisi Disk dalam Calamares:**
  - "Erase disk" (Hapus disk).
  - "Install alongside" (Instal berdampingan).
  - "Manual partitioning" (Partisi manual) dan penerapan skema partisi yang direncanakan.
- Pembuatan Akun Pengguna dan Pengaturan Kata Sandi.
- Tinjauan Ringkasan Instalasi dan Memulai Proses Instalasi.
- _Reboot_ Sistem dan Login Pertama ke Manjaro Sway i3.

### Sumber Referensi

- **Panduan Instalasi Manjaro (Manjaro Wiki):**
  - [Installation Guides - Manjaro Wiki](https://wiki.manjaro.org/index.php?title=Installation_Guides) (Cari panduan yang paling sesuai dengan metode instalasi Anda, baik itu UEFI/BIOS, _single boot_, atau _dual boot_).
- **Video Tutorial Instalasi Manjaro Sway (Cari di YouTube):**
  - Cari tutorial video terbaru yang spesifik untuk "Manjaro Sway install" atau "Manjaro i3 install". Video dapat memberikan panduan visual yang sangat membantu untuk setiap langkah _installer_. Pastikan sumbernya terkemuka.

**Visualisasi (Opsional tapi Direkomendasikan):**
Sangat disarankan untuk menyertakan _screenshot_ dari setiap langkah _installer_ Calamares. Ini akan sangat membantu pembelajar untuk mengikuti prosesnya, terutama pada bagian pemilihan partisi disk yang bisa menjadi kompleks.

---

## Modul 1.5: Pengenalan Lingkungan Sway/i3 Dasar

### Deskripsi Konkret

Selamat\! Setelah berhasil menginstal Manjaro Sway i3, kini saatnya Anda berinteraksi dengan lingkungan _desktop_ baru Anda. Modul ini akan memperkenalkan Anda pada **antarmuka dasar Sway/i3**. Anda akan belajar bagaimana jendela diatur secara otomatis, bagaimana **_keybindings_** bekerja sebagai metode interaksi utama, dan bagaimana Anda dapat menavigasi, membuka, menutup aplikasi, serta mengelola jendela dan _workspace_ hanya dengan _keyboard_.

### Konsep Dasar dan Filosofi

Filosofi inti di balik Sway dan i3 adalah **"Keyboard-Centric Workflow"** atau Alur Kerja Berbasis Keyboard. Ini berarti bahwa hampir semua interaksi Anda dengan sistem akan dilakukan melalui kombinasi tombol keyboard, bukan dengan _mouse_. Ini mungkin terasa tidak biasa pada awalnya jika Anda terbiasa dengan lingkungan _desktop_ tradisional, tetapi ini adalah kunci untuk mencapai efisiensi dan kecepatan yang luar biasa.

- **Keybindings:** Ini adalah "pintasan keyboard" Anda. Setiap tindakan, seperti membuka terminal, menutup jendela, atau beralih _workspace_, akan terikat pada kombinasi tombol tertentu.
- **Modifier Key (`$mod`):** Di i3/Sway, ada satu tombol utama yang berfungsi sebagai "tombol pengubah" untuk banyak _keybindings_. Secara _default_ di Manjaro Sway i3, tombol ini adalah **Super Key** (sering disebut sebagai tombol "Windows" pada _keyboard_ PC atau tombol "Command" pada _keyboard_ Mac). Dalam file konfigurasi, tombol ini direferensikan sebagai `$mod`.
- **Workspaces (Ruang Kerja):** Daripada memiliki semua jendela Anda di satu layar yang berantakan, i3/Sway menggunakan konsep _workspace_. Anda dapat memiliki beberapa _workspace_ (biasanya dinomori 1-10) dan mengelompokkan aplikasi yang relevan di setiap _workspace_. Misalnya, _workspace_ 1 untuk pengembangan kode, _workspace_ 2 untuk browser, _workspace_ 3 untuk komunikasi, dst. Ini membantu menjaga _desktop_ tetap rapi dan memungkinkan Anda beralih konteks dengan cepat.
- **Tiling vs. Floating:**
  - **Tiling (Ubin):** Mode _default_ di mana jendela secara otomatis diatur berdampingan (seperti ubin lantai) tanpa tumpang tindih. Ini memaksimalkan ruang layar yang tersedia.
  - **Floating (Mengambang):** Mode di mana jendela dapat dipindahkan dan diubah ukurannya secara bebas, mirip dengan jendela di lingkungan _desktop_ tradisional. Ini berguna untuk jendela kecil seperti kalkulator atau _pop-up_.

### Implementasi Inti

Berikut adalah _keybindings_ dasar yang paling umum yang akan Anda gunakan. `$mod` merujuk pada tombol Super (Windows Key) secara _default_.

- **Membuka Terminal:**

  - `$mod + Return` (Tombol Super + Enter)
  - _Penjelasan:_ Ini adalah salah satu _keybinding_ yang paling sering digunakan, langsung membuka aplikasi terminal Anda.

- **Menutup Jendela Aktif:**

  - `$mod + Shift + q` (Tombol Super + Shift + Q)
  - _Penjelasan:_ Menutup jendela yang sedang Anda fokuskan.

- **Meluncurkan Aplikasi (Run Launcher):**

  - `$mod + d` (Tombol Super + D)
  - _Penjelasan:_ Ini akan membuka _application launcher_ (biasanya **dmenu** atau **Rofi** di Manjaro Sway i3). Anda dapat mulai mengetik nama aplikasi di sini, dan launcher akan menampilkan saran. Tekan `Enter` untuk meluncurkan aplikasi yang dipilih.

- **Beralih Antar Workspaces:**

  - `$mod + 1` (Tombol Super + 1)
  - `$mod + 2` (Tombol Super + 2)
  - ... hingga `$mod + 0` (untuk _workspace_ 10)
  - _Penjelasan:_ Beralih langsung ke _workspace_ bernomor yang sesuai.

- **Memindahkan Jendela ke Workspace Lain:**

  - `$mod + Shift + 1` (Tombol Super + Shift + 1)
  - _Penjelasan:_ Memindahkan jendela yang sedang aktif ke _workspace_ nomor 1. Anda juga akan berpindah ke _workspace_ tersebut.

- **Mengubah Mode Tiling (Horizontal/Vertical Split):**

  - `$mod + e` (Tombol Super + E)
  - _Penjelasan:_ Mengubah orientasi split untuk jendela berikutnya. Jika Anda membuka dua jendela, mereka mungkin dibagi secara horizontal. Jika Anda menekan `$mod + e` dan membuka jendela ketiga, ia mungkin akan membagi jendela yang sudah ada secara vertikal.

- **Beralih Antar Jendela (Fokus):**

  - `$mod + h` (kiri)
  - `$mod + j` (bawah)
  - `$mod + k` (atas)
  - `$mod + l` (kanan)
  - _Penjelasan:_ Menggunakan tombol `h`, `j`, `k`, `l` (mirip navigasi Vim) untuk berpindah fokus antar jendela di dalam _workspace_.

- **Mengubah Jendela Menjadi Floating/Tiling:**

  - `$mod + Shift + space` (Tombol Super + Shift + Spasi)
  - _Penjelasan:_ Mengubah mode jendela aktif antara _tiling_ (otomatis diatur) dan _floating_ (dapat dipindahkan bebas).

- **Mode Resize (Mengubah Ukuran Jendela secara Manual):**

  - `$mod + r` (Tombol Super + R)
  - _Penjelasan:_ Masuk ke mode _resize_. Saat dalam mode ini, _keybindings_ lainnya akan berubah fungsinya untuk mengubah ukuran jendela. Setelah selesai, tekan `Return` atau `Escape` untuk keluar dari mode _resize_.
    - Di mode _resize_:
      - `h`: Kecilkan lebar
      - `l`: Perbesar lebar
      - `k`: Kecilkan tinggi
      - `j`: Perbesar tinggi

- **Restart Sway/i3 (memuat ulang konfigurasi):**

  - `$mod + Shift + r` (Tombol Super + Shift + R)
  - _Penjelasan:_ Ini akan me-restart Sway/i3, memuat ulang konfigurasi Anda tanpa perlu me-restart seluruh sesi Linux. Ini sangat berguna saat Anda sedang mengedit file konfigurasi.

- **Keluar dari Sway/i3 Session:**

  - `$mod + Shift + e` (Tombol Super + Shift + E)
  - _Penjelasan:_ Ini akan menampilkan dialog konfirmasi untuk keluar dari sesi Sway/i3 Anda.

### Terminologi Kunci

- **Keybinding:** Kombinasi tombol keyboard yang telah ditentukan untuk memicu suatu tindakan atau perintah. Ini adalah "pintasan" Anda.
- **Modifier Key ($mod):** Tombol pengubah utama yang digunakan dalam kombinasi _keybinding_ (misalnya, `Super` / Tombol Windows, `Alt`, `Ctrl`, `Shift`). Di Manjaro Sway i3, _default_-nya adalah `Super`.
- **Workspaces (Ruang Kerja):** Ruang kerja virtual terpisah tempat Anda dapat mengelompokkan jendela dan aplikasi Anda. Ini membantu mengatur _desktop_ dan memungkinkan multitasking yang efisien.
- **Tiling:** Mode default di mana jendela secara otomatis diatur berdampingan di layar tanpa tumpang tindih.
- **Floating:** Mode di mana jendela dapat dipindahkan dan diubah ukurannya secara bebas di atas jendela lain.
- **Focus:** Jendela atau elemen UI yang saat ini aktif atau menerima input dari _keyboard_.
- **i3bar / Waybar:** Panel di bagian bawah (atau atas) layar yang menampilkan informasi sistem (waktu, baterai, jaringan), status _workspace_, dan _system tray_. i3bar digunakan untuk i3, Waybar untuk Sway.
- **dmenu / Rofi:** **Application launcher** yang ringan dan efisien. Anda mengetik nama aplikasi, dan mereka akan mencarinya serta meluncurkannya. `dmenu` sangat minimalis, `Rofi` lebih kaya fitur dan visual. Manjaro Sway i3 sering kali sudah menginstal dan mengkonfigurasi salah satunya.

### Daftar Isi

- Memahami Konsep "Keyboard-Centric Workflow".
- Identifikasi dan Peran Modifier Key (`$mod`).
- Menguasai _Keybindings_ Dasar untuk Navigasi Sistem:
  - Membuka dan Menutup Terminal.
  - Meluncurkan Aplikasi dengan `dmenu`/Rofi.
  - Mengatur Fokus dan Berpindah Antar Jendela.
- Memahami dan Menggunakan _Workspaces_: Beralih dan Memindahkan Jendela.
- Mengelola Layout Jendela: _Tiling_, _Floating_, _Stacking_, dan _Tabbed_.
- Penggunaan Dasar _Status Bar_ (i3bar/Waybar).
- Restart dan Keluar dari Sesi Sway/i3.
- Tips Latihan untuk Membangun Memori Otot (_Muscle Memory_).

### Sumber Referensi

- **Panduan Pengguna i3 (Sangat Direkomendasikan!):**
  - [i3 User's Guide: Usage](https://i3wm.org/docs/userguide.html%23usage)
  - [i3 User's Guide: Configuration](https://i3wm.org/docs/userguide.html%23configuration) (Meski akan dibahas lebih detail di Fase 2, melihat sekilas akan membantu).
- **Wiki Sway (Penggunaan Dasar):**
  - [Sway User's Wiki: Basic Usage](https://github.com/swaywm/sway/wiki/Basic-Usage)
- **Manjaro i3/Sway User Guide (jika tersedia di Manjaro Wiki):**
  - [Manjaro Wiki: i3](https://wiki.manjaro.org/index.php%3Ftitle%3DI3) (Cari bagian yang relevan dengan _keybindings_ default Manjaro Sway i3).

**Visualisasi (Opsional tapi Direkomendasikan):**
Gambar visual akan sangat membantu di sini. Misalnya:

- Diagram keyboard yang menyoroti `$mod` key dan _keybindings_ dasar.
- _Screenshot_ _desktop_ Sway/i3 yang menunjukkan bagaimana jendela di-_tile_ secara otomatis.
- _Screenshot_ yang menunjukkan perbedaan antara _tiling_ dan _floating_ jendela.
- _Screenshot_ Waybar/i3bar yang menunjukkan _workspace indicator_.

---

## Modul 1.6: Pengenalan Dasar Command Line Interface (CLI)

### Deskripsi Konkret

Di lingkungan Manjaro Sway i3, **Command Line Interface (CLI)** atau yang biasa kita sebut **Terminal** adalah teman terbaik Anda. Modul ini akan memperkenalkan Anda pada dasar-dasar penggunaan CLI di Linux. Anda akan belajar perintah-perintah esensial untuk **navigasi _file system_**, **manajemen _file_** dan **direktori**, serta bagaimana mendapatkan bantuan ketika Anda tidak tahu harus mengetik apa. Menguasai dasar-dasar CLI akan membuka gerbang ke kontrol penuh atas sistem Anda.

### Konsep Dasar dan Filosofi

CLI adalah antarmuka berbasis teks untuk berinteraksi dengan sistem operasi. Daripada mengklik ikon atau menu, Anda mengetikkan perintah. Filosofi di baliknya adalah **efisiensi**, **presisi**, dan **otomatisasi**.

- **Efisiensi:** Banyak tugas dapat diselesaikan lebih cepat dengan mengetik beberapa perintah daripada menavigasi melalui banyak menu grafis.
- **Presisi:** Anda memiliki kontrol granular yang lebih besar atas operasi sistem.
- **Otomatisasi:** Perintah-perintah dapat digabungkan menjadi _script_ (akan dibahas lebih lanjut di Fase 3) untuk mengotomatiskan tugas-tugas yang berulang.

Di Linux, CLI diakses melalui **Terminal Emulator** (seperti Alacritty, Kitty, atau XTerm), yang sudah kita pelajari cara membukanya di Modul 1.5. Di dalam terminal, Anda akan berinteraksi dengan **Shell**, yang merupakan program yang menerjemahkan perintah Anda ke sistem operasi. **Bash** (Bourne Again SHell) adalah _shell_ yang paling umum digunakan secara _default_ di Manjaro.

### Implementasi Inti

Mari kita selami beberapa perintah dasar yang akan Anda gunakan setiap hari.

1.  **Navigasi Direktori (Bergerak di _File System_):**

    - `pwd` (Print Working Directory): Menampilkan jalur lengkap dari direktori saat ini di mana Anda berada.
      ```bash
      pwd
      # Output contoh: /home/pengguna_anda
      ```
    - `ls` (List): Menampilkan daftar isi (file dan direktori) dari direktori saat ini.
      ```bash
      ls
      # Output contoh: Dokumen Gambar Musik Unduhan
      ```
      - `ls -l`: Menampilkan daftar dengan format panjang (detail seperti izin, pemilik, ukuran, tanggal).
      - `ls -a`: Menampilkan semua file, termasuk file tersembunyi (yang diawali dengan titik, `.`).
    - `cd` (Change Directory): Berpindah dari satu direktori ke direktori lain.
      ```bash
      cd Documents            # Masuk ke direktori "Documents"
      cd ..                   # Pindah ke direktori induk (satu tingkat di atas)
      cd ~                    # Pindah ke direktori home pengguna saat ini (shortcut)
      cd /                    # Pindah ke root directory (direktori paling atas)
      cd -                    # Pindah kembali ke direktori sebelumnya
      ```

2.  **Manajemen File dan Direktori:**

    - `mkdir` (Make Directory): Membuat direktori baru.
      ```bash
      mkdir proyek_baru
      mkdir -p proyek/subfolder # Membuat direktori dan subdirektori secara rekursif
      ```
    - `touch`: Membuat file kosong baru atau memperbarui waktu modifikasi file yang sudah ada.
      ```bash
      touch file_baru.txt
      ```
    - `cp` (Copy): Menyalin file atau direktori.
      ```bash
      cp file_sumber.txt file_tujuan.txt           # Menyalin file
      cp -r folder_sumber/ folder_tujuan/          # Menyalin direktori secara rekursif
      cp file.txt ~/Dokumen/                       # Menyalin file ke direktori Documents di home
      ```
    - `mv` (Move): Memindahkan file atau direktori, juga digunakan untuk mengganti nama.
      ```bash
      mv file_lama.txt file_baru.txt             # Mengganti nama file
      mv file_ini.txt ~/Backup/                  # Memindahkan file ke direktori Backup
      ```
    - `rm` (Remove): Menghapus file. **Berhati-hatilah dengan perintah ini, tidak ada "Recycle Bin" di CLI.**
      ```bash
      rm file_yang_dihapus.txt
      rm -r folder_yang_dihapus/                 # Menghapus direktori dan isinya secara rekursif
      rm -rf folder_penting/                     # SANGAT BERBAHAYA! Menghapus tanpa konfirmasi. JANGAN GUNAKAN INI SAMPAI ANDA SANGAT YAKIN.
      ```

3.  **Melihat Isi File:**

    - `cat` (Concatenate): Menampilkan seluruh isi file ke terminal. Berguna untuk file kecil.
      ```bash
      cat nama_file.txt
      ```
    - `less`: Menampilkan isi file satu layar penuh pada satu waktu. Berguna untuk file besar, Anda bisa _scroll_ ke atas/bawah. Tekan `q` untuk keluar.
      ```bash
      less logfile.log
      ```
    - `head`: Menampilkan beberapa baris pertama dari sebuah file (default 10 baris).
      ```bash
      head nama_file.txt
      ```
    - `tail`: Menampilkan beberapa baris terakhir dari sebuah file (default 10 baris). Berguna untuk melihat _log_ yang sedang ditulis.
      ```bash
      tail -f /var/log/syslog # Melihat log sistem secara real-time (tekan Ctrl+C untuk keluar)
      ```

4.  **Perintah Penting Lainnya:**

    - `man` (Manual): Menampilkan "manual page" (dokumentasi) untuk perintah Linux. Ini adalah sumber daya yang tak ternilai\!
      ```bash
      man ls
      man cd
      man rm
      # Tekan q untuk keluar dari man page.
      ```
    - `sudo` (SuperUser DO): Menjalankan perintah sebagai _superuser_ (administrator _root_). Anda akan sering menggunakannya untuk tugas-tugas yang memerlukan hak akses tinggi, seperti menginstal atau memperbarui perangkat lunak.
      ```bash
      sudo pacman -Syu    # Contoh: Perintah untuk memperbarui sistem di Manjaro.
      ```
    - `clear` atau `Ctrl + l`: Membersihkan layar terminal.
    - `history`: Menampilkan daftar perintah yang pernah Anda masukkan sebelumnya.
    - Tekan `Tab` dua kali: Fitur **autokompletasi**. Jika Anda mengetik sebagian perintah atau nama file/direktori, lalu menekan `Tab`, _shell_ akan mencoba melengkapinya secara otomatis. Ini sangat menghemat waktu dan mencegah kesalahan ketik.

### Terminologi Kunci

- **Terminal/Konsole/Shell:** Program yang menyediakan antarmuka baris perintah untuk berinteraksi dengan sistem operasi. **Shell** adalah interpreter perintah (misalnya, Bash).
- **Command (Perintah):** Instruksi yang diberikan kepada sistem operasi melalui CLI (misalnya, `ls`, `cd`, `mkdir`).
- **Argument:** Informasi tambahan yang diberikan kepada perintah untuk memodifikasi perilakunya atau menargetkan _file_/direktori tertentu (misalnya, `ls -l /home`).
- **Option/Flag:** Jenis argumen khusus yang biasanya diawali dengan tanda hubung (`-`) atau dua tanda hubung (`--`) untuk mengaktifkan fitur atau mengubah perilaku perintah (misalnya, `-l` pada `ls -l`).
- **Current Working Directory (CWD):** Direktori tempat Anda berada saat ini di _file system_ (yang ditampilkan oleh `pwd`).
- **Root Directory (`/`):** Direktori paling atas di _file system_ Linux. Semua direktori lain berada di bawahnya.
- **Home Directory (`~` atau `/home/username`):** Direktori pribadi setiap pengguna, tempat Anda menyimpan file dan konfigurasi pribadi Anda.
- **Absolute Path:** Jalur lengkap ke _file_ atau direktori yang dimulai dari _root directory_ (misalnya, `/home/user/Documents/`).
- **Relative Path:** Jalur ke _file_ atau direktori yang relatif terhadap _Current Working Directory_ Anda (misalnya, jika Anda di `/home/user`, `Documents/` adalah jalur relatif ke `/home/user/Documents/`).
- **Superuser (root):** Akun administrator dengan hak akses tak terbatas pada sistem.
- **`sudo` (superuser do):** Perintah yang memungkinkan pengguna standar menjalankan perintah dengan hak akses _superuser_ untuk satu perintah saja. Ini membutuhkan kata sandi pengguna Anda.
- **Output:** Informasi yang dihasilkan oleh perintah dan ditampilkan di terminal.
- **Input:** Perintah atau data yang Anda berikan kepada program.
- **Man Page (Manual Page):** Dokumentasi bawaan untuk perintah dan utilitas Linux, diakses melalui perintah `man`.

### Daftar Isi

- Apa itu CLI dan Mengapa Ia Penting dalam Lingkungan Minimalis?
- Membuka dan Berinteraksi dengan Terminal.
- Navigasi Dasar _File System_: `pwd`, `ls`, `cd`.
- Manajemen File dan Direktori: `mkdir`, `touch`, `cp`, `mv`, `rm`.
- Melihat Isi File: `cat`, `less`, `head`, `tail`.
- Menggunakan `man` untuk Mendapatkan Bantuan dan Dokumentasi.
- Memahami Peran dan Penggunaan `sudo`.
- Tips Produktivitas CLI: Autokompletasi Tab dan Riwayat Perintah.
- Struktur Direktori Linux Dasar (`/bin`, `/etc`, `/usr`, `/var`, dll.) (Pengantar Singkat).

### Sumber Referensi

- **The Linux Command Line (Buku Online Gratis oleh William Shotts Jr.):**
  - [The Linux Command Line](http://linuxcommand.org/tlcl.php) (Sangat direkomendasikan untuk pendalaman lebih lanjut).
- **Tutorial Bash Scripting (Ryan's Tutorials - Bagian Awal):**
  - [Bash Scripting Tutorial - Ryan's Tutorials](https://ryanstutorials.net/linuxtutorial/bash-scripting.php) (Fokus pada bagian dasar `ls`, `cd`, `cp`, dll.)
- **Referensi Perintah Linux Dasar (TutorialsPoint):**
  - [Basic Linux Commands - TutorialsPoint](https://www.tutorialspoint.com/linux_commands/index.htm)
- **Cheat Sheet Perintah Linux:**
  - [Linux Command Line Cheat Sheet](https://www.dummies.com/wp-content/uploads/linux-command-line-cheat-sheet.pdf) (Untuk referensi cepat).

---

# **Selamat!**

Anda telah menyelesaikan seluruh **Fase 1: Pondasi** dari kurikulum **Menguasai Manjaro Sway i3**.

Anda sekarang memiliki pemahaman dasar tentang:

- Apa itu Linux dan mengapa Manjaro.
- Filosofi _tiling window manager_ seperti i3 dan Sway.
- Cara melakukan instalasi Manjaro Sway i3.
- Interaksi dasar dengan lingkungan Sway/i3 menggunakan _keybindings_.
- Perintah dasar _Command Line Interface_ (CLI) yang esensial.

Ini adalah fondasi yang sangat kuat untuk perjalanan Anda menjadi _super user_ Manjaro Sway i3. Selanjutnya, kita akan melangkah ke **Fase 2: Menengah**, di mana Anda akan mulai menyelami kustomisasi dan manajemen sistem yang lebih mendalam.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

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
