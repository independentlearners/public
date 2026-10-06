# **Materi 6 — Productivity Engineering**
Ini adalah materi terakhir dalam kurikulum inti. Semua yang sudah Anda pelajari—fondasi Zsh, `setopt`, ZLE, widget, hook, completion, autoload, `zmodload`, struktur konfigurasi—sekarang dirakit menjadi **lingkungan kerja yang Anda program sendiri**.

Tetap di jalur kurikulum. Materi ini mencakup:
- custom widgets
- custom completion
- aliases/functions
- hooks
- terminal integration
- Git integration
- fzf/zoxide/yazi integration
- prompt customization
- personal Zsh framework

Setelah ini, kita tutup dengan **Referensi Resmi Wajib** dan **Target Akhir** sesuai kurikulum awal.

---

# Materi 6 — Productivity Engineering

## 6.1 Prinsip Productivity Engineering

Productivity engineering adalah praktik membangun lingkungan shell yang:
1. Mengurangi gerakan tangan dan ketikan berulang.
2. Memberi informasi tepat saat dibutuhkan.
3. Mengotomatiskan alur kerja yang sering dilakukan.
4. Tetap cepat saat startup.
5. Mudah dirawat dan dikembangkan.

Zsh cocok untuk ini karena ia memberi Anda:
- ZLE untuk memanipulasi command line.
- Completion system untuk menebak argumen.
- Hook untuk menyisipkan logika pada momen tertentu.
- Autoload dan modul untuk memuat fitur secara efisien.
- Konfigurasi modular untuk merapikan semuanya.

Mental model:

```text
Kebutuhan berulang
   ↓
Widget / function / alias / completion
   ↓
Hook / integrasi
   ↓
Prompt / notifikasi
   ↓
Lingkungan kerja pribadi
```

---

## 6.2 Custom Widgets

Widget adalah unit aksi ZLE. Anda sudah mempelajari dasar `zle -N` dan `bindkey` di Materi 3 dan 5. Sekarang kita buat widget yang benar-benar berguna.

### 6.2.1 Widget Menyisipkan `sudo`

Tujuan: menekan `Ctrl+S` untuk menambahkan `sudo ` di awal baris.

```zsh
insert_sudo() {
    if [[ "$BUFFER" != sudo* ]]; then
        BUFFER="sudo $BUFFER"
        CURSOR=$(( CURSOR + 5 ))
    fi
}

zle -N insert_sudo
bindkey '^S' insert_sudo
```

Penjelasan kata demi kata:

- `insert_sudo() {` — definisi fungsi. Nama bebas.
- `if [[ "$BUFFER" != sudo* ]]; then` — cek apakah buffer **tidak** diawali `sudo`.
  - `[[` — conditional.
  - `"$BUFFER"` — isi baris saat ini.
  - `!=` — tidak sama dengan.
  - `sudo*` — pola glob: `sudo` diikuti apa pun.
  - `; then` — mulai blok jika benar.
- `BUFFER="sudo $BUFFER"` — tambahkan `sudo ` di depan buffer.
- `CURSOR=$(( CURSOR + 5 ))` — geser kursor 5 karakter ke kanan.
  - `$(( ... ))` — aritmetika.
  - `CURSOR + 5` — posisi lama ditambah 5, karena `sudo ` panjangnya 5 karakter.
- `fi` — akhir `if`.
- `}` — akhir fungsi.
- `zle -N insert_sudo` — daftarkan sebagai widget ZLE.
- `bindkey '^S' insert_sudo` — ikat `Ctrl+S`.

Efek: jika Anda mengetik `apt update`, lalu `Ctrl+S`, buffer menjadi `sudo apt update`.

### 6.2.2 Widget Mencari History dengan fzf

Tujuan: menekan `Ctrl+R` untuk mencari history menggunakan `fzf`.

```zsh
fzf_history() {
    local selected
    selected=$(fc -l 1 | fzf --height 40% --reverse --tac | sed 's/^[ ]*[0-9]*[ ]*//')
    if [[ -n "$selected" ]]; then
        BUFFER="$selected"
        CURSOR=${#BUFFER}
    fi
    zle reset-prompt
}

zle -N fzf_history
bindkey '^R' fzf_history
```

