Banyak orang langsung belajar `grep`, tapi bingung ketika outputnya tidak bisa disimpan ke file, atau kenapa error message tidak hilang saat di-filter. Oleh karena itu, sebelum masuk ke `grep`, saya menambahkan **Sub-Modul 1.0: The Anatomy of Linux Streams**. Ini adalah *prasyarat mutlak* untuk Text Processing.

-----

# 🚀 FASE 1: The Stream & The Search (Pondasi & Pencarian)

Fase ini adalah tentang bagaimana kita mengontrol data yang bergerak dan bagaimana kita menangkap informasi dari data tersebut.

## BAGIAN 1.0: The Anatomy of Streams (Anatomi Aliran Data)

**Status:** *Tambahan Esensial (Foundation Layer)*

Sebelum kita memproses teks, kita harus paham "di mana" teks itu mengalir. Di Linux (terutama Arch yang Anda gunakan), **Teks adalah Arus Air**, dan Command Line Tools (Grep, Sed, Awk) adalah **Pipa dan Filternya**.

-----

<details>
  <summary>📃 Daftar Isi</summary>

### 📋 Daftar Isi Bagian 1.0

1.  **Konsep:** *Everything is a File* & *The Stream*.
2.  **Mekanisme:** Standard Input (0), Standard Output (1), Standard Error (2).
3.  **Sintaks & Operator:** Piping (`|`), Redirection (`>`, `>>`, `2>`).
4.  **Studi Kasus Arch:** Memisahkan log error pacman.
5.  **Praktek Terbaik & Keamanan Data.**

-----

</details>


### 1\. Deskripsi Konkret & Peran

Bagian ini mengajarkan Anda cara mengendalikan *arah* informasi. Tanpa ini, Anda hanya bisa melihat teks di layar tapi tidak bisa menyimpannya, membuang pesan error yang mengganggu, atau mengoper data dari satu program ke program lain. Ini adalah mekanisme transportasi utama dalam Text Processing.

### 2\. Konsep Kunci & Filosofi

**Filosofi:** *Unix Philosophy — "Expect the output of every program to become the input to another, as yet unknown, program."*
(Harapkan keluaran setiap program menjadi masukan bagi program lain yang belum diketahui).

**Analogi:**
Bayangkan sistem Linux Anda adalah sebuah pabrik pengolahan air.

  * **Data Teks:** Air.
  * **Program (Grep/Sed):** Mesin filter/pemanas air.
  * **Terminal (CLI):** Muara akhir (tempat air keluar).
  * **Pipe (`|`):** Pipa penyambung antar mesin.

### 3\. Terminologi Esensial & English Context

  * **File Descriptor (FD) / Noun:**
      * *Definisi:* Angka integer non-negatif yang digunakan kernel (inti OS) untuk menunjuk file atau aliran data yang terbuka.
      * *English Context:* "File Descriptor 1 points to stdout." (Deskriptor berkas 1 menunjuk ke keluaran standar).
  * **Stream / Noun:**
      * *Definisi:* Urutan byte data yang dibaca atau ditulis secara berurutan.
      * *English Context:* "The text stream flows from the keyboard to the program." (Aliran teks mengalir dari keyboard ke program).
  * **Verbose / Adjective:**
      * *Definisi:* Mode di mana program memberikan output yang sangat detail/banyak.
      * *English Context:* "Run the command in verbose mode to see what's happening." (Jalankan perintah dalam mode verbose untuk melihat apa yang terjadi).

-----

### 4\. Anatomi Tiga Aliran Suci (The Holy Trinity of Streams)

Setiap kali Anda menjalankan perintah di terminal (misal: `ls` atau `pacman`), Linux membuka 3 saluran secara otomatis:

1.  **STDIN (Standard Input) - FD 0:**
      * **Sumber:** Biasanya Keyboard.
      * **Fungsi:** Jalan masuk data ke program.
2.  **STDOUT (Standard Output) - FD 1:**
      * **Tujuan:** Layar Terminal (Console).
      * **Fungsi:** Tempat program menampilkan hasil **sukses**.
3.  **STDERR (Standard Error) - FD 2:**
      * **Tujuan:** Layar Terminal (Console).
      * **Fungsi:** Tempat program menampilkan pesan **error/diagnostik**.
      * *Catatan Penting:* Meskipun STDOUT dan STDERR sama-sama muncul di layar, mereka mengalir di "pipa" yang berbeda. Ini krusial.

-----

### 5\. Sintaks Dasar & Implementasi Inti

Mari kita bedah operator pengalihan (*redirection*) secara mendalam, kata per kata.

#### A. Operator Pipe (`|`)

Menghubungkan STDOUT program kiri ke STDIN program kanan.

**Sintaks:**

