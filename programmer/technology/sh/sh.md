> Deepseek

# **sh/POSIX Standard**

Kurikulum ini dirancang agar Anda dapat menulis skrip shell yang portabel, aman, dan efisien di berbagai sistem Unix-like (Linux, macOS, BSD).

---

## 🧭 Peta Jalan Kurikulum

| Tingkat | Fokus Utama | Estimasi Waktu |
|---------|-------------|----------------|
| **Level 1 – Fondasi** | Dasar shell, perintah, shebang | 1–2 minggu |
| **Level 2 – Blok Bangunan** | Variabel, kondisi, loop, fungsi | 2–3 minggu |
| **Level 3 – Teknik Lanjutan** | I/O, pipe, ekspansi, regex, sed/awk | 3–4 minggu |
| **Level 4 – Profesional** | Error handling, portabilitas, debugging, keamanan | 4–5 minggu |
| **Level 5 – Tingkat Dewa** | Optimasi performa, arsitektur skrip kompleks, kontribusi ke proyek open source | Berkelanjutan |

---

## [📘 Level 1: Fondasi (Zero to Basic)][1]

### Tujuan
Memahami apa itu shell, mengapa POSIX penting, dan mampu menjalankan perintah dasar serta menulis skrip pertama.

### Materi

1. **Pengenalan Shell & POSIX**
   - Apa itu shell? Perannya sebagai command interpreter.
   - Mengapa POSIX matters: portabilitas lintas Linux, macOS, BSD.
   - Berbagai shell: `sh`, `bash`, `dash`, `ksh`, dan kaitannya dengan POSIX.

2. **Terminal & Lingkungan**
   - Navigasi dasar: `ls`, `cd`, `pwd`, `man`.
   - Environment variable: `PATH`, `HOME`, `PS1`.

3. **Skrip Pertama & Shebang**
   - Magic `#!/bin/sh`: mengapa menggunakan `/bin/sh` dan bukan `/bin/bash`.
   - Membuat file skrip, memberi izin eksekusi (`chmod +x`), dan menjalankannya.
   - Komentar: `#` sebagai catatan untuk masa depan.

4. **Perintah Dasar yang Wajib Dikuasai**
   - Manipulasi file: `cp`, `mv`, `rm`, `mkdir`, `touch`.
   - Melihat isi file: `cat`, `less`, `head`, `tail`.
   - Pencarian: `grep`, `find`.

### Latihan
- Tulis skrip `hello.sh` yang mencetak "Hello, POSIX!" dan menerima satu argumen nama.
- Buat skrip yang menampilkan daftar file di direktori saat ini beserta ukurannya.

---

## [📗 Level 2: Blok Bangunan (Basic to Intermediate)][2]

### Tujuan
Menguasai konstruksi dasar pemrograman shell: variabel, kondisi, loop, dan fungsi.

### Materi

1. **Variabel & Ekspansi Parameter**
   - Dasar variabel, konvensi penamaan, string vs numerik.
   - Environment variable vs variabel lokal.
   - Ekspansi parameter: `${var}`, `${var:-default}`, `${var:=default}`, `${#var}`.
   - Variabel spesial: `$#`, `$@`, `$?`, `$$`, `$0`.

2. **Kondisional (`if`, `test`, `case`)**
   - `if`, `elif`, `else`.
   - Operator `test` dan `[ ]`: perbandingan numerik (`-eq`, `-lt`), string (`=`, `!=`), file (`-f`, `-d`, `-r`).
   - Operator Boolean: `&&`, `||`, `!`.
   - `case` untuk percabangan multi-opsi.

3. **Loop (`for`, `while`, `until`)**
   - `for` loop dengan daftar, glob, dan `$(seq)`.
   - `while` dan `until` untuk kondisi dinamis.
   - `break` dan `continue`.

4. **Fungsi**
   - Mendefinisikan dan memanggil fungsi.
   - Variabel lokal (`local`), parameter fungsi, dan nilai return.
   - Membangun pustaka fungsi yang dapat digunakan ulang.

