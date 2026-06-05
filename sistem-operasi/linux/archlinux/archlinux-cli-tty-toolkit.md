# 🖥️ ARCH LINUX CLI/TTY ULTIMATE TOOLKIT

## Panduan Lengkap — Full TTY tanpa GUI Desktop Environment

> **Filosofi**: Menguasai sepenuhnya ekosistem CLI/TUI Arch Linux — menonton video, browsing web,
> email, chat, musik, manajemen file, development — **semua tanpa X11, Wayland, atau Desktop Environment.**

---

## 📋 LEGENDA STATUS

| Simbol | Keterangan |
|--------|-----------|
| 📦 **pacstrap** | Tersedia di repo resmi — **bisa diinstall langsung saat proses instalasi Arch** |
| ✅ **Official** | Tersedia di repositori resmi Arch (core/extra/multilib) via `pacman` |
| 🔶 **AUR** | Hanya di Arch User Repository — perlu AUR helper (`yay`/`paru`) |
| ⚡ **PRIORITAS TINGGI** | Wajib dipertimbangkan, backbone workflow TTY |
| 🔄 **PRIORITAS SEDANG** | Berguna sesuai kebutuhan spesifik |
| 💡 **OPSIONAL** | Pelengkap atau alternatif yang layak dicoba |

---

## ═══════════════════════════════════════
## 1. 🐚 SHELL & PROMPT — Fondasi Utama
## ═══════════════════════════════════════

### 1.1 `zsh` ⚡ 📦

**Tujuan**: Shell modern pengganti bash — auto-completion superior, history berbasis konteks, globbing
canggih, dan ekosistem plugin terkaya. Standar de facto power user Linux.

**Penggunaan Dasar**:
```bash
pacman -S zsh
chsh -s /usr/bin/zsh              # Jadikan default shell (perlu logout)
zsh --help
man zsh

# File konfigurasi utama:
~/.zshrc          # Konfigurasi interaktif
~/.zprofile       # Login shell config
~/.zshenv         # Selalu diload
```

**Plugin Manager Rekomendasi**:
```bash
# zinit (tercepat, paling fleksibel):
yay -S zinit

# Atau Oh My Zsh (paling populer):
yay -S oh-my-zsh-git

# Plugin wajib ditambahkan:
# - zsh-autosuggestions
# - zsh-syntax-highlighting
# - zsh-history-substring-search
```

**Kata Kunci**: `zsh archlinux setup`, `zsh plugins zinit`, `zshrc configuration`, `zsh completions`

**Catatan**: Plugin `zsh-autosuggestions` sendirian sudah mengubah pengalaman CLI secara dramatis.

---

### 1.2 `fish` 🔄 ✅

**Tujuan**: Shell ramah pengguna dengan fitur bawaan out-of-the-box — syntax highlighting, auto-suggest,
web config, tanpa konfigurasi tambahan.

**Penggunaan Dasar**:
```bash
pacman -S fish
chsh -s /usr/bin/fish
fish_config          # Buka konfigurasi via TUI browser
fish --help
man fish

# Abbreviations (alias cerdas):
abbr -a gst 'git status'
```

**Kata Kunci**: `fish shell setup`, `fish abbreviations`, `fish functions`, `fish vs zsh`

**Catatan**: Tidak POSIX-compatible, jangan gunakan sebagai `/bin/sh`. Unggul untuk penggunaan
interaktif, kurang ideal untuk scripting sistem.

---

### 1.3 `starship` ⚡ ✅

**Tujuan**: Prompt shell universal berbasis Rust — cross-shell, informatif (git branch, runtime bahasa,
exit code, waktu, battery), dan sangat cepat.

**Penggunaan Dasar**:
```bash
pacman -S starship

# Tambahkan ke ~/.zshrc:
eval "$(starship init zsh)"
# Atau ~/.bashrc:
eval "$(starship init bash)"

starship explain           # Jelaskan setiap modul prompt
starship timings           # Benchmark per modul
```

**Konfigurasi** (`~/.config/starship.toml`):
```toml
[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"

[git_branch]
symbol = " "

[battery]
full_symbol = "🔋"
```

**Kata Kunci**: `starship prompt config`, `starship.toml`, `starship modules`, `starship archlinux`

---

### 1.4 `tmux` ⚡ 📦

**Tujuan**: Terminal multiplexer — **tool PALING WAJIB** di setup TTY. Bagi satu terminal menjadi
banyak pane/window, session persisten (survive logout, server disconnect), dan manajemen workspace.

**Penggunaan Dasar**:
```bash
pacman -S tmux
tmux                          # Session baru
tmux new -s kerja             # Session bernama
tmux ls                       # List session aktif
tmux a -t kerja               # Attach ke session 'kerja'
tmux kill-session -t kerja    # Hapus session

# Shortcut dalam tmux (PREFIX = Ctrl+b):
PREFIX c       # Window baru
PREFIX %       # Split vertikal (pane kanan)
PREFIX "       # Split horizontal (pane bawah)
PREFIX h/j/k/l # Navigasi antar pane (butuh config)
PREFIX d       # Detach dari session
PREFIX [       # Masuk scroll/copy mode
PREFIX ]       # Paste dari buffer
PREFIX z       # Zoom pane (fullscreen toggle)
PREFIX ,       # Rename window
PREFIX $       # Rename session
```

**Plugin Manager (TPM)**:
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Tambah di ~/.tmux.conf:
# set -g @plugin 'tmux-plugins/tpm'
# set -g @plugin 'tmux-plugins/tmux-sensible'
# set -g @plugin 'tmux-plugins/tmux-resurrect'   # Restore sessions
# set -g @plugin 'tmux-plugins/tmux-continuum'   # Auto-save sessions
# set -g @plugin 'tmux-plugins/tmux-yank'        # Clipboard
# PREFIX I = Install plugins
```

**Kata Kunci**: `tmux cheatsheet`, `tmux config archlinux`, `tmux TPM plugins`, `tmux resurrect`,
`tmux copy mode`, `tmux pane navigation`

**Catatan**: Tersedia di pacstrap. **Install ini pertama kali setelah boot ke sistem baru.**

---

### 1.5 `zellij` 🔄 ✅

**Tujuan**: Multiplexer terminal modern berbasis Rust — keybinding terlihat di layar (tidak perlu
hafal), layout bawaan, dan plugin system berbasis WASM.

**Penggunaan Dasar**:
```bash
pacman -S zellij
zellij                      # Jalankan
zellij --layout compact     # Layout compact
zellij list-sessions        # Daftar session
zellij attach nama          # Attach session
zellij --help
```

**Kata Kunci**: `zellij layouts`, `zellij config`, `zellij vs tmux`, `zellij plugins`

**Catatan**: Lebih mudah dipelajari dari tmux tapi ekosistemnya masih berkembang. tmux lebih mature
dan didukung lebih banyak tools.

---

## ═══════════════════════════════════════
## 2. 📂 MANAJEMEN FILE
## ═══════════════════════════════════════

### 2.1 `ranger` ⚡ ✅

**Tujuan**: File manager TUI berbasis Python dengan navigasi vi-style (hjkl), preview file teks/gambar,
panel tiga kolom, dan integrasi skrip bash yang sangat kuat.

**Penggunaan Dasar**:
```bash
pacman -S ranger
ranger                        # Jalankan
ranger --copy-config=all      # Generate config ke ~/.config/ranger/

# Navigasi:
h/j/k/l    # Navigasi direktori
gg / G     # Awal / akhir list
Space      # Select file
v          # Visual select mode
yy         # Copy/yank
pp         # Paste
dd         # Cut
dD         # Delete (dengan konfirmasi)
zh         # Toggle hidden files
:shell     # Buka shell sementara
:rename    # Rename file
:mkdir     # Buat direktori
s          # Sort files
z          # Settings
r          # Open with (menggunakan rifle)
```

**Kata Kunci**: `ranger file manager`, `ranger config archlinux`, `ranger rifle opener`,
`ranger image preview`, `ranger scope.sh`, `ranger bookmarks`

**Catatan**: `rifle.conf` mengontrol aplikasi apa yang membuka file tertentu. `scope.sh` mengontrol
preview file. Dukung preview gambar via `ueberzug` (AUR) untuk X11 atau `chafa` untuk TTY murni.

---

### 2.2 `lf` ⚡ ✅

**Tujuan**: File manager TUI berbasis Go — lebih cepat dari ranger, sangat ringan, vi-keybindings,
dan konfigurasi via shell script murni.

**Penggunaan Dasar**:
```bash
pacman -S lf
lf               # Jalankan
lf --help

# Keybinding sama dengan ranger (hjkl)
# Konfigurasi di ~/.config/lf/lfrc
```

**Kata Kunci**: `lf file manager config`, `lf previewer`, `lf lfrc`, `lf icons`, `lf vs ranger`

**Catatan**: Lebih ringan dari ranger. Pasangkan dengan `pistol` (AUR) atau script custom untuk
file preview. Butuh lebih banyak konfigurasi manual.

---

### 2.3 `nnn` ⚡ ✅

**Tujuan**: File manager terminal **tercepat** — sangat ringan (tidak ada dependency Python/Go),
plugin ecosystem yang luas, dan mendukung bookmark, bulk rename, dan disk usage.

**Penggunaan Dasar**:
```bash
pacman -S nnn
nnn              # Jalankan
nnn -H           # Tampilkan hidden files
nnn -e           # Open files in text editor
nnn -d           # Detail mode

# Navigasi: Arrow keys
# Enter → buka file/masuk folder
# q → quit
# . → toggle hidden
# Tab → switch context
```

**Kata Kunci**: `nnn file manager`, `nnn plugins github`, `nnn configuration`, `nnn bookmarks`

**Catatan**: Plugin tersedia di [github.com/jarun/nnn/tree/master/plugins](https://github.com/jarun/nnn).
Plugin `preview-tui` sangat direkomendasikan.

---

### 2.4 `mc` (Midnight Commander) 🔄 📦

**Tujuan**: File manager dua panel klasik (Orthodox File Manager) — sangat mudah digunakan, tidak
perlu hafal banyak shortcut, ideal untuk migrasi dari GUI file manager.

**Penggunaan Dasar**:
```bash
pacman -S mc
mc               # Jalankan

# Function keys:
# F1=Help  F2=Menu   F3=View   F4=Edit
# F5=Copy  F6=Move   F7=MkDir  F8=Delete
# F9=Menu  F10=Exit

# Navigasi: Arrow keys
# Tab → switch panel
# Ctrl+O → hide panels (shell view)
```

**Kata Kunci**: `midnight commander config`, `mc shortcuts`, `mc FTP SFTP`

**Catatan**: Tersedia di pacstrap. Mendukung koneksi SFTP/FTP langsung dari interface. Pilihan
terbaik untuk pengguna yang baru migrasi dari GUI.

---

### 2.5 `vifm` 💡 ✅

**Tujuan**: File manager dua panel dengan keybinding **identik** dengan vim — pilihan terbaik bagi
pengguna yang ingin konsistensi vim di mana-mana.

**Penggunaan Dasar**:
```bash
pacman -S vifm
vifm             # Jalankan
# Keybinding vim penuh berlaku
```

**Kata Kunci**: `vifm config`, `vifm colorscheme`, `vifm preview`, `vifm vim integration`

---

### 2.6 `eza` ⚡ ✅

**Tujuan**: Pengganti `ls` modern — warna per tipe file, ikon (butuh nerd font), info git, tree view,
dan extended attributes.

**Penggunaan Dasar**:
```bash
pacman -S eza
eza                     # List basic
eza -la                 # Detail + hidden files
eza --tree              # Tree view
eza --tree --level=2    # Tree depth 2
eza --git               # Tampilkan status git
eza -lh --sort=size     # Sort by size

# Aliases di ~/.zshrc:
alias ls='eza --icons'
alias ll='eza -la --icons'
alias lt='eza --tree --icons'
```

**Kata Kunci**: `eza ls replacement`, `eza icons nerd font`, `eza git status`

---

### 2.7 `bat` ⚡ ✅

**Tujuan**: Pengganti `cat` dengan syntax highlighting untuk 200+ bahasa, nomor baris, Git diff
integration, dan pager bawaan yang cerdas.

**Penggunaan Dasar**:
```bash
pacman -S bat
bat file.py               # Baca dengan highlighting
bat -n file.txt           # Hanya nomor baris
bat --list-themes         # Daftar tema warna
bat --theme=TwoDark file  # Pilih tema spesifik
bat -p file.txt           # Plain output (tanpa decoration)
bat *.conf                # Multiple files

# Jadikan default PAGER:
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
```

**Kata Kunci**: `bat cat replacement`, `bat themes`, `bat config`, `bat syntax highlighting`

---

### 2.8 `zoxide` ⚡ ✅

**Tujuan**: Pengganti `cd` berbasis Rust yang mengingat direktori sering dikunjungi dan melompat ke
sana hanya dengan kata kunci parsial — seperti teleportasi.

**Penggunaan Dasar**:
```bash
pacman -S zoxide

# Tambahkan ke ~/.zshrc:
eval "$(zoxide init zsh)"

# Penggunaan:
z proj               # Lompat ke direktori yang mengandung 'proj'
z home src           # Lompat ke path mengandung 'home' dan 'src'
zi                   # Interactive dengan fzf
z -                  # Kembali ke direktori sebelumnya
```

**Kata Kunci**: `zoxide autojump`, `zoxide fzf integration`, `zoxide setup zsh`

---

## ═══════════════════════════════════════
## 3. ✏️ TEXT EDITOR
## ═══════════════════════════════════════

### 3.1 `neovim` ⚡ 📦

**Tujuan**: Text editor modal modern berbasis Lua — LSP bawaan, treesitter, async plugin system, dan
ekosistem plugin terkaya di dunia CLI. **De facto** editor untuk developer serius di CLI.

**Penggunaan Dasar**:
```bash
pacman -S neovim
nvim file.txt        # Buka file
nvim .               # File explorer (netrw)
nvim --help
nvim +PlugInstall    # Install plugins

