### **Konteks singkat:** istilah berikut berlaku pada shell POSIX/Bash (Bash = GNU Bourne-Again SHell, implementasi umum ditulis dalam C). Contoh dan perilaku dapat sedikit berbeda pada shell lain (dash, zsh).

---

## 1. POSIX

**Inti:** Standar interoperabilitas untuk shell dan utilitas Unix — mendefinisikan perilaku minimum agar skrip portable antar sistem.
**Poin penting:**

* Menetapkan spesifikasi `sh` dan utilitas core (test, echo, awk, dsb.).
* Fitur Bash yang bukan bagian POSIX tidak boleh digunakan jika ingin portabilitas.

**Contoh (POSIX-compatible script):**

```sh
#!/bin/sh
if [ -f "$1" ]; then
  printf '%s\n' "File ada: $1"
else
  printf '%s\n' "File tidak ditemukan"
fi
```

**Penjelasan token / bagian baris perintah:**

* `#!/bin/sh` → *shebang*: menunjuk interpreter POSIX `sh` (jalankan script dengan shell yang kompatibel POSIX).
* `if` → reserved word memulai percabangan kondisi.
* `[` → biasanya builtin `test` (di POSIX `[` adalah perintah test yang membutuhkan `]` penutup).
* `-f` → test operator: benar jika argumen berikut adalah file reguler yang ada.
* `"$1"` → parameter positional pertama; di-quote untuk mencegah word splitting atau masalah jika ada spasi.
* `]` → penutup `test` (harus ada spasi sebelum `]`).
* `then` → pembuka blok yang dijalankan jika kondisi benar.
* `printf '%s\n' "File ada: $1"` → builtin `printf` (lebih portable daripada `echo`); format `%s\n` dan argument literal; `"$1"` disisipkan.
* `else` → pembuka blok alternatif jika kondisi false.
* `fi` → menutup blok `if`.

---

## 2. Globbing

**Inti:** Wildcard pattern matching untuk nama berkas (shell melakukan pathname expansion dari pola seperti `*`, `?`, `[ ]`).
**Poin penting:**

* Dilakukan oleh shell **sebelum** eksekusi perintah.
* Bukan regex: `*` = nol atau lebih karakter, `?` = satu karakter, `[abc]` = salah satu karakter.
* Perilaku saat tidak ada yang cocok bergantung pada opsi (`nullglob`, `failglob`).

**Contoh:**

```sh
for f in /var/log/*.log; do
  echo "$f"
done
```

**Penjelasan token / bagian baris perintah:**

* `for f in /var/log/*.log; do` → `for` adalah struktur loop; `f` variabel iterasi; `/var/log/*.log` pola glob.

  * `/var/log/` → path direktori.
  * `*.log` → glob: cocokkan semua nama file yang diakhiri `.log`. Shell mengganti pola ini dengan daftar path matching sebelum `for` dieksekusi.
* `echo "$f"` → cetak nilai variabel `f` (di-quote untuk aman terhadap spasi).
* `done` → akhiri loop.

---

## 3. Brace expansion

**Inti:** Ekspansi teks literal oleh shell untuk menghasilkan kombinasi string (mis. `{a,b}`, `{1..5}`), tanpa memeriksa filesystem.
**Poin penting:**

* Dilakukan **sebelum** pathname expansion.
* Berguna untuk membuat banyak nama file/direktori tanpa loop eksternal.

**Contoh:**

```sh
mkdir -p build/{debug,release}
echo file{1,2,3}.txt
```

**Penjelasan token / bagian baris perintah:**

* `mkdir -p build/{debug,release}`

  * `mkdir` → perintah untuk membuat direktori.
  * `-p` → opsi: buat parent jika perlu, jangan error jika sudah ada.
  * `build/{debug,release}` → brace expansion: shell memperluas menjadi `build/debug` dan `build/release` lalu menjalankan `mkdir -p` untuk masing-masing.
* `echo file{1,2,3}.txt` → shell memperluas menjadi `file1.txt file2.txt file3.txt` lalu `echo` mencetak daftar tersebut.

---

## 4. Pathname expansion

**Inti:** Transformasi pola (globs) menjadi daftar path aktual yang ada di filesystem; sering disebut juga bagian dari globbing tetapi menekankan interaksi dengan filesystem.
**Poin penting:**

* Jika pola tidak cocok dan opsi seperti `nullglob` tidak aktif, pola tetap literal — bisa menimbulkan error.
* Memperhatikan permissions dan current working directory.

**Contoh (dengan nullglob untuk menghindari pola literal):**

```sh
shopt -s nullglob
files=( /etc/*.conf )
printf '%s\n' "${files[@]}"
```

**Penjelasan token / bagian baris perintah:**

* `shopt -s nullglob` → `shopt` (shell option): aktifkan `nullglob` sehingga pola tanpa hasil menghasilkan array kosong bukan string literal.
* `files=( /etc/*.conf )` → assignment array: shell melakukan pathname expansion pada `/etc/*.conf` dan menempatkan hasil (daftar file) ke array `files`.
* `printf '%s\n' "${files[@]}"` → `printf` mencetak setiap elemen array sebagai baris terpisah; `"${files[@]}"` memastikan setiap elemen diperlakukan sebagai argumen terpisah (menghindari splitting).

---

## 5. Tilde expansion

**Inti:** `~` di awal kata diekspansi menjadi direktori home; `~user` menjadi home user tertentu.
**Poin penting:**

* Hanya berlaku jika `~` berada di awal kata atau setelah `=`, dan sebelum karakter pemisah.
* Dievaluasi sebelum parameter expansion dan word splitting.

**Contoh:**

```sh
cd ~
echo ~root
touch ~/file.txt
```

**Penjelasan token / bagian baris perintah:**

* `cd ~` → `~` diexpand menjadi path home user saat ini (mis. `/home/username`), `cd` mengubah working directory.
* `echo ~root` → `~root` diexpand menjadi home user `root` (sering `/root`) lalu `echo` mencetaknya.
* `touch ~/file.txt` → `~` diexpand lalu `touch` membuat file `file.txt` di home user.

---

## 6. Parameter expansion

**Inti:** Ekspansi variabel plus operator yang memodifikasi nilai (defaulting, trimming, substitution). Contoh operator: `${var:-default}`, `${var#pattern}`, `${var%pattern}`, `${!prefix*}`.
**Poin penting:**

* Sangat berguna untuk default values, trimming path, substring.
* Beberapa operator juga dapat mengubah variabel (`:=`) atau memicu error (`:?`).

**Contoh:**

```sh
file=${1:-/tmp/default.txt}
base=${file%.*}
dir=${file##*/}
echo "file=$file base=$base dir=$dir"
```

**Penjelasan token / bagian baris perintah:**

* `file=${1:-/tmp/default.txt}`

  * `${1:-/tmp/default.txt}` → jika `$1` kosong atau tidak diset, gunakan `/tmp/default.txt` sebagai default; tidak mengubah `$1`.
  * Assignment `file=...` menyimpan hasil ke variabel `file`.
* `base=${file%.*}` → `${var%pattern}` menghapus **suffix** paling pendek yang cocok dengan `.*` (menghilangkan ekstensi), menghasilkan nama tanpa ekstensi.
* `dir=${file##*/}` → `${var##pattern}` menghapus **prefix** terpanjang sampai pola `*/` (mengambil basename).
* `echo "file=$file base=$base dir=$dir"` → menampilkan hasil; quoting memastikan nilai yang mengandung spasi tetap satu argumen.

---

## 7. Command substitution

**Inti:** Menjalankan perintah dan menggantikan ekspresi `$(...)` (atau backticks) dengan output perintah tersebut.
**Poin penting:**

