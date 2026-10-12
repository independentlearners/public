# **Fase 1: Fondasi — Berinteraksi dengan Shell (Tingkat Pemula)**

> **Prasyarat:** Tidak ada. Cocok untuk pemula yang belum pernah menyentuh terminal.
> **Estimasi waktu:** 6–8 jam (teori + latihan).
> **Target lingkungan:** Arch Linux, Ubuntu/Debian, Fedora, macOS, atau Windows via WSL2/Git Bash.
> **Setelah menyelesaikan fase ini**, Anda akan mampu: menavigasi sistem berkas, mengalirkan data antar perintah, menulis skrip pertama, memakai variabel, menerima argumen, dan menangani kesalahan dasar.

---

## 📑 Daftar Isi Fase 1

- [Modul 1.1 — Fondasi: Berinteraksi dengan Shell](#modul-11--fondasi-berinteraksi-dengan-shell)
- [Modul 1.2 — Perintah Fundamental & I/O Redirection](#modul-12--perintah-fundamental--io-redirection)
- [Modul 1.3 — Skrip Pertama, Variabel, dan Ekspansi](#modul-13--skrip-pertama-variabel-dan-ekspansi)
- [Lampiran A — Kamus Simbol Shell Lengkap](#lampiran-a--kamus-simbol-shell-lengkap)
- [Lampiran B — POSIX vs Bash vs Zsh](#lampiran-b--posix-vs-bash-vs-zsh)
- [Lampiran C — Variabel Bawaan Shell dan Lingkungan](#lampiran-c--variabel-bawaan-shell-dan-lingkungan)
- [Lampiran D — Pesan Error Umum dan Solusinya](#lampiran-d--pesan-error-umum-dan-solusinya)
- [Lampiran E — Referensi](#lampiran-e--referensi)

---

## **Modul 1.1 — Fondasi: Berinteraksi dengan Shell**

### 🎯 Tujuan Modul

Setelah menyelesaikan modul ini, Anda akan mampu:

1. Menjelaskan perbedaan **terminal**, **shell**, **kernel**, dan **konsol**.
2. Menjelaskan filosofi Unix dan mengapa ia relevan hingga kini.
3. Mengenali shell yang Anda gunakan (bukan sekadar `$SHELL`).
4. Menavigasi sistem berkas dengan `pwd`, `ls`, `cd`.
5. Mencari bantuan dengan `man`, `--help`, `-h`, dan `help` builtin.
6. Menjelaskan apa itu POSIX dan mengapa ia penting.

---

### 1.1.1 Sejarah Singkat Unix dan Shell

Pada 1969–1970, Ken Thompson dan Dennis Ritchie di Bell Labs mengembangkan **Unix** sebagai sistem operasi kecil, modular, dan multiuser. Salah satu warisan terbesarnya adalah **shell** — program yang membaca perintah pengguna dan memintanya dijalankan oleh kernel.

Evolusi shell:

| Tahun | Shell | Catatan |
|-------|-------|---------|
| 1971 | `sh` (Thompson shell) | Shell Unix pertama |
| 1977 | Bourne shell (`sh`) | Cikal bakal POSIX shell modern |
| 1978 | C shell (`csh`) | Sintaks mirip C, job control |
| 1983 | Korn shell (`ksh`) | Gabungan `sh` + `csh` |
| 1989 | Bash (`bash`) | Bourne-Again Shell, GNU, POSIX + ekstensi |
| 1990 | Zsh (`zsh`) | Ekstensi Bash + globbing kaya |
| 2005 | Fish (`fish`) | **Bukan** POSIX, sintaks berbeda |

Shell modern seperti **Bash**, **Zsh**, dan **Ksh** adalah **turunan** atau **pengembangan** dari standar POSIX. **Fish bukan turunan POSIX** dan tidak dapat dijalankan dalam mode POSIX.
> [RINGKASAN TEKNIS: PENGENALAN SHELL PADA SISTEM UNIX-LIKE - sh, Bash, Dash, dan Zsh](./posix.md)

---

### 1.1.2 Terminal, Konsol, Shell, dan Kernel

Banyak pemula mengira “terminal”, “konsol”, “shell”, dan “kernel” adalah hal yang sama. Padahal keempatnya berbeda.

| Istilah | Apa Itu | Contoh |
|---------|---------|--------|
| **Kernel** | Inti sistem operasi; mengelola CPU, memori, perangkat I/O | Linux kernel, Darwin kernel (macOS) |
| **Shell** | Program *interpreter* yang membaca dan mengeksekusi perintah | `bash`, `zsh`, `sh`, `dash`, `ksh`, `fish` |
| **Terminal (emulator)** | Aplikasi yang menyediakan antarmuka teks ke shell | GNOME Terminal, Konsole, iTerm2, Windows Terminal, VS Code Terminal |
| **Konsol** | Terminal fisik langsung terhubung ke sistem (tty) | `/dev/tty1`–`/dev/tty6` di Linux |

**Analogi:** Mobil = sistem operasi. Mesin = kernel. Dashboard + setir = shell. Kerangka Mobil = terminal. Baris perintah = kendali anda.

**Alur eksekusi perintah:**

```
Anda mengetik  →  Terminal  →  Shell (parse)  →  Kernel  →  Perangkat keras
                ←  Terminal  ←  Shell          ←  Kernel  ←
```

#### Bagaimana Shell Bekerja (Step by Step)

Misalkan Anda mengetik `ls -l /home`:

1. Shell membaca baris perintah.
2. Shell melakukan **parsing**: memecah menjadi kata (`ls`, `-l`, `/home`).
3. Shell melakukan **ekspansi** (variabel, glob, command substitution).
4. Shell mencari program `ls` di direktori yang ada di `$PATH`.
5. Shell meminta kernel mengeksekusi `ls` dengan argumen `-l` lalu nilainya `/home`.
6. Kernel menjalankan proses, output dikirim kembali ke shell.
7. Shell menampilkan output ke terminal dan menunggu perintah berikutnya.

---

### 1.1.3 Filosofi Unix

Filosofi ini dirumuskan oleh Ken Thompson, Dennis Ritchie, dan Douglas McIlroy. Menjadi dasar cara berpikir “ala Unix”.

#### **1. Tulis program yang melakukan satu hal dan melakukannya dengan baik.**

- `grep` hanya mencari teks; tidak mengurutkan atau mengedit.
- `sort` hanya mengurutkan; tidak mencari.
- **Analogi:** Pisau tajam, mixer, dan oven — masing-masing satu tugas, semua berkualitas.
- **Relevansi:** Mirip *Single Responsibility Principle* dalam OOP dan pemecahan widget di Flutter.

#### **2. Tulis program yang bekerja bersama.**

- Output satu program bisa menjadi input program lain lewat *pipe* (`|`) dan *redirection* (`>`, `<`).
- **Analogi:** Bahan dipotong pisau → dimasukkan ke mixer → adonan masuk oven.
- **Relevansi:** Dasar dari *composable software*, *microservices*, dan *data pipeline*.

#### **3. Tulis program untuk menangani aliran teks, karena itu adalah antarmuka universal.**

- Data antar program berupa teks biasa — mudah di-*parse*, di-*debug*, dan ditransfer.
- **Analogi:** Bahasa Inggris dalam diplomasi internasional.
- **Relevansi:** Log sistem, file konfigurasi, output CLI, dan *streaming data* masih berbasis teks.

#### **4. Kesederhanaan lebih baik daripada kerumitan.**

Kode kecil, jelas, dan dapat dibaca jauh lebih bernilai daripada kode pintar tapi tidak terbaca.

#### **5. Modularitas lebih baik daripada monolitik.**

Bangun dari komponen kecil yang dapat dikombinasikan, bukan satu program besar.

> 📚 Referensi lengkap: [The Art of Unix Programming, Eric S. Raymond](http://www.catb.org/~esr/writings/taoup/html/)

---

### 1.1.4 Mengenali Shell Anda

Cara yang **sering diajarkan tetapi kurang akurat**:

```bash
echo $SHELL
# /bin/bash  atau  /bin/zsh
```

> ⚠️ **Peringatan:** `$SHELL` menunjuk ke **login shell**, bukan shell yang sedang berjalan. Jika Anda menjalankan `bash` dari dalam `zsh`, `$SHELL` tetap menunjukkan `/bin/zsh`.

Cara yang **lebih akurat**:

```bash
# 1. Nama shell yang sedang berjalan
echo "$0"
# bash

# 2. Nama proses shell saat ini
ps -o comm= -p $$

# 3. Versi shell
bash --version | head -n1
zsh --version

# 4. Lokasi executable shell
command -v bash
command -v zsh
```

> **Alternatif `which`:** `which` bukan utilitas POSIX dan bisa berbeda perilakunya di berbagai sistem. Gunakan `command -v` atau `type` untuk hasil portabel:
> ```bash
> command -v ls       # /usr/bin/ls
> type ls             # ls is /usr/bin/ls
> type cd             # cd is a shell builtin
> ```

---

### 1.1.5 Navigasi Dasar Sistem Berkas

| Perintah | Fungsi | Contoh |
|----------|--------|--------|
| `pwd` | Print Working Directory | `pwd` → `/home/user` |
| `ls` | List isi direktori | `ls -la` |
| `cd` | Change Directory | `cd /etc`, `cd ..`, `cd ~`, `cd -` |

**Opsi umum `ls`:**

| Opsi | Fungsi |
|------|--------|
| `-l` | Format panjang (izin, pemilik, ukuran, tanggal) |
| `-a` | Tampilkan file tersembunyi (diawali `.`) |
| `-h` | Ukuran human-readable (`1K`, `2M`) |
| `-R` | Rekursif |
| `-t` | Urut berdasarkan waktu |
| `-S` | Urut berdasarkan ukuran |

**Path spesial:**

| Simbol | Arti |
|--------|------|
| `.` | Direktori saat ini |
| `..` | Direktori induk |
| `~` | Direktori home user |
| `~user` | Direktori home user lain |
| `-` | Direktori sebelumnya (khusus `cd -`) |
| `/` | Root direktori |

**Membaca `ls -l`:**

```
-rwxr-xr-- 1 alice dev  4096 Jan 12 10:00 script.sh
│└┬┘└┬┘└┬┘ │  │    │    │    │             │
│ │  │  │  │  │    │    │    │             └─ nama
│ │  │  │  │  │    │    │    └─ waktu modifikasi
│ │  │  │  │  │    │    └─ ukuran byte
│ │  │  │  │  │    └─ grup
│ │  │  │  │  └─ pemilik
│ │  │  │  └─ jumlah hard link
│ │  │  └─ izin others: r--
│ │  └─ izin group: r-x
│ └─ izin owner: rwx
└─ tipe file: - (file biasa), d (direktori), l (symlink),
   s (socket), b (block), c (character), p (pipe)
```

---

### 1.1.6 Mendapatkan Bantuan

#### **`man` — Manual Pages**

```bash
man ls
man 5 passwd   # seksi 5 = format file
man 3 printf   # seksi 3 = library C
```

| Seksi | Isi |
|-------|-----|
| 1 | Perintah user |
| 2 | System calls |
| 3 | Library functions |
| 5 | Format file / konvensi |
| 7 | Overview / misc |
| 8 | Perintah admin |

**Navigasi di `man`:**
- `↑`/`↓` atau `j`/`k` — gulir baris
- `Space`/`Page Down` — gulir halaman
- `/pola` — cari ke depan
- `n` / `N` — hasil cari berikutnya / sebelumnya
- `g` / `G` — ke awal / akhir
- `q` — keluar

#### **`--help` / `-h`**

Banyak program GNU mendukung `--help`:

```bash
ls --help
grep --help
```

> ⚠️ **Catatan:** Tidak semua program mendukung `--help`. `-h` juga tidak selalu berarti "help"; pada `ls`, `-h` berarti *human-readable*. Selalu baca `man` untuk memastikan.

#### **`help` — Builtin Bash**

Beberapa perintah adalah **builtin** shell (bagian dari shell, bukan program eksternal). Untuk itu, gunakan `help`:

```bash
help cd
help echo
help test
```

Cek apakah sebuah perintah builtin:

```bash
type cd       # cd is a shell builtin
type echo     # echo is a shell builtin
type ls       # ls is /usr/bin/ls
```

#### **`info` — Dokumentasi GNU**

```bash
info coreutils
info bash
```

#### **`apropos` / `whatis`**

```bash
whatis ls             # deskripsi singkat
apropos "copy file"   # cari perintah berdasarkan kata kunci
```

#### **`tldr` — Contoh Praktis (opsional)**

```bash
# Install: sudo pacman -S tldr  atau  npm i -g tldr
tldr tar
```

---

### 1.1.7 File Startup Shell

Shell membaca file konfigurasi saat dijalankan:

| Shell | Login shell | Interactive non-login |
|-------|-------------|-----------------------|
| Bash | `/etc/profile`, `~/.bash_profile`, `~/.bash_login`, `~/.profile` | `~/.bashrc` |
| Zsh | `/etc/zprofile`, `~/.zprofile`, `~/.zshrc` | `~/.zshrc` |
| POSIX `sh` | `/etc/profile`, `~/.profile` | `$ENV` |

**Muat ulang `.bashrc` tanpa logout:**

```bash
source ~/.bashrc
# atau
. ~/.bashrc
```

**Jenis shell:**

| Jenis | Definisi | Contoh |
|-------|----------|--------|
| Login | Dimulai saat login (tty, SSH, `bash -l`) | Membaca `.bash_profile` |
| Interactive non-login | Terminal emulator baru | Membaca `.bashrc` |
| Non-interactive | Skrip yang dijalankan | Tidak membaca file startup interaktif |

---

### 1.1.8 Apa Itu POSIX dan Mengapa Penting

**POSIX** (*Portable Operating System Interface*) adalah standar IEEE (Std 1003.1) yang menjamin kompatibilitas antar sistem Unix-like. Untuk shell scripting, POSIX menentukan:

- Sintaks dasar skrip (`if`, `case`, `for`, `while`).
- Perilaku *builtin* (`echo`, `test`, `read`, `set`, `trap`).
- Himpunan utilitas standar (`ls`, `cp`, `mv`, `grep`, `sed`, `awk`).
- Ekspansi parameter, redirection, pipe, dan sebagainya.

Skrip yang **POSIX-compliant** berjalan di semua shell POSIX: `sh`, `dash`, `ksh`, `bash --posix`, `zsh --emulate sh`.

> **Catatan penting:** `dash` (Debian/Ubuntu) dan `bash` bukan shell yang sama. Di Debian/Ubuntu, `/bin/sh` adalah symlink ke `dash`. Skrip yang mengandalkan `[[ ]]` atau array **akan gagal** di sana.

#### POSIX Shell Specification (Ringkasan)

| Aspek | Yang Diatur POSIX |
|-------|-------------------|
| Sintaks | `if/then/elif/else/fi`, `case/esac`, `for`, `while`, `until` |
| Builtin | `test`, `echo`, `read`, `set`, `trap`, `cd`, `pwd`, `umask`, `eval`, `exec`, `exit`, `export`, `readonly`, `return`, `shift`, `times`, `type`, `ulimit`, `unset`, `wait`, `.`, `:` |
| Ekspansi | `$VAR`, `${VAR}`, `$(cmd)`, `` `cmd` ``, `$(( ))`, `~`, `{a,b}` (brace)** |
| Redirection | `>`, `>>`, `<`, `2>`, `2>&1`, `|`, `<<` (here-doc) |
| Utilitas | `ls`, `cp`, `mv`, `rm`, `mkdir`, `chmod`, `grep` (BRE), `sed`, `awk`, `sort`, `uniq`, `head`, `tail`, `wc`, `find`, `xargs`, `test` |

> **Brace expansion `{a,b}` bukan POSIX.** Yang POSIX adalah *curly bracket pattern* di `case`, bukan `{a,b,c}`. Baca lebih lanjut tentang [POSIX][posix]

---

### 1.1.9 Latihan Modul 1.1

1. Jalankan `echo "$0"`, `ps -o comm= -p $$`, dan `echo $SHELL`. Apakah ketiganya menghasilkan hal sama? Jelaskan mengapa.
2. Gunakan `man ls` untuk mencari arti opsi `-i`, `-h`, dan `-r`.
3. Gunakan `help cd` untuk mencari arti `cd -`.
4. Tampilkan semua file (termasuk tersembunyi) di `/etc` dalam format panjang dan human-readable.
5. Gunakan `type` pada: `cd`, `ls`, `echo`, `printf`, `test`. Mana yang builtin?
6. Jalankan `command -v` pada `ls`, `grep`, dan `python3`. Apa bedanya dengan `which`?

**Solusi singkat:**
1. `$SHELL` = login shell; `$0` dan `ps -p $$` = shell saat ini. Bisa berbeda.
2. `man ls` → cari `/OPTIONS`.
3. `help cd` → `cd -` kembali ke direktori sebelumnya.
4. `ls -lah /etc`
5. `cd`, `echo`, `printf`, `test` adalah builtin (sebagian shell juga punya versi eksternal); `ls` eksternal.
6. `command -v` sesuai POSIX dan bekerja untuk builtin maupun eksternal.

---

## **Modul 1.2 — Perintah Fundamental & I/O Redirection**

### 🎯 Tujuan Modul

1. Memahami **standard streams**: `stdin`, `stdout`, `stderr`.
2. Menguasai redirection `>`, `>>`, `<`, `2>`, `2>&1`, `&>`, `<>`.
3. Menguasai **pipe** (`|`) dan `|&`.
4. Menguasai **here-document** (`<<`) dan **here-string** (`<<<`).
5. Menggunakan perintah teks esensial: `cat`, `grep`, `head`, `tail`, `wc`, `sort`, `uniq`, `cut`, `tr`, `tee`, `xargs`.

---

### 1.2.1 Standard Streams

Setiap proses di Unix memiliki tiga saluran I/O standar:

| Stream | Deskripsi | File Descriptor | Default |
|--------|-----------|-----------------|---------|
| `stdin` | Input standar | `0` | Keyboard |
| `stdout` | Output standar | `1` | Terminal |
| `stderr` | Error standar | `2` | Terminal |

```
                   +-------------------+
                   |      Program      |
                   |                   |
Keyboard ─(0 stdin)→│                   │─(1 stdout)→ Terminal
                   │                   │─(2 stderr)→ Terminal
                   +-------------------+
```

**Mengapa `stdout` dan `stderr` dipisah?**
Agar output normal bisa dialihkan ke file atau pipe, sementara pesan error tetap terlihat di layar (atau bisa dialihkan terpisah ke file log).

---

### 1.2.2 Output Redirection

| Operator | Nama | Fungsi |
|----------|------|--------|
| `>` | redirect stdout (overwrite) | Timpa isi file |
| `>>` | append stdout | Tambahkan ke akhir file |
| `1>` | sama dengan `>` | Eksplisit untuk fd 1 |
| `>|` | force overwrite (Bash) | Timpa meski `set -C` aktif |
| `&>` | redirect stdout + stderr (Bash/Zsh) | Gabung keduanya ke file |
| `&>>` | append stdout + stderr (Bash) | Gabung dan tambahkan |

**Contoh:**

```bash
echo "Hello" > output.txt          # timpa
echo "World" >> output.txt         # tambahkan
ls -l /etc > daftar.txt
date >> daftar.txt
```

> ⚠️ **Bahaya:** `>` akan **menghapus** isi file tanpa konfirmasi. Berhati-hatilah. Untuk mencegah overwrite tanpa sengaja, aktifkan `set -C` (noclobber):
> ```bash
> set -C
> echo "x" > file.txt    # error jika file sudah ada
> echo "x" >| file.txt   # paksa timpa
> ```

---

### 1.2.3 Input Redirection

| Operator | Nama | Fungsi |
|----------|------|--------|
| `<` | redirect stdin | Baca input dari file |
| `<>` | read-write | Buka file untuk baca dan tulis |
| `<<` | here-document | Kirim blok teks sebagai stdin |
| `<<<` | here-string (Bash/Zsh) | Kirim satu string sebagai stdin |

**Contoh:**

```bash
wc -l < file.txt               # hitung baris dari file

# Here-document: kirim blok teks sampai penanda
cat <<EOF
Halo, $USER!
Hari ini adalah $(date +%A).
EOF

# Here-document dengan tab-strip (<<-)
cat <<-EOF
	Baris dengan tab di depan akan dihapus tabnya.
EOF

# Here-string
grep "root" <<< "user1
root
user2"
```

---

### 1.2.4 Pipes

**Pipe (`|`)** mengambil `stdout` perintah kiri, mengirim sebagai `stdin` perintah kanan.

```bash
ls | grep "txt"
cat access.log | grep "ERROR" | wc -l
ps aux | sort -k3 -n | tail -n5     # 5 proses dengan CPU tertinggi
```

**`|&` (Bash 4+):** Pipe `stdout` **dan** `stderr` sekaligus.

```bash
make |& tee build.log
```

**Diagram:**

```
+-----------+   stdout    +-----------+   stdout    +-----------+
| Command A | ──────────→ | Command B | ──────────→ | Command C |
+-----------+   (pipe)    +-----------+   (pipe)    +-----------+
```

> ⚠️ **Catatan:** Pipe hanya mengalirkan `stdout`. Untuk `stderr`, gabungkan dulu dengan `2>&1`.
>
> ```bash
> find / -name "*.conf" 2>&1 | grep "network"
> ```

---

### 1.2.5 Menggabungkan dan Mengalihkan Stream

| Operator | Fungsi |
|----------|--------|
| `2>file` | Redirect `stderr` ke file |
| `2>>file` | Append `stderr` |
| `2>&1` | Arahkan `stderr` ke tempat `stdout` |
| `1>&2` | Arahkan `stdout` ke tempat `stderr` |
| `&>file` | `stdout` + `stderr` ke file (Bash) |
| `n>&-` | Tutup fd `n` |
| `3>file` | Buka fd 3 ke file |

**Urutan itu penting:**

```bash
# BENAR: stdout dan stderr sama-sama ke file
command > out.log 2>&1

# SALAH: stderr ke terminal, stdout ke file
command 2>&1 > out.log
```

**Mengapa?** Redirection diproses kiri ke kanan.
1. `2>&1` → stderr menunjuk ke tempat stdout saat ini (terminal).
2. `> out.log` → stdout dipindah ke file. stderr tetap di terminal.

**Custom file descriptor:**

```bash
exec 3> custom.log
echo "ke fd 3" >&3
exec 3>&-   # tutup
```

**`tee` — salin ke layar dan file sekaligus:**

```bash
ls -l | tee output.txt
ls -l | tee -a output.txt    # append
ls -l | tee output.txt | grep ".sh"
```

---

### 1.2.6 Perintah Teks Esensial

| Perintah | Fungsi | Contoh |
|----------|--------|--------|
| `cat` | Concat & print file | `cat file.txt`, `cat file1 file2` |
| `grep` | Filter pola (regex) | `grep "root" /etc/passwd` |
| `head` | Baris awal | `head -n5 file.txt` |
| `tail` | Baris akhir | `tail -f log.txt` |
| `wc` | Hitung baris/kata/byte | `wc -l file.txt` |
| `sort` | Urutkan | `sort -n`, `sort -r`, `sort -k2` |
| `uniq` | Hapus duplikat berurutan | `sort file | uniq -c` |
| `cut` | Potong kolom | `cut -d: -f1 /etc/passwd` |
| `tr` | Translasi karakter | `tr 'a-z' 'A-Z'` |
| `tee` | Salin ke stdout & file | `cmd | tee log` |
| `xargs` | Bangun argumen dari stdin | `find . -name "*.tmp" | xargs rm` |
| `sed` | Editor stream | `sed 's/foo/bar/g'` |
| `awk` | Pemroses teks per kolom | `awk '{print $1, $3}'` |

**Contoh kombinasional:**

```bash
# 5 user terakhir dari /etc/passwd, diurutkan
cut -d: -f1 /etc/passwd | sort | tail -n5

# Hitung jumlah baris log dengan ERROR
grep "ERROR" app.log | wc -l

# Tampilkan 10 IP tersering di access.log
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head

# Hapus file .tmp secara aman
find . -name "*.tmp" -print0 | xargs -0 rm

# Ganti teks pada banyak file
sed -i 's/foo/bar/g' *.txt
```

---

### 1.2.7 Latihan Modul 1.2

1. Tampilkan 5 baris pertama `/etc/passwd`, lalu 5 baris terakhir.
2. Hitung berapa banyak user yang shell-nya `/bin/bash`.
3. Salin output `ls -la /etc` ke `etc-list.txt`, dan pesan error ke `etc-error.txt`.
4. Cari file `.conf` di `/etc` (rekursif) dan tampilkan tanpa pesan “permission denied”.
5. Tampilkan 10 perintah yang paling sering Anda gunakan (petunjuk: `history | awk '{print $2}' | sort | uniq -c | sort -rn | head`).
6. Gunakan `tee` untuk menyimpan output `ls -l` ke file **dan** menampilkannya di layar.

**Contoh solusi:**

```bash
# 1
head -n5 /etc/passwd; echo "---"; tail -n5 /etc/passwd

# 2
grep -c '/bin/bash$' /etc/passwd

# 3
ls -la /etc > etc-list.txt 2> etc-error.txt

# 4
find /etc -name "*.conf" 2>/dev/null

# 5
history | awk '{print $2}' | sort | uniq -c | sort -rn | head

# 6
ls -l | tee ls-output.txt
```

---

## **Modul 1.3 — Skrip Pertama, Variabel, dan Ekspansi**

### 🎯 Tujuan Modul

1. Membuat skrip Bash pertama dengan shebang yang benar.
2. Mengatur izin eksekusi dengan `chmod`.
3. Menjalankan skrip dari path relatif dan absolut.
4. Mendefinisikan, membaca, dan menghapus variabel.
5. Menggunakan variabel bawaan shell dan lingkungan.
6. Menerima argumen baris perintah dan memprosesnya.
7. Membaca input interaktif dengan `read`.
8. Memeriksa dan menetapkan exit status.
9. Memahami urutan shell expansion.

---

### 1.3.1 Shebang (`#!`)

Shebang adalah baris pertama skrip yang memberi tahu kernel interpreter apa yang harus dipakai.

| Shebang | Arti | Portabilitas |
|---------|------|--------------|
| `#!/bin/bash` | Bash absolut | Kurang portabel (tidak semua sistem punya `/bin/bash`) |
| `#!/usr/bin/env bash` | Cari `bash` dari `$PATH` | **Direkomendasikan** untuk Bash |
| `#!/bin/sh` | POSIX shell absolut | Portabel di sistem Unix |
| `#!/usr/bin/env sh` | Cari `sh` dari `$PATH` | Lebih portabel |
| `#!/usr/bin/env zsh` | Cari `zsh` dari `$PATH` | Untuk skrip Zsh |
| `#!/usr/bin/env python3` | Cari `python3` | Untuk skrip Python |

**Aturan:**
- Shebang **wajib** ada di baris pertama (boleh didahului BOM tapi hindari BOM).
- Path interpreter di shebang **selalu absolut** (`/bin/bash`, `/usr/bin/env`).
- Jika memakai `env`, path `env` absolut (`/usr/bin/env` atau `/bin/env`), tapi argumen setelahnya (`bash`) dicari di `$PATH`.

**Kapan pakai apa?**

- Untuk **skrip POSIX murni** (portabel): `#!/bin/sh` atau `#!/usr/bin/env sh`.
- Untuk **skrip Bash modern** (pakai `[[ ]]`, array): `#!/usr/bin/env bash`.
- Untuk **skrip Arch/Debian personal**: `#!/bin/bash` juga oke karena `/bin/bash` hampir selalu ada.

---

### 1.3.2 Membuat dan Menjalankan Skrip

Buat file `halo.sh`:

```bash
#!/usr/bin/env bash
# Skrip pertama: mencetak salam
echo "Halo, dunia!"
```

**Berikan izin eksekusi:**

```bash
chmod u+x halo.sh
```

**Jalankan:**

```bash
./halo.sh               # path relatif
~/scripts/halo.sh       # path absolut dengan ~
bash halo.sh            # paksa pakai bash (mengabaikan shebang)
sh halo.sh              # paksa pakai sh
```

**Arti izin `chmod`:**

| Simbol | Arti |
|--------|------|
| `u` | user (pemilik) |
| `g` | group |
| `o` | others |
| `a` | all |
| `+` | tambah izin |
| `-` | hapus izin |
| `=` | set izin persis |
| `r` | read (4) |
| `w` | write (2) |
| `x` | execute (1) |

Contoh:

```bash
chmod u+x script.sh       # pemilik boleh eksekusi
chmod 755 script.sh       # rwxr-xr-x
chmod 644 file.txt        # rw-r--r--
chmod +x script.sh        # tambah execute untuk semua yang diizinkan umask
```

---

### 1.3.3 Variabel: Definisi, Penggunaan, dan Nilai Default

#### **Mendefinisikan Variabel**

```bash
NAMA="Alice"              # string
USIA=30                   # string berisi digit
PESAN="Halo, $NAMA!"      # interpolasi
```

> ⚠️ **Tidak ada spasi** di sekitar `=`! `NAMA = "Alice"` akan error:
> ```
> bash: NAMA: command not found
> ```

#### **Membaca Variabel**

```bash
echo "$NAMA"              # Alice
echo "${NAMA}"            # Alice (lebih aman)
echo "Nama: ${NAMA}_x"    # Nama: Alice_x
echo "Nama: $NAMA_x"      # Nama: (kosong) → salah, $NAMA_x dianggap variabel
```

#### **Menghapus Variabel**

```bash
unset NAMA
```

#### **Mode Read-only**

```bash
readonly KONSTANTA="nilai tetap"
KONSTANTA="ubah"          # error: KONSTANTA: readonly variable
```

#### **Variabel Lokal (di dalam fungsi)**

```bash
fungsi() {
    local VAR="lokal"
    echo "$VAR"
}
```

#### **Nilai Default dan Alternatif (Parameter Expansion)**

Ini adalah fitur **sangat penting** yang sering dilupakan pemula.

| Sintaks | Arti | Contoh |
|---------|------|--------|
| `${VAR:-default}` | Pakai `default` jika `VAR` kosong/tidak diset | `${USER:-tamu}` |
| `${VAR:=default}` | Set `VAR` ke `default` jika kosong, lalu pakai | `${CONFIG:=/etc/app.conf}` |
| `${VAR:?pesan}` | Error dan keluar jika `VAR` kosong | `${HOME:?HOME tidak diset}` |
| `${VAR:+alternatif}` | Pakai `alternatif` jika `VAR` **diset** | `${VERBOSE:+v}` |
| `${#VAR}` | Panjang string | `${#NAMA}` |
| `${VAR#pola}` | Hapus prefix terpendek | `${file#*/}` |
| `${VAR##pola}` | Hapus prefix terpanjang | `${path##*/}` → basename |
| `${VAR%pola}` | Hapus suffix terpendek | `${file%.txt}` |
| `${VAR%%pola}` | Hapus suffix terpanjang | `${path%%/*}` → dirname |
| `${VAR/POLA/ganti}` | Ganti pertama | `${satu/foo/bar}` |
| `${VAR//POLA/ganti}` | Ganti semua | `${satu//foo/bar}` |
| `${VAR:2:3}` | Substring mulai dari 2, panjang 3 | `${kata:0:5}` |
| `${VAR^^}` | Huruf besar semua (Bash) | `${kata^^}` |
| `${VAR,,}` | Huruf kecil semua (Bash) | `${kata,,}` |

**Contoh praktis:**

```bash
#!/usr/bin/env bash

# Nilai default
NAMA="${1:-Pengguna}"
echo "Halo, $NAMA!"

# Set dan pakai
LOG="${LOG_FILE:=/var/log/app.log}"
echo "Log ke: $LOG"

# Wajib diisi
: "${DATABASE_URL:?DATABASE_URL wajib diisi!}"

# Basename & dirname
PATHFILE="/home/user/dokumen.txt"
echo "${PATHFILE##*/}"    # dokumen.txt
echo "${PATHFILE%/*}"     # /home/user
echo "${PATHFILE%.txt}"   # /home/user/dokumen

# Panjang string
echo "Panjang: ${#NAMA}"

# Ganti
TEKS="halo halo dunia"
echo "${TEKS//halo/hai}"  # hai hai dunia

# Huruf besar/kecil
echo "${TEKS^^}"          # HALO HALO DUNIA
```

#### **Ekspansi Aritmatika**

```bash
A=10
B=3
echo $((A + B))       # 13
echo $((A * B))       # 30
echo $((A / B))       # 3 (integer)
echo $((A % B))       # 1
((A++))               # A=11
((A += 5))            # A=16
```

Untuk float, gunakan `bc` atau `awk`:

```bash
echo "scale=2; 10/3" | bc
awk 'BEGIN {printf "%.2f\n", 10/3}'
```

#### **Array (Bash, bukan POSIX)**

```bash
buah=("apel" "jeruk" "mangga")
echo "${buah[0]}"        # apel
echo "${buah[@]}"        # semua elemen
echo "${#buah[@]}"       # jumlah elemen
buah+=("pisang")         # tambah
for b in "${buah[@]}"; do echo "$b"; done
```

#### **Associative Array (Bash 4+)**

```bash
declare -A warna
warna[merah]="#ff0000"
warna[hijau]="#00ff00"
echo "${warna[merah]}"
```

---

### 1.3.4 Variabel Lingkungan

Variabel lingkungan diwariskan ke proses anak. Variabel shell biasa tidak.

```bash
export API_KEY="rahasia"
```

| Perintah | Fungsi |
|----------|--------|
| `export VAR=value` | Set & ekspor |
| `export -n VAR` | Batalkan ekspor |
| `export -p` | Tampilkan semua yang diekspor |
| `env` | Tampilkan lingkungan |
| `printenv HOME` | Cetak satu variabel |

**Contoh membaca environment di skrip:**

```bash
#!/usr/bin/env bash
echo "Home   : $HOME"
echo "User   : $USER"
echo "Shell  : $SHELL"
echo "PATH   : $PATH"
echo "PWD    : $PWD"
```

---

### 1.3.5 Argumen Baris Perintah

| Variabel | Arti |
|----------|------|
| `$0` | Nama skrip |
| `$1`..`$9` | Argumen posisi (di luar 9 perlu `${10}`) |
| `${10}` | Argumen ke-10 |
| `$#` | Jumlah argumen (tanpa `$0`) |
| `$@` | Semua argumen sebagai daftar terpisah |
| `$*` | Semua argumen sebagai satu string |
| `$$` | PID shell saat ini |
| `$!` | PID proses background terakhir |
| `$?` | Exit status perintah terakhir |
| `$_` | Argumen terakhir perintah sebelumnya |

**Contoh:**

```bash
#!/usr/bin/env bash
echo "Skrip: $0"
echo "Jumlah argumen: $#"
echo "Argumen 1: ${1:-<kosong>}"
echo "Semua (\"\$@\"):"
for arg in "$@"; do
    echo "  - $arg"
done
```

**Perbedaan `$@` vs `$*`:**

```bash
# Dijalankan: ./skrip.sh "a b" c
# "$@" → "a b" dan "c"  (dua argumen, aman)
# "$*" → "a b c"        (satu string, hilang batas)
```

> **Praktik terbaik:** Selalu gunakan `"$@"` (dengan kutip) untuk meneruskan argumen.

**`shift` — geser argumen:**

```bash
#!/usr/bin/env bash
while [ $# -gt 0 ]; do
    echo "Argumen: $1"
    shift
done
```

**Parsing opsi sederhana dengan `getopts`:**

```bash
#!/usr/bin/env bash
while getopts "hv:f:" opt; do
    case "$opt" in
        h) echo "Bantuan"; exit 0 ;;
        v) VERBOSE="$OPTARG" ;;
        f) FILE="$OPTARG" ;;
        *) echo "Opsi tidak dikenal" >&2; exit 1 ;;
    esac
done
```

---

### 1.3.6 Input Interaktif: `read`

```bash
#!/usr/bin/env bash

read -p "Nama Anda: " NAMA
echo "Halo, $NAMA"

# Dengan timeout
if read -t 5 -p "Ketik sesuatu dalam 5 detik: " RESP; then
    echo "Anda mengetik: $RESP"
else
    echo "Waktu habis."
fi

# Tanpa menampilkan input (password)
read -s -p "Password: " PW
echo

# Baca per baris dari file
while IFS= read -r line; do
    echo "Baris: $line"
done < file.txt
```

| Opsi | Fungsi |
|------|--------|
| `-p "prompt"` | Tampilkan prompt (Bash) |
| `-s` | Silent (tanpa echo) |
| `-t N` | Timeout N detik |
| `-n N` | Baca N karakter |
| `-r` | Raw mode (jangan interpretasi `\`) |
| `-a arr` | Baca ke array |

---

### 1.3.7 Exit Status

Setiap perintah mengembalikan exit status `0`–`255`:

- `0` = sukses
- `1`–`125` = kesalahan (bebas sesuai program)
- `126` = tidak dapat dieksekusi (izin)
- `127` = perintah tidak ditemukan
- `128` = exit dengan sinyal tidak valid
- `128+N` = dihentikan sinyal N (mis. `130` = Ctrl+C / SIGINT)
- `255` = kesalahan keluar di luar rentang

**Cek exit status:**

```bash
ls /etc
echo "$?"

ls /tidak/ada 2>/dev/null
echo "$?"        # 2
```

**Set exit status eksplisit:**

```bash
exit 0           # sukses
exit 1           # gagal
```

**Praktik aman di awal skrip:**

```bash
#!/usr/bin/env bash
set -euo pipefail
```

| Opsi | Arti |
|------|------|
| `-e` | Keluar jika perintah gagal (dengan pengecualian) |
| `-u` | Error jika variabel tak terdefinisi |
| `-o pipefail` | Exit status pipeline = kegagalan pertama di pipe |

**Catatan penting:** `set -e` memiliki jebakan — tidak berlaku pada perintah di dalam kondisi `if`, `&&`, `||`, `!`, atau perintah dengan `until/while`.

---

### 1.3.8 Shell Expansion (Urutan Lengkap)

Bash memproses baris perintah melalui tahap-tahap berikut **secara berurutan**:

1. **Brace expansion** — `{a,b,c}` → `a b c`
2. **Tilde expansion** — `~` → `/home/user`
3. **Parameter expansion** — `$VAR`, `${VAR}`
4. **Command substitution** — `$(cmd)` atau `` `cmd` ``
5. **Arithmetic expansion** — `$((1+2))`
6. **Word splitting** — pisah dengan `$IFS` (default: spasi, tab, newline)
7. **Pathname expansion (globbing)** — `*.txt`, `?`, `[abc]`
8. **Quote removal** — hapus kutip yang tidak di-escape

#### **Brace Expansion**

```bash
echo {a,b,c}              # a b c
echo file{1..3}.txt       # file1.txt file2.txt file3.txt
echo {A..E}               # A B C D E
mkdir -p project/{src,test,docs}
```

#### **Tilde Expansion**

```bash
echo ~                    # /home/user
echo ~root                # /root
cd ~/dokumen
```

#### **Parameter Expansion**

```bash
echo "$NAMA"
echo "${NAMA:-default}"
```

#### **Command Substitution**

```bash
TANGGAL=$(date +%Y-%m-%d)
echo "Hari ini: $TANGGAL"

JUMLAH=$(ls | wc -l)
echo "Ada $JUMLAH file"
```

#### **Arithmetic Expansion**

```bash
echo $(( 5 * 3 ))
A=10; B=20; echo $(( A + B ))
```

#### **Word Splitting**

```bash
VAR="a b c"
for x in $VAR; do echo "$x"; done     # a\nb\nc (terpisah)
for x in "$VAR"; do echo "$x"; done   # a b c (satu string)
```

> ⚠️ **Praktik terbaik:** Selalu kutip `"$VAR"` kecuali Anda memang menginginkan word splitting.

#### **Pathname Expansion (Globbing)**

| Pola | Arti |
|------|------|
| `*` | 0 atau lebih karakter |
| `?` | 1 karakter apa pun |
| `[abc]` | satu dari a, b, c |
| `[a-z]` | satu huruf lowercase |
| `[!abc]` / `[^abc]` | bukan a, b, c |
| `**` | rekursif (perlu `shopt -s globstar`) |

```bash
ls *.txt
ls file?.log
ls [A-Z]*
```

#### **Quote Removal**

```bash
echo "Halo"              # Halo
echo 'Halo $USER'        # Halo $USER (literal)
echo "Halo $USER"        # Halo alice
echo \$USER              # $USER (literal)
```

#### **Urutan Penting untuk Debugging**

```bash
bash -n skrip.sh         # cek sintaks tanpa eksekusi
bash -x skrip.sh         # trace setiap perintah
set -x ; ... ; set +x    # trace blok tertentu
```

---

### 1.3.9 Pola `echo` vs `printf`

`echo` tidak portabel: perilaku `-e`, `-n`, dan `\` berbeda antar shell. Untuk skrip serius, gunakan `printf`:

```bash
printf "Halo, %s!\n" "$NAMA"
printf "%-10s | %5d\n" "Total" 42
printf "Hex: %x\n" 255
```

| Spesifikasi | Arti |
|-------------|------|
| `%s` | String |
| `%d` | Integer |
| `%f` | Float |
| `%x` | Hex |
| `%o` | Octal |
| `%c` | Karakter |
| `%%` | Literal `%` |

---

### 1.3.10 Contoh Skrip Lengkap: `sapa.sh`

```bash
#!/usr/bin/env bash
# sapa.sh — contoh skrip pertama dengan argumen, opsi, dan penanganan error
set -euo pipefail

# Nilai default
NAMA="${1:-Pengguna}"
JUMLAH="${2:-1}"

# Validasi
if ! [[ "$JUMLAH" =~ ^[0-9]+$ ]]; then
    printf "Error: JUMLAH harus angka positif.\n" >&2
    exit 1
fi

# Loop
for ((i=1; i<=JUMLAH; i++)); do
    printf "%d. Halo, %s!\n" "$i" "$NAMA"
done

exit 0
```

**Jalankan:**

```bash
chmod +x sapa.sh
./sapa.sh                  # Halo, Pengguna!
./sapa.sh Andi             # Halo, Andi!
./sapa.sh Andi 3           # 3x salam
./sapa.sh Andi abc         # Error: JUMLAH harus angka positif. (exit 1)
```

---

### 1.3.11 Latihan Modul 1.3

1. Buat skrip `info.sh` yang mencetak: nama skrip, PID, user, home, dan shell.
2. Buat skrip `greet.sh NAMA` yang menyapa NAMA; jika argumen tidak ada, gunakan `${1:-Tamu}`.
3. Buat skrip yang meminta input nama dan umur dengan `read`, lalu validasi umur harus angka.
4. Buat skrip yang mengembalikan exit status `0` jika file ada, `1` jika tidak.
5. Buat skrip yang menerima flag `-v` untuk verbose dan `-f FILE` untuk nama file (gunakan `getopts`).
6. Debug skrip dari latihan 5 menggunakan `bash -x`.

---

## **Lampiran A — Kamus Simbol Shell Lengkap**

### A.1 Simbol Dasar

| Simbol | Nama (EN) | Nama (ID) | Fungsi |
|--------|-----------|-----------|--------|
| `#` | hash / comment | komentar | Komentar; juga `${#VAR}` panjang |
| `#!` | shebang | shebang | Interpreter skrip |
| `$` | dollar | dolar | Ekspansi variabel / parameter |
| `$()` | command substitution | substitusi perintah | Jalankan perintah, ambil output |
| `` ` `` | backtick | kutip miring | Command substitution lama (hindari) |
| `"` | double quote | kutip ganda | String dengan ekspansi |
| `'` | single quote | kutip tunggal | String literal (tanpa ekspansi) |
| `\` | backslash | garis miring terbalik | Escape |
| `=` | equal | sama dengan | Assignment; juga equality di `[ ]` |
| `-` | dash | minus | Opsi singkat; juga stdin/stdout |
| `--` | double dash | minus ganda | Opsi panjang; akhir opsi |
| `*` | asterisk | bintang | Glob; perkalian; `$*` |
| `?` | question | tanya | Glob 1 karakter; `$?` exit status |
| `[ ]` | brackets | kurung siku | Test POSIX; glob character class |
| `[[ ]]` | double brackets | kurung siku ganda | Test Bash/Zsh (lebih aman) |
| `{}` | braces | kurung kurawal | Brace expansion; group command |
| `()` | parens | kurung biasa | Subshell; array; aritmatika |
| `(())` | double parens | kurung ganda | Aritmatika |
| `:` | colon | titik dua | Null command; juga di `${VAR:-x}` |
| `.` | dot | titik | Source skrip; direktori saat ini |
| `..` | double dot | dua titik | Direktori induk |
| `/` | slash | garis miring | Separator path; root |
| `~` | tilde | tilde | Home |
| `^` | caret | topi | Awal baris (regex); `${VAR^}` |
| `!` | bang | tanda seru | Negasi; riwayat; `[!x]` |
| `;` | semicolon | titik koma | Pemisah perintah |
| `%` | percent | persen | Modulo; job ID; `${VAR%pat}` |
| `&` | ampersand | dan | Background |
| `,` | comma | koma | Brace expansion; operator di `(())` |

### A.2 Redirection & Pipe

| Simbol | Fungsi |
|--------|--------|
| `>` `1>` | Redirect stdout (timpa) |
| `>>` | Append stdout |
| `>|` | Paksa timpa (Bash, jika noclobber) |
| `<` | Redirect stdin |
| `<>` | Baca-tulis |
| `2>` | Redirect stderr |
| `2>>` | Append stderr |
| `&>` | stdout + stderr (Bash) |
| `&>>` | Append stdout + stderr (Bash) |
| `2>&1` | Gabung stderr ke stdout |
| `1>&2` | Gabung stdout ke stderr |
| `n>&-` | Tutup fd n |
| `n>&m` | Duplikasi fd m ke n |
| `|` | Pipe |
| `|&` | Pipe stdout + stderr (Bash) |
| `<<` | Here-document |
| `<<-` | Here-doc dengan tab-strip |
| `<<<` | Here-string (Bash/Zsh) |

### A.3 Operator Logika & Kontrol

| Simbol | Fungsi |
|--------|--------|
| `&&` | AND (jalankan kedua jika pertama sukses) |
| `\|\|` | OR (jalankan kedua jika pertama gagal) |
| `!` | NOT |
| `;` | Urutan |
| `&` | Background |
| `;;` | Akhir case branch |
| `;&` | Fallthrough (Bash) |
| `;;&` | Test case berikutnya (Bash) |
| `?:` | Ternary (di `(( ))`) |
| `=~` | Regex match (di `[[ ]]`) |
| `==` / `=` | Equality string |
| `!=` | Tidak sama |
| `<` `>` | Perbandingan (lexicographic di `[[ ]]`) |
| `-eq` `-ne` `-lt` `-le` `-gt` `-ge` | Perbandingan numerik |

### A.4 Izin File & `ls -l`

| Simbol | Arti |
|--------|------|
| `r` | read (4) |
| `w` | write (2) |
| `x` | execute (1) |
| `-` | tidak ada izin |
| `s` (posisi user/group) | setuid/setgid |
| `t` (posisi others) | sticky bit |
| `S` / `T` | setuid/setgid/sticky tapi tanpa execute |
| `d` (kolom pertama) | direktori |
| `l` | symlink |
| `s` (kolom pertama) | socket |
| `b` | block device |
| `c` | character device |
| `p` | named pipe (FIFO) |
| `-` (kolom pertama) | file biasa |

### A.5 Variabel Spesial Shell

| Variabel | Arti |
|----------|------|
| `$0` | Nama skrip / shell |
| `$1`..`$9` | Argumen posisi |
| `${10}` | Argumen ke-10+ |
| `$#` | Jumlah argumen |
| `$@` | Semua argumen (daftar) |
| `$*` | Semua argumen (string tunggal) |
| `$?` | Exit status terakhir |
| `$$` | PID shell |
| `$!` | PID background terakhir |
| `$_` | Argumen terakhir |
| `$-` | Flag shell aktif |

---

## **Lampiran B — POSIX vs Bash vs Zsh**

| Fitur | POSIX `sh` | Bash | Zsh | Catatan |
|-------|:----------:|:----:|:---:|---------|
| `if/then/else/fi` | ✅ | ✅ | ✅ | Sama |
| `case/esac` | ✅ | ✅ | ✅ | Sama |
| `for` / `while` / `until` | ✅ | ✅ | ✅ | Sama |
| `[ ]` / `test` | ✅ | ✅ | ✅ | POSIX |
| `[[ ]]` | ❌ | ✅ | ✅ | Non-POSIX, lebih aman |
| `==` (string) | ❌ | ✅ | ✅ | Gunakan `=` untuk POSIX |
| `=~` (regex) | ❌ | ✅ | ✅ | Non-POSIX |
| Array | ❌ | ✅ | ✅ | Non-POSIX |
| Associative array | ❌ | ✅ (4+) | ✅ | Non-POSIX |
| `**` glob rekursif | ❌ | ✅ (`shopt -s globstar`) | ✅ default | Non-POSIX |
| Brace expansion `{a,b}` | ❌ | ✅ | ✅ | Non-POSIX |
| `$(cmd)` | ✅ | ✅ | ✅ | POSIX |
| `` `cmd` `` | ✅ | ✅ | ✅ | POSIX (hindari) |
| `$(( ))` | ✅ | ✅ | ✅ | POSIX |
| `(( ))` sebagai perintah | ❌ | ✅ | ✅ | Non-POSIX |
| Process substitution `<( )` | ❌ | ✅ | ✅ | Non-POSIX |
| Fungsi `function name()` | ❌ | ✅ | ✅ | Non-POSIX; POSIX hanya `name()` |
| `local` | ❌ | ✅ | ✅ | Non-POSIX |
| `declare` / `typeset` | ❌ | ✅ | ✅ | Non-POSIX |
| `set -u` | ✅ | ✅ | ✅ | POSIX |
| `set -o pipefail` | ❌ | ✅ | ✅ | Non-POSIX |
| `let` | ❌ | ✅ | ✅ | Non-POSIX |
| `read -p` | ❌ | ✅ | ✅ | Non-POSIX |
| `read -t` | ❌ | ✅ | ✅ | Non-POSIX |
| `echo -e` | ⚠️ | ✅ | ✅ | Tidak portabel; gunakan `printf` |
| `printf` | ✅ | ✅ | ✅ | POSIX |
| `&>` | ❌ | ✅ | ✅ | Gunakan `>file 2>&1` untuk POSIX |
| `|&` | ❌ | ✅ | ✅ | Non-POSIX |
| `<<<` | ❌ | ✅ | ✅ | Non-POSIX |
| `${VAR:offset:length}` | ❌ | ✅ | ✅ | Non-POSIX |
| `${VAR//pat/rep}` | ❌ | ✅ | ✅ | Non-POSIX |
| `${VAR^^}` / `${VAR,,}` | ❌ | ✅ | ✅ | Non-POSIX |
| `select` | ❌ | ✅ | ✅ | Non-POSIX |
| `$RANDOM` | ❌ | ✅ | ✅ | Non-POSIX |
| `$SECONDS` | ❌ | ✅ | ✅ | Non-POSIX |

> **Kesimpulan praktis:**
> - **Portabel lintas Unix:** tulis POSIX `sh`, shebang `#!/bin/sh` atau `#!/usr/bin/env sh`.
> - **Hanya Arch/Debian/Ubuntu modern:** boleh Bash dengan `#!/usr/bin/env bash`.
> - **Linux + macOS dengan Bash 3.2:** hindari fitur Bash 4+ seperti `declare -A`, `mapfile`, `${VAR,,}`.
> - **Jangan pakai Fish untuk skrip portabel.** Fish bukan POSIX dan sintaksnya berbeda total.

---

## **Lampiran C — Variabel Bawaan Shell dan Lingkungan**

### C.1 Variabel Lingkungan Umum

| Variabel | Isi | Contoh |
|----------|-----|--------|
| `HOME` | Direktori home user | `/home/alice` |
| `USER` / `LOGNAME` | Nama user | `alice` |
| `UID` | User ID | `1000` |
| `SHELL` | Login shell | `/bin/bash` |
| `PATH` | Daftar direktori pencarian | `/usr/local/bin:/usr/bin:/bin` |
| `PWD` | Direktori saat ini | `/home/alice` |
| `OLDPWD` | Direktori sebelumnya | `/tmp` |
| `TERM` | Jenis terminal | `xterm-256color` |
| `LANG` / `LC_*` | Lokalisasi | `en_US.UTF-8` |
| `HOSTNAME` | Nama host | `archlinux` |
| `EDITOR` / `VISUAL` | Editor default | `vim` |
| `PS1` | Prompt utama | `\u@\h:\w\$ ` |
| `PS2` | Prompt lanjutan | `> ` |
| `IFS` | Internal Field Separator | spasi, tab, newline |
| `HISTSIZE` | Ukuran history | `1000` |
| `HISTFILE` | File history | `~/.bash_history` |
| `RANDOM` (Bash) | Angka acak 0–32767 | `$RANDOM` |
| `SECONDS` (Bash) | Detik sejak shell start | `$SECONDS` |
| `LINENO` (Bash) | Nomor baris saat ini | `$LINENO` |
| `FUNCNAME` (Bash) | Nama fungsi | `${FUNCNAME[0]}` |
| `BASH_VERSION` | Versi Bash | `5.2.15` |
| `BASH_SOURCE` | Sumber file skrip | `${BASH_SOURCE[0]}` |
| `DIRSTACK` | Stack `pushd`/`popd` | — |
| `GROUPS` | Grup user | — |
| `PPID` | PID parent | — |
| `TMPDIR` | Direktori temp | `/tmp` |

### C.2 Variabel Posisi & Spesial

| Variabel | Arti |
|----------|------|
| `$0` | Nama skrip |
| `$1`..`$9`, `${10}` | Argumen posisi |
| `$#` | Jumlah argumen |
| `$@` | Semua argumen (array) |
| `$*` | Semua argumen (string) |
| `$?` | Exit status |
| `$$` | PID shell |
| `$!` | PID background |
| `$-` | Flag shell aktif |
| `$_` | Argumen terakhir |

### C.3 Nilai Default Berguna

| Ekspresi | Fungsi |
|----------|--------|
| `${VAR:-default}` | Default jika kosong |
| `${VAR:=default}` | Set default jika kosong |
| `${VAR:?pesan}` | Error jika kosong |
| `${VAR:+alt}` | Alt jika diset |
| `${VAR#pat}` | Hapus prefix pendek |
| `${VAR##pat}` | Hapus prefix panjang |
| `${VAR%pat}` | Hapus suffix pendek |
| `${VAR%%pat}` | Hapus suffix panjang |
| `${VAR/pat/rep}` | Ganti pertama |
| `${VAR//pat/rep}` | Ganti semua |
| `${VAR/#pat/rep}` | Ganti di awal |
| `${VAR/%pat/rep}` | Ganti di akhir |
| `${#VAR}` | Panjang |

### C.4 `IFS` (Internal Field Separator)

`IFS` menentukan bagaimana Bash memecah kata (word splitting). Default: spasi, tab, newline.

```bash
# Sementara ubah IFS untuk parsing CSV
OLD_IFS="$IFS"
IFS=","
while read -r nama umur kota; do
    echo "Nama: $nama, Umur: $umur, Kota: $kota"
done < data.csv
IFS="$OLD_IFS"
```

> ⚠️ Selalu simpan dan pulihkan `IFS` setelah diubah, atau gunakan `IFS=, read ...` inline.

### C.5 `PATH`

`PATH` adalah daftar direktori (dipisah `:`) tempat shell mencari perintah.

```bash
echo "$PATH"
# /usr/local/sbin:/usr/local/bin:/usr/bin:/bin

# Tambah direktori ke depan
export PATH="$HOME/.local/bin:$PATH"

# Cek isi PATH
echo "$PATH" | tr ':' '\n'
```

### C.6 `PS1` — Prompt

| Escape | Arti |
|--------|------|
| `\u` | Username |
| `\h` | Hostname (pendek) |
| `\H` | Hostname (lengkap) |
| `\w` | Path (dengan `~`) |
| `\W` | Basename direktori |
| `\d` | Tanggal |
| `\t` | Waktu (HH:MM:SS) |
| `\n` | Newline |
| `\$` | `#` untuk root, `$` untuk user |
| `\[` `\]` | Bungkus escape warna |

Contoh:

```bash
PS1='\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '
```

---

## **Lampiran D — Pesan Error Umum dan Solusinya**

### D.1 Kesalahan Sintaks

| Pesan | Penyebab | Solusi |
|-------|----------|--------|
| `syntax error near unexpected token 'fi'` | `if` tanpa `then`, atau `fi` berlebih | Periksa pasangan `if ... fi` |
| `syntax error: unexpected end of file` | Blok belum ditutup (`fi`, `done`, `esac`, `}`) | Lengkapi penutup |
| `command not found` | Perintah tidak ada / tidak di PATH / typo | Cek `command -v`, perbaiki `$PATH` |
| `No such file or directory` | File tidak ada, atau shebang salah | Cek path; pastikan shebang valid |
| `Permission denied` | Tidak ada izin eksekusi/baca | `chmod +x file`, atau `sudo` |
| `bad interpreter: /bin/bash^M` | File punya CRLF (Windows) | `dos2unix file` atau `sed -i 's/\r$//' file` |
| `unexpected EOF while looking for matching '"'` | Kutip tidak ditutup | Periksa pasangan `"`, `'` |
| `bash: [: too many arguments` | Variabel tanpa kutip di `[ ]` | Gunakan `[[ ]]` atau kutip: `[ "$VAR" = "x" ]` |
| `integer expression expected` | Perbandingan string dengan `-eq` | Pakai `=` untuk string, atau validasi angka |
| `ambiguous redirect` | Redirect ke variabel kosong / multi-kata | Kutip: `> "$FILE"` |

### D.2 Kesalahan Variabel

| Pesan | Penyebab | Solusi |
|-------|----------|--------|
| `unbound variable` | `set -u` aktif dan variabel kosong | Beri default `${VAR:-}` atau hapus `set -u` |
| `command not found: VAR=value` | Spasi di sekitar `=` | `VAR=value` tanpa spasi |
| `bad substitution` | Sintaks `${}` salah, atau pakai Bash di `sh` | Perbaiki sintaks / ganti shebang ke `bash` |
| `cannot assign to readonly variable` | Variabel `readonly` | `unset` tidak berlaku; restart shell / skrip |

### D.3 Kesalahan Redirection & Pipe

| Pesan | Penyebab | Solusi |
|-------|----------|--------|
| `No such file or directory` saat `> file` | Direktori induk tidak ada | `mkdir -p dir` sebelum redirect |
| `Permission denied` saat `>` | Tidak ada izin tulis | Cek izin / `sudo` |
| `cannot overwrite existing file` | `set -C` (noclobber) aktif | Pakai `>|` atau matikan `set +C` |
| stderr tidak ikut terpipe | Pipe hanya `stdout` | Gabung: `cmd 2>&1 | next` |

### D.4 Kesalahan Eksekusi

| Pesan | Penyebab | Solusi |
|-------|----------|--------|
| `bash: ./script.sh: /bin/bash^M: bad interpreter` | Line ending CRLF | `sed -i 's/\r$//' script.sh` |
| `bash: ./script.sh: Permission denied` | Tidak ada izin eksekusi | `chmod +x script.sh` |
| `bash: ./script.sh: No such file or directory` (padahal ada) | Shebang menunjuk ke interpreter tidak ada | Cek shebang, `ls -l` interpreter |
| `command not found: [[` | Dijalankan di `sh`/`dash`, bukan `bash` | Ubah shebang ke `bash` |

### D.5 Debugging

| Teknik | Fungsi |
|--------|--------|
| `bash -n skrip.sh` | Cek sintaks tanpa eksekusi |
| `bash -x skrip.sh` | Tampilkan setiap perintah sebelum dieksekusi |
| `set -x` / `set +x` | Aktifkan / matikan trace di tengah skrip |
| `set -e` | Keluar saat perintah gagal |
| `set -u` | Error saat variabel kosong |
| `set -o pipefail` | Deteksi kegagalan di pipeline |
| `trap 'echo "error di baris $LINENO"' ERR` | Hook error |
| `shellcheck skrip.sh` | Analisis statis (sangat direkomendasikan) |

### D.6 `shellcheck` — Wajib Dipakai

```bash
# Install
sudo pacman -S shellcheck     # Arch
sudo apt install shellcheck   # Debian/Ubuntu
brew install shellcheck       # macOS

# Pakai
shellcheck skrip.sh
```

ShellCheck akan mendeteksi:

- Variabel tanpa kutip (SC2086)
- Penggunaan `[ ]` di mana `[[ ]]` lebih baik
- `cat file | cmd` yang tidak perlu (SC2002)
- `for i in $(ls)` yang rapuh (SC2045)
- Banyak lagi.

---

## **Lampiran E — Referensi**

### Buku

- **The Linux Command Line** — William E. Shotts, Jr.  
  <http://linuxcommand.org/tlcl.php>
- **The Art of Unix Programming** — Eric S. Raymond  
  <http://www.catb.org/~esr/writings/taoup/html/>
- **Advanced Bash-Scripting Guide** — Mendel Cooper  
  <https://tldp.org/LDP/abs/html/>

### Dokumentasi Resmi

- **GNU Bash Manual**  
  <https://www.gnu.org/software/bash/manual/bash.html>
- **POSIX.1-2017 (IEEE Std 1003.1)**  
  <https://pubs.opengroup.org/onlinepubs/9699919799/>
- **Zsh Manual**  
  <https://zsh.sourceforge.io/Doc/>

### Tutorial & Referensi Online

- **Ubuntu — Linux Command Line for Beginners**  
  <https://ubuntu.com/tutorials/command-line-for-beginners>
- **TLDP — I/O Redirection**  
  <https://tldp.org/LDP/abs/html/io-redirection.html>
- **Ryans Tutorials — Pipes and Redirection**  
  <https://ryanstutorials.net/linuxtutorial/piping.php>
- **Red Hat — What is a shell?**  
  <https://www.redhat.com/en/topics/linux/what-is-a-shell>
- **Red Hat — What is the Linux kernel?**  
  <https://www.redhat.com/en/topics/linux/what-is-linux-kernel>
- **Arch Wiki — Bash**  
  <https://wiki.archlinux.org/title/Bash>
- **Arch Wiki — Command-line shell**  
  <https://wiki.archlinux.org/title/Command-line_shell>

### Alat Bantu

- **ShellCheck** — <https://www.shellcheck.net/>
- **ExplainShell** — <https://explainshell.com/>
- **tldr pages** — <https://tldr.sh/>
- **Bash Pitfalls** — <https://mywiki.wooledge.org/BashPitfalls>
- **Google Shell Style Guide** — <https://google.github.io/styleguide/shellguide.html>

---

## **Penutup Fase 1**

Anda kini memiliki fondasi:

- ✅ Memahami filosofi Unix dan ekosistem shell.
- ✅ Dapat menavigasi sistem berkas dan mencari bantuan.
- ✅ Menguasai I/O redirection, pipe, dan perintah teks dasar.
- ✅ Dapat menulis, menjalankan, dan men-debug skrip Bash pertama.
- ✅ Memahami variabel, argumen, nilai default, exit status, dan urutan ekspansi.

**Langkah selanjutnya (Fase 2):** kondisional (`if`, `case`), perulangan (`for`, `while`, `until`), fungsi, dan struktur kontrol lainnya.

> **Tips terakhir:** *Latihan adalah kunci.* Tulis skrip setiap hari meski hanya 5 baris. Gunakan `shellcheck`. Baca `man` dan `help` sebelum bertanya pada mesin pencari. Selamat berkarya!

---

> ⬆️ **[Ke Atas](#fase-1-fondasi--berinteraksi-dengan-shell-tingkat-pemula)**
> ➡️ **[Modul Berikutnya (Fase 2)](../bagian-2/README.md)**
> 📘 **[Kurikulum](../../README.md)**
> 🌐 **[Domain Spesifik](../../../../README.md)**
> 📎 **[Lampiran POSIX](./posix.md)**

<!-- Referensi internal -->
[1]: ../README.md

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