### Latihan
- Skrip yang menerima argumen dan memvalidasi apakah file tersebut ada serta dapat dibaca.
- Fungsi `max()` yang mengembalikan angka terbesar dari dua parameter.
- Loop yang memproses semua file `.txt` di direktori dan menghitung jumlah barisnya.

---

## [📙 Level 3: Teknik Lanjutan (Intermediate to Advanced)][3]

### Tujuan
Menguasai manipulasi teks, pipeline, dan alat-alat Unix yang menjadi tulang punggung skrip profesional.

### Materi

1. **Input/Output & Redirection**
   - Membaca input pengguna dengan `read`.
   - Redirection: `>`, `>>`, `<`, `2>`, `&>`.
   - Here document (`<<EOF`) dan here string (`<<<`).
   - File descriptor dan `/dev/null`.

2. **Command Substitution & Pipeline**
   - `$(command)` vs backtick.
   - Pipe (`|`) sebagai filosofi Unix: menghubungkan program kecil.
   - `xargs` untuk memperkuat pipeline.

3. **Pattern Matching & Text Processing**
   - Globbing: `*`, `?`, `[ ]`.
   - Ekspansi parameter untuk manipulasi string: `${var#pattern}`, `${var%pattern}`, `${var/old/new}`.
   - **`grep`**: pencarian pola, opsi `-E`, `-i`, `-v`, `-r`.
   - **`sed`**: stream editor untuk substitusi, penghapusan, dan transformasi teks.
   - **`awk`**: pemrosesan kolom, perhitungan, dan pelaporan.
   - Regular Expression POSIX (BRE dan ERE).

4. **Aritmatika dalam Shell**
   - `$(( ))` untuk ekspansi aritmatika.
   - `expr` sebagai alternatif portabel.
   - Operasi floating-point dengan `bc` atau `awk`.

### Latihan
- Skrip yang mengekstrak alamat email unik dari file teks menggunakan `grep -E` dan `sort -u`.
- Pipeline yang menghitung frekuensi kata dari sebuah file, diurutkan dari yang terbanyak.
- Menggunakan `sed` untuk mengganti semua kemunculan tanggal format `DD/MM/YYYY` menjadi `YYYY-MM-DD`.

---

## [📕 Level 4: Profesional (Advanced to Expert)][4]

### Tujuan
Menulis skrip yang tahan banting, portabel, aman, dan mudah di-debug.

### Materi

1. **Error Handling & Defensive Programming**
   - Exit code dan `$?`.
   - `trap` untuk menangkap sinyal dan error.
   - `set -e`, `set -u`, `set -o pipefail` (dengan catatan portabilitas).
   - Logging dan graceful failure.

2. **Portabilitas (Write Once, Run Anywhere)**
   - Menghindari "bashisms" (fitur bash yang tidak ada di POSIX sh).
   - Checklist kepatuhan POSIX.
   - Menguji di berbagai shell: `dash`, `bash --posix`, `ksh`.
   - Shebang portabel: `#!/bin/sh` vs `#!/usr/bin/env sh`.

3. **Debugging**
   - `set -x` dan `set +x` untuk tracing.
   - `echo` strategis dan `tee` untuk inspeksi aliran data.
   - `set -n` untuk syntax check.
   - `trap 'echo "Error on line $LINENO"' ERR`.

4. **Keamanan Skrip Shell**
   - **Command injection**: hindari `eval`, selalu quote variabel (`"$var"`).
   - **Path injection**: set `PATH` secara eksplisit, gunakan path absolut untuk perintah kritis.
   - **Variable injection**: sanitasi input pengguna.
   - **Temporary file**: gunakan `mktemp` dengan aman.
   - Jangan pernah menggunakan SUID/SGID pada skrip shell.

5. **Praktik Terbaik & Gaya Kode**
   - Penamaan variabel yang jelas.
   - Dokumentasi inline dan header skrip.
   - Menghindari `eval` dan backtick.
   - Menggunakan `getopts` untuk parsing argumen.

### Latihan
- Refaktor skrip yang rentan command injection menjadi aman.
- Tulis skrip yang portabel di `dash` dan `bash` tanpa error.
- Buat skrip dengan logging, error handling, dan trap yang komprehensif.

