### **[Fase 1: Fundamental — Memahami Peta Jalan (Beginner)][0]**

#### **Modul 1: Filosofi Hierarki Filesystem (Filesystem Hierarchy Standard/FHS)**

**Struktur Pembelajaran Internal:**

<details>
  <summary>📃 Daftar Isi</summary>

  * **1.1** Apa itu Filesystem Hierarchy Standard (FHS)?
  * **1.2** Filosofi "Semuanya adalah File" (Everything is a File).
  * **1.3** Pemisahan Data: `Static` vs. `Variable`, `Shareable` vs. `Unshareable`.
  * **1.4** Konsep `Root Directory` (`/`) dan `Mount Point`.
  * **1.5** Analogi: Peta Kota vs. Peta Harta Karun.

</details>

-----

### **Deskripsi Konkret & Peran dalam Kurikulum**

Modul ini adalah titik awal fundamental. Anda tidak hanya akan belajar nama-nama folder, tetapi yang lebih penting, Anda akan menguasai **filosofi** dan **prinsip** di balik mengapa sistem operasi Linux/Unix-like diatur sedemikian rupa. Memahami FHS adalah seperti memahami tata letak dan aturan lalu lintas sebuah kota sebelum Anda mulai mengendarai kendaraan di dalamnya. Ini adalah prasyarat mutlak untuk menjadi administrator sistem yang kompeten, karena tanpa pemahaman ini, setiap navigasi atau modifikasi akan terasa seperti tebakan. Ini adalah pondasi yang akan membuat pembelajaran modul-modul berikutnya (seperti manajemen perizinan atau administrasi sistem) menjadi jauh lebih intuitif dan logis.

### **Konsep Kunci & Filosofi Mendalam**

**Filosofi "Everything is a File"**

Ini adalah prinsip sentral dalam desain Unix. Dalam sistem Linux, perangkat keras seperti *hard drive*, *keyboard*, atau bahkan *printer* diperlakukan sebagai file. Data yang diakses oleh proses yang sedang berjalan pun direpresentasikan sebagai file virtual. Konsep ini menyederhanakan cara interaksi antara program dan sistem. Daripada harus menulis kode yang rumit untuk setiap jenis perangkat, pengembang dapat menggunakan satu set perintah standar (seperti `read`, `write`, `open`, `close`) yang berlaku untuk semua "file", baik itu file dokumen, perangkat fisik, atau data proses.

**Pemisahan Data (The Separation Principle)**

FHS memisahkan data menjadi beberapa kategori untuk meningkatkan efisiensi, keamanan, dan fleksibilitas. Tiga pemisahan utama adalah:

1.  **Static vs. Variable:**

      * **Data Statis:** Berisi file yang tidak berubah (atau jarang berubah) tanpa intervensi administrator. Contohnya adalah program-program biner di `/bin` atau `/usr/bin`. File-file ini bisa disimpan di media *read-only* atau dibagikan melalui jaringan.
      * **Data Variabel:** Berisi file yang terus-menerus berubah saat sistem beroperasi. Contohnya adalah log sistem di `/var/log`, *cache* di `/var/cache`, atau email di `/var/mail`.

2.  **Shareable vs. Unshareable:**

      * **Data `Shareable`:** Dapat diakses atau digunakan bersama oleh beberapa *host* (komputer) dalam sebuah jaringan. Contohnya `/usr` yang berisi program-program yang bisa di-mount dari server sentral.
      * **Data `Unshareable`:** Berisi file yang hanya relevan dan spesifik untuk satu *host*. Contohnya adalah konfigurasi sistem di `/etc` atau file perangkat di `/dev`.

**Konsep `Root Directory` (`/`) dan `Mount Point`**

**`Root Directory`** adalah pangkal dari seluruh hirarki. Ini adalah titik awal mutlak, dan semua direktori serta file lainnya adalah cabangnya.

**`Mount Point`** adalah direktori kosong di mana sistem file lain 'ditempelkan'. Ini adalah konsep yang sangat kuat. Misalnya, ketika Anda mencolokkan *flash drive* USB, sistem akan "memasang" sistem file dari *flash drive* tersebut ke sebuah direktori (misalnya `/media/username/usbdisk`). Dengan cara ini, Anda dapat mengakses konten USB melalui hirarki file yang sama, tanpa harus khawatir tentang di mana perangkat fisik itu berada.

