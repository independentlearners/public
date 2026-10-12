# MODUL 6.1: ARSITEKTUR ENTERPRISE DAN DEPLOYMENT

---
### AUDIT KURIKULUM — FASE 6: EXPERT

## Metodologi Audit

Audit ini dilakukan dengan memeriksa setiap entri dalam Fase 6 terhadap: (1) kelengkapan struktur (apakah setiap modul memiliki Deskripsi Konkret, Konsep Dasar, Sintaks, Terminologi, Daftar Isi, dan Sumber Referensi), (2) kedalaman konten (apakah topik yang disebutkan di Daftar Isi benar-benar dijelaskan), (3) kesinambungan antar modul (apakah ada prasyarat yang tidak terpenuhi), dan (4) kelengkapan cakupan untuk level Expert.

---

## Temuan Audit

### 1. Modul 6.1: Arsitektur Enterprise dan Deployment — ⚠️ CUKUP BAIK, PERLU PENDALAMAN

**Kekuatan:**
- Struktur dotfiles enterprise sudah diperkenalkan
- Perbedaan konfigurasi sistem-wide vs pengguna sudah disebutkan
- Sintaks dasar modular loading sudah ada

**Kekurangan yang Teridentifikasi:**
- Belum ada penjelasan tentang **urutan lengkap startup files Zsh** (zshenv, zprofile, zshrc, zlogin, zlogout) beserta perbedaan perilaku untuk login/interactive/non-interactive shell — ini fundamental sebelum bicara deployment
- Belum ada pembahasan tentang **XDG Base Directory Specification** dan relevansinya untuk konfigurasi enterprise
- Istilah "Zero-Trust Security" hanya disebut satu baris tanpa penjelasan
- Belum ada penjelasan tentang **kebijakan audit** dan **manajemen secrets** dalam konteks shell
- Belum ada pembahasan tentang **plugin manager enterprise** (Antidote, Sheldon, Zinit) dan trade-off-nya untuk tim
- **Onboarding pengembang baru** disebut di Daftar Isi tapi tidak ada petunjuk implementasi

### 2. Modul 6.2: Kontribusi ke Proyek Zsh dan Open Source — ❌ TIDAK MEMILIKI KONTEN

Modul ini hanya memiliki judul. Tidak ada Deskripsi Konkret, Sintaks, Terminologi, Daftar Isi, maupun Sumber Referensi. Ini merupakan gap besar untuk Fase Expert karena kontribusi open source adalah kompetensi inti level expert.

**Yang perlu ditambahkan:**
- Proses build Zsh dari source
- Alur komunikasi via mailing list
- Format patch dan review
- Penulisan plugin Zsh yang mengikuti standar komunitas

### 3. Modul 6.3: Spesialisasi — ⚠️ TERLALU RINGKAS

Modul ini memberikan 3 jalur spesialisasi, tetapi:
- Jalur B (Data Engineering) hanya menyebutkan nama tools tanpa sintaks contoh
- Jalur C (Developer Tooling) hanya menyebutkan nama tools tanpa sintaks contoh
- Hanya Jalur A yang memiliki sintaks dasar
- **Proyek akhir** disebut di Daftar Isi tapi tidak dijelaskan

---

## Rekomendasi Penambahan ke Kurikulum

| # | Materi Tambahan | Modul | Alasan |
|---|---|---|---|
| 1 | Urutan lengkap startup/shutdown files Zsh (5 file + /etc/ variants) | 6.1 | Fondasi wajib sebelum enterprise config |
| 2 | XDG Base Directory Specification + `$ZDOTDIR` | 6.1 | Standar modern lokasi konfigurasi |
| 3 | Manajemen secrets (1Password CLI, keychain, SOPS) | 6.1 | Keamanan enterprise |
| 4 | Audit dan compliance (log command, history policy) | 6.1 | Zero-trust implementation |
| 5 | Perbandingan plugin manager (Antidote, Sheldon, Zinit, Znap) | 6.1 | Keputusan teknis tim |
| 6 | `zcompile` dan optimasi startup time | 6.1 | Performance enterprise |
| 7 | Kontribusi Zsh: build, patch, mailing list | 6.2 | Gap kritis |
| 8 | Proyek akhir spesialisasi | 6.3 | Assessment |

---

## Catatan Struktural

Kurikulum Fase 6 **tidak meloncat** secara fundamental — modul 6.1 memang prasyarat untuk 6.2 dan 6.3. Namun, konten 6.1 perlu diperdalam secara signifikan sebelum beralih ke 6.2. Materi di bawah ini akan **melampaui** apa yang tertulis di kurikulum, dengan penambahan yang ditandai secara eksplisit sebagai **[TAMBAHAN AUDIT]**.

---


## Struktur Pembelajaran Internal (Mini-Daftar Isi)

<details>
  <summary>📃 Daftar Isi</summary>

---


Sebelum memulai, berikut adalah peta lengkap yang akan kita bahas:

1. **Fondasi Startup Files Zsh** — 5 file startup + urutan loading, perbedaan login vs interactive vs non-interactive
2. **Konfigurasi Sistem-Wide vs Pengguna** — `/etc/zsh/` hierarchy, precedence, dan override strategy
3. **Modular Configuration dengan conf.d** — Pola loading file numerik, dependency resolution
4. **XDG Base Directory & ZDOTDIR** [TAMBAHAN AUDIT] — Standar lokasi konfigurasi modern
5. **Manajemen Dotfiles: GNU Stow** — Symlink farm, package-based organization, workflow lengkap
6. **Deployment Enterprise: Ansible** — Role-based deployment, idempotency, version control
7. **Manajemen Plugin di Tim** — Perbandingan plugin manager, kebijakan standarisasi
8. **Keamanan & Zero-Trust** — Secrets management, audit policy, restricted shell
9. **Optimasi Startup Time** [TAMBAHAN AUDIT] — `zcompile`, lazy loading, benchmarking
10. **Onboarding Pengembang Baru** — Checklist, automasi, template

</details>


---

## 1. Fondasi Startup Files Zsh

### Deskripsi Konkret & Peran dalam Kurikulum

Zsh membaca serangkaian file konfigurasi saat startup. Memahami **file mana yang dibaca, kapan, dan dalam urutan apa** adalah fondasi mutlak sebelum Anda bisa merancang arsitektur enterprise. Tanpa pemahaman ini, konfigurasi enterprise Anda akan rapuh: environment variable mungkin tidak ter-set untuk cron jobs, PATH mungkin berisi duplikat, atau konfigurasi yang seharusnya global malah ter-override secara tak terduga.

Di tingkat enterprise, **kesalahan urutan startup file berarti deployment yang tidak konsisten** — satu tim bisa memiliki shell yang berperilaku berbeda dari tim lain hanya karena perbedaan cara shell di-invoke.

### Konsep Kunci & Filosofi Mendalam

**Bayangkan shell seperti sebuah gedung bertingkat.** Setiap lantai adalah fase startup yang berbeda. Lantai paling dasar (`/etc/zshenv`) adalah fondasi yang selalu ada. Lantai-lantai di atasnya hanya dibangun jika kondisi tertentu terpenuhi — apakah Anda masuk melalui pintu utama (login shell) atau jendela samping (non-login interactive shell)?

Filosofi desain Zsh adalah: **semakin awal file dibaca, semakin universal dampaknya, dan semakin hati-hati Anda harus mengisinya.** `/etc/zshenv` dibaca oleh *setiap* instance Zsh — termasuk shell yang dijalankan oleh `cron`, `scp`, script non-interactive, bahkan shell yang di-embed dalam program lain. Jika Anda meletakkan sesuatu yang berat atau error-prone di sini, *seluruh sistem* bisa terganggu.

### Sintaks Dasar — Urutan Loading Lengkap

Berikut adalah urutan lengkap file startup Zsh berdasarkan manual resmi:

```bash
┌─────────────────────────────────────────────────────────────┐
│                    URUTAN STARTUP ZSH                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. /etc/zshenv          ← SELALU dibaca (tidak bisa       │
│     $ZDOTDIR/.zshenv        di-override)                    │
│                                                             │
│  ┌─ Jika LOGIN SHELL: ──────────────────────────────────┐   │
│  │  2. /etc/zprofile                                   │   │
│  │     $ZDOTDIR/.zprofile                              │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─ Jika INTERACTIVE SHELL: ───────────────────────────┐   │
│  │  3. /etc/zshrc                                      │   │
│  │     $ZDOTDIR/.zshrc                                 │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─ Jika LOGIN SHELL: ─────────────────────────────────┐   │
│  │  4. /etc/zlogin                                     │   │
│  │     $ZDOTDIR/.zlogin                                │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ═══════════ SHELL BERJALAN ═══════════                     │
│                                                             │
│  ┌─ Saat LOGIN SHELL EXIT: ────────────────────────────┐   │
│  │  5. $ZDOTDIR/.zlogout                               │   │
│  │     /etc/zlogout                                    │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Mengapa urutan ini penting?** Mari kita telusuri setiap file:

**`/etc/zshenv` dan `$ZDOTDIR/.zshenv`** — Dibaca oleh *semua* shell, tanpa kecuali. Ini adalah tempat untuk environment variable yang harus tersedia bahkan untuk script non-interactive: `PATH`, `EDITOR`, `LANG`, dan variabel yang dibutuhkan oleh tools otomasi. Karena dibaca oleh setiap shell, file ini harus **sesingkat mungkin**. Manual Zsh menyarankan untuk membungkus kode yang tidak perlu dijalankan setiap saat dengan `if [[ -o rcs ]]`.

```bash
# /etc/zsh/zshenv — KONFIGURASI MINIMAL
# File ini dibaca oleh SETIAP instance zsh, termasuk cron, scp, dll.

# Hanya set environment variable yang benar-benar global
export PATH="/usr/local/bin:/usr/bin:/bin"
export EDITOR="vim"
export LANG="en_US.UTF-8"

# PENTING: Jangan letakkan plugin loading, prompt setup, atau
# alias di sini — file ini harus tetap minimal dan cepat.
```

**`/etc/zprofile` dan `$ZDOTDIR/.zprofile`** — Hanya dibaca oleh login shell. Login shell adalah shell yang dijalankan saat Anda login ke sistem (via TTY, SSH, atau `su -`). Ini adalah tempat yang tepat untuk mengatur environment yang hanya perlu di-set sekali per sesi login, seperti `PATH` tambahan, variabel yang membutuhkan eksekusi command substitution berat (misalnya `$(brew shellenv)`), atau konfigurasi yang bergantung pada kondisi login.

```bash
# /etc/zsh/zprofile — KONFIGURASI LOGIN SHELL
# Hanya dibaca sekali per sesi login.

# macOS: Homebrew environment (hanya perlu sekali per login)
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Linux: tambahan PATH untuk tools enterprise
export PATH="$PATH:/opt/company/tools/bin"
```

**`/etc/zshrc` dan `$ZDOTDIR/.zshrc`** — Hanya dibaca oleh interactive shell. Ini adalah tempat untuk: alias, fungsi, prompt (PS1), plugin, key bindings, dan konfigurasi completion. Hampir semua "kustomisasi" pengguna ada di sini.

```bash
# /etc/zsh/zshrc — KONFIGURASI INTERACTIVE SHELL
# Hanya dibaca oleh shell yang interaktif (terminal user).

# Aktifkan completion system
autoload -Uz compinit && compinit

# History settings
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

