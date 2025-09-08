### **[Fase 1: Persiapan dan Pra-Instalasi (Dalam Lingkungan Arch Live)][0]**

### **Modul 1: Memahami Lingkungan Arch Live & Koneksi Jaringan**

<details>
  <summary>📃 Daftar Isi</summary>

-----

#### **Struktur Pembelajaran Internal**

  * Deskripsi Konkret: Memulai di Arch Live
  * Konsep Kunci & Filosofi Mendalam: Lingkungan Sementara
  * Sintaks Dasar / Contoh Implementasi Inti
      * **Perintah `lsblk`**
      * **Perintah `ip link`**
      * **Perintah `ping`**
  * Terminologi Esensial: `Arch Live`, `root user`, `shell`, `DHCP`.
  * Verifikasi & *Output*
  * Hubungan dengan Modul Lain
  * Tips & Praktik Terbaik

</details>

-----

### **Deskripsi Konkret: Memulai di Arch Live**

Selamat datang di lingkungan **Arch Live**\! Ini adalah sistem operasi minimalis yang dimuat ke dalam memori komputer Anda langsung dari media instalasi (USB atau CD). Tujuannya adalah untuk menyediakan lingkungan kerja yang stabil dan fungsional agar Anda dapat menginstal sistem operasi utama Anda ke dalam *hard disk*.

Saat Anda berhasil *boot* dari USB Arch Linux, Anda akan langsung disuguhkan dengan *shell* Zsh. Tidak ada GUI, tidak ada *desktop environment*. Ini adalah murni CLI. Anda secara otomatis masuk sebagai ***root user***, yang berarti Anda memiliki hak akses penuh untuk melakukan apa pun pada sistem.

### **Konsep Kunci & Filosofi Mendalam: Lingkungan Sementara**

Filosofi di balik Arch Live adalah **minimalisme dan kontrol**. Ini bukan sistem yang akan Anda gunakan sehari-hari; ini adalah sebuah "alat bedah" yang dirancang untuk satu tujuan: menginstal Arch Linux.

  * **Minimalisme:** Hanya paket-paket esensial yang disertakan. Ini membuat ISO-nya kecil dan proses *booting* cepat.
  * **Kontrol:** Karena tidak ada GUI, Anda dipaksa untuk menggunakan CLI. Hal ini memastikan Anda memahami setiap perintah yang Anda jalankan, yang merupakan fondasi untuk menjadi seorang ahli.

### **Sintaks Dasar / Contoh Implementasi Inti**

Sekarang, mari kita mulai dengan langkah-langkah diagnostik awal.

#### **Perintah 1: `lsblk`**

Tugas pertama Anda adalah mengidentifikasi perangkat penyimpanan (`hard disk` atau SSD) dan partisi-partisi yang ada.

```bash
# Perintah ini akan mencantumkan semua perangkat blok
# (seperti hard disk, partisi, dll.) yang terhubung ke sistem.
lsblk
```

  * **Penjelasan Mendalam:** `lsblk` adalah singkatan dari **"list block devices"**. Perangkat blok adalah perangkat penyimpanan yang memindahkan data dalam "blok" atau potongan berukuran tetap, seperti *hard disk* atau SSD. Perintah ini akan menampilkan struktur pohon hierarkis dari perangkat penyimpanan Anda.

  * **Output yang Diharapkan:** Anda akan melihat tabel dengan kolom seperti `NAME`, `MAJ:MIN`, `RM`, `SIZE`, `RO`, `TYPE`, dan `MOUNTPOINT`.

      * `NAME`: Nama perangkat (misalnya, `sda`, `nvme0n1`, atau partisi `sda1`).
      * `SIZE`: Ukuran total perangkat atau partisi.
      * `TYPE`: Menunjukkan apakah itu *disk* atau partisi (`part`).

  * **Verifikasi Keberhasilan:** Lihatlah *output* dan identifikasi nama perangkat penyimpanan utama Anda. Biasanya, itu adalah `sda` jika Anda menggunakan *drive* SATA, atau `nvme0n1` jika Anda menggunakan NVMe SSD. Pastikan ukurannya sesuai dengan *hard disk* atau SSD fisik Anda.

