### **[Fase 2: Navigasi dan Modifikasi — Menguasai Peta (Intermediate)][0]**

Sekarang kita akan beralih ke fase kedua, di mana Anda akan menguasai navigasi dan manajemen *filesystem* layaknya seorang profesional.

-----

#### **Modul 3: Navigasi dan Manajemen Filesystem Tingkat Lanjut**

**Struktur Pembelajaran Internal:**

<details>
  <summary>📃 Daftar Isi</summary>

  * **3.1** Navigasi Tingkat Lanjut: Jalan Pintas (`.` , `..` , `~` , `-`).
  * **3.2** Mencari File: Perintah `find` dan `locate`.
  * **3.3** Memahami dan Membuat Tautan: **Symbolic Link** (`symlink`) dan **Hard Link**.
  * **3.4** Mengelola Ruang Disk: Perintah `df` dan `du`.
  * **3.5** Studi Kasus: Menemukan dan Mengelola File Log yang Memenuhi Ruang Disk.

</details>

-----

### **Deskripsi Konkret & Peran dalam Kurikulum**

Modul ini adalah tentang **efisiensi dan presisi**. Setelah Anda memahami peta (struktur direktori), modul ini akan membekali Anda dengan kendaraan (perintah-perintah canggih) untuk menavigasi dan mengelola file dengan lebih cepat dan cerdas. Ini adalah lompatan dari pengguna biasa ke pengguna yang efisien, yang tahu persis bagaimana menemukan dan memanipulasi data di lingkungan CLI tanpa harus bergantung pada antarmuka grafis.

### **Konsep Kunci & Filosofi Mendalam**

Filosofi di balik perintah-perintah ini adalah **otomatisasi dan fleksibilitas**. Daripada menjelajahi setiap direktori secara manual, Anda bisa meminta sistem untuk melakukan pencarian kompleks untuk Anda. Tautan, di sisi lain, memungkinkan Anda mengatur *filesystem* dengan cara yang lebih logis tanpa harus menggandakan file, menghemat ruang dan waktu.

#### **3.1 Navigasi Tingkat Lanjut**

Ini adalah cara para ahli menavigasi *filesystem* tanpa mengetik banyak.

  * **`cd .`**: Mengacu pada **direktori saat ini** (current directory). Perintah ini sering digunakan dalam skrip untuk memastikan perintah dijalankan di lokasi yang benar.
  * **`cd ..`**: Mengacu pada **direktori induk** (parent directory). Ini adalah salah satu perintah navigasi paling fundamental untuk bergerak satu tingkat ke atas dalam hierarki.
  * **`cd ~`**: Jalan pintas untuk langsung kembali ke **direktori home** pengguna Anda (`/home/username`).
  * **`cd -`**: Perintah ini sangat berguna, akan membawa Anda kembali ke **direktori sebelumnya** tempat Anda berada. Ini seperti tombol "kembali" di browser.

#### **3.2 Mencari File**

  * **`find`**: Perintah yang sangat kuat dan fleksibel untuk mencari file di dalam hirarki direktori. Anda dapat mencari berdasarkan nama, tipe file, ukuran, waktu modifikasi, dan banyak kriteria lainnya. `find` bekerja secara *real-time* dengan memindai direktori satu per satu.
  * **`locate`**: Perintah yang jauh lebih cepat daripada `find` karena ia mencari di database yang telah diindeks sebelumnya. Namun, database ini mungkin tidak selalu *up-to-date*. Anda harus menjalankan `updatedb` (biasanya sebagai *root*) untuk memperbarui database.

#### **3.3 Memahami Tautan (Link)**