# Load konfigurasi modular enterprise
if [[ -d /etc/zsh/conf.d ]]; then
    for conf in /etc/zsh/conf.d/*.zsh(N); do
        source "$conf"
    done
fi
```

**`/etc/zlogin` dan `$ZDOTDIR/.zlogin`** — Dibaca setelah `.zshrc` untuk login shell. Jarang digunakan. Tempat untuk pesan selamat datang, pengecekan update, atau script yang harus dijalankan *setelah* semua konfigurasi interactive selesai.

**`$ZDOTDIR/.zlogout` dan `/etc/zlogout`** — Dibaca saat login shell exit. Tempat untuk cleanup: menghapus temporary files, menyimpan state, atau mengirim log session.

> **⚠️ Kesalahan Umum:** Banyak pengembang meletakkan semua konfigurasi di `.zshrc` tanpa memikirkan file mana yang seharusnya digunakan. Akibatnya, `PATH` yang seharusnya hanya untuk login shell malah di-set ulang setiap kali shell interaktif dibuka — menyebabkan duplikasi PATH yang memperlambat startup. Solusinya: **pindahkan setup environment ke `.zshenv` atau `.zprofile`, sisakan hanya alias, fungsi, dan prompt di `.zshrc`.**

### Diagram Alur: Kapan Setiap File Dibaca

```bash
Shell di-invoke
       │
       ▼
  Baca /etc/zshenv ──── SELALU
       │
       ▼
  Baca $ZDOTDIR/.zshenv ──── SELALU
       │
       ▼
  ┌──── Login shell? ────┐
  │ YA                    │ TIDAK
  ▼                       ▼
  Baca /etc/zprofile      ┌──── Interactive? ────┐
  Baca $ZDOTDIR/.zprofile │ YA                    │ TIDAK
       │                  ▼                       ▼
       ▼                  Baca /etc/zshrc          Shell berjalan
  ┌──── Interactive? ──┐  Baca $ZDOTDIR/.zshrc     (non-interactive)
  │ YA                 │  Shell berjalan
  ▼                    │
  Baca /etc/zshrc      │
  Baca $ZDOTDIR/.zshrc │
       │               │
       ▼               │
  Baca /etc/zlogin      │
  Baca $ZDOTDIR/.zlogin │
       │               │
       ▼               │
  ═════ Shell berjalan ═
       │
       ▼ (saat exit)
  Baca $ZDOTDIR/.zlogout
  Baca /etc/zlogout
```

> **🔍 Visualisasi Sangat Membantu di Sini:** Diagram alur di atas akan lebih mudah dipahami jika divisualisasikan sebagai *decision tree* berwarna, di mana setiap node adalah pertanyaan (Login? Interactive?) dan setiap leaf adalah shell state. Buatlah diagram ini di tool seperti draw.io atau Excalidraw untuk referensi tim.

### Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Login Shell** | Shell yang dijalankan saat user login (SSH, TTY, `su -`). Membaca `.zprofile` dan `.zlogin` | `ssh user@server`, login via TTY |
| **Interactive Shell** | Shell yang terhubung ke terminal dan menunggu input user. Membaca `.zshrc` | Terminal di desktop, `tmux` session |
| **Non-Interactive Shell** | Shell yang menjalankan script tanpa interaksi user. Hanya membaca `.zshenv` | `zsh -c "echo hello"`, script cron |
| **`$ZDOTDIR`** | Environment variable yang menentukan direktori dotfiles Zsh. Jika kosong, menggunakan `$HOME` | `export ZDOTDIR="$HOME/.config/zsh"` |
| **`RCS` option** | Opsi Zsh yang mengontrol apakah startup files dibaca. Jika di-unset, tidak ada file RCS yang dibaca | `zsh -f` (fast startup, skip semua file) |
| **`GLOBAL_RCS` option** | Opsi yang hanya mengontrol file startup global (`/etc/zsh*`) | `setopt no_global_rcs` |
| **`zcompile`** | Builtin command untuk meng-compile file Zsh menjadi bytecode (`.zwc`), mempercepat loading | `zcompile .zshrc` |

### Hubungan dengan Modul Lain

Pemahaman startup files adalah **prasyarat langsung** untuk:
- **Sub-bab 2 (Sistem-wide vs Pengguna):** Anda tidak bisa merancang hierarki `/etc/zsh/` tanpa tahu file mana yang dibaca kapan
- **Sub-bab 3 (conf.d):** Loading modular via `for conf in /etc/zsh/conf.d/*.zsh(N)` hanya masuk akal jika Anda tahu bahwa ini ditempatkan di `.zshrc` atau `.zprofile`
- **Sub-bab 5 (GNU Stow):** Stow mengelola symlink untuk file-file ini; Anda perlu tahu file mana yang perlu di-symlink
- **Modul 6.2:** Kontribusi ke Zsh memerlukan pemahaman mendalam tentang bagaimana shell membaca konfigurasi

### Sumber Referensi Lengkap

- **Zsh Manual: Startup/Shutdown Files** — https://zsh.sourceforge.io/Doc/Release/Files.html#Startup_002fShutdown-Files
- **Zsh Manual: What to Put in Your Startup Files** — https://zsh.sourceforge.io/Guide/zshguide02.html
- **FreeBSD Man Page: zshall (Startup/Shutdown Files)** — https://man.freebsd.org/cgi/man.cgi?query=zshall#2
- **Zsh Manual: Invocation** — https://zsh.sourceforge.io/Doc/Release/Invocation.html

### Tips dan Praktik Terbaik

1. **Gunakan `zsh -f` untuk debugging.** Opsi `-f` (no rcs) melewati semua startup files. Jika masalah hilang dengan `-f`, masalahnya ada di startup files Anda.
2. **Jangan letakkan `PATH` setup di `.zshrc`.** Pindahkan ke `.zshenv` atau `.zprofile` untuk menghindari duplikasi PATH setiap kali shell baru dibuka.
3. **Gunakan `zcompile` untuk file startup besar.** Bytecode Zsh memuat lebih cepat dari source, terutama untuk file >1000 baris.
4. **Test dengan berbagai mode shell.** Setelah mengubah konfigurasi, test: `zsh -l` (login), `zsh -i` (interactive), `zsh -c "echo test"` (non-interactive), dan `zsh -f` (tanpa startup).
5. **Dokumentasikan setiap file.** Beri komentar header di setiap file startup yang menjelaskan *mengapa* file tersebut ada dan *apa* yang seharusnya (dan tidak seharusnya) ada di dalamnya.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Meletakkan plugin loading di `.zshenv` | Shell non-interactive (cron, scripts) memuat plugin yang tidak perlu → lambat, error | Pindahkan plugin loading ke `.zshrc` |
| PATH duplikat di setiap shell baru | `echo $PATH` menunjukkan `/usr/bin:/usr/bin:/usr/bin` berulang | Set PATH hanya di `.zshenv` atau gunakan `typeset -U path` untuk deduplikasi |
| Mengandalkan `.zshrc` untuk environment variable | Environment variable tidak tersedia di `ssh user@host command` | Set environment variable di `.zshenv` atau `.zprofile` |
| Tidak menggunakan `ZDOTDIR` | Dotfiles berantakan di `$HOME` | Set `ZDOTDIR="$HOME/.config/zsh"` di `/etc/zsh/zshenv` |
| File `.zlogout` tidak berjalan | Cleanup tidak terjadi | Pastikan shell adalah login shell dan tidak di-`exec` oleh proses lain |

---

## 2. Konfigurasi Sistem-Wide vs Pengguna

### Deskripsi Konkret & Peran dalam Kurikulum

Di lingkungan enterprise, Anda perlu membedakan antara konfigurasi yang **harus** diterapkan ke semua pengguna (kebijakan keamanan, PATH tools perusahaan, proxy settings) dan konfigurasi yang **boleh** dikustomisasi oleh masing-masing pengembang (alias, theme, editor preference).

Zsh menyediakan hierarki yang jelas: `/etc/zsh/` untuk konfigurasi sistem-wide, dan `$ZDOTDIR/` atau `$HOME/` untuk konfigurasi pengguna. Dengan memahami precedence (urutan prioritas) dan mekanisme override, Anda bisa merancang sistem di mana kebijakan perusahaan *selalu* diterapkan, sementara pengembang tetap memiliki kebebasan yang terkendali.

### Konsep Kunci & Filosofi Mendalam

**Analogi:** Bayangkan konfigurasi shell seperti sistem hukum. Ada **hukum federal** (`/etc/zsh/`) yang berlaku untuk semua warga dan tidak bisa dilanggar. Ada **peraturan daerah** (`$ZDOTDIR/`) yang bisa menambah atau memodifikasi selama tidak bertentangan dengan hukum federal. Dan ada **preferensi pribadi** (`.zshrc.local`) yang hanya berlaku untuk individu.

Kunci desainnya adalah: **file sistem-wide dibaca TERLEBIH DAHULU**, kemudian file pengguna. Ini berarti pengguna *bisa* menimpa (override) konfigurasi sistem, kecuali untuk hal-hal yang di-`readonly` atau di-set di `/etc/zshenv` (yang tidak bisa di-override).

**Filosofi Zero-Trust dalam konteks ini:** Jangan pernah mengasumsikan bahwa konfigurasi pengguna akan "benar". Sebaliknya, pastikan bahwa **bahkan jika pengguna memiliki `.zshrc` kosong atau rusak**, kebijakan keamanan fundamental tetap diterapkan melalui `/etc/zsh/zshenv` dan `/etc/zsh/zshrc`.

### Sintaks Dasar — Hierarki Enterprise

```bash
# ═══════════════════════════════════════════════════════════
# STRUKTUR DIREKTORI ENTERPRISE ZSH
# ═══════════════════════════════════════════════════════════

# /etc/zsh/ — Konfigurasi sistem-wide (di-manage oleh IT)
/etc/zsh/
├── zshenv              # Environment minimal (SEMUA shell)
├── zprofile            # Login shell environment
├── zshrc               # Interactive shell base config
├── zlogin              # Post-login actions
├── zlogout             # Pre-logout cleanup
└── conf.d/             # Konfigurasi modular
    ├── 00-base.zsh     # Foundation (PATH, locale)
    ├── 10-security.zsh # Kebijakan keamanan
    ├── 20-tools.zsh    # Tools perusahaan
    └── 30-prompt.zsh   # Prompt standar (opsional)

# $HOME/ — Konfigurasi pengguna (di-manage oleh developer)
$HOME/
├── .zshenv -> ~/dotfiles/zsh/.zshenv
├── .zshrc -> ~/dotfiles/zsh/.zshrc
└── .zshrc.local    # Override pribadi (TIDAK di-track)
```

**Mekanisme Loading di `.zshrc` Sistem:**

```bash
# /etc/zsh/zshrc — File ini dibaca oleh SEMUA interactive shell

# 1. Load konfigurasi modular sistem-wide
#    Pola glob (*.zsh(N)) dengan qualifier (N) = null_glob
#    Artinya: jika direktori kosong, loop tidak error
if [[ -d /etc/zsh/conf.d ]]; then
    for conf in /etc/zsh/conf.d/*.zsh(N); do
        source "$conf"
    done
fi

# 2. Setelah konfigurasi sistem, load konfigurasi pengguna
#    File .zshrc pengguna akan dibaca SETELAH ini oleh Zsh
#    (karena urutan: /etc/zshrc → $ZDOTDIR/.zshrc)

# 3. Terakhir, load override lokal pengguna
#    File ini TIDAK di-track di git — untuk preferensi mesin lokal
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
```

**Penjelasan Sintaks Zsh yang Digunakan:**

| Sintaks | Penjelasan |
|---|---|
| `for conf in pattern(N)` | Loop. `(N)` adalah glob qualifier yang berarti "null_glob" — jika tidak ada file yang cocok, ekspansi menjadi kosong (bukan error) |
| `*.zsh(N)` | Glob pattern dengan qualifier. `*` = wildcard, `.zsh` = ekstensi, `(N)` = null_glob |
| `source "$conf"` | Membaca dan mengeksekusi file di shell saat ini (bukan subshell) |
| `[[ -f "$HOME/.zshrc.local" ]]` | Test apakah file ada dan merupakan regular file |
| `&&` | Logical AND — jalankan perintah berikutnya hanya jika perintah sebelumnya sukses |

### Contoh Implementasi: Kebijakan Keamanan Enterprise

```bash
# /etc/zsh/conf.d/10-security.zsh
# Kebijakan keamanan yang SELALU diterapkan, tidak bisa di-override

# 1. Set history file ke lokasi terpusat (untuk audit)
#    Gunakan SECONDS dan hostname untuk filename unik
HISTFILE="/var/log/zsh_history/${USER}_${HOST}"
HISTSIZE=100000
SAVEHIST=100000

# 2. Paksa pencatatan timestamp di history (untuk audit trail)
setopt EXTENDED_HISTORY

# 3. Jangan simpan command yang diawali spasi (menghindari leak secrets)
setopt HIST_IGNORE_SPACE

# 4. Jangan izinkan penggunaan command yang berbahaya
#    dengan membuat alias yang menolak
alias rm='rm -I --preserve-root'
alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'

# 5. Set timeout untuk shell yang idle (detik)
#    TMOUT=3600 berarti shell exit setelah 1 jam idle
TMOUT=3600
setopt TMOUT

# 6. Batasi apa yang bisa di-override oleh pengguna
#    dengan membuat variabel readonly
readonly HISTFILE HISTSIZE SAVEHIST
```

> **🔍 Visualisasi Sangat Membantu di Sini:** Diagram *hierarchy precedence* — yang menunjukkan urutan `/etc/zsh/zshenv` → `/etc/zsh/zprofile` → `/etc/zsh/zshrc` → `$ZDOTDIR/.zshrc` → `$HOME/.zshrc.local` — akan sangat membantu untuk memahami kapan setiap konfigurasi bisa di-override. Buatlah diagram ini dengan panah yang menunjukkan arah pembacaan dan "override window" di setiap level.

### Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Sistem-wide** | Konfigurasi yang berlaku untuk semua pengguna di mesin | `/etc/zsh/zshrc` |
| **Per-user** | Konfigurasi spesifik pengguna | `$HOME/.zshrc` |
| **Precedence** | Urutan prioritas pembacaan file | Sistem dibaca dulu, pengguna menimpa |
| **Override** | Menimpa nilai yang sudah di-set | `alias ls='eza'` di `.zshrc` menimpa alias sistem |
| **`readonly`** | Builtin Zsh untuk membuat variabel tidak bisa diubah | `readonly HISTFILE` |
| **`TMOUT`** | Variabel Zsh yang menyebabkan shell exit setelah N detik idle | `TMOUT=3600` |
| **`SECONDS`** | Variabel built-in Zsh yang menghitung detik sejak shell dimulai | Berguna untuk logging |

### Hubungan dengan Modul Lain

- **Sub-bab 1 (Startup Files):** Hierarki ini adalah *aplikasi praktis* dari urutan startup yang sudah dipelajari
- **Sub-bab 3 (conf.d):** Pola `for conf in /etc/zsh/conf.d/*.zsh(N)` yang diperkenalkan di sini akan diperdalam
- **Sub-bab 5 (GNU Stow):** Konfigurasi pengguna akan di-deploy menggunakan Stow
- **Sub-bab 6 (Ansible):** Konfigurasi sistem-wide akan di-deploy menggunakan Ansible

### Sumber Referensi Lengkap

- **Zsh Manual: Files** — https://zsh.sourceforge.io/Doc/Release/Files.html#Startup_002fShutdown-Files
- **FreeBSD Man: zshall (RCS/GLOBAL_RCS options)** — https://man.freebsd.org/cgi/man.cgi?query=zshall#2
- **Arch Linux Wiki: Zsh** — https://wiki.archlinux.org/title/Zsh

### Tips dan Praktik Terbaik

1. **Selalu test konfigurasi sistem-wide dengan user baru.** Buat test user (`useradd testuser`), login sebagai user tersebut, dan verifikasi bahwa konfigurasi berjalan tanpa error.
2. **Gunakan komentar header di setiap file `/etc/zsh/`.** Jelaskan tujuan file, siapa yang boleh mengubah, dan apa yang tidak boleh diubah.
3. **Dokumentasikan kebijakan override.** Beri tahu pengembang apa yang boleh dan tidak boleh di-override di `.zshrc.local`.
4. **Gunakan `readonly` secara hati-hati.** Terlalu banyak `readonly` membuat pengembang frustrasi; terlalu sedikit membuat kebijakan tidak efektif.
5. **Version control untuk `/etc/zsh/`.** Gunakan Git untuk melacak perubahan konfigurasi sistem-wide, sama seperti Anda melacak dotfiles.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Mengedit `/etc/zsh/zshenv` tanpa backup | Sistem shell rusak, tidak bisa login | Selalu backup sebelum edit: `cp /etc/zsh/zshenv{,.bak}` |
| Konflik antara alias sistem dan pengguna | Alias sistem di-override tanpa sepengetahuan | Gunakan komentar jelas di `/etc/zsh/conf.d/` tentang alias yang "reserved" |
| `readonly` pada variabel yang salah | Pengguna tidak bisa set PATH mereka sendiri | Hanya `readonly` variabel yang benar-benar kritis (HISTFILE, keamanan) |
| Tidak ada fallback jika `.zshrc.local` error | Shell gagal startup | Bungkus dengan `[[ -f ... ]] && source ... 2>/dev/null` |

---

## 3. Modular Configuration dengan conf.d

### Deskripsi Konkret & Peran dalam Kurikulum

Pola `conf.d` adalah cara untuk memecah konfigurasi besar menjadi file-file kecil yang dapat dikelola secara independen. Ini adalah pola yang sudah lazim di Linux (digunakan oleh `rsyslog`, `nginx`, `sysctl`, dll.) dan sangat cocok untuk konfigurasi Zsh enterprise.

Di tingkat enterprise, `conf.d` memungkinkan:
- **Tim berbeda bertanggung jawab atas file berbeda** (tim keamanan mengelola `10-security.zsh`, tim DevOps mengelola `20-tools.zsh`)
- **Rollback granular** — jika `20-tools.zsh` bermasalah, cukup disable file itu tanpa menyentuh seluruh konfigurasi
- **Dependency ordering** — file di-load dalam urutan numerik, sehingga `00-base.zsh` selalu di-load sebelum `10-security.zsh`

### Konsep Kunci & Filosofi Mendalam

**Filosofi Unix: "Do one thing and do it well."** Setiap file dalam `conf.d` harus memiliki satu tanggung jawab yang jelas. File `00-base.zsh` hanya mengatur fondasi (PATH, locale, editor). File `10-security.zsh` hanya mengatur kebijakan keamanan. File `20-tools.zsh` hanya mengatur tools perusahaan.

**Mengapa numerik?** Zsh membaca file dalam urutan alfabetis. Dengan prefix numerik (`00-`, `10-`, `20-`), Anda mendapatkan kontrol penuh atas urutan loading. Celah angka (0-9, 10-19, 20-29) memberikan ruang untuk menyisipkan file di antara yang sudah ada tanpa harus rename semuanya.

### Sintaks Dasar — Modular Loading

```bash
# /etc/zsh/zshrc — Loading modular

# Pola dasar: load semua *.zsh di conf.d dalam urutan numerik
# (N) = null_glob: jika tidak ada file, loop tidak error
for conf in /etc/zsh/conf.d/*.zsh(N); do
    source "$conf"
done
```

**Penjelasan Sintaks Zsh (kata demi kata):**

```bash
for conf in /etc/zsh/conf.d/*.zsh(N); do
#  │    │    │                    │  │
#  │    │    │                    │  └── (N) = glob qualifier "null_glob"
#  │    │    │                    │        Jika tidak ada file cocok,
#  │    │    │                    │        ekspansi menjadi kosong (bukan error)
#  │    │    │                    │
#  │    │    │                    └────── * = wildcard (semua karakter)
#  │    │    │
#  │    │    └────────────────────────── /etc/zsh/conf.d/ = direktori konfigurasi
#  │    │
#  │    └─────────────────────────────── variabel loop (nama file)
#  │
#  └──────────────────────────────────── perintah loop Zsh

    source "$conf"
#   │      │
#   │      └── $conf = nilai variabel loop (path file lengkap)
#   │
#   └── source = builtin Zsh untuk membaca & eksekusi file
#               di shell SAAT INI (bukan subshell)

done
```

**Struktur File yang Direkomendasikan:**

```bash
/etc/zsh/conf.d/
├── 00-base.zsh          # PATH, locale, EDITOR, umask
├── 05-os-detect.zsh     # Deteksi OS, set OS-specific variables
├── 10-security.zsh      # Kebijakan keamanan, audit, TMOUT
├── 15-proxy.zsh         # Proxy settings (jika di belakang corporate proxy)
├── 20-tools.zsh         # Tools perusahaan (kubectl, aws, gcloud, dll.)
├── 25-completion.zsh    # Completion system setup
├── 30-prompt.zsh        # Prompt standar perusahaan (opsional)
├── 35-plugins.zsh       # Plugin loading (jika menggunakan plugin manager)
└── 90-local.zsh         # Local overrides (untuk testing)
```

**Contoh Setiap File:**

```bash
# /etc/zsh/conf.d/00-base.zsh — FONDASI
# Mengatur environment variable fundamental untuk semua pengguna.

# Pastikan PATH tidak duplikat
typeset -U path PATH

# Tambahkan direktori tools perusahaan di depan PATH
path=("/opt/company/bin" $path)

# Umask: file baru tidak bisa diakses group/others
umask 022

# Locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Editor default (bisa di-override pengguna)
export EDITOR="${EDITOR:-vim}"
```

```bash
# /etc/zsh/conf.d/10-security.zsh — KEAMANAN
# Kebijakan keamanan yang tidak boleh di-override.

# History: lokasi terpusat, format extended, jangan simpan command diawali spasi
HISTFILE="/var/log/zsh_history/${USER}_${HOST}"
HISTSIZE=100000
SAVEHIST=100000
setopt EXTENDED_HISTORY HIST_IGNORE_SPACE

# Timeout untuk shell idle
TMOUT=3600
setopt TMOUT

# Aliases yang menolak operasi berbahaya
alias rm='rm -I --preserve-root'
alias chmod='chmod --preserve-root'

# Log semua command yang dijalankan (opsional, untuk audit ketat)
# CATATAN: Ini bisa memperlambat shell jika logging synchronous
# preexec() {
#     echo "$(date '+%Y-%m-%d %H:%M:%S') | ${USER} | ${HOST} | ${1}" \
#         >> /var/log/company/zsh_audit.log
# }
# preexec_functions+=(preexec)
```

```bash
# /etc/zsh/conf.d/20-tools.zsh — TOOLS PERUSAHAAN
# Konfigurasi untuk tools yang digunakan perusahaan.

# Kubernetes
export KUBECONFIG="${HOME}/.kube/config:/opt/company/kube/config"

# AWS CLI
export AWS_PROFILE="${AWS_PROFILE:-default}"
export AWS_CONFIG_FILE="/opt/company/aws/config"

# Google Cloud
if [[ -f /opt/company/gcloud/path.zsh.inc ]]; then
    source /opt/company/gcloud/path.zsh.inc
fi

# Fungsi helper perusahaan
company-login() {
    local env="${1:-staging}"
    echo "Logging into ${env} environment..."
    # ... login logic ...
}
```

### Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **`conf.d`** | Direktori konfigurasi modular yang lazim di Linux | `/etc/zsh/conf.d/`, `/etc/nginx/conf.d/` |
| **Glob qualifier `(N)`** | Qualifier Zsh yang berarti "null_glob" — tidak error jika tidak ada match | `*.zsh(N)` |
| **`typeset -U`** | Membuat variabel "unique" — elemen array tidak duplikat | `typeset -U path` |
| **`path`** | Array Zsh yang terhubung ke `$PATH` | `path=("/usr/local/bin" $path)` |
| **`umask`** | Bit mask yang menentukan permission default file baru | `umask 022` |
| **`preexec`** | Hook Zsh yang dijalankan *sebelum* setiap command dieksekusi | Berguna untuk logging/audit |
| **`precmd`** | Hook Zsh yang dijalankan *sebelum* prompt ditampilkan | Berguna untuk update prompt info |

### Hubungan dengan Modul Lain

- **Sub-bab 1 & 2:** `conf.d` adalah implementasi praktis dari startup files dan hierarki sistem/user
- **Sub-bab 5 (GNU Stow):** Stow juga menggunakan konsep "package" yang mirip dengan `conf.d`
- **Sub-bab 6 (Ansible):** Ansible akan men-deploy file-file `conf.d` ini ke server
- **Sub-bab 7 (Plugin):** `35-plugins.zsh` adalah tempat yang tepat untuk inisialisasi plugin manager

### Sumber Referensi Lengkap

- **Zsh Manual: Anonymous Functions & Glob Qualifiers** — https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers
- **Zsh Manual: `typeset` builtin** — https://zsh.sourceforge.io/Doc/Release/Shell-Builtin-Commands.html
- **Arch Wiki: Zsh (modular config)** — https://wiki.archlinux.org/title/Zsh#A_modular_alternative
- **GitHub: `.p10k.zsh.d` — Modular Powerlevel10k config** — https://github.com/emamoah/.p10k.zsh.d
- **GitHub: Modularized-Shell-Runtime-Config** — https://github.com/ChristianSilvermoon/Modularized-Shell-Runtime-Config

### Tips dan Praktik Terbaik

1. **Gunakan nomor dengan celah.** Jangan gunakan `1, 2, 3` — gunakan `00, 10, 20` sehingga Anda bisa menyisipkan `05` nanti tanpa rename.
2. **Satu file, satu tanggung jawab.** Jika file mulai melebihi 50 baris, pertimbangkan untuk memecahnya.
3. **Dokumentasikan dependency.** Jika `20-tools.zsh` membutuhkan PATH yang di-set di `00-base.zsh`, tulis di komentar header.
4. **Test loading order.** Gunakan `zsh -xvs 2>&1 | head -100` untuk melihat urutan file yang di-load.
5. **Sediakan mekanisme disable.** Jika ada file yang bermasalah, tim harus bisa disable tanpa menghapus file — misalnya dengan rename ke `.zsh.disabled`.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| File di `conf.d` tidak terbaca | Konfigurasi tidak diterapkan | Pastikan glob pattern benar: `*.zsh` bukan `*.zshrc` |
| Loading order salah | Variabel belum di-set saat digunakan | Gunakan prefix numerik dan dokumentasikan dependency |
| File dengan nama salah | File tidak di-load karena pattern tidak match | Konsisten dengan ekstensi `.zsh` |
| Duplikasi kode antar file | Konflik antar tim | Review berkala dan extract common code ke `00-base.zsh` |

---

## 4. XDG Base Directory & ZDOTDIR [TAMBAHAN AUDIT]

> **📌 Mengapa Materi Ini Ditambahkan:** Kurikulum asli tidak menyebut XDG Base Directory Specification, padahal ini adalah standar modern untuk lokasi konfigurasi di Linux dan macOS. Di lingkungan enterprise, XDG compliance adalah praktik terbaik yang memisahkan konfigurasi (`~/.config`), cache (`~/.cache`), dan data (`~/.local/share`) — memudahkan backup, audit, dan deployment.

### Deskripsi Konkret & Peran dalam Kurikulum

XDG Base Directory Specification adalah standar freedesktop.org yang mendefinisikan lokasi standar untuk file konfigurasi, cache, dan data. Dengan mengikuti standar ini, Anda menghindari "home directory pollution" — di mana setiap tool menumpuk file dotfiles di `$HOME`.

Untuk Zsh, ada dua aspek:
1. **`$ZDOTDIR`** — memindahkan dotfiles Zsh dari `$HOME` ke lokasi XDG-compliant (misalnya `~/.config/zsh/`)
2. **XDG variables** — memastikan tools lain (history file, completion cache) juga mengikuti XDG

### Konsep Kunci & Filosofi Mendalam

**Masalah:** Secara default, Zsh mencari `.zshenv`, `.zshrc`, dll. di `$HOME`. Jika Anda memiliki 10 tools yang masing-masing menaruh 2-3 file di `$HOME`, Anda memiliki 20-30 file dotfiles berantakan di home directory.

**Solusi XDG:** Standar ini mendefinisikan:
- `$XDG_CONFIG_HOME` (default: `~/.config`) — untuk konfigurasi
- `$XDG_CACHE_HOME` (default: `~/.cache`) — untuk cache (bisa dihapus kapan saja)
- `$XDG_DATA_HOME` (default: `~/.local/share`) — untuk data yang perlu persist
- `$XDG_STATE_HOME` (default: `~/.local/state`) — untuk state (history, logs)

### Sintaks Dasar — Migrasi ke XDG

**Langkah 1: Set `ZDOTDIR` di `/etc/zsh/zshenv`**

```bash
# /etc/zsh/zshenv — TAMBAHKAN INI di bagian atas

# Jika ZDOTDIR belum di-set, gunakan ~/.config/zsh
# Ini HARUS di /etc/zsh/zshenv karena file ini dibaca sebelum
# Zsh mencari $ZDOTDIR/.zshenv
if [[ -z "$ZDOTDIR" ]]; then
    export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
fi
```

**Mengapa di `/etc/zsh/zshenv`?** Karena Zsh menggunakan `$ZDOTDIR` untuk mencari `.zshenv`. Jika Anda set `ZDOTDIR` di `.zshenv`, sudah terlambat — Zsh sudah mencari di lokasi default.

**Langkah 2: Pindahkan dotfiles ke lokasi XDG**

```bash
# Sebelum:
# ~/.zshenv, ~/.zshrc, ~/.zprofile, dll.

# Sesudah:
# ~/.config/zsh/.zshenv
# ~/.config/zsh/.zshrc
# ~/.config/zsh/.zprofile
```

**Langkah 3: Set XDG variables untuk Zsh history**

```bash
# ~/.config/zsh/.zshrc — XDG-compliant history

# History di XDG_STATE_HOME (bukan $HOME)
# State = data yang berubah dan perlu persist (history, logs)
export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "${HISTFILE:h}"  # ${HISTFILE:h} = head (dirname) dari path

# Completion cache di XDG_CACHE_HOME
# Cache = data yang bisa di-regenerate (completion dump)
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
autoload -Uz compinit && compinit -d "$ZSH_COMPDUMP"
```

**Penjelasan Sintaks Zsh:**

| Sintaks | Penjelasan |
|---|---|
| `${XDG_CONFIG_HOME:-$HOME/.config}` | Parameter expansion dengan default. Jika `$XDG_CONFIG_HOME` kosong, gunakan `$HOME/.config` |
| `${HISTFILE:h}` | Modifier `:h` = head (dirname). `path/to/file` → `path/to` |
| `mkdir -p` | Membuat direktori beserta parent-nya jika belum ada |
| `compinit -d "$ZSH_COMPDUMP"` | `compinit` dengan opsi `-d` untuk menentukan lokasi dump file |

### Terminologi Esensial

| Istilah | Definisi | Default |
|---|---|---|
| **XDG_CONFIG_HOME** | Lokasi konfigurasi | `~/.config` |
| **XDG_CACHE_HOME** | Lokasi cache (bisa dihapus) | `~/.cache` |
| **XDG_DATA_HOME** | Lokasi data persist | `~/.local/share` |
| **XDG_STATE_HOME** | Lokasi state (history, logs) | `~/.local/state` |
| **`$ZDOTDIR`** | Direktori dotfiles Zsh | `$HOME` (default) |
| **`:h` modifier** | Head/dirname dari path | `${path:h}` |

### Hubungan dengan Modul Lain

- **Sub-bab 1:** XDG mempengaruhi *di mana* Zsh mencari startup files
- **Sub-bab 5 (GNU Stow):** Stow packages akan di-symlink ke `~/.config/zsh/` bukan `$HOME`
- **Sub-bab 6 (Ansible):** Deployment harus menargetkan path XDG yang benar

### Sumber Referensi Lengkap

- **XDG Base Directory Specification** — https://specifications.freedesktop.org/basedir-spec/latest/
- **Zsh Manual: `$ZDOTDIR`** — https://zsh.sourceforge.io/Doc/Release/Parameters.html
- **GitHub: xdg-basedirs plugin for Oh-My-Zsh** — https://github.com/krahlos/xdg-basedirs
- **Arch Wiki: XDG Base Directory** — https://wiki.archlinux.org/title/XDG_Base_Directory

### Tips dan Praktik Terbaik

1. **Set `ZDOTDIR` di `/etc/zsh/zshenv`**, bukan di file lain. Ini adalah satu-satunya tempat yang dijamin dieksekusi sebelum Zsh mencari dotfiles.
2. **Jangan pindahkan `.zshenv` ke XDG.** `.zshenv` *harus* ada di `$HOME` atau di lokasi yang diketahui Zsh sebelum `ZDOTDIR` di-set. Jika Anda set `ZDOTDIR` di `/etc/zsh/zshenv`, maka `$ZDOTDIR/.zshenv` akan dibaca.
3. **Gunakan `$XDG_STATE_HOME` untuk history**, bukan `$XDG_DATA_HOME`. History adalah state (berubah seiring waktu), bukan data statis.
4. **Beri tahu pengguna.** Migrasi ke XDG akan memutus symlink yang ada; komunikasikan dengan tim sebelum migrasi.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Set `ZDOTDIR` di `.zshenv` | `.zshenv` baru tidak terbaca | Set di `/etc/zsh/zshenv` |
| Lupa `mkdir -p` untuk HISTFILE | History tidak tersimpan, error "no such file" | Tambahkan `mkdir -p "${HISTFILE:h}"` |
| `compinit` dump di lokasi read-only | Error permission saat shell startup | Gunakan `$XDG_CACHE_HOME` yang writable |
| Migrasi tanpa update symlink Stow | Dotfiles tidak terbaca | Jalankan ulang `stow -t ~/.config/zsh zsh` |

---

## 5. Manajemen Dotfiles: GNU Stow

### Deskripsi Konkret & Peran dalam Kurikulum

GNU Stow adalah "symlink farm manager" — alat yang mengotomatiskan pembuatan symlink dari repository dotfiles ke lokasi targetnya. Di tingkat enterprise, Stow memungkinkan Anda untuk:
- Menyimpan semua dotfiles dalam satu Git repository
- Mengelompokkan dotfiles menjadi "packages" logis (zsh, git, vim, tmux)
- Men-deploy package dengan satu perintah (`stow zsh`)
- Rollback dengan satu perintah (`stow -D zsh`)

### Konsep Kunci & Filosofi Mendalam

**Bayangkan Stow seperti sistem rak gudang.** Anda memiliki kotak-kotak (packages) yang berisi barang (dotfiles). Setiap kotak diberi label (nama package). Ketika Anda perlu barang tertentu, Anda "stow" kotak itu ke rak (home directory) — Stow secara otomatis membuat "jalur" (symlink) dari rak ke barang di gudang.

**Mengapa symlink?** Symlink memungkinkan file *terlihat* di `$HOME` (sehingga Zsh bisa membacanya) tetapi *tersimpan* di Git repository (sehingga bisa di-version control). Ini memisahkan "lokasi fisik" dari "lokasi logis".

### Sintaks Dasar — Setup dan Workflow

**Struktur Repository:**

```bash
~/dotfiles/                    # Git repository
├── zsh/                       # Package "zsh"
│   ├── .zshenv
│   ├── .zshrc
│   └── .config/
│       └── zsh/
│           └── conf.d/
│               └── 00-base.zsh
├── git/                       # Package "git"
│   └── .gitconfig
└── vim/                       # Package "vim"
    └── .vimrc
```

**Cara Kerja Stow:**

```bash
~/dotfiles/zsh/.zshrc  ──(stow zsh)──>  ~/.zshrc (symlink)
~/dotfiles/zsh/.zshenv ──(stow zsh)──>  ~/.zshenv (symlink)

~/.zshrc → ~/dotfiles/zsh/.zshrc  (symlink)
```

**Perintah Stow:**

```bash
# Install GNU Stow
# macOS:
brew install stow
# Debian/Ubuntu:
sudo apt install stow

# Masuk ke direktori dotfiles
cd ~/dotfiles

# Stow package "zsh" ke home directory
stow zsh

# Stow multiple packages sekaligus
stow zsh git vim

# Stow ke target directory tertentu (misalnya untuk XDG)
stow -t ~/.config/zsh zsh

# Unstow (hapus symlink)
stow -D zsh

# Restow (update symlink setelah menambah file baru)
stow -R zsh

# Dry run (lihat apa yang akan dilakukan tanpa eksekusi)
stow -n -v zsh
```

**Penjelasan Flag Stow:**

| Flag | Nama | Fungsi |
|---|---|---|
| `-t` | `--target` | Direktori target (default: parent dari direktori dotfiles) |
| `-D` | `--delete` | Hapus symlink (unstow) |
| `-R` | `--restow` | Unstow + stow ulang (refresh symlink) |
| `-n` | `--no` | Dry run — tampilkan apa yang akan dilakukan |
| `-v` | `--verbose` | Tampilkan output detail |

### Alur Kerja Enterprise

```bash
┌─────────────────────────────────────────────────────────────┐
│                 WORKFLOW ENTERPRISE STOW                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Developer baru cloning repository:                      │
│     git clone https://git.company.com/dotfiles.git ~/dotfiles│
│                                                             │
│  2. Masuk ke direktori:                                     │
│     cd ~/dotfiles                                           │
│                                                             │
│  3. Stow package yang dibutuhkan:                           │
│     stow zsh git tmux                                       │
│                                                             │
│  4. Verifikasi:                                             │
│     ls -la ~/.zshrc  # → symlink ke ~/dotfiles/zsh/.zshrc   │
│                                                             │
│  5. Jika ada update dari repository:                        │
│     git pull                                                │
│     stow -R zsh  # refresh symlink (jika ada file baru)     │
│                                                             │
│  6. Jika ingin menambah file baru ke package:               │
│     # Letakkan file di ~/dotfiles/zsh/                      │
│     stow -R zsh  # refresh symlink                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Symlink** | Symbolic link — file yang menunjuk ke file lain | `~/.zshrc → ~/dotfiles/zsh/.zshrc` |
| **Stow package** | Direktori dalam repository yang berisi dotfiles untuk satu tool | `~/dotfiles/zsh/` |
| **Stow directory** | Direktori yang berisi packages | `~/dotfiles/` |
| **Target directory** | Direktori tempat symlink dibuat | `$HOME` atau `~/.config/zsh/` |
| **Stow** | Membuat symlink dari target ke package | `stow zsh` |
| **Unstow** | Menghapus symlink | `stow -D zsh` |
| **Restow** | Unstow + stow (refresh) | `stow -R zsh` |
| **Symlink farm** | Kumpulan symlink yang dikelola secara terpusat | Dotfiles repository |

### Contoh: Stow dengan XDG Structure

```bash
# Struktur repository untuk XDG compliance
~/dotfiles/
├── zsh/
│   ├── .config/
│   │   └── zsh/
│   │       ├── .zshenv
│   │       ├── .zshrc
│   │       └── conf.d/
│   │           └── 00-base.zsh
│   └── .local/
│       └── state/
│           └── zsh/          # history akan disimpan di sini
└── git/
    └── .config/
        └── git/
            └── config

# Stow ke home directory (symlink ~/.config/zsh → ~/dotfiles/zsh/.config/zsh)
stow -t ~ zsh

# Hasil:
# ~/.config/zsh/.zshenv → ~/dotfiles/zsh/.config/zsh/.zshenv
# ~/.config/zsh/.zshrc  → ~/dotfiles/zsh/.config/zsh/.zshrc
```

### Hubungan dengan Modul Lain

- **Sub-bab 1-3:** Stow mengelola file-file startup yang sudah dipelajari
- **Sub-bab 4 (XDG):** Stow harus di-konfigurasi untuk menargetkan path XDG
- **Sub-bab 6 (Ansible):** Stow bisa dipanggil oleh Ansible sebagai langkah deployment
- **Modul 6.3 Jalur C:** Membangun CLI tools dengan Zsh — Stow adalah bagian dari tooling workflow

### Sumber Referensi Lengkap

- **GNU Stow Official** — https://www.gnu.org/software/stow/
- **GNU Stow Manual** — https://www.gnu.org/software/stow/manual/
- **Tutorial: How to Manage Dotfiles Using GNU Stow** — https://shibisuriya.github.io/blog/how-to-manage-dotfiles-using-gnu-stow
- **GitHub: dotfiles.github.io** — https://dotfiles.github.io/
- **GitHub: nafaaal/dotfiles (contoh Stow)** — https://github.com/nafaalal/dotfiles

### Tips dan Praktik Terbaik

1. **Selalu dry-run terlebih dahulu.** Gunakan `stow -n -v` untuk melihat apa yang akan di-symlink sebelum eksekusi.
2. **Gunakan `stow -R` setelah git pull.** Jika ada file baru di repository, symlink perlu di-refresh.
3. **Jangan stow semua package sekaligus.** Stow hanya package yang Anda butuhkan di mesin tersebut.
4. **Hati-hati dengan konflik.** Jika `~/.zshrc` sudah ada (bukan symlink), Stow akan menolak. Backup dulu atau hapus.
5. **Dokumentasikan struktur package.** Buat `README.md` di root repository yang menjelaskan setiap package.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| `~/.zshrc` sudah ada (bukan symlink) | Stow error "existing target is not a symlink" | `mv ~/.zshrc ~/.zshrc.bak` lalu stow |
| Stow dijalankan dari direktori salah | Stow tidak menemukan packages | Selalu `cd ~/dotfiles` dulu |
| File baru tidak ter-symlink | File tidak muncul di target | `stow -R package_name` |
| Target directory salah | Symlink dibuat di tempat yang salah | Gunakan `-t` untuk menentukan target |
| Unstow tidak menghapus symlink | Symlink rusak (dangling) | `stow -D package_name` dari direktori yang benar |

---

## 6. Deployment Enterprise: Ansible

### Deskripsi Konkret & Peran dalam Kurikulum

Ansible adalah alat manajemen konfigurasi yang memungkinkan Anda men-deploy dotfiles dan konfigurasi Zsh ke banyak mesin secara otomatis. Di tingkat enterprise, Ansible digunakan untuk:
- **Onboarding pengembang baru** — satu perintah untuk setup environment lengkap
- **Konsistensi konfigurasi** — memastikan semua mesin tim memiliki konfigurasi yang sama
- **Audit dan compliance** — memverifikasi bahwa kebijakan diterapkan
- **Rollback** — kembali ke konfigurasi sebelumnya jika ada masalah

### Konsep Kunci & Filosofi Mendalam

**Filosofi Ansible: "Idempotent, agentless, dan human-readable."**

- **Idempotent** berarti menjalankan playbook yang sama dua kali tidak akan mengubah apa pun jika state sudah sesuai. Ini berbeda dengan shell script biasa yang mungkin menambahkan PATH duplikat setiap kali dijalankan.
- **Agentless** berarti tidak perlu install agent di mesin target — cukup SSH dan Python.
- **Human-readable** berarti playbook ditulis dalam YAML yang bisa dibaca bahkan oleh non-developer.

**Mengapa Ansible untuk dotfiles?** Karena dotfiles enterprise bukan hanya tentang file `.zshrc` — ini tentang *memastikan* bahwa semua prasyarat (git, zsh, tools) terinstall, bahwa file berada di lokasi yang benar, dan bahwa konfigurasi sistem-wide (`/etc/zsh/`) juga diterapkan.

### Sintaks Dasar — Ansible Playbook untuk Dotfiles

**Struktur Role:**

```bash
ansible-dotfiles/
├── playbook.yml
├── inventory.ini
└── roles/
    └── zsh-config/
        ├── tasks/
        │   └── main.yml
        ├── defaults/
        │   └── main.yml
        ├── templates/
        │   └── zshenv.j2
        └── files/
            └── .zshrc
```

**`defaults/main.yml` — Variabel Default:**

```yaml
# roles/zsh-config/defaults/main.yml

# Repository dotfiles
dotfiles_repo: "https://git.company.com/dotfiles.git"
dotfiles_repo_version: "main"

# Lokasi clone lokal
dotfiles_local_destination: "~/dotfiles"

# Home directory target
dotfiles_home: "~"

# File yang akan di-symlink
dotfiles_files:
  - .zshrc
  - .zshenv
  - .zprofile

# Konfigurasi sistem-wide
zsh_system_wide: true
zsh_conf_d_files:
  - 00-base.zsh
  - 10-security.zsh
  - 20-tools.zsh
```

**`tasks/main.yml` — Task Utama:**

```yaml
# roles/zsh-config/tasks/main.yml

---
# 1. Pastikan Git terinstall
- name: Ensure git is installed
  package:
    name: git
    state: present

# 2. Clone dotfiles repository
- name: Clone dotfiles repository
  git:
    repo: "{{ dotfiles_repo }}"
    dest: "{{ dotfiles_local_destination }}"
    version: "{{ dotfiles_repo_version }}"
    update: yes
  become: no

# 3. Symlink dotfiles ke home directory
- name: Symlink dotfiles
  file:
    src: "{{ dotfiles_local_destination }}/{{ item }}"
    dest: "{{ dotfiles_home }}/{{ item }}"
    state: link
    force: yes
  loop: "{{ dotfiles_files }}"
  become: no

# 4. Deploy konfigurasi sistem-wide (jika diaktifkan)
- name: Deploy system-wide conf.d files
  copy:
    src: "{{ item }}"
    dest: "/etc/zsh/conf.d/{{ item }}"
    owner: root
    group: root
    mode: '0644'
  loop: "{{ zsh_conf_d_files }}"
  when: zsh_system_wide
  become: yes

# 5. Verifikasi konfigurasi
- name: Verify zsh configuration
  command: zsh -n -c 'source /etc/zsh/zshenv'
  changed_when: false
  ignore_errors: yes
```

**`playbook.yml` — Playbook Utama:**

```yaml
# playbook.yml
---
- hosts: developers
  roles:
    - zsh-config
```

**Menjalankan Playbook:**

```bash
# Jalankan playbook pada semua host di group "developers"
ansible-playbook -i inventory.ini playbook.yml

# Jalankan dengan verbose output
ansible-playbook -i inventory.ini playbook.yml -v

# Jalankan pada host tertentu
ansible-playbook -i inventory.ini playbook.yml --limit dev-machine-01

# Dry run (check mode)
ansible-playbook -i inventory.ini playbook.yml --check

# Hanya jalankan task tertentu (tags)
ansible-playbook -i inventory.ini playbook.yml --tags "dotfiles"
```

**Penjelasan Sintaks YAML Ansible:**

| Sintaks | Penjelasan |
|---|---|
| `---` | Penanda awal dokumen YAML |
| `- name:` | Nama task (deskripsi manusiawi) |
| `package:` | Modul Ansible untuk manajemen package |
| `git:` | Modul Ansible untuk clone/update Git repository |
| `file:` | Modul Ansible untuk manajemen file/symlink |
| `copy:` | Modul Ansible untuk copy file ke target |
| `loop:` | Iterasi (seperti `for` loop di shell) |
| `when:` | Kondisi (task hanya dijalankan jika kondisi terpenuhi) |
| `become: yes` | Jalankan dengan privilege escalation (sudo) |
| `become: no` | Jalankan sebagai user biasa |

### Alur Kerja Ansible Deployment

```bash
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Control     │     │  Managed     │     │  Managed     │
│  Node        │────>│  Node 1      │     │  Node 2      │
│  (Ansible)   │ SSH │  (Developer  │     │  (Developer  │
│              │     │   Workstation)│     │   Workstation)│
└──────────────┘     └──────────────┘     └──────────────┘
       │                    │                    │
       │  1. Baca inventory │                    │
       │  2. Jalankan tasks │                    │
       │  3. Verifikasi     │                    │
       ▼                    ▼                    ▼
  playbook.yml        Konfigurasi          Konfigurasi
                      diterapkan           diterapkan
```

> **🔍 Visualisasi Sangat Membantu di Sini:** Diagram arsitektur Ansible — yang menunjukkan Control Node di kiri dan Managed Nodes di kanan, dengan panah SSH — akan sangat membantu untuk memahami model agentless. Tambahkan juga diagram *idempotency*: jalankan pertama kali (perubahan terjadi) vs jalankan kedua kali (tidak ada perubahan).

### Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Playbook** | File YAML yang mendefinisikan tasks | `playbook.yml` |
| **Role** | Kumpulan tasks, variables, dan files untuk satu tujuan | `roles/zsh-config/` |
| **Task** | Satu unit kerja dalam playbook | "Clone dotfiles repository" |
| **Inventory** | File yang mendaftarkan host target | `inventory.ini` |
| **Idempotent** | Dijalankan berkali-kali menghasilkan state yang sama | `file: state=link` |
| **Control Node** | Mesin yang menjalankan Ansible | Laptop admin |
| **Managed Node** | Mesin yang dikonfigurasi oleh Ansible | Workstation developer |
| **`become`** | Privilege escalation (sudo) | `become: yes` |
| **`loop`** | Iterasi dalam task | `loop: "{{ dotfiles_files }}"` |
| **`when`** | Kondisi untuk menjalankan task | `when: zsh_system_wide` |

### Hubungan dengan Modul Lain

- **Sub-bab 1-3:** Ansible men-deploy file startup dan `conf.d` yang sudah dipelajari
- **Sub-bab 4 (XDG):** Ansible harus menargetkan path XDG yang benar
- **Sub-bab 5 (GNU Stow):** Ansible bisa memanggil Stow sebagai task
- **Sub-bab 8 (Onboarding):** Ansible adalah tulang punggung automasi onboarding

### Sumber Referensi Lengkap

- **Ansible Documentation** — https://docs.ansible.com/
- **Ansible: Roles** — https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html
- **GitHub: geerlingguy/ansible-role-dotfiles** — https://github.com/geerlingguy/ansible-role-dotfiles
- **GitHub: sloria/dotfiles as Ansible roles** — https://github.com/sloria/dotfiles

### Tips dan Praktik Terbaik

1. **Selalu test dengan `--check` terlebih dahulu.** Ini adalah mode dry-run Ansible yang menunjukkan apa yang akan berubah tanpa benar-benar mengubah.
2. **Gunakan `--diff` bersama `--check`.** Ini menunjukkan perbedaan file yang akan diubah.
3. **Pisahkan role berdasarkan tanggung jawab.** `zsh-config`, `git-config`, `tools` — masing-masing role fokus pada satu area.
4. **Gunakan `become: no` untuk task pengguna.** Hanya gunakan `become: yes` untuk task yang membutuhkan root (deploy `/etc/zsh/`).
5. **Verifikasi setelah deployment.** Tambahkan task yang memverifikasi konfigurasi (seperti `zsh -n`) di akhir playbook.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Task tidak idempotent | PATH bertambah setiap kali playbook dijalankan | Gunakan modul Ansible (`file`, `copy`) bukan `command`/`shell` |
| `become` salah | Task gagal karena permission | `become: no` untuk task pengguna, `become: yes` untuk sistem |
| Inventory salah | Ansible tidak menemukan host | Verifikasi `inventory.ini` dan SSH connectivity |
| Variable tidak terdefinisi | Error "undefined variable" | Pastikan semua variable ada di `defaults/main.yml` |
| Symlink konflik | File sudah ada | Gunakan `force: yes` atau backup terlebih dahulu |

---

## 7. Manajemen Plugin di Tim

### Deskripsi Konkret & Peran dalam Kurikulum

Di tingkat enterprise, plugin Zsh bukan sekadar preferensi pribadi — ini adalah **keputusan teknis** yang mempengaruhi konsistensi, performa, dan keamanan tim. Module ini membahas cara memilih plugin manager, menstandarisasi plugin, dan mengelola lifecycle plugin.

### Konsep Kunci & Filosofi Mendalam

**Masalah plugin enterprise:**
- **Konsistensi:** Jika setiap developer menggunakan plugin manager berbeda, troubleshooting menjadi mimpi buruk
- **Keamanan:** Plugin dari sumber tidak terpercaya bisa menjadi vektor serangan
- **Performa:** Plugin yang berat memperlambat startup shell, terutama di mesin dengan resource terbatas
- **Maintenance:** Plugin yang tidak di-maintain bisa break setelah update Zsh

**Landscape plugin manager Zsh (2025-2026):**

| Plugin Manager | Bahasa | Status | Performa |
|---|---|---|---|
| **Antibody** | Go | ⚠️ Maintenance mode | Cepat |
| **Antigen** | Zsh | ⚠️ Maintenance mode | Lambat |
| **Antidote** | Zsh | ✅ Active | Cepat |
| **Sheldon** | Rust | ✅ Active | Cepat |
| **Zinit** | Zsh | ✅ Active (continuum) | Cepat |
| **Znap** | Zsh | ✅ Active | Cepat |
| **Zplug** | Zsh | ☠️ Abandonware | Lambat |
| **zsh_unplugged** | Zsh | ✅ Active | Sangat cepat (manual) |

### Sintaks Dasar — Contoh dengan Antidote

```bash
# ~/.config/zsh/.zsh_plugins.txt — Daftar plugin (dikelola tim)

# Format: username/repo atau URL lengkap
# Plugin dikelompokkan dan diberi komentar untuk klarifikasi

# ── Core plugins (WAJIB) ──
zsh-users/zsh-completions
zsh-users/zsh-autosuggestions
zsh-users/zsh-syntax-highlighting

# ── Enterprise tools ──
# kubectl completion
ohmyzsh/ohmyzsh path:plugins/kubectl

# ── Prompt ──
romkatv/powerlevel10k

# ── Local overrides (opsional) ──
# ~/.config/zsh/.zsh_plugins_local.txt
```

```bash
# ~/.config/zsh/.zshrc — Loading dengan Antidote

# Inisialisasi Antidote
source /opt/company/antidote/antidote.zsh

# Load plugins dari file (static loading — lebih cepat)
antidote load ~/.config/zsh/.zsh_plugins.txt

# Atau: dynamic loading (jika ada plugin yang memerlukan)
# antidote load ~/.config/zsh/.zsh_plugins.txt
```

**Alternatif: Manual Plugin Loading (zsh_unplugged)**

```bash
# ~/.config/zsh/.zshrc — Manual plugin loading (tanpa plugin manager)

# Fungsi sederhana untuk clone & source plugin
function plugin-load() {
    local repo="$1"
    local plugin_dir="${ZDOTDIR:-$HOME}/.zsh_plugins/${repo:t}"

    if [[ ! -d "$plugin_dir" ]]; then
        git clone --depth 1 "https://github.com/${repo}.git" "$plugin_dir"
    fi

    # Tambahkan ke fpath jika ada completions
    [[ -d "$plugin_dir" ]] && fpath=("$plugin_dir" $fpath)

    # Source file utama
    source "$plugin_dir/${repo:t}.plugin.zsh" 2>/dev/null
}

# Load plugins
plugin-load "zsh-users/zsh-autosuggestions"
plugin-load "zsh-users/zsh-syntax-highlighting"

# Rebuild completion cache
autoload -Uz compinit && compinit
```

> **💡 Catatan:** `zsh_unplugged` adalah pendekatan minimalis yang menggunakan ~20 baris fungsi untuk menggantikan plugin manager penuh. Untuk tim kecil dengan kebutuhan sederhana, ini bisa lebih mudah di-maintain daripada plugin manager.

### Kebijakan Plugin Enterprise

```bash
# /etc/zsh/conf.d/35-plugins.zsh — Kebijakan plugin sistem-wide

# Daftar plugin yang DIIZINKAN (whitelist)
# Plugin di luar daftar ini tidak akan di-load
typeset -ga ZSH_ALLOWED_PLUGINS=(
    "zsh-users/zsh-completions"
    "zsh-users/zsh-autosuggestions"
    "zsh-users/zsh-syntax-highlighting"
    "romkatv/powerlevel10k"
)

# Direktori plugin yang dikelola sistem
export ZSH_PLUGIN_DIR="/opt/company/zsh-plugins"

# Fungsi untuk memverifikasi plugin
function zsh-plugin-verify() {
    local plugin="$1"
    if [[ ! " ${ZSH_ALLOWED_PLUGINS[@]} " =~ " ${plugin} " ]]; then
        echo "ERROR: Plugin '${plugin}' tidak diizinkan oleh kebijakan perusahaan." >&2
        return 1
    fi
    return 0
}
```

### Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Plugin manager** | Alat untuk mengelola instalasi dan loading plugin | Antidote, Sheldon, Zinit |
| **Static loading** | Semua plugin di-load saat startup | Antidote static load |
| **Dynamic loading** | Plugin di-load saat dibutuhkan (lazy) | Zinit turbo mode |
| **Whitelist** | Daftar plugin yang diizinkan | `ZSH_ALLOWED_PLUGINS` |
| **`fpath`** | Array Zsh yang menentukan lokasi fungsi autoload | `fpath=("$dir" $fpath)` |
| **`compinit`** | Fungsi untuk inisialisasi completion system | `autoload -Uz compinit && compinit` |

### Hubungan dengan Modul Lain

- **Sub-bab 3 (conf.d):** `35-plugins.zsh` adalah file dalam `conf.d` untuk konfigurasi plugin
- **Sub-bab 9 (Optimasi):** Plugin loading adalah salah satu penyebab utama startup lambat
- **Modul 6.3 Jalur C:** Membangun CLI tools sering melibatkan plugin Zsh

### Sumber Referensi Lengkap

- **Antidote GitHub** — https://github.com/mattmc3/antidote
- **Sheldon GitHub** — https://github.com/rossmacarthur/sheldon
- **Zinit (Continuum) GitHub** — https://github.com/zdharma-continuum/zinit
- **zsh_unplugged** — https://github.com/mattmc3/zsh_unplugged
- **Awesome Zsh Plugins** — https://github.com/unixorn/awesome-zsh-plugins
- **LinuxLinks: 11 Best Zsh Plugin Managers** — https://www.linuxlinks.com/best-free-open-source-zsh-plugin-managers/

### Tips dan Praktik Terbaik

1. **Pilih plugin manager yang active.** Jangan gunakan plugin manager yang sudah abandonware (zplug, antigen).
2. **Gunakan static loading jika memungkinkan.** Dynamic loading lebih cepat startup, tetapi lebih kompleks untuk di-debug.
3. **Standarisasi plugin di tingkat tim.** Buat file `.zsh_plugins.txt` yang di-version control dan di-share.
4. **Review plugin secara berkala.** Hapus plugin yang tidak digunakan — setiap plugin menambah startup time.
5. **Test di mesin lambat.** Plugin yang cepat di laptop high-end mungkin lambat di VM dengan 1 CPU.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Plugin manager tidak di-maintain | Plugin break setelah update Zsh | Migrasi ke Antidote/Sheldon |
| Terlalu banyak plugin | Startup time >1 detik | Audit plugin, hapus yang tidak perlu |
| Konflik antar plugin | Fungsi/alias bertabrakan | Load order matters — load yang penting dulu |
| Plugin dari sumber tidak terpercaya | Risiko keamanan | Gunakan whitelist, review code plugin |

---

## 8. Keamanan & Zero-Trust

### Deskripsi Konkret & Peran dalam Kurikulum

Di lingkungan enterprise, shell adalah **titik akses paling sensitif** — dari sini, pengguna bisa mengakses server produksi, database, secrets, dan infrastruktur cloud. Zero-trust security berarti: **jangan percaya apa pun secara default, verifikasi semuanya.**

### Konsep Kunci & Filosofi Mendalam

**Zero-Trust dalam konteks shell:**

1. **Jangan simpan secrets di plaintext.** API keys, tokens, dan passwords tidak boleh ada di `.zshrc` atau environment variable yang bisa di-expose.
2. **Audit semua command.** Command history harus tercatat dengan timestamp dan tidak bisa dihapus oleh pengguna.
3. **Batasi apa yang bisa dijalankan.** Restricted shell mode, alias yang menolak operasi berbahaya.
4. **Timeout idle sessions.** Shell yang dibiarkan terbuka adalah risiko keamanan.

### Sintaks Dasar — Secret Management

```bash
# /etc/zsh/conf.d/10-security.zsh — Secret management

# ═══════════════════════════════════════════════════════════
# JANGAN PERNAH lakukan ini:
# export AWS_SECRET_ACCESS_KEY="AKIAIOSFODNN7EXAMPLE"
# export GITHUB_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxx"
# ═══════════════════════════════════════════════════════════

# ✅ LAKUKAN ini: Load secrets dari secret manager
# Menggunakan 1Password CLI
if command -v op &>/dev/null; then
    # Load AWS credentials dari 1Password
    export AWS_ACCESS_KEY_ID=$(op read "op://Company/AWS/access_key_id" 2>/dev/null)
    export AWS_SECRET_ACCESS_KEY=$(op read "op://Company/AWS/secret_access_key" 2>/dev/null)
fi

# ✅ Alternatif: macOS Keychain
if [[ "$OSTYPE" == darwin* ]]; then
    # Simpan: security add-generic-password -a "$USER" -s "company-github-token" -w "TOKEN"
    # Load:
    export GITHUB_TOKEN=$(security find-generic-password -a "$USER" -s "company-github-token" -w 2>/dev/null)
fi

# ✅ Alternatif: SOPS (Secrets OPerationS)
# Jika secrets di-encrypt dalam file YAML
if command -v sops &>/dev/null && [[ -f /opt/company/secrets.enc.yaml ]]; then
    eval "$(sops -d --output-type dotenv /opt/company/secrets.enc.yaml | sed 's/^/export /')"
fi
```

**Penjelasan Sintaks:**

| Sintaks | Penjelasan |
|---|---|
| `$(command)` | Command substitution — jalankan command dan gunakan output-nya |
| `command -v op` | Cek apakah command `op` ada di PATH |
| `&>/dev/null` | Redirect stdout dan stderr ke /dev/null (suppress output) |
| `op read "op://..."` | 1Password CLI untuk membaca secret |
| `security find-generic-password` | macOS Keychain CLI |
| `sops -d` | Decrypt file dengan SOPS |
| `eval "$(...)"` | Evaluasi output sebagai command |

### Audit Logging

```bash
# /etc/zsh/conf.d/10-security.zsh — Audit logging

# Aktifkan logging semua command ke file terpusat
# CATATAN: Ini bisa memperlambat shell — gunakan dengan hati-hati

# Hanya aktifkan untuk shell interaktif
if [[ -o interactive ]]; then
    # Fungsi preexec: dijalankan SEBELUM setiap command
    function _company_audit_preexec() {
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        local tty=$(tty 2>/dev/null || echo "no-tty")
        local cmd="$1"

        # Tulis ke file audit (append)
        echo "${timestamp} | ${USER} | ${HOST} | ${tty} | ${cmd}" \
            >> /var/log/company/zsh_audit.log
    }

    # Daftarkan fungsi preexec
    autoload -Uz add-zsh-hook
    add-zsh-hook preexec _company_audit_preexec
fi

# Restricted shell: batasi command yang bisa dijalankan
# CATATAN: Ini sangat ketat — hanya untuk akun service
# setopt restricted  # Uncomment untuk mengaktifkan
# Dalam restricted mode:
# - Tidak bisa cd di luar direktori tertentu
# - Tidak bisa mengubah PATH
# - Tidak bisa menjalankan command dengan path absolut
# - Tidak bisa redirect output
```

### Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Zero-Trust** | Model keamanan yang tidak mempercayai apa pun secara default | Verifikasi setiap akses |
| **Secret Manager** | Alat untuk menyimpan dan mengakses secrets secara aman | 1Password, HashiCorp Vault, SOPS |
| **SOPS** | Secrets OPerationS — alat enkripsi file YAML/JSON | `sops -d secrets.enc.yaml` |
| **Audit Trail** | Rekaman semua aktivitas untuk keperluan audit | `zsh_audit.log` |
| **`preexec`** | Hook Zsh sebelum command dieksekusi | Untuk logging |
| **Restricted Shell** | Mode shell yang membatasi command yang bisa dijalankan | `zsh -r` |
| **`TMOUT`** | Timeout idle shell | `TMOUT=3600` |

### Sumber Referensi Lengkap

- **1Password CLI** — https://developer.1password.com/docs/cli/
- **SOPS (Mozilla)** — https://github.com/mozilla/sops
- **HashiCorp Vault** — https://www.vaultproject.io/
- **Zero-Trust Shell Architecture** — https://hoop.dev/blog/air-gapped-deployment-with-zsh
- **Zsh Restricted Shell** — https://zsh.sourceforge.io/Doc/Release/Options.html

### Tips dan Praktik Terbaik

1. **Jangan pernah commit secrets ke Git.** Gunakan `.gitignore` untuk `.env`, `.secrets`, dan file konfigurasi lokal.
2. **Gunakan secret manager, bukan environment file.** 1Password CLI, SOPS, atau Vault jauh lebih aman daripada `.env` file.
3. **Audit log harus append-only.** Pengguna tidak boleh bisa menghapus atau memodifikasi log.
4. **Test restricted shell di environment terisolasi.** Restricted shell sangat ketat dan bisa mengganggu workflow normal.
5. **Rotasi secrets secara berkala.** Secret manager memudahkan rotasi tanpa mengubah konfigurasi shell.

---

## 9. Optimasi Startup Time [TAMBAHAN AUDIT]

### Deskripsi Konkret & Peran dalam Kurikulum

Shell yang lambat startup adalah masalah produktivitas dan pengalaman pengguna. Di tingkat enterprise, startup time yang konsisten (<200ms) adalah indikator kesehatan konfigurasi. Materi ini membahas cara mengukur, menganalisis, dan mengoptimasi startup time.

### Konsep Kunci & Filosofi Mendalam

**Setiap milidetik di startup shell dikalikan dengan berapa kali shell dibuka per hari.** Jika seorang developer membuka 50 terminal per hari, startup 1 detik berarti 50 detik terbuang — hampir 1 menit per hari per developer. Untuk tim 50 developer, ini 50 menit per hari.

### Sintaks Dasar — Profiling

```bash
# Profiling startup time — letakkan di ~/.zshrc

# Aktifkan profiling Zsh
zmodload zsh/zprof

# ... (semua konfigurasi Anda) ...

# Di akhir file, tampilkan laporan profiling
# Uncomment baris di bawah untuk melihat laporan
# zprof
```

**Cara Mengukur Startup Time:**

```bash
# Ukur total startup time
time zsh -i -c exit

# Contoh output:
# zsh -i -c exit  0.08s user 0.03s system 85% cpu 0.129 total
#                 ↑ startup time ~129ms

# Benchmark yang lebih detail
for i in {1..5}; do
    /usr/bin/time -f "%e" zsh -i -c exit
done

# Dengan hyperfine (lebih akurat)
hyperfine --warmup 3 'zsh -i -c exit'
```

### Teknik Optimasi

**1. Lazy Loading:**

```bash
# Sebelum: load plugin berat saat startup
# source /path/to/heavy-plugin.zsh  # 200ms

# Sesudah: lazy load — hanya load saat dibutuhkan
function heavy-tool() {
    unset -f heavy-tool
    source /path/to/heavy-plugin.zsh
    heavy-tool "$@"
}
```

**2. `zcompile`:**

```bash
# Compile file startup besar menjadi bytecode
# File .zwc akan di-load lebih cepat dari source
zcompile ~/.config/zsh/.zshrc
zcompile /etc/zsh/conf.d/00-base.zsh

# Verifikasi
ls -la ~/.config/zsh/.zshrc.zwc
```

**3. Completion Cache:**

```bash
# Gunakan dump file untuk compinit
# Ini menghindari scan ulang semua completion setiap startup
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

# Rebuild cache hanya jika file lebih tua dari 24 jam
# (compinit handles this automatically with -d)
```

### Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **`zprof`** | Modul Zsh untuk profiling startup | `zmodload zsh/zprof` |
| **Lazy loading** | Menunda loading sampai dibutuhkan | Function wrapper |
| **`zcompile`** | Compile file Zsh ke bytecode | `zcompile .zshrc` |
| **`.zwc`** | File bytecode Zsh | `.zshrc.zwc` |
| **`zcompdump`** | Cache completion | `~/.cache/zsh/zcompdump` |
| **`hyperfine`** | Alat benchmark command-line | `hyperfine 'zsh -i -c exit'` |

### Sumber Referensi Lengkap

- **Zsh Manual: `zprof`** — https://zsh.sourceforge.io/Doc/Release/Modules.html
- **Zsh Manual: `zcompile`** — https://zsh.sourceforge.io/Doc/Release/Shell-Builtin-Commands.html
- **How to Diagnose Slow Shell Startup** — https://namhoonlee.com/posts/slow-shell-startup
- **Zsh Startup Optimization** — https://hoop.dev/blog/zsh-slows-down-when-you-need-it-most

### Tips dan Praktik Terbaik

1. **Target <200ms untuk interactive shell.** Jika lebih dari itu, ada yang perlu dioptimasi.
2. **Gunakan `zprof` untuk menemukan bottleneck.** Fokus pada fungsi yang memakan waktu >10ms.
3. **Lazy load tools berat.** `nvm`, `conda`, `rbenv` — semua ini bisa lazy-load.
4. **Hindari `compinit` tanpa cache.** Selalu gunakan `-d` untuk menentukan dump file.
5. **Test di mesin lambat.** Optimasi di laptop high-end tidak selalu terasa di VM.

---

## 10. Onboarding Pengembang Baru

### Deskripsi Konkret & Peran dalam Kurikulum

Onboarding adalah proses memperkenalkan pengembang baru ke environment kerja. Di tingkat enterprise, onboarding yang baik berarti: **dari laptop baru hingga siap coding dalam <15 menit.**

### Checklist Onboarding

```bash
# ═══════════════════════════════════════════════════════════
# ONBOARDING CHECKLIST — ZSH ENTERPRISE
# ═══════════════════════════════════════════════════════════

# 1. Install prerequisites
#    - Git
#    - Zsh (biasanya sudah ada)
#    - GNU Stow (opsional)
#    - Ansible (opsional, untuk deployment)

# 2. Clone dotfiles repository
git clone https://git.company.com/dotfiles.git ~/dotfiles

# 3. Jalankan setup script (otomatis)
~/dotfiles/setup.sh

# 4. Verifikasi
zsh -i -c 'echo "Zsh version: $ZSH_VERSION"'
zsh -i -c 'echo "PATH: $PATH"' | tr ':' '\n' | head -5

# 5. Buka terminal baru dan verifikasi prompt/tools
```

**Setup Script Example:**

```bash
#!/bin/zsh
# ~/dotfiles/setup.sh — Onboarding automation script
set -euo pipefail

echo "=== Zsh Enterprise Onboarding ==="

# 1. Detect OS
case "$(uname -s)" in
    Darwin*) OS="macos" ;;
    Linux*)  OS="linux" ;;
    *)       echo "Unsupported OS"; exit 1 ;;
esac
echo "Detected OS: $OS"

# 2. Install GNU Stow
if ! command -v stow &>/dev/null; then
    echo "Installing GNU Stow..."
    if [[ "$OS" == "macos" ]]; then
        brew install stow
    else
        sudo apt-get install -y stow
    fi
fi

# 3. Stow dotfiles
echo "Stowing dotfiles..."
cd ~/dotfiles
stow zsh git tmux

# 4. Verifikasi
echo "Verifying configuration..."
if zsh -n -c 'source ~/.zshrc' 2>/dev/null; then
    echo "✅ Zsh configuration OK"
else
    echo "⚠️  Zsh configuration has errors"
fi

echo "=== Onboarding complete! Open a new terminal. ==="
```

### Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Onboarding** | Proses setup environment untuk pengembang baru | <15 menit |
| **Setup script** | Script otomasi untuk onboarding | `setup.sh` |
| **Idempotent script** | Script yang aman dijalankan berkali-kali | `set -euo pipefail` |
| **`set -euo pipefail`** | Strict mode Bash/Zsh: exit on error, undefined var, pipe failure | Mencegah error tersembunyi |

### Sumber Referensi Lengkap

- **Automated Dev Onboarding with CLI and dotfiles** — LinkedIn/Wyat Soule
- **GitHub: dotfiles onboarding automation** — https://github.com/topics/dotfiles-onboarding
- **Ansible for DevOps (Jeff Geerling)** — https://www.ansiblefordevops.com/

---

## Ringkasan Modul 6.1

| Sub-bab | Topik | Estimasi Waktu |
|---|---|---|
| 1 | Fondasi Startup Files Zsh | 3-4 jam |
| 2 | Konfigurasi Sistem-Wide vs Pengguna | 2-3 jam |
| 3 | Modular Configuration (conf.d) | 2-3 jam |
| 4 | XDG Base Directory & ZDOTDIR | 2 jam |
| 5 | GNU Stow | 3-4 jam |
| 6 | Ansible Deployment | 4-5 jam |
| 7 | Manajemen Plugin | 3-4 jam |
| 8 | Keamanan & Zero-Trust | 3-4 jam |
| 9 | Optimasi Startup Time | 2-3 jam |
| 10 | Onboarding Pengembang | 2 jam |
| **Total** | | **~26-32 jam** |

---

## Verifikasi Pemahaman

Sebelum melanjutkan ke Modul 6.2, pastikan Anda dapat:

- [ ] Menjelaskan urutan lengkap startup files Zsh dan kapan setiap file dibaca
- [ ] Membuat hierarki `/etc/zsh/` + `conf.d` untuk enterprise
- [ ] Menggunakan GNU Stow untuk mengelola dotfiles dengan package-based approach
- [ ] Menulis Ansible playbook sederhana untuk deploy konfigurasi Zsh
- [ ] Menjelaskan mengapa secrets tidak boleh disimpan di `.zshrc`
- [ ] Mengukur dan mengoptimasi startup time shell
- [ ] Membuat script onboarding otomatis untuk pengembang baru

---


## ✅ Materi Modul 6.1 telah selesai.
Berikutnya adalah **Modul 6.2: Kontribusi ke Proyek Zsh dan Open Source,** ini akan mencakup:

1. Sejarah dan governance proyek Zsh
2. Mailing list dan komunikasi komunitas
3. Proses patch dan review
4. Menulis plugin Zsh
5. Mendokumentasikan kontribusi
6. Etika open source

---

# MODUL 6.2: KONTRIBUSI KE PROYEK ZSH DAN OPEN SOURCE

> **📌 Catatan Audit:** Modul ini sebelumnya kosong dalam kurikulum (hanya judul). Materi di bawah ini dibangun sepenuhnya dari nol berdasarkan riset dari sumber-sumber resmi proyek Zsh, mailing list archive, dan dokumentasi pengembangan. Semua konten ditandai sebagai **[TAMBAHAN AUDIT]** karena melampaui apa yang tertulis di kurikulum asli — namun tetap dalam kerangka Fase 6 (Expert: Arsitektur, Kontribusi, dan Spesialisasi).

---

## Struktur Pembelajaran Internal (Mini-Daftar Isi)

1. **Sejarah dan Governance Proyek Zsh** — Dari Paul Falstad (1990) hingga Zsh Development Group, model "rotating coordinator", dan filosofi mailing-list-driven development
2. **Mailing List dan Komunikasi** — Tiga mailing list utama (announce, users, workers), arsitektur nested, etika komunikasi, dan arsip
3. **Proses Patch dan Review** — Format patch (context/unified diff), aturan satu-patch-satu-email, X-Seq numbering, ChangeLog convention, dan siklus review
4. **Menulis Plugin Zsh** — Standar plugin (file `.plugin.zsh`, `$0` handling, fpath), struktur direktori, dan best practices
5. **Mendokumentasikan Kontribusi** — ChangeLog, dokumentasi manual (`yodl`), dan completion documentation
6. **Etika Open Source** — Prinsip komunikasi, menangani feedback, dan membangun hubungan dengan maintainer
7. **Membangun Zsh dari Source** [TAMBAHAN AUDIT] — Prasyarat build, konfigurasi, dan testing
8. **Proyek Akhir: Kontribusi Nyata** [TAMBAHAN AUDIT] — Panduan langkah demi langkah untuk kontribusi pertama

---

## 1. Sejarah dan Governance Proyek Zsh

### Deskripsi Konkret & Peran dalam Kurikulum

Memahami sejarah dan governance proyek adalah fondasi untuk berkontribusi secara efektif. Zsh bukan proyek yang dikelola oleh perusahaan atau yayasan — ini adalah proyek **komunitas murni** yang telah berjalan sejak 1990. Model governance-nya unik: tidak ada "benevolent dictator", melainkan **rotating coordinator** yang bergilir di antara pengembang inti. Memahami struktur ini membantu Anda mengetahui **ke mana harus mengirim patch**, **siapa yang mengambil keputusan**, dan **bagaimana proses pengambilan keputusan berlangsung**.

### Konsep Kunci & Filosofi Mendalam

**Zsh lahir dari sebuah keisengan akademis.** Paul Falstad, seorang mahasiswa di Princeton University, menulis versi pertama Zsh pada tahun 1990. Nama "Zsh" berasal dari nama Zhong Shao, seorang asisten pengajar di Princeton — Falstad melihat login Shao, "zsh", dan menganggapnya nama yang bagus untuk sebuah shell.

**Filosofi governance Zsh sangat berbeda dari proyek open source modern.** Tidak ada GitHub Issues, tidak ada Pull Request workflow (meskipun GitHub mirror tersedia), dan tidak ada roadmap publik. Semua development terjadi melalui **mailing list** `zsh-workers@zsh.org`. Keputusan diambil melalui diskusi di mailing list, dan koordinator bergilir bertanggung jawab untuk mengintegrasikan patch.

**Model "rotating coordinator":** Zsh tidak memiliki satu "pemimpin" permanen. Koordinator dipilih dari pengembang inti dan bergilir. Sepanjang sejarah, koordinator termasuk Zefram (Andrew Main) hingga 1999, kemudian Bart Schaefer dan Peter Stephenson yang memimpin rilis besar seperti 4.0 (2001) dan 5.0 (2012). Peter Stephenson masih menjadi koordinator saat ini.

**Mengapa model ini penting?** Karena ini berarti **Anda tidak perlu "dipilih" oleh siapa pun untuk berkontribusi**. Siapa pun yang berlangganan mailing list dan mengirim patch yang baik akan dianggap serius. Proyek ini mendeskripsikan dirinya sebagai "very open and anyone is welcomed and encouraged to join and contribute".

### Diagram: Sejarah dan Evolusi Zsh

```bash
1990 ─── Paul Falstad menulis versi pertama Zsh di Princeton
         │  Nama "Zsh" dari login Zhong Shao
         │  Tujuan: cross antara ksh dan tcsh
         ▼
1995 ─── zsh-announce mailing list archive dimulai
         │  Development terkoordinasi via mailing list
         ▼
1997 ─── Zsh 3.0 dirilis
         │  Mailing list-driven development mapan
         ▼
1999 ─── Zefram (Andrew Main) berhenti sebagai koordinator
         │  Rotating coordinator model dimulai
         ▼
2001 ─── Zsh 4.0 dirilis
         │  Bart Schaefer dan Peter Stephenson memimpin
         ▼
2012 ─── Zsh 5.0 dirilis
         │  Peter Stephenson sebagai koordinator
         ▼
2019 ─── macOS Catalina mengadopsi Zsh sebagai default shell
         │  Menggantikan Bash (GPLv2)
         ▼
2020 ─── Kali Linux mengadopsi Zsh sebagai default shell
         ▼
2026 ─── Zsh 5.9.1 (rilis stabil saat ini)
```

> **🔍 Visualisasi Sangat Membantu di Sini:** Timeline di atas akan lebih efektif jika divisualisasikan sebagai *horizontal timeline* dengan penanda tahun, nama koordinator, dan milestone rilis. Tambahkan warna berbeda untuk setiap era governance.

### Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Zsh Development Group** | Kelompok informal yang mengembangkan Zsh | Terdiri dari subscriber mailing list |
| **Rotating Coordinator** | Koordinator yang bergilir, bukan permanen | Peter Stephenson (saat ini) |
| **Mailing-list-driven** | Development terjadi melalui diskusi mailing list | `zsh-workers@zsh.org` |
| **MIT-Modern-Variant License** | Lisensi Zsh (BSD-like) | Memungkinkan penggunaan komersial |
| **META-FAQ** | Dokumen yang menjelaskan struktur proyek | Berisi info mailing list |

### Hubungan dengan Modul Lain

- **Modul 6.1 (Sub-bab 1-3):** Startup files dan konfigurasi adalah hasil dari development yang dibahas di sini
- **Sub-bab 2 (Mailing List):** Komunikasi adalah inti dari governance
- **Sub-bab 3 (Patch):** Proses patch adalah mekanisme kontribusi utama
- **Modul 6.3:** Spesialisasi (DevOps, Data, Tooling) adalah area di mana kontribusi Zsh bisa diterapkan

### Sumber Referensi Lengkap

- **Zsh Wikipedia: History** — https://en.wikipedia.org/wiki/Z_shell
- **Zsh Development Guide (Etc/zsh-development-guide)** — https://github.com/zsh-users/zsh/blob/master/Etc/zsh-development-guide
- **Zsh META-FAQ** — https://zsh.sourceforge.io/FAQ/
- **Zsh SourceForge: Chapter 6 — The Future of Zsh** — https://zsh.sourceforge.io/Doc/Release/zsh_toc.html
- **Zsh License (MIT-Modern-Variant)** — https://zsh.sourceforge.io/LICENCE

### Tips dan Praktik Terbaik

1. **Baca arsip mailing list sebelum posting.** Sebelum mengirim pertanyaan atau patch, cari di arsip `https://www.zsh.org/mla/` untuk memastikan topik belum pernah dibahas.
2. **Pahami bahwa maintainer adalah sukarelawan.** Mereka tidak dibayar untuk merespons patch Anda. Kesabaran adalah kunci.
3. **Gunakan bahasa Inggris yang jelas.** Mailing list Zsh berbahasa Inggris; jika bahasa Inggris bukan bahasa pertama Anda, tidak masalah — yang penting adalah kejelasan.
4. **Ikuti konvensi yang sudah ada.** Jangan mengusulkan perubahan besar pada workflow tanpa diskusi terlebih dahulu di mailing list.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Mengirim patch langsung ke koordinator | Patch tidak di-review | Kirim ke `zsh-workers@zsh.org` |
| Tidak mencari arsip | Pertanyaan duplikat | Cari di `https://www.zsh.org/mla/` dulu |
| Mengharapkan respons cepat | Frustrasi karena tidak ada balasan | Tunggu 1-2 minggu, lalu follow-up dengan sopan |

---

## 2. Mailing List dan Komunikasi

### Deskripsi Konkret & Peran dalam Kurikulum

Mailing list adalah **saluran komunikasi utama** proyek Zsh. Ada tiga mailing list yang saling terkait: `zsh-announce` (pengumuman), `zsh-users` (pertanyaan pengguna), dan `zsh-workers` (development). Memahami cara berlangganan, etika berkomunikasi, dan arsip mailing list adalah keterampilan esensial untuk berkontribusi.

### Konsep Kunci & Filosofi Mendalam

**Arsitektur mailing list Zsh bersifat nested** — ini berarti semua pengiriman ke `zsh-announce` secara otomatis diteruskan ke `zsh-users`, dan semua pengiriman ke `zsh-users` diteruskan ke `zsh-workers`. Artinya: **Anda hanya perlu berlangganan SATU mailing list**. Jika Anda berlangganan `zsh-workers`, Anda akan menerima semua pesan dari `zsh-users` dan `zsh-announce`.

**Mengapa nested?** Ini memastikan bahwa pengembang inti (yang berlangganan `zsh-workers`) selalu melihat pertanyaan pengguna dan pengumuman. Ini juga mencegah fragmentasi diskusi — semua diskusi pada akhirnya sampai ke `zsh-workers`.

**Etika mailing list adalah kunci.** Berbeda dengan GitHub Issues atau Discord, mailing list memiliki norma komunikasi yang berbeda: email harus **plain text** (bukan HTML), **bottom-posting** (bukan top-posting), dan **satu topik per thread**. Melanggar norma ini bisa membuat Anda diabaikan atau bahkan di-blacklist.

### Sintaks Dasar — Berlangganan dan Mengirim

**Berlangganan Mailing List:**

```bash
# Kirim email ke alamat subscription dengan subject "subscribe"
# (Atau gunakan link web di https://www.zsh.org/sympa)

# Untuk zsh-workers (development):
echo "subscribe" | mail -s "subscribe" zsh-workers-subscribe@zsh.org

# Anda akan menerima email konfirmasi — balas untuk mengonfirmasi
```

**Mengirim Patch ke Mailing List:**

```bash
# Format subject yang benar:
# "PATCH: deskripsi singkat perbaikan"
# "[PATCH] deskripsi"
# "[PATCH n/m] deskripsi" (untuk series)

# Contoh: mengirim patch via git send-email (jika tersedia)
git send-email \
    --to="zsh-workers@zsh.org" \
    --subject="PATCH: Fix completion for git rebase" \
    0001-fix-completion.patch

# Atau: kirim manual dengan attachment .patch
# Subject: [PATCH] Fix completion for git rebase
# Body:
#   Perbaikan untuk completion git rebase yang tidak berfungsi
#   saat menggunakan opsi --interactive.
#
#   Patch terlampir.
```

**Etika Mailing List:**

| Aturan | Penjelasan |
|---|---|
| **Plain text** | Jangan kirim HTML email. Gunakan plain text. |
| **Bottom-posting** | Balas di bawah kutipan, bukan di atas. |
| **Satu topik per thread** | Jangan campur beberapa topik dalam satu email. |
| **Jangan top-posting** | Jangan letakkan balasan Anda di atas kutipan. |
| **Kutip dengan tepat** | Hanya kutip bagian yang relevan. |
| **Jangan serang pribadi** | Kritik ide, bukan orang. |
| **Beri waktu** | Maintainer sukarelawan; tunggu 1-2 minggu sebelum follow-up. |

### Diagram: Arsitektur Mailing List Nested

```bash
┌─────────────────────────────────────────────────────────────┐
│                 ARSITEKTUR MAILING LIST ZSH                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────────┐                                       │
│  │  zsh-announce    │  ← Pengumuman rilis, security         │
│  │  (announce-only) │     Tidak bisa posting                │
│  └────────┬─────────┘                                       │
│           │  auto-forward                                  │
│           ▼                                                 │
│  ┌──────────────────┐                                       │
│  │  zsh-users       │  ← Pertanyaan pengguna, diskusi       │
│  │  (low-medium vol)│     Cara menggunakan shell            │
│  └────────┬─────────┘                                       │
│           │  auto-forward                                  │
│           ▼                                                 │
│  ┌──────────────────┐                                       │
│  │  zsh-workers     │  ← Development, patch, bug report     │
│  │  (high volume)   │     "Guts of the shell"               │
│  └──────────────────┘                                       │
│                                                             │
│  ┌──────────────────┐                                       │
│  │  zsh-security    │  ← Laporan keamanan (tidak publik)    │
│  │  (private)       │     Kirim email, tidak bisa subscribe │
│  └──────────────────┘                                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Nested mailing list** | List yang saling terhubung; kirim ke satu, sampai ke semua | `zsh-users` → `zsh-workers` |
| **Bottom-posting** | Balasan di bawah kutipan | Standar mailing list |
| **Top-posting** | Balasan di atas kutipan | Tidak sopan di mailing list |
| **Plain text** | Email tanpa format HTML | Standar mailing list |
| **X-Seq** | Nomor urut mailing list untuk patch | `X-Seq: 52281` |
| **Archive** | Arsip publik mailing list | `https://www.zsh.org/mla/` |

### Hubungan dengan Modul Lain

- **Sub-bab 1 (Governance):** Mailing list adalah mekanisme governance
- **Sub-bab 3 (Patch):** Patch dikirim melalui mailing list
- **Sub-bab 6 (Etika):** Etika mailing list adalah bagian dari etika open source

### Sumber Referensi Lengkap

- **Zsh Mailing Lists Official** — https://zsh.sourceforge.io/Arc/mlist.html
- **Zsh Mailing List Archive** — https://www.zsh.org/mla/
- **Zsh Workers Archive 2026** — https://www.zsh.org/mla/workers/2026/
- **Zsh META-FAQ (Mailing Lists)** — https://zsh.sourceforge.io/FAQ/

### Tips dan Praktik Terbaik

1. **Berlangganan `zsh-workers` saja.** Karena nested, Anda akan menerima semua pesan dari list lain.
2. **Gunakan `git send-email` jika tersedia.** Ini memformat patch dengan benar dan mengirimnya ke mailing list.
3. **Selalu plain text.** Jika email client Anda default ke HTML, ubah pengaturannya.
4. **Bottom-post.** Ini adalah norma universal di mailing list teknis.
5. **Cek arsip sebelum posting.** Gunakan pencarian di `https://www.zsh.org/mla/`.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Kirim HTML email | Email di-reject oleh mailing list | Gunakan plain text |
| Top-posting | Diabaikan atau ditegur | Bottom-post |
| Kirim ke `zsh-announce` | Email di-reject (announce-only) | Kirim ke `zsh-workers` |
| Tidak plain text | Format berantakan | Konfigurasi email client ke plain text |
| Follow-up terlalu cepat | Dianggap tidak sopan | Tunggu 1-2 minggu |

---

## 3. Proses Patch dan Review

### Deskripsi Konkret & Peran dalam Kurikulum

Proses patch adalah **mekanisme kontribusi inti** di Zsh. Berbeda dengan proyek modern yang menggunakan Pull Request di GitHub, Zsh masih menggunakan **patch via mailing list**. Memahami format patch yang benar, aturan granularitas, dan siklus review adalah keterampilan yang wajib dikuasai untuk berkontribusi.

### Konsep Kunci & Filosofi Mendalam

**Filosofi patch Zsh: "Smallest logical unit."** Setiap patch harus berisi **satu perbaikan bug atau satu fitur** — tidak lebih. Ini memudahkan maintainer untuk me-review, menerima, atau menolak patch secara individual tanpa harus memisahkan perubahan yang tidak terkait.

**Mengapa bukan Pull Request?** Zsh adalah proyek yang sudah ada sejak 1990 — jauh sebelum Git dan GitHub. Workflow mailing list sudah tertanam dalam budaya proyek. Meskipun ada mirror GitHub, development resmi tetap terjadi di mailing list. Ini adalah **pilihan desain**, bukan keterbelakangan.

**X-Seq: Sistem penomoran yang unik.** Setiap email yang masuk ke mailing list Zsh mendapatkan nomor urut yang disebut **X-Seq**. Nomor ini digunakan untuk cross-reference antara arsip mailing list dan Git history. Commit message di Zsh harus dimulai dengan X-Seq number dari patch yang sesuai.

### Sintaks Dasar — Membuat dan Mengirim Patch

**Langkah 1: Clone dan Build Zsh dari Source**

```bash
# Clone repositori Zsh
git clone https://github.com/zsh-users/zsh.git
cd zsh

# Build dari source
./Util/preconfig          # Menjalankan autoconf
./configure --prefix=/usr/local
make
sudo make install

# Verifikasi build
zsh --version
```

**Penjelasan Setiap Perintah:**

| Perintah | Penjelasan |
|---|---|
| `git clone` | Mengunduh repositori Zsh dari GitHub |
| `./Util/preconfig` | Menjalankan `autoconf` dan `autoheader` untuk menghasilkan script `configure` |
| `./configure` | Mengkonfigurasi build untuk platform Anda (mendeteksi compiler, library, dll.) |
| `make` | Mengkompilasi source code Zsh |
| `sudo make install` | Menginstall Zsh ke `/usr/local/bin` |

**Langkah 2: Membuat Patch**

```bash
# Buat branch baru untuk perbaikan
git checkout -b fix-bug-xyz

# Edit file yang bermasalah
# ... (edit Src/completion.c, Doc/Zsh/compsys.yo, dll.) ...

# Commit dengan pesan yang benar
# Commit message HARUS dimulai dengan X-Seq number (nanti)
git commit -m "Fix: deskripsi perbaikan"

# Buat patch file
git format-patch origin/master
# Menghasilkan file: 0001-Fix-deskripsi-perbaikan.patch

# Lihat isi patch
cat 0001-Fix-deskripsi-perbaikan.patch
```

**Langkah 3: Mengirim ke Mailing List**

```bash
# Kirim via git send-email (cara terbaik)
git send-email \
    --to="zsh-workers@zsh.org" \
    --subject="[PATCH] Fix: deskripsi perbaikan" \
    0001-Fix-deskripsi-perbaikan.patch

# Atau: kirim manual
# 1. Buat email baru
# 2. To: zsh-workers@zsh.org
# 3. Subject: [PATCH] Fix: deskripsi perbaikan
# 4. Body: deskripsi perubahan (plain text)
# 5. Attach: 0001-Fix-deskripsi-perbaikan.patch
```

### Format Patch yang Benar

**Contoh Patch dengan Context Diff:**

```diff
--- a/Src/completion.c
+++ b/Src/completion.c
@@ -123,7 +123,7 @@
 static int
 comp_add_file(...)
 {
-    return old_behavior;
+    return new_behavior;
 }
```

**Contoh Patch dengan Unified Diff:**

```diff
--- a/Src/completion.c
+++ b/Src/completion.c
@@ -123,7 +123,7 @@
 static int
 comp_add_file(...)
 {
-    return old_behavior;
+    return new_behavior;
 }
```

**Aturan Patch Zsh:**

| Aturan | Penjelasan |
|---|---|
| **Format** | Context diff (`diff -c`) atau unified diff (`diff -u`) |
| **Path** | Harus relatif ke top-level directory: `Src/init.c`, bukan `init.c` |
| **Granularitas** | Satu patch = satu bug fix atau satu fitur |
| **Dependency** | Jika patch bergantung pada patch lain, sebutkan |
| **Testing** | Patch harus di-test dan apply dengan bersih |
| **Subject** | Dimulai dengan `PATCH:`, `[PATCH]`, atau `[PATCH n/m]` |
| **X-Seq** | Commit message harus dimulai dengan X-Seq number |
| **ChangeLog** | Entry harus ditambahkan manual sebelum push |

### Diagram: Siklus Patch Zsh

```bash
┌─────────────────────────────────────────────────────────────┐
│                    SIKLUS PATCH ZSH                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. DEVELOPER membuat patch di local repository             │
│     │                                                       │
│     ▼                                                       │
│  2. KIRIM ke zsh-workers@zsh.org                            │
│     │  Subject: [PATCH] deskripsi                           │
│     │  Format: diff -u / diff -c                            │
│     │                                                       │
│     ▼                                                       │
│  3. MAILING LIST memberikan X-Seq number                    │
│     │  X-Seq: 52281                                         │
│     │                                                       │
│     ▼                                                       │
│  4. REVIEW oleh maintainer/pengembang lain                  │
│     │  ├── Diskusi di mailing list                          │
│     │  ├── Mungkin ada revisi                               │
│     │  └── Keputusan: accept / reject / revise              │
│     │                                                       │
│     ▼                                                       │
│  5. COMMIT ke repository (oleh maintainer)                  │
│     │  Commit message: X-Seq 52281: deskripsi               │
│     │  ChangeLog entry ditambahkan                           │
│     │                                                       │
│     ▼                                                       │
│  6. PATCH masuk ke rilis berikutnya                         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

> **🔍 Visualisasi Sangat Membantu di Sini:** Diagram siklus patch di atas akan lebih efektif jika divisualisasikan sebagai *flowchart* dengan decision points (accept/reject/revise). Tambahkan juga *swimlane* untuk peran developer vs maintainer vs mailing list.

### Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Context diff** | Format patch dengan konteks di sekitar perubahan | `diff -c old new` |
| **Unified diff** | Format patch dengan baris konteks dan prefix +/- | `diff -u old new` |
| **X-Seq** | Nomor urut mailing list untuk patch | `X-Seq: 52281` |
| **ChangeLog** | File log perubahan manual | `ChangeLog` di root repository |
| **git format-patch** | Perintah Git untuk menghasilkan patch file | `git format-patch origin/master` |
| **git send-email** | Perintah Git untuk mengirim patch via email | `git send-email --to=...` |
| **Coordinator** | Pengembang yang mengintegrasikan patch | Peter Stephenson |

### Hubungan dengan Modul Lain

- **Sub-bab 2 (Mailing List):** Patch dikirim melalui mailing list
- **Sub-bab 4 (Plugin):** Plugin juga bisa dikontribusikan sebagai patch
- **Sub-bab 5 (Dokumentasi):** Patch harus mencakup dokumentasi
- **Sub-bab 6 (Etika):** Menangani feedback adalah bagian dari etika

### Sumber Referensi Lengkap

- **Zsh Development Guide (Patch Guidelines)** — https://github.com/zsh-users/zsh/blob/master/Etc/zsh-development-guide
- **Zsh Mailing List Archive** — https://www.zsh.org/mla/
- **Zsh Git Repository** — https://github.com/zsh-users/zsh
- **Zsh Development Guidelines (DeepWiki)** — https://deepwiki.com/zsh-users/zsh/7.2-development-guidelines
- **Git send-email Documentation** — https://git-scm.com/docs/git-send-email

### Tips dan Praktik Terbaik

1. **Test patch Anda sebelum mengirim.** Jalankan `git apply --check` untuk memastikan patch applies cleanly.
2. **Sertakan ChangeLog entry.** Tambahkan entry ke `ChangeLog` sebelum push.
3. **Gunakan commit message yang deskriptif.** Jangan hanya "fix bug" — jelaskan bug apa dan bagaimana diperbaiki.
4. **Sertakan test case.** Jika memperbaiki bug, tambahkan test case di `Test/` untuk mencegah regresi.
5. **Jangan takut untuk revisi.** Jika maintainer meminta revisi, lakukan dengan cepat dan sopan.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Patch tidak apply | Maintainer tidak bisa apply | Test dengan `git apply --check` |
| Multiple fix dalam satu patch | Patch ditolak | Pisahkan menjadi patch terpisah |
| Path absolut | Patch tidak apply | Gunakan path relatif ke top-level |
| Format HTML | Email di-reject | Gunakan plain text |
| Tidak ada ChangeLog | Maintainer harus menambahkan manual | Tambahkan ChangeLog entry |

---

## 4. Menulis Plugin Zsh

### Deskripsi Konkret & Peran dalam Kurikulum

Plugin adalah cara untuk memperluas fungsionalitas Zsh tanpa harus memodifikasi source code inti. Di tingkat enterprise, plugin memungkinkan tim untuk menambahkan fungsi spesifik (completion untuk tools internal, fungsi helper, dll.) tanpa harus fork Zsh.

### Konsep Kunci & Filosofi Mendalam

**Apa itu plugin Zsh?** Secara historis, plugin Zsh pertama kali didefinisikan oleh **Oh My Zsh**. Pada tingkat sederhana, plugin adalah **direktori dengan satu file sourceable** yang berisi kode Zsh. Plugin dapat berisi: file script utama, fungsi autoload, completion, program backend, dan dokumentasi.

**Standar plugin: `$0` handling.** Salah satu tantangan dalam menulis plugin Zsh adalah **mengetahui lokasi plugin itu sendiri**. Ketika plugin di-source, `$0` mungkin berisi path ke Zsh binary, bukan path ke file plugin. Solusinya adalah **standar `$0` handling** yang menggunakan ekspresi: `0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"`.

**Mengapa ini penting?** Tanpa standar ini, plugin tidak portabel — ia hanya berfungsi di plugin manager tertentu. Dengan mengikuti standar, plugin dapat di-source langsung, di-load oleh Oh My Zsh, Antidote, Zinit, atau plugin manager lainnya.

### Sintaks Dasar — Membuat Plugin Zsh

**Struktur Direktori Plugin:**

```bash
my-plugin/
├── my-plugin.plugin.zsh      # Entry point utama (wajib)
├── functions/                # Fungsi autoload
│   ├── _my-function
│   └── _another-function
├── completions/              # Completion functions
│   └── _my-command
├── README.md                 # Dokumentasi
└── LICENSE                   # Lisensi
```

**File Entry Point (`my-plugin.plugin.zsh`):**

```bash
# my-plugin.plugin.zsh — Entry point plugin

# ═══════════════════════════════════════════════════════════
# 1. STANDARD $0 HANDLING (WAJIB)
# ═══════════════════════════════════════════════════════════
# Ekspresi ini memastikan $0 berisi path ke file plugin ini,
# bukan path ke Zsh binary. Ini memungkinkan plugin untuk
# mengetahui lokasinya sendiri.
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Sekarang $0 berisi path absolut ke file plugin
# ${0:h} = direktori plugin
local plugin_dir="${0:h}"

# ═══════════════════════════════════════════════════════════
# 2. TAMBAHKAN DIREKTORI KE fpath (untuk autoload functions)
# ═══════════════════════════════════════════════════════════
# fpath adalah array Zsh yang menentukan lokasi fungsi autoload
if [[ -d "${plugin_dir}/functions" ]]; then
    fpath=("${plugin_dir}/functions" $fpath)
fi

# ═══════════════════════════════════════════════════════════
# 3. TAMBAHKAN COMPLETIONS KE fpath
# ═══════════════════════════════════════════════════════════
if [[ -d "${plugin_dir}/completions" ]]; then
    fpath=("${plugin_dir}/completions" $fpath)
fi

# ═══════════════════════════════════════════════════════════
# 4. SOURCE FILE TAMBAHAN (jika ada)
# ═══════════════════════════════════════════════════════════
# Source file helper jika ada
for file in "${plugin_dir}"/lib/*.zsh(N); do
    source "$file"
done

# ═══════════════════════════════════════════════════════════
# 5. DEFINISIKAN FUNGSI PLUGIN
# ═══════════════════════════════════════════════════════════
# Fungsi utama plugin
my-plugin-hello() {
    echo "Hello from my-plugin!"
}

# ═══════════════════════════════════════════════════════════
# 6. DAFTARKAN FUNGSI UNTUK CLEAN UNLOAD (opsional)
# ═══════════════════════════════════════════════════════════
# Jika plugin manager mendukung unload, daftarkan fungsi
# yang harus di-unset saat plugin di-unload.
# Format: array global yang berisi nama fungsi
typeset -ga _my_plugin_functions=(
    "my-plugin-hello"
)
```

**Penjelasan Sintaks Zsh (kata demi kata):**

| Sintaks | Penjelasan |
|---|---|
| `0="${ZERO:-...}"` | Set `$0` ke nilai `$ZERO` jika ada, jika tidak gunakan fallback |
| `${0:#$ZSH_ARGZERO}` | Hapus `$0` jika sama dengan `$ZSH_ARGZERO` (path Zsh binary) |
| `${(%):-%N}` | Prompt expansion `%N` yang memberikan path absolut ke script |
| `${(M)0:#/*}` | Match jika `$0` dimulai dengan `/` (path absolut) |
| `$PWD/$0` | Gabungkan `$PWD` dengan `$0` jika `$0` bukan path absolut |
| `${0:h}` | Head (dirname) dari `$0` |
| `fpath=("${plugin_dir}/functions" $fpath)` | Tambahkan direktori ke awal `fpath` |
| `for file in "${plugin_dir}"/lib/*.zsh(N)` | Loop semua file `.zsh` di `lib/` (dengan null_glob) |
| `typeset -ga` | Buat array global |

### Contoh Plugin Lengkap: `git-helper`

**Struktur:**

```bash
git-helper/
├── git-helper.plugin.zsh
├── functions/
│   └── _git-helper
├── completions/
│   └── _git-helper
└── README.md
```

**`git-helper.plugin.zsh`:**

```bash
# git-helper.plugin.zsh — Plugin helper untuk Git

# Standard $0 handling
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"
local plugin_dir="${0:h}"

# Tambahkan functions dan completions ke fpath
[[ -d "${plugin_dir}/functions" ]] && fpath=("${plugin_dir}/functions" $fpath)
[[ -d "${plugin_dir}/completions" ]] && fpath=("${plugin_dir}/completions" $fpath)

# Fungsi: git-helper-status
# Menampilkan status Git yang lebih ringkas
git-helper-status() {
    local branch=$(git branch --show-current 2>/dev/null)
    local status=$(git status --short 2>/dev/null)

    if [[ -z "$branch" ]]; then
        echo "Not a git repository"
        return 1
    fi

    echo "Branch: $branch"
    if [[ -z "$status" ]]; then
        echo "Working tree clean"
    else
        echo "$status" | head -10
        local total=$(echo "$status" | wc -l)
        [[ $total -gt 10 ]] && echo "... and $((total - 10)) more"
    fi
}

# Fungsi: git-helper-clean
# Membersihkan branch yang sudah di-merge
git-helper-clean() {
    local base="${1:-main}"
    echo "Cleaning merged branches (base: $base)..."
    git branch --merged "$base" | grep -v "$base" | xargs -r git branch -d
}

# Daftarkan fungsi untuk clean unload
typeset -ga _git_helper_functions=(
    "git-helper-status"
    "git-helper-clean"
)
```

**`functions/_git-helper` (Completion):**

```bash
#compdef git-helper

# Completion untuk git-helper
_git-helper() {
    local -a commands
    commands=(
        'status:Show git status'
        'clean:Clean merged branches'
    )

    _arguments -C \
        '1:command:->command' \
        '*::arg:->args'

    case "$state" in
        command)
            _describe 'command' commands
            ;;
        args)
            case "$words[1]" in
                clean)
                    _arguments '1:base branch:_git_branch'
                    ;;
            esac
            ;;
    esac
}

_git-helper "$@"
```

### Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Entry point** | File utama plugin yang di-source | `my-plugin.plugin.zsh` |
| **`$0` handling** | Standar untuk mengetahui lokasi plugin | `0="${ZERO:-...}"` |
| **`fpath`** | Array Zsh untuk lokasi fungsi autoload | `fpath=("$dir" $fpath)` |
| **Autoload function** | Fungsi yang di-load saat dibutuhkan | `autoload -Uz _my-function` |
| **Completion function** | Fungsi untuk completion (`#compdef`) | `_git-helper` |
| **Clean unload** | Menghapus fungsi saat plugin di-unload | `typeset -ga _functions` |
| **`#compdef`** | Tag untuk completion function | `#compdef git-helper` |

### Hubungan dengan Modul Lain

- **Modul 6.1 (Sub-bab 7):** Plugin manager (Antidote, Sheldon) adalah cara untuk mengelola plugin
- **Sub-bab 3 (Patch):** Plugin bisa dikontribusikan sebagai patch ke Zsh
- **Sub-bab 5 (Dokumentasi):** Plugin harus didokumentasikan
- **Modul 6.3 Jalur C:** Membangun CLI tools dengan Zsh — plugin adalah bagian dari tooling

### Sumber Referensi Lengkap

- **Zsh Plugin Standard** — https://wiki.zshell.dev/community/zsh_plugin_standard
- **Zsh Plugin Standard (GitHub)** — https://github.com/z-shell/zsh-plugin-standard
- **How to Make Zsh Plugins** — https://github.com/zsh-users/zsh/blob/master/Etc/zsh-development-guide
- **Awesome Zsh Plugins** — https://github.com/unixorn/awesome-zsh-plugins
- **Oh My Zsh Plugin Development** — https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins-Overview

### Tips dan Praktik Terbaik

1. **Selalu gunakan standard `$0` handling.** Ini membuat plugin Anda portabel.
2. **Letakkan file plugin di root repository.** Plugin manager mencari `*.plugin.zsh` di root.
3. **Dokumentasikan plugin Anda.** Sertakan `README.md` dengan contoh penggunaan.
4. **Test di berbagai plugin manager.** Pastikan plugin berfungsi di Oh My Zsh, Antidote, dan Zinit.
5. **Gunakan `typeset -ga` untuk clean unload.** Ini memungkinkan plugin manager untuk menghapus fungsi Anda.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Tidak ada `$0` handling | Plugin tidak berfungsi saat di-load | Tambahkan standard `$0` handling |
| File plugin di subdirektori | Plugin manager tidak menemukan | Letakkan `*.plugin.zsh` di root |
| Tidak ada `#compdef` | Completion tidak berfungsi | Tambahkan `#compdef nama-command` |
| Fungsi tidak di-unset saat unload | Konflik antar plugin | Daftarkan fungsi di array global |

---

## 5. Mendokumentasikan Kontribusi

### Deskripsi Konkret & Peran dalam Kurikulum

Dokumentasi adalah bagian penting dari kontribusi Zsh. Setiap patch yang mengubah perilaku shell **harus** mencakup update dokumentasi. Di Zsh, dokumentasi ditulis dalam format **`yodl`** — format yang dikonversi ke manual pages, TeXinfo, dan HTML.

### Konsep Kunci & Filosofi Mendalam

**Mengapa dokumentasi manual?** Zsh tidak menggunakan generator dokumentasi otomatis dari komentar kode. Sebaliknya, dokumentasi ditulis secara manual dalam file `.yo` (yodl) di direktori `Doc/`. Ini memastikan bahwa dokumentasi **ditulis dengan sengaja** — bukan di-generate dari kode.

**ChangeLog: Sejarah perubahan manual.** Setiap commit ke Zsh harus menyertakan entry di file `ChangeLog`. Entry ini ditulis manual (bukan di-generate dari Git log) dan berfungsi sebagai **catatan sejarah resmi proyek**.

### Sintaks Dasar — Yodl dan ChangeLog

**Contoh Yodl (`Doc/Zsh/builtins.yo`):**

```bash
texinode(mybuiltin)(...)(...)
sect(My Builtin)
cindex(builtins)
cindex(my builtin)
findex(mybuiltin)
item(tt(mybuiltin) [ tt(-v) ] var(file))(
Deskripsi builtin dalam format Yodl.
)
```

**Contoh ChangeLog Entry:**

```bash
2026-10-12  Nama Developer  <email@example.com>

    * Src/completion.c: Fix completion for git rebase
    * Doc/Zsh/compsys.yo: Document new behavior
    * Test/W02jobs.ztst: Add test case
```

### Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Yodl** | Format dokumentasi Zsh | `.yo` files |
| **ChangeLog** | File log perubahan manual | `ChangeLog` |
| **Texinfo** | Format dokumentasi GNU | Output dari yodl |
| **`texinode`** | Yodl macro untuk node dokumentasi | `texinode(...)` |
| **`sect`** | Yodl macro untuk section | `sect(My Builtin)` |

### Sumber Referensi Lengkap

- **Yodl Documentation** — https://yodl.sourceforge.io/
- **Zsh Documentation Source** — https://github.com/zsh-users/zsh/tree/master/Doc
- **Zsh Development Guide (Documentation)** — https://github.com/zsh-users/zsh/blob/master/Etc/zsh-development-guide

---

## 6. Etika Open Source

### Deskripsi Konkret & Peran dalam Kurikulum

Etika open source adalah tentang **bagaimana berinteraksi dengan komunitas**. Di Zsh, etika sangat penting karena development terjadi melalui mailing list — komunikasi tertulis yang bisa disalahartikan. Memahami etika membantu Anda membangun reputasi positif dan berkontribusi secara efektif.

### Konsep Kunci & Filosofi Mendalam

**Prinsip utama: "Maintainer adalah sukarelawan."** Mereka tidak dibayar untuk merespons patch Anda. Mereka memiliki pekerjaan, keluarga, dan kehidupan. **Kesabaran dan rasa hormat** adalah mata uang utama dalam open source.

**Prinsip kedua: "Review adalah hadiah."** Ketika seseorang meluangkan waktu untuk me-review patch Anda — bahkan jika mereka menolaknya — itu adalah bentuk perhatian. Terima feedback dengan baik, bahkan jika Anda tidak setuju.

**Prinsip ketiga: "Konsistensi lebih penting daripada preferensi pribadi."** Jika proyek memiliki gaya coding tertentu, ikuti. Jangan mengusulkan perubahan gaya besar-besaran tanpa diskusi.

### Etika Mailing List Zsh

| Situasi | Etika |
|---|---|
| **Mengirim patch pertama** | Perkenalkan diri, jelaskan latar belakang |
| **Menerima feedback negatif** | Jangan defensif; tanyakan apa yang bisa diperbaiki |
| **Menunggu respons** | Tunggu 1-2 minggu sebelum follow-up |
| **Follow-up** | Gunakan "bump" yang sopan: "Any thoughts on this?" |
| **Menolak saran** | Jelaskan alasan dengan sopan; jangan serang pribadi |
| **Melihat patch orang lain** | Review jika Anda mampu; ini kontribusi berharga |

### Sumber Referensi Lengkap

- **Open Source Etiquette** — https://opensource.guide/how-to-contribute/
- **Git Patch Review Etiquette** — https://git-scm.com/docs/MyFirstContribution
- **Zsh Mailing List Etiquette** — https://zsh.sourceforge.io/Arc/mlist.html

---

## 7. Membangun Zsh dari Source [TAMBAHAN AUDIT]

> **📌 Mengapa Materi Ini Ditambahkan:** Kurikulum tidak menyebut proses build dari source, padahal ini adalah **prasyarat teknis** untuk berkontribusi. Tanpa bisa build Zsh, Anda tidak bisa test patch Anda.

### Sintaks Dasar — Build Lengkap

```bash
# ═══════════════════════════════════════════════════════════
# BUILD ZSH DARI SOURCE
# ═══════════════════════════════════════════════════════════

# 1. Install prasyarat
# Debian/Ubuntu:
sudo apt install -y git build-essential autoconf m4 yodl texi2html
# macOS:
brew install autoconf m4 yodl texi2html

# 2. Clone repository
git clone https://github.com/zsh-users/zsh.git
cd zsh

# 3. Generate configure script
./Util/preconfig

# 4. Konfigurasi build
./configure --prefix=/usr/local \
    --enable-etcdir=/etc \
    --enable-zshenv=/etc/zshenv

# 5. Build
make -j$(nproc)

# 6. Test (opsional tapi sangat disarankan)
make check

# 7. Install
sudo make install

# 8. Verifikasi
/usr/local/bin/zsh --version
```

**Prasyarat Build:**

| Tool | Kegunaan |
|---|---|
| **GNU autoconf 2.50+** | Menghasilkan script `configure` |
| **GNU m4** | Diperlukan oleh autoconf |
| **yodl** | Mengkonversi dokumentasi `.yo` |
| **texi2html** | Mengkonversi Texinfo ke HTML |
| **GCC/Clang** | Mengkompilasi C code |

### Sumber Referensi Lengkap

- **Zsh INSTALL Guide** — https://github.com/zsh-users/zsh/blob/master/INSTALL
- **Zsh Build DeepWiki** — https://deepwiki.com/zsh-users/zsh/1.2-installation

---

## 8. Proyek Akhir: Kontribusi Nyata [TAMBAHAN AUDIT]

### Panduan Langkah demi Langkah

**Langkah 1: Pilih Area Kontribusi**

| Area | Tingkat Kesulitan | Contoh |
|---|---|---|
| **Dokumentasi** | Mudah | Perbaiki typo, tambahkan contoh |
| **Completion** | Menengah | Tambahkan completion untuk tool baru |
| **Plugin** | Menengah | Buat plugin untuk workflow spesifik |
| **Bug fix** | Menengah-Sulit | Perbaiki bug di source code |
| **Fitur baru** | Sulit | Implementasi fitur yang diminta |

**Langkah 2: Temukan Bug atau Fitur**

- Baca arsip mailing list untuk bug yang belum diperbaiki
- Cek `Test/` untuk test case yang gagal
- Cari `TODO` atau `FIXME` di source code
- Gunakan Zsh sehari-hari dan catat frustrasi

**Langkah 3: Buat Patch**

```bash
# Buat branch
git checkout -b fix/my-contribution

# Edit files
# ...

# Test
make check

# Commit
git commit -m "Fix: deskripsi"

# Buat patch
git format-patch origin/master
```

**Langkah 4: Kirim ke Mailing List**

```bash
git send-email \
    --to="zsh-workers@zsh.org" \
    --subject="[PATCH] Fix: deskripsi" \
    0001-Fix-deskripsi.patch
```

**Langkah 5: Tangani Feedback**

- Tunggu 1-2 minggu
- Jika ada feedback, revisi patch dan kirim ulang
- Jika tidak ada respons, follow-up dengan sopan

---

## Ringkasan Modul 6.2

| Sub-bab | Topik | Estimasi Waktu |
|---|---|---|
| 1 | Sejarah dan Governance | 2-3 jam |
| 2 | Mailing List dan Komunikasi | 2-3 jam |
| 3 | Proses Patch dan Review | 4-5 jam |
| 4 | Menulis Plugin Zsh | 5-6 jam |
| 5 | Mendokumentasikan Kontribusi | 2-3 jam |
| 6 | Etika Open Source | 2 jam |
| 7 | Build dari Source | 2-3 jam |
| 8 | Proyek Akhir | 8-10 jam |
| **Total** | | **~27-35 jam** |

---

## Verifikasi Pemahaman

Sebelum melanjutkan ke Modul 6.3, pastikan Anda dapat:

- [ ] Menjelaskan model governance Zsh dan peran rotating coordinator
- [ ] Berlangganan mailing list Zsh dan mengirim email sesuai etika
- [ ] Membuat patch dengan format yang benar (context/unified diff)
- [ ] Menulis plugin Zsh dengan standard `$0` handling
- [ ] Menambahkan ChangeLog entry untuk kontribusi
- [ ] Membangun Zsh dari source dan menjalankan test
- [ ] Mengirim patch ke mailing list dan menangani feedback

---

## ✅ Materi Modul 6.2 telah selesai.
Kita akan melanjutkan ke **Modul 6.3: Spesialisasi — Pilih Jalur Anda** yang mencakup:

1. **Jalur A — DevOps & Cloud Automation:** CI/CD pipeline, AWS/GCP/Azure CLI, Infrastructure as Code
2. **Jalur B — Data Engineering & Analisis:** Pipeline data dengan `awk`/`sed`/`jq`, integrasi Python/R, otomatisasi ETL
3. **Jalur C — Developer Tooling & Produktivitas:** CLI tools, integrasi editor, FZF/ripgrep/fd/bat
4. **Proyek akhir** untuk setiap jalur

---

# MODUL 6.3: SPESIALISASI — PILIH JALUR ANDA

> **📌 Catatan Audit:** Modul ini dalam kurikulum asli hanya memberikan garis besar tiga jalur spesialisasi dengan sintaks contoh untuk Jalur A saja. Materi di bawah ini mengembangkan **ketiga jalur secara lengkap** dengan sintaks, studi kasus, terminologi, dan proyek akhir untuk masing-masing. Bagian yang ditandai **[TAMBAHAN AUDIT]** adalah materi yang melampaui kurikulum asli namun esensial untuk mencapai level Expert yang utuh.

---

## Struktur Pembelajaran Internal (Mini-Daftar Isi)

1. **Pendahuluan: Filosofi Spesialisasi** — Mengapa Zsh menjadi *force multiplier* di tiga domain berbeda
2. **Jalur A — DevOps & Cloud Automation** — CI/CD pipeline, AWS/GCP/Azure CLI, Infrastructure as Code
3. **Jalur B — Data Engineering & Analisis** — Pipeline data dengan `awk`/`sed`/`jq`, integrasi Python/R, otomatisasi ETL
4. **Jalur C — Developer Tooling & Produktivitas** — CLI tools, integrasi editor, FZF/ripgrep/fd/bat
5. **Proyek Akhir Setiap Jalur** — Assessment komprehensif dengan rubrik
6. **Perbandingan Jalur** — Tabel keputusan untuk memilih jalur yang tepat
7. **Referensi Lintas Jalur** — Sumber daya yang berlaku untuk ketiga jalur

---

## 1. Pendahuluan: Filosofi Spesialisasi

### Deskripsi Konkret & Peran dalam Kurikulum

Setelah menguasai fondasi Zsh (Fase 1-5) dan arsitektur enterprise (Modul 6.1), Anda kini berada di titik percabangan. Spesialisasi bukan berarti "berhenti belajar Zsh" — ini berarti **menggunakan Zsh sebagai alat untuk mendominasi domain tertentu**. Setiap jalur memiliki pola, tools, dan workflow yang berbeda.

### Konsep Kunci & Filosofi Mendalam

**Mengapa Zsh adalah *force multiplier* di setiap domain?**

Bayangkan Anda adalah seorang DevOps engineer. Anda memiliki 50 server, 10 cluster Kubernetes, dan 3 cloud provider. Tanpa shell yang kuat, Anda akan menghabiskan 80% waktu untuk mengetik perintah berulang. Dengan Zsh yang dioptimasi, Anda bisa mengotomasi deployment, switching context, dan monitoring — semua dari satu terminal.

**Prinsip universal ketiga jalur:**
1. **Composability** — Zsh dirancang untuk menggabungkan tools kecil (`awk`, `jq`, `fzf`) menjadi pipeline powerful
2. **Automation first** — Setiap tugas yang dilakukan lebih dari dua kali harus dijadikan fungsi atau alias
3. **Context awareness** — Shell harus tahu "di mana Anda berada" (cloud profile, Kubernetes namespace, Git branch) dan menyesuaikan perilakunya
4. **Feedback loop yang cepat** — Tools modern (FZF, ripgrep) memberikan umpan balik instan, mengurangi friksi kognitif

### Diagram: Tiga Jalur Spesialisasi

```bash
┌─────────────────────────────────────────────────────────────────────┐
│                    TIGA JALUR SPESIALISASI ZSH                       │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐     │
│  │   JALUR A       │  │   JALUR B       │  │   JALUR C       │     │
│  │   DevOps &      │  │   Data Eng &    │  │   Developer     │     │
│  │   Cloud         │  │   Analisis      │  │   Tooling       │     │
│  ├─────────────────┤  ├─────────────────┤  ├─────────────────┤     │
│  │                 │  │                 │  │                 │     │
│  │ • CI/CD         │  │ • ETL pipeline  │  │ • CLI tools     │     │
│  │ • AWS/GCP/Azure │  │ • awk/sed/jq    │  │ • Editor integ  │     │
│  │ • Terraform     │  │ • Python/R      │  │ • FZF/ripgrep   │     │
│  │ • Kubernetes    │  │ • Visualisasi   │  │ • Produktivitas │     │
│  │                 │  │                 │  │                 │     │
│  └────────┬────────┘  └────────┬────────┘  └────────┬────────┘     │
│           │                    │                    │              │
│           ▼                    ▼                    ▼              │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │              FONDASI BERSAMA (Fase 1-5 + Modul 6.1-6.2)      │   │
│  │   Startup files • Modular config • Plugin • Security         │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

> **🔍 Visualisasi Sangat Membantu di Sini:** Diagram di atas akan lebih efektif jika divisualisasikan sebagai *decision tree* dengan pertanyaan pemandu: "Apakah Anda bekerja dengan infrastruktur? → Jalur A", "Apakah Anda bekerja dengan data? → Jalur B", "Apakah Anda membangun tools untuk developer? → Jalur C". Tambahkan ikon untuk setiap domain.

---

## 2. JALUR A — DevOps & Cloud Automation

### Deskripsi Konkret & Peran dalam Kurikulum

Jalur ini untuk Anda yang bekerja dengan **infrastruktur, deployment, dan cloud services**. Fokusnya adalah menggunakan Zsh untuk mengotomasi siklus hidup aplikasi: build → test → deploy → monitor. Di tingkat enterprise, kemampuan ini berarti Anda bisa men-deploy ke produksi dengan satu perintah yang aman dan idempoten.

### Konsep Kunci & Filosofi Mendalam

**DevOps adalah tentang *pipeline*, bukan *command*.** Seorang DevOps engineer tidak mengetik `docker build`, lalu `docker push`, lalu `aws ecs update-service` secara manual. Mereka menulis **fungsi** yang menggabungkan semua langkah menjadi satu unit yang dapat diulang, di-test, dan di-audit.

**Prinsip "fail fast" dalam shell scripting.** Script DevOps harus berhenti pada error pertama. Jika build gagal, jangan lanjutkan ke push. Jika push gagal, jangan lanjutkan ke deploy. Ini dicapai dengan `set -euo pipefail` — tiga opsi yang memastikan shell keluar pada error, variabel tak terdefinisi, dan kegagalan pipe.

### Sintaks Dasar — Fungsi Deploy yang Robust

```bash
#!/bin/zsh
# deploy.zsh — Script deploy enterprise-grade

# ═══════════════════════════════════════════════════════════
# 1. STRICT MODE — WAJIB untuk script produksi
# ═══════════════════════════════════════════════════════════
set -euo pipefail
# -e: exit on error
# -u: exit on undefined variable
# -o pipefail: exit if any command in a pipe fails

# ═══════════════════════════════════════════════════════════
# 2. KONFIGURASI — Gunakan variabel, jangan hardcode
# ═══════════════════════════════════════════════════════════
readonly APP_NAME="myapp"
readonly ECR_URL="${ECR_URL:-123456789012.dkr.ecr.us-east-1.amazonaws.com}"
readonly AWS_REGION="${AWS_REGION:-us-east-1}"
readonly CLUSTER_NAME="production-cluster"
readonly SERVICE_NAME="myapp-service"

# ═══════════════════════════════════════════════════════════
# 3. FUNGSI UTAMA — Dengan error handling
# ═══════════════════════════════════════════════════════════
deploy() {
    local env="${1:-staging}"
    
    # Validasi environment
    if [[ ! "$env" =~ ^(staging|production)$ ]]; then
        echo "Error: environment harus 'staging' atau 'production'" >&2
        return 1
    fi
    
    echo "🚀 Memulai deploy ke environment: $env"
    
    # Step 1: Build Docker image
    echo "📦 Building Docker image..."
    docker build -t "${APP_NAME}:${env}" . || {
        echo "❌ Build gagal" >&2
        return 1
    }
    
    # Step 2: Login ke ECR
    echo "🔐 Login ke ECR..."
    aws ecr get-login-password --region "$AWS_REGION" \
        | docker login --username AWS --password-stdin "$ECR_URL" || {
        echo "❌ Login ECR gagal" >&2
        return 1
    }
    
    # Step 3: Tag dan push
    echo "📤 Push ke ECR..."
    docker tag "${APP_NAME}:${env}" "${ECR_URL}/${APP_NAME}:${env}"
    docker push "${ECR_URL}/${APP_NAME}:${env}" || {
        echo "❌ Push gagal" >&2
        return 1
    }
    
    # Step 4: Update ECS service
    echo "🔄 Update ECS service..."
    aws ecs update-service \
        --cluster "$CLUSTER_NAME" \
        --service "$SERVICE_NAME" \
        --force-new-deployment \
        --region "$AWS_REGION" || {
        echo "❌ Update service gagal" >&2
        return 1
    }
    
    echo "✅ Deploy ke $env selesai!"
}

# ═══════════════════════════════════════════════════════════
# 4. TANGKAP ERROR — Dengan trap untuk cleanup
# ═══════════════════════════════════════════════════════════
trap 'echo "❌ Deploy gagal pada line $LINENO" >&2' ERR

# ═══════════════════════════════════════════════════════════
# 5. EKSEKUSI — Panggil fungsi utama
# ═══════════════════════════════════════════════════════════
deploy "$@"
```

**Penjelasan Sintaks Zsh (kata demi kata):**

| Sintaks | Penjelasan |
|---|---|
| `set -euo pipefail` | Strict mode: exit on error (`-e`), undefined var (`-u`), pipe failure (`-o pipefail`) |
| `readonly APP_NAME="myapp"` | Buat variabel yang tidak bisa diubah |
| `"${ECR_URL:-default}"` | Parameter expansion dengan default — gunakan nilai ECR_URL jika ada, jika tidak gunakan default |
| `local env="${1:-staging}"` | Variabel lokal dengan default parameter |
| `[[ ! "$env" =~ ^(staging\|production)$ ]]` | Regex match dalam `[[ ]]` |
| `>&2` | Redirect ke stderr (error stream) |
| `\|\| { ... }` | Logical OR — jalankan blok jika perintah sebelumnya gagal |
| `trap '...' ERR` | Trap error dan jalankan command |
| `$LINENO` | Nomor baris saat error terjadi |

### Studi Kasus: Interaksi dengan AWS CLI

**AWS CLI adalah tool paling fundamental untuk DevOps di AWS.** Salah satu tantangan terbesar adalah **manajemen profil** — berpindah antara akun dev, staging, dan production. Berikut adalah fungsi yang memanfaatkan pola dari extension AWS CLI:

```bash
# ~/.config/zsh/conf.d/20-aws.zsh — AWS helper functions

# ═══════════════════════════════════════════════════════════
# FUNGSI: aws-switch — Ganti AWS profile dengan konfirmasi
# ═══════════════════════════════════════════════════════════
aws-switch() {
    local profile="${1:-}"
    
    if [[ -z "$profile" ]]; then
        # Mode interaktif dengan fzf
        profile=$(aws configure list-profiles | fzf --prompt="Pilih AWS profile: ")
    fi
    
    [[ -z "$profile" ]] && return 1
    
    # Konfirmasi untuk production
    if [[ "$profile" == *"prod"* ]]; then
        echo "⚠️  Anda akan beralih ke PRODUCTION profile: $profile"
        read -q "REPLY?Lanjutkan? (y/n) "
        echo
        [[ "$REPLY" != "y" ]] && return 1
    fi
    
    export AWS_PROFILE="$profile"
    export AWS_DEFAULT_PROFILE="$profile"
    
    # Tampilkan informasi
    echo "✅ AWS Profile: $profile"
    aws sts get-caller-identity --output table 2>/dev/null || true
}

# Alias untuk kompatibilitas
alias asp='aws-switch'

# ═══════════════════════════════════════════════════════════
# FUNGSI: aws-region — Set region
# ═══════════════════════════════════════════════════════════
aws-region() {
    local region="${1:-}"
    [[ -z "$region" ]] && region=$(aws ec2 describe-regions \
        --query 'Regions[].RegionName' --output text | tr '\t' '\n' | fzf)
    
    [[ -z "$region" ]] && return 1
    
    export AWS_REGION="$region"
    export AWS_DEFAULT_REGION="$region"
    echo "✅ AWS Region: $region"
}

alias asr='aws-region'
```

**Mengapa ini penting?** Oh My Zsh menyediakan plugin `aws` yang secara otomatis mengelola `AWS_PROFILE`, `AWS_REGION`, dan bahkan MFA/SSO. Anda tidak perlu menulis semuanya dari nol — cukup aktifkan plugin dan tambahkan fungsi kustom di atasnya.

### Studi Kasus: Terraform dan Kubernetes

**Terraform** memerlukan `terraform init` setiap kali Anda beralih antar workspace. **Kubernetes** memerlukan `kubectl config use-context`. Keduanya adalah kandidat sempurna untuk otomatisasi Zsh:

```bash
# ~/.config/zsh/conf.d/25-k8s-tf.zsh — Kubernetes & Terraform helpers

# ═══════════════════════════════════════════════════════════
# FUNGSI: k8s-switch — Ganti Kubernetes context
# ═══════════════════════════════════════════════════════════
k8s-switch() {
    local context="${1:-}"
    [[ -z "$context" ]] && context=$(kubectl config get-contexts -o name | fzf --prompt="Pilih context: ")
    
    [[ -z "$context" ]] && return 1
    
    kubectl config use-context "$context"
    # Tampilkan namespace
    local ns=$(kubectl config view --minify -o jsonpath='{..namespace}')
    echo "✅ Context: $context | Namespace: ${ns:-default}"
}

alias kctx='k8s-switch'

# ═══════════════════════════════════════════════════════════
# FUNGSI: tf-switch — Ganti Terraform workspace
# ═══════════════════════════════════════════════════════════
tf-switch() {
    local workspace="${1:-}"
    
    if [[ -z "$workspace" ]]; then
        workspace=$(terraform workspace list | sed 's/^*//' | tr -d ' ' | fzf --prompt="Pilih workspace: ")
    fi
    
    [[ -z "$workspace" ]] && return 1
    
    terraform workspace select "$workspace" && {
        echo "✅ Terraform workspace: $workspace"
        # Opsional: auto-init
        if [[ -n "$TF_AUTO_INIT" ]]; then
            echo "🔄 Running terraform init..."
            terraform init -reconfigure
        fi
    }
}

