# **Materi 5 — Zsh Internals untuk Customization**
Ini adalah materi yang membuat Anda tidak hanya *memakai* Zsh, tetapi *memahami mekanisme di balik plugin* dan mampu memodifikasi atau membuat fitur sendiri.

Tetap di jalur kurikulum. Kita belum masuk ke **Materi 6 — Productivity Engineering**. Fokus sekarang: completion system, ZLE internals, widgets, hooks, autoload functions, `zmodload`, modules, dan alur `plugin → source code → Zsh mechanism → modify → custom feature`.

---

# Materi 5 — Zsh Internals untuk Customization

## 5.1 Zsh Completion System (compsys)

Completion system Zsh disebut **compsys**. Ia adalah kumpulan fungsi, mekanisme, dan konfigurasi yang membuat Tab completion bekerja.

### 5.1.1 compinit

```zsh
autoload -Uz compinit
compinit
```

Penjelasan kata demi kata:

- `autoload` — builtin Zsh. Menandai bahwa `compinit` adalah fungsi yang akan dimuat dari file di `$fpath` saat pertama kali dipanggil.
- `-U` — jangan lakukan alias expansion saat memuat fungsi. Ini mencegah konflik jika Anda punya alias yang namanya mirip.
- `-z` — gunakan format Zsh native, bukan format Ksh emulation.
- `compinit` — nama fungsi yang di-autoload. Fungsi ini ada di `$fpath`, biasanya di `/usr/share/zsh/functions/Completion/Base/Core/compinit`.
- `compinit` — panggil fungsi. Ia akan memindai `$fpath`, mencari semua fungsi completion, dan membuat file `~/.zcompdump`.

`compinit` hanya perlu dijalankan sekali per shell interaktif. Biasanya diletakkan di `.zshrc` atau `completion.zsh`.

### 5.1.2 fpath

```zsh
fpath=($ZDOTDIR/completion $fpath)
```

Penjelasan:

- `fpath` — array direktori tempat Zsh mencari fungsi autoload, termasuk fungsi completion.
- `=(...)` — assignment array.
- `$ZDOTDIR/completion` — direktori pribadi untuk fungsi completion Anda.
- `$fpath` — nilai lama `fpath`, sehingga direktori sistem tetap ada.
- Urutan penting: direktori pribadi di depan agar fungsi Anda menimpa fungsi sistem.

### 5.1.3 zstyle

`zstyle` adalah cara mengonfigurasi completion. Ia menggunakan pola hierarkis.

```zsh
zstyle ':completion:*' menu select
```

Penjelasan kata demi kata:

- `zstyle` — builtin Zsh untuk mengatur style.
- `':completion:*'` — pattern. Tanda kutip tunggal agar `*` tidak diekspansi oleh shell.
- `:completion:*` — konteks. `:completion:` adalah top-level untuk completion. `*` berarti semua subkonteks.
- `menu` — nama style.
- `select` — nilai style.
- Efek: menu completion diaktifkan, dan item bisa dipilih dengan panah.

Style lain:

```zsh
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
```

Penjelasan:

- `matcher-list` — style untuk pencocokan.
- `'m:{a-zA-Z}={A-Za-z}'` — matcher. `m:` berarti matcher. `{a-zA-Z}` dan `{A-Za-z}` adalah kelas karakter. Ini membuat completion case-insensitive.

```zsh
zstyle ':completion:*' list-colors ''
```

Penjelasan:

- `list-colors` — style untuk warna daftar completion.
- `''` — gunakan warna default `ls`.

### 5.1.4 Tags

Tags adalah kategori kandidat completion. Contoh: `files`, `directories`, `options`, `commands`, `parameters`.

```zsh
zstyle ':completion:*:descriptions' format '%F{yellow}%d%f'
```

Penjelasan:

- `:completion:*:descriptions` — konteks untuk deskripsi.
- `format` — style untuk format tampilan.
- `%F{yellow}` — mulai warna kuning.
- `%d` — deskripsi tag.
- `%f` — reset warna.

### 5.1.5 Completers

Completer adalah fungsi yang menghasilkan kandidat. Contoh: `_complete`, `_approximate`, `_expand`, `_history`.

