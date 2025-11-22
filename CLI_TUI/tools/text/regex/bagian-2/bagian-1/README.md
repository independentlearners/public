# Berikut penjelasan lengkap dan teknis

```bash
grep -P "colou?r" text.txt
```

---

## 1 — Uraian perintah

| Bagian      | Fungsi                                                 |
| ----------- | ------------------------------------------------------ |
| `grep`      | Mencari pola teks dengan regex                         |
| `-P`        | Gunakan **PCRE** (Perl Compatible Regular Expressions) |
| `"colou?r"` | Pola regex                                             |
| `text.txt`  | File yang menjadi target pencarian                     |

---

## 2 — Penjelasan regex karakter per karakter

Regex:

```
colou?r
```

Mari uraikan menjadi token:

| Token | Nama                       | Fungsi                                       |
| ----- | -------------------------- | -------------------------------------------- |
| `c`   | literal c                  | harus cocok huruf c                          |
| `o`   | literal o                  | harus cocok huruf o                          |
| `l`   | literal l                  | harus cocok huruf l                          |
| `o`   | literal o                  | harus cocok huruf o                          |
| `u?`  | literal u + kuantifier `?` | `?` = **opsional**, muncul **0 atau 1 kali** |
| `r`   | literal r                  | harus cocok huruf r                          |

Makna keseluruhan:

> Mencocokkan kata **colour** (British English)
> **atau** kata **color** (American English)

Karena `u` boleh tidak muncul.

---

## 3 — Contoh isi file `text.txt`

```
color
colour
colors
colours
colr
```

Perintah:

```bash
grep -P "colou?r" text.txt
```

Output yang cocok:

```
color
colour
```

Penjelasan:

| Baris     | Cocok? | Alasan                                                |
| --------- | ------ | ----------------------------------------------------- |
| `color`   | Ya     | `u` muncul 0 kali                                     |
| `colour`  | Ya     | `u` muncul 1 kali                                     |
| `colors`  | Tidak  | Ada `s` setelah `r` → regex menghentikan match di `r` |
| `colours` | Tidak  | Sama: match tidak mencakup huruf `s` setelah `r`      |
| `colr`    | Tidak  | Kurang `o` sebelum `u?`                               |

---

## 4 — Apabila ingin mencocokkan bentuk jamak juga

Tambahkan `s?` di akhir:

```bash
grep -P "colou?rs?" text.txt
```

Maka cocok dengan:

```
color
colour
colors
colours
```

---

## 5 — Jika ingin cocok seluruh kata (bukan substring)

Gunakan batas kata `\b`:

```bash
grep -P '\bcolou?r\b' text.txt
```

Mencegah match terhadap kata lebih panjang seperti `discolouration`.

---

## 6 — Variasi lanjutan dengan regex PCRE

### Case-insensitive

```bash
grep -Pi "colou?r" text.txt
```

`-i` = ignore case → cocok `Color`, `COLOUR`, dst.

### Hanya tampilkan bagian yang match

```bash
grep -oP "colou?r" text.txt
```

`-o` = hanya substring yang cocok, bukan seluruh baris.

### Hitung kemunculan

```bash
grep -oP "colou?r" text.txt | wc -l
```

---

## 7 — Referensi kuantifier yang terkait

| Simbol  | Nama           | Makna           |
| ------- | -------------- | --------------- |
| `?`     | optional       | 0 atau 1 kali   |
| `*`     | kleene star    | 0 atau lebih    |
| `+`     | minimal sekali | 1 atau lebih    |
| `{n}`   | exact          | n kali          |
| `{n,}`  | minimal n kali | ≥ n             |
| `{n,m}` | range          | n sampai m kali |

`?` dalam pola Anda berarti **u** opsional.

---

## 8 — Cara mendapatkan bantuan

| Perintah         | Kegunaan                   |
| ---------------- | -------------------------- |
| `man grep`       | Dokumentasi lengkap grep   |
| `grep --help`    | Ringkasan opsi             |
| `man 7 regex`    | Referensi umum regex POSIX |
| Dokumentasi PCRE | Untuk fitur lanjutan `-P`  |

---

> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

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
