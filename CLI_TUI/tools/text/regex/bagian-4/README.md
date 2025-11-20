Ini adalah **Puncak Gunung Es** dari pemrosesan teks di CLI. Jika `grep` adalah saringan dan `sed` adalah gunting bedah, maka **Awk** adalah **Excel di dalam Terminal**.

Awk bukanlah sekadar perintah; ia adalah **Bahasa Pemrograman Turing-Complete** yang didesain khusus untuk memanipulasi data terstruktur (baris dan kolom).

-----

# [📊 FASE 4: The Analyst (GNU Awk - Parsing Struktural)][0]

**Status:** *Expert Data Manipulation*
**Fokus Utama:** Pengolahan data kolom (Log, CSV, TSV), Aritmatika, dan Pelaporan.

## BAGIAN 4.0: The Paradigm (Filosofi & Arsitektur)

**Status:** *Core Concept*

Berbeda dengan bahasa prosedural (C, Python) yang mengharuskan Anda menulis *loop* secara eksplisit untuk membaca file, Awk adalah **Data-Driven**.

<details>
  <summary>📃 Daftar Isi</summary>

-----

### 📋 Daftar Isi Bagian 4.0

1.  **Filosofi:** Aho, Weinberger, Kernighan.
2.  **Konsep:** Record vs Field.
3.  **Siklus Kerja:** `Pattern { Action }`.

</details>

-----

### 1\. Deskripsi Konkret

Awk secara otomatis membaca file baris demi baris, memecahnya menjadi kolom-kolom, dan membiarkan Anda melakukan operasi pada kolom tersebut tanpa pusing memikirkan cara membuka atau menutup file.

### 2\. Terminologi Esensial & English Context

  * **Record (Rekaman) / Noun:**
      * *Indo:* Satu unit data lengkap (secara default adalah satu **baris**).
      * *Variabel:* Dilacak oleh `NR` (Number of Records).
  * **Field (Bidang/Kolom) / Noun:**
      * *Indo:* Bagian data dalam satu record yang dipisahkan oleh pemisah (spasi/koma).
      * *Variabel:* Dilacak oleh `NF` (Number of Fields). `$1`, `$2`, dst.
  * **Delimiter / Field Separator (Pemisah) / Noun:**
      * *Indo:* Karakter yang memisahkan antar kolom (default: spasi atau tab).
      * *Variabel:* `FS`.

### 3\. Visualisasi Konsep Data

Bayangkan sebuah tabel Excel.

  * **Record:** Adalah **Baris** (Row).
  * **Field:** Adalah **Kolom** (Column).
  * **$0:** Adalah seluruh baris mentah.

-----

## BAGIAN 4.1: The Anatomy (Sintaks & Variabel)

**Status:** *Foundation*

Mari kita bedah cara Awk melihat data Anda.

### 📋 Daftar Isi Bagian 4.1

1.  Sintaks Dasar: `awk 'options' file`.
2.  Variabel Kolom: `$0` hingga `$N`.
3.  Mencetak Data: `print`.

### 1\. Sintaks Dasar & Implementasi

Cetak kolom pertama (User) dan kolom terakhir (Shell) dari file `/etc/passwd` di Arch Linux.
*Catatan: `/etc/passwd` dipisahkan oleh titik dua (`:`).*

```bash
awk -F ":" '{ print $1, $7 }' /etc/passwd
```

**Bedah Kode (Word-by-Word):**

1.  `awk`: Panggil interpreter GNU Awk.
2.  `-F ":"`: **Option Flag**. Set *Field Separator* menjadi titik dua. Jika tidak diisi, Awk menganggap spasi sebagai pemisah.
3.  `'...'`: Pembungkus program Awk (agar tidak dieksekusi shell).
4.  `{ ... }`: **Action Block**. Semua perintah harus ada di dalam kurung kurawal.
5.  `print`: Perintah cetak ke layar (otomatis menambah *newline*).
6.  `$1`: **Field 1**. Kolom pertama.
7.  `,`: **Comma**. Tanda agar Awk memberi spasi di antara output $1 dan $7.
8.  `$7`: **Field 7**. Kolom ketujuh.
9.  `/etc/passwd`: File input.

### 2\. Variabel Built-in Ajaib (Wajib Hafal)

