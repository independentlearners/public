# **Materi 4 — Struktur Konfigurasi Zsh**
Ini adalah materi yang mengubah Zsh dari sekadar shell yang Anda pakai menjadi shell yang Anda **bangun**. Di sini kita akan bahas file startup, urutan pembacaannya, modularisasi konfigurasi, dan struktur direktori yang sesuai dengan arah dotfiles Anda.

Tetap di jalur kurikulum. Kita belum masuk ke Zsh internals untuk customization (Materi 5) dan belum masuk productivity engineering (Materi 6).

---

# Materi 4 — Struktur Konfigurasi Zsh

## 4.1 File Startup Zsh

Zsh memiliki lima file startup utama. Masing-masing dibaca pada momen yang berbeda.

```text
~/.zshenv
~/.zprofile
~/.zshrc
~/.zlogin
~/.zlogout
```

Urutan pembacaan untuk shell interaktif login:

```text
.zshenv → .zprofile → .zshrc → .zlogin
```

Urutan pembacaan untuk shell interaktif non-login:

```text
.zshenv → .zshrc
```

Urutan pembacaan untuk shell non-interaktif:

```text
.zshenv
```

Saat logout dari shell login:

```text
.zlogout
```

Pemahaman urutan ini adalah fondasi. Jika Anda salah menaruh konfigurasi, ia mungkin tidak dibaca, atau dibaca terlalu awal, atau dibaca terlalu sering.

---

## 4.2 `.zshenv`

`.zshenv` adalah file pertama yang dibaca, **selalu**, untuk semua jenis shell: login, non-login, interaktif, non-interaktif.

```zsh
# ~/.zshenv
export EDITOR=nvim
export PAGER=less
```

Penjelasan kata demi kata:

- `# ~/.zshenv` — komentar. Baris yang dimulai `#` diabaikan Zsh.
- `export` — builtin untuk mengekspor variabel ke environment, sehingga tersedia untuk proses anak.
- `EDITOR=nvim` — assignment variabel. `EDITOR` adalah nama variabel, `nvim` adalah nilai.
- `PAGER=less` — variabel `PAGER` diisi `less`.

**Karakteristik `.zshenv`:**

- Dibaca **selalu**, termasuk saat Zsh menjalankan script.
- Cocok untuk variabel environment yang dibutuhkan script.
- Jangan taruh perintah interaktif seperti `bindkey`, `setopt` interaktif, atau `compinit`.
- Jangan taruh `echo` atau output apa pun, karena akan mengganggu script yang membaca output.

**Kesalahan umum:**

- Menaruh `setopt AUTO_CD` di `.zshenv`. Ini tidak salah secara sintaks, tetapi tidak berguna karena script non-interaktif tidak butuh `AUTO_CD`.
- Menaruh `compinit` di `.zshenv`. Ini akan memperlambat setiap script Zsh yang dijalankan.

**Lokasi alternatif:**

Jika `$ZDOTDIR` diset, Zsh akan mencari `.zshenv` di `$ZDOTDIR` alih-alih `$HOME`.

```zsh
ZDOTDIR=~/.config/zsh
```

Penjelasan:

- `ZDOTDIR` — variabel yang menentukan direktori file startup Zsh.
- `~/.config/zsh` — path direktori.

Jika Anda ingin semua file startup berada di `~/.config/zsh/`, set `ZDOTDIR` di `.zshenv` **sistem** (`/etc/zsh/zshenv`) atau melalui environment.

---

## 4.3 `.zprofile`

`.zprofile` dibaca setelah `.zshenv` untuk **login shell**.

```zsh
# ~/.zprofile
export PATH="$HOME/.local/bin:$PATH"
```

Penjelasan:

- `export PATH=...` — menambahkan `~/.local/bin` ke depan `PATH`.
- `"$HOME/.local/bin:$PATH"` — string yang menggabungkan path baru dengan `PATH` lama, dipisahkan titik dua.

**Karakteristik `.zprofile`:**

- Hanya dibaca oleh login shell.
- Analog dengan `.bash_profile` di Bash.
- Cocok untuk konfigurasi environment yang hanya perlu sekali per login.
- Tidak cocok untuk alias, widget, atau konfigurasi interaktif.

**Kapan login shell terjadi:**

