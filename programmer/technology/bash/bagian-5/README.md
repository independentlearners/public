# Referensi Bash/POSIX Shell — Edisi Revisi Lengkap

Dokumen ini adalah penulisan ulang menyeluruh dari materi sebelumnya. Tujuannya bukan sekadar menerjemahkan ulang 71 nomor, tetapi menyusun ulang menjadi referensi yang:

- **tidak duplikatif**;
- **konsisten kedalamannya**;
- **menandai POSIX vs Bash-specific**;
- **memperbaiki kesalahan teknis**;
- **melengkapi konsep yang hilang**;
- **memberi penjelasan token per token** pada contoh-contoh kunci.

Konteks utama: **shell POSIX `/bin/sh`** dan **GNU Bash**. Bash adalah implementasi Bourne-Again SHell yang umum ditulis dalam C. Shell lain seperti `dash`, `zsh`, `ksh`, dan `fish` dapat berbeda. Setiap fitur yang tidak POSIX akan ditandai.

---

## Daftar Isi

1. Model Eksekusi Shell
2. Tokenization, Parsing, dan Evaluation Order
3. Quoting, Escaping, dan IFS
4. Ekspansi
5. Globbing dan Pathname Expansion
6. Redirection dan File Descriptor
7. Pipeline, Subshell, dan Command Grouping
8. Variabel, Parameter, dan Array
9. Fungsi Shell
10. Kontrol Alur
11. Job Control, Signal, dan Trap
12. Exit Status, `pipefail`, dan `PIPESTATUS`
13. Shell Options, Builtins, PATH, dan Hashing
14. Alias, History, dan Prompt
15. Startup Files, Mode Shell, dan Restricted Shell
16. Model Keamanan Shell
17. Debugging dan Tracing
18. Tabel Portabilitas POSIX vs Bash
19. Peta Istilah 1–71 ke Bagian Revisi

---

## 1. Model Eksekusi Shell

Shell adalah program yang membaca baris perintah, memecahnya menjadi token, melakukan ekspansi, lalu mengeksekusi perintah. Ada dua kategori perintah:

- **Builtin**: dijalankan di dalam proses shell. Contoh: `cd`, `echo`, `read`, `export`, `set`, `trap`.
- **External command**: program terpisah di filesystem. Shell melakukan `fork` lalu `exec`.

### 1.1 POSIX

**Inti:** Standar interoperabilitas untuk shell dan utilitas Unix. POSIX mendefinisikan perilaku minimum `sh`, `test`, `echo`, `printf`, `awk`, dan sebagainya.

**Poin penting:**

- Skrip yang ingin portabel harus memakai `#!/bin/sh` dan menghindari fitur Bash-specific.
- POSIX tidak menjamin `[[ ]]`, `<<<`, `$'...'`, array, `local`, `declare -A`, `pipefail`, `&>`, `set -o pipefail`, dan process substitution.

**Contoh POSIX:**

```sh
#!/bin/sh
if [ -f "$1" ]; then
  printf '%s\n' "File ada: $1"
else
  printf '%s\n' "File tidak ditemukan"
fi
```

**Penjelasan token:**

- `#!/bin/sh` — shebang; menunjuk interpreter POSIX `sh`.
- `if` — reserved word memulai percabangan.
- `[` — perintah `test`; di POSIX `[` adalah nama lain `test`.
- `-f` — operator test: benar jika argumen berikut adalah file reguler yang ada.
- `"$1"` — parameter positional pertama; di-quote untuk mencegah word splitting dan pathname expansion.
- `]` — penutup `test`; wajib ada spasi sebelum `]`.
- `then` — pembuka blok kondisi benar.
- `printf '%s\n' "File ada: $1"` — `printf` lebih portabel daripada `echo` untuk format.
- `else` — blok alternatif.
- `fi` — penutup `if`.

### 1.2 Bash

Bash menambah banyak fitur: array, associative array, `[[ ]]`, `(( ))`, `<<<`, process substitution, `shopt`, `local`, `mapfile`, `pipefail`, dan lain-lain.

**Contoh Bash:**

```bash
#!/usr/bin/env bash
set -euo pipefail
files=( "$HOME"/*.txt )
if (( ${#files[@]} > 0 )); then
  printf '%s\n' "${files[@]}"
fi
```

**Penjelasan token:**

- `#!/usr/bin/env bash` — shebang portabel untuk mencari `bash` di `PATH`.
- `set -euo pipefail` — aktifkan `errexit`, `nounset`, `pipefail`.
- `files=( "$HOME"/*.txt )` — array assignment; `"$HOME"` di-quote, `/*.txt` tetap glob.
- `(( ${#files[@]} > 0 ))` — arithmetic command Bash; `${#files[@]}` jumlah elemen array.
- `printf '%s\n' "${files[@]}"` — cetak setiap elemen array sebagai argumen terpisah.

