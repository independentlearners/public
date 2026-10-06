# Level 2 – Blok Bangunan  
## Materi 1: Variabel & Ekspansi Parameter (Mendalam)

> **Catatan:** Ini adalah **materi pertama** dari Level 2. Di Level 1 kita sudah menyinggung variabel secara singkat. Sekarang kita akan membedahnya **sampai ke level byte**, termasuk semua bentuk ekspansi parameter POSIX, perbedaan `$var` vs `${var}` vs `"$var"` vs `"${var}"`, operator default, dan jebakan yang sering memakan korban.

---

## 🎯 Tujuan Materi 1

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Menjelaskan perbedaan **shell variable** dan **environment variable** secara mendalam.
2. Menguasai **seluruh bentuk ekspansi parameter** yang didefinisikan POSIX.
3. Memahami kapan harus menggunakan `${var}` dan kapan cukup `$var`.
4. Menggunakan operator default (`:-`, `:=`, `:?`, `:+`) dengan benar.
5. Memanipulasi string dengan `${var#pattern}`, `${var%pattern}`, `${var/old/new}`.
6. Memahami variabel spesial (`$?`, `$$`, `$!`, `$#`, `$@`, `$*`, `$0`–`$9`).
7. Menghindari **word splitting** dan **globbing** yang tidak diinginkan.
8. Menulis skrip yang aman dari **variable injection** dan **unset variable trap**.

---

## 2.1.1 Apa Itu Variabel?

**Variabel** adalah nama yang mewakili sebuah nilai. Dalam shell, variabel tidak memiliki tipe data. Semuanya adalah **string**. Bahkan angka pun disimpan sebagai string, dan operasi aritmatika dilakukan dengan konversi implisit.

**Sintaks assignment:**

```sh
nama=nilai
```

Aturan ketat:

1. **Tidak boleh ada spasi** di sekitar `=`. Ini adalah kesalahan paling umum bagi pemula.
   - ✅ `nama="Budi"` 
   - ❌ `nama = "Budi"` — shell menganggap `nama` sebagai perintah.
   - ❌ `nama ="Budi"` — shell menganggap `nama` sebagai perintah dengan argumen `=Budi`.

2. **Nama variabel** harus diawali huruf atau underscore (`_`), dan hanya boleh berisi huruf, angka, dan underscore.
   - ✅ `nama`, `_tmp`, `VAR1`, `myVar`
   - ❌ `1var` (diawali angka), `my-var` (mengandung minus), `my.var` (mengandung titik)

3. **Nilai** boleh mengandung apa saja, termasuk spasi, tetapi harus dikutip.
   - ✅ `nama="Budi Santoso"`
   - ❌ `nama=Budi Santoso` — `Santoso` dianggap sebagai perintah terpisah.

---

## 2.1.2 Membaca Variabel: `$var` vs `${var}` vs `"$var"` vs `"${var}"`

Ini adalah salah satu topik paling penting dalam shell scripting. Mari kita bedah satu per satu.

### `$var` — Ekspansi Sederhana

```sh
nama="Budi"
echo $nama
```

Penjelasan:

- `$nama` – Shell mengganti `$nama` dengan nilai variabel, yaitu `Budi`.
- Ekspansi parameter terjadi sebelum word splitting dan globbing.
- Bahaya: jika nilai mengandung spasi, akan terjadi **word splitting**.

Contoh bahaya:

```sh
nama="Budi Santoso"
echo $nama
```

Output:

```
Budi Santoso
```

Terlihat sama, tetapi sebenarnya `echo` menerima **dua argumen**: `Budi` dan `Santoso`. Jika digunakan dalam konteks lain, misalnya:

```sh
file="my document.txt"
rm $file
```

`rm` akan menerima **dua argumen**: `my` dan `document.txt`. File `my document.txt` tidak akan terhapus, dan Anda mungkin menghapus file lain secara tidak sengaja.

### `${var}` — Ekspansi dengan Kurung Kurawal

```sh
nama="Budi"
echo ${nama}
```

Penjelasan:

- `${nama}` – Sama seperti `$nama`, tetapi nama variabel dibatasi oleh `}`.
- Kapan perlu? Ketika variabel diikuti oleh karakter yang bisa menjadi bagian dari nama variabel.

Contoh:

```sh
nama="Budi"
echo "$nama_file"
```

Output: kosong (atau error). Shell mencari variabel bernama `nama_file`, bukan `nama` diikuti `_file`.

Yang benar:

```sh
echo "${nama}_file"
```

Output:

```
Budi_file
```

Kurung kurawal memberi **batas eksplisit** pada nama variabel.

### `"$var"` — Ekspansi dalam Kutip Ganda

```sh
nama="Budi Santoso"
echo "$nama"
```

Penjelasan:

- Tanda kutip ganda (`"`) mencegah **word splitting** dan **globbing**.
- Ekspansi parameter (`$nama`) **tetap terjadi** di dalam kutip ganda.
- `echo` menerima **satu argumen**: `Budi Santoso`.
- Ini adalah **bentuk yang paling aman** dan paling sering digunakan.

### `"${var}"` — Kombinasi Aman

```sh
nama="Budi Santoso"
echo "${nama}_file"
```

Penjelasan:

- Menggabungkan keamanan kutip ganda dengan batas eksplisit kurung kurawal.
- **Ini adalah bentuk yang direkomendasikan** untuk hampir semua penggunaan variabel.

### Tabel Perbandingan

| Bentuk | Word Split | Globbing | Batas Nama | Rekomendasi |
|--------|-----------|----------|------------|-------------|
| `$var` | Ya | Ya | Tidak | Hindari |
| `${var}` | Ya | Ya | Ya | Untuk kasus khusus |
| `"$var"` | Tidak | Tidak | Tidak | Aman |
| `"${var}"` | Tidak | Tidak | Ya | **Paling aman** |

### Aturan Emas

> **Selalu kutip variabel Anda dengan `"${var}"` kecuali Anda benar-benar tahu mengapa tidak.**

Ada beberapa pengecualian:

1. Dalam `[ ]` (test), variabel **tidak boleh** dikutip jika Anda ingin melakukan perbandingan tertentu (misalnya `[ -z $var ]` vs `[ -z "$var" ]`). Namun, **selalu kutip** `"$var"` bahkan di dalam `[ ]` — ini lebih aman.
2. Dalam assignment `var=$other`, kutip tidak diperlukan karena word splitting tidak terjadi di sisi kanan assignment. Tapi kutip tetap aman: `var="$other"`.

---

## 2.1.3 Word Splitting: Musuh Tersembunyi

**Word splitting** adalah proses shell memecah string menjadi beberapa kata berdasarkan **IFS** (Internal Field Separator).

### Nilai Default IFS

```sh
echo "$IFS" | od -c
```

Output (kira-kira):

```
0000000      \t  \n
0000003
```

Penjelasan:

- `IFS` default berisi tiga karakter: **spasi**, **tab**, dan **newline**.
- `od -c` – **Octal dump**, menampilkan karakter sebagai karakter literal. `\t` adalah tab, `\n` adalah newline.

### Kapan Word Splitting Terjadi?

Word splitting terjadi pada hasil **ekspansi parameter yang tidak dikutip**, dan pada hasil **command substitution yang tidak dikutip**.

Contoh:

```sh
nama="Budi Santoso"
daftar=$nama
echo $daftar
```

Penjelasan:

- `daftar=$nama` – Assignment. Word splitting **tidak** terjadi di sisi kanan assignment. `daftar` berisi `Budi Santoso`.
- `echo $daftar` – Ekspansi `$daftar` tidak dikutip, sehingga word splitting terjadi. `echo` menerima dua argumen.

Untuk mencegah:

```sh
echo "$daftar"
```

### Mengubah IFS

```sh
IFS=:
nama="Budi:Santoso:Jakarta"
for bagian in $nama; do
    echo "$bagian"
done
```

Output:

```
Budi
Santoso
Jakarta
```

Penjelasan:

- `IFS=:` – Mengubah pemisah menjadi titik dua.
- `for bagian in $nama` – Word splitting menggunakan IFS baru, sehingga `$nama` dipecah pada `:`.
- **Catatan:** Mengubah `IFS` harus dikembalikan setelah selesai, atau gunakan subshell.

### Mengembalikan IFS

```sh
OLD_IFS="$IFS"
IFS=:
# ... lakukan sesuatu ...
IFS="$OLD_IFS"
```

Atau gunakan **subshell**:

```sh
(
    IFS=:
    for bagian in $nama; do
        echo "$bagian"
    done
)
```

Penjelasan:

- `(` dan `)` – Membuat **subshell**. Perubahan di dalamnya tidak mempengaruhi shell induk.

### Jebakan Word Splitting

```sh
file="laporan penting.txt"
if [ -f $file ]; then
    echo "File ada"
fi
```

Penjelasan:

- `[ -f $file ]` – `$file` tidak dikutip, sehingga word splitting terjadi.
- `[` menerima argumen `-f`, `laporan`, `penting.txt`, `]` — ini adalah **4 argumen**, bukan 3.
- `test` akan error: `[: too many arguments`.
- Yang benar:
  ```sh
  if [ -f "$file" ]; then
  ```

---

## 2.1.4 Globbing: Ekspansi Wildcard

**Globbing** adalah ekspansi karakter wildcard (`*`, `?`, `[ ]`) menjadi nama file yang cocok.

```sh
echo *.txt
```

Penjelasan:

- `*.txt` – Shell mencari semua file di direktori saat ini yang berakhiran `.txt`.
- Hasilnya, `echo` menerima daftar file sebagai argumen terpisah.
- Jika tidak ada file yang cocok, `*.txt` tetap literal (perilaku POSIX). Bash bisa mengubah ini dengan `nullglob`, tetapi itu **tidak POSIX**.

### Globbing Tidak Terjadi di Dalam Kutip

```sh
echo "*.txt"
```

Output:

```
*.txt
```

Penjelasan:

- Kutip ganda mencegah globbing.
- String `*.txt` dianggap literal.

### Menonaktifkan Globbing

```sh
set -f
```

Penjelasan:

- `set -f` – **Noglob**. Menonaktifkan globbing secara global.
- Berguna saat Anda ingin memperlakukan `*` sebagai karakter literal tanpa harus mengutip setiap saat.
- Untuk mengaktifkan kembali: `set +f`.

---

## 2.1.5 Ekspansi Parameter POSIX (Lengkap)

POSIX mendefinisikan banyak bentuk ekspansi parameter. Ini adalah **inti** dari manipulasi variabel yang canggih.

### `${var:-default}` — Default Value

```sh
echo "${nama:-Anonim}"
```

Penjelasan:

- Jika `nama` **unset** atau **kosong**, gunakan `Anonim`.
- Jika `nama` berisi nilai (bahkan hanya spasi), gunakan nilai itu.
- Variabel `nama` **tidak diubah**.

Contoh:

```sh
unset nama
echo "${nama:-Anonim}"   # Output: Anonim
nama="Budi"
echo "${nama:-Anonim}"   # Output: Budi
nama=""
echo "${nama:-Anonim}"   # Output: Anonim (karena kosong)
```

### `${var-default}` — Default Value (Tanpa Pemeriksaan Kosong)

```sh
echo "${nama-Anonim}"
```

Penjelasan:

- Sama seperti `${var:-default}`, tetapi **hanya** memeriksa apakah variabel **unset**, bukan apakah kosong.
- Jika `nama` di-set ke string kosong `""`, maka `${nama-Anonim}` menghasilkan string kosong.
- Bandingkan dengan `${nama:-Anonim}` yang menghasilkan `Anonim` untuk string kosong.

Contoh:

```sh
unset nama
echo "${nama-Anonim}"     # Output: Anonim
nama=""
echo "${nama-Anonim}"     # Output: (kosong)
echo "${nama:-Anonim}"    # Output: Anonim
```

### `${var:=default}` — Assign Default

```sh
echo "${nama:=Anonim}"
echo "$nama"
```

Penjelasan:

- Jika `nama` unset atau kosong, **set** `nama` ke `Anonim` dan gunakan nilai itu.
- Jika `nama` sudah ada, gunakan nilai yang ada.
- **Efek samping:** variabel di-set.

Contoh:

```sh
unset nama
echo "${nama:=Anonim}"   # Output: Anonim
echo "$nama"             # Output: Anonim (variabel sekarang di-set)
```

### `${var=default}` — Assign Default (Tanpa Pemeriksaan Kosong)

Sama seperti `${var:=default}`, tetapi hanya memeriksa unset, bukan kosong.

### `${var:?pesan}` — Error Jika Kosong

```sh
echo "${nama:?Nama harus diisi}"
```

Penjelasan:

- Jika `nama` unset atau kosong, cetak `pesan` ke stderr dan keluar dari skrip (jika non-interaktif).
- Jika `nama` ada, gunakan nilainya.
- Berguna untuk validasi argumen wajib.

Contoh:

```sh
#!/bin/sh
: "${NAMA:?Variabel NAMA wajib diisi}"
echo "Halo, $NAMA"
```

Penjelasan:

- `:` – Perintah **no-op** (do nothing). Sering digunakan bersama ekspansi parameter untuk efek samping.
- `"${NAMA:?Variabel NAMA wajib diisi}"` – Jika `NAMA` tidak ada, skrip keluar dengan pesan error.

### `${var:+alternatif}` — Gunakan Alternatif Jika Ada

```sh
echo "${nama:+Halo, $nama}"
```

Penjelasan:

- Jika `nama` **di-set dan tidak kosong**, gunakan `alternatif`.
- Jika `nama` unset atau kosong, hasilnya string kosong.
- Kebalikan dari `${var:-default}`.

Contoh:

```sh
unset nama
echo "${nama:+Halo}"     # Output: (kosong)
nama="Budi"
echo "${nama:+Halo}"     # Output: Halo
```

### `${#var}` — Panjang String

```sh
nama="Budi"
echo "${#nama}"
```

Output:

```
4
```

Penjelasan:

- `${#nama}` – Mengembalikan panjang string (jumlah karakter).
- Untuk UTF-8, jumlah **byte** mungkin berbeda dari jumlah **karakter**. POSIX tidak mendefinisikan multibyte secara portabel.

### `${var#pattern}` — Hapus Awalan Terpendek

```sh
file="/home/budi/laporan.txt"
echo "${file#*/}"
```

Output:

```
home/budi/laporan.txt
```

Penjelasan:

- `#` – Menghapus **awalan terpendek** yang cocok dengan `pattern`.
- `*/` – Pola: apa pun diikuti `/`.
- `#*/` menghapus awalan terpendek yang diakhiri `/`, yaitu `/`.

Jika menggunakan `##`:

```sh
echo "${file##*/}"
```

Output:

```
laporan.txt
```

Penjelasan:

- `##` – Menghapus **awalan terpanjang** yang cocok.
- `##*/` menghapus semua hingga `/` terakhir.

### `${var%pattern}` — Hapus Akhiran Terpendek

```sh
file="/home/budi/laporan.txt"
echo "${file%.*}"
```

Output:

```
/home/budi/laporan
```

Penjelasan:

- `%` – Menghapus **akhiran terpendek** yang cocok dengan pola.
- `.*` – Pola: titik diikuti apa pun.
- Hasil: `.txt` dihapus.

Jika menggunakan `%%`:

```sh
echo "${file%%.*}"
```

Output:

```
/home/budi/laporan
```

Penjelasan:

- `%%` – Menghapus akhiran terpanjang.
- Dalam kasus ini, hasilnya sama karena hanya ada satu titik.

Bandingkan dengan file `arsip.tar.gz`:

```sh
file="arsip.tar.gz"
echo "${file%.*}"    # arsip.tar
echo "${file%%.*}"   # arsip
```

### `${var/old/new}` — Ganti Pertama

**Catatan:** Fitur ini **tidak POSIX**. Ini adalah ekstensi bash. Untuk penggantian string portabel, gunakan `sed` atau `awk`. Namun, banyak shell modern mendukungnya. Kita akan membahasnya di Level 3 (sed/awk). Untuk sekarang, hindari di skrip POSIX.

### Tabel Ringkasan Ekspansi Parameter

| Bentuk | Arti |
|--------|------|
| `${var}` | Nilai variabel |
| `${var:-default}` | Default jika unset atau kosong |
| `${var-default}` | Default jika unset saja |
| `${var:=default}` | Set default jika unset atau kosong |
| `${var=default}` | Set default jika unset saja |
| `${var:?pesan}` | Error jika unset atau kosong |
| `${var?pesan}` | Error jika unset saja |
| `${var:+alt}` | Alt jika unset atau kosong |
| `${var+alt}` | Alt jika unset saja |
| `${#var}` | Panjang string |
| `${var#pattern}` | Hapus awalan terpendek |
| `${var##pattern}` | Hapus awalan terpanjang |
| `${var%pattern}` | Hapus akhiran terpendek |
| `${var%%pattern}` | Hapus akhiran terpanjang |

