# Lesson 11 — Environment Variables & PATH

Materi ini masuk ke tahap struktur konfigurasi Zsh. Tujuannya adalah memahami bagaimana variabel diteruskan ke program lain, bagaimana Zsh menemukan executable melalui `PATH`, dan di mana pengaturan tersebut sebaiknya ditempatkan.

## 1. Variabel shell vs environment variable

Keduanya menyimpan nilai, tetapi memiliki perbedaan pada proses yang dapat mengaksesnya.

### Variabel shell biasa

```bash
PROJECT_NAME="zsh-lab"

print -r -- "$PROJECT_NAME"
```

`PROJECT_NAME` tersedia di shell yang sedang berjalan. Namun, variabel tersebut tidak otomatis diwariskan kepada proses anak.

### Environment variable

```bash
export PROJECT_NAME="zsh-lab"

print -r -- "$PROJECT_NAME"
```

`export` menandai variabel agar diwariskan kepada proses anak yang dijalankan oleh shell.

Zsh saat ini

PROJECT_NAME tersedia

Jika variabel diekspor

Proses anak

Menerima PROJECT_NAME dari environment

Contoh pengujian yang dapat dijalankan langsung:

```bash
PROJECT_LOCAL="tidak-diekspor"
export PROJECT_SHARED="diwariskan"

zsh -c 'print -r -- "${PROJECT_LOCAL-unset}"'
zsh -c 'print -r -- "${PROJECT_SHARED-unset}"'
```

Hasilnya:

```bash
unset
diwariskan
```

`zsh -c` menjalankan perintah di proses Zsh baru. Tanda kutip tunggal memastikan ekspansi variabel di dalam perintah dilakukan oleh Zsh anak, bukan shell induk.

Perintah untuk memeriksa variabel:

```bash
print -r -- "$PROJECT_SHARED"
export -p
env
```

- `print` membaca nilai variabel dari shell saat ini.
- `export -p` menampilkan deklarasi variabel yang diekspor.
- `env` menampilkan environment yang diteruskan kepada program.

## 2. Memahami `PATH`

`PATH` adalah environment variable berisi daftar direktori yang dipisahkan tanda titik dua (`:`). Shell mencari executable di direktori-direktori tersebut ketika Anda menjalankan perintah tanpa menyebutkan lokasi lengkapnya.

Misalnya, ketika Anda mengetik:

```bash
git status
```

Zsh mencari executable bernama `git` melalui direktori di `PATH`, kecuali perintah tersebut diselesaikan melalui mekanisme shell lain seperti alias atau fungsi.

Periksa `PATH`:

```bash
print -r -- "$PATH"
```

Dalam Zsh, tersedia array khusus bernama `path` yang terhubung langsung dengan `PATH`.

```bash
print -rl -- $path
```

Opsi `-l` mencetak setiap elemen pada baris tersendiri. Karena `path` merupakan array Zsh, Anda tidak perlu memecah string `PATH` secara manual.

## 3. Menambahkan direktori ke `PATH` dengan cara khas Zsh

Misalnya, Anda ingin menambahkan `~/.local/bin` agar executable pribadi dapat dijalankan tanpa menulis lokasi lengkapnya.

```bash
typeset -U path
path=("$HOME/.local/bin" $path)
```

Mekanismenya:

- `typeset -U path` membuat elemen array `path` unik sehingga duplikat dihilangkan.
- `path=("$HOME/.local/bin" $path)` menempatkan direktori tersebut di awal daftar.
- Karena `path` terhubung dengan `PATH`, perubahan array memperbarui nilai `PATH` juga.

Urutan direktori penting: direktori yang muncul lebih awal biasanya diperiksa lebih dahulu.

Untuk menambahkan direktori di bagian akhir:

```bash
path+=("$HOME/bin")
```

Hindari menambahkan direktori berulang kali tanpa penanganan duplikat, terutama jika pengaturan dijalankan setiap kali shell dimulai.

## 4. Memeriksa executable yang ditemukan Zsh

Gunakan:

```bash
command -v git
whence -va git
```

`command -v` menunjukkan bagaimana perintah diselesaikan. `whence -va` memberikan informasi yang lebih luas, termasuk kemungkinan alias, fungsi, builtin, atau executable.

Untuk melihat apakah direktori tertentu tersedia di `PATH`:

```bash
[[ -d "$HOME/.local/bin" ]] && print -r -- "Direktori tersedia"
```

Perhatikan bahwa direktori yang ada belum tentu berisi executable, dan executable yang tersedia belum tentu dapat dijalankan jika izin atau interpreter-nya bermasalah.

## 5. Di file startup mana `PATH` sebaiknya diatur?

Pemilihan file bergantung pada kapan pengaturan harus tersedia.