### **Sintaks Dasar / Contoh Implementasi Inti**

Berikut adalah beberapa perintah untuk membantu Anda memvisualisasikan struktur FHS.

1.  **Melihat Hirarki Filesystem:**

      * Perintah `tree` (Anda mungkin perlu menginstalnya dengan `sudo pacman -S tree` di Arch Linux) adalah cara terbaik untuk memvisualisasikan struktur pohon direktori.

    <!-- end list -->

    ```bash
    # Melihat struktur dari direktori root (hati-hati, outputnya bisa sangat panjang!)
    tree -L 2 /

    # Keterangan:
    # -L 2: Membatasi kedalaman tampilan hanya pada 2 level.
    # /: Menunjukkan direktori yang akan ditampilkan, yaitu root.
    ```

2.  **Memeriksa Penggunaan Disk:**

      * Perintah `df` (**d**isk **f**ree) menunjukkan penggunaan ruang disk dari semua sistem file yang telah di-*mount*.

    <!-- end list -->

    ```bash
    # Menampilkan informasi disk secara human-readable (mudah dibaca)
    df -h

    # Contoh output:
    # Filesystem      Size  Used Avail Use% Mounted on
    # /dev/sda1        40G   10G  28G  27% /
    # /dev/sda2        50G   20G  28G  42% /home
    ```

      * Output di atas menunjukkan bahwa `/dev/sda1` di-*mount* di `/` dan `/dev/sda2` di-*mount* di `/home`. Ini adalah contoh nyata dari konsep *mount point*.

### **Terminologi Esensial & Penjelasan Detil**

  * **Filesystem (Sistem Berkas):** Struktur yang digunakan sistem operasi untuk mengatur, menyimpan, dan mengambil file data. Ini bisa berupa partisi pada hard drive (misalnya, ext4, NTFS) atau sistem file virtual (misalnya, `/proc`).
  * **Hierarki (Hierarchy):** Struktur berjenjang di mana item-item diatur dalam level-level, dari yang paling umum (root) ke yang paling spesifik (file).
  * **Binary (Biner):** File yang berisi kode yang dapat dieksekusi langsung oleh komputer. Contohnya adalah program atau perintah seperti `ls` atau `bash`.
  * **Kernel:** Inti dari sistem operasi yang mengelola sumber daya perangkat keras dan menyediakan layanan dasar untuk program. Perangkat di `/dev` dan proses di `/proc` adalah representasi interaksi dengan kernel.

### **Rekomendasi Visualisasi**

Visualisasi yang paling membantu di sini adalah **diagram pohon (tree diagram)** yang menunjukkan hubungan hierarkis antar direktori. Sebuah diagram alur yang menunjukkan bagaimana perintah-perintah CLI (seperti `cd` atau `ls`) bekerja di dalam struktur pohon ini juga akan sangat berharga.

### **Hubungan dengan Modul Lain**

Modul ini adalah prasyarat untuk semua modul berikutnya. Pemahaman tentang FHS akan menjadi fondasi yang kokoh untuk:

  * **Modul 2 (Direktori Esensial):** Anda akan belajar peran spesifik dari setiap direktori yang telah dipisahkan secara filosofis di modul ini.
  * **Modul 3 (Navigasi & Manajemen):** Anda akan menggunakan pemahaman FHS untuk menavigasi, mencari, dan memanipulasi file dengan efisien.
  * **Modul 4 & 5 (Admin & Perizinan):** Anda akan tahu di mana menemukan file log, file konfigurasi, dan bagaimana izin diterapkan pada struktur direktori yang terorganisir ini.