```zsh
zstyle ':completion:*' completer _complete _approximate
```

Penjelasan:

- `completer` — style untuk daftar completer.
- `_complete` — completer normal.
- `_approximate` — completer untuk typo.

### 5.1.6 Completion Function Sederhana

Buat file `~/.config/zsh/completion/_hello`:

```zsh
#compdef hello

_hello() {
    local -a names
    names=(
        'dunia:Menyapa dunia'
        'zsh:Menyapa Zsh'
        'bash:Menyapa Bash'
    )
    _describe 'sapaan' names
}
```

Penjelasan kata demi kata:

- `#compdef hello` — baris pertama. Memberi tahu compsys bahwa fungsi ini untuk perintah `hello`.
- `_hello() {` — definisi fungsi completion. Konvensi nama: underscore diikuti nama perintah.
- `local -a names` — deklarasikan array lokal `names`.
- `names=(` — mulai assignment array.
- `'dunia:Menyapa dunia'` — item pertama. Format `nilai:deskripsi`.
- `'zsh:Menyapa Zsh'` — item kedua.
- `'bash:Menyapa Bash'` — item ketiga.
- `)` — akhir array.
- `_describe 'sapaan' names` — builtin completion untuk menampilkan array `names` dengan label `sapaan`.
- `}` — akhir fungsi.

Setelah file ini ada di `$fpath`, jalankan `compinit` ulang. Ketik `hello <Tab>` dan Anda akan melihat pilihan.

### 5.1.7 compdef

```zsh
compdef _hello hello
```

Penjelasan:

- `compdef` — builtin untuk mendaftarkan fungsi completion ke perintah.
- `_hello` — nama fungsi completion.
- `hello` — nama perintah.
- Efek: `hello` menggunakan `_hello` untuk completion.

Jika Anda sudah menulis `#compdef hello` di file, `compinit` akan otomatis mendaftarkannya. `compdef` berguna untuk pendaftaran manual.

---

## 5.2 ZLE Internals

ZLE adalah **Zsh Line Editor**. Ia menangani input keyboard di prompt. Memahami ZLE berarti memahami bagaimana tombol, keymap, widget, dan buffer bekerja.

### 5.2.1 Arsitektur ZLE

```text
Keyboard
   ↓
Keymap
   ↓
Widget
   ↓
Buffer / Cursor / History
```

- **Keymap** — pemetaan tombol ke widget.
- **Widget** — fungsi yang melakukan aksi.
- **Buffer** — isi baris saat ini.
- **Cursor** — posisi kursor.

### 5.2.2 Variabel ZLE

Di dalam widget, Anda bisa mengakses variabel khusus:

- `BUFFER` — seluruh isi baris.
- `CURSOR` — posisi kursor (integer).
- `LBUFFER` — bagian kiri buffer sampai kursor.
- `RBUFFER` — bagian kanan buffer dari kursor.
- `PREDISPLAY` — teks yang ditampilkan sebelum buffer.
- `POSTDISPLAY` — teks yang ditampilkan setelah buffer.
- `KEYS` — tombol yang ditekan.
- `WIDGET` — nama widget yang sedang dijalankan.

Contoh:

```zsh
my_widget() {
    echo "BUFFER=$BUFFER" >&2
    echo "CURSOR=$CURSOR" >&2
    echo "LBUFFER=$LBUFFER" >&2
    echo "RBUFFER=$RBUFFER" >&2
}
```

Penjelasan:

- `echo "..." >&2` — cetak ke stderr agar tidak mengganggu buffer.
- `$BUFFER` — seluruh baris.
- `$CURSOR` — posisi kursor.
- `$LBUFFER` — kiri kursor.
- `$RBUFFER` — kanan kursor.

### 5.2.3 zle Builtin

```zsh
zle -N my_widget
```

Penjelasan:

- `zle` — builtin untuk mengelola ZLE.
- `-N` — buat widget baru dari fungsi `my_widget`.
- `my_widget` — nama fungsi dan nama widget.

Opsi lain:

