# Login | No Login

Topik ini adalah fondasi di balik banyak kasus "kok PATH/alias saya ada di terminal, tapi hilang di skrip, SSH, atau aplikasi GUI?". Ada **dua sumbu independen**, dan kombinasinya menentukan file konfigurasi mana yang dibaca zsh.

## 1. Dua sumbu

**Login shell.** zsh menganggap dirinya login shell jika karakter pertama `argv[0]` adalah `-` (mis. `-zsh`, cara `login(1)` meluncurkannya) atau jika dijalankan dengan `-l`. Ini hanya *penanda* agar shell membaca file profil sesi.

**Interactive shell.** Ini shell yang berdialog dengan manusia: perintah dibaca dari TTY (stdin berupa terminal, tanpa `-c` atau file skrip), atau dipaksa dengan `-i`. Prompt, ZLE (line editor), history, job control, dan completion aktif. Shell non-interaktif (`-c`, file skrip, pipa) tidak punya semua itu, berhenti pada error fatal, dan tidak membaca `.zshrc`. Satu detail khas zsh: komentar `#` di command line baru dikenali jika `setopt interactive_comments`, sedangkan di skrip selalu dikenali.

Cek status shell yang sedang berjalan:

```zsh
[[ -o login ]]       && echo login       || echo non-login
[[ -o interactive ]] && echo interactive || echo non-interactive
ps -p $$ -o args=     # tampil "-zsh" atau "zsh -l" bila login shell
echo $SHLVL           # kedalaman shell bersarang
```

`$SHELL` hanya mencerminkan login shell di `/etc/passwd` (hasil `chsh`), bukan shell yang sedang berjalan.

## 2. Aturan baca file startup zsh

zsh memakai tiga "gerbang" yang independen:

```
SELALU          : /etc/zsh/zshenv   → ~/.zshenv
bila login      : /etc/zsh/zprofile → ~/.zprofile
bila interaktif : /etc/zsh/zshrc    → ~/.zshrc
bila login      : /etc/zsh/zlogin   → ~/.zlogin
login shell keluar: ~/.zlogout → /etc/zsh/zlogout
```

| File | 1. login + interaktif | 2. login + non-interaktif | 3. non-login + interaktif | 4. non-login + non-interaktif |
|---|:-:|:-:|:-:|:-:|
| `zshenv` (global + user) | ✓ | ✓ | ✓ | ✓ |
| `zprofile` (global + user) | ✓ | ✓ | – | – |
| `zshrc` (global + user) | ✓ | – | ✓ | – |
| `zlogin` (global + user) | ✓ | ✓ | – | – |

**Spesifik Arch:** paket `zsh` hanya menyediakan `/etc/zsh/zprofile`, yang pada dasarnya meng-source `/etc/profile` (cek dengan `cat /etc/zsh/zprofile`). `/etc/profile` membangun PATH dasar dan memuat `/etc/profile.d/*.sh` (mis. `locale.sh` yang memuat `/etc/locale.conf`). Jadi hanya login shell yang menjalankan ini langsung. Shell non-login mendapatkannya lewat **pewarisan environment** dari proses induk.

## 3. Empat mode secara mendalam

### Mode 1: login + interaktif

**Pemicu:**
- login di TTY (getty → login)
- `ssh host` tanpa perintah
- `su - user`, `sudo -i`
- `zsh -l` atau `exec zsh -l`
- **setiap pane tmux**, karena tmux secara default membuat login shell

**Dibaca:** `zshenv → zprofile → zshrc → zlogin`, lalu `zlogout` saat keluar. Ini satu-satunya mode yang menyentuh semua file.

**Karakter:** di sinilah environment sesi "dilahirkan". PAM menyiapkan sesi logind dan `XDG_RUNTIME_DIR` (`pam_systemd`) serta membaca `/etc/environment` (`pam_env`). Setelah itu berjalan `/etc/profile` dan `~/.zprofile`. Mode ini cocok untuk env per-sesi dan autostart compositor.

**Jebakan:**
- **tmux:** `.zprofile` dan `/etc/profile` berjalan ulang di tiap pane, sehingga PATH bisa ganda bila tidak idempoten. Perbaikannya adalah `set -g default-command "${SHELL}"` di `tmux.conf` (pane jadi non-login) atau `typeset -U path`.
- **`exec` di `.zprofile`** (mis. `exec sway`) menggantikan shell *sebelum* `.zshrc` dan `.zlogin` dibaca. Variabel yang hanya di-export di `.zshrc` tidak akan sampai ke aplikasi yang diluncurkan compositor (launcher, keybinding). Di terminal variabel itu tampak normal karena shell non-login di terminal membaca `.zshrc` sendiri.
- Jangan autostart sesi grafis dari `.zlogin`. Pada titik itu konfigurasi interaktif dari `.zshrc` sudah dimuat dan ikut mencemari environment.