Awk menyediakan variabel otomatis yang berubah setiap baris:

  * **NR (Number of Records):** Nomor baris saat ini.
      * *Guna:* Menambah nomor urut.
  * **NF (Number of Fields):** Jumlah total kolom di baris tersebut.
      * *Guna:* Mengakses kolom **terakhir** secara dinamis dengan `$NF`.

**Contoh: Cetak kolom terakhir tanpa tahu ada berapa kolom.**

```bash
echo "arch linux is great" | awk '{ print $NF }'
```

  * **Output:** `great`
  * **Logika:** `$NF` berarti "Field ke-NF". Karena NF=4, maka Awk mencetak `$4`.

-----

## BAGIAN 4.2: The Lifecycle (BEGIN, MAIN, END)

**Status:** *Intermediate Logic*

Struktur program Awk yang lengkap terdiri dari tiga blok waktu. Ini sangat penting untuk membuat laporan (Header, Data, Footer).

### 📋 Daftar Isi Bagian 4.2

1.  `BEGIN`: Persiapan sebelum baca file.
2.  `MAIN`: Loop per baris (tanpa kata kunci).
3.  `END`: Kesimpulan setelah file habis.

### 1\. Diagram Alur Eksekusi

1.  Jalankan blok `BEGIN` (1 kali).
2.  Baca Baris 1 -\> Jalankan Blok `MAIN`.
3.  Baca Baris 2 -\> Jalankan Blok `MAIN`.
4.  ... (Sampai EOF / End of File).
5.  Jalankan blok `END` (1 kali).

### 2\. Studi Kasus: Menghitung Total Ukuran File

Kita akan mengambil output `ls -l`, menjumlahkan kolom ukuran (kolom ke-5), dan mencetak totalnya.

```bash
ls -l | awk 'BEGIN { sum=0 } { sum = sum + $5 } END { print "Total Bytes:", sum }'
```

**Bedah Logika Mendalam:**

1.  `BEGIN { sum=0 }`:
      * Sebelum baca baris pertama, siapkan variabel `sum` bernilai 0.
      * *Tips:* Di Awk, variabel otomatis 0 jika tidak diinisialisasi, tapi menulisnya membuat kode lebih terbaca.
2.  `{ sum = sum + $5 }`:
      * Ini blok `MAIN`. Awk menjalankannya untuk **setiap file** yang dilisting oleh `ls`.
      * Ambil nilai kolom 5 (ukuran file), tambahkan ke `sum`.
3.  `END { print ... }`:
      * Setelah semua baris selesai dibaca, cetak teks "Total Bytes:" diikuti nilai akhir `sum`.

-----

## BAGIAN 4.3: Logic Control & Filtering

**Status:** *Programming Capability*

Awk mendukung `if`, `else`, `for`, dan `while` persis seperti bahasa C.

### Implementasi: Filter Lanjutan

Hanya cetak file yang ukurannya di atas 1000 bytes.

```bash
ls -l | awk '$5 > 1000 { print $9, "is big (" $5 " bytes)" }'
```

**Penjelasan Sintaks Pattern:**

  * `$5 > 1000`: Ini adalah **Pattern** (Syarat).
  * Jika syarat **TRUE**, maka blok `{ print ... }` dijalankan.
  * Jika syarat **FALSE**, baris dilewati.
  * Ini jauh lebih cerdas daripada `grep`, karena `grep` tidak mengerti angka (1000 vs 900 dianggap teks). Awk mengerti matematika.

-----

## 🧠 BAGIAN 4.4: Associative Arrays (Fitur Paling Kuat)

**Status:** *Expert / Enterprise Level*

Ini adalah alasan utama SysAdmin senior menggunakan Awk. **Associative Array** memungkinkan Anda melakukan **Aggregasi Data** (Group By) seperti SQL.

### Konsep

Array biasa indeksnya angka (`arr[0]`). Array Asosiatif indeksnya **String** (`arr["ip_address"]`).

### Studi Kasus: Log Analyzer

Anda punya log server web (`access.log`). Anda ingin tahu: **IP mana saja yang mengakses, dan berapa kali mereka mengakses?**

Format Log: `192.168.1.5 - - [Date] "GET /..."`
IP ada di kolom `$1`.

```bash
awk '{ count[$1]++ } END { for (ip in count) print ip, count[ip] }' access.log
```

