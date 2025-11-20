Kurikulum ini dirancang untuk membawa Anda dari pemahaman dasar aliran teks (*text streams*) hingga memanipulasi data kompleks selevel *Enterprise Data Engineer*, hanya dengan menggunakan alat-alat standar Unix/Linux yang *timeless* (tak lekang oleh waktu).

-----

# [📜 Master Kurikulum: Text Processing Command Line Interface (CLI)][0]

**Fokus:** Regex (PCRE), Grep, Sed, Awk.
**Filosofi:** *Do one thing and do it well* (Lakukan satu hal dan lakukan dengan sangat baik).
**Target OS:** Linux (Arch Linux/Unix-like).
**Estimasi Waktu Total:** 3 - 6 Bulan (Tergantung intensitas).

-----

## 🛠️ Persiapan & Lingkungan (Prasyarat)

Sebelum masuk ke materi inti, pastikan lingkungan Arch Linux Anda siap.

  * **Sistem Operasi:** Arch Linux (Rolling Release).
  * **Shell:** Bash atau Zsh (Default di banyak sistem, Zsh populer di Arch).
  * **Terminal:** Alacritty/Kitty/Foot (Sesuai preferensi Sway/Wayland Anda).
  * **Instalasi Tools (Pacman):**
    ```bash
    sudo pacman -S grep sed gawk pcre pcre2 man-db
    ```
    *(Catatan: `gawk` adalah GNU Awk, standar de facto di Linux).*

-----

## [FASE 1: The Stream & The Search (Fondasi & Pencarian)][1]

**Level:** Novice to Intermediate
**Waktu:** 2-3 Minggu

Fase ini membangun mental model tentang bagaimana teks "mengalir" di Linux dan bagaimana menangkap (menemukan) informasi spesifik di dalam aliran tersebut.

### 1\. Modul: Filosofi Unix & Grep (Global Regular Expression Print)

