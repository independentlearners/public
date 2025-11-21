# Penjelasan *kata-demi-kata*, *simbol per simbol*, *argumen per argumen* untuk perintah:

```
grep -o "user_[0-9]*" file.txt
```

Penjelasan dilakukan **secara teknis**, **mendalam**, dan sesuai standar dokumentasi *text processing* di Linux.

---

###   1. **`grep`**

**Identitas alat:**

* Nama: `grep` (Globally search a Regular Expression and Print)
* Bahasa sumber: ditulis dalam **C**
* Kategori: **text processing utility**
* Dokumentasi: GNU grep manual (`man grep`, `info grep`)
* Kegunaan: mencari pola teks berbasis regex di dalam file atau input pipeline.

**Cara mendapatkan bantuan:**

* `man grep`
* `grep --help`

---

### 2. **`-o`**

**Nama resmi:** `--only-matching`
**Fungsi:** hanya mencetak **bagian teks yang cocok** dengan pola regex, **bukan seluruh baris**.

Tanpa `-o`, grep menampilkan seluruh baris yang mengandung kecocokan.
Dengan `-o`, yang keluar hanya substring yang match.

---

### 3. **`"user_[0-9]*"`**

Ini adalah **regular expression** sepenuhnya. Kita bedah simbolnya:

#### a. **`"` … `"`**

Menandakan **string literal** dalam shell (double quotes).
Double quotes tetap membiarkan ekspansi seperti `$VAR`, tetapi dalam konteks regex ini tidak ada pengaruh.

---

#### b. **`user_`**

* Literal *string* tepat "user_"
* Tidak ada karakter khusus di sini.
* Grep akan mencari substring yang secara tepat memuat karakter u-s-e-r-underscore.

---

#### c. **`[0-9]`**

**Simbol kelas karakter (character class)**:

* `[...]` adalah kelas karakter.
* `0-9` adalah interval digit.

Artinya: cocokkan **satu karakter** yang merupakan digit **0 sampai 9**.

---

#### d. **`*`**

**Kuantifier** dalam regex: **zero or more** (0 atau lebih).

Berarti:

* `[0-9]*` cocok dengan rangkaian angka (digits) sebanyak 0, 1, atau tak terbatas jumlahnya.

Contoh kecocokan untuk bagian ini:

* "" (kosong — karena *zero*)
* "1"
* "42"
* "90123"
* dan seterusnya.

---

#### e. Gabungan regex lengkap:

`user_` + `[0-9]*` → pola mencocokkan string seperti:

* `user_`
* `user_1`
* `user_42`
* `user_00001`
* `user_123456789`

---

### 4. **`file.txt`**

Nama file yang akan dipindai oleh grep.

Jika file tidak ada → error:
`grep: file.txt: No such file or directory`

---

### 5. Alur Eksekusi Perintah

1. Shell menjalankan program `grep`.
2. Grep membaca file **file.txt**.
3. Grep menerapkan regex **user_[0-9]*** ke setiap baris.
4. Karena `-o`, setiap match dicetak **per match**, satu per baris.
5. Output hanya substring yang cocok → bukan full line.

---

### 6. Contoh Input vs Output

**file.txt:**

```
user_1 logged in.
invalid record.
user_22 performed action.
```

**Perintah:**

```
grep -o "user_[0-9]*" file.txt
```

**Output:**

```
user_1
user_22
```

---
<!---->
<!-- # 7. Konfigurasi & Persyaratan agar bisa memodifikasi grep / regex -->
<!---->
<!-- ##### Jika ingin memodifikasi `grep`: -->
<!---->
<!-- * Bahasa: **C** -->
<!-- * Build tools: -->
<!---->
<!--   * `gcc` -->
<!--   * `make` -->
<!--   * autotools (`autoconf`, `automake`) -->
<!-- * Repository sumber: GNU grep source (https). -->
<!-- * Pengetahuan yang dibutuhkan: -->
<!---->
<!--   * Struktur data dasar (string, buffer) -->
<!--   * POSIX regex engine -->
<!--   * Memory model C -->
<!--   * System call (I/O file) -->
<!-- * Build: -->
<!---->
<!--   ``` -->
<!--   ./configure -->
<!--   make -->
<!--   sudo make install -->
<!--   ``` -->
<!---->
<!-- ### Jika ingin membuat regex engine sendiri: -->
<!---->
<!-- * Harus menguasai: -->
<!---->
<!--   * Finite Automata (NFA, DFA) -->
<!--   * Parsing regex grammar -->
<!--   * Pattern-matching algorithms (Thompson NFA, backtracking) -->
<!--   * Bahasa pemrograman yang dipilih untuk implementasi (C, Rust, Lua, Dart, dll.) -->
<!---->
### Bantuan regex:

* `man 7 regex`
* `info grep`
* GNU grep manual online

---
<!-- Jika Anda ingin, saya bisa lanjutkan dengan: -->
<!---->
<!-- * Versi penjelasan yang lebih teknis lagi per byte/penguraian lexer-regex engine. -->
<!-- * Membandingkan pola ini dengan egrep (`-E`). -->
<!-- * Menjelaskan variasi simbol `[0-9]`, `\d`, `[:digit:]`. -->
<!-- * Membuat cheat sheet regex Linux lengkap. -->
<!---->

[Kembali](../README.md)
