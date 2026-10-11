# Pelajaran 10 — Konfigurasi Zsh Modular

Pada pelajaran sebelumnya, kita mempelajari file startup dan kapan masing-masing dijalankan. Sekarang kita gunakan pemahaman itu untuk menyusun konfigurasi yang terpisah berdasarkan tanggung jawabnya.

Tujuannya bukan sekadar memecah `.zshrc` menjadi banyak file. Tujuan utamanya adalah membuat konfigurasi lebih mudah dibaca, diuji, diperbaiki, dan dikembangkan ketika Anda mulai menambahkan fitur atau mempelajari kode plugin Zsh.

## 10.1 Mengapa konfigurasi perlu modular?

Misalnya, semua pengaturan ditulis langsung dalam satu file:

```bash
~/.zshrc
├── options
├── environment variables
├── aliases
├── functions
├── history
├── completion
├── keybindings
├── prompt
└── integrations
```

Pada konfigurasi kecil, cara ini masih dapat digunakan. Namun, ketika jumlah fungsi dan integrasi bertambah, satu file menjadi lebih sulit dipelihara.

Struktur modular memisahkan bagian-bagian tersebut:

\~/.config/zsh/

`zshrc`

Titik masuk

`options.zsh`

Options

`aliases.zsh`

Alias

`functions/`

Fungsi autoload

`history.zsh`

History

`completion.zsh`

Completion

`integrations/`

Program eksternal

Setiap file memiliki tanggung jawab tertentu. Ketika ada masalah pada completion, misalnya, Anda dapat memeriksa bagian completion tanpa harus membaca seluruh konfigurasi prompt atau alias.

Nama dan pembagian file ini merupakan rancangan yang bisa Anda sesuaikan, bukan struktur wajib dari Zsh.

## 10.2 Memahami `source`

`source` membaca file dan menjalankan isinya di shell yang sedang aktif. Bentuk singkatnya adalah `.`.

Contoh file `options.zsh`:

```
setopt AUTO_CD
setopt EXTENDED_GLOB
```

Kemudian, di file `zshrc`:

```
source "$HOME/.config/zsh/options.zsh"
```

Saat `zshrc` dijalankan, kedua perintah dalam `options.zsh` ikut dijalankan pada shell yang sama.

Artinya, perubahan options tersebut memengaruhi shell pemanggil. Begitu pula definisi fungsi, alias, dan variabel yang dibuat oleh file yang di-source dapat tersedia pada shell tersebut sesuai aturan masing-masing.

Hal penting: `source` bukan proses shell baru. Ia tidak secara otomatis mengisolasi perubahan variabel atau options.

Untuk menguji apakah sebuah file dapat dibaca sebelum memuatnya, Anda dapat menggunakan:

```
local_config="$HOME/.config/zsh/options.zsh"

if [[ -r "$local_config" ]]; then
    source "$local_config"
fi
```

Di sini, pemeriksaan `-r` mencegah pemanggilan `source` jika file tidak dapat dibaca. Variabel `local_config` pada contoh ini bukan variabel lokal fungsi; kata `local` hanya bagian dari nama variabel.

## 10.3 Menyusun file `zshrc` sebagai titik masuk

File utama sebaiknya bertindak sebagai pengatur pemuatan konfigurasi, bukan tempat menampung semua implementasi.

Contoh sederhana:

```
# ~/.config/zsh/zshrc

ZSH_CONFIG="$HOME/.config/zsh"

source "$ZSH_CONFIG/options.zsh"
source "$ZSH_CONFIG/aliases.zsh"
source "$ZSH_CONFIG/history.zsh"
```

Ini menunjukkan pola dasarnya, tetapi masih memiliki keterbatasan: jika salah satu file tidak tersedia, `source` akan gagal dan mengeluarkan pesan error.

Untuk konfigurasi yang lebih tahan terhadap file opsional, buat fungsi pemuat:

```
# ~/.config/zsh/zshrc

ZSH_CONFIG="$HOME/.config/zsh"

load_config() {
    emulate -L zsh

    if [[ -r "$1" ]]; then
        source "$1"
    else
        print -u2 -r -- "Konfigurasi tidak dapat dibaca: $1"
        return 1
    fi
}

load_config "$ZSH_CONFIG/options.zsh" || return
load_config "$ZSH_CONFIG/aliases.zsh" || return
load_config "$ZSH_CONFIG/history.zsh" || return
```

Fungsi ini memeriksa keterbacaan file, memuatnya jika tersedia, dan mengembalikan status kegagalan jika tidak dapat dibaca. `|| return` menghentikan pemrosesan file pemanggil jika pemuatan gagal.

Ada batasan penting: karena `zshrc` di-source oleh shell interaktif, `return` dapat keluar dari file konfigurasi tersebut, tetapi tidak keluar dari seluruh sesi shell. Contoh ini juga menganggap `load_config` dipanggil dari file konfigurasi, bukan sebagai mekanisme pemuatan universal untuk semua jenis file.

Untuk tahap awal, gunakan struktur sederhana terlebih dahulu. Jangan menambahkan abstraksi sebelum Anda memahami manfaatnya.

## 10.4 Kapan menggunakan `source` dan kapan menggunakan `autoload`?

Keduanya memiliki tujuan berbeda.

