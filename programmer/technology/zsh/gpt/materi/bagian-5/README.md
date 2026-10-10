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

Zsh

```
print -r -- *.zsh
```

Zsh mencocokkan pola `*.zsh` dengan nama file yang sesuai di direktori saat ini.

Hasilnya:

```
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

Zsh

```
print -r -- *.txt
```

Mencocokkan semua nama yang berakhiran `.txt`.

Zsh

```
print -r -- file?.txt
```

Mencocokkan nama seperti `file1.txt` atau `fileA.txt`, tetapi bukan `file10.txt`, karena `?` hanya mencocokkan satu karakter.

Zsh

```
print -r -- file[12].txt
```

Mencocokkan `file1.txt` dan `file2.txt`, tetapi bukan `file3.txt`.

Penting: glob bukan regular expression (regex). Walaupun ada karakter yang tampak serupa, aturan pencocokannya berbeda.

## 05.3 — Glob tidak selalu mencari ke subdirektori

Pola berikut:

Zsh

```
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

```
print -r -- **/*.lua
```

Pola `**/` dapat mencocokkan direktori bertingkat, sehingga file Lua di dalam subdirektori juga dapat ditemukan.

Namun, hasil pastinya bergantung pada struktur direktori dan aturan glob yang aktif. Jika pola tidak menemukan kecocokan, perilaku default Zsh berbeda dari Bash: Zsh biasanya melaporkan `no matches found` alih-alih meneruskan pola mentah ke perintah.

Jangan mengaktifkan opsi untuk mengubah perilaku tersebut dahulu; kita akan mempelajari Zsh options pada tahap kurikulum yang sesuai.

## 05.4 — Mengecualikan pola dengan `^`

Dokumen kurikulum Anda juga memberikan contoh:

Zsh

```
^*.bak
```

Dalam Zsh, pola negasi seperti ini memerlukan opsi `EXTENDED_GLOB`.

Contoh:

Zsh

```
setopt EXTENDED_GLOB
print -r -- ^*.bak
```

Secara konseptual, pola tersebut berarti mencocokkan nama yang tidak berakhiran `.bak`.

Misalnya, di direktori terdapat:

```
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

Posisi kurikulum: Lesson 05 — Glob / Filename Generation, bagian dasar. Berikutnya kita akan mempelajari pencocokan pola yang lebih spesifik, termasuk rentang karakter, pola rekursif, dan negasi glob, sebelum berpindah ke materi berikutnya.
#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md

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

