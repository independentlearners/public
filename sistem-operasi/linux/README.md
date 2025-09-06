#  **[Peta lengkap semua folder penting di Linux/Unix-like (beserta fungsinya)][0]**
Prasyarat:

  * **Pemahaman Dasar CLI:** Memahami cara membuka terminal dan menjalankan perintah dasar seperti `ls`, `cd`, dan `pwd`. Jika belum, mulailah dengan tutorial dasar Linux CLI terlebih dahulu.
  * **Sistem Operasi:** Memiliki sistem operasi Linux/Unix-like terinstal (disarankan **Arch Linux** sesuai preferensi Anda).

Alat Esensial:

  * **Terminal Emulator:** Aplikasi terminal default di Arch Linux (`xterm`, `alacritty`, `kitty`, atau `gnome-terminal` jika Anda menginstalnya)
  * **Editor Teks CLI:** `Vim`, `Neovim`, atau `Nano` untuk mengedit file konfigurasi.
  * **Shell:** Shell default Bash atau Zsh.

Hasil Pembelajaran (Learning Outcomes):

Setelah menyelesaikan kurikulum ini, Anda akan:

  * Memahami struktur hierarki filesystem Linux/Unix-like secara mendalam, termasuk filosofi di baliknya.
  * Mampu menavigasi, mengelola, dan memodifikasi file serta direktori dengan efisien menggunakan perintah-perintah CLI.
  * Mengidentifikasi fungsi dan peran dari setiap direktori penting, dari `/bin` hingga `/var`.
  * Mampu mendiagnosis masalah umum terkait filesystem dan menemukan file penting dengan cepat.
  * Memiliki fondasi kuat untuk melangkah ke tingkat **superuser** (administrator sistem) dan mengelola sistem Linux secara profesional.

-----

### **[Fase 1: Fundamental — Memahami Peta Jalan (Beginner)][1]**

**Waktu Estimasi:** 10-15 jam

Fase ini adalah fondasi yang akan memberikan Anda pemahaman holistik tentang mengapa filesystem Linux diatur seperti itu dan memperkenalkan Anda pada direktori paling penting yang akan sering Anda temui.

#### **Modul 1: Filosofi Hierarki Filesystem (Filesystem Hierarchy Standard/FHS)**

1.  **Deskripsi Konkret:** Anda akan mempelajari filosofi dan standar di balik penataan direktori di Linux/Unix-like. Ini bukan hanya tentang menghafal nama-nama folder, tetapi memahami alasan di balik strukturnya.

2.  **Konsep Dasar dan Filosofi:** FHS adalah standar yang mendefinisikan direktori utama dan isinya di sistem operasi Linux. Tujuannya adalah untuk menjaga konsistensi di antara berbagai distribusi, sehingga administrator sistem dan pengembang tahu persis di mana mereka akan menemukan file yang mereka butuhkan. Filosofi utamanya adalah **"semuanya adalah file"** dan **pemisahan file yang dapat dibagikan (shareable) dari yang tidak dapat dibagikan (unshareable)**, serta **data statis dari data dinamis**.

3.  **Sintaks Dasar/Contoh:**

    ```bash
    # Perintah untuk melihat semua direktori di root
    ls -l /
    ```

4.  **Terminologi Kunci:**

      * **Root Directory (`/`):** Direktori paling atas atau pangkal dari seluruh pohon filesystem. Semua direktori dan file lainnya berada di dalamnya. Ini berbeda dengan `root` user.
      * **Filesystem Hierarchy Standard (FHS):** Standar yang mengatur struktur direktori utama di Linux.
      * **Mount Point:** Direktori tempat sistem file lain (misalnya, partisi hard disk atau flash drive USB) dipasang.
      * **Shared vs. Unshared Data:** Data yang dapat diakses oleh beberapa sistem (misalnya, file biner program) versus data yang spesifik untuk satu host (misalnya, file konfigurasi `/etc`).
      * **Static vs. Dynamic Data:** Data yang tidak berubah tanpa campur tangan administrator (misalnya, file biner `/bin`) versus data yang terus berubah saat sistem berjalan (misalnya, log `/var/log`).

5.  **Daftar Isi:**

      * Apa itu Filesystem Hierarchy Standard (FHS)?
      * Filosofi "Semuanya adalah File".
      * Pemisahan Direktori `bin`, `lib`, dan `usr`.
      * Perbedaan antara Data Statis, Dinamis, dan Data yang Dapat Dibagikan.