---

## 2.1.6 Variabel Spesial

Shell menyediakan variabel spesial yang di-set otomatis. Ini adalah alat penting.

### `$?` — Exit Status

```sh
ls /tmp
echo "$?"
```

Penjelasan:

- `$?` – Exit status dari perintah terakhir.
- `0` – Sukses.
- `1`–`125` – Berbagai error.
- `126` – Perintah tidak dapat dieksekusi.
- `127` – Perintah tidak ditemukan.
- `128+N` – Proses dihentikan oleh sinyal N (misalnya `130` untuk SIGINT = 128+2).

Contoh:

```sh
grep "pola" file.txt
if [ $? -eq 0 ]; then
    echo "Ditemukan"
else
    echo "Tidak ditemukan"
fi
```

**Catatan:** Lebih baik gunakan `if grep "pola" file.txt; then` karena `if` langsung mengevaluasi exit status perintah.

### `$$` — PID Shell

```sh
echo "PID: $$"
```

Penjelasan:

- `$$` – PID dari shell yang menjalankan perintah.
- Dalam skrip, `$$` adalah PID shell yang menjalankan skrip.
- Berguna untuk nama file temporary yang unik:
  ```sh
  tmpfile="/tmp/data.$$"
  ```

### `$!` — PID Proses Latar Belakang

```sh
sleep 10 &
echo "$!"
```

Penjelasan:

- `&` – Menjalankan perintah di latar belakang.
- `$!` – PID dari proses latar belakang terakhir.
- Berguna untuk memantau proses:
  ```sh
  sleep 10 &
  PID=$!
  wait "$PID"
  ```

### `$#` — Jumlah Argumen

```sh
echo "Jumlah argumen: $#"
```

Penjelasan:

- `$#` – Jumlah argumen posisi yang diberikan ke skrip atau fungsi.

### `$@` — Semua Argumen (Terpisah)

```sh
for arg in "$@"; do
    echo "Argumen: $arg"
done
```

Penjelasan:

- `"$@"` – Ekspansi menjadi daftar argumen, masing-masing dikutip terpisah.
- Ini adalah **cara yang benar** untuk memproses argumen dalam loop.
- Setiap argumen dianggap sebagai satu kata, bahkan jika mengandung spasi.

### `$*` — Semua Argumen (Satu String)

```sh
for arg in "$*"; do
    echo "Argumen: $arg"
done
```

Penjelasan:

- `"$*"` – Ekspansi menjadi satu string, argumen dipisahkan oleh karakter pertama `IFS` (biasanya spasi).
- Loop hanya berjalan **sekali** dengan semua argumen digabung.
- **Hampir selalu salah** untuk digunakan dalam loop.

### Perbedaan `$@` dan `$*`

Anggaplah skrip dipanggil dengan:

```sh
./skrip.sh "Budi Santoso" "Jakarta"
```

**Dengan `"$@"`:**

```
Argumen: Budi Santoso
Argumen: Jakarta
```

Dua iterasi, masing-masing argumen utuh.

**Dengan `"$*"`:**

```
Argumen: Budi Santoso Jakarta
```

Satu iterasi, semua digabung.

**Tanpa kutip (`$@` atau `$*`):**

```
Argumen: Budi
Argumen: Santoso
Argumen: Jakarta
```

Tiga iterasi, argumen dengan spasi dipecah. **Ini bug.**

> **Aturan:** Selalu gunakan `"$@"` untuk memproses argumen. Hindari `$*`.

### `$0` — Nama Skrip

```sh
echo "Skrip: $0"
```

Penjelasan:

- `$0` – Nama skrip sebagaimana dipanggil.
- Dalam fungsi, `$0` tetap nama skrip, bukan nama fungsi.

### `$1` – `$9` — Argumen Posisi

```sh
echo "Argumen 1: $1"
echo "Argumen 2: $2"
```

Penjelasan:

- `$1` hingga `$9` – Argumen posisi.
- Untuk argumen ke-10 dan seterusnya: `${10}`, `${11}`, dst.
- Tanpa kurung kurawal, `$10` dianggap `$1` diikuti `0`.

### `$-` — Opsi Shell

```sh
echo "$-"
```

Penjelasan:

- `$-` – Opsi shell yang sedang aktif.
- Misalnya `himBHs` berarti `-h`, `-i`, `-m`, `-B`, `-H`, `-s` aktif.
- Berguna untuk memeriksa apakah shell interaktif: `case "$-" in *i*) echo "Interaktif";; esac`.

---

## 2.1.7 Assignment dan Ekspansi: Jebakan Halus

### Assignment vs Command

```sh
nama="Budi"
```

Penjelasan:

- Ini adalah **assignment murni**. Tidak ada perintah yang dijalankan.
- Variabel `nama` di-set.

```sh
nama="Budi" echo "$nama"
```

Penjelasan:

- Ini **bukan** assignment murni. Ini adalah assignment **sementara** untuk perintah `echo`.
- `nama` di-set hanya untuk durasi perintah `echo`.
- Namun, `$nama` diekspansi **sebelum** assignment diterapkan. Jadi output bisa kosong.
- Setelah perintah selesai, `nama` tidak di-set.

### Assignment di Depan Perintah

```sh
PATH="/custom:$PATH" mycommand
```

Penjelasan:

- `PATH` di-set hanya untuk `mycommand`, tidak permanen.
- Berguna untuk menjalankan perintah dengan environment berbeda.

### Assignment Bersamaan

```sh
a=1 b=2 c=3
```

Penjelasan:

- POSIX tidak mendefinisikan assignment bersamaan dalam satu baris dengan cara ini.
- Bash mendukung, tetapi tidak portabel. Hindari.

Yang benar:

```sh
a=1
b=2
c=3
```

### Kutip dalam Assignment

```sh
nama="Budi Santoso"
```

Penjelasan:

- Kutip ganda melindungi spasi.
- Tanpa kutip: `nama=Budi Santoso` akan error (Santoso dianggap perintah).

```sh
angka=42
```

Penjelasan:

- Tidak perlu kutip untuk angka tunggal.
- Namun, kutip tetap aman: `angka="42"`.

### Assignment dengan Command Substitution

```sh
tanggal=$(date +%Y-%m-%d)
```

Penjelasan:

- `$(date +%Y-%m-%d)` – Command substitution. Menjalankan `date` dengan format YYYY-MM-DD, menangkap output.
- Tidak perlu kutip karena assignment tidak melakukan word splitting pada sisi kanan.

Tapi hati-hati:

```sh
daftar=$(ls)
```

Penjelasan:

- `daftar` akan berisi output `ls` dengan newline di dalamnya.
- Untuk memprosesnya sebagai daftar, gunakan loop:
  ```sh
  for file in $(ls); do
  ```
  Tapi ini **tidak aman** untuk nama file dengan spasi. Alternatif POSIX:
  ```sh
  for file in *; do
  ```
  atau
  ```sh
  ls | while read -r file; do
  ```

---

## 2.1.8 Environment Variable vs Shell Variable (Pendalaman)

Kita sudah membahas ini di Level 1. Sekarang kita perdalam.

### `export` — Menandai Variabel

```sh
nama="Budi"
export nama
```

Penjelasan:

- `export` menandai variabel agar diwariskan ke proses anak.
- Setelah `export`, setiap proses yang dijalankan dari shell ini akan menerima `nama` di environment-nya.

Bisa digabung:

```sh
export nama="Budi"
```

Atau beberapa sekaligus:

```sh
export VAR1 VAR2 VAR3
```

Penjelasan:

- `export VAR1 VAR2 VAR3` – Mengekspor ketiga variabel (yang harus sudah di-set).

### Melihat Environment

```sh
env
```

Penjelasan:

- Menampilkan semua environment variable.

```sh
export -p
```

Penjelasan:

- `-p` – Menampilkan semua variabel yang di-export dalam format yang bisa dieksekusi kembali.
- Output berupa baris `export VAR=nilai`.

### Menghapus Export

```sh
export -n nama
```

Penjelasan:

- `-n` – Menghapus tanda export, tetapi variabel tetap ada.
- **Tidak POSIX**. POSIX tidak mendefinisikan cara "unexport".

### `unset` — Menghapus Variabel

```sh
unset nama
```

Penjelasan:

- Menghapus variabel `nama` dari shell.
- Jika variabel di-export, `unset` juga menghapusnya dari environment.
- POSIX mendefinisikan `unset -v` untuk variabel dan `unset -f` untuk fungsi:
  ```sh
  unset -v nama   # hapus variabel
  unset -f fungsi # hapus fungsi
  ```

### `readonly` — Variabel Konstan

```sh
readonly PI=3.14
```

Penjelasan:

- `readonly` – Menandai variabel sebagai **read-only**.
- Setelah ini, `PI=3.15` akan error.
- Berguna untuk konfigurasi yang tidak boleh diubah.

```sh
readonly -p
```

Penjelasan:

- Menampilkan semua variabel read-only.
- **Tidak POSIX** untuk `-p`. POSIX mendefinisikan `readonly` tanpa opsi.

### Praktek: Environment untuk Skrip Anak

```sh
#!/bin/sh
# parent.sh
export PESAN="Halo dari parent"
./child.sh
```

```sh
#!/bin/sh
# child.sh
echo "$PESAN"
```

Penjelasan:

- `parent.sh` meng-export `PESAN`, lalu menjalankan `child.sh`.
- `child.sh` menerima `PESAN` di environment-nya.
- Jika `PESAN` tidak di-export, `child.sh` tidak akan melihatnya.

---

## 2.1.9 Variabel dalam Fungsi

Fungsi di shell **berbagi namespace** dengan skrip utama. Ini berbeda dari banyak bahasa pemrograman.

```sh
#!/bin/sh

nama="Global"

fungsi() {
    nama="Lokal"
    echo "Dalam fungsi: $nama"
}

fungsi
echo "Setelah fungsi: $nama"
```

Output:

```
Dalam fungsi: Lokal
Setelah fungsi: Lokal
```

Penjelasan:

- Fungsi mengubah variabel global `nama`.
- Ini adalah **efek samping** yang sering tidak diinginkan.

### `local` — Variabel Lokal

```sh
fungsi() {
    local nama="Lokal"
    echo "Dalam fungsi: $nama"
}
```

Penjelasan:

- `local` – Mendefinisikan variabel yang hanya berlaku di dalam fungsi.
- Setelah fungsi selesai, variabel `nama` kembali ke nilai sebelumnya.
- **`local` tidak POSIX.** POSIX tidak mendefinisikan `local`. Namun, hampir semua shell modern mendukungnya. Untuk skrip yang benar-benar portabel, hindari `local` dan gunakan konvensi penamaan.

### Alternatif Portabel

Gunakan prefix unik:

```sh
_fungsi_nama="Lokal"
```

Atau simpan dan pulihkan:

```sh
fungsi() {
    _old_nama="$nama"
    nama="Lokal"
    # ...
    nama="$_old_nama"
}
```

---

## 2.1.10 Contoh Skrip Lengkap

Mari kita gabungkan semuanya dalam skrip nyata.

### Skrip 1: Validasi Argumen

```sh
#!/bin/sh
# Nama: sapa.sh
# Tujuan: Menyapa pengguna dengan nama yang diberikan

: "${1:?Penggunaan: $0 nama}"

nama="$1"

echo "Halo, ${nama}!"
echo "Panjang nama: ${#nama} karakter"
```

Bedah:

- `: "${1:?Penggunaan: $0 nama}"` – 
  - `:` – No-op.
  - `"${1:?...}"` – Jika `$1` unset atau kosong, cetak pesan dan keluar.
  - `$0` di dalam pesan diekspansi menjadi nama skrip.
- `nama="$1"` – Simpan argumen ke variabel.
- `"${nama}"` – Kutip ganda dengan kurung kurawal.
- `"${#nama}"` – Panjang string.

### Skrip 2: Default dan Alternatif

```sh
#!/bin/sh
# Nama: konfigurasi.sh
# Tujuan: Menunjukkan penggunaan operator default

# Default jika unset atau kosong
HOST="${HOST:-localhost}"
PORT="${PORT:-8080}"

# Error jika wajib
: "${USER_WAJIB:?USER_WAJIB harus di-set}"

# Alternatif jika ada
VERBOSE="${DEBUG:+--verbose}"

echo "Host: $HOST"
echo "Port: $PORT"
echo "Verbose: $VERBOSE"
```

Bedah:

- `${HOST:-localhost}` – Default `localhost` jika `HOST` unset atau kosong.
- `${PORT:-8080}` – Default `8080`.
- `${USER_WAJIB:?...}` – Error jika tidak di-set.
- `${DEBUG:+--verbose}` – Jika `DEBUG` di-set, hasilnya `--verbose`. Jika tidak, kosong.

### Skrip 3: Manipulasi Path

```sh
#!/bin/sh
# Nama: pathinfo.sh
# Tujuan: Menampilkan informasi tentang path file

file="${1:?Penggunaan: $0 path}"

echo "Path lengkap: $file"
echo "Direktori: ${file%/*}"
echo "Nama file: ${file##*/}"
echo "Ekstensi: ${file##*.}"
echo "Tanpa ekstensi: ${file%.*}"
```

Bedah:

- `${file%/*}` – Hapus akhiran terpendek yang cocok dengan `/*`, yaitu bagian setelah `/` terakhir.
- `${file##*/}` – Hapus awalan terpanjang yang cocok dengan `*/`, yaitu semua hingga `/` terakhir.
- `${file##*.}` – Hapus awalan terpanjang yang cocok dengan `*.`, yaitu semua hingga `.` terakhir.
- `${file%.*}` – Hapus akhiran terpendek yang cocok dengan `.*`, yaitu ekstensi.

Contoh:

```sh
./pathinfo.sh /home/budi/laporan.txt
```

Output:

```
Path lengkap: /home/budi/laporan.txt
Direktori: /home/budi
Nama file: laporan.txt
Ekstensi: txt
Tanpa ekstensi: /home/budi/laporan
```

### Skrip 4: Loop Argumen Aman

```sh
#!/bin/sh
# Nama: argumen.sh
# Tujuan: Menampilkan semua argumen dengan aman

echo "Jumlah argumen: $#"

for arg in "$@"; do
    echo "  - $arg"
done
```

Bedah:

- `"$@"` – Ekspansi argumen yang aman.
- Setiap argumen dianggap utuh, bahkan jika mengandung spasi.

Contoh:

```sh
./argumen.sh "Budi Santoso" "Jakarta" "Indonesia"
```

Output:

```
Jumlah argumen: 3
  - Budi Santoso
  - Jakarta
  - Indonesia
```

---

## 2.1.11 Latihan

1. **Default dan Alternatif:**
   - Tulis skrip yang membaca `$EDITOR` dengan default `vi` dan `$PAGER` dengan default `less`.
   - Gunakan `${var:-default}`.
   - Cetak nilai yang digunakan.

2. **Validasi:**
   - Tulis skrip yang memerlukan dua argumen: nama dan umur.
   - Gunakan `${1:?...}` dan `${2:?...}` untuk validasi.
   - Cetak pesan yang sesuai.

3. **Manipulasi String:**
   - Berikan path `/var/log/syslog.1.gz` sebagai argumen.
   - Cetak direktori, nama file, ekstensi, dan nama tanpa ekstensi.
   - Gunakan operator `${var%pattern}` dan `${var##pattern}`.

4. **Loop Argumen:**
   - Tulis skrip yang mencetak setiap argumen dalam format `[argumen ke-N]: nilai`.
   - Gunakan counter dan `"$@"`.

5. **Word Splitting:**
   - Buat file dengan nama mengandung spasi: `touch "file penting.txt"`.
   - Coba `for f in $(ls); do echo "$f"; done`. Apa yang terjadi?
   - Ubah ke `for f in *; do echo "$f"; done`. Apa bedanya?
   - Jelaskan mengapa `*` lebih aman daripada `$(ls)`.

6. **Environment:**
   - Tulis skrip `parent.sh` yang meng-export `PESAN="Halo"` dan menjalankan `child.sh`.
   - Tulis skrip `child.sh` yang mencetak `$PESAN`.
   - Jalankan `parent.sh`. Apakah `child.sh` melihat `PESAN`?
   - Hapus `export`, jalankan lagi. Apa yang terjadi?

