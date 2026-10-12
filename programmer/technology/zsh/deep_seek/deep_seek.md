# Kurikulum Pembelajaran Zsh & Shell Scripting: Dari Pemula hingga Expert

---

## Ringkasan Kurikulum

Kurikulum ini dirancang untuk membawa pembelajar dari nol hingga tingkat expert dalam menggunakan dan memprogram **Zsh (Z Shell)** — shell yang kini menjadi default di macOS dan semakin populer di komunitas Linux. Zsh bukan sekadar "Bash yang lebih baik"; ia adalah bahasa scripting yang kaya dengan fitur unik seperti array 1-indexed, globbing qualifier, sistem completion yang dapat diprogram, dan arsitektur plugin yang matang.

**Total estimasi waktu:** 6–9 bulan (belajar santai) atau 3–4 bulan (intensif, 10–15 jam/minggu)

| Fase | Level | Durasi | Fokus Utama |
|------|-------|--------|-------------|
| 1 | Pemula | 2–3 minggu | Fondasi shell, navigasi, variabel |
| 2 | Pemula–Menengah | 3–4 minggu | Kontrol alur, fungsi, scripting dasar |
| 3 | Menengah | 4–5 minggu | Globbing lanjutan, completion, konfigurasi |
| 4 | Menengah–Mahir | 4–6 minggu | Plugin, prompt, performa, keamanan |
| 5 | Mahir | 6–8 minggu | Scripting lanjutan, testing, integrasi |
| 6 | Expert | 8–12 minggu | Arsitektur enterprise, kontribusi, spesialisasi |

---

## Prasyarat Umum

- **Tidak ada prasyarat pemrograman.** Kurikulum ini dirancang agar dapat diikuti oleh non-IT sekalipun.
- **Akses ke sistem operasi:** Linux, macOS, atau Windows dengan WSL (Windows Subsystem for Linux).
- **Kemampuan dasar menggunakan keyboard dan terminal** (mengetik perintah sederhana).
- **Rasa ingin tahu dan kesabaran** — shell adalah alat yang powerful namun membutuhkan latihan.

## Alat Esensial

| Alat | Fungsi | Cara Mendapatkan |
|------|--------|------------------|
| **Zsh** | Shell utama | `sudo apt install zsh` (Debian/Ubuntu), `brew install zsh` (macOS) |
| **Terminal Emulator** | Antarmuka ke shell | GNOME Terminal, iTerm2, Windows Terminal, Alacritty |
| **Editor Teks** | Menulis script | VS Code, Neovim, atau editor apa pun |
| **Git** | Version control | `sudo apt install git` |
| **Oh My Zsh** | Framework plugin | `sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"` |
| **ShellCheck** | Linter script | `sudo apt install shellcheck` |

---

# [FASE 1: FONDASI — MENGENAL SHELL DAN ZSH]
**Level:** Pemula | **Durasi:** 2–3 minggu | **Jam:** ~15–20 jam

### Modul 1.1: Apa Itu Shell dan Mengapa Zsh?

**Deskripsi Konkret:**
Memahami peran shell sebagai jembatan antara pengguna dan sistem operasi. Membedakan antara kernel, shell, dan terminal emulator. Mengapa Zsh hadir sebagai evolusi dari sh, bash, dan ksh.

**Konsep Dasar dan Filosofi:**
Shell adalah program yang membaca perintah dari input (keyboard) dan meneruskannya ke kernel untuk dieksekusi. Filosofi Unix — "lakukan satu hal dengan baik dan gabungkan dengan alat lain" — tercermin dalam cara shell bekerja: setiap perintah adalah program kecil yang dapat digabungkan melalui pipe (`|`) dan redirection. Zsh hadir dengan filosofi "shell untuk manusia": tab completion yang benar-benar berfungsi, koreksi ejaan otomatis, dan array yang diindeks dari 1 (karena manusia menghitung dari 1).

**Sintaks Dasar:**
```bash
# Cek shell yang sedang digunakan
echo $SHELL
echo $0

# Melihat daftar shell yang tersedia
cat /etc/shells

# Mengganti shell default ke Zsh
chsh -s $(which zsh)
```

**Terminologi Kunci:**
- **Shell**: Program yang menerjemahkan perintah pengguna menjadi instruksi sistem operasi.
- **Kernel**: Inti sistem operasi yang mengelola resource perangkat keras.
- **Terminal Emulator**: Aplikasi grafis yang menampilkan output shell dan menerima input.
- **POSIX**: Standar portabilitas sistem operasi; Bash dan Zsh memiliki tingkat kepatuhan yang berbeda.
- **Prompt**: Teks yang ditampilkan shell sebelum menerima input (misalnya `$` atau `%`).

**Daftar Isi:**
1. Arsitektur sistem: kernel, shell, terminal
2. Sejarah shell: sh → bash → zsh → fish
3. Perbedaan Zsh vs Bash: array, globbing, completion
4. Instalasi Zsh di berbagai platform
5. Mengganti shell default dengan aman

**Sumber Referensi:**
- Dokumentasi resmi Zsh: https://zsh.sourceforge.io/Doc/
- Zsh FAQ (perbandingan dengan shell lain): https://zsh.sourceforge.io/FAQ/
- Roadmap Zsh untuk pemula: https://zsh.sourceforge.io/Guide/

**Visualisasi yang Direkomendasikan:**
> Diagram alur direkomendasikan di sini untuk menjelaskan alur interaksi: *Pengguna → Terminal Emulator → Shell (Zsh) → Kernel → Perangkat Keras*, dengan panah bolak-balik yang menunjukkan siklus input-proses-output.

---

### Modul 1.2: Navigasi Sistem File dan Perintah Dasar

**Deskripsi Konkret:**
Menguasai navigasi direktori, manipulasi file, dan melihat konten. Ini adalah fondasi yang harus dikuasai sebelum menulis script apa pun.

**Konsep Dasar dan Filosofi:**
Sistem file Unix adalah pohon terbalik yang dimulai dari root (`/`). Setiap file dan direktori memiliki lokasi absolut dan relatif. Pemahaman ini penting karena script bekerja dengan path — dan path yang salah adalah penyebab bug paling umum.

**Sintaks Dasar:**
```bash
# Navigasi
pwd                    # Print Working Directory
cd /var/log            # Pindah ke direktori absolut
cd ~                   # Pindah ke home
cd -                   # Kembali ke direktori sebelumnya
ls -la                 # List semua file (termasuk hidden) dengan detail

# Manipulasi file
touch file.txt         # Membuat file kosong
mkdir -p proyek/src    # Membuat direktori bersarang
cp file.txt backup.txt # Copy
mv file.txt arsip/     # Move/rename
rm -i file.txt         # Hapus dengan konfirmasi

# Melihat konten
cat file.txt           # Tampilkan seluruh konten
less file.txt          # Tampilkan dengan navigasi
head -5 file.txt       # 5 baris pertama
tail -f log.txt        # Ikuti file yang terus diperbarui
```

**Terminologi Kunci:**
- **Path Absolut**: Lokasi lengkap dari root (`/home/user/dokumen`).
- **Path Relatif**: Lokasi dari direktori saat ini (`../dokumen`).
- **Home Directory**: Direktori pribadi pengguna (`~` atau `/home/username`).
- **Hidden File**: File yang dimulai dengan titik (`.`) dan tidak terlihat tanpa flag `-a`.
- **Wildcard/Glob**: Pola untuk mencocokkan nama file (`*.txt`).

