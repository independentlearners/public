# ANSI escape sequence

Meskipun dokumen `Bash` yang dilampirkan berisi skrip konfigurasi untuk Zsh dan tidak memuat informasi tentang *ANSI escape sequence*, saya dapat memberikan dokumentasi lengkap mengenai *ANSI escape sequence* berdasarkan pengetahuan umum.

**ANSI Escape Sequences** adalah standar untuk pensinyalan *in-band* guna mengontrol pemformatan teks, warna, serta penempatan kursor pada terminal emulator dan konsol teks.

Berikut adalah dokumentasi komprehensif tentang cara kerjanya:

### 1. Sintaks Dasar

Hampir semua urutan ANSI modern dimulai dengan **Control Sequence Introducer (CSI)**, yang terdiri dari karakter *Escape* dan tanda kurung siku kiri `[`.
Dalam skrip (seperti Bash/Zsh) atau bahasa pemrograman, karakter *Escape* dapat ditulis sebagai:

* `\e`
* `\033` (Oktal)
* `\x1B` (Heksadesimal)

Bentuk umumnya adalah: `\e[<Parameter><Perintah>`

### 2. Pemformatan Teks dan Warna (SGR - Select Graphic Rendition)

Perintah SGR diakhiri dengan huruf `m`. Beberapa parameter dapat digabungkan dengan memisahkannya menggunakan titik koma (`;`).
Contoh: `\e[1;31m` (Tebal dan Teks Merah).
Untuk mengembalikan terminal ke keadaan semula (reset), gunakan `\e[0m`.

#### Gaya Teks (Text Styles)

| Kode | Efek | Catatan |
| --- | --- | --- |
| `0` | Reset / Normal | Membatalkan semua format dan warna |
| `1` | **Tebal (Bold)** / Terang | Biasanya membuat warna sedikit lebih terang |
| `2` | Redup (Dim) | Menurunkan intensitas warna |
| `3` | *Miring (Italic)* | Tidak didukung di semua terminal |
| `4` | Garis bawah (Underline) |  |
| `5` | Berkedip (Blink) lambat |  |
| `7` | Membalik warna (Reverse/Invert) | Menukar warna teks dan warna latar belakang |
| `8` | Tersembunyi (Hidden) | Teks tidak terlihat, biasanya untuk password |
| `9` | ~~Dicoret (Strikethrough)~~ |  |

#### Warna Dasar (8/16 Warna)

Terminal klasik mendukung 8 warna dasar dan 8 warna cerah/terang.

| Warna | Teks (Foreground) | Latar Belakang (Background) | Teks Cerah (Bright) | Latar Cerah (Bright) |
| --- | --- | --- | --- | --- |
| **Hitam** | `30` | `40` | `90` | `100` |
| **Merah** | `31` | `41` | `91` | `101` |
| **Hijau** | `32` | `42` | `92` | `102` |
| **Kuning** | `33` | `43` | `93` | `103` |
| **Biru** | `34` | `44` | `94` | `104` |
| **Magenta** | `35` | `45` | `95` | `105` |
| **Cyan** | `36` | `46` | `96` | `106` |
| **Putih** | `37` | `47` | `97` | `107` |

*Contoh Penggunaan:*
`echo -e "\e[31mIni teks merah\e[0m"`
`echo -e "\e[42;30m Latar hijau, teks hitam \e[0m"`

#### Warna Lanjutan (256 Warna)

Terminal modern mendukung 256 warna menggunakan format khusus:

* **Teks:** `\e[38;5;<Kode Warna>m`
* **Latar Belakang:** `\e[48;5;<Kode Warna>m`

*(Kode warna berkisar dari 0 hingga 255. Contoh: 196 adalah merah menyala).*

#### True Color (24-bit RGB)

Jika terminal Anda mendukung *True Color* (RGB), Anda dapat memasukkan nilai Merah, Hijau, dan Biru (0-255):

* **Teks:** `\e[38;2;<R>;<G>;<B>m`
* **Latar Belakang:** `\e[48;2;<R>;<G>;<B>m`

*Contoh Penggunaan:*
`echo -e "\e[38;2;255;100;0mIni warna oranye RGB\e[0m"`

---

### 3. Kontrol Navigasi Kursor

ANSI escape sequences juga dapat digunakan untuk memindahkan kursor tanpa menghapus teks yang ada. Huruf terakhir bersifat *case-sensitive*.

| Urutan | Perintah | Deskripsi |
| --- | --- | --- |
| `\e[<N>A` | Cursor Up | Memindahkan kursor ke atas sebanyak *N* baris |
| `\e[<N>B` | Cursor Down | Memindahkan kursor ke bawah sebanyak *N* baris |
| `\e[<N>C` | Cursor Forward | Memindahkan kursor ke kanan sebanyak *N* kolom |
| `\e[<N>D` | Cursor Back | Memindahkan kursor ke kiri sebanyak *N* kolom |
| `\e[<Y>;<X>H` | Cursor Position | Memindahkan kursor ke Baris *Y*, Kolom *X* (Pojok kiri atas adalah `1;1`) |
| `\e[s` atau `\e7` | Save Cursor | Menyimpan posisi kursor saat ini |
| `\e[u` atau `\e8` | Restore Cursor | Mengembalikan kursor ke posisi yang terakhir disimpan |

---

### 4. Menghapus Layar dan Teks (Erase Functions)

Digunakan untuk membersihkan sebagian atau seluruh tampilan layar.

| Urutan | Perintah | Deskripsi |
| --- | --- | --- |
| `\e[J` atau `\e[0J` | Erase in Display | Menghapus layar dari posisi kursor ke bagian bawah layar |
| `\e[1J` | Erase in Display | Menghapus layar dari posisi kursor ke bagian atas layar |
| `\e[2J` | Erase in Display | Menghapus *seluruh* layar |
| `\e[3J` | Erase Saved Lines | Menghapus *scrollback buffer* terminal secara keseluruhan |
| `\e[K` atau `\e[0K` | Erase in Line | Menghapus teks dari posisi kursor ke akhir baris saat ini |
| `\e[1K` | Erase in Line | Menghapus teks dari posisi kursor ke awal baris saat ini |
| `\e[2K` | Erase in Line | Menghapus *seluruh* baris saat ini |

**Catatan Praktis dalam Skrip Bash/Zsh:**
Jika Anda menggunakan perintah `echo`, pastikan untuk menambahkan flag `-e` agar terminal membaca urutan escape tersebut (contoh: `echo -e "\e[32mSukses\e[0m"`). Alternatif yang lebih portabel adalah menggunakan perintah `printf` tanpa flag (contoh: `printf "\e[32mSukses\e[0m\n"`).