alias tfw='tf-switch'
```

**Pola yang digunakan:** Setiap fungsi mengikuti pola **"pilih → konfirmasi → eksekusi → tampilkan state"**. Ini konsisten dengan prinsip DevOps: *idempoten, aman, dan memberikan feedback yang jelas*.

### Integrasi CI/CD: GitHub Actions dengan Zsh

Zsh bukan hanya untuk interaktif. Di CI/CD pipeline, Anda bisa menggunakan Zsh sebagai shell untuk step-step tertentu:

```yaml
# .github/workflows/deploy.yml — GitHub Actions dengan Zsh
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Zsh
        run: |
          sudo apt-get install -y zsh
          echo "SHELL=/usr/bin/zsh" >> $GITHUB_ENV

      - name: Deploy with Zsh
        shell: zsh {0}
        run: |
          set -euo pipefail
          source ./scripts/deploy.zsh
          deploy production
```

**Penjelasan:**
- `shell: zsh {0}` — Beritahu GitHub Actions untuk menggunakan Zsh
- `source ./scripts/deploy.zsh` — Muat fungsi deploy
- `set -euo pipefail` — Strict mode di CI (bahkan lebih penting di CI karena tidak ada interaksi manual)

### Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **Strict mode** | Mode shell yang exit pada error | `set -euo pipefail` |
| **Idempoten** | Dijalankan berkali-kali menghasilkan state yang sama | `terraform apply` |
| **ECR** | Elastic Container Registry (AWS) | `aws ecr get-login-password` |
| **ECS** | Elastic Container Service (AWS) | `aws ecs update-service` |
| **Workspace** | Konteks terisolasi di Terraform | `terraform workspace select` |
| **Context** | Konfigurasi cluster di Kubernetes | `kubectl config use-context` |
| **Fail fast** | Berhenti pada error pertama | `set -e` |
| **Trap** | Handler untuk signal/error | `trap '...' ERR` |

### Hubungan dengan Modul Lain

- **Modul 6.1 (Sub-bab 6-8):** Deployment Ansible, keamanan secrets, dan audit
- **Modul 6.2 (Sub-bab 4):** Menulis plugin Zsh untuk tools DevOps
- **Jalur C:** FZF dan tools modern digunakan di sini untuk pemilihan interaktif

### Sumber Referensi Lengkap

- **AWS CLI Documentation** — https://docs.aws.amazon.com/cli/
- **AWS CLI Zsh Completion** — https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html
- **Terraform CLI Documentation** — https://developer.hashicorp.com/terraform/cli
- **kubectl Documentation** — https://kubernetes.io/docs/reference/kubectl/
- **Oh My Zsh AWS Plugin** — https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/aws
- **Oh My Zsh kubectl Plugin** — https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl
- **Oh My Zsh terraform Plugin** — https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/terraform
- **awse — AWS CLI Extension** — https://github.com/isac7722/aws-cli-extension
- **GitHub Actions: Shell Zsh** — https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idstepsshell
- **ShellCheck** — https://www.shellcheck.net/

### Tips dan Praktik Terbaik

1. **Selalu `set -euo pipefail`.** Di CI/CD, ini menyelamatkan Anda dari deploy yang tidak sengaja.
2. **Gunakan `trap` untuk cleanup.** Jika script gagal di tengah, trap memastikan resource dibersihkan.
3. **Jangan hardcode secrets.** Gunakan AWS Secrets Manager, environment variable, atau 1Password CLI.
4. **Test script dengan `shellcheck`.** ShellCheck adalah linter untuk shell script yang menangkap bug umum.
5. **Gunakan `--dry-run` jika tersedia.** `terraform plan`, `kubectl apply --dry-run=client`, dll.
6. **Log semua aksi.** Di lingkungan enterprise, audit trail adalah keharusan.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| Tidak pakai `set -e` | Script lanjut meskipun build gagal | Tambahkan `set -euo pipefail` |
| Hardcode credentials | Kredensial bocor di Git | Gunakan environment variable atau secret manager |
| Tidak validasi input | Script deploy ke environment yang salah | Validasi `$1` dengan regex |
| Tidak ada konfirmasi production | Deploy tanpa sengaja | Tambahkan prompt `read -q` untuk production |
| Pipe tanpa `pipefail` | `docker build \| tee log` — build gagal tapi script lanjut | Set `pipefail` |

---

## 3. JALUR B — Data Engineering & Analisis

### Deskripsi Konkret & Peran dalam Kurikulum

Jalur ini untuk Anda yang bekerja dengan **data: ETL, analisis, transformasi, dan visualisasi**. Fokusnya adalah menggunakan Zsh sebagai "lem" yang menghubungkan tools data engineering: `awk` untuk pemrosesan kolom, `sed` untuk transformasi teks, `jq` untuk JSON, dan Python/R untuk analisis yang lebih kompleks.

### Konsep Kunci & Filosofi Mendalam

**Filosofi Unix untuk data: "Small tools, powerful pipelines."** Alih-alih menulis satu program besar Python untuk setiap tugas, data engineer yang efektif menggabungkan tools kecil yang masing-masing melakukan satu hal dengan baik. `awk` memproses kolom, `sed` mengganti teks, `jq` mengekstrak JSON — dan Zsh menjadi konduktor dari orkestra ini.

**Mengapa shell untuk data?** Ada tiga alasan:
1. **Kecepatan prototyping** — Pipeline data bisa ditulis dalam hitungan menit, bukan jam
2. **Streaming** — Tools Unix membaca data baris per baris, sehingga bisa menangani file yang lebih besar dari RAM
3. **Composability** — Pipeline bisa digabungkan dengan mudah: `cat data.csv | awk ... | jq ... > output.json`

**Kapan TIDAK menggunakan shell?** Untuk analisis statistik kompleks, machine learning, atau visualisasi, shell bukan alat yang tepat. Gunakan Python/R. Shell adalah untuk **persiapan data dan otomatisasi**, bukan untuk analisis mendalam.

### Sintaks Dasar — Pipeline ETL dengan awk, sed, jq

```bash
#!/bin/zsh
# etl-pipeline.zsh — Pipeline ETL sederhana