# Mode:
# Normal  → navigasi & perintah (default)
# Insert  → i untuk masuk
# Visual  → v untuk select
# Command → : untuk perintah
# Escape  → kembali ke Normal

# Perintah esensial:
:w       # Save
:q       # Quit
:wq      # Save + quit
:q!      # Force quit
:help topik     # Bantuan
:Tutor          # Tutorial interaktif (30 menit)
```

**Distribusi Config Siap Pakai** (pilih salah satu):
```bash
# LazyVim (paling direkomendasikan, modern):
git clone https://github.com/LazyVim/starter ~/.config/nvim

# NvChad (populer, tampilan cantik):
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

# AstroNvim:
git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
```

**Kata Kunci**: `neovim config lua`, `LazyVim setup`, `NvChad`, `neovim LSP`, `neovim plugins`,
`nvim init.lua`, `neovim treesitter`, `neovim lazy.nvim`

**Catatan**: Tersedia di pacstrap. Invest waktu untuk setup neovim dengan baik — hasilnya adalah
IDE penuh di terminal.

---

### 3.2 `helix` ⚡ ✅

**Tujuan**: Editor modal modern berbasis Rust — LSP dan treesitter **bawaan tanpa plugin**, multiple
cursors, dan filosofi "selection-first" yang berbeda dari vim.

**Penggunaan Dasar**:
```bash
pacman -S helix
hx file.txt          # Buka file
hx --tutor           # Tutorial interaktif
hx --health          # Cek status LSP per bahasa

# Filosofi: pilih dulu, lalu aksi
# w → select word, then d to delete
# Space + f → file picker
# Space + b → buffer picker
# Ctrl+w + v → split vertikal
```

**Kata Kunci**: `helix editor tutorial`, `helix LSP config`, `helix keybindings`, `helix languages.toml`

**Catatan**: Zero-config langsung produktif. Tidak perlu install plugin — LSP dikonfigurasi otomatis
untuk bahasa yang terdeteksi.

---

### 3.3 `micro` 🔄 ✅

**Tujuan**: Editor TUI yang **intuitif seperti editor GUI** — shortcut standar (Ctrl+S, Ctrl+C,
Ctrl+Z), plugin system, dan mouse support. Ideal untuk yang tidak mau belajar vim.

**Penggunaan Dasar**:
```bash
pacman -S micro
micro file.txt       # Buka file
micro --help

# Shortcut:
# Ctrl+S → Save
# Ctrl+Q → Quit
# Ctrl+Z → Undo
# Ctrl+F → Find
# Ctrl+G → Help
# Ctrl+E → Command mode
```

**Kata Kunci**: `micro editor plugins`, `micro shortcuts`, `micro config`

---

### 3.4 `nano` 🔄 📦

**Tujuan**: Editor paling sederhana — ideal untuk edit cepat file konfigurasi. Selalu tersedia di
sistem minimal.

**Penggunaan Dasar**:
```bash
pacman -S nano
nano /etc/hosts      # Edit file
nano --help

# Ctrl+O → Save (Write Out)
# Ctrl+X → Exit
# Ctrl+W → Search
# Ctrl+K → Cut baris
# Ctrl+U → Paste
# Ctrl+G → Help
```

**Aktifkan Syntax Highlighting**:
```bash
echo "include /usr/share/nano/*.nanorc" >> ~/.nanorc
```

**Kata Kunci**: `nano shortcuts`, `nanorc syntax highlighting`, `nano config`

**Catatan**: Tersedia di pacstrap. Pilihan fallback yang selalu bisa diandalkan.

---

## ═══════════════════════════════════════
## 4. 📊 MONITORING SISTEM
## ═══════════════════════════════════════

### 4.1 `btop` ⚡ ✅

**Tujuan**: System monitor all-in-one yang visual dan komprehensif — CPU per-core, RAM, swap, network,
storage, dan process manager dengan tampilan yang indah. Pengganti htop modern.

**Penggunaan Dasar**:
```bash
pacman -S btop
btop                     # Jalankan
btop --help

# Dalam btop:
# m → menu
# f → filter proses
# k → kill proses pilihan
# s → sort kolom
# 1-4 → layout preset
# q → quit
```

**Kata Kunci**: `btop config`, `btop themes`, `btop shortcuts`, `btop archlinux`

---

### 4.2 `htop` ⚡ 📦

**Tujuan**: Process viewer interaktif ringan — sorting, filter, kill process, tree view. Classic yang
tak tergantikan.

**Penggunaan Dasar**:
```bash
pacman -S htop
htop                     # Jalankan
htop --help

# F2 → Setup konfigurasi
# F3/F4 → Search/Filter
# F5 → Tree view
# F6 → Sort
# F9 → Kill process
# F10 → Quit
```

**Kata Kunci**: `htop shortcuts`, `htop config`, `htop tree view`

**Catatan**: Tersedia di pacstrap. Lebih ringan dari btop, pilihan terbaik di sistem resource-terbatas.

---

### 4.3 `bottom` ⚡ ✅

**Tujuan**: System monitor berbasis Rust (perintah: `btm`) — grafik CPU/memory/network yang smooth
dengan interface yang dapat dikustomisasi.

**Penggunaan Dasar**:
```bash
pacman -S bottom
btm                      # Jalankan
btm --help
btm --basic             # Mode tampilan minimal

# Dalam btm:
# q → quit
# e → expand widget
# / → filter proses
```

**Kata Kunci**: `bottom btm rust`, `bottom system monitor`, `bottom archlinux`

---

### 4.4 `ncdu` ⚡ ✅

**Tujuan**: Disk Usage Analyzer interaktif — temukan file dan folder besar yang memakan storage
dengan navigasi TUI yang mudah.

**Penggunaan Dasar**:
```bash
pacman -S ncdu
ncdu /           # Scan seluruh sistem
ncdu ~           # Scan home directory
ncdu --help

# Dalam ncdu:
# ↑↓ → navigasi
# Enter → masuk folder
# d → delete (dengan konfirmasi)
# e → exclude pattern
# ? → help
# q → quit
```

**Kata Kunci**: `ncdu disk usage`, `ncdu scan path`, `ncdu delete files`

---

### 4.5 `duf` ✅

**Tujuan**: Pengganti `df` yang visual — tampilkan penggunaan disk semua mount point dengan warna,
bar progress, dan format tabel yang rapi.

**Penggunaan Dasar**:
```bash
pacman -S duf
duf              # Semua mount point
duf /home        # Spesifik path
duf --help
```

**Kata Kunci**: `duf disk free`, `duf df replacement`

---

### 4.6 `glances` 🔄 ✅

**Tujuan**: Monitor sistem all-in-one yang bisa diakses via terminal, web browser (REST API), atau
mode client-server — cocok untuk monitoring server remote.

**Penggunaan Dasar**:
```bash
pacman -S glances
glances                  # Mode terminal
glances -w               # Mode web server (port 61208)
glances --webui          # Web UI
glances -c hostname      # Mode client (remote monitoring)
```

**Kata Kunci**: `glances monitor`, `glances web mode`, `glances API`, `glances server monitoring`

---

### 4.7 `inxi` ✅

**Tujuan**: Tool informasi sistem hardware yang komprehensif — CPU, GPU, RAM, storage, network,
sensors, driver — sangat berguna untuk troubleshooting.

**Penggunaan Dasar**:
```bash
pacman -S inxi
inxi -F              # Full system info
inxi -G              # GPU info
inxi -N              # Network adapters
inxi -C              # CPU detail
inxi -D              # Disk info
inxi -S              # System/OS info
```

**Kata Kunci**: `inxi system info`, `inxi -F hardware`, `inxi GPU driver`

---

## ═══════════════════════════════════════
## 5. 🌐 JARINGAN & KONEKTIVITAS
## ═══════════════════════════════════════

### 5.1 `NetworkManager` + `nmtui` ⚡ 📦

**Tujuan**: Manajemen jaringan lengkap (WiFi, Ethernet, VPN, Mobile Broadband) dengan antarmuka TUI
yang mudah digunakan — **pilihan utama** untuk manajemen network di TTY.

**Penggunaan Dasar**:
```bash
pacman -S networkmanager
systemctl enable --now NetworkManager

nmtui                              # TUI interaktif (PALING MUDAH)
nmtui-connect                      # Langsung ke connect WiFi

# CLI dengan nmcli:
nmcli dev status                   # Status semua perangkat
nmcli wifi list                    # Scan jaringan WiFi tersedia
nmcli wifi connect "NamaSSID" password "password123"
nmcli con show                     # Semua koneksi tersimpan
nmcli con up "nama-koneksi"        # Aktifkan koneksi
nmcli con down "nama-koneksi"      # Nonaktifkan koneksi
nmcli radio wifi off               # Matikan WiFi
```

**Kata Kunci**: `nmtui TUI WiFi`, `nmcli commands`, `NetworkManager archlinux`,
`nmcli wifi connect`, `NetworkManager VPN`

**Catatan**: **Wajib install saat pacstrap**. Pilih NetworkManager ATAU iwd, tidak keduanya untuk
WiFi management.

---

### 5.2 `iwd` + `iwctl` 🔄 📦

**Tujuan**: Backend WiFi modern dari Intel — lebih ringan dari wpa_supplicant, koneksi lebih cepat,
dengan mode TUI interaktif.

**Penggunaan Dasar**:
```bash
pacman -S iwd
systemctl enable --now iwd

iwctl                              # Masuk mode interaktif
[iwd]# device list                 # Daftar perangkat WiFi
[iwd]# station wlan0 scan          # Scan jaringan
[iwd]# station wlan0 get-networks  # Tampilkan hasil scan
[iwd]# station wlan0 connect "SSID"  # Koneksi
[iwd]# exit
```

**Kata Kunci**: `iwd archlinux setup`, `iwctl connect wifi`, `iwd vs NetworkManager`

**Catatan**: Tersedia di pacstrap. Bisa dikombinasikan dengan `systemd-networkd` untuk manajemen IP.
Lebih ringan dari NetworkManager.

---

### 5.3 `curl` ⚡ 📦

**Tujuan**: Transfer data via HTTP, HTTPS, FTP, SFTP dan 20+ protokol lainnya — Swiss army knife
networking yang mutlak diperlukan.

**Penggunaan Dasar**:
```bash
pacman -S curl
curl https://example.com                          # GET request
curl -O https://file.com/file.zip                # Download file
curl -L https://...                              # Follow redirect
curl -X POST -H "Content-Type: application/json" \
     -d '{"key":"value"}' https://api.com        # POST JSON
curl -u user:pass https://secure.com             # Basic auth
curl -I https://example.com                      # Header saja
curl --progress-bar -O "URL"                     # Progress bar
curl -c cookies.txt -b cookies.txt https://...   # Cookie handling
curl --help all | less                           # Semua opsi
man curl
```

**Kata Kunci**: `curl tutorial`, `curl POST JSON`, `curl headers`, `curl authentication`,
`curl download`, `curl REST API`

---

### 5.4 `wget` ⚡ 📦

**Tujuan**: Download file dari web dengan dukungan resume download, recursive website download,
dan mirroring situs.

**Penggunaan Dasar**:
```bash
pacman -S wget
wget https://file.com/file.zip               # Download
wget -c https://...                          # Resume download
wget -q --show-progress https://...         # Progress minimal
wget -r -l2 --no-parent https://website.com # Recursive depth 2
wget --mirror --convert-links https://...   # Mirror situs lengkap
wget -P ~/Downloads/ https://...            # Tentukan direktori
wget --help
man wget
```

**Kata Kunci**: `wget resume download`, `wget recursive`, `wget mirror`, `wget no-parent`

---

### 5.5 `httpie` 🔄 ✅

**Tujuan**: HTTP client modern yang ramah developer — output JSON berwarna dan terformat, sintaks
intuitif untuk testing API, alternatif curl yang lebih mudah dibaca.

**Penggunaan Dasar**:
```bash
pacman -S python-httpie
http GET https://api.example.com              # GET request
http POST https://api.com name=John age:=25   # POST dengan JSON
http GET https://api.com Authorization:"Bearer TOKEN"
http --download https://file.com/file.zip    # Download
http --help
```

**Kata Kunci**: `httpie tutorial`, `http cli API`, `httpie vs curl`, `httpie JSON`

---

### 5.6 `nmap` 🔄 ✅

**Tujuan**: Network scanner untuk audit keamanan — port scanning, OS detection, service/version
discovery, dan network mapping.

**Penggunaan Dasar**:
```bash
pacman -S nmap
nmap 192.168.1.1                # Scan satu host
nmap -sV 192.168.1.0/24        # Scan jaringan + service version
nmap -p 22,80,443 target        # Scan port spesifik
nmap -A target                  # Aggressive scan (OS+service+scripts)
nmap --help
man nmap
```

**Kata Kunci**: `nmap cheatsheet`, `nmap port scan`, `nmap scripts NSE`, `nmap network audit`

---

### 5.7 `openssh` ⚡ 📦

**Tujuan**: Koneksi SSH ke server remote — SSH client, server, dan key management. Fondasi untuk
remote administration dan secure file transfer.

**Penggunaan Dasar**:
```bash
pacman -S openssh
ssh user@hostname                       # Koneksi dasar
ssh -p 2222 user@hostname               # Port custom
ssh -i ~/.ssh/my-key user@hostname      # Gunakan key spesifik
ssh-keygen -t ed25519 -C "email@mail"   # Generate keypair (ed25519 terbaik)
ssh-copy-id user@hostname               # Copy public key ke server
ssh-add ~/.ssh/my-key                   # Add ke ssh-agent

# SSH config (~/.ssh/config):
# Host myserver
#   HostName 192.168.1.100
#   User ubuntu
#   IdentityFile ~/.ssh/my-key
#   Port 22