| Kebutuhan                                                 | Mekanisme        |
| --------------------------------------------------------- | ---------------- |
| Mengaktifkan options saat startup                         | `source`         |
| Memuat alias saat startup                                 | `source`         |
| Memuat pengaturan history                                 | `source`         |
| Menyiapkan konfigurasi completion                         | Umumnya `source` |
| Memuat definisi fungsi saat fungsi pertama kali dipanggil | `autoload`       |
| Menghindari pemuatan semua implementasi fungsi di awal    | `autoload`       |

Misalnya, jika Anda memiliki 30 fungsi tetapi hanya menggunakan lima di antaranya dalam satu sesi, autoload memungkinkan definisi fungsi lainnya ditunda sampai diperlukan.

Pola autoload:

```
fpath=("$HOME/.config/zsh/functions" $fpath)
autoload -Uz mkcd
```

Sebaliknya, jika Anda ingin mengaktifkan alias pada setiap startup interaktif, file alias dapat di-source:

```
source "$HOME/.config/zsh/aliases.zsh"
```

Perlu diperhatikan bahwa autoload menunda pemuatan definisi fungsi, bukan seluruh pekerjaan startup. Penambahan direktori ke `fpath` dan perintah `autoload` itu sendiri tetap dijalankan saat konfigurasi memprosesnya.

## 10.5 Memisahkan konfigurasi berdasarkan tanggung jawab

Contoh pembagian isi file:

`options.zsh`

```
setopt AUTO_CD
setopt EXTENDED_GLOB
setopt HIST_IGNORE_DUPS
```

`aliases.zsh`

```
alias ll='ls -lh'
alias la='ls -A'
```

`history.zsh`

```
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
```

`integrations/git.zsh`

```
if (( $+commands[git] )); then
    alias gs='git status'
fi
```

Contoh terakhir menggunakan `$+commands[git]` untuk memeriksa apakah Zsh mengenali executable bernama `git` melalui mekanisme pencarian perintahnya. Alias hanya dibuat jika perintah itu tersedia.

Ini adalah contoh pembagian tanggung jawab, bukan konfigurasi lengkap yang harus langsung disalin. Pengaturan history, misalnya, juga dapat membutuhkan options yang sesuai. Integrasi eksternal mungkin perlu pemeriksaan tambahan atau mekanisme inisialisasi khusus.

## 10.6 Perhatikan urutan pemuatan

Konfigurasi modular tetap memiliki urutan eksekusi. Pemisahan file tidak otomatis menyelesaikan ketergantungan antarbagian.

Misalnya:

```
zshrc
  │
  ├── options.zsh
  ├── history.zsh
  ├── aliases.zsh
  ├── functions/ (autoload registration)
  ├── completion.zsh
  └── integrations/
```

Urutan ini hanya ilustrasi. Urutan yang benar bergantung pada ketergantungan nyata.

Jika sebuah integrasi memerlukan completion system, completion harus disiapkan terlebih dahulu. Jika sebuah fungsi membutuhkan variabel yang ditetapkan oleh file lain, variabel itu harus tersedia sebelum fungsi dijalankan—atau ketergantungan tersebut perlu ditangani secara eksplisit di dalam fungsi.

Untuk menghindari konfigurasi yang sulit dilacak, biasakan menjawab dua pertanyaan saat membaca setiap file:

1. Apa yang dilakukan file ini ketika dimuat?
2. Apakah file ini bergantung pada sesuatu yang harus dimuat lebih dahulu?

Dua pertanyaan ini juga berguna ketika Anda membaca konfigurasi plugin pihak ketiga.

## 10.7 Latihan praktik

Sebelum mengubah konfigurasi utama, Anda dapat menguji konsep modular di direktori sementara:

```
mkdir -p /tmp/zsh-modular-test

print -r -- 'setopt AUTO_CD' \
    > /tmp/zsh-modular-test/options.zsh

source /tmp/zsh-modular-test/options.zsh

[[ -o AUTO_CD ]] \
    && print -r -- "AUTO_CD aktif"
```

Latihan ini membuat direktori dan file uji di `/tmp`, bukan mengubah konfigurasi Zsh yang sedang digunakan. Perintah terakhir memeriksa apakah option tersebut aktif pada shell saat ini.

Setelah selesai, Anda dapat menghapus direktori latihan secara eksplisit:

```
rm -r -- /tmp/zsh-modular-test
```

Jalankan penghapusan hanya jika direktori tersebut memang masih merupakan direktori latihan yang Anda buat.

## Ringkasan

Konfigurasi modular Zsh dibangun dari tiga prinsip:

- `source` menjalankan konfigurasi dalam shell saat ini.
- `autoload` memisahkan definisi fungsi dan memungkinkan pemuatannya ditunda sampai dibutuhkan.
- Urutan pemuatan harus mengikuti ketergantungan antarkomponen.

Materi berikutnya adalah Pelajaran 11 — Environment Variables & PATH. Kita akan mempelajari perbedaan variabel shell dan variabel lingkungan, cara mengekspor variabel dengan `export`, bagaimana `PATH` menentukan pencarian executable, serta bagaimana menempatkan pengaturan lingkungan pada file startup yang tepat.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**
> - **[Daftar Teknologi][tekno]**

[tekno]: ../../../../../README.md
[domain]: ../../../../../../README.md
[kurikulum]: ../zsh_scripting.md
[sebelumnya]: ../bagian-10/README.md
[selanjutnya]: ../bagian-12/README.md

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