Penjelasan:

- `fzf_history() {` — fungsi widget.
- `local selected` — variabel lokal.
- `selected=$(fc -l 1 | fzf ... | sed ...)` — ambil history, kirim ke fzf, bersihkan nomor.
  - `fc -l 1` — daftar history dari nomor 1.
  - `|` — pipe.
  - `fzf --height 40% --reverse --tac` — jalankan fzf.
    - `--height 40%` — tinggi 40% layar.
    - `--reverse` — tampilkan dari atas.
    - `--tac` — reverse input, terbaru di atas.
  - `| sed 's/^[ ]*[0-9]*[ ]*//'` — hapus nomor history di awal baris.
    - `sed` — stream editor.
    - `s/.../.../` — substitusi.
    - `^[ ]*[0-9]*[ ]*` — awal baris, spasi opsional, angka opsional, spasi opsional.
- `if [[ -n "$selected" ]]; then` — jika ada yang dipilih.
- `BUFFER="$selected"` — isi buffer dengan perintah terpilih.
- `CURSOR=${#BUFFER}` — pindahkan kursor ke akhir.
- `fi` — akhir if.
- `zle reset-prompt` — segarkan prompt.
- `}` — akhir fungsi.
- `zle -N fzf_history` — daftarkan widget.
- `bindkey '^R' fzf_history` — ikat `Ctrl+R`.

### 6.2.3 Widget Menyalin Baris ke Clipboard

Tujuan: menekan `Ctrl+Y` untuk menyalin buffer ke clipboard.

```zsh
copy_line() {
    print -rn -- "$BUFFER" | xclip -selection clipboard
    zle -M "Disalin ke clipboard"
}

zle -N copy_line
bindkey '^Y' copy_line
```

Penjelasan:

- `copy_line() {` — fungsi.
- `print -rn -- "$BUFFER"` — cetak buffer tanpa newline.
  - `-r` — raw.
  - `-n` — tanpa newline.
  - `--` — akhir opsi.
  - `"$BUFFER"` — isi buffer.
- `| xclip -selection clipboard` — kirim ke xclip.
  - `xclip` — utilitas clipboard X11.
  - `-selection clipboard` — gunakan clipboard, bukan primary.
- `zle -M "Disalin ke clipboard"` — tampilkan pesan di bawah prompt.
- `}` — akhir fungsi.
- `zle -N copy_line` — daftarkan.
- `bindkey '^Y' copy_line` — ikat `Ctrl+Y`.

Jika Anda memakai Wayland, ganti `xclip` dengan `wl-copy`. Jika macOS, gunakan `pbcopy`.

---

## 6.3 Custom Completion

Completion system Zsh sangat kuat. Anda bisa menulis fungsi completion sendiri.

### 6.3.1 Struktur Fungsi Completion

File completion harus:
1. Diawali `#compdef nama_perintah`.
2. Berisi fungsi bernama `_nama_perintah`.
3. Menggunakan builtin completion seperti `_describe`, `compadd`, `_arguments`.

### 6.3.2 Contoh Completion Sederhana

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

Penjelasan:

- `#compdef hello` — beri tahu compsys bahwa fungsi ini untuk perintah `hello`.
- `_hello() {` — definisi fungsi.
- `local -a names` — array lokal.
- `names=(` — mulai assignment.
- `'dunia:Menyapa dunia'` — item completion. Format `nilai:deskripsi`.
- `'zsh:Menyapa Zsh'` — item kedua.
- `'bash:Menyapa Bash'` — item ketiga.
- `)` — akhir array.
- `_describe 'sapaan' names` — tampilkan array dengan label `sapaan`.
- `}` — akhir fungsi.

Setelah file ada di `$fpath` dan `compinit` dijalankan ulang, `hello <Tab>` akan menampilkan pilihan.

### 6.3.3 Completion dengan `compadd`

```zsh
#compdef mycmd

_mycmd() {
    compadd -- start stop restart status
}
```