**Daftar Isi:**
1. Struktur direktori Unix/Linux
2. Path absolut vs relatif
3. Perintah navigasi: `pwd`, `cd`, `ls`
4. Perintah manipulasi: `cp`, `mv`, `rm`, `mkdir`
5. Melihat konten: `cat`, `less`, `head`, `tail`
6. Pencarian file: `find`, `locate`, `which`

**Sumber Referensi:**
- Panduan navigasi command line: https://linuxcommand.org/
- Zsh manual — Command Line Editing: https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html

---

### Modul 1.3: Variabel, Quoting, dan Ekspansi

**Deskripsi Konkret:**
Memahami cara menyimpan nilai dalam variabel, mengapa quoting penting, dan bagaimana shell melakukan ekspansi terhadap karakter khusus.

**Konsep Dasar dan Filosofi:**
Shell adalah bahasa *untyped* — variabel tidak memiliki tipe data eksplisit. Semuanya adalah string sampai diproses lebih lanjut. Quoting adalah mekanisme untuk mengontrol kapan shell melakukan interpretasi terhadap karakter khusus. Perbedaan antara single quote (`'`), double quote (`"`), dan tanpa quote adalah salah satu sumber kebingungan terbesar bagi pemula.

**Sintaks Dasar:**
```bash
# Variabel
nama="Budi"
umur=25
echo "Nama: $nama, Umur: $umur"

# Quoting
echo 'Halo $nama'      # Output: Halo $nama (literal)
echo "Halo $nama"      # Output: Halo Budi (ekspansi)
echo "Total: $((2 + 3))"  # Output: Total: 5

# Command substitution
tanggal=$(date +%Y-%m-%d)
echo "Hari ini: $tanggal"

# Ekspansi parameter lanjutan
echo ${nama:0:2}       # Output: Bu (substring)
echo ${#nama}          # Output: 4 (panjang)

# Array (1-indexed di Zsh!)
buah=(apel jeruk mangga)
echo ${buah[1]}        # Output: apel
echo ${buah[@]}        # Output: apel jeruk mangga
echo ${#buah[@]}       # Output: 3
```

**Terminologi Kunci:**
- **Ekspansi**: Proses shell mengganti variabel, wildcard, atau perintah dengan nilai sebenarnya.
- **Quoting**: Mekanisme untuk mencegah ekspansi karakter khusus.
- **Single Quote**: Semua karakter literal, tidak ada ekspansi.
- **Double Quote**: Variabel dan command substitution tetap diekspansi.
- **Command Substitution**: Menjalankan perintah dan menggunakan outputnya sebagai nilai.
- **Array**: Kumpulan nilai yang diakses melalui indeks.

**Daftar Isi:**
1. Mendeklarasikan dan menggunakan variabel
2. Jenis quoting dan kapan menggunakannya
3. Command substitution: `$(...)` vs backtick
4. Ekspansi parameter: `${var:-default}`, `${#var}`
5. Array dasar (1-indexed Zsh)
6. Associative array (hash/map)

**Sumber Referensi:**
- Zsh Expansion and Substitution: https://zsh.sourceforge.io/Doc/Release/Expansion.html
- Bash/Zsh array comparison: https://zsh.sourceforge.io/FAQ/zshfaq02.html

**Visualisasi yang Direkomendasikan:**
> Diagram direkomendasikan di sini untuk menjelaskan *alur ekspansi shell*: Input → Tokenisasi → Ekspansi (parameter, command, arithmetic, glob) → Word Splitting → Eksekusi, dengan contoh konkret di setiap tahap.

---

# [FASE 2: SCRIPTING DASAR — DARI PERINTAH KE PROGRAM]
**Level:** Pemula–Menengah | **Durasi:** 3–4 minggu | **Jam:** ~25–30 jam

### Modul 2.1: Struktur Script dan Kontrol Alur

**Deskripsi Konkret:**
Menulis script pertama: shebang, permission, variabel environment, kondisional, dan loop. Ini adalah titik di mana perintah-perintah tunggal berubah menjadi program yang dapat diotomatisasi.

**Konsep Dasar dan Filosofi:**
Script adalah file teks yang berisi rangkaian perintah. Shebang (`#!`) memberi tahu sistem interpreter mana yang harus digunakan. Kontrol alur memungkinkan script membuat keputusan dan mengulangi operasi — inilah inti dari otomatisasi.

**Sintaks Dasar:**
```bash
#!/bin/zsh
# script_pertama.zsh - Contoh script dasar

# Kondisional
if [[ $# -eq 0 ]]; then
    echo "Error: Butuh minimal satu argumen" >&2
    exit 1
elif [[ "$1" == "hello" ]]; then
    echo "Halo, dunia!"
else
    echo "Argumen: $1"
fi

# Loop for
for file in *.txt; do
    echo "Memproses: $file"
done

# Loop while
counter=1
while [[ $counter -le 5 ]]; do
    echo "Iterasi ke-$counter"
    ((counter++))
done

# Loop dengan range (Zsh-specific)
for i in {1..10}; do
    echo $i
done

# Case statement
case "$1" in
    start)  echo "Memulai..." ;;
    stop)   echo "Menghentikan..." ;;
    *)      echo "Perintah tidak dikenal" ;;
esac
```

**Terminologi Kunci:**
- **Shebang**: Baris pertama script yang menunjukkan interpreter (`#!/bin/zsh`).
- **Exit Code**: Angka yang dikembalikan program (0 = sukses, non-zero = error).
- **Argument**: Nilai yang diberikan ke script saat dijalankan (`$1`, `$2`, `$@`).
- **Environment Variable**: Variabel yang tersedia untuk semua proses.
- **Loop**: Struktur untuk mengulangi blok kode.
- **Kondisional**: Struktur untuk membuat keputusan berdasarkan kondisi.

**Daftar Isi:**
1. Struktur script: shebang, komentar, exit code
2. Memberikan permission eksekusi (`chmod +x`)
3. Variabel lokal vs environment
4. Kondisional: `if`, `elif`, `else`, `case`
5. Perbandingan string dan angka
6. Loop: `for`, `while`, `until`, `repeat`
7. Argumen script: `$1`, `$@`, `$#`

**Sumber Referensi:**
- Zsh Roadmap — Scripting: https://zsh.sourceforge.io/Guide/zshguide.html
- Shell scripting best practices: https://github.com/Data-Wise/flow-cli/blob/master/docs/ZSH-DEVELOPMENT-GUIDELINES.md

---

### Modul 2.2: Fungsi, Input/Output, dan Redirection

**Deskripsi Konkret:**
Membuat fungsi yang dapat digunakan ulang, membaca input dari pengguna, dan mengarahkan output ke file atau proses lain.

**Konsep Dasar dan Filosofi:**
Fungsi adalah blok kode yang dapat dipanggil berulang kali. Redirection adalah kekuatan sebenarnya dari Unix: setiap program memiliki tiga stream standar (stdin, stdout, stderr) yang dapat diarahkan. Pipe (`|`) menghubungkan stdout satu program ke stdin program lain — inilah "lem" yang menyatukan alat-alat Unix.

