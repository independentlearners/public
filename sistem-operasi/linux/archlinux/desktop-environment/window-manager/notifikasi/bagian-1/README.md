Di tahap ini, kita tidak hanya sekadar menyalin kode. Kita akan membangun **file konfigurasi** dari nol (kosong), memahami di mana ia tinggal, bagaimana strukturnya, dan menelaah setiap karakter yang kita ketik.

Tujuannya: Agar Anda bisa menulis konfigurasi sendiri tanpa menyontek tutorial di masa depan.

-----

### **1. English for Professional Documentation (Bahasa Inggris untuk Dokumentasi Profesional)**

Dalam membaca manual konfigurasi (seperti `man mako`), Anda akan bertemu istilah **"Directive"** atau **"Property"**.

> *"The **font** directive sets the typeface used for the notification body."*
> (Direktif **font** mengatur jenis huruf yang digunakan untuk isi notifikasi.)

**Bedah Kata & Konsep:**

  * **Directive** (Noun):
      * Berasal dari kata *Direct* (Mengarahkan).
      * Dalam konteks konfigurasi, ini adalah **perintah spesifik** atau kunci pengaturan (Key) yang memberi tahu program apa yang harus dilakukan. Contoh: `font`, `background-color`.
  * **Sets** (Verb):
      * Menetapkan atau mengatur.
  * **Typeface** (Noun):
      * Istilah desain grafis profesional untuk "jenis huruf" (sering tertukar dengan *font*, tapi dalam IT sering dianggap sama).

-----

### **2. The Configuration Path (Jalur Konfigurasi)**

Sway dan aplikasi modern di Linux mengikuti standar yang disebut **XDG Base Directory Specification**.

Mako tidak akan membuat file konfigurasi secara otomatis untuk Anda. Kita harus membuatnya secara manual di lokasi spesifik.

**Lokasi Target:** `~/.config/mako/config`

Mari kita buat direktori dan filenya menggunakan CLI. Ketik perintah ini (jangan di-enter dulu):

```bash
mkdir -p ~/.config/mako && touch ~/.config/mako/config
```

**Bedah Kode, Simbol & Logika (Deep Dive):**

1.  **`mkdir`** (Command)
      * Singkatan: *Make Directory*.
      * Fungsi: Membuat folder baru.
2.  **`-p`** (Option / Flag)
      * **Jenis:** *Parents flag*.
      * **Penting:** Tanpa flag ini, jika folder `.config` belum ada, perintah akan error (*"No such file or directory"*).
      * **Fungsi:** Memerintahkan `mkdir` untuk membuat direktori induk (parent) jika belum ada, DAN **tidak akan error** jika direktori tersebut sudah ada. Ini adalah praktik *error-handling* preventif dalam scripting.
3.  **`~`** (Symbol / Tilde)
      * **Arti:** Shortcut untuk `/home/username_anda`.
      * **Kenapa pakai ini?** Agar perintah ini bisa dipakai oleh siapapun tanpa harus mengetahui nama usernya.
4.  **`/.config/mako`** (Path)
      * Alamat folder yang akan dibuat.
5.  **`&&`** (Control Operator / Logical AND)
      * **Sangat Penting:** Ini adalah operator logika.
      * **Cara Baca:** "Lakukan perintah di kiri. **JIKA DAN HANYA JIKA** perintah kiri SUKSES (exit code 0), barulah jalankan perintah di kanan."
      * **Manfaat:** Jika `mkdir` gagal (misal disk penuh), `touch` tidak akan dijalankan. Ini mencegah error beruntun.
6.  **`touch`** (Command)
      * **Fungsi Asli:** Mengubah timestamp file.
      * **Fungsi Praktis:** Jika file tidak ada, ia akan membuat file kosong. Jika file ada, isinya tidak akan dihapus (aman).
7.  **`~/.config/mako/config`** (File Path)
      * File teks kosong yang baru saja kita buat.

-----

### **3. The Syntax Structure (Struktur Sintaks)**

Sekarang, mari kita buka file tersebut. Karena Anda menyukai CLI, gunakan editor teks favorit Anda (vim, nano, atau neovim).

Contoh perintah: `nano ~/.config/mako/config`

Mako menggunakan format file yang mirip dengan standar **INI File**.