- `zle -A old new` — alias widget. `new` akan memanggil `old`.
- `zle -D widget` — hapus widget.
- `zle -l` — daftar widget.
- `zle -L` — daftar widget dengan definisi.
- `zle -R` — refresh tampilan.
- `zle widget` — panggil widget dari dalam widget lain.

Contoh memanggil widget bawaan:

```zsh
my_widget() {
    zle accept-line
}
```

Penjelasan:

- `zle accept-line` — panggil widget `accept-line` (seperti menekan Enter).

### 5.2.4 Widget Kustom Lengkap

```zsh
insert_date() {
    LBUFFER="${LBUFFER}$(date +%Y-%m-%d)"
    zle reset-prompt
}

zle -N insert_date
bindkey '^D' insert_date
```

Penjelasan:

- `insert_date() {` — definisi fungsi.
- `LBUFFER="${LBUFFER}$(date +%Y-%m-%d)"` — tambahkan tanggal ke kiri buffer.
  - `${LBUFFER}` — nilai kiri buffer.
  - `$(date +%Y-%m-%d)` — command substitution. Jalankan `date` dengan format `%Y-%m-%d`.
- `zle reset-prompt` — segarkan prompt.
- `}` — akhir fungsi.
- `zle -N insert_date` — daftarkan sebagai widget.
- `bindkey '^D' insert_date` — ikat `Ctrl+D` ke widget.

---

## 5.3 Widgets

Widget adalah unit aksi di ZLE. Ada dua jenis: bawaan dan kustom.

### 5.3.1 Widget Bawaan Penting

- `accept-line` — jalankan perintah.
- `self-insert` — sisipkan karakter.
- `backward-delete-char` — hapus karakter sebelum kursor.
- `delete-char` — hapus karakter di kursor.
- `beginning-of-line` — awal baris.
- `end-of-line` — akhir baris.
- `kill-line` — hapus sampai akhir baris.
- `kill-whole-line` — hapus seluruh baris.
- `up-line-or-history` — history sebelumnya.
- `down-line-or-history` — history berikutnya.
- `history-incremental-search-backward` — pencarian history mundur.
- `history-incremental-search-forward` — pencarian history maju.
- `undo` — urungkan.
- `redo` — ulangi.
- `clear-screen` — bersihkan layar.
- `redisplay` — tampilkan ulang.
- `reset-prompt` — segarkan prompt.
- `expand-or-complete` — completion.
- `menu-complete` — completion menu.
- `reverse-menu-complete` — completion menu mundur.

### 5.3.2 Widget yang Memanipulasi Buffer

```zsh
uppercase_word() {
    local word
    word="${LBUFFER##* }"
    LBUFFER="${LBUFFER%$word}${(U)word}"
}

zle -N uppercase_word
bindkey '^U' uppercase_word
```

Penjelasan:

- `local word` — deklarasikan variabel lokal.
- `word="${LBUFFER##* }"` — ambil kata terakhir dari `LBUFFER`.
  - `${LBUFFER##* }` — hapus prefix terpanjang yang cocok dengan `* ` (apa pun diikuti spasi).
- `LBUFFER="${LBUFFER%$word}${(U)word}"` — ganti kata terakhir dengan versi uppercase.
  - `${LBUFFER%$word}` — hapus suffix `$word` dari `LBUFFER`.
  - `${(U)word}` — uppercase.
- `zle -N uppercase_word` — daftarkan widget.
- `bindkey '^U' uppercase_word` — ikat `Ctrl+U`.

### 5.3.3 Widget yang Menggunakan History

```zsh
last_command() {
    BUFFER="${history[1]}"
    CURSOR=${#BUFFER}
}

zle -N last_command
bindkey '^L' last_command
```

Penjelasan:

- `BUFFER="${history[1]}"` — ambil perintah terakhir dari array `history`.
- `CURSOR=${#BUFFER}` — pindahkan kursor ke akhir.
- `zle -N last_command` — daftarkan.
- `bindkey '^L' last_command` — ikat `Ctrl+L`.

---

## 5.4 Hooks

Hook adalah fungsi yang dipanggil otomatis pada momen tertentu. Di Zsh, hook adalah fungsi dengan nama khusus.