* Gunakan `$(...)` (lebih aman, bisa dinesting) daripada backticks.
* Output yang dihasilkan tunduk pada word splitting dan globbing kecuali di-quote.

**Contoh:**

```sh
now=$(date +%Y%m%d_%H%M%S)
backup="/var/backups/backup_${now}.tar.gz"
echo "Membuat backup: $backup"
```

**Penjelasan token / bagian baris perintah:**

* `now=$(date +%Y%m%d_%H%M%S)`

  * `$(date +%Y%m%d_%H%M%S)` → jalankan `date` dengan format, hasil (mis. `20251104_101530`) disubstitusi ke string.
  * Assignment `now=...` menyimpan nilai ke variabel `now`.
* `backup="/var/backups/backup_${now}.tar.gz"` → interpolasi variabel `now` ke dalam nama file; `"..."` menjaga seluruh path sebagai satu string.
* `echo "Membuat backup: $backup"` → cetak informasi.

---

## 8. Arithmetic expansion

**Inti:** Evaluasi ekspresi aritmetika dalam `$(( ... ))` menghasilkan nilai integer.
**Poin penting:**

* Operasi integer (tidak ada float).
* Berguna untuk penambahan, perhitungan indeks array, bitwise, dan ekspresi kondisi.

**Contoh:**

```sh
count=5
count=$((count + 1))
limit=$((2**10))
echo "count=$count limit=$limit"
```

**Penjelasan token / bagian baris perintah:**

* `count=5` → set variabel awal.
* `count=$((count + 1))` → `$((...))` evaluasi aritmetika: ambil nilai `count` tambah 1; hasil diassign kembali ke `count`.
* `limit=$((2**10))` → `**` operator pangkat, hasil 1024.
* `echo "count=$count limit=$limit"` → menampilkan hasil.

---

## 9. Process substitution

**Inti:** Menyediakan hasil stdout atau input ke perintah lain sebagai file-like object (`<(cmd)` atau `>(cmd)`), sering diwujudkan sebagai `/dev/fd/*` atau named pipe.
**Poin penting:**

* Berguna saat perintah memerlukan nama file sebagai argumen tetapi data berasal dari proses.
* Tidak tersedia di semua shell atau semua platform; perilaku tergantung implementasi.

**Contoh:**

```sh
diff <(sort fileA.txt) <(sort fileB.txt)
```

**Penjelasan token / bagian baris perintah:**

* `diff` → program pembanding file.
* `<(sort fileA.txt)` → process substitution: menjalankan `sort fileA.txt` dan membuat file descriptor (mis. `/dev/fd/63`) yang `diff` baca sebagai file pertama.
* `<(sort fileB.txt)` → sama untuk fileB.
* `diff` membandingkan isi stream yang terlihat sebagai file oleh proses, tanpa menulis file sementara.

---

## 10. Word splitting

**Inti:** Pembagian hasil ekspansi menjadi kata berdasarkan `IFS` (internal field separator: default spasi, tab, newline).
**Poin penting:**

* Sumber bug umum: variabel tidak di-quote menyebabkan splitting tak diinginkan dan globbing.
* Gunakan `"$var"` atau array untuk menghindari splitting yang tidak diinginkan.

**Contoh (perbandingan salah vs benar):**

```sh
# Salah: berisiko jika ada spasi dalam nama file
files=$HOME/*.txt
for f in $files; do
  echo "$f"
done

# Benar: gunakan array dan quote
shopt -s nullglob
files=( "$HOME"/*.txt )
for f in "${files[@]}"; do
  echo "$f"
done
```

**Penjelasan token / bagian baris perintah:**

* `files=$HOME/*.txt`

  * `$HOME/*.txt` → shell melakukan tilde/parameter expansion lalu pathname expansion; jika ada file dengan spasi, hasilnya nanti akan terkena word splitting saat `for f in $files` dijalankan (jadi `f` bisa terpecah jadi beberapa token).
  * Assignment tanpa quotes → nilai yang mengandung spasi tetap disimpan, namun saat digunakan dalam `for` tanpa quotes akan di-split.
* `shopt -s nullglob` → aktifkan `nullglob` agar pola tanpa hasil tidak menghasilkan string literal pola.
* `files=( "$HOME"/*.txt )` → buat array; `"$HOME"/*.txt` menjaga prefix home di-quote tetapi membiarkan glob berfungsi; hasil setiap file menjadi elemen array tunggal meskipun nama file mengandung spasi.
* `for f in "${files[@]}"; do` → `"${files[@]}"` memperluas setiap elemen array menjadi argumen terpisah tanpa word splitting lebih lanjut; `"$f"` di dalam loop aman untuk spasi.

---

<!--
Jika format dan tingkat detail ini sudah sesuai, saya akan melanjutkan (atau saya dapat mengekspor 71 istilah lengkap + definisi singkat + contoh tokenized ke dalam CSV/Markdown sesuai kebutuhan Anda).
---
Baik — yang akan saya lakukan sekarang:

1. Menyajikan **istilah 11–20** dari daftar Anda.
2. Untuk setiap istilah: **inti singkat**, **poin teknis penting**, **contoh implementasi ringkas**, dan **penjelasan setiap bagian baris perintah / token** pada contoh tersebut (setiap kata/kata kunci/perintah dijelaskan).
3. Tetap ringkas, teknis, dan dalam bahasa Indonesia formal.

**Identitas singkat teknologi**: konteks semua istilah ini adalah shell POSIX / Bash (Bash = GNU Bourne-Again SHell, implementasi umum ditulis dalam bahasa C). Perilaku bisa sedikit berbeda pada shell lain (dash, zsh).

---
-->

## 11. Field splitting (IFS)

**Inti:** Pemisahan kata setelah ekspansi berdasarkan nilai variabel `IFS` (Internal Field Separator).
**Poin penting:**

* Default `IFS` = spasi, tab, newline.
* Mengubah `IFS` memengaruhi `read`, pemrosesan kata dari ekspansi, dan perilaku `for var in $list`.
* Jangan ubah global tanpa lokalizasi (`IFS=',' read ...` atau `IFS=,; ...; unset IFS`).

**Contoh:**

```sh
line="a,b,c"
IFS=',' read -r a b c <<< "$line"
```

**Penjelasan tiap bagian:**

* `line="a,b,c"` — `line` = assignment variabel; `=` tanpa spasi.
* `IFS=','` — assignment sementara variabel lingkungan/context untuk perintah berikut; `,` adalah pemisah.
* `read` — builtin shell yang membaca satu baris dari stdin (atau here-string pada contoh).
* `-r` — opsi `read` yang menonaktifkan interpretasi backslash (mencegah escaping).
* `a b c` — nama variabel target untuk hasil pemisahan; kata pertama ke `a`, kedua ke `b`, sisanya ke `c` jika ada lebih banyak.
* `<<<` — here-string: masukkan string di sebelah kanan sebagai stdin untuk `read`.
* `"$line"` — ekspansi variabel `line` di-quote sehingga menangani whitespace literal; ekspansi terjadi sebelum `IFS` berlaku untuk pemisahan.

---

## 12. Quoting (single / double / ANSI-C)

**Inti:** Mekanisme mengontrol ekspansi dan word splitting; kutipan menentukan apakah variabel/karakter khusus diekspansi.
**Poin penting:**

* Single quotes `'...'` = literal persis, tidak ada ekspansi.
* Double quotes `"..."` = ekspansi variabel dan command substitution tetap terjadi, tetapi mencegah word splitting dan globbing pada hasil.
* ANSI-C quoting `$'...'` mendukung escape sequences seperti `\n`.

