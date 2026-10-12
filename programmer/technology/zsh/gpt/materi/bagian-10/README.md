# Pelajaran 09 — Startup Architecture Zsh

Tujuan pelajaran ini adalah memahami kapan Zsh membaca setiap file startup, kondisi apa yang membuat file tersebut dijalankan, dan bagaimana keputusan itu memengaruhi konfigurasi shell.

Ini penting sebelum menyusun konfigurasi modular. Jika konfigurasi ditempatkan di file yang salah, variabel lingkungan mungkin tidak tersedia pada proses yang membutuhkannya, alias mungkin tidak muncul, atau konfigurasi interaktif justru dimuat pada shell noninteraktif.

## 09.1 Dua konsep utama: login dan interactive

Zsh memiliki dua sifat shell yang perlu dibedakan.

- Login shell: shell yang dimulai sebagai sesi login.
- Interactive shell: shell yang berinteraksi dengan pengguna, biasanya menerima perintah yang diketik langsung.

Keduanya merupakan sifat yang berbeda. Sebuah shell bisa login sekaligus interaktif, tetapi tidak semua shell interaktif adalah login shell.

Login + interactive

Contoh: sesi terminal yang dimulai sebagai login shell. File startup login dan interaktif yang relevan akan dibaca.

Interactive, bukan login

Contoh: shell interaktif baru yang dijalankan dari shell lain. Umumnya membaca konfigurasi interaktif, bukan file login.

Noninteractive

Contoh: Zsh menjalankan perintah dari script. Konfigurasi interaktif seperti alias dan keybinding tidak otomatis diperlukan.

Jangan menentukan jenis shell hanya dari aplikasi terminal yang digunakan. Terminal emulator adalah program yang menyediakan antarmuka terminal; cara shell dijalankan ditentukan oleh proses yang memulainya dan argumen yang diberikan.

## 09.2 Lima file startup utama

Zsh mengenali lima file startup utama berikut. Nama dengan awalan titik biasanya berada di direktori home, kecuali lokasi startup diarahkan melalui `$ZDOTDIR`.

| File        | Kapan dibaca                                  | Peran umum                                                  |
| ----------- | --------------------------------------------- | ----------------------------------------------------------- |
| `.zshenv`   | Setiap shell Zsh                              | Variabel lingkungan yang benar-benar diperlukan secara luas |
| `.zprofile` | Login shell                                   | Inisialisasi lingkungan untuk sesi login                    |
| `.zshrc`    | Interactive shell                             | Konfigurasi interaktif: options, alias, prompt, keybinding  |
| `.zlogin`   | Login shell, setelah `.zshrc` jika interaktif | Inisialisasi setelah konfigurasi startup utama              |
| `.zlogout`  | Ketika login shell keluar                     | Pekerjaan saat logout                                       |

Hal yang perlu diingat:

- `.zshenv` bukan tempat ideal untuk konfigurasi berat karena dijalankan pada setiap shell Zsh.
- `.zshrc` merupakan tempat utama konfigurasi interaktif.
- `.zprofile` dan `.zlogin` berhubungan dengan login shell, tetapi berada pada posisi berbeda dalam urutan startup.
- `.zlogout` bukan file untuk konfigurasi saat shell dimulai; file ini berkaitan dengan keluarnya login shell.

Nama file tersebut merupakan konvensi startup yang dipahami Zsh. Anda tidak harus membuat semuanya jika tidak memiliki kebutuhan untuk menggunakannya.

## 09.3 Urutan startup yang sebenarnya

Secara umum, urutan startup Zsh adalah:

1\. `.zshenv`

Dibaca oleh setiap shell Zsh

2\. `.zprofile`

Hanya jika login shell

3\. `.zshrc`

Hanya jika interactive shell

Kedua file tersebut dibaca sesuai kondisi shell; keduanya dapat dijalankan dalam satu sesi.

4\. `.zlogin`

Dibaca jika login shell, setelah `.zshrc` bila shell juga interaktif

Ketika login shell keluar: `.zlogout`

Tahap logout, bukan bagian dari urutan startup

Urutan itu menjelaskan mengapa `.zprofile` tidak selalu dijalankan sebelum `.zshrc`: jika shell bukan login shell, `.zprofile` dilewati. Sebaliknya, `.zshrc` dilewati jika shell noninteraktif.

## 09.4 Mengidentifikasi jenis shell

Zsh menyediakan kondisi untuk memeriksa sifat shell saat ini:

```bash
if [[ -o login ]]; then
    print -r -- "Login shell"
fi

if [[ -o interactive ]]; then
    print -r -- "Interactive shell"
fi
```

Anda juga dapat memeriksa jenis shell melalui beberapa cara berbeda.

