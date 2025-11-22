# Berikut penjelasan lengkapnya

```bash
grep -P "10*1" text.txt
```

---

## 1 — Penjelasan komponen perintah

| Bagian     | Arti                                                                                                  |
| ---------- | ----------------------------------------------------------------------------------------------------- |
| `grep`     | Program pencarian teks berbasis pola (regex). Biasanya GNU grep, ditulis dalam bahasa C               |
| `-P`       | Gunakan **PCRE** (Perl Compatible Regular Expressions), sehingga sintaks regex mengikuti standar Perl |
| `"10*1"`   | Pola regex yang akan dicocokkan                                                                       |
| `text.txt` | File yang menjadi target pencarian                                                                    |

---

## 2 — Penjelasan pola **"10*1"**

Mari uraikan karakter per karakter:

| Simbol | Nama                                  | Fungsi                                                                    |
| ------ | ------------------------------------- | ------------------------------------------------------------------------- |
| `1`    | literal karakter '1'                  | Harus cocok dengan angka 1                                                |
| `0*`   | karakter literal `0` + kuantifier `*` | `*` artinya: ulangi **0 atau lebih kali** karakter sebelumnya (yaitu `0`) |
| `1`    | literal karakter '1'                  | Setelah rangkaian nol, harus diikuti angka 1                              |

Sehingga pola ini berarti:

> Cocokkan **angka 1**, lalu **nol atau lebih** angka 0, lalu **angka 1**.

Dengan kata lain:
Cocok terhadap string mirip pola:

```
11
101
1001
10001
100001
… dan seterusnya
```

---

## 3 — Contoh isi file `text.txt`

Misalkan:

```
101
1001
0001
11
123
10001
1
10101
```

### Perintah:

```bash
grep -P "10*1" text.txt
```

### Output yang cocok:

```
101
1001
11
10001
10101
```

### Penjelasan setiap kecocokan:

| Baris   | Cocok? | Alasan                                         |
| ------- | ------ | ---------------------------------------------- |
| `101`   | Ya     | 1 + 0* + 1 → (1)(0)(1)                         |
| `1001`  | Ya     | (1)(00)(1)                                     |
| `0001`  | Tidak  | Tidak dimulai dengan 1                         |
| `11`    | Ya     | (1)(0 diperbolehkan 0 kali)(1)                 |
| `123`   | Tidak  | tidak ada pola 1…1 dengan nol ditengah         |
| `10001` | Ya     | (1)(000)(1)                                    |
| `1`     | Tidak  | Tidak ada 1 kedua di akhir                     |
| `10101` | Ya     | Di dalam string ada substring `101` yang cocok |

---

## 4 — Kesalahpahaman umum

Banyak orang menyangka `10*1` berarti “angka 10 sampai 1” atau “10 dikali 1”
Ini **bukan operasi matematika**, tetapi regex.

---

## 5 — Versi yang lebih eksplisit dengan batas kata

Agar hanya cocok bila **kata penuh** berupa IP segment contoh tertentu:

```bash
grep -P '\b10*1\b' text.txt
```

`\b` = boundary (pembatas kata).
Jadi `10101` tidak akan diambil karena match hanya sebagai substring.

---

## 6 — Contoh pola lain yang relevan

| Regex      | Artinya                 | Contoh cocok                           |                 |
| ---------- | ----------------------- | -------------------------------------- | --------------- |
| `10+1`     | + = minimal 1 nol       | 101, 1001, 10001                       |                 |
| `10{2}1`   | tepat 2 nol             | 1001                                   |                 |
| `10{2,4}1` | 2 hingga 4 nol          | 1001, 10001, 100001                    |                 |
| `1(0       | 1)+1`                   | nol atau satu, 1 kali atau lebih       | 101, 111, 10101 |
| `^10*1$`   | match **seluruh baris** | hanya baris yang persis 101, 1001, dll |                 |

Contoh penggunaan:

```bash
grep -P "^10+1$" text.txt
```

`^` dan `$` memastikan seluruh baris harus mengikuti pola — bukan sekadar substring.

---

## 7 — Bantuan & debugging regex

Jika ragu, gunakan alat bantu seperti:

```bash
man grep
grep --help
```

Untuk uji regex lebih cepat:
Gunakan tool CLI `pcregrep` atau online tester **PCRE** (bukan ERE/ERE biasa).

---

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