**Sintaks Dasar:**
```bash
#!/bin/zsh

# Fungsi dasar
sapa() {
    local nama="$1"
    echo "Halo, $nama!"
}
sapa "Dunia"

# Fungsi dengan return value
hitung_luas() {
    local panjang=$1
    local lebar=$2
    echo $((panjang * lebar))
}
luas=$(hitung_luas 5 3)
echo "Luas: $luas"

# Input dari pengguna
read -p "Masukkan nama Anda: " nama
echo "Halo, $nama"

# Redirection
echo "Pesan ini ke file" > output.txt      # Overwrite
echo "Pesan ini ditambahkan" >> output.txt  # Append
command_berat 2> error.log                  # Redirect stderr
command 2>&1 | tee log.txt                  # stdout+stderr ke file dan layar

# Pipe
ps aux | grep zsh | awk '{print $2}'
```

**Terminologi Kunci:**
- **Fungsi**: Blok kode yang dapat dipanggil dengan nama.
- **Lokal Variable**: Variabel yang hanya berlaku di dalam fungsi (`local`).
- **Stdin (0)**: Stream input standar (biasanya keyboard).
- **Stdout (1)**: Stream output standar (biasanya terminal).
- **Stderr (2)**: Stream error standar (biasanya terminal).
- **Pipe (`|`)**: Menghubungkan stdout satu perintah ke stdin perintah berikutnya.
- **Redirection (`>`, `>>`, `2>`)**: Mengarahkan stream ke file atau lokasi lain.

**Daftar Isi:**
1. Mendefinisikan dan memanggil fungsi
2. Parameter fungsi dan return value
3. Variabel lokal dalam fungsi
4. Membaca input: `read`, `select`
5. Tiga stream standar: stdin, stdout, stderr
6. Redirection: `>`, `>>`, `2>`, `&>`
7. Pipe dan pipeline
8. `tee`: output ke file dan layar sekaligus

**Sumber Referensi:**
- Zsh Functions: https://zsh.sourceforge.io/Doc/Release/Functions.html
- Redirection manual: https://zsh.sourceforge.io/Doc/Release/Redirection.html

**Visualisasi yang Direkomendasikan:**
> Diagram direkomendasikan di sini untuk menjelaskan *tiga stream standar dan redirection*: kotak program dengan tiga panah masuk/keluar (stdin, stdout, stderr), dan bagaimana `>`, `2>`, `|`, `tee` mengubah arah panah tersebut.

---

### Modul 2.3: Error Handling dan Debugging Dasar

**Deskripsi Konkret:**
Menangani error dengan graceful, menggunakan exit code, dan teknik debugging dasar seperti `set -x` dan `set -e`.

**Konsep Dasar dan Filosofi:**
Script yang baik tidak hanya berjalan saat semuanya lancar, tetapi juga menangani kegagalan dengan elegan. Setiap perintah mengembalikan exit code; `0` berarti sukses, non-zero berarti gagal. Prinsip "fail fast" — hentikan eksekusi segera saat terjadi error — mencegah kerusakan lebih lanjut.

**Sintaks Dasar:**
```bash
#!/bin/zsh
set -e          # Exit on error
set -u          # Error on undefined variable
set -o pipefail # Pipe fails if any command in pipe fails

# Trap untuk cleanup
cleanup() {
    echo "Membersihkan temporary files..."
    rm -f /tmp/temp_$$
}
trap cleanup EXIT

# Cek error
if ! command -v git &>/dev/null; then
    echo "Git tidak terinstall" >&2
    exit 1
fi

# Debug mode
set -x          # Tampilkan setiap perintah sebelum dieksekusi
# ... kode yang di-debug ...
set +x          # Matikan debug

# Tracing spesifik fungsi
typeset -ft nama_fungsi  # Aktifkan tracing untuk fungsi tertentu
```

**Terminologi Kunci:**
- **Exit Code**: Kode numerik yang dikembalikan perintah (0 = sukses).
- **`set -e`**: Opsi shell untuk keluar otomatis saat ada perintah yang gagal.
- **`trap`**: Mekanisme untuk menangkap sinyal atau event (seperti `EXIT`).
- **`set -x` (xtrace)**: Mode debug yang menampilkan setiap perintah sebelum eksekusi.
- **`$?`**: Variabel khusus yang menyimpan exit code perintah terakhir.
- **Fail Fast**: Prinsip menghentikan eksekusi segera saat error terjadi.

**Daftar Isi:**
1. Exit code dan `$?`
2. Opsi `set -e`, `set -u`, `set -o pipefail`
3. Trap dan cleanup
4. Debugging dengan `set -x` dan `PS4`
5. Tracing fungsi dengan `typeset -ft`
6. Logging terstruktur

**Sumber Referensi:**
- Zsh debugging techniques: https://hoop.dev/blog/zsh-debug-logging
- zshdb debugger: https://manpages.ubuntu.com/manpages/focal/man1/zshdb.1.html

---

# [FASE 3: GLOBBING, COMPLETION, DAN KONFIGURASI]
**Level:** Menengah | **Durasi:** 4–5 minggu | **Jam:** ~30–40 jam

### Modul 3.1: Globbing dan Pattern Matching Lanjutan

**Deskripsi Konkret:**
Menguasai sistem globbing Zsh yang jauh lebih kaya dari Bash: recursive globbing, glob qualifiers, dan pattern exclusion.

**Konsep Dasar dan Filosofi:**
Globbing adalah cara shell mencocokkan nama file dengan pola. Zsh memperluas ini secara dramatis: Anda bisa memfilter berdasarkan tipe file, ukuran, waktu modifikasi, dan bahkan atribut seperti executable atau symlink. Glob qualifier adalah "filter" yang diterapkan setelah pencocokan nama file, memungkinkan seleksi yang sangat presisi.

**Sintaks Dasar:**
```bash
# Globbing dasar
ls *.txt                # Semua file .txt
ls **/*.txt             # Recursive semua .txt (Zsh: tanpa find!)
ls file?.txt            # Satu karakter wildcard

# Glob qualifiers (dalam tanda kurung)
ls *(.)                 # Hanya file biasa (bukan direktori)
ls *(/)                 # Hanya direktori
ls *(@)                 # Hanya symlink
ls *(x)                 # Hanya executable
ls *(Lk+100)            # File > 100 KB
ls *(m-7)               # Dimodifikasi dalam 7 hari terakhir
ls *(om[1,5])           # 5 file terbaru (sort by mtime)

# Kombinasi
ls **/*.log(om[1,3])    # 3 log terbaru secara rekursif

# Exclusion
ls ^*.tmp               # Semua kecuali .tmp
ls *~*test*             # Semua kecuali yang mengandung "test"

# Extended globbing (setopt EXTENDED_GLOB)
setopt EXTENDED_GLOB
ls ^*.{jpg,png}         # Exclude multiple patterns
```

**Terminologi Kunci:**
- **Globbing**: Ekspansi pola wildcard menjadi daftar nama file.
- **Glob Qualifier**: Filter dalam tanda kurung yang membatasi hasil glob.
- **Recursive Glob (`**`)**: Mencari di semua subdirektori.
- **`^` (Negasi)**: Mengecualikan pola.
- **`~` (Exclusion)**: Mengecualikan pola dalam extended globbing.
- **`setopt EXTENDED_GLOB`**: Mengaktifkan fitur globbing tambahan.