- Saat Anda login ke TTY.
- Saat Anda SSH ke mesin.
- Saat terminal emulator dikonfigurasi menjalankan login shell (misalnya dengan `zsh -l`).
- Saat macOS Terminal membuka shell baru (secara default login shell).

Di banyak setup Linux modern dengan terminal emulator seperti Alacritty, Kitty, atau GNOME Terminal, shell yang dijalankan adalah **non-login interaktif**. Artinya `.zprofile` **tidak** dibaca. Hanya `.zshenv` dan `.zshrc` yang dibaca.

Karena itu, jangan bergantung pada `.zprofile` untuk hal-hal penting. Taruh environment dasar di `.zshenv`, dan sisanya di `.zshrc`.

---

## 4.4 `.zshrc`

`.zshrc` adalah file yang paling sering Anda sentuh. Ia dibaca untuk **setiap shell interaktif**, baik login maupun non-login.

```zsh
# ~/.zshrc
setopt AUTO_CD
setopt EXTENDED_GLOB

autoload -Uz compinit
compinit

bindkey '^G' my_widget

alias ll='ls -la'
```

Penjelasan:

- `setopt AUTO_CD` — nyalakan option.
- `setopt EXTENDED_GLOB` — nyalakan option lain.
- `autoload -Uz compinit` — siapkan fungsi `compinit` untuk dimuat otomatis.
- `compinit` — inisialisasi sistem completion.
- `bindkey '^G' my_widget` — ikat tombol ke widget.
- `alias ll='ls -la'` — buat alias.

**Karakteristik `.zshrc`:**

- Dibaca setiap kali shell interaktif baru dibuka.
- Cocok untuk: option interaktif, alias, fungsi, prompt, keybinding, completion, plugin.
- **Tidak** dibaca oleh script non-interaktif.
- Harus cepat. Setiap milidetik di sini menambah waktu startup terminal Anda.

---

## 4.5 `.zlogin`

`.zlogin` dibaca setelah `.zshrc`, hanya untuk login shell.

```zsh
# ~/.zlogin
echo "Selamat datang, $USER"
```

Penjelasan:

- `echo "Selamat datang, $USER"` — cetak pesan selamat datang.
- `$USER` — variabel environment yang berisi nama user.

**Karakteristik `.zlogin`:**

- Dibaca setelah `.zshrc`.
- Hanya untuk login shell.
- Cocok untuk: pesan login, memulai program yang harus jalan sekali per login (seperti `gpg-agent`, `ssh-agent`).
- Jarang digunakan. Banyak orang melewatkannya.

**Perbedaan `.zprofile` dan `.zlogin`:**

- `.zprofile` dibaca **sebelum** `.zshrc`.
- `.zlogin` dibaca **setelah** `.zshrc`.
- Karena `.zshrc` sering mengubah environment, `.zlogin` bisa memanfaatkan perubahan itu.

---

## 4.6 `.zlogout`

`.zlogout` dibaca saat login shell keluar.

```zsh
# ~/.zlogout
echo "Sampai jumpa"
```

Penjelasan:

- `echo "Sampai jumpa"` — cetak pesan perpisahan.

**Karakteristik `.zlogout`:**

- Hanya untuk login shell.
- Cocok untuk: membersihkan file sementara, menyimpan status, mencetak pesan perpisahan.
- Sangat jarang digunakan.

---

## 4.7 Ringkasan Urutan Pembacaan

| Jenis Shell | File yang Dibaca |
|-------------|------------------|
| Login interaktif | `.zshenv` → `.zprofile` → `.zshrc` → `.zlogin` |
| Non-login interaktif | `.zshenv` → `.zshrc` |
| Non-interaktif | `.zshenv` |
| Logout login | `.zlogout` |

**Prinsip praktis:**

- `.zshenv` — environment dasar untuk semua shell.
- `.zprofile` — environment untuk login shell saja.
- `.zshrc` — konfigurasi interaktif (paling banyak isi).
- `.zlogin` — jarang dipakai.
- `.zlogout` — jarang dipakai.

Untuk tujuan Anda, fokus utama ada di `.zshenv` dan `.zshrc`.

---

## 4.8 Modular Configuration

Menaruh semua konfigurasi di `.zshrc` akan membuat file itu panjang dan sulit dirawat. Solusinya adalah **modular configuration**: pecah `.zshrc` menjadi beberapa file kecil yang di-*source*.