| File        | Peran                                                                                |
| ----------- | ------------------------------------------------------------------------------------ |
| `.zshenv`   | Variabel lingkungan yang diperlukan oleh hampir semua proses Zsh; jaga tetap ringan. |
| `.zprofile` | Pengaturan untuk sesi login, termasuk lingkungan sesi jika sesuai.                   |
| `.zshrc`    | Pengaturan shell interaktif, seperti alias, keybind, prompt, dan fitur interaktif.   |
| `.zlogin`   | Pengaturan login yang dijalankan setelah `.zshrc` pada shell login interaktif.       |

Untuk konfigurasi Anda, gunakan aturan praktis berikut:

- Jika variabel harus tersedia untuk skrip Zsh noninteraktif, jangan hanya mengaturnya di `.zshrc`.
- Jika pengaturan hanya untuk kenyamanan terminal interaktif, `.zshrc` adalah tempat yang tepat.
- Jika `PATH` perlu tersedia pada semua proses Zsh, pengaturan dapat ditempatkan di `.zshenv`, tetapi hindari menjalankan program eksternal yang tidak diperlukan di sana.
- Jika pengaturan hanya dibutuhkan pada sesi login, `.zprofile` dapat menjadi pilihan. Ingat, file tersebut tidak dijalankan oleh shell non-login.

Contoh file `~/.config/zsh/options.zsh`:

```bash
setopt AUTO_CD
setopt EXTENDED_GLOB
```

Contoh file `~/.config/zsh/environment.zsh`:

```bash
export EDITOR="nvim"
export VISUAL="$EDITOR"

typeset -U path
path=("$HOME/.local/bin" $path)
```

Kemudian, di `zshrc`, muat konfigurasi lingkungan sebelum modul yang menggunakannya:

```bash
ZSH_CONFIG="$HOME/.config/zsh"

if [[ -r "$ZSH_CONFIG/environment.zsh" ]]; then
    source "$ZSH_CONFIG/environment.zsh"
fi

if [[ -r "$ZSH_CONFIG/options.zsh" ]]; then
    source "$ZSH_CONFIG/options.zsh"
fi
```

Catatan penting: contoh ini cocok untuk pengaturan interaktif di `.zshrc`. Jika variabel lingkungan harus tersedia pada semua proses Zsh, muat pengaturan tersebut dari file startup yang sesuai dengan cakupan yang dibutuhkan.

Ada satu koreksi terkait materi sebelumnya: jangan membungkus `source` konfigurasi opsi di dalam fungsi yang menggunakan `emulate -L zsh` jika Anda ingin perubahan opsi dari file tersebut bertahan setelah fungsi selesai. Lingkup lokal opsi dapat menyebabkan perubahan itu dipulihkan ketika fungsi berakhir. Untuk kasus ini, `source` langsung pada tingkat teratas seperti contoh di atas lebih tepat.

## 6. Praktik terarah

Jalankan perintah berikut satu per satu pada terminal Zsh:

```bash
# 1. Variabel shell biasa
LESSON_VAR="local-value"

# 2. Variabel yang diwariskan
export LESSON_ENV="exported-value"

# 3. Bandingkan dari proses anak
zsh -c 'print -r -- "${LESSON_VAR-unset}"'
zsh -c 'print -r -- "${LESSON_ENV-unset}"'

# 4. Periksa PATH
print -rl -- $path

# 5. Periksa lokasi executable
command -v zsh
command -v git
```

Anda seharusnya melihat `unset` untuk variabel pertama dan `exported-value` untuk variabel kedua, kecuali ada konfigurasi lain yang mengubah lingkungan proses anak.

Tidak ada perubahan permanen pada file konfigurasi dalam latihan ini.

## Inti pelajaran

Ada tiga mekanisme yang perlu Anda pahami sebelum melanjutkan:

1. Variabel shell menyimpan data dalam shell saat ini; `export` membuatnya tersedia melalui environment bagi proses anak.
2. `PATH` menentukan direktori pencarian executable, sedangkan array khusus Zsh `path` memudahkan pengelolaannya.
3. File startup menentukan kapan pengaturan dimuat. Lokasi konfigurasi harus sesuai dengan cakupan proses yang memerlukannya.

Materi berikutnya adalah Lesson 12 — History, termasuk `HISTFILE`, `HISTSIZE`, `SAVEHIST`, opsi history, dan bagaimana Zsh menyimpan serta membagikan riwayat perintah.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**
> - **[Daftar Teknologi][tekno]**

[tekno]: ../../../../../README.md
[domain]: ../../../../../../README.md
[kurikulum]: ../zsh_scripting.md
[sebelumnya]: ../bagian-11/README.md
[selanjutnya]: ../bagian-13/README.md

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