**Daftar Isi:**
1. Wildcard dasar: `*`, `?`, `[...]`
2. Recursive globbing dengan `**`
3. Glob qualifiers: tipe, permission, ukuran, waktu
4. Sorting dan pembatasan hasil glob
5. Negasi dan exclusion patterns
6. Extended globbing dan opsi `EXTENDED_GLOB`

**Sumber Referensi:**
- Zsh Expansion — Filename Generation: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Filename-Generation
- Glob qualifier examples: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers

**Visualisasi yang Direkomendasikan:**
> Tabel visual direkomendasikan di sini untuk merangkum *glob qualifier*: kolom untuk kualifikasi (tipe, permission, waktu, ukuran), sintaks, dan contoh hasil.

---

### Modul 3.2: Sistem Completion yang Dapat Diprogram

**Deskripsi Konkret:**
Memahami dan mengkustomisasi sistem completion Zsh — salah satu fitur paling powerful yang membedakannya dari shell lain. Dari completion bawaan hingga menulis completion function sendiri.

**Konsep Dasar dan Filosofi:**
Sistem completion Zsh (`compsys`) adalah kerangka kerja lengkap yang memungkinkan completion kontekstual. Ketika Anda menekan Tab, sistem menganalisis seluruh baris perintah, memahami konteks (apakah Anda mengetik opsi, path file, atau argumen khusus), dan menawarkan saran yang relevan. Ini bukan sekadar daftar perintah; ini adalah pemahaman semantik terhadap command line.

**Sintaks Dasar:**
```bash
# Inisialisasi completion system
autoload -Uz compinit
compinit

# Konfigurasi dasar
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Completion function sederhana
_my_command() {
    local -a options
    options=(
        '--help:Membuka bantuan'
        '--version:Menampilkan versi'
        '--output=:File output'
    )
    _describe 'options' options
}
compdef _my_command my_command

# Menggunakan completion untuk command yang ada
compdef _git git
compdef _docker docker
```

**Terminologi Kunci:**
- **Completion**: Fitur yang melengkapi perintah saat Tab ditekan.
- **`compinit`**: Fungsi inisialisasi sistem completion.
- **`compdef`**: Mendaftarkan fungsi completion untuk perintah tertentu.
- **`zstyle`**: Mekanisme konfigurasi untuk completion dan modul lain.
- **Context**: Informasi tentang posisi cursor dan perintah yang sedang diketik.
- **`_describe`**: Fungsi helper untuk menampilkan daftar completion dengan deskripsi.

**Daftar Isi:**
1. Inisialisasi completion: `compinit`
2. Konfigurasi dengan `zstyle`
3. Completion untuk command yang ada
4. Menulis completion function sendiri
5. Context-sensitive completion
6. Menu selection dan matcher

**Sumber Referensi:**
- Zsh Completion System: https://zsh.sourceforge.io/Doc/Release/Completion-System.html
- Zsh Completion Examples: https://github.com/zsh-users/zsh-completions

---

### Modul 3.3: Konfigurasi Zsh — `.zshrc`, Opsi, dan Startup Files

**Deskripsi Konkret:**
Menguasai file konfigurasi Zsh: urutan pembacaan, opsi shell, aliases, dan fungsi startup.

**Konsep Dasar dan Filosofi:**
Zsh membaca beberapa file saat startup, tergantung pada apakah shell bersifat login, interaktif, atau keduanya. Memahami urutan ini krusial untuk konfigurasi yang benar. File `.zshrc` adalah file konfigurasi utama untuk shell interaktif. Opsi shell (`setopt`) mengontrol perilaku shell — dari koreksi ejaan hingga format prompt.

**Sintaks Dasar:**
```bash
# ~/.zshrc - File konfigurasi utama

# Opsi shell yang direkomendasikan
setopt AUTO_CD              # cd tanpa mengetik "cd"
setopt AUTO_PUSHD           # Simpan direktori lama
setopt PUSHD_IGNORE_DUPS    # Hindari duplikasi di stack
setopt CORRECT              # Koreksi ejaan otomatis
setopt GLOB_DOTS            # Sertakan file hidden dalam glob
setopt EXTENDED_HISTORY     # Simpan timestamp di history
setopt HIST_IGNORE_ALL_DUPS # Hindari duplikasi history
setopt SHARE_HISTORY        # Share history antar terminal

# Aliases
alias ll='ls -la'
alias gs='git status'
alias ..='cd ..'
alias reload='exec zsh'

# PATH
export PATH="$HOME/.local/bin:$PATH"

# Environment variables
export EDITOR='nvim'
export LANG='id_ID.UTF-8'

# Memuat completion
autoload -Uz compinit && compinit

# Fungsi custom
mkcd() {
    mkdir -p "$1" && cd "$1"
}
```

**Terminologi Kunci:**
- **`.zshrc`**: File konfigurasi untuk shell interaktif.
- **`.zprofile`**: File konfigurasi untuk login shell.
- **`setopt`**: Perintah untuk mengaktifkan opsi shell.
- **`unsetopt`**: Perintah untuk menonaktifkan opsi shell.
- **Login Shell**: Shell yang dijalankan saat login pertama.
- **Interactive Shell**: Shell yang menerima input dari pengguna.
- **Alias**: Nama pendek untuk perintah yang lebih panjang.

**Daftar Isi:**
1. Urutan pembacaan file startup: `.zshenv`, `.zprofile`, `.zshrc`, `.zlogin`
2. Opsi shell: `setopt` dan `unsetopt`
3. Aliases: efisien vs berbahaya
4. PATH dan environment variables
5. Fungsi startup dan autoloading
6. Organisasi `.zshrc` yang modular

**Sumber Referensi:**
- Zsh Startup Files: https://zsh.sourceforge.io/Doc/Release/Files.html
- Zsh Options: https://zsh.sourceforge.io/Doc/Release/Options.html
- Zsh configuration examples: https://github.com/kraloveckey/zshrc

---

# [FASE 4: EKOSISTEM, PERFORMA, DAN KEAMANAN]
**Level:** Menengah–Mahir | **Durasi:** 4–6 minggu | **Jam:** ~35–45 jam

### Modul 4.1: Framework dan Plugin Manager

**Deskripsi Konkret:**
Mengenal ekosistem plugin Zsh: Oh My Zsh, Antidote, Zinit, dan alternatif lainnya. Memilih dan mengelola plugin dengan bijak.

**Konsep Dasar dan Filosofi:**
Plugin manager memungkinkan Anda menginstal, memperbarui, dan memuat plugin dengan mudah. Namun, tidak semua plugin manager sama: beberapa cepat, beberapa lambat; beberapa aktif dikembangkan, beberapa sudah ditinggalkan. Memahami trade-off ini penting untuk membangun lingkungan kerja yang stabil dan cepat.

**Sintaks Dasar:**
```bash
# Oh My Zsh - Framework paling populer
# Install: sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting docker kubectl)
ZSH_THEME="robbyrussell"

# Antidote - Plugin manager modern dan cepat
# Install: git clone https://github.com/mattmc3/antidote.git ~/.antidote
source ~/.antidote/antidote.zsh
antidote load

# Zinit - Fleksibel dan cepat
source ~/.zinit/bin/zinit.zsh
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# Plugin manual (tanpa manager)
source ~/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
```

