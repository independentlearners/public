<!-- <details> -->
<!--   <summary>📃 Daftar Isi</summary> -->
<!---->
<!-- </details> -->
<!---->
<!-- # -->
<!-- Baik, saya mengerti sepenuhnya instruksi Anda. Kita akan membedah materi ini dengan presisi tingkat mikroskopis. Tidak ada simbol atau kata yang terlewat tanpa penjelasan. -->
<!---->
<!-- Selamat datang di **Fase 0: Prerequisites & Philosophy**. -->
<!---->
Sebelum kita menulis satu baris kode warna pun, kita harus memahami "kanvas" tempat kita akan melukis. Di Linux (khususnya Arch), pemahaman struktur file adalah separuh dari keberhasilan konfigurasi.
<!---->
<!-- ----- -->
<!---->
### [🇬🇧 English Corner: Structural Vocabulary][0]

Untuk memahami dokumentasi konfigurasi, Anda perlu menguasai kosakata tentang struktur kalimat perintah (*command syntax*).

**1. Vocabulary Focus:**

  * **Directive** *(Noun)*: Instruksi spesifik atau perintah dalam file konfigurasi yang memberitahu program apa yang harus dilakukan.
      * *Context:* "`include` is a **directive** to load another file."
  * **Argument** *(Noun)*: Informasi tambahan yang diberikan kepada perintah (*directive*) agar bisa berjalan.
      * *Context:* "The file path is the **argument** for the include directive."
  * **Wildcard** *(Noun)*: Karakter khusus (biasanya simbol `*`) yang mewakili satu atau lebih karakter lain.

**2. Professional Grammar: Prepositions of Place**
Dalam IT, preposisi sangat krusial untuk menunjukkan lokasi file.

  * **Path**: `/etc/sway/config`
  * *Usage:* "The config file is located **in** the `/etc/sway` directory." (File konfigurasi berlokasi **di dalam** direktori `/etc/sway`).

-----

### 🛠️ Tech Identity: Sway Window Manager