Tautan adalah cara untuk membuat "referensi" ke file atau direktori lain. Ada dua jenis:

  * **Symbolic Link (`symlink`)**: Mirip dengan pintasan (shortcut) di Windows. Ini adalah file kecil yang hanya berisi jalur ke file atau direktori asli. Jika file asli dihapus, *symlink* akan rusak (menjadi "broken link"). Mereka sangat umum, terutama di `/usr/bin` yang sering kali merupakan *symlink* ke lokasi file sebenarnya.
  * **Hard Link**: Ini adalah entri direktori tambahan yang menunjuk ke lokasi data yang sama di disk. Berbeda dengan *symlink*, *hard link* bukanlah file terpisah, melainkan nama lain untuk file yang sama. Jika file asli dihapus, data masih dapat diakses melalui *hard link* karena jumlah referensinya (*link count*) akan berkurang satu, tetapi data fisik tidak akan dihapus sampai referensi terakhir hilang.

#### **3.4 Mengelola Ruang Disk**

  * **`df` (Disk Free)**: Menampilkan penggunaan ruang disk dari **sistem file yang di-*mount***. Ini memberikan gambaran besar tentang seberapa penuh partisi Anda.
  * **`du` (Disk Usage)**: Menghitung penggunaan ruang disk dari **direktori atau file tertentu**. Ini sangat berguna untuk menemukan "biang keladi" yang menghabiskan ruang disk.

### **Sintaks Dasar / Contoh Implementasi Inti**

  * **Mencari File:**

      * Mencari file bernama `nginx.conf` di seluruh sistem:
        ```bash
        sudo find / -name nginx.conf
        ```
      * Mencari semua file `.log` di direktori home Anda:
        ```bash
        find ~/ -name "*.log"
        ```

  * **Membuat Tautan:**

      * Membuat *symlink* dari `/usr/bin/python3` ke `python`:
        ```bash
        sudo ln -s /usr/bin/python3 /usr/bin/python
        ```
      * Membuat *hard link* untuk file `file_asli.txt`:
        ```bash
        ln file_asli.txt file_salinan_hardlink.txt
        ```

  * **Melihat Penggunaan Disk:**

      * Melihat penggunaan disk yang mudah dibaca (*human-readable*):
        ```bash
        df -h
        du -sh /var/log
        ```

### **Terminologi Esensial & Penjelasan Detil**

  * **`-s` (summarize):** Opsi untuk `du` yang menampilkan total ukuran direktori, bukan rincian setiap subdirektori.
  * **`-h` (human-readable):** Opsi untuk `df` dan `du` yang menampilkan ukuran dalam format mudah dibaca (misalnya, `10G` bukan `10737418240`).
  * **`inode` (index node):** Struktur data di *filesystem* yang menyimpan informasi tentang file atau direktori, seperti metadata, pemilik, perizinan, dan lokasi data. *Hard link* semuanya menunjuk ke *inode* yang sama.

### **Rekomendasi Visualisasi**

Diagram alur atau ilustrasi konsep visual untuk **Symbolic Link** vs. **Hard Link** sangat disarankan. Sebuah ilustrasi yang membandingkan cara kerja `find` (memindai) dan `locate` (mencari database) juga akan sangat membantu pemahaman.

### **Hubungan dengan Modul Lain**

  * **Prasyarat dari Modul 2:** Anda harus sudah memahami direktori seperti `/var/log` dan `/etc` agar tahu di mana harus mencari file.
  * **Lanjutan ke Modul 5:** Konsep *inode* dan *hard link* secara langsung berhubungan dengan cara perizinan dan kepemilikan file disimpan, yang akan dibahas lebih dalam di **Modul 5**.

