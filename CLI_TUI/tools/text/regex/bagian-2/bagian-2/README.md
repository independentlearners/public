# Berikut penjelasan lengkap dan teknis

```bash
grep -P "Go+gle" text.txt
```

---

## 1 — Penjelasan komponen perintah

| Bagian     | Fungsi                                                     |
| ---------- | ---------------------------------------------------------- |
| `grep`     | Mencari pola teks                                          |
| `-P`       | Menggunakan **PCRE** (Perl Compatible Regular Expressions) |
| `"Go+gle"` | Pola regex                                                 |
| `text.txt` | File target untuk pencarian                                |

---

## 2 — Penjelasan regex karakter-per-karakter

Regex:

```
Go+gle
```

Uraiannya:

| Token | Arti                       | Fungsi                                          |
| ----- | -------------------------- | ----------------------------------------------- |
| `G`   | literal                    | Harus ada huruf kapital G                       |
| `o+`  | literal o + kuantifier `+` | `o` harus muncul **minimal 1 kali**, bisa lebih |
| `g`   | literal                    | Diikuti huruf g                                 |
| `l`   | literal                    | Diikuti huruf l                                 |
| `e`   | literal                    | Diakhiri huruf e                                |

Makna keseluruhan:

> Mencocokkan "Gogle", "Google", "Goooogle", dan variasi sejenis
> dengan **minimal satu huruf o**, tidak terbatas maksimal

Bentuk cocok:

```
Gogle
Google
Goooogle
Gooooooooooogle
```

---

## 3 — Contoh isi `text.txt`

```
Gogle
Google
Goooogle
Googles
Ggl
google
Goooooooooogle rocks
Gleen
```

Perintah:

```bash
grep -P "Go+gle" text.txt
```

Output:

```
Gogle
Google
Goooogle
Goooooooooogle rocks
```

Penjelasan:

| Baris                | Cocok? | Alasan                                          |
| -------------------- | ------ | ----------------------------------------------- |
| Gogle                | Ya     | `o` muncul 1 kali                               |
| Google               | Ya     | `o` muncul 2 kali                               |
| Goooogle             | Ya     | `o` muncul > 2 kali                             |
| Googles              | Tidak  | Ada huruf `s` setelah `e`, regex tidak mewadahi |
| Ggl                  | Tidak  | Tidak ada `o`                                   |
| google               | Tidak  | Huruf kecil `g` → case mismatch tanpa `-i`      |
| Goooooooooogle rocks | Ya     | Ada substring yang cocok di awal                |
| Gleen                | Tidak  | Tidak ada pola                                  |

---

## 4 — Jika ingin seluruh kata (bukan hanya substring)

Gunakan batas kata `\b`:

```bash
grep -P '\bGo+gle\b' text.txt
```

Maka `Goooooooooogle rocks` tidak akan cocok
karena pola tidak berdiri sebagai kata utuh.

---

## 5 — Jika ingin case-insensitive

```bash
grep -Pi "Go+gle" text.txt
```

`-i` = abaikan besar-kecil huruf
Maka `google` juga ikut cocok.

---

## 6 — Contoh variasi lanjutan

| Regex        | Arti                   | Contoh cocok        |                         |
| ------------ | ---------------------- | ------------------- | ----------------------- |
| `Go*gle`     | `*` = 0 atau lebih `o` | Ggle, Gogle, Google |                         |
| `Go{2}gle`   | tepat 2 huruf o        | Google              |                         |
| `Go{2,4}gle` | 2–4 huruf o            | Google, Goooogle    |                         |
| `G(o         | 0)+gle`                | `o` atau angka `0`  | Google, G0ogle, Go0ogle |

Contoh pemakaian:

```bash
grep -P 'G(o|0)+gle' text.txt
```

---

## 7 — Referensi kuantifier terkait

| Simbol  | Nama           | Makna             |
| ------- | -------------- | ----------------- |
| `?`     | optional       | 0 atau 1 kali     |
| `*`     | kleene star    | 0 atau lebih kali |
| `+`     | kleene plus    | 1 atau lebih kali |
| `{n}`   | exact count    | tepat n kali      |
| `{n,}`  | minimal n kali | ≥ n kali          |
| `{n,m}` | rentang        | n hingga m kali   |

`+` pada pola diatas = **minimal satu `o`**.

---

## 8 — Dokumentasi bantuan

| Perintah      | Fungsi               |
| ------------- | -------------------- |
| `man grep`    | Manual grep lengkap  |
| `grep --help` | Ringkasan opsi       |
| `man 7 regex` | Referensi umum regex |

---

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
