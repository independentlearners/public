# Pelajaran 17 — Modular Configuration di Zsh

Tujuan pelajaran ini adalah memahami cara membagi konfigurasi Zsh menjadi beberapa file yang memiliki tanggung jawab berbeda, bagaimana file-file itu dimuat, dan bagaimana menghindari masalah akibat urutan pemuatan.

Ini berhubungan langsung dengan struktur `~/.config/zsh/` yang digunakan dalam pengembangan dotfiles.

## 1. Apa itu konfigurasi modular?

Konfigurasi modular adalah pendekatan untuk memisahkan konfigurasi besar menjadi sejumlah file berdasarkan fungsinya.

Tanpa modularisasi, seluruh konfigurasi bisa berada dalam satu file:

```
# ~/.zshrc

setopt AUTO_CD
setopt HIST_IGNORE_DUPS

alias ll='ls -lah'

mkcd() {
    mkdir -p -- "$1" && cd -- "$1"
}

autoload -Uz compinit
compinit
```

Kode ini sederhana, tetapi ketika konfigurasi bertambah besar, beberapa masalah mulai muncul:

- Sulit menemukan bagian yang ingin diubah.
- Konfigurasi plugin bercampur dengan alias dan fungsi pribadi.
- Urutan inisialisasi sulit dipahami.
- Kesalahan pada satu bagian lebih sulit dilacak.
- Mengaktifkan atau menonaktifkan fitur tertentu menjadi kurang teratur.

Dengan konfigurasi modular, setiap file memiliki tanggung jawab yang jelas.

`~/.config/zsh/`

`zshrc`

Pengatur utama yang menentukan urutan pemuatan konfigurasi.

`options.zsh`

Mengatur perilaku shell melalui `setopt` dan `unsetopt`.

`history.zsh`

Mengatur lokasi, ukuran, dan perilaku riwayat perintah.

`keybinds.zsh`

Mengatur keymap dan ikatan tombol, termasuk mode vi.

`integrations/`

Menghubungkan program eksternal seperti Git, fzf, zoxide, dan yazi.

Prinsip penting: memisahkan file tidak otomatis membuat konfigurasi lebih baik. Modularisasi baru bermanfaat jika tanggung jawab, dependensi, dan urutan pemuatan setiap file tetap jelas.

## 2. Memahami `source`

Mekanisme utama untuk memuat konfigurasi dari file lain adalah `source`.

Misalnya, buat file berikut:

```
# ~/.config/zsh/options.zsh

setopt AUTO_CD
setopt EXTENDED_GLOB
```

Kemudian, pada file utama:

```
# ~/.config/zsh/zshrc

source "$HOME/.config/zsh/options.zsh"
```

Ketika Zsh menjalankan `source`, isi file tersebut dieksekusi di lingkungan shell yang sedang berjalan. Ini bukan proses shell baru.

Contoh sederhananya:

```
# child.zsh
message="Konfigurasi dimuat"
```

```
# main.zsh
source ./child.zsh
print -r -- "$message"
```

Jika file ditemukan dan berhasil dijalankan, output-nya:

```
Konfigurasi dimuat
```

Variabel `message` tersedia setelah `source` karena file tersebut dijalankan dalam shell yang sama.

Hal ini juga berarti bahwa perubahan opsi, definisi fungsi, alias, dan variabel yang dibuat oleh file konfigurasi dapat memengaruhi shell pemanggilnya.

## 3. Memuat file konfigurasi dengan aman

Tidak semua file konfigurasi harus selalu tersedia. Sebuah integrasi bisa belum dibuat atau sengaja dinonaktifkan.

Untuk memeriksa apakah file dapat dibaca, gunakan `[[ -r ... ]]`.

```
local_config="$HOME/.config/zsh/integrations/git.zsh"

if [[ -r "$local_config" ]]; then
    source "$local_config"
fi
```

Penjelasan:

- `local_config=...` menyimpan lokasi file.
- `[[ -r "$local_config" ]]` memeriksa apakah file tersedia dan dapat dibaca.
- `source` menjalankan file jika kondisi terpenuhi.

Variabel bernama `local_config` pada contoh ini bukan variabel lokal fungsi. Kata `local` hanya bagian dari nama variabel. Untuk membuat variabel lokal sungguhan, gunakan `local` di dalam fungsi.

Pemeriksaan `-r` tidak menjamin isi file bebas dari kesalahan sintaks atau kesalahan saat dieksekusi. Pemeriksaan itu hanya memeriksa keterbacaannya.