**Terminologi Kunci:**
- **Oh My Zsh**: Framework komunitas dengan 300+ plugin dan 140+ tema.
- **Antidote**: Plugin manager Zsh yang cepat dan modern.
- **Zinit**: Plugin manager fleksibel dengan fitur lanjutan.
- **zsh-autosuggestions**: Plugin yang menyarankan perintah berdasarkan history.
- **zsh-syntax-highlighting**: Plugin yang mewarnai sintaks saat mengetik.
- **Plugin Load Time**: Waktu yang dibutuhkan untuk memuat plugin saat startup.

**Daftar Isi:**
1. Oh My Zsh: kelebihan dan kekurangan
2. Antidote: plugin manager ringan
3. Zinit: fleksibilitas dan performa
4. Plugin esensial: autosuggestions, syntax highlighting
5. Manajemen plugin tanpa framework
6. Mengukur dan mengoptimalkan waktu startup

**Sumber Referensi:**
- Oh My Zsh Wiki — Plugins: https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
- Antidote: https://getantidote.github.io/
- Zinit: https://github.com/zdharma-continuum/zinit
- Awesome Zsh Plugins: https://github.com/unixorn/awesome-zsh-plugins

**Visualisasi yang Direkomendasikan:**
> Diagram batang direkomendasikan di sini untuk membandingkan *waktu startup* antara Vanilla Zsh (~50ms), Oh My Zsh (~800ms), dan setup yang dioptimalkan (~100–200ms).

---

### Modul 4.2: Prompt Kustomisasi dan Tema

**Deskripsi Konkret:**
Membuat prompt yang informatif dan efisien: menampilkan git status, status exit, waktu eksekusi, dan informasi kontekstual lainnya.

**Konsep Dasar dan Filosofi:**
Prompt adalah antarmuka utama Anda dengan shell. Prompt yang baik memberikan informasi yang Anda butuhkan tanpa mengganggu. Zsh memiliki sistem prompt yang sangat fleksibel melalui ekspansi prompt (`%` escape) dan fungsi `precmd`/`preexec`.

**Sintaks Dasar:**
```bash
# Prompt sederhana dengan ekspansi
PS1='%n@%m:%~%# '        # user@host:path#

# Prompt informatif
PS1='%F{green}%n%f@%F{blue}%m%f:%F{yellow}%~%f%# '

# Prompt dengan git status (fungsi)
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '(%b)'
setopt PROMPT_SUBST
PS1='%F{green}%n%f:%F{blue}%~%f${vcs_info_msg_0_}%# '

# Prompt dengan exit code
PS1='%(?.%F{green}√.%F{red}✗)%f %# '

# Menggunakan tema dari framework
ZSH_THEME="agnoster"     # Oh My Zsh
# atau
ZSH_THEME="powerlevel10k/powerlevel10k"  # Powerlevel10k
```

**Terminologi Kunci:**
- **PS1**: Variabel prompt utama.
- **Escape Sequence**: Kode khusus dalam prompt (`%n`, `%m`, `%~`).
- **`precmd`**: Fungsi yang dijalankan sebelum prompt ditampilkan.
- **`preexec`**: Fungsi yang dijalankan sebelum perintah dieksekusi.
- **`vcs_info`**: Modul untuk menampilkan informasi version control.
- **Powerlevel10k**: Tema prompt populer dengan fitur canggih.

**Daftar Isi:**
1. Ekspansi prompt: `%n`, `%m`, `%~`, `%#`
2. Warna dan formatting
3. `precmd` dan `preexec` hooks
4. Menampilkan git status dengan `vcs_info`
5. Tema populer: Powerlevel10k, Agnoster, Pure
6. Prompt minimal vs prompt informatif

**Sumber Referensi:**
- Zsh Prompt Expansion: https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
- Powerlevel10k: https://github.com/romkatv/powerlevel10k
- Pure prompt: https://github.com/sindresorhus/pure

**Visualisasi yang Direkomendasikan:**
> Tangkapan layar prompt yang direkomendasikan di sini untuk membandingkan *tampilan visual* dari beberapa tema (Powerlevel10k, Agnoster, Pure) dan menunjukkan informasi apa yang ditampilkan masing-masing.

---

### Modul 4.3: Optimasi Performa Shell

**Deskripsi Konkret:**
Mengukur dan mengoptimalkan waktu startup shell dan waktu eksekusi perintah. Menggunakan `zprof`, lazy loading, dan caching.

**Konsep Dasar dan Filosofi:**
Shell yang lambat saat startup adalah masalah produktivitas. Setiap milidetik di startup dikalikan dengan berapa kali Anda membuka terminal setiap hari. Optimasi bukan tentang "lebih cepat" secara abstrak, tetapi tentang menghilangkan bottleneck yang tidak perlu.

**Sintaks Dasar:**
```bash
# Profiling startup
zmodload zsh/zprof
# ... konfigurasi ...
zprof | head -20

# Mengukur waktu startup
time zsh -i -c exit

# Lazy loading (memuat plugin saat dibutuhkan)
zsh-defer source ~/.nvm/nvm.sh

# Compile file Zsh ke bytecode
zcompile ~/.zshrc
zcompile ~/.zsh_plugins.zsh

# Cache completion dump
compinit -C  # Skip security check (untuk kecepatan)

# Menghindari sourcing yang tidak perlu
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
```

**Terminologi Kunci:**
- **`zprof`**: Modul profiling bawaan Zsh.
- **Lazy Loading**: Memuat plugin hanya saat dibutuhkan.
- **`zcompile`**: Mengkompilasi file Zsh ke bytecode untuk loading lebih cepat.
- **`compinit -C`**: Melewati pemeriksaan keamanan completion (gunakan dengan hati-hati).
- **Startup Time**: Waktu yang dibutuhkan shell untuk siap menerima input.

**Daftar Isi:**
1. Profiling dengan `zprof`
2. Mengukur waktu startup
3. Lazy loading plugin berat (nvm, pyenv, dll.)
4. Kompilasi dengan `zcompile`
5. Caching `compinit`
6. Mengurangi jumlah plugin

**Sumber Referensi:**
- Zsh Performance Optimization: https://doc.dotfiles.io/adr/002-shell-performance/
- Speeding up Zsh: https://hoop.dev/blog/zsh-slows-down

---

### Modul 4.4: Keamanan Scripting Zsh

**Deskripsi Konkret:**
Menulis script yang aman: menghindari code injection, mengelola secrets dengan benar, dan mengamankan file konfigurasi.

**Konsep Dasar dan Filosofi:**
Script shell sering memiliki akses ke sistem dan data sensitif. Kesalahan sekecil apapun dapat menyebabkan eksekusi kode berbahaya. Prinsip "least privilege" dan "defense in depth" harus diterapkan.

**Sintaks Dasar:**
```bash
#!/bin/zsh
set -euo pipefail

# ❌ JANGAN: eval dengan input pengguna
# eval "echo $user_input"  # BAHAYA: code injection!

# ✅ GUNAKAN: array dan quoting
printf '%s\n' "$user_input"

# Amankan sourcing
safe_source() {
    local file="$1"
    if [[ -O "$file" && -r "$file" ]]; then
        source "$file"
    else
        echo "File tidak aman: $file" >&2
        return 1
    fi
}

# Kelola secrets dengan benar
# ❌ JANGAN: hardcode di script
# API_KEY="sk-1234567890"

# ✅ GUNAKAN: environment variable dari secure store
# export API_KEY="$(op read 'op://vault/api-key')"

# Batasi permission file konfigurasi
chmod 600 ~/.zshrc
chmod 700 ~/.ssh
```