set -euo pipefail

# ═══════════════════════════════════════════════════════════
# STUDI KASUS: Transformasi data penjualan
# Input: CSV dengan kolom: id, tanggal, produk, jumlah, harga
# Output: JSON dengan total per produk
# ═══════════════════════════════════════════════════════════

input_file="${1:-sales.csv}"
output_file="${2:-summary.json}"

echo "📊 Memproses $input_file..."

# Step 1: Filter dan transformasi dengan awk
# -F',' = field separator adalah koma
# NR>1 = skip header (baris pertama)
# {print $3, $4*$5} = cetak produk dan total (jumlah * harga)
awk -F',' 'NR>1 {print $3, $4*$5}' "$input_file" \
    | \
# Step 2: Agregasi dengan awk (sum per produk)
# {sum[$1]+=$2} = associative array: sum[produk] += total
# END {for (p in sum) print p, sum[p]} = cetak hasil akhir
awk '{sum[$1]+=$2} END {for (p in sum) print p, sum[p]}' \
    | \
# Step 3: Konversi ke JSON dengan jq
# -R = raw input (bukan JSON)
# -s = slurp (baca semua input sebagai satu string)
# split("\n") = split per baris
# map(select(length > 0)) = hapus baris kosong
# map(split(" ")) = split per spasi
# map({produk: .[0], total: .[1]}) = buat object JSON
jq -R -s '
    split("\n") 
    | map(select(length > 0)) 
    | map(split(" ")) 
    | map({produk: .[0], total: (.[1] | tonumber)})
