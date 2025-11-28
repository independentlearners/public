Ini adalah momen transisi terbesar dalam kurikulum ini. Di Fase 1, Anda adalah **Operator** (mengemudikan mobil secara manual). Di Fase 2, Anda menjadi **Engineer** (merakit autopilot agar mobil menyetir sendiri).

Kita tidak akan langsung melompat ke variabel yang rumit. Kita akan mulai dengan membedah "Jantung" dari sebuah script. Banyak tutorial hanya menyuruh Anda menyalin kode `#!/bin/bash` tanpa menjelaskan apa artinya. Di sini, kita akan membedahnya hingga ke level byte.

-----

# PHASE 2: Core Scripting – Dari Pengguna Menjadi Pemrogram

## MODUL 2.1: Anatomi Script, The Shebang, & Mekanisme Eksekusi

<details>
  <summary>📃 Daftar Isi</summary>

-----

### 📑 Struktur Pembelajaran Internal (Mini Daftar Isi)

1.  **Filosofi Otomasi:** Script sebagai "Rekaman Intelektual".
2.  **The Shebang (`#!`):** Baris paling penting yang mengatur segalanya.
3.  **Magic Bytes:** Bagaimana Kernel mengenali file script.
4.  **Portabilitas:** Perdebatan `/bin/bash` vs `/usr/bin/env bash`.
5.  **Mekanisme Eksekusi:** Mengapa harus pakai titik-garis miring (`./`)?
6.  **Study Kasus:** Membuat "Hello World" yang benar secara teknis.

</details>

### 1\. Deskripsi Konkret & Peran

Modul ini mengajarkan struktur fisik dari file Bash Script. Kita akan membuat file script pertama, memahami header wajibnya, dan mempelajari 3 cara berbeda untuk menjalankannya.
**Peran:** Tanpa memahami Shebang dan mekanisme eksekusi, script Anda mungkin berjalan di "penerjemah" yang salah (misalnya berjalan di `sh` bukannya `bash`) yang menyebabkan error sintaks misterius. Ini adalah pondasi stabilitas kode.

### 2\. Konsep Kunci & Filosofi Mendalam

**Filosofi: "Stored Intelligence" (Kecerdasan Tersimpan)**
Bash script pada dasarnya adalah daftar perintah yang Anda ketik di terminal, namun disimpan dalam file teks. Ketika dijalankan, komputer memutar ulang perintah-perintah tersebut secara berurutan (top-to-bottom). Ini memungkinkan Anda "menyimpan" logika penyelesaian masalah Anda untuk dipakai ulang di masa depan tanpa perlu mengingat langkah-langkahnya.

**Konsep: The Interpreter (Penerjemah)**
File teks tidak bisa melakukan apa-apa sendiri. Dia butuh program lain (Interpreter) untuk membacanya baris demi baris dan melaksanakannya. Di sini, Interpreter kita adalah `/bin/bash`.

-----

### 3\. Sintaks Dasar & Implementasi Inti

#### A. Script Pertama: Hello World

Mari kita gunakan editor (`nano` atau `vim`) yang sudah dipelajari di Fase 1.

1.  Buat file baru: `nano hello.sh`
2.  Ketik kode berikut persis seperti ini:

<!-- end list -->

```bash
#!/bin/bash

# Ini adalah komentar (tidak akan dijalankan)
echo "Hello World! Saya mulai belajar scripting."
```

3.  Simpan dan keluar (`Ctrl+O`, `Enter`, `Ctrl+X`).
4.  Beri izin eksekusi (Ingat Modul 1.4): `chmod +x hello.sh`
5.  Jalankan: `./hello.sh`

**Penjelasan Sintaks Kata per Kata:**

  * `#!/bin/bash`: Disebut **Shebang**. Ini memberi tahu Kernel Linux: "Tolong panggil program `/bin/bash` untuk menjalankan sisa isi file ini."
  * `#`: Tanda pagar (Hash) di awal baris (selain baris pertama) menandakan **Komentar**. Baris ini diabaikan oleh komputer. Gunakan untuk catatan manusia.
  * `echo`: Perintah untuk mencetak teks ke layar (Standard Output).
  * `"..."`: Tanda kutip ganda membungkus teks (String) agar spasi dianggap satu kesatuan.

-----

### 4\. Deep Dive: The Shebang (`#!`)

Ini adalah bagian yang sering dilewatkan tutorial biasa.

**Mengapa namanya Shebang?**
Gabungan dari **SH**arp (`#`) dan **BANG** (`!`).

**Bagaimana Kernel Bekerja?**
Saat Anda mencoba menjalankan file (misal `./hello.sh`), Kernel Linux membaca **2 byte pertama** dari file tersebut.

  * Jika 2 byte itu adalah kode heksadesimal `0x23 0x21` (yang merupakan karakter `#` dan `!`), Kernel tahu ini adalah script.
  * Kernel kemudian membaca sisa baris pertama (`/bin/bash`) untuk mencari alamat Interpreternya.
  * Kernel menjalankan perintah: `/bin/bash hello.sh`.

**Best Practice: Portabilitas**

  * **Cara Kaku:** `#!/bin/bash`
      * *Kelebihan:* Pasti aman di hampir semua sistem Linux standar.
      * *Kekurangan:* Di beberapa sistem Unix lama atau BSD (seperti macOS tertentu), Bash mungkin tidak diinstal di folder `/bin`, tapi di `/usr/local/bin`. Script akan error "Interpreter not found".
  * **Cara Fleksibel (Direkomendasikan):** `#!/usr/bin/env bash`
      * *Penjelasan:* Program `env` akan mencari di mana lokasi `bash` berada dalam sistem (mencari di `$PATH`), lalu menjalankannya. Ini membuat script Anda bisa berjalan di Linux, macOS, atau Unix lain tanpa perlu diedit.

-----

### 5\. Mekanisme Eksekusi: Misteri `./`

Mengapa kita harus mengetik `./hello.sh`? Kenapa tidak cukup `hello.sh` saja seperti perintah `ls`?

Ini berhubungan dengan **Variabel `$PATH`**.

  * Saat Anda mengetik perintah (misal `ls`), Shell mencari program bernama `ls` di dalam folder-folder yang terdaftar di `$PATH` (biasanya `/bin`, `/usr/bin`).
  * Demi keamanan, **folder saat ini (Current Directory)** biasanya **TIDAK** ada di dalam `$PATH`. Ini untuk mencegah hacker menaruh file jebakan bernama `ls` di folder Anda.
  * Oleh karena itu, Anda harus memberikan alamat eksplisit:
      * `./hello.sh` artinya: "Jalankan file `hello.sh` yang ada di **titik ini** (folder ini)."

**Tiga Cara Menjalankan Script:**

1.  **Execute Method (Standard):** `./hello.sh`

      * Syarat: File harus punya izin `x` (`chmod +x`).
      * Proses: Shell membuat proses baru (sub-shell) untuk menjalankan script. Variabel di dalam script tidak akan mengotori terminal Anda. **(Paling Aman)**.

2.  **Interpreter Method:** `bash hello.sh`

      * Syarat: File **TIDAK** butuh izin `x`. Cukup izin baca (`r`).
      * Proses: Kita memanggil program `bash` dan menyuruhnya membaca file teks `hello.sh`.
      * Kegunaan: Bagus untuk testing script yang belum siap dieksekusi atau debugging.

3.  **Source Method:** `source hello.sh` atau `. hello.sh`

      * Syarat: Tidak butuh izin `x`.
      * Proses: Perintah dijalankan **di dalam Shell Anda saat ini**, bukan di sub-shell baru.
      * **Bahaya:** Jika script berisi perintah `exit`, terminal Anda akan ikut tertutup/keluar\!
      * **Kegunaan:** Biasanya hanya untuk memuat variabel atau konfigurasi (seperti `.bashrc`).

