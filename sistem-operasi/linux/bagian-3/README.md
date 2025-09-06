### **[Fase 3: Menguasai Sistem — Menjadi Superuser (Expert/Enterprise)][0]**

Disini anda akan bertransformasi dari seorang pengguna yang mahir menjadi seorang **superuser** yang memiliki kendali penuh atas sistem.

-----

#### **Modul 5: Manajemen Perizinan (Permissions)**

**Struktur Pembelajaran Internal:**

<details>
  <summary>📃 Daftar Isi</summary>

  * **5.1** Dasar-dasar Izin File: `rwx` (read, write, execute).
  * **5.2** Tiga Kategori Pengguna: `Owner`, `Group`, dan `Others`.
  * **5.3** Mengubah Perizinan: Perintah `chmod`.
  * **5.4** Mengubah Kepemilikan: Perintah `chown` dan `chgrp`.
  * **5.5** Memahami Notasi Numerik (Octal) vs. Notasi Simbolik.
  * **5.6** Izin Khusus: `setuid`, `setgid`, dan `sticky bit`.
  * **5.7** Studi Kasus: Mengamankan Skrip Bash.

</details>

-----

### **Deskripsi Konkret & Peran dalam Kurikulum**

Modul ini adalah tentang **keamanan dan kontrol**. Di Linux, perizinan adalah fondasi dari seluruh sistem keamanan. Tanpa pemahaman yang mendalam tentang perizinan, Anda tidak dapat secara efektif melindungi file penting, mengamankan server, atau bahkan menjalankan program dengan benar. Modul ini adalah jembatan menuju administrasi sistem yang profesional, di mana Anda akan belajar bagaimana mengontrol siapa yang bisa melakukan apa di setiap sudut *filesystem*.

### **Konsep Kunci & Filosofi Mendalam**

Filosofi inti dari perizinan Linux adalah **"least privilege"** (hak akses seminimal mungkin). Ini berarti setiap pengguna dan program hanya boleh memiliki hak akses yang benar-benar mereka butuhkan untuk menjalankan fungsinya, tidak lebih. Dengan membatasi akses, risiko kerusakan yang tidak disengaja atau serangan berbahaya dapat diminimalisir.

Setiap file dan direktori memiliki tiga set izin untuk tiga kategori pengguna.

#### **5.1 Dasar-dasar Izin File**

Perizinan dasar terdiri dari tiga mode:

  * **`r` (read):** Hak untuk **membaca** konten file atau, pada direktori, hak untuk melihat daftar file di dalamnya.
  * **`w` (write):** Hak untuk **memodifikasi** atau **menghapus** file. Untuk direktori, ini adalah hak untuk membuat atau menghapus file di dalamnya.
  * **`x` (execute):** Hak untuk **menjalankan** file. Untuk direktori, ini adalah hak untuk **memasukinya** (`cd`). Tanpa izin `x` pada direktori, Anda tidak dapat mengakses kontennya, bahkan jika Anda memiliki izin `r`.

#### **5.2 Tiga Kategori Pengguna**

Izin ini diterapkan pada tiga entitas:

  * **`u` (user):** **Pemilik (owner)** file.
  * **`g` (group):** Anggota **grup** yang memiliki file.
  * **`o` (others):** **Semua pengguna lain** di sistem yang bukan pemilik atau anggota grup tersebut.

Output dari `ls -l` memberikan gambaran ini dengan jelas. Contoh: `drwxr-xr--`

  * `d`: Tipe file (direktori)
  * `rwx`: Izin untuk **pemilik**
  * `r-x`: Izin untuk **grup**
  * `r--`: Izin untuk **lainnya**

#### **5.3 Mengubah Perizinan: `chmod`**

Perintah `chmod` (**ch**ange **mod**e) digunakan untuk mengubah perizinan file atau direktori. Ini dapat dilakukan dengan dua cara:

  * **Notasi Simbolik:** Menggunakan huruf dan operator (`+`, `-`, `=`).
  * **Notasi Numerik (Octal):** Menggunakan angka desimal (0-7) di mana setiap angka mewakili kombinasi izin.