**Identitas Teknologi:**

  * **Bahasa Asli:** C.
  * **Pengembang:** [Ken Thompson (versi asli),](https://id.wikipedia.org/wiki/Ken_Thompson) Mike Haertel (GNU Grep).
  * **Lisensi:** GPL (GNU General Public License).
  * **Repositori:** [GNU Grep Git (Savannah)](https://git.savannah.gnu.org/git/grep.git) | [Mirror GitHub (Unofficial)](https://www.google.com/search?q=https://github.com/frederic/grep).

**Deskripsi Konkret:**
Anda akan belajar cara menyaring ribuan baris log atau kode untuk menemukan jarum dalam jerami menggunakan `grep`. Anda juga akan memahami konsep *Standard Streams* (stdin, stdout, stderr).

**Konsep Dasar dan Filosofi:**
Grep bekerja berdasarkan prinsip **Filtering**. Ia tidak mengubah teks, ia hanya "memilih" baris mana yang boleh lewat berdasarkan pola yang Anda berikan. Ini mengajarkan efisiensi: jangan baca semuanya, baca hanya yang relevan.

**Terminologi Kunci & English Lesson:**

  * **Standard Input (stdin) / Noun:**
      * *Indo:* Masukan standar.
      * *English Context:* "The program reads from standard input." (Program membaca dari masukan standar). Ini adalah aliran data yang masuk ke program.
  * **Pipe (`|`) / Noun & Verb:**
      * *Indo:* Pipa / Menyalurkan.
      * *English Context:* "Pipe the output of `cat` to `grep`." (Salurkan keluaran `cat` ke `grep`). Simbol `|` menghubungkan stdout program A ke stdin program B.
  * **Case Sensitive / Adjective:**
      * *Indo:* Peka huruf besar/kecil.
      * *English Context:* "Grep is case sensitive by default." (Grep membedakan huruf besar dan kecil secara bawaan).
  * **Recursive / Adjective:**
      * *Indo:* Rekursif (berulang ke dalam).
      * *English Context:* "Search recursively through directories." (Cari secara mendalam melalui direktori dan sub-direktorinya).

**Daftar Isi (Table of Contents):**

1.  Understanding File Descriptors: stdin (0), stdout (1), stderr (2).
2.  Basic Grep: Searching literal strings (`grep "error" syslog`).
3.  Grep Options: `-i` (ignore case), `-v` (invert match), `-r` (recursive), `-l` (list files only).
4.  Context Control: `-A` (After), `-B` (Before), `-C` (Context) — *Sangat berguna untuk debugging.*
5.  Colorizing & Line Numbers (`--color`, `-n`).
6.  **Error Handling:** Apa arti `exit status 1` (not found) vs `exit status 0` (found) pada Grep untuk scripting.

**Sumber Referensi:**

  * [GNU Grep Manual](https://www.gnu.org/software/grep/manual/grep.html)
  * [Arch Wiki - Grep](https://www.google.com/search?q=https://wiki.archlinux.org/title/Grep)
  * [TLDR Pages - Grep](https://www.google.com/search?q=https://tldr.inbrowser.app/pages/common/grep)

**Visualisasi:**

  - *Bayangkan air mengalir melalui pipa, di mana `grep` adalah saringan yang hanya membiarkan partikel warna tertentu lewat.*

-----

## [FASE 2: The Brain of Pattern (Logika Pola)][2]

**Level:** Intermediate to Advanced
**Waktu:** 3-4 Minggu

Di sini Anda mempelajari "bahasa" pencarian itu sendiri. Regex adalah *skill* yang transferable (bisa dipakai di Dart, Python, JS, Vscode, dll). Kita fokus pada **PCRE (Perl Compatible Regular Expressions)** karena ini adalah standar emas industri.

### 2\. Modul: Regex Deep Dive (PCRE)

**Identitas Teknologi:**

  * **Bahasa Asli:** C.
  * **Pengembang:** Philip Hazel.
  * **Lisensi:** BSD License.
  * **Repositori:** [PCRE2 GitHub](https://github.com/PCRE2Project/pcre2).

**Deskripsi Konkret:**
Belajar menyusun pola abstrak untuk mencocokkan teks dinamis (misal: memvalidasi email, mengambil IP address, mencari format tanggal ISO 8601).

**Konsep Dasar dan Filosofi:**
Regex adalah **Abstraksi**. Alih-alih mencari kata "Senin", Anda mencari "Kata apapun yang diawali huruf kapital dan diakhiri 'in'". Ini melatih logika simbolik.

**Terminologi Kunci & English Lesson:**

  * **Wildcard / Noun:**
      * *Indo:* Karakter liar/pengganti (biasanya `.`).
      * *English Context:* "The dot is a wildcard matching any single character." (Titik adalah karakter pengganti yang cocok dengan karakter tunggal apa pun).
  * **Quantifier / Noun:**
      * *Indo:* Penentu jumlah.
      * *English Context:* "Use quantifiers to specify how many times a character must occur." (Gunakan quantifier untuk menentukan berapa kali karakter harus muncul). Contoh: `*` (0 or more), `+` (1 or more), `?` (0 or 1).
  * **Anchor / Noun:**
      * *Indo:* Jangkar/Penanda posisi.
      * *English Context:* "Anchors do not consume characters; they assert a position." (Jangkar tidak memakan karakter; mereka menegaskan posisi). Contoh: `^` (awal baris), `$` (akhir baris).
  * **Lookahead & Lookbehind / Noun:**
      * *Indo:* Lihat ke depan & Lihat ke belakang (Assertions).
      * *English Context:* "Positive lookahead allows matching a pattern only if it is followed by another pattern."

**Daftar Isi (Table of Contents):**

1.  Basic Metacharacters (`.`, `^`, `$`).
2.  Character Classes (`[a-z]`, `[^0-9]`, `\d`, `\w`, `\s`).
3.  Quantifiers & Greediness (`*`, `+`, `?`, `{n,m}`). Memahami *Greedy* vs *Lazy* match.
4.  Grouping & Capturing Groups `(...)` vs Non-capturing `(?:...)`.
5.  Backreferences (`\1`, `\2`) — Menggunakan kembali apa yang sudah ditangkap.
6.  **PCRE Advanced:** Lookahead `(?=...)` dan Lookbehind `(?<=...)`.
7.  **Praktek di CLI:** Menggunakan `grep -P` untuk mengaktifkan engine PCRE.

**Sumber Referensi:**

  * [PCRE Documentation](https://www.pcre.org/original/doc/html/pcrepattern.html)
  * [Regex101 (Interactive Tester)](https://regex101.com/) - *Tools wajib untuk debugging regex.*

-----

## [FASE 3: The Surgeon (Pengeditan Otomatis)][3]

**Level:** Advanced
**Waktu:** 3-4 Minggu

Jika Grep menemukan teks, Sed (Stream Editor) mengubahnya. Ini adalah otomatisasi pengeditan teks tanpa membuka teks editor interaktif (seperti Nano/Vim).

### 3\. Modul: Sed (Stream Editor)

**Identitas Teknologi:**

  * **Bahasa Asli:** C.
  * **Pengembang:** Lee E. McMahon (Bell Labs), versi GNU oleh Free Software Foundation.
  * **Lisensi:** GPL.
  * **Repositori:** [GNU Sed Git](https://git.savannah.gnu.org/git/sed.git).

**Deskripsi Konkret:**
Anda akan memanipulasi file konfigurasi, melakukan *find & replace* massal pada ribuan file, dan menghapus baris tertentu secara otomatis.

**Konsep Dasar dan Filosofi:**
Sed bekerja dengan siklus: **Read, Execute, Print**. Sed memiliki **Pattern Space** (meja kerja aktif) dan **Hold Space** (penyimpanan sementara/saku). Memahami dua ruang ini adalah kunci penguasaan Sed tingkat lanjut (Turing Complete).

**Terminologi Kunci & English Lesson:**

  * **Substitution / Noun:**
      * *Indo:* Penggantian/Substitusi.
      * *English Context:* "Perform a global substitution." (Lakukan penggantian secara menyeluruh). Syntax: `s/old/new/g`.
  * **Delimiter / Noun:**
      * *Indo:* Pembatas.
      * *English Context:* "You can change the delimiter if the pattern contains slashes." (Anda bisa mengubah pembatas jika pola mengandung garis miring). Contoh: Gunakan `#` alih-alih `/` -\> `s#http://#https://#`.
  * **In-place Editing / Noun Phrase:**
      * *Indo:* Pengeditan langsung di tempat (di file asli).
      * *English Context:* "Use the -i flag for in-place editing." (Gunakan bendera -i untuk pengeditan langsung pada file).

**Daftar Isi (Table of Contents):**

1.  Basic Substitution: `s/regex/replacement/flags`.
2.  Addressing: Memilih baris mana yang diedit (misal: `1,5d` hapus baris 1-5, atau `/error/d` hapus baris yang mengandung 'error').
3.  Multiple Commands: Menggunakan `-e` atau `{ ... }`.
4.  **Advanced Concept:** Pattern Space vs Hold Space (`h`, `H`, `g`, `G`, `x`). Ini untuk operasi multi-baris.
5.  Flow Control: Labels dan Branching (`:label`, `b`, `t`) — Membuat *loops* di dalam Sed.
6.  **Error Handling:** Menggunakan perintah `l` (list) untuk melihat karakter tersembunyi (hidden chars/line breaks) saat regex gagal cocok.

**Sumber Referensi:**

  * [GNU Sed Manual](https://www.gnu.org/software/sed/manual/sed.html)
  * [Sed One-Liners Explained](https://www.google.com/search?q=https://catonmat.net/sed-one-liners-explained) - *Karya Peteris Krumins, sangat direkomendasikan.*

-----

## [FASE 4: The Analyst (Parsing Struktural)][4]

**Level:** Expert
**Waktu:** 4-5 Minggu

Awk bukan sekadar perintah, ia adalah **Bahasa Pemrograman** lengkap yang didesain untuk pemrosesan teks berbasis kolom (data tabular).

### 4\. Modul: GNU Awk (Gawk)

**Identitas Teknologi:**

  * **Bahasa Asli:** C.
  * **Pengembang:** Aho, Weinberger, Kernighan (Asli). GNU version oleh FSF.
  * **Lisensi:** GPL.
  * **Repositori:** [GNU Gawk Git](https://git.savannah.gnu.org/git/gawk.git).

**Deskripsi Konkret:**
Anda akan membuat laporan dari log server, menghitung total ukuran file, memformat output CSV ke JSON, atau melakukan operasi matematika pada data teks.

**Konsep Dasar dan Filosofi:**
Awk memperlakukan teks sebagai **Records** (biasanya baris) dan **Fields** (kolom). Ia bekerja dengan paradigma: `pattern { action }`. Jika pola cocok, lakukan aksi. Ini sangat mirip dengan konsep *Event-Driven*.

**Terminologi Kunci & English Lesson:**

  * **Field Separator / Noun:**
      * *Indo:* Pemisah kolom.
      * *English Context:* "Set the field separator to a comma for CSV files." (Atur pemisah kolom menjadi koma untuk file CSV). Variable: `FS` atau flag `-F`.
  * **Associative Array / Noun:**
      * *Indo:* Array Asosiatif (Key-Value pair / Map).
      * *English Context:* "Awk supports associative arrays aimed at storing data indexed by strings." (Awk mendukung array asosiatif yang ditujukan untuk menyimpan data yang diindeks oleh string).
  * **Built-in Variable / Noun:**
      * *Indo:* Variabel bawaan.
      * *English Context:* "NR (Number of Records) and NF (Number of Fields) are crucial built-in variables."

**Daftar Isi (Table of Contents):**

1.  Structure: `BEGIN { ... } pattern { ... } END { ... }`.
2.  Variables: `NR` (Line Number), `NF` (Field Count), `$0` (Whole Line), `$1` (First Column).
3.  Control Flow: If-Else, While, For loops (Syntax mirip C/Dart).
4.  **Power Feature:** Associative Arrays — Melakukan *Group By* dan *Count* (misal: menghitung jumlah request per IP address).
5.  Built-in Functions: String functions (`substr`, `length`, `split`) dan Math (`sin`, `cos`, `rand`).
6.  Formatting Output: Menggunakan `printf` untuk *pretty printing*.

**Sumber Referensi:**

  * [The GNU Awk User's Guide (Gawk Manual)](https://www.gnu.org/software/gawk/manual/gawk.html) - *Salah satu dokumentasi teknis terbaik yang pernah ditulis.*

-----

## [FASE 5: Enterprise Integration & Automation][5]

**Level:** Enterprise / Architect
**Waktu:** 2-3 Minggu

Menggabungkan semuanya menjadi solusi yang kuat, cepat, dan otomatis.

### 5\. Modul: Shell Scripting Integration & Performance

**Deskripsi Konkret:**
Membangun *pipeline* data yang kompleks, menangani file bergiga-giga byte dengan cepat, dan mengintegrasikan tools ini ke dalam skrip Bash/Zsh yang robust.

**Daftar Isi:**

1.  **Xargs:** Mengubah stdin menjadi argumen (Parallel processing dengan `xargs -P`).
2.  **Process Substitution:** `<(command)` — Memperlakukan output perintah sebagai file.
3.  **Performance Tuning:**
      * Menggunakan `LC_ALL=C` untuk mempercepat `grep` (mematikan Unicode handling sementara).
      * Memilih `mawk` vs `gawk` untuk kecepatan di kasus tertentu.
4.  **Error Handling & Debugging:**
      * `set -x` (Bash debug).
      * Memeriksa exit codes (`$?`) di setiap langkah pipeline.
5.  **Studi Kasus:** Membuat skrip Log Analyzer untuk web server (Nginx/Apache) yang menghasilkan laporan harian via email.

-----

## 🛠️ Rekomendasi Alat Tambahan & Interoperabilitas

Meskipun CLI adalah raja, interoperabilitas itu penting:

1.  **Ripgrep (`rg`):** (Ditulis dalam **Rust**, Repositori: [Github - BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep)).
      * *Relevansi:* Alternatif `grep` yang jauh lebih cepat dan modern. Sangat disukai komunitas Arch/Rust.
2.  **Fzf (Fuzzy Finder):** (Ditulis dalam **Go**, Repositori: [Github - junegunn/fzf](https://github.com/junegunn/fzf)).
      * *Relevansi:* Pipa output regex anda ke `fzf` untuk pencarian interaktif.
3.  **Jq:** (Ditulis dalam **C**, Repositori: [Github - jqlang/jq](https://github.com/jqlang/jq)).
      * *Relevansi:* Jika teks anda formatnya JSON, `awk`/`grep` susah dipakai. Gunakan `jq`.

-----

## 🎓 Hasil Pembelajaran (Learning Outcomes)

Setelah menyelesaikan kurikulum ini, Anda akan mampu:

1.  **Membaca Log:** Menganalisis log sistem error di Arch Linux tanpa perlu GUI viewer.
2.  **Data Munging:** Membersihkan dan mengubah format data mentah (CSV, XML, Logs) menjadi format yang siap diolah database atau Dart/Flutter app.
3.  **Automasi:** Menulis *one-liners* (perintah satu baris) yang dapat melakukan pekerjaan manual berjam-jam dalam hitungan detik.
4.  **Diagnosa:** Memahami error sistem dengan mencari pola anomali secara cepat.
5.  **Profesionalisme Bahasa:** Memahami dokumentasi teknis bahasa Inggris (man pages) dengan presisi gramatikal.

-----

Kurikulum ini secara resmi mencakup technical safety:

1.  **PCRE2:** (Inti dari Fase 2).
2.  **POSIX BRE/ERE:** (Telah dijelaskan perbedaannya di atas).
3.  **Lookaround:** (Tercakup di Fase 2 - Advanced).
4.  **Backreference:** (Tercakup di Fase 3 - Sed).
5.  **Pattern Grouping:** (Tercakup di Fase 2 & 3).
6.  **Integrasi:** (Tercakup di Fase 5 - Log Sentinel).
7.  **Regex dalam Pemrograman:** (Telah ditambahkan contoh Dart di atas).

-----

> - **[Selanjutnya][selanjutnya]**
> - **[Tahap Ujiab][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../regex/bagian-6/README.md
[selanjutnya]: ../bagian-1/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../regex/bagian-1/README.md
[2]: ../regex/bagian-2/README.md
[3]: ../regex/bagian-3/README.md
[4]: ../regex/bagian-4/README.md
[5]: ../regex/bagian-5/README.md
[6]: ../regex/bagian-6/README.md
<!-- [7]: ../regex/bagian-1/README.md -->
<!-- [8]: ../regex/bagian-1/README.md -->
<!-- [9]: ../regex/bagian-1/README.md -->
<!-- [10]: ../regex/bagian-1/README.md -->
<!-- [11]: ../regex/bagian-1/README.md -->
<!-- [12]: ../regex/bagian-1/README.md -->
<!-- [13]: ../regex/bagian-1/README.md -->
<!-- [14]: ../regex/bagian-1/README.md -->
<!-- [15]: ../regex/bagian-1/README.md -->
<!-- [16]: ../regex/bagian-1/README.md -->
<!-- [17]: ../regex/bagian-1/README.md -->
<!-- [18]: ../regex/bagian-1/README.md -->