7. **Ekspansi Parameter Lengkap:**
   - Buat skrip yang mendemonstrasikan semua bentuk ekspansi:
     - `${var:-default}`
     - `${var:=default}`
     - `${var:?error}`
     - `${var:+alt}`
     - `${#var}`
     - `${var#pattern}`
     - `${var%pattern}`
     - `${var##pattern}`
     - `${var%%pattern}`
   - Untuk setiap bentuk, tampilkan variabel sebelum, hasil ekspansi, dan variabel sesudah (jika berubah).

---

## 2.1.12 Ringkasan Materi 1

- Variabel shell adalah string; tidak ada tipe data.
- Assignment tidak boleh ada spasi di sekitar `=`.
- Selalu kutip variabel: `"${var}"` adalah bentuk paling aman.
- Word splitting dan globbing adalah penyebab bug paling umum; kutip ganda mencegah keduanya.
- Ekspansi parameter POSIX mencakup default, assign, error, alternatif, panjang, hapus awalan/akhiran.
- Variabel spesial (`$?`, `$$`, `$!`, `$#`, `$@`, `$*`, `$0`–`$9`) adalah alat penting.
- `"$@"` adalah cara benar untuk memproses argumen; hindari `$*` dan `$@` tanpa kutip.
- `export` menandai variabel untuk diwariskan ke proses anak.
- `readonly` membuat variabel konstan.
- `local` tidak POSIX; gunakan konvensi penamaan untuk portabilitas.

---

## 📌 Selanjutnya

Materi 1 Level 2 selesai. Anda sekarang menguasai variabel dan ekspansi parameter secara mendalam.

Berikutnya adalah **Materi 2: Kondisional (`if`, `test`, `case`)** — kita akan membahas:

- Struktur `if`, `elif`, `else`, `fi`.
- Perintah `test` dan `[ ]` secara mendalam.
- Semua operator: numerik, string, file.
- Operator Boolean: `&&`, `||`, `!`.
- `case` untuk percabangan multi-opsi.
- Jebakan umum dan praktik terbaik.

## Materi 2: Kondisional (`if`, `test`, `case`)

> **Catatan:** Ini adalah **materi kedua** dari Level 2. Kita akan membedah setiap struktur kondisional POSIX, setiap operator `test`, dan setiap jebakan yang pernah menjebak programmer shell. Setelah materi ini, Anda akan mampu menulis logika percabangan yang kompleks, aman, dan portabel.

---

## 🎯 Tujuan Materi 2

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Menulis struktur `if`, `elif`, `else`, `fi` dengan benar.
2. Memahami bahwa `if` mengevaluasi **exit status**, bukan "benar/salah" boolean.
3. Menguasai perintah `test` dan `[ ]` secara mendalam.
4. Menggunakan semua operator numerik, string, dan file dengan tepat.
5. Menggabungkan kondisi dengan `&&`, `||`, `!`.
6. Menggunakan `case` untuk percabangan multi-opsi.
7. Menghindari jebakan klasik seperti `[ $var = "x" ]` tanpa kutip.
8. Menulis skrip yang menangani error dengan elegan.

---

## 2.2.1 Filosofi Kondisional di Shell

Di banyak bahasa pemrograman, kondisional didasarkan pada **nilai boolean** (`true`/`false`). Di shell, kondisional didasarkan pada **exit status** sebuah perintah.

Ingat:

- Exit status `0` = **sukses** (true).
- Exit status **non-zero** = **gagal** (false).

Ini terbalik dari intuisi banyak orang. Di shell, `0` berarti "berhasil", bukan "false".

Setiap perintah yang Anda jalankan mengembalikan exit status. Perintah `if` mengevaluasi exit status tersebut.

```sh
if perintah; then
    # dijalankan jika perintah sukses (exit 0)
fi
```

Jadi, `if` tidak memeriksa apakah sesuatu "benar". `if` memeriksa apakah perintah yang dijalankan **berhasil**.

---

## 2.2.2 Struktur `if`

### Sintaks Dasar

```sh
if kondisi; then
    perintah1
    perintah2
fi
```

Penjelasan kata demi kata:

- `if` – Kata kunci yang memulai blok kondisional. POSIX mendefinisikannya sebagai *compound command*.
- `kondisi` – Sebuah perintah (biasanya `test` atau `[ ]`) yang mengembalikan exit status.
- `;` – Pemisah perintah. Mengizinkan `then` ditulis di baris yang sama.
- `then` – Kata kunci yang menandai awal blok yang dieksekusi jika kondisi sukses.
- `perintah1`, `perintah2` – Perintah yang dijalankan.
- `fi` – Kata kunci penutup. `fi` adalah `if` terbalik.

### Format Alternatif

```sh
if kondisi
then
    perintah
fi
```

`then` di baris terpisah. Ini juga valid. Beberapa gaya panduan lebih suka ini. Pilih satu gaya dan konsisten.

### Contoh Sederhana

```sh
#!/bin/sh

if [ -f "/etc/passwd" ]; then
    echo "File /etc/passwd ada."
fi
```

Penjelasan:

- `[ -f "/etc/passwd" ]` – Perintah `test` dengan operator `-f` (file ada dan merupakan file biasa). Mengembalikan `0` jika benar, `1` jika salah.
- Jika `0`, blok `then` dieksekusi.
- `fi` menutup blok.

### `if` dengan Perintah Apa Pun

```sh
if grep -q "root" /etc/passwd; then
    echo "Ada user root."
fi
```

Penjelasan:

- `grep -q "root" /etc/passwd` – `grep` dengan `-q` (quiet). Tidak mencetak apa pun, hanya mengembalikan exit status.
- Jika `root` ditemukan, exit status `0`.
- `if` mengevaluasi exit status tersebut.

Ini adalah pola yang sangat kuat: **gunakan perintah nyata sebagai kondisi**.

### `if` dengan Beberapa Perintah

```sh
if cd /tmp && [ -w . ]; then
    echo "Bisa menulis di /tmp."
fi
```

Penjelasan:

- `cd /tmp` – Mengubah direktori ke `/tmp`.
- `&&` – Operator AND. Perintah berikutnya hanya dijalankan jika `cd` sukses.
- `[ -w . ]` – Cek apakah direktori saat ini (`.` = `/tmp`) dapat ditulis.
- Keduanya harus sukses agar blok `then` dieksekusi.

### `if` dengan Negasi

```sh
if ! [ -f "/etc/passwd" ]; then
    echo "File /etc/passwd TIDAK ada."
fi
```

Penjelasan:

- `!` – Operator negasi. Membalik exit status.
- Jika `[ -f "/etc/passwd" ]` mengembalikan `0` (file ada), `!` membuatnya `1`.
- Jika file tidak ada (exit `1`), `!` membuatnya `0`, sehingga blok `then` dieksekusi.

### `if` Tanpa `then`? Tidak Bisa.

`then` adalah kata kunci wajib. Jika Anda menulis:

```sh
if [ -f file ]
    echo "Ada"
fi
```

Shell akan error. `then` harus ada.

---

## 2.2.3 `else` dan `elif`

### `else`

```sh
if [ -f "$file" ]; then
    echo "File ada."
else
    echo "File tidak ada."
fi
```

Penjelasan:

- `else` – Blok yang dieksekusi jika kondisi `if` gagal (exit non-zero).
- Hanya boleh ada satu `else` dalam satu `if`.

### `elif`

```sh
if [ "$1" = "start" ]; then
    echo "Memulai..."
elif [ "$1" = "stop" ]; then
    echo "Menghentikan..."
elif [ "$1" = "restart" ]; then
    echo "Restart..."
else
    echo "Perintah tidak dikenal: $1"
fi
```

Penjelasan:

- `elif` – Singkatan dari "else if". Memeriksa kondisi baru jika kondisi sebelumnya gagal.
- Bisa ada berapa pun `elif`.
- `else` opsional di akhir.
- `fi` menutup seluruh rangkaian.

### Perilaku Evaluasi

`if`/`elif` dievaluasi dari atas ke bawah. Begitu satu kondisi sukses, bloknya dieksekusi dan sisanya dilewati.

```sh
x=5
if [ "$x" -gt 10 ]; then
    echo "Besar"
elif [ "$x" -gt 3 ]; then
    echo "Sedang"    # Ini yang dieksekusi
elif [ "$x" -gt 1 ]; then
    echo "Kecil"     # Tidak dieksekusi
fi
```

Output:

```
Sedang
```

### Jebakan: Urutan Kondisi

```sh
if [ "$x" -gt 1 ]; then
    echo "Kecil"
elif [ "$x" -gt 3 ]; then
    echo "Sedang"
elif [ "$x" -gt 10 ]; then
    echo "Besar"
fi
```

Dengan `x=5`, output adalah `Kecil`, bukan `Sedang`. Karena kondisi pertama sudah benar, sisanya dilewati. **Urutkan kondisi dari yang paling spesifik ke paling umum.**

---

## 2.2.4 Perintah `test` dan `[ ]`

`test` adalah perintah POSIX untuk mengevaluasi ekspresi. `[` adalah alias untuk `test`, dengan syarat harus diakhiri `]`.

### `test` vs `[`

```sh
test -f "$file"
[ -f "$file" ]
```

Keduanya sama. Perbedaan hanya sintaksis. `[` memerlukan `]` sebagai argumen terakhir.

**Penting:** `[` adalah **perintah**, bukan sintaks shell. Karena itu, butuh spasi setelah `[` dan sebelum `]`.

```sh
[ -f "$file" ]     # ✅
[-f "$file"]       # ❌ (tidak ada spasi)
[ -f "$file"]      # ❌ (tidak ada spasi sebelum ])
```

### `[[ ]]` — Bukan POSIX

Bash dan beberapa shell modern mendukung `[[ ]]` (double bracket). Ini adalah **kata kunci shell**, bukan perintah, dan memiliki kelebihan (tidak perlu kutip, mendukung regex). Tapi **`[[ ]]` tidak POSIX**. Jangan gunakan di skrip portabel.

### Jumlah Argumen ke `test`

`test` berperilaku berbeda berdasarkan jumlah argumen:

- **1 argumen**: Periksa apakah string tidak kosong.
  ```sh
  [ "$var" ]   # true jika $var tidak kosong
  ```
- **2 argumen**: Argumen pertama adalah operator unary.
  ```sh
  [ -f "$file" ]
  [ -n "$var" ]
  [ -z "$var" ]
  ```
- **3 argumen**: Argumen kedua adalah operator binary.
  ```sh
  [ "$a" = "$b" ]
  [ "$a" -eq "$b" ]
  ```
- **4 argumen**: Argumen pertama adalah `!`, atau operator dengan `-a`/`-o`.
  ```sh
  [ ! -f "$file" ]
  [ "$a" = "$b" -a "$c" = "$d" ]   # -a = AND (deprecated)
  ```

### Operator yang Tersedia

#### Operator File

| Operator | Arti |
|----------|------|
| `-e` | File ada (exists) |
| `-f` | File ada dan merupakan file biasa |
| `-d` | Direktori ada |
| `-r` | File ada dan dapat dibaca |
| `-w` | File ada dan dapat ditulis |
| `-x` | File ada dan dapat dieksekusi |
| `-s` | File ada dan ukurannya > 0 |
| `-L` | File ada dan merupakan symlink (POSIX: `-h`) |
| `-h` | Sama seperti `-L` |
| `-p` | Named pipe (FIFO) |
| `-S` | Socket |
| `-b` | Block device |
| `-c` | Character device |
| `-t` | File descriptor adalah terminal |
| `-u` | Setuid bit aktif |
| `-g` | Setgid bit aktif |
| `-k` | Sticky bit aktif |

**Catatan:** `-e` tidak POSIX! Operator `-e` tidak didefinisikan dalam POSIX. POSIX menggunakan `-f`, `-d`, `-r`, `-w`, `-x`, `-s`, `-b`, `-c`, `-p`, `-h`, `-L`, `-S`, `-t`, `-u`, `-g`, `-k`. Untuk cek keberadaan, gunakan `-f` atau `-d` sesuai tipe, atau `-r`/`-w`/`-x`.

Namun, hampir semua implementasi modern mendukung `-e`. Untuk portabilitas maksimal, hindari `-e` dan gunakan `test -r "$file" -o -w "$file"` atau cek tipe spesifik.

#### Operator String

| Operator | Arti |
|----------|------|
| `-z "$s"` | String kosong (zero length) |
| `-n "$s"` | String tidak kosong |
| `"$a" = "$b"` | String sama |
| `"$a" != "$b"` | String berbeda |
| `"$a" < "$b"` | String kurang dari (lexicographic) — **bukan POSIX dalam `[ ]`** |
| `"$a" > "$b"` | String lebih dari — **bukan POSIX dalam `[ ]`** |

**Penting:** Operator `<` dan `>` **tidak POSIX** dalam `[ ]`. Untuk perbandingan string, POSIX hanya mendefinisikan `=` dan `!=`.

Untuk membandingkan string secara lexicographic, gunakan `case` atau `expr`.

#### Operator Numerik

| Operator | Arti |
|----------|------|
| `"$a" -eq "$b"` | Sama dengan (equal) |
| `"$a" -ne "$b"` | Tidak sama dengan (not equal) |
| `"$a" -gt "$b"` | Lebih besar (greater than) |
| `"$a" -ge "$b"` | Lebih besar atau sama (greater or equal) |
| `"$a" -lt "$b"` | Lebih kecil (less than) |
| `"$a" -le "$b"` | Lebih kecil atau sama (less or equal) |

**Catatan:** Operator ini hanya bekerja untuk **integer**. Untuk floating-point, gunakan `awk` atau `bc`.

### Operator Boolean (Deprecated)

| Operator | Arti |
|----------|------|
| `-a` | AND |
| `-o` | OR |
| `!` | NOT |

**Peringatan:** POSIX mendefinisikan `-a` dan `-o` untuk `test`, tetapi **penggunaannya sangat tidak disarankan** karena ambigu, terutama dengan banyak argumen. Gunakan `&&` dan `||` di luar `[ ]` sebagai gantinya.

```sh
# Hindari
[ "$a" = "$b" -a "$c" = "$d" ]

# Gunakan
[ "$a" = "$b" ] && [ "$c" = "$d" ]
```

`!` masih sering digunakan dan aman:

```sh
[ ! -f "$file" ]
```

---

## 2.2.5 Kutip dalam `test`: Jebakan Paling Umum

Ini adalah topik yang **wajib** dipahami.

### Kasus 1: Variabel Kosong

```sh
var=""
if [ $var = "hello" ]; then
    echo "Sama"
fi
```

Penjelasan:

- `$var` kosong, tidak dikutip.
- Setelah word splitting, `[` menerima argumen: `[`, `=`, `hello`, `]`.
- Itu hanya **3 argumen** setelah `[`, tetapi `test` mengharapkan operator di posisi tertentu.
- Hasil: error `[: =: unexpected operator` atau `[: too many arguments`.

Yang benar:

```sh
if [ "$var" = "hello" ]; then
```

### Kasus 2: Variabel Mengandung Spasi

```sh
var="hello world"
if [ $var = "hello world" ]; then
```

Penjelasan:

- `$var` tidak dikutip, word splitting menghasilkan `hello` dan `world`.
- `[` menerima terlalu banyak argumen.
- Error.

Yang benar:

```sh
if [ "$var" = "hello world" ]; then
```

### Kasus 3: Variabel Mengandung `*`

```sh
var="*"
if [ $var = "*" ]; then
```

Penjelasan:

- `$var` tidak dikutip, globbing terjadi.
- `*` diekspansi menjadi semua file di direktori saat ini.
- `[` menerima daftar file yang panjang.
- Error.

Yang benar:

```sh
if [ "$var" = "*" ]; then
```

### Aturan Emas

> **Selalu kutip setiap ekspansi variabel dalam `test`, kecuali Anda benar-benar tahu mengapa tidak.**

Bahkan untuk operator `-z` dan `-n`, kutip tetap aman:

```sh
[ -z "$var" ]    # ✅
[ -n "$var" ]    # ✅
```

### Pengecualian: `[ -z $var ]` vs `[ -z "$var" ]`

```sh
var=""
[ -z $var ]     # ✅ bekerja (word splitting menghasilkan nol argumen)
[ -z "$var" ]   # ✅ bekerja (satu argumen kosong)
```

Keduanya bekerja untuk `-z`. Tapi `[ -z "$var" ]` lebih aman karena tidak bergantung pada word splitting.

---

## 2.2.6 Operator `&&` dan `||`

Selain di dalam `[ ]`, Anda bisa menggabungkan kondisi dengan `&&` dan `||` di level perintah.

### `&&` — AND

```sh
[ -f "$file" ] && [ -r "$file" ] && echo "File ada dan bisa dibaca"
```