---

## 2. Tokenization, Parsing, dan Evaluation Order

### 2.1 Tokenization

**Inti:** Memecah input menjadi token: kata, operator, reserved word, redirection, dan sebagainya.

**Poin penting:**

- Quoting dan escaping memengaruhi batas token.
- `"satu dua"` adalah satu token; `satu dua` adalah dua token.
- Operator seperti `|`, `&&`, `;`, `>`, `>>`, `<` adalah token tersendiri.

**Contoh:**

```bash
echo "satu dua" tiga
```

Token:

1. `echo`
2. `"satu dua"` — satu token karena quote.
3. `tiga`

### 2.2 Parsing

**Inti:** Mengubah token menjadi struktur perintah: pipeline, list, compound command, redirection.

**Poin penting:**

- Reserved word seperti `if`, `then`, `fi`, `for`, `do`, `done`, `case`, `esac` dikenali di tahap parsing.
- Kesalahan parsing menghasilkan syntax error sebelum eksekusi.

**Contoh:**

```bash
if [ -f "$1" ]; then echo ok; fi
```

**Penjelasan token:**

- `if` — reserved word.
- `[` — perintah test.
- `-f` — operator file test.
- `"$1"` — parameter positional pertama.
- `]` — penutup test.
- `then` — reserved word.
- `echo` — builtin.
- `ok` — argumen.
- `;` — pemisah perintah.
- `fi` — penutup `if`.

### 2.3 Evaluation Order / Expansion Order

Urutan ekspansi Bash yang benar:

1. **Brace expansion** — `{a,b}`, `{1..5}`.
2. **Tilde expansion** — `~`, `~user`.
3. **Parameter expansion** — `$var`, `${var}`.
4. **Command substitution** — `$(cmd)`, `` `cmd` ``.
5. **Arithmetic expansion** — `$((...))`.
6. **Word splitting** — berdasarkan `IFS`.
7. **Pathname expansion / globbing** — `*`, `?`, `[ ]`.
8. **Quote removal** — menghapus quote yang tersisa.

**Catatan penting:**

- Process substitution `<(cmd)` dan `>(cmd)` bukan bagian urutan ekspansi biasa; ia membuat file descriptor.
- Di dalam assignment seperti `x=$HOME/*.txt`, **pathname expansion tidak terjadi**. Yang terjadi hanya tilde dan parameter expansion. Pathname expansion baru terjadi saat nilai dipakai tanpa quote.

**Contoh:**

```bash
x=$HOME/*.txt
printf '%s\n' "$x"
```

`x` berisi literal `/home/user/*.txt`, bukan daftar file.

```bash
for f in $x; do
  printf '%s\n' "$f"
done
```

Di sini `$x` diekspansi, word splitting terjadi, lalu pathname expansion pada tiap kata.

---

## 3. Quoting, Escaping, dan IFS

### 3.1 Quoting

**Inti:** Mengontrol ekspansi dan word splitting.

**Jenis:**

- Single quote `'...'` — literal persis. Tidak ada ekspansi.
- Double quote `"..."` — parameter expansion, command substitution, arithmetic expansion tetap terjadi; word splitting dan pathname expansion dicegah.
- ANSI-C quoting `$'...'` — Bash-specific; mendukung `\n`, `\t`, `\xHH`.

**Contoh:**

```bash
name="John Doe"
printf '%s\n' "$name"
printf '%s\n' $name
printf '%s\n' '$HOME'
```

**Penjelasan token:**

- `name="John Doe"` — assignment; nilai berisi spasi.
- `"$name"` — satu argumen.
- `$name` — diekspansi lalu word splitting; bisa menjadi dua argumen.
- `'$HOME'` — literal `$HOME`.

### 3.2 Escaping