### **Sumber Referensi Lengkap**

  * **Linux `find` command:** [https://www.tecmint.com/15-linux-find-command-examples/](https://www.google.com/search?q=https://www.tecmint.com/15-linux-find-command-examples/)
  * **Linux `ln` command (link):** [https://www.geeksforgeeks.org/ln-command-in-linux-with-examples/](https://www.geeksforgeeks.org/ln-command-in-linux-with-examples/)
  * **Linux `du` command:** [https://www.tecmint.com/linux-du-command-examples/](https://www.google.com/search?q=https://www.tecmint.com/linux-du-command-examples/)

### **Tips dan Praktik Terbaik**

  * **Gunakan `find` dengan hati-hati**: Jika Anda mencari di direktori *root* (`/`), gunakan `sudo find /` dan tambahkan opsi `-xdev` untuk mencegah pencarian melintasi *mount point* ke sistem file lain, seperti jaringan atau perangkat eksternal.
  * **Cek *man page***: Perintah `find` memiliki banyak sekali opsi. Selalu cek `man find` untuk opsi-opsi yang Anda butuhkan.

### **Potensi Kesalahan Umum & Solusi**

  * **Kesalahan:** Menganggap *hard link* dan *symlink* itu sama.
      * **Solusi:** Ingat: **S**ymlink untuk **S**hortcut. Jika file asli dihapus, *symlink* rusak. **H**ard link untuk **H**ard-core. Ia adalah nama file baru, dan data fisik hanya dihapus saat semua *hard link* ke *inode* tersebut dihapus.
  * **Kesalahan:** Menggunakan `locate` tanpa memperbarui database.
      * **Solusi:** Jika Anda baru saja membuat file, jalankan `sudo updatedb` terlebih dahulu, lalu jalankan `locate`.

<!-- end list -->

```
┌───────────────────────────────────────┐
│     Navigasi & Manajemen Lanjutan     │
│             (Modul 3)                 │
│ ┌───────────────────────────────────┐ │
│ │  Navigasi Cepat                   │ │───┐
│ │ (cd ., cd .., cd ~, cd -)         │ │   │
│ └───────────────────────────────────┘ │   ▼
│ ┌───────────────────────────────────┐ │   Bergerak di filesystem tanpa
│ │  Mencari File                     │ │───┐  mengetik banyak.
│ │ (find, locate)                    │ │   │
│ └───────────────────────────────────┘ │   ▼
│ ┌───────────────────────────────────┐ │   Menemukan file dengan kriteria
│ │  Membuat Tautan                   │ │───┐  spesifik.
│ │ (ln -s, ln)                       │ │   │
│ └───────────────────────────────────┘ │   ▼
│ ┌───────────────────────────────────┐ │   Membuat pintasan atau nama
│ │  Mengelola Disk                   │ │───┐  alternatif untuk file.
│ │ (df, du)                          │ │   │
│ └───────────────────────────────────┘ │   ▼
│                                       │   Melihat sisa dan penggunaan
│                                       │   ruang disk.
└───────────────────────────────────────┘
```

-----

#### **Modul 4: Direktori Penting Lainnya dan Konsep Mount**

**Struktur Pembelajaran Internal:**

  * **4.1** Direktori untuk Perangkat: `/dev`.
  * **4.2** Direktori untuk Proses: `/proc`.
  * **4.3** Direktori untuk Kernel: `/sys`.
  * **4.4** Konsep `Mount Point` & `fstab`.
  * **4.5** Studi Kasus: Menghubungkan dan Melepas Perangkat Penyimpanan Eksternal.

-----

### **Deskripsi Konkret & Peran dalam Kurikulum**

Modul ini adalah tentang memahami bagian-bagian sistem yang paling dinamis dan misterius. Direktori `/dev`, `/proc`, dan `/sys` adalah antarmuka langsung ke kernel dan perangkat keras Anda. Mereka tidak berisi file fisik yang tersimpan di disk, melainkan file "virtual" yang dibuat dan diperbarui oleh kernel secara *real-time*. Mempelajari ini adalah kunci untuk diagnostik, pemecahan masalah tingkat lanjut, dan pemahaman mendalam tentang cara kerja sistem Linux di bawah permukaan.

### **Konsep Kunci & Filosofi Mendalam**

Filosofi di balik direktori-direktori ini adalah **abstrak dan virtual**. Daripada mengharuskan program berinteraksi langsung dengan perangkat keras (yang sangat kompleks dan rawan kesalahan), kernel menyediakan "file" di direktori ini sebagai titik interaksi yang seragam dan sederhana. Ini mengimplementasikan kembali filosofi "semuanya adalah file" ke tingkat yang lebih dalam, memungkinkan kita untuk membaca informasi atau mengirim perintah ke perangkat keras dan proses yang sedang berjalan hanya dengan membaca atau menulis ke file.

#### **4.1 Direktori `/dev` (devices)**

`/dev` berisi file spesial yang merepresentasikan perangkat keras. Saat Anda membaca dari file di `/dev`, Anda sedang membaca data dari perangkat keras yang diwakilinya. Begitu pula, saat Anda menulis ke file, Anda sedang mengirimkan data atau perintah ke perangkat tersebut.

  * **Block Devices:** Merepresentasikan perangkat yang mentransfer data dalam blok, seperti *hard drive* (`/dev/sda`, `/dev/nvme0n1`), partisi (`/dev/sda1`), atau flash drive USB.
  * **Character Devices:** Merepresentasikan perangkat yang mentransfer data sebagai aliran karakter, seperti terminal (`/dev/tty1`), *sound card*, atau *null device* (`/dev/null`).

#### **4.2 Direktori `/proc` (processes)**

`/proc` adalah filesystem virtual yang dibuat saat sistem boot. Direktori ini berisi informasi tentang **proses yang sedang berjalan** dan **status kernel**. Anda akan menemukan direktori bernomor yang sesuai dengan setiap **ID Proses (PID)** yang sedang aktif.

  * **Informasi Proses:** Setiap direktori `/proc/<PID>` berisi file-file yang memberikan detail tentang proses tersebut, seperti memori yang digunakan (`status`), *executable* yang dijalankan (`exe`), dan file yang terbuka (`fd`).
  * **Informasi Kernel:** File-file seperti `/proc/cpuinfo` (informasi CPU), `/proc/meminfo` (informasi memori), dan `/proc/version` (versi kernel) memberikan gambaran langsung tentang kondisi sistem.

#### **4.3 Direktori `/sys` (system)**

Mirip dengan `/proc`, `/sys` adalah filesystem virtual lain yang menyediakan antarmuka terstruktur ke **perangkat dan driver**. Direktori ini memungkinkan Anda mengkonfigurasi perangkat keras tanpa memerlukan *kernel module* kustom atau program spesifik. Contohnya, Anda dapat mengubah kecerahan layar dengan menulis ke file di `/sys/class/backlight`.

#### **4.4 Konsep `Mount Point` dan `/etc/fstab`**

Seperti yang dibahas sebelumnya, `mount` adalah proses "menempelkan" sistem file dari suatu perangkat ke sebuah direktori di pohon *filesystem* utama. File `/etc/fstab` (**f**ile **s**ystem **tab**le) adalah file konfigurasi krusial yang berisi daftar sistem file yang akan di-*mount* secara otomatis saat sistem boot. Mengedit file ini memungkinkan Anda untuk mengkonfigurasi partisi tambahan atau drive eksternal agar selalu tersedia di lokasi yang Anda tentukan.

### **Sintaks Dasar / Contoh Implementasi Inti**

  * **Studi Kasus: Memeriksa Informasi CPU**

      * **Skenario:** Anda ingin melihat detail teknis tentang CPU Anda tanpa menginstal program tambahan.
      * **Perintah:**
        ```bash
        cat /proc/cpuinfo
        ```
      * **Keterangan:** Perintah ini akan membaca konten file `/proc/cpuinfo` dan menampilkannya di terminal.

  * **Studi Kasus: Memasang & Melepas Flash Drive**

      * **Skenario:** Anda mencolokkan flash drive, dan ingin mengakses isinya.
      * **Perintah:**
        ```bash
        # 1. Identifikasi perangkat (misalnya /dev/sdb1)
        sudo fdisk -l

        # 2. Buat direktori mount point
        sudo mkdir /mnt/usb

        # 3. Pasang perangkat ke direktori
        sudo mount /dev/sdb1 /mnt/usb

        # 4. Navigasi ke direktori mount point
        cd /mnt/usb

        # 5. Ketika selesai, lepas perangkat
        sudo umount /mnt/usb
        ```
      * **Keterangan:** Menggunakan `fdisk -l` untuk menemukan nama perangkat, `mkdir` untuk membuat lokasi, `mount` untuk menghubungkan, dan `umount` untuk melepaskan. `sudo` diperlukan karena ini adalah operasi tingkat sistem.

### **Terminologi Esensial & Penjelasan Detil**

  * **ID Proses (PID):** Nomor unik yang diberikan oleh kernel untuk setiap proses yang berjalan.
  * **Sistem File Virtual:** Sistem file yang tidak berada di disk fisik, melainkan ada dalam memori dan dibuat oleh kernel secara dinamis.
  * **`fstab`:** Singkatan dari **f**ile **s**ystem **tab**le, file di `/etc` yang mengatur *mount point* otomatis.

### **Hubungan dengan Modul Lain**

  * **Modul 1 & 2:** Modul ini adalah contoh nyata dari filosofi "semuanya adalah file" dan konsep *mount point* yang diperkenalkan di awal.
  * **Modul 5 & 6:** Pemahaman tentang `/proc` dan `/sys` sangat penting untuk pemecahan masalah dan pemantauan sistem, yang merupakan tugas rutin seorang administrator.

### **Sumber Referensi Lengkap**

  * **Arch Linux Wiki on `fstab`:** [https://wiki.archlinux.org/title/Fstab](https://wiki.archlinux.org/title/Fstab)
  * **Linux Documentation Project on `/dev`:** [https://www.tldp.org/LDP/sag/html/devices.html](https://www.google.com/search?q=https://www.tldp.org/LDP/sag/html/devices.html)
  * **Linux Documentation Project on `/proc`:** [https://www.tldp.org/LDP/sag/html/proc-fs.html](https://www.tldp.org/LDP/sag/html/proc-fs.html)

### **Tips dan Praktik Terbaik**

  * **Jangan pernah menghapus file di `/dev`, `/proc`, atau `/sys`:** File-file ini tidak menggunakan ruang disk. Menghapusnya dapat menyebabkan masalah fatal pada sistem Anda.
  * **Selalu gunakan `umount` sebelum mencabut perangkat:** Ini memastikan semua operasi tulis selesai dan mencegah kerusakan data.

### **Potensi Kesalahan Umum & Solusi**

  * **Kesalahan:** Perintah `mount` gagal karena direktori *mount point* tidak ada.
      * **Solusi:** Pastikan Anda membuat direktori kosong terlebih dahulu dengan `sudo mkdir /mnt/nama_folder`.
  * **Kesalahan:** Gagal melepaskan perangkat karena masih ada proses yang menggunakannya.
      * **Solusi:** Gunakan perintah `lsof /path/to/mount/point` atau `fuser -m /path/to/mount/point` untuk menemukan proses yang sedang berjalan, lalu bunuh proses tersebut jika perlu (`kill <PID>`).

<!-- end list -->

```
┌───────────────────────────────────────┐
│     Direktori Khusus & Konsep Mount   │
│                (Modul 4)              │
│ ┌───────────────────────────────────┐ │
│ │  /dev                             │ │───┐
│ │ (Antarmuka Perangkat Keras)       │ │   │
│ └───────────────────────────────────┘ │   ▼
│ ┌───────────────────────────────────┐ │   File virtual untuk berinteraksi
│ │  /proc                            │ │───┐  dengan hardware.
│ │ (Informasi Proses & Kernel)       │ │   │
│ └───────────────────────────────────┘ │   ▼
│ ┌───────────────────────────────────┐ │   Memberikan insight real-time
│ │  /sys                             │ │───┐  tentang sistem.
│ │ (Antarmuka Driver)                │ │   │
│ └───────────────────────────────────┘ │   ▼
│ ┌───────────────────────────────────┐ │   Menyediakan cara terstruktur untuk
│ │  Mount Point                      │ │───┐  mengkonfigurasi kernel.
│ │ (Mengikat Filesystem)             │ │   │
│ └───────────────────────────────────┘ │   ▼
│                                       │   Menghubungkan partisi atau drive
│                                       │   eksternal ke pohon direktori.
└───────────────────────────────────────┘
```

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