### **Sumber Referensi Lengkap**

  * **FHS Official Documentation:** [https://refspecs.linuxfoundation.org/FHS\_3.0/fhs/index.html](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html) (Sumber resmi dari Linux Foundation).
  * **Linux File System Hierarchy:** [https://www.tldp.org/LDP/sag/html/sg-fs.html](https://www.tldp.org/LDP/sag/html/sg-fs.html) (Panduan detail dari The Linux Documentation Project).
  * **`tree` command manual:** `man tree` (Jalankan langsung di terminal Anda untuk dokumentasi lokal).
  * **`df` command manual:** `man df` (Jalankan langsung di terminal Anda).

### **Tips dan Praktik Terbaik**

  * **Jangan menghafal, pahami:** Alih-alih menghafal setiap direktori, fokuslah untuk memahami **tujuan** utama dari setiap kategori (misalnya, `/etc` untuk konfigurasi, `/var` untuk data variabel).
  * **Mulai dari `/`:** Ketika Anda merasa tersesat, selalu kembali ke direktori `/` (`cd /`) dan gunakan `ls` atau `tree` untuk orientasi.
  * **Manfaatkan `man pages`:** Setiap perintah Linux memiliki halaman manual. Gunakan `man [nama-perintah]` (misalnya, `man ls`) untuk mendapatkan informasi paling akurat tentang sebuah perintah.

### **Potensi Kesalahan Umum & Solusi**

  * **Kesalahan:** Menganggap `/` dan `/root` adalah hal yang sama.
      * **Solusi:** Ingatlah bahwa `/` adalah akar dari semua direktori, sedangkan `/root` adalah direktori home untuk pengguna `root` saja. Mengakses `/root` dari pengguna biasa akan ditolak karena alasan keamanan.
  * **Kesalahan:** Mencoba memodifikasi file di `/bin` atau `/usr/bin` tanpa izin `superuser`.
      * **Solusi:** File-file ini adalah bagian dari sistem statis yang dilindungi. Perubahan hanya bisa dilakukan oleh pengguna `root` menggunakan `sudo`. Selalu gunakan `sudo` dengan hati-hati dan hanya ketika benar-benar diperlukan.

<!-- end list -->

```
┌───────────────────────────┐
│     Filosofi Filesystem   │
│       (Modul 1.1)         │
│ ┌───────────────────────┐ │
│ │  Konsep Sentral FHS   │ │
│ │  (Everything is a File) │───┐
│ └───────────────────────┘ │   │
│ ┌───────────────────────┐ │   ▼
│ │  Pemisahan Data       │ │   Membedakan file berdasarkan
│ │  (Static vs. Variable)│───┐  tujuannya.
│ └───────────────────────┘ │ │
│ ┌───────────────────────┐ │ ▼
│ │  Pemisahan Data       │ │Mengatur file berdasarkan
│ │(Shareable vs. Unshareable)│lokasi aksesnya.
│ └───────────────────────┘ │
│ ┌───────────────────────┐ │
│ │      Direktori        │ │
│ │      Root (/)         │───┐
│ └───────────────────────┘ │ │
│ ┌───────────────────────┐ │ ▼
│ │     Mount Point       │ │ Tempat "menempelkan" filesystem
│ │     (Seperti /home)   │─┼─── dari partisi lain.
│ └───────────────────────┘ │
└───────────────────────────┘
```

-----

Kita telah menyelesaikan penjelasan mendalam untuk **Modul 1: Filosofi Hierarki Filesystem**. Penjelasan ini mencakup konsep, contoh, dan hubungan dengan modul lain secara komprehensif.

-----

#### **Modul 2: Direktori Esensial Tingkat Tinggi**

**Struktur Pembelajaran Internal:**

  * **2.1** Direktori untuk Program & Library: `/bin`, `/sbin`, `/lib`, `/usr`, `/usr/bin`, `/usr/sbin`, `/usr/lib`.
  * **2.2** Direktori untuk Konfigurasi & Data Pengguna: `/etc`, `/home`, `/root`.
  * **2.3** Direktori untuk Data Temporer & Variabel: `/tmp`, `/var`.
  * **2.4** Direktori untuk Perangkat Keras: `/dev`.
  * **2.5** Direktori untuk Proses dan Kernel: `/proc`, `/sys`.
  * **2.6** Analogi: Departemen-departemen di dalam Kantor Pemerintahan.

-----

### **Deskripsi Konkret & Peran dalam Kurikulum**

Modul ini akan membawa Anda dari filosofi abstrak ke praktik nyata. Anda akan mempelajari secara detail fungsi spesifik dari setiap direktori utama yang berada di bawah direktori *root* (`/`). Setiap direktori ini memiliki peran unik dan penting dalam fungsionalitas sistem. Memahami peran masing-masing adalah langkah krusial untuk menjadi seorang pengguna yang mahir dan, pada akhirnya, seorang administrator yang handal. Modul ini menjadi jembatan antara konsep FHS yang telah Anda pelajari dengan navigasi praktis yang akan dibahas di modul selanjutnya.

### **Konsep Kunci & Filosofi Mendalam**

Setiap direktori utama di Linux adalah sebuah "departemen" dengan tugas dan tanggung jawab yang sangat spesifik. Filosofi di balik penataan ini adalah **organisasi dan standarisasi**. Dengan menempatkan jenis file tertentu di lokasi yang telah ditetapkan, sistem menjadi lebih mudah untuk dikelola, didiagnosis, dan diotomatisasi, baik oleh manusia maupun oleh program. Ini meminimalisir risiko kesalahan dan inkonsistensi.

#### **2.1 Direktori untuk Program & Library**

Direktori ini menampung file-file yang dapat dieksekusi (program) dan file-file pendukung (library) yang diperlukan untuk menjalankan sistem.

  * **`/bin` (binaries):** Berisi program-program penting yang diperlukan untuk boot sistem dan perbaikan dasar. Program di sini bersifat minimalis dan esensial. Contoh: `ls`, `cat`, `mv`, `cp`.

  * **`/sbin` (system binaries):** Mirip dengan `/bin`, tetapi berisi program-program yang hanya digunakan oleh **superuser** (`root`) untuk tujuan administrasi sistem. Contoh: `fdisk`, `reboot`, `shutdown`.

  * **`/lib` (libraries):** Berisi pustaka (library) esensial yang dibutuhkan oleh program di `/bin` dan `/sbin` saat boot.

  * **`/usr` (Unix System Resources):** Direktori yang paling besar dan kompleks. Sebagian besar program dan file yang diinstal oleh pengguna (melalui manajer paket seperti `pacman` di Arch Linux) akan berada di sini. `/usr` dapat dibayangkan sebagai direktori statis dan dapat dibagikan yang menampung hampir semua program, library, dokumentasi, dan data pendukung lainnya.

      * **`/usr/bin`:** Berisi program yang paling sering digunakan oleh semua pengguna.
      * **`/usr/sbin`:** Berisi program administrasi sistem yang tidak penting untuk boot awal.
      * **`/usr/lib`:** Berisi pustaka pendukung untuk program di `/usr/bin` dan `/usr/sbin`.

**Perbedaan Utama `/bin` vs `/usr/bin`**: Secara historis, `/bin` berisi perintah yang sangat penting untuk boot dan perbaikan sistem jika partisi `/usr` tidak bisa di-*mount*. Di distribusi modern, batas ini semakin kabur, dan banyak distribusi hanya menggunakan `/usr/bin` dan membuat `/bin` menjadi **symlink** ke `/usr/bin`. Di Arch Linux, `/bin`, `/sbin`, dan `/lib` semuanya adalah *symlink* ke `/usr/bin`, `/usr/sbin`, dan `/usr/lib`.

#### **2.2 Direktori untuk Konfigurasi & Data Pengguna**

  * **`/etc` (et cetera):** Singkatan yang bermakna "dan lain-lain" tetapi secara praktis adalah tempat menyimpan **file konfigurasi sistem**. File di sini berupa teks biasa yang dapat diedit, memungkinkan Anda untuk mengubah perilaku program dan sistem secara menyeluruh. Contoh: `/etc/fstab` (daftar sistem file yang akan di-*mount* saat boot), `/etc/resolv.conf` (konfigurasi DNS), atau `/etc/bash.bashrc` (konfigurasi shell Bash).
  * **`/home`:** Direktori ini adalah "rumah" bagi setiap pengguna non-root. Setiap pengguna memiliki sub-direktorinya sendiri di sini (contoh: `/home/username`), di mana mereka memiliki kontrol penuh untuk menyimpan file pribadi, dokumen, dan konfigurasi aplikasi spesifik pengguna.
  * **`/root`:** Direktori **home** untuk pengguna `root`. Ini terpisah dari `/home` untuk alasan keamanan, memastikan bahwa file-file penting *root* tidak secara tidak sengaja dapat diakses oleh pengguna lain.

#### **2.3 Direktori untuk Data Temporer & Variabel**

  * **`/tmp` (temporary):** Direktori untuk file-file sementara yang dibuat oleh program. Isinya **dapat dihapus saat sistem di-*reboot***. Jangan pernah menyimpan file penting di sini.

  * **`/var` (variable):** Direktori yang menyimpan data yang isinya terus berubah (variabel) saat sistem berjalan.

      * **`/var/log`:** Tempat penyimpanan file **log sistem** yang sangat penting. Log merekam aktivitas sistem, kesalahan, dan pesan diagnostik.
      * **`/var/cache`:** Tempat menyimpan data yang di-*cache* oleh manajer paket (`pacman` di Arch) atau program lain.
      * **`/var/tmp`:** Mirip dengan `/tmp`, tetapi isinya biasanya **tidak dihapus saat sistem di-*reboot***.

#### **2.4 Direktori untuk Perangkat Keras**

  * **`/dev` (devices):** Direktori ini bukanlah direktori "fisik". Isinya adalah file spesial yang merepresentasikan **perangkat keras** yang terhubung ke sistem, seperti *hard drive*, *mouse*, *keyboard*, atau terminal. Interaksi dengan file-file di `/dev` adalah cara kernel berkomunikasi dengan perangkat fisik.

#### **2.5 Direktori untuk Proses dan Kernel**

  * **`/proc` (processes):** Sistem file virtual yang berisi informasi tentang proses yang sedang berjalan, memori, dan status kernel. Setiap proses memiliki direktori bernomor di sini (misalnya, `/proc/1234`).
  * **`/sys` (system):** Sistem file virtual lain yang menyediakan antarmuka terstruktur ke perangkat dan driver dari kernel. Ini sering digunakan untuk mengkonfigurasi atau membaca status perangkat keras.

### **Sintaks Dasar / Contoh Implementasi Inti**

Memahami direktori ini adalah tentang tahu di mana harus mencari.

  * **Studi Kasus: Diagnostik Masalah Boot**

      * **Skenario:** Sistem Anda gagal boot ke lingkungan desktop.
      * **Pendekatan:** Masuk ke terminal dan periksa log sistem.
      * **Perintah:**
        ```bash
        # Mengakses direktori log sistem
        cd /var/log

        # Melihat log pesan sistem terbaru
        less syslog
        # Atau untuk melihat real-time log
        tail -f syslog
        ```
      * **Keterangan:** Perintah `cd /var/log` akan membawa Anda ke tempat di mana log sistem disimpan. `less` adalah program untuk melihat konten file teks, dan `tail -f` akan menampilkan baris-baris terakhir dari file dan terus memantaunya.

  * **Studi Kasus: Mengatur Konfigurasi**

      * **Skenario:** Anda ingin mengubah nama host sistem Anda.
      * **Pendekatan:** Edit file konfigurasi di `/etc`.
      * **Perintah:**
        ```bash
        # Menggunakan editor Vim untuk mengedit file hosts (harus dengan sudo)
        sudo vim /etc/hosts
        ```
      * **Keterangan:** Mengakses dan memodifikasi file di `/etc` biasanya memerlukan hak **superuser**, itulah mengapa kita menggunakan perintah `sudo`.

### **Terminologi Esensial & Penjelasan Detil**

  * **Log:** Catatan kronologis dari semua aktivitas dan peristiwa yang terjadi pada sistem.
  * **Symlink (Symbolic Link):** Semacam pintasan ke file atau direktori lain. Jika file asli dihapus, symlink akan rusak.
  * **Kernel:** Inti dari sistem operasi yang mengelola semua interaksi antara perangkat lunak dan perangkat keras.

### **Hubungan dengan Modul Lain**

  * **Modul 3 (Navigasi & Manajemen):** Modul ini adalah "peta" yang akan Anda gunakan. Modul 3 akan memberikan Anda "kompas" (perintah-perintah navigasi canggih) untuk bergerak di sepanjang peta ini. Anda akan menerapkan pengetahuan tentang `/var/log` untuk diagnostik, atau pengetahuan tentang `/etc` untuk mengelola konfigurasi.
  * **Modul 5 (Manajemen Perizinan):** Anda akan belajar mengapa beberapa direktori, seperti `/etc` dan `/root`, dilindungi dari akses pengguna biasa, dan bagaimana izin `rwx` diterapkan pada file-file di dalamnya.

### **Sumber Referensi Lengkap**

  * **Linux `ls` command manual:** `man ls`
  * **Linux `cd` command manual:** `man cd`
  * **`The Linux System Administrator's Guide`:** [https://www.tldp.org/LDP/sag/html/index.html](https://www.tldp.org/LDP/sag/html/index.html)
  * **Arch Linux Wiki on `File hierarchy`:** [https://wiki.archlinux.org/title/File\_hierarchy](https://wiki.archlinux.org/title/File_hierarchy)

### **Tips dan Praktik Terbaik**

  * **Selalu gunakan `sudo` dengan hati-hati:** Jangan pernah menjalankan perintah `sudo` kecuali Anda sepenuhnya yakin apa yang akan dilakukannya.
  * **Backup konfigurasi:** Sebelum mengedit file di `/etc`, selalu buat salinan cadangan. Misalnya: `sudo cp /etc/fstab /etc/fstab.bak`.

### **Potensi Kesalahan Umum & Solusi**

  * **Kesalahan:** Mencari program yang baru diinstal di `/bin` dan tidak menemukannya.
      * **Solusi:** Sebagian besar program yang diinstal oleh manajer paket ditempatkan di `/usr/bin`. Periksa di sana terlebih dahulu.
  * **Kesalahan:** Mengedit file konfigurasi sistem dan membuat kesalahan, menyebabkan sistem tidak stabil.
      * **Solusi:** Selalu buat cadangan file sebelum mengeditnya. Jika terjadi kesalahan, Anda bisa dengan mudah mengembalikan versi aslinya.

<!-- end list -->

```
┌───────────────────────────────────────┐
│         Direktori Esensial            │
│          (Modul 2.1 - 2.6)            │
│ ┌───────────────────────────────────┐ │
│ │  /bin, /sbin, /lib                │ │───┐
│ │  (Program & Library Esensial)     │ │   │
│ └───────────────────────────────────┘ │   ▼
│ ┌───────────────────────────────────┐ │   Program penting untuk boot &
│ │  /usr/bin, /usr/sbin, /usr/lib    │ │───┐  administrasi sistem dasar.
│ │  (Program & Library Tambahan)     │ │   │
│ └───────────────────────────────────┘ │   ▼
│ ┌───────────────────────────────────┐ │   Program yang diinstal pengguna
│ │  /etc                             │ │───┐  melalui manajer paket.
│ │  (File Konfigurasi)               │ │   │
│ └───────────────────────────────────┘ │   ▼
│ ┌───────────────────────────────────┐ │   Jantung konfigurasi sistem.
│ │  /home, /root                     │ │───┐
│ │  (Direktori Pengguna)             │ │   │
│ └───────────────────────────────────┘ │   ▼
│ ┌───────────────────────────────────┐ │   Tempat penyimpanan file pribadi.
│ │  /tmp, /var                       │ │───┐
│ │  (File Temporer & Variabel)       │ │   │
│ └───────────────────────────────────┘ │   ▼
│ ┌───────────────────────────────────┐ │   Data dinamis seperti log & cache.
│ │  /dev, /proc, /sys                │ │───┐
│ │  (Perangkat, Proses, Kernel)      │ │   │
│ └───────────────────────────────────┘ │   ▼
│                                       │   Antarmuka ke hardware & kernel.
└───────────────────────────────────────┘
```

# Selamat!

Fase satu selsai

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
