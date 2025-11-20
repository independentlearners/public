Sekarang kita beralih dari sekadar "melihat" pola (Regex) menjadi "memanipulasi" pola tersebut.

Selamat datang di **Fase 3**, di mana Anda akan belajar menjadi "Ahli Bedah Teks".

-----

# [🔪 FASE 3: The Surgeon (Sed — Stream Editor)][0]

**Status:** *Advanced Text Manipulation*

Jika `grep` adalah mata pencari, maka `sed` adalah pisau bedah. Sed (Stream Editor) adalah editor teks non-interaktif. Artinya, Anda memberikan instruksi pembedahan di awal, lalu Sed akan memproses file baris demi baris secara otomatis.

## BAGIAN 3.0: The Workflow (Filosofi & Cara Kerja)

**Status:** *Core Concept*

Sebelum mengetik perintah, Anda harus memahami siklus hidup Sed. Banyak pemula gagal di Sed tingkat lanjut karena mereka tidak paham "di mana" teks itu berada saat diproses.

<details>
  <summary>📃 Daftar Isi</summary>

-----

### 📋 Daftar Isi Bagian 3.0

1.  **Siklus:** Read, Execute, Print.
2.  **Memori:** Pattern Space vs Hold Space.
3.  **Sintaks Dasar:** Struktur perintah Sed.

</details>

-----

### 1\. Deskripsi Konkret

Sed membaca input (stdin atau file), menaruh satu baris di meja kerja, melakukan operasi yang Anda minta, mencetak hasilnya ke layar (stdout), lalu membuang baris itu dan mengambil baris berikutnya. Siklus ini berulang sampai file habis.

### 2\. Konsep Kunci: Dua Ruang Memori (PENTING)

Sed memiliki dua buffer memori internal. Memahami ini membedakan pemula dengan ahli.

1.  **Pattern Space (Meja Kerja):**
      * Tempat baris yang *sedang dibaca* diletakkan.
      * Semua perintah manipulasi (ganti, hapus) terjadi di sini.
      * Isinya dibersihkan setiap kali ganti baris baru.
2.  **Hold Space (Saku/Gudang):**
      * Tempat penyimpanan sementara.
      * Anda bisa memindahkan teks dari *Pattern Space* ke *Hold Space* untuk disimpan ("Disalin ke saku"), dan mengambilnya lagi nanti.
      * Isinya **bertahan** antar baris (persisten).

### 3\. Sintaks Dasar

```bash
sed [OPTIONS] 'COMMAND' file.txt
```

-----

## BAGIAN 3.1: The Substitution (Substitusi Dasar)

**Status:** *Bread & Butter (Makanan Sehari-hari)*

Ini adalah perintah yang akan Anda gunakan 90% dari waktu Anda bekerja dengan Sed.

### 📋 Daftar Isi Bagian 3.1

1.  **Sintaks:** `s/old/new/flags`.
2.  **Delimiters:** Mengatasi "Hutan Garis Miring".
3.  **Backreferences:** Menggunakan hasil Regex (`\1`).
4.  **Safety:** Dry-run sebelum eksekusi.

### 1\. Sintaks & Implementasi Inti (Detail Per Kata)

Perintah `s` (substitute).

```bash
sed 's/jendela/linux/g' artikel.txt
```

Mari kita bedah anatominya:

  * `s`: **Command**. Singkatan dari *Substitute*. "Saya ingin mengganti sesuatu".
  * `/`: **Delimiter** (Pemisah). Batas antara perintah, pola lama, dan pola baru.
  * `jendela`: **Regex Pattern**. Apa yang dicari (bisa berupa Regex PCRE dasar).
  * `/`: Pemisah tengah.
  * `linux`: **Replacement String**. Kata penggantinya.
  * `/`: Pemisah akhir.
  * `g`: **Flag**. Singkatan dari *Global*.
      * *Tanpa `g`:* Hanya ganti kata "jendela" *pertama* yang ditemukan di setiap baris.
      * *Dengan `g`:* Ganti *semua* kata "jendela" yang ada di baris tersebut.

### 2\. Masalah "Leaning Toothpick" (Pagar Miring) & Solusinya

