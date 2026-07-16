# Kurikulum Bash Scripting: Dari Nol Menuju Ahli (7 Hari)

**Host utama:** Arch Linux & Termux
**Referensi wajib:**
- Bash Reference Manual (GNU): https://www.gnu.org/software/bash/manual/bash.html
- Bash Reference Manual (Case Western, versi lengkap dengan indeks): https://tiswww.case.edu/php/chet/bash/bashref.html
- GNU Project (induk seluruh dokumentasi resmi): https://www.gnu.org/

Prinsip belajar minggu ini: **tidak ada satu baris kode pun yang boleh dijalankan tanpa kamu tahu persis apa arti tiap karakternya.** Bash bukan sekadar rangkaian perintah — ia adalah cara berpikir mesin dalam mengeksekusi alur logika secara sekuensial, kondisional, dan berulang. Setiap hari dirancang membangun lapisan mental berikutnya di atas lapisan sebelumnya.

---

## [HARI 1 — Fondasi Shell dan Anatomi Perintah][1]

**Tujuan mental:** memahami bahwa shell adalah *interpreter* yang membaca teks, memecahnya jadi token, lalu mengeksekusi program.

1. Apa itu shell, apa itu Bash, perbedaan shell login vs non-login, interactive vs non-interactive
2. Anatomi sebuah perintah: `perintah -opsi argumen`
3. Variabel lingkungan (`$HOME`, `$PATH`, `$USER`, `$PWD`) — apa yang terjadi saat sistem mencari executable lewat `$PATH`
4. Membuat file skrip pertama: shebang `#!/bin/bash`, izin eksekusi `chmod +x`
5. Perbedaan menjalankan skrip via `./script.sh`, `bash script.sh`, dan `source script.sh` (dampaknya terhadap subshell vs shell saat ini)
6. Instalasi & verifikasi versi Bash di Arch Linux (`pacman -S bash`) dan Termux (`pkg install bash`)

**Referensi bagian ini:** Bash Reference Manual Bab 1 (Basic Shell Features) — https://www.gnu.org/software/bash/manual/bash.html#Basic-Shell-Features

**Latihan wajib:** buat skrip `hello.sh` lalu jelaskan kata per kata makna `#!/bin/bash`, `#`, `/bin/bash`, dan mengapa baris ini harus jadi baris pertama tanpa spasi di depannya.

---

## [HARI 2 — Variabel, Quoting, dan Ekspansi][2]

**Tujuan mental:** memahami bahwa Bash melakukan *word splitting* dan *expansion* sebelum mengeksekusi apa pun — ini akar dari 90% bug pemula.

1. Deklarasi variabel: `nama=nilai` (kenapa **tanpa spasi** di sekitar `=` itu wajib)
2. Membaca variabel: `$nama` vs `${nama}` — kapan kurung kurawal wajib dipakai
3. Quoting:
   - Single quote `'...'` — literal, tidak ada ekspansi apa pun
   - Double quote `"..."` — ekspansi variabel & command substitution tetap jalan, tapi word splitting glob dimatikan
   - Tanpa quote — rawan word splitting dan globbing tak disengaja
4. Command substitution: `$(perintah)` vs backtick `` `perintah` `` (kenapa `$()` lebih disarankan — bisa dinestingkan)
5. Arithmetic expansion: `$(( ekspresi ))`
6. Variabel khusus: `$0`, `$1`...`$9`, `$#`, `$@`, `$*`, `$?`, `$$`, `$!`
7. `export` — kenapa variabel biasa tidak diwariskan ke subprocess, dan `export` mengubahnya jadi bagian environment

**Referensi bagian ini:** Bab 3.4 (Shell Parameters) & 3.5 (Shell Expansions) — https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameters

**Latihan wajib:** buat variabel berisi spasi, coba echo tanpa quote lalu dengan quote, amati dan jelaskan perbedaan output kata demi kata.

---

## HARI 3 — Percabangan Logika (Conditional Logic)

**Tujuan mental:** ini adalah jantung logika program — mesin mengambil keputusan berdasarkan *exit status* (`$?`), bukan berdasarkan "benar/salah" seperti bahasa lain.

