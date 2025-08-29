# 📘 Regular Expressions (Regex)

## 🔹 Definisi

**Regular Expressions (regex)** adalah sebuah _pattern-matching syntax_ yang digunakan untuk mencocokkan, mencari, dan memanipulasi teks berdasarkan pola tertentu. Regex banyak digunakan dalam proses parsing, validasi input, pencarian dan penggantian teks, serta analisis data berbasis teks.

---

## 🔹 Struktur Umum

```regex
/pola/
```

Regex bekerja dengan mencocokkan pola terhadap string. Pola ini dapat terdiri dari karakter literal, karakter khusus (_metacharacters_), dan _quantifiers_.

---

## 🔹 Karakter Dasar (Literal Characters)

Literal adalah karakter biasa yang dicocokkan secara langsung:

```regex
hello    # Mencocokkan teks "hello"
```

---

## 🔹 Metacharacters

Metakarakter memiliki arti khusus dalam regex:

| Karakter | Arti                                                           |                            |
| -------- | -------------------------------------------------------------- | -------------------------- |
| `.`      | Mencocokkan **sembarang satu karakter** kecuali newline        |                            |
| `^`      | Menandai **awal string**                                       |                            |
| `$`      | Menandai **akhir string**                                      |                            |
| `*`      | Mencocokkan **0 atau lebih** karakter sebelumnya               |                            |
| `+`      | Mencocokkan **1 atau lebih** karakter sebelumnya               |                            |
| `?`      | Mencocokkan **0 atau 1** karakter sebelumnya (opsional)        |                            |
| \`       | \`                                                             | Operator **OR** antar pola |
| `()`     | Menandai **grouping**                                          |                            |
| `[]`     | Menandai **character class**                                   |                            |
| `\`      | **Escape character**, membuat karakter spesial menjadi literal |                            |

---

## 🔹 Character Classes

Karakter dalam `[]` mewakili **set karakter** yang dapat dicocokkan.

```regex
[aeiou]     # Mencocokkan salah satu huruf vokal
[0-9]       # Mencocokkan digit 0 hingga 9
[a-zA-Z_]   # Mencocokkan huruf alfabet dan garis bawah
[^abc]      # Mencocokkan karakter selain a, b, atau c
```

---

## 🔹 Predefined Character Classes

| Notasi | Arti                            |
| ------ | ------------------------------- |
| `\d`   | Digit (`[0-9]`)                 |
| `\D`   | Bukan digit (`[^0-9]`)          |
| `\w`   | Word character (`[a-zA-Z0-9_]`) |
| `\W`   | Non-word character              |
| `\s`   | Spasi (space, tab, newline)     |
| `\S`   | Non-spasi                       |

---

## 🔹 Quantifiers

Digunakan untuk menentukan jumlah pengulangan:

| Notasi  | Arti                   |
| ------- | ---------------------- |
| `*`     | 0 atau lebih           |
| `+`     | 1 atau lebih           |
| `?`     | 0 atau 1               |
| `{n}`   | Tepat n kali           |
| `{n,}`  | Minimal n kali         |
| `{n,m}` | Antara n hingga m kali |

Contoh:

```regex
a{3}     # Mencocokkan "aaa"
b{1,3}   # Mencocokkan "b", "bb", atau "bbb"
```

---

## 🔹 Grouping & Capturing

- `()` digunakan untuk membuat **grup** dan menangkap bagian string.
- Grup bisa diberi nama: `(?<nama>pattern)`

Contoh:

```regex
(\d{4})-(\d{2})-(\d{2})
# Mencocokkan format tanggal YYYY-MM-DD
```

---

## 🔹 Alternation (OR)

```regex
(cat|dog)    # Mencocokkan "cat" atau "dog"
```

---

## 🔹 Anchors (Penanda Posisi)

| Notasi | Arti                       |
| ------ | -------------------------- |
| `^`    | Awal string/baris          |
| `$`    | Akhir string/baris         |
| `\b`   | Word boundary (batas kata) |
| `\B`   | Non-word boundary          |

Contoh:

```regex
^\d+$    # String yang hanya terdiri dari digit (tanpa spasi)
\bword\b # Cocokkan kata "word" sebagai kata utuh
```

---

## 🔹 Flags (Modifikasi Perilaku Regex)

Beberapa implementasi regex (seperti dalam JavaScript, Python, Dart) mendukung flag seperti:

| Flag | Arti                                            |
| ---- | ----------------------------------------------- |
| `i`  | Case-insensitive (abaikan kapital)              |
| `g`  | Global search (semua kecocokan)                 |
| `m`  | Multi-line mode (`^` dan `$` berlaku per baris) |
| `s`  | Dot-all mode (`.` mencocokkan newline)          |

Contoh (JavaScript-style):

```regex
/hello/i     # Mencocokkan "hello", "Hello", "HELLO", dst.
```

---

## 🔹 Contoh Penggunaan Regex

### 1. Validasi Email

```regex
^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$
```

### 2. Nomor Telepon Indonesia (simplified)

```regex
^(\+62|0)8[1-9][0-9]{6,9}$
```

### 3. Cek apakah string hanya angka

```regex
^\d+$
```

---

## 🔹 Tips Umum

- Gunakan tool seperti **regex101.com** untuk mengetes regex.
- Selalu escape karakter spesial jika ingin mencocokkan literal (`\.` untuk titik).
- Regex bersifat **greedy** secara default (mengambil sebanyak mungkin karakter).
- Untuk mode **non-greedy**, gunakan `*?`, `+?`, dll.

---

## 🔹 Kesimpulan

Regular expressions adalah alat powerful untuk pencocokan pola dalam teks. Meskipun sintaksnya tampak kompleks di awal, regex sangat fleksibel dan menjadi alat wajib untuk pemrosesan teks tingkat lanjut. Pelajari secara bertahap, gunakan dokumentasi atau visualizer saat membuat pattern yang kompleks.

---

**[Home][1]**
**[Kamus][1]**

[1]: ../../domain-spesifik/README.md
[2]:../../kamus/README.md