### Mode 2: login + non-interaktif

**Pemicu:**
- `zsh -lc 'cmd'`
- `su - user -c 'cmd'`
- `sudo -i cmd`
- shebang `#!/usr/bin/env -S zsh -l`
- alat atau launcher yang menjalankan `$SHELL -l -c …` (kadang `-ilc`) untuk menangkap environment pengguna

**Dibaca:** `zshenv → zprofile → zlogin`. `zshrc` dilewati.

**Karakter:** environment sesi lengkap (termasuk `/etc/profile` Arch) tanpa lapisan interaktif. Alias, fungsi, prompt, `compinit`, plugin zinit, dan `setopt` dari `.zshrc` tidak tersedia. Mode ini pas untuk tugas otomatis yang butuh env pengguna penuh, misalnya pembungkus job.

**Jebakan:**
- Logika autostart di `.zprofile` ikut jalan di mode ini. Beri guard dengan `[[ -o interactive ]]` atau cek TTY.
- Output apa pun dari file profil bercampur ke stdout yang dibaca pemanggil.

### Mode 3: non-login + interaktif

**Pemicu:**
- membuka emulator terminal di sesi grafis (Alacritty, foot, kitty, GNOME Terminal, Konsole umumnya non-login secara default di Linux; berbeda dengan Terminal.app di macOS yang login, yang sering membingungkan di tutorial online)
- mengetik `zsh` di shell yang berjalan
- `su user` (tanpa `-`) atau `sudo -s`
- `:terminal` di Neovim
- pane tmux, bila `default-command` diubah

**Dibaca:** `zshenv → zshrc`.

**Karakter:** ini mode harian. `.zprofile` tidak dibaca. Environment datang dari **pewarisan** (terminal ← compositor atau DM ← login). Variabel yang di-export di rantai induk tetap terlihat. Yang tidak ikut terwariskan adalah alias, fungsi, opsi `setopt`, dan variabel yang tidak di-export. Karena itu semua hal interaktif wajib ada di `.zshrc`.

**Jebakan:** bila sesi grafis dimulai oleh display manager (SDDM, GDM, greetd) dan bukan shell login, `~/.zprofile` belum tentu pernah dibaca (tergantung implementasi DM). Variabel di sana lalu "hilang" di terminal GUI. Opsinya:
- pindahkan ke `~/.zshenv`
- pakai `~/.config/environment.d/*.conf` (berlaku untuk proses turunan `systemd --user`, bukan otomatis untuk anak shell login)
- jalankan terminal dengan `zsh -l`

### Mode 4: non-login + non-interaktif

**Pemicu:**
- `zsh script.zsh` atau `./script.zsh` (shebang zsh)
- `zsh -c 'cmd'`
- **`ssh host 'cmd'`**, termasuk `ssh -t`: pty tidak mengubah mode karena shell dijalankan dengan `-c`
- `scp`, `rsync`, `git` lewat SSH
- `:!cmd` di Vim/Neovim (`$SHELL -c`)
- git hooks dan `find -exec zsh -c`
- unit systemd yang `ExecStart`-nya memanggil `zsh -c`

**Dibaca:** hanya `/etc/zsh/zshenv` dan `~/.zshenv`.

**Karakter:** ini mode paling bersih sekaligus paling rawan kejutan. Tidak ada alias, fungsi, plugin, maupun env dari `.zprofile` atau `.zshrc`. `~/.zshenv` adalah satu-satunya titik kustomisasi yang dijamin.

**Jebakan:**
- Output apa pun di `.zshenv` merusak protokol `scp`, `sftp`, `rsync`, dan `git` via SSH.
- File ini dibaca di *setiap* eksekusi zsh, termasuk skrip. Jangan taruh yang berat seperti `eval "$(starship init zsh)"` atau init manajer versi.
- Untuk baseline bersih di skrip atau debugging, pakai `zsh -f`. Opsi ini melewati semua file startup kecuali `/etc/zsh/zshenv`.
- Skrip `#!/bin/bash` atau `/bin/sh` (di Arch `/bin/sh` → bash) tidak membaca file zsh sama sekali. Proses yang diluncurkan systemd langsung tanpa shell berada di luar keempat mode ini: tidak ada file startup yang dibaca.

## 4. Alur environment (contoh: Wayland dimulai dari TTY)

```
getty@tty1 → login (PAM) → -zsh                       [1: login + interaktif]
                             │ zshenv → zprofile (+/etc/profile)
                             │ zprofile: export …; exec sway
                             ▼
                           sway          (mewarisi env; menggantikan proses shell)
                             └─ foot     (keybinding)
                                  └─ zsh                [3: non-login + interaktif]  zshenv → zshrc
                                       ├─ tmux → zsh    [1*: login + interaktif, default tmux]
                                       ├─ zsh -c / skrip[4: non-login + non-interaktif] zshenv saja
                                       └─ zsh -lc 'cmd' [2: login + non-interaktif] zshenv → zprofile → zlogin
```

