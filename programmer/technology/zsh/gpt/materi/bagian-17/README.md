# Lesson 16 — Zsh Modules (`zmodload`)

Pada pelajaran ini, kita mempelajari bagaimana Zsh dapat memuat modul untuk menyediakan kemampuan tambahan. Ini merupakan langkah awal memahami bagian internal Zsh yang nantinya berguna ketika membaca konfigurasi tingkat lanjut dan kode plugin.

Mental model:

```bash
Zsh
 │
 ├── Fitur bawaan
 │
 └── Module system
       │
       ├── Memuat modul
       ├── Menyediakan fitur
       └── Mengekspos builtin, parameter,
           atau kemampuan lain
```

## 1. Apa itu modul Zsh?

Zsh memiliki sistem modul yang memungkinkan kemampuan tertentu disediakan atau dimuat secara terpisah dari inti shell.

Modul bukan hal yang sama dengan plugin.

| Konsep   | Fungsi                                                                              |
| -------- | ----------------------------------------------------------------------------------- |
| Builtin  | Perintah yang disediakan langsung oleh shell, misalnya `cd`.                        |
| Function | Kumpulan kode shell yang dapat dipanggil berdasarkan nama.                          |
| Autoload | Mekanisme untuk memuat definisi fungsi saat diperlukan.                             |
| Module   | Komponen yang dapat menyediakan kemampuan tambahan melalui sistem modul Zsh.        |
| Plugin   | Kumpulan kode atau konfigurasi yang mengintegrasikan satu atau lebih mekanisme Zsh. |

Plugin dapat menggunakan modul, tetapi tidak semua plugin membutuhkan modul. Sebagian besar konfigurasi Zsh dapat dibuat menggunakan fungsi, parameter, hooks, dan builtin tanpa menulis modul baru.

## 2. Mengenal `zmodload`

`zmodload` adalah builtin yang digunakan untuk memuat atau mengelola modul Zsh.

Periksa bantuan yang tersedia di sistem Anda:

```bash
man zshmodules
```

Untuk mengetahui apakah `zmodload` tersedia:

```bash
whence -v zmodload
```

Karena `zmodload` merupakan builtin Zsh, Anda tidak perlu memasang executable terpisah untuk menjalankannya.

## 3. Melihat modul yang telah dimuat

Jalankan:

```bash
zmodload
```

Perintah tersebut menampilkan modul yang sedang dimuat pada sesi shell Anda.

Daftar aktualnya bergantung pada konfigurasi dan kebutuhan shell. Jangan menganggap setiap modul yang tersedia otomatis telah dimuat.

Untuk memeriksa dokumentasi modul, gunakan:

```bash
man zshmodules
```

Manual tersebut menjelaskan modul yang tersedia beserta kemampuan yang disediakannya.

## 4. Memuat modul secara eksplisit

Salah satu modul yang dapat Anda pelajari adalah `zsh/datetime`.

Coba di sesi Zsh:

```bash
zmodload zsh/datetime
```

Modul ini menyediakan parameter waktu seperti `$EPOCHSECONDS` dan `$EPOCHREALTIME`.

Setelah modul berhasil dimuat, coba:

```bash
print -r -- "$EPOCHSECONDS"
```

Nilainya menunjukkan waktu Unix dalam satuan detik.

Untuk melihat waktu dengan presisi pecahan detik:

```bash
print -r -- "$EPOCHREALTIME"
```

Parameter tersebut berguna ketika Anda ingin mengukur durasi operasi atau mencatat waktu pada konfigurasi interaktif.

Perhatikan perbedaan berikut:

- `zmodload zsh/datetime` memuat modul.
- `$EPOCHSECONDS` membaca parameter yang disediakan modul.
- `print` menampilkan nilainya.

Artinya, `zmodload` bukan perintah untuk mengambil waktu secara langsung; ia mengaktifkan kemampuan yang kemudian dapat digunakan.

## 5. Modul dan parameter khusus

Modul dapat menyediakan parameter atau builtin yang tidak tersedia sebelum modul dimuat.

Contoh lain adalah `zsh/parameter`, yang menyediakan akses lebih luas terhadap informasi internal shell melalui parameter khusus.

Coba:

```bash
zmodload zsh/parameter
```

Kemudian periksa salah satu parameter yang tersedia:

```bash
print -r -- "$ZSH_VERSION"
```

`ZSH_VERSION` sendiri sudah tersedia tanpa modul tersebut. Jadi, perintah itu hanya memeriksa versi Zsh, bukan membuktikan bahwa `zsh/parameter` menyediakan parameter tersebut.

Untuk memeriksa parameter dan kemampuan yang berkaitan dengan modul secara akurat, gunakan dokumentasi `zshmodules(1)` pada versi Zsh yang terpasang.

## 6. Apakah semua modul harus dimuat?

Tidak. Memuat modul secara eksplisit hanya diperlukan ketika konfigurasi atau script membutuhkan kemampuan yang disediakan modul tersebut dan kemampuan itu belum tersedia.

Prinsip yang baik:

1. Tentukan fitur yang dibutuhkan.
2. Periksa dokumentasi modul yang relevan.
3. Muat modul jika diperlukan.
4. Gunakan kemampuan yang disediakan.
5. Hindari memuat modul tanpa tujuan yang jelas.

Jangan menambahkan semua `zmodload` yang Anda temukan ke `zshrc`. Konfigurasi yang baik memuat fitur berdasarkan kebutuhan, bukan sekadar mengumpulkan modul.

## 7. Praktik kecil

Jalankan perintah berikut secara berurutan:

```bash
# Periksa versi Zsh.
print -r -- "$ZSH_VERSION"

# Periksa builtin zmodload.
whence -v zmodload

# Muat modul waktu.
zmodload zsh/datetime

# Gunakan parameter yang disediakan modul.
print -r -- "$EPOCHSECONDS"

# Lihat modul yang dimuat.
zmodload
```

Jika terjadi kesalahan saat memuat modul, jangan langsung menyimpulkan bahwa sintaksnya salah. Modul mungkin tidak tersedia dalam build Zsh yang digunakan, atau ada perbedaan dukungan berdasarkan versi.

## Ringkasan

Hal utama dari pelajaran ini adalah memahami hubungan antara modul dan fitur yang disediakan Zsh:

```bash
zmodload
   ↓
Memuat modul
   ↓
Kemampuan modul tersedia
   ↓
Script atau konfigurasi menggunakannya
```

Modul berbeda dari function dan autoload: modul menyediakan kemampuan pada tingkat sistem modul Zsh, sedangkan autoload berfokus pada pemuatan definisi fungsi.

Pelajaran selanjutnya adalah Lesson 17 — Modular Configuration, yaitu menyusun file konfigurasi menjadi komponen terpisah yang mudah dipahami, diuji, dan dikembangkan.

> - **[Ke Atas](#)**
> - **[Sebelumnya][sebelumnya]**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**
> - **[Daftar Teknologi][tekno]**

[tekno]: ../../../../../README.md
[domain]: ../../../../../../README.md
[kurikulum]: ../zsh_scripting.md
[sebelumnya]: ../bagian-16/README.md
[selanjutnya]: ../bagian-18/README.md

<!-- [selanjutnya]: ../bagian-3/README.md -->

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

