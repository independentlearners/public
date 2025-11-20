Ini adalah ujian akhir untuk membuktikan bahwa Anda telah menguasai **Seni Text Processing** di Linux.

Kita tidak akan menggunakan data "mainan" yang bersih. Saya telah menyiapkan **Data Mentah** yang kotor, tidak konsisten, dan mirip dengan apa yang akan Anda temui di dunia nyata (server logs, legacy data).

Silakan buka terminal Arch Linux Anda (Alacritty/Kitty/dll).

-----

# ⚔️ THE CHALLENGE SERIES: Text Processing Mastery

**Skenario:**
Anda adalah SysAdmin yang baru saja mewarisi server tua. Log-nya berantakan, format datanya kacau, dan manajer Anda meminta laporan statistik dalam waktu 1 jam. Anda hanya punya terminal.

-----

## 🛠️ PERSIAPAN: Membuat Data Mentah (Dataset)

Salin dan tempel perintah berikut ke terminal Anda untuk membuat dua file studi kasus.

**1. File `server_kotor.log`** (Log server yang tidak konsisten)

```bash
cat <<EOF > server_kotor.log
[2025-08-12 08:00:01] INFO: Service started by user admin
[2025-08-12 08:05:22] ERROR: Connection timeout from ip 192.168.1.50
[2025-08-12 08:06:10] Warning: Disk usage at 85%
[2025-08-12 08:10:15] error: DB Connection failed (IP: 10.0.0.5)
[2025-08-12 08:11:00] INFO: Scheduled maintenance
[2025-08-12 08:15:30] CRITICAL: SEGMENTATION FAULT at 0x0045
[2025-08-12 08:20:00] Error: Retrying connection from 192.168.1.50
[2025-08-12 08:22:45] info: User logged out
EOF
```

**2. File `karyawan_kacau.csv`** (Data CSV dengan spasi berlebih dan format huruf tidak rapi)

```bash
cat <<EOF > karyawan_kacau.csv
ID, Nama,    Departemen, Gaji
101, buDi santoso,   IT, 5000
102,   Siti aminah, HR, 4500
103, Andi HERmawan, IT, 5200
104,  Rudi tabuti,  Finance, 4800
EOF
```

-----

## 🎯 LEVEL 1: The Filter (Grep Basics)

**Misi:** Manajer hanya ingin melihat masalah. Tampilkan semua baris yang mengandung pesan kesalahan, tapi perhatikan bahwa penulis log tidak konsisten menulis "ERROR" (ada yang "ERROR", "error", "Error").

**Tantangan:**
Tulis satu perintah untuk menampilkan semua variasi error tersebut beserta nomor barisnya.

\<details\>
\<summary\>👉 \<b\>Klik untuk melihat Kunci Jawaban & Penjelasan\</b\>\</summary\>

```bash
grep -in "error" server_kotor.log
```

**Penjelasan Bedah Kode:**

  * `grep`: Alat pencari.
  * `-i` (Ignore Case): Ini kuncinya. Dia akan menangkap "ERROR", "Error", dan "error".
  * `-n` (Line Number): Menampilkan nomor baris (misal `2:`, `4:`) agar kita tahu lokasi error.
  * `"error"`: Pola string literal.
  * `server_kotor.log`: File target.

\</details\>

-----

## 🎯 LEVEL 2: The Extraction (Regex PCRE)

**Misi:** Tim jaringan meminta daftar alamat IP yang muncul di dalam log tersebut. Mereka tidak peduli dengan pesan errornya, mereka hanya butuh **IP Address**-nya saja.

**Tantangan:**
Gunakan `grep` dengan Regex PCRE untuk mengekstrak *hanya* pola IP Address (format `angka.angka.angka.angka`). Output tidak boleh mengandung teks lain.

\<details\>
\<summary\>👉 \<b\>Klik untuk melihat Kunci Jawaban & Penjelasan\</b\>\</summary\>

```bash
grep -P -o "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" server_kotor.log
```

*Atau versi shorthand:*

```bash
grep -P -o "(\d{1,3}\.){3}\d{1,3}" server_kotor.log
```

**Penjelasan Bedah Kode:**

  * `-P`: Mengaktifkan **Perl Compatible Regex** (agar kita bisa pakai `\d`).
  * `-o` (**Only Matching**): Ini kuncinya\! Secara default grep mencetak *satu baris penuh*. Dengan `-o`, dia hanya mencetak *bagian yang cocok dengan pola*.
  * `\d{1,3}`: Digit angka, muncul 1 sampai 3 kali.
  * `\.`: Titik literal (di-escape). Tanpa backslash, titik berarti "karakter apa saja".

\</details\>

-----

## 🎯 LEVEL 3: The Surgeon (Sed Transformation)

**Misi:** Lihat file `karyawan_kacau.csv`. Formatnya mengerikan (banyak spasi di sekitar koma, huruf nama tidak kapital dengan benar).
Kita harus membersihkan spasi berlebih tersebut agar bisa dimasukkan ke database.

**Tantangan:**
Hapus semua spasi yang berada *di sekitar* tanda koma. Contoh: `,` menjadi `,` dan ` ,  ` menjadi `,`. Gunakan `sed`.