Penjelasan:

- `compadd` — builtin untuk menambahkan kandidat completion.
- `--` — akhir opsi.
- `start stop restart status` — kandidat.

### 6.3.4 Completion dengan `_arguments`

```zsh
#compdef mycmd

_mycmd() {
    _arguments \
        '--help[Menampilkan bantuan]' \
        '--version[Menampilkan versi]' \
        '--output=[File output]:file:_files' \
        '1:command:(start stop restart status)'
}
```

Penjelasan:

- `_arguments` — builtin untuk parsing argumen.
- `'--help[...]'` — opsi `--help` dengan deskripsi.
- `'--version[...]'` — opsi `--version`.
- `'--output=[...]:file:_files'` — opsi `--output` yang membutuhkan argumen file, completion menggunakan `_files`.
- `'1:command:(start stop restart status)'` — argumen pertama, kandidat `start`, `stop`, `restart`, `status`.

### 6.3.5 Mendaftarkan Completion Manual

```zsh
compdef _mycmd mycmd
```

Penjelasan:

- `compdef` — builtin.
- `_mycmd` — fungsi completion.
- `mycmd` — perintah yang di-complete.

---

## 6.4 Aliases dan Functions

### 6.4.1 Alias

Alias adalah pengganti teks sederhana.

```zsh
alias ll='ls -la'
```

Penjelasan:

- `alias` — builtin.
- `ll` — nama alias.
- `='ls -la'` — teks pengganti.
- Setiap kali Anda mengetik `ll`, Zsh menggantinya dengan `ls -la`.

Alias cocok untuk:
- Perintah pendek yang sering dipakai.
- Menambahkan opsi default.
- Mengganti nama perintah.

Alias tidak cocok untuk:
- Logika kompleks.
- Argumen dinamis.
- Kontrol alur.

### 6.4.2 Fungsi

Fungsi adalah blok kode yang bisa menerima argumen.

```zsh
mkcd() {
    mkdir -p "$1" && cd "$1"
}
```

Penjelasan:

- `mkcd()` — nama fungsi.
- `mkdir -p "$1"` — buat direktori.
  - `-p` — buat parent jika perlu.
  - `"$1"` — argumen pertama.
- `&&` — jika sukses, lanjut.
- `cd "$1"` — masuk ke direktori.
- `}` — akhir fungsi.

Fungsi cocok untuk:
- Logika.
- Argumen.
- Kontrol alur.
- Menggabungkan beberapa perintah.

### 6.4.3 Kapan Alias, Kapan Fungsi

- Alias: `alias grep='grep --color=auto'`.
- Fungsi: `extract() { ... }`.

Jangan buat alias untuk hal yang butuh argumen dinamis. Gunakan fungsi.

---

## 6.5 Hooks untuk Produktivitas

Hook memungkinkan Anda menjalankan kode pada momen tertentu.

### 6.5.1 `precmd` untuk Informasi Git

```zsh
autoload -Uz vcs_info
precmd() {
    vcs_info
}
```

Penjelasan:

- `autoload -Uz vcs_info` — muat fungsi `vcs_info`.
- `precmd()` — hook sebelum prompt.
- `vcs_info` — kumpulkan info VCS.

### 6.5.2 `preexec` untuk Timer

```zsh
preexec() {
    start_time=$EPOCHREALTIME
}

precmd() {
    if [[ -n "$start_time" ]]; then
        local elapsed=$(( EPOCHREALTIME - start_time ))
        printf 'Perintah selesai dalam %.2f detik\n' "$elapsed"
        unset start_time
    fi
}
```

Penjelasan:

- `preexec()` — sebelum perintah.
- `start_time=$EPOCHREALTIME` — simpan waktu mulai.
- `precmd()` — sebelum prompt.
- `if [[ -n "$start_time" ]]` — jika timer berjalan.
- `local elapsed=$(( EPOCHREALTIME - start_time ))` — hitung selisih.
- `printf '...%.2f...' "$elapsed"` — cetak dengan 2 desimal.
- `unset start_time` — reset.