# SSH Server:
systemctl enable --now sshd
```

**Kata Kunci**: `ssh keygen ed25519`, `ssh config file`, `ssh tunneling`, `ssh port forwarding`,
`ssh key authentication`, `openssh archlinux`

**Catatan**: Tersedia di pacstrap. Gunakan **ed25519** untuk key generation, bukan RSA lama.

---

### 5.8 `mosh` 🔄 ✅

**Tujuan**: Pengganti SSH yang bertahan terhadap koneksi tidak stabil — roaming IP, timeout, latency
tinggi, dan mobile network. Ideal untuk koneksi dari smartphone/laptop mobile.

**Penggunaan Dasar**:
```bash
pacman -S mosh
mosh user@server          # Koneksi (butuh mosh di server juga)
mosh --help
```

**Kata Kunci**: `mosh mobile shell`, `mosh vs SSH`, `mosh setup`

---

### 5.9 `wireguard` + `wg-tools` ⚡ ✅

**Tujuan**: VPN modern berbasis kernel Linux — jauh lebih cepat, sederhana, dan aman dibanding
OpenVPN atau IPSec.

**Penggunaan Dasar**:
```bash
pacman -S wireguard-tools
wg genkey | tee privatekey | wg pubkey > publickey
# Konfigurasi di /etc/wireguard/wg0.conf
wg-quick up wg0                  # Aktifkan VPN
wg-quick down wg0                # Nonaktifkan VPN
systemctl enable --now wg-quick@wg0  # Enable saat boot
wg show                          # Status koneksi
```

**Kata Kunci**: `wireguard archlinux`, `wg-quick setup`, `wireguard VPN config`

---

## ═══════════════════════════════════════
## 6. 🌍 WEB BROWSER CLI/TUI
## ═══════════════════════════════════════

### 6.1 `w3m` ⚡ ✅

**Tujuan**: Browser teks dengan dukungan tabel, frame, cookie, form, dan **rendering gambar inline**
di terminal yang mendukung. Paling cepat untuk akses informasi teks.

**Penggunaan Dasar**:
```bash
pacman -S w3m
w3m https://example.com             # Buka URL
w3m -T text/html file.html          # Buka file HTML
w3m -dump https://site.com | less   # Output teks ke pager

# Navigasi dalam w3m:
# Tab / Shift+Tab → pindah antar link
# Enter → ikuti link
# B → kembali (back)
# H → home (start page)
# g → goto URL baru
# / → search
# q → quit
# o → options
```

**Kata Kunci**: `w3m browser`, `w3m images terminal`, `w3m configuration`, `w3m inline images`

**Catatan**: Package `w3m` di Arch sudah termasuk dukungan gambar via framebuffer.

---

### 6.2 `lynx` 🔄 ✅

**Tujuan**: Browser teks tertua dan paling stabil — fokus murni pada teks, ideal untuk akses cepat
informasi, scripting web, dan testing.

**Penggunaan Dasar**:
```bash
pacman -S lynx
lynx https://example.com
lynx --dump https://site.com        # Output ke stdout

# Navigasi:
# ↑↓ → pindah link
# Enter → ikuti link
# ← → kembali
# g → go to URL
# / → search
# q → quit
# = → info halaman
```

**Kata Kunci**: `lynx browser config`, `lynx cookie`, `lynx archlinux`

---

### 6.3 `browsh` ⚡ 🔶

**Tujuan**: **Browser revolusioner** — merender website sesungguhnya (termasuk JavaScript, CSS, gambar)
ke dalam terminal menggunakan Firefox sebagai engine. Tampilan visual lengkap di TTY!

**Penggunaan Dasar**:
```bash
yay -S browsh-bin
# Memerlukan firefox terinstall terlebih dahulu:
pacman -S firefox

browsh https://youtube.com          # Buka YouTube di TTY!
browsh https://google.com

# Navigasi:
# Ctrl+L → address bar
# Ctrl+T → tab baru
# Ctrl+W → tutup tab
# Ctrl+Tab → pindah tab
# F12 → developer tools
```

**Kata Kunci**: `browsh browser TTY`, `browsh firefox terminal`, `browsh visual browser CLI`

**Catatan**: **Game changer** untuk browsing di TTY! Bisa menonton website berbasis video, membaca
konten JavaScript-rendered, dan bahkan melihat gambar. Performa tergantung pada mesin dan terminal
yang digunakan.

---

### 6.4 `carbonyl` 💡 🔶

**Tujuan**: Browser berbasis Chromium yang merender halaman web penuh ke dalam terminal dengan
kualitas visual tinggi menggunakan teknik rendering inovatif.

**Penggunaan Dasar**:
```bash
yay -S carbonyl
carbonyl https://www.google.com
carbonyl --help
```

**Kata Kunci**: `carbonyl browser`, `carbonyl chromium terminal`, `carbonyl vs browsh`

**Catatan**: Alternatif browsh berbasis Chromium. Lebih aktif dikembangkan dan memiliki performa
yang terus meningkat.

---

## ═══════════════════════════════════════
## 7. 📧 EMAIL CLI/TUI
## ═══════════════════════════════════════

### 7.1 `neomutt` ⚡ ✅

**Tujuan**: Email client TUI paling powerful — threading, tagging, multi-account, PGP encryption,
attachment, HTML rendering via w3m, dan konfigurabilitas tak terbatas.

**Penggunaan Dasar**:
```bash
pacman -S neomutt
neomutt            # Jalankan
# ? → help
# m → compose email baru
# r → reply
# c → change folder/mailbox
# s → save email
# d → delete
# / → search
# Enter → buka email
# v → view attachments
```

**Kata Kunci**: `neomutt config archlinux`, `neomutt mbsync`, `neomutt gmail IMAP`,
`neomutt PGP encryption`, `neomutt html email w3m`

**Catatan**: Setup lengkap membutuhkan `isync` (sync IMAP) + `msmtp` (kirim SMTP).
Butuh waktu konfigurasi tapi hasilnya adalah email client paling powerful di planet CLI.

---

### 7.2 `aerc` ⚡ ✅

**Tujuan**: Email client TUI modern yang lebih mudah dikonfigurasi dari neomutt — mendukung IMAP/SMTP
langsung tanpa helper eksternal, rendering HTML, dan keybinding vim-like.

**Penggunaan Dasar**:
```bash
pacman -S aerc
aerc              # Jalankan
# ? → help
# C → compose email baru
# r → reply
# R → reply all
# f → forward
# d → delete
# Enter → buka email
```

**Kata Kunci**: `aerc email setup`, `aerc config`, `aerc gmail IMAP`, `aerc accounts.conf`

**Catatan**: **Rekomendasi utama untuk pemula email CLI.** Setup lebih sederhana, langsung mendukung
OAuth2 untuk Gmail/Outlook.

---

### 7.3 `isync` (mbsync) ⚡ ✅

**Tujuan**: Sinkronisasi email IMAP ke lokal dalam format Maildir — memungkinkan akses offline dan
integrasi dengan email client CLI manapun.

**Penggunaan Dasar**:
```bash
pacman -S isync
mbsync -a                    # Sync semua akun
mbsync gmail                 # Sync akun bernama 'gmail'
mbsync -V gmail              # Verbose (debug)
mbsync --help

# Konfigurasi di ~/.mbsyncrc
# Jalankan berkala via systemd timer atau cron
```

**Kata Kunci**: `mbsync config`, `isync gmail setup`, `mbsync IMAP archlinux`, `mbsync Maildir`

---

### 7.4 `msmtp` ⚡ ✅

**Tujuan**: SMTP client ringan untuk mengirim email dari command line — berfungsi sebagai sendmail
replacement yang kompatibel dengan hampir semua email client CLI.

**Penggunaan Dasar**:
```bash
pacman -S msmtp msmtp-mta
msmtp --help

# Test kirim email:
echo -e "Subject: Test\n\nIsi email" | msmtp recipient@gmail.com

# Konfigurasi di ~/.msmtprc (simpan password dengan gpg)
```

**Kata Kunci**: `msmtp config`, `msmtp gmail SMTP`, `msmtp neomutt integration`, `msmtp oauth2`

---

## ═══════════════════════════════════════
## 8. 💬 CHAT & KOMUNIKASI
## ═══════════════════════════════════════

### 8.1 `weechat` ⚡ ✅

**Tujuan**: IRC client TUI paling extensible — plugin untuk Matrix, Slack, Discord, XMPP, Mastodon,
Telegram dan hampir semua protokol chat via script Python/Lua/Ruby.

**Penggunaan Dasar**:
```bash
pacman -S weechat
weechat

# Perintah dasar:
/server add libera irc.libera.chat
/connect libera
/join #archlinux
/msg username pesan
/part        # Keluar dari channel
/quit        # Disconnect
/help        # Bantuan

# Plugin matrix:
/script install matrix.py
```

**Kata Kunci**: `weechat config`, `weechat plugins`, `weechat matrix`, `weechat scripts python`,
`weechat relay`

---

### 8.2 `irssi` 🔄 ✅

**Tujuan**: IRC client terminal klasik yang ringan dan stabil — pilihan tradisional komunitas IRC
Linux.

**Penggunaan Dasar**:
```bash
pacman -S irssi
irssi
/connect irc.libera.chat
/join #archlinux
/help
```

**Kata Kunci**: `irssi config`, `irssi scripts`, `irssi IRC setup`

---

### 8.3 `profanity` ⚡ ✅

**Tujuan**: XMPP/Jabber client TUI dengan dukungan OMEMO end-to-end encryption, OTR, MUC (group chat),
dan file transfer — untuk komunikasi terenkripsi via Jabber network.

**Penggunaan Dasar**:
```bash
pacman -S profanity
profanity
/connect user@domain.com
/help
/roster          # Daftar kontak
/msg user@domain  # Kirim pesan
```

**Kata Kunci**: `profanity XMPP`, `profanity OMEMO encryption`, `profanity config`

---

### 8.4 `gomuks` ⚡ ✅

**Tujuan**: Matrix chat client TUI — akses ke jaringan Matrix (Element.io, Matrix.org, dll) dengan
dukungan end-to-end encryption langsung dari terminal.

**Penggunaan Dasar**:
```bash
pacman -S gomuks
gomuks
# Login dengan akun Matrix
# Arrow keys + Enter untuk navigasi
# Ctrl+Q → quit
```

**Kata Kunci**: `gomuks Matrix TUI`, `gomuks setup`, `Matrix terminal client`

---

### 8.5 `tut` 🔄 🔶

**Tujuan**: Mastodon / Fediverse client TUI — browse timeline, boost, reply, follow, dan kelola akun
Mastodon dari terminal.

**Penggunaan Dasar**:
```bash
yay -S tut
tut
# ? → help
# j/k → navigasi
# b → boost
# f → favourite
# r → reply
```

**Kata Kunci**: `tut mastodon TUI`, `tut fediverse`, `mastodon terminal client`

---

### 8.6 `himalaya` 🔄 ✅

**Tujuan**: Email client CLI yang minimalis — send, read, reply email dari satu perintah tanpa TUI
penuh.

**Penggunaan Dasar**:
```bash
pacman -S himalaya
himalaya list                        # List email
himalaya read ID                     # Baca email
himalaya reply ID                    # Reply email
himalaya write                       # Tulis email baru
himalaya --help
```

**Kata Kunci**: `himalaya email CLI`, `himalaya config`, `himalaya gmail`

---

## ═══════════════════════════════════════
## 9. 📰 RSS, BERITA & INFORMASI
## ═══════════════════════════════════════

### 9.1 `newsboat` ⚡ ✅

**Tujuan**: RSS/Atom feed reader TUI yang cepat — vim-keybindings, filter dan query, makro otomasi,
dan integrasi browser/player eksternal.

**Penggunaan Dasar**:
```bash
pacman -S newsboat
newsboat                    # Jalankan
newsboat --help

# Dalam newsboat:
# r → refresh feed aktif
# R → refresh semua feed
# Enter → buka feed / baca artikel
# o → buka artikel di browser
# / → search
# n → next search result
# ? → help
# q → quit

# Tambahkan feeds ke ~/.newsboat/urls:
# https://archlinux.org/feeds/news/
# https://feeds.feedburner.com/TechCrunch
# https://hnrss.org/frontpage
```

**Kata Kunci**: `newsboat config`, `newsboat feeds URL`, `newsboat macros`, `newsboat browser config`

**Catatan**: Integrasikan dengan `w3m` atau `browsh` sebagai browser membuka artikel.
Bisa auto-download podcast dengan integrasi `yt-dlp`.

---

### 9.2 `tuifeed` 💡 🔶

**Tujuan**: RSS feed reader TUI berbasis Rust yang modern dan ringan sebagai alternatif newsboat.

**Penggunaan Dasar**:
```bash
yay -S tuifeed
tuifeed
```

**Kata Kunci**: `tuifeed RSS reader`, `tuifeed rust`

---

## ═══════════════════════════════════════
## 10. 🎵 AUDIO & MUSIK
## ═══════════════════════════════════════

### 10.1 `pipewire` + `wireplumber` ⚡ ✅

**Tujuan**: Server audio modern — pengganti PulseAudio dan JACK, menangani audio (dan video) secara
unified. **Fondasi wajib** untuk audio di Arch Linux modern.

**Penggunaan Dasar**:
```bash
pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber
systemctl --user enable --now pipewire pipewire-pulse wireplumber

pactl info                          # Cek status PulseAudio compat layer
pw-top                              # Monitor PipeWire (realtime)
pactl list sinks                    # Daftar output audio
pactl set-sink-volume @DEFAULT_SINK@ 70%  # Set volume
```

**Kata Kunci**: `pipewire archlinux setup`, `pipewire pulseaudio replacement`, `wireplumber config`

---

### 10.2 `alsa-utils` ⚡ 📦

**Tujuan**: Tools ALSA langsung dari kernel — kontrol audio paling mendasar tanpa layer tambahan.
Wajib sebagai fondasi audio.

**Penggunaan Dasar**:
```bash
pacman -S alsa-utils
alsamixer           # TUI mixer interaktif
amixer set Master 80%    # Set master volume (CLI)
amixer set Master toggle # Mute/unmute
aplay file.wav      # Play audio file
arecord file.wav    # Rekam audio
speaker-test -t wav # Test speaker
```

**Kata Kunci**: `alsamixer no sound`, `alsa arch setup`, `amixer volume CLI`

**Catatan**: Tersedia di pacstrap. Wajib install untuk audio dasar.

---

### 10.3 `mpd` + `ncmpcpp` ⚡ ✅

**Tujuan**: Kombinasi musik terbaik — MPD (Music Player Daemon) sebagai backend server musik,
ncmpcpp sebagai TUI client yang powerful dengan library browser, playlist, dan visualizer.

**Penggunaan Dasar**:
```bash
pacman -S mpd ncmpcpp
systemctl --user enable --now mpd