```bash
command1 | command2
```

  * `command1`: Perintah pertama (Penghasil data).
  * `|`: "Ambil hasil sukses dari kiri, masukkan ke mulut program kanan".
  * `command2`: Perintah kedua (Pemroses data).

**Contoh Konkret (Arch Linux):**
Melihat daftar paket yang terinstall, tapi hanya 5 baris pertama.

```bash
pacman -Q | head -n 5
```

  * `pacman -Q`: List semua paket (ribuan baris) -\> STDOUT.
  * `|`: Menangkap STDOUT tersebut sebelum sampai ke layar.
  * `head -n 5`: Mengambil 5 baris teratas dari input yang diterima.

#### B. Operator Redirection Output (`>` dan `>>`)

**1. Overwrite (Timpa) `>`**

```bash
echo "Baris Pertama" > catatan.txt
```

  * `echo ...`: Perintah mencetak teks.
  * `>`: "Alihkan STDOUT ke file. **HAPUS** isi file lama jika ada, lalu tulis yang baru." (**Hati-hati\!**)
  * `catatan.txt`: File tujuan.

**2. Append (tambah) `>>`**

```bash
echo "Baris Kedua" >> catatan.txt
```

  * `>>`: "Alihkan STDOUT ke file. Tambahkan di baris paling **BAWAH** tanpa menghapus isi lama."

#### C. Mengelola Error (`2>` dan `2>&1`)

Inilah bagian tersulit bagi pemula. Mari kita simulasikan error. Kita coba akses file yang tidak ada.

**Skenario:**

```bash
ls file_ada.txt file_tidak_ada.txt > hasil.txt
```

  * Output di layar: `ls: cannot access 'file_tidak_ada.txt': No such file or directory`
  * Isi `hasil.txt`: Hanya berisi info `file_ada.txt`.
  * *Kenapa?* Karena pesan error berjalan di jalur **STDERR (FD 2)**, sedangkan `>` hanya menangkap **STDOUT (FD 1)**.

**Solusi: Menangkap Error**

```bash
ls file_tidak_ada.txt 2> error.log
```

  * `2>`: "Ambil stream nomor 2 (STDERR), dan alihkan ke file error.log."

**Teknik Master: Menggabungkan Semua Output**
Seringkali dalam logging sistem, kita ingin output sukses DAN error masuk ke satu file yang sama.

```bash
ls file_ngawur.txt > semua_log.txt 2>&1
```

**Bedah Sintaks Kata per Kata:**

1.  `ls ...`: Jalankan perintah.
2.  `> semua_log.txt`: Alihkan FD 1 (Standard Output) ke file `semua_log.txt`.
3.  `2>`: Arahkan FD 2 (Standard Error)...
4.  `&1`: ...ke lokasi yang sama dengan FD 1 (yaitu ke dalam file `semua_log.txt`).
      * `&` di sini berarti "alamat referensi dari file descriptor".

-----

### 6\. Potensi Kesalahan Umum & Solusi

  * **Kesalahan:** Menggunakan `>` saat ingin menambah log, sehingga data lama hilang terhapus.
      * **Solusi:** Selalu gunakan `>>` untuk log, kecuali Anda yakin ingin mereset file.
  * **Kesalahan:** Mencoba `grep` error message tetapi gagal.
      * *Kasus:* `command_error | grep "Error"` (Tidak akan muncul apa-apa).
      * *Penyebab:* `|` (Pipe) secara default hanya mengalirkan STDOUT. Error (STDERR) lewat jalur samping dan melewati grep.
      * *Solusi:* Redirect error ke stdout dulu: `command_error 2>&1 | grep "Error"`.

-----