### Konsep Source

```zsh
source ~/.config/zsh/options.zsh
```

Penjelasan kata demi kata:

- `source` — builtin untuk membaca dan menjalankan file di shell saat ini (bukan sub-shell).
- `~/.config/zsh/options.zsh` — path file.
- Karena dijalankan di shell saat ini, semua variabel, fungsi, dan option yang didefinisikan di file tersebut tersedia di shell Anda.

Bentuk alternatif:

```zsh
. ~/.config/zsh/options.zsh
```

Penjelasan:

- `.` — titik. Ini adalah bentuk POSIX dari `source`. Sama fungsinya.

### Struktur Direktori

```text
~/.config/zsh/
├── zshrc
├── aliases.zsh
├── functions.zsh
├── options.zsh
├── completion.zsh
├── keybinds.zsh
├── history.zsh
├── prompt.zsh
└── integrations/
    ├── git.zsh
    ├── fzf.zsh
    ├── zoxide.zsh
    └── yazi.zsh
```

Penjelasan setiap file:

- `zshrc` — file utama. Membaca semua file lain.
- `aliases.zsh` — definisi alias.
- `functions.zsh` — definisi fungsi.
- `options.zsh` — semua `setopt`.
- `completion.zsh` — konfigurasi completion.
- `keybinds.zsh` — semua `bindkey`.
- `history.zsh` — konfigurasi history.
- `prompt.zsh` — konfigurasi prompt.
- `integrations/` — integrasi dengan program eksternal.
- `integrations/git.zsh` — integrasi git.
- `integrations/fzf.zsh` — integrasi fzf.
- `integrations/zoxide.zsh` — integrasi zoxide.
- `integrations/yazi.zsh` — integrasi yazi.

### Mengarahkan Zsh ke `~/.config/zsh/`

Zsh secara default mencari `.zshrc` di `$HOME`. Untuk memindahkannya ke `~/.config/zsh/`, set `ZDOTDIR`.

Cara paling bersih: buat file `~/.zshenv` yang berisi:

```zsh
ZDOTDIR=$HOME/.config/zsh
```

Penjelasan:

- `ZDOTDIR=$HOME/.config/zsh` — set direktori konfigurasi Zsh.
- `$HOME` — variabel environment untuk home direktori.
- Setelah ini, Zsh akan mencari `.zshrc`, `.zprofile`, `.zlogin`, `.zlogout` di `~/.config/zsh/`, bukan di `$HOME`.
- `.zshenv` tetap dibaca dari `$HOME` karena `ZDOTDIR` belum diset saat `.zshenv` dibaca.

Ini adalah pola yang sangat umum di dotfiles modern.

### File `zshrc` Utama

File `~/.config/zsh/.zshrc` (atau `~/.config/zsh/zshrc` jika Anda mengikuti konvensi tanpa titik) berisi:

```zsh
# ~/.config/zsh/.zshrc

# Sumber semua modul
source $ZDOTDIR/options.zsh
source $ZDOTDIR/history.zsh
source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/functions.zsh
source $ZDOTDIR/keybinds.zsh
source $ZDOTDIR/completion.zsh
source $ZDOTDIR/prompt.zsh

# Integrasi eksternal
source $ZDOTDIR/integrations/git.zsh
source $ZDOTDIR/integrations/fzf.zsh
source $ZDOTDIR/integrations/zoxide.zsh
source $ZDOTDIR/integrations/yazi.zsh
```

Penjelasan:

- `$ZDOTDIR/options.zsh` — path lengkap ke file.
- `$ZDOTDIR` — variabel yang sudah diset di `.zshenv`.
- Urutan source penting:
  1. `options.zsh` dulu, karena option memengaruhi perilaku file berikutnya.
  2. `history.zsh`, karena option history juga memengaruhi.
  3. `aliases.zsh` dan `functions.zsh`, karena keduanya mendefinisikan perintah.
  4. `keybinds.zsh`, karena widget harus sudah didefinisikan.
  5. `completion.zsh`, karena `compinit` harus dijalankan setelah `fpath` diset.
  6. `prompt.zsh`, karena prompt membutuhkan fungsi yang mungkin didefinisikan di atasnya.
  7. Integrasi eksternal di akhir.

### File `options.zsh`

```zsh
# ~/.config/zsh/options.zsh

setopt AUTO_CD
setopt EXTENDED_GLOB
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY
setopt AUTO_MENU
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
```

