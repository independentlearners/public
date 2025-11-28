Selamat datang di **PHASE 3: The Power of Pipes**.

Di fase-fase sebelumnya, kita belajar bagaimana **satu program** bekerja (logika internalnya). Sekarang, kita akan belajar bagaimana **menghubungkan** berbagai program agar bekerja sama.

Ini adalah "Ilmu Perpipaan" (Plumbing) digital. Di Linux, kekuatan sejati tidak terletak pada satu program raksasa yang melakukan segalanya, melainkan pada kemampuan Anda merangkai alat-alat kecil menjadi satu jalur produksi data yang efisien.

-----

# PHASE 3: The Power of Pipes

## MODUL 3.1: I/O Redirection, Streams, & Piping

-----

<details>
  <summary>📃 Daftar Isi</summary>

### 📑 Struktur Pembelajaran Internal (Mini Daftar Isi)

1.  **Filosofi Aliran Data:** Konsep "Sungai Data" di Linux.
2.  **The Three Holy Streams (File Descriptors):** Stdin (0), Stdout (1), Stderr (2).
3.  **Output Redirection:** Mengalihkan data dari layar ke file (`>` vs `>>`).
4.  **Input Redirection:** Memberi makan program dari file (`<`).
5.  **The Pipe (`|`):** Menyambung output satu program ke input program lain.
6.  **Advanced Redirection:** Menangani pesan error (`2>`, `2>&1`).
7.  **The Void:** Membuang sampah ke `/dev/null`.
8.  **Studi Kasus:** Sistem Log Otomatis (Memisahkan Error dan Sukses).

</details>

-----

### 1\. Deskripsi Konkret & Peran

Modul ini mengajarkan cara mengontrol ke mana data pergi dan dari mana data datang. Anda akan berhenti hanya melihat teks di layar terminal, dan mulai menyimpan hasil perintah ke file, membuang pesan error agar tidak mengganggu, dan merantai perintah.
**Peran:** Tanpa modul ini, Anda tidak bisa menyimpan log, tidak bisa memfilter data, dan script Anda akan sangat berisik. Ini adalah pondasi untuk Modul 3.2 (Text Processing).

### 2\. Konsep Kunci & Filosofi Mendalam

**Filosofi: "Text Streams" (Aliran Teks)**
Linux memperlakukan data seperti air yang mengalir melalui pipa. Program adalah "keran" atau "filter" di sepanjang pipa tersebut.

**Konsep: File Descriptors (FD)**
Sistem Operasi melacak koneksi data menggunakan angka yang disebut *File Descriptor*. Setiap kali Anda menjalankan program, Linux otomatis membuka 3 jalur (saluran):

1.  **0 - Stdin (Standard Input):** Pintu masuk data (Default: Keyboard).
2.  **1 - Stdout (Standard Output):** Pintu keluar data normal (Default: Layar Terminal).
3.  **2 - Stderr (Standard Error):** Pintu keluar khusus pesan kesalahan (Default: Layar Terminal).

*Penting:* Mengapa Error dipisah dari Output? Agar jika Anda menyimpan hasil program ke file, pesan error tidak ikut tercampur ke dalam file tersebut dan merusak format data.

*(Visualisasi: Bayangkan sebuah kotak mesin (Proses). Ada corong di kiri (0) untuk memasukkan bahan. Ada dua cerobong di kanan: cerobong utama (1) mengeluarkan produk jadi, dan cerobong kecil (2) membuang asap/limbah).*

-----

### 3\. Sintaks Dasar & Implementasi Inti

#### A. Output Redirection (`>` dan `>>`)

Mengubah tujuan **Stdout** dari layar ke file.

1.  **Overwrite (Timpa) - `>`**

      * Hati-hati\! Ini menghancurkan isi lama file.

    <!-- end list -->

    ```bash
    echo "Baris Pertama" > catatan.txt
    # Isi file sekarang: "Baris Pertama"

    echo "Baris Kedua" > catatan.txt
    # Isi file sekarang: "Baris Kedua" ("Baris Pertama" HILANG selamanya).
    ```

2.  **Append (Tambah) - `>>`**

      * Menambahkan di baris paling bawah tanpa menghapus isi lama.

    <!-- end list -->

    ```bash
    echo "Baris Ketiga" >> catatan.txt
    # Isi file sekarang: "Baris Kedua" lalu "Baris Ketiga".
    ```

#### B. Input Redirection (`<`)

Mengubah sumber **Stdin** dari keyboard menjadi file.
Jarang dipakai pemula karena banyak perintah bisa baca file langsung, tapi vital untuk perintah tertentu seperti `tr` atau database loader.