**Terminologi Kunci:**
- **Code Injection**: Serangan di mana input pengguna dieksekusi sebagai kode.
- **`eval`**: Perintah yang mengeksekusi string sebagai kode (berbahaya dengan input tidak terpercaya).
- **Least Privilege**: Prinsip memberikan akses minimum yang diperlukan.
- **Secrets Management**: Praktik mengelola kredensial dengan aman.
- **`-O` (ownership check)**: Test operator Zsh untuk memeriksa kepemilikan file.
- **Homograph Attack**: Serangan menggunakan karakter Unicode yang mirip.

**Daftar Isi:**
1. Bahaya `eval` dan code injection
2. Quoting yang benar untuk keamanan
3. Mengamankan `source` dan plugin
4. Manajemen secrets: environment vs file
5. Permission file konfigurasi
6. Audit script dengan ShellCheck

**Sumber Referensi:**
- Zsh Security: https://hoop.dev/blog/zsh-compliance-requirements
- zsh-redact-history: https://github.com/severeon/zsh-redact-history
- ShellCheck: https://www.shellcheck.net/

---

# [FASE 5: SCRIPTING LANJUTAN DAN TESTING]
**Level:** Mahir | **Durasi:** 6–8 minggu | **Jam:** ~50–60 jam

### Modul 5.1: Fungsi Lanjutan, Hook, dan Autoloading

**Deskripsi Konkret:**
Menguasai fungsi Zsh tingkat lanjut: anonymous functions, hook functions, autoloading, dan manipulasi parameter tingkat lanjut.

**Konsep Dasar dan Filosofi:**
Zsh memiliki sistem fungsi yang jauh lebih kaya dari Bash. Hook functions (`chpwd`, `precmd`, `preexec`) memungkinkan Anda merespons event shell secara otomatis. Autoloading memungkinkan fungsi dimuat hanya saat dibutuhkan, menghemat waktu startup.

**Sintaks Dasar:**
```bash
#!/bin/zsh

# Anonymous function
() {
    local temp_dir=$(mktemp -d)
    echo "Working in: $temp_dir"
    cd "$temp_dir"
    # ... kerja ...
}  # Langsung dieksekusi

# Hook functions
chpwd() {
    echo "Pindah ke: $PWD"
    ls -la
}

precmd() {
    # Dijalankan sebelum setiap prompt
    echo "Waktu: $(date +%H:%M:%S)"
}

preexec() {
    # Dijalankan sebelum setiap perintah
    echo "Menjalankan: $1"
}

# Autoloading
# 1. Buat file: ~/.zsh/functions/nama_fungsi
# 2. Tambahkan ke fpath
fpath=(~/.zsh/functions $fpath)
# 3. Autoload
autoload -Uz nama_fungsi
# 4. Panggil seperti biasa
nama_fungsi

# Manipulasi parameter lanjutan
local -a arr
arr=(satu dua tiga)
echo ${(j:,:)arr}      # Join dengan koma: satu,dua,tiga
echo ${(Oa)arr}        # Sort descending
echo ${(k)assoc}       # Keys dari associative array
```

**Terminologi Kunci:**
- **Anonymous Function**: Fungsi tanpa nama yang langsung dieksekusi.
- **Hook Function**: Fungsi yang dipanggil otomatis pada event tertentu.
- **`chpwd`**: Hook yang dipanggil saat direktori berubah.
- **`precmd`**: Hook sebelum prompt ditampilkan.
- **`preexec`**: Hook sebelum perintah dieksekusi.
- **Autoloading**: Memuat fungsi saat pertama kali dipanggil.
- **Parameter Expansion Flags**: Modifier dalam `${(flag)var}` untuk manipulasi string/array.

**Daftar Isi:**
1. Anonymous functions
2. Hook functions: `chpwd`, `precmd`, `preexec`
3. Autoloading dan fpath
4. Parameter expansion flags: `(j)`, `(s)`, `(k)`, `(v)`
5. Manipulasi array lanjutan
6. Associative array dan iterasi

**Sumber Referensi:**
- Zsh Functions: https://zsh.sourceforge.io/Doc/Release/Functions.html
- Zsh Parameter Expansion: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Parameter-Expansion

---

### Modul 5.2: Testing dan Quality Assurance

**Deskripsi Konkret:**
Menulis test untuk script Zsh menggunakan framework seperti ShellSpec, ZUnit, dan zsh-test-runner.

**Konsep Dasar dan Filosofi:**
Script shell juga memerlukan test. Tanpa test, refactoring menjadi berisiko, dan bug mudah lolos ke produksi. Framework testing Zsh menyediakan struktur untuk unit test, integration test, dan end-to-end test.

**Sintaks Dasar:**
```bash
# ShellSpec - BDD testing framework
# Install: curl -fsSL https://git.io/shellspec | sh

# Contoh test file: spec/math_spec.sh
Describe 'kalkulator'
    It 'menjumlahkan dua angka'
        When call hitung 2 + 3
        The output should eq 5
    End

    It 'menangani pembagian dengan nol'
        When call bagi 10 0
        The status should be failure
        The stderr should include 'tidak bisa dibagi nol'
    End
End

# Menjalankan test
shellspec

# ZUnit - Unit testing untuk Zsh
# Install: brew install zunit
zunit  # Jalankan test

# zsh-test-runner
# Install: git clone https://github.com/olets/zsh-test-runner
ztr test 'deskripsi' {
    local result=$(fungsi_yang_ditest)
    ztr test -eq "$result" "nilai yang diharapkan"
}
```

**Terminologi Kunci:**
- **ShellSpec**: Framework BDD untuk shell scripting.
- **ZUnit**: Framework unit testing khusus Zsh.
- **BDD (Behavior-Driven Development)**: Pendekatan testing berdasarkan perilaku yang diharapkan.
- **Unit Test**: Test untuk fungsi atau modul individu.
- **Integration Test**: Test yang memverifikasi interaksi antar komponen.
- **E2E Test**: Test yang mensimulasikan alur kerja pengguna lengkap.

**Daftar Isi:**
1. Mengapa testing script shell penting
2. ShellSpec: instalasi dan sintaks
3. ZUnit: unit testing untuk Zsh
4. zsh-test-runner: alternatif ringan
5. CI/CD untuk script shell
6. Code coverage

**Sumber Referensi:**
- ShellSpec: https://shellspec.info/
- ZUnit: https://github.com/z-shell/zunit
- zsh-test-runner: https://github.com/olets/zsh-test-runner

**Visualisasi yang Direkomendasikan:**
> Diagram piramida testing direkomendasikan di sini: *Unit Tests* (dasar, banyak, cepat) → *Integration Tests* (tengah) → *E2E Tests* (atas, sedikit, lambat), dengan contoh untuk setiap level dalam konteks Zsh.

---

### Modul 5.3: Integrasi dengan Bahasa Lain dan API Eksternal

**Deskripsi Konkret:**
Menghubungkan Zsh dengan Python, Node.js, Ruby, dan API eksternal (REST, database, cloud services).

