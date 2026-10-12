# FASE 4: EKOSISTEM, PERFORMA, DAN KEAMANAN

**Level:** Menengah–Mahir | **Durasi:** 4–6 minggu | **Jam:** ~35–45 jam

---

## MODUL 4.1: Framework dan Plugin Manager

<details>
  <summary>📃 Daftar Isi</summary>

---

> **Daftar Isi Modul 4.1 (Mini-Daftar Isi):**

> 1.  [Prasyarat Fundamental: Memahami Cara Zsh Memuat Konfigurasi](#prasyarat-fundamental)
> 2.  [Oh My Zsh: Kelebihan dan Kekurangan](#oh-my-zsh-kelebihan-dan-kekurangan)
> 3.  [Antidote: Plugin Manager Ringan dan Modern](#antidote)
> 4.  [Zinit: Fleksibilitas dan Performa dengan Turbo Mode](#zinit)
> 5.  [Plugin Esensial: Autosuggestions dan Syntax Highlighting](#plugin-esensial)
> 6.  [Manajemen Plugin Tanpa Framework (Manual Sourcing)](#manajemen-manual)
> 7.  [Mengukur dan Mengoptimalkan Waktu Startup](#mengukur-startup)
> 8.  [Terminologi Esensial Modul 4.1](#terminologi-4-1)
> 9.  [Rekomendasi Visualisasi](#visualisasi-4-1)
> 10. [Hubungan dengan Modul Lain](#hubungan-modul)
> 11. [Sumber Referensi Lengkap](#referensi-4-1)
> 12. [Tips dan Praktik Terbaik](#tips-4-1)
> 13. [Potensi Kesalahan Umum dan Solusi](#kesalahan-4-1)

</details>

---

### Prasyarat Fundamental: Memahami Cara Zsh Memuat Konfigurasi

Sebelum membahas plugin manager, kita **wajib** memahami fondasi bagaimana Zsh bekerja saat startup. Tanpa ini, kita hanya akan menghafal sintaks tanpa memahami esensinya.

#### Deskripsi Konkret & Peran dalam Kurikulum

Bagian ini menjelaskan **bagaimana Zsh memuat file-file konfigurasinya saat pertama kali dijalankan**. Ini adalah fondasi mutlak untuk memahami mengapa plugin manager ada, apa masalah yang mereka selesaikan, dan bagaimana mereka bekerja di balik layar.

#### Konsep Kunci & Filosofi Mendalam

Bayangkan Zsh sebagai sebuah **rumah**. Saat Anda "masuk" (membuka terminal), Zsh menjalankan serangkaian "protokol penyambutan" — file-file yang berisi instruksi tentang bagaimana rumah itu harus ditata. Ada yang dijalankan sebelum pintu terbuka (`zshenv`), ada yang dijalankan saat Anda masuk sebagai pengguna interaktif (`zshrc`), dan ada yang dijalankan setelah semuanya siap (`zlogin`).

**Filosofi modularisasi:** Semakin banyak yang Anda masukkan ke dalam "protokol penyambutan", semakin lama pintu terbuka. Plugin manager adalah **manajer logistik** yang memastikan hanya barang-barang yang benar-benar dibutuhkan yang dibawa masuk, dan membawanya dengan cara yang paling efisien.

#### Sintaks Dasar / Contoh Implementasi Inti

**Urutan Pemuatan File Startup Zsh (dari yang paling awal):**

```bash
# 1. /etc/zshenv       — System-wide, SELALU dijalankan (semua mode)
# 2. ~/.zshenv         — User-specific, SELALU dijalankan (semua mode)
# 3. /etc/zprofile     — System-wide, hanya login shell
# 4. ~/.zprofile       — User-specific, hanya login shell
# 5. /etc/zshrc        — System-wide, hanya interactive shell
# 6. ~/.zshrc          — User-specific, hanya interactive shell ← INI TEMPAT KONFIGURASI UTAMA
# 7. /etc/zlogin       — System-wide, hanya login shell
# 8. ~/.zlogin         — User-specific, hanya login shell
# 9. ~/.zlogout        — Saat logout
```

**Penjelasan kata demi kata untuk sintaks di atas:**
- `/etc/zshenv`: File di direktori `/etc` (system-wide) yang dijalankan untuk **setiap** invasi Zsh, termasuk script non-interaktif. Digunakan untuk mengatur `$PATH` dan variabel environment fundamental.
- `~/.zshenv`: File di direktori home pengguna (`~` adalah shorthand untuk `/home/username`). Sama seperti `/etc/zshenv`, tapi khusus untuk pengguna.
- `/etc/zshrc`: File system-wide yang hanya dijalankan untuk **interactive shell** (shell yang menerima input dari keyboard). Di sinilah konfigurasi seperti prompt, alias, dan plugin biasanya diletakkan.
- `~/.zshrc`: File user-specific untuk interactive shell. **Inilah file utama yang akan kita modifikasi** untuk mengonfigurasi plugin manager.

**Konsep `$fpath` dan `autoload`:**

```bash
# $fpath adalah array direktori tempat Zsh mencari fungsi autoload
echo $fpath
# Output contoh: /usr/share/zsh/functions /usr/local/share/zsh/functions

# Menambahkan direktori ke $fpath
fpath=(~/.zsh/functions $fpath)

# Autoload: Mendaftarkan fungsi agar bisa dipanggil tanpa source
autoload -Uz vcs_info    # -U: abaikan alias, -z: gunakan gaya Zsh
vcs_info                 # Sekarang fungsi ini bisa dipanggil
```

**Penjelasan kata demi kata:**
- `fpath`: Array khusus di Zsh yang berisi daftar direktori tempat Zsh mencari file fungsi. Setiap file di direktori ini dapat di-`autoload` tanpa harus di-`source` secara eksplisit.
- `autoload`: Perintah Zsh untuk "mendaftarkan" sebuah fungsi. Fungsi tidak dimuat ke memori sampai dipanggil pertama kali. Ini adalah **lazy loading** native Zsh.
- `-U`: Opsi untuk mengabaikan alias saat menjalankan fungsi.
- `-z`: Opsi untuk memaksa Zsh menggunakan gaya pemanggilan Zsh (bukan Ksh/Bash).

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **Login Shell** | Shell yang dijalankan saat pengguna login (misalnya, melalui SSH atau console login). Ditandai dengan tanda `-` di depan nama shell (`-zsh`). |
| **Interactive Shell** | Shell yang menerima input dari keyboard secara langsung. Terminal emulator biasanya menjalankan interactive shell. |
| **Non-Interactive Shell** | Shell yang dijalankan untuk mengeksekusi script, tanpa input keyboard. |
| **`source`** | Perintah untuk mengeksekusi file dalam konteks shell saat ini (bukan sub-shell). Sama dengan `.` (titik). |
| **`$fpath`** | Array Zsh yang berisi direktori tempat fungsi autoload dicari. |
| **`autoload`** | Mekanisme Zsh untuk memuat fungsi secara malas (saat dipanggil, bukan saat startup). |

#### Visualisasi yang Direkomendasikan

> **Diagram alur startup Zsh** akan sangat membantu di sini. Diagram ini harus menunjukkan urutan file yang dijalankan: `/etc/zshenv` → `~/.zshenv` → `/etc/zshrc` → `~/.zshrc` → `~/.zlogin`, dengan penanda mana yang dijalankan untuk login shell vs interactive shell vs non-interactive shell.

#### Sumber Referensi

- Zsh Startup Files: https://zsh.sourceforge.io/Doc/Release/Files.html
- Zsh `fpath` dan `autoload`: https://zsh.sourceforge.io/Doc/Release/Functions.html

---

### Oh My Zsh: Kelebihan dan Kekurangan

#### Deskripsi Konkret & Peran dalam Kurikulum

Oh My Zsh adalah **framework komunitas** untuk mengelola konfigurasi Zsh. Ia menyediakan 300+ plugin bawaan dan 140+ tema, serta sistem auto-update. Modul ini membahas cara menginstal, mengonfigurasi, dan mengevaluasi trade-off penggunaan Oh My Zsh.

#### Konsep Kunci & Filosofi Mendalam

Oh My Zsh menganut filosofi **"batteries included"** — semua yang Anda butuhkan sudah tersedia. Anda cukup menambahkan nama plugin ke dalam array `plugins`, dan Oh My Zsh akan menanganinya. Namun, filosofi ini memiliki konsekuensi: **setiap plugin yang Anda aktifkan dimuat saat startup**, yang berarti semakin banyak plugin, semakin lambat shell Anda.

**Trade-off utama:**
- ✅ **Kemudahan:** Instalasi satu baris, konfigurasi sederhana
- ✅ **Ekosistem:** 300+ plugin siap pakai, 140+ tema
- ✅ **Komunitas:** 2,200+ kontributor, update rutin
- ❌ **Performa:** Startup time ~800ms dengan banyak plugin
- ❌ **Monolitik:** Semua plugin dimuat di awal, tidak ada lazy loading native
- ❌ **Kurang fleksibel:** Sulit mengontrol plugin mana yang dimuat kapan

#### Sintaks Dasar / Contoh Implementasi Inti

**Instalasi Oh My Zsh:**

```bash
# Install via curl (memerlukan curl)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install via wget
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

**Penjelasan kata demi kata:**
- `sh -c`: Menjalankan perintah string sebagai script shell.
- `$(curl -fsSL ...)`: Command substitution — menjalankan `curl` dan mengambil outputnya sebagai string.
- `curl`: Tool untuk transfer data dari/ke URL.
  - `-f`: Fail silently (jangan tampilkan output HTTP error).
  - `-s`: Silent mode (jangan tampilkan progress bar).
  - `-S`: Tampilkan error jika ada (digunakan bersama `-s`).
  - `-L`: Follow redirects (ikuti pengalihan HTTP).

**Konfigurasi `.zshrc` untuk Oh My Zsh:**

```bash
# Path instalasi Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Tema yang digunakan
ZSH_THEME="robbyrussell"

# Daftar plugin yang diaktifkan (dipisahkan spasi, BUKAN koma)
plugins=(
    git                      # Aliases dan fungsi untuk Git
    zsh-autosuggestions      # Saran perintah berdasarkan history
    zsh-syntax-highlighting  # Pewarnaan sintaks saat mengetik
    docker                   # Completion dan aliases untuk Docker
    kubectl                  # Completion untuk kubectl
    history-substring-search # Pencarian history dengan substring
)

# Memuat Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Pengaturan tambahan
export LANG=en_US.UTF-8
export EDITOR='nvim'
```

**Penjelasan kata demi kata:**
- `export ZSH="$HOME/.oh-my-zsh"`: Menyimpan path instalasi Oh My Zsh ke variabel environment `ZSH`. `$HOME` adalah variabel yang berisi path direktori home pengguna.
- `ZSH_THEME="robbyrussell"`: Menentukan tema yang digunakan. `robbyrussell` adalah tema default yang ringan dan informatif.
- `plugins=(...)`: Array Zsh yang berisi nama-nama plugin. **Penting:** Elemen array Zsh dipisahkan oleh **spasi**, bukan koma. Menulis `plugins=(git, docker)` akan dianggap sebagai satu plugin bernama `git,` (dengan koma).
- `source $ZSH/oh-my-zsh.sh`: Mengeksekusi file `oh-my-zsh.sh` dalam konteks shell saat ini. File ini bertanggung jawab memuat semua plugin yang terdaftar di array `plugins`.

**Contoh plugin bawaan Oh My Zsh — `git`:**

```bash
# Setelah mengaktifkan plugin 'git', Anda bisa menggunakan aliases ini:
gst        # git status
ga         # git add
gcmsg      # git commit -m
gp         # git push
gl         # git pull
gco        # git checkout
```

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **Oh My Zsh** | Framework komunitas untuk konfigurasi Zsh, menyediakan plugin dan tema. |
| **`ZSH_THEME`** | Variabel yang menentukan tema prompt Oh My Zsh. |
| **`plugins`** | Array Zsh yang berisi nama plugin yang akan diaktifkan. |
| **`$ZSH_CUSTOM`** | Direktori untuk plugin dan tema kustom. Default: `~/.oh-my-zsh/custom`. |
| **Auto-update** | Fitur Oh My Zsh yang secara otomatis memperbarui framework dan plugin. |

#### Rekomendasi Visualisasi

> **Diagram batang perbandingan waktu startup** akan sangat membantu: Vanilla Zsh (~50ms), Oh My Zsh dengan 5 plugin (~800ms), Oh My Zsh dengan 20 plugin (~1.5s), dan setup yang dioptimalkan (~100–200ms).

#### Hubungan dengan Modul Lain

- **Prasyarat untuk Modul 4.2:** Tema Oh My Zsh (`ZSH_THEME`) akan dibahas lebih lanjut dalam konteks kustomisasi prompt.
- **Terkait Modul 4.3:** Performa Oh My Zsh menjadi studi kasus utama untuk optimasi startup.

#### Sumber Referensi

- Oh My Zsh Wiki — Plugins: https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
- Oh My Zsh GitHub: https://github.com/ohmyzsh/ohmyzsh
- Awesome Zsh Plugins: https://github.com/unixorn/awesome-zsh-plugins

#### Tips dan Praktik Terbaik

1. **Aktifkan hanya plugin yang benar-benar digunakan.** Setiap plugin menambah waktu startup.
2. **Urutan plugin penting.** `zsh-syntax-highlighting` harus berada di **posisi terakhir** dalam array `plugins` karena ia perlu "melihat" semua plugin lain terlebih dahulu.
3. **Gunakan `ZSH_CUSTOM` untuk plugin kustom** agar tidak tercampur dengan plugin bawaan.
4. **Nonaktifkan auto-update jika Anda menginginkan startup yang lebih cepat** — auto-update melakukan pengecekan setiap kali shell dibuka.

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Menggunakan koma dalam array `plugins` | Gunakan spasi: `plugins=(git docker)` bukan `plugins=(git, docker)` |
| `zsh-syntax-highlighting` tidak berfungsi | Pastikan ia berada di **urutan terakhir** array `plugins` |
| Shell menjadi lambat setelah menambah banyak plugin | Gunakan `zprof` untuk profiling, atau beralih ke plugin manager yang lebih ringan |
| Konflik antara Oh My Zsh dan konfigurasi manual | Jangan `source` plugin secara manual jika sudah ada di array `plugins` |

---

### Antidote: Plugin Manager Ringan dan Modern

#### Deskripsi Konkret & Peran dalam Kurikulum

Antidote adalah plugin manager Zsh yang **dibangun dari awal dengan fokus pada performa**. Ia menggunakan pendekatan **static plugin file** — file yang di-generate sekali dan dimuat dengan sangat cepat. Antidote adalah penerus Antibody, yang pada gilirannya merupakan penerus Antigen.

#### Konsep Kunci & Filosofi Mendalam

Antidote menganut filosofi **"generate once, load many"** . Bayangkan Anda memiliki daftar belanja (file `.zsh_plugins.txt`). Daripada pergi ke toko setiap kali Anda ingin memasak (setiap startup shell), Antidote **meng-generate file statis** (`.zsh_plugins.zsh`) yang berisi semua yang Anda butuhkan. Saat startup, Zsh hanya perlu memuat file statis ini — jauh lebih cepat daripada mencari dan memuat plugin satu per satu.

**Mengapa ini cepat?**
1. **Konkurensi:** Antidote dapat meng-clone plugin secara paralel.
2. **Static file:** File `.zsh_plugins.zsh` di-generate sekali dan dimuat langsung.
3. **Native Zsh:** Ditulis dalam Zsh, bukan Go (seperti Antibody) atau Ruby (seperti Antigen).

#### Sintaks Dasar / Contoh Implementasi Inti

**Instalasi Antidote:**

```bash
# Clone repository Antidote
git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
```

**Penjelasan kata demi kata:**
- `git clone`: Perintah Git untuk menyalin repository.
- `--depth=1`: Shallow clone — hanya mengambil commit terakhir. Jauh lebih cepat dan hemat bandwidth.
- `${ZDOTDIR:-~}`: Parameter expansion. Jika `$ZDOTDIR` diset, gunakan nilainya; jika tidak, gunakan `~` (home directory). `ZDOTDIR` adalah variabel khusus Zsh yang menentukan di mana file konfigurasi Zsh disimpan.
- `~/.antidote`: Direktori tujuan clone.

**Konfigurasi `.zshrc` untuk Antidote:**

```bash
# 1. Source antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# 2. Inisialisasi plugin dari file statis
antidote load

# 3. (Opsional) Jika ingin menggunakan file kustom
# antidote load /path/to/custom_plugins.txt
```

**Penjelasan kata demi kata:**
- `source .../antidote.zsh`: Memuat fungsi-fungsi Antidote ke dalam shell saat ini.
- `antidote load`: Perintah Antidote untuk:
  1. Membaca file `~/.zsh_plugins.txt`.
  2. Meng-clone plugin yang belum ada (jika perlu).
  3. Meng-generate `~/.zsh_plugins.zsh` (file statis).
  4. Memuat file statis tersebut.

**File `~/.zsh_plugins.txt` (daftar plugin):**

```bash
# Format: satu plugin per baris
# Komentar diawali dengan #

# Plugin dari GitHub
zsh-users/zsh-autosuggestions
zsh-users/zsh-syntax-highlighting

# Plugin dari Oh My Zsh (menggunakan prefix)
ohmyzsh/ohmyzsh path:plugins/git
ohmyzsh/ohmyzsh path:plugins/docker

# Plugin dengan nama kustom
romkatv/powerlevel10k

# Plugin lokal
~/.zsh/plugins/my-custom-plugin
```

**Penjelasan kata demi kata:**
- `zsh-users/zsh-autosuggestions`: Format `username/repository` — Antidote akan meng-clone dari GitHub.
- `path:plugins/git`: Modifier `path:` menentukan sub-direktori dalam repository yang berisi plugin. Digunakan untuk mengambil plugin dari framework seperti Oh My Zsh.
- `~/.zsh/plugins/my-custom-plugin`: Path lokal — Antidote akan meng-`source` file dari direktori ini.

**Optimasi tingkat lanjut (manual static loading):**

```bash
# .zshrc
# Set nama file plugin
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins

# Source antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# Generate file statis jika belum ada atau jika .txt lebih baru
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
    antidote bundle < ${zsh_plugins}.txt > ${zsh_plugins}.zsh
fi

# Muat file statis (jauh lebih cepat)
source ${zsh_plugins}.zsh
```

**Penjelasan kata demi kata:**
- `zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins`: Variabel untuk path dasar file plugin.
- `[[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]`: Kondisional Zsh. `!` berarti negasi. `-nt` berarti "newer than" (lebih baru dari). Jadi, kondisi ini bernilai true jika file `.zsh` **tidak** lebih baru dari file `.txt` — artinya perlu di-generate ulang.
- `antidote bundle < ${zsh_plugins}.txt > ${zsh_plugins}.zsh`: `antidote bundle` membaca dari stdin (`<`) dan menulis ke stdout (`>`). Ini meng-generate file statis.
- `source ${zsh_plugins}.zsh`: Memuat file statis yang sudah di-generate.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **Antidote** | Plugin manager Zsh yang fokus pada performa, penerus Antibody. |
| **Static Plugin File** | File `.zsh` yang di-generate dari daftar plugin, dimuat langsung saat startup. |
| **`antidote load`** | Perintah untuk memuat semua plugin dari file `.zsh_plugins.txt`. |
| **`antidote bundle`** | Perintah untuk meng-generate file statis dari daftar plugin. |
| **`.zsh_plugins.txt`** | File teks berisi daftar plugin (satu per baris). |
| **`.zsh_plugins.zsh`** | File statis yang di-generate, berisi kode untuk memuat plugin. |
| **`ZDOTDIR`** | Variabel Zsh yang menentukan direktori konfigurasi Zsh. |

#### Rekomendasi Visualisasi

> **Diagram alur kerja Antidote** akan sangat membantu: `.zsh_plugins.txt` → `antidote bundle` → `.zsh_plugins.zsh` (file statis) → `source` saat startup. Bandingkan dengan Oh My Zsh yang langsung memuat setiap plugin.

#### Hubungan dengan Modul Lain

- **Alternatif untuk Modul 4.1 (Oh My Zsh):** Antidote dapat digunakan sebagai pengganti Oh My Zsh, atau bersamaan untuk memuat plugin Oh My Zsh.
- **Terkait Modul 4.3:** Static file adalah salah satu teknik optimasi startup yang akan dibahas lebih lanjut.

#### Sumber Referensi

- Antidote Official Site: https://getantidote.github.io/
- Antidote GitHub: https://github.com/mattmc3/antidote
- Antidote Manual (Debian): https://manpages.debian.org/testing/zsh-antidote/antidote.1.en.html

#### Tips dan Praktik Terbaik

1. **Gunakan `antidote bundle` untuk generate file statis** — jangan biarkan `antidote load` meng-generate setiap startup.
2. **Commit file `.zsh_plugins.zsh` ke dotfiles Anda** — ini memungkinkan startup yang cepat tanpa perlu generate ulang di setiap mesin.
3. **Gunakan `path:` modifier untuk mengambil plugin dari framework** seperti Oh My Zsh.
4. **Jalankan `antidote bundle` setiap kali mengubah `.zsh_plugins.txt`** untuk memperbarui file statis.

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Lupa menjalankan `antidote bundle` setelah mengubah daftar plugin | Tambahkan logika kondisional di `.zshrc` untuk auto-generate jika `.txt` lebih baru |
| File statis tidak di-generate karena error | Jalankan `antidote bundle < .zsh_plugins.txt > .zsh_plugins.zsh` secara manual untuk melihat error |
| Plugin tidak ditemukan | Periksa format `username/repository` dan pastikan repository ada di GitHub |

---

### Zinit: Fleksibilitas dan Performa dengan Turbo Mode

#### Deskripsi Konkret & Peran dalam Kurikulum

Zinit adalah plugin manager Zsh yang **sangat fleksibel** dan **cepat**, dengan fitur unik bernama **Turbo Mode** yang memungkinkan pemuatan plugin secara **asinkron** setelah prompt pertama muncul. Zinit juga mendukung **unloading** plugin, pelaporan detail tentang apa yang di-setup oleh plugin, dan kompatibilitas dengan plugin Oh My Zsh dan Prezto.

#### Konsep Kunci & Filosofi Mendalam

Zinit menganut filosofi **"kontrol penuh"** . Daripada memuat semua plugin di awal (blocking), Zinit memungkinkan Anda menentukan **kapan** setiap plugin dimuat:
- **Langsung (blocking):** Plugin dimuat sebelum prompt muncul.
- **Turbo (asynchronous):** Plugin dimuat setelah prompt muncul, di background.
- **Lazy:** Plugin dimuat saat pertama kali dibutuhkan (misalnya, saat Anda menjalankan perintah `docker`).

**Analogi:** Bayangkan Anda sedang bersiap-siap pergi. Oh My Zsh adalah seperti memakai semua pakaian, sepatu, dan aksesori **sebelum** membuka pintu. Zinit Turbo adalah seperti membuka pintu dulu (prompt muncul), **lalu** memakai sepatu sambil berjalan. Anda bisa mulai bergerak lebih cepat.

#### Sintaks Dasar / Contoh Implementasi Inti

**Instalasi Zinit:**

```bash
# Metode 1: Clone manual
git clone --depth=1 https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin

# Metode 2: Automatic installer
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
```

**Konfigurasi `.zshrc` untuk Zinit:**

```bash
# Source Zinit
source ~/.zinit/bin/zinit.zsh

# Memuat plugin dengan mode Turbo (asynchronous)
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

# Memuat plugin Oh My Zsh
zinit ice wait lucid
zinit snippet OMZ::plugins/git/git.plugin.zsh

# Memuat plugin dengan mode "load" (blocking)
zinit load romkatv/powerlevel10k

# Memuat plugin dengan mode "light" (blocking, lebih ringan)
zinit light zsh-users/zsh-completions
```

**Penjelasan kata demi kata:**
- `source ~/.zinit/bin/zinit.zsh`: Memuat Zinit ke dalam shell.
- `zinit ice wait lucid`: `ice` adalah "modifier" yang mengatur bagaimana plugin berikutnya dimuat.
  - `wait`: Mode Turbo — tunggu hingga prompt pertama muncul sebelum memuat plugin.
  - `lucid`: Aktifkan `lucid` mode — tampilkan pesan yang lebih bersih (tidak verbose).
- `zinit light zsh-users/zsh-autosuggestions`: `light` adalah cara ringan untuk memuat plugin. Tidak ada pelaporan detail.
- `zinit load`: Cara memuat plugin dengan **pelaporan lengkap** (aliases, functions, bindkeys, dll. yang di-setup).
- `zinit snippet OMZ::plugins/git/git.plugin.zsh`: `snippet` memuat file tertentu dari repository. `OMZ::` adalah prefix untuk Oh My Zsh.

**Mode Turbo lebih detail:**

```bash
# Turbo dengan threshold waktu (ms)
zinit ice wait"0" lucid    # Muat segera setelah prompt muncul
zinit ice wait"1" lucid    # Muat setelah 1 detik
zinit ice wait"2" lucid    # Muat setelah 2 detik

# Turbo dengan kondisi
zinit ice wait lucid atload'echo "Plugin dimuat!"'
zinit light zsh-users/zsh-autosuggestions
```

**Penjelasan kata demi kata:**
- `wait"0"`: Mode Turbo dengan delay 0 detik (muat segera setelah prompt).
- `atload'...'`: Perintah yang dijalankan **setelah** plugin dimuat.

**Zinit commands (manajemen plugin):**

```bash
# Melihat daftar plugin yang dimuat
zinit list

# Unload plugin
zinit unload zsh-users/zsh-autosuggestions

# Update semua plugin
zinit update --all

# Melihat report dari plugin
zinit report zsh-users/zsh-autosuggestions
```

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **Zinit** | Plugin manager Zsh fleksibel dengan Turbo Mode. |
| **Turbo Mode** | Mode pemuatan asinkron — plugin dimuat setelah prompt muncul. |
| **`zinit ice`** | Modifier yang mengatur bagaimana plugin berikutnya dimuat. |
| **`zinit light`** | Memuat plugin dengan cara ringan (tanpa report). |
| **`zinit load`** | Memuat plugin dengan report lengkap. |
| **`zinit snippet`** | Memuat file tertentu dari repository. |
| **`OMZ::`** | Prefix untuk mengambil plugin dari Oh My Zsh. |
| **`atload`** | Perintah yang dijalankan setelah plugin dimuat. |

#### Rekomendasi Visualisasi

> **Diagram alur Turbo Mode** akan sangat membantu: Timeline yang menunjukkan (1) Zsh mulai, (2) Prompt muncul, (3) Di background, plugin dimuat secara asinkron. Bandingkan dengan Oh My Zsh di mana prompt **baru muncul setelah semua plugin dimuat**.

#### Hubungan dengan Modul Lain

- **Alternatif untuk Modul 4.1 (Oh My Zsh):** Zinit dapat memuat plugin Oh My Zsh, sehingga bisa digunakan sebagai pengganti yang lebih cepat.
- **Terkait Modul 4.3:** Turbo Mode adalah teknik optimasi startup yang sangat efektif.

#### Sumber Referensi

- Zinit GitHub: https://github.com/zdharma-continuum/zinit
- Zinit Wiki: https://github.com/zdharma-continuum/zinit/wiki
- Zinit Speed Comparison: https://github.com/zdharma-continuum/zinit#speed-comparison

#### Tips dan Praktik Terbaik

1. **Gunakan Turbo Mode untuk plugin yang tidak dibutuhkan segera** (misalnya, autosuggestions, syntax highlighting).
2. **Jangan gunakan Turbo Mode untuk plugin yang mengubah prompt** — prompt perlu dimuat sebelum prompt muncul.
3. **Gunakan `zinit report` untuk memahami apa yang di-setup oleh plugin** — ini sangat membantu untuk debugging.
4. **Kombinasikan `wait` dengan `atload` untuk menjalankan perintah setelah plugin dimuat.**

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Prompt tidak muncul karena plugin Turbo | Pastikan plugin yang mengubah prompt dimuat dengan `load` (blocking), bukan `wait` |
| Plugin tidak berfungsi setelah dimuat dengan Turbo | Periksa apakah plugin memerlukan inisialisasi immediate; jika ya, gunakan `load` |
| Konflik antara `zinit light` dan `zinit load` | Gunakan `light` untuk plugin sederhana, `load` untuk plugin yang memerlukan report |

---

### Plugin Esensial: Autosuggestions dan Syntax Highlighting

#### Deskripsi Konkret & Peran dalam Kurikulum

Dua plugin ini adalah **plugin yang paling sering direkomendasikan** untuk Zsh. Mereka meningkatkan produktivitas secara signifikan dengan memberikan saran perintah (autosuggestions) dan pewarnaan sintaks (syntax highlighting).

#### Konsep Kunci & Filosofi Mendalam

- **zsh-autosuggestions** bekerja seperti **"autocomplete berdasarkan history"** . Saat Anda mengetik, plugin ini menampilkan saran (dalam warna abu-abu) berdasarkan perintah yang pernah Anda jalankan sebelumnya. Tekan `→` (panah kanan) atau `Ctrl+E` untuk menerima saran.
- **zsh-syntax-highlighting** bekerja seperti **"pemeriksa ejaan untuk shell"** . Saat Anda mengetik, perintah yang valid ditampilkan hijau, yang tidak valid merah. Ini membantu Anda mendeteksi kesalahan **sebelum** menekan Enter.

#### Sintaks Dasar / Contoh Implementasi Inti

**Instalasi manual (tanpa plugin manager):**

```bash
# Clone plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting

# Source di .zshrc (urutan penting!)
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

**Penjelasan kata demi kata:**
- `git clone https://github.com/...`: Meng-clone repository plugin.
- `source .../zsh-autosuggestions.zsh`: Memuat plugin autosuggestions.
- `source .../zsh-syntax-highlighting.zsh`: Memuat plugin syntax highlighting. **Harus setelah autosuggestions** dan setelah semua plugin lain.

**Instalasi dengan Oh My Zsh:**

```bash
# Clone ke direktori custom Oh My Zsh
git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Tambahkan ke array plugins di .zshrc
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting  # HARUS TERAKHIR
)
```

**Penjelasan kata demi kata:**
- `${ZSH_CUSTOM:-~/.oh-my-zsh/custom}`: Gunakan `$ZSH_CUSTOM` jika diset, jika tidak gunakan `~/.oh-my-zsh/custom`.
- `zsh-syntax-highlighting` **harus berada di posisi terakhir** dalam array `plugins` karena ia perlu memproses semua plugin lain terlebih dahulu.

**Konfigurasi zsh-autosuggestions:**

```bash
# Mengubah warna saran (default: abu-abu)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'  # Warna 8 = abu-abu gelap

# Mengubah strategi saran
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# - history: berdasarkan perintah yang pernah dijalankan
# - completion: berdasarkan completion yang tersedia
# - match_prev_cmd: berdasarkan perintah sebelumnya

# Menonaktifkan saran untuk perintah tertentu
ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *"
```

**Penjelasan kata demi kata:**
- `ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE`: Variabel untuk mengatur warna teks saran. `fg=8` berarti foreground color nomor 8 (biasanya abu-abu).
- `ZSH_AUTOSUGGEST_STRATEGY`: Array strategi yang digunakan untuk menghasilkan saran.
- `ZSH_AUTOSUGGEST_HISTORY_IGNORE`: Pattern perintah yang tidak akan disarankan.

**Konfigurasi zsh-syntax-highlighting:**

```bash
# Mengubah warna perintah yang valid
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'

# Mengubah warna path
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'

# Mengubah warna alias
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'

# Menonaktifkan highlighting untuk globbing
ZSH_HIGHLIGHT_STYLES[globbing]='none'
```

**Penjelasan kata demi kata:**
- `ZSH_HIGHLIGHT_STYLES`: Array asosiatif yang memetakan tipe token ke style. Style ditulis dalam format `fg=warna,bold`.
- `command`: Token untuk perintah yang valid.
- `path`: Token untuk path file/direktori.
- `alias`: Token untuk alias.
- `globbing`: Token untuk ekspresi glob (misalnya, `*.txt`).

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **zsh-autosuggestions** | Plugin yang menyarankan perintah berdasarkan history. |
| **zsh-syntax-highlighting** | Plugin yang mewarnai sintaks saat mengetik. |
| **`ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE`** | Variabel untuk mengatur warna saran. |
| **`ZSH_HIGHLIGHT_STYLES`** | Array asosiatif untuk mengatur warna token. |
| **`ZSH_AUTOSUGGEST_STRATEGY`** | Array strategi untuk menghasilkan saran. |

#### Rekomendasi Visualisasi

> **Tangkapan layar** yang menunjukkan autosuggestions (teks abu-abu) dan syntax highlighting (perintah hijau, path biru, error merah) akan sangat membantu.

#### Sumber Referensi

- zsh-autosuggestions GitHub: https://github.com/zsh-users/zsh-autosuggestions
- zsh-syntax-highlighting GitHub: https://github.com/zsh-users/zsh-syntax-highlighting
- zsh-syntax-highlighting README (styles): https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md

#### Tips dan Praktik Terbaik

1. **Urutan source penting:** `zsh-autosuggestions` dulu, `zsh-syntax-highlighting` terakhir.
2. **Sesuaikan warna dengan tema terminal Anda** untuk memastikan kontras yang baik.
3. **Gunakan `ZSH_AUTOSUGGEST_HISTORY_IGNORE` untuk mengecualikan perintah sensitif** (misalnya, perintah yang mengandung password).
4. **Untuk performa, gunakan `fast-syntax-highlighting`** (alternatif yang lebih cepat).

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Syntax highlighting tidak berfungsi | Pastikan ia di-source **terakhir** setelah semua plugin lain |
| Autosuggestions tidak muncul | Periksa apakah `zsh-autosuggestions` sudah di-source dengan benar |
| Warna tidak terlihat | Sesuaikan `ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE` dengan warna latar terminal |
| Konflik dengan plugin lain | Pastikan tidak ada plugin lain yang memodifikasi `ZLE` secara konflik |

---

### Manajemen Plugin Tanpa Framework (Manual Sourcing)

#### Deskripsi Konkret & Peran dalam Kurikulum

Tidak semua orang membutuhkan plugin manager. **Manual sourcing** adalah pendekatan paling minimalis: Anda meng-clone plugin sendiri dan memuatnya langsung di `.zshrc`. Ini memberikan **kontrol penuh** dan **startup tercepat**, tetapi memerlukan manajemen manual.

#### Konsep Kunci & Filosofi Mendalam

Filosofi di balik manual sourcing adalah **"Anda tahu apa yang Anda muat, dan Anda memuatnya dengan cara Anda sendiri"** . Tidak ada abstraksi, tidak ada "magic". Setiap plugin adalah file yang Anda `source` secara eksplisit.

**Trade-off:**
- ✅ **Performa terbaik:** Tidak ada overhead dari plugin manager.
- ✅ **Kontrol penuh:** Anda tahu persis apa yang dimuat dan kapan.
- ✅ **Transparansi:** Mudah di-debug karena tidak ada lapisan abstraksi.
- ❌ **Manajemen manual:** Anda harus meng-clone dan meng-update plugin sendiri.
- ❌ **Tidak ada dependency resolution:** Anda harus mengelola urutan source sendiri.
- ❌ **Repetitif:** Setiap plugin memerlukan baris `source` sendiri.

#### Sintaks Dasar / Contoh Implementasi Inti

**Struktur direktori:**

```bash
~/.zsh/
├── plugins/
│   ├── zsh-autosuggestions/
│   │   └── zsh-autosuggestions.zsh
│   ├── zsh-syntax-highlighting/
│   │   └── zsh-syntax-highlighting.zsh
│   └── zsh-completions/
│       └── zsh-completions.zsh
└── .zshrc
```

**Konfigurasi `.zshrc` manual:**

```bash
# Set ZDOTDIR (opsional, tapi direkomendasikan)
export ZDOTDIR="$HOME/.zsh"

# Fungsi helper untuk source plugin
source_plugin() {
    local plugin_path="$1"
    if [[ -f "$plugin_path" ]]; then
        source "$plugin_path"
    else
        echo "Plugin tidak ditemukan: $plugin_path" >&2
    fi
}

# Source plugin satu per satu (urutan penting!)
source_plugin "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source_plugin "$ZDOTDIR/plugins/zsh-completions/zsh-completions.zsh"
source_plugin "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Konfigurasi setelah plugin
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
```

**Penjelasan kata demi kata:**
- `export ZDOTDIR="$HOME/.zsh"`: Mengatur `ZDOTDIR` — variabel yang memberi tahu Zsh di mana mencari file konfigurasi.
- `source_plugin()`: Fungsi helper untuk memeriksa keberadaan file sebelum `source`.
- `local plugin_path="$1"`: Deklarasi variabel lokal dengan parameter pertama fungsi.
- `[[ -f "$plugin_path" ]]`: Test apakah file ada dan merupakan file regular.
- `>&2`: Redirect output ke stderr (standard error).
- `source_plugin "$ZDOTDIR/.../zsh-autosuggestions.zsh"`: Memanggil fungsi helper untuk memuat plugin.

**Manajemen update manual:**

```bash
# Script untuk update semua plugin
update_plugins() {
    local plugin_dir="$ZDOTDIR/plugins"
    
    for plugin in "$plugin_dir"/*/; do
        if [[ -d "$plugin/.git" ]]; then
            echo "Updating $(basename "$plugin")..."
            (cd "$plugin" && git pull --ff-only)
        fi
    done
}
```

**Penjelasan kata demi kata:**
- `for plugin in "$plugin_dir"/*/; do`: Loop untuk setiap sub-direktori di `plugins/`.
- `[[ -d "$plugin/.git" ]]`: Test apakah ada direktori `.git` (artinya ini adalah Git repository).
- `(cd "$plugin" && git pull --ff-only)`: Sub-shell — masuk ke direktori plugin, lalu `git pull`. `--ff-only` berarti hanya fast-forward, tidak membuat merge commit.
- `basename "$plugin"`: Mengambil nama direktori tanpa path lengkap.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **Manual Sourcing** | Memuat plugin dengan perintah `source` eksplisit, tanpa plugin manager. |
| **`ZDOTDIR`** | Variabel yang menentukan direktori konfigurasi Zsh. |
| **`>&2`** | Redirect output ke stderr. |
| **`--ff-only`** | Opsi Git untuk hanya melakukan fast-forward merge. |

#### Rekomendasi Visualisasi

> **Struktur pohon direktori** `~/.zsh/plugins/` akan sangat membantu untuk memvisualisasikan bagaimana plugin diorganisir.

#### Sumber Referensi

- Zsh `ZDOTDIR`: https://zsh.sourceforge.io/Doc/Release/Parameters.html
- Zsh Unplugged: https://github.com/mattmc3/zsh_unplugged

#### Tips dan Praktik Terbaik

1. **Gunakan fungsi helper** untuk menghindari repetisi dan menambahkan error handling.
2. **Simpan plugin di `~/.zsh/plugins/`** untuk organisasi yang rapi.
3. **Gunakan `zcompile`** untuk mengompilasi file plugin ke bytecode (lihat Modul 4.3).
4. **Buat script update** untuk meng-update semua plugin secara otomatis.

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Plugin tidak ditemukan | Periksa path dan pastikan file ada |
| Urutan source salah | Pastikan syntax-highlighting di-source terakhir |
| Lupa meng-update plugin | Buat script update otomatis |

---

### Mengukur dan Mengoptimalkan Waktu Startup

#### Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas **bagaimana mengukur** waktu startup Zsh dan **teknik-teknik optimasi** untuk mempercepatnya. Ini adalah inti dari Modul 4.3, tetapi konsep dasarnya sudah diperkenalkan di sini.

#### Konsep Kunci & Filosofi Mendalam

**Setiap milidetik berarti.** Jika Anda membuka terminal 50 kali sehari, dan setiap startup memakan 800ms, itu berarti **40 detik per hari** terbuang hanya untuk menunggu shell siap. Optimasi bukan tentang "lebih cepat" secara abstrak, tetapi tentang **menghilangkan bottleneck yang tidak perlu**.

**Prinsip utama:**
1. **Ukur dulu, baru optimasi.** Jangan menebak-nebak.
2. **Identifikasi bottleneck.** Gunakan profiling.
3. **Lazy loading.** Muat plugin hanya saat dibutuhkan.
4. **Kompilasi.** Ubah file Zsh menjadi bytecode.

#### Sintaks Dasar / Contoh Implementasi Inti

**Mengukur waktu startup:**

```bash
# Mengukur waktu startup shell
time zsh -i -c exit

# Output contoh:
# zsh -i -c exit  0.05s user 0.03s system 45% cpu 0.178 total
#                                                    ^^^^^^^^
#                                                    Total waktu startup
```

**Penjelasan kata demi kata:**
- `time`: Perintah untuk mengukur waktu eksekusi.
- `zsh -i -c exit`: Jalankan Zsh dalam mode interaktif (`-i`) dengan perintah (`-c`) `exit`.
- `-i`: Interactive mode — memuat `.zshrc`.
- `-c exit`: Menjalankan perintah `exit` setelah startup.

**Profiling dengan `zprof`:**

```bash
# Tambahkan di paling atas .zshrc
zmodload zsh/zprof

# ... semua konfigurasi .zshrc ...

# Tambahkan di paling bawah .zshrc
zprof | head -20
```

**Penjelasan kata demi kata:**
- `zmodload zsh/zprof`: Memuat modul profiling `zprof` bawaan Zsh.
- `zprof | head -20`: Menampilkan 20 baris pertama output profiling.

**Contoh output `zprof`:**

```bash
num  calls                time                       self            name
-----------------------------------------------------------------------------------
 1)    1          12.34    12.34   33.33%     12.34    12.34   33.33%  compinit
 2)    2           8.21     4.11   22.17%      8.21     4.11   22.17%  source
 3)    1           5.67     5.67   15.31%      5.67     5.67   15.31%  nvm
...
```

**Penjelasan kolom:**
- `num`: Nomor urut.
- `calls`: Berapa kali fungsi dipanggil.
- `time`: Total waktu yang dihabiskan (dalam ms).
- `self`: Waktu yang dihabiskan untuk fungsi itu sendiri (tidak termasuk sub-fungsi).
- `name`: Nama fungsi.

**Teknik optimasi — `zcompile`:**

```bash
# Kompilasi .zshrc ke bytecode
zcompile ~/.zshrc

# Kompilasi file plugin
zcompile ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Kompilasi file plugins statis (Antidote)
zcompile ~/.zsh_plugins.zsh
```

**Penjelasan kata demi kata:**
- `zcompile`: Perintah Zsh untuk mengompilasi file script ke bytecode.
- File output: `.zshrc.zwc` (Zsh Word Code) — dimuat lebih cepat daripada file teks.

**Teknik optimasi — `compinit -C`:**

```bash
# Cara biasa (dengan security check)
autoload -Uz compinit
compinit

# Cara cepat (skip security check)
compinit -C
```

**Penjelasan kata demi kata:**
- `compinit`: Fungsi untuk menginisialisasi sistem completion.
- `-C`: Skip security check — jangan periksa ownership dan permission file completion. **Gunakan dengan hati-hati** — hanya jika Anda yakin direktori completion aman.

**Teknik optimasi — Lazy loading dengan `zsh-defer`:**

```bash
# Install zsh-defer
git clone https://github.com/romkatv/zsh-defer.git ~/.zsh/zsh-defer

# Source di .zshrc
source ~/.zsh/zsh-defer/zsh-defer.plugin.zsh

# Gunakan untuk memuat plugin berat
zsh-defer source ~/.nvm/nvm.sh
zsh-defer source ~/.pyenv/pyenv.zsh
```

**Penjelasan kata demi kata:**
- `zsh-defer`: Plugin yang menunda eksekusi perintah sampai setelah prompt muncul.
- `zsh-defer source ~/.nvm/nvm.sh`: Menunda sourcing `nvm` sampai setelah prompt.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **`zprof`** | Modul profiling bawaan Zsh. |
| **`zcompile`** | Mengompilasi file Zsh ke bytecode (`.zwc`). |
| **`compinit -C`** | Skip security check untuk completion. |
| **Lazy Loading** | Memuat plugin hanya saat dibutuhkan. |
| **`zsh-defer`** | Plugin untuk menunda eksekusi perintah. |
| **Startup Time** | Waktu dari menjalankan Zsh hingga prompt muncul. |

#### Rekomendasi Visualisasi

> **Grafik batang profiling** akan sangat membantu: Menampilkan fungsi mana yang memakan waktu paling banyak dalam startup.

#### Sumber Referensi

- Zsh Performance Optimization: https://doc.dotfiles.io/adr/002-shell-performance/
- Speeding up Zsh: https://hoop.dev/blog/zsh-slows-down
- zsh-bench: https://github.com/romkatv/zsh-bench

#### Tips dan Praktik Terbaik

1. **Ukur sebelum dan sesudah optimasi** untuk melihat dampaknya.
2. **Gunakan `zprof` untuk mengidentifikasi bottleneck** — jangan menebak.
3. **Kompilasi file yang sering dimuat** dengan `zcompile`.
4. **Gunakan lazy loading untuk plugin berat** seperti nvm, pyenv, dan SDK manager.
5. **Hindari `compinit` setiap startup** — gunakan `compinit -C` atau caching.

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Optimasi tanpa mengukur | Selalu ukur dengan `time zsh -i -c exit` dan `zprof` |
| `compinit -C` menyebabkan completion tidak berfungsi | Pastikan direktori completion aman sebelum menggunakan `-C` |
| `zcompile` tidak berdampak | Pastikan file yang dikompilasi adalah file yang benar-benar dimuat |

---

### Terminologi Esensial Modul 4.1

Berikut adalah daftar lengkap istilah teknis yang muncul dalam Modul 4.1, dengan definisi dan contoh:

| Istilah | Definisi | Contoh |
|---------|----------|--------|
| **Oh My Zsh** | Framework komunitas untuk konfigurasi Zsh | `ZSH_THEME="robbyrussell"` |
| **Antidote** | Plugin manager Zsh fokus performa | `antidote load` |
| **Zinit** | Plugin manager Zsh fleksibel dengan Turbo | `zinit ice wait lucid` |
| **Turbo Mode** | Pemuatan asinkron plugin | `zinit ice wait` |
| **zsh-autosuggestions** | Plugin saran perintah berdasarkan history | `ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE` |
| **zsh-syntax-highlighting** | Plugin pewarnaan sintaks | `ZSH_HIGHLIGHT_STYLES[command]` |
| **Plugin Load Time** | Waktu memuat plugin saat startup | Diukur dengan `zprof` |
| **Static Plugin File** | File `.zsh` yang di-generate dari daftar plugin | `~/.zsh_plugins.zsh` |
| **`$fpath`** | Array direktori untuk fungsi autoload | `fpath=(~/.zsh/functions $fpath)` |
| **`autoload`** | Memuat fungsi secara malas | `autoload -Uz vcs_info` |
| **`zcompile`** | Mengompilasi file Zsh ke bytecode | `zcompile ~/.zshrc` |
| **`zprof`** | Modul profiling Zsh | `zmodload zsh/zprof` |
| **`compinit -C`** | Skip security check completion | `compinit -C` |
| **Lazy Loading** | Memuat plugin saat dibutuhkan | `zsh-defer source ~/.nvm/nvm.sh` |

---

### Rekomendasi Visualisasi Modul 4.1

1. **Diagram batang perbandingan waktu startup:** Vanilla Zsh (~50ms) vs Oh My Zsh (~800ms) vs Antidote (~100ms) vs Zinit Turbo (~40ms) vs Setup optimal (~100–200ms).

2. **Diagram alur startup Zsh:** Menunjukkan urutan file yang dijalankan: `/etc/zshenv` → `~/.zshenv` → `/etc/zshrc` → `~/.zshrc` → `~/.zlogin`.

3. **Diagram alur Antidote:** `.zsh_plugins.txt` → `antidote bundle` → `.zsh_plugins.zsh` → `source` saat startup.

4. **Diagram alur Turbo Mode Zinit:** Timeline: Zsh start → Prompt muncul → Di background, plugin dimuat asinkron.

5. **Tangkapan layar autosuggestions dan syntax highlighting:** Menunjukkan teks saran abu-abu dan pewarnaan perintah.

6. **Struktur pohon direktori `~/.zsh/plugins/`:** Memvisualisasikan organisasi plugin manual.

---

### Hubungan dengan Modul Lain

| Modul | Hubungan |
|-------|----------|
| **Modul 4.2 (Prompt Kustomisasi)** | Tema Oh My Zsh (`ZSH_THEME`) dan Powerlevel10k akan dibahas lebih lanjut. |
| **Modul 4.3 (Optimasi Performa)** | Teknik optimasi seperti `zcompile`, lazy loading, dan `zprof` akan diperdalam. |
| **Modul 4.4 (Keamanan Scripting)** | Praktik mengamankan `source` plugin dan manajemen secrets akan dibahas. |

---

### Sumber Referensi Lengkap Modul 4.1

1. **Oh My Zsh Wiki — Plugins:** https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
2. **Oh My Zsh GitHub:** https://github.com/ohmyzsh/ohmyzsh
3. **Antidote Official Site:** https://getantidote.github.io/
4. **Antidote GitHub:** https://github.com/mattmc3/antidote
5. **Zinit GitHub:** https://github.com/zdharma-continuum/zinit
6. **Zinit Wiki:** https://github.com/zdharma-continuum/zinit/wiki
7. **zsh-autosuggestions GitHub:** https://github.com/zsh-users/zsh-autosuggestions
8. **zsh-syntax-highlighting GitHub:** https://github.com/zsh-users/zsh-syntax-highlighting
9. **Awesome Zsh Plugins:** https://github.com/unixorn/awesome-zsh-plugins
10. **Zsh Startup Files:** https://zsh.sourceforge.io/Doc/Release/Files.html
11. **Zsh Prompt Expansion:** https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
12. **Zsh Performance Optimization:** https://doc.dotfiles.io/adr/002-shell-performance/
13. **Speeding up Zsh:** https://hoop.dev/blog/zsh-slows-down
14. **zsh-bench:** https://github.com/romkatv/zsh-bench
15. **Zsh Unplugged:** https://github.com/mattmc3/zsh_unplugged

---

### Tips dan Praktik Terbaik Modul 4.1

1. **Pilih plugin manager sesuai kebutuhan:**
   - **Oh My Zsh:** Jika Anda ingin kemudahan dan tidak keberatan dengan startup yang lebih lambat.
   - **Antidote:** Jika Anda ingin keseimbangan antara kemudahan dan performa.
   - **Zinit:** Jika Anda ingin kontrol penuh dan performa maksimal.
   - **Manual:** Jika Anda ingin minimalis dan transparan.

2. **Urutan plugin dalam array `plugins` penting:**
   - `zsh-syntax-highlighting` **harus terakhir**.
   - Plugin yang mengubah prompt **harus sebelum** plugin yang membaca prompt.

3. **Gunakan `zcompile` untuk file yang sering dimuat.**

4. **Hindari `compinit` setiap startup** — gunakan caching atau `-C`.

5. **Gunakan lazy loading untuk plugin berat** (nvm, pyenv, SDK manager).

6. **Selalu ukur dampak setiap perubahan** dengan `time zsh -i -c exit`.

7. **Jaga `.zshrc` tetap bersih** — pindahkan konfigurasi ke file terpisah.

8. **Gunakan `ZDOTDIR`** untuk organisasi yang lebih baik.

---

### Potensi Kesalahan Umum dan Solusi Modul 4.1

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| Shell lambat setelah menambah plugin | Terlalu banyak plugin dimuat di awal | Gunakan `zprof` untuk profiling; lazy loading; kurangi plugin |
| `zsh-syntax-highlighting` tidak berfungsi | Tidak berada di posisi terakhir | Pindahkan ke akhir array `plugins` |
| Autosuggestions tidak muncul | Plugin tidak di-source dengan benar | Periksa path dan urutan source |
| Konflik antar plugin | Dua plugin memodifikasi `ZLE` | Gunakan `zinit report` untuk melihat konflik |
| `compinit` lambat | Security check setiap startup | Gunakan `compinit -C` atau caching |
| Plugin tidak ditemukan | Path salah | Periksa path dan pastikan file ada |
| `.zshrc` error setelah instalasi | Konfigurasi duplikat | Periksa `.zshrc` untuk baris duplikat |
| Startup time tidak membaik setelah optimasi | Optimasi tidak tepat sasaran | Ukur dengan `zprof` untuk identifikasi bottleneck sebenarnya |

---


## ✅ Daftar yang telah diselesaikan


Materi **Modul 4.1: Framework dan Plugin Manager** telah selesai disajikan secara komprehensif, mencakup:

- ✅ Prasyarat fundamental: cara Zsh memuat konfigurasi
- ✅ Oh My Zsh: kelebihan, kekurangan, dan sintaks
- ✅ Antidote: plugin manager ringan dengan static file
- ✅ Zinit: Turbo Mode dan fleksibilitas
- ✅ Plugin esensial: autosuggestions dan syntax highlighting
- ✅ Manajemen plugin manual
- ✅ Pengukuran dan optimasi startup
- ✅ Terminologi, visualisasi, referensi, tips, dan kesalahan umum

---

# MODUL 4.2: Prompt Kustomisasi dan Tema

<details>
  <summary>📃 Daftar Isi</summary>

---


> **Daftar Isi Modul 4.2 (Mini-Daftar Isi):**
> 1.  [Prasyarat Fundamental: Memahami Prompt sebagai Antarmuka](#prasyarat-prompt)
> 2.  [Ekspansi Prompt: `%n`, `%m`, `%~`, `%#` dan Lainnya](#ekspansi-prompt)
> 3.  [Warna dan Formatting dalam Prompt](#warna-formatting)
> 4.  [`precmd` dan `preexec`: Hook yang Mengubah Segalanya](#precmd-preexec)
> 5.  [Menampilkan Git Status dengan `vcs_info`](#vcs-info)
> 6.  [Tema Populer: Powerlevel10k, Agnoster, Pure](#tema-populer)
> 7.  [Prompt Minimal vs Prompt Informatif: Filosofi Desain](#prompt-filosofi)
> 8.  [Membangun Prompt Kustom dari Nol: Studi Kasus Lengkap](#prompt-kustom)
> 9.  [Terminologi Esensial Modul 4.2](#terminologi-4-2)
> 10. [Rekomendasi Visualisasi Modul 4.2](#visualisasi-4-2)
> 11. [Hubungan dengan Modul Lain](#hubungan-4-2)
> 12. [Sumber Referensi Lengkap Modul 4.2](#referensi-4-2)
> 13. [Tips dan Praktik Terbaik Modul 4.2](#tips-4-2)
> 14. [Potensi Kesalahan Umum dan Solusi Modul 4.2](#kesalahan-4-2)

</details>

---

### Prasyarat Fundamental: Memahami Prompt sebagai Antarmuka

#### Deskripsi Konkret & Peran dalam Kurikulum

Sebelum kita menyentuh sintaks `PS1` atau `vcs_info`, kita **wajib** memahami **apa itu prompt secara fundamental** dan **bagaimana Zsh memprosesnya**. Prompt bukan sekadar teks statis — ia adalah **antarmuka dinamis** yang di-render ulang setiap kali Anda menekan Enter.

#### Konsep Kunci & Filosofi Mendalam

**Prompt adalah "wajah" shell Anda.** Ia adalah hal pertama yang Anda lihat saat membuka terminal, dan ia adalah tempat Anda mengetik perintah. Prompt yang baik memberikan **informasi yang Anda butuhkan** (di mana Anda berada, status git, exit code perintah terakhir) **tanpa mengganggu** (terlalu panjang, terlalu berwarna, terlalu berisik).

**Bagaimana Zsh memproses prompt:**

1. Zsh menyimpan **template prompt** di variabel `PS1` (Prompt String 1).
2. Setiap kali prompt akan ditampilkan, Zsh melakukan **ekspansi prompt** — mengganti kode khusus (`%n`, `%~`, dll.) dengan nilai aktual.
3. Jika `PROMPT_SUBST` diaktifkan, Zsh juga menjalankan **command substitution** (`$(...)`) dan **parameter expansion** (`${...}`) di dalam prompt.
4. Hasil akhirnya adalah string yang ditampilkan ke terminal.

**Analogi:** Bayangkan prompt seperti **papan skor di stadion**. Papan skor menampilkan informasi yang relevan (skor, waktu) secara real-time. Jika papan skor terlalu penuh dengan informasi, penonton tidak bisa fokus pada pertandingan. Jika terlalu kosong, penonton tidak tahu apa yang terjadi. Prompt yang baik adalah **keseimbangan**.

#### Sintaks Dasar / Contoh Implementasi Inti

**Prompt paling sederhana:**

```bash
PS1='$ '    # Hanya menampilkan "$ " sebagai prompt
```

**Penjelasan kata demi kata:**
- `PS1`: Variabel khusus Zsh yang menyimpan template prompt utama.
- `'$ '`: String literal yang berisi tanda dolar dan spasi. Tanda `$` di sini adalah **literal**, bukan variabel, karena berada dalam **single quotes**.

**Prompt dengan ekspansi dasar:**

```bash
PS1='%n@%m:%~%# '
# Contoh output: user@hostname:~/projects$
```

**Penjelasan kata demi kata:**
- `%n`: Ekspansi prompt untuk **username** saat ini.
- `@`: Karakter literal `@`.
- `%m`: Ekspansi prompt untuk **hostname** (sampai titik pertama).
- `:`: Karakter literal `:`.
- `%~`: Ekspansi prompt untuk **current working directory**, dengan `~` menggantikan home directory.
- `%#`: Ekspansi prompt untuk **prompt character** — `#` jika root, `%` jika user biasa.
- `' '`: Spasi di akhir prompt.

**Mengapa single quotes?**
Single quotes (`'...'`) mencegah Zsh melakukan **parameter expansion** (`$variable`) dan **command substitution** (`$(...)`) saat assignment. Kita **ingin** Zsh menyimpan template mentah dan baru memprosesnya saat prompt ditampilkan. Jika kita menggunakan double quotes (`"..."`), Zsh akan langsung mengganti `%n` dengan username saat assignment, dan prompt akan **statis**.

**Visualisasi konsep:**

```bash
┌─────────────────────────────────────────────────────────────┐
│  SAAT ASSIGNMENT (single quotes):                           │
│  PS1='%n@%m:%~%# '                                          │
│  → Zsh menyimpan string mentah: "%n@%m:%~%# "               │
│                                                             │
│  SAAT PROMPT DITAMPILKAN:                                   │
│  → Zsh mengganti %n → "user"                                │
│  → Zsh mengganti %m → "hostname"                            │
│  → Zsh mengganti %~ → "~/projects"                          │
│  → Zsh mengganti %# → "$"                                   │
│  → Hasil: "user@hostname:~/projects$ "                      │
└─────────────────────────────────────────────────────────────┘
```

---

### Ekspansi Prompt: `%n`, `%m`, `%~`, `%#` dan Lainnya

#### Deskripsi Konkret & Peran dalam Kurikulum

Ekspansi prompt adalah **inti dari kustomisasi prompt**. Ini adalah bahasa mini di dalam Zsh yang memungkinkan Anda menampilkan informasi dinamis tanpa harus menulis kode Zsh yang kompleks. Menguasai ekspansi prompt adalah **fondasi** untuk memahami tema seperti Powerlevel10k dan Agnoster.

#### Konsep Kunci & Filosofi Mendalam

Zsh menggunakan **tanda persen (`%`)** sebagai penanda ekspansi prompt. Setiap kode `%X` memiliki arti khusus. Filosofinya adalah **"informasi sekilas"** — Anda tidak perlu menjalankan perintah untuk mengetahui di mana Anda berada atau siapa Anda; prompt sudah menampilkannya.

**Mengapa `%` dan bukan `$`?**
- `$` sudah digunakan untuk **parameter expansion** (variabel).
- `%` jarang digunakan dalam teks biasa, sehingga aman sebagai penanda.
- Ini memungkinkan prompt untuk **mengandung `$` literal** tanpa konflik.

#### Sintaks Dasar / Contoh Implementasi Inti

**Tabel ekspansi prompt paling penting:**

| Kode | Arti | Contoh Output |
|------|------|---------------|
| `%n` | Username | `john` |
| `%m` | Hostname (sampai titik pertama) | `laptop` |
| `%M` | Hostname lengkap | `laptop.local` |
| `%~` | Current directory (dengan `~`) | `~/projects` |
| `%d` | Current directory (path lengkap) | `/home/john/projects` |
| `%C` | Current directory (hanya 2 level terakhir) | `john/projects` |
| `%c` | Current directory (hanya level terakhir) | `projects` |
| `%#` | `#` jika root, `%` jika user biasa | `$` atau `#` |
| `%?` | Exit code perintah terakhir | `0` |
| `%h` | Jumlah perintah di history | `1234` |
| `%T` | Waktu (HH:MM:SS) | `14:30:25` |
| `%t` | Waktu (HH:MM) | `14:30` |
| `%D` | Tanggal (YY-MM-DD) | `24-01-15` |
| `%W` | Tanggal (MM/DD/YY) | `01/15/24` |
| `%w` | Tanggal (DD Mon) | `15 Jan` |
| `%*` | Waktu dengan detik dan AM/PM | `14:30:25` |
| `%D{format}` | Tanggal dengan format kustom | `%D{%Y-%m-%d}` → `2024-01-15` |

**Contoh prompt dengan multiple ekspansi:**

```bash
PS1='[%T] %n@%m:%~%# '
# Output: [14:30:25] john@laptop:~/projects$
```

**Prompt dengan conditional:**

```bash
# Menampilkan simbol berbeda berdasarkan exit code
PS1='%(?.%F{green}√.%F{red}✗)%f %# '
# Jika exit code 0: √ (hijau)
# Jika exit code ≠ 0: ✗ (merah)
```

**Penjelasan kata demi kata:**
- `%(?.%F{green}√.%F{red}✗)`: Conditional expansion.
  - `%(...)`: Mulai conditional.
  - `?`: Kondisi — exit code 0?
  - `.`: Pemisah antara kondisi true dan false.
  - `%F{green}√`: Jika true, tampilkan `√` dengan warna hijau.
  - `.`: Pemisah.
  - `%F{red}✗`: Jika false, tampilkan `✗` dengan warna merah.
  - `)`: Akhir conditional.
- `%f`: Reset warna ke default.
- `%#`: Prompt character.

**Prompt dengan informasi git (sederhana):**

```bash
# Menggunakan command substitution (memerlukan PROMPT_SUBST)
setopt PROMPT_SUBST
PS1='%~$(git branch --show-current 2>/dev/null | sed "s/^/ (/;s/$/)/")%# '
# Output: ~/projects (main)$
```

**Penjelasan kata demi kata:**
- `setopt PROMPT_SUBST`: Mengaktifkan **command substitution** di dalam prompt. Tanpa ini, `$(...)` akan ditampilkan literal.
- `$(git branch --show-current 2>/dev/null)`: Menjalankan `git branch --show-current` dan mengambil outputnya. `2>/dev/null` membuang error jika bukan git repository.
- `| sed "s/^/ (/;s/$/)/"`: Pipe ke `sed` untuk menambahkan ` (` di awal dan `)` di akhir.
- `%#`: Prompt character.

**Prompt dengan ekspansi bertingkat (nested):**

```bash
# Menampilkan "user@host" hanya jika bukan user yang sama dengan default
PS1='%(!.%F{red}%n@%m%f.)%F{blue}%~%f%# '
# %(!...) — jika root, tampilkan user@host dengan warna merah
# Jika bukan root, tidak menampilkan apa-apa
```

**Penjelasan kata demi kata:**
- `%(!...)`: Conditional — jika **root** (UID 0).
  - `!`: Kondisi — apakah root?
  - `%F{red}%n@%m%f`: Jika root, tampilkan user@host dengan warna merah.
  - `.`: Pemisah.
  - (kosong): Jika bukan root, tidak menampilkan apa-apa.
- `%F{blue}%~%f`: Current directory dengan warna biru.
- `%#`: Prompt character.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **Ekspansi Prompt** | Proses mengganti kode `%X` dengan nilai aktual saat prompt ditampilkan. |
| **`PS1`** | Variabel yang menyimpan template prompt utama. |
| **`PROMPT_SUBST`** | Opsi Zsh untuk mengaktifkan command substitution di prompt. |
| **Conditional Expansion** | Ekspansi `%(...)` yang memungkinkan percabangan logika. |
| **`%F{color}`** | Mengatur foreground color. |
| **`%f`** | Reset foreground color ke default. |
| **`%K{color}`** | Mengatur background color. |
| **`%k`** | Reset background color. |
| **`%B`** | Bold on. |
| **`%b`** | Bold off. |
| **`%U`** | Underline on. |
| **`%u`** | Underline off. |

#### Rekomendasi Visualisasi

> **Diagram pohon ekspansi prompt** akan sangat membantu: Menampilkan bagaimana `%n@%m:%~%#` di-render menjadi `user@host:~/projects$`, dengan setiap kode `%X` dianotasi.

#### Sumber Referensi

- Zsh Prompt Expansion: https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
- Zsh Conditional Expansion: https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Conditional-Substrings-in-Prompts

#### Tips dan Praktik Terbaik

1. **Gunakan `%~` daripada `%d`** — `%~` mengganti home directory dengan `~`, sehingga lebih pendek.
2. **Gunakan `%C` untuk path yang lebih pendek** — hanya menampilkan 2 level terakhir.
3. **Gunakan conditional untuk menampilkan informasi kontekstual** — misalnya, git branch hanya jika di git repository.
4. **Hindari command substitution yang berat di prompt** — setiap kali prompt ditampilkan, perintah dijalankan. Gunakan `precmd` untuk caching.

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Prompt menampilkan `%n` literal | Gunakan single quotes saat assignment: `PS1='%n'` |
| `$(...)` tidak berfungsi di prompt | Aktifkan `setopt PROMPT_SUBST` |
| Prompt terlalu lambat | Hindari command substitution berat; gunakan `precmd` untuk caching |
| Warna tidak muncul | Pastikan terminal mendukung warna; gunakan `%F{...}` dengan benar |

---

### Warna dan Formatting dalam Prompt

#### Deskripsi Konkret & Peran dalam Kurikulum

Warna dan formatting adalah **alat komunikasi visual** di prompt. Mereka memungkinkan Anda membedakan informasi (user vs host vs path) dan menandai status (sukses vs gagal). Modul ini membahas cara menggunakan warna dengan benar dan efisien.

#### Konsep Kunci & Filosofi Mendalam

**Warna adalah bahasa.** Dalam prompt, warna digunakan untuk:
- **Memisahkan informasi:** User hijau, host biru, path kuning.
- **Menandai status:** Exit code 0 hijau, exit code ≠ 0 merah.
- **Menarik perhatian:** Branch git yang berbeda, file yang dimodifikasi.

**Filosofi minimalis:** Warna harus **berfungsi**, bukan sekadar **dekorasi**. Prompt yang terlalu berwarna-warni justru sulit dibaca. Gunakan warna untuk **membedakan**, bukan untuk **menghias**.

**Bagaimana Zsh merepresentasikan warna:**
Zsh menggunakan **ANSI escape codes** — urutan karakter khusus yang dimulai dengan `\e[` (atau `\033[`) dan diakhiri dengan `m`. Misalnya, `\e[32m` adalah hijau, `\e[0m` adalah reset.

**Tabel warna ANSI:**

| Kode | Warna | Kode | Warna |
|------|-------|------|-------|
| 30 | Hitam | 90 | Hitam terang |
| 31 | Merah | 91 | Merah terang |
| 32 | Hijau | 92 | Hijau terang |
| 33 | Kuning | 93 | Kuning terang |
| 34 | Biru | 94 | Biru terang |
| 35 | Magenta | 95 | Magenta terang |
| 36 | Cyan | 96 | Cyan terang |
| 37 | Putih | 97 | Putih terang |

**Format Zsh:** `%F{nama_warna}` untuk foreground, `%K{nama_warna}` untuk background.

#### Sintaks Dasar / Contoh Implementasi Inti

**Warna dasar:**

```bash
# Menggunakan nama warna
PS1='%F{green}%n%f@%F{blue}%m%f:%F{yellow}%~%f%# '

# Menggunakan nomor warna (0-255)
PS1='%F{2}%n%f@%F{4}%m%f:%F{3}%~%f%# '

# Warna dengan format RGB (true color, memerlukan terminal yang mendukung)
PS1='%F{#00ff00}%n%f@%F{#0000ff}%m%f%# '
```

**Penjelasan kata demi kata:**
- `%F{green}`: Set foreground color ke hijau.
- `%f`: Reset foreground color ke default.
- `%F{2}`: Set foreground color ke warna nomor 2 (hijau dalam palet 256 warna).
- `%F{#00ff00}`: Set foreground color ke RGB `#00ff00` (hijau terang).

**Formatting (bold, underline, dll.):**

```bash
# Bold
PS1='%B%n%f%b@%m%# '
# %B = bold on, %b = bold off

# Underline
PS1='%U%n%f%u@%m%# '
# %U = underline on, %u = underline off

# Kombinasi
PS1='%B%F{green}%n%f%b@%F{blue}%m%f%# '
```

**Penjelasan kata demi kata:**
- `%B`: Bold on.
- `%b`: Bold off.
- `%U`: Underline on.
- `%u`: Underline off.

**Background color:**

```bash
# Background untuk path
PS1='%K{blue}%F{white}%~%f%k%# '
# %K{blue} = background biru, %F{white} = teks putih
# %k = reset background, %f = reset foreground
```

**Prompt dengan warna kondisional:**

```bash
# Warna path berubah berdasarkan apakah direktori writable
PS1='%(W.%F{green}.%F{red})%~%f%# '
# Jika direktori writable: hijau
# Jika tidak: merah
```

**Penjelasan kata demi kata:**
- `%(W...)`: Conditional — apakah direktori writable?
  - `W`: Kondisi — writable?
  - `%F{green}`: Jika true, hijau.
  - `.`: Pemisah.
  - `%F{red}`: Jika false, merah.
- `%~`: Current directory.
- `%f`: Reset warna.

**Efek warna lebih lanjut (256 warna):**

```bash
# Menggunakan 256 warna
PS1='%F{196}%n%f@%F{21}%m%f:%F{226}%~%f%# '

# Melihat palet 256 warna di terminal
for i in {0..255}; do
    printf "\e[48;5;%dm %3d \e[0m" $i $i
    [[ $((i % 16)) -eq 15 ]] && echo
done
```

**Penjelasan kata demi kata:**
- `%F{196}`: Warna nomor 196 (merah terang dalam palet 256).
- `\e[48;5;%dm`: ANSI escape code untuk background color dengan 256 warna.
  - `48`: Background color.
  - `5`: Mode 256 warna.
  - `%d`: Nomor warna.
  - `m`: Akhir escape code.
- `\e[0m`: Reset semua formatting.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **ANSI Escape Code** | Urutan karakter khusus untuk mengontrol formatting terminal. |
| **`%F{color}`** | Set foreground color. |
| **`%K{color}`** | Set background color. |
| **`%f`** | Reset foreground color. |
| **`%k`** | Reset background color. |
| **`%B` / `%b`** | Bold on/off. |
| **`%U` / `%u`** | Underline on/off. |
| **True Color** | Warna RGB 24-bit (16 juta warna). |
| **256 Color** | Palet 256 warna yang didukung oleh sebagian besar terminal modern. |

#### Rekomendasi Visualisasi

> **Tangkapan layar prompt dengan berbagai kombinasi warna** akan sangat membantu: Menampilkan prompt dengan warna dasar, 256 warna, dan true color.

> **Diagram palet warna ANSI** akan membantu: Menampilkan 16 warna dasar dan 256 warna dengan nomor masing-masing.

#### Sumber Referensi

- Zsh Prompt Expansion (Colors): https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Visual-effects
- ANSI Escape Codes: https://en.wikipedia.org/wiki/ANSI_escape_code
- 256 Color Chart: https://www.ditig.com/256-colors-cheat-sheet

#### Tips dan Praktik Terbaik

1. **Gunakan warna yang kontras dengan background terminal** — pastikan teks terbaca.
2. **Jangan gunakan terlalu banyak warna** — 3-4 warna sudah cukup.
3. **Gunakan `%f` dan `%k` untuk reset** — jangan biarkan warna "bocor" ke teks berikutnya.
4. **Test prompt di berbagai terminal** — warna mungkin berbeda di terminal yang berbeda.
5. **Gunakan `$TERM` untuk memeriksa kemampuan terminal** — beberapa terminal tidak mendukung true color.

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Warna tidak muncul | Periksa `$TERM`; pastikan terminal mendukung warna |
| Warna "bocor" ke teks berikutnya | Selalu reset dengan `%f` dan `%k` |
| Warna terlihat berbeda di terminal lain | Gunakan warna dasar (0-7) untuk kompatibilitas maksimal |
| True color tidak berfungsi | Periksa apakah terminal mendukung `COLORTERM=truecolor` |

---

### `precmd` dan `preexec`: Hook yang Mengubah Segalanya

#### Deskripsi Konkret & Peran dalam Kurikulum

`precmd` dan `preexec` adalah **hook** — fungsi yang dijalankan secara otomatis oleh Zsh pada momen tertentu. `precmd` dijalankan **sebelum prompt ditampilkan**, dan `preexec` dijalankan **sebelum perintah dieksekusi**. Keduanya adalah **fondasi** untuk prompt dinamis yang menampilkan informasi seperti git status, waktu eksekusi, dan exit code.

#### Konsep Kunci & Filosofi Mendalam

**Analogi:** Bayangkan Anda adalah seorang **resepsionis** di sebuah kantor.
- **`precmd`** adalah saat Anda **bersiap menyambut tamu** — Anda merapikan meja, mengecek jadwal, dan menyiapkan informasi yang diperlukan.
- **`preexec`** adalah saat Anda **mencatat tamu yang datang** — Anda mencatat nama, waktu kedatangan, dan keperluan.

**Mengapa hook penting?**
- **Prompt dinamis:** Informasi seperti git status berubah setiap kali Anda berpindah direktori. `precmd` memungkinkan Anda memperbarui informasi ini **sebelum** prompt ditampilkan.
- **Pengukuran waktu:** `preexec` mencatat waktu mulai perintah, `precmd` menghitung durasi.
- **Caching:** `precmd` dapat meng-cache informasi yang mahal (seperti git status) sehingga prompt tidak lambat.

**Urutan eksekusi:**

```bash
┌─────────────────────────────────────────────────────────────┐
│  USER MENGETIK PERINTAH                                     │
│  → preexec dijalankan (mencatat waktu mulai)                │
│  → Perintah dieksekusi                                      │
│  → precmd dijalankan (menghitung durasi, update git status) │
│  → Prompt ditampilkan                                       │
└─────────────────────────────────────────────────────────────┘
```

#### Sintaks Dasar / Contoh Implementasi Inti

**`precmd` dasar:**

```bash
# Fungsi yang dijalankan sebelum prompt
precmd() {
    echo "Prompt akan ditampilkan..."
}

# Atau menggunakan add-zsh-hook (lebih baik)
autoload -Uz add-zsh-hook
add-zsh-hook precmd my_precmd_function

my_precmd_function() {
    # Kode di sini dijalankan sebelum setiap prompt
    :
}
```

**Penjelasan kata demi kata:**
- `precmd()`: Mendefinisikan fungsi `precmd`. Zsh akan otomatis memanggil fungsi ini sebelum menampilkan prompt.
- `autoload -Uz add-zsh-hook`: Memuat fungsi `add-zsh-hook` dari `$fpath`.
- `add-zsh-hook precmd my_precmd_function`: Mendaftarkan `my_precmd_function` sebagai hook `precmd`. Ini lebih baik daripada mendefinisikan `precmd()` langsung karena **tidak menimpa** hook lain.

**`preexec` dasar:**

```bash
# Fungsi yang dijalankan sebelum perintah dieksekusi
preexec() {
    echo "Akan menjalankan: $1"
}

# Dengan add-zsh-hook
add-zsh-hook preexec my_preexec_function

my_preexec_function() {
    # $1 = perintah yang akan dijalankan
    # $2 = seluruh command line
    # $3 = expanded command line
    :
}
```

**Penjelasan kata demi kata:**
- `preexec()`: Fungsi yang dipanggil sebelum perintah dieksekusi.
- `$1`: Perintah yang akan dijalankan (setelah alias expansion).
- `$2`: Seluruh command line.
- `$3`: Command line setelah ekspansi.

**Studi kasus: Mengukur waktu eksekusi perintah:**

```bash
# Variabel untuk menyimpan waktu mulai
typeset -g _cmd_start_time

# preexec: catat waktu mulai
preexec() {
    _cmd_start_time=$EPOCHREALTIME
}

# precmd: hitung dan tampilkan durasi
precmd() {
    if [[ -n "$_cmd_start_time" ]]; then
        local duration=$((EPOCHREALTIME - _cmd_start_time))
        if (( duration > 1 )); then
            printf "⏱  %.2fs\n" "$duration"
        fi
        unset _cmd_start_time
    fi
}
```

**Penjelasan kata demi kata:**
- `typeset -g _cmd_start_time`: Deklarasi variabel global (`-g`) untuk menyimpan waktu mulai.
- `$EPOCHREALTIME`: Variabel Zsh yang berisi waktu Unix dengan presisi mikrodetik.
- `preexec()`: Menyimpan waktu mulai sebelum perintah dieksekusi.
- `precmd()`: Menghitung durasi dan menampilkannya jika lebih dari 1 detik.
- `printf "⏱  %.2fs\n" "$duration"`: Menampilkan durasi dengan 2 angka desimal.

**Studi kasus: Menampilkan git status di prompt:**

```bash
autoload -Uz vcs_info
precmd() {
    vcs_info
}

zstyle ':vcs_info:git:*' formats '(%b)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a)'

setopt PROMPT_SUBST
PS1='%F{green}%n%f@%F{blue}%m%f:%F{yellow}%~%f${vcs_info_msg_0_}%# '
```

**Penjelasan kata demi kata:**
- `autoload -Uz vcs_info`: Memuat fungsi `vcs_info` dari `$fpath`.
- `precmd() { vcs_info }`: Menjalankan `vcs_info` sebelum setiap prompt untuk memperbarui informasi version control.
- `zstyle ':vcs_info:git:*' formats '(%b)'`: Mengatur format untuk git — `%b` adalah branch.
- `zstyle ':vcs_info:git:*' actionformats '(%b|%a)'`: Format saat ada action (misalnya, rebase).
- `setopt PROMPT_SUBST`: Mengaktifkan command substitution di prompt.
- `${vcs_info_msg_0_}`: Variabel yang berisi hasil `vcs_info`.

**Caching git status untuk performa:**

```bash
# Cache git status untuk menghindari pengecekan setiap prompt
typeset -g _git_status_cache=""
typeset -g _git_status_cache_dir=""

precmd() {
    local current_dir="$PWD"
    if [[ "$current_dir" != "$_git_status_cache_dir" ]]; then
        _git_status_cache_dir="$current_dir"
        if git rev-parse --is-inside-work-tree &>/dev/null; then
            local branch=$(git branch --show-current 2>/dev/null)
            local dirty=""
            if ! git diff --quiet 2>/dev/null; then
                dirty="*"
            fi
            _git_status_cache=" ($branch$dirty)"
        else
            _git_status_cache=""
        fi
    fi
}
```

**Penjelasan kata demi kata:**
- `typeset -g _git_status_cache`: Variabel global untuk menyimpan cache.
- `_git_status_cache_dir`: Menyimpan direktori terakhir yang di-cache.
- `git rev-parse --is-inside-work-tree`: Memeriksa apakah direktori saat ini adalah git repository.
- `git branch --show-current`: Mendapatkan nama branch saat ini.
- `git diff --quiet`: Memeriksa apakah ada perubahan yang belum di-commit.
- Cache hanya diperbarui jika direktori berubah.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **`precmd`** | Fungsi yang dijalankan sebelum prompt ditampilkan. |
| **`preexec`** | Fungsi yang dijalankan sebelum perintah dieksekusi. |
| **`add-zsh-hook`** | Fungsi untuk mendaftarkan hook tanpa menimpa yang lain. |
| **`$EPOCHREALTIME`** | Waktu Unix dengan presisi mikrodetik. |
| **`vcs_info`** | Modul Zsh untuk menampilkan informasi version control. |
| **Caching** | Menyimpan hasil perhitungan untuk menghindari perhitungan ulang. |

#### Rekomendasi Visualisasi

> **Diagram timeline** akan sangat membantu: Menampilkan urutan `preexec` → eksekusi perintah → `precmd` → prompt ditampilkan.

> **Diagram alur caching git status** akan membantu: Menampilkan bagaimana cache diperbarui hanya jika direktori berubah.

#### Sumber Referensi

- Zsh `precmd` dan `preexec`: https://zsh.sourceforge.io/Doc/Release/Functions.html#Hook-Functions
- `add-zsh-hook`: https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#Manipulating-Hook-Functions
- `vcs_info`: https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#Version-Control-Information

#### Tips dan Praktik Terbaik

1. **Gunakan `add-zsh-hook` daripada mendefinisikan `precmd()` langsung** — ini mencegah konflik dengan plugin lain.
2. **Cache informasi yang mahal** — git status, versi Node.js, dll.
3. **Jangan jalankan perintah berat di `precmd`** — ini memperlambat prompt.
4. **Gunakan `preexec` untuk mencatat waktu mulai** — ini adalah pola standar untuk mengukur durasi perintah.
5. **Hati-hati dengan `preexec` yang mengubah state** — pastikan tidak mengganggu perintah yang akan dijalankan.

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Prompt lambat karena git status | Cache git status; perbarui hanya jika direktori berubah |
| `precmd` menimpa hook dari plugin lain | Gunakan `add-zsh-hook` |
| `preexec` mengganggu perintah | Jangan mengubah state di `preexec`; hanya baca |
| `vcs_info` tidak berfungsi | Pastikan `autoload -Uz vcs_info` dan `precmd() { vcs_info }` |

---

### Menampilkan Git Status dengan `vcs_info`

#### Deskripsi Konkret & Peran dalam Kurikulum

`vcs_info` adalah **modul bawaan Zsh** untuk menampilkan informasi version control (VCS) di prompt. Ia mendukung Git, Mercurial, Subversion, dan lainnya. Modul ini membahas cara mengkonfigurasi `vcs_info` untuk menampilkan informasi git yang relevan.

#### Konsep Kunci & Filosofi Mendalam

**Mengapa `vcs_info` dan bukan `git status` langsung?**
- `vcs_info` adalah **bagian dari Zsh** — tidak memerlukan eksternal command.
- Ia **mendukung berbagai VCS** — Git, Hg, SVN, dll.
- Ia **dapat di-konfigurasi** dengan `zstyle`.
- Ia **di-cache** oleh Zsh — tidak dijalankan setiap prompt jika tidak perlu.

**Filosofi:** `vcs_info` adalah **abstraksi** — Anda tidak perlu tahu perintah git spesifik untuk menampilkan branch. Anda cukup mengkonfigurasi format, dan `vcs_info` menanganinya.

#### Sintaks Dasar / Contoh Implementasi Inti

**Konfigurasi dasar:**

```bash
# Muat modul vcs_info
autoload -Uz vcs_info

# Konfigurasi format
zstyle ':vcs_info:git:*' formats '(%b)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a)'

# Hook ke precmd
precmd() {
    vcs_info
}

# Tampilkan di prompt
setopt PROMPT_SUBST
PS1='%~${vcs_info_msg_0_}%# '
# Output: ~/projects (main)$
```

**Penjelasan kata demi kata:**
- `autoload -Uz vcs_info`: Memuat fungsi `vcs_info`.
- `zstyle ':vcs_info:git:*' formats '(%b)'`: Mengatur format untuk git.
  - `:vcs_info:git:*`: Pattern — semua konteks git.
  - `formats`: Format saat tidak ada action.
  - `(%b)`: `%b` = branch, `(` dan `)` literal.
- `zstyle ':vcs_info:git:*' actionformats '(%b|%a)'`: Format saat ada action (rebase, merge, dll.).
- `precmd() { vcs_info }`: Memperbarui `vcs_info` sebelum setiap prompt.
- `${vcs_info_msg_0_}`: Variabel yang berisi hasil format.

**Format lengkap `vcs_info`:**

| Kode | Arti |
|------|------|
| `%b` | Branch name |
| `%a` | Action (rebase, merge, dll.) |
| `%r` | Repository name |
| `%R` | Root directory |
| `%S` | Subdirectory |
| `%u` | Updated (unmerged) |
| `%c` | Staged changes |
| `%m` | Modified files |
| `%s` | Stash count |
| `%p` | Patch applied |
| `%i` | Revision number |

**Contoh format dengan status:**

```bash
zstyle ':vcs_info:git:*' formats '(%b) %u%c%m'
# %u = unmerged, %c = staged, %m = modified
# Output: (main) U M
```

**Penjelasan kata demi kata:**
- `%u`: Menampilkan `U` jika ada file yang belum di-merge.
- `%c`: Menampilkan `C` jika ada perubahan yang di-stage.
- `%m`: Menampilkan `M` jika ada perubahan yang belum di-stage.

**Menampilkan stash:**

```bash
zstyle ':vcs_info:git:*' formats '(%b) %s'
# %s = jumlah stash
# Output: (main) 2
```

**Konfigurasi lanjutan — `check-for-changes`:**

```bash
# Mengaktifkan pengecekan perubahan (lebih lambat tapi lebih informatif)
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr 'S'
zstyle ':vcs_info:git:*' unstagedstr 'U'
zstyle ':vcs_info:git:*' formats '(%b) %c%u'
```

**Penjelasan kata demi kata:**
- `check-for-changes true`: Mengaktifkan pengecekan perubahan (menjalankan `git diff`).
- `stagedstr 'S'`: String yang ditampilkan untuk perubahan staged.
- `unstagedstr 'U'`: String yang ditampilkan untuk perubahan unstaged.

**Action formats untuk rebase/merge:**

```bash
zstyle ':vcs_info:git:*' actionformats '(%b|%a)'
# %a = action
# Output saat rebase: (main|rebase-i)
```

**Penjelasan kata demi kata:**
- `actionformats`: Format yang digunakan saat ada action (rebase, merge, cherry-pick).
- `%a`: Nama action.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **`vcs_info`** | Modul Zsh untuk informasi version control. |
| **`zstyle`** | Perintah untuk mengatur style/konfigurasi modul Zsh. |
| **`formats`** | Format string untuk `vcs_info`. |
| **`actionformats`** | Format string saat ada action (rebase, merge). |
| **`check-for-changes`** | Opsi untuk mengecek perubahan file (lebih lambat). |
| **`vcs_info_msg_0_`** | Variabel berisi hasil `vcs_info`. |

#### Rekomendasi Visualisasi

> **Tangkapan layar prompt dengan `vcs_info`** akan sangat membantu: Menampilkan berbagai state git (clean, modified, staged, rebase).

> **Diagram format `vcs_info`** akan membantu: Menampilkan bagaimana `%b`, `%u`, `%c`, `%m` dirender.

#### Sumber Referensi

- Zsh `vcs_info` Documentation: https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#Version-Control-Information
- `vcs_info` Examples: https://github.com/zsh-users/zsh/blob/master/Misc/vcs_info-examples

#### Tips dan Praktik Terbaik

1. **Aktifkan `check-for-changes` hanya jika diperlukan** — ini memperlambat prompt.
2. **Gunakan `formats` yang ringkas** — jangan terlalu banyak informasi.
3. **Cache `vcs_info` jika prompt lambat** — meskipun Zsh sudah memiliki caching internal.
4. **Gunakan `actionformats` untuk menampilkan status rebase/merge** — ini sangat membantu saat menyelesaikan konflik.

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| `vcs_info` tidak muncul | Pastikan `precmd() { vcs_info }` dan `setopt PROMPT_SUBST` |
| Prompt lambat | Nonaktifkan `check-for-changes` atau cache hasilnya |
| Format tidak sesuai | Periksa `zstyle ':vcs_info:git:*' formats` |
| `%b` menampilkan literal | Pastikan `PROMPT_SUBST` aktif dan `${vcs_info_msg_0_}` digunakan |

---

### Tema Populer: Powerlevel10k, Agnoster, Pure

#### Deskripsi Konkret & Peran dalam Kurikulum

Tema adalah **paket siap pakai** yang mengonfigurasi prompt Anda. Daripada menulis `PS1` dari nol, Anda dapat menggunakan tema yang sudah dirancang dengan baik. Modul ini membahas tiga tema populer: **Powerlevel10k** (canggih), **Agnoster** (klasik), dan **Pure** (minimalis).

#### Konsep Kunci & Filosofi Mendalam

**Mengapa menggunakan tema?**
- **Hemat waktu:** Tidak perlu menulis prompt dari nol.
- **Desain teruji:** Tema populer telah melalui iterasi dan feedback.
- **Fitur lengkap:** Powerlevel10k, misalnya, memiliki konfigurasi interaktif.

**Trade-off:**
- **Kustomisasi:** Tema mungkin tidak 100% sesuai keinginan Anda.
- **Performa:** Beberapa tema (terutama Powerlevel10k) sangat dioptimalkan, tetapi tetap menambah overhead.
- **Dependency:** Tema memerlukan font khusus (Powerline fonts).

**Filosofi masing-masing:**
- **Powerlevel10k:** "Prompt yang cepat dan dapat dikonfigurasi sepenuhnya."
- **Agnoster:** "Prompt yang informatif dengan segmen Powerline."
- **Pure:** "Prompt minimalis yang hanya menampilkan yang penting."

#### Sintaks Dasar / Contoh Implementasi Inti

**Powerlevel10k:**

```bash
# Instalasi dengan Oh My Zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Set tema di .zshrc
ZSH_THEME="powerlevel10k/powerlevel10k"

# Instalasi manual (tanpa Oh My Zsh)
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
source ~/powerlevel10k/powerlevel10k.zsh-theme

# Konfigurasi interaktif
p10k configure
```

**Penjelasan kata demi kata:**
- `git clone --depth=1`: Clone shallow (hanya commit terakhir).
- `${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}`: Gunakan `$ZSH_CUSTOM` jika ada, jika tidak gunakan default.
- `ZSH_THEME="powerlevel10k/powerlevel10k"`: Set tema di Oh My Zsh.
- `source ~/powerlevel10k/powerlevel10k.zsh-theme`: Memuat tema secara manual.
- `p10k configure`: Menjalankan wizard konfigurasi interaktif.

**Fitur Powerlevel10k:**

```bash
# Konfigurasi via ~/.p10k.zsh
# Prompt segments: dir, vcs, time, status, dll.

# Contoh konfigurasi manual
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    dir                     # Current directory
    vcs                     # Git status
    newline                 # Line break
    prompt_char             # Prompt character
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status                  # Exit code
    command_execution_time  # Durasi perintah
    time                    # Waktu
)
```

**Penjelasan kata demi kata:**
- `POWERLEVEL9K_LEFT_PROMPT_ELEMENTS`: Array segmen untuk prompt kiri.
- `POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS`: Array segmen untuk prompt kanan.
- `dir`: Segmen untuk current directory.
- `vcs`: Segmen untuk git status.
- `status`: Segmen untuk exit code.
- `command_execution_time`: Segmen untuk durasi perintah.
- `time`: Segmen untuk waktu.

**Agnoster:**

```bash
# Agnoster tersedia di Oh My Zsh
ZSH_THEME="agnoster"

# Atau manual
git clone https://github.com/agnoster/agnoster-zsh-theme.git ~/.zsh/themes/agnoster
source ~/.zsh/themes/agnoster/agnoster.zsh-theme
```

**Penjelasan kata demi kata:**
- `ZSH_THEME="agnoster"`: Set tema Agnoster di Oh My Zsh.
- `source ~/.zsh/themes/agnoster/agnoster.zsh-theme`: Memuat tema secara manual.

**Fitur Agnoster:**
- Segmen Powerline dengan panah.
- Menampilkan user@host, path, git status.
- Membutuhkan Powerline fonts.

**Pure:**

```bash
# Instalasi Pure
git clone https://github.com/sindresorhus/pure.git ~/.zsh/pure

# Di .zshrc
fpath+=(~/.zsh/pure)
autoload -U promptinit; promptinit
prompt pure
```

**Penjelasan kata demi kata:**
- `fpath+=(~/.zsh/pure)`: Menambahkan direktori Pure ke `$fpath`.
- `autoload -U promptinit; promptinit`: Memuat sistem prompt Zsh.
- `prompt pure`: Mengaktifkan prompt Pure.

**Fitur Pure:**
- Minimalis — hanya menampilkan yang penting.
- Git status dengan simbol.
- Waktu eksekusi perintah jika > 5 detik.
- Tidak memerlukan Powerline fonts.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **Powerlevel10k** | Tema prompt Zsh yang cepat dan dapat dikonfigurasi. |
| **Agnoster** | Tema prompt klasik dengan segmen Powerline. |
| **Pure** | Tema prompt minimalis. |
| **Powerline Fonts** | Font yang memiliki glyph khusus untuk segmen prompt. |
| **`p10k configure`** | Wizard konfigurasi Powerlevel10k. |
| **Prompt Segment** | Bagian dari prompt yang menampilkan informasi tertentu. |

#### Rekomendasi Visualisasi

> **Tangkapan layar ketiga tema** akan sangat membantu: Menampilkan Powerlevel10k, Agnoster, dan Pure secara berdampingan.

> **Diagram segmen Powerlevel10k** akan membantu: Menampilkan segmen mana yang ditampilkan di kiri dan kanan.

#### Sumber Referensi

- Powerlevel10k: https://github.com/romkatv/powerlevel10k
- Agnoster: https://github.com/agnoster/agnoster-zsh-theme
- Pure: https://github.com/sindresorhus/pure
- Powerline Fonts: https://github.com/powerline/fonts

#### Tips dan Praktik Terbaik

1. **Gunakan Powerlevel10k jika Anda ingin kustomisasi penuh** — wizard `p10k configure` sangat membantu.
2. **Gunakan Pure jika Anda ingin minimalis** — tidak perlu font khusus.
3. **Instal Powerline Fonts** jika menggunakan Agnoster atau Powerlevel10k dengan segmen Powerline.
4. **Jangan gunakan terlalu banyak segmen** — prompt yang penuh informasi justru sulit dibaca.

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Glyph tidak muncul (kotak) | Instal Powerline Fonts dan set font di terminal |
| Powerlevel10k lambat | Jalankan `p10k configure` dan pilih opsi yang lebih ringan |
| Tema tidak berubah | Pastikan `ZSH_THEME` di-set sebelum `source $ZSH/oh-my-zsh.sh` |
| Konflik antar tema | Hanya aktifkan satu tema |

---

### Prompt Minimal vs Prompt Informatif: Filosofi Desain

#### Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas **trade-off** antara prompt minimal dan prompt informatif, serta **kapan** menggunakan masing-masing. Ini adalah bagian **filosofis** yang penting untuk memahami **mengapa** Anda memilih konfigurasi prompt tertentu.

#### Konsep Kunci & Filosofi Mendalam

**Prompt Minimal:**
- Hanya menampilkan yang **paling penting**: path, prompt character.
- **Kelebihan:** Cepat, tidak mengganggu, fokus pada perintah.
- **Kekurangan:** Tidak ada informasi kontekstual (git status, exit code).
- **Cocok untuk:** Developer yang sering mengetik perintah panjang, bekerja di banyak direktori.

**Prompt Informatif:**
- Menampilkan **banyak informasi**: user, host, path, git status, waktu, exit code.
- **Kelebihan:** Semua informasi tersedia sekilas.
- **Kekurangan:** Lebih lambat, bisa mengganggu, memakan ruang.
- **Cocok untuk:** Developer yang bekerja dengan git, perlu memantau status, atau bekerja di banyak environment.

**Filosofi "Prompt sebagai Dashboard":**
Prompt yang baik adalah **dashboard** — ia menampilkan informasi yang **relevan** pada **waktu yang tepat**. Jika Anda sedang bekerja dengan git, tampilkan git status. Jika Anda sedang mengukur performa, tampilkan waktu eksekusi. Jika tidak, sembunyikan.

#### Sintaks Dasar / Contoh Implementasi Inti

**Prompt minimal:**

```bash
# Hanya path dan prompt character
PS1='%~%# '
# Output: ~/projects$
```

**Prompt informatif:**

```bash
# User, host, path, git, exit code, waktu
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '(%b)'
setopt PROMPT_SUBST
PS1='%F{green}%n%f@%F{blue}%m%f:%F{yellow}%~%f${vcs_info_msg_0_} %(?.%F{green}√.%F{red}✗)%f %# '
# Output: user@host:~/projects (main) √ $
```

**Prompt adaptif (berubah berdasarkan konteks):**

```bash
# Tampilkan git hanya jika di git repository
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '(%b)'
setopt PROMPT_SUBST

# Prompt adaptif
PS1='%F{blue}%~%f${vcs_info_msg_0_:+ %F{magenta}${vcs_info_msg_0_}%f}%# '
# Jika tidak di git: ~/projects$
# Jika di git: ~/projects (main)$
```

**Penjelasan kata demi kata:**
- `${vcs_info_msg_0_:+ ...}`: Parameter expansion dengan `:+` — jika `vcs_info_msg_0_` **diset dan tidak kosong**, tampilkan `...`.
- `%F{magenta}${vcs_info_msg_0_}%f`: Git status dengan warna magenta.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **Prompt Minimal** | Prompt yang hanya menampilkan informasi paling penting. |
| **Prompt Informatif** | Prompt yang menampilkan banyak informasi. |
| **Prompt Adaptif** | Prompt yang berubah berdasarkan konteks. |
| **Dashboard** | Metafora untuk prompt yang menampilkan informasi relevan. |

#### Rekomendasi Visualisasi

> **Perbandingan side-by-side** prompt minimal vs informatif vs adaptif akan sangat membantu.

#### Sumber Referensi

- Zsh Prompt Expansion: https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
- Parameter Expansion: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Parameter-Expansion

#### Tips dan Praktik Terbaik

1. **Mulai dari minimal, tambahkan informasi sesuai kebutuhan.**
2. **Gunakan prompt adaptif** — tampilkan informasi hanya saat relevan.
3. **Ukur dampak setiap informasi** — jika prompt menjadi lambat, kurangi.
4. **Perhatikan ruang** — prompt yang terlalu panjang memakan ruang horizontal.

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Prompt terlalu panjang | Gunakan `%C` daripada `%~`; sembunyikan informasi yang tidak perlu |
| Prompt terlalu lambat | Kurangi command substitution; cache informasi |
| Informasi tidak relevan | Gunakan conditional untuk menampilkan hanya saat relevan |

---

### Membangun Prompt Kustom dari Nol: Studi Kasus Lengkap

#### Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah **studi kasus lengkap** — membangun prompt kustom dari nol, menggabungkan semua konsep yang telah dipelajari: ekspansi prompt, warna, `precmd`/`preexec`, `vcs_info`, dan filosofi desain.

#### Konsep Kunci & Filosofi Mendalam

**Tujuan:** Membangun prompt yang:
- **Cepat:** Tidak memperlambat startup atau prompt.
- **Informatif:** Menampilkan informasi yang relevan.
- **Adaptif:** Berubah berdasarkan konteks.
- **Estetis:** Enak dilihat dan tidak mengganggu.

**Desain prompt:**

```bash
┌─────────────────────────────────────────────────────────────┐
│  [14:30:25] user@host:~/projects (main) √ $                 │
│  │          │    │    │         │        │ │                │
│  │          │    │    │         │        │ └─ prompt char   │
│  │          │    │    │         │        └─ exit code       │
│  │          │    │    │         └─ git branch               │
│  │          │    │    └─ current directory                  │
│  │          │    └─ hostname                                │
│  │          └─ username                                    │
│  └─ waktu                                                   │
└─────────────────────────────────────────────────────────────┘
```

#### Sintaks Dasar / Contoh Implementasi Inti

**Langkah 1: Setup dasar**

```bash
# ~/.zshrc

# 1. Muat modul yang diperlukan
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

# 2. Aktifkan command substitution di prompt
setopt PROMPT_SUBST

# 3. Konfigurasi vcs_info
zstyle ':vcs_info:git:*' formats '(%b)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a)'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr 'S'
zstyle ':vcs_info:git:*' unstagedstr 'U'
```

**Penjelasan kata demi kata:**
- `autoload -Uz vcs_info`: Memuat fungsi `vcs_info`.
- `autoload -Uz add-zsh-hook`: Memuat fungsi `add-zsh-hook`.
- `setopt PROMPT_SUBST`: Mengaktifkan command substitution di prompt.
- `zstyle ':vcs_info:git:*' formats '(%b)'`: Format git — branch dalam tanda kurung.
- `zstyle ':vcs_info:git:*' check-for-changes true`: Aktifkan pengecekan perubahan.
- `zstyle ':vcs_info:git:*' stagedstr 'S'`: String untuk perubahan staged.
- `zstyle ':vcs_info:git:*' unstagedstr 'U'`: String untuk perubahan unstaged.

**Langkah 2: Fungsi `precmd` untuk update `vcs_info`**

```bash
# 4. Update vcs_info sebelum prompt
precmd() {
    vcs_info
}
```

**Penjelasan kata demi kata:**
- `precmd()`: Fungsi yang dijalankan sebelum prompt.
- `vcs_info`: Memperbarui informasi version control.

**Langkah 3: Fungsi `preexec` untuk mencatat waktu**

```bash
# 5. Catat waktu mulai perintah
typeset -g _cmd_start_time

preexec() {
    _cmd_start_time=$EPOCHREALTIME
}
```

**Penjelasan kata demi kata:**
- `typeset -g _cmd_start_time`: Deklarasi variabel global.
- `preexec()`: Fungsi yang dijalankan sebelum perintah.
- `_cmd_start_time=$EPOCHREALTIME`: Menyimpan waktu mulai.

**Langkah 4: Fungsi `precmd` untuk menampilkan durasi**

```bash
# 6. Tampilkan durasi jika > 1 detik
precmd() {
    vcs_info
    
    if [[ -n "$_cmd_start_time" ]]; then
        local duration=$((EPOCHREALTIME - _cmd_start_time))
        if (( duration > 1 )); then
            printf "⏱  %.2fs\n" "$duration"
        fi
        unset _cmd_start_time
    fi
}
```

**Penjelasan kata demi kata:**
- `local duration=$((EPOCHREALTIME - _cmd_start_time))`: Menghitung durasi.
- `(( duration > 1 ))`: Cek apakah durasi > 1 detik.
- `printf "⏱  %.2fs\n" "$duration"`: Menampilkan durasi dengan 2 desimal.
- `unset _cmd_start_time`: Menghapus variabel setelah digunakan.

**Langkah 5: Prompt dengan warna dan conditional**

```bash
# 7. Prompt kustom
PS1='%F{244}[%T]%f %F{green}%n%f@%F{blue}%m%f:%F{yellow}%~%f${vcs_info_msg_0_:+ %F{magenta}${vcs_info_msg_0_}%f} %(?.%F{green}√.%F{red}✗)%f %# '
```

**Penjelasan kata demi kata:**
- `%F{244}[%T]%f`: Waktu dengan warna abu-abu (244).
- `%F{green}%n%f`: Username hijau.
- `@`: Literal `@`.
- `%F{blue}%m%f`: Hostname biru.
- `:`: Literal `:`.
- `%F{yellow}%~%f`: Current directory kuning.
- `${vcs_info_msg_0_:+ %F{magenta}${vcs_info_msg_0_}%f}`: Git status magenta, hanya jika ada.
- `%(?.%F{green}√.%F{red}✗)%f`: Exit code — √ hijau atau ✗ merah.
- `%#`: Prompt character.

**Hasil akhir:**

```bash
[14:30:25] user@host:~/projects (main) √ $
```

**Langkah 6: Optimasi — Cache git status**

```bash
# 8. Cache git status untuk performa
typeset -g _git_cache=""
typeset -g _git_cache_dir=""

precmd() {
    local current_dir="$PWD"
    if [[ "$current_dir" != "$_git_cache_dir" ]]; then
        _git_cache_dir="$current_dir"
        if git rev-parse --is-inside-work-tree &>/dev/null; then
            local branch=$(git branch --show-current 2>/dev/null)
            local dirty=""
            if ! git diff --quiet 2>/dev/null; then
                dirty="*"
            fi
            _git_cache=" ($branch$dirty)"
        else
            _git_cache=""
        fi
    fi
    
    # ... kode lainnya ...
}
```

**Penjelasan kata demi kata:**
- `_git_cache`: Variabel global untuk cache.
- `_git_cache_dir`: Direktori terakhir yang di-cache.
- `[[ "$current_dir" != "$_git_cache_dir" ]]`: Cek apakah direktori berubah.
- `git rev-parse --is-inside-work-tree`: Cek apakah di git repository.
- `git branch --show-current`: Dapatkan nama branch.
- `git diff --quiet`: Cek apakah ada perubahan.
- Cache hanya diperbarui jika direktori berubah.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **Prompt Kustom** | Prompt yang dibangun dari nol sesuai kebutuhan. |
| **Caching** | Menyimpan hasil perhitungan untuk menghindari perhitungan ulang. |
| **`typeset -g`** | Deklarasi variabel global. |
| **`$EPOCHREALTIME`** | Waktu Unix dengan presisi mikrodetik. |

#### Rekomendasi Visualisasi

> **Diagram alur prompt kustom** akan sangat membantu: Menampilkan semua komponen dan bagaimana mereka di-render.

#### Sumber Referensi

- Zsh Prompt Expansion: https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
- Zsh Hook Functions: https://zsh.sourceforge.io/Doc/Release/Functions.html#Hook-Functions
- `vcs_info`: https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#Version-Control-Information

#### Tips dan Praktik Terbaik

1. **Mulai dari sederhana, tambahkan fitur satu per satu.**
2. **Test setiap perubahan** — jalankan `exec zsh` untuk reload.
3. **Ukur performa** — gunakan `time zsh -i -c exit`.
4. **Cache informasi yang mahal.**
5. **Gunakan warna yang konsisten** — jangan terlalu banyak warna.

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Prompt tidak berubah setelah edit | Jalankan `exec zsh` atau `source ~/.zshrc` |
| `vcs_info` tidak muncul | Pastikan `precmd() { vcs_info }` dan `setopt PROMPT_SUBST` |
| Prompt lambat | Cache git status; kurangi command substitution |
| Warna bocor | Selalu reset dengan `%f` |

---

### Terminologi Esensial Modul 4.2

| Istilah | Definisi | Contoh |
|---------|----------|--------|
| **`PS1`** | Variabel prompt utama | `PS1='%~%# '` |
| **Ekspansi Prompt** | Kode `%X` untuk informasi dinamis | `%n`, `%m`, `%~` |
| **`PROMPT_SUBST`** | Opsi untuk command substitution di prompt | `setopt PROMPT_SUBST` |
| **`precmd`** | Hook sebelum prompt ditampilkan | `precmd() { vcs_info }` |
| **`preexec`** | Hook sebelum perintah dieksekusi | `preexec() { ... }` |
| **`vcs_info`** | Modul informasi version control | `autoload -Uz vcs_info` |
| **`%F{color}`** | Set foreground color | `%F{green}` |
| **`%K{color}`** | Set background color | `%K{blue}` |
| **`%f` / `%k`** | Reset foreground/background | `%f%k` |
| **`%B` / `%b`** | Bold on/off | `%Bbold%b` |
| **Powerlevel10k** | Tema prompt canggih | `ZSH_THEME="powerlevel10k/powerlevel10k"` |
| **Agnoster** | Tema prompt klasik | `ZSH_THEME="agnoster"` |
| **Pure** | Tema prompt minimalis | `prompt pure` |
| **Powerline Fonts** | Font dengan glyph khusus | Diperlukan untuk Agnoster |
| **Caching** | Menyimpan hasil untuk performa | Cache git status |

---

### Rekomendasi Visualisasi Modul 4.2

1. **Diagram ekspansi prompt:** Menampilkan bagaimana `%n@%m:%~%#` dirender.

2. **Tangkapan layar prompt dengan berbagai warna:** Menampilkan warna dasar, 256 warna, true color.

3. **Diagram timeline `precmd`/`preexec`:** Menampilkan urutan eksekusi.

4. **Diagram alur caching git status:** Menampilkan bagaimana cache diperbarui.

5. **Tangkapan layar Powerlevel10k, Agnoster, Pure:** Perbandingan visual.

6. **Perbandingan prompt minimal vs informatif vs adaptif:** Side-by-side.

7. **Diagram segmen Powerlevel10k:** Menampilkan segmen kiri dan kanan.

8. **Diagram alur prompt kustom:** Menampilkan semua komponen.

---

### Hubungan dengan Modul Lain

| Modul | Hubungan |
|-------|----------|
| **Modul 4.1 (Plugin Manager)** | Tema Oh My Zsh (`ZSH_THEME`) diperdalam di sini. |
| **Modul 4.3 (Optimasi Performa)** | Caching git status dan `zcompile` untuk prompt. |
| **Modul 4.4 (Keamanan Scripting)** | Prompt yang menampilkan secrets harus dihindari. |

---

### Sumber Referensi Lengkap Modul 4.2

1. **Zsh Prompt Expansion:** https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
2. **Zsh Hook Functions:** https://zsh.sourceforge.io/Doc/Release/Functions.html#Hook-Functions
3. **Zsh `vcs_info`:** https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#Version-Control-Information
4. **Powerlevel10k:** https://github.com/romkatv/powerlevel10k
5. **Agnoster:** https://github.com/agnoster/agnoster-zsh-theme
6. **Pure:** https://github.com/sindresorhus/pure
7. **Powerline Fonts:** https://github.com/powerline/fonts
8. **ANSI Escape Codes:** https://en.wikipedia.org/wiki/ANSI_escape_code
9. **256 Color Chart:** https://www.ditig.com/256-colors-cheat-sheet
10. **Zsh Parameter Expansion:** https://zsh.sourceforge.io/Doc/Release/Expansion.html#Parameter-Expansion

---

### Tips dan Praktik Terbaik Modul 4.2

1. **Gunakan single quotes untuk `PS1`** — agar ekspansi prompt terjadi saat render, bukan saat assignment.
2. **Aktifkan `PROMPT_SUBST` hanya jika perlu** — untuk command substitution.
3. **Gunakan `add-zsh-hook`** daripada mendefinisikan `precmd()` langsung.
4. **Cache informasi yang mahal** — git status, versi Node.js, dll.
5. **Gunakan `%C` daripada `%~`** untuk path yang lebih pendek.
6. **Test prompt di berbagai terminal** — warna dan font mungkin berbeda.
7. **Jangan terlalu banyak warna** — 3-4 warna sudah cukup.
8. **Reset warna dengan `%f` dan `%k`** — untuk menghindari "bocor".
9. **Gunakan conditional untuk informasi kontekstual** — tampilkan hanya saat relevan.
10. **Ukur dampak setiap perubahan** — `time zsh -i -c exit`.

---

### Potensi Kesalahan Umum dan Solusi Modul 4.2

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| Prompt menampilkan `%n` literal | Single quotes tidak digunakan | Gunakan `PS1='%n'` |
| `$(...)` tidak berfungsi | `PROMPT_SUBST` tidak aktif | `setopt PROMPT_SUBST` |
| `vcs_info` tidak muncul | `precmd` tidak di-set | `precmd() { vcs_info }` |
| Prompt lambat | Git status dijalankan setiap prompt | Cache git status |
| Warna tidak muncul | Terminal tidak mendukung | Periksa `$TERM` |
| Warna bocor | Tidak reset | Gunakan `%f` dan `%k` |
| Glyph Powerline tidak muncul | Font tidak mendukung | Instal Powerline Fonts |
| Prompt terlalu panjang | Terlalu banyak informasi | Gunakan `%C`; sembunyikan yang tidak perlu |
| `precmd` menimpa hook lain | Mendefinisikan `precmd()` langsung | Gunakan `add-zsh-hook` |
| Durasi perintah tidak muncul | `preexec` tidak di-set | Pastikan `preexec` mencatat waktu |

---


## ✅ Daftar yang telah diselesaikan


Materi **Modul 4.2: Prompt Kustomisasi dan Tema** telah selesai disajikan secara komprehensif, mencakup:

- ✅ Prasyarat fundamental: prompt sebagai antarmuka
- ✅ Ekspansi prompt: `%n`, `%m`, `%~`, `%#`, dan lainnya
- ✅ Warna dan formatting: ANSI, 256 warna, true color
- ✅ `precmd` dan `preexec`: hook dan penggunaannya
- ✅ `vcs_info`: git status di prompt
- ✅ Tema populer: Powerlevel10k, Agnoster, Pure
- ✅ Filosofi desain: minimal vs informatif
- ✅ Studi kasus lengkap: membangun prompt kustom dari nol
- ✅ Terminologi, visualisasi, referensi, tips, dan kesalahan umum

---

# MODUL 4.3: Optimasi Performa Shell

<details>
  <summary>📃 Daftar Isi</summary>

---


> **Daftar Isi Modul 4.3 (Mini-Daftar Isi):**
> 1.  [Prasyarat Fundamental: Memahami Bottleneck Shell](#prasyarat-performa)
> 2.  [Profiling dengan `zprof`: Menemukan Biang Keladi](#profiling-zprof)
> 3.  [Mengukur Waktu Startup: `time zsh -i -c exit`](#mengukur-startup)
> 4.  [Lazy Loading: Memuat Plugin Hanya Saat Dibutuhkan](#lazy-loading)
> 5.  [Kompilasi dengan `zcompile`: Bytecode untuk Kecepatan](#zcompile)
> 6.  [Caching `compinit`: Menghindari Pemeriksaan Berulang](#caching-compinit)
> 7.  [Mengurangi Jumlah Plugin dan Konfigurasi](#mengurangi-plugin)
> 8.  [Teknik Lanjutan: `zsh-defer`, Async Loading, dan Optimasi Completion](#teknik-lanjutan)
> 9.  [Studi Kasus: Optimasi dari 1.5 Detik ke 100ms](#studi-kasus-performa)
> 10. [Terminologi Esensial Modul 4.3](#terminologi-4-3)
> 11. [Rekomendasi Visualisasi Modul 4.3](#visualisasi-4-3)
> 12. [Hubungan dengan Modul Lain](#hubungan-4-3)
> 13. [Sumber Referensi Lengkap Modul 4.3](#referensi-4-3)
> 14. [Tips dan Praktik Terbaik Modul 4.3](#tips-4-3)
> 15. [Potensi Kesalahan Umum dan Solusi Modul 4.3](#kesalahan-4-3)

</details>

---

### Prasyarat Fundamental: Memahami Bottleneck Shell

#### Deskripsi Konkret & Peran dalam Kurikulum

Sebelum kita membahas teknik optimasi, kita **wajib** memahami **apa yang membuat shell lambat**. Optimasi tanpa pemahaman adalah seperti menebak-nebak — Anda mungkin memperbaiki satu hal tetapi mengabaikan yang lain. Modul ini adalah **fondasi** untuk semua teknik optimasi yang akan dibahas.

#### Konsep Kunci & Filosofi Mendalam

**Shell yang lambat adalah masalah produktivitas.** Setiap kali Anda membuka terminal, Anda menunggu. Jika startup memakan 1 detik, dan Anda membuka terminal 50 kali sehari, itu berarti **50 detik per hari** terbuang. Dalam setahun, itu adalah **5 jam** — waktu yang cukup untuk mempelajari keterampilan baru.

**Apa yang membuat shell lambat?**
1. **Plugin yang berat:** Setiap plugin yang dimuat saat startup menambah waktu.
2. **Command substitution yang mahal:** Menjalankan perintah eksternal (seperti `git status`) di prompt.
3. **`compinit` tanpa caching:** Memeriksa semua file completion setiap startup.
4. **Sourcing file yang tidak perlu:** Memuat konfigurasi yang tidak digunakan.
5. **File `.zshrc` yang besar:** Semakin banyak kode, semakin lama dibaca.
6. **Tidak ada kompilasi:** File teks dibaca dan di-parse setiap startup.

**Filosofi optimasi:**
- **Ukur dulu, baru optimasi.** Jangan menebak.
- **Identifikasi bottleneck.** Gunakan profiling.
- **Hilangkan yang tidak perlu.** Plugin, perintah, file.
- **Tunda yang bisa ditunda.** Lazy loading.
- **Kompilasi yang sering dimuat.** Bytecode.

**Analogi:** Bayangkan Anda sedang **mempersiapkan tas untuk hiking**. Anda tidak membawa semua barang yang Anda miliki — Anda hanya membawa yang **benar-benar dibutuhkan**. Anda juga tidak memasukkan barang ke tas satu per satu saat akan berangkat — Anda sudah menyiapkannya sebelumnya. Optimasi shell adalah tentang **memilih dengan bijak** dan **mempersiapkan dengan efisien**.

#### Sintaks Dasar / Contoh Implementasi Inti

**Mengukur waktu startup (cara cepat):**

```bash
# Mengukur waktu startup shell
time zsh -i -c exit
```

**Penjelasan kata demi kata:**
- `time`: Perintah untuk mengukur waktu eksekusi.
- `zsh -i -c exit`: Menjalankan Zsh dalam mode interaktif (`-i`) dengan perintah (`-c`) `exit`.
  - `-i`: Interactive mode — memuat `.zshrc`.
  - `-c exit`: Menjalankan perintah `exit` setelah startup.
- Output: `zsh -i -c exit  0.05s user 0.03s system 45% cpu 0.178 total`
  - `0.178 total`: Total waktu startup (dalam detik).

**Mengukur waktu startup (cara lebih akurat):**

```bash
# Menggunakan zsh-bench (perlu instalasi)
git clone https://github.com/romkatv/zsh-bench.git ~/.zsh-bench
~/.zsh-bench/zsh-bench
```

**Penjelasan kata demi kata:**
- `git clone`: Meng-clone repository `zsh-bench`.
- `~/.zsh-bench/zsh-bench`: Menjalankan script benchmark.

**Mengidentifikasi plugin yang berat:**

```bash
# Menggunakan zprof (lihat bagian berikutnya)
zmodload zsh/zprof
# ... konfigurasi ...
zprof | head -20
```

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **Startup Time** | Waktu dari menjalankan Zsh hingga prompt muncul. |
| **Bottleneck** | Bagian yang paling memperlambat. |
| **Profiling** | Mengukur waktu eksekusi setiap fungsi. |
| **Lazy Loading** | Memuat plugin hanya saat dibutuhkan. |
| **Bytecode** | Kode yang sudah dikompilasi (`.zwc`). |
| **`compinit`** | Inisialisasi sistem completion. |

#### Rekomendasi Visualisasi

> **Diagram alur startup Zsh** akan sangat membantu: Menampilkan semua file yang dimuat dan berapa lama masing-masing.

#### Sumber Referensi

- Zsh Performance Optimization: https://doc.dotfiles.io/adr/002-shell-performance/
- zsh-bench: https://github.com/romkatv/zsh-bench

#### Tips dan Praktik Terbaik

1. **Ukur sebelum dan sesudah setiap perubahan.**
2. **Fokus pada bottleneck terbesar terlebih dahulu.**
3. **Jangan optimasi premature** — hanya optimasi jika memang lambat.
4. **Gunakan alat ukur yang tepat** — `time`, `zprof`, `zsh-bench`.

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Optimasi tanpa mengukur | Selalu ukur dengan `time zsh -i -c exit` |
| Mengoptimasi hal yang salah | Gunakan `zprof` untuk identifikasi bottleneck |
| Terlalu fokus pada satu aspek | Optimasi secara holistik |

---

### Profiling dengan `zprof`: Menemukan Biang Keladi

#### Deskripsi Konkret & Peran dalam Kurikulum

`zprof` adalah **modul profiling bawaan Zsh**. Ia mencatat berapa kali setiap fungsi dipanggil dan berapa lama waktu yang dihabiskan. Ini adalah **alat paling penting** untuk optimasi — tanpa `zprof`, Anda hanya menebak-nebak.

#### Konsep Kunci & Filosofi Mendalam

**`zprof` adalah "X-ray" untuk shell Anda.** Ia menunjukkan **apa yang terjadi di dalam** saat startup. Anda dapat melihat:
- Fungsi mana yang paling banyak dipanggil.
- Fungsi mana yang paling lama.
- Berapa persen waktu yang dihabiskan untuk setiap fungsi.

**Cara kerja:**
1. `zmodload zsh/zprof` mengaktifkan profiling.
2. Setiap pemanggilan fungsi dicatat.
3. `zprof` menampilkan laporan.

**Filosofi:** **"Yang diukur, akan membaik."** Dengan mengetahui di mana waktu dihabiskan, Anda dapat fokus pada area yang paling berdampak.

#### Sintaks Dasar / Contoh Implementasi Inti

**Setup `zprof`:**

```bash
# Di paling atas .zshrc
zmodload zsh/zprof

# ... semua konfigurasi .zshrc ...

# Di paling bawah .zshrc
zprof | head -20
```

**Penjelasan kata demi kata:**
- `zmodload zsh/zprof`: Memuat modul `zprof`. Ini harus **sebelum** konfigurasi lain agar semua fungsi tercatat.
- `zprof | head -20`: Menampilkan 20 baris pertama laporan profiling.

**Contoh output `zprof`:**

```bash
num  calls                time                       self            name
-----------------------------------------------------------------------------------
 1)    1          12.34    12.34   33.33%     12.34    12.34   33.33%  compinit
 2)    2           8.21     4.11   22.17%      8.21     4.11   22.17%  source
 3)    1           5.67     5.67   15.31%      5.67     5.67   15.31%  nvm
 4)    1           3.45     3.45    9.32%      3.45     3.45    9.32%  pyenv
 5)    1           2.10     2.10    5.67%      2.10     2.10    5.67%  vcs_info
...
```

**Penjelasan kolom:**
- `num`: Nomor urut.
- `calls`: Berapa kali fungsi dipanggil.
- `time`: Total waktu yang dihabiskan (dalam ms).
- `self`: Waktu yang dihabiskan untuk fungsi itu sendiri (tidak termasuk sub-fungsi).
- `name`: Nama fungsi.

**Membaca output:**
- **`compinit`** menghabiskan 12.34ms (33.33% dari total). Ini adalah bottleneck.
- **`nvm`** menghabiskan 5.67ms (15.31%). Ini juga signifikan.
- **`pyenv`** menghabiskan 3.45ms (9.32%).

**Cara mengatasi bottleneck:**

```bash
# 1. Untuk compinit: gunakan compinit -C (skip security check) atau caching
compinit -C

# 2. Untuk nvm: gunakan lazy loading
zsh-defer source ~/.nvm/nvm.sh

# 3. Untuk pyenv: gunakan lazy loading
zsh-defer source ~/.pyenv/pyenv.zsh
```

**`zprof` dengan lebih banyak detail:**

```bash
# Menampilkan semua fungsi (tanpa head)
zprof

# Menampilkan dalam format CSV
zprof -c

# Menyimpan ke file
zprof > /tmp/zprof.txt
```

**Penjelasan kata demi kata:**
- `zprof`: Menampilkan semua.
- `zprof -c`: Format CSV.
- `zprof > /tmp/zprof.txt`: Simpan ke file.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **`zprof`** | Modul profiling bawaan Zsh. |
| **`zmodload`** | Perintah untuk memuat modul Zsh. |
| **`calls`** | Jumlah pemanggilan fungsi. |
| **`time`** | Total waktu yang dihabiskan. |
| **`self`** | Waktu untuk fungsi itu sendiri. |
| **Bottleneck** | Fungsi yang paling memperlambat. |

#### Rekomendasi Visualisasi

> **Grafik batang dari output `zprof`** akan sangat membantu: Menampilkan fungsi mana yang paling lama.

> **Diagram pohon pemanggilan fungsi** akan membantu: Menampilkan hierarki fungsi.

#### Sumber Referensi

- Zsh `zprof` Documentation: https://zsh.sourceforge.io/Doc/Release/Modules.html#The-zsh_002fzprof-Module
- Profiling Zsh: https://hoop.dev/blog/zsh-slows-down

#### Tips dan Praktik Terbaik

1. **Letakkan `zmodload zsh/zprof` di paling atas `.zshrc`.**
2. **Letakkan `zprof | head -20` di paling bawah.**
3. **Fokus pada `self` time** — ini adalah waktu yang benar-benar dihabiskan fungsi.
4. **Gunakan `zprof` secara berkala** untuk memantau performa.

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| `zprof` tidak menampilkan apa-apa | Pastikan `zmodload` di paling atas dan `zprof` di paling bawah |
| Output terlalu banyak | Gunakan `head -20` atau filter |
| `zprof` memperlambat shell | Hanya aktifkan saat profiling, lalu komentari |

---

### Mengukur Waktu Startup: `time zsh -i -c exit`

#### Deskripsi Konkret & Peran dalam Kurikulum

Mengukur waktu startup adalah **langkah pertama** dalam optimasi. Anda perlu tahu **seberapa lambat** shell Anda sebelum Anda dapat memperbaikinya. Modul ini membahas berbagai cara mengukur waktu startup.

#### Konsep Kunci & Filosofi Mendalam

**"Jika Anda tidak bisa mengukurnya, Anda tidak bisa memperbaikinya."** — Peter Drucker

Waktu startup adalah **metrik utama** untuk performa shell. Ada beberapa cara mengukurnya:
1. **`time zsh -i -c exit`** — Cara paling sederhana.
2. **`zsh-bench`** — Benchmark komprehensif.
3. **`hyperfine`** — Alat benchmark eksternal.

**Filosofi:** **Konsistensi.** Ukur dengan cara yang sama setiap kali. Jangan mengubah metode pengukuran di tengah jalan.

#### Sintaks Dasar / Contoh Implementasi Inti

**Metode 1: `time zsh -i -c exit`**

```bash
# Ukur sekali
time zsh -i -c exit

# Ukur 10 kali dan ambil rata-rata
for i in {1..10}; do
    /usr/bin/time -f "%e" zsh -i -c exit
done
```

**Penjelasan kata demi kata:**
- `time`: Perintah shell untuk mengukur waktu.
- `zsh -i -c exit`: Menjalankan Zsh interaktif dan langsung keluar.
- `for i in {1..10}; do ... done`: Loop 10 kali.
- `/usr/bin/time -f "%e"`: Menggunakan `time` eksternal dengan format `%e` (elapsed time).

**Metode 2: `zsh-bench`**

```bash
# Clone zsh-bench
git clone https://github.com/romkatv/zsh-bench.git ~/.zsh-bench

# Jalankan benchmark
~/.zsh-bench/zsh-bench
```

**Penjelasan kata demi kata:**
- `git clone`: Clone repository.
- `~/.zsh-bench/zsh-bench`: Jalankan script.

**Output `zsh-bench`:**

```bash
Benchmarking: zsh -i -c exit
  Time: 0.178s
  ...
```

**Metode 3: `hyperfine`**

```bash
# Install hyperfine (jika belum)
# macOS: brew install hyperfine
# Linux: apt install hyperfine

# Benchmark
hyperfine 'zsh -i -c exit'
```

**Penjelasan kata demi kata:**
- `hyperfine`: Alat benchmark modern.
- `'zsh -i -c exit'`: Perintah yang di-benchmark.

**Output `hyperfine`:**

```bash
Benchmark #1: zsh -i -c exit
  Time (mean ± σ):     178.3 ms ±   5.2 ms
  Range (min … max):   170.1 ms … 190.2 ms
```

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **Startup Time** | Waktu dari menjalankan Zsh hingga prompt muncul. |
| **`time`** | Perintah untuk mengukur waktu eksekusi. |
| **`zsh-bench`** | Alat benchmark untuk Zsh. |
| **`hyperfine`** | Alat benchmark modern. |
| **Elapsed Time** | Waktu total yang dihabiskan. |

#### Rekomendasi Visualisasi

> **Grafik garis waktu startup** dari waktu ke waktu akan sangat membantu: Menampilkan apakah startup semakin lambat.

#### Sumber Referensi

- `zsh-bench`: https://github.com/romkatv/zsh-bench
- `hyperfine`: https://github.com/sharkdp/hyperfine
- Zsh Performance: https://doc.dotfiles.io/adr/002-shell-performance/

#### Tips dan Praktik Terbaik

1. **Ukur beberapa kali** untuk mendapatkan rata-rata.
2. **Gunakan alat yang konsisten.**
3. **Catat hasilnya** untuk membandingkan.
4. **Ukur setelah setiap perubahan.**

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Mengukur sekali saja | Ukur 5-10 kali, ambil rata-rata |
| Mengubah metode pengukuran | Gunakan metode yang sama |
| Tidak mencatat hasil | Simpan hasil di file |

---

### Lazy Loading: Memuat Plugin Hanya Saat Dibutuhkan

#### Deskripsi Konkret & Peran dalam Kurikulum

Lazy loading adalah **teknik paling efektif** untuk mempercepat startup. Daripada memuat semua plugin di awal, Anda **menunda** pemuatan plugin sampai benar-benar dibutuhkan. Ini adalah **inti dari optimasi performa**.

#### Konsep Kunci & Filosofi Mendalam

**Analogi:** Bayangkan Anda sedang **memasak**. Anda tidak mengeluarkan semua bahan dari kulkas di awal — Anda hanya mengeluarkan bahan yang akan digunakan **saat itu**. Lazy loading adalah tentang **mengeluarkan bahan saat dibutuhkan**, bukan di awal.

**Mengapa lazy loading cepat?**
- **Startup lebih cepat:** Plugin yang tidak langsung dibutuhkan tidak dimuat.
- **Hemat memori:** Plugin hanya dimuat saat digunakan.
- **Fokus:** Hanya plugin yang relevan yang dimuat.

**Apa yang bisa di-lazy load?**
- **NVM (Node Version Manager):** Memakan ~100-200ms.
- **Pyenv:** Memakan ~50-100ms.
- **SDKMAN:** Memakan ~50-100ms.
- **Rbenv:** Memakan ~30-50ms.
- **Plugin yang jarang digunakan.**

**Cara lazy loading:**
1. **`zsh-defer`:** Menunda eksekusi sampai setelah prompt.
2. **Fungsi wrapper:** Memuat plugin saat perintah pertama dipanggil.
3. **`zinit ice wait`:** Turbo mode Zinit.

#### Sintaks Dasar / Contoh Implementasi Inti

**Metode 1: `zsh-defer`**

```bash
# Install zsh-defer
git clone https://github.com/romkatv/zsh-defer.git ~/.zsh/zsh-defer

# Source di .zshrc
source ~/.zsh/zsh-defer/zsh-defer.plugin.zsh

# Gunakan untuk memuat plugin berat
zsh-defer source ~/.nvm/nvm.sh
zsh-defer source ~/.pyenv/pyenv.zsh
zsh-defer source ~/.sdkman/bin/sdkman-init.sh
```

**Penjelasan kata demi kata:**
- `zsh-defer`: Plugin yang menunda eksekusi perintah sampai setelah prompt.
- `source ~/.nvm/nvm.sh`: Perintah yang ditunda.

**Metode 2: Fungsi wrapper (untuk NVM)**

```bash
# Lazy load NVM
lazy_load_nvm() {
    unset -f nvm node npm npx
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
}

# Buat fungsi wrapper
nvm() { lazy_load_nvm; nvm "$@"; }
node() { lazy_load_nvm; node "$@"; }
npm() { lazy_load_nvm; npm "$@"; }
npx() { lazy_load_nvm; npx "$@"; }
```

**Penjelasan kata demi kata:**
- `lazy_load_nvm()`: Fungsi untuk memuat NVM.
- `unset -f nvm node npm npx`: Menghapus fungsi wrapper setelah dimuat.
- `export NVM_DIR="$HOME/.nvm"`: Set direktori NVM.
- `[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"`: Source NVM jika file ada.
- `nvm() { lazy_load_nvm; nvm "$@"; }`: Fungsi wrapper — memuat NVM lalu memanggil perintah asli.

**Metode 3: Zinit Turbo Mode**

```bash
# Di .zshrc dengan Zinit
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting
```

**Penjelasan kata demi kata:**
- `zinit ice wait lucid`: Modifier — tunggu sampai prompt muncul.
- `zinit light`: Muat plugin.

**Metode 4: Lazy loading dengan `$fpath` dan `autoload`**

```bash
# Tambahkan direktori ke fpath
fpath=(~/.zsh/functions $fpath)

# Autoload fungsi (tidak dimuat sampai dipanggil)
autoload -Uz my_heavy_function

# Fungsi akan dimuat saat pertama kali dipanggil
my_heavy_function() {
    # Kode berat
}
```

**Penjelasan kata demi kata:**
- `fpath=(~/.zsh/functions $fpath)`: Tambahkan direktori ke `$fpath`.
- `autoload -Uz my_heavy_function`: Daftarkan fungsi untuk autoload.
- Fungsi dimuat saat pertama kali dipanggil.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **Lazy Loading** | Memuat plugin hanya saat dibutuhkan. |
| **`zsh-defer`** | Plugin untuk menunda eksekusi. |
| **Fungsi Wrapper** | Fungsi yang memuat plugin lalu memanggil perintah asli. |
| **Turbo Mode** | Mode Zinit untuk pemuatan asinkron. |
| **`autoload`** | Mekanisme Zsh untuk memuat fungsi secara malas. |
| **`$fpath`** | Array direktori untuk fungsi autoload. |

#### Rekomendasi Visualisasi

> **Diagram alur lazy loading** akan sangat membantu: Menampilkan bagaimana plugin dimuat saat dibutuhkan, bukan di awal.

> **Timeline startup** dengan dan tanpa lazy loading akan membantu.

#### Sumber Referensi

- `zsh-defer`: https://github.com/romkatv/zsh-defer
- Zinit Turbo Mode: https://github.com/zdharma-continuum/zinit#turbo-mode
- Lazy Loading NVM: https://github.com/nvm-sh/nvm#deeper-shell-integration

#### Tips dan Praktik Terbaik

1. **Lazy load plugin yang berat** — NVM, Pyenv, SDKMAN.
2. **Jangan lazy load plugin yang dibutuhkan segera** — prompt, completion.
3. **Gunakan `zsh-defer` untuk plugin yang tidak mengubah prompt.**
4. **Test setelah lazy loading** — pastikan plugin masih berfungsi.

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Plugin tidak berfungsi setelah lazy loading | Pastikan wrapper memanggil perintah asli |
| Prompt tidak muncul | Jangan lazy load plugin yang mengubah prompt |
| Konflik antar wrapper | Gunakan `unset -f` untuk menghapus wrapper setelah dimuat |

---

### Kompilasi dengan `zcompile`: Bytecode untuk Kecepatan

#### Deskripsi Konkret & Peran dalam Kurikulum

`zcompile` adalah **perintah bawaan Zsh** untuk mengompilasi file script ke **bytecode**. Bytecode dimuat lebih cepat daripada file teks karena tidak perlu di-parse setiap startup. Ini adalah **teknik optimasi yang sering diabaikan** tetapi sangat efektif.

#### Konsep Kunci & Filosofi Mendalam

**Analogi:** Bayangkan Anda memiliki **resep masakan** dalam bentuk teks. Setiap kali Anda memasak, Anda harus membaca resep dari awal. `zcompile` adalah seperti **merekam video tutorial** — Anda cukup menonton video, tidak perlu membaca teks. Video (bytecode) lebih cepat "dicerna" daripada teks (source code).

**Mengapa bytecode lebih cepat?**
- **Tidak perlu parsing:** Zsh tidak perlu membaca dan memahami sintaks.
- **Langsung eksekusi:** Bytecode adalah representasi internal yang siap dijalankan.
- **Lebih kecil:** File bytecode biasanya lebih kecil dari file teks.

**Apa yang bisa dikompilasi?**
- `.zshrc`
- File plugin (`.zsh`)
- File konfigurasi
- File fungsi

#### Sintaks Dasar / Contoh Implementasi Inti

**Kompilasi `.zshrc`:**

```bash
# Kompilasi .zshrc
zcompile ~/.zshrc

# File output: ~/.zshrc.zwc
```

**Penjelasan kata demi kata:**
- `zcompile`: Perintah untuk mengompilasi.
- `~/.zshrc`: File yang dikompilasi.
- `~/.zshrc.zwc`: File output (Zsh Word Code).

**Kompilasi file plugin:**

```bash
# Kompilasi plugin
zcompile ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Kompilasi semua file .zsh di direktori
for file in ~/.zsh/plugins/**/*.zsh; do
    zcompile "$file"
done
```

**Penjelasan kata demi kata:**
- `for file in ~/.zsh/plugins/**/*.zsh; do ... done`: Loop semua file `.zsh` di direktori plugin.
- `zcompile "$file"`: Kompilasi setiap file.

**Kompilasi file plugins statis (Antidote):**

```bash
# Kompilasi file statis Antidote
zcompile ~/.zsh_plugins.zsh
```

**Penjelasan kata demi kata:**
- `~/.zsh_plugins.zsh`: File statis yang di-generate Antidote.

**Cara Zsh memuat file yang dikompilasi:**

```bash
# Zsh akan otomatis memuat .zwc jika ada dan lebih baru dari .zsh
source ~/.zshrc
# Jika ~/.zshrc.zwc ada dan lebih baru, Zsh akan memuatnya
```

**Penjelasan kata demi kata:**
- Zsh memeriksa apakah file `.zwc` ada dan lebih baru dari file `.zsh`.
- Jika ya, Zsh memuat `.zwc` daripada `.zsh`.

**Kompilasi dengan `-U` (untuk fungsi autoload):**

```bash
# Kompilasi dengan -U (abaikan alias)
zcompile -U ~/.zsh/functions/my_function
```

**Penjelasan kata demi kata:**
- `-U`: Opsi untuk mengabaikan alias saat kompilasi.

**Kompilasi dengan `-R` (untuk file yang di-source):**

```bash
# Kompilasi dengan -R (untuk file yang di-source)
zcompile -R ~/.zshrc
```

**Penjelasan kata demi kata:**
- `-R`: Opsi untuk file yang di-source (bukan dieksekusi langsung).

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **`zcompile`** | Perintah untuk mengompilasi file Zsh. |
| **Bytecode** | Kode yang sudah dikompilasi. |
| **`.zwc`** | Ekstensi file bytecode Zsh (Zsh Word Code). |
| **Parsing** | Proses membaca dan memahami sintaks. |
| **`-U`** | Opsi untuk mengabaikan alias. |
| **`-R`** | Opsi untuk file yang di-source. |

#### Rekomendasi Visualisasi

> **Diagram perbandingan** file teks vs bytecode akan sangat membantu: Menampilkan waktu yang dibutuhkan untuk memuat masing-masing.

#### Sumber Referensi

- Zsh `zcompile`: https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#index-zcompile
- Zsh Word Code: https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#index-zwc

#### Tips dan Praktik Terbaik

1. **Kompilasi file yang sering dimuat** — `.zshrc`, plugin, file statis.
2. **Kompilasi ulang setelah mengubah file.**
3. **Gunakan `-U` untuk fungsi autoload.**
4. **Gunakan `-R` untuk file yang di-source.**
5. **Jangan kompilasi file yang jarang dimuat** — tidak ada manfaatnya.

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| File `.zwc` tidak dimuat | Pastikan `.zwc` lebih baru dari `.zsh` |
| Kompilasi gagal | Periksa sintaks file; coba `zsh -n file.zsh` |
| File `.zwc` tidak di-update | Kompilasi ulang setelah mengubah file |

---

### Caching `compinit`: Menghindari Pemeriksaan Berulang

#### Deskripsi Konkret & Peran dalam Kurikulum

`compinit` adalah **inisialisasi sistem completion** Zsh. Ia memindai semua file completion di `$fpath` dan membangun cache. **Masalahnya:** `compinit` melakukan **security check** (memeriksa ownership dan permission) setiap kali dijalankan, yang memakan waktu. Modul ini membahas cara meng-cache `compinit` untuk mempercepat startup.

#### Konsep Kunci & Filosofi Mendalam

**Apa yang dilakukan `compinit`?**
1. Memindai `$fpath` untuk file completion.
2. Membangun database completion.
3. Melakukan security check — memastikan file completion tidak dimodifikasi oleh user lain.

**Mengapa security check penting?**
- Mencegah **code injection** melalui file completion yang dimodifikasi.
- Memastikan hanya file yang aman yang dimuat.

**Mengapa security check lambat?**
- Memeriksa setiap file di `$fpath`.
- Memeriksa ownership dan permission.
- Jika `$fpath` besar, ini bisa memakan **50-100ms**.

**Solusi:**
1. **`compinit -C`:** Skip security check. **Hanya jika Anda yakin direktori completion aman.**
2. **Caching:** Simpan hasil `compinit` dan muat ulang hanya jika diperlukan.
3. **`zcompile`:** Kompilasi file completion.

#### Sintaks Dasar / Contoh Implementasi Inti

**Metode 1: `compinit -C` (skip security check)**

```bash
# Cara biasa (dengan security check)
autoload -Uz compinit
compinit

# Cara cepat (skip security check)
autoload -Uz compinit
compinit -C
```

**Penjelasan kata demi kata:**
- `autoload -Uz compinit`: Memuat fungsi `compinit`.
- `compinit`: Menjalankan `compinit` dengan security check.
- `compinit -C`: Menjalankan `compinit` tanpa security check.

**Metode 2: Caching `compinit`**

```bash
# Cek apakah cache ada dan masih baru
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-~}/.zcompdump(#qN.mh+24) ]]; then
    compinit -C
else
    compinit
fi
```

**Penjelasan kata demi kata:**
- `${ZDOTDIR:-~}/.zcompdump`: File cache `compinit`.
- `(#qN.mh+24)`: Glob qualifier — file yang dimodifikasi lebih dari 24 jam yang lalu.
  - `#q`: Memulai glob qualifier.
  - `N`: Null glob (jangan error jika tidak ada).
  - `.`: Hanya file regular.
  - `mh+24`: Modified more than 24 hours ago.
- `if [[ -n ... ]]`: Jika file cache ada dan lebih dari 24 jam, gunakan `-C`.
- `else`: Jika tidak, jalankan `compinit` penuh.

**Metode 3: Caching dengan `compdump`**

```bash
# Set file cache
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump-${HOST}-${ZSH_VERSION}"

# Inisialisasi compinit dengan cache
autoload -Uz compinit
compinit -d "$ZSH_COMPDUMP"
```

**Penjelasan kata demi kata:**
- `ZSH_COMPDUMP`: Variabel untuk path file cache.
- `compinit -d "$ZSH_COMPDUMP"`: Gunakan file cache yang ditentukan.

**Metode 4: `zcompile` untuk file cache**

```bash
# Kompilasi file cache
zcompile ${ZDOTDIR:-~}/.zcompdump
```

**Penjelasan kata demi kata:**
- `zcompile`: Kompilasi file cache.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **`compinit`** | Inisialisasi sistem completion Zsh. |
| **Security Check** | Pemeriksaan ownership dan permission file completion. |
| **`compinit -C`** | Skip security check. |
| **`.zcompdump`** | File cache `compinit`. |
| **Glob Qualifier** | Sintaks Zsh untuk memfilter file berdasarkan atribut. |

#### Rekomendasi Visualisasi

> **Diagram alur `compinit`** akan sangat membantu: Menampilkan langkah-langkah dan di mana security check terjadi.

#### Sumber Referensi

- Zsh `compinit`: https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Initialization
- Zsh Glob Qualifiers: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers

#### Tips dan Praktik Terbaik

1. **Gunakan `compinit -C` hanya jika Anda yakin direktori completion aman.**
2. **Cache `compinit` dengan `ZSH_COMPDUMP`.**
3. **Kompilasi file cache dengan `zcompile`.**
4. **Jalankan `compinit` penuh secara berkala** untuk memperbarui cache.

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Completion tidak berfungsi setelah `-C` | Jalankan `compinit` penuh sekali |
| Cache tidak di-update | Hapus file cache dan jalankan `compinit` penuh |
| Security check terlalu lambat | Gunakan `-C` atau caching |

---

### Mengurangi Jumlah Plugin dan Konfigurasi

#### Deskripsi Konkret & Peran dalam Kurikulum

**Plugin adalah pedang bermata dua.** Mereka menambah fungsionalitas tetapi juga menambah waktu startup. Modul ini membahas **strategi untuk mengurangi jumlah plugin** dan **mengidentifikasi plugin yang tidak perlu**.

#### Konsep Kunci & Filosofi Mendalam

**Prinsip:** **"Kurangi, jangan tambah."** Setiap plugin yang Anda tambahkan harus memiliki **alasan yang jelas**. Jika Anda tidak menggunakan fitur plugin, mengapa memuatnya?

**Pertanyaan untuk setiap plugin:**
1. **Apakah saya menggunakan plugin ini?**
2. **Apakah plugin ini memuat sesuatu yang tidak bisa saya lakukan secara manual?**
3. **Apakah plugin ini memperlambat startup secara signifikan?**
4. **Apakah ada alternatif yang lebih ringan?**

**Strategi:**
- **Audit plugin:** Lihat daftar plugin Anda dan tanyakan apakah Anda benar-benar menggunakannya.
- **Gabungkan plugin:** Beberapa plugin mungkin bisa digantikan dengan satu plugin yang lebih ringan.
- **Gunakan plugin ringan:** Pilih plugin yang dioptimalkan untuk performa.
- **Hapus plugin yang tidak digunakan.**

#### Sintaks Dasar / Contoh Implementasi Inti

**Audit plugin:**

```bash
# Lihat semua plugin yang dimuat
zinit list

# Atau untuk Oh My Zsh
echo $plugins
```

**Penjelasan kata demi kata:**
- `zinit list`: Menampilkan daftar plugin yang dimuat oleh Zinit.
- `echo $plugins`: Menampilkan array plugin di Oh My Zsh.

**Mengukur dampak plugin:**

```bash
# Ukur startup dengan semua plugin
time zsh -i -c exit

# Komentari beberapa plugin, ukur lagi
# Bandingkan hasilnya
```

**Penjelasan kata demi kata:**
- `time zsh -i -c exit`: Mengukur startup.
- Komentari plugin di `.zshrc`, ukur lagi.

**Mengganti plugin berat dengan yang ringan:**

```bash
# Berat: Oh My Zsh git plugin
plugins=(git)

# Ringan: zsh-git-prompt atau manual
# Atau gunakan vcs_info saja
```

**Penjelasan kata demi kata:**
- `plugins=(git)`: Menggunakan plugin git Oh My Zsh.
- Alternatif: Gunakan `vcs_info` yang merupakan bagian dari Zsh.

**Menghapus plugin yang tidak digunakan:**

```bash
# Sebelum
plugins=(git docker kubectl npm node python ruby rails go rust)

# Setelah audit, hanya yang digunakan
plugins=(git docker)
```

**Penjelasan kata demi kata:**
- Hapus plugin yang tidak digunakan dari array.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **Audit Plugin** | Memeriksa plugin yang digunakan. |
| **Plugin Berat** | Plugin yang memakan banyak waktu startup. |
| **Plugin Ringan** | Plugin yang dioptimalkan untuk performa. |

#### Rekomendasi Visualisasi

> **Grafik batang** yang menampilkan dampak setiap plugin terhadap startup akan sangat membantu.

#### Sumber Referensi

- Awesome Zsh Plugins: https://github.com/unixorn/awesome-zsh-plugins
- Zsh Plugin Performance: https://github.com/romkatv/zsh-bench

#### Tips dan Praktik Terbaik

1. **Audit plugin setiap beberapa bulan.**
2. **Hapus plugin yang tidak digunakan.**
3. **Ganti plugin berat dengan yang ringan.**
4. **Gunakan `zprof` untuk mengukur dampak plugin.**

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Terlalu banyak plugin | Audit dan hapus yang tidak perlu |
| Plugin berat | Ganti dengan alternatif ringan |
| Tidak tahu plugin mana yang berat | Gunakan `zprof` |

---

### Teknik Lanjutan: `zsh-defer`, Async Loading, dan Optimasi Completion

#### Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas **teknik optimasi lanjutan** yang melampaui dasar-dasar: `zsh-defer`, async loading, dan optimasi completion. Ini adalah **teknik untuk pengguna mahir** yang ingin performa maksimal.

#### Konsep Kunci & Filosofi Mendalam

**Async loading:** Memuat plugin **di background** sementara prompt sudah muncul. Ini adalah teknik paling canggih — Anda bisa mulai bekerja sementara plugin dimuat.

**`zsh-defer`:** Plugin yang memungkinkan Anda **menunda** eksekusi perintah sampai setelah prompt. Ini adalah cara termudah untuk async loading.

**Optimasi completion:**
- **`compinit -C`:** Skip security check.
- **Caching:** Simpan hasil `compinit`.
- **`zcompile`:** Kompilasi file completion.
- **Mengurangi `$fpath`:** Hapus direktori yang tidak perlu.

#### Sintaks Dasar / Contoh Implementasi Inti

**`zsh-defer` untuk async loading:**

```bash
# Source zsh-defer
source ~/.zsh/zsh-defer/zsh-defer.plugin.zsh

# Defer plugin berat
zsh-defer source ~/.nvm/nvm.sh
zsh-defer source ~/.pyenv/pyenv.zsh
zsh-defer source ~/.sdkman/bin/sdkman-init.sh
```

**Penjelasan kata demi kata:**
- `zsh-defer`: Menunda eksekusi perintah.
- `source ~/.nvm/nvm.sh`: Perintah yang ditunda.

**Async loading dengan `zinit`:**

```bash
# Zinit Turbo Mode
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting
```

**Penjelasan kata demi kata:**
- `zinit ice wait lucid`: Modifier untuk Turbo Mode.
- `zinit light`: Muat plugin.

**Optimasi completion dengan caching:**

```bash
# Caching compinit
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump-${HOST}-${ZSH_VERSION}"
autoload -Uz compinit
if [[ -n ${ZSH_COMPDUMP}(#qN.mh+24) ]]; then
    compinit -C -d "$ZSH_COMPDUMP"
else
    compinit -d "$ZSH_COMPDUMP"
fi
```

**Penjelasan kata demi kata:**
- `ZSH_COMPDUMP`: Path file cache.
- `(#qN.mh+24)`: Glob qualifier — file lebih dari 24 jam.
- `compinit -C -d "$ZSH_COMPDUMP"`: Gunakan cache dan skip security check.
- `compinit -d "$ZSH_COMPDUMP"`: Gunakan cache dengan security check.

**Mengurangi `$fpath`:**

```bash
# Lihat $fpath
echo $fpath

# Hapus direktori yang tidak perlu
fpath=(${fpath:#*/not-needed/*})
```

**Penjelasan kata demi kata:**
- `${fpath:#*/not-needed/*}`: Parameter expansion untuk menghapus elemen yang cocok dengan pattern.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **Async Loading** | Memuat plugin di background. |
| **`zsh-defer`** | Plugin untuk menunda eksekusi. |
| **Turbo Mode** | Mode Zinit untuk async loading. |
| **Caching** | Menyimpan hasil untuk menghindari perhitungan ulang. |
| **`$fpath`** | Array direktori untuk completion. |

#### Rekomendasi Visualisasi

> **Timeline async loading** akan sangat membantu: Menampilkan prompt muncul lebih dulu, plugin dimuat di background.

#### Sumber Referensi

- `zsh-defer`: https://github.com/romkatv/zsh-defer
- Zinit Turbo Mode: https://github.com/zdharma-continuum/zinit#turbo-mode
- Zsh Completion Optimization: https://zsh.sourceforge.io/Doc/Release/Completion-System.html

#### Tips dan Praktik Terbaik

1. **Gunakan `zsh-defer` untuk plugin berat.**
2. **Gunakan Turbo Mode Zinit untuk plugin yang tidak segera dibutuhkan.**
3. **Cache `compinit` dengan `ZSH_COMPDUMP`.**
4. **Kurangi `$fpath` jika terlalu besar.**

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Plugin tidak berfungsi setelah defer | Pastikan plugin tidak dibutuhkan segera |
| Cache tidak di-update | Hapus cache dan jalankan `compinit` penuh |
| `$fpath` terlalu besar | Hapus direktori yang tidak perlu |

---

### Studi Kasus: Optimasi dari 1.5 Detik ke 100ms

#### Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah **studi kasus lengkap** — mengoptimasi shell dari 1.5 detik menjadi 100ms. Ini adalah **contoh nyata** yang menggabungkan semua teknik yang telah dipelajari.

#### Konsep Kunci & Filosofi Mendalam

**Skenario:** Seorang developer memiliki `.zshrc` dengan:
- Oh My Zsh
- 15 plugin
- NVM
- Pyenv
- SDKMAN
- `compinit` tanpa caching
- Prompt Powerlevel10k

**Startup time:** 1.5 detik.

**Tujuan:** Mengoptimasi menjadi < 200ms.

**Langkah-langkah:**
1. **Ukur:** `time zsh -i -c exit` → 1.5s.
2. **Profiling:** `zprof` → `compinit` 200ms, NVM 300ms, Pyenv 200ms, plugin 500ms.
3. **Optimasi `compinit`:** Gunakan `compinit -C` dan caching → hemat 150ms.
4. **Lazy load NVM:** `zsh-defer source ~/.nvm/nvm.sh` → hemat 300ms.
5. **Lazy load Pyenv:** `zsh-defer source ~/.pyenv/pyenv.zsh` → hemat 200ms.
6. **Lazy load SDKMAN:** `zsh-defer source ~/.sdkman/bin/sdkman-init.sh` → hemat 100ms.
7. **Kurangi plugin:** Hapus 10 plugin yang tidak digunakan → hemat 400ms.
8. **Kompilasi:** `zcompile ~/.zshrc` → hemat 50ms.
9. **Ukur ulang:** `time zsh -i -c exit` → 100ms.

**Hasil:** Dari 1.5s menjadi 100ms — **15x lebih cepat**.

#### Sintaks Dasar / Contoh Implementasi Inti

**Sebelum optimasi:**

```bash
# .zshrc (sebelum)
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git docker kubectl npm node python ruby rails go rust)
source $ZSH/oh-my-zsh.sh
source ~/.nvm/nvm.sh
source ~/.pyenv/pyenv.zsh
source ~/.sdkman/bin/sdkman-init.sh
autoload -Uz compinit
compinit
```

**Setelah optimasi:**

```bash
# .zshrc (sesudah)
# 1. Source zsh-defer
source ~/.zsh/zsh-defer/zsh-defer.plugin.zsh

# 2. Oh My Zsh dengan plugin minimal
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# 3. Lazy load plugin berat
zsh-defer source ~/.nvm/nvm.sh
zsh-defer source ~/.pyenv/pyenv.zsh
zsh-defer source ~/.sdkman/bin/sdkman-init.sh

# 4. Caching compinit
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump-${HOST}-${ZSH_VERSION}"
autoload -Uz compinit
if [[ -n ${ZSH_COMPDUMP}(#qN.mh+24) ]]; then
    compinit -C -d "$ZSH_COMPDUMP"
else
    compinit -d "$ZSH_COMPDUMP"
fi

# 5. Kompilasi (setelah edit, jalankan zcompile)
# zcompile ~/.zshrc
```

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **Studi Kasus** | Contoh nyata optimasi. |
| **Benchmark** | Pengukuran performa. |
| **Lazy Loading** | Memuat plugin saat dibutuhkan. |
| **Caching** | Menyimpan hasil untuk performa. |

#### Rekomendasi Visualisasi

> **Grafik batang sebelum vs sesudah optimasi** akan sangat membantu: Menampilkan pengurangan waktu startup.

#### Sumber Referensi

- Zsh Performance Optimization: https://doc.dotfiles.io/adr/002-shell-performance/
- zsh-bench: https://github.com/romkatv/zsh-bench

#### Tips dan Praktik Terbaik

1. **Ukur, optimasi, ukur lagi.**
2. **Fokus pada bottleneck terbesar.**
3. **Gunakan kombinasi teknik.**
4. **Test setelah setiap perubahan.**

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Optimasi tidak berdampak | Ukur dengan `zprof` untuk identifikasi bottleneck |
| Plugin tidak berfungsi | Test setelah lazy loading |
| Cache tidak di-update | Hapus cache dan jalankan `compinit` penuh |

---

### Terminologi Esensial Modul 4.3

| Istilah | Definisi | Contoh |
|---------|----------|--------|
| **`zprof`** | Modul profiling Zsh | `zmodload zsh/zprof` |
| **`zcompile`** | Kompilasi file Zsh ke bytecode | `zcompile ~/.zshrc` |
| **Lazy Loading** | Memuat plugin saat dibutuhkan | `zsh-defer source ~/.nvm/nvm.sh` |
| **`zsh-defer`** | Plugin untuk menunda eksekusi | `source ~/.zsh/zsh-defer/zsh-defer.plugin.zsh` |
| **Turbo Mode** | Async loading Zinit | `zinit ice wait lucid` |
| **`compinit -C`** | Skip security check | `compinit -C` |
| **`.zcompdump`** | File cache `compinit` | `ZSH_COMPDUMP=~/.zcompdump` |
| **Startup Time** | Waktu dari Zsh start hingga prompt | Diukur dengan `time zsh -i -c exit` |
| **Bytecode** | Kode yang sudah dikompilasi | `.zwc` |
| **Async Loading** | Memuat plugin di background | `zsh-defer` |

---

### Rekomendasi Visualisasi Modul 4.3

1. **Grafik batang output `zprof`:** Menampilkan fungsi mana yang paling lama.

2. **Timeline startup dengan dan tanpa lazy loading:** Menampilkan perbedaan.

3. **Diagram alur `compinit`:** Menampilkan langkah-langkah dan security check.

4. **Grafik batang sebelum vs sesudah optimasi:** Menampilkan pengurangan waktu.

5. **Diagram alur async loading:** Menampilkan prompt muncul lebih dulu.

6. **Diagram perbandingan file teks vs bytecode:** Menampilkan waktu muat.

---

### Hubungan dengan Modul Lain

| Modul | Hubungan |
|-------|----------|
| **Modul 4.1 (Plugin Manager)** | Teknik optimasi diterapkan pada plugin manager. |
| **Modul 4.2 (Prompt Kustomisasi)** | Caching git status dan prompt. |
| **Modul 4.4 (Keamanan Scripting)** | `compinit -C` dan security trade-off. |

---

### Sumber Referensi Lengkap Modul 4.3

1. **Zsh `zprof`:** https://zsh.sourceforge.io/Doc/Release/Modules.html#The-zsh_002fzprof-Module
2. **Zsh `zcompile`:** https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#index-zcompile
3. **`zsh-defer`:** https://github.com/romkatv/zsh-defer
4. **Zinit Turbo Mode:** https://github.com/zdharma-continuum/zinit#turbo-mode
5. **Zsh `compinit`:** https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Initialization
6. **Zsh Glob Qualifiers:** https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers
7. **zsh-bench:** https://github.com/romkatv/zsh-bench
8. **hyperfine:** https://github.com/sharkdp/hyperfine
9. **Zsh Performance Optimization:** https://doc.dotfiles.io/adr/002-shell-performance/
10. **Speeding up Zsh:** https://hoop.dev/blog/zsh-slows-down

---

### Tips dan Praktik Terbaik Modul 4.3

1. **Ukur dulu, baru optimasi.**
2. **Gunakan `zprof` untuk identifikasi bottleneck.**
3. **Lazy load plugin berat** — NVM, Pyenv, SDKMAN.
4. **Kompilasi file yang sering dimuat** dengan `zcompile`.
5. **Cache `compinit`** dengan `ZSH_COMPDUMP`.
6. **Kurangi plugin yang tidak digunakan.**
7. **Gunakan `zsh-defer` untuk async loading.**
8. **Test setelah setiap perubahan.**
9. **Jangan optimasi premature** — hanya jika memang lambat.
10. **Catat hasil optimasi** untuk referensi.

---

### Potensi Kesalahan Umum dan Solusi Modul 4.3

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| Startup masih lambat setelah optimasi | Bottleneck tidak teridentifikasi | Gunakan `zprof` untuk profiling |
| Plugin tidak berfungsi setelah lazy loading | Plugin memerlukan immediate initialization | Gunakan `load` bukan `wait` |
| `compinit -C` menyebabkan completion tidak berfungsi | Security check dilewati | Jalankan `compinit` penuh sekali |
| File `.zwc` tidak dimuat | File `.zwc` lebih lama dari `.zsh` | Kompilasi ulang |
| Cache `compinit` tidak di-update | File cache tidak di-refresh | Hapus cache dan jalankan `compinit` penuh |
| Optimasi tidak konsisten | Metode pengukuran berbeda | Gunakan metode yang sama |
| Terlalu fokus pada satu aspek | Mengabaikan aspek lain | Optimasi secara holistik |

---


## ✅ Daftar yang telah diselesaikan


Materi **Modul 4.3: Optimasi Performa Shell** telah selesai disajikan secara komprehensif, mencakup:

- ✅ Prasyarat fundamental: memahami bottleneck shell
- ✅ Profiling dengan `zprof`: menemukan biang keladi
- ✅ Mengukur waktu startup: `time zsh -i -c exit`, `zsh-bench`, `hyperfine`
- ✅ Lazy loading: `zsh-defer`, fungsi wrapper, Turbo Mode
- ✅ Kompilasi dengan `zcompile`: bytecode untuk kecepatan
- ✅ Caching `compinit`: menghindari pemeriksaan berulang
- ✅ Mengurangi jumlah plugin dan konfigurasi
- ✅ Teknik lanjutan: async loading, optimasi completion
- ✅ Studi kasus: optimasi dari 1.5 detik ke 100ms
- ✅ Terminologi, visualisasi, referensi, tips, dan kesalahan umum

---

# MODUL 4.4: Keamanan Scripting Zsh

<details>
  <summary>📃 Daftar Isi</summary>

---


> **Daftar Isi Modul 4.4 (Mini-Daftar Isi):**
> 1.  [Prasyarat Fundamental: Memahami Model Ancaman Shell](#prasyarat-keamanan)
> 2.  [Bahaya `eval` dan Code Injection](#bahaya-eval)
> 3.  [Quoting yang Benar untuk Keamanan](#quoting-keamanan)
> 4.  [Mengamankan `source` dan Plugin](#mengamankan-source)
> 5.  [Manajemen Secrets: Environment vs File](#manajemen-secrets)
> 6.  [Permission File Konfigurasi](#permission-file)
> 7.  [Audit Script dengan ShellCheck](#shellcheck)
> 8.  [Teknik Lanjutan: Sandboxing, Redaction, dan Audit Trail](#teknik-lanjutan-keamanan)
> 9.  [Studi Kasus: Audit Keamanan `.zshrc` Lengkap](#studi-kasus-keamanan)
> 10. [Terminologi Esensial Modul 4.4](#terminologi-4-4)
> 11. [Rekomendasi Visualisasi Modul 4.4](#visualisasi-4-4)
> 12. [Hubungan dengan Modul Lain](#hubungan-4-4)
> 13. [Sumber Referensi Lengkap Modul 4.4](#referensi-4-4)
> 14. [Tips dan Praktik Terbaik Modul 4.4](#tips-4-4)
> 15. [Potensi Kesalahan Umum dan Solusi Modul 4.4](#kesalahan-4-4)

</details>

---

### Prasyarat Fundamental: Memahami Model Ancaman Shell

#### Deskripsi Konkret & Peran dalam Kurikulum

Sebelum kita membahas teknik keamanan spesifik, kita **wajib** memahami **apa yang kita lindungi** dan **dari siapa**. Shell scripting memiliki **model ancaman** yang unik: script shell sering memiliki akses ke sistem file, environment variable sensitif, dan jaringan. Kesalahan sekecil apapun dapat menyebabkan **eksekusi kode berbahaya**, **kebocoran data**, atau **kerusakan sistem**.

#### Konsep Kunci & Filosofi Mendalam

**Apa yang kita lindungi?**
1. **Integritas sistem:** Script tidak boleh merusak file atau konfigurasi.
2. **Kerahasiaan data:** Secrets (API key, password, token) tidak boleh bocor.
3. **Ketersediaan layanan:** Script tidak boleh menyebabkan denial of service.
4. **Privasi pengguna:** History, log, dan data pribadi tidak boleh terekspos.

**Dari siapa?**
1. **Input pengguna yang tidak terpercaya:** Jika script menerima input dari pengguna, input tersebut bisa mengandung kode berbahaya.
2. **File yang dimodifikasi:** File konfigurasi atau plugin bisa dimodifikasi oleh pihak lain.
3. **Environment variable:** Environment bisa di-set oleh proses lain.
4. **Jaringan:** Script yang mengunduh dari internet bisa menjadi vektor serangan.

**Filosofi keamanan:**
- **Least Privilege:** Berikan akses minimum yang diperlukan.
- **Defense in Depth:** Jangan mengandalkan satu lapisan keamanan.
- **Fail Safe:** Jika terjadi kesalahan, script harus gagal dengan aman (bukan mengeksekusi kode berbahaya).
- **Never Trust Input:** Selalu validasi dan sanitasi input.

**Analogi:** Bayangkan shell Anda adalah **rumah**. Anda tidak membiarkan pintu terbuka untuk siapa saja. Anda memeriksa identitas tamu (validasi input), mengunci pintu (permission), dan tidak meninggalkan barang berharga di tempat terbuka (secrets management).

#### Sintaks Dasar / Contoh Implementasi Inti

**Prinsip dasar keamanan dalam script Zsh:**

```bash
#!/bin/zsh
# Script yang aman dimulai dengan shebang dan strict mode

set -euo pipefail
# -e: Exit on error
# -u: Exit on undefined variable
# -o pipefail: Exit on pipe failure
```

**Penjelasan kata demi kata:**
- `#!/bin/zsh`: Shebang — menentukan interpreter yang digunakan untuk menjalankan script. `/bin/zsh` adalah path ke Zsh.
- `set -e`: Exit immediately jika ada perintah yang gagal (exit code ≠ 0). Ini mencegah script melanjutkan setelah error.
- `set -u`: Exit jika ada referensi ke variabel yang belum didefinisikan. Ini mencegah bug yang disebabkan typo.
- `set -o pipefail`: Exit jika ada perintah dalam pipeline yang gagal, bukan hanya perintah terakhir.

**Mengapa `set -euo pipefail` penting?**
- Tanpa `-e`, script akan terus berjalan meskipun ada error, yang bisa menyebabkan kerusakan.
- Tanpa `-u`, typo pada nama variabel akan menghasilkan string kosong, bukan error.
- Tanpa `pipefail`, error di tengah pipeline akan diabaikan.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **Model Ancaman** | Deskripsi tentang apa yang dilindungi dan dari siapa. |
| **Least Privilege** | Prinsip memberikan akses minimum yang diperlukan. |
| **Defense in Depth** | Menggunakan multiple lapisan keamanan. |
| **Fail Safe** | Gagal dengan aman, bukan mengeksekusi kode berbahaya. |
| **Input Validation** | Memeriksa dan membersihkan input pengguna. |
| **`set -euo pipefail`** | Strict mode untuk script shell. |

#### Rekomendasi Visualisasi

> **Diagram model ancaman** akan sangat membantu: Menampilkan aset yang dilindungi, ancaman, dan lapisan pertahanan.

#### Sumber Referensi

- Zsh Security: https://hoop.dev/blog/zsh-compliance-requirements
- ShellCheck: https://www.shellcheck.net/
- Bash Strict Mode: http://redsymbol.net/articles/unofficial-bash-strict-mode/

#### Tips dan Praktik Terbaik

1. **Selalu gunakan `set -euo pipefail` di script.**
2. **Validasi semua input pengguna.**
3. **Jangan pernah mengandalkan input tanpa validasi.**
4. **Gunakan `local` untuk variabel dalam fungsi.**

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Tidak menggunakan strict mode | Selalu `set -euo pipefail` |
| Mengabaikan input validation | Selalu validasi input |
| Menggunakan variabel tanpa deklarasi | Gunakan `local` atau `typeset` |

---

### Bahaya `eval` dan Code Injection

#### Deskripsi Konkret & Peran dalam Kurikulum

`eval` adalah **perintah paling berbahaya** dalam shell scripting. Ia mengeksekusi string sebagai kode. Jika string tersebut mengandung input pengguna, **penyerang dapat mengeksekusi kode arbitrer**. Modul ini membahas mengapa `eval` berbahaya dan bagaimana menghindarinya.

#### Konsep Kunci & Filosofi Mendalam

**Apa itu `eval`?**
`eval` mengambil string, mem-parsing-nya sebagai kode Zsh, dan mengeksekusinya. Ini adalah **meta-eksekusi** — kode yang mengeksekusi kode.

**Mengapa `eval` berbahaya?**
- **Code Injection:** Jika string mengandung input pengguna, penyerang dapat menyisipkan perintah berbahaya.
- **Sulit di-debug:** Kode yang di-`eval` tidak terlihat di script.
- **Sulit dianalisis:** Static analysis tools tidak dapat menganalisis kode yang di-`eval`.

**Contoh serangan:**

```bash
# Script yang rentan
user_input="hello; rm -rf /"
eval "echo $user_input"
# Ini akan mengeksekusi: echo hello; rm -rf /
# Dan menghapus seluruh filesystem!
```

**Filosofi:** **"Jangan pernah menggunakan `eval` dengan input yang tidak terpercaya."** Bahkan dengan input yang "terpercaya", `eval` tetap berbahaya karena bisa menyebabkan bug yang tidak terduga.

#### Sintaks Dasar / Contoh Implementasi Inti

**Contoh `eval` yang berbahaya:**

```bash
# ❌ JANGAN: eval dengan input pengguna
user_input="hello; rm -rf /"
eval "echo $user_input"  # BAHAYA: code injection!

# ❌ JANGAN: eval dengan variabel yang tidak divalidasi
filename="my file; rm -rf /"
eval "cat $filename"  # BAHAYA: code injection!
```

**Penjelasan kata demi kata:**
- `user_input="hello; rm -rf /"`: Input pengguna yang berisi perintah berbahaya.
- `eval "echo $user_input"`: `eval` akan mengeksekusi `echo hello; rm -rf /`. Tanda `;` memisahkan perintah, sehingga `rm -rf /` akan dijalankan.
- `filename="my file; rm -rf /"`: Nama file yang berisi perintah berbahaya.
- `eval "cat $filename"`: `eval` akan mengeksekusi `cat my file; rm -rf /`. Spasi dalam nama file menyebabkan `cat` mencoba membuka `my` dan `file`, lalu `rm -rf /` dijalankan.

**Alternatif yang aman:**

```bash
# ✅ GUNAKAN: array dan quoting
user_input="hello"
printf '%s\n' "$user_input"

# ✅ GUNAKAN: parameter expansion
filename="my file"
cat "$filename"

# ✅ GUNAKAN: ${(q)} untuk quoting
user_input="hello; rm -rf /"
eval "echo ${(q)user_input}"
# ${(q)} akan meng-quote input sehingga aman
```

**Penjelasan kata demi kata:**
- `printf '%s\n' "$user_input"`: Mencetak input tanpa mengeksekusinya. `%s` adalah format string untuk string. `\n` adalah newline.
- `cat "$filename"`: Menggunakan double quotes untuk mencegah word splitting. Nama file dengan spasi akan dianggap sebagai satu argumen.
- `${(q)user_input}`: Parameter expansion dengan flag `(q)` — meng-quote string sehingga aman untuk `eval`. Ini adalah **satu-satunya cara aman** menggunakan `eval` dengan input pengguna.

**Kapan `eval` masih diperlukan?**
- **Indirect variable reference:** Mengakses variabel berdasarkan nama yang disimpan di variabel lain. Gunakan `${(P)name}` sebagai alternatif.
- **Dynamic command construction:** Membangun perintah secara dinamis. Gunakan array sebagai alternatif.

```bash
# Indirect variable reference tanpa eval
var_name="my_var"
my_var="hello"
echo ${(P)var_name}  # Output: hello

# Dynamic command construction tanpa eval
cmd=(echo "hello world")
"${cmd[@]}"  # Menjalankan: echo "hello world"
```

**Penjelasan kata demi kata:**
- `${(P)var_name}`: Parameter expansion dengan flag `(P)` — memperlakukan nilai `var_name` sebagai nama variabel. Ini adalah cara aman untuk indirect reference.
- `cmd=(echo "hello world")`: Array yang berisi perintah dan argumen.
- `"${cmd[@]}"`: Menjalankan array sebagai perintah. `"${cmd[@]}"` mempertahankan quoting setiap elemen.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **`eval`** | Perintah yang mengeksekusi string sebagai kode. |
| **Code Injection** | Serangan di mana input pengguna dieksekusi sebagai kode. |
| **Word Splitting** | Pemisahan string menjadi kata-kata berdasarkan spasi. |
| **`${(q)}`** | Parameter expansion untuk meng-quote string. |
| **`${(P)}`** | Parameter expansion untuk indirect variable reference. |
| **Array** | Struktur data Zsh untuk menyimpan multiple nilai. |

#### Rekomendasi Visualisasi

> **Diagram alur code injection** akan sangat membantu: Menampilkan bagaimana input pengguna masuk ke `eval` dan mengeksekusi perintah berbahaya.

#### Sumber Referensi

- Zsh Parameter Expansion: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Parameter-Expansion
- ShellCheck SC2086: https://www.shellcheck.net/wiki/SC2086
- OWASP Command Injection: https://owasp.org/www-community/attacks/Command_Injection

#### Tips dan Praktik Terbaik

1. **Hindari `eval` sama sekali** jika memungkinkan.
2. **Gunakan array** untuk membangun perintah dinamis.
3. **Gunakan `${(P)}`** untuk indirect variable reference.
4. **Jika harus menggunakan `eval`, gunakan `${(q)}`** untuk meng-quote input.
5. **Gunakan ShellCheck** untuk mendeteksi penggunaan `eval` yang berbahaya.

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Menggunakan `eval` dengan input pengguna | Gunakan `printf` atau array |
| Menggunakan `eval` untuk indirect reference | Gunakan `${(P)}` |
| Tidak meng-quote variabel | Selalu gunakan double quotes |
| Mengabaikan peringatan ShellCheck | Perbaiki semua peringatan |

---

### Quoting yang Benar untuk Keamanan

#### Deskripsi Konkret & Peran dalam Kurikulum

**Quoting adalah fondasi keamanan shell.** Quoting yang salah menyebabkan **word splitting**, **globbing**, dan **code injection**. Modul ini membahas aturan quoting yang benar dan bagaimana menghindari kesalahan umum.

#### Konsep Kunci & Filosofi Mendalam

**Apa itu quoting?**
Quoting adalah cara memberi tahu shell untuk **memperlakukan karakter khusus sebagai literal**, bukan sebagai sintaks. Ada tiga jenis quoting di Zsh:
1. **Single quotes (`'...'`):** Semua karakter literal, tidak ada ekspansi.
2. **Double quotes (`"..."`):** Ekspansi variabel dan command substitution diizinkan, tetapi tidak word splitting atau globbing.
3. **Backslash (`\`):** Meng-escape karakter berikutnya.

**Mengapa quoting penting?**
- **Word splitting:** Tanpa quoting, string dengan spasi akan dipecah menjadi beberapa argumen.
- **Globbing:** Tanpa quoting, karakter seperti `*` dan `?` akan di-expand.
- **Code injection:** Tanpa quoting, karakter khusus seperti `;` dan `|` akan diinterpretasikan.

**Filosofi:** **"Selalu quote, kecuali Anda punya alasan kuat untuk tidak."** Ini adalah aturan emas shell scripting.

#### Sintaks Dasar / Contoh Implementasi Inti

**Word splitting:**

```bash
# ❌ JANGAN: tanpa quoting
filename="my file.txt"
ls $filename  # Akan mencoba membuka "my" dan "file.txt"

# ✅ GUNAKAN: double quotes
ls "$filename"  # Akan membuka "my file.txt"
```

**Penjelasan kata demi kata:**
- `filename="my file.txt"`: Variabel berisi string dengan spasi.
- `ls $filename`: Tanpa quoting, shell akan memecah string menjadi `my` dan `file.txt`.
- `ls "$filename"`: Dengan double quotes, string tetap utuh.

**Globbing:**

```bash
# ❌ JANGAN: tanpa quoting
pattern="*.txt"
echo $pattern  # Akan menampilkan semua file .txt

# ✅ GUNAKAN: double quotes
echo "$pattern"  # Akan menampilkan "*.txt" secara literal
```

**Penjelasan kata demi kata:**
- `pattern="*.txt"`: Variabel berisi pattern glob.
- `echo $pattern`: Tanpa quoting, `*.txt` akan di-expand menjadi semua file `.txt`.
- `echo "$pattern"`: Dengan double quotes, `*.txt` tetap literal.

**Code injection:**

```bash
# ❌ JANGAN: tanpa quoting
user_input="hello; rm -rf /"
echo $user_input  # Akan menjalankan: echo hello; rm -rf /

# ✅ GUNAKAN: double quotes
echo "$user_input"  # Akan menampilkan: hello; rm -rf /
```

**Penjelasan kata demi kata:**
- `user_input="hello; rm -rf /"`: Input berisi perintah berbahaya.
- `echo $user_input`: Tanpa quoting, `;` akan diinterpretasikan sebagai pemisah perintah.
- `echo "$user_input"`: Dengan double quotes, `;` tetap literal.

**Quoting dalam array:**

```bash
# ✅ GUNAKAN: quoting setiap elemen array
files=("my file.txt" "another file.txt")
for file in "${files[@]}"; do
    echo "$file"
done
```

**Penjelasan kata demi kata:**
- `files=("my file.txt" "another file.txt")`: Array dengan elemen yang mengandung spasi.
- `for file in "${files[@]}"; do ... done`: Loop setiap elemen. `"${files[@]}"` mempertahankan quoting setiap elemen.
- `echo "$file"`: Meng-quote variabel loop.

**Kapan TIDAK menggunakan quoting?**
- **Pattern matching:** `[[ $var == pattern ]]` — pattern tidak perlu di-quote.
- **Regular expression:** `[[ $var =~ regex ]]` — regex tidak perlu di-quote.
- **Assigning array:** `arr=(word1 word2)` — word splitting diinginkan.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **Quoting** | Memberi tahu shell untuk memperlakukan karakter sebagai literal. |
| **Single Quotes** | `'...'` — semua literal, tidak ada ekspansi. |
| **Double Quotes** | `"..."` — ekspansi variabel, tetapi tidak word splitting/globbing. |
| **Word Splitting** | Pemecahan string menjadi kata-kata berdasarkan spasi. |
| **Globbing** | Ekspansi pattern glob (`*`, `?`, dll.). |
| **Backslash** | `\` — meng-escape karakter berikutnya. |

#### Rekomendasi Visualisasi

> **Diagram perbandingan quoting** akan sangat membantu: Menampilkan bagaimana string yang sama diperlakukan dengan single quotes, double quotes, dan tanpa quotes.

#### Sumber Referensi

- Zsh Quoting: https://zsh.sourceforge.io/Doc/Release/Shell-Grammar.html#Quoting
- ShellCheck SC2086: https://www.shellcheck.net/wiki/SC2086
- Bash Quoting: https://mywiki.wooledge.org/Quotes

#### Tips dan Praktik Terbaik

1. **Selalu gunakan double quotes** untuk variabel.
2. **Gunakan `"$@"` untuk semua argumen posisi.**
3. **Gunakan `"${array[@]}"` untuk semua elemen array.**
4. **Gunakan single quotes jika tidak ada ekspansi yang diinginkan.**
5. **Gunakan `${(q)}` untuk quoting dalam konteks yang memerlukan.**

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| `$var` tanpa quotes | Gunakan `"$var"` |
| `$@` tanpa quotes | Gunakan `"$@"` |
| `${array[@]}` tanpa quotes | Gunakan `"${array[@]}"` |
| Meng-quote pattern dalam `[[ ]]` | Jangan quote pattern |

---

### Mengamankan `source` dan Plugin

#### Deskripsi Konkret & Peran dalam Kurikulum

`source` adalah perintah yang **mengeksekusi file dalam konteks shell saat ini**. Jika file yang di-source dimodifikasi oleh pihak lain, ini bisa menjadi **vektor serangan**. Modul ini membahas cara mengamankan `source` dan plugin.

#### Konsep Kunci & Filosofi Mendalam

**Apa itu `source`?**
`source` (atau `.`) mengeksekusi file dalam konteks shell saat ini. Ini berarti:
- Variabel yang di-set di file akan tersedia di shell.
- Fungsi yang didefinisikan di file akan tersedia di shell.
- Perintah di file dijalankan dengan hak akses shell.

**Mengapa `source` berbahaya?**
- **File bisa dimodifikasi:** Jika file yang di-source berada di direktori yang writable oleh user lain, penyerang bisa memodifikasi file dan menambahkan kode berbahaya.
- **File bisa berasal dari sumber tidak terpercaya:** Plugin yang diunduh dari internet bisa berisi kode berbahaya.
- **Tidak ada validasi:** `source` mengeksekusi file tanpa validasi.

**Filosofi:** **"Hanya source file yang Anda percayai, dan pastikan file tersebut tidak dapat dimodifikasi oleh pihak lain."**

#### Sintaks Dasar / Contoh Implementasi Inti

**Fungsi `safe_source`:**

```bash
# Fungsi untuk source file dengan aman
safe_source() {
    local file="$1"
    
    # Periksa apakah file ada
    if [[ ! -f "$file" ]]; then
        echo "Error: File tidak ditemukan: $file" >&2
        return 1
    fi
    
    # Periksa ownership (harus milik user saat ini)
    if [[ ! -O "$file" ]]; then
        echo "Error: File bukan milik Anda: $file" >&2
        return 1
    fi
    
    # Periksa permission (tidak boleh writable oleh group/other)
    local perms=$(stat -c '%a' "$file" 2>/dev/null || stat -f '%Lp' "$file" 2>/dev/null)
    if [[ "$perms" =~ [2367]$ ]]; then
        echo "Error: File writable oleh group/other: $file" >&2
        return 1
    fi
    
    # Source file
    source "$file"
}
```

**Penjelasan kata demi kata:**
- `safe_source()`: Mendefinisikan fungsi.
- `local file="$1"`: Deklarasi variabel lokal dengan argumen pertama.
- `[[ ! -f "$file" ]]`: Test apakah file tidak ada. `-f` berarti file regular.
- `[[ ! -O "$file" ]]`: Test apakah file bukan milik user saat ini. `-O` berarti owned by current user.
- `stat -c '%a' "$file"`: Mendapatkan permission file dalam format oktal (Linux).
- `stat -f '%Lp' "$file"`: Mendapatkan permission file (macOS).
- `[[ "$perms" =~ [2367]$ ]]`: Test apakah digit terakhir permission adalah 2, 3, 6, atau 7 (writable oleh group/other).
- `source "$file"`: Source file jika semua pemeriksaan lolos.

**Mengamankan plugin:**

```bash
# Sebelum source plugin, verifikasi checksum
verify_plugin() {
    local plugin_file="$1"
    local expected_checksum="$2"
    local actual_checksum=$(sha256sum "$plugin_file" | cut -d' ' -f1)
    
    if [[ "$actual_checksum" != "$expected_checksum" ]]; then
        echo "Error: Checksum tidak cocok untuk $plugin_file" >&2
        return 1
    fi
    
    return 0
}

# Gunakan
if verify_plugin ~/.zsh/plugins/my-plugin.plugin.zsh "abc123..."; then
    source ~/.zsh/plugins/my-plugin.plugin.zsh
fi
```

**Penjelasan kata demi kata:**
- `sha256sum "$plugin_file"`: Menghitung checksum SHA-256.
- `cut -d' ' -f1`: Mengambil field pertama (checksum) dari output.
- `[[ "$actual_checksum" != "$expected_checksum" ]]`: Membandingkan checksum.

**Menggunakan `zinit` dengan verifikasi:**

```bash
# Zinit dengan verifikasi
zinit ice verifier'my_verifier_function'
zinit light user/repo
```

**Penjelasan kata demi kata:**
- `zinit ice verifier'...'`: Menentukan fungsi verifier.
- `zinit light`: Memuat plugin.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **`source`** | Mengeksekusi file dalam konteks shell saat ini. |
| **Ownership Check** | Memeriksa apakah file milik user saat ini. |
| **Permission Check** | Memeriksa permission file. |
| **Checksum** | Nilai hash untuk verifikasi integritas file. |
| **SHA-256** | Algoritma hash kriptografis. |
| **`-O`** | Test operator Zsh untuk ownership. |
| **`stat`** | Perintah untuk mendapatkan metadata file. |

#### Rekomendasi Visualisasi

> **Diagram alur `safe_source`** akan sangat membantu: Menampilkan pemeriksaan yang dilakukan sebelum source.

#### Sumber Referensi

- Zsh `source`: https://zsh.sourceforge.io/Doc/Release/Shell-Builtin-Commands.html#index-source
- Zsh Conditional Expressions: https://zsh.sourceforge.io/Doc/Release/Conditional-Expressions.html
- ShellCheck SC1090: https://www.shellcheck.net/wiki/SC1090

#### Tips dan Praktik Terbaik

1. **Selalu periksa ownership dan permission sebelum `source`.**
2. **Gunakan checksum untuk verifikasi integritas.**
3. **Jangan source file dari direktori yang writable oleh user lain.**
4. **Gunakan plugin manager yang memiliki fitur verifikasi.**

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Source file tanpa verifikasi | Gunakan `safe_source` |
| Source file dari direktori `/tmp` | Jangan source dari direktori yang writable |
| Tidak memeriksa permission | Periksa permission file |

---

### Manajemen Secrets: Environment vs File

#### Deskripsi Konkret & Peran dalam Kurikulum

**Secrets** adalah data sensitif seperti API key, password, token, dan kredensial. Modul ini membahas cara mengelola secrets dengan aman — **tidak hardcode di script**, **tidak di history**, dan **tidak di file yang tidak terproteksi**.

#### Konsep Kunci & Filosofi Mendalam

**Apa itu secrets?**
- API key (misalnya, `sk-1234567890`)
- Password database
- Token akses (misalnya, GitHub token)
- Kredensial cloud (AWS, GCP, Azure)
- SSH private key

**Mengapa secrets management penting?**
- **Kebocoran data:** Jika secrets bocor, penyerang dapat mengakses sistem Anda.
- **Kerugian finansial:** API key yang bocor bisa digunakan untuk menagih Anda.
- **Reputasi:** Kebocoran secrets dapat merusak reputasi.

**Filosofi:** **"Secrets tidak boleh ada di kode."** Secrets harus disimpan di **secure store** dan diakses melalui environment variable atau secret manager.

**Trade-off:**
- **Environment variable:** Mudah, tetapi bisa bocor melalui `ps`, `/proc`, atau log.
- **File:** Bisa di-proteksi dengan permission, tetapi bisa bocor jika file tidak aman.
- **Secret manager:** Paling aman, tetapi memerlukan setup tambahan.

#### Sintaks Dasar / Contoh Implementasi Inti

**❌ JANGAN: Hardcode secrets di script:**

```bash
# ❌ JANGAN: hardcode API key
API_KEY="sk-1234567890"
curl -H "Authorization: Bearer $API_KEY" https://api.example.com
```

**Penjelasan kata demi kata:**
- `API_KEY="sk-1234567890"`: Hardcode API key di script. Ini **sangat berbahaya** karena:
  - Script bisa dibaca oleh siapa saja.
  - API key bisa bocor melalui version control.
  - API key bisa bocor melalui log.

**✅ GUNAKAN: Environment variable dari secure store:**

```bash
# ✅ GUNAKAN: environment variable
export API_KEY="$(op read 'op://vault/api-key')"
curl -H "Authorization: Bearer $API_KEY" https://api.example.com
```

**Penjelasan kata demi kata:**
- `op read 'op://vault/api-key'`: Membaca secret dari 1Password.
- `export API_KEY="$(...)"`: Menyimpan secret di environment variable.
- `curl -H "Authorization: Bearer $API_KEY"`: Menggunakan secret.

**✅ GUNAKAN: File dengan permission yang ketat:**

```bash
# ✅ GUNAKAN: file dengan permission 600
# ~/.secrets
API_KEY="sk-1234567890"

# Di .zshrc
if [[ -f ~/.secrets ]]; then
    source ~/.secrets
fi

# Set permission
chmod 600 ~/.secrets
```

**Penjelasan kata demi kata:**
- `chmod 600 ~/.secrets`: Set permission sehingga hanya owner yang bisa membaca dan menulis.
  - `6`: Owner: read + write.
  - `0`: Group: tidak ada akses.
  - `0`: Other: tidak ada akses.

**✅ GUNAKAN: Secret manager:**

```bash
# 1Password CLI
export API_KEY="$(op read 'op://vault/api-key')"

# HashiCorp Vault
export API_KEY="$(vault kv get -field=api_key secret/api)"

# AWS Secrets Manager
export API_KEY="$(aws secretsmanager get-secret-value \
    --secret-id api-key \
    --query SecretString \
    --output text)"
```

**Penjelasan kata demi kata:**
- `op read`: 1Password CLI.
- `vault kv get`: HashiCorp Vault CLI.
- `aws secretsmanager get-secret-value`: AWS CLI.

**Mencegah secrets di history:**

```bash
# ❌ JANGAN: secrets di command line
# mysql -u root -p"password123"

# ✅ GUNAKAN: prompt atau environment variable
read -s "DB_PASSWORD?Password: "
mysql -u root -p"$DB_PASSWORD"

# Atau gunakan .my.cnf dengan permission 600
```

**Penjelasan kata demi kata:**
- `read -s "DB_PASSWORD?Password: "`: `read` dengan `-s` (silent) — tidak menampilkan input.
- `DB_PASSWORD?Password: `: Prompt yang ditampilkan.
- `mysql -u root -p"$DB_PASSWORD"`: Menggunakan variabel.

**Redaksi history:**

```bash
# Jangan simpan perintah yang mengandung secrets di history
setopt HIST_IGNORE_SPACE
# Perintah yang dimulai dengan spasi tidak akan disimpan

# Atau gunakan prefix
 export API_KEY="secret"  # Spasi di awal
```

**Penjelasan kata demi kata:**
- `setopt HIST_IGNORE_SPACE`: Mengaktifkan opsi untuk mengabaikan perintah yang dimulai dengan spasi.
- ` export API_KEY="secret"`: Spasi di awal menyebabkan perintah tidak disimpan.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **Secrets** | Data sensitif seperti API key, password, token. |
| **Secret Manager** | Layanan untuk menyimpan dan mengakses secrets. |
| **Environment Variable** | Variabel yang tersedia untuk proses. |
| **`chmod 600`** | Permission: owner read+write, group/other none. |
| **`HIST_IGNORE_SPACE`** | Opsi Zsh untuk mengabaikan perintah dengan spasi di awal. |
| **`read -s`** | Membaca input tanpa menampilkan. |

#### Rekomendasi Visualisasi

> **Diagram alur secrets management** akan sangat membantu: Menampilkan bagaimana secret dibaca dari secure store, digunakan, dan tidak bocor.

#### Sumber Referensi

- 1Password CLI: https://developer.1password.com/docs/cli/
- HashiCorp Vault: https://www.vaultproject.io/
- AWS Secrets Manager: https://aws.amazon.com/secrets-manager/
- Zsh Options: https://zsh.sourceforge.io/Doc/Release/Options.html

#### Tips dan Praktik Terbaik

1. **Jangan pernah hardcode secrets di script.**
2. **Gunakan secret manager** untuk secrets yang sensitif.
3. **Set permission 600 untuk file secrets.**
4. **Gunakan `HIST_IGNORE_SPACE` untuk mencegah secrets di history.**
5. **Gunakan `read -s` untuk input password.**
6. **Rotasi secrets secara berkala.**

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Hardcode secrets | Gunakan secret manager |
| Secrets di history | Gunakan `HIST_IGNORE_SPACE` atau prefix spasi |
| File secrets permission 644 | `chmod 600` |
| Secrets di log | Jangan echo secrets |

---

### Permission File Konfigurasi

#### Deskripsi Konkret & Peran dalam Kurikulum

**Permission file** adalah **lapisan pertahanan pertama** untuk konfigurasi shell. Jika file konfigurasi dapat dimodifikasi oleh user lain, penyerang dapat menambahkan kode berbahaya. Modul ini membahas permission yang benar untuk file konfigurasi.

#### Konsep Kunci & Filosofi Mendalam

**Apa itu permission?**
Permission menentukan siapa yang dapat membaca, menulis, dan mengeksekusi file. Ada tiga level:
1. **Owner:** Pemilik file.
2. **Group:** Grup yang memiliki file.
3. **Other:** Semua user lain.

**Permission yang direkomendasikan:**

| File/Direktori | Permission | Alasan |
|----------------|------------|--------|
| `~/.zshrc` | `600` | Hanya owner yang bisa baca/tulis |
| `~/.zshenv` | `600` | Sama |
| `~/.zsh/` | `700` | Hanya owner yang bisa akses |
| `~/.ssh/` | `700` | SSH memerlukan ini |
| `~/.ssh/id_rsa` | `600` | Private key harus dilindungi |
| `~/.secrets` | `600` | Secrets harus dilindungi |

**Filosofi:** **"Jika tidak perlu diakses oleh orang lain, jangan beri akses."** Ini adalah prinsip Least Privilege.

#### Sintaks Dasar / Contoh Implementasi Inti

**Melihat permission:**

```bash
# Melihat permission file
ls -la ~/.zshrc
# Output: -rw------- 1 user user 1234 Jan 1 00:00 .zshrc

# Menggunakan stat
stat -c '%a %n' ~/.zshrc
# Output: 600 /home/user/.zshrc
```

**Penjelasan kata demi kata:**
- `ls -la`: List file dengan detail (`-l`) dan semua file (`-a`).
- `-rw-------`: Permission — owner read+write (`rw-`), group none (`---`), other none (`---`).
- `stat -c '%a %n'`: Format output — `%a` adalah permission oktal, `%n` adalah nama file.

**Mengubah permission:**

```bash
# Set permission 600 untuk .zshrc
chmod 600 ~/.zshrc

# Set permission 700 untuk direktori .zsh
chmod 700 ~/.zsh

# Set permission 600 untuk file secrets
chmod 600 ~/.secrets
```

**Penjelasan kata demi kata:**
- `chmod 600`: Mengubah permission menjadi `600`.
  - `6`: Owner — read (4) + write (2) = 6.
  - `0`: Group — tidak ada akses.
  - `0`: Other — tidak ada akses.
- `chmod 700`: Owner — read (4) + write (2) + execute (1) = 7.

**Memeriksa permission secara otomatis:**

```bash
# Fungsi untuk memeriksa permission
check_permissions() {
    local file="$1"
    local expected_perms="$2"
    
    if [[ ! -e "$file" ]]; then
        echo "File tidak ada: $file" >&2
        return 1
    fi
    
    local actual_perms=$(stat -c '%a' "$file" 2>/dev/null || stat -f '%Lp' "$file" 2>/dev/null)
    
    if [[ "$actual_perms" != "$expected_perms" ]]; then
        echo "Warning: Permission $file adalah $actual_perms, seharusnya $expected_perms" >&2
        return 1
    fi
    
    return 0
}

# Gunakan
check_permissions ~/.zshrc 600
check_permissions ~/.ssh 700
check_permissions ~/.ssh/id_rsa 600
```

**Penjelasan kata demi kata:**
- `[[ ! -e "$file" ]]`: Test apakah file tidak ada.
- `stat -c '%a' "$file"`: Mendapatkan permission (Linux).
- `stat -f '%Lp' "$file"`: Mendapatkan permission (macOS).
- `[[ "$actual_perms" != "$expected_perms" ]]`: Membandingkan permission.

**Audit permission di `.zshrc`:**

```bash
# Audit permission file konfigurasi
audit_config_permissions() {
    local files=(
        ~/.zshrc:600
        ~/.zshenv:600
        ~/.zsh:700
        ~/.ssh:700
        ~/.ssh/id_rsa:600
        ~/.secrets:600
    )
    
    for entry in "${files[@]}"; do
        local file="${entry%%:*}"
        local perms="${entry##*:}"
        check_permissions "$file" "$perms"
    done
}
```

**Penjelasan kata demi kata:**
- `local files=(...)`: Array dengan format `file:permission`.
- `for entry in "${files[@]}"; do ... done`: Loop setiap entry.
- `"${entry%%:*}"`: Mengambil bagian sebelum `:` (nama file).
- `"${entry##*:}"`: Mengambil bagian setelah `:` (permission).

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **Permission** | Hak akses file (read, write, execute). |
| **Owner** | Pemilik file. |
| **Group** | Grup yang memiliki file. |
| **Other** | Semua user lain. |
| **`chmod`** | Perintah untuk mengubah permission. |
| **`stat`** | Perintah untuk melihat metadata file. |
| **`600`** | Permission: owner read+write, group/other none. |
| **`700`** | Permission: owner read+write+execute, group/other none. |

#### Rekomendasi Visualisasi

> **Diagram permission** akan sangat membantu: Menampilkan bagaimana permission direpresentasikan dalam oktal dan simbolik.

#### Sumber Referensi

- `chmod`: https://man7.org/linux/man-pages/man1/chmod.1.html
- `stat`: https://man7.org/linux/man-pages/man1/stat.1.html
- File Permissions: https://wiki.archlinux.org/title/File_permissions_and_attributes

#### Tips dan Praktik Terbaik

1. **Set permission 600 untuk file konfigurasi.**
2. **Set permission 700 untuk direktori konfigurasi.**
3. **Audit permission secara berkala.**
4. **Jangan gunakan permission 777.**
5. **Gunakan `umask` untuk set default permission.**

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Permission 644 untuk `.zshrc` | `chmod 600 ~/.zshrc` |
| Permission 755 untuk `~/.ssh` | `chmod 700 ~/.ssh` |
| Tidak memeriksa permission | Gunakan `check_permissions` |
| Permission 777 | Jangan pernah gunakan 777 |

---

### Audit Script dengan ShellCheck

#### Deskripsi Konkret & Peran dalam Kurikulum

**ShellCheck** adalah **alat analisis statis** untuk script shell. Ia mendeteksi bug, kesalahan quoting, code injection, dan masalah portabilitas. Modul ini membahas cara menggunakan ShellCheck untuk mengaudit script Zsh.

#### Konsep Kunci & Filosofi Mendalam

**Apa itu ShellCheck?**
ShellCheck adalah **linter** — alat yang menganalisis kode tanpa menjalankannya. Ia memeriksa:
- **Quoting:** Variabel yang tidak di-quote.
- **Word splitting:** String yang mengandung spasi.
- **Code injection:** Penggunaan `eval` yang berbahaya.
- **Portabilitas:** Perbedaan antara shell.
- **Praktik terbaik:** Penggunaan `$@` vs `$*`, dll.

**Filosofi:** **"Lebih baik menemukan bug sebelum menjalankan script."** ShellCheck adalah **reviewer otomatis** yang memeriksa script Anda.

**Mengapa ShellCheck penting?**
- **Mencegah bug:** Menemukan masalah sebelum menyebabkan kerusakan.
- **Meningkatkan keamanan:** Mendeteksi code injection.
- **Mendidik:** Setiap peringatan disertai penjelasan.

#### Sintaks Dasar / Contoh Implementasi Inti

**Instalasi ShellCheck:**

```bash
# macOS
brew install shellcheck

# Linux (Debian/Ubuntu)
sudo apt install shellcheck

# Linux (Arch)
sudo pacman -S shellcheck

# Windows (dengan Scoop)
scoop install shellcheck
```

**Menjalankan ShellCheck:**

```bash
# Audit script
shellcheck script.sh

# Audit .zshrc
shellcheck ~/.zshrc

# Audit dengan shell spesifik
shellcheck --shell=zsh ~/.zshrc
```

**Penjelasan kata demi kata:**
- `shellcheck`: Perintah untuk menjalankan ShellCheck.
- `--shell=zsh`: Menentukan shell yang digunakan.

**Contoh peringatan ShellCheck:**

```bash
# ❌ Kode dengan masalah
filename="my file.txt"
ls $filename
```

**Output ShellCheck:**

```bash
In script.sh line 2:
ls $filename
   ^-- SC2086 (info): Double quote to prevent globbing and word splitting.
```

**Penjelasan:**
- `SC2086`: Kode peringatan.
- `Double quote to prevent globbing and word splitting`: Penjelasan dan solusi.

**Memperbaiki kode:**

```bash
# ✅ Kode yang diperbaiki
filename="my file.txt"
ls "$filename"
```

**ShellCheck untuk Zsh:**

```bash
# ShellCheck secara default untuk sh/bash
# Untuk Zsh, gunakan direktif
#!/bin/zsh
# shellcheck shell=zsh

# Atau jalankan dengan flag
shellcheck --shell=zsh ~/.zshrc
```

**Penjelasan kata demi kata:**
- `# shellcheck shell=zsh`: Direktif untuk ShellCheck.
- `--shell=zsh`: Flag untuk menentukan shell.

**Mengabaikan peringatan tertentu:**

```bash
# Mengabaikan peringatan SC2086
# shellcheck disable=SC2086
ls $filename
```

**Penjelasan kata demi kata:**
- `# shellcheck disable=SC2086`: Direktif untuk mengabaikan peringatan SC2086.

**Integrasi dengan editor:**

```bash
# VS Code: Install extension "ShellCheck"
# Vim: Install ALE atau Syntastic
# Emacs: Install flycheck
```

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **ShellCheck** | Alat analisis statis untuk script shell. |
| **Linter** | Alat yang menganalisis kode tanpa menjalankannya. |
| **Static Analysis** | Analisis kode tanpa eksekusi. |
| **SC2086** | Kode peringatan untuk quoting. |
| **Direktif** | Komentar khusus untuk mengonfigurasi ShellCheck. |

#### Rekomendasi Visualisasi

> **Tangkapan layar ShellCheck** akan sangat membantu: Menampilkan peringatan dan penjelasan.

#### Sumber Referensi

- ShellCheck: https://www.shellcheck.net/
- ShellCheck Wiki: https://www.shellcheck.net/wiki/
- ShellCheck GitHub: https://github.com/koalaman/shellcheck

#### Tips dan Praktik Terbaik

1. **Jalankan ShellCheck pada setiap script.**
2. **Perbaiki semua peringatan.**
3. **Gunakan direktif untuk mengabaikan peringatan yang tidak relevan.**
4. **Integrasikan dengan editor.**
5. **Gunakan `--shell=zsh` untuk script Zsh.**

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Mengabaikan peringatan | Perbaiki semua peringatan |
| Tidak menggunakan `--shell=zsh` | Gunakan flag atau direktif |
| Tidak memahami peringatan | Baca penjelasan di ShellCheck Wiki |

---

### Teknik Lanjutan: Sandboxing, Redaction, dan Audit Trail

#### Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas **teknik keamanan lanjutan** yang melampaui dasar-dasar: sandboxing, redaction, dan audit trail. Ini adalah **teknik untuk pengguna mahir** yang ingin keamanan maksimal.

#### Konsep Kunci & Filosofi Mendalam

**Sandboxing:** Menjalankan script dalam **lingkungan terisolasi** sehingga tidak dapat merusak sistem.
- **`bwrap` (bubblewrap):** Sandbox ringan untuk Linux.
- **`firejail`:** Sandbox dengan profil keamanan.
- **`docker`:** Container untuk isolasi.

**Redaction:** Menghapus **informasi sensitif** dari output atau log.
- **`zsh-redact-history`:** Plugin untuk meredaksi history.
- **Manual redaction:** Mengganti secrets dengan `***`.

**Audit Trail:** Mencatat **semua perintah** yang dijalankan untuk audit.
- **`script`:** Merekam sesi terminal.
- **`auditd`:** Audit sistem Linux.
- **Custom logging:** Mencatat perintah ke file.

#### Sintaks Dasar / Contoh Implementasi Inti

**Sandboxing dengan `bwrap`:**

```bash
# Menjalankan script dalam sandbox
bwrap --ro-bind / / \
      --dev /dev \
      --proc /proc \
      --tmpfs /tmp \
      zsh script.sh
```

**Penjelasan kata demi kata:**
- `bwrap`: Bubblewrap — sandbox ringan.
- `--ro-bind / /`: Bind mount root filesystem sebagai read-only.
- `--dev /dev`: Mount `/dev`.
- `--proc /proc`: Mount `/proc`.
- `--tmpfs /tmp`: Mount `/tmp` sebagai tmpfs (temporary).
- `zsh script.sh`: Perintah yang dijalankan dalam sandbox.

**Redaction dengan `zsh-redact-history`:**

```bash
# Install zsh-redact-history
git clone https://github.com/severeon/zsh-redact-history.git ~/.zsh/zsh-redact-history
source ~/.zsh/zsh-redact-history/zsh-redact-history.plugin.zsh

# Konfigurasi pola redaction
ZSH_REDACT_HISTORY_PATTERNS=(
    'password=*'
    'token=*'
    'api_key=*'
    'secret=*'
)
```

**Penjelasan kata demi kata:**
- `git clone`: Clone repository.
- `source`: Memuat plugin.
- `ZSH_REDACT_HISTORY_PATTERNS`: Array pattern yang akan diredaksi.

**Audit trail dengan `script`:**

```bash
# Merekam sesi terminal
script -t timing.log session.log

# Merekam dengan timestamp
script -t 2>timing.log session.log
```

**Penjelasan kata demi kata:**
- `script`: Perintah untuk merekam sesi terminal.
- `-t timing.log`: Menyimpan timing ke file.
- `session.log`: File output.

**Custom audit logging:**

```bash
# Log semua perintah ke file
audit_log() {
    local log_file="$HOME/.zsh_audit.log"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local user="$USER"
    local pwd="$PWD"
    local cmd="$1"
    
    # Redact secrets
    cmd=$(echo "$cmd" | sed -E 's/(password|token|api_key|secret)=[^ ]*/\1=***/g')
    
    echo "[$timestamp] [$user] [$pwd] $cmd" >> "$log_file"
}

# Hook ke preexec
preexec() {
    audit_log "$1"
}
```

**Penjelasan kata demi kata:**
- `audit_log()`: Fungsi untuk mencatat perintah.
- `date '+%Y-%m-%d %H:%M:%S'`: Mendapatkan timestamp.
- `sed -E 's/(password|token|api_key|secret)=[^ ]*/\1=***/g'`: Mengganti secrets dengan `***`.
- `echo "[$timestamp] ..." >> "$log_file"`: Menulis ke log.
- `preexec() { audit_log "$1" }`: Hook ke `preexec`.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **Sandboxing** | Menjalankan script dalam lingkungan terisolasi. |
| **`bwrap`** | Bubblewrap — sandbox ringan. |
| **Redaction** | Menghapus informasi sensitif. |
| **Audit Trail** | Catatan semua perintah yang dijalankan. |
| **`script`** | Perintah untuk merekam sesi terminal. |
| **`preexec`** | Hook sebelum perintah dieksekusi. |

#### Rekomendasi Visualisasi

> **Diagram alur sandboxing** akan sangat membantu: Menampilkan bagaimana script diisolasi.

> **Diagram alur audit trail** akan membantu: Menampilkan bagaimana perintah dicatat.

#### Sumber Referensi

- Bubblewrap: https://github.com/containers/bubblewrap
- Firejail: https://firejail.wordpress.com/
- `zsh-redact-history`: https://github.com/severeon/zsh-redact-history
- `script`: https://man7.org/linux/man-pages/man1/script.1.html

#### Tips dan Praktik Terbaik

1. **Gunakan sandbox untuk script yang tidak terpercaya.**
2. **Redaksi secrets dari history dan log.**
3. **Aktifkan audit trail untuk keamanan.**
4. **Rotasi log secara berkala.**

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Tidak menggunakan sandbox | Gunakan `bwrap` untuk script tidak terpercaya |
| Secrets di log | Gunakan redaction |
| Tidak ada audit trail | Aktifkan logging |

---

### Studi Kasus: Audit Keamanan `.zshrc` Lengkap

#### Deskripsi Konkret & Peran dalam Kurikulum

Modul ini adalah **studi kasus lengkap** — mengaudit `.zshrc` untuk keamanan. Ini adalah **contoh nyata** yang menggabungkan semua teknik yang telah dipelajari.

#### Konsep Kunci & Filosofi Mendalam

**Skenario:** Seorang developer memiliki `.zshrc` yang berisi:
- Plugin dari internet.
- Secrets hardcode.
- `eval` dengan input pengguna.
- Permission file yang salah.

**Tujuan:** Mengaudit dan memperbaiki masalah keamanan.

**Langkah-langkah:**
1. **Audit permission:** Periksa permission file.
2. **Audit secrets:** Cari secrets hardcode.
3. **Audit `eval`:** Cari penggunaan `eval`.
4. **Audit quoting:** Cari variabel tanpa quotes.
5. **Audit plugin:** Verifikasi plugin.
6. **Audit logging:** Periksa apakah secrets bocor ke log.

#### Sintaks Dasar / Contoh Implementasi Inti

**Sebelum audit:**

```bash
# .zshrc (sebelum)
# ❌ Secrets hardcode
export API_KEY="sk-1234567890"
export DB_PASSWORD="password123"

# ❌ eval dengan input pengguna
user_input="hello; rm -rf /"
eval "echo $user_input"

# ❌ Variabel tanpa quotes
filename="my file.txt"
ls $filename

# ❌ Plugin dari sumber tidak terpercaya
source /tmp/plugin.zsh
```

**Setelah audit:**

```bash
# .zshrc (sesudah)
#!/bin/zsh
set -euo pipefail

# ✅ Secrets dari secure store
if [[ -f ~/.secrets ]]; then
    source ~/.secrets
fi

# ✅ Hindari eval
user_input="hello"
printf '%s\n' "$user_input"

# ✅ Quoting yang benar
filename="my file.txt"
ls "$filename"

# ✅ Verifikasi plugin
if [[ -f ~/.zsh/plugins/plugin.zsh ]]; then
    if [[ -O ~/.zsh/plugins/plugin.zsh ]]; then
        source ~/.zsh/plugins/plugin.zsh
    fi
fi

# ✅ Set permission
chmod 600 ~/.zshrc
chmod 600 ~/.secrets
```

**Script audit otomatis:**

```bash
#!/bin/zsh
# audit_zshrc.sh

audit_zshrc() {
    local file="${1:-$HOME/.zshrc}"
    local issues=0
    
    echo "=== Audit Keamanan: $file ==="
    
    # 1. Periksa permission
    local perms=$(stat -c '%a' "$file" 2>/dev/null || stat -f '%Lp' "$file" 2>/dev/null)
    if [[ "$perms" != "600" ]]; then
        echo "❌ Permission: $perms (seharusnya 600)"
        ((issues++))
    else
        echo "✅ Permission: $perms"
    fi
    
    # 2. Periksa secrets hardcode
    if grep -qE '(password|token|api_key|secret)=["\x27]?[^"\x27]+' "$file"; then
        echo "❌ Secrets hardcode ditemukan"
        ((issues++))
    else
        echo "✅ Tidak ada secrets hardcode"
    fi
    
    # 3. Periksa eval
    if grep -q 'eval' "$file"; then
        echo "❌ Penggunaan eval ditemukan"
        ((issues++))
    else
        echo "✅ Tidak ada eval"
    fi
    
    # 4. Periksa quoting
    if grep -qE '\$[a-zA-Z_][a-zA-Z0-9_]*[^"'"'"']' "$file"; then
        echo "⚠️  Variabel tanpa quotes ditemukan"
        ((issues++))
    else
        echo "✅ Quoting benar"
    fi
    
    echo "=== Total issues: $issues ==="
    return $issues
}

audit_zshrc "$@"
```

**Penjelasan kata demi kata:**
- `grep -qE`: Grep dengan quiet mode (`-q`) dan extended regex (`-E`).
- `(password|token|api_key|secret)=["\x27]?[^"\x27]+`: Pattern untuk mendeteksi secrets.
- `grep -q 'eval'`: Mencari penggunaan `eval`.
- `grep -qE '\$[a-zA-Z_][a-zA-Z0-9_]*[^"'"'"']'`: Mencari variabel tanpa quotes.

#### Terminologi Esensial & Penjelasan Detil

| Istilah | Definisi |
|---------|----------|
| **Audit Keamanan** | Memeriksa script untuk masalah keamanan. |
| **Secrets Hardcode** | Secrets yang ditulis langsung di script. |
| **`grep`** | Perintah untuk mencari pattern. |
| **`-q`** | Quiet mode — tidak menampilkan output. |
| **`-E`** | Extended regex. |

#### Rekomendasi Visualisasi

> **Diagram alur audit** akan sangat membantu: Menampilkan langkah-langkah audit.

#### Sumber Referensi

- ShellCheck: https://www.shellcheck.net/
- Zsh Security: https://hoop.dev/blog/zsh-compliance-requirements
- OWASP: https://owasp.org/

#### Tips dan Praktik Terbaik

1. **Audit `.zshrc` secara berkala.**
2. **Gunakan script audit otomatis.**
3. **Perbaiki semua issues.**
4. **Jalankan ShellCheck setelah audit.**

#### Potensi Kesalahan Umum & Solusi

| Kesalahan | Solusi |
|-----------|--------|
| Tidak pernah audit | Audit secara berkala |
| Mengabaikan issues | Perbaiki semua issues |
| Tidak menggunakan tools | Gunakan ShellCheck dan script audit |

---

### Terminologi Esensial Modul 4.4

| Istilah | Definisi | Contoh |
|---------|----------|--------|
| **Code Injection** | Serangan di mana input pengguna dieksekusi sebagai kode | `eval "echo $user_input"` |
| **`eval`** | Perintah yang mengeksekusi string sebagai kode | `eval "$cmd"` |
| **Quoting** | Memberi tahu shell untuk memperlakukan karakter sebagai literal | `"$var"` |
| **Word Splitting** | Pemecahan string menjadi kata-kata | `$var` tanpa quotes |
| **Globbing** | Ekspansi pattern glob | `*.txt` |
| **`source`** | Mengeksekusi file dalam konteks shell saat ini | `source ~/.zshrc` |
| **Ownership Check** | Memeriksa apakah file milik user saat ini | `[[ -O "$file" ]]` |
| **Permission** | Hak akses file | `chmod 600` |
| **Secrets** | Data sensitif | API key, password |
| **Secret Manager** | Layanan untuk menyimpan secrets | 1Password, Vault |
| **`HIST_IGNORE_SPACE`** | Opsi untuk mengabaikan perintah dengan spasi di awal | `setopt HIST_IGNORE_SPACE` |
| **ShellCheck** | Alat analisis statis | `shellcheck script.sh` |
| **Sandboxing** | Menjalankan script dalam isolasi | `bwrap` |
| **Redaction** | Menghapus informasi sensitif | `sed 's/password=.*/password=***/'` |
| **Audit Trail** | Catatan semua perintah | `script -t timing.log session.log` |

---

### Rekomendasi Visualisasi Modul 4.4

1. **Diagram model ancaman:** Menampilkan aset, ancaman, dan pertahanan.

2. **Diagram alur code injection:** Menampilkan bagaimana input pengguna masuk ke `eval`.

3. **Diagram perbandingan quoting:** Menampilkan single quotes, double quotes, tanpa quotes.

4. **Diagram alur `safe_source`:** Menampilkan pemeriksaan sebelum source.

5. **Diagram alur secrets management:** Menampilkan secure store → environment → penggunaan.

6. **Diagram permission:** Menampilkan oktal dan simbolik.

7. **Tangkapan layar ShellCheck:** Menampilkan peringatan dan penjelasan.

8. **Diagram alur sandboxing:** Menampilkan isolasi script.

9. **Diagram alur audit trail:** Menampilkan pencatatan perintah.

---

### Hubungan dengan Modul Lain

| Modul | Hubungan |
|-------|----------|
| **Modul 4.1 (Plugin Manager)** | Keamanan plugin dan verifikasi. |
| **Modul 4.2 (Prompt Kustomisasi)** | Prompt yang menampilkan secrets harus dihindari. |
| **Modul 4.3 (Optimasi Performa)** | `compinit -C` dan trade-off keamanan. |

---

### Sumber Referensi Lengkap Modul 4.4

1. **Zsh Security:** https://hoop.dev/blog/zsh-compliance-requirements
2. **ShellCheck:** https://www.shellcheck.net/
3. **ShellCheck Wiki:** https://www.shellcheck.net/wiki/
4. **Zsh Parameter Expansion:** https://zsh.sourceforge.io/Doc/Release/Expansion.html
5. **Zsh Conditional Expressions:** https://zsh.sourceforge.io/Doc/Release/Conditional-Expressions.html
6. **Zsh Options:** https://zsh.sourceforge.io/Doc/Release/Options.html
7. **1Password CLI:** https://developer.1password.com/docs/cli/
8. **HashiCorp Vault:** https://www.vaultproject.io/
9. **AWS Secrets Manager:** https://aws.amazon.com/secrets-manager/
10. **Bubblewrap:** https://github.com/containers/bubblewrap
11. **`zsh-redact-history`:** https://github.com/severeon/zsh-redact-history
12. **OWASP Command Injection:** https://owasp.org/www-community/attacks/Command_Injection
13. **File Permissions:** https://wiki.archlinux.org/title/File_permissions_and_attributes
14. **`chmod`:** https://man7.org/linux/man-pages/man1/chmod.1.html
15. **Bash Strict Mode:** http://redsymbol.net/articles/unofficial-bash-strict-mode/

---

### Tips dan Praktik Terbaik Modul 4.4

1. **Selalu gunakan `set -euo pipefail`.**
2. **Hindari `eval` sama sekali.**
3. **Selalu quote variabel.**
4. **Verifikasi file sebelum `source`.**
5. **Jangan hardcode secrets.**
6. **Set permission 600 untuk file konfigurasi.**
7. **Gunakan ShellCheck.**
8. **Audit `.zshrc` secara berkala.**
9. **Redaksi secrets dari history dan log.**
10. **Gunakan sandbox untuk script tidak terpercaya.**

---

### Potensi Kesalahan Umum dan Solusi Modul 4.4

| Kesalahan | Penyebab | Solusi |
|-----------|----------|--------|
| Code injection | `eval` dengan input pengguna | Hindari `eval`; gunakan array |
| Secrets bocor | Hardcode di script | Gunakan secret manager |
| File konfigurasi dimodifikasi | Permission 644 | `chmod 600` |
| Plugin berbahaya | Source dari sumber tidak terpercaya | Verifikasi checksum |
| ShellCheck tidak digunakan | Tidak tahu | Install dan gunakan |
| Log berisi secrets | Tidak redaksi | Gunakan redaction |
| Audit trail tidak ada | Tidak diaktifkan | Aktifkan logging |
| Sandbox tidak digunakan | Tidak tahu | Gunakan `bwrap` |


---

# ✅ Selamat! anda telah menyelesaikan

Materi **Modul 4.4: Keamanan Scripting Zsh** secara komprehensif, mencakup:

- ✅ Prasyarat fundamental: memahami model ancaman shell
- ✅ Bahaya `eval` dan code injection
- ✅ Quoting yang benar untuk keamanan
- ✅ Mengamankan `source` dan plugin
- ✅ Manajemen secrets: environment vs file
- ✅ Permission file konfigurasi
- ✅ Audit script dengan ShellCheck
- ✅ Teknik lanjutan: sandboxing, redaction, audit trail
- ✅ Studi kasus: audit keamanan `.zshrc` lengkap
- ✅ Terminologi, visualisasi, referensi, tips, dan kesalahan umum

---

# Selamat!

**Fase 4: Ekosistem, Performa, dan Keamanan telah selesai seluruhnya** (Modul 4.1, 4.2, 4.3, 4.4).

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

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