ncmpcpp                   # Jalankan TUI client
# 1 → playlist view
# 2 → library browser
# 3 → search engine
# 4 → media library
# 8 → visualizer (spektrum)
# Space → play/pause
# n → next track
# p → previous track
# + / - → volume
# / → search dalam library
# u → update music database
```

**Konfigurasi MPD** (`~/.config/mpd/mpd.conf`):
```bash
music_directory "~/Music"
db_file "~/.local/share/mpd/database"
log_file "~/.local/share/mpd/log"
pid_file "~/.local/share/mpd/pid"
bind_to_address "localhost"
audio_output {
    type "pipewire"
    name "PipeWire Output"
}
```

**Kata Kunci**: `mpd config archlinux`, `ncmpcpp keybindings`, `mpd systemd user service`,
`ncmpcpp visualizer`, `mpd library setup`

---

### 10.4 `cmus` ⚡ ✅

**Tujuan**: Music player TUI all-in-one tanpa daemon — sederhana, ringan, vi-keybindings, mendukung
hampir semua format audio.

**Penggunaan Dasar**:
```bash
pacman -S cmus
cmus

# Dalam cmus:
# 1-7 → pindah view (library, playlist, browser, dll)
# :add ~/Music → tambah folder musik
# c → pause/play
# n → next
# b → previous
# . → forward
# , → rewind
# v → stop
# q → quit
```

**Kata Kunci**: `cmus config`, `cmus shortcuts`, `cmus library`, `cmus playlist`

---

### 10.5 `pulsemixer` ⚡ ✅

**Tujuan**: Mixer audio TUI untuk PulseAudio/PipeWire — kontrol volume per-aplikasi, pilih input/output
device, dan mute/unmute dari terminal.

**Penggunaan Dasar**:
```bash
pacman -S pulsemixer
pulsemixer              # TUI interaktif
# Arrow keys → navigasi
# Enter → select device
# +/- → volume atas/bawah
# m → mute toggle
# Left/Right → channel balance
# q → quit

# CLI mode:
pulsemixer --get-volume
pulsemixer --set-volume 70
pulsemixer --toggle-mute
```

**Kata Kunci**: `pulsemixer volume control`, `pulsemixer PipeWire`, `pulsemixer TUI`

---

## ═══════════════════════════════════════
## 11. 🎥 VIDEO & STREAMING
## ═══════════════════════════════════════

### 11.1 `mpv` ⚡ ✅

**Tujuan**: Video player paling powerful di Linux — mendukung hampir semua format, hardware decoding,
scripting Lua, dan yang terpenting: **bisa dijalankan langsung di TTY tanpa X11** via DRM/KMS.

**Penggunaan Dasar**:
```bash
pacman -S mpv

# Untuk TTY MURNI (tanpa X11/Wayland) - PENTING:
mpv --vo=drm video.mp4                  # Direct Rendering Manager
mpv --vo=drm --drm-device=/dev/dri/card0 video.mp4

# Penggunaan umum:
mpv video.mp4                           # Putar file lokal
mpv https://youtube.com/watch?v=ID     # Stream YouTube (butuh yt-dlp)
mpv --no-video audio.mp3               # Audio only mode
mpv --loop playlist.m3u                # Loop playlist

# Shortcut dalam mpv:
# Space → pause/play
# ← → → seek ±5 detik
# ↑ ↓ → volume
# f → fullscreen (di DRM TTY tidak relevan)
# j → toggle subtitle cycle
# v → toggle subtitle display
# # → audio track berikutnya
# 9 / 0 → volume down/up
# m → mute
# q → quit
# / * → volume control lain
```

**Kata Kunci**: `mpv TTY DRM`, `mpv --vo=drm`, `mpv config archlinux`, `mpv yt-dlp streaming`,
`mpv hardware decoding vaapi`, `mpv framebuffer`

**Catatan**: Agar user bisa mengakses DRM di TTY: `sudo usermod -aG video $USER`. Logout dan login
kembali. mpv di TTY via DRM membutuhkan GPU yang mendukung KMS/DRM.

---

### 11.2 `yt-dlp` ⚡ ✅

**Tujuan**: Download video/audio dari YouTube, Twitch, Twitter/X, TikTok, Instagram, Bilibili dan
1000+ situs lainnya — fork aktif dari youtube-dl.

**Penggunaan Dasar**:
```bash
pacman -S yt-dlp

yt-dlp "https://youtube.com/watch?v=ID"       # Download video terbaik
yt-dlp -x "URL"                               # Audio only (extract)
yt-dlp -x --audio-format mp3 "URL"           # Extract ke MP3
yt-dlp -f bestvideo+bestaudio "URL"           # Kualitas terbaik manual
yt-dlp --list-formats "URL"                   # Daftar semua format
yt-dlp -f "137+140" "URL"                     # Format spesifik (contoh: 1080p+audio)
yt-dlp -o "%(title)s.%(ext)s" "URL"          # Custom nama output
yt-dlp -o "~/Downloads/%(uploader)s/%(title)s.%(ext)s" "URL"
yt-dlp --add-metadata -x "URL"               # Download audio + metadata
yt-dlp "URL/playlist?list=PLxxx"             # Download playlist
yt-dlp --write-sub --sub-lang en "URL"       # Download dengan subtitle
yt-dlp --cookies-from-browser firefox "URL"  # Gunakan cookies browser
yt-dlp --help | less
```

**Kata Kunci**: `yt-dlp tutorial`, `yt-dlp format selection`, `yt-dlp playlist download`,
`yt-dlp audio only`, `yt-dlp cookies`, `yt-dlp config`

---

### 11.3 `streamlink` ⚡ ✅

**Tujuan**: Pipe stream langsung dari Twitch, YouTube Live, Crunchyroll, dan 50+ situs streaming
langsung ke mpv atau video player lainnya — streaming real-time di TTY!

**Penggunaan Dasar**:
```bash
pacman -S streamlink

streamlink https://twitch.tv/channel best           # Kualitas terbaik
streamlink --player mpv "URL" 1080p                # Ke mpv normal
streamlink --player "mpv --vo=drm" "URL" best      # Ke mpv di TTY murni!
streamlink --list-streams "URL"                     # Daftar kualitas tersedia
streamlink --help
```

**Kata Kunci**: `streamlink mpv TTY`, `streamlink twitch`, `streamlink quality`, `streamlink YouTube`

**Catatan**: Kombinasi `streamlink + mpv --vo=drm` adalah cara **streaming Twitch/YouTube Live di TTY
murni tanpa X11**. Revolusioner untuk setup ini.

---

### 11.4 `ffmpeg` ⚡ ✅

**Tujuan**: Media processing Swiss army knife — konversi, encode, decode, cut, merge, stream, screenshot,
dan hampir semua operasi media yang bisa dibayangkan.

**Penggunaan Dasar**:
```bash
pacman -S ffmpeg

ffmpeg -i input.mp4 output.mkv                    # Konversi format
ffmpeg -i in.mp4 -ss 00:01:30 -t 60 out.mp4     # Potong: mulai 1:30, durasi 60s
ffmpeg -i in.mp4 -vn out.mp3                     # Ekstrak audio saja
ffmpeg -i in.mp4 -an out.mp4                     # Hapus audio
ffmpeg -i in.mp4 -vf scale=1280:720 out.mp4     # Resize video
ffmpeg -i in.mp4 -r 15 -vf scale=480:-1 out.gif # Convert ke GIF
ffmpeg -i in.mkv -c:v libx264 -crf 23 out.mp4   # Re-encode dengan x264
ffmpeg -i in.mp4 out_%03d.jpg                    # Ekstrak semua frame
ffmpeg -framerate 30 -i frame_%03d.jpg video.mp4 # Frame ke video
ffmpeg -i in.mp4 2>&1 | head                     # Info file media
ffmpeg -help
man ffmpeg
```

**Kata Kunci**: `ffmpeg tutorial`, `ffmpeg convert`, `ffmpeg cheatsheet`, `ffmpeg compress video`,
`ffmpeg cut trim`, `ffmpeg audio extract`

---

## ═══════════════════════════════════════
## 12. 🖼️ PENAMPIL GAMBAR — TTY/FRAMEBUFFER
## ═══════════════════════════════════════

> **Catatan TTY**: Di TTY murni tanpa X11, ada dua pendekatan untuk menampilkan gambar:
> 1. **Framebuffer** (`/dev/fb0`) — gambar asli, butuh user di grup `video`
> 2. **Character-based** — gambar dikonversi ke karakter Unicode/ASCII, works tanpa framebuffer

---

### 12.1 `fim` ⚡ ✅

**Tujuan**: **Framebuffer Image Manager** — penampil gambar utama untuk TTY. Menampilkan PNG, JPG,
GIF, BMP, dan format lainnya langsung di konsol menggunakan framebuffer Linux.

**Penggunaan Dasar**:
```bash
pacman -S fim

# Pastikan user ada di grup video:
sudo usermod -aG video $USER  # Logout lagi setelah ini

fim gambar.jpg                 # Tampilkan gambar
fim -R ~/Pictures/             # Slideshow semua gambar di folder
fim *.jpg                      # Multiple gambar (slideshow)

# Dalam fim:
# → / Space → gambar berikutnya
# ← / Backspace → gambar sebelumnya
# + / - → zoom in/out
# a → auto-scale (fit screen)
# = → reset zoom
# w → flip horizontal
# u → flip vertikal
# h → help
# q → quit
```

**Kata Kunci**: `fim framebuffer image viewer`, `fim archlinux TTY`, `fim slideshow`, `/dev/fb0`

**Catatan**: **Pilihan utama untuk image viewing di TTY.** Memerlukan `/dev/fb0` (framebuffer device)
aktif. Verifikasi dengan `ls /dev/fb*`.

---

### 12.2 `fbi` 🔄 ✅

**Tujuan**: Framebuffer Image viewer sederhana — bagian dari paket `fbida`. Alternatif fim yang lebih
basic.

**Penggunaan Dasar**:
```bash
pacman -S fbida
fbi -a gambar.jpg                  # Auto-scale
fbi -T 5 *.jpg                     # Slideshow 5 detik per gambar
fbi -d /dev/fb0 gambar.jpg        # Spesifik framebuffer device
fbi --help
```

**Kata Kunci**: `fbi framebuffer viewer`, `fbida linux`, `fbi slideshow TTY`

---

### 12.3 `chafa` ⚡ ✅

**Tujuan**: Konversi gambar ke karakter Unicode, Braille, atau ASCII yang ditampilkan di terminal —
**works di TTY tanpa framebuffer**, kualitas visual mengejutkan, mendukung animasi GIF.

**Penggunaan Dasar**:
```bash
pacman -S chafa
chafa gambar.jpg                    # Tampilkan (auto-detect kemampuan terminal)
chafa -f symbols gambar.jpg         # Mode karakter Unicode
chafa -f braille gambar.jpg         # Mode braille (densitas tinggi)
chafa -f ascii gambar.jpg           # Mode ASCII murni
chafa --size 80x40 gambar.jpg       # Ukuran custom (kolom x baris)
chafa --size $(stty size | awk '{print $2 "x" $1}') gambar.jpg  # Full terminal
chafa animasi.gif                   # Animasi GIF!
chafa --help
```

**Kata Kunci**: `chafa image terminal`, `chafa braille`, `chafa sixel`, `chafa GIF animation`

**Catatan**: Mendukung sixel graphics untuk terminal yang mendukungnya. Bisa diintegrasikan ke ranger
sebagai previewer gambar.

---

### 12.4 `viu` 🔄 ✅

**Tujuan**: Image viewer terminal berbasis Rust — mendukung truecolor, sixel, half-block characters,
dan Kitty graphics protocol.

**Penggunaan Dasar**:
```bash
pacman -S viu
viu gambar.jpg            # Tampilkan
viu -w 80 gambar.jpg      # Lebar 80 karakter
viu -h 40 gambar.jpg      # Tinggi 40 baris
viu *.jpg                 # Slideshow
viu --help
```

**Kata Kunci**: `viu image viewer`, `viu sixel`, `viu terminal truecolor`

---

## ═══════════════════════════════════════
## 13. 📄 PEMBACA DOKUMEN
## ═══════════════════════════════════════

### 13.1 `poppler-utils` (pdftotext, pdfinfo) ⚡ ✅

**Tujuan**: Ekstrak teks dari PDF untuk dibaca di terminal atau diproses dengan tools lain — solusi
paling universal untuk PDF di TTY.

**Penggunaan Dasar**:
```bash
pacman -S poppler
pdftotext file.pdf -               # Output ke stdout
pdftotext file.pdf | less          # Baca dengan pager
pdftotext -layout file.pdf out.txt # Pertahankan layout halaman
pdftotext -f 1 -l 5 file.pdf -    # Hanya halaman 1-5
pdfinfo file.pdf                   # Metadata dan info PDF
pdfimages file.pdf output_prefix   # Ekstrak gambar dari PDF
pdftoppm file.pdf page -jpeg       # Convert halaman ke gambar
```

**Kata Kunci**: `pdftotext linux`, `poppler tools PDF`, `pdf to text CLI`, `pdfinfo metadata`

---

### 13.2 `fbpdf` 🔄 🔶

**Tujuan**: Pembaca PDF langsung di TTY menggunakan framebuffer — tampilkan PDF dengan layout visual
asli tanpa X11.

**Penggunaan Dasar**:
```bash
yay -S fbpdf
fbpdf file.pdf