Penjelasan:

- Semua option interaktif dikumpulkan di sini.
- File ini murni deklaratif. Tidak ada logika.

### File `history.zsh`

```zsh
# ~/.config/zsh/history.zsh

HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
```

Penjelasan:

- `HISTFILE=$ZDOTDIR/.zsh_history` — simpan file history di direktori konfigurasi.
- `HISTSIZE=10000` — jumlah perintah di memori.
- `SAVEHIST=10000` — jumlah perintah di file.
- Option history dikumpulkan di sini agar rapi.

### File `aliases.zsh`

```zsh
# ~/.config/zsh/aliases.zsh

alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
```

Penjelasan:

- `alias` — builtin untuk membuat alias.
- `ll='ls -la'` — `ll` akan diganti dengan `ls -la`.
- Tanda kutip tunggal mencegah ekspansi saat pendefinisian.

### File `functions.zsh`

```zsh
# ~/.config/zsh/functions.zsh

mkcd() {
    mkdir -p "$1" && cd "$1"
}

extract() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.gz|*.tgz) tar xzf "$1" ;;
            *.tar.bz2)     tar xjf "$1" ;;
            *.zip)         unzip "$1" ;;
            *)             echo "Format tidak dikenal: $1" ;;
        esac
    else
        echo "File tidak ditemukan: $1"
    fi
}
```

Penjelasan:

- `mkcd() { ... }` — fungsi untuk membuat direktori dan masuk ke dalamnya.
- `mkdir -p "$1"` — buat direktori, `-p` untuk membuat parent jika perlu.
- `&&` — jika `mkdir` sukses, jalankan `cd`.
- `cd "$1"` — masuk ke direktori.
- `extract()` — fungsi untuk mengekstrak berbagai format arsip.
- `if [[ -f "$1" ]]` — cek apakah argumen pertama adalah file biasa.
- `case "$1" in ... esac` — pencocokan pola.
- `*.tar.gz|*.tgz)` — pola untuk file `.tar.gz` atau `.tgz`.
- `tar xzf "$1"` — ekstrak tarball gzip.
- `*)` — pola default.

### File `keybinds.zsh`

```zsh
# ~/.config/zsh/keybinds.zsh

bindkey -e

bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history
bindkey '^R' history-incremental-search-backward
bindkey '^G' my_custom_widget
```

Penjelasan:

- `bindkey -e` — gunakan keymap emacs.
- `bindkey '^[[A' up-line-or-history` — panah atas untuk history.
- `bindkey '^[[B' down-line-or-history` — panah bawah untuk history.
- `bindkey '^R' history-incremental-search-backward` — Ctrl+R untuk pencarian history.
- `bindkey '^G' my_custom_widget` — Ctrl+G untuk widget kustom.

### File `completion.zsh`

```zsh
# ~/.config/zsh/completion.zsh

fpath=($ZDOTDIR/completion $fpath)

autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
```

Penjelasan:

- `fpath=($ZDOTDIR/completion $fpath)` — tambahkan direktori fungsi completion pribadi.
- `autoload -Uz compinit` — siapkan fungsi `compinit`.
- `compinit` — inisialisasi completion.
- `zstyle ':completion:*' menu select` — aktifkan menu selection.
- `zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'` — case-insensitive matching.

### File `prompt.zsh`

```zsh
# ~/.config/zsh/prompt.zsh

autoload -Uz promptinit
promptinit

setopt PROMPT_SUBST

PROMPT='%F{green}%n%f@%F{blue}%m%f:%F{yellow}%~%f %# '
RPROMPT='%(?..%F{red}[%?]%f)'
```

Penjelasan:

- `autoload -Uz promptinit` — siapkan fungsi `promptinit`.
- `promptinit` — inisialisasi sistem prompt.
- `setopt PROMPT_SUBST` — aktifkan ekspansi parameter di prompt.
- `PROMPT='...'` — prompt utama.
  - `%F{green}` — mulai warna hijau.
  - `%n` — nama user.
  - `%f` — reset warna.
  - `@` — literal.
  - `%F{blue}` — warna biru.
  - `%m` — nama host (sampai titik pertama).
  - `%f` — reset warna.
  - `:` — literal.
  - `%F{yellow}` — warna kuning.
  - `%~` — path direktori saat ini, dengan `~` untuk home.
  - `%f` — reset warna.
  - `%#` — `#` jika root, `%` jika user biasa.