**Bedah Logika Sangat Detail:**

1.  `{ count[$1]++ }`:
      * Untuk setiap baris, ambil `$1` (IP address, misal "10.0.0.1").
      * Gunakan IP tersebut sebagai **Kunci** (Index) array bernama `count`.
      * `++`: Tambahkan nilai di laci tersebut sebesar 1.
      * *Ilustrasi:* Jika "10.0.0.1" muncul lagi, nilai di laci "10.0.0.1" naik dari 1 jadi 2, dst.
2.  `END { ... }`:
      * Jalankan setelah selesai membaca ribuan baris log.
3.  `for (ip in count)`:
      * Looping khusus untuk array asosiatif. Variabel `ip` akan berisi Kunci (IP Address).
4.  `print ip, count[ip]`:
      * Cetak Kunci (IP) dan Nilai (Jumlah hitungan).

**Hasil:**

```text
192.168.1.5 23
10.0.0.2 5
```

*(Anda baru saja membuat tool analitik log dalam 1 baris kode\!)*

-----

## BAGIAN 4.5: Formatting Output (`printf`)

**Status:** *Reporting*

Perintah `print` biasa itu jelek (tidak rata). Untuk laporan profesional, gunakan `printf` (C-style formatting).

**Sintaks:**
`printf "FORMAT", data1, data2`

**Contoh:**

```bash
awk -F: '{ printf "User: %-10s | ID: %4d\n", $1, $3 }' /etc/passwd
```

  * `%-10s`: String (`s`), rata kiri (`-`), lebar 10 karakter.
  * `|`: Pemisah visual literal.
  * `%4d`: Desimal/Angka (`d`), rata kanan (default), lebar 4 digit.
  * `\n`: Karakter baris baru (wajib di printf).

-----

## ⚠️ Potensi Kesalahan Umum & Solusi

1.  **Bingung Antara Shell Variable dan Awk Variable:**
      * Di shell: `$var`.
      * Di dalam Awk: `var` (tanpa $). Tanda `$`  di Awk KHUSUS untuk kolom ( `$1`, `$2\`).
      * *Salah:* `awk '{ print $NR }'` (Ini berarti cetak kolom ke-nomor-baris).
      * *Benar:* `awk '{ print NR }'` (Cetak nomor baris).
2.  **Menggunakan Single Quote di dalam Single Quote:**
      * Awk dibungkus `'...'`. Jika Anda butuh mencetak tanda petik satu di output, itu *tricky*.
      * *Solusi:* Gunakan heksadesimal `\x27` atau berikan variabel lewat flag `-v`.
3.  **Field Separator Salah:**
      * Lupa `-F`. Awk defaultnya memakan spasi berapapun jumlahnya sebagai satu pemisah. Jika data Anda CSV (`a,b,c`), wajib `-F,`.

-----

## 🔗 Sumber Referensi Lengkap

1.  **GNU Awk User's Guide (The Gawk Bible):** [https://www.gnu.org/software/gawk/manual/gawk.html](https://www.gnu.org/software/gawk/manual/gawk.html)
      * *Rekomendasi:* Buku manual teknis terbaik yang pernah ditulis. Baca bab "Arrays" untuk pencerahan.
2.  **Awk One-Liners:** [https://github.com/adrianscheff/useful-sed-awk-oneliners](https://www.google.com/search?q=https://github.com/adrianscheff/useful-sed-awk-oneliners)
3.  **Grymoire Awk Tutorial:** [https://www.grymoire.com/Unix/Awk.html](https://www.grymoire.com/Unix/Awk.html)

-----

## 💡 Hubungan dengan Fase Terakhir (Enterprise Automation)

Sekarang Anda memiliki:

  * `grep`: Mencari jarum.
  * `Regex`: Mendefinisikan bentuk jarum.
  * `sed`: Memotong/mengganti benang.
  * `awk`: Menghitung statistik benang dan membuat laporan pabrik.

Langkah terakhir (**FASE 5**) adalah menggabungkan semua "monster" ini ke dalam **Shell Scripting Automation**. Kita akan belajar bagaimana membuat skrip `.sh` yang menggabungkan `grep | awk | sed` dengan error handling yang robust, argumen input, dan performa tinggi.

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

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
