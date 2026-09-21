# Escape Sequence

### 1. Escape Sequence Karakter (untuk `echo -e`, `printf`, dan String ANSI-C `$''`)

Bash mendukung escape sequence standar C untuk merepresentasikan karakter khusus yang sulit diketik. Untuk menggunakan escape sequence ini dalam perintah `echo`, Anda harus menggunakan opsi `-e` (misal: `echo -e "Baris1\nBaris2"`).

* `\a` : *Alert* (membunyikan bel/beep pada terminal)
* `\b` : *Backspace* (menghapus satu karakter ke kiri)
* `\c` : Menghilangkan penambahan baris baru (*newline*) di akhir output (hanya berlaku pada `echo -e`)
* `\e` atau `\E` : Karakter *Escape* (umumnya digunakan untuk memicu kode warna atau format teks ANSI)
* `\f` : *Form feed* (halaman baru, jarang digunakan di terminal modern)
* `\n` : *Newline* (pindah ke baris baru)
* `\r` : *Carriage return* (mengembalikan kursor ke awal baris saat ini tanpa turun ke baris baru)
* `\t` : Tab horizontal
* `\v` : Tab vertikal
* `\\` : Menampilkan karakter garis miring terbalik (*backslash*)
* `\'` : Menampilkan tanda kutip tunggal (*single quote*)
* `\"` : Menampilkan tanda kutip ganda (*double quote*)
* `\nnn` : Menampilkan karakter berdasarkan nilai oktalnya (1 hingga 3 digit oktal `n`)
* `\xHH` : Menampilkan karakter berdasarkan nilai heksadesimalnya (1 atau 2 digit heksadesimal `H`)
* `\uHHHH` : Menampilkan karakter Unicode (4 digit heksadesimal `H`)
* `\UHHHHHHHH` : Menampilkan karakter Unicode (8 digit heksadesimal `H`)

### 2. Escape Sequence untuk Prompt Terminal (`PS1`, `PS2`, dsb.)

Selain karakter teks biasa, Bash memiliki serangkaian *escape sequence* khusus yang secara eksklusif dapat dievaluasi ketika menyetel variabel prompt seperti `PS1` (prompt utama di terminal).

**Informasi Waktu & Tanggal:**

* `\t` : Waktu saat ini (format 24-jam `HH:MM:SS`)
* `\T` : Waktu saat ini (format 12-jam `HH:MM:SS`)
* `\@` : Waktu saat ini (format 12-jam `AM/PM`)
* `\A` : Waktu saat ini (format 24-jam `HH:MM` tanpa detik)
* `\d` : Tanggal (format "Hari Bulan Tanggal", misal: `Tue May 26`)
* `\D{format}` : Format tanggal yang disesuaikan (format di dalam kurung kurawal mengacu pada sintaks `strftime` bahasa C)

**Informasi Sistem & Lingkungan:**

* `\u` : Nama pengguna (*username*) pengguna saat ini
* `\h` : *Hostname* komputer (singkat, hingga tanda titik pertama)
* `\H` : *Hostname* komputer penuh (*Fully Qualified Domain Name*)
* `\w` : Direktori kerja saat ini (*current working directory*). Jika direktori berada di bawah direktori beranda pengguna (`$HOME`), jalurnya disingkat dengan tilde (`~`)
* `\W` : Nama dasar (hanya *folder* paling ujung) dari direktori kerja saat ini
* `\l` : Nama *basename* dari perangkat terminal yang sedang digunakan (misal: `ttys001` atau `pts/0`)
* `\s` : Nama aplikasi shell yang sedang digunakan (misal: `bash`)
* `\v` : Versi rilis dari Bash (misal: `5.1`)
* `\V` : Versi rilis beserta *patch level* dari Bash (misal: `5.1.4`)
* `\j` : Jumlah *background jobs* yang sedang dikelola oleh *shell* saat ini

**Informasi Eksekusi & Lainnya:**

* `\$` : Menampilkan tanda `#` jika Anda login sebagai `root` (UID 0), dan menampilkan tanda `$` untuk pengguna biasa
* `\!` : Menampilkan nomor urut baris perintah tersebut pada file *history* Bash
* `\#` : Menampilkan nomor urut (jumlah keberapa) dari perintah tersebut selama sesi Bash saat ini berjalan
* `\[` : Penanda awal untuk karakter *non-printing*. Mutlak diperlukan untuk mengurung *escape sequence* warna (seperti `\e[32m`) di `PS1` agar Bash dapat menghitung panjang teks visual di terminal dengan benar (mencegah bug teks menimpa teks sebelumnya)
* `\]` : Penanda akhir dari urutan karakter *non-printing*