```bash
# Mengirim isi file 'nama.txt' ke perintah sort
sort < nama.txt
```

#### C. The Pipe (`|`)

Ini adalah "Lem Ajaib" Linux. Mengambil **Stdout** dari perintah kiri, dan menyambungkannya langsung ke **Stdin** dari perintah kanan.

```bash
ls -l | grep ".txt" | wc -l
```

**Alur Data:**

1.  `ls -l`: Daftar semua file (Output keluar lewat pipa, tidak ke layar).
2.  `grep ".txt"`: Menerima daftar file, menyaring hanya yang berakhiran `.txt`.
3.  `wc -l`: Menerima daftar file `.txt`, lalu menghitung jumlah barisnya (**W**ord **C**ount).
4.  Hasil akhir (angka) muncul di layar.

#### D. Menangani Error (`2>`)

Ingat, Pipe (`|`) dan Redirection biasa (`>`) hanya menangkap Stdout (Angka 1). Stderr (Angka 2) akan "bocor" ke layar kecuali ditangani khusus.

*Skenario:* Kita mencari file di seluruh sistem. Karena kita bukan root, akan banyak pesan "Permission denied".

```bash
# Cara Salah (Error tetap muncul mengotori layar)
find / -name "config" > hasil.txt

# Cara Benar (Membuang error ke file terpisah)
find / -name "config" > hasil.txt 2> error.log
```

  * `>`: Sama dengan `1>` (Stdout ke file).
  * `2>`: Stderr ke file lain.

#### E. Merge Output (`2>&1`)

Terkadang kita ingin Log Error dan Log Sukses masuk ke satu file yang sama secara berurutan.

```bash
# "Belokkan jalur 2 agar masuk ke jalur 1"
./script_saya.sh > semua_log.txt 2>&1
```

**Bedah Sintaks:**

  * `>` : Alihkan output ke file.
  * `2>&1` : "Hei jalur 2 (error), tolong arahkan outputmu ke alamat (`&`) yang sama dengan jalur 1 (output)."

#### F. The Black Hole (`/dev/null`)

`/dev/null` adalah file spesial di Linux. Apapun yang dikirim ke sana akan lenyap/dihapus seketika. Sangat berguna untuk membungkam script.

```bash
# Jalankan script, jangan tampilkan apapun (baik sukses maupun error)
./script_berisik.sh > /dev/null 2>&1
```

-----

### 4\. Studi Kasus: Sistem Logging Script

Kita akan membuat script yang mensimulasikan proses backup.

**File: `backup_simulator.sh`**

```bash
#!/bin/bash

LOGFILE="backup.log"

# Fungsi untuk log pesan dengan timestamp
log_message() {
    echo "[$(date +'%T')] $1"
}

# Mulai
log_message "Memulai proses backup..." >> "$LOGFILE"

# 1. Simulasi Sukses (Output biasa)
echo "Mengcopy data user..." >> "$LOGFILE"

# 2. Simulasi Error (Mencoba akses file terlarang)
# Kita alihkan error (2) ke Logfile juga
ls /root/rahasia 2>> "$LOGFILE"

# Penutup
log_message "Proses selesai." >> "$LOGFILE"

echo "Silakan cek file $LOGFILE untuk hasil."
```

**Analisis:**

  * Script ini "diam" saat dijalankan (tidak berisik di layar).
  * Semua jejak, termasuk error dari perintah `ls`, tersimpan rapi di `backup.log`.

-----

### 5\. Terminologi Esensial

1.  **File Descriptor (FD):** Angka indeks untuk aliran data (0, 1, 2).
2.  **Pipeline:** Rangkaian perintah yang dihubungkan dengan `|`.
3.  **Clobbering:** Istilah teknis untuk menimpa file secara tidak sengaja menggunakan `>`.
4.  **Device File:** File spesial di folder `/dev/` yang merepresentasikan perangkat (seperti `/dev/null` atau `/dev/sda`).

-----

### 6\. Hubungan dengan Modul Lain

  * **Prasyarat:** **Modul 1.1** (Perintah dasar seperti `ls`, `cat`).
  * **Koneksi ke Depan:** **Modul 3.2 (Text Processing)**. Pipe adalah cara kita mengirim teks ke "mesin pembedah" seperti `grep`, `sed`, dan `awk`. Tanpa pipe, tool-tool tersebut sulit digunakan secara efektif.