# Dalam fbpdf:
# j/k → scroll down/up
# +/- → zoom in/out
# g → go to page
# q → quit
```

**Kata Kunci**: `fbpdf framebuffer PDF`, `fbpdf TTY`, `mupdf framebuffer`

**Catatan**: Alternatif: `mupdf` dengan mode headless: `mutool draw -o page%d.png file.pdf`
lalu tampilkan dengan `fim`.

---

### 13.3 `pandoc` ⚡ ✅

**Tujuan**: Konverter dokumen universal — antara Markdown, HTML, PDF, DOCX, EPUB, LaTeX, RST,
dan 40+ format lainnya. Penulis dokumen universal untuk CLI.

**Penggunaan Dasar**:
```bash
pacman -S pandoc pandoc-cli

pandoc input.md -o output.pdf          # Markdown ke PDF
pandoc input.docx -o output.md         # DOCX ke Markdown (extrak konten)
pandoc input.md -o output.html         # Markdown ke HTML
pandoc input.md --to=plain | less      # Markdown ke teks biasa (baca di terminal)
pandoc input.md -s -o output.epub      # Ebook EPUB
pandoc --list-output-formats           # Daftar semua format output
pandoc --help
```

**Kata Kunci**: `pandoc tutorial`, `pandoc markdown PDF`, `pandoc document conversion`,
`pandoc DOCX Markdown`

---

### 13.4 `glow` ⚡ ✅

**Tujuan**: Render file Markdown dengan styling indah langsung di terminal — ideal untuk membaca
README, dokumentasi, dan notes.

**Penggunaan Dasar**:
```bash
pacman -S glow
glow README.md              # Render file markdown
glow -p README.md           # Dengan pager (less)
glow .                      # Browse markdown files di direktori
curl https://raw.githubusercontent.com/.../README.md | glow - # Dari internet
glow --help
```

**Kata Kunci**: `glow markdown terminal`, `glow renderer`, `glow pager`

---

### 13.5 `sc-im` ⚡ ✅

**Tujuan**: Spreadsheet editor TUI dengan formula lengkap, vi-keybindings, dan import/export
CSV/XLSX — pengganti Excel/LibreOffice Calc di CLI!

**Penggunaan Dasar**:
```bash
pacman -S sc-im
sc-im                    # Buka spreadsheet baru
sc-im file.csv           # Buka file CSV

# Dalam sc-im:
# Arrow keys → navigasi sel
# Enter → masuk mode edit
# = → masuk formula (=SUM(A1:A10))
# :w filename → save ke file
# :wq → save dan quit
# :q! → quit tanpa save
# :e file.csv → buka file
# v → visual select range
```

**Kata Kunci**: `sc-im spreadsheet`, `sc-im formulas`, `sc-im CSV`, `sc-im tutorial`

---

### 13.6 `catdoc` 🔄 ✅

**Tujuan**: Ekstrak teks dari file DOC (Word lama) untuk dibaca di terminal.

**Penggunaan Dasar**:
```bash
pacman -S catdoc
catdoc file.doc | less
catdoc --help
```

**Kata Kunci**: `catdoc DOC linux`, `word to text CLI`

---

## ═══════════════════════════════════════
## 14. ⬇️ DOWNLOAD MANAGER
## ═══════════════════════════════════════

### 14.1 `aria2` ⚡ ✅

**Tujuan**: Download manager multi-protokol (HTTP, HTTPS, FTP, BitTorrent, Metalink) dengan
multi-connection per file — download manager terbaik dan tercepat untuk CLI.

**Penggunaan Dasar**:
```bash
pacman -S aria2

aria2c "https://file.com/file.zip"               # Download basic
aria2c -x 16 "URL"                               # 16 koneksi paralel
aria2c -s 16 "URL"                               # 16 segment per file
aria2c -x 16 -s 16 "URL"                         # Maksimal kecepatan
aria2c -c "URL"                                  # Resume download
aria2c -d ~/Downloads/ "URL"                     # Direktori tujuan
aria2c -i downloads.txt                          # Download dari file list (satu URL per baris)
aria2c --bittorrent-file file.torrent            # Download via torrent
aria2c "magnet:?xt=urn:btih:HASH"               # Magnet link
aria2c --enable-rpc --rpc-listen-all            # Mode RPC (untuk WebUI/remote control)
aria2c --help | less
```

**Kata Kunci**: `aria2c tutorial`, `aria2 multi-connection`, `aria2 bittorrent`,
`aria2 resume`, `aria2 RPC interface`

---

### 14.2 `axel` ✅

**Tujuan**: Accelerated Downloader — menggunakan beberapa koneksi simultan untuk satu file HTTP/FTP,
mempercepat download secara signifikan.

**Penggunaan Dasar**:
```bash
pacman -S axel
axel -n 10 "URL"           # 10 koneksi simultan
axel -v "URL"              # Verbose progress
axel -o output.file "URL"  # Nama output custom
axel --help
```

**Kata Kunci**: `axel accelerated download`, `axel multiple connections`, `axel vs wget`

---

### 14.3 `rclone` (untuk cloud download) ⚡ ✅

**Tujuan**: Download/upload dari 40+ cloud storage provider — Google Drive, Dropbox, S3, OneDrive,
Backblaze, dan banyak lagi.

*(Lihat juga bagian Backup & Cloud Sync)*

---

## ═══════════════════════════════════════
## 15. 🔀 VERSION CONTROL & DEVELOPMENT
## ═══════════════════════════════════════

### 15.1 `git` ⚡ 📦

**Tujuan**: Version control system — mutlak wajib untuk development, manajemen dotfiles, dan hampir
semua alur kerja programmer.

**Penggunaan Dasar**:
```bash
pacman -S git

git init                              # Init repo baru
git clone URL                         # Clone repo
git status                            # Status working directory
git add -A                            # Stage semua perubahan
git add file.txt                      # Stage file spesifik
git commit -m "pesan commit"         # Commit
git push origin main                  # Push ke remote
git pull                             # Pull dari remote
git log --oneline --graph --all      # Visual commit graph
git diff HEAD~1                      # Diff vs commit sebelumnya
git branch                           # Daftar branch
git checkout -b feature-baru         # Buat dan pindah ke branch baru
git stash                            # Simpan perubahan sementara
git stash pop                        # Kembalikan stash
git rebase -i HEAD~3                 # Interactive rebase 3 commit terakhir
git --help
man git
```

**Kata Kunci**: `git cheatsheet`, `git workflow`, `git rebase interactive`, `git config aliases`,
`git log graph`

**Catatan**: Tersedia di pacstrap.

---

### 15.2 `lazygit` ⚡ ✅

**Tujuan**: TUI untuk git yang sangat intuitif — stage, unstage, commit, push, rebase, branch
management, semua dengan interface yang visual tanpa menghafal perintah git kompleks.

**Penggunaan Dasar**:
```bash
pacman -S lazygit
lazygit              # Jalankan di dalam direktori git repo

# Dalam lazygit:
# ? → help penuh
# 1-5 → navigasi panel (Status, Files, Branches, Commits, Stash)
# Space → stage/unstage file
# c → commit
# P → push
# p → pull
# b → branch operations
# z → undo
# R → refresh
# q → quit
```

**Kata Kunci**: `lazygit tutorial`, `lazygit shortcuts`, `lazygit config`

---

### 15.3 `tig` 🔄 ✅

**Tujuan**: TUI browser untuk git repository — visualisasi commit graph, diff viewer, blame, dan
navigasi history dengan vi-keybindings.

**Penggunaan Dasar**:
```bash
pacman -S tig
tig                    # Main log view
tig blame file.txt     # Blame view
tig log                # Log semua branch
tig status             # Status view
tig show HEAD          # Show commit terbaru
```

**Kata Kunci**: `tig git browser`, `tig config`, `tig blame`

---

### 15.4 `gitui` 💡 ✅

**Tujuan**: TUI untuk git berbasis Rust — alternatif lazygit yang lebih cepat.

**Penggunaan Dasar**:
```bash
pacman -S gitui
gitui
# ? → help
```

**Kata Kunci**: `gitui rust`, `gitui vs lazygit`

---

### 15.5 Development Tools Esensial ⚡ 📦

**Tujuan**: Toolchain development komprehensif.

```bash
pacman -S base-devel gcc clang python python-pip nodejs npm rustup make cmake gdb strace ltrace valgrind universal-ctags
```

| Tool | Fungsi | Paket |
|------|--------|-------|
| `gcc` / `clang` | C/C++ compiler | `gcc`, `clang` |
| `python` + `pip` | Python + package manager | `python`, `python-pip` |
| `node` + `npm` | JavaScript runtime | `nodejs`, `npm` |
| `rustup` + `cargo` | Rust toolchain manager | `rustup` |
| `gdb` | GNU Debugger — debug interaktif | `gdb` |
| `strace` | Trace system calls — debugging OS | `strace` |
| `ltrace` | Trace library calls | `ltrace` |
| `valgrind` | Memory error detector | `valgrind` |
| `make` / `cmake` | Build systems | `make`, `cmake` |
| `ctags` | Code indexing untuk editor | `universal-ctags` |

**Kata Kunci**: `gdb debugging tutorial`, `strace tutorial`, `cmake tutorial`, `rustup setup`

---

## ═══════════════════════════════════════
## 16. 🗄️ DATABASE CLI
## ═══════════════════════════════════════

### 16.1 `sqlite3` ⚡ ✅

**Tujuan**: SQLite database engine CLI — database berbasis file yang ringan, ideal untuk development
dan aplikasi yang tidak butuh server.

**Penggunaan Dasar**:
```bash
pacman -S sqlite
sqlite3 database.db              # Buka/buat database

# Dalam sqlite3:
.tables                          # List semua tabel
.schema nama_tabel               # Tampilkan schema
.mode column                     # Format output kolom
.headers on                      # Tampilkan header kolom
SELECT * FROM users LIMIT 10;   # Query SQL
INSERT INTO t VALUES (...);
.export data.csv tabel           # Export ke CSV
.read script.sql                 # Jalankan file SQL
.quit
```

**Kata Kunci**: `sqlite3 tutorial`, `sqlite3 commands`, `sqlite CLI`

---

### 16.2 `pgcli` ✅

**Tujuan**: Client PostgreSQL interaktif dengan auto-completion cerdas, syntax highlighting, dan
output yang rapi — jauh lebih baik dari `psql` bawaan.

**Penggunaan Dasar**:
```bash
pacman -S pgcli
pgcli -h hostname -u username dbname
pgcli --help
# Dalam pgcli:
# \? → help
# \dt → daftar tabel
# \d nama_tabel → schema tabel
# Ctrl+R → search history
```

**Kata Kunci**: `pgcli PostgreSQL`, `pgcli auto-complete`, `pgcli vs psql`

---

### 16.3 `mycli` / `litecli` 🔄 ✅

**Tujuan**: Client MySQL dan SQLite dengan auto-completion dan syntax highlighting.

**Penggunaan Dasar**:
```bash
pacman -S mycli
mycli -h host -u user -p dbname      # MySQL

pacman -S litecli
litecli database.db                  # SQLite dengan fitur lebih dari sqlite3
```

**Kata Kunci**: `mycli MySQL CLI`, `litecli sqlite`, `mycli auto-complete`

---

## ═══════════════════════════════════════
## 17. 📦 PACKAGE MANAGER & AUR HELPER
## ═══════════════════════════════════════

### 17.1 `pacman` ⚡ 📦

**Tujuan**: Package manager utama Arch Linux — fondasi manajemen software.

**Penggunaan Dasar**:
```bash
pacman -Syu                   # Update seluruh sistem
pacman -S paket               # Install paket
pacman -R paket               # Remove paket
pacman -Rs paket              # Remove + hapus dependencies orphan
pacman -Rns paket             # Remove + deps + config files
pacman -Ss kata-kunci         # Cari paket (official repos)
pacman -Si paket              # Info detail paket
pacman -Q                     # List semua paket terinstall
pacman -Qi paket              # Info paket terinstall
pacman -Qdt                   # Orphan packages (tidak dibutuhkan)
pacman -Sc                    # Bersihkan cache paket lama
pacman -U file.pkg.tar.zst    # Install dari file lokal
```

**Kata Kunci**: `pacman cheatsheet`, `pacman commands`, `pacman config mirrorlist`,
`pacman -Qdt orphans`

---

### 17.2 `yay` ⚡ 🔶

**Tujuan**: AUR helper paling populer — install paket AUR dengan sintaks identik pacman, written in Go.

**Instalasi**:
```bash
pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si

yay -S paket-aur              # Install dari AUR
yay -Syu                      # Update termasuk AUR packages
yay -Ss kata-kunci            # Cari di AUR + official
yay -Si paket                 # Info paket AUR
yay --help
```

**Kata Kunci**: `yay AUR helper`, `yay install`, `yay vs paru`, `makepkg tutorial`

---

### 17.3 `paru` ⚡ 🔶

**Tujuan**: AUR helper berbasis Rust yang lebih aman — selalu tampilkan PKGBUILD untuk review,
penanganan dependency yang lebih cerdas.

**Penggunaan Dasar**:
```bash
yay -S paru                   # Install via yay dulu
paru -S paket                 # Install
paru -Syu                     # Update semua
paru --fm nvim                # Gunakan neovim untuk review PKGBUILD
paru --help
```

**Kata Kunci**: `paru AUR helper`, `paru vs yay`, `paru PKGBUILD review`

---

## ═══════════════════════════════════════
## 18. 🔐 PASSWORD & KEAMANAN
## ═══════════════════════════════════════

### 18.1 `pass` ⚡ ✅

**Tujuan**: Unix standard password manager — enkripsi GPG, integrasi git untuk sync antar perangkat,
folder-based organization, dan kompatibel dengan ratusan client.

**Penggunaan Dasar**:
```bash
pacman -S pass

# Setup awal (butuh GPG key):
pass init "ID-GPG-KEY-KAMU"
pass git init

# Penggunaan:
pass insert email/gmail              # Tambah password (interaktif)
pass insert -m social/twitter        # Multiline (username, URL, dll)
pass email/gmail                     # Tampilkan password
pass -c email/gmail                  # Copy ke clipboard (via xclip atau tmux)
pass generate social/twitter 20      # Generate password 20 karakter
pass ls                             # List semua entries
pass find keyword                   # Cari entry
pass rm email/old-account           # Hapus entry
pass git push                       # Sync ke remote git
```

**Kata Kunci**: `pass password manager`, `pass gpg setup`, `pass git sync`, `pass archlinux`

---

### 18.2 `gnupg` (gpg) ⚡ 📦

**Tujuan**: OpenPGP encryption dan digital signing — enkripsi file, signing email, key management.
Fondasi keamanan CLI.

**Penggunaan Dasar**:
```bash
pacman -S gnupg

