Kita sekarang memasuki wilayah yang membedakan pemula dengan ahli: **Regular Expressions (Regex)**.

Banyak orang takut pada Regex karena terlihat seperti kode acak (contoh: `(?<=\d)\w+`). Namun, di sini kita akan membongkarnya perlahan. Kita akan melewati standar Regex biasa dan langsung menuju **PCRE (Perl Compatible Regular Expressions)**.

*Mengapa PCRE?* Karena sintaks ini adalah standar industri yang digunakan di **Dart (Flutter)**, Python, JavaScript, dan PHP. Menguasai modul ini berarti Anda menguasai pencarian pola untuk hampir semua bahasa pemrograman modern.

-----

# [🧠 FASE 2: The Brain of Pattern (Logika Pola - PCRE)][0]

Di fase ini, kita berhenti melihat teks sebagai "kata-kata" dan mulai melihatnya sebagai "struktur" dan "pola".

## BAGIAN 2.1: The Atoms (Metacharacters & Classes)

**Status:** *Core Foundation*

Sebelum menyusun kalimat Regex, Anda harus mengenal huruf-hurufnya. Dalam Regex, karakter dibagi dua: **Literal** (huruf biasa) dan **Metacharacter** (huruf sakti dengan makna khusus).
<details>
  <summary>📃 Daftar Isi</summary>

-----

### 📋 Daftar Isi Bagian 2.1