| Izin  | Nilai Numerik |
|---|-------------------|
|`r`| (read)        | 4 |
|`w`| (write)       | 2 |
|`x`| (execute)     | 1 |
|`-`| (tanpa izin)  | 0 |

Kombinasinya dijumlahkan: `rwx` adalah **$4+2+1=7$,** `rw-` adalah $4+2+0=6$, dan seterusnya.

#### **5.4 Mengubah Kepemilikan: `chown` & `chgrp`**

  * `chown` (**ch**ange **own**er): Mengubah pemilik file atau direktori.
  * `chgrp` (**ch**ange **gr**ou**p**): Mengubah grup yang terkait dengan file.

#### **5.6 Izin Khusus**

Ada izin khusus yang jarang dibahas tetapi sangat penting untuk keamanan sistem.

  * **`setuid` (set user ID):** Diterapkan pada file biner yang dapat dieksekusi. Ketika pengguna biasa menjalankan file dengan *setuid*, proses tersebut akan berjalan dengan hak akses **pemilik file** (sering kali `root`), bukan pengguna yang menjalankannya. Ini sangat berguna untuk program seperti `passwd`, yang harus menulis ke file yang dilindungi.
  * **`setgid` (set group ID):** Mirip dengan `setuid`, tetapi proses akan berjalan dengan hak akses grup pemilik. Pada direktori, ini memastikan bahwa file baru yang dibuat di dalamnya akan mewarisi grup yang sama.
  * **`sticky bit`:** Diterapkan pada direktori. File di dalam direktori dengan *sticky bit* hanya dapat dihapus atau diganti namanya oleh **pemiliknya**, bahkan jika pengguna lain memiliki izin `write`. Direktori `/tmp` adalah contoh klasik dari penggunaan *sticky bit* untuk mencegah pengguna menghapus file milik orang lain.

### **Sintaks Dasar / Contoh Implementasi Inti**

  * **Mengubah Perizinan:**
      * Memberikan izin `rwx` kepada pemilik, `rx` kepada grup, dan tidak ada izin untuk lainnya:
        ```bash
        # Notasi Simbolik
        chmod u=rwx,g=rx,o= fileku.txt
        # Notasi Numerik (lebih umum)
        chmod 750 fileku.txt
        ```
  * **Mengubah Kepemilikan:**
      * Mengubah pemilik file `script.sh` menjadi pengguna `johndoe` dan grup `developers`:
        ```bash
        sudo chown johndoe:developers script.sh
        ```
  * **Mengamankan Direktori Log:**
      * Membuat direktori `/var/log/myapp` yang hanya dapat diakses oleh pengguna `root` dan grup `myapploggers`:
        ```bash
        sudo mkdir /var/log/myapp
        sudo chown root:myapploggers /var/log/myapp
        sudo chmod 770 /var/log/myapp # Hanya root & myapploggers yang bisa rwx
        ```

### **Terminologi Esensial & Penjelasan Detil**

  * **Superuser (`root`):** Pengguna dengan hak akses tertinggi di sistem, yang dapat mengabaikan semua perizinan.
  * **Group:** Koleksi pengguna yang berbagi perizinan yang sama terhadap file dan direktori.

### **Rekomendasi Visualisasi**

Diagram tabel yang memvisualisasikan notasi numerik dan hubungannya dengan `rwx` akan sangat membantu. Sebuah ilustrasi yang menunjukkan bagaimana *sticky bit* diterapkan pada direktori `/tmp` juga akan memperjelas konsepnya.

### **Hubungan dengan Modul Lain**

  * **Prasyarat dari Modul 2:** Anda harus sudah tahu di mana file-file konfigurasi penting berada (`/etc`) dan bagaimana *symlink* bekerja untuk memahami bagaimana izin diterapkan pada struktur direktori yang kompleks.
  * **Lanjutan ke Modul 6:** Pengetahuan tentang perizinan sangat penting untuk mengelola *filesystem* secara aman, yang akan menjadi topik utama dalam modul berikutnya.

