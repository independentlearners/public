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

-----

Anda telah berhasil mengidentifikasi perangkat keras dan menguji koneksi jaringan. Langkah selanjutnya adalah menyiapkan *hard disk* atau SSD Anda untuk instalasi. Di modul ini, kita akan fokus pada manajemen partisi, sebuah langkah yang sangat penting dan memerlukan presisi.

-----

### **Modul 2: Manajemen Partisi: *Disk*, GPT, dan MBR**

#### **Struktur Pembelajaran Internal**

  * Deskripsi Konkret: Mempersiapkan Ruang Penyimpanan
  * Konsep Kunci & Filosofi Mendalam: Partisi dan Strukturnya
  * Sintaks Dasar / Contoh Implementasi Inti
      * **Perintah `fdisk` (untuk MBR)**
      * **Perintah `gdisk` (untuk GPT)**
  * Terminologi Esensial: `fdisk`, `gdisk`, `partisi`, `filesystem`.
  * Verifikasi & *Output*
  * Hubungan dengan Modul Lain
  * Tips & Praktik Terbaik

-----

### **Deskripsi Konkret: Mempersiapkan Ruang Penyimpanan**

Setelah Anda tahu nama *hard disk* atau SSD Anda (misal, `/dev/sda`), langkah berikutnya adalah membaginya menjadi beberapa bagian logis yang disebut **partisi**. Setiap partisi dapat menampung *filesystem* yang berbeda, seperti `ext4` untuk sistem operasi dan `swap` untuk memori virtual.

Tugas Anda sekarang adalah menggunakan utilitas CLI untuk membuat partisi baru yang akan menampung instalasi Arch Linux Anda. Kita akan menggunakan **`fdisk`** untuk skema partisi lama (**MBR**) dan **`gdisk`** untuk skema partisi modern (**GPT**). Sesuai dengan kurikulum kita, kita akan fokus pada GPT karena itu adalah standar modern yang dipasangkan dengan UEFI.

### **Konsep Kunci & Filosofi Mendalam: Partisi dan Strukturnya**

Bayangkan *hard disk* Anda adalah sebuah buku kosong yang besar. Untuk mengisi buku itu dengan cerita yang berbeda (sistem operasi, data pribadi, dsb.), Anda perlu membagi buku menjadi beberapa bab (**partisi**).

  * **Skema Partisi:** Adalah "daftar isi" atau "cetak biru" yang memberi tahu komputer bagaimana buku itu dibagi.

      * **MBR (Master Boot Record):** Skema lama, seperti daftar isi sederhana di halaman pertama buku. Terbatas, hanya bisa mencatat hingga 4 bab utama.
      * **GPT (GUID Partition Table):** Skema modern, seperti daftar isi digital yang fleksibel, dapat mencatat hampir tak terbatas jumlah bab dan mendukung *hard disk* yang sangat besar.

  * **Utilitas Partisi:**

      * **`fdisk`:** Digunakan untuk bekerja dengan skema **MBR**. Ia hanya bisa berinteraksi dengan tabel partisi MBR.
      * **`gdisk`:** Digunakan untuk bekerja dengan skema **GPT**. Ini adalah alat yang lebih direkomendasikan dan akan menjadi fokus kita.

### **Sintaks Dasar / Contoh Implementasi Inti**

Kita akan menggunakan `gdisk` untuk membuat partisi di *hard disk* yang telah Anda identifikasi. Asumsikan nama *disk* Anda adalah `/dev/sda`.

```bash
# Perintah untuk memulai gdisk pada hard disk yang ingin Anda partisi.
sudo gdisk /dev/sda
```

Setelah perintah ini, Anda akan masuk ke dalam *shell* interaktif `gdisk`.

#### **Langkah-langkah Mempartisi dengan `gdisk` (GPT)**

1.  **Hapus Partisi yang Ada:** Jika Anda ingin memulai dari awal, ketik `o` dan tekan `Enter`. Ini akan membuat tabel partisi **GPT** yang baru. Konfirmasikan dengan `y`.

2.  **Buat Partisi ESP:** Partisi ini wajib untuk instalasi UEFI.

      * Ketik `n` dan tekan `Enter` untuk membuat partisi baru.
      * Pilih nomor partisi (biarkan kosong untuk *default*).
      * Pilih sektor awal dan akhir (biarkan kosong untuk *default*).
      * Pilih kode partisi. Masukkan **`ef00`** dan tekan `Enter`. `ef00` adalah kode hex untuk **EFI System Partition**.
      * Deskripsi: Partisi ini akan diformat sebagai FAT32 dan akan menampung *bootloader* Anda.

3.  **Buat Partisi `swap` (Opsional):** Partisi `swap` berfungsi sebagai memori virtual.

      * Ketik `n` lagi untuk partisi baru.
      * Pilih nomor partisi.
      * Tentukan ukuran, misal `+4G` (4 gigabyte).
      * Pilih kode partisi. Masukkan **`8200`** dan tekan `Enter`. `8200` adalah kode untuk Linux *swap*.