### 6.5.3 `chpwd` untuk Auto `ls`

```zsh
chpwd() {
    ls -CF
}
```

Penjelasan:

- `chpwd()` — dipanggil setiap ganti direktori.
- `ls -CF` — daftar file dengan format kolom dan indikator tipe.

---

## 6.6 Terminal Integration

Terminal integration menghubungkan Zsh dengan terminal emulator.

### 6.6.1 Mengatur Judul Terminal

```zsh
set_title() {
    print -Pn "\e]0;%~\a"
}
precmd() {
    set_title
}
```

Penjelasan:

- `set_title() {` — fungsi.
- `print -Pn "\e]0;%~\a"` — cetak escape sequence.
  - `-P` — aktifkan prompt expansion.
  - `-n` — tanpa newline.
  - `\e]0;` — mulai escape sequence untuk judul.
  - `%~` — path direktori saat ini.
  - `\a` — bell, penanda akhir.
- `precmd()` — panggil setiap sebelum prompt.

### 6.6.2 Clipboard

```zsh
clip() {
    if command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard
    elif command -v wl-copy >/dev/null 2>&1; then
        wl-copy
    elif command -v pbcopy >/dev/null 2>&1; then
        pbcopy
    else
        echo "Clipboard tidak didukung" >&2
        return 1
    fi
}
```

Penjelasan:

- `clip()` — fungsi untuk menyalin stdin ke clipboard.
- `command -v xclip` — cek ketersediaan.
- `>/dev/null 2>&1` — buang output.
- `xclip -selection clipboard` — X11.
- `wl-copy` — Wayland.
- `pbcopy` — macOS.
- `else` — jika tidak ada.
- `echo ... >&2` — error ke stderr.
- `return 1` — status gagal.

### 6.6.3 Notifikasi

```zsh
notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$1"
    elif command -v osascript >/dev/null 2>&1; then
        osascript -e "display notification \"$1\""
    fi
}
```

Penjelasan:

- `notify()` — fungsi notifikasi.
- `notify-send "$1"` — Linux.
- `osascript -e "..."` — macOS.

---

## 6.7 Git Integration

### 6.7.1 `vcs_info` di Prompt

```zsh
autoload -Uz vcs_info
precmd() {
    vcs_info
}

zstyle ':vcs_info:git:*' formats ' %F{yellow}(%b)%f'
setopt PROMPT_SUBST
RPROMPT='${vcs_info_msg_0_}'
```

Penjelasan:

- `autoload -Uz vcs_info` — muat.
- `precmd()` — hook.
- `vcs_info` — kumpulkan info.
- `zstyle ':vcs_info:git:*' formats ' %F{yellow}(%b)%f'` — format git.
  - `%b` — branch.
- `setopt PROMPT_SUBST` — aktifkan ekspansi di prompt.
- `RPROMPT='${vcs_info_msg_0_}'` — tampilkan di kanan.

### 6.7.2 Fungsi Git

```zsh
gcom() {
    git add -A && git commit -m "$1"
}

gpush() {
    git push origin "$(git branch --show-current)"
}
```

Penjelasan:

- `gcom()` — commit semua perubahan.
- `git add -A` — tambahkan semua.
- `&& git commit -m "$1"` — commit dengan pesan.
- `gpush()` — push branch saat ini.
- `$(git branch --show-current)` — ambil nama branch.

### 6.7.3 Alias Git

```zsh
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
```

Penjelasan:

- `gs` — status.
- `ga` — add.
- `gc` — commit.
- `gp` — push.
- `gl` — log ringkas.

---

## 6.8 fzf / zoxide / yazi Integration

### 6.8.1 fzf

```zsh
if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
fi

if [[ -f /usr/share/fzf/completion.zsh ]]; then
    source /usr/share/fzf/completion.zsh
fi

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
```

Penjelasan:

- `if [[ -f ... ]]` — cek file.
- `source ...` — muat binding dan completion fzf.
- `export FZF_DEFAULT_OPTS=...` — opsi default.

### 6.8.2 zoxide

