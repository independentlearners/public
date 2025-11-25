# Panduan lengkap & praktis:

Mengenai hal-hal yang perlu diperhatikan saat bekerja dengan **regular expressions (regex)** — khusus untuk menangani karakter/simbol membingungkan.

---

## Inti ringkas (apa yang harus diingat sebelum menulis regex)

1. **Pahami engine regex**: PCRE, ECMAScript (JS), Python `re` vs `regex` (PyPI), POSIX BRE/ERE — sintaks dan fitur (lookaround, `\p{...}`, possessive quantifier, atomic group) *berbeda*.
2. **Escape vs literal**: banyak simbol punya makna khusus (`. ^ $ * + ? () [] { } | \`) — bila ingin "karakter biasa", *escape* dengan `\` (atau gunakan kelas karakter/quoting engine).
3. **Context dua lapis**: shell / string literal → bahasa → engine. Anda sering perlu **double escaping**.
4. **Unicode & normalization**: teks Unicode punya kombinasi (NFC/NFD). Untuk mencocokkan *glyph* yang terlihat sama, periksa normalisasi atau gunakan grapheme cluster (`\X`) bila engine mendukung.
5. **Performance & safety**: pola tertentu menyebabkan *catastrophic backtracking* — gunakan quantifier yang lebih ketat, atomic groups, possessive quantifiers, atau refactor pola.
6. **Testing**: selalu uji pada dataset nyata, gunakan alat seperti `regex101`, `ripgrep` (`rg`), `pcretest`, atau unit tests.

---

## 1) Simbol “membingungkan” dan cara menanganinya (daftar & aturan cepat)

* `\` (backslash) — *escape character*. Untuk mencocokkan backslash literal, gunakan `\\` pada level regex; di shell atau string literal biasanya jadi `\\\\` (lihat contoh di bawah).
* `.` — matches *sebarang karakter kecuali newline* (kecuali DOTALL). Untuk literal, pakai `\.`.
* `^` dan `$` — batas baris/teks (anchor). Dalam mode multiline (`m`), ^ dan $ berlaku per baris.
* `[]` — kelas karakter. Di dalamnya `-` adalah rentang (`a-z`); letakkan `-` di awal/akhir atau escape `\-` bila ingin literal. `^` di awal kelas berarti *negasi*.
* `()` — kelompok (grouping); default menangkap (capturing). Untuk non-capturing gunakan `(?:...)`.
* `{m,n}` — quantifier range. `{3}` = tepat 3, `{2,}` = 2 atau lebih. `{,3}` tidak valid di beberapa engine (sebaiknya `{0,3}`).
* `* + ?` — quantifier (0+, 1+, 0-1). Mereka **serakah (greedy)** default; tambahkan `?` untuk membuatnya *lazy* (mis. `.*?`).
* `|` — alternation (OR). Ingat prioritas: gunakan grup untuk mengontrol urutan.
* `\b` vs `\B` — word boundary / not boundary. Untuk Unicode-aware word boundaries kadang berbeda antar engine.
* `\d \w \s` — shorthand classes (digit, wordchar, whitespace). Dalam Unicode-aware engines, `\w` dapat mencakup banyak karakter non-ASCII.
* `\p{...}` — properti Unicode (huruf, angka, script). Dukungan bergantung engine (PCRE, .NET, Perl, Python `regex`, JS recent with `u` flag).
* Zero-width assertions: `(?=...)` lookahead, `(?<=...)` lookbehind (beberapa engine memiliki batasan panjang lookbehind).

---

## 2) Escape & konteks: **double escaping** (penjelasan per-kata pada contoh nyata)

### Contoh: cari **satu backslash** literal di file menggunakan `grep -P` pada shell (bash/zsh)

Perintah:

```bash
grep -P '\\\\' file.txt
```

Penjelasan *kata-per-kata*:

* `grep` → program GNU `grep`.
* `-P` → flag: gunakan **Perl Compatible Regular Expressions (PCRE)** sebagai engine.
* `'\\\\'` → argumen pola, dibungkus single quotes:

  * di dalam single quotes, shell **tidak** men-escape apa pun; isi dikirim literal ke program. Jadi `'\\\\'` berisi empat karakter backslash (`\ \ \ \`).
  * PCRE menerima `\\\\` → PCRE memproses escape berpasangan: `\\` → literal `\`. Karena ada empat, PCRE melihat dua pasangan `\\` `\\` → yang masing-masing menjadi satu literal `\`? *Namun* PCRE membaca pola `\\\\` sebagai meminta mencocokkan *dua* backslash berurutan. Untuk satu backslash literal, pola PCRE yang diharapkan adalah `\\` (dua). Oleh karena itu, agar grep menerima `\\`, shell harus diberikan `\\\\` (empat) sehingga program menerima dua backslash.
  * ringkas: `'\\\\'` → shell pass `\\\\` → engine membaca `\\` → cocokkan *satu* backslash.
* `file.txt` → nama file input.

> Catatan praktis: untuk menghindari kebingungan, sering gunakan single quotes lalu pikirkan: “berapa banyak backslash harus dikirim ke engine?” — untuk satu literal `\` kebanyakan alat membutuhkan `\\\\` pada command line.

### Contoh: cari literal `.` dengan `rg` (ripgrep)

Perintah:

```bash
rg '\.' /path/to/dir
```

Penjelasan:

* `rg` → ripgrep (faster grep).
* `'\.'` → pola: backslash + dot di dalam single quotes. Shell mengirim `\.` literal; engine mengartikan `\.` sebagai *literal dot*.
* `/path/to/dir` → target direktori.

---

## 3) Contoh umum + penjelasan token demi token

### A. Mencari alamat email sederhana (tidak sempurna tapi praktis)

Regex:

```
\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b
```

Penjelasan token:

* `\b` → word boundary (awal kata).
* `[A-Za-z0-9._%+-]+` → karakter lokal email: satu atau lebih dari set huruf besar/kecil, digit, titik, underscore, `%`, `+`, `-`.

  * `[]` = character class.
  * `A-Za-z` = rentang A–Z dan a–z.
  * `0-9` = digit.
  * `_ . % + -` = karakter literal dalam kelas.
  * `+` setelah `]` = quantifier “1 atau lebih”.
* `@` → literal `@`.
* `[A-Za-z0-9.-]+` → domain label (sederhana).
* `\.` → literal dot sebelum TLD.
* `[A-Za-z]{2,}` → TLD minimal 2 huruf.
* `\b` → word boundary (akhir kata).

Catatan: untuk validasi email produksi gunakan parser/validator khusus; regex ini berguna untuk ekstraksi sederhana.

---

### B. Tangani newline vs dot: `s` / DOTALL

Regex (PCRE/Python `re.S`):

```
(?s)<div class="content">.*?</div>
```

Token:

* `(?s)` → inline flag: nyalakan DOTALL sehingga `.` mencocokkan newline juga.
* `<div class="content">` → literal HTML start tag.
* `.*?` → `.` (any char incl newline karena `s`), `*` (0+), `?` membuat quantifier *lazy* (ambil paling sedikit) — mencegah mencocokkan terlalu jauh.
* `</div>` → literal close tag.

---

### C. Avoid catastrophic backtracking — contoh masalah dan perbaikan

Masalah:

```
^(a+)+b
```

Pada input panjang `a...a` tanpa `b` akan membuat *backtracking* eksplosif.

Perbaikan (PCRE): pakai atomic group:

```
^(?>a+)+b
```

Penjelasan:

* `(? > ... )` — atomic group: engine tidak akan backtrack ke dalamnya setelah cocok; menghindari eksplosi.

Alternatif lain: ubah pola logika agar deterministik, atau gunakan possessive quantifier (`a++`) bila didukung.

---

## 4) Perbedaan engine penting (singkat tapi krusial)

* **PCRE / Perl** — sangat kaya; dukungan `(?<=)`, `(?<! )`, `(?| )`, `\p{…}`, possessive quantifiers (`++`, `?+`), atomic groups. Banyak CLI tool (`pcregrep`, `grep -P` jika build mendukung).
* **ECMAScript (JS)** — semakin kuat: lookbehind baru didukung di engine modern; `\p{…}` hanya dengan flag `u` dan engine modern. Tidak semua browser lama mendukung.
* **Python `re`** — fitur cukup lengkap; tidak mendukung `\p{}`; gunakan `regex` module (PyPI) untuk `\p` dan fitur tambahan. Python 3 `re` default Unicode-aware.
* **POSIX BRE/ERE (classic grep/sed/awk)** — lebih terbatas; mis. `\{m,n\}` penanganan berbeda; lookahead/lookbehind tidak tersedia. Gunakan PCRE jika butuh fitur canggih.

---

## 5) Praktik terbaik (checklist sebelum menulis pola)

1. **Tentukan engine** yang akan dipakai (PCRE/JS/Python/etc).
2. **Tulis contoh input** nyata (edge cases: tabs, CRLF, non-ASCII, combining marks).
3. **Normalisasi Unicode** kalau bekerja dengan teks internasional (`NFC` biasanya).
4. **Escape semua literal khusus** atau gunakan `\Q...\E` jika engine mendukung, atau fungsi quoting dalam bahasa (`re.escape()` di Python).
5. **Gunakan raw strings** bila tersedia (Python `r'...'`) untuk mengurangi double escaping.
6. **Batasi quantifier** (pakai `+?`, `{m,n}`) jika memungkinkan.
7. **Uji performa** pada dataset besar; perhatikan pola yang mengandung nested quantifier `(.*.*)` atau `(a+)+`.
8. **Buat unit tests** untuk semua kasus, termasuk kasus gagal (negative tests).

---

## 6) Debugging & alat bantu

* **regex101.com** — interaktif (PCRE / ECMAScript / Python flavor), jelaskan token, dan tester.
* **rgrep / ripgrep (`rg`)** — cepat untuk searching di repo; dukung PCRE2 dengan `-P`? (periksa build).
* **pcretest / pcre2test** — untuk menguji PCRE.
* **Perl**: `perl -ne 'print if /pattern/' file` — gunakan `-Mre=debug` untuk debug regex (Perl).
* **Python**: `python - <<'PY'\nimport re\np=re.compile(r'...')\nprint(p.findall(open("file").read()))\nPY`
* **Unit tests**: framework bahasa (pytest, unittest, etc.) untuk memastikan tidak regrese.

---

## 7) Contoh perintah di lingkungan Arch Linux (instalasi & penjelasan kata-per-kata)

Perintah instalasi ripgrep dan pcre2 (Arch):

```bash
sudo pacman -Syu ripgrep pcre2
```

Penjelasan:

* `sudo` → jalankan perintah sebagai superuser.
* `pacman` → package manager Arch Linux.
* `-Syu` → opsi: `-S` sync/install paket, `-y` refresh database paket, `-u` upgrade sistem.
* `ripgrep` `pcre2` → nama paket yang akan diinstall.

Perintah cari dengan `rg` (ripgrep) mencari literal `a.b` (titik literal):

```bash
rg '\a\.b' /path
```

(Tegaskan: contoh ini untuk menunjukkan escaping dot; sesuaikan pola Anda.)

---

## 8) Unicode: grapheme vs codepoint vs normalization (singkat tapi penting)

* **Codepoint**: unit Unicode (mis. U+00E9).
* **Grapheme cluster**: apa yang dilihat pengguna sebagai “karakter” (mis. `e + ´` bisa menjadi satu grapheme).
* **Normalisasi**: NFC (compose), NFD (decompose). Jika teks berasal dari berbagai sumber, normalisasikan sebelum regex. Di Python: `unicodedata.normalize('NFC', s)`.
* **Engine support**: gunakan `\X` (grapheme cluster) jika tersedia atau library khusus.

---

## 9) Menangani non-printable & kontrol character

* Gunakan `\s` untuk whitespace (termasuk `\t`, `\n`, `\r`) — periksa definisi engine.
* Untuk kontrol byte: gunakan hex `\xNN` (mis. `\x0A` = LF) atau Unicode `\uXXXX`/`\x{...}` (engine mendukungnya).
* Untuk pola tingkat byte (binary data), gunakan tools yang bekerja di level byte (Perl, `xxd` + perl, atau `grep -U`).

---

## 10) Contoh kompleks: escape arbitrary user input (selalu aman)

Jika Anda akan menyisipkan input pengguna ke dalam regex, **escape** dulu:

* Python:

```python
import re
user = input_str
pattern = re.escape(user)  # escape tiap karakter khusus
regex = re.compile(pattern)
```

Penjelasan:

* `re.escape()` menjadikan semua karakter yang berpotensi bermakna di regex menjadi literal.

---

## 11) Checklist konfigurasi & persiapan untuk dapat memodifikasi / mengembangkan regex

1. **Kenali bahasa/engine** yang dipakai oleh aplikasi target (JS di browser? Backend Python? CLI grep?).
2. **Siapkan tooling**: `ripgrep`, `pcre2`, `pcregrep`, `perl`, `python` (+ `regex` module), `regex101`.
3. **Pelajari rules escaping** untuk shell + language string literal (bash, zsh, PowerShell berbeda).
4. **Siapkan test suite** (unit tests, contoh file) dan dataset dengan edge cases.
5. **Pelajari Unicode basics** (NFC/NFD, grapheme cluster) bila bekerja dengan teks internasional.
6. **Baca dokumentasi engine** (PCRE manual, MDN RegExp, Python `re` docs).

---

## 12) Tips lanjutan untuk performa & maintainability

* Hindari backtracking eksplosif: jangan gabungkan `.*` atau `.+` secara nesting tanpa batas.
* Gunakan anchoring (`^`, `$`) bila memungkinkan untuk memotong pencarian.
* Gunakan non-capturing groups `(?:...)` bila Anda tidak perlu menangkap—lebih efisien.
* Komentar pola panjang (beberapa engine mendukung `x` flag / verbose mode) untuk keterbacaan.
* Jika pola terlalu kompleks, pertimbangkan parser/lexer daripada regex (mis. HTML, JSON).

---

## 13) Referensi & bacaan lanjut (rekomendasi sumber resmi)

> Jika Anda ingin, saya dapat mengambil link langsung/halaman dokumentasi terbaru. Untuk sekarang, berikut nama sumber yang sangat berguna — cari nama-nama ini (atau minta saya ambil linknya):

1. **PCRE / PCRE2 manual** — dokumentasi resmi untuk fitur-fitur Perl-compatible regex.
2. **MDN Web Docs: Regular expressions (JavaScript)** — penjelasan tentang RegExp di browser dan `\p{}` / `u` flag.
3. **Python `re` module documentation** (docs.python.org) dan package **`regex` (PyPI)** untuk fitur tambahan.
4. **Unicode Standard Annex #29 (Text Segmentation)** — penjelasan grapheme cluster, word boundaries.
5. **regex101.com** — tester interaktif (flavor pilih: PCRE, ECMAScript, Python).
6. **ripgrep (rg) documentation** dan **GNU grep manual** (perbedaan flag dan opsi).
7. Buku/Artikel: “Mastering Regular Expressions” (Friedl) — referensi mendalam tentang perilaku engine dan optimisasi.

---

## 14) Ringkasan praktis + langkah selanjutnya yang saya rekomendasikan

* Mulai dari: tentukan engine → buat test cases → tulis pola sederhana → escape input → uji performa.
* Jika Anda ingin, saya bisa:

  1. Menyusun pola regex untuk kasus spesifik Anda (berikan contoh input & output yang diinginkan).
  2. Menyediakan perintah shell `rg/grep/perl/python` yang siap pakai, lengkap penjelasan token-per-token sesuai preferensi Anda.
  3. Mengambil link dokumentasi resmi untuk sumber-sumber yang tercantum di atas (saya akan browsing dan sertakan link & ringkasan).

---


> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-6/README.md
[selanjutnya]: ../bagian-8/README.md

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