**Contoh:**

```sh
name="John Doe"
echo "$name"     # benar; satu argumen berisi spasi
echo $name       # salah jika ada spasi: dua argumen
echo '$HOME'     # tampilkan literal $HOME
```

**Penjelasan tiap bagian:**

* `name="John Doe"` — assignment, value berisi spasi.
* `echo` — perintah builtin untuk mencetak argumen ke stdout.
* `"$name"` — double-quoted ekspansi: substitusi variabel dilakukan, tetapi hasilnya tidak dipecah menjadi beberapa kata.
* `$name` (tanpa quotes) — variabel diekspansi lalu word splitting/globbing diterapkan; menghasilkan kemungkinan banyak argumen.
* `'$HOME'` — single quotes mencegah ekspansi `$HOME`; argumen literal `$HOME`.

---

## 13. Escaping

**Inti:** Penggunaan backslash `\` untuk menetralkan arti khusus karakter berikutnya.
**Poin penting:**

* Backslash efektif di luar single quotes; di dalam double quotes melindungi beberapa karakter.
* Escaping berguna pada file/argument dengan spasi atau karakter khusus.

**Contoh:**

```sh
touch file\ name.txt
echo "Path is \$HOME"
```

**Penjelasan tiap bagian:**

* `touch` — perintah eksternal/builtin untuk membuat file kosong atau memperbarui timestamp.
* `file\ name.txt` — `\ ` meng-escape spasi sehingga shell menganggapnya bagian dari satu nama file; token utuh `file name.txt`.
* `echo "Path is \$HOME"` — `"` membolehkan ekspansi, tetapi `\$HOME` dengan backslash mencegah perluasan `$HOME`; hasil literal `$HOME` ditampilkan.

---

## 14. Here-document

**Inti:** Menyediakan blok teks multiline sebagai stdin untuk perintah (`<<WORD` ... `WORD`).
**Poin penting:**

* Penanda delimiter dapat dikutip (`<<'EOF'`) untuk menonaktifkan ekspansi variabel dan command substitution di dalam blok.
* Berguna untuk membuat input multiline tanpa file sementara.

**Contoh:**

```sh
cat <<'EOF'
Literal $HOME and $(date) not expanded
EOF
```

**Penjelasan tiap bagian:**

* `cat` — perintah yang membaca stdin lalu menulis ke stdout.
* `<<'EOF'` — operator here-document; `'EOF'` (terkutip) menandakan *no expansion* di dalam body.
* Baris antara delimiter — isi yang dikirimkan ke stdin `cat`.
* `EOF` — penutup delimiter harus berada di kolom pertama dan identik dengan pembuka (tanpa spasi tambahan).

---

## 15. Here-string

**Inti:** Versi singkat here-document untuk satu string (`<<< "string"`), memasukkan string sebagai stdin perintah.
**Poin penting:**

* Bermanfaat untuk memberi input singkat tanpa subshell atau file.
* Perilaku ekspansi tetap mengikuti quoting (jika `"$var"` di-quote, tidak terjadi word splitting pada hasil).

**Contoh:**

```sh
grep '^user' <<< "$passwd_line"
```

**Penjelasan tiap bagian:**

* `grep '^user'` — `grep` mencari pola; `'^user'` pola regex (caret = awal baris).
* `<<<` — operator here-string; operan sebelah kanan dikirim sebagai stdin untuk `grep`.
* `"$passwd_line"` — ekspansi variabel sebagai satu string; tidak dipecah oleh IFS karena berada di dalam quotes.

---

## 16. Subshell

**Inti:** Perintah yang dibungkus tanda kurung `(...)` dieksekusi dalam proses anak (subshell); lingkungan (variabel, cwd) tidak mengubah parent.
**Poin penting:**

* Efek samping (cd, export) tidak bertahan ke shell induk.
* Berguna untuk isolasi dan pipeline grouping.

**Contoh:**

```sh
( cd /tmp && ls ) && pwd
```

**Penjelasan tiap bagian:**

* `(` `)` — buka/tutup subshell; semua perintah di dalam dieksekusi di proses terpisah.
* `cd /tmp` — ubah direktori kerja di subshell (tidak memengaruhi parent).
* `&&` — operator logika: jalankan kanan hanya jika kiri sukses (exit status 0).
* `ls` — daftar file di subshell.
* `&& pwd` — setelah subshell sukses, `pwd` (di parent) menampilkan direktori kerja parent.

---

## 17. Command grouping (`{ ... ; }`)

**Inti:** Sekuens perintah dibungkus `{ ... ; }` dieksekusi di shell saat ini sebagai satu daftar perintah (bukan subshell).
**Poin penting:**

* Berbeda dengan `(...)`: perubahan lingkungan (mis. `cd`) bertahan.
* Sintaks membutuhkan spasi setelah `{` dan `;` sebelum `}`.

**Contoh:**

```sh
{ cd /tmp; echo "now $(pwd)"; } > /dev/null
```

**Penjelasan tiap bagian:**

* `{` `}` — buka/tutup grouping di shell saat ini (bukan subshell).
* `cd /tmp;` — perintah pertama; `;` memisahkan perintah.
* `echo "now $(pwd)"` — echo hasil `pwd` (command substitution) di shell yang sama setelah `cd`.
* `> /dev/null` — mengalihkan stdout dari seluruh grup ke `/dev/null` (semua output group ditangkap).

---

## 18. Pipelines

**Inti:** Operator `|` menghubungkan stdout proses kiri ke stdin proses kanan.
**Poin penting:**

* Data mengalir streaming; efisien untuk pemrosesan besar.
* Exit status pipeline = status dari perintah terakhir kecuali `set -o pipefail` mengubahnya menjadi non-zero jika salah satu gagal.

**Contoh:**

```sh
ps aux | grep '[s]shd' | awk '{print $2}'
```

**Penjelasan tiap bagian:**

* `ps aux` — daftar proses (BSD style).
* `|` — pipe: stdout `ps` menjadi stdin `grep`.
* `grep '[s]shd'` — cari baris yang mengandung `sshd`; penggunaan `[s]shd` mencegah `grep` sendiri muncul pada daftar proses (trick regex).
* `|` — pipe lagi: hasil `grep` ke `awk`.
* `awk '{print $2}'` — cetak kolom kedua (umumnya PID).
* Hasil akhir adalah daftar PID yang cocok.

---

## 19. Job control

**Inti:** Mekanisme manajemen tugas/background di shell interaktif (`&`, `jobs`, `fg`, `bg`, `%N`).
**Poin penting:**

* `&` menjalankan proses di background; `$!` berisi PID job terakhir.
* `Ctrl-Z` menghentikan (SIGTSTP) foreground job; `bg` melanjutkan di background, `fg` membawa job ke foreground.
* Job numbering `%1`, `%name` sebagai job spec.

**Contoh:**

```sh
sleep 300 &
echo "PID: $!"
jobs
```

**Penjelasan tiap bagian:**

* `sleep 300` — jalankan perintah yang tidur 300 detik.
* `&` — jalankan `sleep` di background (shell segera kembali).
* `echo "PID: $!"` — `$!` variabel special yang berisi PID dari proses background terakhir; `echo` mencetaknya.
* `jobs` — builtin menampilkan daftar job shell (job id dan status).

---

## 20. File descriptors

**Inti:** Representasi numerik stream I/O: `0`=stdin, `1`=stdout, `2`=stderr; shell dapat membuka/duplikasi/redirect FD lain (3–n).
**Poin penting:**

* Redirection `2>&1` menyalin stderr ke stdout (perhatikan urutan).
* `exec` bisa membuka atau mengganti FD pada shell tanpa memulai proses baru (`exec 3>file`).
* Menutup FD: `exec 3>&-`.