*(Visualisasi Direkomendasikan: Diagram Pohon Proses. "Parent Shell" melahirkan "Child Shell" saat menggunakan `./`. Tapi saat menggunakan `source`, Parent Shell memakan script itu sendiri).*

-----

### 6\. Terminologi Esensial

1.  **Interpreter:** Program yang membaca kode sumber dan menjalankannya langsung (contoh: Bash, Python, Ruby). Berbeda dengan Compiler yang mengubah kode jadi biner dulu (C++, Go).
2.  **Magic Number:** Byte khusus di awal file yang menjadi identitas jenis file (Contoh: `#!` untuk script, `PK` untuk zip, `JFIF` untuk jpeg).
3.  **Comment (`#`):** Bagian kode yang ditujukan untuk dokumentasi manusia dan diabaikan mesin.
4.  **PATH:** Daftar alamat folder tempat sistem mencari program yang bisa dijalankan.

-----

### 7\. Hubungan dengan Modul Lain

  * **Prasyarat:** **Modul 1.4 (Permissions)**. Tanpa `chmod +x`, metode `./hello.sh` akan gagal dengan pesan "Permission denied".
  * **Koneksi ke Depan:** **Modul 2.2 (Variables)**. Setelah kita bisa menjalankan script, kita perlu membuatnya pintar dengan menyimpan data ke dalam variabel.