### 7\. Sumber Referensi

  * **GNU Bash Manual - Redirections:** [GNU.org - Bash Redirections](https://www.gnu.org/software/bash/manual/html_node/Redirections.html)
  * **Arch Wiki - Bash:** [Arch Wiki - Bash](https://wiki.archlinux.org/title/Bash)
  * **Greg's Wiki (BashGuide):** [Standard Streams](https://mywiki.wooledge.org/BashGuide/InputAndOutput)

-----

## BAGIAN 1.1: GREP — The Filter (Penyaringan Presisi)

**Level:** Foundation to Intermediate

Setelah paham aliran (Streams), kita masuk ke alat utama pertama: **GREP** (Global Regular Expression Print).

### 📋 Daftar Isi Bagian 1.1

1.  Sintaks Anatomi Grep.
2.  Mode Operasi: Fixed String vs Basic Regex.
3.  Invert Match (`-v`): Seni membuang sampah.
4.  Context Control (`-A`, `-B`, `-C`): Melihat sekitar.
5.  Recursive Search (`-r`) di Direktori Proyek.

-----

### 1\. Deskripsi Konkret & Peran

`grep` adalah saringan Anda. Di dunia pemrograman dan SysAdmin, Anda sering dihadapkan pada file log berisi jutaan baris. Membaca manual itu mustahil. `grep` memungkinkan Anda bertanya: *"Tunjukkan hanya baris yang mengandung kata 'FATAL' dan abaikan sisanya."*

### 2\. Sintaks Dasar & Implementasi Inti

**Sintaks Umum:**

```bash
grep [OPTIONS] PATTERN [FILE...]
```

**Contoh Sederhana (Literal String):**
Mencari user bernama "root" di file konfigurasi user sistem.

```bash
grep "root" /etc/passwd
```

  * `grep`: Panggil program.
  * `"root"`: Pola string yang dicari (Case Sensitive secara default).
  * `/etc/passwd`: File target (Database user di Linux).

**Output:**

```text
root:x:0:0::/root:/bin/bash
```

-----

### 3\. Studi Kasus Mendalam: Opsi-Opsi Kunci (Flags)

Berikut adalah flag `grep` yang wajib dikuasai oleh calon expert, dijelaskan dengan studi kasus nyata di Arch Linux.

#### A. Case Insensitive (`-i`)

Manusia sering tidak konsisten (Error, error, ERROR).

```bash
grep -i "error" /var/log/pacman.log
```

  * **Fungsi:** Mencocokkan "error", "Error", "ERROR", "eRRoR".

#### B. Invert Match (`-v`)

Kadang, lebih mudah mendefinisikan apa yang **TIDAK** kita inginkan.

  * *Kasus:* Anda ingin melihat file konfigurasi, tapi file tersebut penuh dengan komentar (baris yang diawali `#`).
  * *Tujuan:* Tampilkan baris konfigurasi aktif saja.

<!-- end list -->

```bash
grep -v "^#" /etc/pacman.d/mirrorlist
```

  * `-v`: *Invert* (Balikkan logika). Tampilkan yang **TIDAK** cocok dengan pola.
  * `"^#"`: (Regex dasar) Baris yang diawali tanda pagar.
  * **Hasil:** Daftar mirror server yang bersih tanpa komentar.

#### C. Recursive Search (`-r` atau `-R`)

Mencari teks di dalam *seluruh folder* dan sub-folder. Sangat vital bagi programmer untuk mencari variabel di dalam *source code*.

```bash
grep -r "function main" ./my_project/
```

  * `-r`: Masuk ke setiap direktori di dalam `./my_project/` dan cari file di dalamnya.

#### D. Line Number (`-n`)

Menampilkan nomor baris tempat teks ditemukan. Penting untuk debugging coding.

```bash
grep -n "TODO" main.dart
```

  * **Output:** `45: // TODO: Fix memory leak here` (Artinya ada di baris 45).

#### E. Context Control (`-A`, `-B`, `-C`)

Seringkali, penyebab error tidak ada di baris "Error" itu sendiri, tapi di baris *sebelumnya*.

  * `-A num` (**A**fter): Tampilkan `num` baris *setelah* kecocokan.
  * `-B num` (**B**efore): Tampilkan `num` baris *sebelum* kecocokan.
  * `-C num` (**C**ontext): Tampilkan sebelum DAN sesudah.

**Contoh Real:** Melihat error boot kernel (dmesg) beserta konteksnya.

```bash
dmesg | grep -C 3 "fail"
```

(Menampilkan baris yang mengandung kata "fail", ditambah 3 baris di atasnya dan 3 baris di bawahnya untuk memahami konteks kejadian).

-----

### 4\. Hubungan dengan Modul Lain

Bagian ini (Grep dasar) adalah pintu gerbang menuju **Fase 2 (Regex)**.

  * Saat ini kita menggunakan `grep` dengan *string literal* (kata pasti) atau regex yang sangat sederhana (`^`).
  * Nanti, di Fase 2, kita akan mengganti *Pattern* sederhana tadi dengan logika PCRE yang kompleks untuk menangkap pola dinamis (seperti email atau IP address).

### 5\. Tips & Praktik Terbaik

1.  **Colorize:** Di `.bashrc` atau `.zshrc` anda, pastikan alias ini ada:
    `alias grep='grep --color=auto'`
    Ini membuat hasil pencarian berwarna merah terang, memudahkan mata memindai hasil.
2.  **Gunakan Single Quote (`'`):** Biasakan membungkus pola Anda dengan tanda kutip satu `'pola'`.
      * *Alasan:* Shell (Bash/Zsh) kadang menganggap karakter khusus regex (seperti `$`, `*`) sebagai variabel shell jika menggunakan kutip dua (`"`). Kutip satu menjaga pola tetap murni (*literal*) sebelum dikirim ke grep.

### 6\. Sumber Referensi

  * **GNU Grep Manual:** [GNU.org - Grep](https://www.gnu.org/software/grep/manual/grep.html)
  * **TLDR Pages (Grep):** [TLDR Grep](https://www.google.com/search?q=https://tldr.inbrowser.app/pages/common/grep)

-----

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