Penjelasan:

- `&&` – Perintah berikutnya hanya dijalankan jika perintah sebelumnya **sukses** (exit 0).
- Rantai berhenti pada kegagalan pertama.
- Jika `[ -f "$file" ]` gagal, perintah berikutnya tidak dijalankan.

### `||` — OR

```sh
[ -f "$file" ] || echo "File tidak ada"
```

Penjelasan:

- `||` – Perintah berikutnya hanya dijalankan jika perintah sebelumnya **gagal** (exit non-zero).
- Rantai berhenti pada kesuksesan pertama.

### Kombinasi `&&` dan `||`

```sh
[ -f "$file" ] && echo "Ada" || echo "Tidak ada"
```

Penjelasan:

- Jika `[ -f "$file" ]` sukses, jalankan `echo "Ada"`.
- Jika `[ -f "$file" ]` gagal, jalankan `echo "Tidak ada"`.
- Ini adalah pola **ternary** di shell.

**Jebakan:** Jika `echo "Ada"` gagal (misalnya karena stdout ditutup), maka `echo "Tidak ada"` juga akan dijalankan. Ini jarang terjadi, tetapi perlu diingat.

### Di Dalam `if`

```sh
if [ -f "$file" ] && [ -r "$file" ]; then
    echo "File ada dan bisa dibaca."
fi
```

Ini lebih jelas daripada rantai `&&` di luar `if`.

### Prioritas

`&&` dan `||` memiliki prioritas sama dan dievaluasi dari kiri ke kanan.

```sh
A && B || C
```

Dievaluasi sebagai `(A && B) || C`.

Jika Anda ingin `A && (B || C)`:

```sh
A && { B || C; }
```

Penjelasan:

- `{ ...; }` – **Command group**. Menjalankan perintah dalam konteks shell saat ini (bukan subshell).
- Butuh `;` sebelum `}` dan spasi setelah `{`.
- Alternatif: `( B || C )` untuk subshell.

---

## 2.2.7 `case` — Percabangan Multi-Opsi

`case` adalah struktur untuk mencocokkan sebuah nilai dengan beberapa pola.

### Sintaks

```sh
case "$variabel" in
    pola1)
        perintah1
        ;;
    pola2)
        perintah2
        ;;
    *)
        default
        ;;
esac
```

Penjelasan kata demi kata:

- `case` – Kata kunci awal.
- `"$variabel"` – Nilai yang akan dicocokkan. Biasanya dikutip.
- `in` – Kata kunci yang memisahkan nilai dari pola.
- `pola1)` – Pola yang diakhiri `)`. Bisa berisi wildcard.
- `;;` – **Double semicolon**. Menandai akhir blok untuk pola tersebut. Mirip `break` di C.
- `*)` – Pola default. `*` cocok dengan apa pun.
- `esac` – Penutup. `esac` adalah `case` terbalik.

### Contoh Sederhana

```sh
#!/bin/sh

case "$1" in
    start)
        echo "Memulai layanan..."
        ;;
    stop)
        echo "Menghentikan layanan..."
        ;;
    restart)
        echo "Merestart layanan..."
        ;;
    *)
        echo "Penggunaan: $0 {start|stop|restart}"
        exit 1
        ;;
esac
```

Penjelasan:

- `case "$1" in` – Cocokkan argumen pertama.
- `start)` – Jika `$1` sama dengan `start`.
- `;;` – Akhiri blok.
- `*)` – Default untuk semua nilai lain.
- `exit 1` – Keluar dengan error.

### Pola Wildcard

```sh
case "$file" in
    *.txt)
        echo "File teks"
        ;;
    *.jpg|*.png|*.gif)
        echo "File gambar"
        ;;
    *.sh)
        echo "Skrip shell"
        ;;
    *)
        echo "Tipe tidak dikenal"
        ;;
esac
```

Penjelasan:

- `*.txt` – Cocok dengan nama file berakhiran `.txt`.
- `*.jpg|*.png|*.gif` – Tanda `|` memisahkan beberapa pola. Cocok jika salah satu cocok.
- `*.sh` – Akhiran `.sh`.

### Pola dengan Karakter Khusus

```sh
case "$1" in
    [Yy]|[Yy][Ee][Ss])
        echo "Ya"
        ;;
    [Nn]|[Nn][Oo])
        echo "Tidak"
        ;;
esac
```

Penjelasan:

- `[Yy]` – Cocok dengan `Y` atau `y`.
- `[Yy][Ee][Ss]` – Cocok dengan `Yes`, `YES`, `yes`, `yEs`, dll.
- `|` – Alternasi.

### `;;` — Berhenti

Setiap blok diakhiri `;;`. Ini **wajib** (kecuali blok terakhir sebelum `esac` di beberapa shell).

### `;&` dan `;;&` — Tidak POSIX

Bash mendukung `;&` (fall through) dan `;;&` (continue matching). **Tidak POSIX.** Jangan gunakan di skrip portabel.

### `case` dengan Beberapa Perintah

```sh
case "$1" in
    start)
        echo "Memulai..."
        start_service
        log "Layanan dimulai"
        ;;
    stop)
        echo "Menghentikan..."
        stop_service
        log "Layanan dihentikan"
        ;;
esac
```

Setiap blok bisa berisi berapa pun perintah.

### `case` vs `if`

Kapan gunakan `case`?

- Ketika ada banyak nilai diskrit yang mungkin.
- Ketika pola melibatkan wildcard.
- Ketika kode lebih mudah dibaca dengan `case`.

Kapan gunakan `if`?

- Ketika kondisinya bukan sekadar pencocokan nilai (misalnya cek file, cek exit status).
- Ketika hanya ada satu atau dua cabang.

### Contoh: Parsing Argumen dengan `case`

```sh
#!/bin/sh

while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            echo "Penggunaan: $0 [-v] [-o file]"
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=1
            shift
            ;;
        -o|--output)
            OUTPUT="$2"
            shift 2
            ;;
        -*)
            echo "Opsi tidak dikenal: $1" >&2
            exit 1
            ;;
        *)
            ARGS="$ARGS $1"
            shift
            ;;
    esac
done
```

Penjelasan:

- `while [ $# -gt 0 ]` – Loop selama masih ada argumen.
- `case "$1"` – Cocokkan argumen pertama.
- `-h|--help` – Jika argumen adalah `-h` atau `--help`.
- `-v|--verbose` – Set `VERBOSE=1`, lalu `shift` untuk membuang argumen ini.
- `-o|--output` – Ambil argumen berikutnya (`$2`), lalu `shift 2` untuk membuang dua argumen.
- `-*` – Pola untuk semua opsi yang tidak dikenal.
- `*)` – Argumen non-opsi. Tambahkan ke `ARGS`.

Ini adalah pola parsing argumen manual yang portabel. Di Level 4 kita akan bahas `getopts` yang lebih canggih.

---

## 2.2.8 Jebakan Klasik

### Jebakan 1: `[ $var = "x" ]` Tanpa Kutip

Sudah dibahas. Selalu kutip: `[ "$var" = "x" ]`.

### Jebakan 2: `[ $var -eq 0 ]` dengan Variabel Kosong

```sh
var=""
[ $var -eq 0 ]
```

Penjelasan:

- `$var` kosong, word splitting menghasilkan nol argumen.
- `[` menerima `-eq`, `0`, `]` — ini hanya 3 argumen, `test` menganggapnya sebagai operator unary `-eq`? Tidak, `-eq` bukan unary.
- Error: `[: -eq: unexpected operator`.

Yang benar:

```sh
[ "$var" -eq 0 ]
```

Tapi bahkan ini bisa error jika `$var` bukan angka:

```sh
var="abc"
[ "$var" -eq 0 ]    # Error: integer expression expected
```

Untuk aman, validasi dulu bahwa `$var` adalah angka.

### Jebakan 3: `=` vs `==`

POSIX hanya mendefinisikan `=` untuk perbandingan string dalam `test`. `==` adalah ekstensi bash. Gunakan `=`.

```sh
[ "$a" = "$b" ]     # ✅ POSIX
[ "$a" == "$b" ]    # ❌ Tidak POSIX
```

### Jebakan 4: `-eq` untuk String

```sh
[ "$a" -eq "$b" ]
```

`-eq` hanya untuk integer. Jika `$a` atau `$b` bukan angka, error. Gunakan `=` untuk string.

### Jebakan 5: `if [ ... ]` vs `if [[ ... ]]`

`[[ ]]` tidak POSIX. Jangan gunakan di skrip portabel.

### Jebakan 6: `test` dengan `!` dan Banyak Argumen

```sh
[ ! -f "$file" -a -r "$file" ]
```

Prioritas ambigu. Gunakan:

```sh
[ ! -f "$file" ] && [ -r "$file" ]
```

### Jebakan 7: `case` Tanpa `;;`

Lupa `;;` bisa menyebabkan sintaks error.

### Jebakan 8: `case` dengan `esac` Hilang

`esac` wajib. Lupa `esac` → error.

### Jebakan 9: `[ "$a" < "$b" ]`

`<` dan `>` dalam `[ ]` dianggap sebagai redirection oleh shell, bukan operator perbandingan. Gunakan `case` atau `expr`.

```sh
# Salah
[ "$a" < "$b" ]    # shell menganggap < sebagai redirection

# Benar (POSIX)
case "$a" in
    "$b"|"${b}"*) ;;   # a == b atau a > b (kurang akurat)
esac

# Lebih baik gunakan sort atau awk
```

### Jebakan 10: `if [ -e "$file" ]`

`-e` tidak POSIX. Gunakan `-f` atau `-d`, atau cek dengan `-r`/`-w`.

---

## 2.2.9 Contoh Skrip Lengkap

### Skrip 1: Cek File

```sh
#!/bin/sh
# Nama: cekfile.sh
# Tujuan: Memeriksa status file

file="${1:?Penggunaan: $0 file}"

if [ ! -e "$file" ]; then
    echo "File '$file' tidak ada." >&2
    exit 1
fi

if [ -d "$file" ]; then
    echo "'$file' adalah direktori."
elif [ -f "$file" ]; then
    echo "'$file' adalah file biasa."
    if [ -r "$file" ]; then
        echo "  - Dapat dibaca"
    fi
    if [ -w "$file" ]; then
        echo "  - Dapat ditulis"
    fi
    if [ -x "$file" ]; then
        echo "  - Dapat dieksekusi"
    fi
else
    echo "'$file' adalah tipe file lain."
fi
```

Bedah:

- `:?` – Ekspansi parameter untuk validasi argumen.
- `-d`, `-f`, `-r`, `-w`, `-x` – Operator file POSIX.
- `>&2` – Redirection ke stderr.

### Skrip 2: Menu Interaktif

```sh
#!/bin/sh
# Nama: menu.sh
# Tujuan: Menu sederhana dengan case

echo "1. Tampilkan tanggal"
echo "2. Tampilkan pengguna"
echo "3. Keluar"
printf "Pilih [1-3]: "
read pilihan

case "$pilihan" in
    1)
        date
        ;;
    2)
        whoami
        ;;
    3)
        echo "Selamat tinggal."
        exit 0
        ;;
    *)
        echo "Pilihan tidak valid." >&2
        exit 1
        ;;
esac
```

Bedah:

- `printf` – Lebih portabel daripada `echo -n`. `printf "Pilih: "` mencetak tanpa newline.
- `read pilihan` – Membaca input pengguna.
- `case` – Percabangan.

### Skrip 3: Validasi Angka

```sh
#!/bin/sh
# Nama: validasi_angka.sh
# Tujuan: Memvalidasi bahwa argumen adalah angka

if [ $# -ne 1 ]; then
    echo "Penggunaan: $0 angka" >&2
    exit 1
fi

case "$1" in
    ''|*[!0-9]*)
        echo "'$1' bukan angka non-negatif." >&2
        exit 1
        ;;
esac

echo "'$1' adalah angka yang valid."
```

Bedah:

- `$# -ne 1` – Jumlah argumen tidak sama dengan 1.
- `case "$1"`:
  - `''` – String kosong.
  - `*[!0-9]*` – Mengandung karakter selain 0-9. `[!0-9]` adalah negasi dari karakter digit.
  - Pola ini menangkap semua yang bukan angka murni.
- Jika tidak cocok dengan pola di atas, berarti angka valid.

Ini adalah cara **portabel** untuk validasi angka tanpa regex.

---

## 2.2.10 Latihan

1. **`if` Dasar:**
   - Tulis skrip yang menerima satu nama file sebagai argumen.
   - Cek apakah file ada dan merupakan file biasa.
   - Cetak pesan sesuai.

2. **`elif`:**
   - Tulis skrip yang menerima angka sebagai argumen.
   - Cetak "negatif", "nol", atau "positif" menggunakan `if`/`elif`/`else`.
   - Validasi bahwa argumen adalah angka.

3. **`case`:**
   - Tulis skrip yang menerima ekstensi file (misalnya `txt`, `jpg`).
   - Cetak kategori: "teks", "gambar", "video", atau "tidak dikenal".
   - Gunakan `case` dengan beberapa pola.

4. **`test` Operator:**
   - Tulis skrip yang memeriksa apakah `/tmp` adalah direktori yang dapat ditulis.
   - Gunakan `[ -d ]` dan `[ -w ]`.
   - Cetak pesan yang sesuai.

5. **Kutip:**
   - Buat variabel `x=""`.
   - Coba `[ $x = "a" ]`. Apa errornya?
   - Coba `[ "$x" = "a" ]`. Apakah error?
   - Jelaskan perbedaannya.

6. **Boolean:**
   - Tulis skrip yang memeriksa apakah sebuah file ada **dan** dapat dibaca.
   - Gunakan `&&` di luar `[ ]`.
   - Tulis juga versi yang menggunakan `if` bertingkat.

7. **Parsing Argumen:**
   - Tulis skrip yang menerima opsi `-v` (verbose) dan `-f FILE`.
   - Gunakan `while` dan `case`.
   - Jika `-v` diberikan, cetak pesan tambahan.

8. **Error Handling:**
   - Tulis skrip yang mencoba membaca file dari argumen.
   - Jika file tidak ada, cetak error ke stderr dan `exit 1`.
   - Jika ada, cetak 5 baris pertama dengan `head`.

---

## 2.2.11 Ringkasan Materi 2

- `if` mengevaluasi **exit status**, bukan boolean.
- Struktur: `if kondisi; then ... elif ... else ... fi`.
- `test` dan `[ ]` adalah perintah, bukan sintaks. Butuh spasi.
- Operator file: `-f`, `-d`, `-r`, `-w`, `-x`, `-s`, dll.
- Operator string: `=`, `!=`, `-z`, `-n`.
- Operator numerik: `-eq`, `-ne`, `-gt`, `-ge`, `-lt`, `-le`.
- **Selalu kutip** variabel dalam `[ ]`: `[ "$var" = "x" ]`.
- Hindari `-a` dan `-o` di dalam `[ ]`; gunakan `&&` dan `||` di luar.
- `case` untuk percabangan multi-opsi dengan pola wildcard.
- Jebakan: `==` tidak POSIX, `-e` tidak POSIX, `<`/`>` bukan perbandingan di `[ ]`.
- Validasi angka portabel dengan `case "$1" in ''|*[!0-9]*) ...`.

---

## 📌 Selanjutnya

Materi 2 Level 2 selesai. Anda sekarang menguasai kondisional secara mendalam.

Berikutnya adalah **Materi 3: Loop (`for`, `while`, `until`)** — kita akan membahas:

- `for` loop dengan daftar, glob, dan `"$@"`.
- `while` dan `until` untuk kondisi dinamis.
- `break` dan `continue`.
- Membaca file baris per baris dengan `read`.
- Loop dengan counter dan aritmatika.
- Jebakan loop: subshell, IFS, dan performa.

## Materi 3: Loop (`for`, `while`, `until`)

> **Catatan:** Ini adalah **materi ketiga** dari Level 2. Loop adalah jantung dari otomatisasi. Kita akan membedah setiap jenis loop, setiap kata kunci, dan setiap jebakan yang bisa membuat skrip Anda hang, lambat, atau salah. Setelah materi ini, Anda akan mampu memproses ribuan file, baris, dan argumen dengan aman dan efisien.

---

## 🎯 Tujuan Materi 3

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Menulis `for` loop dengan daftar eksplisit, glob, `"$@"`, dan command substitution.
2. Menulis `while` dan `until` untuk kondisi dinamis.
3. Menggunakan `break` dan `continue` dengan tepat, termasuk dengan level.
4. Membaca file **baris per baris** dengan aman menggunakan `read`.
5. Menggunakan loop dengan counter dan aritmatika.
6. Menghindari jebakan **subshell** yang membuat variabel "hilang".
7. Memahami performa loop dan kapan harus menggunakan `xargs` atau `find -exec`.
8. Menulis loop yang aman terhadap nama file dengan spasi, newline, dan karakter khusus.

