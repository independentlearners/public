# Lesson 05 — Glob / Filename Generation

Kita masuk ke materi berikutnya dalam kurikulum Zsh. Dokumen Beralih Ke Zsh.txt mencantumkan contoh glob `*.txt`, `**/*.lua`, dan `^*.bak`. Kita mulai dari dasar agar Anda memahami bagaimana Zsh mencocokkan nama file sebelum mempelajari pola yang lebih kompleks.

## 05.1 — Apa itu glob?

Glob adalah pola yang digunakan shell untuk mencocokkan nama file atau direktori. Dalam Zsh, proses pencocokan ini disebut filename generation.

Misalnya, direktori Anda berisi:

```
project/
├── main.zsh
├── setup.zsh
├── README.md
├── notes.txt
└── backup.txt
```

Jika Anda menjalankan:

```bash
print -r -- *.zsh
```

Zsh mencocokkan pola `*.zsh` dengan nama file yang sesuai di direktori saat ini.

Hasilnya:

```bash
main.zsh setup.zsh
```

Zsh melakukan pencocokan tersebut sebelum menjalankan `print`. Dengan demikian, `print` menerima nama file hasil pencocokan, bukan pola `*.zsh` itu sendiri.

Alur sederhananya:

```
Perintah yang ditulis
        ↓
Zsh memproses ekspansi
        ↓
Glob mencocokkan nama file
        ↓
Perintah menerima hasil pencocokan
```

## 05.2 — Wildcard dasar

Ada tiga pola yang perlu dipahami terlebih dahulu.

| Pola    | Makna                                                |
| ------- | ---------------------------------------------------- |
| `*`     | Mencocokkan nol atau lebih karakter                  |
| `?`     | Mencocokkan tepat satu karakter                      |
| `[abc]` | Mencocokkan satu karakter dari pilihan yang tersedia |

Contoh berikut mengasumsikan file-file tersebut memang tersedia di direktori saat ini.

```bash
print -r -- *.txt
```

Mencocokkan semua nama yang berakhiran `.txt`.

```bash
print -r -- file?.txt
```

Mencocokkan nama seperti `file1.txt` atau `fileA.txt`, tetapi bukan `file10.txt`, karena `?` hanya mencocokkan satu karakter.

```bash
print -r -- file[12].txt
```

Mencocokkan `file1.txt` dan `file2.txt`, tetapi bukan `file3.txt`.

Penting: glob bukan regular expression (regex). Walaupun ada karakter yang tampak serupa, aturan pencocokannya berbeda.

## 05.3 — Glob tidak selalu mencari ke subdirektori

Pola berikut:

Zsh

```bash
print -r -- *.lua
```

mencari nama yang cocok di direktori saat ini. Pola tersebut tidak secara otomatis menelusuri seluruh subdirektori.

Misalnya:

```
project/
├── main.lua
└── modules/
    └── helper.lua
```

`*.lua` mencocokkan `main.lua`, tetapi tidak mencocokkan `modules/helper.lua`.

Untuk penelusuran rekursif, Zsh menyediakan pola:

Zsh

```bash
print -r -- **/*.lua
```

Pola `**/` dapat mencocokkan direktori bertingkat, sehingga file Lua di dalam subdirektori juga dapat ditemukan.

Namun, hasil pastinya bergantung pada struktur direktori dan aturan glob yang aktif. Jika pola tidak menemukan kecocokan, perilaku default Zsh berbeda dari Bash: Zsh biasanya melaporkan `no matches found` alih-alih meneruskan pola mentah ke perintah.

Jangan mengaktifkan opsi untuk mengubah perilaku tersebut dahulu; kita akan mempelajari Zsh options pada tahap kurikulum yang sesuai.

## 05.4 — Mengecualikan pola dengan `^`

Dokumen kurikulum Anda juga memberikan contoh:

Zsh

```bash
^*.bak
```

Dalam Zsh, pola negasi seperti ini memerlukan opsi `EXTENDED_GLOB`.

Contoh:

Zsh

```bash
setopt EXTENDED_GLOB
print -r -- ^*.bak
```

Secara konseptual, pola tersebut berarti mencocokkan nama yang tidak berakhiran `.bak`.

Misalnya, di direktori terdapat:

```bash
main.zsh
notes.txt
backup.bak
```

Pola `^*.bak` dapat mencocokkan `main.zsh` dan `notes.txt`, tetapi mengecualikan `backup.bak`.