| Perintah                     | Tujuan                                            |
| ---------------------------- | ------------------------------------------------- |
| `[[ -o login ]]`             | Memeriksa apakah shell merupakan login shell      |
| `[[ -o interactive ]]`       | Memeriksa apakah shell interaktif                 |
| `print -r -- "$ZSH_VERSION"` | Menampilkan versi Zsh                             |
| `print -r -- "$ZDOTDIR"`     | Menampilkan nilai `ZDOTDIR` jika telah ditetapkan |

Untuk menguji kondisi shell tanpa mengubah konfigurasi, jalankan:

```bash
zsh -c '[[ -o interactive ]] && print interactive || print noninteractive'
```

Lalu bandingkan dengan:

```bash
zsh -ic '[[ -o interactive ]] && print interactive || print noninteractive'
```

Opsi `-c` menjalankan perintah yang diberikan. Opsi `-i` meminta shell berjalan secara interaktif. Karena pengujian ini dilakukan pada proses Zsh baru, hasilnya tidak mengubah jenis shell yang sedang Anda gunakan.

## 09.5 Peran `$ZDOTDIR`

Secara default, Zsh mencari file startup di direktori home. Parameter `$ZDOTDIR` memungkinkan Anda mengarahkan pencarian tersebut ke direktori lain.

Contoh:

```bash
ZDOTDIR="$HOME/.config/zsh"
```

Jika nilai ini telah tersedia saat Zsh mulai, file startup dapat ditempatkan di:

```bash
~/.config/zsh/
├── .zshenv
├── .zprofile
├── .zshrc
├── .zlogin
└── .zlogout
```

Ada detail penting: jika Anda menetapkan `ZDOTDIR` hanya di dalam `.zshrc`, Zsh sudah harus menemukan dan membaca `.zshrc` terlebih dahulu. Karena itu, cara tersebut tidak dapat dengan sendirinya mengarahkan lokasi awal `.zshrc` yang sedang dicari.

Untuk konfigurasi yang menggunakan `~/.config/zsh`, pengaturan awal lokasi startup perlu direncanakan dengan hati-hati—misalnya melalui lingkungan yang diwariskan oleh proses pemanggil atau mekanisme awal yang dapat ditemukan Zsh. Jangan langsung memindahkan file startup yang aktif tanpa memastikan bagaimana shell Anda menemukannya.

## 09.6 Apa yang sebaiknya ditempatkan di setiap file?

Untuk membangun konfigurasi yang mudah dipelihara, gunakan pembagian tanggung jawab berikut sebagai titik awal.

```bash
.zshenv
└── Variabel lingkungan yang diperlukan oleh semua jenis shell

.zprofile
└── Inisialisasi khusus sesi login

.zshrc
├── setopt
├── alias dan fungsi interaktif
├── prompt
├── completion
├── keybinding / ZLE
└── integrasi terminal interaktif

.zlogin
└── Inisialisasi login yang memang perlu dilakukan setelah .zshrc

.zlogout
└── Pekerjaan yang diperlukan ketika login shell keluar
```

Hindari menaruh inisialisasi berat di `.zshenv`, terutama perintah yang memanggil banyak program eksternal. Shell noninteraktif yang hanya menjalankan satu perintah tetap dapat membaca file ini; pekerjaan tambahan yang tidak diperlukan dapat memperlambat proses tersebut atau memengaruhi script lain.

Prinsip utamanya: tempatkan konfigurasi berdasarkan kapan konfigurasi itu dibutuhkan, bukan sekadar berdasarkan jenis pengaturannya.

## Langkah praktik

Sebelum kita masuk ke konfigurasi modular, pahami dulu startup shell yang benar-benar digunakan sistem Anda. Jalankan perintah berikut di terminal Zsh Anda:

```bash
print -r -- "Zsh version: $ZSH_VERSION"
print -r -- "ZDOTDIR: ${ZDOTDIR:-<belum ditetapkan>}"

[[ -o login ]] && print -r -- "Login: yes" || print -r -- "Login: no"
[[ -o interactive ]] && print -r -- "Interactive: yes" || print -r -- "Interactive: no"
```

Perintah ini hanya membaca keadaan shell dan mencetak informasi; tidak mengubah file konfigurasi.

Pelajaran berikutnya dalam topik ini akan membahas bagaimana startup files memuat konfigurasi modular, termasuk perbedaan `source` dan `autoload` dalam struktur konfigurasi, cara memisahkan options, alias, fungsi, dan integrasi, serta bagaimana menghindari pemuatan berulang yang tidak diperlukan.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**
> - **[Daftar Teknologi][tekno]**

[tekno]: ../../../../../README.md
[domain]: ../../../../../../README.md
[kurikulum]: ../zsh_scripting.md
[sebelumnya]: ../bagian-9/README.md
[selanjutnya]: ../bagian-11/README.md

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

