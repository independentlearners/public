## Sorotan Sintaks Dart di Nano Termux

### 1. Periksa Keberadaan File Konfigurasi Sorotan Sintaks Dart Nano

Nano menggunakan file konfigurasi khusus untuk sorotan sintaks. File-file ini biasanya berada di direktori `$HOME/.nano/` atau `$HOME/.config/nano/`. Anda perlu mencari file yang berkaitan dengan Dart, misalnya `dart.nanorc`.

Pertama, periksa apakah file tersebut sudah ada di sistem Anda:

```bash
ls ~/.nano/dart.nanorc
ls ~/.config/nano/dart.nanorc
```

Jika tidak ada, Anda perlu membuatnya.

### 2. Membuat atau Mengunduh File Konfigurasi `dart.nanorc`

Ada dua cara utama untuk mendapatkan file `dart.nanorc`:

#### a. Membuat File Secara Manual

Anda bisa membuat file `dart.nanorc` dan menambahkan aturan sorotan sintaks dasar ke dalamnya. Buka Nano dan buat file baru:

```bash
nano ~/.nano/dart.nanorc
```

Kemudian, salin dan tempel konten berikut ke dalam file. Ini adalah contoh dasar yang bisa Anda kembangkan:

```shell
## Dart syntax highlighting for Nano
syntax "dart" "\.dart$"
color brightwhite "^import "
color brightwhite "^library "
color brightwhite "^part "
color brightwhite "^export "
color brightwhite "^class "
color brightwhite "^abstract "
color brightwhite "^enum "
color brightwhite "^typedef "
color brightwhite "^extension "
color brightwhite "^mixin "
color brightwhite "^factory "
color brightwhite "^void "
color brightwhite "^var "
color brightwhite "^final "
color brightwhite "^const "
color brightwhite "^late "
color brightwhite "^required "
color brightwhite "^covariant "
color brightwhite "^dynamic "
color brightwhite "^null "
color brightwhite "^true "
color brightwhite "^false "
color brightwhite "^as "
color brightwhite "^is "
color brightwhite "^assert "
color brightwhite "^await "
color brightwhite "^yield "
color brightwhite "^sync "
color brightwhite "^async "
color brightwhite "^for "
color brightwhite "^while "
color brightwhite "^do "
color brightwhite "^if "
color brightwhite "^else "
color brightwhite "^switch "
color brightwhite "^case "
color brightwhite "^default "
color brightwhite "^break "
color brightwhite "^continue "
color brightwhite "^return "
color brightwhite "^throw "
color brightwhite "^try "
color brightwhite "^catch "
color brightwhite "^finally "
color brightwhite "^rethrow "
color brightwhite "^with "
color brightwhite "^implements "
color brightwhite "^extends "
color brightwhite "^super "
color brightwhite "^this "
color brightwhite "^new "
color brightwhite "^get "
color brightwhite "^set "
color brightwhite "^static "
color brightwhite "^external "
color brightwhite "^operator "
color brightwhite "^sealed "
color brightwhite "^interface "
color brightwhite "^base "
color brightwhite "^override "
color brightwhite "^covariant "
color brightwhite "^part of "

color brightmagenta "(class|abstract|enum|typedef|extension|mixin|factory|void|var|final|const|late|required|covariant|dynamic|null|true|false|as|is|assert|await|yield|sync|async|for|while|do|if|else|switch|case|default|break|continue|return|throw|try|catch|finally|rethrow|with|implements|extends|super|this|new|get|set|static|external|operator|sealed|interface|base|override|covariant|part of)"

color brightgreen ""(.*?)"|'(.*?)'"
color brightred "//.*"
color brightred "/\*.*\*/"
color brightblue "[0-9]+"
```

Atau

