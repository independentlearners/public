# **FASE 1: FONDASI — MENGENAL SHELL DAN ZSH**

## 🔍 AUDIT KURIKULUM FASE 1

Sebelum masuk ke materi, saya melakukan audit singkat terhadap struktur kurikulum Fase 1:

| Modul | Judul | Kelengkapan | Catatan Audit |
|---|---|---|---|
| 1.1 | Apa Itu Shell dan Mengapa Zsh? | ✅ Lengkap | Perlu ditambahkan: terminal emulator modern (WezTerm, Warp), shell alternatif (fish, nushell) sebagai konteks perbandingan |
| 1.2 | Navigasi Sistem File dan Perintah Dasar | ✅ Lengkap | Perlu ditambahkan: `zoxide` (smart cd), `fzf` (fuzzy finder) sebagai tools modern Zsh |
| 1.3 | Variabel, Quoting, dan Ekspansi | ✅ Lengkap | Perlu ditambahkan: `print -P` (prompt expansion), `${(q)}` flag untuk quoting aman |

**Rekomendasi pembaruan kurikulum:**
- Tambahkan **Modul 1.4: Autoloading dan Fungsi** (sebagai jembatan ke fase berikutnya)
- Tambahkan **Modul 1.5: History dan Line Editing** (sebelum masuk ke scripting)

> *Catatan: Saya akan tetap fokus pada tiga modul yang ada, namun menyisipkan materi tambahan yang relevan sebagai "Deep Dive" di setiap modul.*

---

# 📘 MODUL 1.1: APA ITU SHELL DAN MENGAPA ZSH?

## 📋 Struktur Pembelajaran Internal (Mini Daftar Isi)

1. Arsitektur Sistem: Kernel, Shell, dan Terminal Emulator
2. Sejarah Evolusi Shell: sh → bash → zsh → fish
3. Perbedaan Fundamental Zsh vs Bash
4. Instalasi Zsh di Berbagai Platform
5. Mengganti Shell Default dengan Aman
6. Deep Dive: Terminal Emulator Modern (WezTerm, Warp, Alacritty)
7. Deep Dive: Shell Alternatif (fish, nushell) — Konteks Perbandingan

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah **fondasi paling dasar** dari seluruh kurikulum. Tanpa pemahaman yang benar tentang apa itu shell, bagaimana ia bekerja, dan mengapa Zsh dipilih, seluruh pembelajaran selanjutnya akan terasa seperti menghafal perintah tanpa memahami esensi. Modul ini menjawab pertanyaan mendasar: *"Apa yang sebenarnya terjadi ketika saya mengetik perintah dan menekan Enter?"*

Dalam konteks kurikulum keseluruhan, Modul 1.1 berperan sebagai **peta konseptual** yang akan terus dirujuk sepanjang pembelajaran. Ketika nanti Anda menulis script, mengkonfigurasi `.zshrc`, atau melakukan debugging, pemahaman tentang arsitektur kernel–shell–terminal akan menjadi "kompas" yang memandu setiap keputusan teknis.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1 Arsitektur Sistem: Kernel, Shell, dan Terminal Emulator

Bayangkan sistem operasi seperti sebuah **restoran**:

```bash
┌─────────────────────────────────────────────────────────────┐
│                    ESTORAN (Sistem Komputer)                │
│                                                             │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐   │
│  │   PELANGGAN  │    │   PELAYAN    │    │    DAPUR     │   │
│  │  (Pengguna)  │── →│   (Shell)    │───→│   (Kernel)   │   │
│  │              │    │              │    │              │   │
│  │ Mengetik     │    │ Menerjemah-  │    │ Mengelola    │   │
│  │ pesanan      │    │ kan pesanan  │    │ resource     │   │
│  └──────────────┘    └──────────────┘    └──────────────┘   │
│         ↑                    ↑                   ↑          │
│         │                    │                   │          │
│    ┌────┴─────┐         ┌────┴────┐         ┌────┴────┐     │
│    │ Terminal │         │  Shell  │         │ Kernel  │     │
│    │ Emulator │         │  (Zsh)  │         │ (Linux) │     │
│    └──────────┘         └─────────┘         └─────────┘     │
│                                                             │
│  Penjelasan:                                                │
│  • Terminal Emulator = Meja tempat pelanggan duduk          │
│  • Shell = Pelayan yang mencatat pesanan                    │
│  • Kernel = Dapur yang memasak pesanan                      │
└─────────────────────────────────────────────────────────────┘
```

**Terminal Emulator** adalah **jendela grafis** tempat Anda mengetik. Ia tidak "memahami" perintah apa pun — ia hanya menampilkan teks dan mengirimkan keystroke Anda ke shell. Contoh: iTerm2 (macOS), GNOME Terminal (Linux), Windows Terminal (Windows), WezTerm (cross-platform), Alacritty (GPU-accelerated).

**Shell** adalah **program penerjemah** yang membaca perintah, memprosesnya (ekspansi, quoting, globbing), dan meminta kernel mengeksekusinya. Shell adalah *interface* antara manusia dan kernel. Contoh: sh, bash, zsh, fish, ksh, nushell.

**Kernel** adalah **inti sistem operasi** yang mengelola resource perangkat keras: CPU, memory, disk, network. Kernel tidak peduli siapa yang mengirim perintah — ia hanya peduli *apa* yang diminta dan *bagaimana* mengeksekusinya.

**Alur eksekusi perintah `ls -la`:**

```bash
Pengguna mengetik: "ls -la" + [Enter]
         │
         ▼
┌─────────────────────┐
│  Terminal Emulator  │  ← Menangkap keystroke, menampilkan karakter
│  (WezTerm/iTerm2)   │
└─────────┬───────────┘
          │ Mengirim string "ls -la\n"
          ▼
┌─────────────────────┐
│    Shell (Zsh)      │  ← Membaca input, melakukan parsing
│                     │     • Tokenisasi: ["ls", "-la"]
│                     │     • Ekspansi: tidak ada (literal)
│                     │     • Mencari binary: /bin/ls
└─────────┬───────────┘
          │ fork() + execve("/bin/ls", ["ls", "-la"])
          ▼
┌─────────────────────┐
│      Kernel         │  ← Menerima system call
│      (Linux)        │     • Alokasi memory
│                     │     • Membaca filesystem
│                     │     • Menulis ke stdout
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│   Output ke layar   │  ← Terminal menampilkan hasil
└─────────────────────┘
```

> **Visualisasi diagram alur/struktur [Pengguna → Terminal → Shell → Kernel → Hardware] akan sangat membantu di sini.**

### 2.2 Filosofi Unix dan Shell

Filosofi Unix yang mendasari desain shell adalah:

> **"Lakukan satu hal dengan baik, dan gabungkan dengan alat lain."**

Dalam praktiknya:

```bash
# Setiap perintah adalah program kecil yang melakukan SATU hal
ls          # Hanya menampilkan daftar file
grep        # Hanya mencari pola teks
sort        # Hanya mengurutkan baris
wc          # Hanya menghitung baris/kata/karakter

# Kekuatan sebenarnya: MENGGABUNGKAN melalui pipe (|)
ls -la | grep ".txt" | sort -k5 -n | head -10
# 1. ls -la      → daftar file detail
# 2. grep .txt   → filter hanya file .txt
# 3. sort -k5 -n → urutkan berdasarkan kolom 5 (size) secara numerik
# 4. head -10    → ambil 10 teratas
```

**Pipe (`|`)** adalah operator yang menghubungkan stdout dari satu perintah ke stdin perintah berikutnya. Ini adalah *lem* yang menyatukan program-program kecil menjadi pipeline yang powerful.

**Redirection (`>` dan `<`):** Menghubungkan stdout/stdin ke file alih-alih ke terminal. Contoh: `ls > daftar.txt` menyimpan output ke file.

### 2.3 Filosofi Zsh: "Shell untuk Manusia"

Zsh dirancang dengan prinsip yang berbeda dari bash. Bash mengutamakan **kompatibilitas POSIX** dan **scripting portability**. Zsh mengutamakan **pengalaman interaktif manusia**:

| Aspek | Bash | Zsh |
|---|---|---|
| **Tab Completion** | Dasar, hanya prefix | Cerdas, fuzzy matching, deskripsi opsi, menu selection |
| **Koreksi Ejaan** | Tidak ada | Otomatis: `gti` → `git` |
| **Array Index** | 0-based (seperti C) | **1-based** (seperti manusia menghitung) |
| **Globbing** | Terbatas | Extended globbing dengan kualifikasi |
| **Prompt** | Sederhana, perlu PS1 manual | `vcs_info`, `prompt` themes, Powerlevel10k |
| **Plugin** | Bash-it (minimal) | Oh My Zsh, Prezto, Zinit, Antigen |

**Mengapa array 1-indexed?**

```bash
# Zsh: elemen pertama adalah [1]
buah=(apel jeruk mangga)
echo ${buah[1]}   # Output: apel
echo ${buah[2]}   # Output: jeruk

# Bash: elemen pertama adalah [0]
buah=(apel jeruk mangga)
echo ${buah[0]}   # Output: apel
echo ${buah[1]}   # Output: jeruk
```

Filosofi di balik ini: **Manusia menghitung dari 1**, bukan dari 0. Dalam Zsh, Anda tidak perlu berpikir "elemen pertama ada di indeks 0" — Anda cukup berpikir "elemen pertama adalah [1]". Ini mengurangi beban kognitif dalam penulisan script interaktif.

> **Filosofi Kunci Zsh:** *"The shell for the human"* — setiap fitur dirancang untuk mengurangi friksi antara niat pengguna dan eksekusi.

---

## 3. Sintaks Dasar / Contoh Implementasi Inti

### 3.1 Cek Shell yang Sedang Digunakan

```bash
# Cek shell login (shell yang dijalankan saat login)
echo $SHELL
# Output: /bin/zsh  (atau /usr/bin/zsh, /bin/bash, dll.)

# Cek shell yang sedang berjalan (bisa berbeda dari shell login)
echo $0
# Output: -zsh  (tanda minus menunjukkan login shell)
#         zsh   (tanpa minus = non-login shell)
#         bash  (jika Anda menjalankan bash dari dalam zsh)
```

**Penjelasan sintaks:**
- `$SHELL` — **environment variable** yang menyimpan path shell default pengguna. Nilai ini di-set saat login oleh sistem (biasanya dari `/etc/passwd`).
- `$0` — **positional parameter** khusus yang menyimpan nama shell atau script yang sedang berjalan. Dalam konteks shell interaktif, ini adalah nama shell itu sendiri.
- `echo` — perintah built-in shell untuk menampilkan teks. Di Zsh, `echo` memiliki beberapa flag (misalnya `-e` untuk interpretasi escape sequence).

### 3.2 Melihat Daftar Shell yang Tersedia

```bash
# Melihat semua shell yang terdaftar sebagai "legal shell" di sistem
cat /etc/shells

# Contoh output:
# /bin/sh
# /bin/bash
# /bin/zsh
# /usr/bin/zsh
# /usr/bin/fish
```

**Penjelasan:**
- `/etc/shells` — file teks yang berisi daftar path shell yang dianggap *valid* oleh sistem.
- `chsh` (change shell) hanya mengizinkan penggantian ke shell yang terdaftar di file ini. Ini adalah **fitur keamanan**: mencegah pengguna mengganti shell ke program arbitrer.
- `cat` — singkatan dari "concatenate", namun dalam konteks ini berfungsi untuk menampilkan isi file ke stdout.

### 3.3 Mengganti Shell Default ke Zsh

```bash
# Cari lokasi binary zsh terlebih dahulu
which zsh
# Output contoh: /usr/bin/zsh  atau  /opt/homebrew/bin/zsh

# Ganti shell default (akan meminta password)
chsh -s $(which zsh)

# Verifikasi perubahan
echo $SHELL
# Output: /usr/bin/zsh  (setelah login ulang)
```

**Penjelasan sintaks:**
- `which` — perintah untuk mencari lokasi executable di `$PATH`. Mengembalikan path lengkap binary pertama yang ditemukan.
- `chsh` — *change shell*, perintah untuk mengubah shell login pengguna. Mengubah entry di `/etc/passwd` untuk user Anda.
- `-s` — flag untuk menentukan shell baru (singkatan dari `--shell`).
- `$(which zsh)` — **command substitution**: menjalankan `which zsh` dan menggunakan outputnya sebagai argumen untuk `chsh`. Ini adalah cara yang lebih portabel daripada hardcode `/bin/zsh` karena lokasi zsh bisa berbeda di setiap sistem.
- `chsh -s $(which zsh)` — perlu **login ulang** (atau buka terminal baru) agar perubahan berlaku, karena `$SHELL` di-set saat login.

**Praktik terbaik:** Jangan pernah mengubah shell default ke path yang tidak ada di `/etc/shells`. Jika `chsh` gagal, periksa apakah zsh sudah terdaftar. Jika belum, tambahkan path zsh ke `/etc/shells` (memerlukan akses root).

### 3.4 Verifikasi Instalasi

```bash
# Cek versi Zsh
zsh --version
# Output: zsh 5.9 (x86_64-ubuntu-linux-gnu)

# Cek fitur yang di-compile (opsional, untuk deep-dive)
zsh --version && zsh -c 'echo $ZSH_VERSION'
```

---

## 4. Terminologi Esensial & Penjelasan Detail

| Istilah | Definisi | Contoh / Catatan |
|---|---|---|
| **Shell** | Program yang menerjemahkan perintah pengguna menjadi instruksi sistem operasi. Bertindak sebagai *command interpreter*. | `zsh`, `bash`, `sh`, `fish`, `ksh` |
| **Kernel** | Inti sistem operasi yang mengelola resource perangkat keras (CPU, memory, disk, network). | Linux kernel, Darwin (macOS), Windows NT kernel |
| **Terminal Emulator** | Aplikasi grafis yang menampilkan output shell dan menerima input keyboard. | iTerm2, WezTerm, GNOME Terminal, Windows Terminal, Alacritty |
| **POSIX** | Standar portabilitas sistem operasi (Portable Operating System Interface). Menentukan bagaimana shell harus berperilaku. | Bash sebagian besar POSIX-compliant; Zsh *mostly* POSIX-compliant dengan opsi `emulate sh` |
| **Prompt** | Teks yang ditampilkan shell sebelum menerima input. Biasanya berisi informasi user, hostname, dan current directory. | `$` (bash), `%` (zsh), `➜ ~` (Oh My Zsh default) |
| **Login Shell** | Shell yang dijalankan saat pengguna login. Membaca file konfigurasi login (`.zprofile`, `.zlogin`). | Ditandai dengan `-` di depan nama shell (`-zsh`) |
| **Non-Login Shell** | Shell yang dijalankan di dalam sesi yang sudah login (misalnya membuka tab baru di terminal). | Membaca `.zshrc` saja |
| **`$PATH`** | Environment variable yang berisi daftar direktori tempat sistem mencari executable. | `/usr/local/bin:/usr/bin:/bin` |
| **Environment Variable** | Variabel yang diwariskan ke child process. Berbeda dengan variabel shell biasa. | `$HOME`, `$PATH`, `$SHELL`, `$EDITOR` |
| **Dotfile** | File konfigurasi yang dimulai dengan titik (`.`) dan tersembunyi secara default. | `.zshrc`, `.zprofile`, `.zshenv`, `.zlogin` |