gpg --gen-key                              # Generate key pair
gpg --list-keys                           # Daftar semua key
gpg --list-secret-keys                    # Hanya private keys
gpg -e -r "Nama/Email" file.txt           # Enkripsi file
gpg -d file.txt.gpg                       # Dekripsi file
gpg --sign file.txt                       # Sign file
gpg --verify file.txt.gpg                 # Verifikasi signature
gpg --export -a "email" > pubkey.asc      # Export public key
gpg --import pubkey.asc                   # Import public key orang lain
gpg --fingerprint email                   # Lihat fingerprint key
```

**Kata Kunci**: `gpg tutorial`, `gpg key generate`, `gpg encrypt file`, `gpg signing`,
`gpg key management`

**Catatan**: Tersedia di pacstrap. Diperlukan oleh `pass`, AUR (verifikasi signature), dan banyak
tools keamanan lainnya.

---

### 18.3 `nftables` / `ufw` ⚡ ✅

**Tujuan**: Firewall — filter dan kontrol traffic jaringan masuk/keluar. `nftables` lebih modern
dan powerful, `ufw` lebih mudah digunakan.

**Penggunaan Dasar**:
```bash
# UFW (Uncomplicated Firewall) - lebih mudah:
pacman -S ufw
systemctl enable --now ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp             # Allow SSH
ufw allow 80/tcp             # Allow HTTP
ufw deny 3306/tcp            # Block MySQL dari luar
ufw enable
ufw status verbose

# nftables (lebih powerful):
pacman -S nftables
systemctl enable --now nftables
nft list ruleset             # Tampilkan semua rules
```

**Kata Kunci**: `ufw archlinux setup`, `nftables tutorial`, `iptables vs nftables`, `ufw rules`

---

### 18.4 `bitwarden-cli` 🔄 ✅

**Tujuan**: CLI client untuk Bitwarden cloud password manager — akses, copy, dan generate password
dari vault Bitwarden via terminal.

**Penggunaan Dasar**:
```bash
pacman -S bitwarden-cli
bw login user@email.com                    # Login
bw unlock                                  # Unlock vault
bw list items | jq '.[] | {name: .name}'  # List semua items
bw get password "Gmail"                    # Ambil password spesifik
bw generate -l 20                          # Generate password
bw --help
```

**Kata Kunci**: `bitwarden CLI bw`, `bitwarden terminal`, `bw commands`

---

### 18.5 `lynis` ⚡ ✅

**Tujuan**: Security auditing tool — scan kerentanan, konfigurasi tidak aman, dan berikan rekomendasi
hardening sistem Linux.

**Penggunaan Dasar**:
```bash
pacman -S lynis
lynis audit system                 # Audit penuh (butuh root)
lynis audit system --quick         # Audit cepat
lynis show commands                # Daftar perintah tersedia
lynis --help
```

**Kata Kunci**: `lynis audit system`, `lynis hardening`, `lynis archlinux`

---

## ═══════════════════════════════════════
## 19. 📅 KALENDER & MANAJEMEN TUGAS
## ═══════════════════════════════════════

### 19.1 `taskwarrior` ⚡ ✅

**Tujuan**: Task manager CLI yang sangat powerful — prioritas, tags, proyek, due date, recurrence,
time tracking, filter canggih, dan sync ke server.

**Penggunaan Dasar**:
```bash
pacman -S task
task add "Beli kopi" +belanja due:tomorrow priority:H
task add "Review PR" project:kerja due:2025-01-20
task list                           # Tampilkan semua tugas
task project:kerja list             # Filter by project
task +belanja list                  # Filter by tag
task 1 done                        # Selesaikan tugas ID 1
task 1 modify priority:M           # Ubah prioritas
task 1 delete                      # Hapus tugas
task calendar                      # Tampilkan kalender tugas
task summary                       # Ringkasan per proyek
task sync                          # Sync ke taskd server
task --help
```

**Kata Kunci**: `taskwarrior tutorial`, `task warrior commands`, `taskwarrior filters`,
`taskwarrior sync`

---

### 19.2 `calcurse` ⚡ ✅

**Tujuan**: Kalender dan todo manager TUI dengan tampilan hari/minggu/bulan — sinkronisasi CalDAV
dan iCal support.

**Penggunaan Dasar**:
```bash
pacman -S calcurse
calcurse                    # Jalankan

# Dalam calcurse:
# ? → help
# a → tambah appointment/event
# t → tambah todo item
# d → hapus item
# e → edit item
# Arrow keys → navigasi tanggal
# Tab → switch panel
# q → quit
```

**Kata Kunci**: `calcurse calendar TUI`, `calcurse config`, `calcurse caldav sync`

---

### 19.3 `khal` + `vdirsyncer` 🔄 ✅

**Tujuan**: Kalender CLI yang sync dengan server CalDAV (Google Calendar, Nextcloud, Fastmail, dll)
— solusi terbaik untuk kalender yang terhubung cloud.

**Penggunaan Dasar**:
```bash
pacman -S khal vdirsyncer
vdirsyncer discover                  # Temukan kalender tersedia
vdirsyncer sync                      # Sync semua kalender
khal list                            # Lihat event mendatang
khal list 2025-01-01 2025-01-31     # Event dalam range tanggal
khal edit                            # Edit events interaktif
khal interactive                     # TUI interaktif
khal new "2025-01-20 14:00" "Meeting dengan klien"  # Buat event
```

**Kata Kunci**: `khal calendar CLI`, `vdirsyncer caldav setup`, `khal google calendar sync`

---

### 19.4 `timewarrior` 🔄 ✅

**Tujuan**: Time tracking CLI — catat waktu yang dihabiskan per tugas/proyek, integrasi dengan
taskwarrior.

**Penggunaan Dasar**:
```bash
pacman -S timew
timew start "coding project X"       # Mulai track
timew stop                          # Stop tracking
timew summary                       # Ringkasan hari ini
timew report month                  # Report bulanan
timew --help
```

**Kata Kunci**: `timewarrior CLI`, `timew taskwarrior integration`, `time tracking terminal`

---

## ═══════════════════════════════════════
## 20. 🌊 TORRENT
## ═══════════════════════════════════════

### 20.1 `rtorrent` ⚡ ✅

**Tujuan**: BitTorrent client TUI yang paling powerful dan dapat dikustomisasi — mendukung magnet links,
RSS torrent feeds, auto-download, dan scripting melalui XML-RPC.

**Penggunaan Dasar**:
```bash
pacman -S rtorrent
rtorrent                           # Jalankan
rtorrent file.torrent              # Buka torrent file langsung

# Dalam rtorrent:
# Enter → detail torrent
# Ctrl+Q → quit
# +/- → throttle upload/download
# Space → pause/resume
# d → hapus torrent
# Backspace → tambah torrent dari URL/file
```

**Kata Kunci**: `rtorrent config`, `rtorrent archlinux`, `rtorrent magnet link`, `rtorrent XML-RPC`

---

### 20.2 `transmission-cli` ✅

**Tujuan**: BitTorrent client dengan antarmuka CLI yang clean — daemon mode untuk headless operation,
remote control via `transmission-remote`.

**Penggunaan Dasar**:
```bash
pacman -S transmission-cli
transmission-daemon                             # Start daemon di background
transmission-remote -a file.torrent            # Add torrent file
transmission-remote -a "magnet:?xt=..."        # Add magnet link
transmission-remote -l                         # List semua torrent
transmission-remote -t 1 -s                    # Start torrent ID 1
transmission-remote -t 1 -p                    # Pause torrent ID 1
transmission-remote -t 1 -r                    # Remove torrent ID 1
transmission-remote -t 1 -i                    # Info detail torrent 1
transmission-remote --help
```

**Kata Kunci**: `transmission CLI daemon`, `transmission-remote commands`, `transmission headless`

---

## ═══════════════════════════════════════
## 21. 🗜️ KOMPRESI & ARSIP
## ═══════════════════════════════════════

### 21.1 `ouch` ⚡ ✅

**Tujuan**: Tool kompresi/dekompresi universal — mengenali format secara otomatis dari ekstensi file,
tidak perlu hafal flags tar yang membingungkan!

**Penggunaan Dasar**:
```bash
pacman -S ouch
ouch compress file1.txt file2.txt archive.tar.gz    # Kompres ke .tar.gz
ouch compress folder/ archive.tar.xz                # Folder ke .tar.xz
ouch compress *.txt bundle.zip                      # Multiple ke ZIP
ouch decompress archive.zip                         # Ekstrak ZIP
ouch decompress archive.tar.gz                      # Ekstrak tar.gz
ouch decompress archive.rar                         # Ekstrak RAR
ouch list archive.tar.bz2                           # Daftar isi
ouch --help
```

**Kata Kunci**: `ouch archiver universal`, `ouch compress decompress`, `ouch all formats`

---

### 21.2 `tar` + compression tools ⚡ 📦

**Tujuan**: Tools kompresi standar Unix — tar, gzip, bzip2, xz, zstd. Wajib ada di setiap sistem.

**Penggunaan Dasar**:
```bash
# Kompres:
tar -czf archive.tar.gz   folder/          # gzip (cepat, ratio sedang)
tar -cjf archive.tar.bz2  folder/          # bzip2 (lambat, ratio baik)
tar -cJf archive.tar.xz   folder/          # xz (paling lambat, ratio terbaik)
tar -I zstd -cf archive.tar.zst folder/   # zstd (modern, cepat + ratio baik)

# Ekstrak:
tar -xzf archive.tar.gz                    # Ekstrak gzip
tar -xf archive.tar.xz                    # Ekstrak (auto-detect)
tar -xf archive.tar.gz -C /tujuan/        # Ekstrak ke direktori spesifik

# Lihat isi tanpa ekstrak:
tar -tvf archive.tar.gz | less
tar --help
```

**Kata Kunci**: `tar command linux`, `tar extract archive`, `zstd compression`, `tar flags`

**Catatan**: Tersedia di pacstrap.

---

### 21.3 `atool` 🔄 ✅

**Tujuan**: Wrapper unified untuk semua tool kompresi — satu perintah untuk ekstrak/kompres/list
semua format arsip.

**Penggunaan Dasar**:
```bash
pacman -S atool
atool -x archive.zip         # Ekstrak (semua format)
atool -a output.tar.gz dir/  # Kompres ke format
atool -l archive.rar          # Lihat isi arsip
atool --help
```

**Kata Kunci**: `atool archive manager`, `atool linux universal`

---

## ═══════════════════════════════════════
## 22. 🔍 PENCARIAN & FUZZY FINDER
## ═══════════════════════════════════════

### 22.1 `fzf` ⚡ ✅

**Tujuan**: Fuzzy finder interaktif universal — dapat diintegrasikan ke shell (Ctrl+R untuk history,
Ctrl+T untuk file), vim, dan hampir semua workflow CLI untuk pemilihan interaktif yang cepat.

**Penggunaan Dasar**:
```bash
pacman -S fzf

# Standalone:
fzf                                      # Filter stdin interaktif
cat /etc/passwd | fzf                    # Filter output command
ls | fzf                                 # Pilih file dari list

# Integrasi shell — tambahkan ke ~/.zshrc atau ~/.bashrc:
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
# Setelah ini:
# Ctrl+R → fuzzy search command history
# Ctrl+T → fuzzy file finder
# Alt+C → fuzzy cd ke subdirektori

# Contoh penggunaan kreatif:
vim $(fzf)                               # Buka file pilihan di vim
git checkout $(git branch | fzf)         # Pindah branch dengan fuzzy
kill $(ps aux | fzf | awk '{print $2}') # Kill proses dengan fuzzy
```

**Preview dengan bat**:
```bash
fzf --preview 'bat --color=always --style=numbers {}'
```

**Kata Kunci**: `fzf tutorial`, `fzf shell integration zsh`, `fzf key bindings`,
`fzf preview`, `fzf vim integration`

---

### 22.2 `ripgrep` (rg) ⚡ ✅

**Tujuan**: Pencarian teks berbasis Rust yang **sangat cepat** — pengganti grep yang lebih cepat,
respectful gitignore, dan output berwarna.

**Penggunaan Dasar**:
```bash
pacman -S ripgrep

rg "kata-kunci"                     # Cari di direktori saat ini
rg "pattern" /path/to/dir          # Cari di path spesifik
rg -i "case insensitive"            # Ignore case
rg -l "text"                        # Hanya tampilkan nama file
rg -c "pattern"                     # Hitung occurrences per file
rg --type py "def function"         # Filter per tipe file (Python)
rg --type js --type ts "import"     # Multiple tipe file
rg -A 5 -B 2 "pattern"             # Context: 5 baris setelah, 2 sebelum
rg -n "text"                        # Tampilkan nomor baris
rg "TODO" --glob "*.rs"             # Glob pattern
rg --help | less
```

**Kata Kunci**: `ripgrep tutorial`, `rg flags options`, `ripgrep vs grep`, `rg type filter`

---

### 22.3 `fd` ⚡ ✅

**Tujuan**: Pengganti `find` berbasis Rust — lebih cepat, sintaks lebih intuitif, default ignore
hidden files dan gitignore patterns.

**Penggunaan Dasar**:
```bash
pacman -S fd

