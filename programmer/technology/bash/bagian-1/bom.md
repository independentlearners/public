# Ringkasan Teknis: BOM dan Shebang pada Script

## Definisi

**BOM (Byte Order Mark)** adalah urutan byte khusus di awal file teks yang menandai encoding file. Pada UTF-8, BOM terdiri dari tiga byte `EF BB BF`, yang secara Unicode mewakili karakter `U+FEFF` dan biasanya tidak terlihat di editor. [runebook](https://runebook.dev/en/docs/python/library/codecs/module-encodings.utf_8_sig)

**Shebang** adalah dua karakter `#!` pada baris pertama file script, misalnya `#!/bin/bash` atau `#!/usr/bin/env python3`. Sistem operasi Unix/Linux menggunakan shebang untuk menentukan interpreter yang menjalankan script tersebut. 

## Interaksi BOM dengan Shebang

Kernel Unix/Linux mengenali script yang dapat dieksekusi dengan memeriksa apakah dua byte pertama file persis `#!` (`0x23 0x21`). Jika file disimpan sebagai **UTF-8 with BOM**, tiga byte `EF BB BF` berada sebelum shebang, sehingga `#!` tidak lagi berada pada posisi byte pertama. [lunchboxhands](https://lunchboxhands.com/blog/invisible-unicode-characters/)

Akibatnya, shebang tidak dikenali sebagai deklarasi interpreter dan script dapat gagal dijalankan dengan error seperti:

```text
bad interpreter: No such file or directory
```

atau:

```text
command not found
```



## Contoh Byte

Script yang tampak normal di editor:

```bash
#!/bin/bash
echo "Halo"
```

Jika disimpan dengan UTF-8 BOM, representasi byte awalnya menjadi:

```text
EF BB BF 23 21 2F 62 69 6E 2F 62 61 73 68
   ↑       ↑ ↑
  BOM      # !
```

Dengan demikian, baris pertama yang dibaca sistem adalah `<BOM>#!/bin/bash`, bukan `#!/bin/bash`. [wp-p](https://wp-p.info/tpl_dictionary_rep.php?cat=dictionary-format&fl=bom&lang=en)

## Contoh Pembuatan File BOM

Perintah berikut membuat shell script yang mengandung BOM:

```bash
printf '\xef\xbb\xbf#!/bin/bash\necho hello\n' > bom.sh
chmod +x bom.sh
./bom.sh
```

File `bom.sh` akan diawali byte `EF BB BF`, sehingga shebang-nya berpotensi tidak dikenali oleh sistem. [wp-p](https://wp-p.info/tpl_dictionary_rep.php?cat=dictionary-format&fl=bom&lang=en)

## BOM Bukan Baris Deklarasi

BOM **bukan** baris kode atau komentar yang ditulis manual di dalam script. Ia adalah byte pembuka file yang biasanya ditambahkan otomatis oleh editor ketika pengguna memilih opsi penyimpanan **UTF-8 with BOM**. [runebook](https://runebook.dev/en/docs/python/library/codecs/module-encodings.utf_8_sig)

Berbeda dengan BOM, shebang dan deklarasi encoding memang berupa baris teks:

```bash
#!/usr/bin/env bash
```

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
```

Pada Python 3, UTF-8 sudah menjadi encoding default, sehingga komentar `# -*- coding: utf-8 -*-` umumnya tidak diperlukan. Python juga dapat menerima UTF-8 BOM di awal file dan menafsirkannya sebagai penanda encoding UTF-8. 

## Rekomendasi Praktik

| Jenis file | Rekomendasi encoding | Alasan |
|---|---|---|
| Shell script (`.sh`) | UTF-8 tanpa BOM | Shebang harus menjadi byte pertama file.  [lunchboxhands](https://lunchboxhands.com/blog/invisible-unicode-characters/) |
| Python script (`.py`) | UTF-8 tanpa BOM, meskipun BOM umumnya masih didukung | Menghindari masalah kompatibilitas dan menjaga konsistensi.  |
| File konfigurasi teks | UTF-8 tanpa BOM | BOM dapat dianggap sebagai karakter tak terduga oleh parser.  |
| Dokumen untuk aplikasi Windows tertentu | UTF-8 with BOM bila aplikasi membutuhkannya | Beberapa aplikasi Windows menggunakan BOM untuk mendeteksi UTF-8.  |

## Verifikasi dan Perbaikan

Untuk memeriksa apakah sebuah script mengandung BOM:

```bash
hexdump -C script.sh | head -n 1
```

Jika output diawali dengan `ef bb bf`, file tersebut memiliki BOM. [wp-p](https://wp-p.info/tpl_dictionary_rep.php?cat=dictionary-format&fl=bom&lang=en)

Praktik yang disarankan:

- Simpan shell script sebagai **UTF-8 tanpa BOM**.
- Gunakan akhir baris Unix (`LF`), bukan `CRLF` dari Windows.
- Pastikan shebang berada pada baris pertama tanpa karakter, spasi, atau byte apa pun sebelum `#!`.
- Pada editor seperti VS Code, gunakan **Save with Encoding → UTF-8**, bukan **UTF-8 with BOM**. 

## Kesimpulan

BOM berguna sebagai penanda encoding pada beberapa konteks, tetapi berbahaya untuk shell script karena menggeser posisi shebang. Untuk script yang dijalankan langsung di Linux, macOS, atau lingkungan Unix-like, standar yang aman adalah **UTF-8 tanpa BOM**, akhir baris `LF`, dan shebang pada byte paling awal file. [lunchboxhands](https://lunchboxhands.com/blog/invisible-unicode-characters/)