Opsi ini mengubah cara Zsh menafsirkan pola tertentu. Karena itu, kita akan membahas `setopt` dan `EXTENDED_GLOB` lebih sistematis pada Lesson 06. Untuk saat ini, cukup pahami bahwa `^` bukan operator negasi glob yang selalu aktif secara default.


<details>
  <summary>📃  Latihan 05.1</summary>

Soal 1 — Wildcard

Anggap direktori berisi `main.zsh`, `test.zsh`, `notes.txt`, dan `file1.txt`. Nama mana yang cocok dengan `*.zsh`?

Soal 2 — Satu karakter

Dari nama `file1.txt`, `file2.txt`, dan `file10.txt`, mana yang cocok dengan `file?.txt`?

Soal 3 — Rekursi

Apa perbedaan utama antara `*.lua` dan `**/*.lua`?

</details>

## Lesson 05 — Glob / Filename Generation

### 05.2 — Rentang dan kelas karakter

Glob digunakan Zsh untuk mencocokkan nama file atau direktori. Selain `*` dan `?`, kita dapat menggunakan kurung siku `[...]` untuk mencocokkan satu karakter berdasarkan himpunan atau rentang.

Misalkan direktori saat ini berisi:

```
file1.txt
file2.txt
file3.txt
file10.txt
fileA.txt
fileB.txt
```

| Pola            | Hasil yang cocok                                                |
| --------------- | --------------------------------------------------------------- |
| `file[12].txt`  | `file1.txt`, `file2.txt`                                        |
| `file[1-3].txt` | `file1.txt`, `file2.txt`, `file3.txt`                           |
| `file[AB].txt`  | `fileA.txt`, `fileB.txt`                                        |
| `file?.txt`     | `file1.txt`, `file2.txt`, `file3.txt`, `fileA.txt`, `fileB.txt` |

Penting untuk membedakan dua hal:

- `?` mencocokkan tepat satu karakter.
- `[1-3]` mencocokkan tepat satu karakter yang berada dalam rentang `1` sampai `3`.

Karena `file10.txt` memiliki dua karakter setelah `file`, pola `file?.txt` tidak cocok dengannya.

Contoh pengujian di Zsh:

```
print -r -- file[1-3].txt
```

`print` menerima hasil ekspansi glob dari Zsh. Pola itu bukan teks biasa yang diteruskan apa adanya ke `print`.

### 05.3 — Mengecualikan karakter

Kurung siku juga dapat digunakan untuk mencocokkan karakter yang bukan bagian dari himpunan tertentu.

```
print -r -- file[^12].txt
```

Dengan daftar file pada contoh sebelumnya, pola tersebut cocok dengan nama seperti `file3.txt` dan `fileA.txt`, tetapi tidak dengan `file1.txt` atau `file2.txt`.

Di dalam `[...]`, `^` di awal menyatakan negasi. Jangan menyamakannya dengan `^pattern` di luar kurung siku: keduanya merupakan bentuk pola yang berbeda.

### 05.4 — Glob rekursif

Pola `**/` memungkinkan pencarian nama file melalui direktori bertingkat.

Misalnya struktur direktori berikut:

```
project/
├── main.lua
├── config/
│   └── settings.lua
└── src/
    └── modules/
        └── helper.lua
```

Jika posisi shell berada di dalam `project/`:

```
print -r -- *.lua
```

mencocokkan file Lua di direktori saat ini, yaitu `main.lua`.

Sementara itu:

```
print -r -- **/*.lua
```

dapat mencocokkan `main.lua`, `config/settings.lua`, dan `src/modules/helper.lua`.

Perhatikan bahwa `**/*.lua` bergantung pada struktur direktori dan file yang benar-benar tersedia. Secara default, glob biasa juga tidak mencocokkan nama tersembunyi seperti `.config.lua` kecuali pola ditulis secara eksplisit untuk nama tersebut atau opsi terkait diaktifkan.

### 05.5 — Extended glob

Dokumen kurikulum Anda juga memperkenalkan pola negasi `^*.bak`. Pola ini menggunakan fitur extended glob, yang perlu diaktifkan dengan opsi `EXTENDED_GLOB`.

```
setopt EXTENDED_GLOB

print -r -- ^*.bak
```

Dalam konteks ini, `^*.bak` mencocokkan nama yang tidak cocok dengan pola `*.bak`.