### Memuat beberapa file secara terstruktur

Berikut contoh file utama yang lebih teratur:

```
# ~/.config/zsh/zshrc

ZSH_CONFIG="$HOME/.config/zsh"

source "$ZSH_CONFIG/options.zsh"
source "$ZSH_CONFIG/history.zsh"
source "$ZSH_CONFIG/aliases.zsh"
source "$ZSH_CONFIG/functions.zsh"
source "$ZSH_CONFIG/completion.zsh"
source "$ZSH_CONFIG/keybinds.zsh"
source "$ZSH_CONFIG/prompt.zsh"
```

Contoh tersebut mengasumsikan semua file yang disebutkan memang tersedia. Jika file wajib tidak ada, pemuatan dapat menghasilkan error.

Untuk file opsional, gunakan pemeriksaan keterbacaan:

```
integration="$ZSH_CONFIG/integrations/git.zsh"

if [[ -r "$integration" ]]; then
    source "$integration"
fi
```

Anda tidak harus menggunakan pola yang sama untuk semua file. Bedakan file yang wajib ada dari file yang memang opsional.

## 4. Mengapa urutan pemuatan penting?

Anggap konfigurasi memiliki dependensi berikut:

```
environment
    ↓
completion setup
    ↓
plugin yang memerlukan completion
    ↓
keybindings khusus
```

Jika plugin mengharapkan sistem completion sudah aktif, tetapi file plugin dimuat lebih dahulu, hasilnya mungkin tidak sesuai harapan.

Contoh lainnya: jika sebuah fungsi memanggil fungsi lain yang belum didefinisikan atau belum tersedia melalui `autoload`, pemanggilan tersebut dapat gagal.

Karena itu, file utama berfungsi sebagai pengatur urutan inisialisasi, bukan sekadar daftar file.

Ada pula perbedaan penting antara file startup standar dan file modular:

| File                  | Fungsi                                                                                   |
| --------------------- | ---------------------------------------------------------------------------------------- |
| `.zshenv`             | Dibaca oleh hampir setiap jenis proses Zsh; cocok untuk pengaturan lingkungan minimal.   |
| `.zprofile`           | Dibaca oleh shell login, sebelum `.zshrc`.                                               |
| `.zshrc`              | Dibaca oleh shell interaktif.                                                            |
| `.zlogin`             | Dibaca oleh shell login setelah `.zshrc`, jika interaktif.                               |
| `.zlogout`            | Dibaca ketika shell login keluar.                                                        |
| `~/.config/zsh/zshrc` | File konfigurasi buatan sendiri; dimuat sesuai pengaturan startup atau melalui `source`. |

Nama `zshrc` di dalam `~/.config/zsh/` tidak otomatis menjadikannya file startup standar. Yang menentukan adalah konfigurasi startup Zsh dan cara file itu dipanggil.

Dalam lingkungan Anda, `.zshrc` diketahui mengarah ke `~/.config/zsh/zshrc`. Untuk memastikan keadaan saat ini, Anda bisa memeriksa:

```
print -r -- "${ZDOTDIR:-$HOME}"
readlink -f ~/.zshrc
```

Perintah pertama menampilkan direktori startup Zsh yang efektif menurut variabel `ZDOTDIR`, dengan fallback ke `$HOME`. Perintah kedua menampilkan tujuan akhir symlink `.zshrc`.

## 5. Mengapa tidak langsung memuat semua file dengan glob?

Anda mungkin tergoda menulis:

```
for file in "$HOME"/.config/zsh/*.zsh; do
    source "$file"
done
```

Ini bisa digunakan, tetapi memiliki kelemahan arsitektural.

1. Urutan pemuatan mengikuti urutan hasil glob, bukan urutan dependensi yang Anda rancang secara eksplisit.
2. File baru dapat mulai dimuat secara otomatis meskipun belum siap dipakai.
3. File yang memerlukan urutan khusus bisa dimuat terlalu awal.
4. Jika glob tidak cocok dengan file apa pun, perilakunya dipengaruhi oleh opsi Zsh yang aktif.

Untuk konfigurasi utama, daftar eksplisit biasanya lebih mudah dipahami dan di-debug. Pemakaian glob lebih cocok jika Anda memang menginginkan pemuatan otomatis dan sudah menetapkan aturan penamaan serta urutannya.

## 6. Memeriksa konfigurasi tanpa langsung mengubah shell aktif