---

## 2.3.1 Filosofi Loop di Shell

Loop di shell berbeda dari loop di bahasa pemrograman lain. Di shell:

1. Loop memproses **daftar kata** (word list), bukan indeks numerik.
2. Loop dijalankan di **proses shell yang sama** (kecuali jika di-pipe atau di-subshell).
3. Loop bisa memproses **output perintah** dengan mudah melalui command substitution atau pipe.
4. Loop sangat cocok untuk **batch processing** — memproses banyak file, baris, atau argumen.

Tiga jenis loop POSIX:

- `for` – iterasi atas daftar kata.
- `while` – iterasi selama kondisi sukses.
- `until` – iterasi sampai kondisi sukses (kebalikan `while`).

---

## 2.3.2 `for` Loop — Iterasi atas Daftar

### Sintaks Dasar

```sh
for variabel in daftar; do
    perintah
done
```

Penjelasan kata demi kata:

- `for` – Kata kunci awal loop.
- `variabel` – Nama variabel yang akan menampung setiap item. Tidak perlu `$` di sini.
- `in` – Kata kunci yang memisahkan variabel dari daftar.
- `daftar` – Daftar kata yang akan diiterasi. Bisa berupa literal, glob, variabel, atau command substitution.
- `;` – Pemisah. Mengizinkan `do` di baris yang sama.
- `do` – Kata kunci yang menandai awal blok loop.
- `perintah` – Perintah yang dijalankan setiap iterasi.
- `done` – Kata kunci penutup.

### Format Alternatif

```sh
for variabel in daftar
do
    perintah
done
```

`do` di baris terpisah. Sama validnya.

### Contoh 1: Daftar Literal

```sh
for buah in apel jeruk mangga; do
    echo "Buah: $buah"
done
```

Output:

```
Buah: apel
Buah: jeruk
Buah: mangga
```

Penjelasan:

- `apel jeruk mangga` – Daftar kata literal. Shell memecahnya berdasarkan IFS (spasi).
- Setiap iterasi, `buah` di-set ke salah satu nilai.
- `$buah` diekspansi dalam loop.

### Contoh 2: Daftar dengan Kutip

```sh
for nama in "Budi Santoso" "Ani Rahayu" "Citra Dewi"; do
    echo "Nama: $nama"
done
```

Output:

```
Nama: Budi Santoso
Nama: Ani Rahayu
Nama: Citra Dewi
```

Penjelasan:

- Kutip ganda melindungi spasi, sehingga setiap nama dianggap satu item.
- Tanpa kutip, setiap kata akan menjadi item terpisah.

### Contoh 3: Glob

```sh
for file in *.txt; do
    echo "Memproses: $file"
done
```

Penjelasan:

- `*.txt` – Globbing. Shell mengekspansi menjadi daftar file yang cocok.
- Setiap file menjadi satu item.
- **Jika tidak ada file yang cocok**, `*.txt` tetap literal. Loop akan berjalan sekali dengan `file="*.txt"`. Ini jebakan.

Untuk mengatasi, gunakan:

```sh
for file in *.txt; do
    [ -f "$file" ] || continue
    echo "Memproses: $file"
done
```

Penjelasan:

- `[ -f "$file" ]` – Cek apakah `$file` adalah file biasa.
- `|| continue` – Jika bukan, lanjut ke iterasi berikutnya.
- Jika `*.txt` tidak cocok, `$file="*.txt"`, `[ -f "*.txt" ]` gagal, `continue` dijalankan.

### Contoh 4: Argumen Skrip

```sh
for arg in "$@"; do
    echo "Argumen: $arg"
done
```

Penjelasan:

- `"$@"` – Ekspansi semua argumen sebagai daftar terpisah.
- Setiap argumen dianggap utuh, termasuk yang mengandung spasi.
- **Ini adalah cara benar** untuk memproses argumen skrip.

Bandingkan dengan `"$*"`:

```sh
for arg in "$*"; do
    echo "Argumen: $arg"
done
```

Output hanya **satu iterasi** dengan semua argumen digabung. Hampir selalu salah.

### Contoh 5: Command Substitution

```sh
for user in $(cut -d: -f1 /etc/passwd); do
    echo "User: $user"
done
```

Penjelasan:

- `$(cut -d: -f1 /etc/passwd)` – Menjalankan `cut`, menangkap output.
- `cut -d: -f1` – Memotong berdasarkan delimiter `:` dan mengambil field pertama (username).
- Output dipecah oleh IFS (spasi, tab, newline).
- Setiap username menjadi satu item.

**Jebakan:** Jika username mengandung spasi (jarang), akan terpecah. Untuk username, aman. Untuk data umum, hati-hati.

### Contoh 6: Range Angka

POSIX tidak memiliki `for i in {1..10}`. Itu bashism. Gunakan `seq` atau `while`.

```sh
for i in $(seq 1 10); do
    echo "Iterasi: $i"
done
```

Penjelasan:

- `seq 1 10` – Mencetak angka 1 hingga 10, satu per baris.
- `$(...)` – Menangkap output, dipecah berdasarkan IFS (newline dan spasi).
- Setiap angka menjadi item.
- `seq` **tidak POSIX**? Sebenarnya `seq` bukan POSIX. POSIX tidak mendefinisikan `seq`. Alternatif portabel:

```sh
i=1
while [ "$i" -le 10 ]; do
    echo "Iterasi: $i"
    i=$((i + 1))
done
```

Ini **benar-benar portabel**.

### Contoh 7: Tanpa `in`

```sh
for arg; do
    echo "Argumen: $arg"
done
```

Penjelasan:

- `for arg` tanpa `in daftar` – Secara implisit berarti `for arg in "$@"`.
- Ini POSIX dan merupakan cara ringkas untuk memproses semua argumen.

### Contoh 8: Loop Bersarang

```sh
for i in 1 2 3; do
    for j in a b c; do
        echo "$i$j"
    done
done
```

Output:

```
1a
1b
1c
2a
2b
2c
3a
3b
3c
```

Penjelasan:

- Loop luar iterasi 3 kali, loop dalam 3 kali, total 9 iterasi.
- Setiap kombinasi dihasilkan.

### `for` Tanpa Iterasi

```sh
for x in; do
    echo "Tidak akan pernah tercetak"
done
echo "Selesai"
```

Penjelasan:

- `in` diikuti daftar kosong. Loop tidak dijalankan sama sekali.
- Berguna untuk skip loop jika daftar kosong.

---

## 2.3.3 `while` Loop — Iterasi Selama Kondisi Sukses

### Sintaks Dasar

```sh
while kondisi; do
    perintah
done
```

Penjelasan:

- `while` – Kata kunci.
- `kondisi` – Perintah yang dievaluasi setiap iterasi. Jika exit status `0` (sukses), blok dijalankan.
- `do` – Awal blok.
- `done` – Akhir blok.

### Contoh 1: Counter Sederhana

```sh
i=1
while [ "$i" -le 5 ]; do
    echo "Iterasi: $i"
    i=$((i + 1))
done
```

Output:

```
Iterasi: 1
Iterasi: 2
Iterasi: 3
Iterasi: 4
Iterasi: 5
```

Penjelasan:

- `i=1` – Inisialisasi counter.
- `[ "$i" -le 5 ]` – Cek apakah `i` kurang dari atau sama dengan 5.
- `i=$((i + 1))` – Aritmatika. Menambah 1 ke `i`.
- Loop berhenti ketika `i=6`, karena `[ 6 -le 5 ]` gagal.

### Contoh 2: Loop Tak Terbatas

```sh
while true; do
    echo "Menunggu..."
    sleep 5
done
```

Penjelasan:

- `true` – Perintah POSIX yang selalu mengembalikan exit status `0`.
- Loop berjalan selamanya sampai dihentikan dengan `Ctrl+C` atau `break`.

Alternatif:

```sh
while :; do
    echo "Menunggu..."
    sleep 5
done
```

Penjelasan:

- `:` – Perintah no-op, sama seperti `true`.
- Lebih ringkas dan sering digunakan.

### Contoh 3: Membaca File Baris per Baris

```sh
while IFS= read -r line; do
    echo "Baris: $line"
done < "$file"
```

Penjelasan kata demi kata:

- `while IFS= read -r line; do` – 
  - `IFS=` – Set IFS ke string kosong **hanya untuk perintah `read`**. Ini mencegah `read` memangkas spasi di awal/akhir baris.
  - `read` – Perintah POSIX untuk membaca satu baris dari stdin.
  - `-r` – **Raw mode**. Mencegah backslash `\` dianggap sebagai karakter escape. Tanpa `-r`, `\n` di input akan diinterpretasikan.
  - `line` – Nama variabel untuk menampung baris.
- `done < "$file"` – 
  - `< "$file"` – Redirection. Mengarahkan stdin loop dari file.
  - **Penting:** Redirection harus di `done`, bukan di dalam loop.

**Ini adalah pola membaca file yang paling aman dan portabel.**

### Contoh 4: Membaca dari Pipe

```sh
cat "$file" | while IFS= read -r line; do
    echo "Baris: $line"
done
```

Penjelasan:

- `cat "$file" | while ...` – Output `cat` dialirkan ke `while`.
- **Jebakan subshell:** Bagian `while` berjalan di **subshell**, karena pipeline membuat subshell. Variabel yang diubah di dalam loop **tidak akan bertahan** setelah loop selesai.

Contoh:

```sh
count=0
cat "$file" | while IFS= read -r line; do
    count=$((count + 1))
done
echo "Jumlah baris: $count"
```

Output:

```
Jumlah baris: 0
```

Penjelasan:

- `count` di dalam loop di-set, tetapi karena loop berjalan di subshell, `count` di shell induk tetap `0`.
- Solusi: gunakan redirection `<` alih-alih pipe, atau gunakan command substitution.

**Versi benar dengan redirection:**

```sh
count=0
while IFS= read -r line; do
    count=$((count + 1))
done < "$file"
echo "Jumlah baris: $count"
```

Output benar: jumlah baris sebenarnya.

### Contoh 5: Loop dengan Perintah sebagai Kondisi

```sh
while grep -q "ERROR" /var/log/syslog; do
    echo "Ada error!"
    sleep 60
done
```

Penjelasan:

- `grep -q "ERROR" /var/log/syslog` – Cek apakah ada "ERROR". Exit status `0` jika ada.
- Selama ada, loop berjalan.
- `sleep 60` – Tunggu 60 detik sebelum cek lagi.

### Contoh 6: `while` dengan `read` dan Argumen

```sh
echo "Masukkan nama (kosong untuk keluar):"
while read -r nama && [ -n "$nama" ]; do
    echo "Halo, $nama"
done
```

Penjelasan:

- `read -r nama` – Membaca dari stdin. Exit status `0` jika berhasil, non-zero jika EOF.
- `&& [ -n "$nama" ]` – Lanjut hanya jika ada input dan tidak kosong.
- Loop berhenti ketika pengguna memasukkan string kosong (menekan Enter) atau EOF (Ctrl+D).

---

## 2.3.4 `until` Loop — Iterasi Sampai Kondisi Sukses

`until` adalah **kebalikan** dari `while`. Loop berjalan selama kondisi **gagal**, dan berhenti ketika kondisi **sukses**.

### Sintaks

```sh
until kondisi; do
    perintah
done
```

### Contoh

```sh
i=1
until [ "$i" -gt 5 ]; do
    echo "Iterasi: $i"
    i=$((i + 1))
done
```

Output:

```
Iterasi: 1
Iterasi: 2
Iterasi: 3
Iterasi: 4
Iterasi: 5
```

Penjelasan:

- `until [ "$i" -gt 5 ]` – Loop berjalan sampai `i` lebih besar dari 5.
- Setara dengan `while [ "$i" -le 5 ]`.

### Kapan Menggunakan `until`?

`until` berguna ketika lebih alami untuk menyatakan "sampai kondisi X tercapai". Contoh:

```sh
until ping -c1 example.com >/dev/null 2>&1; do
    echo "Menunggu koneksi..."
    sleep 5
done
echo "Terhubung!"
```

Penjelasan:

- `ping -c1` – Ping satu kali.
- `>/dev/null 2>&1` – Buang stdout dan stderr.
- Loop berjalan sampai ping berhasil.
- Lebih alami dibaca daripada `while ! ping ...`.

---

## 2.3.5 `break` dan `continue`

### `break` — Keluar dari Loop

```sh
for i in 1 2 3 4 5; do
    if [ "$i" -eq 3 ]; then
        break
    fi
    echo "Iterasi: $i"
done
```

Output:

```
Iterasi: 1
Iterasi: 2
```

Penjelasan:

- `break` – Keluar dari loop sepenuhnya.
- Ketika `i=3`, `break` dijalankan, loop berhenti.
- Sisa iterasi (4, 5) tidak dijalankan.

### `break N` — Keluar dari N Level

```sh
for i in 1 2 3; do
    for j in a b c; do
        if [ "$i$j" = "2b" ]; then
            break 2
        fi
        echo "$i$j"
    done
done
```

Output:

```
1a
1b
1c
2a
```

Penjelasan:

- `break 2` – Keluar dari dua level loop sekaligus (loop dalam dan loop luar).
- Ketika `i=2, j=b`, `break 2` dijalankan.
- Loop langsung berhenti total.
- `break N` **tidak POSIX**? Sebenarnya POSIX mendefinisikan `break` tanpa argumen. Argumen `N` adalah ekstensi. Untuk portabilitas maksimal, hindari `break N`.

### `continue` — Lanjut ke Iterasi Berikutnya

```sh
for i in 1 2 3 4 5; do
    if [ "$i" -eq 3 ]; then
        continue
    fi
    echo "Iterasi: $i"
done
```

Output:

```
Iterasi: 1
Iterasi: 2
Iterasi: 4
Iterasi: 5
```

Penjelasan:

- `continue` – Lewati sisa perintah di iterasi saat ini, lanjut ke iterasi berikutnya.
- Ketika `i=3`, `continue` dijalankan, `echo` dilewati.

### `continue N` — Lanjut ke Iterasi Loop Luar

Sama seperti `break N`, ini ekstensi. Hindari untuk portabilitas.

### Contoh Praktis: Lewati File yang Tidak Bisa Dibaca

```sh
for file in *.txt; do
    [ -r "$file" ] || continue
    echo "Memproses: $file"
    # ...
done
```

Penjelasan:

- `[ -r "$file" ]` – Cek apakah file bisa dibaca.
- `|| continue` – Jika tidak bisa dibaca, lanjut ke file berikutnya.

Ini adalah pola yang sangat umum dan bersih.

### `break` vs `continue`

| Aspek | `break` | `continue` |
|-------|---------|------------|
| Efek | Keluar dari loop | Lanjut ke iterasi berikutnya |
| Sisa iterasi | Tidak dijalankan | Dijalankan (kecuali kondisi lain) |
| Penggunaan | Ketika kondisi akhir tercapai | Lewati item tertentu |

---

## 2.3.6 Aritmatika dalam Loop

POSIX mendefinisikan **arithmetic expansion** dengan `$(( ))`.

### Sintaks

```sh
hasil=$((ekspresi))
```

Penjelasan:

- `$((` dan `))` – Delimiter ekspansi aritmatika.
- `ekspresi` – Ekspresi aritmatika integer.
- Operator yang didukung: `+`, `-`, `*`, `/`, `%`, `**` (power, tidak POSIX), `<<`, `>>`, `&`, `|`, `^`, `~`, `!`, `&&`, `||`, `? :`, perbandingan, dan assignment.

### Contoh

```sh
i=5
i=$((i + 1))
echo "$i"    # 6

j=$((i * 2))
echo "$j"    # 12

k=$((i > j ? i : j))
echo "$k"    # 12
```

### Counter dalam Loop

```sh
count=0
for file in *.txt; do
    count=$((count + 1))