**Format Dasar:**

```ini
key=value
```

**Bedah Sintaks:**

1.  **`key`** (Kunci/Direktif): Nama pengaturan yang disediakan oleh Mako (misal: `font`, `width`, `anchor`). Ini harus ditulis persis sesuai dokumentasi (case-sensitive).
2.  **`=`** (Assignment Operator / Operator Penugasan):
      * **Fungsi:** Menghubungkan *Key* dengan *Value*.
      * **Aturan Spasi:** Di Mako, `key=value`, `key = value`, atau `key= value` biasanya bisa dibaca. Namun, **praktik terbaik (Best Practice)** dalam scripting adalah meminimalkan spasi yang tidak perlu di sekitar `=` untuk menghindari ambiguitas parsing, kecuali dokumentasi menyarankan sebaliknya. Kita akan gunakan format rapat `key=value` atau `key=value` (dengan spasi di nilai jika perlu).
3.  **`value`** (Nilai): Apa yang Anda inginkan (misal: `12`, `#ffffff`, `top-right`).

-----

### **4. Menulis Konfigurasi Pertama (Writing First Config)**

Mari kita tulis konfigurasi paling dasar untuk memastikan Mako membaca file kita. Masukkan teks berikut ke dalam editor Anda:

```ini
# Pengaturan Dasar
font=monospace 14
background-color=#2e3440
```

**Bedah Per-Baris & Simbol:**

**Baris 1:** `  # Pengaturan Dasar `

  * **`#`** (Hash / Pound Symbol):
      * **Fungsi:** *Comment character*.
      * **Cara Kerja:** Mako akan **mengabaikan** apapun yang ada di kanan simbol ini.
      * **Tujuan:** Catatan untuk manusia. Jangan pernah malas menulis komentar; ini akan menyelamatkan Anda saat debugging 6 bulan lagi.

**Baris 2:** `font=monospace 14`

  * **`font`** (Key): Direktif untuk mengatur huruf.
  * **`=`**: Penugasan.
  * **`monospace`** (Value - Part 1): Nama font. *Monospace* adalah font default sistem di mana setiap huruf memiliki lebar yang sama (cocok untuk koding). Anda bisa ganti dengan "JetBrains Mono" atau "Roboto" jika sudah terinstal.
  * **`     `** (Space): Pemisah antara nama font dan ukuran.
  * **`14`** (Value - Part 2): Ukuran font dalam poin (pt).

**Baris 3:** `background-color=#2e3440`

  * **`background-color`** (Key): Mengatur warna latar notifikasi.
  * **`#2e3440`** (Value - Hex Code):
      * **`#`**: Penanda kode warna Hexadesimal.
      * **`2e3440`**: Kode warna biru gelap (Tema *Nord*).
      * **Catatan:** Jika simbol `#` ini ada di *tengah* baris setelah spasi, bisa dianggap komentar. Tapi karena ini menempel pada kode warna, Mako paham ini adalah warna.

-----

### **5. Validasi & Testing (Validation)**

Simpan file tersebut (di Nano: `Ctrl+O` -\> Enter -\> `Ctrl+X`).

Sekarang kita perlu me-reload Mako agar ia membaca file baru ini.
Jalankan perintah:

```bash
makoctl reload
```

Lalu, kirim notifikasi tes:

```bash
notify-send "Tes Konfigurasi" "Jika ini background biru gelap dan font besar, berarti sukses."
```

**Analisis Error (Troubleshooting):**

1.  **Jika notifikasi tidak muncul:** Cek apakah daemon mako sedang berjalan. Ketik `mako &` di terminal untuk menjalankannya secara manual di background.
2.  **Jika tampilan tidak berubah (masih default):** Berarti file config salah letak atau salah nama. Pastikan path-nya `~/.config/mako/config` (tanpa ekstensi .txt atau lainnya).

-----

### **Next Step**

Apakah notifikasi tes Anda sudah muncul dengan background biru gelap dan font ukuran 14?

Jika **YA**, kita akan lanjut ke **Fase 2: Advanced Styling**. Kita akan belajar tentang *padding*, *border-radius* (lengkungan sudut), dan *alpha transparency* agar notifikasi terlihat modern dan transparan.

> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../README.md
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