### **Sumber Referensi Lengkap**

  * **Linux File Permissions Explained:** [https://www.redhat.com/sysadmin/linux-file-permissions-101](https://www.google.com/search?q=https://www.redhat.com/sysadmin/linux-file-permissions-101)
  * **Arch Linux Wiki on `File permissions`:** [https://wiki.archlinux.org/title/File\_permissions](https://wiki.archlinux.org/title/File_permissions)
  * **Understanding `setuid`, `setgid`, and `sticky bit`:** [https://www.geeksforgeeks.org/special-permissions-set-user-id-set-group-id-and-sticky-bit-in-linux/](https://www.google.com/search?q=https://www.geeksforgeeks.org/special-permissions-set-user-id-set-group-id-and-sticky-bit-in-linux/)

### **Tips dan Praktik Terbaik**

  * **Jangan gunakan `chmod 777`:** Memberikan izin penuh kepada semua orang adalah praktik yang sangat tidak aman.
  * **Pikirkan dulu, baru jalankan:** Sebelum menjalankan `chmod` atau `chown`, jalankan `ls -l` untuk melihat perizinan saat ini dan pastikan Anda tahu persis apa yang akan Anda ubah.

### **Potensi Kesalahan Umum & Solusi**

  * **Kesalahan:** Mengubah perizinan file sehingga Anda sendiri tidak bisa membacanya atau mengeditnya.
      * **Solusi:** Selalu pastikan Anda mempertahankan izin yang memungkinkan Anda untuk melanjutkan pekerjaan. Jika Anda mengunci diri, Anda mungkin perlu beralih ke pengguna `root` atau `sudo` untuk memperbaikinya.

<!-- end list -->

```
┌───────────────────────────────┐
│     Manajemen Perizinan       │
│           (Modul 5)           │
│ ┌───────────────────────────┐ │
│ │  Dasar rwx                │ │───┐
│ │ (Read, Write, Execute)    │ │   │
│ └───────────────────────────┘ │   ▼
│ ┌───────────────────────────┐ │   Hak dasar untuk interaksi file.
│ │  Kategori Pengguna        │ │───┐
│ │ (Owner, Group, Others)    │ │   │
│ └───────────────────────────┘ │   ▼
│ ┌───────────────────────────┐ │   Siapa yang memiliki hak akses.
│ │  chmod                    │ │───┐
│ │ (Mengubah Izin)           │ │   │
│ └───────────────────────────┘ │   ▼
│ ┌───────────────────────────┐ │   Perintah utama untuk mengubah
│ │  chown & chgrp            │ │───┐  perizinan.
│ │ (Mengubah Kepemilikan)    │ │   │
│ └───────────────────────────┘ │   ▼
│                               │   Mengubah pemilik & grup file.
└───────────────────────────────┘
```

Disini anda akan mempelajari direktori-direktori penting lainnya dan bagaimana semua pengetahuan yang telah Anda dapatkan terhubung dalam praktik administrasi sistem sehari-hari.

-----

#### **Modul 6: Struktur Filesystem Lanjutan dan Praktik Admin**

**Struktur Pembelajaran Internal:**

  * **6.1** Direktori Boot & Kernel: `/boot`.
  * **6.2** Direktori Opsional: `/opt`.
  * **6.3** Direktori Layanan Jaringan: `/srv`.
  * **6.4** Direktori Sumber Kompilasi: `/usr/local`.
  * **6.5** Memahami Perbedaan Antar Direktori Terkait Program: `/bin` vs. `/sbin` vs. `/usr/bin` vs. `/usr/sbin`.
  * **6.6** Studi Kasus: Menemukan Sumber Masalah pada Sistem yang Tidak Stabil.

-----

### **Deskripsi Konkret & Peran dalam Kurikulum**

Modul ini adalah titik akhir yang mengintegrasikan semua pengetahuan Anda. Anda akan memahami direktori-direktori yang berperan dalam proses boot, instalasi perangkat lunak pihak ketiga, dan penyediaan layanan jaringan. Penjelasan tentang hierarki program (`/bin`, `/usr/bin`, dll.) akan menyempurnakan pemahaman Anda tentang bagaimana program diatur di sistem Linux. Dengan menguasai modul ini, Anda memiliki fondasi yang kuat untuk menjadi seorang administrator sistem yang andal.

### **Konsep Kunci & Filosofi Mendalam**

Filosofi di balik direktori-direktori ini adalah **spesialisasi dan fleksibilitas**. Mereka menyediakan lokasi yang terstruktur untuk file-file yang tidak cocok dengan direktori utama, seperti program yang diinstal secara manual (`/usr/local`) atau layanan server (`/srv`). Ini memungkinkan sistem untuk tetap rapi dan terorganisir meskipun dengan penambahan program atau layanan dari berbagai sumber.

#### **6.1 Direktori Boot & Kernel: `/boot`**

Direktori ini berisi semua file yang dibutuhkan oleh **bootloader** (seperti GRUB) untuk memulai proses booting sistem. File-file di sini mencakup:

  * **Kernel Linux:** Program inti dari sistem operasi.
  * **Initial RAM Disk (initrd):** Sebuah *filesystem* sementara yang dimuat ke memori saat boot. Ini berisi driver-driver yang diperlukan untuk mengakses sistem file root yang sebenarnya.

#### **6.2 Direktori Opsional: `/opt`**

`/opt` (optional) adalah direktori tempat paket perangkat lunak pihak ketiga yang besar, mandiri, atau tidak terkelola oleh manajer paket sistem, biasanya diinstal. Program yang diinstal di sini cenderung memiliki semua file (biner, library, dan konfigurasi) dalam satu sub-direktori, seperti `/opt/google-chrome`. Ini menjaga sisa *filesystem* Anda tetap bersih.

#### **6.3 Direktori Layanan Jaringan: `/srv`**

`/srv` (service) adalah tempat data yang akan **disajikan oleh sistem** disimpan. Misalnya, jika Anda mengonfigurasi server web, file-file HTML Anda bisa ditempatkan di `/srv/www`. Tujuannya adalah untuk memisahkan data layanan dari sisa sistem lainnya untuk manajemen dan keamanan yang lebih baik.

#### **6.4 Direktori Sumber Kompilasi: `/usr/local`**

Direktori ini dimaksudkan untuk program yang Anda **kompilasi dan instal secara manual dari kode sumber**. Ini menjaga program-program tersebut terpisah dari program yang diinstal oleh manajer paket (`pacman`), mencegah konflik dan memudahkan pembaruan sistem tanpa memengaruhi instalasi kustom Anda.

#### **6.5 Memahami Perbedaan Hierarki Program**

Memahami perbedaan antara `/bin`, `/sbin`, `/usr/bin`, dan `/usr/sbin` adalah kunci untuk pemecahan masalah dan administrasi.

  * **`/bin` & `/sbin`**: Berisi biner penting yang diperlukan saat sistem boot.
  * **`/usr/bin` & `/usr/sbin`**: Berisi biner yang diinstal oleh manajer paket dan tidak penting untuk boot awal.
    Di Arch Linux, `/bin` adalah **symlink** ke `/usr/bin`, yang menyederhanakan struktur.

### **Sintaks Dasar / Contoh Implementasi Inti**

  * **Studi Kasus: Memperbarui Kernel**

      * **Skenario:** Anda perlu menginstal kernel baru dari sumber.
      * **Pendekatan:** Setelah mengkompilasi, Anda akan menyalin file kernel ke `/boot`.
      * **Perintah:**
        ```bash
        # Mengubah direktori ke lokasi kode sumber
        cd /path/to/kernel/source
        # Menyiapkan file
        sudo make install
        # Menyalin file ke /boot
        sudo cp arch/x86_64/boot/bzImage /boot/vmlinuz-custom
        ```

  * **Studi Kasus: Menemukan Sumber Masalah**

      * **Skenario:** Layanan web Anda tidak berfungsi, tetapi Anda tidak yakin di mana lognya berada.
      * **Pendekatan:** Berdasarkan pengetahuan Anda tentang FHS, log harus ada di `/var/log`. Anda akan mencari file log yang terkait dengan layanan tersebut.
      * **Perintah:**
        ```bash
        # Mencari log terkait web server
        ls -l /var/log | grep http
        # Atau
        sudo grep -i "error" /var/log/nginx/error.log
        ```

### **Terminologi Esensial & Penjelasan Detil**

  * **Bootloader:** Program yang memuat sistem operasi ke memori saat komputer dinyalakan.
  * **Initial RAM Disk (initrd):** Sebuah *filesystem* mini dalam memori yang digunakan untuk memuat driver dan menyiapkan lingkungan sebelum *filesystem* root utama di-*mount*.

### **Hubungan dengan Modul Lain**

  * **Modul 1 & 2:** Modul ini adalah studi kasus nyata dari semua filosofi dan struktur direktori yang telah Anda pelajari di awal.
  * **Modul 3 & 5:** Keterampilan navigasi dan manajemen perizinan akan digunakan secara ekstensif saat Anda bekerja di direktori seperti `/boot`, `/opt`, atau `/srv`.

### **Sumber Referensi Lengkap**

  * **Arch Linux Wiki on `Kernel`:** [https://wiki.archlinux.org/title/Kernel](https://wiki.archlinux.org/title/Kernel)
  * **Filesystem Hierarchy Standard (FHS):** [https://refspecs.linuxfoundation.org/FHS\_3.0/fhs/ch03.html](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03.html) (Bagian yang menjelaskan `/opt`, `/srv`, dan lainnya).

### **Tips dan Praktik Terbaik**

  * **Gunakan manajer paket:** Kecuali Anda memiliki alasan yang sangat kuat, selalu gunakan manajer paket (`pacman`) untuk menginstal program daripada mengkompilasi dari sumber. Ini akan menempatkan file secara otomatis di lokasi yang benar dan memudahkan pembaruan.
  * **Jangan ubah file di `/boot` secara sembarangan:** Kesalahan kecil bisa membuat sistem Anda tidak bisa boot. Selalu berhati-hati dan buat cadangan.

### **Potensi Kesalahan Umum & Solusi**

  * **Kesalahan:** Menginstal program dari sumber ke direktori `/bin` atau `/usr/bin`.
      * **Solusi:** Selalu instal program yang Anda kompilasi secara manual ke `/usr/local/bin` untuk menjaga konsistensi dan menghindari konflik dengan manajer paket.
  * **Kesalahan:** Mengedit file di `/boot` tanpa memperbarui konfigurasi bootloader.
      * **Solusi:** Setelah menyalin file kernel baru, pastikan Anda juga memperbarui konfigurasi GRUB (biasanya dengan `sudo grub-mkconfig -o /boot/grub/grub.cfg`) agar bootloader tahu di mana harus menemukan kernel baru tersebut.

<!-- end list -->

```
┌───────────────────────────────────────┐
│     Struktur Lanjutan & Praktik Admin │
│                (Modul 6)              │
│ ┌───────────────────────────────────┐ │
│ │  /boot                            │ │───┐
│ │ (File Boot & Kernel)              │ │   │
│ └───────────────────────────────────┘ │   ▼
│ ┌───────────────────────────────────┐ │   Esensial untuk memulai sistem.
│ │  /opt, /srv, /usr/local           │ │───┐
│ │ (Instalasi & Layanan)             │ │   │
│ └───────────────────────────────────┘ │   ▼
│ ┌───────────────────────────────────┐ │   Fleksibilitas untuk instalasi
│ │  Hierarki Biner                   │ │───┐  manual & layanan.
│ │ (/bin, /sbin, /usr/bin)           │ │   │
│ └───────────────────────────────────┘ │   ▼
│                                       │   Memahami perbedaan tujuan
│                                       │   setiap folder.
└───────────────────────────────────────┘
```

# Selamat!

Saya telah menyelesaikan penjelasan mendalam untuk **Modul 6: Struktur Filesystem Lanjutan dan Praktik Admin**. Dengan ini, seluruh kurikulum telah diselesaikan.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

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