#### **Perintah 2: `ip link` dan `ip a`**

Selanjutnya, kita akan memastikan bahwa Anda memiliki koneksi jaringan.

```bash
# Perintah ini akan menampilkan status semua perangkat jaringan Anda.
ip link

# Perintah ini akan menampilkan informasi alamat IP yang diberikan ke perangkat jaringan.
ip a
```

  * **Penjelasan Mendalam:** `ip` adalah utilitas modern untuk mengelola antarmuka jaringan. `ip link` akan menunjukkan perangkat jaringan yang tersedia (misalnya, `lo` untuk *loopback*, `enp1s0` untuk *ethernet*, `wlan0` untuk WiFi). `ip a` atau `ip addr` akan menampilkan alamat IP yang telah diberikan kepada mereka.

      * **Filosofi:** Linux tidak mengaktifkan jaringan secara otomatis pada semua perangkat. Perintah ini membantu Anda mengidentifikasi perangkat mana yang perlu diaktifkan atau dikonfigurasi.

  * **Output yang Diharapkan:** Setelah menjalankan `ip a`, Anda akan melihat antarmuka jaringan Anda. Jika Anda terhubung ke jaringan dengan kabel Ethernet, Anda mungkin melihat alamat IP di bawah nama perangkat (misal, `enp1s0`). Jika Anda tidak melihat alamat IP, itu berarti koneksi belum diaktifkan.

#### **Perintah 3: `ping`**

Ini adalah uji coba akhir untuk memastikan koneksi Anda benar-benar berfungsi.

```bash
# Menguji koneksi dengan mengirimkan paket ke Google DNS.
ping -c 3 8.8.8.8
```

  * **Penjelasan Mendalam:** `ping` mengirimkan paket data kecil ke alamat IP atau nama *host* tertentu dan menunggu respons. Ini menguji apakah ada jalur komunikasi yang valid antara Anda dan tujuan.

      * **Filosofi:** `ping` adalah "tes denyut jantung" jaringan. Jika `ping` berhasil, Anda tahu bahwa koneksi internet Anda aktif dan berfungsi.

  * **Output yang Diharapkan:** Anda akan melihat *output* yang menunjukkan paket-paket berhasil dikirim dan diterima. Contohnya: `3 packets transmitted, 3 received, 0% packet loss`. Jika *output* menunjukkan `100% packet loss`, itu berarti koneksi Anda tidak berfungsi.

-----

### **Verifikasi & *Output***

Setelah menjalankan ketiga perintah ini, Anda harus dapat menjawab pertanyaan-pertanyaan berikut:

1.  Apa nama perangkat *hard disk* atau SSD Anda?
2.  Apakah Anda memiliki koneksi internet yang berfungsi?

Jawaban atas pertanyaan ini adalah verifikasi bahwa Anda telah berhasil menyelesaikan modul ini.

### **Hubungan dengan Modul Lain**

  * **Ke Modul 2 (Manajemen Partisi):** Identifikasi perangkat yang Anda lakukan dengan `lsblk` adalah prasyarat mutlak untuk mempartisi *disk* tersebut di modul berikutnya. Tanpa mengetahui nama perangkat, Anda tidak bisa menggunakan `fdisk` atau `gdisk`.
  * **Ke Modul 4 (Instalasi Sistem Inti):** Koneksi internet adalah prasyarat untuk mengunduh paket-paket sistem dasar menggunakan `pacstrap`.

### **Tips & Praktik Terbaik**

  * **Nama Perangkat:** Nama perangkat seperti `sda`, `sdb`, `nvme0n1` dapat bervariasi. Selalu gunakan `lsblk` untuk memverifikasi nama perangkat yang benar sebelum menjalankan perintah partisi atau *mount* yang destruktif.
  * **Koneksi:** Jika Anda menggunakan WiFi, Anda akan memerlukan langkah-langkah tambahan menggunakan `iwctl`. Kita bisa membahas ini secara mendalam jika Anda perlu.

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