```zsh
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi
```

Penjelasan:

- `command -v zoxide` — cek perintah.
- `eval "$(zoxide init zsh)"` — jalankan inisialisasi zoxide.
- `eval` — evaluasi string sebagai perintah.

### 6.8.3 yazi

```zsh
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

- `y()` — fungsi.
- `local tmp="$(mktemp -t yazi-cwd.XXXXXX)"` — file sementara.
- `yazi "$@" --cwd-file="$tmp"` — jalankan yazi.
- `if cwd="$(cat -- "$tmp")" ...` — baca direktori.
- `cd -- "$cwd"` — pindah.
- `rm -f -- "$tmp"` — hapus file sementara.

---

## 6.9 Prompt Customization

### 6.9.1 Prompt Dasar

```zsh
setopt PROMPT_SUBST

PROMPT='%F{green}%n%f@%F{blue}%m%f:%F{yellow}%~%f %# '
RPROMPT='%(?..%F{red}[%?]%f)'
```

Penjelasan:

- `setopt PROMPT_SUBST` — aktifkan ekspansi.
- `PROMPT='...'` — prompt kiri.
  - `%F{green}` — warna hijau.
  - `%n` — user.
  - `%f` — reset warna.
  - `@` — literal.
  - `%F{blue}` — biru.
  - `%m` — host.
  - `%f` — reset.
  - `:` — literal.
  - `%F{yellow}` — kuning.
  - `%~` — path.
  - `%f` — reset.
  - `%#` — `#` atau `%`.
- `RPROMPT='...'` — prompt kanan.
  - `%(?..%F{red}[%?]%f)` — jika exit status bukan 0, tampilkan merah.

### 6.9.2 Prompt dengan Git

```zsh
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' %F{yellow}(%b)%f'
RPROMPT='${vcs_info_msg_0_} %(?.%F{green}✔%f.%F{red}✘%f)'
```

Penjelasan:

- `RPROMPT` menampilkan branch dan status sukses/gagal.
- `%(?.✔.✘)` — jika exit 0 tampilkan ✔, else ✘.

### 6.9.3 Promptinit

```zsh
autoload -Uz promptinit
promptinit
prompt walters
```

Penjelasan:

- `promptinit` — inisialisasi sistem prompt.
- `prompt walters` — gunakan tema `walters`.

---

## 6.10 Personal Zsh Framework

Sekarang kita rakit semuanya menjadi kerangka pribadi.

### 6.10.1 Struktur Direktori

```text
~/.config/zsh/
├── .zshenv
├── .zshrc
├── options.zsh
├── history.zsh
├── aliases.zsh
├── functions.zsh
├── keybinds.zsh
├── completion.zsh
├── prompt.zsh
├── plugins.zsh
├── functions/
│   ├── mkcd
│   ├── extract
│   └── greet
├── completion/
│   └── _hello
└── integrations/
    ├── git.zsh
    ├── fzf.zsh
    ├── zoxide.zsh
    └── yazi.zsh
```

### 6.10.2 File `.zshenv`

```zsh
export ZDOTDIR=$HOME/.config/zsh
```

Penjelasan:

- `ZDOTDIR` — arahkan Zsh ke direktori konfigurasi.
- File ini ada di `$HOME/.zshenv`.

### 6.10.3 File `.zshrc`

```zsh
source $ZDOTDIR/options.zsh
source $ZDOTDIR/history.zsh
source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/functions.zsh
source $ZDOTDIR/keybinds.zsh
source $ZDOTDIR/completion.zsh
source $ZDOTDIR/prompt.zsh
source $ZDOTDIR/plugins.zsh

source $ZDOTDIR/integrations/git.zsh
source $ZDOTDIR/integrations/fzf.zsh
source $ZDOTDIR/integrations/zoxide.zsh
source $ZDOTDIR/integrations/yazi.zsh
```

Penjelasan:

- Urutan source penting:
  1. Options dulu.
  2. History.
  3. Alias dan fungsi.
  4. Keybinds.
  5. Completion.
  6. Prompt.
  7. Plugins.
  8. Integrasi.