' > "$output_file"

echo "✅ Output tersimpan di $output_file"
```

**Penjelasan Sintaks (kata demi kata):**

| Sintaks | Penjelasan |
|---|---|
| `awk -F','` | Set field separator ke koma |
| `NR>1` | Number of Record > 1 (skip header) |
| `{print $3, $4*$5}` | Cetak kolom 3 dan hasil kali kolom 4×5 |
| `{sum[$1]+=$2}` | Associative array: tambahkan `$2` ke `sum[$1]` |
| `END {for (p in sum) ...}` | Blok END: iterasi semua kunci di `sum` |
| `jq -R -s` | `-R` raw input, `-s` slurp (baca semua sebagai satu string) |
| `split("\n")` | Split string per newline |
| `map(select(length > 0))` | Map: filter baris kosong |
| `map({produk: .[0], total: ...})` | Buat object JSON dengan key `produk` dan `total` |
| `tonumber` | Konversi string ke number |

### Contoh jq yang Lebih Kompleks

```bash
# ═══════════════════════════════════════════════════════════
# jq untuk data engineer — pola umum
# ═══════════════════════════════════════════════════════════

# 1. Ambil field tertentu
curl -s https://api.example.com/users | jq '.users[] | {name: .name, email: .email}'

# 2. Filter berdasarkan kondisi
jq '.users[] | select(.age > 30)' users.json