fd "pattern"                        # Cari file dengan nama matching
fd -e py                            # Cari file dengan ekstensi .py
fd -t f                             # File saja (bukan direktori)
fd -t d                             # Direktori saja
fd -H "hidden"                      # Termasuk hidden files
fd "*.log" -x rm {}                  # Jalankan command untuk setiap hasil
fd "*.jpg" -x convert {} {.}.png    # Batch convert dengan ImageMagick
fd --help
```

**Kata Kunci**: `fd find replacement`, `fd command linux`, `fd exec`, `fd file type`

---

### 22.4 `plocate` ✅

**Tujuan**: Cari file berdasarkan nama secara instan menggunakan database yang diindex — jauh lebih
cepat dari `find` untuk pencarian nama file.

**Penggunaan Dasar**:
```bash
pacman -S plocate
updatedb                            # Update database (perlu root, jalankan berkala via cron)
locate filename                     # Cari file berdasarkan nama
locate -i "pattern"                 # Case insensitive
locate "*.conf"                     # Pattern matching
locate -c "*.log"                   # Count hasil
```

**Kata Kunci**: `plocate locate linux`, `updatedb cron`, `locate vs find`

---

## ═══════════════════════════════════════
## 23. 💾 BACKUP & CLOUD SYNC
## ═══════════════════════════════════════

### 23.1 `rsync` ⚡ 📦

**Tujuan**: Sinkronisasi dan backup file/direktori lokal atau remote via SSH — hanya transfer delta
(perubahan), sangat efisien dan reliable.

**Penggunaan Dasar**:
```bash
pacman -S rsync

rsync -avz source/ destination/                     # Sync lokal (verbose)
rsync -avz -e ssh source/ user@host:/dest/          # Sync ke remote via SSH
rsync -avz --delete source/ dest/                   # Mirror (hapus yang tidak ada di source)
rsync -avz --exclude '*.log' source/ dest/          # Exclude pattern
rsync -avz --exclude-from='.rsyncignore' src/ dst/  # Exclude dari file
rsync -avz --progress source/ dest/                 # Tampilkan progress per file
rsync -n -avz source/ dest/                         # Dry run (test tanpa execute)
rsync --help
man rsync
```

**Kata Kunci**: `rsync tutorial`, `rsync backup`, `rsync --delete mirror`, `rsync SSH`,
`rsync exclude`, `rsync cron automation`

**Catatan**: Tersedia di pacstrap. Jadikan `rsync` ke direktori eksternal via cron untuk backup otomatis.

---

### 23.2 `restic` ⚡ ✅

**Tujuan**: Backup modern terenkripsi — deduplication, snapshot-based, mendukung berbagai backend
(lokal, SFTP, S3, Backblaze B2, Azure, Google Cloud).

**Penggunaan Dasar**:
```bash
pacman -S restic
export RESTIC_PASSWORD="password-kuat"

restic -r /backup/repo init                    # Init repository baru
restic -r /backup/repo backup ~/               # Backup home directory
restic -r /backup/repo backup ~/Documents /etc # Backup multiple path
restic -r /backup/repo snapshots               # Lihat semua snapshots
restic -r /backup/repo restore latest --target ~/restore/  # Restore snapshot terbaru
restic -r /backup/repo check                   # Verifikasi integritas
restic -r sftp:user@host:/backup init          # Init di SFTP remote
restic -r s3:s3.amazonaws.com/bucket init      # Init di S3

# Hapus snapshot lama (retention policy):
restic -r /repo forget --keep-daily 7 --keep-weekly 4 --prune
```

**Kata Kunci**: `restic backup tutorial`, `restic encryption`, `restic S3 backend`,
`restic snapshot restore`, `restic prune retention`

---

### 23.3 `rclone` ⚡ ✅

**Tujuan**: "rsync untuk cloud storage" — sync, copy, move, mount, dan manage file di 40+ cloud
storage provider dari CLI.

**Penggunaan Dasar**:
```bash
pacman -S rclone
rclone config                                  # Setup interaktif (tambah remote)

rclone ls gdrive:                              # List Google Drive root
rclone ls gdrive:folder/                       # List folder
rclone copy ~/file gdrive:backup/              # Upload file
rclone copy gdrive:file.txt ~/Downloads/       # Download file
rclone sync ~/folder gdrive:folder/            # Sync (mirror)
rclone sync gdrive: ~/local-backup/            # Download semua
rclone mount gdrive: ~/gdrive/ &               # Mount sebagai filesystem (FUSE)
rclone ls dropbox:
rclone copy s3:bucket/file ~/
rclone --help
```

**Kata Kunci**: `rclone google drive setup`, `rclone sync`, `rclone mount FUSE`,
`rclone config`, `rclone S3 Dropbox`

---

### 23.4 `borgbackup` 🔄 ✅

**Tujuan**: Backup dengan deduplication block-level — sangat hemat storage, terenkripsi, compressed,
dan mendukung backup inkremental yang efisien.

**Penggunaan Dasar**:
```bash
pacman -S borg
borg init --encryption=repokey /backup/repo        # Init repository
borg create /backup/repo::snapshot-{now} ~/         # Buat snapshot
borg create /backup/repo::$(date +%Y%m%d) ~/docs   # Dengan tanggal di nama
borg list /backup/repo                              # Daftar semua snapshot
borg extract /backup/repo::snapshot-name            # Restore snapshot
borg info /backup/repo                              # Info repository
borg prune -v --list /backup/repo \
  --keep-daily=7 --keep-weekly=4 --keep-monthly=6  # Retention policy
```

**Kata Kunci**: `borgbackup tutorial`, `borg deduplication`, `borg vs restic`, `borg prune`

---

## ═══════════════════════════════════════
## 24. 🔵 BLUETOOTH
## ═══════════════════════════════════════

### 24.1 `bluetoothctl` ⚡ ✅

**Tujuan**: Manajemen Bluetooth dari command line — pair, connect, scan, dan manage perangkat
Bluetooth dari TTY.

**Penggunaan Dasar**:
```bash
pacman -S bluez bluez-utils
systemctl enable --now bluetooth

bluetoothctl                           # Mode interaktif
# Dalam bluetoothctl:
[bluetooth]# power on                  # Aktifkan Bluetooth
[bluetooth]# agent on                  # Enable agent (untuk pairing)
[bluetooth]# default-agent             # Set sebagai default
[bluetooth]# scan on                   # Mulai scan perangkat
[bluetooth]# scan off                  # Stop scan
[bluetooth]# devices                   # Daftar perangkat ditemukan
[bluetooth]# pair XX:XX:XX:XX:XX:XX    # Pair perangkat
[bluetooth]# connect XX:XX:XX:XX:XX:XX # Connect
[bluetooth]# trust XX:XX:XX:XX:XX:XX   # Trust (auto-connect)
[bluetooth]# info XX:XX:XX:XX:XX:XX    # Info perangkat
[bluetooth]# paired-devices            # Daftar paired devices
[bluetooth]# exit
```

**Kata Kunci**: `bluetoothctl tutorial`, `bluetooth archlinux setup`, `bluetoothctl pair connect`

---

### 24.2 `bluetui` 🔄 🔶

**Tujuan**: TUI yang lebih visual dan mudah digunakan untuk manajemen Bluetooth dibanding
`bluetoothctl` interaktif.

**Penggunaan Dasar**:
```bash
yay -S bluetui
bluetui
# Space → connect/disconnect
# p → pair
# r → remove device
# s → scan
# q → quit
```

**Kata Kunci**: `bluetui TUI`, `bluetooth TUI archlinux`

---

## ═══════════════════════════════════════
## 25. ⚡ POWER MANAGEMENT
## ═══════════════════════════════════════

### 25.1 `tlp` ⚡ ✅

**Tujuan**: Power management otomatis untuk laptop — optimasi penggunaan daya, battery charge
threshold, dan CPU frequency scaling. Extend battery life secara signifikan.

**Penggunaan Dasar**:
```bash
pacman -S tlp tlp-rdw
systemctl enable --now tlp

tlp-stat                             # Status dan info lengkap
tlp-stat -b                          # Status baterai
tlp-stat -d                          # Status disk
tlp-stat -p                          # Status processor
tlp start                            # Apply settings sekarang (manual)
tlp ac                               # Force AC mode
tlp bat                              # Force battery mode
tlp-stat -s                          # Status service
```

**Konfigurasi** (`/etc/tlp.conf`):
```bash
# Battery charge threshold (ThinkPad & beberapa laptop):
START_CHARGE_THRESH_BAT0=40
STOP_CHARGE_THRESH_BAT0=80
```

**Kata Kunci**: `tlp archlinux laptop`, `tlp battery threshold`, `tlp config`, `tlp-stat`

---

### 25.2 `powertop` 🔄 ✅

**Tujuan**: Analisa konsumsi daya per proses dan hardware — identifikasi apa yang paling boros daya
dan beri auto-tune otomatis.

**Penggunaan Dasar**:
```bash
pacman -S powertop
powertop                            # TUI interaktif (butuh root)
powertop --auto-tune                # Auto-optimasi (sementara, hilang setelah reboot)
powertop --html=report.html         # Generate laporan HTML

# Untuk auto-tune permanen via systemd:
# Buat /etc/systemd/system/powertop.service
```

**Kata Kunci**: `powertop archlinux`, `powertop auto-tune`, `powertop battery laptop`

---

### 25.3 `brightnessctl` ✅

**Tujuan**: Kontrol kecerahan layar dari TTY — bekerja dengan backlight hardware tanpa X11.

**Penggunaan Dasar**:
```bash
pacman -S brightnessctl
brightnessctl get                    # Kecerahan saat ini
brightnessctl max                    # Nilai maksimum
brightnessctl set 50%                # Set ke 50%
brightnessctl set +10%               # Naikkan 10%
brightnessctl set 10%-               # Turunkan 10%
brightnessctl --help
```

**Kata Kunci**: `brightnessctl TTY`, `backlight control linux`, `brightnessctl archlinux`

---

## ═══════════════════════════════════════
## 26. 🖥️ UTILITAS TTY & KONSOL
## ═══════════════════════════════════════

### 26.1 `terminus-font` ⚡ ✅

**Tujuan**: Font bitmap berkualitas tinggi untuk konsol TTY — **perbedaan kenyamanan membaca sangat
drastis** dibanding font TTY default yang pixelated.

**Penggunaan Dasar**:
```bash
pacman -S terminus-font

# Set font sementara:
setfont ter-v22b          # 22pt bold
setfont ter-v18b          # 18pt bold (lebih kecil)
setfont ter-v28b          # 28pt bold (lebih besar)
showconsolefont           # Tampilkan font saat ini

# Set font permanen di /etc/vconsole.conf:
echo "FONT=ter-v22b" | sudo tee -a /etc/vconsole.conf
```

**Ukuran tersedia**: `ter-v12b` (sangat kecil) → `ter-v16b` → `ter-v18b` → `ter-v22b` (rekomendasi)
→ `ter-v24b` → `ter-v28b` → `ter-v32b` (sangat besar)

**Kata Kunci**: `terminus font archlinux`, `vconsole.conf font`, `setfont TTY`, `console font`

**Catatan**: **Sangat direkomendasikan** untuk penggunaan TTY jangka panjang. Matanya akan berterima
kasih.

---

### 26.2 `asciinema` ⚡ ✅

**Tujuan**: Rekam sesi terminal dan share secara online atau simpan lokal — demo tutorial, workflow,
dan troubleshooting tanpa screenshot.

**Penggunaan Dasar**:
```bash
pacman -S asciinema
asciinema rec demo.cast            # Rekam ke file lokal
asciinema rec                      # Rekam + upload ke asciinema.org
asciinema play demo.cast           # Putar recording
asciinema upload demo.cast         # Upload ke asciinema.org
asciinema cat demo.cast            # Lihat raw log
asciinema --help
```

**Kata Kunci**: `asciinema record terminal`, `asciinema share`, `asciinema player`

---

### 26.3 `fastfetch` ✅

**Tujuan**: Tampilkan informasi sistem dan ASCII art distro — lebih cepat dari neofetch, lebih
banyak info yang bisa dikonfigurasi.

**Penggunaan Dasar**:
```bash
pacman -S fastfetch
fastfetch                           # Tampilkan info sistem
fastfetch --help
fastfetch --config none             # Minimal output
fastfetch --logo Arch               # ASCII art Arch Linux
```

**Kata Kunci**: `fastfetch config`, `fastfetch vs neofetch`, `fastfetch archlinux`

---

### 26.4 `tealdeer` (tldr) ⚡ ✅

**Tujuan**: Cheatsheet perintah dengan contoh praktis — alternatif `man` yang lebih cepat dibaca.
Jawab pertanyaan "bagaimana cara menggunakan tool X" dalam hitungan detik.

**Penggunaan Dasar**:
```bash
pacman -S tealdeer
tldr --update                       # Update database cheatsheet
tldr tar                            # Contoh penggunaan tar
tldr rsync                          # Contoh rsync
tldr ffmpeg                         # Contoh ffmpeg
tldr git                            # Contoh git
tldr --list | fzf | xargs tldr     # Browse semua dengan fzf!
```

**Kata Kunci**: `tldr man pages alternative`, `tealdeer update`, `tldr cheatsheet`

---

### 26.5 `jq` ⚡ ✅

**Tujuan**: JSON processor CLI — parse, filter, transform, dan format data JSON dari command line.
Essential untuk bekerja dengan API dan config JSON.

**Penggunaan Dasar**:
```bash
pacman -S jq
curl -s api.example.com | jq '.'              # Pretty print JSON
curl -s api.com | jq '.data[].name'           # Extract field spesifik
curl -s api.com | jq '.users | length'        # Count items
curl -s api.com | jq '.[] | select(.age > 18)' # Filter kondisi
cat data.json | jq 'keys'                     # Lihat semua keys
cat data.json | jq 'to_entries | .[] | .key'  # Iterate keys
jq --help
```

**Kata Kunci**: `jq tutorial`, `jq filter JSON`, `jq curl API`, `jq select filter`

---

### 26.6 `yq` 🔄 ✅

**Tujuan**: Seperti `jq` tapi untuk YAML, XML, TOML, dan CSV — proses file konfigurasi berbasis
YAML langsung dari CLI.

**Penggunaan Dasar**:
```bash
pacman -S go-yq
yq '.spec.containers' pod.yaml                  # Baca field YAML
yq -i '.version = "2.0"' config.yaml           # Edit in-place
yq -i '.items += ["baru"]' list.yaml           # Tambah item
yq -o=json config.yaml                          # Konversi YAML ke JSON
yq --help
```

**Kata Kunci**: `yq yaml CLI`, `yq TOML XML`, `yq vs jq`, `yq edit in-place`

---

### 26.7 `sed` + `awk` ⚡ 📦

**Tujuan**: Stream text processors — pattern matching, transform, extract, dan manipulasi data teks.
Backbone dari shell scripting.

**Penggunaan Dasar**:
```bash
# sed — Stream Editor:
sed 's/lama/baru/g' file.txt              # Replace semua occurrences
sed -i 's/lama/baru/g' file.txt          # In-place edit
sed -n '10,20p' file.txt                  # Print baris 10-20
sed '/pattern/d' file.txt                 # Hapus baris yang match pattern
sed '/^#/d; /^$/d' file.txt              # Hapus komentar dan baris kosong