**Konsep Dasar dan Filosofi:**
Shell bukan pulau. Kekuatan sebenarnya muncul ketika Anda menggabungkan kemampuan shell dengan bahasa pemrograman lain dan layanan eksternal. Zsh dapat memanggil script Python, menggunakan output JSON dari API, dan berinteraksi dengan database.

**Sintaks Dasar:**
```bash
#!/bin/zsh

# Memanggil Python dan menangkap output
hasil=$(python3 -c "
import json
data = {'nama': 'Budi', 'umur': 25}
print(json.dumps(data))
")
echo "$hasil" | jq '.nama'

# Parse JSON dengan jq
curl -s https://api.github.com/users/octocat | jq '.name'

# Interaksi dengan database
psql -U user -d db -c "SELECT * FROM tabel;" --csv

# Menggunakan Node.js
node -e "
const os = require('os');
console.log(os.platform());
"

# Environment variables untuk integrasi
export DATABASE_URL="postgres://user:pass@localhost:5432/db"
export API_KEY="$(cat ~/.secrets/api_key)"

# Pipe ke alat CLI lainnya
kubectl get pods -o json | jq '.items[].metadata.name'
```

**Terminologi Kunci:**
- **`jq`**: Alat CLI untuk memproses JSON.
- **REST API**: Antarmuka HTTP untuk berkomunikasi dengan layanan eksternal.
- **Environment Variable**: Cara aman untuk meneruskan konfigurasi ke script.
- **`curl`**: Alat untuk transfer data via HTTP/FTP.
- **`psql`**: Client PostgreSQL CLI.
- **`kubectl`**: CLI Kubernetes.

**Daftar Isi:**
1. Memanggil Python/Ruby/Node dari Zsh
2. Memproses JSON dengan `jq`
3. Interaksi dengan REST API
4. Koneksi database
5. Environment variable untuk konfigurasi
6. Pipeline dengan alat CLI modern

**Sumber Referensi:**
- jq manual: https://stedolan.github.io/jq/manual/
- Zsh modules (net/tcp): https://zsh.sourceforge.io/Doc/Release/Zsh-Modules.html

---

# [FASE 6: EXPERT — ARSITEKTUR, KONTRIBUSI, DAN SPESIALISASI]
**Level:** Expert | **Durasi:** 8–12 minggu | **Jam:** ~60–80 jam

### Modul 6.1: Arsitektur Enterprise dan Deployment

**Deskripsi Konkret:**
Merancang, mendeploy, dan mengelola lingkungan Zsh untuk tim dan organisasi. Standarisasi konfigurasi, distribusi plugin, dan kebijakan keamanan.

**Konsep Dasar dan Filosofi:**
Di tingkat enterprise, konsistensi dan keamanan lebih penting daripada kustomisasi individual. Tantangannya adalah menyeimbangkan kebutuhan tim untuk konfigurasi yang dapat diprediksi dengan preferensi individu pengembang.

**Sintaks Dasar:**
```bash
# Struktur dotfiles enterprise
# /etc/zsh/zshrc - Konfigurasi sistem-wide
# /etc/zsh/zshenv - Environment untuk semua shell
# /etc/zsh/zprofile - Login shell sistem-wide

# Konfigurasi modular yang dapat di-override
# /etc/zsh/conf.d/00-base.zsh
# /etc/zsh/conf.d/10-security.zsh
# /etc/zsh/conf.d/20-tools.zsh

# Load konfigurasi berdasarkan direktori
for conf in /etc/zsh/conf.d/*.zsh(N); do
    source "$conf"
done

# Konfigurasi lokal pengguna (override)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Distribusi dotfiles dengan Git
# git clone https://git.company.com/dotfiles.git ~/.dotfiles
# stow zsh  # Menggunakan GNU Stow
```

**Terminologi Kunci:**
- **Dotfiles**: File konfigurasi yang dimulai dengan titik (`.zshrc`).
- **GNU Stow**: Alat untuk mengelola dotfiles sebagai symlink.
- **Ansible**: Alat manajemen konfigurasi untuk deployment.
- **Chef/Puppet**: Alat manajemen konfigurasi enterprise.
- **Zero-Trust Security**: Model keamanan yang tidak mempercayai apa pun secara default.

**Daftar Isi:**
1. Struktur dotfiles yang scalable
2. Konfigurasi sistem-wide vs pengguna
3. Manajemen plugin di tim
4. Deployment dengan Ansible/Stow
5. Kebijakan keamanan dan audit
6. Onboarding pengembang baru

**Sumber Referensi:**
- Dotfiles management: https://dotfiles.github.io/
- GNU Stow: https://www.gnu.org/software/stow/
- Ansible: https://docs.ansible.com/

---

### Modul 6.2: Kontribusi ke Proyek Zsh dan Open Source

**Deskripsi Konkret:**
Berkontribusi ke proyek Zsh inti, plugin, atau alat terkait. Memahami proses development, mailing list, dan standar kontribusi.

**Konsep Dasar dan Filosofi:**
Zsh dikembangkan oleh komunitas sejak 1990. Berkontribusi bukan hanya tentang menulis kode, tetapi juga tentang memahami ekosistem, berkomunikasi dengan maintainer, dan mengikuti standar yang telah ditetapkan.

**Sintaks Dasar:**
```bash
# Clone repositori Zsh
git clone https://github.com/zsh-users/zsh.git
cd zsh

# Build dari source
./Util/preconfig
./configure --prefix=/usr/local
make
sudo make install

# Membuat patch
git checkout -b fix-bug-xyz
# ... edit files ...
git commit -m "Fix: deskripsi perbaikan"
git format-patch origin/master

# Mengirim ke mailing list
# Kirim patch ke zsh-workers@zsh.org
```

**Terminologi Kunci:**
- **Mailing List**: `zsh-workers@zsh.org` untuk development, `zsh-users@zsh.org` untuk diskusi pengguna.
- **Patch**: Perubahan kode yang dikirim untuk ditinjau.
- **Pull Request**: Permintaan untuk menggabungkan perubahan (di GitHub).
- **Maintainer**: Orang yang bertanggung jawab atas proyek.
- **BSD License**: Lisensi open source yang digunakan Zsh.

**Daftar Isi:**
1. Sejarah dan governance proyek Zsh
2. Mailing list dan komunikasi
3. Proses patch dan review
4. Menulis plugin Zsh
5. Mendokumentasikan kontribusi
6. Etika open source

**Sumber Referensi:**
- Zsh Mailing Lists: https://zsh.sourceforge.io/Arc/mailinglists.html
- Zsh GitHub: https://github.com/zsh-users/zsh
- Zsh FAQ: https://zsh.sourceforge.io/FAQ/

---

### Modul 6.3: Spesialisasi — Pilih Jalur Anda

**Deskripsi Konkret:**
Modul ini memberikan tiga jalur spesialisasi yang dapat dipilih sesuai minat dan kebutuhan karier.

**Jalur A: DevOps & Cloud Automation**
- Script untuk CI/CD pipeline
- Interaksi dengan AWS/GCP/Azure CLI
- Infrastructure as Code dengan Zsh
- Referensi: AWS CLI, Terraform, Kubernetes

**Jalur B: Data Engineering & Analisis**
- Pipeline data dengan `awk`, `sed`, `jq`
- Integrasi dengan Python/R untuk analisis
- Otomatisasi ETL
- Referensi: Python pandas, Apache Spark