Extended glob menyediakan operator lain yang berguna:

| Pola         | Makna                                         |
| ------------ | --------------------------------------------- |
| `?(pattern)` | Nol atau satu kemunculan pola                 |
| `*(pattern)` | Nol atau lebih kemunculan pola                |
| `+(pattern)` | Satu atau lebih kemunculan pola               |
| `@(a\\|b)`   | Salah satu pola alternatif                    |
| `!(pattern)` | Pola yang tidak cocok dengan pola di dalamnya |

Contoh berikut mengasumsikan `EXTENDED_GLOB` sudah aktif:

```
# Nama yang berakhiran .txt atau .md
print -r -- *.(txt|md)

# Nama yang berakhiran satu atau lebih digit
print -r -- *<1->
```

Contoh kedua menggunakan bentuk rentang angka extended glob Zsh. Kita akan membahasnya setelah pola dasarnya benar-benar dipahami; untuk saat ini, fokuskan perhatian pada operator `*`, `?`, `[...]`, `**/`, dan negasi.

Catatan: glob bekerja pada nama file dan direktori. Glob bukan regular expression, sehingga sintaksnya tidak boleh langsung dipindahkan dari `grep`, `sed`, atau bahasa pemrograman lain.

---

<details>
  <summary>📃  Latihan Lesson 05</summary>

#### Jawab berdasarkan pemahaman Anda sendiri sebelum menjalankan contoh di terminal.

1\. Apa yang cocok dengan `file?.txt`?

`file1.txt` dan `file10.txt`

`file1.txt`, tetapi bukan `file10.txt`

Semua file yang berakhiran `.txt`

2\. Apa perbedaan `*.lua` dan `**/*.lua`?

Tidak ada perbedaan

`*.lua` untuk direktori saat ini; `**/*.lua` dapat mencakup subdirektori secara rekursif

`*.lua` mencari rekursif; `**/*.lua` hanya di direktori saat ini

3\. Apa syarat menggunakan `^*.bak` sebagai pola negasi extended glob?

Mengaktifkan `EXTENDED_GLOB`

Mengaktifkan `AUTO_CD`

Tidak ada opsi yang diperlukan

4\. Apa fungsi `[1-3]` dalam pola `file[1-3].txt`?

Mencocokkan satu atau lebih digit dari 1 sampai 3

Mencocokkan tepat satu karakter dari `1`, `2`, atau `3`

Mencocokkan nama file yang mengandung angka 1 sampai 3 di posisi mana pun

</details>

---

Kita lanjutkan materi glob yang tersisa sebelum berpindah ke Lesson 06 — Zsh Options.

## Lesson 05 — Glob / Filename Generation

### 05.2 — Rentang dan kelas karakter

Glob digunakan Zsh untuk mencocokkan nama file atau direktori. Selain `*` dan `?`, kita dapat menggunakan kurung siku `[...]` untuk mencocokkan satu karakter berdasarkan himpunan atau rentang.

Misalkan direktori saat ini berisi:

```
file1.txt
file2.txt
file3.txt
file10.txt
fileA.txt
fileB.txt
```

| Pola            | Hasil yang cocok                                                |
| --------------- | --------------------------------------------------------------- |
| `file[12].txt`  | `file1.txt`, `file2.txt`                                        |
| `file[1-3].txt` | `file1.txt`, `file2.txt`, `file3.txt`                           |
| `file[AB].txt`  | `fileA.txt`, `fileB.txt`                                        |
| `file?.txt`     | `file1.txt`, `file2.txt`, `file3.txt`, `fileA.txt`, `fileB.txt` |

Penting untuk membedakan dua hal:

- `?` mencocokkan tepat satu karakter.
- `[1-3]` mencocokkan tepat satu karakter yang berada dalam rentang `1` sampai `3`.

Karena `file10.txt` memiliki dua karakter setelah `file`, pola `file?.txt` tidak cocok dengannya.

Contoh pengujian di Zsh:

```
print -r -- file[1-3].txt
```

`print` menerima hasil ekspansi glob dari Zsh. Pola itu bukan teks biasa yang diteruskan apa adanya ke `print`.

### 05.3 — Mengecualikan karakter

Kurung siku juga dapat digunakan untuk mencocokkan karakter yang bukan bagian dari himpunan tertentu.

```
print -r -- file[^12].txt
```