Sesuai permintaan Anda untuk menyertakan identitas teknologi:

  * **Nama:** Sway (SwayWM).
  * **Bahasa Pemrograman:** **C**. (Dibangun di atas pustaka `wlroots` yang juga ditulis dalam C).
  * **Asal/Pengembang:** Proyek ini dipimpin oleh **Drew DeVault** (seorang insinyur perangkat lunak terkemuka di komunitas Open Source).
  * **Lisensi:** MIT License (Sangat bebas/permissive).
  * **Persyaratan Modifikasi Mandiri:** Untuk memodifikasi kode sumber (*source code*) Sway, Anda perlu memahami bahasa **C**, protokol **Wayland**, dan sistem build **Meson**. Namun, untuk *theming* (kelas kita saat ini), Anda hanya perlu memahami sintaks konfigurasi Sway.
  * **Dokumentasi Resmi:**
      * *Man Pages:* `man 5 sway` (Ini adalah kitab suci konfigurasi Sway di terminal Anda).
      * *GitHub:* [https://github.com/swaywm/sway](https://github.com/swaywm/sway)

-----

### 📚 Fase 0: Struktur dan Sintaks Dasar

Mari kita mulai dengan **File Konfigurasi Utama**.

Di Arch Linux, konfigurasi default Sway biasanya ada di `/etc/sway/config`. Namun, **jangan pernah** mengedit file ini secara langsung karena akan tertimpa saat update. Anda harus menyalinnya ke direktori user Anda.

**Perintah persiapan (CLI):**

```bash
mkdir -p ~/.config/sway
cp /etc/sway/config ~/.config/sway/config
```

Sekarang, mari kita bedah sintaks paling dasar yang akan Anda temukan di baris pertama atau kedua file tersebut. Ini adalah contoh sempurna untuk analisis "kata-perkata".

#### Bedah Anatomi Sintaks: Variabel

Dalam Sway, kita sering mendefinisikan variabel untuk menyimpan nilai (seperti warna atau tombol modifier) agar bisa dipakai berulang kali.

**Contoh Baris Kode:**

```sway
set $mod Mod4
```

Mari kita bedah baris di atas secara **mikroskopis**:

| Token/Bagian | Jenis Kata/Simbol | Penjelasan Mendalam & Filosofi |
| :--- | :--- | :--- |
| **`set`** | *Keyword / Directive* (Kata Perintah) | Ini adalah kata kerja imperatif. Ia memerintahkan Sway untuk: "Tolong tetapkan/buat sebuah definisi baru". Dalam bahasa C, ini mirip dengan deklarasi variabel. Tanpa kata ini, Sway tidak tahu bahwa Anda sedang mencoba membuat variabel. |
| **`     `** | *Whitespace* (Spasi) | Pemisah (delimiter). Spasi ini **wajib** ada. Ia memisahkan antara perintah (`set`) dengan nama variabelnya. Tanpa spasi, `set$mod` akan dianggap error (syntax error). |
| **`$`** | *Sigil / Prefix* (Awalan Simbol) | Tanda Dollar. Dalam banyak bahasa scripting (Bash, PHP, Perl), simbol ini menandakan "Ini adalah Variabel". Di Sway, **wajib** menggunakan `$` di depan nama variabel agar sistem tahu bahwa teks berikutnya adalah wadah penyimpanan, bukan teks biasa. |
| **`mod`** | *Identifier / Name* (Nama Variabel) | Ini adalah nama yang Anda berikan. Anda bebas menamainya (misal: `$tombolutama`), tapi `$mod` adalah standar konvensi (kesepakatan umum) di komunitas i3/Sway yang berarti "Modifier". |
| **`     `** | *Whitespace* (Spasi) | Pemisah lagi. Memisahkan nama variabel (`$mod`) dengan nilai isinya. |
| **`Mod4`** | *Value / Literal* (Nilai) | Isi dari variabel tersebut. <br>• **Mod1** biasanya tombol `Alt`. <br>• **Mod4** adalah tombol `Super` atau `Windows Key` (Logo Windows/Command di Mac). <br>Sway memetakan string "Mod4" ke kode tombol fisik pada keyboard Anda melalui kernel Linux. |

**Kesimpulan Baris Tersebut:**
"Hai Sway (`set`), saya ingin membuat variabel bernama (`$mod`) yang jika saya panggil nanti, itu setara dengan saya menekan tombol Windows (`Mod4`)."

-----

#### Bedah Anatomi Sintaks: Komentar (Comments)

Anda akan sering melihat ini untuk dokumentasi mandiri.

**Contoh Baris Kode:**

```sway
# Logo key. Use Mod1 for Alt.
```

| Token/Bagian | Jenis Kata/Simbol | Penjelasan Mendalam |
| :--- | :--- | :--- |
| **`#`** | *Hash / Pound Sign* (Tanda Pagar) | Ini adalah instruksi kepada Sway untuk **mengabaikan** apapun yang ada setelah simbol ini pada baris yang sama. <br>• **Fungsi:** Digunakan untuk catatan manusia. Komputer tidak akan membaca ini. <br>• **Penting:** Jika Anda lupa tanda ini dan menulis kalimat biasa, Sway akan error karena mengira itu adalah perintah konfigurasi. |
| **`     `** | *Space* (Spasi) | Opsional, tapi sangat disarankan untuk keterbacaan (estetika kode). |
| **`Logo...`** | *Comment String* (Isi Komentar) | Teks bebas. Anda bisa menulis puisi di sini, Sway tidak peduli. |

-----

#### Bedah Anatomi Sintaks: Include (Integrasi File)

Ini teknik tingkat lanjut untuk memecah konfigurasi agar rapi (Modularisasi).

**Contoh Baris Kode:**

```sway
include /etc/sway/config.d/*
```

| Token/Bagian | Jenis Kata/Simbol | Penjelasan Mendalam |
| :--- | :--- | :--- |
| **`include`** | *Directive* (Perintah) | Perintah untuk "mengambil dan membaca" isi file lain dan memasukkannya ke posisi ini. Ini seperti menyisipkan halaman buku lain ke dalam buku yang sedang Anda baca. |
| **`/`** | *Root Directory Separator* (Pemisah) | Garis miring depan (*forward slash*). Menandakan awal dari struktur file sistem Linux (Root). |
| **`etc`** | *Directory* | Folder konfigurasi sistem standar di Linux (singkatan dari *Et cetera* atau *Extended Tool Chest*). |
| **`/`** | *Separator* | Pemisah antar folder. |
| **`sway`** | *Directory* | Folder spesifik milik aplikasi Sway. |
| **`/`** | *Separator* | Pemisah lagi. |
| **`config.d`** | *Directory* | Folder khusus (konvensi `.d` berarti *directory* untuk fragmen konfigurasi). |
| **`/`** | *Separator* | Pemisah terakhir sebelum file. |
| **`*`** | *Wildcard / Glob Pattern* | **Sangat Penting.** Simbol bintang ini berarti "Semua file". <br>• Artinya: "Ambil **semua** file yang ada di dalam folder `config.d`, apa pun namanya, dan baca semuanya." <br>• Tanpa bintang, Anda harus menulis nama file satu per satu. |

-----

### ⚠️ Error Handling & Debugging (Safety Net)

Sesuai instruksi Anda: "Bagaimana jika error?"

Jika Anda salah mengetik, misal lupa spasi di `set$mod`, Sway mungkin tidak akan memuat konfigurasi baru atau bahkan keluar (crash) ke TTY.

**1. Validasi Sebelum Reload:**
Sebelum menekan tombol reload, selalu biasakan mengecek apakah sintaks yang Anda tulis sudah benar menurut "tata bahasa" Sway.

Gunakan perintah ini di Terminal (CLI):

```bash
sway -C
```

  * **`sway`**: Memanggil biner aplikasi Sway.
  * **`-C`** (Huruf besar/Kapital): Singkatan dari `--validate`. Ini adalah *flag* atau opsi argumen.
      * **Arti:** "Cek file konfigurasi saya, tapi jangan jalankan Sway. Cukup beritahu saya jika ada yang salah."

**2. Cara Membaca Pesan Error:**
Jika outputnya seperti ini:
`Error on line 12: Unknown directive 'sett'`

  * **`Error on line 12`**: Masalah ada di baris ke-12 file konfigurasi Anda.
  * **`Unknown directive`**: Sway tidak mengenali kata perintah pertama.
  * **`'sett'`**: Ini kata yang salah (typo dari `set`).

**Solusi:** Buka file config, pergi ke baris 12, hapus satu huruf 't', simpan, lalu jalankan `sway -C` lagi sampai tidak ada output error.

-----

**Langkah Selanjutnya:**
Kita telah memahami "Bahan Dasar" (Sintaks, Variabel, Komentar, dan Wildcard). Sekarang kita siap untuk mencampurkan warna di mana kita akan menentukan kode Hex (`#ffffff`) dan memasukkannya ke dalam variabel agar mudah dikelola.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../../README.md
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