# 3. Group by
jq 'group_by(.department) | map({dept: .[0].department, count: length})' employees.json

# 4. Sort
jq 'sort_by(.salary) | reverse' employees.json

# 5. Hitung agregat
jq '[.users[].age] | add / length' users.json

# 6. Konversi CSV ke JSON
# Input CSV: name,age,city
# Output: [{"name":"Alice","age":30,"city":"NYC"}, ...]
jq -R -s 'split("\n") | map(select(length > 0)) | 
    (.[0] | split(",")) as $headers | 
    .[1:] | map(split(",") | [range(length)] as $i | 
    reduce $i[] as $j ({}; .[$headers[$j]] = .[$j]))' data.csv
```

### Integrasi dengan Python

**Shell dan Python bukan kompetitor — mereka mitra.** Shell untuk orkestrasi dan transformasi ringan, Python untuk analisis kompleks:

```bash
# ═══════════════════════════════════════════════════════════
# FUNGSI: py-pipe — Pipe shell output ke Python inline
# ═══════════════════════════════════════════════════════════
py-pipe() {
    local code="$1"
    shift
    python3 -c "
import sys, json
data = sys.stdin.read()
$code
" "$@"
}

# Contoh penggunaan:
# 1. Konversi JSON ke CSV
cat data.json | py-pipe "
import csv, json, sys
data = json.loads(data)
writer = csv.DictWriter(sys.stdout, fieldnames=data[0].keys())
writer.writeheader()
writer.writerows(data)
" > data.csv