**Contoh 1 (redirect gabungan):**

```sh
cmd >out.log 2>&1
```

**Penjelasan tiap bagian:**

* `cmd` — perintah apa pun.
* `>out.log` — redirect stdout (fd 1) ke file `out.log` (create/truncate).
* `2>&1` — duplicate fd 2 (stderr) ke target fd 1 yang saat ini menunjuk ke `out.log`; penting: lakukan setelah `>out.log` sehingga fd1 sudah benar.

**Contoh 2 (open FD kustom):**

```sh
exec 3< config.txt
read -u 3 line
exec 3<&-
```

**Penjelasan tiap bagian:**

* `exec` — builtin yang mengganti proses shell saat ini tanpa fork (juga memanipulasi FD).
* `3< config.txt` — buka file `config.txt` untuk membaca dan hubungkan ke FD nomor 3.
* `read -u 3 line` — `read` membaca dari FD 3 (`-u 3`) ke variabel `line`.
* `exec 3<&-` — tutup FD 3 (`<&-` menutup pembacaan FD).

---

### **11. Field Splitting (IFS – Internal Field Separator)**

**Inti:**
Field splitting adalah proses pemisahan string menjadi beberapa bagian (field) berdasarkan karakter pemisah yang ditentukan oleh variabel `IFS`. Default-nya adalah spasi, tab, dan newline.

**Poin penting:**

* Terjadi setelah ekspansi parameter atau substitusi perintah.
* Sangat berpengaruh dalam pemrosesan input dan loop.

**Contoh implementasi:**

```bash
IFS=',' read -r a b c <<< "satu,dua,tiga"
echo "$a" "$b" "$c"
```

**Penjelasan:**

* `IFS=','` → Mengubah pemisah default menjadi koma.
* `read -r a b c` → Membaca input ke tiga variabel.
* `<<<` → Operator **here-string**, mengirimkan string langsung ke `stdin`.
* `"satu,dua,tiga"` → Input yang akan dipecah menjadi tiga bagian.
  Hasil: `satu dua tiga`.

---

### **12. Quoting (Single, Double, ANSI-C Quoting)**

**Inti:**
Quoting digunakan untuk mengontrol ekspansi. Tujuannya adalah menjaga literal agar tidak diekspansi atau diproses oleh shell.

**Poin penting:**

* `'single quotes'` → Melindungi seluruh isi dari ekspansi.
* `"double quotes"` → Mengizinkan ekspansi parameter (`$var`) tapi menonaktifkan globbing.
* `$'ansi'` → Memungkinkan karakter khusus seperti `\n`, `\t`.

**Contoh implementasi:**

```bash
nama="Bash"
echo '$nama'     # Tidak diekspansi
echo "$nama"     # Diekspansi menjadi Bash
echo $'Baris\nBaru'
```

---

### **13. Escaping**

**Inti:**
Escape digunakan untuk menonaktifkan arti khusus dari karakter tunggal dalam konteks tertentu.

**Poin penting:**