**Jalur C: Developer Tooling & Produktivitas**
- Membangun CLI tools dengan Zsh
- Integrasi dengan editor (VS Code, Neovim)
- FZF, ripgrep, fd, bat
- Referensi: fzf, ripgrep, fd, bat

**Sintaks Dasar (Contoh Jalur A — DevOps):**
```bash
#!/bin/zsh
set -euo pipefail

# Deploy ke AWS
deploy() {
    local env="${1:-staging}"
    
    # Build
    docker build -t myapp:"$env" .
    
    # Push ke ECR
    aws ecr get-login-password | docker login --username AWS --password-stdin "$ECR_URL"
    docker push "$ECR_URL/myapp:$env"
    
    # Update service
    aws ecs update-service \
        --cluster "my-cluster" \
        --service "my-service" \
        --force-new-deployment
    
    echo "Deploy ke $env selesai"
}
```

**Daftar Isi:**
1. **Jalur A — DevOps:** CI/CD, cloud CLI, IaC
2. **Jalur B — Data:** ETL, analisis, visualisasi
3. **Jalur C — Tooling:** CLI tools, editor, produktivitas
4. Proyek akhir untuk setiap jalur

**Sumber Referensi:**
- Awesome Zsh Plugins: https://github.com/unixorn/awesome-zsh-plugins
- Modern CLI tools: https://github.com/ibraheemdev/modern-unix

---

## Sumber Daya Komunitas & Sertifikasi

### Komunitas

| Platform | Deskripsi | Tautan |
|----------|-----------|--------|
| **Zsh Mailing List** | Diskusi resmi pengguna dan developer | https://zsh.sourceforge.io/Arc/mailinglists.html |
| **Oh My Zsh GitHub** | 2.400+ kontributor, 300+ plugin | https://github.com/ohmyzsh/ohmyzsh |
| **r/zsh** | Subreddit komunitas Zsh | https://reddit.com/r/zsh |
| **Stack Overflow** | Q&A dengan tag `zsh` | https://stackoverflow.com/questions/tagged/zsh |
| **Awesome Zsh Plugins** | Koleksi plugin, framework, tema | https://github.com/unixorn/awesome-zsh-plugins |
| **Zsh Wiki** | Wiki komunitas | http://www.zshwiki.org/ |

### Sertifikasi dan Validasi Keahlian

| Sertifikasi | Provider | Deskripsi | Tautan |
|-------------|----------|-----------|--------|
| **Shell Scripting with Z Shell** | EC-Council | Sertifikasi resmi untuk Zsh scripting | https://codered.eccouncil.org/ |
| **Linux Professional Institute (LPIC-1)** | LPI | Mencakup shell scripting termasuk Zsh | https://www.lpi.org/ |
| **Red Hat Certified System Administrator (RHCSA)** | Red Hat | Termasuk shell scripting | https://www.redhat.com/en/services/training/rh124-red-hat-system-administration-i |
| **CompTIA Linux+** | CompTIA | Mencakup shell dan scripting | https://www.comptia.org/certifications/linux |

**Catatan:** Tidak ada sertifikasi "Zsh-only" yang diakui secara universal. Sertifikasi Linux umumnya mencakup shell scripting sebagai bagian dari kurikulum. Portofolio proyek dan kontribusi open source sering lebih bernilai daripada sertifikat dalam konteks praktis.

---

## Hasil Pembelajaran (Learning Outcomes)

Setelah menyelesaikan seluruh kurikulum ini, peserta akan mampu:

### Pengetahuan
1. **Menjelaskan arsitektur shell** dan perbedaannya dengan kernel, terminal, dan sistem operasi.
2. **Mengidentifikasi perbedaan kunci** antara Zsh, Bash, dan shell lainnya, termasuk kapan menggunakan masing-masing.
3. **Memahami filosofi Unix** dan bagaimana prinsip-prinsipnya diterapkan dalam scripting Zsh.

### Keterampilan Praktis
4. **Menulis script Zsh yang robust** dengan error handling, logging, dan testing.
5. **Menguasai globbing lanjutan** dan glob qualifier untuk manipulasi file yang presisi.
6. **Mengkonfigurasi Zsh** dari nol, termasuk completion system, prompt, dan plugin.
7. **Mengoptimalkan performa shell** dengan profiling, lazy loading, dan caching.
8. **Mengintegrasikan Zsh** dengan bahasa pemrograman lain dan API eksternal.
9. **Mendeploy konfigurasi Zsh** untuk tim menggunakan dotfiles management dan automation.
10. **Menulis test** untuk script Zsh menggunakan framework testing modern.

### Sikap dan Kebiasaan
11. **Menerapkan praktik keamanan** dalam scripting, termasuk manajemen secrets dan pencegahan code injection.
12. **Mengadopsi mindset "fail fast"** dan defensive programming dalam otomatisasi.
13. **Berkontribusi ke komunitas** open source dan berbagi pengetahuan.
14. **Terus belajar** dan mengadaptasi teknologi baru dalam ekosistem shell.

---

## Fleksibilitas & Adaptasi

Kurikulum ini dirancang sebagai **kerangka kerja yang dapat disesuaikan**. Beberapa cara untuk mengadaptasinya:

- **Untuk pemula total:** Fokus pada Fase 1–2, perlambat tempo, tambahkan latihan praktis di setiap modul.
- **Untuk pengguna Bash yang beralih:** Percepat Fase 1, fokus pada Modul 2.3 (perbedaan Zsh–Bash) dan Fase 3 (globbing, completion).
- **Untuk DevOps engineer:** Setelah Fase 3, langsung ke Modul 5.3 (integrasi) dan Modul 6.3 Jalur A (DevOps).
- **Untuk data scientist:** Setelah Fase 3, langsung ke Modul 5.3 (integrasi Python) dan Modul 6.3 Jalur B (Data).
- **Untuk developer tooling:** Fokus pada Fase 4 (plugin, prompt) dan Modul 6.3 Jalur C (Tooling).

Setiap modul dapat **ditambahkan, dikurangi, atau dikombinasikan** sesuai kebutuhan. Tidak ada urutan yang kaku — kurikulum ini adalah peta, bukan rel.

---

## Catatan Akhir

Zsh adalah investasi jangka panjang. Waktu yang dihabiskan untuk menguasainya akan terbayar berkali-kali lipat dalam produktivitas, otomatisasi, dan kontrol atas lingkungan kerja Anda. Kunci utamanya adalah **konsisten berlatih**, **membaca dokumentasi**, dan **tidak takut bereksperimen**. Selamat belajar!


[FASE 1: FONDASI — MENGENAL SHELL DAN ZSH]: ./bagian-1/README.md
[FASE 2: SCRIPTING DASAR — DARI PERINTAH KE PROGRAM]: ./bagian-2/README.md
[FASE 3: GLOBBING, COMPLETION, DAN KONFIGURASI]: ./bagian-3/README.md
[FASE 4: EKOSISTEM, PERFORMA, DAN KEAMANAN]: ./bagian-4/README.md
[FASE 5: SCRIPTING LANJUTAN DAN TESTING]: ./bagian-5/README.md
[FASE 6: EXPERT — ARSITEKTUR, KONTRIBUSI, DAN SPESIALISASI]: ./bagian-6/README.md