4.  **Buat Partisi *root* (`/`):** Partisi ini akan menampung seluruh sistem operasi Arch Linux Anda.

      * Ketik `n` lagi.
      * Gunakan sisa ruang yang ada.
      * Pilih kode partisi **`8300`** (Linux *filesystem*).

5.  **Simpan & Keluar:**

      * Ketik `w` dan tekan `Enter` untuk menulis perubahan ke *disk*.
      * Konfirmasikan dengan `y`.

Setelah keluar dari `gdisk`, Anda akan kembali ke *shell* Arch Live.

### **Terminologi Esensial & Penjelasan Detil**

  * **Partisi:** Pembagian logis dari *hard disk* fisik. Setiap partisi diperlakukan oleh sistem operasi sebagai *disk* terpisah.
  * ***Filesystem*:** Struktur data yang mengorganisir dan menyimpan *file* pada sebuah partisi. Contoh: `ext4`, `FAT32`, `NTFS`.
  * **`fdisk`:** **F**ixed **D**isk, utilitas CLI untuk mengelola tabel partisi MBR.
  * **`gdisk`:** **G**PT **D**isk, utilitas modern untuk mengelola tabel partisi GPT.

### **Verifikasi & *Output***

Setelah menyelesaikan langkah-langkah di `gdisk` dan kembali ke *shell* utama, verifikasi partisi baru Anda dengan menjalankan perintah `lsblk` lagi.

```bash
lsblk
```

  * **Output yang Diharapkan:** Anda akan melihat partisi-partisi baru di bawah *disk* Anda (`/dev/sda`). Misal, Anda akan melihat `/dev/sda1` (ESP), `/dev/sda2` (Swap), dan `/dev/sda3` (Root) dengan ukurannya masing-masing. Ini adalah bukti keberhasilan bahwa partisi telah dibuat dengan benar.

### **Hubungan dengan Modul Lain**

  * **Ke Modul 3 (Memformat Partisi):** Memahami manajemen partisi adalah prasyarat untuk modul berikutnya. Setelah Anda membuat partisi dengan `gdisk`, Anda harus memformatnya dengan *filesystem* yang benar menggunakan `mkfs`.
  * **Ke Modul 6 (Bootloader):** Partisi ESP yang Anda buat di sini adalah tempat di mana *bootloader* akan dipasang. Membuat partisi ini dengan benar adalah kunci untuk instalasi UEFI yang sukses.

### **Tips & Praktik Terbaik**

  * **Hati-hati:** Partisi adalah langkah yang destruktif. Pastikan Anda memilih *hard disk* yang benar. Jika Anda ragu, gunakan `lsblk` untuk memverifikasi nama dan ukuran *disk* Anda.
  * **Prioritaskan GPT:** Selalu gunakan **GPT** dengan **UEFI**. Ini adalah kombinasi yang paling kuat, aman, dan fleksibel untuk sistem modern.

------

Anda telah berhasil mempartisi *hard disk* Anda. Langkah selanjutnya yang sangat penting adalah menyiapkan ***filesystem*** di partisi-partisi tersebut. Memformat partisi adalah seperti mengambil buku yang telah Anda bagi menjadi bab-bab dan memberikan setiap babnya sebuah "struktur" agar tulisan (data) bisa diatur dan disimpan.

-----

### **Modul 3: Memformat Partisi & *Mounting* Sistem**

#### **Struktur Pembelajaran Internal**

  * Deskripsi Konkret: Menyiapkan *Filesystem*
  * Konsep Kunci & Filosofi Mendalam: Peran *Filesystem* dan *Mounting*
  * Sintaks Dasar / Contoh Implementasi Inti
      * **Perintah `mkfs`**
      * **Perintah `swapon`**
      * **Perintah `mount`**
  * Terminologi Esensial: `Filesystem`, `ext4`, `FAT32`, `mkfs`, `mount`.
  * Verifikasi & *Output*
  * Hubungan dengan Modul Lain
  * Tips & Praktik Terbaik

-----

### **Deskripsi Konkret: Menyiapkan *Filesystem***

Setelah mempartisi dengan `gdisk`, partisi-partisi Anda masih "kosong" dari sisi struktur data. Anda perlu memformatnya dengan *filesystem* yang sesuai agar Linux dapat menggunakannya.

  * **Partisi ESP** (EFI System Partition) harus diformat dengan **FAT32**, karena ini adalah *filesystem* yang wajib dikenali oleh *firmware* UEFI.
  * **Partisi *root*** (`/`) akan diformat dengan **`ext4`**, yang merupakan standar dan pilihan yang stabil untuk sistem Linux.
  * **Partisi *swap*** tidak diformat dengan `mkfs`, tetapi dengan utilitas `mkswap`.

Setelah partisi diformat, Anda harus "memasangnya" atau *mount* ke lokasi tertentu di direktori *live environment* Anda. Ini adalah langkah krusial yang menghubungkan partisi fisik di *disk* dengan struktur direktori logis di Linux.

### **Konsep Kunci & Filosofi Mendalam: Peran *Filesystem* dan *Mounting***