## 5. Pembagian tugas tiap file

| File | Mode | Isi yang ideal |
|---|---|---|
| `~/.zshenv` | 1–4 | Env minimal, idempoten, tanpa output: `XDG_*`, PATH pribadi, `ZDOTDIR` |
| `~/.zprofile` | 1, 2 | Env per-sesi, autostart compositor (dengan guard) |
| `~/.zshrc` | 1, 3 | Semua yang interaktif: prompt, zinit/plugin, `compinit`, `bindkey`, alias, `setopt`, history |
| `~/.zlogin` | 1, 2 | Jarang dipakai; untuk hal yang butuh `.zshrc` sudah termuat |
| `~/.zlogout` | login shell | Pembersihan saat keluar |

```zsh
# ~/.zshenv: dibaca SEMUA mode, jadi jaga kecil dan tanpa output
export XDG_CONFIG_HOME="$HOME/.config"
typeset -U path PATH                 # cegah entri ganda (shell bersarang/tmux)
path=("$HOME/.local/bin" $path)
```

```zsh
# ~/.zprofile: hanya login shell (sesuaikan: sway / Hyprland / niri)
if [[ -o interactive && -z $WAYLAND_DISPLAY && ${XDG_VTNR:-0} -eq 1 ]]; then
  exec sway
fi
```

## 6. Eksperimen dan debugging

Mensimulasikan keempat mode lewat flag:

```zsh
probe='[[ -o login ]] && L=login || L=non-login; [[ -o interactive ]] && I=interactive || I=non-interactive; print "$L + $I"'
zsh -l -i -c "$probe"   # login + interactive
zsh -l    -c "$probe"   # login + non-interactive
zsh    -i -c "$probe"   # non-login + interactive
zsh       -c "$probe"   # non-login + non-interactive
```

Melihat file apa saja yang benar-benar dibaca:

```zsh
zsh -o SOURCE_TRACE -l -i -c exit      # zsh mencetak nama tiap file yang di-source
strace -f -e trace=openat zsh -l -i -c exit 2>&1 | grep -E '/etc/zsh/|\.z(shenv|profile|shrc|login|logout)'
```

`strace` (`pacman -S strace`) juga menampilkan file yang dicari tetapi tidak ada (`ENOENT`). Untuk menguji dari environment nyaris kosong:

```zsh
env -i HOME="$HOME" TERM="$TERM" zsh -l -i       # simulasi sesi login bersih
env -i HOME="$HOME" zsh -c 'print -r -- $PATH'   # yang dilihat skrip non-interaktif
```

## 7. Catatan lanjutan

- **`ZDOTDIR`**: file user selain `.zshenv` dicari di `$ZDOTDIR` (default `$HOME`). Pola umum: `~/.zshenv` hanya berisi `export ZDOTDIR="$HOME/.config/zsh"`.
- **`NO_GLOBAL_RCS`**: bila di-set di `~/.zshenv`, opsi ini mematikan `/etc/zsh/{zprofile,zshrc,zlogin}`. Di Arch itu berarti `/etc/profile` dan `profile.d` tidak termuat di login shell, jadi hati-hati.
- **Mode emulasi**: bila zsh dipanggil dengan nama `sh` atau `ksh`, ia membaca `/etc/profile`, `~/.profile`, dan `$ENV` seperti shell POSIX, bukan file zsh.
- **Bash berbeda**: login membaca `/etc/profile` lalu salah satu dari `~/.bash_profile`, `~/.bash_login`, `~/.profile`. Interaktif non-login membaca `~/.bashrc`. Non-interaktif memakai `$BASH_ENV`. Bash tidak punya padanan `.zshenv` yang selalu dibaca.

## 8. Ke depan

- Tiga prinsip yang menghindari sebagian besar masalah adalah **idempoten** (`typeset -U path`), **tanpa output** di file yang dibaca mode non-interaktif, dan **guard** pada autostart.
- Untuk env yang harus menjangkau layanan `systemd --user` dan aplikasi GUI, pelajari `environment.d`. Manajer sesi Wayland berbasis systemd seperti `uwsm` juga layak dieksplorasi.
- Model mental yang ringkas: **environment itu warisan antar proses, sedangkan konfigurasi interaktif itu per-shell.**

> By Claude
<!-- Jika ingin, tempelkan isi `.zshenv`, `.zprofile`, dan `.zshrc` Anda, dan saya bantu audit penempatannya terhadap keempat mode ini. -->