**Penjelasan tambahan untuk istilah yang sering membingungkan:**

**"Shell" vs "Terminal" vs "Command Line"** — Ketiganya sering digunakan bergantian dalam percakapan sehari-hari, tetapi secara teknis berbeda:
- **Terminal** = jendela (software) yang Anda lihat dan ketik di dalamnya.
- **Shell** = program yang berjalan *di dalam* terminal dan memproses perintah Anda.
- **Command Line** = *antarmuka* (interface) tempat Anda mengetik perintah — bisa berupa terminal, bisa juga REPL Python, MySQL prompt, dll.

**"POSIX Compliance"** — Bash dan Zsh memiliki tingkat kepatuhan POSIX yang berbeda. Bash dirancang untuk menjadi POSIX-compliant (terutama saat dipanggil sebagai `sh`). Zsh *tidak* berusaha menjadi POSIX-compliant secara default, tetapi memiliki **emulation mode** (`emulate sh`) untuk menjalankan script POSIX. Perbedaan ini penting ketika Anda menulis script portabel.

---

## 5. Deep Dive: Terminal Emulator Modern

*(Tambahan di luar kurikulum — penting untuk pemahaman praktis)*

### 5.1 Mengapa Terminal Emulator Penting?

Terminal emulator menentukan **pengalaman visual dan interaktif** Anda. Terminal lama (seperti `xterm`) hanya menampilkan teks monokrom. Terminal modern menawarkan:

| Fitur | Terminal Klasik | Terminal Modern |
|---|---|---|
| **GPU Acceleration** | ❌ CPU-based rendering | ✅ GPU-based (Alacritty, WezTerm, Kitty) |
| **Ligatures** | ❌ Tidak didukung | ✅ `->`, `=>`, `!=` ditampilkan sebagai simbol |
| **Image Protocol** | ❌ Tidak ada | ✅ Kitty protocol, iTerm2 protocol |
| **Split Panes** | ❌ Perlu tmux | ✅ Built-in (WezTerm) |
| **Font Fallback** | Terbatas | Cerdas (emoji, Nerd Fonts) |
| **Hyperlinks** | ❌ Teks biasa | ✅ Ctrl+Click untuk buka URL |

### 5.2 Rekomendasi Terminal Emulator per Platform

| Platform | Rekomendasi | Alasan |
|---|---|---|
| **macOS** | iTerm2, WezTerm, Kitty | iTerm2 paling mature; WezTerm cross-platform |
| **Linux** | WezTerm, Alacritty, Kitty | GPU-accelerated, config via file |
| **Windows** | Windows Terminal, WezTerm | Windows Terminal terintegrasi dengan WSL |
| **Cross-platform** | WezTerm | Satu config untuk semua OS |

### 5.3 Contoh Konfigurasi WezTerm (`~/.wezterm.lua`)

```lua
-- ~/.wezterm.lua
local wezterm = require 'wezterm'

return {
  -- Font: menggunakan Nerd Font untuk ikon
  font = wezterm.font_with_fallback {
    'JetBrainsMono Nerd Font',
    'Noto Color Emoji',
  },
  font_size = 12.0,

  -- Warna: skema Tokyo Night
  color_scheme = 'Tokyo Night',

  -- Window: opacity dan padding
  window_background_opacity = 0.95,
  window_padding = { left = 8, right = 8, top = 4, bottom = 4 },

  -- Keybindings: split pane
  keys = {
    { key = 'd', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal },
    { key = 'e', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical },
  },

  -- Shell default
  default_prog = { 'zsh', '-l' },
}
```

**Penjelasan:**
- `wezterm.lua` — WezTerm dikonfigurasi menggunakan Lua, bukan YAML/TOML. Ini memberikan fleksibilitas penuh (kondisi, loop, fungsi).
- `font_with_fallback` — menentukan font utama dan fallback jika karakter tidak tersedia (misalnya emoji).
- `default_prog = { 'zsh', '-l' }` — menjalankan Zsh sebagai *login shell* (`-l` flag) agar membaca `.zprofile` dan `.zlogin`.

---

## 6. Deep Dive: Shell Alternatif — Konteks Perbandingan

*(Tambahan di luar kurikulum — untuk memperluas perspektif)*

### 6.1 Fish Shell

**Filosofi:** *"Finally, a command line shell for the 90s"* — fish (Friendly Interactive SHell) mengutamakan **kemudahan penggunaan** di atas kompatibilitas POSIX.

| Fitur | Zsh | Fish |
|---|---|---|
| **Sintaks** | Bourne-compatible | Berbeda total (tidak POSIX) |
| **Autosuggestion** | Perlu plugin | Built-in |
| **Syntax Highlighting** | Perlu plugin | Built-in |
| **Tab Completion** | Cerdas, perlu setup | Cerdas, built-in |
| **Scripting** | Powerful, kompleks | Sederhana, terbatas |
| **Konfigurasi** | `.zshrc` (shell script) | `config.fish` (fish script) |

**Contoh perbedaan sintaks:**

```python
# Fish: variabel
set nama "Budi"
echo "Halo $nama"

# Fish: kondisi
if test -f file.txt
    echo "File ada"
end
```

```bash
# Zsh: variabel
nama="Budi"
echo "Halo $nama"

# Zsh: kondisi
if [[ -f file.txt ]]; then
    echo "File ada"
fi
```

**Mengapa Zsh tetap lebih powerful?** Fish membatasi kompleksitas scripting untuk menjaga kesederhanaan. Zsh memberikan **kekuatan scripting penuh** dengan **pengalaman interaktif yang baik** — kombinasi terbaik untuk power user.

### 6.2 Nushell

**Filosofi:** *"A new type of shell"* — nushell memperlakukan data sebagai **structured data** (tabel), bukan teks.

```bash
# Nushell: output adalah tabel, bukan teks
ls | where size > 1MB | sort-by modified | first 5
```

**Kelebihan:** Manipulasi data terstruktur, error handling yang baik.
**Kekurangan:** Tidak POSIX-compatible, ekosistem masih muda, tidak cocok untuk scripting sistem.

**Kesimpulan:** Untuk pembelajaran kurikulum ini, **Zsh adalah pilihan optimal** karena:
1. POSIX-compatible (sebagian besar) — script Anda portabel
2. Ekosistem plugin terbesar (Oh My Zsh, Prezto, Zinit)
3. Default di macOS sejak Catalina — ketersediaan universal
4. Powerful scripting + excellent interactive experience

---

## 7. Hubungan dengan Modul Lain

| Modul | Hubungan |
|---|---|
| **Modul 1.2 (Navigasi)** | Modul 1.1 memberikan *konteks arsitektural* mengapa navigasi bekerja seperti itu. Tanpa memahami shell sebagai interpreter, `cd` hanya terasa seperti "perintah ajaib". |
| **Modul 1.3 (Variabel & Ekspansi)** | Memahami shell sebagai *program yang memproses teks* adalah prasyarat untuk memahami ekspansi. Shell tidak "menjalankan" `$HOME` — ia *mengganti* `$HOME` dengan nilainya sebelum eksekusi. |
| **Fase 2 (Scripting)** | Shell login vs non-login, dotfiles, dan environment variable akan menjadi kritis saat menulis script yang perlu dijalankan di berbagai konteks. |
| **Fase 3 (Plugin)** | Pemahaman tentang shell sebagai *program yang dapat dikonfigurasi* membuka pintu ke Oh My Zsh, Zinit, dan Powerlevel10k. |

---

## 8. Sumber Referensi Lengkap

| Sumber | URL | Deskripsi |
|---|---|---|
| **Dokumentasi Resmi Zsh** | https://zsh.sourceforge.io/Doc/ | Manual lengkap Zsh dalam berbagai format (HTML, PDF, Info) |
| **Zsh FAQ** | https://zsh.sourceforge.io/FAQ/ | Pertanyaan umum, termasuk perbandingan dengan shell lain |
| **Zsh Guide** | https://zsh.sourceforge.io/Guide/ | Panduan untuk pemula dari komunitas Zsh |
| **Zsh Wiki** | http://www.zshwiki.org/ | Wiki komunitas Zsh |
| **Zsh Manual — Introduction** | https://zsh.sourceforge.io/Doc/Release/Introduction.html | Bab pengenalan dalam manual resmi |
| **Bash vs Zsh — Refine.dev** | https://refine.dev/blog/zsh-vs-bash/ | Perbandingan komprehensif dengan contoh kode |
| **WezTerm Documentation** | https://wezterm.org/ | Dokumentasi terminal emulator WezTerm |
| **Fish Shell Documentation** | https://fishshell.com/docs/current/ | Dokumentasi resmi Fish Shell |
| **Nushell Documentation** | https://www.nushell.sh/book/ | Buku panduan Nushell |
| **The TTY Demystified** | https://www.linusakesson.net/programming/tty/ | Penjelasan mendalam tentang TTY dan terminal (sejarah) |

---

## 9. Tips dan Praktik Terbaik

### 9.1 Instalasi Zsh

**Linux (Ubuntu/Debian):**
```bash
sudo apt update && sudo apt install zsh
```

**Linux (Fedora/RHEL):**
```bash
sudo dnf install zsh
```

**macOS:**
```bash
# Zsh sudah pre-installed sejak Catalina
# Untuk versi terbaru via Homebrew:
brew install zsh
```

**Windows:**
```bash
# Via WSL (Windows Subsystem for Linux)
wsl --install -d Ubuntu
# Kemudian di dalam Ubuntu:
sudo apt install zsh
```

### 9.2 Mengganti Shell Default — Checklist Keamanan

```bash
# 1. Cek path zsh
which zsh
# Harus mengembalikan path yang valid, misal /usr/bin/zsh

# 2. Cek apakah zsh terdaftar di /etc/shells
grep zsh /etc/shells

# 3. Jika belum terdaftar, tambahkan (perlu sudo)
echo $(which zsh) | sudo tee -a /etc/shells

# 4. Ganti shell
chsh -s $(which zsh)

# 5. Verifikasi (perlu login ulang)
echo $SHELL
```

### 9.3 Membuat Backup Sebelum Eksperimen

```bash
# Backup .zshrc yang ada (jika sudah ada)
cp ~/.zshrc ~/.zshrc.backup

# Jika belum ada .zshrc
touch ~/.zshrc
```

### 9.4 Jangan Edit `/etc/passwd` Secara Manual

Selalu gunakan `chsh`. Mengedit `/etc/passwd` secara manual bisa menyebabkan sistem tidak bisa login jika terjadi kesalahan sintaks.

---

## 10. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| **`chsh` gagal: "shell not listed in /etc/shells"** | Error saat menjalankan `chsh -s` | Tambahkan path zsh ke `/etc/shells` terlebih dahulu |
| **`$SHELL` tidak berubah setelah `chsh`** | `echo $SHELL` masih menunjukkan shell lama | Login ulang atau buka terminal baru — `$SHELL` di-set saat login |
| **`$0` menunjukkan `-zsh` bukan `zsh`** | Bingung kenapa ada tanda minus | Tanda `-` menunjukkan *login shell* — ini normal dan benar |
| **Zsh tidak membaca `.zshrc`** | Konfigurasi tidak diterapkan | Pastikan `.zshrc` ada di `$HOME` dan shell adalah *interactive non-login* |
| **Menjalankan script bash di Zsh** | Error sintaks yang tidak terduga | Gunakan `bash script.sh` atau tambahkan `#!/bin/bash` di header script |
| **Path zsh berbeda setelah update** | `chsh` menunjuk ke path lama | Cek `which zsh` ulang dan `chsh -s` dengan path baru |

### 10.1 Debugging: Memeriksa Apakah Anda di Login Shell

```bash
# Cara 1: Cek $0
echo $0
# Output: -zsh  → login shell
#         zsh   → non-login shell

# Cara 2: Cek opsi login
[[ -o login ]] && echo "Login shell" || echo "Non-login shell"

# Cara 3: Cek proses
ps -o comm= -p $PPID
```

### 10.2 Memahami File Konfigurasi Zsh

Zsh membaca file konfigurasi dalam urutan berikut (untuk *login shell*):

1. `/etc/zshenv` — selalu dibaca (semua shell)
2. `~/.zshenv` — selalu dibaca (semua shell)
3. `/etc/zprofile` — hanya login shell
4. `~/.zprofile` — hanya login shell
5. `/etc/zshrc` — hanya interactive shell
6. `~/.zshrc` — hanya interactive shell
7. `/etc/zlogin` — hanya login shell
8. `~/.zlogin` — hanya login shell

**Praktik terbaik:**
- Letakkan **environment variable** di `.zshenv` (selalu dibaca)
- Letakkan **alias, prompt, plugin** di `.zshrc` (interactive only)
- Letakkan **PATH tambahan** di `.zprofile` (login only)
- Jangan letakkan **perintah yang memakan waktu** di `.zshenv` — akan memperlambat semua shell

> **Visualisasi diagram alur/struktur [urutan pembacaan file konfigurasi Zsh] akan sangat membantu di sini.**

---

## ✅ Konfirmasi untuk Melanjutkan

Materi **Modul 1.1** telah selesai disajikan secara komprehensif. Saya telah mencakup:

- ✅ Deskripsi konkret & peran dalam kurikulum
- ✅ Konsep kunci & filosofi mendalam (dengan analogi restoran)
- ✅ Sintaks dasar & contoh implementasi (dengan penjelasan kata demi kata)
- ✅ Terminologi esensial (11 istilah dengan definisi dan contoh)
- ✅ Struktur pembelajaran internal (mini daftar isi)
- ✅ Rekomendasi visualisasi
- ✅ Hubungan dengan modul lain
- ✅ Sumber referensi lengkap (10 sumber)
- ✅ Tips dan praktik terbaik
- ✅ Potensi kesalahan umum & solusi
- ✅ Deep Dive: Terminal Emulator Modern & Shell Alternatif

# 📘 MODUL 1.2: NAVIGASI SISTEM FILE DAN PERINTAH DASAR

## 🔍 Audit Singkat Modul 1.2

| Aspek | Status | Catatan |
|---|---|---|
| Judul & cakupan | ✅ Sesuai | Sudah mencakup navigasi, manipulasi, melihat konten, pencarian |
| Konsep path | ✅ Ada | Perlu diperdalam: symlink, hardlink, inode |
| Perintah dasar | ✅ Lengkap | Perlu ditambah: `tree`, `stat`, `file`, `du`, `df` |
| Izin file | ❌ Belum ada | **Rekomendasi tambahan:** `chmod`, `chown`, `umask` |
| Tools modern | ❌ Belum ada | **Rekomendasi tambahan:** `eza`/`exa`, `bat`, `fd`, `zoxide`, `fzf` |
| Studi kasus | ❌ Belum ada | **Rekomendasi tambahan:** studi kasus organisasi proyek |

> **Kesimpulan audit:** Modul 1.2 sudah kuat sebagai fondasi, tetapi untuk menjadi dokumentasi pembelajaran yang komprehensif, perlu ditambahkan materi tentang **izin file**, **symlink/hardlink**, dan **tools modern** yang mempercepat navigasi. Materi tambahan ini akan disajikan sebagai *Deep Dive* tanpa mengubah urutan kurikulum.

---

## 📋 Struktur Pembelajaran Internal (Mini Daftar Isi)

1. Struktur Direktori Unix/Linux — Pohon Terbalik
2. Path Absolut vs Relatif — Navigasi Tanpa Tersesat
3. Perintah Navigasi: `pwd`, `cd`, `ls`
4. Perintah Manipulasi: `mkdir`, `touch`, `cp`, `mv`, `rm`
5. Melihat Konten: `cat`, `less`, `head`, `tail`, `wc`
6. Pencarian File: `find`, `locate`, `which`, `type`
7. Deep Dive: Symlink, Hardlink, dan Inode
8. Deep Dive: Izin File dan Kepemilikan (`chmod`, `chown`, `umask`)
9. Deep Dive: Tools Modern (`eza`, `bat`, `fd`, `zoxide`, `fzf`, `tree`)
10. Studi Kasus: Mengorganisir Proyek dari Nol
11. Debugging, Tips, dan Kesalahan Umum

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah **keterampilan bertahan hidup** di command line. Jika Modul 1.1 menjelaskan *apa* itu shell, Modul 1.2 mengajarkan *bagaimana menggunakan* shell untuk berinteraksi dengan sistem file. Ini adalah fondasi yang harus dikuasai sebelum menulis script apa pun, karena **90% pekerjaan shell adalah membaca, mencari, memindahkan, dan memodifikasi file**.

Dalam konteks kurikulum keseluruhan, Modul 1.2 adalah jembatan antara teori (Modul 1.1) dan manipulasi data (Modul 1.3). Tanpa kemampuan navigasi yang lancar, Anda akan frustrasi saat menulis script karena tidak tahu di mana file berada, bagaimana path bekerja, atau mengapa file tidak ditemukan.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1 Struktur Direktori Unix/Linux — Pohon Terbalik