**Inti:** Backslash `\` menetralkan arti khusus karakter berikutnya.

**Contoh:**

```bash
touch file\ name.txt
printf '%s\n' "Path is \$HOME"
```

**Penjelasan token:**

- `file\ name.txt` — spasi di-escape; satu nama file.
- `\$HOME` — di dalam double quote, backslash mencegah ekspansi `$HOME`.

### 3.3 IFS / Field Splitting

**Inti:** `IFS` menentukan karakter pemisah field saat word splitting dan `read`.

**Default:** spasi, tab, newline.

**Contoh POSIX:**

```sh
line="a,b,c"
IFS=',' read -r a b c <<< "$line"
```

**Catatan:** `<<<` adalah Bash-specific. Versi POSIX:

```sh
printf '%s\n' "$line" | IFS=',' read -r a b c
```

Namun pipeline membuat subshell, sehingga variabel `a b c` tidak bertahan di shell utama. Solusi POSIX lain:

```sh
oldIFS=$IFS
IFS=','
set -- $line
IFS=$oldIFS
a=$1; b=$2; c=$3
```

**Penjelasan token contoh Bash:**

- `line="a,b,c"` — assignment.
- `IFS=','` — assignment sementara untuk perintah `read`.
- `read` — builtin membaca input.
- `-r` — menonaktifkan interpretasi backslash.
- `a b c` — variabel target.
- `<<<` — here-string Bash.
- `"$line"` — string yang dikirim.

---

## 4. Ekspansi

### 4.1 Brace Expansion

**Inti:** Menghasilkan kombinasi string literal. Tidak memeriksa filesystem.

**Contoh:**

```bash
mkdir -p build/{debug,release}
printf '%s\n' file{1,2,3}.txt
```

**Penjelasan token:**

- `mkdir` — buat direktori.
- `-p` — buat parent bila perlu, jangan error jika sudah ada.
- `build/{debug,release}` — brace expansion menjadi `build/debug` dan `build/release`.
- `file{1,2,3}.txt` — menjadi `file1.txt file2.txt file3.txt`.

**Bash-specific:** brace expansion tidak POSIX.

### 4.2 Tilde Expansion

**Inti:** `~` di awal kata menjadi home direktori; `~user` menjadi home user tertentu.

**Contoh:**

```bash
cd ~
printf '%s\n' ~root
touch ~/file.txt
```

**Penjelasan token:**

- `cd ~` — `~` menjadi `/home/user`.
- `~root` — menjadi home `root`, biasanya `/root`.
- `~/file.txt` — home + `/file.txt`.

**POSIX:** tilde expansion didukung.

### 4.3 Parameter Expansion

**Inti:** Ekspansi variabel plus operator modifikasi.

**Operator penting:**

- `${var:-default}` — default jika kosong/unset.
- `${var:=default}` — set default jika kosong/unset.
- `${var:+alt}` — gunakan `alt` jika var di-set.
- `${var:?error}` — error jika kosong/unset.
- `${var#pattern}` — hapus prefix terpendek.
- `${var##pattern}` — hapus prefix terpanjang.
- `${var%pattern}` — hapus suffix terpendek.
- `${var%%pattern}` — hapus suffix terpanjang.
- `${var/pat/repl}` — substitusi pertama (Bash).
- `${var//pat/repl}` — substitusi semua (Bash).
- `${!prefix*}` — daftar variabel dengan prefix (Bash).
- `${var:offset:length}` — substring (Bash).

**Contoh:**

```bash
file=${1:-/tmp/default.txt}
base=${file%.*}
dir=${file##*/}
printf '%s\n' "file=$file base=$base dir=$dir"
```

**Penjelasan token:**

- `${1:-/tmp/default.txt}` — jika `$1` kosong/unset, pakai default.
- `file=...` — assignment.
- `${file%.*}` — hapus suffix terpendek `.*`; menghilangkan ekstensi.
- `${file##*/}` — hapus prefix terpanjang sampai `/`; mengambil basename.
- `printf` — cetak.

### 4.4 Command Substitution

**Inti:** Menjalankan perintah dan menggantinya dengan output.

**Sintaks POSIX:** `$(cmd)` atau `` `cmd` ``.

**Contoh:**

```bash
now=$(date +%Y%m%d_%H%M%S)
backup="/var/backups/backup_${now}.tar.gz"
printf '%s\n' "Membuat backup: $backup"
```

**Penjelasan token:**

- `$(date +%Y%m%d_%H%M%S)` — jalankan `date`, ambil output.
- `now=...` — assignment.
- `"${now}"` — interpolasi variabel.
- `"..."` — menjaga path sebagai satu string.

**Catatan:** Output command substitution tunduk pada word splitting dan globbing jika tidak di-quote.

### 4.5 Arithmetic Expansion

**Inti:** Evaluasi integer.

**Sintaks POSIX:** `$((...))`.

**Contoh:**

```bash
count=5
count=$((count + 1))
limit=$((2**10))
printf '%s\n' "count=$count limit=$limit"
```

**Penjelasan token:**

- `count=5` — assignment.
- `$((count + 1))` — arithmetic expansion.
- `2**10` — pangkat; Bash dan POSIX? `**` didukung di beberapa shell; POSIX tidak mewajibkan `**`.
- `printf` — cetak.

### 4.6 Process Substitution

**Inti:** Bash-specific. Menyediakan file-like object `<(cmd)` atau `>(cmd)`.

**Contoh:**

```bash
diff <(sort fileA.txt) <(sort fileB.txt)
```

**Penjelasan token:**

- `diff` — bandingkan dua file.
- `<(sort fileA.txt)` — jalankan `sort`, buat `/dev/fd/...`.
- `<(sort fileB.txt)` — sama untuk fileB.

**POSIX:** tidak ada process substitution.

### 4.7 Word Splitting

**Inti:** Memecah hasil ekspansi berdasarkan `IFS`.

**Poin penting:**

- Terjadi setelah parameter/command/arithmetic expansion.
- Tidak terjadi di dalam double quote.
- Pathname expansion terjadi setelah word splitting.

**Contoh salah vs benar:**

```bash
# Salah: pola disimpan literal, lalu dipakai tanpa quote
files=$HOME/*.txt
for f in $files; do
  printf '%s\n' "$f"
done

# Benar: array dan quote
shopt -s nullglob
files=( "$HOME"/*.txt )
for f in "${files[@]}"; do
  printf '%s\n' "$f"
done
```

**Penjelasan:**

- `files=$HOME/*.txt` — assignment; `*` tidak diekspansi di sini.
- `for f in $files` — `$files` diekspansi, word splitting, lalu pathname expansion.
- `files=( "$HOME"/*.txt )` — array; setiap file menjadi elemen terpisah.
- `"${files[@]}"` — setiap elemen menjadi argumen terpisah.

### 4.8 Pathname Expansion / Globbing

**Inti:** Shell mencocokkan pola dengan nama file.

**Pola dasar:**

- `*` — nol atau lebih karakter.
- `?` — satu karakter.
- `[abc]` — salah satu karakter.
- `[!abc]` — bukan salah satu.

**Opsi Bash:**

- `nullglob` — pola tanpa hasil menjadi kosong.
- `failglob` — pola tanpa hasil menyebabkan error.
- `dotglob` — `*` mencakup file tersembunyi.
- `globstar` — `**` rekursif.
- `extglob` — pola tambahan seperti `?(pattern)`, `*(pattern)`, `+(pattern)`, `@(pattern)`, `!(pattern)`.
- `nocaseglob` — tidak case-sensitive.

**Contoh:**

```bash
shopt -s nullglob
files=( /etc/*.conf )
if (( ${#files[@]} > 0 )); then
  printf '%s\n' "${files[@]}"
fi
```

**Penjelasan token:**

- `shopt -s nullglob` — aktifkan nullglob.
- `files=( /etc/*.conf )` — array hasil glob.
- `(( ${#files[@]} > 0 ))` — cek jumlah elemen.
- `printf '%s\n' "${files[@]}"` — cetak.

---

## 5. Redirection dan File Descriptor

### 5.1 File Descriptor

**Inti:** Integer yang mewakili stream I/O.

- `0` — stdin.
- `1` — stdout.
- `2` — stderr.
- `3–n` — descriptor tambahan.

**Contoh:**

```bash
cmd >out.log 2>&1
```

**Penjelasan token:**

- `cmd` — perintah.
- `>out.log` — stdout ke file.
- `2>&1` — stderr duplikat ke stdout saat ini.

Urutan penting: `2>&1 >out.log` berbeda; stderr akan tetap ke terminal.

### 5.2 Redirection

**Operator:**

- `>` — overwrite.
- `>>` — append.
- `<` — input.
- `2>` — stderr.
- `&>` — stdout dan stderr (Bash).
- `n>&m` — duplikasi.
- `n<&m` — duplikasi input.
- `exec 3>file` — buka FD 3.
- `exec 3>&-` — tutup FD 3.

**Contoh:**

```bash
exec 3< config.txt
read -u 3 line
exec 3<&-
```

**Penjelasan token:**

- `exec` — builtin; memanipulasi FD shell.
- `3< config.txt` — buka config.txt untuk baca di FD 3.
- `read -u 3 line` — baca dari FD 3.
- `exec 3<&-` — tutup FD 3.

**POSIX:** `read -u` Bash-specific.

### 5.3 Here-Document

**Inti:** Input multiline ke stdin.

**Contoh:**

```bash
cat <<'EOF'
Literal $HOME dan $(date) tidak diekspansi
EOF
```

**Penjelasan token:**

- `cat` — baca stdin, tulis stdout.
- `<<'EOF'` — here-doc; delimiter dikutip → tidak ada ekspansi.
- `EOF` — penutup harus di awal baris.

### 5.4 Here-String

**Inti:** Bash-specific. `<<< "string"`.

**Contoh:**

```bash
grep '^user' <<< "$passwd_line"
```

**Penjelasan token:**

- `grep '^user'` — cari pola.
- `<<<` — kirim string sebagai stdin.
- `"$passwd_line"` — di-quote.

---

## 6. Pipeline, Subshell, dan Command Grouping

### 6.1 Pipeline

**Inti:** `|` menghubungkan stdout kiri ke stdin kanan.

**Contoh:**

```bash
ps aux | grep '[s]shd' | awk '{print $2}'
```

**Penjelasan token:**

- `ps aux` — daftar proses.
- `|` — pipe.
- `grep '[s]shd'` — cari `sshd`; trik `[s]` mencegah grep muncul.
- `awk '{print $2}'` — cetak kolom kedua.

**Exit status pipeline:** default status perintah terakhir. Dengan `set -o pipefail`, non-zero jika ada yang gagal.

### 6.2 Subshell

**Inti:** `( ... )` menjalankan di proses anak.

**Contoh:**

```bash
( cd /tmp && ls ) && pwd
```

**Penjelasan token:**

- `(` `)` — subshell.
- `cd /tmp` — hanya di subshell.
- `&&` — logika AND.
- `ls` — daftar.
- `pwd` — di parent.

### 6.3 Command Grouping

**Inti:** `{ ...; }` di shell saat ini.

**Contoh:**

```bash
{ cd /tmp; printf '%s\n' "now $(pwd)"; } > /dev/null
```

**Penjelasan token:**

- `{` `}` — grouping.
- `cd /tmp;` — ubah direktori shell saat ini.
- `printf` — cetak.
- `> /dev/null` — redirect seluruh grup.

**Sintaks:** butuh spasi setelah `{` dan `;` sebelum `}`.

---

## 7. Variabel, Parameter, dan Array

### 7.1 Environment Variables

**Inti:** Variabel yang diwariskan ke proses anak.

**Contoh:**

```bash
export PATH="$PATH:/opt/bin"
printf '%s\n' "$PATH"
```

**Penjelasan token:**

- `export` — tandai variabel untuk lingkungan.
- `PATH="$PATH:/opt/bin"` — assignment.
- `printf` — cetak.

### 7.2 Local Variables

**Inti:** Bash-specific `local` di dalam fungsi.

**Contoh:**

```bash
myfunc() {
  local var="lokal"
  printf '%s\n' "$var"
}
myfunc
printf '%s\n' "${var:-kosong}"
```

**Penjelasan token:**

- `myfunc()` — definisi fungsi.
- `local var="lokal"` — variabel lokal.
- `${var:-kosong}` — default jika unset.

### 7.3 Positional Parameters

- `$0` — nama skrip.
- `$1`, `$2`, ... — argumen.
- `$#` — jumlah argumen.
- `"$@"` — semua argumen sebagai argumen terpisah.
- `"$*"` — semua argumen sebagai satu string.

**Contoh:**

```bash
printf 'Skrip: %s\n' "$0"
printf 'Arg1: %s\n' "$1"
printf 'Jumlah: %d\n' "$#"
```

### 7.4 Special Parameters

- `$?` — exit status terakhir.
- `$$` — PID shell.
- `$!` — PID background terakhir.
- `$-` — opsi shell.

**Contoh:**

```bash
sleep 100 &
printf 'PID: %s\n' "$!"
```

### 7.5 Indexed Arrays

**Bash-specific.**

```bash
fruits=("apel" "pisang" "mangga")
printf '%s\n' "${fruits[1]}"
printf '%s\n' "${fruits[@]}"
printf '%s\n' "${#fruits[@]}"
```

**Penjelasan token:**

- `fruits=(...)` — array.
- `${fruits[1]}` — elemen indeks 1.
- `${fruits[@]}` — semua elemen.
- `${#fruits[@]}` — jumlah elemen.

### 7.6 Associative Arrays

**Bash 4+.**

```bash
declare -A user
user[name]="Cendekiawan"
user[role]="Pelajar IT"
printf '%s - %s\n' "${user[name]}" "${user[role]}"
```

**Penjelasan token:**

- `declare -A user` — associative array.
- `user[key]=value` — assignment.
- `${user[key]}` — akses.

### 7.7 `readonly`, `declare -i`, Nameref

```bash
readonly PI=3.14
declare -i n=5
declare -n ref=PI
printf '%s\n' "$ref"
```

**Penjelasan token:**

- `readonly` — tidak bisa diubah.
- `declare -i` — integer.
- `declare -n` — nameref Bash.

---

## 8. Fungsi Shell

**Inti:** Blok perintah bernama.

**Contoh:**

```bash
greet() {
  local name="$1"
  printf 'Halo, %s!\n' "$name"
  return 0
}
greet "Cendekiawan"
```

**Penjelasan token:**

- `greet()` — definisi fungsi.
- `local name="$1"` — variabel lokal.
- `printf` — cetak.
- `return 0` — status keluar fungsi.
- `greet "Cendekiawan"` — panggil fungsi.

**POSIX:** `local` tidak POSIX. Gunakan variabel biasa atau subshell.

---

## 9. Kontrol Alur

### 9.1 `if`

```bash
if [ -f "$1" ]; then
  printf '%s\n' "ada"
elif [ -d "$1" ]; then
  printf '%s\n' "direktori"
else
  printf '%s\n' "tidak ada"
fi
```

### 9.2 `case`

```bash
case "$1" in
  start) printf '%s\n' "mulai" ;;
  stop)  printf '%s\n' "berhenti" ;;
  *)     printf '%s\n' "tidak dikenal" ;;
esac
```

### 9.3 `for`

```bash
for f in *.txt; do
  printf '%s\n' "$f"
done
```

### 9.4 `while` dan `until`

```bash
i=0
while (( i < 3 )); do
  printf '%s\n' "$i"
  ((i++))
done

until (( i == 0 )); do
  ((i--))
done
```

### 9.5 `select`

**Bash-specific.**

```bash
select opt in "satu" "dua" "keluar"; do
  case "$opt" in
    keluar) break ;;
    *) printf 'Pilih: %s\n' "$opt" ;;
  esac
done
```

### 9.6 `[[ ]]` dan `(( ))`

**Bash-specific.**

```bash
if [[ $name == *.txt && -f $name ]]; then
  printf '%s\n' "file txt"
fi

if (( count > 5 )); then
  printf '%s\n' "besar"
fi
```

**POSIX:** gunakan `[ ]` dan `test`.

### 9.7 `getopts`

**POSIX.**

```sh
while getopts "ab:c" opt; do
  case "$opt" in
    a) printf '%s\n' "opsi a" ;;
    b) printf 'arg b: %s\n' "$OPTARG" ;;
    c) printf '%s\n' "opsi c" ;;
    *) exit 1 ;;
  esac
done
```

---

## 10. Job Control, Signal, dan Trap

### 10.1 Job Control

**Contoh:**

```bash
sleep 300 &
printf 'PID: %s\n' "$!"
jobs
fg %1
```

**Penjelasan token:**

- `sleep 300 &` — background.
- `$!` — PID background terakhir.
- `jobs` — daftar job.
- `fg %1` — foreground job 1.

### 10.2 Signals

**Contoh:**

```bash
sleep 100 &
kill -INT "$!"
```

**Penjelasan token:**

- `kill -INT` — kirim SIGINT.
- `"$!"` — PID background.

Daftar sinyal: `kill -l`.

### 10.3 Trap

**Contoh:**

```bash
trap 'printf "Dihentikan!\n"; exit 1' INT TERM
trap 'printf "Selesai.\n"' EXIT
while true; do sleep 1; done
```

**Penjelasan token:**

- `trap '...' INT TERM` — handler untuk SIGINT dan SIGTERM.
- `trap '...' EXIT` — dijalankan saat shell keluar.
- `while true` — loop.

**POSIX:** `trap '...' INT TERM` lebih portabel daripada `SIGINT`.

---

## 11. Exit Status, `pipefail`, dan `PIPESTATUS`

### 11.1 Exit Status

- `0` — sukses.
- `1–255` — error.
- `$?` — status terakhir.

**Contoh:**

```bash
grep root /etc/passwd
printf 'status: %d\n' "$?"
```

### 11.2 `pipefail`

**Bash-specific.**

```bash
set -o pipefail
false | true
printf 'status: %d\n' "$?"
```

Dengan `pipefail`, status pipeline non-zero karena `false`.

### 11.3 `PIPESTATUS`

**Bash-specific.**

```bash
false | true | false
printf '%s\n' "${PIPESTATUS[@]}"
```

Menampilkan status setiap komponen pipeline.

---

## 12. Shell Options, Builtins, PATH, dan Hashing

### 12.1 `set`

- `set -e` — errexit.
- `set -u` — nounset.
- `set -x` — tracing.
- `set -o pipefail` — pipefail.
- `set -C` / `set -o noclobber` — cegah overwrite.

**Contoh:**

```bash
set -euo pipefail
```

### 12.2 `shopt`

**Bash-specific.**

```bash
shopt -s nullglob globstar extglob
shopt -u nullglob
shopt -p
```

### 12.3 Builtins vs External

```bash
type cd
type ls
command -v bash
```

- `type` — Bash builtin.
- `command -v` — POSIX.
- `which` — external, tidak portabel.

### 12.4 PATH Lookup

```bash
printf '%s\n' "$PATH"
```

Shell mencari executable di direktori `PATH`.

### 12.5 Command Hashing

```bash
hash
hash -r
```

`hash` menampilkan cache; `hash -r` mereset.

---

## 13. Alias, History, dan Prompt

### 13.1 Alias

```bash
alias ll='ls -la'
ll /tmp
```

Alias hanya substitusi teks. Di skrip, lebih baik fungsi.

### 13.2 History Expansion

**Interaktif.**

```bash
echo hello
!!
```

`!!` mengulang perintah terakhir.

### 13.3 Prompt

- `PS1` — prompt utama.
- `PS2` — prompt lanjutan.
- `PS4` — prefix tracing.

```bash
PS4='+ $BASH_SOURCE:$LINENO: '
set -x
ls /tmp
set +x
```

### 13.4 `PROMPT_COMMAND`

**Bash-specific.**

```bash
PROMPT_COMMAND='printf "["; date +%H:%M; printf "]\n"'
```

---

## 14. Startup Files, Mode Shell, dan Restricted Shell

### 14.1 Login vs Non-Login

- Login shell: `/etc/profile`, `~/.bash_profile`, `~/.bash_login`, `~/.profile`.
- Non-login interaktif: `~/.bashrc`.
- Non-interaktif: `BASH_ENV` jika diset.

### 14.2 Interactive vs Non-Interactive

```bash
bash -c 'printf "non-interaktif\n"'
bash --login
```

### 14.3 Restricted Shell

**Bash-specific `rbash`.**

```bash
ln -s /bin/bash /bin/rbash
rbash
```

Membatasi `cd`, PATH, dan perintah dengan `/`.

---

## 15. Model Keamanan Shell

**Poin penting:**

- Selalu quote variabel: `"$var"`.
- Jangan `eval` input pengguna.
- Waspadai `PATH`, `IFS`, `BASH_ENV`, `ENV`.
- Gunakan `set -u` untuk mendeteksi variabel kosong.
- Gunakan `set -e` dengan hati-hati; banyak pengecualian.
- Gunakan `--` untuk mengakhiri opsi: `rm -- "$file"`.
- Validasi input sebelum digunakan.
- Jangan gunakan `which`; gunakan `command -v`.
- Untuk file sementara, gunakan `mktemp`.
- Set `umask` yang aman.

**Contoh:**

```bash
umask 077
tmp=$(mktemp) || exit 1
trap 'rm -f "$tmp"' EXIT
```

---

## 16. Debugging dan Tracing

- `set -x` — trace perintah.
- `set +x` — matikan.
- `PS4` — format trace.
- `bash -n script.sh` — cek sintaks.
- `bash -v script.sh` — verbose.
- `trap '...' DEBUG` — Bash-specific.
- `trap '...' ERR` — Bash-specific.

**Contoh:**

```bash
PS4='+ ${BASH_SOURCE}:${LINENO}: '
set -x
printf '%s\n' "debug"
set +x
```

---

## 17. Tabel Portabilitas POSIX vs Bash

| Fitur | POSIX `sh` | Bash |
|---|---|---|
| `$(cmd)` | Ya | Ya |
| `` `cmd` `` | Ya | Ya |
| `$((...))` | Ya | Ya |
| `[[ ]]` | Tidak | Ya |
| `(( ))` | Tidak | Ya |
| `<<<` | Tidak | Ya |
| `$'...'` | Tidak | Ya |
| Array | Tidak | Ya |
| Associative array | Tidak | Bash 4+ |
| `local` | Tidak | Ya |
| `declare` | Tidak | Ya |
| Process substitution | Tidak | Ya |
| `pipefail` | Tidak | Ya |
| `PIPESTATUS` | Tidak | Ya |
| `&>` | Tidak | Ya |
| `set -o pipefail` | Tidak | Ya |
| `shopt` | Tidak | Ya |
| `mapfile`/`readarray` | Tidak | Bash 4+ |
| `read -u` | Tidak | Ya |
| `read -p` | Tidak | Ya |
| `read -t` | Tidak | Ya |
| `select` | Tidak | Ya |
| `function` keyword | Tidak | Ya |
| `**` arithmetic | Tidak | Ya |
| `globstar` | Tidak | Bash 4+ |
| `extglob` | Tidak | Ya |

---

## 18. Peta Istilah 1–71 ke Bagian Revisi

| Nomor Lama | Istilah Lama | Bagian Baru |
|---|---|---|
| 1 | POSIX | 1.1 |
| 2 | Globbing | 4.8 |
| 3 | Brace expansion | 4.1 |
| 4 | Pathname expansion | 4.8 |
| 5 | Tilde expansion | 4.2 |
| 6 | Parameter expansion | 4.3 |
| 7 | Command substitution | 4.4 |
| 8 | Arithmetic expansion | 4.5 |
| 9 | Process substitution | 4.6 |
| 10 | Word splitting | 4.7, 3.3 |
| 11 | Field splitting (IFS) | 3.3 |
| 12 | Quoting | 3.1 |
| 13 | Escaping | 3.2 |
| 14 | Here-document | 5.3 |
| 15 | Here-string | 5.4 |
| 16 | Subshell | 6.2 |
| 17 | Command grouping | 6.3 |
| 18 | Pipelines | 6.1 |
| 19 | Job control | 10.1 |
| 20 | File descriptors | 5.1 |
| 21 | Redirection | 5.2 |
| 22 | Descriptor duplication | 5.2 |
| 23 | Standard streams | 5.1 |
| 24 | Exit status | 11.1 |
| 25 | Signals | 10.2 |
| 26 | Trap | 10.3 |
| 27 | Environment variables | 7.1 |
| 28 | Local variables | 7.2 |
| 29 | Exporting variables | 7.1 |
| 30 | Shell functions | 8 |
| 31 | Indexed arrays | 7.5 |
| 32 | Associative arrays | 7.6 |
| 33 | Variable substitution modifiers | 4.3 |
| 34 | Positional parameters | 7.3 |
| 35 | Special parameters | 7.4 |
| 36 | Shell options | 12.1, 12.2 |
| 37 | Restricted shell | 14.3 |
| 38 | Login vs non-login | 14.1 |
| 39 | Interactive vs non-interactive | 14.2 |
| 40 | Tokenization | 2.1 |
| 41 | Parsing | 2.2 |
| 42 | Evaluation order | 2.3 |
| 43 | Command hashing | 12.5 |
| 44 | PATH lookup | 12.4 |
| 45 | Aliases | 13.1 |
| 46 | History expansion | 13.2 |
| 47 | Prompting | 13.3 |
| 48 | Builtins vs external | 12.3 |
| 49 | pipefail | 11.2 |
| 50 | PID dan job ID | 10.1, 7.4 |
| 51 | Command substitution | 4.4 |
| 52 | Arithmetic expansion | 4.5 |
| 53 | Process substitution | 4.6 |
| 54 | Command grouping | 6.3 |
| 55 | Environment variables | 7.1 |
| 56 | PATH lookup | 12.4 |
| 57 | Command hashing | 12.5 |
| 58 | Job control | 10.1 |
| 59 | Signals | 10.2 |
| 60 | Trap | 10.3 |
| 61 | Shell security model | 15 |
| 62 | Shell startup files | 14.1 |
| 63 | Restricted mode | 14.3 |
| 64 | Reserved words | 2.2 |
| 65 | Quoting rules advanced | 3.1 |
| 66 | Escaping | 3.2 |
| 67 | Command separator | 6.1, 6.3 |
| 68 | Here documents | 5.3 |
| 69 | Here strings | 5.4 |
| 70 | Shell builtins | 12.3 |
| 71 | Word splitting | 4.7, 3.3 |

---

## 19. Konsep Tambahan yang Wajib Dikuasai

- `case`, `while`, `until`, `select`.
- `[[ ]]`, `(( ))`.
- `getopts`.
- `read` lengkap: `-p`, `-t`, `-n`, `-a`, `-u`, `-r`.
- `mapfile` / `readarray`.
- `PIPESTATUS`.
- `$@` vs `$*` dan quoting.
- `IFS` non-whitespace.
- `BASH_ENV`, `PROMPT_COMMAND`.
- `trap ERR EXIT DEBUG RETURN`.
- `set -u`, `set -C`, `noclobber`.
- `eval`, `command`, `builtin`, `exec`.
- `umask`, `ulimit`, `readonly`, `declare -i`, `nameref`.
- `globstar`, `extglob`, `dotglob`, `nocaseglob`, `failglob`.
- Versi minimum Bash untuk fitur tertentu.

---

## Penutup

Dokumen ini menyatukan ulang materi awal, menghapus duplikasi, memperbaiki urutan ekspansi, menandai POSIX vs Bash, dan menambahkan konsep yang hilang. Untuk penguasaan penuh:

1. Tulis mini-lab untuk setiap bagian.
2. Uji di `sh` dan `bash`.
3. Baca GNU Bash Reference Manual dan POSIX Shell Command Language.
4. Gunakan `shellcheck` untuk audit skrip.
5. Biasakan `set -euo pipefail` pada skrip Bash, dengan pemahaman pengecualiannya.

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