### 8\. Sumber Referensi Lengkap

  * **Dokumentasi Resmi:** [GNU Bash Reference - Invoking Bash](https://www.gnu.org/software/bash/manual/html_node/Invoking-Bash.html)
  * **Artikel Deep Dive:** [The shebang explainer](https://bash.cyberciti.biz/guide/Shebang)
  * **Standar:** [Google Shell Style Guide - File Extensions](https://google.github.io/styleguide/shellguide.html) (Tentang penamaan .sh).

### 9\. Tips dan Praktik Terbaik

  * **Selalu gunakan ekstensi `.sh`:** Meskipun Linux tidak mewajibkan ekstensi (karena ada Shebang), memberinya nama `.sh` memudahkan manusia dan editor teks mengenali bahwa itu adalah file script.
  * **Komentari kode Anda:** Biasakan menulis komentar `# Deskripsi` di atas blok kode yang rumit. Ingat: "Kode Anda hari ini adalah miliki Anda, tapi kode Anda bulan depan adalah milik orang asing (Anda yang lupa ingatan)."

### 10\. Potensi Kesalahan Umum & Solusi

  * **Kesalahan:** `bash: ./hello.sh: Permission denied`
      * **Penyebab:** Lupa `chmod +x hello.sh`.
      * **Solusi:** Berikan izin eksekusi.
  * **Kesalahan:** `bash: ./hello.sh: /bin/bash^M: bad interpreter`
      * **Penyebab:** Anda menulis script di **Windows** (Notepad) lalu memindahkannya ke Linux. Windows menggunakan penutup baris `CRLF` (`\r\n`), sedangkan Linux hanya `LF` (`\n`). Karakter `^M` adalah sisa sampah dari Windows.
      * **Solusi:** Gunakan tool `dos2unix hello.sh` untuk mengonversinya, atau atur editor Anda di Windows untuk menggunakan "Unix Line Endings".

-----

Kita telah berhasil melahirkan program pertama. Kerangka fisiknya sudah ada, tapi otaknya masih kosong.

Selanjutnya di **Modul 2.2**, kita akan mengisi otaknya dengan memori. Kita akan belajar **Variables (Variabel)**: Cara script mengingat nama user, tanggal, dan hasil perhitungan.

-----

Setelah kita berhasil membuat "tubuh" script (file dan izin eksekusi) di Modul 2.1, sekarang kita harus memberinya "ingatan". Tanpa variabel, script Anda akan amnesia—tidak bisa mengingat siapa penggunanya, jam berapa sekarang, atau file mana yang sedang diproses.

## MODUL 2.2: Variables (Variabel), Input, & Aritmatika Dasar

### 📑 Struktur Pembelajaran Internal (Mini Daftar Isi)

1.  **Filosofi Memori:** Konsep wadah data dan penamaan.
2.  **Aturan Emas Penugasan (Assignment):** Mengapa spasi adalah musuh.
3.  **Interpolasi & Quotes:** Perang antara Petik Satu (`'`) vs Petik Dua (`"`).
4.  **Command Substitution:** Menyimpan hasil perintah Linux ke dalam variabel.
5.  **Interaksi Pengguna:** Menerima input dengan `read`.
6.  **Variabel Spesial (Positional Arguments):** `$1`, `$2`, `$@`.
7.  **Aritmatika:** Melakukan matematika di dunia teks `$((...))`.
8.  **Studi Kasus:** Script Backup Sederhana dengan Timestamp.

-----

### 1\. Deskripsi Konkret & Peran

Modul ini mengajarkan cara menyimpan data dinamis. Anda akan belajar membuat label (variabel) untuk menyimpan teks, angka, atau hasil perintah sistem, lalu memanggilnya kembali nanti.
**Peran:** Variabel membuat script menjadi **Dinamis**. Script statis hanya bisa melakukan hal yang sama persis berulang kali (misal: `echo "Halo Budi"`). Script dinamis bisa beradaptasi (misal: `echo "Halo $NAMA"`), sehingga satu script bisa dipakai oleh Budi, Siti, atau siapapun.

### 2\. Konsep Kunci & Filosofi Mendalam

**Filosofi: "Bash is Loosely Typed" (Tipe Data Longgar)**
Dalam bahasa pemrograman ketat (seperti C atau Java), Anda harus mendeklarasikan: "Ini adalah Angka", "Ini adalah Teks". Di Bash, **semuanya adalah String (Teks)** secara default.

  * Jika Anda simpan `10`, Bash melihatnya sebagai teks "10".
  * Bash baru akan menganggapnya angka jika Anda memaksanya masuk ke dalam konteks matematika `$(( ))`.

**Filosofi: Expansion (Pengembangan)**
Saat Bash melihat simbol Dolar `$`, ia melakukan **Substitusi**. Sebelum perintah dijalankan, Bash akan mengganti `$NAMA_VARIABEL` dengan isi sebenarnya. Ini terjadi sangat awal dalam proses eksekusi.

-----

### 3\. Sintaks Dasar & Implementasi Inti

#### A. Membuat Variabel (Assignment)

Ini adalah bagian yang paling sering salah dilakukan pemula.

```bash
NAMA="Budi Santoso"
UMUR=25
PATH_FILE=/home/budi/data.txt
```

**Penjelasan Sintaks & Aturan Emas:**

1.  **Kapitalisasi:** Konvensi (kebiasaan) di Bash adalah menggunakan **HURUF\_BESAR** untuk variabel buatan sendiri, agar mudah dibedakan dengan perintah sistem.
2.  **DILARANG ADA SPASI:**
      * ❌ `NAMA = "Budi"` (Salah\! Bash akan mengira Anda menjalankan perintah bernama `NAMA` dengan argumen `=` dan `"Budi"`).
      * ✅ `NAMA="Budi"` (Benar).
3.  **Tanda Kutip:** Jika isi variabel mengandung spasi (seperti "Budi Santoso"), Anda **wajib** membungkusnya dengan kutip.

#### B. Memanggil Variabel (Interpolation)

Untuk mengambil isinya, gunakan `$`.

```bash
echo "Halo, nama saya $NAMA dan umur saya $UMUR tahun."
```

**Best Practice: Curly Braces `${}`**
Bagaimana jika Anda ingin menempelkan teks langsung setelah variabel?

  * Salah: `echo "File backup adalah $NAMA_file"` (Bash mencari variabel bernama `NAMA_file`, yang tidak ada).
  * Benar: `echo "File backup adalah ${NAMA}_file"` (Bash tahu batas nama variabelnya adalah `NAMA`, lalu menempelkan `_file`).

#### C. The Quote War: `'` vs `"`

Ini konsep vital di Bash.

1.  **Single Quotes (`'` - Strong Quote):** "Apa yang Anda lihat adalah apa yang Anda dapat". Bash **tidak** akan menerjemahkan simbol `$` di dalamnya.
      * `echo 'Saya adalah $NAMA'` -\> Output: `Saya adalah $NAMA` (Literal).
2.  **Double Quotes (`"` - Weak Quote):** Bash akan menerjemahkan variabel di dalamnya.
      * `echo "Saya adalah $NAMA"` -\> Output: `Saya adalah Budi Santoso`.

#### D. Command Substitution: `$(...)`

Menyimpan *output* dari perintah Linux ke dalam variabel.

```bash
TANGGAL_SEKARANG=$(date +%Y-%m-%d)
USER_AKTIF=$(whoami)

echo "Laporan dibuat oleh $USER_AKTIF pada tanggal $TANGGAL_SEKARANG"
```

**Penjelasan Sintaks:**

  * `$(`: Buka substitusi.
  * `date +%Y-%m-%d`: Perintah Linux biasa untuk cek tanggal.
  * `)`: Tutup substitusi.
  * Bash akan menjalankan perintah di dalam kurung, mengambil output teksnya, dan memasukkannya ke variabel.

#### E. User Input: `read`

Meminta pengguna mengetik sesuatu saat script berjalan.

```bash
read -p "Masukkan nama folder proyek: " FOLDER_PROYEK
mkdir "$FOLDER_PROYEK"
```
Jika menggunakan zsh, jalankan kode ini dengan tanpa menyertakan `.` seperti `. ~/script.sh`.
  * `read`: Perintah baca input keyboard.
  * `-p`: **P**rompt. Menampilkan pesan teks sebelum menunggu ketikan.
  * `FOLDER_PROYEK`: Nama variabel penampung input.

#### F. Aritmatika: `$((...))`

Ingat, Bash menganggap angka sebagai teks. Untuk menghitung, gunakan kurung ganda.

```bash
ANGKA_1=10
ANGKA_2=5

HASIL=$((ANGKA_1 + ANGKA_2))
echo "Hasil penjumlahan: $HASIL"
```

  * Di dalam `$((...))`, Anda tidak perlu menggunakan `$` di depan nama variabel (opsional, tapi lebih bersih tanpa `$`).
  * **Catatan:** Bash murni hanya bisa menghitung **Bilangan Bulat (Integer)**. Tidak bisa desimal (koma).

-----

### 4\. Variabel Spesial (Positional Arguments)

Saat Anda menjalankan script dengan argumen: `./script.sh satu dua tiga`

1.  **`$0`**: Nama script itu sendiri (`./script.sh`).
2.  **`$1`**: Argumen pertama (`satu`).
3.  **`$2`**: Argumen kedua (`dua`).
4.  **`$#`**: Jumlah total argumen (Output: `3`).
5.  **`$@`**: Semua argumen sebagai daftar (`satu dua tiga`).

**Contoh Implementasi (File: sapa.sh):**

```bash
#!/bin/bash
echo "Halo $1, selamat datang di $2!"
```

*Jalankan:* `./sapa.sh Budi Jakarta`
*Output:* "Halo Budi, selamat datang di Jakarta\!"

-----

### 5\. Terminologi Esensial

1.  **Variable Expansion:** Proses Shell mengganti `$VAR` dengan nilainya.
2.  **Hard Coding:** Menulis nilai langsung di kode (misal `nama="Budi"`). Kebalikan dari dinamis.
3.  **Concatenation:** Menggabungkan dua string menjadi satu (misal `$DEPAN$BELAKANG`).
4.  **Integer:** Bilangan bulat.
5.  **Scope:** Jangkauan variabel. Secara default variabel Bash bersifat global dalam script tersebut, tapi tidak terbawa ke script lain kecuali di-`export`.

-----

### 6\. Hubungan dengan Modul Lain

  * **Prasyarat:** Modul 2.1 (Struktur script).
  * **Koneksi ke Depan:** **Modul 2.3 (Logic & Conditionals)**. Kita akan menggunakan variabel untuk mengambil keputusan. Contoh: `if [ "$UMUR" -gt 17 ]; then ...`
  * **Koneksi ke Depan:** **Fase 3 (Pipes)**. Command substitution `$(...)` adalah bentuk lain dari pemipaan data.

### 7\. Sumber Referensi Lengkap

  * **Dokumentasi Resmi:** [Bash Manual - Shell Parameters](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameters.html)
  * **Tutorial Visual:** [Bash Hackers Wiki - Quotes](https://www.google.com/search?q=https://wiki.bash-hackers.org/syntax/quoting) (Penjelasan mendalam tentang perbedaan quotes).
  * **Artikel:** [Baeldung - Bash Math](https://www.google.com/search?q=https://www.baeldung.com/linux/bash-math) (Cara menghitung di Bash).

### 8\. Tips dan Praktik Terbaik

  * **Selalu Quote Variabel Anda:** Saat menggunakan variabel dalam perintah, bungkus dengan kutip dua.
      * ❌ `rm $FILE` (Jika `FILE="Data Penting.txt"`, perintah ini akan menghapus `Data` lalu menghapus `Penting.txt`).
      * ✅ `rm "$FILE"` (Aman, dianggap satu file bernama "Data Penting.txt").
  * **Gunakan Nama Deskriptif:** Jangan pakai `x` atau `a`. Gunakan `dir_tujuan`, `nama_user`, `max_retry`.

### 9\. Potensi Kesalahan Umum & Solusi

  * **Kesalahan:** `JUMLAH = 5` (Spasi di sekitar sama dengan).
      * **Error:** `JUMLAH: command not found`.
      * **Solusi:** Hapus spasi: `JUMLAH=5`.
  * **Kesalahan:** Lupa tanda `$` saat memanggil.
      * `echo NAMA` -\> Outputnya teks "NAMA".
      * `echo $NAMA` -\> Outputnya isi variabel.
  * **Kesalahan:** Mencoba matematika desimal. `echo $(( 10 / 3 ))`.
      * **Hasil:** `3` (Dibulatkan ke bawah). Bash tidak paham 3.33.
      * **Solusi:** Gunakan tool eksternal `bc` atau `awk` untuk matematika desimal (Akan dibahas di Fase Lanjut).

-----

Dengan menguasai variabel, Anda sekarang memiliki "memori". Tapi script Anda masih berjalan lurus dari atas ke bawah tanpa berpikir.

Di **Modul 2.3**, kita akan memberikan "Otak" pada script Anda. Kita akan belajar **Logic & Conditionals (If/Else)**. Script Anda akan bisa berkata: *"Jika file ini ada, hapus. Jika tidak ada, buat baru."*

Kita memasuki **MODUL 2.3**. Ini adalah modul di mana script Anda mulai "hidup".

Jika **Variabel (Modul 2.2)** adalah **Memori** (ingatan), maka **Logic & Control Flow (Modul 2.3)** adalah **Kecerdasan** (kemampuan mengambil keputusan). Tanpa modul ini, script Anda hanya robot bodoh yang menjalankan perintah urut dari baris 1 sampai 100 tanpa peduli apakah terjadi error di tengah jalan.

-----

## MODUL 2.3: Logika, Kondisional, & Pengambilan Keputusan

### 📑 Struktur Pembelajaran Internal (Mini Daftar Isi)

1.  **Filosofi Kebenaran:** Mengapa di Linux, Angka 0 berarti "Benar" (Sukses).
2.  **The Exit Code (`$?`):** Cara sistem memberitahu sukses atau gagal.
3.  **Operator Uji (`test`):** Membedakan `[ ... ]` klasik vs `[[ ... ]]` modern.
4.  **Operator File & String:** Mengecek apakah file ada, atau apakah variabel kosong.
5.  **Struktur `if-then-else`:** Percabangan logika dasar.
6.  **Logika Boolean:** `&&` (AND) dan `||` (OR).
7.  **Studi Kasus:** Script Installer yang mengecek apakah Anda User Root.

-----

### 1\. Deskripsi Konkret & Peran

Modul ini mengajarkan cara membuat script yang bisa beradaptasi dengan situasi. Anda akan menulis kode yang bisa berkata: *"Jika file konfigurasi tidak ada, buatkan yang baru. Tapi jika sudah ada, backup dulu lalu update."*
**Peran:** Ini adalah tulang punggung otomatisasi yang aman. Script yang baik bukan script yang hanya berjalan saat kondisi sempurna, tapi script yang bisa menangani kesalahan (*error handling*) dengan anggun.

### 2\. Konsep Kunci & Filosofi Mendalam

**Filosofi: "No News is Good News" (Unix Philosophy)**
Dalam budaya Unix/Linux, jika sebuah program berjalan sukses, dia biasanya diam (tidak menampilkan output apa-apa). Jika dia menampilkan error, berarti ada masalah.

**Konsep: The Inverted Boolean (Terbalik\!)**
Ini sering mengejutkan programmer bahasa lain (C, Java, Python):

  * **Exit Code 0** = **Success / True**. (Hanya ada satu cara untuk sukses).
  * **Exit Code 1-255** = **Error / False**. (Ada banyak cara untuk gagal: file tidak ketemu, izin ditolak, disk penuh, dll).

[Image of Bash If Else Flowchart]

-----

### 3\. Sintaks Dasar & Implementasi Inti

#### A. The Exit Status (`$?`)

Setiap kali perintah selesai berjalan, dia meninggalkan "jejak" berupa angka status.

```bash
ls /home/budi
echo $? 
# Jika folder ada, output: 0
# Jika folder tidak ada, output: 2 (atau angka non-nol lain)
```

  * `echo $?`: Perintah wajib hafal untuk debugging. Ini mencetak status perintah **terakhir** yang dijalankan.

#### B. The Test Syntax: `[ ]` vs `[[ ]]`

Untuk melakukan pengecekan (apakah A = B?), kita butuh perintah `test`.

1.  **Single Bracket `[ ... ]`**: Standar POSIX lama. Kaku dan sedikit berbahaya jika tidak hati-hati dengan spasi/quote.
2.  **Double Bracket `[[ ... ]]`** (Rekomendasi): Fitur spesifik Bash. Lebih canggih, aman, dan mendukung Regex.

**Aturan Emas Spasi:**
Bash sangat sensitif dengan spasi.

  * ❌ SALAH: `if [$NAMA="Budi"];` (Dianggap satu perintah aneh).
  * ✅ BENAR: `if [ "$NAMA" = "Budi" ];` (Spasi setelah `[`, sebelum `]`, dan di sekitar `=`).

#### C. Operator Pengecekan (Hafalkan yang Penting Saja)

**Untuk File:**

  * `-e file`: True jika file/folder **E**xist (ada).
  * `-f file`: True jika itu **F**ile biasa (bukan folder).
  * `-d file`: True jika itu **D**irectory (folder).
  * `-x file`: True jika file e**X**ecutable (bisa dijalankan).

**Untuk String (Teks):**

  * `-z "$VAR"`: True jika string **Zero** length (Kosong). Sering dipakai untuk cek input user.
  * `-n "$VAR"`: True jika string **Non-zero** (Ada isinya).
  * `"$A" = "$B"`: True jika sama persis.
  * `"$A" != "$B"`: True jika beda.

**Untuk Angka (Integer Only):**
Jangan pakai `=` atau `>` untuk angka di dalam `[ ]`\! Gunakan:

  * `-eq`: **Eq**ual (Sama dengan).
  * `-ne`: **N**ot **E**qual (Tidak sama).
  * `-gt`: **G**reater **T**han (Lebih besar \>).
  * `-lt`: **L**ess **T**han (Lebih kecil \<).
  * `-ge`: Greater or Equal (\>=).
  * `-le`: Less or Equal (\<=).

#### D. Struktur IF-THEN-ELSE

Kerangka pengambilan keputusan.

```bash
#!/bin/bash

UMUR=15

if [[ "$UMUR" -ge 17 ]]; then
    echo "Silakan masuk, Anda sudah dewasa."
elif [[ "$UMUR" -ge 12 ]]; then
    echo "Boleh masuk tapi harus didampingi orang tua."
else
    echo "Maaf, belum cukup umur."
fi
```

  * `if`: Memulai blok logika.
  * `; then`: Pemisah antara syarat dan tindakan (Wajib ada jika sebaris).
  * `elif`: Singkatan dari "Else If" (Kondisi alternatif).
  * `else`: Pilihan terakhir jika semua kondisi di atas gagal.
  * `fi`: Kebalikan dari `if`. Penutup blok logika.

#### E. Logika AND (`&&`) dan OR (`||`)

Menggabungkan dua kondisi.

```bash
# Cek apakah user bernama "admin" DAN file "rahasia.txt" ada
if [[ "$USER" = "admin" && -f "rahasia.txt" ]]; then
    cat rahasia.txt
fi
```

**Shortcut One-Liner (Sering dipakai pro):**

```bash
# [Kondisi] && [Jalan jika sukses] || [Jalan jika gagal]
mkdir data_baru && echo "Folder dibuat" || echo "Gagal buat folder"
```

Ini cara cepat menulis if-else sederhana.

-----

### 4\. Studi Kasus: Script Installer (Root Checker)

Mari kita buat script nyata. Banyak script instalasi (seperti install web server) mewajibkan Anda menjalankannya sebagai administrator (`root`). Kita akan memvalidasi ini.

**File: `install_app.sh`**

```bash
#!/bin/bash

# Cek apakah user saat ini adalah root (UID 0)
if [[ $EUID -ne 0 ]]; then
   echo "ERROR: Script ini harus dijalankan sebagai root!"
   echo "Gunakan: sudo ./install_app.sh"
   exit 1  # Keluar script dengan kode error 1
fi

# Jika lolos (artinya user adalah root), script lanjut ke sini
echo "Memulai instalasi..."
# mkdir /opt/aplikasi (hanya root yang bisa lakukan ini)
echo "Instalasi Selesai."
exit 0 # Keluar dengan sukses
```

**Penjelasan:**

1.  `$EUID`: Variabel sistem yang menyimpan ID user efektif. Root selalu punya ID 0.
2.  `-ne 0`: Not Equal 0 (Jika bukan 0, berarti bukan root).
3.  `exit 1`: Menghentikan script seketika dan memberitahu sistem bahwa terjadi kesalahan.

-----

### 5\. Terminologi Esensial

1.  **Exit Code:** Angka 0-255 yang dikembalikan program saat selesai. 0=Sukses.
2.  **Short-Circuit Evaluation:**
      * `A && B`: Jika A gagal, B tidak akan dijalankan (karena hasilnya pasti gagal).
      * `A || B`: Jika A sukses, B tidak akan dijalankan (karena hasilnya sudah pasti sukses).
3.  **Conditional Expression:** Pernyataan yang bernilai True atau False.
4.  **Nested If:** `if` di dalam `if` (If bersarang).

-----

### 6\. Hubungan dengan Modul Lain

  * **Prasyarat:** **Modul 2.2 (Variabel)**. Kita mengevaluasi isi variabel di dalam `if`.
  * **Koneksi ke Depan:** **Modul 2.4 (Loops)**. Kita akan menggunakan logika ini untuk menghentikan perulangan (misal: Loop terus sampai file ditemukan).

### 7\. Sumber Referensi Lengkap

  * **Dokumentasi Resmi:** [GNU Bash Manual - Conditional Constructs](https://www.gnu.org/software/bash/manual/html_node/Conditional-Constructs.html)
  * **Panduan Mendalam:** [MyWikiWoo - Bash Guide Tests](https://mywiki.wooledge.org/BashGuide/TestsAndConditionals) (Sumber paling dihormati komunitas Bash).
  * **Daftar Operator File:** [Man page for test](https://linux.die.net/man/1/test).

### 8\. Tips dan Praktik Terbaik

  * **Selalu gunakan `[[ ]]`:** Kecuali Anda menulis script untuk sistem Unix super kuno (tahun 90-an), selalu gunakan double brackets. Ini mencegah banyak bug aneh terkait spasi kosong pada variabel.
  * **Quote Variabel Anda:** `if [ -z "$INPUT" ]`. Jika input kosong dan Anda lupa tanda kutip (`if [ -z $INPUT ]`), Bash akan melihat `if [ -z ]` yang merupakan error sintaks.
  * **Indentasi:** Selalu menjorokkan kode di dalam `if` (gunakan Tab atau Spasi). Ini wajib agar kode bisa dibaca manusia.

### 9\. Potensi Kesalahan Umum & Solusi

  * **Kesalahan:** `if [ $A > $B ]` (Menggunakan `>` untuk angka).
      * **Bahaya:** Simbol `>` di Bash berarti **Redirection** (tulis ke file). Perintah ini malah akan membuat file kosong bernama `$B`.
      * **Solusi:** Gunakan `-gt` untuk angka (`[ $A -gt $B ]`) atau gunakan double parenthesis untuk aritmatika murni `(( $A > $B ))`.
  * **Kesalahan:** Lupa spasi `if ["$A"="$B"]`.
      * **Error:** `command not found`.
      * **Solusi:** Beri napas\! `if [ "$A" = "$B" ]`.

-----

Script Anda sekarang sudah punya otak. Dia bisa menolak dijalankan jika syarat tidak terpenuhi.

Tapi bagaimana jika kita perlu melakukan tugas yang sama untuk 1.000 file? Menulis `if` sebanyak 1.000 kali tentu tidak masuk akal.

Di **Modul 2.4**, kita akan memberikan "Stamina Tanpa Batas" pada script Anda. Kita akan belajar **Loops (Perulangan): For, While, dan Until**. Kita akan memproses ribuan data dalam hitungan detik.

Kita memasuki **MODUL 2.4**. Ini adalah modul di mana kita melepaskan potensi sebenarnya dari komputer: **Stamina Tanpa Batas**.

Jika **Logic (Modul 2.3)** membuat script Anda pintar mengambil keputusan sekali, maka **Loops (Modul 2.4)** membuat script Anda bisa melakukan keputusan itu jutaan kali tanpa lelah.

-----

## MODUL 2.4: Loops (Perulangan) & Iterasi Otomatis

### 📑 Struktur Pembelajaran Internal (Mini Daftar Isi)

1.  **Filosofi Perulangan:** Mengapa manusia membenci repetisi, tapi mesin menyukainya.
2.  **The `for` Loop:** Iterasi daftar item (gaya Python & gaya C).
3.  **The `while` Loop:** Berlari selama lampu masih hijau.
4.  **The `until` Loop:** Berlari sampai lampu menjadi hijau (Kebalikan `while`).
5.  **Loop Control:** Menghentikan paksa (`break`) dan melompati antrian (`continue`).
6.  **Range & Sequences:** Trik `{1..100}`.
7.  **Studi Kasus:** Mass Renaming (Mengganti ekstensi 1000 file sekaligus).

-----

### 1\. Deskripsi Konkret & Peran

Modul ini mengajarkan cara memproses tumpukan data. Anda akan belajar menulis perintah sekali, lalu menyuruh komputer mengulanginya untuk setiap file dalam folder, setiap baris dalam file teks, atau setiap server dalam jaringan.
**Peran:** Ini adalah inti dari "Batch Processing". SysAdmin tidak membackup server satu per satu; mereka menulis loop untuk membackup 50 server sekaligus. Tanpa loop, otomasi skala besar mustahil dilakukan.

### 2\. Konsep Kunci & Filosofi Mendalam

**Filosofi: "Iterate over Lists, not Parsing Output"**
Di Bash, loop paling aman bekerja dengan **daftar objek** (seperti hasil *globbing* `*.txt`), bukan dengan membedah output teks mentah dari perintah lain (seperti output `ls`).

**Konsep: The Block (`do ... done`)**
Semua loop di Bash dimulai dengan kata kunci pembuka (seperti `for`, `while`) dan diikuti oleh blok eksekusi yang diapit oleh kata **`do`** (lakukan) dan **`done`** (selesai). Semua kode di antara `do` dan `done` akan diulang-ulang.

[Image of For Loop Flowchart]

-----

### 3\. Sintaks Dasar & Implementasi Inti

#### A. The `for` Loop (Gaya Daftar/List)

Ini adalah bentuk paling umum. "Untuk setiap ITEM di dalam DAFTAR, lakukan sesuatu."

```bash
# Contoh 1: Loop manual
for NAMA in Budi Siti Agus; do
    echo "Halo, $NAMA!"
done

# Contoh 2: Loop File (Globbing) - Sangat Powerful!
for FILE in *.jpg; do
    echo "Ditemukan gambar: $FILE"
done
```

**Penjelasan Sintaks:**

  * `for NAMA`: `NAMA` adalah **Variabel Iterator**. Di putaran pertama, isinya "Budi". Di putaran kedua, isinya "Siti".
  * `in ...`: Mendefinisikan daftar yang akan diproses.
  * `*.jpg`: Bash akan mengembangkan ini menjadi daftar file (`foto1.jpg foto2.jpg ...`) *sebelum* loop berjalan.

#### B. The `for` Loop (Gaya C / Angka)

Mirip bahasa C/Java/Javascript. Digunakan jika Anda butuh penghitung angka.

```bash
# Format: (( inisialisasi; kondisi; step ))
for (( i=1; i<=5; i++ )); do
    echo "Hitungan ke: $i"
done
```

#### C. The `while` Loop (Kondisional)

"Selama kondisi BENAR, teruslah bekerja." Hati-hati dengan **Infinite Loop** (Loop tak terbatas) jika kondisi selamanya benar.

```bash
COUNTER=1

while [ $COUNTER -le 5 ]; do
    echo "Loop While ke-$COUNTER"
    ((COUNTER++)) # Naikkan nilai counter agar loop bisa berhenti
done
```

**Penggunaan Umum: Membaca File Baris per Baris**

```bash
# Membaca file 'daftar_nama.txt' baris demi baris
while read -r BARIS; do
    echo "Memproses: $BARIS"
done < daftar_nama.txt
```

*Teknik Input Redirection (`<`) di akhir loop `done` adalah cara efisien membaca file.*

#### D. The `until` Loop (Kebalikan While)

"Teruslah bekerja SAMPAI kondisi menjadi BENAR." (Atau: Selama kondisi SALAH, teruslah bekerja).

```bash
COUNT=1
until [ $COUNT -gt 5 ]; do
    echo "Menunggu sampai lebih besar dari 5. Sekarang: $COUNT"
    ((COUNT++))
done
```

*Berguna untuk:* Menunggu service menyala (misal: "Loop terus sampai Database konek").

-----

### 4\. Loop Control: `break` & `continue`

Kadang kita perlu mengintervensi jalannya loop.

1.  **`break`**: "Stop sekarang juga\! Keluar dari loop."
      * *Contoh:* Mencari file. Jika ketemu, berhenti mencari (tidak perlu cek sisa folder).
2.  **`continue`**: "Skip putaran ini, langsung lanjut ke putaran berikutnya."
      * *Contoh:* Memproses data, tapi lewati jika datanya korup/kosong.

**Contoh Implementasi:**

```bash
for ANGKA in {1..10}; do
    if [ $ANGKA -eq 3 ]; then
        continue  # Lewati angka 3
    fi
    
    if [ $ANGKA -eq 6 ]; then
        break     # Berhenti total di angka 6
    fi
    
    echo "Angka: $ANGKA"
done
# Output: 1, 2, 4, 5 (3 diewati, stop sebelum 6)
```

-----

### 5\. Studi Kasus: Mass Renaming (Prefixer)

Kita ingin menambahkan awalan `backup_` ke semua file `.txt`.

**File: `tambah_prefix.sh`**

```bash
#!/bin/bash

# Loop semua file berakhiran .txt
for FILE in *.txt; do
    # Cek keamanan: Pastikan file benar-benar ada (jika folder kosong, *.txt tetap tercetak sebagai string literal di beberapa shell lama)
    [ -e "$FILE" ] || continue

    BARU="backup_$FILE"
    
    echo "Mengubah nama $FILE menjadi $BARU..."
    mv "$FILE" "$BARU"
done

echo "Selesai!"
```

**Analisis:**

1.  `for FILE in *.txt`: Mengambil semua file teks.
2.  `mv "$FILE" "$BARU"`: Melakukan rename. Tanda kutip penting untuk menangani nama file berspasi.

-----

### 6\. Terminologi Esensial

1.  **Iteration (Iterasi):** Satu putaran lengkap dalam sebuah loop.
2.  **Infinite Loop:** Loop yang tidak pernah berhenti karena kondisinya selalu True. (Tekan `Ctrl+C` untuk membunuh script yang terjebak ini).
3.  **Globbing:** Fitur shell yang mengembangkan wildcard (`*`) menjadi daftar file.
4.  **Iterator Variable:** Variabel sementara (misal `i` atau `FILE`) yang menyimpan nilai item saat ini dalam antrian loop.

-----

### 7\. Hubungan dengan Modul Lain

  * **Prasyarat:** **Modul 2.2 (Variabel)** dan **Modul 2.3 (Logic)**. Loop menggabungkan keduanya.
  * **Koneksi ke Depan:** **Modul 3.2 (Text Processing)**. Nanti kita akan menggunakan loop untuk memberi makan data ke `sed` atau `awk` untuk pemrosesan teks tingkat tinggi.

### 8\. Sumber Referensi Lengkap

  * **Dokumentasi Resmi:** [Bash Manual - Looping Constructs](https://www.gnu.org/software/bash/manual/html_node/Looping-Constructs.html)
  * **Tutorial Visual:** [Ryan's Tutorials - Bash Loops](https://ryanstutorials.net/bash-scripting-tutorial/bash-loops.php)
  * **Artikel Deep Dive:** [Greg's Wiki - Wooledge Loop](https://www.google.com/search?q=https://mywiki.wooledge.org/BashGuide/TestsAndConditionals%23Loops) (Membahas mengapa parsing `ls` itu buruk).

### 9\. Tips dan Praktik Terbaik

  * **JANGAN me-loop output `ls`:**
      * ❌ `for f in $(ls *.txt)` -\> **SALAH BESAR\!** Jika nama file ada spasi ("data saya.txt"), `ls` akan memecahnya jadi dua item: "data" dan "saya.txt". Script akan error.
      * ✅ `for f in *.txt` -\> **BENAR.** Bash globbing menangani spasi dengan aman.
  * **Gunakan `{start..end}`:** Untuk loop angka sederhana, gunakan *brace expansion*.
      * `for i in {1..10}` jauh lebih bersih daripada `seq 1 10`.

### 10\. Potensi Kesalahan Umum & Solusi

  * **Kesalahan:** Lupa menutup dengan `done`.
      * **Error:** `syntax error: unexpected end of file`.
      * **Solusi:** Cek pasangan `do` dan `done`.
  * **Kesalahan:** Loop tak berhenti (Infinite loop) di `while`.
      * **Penyebab:** Lupa menaikkan counter (`((i++))`) atau kondisi logika salah.
      * **Solusi:** Pastikan logika di dalam loop mengubah variabel yang dicek di syarat loop.

-----

Dengan selesainya **Modul 2.4**, kita telah memiliki semua blok bangunan dasar pemrograman prosedural:

1.  Variabel (Memori)
2.  Kondisional (Otak)
3.  Loops (Otot)

Penjelasan sebelumnya masih terlalu fokus pada fitur spesifik Bash (*Bashisms*) dan kurang menekankan pada **Portabilitas Script** (kemampuan script berjalan di semua jenis Unix/Linux, termasuk Alpine Linux yang sering dipakai di Docker, macOS, atau BSD).

Ini adalah materi tingkat lanjut yang membedakan *scripter* biasa dengan *System Engineer* yang paham standar industri.

Mari kita sisipkan materi ini sebagai **MODUL 2.5 (Spesial)**, tepat setelah kita belajar Looping dan sebelum masuk ke Fase Pipes.

-----

## MODUL 2.5: Standar POSIX, Portabilitas, & Bahaya "Bashisms"

### 📑 Struktur Pembelajaran Internal

1.  **Definisi POSIX:** Apa itu dan mengapa menjadi "Hukum Tertinggi" di dunia Unix.
2.  **Bash vs Sh:** Perbedaan antara Shell modern dan Shell standar.
3.  **Implikasi Nyata:** Studi kasus Docker (Alpine Linux) dan Sistem Embedded.
4.  **Anatomi "Bashism":** Fitur-fitur enak di Bash yang dilarang di POSIX.
5.  **Substitusi Sintaks:** Cara menulis ulang kode Bash menjadi kode POSIX-compliant.
6.  **Studi Kasus:** Mengaudit script yang rusak saat dijalankan di server minimalis.

-----

### 1\. Deskripsi Konkret & Peran

Modul ini mengajarkan Anda cara menulis script yang "Universal". Script Bash biasa mungkin berjalan lancar di Ubuntu Anda, tapi **gagal total** saat dijalankan di dalam container Docker ringan (seperti Alpine) atau di server perbankan tua (Solaris/AIX).
**Peran:** Memahami POSIX melindungi Anda dari error "Syntax Error" yang memalukan saat script Anda dipindahkan ke lingkungan yang berbeda. Ini adalah standar disiplin tertinggi dalam penulisan shell script.

### 2\. Konsep Kunci & Filosofi Mendalam

**Apa itu POSIX?**
**POSIX** (Portable Operating System Interface) bukanlah sebuah software, melainkan **Dokumen Standar** (ISO/IEC 9945) yang dibuat oleh IEEE. Standar ini mendefinisikan bagaimana seharusnya OS Unix bekerja.

  * **Filosofi:** "Tulis sekali, jalan di mana saja (Write once, run anywhere within Unix)."
  * Jika script Anda mematuhi standar POSIX, script itu dijamin jalan di Linux, macOS, FreeBSD, OpenBSD, bahkan di Android shell, tanpa perlu diubah satu huruf pun.

**Apa itu "Bashism"?**
Bashism adalah fitur-fitur canggih yang **hanya** dimiliki oleh `bash` (GNU Bourne Again Shell) tapi **tidak ada** di standar POSIX `sh`.

  * Contoh: Array, `[[ ... ]]`, Loop gaya C `for ((i=0;...))`.
  * **Bahaya:** Jika Anda menggunakan Shebang `#!/bin/sh` (yang menyiratkan POSIX) tapi menggunakan sintaks Array (Bashism), sistem operasi yang ketat akan menolak menjalankan script tersebut.

-----

### 3\. Perbedaan Sintaks: Bashism vs POSIX (Analisis Kode demi Kode)

Mari kita bedah sintaks umum yang sering salah digunakan, dan bagaimana cara menulisnya agar sesuai standar POSIX.

#### A. Pengecekan Kondisi (The Test Condition)

**❌ Kode Bash (Non-Portable):**

```bash
if [[ "$NAMA" == "Budi" ]]; then
    echo "Halo Budi"
fi
```

**Analisis Masalah:**

  * `[[ ... ]]`: Kurung siku ganda adalah fitur spesial Bash. Shell lain (seperti `dash` di Debian/Ubuntu atau `ash` di Alpine) tidak mengerti simbol ini.
  * `==`: Operator perbandingan string gaya C/Python ini tidak standar di POSIX `sh`.

**✅ Kode POSIX (Portable):**

```bash
if [ "$NAMA" = "Budi" ]; then
    echo "Halo Budi"
fi
```

**Perubahan:**

  * Gunakan `[ ... ]` (Single bracket).
  * Gunakan `=` (Satu sama dengan) untuk string.

**Implikasi Keamanan POSIX:**
Di POSIX `[ ]`, variabel yang mengandung spasi bisa menyebabkan crash jika tidak di-quote.

  * Salah: `[ $NAMA = Budi ]` (Jika NAMA kosong, perintah jadi `[ = Budi ]` -\> Error).
  * Benar: `[ "$NAMA" = "Budi" ]` (Wajib pakai tanda kutip dua).

#### B. Array (Larik Data)

**❌ Kode Bash (Non-Portable):**

```bash
SERVER_LIST=("web01" "db01" "cache01") # Definisi Array
echo "Server pertama: ${SERVER_LIST[0]}"
```

**Analisis Masalah:**
POSIX `sh` **TIDAK MENDUKUNG ARRAY**. Sama sekali. Jika Anda butuh menyimpan daftar item, Anda tidak bisa menggunakan sintaks kurung `( ... )`.

**✅ Kode POSIX (Portable):**
Anda harus menggunakan string panjang yang dipisahkan spasi, lalu memotongnya.

```bash
SERVER_LIST="web01 db01 cache01" # String biasa

# Cara iterasi tanpa array
for SERVER in $SERVER_LIST; do
    echo "Memproses: $SERVER"
done
```

**Implikasi:** Menulis script POSIX membutuhkan logika manipulasi string yang lebih cerdik karena ketiadaan struktur data Array.

#### C. Brace Expansion (Ekspansi Kurung Kurawal)

**❌ Kode Bash (Non-Portable):**

```bash
# Membuat file data1.txt s/d data10.txt
touch data{1..10}.txt
```

**Analisis Masalah:**
Fitur `{1..10}` adalah Bashism. Shell standar akan menganggap `{1..10}` sebagai nama file literal yang aneh.

**✅ Kode POSIX (Portable):**
Gunakan perintah eksternal `seq` (sequence) yang tersedia di hampir semua Unix.

```bash
# Gunakan command substitution
for i in $(seq 1 10); do
    touch "data$i.txt"
done
```

#### D. String Manipulation (Substring & Replace)

**❌ Kode Bash (Non-Portable):**

```bash
FILE="gambar.png"
# Mengganti ekstensi .png jadi .jpg langsung di variabel
BARU=${FILE/.png/.jpg}
```

**✅ Kode POSIX (Portable):**
POSIX Shell tidak bisa memanipulasi isi variabel secara langsung. Anda harus menggunakan alat eksternal seperti `sed` atau `cut`.

```bash
FILE="gambar.png"
# Kirim ke 'sed' lewat pipe
BARU=$(echo "$FILE" | sed 's/\.png/\.jpg/')
```

**Implikasi Performa:**
Cara Bash jauh lebih cepat (microseconds) karena terjadi di dalam memori shell. Cara POSIX lebih lambat (milliseconds) karena harus memanggil program eksternal `sed` (membuat proses baru). Namun, cara POSIX dijamin jalan di mana saja.

-----

### 4\. Studi Kasus Implikasi: "Docker Crash"

Bayangkan Anda membuat Docker image berbasis **Alpine Linux** (distro linux super kecil, hanya 5MB). Alpine tidak menggunakan Bash secara default, dia menggunakan `ash` (Almquist Shell) yang patuh pada POSIX.

**Script Anda (`startup.sh`):**

```bash
#!/bin/sh
# Saya pakai /bin/sh biar terlihat standar (padahal isinya Bashism)

function mulai_app() {  # <-- Kata kunci 'function' adalah Bashism!
    echo "Mulai..."
}

mulai_app
```

**Hasil di Alpine Linux:**

```text
/entrypoint.sh: line 4: syntax error: unexpected "("
```

**Analisis:**
Di standar POSIX, mendefinisikan fungsi **TIDAK BOLEH** menggunakan kata kunci `function`.

  * **Bash:** `function nama() { ... }` atau `nama() { ... }` (Boleh dua-duanya).
  * **POSIX:** `nama() { ... }` (Hanya boleh cara ini).

Script Anda akan membuat container Docker gagal start (*CrashLoopBackOff*), dan Anda akan bingung karena "Di laptop saya (Ubuntu dengan Bash) ini jalan lancar\!".

-----

### 5\. Cara Validasi: `checkbashisms`

Bagaimana cara tahu script kita mengandung Bashism atau tidak? Jangan menebak. Gunakan alat audit.

**Instalasi:**
`sudo apt install devscripts` (Ubuntu/Debian)

**Penggunaan:**

```bash
checkbashisms script_saya.sh
```

**Contoh Output Audit:**

```text
possible bashism in script_saya.sh line 5 (arrays):
    SERVERS=(a b c)
possible bashism in script_saya.sh line 10 ([[ .. ]]):
    if [[ $A == $B ]]; then
```

Alat ini akan menunjukkan baris mana yang melanggar standar POSIX.

-----

### 6\. Kapan Harus POSIX, Kapan Harus Bash?

Tidak semua script harus POSIX. Berikut panduannya:

1.  **Gunakan BASH (`#!/bin/bash`) jika:**

      * Script Anda kompleks (butuh Array, String Manipulation canggih).
      * Anda yakin 100% server target memiliki Bash (Standar di RedHat, Ubuntu, CentOS).
      * Anda butuh performa (menghindari pemanggilan `sed`/`awk` berlebihan).
      * **Keuntungan:** Koding lebih cepat, fitur lebih kaya.

2.  **Gunakan POSIX (`#!/bin/sh`) jika:**

      * Script Anda adalah `entrypoint.sh` untuk Docker.
      * Script Anda akan berjalan di sistem Embedded (Router, IoT) yang memorinya kecil.
      * Script Anda didistribusikan ke publik (Open Source) dan Anda tidak tahu user akan menjalankannya di OS apa (mungkin macOS, mungkin FreeBSD).
      * **Keuntungan:** Portabilitas 100%, jalan di sistem paling minimalis sekalipun.

-----

### Ringkasan Implikasi untuk Kurikulum

  * **Modul 2.3 (Logic)** sebelumnya menggunakan `[[ ]]`. Itu adalah praktik terbaik **Modern Bash**, tapi tidak POSIX.
  <!-- * **Modul 4.1 (Function)** sebelumnya menggunakan `local`. Kata kunci `local` sebenarnya **TIDAK** ada di standar POSIX murni, meskipun didukung oleh banyak shell (dash/ash). Di POSIX ketat, semua variabel adalah global. -->

**Revisi Mental untuk Anda:**
Saat Anda menulis `#!/bin/bash`, Anda aman menggunakan semua fitur canggih yang kita pelajari. Tapi jika suatu saat Anda dipaksa bekerja di lingkungan terbatas dan harus mengganti header ke `#!/bin/sh`, Anda harus siap membuang array, double brackets, dan fitur canggih lainnya.

-----

Dalam kurikulum tingkat "Expert" atau "Enterprise", ketergantungan hanya pada `echo` adalah kelemahan. `echo` tidak konsisten antar sistem operasi (implikasi POSIX), dan tidak bisa merapikan teks (misalnya membuat tabel kolom yang rapi).

## MODUL 2.6: Precision Output (printf) & Text Formatting

### 📑 Struktur Pembelajaran Internal

1.  **Filosofi Output:** Mengapa `echo` dianggap "kekanak-kanakan" dan `printf` adalah standar profesional.
2.  **Anatomi `printf`:** Membedah struktur Format String dan Argumen.
3.  **Format Specifiers:** Memahami `%s` (String), `%d` (Desimal/Angka), dan `%f` (Float).
4.  **Escape Sequences:** Mengendalikan baris baru (`\n`), Tab (`\t`), dan suara (`\a`).
5.  **Layout & Alignment:** Membuat tabel rapi dengan padding (rata kanan/kiri).
6.  **Studi Kasus:** Membuat Laporan Tabel Inventaris yang Rapi.

-----

### 1\. Deskripsi Konkret & Peran

Modul ini mengajarkan Anda cara menampilkan data dengan presisi milimeter. Jika `echo` seperti melempar cat ke tembok, `printf` seperti melukis dengan kuas halus.
**Peran:** Saat Anda membuat script CLI profesional, user mengharapkan output yang rapi, sejajar, dan mudah dibaca. `printf` (Print Formatted) adalah satu-satunya cara untuk mencapai ini secara konsisten di semua sistem Unix/Linux (POSIX Compliant).

### 2\. Konsep Kunci & Filosofi Mendalam

**Filosofi: "C-Style Formatting"**
Bash meminjam perintah `printf` langsung dari bahasa pemrograman C. Ini berarti ia sangat kuat dan standar.

  * **Predictability:** `printf` tidak pernah menambahkan baris baru (`newline`) secara otomatis kecuali Anda memintanya. Ini memberi Anda kontrol total.
  * **Separation of Concerns:** `printf` memisahkan **"Bagaimana data ditampilkan"** (Format String) dari **"Apa datanya"** (Arguments).

-----

### 3\. Sintaks Dasar & Implementasi Inti

#### A. Hello World dengan `printf`

Perbedaan utama dengan `echo`.

```bash
# Menggunakan echo (Otomatis ganti baris)
echo "Halo Dunia"

# Menggunakan printf
printf "Halo Dunia" 
# Output: Halo Dunia(kursor berhenti disini, tidak ganti baris!)

# printf yang benar
printf "Halo Dunia\n"
```

#### B. Membedah Sintaks `printf`

```bash
printf "Nama: %s, Umur: %d tahun\n" "Budi" 25
```

**Penjelasan Kata per Kata:**

1.  **`printf`**: Perintah utama.
2.  **`"Nama: %s, Umur: %d tahun\n"`**: Disebut **Format String**. Ini adalah cetakan/template.
      * **`%s`**: *Specifier* untuk **String** (Teks). Bash akan mengambil argumen pertama ("Budi") dan menempelkannya di sini.
      * **`%d`**: *Specifier* untuk **Decimal** (Angka Bulat). Bash mengambil argumen kedua (25) dan menempelkannya di sini.
      * **`\n`**: *Escape Sequence* untuk **New Line** (Baris Baru).
3.  **`"Budi"`**: Argumen pertama (mengisi `%s`).
4.  **`25`**: Argumen kedua (mengisi `%d`).

#### C. Daftar Specifier Penting (Wajib Tahu)

  * **`%s`**: String (Teks).
  * **`%d`** atau **`%i`**: Integer (Bilangan Bulat).
  * **`%f`**: Float (Bilangan Desimal). *Catatan: Bash math tidak support float, tapi `printf` BISA menampilkan float jika inputnya string desimal.*
  * **`%b`**: String dengan interpretasi backslash (misal inputnya punya `\n`, akan diproses).

#### D. Escape Sequences (Karakter Spesial)

Karakter yang diawali backslash `\` memiliki makna khusus:

  * **`\n` (New Line):** Turun ke baris bawah.
  * **`\t` (Tab):** Geser spasi (biasanya 4 atau 8 spasi) untuk indentasi.
  * **`\r` (Carriage Return):** Balik ke awal baris (sering dipakai untuk menimpa loading bar).
  * **`\\`**: Menampilkan karakter backslash itu sendiri.

-----

### 4\. Advanced Formatting: Padding & Alignment (Membuat Tabel)

Ini adalah fitur "Killer" dari `printf`. Bagaimana cara membuat tabel agar kolomnya lurus meskipun panjang namanya beda-beda?

**Masalah (Pakai Echo):**

```bash
echo "Nama Barang Harga"
echo "Buku 5000"
echo "KomputerGaming 15000000"
```

*Output (Berantakan):*

```text
Nama Barang Harga
Buku 5000
KomputerGaming 15000000
```

**Solusi (Pakai Printf dengan Lebar Kolom):**

```bash
# Header
printf "%-20s | %10s\n" "NAMA BARANG" "HARGA (IDR)"
printf "%s\n" "-----------------------------------"

# Data
printf "%-20s | %10d\n" "Buku" 5000
printf "%-20s | %10d\n" "KomputerGaming" 15000000
```

**Bedah Kode Formatting:**

1.  **`%-20s`**:
      * `%s`: Ini String.
      * `20`: Sediakan ruang kosong sebanyak **20 karakter**.
      * `-` (Minus): **Rata Kiri (Left Align)**. Teks ditempel di kiri, sisa ruang kosong di kanan.
2.  **`%10d`**:
      * `%d`: Ini Angka.
      * `10`: Sediakan ruang 10 karakter.
      * *(Tanpa Minus)*: Defaultnya **Rata Kanan (Right Align)**. Ini standar akuntansi agar angka satuan/puluhan lurus ke bawah.

**Output (Rapi Sempurna):**

```text
NAMA BARANG          | HARGA (IDR)
-----------------------------------
Buku                 |       5000
KomputerGaming       |   15000000
```

-----

### 5\. Menyimpan Output ke Variabel (`-v`)

Fitur canggih `printf` di Bash (sejak versi 3.1) adalah opsi `-v`. Alih-alih mencetak ke layar, dia menyimpan hasil formatnya langsung ke variabel tanpa perlu sub-shell `$()`. Ini **lebih cepat**.

```bash
# Cara Lama (Lambat, membuat proses baru)
PESAN=$(printf "User %s login pada jam %s" "Budi" "12:00")

# Cara Baru (Cepat, internal Bash)
printf -v PESAN "User %s login pada jam %s" "Budi" "12:00"

echo "$PESAN"
```

-----

### 6\. Studi Kasus: Script Laporan User

Kita akan membuat script yang meloop daftar user dan menampilkan data mereka dalam tabel yang cantik.

**File: `laporan_user.sh`**

```bash
#!/bin/bash

# Header Tabel
# %-15s : String rata kiri, lebar 15
# %-10s : String rata kiri, lebar 10
# %6s   : String rata kanan, lebar 6 (untuk ID)
printf "%-15s %-10s %6s\n" "USERNAME" "GROUP" "UID"
printf "%s\n" "----------------------------------"

# Loop membaca file /etc/passwd
# Kita set IFS (Internal Field Separator) jadi titik dua ':' karena format passwd adalah user:x:uid:gid...
while IFS=':' read -r user pass uid gid comment home shell; do
    # Hanya tampilkan user dengan UID >= 1000 (User manusia, bukan sistem)
    # (Menggunakan aritmatika bash)
    if (( uid >= 1000 )); then
        # Cetak data sesuai format header
        printf "%-15s %-10s %6d\n" "$user" "users" "$uid"
    fi
done < /etc/passwd
```

-----

### 7\. Hubungan dengan Modul Lain

  * **Prasyarat:** **Modul 2.2 (Variabel)**.
  * **Koneksi:** Materi ini sangat krusial untuk **Modul 5.1 (Logging)**. Log yang baik harus terformat rapi (Timestamp, Level, Pesan) menggunakan `printf` agar mudah diparsing mesin.

<!-- Apakah penambahan Modul 2.6 tentang `printf` ini sudah menjawab kekhawatiran Anda mengenai kelengkapan materi formatting dan kode C-style dalam Bash? -->
<!-- Apakah penjelasan mendalam mengenai standar POSIX dan implikasi "Syntax Error" di lingkungan berbeda ini sudah cukup jelas dan memenuhi standar audit Anda? -->
Sekarang, mari kita masuk ke **PHASE 3: The Power of Pipes**. Di sinilah Bash benar-benar bersinar dan berbeda dari bahasa pemrograman biasa. Kita akan belajar mengalirkan data antar program.

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