Sistem file Unix adalah **pohon terbalik** yang dimulai dari root (`/`). Semua file dan direktori berada di bawah root. Tidak ada drive letter seperti di Windows (`C:\`, `D:\`). Jika ada disk tambahan, mereka "dipasang" (mount) ke direktori tertentu di dalam pohon.

```bash
/                           ← Root directory (akar)
├── bin/                    ← Binary essential (ls, cp, mv)
├── boot/                   ← File boot loader
├── dev/                    ← Device files (harddisk, keyboard)
├── etc/                    ← Configuration files
│   ├── passwd              ← Data user
│   ├── shells              ← Daftar shell valid
│   └── zsh/                ← Konfigurasi global Zsh
├── home/                   ← Direktori pengguna
│   ├── budi/               ← Home directory Budi
│   │   ├── .zshrc          ← Konfigurasi Zsh Budi
│   │   ├── dokumen/        ← Dokumen Budi
│   │   └── proyek/         ← Proyek Budi
│   └── siti/               ← Home directory Siti
├── lib/                    ← Shared libraries
├── mnt/                    ← Mount point sementara
├── opt/                    ← Software opsional
├── proc/                   ← Virtual filesystem (info proses)
├── root/                   ← Home directory untuk root
├── sbin/                   ← System binaries (hanya root)
├── tmp/                    ← File sementara
├── usr/                    ← User binaries & data
│   ├── bin/                ← Binary tambahan
│   ├── local/              ← Software yang di-compile sendiri
│   └── share/              ← Shared data
└── var/                    ← Variable data (log, cache)
    ├── log/                ← Log files
    └── tmp/                ← Temporary files
```

**Filosofi Unix:** *"Everything is a file."* — Harddisk, keyboard, proses, network socket, semuanya direpresentasikan sebagai file. Ini menyatukan cara berinteraksi dengan berbagai resource.

> **Visualisasi diagram pohon direktori [Unix File System Hierarchy] akan sangat membantu di sini.**

### 2.2 Path Absolut vs Relatif — Navigasi Tanpa Tersesat

**Path** adalah alamat lokasi file atau direktori. Ada dua jenis:

| Jenis | Definisi | Contoh | Kapan Digunakan |
|---|---|---|---|
| **Absolut** | Dimulai dari root (`/`). Selalu sama, di mana pun Anda berada. | `/home/budi/dokumen/laporan.txt` | Script, konfigurasi, referensi pasti |
| **Relatif** | Dimulai dari direktori saat ini. Berubah tergantung posisi Anda. | `dokumen/laporan.txt` (jika di `/home/budi`) | Navigasi interaktif, perintah sehari-hari |

**Simbol khusus dalam path:**

| Simbol | Arti | Contoh |
|---|---|---|
| `/` | Root directory | `cd /` |
| `~` | Home directory pengguna | `cd ~/proyek` |
| `.` | Direktori saat ini | `cp file.txt .` |
| `..` | Direktori parent (satu level di atas) | `cd ..` |
| `-` | Direktori sebelumnya | `cd -` |

**Contoh pemahaman path:**

```bash
# Misalkan Anda berada di /home/budi/proyek/src
pwd
# Output: /home/budi/proyek/src

# Path absolut
cd /home/budi/dokumen
# Anda sekarang di /home/budi/dokumen

# Path relatif (dari /home/budi/dokumen)
cd ../proyek/src
# .. → /home/budi
# ../proyek → /home/budi/proyek
# ../proyek/src → /home/budi/proyek/src
```

**Filosofi:** Path absolut seperti **alamat lengkap** (Jl. Merdeka No. 10, Jakarta). Path relatif seperti **petunjuk arah** ("dari sini, belok kiri, lalu kanan"). Keduanya berguna tergantung konteks.

---

## 3. Perintah Navigasi: `pwd`, `cd`, `ls`

### 3.1 `pwd` — Print Working Directory

```bash
pwd
# Output: /home/budi/proyek
```

**Penjelasan kata demi kata:**
- `pwd` — *Print Working Directory*. Perintah built-in shell (bukan binary eksternal) untuk menampilkan path absolut direktori saat ini.
- Tidak ada argumen. Hanya menampilkan satu baris.

**Flag opsional:**
- `pwd -P` — menampilkan path fisik (resolve symlink). Berguna jika Anda berada di direktori yang merupakan symlink.
- `pwd -L` — menampilkan path logis (default, menggunakan `$PWD`).

```bash
# Contoh perbedaan -P dan -L
ln -s /home/budi/proyek /home/budi/proyek-link
cd /home/budi/proyek-link
pwd -L    # Output: /home/budi/proyek-link
pwd -P    # Output: /home/budi/proyek
```

### 3.2 `cd` — Change Directory

```bash
cd /var/log            # Pindah ke direktori absolut
cd ~                   # Pindah ke home
cd -                   # Kembali ke direktori sebelumnya
cd ..                  # Naik satu level
cd ../..               # Naik dua level
cd                     # Tanpa argumen = cd ~ (ke home)
```

**Penjelasan kata demi kata:**
- `cd` — *Change Directory*. Mengubah direktori kerja shell saat ini.
- Argumen: path tujuan (absolut atau relatif).
- `cd` tanpa argumen: pindah ke `$HOME`.
- `cd -`: pindah ke `$OLDPWD` (direktori sebelumnya). Shell menyimpan variabel `$OLDPWD`.

**Fitur Zsh yang jarang dibahas:**
- `cd` dengan **autocd** option: Anda bisa mengetik nama direktori tanpa `cd`. Contoh: `proyek` (jika ada direktori `proyek`) akan otomatis `cd proyek`.
- `cd` completion: Tekan Tab setelah `cd` untuk melihat daftar direktori.
- `cd` dengan **named directories**: `cd ~proyek` jika Anda mendefinisikan `hash -d proyek=/home/budi/proyek`.

```bash
# Aktifkan autocd di .zshrc
setopt autocd

# Setelah itu, cukup ketik:
/var/log    # Otomatis cd ke /var/log
```

### 3.3 `ls` — List

```bash
ls                     # Daftar file di direktori saat ini
ls -la                 # Daftar semua file (termasuk hidden) dengan detail
ls -lh                 # Detail dengan ukuran human-readable
ls -lt                 # Urutkan berdasarkan waktu modifikasi (terbaru dulu)
ls -lS                 # Urutkan berdasarkan ukuran (terbesar dulu)
ls -R                  # Rekursif (tampilkan subdirektori)
ls *.txt               # Hanya file .txt (glob)
ls -d */               # Hanya direktori
```

**Penjelasan kata demi kata:**
- `ls` — *List*. Menampilkan isi direktori.
- `-l` — *Long format*. Menampilkan detail: permission, owner, group, size, timestamp, nama.
- `-a` — *All*. Menampilkan file hidden (dimulai dengan `.`).
- `-h` — *Human-readable*. Ukuran dalam KB, MB, GB.
- `-t` — *Time*. Urutkan berdasarkan waktu modifikasi.
- `-S` — *Size*. Urutkan berdasarkan ukuran.
- `-R` — *Recursive*. Tampilkan subdirektori secara rekursif.
- `-d` — *Directory*. Tampilkan direktori itu sendiri, bukan isinya.
- `*/` — glob yang cocok dengan semua direktori.

**Output `ls -la` dan artinya:**

```bash
drwxr-xr-x  5 budi budi 4096 Jan 10 10:30 proyek
-rw-r--r--  1 budi budi  220 Jan 10 09:15 .zshrc
lrwxrwxrwx  1 budi budi   12 Jan 10 08:00 link -> /home/budi/proyek
```

| Kolom | Arti |
|---|---|
| `d` / `-` / `l` | Tipe file: direktori, file biasa, symlink |
| `rwxr-xr-x` | Permission: owner, group, others |
| `5` | Jumlah hardlink |
| `budi` | Owner |
| `budi` | Group |
| `4096` | Ukuran dalam byte |
| `Jan 10 10:30` | Waktu modifikasi terakhir |
| `proyek` | Nama file/direktori |

> **Visualisasi diagram [anatomi output ls -la] akan sangat membantu di sini.**

---

## 4. Perintah Manipulasi: `mkdir`, `touch`, `cp`, `mv`, `rm`

### 4.1 `mkdir` — Make Directory

```bash
mkdir proyek                   # Membuat satu direktori
mkdir -p proyek/src/components # Membuat direktori bersarang
mkdir -m 755 publik            # Membuat dengan permission tertentu
```

**Penjelasan kata demi kata:**
- `mkdir` — *Make Directory*.
- `-p` — *Parents*. Membuat direktori parent jika belum ada. Tanpa `-p`, `mkdir proyek/src` akan gagal jika `proyek` belum ada.
- `-m` — *Mode*. Menentukan permission awal (default: 755 dimodifikasi oleh umask).

### 4.2 `touch` — Membuat File Kosong / Update Timestamp

```bash
touch file.txt                 # Membuat file kosong
touch file1.txt file2.txt      # Membuat beberapa file sekaligus
touch -t 202501100830 file.txt # Set timestamp spesifik
```

**Penjelasan:**
- `touch` — jika file belum ada, buat kosong. Jika sudah ada, update timestamp akses dan modifikasi.
- `-t` — *Time*. Format: `[[CC]YY]MMDDhhmm[.ss]`.

### 4.3 `cp` — Copy

```bash
cp file.txt backup.txt         # Copy file
cp -r proyek proyek-backup     # Copy direktori rekursif
cp -i file.txt tujuan/         # Copy dengan konfirmasi jika overwrite
cp -u file.txt tujuan/         # Copy hanya jika source lebih baru
cp -v file.txt tujuan/         # Verbose (tampilkan proses)
cp file.txt {1,2,3}.txt        # Brace expansion: file1.txt, file2.txt, file3.txt
```

**Penjelasan kata demi kata:**
- `cp` — *Copy*.
- `-r` — *Recursive*. Wajib untuk direktori.
- `-i` — *Interactive*. Minta konfirmasi sebelum overwrite.
- `-u` — *Update*. Copy hanya jika source lebih baru dari destination.
- `-v` — *Verbose*. Tampilkan file yang sedang di-copy.
- `{1,2,3}` — **brace expansion** Zsh: menghasilkan `1 2 3`.

### 4.4 `mv` — Move / Rename

```bash
mv file.txt arsip/             # Pindah ke direktori arsip
mv file.txt nama-baru.txt      # Rename
mv -i file.txt tujuan/         # Konfirmasi jika overwrite
mv -v file.txt tujuan/         # Verbose
mv -n file.txt tujuan/         # No-clobber (jangan overwrite)
```

**Penjelasan:**
- `mv` — *Move*. Jika destination adalah direktori, file dipindahkan. Jika destination adalah nama file, file di-rename.
- `-i` — Interactive.
- `-n` — No-clobber. Jangan overwrite file yang sudah ada.
- `-v` — Verbose.

### 4.5 `rm` — Remove

```bash
rm file.txt                    # Hapus file
rm -i file.txt                 # Hapus dengan konfirmasi
rm -r proyek/                  # Hapus direktori rekursif
rm -rf proyek/                 # Hapus paksa tanpa konfirmasi (HATI-HATI!)
rm -v file.txt                 # Verbose
```

**Penjelasan kata demi kata:**
- `rm` — *Remove*.
- `-i` — Interactive. **Selalu gunakan ini untuk pemula.**
- `-r` — Recursive. Untuk direktori.
- `-f` — Force. Abaikan file yang tidak ada, tidak ada konfirmasi. **Sangat berbahaya.**
- `-v` — Verbose.

**Peringatan:** `rm -rf /` akan menghapus seluruh sistem. Jangan pernah menjalankan `rm -rf` dengan wildcard yang tidak jelas. Selalu periksa dengan `ls` terlebih dahulu.

---

## 5. Melihat Konten: `cat`, `less`, `head`, `tail`, `wc`

### 5.1 `cat` — Concatenate

```bash
cat file.txt                   # Tampilkan seluruh konten
cat file1.txt file2.txt        # Gabungkan dan tampilkan
cat -n file.txt                # Tampilkan dengan nomor baris
cat > file.txt                 # Tulis dari stdin (Ctrl+D untuk selesai)
cat file.txt | grep "error"    # Pipe ke grep
```

**Penjelasan:**
- `cat` — *Concatenate*. Menampilkan isi file ke stdout.
- `-n` — Number. Beri nomor baris.
- `>` — Redirection. Menulis output ke file (overwrite).
- `>>` — Append. Menambah ke akhir file.

### 5.2 `less` — Pager

```bash
less file.txt                  # Buka file dengan navigasi
less +F log.txt                # Mode follow (seperti tail -f)
```

**Navigasi dalam `less`:**
- `Space` / `Page Down` — halaman berikutnya
- `b` / `Page Up` — halaman sebelumnya
- `/pattern` — cari ke bawah
- `?pattern` — cari ke atas
- `n` — next match
- `N` — previous match
- `g` — ke awal file
- `G` — ke akhir file
- `q` — keluar

**Mengapa `less` lebih baik dari `cat`?** `cat` menampilkan seluruh file sekaligus, membanjiri terminal. `less` memungkinkan navigasi, pencarian, dan tidak memuat seluruh file ke memory (efisien untuk file besar).

### 5.3 `head` dan `tail`

```bash
head file.txt                  # 10 baris pertama (default)
head -5 file.txt               # 5 baris pertama
head -n 20 file.txt            # 20 baris pertama
tail file.txt                  # 10 baris terakhir
tail -f log.txt                # Ikuti file yang terus diperbarui
tail -n +5 file.txt            # Mulai dari baris ke-5 sampai akhir
```

**Penjelasan:**
- `head` — menampilkan bagian awal file.
- `tail` — menampilkan bagian akhir file.
- `-f` — *Follow*. Tetap buka file dan tampilkan baris baru saat ditambahkan. Berguna untuk memantau log.
- `-n +5` — mulai dari baris ke-5.

### 5.4 `wc` — Word Count

```bash
wc file.txt                    # Baris, kata, karakter
wc -l file.txt                 # Hanya baris
wc -w file.txt                 # Hanya kata
wc -c file.txt                 # Hanya byte
wc -m file.txt                 # Hanya karakter (unicode-aware)
```

---

## 6. Pencarian File: `find`, `locate`, `which`, `type`

### 6.1 `find` — Pencarian Rekursif

```bash
find . -name "*.txt"                   # Cari file .txt di direktori saat ini
find /var/log -name "*.log" -mtime -7  # Log yang dimodifikasi 7 hari terakhir
find . -type d -name "src"             # Cari direktori bernama src
find . -type f -size +1M               # File lebih besar dari 1MB
find . -name "*.tmp" -delete           # Hapus file .tmp (HATI-HATI)
find . -name "*.txt" -exec grep -l "error" {} \;  # Cari file .txt yang mengandung "error"
```

**Penjelasan kata demi kata:**
- `find` — perintah pencarian rekursif.
- `.` — mulai dari direktori saat ini.
- `-name "*.txt"` — cocokkan nama file dengan pola glob.
- `-type f` — hanya file biasa. `-type d` — hanya direktori. `-type l` — symlink.
- `-mtime -7` — modified time kurang dari 7 hari yang lalu.
- `-size +1M` — ukuran lebih dari 1 megabyte.
- `-exec command {} \;` — jalankan command untuk setiap hasil. `{}` adalah placeholder untuk nama file. `\;` mengakhiri perintah.
- `-delete` — hapus file yang cocok.

**Alur kerja `find`:**

```bash
Mulai dari direktori awal
        │
        ▼
┌───────────────────┐
│ Baca setiap entry │
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│ Cocokkan dengan   │
│ kriteria (name,   │
│ type, size, time) │
└────────┬──────────┘
         │
    ┌────┴────┐
    │ Cocok?  │
    └────┬────┘
     Ya  │  Tidak
    ┌────┘    └────┐
    ▼              ▼
┌────────┐    ┌──────────┐
│ Tampil │    │ Lanjut ke│
│ / exec │    │ entry    │
└────────┘    │ berikut  │
              └──────────┘
```

> **Visualisasi diagram alur [find workflow] akan sangat membantu di sini.**

### 6.2 `locate` — Pencarian Cepat Berbasis Database

```bash
locate file.txt                # Cari file.txt di seluruh sistem
sudo updatedb                  # Update database locate (perlu root)
```

**Penjelasan:**
- `locate` — mencari di database yang di-update secara berkala (biasanya harian). Jauh lebih cepat dari `find`, tetapi hasilnya mungkin tidak terbaru.
- `updatedb` — memperbarui database. Di macOS: `sudo /usr/libexec/locate.updatedb`.

### 6.3 `which` dan `type`

```bash
which zsh                      # Path binary zsh
which -a python                # Semua path python di $PATH
type ls                        # Apakah ls alias, builtin, atau binary?
type -a ls                     # Semua definisi ls
```

**Penjelasan:**
- `which` — mencari executable di `$PATH`. Tidak mendeteksi alias atau builtin.
- `type` — lebih komprehensif: mendeteksi alias, fungsi, builtin, dan binary.
- `-a` — tampilkan semua kemungkinan.

**Contoh perbedaan:**
```bash
alias ll='ls -la'
which ll        # Output: ll: aliased to ls -la (di Zsh)
type ll         # Output: ll is an alias for ls -la
```

---

## 7. Deep Dive: Symlink, Hardlink, dan Inode

*(Tambahan di luar kurikulum — penting untuk pemahaman sistem file)*

### 7.1 Inode

**Inode** adalah struktur data yang menyimpan metadata file: permission, owner, group, ukuran, timestamp, dan pointer ke blok data. Nama file sebenarnya hanyalah entri di direktori yang menunjuk ke inode.

```bash
ls -i file.txt                 # Tampilkan inode number
stat file.txt                  # Detail lengkap inode
```

### 7.2 Hardlink

**Hardlink** adalah nama tambahan untuk inode yang sama. Menghapus satu hardlink tidak menghapus data selama masih ada hardlink lain.

```bash
ln file.txt hardlink.txt       # Buat hardlink
ls -li file.txt hardlink.txt   # Kedua file punya inode number sama
```

### 7.3 Symlink (Softlink)

**Symlink** adalah file khusus yang berisi path ke file lain. Seperti "shortcut" di Windows.

```bash
ln -s /home/budi/proyek link-proyek  # Buat symlink
ls -la link-proyek                    # Output: link-proyek -> /home/budi/proyek
readlink link-proyek                  # Baca target symlink
```

**Perbedaan Hardlink vs Symlink:**

| Aspek | Hardlink | Symlink |
|---|---|---|
| Inode | Sama | Berbeda |
| Target | Tidak bisa lintas filesystem | Bisa lintas filesystem |
| Target dihapus | Data tetap ada | Symlink rusak (broken) |
| Direktori | Tidak bisa | Bisa |

---

## 8. Deep Dive: Izin File dan Kepemilikan (`chmod`, `chown`, `umask`)

*(Tambahan di luar kurikulum — krusial untuk keamanan dan kolaborasi)*

### 8.1 Permission Dasar

Setiap file memiliki 3 set permission: **owner**, **group**, **others**. Setiap set memiliki **read (r)**, **write (w)**, **execute (x)**.

```bash
rwx r-x r-x
│   │   │
│   │   └── others: read + execute
│   └────── group: read + execute
└────────── owner: read + write + execute
```

**Nilai numerik:**
- `r` = 4
- `w` = 2
- `x` = 1

Jadi `rwxr-xr-x` = 755 (7=4+2+1, 5=4+1, 5=4+1).

### 8.2 `chmod` — Change Mode

```bash
chmod 755 script.sh            # Numerik: rwxr-xr-x
chmod +x script.sh             # Tambah execute untuk semua
chmod u+x script.sh            # Tambah execute hanya untuk owner
chmod go-w file.txt            # Hapus write untuk group dan others
chmod -R 644 proyek/           # Rekursif
```

**Penjelasan:**
- `chmod` — *Change Mode*.
- `u` — user/owner, `g` — group, `o` — others, `a` — all.
- `+` — tambah, `-` — hapus, `=` — set tepat.
- `-R` — recursive.

### 8.3 `chown` — Change Owner

```bash
sudo chown budi file.txt               # Ganti owner ke budi
sudo chown budi:siti file.txt          # Ganti owner dan group
sudo chown -R budi:budi proyek/        # Rekursif
```

### 8.4 `umask` — Default Permission

`umask` menentukan permission default untuk file dan direktori baru. Nilai default biasanya `022`.

```bash
umask                          # Tampilkan umask saat ini
umask 027                      # Set umask
```

**Cara kerja:** Permission default = `777` (direktori) atau `666` (file) dikurangi umask.
- File baru: `666 - 022 = 644` (rw-r--r--)
- Direktori baru: `777 - 022 = 755` (rwxr-xr-x)

---

## 9. Deep Dive: Tools Modern

*(Tambahan di luar kurikulum — mempercepat navigasi dan meningkatkan pengalaman)*

| Tool | Pengganti | Kelebihan | Instalasi |
|---|---|---|---|
| **eza** / **exa** | `ls` | Warna, ikon, git status, tree view | `brew install eza` / `cargo install eza` |
| **bat** | `cat` | Syntax highlighting, line numbers, git diff | `brew install bat` |
| **fd** | `find` | Sintaks lebih sederhana, cepat, ignore .gitignore | `brew install fd` |
| **zoxide** | `cd` | Smart cd, belajar dari kebiasaan | `brew install zoxide` |
| **fzf** | - | Fuzzy finder untuk file, history, proses | `brew install fzf` |
| **tree** | `ls -R` | Tampilan pohon direktori | `brew install tree` |
| **ripgrep** (`rg`) | `grep` | Pencarian teks super cepat | `brew install ripgrep` |

**Contoh penggunaan:**

```bash
# eza: ls modern
eza --icons --git --tree --level=2

# bat: cat dengan syntax highlighting
bat script.sh

# fd: find modern
fd "\.txt$"                    # Cari file .txt
fd -e txt                      # Ekstensi txt
fd -t d src                    # Cari direktori bernama src

# zoxide: cd pintar
z proyek                       # Lompat ke direktori yang paling sering dikunjungi
z src                          # Lompat ke src terdekat

# fzf: fuzzy finder
vim $(fzf)                     # Pilih file dengan fzf, buka di vim
Ctrl+R                         # Fuzzy search history (setelah setup)
```

**Integrasi dengan Zsh (`~/.zshrc`):**

```bash
# zoxide
eval "$(zoxide init zsh)"

# fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# alias
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --git'
alias cat='bat'
alias find='fd'
alias grep='rg'
```

---

## 10. Studi Kasus: Mengorganisir Proyek dari Nol

**Skenario:** Anda baru menerima proyek web dengan struktur berantakan. Anda perlu merapikan, mencari file, dan memindahkan ke struktur yang benar.

```bash
# 1. Lihat struktur saat ini
pwd
ls -la

# 2. Buat struktur direktori yang diinginkan
mkdir -p proyek/{src/{components,utils,styles},public,test,docs}

# 3. Pindahkan file ke lokasi yang benar
mv *.js proyek/src/
mv *.css proyek/src/styles/
mv *.html proyek/public/
mv *.md proyek/docs/

# 4. Cari file yang tersisa dan belum terorganisir
find . -maxdepth 1 -type f -name "*.txt" -exec mv {} proyek/docs/ \;

# 5. Cari file besar yang mungkin perlu dioptimasi
find proyek -type f -size +500k -exec ls -lh {} \;

# 6. Cari file yang mengandung "TODO"
rg "TODO" proyek/

# 7. Buat backup sebelum kompresi
tar -czf proyek-backup-$(date +%Y%m%d).tar.gz proyek/

# 8. Verifikasi struktur
tree proyek/ -L 2
```

**Penjelasan:**
- `mkdir -p proyek/{src/{components,utils,styles},public,test,docs}` — brace expansion bersarang membuat seluruh struktur dalam satu perintah.
- `find . -maxdepth 1 -type f -name "*.txt" -exec mv {} proyek/docs/ \;` — mencari file .txt hanya di level teratas, lalu memindahkan.
- `tar -czf` — membuat arsip terkompresi. `-c` create, `-z` gzip, `-f` file.

---

## 11. Terminologi Esensial & Penjelasan Detail

| Istilah | Definisi | Contoh |
|---|---|---|
| **Root Directory** | Direktori tertinggi dalam pohon filesystem. | `/` |
| **Home Directory** | Direktori pribadi pengguna. | `/home/budi` atau `~` |
| **Current Working Directory** | Direktori tempat shell berada saat ini. | Output `pwd` |
| **Parent Directory** | Direktori satu level di atas. | `..` |
| **Path Absolut** | Path lengkap dari root. | `/home/budi/file.txt` |
| **Path Relatif** | Path dari direktori saat ini. | `dokumen/file.txt` |
| **Hidden File** | File yang dimulai dengan `.`. | `.zshrc`, `.gitignore` |
| **Wildcard/Glob** | Pola untuk mencocokkan nama file. | `*.txt`, `file?.txt` |
| **Inode** | Struktur data yang menyimpan metadata file. | `ls -i` |
| **Hardlink** | Nama tambahan untuk inode yang sama. | `ln file hardlink` |
| **Symlink** | File yang menunjuk ke path file lain. | `ln -s target link` |
| **Permission** | Hak akses file: read, write, execute. | `rwxr-xr-x` |
| **Owner** | Pengguna yang memiliki file. | `budi` |
| **Group** | Grup pengguna yang memiliki akses. | `staff`, `sudo` |
| **Umask** | Mask yang menentukan permission default. | `022` |
| **Pipe** | Menghubungkan stdout ke stdin perintah lain. | `ls | grep txt` |
| **Redirection** | Mengarahkan stdout/stdin ke file. | `>`, `>>`, `<` |
| **Stdin** | Standard input (biasanya keyboard). | FD 0 |
| **Stdout** | Standard output (biasanya terminal). | FD 1 |
| **Stderr** | Standard error (biasanya terminal). | FD 2 |
| **File Descriptor** | Angka yang merepresentasikan file/socket terbuka. | 0, 1, 2 |
| **Mount** | Menempelkan filesystem ke direktori. | `/mnt/usb` |
| **Filesystem** | Sistem yang mengatur penyimpanan data. | ext4, APFS, NTFS |

**Penjelasan tambahan:**
- **Glob vs Regex:** Glob digunakan untuk mencocokkan nama file (`*.txt`), regex untuk mencocokkan pola teks (`^error.*$`). Glob lebih sederhana, regex lebih powerful.
- **Pipe vs Redirection:** Pipe (`|`) menghubungkan antar perintah. Redirection (`>`) menghubungkan perintah dengan file.
- **Stdin, Stdout, Stderr:** Tiga stream standar. `2>` untuk redirect stderr. `&>` untuk redirect keduanya.

---

## 12. Hubungan dengan Modul Lain

| Modul | Hubungan |
|---|---|
| **Modul 1.1 (Shell & Zsh)** | Navigasi adalah *praktik* dari teori shell. `cd`, `ls`, `pwd` adalah builtin atau binary yang dijalankan oleh shell. |
| **Modul 1.3 (Variabel & Ekspansi)** | Path sering menggunakan variabel (`$HOME`, `$PWD`). Glob dan ekspansi parameter akan sering digunakan bersama navigasi. |
| **Fase 2 (Scripting)** | Script hampir selalu berinteraksi dengan file: membaca, menulis, memindahkan. Navigasi yang lancar adalah prasyarat. |
| **Fase 3 (Plugin & Konfigurasi)** | Konfigurasi Zsh (`.zshrc`, `.zprofile`) adalah file yang perlu dinavigasi dan diedit. |

---

## 13. Sumber Referensi Lengkap

| Sumber | URL | Deskripsi |
|---|---|---|
| **GNU Coreutils Manual** | https://www.gnu.org/software/coreutils/manual/ | Manual resmi untuk `ls`, `cp`, `mv`, `rm`, `mkdir`, `cat`, `head`, `tail`, `wc` |
| **Linux Command Line** | https://linuxcommand.org/ | Tutorial command line gratis dan komprehensif |
| **The Linux Command Line (Book)** | https://linuxcommand.org/tlcl.php | Buku gratis oleh William Shotts |
| **Zsh Manual — Expansion** | https://zsh.sourceforge.io/Doc/Release/Expansion.html | Detail globbing dan ekspansi Zsh |
| **Zsh Manual — Options** | https://zsh.sourceforge.io/Doc/Release/Options.html | Opsi Zsh termasuk `autocd`, `globdots` |
| **man7.org — Path** | https://man7.org/linux/man-pages/man7/path_resolution.7.html | Resolusi path di Linux |
| **man7.org — Inode** | https://man7.org/linux/man-pages/man7/inode.7.html | Detail inode |
| **eza Documentation** | https://eza.rocks/ | Dokumentasi eza (ls modern) |
| **bat GitHub** | https://github.com/sharkdp/bat | Dokumentasi bat |
| **fd GitHub** | https://github.com/sharkdp/fd | Dokumentasi fd |
| **zoxide GitHub** | https://github.com/ajeetdsouza/zoxide | Dokumentasi zoxide |
| **fzf GitHub** | https://github.com/junegunn/fzf | Dokumentasi fzf |
| **ripgrep GitHub** | https://github.com/BurntSushi/ripgrep | Dokumentasi ripgrep |
| **tldp.org — File Permissions** | https://tldp.org/LDP/abs/html/permissions.html | Penjelasan permission di Bash |
| **Ubuntu File Permissions** | https://help.ubuntu.com/community/FilePermissions | Panduan permission Ubuntu |

---

## 14. Tips dan Praktik Terbaik

### 14.1 Navigasi

- Gunakan `cd -` untuk kembali ke direktori sebelumnya.
- Aktifkan `autocd` di Zsh untuk navigasi tanpa `cd`.
- Gunakan `zoxide` (`z`) untuk lompat cepat ke direktori yang sering dikunjungi.
- Manfaatkan Tab completion untuk path — jangan ketik manual.

### 14.2 Manipulasi File

- Selalu gunakan `cp -i` dan `mv -i` untuk menghindari overwrite tidak sengaja.
- Sebelum `rm -rf`, periksa dengan `ls` atau `find` terlebih dahulu.
- Gunakan `trash-cli` (jika tersedia) sebagai pengganti `rm` untuk keamanan.
- Untuk file penting, buat backup sebelum modifikasi.

### 14.3 Pencarian

- Gunakan `fd` daripada `find` untuk sintaks yang lebih sederhana.
- Gunakan `rg` (ripgrep) daripada `grep` untuk pencarian teks cepat.
- `locate` lebih cepat dari `find` tetapi database perlu di-update.

### 14.4 Permission

- Jangan gunakan `chmod 777` sebagai solusi cepat — itu membuka akses ke semua orang.
- Gunakan `chmod 755` untuk direktori, `644` untuk file.
- Pahami `umask` untuk permission default yang aman.

### 14.5 Umum

- Biasakan membaca `man` page: `man ls`, `man find`.
- Gunakan `--help` untuk ringkasan cepat: `ls --help`.
- Gunakan `alias` untuk perintah yang sering diketik.
- Integrasikan tools modern secara bertahap — jangan sekaligus.

---

## 15. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| **`cd: no such file or directory`** | Path salah atau tidak ada | Cek dengan `ls` terlebih dahulu, gunakan Tab completion |
| **Spasi dalam nama file** | `mv file baru.txt` dianggap dua argumen | Quote: `mv "file baru.txt" tujuan/` atau escape: `mv file\ baru.txt tujuan/` |
| **`rm -rf` tidak sengaja** | Wildcard terlalu luas | Selalu `ls` dulu, gunakan `rm -i`, atau `trash-cli` |
| **Overwrite file tanpa sadar** | `cp` dan `mv` default overwrite | Gunakan `-i` atau `-n` |
| **Permission denied** | Tidak punya izin | Cek `ls -l`, gunakan `sudo` jika perlu, atau `chmod` |
| **Symlink rusak** | Target dihapus | `readlink` untuk cek target, buat ulang |
| **`find` terlalu lama** | Mulai dari `/` | Batasi direktori awal, gunakan `-maxdepth` |
| **Glob tidak cocok** | Tidak ada file yang cocok | Cek dengan `echo *.txt` sebelum digunakan |
| **`which` tidak menemukan** | Binary tidak di `$PATH` | Cek `echo $PATH`, gunakan path absolut |
| **File hidden tidak terlihat** | `ls` tanpa `-a` | Gunakan `ls -la` |

### 15.1 Debugging: Melacak Path

```bash
# Tampilkan path absolut dari file
realpath file.txt
# atau
readlink -f file.txt

# Cek apakah file ada
[[ -f file.txt ]] && echo "Ada" || echo "Tidak ada"

# Cek tipe file
file file.txt

# Cek statistik file
stat file.txt
```

---

## ✅ Konfirmasi untuk Melanjutkan

Materi **Modul 1.2** telah selesai disajikan secara komprehensif. Saya telah mencakup:

- ✅ Deskripsi konkret & peran dalam kurikulum
- ✅ Konsep kunci & filosofi (pohon terbalik, path, permission)
- ✅ Sintaks dasar & contoh implementasi (dengan penjelasan kata demi kata)
- ✅ Terminologi esensial (23 istilah)
- ✅ Struktur pembelajaran internal (mini daftar isi)
- ✅ Rekomendasi visualisasi (diagram pohon, alur find, anatomi ls)
- ✅ Hubungan dengan modul lain
- ✅ Sumber referensi lengkap (15 sumber)
- ✅ Tips dan praktik terbaik
- ✅ Potensi kesalahan umum & solusi
- ✅ Deep Dive: Symlink/Hardlink, Permission, Tools Modern
- ✅ Studi kasus: Mengorganisir proyek

# 📘 MODUL 1.3: VARIABEL, QUOTING, DAN EKSPANSI

## 🔍 Audit Singkat Modul 1.3

| Aspek | Status | Catatan |
|---|---|---|
| Judul & cakupan | ✅ Sesuai | Variabel, quoting, ekspansi sudah tercakup |
| Command substitution | ✅ Ada | Perlu diperdalam: `$(...)` vs backtick, nesting |
| Parameter expansion | ✅ Ada | Perlu ditambah: `${var:-default}`, `${var:=}`, `${var:?}`, `${var:+}` |
| Array | ✅ Ada | Perlu diperdalam: slicing, filtering, sorting, `(f)`, `(o)`, `(j)` flags |
| Associative array | ✅ Ada | Perlu contoh lengkap dengan iterasi |
| Arithmetic expansion | ❌ Belum ada | **Rekomendasi tambahan:** `$((...))`, `((...))`, operator aritmatika |
| Brace expansion | ❌ Belum ada | **Rekomendasi tambahan:** `{a,b,c}`, `{1..10}`, `{01..10}` |
| Proses substitusi | ❌ Belum ada | **Rekomendasi tambahan:** `<(command)`, `>(command)` |
| Special variables | ❌ Belum ada | **Rekomendasi tambahan:** `$?`, `$$`, `$!`, `$#`, `$@`, `$*` |
| Quoting lanjutan | ❌ Belum ada | **Rekomendasi tambahan:** `$'...'` (ANSI-C), `${(q)}`, `${(qq)}` |

> **Kesimpulan audit:** Modul 1.3 adalah modul **paling kritis** dalam Fase 1. Di sinilah kebanyakan pemula mengalami kebingungan terbesar. Modul ini perlu diperluas dengan **arithmetic expansion**, **brace expansion**, **proses substitusi**, **special variables**, dan **quoting lanjutan** agar benar-benar komprehensif.

---

## 📋 Struktur Pembelajaran Internal (Mini Daftar Isi)

1. Variabel di Shell — Untyped, Dinamis, dan Sederhana
2. Mendeklarasikan dan Menggunakan Variabel
3. Quoting: Single, Double, Backslash, dan ANSI-C
4. Command Substitution: `$(...)` vs Backtick
5. Arithmetic Expansion: `$((...))` dan `((...))`
6. Brace Expansion: `{a,b,c}`, `{1..10}`, `{01..10}`
7. Parameter Expansion: Default, Assign, Error, Alternate
8. Array di Zsh: 1-Indexed, Slicing, Filtering, Sorting
9. Associative Array: Hash Map di Shell
10. Special Variables: `$?`, `$$`, `$!`, `$#`, `$@`, `$*`, `$0`, `$_`
11. Deep Dive: Quoting Lanjutan (`$'...'`, `${(q)}`, `${(qq)}`)
12. Deep Dive: Proses Substitusi (`<(command)`, `>(command)`)
13. Deep Dive: Ekspansi Zsh Lanjutan (`(f)`, `(o)`, `(j)`, `(k)`, `(v)`)
14. Debugging, Tips, dan Kesalahan Umum

---

## 1. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah **jantung dari pemrograman shell**. Jika Modul 1.1 menjelaskan *apa* itu shell dan Modul 1.2 mengajarkan *navigasi*, Modul 1.3 mengajarkan *bagaimana memanipulasi data* di dalam shell. Variabel adalah cara menyimpan nilai, quoting adalah cara mengontrol interpretasi, dan ekspansi adalah cara mengubah teks menjadi nilai yang bermakna.

Dalam konteks kurikulum keseluruhan, Modul 1.3 adalah **prasyarat mutlak** untuk Fase 2 (Scripting). Tanpa pemahaman yang kuat tentang quoting dan ekspansi, script Anda akan penuh dengan bug yang sulit dilacak: spasi yang tidak diinginkan, variabel yang tidak terdefinisi, glob yang tidak sengaja, dan sebagainya.

**Mengapa modul ini sulit?** Karena shell adalah bahasa *untyped* — semuanya string — dan shell melakukan *banyak* ekspansi secara implisit. Pemula sering bingung: "Kapan shell mengganti `$var`? Kapan ia membiarkannya literal? Kapan spasi menjadi pemisah argumen?" Modul ini menjawab semua pertanyaan itu.

---

## 2. Konsep Kunci & Filosofi Mendalam

### 2.1 Shell adalah Bahasa Untyped

Di bahasa seperti C, Java, atau Python, variabel memiliki tipe: integer, string, float, boolean. Di shell, **semuanya adalah string** sampai diproses lebih lanjut. Tidak ada deklarasi tipe.

```bash
# Semua ini valid di shell
x=42
y="hello"
z=3.14
w="true"

# Tidak ada tipe. Anda bisa mengubah "tipe" kapan saja:
x="sekarang saya string"
```

**Filosofi:** Shell bukan bahasa pemrograman umum. Ia adalah *command interpreter* yang kebetulan memiliki fitur pemrograman. Kesederhanaan ini adalah kekuatan sekaligus kelemahan: mudah dipelajari, tetapi mudah pula membuat kesalahan.

### 2.2 Ekspansi adalah Proses Multi-Tahap

Ketika Anda mengetik perintah dan menekan Enter, shell melakukan **banyak ekspansi** secara berurutan. Urutan ini penting dan sering menjadi sumber kebingungan.

```bash
Input mentah: echo "Halo $nama, hari ini $(date +%A), file: *.txt"
       │
       ▼
┌──────────────────────────────────────────────────────────────┐
│ TAHAP 1: Tokenisasi                                          │
│ Memecah input menjadi token:                                 │
│["echo", "\"Halo $nama, hari ini $(date +%A), file: *.txt\""] │
└──────────────────────────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│ TAHAP 2: Brace Expansion                                    │
│ {a,b,c} → a b c                                             │
│ {1..5} → 1 2 3 4 5                                          │
│ (Tidak ada dalam contoh ini)                                │
└─────────────────────────────────────────────────────────────┘
       │
       ▼
┌──────────────────────────────────────────────────────────────┐
│ TAHAP 3: Tilde Expansion                                     │
│ ~ → /home/budi                                               │
│ ~user → /home/user                                           │
│ (Tidak ada dalam contoh ini)                                 │
└──────────────────────────────────────────────────────────────┘
       │
       ▼
┌──────────────────────────────────────────────────────────────┐
│ TAHAP 4: Parameter Expansion                                 │
│ $nama → "Budi"                                               │
│ ${var:-default} → nilai atau default                         │
│ Hasil: "Halo Budi, hari ini $(date +%A), file: *.txt"        │
└──────────────────────────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│ TAHAP 5: Command Substitution                               │
│ $(date +%A) → "Jumat"                                       │
│ Hasil: "Halo Budi, hari ini Jumat, file: *.txt"             │
└─────────────────────────────────────────────────────────────┘
       │
       ▼
┌──────────────────────────────────────────────────────────────┐
│ TAHAP 6: Arithmetic Expansion                                │
│ $((2+3)) → 5                                                 │
│ (Tidak ada dalam contoh ini)                                 │
└──────────────────────────────────────────────────────────────┘
       │
       ▼
┌──────────────────────────────────────────────────────────────┐
│ TAHAP 7: Word Splitting                                      │
│ Memecah hasil berdasarkan IFS (Internal Field Separator)     │
│ Hanya terjadi pada ekspansi yang TIDAK di-quote              │
│ Dalam contoh ini, seluruh string di-quote, jadi tidak dipecah│
└──────────────────────────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│ TAHAP 8: Filename Expansion (Globbing)                      │
│ *.txt → daftar file .txt                                    │
│ Hanya terjadi pada ekspansi yang TIDAK di-quote             │
│ Dalam contoh ini, *.txt ada di dalam double quote, jadi     │
│ TIDAK di-glob (tetap literal "*.txt")                       │
└─────────────────────────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│ TAHAP 9: Quote Removal                                      │
│ Menghapus quote yang tersisa                                │
│ Hasil akhir: Halo Budi, hari ini Jumat, file: *.txt         │
└─────────────────────────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│ EKSEKUSI: echo "Halo Budi, hari ini Jumat, file: *.txt"     │
└─────────────────────────────────────────────────────────────┘
```

> **Visualisasi diagram alur [urutan ekspansi shell dari tokenisasi hingga eksekusi] akan sangat membantu di sini.**

**Poin kunci:** Urutan ekspansi menentukan hasil akhir. Memahami urutan ini adalah kunci untuk memprediksi perilaku shell.

### 2.3 Quoting: Mengontrol Ekspansi

Quoting adalah **mekanisme untuk mencegah ekspansi**. Ada beberapa jenis quoting, masing-masing dengan perilaku berbeda:

| Jenis | Simbol | Ekspansi Parameter | Command Sub | Arithmetic | Glob | Spasi |
|---|---|---|---|---|---|---|
| **Single Quote** | `'...'` | ❌ | ❌ | ❌ | ❌ | Literal |
| **Double Quote** | `"..."` | ✅ | ✅ | ✅ | ❌ | Literal |
| **Backslash** | `\x` | ❌ | ❌ | ❌ | ❌ | Literal |
| **ANSI-C** | `$'...'` | ❌ | ❌ | ❌ | ❌ | Escape sequence |
| **Tanpa Quote** | `...` | ✅ | ✅ | ✅ | ✅ | Word split |

**Filosofi quoting:** *"Quote everything you don't want the shell to touch."* — Jika Anda ingin shell memperlakukan sesuatu sebagai literal, quote-lah. Jika Anda ingin shell memprosesnya, biarkan tanpa quote.

### 2.4 Variabel vs Environment Variable

| Aspek | Variabel Shell | Environment Variable |
|---|---|---|
| **Scope** | Hanya shell saat ini | Shell dan child process |
| **Deklarasi** | `nama="Budi"` | `export nama="Budi"` |
| **Warisan** | Tidak diwariskan | Diwariskan ke child process |
| **Contoh** | Variabel loop, sementara | `PATH`, `HOME`, `EDITOR` |
| **Zsh Specific** | `typeset` untuk kontrol | `typeset -x` untuk export |

```bash
# Variabel shell (tidak diwariskan)
nama="Budi"
zsh -c 'echo $nama'   # Output: (kosong) — tidak diwariskan

# Environment variable (diwariskan)
export nama="Budi"
zsh -c 'echo $nama'   # Output: Budi
```

---

## 3. Mendeklarasikan dan Menggunakan Variabel

### 3.1 Sintaks Dasar

```bash
# Deklarasi dan assignment (TANPA spasi di sekitar =)
nama="Budi"
umur=25
kota="Jakarta"

# Menggunakan variabel
echo $nama              # Output: Budi
echo "Nama: $nama"      # Output: Nama: Budi
echo "Umur: ${umur}"    # Output: Umur: 25 (dengan braces)

# Variabel bisa diubah nilainya
nama="Siti"
echo $nama              # Output: Siti

# Menghapus variabel
unset nama
echo $nama              # Output: (kosong)
```

**Penjelasan kata demi kata:**
- `nama="Budi"` — assignment. **Tidak boleh ada spasi** di sekitar `=`. `nama = "Budi"` akan diinterpretasikan sebagai perintah `nama` dengan argumen `=` dan `Budi`.
- `$nama` — parameter expansion. Mengganti `$nama` dengan nilai variabel.
- `${nama}` — parameter expansion dengan braces. Wajib jika diikuti karakter yang bisa menjadi bagian nama variabel. Contoh: `echo "${nama}ku"` vs `echo "$namaku"` (yang terakhir mencari variabel `namaku`).
- `unset` — menghapus variabel dari environment shell.

### 3.2 Aturan Penamaan Variabel

```bash
# VALID
nama="Budi"
_nama="Budi"
nama_lengkap="Budi Santoso"
NAMA="Budi"
nama123="Budi"

# TIDAK VALID
123nama="Budi"     # Tidak boleh dimulai dengan angka
nama-lengkap="Budi" # Tidak boleh mengandung tanda hubung
nama lengkap="Budi" # Tidak boleh mengandung spasi
```

**Aturan:**
- Dimulai dengan huruf (`a-z`, `A-Z`) atau underscore (`_`).
- Boleh mengandung huruf, angka, underscore.
- Case-sensitive: `nama` dan `NAMA` adalah variabel berbeda.
- Konvensi: environment variable menggunakan `UPPER_CASE`, variabel lokal menggunakan `lower_case`.

### 3.3 Readonly dan Local Variabel

```bash
# Readonly: tidak bisa diubah setelah di-set
readonly PI=3.14
PI=3.15                # Error: read-only variable

# Local: hanya berlaku dalam fungsi
fungsi() {
    local x=10
    echo "Dalam fungsi: $x"
}
fungsi
echo "Di luar: $x"     # Output: (kosong) — x tidak ada di luar fungsi

# Typeset (Zsh): kontrol lebih detail
typeset -i angka=42     # Integer
typeset -a arr=(1 2 3)  # Array
typeset -A map          # Associative array
typeset -r konstanta=10 # Readonly
typeset -x export_var=1 # Export (environment)
```

**Penjelasan:**
- `readonly` — mencegah perubahan nilai. Berguna untuk konstanta.
- `local` — membatasi scope variabel ke fungsi. Mencegah "polusi" variabel global.
- `typeset` — perintah Zsh untuk mendeklarasikan variabel dengan atribut khusus.

### 3.4 Variabel dari Input Pengguna

```bash
# read: membaca input dari stdin
echo -n "Masukkan nama: "
read nama
echo "Halo, $nama"

# read dengan prompt (Zsh)
read "nama?Masukkan nama: "
echo "Halo, $nama"

# read dengan timeout
read -t 5 "nama?Masukkan nama (5 detik): "

# read ke array
read -A buah "?Masukkan buah (spasi): "
echo "Buah pertama: ${buah[1]}"
```

**Penjelasan:**
- `read` — membaca satu baris dari stdin.
- `-n` — tidak menambahkan newline (untuk prompt).
- `"nama?prompt"` — sintaks Zsh untuk read dengan prompt langsung.
- `-t 5` — timeout 5 detik.
- `-A` — membaca ke array.

---

## 4. Quoting: Single, Double, Backslash, dan ANSI-C

### 4.1 Single Quote (`'...'`)

```bash
echo 'Halo $nama'          # Output: Halo $nama (literal)
echo 'Hari ini $(date)'    # Output: Hari ini $(date) (literal)
echo 'File: *.txt'         # Output: File: *.txt (literal)
echo 'It'\''s okay'        # Output: It's okay (escape single quote)
```

**Karakteristik:**
- **Semua** karakter di dalam single quote adalah literal.
- Tidak ada ekspansi: parameter, command, arithmetic, glob.
- Tidak bisa mengandung single quote. Gunakan `'\''` atau `'"'"'`.

### 4.2 Double Quote (`"..."`)

```bash
nama="Budi"
echo "Halo $nama"          # Output: Halo Budi
echo "Hari ini $(date +%A)" # Output: Hari ini Jumat
echo "File: *.txt"         # Output: File: *.txt (glob TIDAK diekspansi)
echo "Total: $((2+3))"     # Output: Total: 5
echo "Rumah: ~"            # Output: Rumah: ~ (tilde TIDAK diekspansi dalam quote)
```

**Karakteristik:**
- Parameter expansion: ✅
- Command substitution: ✅
- Arithmetic expansion: ✅
- Glob expansion: ❌ (tetap literal)
- Tilde expansion: ❌ (tetap literal)
- Word splitting: ❌ (spasi tetap literal)

### 4.3 Backslash (`\`)

```bash
echo Halo\ Dunia           # Output: Halo Dunia (spasi di-escape)
echo \$nama                # Output: $nama (literal)
echo "Halo \"Dunia\""      # Output: Halo "Dunia"
echo 'It'\''s'             # Output: It's
```

**Karakteristik:**
- Meng-escape satu karakter berikutnya.
- Di luar quote: meng-escape karakter khusus.
- Di dalam double quote: meng-escape `$`, `` ` ``, `"`, `\`, newline.
- Di dalam single quote: **tidak berfungsi** (literal).

### 4.4 ANSI-C Quote (`$'...'`)

```bash
echo $'Halo\tDunia'        # Output: Halo	Dunia (tab)
echo $'Baris1\nBaris2'     # Output: Baris1
                           #         Baris2
echo $'\x41\x42\x43'       # Output: ABC (hex)
echo $'\u00e9'             # Output: é (unicode)
echo $'\e[31mMerah\e[0m'   # Output: Merah (dengan warna merah)
```

**Escape sequence yang didukung:**
- `\n` — newline
- `\t` — tab
- `\r` — carriage return
- `\\` — backslash
- `\'` — single quote
- `\"` — double quote
- `\a` — bell
- `\b` — backspace
- `\e` — escape
- `\xHH` — hex byte
- `\uHHHH` — unicode karakter
- `\UHHHHHHHH` — unicode karakter (8 digit)

### 4.5 Perbandingan Quoting

```bash
nama="Budi Santoso"
file="dokumen penting.txt"

# Tanpa quote: word splitting terjadi
ls $file
# Diinterpretasikan sebagai: ls "dokumen" "penting.txt" → ERROR

# Dengan quote: aman
ls "$file"
# Diinterpretasikan sebagai: ls "dokumen penting.txt" → OK

# Contoh lain
echo $nama        # Output: Budi Santoso (satu spasi)
echo "$nama"      # Output: Budi Santoso (satu spasi)
echo '$nama'      # Output: $nama (literal)
echo \$nama       # Output: $nama (literal)
```

**Praktik terbaik:** **Selalu quote variabel** kecuali Anda benar-benar ingin word splitting atau globbing.

---

## 5. Command Substitution: `$(...)` vs Backtick

### 5.1 Sintaks Dasar

```bash
# Sintaks modern: $()
tanggal=$(date +%Y-%m-%d)
echo "Hari ini: $tanggal"

# Sintaks lama: backtick
tanggal=`date +%Y-%m-%d`
echo "Hari ini: $tanggal"

# Command substitution dalam string
echo "User: $(whoami), Home: $HOME"

# Command substitution bersarang
echo "File terbaru: $(ls -t | head -1)"
echo "Total file: $(ls | wc -l)"
```

**Penjelasan:**
- `$(command)` — menjalankan `command` dan mengganti dengan outputnya.
- Backtick (`` `command` ``) — sintaks lama, masih didukung tetapi **tidak direkomendasikan**.
- Output command substitution adalah stdout dari command tersebut (stderr tetap ke terminal).

### 5.2 Mengapa `$(...)` Lebih Baik dari Backtick?

| Aspek | `$(...)` | Backtick |
|---|---|---|
| **Nesting** | Mudah: `$(echo $(date))` | Sulit: `` `echo \`date\`` `` |
| **Escaping** | Lebih intuitif | Membingungkan |
| **Readability** | Jelas | Sulit dibaca |
| **POSIX** | Didukung | Didukung |

```bash
# Nesting dengan $() — mudah
echo "Tahun: $(date +%Y), Bulan: $(date +%m)"

# Nesting dengan backtick — sulit
echo "Tahun: `date +%Y`, Bulan: `date +%m`"
```

### 5.3 Command Substitution dan Quoting

```bash
# Tanpa quote: word splitting terjadi
file_list=$(ls)
echo $file_list        # Output: file1 file2 file3 (spasi sebagai pemisah)

# Dengan quote: aman
echo "$file_list"      # Output: file1
                       #         file2
                       #         file3

# Command substitution dengan newline
files=$(ls -1)
echo "$files"          # Output: file1
                       #         file2
                       #         file3
```

**Praktik terbaik:** Selalu quote command substitution: `"$(command)"`.

### 5.4 Command Substitution vs Process Substitution

```bash
# Command substitution: output menjadi string
echo "Hari ini: $(date)"

# Process substitution: output menjadi file virtual
diff <(ls dir1) <(ls dir2)
# <(ls dir1) membuat file virtual berisi output ls dir1
# diff membandingkan dua file virtual tersebut
```

---

## 6. Arithmetic Expansion: `$((...))` dan `((...))`

### 6.1 Sintaks Dasar

```bash
# $((...)) — menghasilkan nilai
echo $((2 + 3))          # Output: 5
echo $((10 - 4))         # Output: 6
echo $((3 * 4))          # Output: 12
echo $((10 / 3))         # Output: 3 (integer division)
echo $((10 % 3))         # Output: 1 (modulus)
echo $((2 ** 8))         # Output: 256 (power)

# ((...)) — evaluasi tanpa output (untuk kondisi)
((x = 5 + 3))
echo $x                  # Output: 8

# Dalam kondisi
if ((x > 5)); then
    echo "x lebih dari 5"
fi
```

**Penjelasan:**
- `$((...))` — arithmetic expansion. Menghasilkan nilai numerik.
- `((...))` — arithmetic command. Mengevaluasi ekspresi, return 0 jika hasil != 0, return 1 jika hasil == 0.
- Variabel di dalam `((...))` tidak perlu `$`: `((x + 1))` sama dengan `$(($x + 1))`.

### 6.2 Operator Aritmatika

| Operator | Arti | Contoh |
|---|---|---|
| `+` | Penjumlahan | `$((2+3))` → 5 |
| `-` | Pengurangan | `$((5-3))` → 2 |
| `*` | Perkalian | `$((3*4))` → 12 |
| `/` | Pembagian | `$((10/3))` → 3 |
| `%` | Modulus | `$((10%3))` → 1 |
| `**` | Power | `$((2**3))` → 8 |
| `++` | Increment | `((x++))` |
| `--` | Decrement | `((x--))` |
| `+=` | Tambah dan assign | `((x+=5))` |
| `-=` | Kurang dan assign | `((x-=5))` |
| `*=` | Kali dan assign | `((x*=2))` |
| `/=` | Bagi dan assign | `((x/=2))` |
| `<<` | Left shift | `$((1<<3))` → 8 |
| `>>` | Right shift | `$((8>>1))` → 4 |
| `&` | Bitwise AND | `$((5&3))` → 1 |
| `\|` | Bitwise OR | `$((5\|3))` → 7 |
| `^` | Bitwise XOR | `$((5^3))` → 6 |
| `~` | Bitwise NOT | `$((~5))` → -6 |

### 6.3 Perbandingan dalam `((...))`

```bash
x=10
y=20

# Perbandingan numerik
((x < y)) && echo "x < y"    # Output: x < y
((x > y)) || echo "x <= y"   # Output: x <= y
((x == 10)) && echo "x == 10" # Output: x == 10
((x != y)) && echo "x != y"   # Output: x != y

# Operator perbandingan
# <, >, <=, >=, ==, !=
```

### 6.4 Basis Bilangan

```bash
echo $((10#42))          # Output: 42 (desimal)
echo $((8#52))           # Output: 42 (oktal)
echo $((16#2A))          # Output: 42 (hex)
echo $((2#101010))       # Output: 42 (biner)
```

---

## 7. Brace Expansion: `{a,b,c}`, `{1..10}`, `{01..10}`

### 7.1 Sintaks Dasar

```bash
# Daftar
echo {a,b,c}             # Output: a b c
echo file{1,2,3}.txt     # Output: file1.txt file2.txt file3.txt

# Range
echo {1..5}              # Output: 1 2 3 4 5
echo {5..1}              # Output: 5 4 3 2 1
echo {a..e}              # Output: a b c d e
echo {A..E}              # Output: A B C D E

# Range dengan step
echo {1..10..2}          # Output: 1 3 5 7 9
echo {10..1..-2}         # Output: 10 8 6 4 2

# Range dengan padding
echo {01..10}            # Output: 01 02 03 04 05 06 07 08 09 10
echo {001..010}          # Output: 001 002 ... 010

# Kombinasi
echo {a,b}{1,2}          # Output: a1 a2 b1 b2
```

### 7.2 Brace Expansion vs Glob

```bash
# Brace expansion: membuat string baru
echo file{1,2,3}.txt     # Output: file1.txt file2.txt file3.txt
                         # (tidak peduli file ada atau tidak)

# Glob: mencocokkan file yang ada
echo file*.txt           # Output: file1.txt file2.txt (hanya yang ada)
```

**Perbedaan kunci:** Brace expansion terjadi **sebelum** glob. Brace expansion tidak memerlukan file untuk ada.

### 7.3 Penggunaan Praktis

```bash
# Membuat struktur direktori
mkdir -p proyek/{src,public,test,docs}/{js,css,img}

# Backup file dengan timestamp
cp file.txt file.txt.{bak,backup}

# Membuat file bernomor
touch laporan-{01..12}.txt

# Loop dengan brace expansion
for i in {1..10}; do
    echo "Iterasi ke-$i"
done
```

---

## 8. Parameter Expansion: Default, Assign, Error, Alternate

### 8.1 Sintaks Dasar

```bash
# ${var:-default} — gunakan default jika var kosong/tidak ada
echo ${nama:-"Tamu"}     # Jika $nama kosong, output: Tamu

# ${var:=default} — set var ke default jika kosong
echo ${nama:="Tamu"}     # Jika $nama kosong, set ke "Tamu"

# ${var:?error} — error jika var kosong
echo ${nama:?"Nama harus diisi"}  # Error jika $nama kosong

# ${var:+alternate} — gunakan alternate jika var TIDAK kosong
echo ${nama:+"Ada nama"} # Output: Ada nama (jika $nama tidak kosong)
```

### 8.2 Perbandingan Operator

| Operator | Jika `var` Kosong | Jika `var` Tidak Kosong |
|---|---|---|
| `${var:-default}` | Gunakan `default` | Gunakan `$var` |
| `${var:=default}` | Set `var=default`, gunakan `default` | Gunakan `$var` |
| `${var:?error}` | Tampilkan error, exit | Gunakan `$var` |
| `${var:+alternate}` | Gunakan string kosong | Gunakan `alternate` |

### 8.3 Contoh Praktis

```bash
# Default value
editor=${EDITOR:-vim}
echo "Editor: $editor"

# Wajib diisi
: ${NAMA:?"Variabel NAMA harus diisi"}
# Jika NAMA kosong, script akan error dan exit

# Conditional
echo ${DEBUG:+"Mode debug aktif"}
# Jika DEBUG tidak kosong, tampilkan "Mode debug aktif"

# Kombinasi dengan command substitution
config_file=${CONFIG:-"$HOME/.config/app/config.yaml"}
```

### 8.4 Substring dan Manipulasi String

```bash
nama="Budi Santoso"

# Substring
echo ${nama:0:4}         # Output: Budi (4 karakter dari index 0)
echo ${nama:5}           # Output: Santoso (dari index 5)
echo ${nama: -7}         # Output: Santoso (7 karakter terakhir)

# Panjang
echo ${#nama}            # Output: 12

# Hapus prefix
file="dokumen.txt"
echo ${file#*.}          # Output: txt (hapus prefix terpendek)
echo ${file##*.}         # Output: txt (hapus prefix terpanjang)

# Hapus suffix
echo ${file%.*}          # Output: dokumen (hapus suffix terpendek)
echo ${file%%.*}         # Output: dokumen (hapus suffix terpanjang)

# Replace
echo ${nama/Budi/Siti}   # Output: Siti Santoso (replace pertama)
echo ${nama//o/0}        # Output: Budi Sant0s0 (replace semua)

# Case conversion (Zsh)
echo ${nama:u}           # Output: BUDI SANTOSO (uppercase)
echo ${nama:l}           # Output: budi santoso (lowercase)
echo ${nama:c}           # Output: Budi santoso (capitalize)
```

---

## 9. Array di Zsh: 1-Indexed, Slicing, Filtering, Sorting

### 9.1 Sintaks Dasar

```bash
# Deklarasi array
buah=(apel jeruk mangga)
angka=(1 2 3 4 5)
kosong=()

# Akses elemen (1-indexed!)
echo ${buah[1]}          # Output: apel
echo ${buah[2]}          # Output: jeruk
echo ${buah[3]}          # Output: mangga

# Semua elemen
echo ${buah[@]}          # Output: apel jeruk mangga
echo ${buah[*]}          # Output: apel jeruk mangga

# Jumlah elemen
echo ${#buah[@]}         # Output: 3

# Assign elemen
buah[4]="pisang"
echo ${buah[@]}          # Output: apel jeruk mangga pisang

# Hapus elemen
unset "buah[2]"
echo ${buah[@]}          # Output: apel mangga pisang
```

**Penjelasan:**
- `buah=(...)` — deklarasi array. Elemen dipisahkan spasi.
- `${buah[1]}` — akses elemen pertama (1-indexed).
- `${buah[@]}` — semua elemen, masing-masing sebagai kata terpisah.
- `${buah[*]}` — semua elemen sebagai satu string.
- `${#buah[@]}` — jumlah elemen.

### 9.2 Slicing Array

```bash
buah=(apel jeruk mangga pisang anggur)

# Slice: ${array[start,end]}
echo ${buah[2,4]}        # Output: jeruk mangga pisang
echo ${buah[2,-1]}       # Output: jeruk mangga pisang anggur
echo ${buah[-2,-1]}      # Output: pisang anggur

# Slice dengan step
echo ${buah[1,5,2]}      # Output: apel mangga anggur (step 2)
```

### 9.3 Filtering dan Sorting (Zsh Flags)

```bash
buah=(apel jeruk mangga pisang anggur)

# (o) — sort ascending
echo ${(o)buah[@]}       # Output: anggur apel jeruk mangga pisang

# (O) — sort descending
echo ${(O)buah[@]}       # Output: pisang mangga jeruk apel anggur

# (on) — sort numeric
angka=(10 2 30 4 5)
echo ${(on)angka[@]}     # Output: 2 4 5 10 30

# (f) — split berdasarkan newline
files=(${(f)"$(ls)"})
echo ${files[1]}         # File pertama

# (j:,:) — join dengan koma
echo ${(j:,:)buah[@]}    # Output: apel,jeruk,mangga,pisang,anggur

# (k) — keys (index) dari associative array
# (v) — values dari associative array

# (u) — unique
angka=(1 2 2 3 3 3)
echo ${(u)angka[@]}      # Output: 1 2 3

# (q) — quote
echo ${(q)buah[@]}       # Output: apel jeruk mangga pisang anggur (quoted)
```

### 9.4 Iterasi Array

```bash
buah=(apel jeruk mangga)

# Iterasi nilai
for b in "${buah[@]}"; do
    echo "Buah: $b"
done

# Iterasi index
for i in {1..${#buah[@]}}; do
    echo "Index $i: ${buah[$i]}"
done

# Dengan index dan nilai (Zsh)
for i in {1..${#buah[@]}}; do
    echo "$i: ${buah[$i]}"
done
```

---

## 10. Associative Array: Hash Map di Shell

### 10.1 Sintaks Dasar

```bash
# Deklarasi associative array
typeset -A user
user[nama]="Budi"
user[umur]=25
user[kota]="Jakarta"

# Akses
echo ${user[nama]}       # Output: Budi
echo ${user[umur]}       # Output: 25

# Semua keys
echo ${(k)user}          # Output: nama umur kota

# Semua values
echo ${(v)user}          # Output: Budi 25 Jakarta

# Jumlah elemen
echo ${#user}            # Output: 3

# Iterasi
for key in ${(k)user}; do
    echo "$key: ${user[$key]}"
done
```

**Penjelasan:**
- `typeset -A` — mendeklarasikan associative array (hash map).
- `${user[key]}` — akses value berdasarkan key.
- `${(k)user}` — semua keys.
- `${(v)user}` — semua values.

### 10.2 Contoh Praktis: Konfigurasi

```bash
typeset -A config
config[host]="localhost"
config[port]=8080
config[debug]="true"

# Baca konfigurasi
echo "Server: ${config[host]}:${config[port]}"
echo "Debug: ${config[debug]}"

# Cek apakah key ada
if [[ -n ${config[host]} ]]; then
    echo "Host terdefinisi"
fi

# Hapus key
unset "config[debug]"
```

### 10.3 Associative Array vs Regular Array

| Aspek | Regular Array | Associative Array |
|---|---|---|
| **Deklarasi** | `arr=(a b c)` | `typeset -A map` |
| **Index** | Numerik (1, 2, 3) | String (nama, umur) |
| **Akses** | `${arr[1]}` | `${map[nama]}` |
| **Keys** | `${!arr[@]}` | `${(k)map}` |
| **Values** | `${arr[@]}` | `${(v)map}` |
| **Penggunaan** | Daftar berurutan | Konfigurasi, mapping |

---

## 11. Special Variables: `$?`, `$$`, `$!`, `$#`, `$@`, `$*`, `$0`, `$_`

### 11.1 Daftar Special Variables

| Variabel | Arti | Contoh |
|---|---|---|
| `$?` | Exit status perintah terakhir | `0` = sukses, non-zero = error |
| `$$` | PID shell saat ini | `12345` |
| `$!` | PID background process terakhir | `12346` |
| `$#` | Jumlah argumen posisional | `3` |
| `$@` | Semua argumen posisional (terpisah) | `"a" "b" "c"` |
| `$*` | Semua argumen posisional (satu string) | `"a b c"` |
| `$0` | Nama script/shell | `./script.sh` |
| `$_` | Argumen terakhir perintah sebelumnya | `/usr/bin/zsh` |
| `$LINENO` | Nomor baris saat ini | `42` |
| `$RANDOM` | Angka acak 0-32767 | `12345` |
| `$SECONDS` | Detik sejak shell dimulai | `3600` |
| `$PPID` | PID parent process | `12344` |
| `$PWD` | Direktori saat ini | `/home/budi` |
| `$OLDPWD` | Direktori sebelumnya | `/home/budi/proyek` |

### 11.2 Contoh Penggunaan

```bash
# $? — exit status
ls /nonexistent
echo $?                  # Output: 2 (error)
ls /home
echo $?                  # Output: 0 (sukses)

# $$ — PID shell
echo "PID shell: $$"

# $! — PID background
sleep 100 &
echo "PID sleep: $!"
kill $!

# $# — jumlah argumen
echo "Jumlah argumen: $#"

# $@ — semua argumen
for arg in "$@"; do
    echo "Argumen: $arg"
done

# $RANDOM — angka acak
echo "Angka acak: $RANDOM"
echo "Dadu: $((RANDOM % 6 + 1))"

# $SECONDS — waktu sejak shell dimulai
echo "Shell berjalan selama $SECONDS detik"
```

### 11.3 `$@` vs `$*`

```bash
# Script: test.sh
echo "Dengan \$@:"
for arg in "$@"; do
    echo "  [$arg]"
done

echo "Dengan \$*:"
for arg in "$*"; do
    echo "  [$arg]"
done

# Jalankan: ./test.sh "a b" c
# Output:
# Dengan $@:
#   [a b]
#   [c]
# Dengan $*:
#   [a b c]
```

**Perbedaan:**
- `"$@"` — setiap argumen adalah kata terpisah. **Gunakan ini.**
- `"$*"` — semua argumen digabung menjadi satu string dengan `$IFS` sebagai pemisah.

---

## 12. Deep Dive: Quoting Lanjutan

### 12.1 `$'...'` — ANSI-C Quoting

```bash
# Escape sequence
echo $'Halo\tDunia'      # Tab
echo $'Baris1\nBaris2'   # Newline
echo $'\x41\x42'         # Hex: AB
echo $'\u00e9'           # Unicode: é
echo $'\e[31mMerah\e[0m' # Warna merah
```

### 12.2 `${(q)}` — Quote untuk Reuse

```bash
# (q) — quote string agar aman digunakan kembali
nama="Budi Santoso"
quoted=${(q)nama}
echo $quoted             # Output: 'Budi Santoso'

# (qq) — quote untuk eval
# (qqq) — quote untuk eval dengan newline
# (q-) — quote minimal
```

### 12.3 `${(qq)}` — Quote untuk Eval

```bash
perintah="echo 'Halo Dunia'"
eval ${(qq)perintah}
# Output: Halo Dunia
```

---

## 13. Deep Dive: Proses Substitusi

### 13.1 `<(command)` — Process Substitution Input

```bash
# Bandingkan output dua perintah
diff <(ls dir1) <(ls dir2)

# Baca file yang dihasilkan perintah
while read line; do
    echo "Line: $line"
done < <(cat file.txt)

# Gunakan output perintah sebagai file
sort <(echo "b"; echo "a"; echo "c")
```

**Penjelasan:** `<(command)` menjalankan command dan membuat file virtual (named pipe atau `/dev/fd`) yang berisi outputnya. File virtual ini bisa digunakan sebagai argumen file.

### 13.2 `>(command)` — Process Substitution Output

```bash
# Kirim output ke dua tempat sekaligus
echo "Halo" > >(tee file1.txt) > >(tee file2.txt)

# Log ke file dan terminal
command > >(tee log.txt)
```

---

## 14. Deep Dive: Ekspansi Zsh Lanjutan

### 14.1 Flag Ekspansi Zsh

| Flag | Arti | Contoh |
|---|---|---|
| `(f)` | Split berdasarkan newline | `${(f)"$(ls)"}` |
| `(o)` | Sort ascending | `${(o)arr[@]}` |
| `(O)` | Sort descending | `${(O)arr[@]}` |
| `(on)` | Sort numeric | `${(on)arr[@]}` |
| `(j:sep:)` | Join dengan separator | `${(j:,:)arr[@]}` |
| `(k)` | Keys | `${(k)map}` |
| `(v)` | Values | `${(v)map}` |
| `(u)` | Unique | `${(u)arr[@]}` |
| `(q)` | Quote | `${(q)var}` |
| `(qq)` | Quote untuk eval | `${(qq)var}` |
| `(z)` | Split seperti shell | `${(z)var}` |
| `(s:sep:)` | Split dengan separator | `${(s:,:)var}` |
| `(c)` | Count | `${(c)arr[@]}` |
| `(w)` | Count words | `${(w)var}` |

### 14.2 Contoh Kombinasi

```bash
# Split, sort, unique
files=(${(f)"$(ls)"})
echo ${(u)files[@]}

# Join dengan koma
buah=(apel jeruk mangga)
echo ${(j:, :)buah[@]}   # Output: apel, jeruk, mangga

# Sort numeric descending
angka=(10 2 30 4 5)
echo ${(On)angka[@]}     # Output: 30 10 5 4 2
```

---

## 15. Terminologi Esensial & Penjelasan Detail

| Istilah | Definisi | Contoh |
|---|---|---|
| **Ekspansi** | Proses shell mengganti teks dengan nilai sebenarnya | `$nama` → `Budi` |
| **Quoting** | Mekanisme mencegah ekspansi | `'$nama'` → literal |
| **Single Quote** | Quote literal, tidak ada ekspansi | `'...'` |
| **Double Quote** | Quote dengan parameter/command/arithmetic expansion | `"..."` |
| **Backslash** | Escape karakter berikutnya | `\$` |
| **ANSI-C Quote** | Quote dengan escape sequence | `$'...'` |
| **Command Substitution** | Output perintah menjadi nilai | `$(date)` |
| **Arithmetic Expansion** | Evaluasi ekspresi matematika | `$((2+3))` |
| **Brace Expansion** | Membuat daftar string | `{a,b,c}` |
| **Parameter Expansion** | Manipulasi nilai variabel | `${var:-default}` |
| **Word Splitting** | Memecah string berdasarkan IFS | `$var` tanpa quote |
| **Glob/Pathname Expansion** | Mencocokkan nama file dengan pola | `*.txt` |
| **Tilde Expansion** | Mengganti `~` dengan home directory | `~/file` |
| **Process Substitution** | Output perintah sebagai file virtual | `<(command)` |
| **Array** | Kumpulan nilai berindeks numerik | `arr=(a b c)` |
| **Associative Array** | Kumpulan nilai berindeks string | `typeset -A map` |
| **IFS** | Internal Field Separator | Default: spasi, tab, newline |
| **Special Variable** | Variabel yang memiliki arti khusus | `$?`, `$$`, `$!` |
| **Exit Status** | Kode hasil perintah | `$?` |
| **PID** | Process ID | `$$` |

**Penjelasan tambahan:**
- **IFS (Internal Field Separator):** Variabel yang menentukan karakter pemisah kata. Default: spasi, tab, newline. Bisa diubah: `IFS=,` untuk memisahkan berdasarkan koma.
- **Word Splitting:** Terjadi setelah parameter expansion, command substitution, dan arithmetic expansion. Hanya pada ekspansi yang tidak di-quote.
- **Glob:** Terjadi setelah word splitting. Hanya pada ekspansi yang tidak di-quote.

---

## 16. Hubungan dengan Modul Lain

| Modul | Hubungan |
|---|---|
| **Modul 1.1 (Shell & Zsh)** | Ekspansi adalah alasan mengapa shell disebut "interpreter" — ia memproses teks sebelum eksekusi. |
| **Modul 1.2 (Navigasi)** | Path sering menggunakan variabel (`$HOME`, `$PWD`), glob (`*.txt`), dan brace expansion (`{1..10}`). |
| **Fase 2 (Scripting)** | Variabel, quoting, dan ekspansi adalah **inti** dari scripting. Setiap script akan menggunakan konsep-konsep ini. |
| **Fase 3 (Plugin)** | Konfigurasi plugin sering menggunakan array dan associative array. |

---

## 17. Sumber Referensi Lengkap

| Sumber | URL | Deskripsi |
|---|---|---|
| **Zsh Expansion** | https://zsh.sourceforge.io/Doc/Release/Expansion.html | Detail lengkap ekspansi Zsh |
| **Zsh Parameters** | https://zsh.sourceforge.io/Doc/Release/Parameters.html | Detail parameter expansion |
| **Zsh Arrays** | https://zsh.sourceforge.io/Doc/Release/Parameters.html#Array-Parameters | Array di Zsh |
| **Bash Parameter Expansion** | https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html | Referensi parameter expansion |
| **Bash Quoting** | https://www.gnu.org/software/bash/manual/html_node/Quoting.html | Referensi quoting |
| **Bash Arrays** | https://www.gnu.org/software/bash/manual/html_node/Arrays.html | Array di Bash (perbandingan) |
| **Zsh FAQ — Arrays** | https://zsh.sourceforge.io/FAQ/zshfaq02.html | FAQ tentang array Zsh |
| **Mycology — Zsh Expansion** | https://github.com/ohmyzsh/ohmyzsh/wiki/Cheatsheet | Cheatsheet Oh My Zsh |
| **LinuxCommand.org — Variables** | https://linuxcommand.org/lc3_wss0030.php | Tutorial variabel |
| **ShellCheck** | https://www.shellcheck.net/ | Tool untuk memeriksa script shell |
| **Bash Pitfalls** | https://mywiki.wooledge.org/BashPitfalls | Kesalahan umum di Bash |
| **Zsh Manual — Options** | https://zsh.sourceforge.io/Doc/Release/Options.html | Opsi Zsh termasuk `KSH_ARRAYS` |
| **Stack Overflow — Zsh Arrays** | https://stackoverflow.com/questions/tagged/zsh | Diskusi tentang Zsh |
| **Unix StackExchange** | https://unix.stackexchange.com/ | Q&A tentang Unix/Linux |
| **Google Shell Style Guide** | https://google.github.io/styleguide/shellguide.html | Panduan gaya penulisan shell |

---

## 18. Tips dan Praktik Terbaik

### 18.1 Quoting

- **Selalu quote** variabel: `"$var"`, `"${arr[@]}"`.
- Gunakan `${var}` bukan `$var` jika diikuti karakter alfanumerik.
- Gunakan `"$@"` bukan `$@` atau `"$*"` untuk argumen.
- Untuk literal yang mengandung `$`, gunakan single quote: `'$var'`.

### 18.2 Variabel

- Gunakan `local` dalam fungsi untuk menghindari polusi global.
- Gunakan `readonly` untuk konstanta.
- Gunakan `typeset -i` untuk variabel integer.
- Beri nama variabel dengan deskriptif.

### 18.3 Array

- Ingat: Zsh array **1-indexed**.
- Gunakan `"${arr[@]}"` untuk semua elemen.
- Gunakan `${#arr[@]}` untuk jumlah elemen.
- Manfaatkan flag Zsh: `(o)`, `(O)`, `(j)`, `(k)`, `(v)`.

### 18.4 Debugging

- Gunakan `set -x` untuk trace eksekusi.
- Gunakan `echo "DEBUG: $var"` untuk inspeksi.
- Gunakan `shellcheck` untuk memeriksa script.
- Gunakan `set -u` untuk error pada variabel tidak terdefinisi.

```bash
# Debugging
set -x                   # Trace semua perintah
set +x                   # Matikan trace
set -u                   # Error jika variabel tidak terdefinisi
set -e                   # Exit jika ada perintah gagal
set -o pipefail          # Exit jika ada perintah di pipe gagal
```

### 18.5 Performa

- Hindari command substitution dalam loop besar.
- Gunakan array daripada string untuk daftar.
- Gunakan `printf` daripada `echo` untuk output kompleks.

---

## 19. Potensi Kesalahan Umum & Solusi

| Kesalahan | Penyebab | Solusi |
|---|---|---|
| **`nama = "Budi"`** | Spasi di sekitar `=` | `nama="Budi"` (tanpa spasi) |
| **`$namaku`** | Variabel `namaku` bukan `nama` + `ku` | `${nama}ku` |
| **`ls $file`** | Word splitting pada spasi | `ls "$file"` |
| **`echo $@`** | Word splitting | `echo "$@"` |
| **`arr[0]`** | Zsh 1-indexed | `arr[1]` untuk elemen pertama |
| **`${arr}`** | Tidak valid untuk semua elemen | `${arr[@]}` |
| **`if [ $x = "a" ]`** | Tidak quote | `if [ "$x" = "a" ]` |
| **`$(command`** | Kurung tidak ditutup | `$(command)` |
| **`'It's'`** | Single quote di dalam single quote | `'It'\''s'` |
| **`echo $((2+3))`** | Benar, tapi `$((2+3))` di quote | `echo "$((2+3))"` |
| **Variabel tidak terdefinisi** | Tidak ada `set -u` | Gunakan `${var:-default}` |
| **Array kosong** | `${#arr[@]}` = 0 | Cek sebelum akses |
| **`read` tanpa `-r`** | Backslash diinterpretasi | `read -r var` |
| **`for i in $(ls)`** | Word splitting pada spasi | `for i in "${arr[@]}"` |

### 19.1 Debugging: Melacak Ekspansi

```bash
# Gunakan echo untuk melihat hasil ekspansi
echo "Nama: $nama"
echo "Array: ${arr[@]}"
echo "Jumlah: ${#arr[@]}"

# Gunakan set -x untuk trace
set -x
ls "$file"
set +x

# Gunakan printf untuk melihat karakter tersembunyi
printf '%q\n' "$var"
```

### 19.2 Contoh Kesalahan Umum dan Perbaikan

```bash
# KESALAHAN: word splitting
file="dokumen penting.txt"
ls $file                 # Error: ls: cannot access 'dokumen': No such file
# PERBAIKAN:
ls "$file"               # OK

# KESALAHAN: array tanpa quote
arr=("a b" "c d")
for x in ${arr[@]}; do
    echo "$x"
done
# Output: a b c d (terpisah)
# PERBAIKAN:
for x in "${arr[@]}"; do
    echo "$x"
done
# Output: a b / c d

# KESALAHAN: variabel tidak terdefinisi
echo "$undefined_var"    # Output: (kosong)
# PERBAIKAN:
set -u
echo "$undefined_var"    # Error: undefined_var: parameter not set

# KESALAHAN: command substitution tanpa quote
files=$(ls)
echo $files              # Word splitting
# PERBAIKAN:
echo "$files"            # Aman
```

---


# ✅ Selamat! anda telah menyelesaikan

Materi **Modul 1.3** secara komprehensif, mencakup:

- ✅ Deskripsi konkret & peran dalam kurikulum
- ✅ Konsep kunci & filosofi (untyped, ekspansi multi-tahap, quoting)
- ✅ Sintaks dasar & contoh implementasi (dengan penjelasan kata demi kata)
- ✅ Terminologi esensial (20+ istilah)
- ✅ Struktur pembelajaran internal (mini daftar isi)
- ✅ Rekomendasi visualisasi (diagram alur ekspansi)
- ✅ Hubungan dengan modul lain
- ✅ Sumber referensi lengkap (15 sumber)
- ✅ Tips dan praktik terbaik
- ✅ Potensi kesalahan umum & solusi
- ✅ Deep Dive: Quoting Lanjutan, Proses Substitusi, Ekspansi Zsh Lanjutan
- ✅ Arithmetic expansion, Brace expansion, Special variables

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

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