\<details\>
\<summary\>👉 \<b\>Klik untuk melihat Kunci Jawaban & Penjelasan\</b\>\</summary\>

```bash
sed 's/\s*,\s*/,/g' karyawan_kacau.csv
```

**Penjelasan Bedah Kode:**

  * `s/.../.../g`: Perintah Substitusi Global.
  * `\s*`: Regex untuk "Whitespace (spasi/tab) sebanyak 0 kali atau lebih".
  * `,` : Tanda koma literal.
  * **Logika:** Cari [SpasiBanyak][Koma][SpasiBanyak], lalu ganti dengan [Koma] saja.
  * **Hasil:** `101, buDi santoso,   IT, 5000` berubah jadi `101,buDi santoso,IT,5000` (Jauh lebih rapi untuk parsing).

\</details\>

-----

## 🎯 LEVEL 4: The Analyst (Awk Logic)

**Misi:** Kembali ke `server_kotor.log`. Kita curiga ada IP yang melakukan serangan berulang.
Hitung berapa kali setiap IP Address muncul di dalam log.

**Tantangan:**
Gunakan **Awk** (bukan `grep`). Anda harus menggunakan *Regex extraction* di dalam Awk (sedikit advanced) atau memadukan `grep` dan `awk`.
*Hint: Gunakan pipa (`|`). Ambil IP dulu, lalu hitung.*

\<details\>
\<summary\>👉 \<b\>Klik untuk melihat Kunci Jawaban & Penjelasan\</b\>\</summary\>

**Solusi Paling Elegan (Pipeline):**

```bash
grep -P -o "\d{1,3}(\.\d{1,3}){3}" server_kotor.log | awk '{ count[$1]++ } END { for (ip in count) print ip, "muncul", count[ip], "kali" }'
```

**Penjelasan Bedah Kode:**

1.  **Langkah 1 (`grep`):** Kita gunakan trik Level 2 untuk mengambil IP-nya saja. Outputnya adalah daftar IP vertikal.
2.  **Langkah 2 (`awk`):**
      * `count[$1]++`: Memasukkan `$1` (IP dari grep) ke dalam **Associative Array** bernama `count`, dan menambah nilainya (+1).
      * `END { ... }`: Setelah semua baris diproses.
      * `for (ip in count)`: Loop untuk membaca isi array.
      * `print ...`: Mencetak hasil akhir.

**Hasil Output:**

```text
10.0.0.5 muncul 1 kali
192.168.1.50 muncul 2 kali
```

\</details\>

-----

## ☠️ LEVEL 5: FINAL BOSS (Integration)

**Misi:** Laporan Gaji Karyawan IT.
Manajer meminta total pengeluaran gaji untuk departemen **"IT"** saja dari file `karyawan_kacau.csv`.
Masalahnya:

1.  Tulisannya bisa "IT " atau " IT" (spasi kacau).
2.  Kita harus menjumlahkan kolom gaji.

**Tantangan:**
Buat **Satu Baris Perintah (One-Liner)** yang:

1.  Menggunakan `awk`.
2.  Mengatur pemisah kolom (`-F`) menjadi koma.
3.  Memfilter hanya baris yang kolom Departemen-nya mengandung "IT" (abaikan spasi).
4.  Menjumlahkan gajinya.
5.  Mencetak totalnya.

\<details\>
\<summary\>👉 \<b\>Klik untuk melihat Kunci Jawaban & Penjelasan\</b\>\</summary\>

```bash
awk -F, '$3 ~ /IT/ { sum += $4 } END { print "Total Gaji IT:", sum }' karyawan_kacau.csv
```

**Penjelasan Bedah Kode Sangat Detail:**

  * `awk`: Panggil program.
  * `-F,`: **PENTING\!** Karena file CSV, kita ubah *Field Separator* dari spasi (default) menjadi koma.
  * `$3 ~ /IT/`:
      * `$3`: Kolom ketiga (Departemen).
      * `~`: Operator **Match** (Cocok dengan Regex...).
      * `/IT/`: Cari kata "IT" di dalam kolom 3. (Regex ini pintar, dia akan cocok dengan " IT", "IT ", atau "   IT   ").
  * `{ sum += $4 }`: Jika kondisi di atas benar, ambil `$4` (Gaji), tambahkan ke variabel `sum`.
  * `END { print ... }`: Cetak hasil akhir setelah selesai membaca file.

**Hasil Output:**
`Total Gaji IT: 10200`
*(Penjelasan: 5000 dari Budi + 5200 dari Andi)*.

\</details\>

-----

### 📝 Evaluasi Mandiri

  * **0-2 Benar:** Anda masih di fase *Foundation*. Ulangi Fase 1 (Grep).
  * **3-4 Benar:** Anda solid di level *Intermediate*. Anda bisa kerja di lingkungan Linux.
  * **5 Benar (Tanpa mengintip):** **EXPERT LEVEL**. Anda siap menangani server enterprise.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-5/README.md
[selanjutnya]: ../bagian-7/README.md

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
