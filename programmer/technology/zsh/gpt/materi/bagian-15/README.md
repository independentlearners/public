# Lesson 14 — Completion System Zsh

Tujuan pelajaran ini adalah memahami bagaimana Zsh memberikan saran ketika Anda menekan `Tab`, bagaimana sistem completion menemukan fungsi yang sesuai, dan bagaimana mekanisme tersebut dapat diperluas melalui konfigurasi sendiri.

Materi ini mengikuti jalur pembelajaran dalam Beralih Ke Zsh.txt, khususnya tahap interactive Zsh dan pengenalan internal completion system.&#x20;

Beralih Ke Zsh.txt



## 1. Apa itu completion system?

Completion adalah mekanisme yang membantu Zsh melengkapi input berdasarkan konteks command line.

Misalnya, ketika Anda mengetik:

```
cd ~/Doc
```

lalu menekan `Tab`, Zsh dapat melengkapi nama direktori menjadi `Documents`, jika cocok dan tersedia.

Contoh lain:

```
git che<Tab>
```

Zsh dapat menawarkan subcommand Git seperti `checkout`, tergantung pada completion yang terpasang dan versi Git yang digunakan.

Completion bukan sekadar pencocokan nama file. Sistem ini dapat memahami beberapa jenis konteks:

- Filename completion: nama file dan direktori.
- Command completion: nama command yang tersedia.
- Argument completion: argumen yang valid untuk command tertentu.
- Contextual completion: subcommand, opsi, branch Git, dan nilai lain sesuai konteks.

## 2. Cara kerja completion

Secara konseptual, alurnya seperti ini:

Anda menekan `Tab`

ZLE menerima input dari keyboard

Completion system

Menentukan konteks command line

Completion function

Menghasilkan kandidat yang sesuai

ZLE menampilkan atau memasukkan hasil

Command line belum otomatis dijalankan

Ada tiga konsep yang perlu dibedakan:

- `ZLE` menangani interaksi dan pengeditan command line.
- `compinit` menginisialisasi completion system.
- Fungsi completion menentukan kandidat yang sesuai dengan konteks.

## 3. Menginisialisasi completion dengan `compinit`

Pada konfigurasi Zsh, completion system biasanya diaktifkan menggunakan:

```
autoload -Uz compinit
compinit
```

Penjelasannya:

| Kode       | Fungsi                                           |
| ---------- | ------------------------------------------------ |
| `autoload` | Menyiapkan fungsi agar dimuat ketika diperlukan. |
| `-U`       | Mencegah alias diperluas ketika fungsi dimuat.   |
| `-z`       | Menggunakan gaya autoload native Zsh.            |
| `compinit` | Fungsi inisialisasi completion system.           |

Mengapa menggunakan `autoload -Uz`? Karena `compinit` merupakan fungsi yang dapat dimuat melalui mekanisme autoload Zsh. Setelah disiapkan, pemanggilan `compinit` menjalankan proses inisialisasinya.

Catatan: `autoload` tidak sama dengan menjalankan fungsi. Baris pertama menyiapkan fungsi; baris kedua memanggilnya.

### Uji di terminal

Jalankan:

```
autoload -Uz compinit
compinit
```

Kemudian coba:

```
cd /usr/lo<Tab>
```

Hasilnya bergantung pada direktori dan kandidat yang tersedia. Jika completion sudah aktif dari konfigurasi Anda, menjalankan `compinit` lagi tidak diperlukan sebagai kebiasaan; hindari inisialisasi berulang tanpa alasan.

## 4. Memahami `$fpath`

Zsh memiliki array khusus bernama `fpath`. Array ini berisi direktori yang digunakan untuk mencari fungsi autoload, termasuk fungsi-fungsi completion.

Lihat isinya:

```
print -rl -- $fpath
```

Opsi `-r` membuat `print` tidak menafsirkan escape sequence, sedangkan `-l` mencetak setiap elemen pada baris tersendiri.

Contoh struktur konseptual:

```
fpath
├── direktori fungsi bawaan atau sistem
├── direktori fungsi completion
└── direktori fungsi kustom pengguna
```

Lokasi sebenarnya bergantung pada sistem dan konfigurasi Anda.

### Menambahkan direktori fungsi kustom

Misalnya, Anda ingin menyimpan fungsi buatan sendiri di:

```
~/.config/zsh/functions/
```

Tambahkan direktori tersebut ke `fpath` sebelum memanggil `compinit`:

```
fpath=("$HOME/.config/zsh/functions" $fpath)

autoload -Uz compinit
compinit
```

Karena `fpath` merupakan array, kita dapat menambahkan direktori di awal array. Ini membuat Zsh dapat mencari fungsi kustom melalui jalur tersebut.

Direktori dalam `fpath` harus Anda kendalikan. File di dalamnya berisi kode yang dapat dijalankan oleh shell ketika dimuat. `compinit` juga dapat memberikan peringatan terkait permission direktori completion yang dianggap tidak aman.

## 5. Mengenal fungsi completion

Completion untuk command tertentu biasanya ditangani oleh fungsi khusus.

Contoh nama fungsi yang mungkin Anda temui:

| Fungsi       | Peran umum                                             |
| ------------ | ------------------------------------------------------ |
| `_files`     | Membantu melengkapi file dan direktori.                |
| `_git`       | Menangani completion untuk Git.                        |
| `_arguments` | Membantu fungsi completion memproses argumen dan opsi. |

Nama-nama tersebut merupakan bagian dari sistem completion, bukan command terminal biasa yang perlu dijalankan setiap kali Anda ingin menggunakan `Tab`.

Anda dapat memeriksa apakah fungsi tersedia:

```
whence -v _git
```

Jika fungsi telah dimuat dan ingin memeriksa definisinya:

```
functions _git
```

Jika `_git` belum dimuat, hasil pemeriksaan definisi dapat berbeda. Jangan menganggap kegagalan menampilkan isi fungsi berarti completion Git pasti tidak tersedia.

## 6. Menghubungkan fungsi dengan command menggunakan `compdef`

`compdef` digunakan untuk menghubungkan fungsi completion dengan command tertentu.

Contoh:

```
compdef _git git
```

Secara konseptual, pernyataan tersebut mengatakan kepada completion system agar menggunakan `_git` untuk completion command `git`.

Namun, fungsi `_git` harus tersedia ketika pemetaan dibuat. Completion system juga harus sudah diinisialisasi.

Jadi, jangan menambahkan pemetaan ini secara membabi buta ke konfigurasi tanpa memastikan urutan pemuatan fungsi dan inisialisasinya.

## 7. Menyusun `completion.zsh` secara modular

Karena konfigurasi Anda menggunakan struktur modular, completion dapat ditempatkan dalam file tersendiri.

Contoh:

```
~/.config/zsh/
├── zshrc
├── options.zsh
├── aliases.zsh
├── completion.zsh
└── functions/
```

Isi `completion.zsh`:

```
# Tambahkan direktori fungsi kustom sebelum inisialisasi.
fpath=("$HOME/.config/zsh/functions" $fpath)

# Siapkan fungsi inisialisasi completion.
autoload -Uz compinit

# Aktifkan completion system.
compinit
```

Kemudian, dalam `zshrc`, muat file tersebut:

```
if [[ -r "$HOME/.config/zsh/completion.zsh" ]]; then
    source "$HOME/.config/zsh/completion.zsh"
fi
```

Pemeriksaan `[[ -r ... ]]` memastikan file tersedia dan dapat dibaca sebelum dimuat.

Urutan ini penting:

1. Tambahkan direktori fungsi ke `fpath`.
2. Jalankan `compinit`.
3. Muat konfigurasi lain yang bergantung pada completion system.

Pengecualian penting: plugin manager atau framework Zsh mungkin sudah menginisialisasi completion. Jika demikian, jangan otomatis menjalankan `compinit` kedua kali. Periksa bagaimana konfigurasi Anda saat ini mengelolanya.

## 8. Praktik pemeriksaan

Jalankan perintah berikut satu per satu di terminal Zsh interaktif:

```
# Periksa direktori pencarian fungsi.
print -rl -- $fpath

# Periksa fungsi inisialisasi.
whence -v compinit

# Periksa fungsi completion Git.
whence -v _git

# Periksa pemetaan completion Git.
whence -v compdef

# Lihat informasi tentang fungsi yang telah dimuat.
functions _git
```

Perintah terakhir dapat menampilkan banyak kode. Jika fungsi belum dimuat, hasilnya mungkin tidak menunjukkan definisi.

Selanjutnya, uji completion langsung:

```
git che<Tab>
```

Perhatikan apakah Zsh melengkapi input, menampilkan daftar kandidat, atau tidak menghasilkan apa pun. Perbedaan tersebut dapat membantu menentukan apakah masalahnya berkaitan dengan konteks, fungsi completion, atau inisialisasi.

## 9. Batas materi Lesson 14

Untuk saat ini, Anda cukup memahami fondasi berikut:

- `compinit` menginisialisasi completion system.
- `fpath` menentukan lokasi pencarian fungsi autoload.
- Fungsi seperti `_git` menangani completion untuk konteks tertentu.
- `compdef` menghubungkan fungsi completion dengan command.
- File modular harus dimuat dalam urutan yang benar.

Sistem completion Zsh memiliki lapisan yang lebih dalam, termasuk styles, tags, completers, dan completion functions. Lapisan-lapisan itu akan lebih mudah dipelajari setelah mekanisme dasar ini dipahami.&#x20;

Beralih Ke Zsh.txt



Pelajaran berikutnya dalam urutan kurikulum adalah Lesson 15 — ZLE (Zsh Line Editor), yang membahas bagaimana Zsh mengedit command line, mengikat tombol dengan `bindkey`, dan menggunakan widget untuk membuat fitur interaktif sendiri.> - **[Ke Atas](#)**
> - **[Sebelumnya][sebelumnya]**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**
> - **[Daftar Teknologi][tekno]**

[tekno]: ../../../../../README.md
[domain]: ../../../../../../README.md
[kurikulum]: ../zsh_scripting.md
[sebelumnya]: ../bagian-14/README.md
[selanjutnya]: ../bagian-16/README.md
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