---

## [🧙 Level 5: Tingkat Dewa (God Tier)][5]

### Tujuan
Mengoptimalkan performa, membangun arsitektur skrip kompleks, dan berkontribusi pada ekosistem open source.

### Materi

1. **Optimasi Performa**
   - Gunakan built-in shell daripada perintah eksternal jika memungkinkan.
   - Paralelisasi dengan `xargs -P` untuk batch processing.
   - Prefilter dengan `grep` sebelum memproses dengan `sed`/`awk`.
   - Mengurangi subshell dan fork.
   - Profiling skrip dengan `time` dan `strace`.

2. **Arsitektur Skrip Kompleks**
   - Modularisasi dengan fungsi dan sourcing file.
   - Menggunakan `getopts` dan parsing argumen tingkat lanjut.
   - State management dan konfigurasi via file.
   - Integrasi dengan bahasa lain (Python, Perl) melalui pipe.

3. **Process Substitution & FIFO**
   - `<(command)` dan `>(command)` untuk mengakses output/input sebagai file descriptor.
   - Menggunakan named pipe (`mkfifo`) untuk komunikasi antar proses.
   - Contoh: `paste <(cut -f1 file1) <(cut -f3 file2)`.

4. **Signal Handling & Job Control**
   - `trap` untuk `SIGINT`, `SIGTERM`, `SIGHUP`.
   - Mengelola proses latar belakang dengan `&`, `wait`, `jobs`, `fg`, `bg`.
   - Menulis daemon sederhana dengan shell.

5. **Kontribusi Open Source**
   - Menulis skrip untuk proyek seperti `autoconf`, `shellcheck`, atau utilitas sistem.
   - Mengikuti standar POSIX dan panduan gaya proyek.
   - Melakukan code review dan pengujian lintas platform.

### Proyek Tingkat Dewa
- **Shell library**: Kumpulan fungsi POSIX yang dapat digunakan ulang (string manipulation, logging, validasi).
- **CLI tool**: Alat baris perintah lengkap dengan `getopts`, help, dan konfigurasi.
- **Log analyzer**: Pipeline kompleks yang mem-parsing log server, menghasilkan laporan, dan mengirim alert.
- **Portable build script**: Skrip yang mendeteksi sistem operasi dan mengompilasi program C secara otomatis.

---

## 📚 Sumber Belajar Rekomendasi

- **Buku**: *POSIX Shell Scripting: A Journey from Zero to Hero* – cloudstreet-dev (GitHub).
- **Spesifikasi Resmi**: IEEE Std 1003.1-2024 (POSIX.1) – Shell Command Language.
- **Panduan Lanjutan**: *Advanced Bash-Scripting Guide* – bab tentang debugging, optimasi, dan keamanan.
- **Latihan**: Appendix O dari Advanced Bash-Scripting Guide.
- **Tool**: `shellcheck` untuk analisis statis skrip POSIX.

---

## 🎯 Tips Belajar

1. **Praktik setiap hari**: Tulis skrip kecil untuk mengotomatisasi tugas rutin.
2. **Gunakan `dash` sebagai shell pengujian**: Ini adalah implementasi POSIX yang ketat, sehingga skrip yang berjalan di `dash` akan portabel di sebagian besar sistem.
3. **Baca skrip orang lain**: Pelajari skrip dari proyek open source seperti `autoconf`, `git`, atau `systemd`.
4. **Selalu uji di lingkungan berbeda**: Minimal di Linux dan macOS.
5. **Jangan takut debug**: Gunakan `set -x` dan `trap` untuk memahami alur eksekusi.

Dengan mengikuti kurikulum ini secara disiplin, Anda akan berkembang dari pemula menjadi ahli shell POSIX yang mampu menulis skrip tingkat produksi yang portabel, aman, dan efisien.

[1]: ./bagian-1/README.md
[2]: ./bagian-2/README.md
[3]: ./bagian-3/README.md
[4]: ./bagian-4/README.md
[5]: ./bagian-5/README.md