done
echo "Total file: $count"
```

Penjelasan:

- `count=0` – Inisialisasi.
- `count=$((count + 1))` – Increment.
- **Perhatikan:** loop ini berjalan di shell yang sama, bukan subshell, jadi `count` bertahan.

### Operator Aritmatika Lengkap

| Operator | Arti |
|----------|------|
| `+` | Penjumlahan |
| `-` | Pengurangan |
| `*` | Perkalian |
| `/` | Pembagian integer |
| `%` | Modulo (sisa bagi) |
| `=` | Assignment |
| `+=`, `-=` | Assignment dengan operasi |
| `==`, `!=` | Perbandingan |
| `<`, `<=`, `>`, `>=` | Perbandingan |
| `&&`, `||` | Logika |
| `!` | Negasi |
| `? :` | Ternary |

### Floating-Point

POSIX aritmatika hanya integer. Untuk floating-point, gunakan `awk` atau `bc`:

```sh
hasil=$(echo "3.14 * 2" | bc)
echo "$hasil"    # 6.28
```

```sh
hasil=$(awk "BEGIN { print 3.14 * 2 }")
echo "$hasil"    # 6.28
```

`awk` lebih portabel daripada `bc` di sistem modern.

---

## 2.3.7 Jebakan Subshell dalam Loop

Ini adalah **jebakan paling berbahaya** dalam loop shell. Wajib dipahami.

### Masalah

```sh
count=0
cat file.txt | while read -r line; do
    count=$((count + 1))
done
echo "Jumlah: $count"
```

Output:

```
Jumlah: 0
```

**Mengapa?** Karena pipeline `cat file.txt | while ...` membuat **subshell** untuk sisi kanan pipeline. Variabel `count` diubah di subshell, bukan di shell induk.

### Solusi 1: Redirection

```sh
count=0
while read -r line; do
    count=$((count + 1))
done < file.txt
echo "Jumlah: $count"
```

Penjelasan:

- `< file.txt` – Redirection di `done`, bukan pipe.
- Loop berjalan di shell saat ini, bukan subshell.
- `count` bertahan.

### Solusi 2: Command Group

```sh
count=0
{
    while read -r line; do
        count=$((count + 1))
    done
} < file.txt
echo "Jumlah: $count"
```

Penjelasan:

- `{ ... }` – Command group. Dijalankan di shell saat ini.
- Redirection di `}`.

### Solusi 3: Command Substitution

```sh
count=$(grep -c "" file.txt)
echo "Jumlah: $count"
```

Penjelasan:

- `grep -c ""` – Menghitung semua baris (pola kosong cocok dengan semua).
- Output ditangkap oleh `$(...)`.

### Solusi 4: Proses di Subshel, Output ke Stdout

```sh
count=$(cat file.txt | while read -r line; do
    echo "x"
done | wc -l)
echo "Jumlah: $count"
```

Ini bekerja tetapi rumit. Lebih baik gunakan redirection.

### Kapan Subshell Tidak Masalah?

Subshell hanya masalah jika Anda perlu **mempertahankan perubahan variabel** setelah loop. Jika loop hanya untuk efek samping (mencetak, memodifikasi file), subshell tidak masalah.

---

## 2.3.8 Jebakan `read`

### Jebakan 1: IFS Memangkas Spasi

```sh
echo "   spasi di depan" | while read line; do
    echo "[$line]"
done
```

Output:

```
[spasi di depan]
```

Spasi di depan hilang karena IFS default memangkasnya.

**Solusi:** `IFS= read -r line`

```sh
echo "   spasi di depan" | while IFS= read -r line; do
    echo "[$line]"
done
```

Output:

```
[   spasi di depan]
```

### Jebakan 2: Backslash

```sh
echo "path\with\backslash" | while read line; do
    echo "$line"
done
```

Output (tanpa `-r`):

```
pathwithbackslash
```

Backslash menghilang karena `read` menginterpretasikannya sebagai escape.

**Solusi:** Selalu gunakan `read -r`.

### Jebakan 3: `read` dari Terminal di Dalam Loop

```sh
for file in *.txt; do
    echo "File: $file"
    read -r jawaban
done < daftar.txt
```

Penjelasan:

- Loop membaca dari `daftar.txt`, bukan dari terminal.
- `read -r jawaban` juga membaca dari `daftar.txt`, bukan dari keyboard.
- Ini menyebabkan perilaku aneh.

**Solusi:** Baca dari `/dev/tty` untuk input pengguna:

```sh
read -r jawaban < /dev/tty
```

### Jebakan 4: Baris Terakhir Tanpa Newline

Jika file tidak diakhiri newline, `read` mungkin tidak membaca baris terakhir.

**Solusi:** Gunakan:

```sh
while IFS= read -r line || [ -n "$line" ]; do
    echo "$line"
done < file.txt
```

Penjelasan:

- `|| [ -n "$line" ]` – Jika `read` gagal (EOF) tetapi `$line` tidak kosong, tetap proses.

---

## 2.3.9 Jebakan Nama File dengan Spasi

Ini adalah topik kritis. Nama file di Unix bisa mengandung spasi, tab, newline, dan karakter aneh lainnya.

### Pola yang Salah

```sh
for file in $(ls); do
    echo "$file"
done
```

**Masalah:** `$(ls)` menghasilkan daftar yang dipecah oleh IFS. File dengan spasi akan terpecah.

### Pola yang Benar

```sh
for file in *; do
    echo "$file"
done
```

Penjelasan:

- `*` – Globbing. Shell mengekspansi menjadi daftar file, masing-masing utuh.
- Setiap file dianggap satu item, termasuk yang mengandung spasi.

### Pola yang Benar dengan `find`

```sh
find . -type f | while IFS= read -r file; do
    echo "$file"
done
```

Penjelasan:

- `find` mencetak satu path per baris.
- `IFS= read -r file` membaca seluruh baris, termasuk spasi.
- **Namun**, jika nama file mengandung newline (jarang tapi mungkin), ini tetap rusak.

### Pola Aman dengan `find -exec`

```sh
find . -type f -exec sh -c '
    for file; do
        echo "File: $file"
    done
' sh {} +
```

Penjelasan:

- `-exec sh -c '...' sh {} +` – Menjalankan shell dengan semua file sebagai argumen.
- `for file; do` – Iterasi `"$@"` secara implisit.
- Setiap file utuh, termasuk yang mengandung newline.
- Ini adalah cara **paling aman** untuk memproses file dari `find`.

### Pola dengan Newline di Nama File

Jika Anda benar-benar perlu menangani newline di nama file, gunakan `find -print0` dan `xargs -0`:

```sh
find . -type f -print0 | xargs -0 -I {} echo "File: {}"
```

Penjelasan:

- `-print0` – Cetak path diakhiri NUL (`\0`), bukan newline.
- `xargs -0` – Baca input dipisahkan NUL.
- `-I {}` – Ganti `{}` dengan setiap path.
- `-print0` dan `-0` **tidak POSIX**. POSIX tidak mendefinisikan `-print0`. Ini ekstensi GNU.

Untuk portabilitas, kompromi terbaik adalah `find -exec sh -c`.

---

## 2.3.10 Performa Loop

### Loop vs Pipeline

Loop di shell lambat karena setiap iterasi mengeksekusi perintah eksternal (jika ada).

```sh
# Lambat: menjalankan grep untuk setiap file
for file in *.log; do
    grep "ERROR" "$file"
done

# Cepat: satu grep untuk semua file
grep "ERROR" *.log
```

Penjelasan:

- Versi pertama menjalankan `grep` sekali per file. Untuk 1000 file, 1000 proses.
- Versi kedua menjalankan `grep` sekali. Jauh lebih cepat.

### Loop vs `xargs`

```sh
# Loop: satu proses per item
for file in *.txt; do
    rm "$file"
done

# xargs: proses batch
find . -name "*.txt" | xargs rm
```

Penjelasan:

- `xargs` menggabungkan banyak item menjadi satu pemanggilan perintah.
- Lebih efisien untuk banyak item.

### Loop vs `sed`/`awk`

```sh
# Loop lambat
while IFS= read -r line; do
    echo "$line" | sed 's/foo/bar/'
done < file.txt

# Sed langsung
sed 's/foo/bar/' file.txt
```

Penjelasan:

- Versi loop menjalankan `sed` sekali per baris.
- Versi langsung menjalankan `sed` sekali untuk seluruh file.

### Kapan Loop Tetap Perlu?

- Ketika logika antar-baris kompleks (state).
- Ketika memproses banyak file dengan tindakan berbeda.
- Ketika perlu kontrol alur (`break`, `continue`).
- Ketika memproses input interaktif.

---

## 2.3.11 Contoh Skrip Lengkap

### Skrip 1: Backup File dengan Loop

```sh
#!/bin/sh
# Nama: backup.sh
# Tujuan: Menyalin semua file .txt dari direktori tertentu

sumber="${1:?Penggunaan: $0 direktori}"
tujuan="${2:-backup}"

if [ ! -d "$sumber" ]; then
    echo "Error: $sumber bukan direktori." >&2
    exit 1
fi

mkdir -p "$tujuan"