### 6.10.4 Lazy Loading Plugin

```zsh
lazy_load() {
    local plugin=$1
    local trigger=$2
    local cmd=$3
    eval "
    $trigger() {
        unfunction $trigger
        source $plugin
        $cmd
    }
    "
}
```

Penjelasan:

- `lazy_load()` — fungsi untuk memuat plugin saat pertama dipanggil.
- `plugin` — path plugin.
- `trigger` — nama fungsi pemicu.
- `cmd` — perintah setelah dimuat.
- `eval "..."` — buat fungsi dinamis.

Contoh:

```zsh
lazy_load ~/.config/zsh/plugins/fzf.zsh fzf fzf
```

### 6.10.5 Bootstrap

Buat script `install.sh`:

```zsh
#!/bin/zsh
set -e

ZDOTDIR=$HOME/.config/zsh
mkdir -p $ZDOTDIR
cp -r .zshrc .zshenv $ZDOTDIR/
cp -r options.zsh history.zsh aliases.zsh functions.zsh keybinds.zsh completion.zsh prompt.zsh $ZDOTDIR/
```

Penjelasan:

- `#!/bin/zsh` — shebang.
- `set -e` — hentikan jika ada error.
- `ZDOTDIR=...` — set direktori.
- `mkdir -p` — buat direktori.
- `cp -r` — salin.

---

## 6.11 Ringkasan Materi 6

- Custom widgets memanipulasi buffer, cursor, history, dan clipboard.
- Custom completion ditulis dengan `#compdef`, `_describe`, `compadd`, `_arguments`.
- Alias untuk penggantian teks sederhana; fungsi untuk logika.
- Hook `preexec`, `precmd`, `chpwd` untuk timer, git, dan auto `ls`.
- Terminal integration: judul, clipboard, notifikasi.
- Git integration: `vcs_info`, fungsi git, alias git.
- fzf/zoxide/yazi integration: source key-bindings, `eval "$(zoxide init zsh)"`, wrapper yazi.
- Prompt customization: `PROMPT`, `RPROMPT`, `vcs_info`, `promptinit`.
- Personal Zsh framework: struktur `~/.config/zsh/`, loader, lazy loading, bootstrap.

---

# Penutup Kurikulum: Referensi Resmi Wajib

Sesuai kurikulum awal, berikut referensi resmi yang wajib Anda baca:

- [ ] `zsh(1)` — gambaran umum Zsh.
- [ ] `zshoptions(1)` — semua option.
- [ ] `zshexpn(1)` — ekspansi parameter, glob, aritmetika.
- [ ] `zshparam(1)` — parameter dan array.
- [ ] `zshbuiltins(1)` — builtin Zsh.
- [ ] `zshzle(1)` — ZLE, widget, keymap.
- [ ] `zshcompsys(1)` — completion system.

Cara membacanya:

```zsh
man zsh
man zshoptions
man zshexpn
man zshparam
man zshbuiltins
man zshzle
man zshcompsys
```

Penjelasan:

- `man` — manual.
- `zsh` — halaman utama.
- `zshoptions` — opsi.
- `zshexpn` — ekspansi.
- `zshparam` — parameter.
- `zshbuiltins` — builtin.
- `zshzle` — ZLE.
- `zshcompsys` — completion.

---

# Target Akhir

- [ ] Tidak hanya memakai plugin Zsh.
- [ ] Bisa membaca source code plugin.
- [ ] Bisa memahami mekanisme Zsh yang dipakai plugin.
- [ ] Bisa memodifikasi.
- [ ] Bisa membuat custom feature sendiri.

---

Kurikulum inti dari **Zsh Foundation → Zsh Options → Interactive Zsh → Struktur Konfigurasi → Zsh Internals → Productivity Engineering** sudah selesai. Anda sekarang memiliki peta lengkap untuk membangun lingkungan Zsh pribadi yang benar-benar Anda pahami, bukan sekadar menyalin dotfiles orang lain.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-5/README.md
[selanjutnya]: ../bagian-7/README.md

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