* Menggunakan backslash (`\`) untuk literal.
* Digunakan saat tidak ingin quoting penuh.

**Contoh:**

```bash
echo Hello\ World
```

`Hello\ World` → `\` mencegah spasi dianggap sebagai pemisah argumen, hasil: `Hello World`.

---

### **14. Here-Document (<<)**

**Inti:**
Here-document memungkinkan input multiline dikirim ke `stdin` suatu perintah.

**Poin penting:**

* Dimulai dengan `<<` diikuti delimiter.
* Baris di antara delimiter diperlakukan sebagai input literal.
* Quoting delimiter menentukan apakah ekspansi aktif.

**Contoh:**

```bash
cat <<EOF
Halo $USER
Ini contoh here-doc
EOF
```

`cat` membaca input sampai baris `EOF` ditemukan. Karena `EOF` tidak di-quote, `$USER` akan diekspansi.

---

### **15. Here-String (<<<)**

**Inti:**
Here-string adalah bentuk ringkas dari here-document untuk satu baris input.

**Poin penting:**

* Mengirimkan string langsung ke `stdin`.
* Berguna untuk tes cepat atau fungsi.

**Contoh:**

```bash
grep root <<< "root:x:0:0:root:/root:/bin/bash"
```

`<<<` mengirim string ke `grep` seolah berasal dari file.

---

### **16. Subshell**

**Inti:**
Subshell adalah proses turunan dari shell utama, digunakan untuk menjalankan perintah terisolasi.

**Poin penting:**

* Dijalankan dengan tanda kurung `( )`.
* Variabel di dalam subshell tidak memengaruhi parent shell.

**Contoh:**

```bash
( cd /etc && ls )
pwd
```

`cd /etc` hanya berlaku di subshell, direktori kerja utama tidak berubah.

---

### **17. Command Grouping**

**Inti:**
Command grouping mengelompokkan beberapa perintah agar diperlakukan sebagai satu unit.

**Poin penting:**

* `{ ...; }` menjalankan dalam shell saat ini.
* `( ... )` menjalankan dalam subshell.

**Contoh:**

```bash
{ cd /etc; echo "Sekarang di $(pwd)"; }
```

`{}` mengeksekusi dalam shell utama, jadi `cd` tetap berlaku setelah blok.

---

### **18. Pipelines (|)**

**Inti:**
Pipeline menyalurkan keluaran `stdout` dari satu perintah menjadi `stdin` perintah berikutnya.

**Poin penting:**

* Simbol `|` digunakan untuk menghubungkan perintah.
* Status pipeline tergantung pada exit code terakhir (kecuali `set -o pipefail`).

**Contoh:**

```bash
ps aux | grep bash | awk '{print $2}'
```

* `ps aux` → Menampilkan semua proses.
* `| grep bash` → Menyaring baris berisi kata “bash”.
* `| awk '{print $2}'` → Menampilkan kolom kedua (PID).

---

### **19. Job Control**

**Inti:**
Job control memungkinkan pengelolaan proses latar belakang dan foreground di shell interaktif.

**Poin penting:**

* `&` untuk menjalankan background.
* `jobs` menampilkan daftar proses.
* `fg`, `bg` untuk memindahkan job antar mode.

**Contoh:**

```bash
sleep 30 &
jobs
fg %1
```

Menjalankan `sleep` di background, lalu memindahkannya ke foreground.

---

### **20. File Descriptors (FD)**

**Inti:**
File descriptor adalah integer yang mewakili file atau stream I/O.

**Poin penting:**

* 0 = stdin, 1 = stdout, 2 = stderr.
* Dapat dialihkan atau digandakan untuk kontrol output/error.

**Contoh:**

```bash
echo "Pesan error" 1>&2
```

* `1>` → stdout.
* `&2` → Arahkan stdout ke stderr.
  Output akan dikirim ke aliran error standar.

---

### **21. Redirection**

**Inti:**
Redirection adalah mekanisme untuk mengubah aliran standar input/output/error dari dan ke file, perangkat, atau proses lain.

**Poin penting:**

* `>` menulis ke file (overwrite).
* `>>` menulis dengan append.
* `<` membaca dari file.
* `2>` mengarahkan stderr.
* `&>` mengarahkan stdout dan stderr sekaligus.

**Contoh implementasi:**

```bash
ls /root > out.txt 2> err.txt
```

**Penjelasan:**

* `ls /root` → Perintah utama.
* `> out.txt` → stdout (hasil normal) ditulis ke file `out.txt`.
* `2> err.txt` → stderr (error output) ditulis ke `err.txt`.
  Jika direktori tidak dapat diakses, pesan error disimpan di `err.txt`.

---

### **22. Descriptor Duplication**

**Inti:**
Teknik untuk menyalin atau mengalihkan file descriptor yang sudah ada ke descriptor lain.

**Poin penting:**

* `n>&m` menduplikasi `m` ke `n`.
* `n<&m` menduplikasi input descriptor.

**Contoh:**

```bash
exec 3>&1
ls /root 1>&3 2>&1
```

**Penjelasan:**

* `exec 3>&1` → Membuka descriptor `3` sebagai salinan `stdout`.
* `ls /root 1>&3` → stdout dikirim ke FD 3 (yakni layar).
* `2>&1` → stderr diarahkan ke stdout, sehingga keduanya tampil di layar.

---

### **23. Standard Streams (stdin, stdout, stderr)**

**Inti:**
Tiga aliran data utama dalam shell: input (0), output (1), dan error (2).

**Poin penting:**

* Dikelola oleh kernel.
* Dapat diarahkan ke file atau program lain.

**Contoh:**

```bash
command < input.txt > output.txt 2> error.log
```

`<` → stdin membaca dari file.
`>` → stdout menulis ke file.
`2>` → stderr menulis ke file lain.

---

### **24. Exit Status**

**Inti:**
Kode keluaran numerik (0–255) yang menunjukkan hasil eksekusi perintah.

**Poin penting:**

* `0` berarti sukses.
* Non-0 berarti error.
* Tersimpan di `$?`.

**Contoh:**

```bash
grep "root" /etc/passwd
echo $?
```

Jika string ditemukan, `echo $?` menghasilkan `0`; jika tidak, hasilnya `1`.

---

### **25. Signals**

**Inti:**
Mekanisme komunikasi antar-proses untuk mengatur perilaku, menghentikan, atau menangani peristiwa sistem.

**Poin penting:**

* Contoh: `SIGINT`, `SIGTERM`, `SIGHUP`.
* Dikirim oleh sistem atau pengguna (`kill`, `trap`).

**Contoh:**

```bash
sleep 100 &
kill -SIGINT $!
```

* `sleep 100 &` → Jalankan di background.
* `$!` → PID proses terakhir di background.
* `kill -SIGINT $!` → Kirim sinyal interupsi ke proses tersebut.

---

### **26. trap (Signal Handling)**

**Inti:**
Perintah `trap` digunakan untuk menangkap sinyal dan mengeksekusi perintah tertentu ketika sinyal diterima.

**Poin penting:**

* Berguna untuk pembersihan resource sebelum keluar.
* Dapat menangani EXIT, SIGINT, SIGTERM, dsb.

**Contoh:**

```bash
trap 'echo "Dihentikan!"; exit' SIGINT
while true; do sleep 1; done
```

Ketika ditekan `Ctrl+C`, `SIGINT` dikirim, `trap` menangkap dan menampilkan pesan “Dihentikan!”.

---

### **27. Environment Variables**

**Inti:**
Variabel global yang diwariskan ke proses anak.

**Poin penting:**

* Disimpan di lingkungan shell.
* Digunakan untuk konfigurasi sistem dan program.

**Contoh:**

```bash
export PATH="$PATH:/opt/bin"
echo $PATH
```

`export` menambahkan `/opt/bin` ke variabel lingkungan `PATH` yang akan diwariskan ke proses lain.

---

### **28. Local Variables**

**Inti:**
Variabel yang hanya berlaku di dalam shell saat ini atau fungsi.

**Poin penting:**

* Tidak diwariskan ke proses anak.
* Didefinisikan tanpa `export`, atau dengan `local` di dalam fungsi.

**Contoh:**

```bash
myfunc() {
  local var="lokal"
  echo "$var"
}
myfunc
echo "$var"  # kosong
```

Variabel `var` hanya hidup di dalam fungsi `myfunc`.

---

### **29. Exporting Variables**

**Inti:**
Proses menjadikan variabel lokal menjadi environment variable agar dapat diakses oleh proses anak.

**Poin penting:**

* Dilakukan dengan `export`.
* Penting untuk mengatur PATH, LANG, EDITOR, dll.

**Contoh:**

```bash
VAR="contoh"
export VAR
bash -c 'echo $VAR'
```

Shell baru mewarisi variabel `VAR` karena sudah diekspor.

---

### **30. Shell Functions**

**Inti:**
Fungsi adalah blok perintah bernama yang dapat dipanggil ulang, seperti subroutine.

**Poin penting:**

* Mendukung parameter (`$1`, `$2`, dst).
* Mewarisi environment shell.
* Dapat mengembalikan status dengan `return`.

**Contoh:**

```bash
greet() {
  echo "Halo, $1!"
}
greet "Cendekiawan"
```

* `greet()` → Mendefinisikan fungsi bernama `greet`.
* `$1` → Argumen pertama saat fungsi dipanggil.
* Output: `Halo, Cendekiawan!`

---

### **31. Arrays (Indexed Arrays)**

**Inti:**
Array adalah kumpulan nilai yang diakses melalui indeks numerik.

**Poin penting:**

* Indeks dimulai dari 0.
* Diinisialisasi dengan tanda kurung `( )`.
* Diakses menggunakan `${array[index]}`.

**Contoh:**

```bash
fruits=("apel" "pisang" "mangga")
echo "${fruits[1]}"
```

**Penjelasan:**

* `fruits=(...)` → Membuat array berisi tiga elemen.
* `${fruits[1]}` → Mengakses elemen ke-2 (`pisang`).

---

### **32. Associative Arrays**

**Inti:**
Array dengan indeks berupa string (key-value map).

**Poin penting:**

* Dideklarasikan dengan `declare -A`.
* Diakses dengan nama kunci.

**Contoh:**

```bash
declare -A user
user[name]="Cendekiawan"
user[role]="Pelajar IT"
echo "${user[name]} - ${user[role]}"
```

`declare -A` → Mendefinisikan associative array.
`${user[key]}` → Mengambil nilai berdasarkan kunci.

---

### **33. Variable Substitution (Modifikator)**

**Inti:**
Mekanisme untuk memodifikasi nilai variabel saat ekspansi.

**Poin penting:**

* `${var:-default}` → Gunakan nilai default jika kosong.
* `${var:=default}` → Setel default jika belum ada.
* `${var:+alt}` → Gunakan `alt` jika variabel diset.

**Contoh:**

```bash
echo "${USER:-guest}"
```

Jika `$USER` tidak diset, hasilnya `guest`.

---

### **34. Positional Parameters**

**Inti:**
Parameter otomatis yang berisi argumen yang diteruskan ke skrip atau fungsi.

**Poin penting:**

* `$0` → Nama skrip.
* `$1, $2, ...` → Argumen ke-n.
* `$#` → Jumlah argumen.

**Contoh:**

```bash
echo "Nama skrip: $0"
echo "Argumen pertama: $1"
```

Menjalankan `./script.sh data.txt` → Output: `data.txt` sebagai `$1`.

---

### **35. Special Parameters**

**Inti:**
Variabel bawaan dengan makna khusus dalam shell.

**Contoh umum:**

* `$?` → Exit status terakhir.
* `$$` → PID shell saat ini.
* `$!` → PID background terakhir.
* `$@` / `$*` → Semua argumen.

**Contoh:**

```bash
sleep 100 &
echo "PID: $!"
```

Menampilkan PID dari proses `sleep` yang dijalankan di background.

---

### **36. Shell Options (set, shopt)**

**Inti:**
Konfigurasi perilaku shell melalui `set` atau `shopt`.

**Poin penting:**

* `set -e` → Keluar saat error.
* `set -x` → Debug tracing.
* `shopt -s extglob` → Aktifkan ekstensi globbing.

**Contoh:**

```bash
set -x
echo "Debug aktif"
set +x
```

`set -x` menampilkan setiap perintah sebelum dieksekusi, berguna untuk debugging.

---

### **37. Restricted Shell (rbash)**

**Inti:**
Mode terbatas dari Bash yang membatasi operasi tertentu untuk keamanan.

**Poin penting:**

* Pengguna tidak bisa mengubah direktori (`cd`).
* Tidak bisa mengubah PATH atau mengeksekusi file di luar direktori tertentu.

**Contoh:**

```bash
rbash
```

Shell berjalan dalam mode terbatas, biasanya digunakan pada sistem multi-user untuk pembatasan akses.

---

### **38. Login vs Non-login Shell**

**Inti:**
Dua mode shell yang menentukan file konfigurasi mana yang dibaca saat startup.

**Poin penting:**

* **Login shell** membaca `/etc/profile` dan `~/.bash_profile`.
* **Non-login shell** membaca `~/.bashrc`.

**Contoh:**

```bash
bash --login
```

Menjalankan bash dalam mode login dan memuat file profil sistem dan pengguna.

---

### **39. Interactive vs Non-interactive Shell**

**Inti:**
Perbedaan antara shell yang berinteraksi langsung dengan pengguna dan shell yang hanya mengeksekusi skrip.

**Poin penting:**

* Interactive menampilkan prompt (`PS1`) dan menunggu input.
* Non-interactive dijalankan melalui skrip (misal, cron job).

**Contoh:**

```bash
bash -c 'echo Non-interaktif'
```

`-c` menjalankan perintah tunggal tanpa membuka prompt interaktif.

---

### **40. Tokenization**

**Inti:**
Proses pemisahan teks input menjadi token — unit logis seperti kata, operator, atau tanda kurung sebelum parsing.

**Poin penting:**

* Tahap pertama dalam eksekusi skrip.
* Dipengaruhi oleh quoting dan escaping.

**Contoh:**

```bash
echo "satu dua" tiga
```

Token: `"satu dua"` dianggap satu token (karena quote), `tiga` adalah token kedua.

---

### 41. Parsing (Parsing Shell)

**Inti:**
Proses mengubah rangkaian token menjadi struktur perintah yang akan dieksekusi (stage setelah tokenization).

**Poin penting:**

* Parsing menentukan struktur kontrol (`if`, `for`, `case`), redirections, dan grouping.
* Dipengaruhi oleh quoting dan operator; kesalahan parsing = syntax error.

**Contoh:**

```bash
if [ -f "$1" ]; then echo ok; fi
```

**Penjelasan token:**

* `if` → kata kunci memulai blok kondisi.
* `[` → builtin atau symlink ke `test` (awalnya token pembuka test).
* `-f` → operator test file (true jika argumen berikut adalah file biasa).
* `"$1"` → ekspansi parameter pertama, di-quote untuk mencegah word splitting.
* `]` → penutup test.
* `then` → pemisah bagian kondisi benar.
* `echo` → perintah builtin pencetak argumen.
* `ok` → argumen untuk `echo`.
* `;` → pemisah perintah (bisa juga newline).
* `fi` → penutup blok `if`.

---

### 42. Evaluation Order / Expansion Order

**Inti:**
Urutan terjadinya ekspansi/transformasi (tilde → parameter → command → arithmetic → word splitting → pathname expansion).

**Poin penting:**

* Memahami urutan penting untuk mencegah bug (mis. meng-quote pada saat yang tepat).
* Contoh: command substitution dievaluasi sebelum word splitting jika tidak di-quote.

**Contoh:**

```bash
files=$(echo *.sh)
echo "$files"
```

**Penjelasan token & urutan:**

1. `*.sh` — pathname expansion pertama kali? sebenarnya shell melakukan brace/tilde/parameter/command/arithmetic expansions, lalu word splitting dan pathname expansion — di sini `echo *.sh` dijalankan di subshell melalui `$(...)`.
2. `$(...)` → command substitution: menjalankan `echo *.sh`.
3. `echo` → menjalankan dengan argumen yang sudah di-glob oleh subshell.
4. Hasil substitusi disimpan ke `files`.
5. `echo "$files"` → di-quote sehingga tidak terjadi word splitting.

---

### 43. Command Hashing

**Inti:**
Shell menyimpan lokasi path executable yang pernah dijalankan (hash table) untuk mempercepat lookup.

**Poin penting:**

* Perubahan PATH setelah hashing mungkin tidak berpengaruh sampai hash di-refresh (`hash -r`).
* `hash` menampilkan/mengelola cache ini.

**Contoh:**

```bash
which mycmd
hash -r
```

**Penjelasan token:**

* `which mycmd` → mencari executable `mycmd` di PATH (eksternal tool, bukan selalu builtin).
* `hash -r` → builtin Bash mengosongkan cache lokasi perintah sehingga lookup akan dilakukan ulang.

---

### 44. Command Search Path (PATH lookup)

**Inti:**
Algoritma pencarian executable berdasarkan urutan direktori dalam variabel lingkungan `PATH`.

**Poin penting:**

* Jika perintah tidak mengandung `/`, shell mencari di PATH.
* Urutan PATH menentukan executable mana yang dijalankan.

**Contoh:**

```bash
echo $PATH
/usr/local/bin/myprog
```

**Penjelasan token:**

* `echo` → menampilkan nilai `PATH`.
* `$PATH` → ekspansi environment variable berisi daftar direktori dipisah `:`.
* Ketika mengeksekusi `myprog`, shell akan memeriksa setiap direktori di `$PATH` sesuai urutan.

---

### 45. Aliases

**Inti:**
Alias adalah substitusi teks sederhana untuk perintah yang didefinisikan oleh pengguna (`alias ll='ls -la'`).

**Poin penting:**

* Hanya berlaku pada parsing baris perintah interaktif (default).
* Jangan gunakan alias di skrip jika ingin predictable behavior; gunakan fungsi.

**Contoh:**

```bash
alias ll='ls -la'
ll /tmp
```

**Penjelasan token:**

* `alias ll='ls -la'` → mendefinisikan alias `ll` yang menggantikan token `ll` dengan `ls -la` saat parsing.
* `ll /tmp` → saat dieksekusi, parser menggantikan `ll` → `ls -la /tmp`.

---

### 46. History Expansion

**Inti:**
Fitur interaktif yang memungkinkan reuse perintah sebelumnya (mis. `!!`, `!$`, `!123`).

**Poin penting:**

* Hanya berlaku di shell interaktif kecuali dinonaktifkan (`set +o histexpand`).
* Dapat berisiko jika digunakan tanpa hati-hati (membocorkan perintah sensitif).

**Contoh:**

```bash
echo hello
!!
```

**Penjelasan token:**

* `echo hello` → perintah pertama disimpan di history.
* `!!` → history expansion: menggantikan `!!` dengan perintah terakhir (`echo hello`) lalu mengeksekusinya lagi.

---

### 47. Prompting (PS1 / PS2 / PS4)

**Inti:**
Variabel yang mengatur tampilan prompt shell dan tracing prefix (PS4 untuk `set -x`).

**Poin penting:**

* `PS1` adalah prompt utama interaktif.
* `PS4` muncul saat tracing (`set -x`), berguna untuk debugging.

**Contoh:**

```bash
PS4='+ $BASH_SOURCE:$LINENO: '
set -x
ls /tmp
set +x
```

**Penjelasan token:**

* `PS4='+ $BASH_SOURCE:$LINENO: '` → atur prefix untuk debugging yang menunjukkan file dan nomor baris.
* `set -x` → aktifkan tracing; setiap perintah akan diprint dengan prefix PS4.
* `ls /tmp` → perintah yang akan terlihat dalam trace.
* `set +x` → matikan tracing.

---

### 48. Builtins vs External Commands

**Inti:**
Perbedaan antara perintah internal shell (builtin) dan program eksternal di filesystem.

**Poin penting:**

* Builtin lebih cepat dan dapat mengubah lingkungan shell (contoh: `cd`, `read`, `export`).
* External dieksekusi sebagai proses terpisah.

**Contoh:**

```bash
type cd
type ls
```

**Penjelasan token:**

* `type cd` → menampilkan apakah `cd` adalah builtin (biasanya builtin).
* `type ls` → biasanya menunjukkan `ls` sebagai file di `/bin/ls` (external).
* Perbedaan penting: `cd` memodifikasi cwd shell; `ls` tidak.

---

### 49. pipefail / Perilaku Exit pada Pipeline

**Inti:**
`set -o pipefail` mengubah exit status pipeline sehingga non-zero jika **salah satu** komponen pipeline gagal.

**Poin penting:**

* Default: exit status pipeline = exit status perintah terakhir.
* `pipefail` berguna untuk deteksi error yang tersembunyi di tengah pipeline.

**Contoh:**

```bash
set -o pipefail
false | true
echo $?   # menghasilkan non-zero karena 'false' gagal
```

**Penjelasan token:**

* `set -o pipefail` → mengaktifkan opsi pipefail.
* `false` → perintah yang selalu exit non-zero.
* `|` → pipeline menghubungkan stdout `false` (kosong) ke `true`.
* `true` → perintah terakhir exit 0; tapi dengan pipefail aktif, pipeline exit non-zero karena `false`.
* `echo $?` → menampilkan exit status pipeline.

---

### 50. Process IDs dan Job IDs

**Inti:**
Identifikasi proses (PID) dan nomor job shell (`%1`, `%2`) untuk manajemen proses.

**Poin penting:**

* PID unik di sistem; `$!` memberikan PID proses terakhir background.
* Job ID adalah nomor lokal shell untuk memanipulasi job (fg/bg).

**Contoh:**

```bash
sleep 200 &
echo "PID=$!"
jobs
fg %1
```

**Penjelasan token:**

* `sleep 200 &` → jalankan `sleep` di background (`&`).
* `$!` → special parameter berisi PID proses background terakhir.
* `jobs` → daftar job yang diketahui shell (menampilkan job id seperti `[1]`).
* `fg %1` → membawa job nomor 1 ke foreground (`%1` adalah job spec).

---
<!--
Berikutnya **51–60** akan menjelaskan termasuk extglob, globstar, nullglob/failglob, kategori ekspansi, command line editing, substitution modifiers, parameter pattern operators, command prefixes, shell test, file test operators.
-->

Bagian ini membahas mekanisme *eksekusi, environment, job control, hingga signal handling*. Ini adalah lapisan penting yang menjelaskan bagaimana Bash berinteraksi dengan kernel dan mengatur proses di sistem UNIX-like.

---

### **51. Command Substitution**

**Inti:**
Menjalankan perintah dan menggantinya dengan hasil output-nya.

**Poin penting:**

* Sintaks: `` `command` `` atau `$(command)`
* Umumnya digunakan dalam assignment variabel atau argumen perintah.

**Contoh:**

```bash
now=$(date +%H:%M)
echo "Waktu saat ini: $now"
```

Penjelasan:

* `$(date +%H:%M)` menjalankan `date` dan menempatkan hasilnya di variabel `now`.
* `echo` menampilkan string beserta hasil substitusinya.

---

### **52. Arithmetic Expansion**

**Inti:**
Melakukan evaluasi ekspresi aritmetika di dalam shell.

**Poin penting:**

* Sintaks: `$((expression))`
* Hanya mendukung operasi integer (+, -, *, /, %, **, <<, >>, dsb.)

**Contoh:**

```bash
a=5; b=3
echo $((a*b+2))
```

Evaluasi `5*3+2` menghasilkan `17`.

---

### **53. Process Substitution**

**Inti:**
Menghubungkan output/input perintah ke file descriptor sementara (pseudo-file).

**Poin penting:**

* Sintaks: `<(command)` atau `>(command)`
* Berguna saat perintah membutuhkan nama file sebagai input.

**Contoh:**

```bash
diff <(ls /bin) <(ls /usr/bin)
```

`<(ls /bin)` dan `<(ls /usr/bin)` masing-masing membuat *named pipe* sementara, memungkinkan `diff` membandingkan dua daftar.

---

### **54. Command Grouping**

**Inti:**
Menjalankan beberapa perintah sebagai satu unit.

**Poin penting:**

* Kurung kurawal `{ ...; }` → dijalankan di shell saat ini.
* Kurung biasa `( ... )` → dijalankan di subshell.

**Contoh:**

```bash
{ echo "Mulai"; ls; echo "Selesai"; }
```

Dijalankan secara berurutan di shell aktif.
Sedangkan `(cd /tmp; ls)` akan mengubah direktori hanya di subshell.

---

### **55. Environment Variables**

**Inti:**
Variabel global yang diwariskan ke proses turunan.

**Poin penting:**

* Dibuat dengan `export`.
* Disimpan di ruang memori shell.
* Umum: `$PATH`, `$HOME`, `$SHELL`, `$LANG`.

**Contoh:**

```bash
export EDITOR=nvim
echo $EDITOR
```

`export` menandai variabel agar tersedia bagi semua proses yang dijalankan dari shell itu.

---

### **56. PATH Lookup**

**Inti:**
Mekanisme pencarian lokasi perintah berdasarkan variabel `PATH`.

**Poin penting:**

* Shell mencari file yang dieksekusi dalam direktori yang terdaftar di `$PATH`.
* Gunakan `which` atau `type` untuk mengetahui lokasi perintah.

**Contoh:**

```bash
echo $PATH
which bash
```

Menampilkan direktori pencarian dan lokasi eksekusi `bash`.

---

### **57. Command Hashing**

**Inti:**
Shell menyimpan cache lokasi perintah agar eksekusi lebih cepat.

**Poin penting:**

* Tabel hash disimpan per sesi.
* `hash -r` digunakan untuk mereset cache.

**Contoh:**

```bash
hash
hash -r
```

`hash` tanpa argumen menampilkan daftar perintah yang sudah di-cache.

---

### **58. Job Control**

**Inti:**
Mekanisme untuk mengelola proses (jobs) yang berjalan di foreground atau background.

**Poin penting:**

* `&` → menjalankan proses di background.
* `jobs` → melihat daftar proses.
* `fg` dan `bg` → memindahkan job antar mode.

**Contoh:**

```bash
sleep 60 &
jobs
fg %1
```

* `sleep 60 &` → job 1 di background.
* `fg %1` → mengembalikannya ke foreground.

---

### **59. Signals**

**Inti:**
Mekanisme interupsi untuk mengontrol proses (misalnya berhenti, lanjut, atau matikan).

**Poin penting:**

* `kill -l` → menampilkan daftar sinyal.
* Umum: `SIGINT` (Ctrl+C), `SIGTERM`, `SIGHUP`, `SIGKILL`.

**Contoh:**

```bash
sleep 300 &
kill -SIGTERM $!
```

`$!` berisi PID dari background process, lalu dikirim sinyal `SIGTERM` untuk menghentikannya.

---

### **60. Trap**

**Inti:**
Menangkap sinyal tertentu dan menjalankan perintah penanganan (handler).

**Poin penting:**

* Berguna untuk cleanup atau logging sebelum proses berakhir.
* Sintaks: `trap 'commands' SIGNAL`.

**Contoh:**

```bash
trap 'echo "Dihentikan oleh user"; exit' SIGINT
while true; do echo "Berjalan..."; sleep 1; done
```

Menangkap `Ctrl+C` dan menjalankan pesan sebelum keluar dari loop.

<!--
Bagian berikut (**61–71**) adalah penutup seri ini: mencakup **security model, login environment, shell startup order, reserved words, quoting rules lanjutan, escaping, dan keyword meta-behavior** — yakni bagian yang memperjelas *bagaimana shell memahami dan membatasi dirinya sendiri*.
-->
---

Kita masuk ke **bagian terakhir (61–71)** — bab penutup yang membahas *mekanisme internal shell yang paling dalam*: keamanan, urutan startup, reserved word, quoting lanjutan, escaping, hingga perilaku sintaks meta. Bagian ini menjelaskan bagaimana Bash menjaga konsistensi dan kontrol terhadap eksekusi.

### **61. Shell Security Model**

**Inti:**
Sistem keamanan Bash bergantung pada mekanisme izin UNIX dan kontrol lingkungan eksekusi.

**Poin penting:**

* Tidak mengeksekusi file tanpa izin `+x`.
* Variabel lingkungan diwariskan ke proses anak; karenanya manipulasi `$PATH` atau `$IFS` bisa berisiko.
* Scripting aman memerlukan sanitasi input (`"$var"` selalu di-quote).

**Contoh:**

```bash
IFS=:
for path in $PATH; do echo "$path"; done
```

Menampilkan semua direktori di `$PATH`. Manipulasi `IFS` yang salah dapat menyebabkan *command injection* jika tidak di-quote dengan benar.

---

### **62. Shell Startup Files**

**Inti:**
File konfigurasi yang dibaca saat Bash dimulai, tergantung pada mode shell (login atau non-login).

**Poin penting:**

* `/etc/profile` → konfigurasi sistem global.
* `~/.bash_profile` → konfigurasi login shell user.
* `~/.bashrc` → konfigurasi interaktif non-login.
* `~/.bash_logout` → dijalankan saat logout.

**Contoh:**

```bash
echo 'export PATH=$PATH:~/scripts' >> ~/.bashrc
source ~/.bashrc
```

Menambahkan direktori `~/scripts` ke `PATH` dan memuat ulang konfigurasi.

---

### **63. Restricted Mode Behavior**

**Inti:**
Mode terbatas (`rbash`) yang membatasi pengguna agar tidak mengeksekusi atau memodifikasi lingkungan shell.

**Poin penting:**

* Tidak dapat menjalankan perintah dengan `/` di dalam path.
* Tidak bisa menggunakan `cd`, `set`, atau `exec` bebas.
* Berguna untuk *sandboxing* user-level.

**Contoh:**

```bash
ln -s /bin/bash /bin/rbash
rbash
```

Masuk ke mode terbatas untuk keamanan eksekusi.

---

### **64. Reserved Words**

**Inti:**
Kata khusus yang dikenali oleh parser Bash dan tidak dapat digunakan sebagai nama variabel atau fungsi.

**Contoh utama:**
`if`, `then`, `else`, `elif`, `fi`, `case`, `for`, `do`, `done`, `while`, `until`, `select`, `function`, `in`, `time`, `[[`, `]]`, `{`, `}`, `!`.

**Contoh:**

```bash
if true; then echo "Benar"; fi
```

`if`, `then`, `fi` adalah reserved words yang membentuk blok kondisional.

---

### **65. Quoting Rules (Advanced)**

**Inti:**
Mengontrol bagaimana karakter khusus ditafsirkan oleh shell.

**Poin penting:**

* **Single quote ('')** → literal, tidak ada ekspansi.
* **Double quote ("")** → ekspansi variabel dan command tetap terjadi.
* **Backslash (\)** → escape karakter berikutnya.

**Contoh:**

```bash
echo '$USER'   # literal
echo "$USER"   # ekspansi
```

Hasil pertama mencetak `$USER`, kedua mencetak nama pengguna sebenarnya.

---

### **66. Escaping**

**Inti:**
Mekanisme untuk menonaktifkan arti khusus dari karakter tertentu.

**Poin penting:**

* Menggunakan `\` di depan karakter.
* Penting untuk mencegah misinterpretasi oleh parser.

**Contoh:**

```bash
echo "Tanda kutip ganda: \""
```

Karakter `\"` dicetak sebagai tanda kutip ganda.

---

### **67. Command Separator**

**Inti:**
Simbol pemisah antar perintah dalam satu baris.

**Poin penting:**

* `;` → Menjalankan perintah berurutan.
* `&&` → Jalankan perintah berikutnya jika sukses.
* `||` → Jalankan perintah berikutnya jika gagal.

**Contoh:**

```bash
mkdir test && cd test || echo "Gagal masuk"
```

Jika `mkdir` berhasil, lanjut ke `cd`; jika tidak, jalankan `echo`.

---

### **68. Here Documents (<<)**

**Inti:**
Blok input multiline yang dikirim langsung ke stdin sebuah perintah.

**Poin penting:**

* Dimulai dengan `<<` diikuti delimiter.
* Isi dibaca hingga delimiter akhir.

**Contoh:**

```bash
cat <<EOF
Baris pertama
Baris kedua
EOF
```

Semua teks antara `EOF` dikirim ke `stdin` dari `cat`.

---

### **69. Here Strings (<<<)**

**Inti:**
Versi singkat dari *here document* untuk satu baris input.

**Contoh:**

```bash
grep bash <<< "shell bash script"
```

`<<<` mengirim string literal ke `stdin` perintah `grep`.

---

### **70. Shell Builtins**

**Inti:**
Perintah yang diimplementasikan langsung oleh shell (tanpa memanggil proses eksternal).

**Poin penting:**

* Lebih cepat dibandingkan binary biasa.
* Contoh: `cd`, `echo`, `set`, `export`, `type`.

**Contoh:**

```bash
type cd
```

Output: `cd is a shell builtin`.

---

### **71. Word Splitting**

**Inti:**
Tahap di mana hasil ekspansi dipecah menjadi kata berdasarkan karakter pemisah (default: spasi, tab, newline) sesuai variabel `IFS`.

**Poin penting:**

* Terjadi setelah ekspansi variabel dan sebelum globbing.
* Untuk menghindari efek samping, selalu gunakan quoting.

**Contoh:**

```bash
names="A B C"
for n in $names; do echo "$n"; done
```

Output tiga baris: A, B, C.
Jika `names="A B  C"`, spasi ganda tetap dihitung satu pemisah karena aturan splitting.

---

Dengan ini, **seluruh 71 istilah fundamental Bash Scripting telah selesai dijelaskan dengan konteks teknis dan implementatif.**

Langkah lanjutan yang disarankan untuk penguasaan penuh:

1. Menulis skrip untuk setiap konsep di atas sebagai *mini-lab*.
2. Membangun dokumentasi pribadi yang memetakan konsep ke perilaku runtime.
3. Membaca sumber resmi:

   * GNU Bash Reference Manual (FSF)
   * Advanced Bash-Scripting Guide (TLDP)

<!--
Apakah Anda ingin saya bantu buatkan *peta hubungan konsep (concept map)* dari semua 71 istilah ini agar mudah diingat dan dijadikan dasar struktur kamus Bash Anda?
-->

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../
[2]: ../
[3]: ../
[4]: ../
[5]: ../
[6]: ../
[7]: ../
[8]: ../
[9]: ../
[10]: ../
[11]: ../
[12]: ../
[13]: ../
[14]: ../
[15]: ../
[16]: ../
[17]: ../
[18]: ../