1. Konsep **exit status**: 0 = sukses, non-nol = gagal — ini fondasi semua percabangan di Bash
2. `if`, `elif`, `else`, `fi` — struktur lengkap kata per kata
3. Test command: `[ ]` (POSIX test) vs `[[ ]]` (Bash extended test) — perbedaan operator dan kenapa `[[ ]]` lebih aman untuk string
4. Operator perbandingan:
   - String: `=`, `!=`, `-z`, `-n`
   - Numerik: `-eq`, `-ne`, `-gt`, `-lt`, `-ge`, `-le`
   - File: `-f`, `-d`, `-e`, `-x`, `-r`, `-w`
5. Operator logika: `&&`, `||`, `!`
6. `case` statement — pattern matching, kapan lebih baik dari `if/elif` bertumpuk
7. Short-circuit evaluation: `perintah1 && perintah2 || perintah3`

**Referensi bagian ini:** Bab 3.2.4 (Conditional Constructs) & Bab 6.4 (Bash Conditional Expressions) — https://www.gnu.org/software/bash/manual/bash.html#Bash-Conditional-Expressions

**Latihan wajib:** buat skrip yang mengecek apakah sebuah file ada, bisa dieksekusi, dan lebih besar dari 0 byte — jelaskan tiap flag `-e`, `-x`, `-s` satu per satu.

---

## HARI 4 — Perulangan (Loops) dan Kontrol Alur

**Tujuan mental:** memahami iterasi sebagai mekanisme mengulang eksekusi berdasarkan kondisi — dasar dari otomatisasi sesungguhnya.

1. `for` loop — tiga gaya: list-based, range `{1..10}`, C-style `for (( ; ; ))`
2. `while` loop — loop berbasis kondisi, kapan dipakai vs `for`
3. `until` loop — kebalikan logis dari `while`
4. `break` dan `continue` — kontrol keluar paksa dari loop, termasuk `break n` untuk nested loop
5. Membaca file baris per baris dengan aman: `while IFS= read -r line; do ... done < file.txt` — jelaskan kata per kata kenapa `IFS=` dan `-r` wajib ada
6. `select` — membuat menu interaktif sederhana
7. Infinite loop yang disengaja: `while true; do ... done` untuk daemon/monitor sederhana

**Referensi bagian ini:** Bab 3.2.5 (Looping Constructs) — https://www.gnu.org/software/bash/manual/bash.html#Looping-Constructs

**Latihan wajib:** buat skrip pemantau baterai di Termux (`termux-battery-status`) yang berjalan tiap 5 detik memakai `while true` + `sleep`, jelaskan tiap komponen.

---

## HARI 5 — Fungsi, Array, dan String Manipulation

**Tujuan mental:** memodularkan logika — ini titik di mana skrip berubah dari "urutan perintah" menjadi "program" sungguhan.

1. Deklarasi fungsi: `nama_fungsi() { ... }` vs `function nama_fungsi { ... }`
2. Parameter fungsi (`$1`, `$2`, dst di dalam fungsi — scope-nya lokal terhadap panggilan)
3. `local` keyword — kenapa variabel di dalam fungsi harus dideklarasikan lokal agar tidak bocor ke scope global
4. `return` vs `echo` sebagai cara "mengembalikan nilai" (kenapa Bash tidak punya return value asli seperti bahasa lain — hanya exit status)
5. Array indexed: `arr=(a b c)`, akses `${arr[0]}`, `${arr[@]}`, `${#arr[@]}`
6. Array asosiatif: `declare -A`, akses berbasis key
7. String manipulation:
   - Panjang string: `${#var}`
   - Substring: `${var:offset:length}`
   - Replace: `${var/pola/ganti}` vs `${var//pola/ganti}`
   - Default value: `${var:-default}`, `${var:=default}`

**Referensi bagian ini:** Bab 3.3 (Shell Functions) & Bab 3.5.3 (Shell Parameter Expansion) — https://www.gnu.org/software/bash/manual/bash.html#Shell-Functions

**Latihan wajib:** tulis fungsi `is_number()` yang menerima 1 argumen dan mengembalikan status 0 jika numerik, jelaskan setiap simbol regex yang dipakai di `[[ $1 =~ ^[0-9]+$ ]]`.