6.  **Sumber Referensi:**

      * [Filesystem Hierarchy Standard (FHS) - Official Documentation](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)
      * [Linux Foundation FHS Introduction](https://www.linuxfoundation.org/blog/2012/03/the-linux-filesystem-hierarchy-primer/)

-----

#### **Modul 2: Direktori Esensial Tingkat Tinggi**

1.  **Deskripsi Konkret:** Anda akan memahami peran dari direktori-direktori inti yang berada di tingkat root (`/`) dan menjadi tulang punggung sistem.

2.  **Konsep Dasar:** Direktori ini adalah "pusat komando" dari sistem Linux. Setiap direktori memiliki fungsi khusus yang tidak boleh dilanggar untuk menjaga stabilitas sistem.

3.  **Sintaks Dasar/Contoh:**

      * Menjelajahi direktori `/etc`: `ls /etc`
      * Melihat file biner: `ls /bin`
      * Melihat informasi proses: `ls /proc`

4.  **Terminologi Kunci:**

      * **`/bin` (Binaries):** Berisi perintah-perintah biner (executable) penting untuk boot dan fungsionalitas dasar sistem. Contoh: `ls`, `cp`, `mv`.
      * **`/etc` (Et cetera):** Tempat menyimpan file konfigurasi sistem yang tidak dapat dibagikan. Contoh: `passwd`, `fstab`, `bash.bashrc`.
      * **`/home` (Home Directories):** Direktori pribadi untuk setiap pengguna non-root. Contoh: `/home/username`.
      * **`/root`:** Direktori home untuk pengguna `root`.
      * **`/usr` (Unix System Resources):** Berisi file-file yang dapat dibagikan, termasuk biner dan library tambahan yang diinstal oleh pengguna. Contoh: `bin`, `lib`, `share`.
      * **`/var` (Variable):** Berisi file-file yang isinya sering berubah selama sistem berjalan. Contoh: `log`, `mail`, `tmp`.

5.  **Daftar Isi:**

      * Penjelasan `/bin`, `/sbin`, dan `/lib`.
      * Peran `/etc` sebagai pusat konfigurasi.
      * Memahami `/home` dan `/root`.
      * Fungsi `/usr`, `/var`, `/tmp`.

6.  **Sumber Referensi:**

      * [A Detailed Guide to Linux Filesystem Structure](https://www.geeksforgeeks.org/linux-file-system-structure/)
      * [A Tour of the Linux Filesystem - How-To Geek](https://www.howtogeek.com/117435/htg-explains-the-linux-directory-structure-explained/)

-----

### **[Fase 2: Navigasi dan Modifikasi — Menguasai Peta (Intermediate)][2]**

**Waktu Estimasi:** 15-20 jam

Fase ini akan membawa Anda dari hanya "mengetahui" direktori menjadi "mengelola" dan "memahami" isinya secara lebih mendalam, termasuk navigasi yang efisien dan konsep penting lainnya.

#### **Modul 3: Navigasi dan Manajemen Filesystem Tingkat Lanjut**

1.  **Deskripsi Konkret:** Modul ini akan memperdalam kemampuan Anda dalam menavigasi direktori dan memanipulasi file menggunakan perintah-perintah CLI.

2.  **Konsep Dasar:** Meskipun perintah dasar sudah dikenal, modul ini akan membahas opsi-opsi lanjutan yang membuat pekerjaan lebih efisien. Misalnya, memahami `.` dan `..` secara lebih dalam atau menggunakan `tree` untuk visualisasi.

3.  **Sintaks Dasar/Contoh:**

      * Menggunakan `find` untuk mencari file: `find / -name "filename.txt"`
      * Melihat penggunaan disk: `df -h`
      * Membuat file dan direktori: `mkdir -p /path/to/new/dir && touch /path/to/new/dir/file.txt`
      * Visualisasi struktur direktori: `tree /etc`

4.  **Terminologi Kunci:**

      * **`find`:** Perintah untuk mencari file dan direktori berdasarkan nama, tipe, ukuran, dan kriteria lainnya.
      * **`df` (Disk Free):** Perintah untuk melaporkan penggunaan ruang disk sistem file.
      * **`du` (Disk Usage):** Perintah untuk memperkirakan penggunaan ruang file.
      * **`symlink` (Symbolic Link) atau `hardlink`:** Link atau pintasan ke file atau direktori lain. `symlink` adalah pointer, sedangkan `hardlink` adalah entri direktori tambahan untuk file yang sama.

5.  **Daftar Isi:**

      * Navigasi Lanjutan: `.`, `..`, `~`, `-`.
      * Mencari File dengan `find` dan `locate`.
      * Memahami Symlink dan Hardlink.
      * Perintah `df` dan `du` untuk mengelola ruang disk.

6.  **Sumber Referensi:**

      * [Linux `find` command explained with examples](https://www.tecmint.com/15-linux-find-command-examples/%5D\(https://www.tecmint.com/15-linux-find-command-examples/\))
      * [Difference between Symlink and Hardlink](https://www.geeksforgeeks.org/difference-between-hard-link-and-symbolic-link-in-linux/)

-----

#### **Modul 4: Direktori Penting Lainnya dan Konsep Mount**

1.  **Deskripsi Konkret:** Anda akan menyelami direktori yang kurang umum tetapi sama pentingnya, seperti `/dev`, `/proc`, dan `/sys`. Anda juga akan memahami bagaimana perangkat eksternal diakses oleh sistem.

2.  **Konsep Dasar:** Direktori ini bukan berisi file "biasa". `/dev` adalah antarmuka ke perangkat keras, `/proc` adalah jendela ke kernel yang sedang berjalan, dan `/sys` adalah cara lain untuk berinteraksi dengan kernel dan perangkat. Mereka adalah representasi dari data yang dinamis dan virtual, yang sangat penting untuk diagnosis dan administrasi sistem.

3.  **Sintaks Dasar/Contoh:**

      * Melihat perangkat: `ls /dev`
      * Melihat informasi CPU dari `/proc`: `cat /proc/cpuinfo`
      * Memasang drive USB: `mount /dev/sdb1 /mnt/usb`

4.  **Terminologi Kunci:**

      * **`/dev` (Devices):** Berisi file-file spesial yang merepresentasikan perangkat keras sistem (misalnya, `sda` untuk hard disk, `tty1` untuk terminal).
      * **`/proc` (Processes):** Sebuah filesystem virtual yang berisi informasi tentang proses yang sedang berjalan, memori, dan status kernel.
      * **`/sys` (System):** Filesystem virtual lain yang menyediakan antarmuka ke perangkat dan driver.
      * **`mount`:** Perintah yang digunakan untuk melampirkan sistem file eksternal (partisi, USB, dll.) ke sebuah direktori di pohon filesystem utama.

5.  **Daftar Isi:**

      * Menggali `/dev`, `/proc`, dan `/sys`.
      * Konsep Mount dan Umount.
      * Filesystem Virtual vs. Filesystem Fisik.
      * Memahami `fstab` dan `df`.

6.  **Sumber Referensi:**

      * [Understanding `/dev`, `/proc`, and `/sys`](https://www.linuxtopia.org/online_books/linux_system_administration/ch24s03.html%5D\(https://www.linuxtopia.org/online_books/linux_system_administration/ch24s03.html\))
      * [Linux `fstab` Explained](https://wiki.archlinux.org/title/fstab%5D\(https://wiki.archlinux.org/title/fstab\))

-----

### **[Fase 3: Menguasai Sistem — Menjadi Superuser (Expert/Enterprise)][3]**

**Waktu Estimasi:** 20-30+ jam

Fase ini adalah lompatan dari pengguna mahir ke administrator sistem. Anda akan belajar mengelola filesystem dari perspektif superuser, berurusan dengan perizinan, dan mengimplementasikan praktik keamanan.

#### **Modul 5: Manajemen Perizinan (Permissions)**

1.  **Deskripsi Konkret:** Anda akan belajar bagaimana sistem mengontrol siapa yang dapat membaca, menulis, dan menjalankan file. Memahami perizinan adalah kunci untuk keamanan dan administrasi sistem yang efektif.

2.  **Konsep Dasar:** Setiap file dan direktori di Linux memiliki tiga set izin: untuk **pemilik (owner)**, **grup (group)**, dan **lainnya (others)**. Izin tersebut adalah **read (r)**, **write (w)**, dan **execute (x)**. Kombinasi ini memberikan kontrol granular atas akses ke sumber daya.

3.  **Sintaks Dasar/Contoh:**

      * Mengubah izin: `chmod 755 script.sh` (owner rwx, group rx, others rx).
      * Mengubah pemilik: `chown user:group filename`
      * Memahami output `ls -l`: `drwxr-xr-x`

4.  **Terminologi Kunci:**

      * **`chmod` (Change Mode):** Perintah untuk mengubah izin file.
      * **`chown` (Change Owner):** Perintah untuk mengubah pemilik file.
      * **Numeric vs. Symbolic Notation:** Dua cara untuk menetapkan izin, misalnya `755` (numerik) vs. `u=rwx,g=rx,o=rx` (simbolik).
      * **`suid`, `sgid`, `sticky bit`:** Izin khusus yang memengaruhi bagaimana file biner dieksekusi atau bagaimana file dibuat di direktori.

5.  **Daftar Isi:**

      * Dasar-dasar Perizinan `rwx`.
      * Numeric vs. Symbolic Mode.
      * Menggunakan `chmod`, `chown`, dan `chgrp`.
      * Memahami Izin Khusus: `suid`, `sgid`, dan `sticky bit`.

6.  **Sumber Referensi:**

      * [Linux File Permissions Explained](https://www.redhat.com/sysadmin/linux-file-permissions-101)
      * [Arch Linux Wiki - File Permissions](https://wiki.archlinux.org/title/File_permissions)

-----

#### **Modul 6: Struktur Filesystem Lanjutan dan Praktik Admin**

1.  **Deskripsi Konkret:** Modul ini akan memperluas pemahaman Anda tentang direktori yang digunakan untuk administrasi, log, dan manajemen paket. Anda akan belajar bagaimana file-file ini berinteraksi untuk menjaga sistem tetap sehat.

2.  **Konsep Dasar:** Sebagai administrator, Anda perlu tahu di mana menemukan log sistem (`/var/log`), di mana paket-paket diinstal (`/usr/bin`), dan bagaimana boot sistem (`/boot`). Memahami interkoneksi direktori ini adalah kunci untuk pemecahan masalah.

3.  **Sintaks Dasar/Contoh:**

      * Melihat log: `tail -f /var/log/syslog`
      * Melihat file kernel: `ls /boot`
      * Mencari biner yang diinstal: `which nano`
      * Memahami struktur paket: `ls /usr/share/doc/`

4.  **Terminologi Kunci:**

      * **`/boot`:** Berisi file-file yang diperlukan untuk proses bootloader dan kernel.
      * **`/opt`:** Direktori untuk instalasi perangkat lunak pihak ketiga yang tidak dikelola oleh manajer paket sistem.
      * **`/srv`:** Direktori untuk data situs web yang disajikan oleh server.
      * **`/usr/local`:** Direktori untuk biner, library, dan header yang dikompilasi dari sumber secara manual.

5.  **Daftar Isi:**

      * Mengelola log di `/var/log`.
      * Memahami peran `/boot` dan `/sbin`.
      * Perbedaan `/bin`, `/sbin`, `/usr/bin`, `/usr/sbin`.
      * Mengenal `/opt` dan `/usr/local` untuk instalasi manual.

6.  **Sumber Referensi:**

      * [Linux Boot Process Explained](https://www.linux.com/training-certification/linux-boot-process-explained/)
      * [Arch Linux Wiki - The `root`](https://wiki.archlinux.org/title/File_hierarchy%5D) [filesystem](https://wiki.archlinux.org/title/File_hierarchy)

-----

### **Sumber Daya Komunitas & Sertifikasi**

  * **Komunitas:**

      * **Arch Linux Wiki:** Sumber daya terkemuka untuk pengguna Arch, dengan dokumentasi yang sangat detail dan akurat.
      * **Reddit r/linux4noobs & r/linuxquestions:** Komunitas yang ramah untuk bertanya dan mendapatkan bantuan.
      * **Stack Overflow:** Sumber daya global untuk pertanyaan teknis.

  * **Sertifikasi:**

      * **CompTIA Linux+:** Sertifikasi tingkat pemula yang mencakup dasar-dasar Linux.
      * **LPIC-1 (Linux Professional Institute Certification):** Sertifikasi yang diakui secara global untuk administrator junior.
      * **RHCSA (Red Hat Certified System Administrator):** Sertifikasi yang sangat dihormati dan berorientasi praktik untuk sistem Red Hat, tetapi konsepnya sangat relevan untuk semua distribusi.

-----

[0]: ../../README.md     
[1]: ./bagian-1/README.md
[2]: ./bagian-2/README.md
[3]: ./bagian-3/README.md