1.  **Konsep:** Literal vs Metacharacter.
2.  **Escaping:** Karakter Backslash (`\`).
3.  **Anchors:** Jangkar Posisi (`^`, `$`).
4.  **Character Classes:** Himpunan karakter (`[]`).
5.  **Shorthand Classes:** Jalan pintas (`\d`, `\w`, `\s`).
6.  **Praktek:** Validasi format sederhana.

</details>

-----

### 1\. Deskripsi Konkret & Peran

Bagian ini mengajarkan cara menargetkan jenis karakter tertentu. Misalnya, alih-alih mencari "user1", "user2", "user3" secara manual, Anda belajar mencari "kata 'user' diikuti angka apa saja". Ini adalah fondasi fleksibilitas.

### 2\. Konsep Kunci & Filosofi

**Filosofi:** *Abstraction over Specificity.*
Jangan mencari "apa isinya", tapi carilah "bagaimana bentuknya".

**Analogi:**
Jika pencarian biasa (`grep "budi"`) adalah mencari seseorang bernama Budi, maka Regex (`grep -P "\w+"`) adalah mencari "siapapun manusia yang punya nama".

### 3\. Terminologi Esensial

  * **Metacharacter / Noun:**
      * *Definisi:* Karakter yang tidak mewakili dirinya sendiri, melainkan mewakili ide atau perintah. Contoh: `.` bukan titik, tapi "karakter apa saja".
  * **Escape (`\`) / Verb & Noun:**
      * *Definisi:* Membatalkan kesaktian metacharacter agar menjadi karakter biasa, atau sebaliknya.
      * *Contoh:* `\.` artinya "cari titik asli", bukan "karakter apa saja".
  * **Whitespace (`\s`) / Noun:**
      * *Definisi:* Karakter tak terlihat seperti Spasi, Tab, atau Baris Baru.

-----

### 4\. Sintaks Dasar & Implementasi Inti (Detail Per Kata)

Untuk menggunakan PCRE di terminal Arch Linux, kita wajib menggunakan flag `-P`.

#### A. The Wildcard (Si Titik `.`)

```bash
grep -P "r.t" file.txt
```

  * `r`: Huruf 'r' literal.
  * `.`: **Satu** karakter apa saja (huruf, angka, simbol), kecuali baris baru.
  * `t`: Huruf 't' literal.
  * *Cocok:* "rat", "rot", "r9t", "r-t".
  * *Tidak Cocok:* "rt" (karena titik minta 1 karakter), "root" (karena titik cuma minta 1, bukan 2).

#### B. Anchors (Jangkar Posisi `^` dan `$`)

Jangkar tidak memakan karakter, dia hanya menunjuk **posisi**.

  * **Caret (`^`): Awal Baris.**

    ```bash
    grep -P "^Error" syslog
    ```

      * *Arti:* Cari baris yang **dimulai** dengan kata "Error".
      * *Cocok:* "**Error**: Connection lost"
      * *Tidak Cocok:* "System encountered an **Error**" (karena Error ada di tengah).

  * **Dollar (`$`): Akhir Baris.**

    ```bash
    grep -P "success$" syslog
    ```

      * *Arti:* Cari baris yang **diakhiri** dengan kata "success".

#### C. Character Classes (`[...]`)

"Pilih satu dari kotak ini".

  * `[aeiou]`: Cocok dengan satu huruf vokal apa saja.
  * `[0-9]`: Cocok dengan satu angka 0 sampai 9.
  * `[^0-9]`: (Perhatikan tanda `^` di dalam kurung siku artinya **Negasi/Bukan**). Cocok dengan apa saja **KECUALI** angka.

#### D. Shorthand Classes (Jalan Pintas Wajib Hafal)

Ini adalah sintaks yang akan sering Anda gunakan di Dart/Flutter nanti.

| Simbol | Arti | Ekuivalen |
| :--- | :--- | :--- |
| `\d` | Digit (Angka) | `[0-9]` |
| `\D` | Non-Digit (Bukan Angka) | `[^0-9]` |
| `\w` | Word Char (Huruf, Angka, Underscore) | `[a-zA-Z0-9_]` |
| `\W` | Non-Word Char (Simbol, Spasi) | `[^a-zA-Z0-9_]` |
| `\s` | Whitespace (Spasi, Tab, Enter) | `[ \t\r\n]` |
| `\S` | Non-Whitespace | `[^ \t\r\n]` |

**Contoh Studi Kasus:**
Mencari format jam sederhana (misal: 12:05) di log.

```bash
grep -P "\d\d:\d\d" jadwal.txt
```

  * `\d`: Angka pertama.
  * `\d`: Angka kedua.
  * `:`: Titik dua literal.
  * `\d\d`: Dua angka berikutnya.

-----

## BAGIAN 2.2: The Multipliers (Quantifiers)

**Status:** *Core Logic*

Setelah tahu cara memilih karakter (`\d`), kita harus menentukan "berapa banyak" karakter itu muncul.

### 📋 Daftar Isi Bagian 2.2

1.  **Konsep:** Repetisi dinamis.
2.  **Basic Quantifiers:** `*`, `+`, `?`.
3.  **Specific Quantifiers:** `{n,m}`.
4.  **Greedy vs Lazy:** Konsep rakus vs secukupnya.

### 1. Konsep Kunci

🔎 **Quantifier Secara Umum** adalah simbol atau kata dalam logika maupun bahasa pemrograman yang digunakan untuk menyatakan jumlah atau cakupan objek dalam suatu pernyataan.  

- **Universal quantifier (∀)** → menyatakan *“untuk semua”*. Contoh: ∀x ∈ N, x + 0 = x.  
- **Existential quantifier (∃)** → menyatakan *“ada setidaknya satu”*. Contoh: ∃x ∈ N, x² = 4.  

**Quantifier dipakai untuk mengontrol ruang lingkup kebenaran pernyataan**: apakah berlaku untuk semua elemen, atau cukup ada satu elemen yang memenuhi. Dalam regex juga sama, Quantifier adalah simbol di regex yang menentukan berapa kali sebuah pola harus muncul. Contoh umum:

`*` : 0 atau lebih kali
`+` : 1 atau lebih kali
`?` : 0 atau 1 kali
`{n}` : tepat n kali
`{n,}` : n atau lebih kali
`{n,m}` : antara n dan m kali

Jadi ketika anda menulis a* artinya “a” boleh tidak muncul atau muncul berulang‑ulang. Quantifier selalu berlaku untuk **satu token tepat di sebelah kirinya**.

### 2. Sintaks Dasar (Detail Per Simbol)

#### A. The Question Mark (`?`) — 0 atau 1 (Opsional)

"Barang ini boleh ada, boleh tidak."

```bash
grep -P "colou?r" text.txt
```

  * `u?`: Huruf 'u' bersifat opsional.
  * *Cocok:* "color", "colour".
  * [Lebih lanjut][1]

#### B. The Plus (`+`) — 1 atau Lebih (Wajib Ada Minimal Satu)

"Harus ada setidaknya satu, tapi boleh banyak."

```bash
grep -P "Go+gle" text.txt
```

  * `o+`: Huruf 'o' harus ada minimal satu.
  * *Cocok:* "Gogle", "Google", "Gooooogle".
  * *Tidak Cocok:* "Ggle".
  * [Lebih lanjut][2]

#### C. The Star (`*`) — 0 atau Lebih

"Tidak ada tidak apa-apa, kalau banyak juga boleh."

```bash
grep -P "10*1" text.txt
```

  * `0*`: Angka 0 boleh hilang, boleh banyak.
  * *Cocok:* "11" (0 nya nol kali), "101", "100001".
  * [Lebih lanjut][3]

#### D. Curly Braces (`{min,max}`) — Spesifik

  * `{3}`: Tepat 3 kali.
  * `{2,5}`: Minimal 2, Maksimal 5.
  * `{2,}`: Minimal 2, Maksimal tak terhingga.
  * [Lebih lanjut][4]

**Contoh Implementasi:** Mencari IP Address (sederhana).

```bash
grep -P "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" access.log
```

  * `\d{1,3}`: Angka (digit) sebanyak 1 sampai 3 kali.
  * `\.`: Titik literal (di-escape).
  * [Lebih lanjut][5]

-----

### 3. Visualisasi Penting: Greedy vs Lazy (PENTING)

Ini adalah konsep yang sering membuat error logika. Secara default, Regex itu **Greedy (Rakus)**. Dia akan memakan teks sebanyak mungkin.

**Kasus:**
Teks: `<div class="header">Judul</div>`
Regex: `<.*>`

  * **Harapan Pemula:** Menangkap `<div>` saja.
  * **Kenyataan (Greedy):** Menangkap `<div class="header">Judul</div>` (Dari `<` pertama sampai `>` paling terakhir).

**Solusi: Lazy Quantifier (`?`)**
Tambahkan `?` setelah quantifier untuk membuatnya berhenti secepat mungkin.
Regex: `<.*?>`

  * **Hasil:** Menangkap `<div>` (Berhenti pada `>` pertama yang ditemui).

<!-- end list -->

  - *Bayangkan Pacman. Greedy Pacman makan sampai tembok terakhir. Lazy Pacman berhenti begitu ketemu makanan pertama.*

-----

## BAGIAN 2.3: Structure & Logic (Groups & Alternation)

**Level:** Intermediate to Expert

Di sini kita mulai membangun logika pemrograman di dalam pencarian teks.

### 1. Grouping `(...)`

Kurung biasa `()` memiliki dua fungsi:

1.  **Menyatukan:** Agar quantifier berlaku untuk satu *frase*, bukan satu huruf.
2.  **Capturing:** Menyimpan hasil tangkapan ke memori (Variables `$1`, `$2`).

**Contoh:**

```bash
grep -P "(ha)+" text.txt
```

  * Tanpa kurung `ha+`: h diikuti aaaaa (haaaaa).
  * Dengan kurung `(ha)+`: frase "ha" diulang (hahahaha).

### 2. Alternation `|` (OR Logic)

Memilih satu opsi atau lainnya.

```bash
grep -P "jambu|mangga|pisang" buah.txt
```

  * Cocok dengan salah satu dari ketiga kata tersebut.

**Kombinasi Group & OR:**

```bash
grep -P "Licens(e|ing)" document.txt
```

  * Cocok dengan: "License" ATAU "Licensing".

-----

## ⚠️ Potensi Kesalahan Umum & Solusi

1.  **Salah Paham `*` di Shell vs Regex:**
      * *Di Shell (Bash):* `*.txt` artinya semua file berakhiran .txt.
      * *Di Regex:* `*.txt` akan **ERROR** atau aneh, karena `*` harus ada karakter di kirinya.
      * *Benar di Regex:* `.*\.txt` (Titik dulu, baru bintang).
2.  **Lupa Escape:**
      * Mencari uang `$100` tapi menulis regex `$100`. Ini salah karena `$` adalah akhir baris.
      * *Solusi:* Tulis `\$100`.
3.  **Over-Escaping:**
      * Karakter seperti `_` atau `@` biasanya tidak perlu di-escape. Cek referensi jika ragu.

-----

## 🔗 Sumber Referensi Lengkap

1.  **Regex101 (Interactive Tester):** [https://regex101.com/](https://regex101.com/)
      * *Tips:* Di panel kiri, pastikan pilih "Flavor: PCRE2". Tool ini memberikan penjelasan *real-time* untuk setiap karakter yang Anda ketik.
2.  **PCRE2 Official Documentation:** [https://pcre.org/current/doc/html/](https://pcre.org/current/doc/html/)
3.  **RexEgg (Tutorial Mendalam):** [https://www.rexegg.com/](https://www.rexegg.com/)
      * Situs legendaris untuk mendalami filosofi regex hingga level expert.

-----

## 💡 Hubungan dengan Modul Berikutnya

Setelah Anda menguasai Regex (Pola), Anda mungkin bertanya: *"Oke, saya sudah menemukan polanya, lalu saya mau ganti teksnya bagaimana?"*

Di sinilah kita akan masuk ke **FASE 3: Sed (Stream Editor)**. Sed menggunakan Regex yang baru saja Anda pelajari sebagai "otak" untuk melakukan operasi bedah (edit) pada file. Jadi, pastikan Anda benar-benar paham konsep `^`, `$`, `.` dan `*` sebelum lanjut.

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum CLI][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ./bagian-1/README.md
[2]: ./bagian-2/README.md
[3]: ./bagian-3/README.md
[4]: ./bagian-4/README.md
[5]: ./bagian-5/README.md
[6]: ./
[7]: ./
[8]: ./
[9]: ./
[10]: ./
[11]: ./
[12]: ./
[13]: ./
[14]: ./
[15]: ./
[16]: ./
[17]: ./
[18]: ./