jumlah=0
for file in "$sumber"/*.txt; do
    [ -f "$file" ] || continue
    cp -p "$file" "$tujuan/" || {
        echo "Gagal menyalin: $file" >&2
        continue
    }
    jumlah=$((jumlah + 1))
    echo "Disalin: $(basename "$file")"
done

echo "Total file disalin: $jumlah"
```

Bedah:

- `sumber="${1:?...}"` – Validasi argumen.
- `tujuan="${2:-backup}"` – Default jika tidak diberikan.
- `mkdir -p "$tujuan"` – Buat direktori jika belum ada.
- `for file in "$sumber"/*.txt` – Glob dengan variabel.
- `[ -f "$file" ] || continue` – Skip jika bukan file biasa.
- `cp -p ... || { ...; continue; }` – Jika gagal, cetak error dan lanjut.
- `basename "$file"` – Mengambil nama file tanpa path.
- `jumlah=$((jumlah + 1))` – Counter.

### Skrip 2: Baca File Baris per Baris

```sh
#!/bin/sh
# Nama: hitung_kata.sh
# Tujuan: Menghitung kata per baris

file="${1:?Penggunaan: $0 file}"

if [ ! -r "$file" ]; then
    echo "Error: $file tidak dapat dibaca." >&2
    exit 1
fi

nomor=0
while IFS= read -r line || [ -n "$line" ]; do
    nomor=$((nomor + 1))
    jumlah=$(printf '%s' "$line" | wc -w)
    printf '%4d: %s kata\n' "$nomor" "$jumlah"
done < "$file"
```

Bedah:

- `|| [ -n "$line" ]` – Menangani baris terakhir tanpa newline.
- `printf '%s' "$line"` – Mencetak tanpa newline. Menggunakan `printf` lebih portabel daripada `echo -n`.
- `wc -w` – Menghitung kata.
- `printf '%4d: %s kata\n'` – Format output. `%4d` = integer dengan lebar 4.

### Skrip 3: Menu Loop

```sh
#!/bin/sh
# Nama: menu_loop.sh
# Tujuan: Menu interaktif dengan while

while :; do
    echo "===== MENU ====="
    echo "1. Tampilkan tanggal"
    echo "2. Tampilkan direktori saat ini"
    echo "3. Keluar"
    printf "Pilih: "
    read -r pilihan

    case "$pilihan" in
        1) date ;;
        2) pwd ;;
        3)
            echo "Selamat tinggal."
            break
            ;;
        *)
            echo "Pilihan tidak valid." >&2
            ;;
    esac
    echo
done
```

Bedah:

- `while :` – Loop tak terbatas.
- `case` – Percabangan.
- `break` – Keluar dari loop.

### Skrip 4: Iterasi Argumen

```sh
#!/bin/sh
# Nama: proses_arg.sh
# Tujuan: Memproses setiap argumen

if [ $# -eq 0 ]; then
    echo "Penggunaan: $0 argumen..." >&2
    exit 1
fi

i=0
for arg in "$@"; do
    i=$((i + 1))
    case "$arg" in
        -v|--verbose)
            echo "[$i] Mode verbose"
            ;;
        -*)
            echo "[$i] Opsi: $arg"
            ;;
        *)
            echo "[$i] Argumen: $arg"
            ;;
    esac
done
```

---

## 2.3.12 Latihan

1. **`for` Dasar:**
   - Tulis skrip yang mencetak angka 1 hingga 10 menggunakan `for` dan `while`.
   - Bandingkan sintaksnya.

2. **`for` dengan Glob:**
   - Buat 5 file `.txt` dan 3 file `.log` di direktori.
   - Loop cetak semua `.txt`.
   - Loop cetak semua `.log`.
   - Pastikan tidak error jika tidak ada file yang cocok.

3. **Baca File:**
   - Buat file `data.txt` dengan 10 baris.
   - Tulis skrip yang membaca file baris per baris.
   - Cetak nomor baris dan isinya.

4. **Subshell:**
   - Tulis skrip yang menghitung jumlah baris file dengan:
     - `cat file | while read`
     - `while read ... done < file`
   - Bandingkan hasilnya. Jelaskan mengapa berbeda.

5. **`break` dan `continue`:**
   - Loop dari 1 sampai 100.
   - Skip angka yang habis dibagi 3 (`continue`).
   - Berhenti di angka 50 (`break`).
   - Cetak angka yang diproses.

6. **Nama File dengan Spasi:**
   - Buat file `file penting.txt`.
   - Loop dengan `for f in $(ls)`. Apa yang terjadi?
   - Loop dengan `for f in *`. Apakah benar?
   - Jelaskan perbedaannya.

7. **`until`:**
   - Tulis loop `until` yang mencetak angka 1 sampai 5.
   - Tulis loop `while` yang setara.

8. **Aritmatika:**
   - Tulis loop yang mencetak kuadrat dari 1 sampai 10.
   - Gunakan `$(( ))`.

9. **Menu:**
   - Buat menu dengan `while` dan `case`.
   - Menu: 1) Cek file, 2) Cek direktori, 3) Keluar.
   - Untuk opsi 1 dan 2, minta input path.

10. **Praktik Terbaik:**
    - Tulis skrip yang membaca file `daftar.txt` berisi nama file (satu per baris).
    - Untuk setiap file, cek apakah ada. Cetak status.
    - Tangani nama file dengan spasi.

---

## 2.3.13 Ringkasan Materi 3

- `for` iterasi atas daftar kata: literal, glob, `"$@"`, command substitution.
- `while` iterasi selama kondisi sukses; `until` sampai kondisi sukses.
- `break` keluar dari loop; `continue` lanjut ke iterasi berikutnya.
- **Selalu kutip** variabel dalam loop: `for f in "$@"; do ...`
- Baca file dengan `while IFS= read -r line; do ...; done < file`.
- **Jebakan subshell:** pipeline membuat subshell; gunakan redirection untuk mempertahankan variabel.
- **Jebakan `read`:** gunakan `IFS= read -r` untuk mempertahankan spasi dan backslash.
- Nama file dengan spasi: gunakan glob (`*`) atau `find -exec`, bukan `$(ls)`.
- Performa: hindari perintah eksternal dalam loop jika bisa diganti dengan `sed`, `awk`, atau `xargs`.
- Aritmatika dengan `$(( ))` untuk integer; `awk` untuk floating-point.

---

## 📌 Selanjutnya

Materi 3 Level 2 selesai. Anda sekarang menguasai loop secara mendalam.

Berikutnya adalah **Materi 4: Fungsi** — kita akan membahas:

- Mendefinisikan fungsi dengan sintaks POSIX.
- Memanggil fungsi dengan argumen.
- Variabel lokal (`local`) dan alternatif portabel.
- Nilai return dan exit status.
- Fungsi rekursif.
- Membangun pustaka fungsi yang dapat digunakan ulang.
- Jebakan: `local`, `return`, dan scope variabel.

## Materi 4: Fungsi

> **Catatan:** Ini adalah **materi keempat** dan **terakhir** dari Level 2. Fungsi adalah alat untuk **abstraksi** dan **reusability**. Tanpa fungsi, skrip Anda akan menjadi tumpukan perintah yang sulit dipelihara. Dengan fungsi, Anda bisa membangun pustaka kode yang dapat digunakan ulang di banyak skrip. Kita akan membedah setiap aspek fungsi POSIX, termasuk jebakan scope variabel yang paling sering memakan korban.

---

## 🎯 Tujuan Materi 4

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Mendefinisikan fungsi dengan sintaks POSIX yang benar.
2. Memanggil fungsi dengan argumen dan mengaksesnya via `$1`, `$@`, `$#`.
3. Memahami perbedaan **exit status** dan **nilai return** fungsi.
4. Menggunakan `return` dengan benar dan memahami batasannya.
5. Mengelola **scope variabel** — variabel global, lokal, dan konvensi penamaan.
6. Menghindari jebakan `local` yang tidak POSIX.
7. Menulis fungsi rekursif.
8. Membangun **pustaka fungsi** yang dapat di-source.
9. Menerapkan praktik terbaik: dokumentasi, validasi argumen, dan error handling.

---

## 2.4.1 Apa Itu Fungsi?

**Fungsi** adalah blok kode bernama yang dapat dipanggil berulang kali. Di shell, fungsi:

1. **Berbagi namespace** dengan skrip utama — variabel global terlihat di dalam fungsi.
2. **Memiliki argumen sendiri** — `$1`, `$2`, dst. di dalam fungsi merujuk ke argumen fungsi, bukan argumen skrip.
3. **Mengembalikan exit status** — bukan nilai seperti di bahasa lain.
4. **Tidak memiliki tipe** — parameter dan return semuanya string atau integer exit status.
5. **Didefinisikan di shell saat ini** — jika Anda menjalankan skrip yang mendefinisikan fungsi, fungsi itu tidak tersedia di shell induk setelah skrip selesai (kecuali di-source).

Fungsi adalah cara utama untuk:

- Menghindari duplikasi kode.
- Memberi nama pada blok logika.
- Menguji kode secara terpisah.
- Membangun pustaka yang dapat digunakan ulang.

---

## 2.4.2 Sintaks Definisi Fungsi

POSIX mendefinisikan **dua sintaks** untuk mendefinisikan fungsi:

### Sintaks 1: `nama() { ... }`

```sh
nama_fungsi() {
    perintah1
    perintah2
}
```

Penjelasan kata demi kata:

- `nama_fungsi` – Nama fungsi. Aturan penamaan sama seperti variabel: huruf, angka, underscore, tidak diawali angka.
- `()` – Tanda kurung kosong. Wajib ada, meskipun tidak ada parameter formal. Ini adalah penanda bahwa ini adalah definisi fungsi.
- `{` – Awal blok. **Harus** dipisahkan oleh spasi dari `)` dan diikuti oleh newline atau `;`.
- `perintah1`, `perintah2` – Isi fungsi.
- `}` – Akhir blok. Harus berada di awal baris atau didahului `;`.

### Sintaks 2: `function nama { ... }`

```sh
function nama_fungsi {
    perintah1
}
```

Penjelasan:

- `function` – Kata kunci.
- **Ini tidak POSIX.** Kata kunci `function` adalah ekstensi bash/ksh. Jangan gunakan di skrip portabel.

### Aturan Penulisan

1. **Spasi setelah `{`** wajib:
   ```sh
   nama() { echo "halo"; }    # ✅
   nama() {echo "halo"; }     # ❌
   ```
   Tanpa spasi, `{echo` dianggap sebagai satu token.

2. **`;` sebelum `}`** wajib jika `}` di baris yang sama:
   ```sh
   nama() { echo "halo"; }    # ✅
   nama() { echo "halo" }     # ❌
   ```

3. **`()` tidak boleh ada spasi di antara nama dan `(`**:
   ```sh
   nama() { ... }    # ✅
   nama () { ... }   # ❌ (beberapa shell mentoleransi, tapi tidak portabel)
   ```

4. **Fungsi harus didefinisikan sebelum dipanggil**:
   ```sh
   sapa          # ❌ error: sapa: not found
   sapa() { echo "Halo"; }
   sapa          # ✅
   ```

### Contoh Sederhana

```sh
#!/bin/sh

sapa() {
    echo "Halo, dunia!"
}

sapa
sapa
sapa
```

Output:

```
Halo, dunia!
Halo, dunia!
Halo, dunia!
```

Penjelasan:

- `sapa() { ... }` – Definisi fungsi.
- `sapa` – Pemanggilan. Tiga kali.
- Setiap pemanggilan menjalankan isi fungsi.

---

## 2.4.3 Argumen Fungsi

Fungsi menerima argumen seperti skrip. Di dalam fungsi:

- `$1`, `$2`, ... – Argumen posisi fungsi.
- `$#` – Jumlah argumen fungsi.
- `$@` – Semua argumen fungsi.
- `$*` – Semua argumen sebagai satu string.
- `$0` – **Tetap nama skrip**, bukan nama fungsi.

### Contoh

```sh
#!/bin/sh

sapa() {
    echo "Fungsi menerima $# argumen"
    echo "Argumen pertama: $1"
    echo "Argumen kedua: $2"
    echo "Semua argumen: $@"
}

sapa Budi Jakarta
```

Output:

```
Fungsi menerima 2 argumen
Argumen pertama: Budi
Argumen kedua: Jakarta
Semua argumen: Budi Jakarta
```

Penjelasan:

- `sapa Budi Jakarta` – Memanggil fungsi dengan dua argumen.
- Di dalam fungsi, `$1` = `Budi`, `$2` = `Jakarta`, `$#` = `2`.
- `$@` = `Budi Jakarta`.

### `$0` di Dalam Fungsi

```sh
#!/bin/sh

cek() {
    echo "Nama skrip: $0"
}

cek
```

Output:

```
Nama skrip: ./skrip.sh
```

Penjelasan:

- `$0` di dalam fungsi adalah nama skrip, bukan nama fungsi.
- Tidak ada variabel POSIX untuk nama fungsi. Jika perlu, gunakan variabel manual.

### Argumen Fungsi vs Argumen Skrip

```sh
#!/bin/sh

fungsi() {
    echo "Argumen fungsi: $1"
}

echo "Argumen skrip: $1"
fungsi "dalam"
```

Jalankan:

```sh
./skrip.sh "luar"
```

Output:

```
Argumen skrip: luar
Argumen fungsi: dalam
```

Penjelasan:

- `$1` di luar fungsi merujuk ke argumen skrip.
- `$1` di dalam fungsi merujuk ke argumen fungsi.
- Argumen skrip **tetap ada** tetapi **tertutup** oleh argumen fungsi selama eksekusi fungsi.

### Mengakses Argumen Skrip dari Dalam Fungsi

Tidak ada cara langsung POSIX. Solusi: simpan di variabel global sebelum memanggil fungsi.

```sh
#!/bin/sh

SKRIP_ARG1="$1"

fungsi() {
    echo "Argumen skrip: $SKRIP_ARG1"
    echo "Argumen fungsi: $1"
}

fungsi "dalam"
```

### `shift` di Dalam Fungsi

`shift` juga bekerja di dalam fungsi, menggeser argumen fungsi, bukan argumen skrip.

```sh
fungsi() {
    echo "Sebelum shift: $1"
    shift
    echo "Setelah shift: $1"
}

fungsi a b c
```

Output:

```
Sebelum shift: a
Setelah shift: b
```

---

## 2.4.4 Nilai Return dan Exit Status

Ini adalah topik yang **sangat sering disalahpahami**. Fungsi shell **tidak mengembalikan nilai** seperti fungsi di Python atau C. Fungsi mengembalikan **exit status** (integer 0–255).

### `return` — Mengembalikan Exit Status

```sh
fungsi() {
    return 0
}
```

Penjelasan:

- `return N` – Menghentikan fungsi dan mengembalikan exit status `N`.
- `N` harus integer 0–255. Nilai di luar rentang akan di-modulo 256.
- Jika `N` tidak diberikan, `return` mengembalikan exit status perintah terakhir.

### Contoh

```sh
#!/bin/sh

cek_positif() {
    if [ "$1" -gt 0 ]; then
        return 0
    else
        return 1
    fi
}

if cek_positif 5; then
    echo "Positif"
else
    echo "Bukan positif"
fi
```

Output:

```
Positif
```

Penjelasan:

- `cek_positif 5` – Memanggil fungsi. Fungsi mengembalikan `0`.
- `if` mengevaluasi exit status `0` → true.

### `return` vs `exit`

| Aspek | `return` | `exit` |
|-------|----------|--------|
| Efek | Menghentikan fungsi | Menghentikan skrip/shell |
| Konteks | Di dalam fungsi | Di mana saja |
| Nilai | Exit status fungsi | Exit status skrip |

**Jebakan:** Jika Anda menggunakan `exit` di dalam fungsi, seluruh skrip akan berhenti, bukan hanya fungsi.

```sh
fungsi() {
    exit 1    # ❌ Menghentikan seluruh skrip
}

fungsi
echo "Tidak akan tercetak"
```

**Yang benar:**

```sh
fungsi() {
    return 1    # ✅ Hanya menghentikan fungsi
}

fungsi
echo "Ini tercetak"
```

### Mengembalikan "Nilai" Sebenarnya

Karena `return` hanya mengembalikan integer, untuk mengembalikan string gunakan salah satu dari:

1. **Echo ke stdout, tangkap dengan command substitution:**

```sh
get_nama() {
    echo "Budi"
}

nama=$(get_nama)
echo "Nama: $nama"
```

2. **Set variabel global:**

```sh
HASIL=""

hitung() {
    HASIL=$(( $1 + $2 ))
}

hitung 3 4
echo "Hasil: $HASIL"
```

3. **Gunakan file temporary:**

```sh
get_data() {
    echo "data" > /tmp/hasil.$$
}

get_data
baca=$(cat /tmp/hasil.$$)
rm -f /tmp/hasil.$$
```

Pola 1 (echo + command substitution) adalah yang paling umum dan bersih.

### Exit Status 0–255

```sh
fungsi() {
    return 300    # Akan menjadi 300 % 256 = 44
}

fungsi
echo "$?"    # 44
```

Penjelasan:

- Exit status hanya 8 bit. Nilai di luar 0–255 akan di-modulo 256.
- Jangan gunakan nilai > 255 untuk return.
- Konvensi: `0` = sukses, `1`–`125` = error, `126`–`128`+ = khusus (lihat Level 1).

### `$?` Setelah Fungsi

```sh
fungsi() {
    return 42
}

fungsi
echo "$?"    # 42
```

Penjelasan:

- `$?` setelah pemanggilan fungsi berisi exit status fungsi.
- Ini adalah cara untuk memeriksa hasil fungsi.

---

## 2.4.5 Scope Variabel — Jebakan Terbesar

Ini adalah topik yang **wajib** dipahami. Kesalahan scope adalah sumber bug paling umum dalam skrip shell.

### Variabel Global Secara Default

Semua variabel di shell adalah **global** secara default. Fungsi dapat membaca dan mengubah variabel global.

```sh
#!/bin/sh

nama="Global"

ubah() {
    nama="Diubah di fungsi"
}

echo "Sebelum: $nama"
ubah
echo "Setelah: $nama"
```

Output:

```
Sebelum: Global
Setelah: Diubah di fungsi
```

Penjelasan:

- Fungsi mengubah variabel `nama` global.
- Perubahan **bertahan** setelah fungsi selesai.
- Ini adalah **efek samping** yang sering tidak diinginkan.

### `local` — Variabel Lokal

```sh
ubah() {
    local nama="Lokal"
    echo "Dalam fungsi: $nama"
}

nama="Global"
ubah
echo "Setelah: $nama"
```

Output:

```
Dalam fungsi: Lokal
Setelah: Global
```

Penjelasan:

- `local nama="Lokal"` – Mendefinisikan variabel yang hanya berlaku di dalam fungsi.
- Setelah fungsi selesai, `nama` kembali ke nilai global.
- **`local` tidak POSIX.** POSIX tidak mendefinisikan `local`. Namun, hampir semua shell modern (`bash`, `dash`, `ksh`, `zsh`, `ash`) mendukungnya.

### Alternatif Portabel untuk `local`

Jika Anda menulis skrip yang harus berjalan di shell POSIX ketat yang tidak mendukung `local` (sangat jarang), gunakan salah satu teknik berikut:

**Teknik 1: Simpan dan Pulihkan**

```sh
ubah() {
    _old_nama="$nama"
    nama="Lokal"
    echo "Dalam fungsi: $nama"
    nama="$_old_nama"
}
```

Penjelasan:

- Simpan nilai lama ke variabel sementara.
- Ubah variabel.
- Pulihkan di akhir fungsi.
- Jebakan: jika fungsi keluar lebih awal (misalnya karena error), pemulihan tidak terjadi.

**Teknik 2: Konvensi Penamaan**

```sh
ubah() {
    _ubah_nama="Lokal"
    echo "Dalam fungsi: $_ubah_nama"
}
```

Penjelasan:

- Gunakan prefix unik untuk variabel fungsi: `_namafungsi_var`.
- Tidak menghilangkan risiko tabrakan, tetapi meminimalkannya.

**Teknik 3: Subshell**

```sh
ubah() (
    nama="Lokal"
    echo "Dalam fungsi: $nama"
)
```

Penjelasan:

- `()` alih-alih `{}` – Fungsi berjalan di subshell.
- Semua perubahan variabel hilang setelah fungsi selesai.
- **Kerugian:** Anda tidak bisa mengembalikan nilai via variabel global, dan performa sedikit lebih lambat.
- Juga tidak bisa menggunakan `return` untuk keluar dari fungsi; gunakan `exit` (yang hanya keluar dari subshell).

### Rekomendasi

Untuk skrip POSIX modern, **gunakan `local`**. Hampir semua shell yang mengklaim POSIX mendukungnya. Jika Anda benar-benar memerlukan portabilitas maksimal (misalnya untuk shell `sh` kuno), gunakan konvensi penamaan.

### `local` dengan Multiple Variabel

```sh
fungsi() {
    local a b c
    a=1
    b=2
    c=3
}
```

Penjelasan:

- `local a b c` – Mendeklarasikan tiga variabel lokal sekaligus.
- Nilainya belum di-set (kosong).
- Di bash, `local a=1 b=2` juga bekerja, tetapi tidak semua shell mendukung assignment dalam `local`. Untuk portabilitas, deklarasikan dulu, lalu assign.

### `local` dan Sub-Fungsi

`local` mempengaruhi **fungsi saat ini** dan **semua fungsi yang dipanggil dari dalamnya**? Tidak. `local` hanya berlaku di fungsi tempat ia dideklarasikan.

```sh
luar() {
    local x="luar"
    dalam
    echo "Di luar: $x"
}

dalam() {
    echo "Di dalam: $x"    # Kosong, karena x lokal untuk luar
}

luar
```

Output:

```
Di dalam: 
Di luar: luar
```

Penjelasan:

- `x` dideklarasikan lokal di `luar`.
- `dalam` tidak melihat `x` karena `x` bukan global.
- **Catatan:** Di bash, `local` membuat variabel terlihat oleh fungsi yang dipanggil (dynamic scoping). Di POSIX, perilaku ini tidak didefinisikan. Untuk portabilitas, jangan andalkan.

---

## 2.4.6 Fungsi Rekursif

Fungsi dapat memanggil dirinya sendiri. Ini berguna untuk struktur data rekursif (pohon direktori, parser).

### Contoh: Faktorial

```sh
#!/bin/sh

faktorial() {
    if [ "$1" -le 1 ]; then
        echo 1
    else
        prev=$(faktorial $(( $1 - 1 )))
        echo $(( $1 * prev ))
    fi
}

echo "5! = $(faktorial 5)"
```

Output:

```
5! = 120
```

Penjelasan:

- `faktorial 5` memanggil `faktorial 4`, yang memanggil `faktorial 3`, dst.
- Basis: `$1 <= 1` mengembalikan `1`.
- Rekursi: `$1 * faktorial($1 - 1)`.
- Setiap panggilan menggunakan `$(...)` untuk menangkap output.

### Contoh: Menelusuri Direktori

```sh
#!/bin/sh

telusuri() {
    for file in "$1"/*; do
        [ -e "$file" ] || continue
        if [ -d "$file" ]; then
            echo "DIR: $file"
            telusuri "$file"
        else
            echo "FILE: $file"
        fi
    done
}

telusuri "${1:-.}"
```

Penjelasan:

- `for file in "$1"/*` – Iterasi semua item di direktori.
- `[ -e "$file" ] || continue` – Skip jika tidak ada (glob tidak cocok).
- Jika direktori, cetak dan rekursi.
- Jika file, cetak.

**Jebakan:** Rekursi dalam shell lambat dan bisa menghabiskan stack. Untuk direktori besar, gunakan `find`.

### Batas Rekursi

Shell tidak memiliki batas rekursi eksplisit, tetapi setiap panggilan fungsi menggunakan stack. Rekursi terlalu dalam bisa menyebabkan `segmentation fault` atau `stack overflow`.

Untuk masalah sederhana, rekursi OK. Untuk masalah besar, gunakan iterasi.

---

## 2.4.7 Fungsi sebagai "Perintah"

Fungsi dapat digunakan di mana saja perintah digunakan:

- Dalam `if`, `while`, `until`.
- Dalam pipeline (`|`).
- Dalam `&&`, `||`.
- Dengan redirection.

### Contoh: Fungsi dalam Pipeline

```sh
upper() {
    tr '[:lower:]' '[:upper:]'
}

echo "halo dunia" | upper
```

Output:

```
HALO DUNIA
```

Penjelasan:

- `tr '[:lower:]' '[:upper:]'` – Mengubah huruf kecil ke besar.
- `upper` membaca dari stdin, menulis ke stdout.
- Fungsi berperilaku seperti filter.

### Contoh: Fungsi dengan Redirection

```sh
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*"
}

log "Pesan" >> /var/log/app.log
```

Penjelasan:

- `log` mencetak ke stdout.
- `>> /var/log/app.log` – Redirection di pemanggilan fungsi.
- Output fungsi dialihkan ke file.

### Contoh: Fungsi dalam `if`

```sh
file_ada() {
    [ -f "$1" ]
}

if file_ada "/etc/passwd"; then
    echo "Ada"
fi
```

Penjelasan:

- `file_ada` mengembalikan exit status dari `[ -f "$1" ]`.
- `if` mengevaluasi exit status tersebut.

### Fungsi Tidak Bisa Digunakan dengan `exec`

```sh
exec fungsi    # ❌ Error
```

Penjelasan:

- `exec` menggantikan proses shell dengan perintah eksternal.
- Fungsi bukan perintah eksternal, jadi tidak bisa di-`exec`.

---

## 2.4.8 Mendokumentasikan Fungsi

Fungsi yang baik memiliki dokumentasi. Konvensi umum:

```sh
# nama_fungsi: Deskripsi singkat.
# Argumen:
#   $1 - Deskripsi argumen pertama.
#   $2 - Deskripsi argumen kedua.
# Output:
#   Deskripsi output (stdout/stderr).
# Return:
#   0 - Sukses.
#   1 - Error karena X.
#   2 - Error karena Y.
nama_fungsi() {
    # ...
}
```

### Contoh

```sh
# baca_file: Membaca file dan mencetak isinya.
# Argumen:
#   $1 - Path ke file yang akan dibaca.
# Output:
#   Isi file ke stdout.
# Return:
#   0 - Sukses.
#   1 - File tidak ada.
#   2 - File tidak dapat dibaca.
baca_file() {
    file="$1"

    if [ ! -e "$file" ]; then
        echo "Error: $file tidak ada." >&2
        return 1
    fi

    if [ ! -r "$file" ]; then
        echo "Error: $file tidak dapat dibaca." >&2
        return 2
    fi

    cat "$file"
    return 0
}
```

Penjelasan:

- Dokumentasi di atas fungsi.
- Setiap kode return didokumentasikan.
- Pesan error ke stderr (`>&2`).

---

## 2.4.9 Pustaka Fungsi yang Dapat Digunakan Ulang

Salah satu kegunaan terbesar fungsi adalah membangun **pustaka** yang dapat di-source oleh banyak skrip.

### Struktur Proyek

```
proyek/
├── lib/
│   ├── log.sh
│   ├── string.sh
│   └── file.sh
├── bin/
│   ├── skrip1.sh
│   └── skrip2.sh
└── main.sh
```

### Contoh Pustaka: `lib/log.sh`

```sh
# lib/log.sh: Pustaka logging sederhana.

# _log: Fungsi internal untuk mencetak log.
# Argumen:
#   $1 - Level log (INFO, WARN, ERROR).
#   $2 - Pesan.
_log() {
    level="$1"
    shift
    pesan="$*"
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $pesan" >&2
}

log_info() {
    _log "INFO" "$@"
}

log_warn() {
    _log "WARN" "$@"
}

log_error() {
    _log "ERROR" "$@"
}
```

Penjelasan:

- `_log` – Fungsi internal, prefix `_` menandakan "private".
- `shift` – Membuang argumen pertama (level), sisanya adalah pesan.
- `$*` – Menggabungkan semua pesan menjadi satu string.
- `>&2` – Log ke stderr.

### Contoh Pustaka: `lib/string.sh`

```sh
# lib/string.sh: Fungsi manipulasi string.

# trim: Menghapus spasi di awal dan akhir string.
# Argumen:
#   $1 - String.
# Output:
#   String tanpa spasi di ujung.
trim() {
    printf '%s' "$1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# upper: Mengubah string ke huruf besar.
upper() {
    printf '%s' "$1" | tr '[:lower:]' '[:upper:]'
}

# lower: Mengubah string ke huruf kecil.
lower() {
    printf '%s' "$1" | tr '[:upper:]' '[:lower:]'
}

# contains: Cek apakah string mengandung substring.
# Return:
#   0 - Mengandung.
#   1 - Tidak mengandung.
contains() {
    case "$1" in
        *"$2"*) return 0 ;;
        *) return 1 ;;
    esac
}
```

Penjelasan:

- `printf '%s' "$1"` – Mencetak tanpa newline. Lebih portabel dari `echo -n`.
- `sed 's/^[[:space:]]*//;s/[[:space:]]*$//'` – Menghapus spasi di awal dan akhir.
- `case` – Cara portabel untuk cek substring.
- `*"$2"*` – Pola: apa pun, lalu `$2`, lalu apa pun.