### 5.4.1 preexec

```zsh
preexec() {
    echo "Menjalankan: $1" >&2
}
```

Penjelasan:

- `preexec` — nama hook. Zsh memanggilnya sebelum mengeksekusi perintah.
- `$1` — perintah yang akan dijalankan.
- `$2` — seluruh baris perintah.
- `$3` — seluruh baris tanpa ekspansi.
- `echo ... >&2` — cetak ke stderr.

### 5.4.2 precmd

```zsh
precmd() {
    echo "Siap menerima perintah" >&2
}
```

Penjelasan:

- `precmd` — dipanggil sebelum prompt ditampilkan.
- Berguna untuk memperbarui prompt, cek git, atau menampilkan informasi.

### 5.4.3 chpwd

```zsh
chpwd() {
    echo "Direktori: $PWD" >&2
}
```

Penjelasan:

- `chpwd` — dipanggil setiap kali direktori berubah.
- `$PWD` — direktori saat ini.

### 5.4.4 zshaddhistory

```zsh
zshaddhistory() {
    local cmd="$1"
    [[ "$cmd" == *secret* ]] && return 1
    return 0
}
```

Penjelasan:

- `zshaddhistory` — dipanggil sebelum perintah ditambahkan ke history.
- `local cmd="$1"` — simpan perintah.
- `[[ "$cmd" == *secret* ]]` — cek apakah mengandung `secret`.
- `&& return 1` — jika ya, jangan simpan.
- `return 0` — jika tidak, simpan.

### 5.4.5 period

```zsh
TMOUT=60
period() {
    echo "Idle 60 detik" >&2
}
```

Penjelasan:

- `TMOUT=60` — interval 60 detik.
- `period` — dipanggil setiap interval.

---

## 5.5 Autoload Functions

Autoload memuat fungsi dari file saat pertama dipanggil.

```zsh
fpath=(~/.config/zsh/functions $fpath)
autoload -Uz myfunc
```

Penjelasan:

- `fpath=(...)` — tambahkan direktori fungsi.
- `autoload -Uz myfunc` — tandai `myfunc` untuk dimuat otomatis.
- `-U` — tanpa alias expansion.
- `-z` — format Zsh.

File `~/.config/zsh/functions/myfunc` berisi isi fungsi:

```zsh
echo "Hello dari autoload"
```

Bukan:

```zsh
myfunc() {
    echo "Hello"
}
```

Perbedaan ini penting. File autoload adalah **tubuh fungsi**, bukan definisi.

### 5.5.1 Autoload dengan Argumen

File `greet`:

```zsh
echo "Hello, $1"
```

Setelah `autoload -Uz greet`, panggil:

```zsh
greet "Cendekiawan"
```

Output: `Hello, Cendekiawan`.

### 5.5.2 Autoload untuk Completion

Semua fungsi completion adalah file autoload. Contoh `_git` di `$fpath`.

```zsh
autoload -Uz _git
```

Penjelasan:

- `_git` — fungsi completion untuk `git`.
- Ketika Anda mengetik `git <Tab>`, Zsh memuat `_git` dan menjalankannya.

---

## 5.6 zmodload

`zmodload` adalah builtin untuk memuat modul Zsh. Modul memperluas kemampuan shell.

### 5.6.1 Melihat Modul

```zsh
zmodload -l
```

Penjelasan:

- `zmodload` — builtin.
- `-l` — list. Menampilkan modul yang tersedia.

```zsh
zmodload -L
```

Penjelasan:

- `-L` — tampilkan modul yang sudah dimuat.

### 5.6.2 Memuat Modul

```zsh
zmodload zsh/zprof
```

Penjelasan:

- `zmodload` — builtin.
- `zsh/zprof` — nama modul. Profiler untuk mengukur waktu eksekusi fungsi.

```zsh
zmodload zsh/datetime
```

Penjelasan:

- `zsh/datetime` — modul untuk mengakses waktu dengan presisi tinggi.
- Menyediakan variabel `EPOCHSECONDS`, `EPOCHREALTIME`, dan fungsi `strftime`.

```zsh
zmodload zsh/system
```

Penjelasan:

- `zsh/system` — modul untuk akses sistem tingkat rendah.
- Menyediakan `sysread`, `syswrite`, `sysopen`, `sysseek`.

```zsh
zmodload zsh/parameter
```

Penjelasan:

- `zsh/parameter` — modul untuk mengakses parameter internal Zsh.
- Menyediakan `$functions`, `$commands`, `$options`, `$aliases`, `$builtins`.

```zsh
zmodload zsh/complist
```

Penjelasan:

- `zsh/complist` — modul untuk kontrol daftar completion.
- Memungkinkan navigasi menu completion dengan tombol.

```zsh
zmodload zsh/zutil
```

Penjelasan:

- `zsh/zutil` — modul utilitas.
- Menyediakan `zstyle`, `zparseopts`, `strftime`.

### 5.6.3 Contoh zsh/parameter

```zsh
zmodload zsh/parameter
print -l ${(k)options} | grep GLOB
```

Penjelasan:

- `zmodload zsh/parameter` — muat modul.
- `${(k)options}` — keys dari associative array `options`.
- `print -l` — cetak satu per baris.
- `| grep GLOB` — filter opsi yang mengandung `GLOB`.

### 5.6.4 Contoh zsh/datetime

```zsh
zmodload zsh/datetime
echo $EPOCHSECONDS
echo $EPOCHREALTIME
```

Penjelasan:

- `$EPOCHSECONDS` — detik sejak epoch.
- `$EPOCHREALTIME` — detik dengan pecahan.

---

## 5.7 Modules

Modul adalah library yang bisa dimuat ke Zsh. Modul memperluas shell dengan builtin, parameter, dan fungsi baru.

Jenis modul:

- **Builtin modules** — sudah ada di Zsh, tinggal dimuat.
- **External modules** — dikompilasi terpisah.

Contoh modul penting:

- `zsh/zprof` — profiler.
- `zsh/datetime` — waktu.
- `zsh/system` — sistem.
- `zsh/parameter` — parameter internal.
- `zsh/complist` — completion list.
- `zsh/zutil` — utilitas.
- `zsh/mathfunc` — fungsi matematika.
- `zsh/stat` — stat file.
- `zsh/files` — operasi file builtin.
- `zsh/mapfile` — baca file ke array.
- `zsh/net/socket` — socket.
- `zsh/net/tcp` — TCP.
- `zsh/pcre` — regex PCRE.
- `zsh/regex` — regex POSIX.
- `zsh/terminfo` — terminfo.
- `zsh/zftp` — FTP.
- `zsh/zle` — ZLE.
- `zsh/zpty` — pseudo-terminal.
- `zsh/zselect` — select.
- `zsh/zutil` — utilitas.

### 5.7.1 Contoh zsh/mathfunc

```zsh
zmodload zsh/mathfunc
echo $(( sqrt(16) ))
```

Penjelasan:

- `zmodload zsh/mathfunc` — muat modul.
- `$(( sqrt(16) ))` — aritmetika dengan fungsi `sqrt`.
- Output: `4`.

### 5.7.2 Contoh zsh/stat

```zsh
zmodload zsh/stat
stat -s size -- file.txt
```

Penjelasan:

- `zmodload zsh/stat` — muat modul.
- `stat` — builtin dari modul.
- `-s size` — ambil ukuran file.
- `--` — akhir opsi.
- `file.txt` — file yang diperiksa.

---

## 5.8 Alur: Plugin → Source Code → Zsh Mechanism → Modify → Custom Feature

Ini adalah alur berpikir yang harus Anda bangun.

```text
plugin
   ↓
source code
   ↓
Zsh mechanism
   ↓
modify
   ↓
custom feature
```

### 5.8.1 Membaca Source Code Plugin

Misalnya Anda menggunakan plugin `zsh-autosuggestions`. Anda ingin tahu bagaimana ia bekerja.

Langkah:

1. Cari file plugin:

```zsh
ls ~/.config/zsh/plugins/zsh-autosuggestions
```

2. Baca file utama:

```zsh
less ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
```

3. Cari mekanisme Zsh yang dipakai:

```zsh
grep -n 'zle -N' zsh-autosuggestions.zsh
grep -n 'bindkey' zsh-autosuggestions.zsh
grep -n 'add-zle-hook-widget' zsh-autosuggestions.zsh
```

Penjelasan:

- `grep -n` — cari dengan nomor baris.
- `'zle -N'` — cari pendaftaran widget.
- `'bindkey'` — cari binding tombol.
- `'add-zle-hook-widget'` — cari hook ZLE.

4. Pahami mekanismenya:

- Plugin mendaftarkan widget dengan `zle -N`.
- Plugin mengikat tombol dengan `bindkey`.
- Plugin menggunakan hook seperti `zle-line-pre-redraw` atau `add-zle-hook-widget`.

5. Modifikasi:

- Anda bisa mengubah binding.
- Anda bisa menambah widget sendiri.
- Anda bisa mematikan bagian tertentu.

6. Buat fitur sendiri:

- Ambil ide dari plugin.
- Gunakan mekanisme Zsh yang sama.
- Tulis widget Anda sendiri.

### 5.8.2 Contoh: Meniru Autosuggestion Sederhana

```zsh
autosuggest() {
    local last="${history[1]}"
    if [[ -n "$last" && "$BUFFER" == "${last:0:${#BUFFER}}" ]]; then
        POSTDISPLAY="${last:${#BUFFER}}"
    else
        POSTDISPLAY=""
    fi
}

autoload -Uz add-zle-hook-widget
add-zle-hook-widget line-pre-redraw autosuggest
```

Penjelasan:

- `autosuggest()` — widget kustom.
- `local last="${history[1]}"` — ambil perintah terakhir.
- `if [[ -n "$last" && "$BUFFER" == "${last:0:${#BUFFER}}" ]]` — cek apakah buffer adalah prefix dari perintah terakhir.
- `POSTDISPLAY="${last:${#BUFFER}}"` — tampilkan sisa perintah sebagai teks setelah buffer.
- `else POSTDISPLAY=""` — kosongkan.
- `autoload -Uz add-zle-hook-widget` — muat helper untuk hook ZLE.
- `add-zle-hook-widget line-pre-redraw autosuggest` — panggil `autosuggest` setiap kali ZLE akan menggambar ulang baris.

Ini adalah contoh bagaimana Anda bisa memahami plugin, mengambil mekanismenya, dan membuat fitur sendiri.

---

## 5.9 Ringkasan Materi 5

- Completion system (compsys) dikonfigurasi dengan `compinit`, `zstyle`, `compdef`, dan fungsi completion.
- `fpath` menentukan lokasi fungsi autoload dan completion.
- `zstyle` mengatur perilaku completion berdasarkan konteks.
- Completion function ditulis dengan `_describe`, `compadd`, dan `#compdef`.
- ZLE adalah editor baris. Terdiri dari keymap, widget, buffer, dan cursor.
- Variabel ZLE: `BUFFER`, `CURSOR`, `LBUFFER`, `RBUFFER`, `PREDISPLAY`, `POSTDISPLAY`.
- `zle -N` mendaftarkan widget. `bindkey` mengikat tombol.
- Widget bisa memanipulasi buffer, history, dan memanggil widget lain.
- Hook: `preexec`, `precmd`, `chpwd`, `zshaddhistory`, `period`.
- Autoload memuat fungsi dari file di `$fpath`.
- `zmodload` memuat modul. Modul memperluas Zsh dengan builtin, parameter, dan fungsi.
- Modul penting: `zsh/zprof`, `zsh/datetime`, `zsh/system`, `zsh/parameter`, `zsh/complist`, `zsh/zutil`.
- Alur customization: baca plugin → pahami source code → identifikasi mekanisme Zsh → modifikasi → buat fitur sendiri.

---

Sampai di sini **Materi 5 — Zsh Internals untuk Customization** selesai. Sesuai kurikulum, berikutnya adalah **Materi 6 — Productivity Engineering**, yang mencakup:
- custom widgets
- custom completion
- aliases/functions
- hooks
- terminal integration
- Git integration
- fzf/zoxide/yazi integration
- prompt customization
- personal Zsh framework

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md

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