Dengan daftar file pada contoh sebelumnya, pola tersebut cocok dengan nama seperti `file3.txt` dan `fileA.txt`, tetapi tidak dengan `file1.txt` atau `file2.txt`.

Di dalam `[...]`, `^` di awal menyatakan negasi. Jangan menyamakannya dengan `^pattern` di luar kurung siku: keduanya merupakan bentuk pola yang berbeda.

### 05.4 — Glob rekursif

Pola `**/` memungkinkan pencarian nama file melalui direktori bertingkat.

Misalnya struktur direktori berikut:

```
project/
├── main.lua
├── config/
│   └── settings.lua
└── src/
    └── modules/
        └── helper.lua
```

Jika posisi shell berada di dalam `project/`:

```
print -r -- *.lua
```

mencocokkan file Lua di direktori saat ini, yaitu `main.lua`.

Sementara itu:

```
print -r -- **/*.lua
```

dapat mencocokkan `main.lua`, `config/settings.lua`, dan `src/modules/helper.lua`.

Perhatikan bahwa `**/*.lua` bergantung pada struktur direktori dan file yang benar-benar tersedia. Secara default, glob biasa juga tidak mencocokkan nama tersembunyi seperti `.config.lua` kecuali pola ditulis secara eksplisit untuk nama tersebut atau opsi terkait diaktifkan.

### 05.5 — Extended glob

Dokumen kurikulum Anda juga memperkenalkan pola negasi `^*.bak`. Pola ini menggunakan fitur extended glob, yang perlu diaktifkan dengan opsi `EXTENDED_GLOB`.

```
setopt EXTENDED_GLOB

print -r -- ^*.bak
```

Dalam konteks ini, `^*.bak` mencocokkan nama yang tidak cocok dengan pola `*.bak`.

Extended glob menyediakan operator lain yang berguna:

| Pola         | Makna                                         |
| ------------ | --------------------------------------------- |
| `?(pattern)` | Nol atau satu kemunculan pola                 |
| `*(pattern)` | Nol atau lebih kemunculan pola                |
| `+(pattern)` | Satu atau lebih kemunculan pola               |
| `@(a\\|b)`   | Salah satu pola alternatif                    |
| `!(pattern)` | Pola yang tidak cocok dengan pola di dalamnya |

Contoh berikut mengasumsikan `EXTENDED_GLOB` sudah aktif:

```
# Nama yang berakhiran .txt atau .md
print -r -- *.(txt|md)

# Nama yang berakhiran satu atau lebih digit
print -r -- *<1->
```

Contoh kedua menggunakan bentuk rentang angka extended glob Zsh. Kita akan membahasnya setelah pola dasarnya benar-benar dipahami; untuk saat ini, fokuskan perhatian pada operator `*`, `?`, `[...]`, `**/`, dan negasi.

Catatan: glob bekerja pada nama file dan direktori. Glob bukan regular expression, sehingga sintaksnya tidak boleh langsung dipindahkan dari `grep`, `sed`, atau bahasa pemrograman lain.

<details>
  <summary>📃  Latihan</summary>

---

Jawab berdasarkan pemahaman Anda sendiri sebelum menjalankan contoh di terminal.

1\. Apa yang cocok dengan `file?.txt`?

`file1.txt` dan `file10.txt`

`file1.txt`, tetapi bukan `file10.txt`

Semua file yang berakhiran `.txt`

2\. Apa perbedaan `*.lua` dan `**/*.lua`?

Tidak ada perbedaan

`*.lua` untuk direktori saat ini; `**/*.lua` dapat mencakup subdirektori secara rekursif

`*.lua` mencari rekursif; `**/*.lua` hanya di direktori saat ini

3\. Apa syarat menggunakan `^*.bak` sebagai pola negasi extended glob?

Mengaktifkan `EXTENDED_GLOB`

Mengaktifkan `AUTO_CD`

Tidak ada opsi yang diperlukan

4\. Apa fungsi `[1-3]` dalam pola `file[1-3].txt`?

Mencocokkan satu atau lebih digit dari 1 sampai 3

Mencocokkan tepat satu karakter dari `1`, `2`, atau `3`

Mencocokkan nama file yang mengandung angka 1 sampai 3 di posisi mana pun

</details>

---

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

[0]: ./README.md
[1]: ./
[2]: ./
[3]: ./
[4]: ./
[5]: ./
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