- `RPROMPT='...'` — prompt kanan.
  - `%(?..%F{red}[%?]%f)` — jika exit status bukan 0, tampilkan dalam warna merah.

### File `integrations/git.zsh`

```zsh
# ~/.config/zsh/integrations/git.zsh

autoload -Uz vcs_info
precmd() {
    vcs_info
}

zstyle ':vcs_info:git:*' formats ' %F{yellow}(%b)%f'

setopt PROMPT_SUBST
RPROMPT='${vcs_info_msg_0_}'
```

Penjelasan:

- `autoload -Uz vcs_info` — siapkan fungsi `vcs_info`.
- `precmd()` — hook yang dijalankan sebelum prompt.
- `vcs_info` — kumpulkan informasi VCS.
- `zstyle ':vcs_info:git:*' formats ' %F{yellow}(%b)%f'` — format untuk git, `%b` adalah branch.
- `setopt PROMPT_SUBST` — aktifkan ekspansi di prompt.
- `RPROMPT='${vcs_info_msg_0_}'` — tampilkan info VCS di prompt kanan.

### File `integrations/fzf.zsh`

```zsh
# ~/.config/zsh/integrations/fzf.zsh

if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
fi

if [[ -f /usr/share/fzf/completion.zsh ]]; then
    source /usr/share/fzf/completion.zsh
fi

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
```

Penjelasan:

- `if [[ -f ... ]]` — cek apakah file ada.
- `source ...` — baca dan jalankan file.
- `export FZF_DEFAULT_OPTS=...` — set default option untuk fzf.

### File `integrations/zoxide.zsh`

```zsh
# ~/.config/zsh/integrations/zoxide.zsh

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi
```

Penjelasan:

- `command -v zoxide` — cek apakah perintah `zoxide` tersedia.
- `>/dev/null 2>&1` — buang stdout dan stderr.
- `eval "$(zoxide init zsh)"` — jalankan output `zoxide init zsh` sebagai perintah shell.

### File `integrations/yazi.zsh`

```zsh
# ~/.config/zsh/integrations/yazi.zsh

y() {
    local tmp="$(mktemp -t yazi-cwd.XXXXXX)"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}
```

Penjelasan:

- `y()` — fungsi untuk menjalankan yazi dan mengubah direktori.
- `local tmp="$(mktemp -t yazi-cwd.XXXXXX)"` — buat file sementara.
- `yazi "$@" --cwd-file="$tmp"` — jalankan yazi dengan argumen.
- `if cwd="$(cat -- "$tmp")" ...` — baca direktori dari file sementara.
- `cd -- "$cwd"` — pindah ke direktori.
- `rm -f -- "$tmp"` — hapus file sementara.

---

## 4.9 Plugin Management

Plugin adalah kumpulan fungsi, alias, completion, dan widget yang bisa Anda muat. Ada beberapa cara mengelola plugin.

### Cara Manual

```zsh
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

Penjelasan:

- Anda clone plugin ke direktori plugin.
- Anda source file utama plugin.
- Urutan source penting. `zsh-syntax-highlighting` harus di-source terakhir.

### Cara dengan Plugin Manager

Beberapa plugin manager populer:

- **Antibody** — cepat, ditulis dalam Go.
- **Zplug** — fleksibel, ditulis dalam Zsh.
- **Znap** — cepat, ringan.
- **zinit** — sangat fleksibel.
- **Sheldon** — ditulis dalam Rust.

Contoh dengan `zinit`:

```zsh
source ~/.config/zsh/plugins/zinit/zinit.zsh

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
```

Penjelasan:

- `source ... zinit.zsh` — muat zinit.
- `zinit light ...` — muat plugin secara ringan (lazy load).

### Prinsip Plugin Management

- Jangan muat plugin yang tidak Anda butuhkan.
- Urutkan source plugin dengan benar.
- Syntax highlighting harus terakhir.
- Autosuggestions harus sebelum syntax highlighting.
- Completion plugin harus setelah `compinit`.

---

## 4.10 Environment Management

Environment adalah kumpulan variabel yang memengaruhi perilaku program.

### Variabel Environment Umum

```zsh
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export MANPAGER='less -R'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
```

Penjelasan:

- `EDITOR` — editor default untuk program CLI.
- `VISUAL` — editor default untuk program GUI atau editor penuh.
- `PAGER` — program untuk menampilkan halaman.
- `MANPAGER` — program untuk menampilkan manual.
- `LANG` — locale default.
- `LC_ALL` — override semua kategori locale.

### PATH

```zsh
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
```

Penjelasan:

- `"$HOME/.local/bin:$HOME/bin:$PATH"` — gabungkan path baru di depan, lalu `PATH` lama.
- Urutan penting. Path pertama yang berisi executable akan dipilih.

### Manajemen PATH Modular

Untuk menghindari duplikasi, gunakan fungsi:

```zsh
path_append() {
    [[ ":$PATH:" != *":$1:"* ]] && PATH="$PATH:$1"
}