Bayangkan Anda ingin mengganti path direktori `/usr/local/bin` menjadi `/opt/bin`.
Jika pakai `/` sebagai pemisah, akan jadi begini:
`s/\/usr\/local\/bin/\/opt\/bin/g` (Sangat sulit dibaca karena penuh *escape character* `\`).

**Fitur Cerdas Sed:** Anda bisa mengganti delimiter dengan karakter apa saja\!

```bash
sed 's#/usr/local/bin#/opt/bin#g' config.sh
```

  * Di sini kita pakai `#` sebagai pemisah. Jauh lebih bersih, bukan?

### 3\. Backreferences (Kekuatan Regex Lanjutan)

Bagaimana jika kita ingin mengubah format tanggal dari `YYYY-MM-DD` menjadi `DD/MM/YYYY`? Kita tidak tahu angkanya apa, kita hanya tahu polanya.

Gunakan **Grouping `()`** (yang perlu di-escape di sed standar menjadi `\(\)`) dan panggil kembali dengan `\1`, `\2`.

**Contoh Kasus:**
Input: `2025-08-17`
Target: `17/08/2025`

```bash
echo "2025-08-17" | sed 's/\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\)/\3\/\2\/\1/'
```

**Bedah Sintaks Sinting ini:**

1.  `\([0-9]\{4\}\)`: Group 1. Mencari 4 digit (Tahun). Disimpan sebagai `\1`.
2.  `-`: Tanda hubung literal.
3.  `\([0-9]\{2\}\)`: Group 2. Mencari 2 digit (Bulan). Disimpan sebagai `\2`.
4.  `-`: Tanda hubung literal.
5.  `\([0-9]\{2\}\)`: Group 3. Mencari 2 digit (Tanggal). Disimpan sebagai `\3`.
6.  `/\3\/\2\/\1/`: Bagian pengganti.
      * Ambil Group 3 (Tanggal).
      * Cetak `/` (di-escape `\/`).
      * Ambil Group 2 (Bulan).
      * ...dan seterusnya.

-----

## BAGIAN 3.2: Addressing & Deletion (Target Operasi)

**Status:** *Precise Control*

Anda tidak selalu ingin mengedit *seluruh* file. Kadang hanya baris 1-10, atau hanya baris yang mengandung kata "Error". Ini disebut **Addressing**.

### 1\. Konsep Addressing

Format umum: `[address]command`.

### 2\. Contoh Implementasi

**A. Menghapus Baris (`d` command)**

```bash
# Hapus baris ke-3
sed '3d' file.txt

# Hapus baris 1 sampai 5 (Range)
sed '1,5d' file.txt

# Hapus baris TERAKHIR ($ = End of file)
sed '$d' file.txt
```

**B. Addressing dengan Regex**
"Hapus semua baris komentar (yang diawali \#)".

```bash
sed '/^#/d' config.conf
```

  * `/^#/`: Ini adalah address-nya (Cari baris yang regex-nya cocok dengan `^#`).
  * `d`: Perintahnya (Delete).

**C. Menggabungkan Address dan Substitusi**
"Hanya lakukan penggantian kata 'foo' menjadi 'bar' JIKA baris tersebut mengandung kata 'Target'".

```bash
sed '/Target/s/foo/bar/g' data.txt
```

  * Sed akan memeriksa baris: Apakah ada kata "Target"?
      * Jika **Tidak**: Lewati (cetak apa adanya).
      * Jika **Ya**: Jalankan perintah `s/foo/bar/g`.

-----

## BAGIAN 3.3: In-Place Editing (Modifikasi File Asli)

**Status:** *Destructive Action (Hati-hati\!)*

Secara default, Sed hanya mencetak hasil ke layar (stdout) demi keamanan. File asli tidak berubah. Untuk mengubah file asli, kita butuh opsi `-i` (*in-place*).

### Sintaks Aman

Saya sangat menyarankan Anda menggunakan backup otomatis saat melakukan *in-place editing*.

```bash
sed -i.bak 's/debug/release/g' project.conf
```

  * `-i.bak`:
    1.  Buat salinan file asli bernama `project.conf.bak`.
    2.  Lalu edit file `project.conf`.
  * Ini menyelamatkan nyawa jika regex Anda salah.

-----

## 🧠 BAGIAN 3.4: The Hold Space (Teknik Ahli / Opsional)

**Status:** *Expert Level (Jarang diajarkan, sangat powerful)*

Ini adalah bagian di mana Sed menjadi bahasa pemrograman Turing-complete. Kita akan memanipulasi urutan baris.

### Perintah Dasar Hold Space:

  * `h` (Hold): Salin isi *Pattern Space* (meja) -\> timpa ke *Hold Space* (saku).
  * `H` (Hold Append): Salin isi *Pattern Space* -\> tambahkan ke *Hold Space*.
  * `g` (Get): Ambil isi *Hold Space* -\> timpa ke *Pattern Space*.
  * `G` (Get Append): Ambil isi *Hold Space* -\> tambahkan ke *Pattern Space*.
  * `x` (Exchange): Tukar isi *Pattern Space* dan *Hold Space*.

### Studi Kasus: Membalik Urutan Baris (Tac Simulator)

Bagaimana cara membalik urutan file (baris terakhir jadi pertama) menggunakan Sed?

```bash
sed -n '1!G;h;$p' file.txt
```

**Penjelasan Logika (Sangat Rumit):**

1.  `sed -n`: Jangan cetak otomatis (Silent mode).
2.  `1!G`: Jika BUKAN baris pertama (`1!`), ambil isi Saku (`G`) dan tempel di bawah Meja. (Efek: Menumpuk baris sebelumnya di bawah baris sekarang).
3.  `h`: Salin seluruh tumpukan di Meja ke Saku (`h`).
4.  `$p`: Jika sudah baris TERAKHIR (`$`), cetak (`p`) isi Meja.

*Hasilnya:* Tumpukan terbalik.

-----

#### 1. POSIX BRE vs ERE (The Standards War)

**Mengapa ini penting?** Di Linux, kadang skrip Anda error hanya karena kurang satu karakter opsi. Anda harus tahu kapan harus melakukan *escape* dan kapan tidak.

**Konsep Dasar:**
Ada dua standar regex "kuno" sebelum PCRE (Perl) merajai dunia:

1.  **BRE (Basic Regular Expressions):** Standar tertua.

      * **Perilaku:** Karakter sakti seperti `?`, `+`, `{`, `}`, `(`, `)` **TIDAK** dianggap sakti kecuali diberi backslash (`\`).
      * **Default di:** `grep` (tanpa flag), `sed` (tanpa flag).
      * **Masalah:** Anda harus mengetik banyak backslash (The Backslash Hell).
      * *Contoh:* Mencari "(abc)?" -\> `\(abc\)\?`

2.  **ERE (Extended Regular Expressions):** Standar yang lebih modern.

      * **Perilaku:** Karakter `?`, `+`, `(`, `)` langsung dianggap sakti.
      * **Diaktifkan dengan:** `grep -E` atau `sed -E` (atau `sed -r` di versi GNU lama).
      * *Contoh:* Mencari "(abc)?" -\> `(abc)?`

**Tabel Perbandingan Sintaks (Wajib Hafal):**

| Fitur | BRE (Grep/Sed Biasa) | ERE (`grep -E`, `sed -E`) | PCRE (`grep -P`) |
| :--- | :--- | :--- | :--- |
| Grouping | `\(...\)` | `(...)` | `(...)` |
| Quantifier {n,m} | `\{n,m\}` | `{n,m}` | `{n,m}` |
| One or More (+) | `\+` | `+` | `+` |
| Zero or One (?) | `\?` | `?` | `?` |
| Alternation (OR) | `\|` | `\|` | `\|` |

**Best Practice:**
Selalu gunakan **ERE** (`-E`) atau **PCRE** (`-P`) jika memungkinkan, agar regex Anda bersih dan mudah dibaca (kompatibel dengan cara pikir programmer modern). Gunakan BRE hanya jika Anda menulis skrip untuk sistem UNIX kuno (seperti Solaris atau AIX).

-----

#### 2. Regex dalam Bahasa Pemrograman (Dart/Flutter Context)

**Mengapa ini penting?** Sebagai programmer. Anda perlu tahu bahwa logika yang Anda pelajari di CLI (`grep -P`) bisa langsung di-*copy paste* ke kode Anda.

**Implementasi: Dari CLI ke Dart**

Mari kita gambarkan dalam dart, misalkan Anda sudah berhasil menyusun regex untuk menangkap Email di terminal:
**Terminal (CLI):**

```bash
grep -P "[\w\.-]+@[\w\.-]+\.\w+" data.txt
```

**Penerapan di Dart (Flutter):**
Di Dart, Regex adalah objek first-class. Library standarnya adalah `dart:core`.

```dart
void main() {
  // 1. Definisikan Teks Sumber
  String rawText = "Hubungi admin di support@archlinux.org segera.";

  // 2. Definisikan Pola (Sama persis dengan PCRE, tapi escape backslash)
  // Perhatikan 'r' (raw string) agar kita tidak perlu double escape (\\w)
  RegExp emailPattern = RegExp(r"[\w\.-]+@[\w\.-]+\.\w+");

  // 3. Eksekusi Pencarian (Mirip grep)
  // Mencari kecocokan pertama
  RegExpMatch? match = emailPattern.firstMatch(rawText);

  if (match != null) {
    // Ini outputnya ($0 di awk/bash)
    print("Email ditemukan: ${match.group(0)}"); 
  }
  
  // 4. Validasi (Mirip grep -q)
  bool isValid = emailPattern.hasMatch("bukan_email");
  print("Validasi: $isValid"); // false
}
```

**Konsep Kunci Interoperabilitas:**

1.  **Raw String (`r"..."`):** Di Python dan Dart, selalu gunakan `r` sebelum string regex. Ini mencegah bahasa pemrograman menerjemahkan `\n` atau `\t` sebelum regex membacanya.
2.  **Method Mapping:**
      * `grep` -\> `RegExp.hasMatch()` atau `RegExp.allMatches()`
      * `sed s///` -\> `String.replaceAll(RegExp(...), "replacement")`
      * `awk` logic -\> Dilakukan dengan manipulasi List/Map di Dart.

-----

## ⚠️ Potensi Kesalahan Umum & Solusi

1.  **Lupa Escape Karakter Khusus:**
      * Ingat, di Sed standar (tanpa flag `-E` atau `-r`), kurung `()` dan kurawal `{}` HARUS di-escape `\(\)` `\{\}` agar berfungsi sebagai grouping/quantifier.
      * *Solusi:* Gunakan `sed -E` (Extended Regex) agar sintaks lebih mirip PCRE modern dan tidak perlu banyak escape.
      * Contoh Modern: `sed -E 's/(abc)+/xyz/'` (Lebih bersih).
2.  **Menggunakan `-i` tanpa backup:**
      * Sekali enter, file berubah. Jika regex salah hapus, data hilang. Selalu gunakan `-i.bak` atau preview dulu tanpa `-i`.
3.  **Delimiter Collision:**
      * Mengganti URL `http://` tapi pakai delimiter `/`. Error. Gunakan `#` atau `|`.

-----

## 🔗 Sumber Referensi Lengkap

1.  **GNU Sed Manual (Official):** [https://www.gnu.org/software/sed/manual/sed.html](https://www.gnu.org/software/sed/manual/sed.html)
      * *Wajib baca:* Bab "The `s` Command" dan "Regular Expressions".
2.  **Sed One-Liners Explained:** [https://catonmat.net/sed-one-liners-explained](https://www.google.com/search?q=https://catonmat.net/sed-one-liners-explained)
      * Koleksi resep Sed siap pakai untuk tugas sehari-hari.
3.  **Grymoire Sed Tutorial:** [https://www.grymoire.com/Unix/Sed.html](https://www.grymoire.com/Unix/Sed.html)
      * Tutorial legendaris yang menjelaskan Pattern Space vs Hold Space dengan sangat visual.

-----

## 💡 Hubungan dengan Modul Berikutnya

Anda sekarang sudah bisa:

1.  Mengalirkan data (`|`, `>`).
2.  Mencari data (`grep`).
3.  Mengubah data (`sed`).

Namun, Sed lemah dalam hal **Aritmatika** (menghitung angka) dan **Logika Kolom** (seperti Excel). Jika Anda punya file CSV dan ingin "Menjumlahkan kolom ke-3 dan mencetak rata-ratanya", Sed akan sangat kesulitan.

Di sinilah kita butuh **FASE 4: The Analyst (AWK)**. Awk bukan sekadar editor, dia adalah *Data Extraction and Reporting Language*.

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