### 7\. Sumber Referensi Lengkap

  * **Dokumentasi Resmi:** [GNU Bash Manual - Redirections](https://www.gnu.org/software/bash/manual/html_node/Redirections.html)
  * **Visual Guide:** [DigitalOcean - Linux I/O Redirection](https://www.digitalocean.com/community/tutorials/an-introduction-to-linux-i-o-redirection)
  * **Deep Dive:** [Greg's Wiki - Redirection](https://mywiki.wooledge.org/BashGuide/InputAndOutput) (Penjelasan sangat mendalam tentang urutan evaluasi).

### 8\. Tips dan Praktik Terbaik

  * **Urutan itu Penting:** `> file 2>&1` **TIDAK SAMA** dengan `2>&1 > file`.
      * Benar: `> file 2>&1` (Arahkan output ke file, lalu arahkan error mengikuti output -\> ke file).
      * Salah: `2>&1 > file` (Arahkan error ke layar (ikut output default), lalu pindahkan output ke file. Hasilnya: Error tetap di layar, hanya output yang ke file).
  * **Jangan "Cat-Piping" (UUoC - Useless Use of Cat):**
      * Buruk: `cat file.txt | grep "pola"` (Buang-buang proses `cat`).
      * Baik: `grep "pola" file.txt` (Grep bisa baca file sendiri\!).

### 9\. Potensi Kesalahan Umum & Solusi

  * **Kesalahan:** Menggunakan `>` untuk membaca dan menulis file yang sama.
      * Perintah: `sort data.txt > data.txt`
      * **Bencana:** Shell akan **mengosongkan** `data.txt` *sebelum* perintah `sort` sempat membacanya. File Anda hilang jadi 0 byte.
      * **Solusi:** Gunakan file sementara: `sort data.txt > temp.txt && mv temp.txt data.txt`.

-----

Anda kini telah menguasai seni mengalirkan data. Pipa sudah terpasang. Namun, data yang mengalir masih mentah.

Bagaimana jika kita ingin **mengubah** data tersebut di tengah jalan? Misal: Mengubah semua "Jalan" menjadi "Jl.", atau mengambil kolom ke-3 dari sebuah laporan keuangan?

Di **Modul 3.2**, kita akan bertemu dengan **The Holy Trinity: Grep, Sed, dan Awk**. Ini adalah alat pemrosesan teks paling kuat di jagat Unix.

Kita memasuki **MODUL 3.2**. Ini adalah modul yang mengubah Anda dari "Pengguna Linux" menjadi "Penyihir Teks".

Di Modul 3.1, kita belajar cara mengalirkan data. Sekarang, kita akan belajar cara **membedah, memfilter, dan memformat ulang** data tersebut saat sedang mengalir.

Kita akan mempelajari **"The Holy Trinity"** (Tritunggal Suci) dalam pemrosesan teks Unix: **Grep, Sed, dan Awk**. Ditambah satu bahasa universal bernama **Regex**.

-----

## MODUL 3.2: The Holy Trinity (Grep, Sed, Awk) & Regex

### 📑 Struktur Pembelajaran Internal (Mini Daftar Isi)

1.  **Filosofi Teks:** Mengapa Linux lebih suka teks daripada database biner.
2.  **Regular Expressions (Regex):** Bahasa simbol untuk pencarian pola (Wildcards on Steroids).
3.  **Grep (The Filter):** Mencari jarum dalam tumpukan jerami.
4.  **Sed (The Editor):** Mengedit ribuan file dalam sekejap mata.
5.  **Awk (The Analyzer):** Mengolah data kolom dan membuat laporan.
6.  **Studi Kasus:** Menganalisis Log Server untuk melacak Hacker.

-----

### 1\. Deskripsi Konkret & Peran

Modul ini mengajarkan cara memanipulasi teks tanpa membuka file tersebut. Anda akan belajar mencari pola error spesifik dalam log 10GB, mengganti alamat IP di 50 file konfigurasi sekaligus, dan mengekstrak kolom data tertentu dari laporan CSV.
**Peran:** Ini adalah *skill* paling berharga bagi SysAdmin dan DevOps. Tanpa alat ini, analisis data manual akan memakan waktu berhari-hari. Dengan alat ini, hanya butuh hitungan detik.

### 2\. Konsep Kunci & Filosofi Mendalam

**Filosofi: "Stream Processing"**
Bayangkan ban berjalan di pabrik.

  * **Grep** adalah sensor yang membuang barang cacat (Filter baris).
  * **Sed** adalah robot lengan yang menempelkan label atau mengecat ulang barang (Modifikasi teks).
  * **Awk** adalah akuntan yang menghitung jumlah barang dan nilainya (Analisis data kolom).

Ketiganya bekerja berdasarkan **Baris per Baris** (*Line by Line*). Mereka membaca baris 1, proses, cetak, lupakan. Lalu baca baris 2. Ini membuat mereka sangat hemat memori (RAM), bahkan untuk memproses file berukuran Terabyte.

-----

### 3\. Fondasi Utama: Regular Expressions (Regex)

Sebelum menyentuh alatnya, kita harus paham "bahasanya". Regex adalah pola karakter untuk mencocokkan teks.

**Simbol Regex Paling Vital:**

1.  **Anchors (Jangkar):**
      * `^` (Topi): Awal baris. `^Error` (Cari baris yang **diawali** kata Error).
      * `$` (Dolar): Akhir baris. `OK$` (Cari baris yang **diakhiri** kata OK).
2.  **Wildcards:**
      * `.` (Titik): Tepat satu karakter apa saja. `b.k` cocok dengan `buk`, `bak`, `b@k`.
      * `*` (Bintang): Mengulang karakter sebelumnya 0 kali atau lebih. `ab*c` cocok dengan `ac`, `abc`, `abbbc`.
3.  **Character Sets:**
      * `[a-z]`: Huruf kecil apa saja.
      * `[0-9]`: Angka apa saja.

-----

### 4\. Implementasi Inti: The Trinity

#### A. Grep (Global Regular Expression Print)

**Fungsi:** Memfilter BARIS. "Tampilkan hanya baris yang mengandung kata X".

```bash
# Mencari kata "error" (case insensitive) di dalam file syslog
grep -i "error" /var/log/syslog
```

**Flags Penting:**

  * `-i`: **I**gnore case (Huruf besar/kecil dianggap sama).
  * `-v`: In**v**ert match (Tampilkan yang **TIDAK** cocok). Berguna untuk membuang komentar.
  * `-r`: **R**ecursive (Cari di dalam folder dan sub-folder).
  * `-E`: **E**xtended Regex (Mengaktifkan fitur regex canggih).

**Contoh Pipeline:**

```bash
# Tampilkan proses yang berjalan, tapi buang baris judul dan grep itu sendiri
ps aux | grep "python" | grep -v "grep"
```

#### B. Sed (Stream Editor)

**Fungsi:** Mencari dan Mengganti (Find and Replace).

**Sintaks Suci:** `s/OLD/NEW/g`

```bash
# Mengganti kata "http" menjadi "https" di layar (tidak mengubah file asli)
echo "Buka http://google.com" | sed 's/http/https/g'
```

**Penjelasan Kata per Kata:**

  * `s`: **S**ubstitute (Perintah ganti).
  * `/`: Delimiter (Pemisah).
  * `http`: Pola yang dicari.
  * `https`: Kata pengganti.
  * `g`: **G**lobal. Jika ada dua kata "http" dalam satu baris, ganti semuanya. Tanpa `g`, hanya yang pertama diganti.

**Bahaya: Edit in Place (`-i`)**
Secara default, Sed hanya menampilkan hasil ke layar. Untuk mengubah file asli secara permanen:

```bash
sed -i 's/localhost/127.0.0.1/g' config.txt
```

  * `-i`: **I**n-place edit. Hati-hati\! Tidak ada Undo.

#### C. Awk (The Data Analyst)

**Fungsi:** Mengolah KOLOM. Awk menganggap setiap baris adalah *Record* dan setiap kata adalah *Field* (Kolom).

Secara default, Awk memisahkan kolom berdasarkan **Spasi/Tab**.

**Variabel Awk:**

  * `$1`: Kolom ke-1.
  * `$2`: Kolom ke-2.
  * `$0`: Seluruh baris.
  * `NF`: **N**umber of **F**ields (Jumlah kolom di baris itu).
  * `NR`: **N**umber of **R**ecords (Nomor baris saat ini).

**Contoh Implementasi:**
Bayangkan output `ls -l` seperti ini:
`-rw-r--r--  1  budi  staff  500  Nov 20  data.txt`
(Kolom: 1=Izin, 3=User, 5=Size, 9=Nama)

```bash
# Saya hanya ingin nama file dan ukurannya
ls -l | awk '{print $9 " - " $5 " bytes"}'
```

**Output:**
`data.txt - 500 bytes`

-----

### 5\. Studi Kasus: Analisis Log Serangan (Gabungan Trinity)

Skenario: Kita punya log web server (`access.log`). Kita ingin mencari 3 Alamat IP teratas yang mencoba mengakses halaman admin ("admin.php") dan gagal (Error 404 atau 403).

**Format Log:**
`192.168.1.50 - - [21/Nov/2025] "GET /admin.php HTTP/1.1" 404 230`

**Script Pipeline:**

```bash
cat access.log | \
grep "admin.php" | \
grep -E " 404 | 403 " | \
awk '{print $1}' | \
sort | \
uniq -c | \
sort -nr | \
head -n 3
```

**Bedah Langkah demi Langkah:**

1.  `cat`: Baca file.
2.  `grep "admin.php"`: Ambil hanya baris yang mengakses halaman admin.
3.  `grep -E " 404 | 403 "`: Ambil baris yang kode statusnya 404 ATAU 403 (Gagal).
4.  `awk '{print $1}'`: Ambil kolom pertama saja (Alamat IP).
5.  `sort`: Urutkan IP agar yang sama berkumpul berdekatan (Syarat `uniq`).
6.  `uniq -c`: Hapus duplikat dan **c**ount (hitung) berapa kali IP itu muncul.
7.  `sort -nr`: Urutkan lagi berdasarkan hasil hitungan (`-n`) dari terbesar ke terkecil (`-r`everse).
8.  `head -n 3`: Ambil 3 baris paling atas (Juara 1, 2, 3).

**Hasil Output:**

```text
   50 192.168.1.10
   12 10.0.0.5
    5 172.16.0.1
```

*(Artinya: IP 192.168.1.10 menyerang 50 kali)*.

-----

### 6\. Terminologi Esensial

1.  **Delimiter:** Karakter pemisah antar kolom (default Awk adalah spasi, CSV menggunakan koma).
2.  **Pattern Space:** Area memori sementara tempat `sed` memproses satu baris teks.
3.  **Escape Character (`\`):** Digunakan untuk mematikan fungsi spesial simbol. Jika ingin mencari titik literal `.`, tulis `\.`.

-----

### 7\. Hubungan dengan Modul Lain

  * **Prasyarat:** **Modul 3.1 (Pipes)**. Tanpa pipe `|`, alat-alat ini tidak bisa disambungkan.
  * **Koneksi ke Depan:** **Fase 4 (Advanced Scripting)**. Kita akan menggunakan `awk` dan `grep` di dalam sub-shell `$(...)` untuk membuat variabel otomatis.

### 8\. Sumber Referensi Lengkap

  * **Latihan Interaktif:** [Regex101](https://regex101.com/) - Situs terbaik untuk menguji dan memahami Regex secara visual. (Pilih Flavor: PCRE atau Python, mirip dengan Linux).
  * **Dokumentasi:** [GNU Sed Manual](https://www.gnu.org/software/sed/manual/sed.html), [GNU Gawk Manual](https://www.gnu.org/software/gawk/manual/gawk.html).
  * **Tutorial:** [The Geek Stuff - Sed & Awk 101](https://www.thegeekstuff.com/2010/01/awk-introduction-tutorial-7-awk-print-examples/).

### 9\. Tips dan Praktik Terbaik

  * **Uji Dulu Sed Tanpa `-i`:** Jangan pernah menjalankan `sed -i` (edit permanen) sebelum Anda melihat outputnya di layar dan yakin 100% regex-nya benar.
  * **Gunakan Kutip Tunggal `'...'`:** Untuk `sed` dan `awk`, selalu gunakan kutip tunggal untuk membungkus perintahnya. Ini mencegah Bash mengacak-acak simbol `$` di dalamnya.
      * ❌ Salah: `awk "{print $1}"` (Bash akan mencoba menerjemahkan `$1` sebagai argumen script pertama).
      * ✅ Benar: `awk '{print $1}'` (Bash membiarkan `$1` agar dibaca oleh Awk).

### 10\. Potensi Kesalahan Umum & Solusi

  * **Kesalahan:** Grep tidak menemukan kata, padahal ada.
      * **Penyebab:** Masalah kapitalisasi (Error vs error).
      * **Solusi:** Gunakan `grep -i`.
  * **Kesalahan:** Sed mengganti terlalu banyak (Greedy Match).
      * **Solusi:** Pahami regex lebih dalam. Karakter `*` bersifat *greedy* (rakus).

-----

Anda baru saja menguasai alat bedah paling tajam di Linux. Dengan `grep`, `sed`, dan `awk`, tidak ada file teks yang tidak bisa Anda taklukkan.

Fase 3 selesai. Kita telah menguasai **Input/Output** dan **Manipulasi Teks**.

Sekarang, kita masuk ke **PHASE 4: Advanced Modular Scripting**. Kita akan belajar menulis script yang tidak hanya "sekadar jalan", tapi terstruktur rapi, bisa dipakai ulang, dan elegan.

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