Sebelum mengedit konfigurasi yang digunakan sehari-hari, periksa sintaks file:

```
zsh -n "$HOME/.config/zsh/zshrc"
```

`-n` meminta Zsh membaca dan memeriksa sintaks tanpa menjalankan perintah dari file tersebut. Namun, ini tidak menguji apakah integrasi berhasil saat dijalankan, dan pemeriksaan terhadap file utama tidak otomatis memeriksa isi file lain yang dimuat melalui `source`.

Untuk menelusuri proses startup, Anda dapat menjalankan:

```
zsh -xlic exit 2> /tmp/zsh-startup.log
```

Arti opsinya:

- `-x`: menampilkan perintah yang dieksekusi sebagai jejak diagnostik.
- `-l`: menjalankan Zsh sebagai shell login.
- `-i`: menjalankannya sebagai shell interaktif.
- `-c exit`: menjalankan perintah `exit` setelah konfigurasi dimuat.
- `2> ...`: menyimpan keluaran diagnostik pada file log.

Perintah ini dapat menjalankan kode startup dan integrasi Anda, jadi gunakan sebagai sesi diagnostik, bukan sebagai pemeriksaan sintaks yang sepenuhnya aman. Log juga bisa berisi informasi sensitif dari konfigurasi.

Untuk membaca log:

```
less /tmp/zsh-startup.log
```

Jangan langsung menghapus atau mengganti konfigurasi lama hanya karena satu pengujian gagal. Cari dahulu file dan perintah yang menghasilkan error.

## 7. Latihan praktik

Buat rancangan modular sederhana terlebih dahulu. Tidak perlu mengubah seluruh konfigurasi dotfiles Anda.

Struktur latihan:

```
~/.config/zsh/
├── zshrc
├── options.zsh
├── aliases.zsh
└── functions.zsh
```

Isi `options.zsh`:

```
setopt AUTO_CD
setopt HIST_IGNORE_DUPS
```

Isi `aliases.zsh`:

```
alias ll='ls -lah'
alias c='clear'
```

Isi `functions.zsh`:

```
mkcd() {
    if (( $# != 1 )); then
        print -u2 -- "Penggunaan: mkcd DIREKTORI"
        return 2
    fi

    mkdir -p -- "$1" && cd -- "$1"
}
```

Isi file utama `zshrc`:

```
ZSH_CONFIG="$HOME/.config/zsh"

source "$ZSH_CONFIG/options.zsh"
source "$ZSH_CONFIG/aliases.zsh"
source "$ZSH_CONFIG/functions.zsh"
```

Setelah memuatnya pada shell uji, verifikasi:

```
setopt | grep -E 'AUTO_CD|HIST_IGNORE_DUPS'
alias ll
whence -v mkcd
```

Jika semuanya sesuai, uji `mkcd` di direktori sementara yang aman.

### Pertanyaan pemahaman

1\. Apa yang terjadi ketika sebuah file konfigurasi dimuat menggunakan source?

File berjalan dalam proses shell baru

Isi file dieksekusi dalam shell yang memanggilnya

File hanya diperiksa sintaksnya

2\. Mengapa urutan source penting?

Agar nama file selalu alfabetis

Karena suatu file dapat bergantung pada konfigurasi yang dimuat sebelumnya

Agar semua variabel otomatis diekspor

3\. Apa fungsi zsh -n?

Menjalankan semua konfigurasi

Memeriksa sintaks tanpa menjalankan perintah dalam file yang diperiksa

Menghapus konfigurasi yang error

Ulangi latihan

Target pelajaran: Anda dapat menjelaskan fungsi `source`, membagi konfigurasi berdasarkan tanggung jawab, menentukan urutan pemuatan, dan memeriksa sintaks tanpa menjalankan konfigurasi.

Pelajaran berikutnya adalah Pelajaran 18 — Arsitektur Plugin Zsh: bagaimana plugin dimuat, apa perbedaan `source` dan `autoload` dalam konteks plugin, serta bagaimana memahami dependensi plugin sebelum mengubahnya.

> - **[Ke Atas](#)**
> - **[Sebelumnya][sebelumnya]**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**
> - **[Daftar Teknologi][tekno]**

[tekno]: ../../../../../README.md
[domain]: ../../../../../../README.md
[kurikulum]: ../zsh_scripting.md
[sebelumnya]: ../bagian-17/README.md
[selanjutnya]: ../bagian-19/README.md

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