### Menggunakan Pustaka

```sh
#!/bin/sh
# main.sh

# Tentukan direktori skrip
SCRIPT_DIR=$(dirname "$0")
LIB_DIR="$SCRIPT_DIR/lib"

# Source pustaka
. "$LIB_DIR/log.sh"
. "$LIB_DIR/string.sh"

# Gunakan
log_info "Memulai program"
nama=$(trim "  Budi  ")
log_info "Nama: $nama"
log_info "Upper: $(upper "$nama")"

if contains "$nama" "ud"; then
    log_info "Mengandung 'ud'"
fi
```

Penjelasan:

- `SCRIPT_DIR=$(dirname "$0")` – Mendapatkan direktori skrip.
- `. "$LIB_DIR/log.sh"` – Source pustaka.
- `trim "  Budi  "` – Memanggil fungsi dari pustaka.

**Jebakan:** `$0` bisa berupa path relatif. `dirname` menanganinya, tetapi jika skrip dipanggil via symlink, `$0` adalah path symlink. Untuk solusi yang lebih kuat, lihat Level 4.

### Pustaka dengan Guard

Untuk mencegah sourcing ganda:

```sh
# lib/log.sh
if [ -n "${_LOG_SH_LOADED:-}" ]; then
    return 0
fi
_LOG_SH_LOADED=1

# ... definisi fungsi ...
```

Penjelasan:

- `[ -n "${_LOG_SH_LOADED:-}" ]` – Cek apakah variabel sudah di-set.
- `return 0` – Jika sudah, keluar dari sourcing.
- `_LOG_SH_LOADED=1` – Tandai sudah di-load.
- Ini mencegah redefinisi fungsi yang tidak perlu.

---

## 2.4.10 Praktik Terbaik Fungsi

### 1. Nama Fungsi yang Deskriptif

```sh
# Buruk
f() { ... }
do_it() { ... }

# Baik
validasi_email() { ... }
hitung_total() { ... }
baca_konfigurasi() { ... }
```

### 2. Satu Tugas per Fungsi

Fungsi harus melakukan **satu hal** dengan baik. Jika fungsi melakukan terlalu banyak, pecah.

### 3. Validasi Argumen di Awal

```sh
sapa() {
    if [ $# -ne 1 ]; then
        echo "Penggunaan: sapa nama" >&2
        return 1
    fi
    echo "Halo, $1!"
}
```

### 4. Gunakan `local` untuk Variabel Sementara

```sh
proses() {
    local file="$1"
    local hasil
    hasil=$(transformasi "$file")
    echo "$hasil"
}
```

### 5. Return Exit Status yang Konsisten

```sh
# 0 = sukses, non-zero = error
# Dokumentasikan arti setiap kode.
```

### 6. Pisahkan Logika dan Output

```sh
# Buruk: fungsi mencetak dan mengembalikan
hitung() {
    echo "Menghitung..."    # Output debug
    echo $(( $1 + $2 ))     # Output hasil
}

# Baik: pisahkan
hitung() {
    echo $(( $1 + $2 ))
}

main() {
    echo "Menghitung..." >&2    # Debug ke stderr
    hasil=$(hitung 3 4)
    echo "Hasil: $hasil"
}
```

### 7. Hindari Variabel Global yang Tidak Perlu

```sh
# Buruk
HASIL=""
hitung() {
    HASIL=$(( $1 + $2 ))
}

# Baik
hitung() {
    echo $(( $1 + $2 ))
}
hasil=$(hitung 3 4)
```

### 8. Gunakan Fungsi `main`

```sh
#!/bin/sh

# Definisi fungsi
sapa() { echo "Halo, $1"; }
proses() { ... }

# Fungsi utama
main() {
    sapa "Budi"
    proses
}

# Panggil main dengan semua argumen
main "$@"
```

Penjelasan:

- `main "$@"` – Memanggil fungsi utama dengan argumen skrip.
- Ini membuat skrip terstruktur dan mudah diuji.
- Berguna untuk testing: Anda bisa `source` skrip dan memanggil fungsi individual tanpa menjalankan `main`.

---

## 2.4.11 Contoh Skrip Lengkap

### Skrip 1: Utilitas File

```sh
#!/bin/sh
# Nama: fileutil.sh
# Tujuan: Demonstrasi fungsi untuk operasi file

# cek_file: Memeriksa status file.
# Argumen:
#   $1 - Path file.
# Return:
#   0 - File ada dan dapat dibaca.
#   1 - File tidak ada.
#   2 - File tidak dapat dibaca.
cek_file() {
    if [ ! -e "$1" ]; then
        return 1
    fi
    if [ ! -r "$1" ]; then
        return 2
    fi
    return 0
}

# hitung_baris: Menghitung jumlah baris file.
# Argumen:
#   $1 - Path file.
# Output:
#   Jumlah baris ke stdout.
hitung_baris() {
    wc -l < "$1" | tr -d ' '
}

# main: Fungsi utama.
main() {
    if [ $# -ne 1 ]; then
        echo "Penggunaan: $0 file" >&2
        exit 1
    fi

    file="$1"

    cek_file "$file"
    status=$?

    case "$status" in
        0)
            echo "File '$file' dapat dibaca."
            jumlah=$(hitung_baris "$file")
            echo "Jumlah baris: $jumlah"
            ;;
        1)
            echo "Error: '$file' tidak ada." >&2
            exit 1
            ;;
        2)
            echo "Error: '$file' tidak dapat dibaca." >&2
            exit 2
            ;;
    esac
}

main "$@"
```

Bedah:

- `cek_file` mengembalikan 0, 1, atau 2.
- `hitung_baris` menggunakan `wc -l < "$1"` – redirection ke stdin `wc`.
- `tr -d ' '` – Menghapus spasi dari output `wc` (karena `wc` menambahkan spasi).
- `main "$@"` – Memanggil main dengan semua argumen.
- `case "$status"` – Menangani setiap kode return.

### Skrip 2: Pustaka String

```sh
#!/bin/sh
# Nama: stringlib.sh
# Tujuan: Pustaka fungsi string

# trim: Menghapus spasi di awal/akhir.
trim() {
    printf '%s' "$1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# panjang: Mengembalikan panjang string.
panjang() {
    printf '%s' "${#1}"
}

# starts_with: Cek apakah string dimulai dengan prefix.
# Return: 0 jika ya, 1 jika tidak.
starts_with() {
    case "$1" in
        "$2"*) return 0 ;;
        *) return 1 ;;
    esac
}

# ends_with: Cek apakah string diakhiri suffix.
# Return: 0 jika ya, 1 jika tidak.
ends_with() {
    case "$1" in
        *"$2") return 0 ;;
        *) return 1 ;;
    esac
}

# replace: Ganti semua kemunculan old dengan new.
# Catatan: Menggunakan sed, bukan POSIX parameter expansion.
replace() {
    printf '%s' "$1" | sed "s/$2/$3/g"
}
```

Penjelasan:

- `starts_with` menggunakan `case` dengan pola `"$2"*`.
- `ends_with` menggunakan pola `*"$2"`.
- `replace` menggunakan `sed` karena `${var//old/new}` tidak POSIX.

### Skrip 3: Fungsi Rekursif untuk Faktorial

```sh
#!/bin/sh
# Nama: faktorial.sh

faktorial() {
    if [ "$1" -le 1 ]; then
        echo 1
        return 0
    fi

    local prev
    prev=$(faktorial $(( $1 - 1 )))
    echo $(( $1 * prev ))
}

main() {
    if [ $# -ne 1 ]; then
        echo "Penggunaan: $0 angka" >&2
        exit 1
    fi

    hasil=$(faktorial "$1")
    echo "$1! = $hasil"
}

main "$@"
```

---

## 2.4.12 Latihan

1. **Fungsi Dasar:**
   - Tulis fungsi `sapa` yang menerima satu nama dan mencetak "Halo, nama!".
   - Panggil dengan beberapa nama.

2. **Return Status:**
   - Tulis fungsi `is_angka` yang mengembalikan `0` jika argumen adalah angka, `1` jika bukan.
   - Gunakan `case` untuk validasi.
   - Uji di `if`.

3. **Scope:**
   - Tulis fungsi yang mendefinisikan variabel `x` tanpa `local`.
   - Panggil, lalu cek `$x` di luar fungsi.
   - Ulangi dengan `local`. Bandingkan.

4. **Argumen Fungsi:**
   - Tulis fungsi `info` yang mencetak `$#`, `$1`, `$@`.
   - Panggil dengan 0, 1, dan 3 argumen.

5. **Fungsi Rekursif:**
   - Tulis fungsi `fibonacci` yang mengembalikan angka Fibonacci ke-N.
   - Uji dengan N=1, 5, 10.

6. **Pustaka:**
   - Buat `lib/math.sh` dengan fungsi `tambah`, `kurang`, `kali`, `bagi`.
   - Buat skrip utama yang meng-source dan menggunakannya.

7. **Dokumentasi:**
   - Ambil salah satu fungsi yang Anda tulis.
   - Tambahkan dokumentasi lengkap: deskripsi, argumen, output, return.

8. **Validasi:**
   - Tulis fungsi `baca_file` yang memvalidasi:
     - Argumen diberikan.
     - File ada.
     - File dapat dibaca.
   - Return kode berbeda untuk setiap error.

9. **Fungsi `main`:**
   - Refaktor skrip latihan sebelumnya untuk menggunakan pola `main "$@"`.
   - Pastikan fungsi dapat diuji secara terpisah dengan sourcing.

10. **Pipeline:**
    - Tulis fungsi `filter_error` yang membaca dari stdin dan hanya mencetak baris mengandung "ERROR".
    - Gunakan dalam pipeline: `cat log.txt | filter_error`.

---

## 2.4.13 Ringkasan Materi 4

- Fungsi didefinisikan dengan `nama() { ... }`. Sintaks `function nama` tidak POSIX.
- Fungsi menerima argumen via `$1`, `$2`, `$#`, `$@`.
- `$0` di dalam fungsi tetap nama skrip.
- `return N` mengembalikan exit status (0–255), bukan nilai.
- `exit` di dalam fungsi menghentikan seluruh skrip. Gunakan `return`.
- Variabel global secara default. Gunakan `local` untuk variabel lokal (tidak POSIX tapi didukung luas).
- Untuk portabilitas maksimal, gunakan konvensi penamaan `_fungsi_var`.
- Fungsi dapat digunakan dalam pipeline, `if`, `&&`, `||`, dengan redirection.
- Rekursi memungkinkan, tetapi lambat dan terbatas.
- Bangun **pustaka fungsi** yang dapat di-source untuk reusability.
- Gunakan pola `main "$@"` untuk struktur yang bersih.
- Dokumentasikan setiap fungsi dengan format yang konsisten.
- Praktik terbaik: satu tugas per fungsi, validasi argumen, pisahkan logika dan output.

---

## 🎉 Level 2 Selesai!

Anda telah menyelesaikan **Level 2 – Blok Bangunan**. Anda sekarang menguasai:

- Variabel dan ekspansi parameter secara mendalam.
- Kondisional (`if`, `test`, `case`).
- Loop (`for`, `while`, `until`).
- Fungsi dan pustaka.

Anda sudah bisa menulis skrip shell yang **terstruktur**, **modular**, dan **portabel**.

---

## 📌 Selanjutnya: Level 3 – Teknik Lanjutan

Di Level 3, kita akan masuk ke teknik yang membedakan penulis skrip biasa dari ahli:

- **Materi 1:** Input/Output & Redirection (mendalam) — file descriptor, here document, here string.
- **Materi 2:** Command Substitution & Pipeline — `xargs`, process substitution, filosofi Unix.
- **Materi 3:** Pattern Matching & Text Processing — `grep`, `sed`, `awk`, regex POSIX.
- **Materi 4:** Aritmatika dalam Shell — `$(( ))`, `expr`, floating-point dengan `awk`/`bc`.

# Selamat!
## Anda telah menyelesaikan level 2

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

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