Bayangkan setiap partisi adalah sebuah lemari kosong.

  * ***Filesystem*** adalah sistem organisasi yang Anda terapkan di dalam lemari tersebut. Anda bisa memilih untuk mengaturnya berdasarkan warna (FAT32), berdasarkan jenis barang (`ext4`), atau lainnya. Tanpa sistem organisasi ini, Anda tidak bisa menaruh apa pun di dalamnya.
  * ***Mounting*** adalah proses "membuka pintu" lemari tersebut dan menempatkannya di sebuah ruangan (direktori). Partisi `/dev/sda3` adalah nama lemari, dan `/mnt` adalah nama ruangan di mana Anda menempatkannya. Dengan *mounting*, Anda bisa mengakses isi partisi seolah-olah itu adalah sebuah direktori.

### **Sintaks Dasar / Contoh Implementasi Inti**

Kita akan menggunakan partisi yang telah Anda buat di Modul 2:

  * `/dev/sda1` untuk ESP
  * `/dev/sda2` untuk *swap*
  * `/dev/sda3` untuk *root*

#### **Perintah 1: Memformat Partisi**

```bash
# Format partisi EFI (ESP) dengan FAT32
# -F 32 artinya FAT32.
mkfs.fat -F 32 /dev/sda1

# Format partisi root (/) dengan ext4
mkfs.ext4 /dev/sda3

# Format partisi swap
mkswap /dev/sda2
```

  * **Penjelasan Mendalam:** Perintah `mkfs` (make filesystem) adalah utilitas untuk membuat *filesystem*. Varian seperti `mkfs.fat` dan `mkfs.ext4` secara spesifik memformat partisi dengan *filesystem* yang ditentukan. Perintah `mkswap` menyiapkan partisi untuk digunakan sebagai ruang *swap*.

  * **Output yang Diharapkan:** Setelah setiap perintah, Anda akan melihat pesan yang menunjukkan bahwa *filesystem* atau ruang *swap* telah berhasil dibuat.

#### **Perintah 2: Mengaktifkan Ruang *Swap***

```bash
# Perintah ini mengaktifkan partisi swap yang baru saja diformat.
swapon /dev/sda2
```

  * **Penjelasan Mendalam:** Perintah `swapon` adalah singkatan dari "swap on." Ia memberi tahu *kernel* untuk mulai menggunakan partisi yang ditentukan sebagai ruang *swap* atau memori virtual.

  * **Verifikasi Keberhasilan:** Anda tidak akan melihat *output* apa pun jika berhasil, tetapi Anda bisa memverifikasinya dengan perintah `swapon --show`.

#### **Perintah 3: Mengaitkan Partisi (*Mount*)**

```bash
# Mount partisi root ke /mnt
mount /dev/sda3 /mnt

# Buat direktori untuk partisi EFI dan mount di sana
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
```

  * **Penjelasan Mendalam:** `mount` adalah perintah untuk menautkan perangkat (partisi) ke direktori. Direktori `/mnt` adalah konvensi standar yang digunakan oleh banyak distribusi Linux sebagai lokasi sementara untuk *mounting*. `mkdir -p` memastikan direktori (`/mnt/boot/efi`) dibuat jika belum ada.

  * **Verifikasi Keberhasilan:** Gunakan perintah `lsblk` lagi. Anda sekarang akan melihat `MOUNTPOINT` terisi. Partisi `/dev/sda3` akan memiliki *mountpoint* `/mnt`, dan `/dev/sda1` akan memiliki `/mnt/boot/efi`.

### **Terminologi Esensial & Penjelasan Detil**

  * **`mkfs`:** Kependekan dari *Make Filesystem*.
  * **`ext4`:** *Fourth extended filesystem*, *filesystem* *journaling* standar untuk Linux.
  * **`FAT32`:** *File Allocation Table 32*, *filesystem* sederhana yang kompatibel dengan banyak sistem operasi.
  * ***Mounting*:** Proses membuat isi partisi dapat diakses melalui direktori tertentu di sistem *filesystem*.
  * ***Swap*:** Ruang di *disk* yang digunakan sebagai memori virtual ketika RAM fisik penuh.

### **Hubungan dengan Modul Lain**

  * **Ke Modul 4 (Instalasi Paket):** Anda tidak bisa menginstal sistem inti Arch Linux dengan `pacstrap` sampai Anda memformat dan *mount* partisi *root* dengan benar.
  * **Ke Modul 6 (*Bootloader*):** Partisi ESP yang Anda format dan *mount* di sini akan menjadi tempat instalasi *bootloader*.

### **Tips & Praktik Terbaik**

  * **Urutan itu Penting:** Selalu *mount* partisi *root* (`/`) terlebih dahulu, lalu *mount* partisi lain (seperti ESP) di dalam direktori *root* yang sudah di-*mount* (`/mnt`).
  * **Periksa dengan Cermat:** Sebelum menjalankan `mount`, gunakan `lsblk` untuk memastikan Anda menggunakan nama perangkat yang benar. Kesalahan di sini bisa sangat fatal.

# Selamat!

Anda telah berhasil memformat dan mount partisi. Sekarang, kita akan melakukan langkah inti dari seluruh proses instalasi: menginstal paket-paket dasar sistem Arch Linux ke partisi root Anda.

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