# awk — Data Processing:
awk '{print $2}' file.txt                 # Print kolom kedua
awk -F, '{print $1}' data.csv            # CSV: print kolom pertama
awk '{sum+=$3} END{print sum}' data.txt  # Sum kolom ketiga
awk 'NR>1' file.txt                       # Skip baris pertama (header)
awk '/pattern/{print $0}' file.txt        # Filter baris matching
```

**Kata Kunci**: `sed tutorial linux`, `awk tutorial`, `sed awk cheatsheet`, `awk CSV processing`

**Catatan**: Tersedia di pacstrap sebagai bagian dari `gawk` dan `sed`.

---

### 26.8 `systemctl` + `journalctl` ⚡ 📦

**Tujuan**: Manajemen service systemd dan pembacaan log sistem — kontrol semua service, timer,
dan monitoring log.

**Penggunaan Dasar**:
```bash
# systemctl:
systemctl start nginx               # Start service
systemctl stop nginx                # Stop service
systemctl restart nginx             # Restart
systemctl enable --now nginx        # Enable on boot + start sekarang
systemctl disable nginx             # Disable from boot
systemctl status nginx              # Status detail
systemctl list-units --type=service # List semua service
systemctl list-units --failed       # Service yang gagal
systemctl daemon-reload             # Reload systemd config
systemctl --user enable mpd         # User-level service

# journalctl:
journalctl -u nginx                 # Log service spesifik
journalctl -u nginx -f              # Log realtime (follow)
journalctl -b                       # Log sejak boot terakhir
journalctl -b -1                    # Log boot sebelumnya
journalctl --since "1 hour ago"     # Log 1 jam terakhir
journalctl -p err                   # Hanya error level
journalctl --disk-usage             # Ukuran log di disk
journalctl --vacuum-time=2weeks     # Bersihkan log lebih dari 2 minggu
```

**Kata Kunci**: `systemctl commands`, `journalctl filters`, `systemd service`, `systemd timers`

---

### 26.9 `cronie` ✅

**Tujuan**: Cron daemon untuk penjadwalan task berkala — backup otomatis, sync, update database, dll.

**Penggunaan Dasar**:
```bash
pacman -S cronie
systemctl enable --now cronie

crontab -e                          # Edit cron jobs dengan editor
crontab -l                          # Tampilkan cron jobs saat ini
crontab -r                          # Hapus semua cron jobs

# Format crontab: menit jam hari bulan hari-minggu perintah
# 0 2 * * * rsync -av ~/Docs/ /mnt/backup/Docs/   # Backup jam 2 pagi setiap hari
# */30 * * * * mbsync -a                           # Sync email setiap 30 menit
# 0 0 1 * * updatedb                               # Update locate DB tiap bulan
```

**Kata Kunci**: `crontab tutorial`, `cron syntax`, `cronie archlinux`, `crontab examples`

---

## ═══════════════════════════════════════
## 27. 📊 PRODUKTIVITAS & OFFICE TAMBAHAN
## ═══════════════════════════════════════

### 27.1 `gnuplot` 🔄 ✅

**Tujuan**: Plot grafik data scientific langsung di terminal (mode dumb/ASCII) atau ke file gambar —
visualisasi data tanpa GUI.

**Penggunaan Dasar**:
```bash
pacman -S gnuplot
gnuplot                             # Mode interaktif

# ASCII plot langsung di terminal:
echo "set terminal dumb 80 24; plot sin(x)" | gnuplot

# Plot dari data file:
cat << 'EOF' | gnuplot
set terminal dumb
set xlabel "X"
set ylabel "Y"
plot "data.csv" using 1:2 with lines title "Data"
EOF
```

**Kata Kunci**: `gnuplot tutorial`, `gnuplot terminal dumb`, `gnuplot script`, `gnuplot data file`

---

### 27.2 `bc` ⚡ 📦

**Tujuan**: Kalkulator presisi arbitrary di command line dengan fungsi matematika.

**Penggunaan Dasar**:
```bash
bc -l                               # Mode interaktif dengan math library
echo "scale=10; 22/7" | bc         # Pi approximation (10 desimal)
echo "2^32" | bc                    # Pangkat
echo "sqrt(2)" | bc -l             # Akar kuadrat
echo "e(1)" | bc -l                # Euler's number e
echo "obase=2; 255" | bc           # Desimal ke binary
echo "ibase=16; FF" | bc           # Hex ke desimal
```

**Kata Kunci**: `bc calculator linux`, `bc scale precision`, `bc math functions`

**Catatan**: Tersedia di pacstrap.

---

### 27.3 `qalculate` 🔄 ✅

**Tujuan**: Kalkulator powerful dengan konversi unit, konstanta fisika, dan fungsi lanjutan.

**Penggunaan Dasar**:
```bash
pacman -S libqalculate
qalc                                # Mode interaktif
qalc "5 km in miles"                # Konversi unit
qalc "speed of light in km/s"       # Konstanta fisika
qalc "100 USD in EUR"               # Konversi mata uang (online)
```

**Kata Kunci**: `qalculate CLI`, `qalc unit conversion`, `qalculate constants`

---

### 27.4 `zathura` (dengan framebuffer) 💡 🔶

**Tujuan**: Dokumen viewer (PDF/EPUB/DjVu) dengan vi-keybindings — bisa dijalankan di framebuffer
tanpa X11 dengan backend yang tepat.

**Penggunaan Dasar**:
```bash
yay -S zathura zathura-pdf-mupdf
# Untuk TTY via framebuffer perlu konfigurasi khusus:
DISPLAY= zathura file.pdf          # Mode framebuffer (experimental)
```

**Kata Kunci**: `zathura PDF viewer`, `zathura framebuffer`, `zathura vi keybindings`

---

## ═══════════════════════════════════════
## 28. 🛡️ SECURITY TOOLS TAMBAHAN
## ═══════════════════════════════════════

### 28.1 `fail2ban` 🔄 ✅

**Tujuan**: Proteksi brute force — monitor log dan blokir IP yang gagal login berulang kali ke SSH,
web server, dan service lainnya.

**Penggunaan Dasar**:
```bash
pacman -S fail2ban
systemctl enable --now fail2ban

fail2ban-client status                  # Status semua jail
fail2ban-client status sshd             # Status SSH jail spesifik
fail2ban-client set sshd unbanip IP    # Unban IP spesifik
fail2ban-client banned                  # Daftar semua IP yang diblokir
journalctl -u fail2ban -f               # Monitor log realtime
```

**Kata Kunci**: `fail2ban archlinux`, `fail2ban SSH protection`, `fail2ban config jail.local`

---

### 28.2 `nmap` (sudah di bagian Network) + `nikto` + `masscan` 🔄 ✅

**Tujuan**: Toolkit audit keamanan tambahan.

```bash
# nikto - web server scanner:
yay -S nikto
nikto -h https://target.com

# masscan - port scanner ultra-cepat:
yay -S masscan
masscan -p1-65535 192.168.1.0/24 --rate=1000
```

---

## ═══════════════════════════════════════
## 29. 🎨 KUSTOMISASI & ESTETIKA TTY
## ═══════════════════════════════════════

### 29.1 Konfigurasi TTY Lengkap

**File `/etc/vconsole.conf`** — Konfigurasi konsol permanen:
```bash
KEYMAP=us            # atau: id (Indonesia), dvorak, dll
FONT=ter-v22b        # Terminus font 22pt bold
FONT_MAP=8859-2      # Unicode mapping
```

**Truecolor di TTY modern**:
```bash
# Cek dukungan warna:
printf '\e[38;2;255;100;0m TrueColor \e[0m\n'

# Di ~/.zshrc atau ~/.bashrc:
export COLORTERM=truecolor
export TERM=linux    # Untuk konsol TTY
# atau jika menggunakan terminal emulator:
export TERM=xterm-256color
```

---

### 29.2 `shell-color-scripts` 💡 🔶

**Tujuan**: Kumpulan script dekorasi ASCII art berwarna untuk terminal — menyambut saat buka shell.

**Penggunaan Dasar**:
```bash
yay -S shell-color-scripts
colorscript -r                      # Random color script
colorscript -l                      # List semua script
colorscript -e crunchbang           # Script spesifik

# Tambah ke ~/.zshrc untuk auto-tampil:
colorscript -r
```

**Kata Kunci**: `shell color scripts`, `colorscript terminal`, `terminal decoration`

---

### 29.3 `cmatrix` / `pipe.sh` / `cbonsai` 💡 ✅

**Tujuan**: Dekorasi terminal yang ikonik — idle screensaver atau sekadar fun.

**Penggunaan Dasar**:
```bash
pacman -S cmatrix
cmatrix              # Matrix rain effect
cmatrix -C red       # Warna merah

yay -S cbonsai
cbonsai              # Bonsai tree ASCII art
cbonsai -i           # Infinite mode (screensaver)
```

**Kata Kunci**: `cmatrix terminal`, `cbonsai ASCII art`, `terminal screensaver`

---

## ═══════════════════════════════════════
## 📋 RINGKASAN INSTALASI PRIORITAS
## ═══════════════════════════════════════

### 🚀 TAHAP 1: pacstrap (Saat Instalasi Arch)
```bash
pacstrap /mnt base base-devel linux linux-firmware \
  networkmanager openssh git tmux neovim nano \
  alsa-utils terminus-font man-db man-pages \
  iwd dhcpcd wget curl rsync gnupg sudo zsh \
  grub efibootmgr dosfstools
```

### ⚡ TAHAP 2: Segera Setelah Boot Pertama
```bash
pacman -S zsh starship \
  btop htop ncdu duf \
  ranger lf nnn eza bat zoxide \
  fzf ripgrep fd plocate \
  mpv ffmpeg yt-dlp streamlink \
  fim chafa viu \
  poppler pandoc glow sc-im \
  aria2 axel \
  lazygit tig \
  newsboat w3m \
  pass nftables ufw \
  pulsemixer pipewire pipewire-alsa pipewire-pulse wireplumber \
  mpd ncmpcpp cmus \
  task calcurse \
  sqlite jq tealdeer fastfetch \
  bluez bluez-utils tlp powertop brightnessctl \
  rtorrent ouch asciinema cronie \
  python python-pip nodejs npm rustup \
  helix micro inxi glances

# AUR Helper dulu:
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

# Lalu AUR packages:
yay -S paru browsh-bin bluetui tut gomuks aerc \
  shell-color-scripts cbonsai
```

### 🔄 TAHAP 3: Sesuai Kebutuhan
```bash
# Email full setup:
pacman -S neomutt isync msmtp himalaya

# Development:
pacman -S gdb valgrind strace ltrace cmake \
  pgcli mycli litecli

# Security:
pacman -S lynis fail2ban bitwarden-cli

# Backup:
pacman -S restic rclone borgbackup

# Kalender cloud:
pacman -S khal vdirsyncer timewarrior
```

---

## 📌 CATATAN KRITIS UNTUK TTY MURNI

### 🎥 Video di TTY
```bash
# Cara 1 - DRM/KMS (rekomendasi):
mpv --vo=drm video.mp4

# Cara 2 - VAAPI (jika GPU support):
mpv --vo=vaapi video.mp4

# Syarat: user harus di grup video:
sudo usermod -aG video $USER
# Verifikasi: ls -la /dev/dri/
```

### 🖼️ Gambar di TTY
```bash
# Via framebuffer:
fim gambar.jpg   # User harus di grup video
# Verifikasi: ls -la /dev/fb0

# Tanpa framebuffer (ASCII):
chafa gambar.jpg  # Bekerja di TTY apapun
```

### 🔇 Audio Setup Minimal
```bash
pacman -S alsa-utils pipewire pipewire-alsa pipewire-pulse wireplumber
systemctl --user enable --now pipewire pipewire-pulse wireplumber
# Test: speaker-test -t wav -c 2
# Kontrol: alsamixer (cek tidak ada 'MM' pada master)
```

### 📋 Clipboard di TTY
Di TTY murni tanpa X11/Wayland, clipboard sistem (`xclip`, `wl-clipboard`) tidak tersedia:
```bash
# Solusi 1 — tmux buffer (TERBAIK):
# PREFIX + [ → enter copy mode
# Space → mulai selection, Enter → copy
# PREFIX + ] → paste

# Solusi 2 — file sementara:
cat file.txt > /tmp/clip && cat /tmp/clip

# Solusi 3 — xclip via Xvfb (advanced):
# Tidak direkomendasikan untuk setup TTY murni
```

### 🎨 Font dan Warna TTY
```bash
# /etc/vconsole.conf yang optimal:
KEYMAP=us
FONT=ter-v22b         # Terminus 22pt - nyaman untuk coding
FONT_MAP=8859-2

# Set manual untuk test:
setfont ter-v22b

# Cek dukungan 256 warna di TTY:
for i in {0..255}; do printf "\x1b[38;5;${i}m%3d " "${i}"; done
```

### 🔊 Scrollback Buffer TTY
TTY default tidak punya scrollback. Solusi:
```bash
# tmux memberikan scrollback tak terbatas:
# PREFIX + [ → scroll mode, q → keluar
# PREFIX + PgUp/PgDn → scroll cepat

# Set scrollback limit di tmux.conf:
set -g history-limit 50000
```

---

*Dibuat untuk Arch Linux — CLI/TTY Full Power — No GUI Needed*
*Semua tools terverifikasi tersedia di Arch Linux 2025*