path_prepend() {
    [[ ":$PATH:" != *":$1:"* ]] && PATH="$1:$PATH"
}
```

Penjelasan:

- `path_append()` — tambahkan path di akhir jika belum ada.
- `[[ ":$PATH:" != *":$1:"* ]]` — cek apakah `$1` sudah ada di `PATH`.
- `&& PATH="$PATH:$1"` — jika belum, tambahkan.

---

## 4.11 Startup Optimization

Zsh startup bisa lambat jika konfigurasi Anda berat. Berikut cara mengukurnya dan mempercepatnya.

### Mengukur Waktu Startup

```zsh
time zsh -i -c exit
```

Penjelasan:

- `time` — perintah untuk mengukur waktu eksekusi.
- `zsh` — jalankan Zsh.
- `-i` — interaktif.
- `-c exit` — jalankan perintah `exit` dan keluar.
- Output: waktu total.

### Profiling dengan `zprof`

```zsh
# Di awal .zshrc
zmodload zsh/zprof

# Di akhir .zshrc
zprof
```

Penjelasan:

- `zmodload zsh/zprof` — muat modul profiler.
- `zprof` — tampilkan hasil profiling.

### Teknik Optimasi

- Hindari menjalankan perintah eksternal di `.zshrc` (misalnya `git`, `python`, `node`).
- Gunakan lazy loading untuk plugin berat.
- Gunakan `compinit -C` untuk melewati pengecekan keamanan file completion.
- Jangan `source` file yang tidak perlu.
- Hindari `eval` yang tidak perlu.

```zsh
autoload -Uz compinit
compinit -C
```

Penjelasan:

- `compinit -C` — lewati pemeriksaan keamanan. Lebih cepat, tetapi hanya aman jika Anda percaya semua file di `fpath`.

---

## 4.12 Ringkasan Materi 4

- File startup: `.zshenv`, `.zprofile`, `.zshrc`, `.zlogin`, `.zlogout`.
- Urutan pembacaan: `.zshenv` → `.zprofile` → `.zshrc` → `.zlogin` (login), `.zshenv` → `.zshrc` (non-login interaktif), `.zshenv` (non-interaktif).
- `.zshenv` untuk environment dasar.
- `.zshrc` untuk konfigurasi interaktif.
- Modular configuration memecah konfigurasi menjadi file kecil.
- `~/.config/zsh/` adalah lokasi konvensional.
- `ZDOTDIR` mengarahkan Zsh ke direktori konfigurasi.
- File modular: `options.zsh`, `history.zsh`, `aliases.zsh`, `functions.zsh`, `keybinds.zsh`, `completion.zsh`, `prompt.zsh`.
- Integrasi eksternal di `integrations/`: `git.zsh`, `fzf.zsh`, `zoxide.zsh`, `yazi.zsh`.
- Plugin management: manual atau dengan plugin manager.
- Environment management: `EDITOR`, `PAGER`, `LANG`, `PATH`.
- Startup optimization: ukur dengan `time`, profiling dengan `zprof`, gunakan lazy loading.

---

Sampai di sini **Materi 4 — Struktur Konfigurasi Zsh** selesai. Sesuai kurikulum, berikutnya adalah **Materi 5 — Zsh Internals untuk Customization**, yang mencakup:
- Zsh completion system: styles, tags, completers, completion functions
- ZLE internals
- widgets
- hooks
- autoload functions
- `zmodload`
- modules
- alur: `plugin → source code → Zsh mechanism → modify → custom feature`

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

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