```shell
syntax "dart" "\.dart$"

# Multiline Strings (triple quotes)
color magenta start='"""' end='"""'
color magenta start="'''" end="'''"

# Single-line Strings
color magenta "\"(\\\\.|[^\"])*\""
color magenta "'(\\\\.|[^'])*'"

# Komentar
color green "//.*"
color green start="/\\" end="\\/"

# Kata Kunci Dart (lengkap)
color blue "\<(abstract|as|assert|async|await|break|case|catch|class|const|continue|covariant|default|deferred|do|dynamic|else|enum|export|extends|extension|external|factory|false|final|finally|for|Function|get|hide|if|implements|import|in|interface|is|late|library|mixin|new|null|on|operator|part|required|rethrow|return|set|show|static|super|switch|sync|this|throw>

# Tipe Data dan Kelas Bawaan
color cyan "\<(int|double|num|bool|String|List|Map|Set|Iterable|Future|Stream|Duration|DateTime|RegExp|Type|Symbol|Object|dynamic|Never)\>"

# Angka (termasuk eksponensial dan hex)
color brightblue "\b-?(0x)?\d+([\.]\d+)?([eE][+-]?\d+)?\b"

# Anotasi
color yellow "@[a-zA-Z_][a-zA-Z0-9_]*"

# Fungsi dan Identifier Umum
color brightcyan "\<(print|main|toString|hashCode|runtimeType|add|remove|contains|forEach|length)\>"
```

Simpan file (`Ctrl+O`, lalu `Enter`, lalu `Ctrl+X`).

#### b. Mengunduh dari Repositori GitHub

Beberapa repositori GitHub menyediakan file `.nanorc` untuk berbagai bahasa. Anda bisa mencari "dart nanorc" di GitHub dan mengunduh file yang sesuai. Pastikan untuk menempatkannya di direktori konfigurasi Nano Anda (misalnya, `~/.nano/`).

Anda bisa menggunakan `wget` atau `curl` untuk mengunduhnya langsung ke Termux jika Anda menemukan URL mentah (raw URL) file tersebut. Contoh:

```bash
wget -O ~/.nano/dart.nanorc https://raw.githubusercontent.com/username/repo/branch/dart.nanorc # Ganti URL ini dengan URL yang benar
```

### 3. Mengaktifkan Sorotan Sintaks Dart di Konfigurasi Nano Utama

Setelah Anda memiliki file `dart.nanorc`, Anda perlu memberi tahu Nano untuk menggunakannya. Ini dilakukan dengan menambahkan baris `include` ke file konfigurasi Nano utama Anda, yaitu `~/.nanorc`.

Buka file `~/.nanorc` di Nano:

```bash
nano ~/.nanorc
```

Tambahkan baris berikut di akhir file:

```nanorc
include "~/.nano/dart.nanorc"
```

Jika Anda menempatkan `dart.nanorc` di `~/.config/nano/`, sesuaikan baris `include` menjadi:

```nanorc
include "~/.config/nano/dart.nanorc"
```

Simpan file (`Ctrl+O`, lalu `Enter`, lalu `Ctrl+X`).

### 4. Uji Coba

Sekarang, buka kembali file Dart Anda di Nano:

```bash
nano nama_file_anda.dart
```

Anda seharusnya sudah melihat sorotan sintaks untuk kode Dart Anda.

### Ringkasan Langkah-langkah:

1.  **Periksa keberadaan `dart.nanorc`**: Gunakan `ls ~/.nano/dart.nanorc` atau `ls ~/.config/nano/dart.nanorc`.
2.  **Buat atau Unduh `dart.nanorc`**:
    - **Manual**: `nano ~/.nano/dart.nanorc` dan tempel kode konfigurasi.
    - **Unduh**: Gunakan `wget` atau `curl` dari GitHub.
3.  **Aktifkan di `~/.nanorc`**: Buka `nano ~/.nanorc` dan tambahkan `include "~/.nano/dart.nanorc"` (atau path yang sesuai).
4.  **Uji Coba**: Buka file `.dart` di Nano.

Dengan mengikuti langkah-langkah ini, Anda seharusnya dapat mengaktifkan sorotan sintaks untuk Dart di Nano Termux Anda. Jika masih ada masalah, pastikan Anda telah menyimpan perubahan di semua file konfigurasi dan bahwa nama file serta jalur yang Anda gunakan sudah benar.