---

## HARI 6 — I/O, Pipe, Redirection, dan Text Processing

**Tujuan mental:** memahami filosofi Unix — "banyak program kecil yang saling terhubung lewat aliran teks" adalah inti kekuatan Bash.

1. File descriptor: `0` (stdin), `1` (stdout), `2` (stderr) — kenapa ini penting dipahami sebelum redirection
2. Redirection: `>`, `>>`, `<`, `2>`, `2>&1`, `&>`
3. Pipe `|` — menyambungkan stdout satu perintah ke stdin perintah lain
4. `tee` — menyalin output ke file sekaligus tetap tampil di layar
5. Here-document (`<<EOF ... EOF`) dan here-string (`<<< "teks"`)
6. Kombinasi dengan tools eksternal wajib dikuasai: `grep`, `sed`, `awk`, `cut`, `sort`, `uniq`, `xargs` — masing-masing satu opsi paling sering dipakai dijelaskan kata per kata
7. `command1 | command2 | command3` — cara berpikir "pipeline" sebagai rantai transformasi data

**Referensi bagian ini:** Bab 3.6 (Redirections) — https://www.gnu.org/software/bash/manual/bash.html#Redirections

**Latihan wajib:** dari `pacman -Qe` (Arch) atau `pkg list-installed` (Termux), buat pipeline untuk menghitung jumlah paket terinstal yang namanya mengandung huruf "lib", jelaskan tiap tahap pipeline.

---

## HARI 7 — Skrip Robust: Error Handling, Debugging, dan Best Practice

**Tujuan mental:** ini adalah lompatan dari "bisa jalan" menuju "layak produksi" — mentalitas insinyur, bukan sekadar pengguna terminal.

1. `set -e` (exit saat error), `set -u` (error saat variabel tak terdefinisi), `set -o pipefail` (pipeline gagal jika salah satu tahap gagal) — kombinasi `set -euo pipefail` sebagai standar skrip profesional
2. `trap` — menangkap sinyal (`EXIT`, `ERR`, `SIGINT`) untuk cleanup otomatis
3. Debugging dengan `bash -x script.sh` dan `set -x` / `set +x` di dalam skrip
4. `shellcheck` — linter wajib sebelum skrip dianggap selesai (instalasi via `pacman -S shellcheck` / `pkg install shellcheck`)
5. Struktur skrip profesional: validasi argumen di awal, fungsi `usage()`, exit code yang konsisten dan terdokumentasi
6. Perbedaan penting antarplatform: keterbatasan Termux (tidak ada akses root penuh, beberapa binary GNU diganti versi ringkas) vs Arch Linux (akses penuh ke `systemd`, `pacman`, `journalctl`)
7. Menulis skrip idempotent — skrip yang aman dijalankan berkali-kali tanpa efek samping berulang

**Referensi bagian ini:** Bab 4.3 (The Set Builtin) & Bab 3.7.5 (Signals/Trap) — https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin

**Proyek akhir pekan (wajib):** bangun satu skrip otomatisasi nyata (contoh: backup folder, monitor resource, atau installer paket favorit) yang menggabungkan **semua** materi hari 1–7: variabel, percabangan, loop, fungsi, array, pipeline, dan error handling `set -euo pipefail`.

---

## Cara Belajar Efektif Setiap Hari

1. Baca teori di manual resmi (link tersedia tiap bagian) sebelum menyentuh terminal — bangun model mental dulu, baru eksekusi
2. Ketik ulang setiap contoh secara manual, jangan copy-paste — otot jari dan otak butuh membangun refleks bersama
3. Setiap baris kode yang kamu tulis, tanyakan pada diri sendiri: *"apa yang shell lakukan secara harfiah di sini, token demi token?"*
4. Jalankan `bash -x` pada tiap skrip latihan untuk melihat urutan eksekusi sesungguhnya
5. Sebelum lanjut ke hari berikutnya, coba jelaskan materi hari itu ke orang lain (atau ke saya) tanpa melihat catatan — itu tanda pemahaman sudah jadi milikmu, bukan hafalan

[1]: ./bagian-1/README.md
[2]: ./bagian-2/README.md