# 2. Analisis statistik sederhana
cat numbers.txt | py-pipe "
import statistics
numbers = [float(x) for x in data.split()]
print(f'Mean: {statistics.mean(numbers):.2f}')
print(f'Median: {statistics.median(numbers):.2f}')
print(f'Std Dev: {statistics.stdev(numbers):.2f}')
"
```

**Integrasi dengan virtual environment:**

```bash
# ~/.config/zsh/conf.d/30-python.zsh — Python environment helper

# ═══════════════════════════════════════════════════════════
# FUNGSI: venv — Buat dan aktifkan virtual environment
# ═══════════════════════════════════════════════════════════
venv() {
    local name="${1:-venv}"
    if [[ ! -d "$name" ]]; then
        echo "📦 Membuat virtual environment: $name"
        python3 -m venv "$name"
    fi
    source "$name/bin/activate"
    echo "✅ Aktif: $VIRTUAL_ENV"
}

# Alias
alias activate='source venv/bin/activate'
alias py='python3'
alias pipup='pip3 install --upgrade pip'
```

**Catatan:** Ada plugin Zsh seperti `zsh-autoswitch-virtualenv` yang secara otomatis mengaktifkan virtual environment saat Anda `cd` ke direktori proyek. Ini menghilangkan kebutuhan untuk manual `source venv/bin/activate`.

### Alur Kerja ETL dengan Shell

```bash
┌─────────────────────────────────────────────────────────────┐
│                   ETL WORKFLOW DENGAN ZSH                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  EXTRACT                                                    │
│  ┌──────────────┐                                          │
│  │ API Call     │  curl -s https://api.example.com/data     │
│  │ Database     │  psql -c "SELECT * FROM table"            │
│  │ File         │  cat data.csv                             │
│  └──────┬───────┘                                          │
│         │                                                   │
│         ▼                                                   │
│  TRANSFORM                                                  │
│  ┌──────────────┐                                          │
│  │ awk          │  Proses kolom, filter, agregasi           │
│  │ sed          │  Ganti teks, hapus baris                  │
│  │ jq           │  Parse/transform JSON                     │
│  │ Python       │  Analisis kompleks, ML                    │
│  └──────┬───────┘                                          │
│         │                                                   │
│         ▼                                                   │
│  LOAD                                                       │
│  ┌──────────────┐                                          │
│  │ Database     │  psql -c "COPY ... FROM STDIN"            │
│  │ File         │  > output.json                            │
│  │ Dashboard    │  curl -X POST -d @data.json               │
│  └──────────────┘                                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

> **🔍 Visualisasi Sangat Membantu di Sini:** Diagram ETL di atas akan lebih efektif jika divisualisasikan sebagai *pipeline horizontal* dengan tiga zona (Extract, Transform, Load) dan panah yang menunjukkan aliran data. Tambahkan contoh perintah di setiap tahap.

### Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **ETL** | Extract, Transform, Load | Pipeline data |
| **`awk`** | Bahasa pemrograman untuk pemrosesan teks berbasis kolom | `awk -F',' '{print $1}'` |
| **`sed`** | Stream editor untuk transformasi teks | `sed 's/old/new/g'` |
| **`jq`** | JSON processor | `jq '.key'` |
| **`yq`** | YAML processor (mirip jq) | `yq '.key'` |
| **Associative array** | Array dengan key string (di awk/zsh) | `sum[$1]+=$2` |
| **Slurp** | Baca semua input sebagai satu string | `jq -s` |
| **Virtual environment** | Isolasi dependencies Python | `python3 -m venv venv` |

### Hubungan dengan Modul Lain

- **Modul 6.1 (Sub-bab 7):** Plugin manager untuk tools data (jq-zsh-plugin)
- **Modul 6.2 (Sub-bab 4):** Menulis plugin Zsh untuk fungsi data khusus
- **Jalur C:** FZF untuk pemilihan interaktif dalam pipeline

### Sumber Referensi Lengkap

- **jq Manual** — https://jqlang.github.io/jq/manual/
- **jq Play (Interactive)** — https://jqplay.org/
- **awk Tutorial** — https://www.grymoire.com/Unix/Awk.html
- **sed Tutorial** — https://www.grymoire.com/Unix/Sed.html
- **Miller (mlr)** — https://miller.readthedocs.io/
- **Python venv Documentation** — https://docs.python.org/3/library/venv.html
- **zsh-autoswitch-virtualenv** — https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv
- **jq-zsh-plugin** — https://github.com/reegnz/jq-zsh-plugin
- **fzfrepl — Interactive pipeline editing** — https://github.com/vapniks/fzfrepl

### Tips dan Praktik Terbaik

1. **Gunakan `jq` untuk JSON, `yq` untuk YAML.** Keduanya memiliki sintaks serupa.
2. **Test `jq` query di jqplay.org** sebelum memasukkannya ke script.
3. **Gunakan `awk` untuk CSV sederhana.** Untuk CSV kompleks (quoting, embedded commas), gunakan `mlr` atau Python.
4. **Pipe adalah teman Anda.** Jangan takut untuk merangkai 5-6 tools dalam satu pipeline.
5. **Simpan pipeline sebagai fungsi.** Jika Anda sering menggunakan pipeline tertentu, jadikan fungsi Zsh.
6. **Gunakan `tee` untuk debugging.** `command | tee debug.log | next-command` menyimpan intermediate output.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| `awk` dengan CSV yang mengandung koma di dalam quote | Data terpotong salah | Gunakan `mlr` atau `csvkit` |
| `jq` gagal parse JSON | Error "Invalid JSON" | Validasi dengan `jq .` dulu |
| Pipe kehilangan data | Output kosong | Cek exit code dengan `echo $?` |
| `sed` mengganti semua kemunculan | Terlalu banyak penggantian | Gunakan `sed 's/old/new/2'` untuk hanya occurrence ke-2 |
| Tidak handle error di pipeline | Data corrupt | Gunakan `set -o pipefail` |
| `awk` tidak bisa akses variabel Zsh | Variabel kosong | Gunakan `awk -v var="$ZSH_VAR"` |

---

## 4. JALUR C — Developer Tooling & Produktivitas

### Deskripsi Konkret & Peran dalam Kurikulum

Jalur ini untuk Anda yang ingin **membangun tools untuk developer lain** atau **memaksimalkan produktivitas pribadi di terminal**. Fokusnya adalah menciptakan lingkungan shell yang *frictionless*: pencarian file instan, navigasi cepat, dan tools yang "terasa native" di Zsh.

### Konsep Kunci & Filosofi Mendalam

**Produktivitas bukan tentang mengetik lebih cepat — ini tentang mengurangi friksi kognitif.** Setiap kali Anda harus mengingat path file, syntax command, atau nama branch, Anda kehilangan fokus dari pekerjaan sebenarnya. Tools modern seperti FZF, ripgrep, fd, dan bat menghilangkan friksi ini dengan memberikan **umpan balik visual instan** dan **pencarian fuzzy**.

**Filosofi "Unix philosophy, modern implementation."** Tools seperti `fd`, `ripgrep`, dan `bat` adalah "reimplementasi modern" dari `find`, `grep`, dan `cat`. Mereka lebih cepat, lebih intuitif, dan menghormati `.gitignore` secara default.

### Sintaks Dasar — Integrasi FZF dengan Zsh

**FZF adalah *fuzzy finder* serbaguna.** Ia bisa digunakan untuk mencari file, history, branch Git, proses, dan apa pun yang bisa di-pipe.

```bash
# ~/.config/zsh/.zshrc — FZF setup

# ═══════════════════════════════════════════════════════════
# FZF: Inisialisasi
# ═══════════════════════════════════════════════════════════
# Cara 1: Source langsung (paling sederhana)
source <(fzf --zsh)

# Cara 2: Konfigurasi manual
export FZF_DEFAULT_OPTS="
    --height 40%
    --layout=reverse
    --border
    --preview 'bat --color=always --style=numbers --line-range=:200 {}'
    --preview-window=right:60%
"

# Gunakan fd sebagai sumber file (lebih cepat, respect .gitignore)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# ═══════════════════════════════════════════════════════════
# FZF: Keybindings
# ═══════════════════════════════════════════════════════════
# Ctrl+R: Fuzzy history search (bawaan fzf)
# Ctrl+T: Fuzzy file search (bawaan fzf)
# Alt+C:  Fuzzy cd (bawaan fzf)

# Binding kustom:
# Ctrl+G: Git branch search
fzf-git-branch() {
    git branch -a --color=always | grep -v '/HEAD\s' | fzf --ansi \
        --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(echo {} | sed "s/.* //")' \
        | sed 's/.* //'
}

# Ctrl+O: File search + open in editor
fzf-file-open() {
    local file
    file=$(fzf --preview 'bat --color=always {}')
    [[ -n "$file" ]] && ${EDITOR:-vim} "$file"
}

# Bind keys
bindkey -s '^G' 'fzf-git-branch\n'
bindkey -s '^O' 'fzf-file-open\n'
```

**Penjelasan Sintaks:**

| Sintaks | Penjelasan |
|---|---|
| `source <(fzf --zsh)` | Proses substitution — jalankan `fzf --zsh` dan source output-nya |
| `FZF_DEFAULT_OPTS` | Opsi default untuk semua invokasi fzf |
| `--preview 'bat ... {}'` | Preview dengan `bat`, `{}` = file yang dipilih |
| `FZF_DEFAULT_COMMAND` | Command yang digunakan fzf untuk daftar file |
| `fd --type f --hidden` | Cari file (`f`), termasuk hidden |
| `--follow` | Ikuti symlink |
| `--exclude .git` | Kecualikan direktori .git |
| `bindkey -s '^G' '...'` | Bind Ctrl+G ke string command |
| `sed 's/.* //'` | Hapus semua sebelum spasi terakhir |

### Alias Modern CLI Tools

```bash
# ~/.config/zsh/conf.d/40-modern-cli.zsh — Alias untuk tools modern

# ═══════════════════════════════════════════════════════════
# Bat (cat dengan syntax highlighting)
# ═══════════════════════════════════════════════════════════
alias cat='bat --paging=never'
alias catp='bat'                    # dengan paging
alias catl='bat --style=plain'      # tanpa line numbers

# ═══════════════════════════════════════════════════════════
# Eza / lsd (ls modern)
# ═══════════════════════════════════════════════════════════
if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -la --icons --group-directories-first --git'
    alias lt='eza --tree --icons --level=2'
    alias lg='eza -la --icons --group-directories-first --git --sort=size'
elif command -v lsd &>/dev/null; then
    alias ls='lsd --group-dirs first'
    alias ll='lsd -la --group-dirs first'
fi

# ═══════════════════════════════════════════════════════════
# Ripgrep (grep modern)
# ═══════════════════════════════════════════════════════════
if command -v rg &>/dev/null; then
    alias grep='rg'
    alias rgi='rg -i'               # case-insensitive
    alias rgw='rg -w'               # whole word
    alias rgl='rg -l'               # hanya nama file
    alias rgn='rg --no-ignore'      # ignore .gitignore
fi

# ═══════════════════════════════════════════════════════════
# fd (find modern)
# ═══════════════════════════════════════════════════════════
if command -v fd &>/dev/null; then
    alias find='fd'
    alias fde='fd -e'               # cari berdasarkan ekstensi
    alias fdh='fd -H'               # termasuk hidden
fi

# ═══════════════════════════════════════════════════════════
# Zoxide (cd pintar)
# ═══════════════════════════════════════════════════════════
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
    # Sekarang `z` dan `zi` tersedia
    # z project     → cd ke project (fuzzy)
    # zi            → interaktif dengan fzf
fi

# ═══════════════════════════════════════════════════════════
# Git dengan delta (diff viewer)
# ═══════════════════════════════════════════════════════════
if command -v delta &>/dev/null; then
    export GIT_PAGER='delta'
    export DELTA_FEATURES='side-by-side line-numbers decorations'
fi
```

### Membangun CLI Tool dengan Zsh

**Zsh bisa digunakan untuk membangun CLI tool yang kompleks** dengan subcommands, help, dan completion. Berikut adalah template:

```bash
#!/usr/bin/env zsh
# mytool — CLI tool example

set -euo pipefail

# ═══════════════════════════════════════════════════════════
# VERSION dan HELP
# ═══════════════════════════════════════════════════════════
readonly VERSION="1.0.0"

show_help() {
    cat <<EOF
mytool $VERSION — Contoh CLI tool Zsh

Penggunaan:
    mytool <command> [options]

Commands:
    hello <name>    Sapa seseorang
    list [dir]      List file di direktori
    find <pattern>  Cari file berdasarkan pattern
    help            Tampilkan bantuan ini
    version         Tampilkan versi

Options:
    -h, --help      Tampilkan bantuan
    -v, --verbose   Mode verbose
EOF
}

# ═══════════════════════════════════════════════════════════
# FUNGSI: hello
# ═══════════════════════════════════════════════════════════
cmd_hello() {
    local name="${1:-World}"
    echo "Hello, $name!"
}

# ═══════════════════════════════════════════════════════════
# FUNGSI: list
# ═══════════════════════════════════════════════════════════
cmd_list() {
    local dir="${1:-.}"
    if [[ ! -d "$dir" ]]; then
        echo "Error: '$dir' bukan direktori" >&2
        return 1
    fi
    ls -la "$dir"
}

# ═══════════════════════════════════════════════════════════
# FUNGSI: find
# ═══════════════════════════════════════════════════════════
cmd_find() {
    local pattern="${1:?Error: pattern diperlukan}"
    if command -v fd &>/dev/null; then
        fd "$pattern"
    else
        find . -name "*${pattern}*" -type f
    fi
}

# ═══════════════════════════════════════════════════════════
# MAIN: Dispatch command
# ═══════════════════════════════════════════════════════════
main() {
    local cmd="${1:-help}"
    shift || true

    case "$cmd" in
        hello)   cmd_hello "$@" ;;
        list)    cmd_list "$@" ;;
        find)    cmd_find "$@" ;;
        help|--help|-h) show_help ;;
        version|--version|-v) echo "mytool $VERSION" ;;
        *)       echo "Unknown command: $cmd" >&2; show_help; return 1 ;;
    esac
}

main "$@"
```

**Pola yang digunakan:**
1. **Dispatch pattern** — `main()` memeriksa `$1` dan memanggil fungsi yang sesuai
2. **Namespace fungsi** — `cmd_*` untuk command functions
3. **Error handling** — `:?` untuk error jika parameter kosong
4. **Help text** — Menggunakan `cat <<EOF` (heredoc)

### Integrasi dengan Editor

```bash
# ~/.config/zsh/conf.d/45-editor.zsh — Editor integration

# ═══════════════════════════════════════════════════════════
# EDITOR — Set default
# ═══════════════════════════════════════════════════════════
export EDITOR="${EDITOR:-nvim}"
export VISUAL="$EDITOR"

# ═══════════════════════════════════════════════════════════
# FUNGSI: v — Buka file di editor (dengan fzf jika tanpa argumen)
# ═══════════════════════════════════════════════════════════
v() {
    if [[ $# -eq 0 ]]; then
        local file
        file=$(fd --type f --hidden --exclude .git | fzf --preview 'bat --color=always {}')
        [[ -n "$file" ]] && $EDITOR "$file"
    else
        $EDITOR "$@"
    fi
}

# ═══════════════════════════════════════════════════════════
# FUNGSI: vg — Buka file di Git repo
# ═══════════════════════════════════════════════════════════
vg() {
    local file
    file=$(git ls-files | fzf --preview 'bat --color=always {}')
    [[ -n "$file" ]] && $EDITOR "$file"
}

# ═══════════════════════════════════════════════════════════
# FUNGSI: vs — Buka file dengan pencarian teks (ripgrep)
# ═══════════════════════════════════════════════════════════
vs() {
    local query="${1:-}"
    [[ -z "$query" ]] && read "query?Cari: "
    local file line
    result=$(rg --line-number --no-heading --color=always "$query" | \
        fzf --ansi --delimiter=':' \
            --preview 'bat --color=always --highlight-line {2} {1}' \
            --preview-window '+{2}-5')
    [[ -n "$result" ]] && {
        file=$(echo "$result" | cut -d: -f1)
        line=$(echo "$result" | cut -d: -f2)
        $EDITOR "+$line" "$file"
    }
}
```

### Terminologi Esensial

| Istilah | Definisi | Contoh |
|---|---|---|
| **FZF** | Fuzzy finder | `fzf --preview 'bat {}'` |
| **Ripgrep** | `grep` modern, cepat, respect .gitignore | `rg pattern` |
| **fd** | `find` modern, sintaks lebih intuitif | `fd -e py` |
| **bat** | `cat` modern dengan syntax highlighting | `bat file.py` |
| **Eza** | `ls` modern dengan ikon | `eza --icons` |
| **Zoxide** | `cd` pintar dengan frekuensi | `z project` |
| **Delta** | Diff viewer untuk Git | `git diff \| delta` |
| **Fuzzy search** | Pencarian yang cocok dengan substring tidak berurutan | "prj" cocok dengan "project" |

### Hubungan dengan Modul Lain

- **Modul 6.1 (Sub-bab 7):** Plugin manager untuk tools produktivitas
- **Modul 6.2 (Sub-bab 4):** Menulis plugin Zsh untuk tools kustom
- **Jalur A:** FZF digunakan untuk pemilihan AWS profile/context
- **Jalur B:** FZF digunakan untuk pemilihan file dalam pipeline data

### Sumber Referensi Lengkap

- **FZF GitHub** — https://github.com/junegunn/fzf
- **FZF Wiki: Examples** — https://github.com/junegunn/fzf/wiki/Examples
- **Ripgrep GitHub** — https://github.com/BurntSushi/ripgrep
- **fd GitHub** — https://github.com/sharkdp/fd
- **bat GitHub** — https://github.com/sharkdp/bat
- **Eza GitHub** — https://github.com/eza-community/eza
- **Zoxide GitHub** — https://github.com/ajeetdsouza/zoxide
- **Delta GitHub** — https://github.com/dandavison/delta
- **Modern Unix Tools** — https://github.com/ibraheemdev/modern-unix
- **Awesome Zsh Plugins** — https://github.com/unixorn/awesome-zsh-plugins

### Tips dan Praktik Terbaik

1. **FZF + fd + bat adalah trio legendaris.** Gunakan `fd` sebagai sumber, `fzf` untuk seleksi, `bat` untuk preview.
2. **Alias tidak selalu lebih baik.** Terlalu banyak alias bisa membingungkan. Gunakan alias hanya untuk perintah yang sering diketik.
3. **Gunakan `zi` (zoxide + fzf) untuk navigasi.** `zi` membuka FZF untuk memilih direktori berdasarkan frekuensi.
4. **Bind key yang intuitif.** `Ctrl+R` untuk history, `Ctrl+T` untuk file, `Alt+C` untuk cd.
5. **Test dengan file besar.** FZF + ripgrep harus tetap responsif bahkan di repositori besar.
6. **Konfigurasi `bat` theme.** `BAT_THEME='TwoDark'` untuk tampilan yang lebih nyaman.

### Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
|---|---|---|
| FZF tidak menemukan file | File tidak muncul | Cek `FZF_DEFAULT_COMMAND` |
| `bat` tidak ada di Ubuntu | Command not found | `sudo apt install bat`, symlink `batcat` ke `bat` |
| `fd` tidak ada di Ubuntu | Command not found | `sudo apt install fd-find`, symlink `fdfind` ke `fd` |
| Alias `cat='bat'` merusak pipe | `bat` error saat menerima stdin | Gunakan `bat --paging=never` atau `bat --style=plain` |
| FZF lambat di direktori besar | Lag saat mengetik | Gunakan `fd` bukan `find`, tambahkan `--exclude` |

---

## 5. PROYEK AKHIR SETIAP JALUR

### Proyek Akhir Jalur A — DevOps Pipeline

**Tujuan:** Membangun script deployment lengkap dengan Zsh yang mencakup build, test, push, deploy, dan rollback.

**Requirement:**
1. Script harus idempoten (bisa dijalankan berkali-kali dengan hasil sama)
2. Harus menggunakan strict mode (`set -euo pipefail`)
3. Harus memiliki trap untuk cleanup
4. Harus memvalidasi input environment (staging/production)
5. Harus memiliki konfirmasi untuk production
6. Harus menampilkan progress dan status
7. Harus memiliki fungsi rollback

**Rubrik:**

| Kriteria | Bobot | Deskripsi |
|---|---|---|
| Kebenaran fungsional | 30% | Script berjalan tanpa error |
| Error handling | 25% | Strict mode, trap, validasi input |
| Keamanan | 20% | Tidak ada hardcoded secrets, konfirmasi production |
| Keterbacaan | 15% | Komentar, nama fungsi jelas, struktur logis |
| Dokumentasi | 10% | README, help text |

### Proyek Akhir Jalur B — ETL Pipeline

**Tujuan:** Membangun pipeline ETL yang mengambil data dari API, mentransformasi dengan `jq` dan `awk`, dan menyimpan hasilnya.

**Requirement:**
1. Ambil data dari public API (contoh: https://jsonplaceholder.typicode.com/)
2. Transformasi: filter, agregasi, dan konversi format
3. Simpan output dalam format JSON dan CSV
4. Pipeline harus bisa dijadwalkan (cron-ready)
5. Harus ada logging

**Rubrik:**

| Kriteria | Bobot | Deskripsi |
|---|---|---|
| Kebenaran pipeline | 30% | Data ditransformasi dengan benar |
| Penggunaan tools | 25% | awk, sed, jq, atau mlr digunakan efektif |
| Error handling | 20% | Handle API failure, file not found |
| Scheduling | 15% | Bisa dijalankan via cron |
| Dokumentasi | 10% | README dengan contoh penggunaan |

### Proyek Akhir Jalur C — CLI Tool

**Tujuan:** Membangun CLI tool dengan Zsh yang memiliki subcommands, help, completion, dan integrasi FZF.

**Requirement:**
1. Minimal 3 subcommands
2. Help text untuk setiap subcommand
3. Completion function (opsional tapi nilai tambah)
4. Integrasi FZF untuk pemilihan interaktif
5. Instalasi sebagai plugin atau symlink ke `~/bin/`

**Rubrik:**

| Kriteria | Bobot | Deskripsi |
|---|---|---|
| Fungsionalitas | 30% | Semua subcommand berfungsi |
| UX | 25% | Help jelas, error message informatif |
| Integrasi FZF | 20% | FZF digunakan dengan baik |
| Completion | 15% | Zsh completion berfungsi |
| Dokumentasi | 10% | README, contoh penggunaan |

---

## 6. PERBANDINGAN JALUR

| Aspek | Jalur A (DevOps) | Jalur B (Data) | Jalur C (Tooling) |
|---|---|---|---|
| **Tools utama** | AWS CLI, Terraform, kubectl, Docker | awk, sed, jq, Python | fzf, ripgrep, fd, bat |
| **Fokus** | Automation, deployment | ETL, analisis data | Produktivitas, CLI tools |
| **Output** | Script deploy, pipeline CI/CD | Pipeline data, laporan | CLI tools, plugin |
| **Skill pendukung** | Cloud, container, IaC | Statistik, Python/R | UX, desain CLI |
| **Cocok untuk** | DevOps engineer, SRE | Data engineer, analis | Developer tools engineer |
| **Tingkat kesulitan** | Menengah–Sulit | Menengah | Menengah |
| **Permintaan pasar** | Sangat tinggi | Tinggi | Sedang–Tinggi |

### Pohon Keputusan: Memilih Jalur

```bash
Apakah Anda bekerja dengan infrastruktur/cloud?
├── YA → Jalur A (DevOps)
│   └── Fokus: AWS/GCP/Azure, Terraform, Kubernetes
│
└── TIDAK
    ├── Apakah Anda bekerja dengan data (ETL, analisis)?
    │   ├── YA → Jalur B (Data Engineering)
    │   │   └── Fokus: awk, sed, jq, Python, pipeline
    │   │
    │   └── TIDAK
    │       ├── Apakah Anda membangun tools untuk developer?
    │       │   ├── YA → Jalur C (Developer Tooling)
    │       │   │   └── Fokus: FZF, ripgrep, CLI tools
    │       │   │
    │       │   └── TIDAK → Anda bisa memilih berdasarkan minat
```

---

## 7. REFERENSI LINTAS JALUR

### Buku

| Judul | Penulis | Relevansi |
|---|---|---|
| **Zsh Shell Engineering** | Pearson Williams | Semua jalur — fondasi dan arsitektur |
| **Mastering Zsh Shell** | — | Semua jalur — workflow dan produktivitas |
| **The Linux Command Line** | William Shotts | Semua jalur — fondasi shell |
| **Unix Power Tools** | Jerry Peek, et al. | Jalur B — pipeline data |
| **DevOps Handbook** | Gene Kim, et al. | Jalur A — filosofi DevOps |

### Repositori GitHub

| Repositori | Relevansi |
|---|---|
| **awesome-zsh-plugins** | Semua jalur — daftar plugin |
| **modern-unix** | Jalur C — tools modern |
| **zsh-users/zsh** | Semua jalur — source code Zsh |
| **ohmyzsh/ohmyzsh** | Semua jalur — framework dan plugin |
| **unixorn/fzf-zsh-plugin** | Jalur C — FZF integration |

### Komunitas

| Komunitas | Platform | Relevansi |
|---|---|---|
| **r/zsh** | Reddit | Semua jalur |
| **Zsh Users Mailing List** | Mailing list | Semua jalur |
| **Stack Overflow (zsh tag)** | Stack Overflow | Semua jalur |
| **r/devops** | Reddit | Jalur A |
| **r/dataengineering** | Reddit | Jalur B |

---

## Ringkasan Modul 6.3

| Sub-bab | Topik | Estimasi Waktu |
|---|---|---|
| 1 | Pendahuluan & Filosofi | 1 jam |
| 2 | Jalur A — DevOps | 8-10 jam |
| 3 | Jalur B — Data Engineering | 8-10 jam |
| 4 | Jalur C — Developer Tooling | 8-10 jam |
| 5 | Proyek Akhir (pilih satu) | 10-15 jam |
| **Total** | | **~35-46 jam** |

---

## Verifikasi Pemahaman

Setelah menyelesaikan Modul 6.3, Anda harus dapat:

- [ ] Menjelaskan filosofi di balik tiga jalur spesialisasi
- [ ] Menulis fungsi deploy yang robust dengan strict mode dan error handling
- [ ] Membangun pipeline ETL dengan `awk`, `sed`, dan `jq`
- [ ] Mengintegrasikan FZF dengan Zsh untuk pencarian file dan history
- [ ] Membangun CLI tool sederhana dengan subcommands dan help
- [ ] Memilih jalur spesialisasi yang sesuai dengan karier Anda

---

## ✅ Selamat!
Materi Modul 6.3 telah selesai. Seluruhnya mencakup **Expert — Arsitektur, Kontribusi, dan Spesialisasi**.

**Ringkasan Fase 6:**
- **Modul 6.1:** Arsitektur Enterprise & Deployment — dotfiles, Stow, Ansible, keamanan, optimasi
- **Modul 6.2:** Kontribusi ke Zsh & Open Source — mailing list, patch, plugin, etika
- **Modul 6.3:** Spesialisasi — DevOps, Data Engineering, Developer Tooling

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

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

