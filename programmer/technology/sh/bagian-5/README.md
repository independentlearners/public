# Level 5 – Tingkat Dewa  
## Materi 1: Optimasi Performa

> **Catatan:** Ini adalah **materi pertama** dari Level 5, sesuai kurikulum yang sudah ditetapkan. Di Level 3 kita sudah menyinggung optimasi pipeline secara singkat. Sekarang kita akan membedahnya **sampai ke level syscall**: mengapa fork() mahal, kapan subshell diciptakan, bagaimana shell mengelola memori, dan teknik-teknik yang membuat skrip Anda berjalan **10x hingga 1000x lebih cepat**. Setelah materi ini, Anda akan bisa mengoptimalkan skrip dengan presisi seorang insinyur performa.

---

## 🎯 Tujuan Materi 1

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Memahami **biaya sebenarnya** dari `fork()`, `exec()`, dan subshell.
2. Mengidentifikasi **titik panas** (hotspot) performa di skrip shell.
3. Mengganti perintah eksternal dengan **built-in shell** dan **parameter expansion**.
4. Mengoptimalkan **loop** dan **pipeline**.
5. Menggunakan **`xargs`**, **`find -exec ... +`**, dan **paralelisasi**.
6. Memahami **buffering** dan **I/O blocking**.
7. Menggunakan **`LC_ALL=C`** untuk mempercepat `grep`, `sed`, `awk`, `sort`.
8. Mengurangi **subshell** yang tidak perlu.
9. Menggunakan **`time`**, **`strace`**, dan **profilers** sederhana.
10. Menulis skrip yang **scalable** untuk jutaan baris atau file.

---

## 5.1.1 Mengapa Shell Lambat? Memahami Biaya Fundamental

Shell adalah **interpreter**, bukan compiler. Ia membaca perintah, mem-parsing, mengekspansi, dan mengeksekusi satu per satu. Overhead utama:

### 1. `fork()` — Membuat Proses Baru

Setiap kali Anda menjalankan perintah eksternal, shell memanggil `fork()` untuk menciptakan proses anak, lalu `exec()` untuk menggantinya dengan program target.

Biaya `fork()`:
- Menyalin page table memori (copy-on-write, tetapi tetap ada overhead).
- Mengalokasikan struktur proses di kernel.
- **Ribuan siklus CPU** per fork.

```sh
# 10.000 fork untuk 10.000 perintah
i=0
while [ "$i" -lt 10000 ]; do
    /bin/true    # fork() + exec()
    i=$((i + 1))
done
```

Waktu: sekitar **5–10 detik** hanya untuk fork.

Bandingkan:

```sh
# Nol fork — built-in shell
i=0
while [ "$i" -lt 10000 ]; do
    :            # built-in no-op
    i=$((i + 1))
done
```

Waktu: **< 50ms**.

**Rasio: 100x–200x lebih cepat.**

### 2. `exec()` — Mengganti Image Proses

Setelah `fork()`, shell memanggil `exec()` untuk menjalankan program eksternal. Biaya:
- Membaca binary dari disk (atau page cache).
- Memuat library dinamis.
- Menginisialisasi runtime.

**`/bin/true`**: ~1ms per eksekusi.
**`/bin/echo`**: ~1–2ms.
**`awk`**: ~5–10ms (memuat binary besar).
**`sed`**: ~3–5ms.

### 3. Subshell — `( ... )`, `$( ... )`, `|`

Subshell memerlukan **fork** tambahan. Setiap `$(...)` dan setiap sisi pipeline adalah subshell.

```sh
# 3 subshell
hasil=$(echo "$(date)" | sed 's/-/\//g')
```

Subshell 1: `$(date)` → fork + exec `date`.
Subshell 2: `sed` → fork + exec `sed`.
Subshell 3: `$(...)` luar → fork untuk menangkap output.

### 4. Built-in vs Eksternal

| Perintah | Tipe | Biaya |
|----------|------|-------|
| `echo` | Built-in di banyak shell | ~0 |
| `printf` | Built-in | ~0 |
| `[` | Built-in | ~0 |
| `test` | Built-in | ~0 |
| `true`/`false` | Built-in | ~0 |
| `:` | Built-in | ~0 |
| `cd` | Built-in (harus) | ~0 |
| `export` | Built-in | ~0 |
| `read` | Built-in | ~0 |
| `kill` | Built-in di banyak shell | ~0 |
| `pwd` | Built-in di banyak shell | ~0 |
| `cat` | Eksternal | ~2ms |
| `ls` | Eksternal | ~2ms |
| `grep` | Eksternal | ~3ms |
| `sed` | Eksternal | ~4ms |
| `awk` | Eksternal | ~8ms |
| `wc` | Eksternal | ~2ms |
| `basename` | Eksternal | ~2ms |
| `dirname` | Eksternal | ~2ms |

**Contoh penting:** `basename` dan `dirname` bisa diganti dengan ekspansi parameter:

```sh
# Lambat — fork + exec
nama=$(basename "$path")
dir=$(dirname "$path")

# Cepat — built-in parameter expansion
nama=${path##*/}
case "$path" in
    */*) dir=${path%/*} ;;
    *)   dir=. ;;
esac
```

**Rasio: 100x lebih cepat.**

### 5. Ukuran Data

Biaya juga tergantung ukuran data:
- **String kecil** — Overhead fork/exec dominan.
- **String besar** — Overhead manipulasi string dominan.

Untuk memproses **1 juta baris**, `awk` jauh lebih cepat dari loop shell.

### 6. Disk I/O

Membaca file berulang kali lambat. Baca sekali, proses di memori.

```sh
# Lambat — baca file 100x
i=0
while [ "$i" -lt 100 ]; do
    grep "pola" besar.txt
    i=$((i + 1))
done

# Cepat — baca sekali
grep "pola" besar.txt > hasil.txt
i=0
while [ "$i" -lt 100 ]; do
    cat hasil.txt
    i=$((i + 1))
done
```

---

## 5.1.2 Mengukur Performa: `time`

Sebelum mengoptimalkan, **ukur dulu**. Jangan menebak.

### `time` Built-in

```sh
time grep "error" besar.txt
```

Output:

```
real    0m0.523s
user    0m0.480s
sys     0m0.040s
```

Penjelasan:

- **real** — Waktu dinding (wall clock). Termasuk menunggu I/O.
- **user** — Waktu CPU di user space.
- **sys** — Waktu CPU di kernel space.

`time` adalah **kata kunci shell** (POSIX), bukan perintah eksternal. Ia bisa mengukur pipeline dan blok.

```sh
time {
    perintah1
    perintah2
}
```

### `time` Eksternal

```sh
/usr/bin/time -v perintah
```

`-v` (verbose) memberikan detail: page faults, context switches, maximum resident set size.

**Tidak POSIX.** GNU time.

### `date` untuk Pengukuran Manual

```sh
start=$(date +%s)
# ... perintah ...
end=$(date +%s)
echo "Durasi: $((end - start)) detik"
```

**Catatan:** `date +%s` hanya presisi detik. Untuk presisi lebih baik, gunakan `date +%s%N` (GNU) atau `perl`.

### Benchmark Sederhana

```sh
#!/bin/sh

benchmark() {
    nama="$1"
    shift
    start=$(date +%s)
    "$@" > /dev/null 2>&1
    end=$(date +%s)
    printf '%-30s %d detik\n' "$nama" "$((end - start))"
}

benchmark "loop eksternal" sh -c '
    i=0
    while [ $i -lt 1000 ]; do
        /bin/true
        i=$((i + 1))
    done
'

benchmark "loop built-in" sh -c '
    i=0
    while [ $i -lt 1000 ]; do
        :
        i=$((i + 1))
    done
'
```

---

## 5.1.3 Mengganti Perintah Eksternal dengan Built-in

Ini adalah **optimasi paling berdampak** untuk skrip dengan loop.

### `basename` → Parameter Expansion

```sh
# Lambat
nama=$(basename "$path")

# Cepat
nama=${path##*/}
```

### `dirname` → Parameter Expansion

```sh
# Lambat
dir=$(dirname "$path")

# Cepat
case "$path" in
    */*) dir=${path%/*} ;;
    *)   dir=. ;;
esac
```

### `echo` → `printf` (Built-in)

Keduanya built-in di sebagian besar shell, tetapi `printf` lebih portabel dan prediktabel.

```sh
# Portabel
printf '%s\n' "$var"

# Tidak selalu portabel
echo "$var"
```

### `expr` → `$(( ))`

```sh
# Lambat — fork + exec expr
hasil=$(expr "$a" + "$b")

# Cepat — built-in arithmetic
hasil=$((a + b))
```

**Rasio: 50x–100x lebih cepat.**

### `wc -l` → Built-in Loop dengan Counter

Untuk file kecil, built-in loop bisa lebih cepat dari `wc -l`:

```sh
# Lambat untuk file kecil
jumlah=$(wc -l < file.txt)

# Cepat untuk file kecil
jumlah=0
while IFS= read -r line; do
    jumlah=$((jumlah + 1))
done < file.txt
```

**Catatan:** Untuk file besar, `wc -l` tetap lebih cepat karena ditulis dalam C. Uji untuk kasus Anda.

### `test -f` → `[ -f ]`

`[` adalah built-in. `test` juga built-in, tetapi `[` lebih sering digunakan.

```sh
# Keduanya built-in
[ -f "$file" ]
test -f "$file"
```

### `pwd` → `$PWD`

```sh
# Lambat — eksternal di beberapa shell
dir=$(pwd)

# Cepat — built-in variabel
dir="$PWD"
```

**Catatan:** `$PWD` tidak selalu akurat jika direktori di-rename. `pwd` built-in lebih aman di sebagian shell.

### `readlink -f` → Ekspansi Parameter

```sh
# GNU readlink
path=$(readlink -f "$file")

# Alternatif portabel
case "$file" in
    /*) path="$file" ;;
    *)  path="$PWD/$file" ;;
esac
# Catatan: tidak menyelesaikan symlink sepenuhnya
```

### `date` → Built-in? Tidak.

`date` tidak ada built-in. Tetapi untuk format sederhana, bisa dikurangi pemanggilannya:

```sh
# Lambat — panggil date 1000x
i=0
while [ "$i" -lt 1000 ]; do
    timestamp=$(date +%s)
    i=$((i + 1))
done

# Cepat — panggil date sekali di luar loop jika timestamp sama
timestamp=$(date +%s)
i=0
while [ "$i" -lt 1000 ]; do
    # gunakan $timestamp
    i=$((i + 1))
done
```

---

## 5.1.4 Optimasi Loop

### Hindari Fork di Dalam Loop

```sh
# Buruk — fork per iterasi
for file in *.txt; do
    basename "$file"
done
```

Jika ada 1000 file, 1000 fork.

```sh
# Baik — parameter expansion
for file in *.txt; do
    printf '%s\n' "${file##*/}"
done
```

### Kumpulkan Output, Cetak Sekali

```sh
# Buruk — tulis ke stdout per iterasi
for i in 1 2 3 4 5; do
    echo "Baris $i"
done
```

```sh
# Baik untuk output besar — kumpulkan
output=""
for i in 1 2 3 4 5; do
    output="${output}Baris $i
"
done
printf '%s' "$output"
```

**Catatan:** Untuk output yang sangat besar, cara ini bisa menghabiskan memori. Gunakan `printf` dalam loop tanpa `echo`:

```sh
for i in 1 2 3 4 5; do
    printf 'Baris %s\n' "$i"
done
```

`printf` built-in tidak fork.

### Loop vs `xargs` vs `find -exec`

```sh
# Loop — 1 fork per file
for file in *.txt; do
    gzip "$file"
done

# find -exec ... \; — 1 fork per file (sama dengan loop)
find . -name "*.txt" -exec gzip {} \;

# find -exec ... + — 1 fork per batch (jauh lebih cepat)
find . -name "*.txt" -exec gzip {} +

# xargs — 1 fork per batch
find . -name "*.txt" | xargs gzip
```

**Untuk 1000 file:**

- Loop: 1000 fork `gzip`.
- `find -exec ... +`: 1–2 fork `gzip` (batched).
- `xargs`: 1–2 fork `gzip` (batched).

**Rasio: 500x lebih cepat dengan batching.**

### Loop vs `awk`/`sed` untuk Pemrosesan Teks

```sh
# Buruk — 10.000 fork
while IFS= read -r line; do
    printf '%s\n' "$line" | sed 's/foo/bar/'
done < besar.txt
```

```sh
# Baik — 1 fork
sed 's/foo/bar/' besar.txt
```

**Rasio: 10.000x lebih cepat.**

### Loop vs `awk` untuk Kalkulasi

```sh
# Buruk — 100.000 fork
total=0
while IFS= read -r line; do
    total=$((total + line))
done < angka.txt
```

Sebenarnya, loop ini **tidak** fork per iterasi (karena `read`, `$(( ))` adalah built-in). Tetapi untuk file besar, `awk` tetap lebih cepat:

```sh
# Baik — 1 fork
awk '{ total += $1 } END { print total }' angka.txt
```

**Rasio: 5x–10x lebih cepat untuk file besar.**

### Loop dengan Banyak String Manipulation

```sh
# Buruk — panggil sed per baris
while IFS= read -r line; do
    line=$(printf '%s' "$line" | sed 's/[[:space:]]*$//')
    # ...
done
```

```sh
# Baik — ekspansi parameter
while IFS= read -r line; do
    # Hapus spasi di akhir
    line=${line%"${line##*[![:space:]]}"}
    # ...
done
```

**Catatan:** Ekspansi parameter untuk trim tidak se-sederhana `sed`. Jika logika kompleks, `sed` sekali di luar loop lebih baik.

---

## 5.1.5 Optimasi Pipeline

### Kurangi Jumlah Tahap Pipeline

```sh
# 4 tahap — 4 fork
cat besar.txt | grep "error" | sort | uniq -c
```

```sh
# 2 tahap — kurangi cat
grep "error" besar.txt | sort | uniq -c
```

**`cat` yang tidak perlu** adalah "Useless Use of Cat" (UUOC). `grep` bisa membaca file langsung.

### Gabungkan `sort | uniq` dengan `sort -u`

```sh
# 2 fork
sort file.txt | uniq

# 1 fork
sort -u file.txt
```

**Rasio: 2x lebih cepat.**

### Gunakan `awk` untuk Menggantikan Banyak Pipeline

```sh
# 3 fork
grep "error" log.txt | awk '{ print $1 }' | sort -u
```

```sh
# 1 fork
awk '/error/ { print $1 }' log.txt | sort -u
```

Atau, jika `sort -u` juga bisa digantikan:

```sh
# 1 fork
awk '/error/ { seen[$1] = 1 } END { for (k in seen) print k }' log.txt
```

**Rasio: 3x lebih cepat.**

### Gunakan `sed` untuk Substitusi Sederhana

```sh
# Lambat — awk untuk substitusi
awk '{ gsub(/foo/, "bar"); print }' file.txt

# Cepat — sed
sed 's/foo/bar/g' file.txt
```

`sed` lebih cepat dari `awk` untuk substitusi sederhana.

### Hindari `cat` untuk Menggabungkan File

```sh
# Lambat — fork cat, lalu pipe
cat file1.txt file2.txt | grep "error"

# Cepat — grep bisa membaca banyak file
grep "error" file1.txt file2.txt
```

### Contoh: Pipeline Optimal

**Tugas:** Hitung jumlah kata "error" di semua file `.log` di direktori.

**Versi lambat:**

```sh
total=0
for file in *.log; do
    jumlah=$(grep -c "error" "$file")
    total=$((total + jumlah))
done
echo "$total"
```

- 1 fork `grep` per file.
- 1 fork `echo` di akhir.
- Untuk 1000 file: 1001 fork.

**Versi lebih cepat:**

```sh
grep -c "error" *.log | awk -F: '{ total += $2 } END { print total }'
```

- 1 fork `grep` untuk semua file.
- 1 fork `awk`.
- **Rasio: 500x lebih cepat.**

**Versi tercepat:**

```sh
awk '/error/ { count++ } END { print count }' *.log
```

- 1 fork `awk` untuk semua file.
- **Rasio: 1000x lebih cepat.**

---

## 5.1.6 `xargs` dan Paralelisasi

### `xargs` untuk Batching

```sh
# Loop — 1 fork per item
for file in *.txt; do
    gzip "$file"
done

# xargs — batched, 1 fork per batch
find . -name "*.txt" | xargs gzip
```

### `xargs -n` untuk Mengontrol Batch Size

```sh
# 1 argumen per perintah
find . -name "*.txt" | xargs -n 1 gzip
```

Gunakan `-n 1` jika perintah hanya menerima satu argumen.

### `xargs -I {}` untuk Placeholder

```sh
find . -name "*.txt" | xargs -I {} cp {} /backup/
```

**Catatan:** `-I` menyebabkan satu item per perintah (batching dinonaktifkan).

### Paralelisasi dengan `xargs -P` (GNU)

```sh
find . -name "*.jpg" | xargs -P 4 -I {} convert {} {}.png
```

- `-P 4` — Jalankan 4 proses paralel.
- **Tidak POSIX.** GNU xargs.

**Kapan Paralelisasi Berguna?**

Ketika tugas-tugas **independen** dan **CPU-bound** atau **I/O-bound**:

- Konversi gambar.
- Kompresi file.
- Download dari jaringan.
- Kompilasi.

**Kapan Tidak Berguna?**

- Tugas yang sangat cepat (overhead fork lebih besar).
- Tugas yang bergantung pada urutan.
- Tugas yang berbagi resource (I/O contention).

### Contoh: Paralelisasi Portabel

POSIX tidak memiliki `xargs -P`. Alternatif: jalankan beberapa proses di latar belakang, lalu `wait`.

```sh
#!/bin/sh

# Batas proses paralel
MAX_JOBS=4
jobs=0

for file in *.jpg; do
    convert "$file" "${file%.jpg}.png" &
    jobs=$((jobs + 1))
    
    if [ "$jobs" -ge "$MAX_JOBS" ]; then
        wait
        jobs=0
    fi
done

wait
```

Penjelasan:

- `convert ... &` — Jalankan di latar belakang.
- `jobs` — Counter.
- `wait` — Tunggu semua proses latar belakang selesai.
- Jika counter mencapai `MAX_JOBS`, tunggu dan reset.

**Batasan:** Ini menunggu **semua** job selesai, bukan hanya satu. Untuk kontrol lebih baik, gunakan `jobs` dan `kill -0`:

```sh
#!/bin/sh

MAX_JOBS=4
pids=""

for file in *.jpg; do
    # Tunggu sampai ada slot kosong
    while [ "$(echo $pids | wc -w)" -ge "$MAX_JOBS" ]; do
        new_pids=""
        for pid in $pids; do
            if kill -0 "$pid" 2>/dev/null; then
                new_pids="$new_pids $pid"
            fi
        done
        pids="$new_pids"
        sleep 0.1
    done
    
    convert "$file" "${file%.jpg}.png" &
    pids="$pids $!"
done

wait
```

**Catatan:** Ini rumit dan tidak sempurna. Untuk paralelisasi serius, gunakan `xargs -P` (GNU) atau `parallel` (GNU parallel, bukan POSIX).

---

## 5.1.7 `LC_ALL=C` untuk Mempercepat

Locale mempengaruhi banyak perintah: `grep`, `sed`, `awk`, `sort`, `tr`, `ls`. Dengan `LC_ALL=C`, perintah tidak perlu memproses multibyte, sehingga lebih cepat.

### Contoh

```sh
# Dengan locale UTF-8
time grep "error" besar.txt

# Dengan LC_ALL=C
time LC_ALL=C grep "error" besar.txt
```

**Perbedaan: 2x–10x lebih cepat** untuk file besar, tergantung locale dan perintah.

### Penerapan

```sh
#!/bin/sh
LC_ALL=C
export LC_ALL
```

Atau per perintah:

```sh
LC_ALL=C sort file.txt
```

### Kapan `LC_ALL=C` TIDAK Tepat?

- Saat memproses teks multibahasa (UTF-8, CJK).
- Saat menggunakan `[[:alpha:]]` untuk huruf beraksen.
- Saat sorting harus mengikuti aturan bahasa.

**Untuk skrip pemrosesan data teknis (log, CSV, dll.), `LC_ALL=C` hampir selalu tepat.**

---

## 5.1.8 Buffering dan I/O

### Output Buffering

Ketika output di-pipe, program sering mem-buffer output. Ini menyebabkan keterlambatan.

```sh
tail -f log.txt | grep "error"
```

`grep` mungkin mem-buffer output, sehingga Anda tidak melihat error segera.

**Solusi GNU:** `grep --line-buffered`:

```sh
tail -f log.txt | grep --line-buffered "error"
```

**Solusi POSIX:** Gunakan `awk` dengan `fflush()`:

```sh
tail -f log.txt | awk '/error/ { print; fflush() }'
```

**Catatan:** `fflush()` tidak POSIX, tetapi didukung banyak `awk`.

### Input Buffering

Membaca file baris per baris menggunakan buffer internal. Ini biasanya efisien.

### Mengurangi I/O

```sh
# Buruk — baca file 100x
for i in 1 2 3 ... 100; do
    grep "pola" besar.txt
done

# Baik — baca sekali, simpan di memori
hasil=$(grep "pola" besar.txt)
for i in 1 2 3 ... 100; do
    printf '%s\n' "$hasil"
done
```

**Catatan:** Untuk output besar, ini bisa menghabiskan memori. Gunakan file temporary:

```sh
grep "pola" besar.txt > /tmp/hasil.$$
for i in 1 2 3 ... 100; do
    cat /tmp/hasil.$$
done
rm -f /tmp/hasil.$$
```

### Menghindari `cat` yang Tidak Perlu

```sh
# Buruk — fork cat
cat file.txt | grep "pola"

# Baik — grep baca langsung
grep "pola" file.txt
```

`grep`, `sed`, `awk`, `sort`, `head`, `tail` bisa membaca file langsung.

**Pengecualian:** Ketika Anda benar-benar perlu menggabungkan beberapa file:

```sh
cat file1.txt file2.txt | grep "pola"
```

Atau lebih baik:

```sh
grep "pola" file1.txt file2.txt
```

---

## 5.1.9 Mengurangi Subshell

Setiap `$(...)`, `(...)`, dan sisi pipeline adalah subshell. Kurangi jika tidak perlu.

### Contoh 1: Assignment dari Perintah

```sh
# 1 subshell
hasil=$(perintah)
```

Ini tidak bisa dihindari jika Anda perlu menangkap output. Tetapi jangan menambah subshell:

```sh
# Buruk — 2 subshell
hasil=$(echo "$(perintah)")

# Baik — 1 subshell
hasil=$(perintah)
```

### Contoh 2: Subshell untuk Variabel

```sh
# Buruk — subshell tidak perlu
(
    var="nilai"
    echo "$var"
)
```

Jika hanya untuk mencetak, tidak perlu subshell:

```sh
var="nilai"
echo "$var"
```

### Contoh 3: Pipeline vs Redirection

```sh
# Subshell di sisi kanan pipe
count=0
cat file.txt | while read -r line; do
    count=$((count + 1))
done
echo "$count"    # 0

# Tanpa subshell — redirection
count=0
while read -r line; do
    count=$((count + 1))
done < file.txt
echo "$count"    # jumlah sebenarnya
```

### Contoh 4: `{ ... }` vs `( ... )`

```sh
# Subshell — variabel tidak bertahan
( var="nilai" )
echo "$var"    # kosong

# Command group — variabel bertahan
{ var="nilai"; }
echo "$var"    # nilai
```

**Command group `{ ... }` lebih cepat karena tidak fork.**

### Contoh 5: `$(cat file)` vs `< file`

```sh
# Subshell + fork cat
content=$(cat file.txt)

# Tidak subshell, tapi butuh redirection
# Tidak bisa langsung ke variabel tanpa subshell
```

Untuk membaca file ke variabel tanpa subshell, tidak ada cara POSIX. Tetapi untuk memproses, gunakan:

```sh
# Lebih baik daripada $(cat file)
while IFS= read -r line; do
    # proses
done < file.txt
```

---

## 5.1.10 Mengoptimalkan `grep`, `sed`, `awk`

### `grep` — Fixed String

Jika pola adalah string literal (bukan regex), gunakan `-F`:

```sh
# Regex
grep "hello.world" file.txt

# Fixed string — lebih cepat
grep -F "hello.world" file.txt
```

`-F` menghindari kompilasi regex. **2x–5x lebih cepat** untuk pola literal.

### `grep` — `LC_ALL=C`

Sudah dibahas. **2x–10x lebih cepat.**

### `grep` — Batasi Output

```sh
# Mencari semua kecocokan
grep "pola" besar.txt

# Berhenti setelah 10 kecocokan
grep -m 10 "pola" besar.txt
```

`-m` **tidak POSIX.** GNU grep.

**Alternatif POSIX:**

```sh
grep "pola" besar.txt | head -n 10
```

**Catatan:** `grep -m` lebih cepat karena `grep` berhenti membaca file setelah 10 kecocokan. `head` tetap membaca seluruh file (kecuali SIGPIPE).

### `sed` — `-n` untuk Skip Auto-Print

```sh
# Auto-print semua baris, lalu substitusi
sed 's/foo/bar/' file.txt

# Hanya cetak baris yang berubah
sed -n 's/foo/bar/p' file.txt
```

`-n` menghindari mencetak baris yang tidak berubah. **Lebih cepat untuk file besar dengan sedikit kecocokan.**

### `sed` — Multiple Commands dalam Satu Pass

```sh
# Buruk — 3 pass
sed 's/a/b/' file.txt | sed 's/c/d/' | sed 's/e/f/'

# Baik — 1 pass
sed -e 's/a/b/' -e 's/c/d/' -e 's/e/f/' file.txt
```

**3x lebih cepat.**

### `awk` — `LC_ALL=C`

Sama seperti `grep`. **2x–5x lebih cepat.**

### `awk` — Hindari `print $0`

```sh
# Sedikit lebih lambat
awk '{ print $0 }' file.txt

# Lebih cepat — action default adalah print
awk '1' file.txt

# Atau
awk '{ print }' file.txt
```

### `awk` — Gunakan `next` untuk Skip

```sh
# Tanpa next — semua baris dievaluasi
awk '
    /error/ { print }
    /warning/ { print }
    { print "lain" }
' file.txt
```

```sh
# Dengan next — skip setelah match
awk '
    /error/ { print; next }
    /warning/ { print; next }
    { print "lain" }
' file.txt
```

**Lebih cepat** karena baris yang sudah match tidak dievaluasi lagi.

### `awk` — Array Asosiatif vs Loop

```sh
# Buruk — loop untuk setiap baris
awk '{ for (i = 1; i <= NF; i++) if ($i == "error") count++ } END { print count }'

# Baik — langsung
awk '{ for (i = 1; i <= NF; i++) if ($i == "error") { count++; break } } END { print count }'
```

`break` setelah match menghindari loop berlanjut.

---

## 5.1.11 Profiling Skrip

### Profiling dengan `time` per Fungsi

```sh
#!/bin/sh

time_func() {
    nama="$1"
    shift
    start=$(date +%s)
    "$@"
    end=$(date +%s)
    printf '%-30s %d detik\n' "$nama" "$((end - start))" >&2
}

time_func "baca file" baca_file "$file"
time_func "proses" proses_data
time_func "tulis hasil" tulis_hasil
```

### Profiling dengan `set -x` + Timestamp

```sh
#!/bin/sh

PS4='+ $(date +%s.%N) ${LINENO}: '
set -x

# Kode yang diprofil
```

Output menunjukkan waktu setiap perintah. Analisis untuk menemukan yang lambat.

**Catatan:** `date +%s.%N` adalah GNU. Untuk portabilitas, gunakan `%s` saja.

### Profiling dengan `strace -c`

```sh
strace -c sh skrip.sh
```

Output:

```
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 60.00    0.060000          60      1000           execve
 30.00    0.030000          30      1000           fork
 ...
```

Menunjukkan syscall mana yang paling banyak memakan waktu.

**Tidak POSIX.** Linux.

### Profiling dengan `bash -x` + `time`

```sh
time bash -x skrip.sh 2> trace.txt
```

Analisis `trace.txt` untuk menemukan bagian yang lambat.

### Contoh: Analisis Skrip Lambat

```sh
#!/bin/sh
# Skrip lambat

total=0
for file in *.txt; do
    jumlah=$(grep -c "error" "$file")
    total=$((total + jumlah))
done
echo "Total: $total"
```

**Profiling:**

```sh
time sh skrip.sh
```

Output:

```
real    0m15.230s
```

**Analisis:** 1000 file, 1000 fork `grep`.

**Optimasi:**

```sh
#!/bin/sh
# Skrip cepat

LC_ALL=C grep -c "error" *.txt | awk -F: '{ total += $2 } END { print "Total: " total }'
```

**Profiling:**

```sh
time sh skrip_cepat.sh
```

Output:

```
real    0m0.150s
```

**Rasio: 100x lebih cepat.**

---

## 5.1.12 Contoh Kasus Optimasi

### Kasus 1: Menghitung Kata dari File Besar

**Tugas:** Hitung frekuensi kata dari file 100MB.

**Versi lambat (loop shell):**

```sh
#!/bin/sh
# Sangat lambat — jutaan fork

tr ' ' '\n' < besar.txt | while read -r kata; do
    echo "$kata"
done | sort | uniq -c | sort -rn
```

**Masalah:** `echo` per kata. Untuk 10 juta kata, 10 juta fork.

**Versi sedang (`tr` + `sort`):**

```sh
tr ' ' '\n' < besar.txt | sort | uniq -c | sort -rn
```

**Versi cepat (`awk` sekali):**

```sh
awk '{
    for (i = 1; i <= NF; i++) {
        count[$i]++
    }
}
END {
    for (kata in count) {
        printf "%d %s\n", count[kata], kata
    }
}' besar.txt | sort -rn | head -n 20
```

**Versi tercepat (`LC_ALL=C` + `awk`):**

```sh
LC_ALL=C awk '{
    for (i = 1; i <= NF; i++) {
        count[$i]++
    }
}
END {
    for (kata in count) {
        printf "%d %s\n", count[kata], kata
    }
}' besar.txt | LC_ALL=C sort -rn | head -n 20
```

**Rasio: 100x–1000x lebih cepat dari versi loop.**

### Kasus 2: Backup Banyak File

**Tugas:** Salin 10.000 file dari satu direktori ke direktori lain.

**Versi lambat (loop):**

```sh
#!/bin/sh
for file in sumber/*; do
    [ -f "$file" ] || continue
    cp -p "$file" tujuan/
done
```

**Versi cepat (cp multiple):**

```sh
#!/bin/sh
cp -p sumber/* tujuan/
```

**Catatan:** `cp` bisa menerima banyak file sekaligus. **Rasio: 100x lebih cepat.**

Jika `cp` tidak bisa menerima terlalu banyak argumen:

```sh
find sumber -maxdepth 1 -type f -exec cp -p {} tujuan/ +
```

**Catatan:** `-maxdepth` tidak POSIX. Untuk portabilitas:

```sh
find sumber -type f -exec cp -p {} tujuan/ +
```

**Rasio: 50x lebih cepat dari loop.**

### Kasus 3: Memproses CSV

**Tugas:** Hitung total kolom ke-3 dari CSV.

**Versi lambat (loop + cut + awk):**

```sh
#!/bin/sh
total=0
while IFS=, read -r a b c; do
    total=$((total + c))
done < data.csv
echo "$total"
```

Loop ini tidak fork per iterasi, tetapi untuk 1 juta baris bisa lambat.

**Versi cepat (`awk` sekali):**

```sh
LC_ALL=C awk -F, '{ total += $3 } END { print total }' data.csv
```

**Rasio: 10x–50x lebih cepat.**

### Kasus 4: Mencari File Berdasarkan Konten

**Tugas:** Cari file `.log` yang mengandung "ERROR".

**Versi lambat (loop + grep):**

```sh
#!/bin/sh
for file in *.log; do
    if grep -q "ERROR" "$file"; then
        echo "$file"
    fi
done
```

**Versi cepat (`grep -l`):**

```sh
LC_ALL=C grep -l "ERROR" *.log
```

**Rasio: 100x lebih cepat.**

**Versi cepat untuk direktori rekursif (`find -exec`):**

```sh
find . -type f -name "*.log" -exec grep -l "ERROR" {} +
```

**Catatan:** `-l` tidak POSIX? Ya, `grep -l` **POSIX**. Lihat POSIX grep.

### Kasus 5: Replace String di Banyak File

**Tugas:** Ganti "foo" dengan "bar" di 1000 file.

**Versi lambat (loop + sed per file):**

```sh
#!/bin/sh
for file in *.txt; do
    sed 's/foo/bar/g' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
done
```

Ini sudah cukup cepat karena `sed` dipanggil sekali per file. Tetapi masih 1000 fork.

**Versi cepat (`find -exec ... +`):**

```sh
find . -type f -name "*.txt" -exec sed -i.bak 's/foo/bar/g' {} +
```

**Catatan:** `-i` tidak POSIX. Untuk portabilitas:

```sh
find . -type f -name "*.txt" -exec sh -c '
    for file; do
        sed "s/foo/bar/g" "$file" > "$file.tmp" && mv "$file.tmp" "$file"
    done
' sh {} +
```

**Rasio: 10x–50x lebih cepat untuk banyak file.**

### Kasus 6: Mengekstrak Data dari Log

**Tugas:** Ekstrak IP dan waktu dari log Apache.

Format log:

```
192.168.1.1 - - [01/Jan/2026:12:00:00 +0000] "GET / HTTP/1.1" 200 1234
```

**Versi lambat (loop + sed):**

```sh
#!/bin/sh
while IFS= read -r line; do
    ip=$(printf '%s' "$line" | sed 's/^\([^ ]*\).*/\1/')
    waktu=$(printf '%s' "$line" | sed 's/.*\[\([^]]*\)\].*/\1/')
    echo "$ip $waktu"
done < access.log
```

**Masalah:** 2 `sed` per baris. Untuk 1 juta baris, 2 juta fork.

**Versi cepat (`awk` sekali):**

```sh
LC_ALL=C awk '{
    ip = $1
    match($0, /\[[^]]*\]/)
    waktu = substr($0, RSTART + 1, RLENGTH - 2)
    print ip, waktu
}' access.log
```

**Rasio: 1.000.000x lebih cepat.**

**Versi tercepat (`sed` dengan backreference):**

```sh
LC_ALL=C sed -n 's/^\([^ ]*\) .*\[\([^]]*\)\].*/\1 \2/p' access.log
```

**Rasio: 500.000x lebih cepat.**

---

## 5.1.13 Anti-Pattern Performa

### 1. UUOC (Useless Use of Cat)

```sh
# Buruk
cat file.txt | grep "pola"

# Baik
grep "pola" file.txt
```

### 2. Loop dengan Perintah Eksternal

```sh
# Buruk
for i in $(seq 1 1000); do
    echo "$i" | wc -c
done

# Baik
for i in $(seq 1 1000); do
    printf '%d\n' "$i"
done
```

### 3. `$(...)` Bersarang Tanpa Perlu

```sh
# Buruk
result=$(echo $(cat file.txt))

# Baik
result=$(cat file.txt)
```

### 4. `grep` + `awk` untuk Hal yang Bisa Dilakukan `awk`

```sh
# Buruk — 2 fork
grep "error" log.txt | awk '{ print $1 }'

# Baik — 1 fork
awk '/error/ { print $1 }' log.txt
```

### 5. `sort | uniq` Alih-alih `sort -u`

```sh
# Buruk — 2 fork
sort file.txt | uniq

# Baik — 1 fork
sort -u file.txt
```

### 6. `echo` untuk Output Besar

```sh
# Buruk — echo built-in, tapi banyak
for i in $(seq 1 1000000); do
    echo "$i"
done

# Baik — printf built-in, sedikit lebih cepat
for i in $(seq 1 1000000); do
    printf '%d\n' "$i"
done

# Terbaik — awk sekali
awk 'BEGIN { for (i = 1; i <= 1000000; i++) print i }'
```

### 7. `test` vs `[`

`test` dan `[` keduanya built-in. `[` lebih cepat? Tidak, sama saja. Tetapi `[` lebih sering digunakan.

### 8. `if [ ... ]; then ... fi` vs `if ...; then ... fi`

Untuk perintah seperti `grep`, langsung gunakan exit status:

```sh
# Buruk
if [ "$(grep -c "pola" file.txt)" -gt 0 ]; then
    echo "Ada"
fi

# Baik
if grep -q "pola" file.txt; then
    echo "Ada"
fi
```

Versi pertama: fork `grep`, fork `[`, dan command substitution (subshell).
Versi kedua: fork `grep` saja.

**Rasio: 3x lebih cepat.**

### 9. `while read` untuk File Kecil

Untuk file kecil (< 1000 baris), loop shell bisa lebih cepat dari `awk` karena tidak fork eksternal (jika tidak ada perintah eksternal di dalam).

```sh
# Untuk file 10 baris, ini mungkin lebih cepat
while IFS= read -r line; do
    printf '%s\n' "$line"
done < kecil.txt

# Ini fork awk
awk '{ print }' kecil.txt
```

**Selalu ukur untuk kasus spesifik Anda.**

### 10. `find -exec ... \;` vs `+`

```sh
# Buruk — fork per file
find . -name "*.txt" -exec grep "pola" {} \;

# Baik — fork per batch
find . -name "*.txt" -exec grep "pola" {} +
```

**Rasio: 100x lebih cepat untuk 1000 file.**

---

## 5.1.14 Contoh Skrip Optimasi Lengkap

### Skrip 1: Analisis Log Cepat

```sh
#!/bin/sh
# Nama: analisis_cepat.sh
# Tujuan: Analisis log dengan performa optimal

set -u

LOG="${1:?Penggunaan: $0 file_log}"

if [ ! -r "$LOG" ]; then
    printf 'Error: %s tidak dapat dibaca.\n' "$LOG" >&2
    exit 1
fi

# Set locale C untuk performa
LC_ALL=C
export LC_ALL

# Analisis dengan satu awk
awk '
/ERROR/ { error_count++ }
/WARN/  { warn_count++ }
{
    total++
}
END {
    printf "Total baris: %d\n", total
    printf "Error: %d\n", error_count
    printf "Warning: %d\n", warn_count
}
' "$LOG"
```

**Catatan:** Satu fork `awk`. Tidak ada loop shell.

### Skrip 2: Backup Paralel

```sh
#!/bin/sh
# Nama: backup_paralel.sh
# Tujuan: Backup dengan paralelisasi

set -u

SUMBER="${1:?Penggunaan: $0 sumber tujuan}"
TUJUAN="${2:?Penggunaan: $0 sumber tujuan}"
MAX_JOBS=4

if [ ! -d "$SUMBER" ]; then
    printf 'Error: %s bukan direktori.\n' "$SUMBER" >&2
    exit 1
fi

mkdir -p "$TUJUAN" || exit 1

# Kumpulkan file, lalu gzip paralel
find "$SUMBER" -type f -name "*.txt" | \
    xargs -P "$MAX_JOBS" -I {} sh -c '
        file="$1"
        tujuan="$2"
        nama=$(basename "$file")
        cp -p "$file" "$tujuan/$nama"
    ' sh {} "$TUJUAN"

printf 'Backup selesai.\n'
```

**Catatan:** `xargs -P` tidak POSIX. Untuk versi portabel, gunakan loop dengan `&` dan `wait` (lihat 5.1.6).

### Skrip 3: Pencarian Cepat

```sh
#!/bin/sh
# Nama: cari_cepat.sh
# Tujuan: Mencari pola di banyak file

set -u

POLA="${1:?Penggunaan: $0 pola [direktori]}"
DIR="${2:-.}"

if [ ! -d "$DIR" ]; then
    printf 'Error: %s bukan direktori.\n' "$DIR" >&2
    exit 1
fi

LC_ALL=C
export LC_ALL

# Satu grep untuk semua file
find "$DIR" -type f -exec grep -l "$POLA" {} +
```

**Rasio:** Jauh lebih cepat daripada loop `grep`.

### Skrip 4: Pemrosesan CSV Besar

```sh
#!/bin/sh
# Nama: proses_csv.sh
# Tujuan: Memproses CSV besar dengan awk

set -u

CSV="${1:?Penggunaan: $0 file.csv}"

if [ ! -r "$CSV" ]; then
    printf 'Error: %s tidak dapat dibaca.\n' "$CSV" >&2
    exit 1
fi

LC_ALL=C
export LC_ALL

# Satu pass awk
awk -F, '
NR == 1 {
    for (i = 1; i <= NF; i++) {
        header[i] = $i
    }
    next
}
{
    for (i = 1; i <= NF; i++) {
        total[i] += $i
        count[i]++
    }
}
END {
    for (i = 1; i <= length(header); i++) {
        if (count[i] > 0) {
            printf "%-20s avg=%.2f\n", header[i], total[i] / count[i]
        }
    }
}
' "$CSV"
```

### Skrip 5: Monitor Log Real-Time

```sh
#!/bin/sh
# Nama: monitor.sh
# Tujuan: Monitor log dengan buffering minimal

set -u

LOG="${1:?Penggunaan: $0 file_log}"

if [ ! -r "$LOG" ]; then
    printf 'Error: %s tidak dapat dibaca.\n' "$LOG" >&2
    exit 1
fi

LC_ALL=C
export LC_ALL

# awk dengan fflush untuk output real-time
tail -f "$LOG" | awk '
/ERROR/ { printf "[ERROR] %s\n", $0; fflush() }
/WARN/  { printf "[WARN]  %s\n", $0; fflush() }
'
```

**Catatan:** `fflush()` tidak POSIX, tetapi didukung banyak `awk`.

---

## 5.1.15 Latihan

1. **Benchmark Dasar:**
   - Tulis skrip yang menjalankan `true` 10.000 kali dengan `while`.
   - Ukur dengan `time`.
   - Ganti `true` dengan `:` (built-in). Ukur lagi.
   - Hitung rasio.

2. **Basename:**
   - Tulis loop yang menggunakan `basename` untuk 1000 file.
   - Ganti dengan `${file##*/}`.
   - Bandingkan waktu.

3. **Dirname:**
   - Sama seperti latihan 2, tetapi dengan `dirname`.
   - Ganti dengan `case` + ekspansi parameter.

4. **Loop vs `xargs`:**
   - Buat 1000 file kosong.
   - Hapus dengan loop `for`.
   - Buat lagi, hapus dengan `find -exec ... +`.
   - Bandingkan waktu.

5. **Loop vs `awk`:**
   - Buat file dengan 100.000 baris angka.
   - Hitung total dengan loop `while` + `$(( ))`.
   - Hitung dengan `awk`.
   - Bandingkan.

6. **`grep` vs `awk`:**
   - Buat file log 100.000 baris.
   - Ekstrak semua "ERROR" dan cetak kolom pertama.
   - Versi 1: `grep | awk`.
   - Versi 2: `awk` saja.
   - Bandingkan.

7. **`LC_ALL=C`:**
   - Buat file dengan 1 juta baris.
   - `sort` dengan locale default.
   - `sort` dengan `LC_ALL=C`.
   - Bandingkan.

8. **Pipeline:**
   - Pipeline: `cat file | grep "x" | sort | uniq -c | sort -rn | head`.
   - Optimalkan: kurangi tahap.
   - Bandingkan waktu.

9. **Paralelisasi:**
   - Buat 100 file untuk diproses (misalnya `gzip`).
   - Proses serial.
   - Proses dengan 4 job paralel (loop `&` + `wait`).
   - Bandingkan.

10. **Profiling:**
    - Ambil skrip lambat yang Anda tulis.
    - Profile dengan `time` per bagian.
    - Identifikasi hotspot.
    - Optimalkan.

11. **Subshell:**
    - Tulis skrip yang menggunakan `$(cat file)` berulang.
    - Ganti dengan `while read < file`.
    - Bandingkan.

12. **Log Analysis:**
    - Buat log Apache sintetis 1 juta baris.
    - Ekstrak IP dan status code.
    - Hitung frekuensi status code.
    - Gunakan `awk` sekali.
    - Bandingkan dengan versi loop.

13. **Benchmark Framework:**
    - Buat fungsi `benchmark` yang menerima nama dan perintah.
    - Jalankan 5 kali, ambil rata-rata.
    - Gunakan untuk membandingkan dua implementasi.

14. **Optimasi Nyata:**
    - Ambil skrip dari proyek nyata (atau skrip Anda sendiri).
    - Ukur performanya.
    - Optimalkan dengan teknik di materi ini.
    - Ukur lagi. Dokumentasikan peningkatan.

15. **Analisis `strace`:**
    - Jalankan skrip dengan `strace -c`.
    - Identifikasi syscall yang paling banyak.
    - Optimalkan bagian yang sesuai.

---

## 5.1.16 Ringkasan Materi 1

- **Fork dan exec mahal.** Setiap perintah eksternal memerlukan fork + exec, yang memakan waktu CPU.
- **Built-in shell gratis.** `printf`, `[`, `:`, `read`, `cd`, `export` adalah built-in.
- **Ekspansi parameter** menggantikan `basename`, `dirname`, dan beberapa `sed`.
- **`$(...)` adalah subshell.** Kurangi jika tidak perlu.
- **Pipeline** membuat subshell di setiap sisi. Gunakan redirection jika memungkinkan.
- **`xargs` dan `find -exec ... +`** melakukan batching, mengurangi jumlah fork.
- **`LC_ALL=C`** mempercepat `grep`, `sed`, `awk`, `sort` 2x–10x.
- **`grep -F`** untuk string literal lebih cepat dari regex.
- **`sort -u`** menggantikan `sort | uniq`.
- **Satu `awk`** menggantikan banyak pipeline.
- **Paralelisasi** dengan `xargs -P` (GNU) atau loop `&` + `wait`.
- **Ukur dengan `time`** sebelum dan sesudah optimasi.
- **Profile dengan `strace -c`** untuk melihat syscall.
- **Anti-pattern**: UUOC, loop dengan perintah eksternal, `grep | awk`, `find -exec ... \;`.

**Prinsip utama:**

> **"Semakin sedikit fork, semakin cepat."**

---

## 📌 Selanjutnya

Materi 1 Level 5 selesai. Anda sekarang menguasai optimasi performa secara mendalam.

Berikutnya adalah **Materi 2: Arsitektur Skrip Kompleks** — kita akan membahas:

- **Modularisasi** dengan fungsi dan sourcing.
- **State management** — menyimpan dan memuat state.
- **Konfigurasi** — file konfigurasi, default, override.
- **Parsing argumen tingkat lanjut** dengan `getopts` dan manual.
- **Integrasi dengan bahasa lain** (Python, Perl) melalui pipe.
- **Membangun CLI tool** yang lengkap.
- **Logging** yang scalable.
- **Error handling** di skala besar.
- **Versioning** skrip.

## Materi 2: Arsitektur Skrip Kompleks

> **Catatan:** Ini adalah **materi kedua** dari Level 5, sesuai kurikulum yang sudah ditetapkan. Di Level 4 kita sudah membahas praktik terbaik dan `getopts`. Sekarang kita akan membangun **arsitektur** untuk skrip berskala besar: modularisasi, state management, konfigurasi berlapis, integrasi lintas bahasa, dan CLI tool yang lengkap. Setelah materi ini, Anda akan mampu membangun sistem shell yang kompleks namun tetap terpelihara.

---

## 🎯 Tujuan Materi 2

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Merancang **arsitektur modular** dengan pustaka yang dapat digunakan ulang.
2. Mengelola **state** skrip secara eksplisit dan aman.
3. Membangun **sistem konfigurasi berlapis**: default → file → environment → argumen.
4. Menguasai **parsing argumen tingkat lanjut** dengan `getopts` dan manual.
5. Mengintegrasikan shell dengan **Python, Perl, dan bahasa lain** via pipe.
6. Membangun **CLI tool** yang lengkap dengan subcommand.
7. Menerapkan **logging scalable** dengan level dan rotasi.
8. Menangani **error** di skala besar dengan kode error yang konsisten.
9. Melakukan **versioning** skrip dan kompatibilitas.
10. Mendokumentasikan arsitektur skrip untuk tim.

---

## 5.2.1 Mengapa Arsitektur Penting untuk Skrip Kompleks?

Skrip sederhana: 50–200 baris. Bisa ditulis dalam satu file.

Skrip kompleks: 1000+ baris, banyak fitur, banyak kontributor. Tanpa arsitektur:
- Sulit dipahami.
- Sulit diuji.
- Sulit diperluas.
- Rawan bug.
- Tidak dapat digunakan ulang.

**Arsitektur** memberikan:
- **Pemisahan tanggung jawab** — Setiap bagian melakukan satu hal.
- **Reusability** — Pustaka dapat digunakan di banyak skrip.
- **Testability** — Setiap unit dapat diuji terpisah.
- **Maintainability** — Perubahan terlokalisasi.
- **Scalability** — Mudah menambah fitur.

---

## 5.2.2 Modularisasi dengan Pustaka

### Struktur Direktori Proyek Kompleks

```
myapp/
├── bin/
│   └── myapp              # Entry point (skrip utama)
├── lib/
│   ├── core.sh            # Fungsi inti (log, error, util)
│   ├── config.sh          # Manajemen konfigurasi
│   ├── string.sh          # Manipulasi string
│   ├── file.sh            # Operasi file
│   ├── network.sh         # Fungsi jaringan
│   └── command/
│       ├── init.sh        # Subcommand: init
│       ├── run.sh         # Subcommand: run
│       └── status.sh      # Subcommand: status
├── etc/
│   └── myapp.conf.example # Konfigurasi contoh
├── test/
│   ├── unit/
│   └── integration/
├── doc/
│   └── ARCHITECTURE.md
├── Makefile
└── README.md
```

### Aturan Modularisasi

1. **Satu file = satu domain.** `string.sh` hanya berisi fungsi string.
2. **Namespace prefix.** `str_trim`, `file_ada`, `log_info`.
3. **Guard sourcing ganda.** Cegah load berulang.
4. **Dokumentasi setiap fungsi.**
5. **Tidak ada efek samping saat sourcing.** Sourcing pustaka tidak boleh menjalankan kode.
6. **Dependensi eksplisit.** Jika `command/run.sh` butuh `string.sh`, source di `run.sh`, bukan di `myapp`.

### Contoh: Pustaka Inti `lib/core.sh`

```sh
# lib/core.sh — Fungsi inti untuk semua skrip myapp.

if [ -n "${_MYAPP_CORE_LOADED:-}" ]; then
    return 0
fi
_MYAPP_CORE_LOADED=1

# ============================================================
# Konstanta Global
# ============================================================

MYAPP_VERSION="1.0.0"
MYAPP_NAME="myapp"

# Kode error standar
readonly E_SUCCESS=0
readonly E_GENERAL=1
readonly E_USAGE=2
readonly E_CONFIG=3
readonly E_NOTFOUND=4
readonly E_PERMISSION=5
readonly E_IO=6
readonly E_NETWORK=7

# ============================================================
# Logging
# ============================================================

: "${MYAPP_LOG_LEVEL:=INFO}"
: "${MYAPP_LOG_FILE:=}"

_log_level_num() {
    case "$1" in
        DEBUG) printf '0' ;;
        INFO)  printf '1' ;;
        WARN)  printf '2' ;;
        ERROR) printf '3' ;;
        FATAL) printf '4' ;;
        *)     printf '99' ;;
    esac
}

log() {
    level="$1"
    shift
    pesan="$*"

    level_num=$(_log_level_num "$level")
    min_num=$(_log_level_num "$MYAPP_LOG_LEVEL")

    [ "$level_num" -ge "$min_num" ] || return 0

    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    baris="[$timestamp] [$level] [$MYAPP_NAME] $pesan"

    printf '%s\n' "$baris" >&2

    if [ -n "$MYAPP_LOG_FILE" ]; then
        printf '%s\n' "$baris" >> "$MYAPP_LOG_FILE"
    fi

    return 0
}

log_debug() { log "DEBUG" "$@"; }
log_info()  { log "INFO"  "$@"; }
log_warn()  { log "WARN"  "$@"; }
log_error() { log "ERROR" "$@"; }
log_fatal() { log "FATAL" "$@"; }

# ============================================================
# Error Handling
# ============================================================

# die: Cetak pesan error dan keluar dengan kode.
#
# Argumen:
#   $1 - Kode exit.
#   $@ - Pesan.
die() {
    kode="$1"
    shift
    log_fatal "$@"
    exit "$kode"
}

# ============================================================
# Cleanup
# ============================================================

_MYAPP_CLEANUP_FUNCS=""

# cleanup_register: Daftarkan fungsi untuk dipanggil saat exit.
#
# Argumen:
#   $1 - Nama fungsi.
cleanup_register() {
    _MYAPP_CLEANUP_FUNCS="$_MYAPP_CLEANUP_FUNCS $1"
}

_cleanup_run() {
    status=$?
    for func in $_MYAPP_CLEANUP_FUNCS; do
        "$func" 2>/dev/null || true
    done
    exit "$status"
}

trap _cleanup_run EXIT INT TERM

# ============================================================
# Utilitas
# ============================================================

# require_cmd: Pastikan perintah tersedia, atau keluar.
#
# Argumen:
#   $1 - Nama perintah.
require_cmd() {
    if ! command -v "$1" > /dev/null 2>&1; then
        die "$E_NOTFOUND" "Perintah '$1' tidak ditemukan di PATH."
    fi
}

# require_file: Pastikan file ada dan dapat dibaca.
#
# Argumen:
#   $1 - Path file.
require_file() {
    if [ ! -f "$1" ]; then
        die "$E_NOTFOUND" "File tidak ditemukan: $1"
    fi
    if [ ! -r "$1" ]; then
        die "$E_PERMISSION" "File tidak dapat dibaca: $1"
    fi
}

# require_dir: Pastikan direktori ada.
#
# Argumen:
#   $1 - Path direktori.
require_dir() {
    if [ ! -d "$1" ]; then
        die "$E_NOTFOUND" "Direktori tidak ditemukan: $1"
    fi
}
```

**Poin penting:**

- Konstanta kode error global.
- Logging dengan level.
- Cleanup registration via trap.
- Fungsi `require_*` untuk precondition check.
- Guard sourcing ganda.
- Tidak ada efek samping saat sourcing (hanya definisi fungsi).

### Contoh: Pustaka Konfigurasi `lib/config.sh`

```sh
# lib/config.sh — Manajemen konfigurasi myapp.

if [ -n "${_MYAPP_CONFIG_LOADED:-}" ]; then
    return 0
fi
_MYAPP_CONFIG_LOADED=1

# State konfigurasi (disimpan di variabel global)
CONFIG_SOURCE=""
CONFIG_VERBOSE=0
CONFIG_TIMEOUT=30
CONFIG_OUTPUT_DIR=""
CONFIG_LOG_LEVEL="INFO"

# config_defaults: Set nilai default.
config_defaults() {
    CONFIG_SOURCE=""
    CONFIG_VERBOSE=0
    CONFIG_TIMEOUT=30
    CONFIG_OUTPUT_DIR="."
    CONFIG_LOG_LEVEL="INFO"
}

# config_load: Muat konfigurasi dari file.
#
# Format file: KEY=value atau KEY="value with spaces"
# Komentar: baris diawali #
#
# Argumen:
#   $1 - Path file konfigurasi.
config_load() {
    file="$1"

    if [ ! -f "$file" ]; then
        log_warn "File konfigurasi tidak ditemukan: $file"
        return 0
    fi

    log_debug "Memuat konfigurasi: $file"

    while IFS= read -r line || [ -n "$line" ]; do
        # Skip komentar dan baris kosong
        case "$line" in
            ''|\#*) continue ;;
        esac

        # Pisahkan KEY=value
        key="${line%%=*}"
        value="${line#*=}"

        # Hapus spasi di sekitar key
        key=$(printf '%s' "$key" | tr -d ' \t')

        # Hapus kutip dari value jika ada
        case "$value" in
            \"*\") value="${value#\"}" ; value="${value%\"}" ;;
            \'*\') value="${value#\'}" ; value="${value%\'}" ;;
        esac

        # Set variabel dengan prefix CONFIG_
        case "$key" in
            VERBOSE)     CONFIG_VERBOSE="$value" ;;
            TIMEOUT)     CONFIG_TIMEOUT="$value" ;;
            OUTPUT_DIR)  CONFIG_OUTPUT_DIR="$value" ;;
            LOG_LEVEL)   CONFIG_LOG_LEVEL="$value" ;;
            *)           log_warn "Konfigurasi tidak dikenal: $key" ;;
        esac
    done < "$file"

    CONFIG_SOURCE="$file"
    return 0
}

# config_apply_env: Override konfigurasi dari environment.
config_apply_env() {
    [ -n "${MYAPP_VERBOSE:-}" ]    && CONFIG_VERBOSE="$MYAPP_VERBOSE"
    [ -n "${MYAPP_TIMEOUT:-}" ]    && CONFIG_TIMEOUT="$MYAPP_TIMEOUT"
    [ -n "${MYAPP_OUTPUT_DIR:-}" ] && CONFIG_OUTPUT_DIR="$MYAPP_OUTPUT_DIR"
    [ -n "${MYAPP_LOG_LEVEL:-}" ]  && CONFIG_LOG_LEVEL="$MYAPP_LOG_LEVEL"
    return 0
}

# config_show: Tampilkan konfigurasi saat ini.
config_show() {
    printf 'Konfigurasi:\n'
    printf '  Source:      %s\n' "${CONFIG_SOURCE:-<default>}"
    printf '  Verbose:     %s\n' "$CONFIG_VERBOSE"
    printf '  Timeout:     %s\n' "$CONFIG_TIMEOUT"
    printf '  Output dir:  %s\n' "$CONFIG_OUTPUT_DIR"
    printf '  Log level:   %s\n' "$CONFIG_LOG_LEVEL"
}
```

**Poin penting:**

- Konfigurasi disimpan di variabel global dengan prefix `CONFIG_`.
- Sumber konfigurasi berlapis: default → file → environment → argumen.
- Fungsi `config_load` membaca file dengan aman.
- `config_show` untuk debugging.

### Contoh: Pustaka String `lib/string.sh`

```sh
# lib/string.sh — Fungsi manipulasi string.

if [ -n "${_MYAPP_STRING_LOADED:-}" ]; then
    return 0
fi
_MYAPP_STRING_LOADED=1

# str_trim: Hapus spasi di awal/akhir.
str_trim() {
    printf '%s' "$1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# str_upper: Ubah ke huruf besar.
str_upper() {
    printf '%s' "$1" | tr '[:lower:]' '[:upper:]'
}

# str_lower: Ubah ke huruf kecil.
str_lower() {
    printf '%s' "$1" | tr '[:upper:]' '[:lower:]'
}

# str_contains: Cek substring.
str_contains() {
    case "$1" in
        *"$2"*) return 0 ;;
        *) return 1 ;;
    esac
}

# str_starts_with: Cek awalan.
str_starts_with() {
    case "$1" in
        "$2"*) return 0 ;;
        *) return 1 ;;
    esac
}

# str_ends_with: Cek akhiran.
str_ends_with() {
    case "$1" in
        *"$2") return 0 ;;
        *) return 1 ;;
    esac
}

# str_repeat: Ulangi string n kali.
str_repeat() {
    str="$1"
    n="$2"
    i=0
    result=""
    while [ "$i" -lt "$n" ]; do
        result="${result}${str}"
        i=$((i + 1))
    done
    printf '%s' "$result"
}

# str_replace: Ganti semua kemunculan.
str_replace() {
    printf '%s' "$1" | sed "s|$2|$3|g"
}
```

### Entry Point `bin/myapp`

```sh
#!/bin/sh
# bin/myapp — Entry point untuk myapp.

set -u

# Tentukan direktori skrip
SCRIPT_PATH="$0"
case "$SCRIPT_PATH" in
    /*) ;;
    *) SCRIPT_PATH="$PWD/$SCRIPT_PATH" ;;
esac
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
BASE_DIR=$(dirname "$SCRIPT_DIR")
LIB_DIR="$BASE_DIR/lib"

# Source pustaka inti
. "$LIB_DIR/core.sh"

# Source subcommand sesuai argumen
COMMAND="${1:-help}"
shift 2>/dev/null || true

case "$COMMAND" in
    init|run|status|help|version)
        if [ -f "$LIB_DIR/command/${COMMAND}.sh" ]; then
            . "$LIB_DIR/command/${COMMAND}.sh"
            "cmd_${COMMAND}" "$@"
        else
            cmd_help
        fi
        ;;
    *)
        log_error "Perintah tidak dikenal: $COMMAND"
        cmd_help
        exit "$E_USAGE"
        ;;
esac
```

**Poin penting:**

- Menentukan `BASE_DIR` dari `$0`.
- Source pustaka inti.
- Dispatch ke subcommand berdasarkan argumen pertama.
- Setiap subcommand adalah file terpisah.

### Contoh Subcommand `lib/command/init.sh`

```sh
# lib/command/init.sh — Subcommand: init.

cmd_init() {
    # Validasi
    require_cmd mkdir

    # Parsing argumen
    while [ $# -gt 0 ]; do
        case "$1" in
            -o|--output)
                CONFIG_OUTPUT_DIR="$2"
                shift 2
                ;;
            -h|--help)
                cat <<EOF
Penggunaan: myapp init [opsi]

Opsi:
  -o, --output DIR    Direktori output (default: .)
  -h, --help          Tampilkan bantuan
EOF
                return 0
                ;;
            *)
                log_error "Opsi tidak dikenal: $1"
                return "$E_USAGE"
                ;;
        esac
    done

    # Inisialisasi
    log_info "Menginisialisasi di: $CONFIG_OUTPUT_DIR"

    if ! mkdir -p "$CONFIG_OUTPUT_DIR"; then
        log_error "Gagal membuat direktori: $CONFIG_OUTPUT_DIR"
        return "$E_IO"
    fi

    log_info "Inisialisasi selesai."
    return 0
}
```

**Poin penting:**

- Setiap subcommand adalah fungsi dengan prefix `cmd_`.
- Parsing argumen di subcommand.
- Return kode error.

---

## 5.2.3 State Management

**State** adalah data yang bertahan antar pemanggilan fungsi atau antar eksekusi skrip.

### Jenis State

1. **In-memory state** — Variabel global. Hilang saat skrip selesai.
2. **File state** — Disimpan di file. Bertahan antar eksekusi.
3. **Environment state** — Diwariskan ke proses anak.

### In-Memory State

Gunakan variabel global dengan prefix yang jelas:

```sh
# lib/core.sh

# State global
STATE_APP_RUNNING=0
STATE_APP_PID=""
STATE_APP_START_TIME=""
STATE_APP_FILES_PROCESSED=0
```

**Aturan:**

- Prefix `STATE_` untuk state.
- Inisialisasi di fungsi `state_init`.
- Reset di fungsi `state_reset`.

### File State

Untuk state yang perlu bertahan:

```sh
# State disimpan di file
STATE_FILE="/var/lib/myapp/state"

state_load() {
    if [ -f "$STATE_FILE" ]; then
        # Baca file sebagai key=value
        while IFS='=' read -r key value; do
            case "$key" in
                ''|'#'*) continue ;;
                last_run) STATE_LAST_RUN="$value" ;;
                counter)  STATE_COUNTER="$value" ;;
            esac
        done < "$STATE_FILE"
    fi
}

state_save() {
    tmp="${STATE_FILE}.tmp.$$"
    {
        printf 'last_run=%s\n' "$(date +%s)"
        printf 'counter=%s\n' "$STATE_COUNTER"
    } > "$tmp" && mv "$tmp" "$STATE_FILE"
}

state_reset() {
    rm -f "$STATE_FILE"
}
```

**Poin penting:**

- Atomic write dengan file temporary + `mv`.
- Format `key=value` sederhana.
- Prefix `STATE_` untuk variabel.

### State untuk Lock

```sh
LOCK_DIR="/var/lock/myapp.lock"

state_lock() {
    if ! mkdir "$LOCK_DIR" 2>/dev/null; then
        # Cek apakah lock stale
        old_pid=""
        if [ -f "$LOCK_DIR/pid" ]; then
            old_pid=$(cat "$LOCK_DIR/pid")
        fi
        
        if [ -n "$old_pid" ] && kill -0 "$old_pid" 2>/dev/null; then
            log_error "Sudah berjalan dengan PID $old_pid"
            return "$E_GENERAL"
        fi
        
        log_warn "Menghapus lock stale"
        rm -rf "$LOCK_DIR"
        
        if ! mkdir "$LOCK_DIR" 2>/dev/null; then
            log_error "Tidak dapat memperoleh lock"
            return "$E_GENERAL"
        fi
    fi
    
    printf '%s\n' "$$" > "$LOCK_DIR/pid"
    return 0
}

state_unlock() {
    rm -rf "$LOCK_DIR" 2>/dev/null || true
}

cleanup_register state_unlock
```

**Poin penting:**

- Lock menggunakan `mkdir` (atomic).
- PID disimpan untuk deteksi stale lock.
- Cleanup terdaftar.

---

## 5.2.4 Konfigurasi Berlapis

Konfigurasi yang baik memiliki **prioritas berlapis**:

```
1. Default (hardcoded)
2. File konfigurasi sistem: /etc/myapp/myapp.conf
3. File konfigurasi pengguna: ~/.config/myapp/myapp.conf
4. File konfigurasi lokal: ./myapp.conf
5. Environment variable: MYAPP_*
6. Argumen command line (prioritas tertinggi)
```

Setiap lapisan **menimpa** lapisan sebelumnya.

### Implementasi

```sh
# lib/config.sh

config_init() {
    # Lapisan 1: Default
    config_defaults
    
    # Lapisan 2: Sistem
    if [ -f "/etc/myapp/myapp.conf" ]; then
        config_load "/etc/myapp/myapp.conf"
    fi
    
    # Lapisan 3: Pengguna
    user_conf="${HOME}/.config/myapp/myapp.conf"
    if [ -f "$user_conf" ]; then
        config_load "$user_conf"
    fi
    
    # Lapisan 4: Lokal
    if [ -f "./myapp.conf" ]; then
        config_load "./myapp.conf"
    fi
    
    # Lapisan 5: Environment
    config_apply_env
    
    # Lapisan 6: Argumen (diproses di main)
}
```

### Format File Konfigurasi

```
# myapp.conf — Konfigurasi myapp

# Verbose mode (0 atau 1)
VERBOSE=0

# Timeout dalam detik
TIMEOUT=30

# Direktori output
OUTPUT_DIR=/var/lib/myapp

# Level log: DEBUG, INFO, WARN, ERROR
LOG_LEVEL=INFO
```

### Parsing yang Aman

```sh
config_load() {
    file="$1"
    
    while IFS= read -r line || [ -n "$line" ]; do
        # Skip komentar dan baris kosong
        case "$line" in
            ''|\#*) continue ;;
        esac
        
        # Validasi format KEY=value
        case "$line" in
            *=*) ;;
            *)
                log_warn "Format tidak valid: $line"
                continue
                ;;
        esac
        
        key="${line%%=*}"
        value="${line#*=}"
        
        # Hapus spasi di key
        key=$(printf '%s' "$key" | tr -d ' \t')
        
        # Hapus kutip dari value
        case "$value" in
            \"*\") value="${value#\"}" ; value="${value%\"}" ;;
            \'*\') value="${value#\'}" ; value="${value%\'}" ;;
        esac
        
        # Set variabel
        case "$key" in
            VERBOSE)    CONFIG_VERBOSE="$value" ;;
            TIMEOUT)    CONFIG_TIMEOUT="$value" ;;
            OUTPUT_DIR) CONFIG_OUTPUT_DIR="$value" ;;
            LOG_LEVEL)  CONFIG_LOG_LEVEL="$value" ;;
            *)          log_warn "Key tidak dikenal: $key" ;;
        esac
    done < "$file"
}
```

### Keamanan File Konfigurasi

Jangan pernah `source` file konfigurasi dari lokasi yang tidak dipercaya:

```sh
# BAHAYA — file konfigurasi bisa berisi kode berbahaya
. "$CONFIG_FILE"

# AMAN — parsing key=value
config_load "$CONFIG_FILE"
```

File konfigurasi bisa berisi:

```sh
# Serangan
VERBOSE=1
rm -rf /home/budi/*   # Dieksekusi jika di-source
```

**Selalu parsing sebagai data, bukan source.**

---

## 5.2.5 Parsing Argumen Tingkat Lanjut

### Kombinasi `getopts` dan Opsi Panjang

```sh
# lib/args.sh

# args_parse: Parsing argumen dengan dukungan opsi pendek dan panjang.
#
# Set variabel global:
#   ARGS_COMMAND
#   ARGS_VERBOSE
#   ARGS_OUTPUT
#   ARGS_FILES
args_parse() {
    ARGS_VERBOSE=0
    ARGS_OUTPUT=""
    ARGS_FILES=""
    
    # Preprocess opsi panjang → pendek
    args=""
    for arg in "$@"; do
        case "$arg" in
            --help)        args="$args -h" ;;
            --verbose)     args="$args -v" ;;
            --output)      args="$args -o" ;;
            --output=*)    args="$args -o ${arg#--output=}" ;;
            --)            args="$args --"; shift; break ;;
            *)             args="$args $arg" ;;
        esac
    done
    
    # Setelah --, argumen lain adalah file
    # shellcheck disable=SC2086
    set -- $args
    
    while getopts "hvo:" opt; do
        case "$opt" in
            h) args_help; exit 0 ;;
            v) ARGS_VERBOSE=1 ;;
            o) ARGS_OUTPUT="$OPTARG" ;;
            \?) return "$E_USAGE" ;;
            :) return "$E_USAGE" ;;
        esac
    done
    
    shift $((OPTIND - 1))
    
    # Sisa argumen adalah file
    ARGS_FILES="$*"
    return 0
}

args_help() {
    cat <<EOF
Penggunaan: myapp [opsi] [file...]

Opsi:
  -h, --help              Tampilkan bantuan
  -v, --verbose           Mode verbose
  -o, --output FILE       File output
EOF
}
```

**Catatan:** Preprocessing dengan `set -- $args` tidak aman untuk argumen dengan spasi. Untuk kasus serius, parsing manual lebih baik.

### Parsing Manual yang Aman

```sh
args_parse() {
    ARGS_VERBOSE=0
    ARGS_OUTPUT=""
    ARGS_FILES=""
    
    while [ $# -gt 0 ]; do
        case "$1" in
            -h|--help)
                args_help
                exit 0
                ;;
            -v|--verbose)
                ARGS_VERBOSE=1
                shift
                ;;
            -o|--output)
                if [ -z "${2:-}" ]; then
                    log_error "Opsi $1 memerlukan argumen."
                    return "$E_USAGE"
                fi
                ARGS_OUTPUT="$2"
                shift 2
                ;;
            --output=*)
                ARGS_OUTPUT="${1#--output=}"
                shift
                ;;
            --)
                shift
                # Sisa argumen adalah file
                while [ $# -gt 0 ]; do
                    ARGS_FILES="$ARGS_FILES $1"
                    shift
                done
                ;;
            -*)
                log_error "Opsi tidak dikenal: $1"
                return "$E_USAGE"
                ;;
            *)
                # Argumen non-opsi
                ARGS_FILES="$ARGS_FILES $1"
                shift
                ;;
        esac
    done
    
    return 0
}
```

**Catatan:** `ARGS_FILES` sebagai string membatasi nama file dengan spasi. Untuk solusi yang lebih baik, gunakan variabel yang menyimpan daftar:

```sh
ARGS_FILES_COUNT=0
ARGS_FILES_1=""
ARGS_FILES_2=""
# ...
```

Atau, simpan argumen posisi setelah parsing:

```sh
args_parse() {
    # ... parsing opsi ...
    
    # Setelah parsing, $@ berisi argumen non-opsi
    # Simpan di global via "$@"
    ARGS_POSITIONAL="$@"
}
```

Tetapi cara paling bersih adalah parsing dan eksekusi dalam satu fungsi.

---

## 5.2.6 Integrasi dengan Bahasa Lain

Shell bagus untuk orkestrasi, tetapi terbatas untuk komputasi kompleks. Integrasikan dengan Python, Perl, atau bahasa lain via pipe.

### Integrasi dengan `python`

```sh
# Kompleks: shell memanggil python untuk komputasi
hasil=$(python3 -c '
import sys
data = sys.stdin.read()
# Proses data
print(len(data.split()))
' <<EOF
$input
EOF
)
```

### Contoh: JSON Parsing

Shell tidak memiliki parser JSON. Gunakan Python:

```sh
# parse_json: Ekstrak nilai dari JSON.
#
# Argumen:
#   $1 - JSON string.
#   $2 - Key.
parse_json() {
    json="$1"
    key="$2"
    
    printf '%s' "$json" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    print(data.get('$key', ''))
except Exception as e:
    print('', file=sys.stderr)
    sys.exit(1)
"
}
```

**Catatan:** Injeksi `$key` ke dalam kode Python berbahaya jika `$key` tidak dipercaya. Gunakan argumen:

```sh
printf '%s' "$json" | python3 -c '
import json, sys
data = json.load(sys.stdin)
print(data.get(sys.argv[1], ""))
' "$key"
```

### Contoh: Perhitungan Floating-Point Kompleks

```sh
# Komputasi dengan Python
hasil=$(python3 -c '
import math
x = float(sys.argv[1])
print(math.sqrt(x) * math.pi)
' "$angka")
```

**Catatan:** `python3` tidak selalu tersedia. Cek dengan `command -v`.

### Integrasi dengan `perl`

Perl hampir selalu tersedia di sistem Unix:

```sh
# Regex kompleks dengan perl
printf '%s' "$input" | perl -ne 'print if /^\d{3}-\d{4}$/'
```

### Contoh: `perl` untuk Regex Lanjutan

```sh
# Cari semua email dengan regex kompleks
perl -ne 'while (/([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})/g) { print "$1\n" }' file.txt
```

### Kapan Integrasi Berguna?

| Tugas | Shell | Python/Perl |
|-------|-------|-------------|
| Parsing JSON | Sulit | Mudah |
| Regex kompleks | Terbatas | Kaya |
| Komputasi floating-point | Terbatas | Mudah |
| Manipulasi string kompleks | Terbatas | Kaya |
| HTTP request | `curl` | `requests` |
| Database | `sqlite3` | `sqlite3` library |
| Orkestrasi | **Excellent** | OK |
| File I/O | **Excellent** | OK |

### Prinsip Integrasi

1. **Shell untuk orkestrasi.** Memanggil perintah, mengelola alur.
2. **Python/Perl untuk komputasi.** Parsing, regex kompleks.
3. **Pipe sebagai antarmuka.** Data mengalir via stdin/stdout.
4. **Cek ketersediaan.** `command -v python3` sebelum digunakan.
5. **Hindari injeksi.** Gunakan argumen, bukan interpolasi string.

### Contoh: Pipeline Shell + Python

```sh
#!/bin/sh

require_cmd python3

# Baca log, filter dengan shell, proses dengan Python
grep "ERROR" access.log | \
    awk '{ print $1, $4, $9 }' | \
    python3 -c '
import sys
from collections import Counter

ips = Counter()
codes = Counter()

for line in sys.stdin:
    parts = line.split()
    if len(parts) >= 3:
        ips[parts[0]] += 1
        codes[parts[2]] += 1

print("Top 10 IP:")
for ip, count in ips.most_common(10):
    print(f"  {ip}: {count}")

print("\nStatus codes:")
for code, count in sorted(codes.items()):
    print(f"  {code}: {count}")
'
```

**Poin penting:**

- `grep` dan `awk` untuk filter awal (cepat).
- Python untuk agregasi dan format (ekspresif).
- Pipe sebagai jembatan.

---

## 5.2.7 Membangun CLI Tool yang Lengkap

CLI tool yang baik memiliki:

1. **Subcommand** — `myapp init`, `myapp run`, `myapp status`.
2. **Global options** — `-v`, `--verbose`, `--config`.
3. **Subcommand-specific options.**
4. **Help** — `myapp help`, `myapp help init`.
5. **Version** — `myapp version`.
6. **Exit codes** yang konsisten.
7. **Error messages** yang jelas.

### Arsitektur CLI

```
myapp <global-options> <command> <command-options> <args>
```

### Contoh Entry Point

```sh
#!/bin/sh
# bin/myapp

set -u

SCRIPT_PATH="$0"
case "$SCRIPT_PATH" in
    /*) ;;
    *) SCRIPT_PATH="$PWD/$SCRIPT_PATH" ;;
esac
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
BASE_DIR=$(dirname "$SCRIPT_DIR")
LIB_DIR="$BASE_DIR/lib"

. "$LIB_DIR/core.sh"

# Parsing global options
GLOBAL_VERBOSE=0
GLOBAL_CONFIG=""

while [ $# -gt 0 ]; do
    case "$1" in
        -v|--verbose)
            GLOBAL_VERBOSE=1
            MYAPP_LOG_LEVEL=DEBUG
            shift
            ;;
        -c|--config)
            if [ -z "${2:-}" ]; then
                log_error "Opsi $1 memerlukan argumen."
                exit "$E_USAGE"
            fi
            GLOBAL_CONFIG="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        -*)
            log_error "Opsi global tidak dikenal: $1"
            exit "$E_USAGE"
            ;;
        *)
            break
            ;;
    esac
done

# Muat konfigurasi
config_init
[ -n "$GLOBAL_CONFIG" ] && config_load "$GLOBAL_CONFIG"
config_apply_env
MYAPP_LOG_LEVEL="$CONFIG_LOG_LEVEL"

# Dispatch subcommand
COMMAND="${1:-help}"
[ $# -gt 0 ] && shift

case "$COMMAND" in
    init|run|status)
        . "$LIB_DIR/command/${COMMAND}.sh"
        "cmd_${COMMAND}" "$@"
        ;;
    help)
        cmd_help "$@"
        ;;
    version)
        printf '%s %s\n' "$MYAPP_NAME" "$MYAPP_VERSION"
        ;;
    *)
        log_error "Perintah tidak dikenal: $COMMAND"
        cmd_help
        exit "$E_USAGE"
        ;;
esac
```

### Subcommand Help

```sh
# lib/command/help.sh

cmd_help() {
    topik="${1:-}"
    
    if [ -n "$topik" ] && [ -f "$LIB_DIR/command/${topik}.sh" ]; then
        # Tampilkan help untuk subcommand tertentu
        case "$topik" in
            init)   cmd_init --help ;;
            run)    cmd_run --help ;;
            status) cmd_status --help ;;
        esac
        return 0
    fi
    
    cat <<EOF
Penggunaan: $MYAPP_NAME [opsi-global] <perintah> [opsi-perintah] [argumen]

Perintah:
  init        Inisialisasi konfigurasi
  run         Jalankan operasi utama
  status      Tampilkan status
  help        Tampilkan bantuan
  version     Tampilkan versi

Opsi Global:
  -v, --verbose       Mode verbose
  -c, --config FILE   File konfigurasi

Contoh:
  $MYAPP_NAME init
  $MYAPP_NAME -v run --output /tmp
  $MYAPP_NAME help init
EOF
}
```

**Poin penting:**

- Help untuk topik spesifik.
- Format konsisten.
- Contoh penggunaan.

---

## 5.2.8 Logging Scalable

### Level Log Dinamis

```sh
# Level: DEBUG < INFO < WARN < ERROR < FATAL
# Hanya cetak jika level >= MYAPP_LOG_LEVEL
```

Sudah diimplementasikan di `lib/core.sh`.

### Log Rotasi

Log yang tumbuh tanpa batas akan menghabiskan disk. Rotasi log:

```sh
# lib/log_rotate.sh

# log_rotate: Rotasi file log jika melebihi ukuran.
#
# Argumen:
#   $1 - Path file log.
#   $2 - Ukuran maksimum (byte).
#   $3 - Jumlah file backup.
log_rotate() {
    log_file="$1"
    max_size="$2"
    max_backups="${3:-5}"
    
    [ -f "$log_file" ] || return 0
    
    ukuran=$(wc -c < "$log_file" | tr -d ' ')
    
    if [ "$ukuran" -lt "$max_size" ]; then
        return 0
    fi
    
    # Rotasi
    i="$max_backups"
    while [ "$i" -gt 1 ]; do
        prev=$((i - 1))
        if [ -f "${log_file}.${prev}" ]; then
            mv "${log_file}.${prev}" "${log_file}.${i}"
        fi
        i=$((i - 1))
    done
    
    mv "$log_file" "${log_file}.1"
    : > "$log_file"
    
    log_info "Log dirotasi: $log_file"
    return 0
}
```

### Log dengan Context

```sh
# log dengan konteks (fungsi, PID, line)
log_context() {
    level="$1"
    shift
    pesan="$*"
    
    # Konteks dari caller
    # (tidak ada cara POSIX untuk mendapatkan nama fungsi caller)
    # Gunakan PID atau identifier lain
    
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    printf '[%s] [%s] [PID:%d] %s\n' "$timestamp" "$level" "$$" "$pesan" >&2
}
```

### Structured Logging (JSON)

```sh
# log_json: Log dalam format JSON.
log_json() {
    level="$1"
    pesan="$2"
    
    timestamp=$(date '+%Y-%m-%dT%H:%M:%S')
    
    # Escape quote di pesan
    pesan_escaped=$(printf '%s' "$pesan" | sed 's/"/\\"/g')
    
    printf '{"timestamp":"%s","level":"%s","message":"%s","pid":%d}\n' \
        "$timestamp" "$level" "$pesan_escaped" "$$" >&2
}
```

**Catatan:** Untuk logging serius, pertimbangkan `syslog` via `logger`:

```sh
logger -t myapp -p user.info "Pesan log"
```

---

## 5.2.9 Error Handling di Skala Besar

### Kode Error yang Konsisten

Definisikan kode error di satu tempat:

```sh
# lib/core.sh

readonly E_SUCCESS=0
readonly E_GENERAL=1
readonly E_USAGE=2
readonly E_CONFIG=3
readonly E_NOTFOUND=4
readonly E_PERMISSION=5
readonly E_IO=6
readonly E_NETWORK=7
readonly E_TIMEOUT=8
readonly E_DEPENDENCY=9
```

### Error Context

```sh
# error_with_context: Log error dengan konteks.
error_with_context() {
    kode="$1"
    shift
    pesan="$*"
    
    log_error "$pesan"
    log_debug "Konteks: PWD=$PWD, USER=${USER:-?}, PID=$$"
    
    return "$kode"
}
```

### Propagation

```sh
# Setiap fungsi mengembalikan kode error
# Caller harus memeriksa

fungsi_a() {
    fungsi_b || return $?
    return 0
}

fungsi_b() {
    fungsi_c || return $?
    return 0
}

fungsi_c() {
    if [ ! -f "$file" ]; then
        log_error "File tidak ada"
        return "$E_NOTFOUND"
    fi
    return 0
}
```

### Central Error Handler

```sh
# lib/core.sh

handle_error() {
    kode="$1"
    pesan="$2"
    
    log_error "$pesan"
    
    case "$kode" in
        "$E_USAGE")     log_info "Gunakan --help untuk bantuan." ;;
        "$E_CONFIG")    log_info "Periksa file konfigurasi Anda." ;;
        "$E_PERMISSION") log_info "Periksa izin file." ;;
    esac
    
    exit "$kode"
}
```

---

## 5.2.10 Versioning Skrip

### Semantic Versioning

Format: `MAJOR.MINOR.PATCH`

- **MAJOR** — Perubahan tidak kompatibel.
- **MINOR** — Fitur baru, kompatibel.
- **PATCH** — Bug fix, kompatibel.

```sh
MYAPP_VERSION="1.2.3"
```

### Menampilkan Versi

```sh
cmd_version() {
    printf '%s %s\n' "$MYAPP_NAME" "$MYAPP_VERSION"
    printf 'Shell: %s\n' "$SHELL"
    printf 'POSIX: sh\n'
}
```

### Version Check

```sh
# require_version: Cek versi minimum.
require_version() {
    minimum="$1"
    
    # Bandingkan versi (simple)
    if [ "$MYAPP_VERSION" = "$minimum" ]; then
        return 0
    fi
    
    # Bandingkan secara numerik (asumsi format X.Y.Z)
    my_major=$(printf '%s' "$MYAPP_VERSION" | cut -d. -f1)
    my_minor=$(printf '%s' "$MYAPP_VERSION" | cut -d. -f2)
    my_patch=$(printf '%s' "$MYAPP_VERSION" | cut -d. -f3)
    
    min_major=$(printf '%s' "$minimum" | cut -d. -f1)
    min_minor=$(printf '%s' "$minimum" | cut -d. -f2)
    min_patch=$(printf '%s' "$minimum" | cut -d. -f3)
    
    if [ "$my_major" -gt "$min_major" ]; then return 0; fi
    if [ "$my_major" -lt "$min_major" ]; then return 1; fi
    if [ "$my_minor" -gt "$min_minor" ]; then return 0; fi
    if [ "$my_minor" -lt "$min_minor" ]; then return 1; fi
    if [ "$my_patch" -ge "$min_patch" ]; then return 0; fi
    
    return 1
}
```

### Changelog

Simpan `CHANGELOG.md`:

```markdown
# Changelog

## [1.2.0] - 2026-01-01
### Added
- Subcommand `status`
- Dukungan konfigurasi JSON

### Fixed
- Bug pada parsing argumen dengan spasi

## [1.1.0] - 2025-12-01
### Added
- Subcommand `run`
```

---

## 5.2.11 Dokumentasi Arsitektur

`doc/ARCHITECTURE.md`:

```markdown
# Arsitektur MyApp

## Overview

MyApp adalah CLI tool untuk ... Arsitektur modular dengan
pemisahan pustaka, subcommand, dan konfigurasi berlapis.

## Struktur Direktori

```
bin/myapp           Entry point
lib/core.sh         Fungsi inti: log, error, cleanup
lib/config.sh       Manajemen konfigurasi
lib/string.sh       Manipulasi string
lib/command/*.sh    Subcommand
```

## Alur Eksekusi

1. `bin/myapp` mem-parsing global options.
2. Memuat konfigurasi berlapis.
3. Dispatch ke subcommand.
4. Subcommand mem-parsing opsi spesifik.
5. Menjalankan operasi.
6. Cleanup via trap.

## State

- In-memory: Variabel dengan prefix `CONFIG_`, `STATE_`, `ARGS_`.
- File: `$STATE_FILE` dengan format `key=value`.

## Konfigurasi

Prioritas (rendah ke tinggi):
1. Default
2. `/etc/myapp/myapp.conf`
3. `~/.config/myapp/myapp.conf`
4. `./myapp.conf`
5. Environment `MYAPP_*`
6. Argumen command line

## Error Handling

- Kode error standar di `lib/core.sh`.
- Setiap fungsi mengembalikan kode error.
- Caller memeriksa dan propagate.
- `die` untuk error fatal.
- `trap EXIT` untuk cleanup.

## Logging

- Level: DEBUG < INFO < WARN < ERROR < FATAL.
- Output ke stderr.
- Opsional ke file via `MYAPP_LOG_FILE`.
- Format: `[timestamp] [level] [app] message`.

## Testing

- Unit test di `test/unit/` untuk setiap pustaka.
- Integration test di `test/integration/` untuk CLI.
- Dijalankan via `make test`.

## Versioning

Semantic versioning: MAJOR.MINOR.PATCH.
Lihat `CHANGELOG.md`.
```

---

## 5.2.12 Contoh Proyek Lengkap

Mari kita lihat struktur proyek lengkap dengan semua komponen.

```
myapp/
├── bin/
│   └── myapp
├── lib/
│   ├── core.sh
│   ├── config.sh
│   ├── string.sh
│   ├── file.sh
│   └── command/
│       ├── init.sh
│       ├── run.sh
│       ├── status.sh
│       └── help.sh
├── etc/
│   └── myapp.conf.example
├── test/
│   ├── unit/
│   │   ├── test_string.sh
│   │   └── test_config.sh
│   └── integration/
│       └── test_cli.sh
├── doc/
│   ├── ARCHITECTURE.md
│   └── README.md
├── Makefile
├── CHANGELOG.md
├── LICENSE
└── README.md
```

### `Makefile`

```makefile
.PHONY: all test install clean

PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
LIBDIR = $(PREFIX)/lib/myapp
CONFDIR = /etc/myapp

all: test

test:
	@echo "Menjalankan unit test..."
	@for t in test/unit/*.sh; do \
		[ -f "$$t" ] || continue; \
		echo "  $$t"; \
		sh "$$t" || exit 1; \
	done
	@echo "Menjalankan integration test..."
	@for t in test/integration/*.sh; do \
		[ -f "$$t" ] || continue; \
		echo "  $$t"; \
		sh "$$t" || exit 1; \
	done
	@echo "Semua test lulus."

lint:
	@for f in bin/myapp lib/*.sh lib/command/*.sh; do \
		shellcheck -s sh "$$f" || exit 1; \
	done

install:
	install -d $(DESTDIR)$(BINDIR)
	install -d $(DESTDIR)$(LIBDIR)
	install -d $(DESTDIR)$(LIBDIR)/command
	install -d $(DESTDIR)$(CONFDIR)
	install -m 755 bin/myapp $(DESTDIR)$(BINDIR)/myapp
	install -m 644 lib/*.sh $(DESTDIR)$(LIBDIR)/
	install -m 644 lib/command/*.sh $(DESTDIR)$(LIBDIR)/command/
	[ -f $(DESTDIR)$(CONFDIR)/myapp.conf ] || \
		install -m 644 etc/myapp.conf.example $(DESTDIR)$(CONFDIR)/myapp.conf

clean:
	rm -f /tmp/myapp.*
```

### `test/unit/test_string.sh`

```sh
#!/bin/sh

. "$(dirname "$0")/../../lib/string.sh"

PASS=0
FAIL=0

assert_eq() {
    expected="$1"
    actual="$2"
    msg="$3"
    
    if [ "$expected" = "$actual" ]; then
        PASS=$((PASS + 1))
    else
        FAIL=$((FAIL + 1))
        printf 'FAIL: %s\n' "$msg"
        printf '  Expected: [%s]\n' "$expected"
        printf '  Actual:   [%s]\n' "$actual"
    fi
}

assert_eq "hello"  "$(str_trim '  hello  ')"   "trim spasi"
assert_eq "hello"  "$(str_trim 'hello')"       "trim tanpa spasi"
assert_eq ""       "$(str_trim '   ')"         "trim semua spasi"
assert_eq "HELLO"  "$(str_upper 'hello')"      "upper"
assert_eq "hello"  "$(str_lower 'HELLO')"      "lower"
assert_eq "aaabbb" "$(str_repeat 'ab' 3)"      "repeat"

printf '\n%d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
```

### `test/integration/test_cli.sh`

```sh
#!/bin/sh

MYAPP="$(dirname "$0")/../../bin/myapp"

PASS=0
FAIL=0

assert_contains() {
    haystack="$1"
    needle="$2"
    msg="$3"
    
    case "$haystack" in
        *"$needle"*) PASS=$((PASS + 1)) ;;
        *)
            FAIL=$((FAIL + 1))
            printf 'FAIL: %s\n' "$msg"
            printf '  Expected contains: [%s]\n' "$needle"
            printf '  Got: [%s]\n' "$haystack"
            ;;
    esac
}

# Test: version
output=$("$MYAPP" version 2>&1)
assert_contains "$output" "myapp" "version menampilkan nama"

# Test: help
output=$("$MYAPP" help 2>&1)
assert_contains "$output" "Penggunaan" "help menampilkan penggunaan"

# Test: unknown command
output=$("$MYAPP" nonexistent 2>&1)
assert_contains "$output" "tidak dikenal" "unknown command"

printf '\n%d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
```

---

## 5.2.13 Latihan

1. **Modularisasi:**
   - Ambil skrip besar yang Anda tulis.
   - Identifikasi domain: string, file, log, config.
   - Pecah menjadi pustaka.
   - Buat entry point.

2. **Guard Sourcing:**
   - Tambahkan guard sourcing ganda ke setiap pustaka.
   - Uji dengan source dua kali.

3. **Konfigurasi Berlapis:**
   - Buat sistem konfigurasi dengan 3 lapisan: default, file, environment.
   - Implementasi parsing yang aman.
   - Uji prioritas.

4. **State File:**
   - Buat state file untuk menyimpan counter.
   - Load, increment, save.
   - Uji dengan beberapa eksekusi.

5. **Lock File:**
   - Implementasi lock dengan `mkdir`.
   - Handle stale lock.
   - Cleanup via trap.

6. **Subcommand:**
   - Buat CLI dengan 3 subcommand: `init`, `run`, `status`.
   - Setiap subcommand punya opsi sendiri.
   - Help untuk setiap subcommand.

7. **Parsing Argumen:**
   - Implementasi parsing manual yang aman untuk argumen dengan spasi.
   - Uji dengan `./myapp --output "file with spaces.txt"`.

8. **Integrasi Python:**
   - Buat skrip shell yang memanggil Python untuk parsing JSON.
   - Pastikan tidak ada injeksi.

9. **Log Rotasi:**
   - Implementasi rotasi log sederhana.
   - Uji dengan file log besar.

10. **Testing:**
    - Tulis unit test untuk pustaka string.
    - Tulis integration test untuk CLI.
    - Jalankan via `make test`.

11. **Dokumentasi:**
    - Tulis `ARCHITECTURE.md` untuk proyek Anda.
    - Jelaskan alur eksekusi, state, konfigurasi.

12. **Versioning:**
    - Implementasi `version` subcommand.
    - Buat `CHANGELOG.md`.
    - Buat tag git.

13. **Refactor:**
    - Ambil skrip monolitik Anda.
    - Refaktor menjadi arsitektur modular.
    - Bandingkan sebelum dan sesudah.

14. **Review:**
    - Minta orang lain membaca kode Anda.
    - Identifikasi area yang sulit dipahami.
    - Perbaiki.

---

## 5.2.14 Ringkasan Materi 2

- **Modularisasi** dengan pustaka: satu file = satu domain, namespace prefix, guard sourcing.
- **Entry point** `bin/myapp` menentukan `BASE_DIR`, source pustaka, dispatch subcommand.
- **Subcommand** adalah file terpisah dengan fungsi `cmd_<name>`.
- **State management**: in-memory (variabel global), file state (`key=value`), lock file.
- **Konfigurasi berlapis**: default → sistem → pengguna → lokal → environment → argumen.
- **Parsing argumen** dengan `getopts` untuk opsi pendek, manual untuk opsi panjang.
- **Integrasi bahasa lain** via pipe: shell untuk orkestrasi, Python/Perl untuk komputasi.
- **CLI tool**: subcommand, global options, help, version.
- **Logging scalable**: level, rotasi, format konsisten.
- **Error handling**: kode error standar, propagation, central handler.
- **Versioning**: semantic versioning, changelog.
- **Dokumentasi arsitektur** untuk tim.
- **Testing**: unit test + integration test, otomatisasi via `make`.

**Prinsip utama:**

> **"Skrip kompleks adalah sistem. Sistem memerlukan arsitektur."**

---

## 📌 Selanjutnya

Materi 2 Level 5 selesai. Anda sekarang menguasai arsitektur skrip kompleks.

Berikutnya adalah **Materi 3: Process Substitution & FIFO** — kita akan membahas:

- **Process substitution** `<( )` dan `>( )` — meskipun tidak POSIX, sangat berguna.
- **Named pipe** (`mkfifo`) untuk komunikasi antar proses.
- **Komunikasi producer-consumer** dengan FIFO.
- **Menghindari deadlock** di FIFO.
- **Pipeline kompleks** dengan process substitution.
- **Menggabungkan output** dari beberapa proses.
- **Teknik lanjutan** dengan file descriptor.

## Materi 3: Process Substitution & FIFO

> **Catatan:** Ini adalah **materi ketiga** dari Level 5, sesuai kurikulum yang sudah ditetapkan. Kita akan membahas dua teknik komunikasi antar-proses yang sangat kuat: **process substitution** (`<( )` dan `>( )`) — fitur bash/ksh/zsh yang tidak POSIX namun sangat berguna, dan **named pipe** (`mkfifo`) — mekanisme POSIX yang memungkinkan komunikasi antar-proses tanpa pipe anonim. Setelah materi ini, Anda akan mampu merancang aliran data yang kompleks dan paralel dengan presisi.

---

## 🎯 Tujuan Materi 3

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Memahami **file descriptor** di level yang lebih dalam.
2. Menguasai **process substitution** `<( )` dan `>( )` — sintaks, penggunaan, dan keterbatasannya.
3. Menggunakan **named pipe** (`mkfifo`) untuk komunikasi antar-proses portabel.
4. Merancang pola **producer-consumer** dengan FIFO.
5. Menghindari **deadlock** pada FIFO dan process substitution.
6. Menggabungkan **output dari beberapa proses** menjadi satu.
7. Menerapkan **pipeline paralel** dengan process substitution.
8. Membangun **arsitektur komunikasi** antara skrip shell dan program lain.
9. Memilih antara **pipe**, **process substitution**, dan **FIFO** sesuai kebutuhan.
10. Menulis kode yang **portabel** meskipun process substitution tidak POSIX.

---

## 5.3.1 File Descriptor: Fondasi Komunikasi

Sebelum masuk ke process substitution dan FIFO, kita perlu memperdalam pemahaman tentang file descriptor.

### Apa Itu File Descriptor?

**File descriptor** (FD) adalah integer kecil yang menjadi **indeks** ke tabel file yang dibuka oleh proses. Setiap proses memiliki tabelnya sendiri. Kernel menggunakan FD untuk melacak:

- File yang dibuka.
- Posisi baca/tulis.
- Mode akses.
- Pipe yang terhubung.

### FD Standar

| FD | Nama | Default |
|----|------|---------|
| 0 | stdin | Keyboard |
| 1 | stdout | Terminal |
| 2 | stderr | Terminal |

### FD Tambahan

Anda bisa membuka FD tambahan (3, 4, 5, ...) untuk keperluan khusus:

```sh
exec 3> output.txt
echo "Baris 1" >&3
echo "Baris 2" >&3
exec 3>&-
```

Penjelasan:

- `exec 3> output.txt` – Buka file `output.txt` untuk tulis, hubungkan ke FD 3.
- `>&3` – Tulis ke FD 3.
- `exec 3>&-` – Tutup FD 3.

### Membaca dari FD

```sh
exec 3< input.txt
read -r line <&3
echo "Baris: $line"
exec 3<&-
```

Penjelasan:

- `exec 3< input.txt` – Buka file untuk dibaca, FD 3.
- `<&3` – Baca dari FD 3.
- `exec 3<&-` – Tutup.

### FD dan Pipe Anonim

Pipeline `|` menghubungkan FD 1 satu proses ke FD 0 proses berikutnya melalui **pipe anonim** — buffer di kernel yang tidak memiliki nama di filesystem.

```sh
perintah1 | perintah2
```

Kernel:
1. Membuat pipe (dua FD: baca dan tulis).
2. Fork `perintah1` dengan FD 1 = ujung tulis pipe.
3. Fork `perintah2` dengan FD 0 = ujung baca pipe.

### Melihat FD Terbuka

```sh
ls -l /proc/$$/fd
```

Penjelasan:

- `/proc/$$/fd` – Direktori virtual (Linux) yang menampilkan FD terbuka dari proses dengan PID `$$`.
- Setiap FD adalah symlink ke target.

Contoh output:

```
lrwx------ 1 budi users 64 Jan  1 12:00 0 -> /dev/pts/0
lrwx------ 1 budi users 64 Jan  1 12:00 1 -> /dev/pts/0
lrwx------ 1 budi users 64 Jan  1 12:00 2 -> /dev/pts/0
lrwx------ 1 budi users 64 Jan  1 12:00 3 -> /tmp/file.txt
```

FD 3 menunjuk ke `/tmp/file.txt`.

**Catatan:** `/proc` adalah fitur Linux. Di BSD/macOS, gunakan `lsof -p $$`.

---

## 5.3.2 Process Substitution — `<()` dan `>()`

**Process substitution** adalah fitur bash/ksh/zsh yang memungkinkan Anda menggunakan output atau input dari sebuah perintah sebagai **file**.

### Sintaks

| Sintaks | Arti |
|---------|------|
| `<(perintah)` | Output perintah dapat dibaca sebagai file |
| `>(perintah)` | Input ke perintah dapat ditulis sebagai file |

### Bagaimana Bekerja?

Ketika shell melihat `<(perintah)`:

1. Shell membuat **pipe** atau **/dev/fd**.
2. Shell fork proses untuk menjalankan `perintah` dengan stdout diarahkan ke pipe.
3. Shell menggantikan `<(perintah)` dengan **path** ke pipe (misalnya `/dev/fd/63`).
4. Perintah di luar melihat path sebagai nama file.

### Contoh 1: `diff` Dua Output

```sh
diff <(ls dir1) <(ls dir2)
```

Penjelasan:

- `<(ls dir1)` – Menjalankan `ls dir1`, outputnya tersedia sebagai file `/dev/fd/63`.
- `<(ls dir2)` – Sama, `/dev/fd/62`.
- `diff` menerima dua path, seolah-olah file.
- `diff` membandingkan kedua output.

**Tanpa process substitution:**

```sh
ls dir1 > /tmp/a.$$
ls dir2 > /tmp/b.$$
diff /tmp/a.$$ /tmp/b.$$
rm -f /tmp/a.$$ /tmp/b.$$
```

Lebih verbose, lebih lambat (I/O disk).

### Contoh 2: `while read` Tanpa Subshell

Ini adalah **keuntungan terbesar** process substitution untuk skrip.

**Masalah dengan pipe:**

```sh
count=0
cat file.txt | while read -r line; do
    count=$((count + 1))
done
echo "$count"    # 0 (subshell)
```

**Solusi dengan process substitution:**

```sh
count=0
while read -r line; do
    count=$((count + 1))
done < <(cat file.txt)
echo "$count"    # jumlah sebenarnya
```

Penjelasan:

- `< <(cat file.txt)` – Process substitution sebagai input.
- `while` berjalan di **shell saat ini**, bukan subshell.
- Variabel `count` bertahan.

**Bandingkan dengan redirection biasa:**

```sh
count=0
while read -r line; do
    count=$((count + 1))
done < file.txt
echo "$count"    # jumlah sebenarnya
```

Ini juga bekerja dan **lebih portabel** (POSIX). Process substitution berguna ketika Anda perlu **memproses output perintah** (bukan file) dalam loop yang memodifikasi variabel.

### Contoh 3: Menghindari File Temporary

```sh
# Tanpa process substitution — butuh file temporary
grep "error" log1.txt > /tmp/err1.$$
grep "error" log2.txt > /tmp/err2.$$
diff /tmp/err1.$$ /tmp/err2.$$
rm -f /tmp/err1.$$ /tmp/err2.$$

# Dengan process substitution
diff <(grep "error" log1.txt) <(grep "error" log2.txt)
```

### Contoh 4: `paste` dari Dua Sumber

```sh
paste <(cut -f1 file1.tsv) <(cut -f3 file2.tsv)
```

Penjelasan:

- `<(cut -f1 file1.tsv)` – Kolom 1 dari file1.
- `<(cut -f3 file2.tsv)` – Kolom 3 dari file2.
- `paste` menggabungkan baris demi baris.

**Tanpa process substitution:**

```sh
cut -f1 file1.tsv > /tmp/col1.$$
cut -f3 file2.tsv > /tmp/col3.$$
paste /tmp/col1.$$ /tmp/col3.$$
rm -f /tmp/col1.$$ /tmp/col3.$$
```

### Contoh 5: `tee` ke Beberapa Tujuan

```sh
perintah > >(gzip > output.gz) > >(wc -l > count.txt) > /dev/null
```

Penjelasan:

- `tee` secara implisit — setiap `>(...)` menerima salinan output.
- Output `perintah` dikirim ke dua proses: `gzip` dan `wc`.
- `> /dev/null` – Buang output asli.

**Catatan:** Ini lebih idiomatik dengan `tee`:

```sh
perintah | tee >(gzip > output.gz) | wc -l > count.txt
```

### Contoh 6: Multiple Output Process

```sh
echo "baris1
baris2
baris3" | tee >(grep "1" > out1.txt) >(grep "2" > out2.txt) > /dev/null
```

Penjelasan:

- `tee` mengirim output ke semua `>(...)`.
- Setiap `grep` memfilter dan menyimpan.

### Contoh 7: Menggabungkan Output dari Beberapa Proses

```sh
cat <(perintah1) <(perintah2) <(perintah3)
```

Penjelasan:

- `cat` membaca dari tiga process substitution.
- Output digabungkan berurutan (tidak paralel).

**Peringatan:** `cat` membaca process substitution satu per satu. Jika `perintah1` lambat, `perintah2` tidak akan dibaca sampai `perintah1` selesai.

### Contoh 8: Process Substitution untuk Log

```sh
{
    echo "Mulai"
    perintah_utama
    echo "Selesai"
} > >(tee -a log.txt >&2)
```

Penjelasan:

- `{ ... }` – Command group.
- `> >(tee -a log.txt >&2)` – Output ke `tee`, yang menulis ke log dan stderr.

### Process Substitution dan Subshell

Setiap process substitution berjalan di **subshell**. Variabel yang di-set di dalamnya **tidak** mempengaruhi shell induk.

```sh
count=0
cat <(count=$((count + 1)); echo "x") > /dev/null
echo "$count"    # 0
```

### Keterbatasan Process Substitution

1. **Tidak POSIX.** Hanya bash, ksh, zsh.
2. **Path `/dev/fd/N`** — Tidak selalu tersedia. Bergantung pada sistem.
3. **Bisa menghabiskan FD.** Setiap process substitution memerlukan FD.
4. **Tidak bisa di-redirect** dengan mudah di semua kasus.

### Fallback Portabel

Jika process substitution tidak tersedia, gunakan **named pipe** (lihat berikutnya) atau file temporary.

---

## 5.3.3 Named Pipe (`mkfifo`) — POSIX

**Named pipe** (FIFO) adalah file khusus yang berperilaku seperti pipe, tetapi memiliki **nama di filesystem**. Ini adalah cara **POSIX** untuk komunikasi antar-proses.

### Membuat Named Pipe

```sh
mkfifo /tmp/mypipe
```

Penjelasan:

- `mkfifo` – Perintah POSIX untuk membuat FIFO.
- `/tmp/mypipe` – Path FIFO.
- `ls -l /tmp/mypipe` akan menampilkan `p` sebagai tipe file.

```sh
prw-r--r-- 1 budi users 0 Jan  1 12:00 /tmp/mypipe
```

Karakter pertama `p` menandakan FIFO.

### Perilaku Blocking

Named pipe memiliki perilaku **blocking**:

- Membuka FIFO untuk **baca** akan memblokir sampai ada yang membuka untuk **tulis**.
- Membuka FIFO untuk **tulis** akan memblokir sampai ada yang membuka untuk **baca**.

Ini adalah **sinkronisasi** built-in.

### Contoh 1: Komunikasi Dua Terminal

**Terminal 1:**

```sh
mkfifo /tmp/mypipe
cat > /tmp/mypipe
```

Terminal 1 **blocking** menunggu pembaca.

**Terminal 2:**

```sh
cat < /tmp/mypipe
```

Terminal 2 **blocking** menunggu penulis. Sekarang keduanya aktif.

Ketika Anda mengetik di Terminal 1, itu muncul di Terminal 2.

### Contoh 2: Producer-Consumer Sederhana

```sh
#!/bin/sh

FIFO="/tmp/data.$$"
mkfifo "$FIFO" || exit 1

# Consumer di latar belakang
(while IFS= read -r line; do
    printf 'Diterima: %s\n' "$line"
done < "$FIFO") &

CONSUMER_PID=$!

# Producer
echo "Pesan 1" > "$FIFO"
echo "Pesan 2" > "$FIFO"
echo "Pesan 3" > "$FIFO"

# Tutup FIFO dengan menutup FD
exec 3>&- 2>/dev/null || true

# Tunggu consumer
wait "$CONSUMER_PID"

rm -f "$FIFO"
```

**Catatan:** Producer menulis tiga pesan, lalu selesai. Consumer membaca hingga EOF.

**Masalah:** Producer membuka FIFO **tiga kali** (untuk setiap `echo >`). Setiap pembukaan menunggu consumer. Ini bekerja, tetapi bisa menyebabkan masalah jika consumer tidak cepat.

**Solusi:** Buka FIFO sekali.

```sh
#!/bin/sh

FIFO="/tmp/data.$$"
mkfifo "$FIFO" || exit 1

# Consumer
(while IFS= read -r line; do
    printf 'Diterima: %s\n' "$line"
done < "$FIFO") &

CONSUMER_PID=$!

# Producer — buka FIFO sekali
exec 3> "$FIFO"
echo "Pesan 1" >&3
echo "Pesan 2" >&3
echo "Pesan 3" >&3
exec 3>&-

wait "$CONSUMER_PID"
rm -f "$FIFO"
```

Penjelasan:

- `exec 3> "$FIFO"` – Buka FIFO untuk tulis, FD 3.
- `>&3` – Tulis ke FD 3.
- `exec 3>&-` – Tutup FD 3. Ini mengirim EOF ke consumer.

### Contoh 3: Menggabungkan Output dengan FIFO

```sh
#!/bin/sh

FIFO="/tmp/sort.$$"
mkfifo "$FIFO" || exit 1

# Consumer: sort
sort "$FIFO" > hasil.txt &
CONSUMER_PID=$!

# Producer: dua sumber
{
    cat file1.txt
    cat file2.txt
} > "$FIFO"

wait "$CONSUMER_PID"
rm -f "$FIFO"

cat hasil.txt
```

Penjelasan:

- `sort "$FIFO"` – Consumer membaca dari FIFO.
- `{ cat file1; cat file2; } > "$FIFO"` – Producer menulis gabungan ke FIFO.
- Setelah producer selesai, FIFO ditutup, `sort` selesai.

### Contoh 4: Multiple Producers

```sh
#!/bin/sh

FIFO="/tmp/multi.$$"
mkfifo "$FIFO" || exit 1

# Consumer
(while IFS= read -r line; do
    printf '[%s] %s\n' "$$" "$line"
done < "$FIFO") &

CONSUMER_PID=$!

# Producer 1
(echo "dari P1"; echo "P1 lagi") > "$FIFO" &

# Producer 2
(echo "dari P2"; echo "P2 lagi") > "$FIFO" &

wait
rm -f "$FIFO"
```

**Peringatan:** Multiple producers bisa saling menimpa jika tidak hati-hati. Setiap penulis harus membuka FIFO dan menulis, tetapi urutan tidak dijamin.

### Contoh 5: FIFO sebagai Lock

FIFO bisa digunakan sebagai lock sederhana:

```sh
#!/bin/sh

LOCK_FIFO="/tmp/myapp.lock"

# Coba buka FIFO untuk tulis tanpa blocking
if ! (exec 3> "$LOCK_FIFO") 2>/dev/null; then
    echo "Sudah ada yang berjalan"
    exit 1
fi

# ...
```

**Catatan:** Ini bukan lock atomic. Gunakan `mkdir` untuk lock yang lebih baik.

### Contoh 6: Pipeline dengan FIFO

```sh
#!/bin/sh

FIFO1="/tmp/fifo1.$$"
FIFO2="/tmp/fifo2.$$"

mkfifo "$FIFO1" "$FIFO2" || exit 1

# Stage 1
grep "error" log.txt > "$FIFO1" &
PID1=$!

# Stage 2
awk '{ print $1 }' < "$FIFO1" > "$FIFO2" &
PID2=$!

# Stage 3
sort -u < "$FIFO2" > hasil.txt &
PID3=$!

wait $PID1 $PID2 $PID3
rm -f "$FIFO1" "$FIFO2"

cat hasil.txt
```

Penjelasan:

- Tiga proses berjalan paralel.
- FIFO menghubungkan output stage 1 ke stage 2, dan stage 2 ke stage 3.
- Lebih efisien dari pipeline? Tidak. Pipeline `|` sudah melakukan ini dengan lebih sederhana.

**Kapan FIFO Berguna?**

- Ketika Anda perlu **membuka koneksi berkali-kali**.
- Ketika **proses tidak bisa dijalankan dalam satu pipeline**.
- Ketika Anda perlu **komunikasi dua arah** (dua FIFO).

### Contoh 7: Komunikasi Dua Arah

```sh
#!/bin/sh

IN="/tmp/in.$$"
OUT="/tmp/out.$$"

mkfifo "$IN" "$OUT" || exit 1

# Server
(
    while IFS= read -r line < "$IN"; do
        printf 'Echo: %s\n' "$line" > "$OUT"
    done
) &
SERVER_PID=$!

# Client
exec 3> "$IN"
exec 4< "$OUT"

echo "Halo" >&3
read -r response <&4
printf 'Respons: %s\n' "$response"

echo "Dunia" >&3
read -r response <&4
printf 'Respons: %s\n' "$response"

exec 3>&-
exec 4<&-

wait "$SERVER_PID"
rm -f "$IN" "$OUT"
```

**Peringatan:** Komunikasi dua arah dengan FIFO bisa rumit dan rawan deadlock. Untuk kasus serius, gunakan socket atau mekanisme lain.

---

## 5.3.4 Menghindari Deadlock

**Deadlock** terjadi ketika dua proses saling menunggu. Pada FIFO, ini sering terjadi.

### Contoh Deadlock

```sh
# Producer mencoba menulis sebelum ada reader
echo "data" > /tmp/fifo    # Blocking sampai ada reader
```

Jika tidak ada reader, proses **menggantung selamanya**.

### Pencegahan Deadlock

**1. Urutan buka yang benar:**

- Buka reader **sebelum** writer, atau keduanya bersamaan.

```sh
# Benar — reader dibuka dulu (di background)
(reader < "$FIFO") &
writer > "$FIFO"
```

**2. Gunakan timeout:**

```sh
# Buka FIFO dengan timeout
if ! timeout 5 sh -c "exec 3> '$FIFO'"; then
    echo "Timeout membuka FIFO" >&2
    exit 1
fi
```

`timeout` **tidak POSIX**. Untuk portabel, gunakan loop dengan `kill`.

**3. Buka FIFO dengan non-blocking:**

Tidak bisa di shell. `O_NONBLOCK` hanya di C.

**4. Selalu tutup FIFO:**

```sh
trap 'exec 3>&-; rm -f "$FIFO"' EXIT
```

### Deteksi Deadlock

Gunakan `ps` untuk melihat proses yang menggantung:

```sh
ps aux | grep "defunct\|D "
```

Proses dengan status `D` (uninterruptible sleep) mungkin deadlock pada I/O.

---

## 5.3.5 Pipeline Paralel dengan Process Substitution

Process substitution memungkinkan pipeline paralel yang lebih fleksibel dari `|`.

### Contoh: Memproses Dua Sumber Paralel

```sh
# Pipeline serial — lambat
cat file1 file2 | grep "error" | sort -u

# Pipeline paralel dengan process substitution
{ cat <(grep "error" file1) <(grep "error" file2); } | sort -u
```

Penjelasan:

- `grep "error" file1` dan `grep "error" file2` berjalan **paralel**.
- `cat` menggabungkan output.
- `sort -u` mengurutkan.

**Catatan:** `cat` membaca process substitution satu per satu, jadi tidak sepenuhnya paralel. Untuk paralel penuh, gunakan FIFO atau `xargs -P`.

### Contoh: Fan-Out ke Beberapa Consumer

```sh
#!/bin/bash

# Setiap baris dikirim ke 3 proses
while IFS= read -r line; do
    echo "$line" | tee >(grep "error" >> errors.log) \
                       >(grep "warn" >> warns.log) \
                       >(wc -l >> count.log) > /dev/null
done < log.txt
```

Penjelasan:

- Setiap baris dari `log.txt` dikirim ke tiga proses.
- `tee` menduplikasi output.
- Setiap process substitution memproses.

**Catatan:** Ini sangat lambat untuk file besar karena satu loop per baris. Untuk file besar, gunakan `awk` atau `tee` sekali.

### Contoh: Fan-Out Efisien

```sh
#!/bin/bash

grep "error" log.txt > errors.log &
grep "warn" log.txt > warns.log &
wc -l < log.txt > count.log &
wait

echo "Selesai"
```

Ini lebih efisien — tiga proses paralel, tidak ada loop.

### Contoh: Menggabungkan Beberapa Output

```sh
#!/bin/bash

# Jalankan tiga perintah paralel, gabungkan output
{
    cat <(perintah1) &
    cat <(perintah2) &
    cat <(perintah3) &
    wait
} | sort
```

**Peringatan:** Urutan output tidak dijamin. Gunakan `sort` atau `sort -n` untuk konsistensi.

---

## 5.3.6 Perbandingan Pipe, Process Substitution, dan FIFO

| Aspek | Pipe (`|`) | Process Substitution `<()` `>()` | FIFO (`mkfifo`) |
|-------|-----------|----------------------------------|-----------------|
| POSIX | Ya | Tidak | Ya |
| Shell | Semua | bash, ksh, zsh | Semua |
| Kemudahan | Sangat mudah | Mudah | Sedang |
| Paralel | Ya | Ya | Ya |
| Nama di FS | Tidak | Tidak | Ya |
| Persisten | Tidak | Tidak | Ya (file tetap ada) |
| Multiple reader | Ya | Terbatas | Ya |
| Multiple writer | Ya | Terbatas | Ya (hati-hati) |
| Portabilitas | Tinggi | Rendah | Tinggi |
| Overhead | Rendah | Sedang | Sedang |

### Kapan Menggunakan Apa?

**Pipe (`|`):**

- Alur data sederhana.
- Pipeline linier.
- Kapan saja bisa.

**Process Substitution:**

- Ketika Anda perlu **file** tetapi hanya punya perintah.
- Ketika `while read` tidak boleh di subshell.
- Di lingkungan yang mendukung bash/ksh/zsh.

**FIFO:**

- Ketika Anda perlu **nama** di filesystem.
- Ketika multiple reader/writer.
- Ketika komunikasi antar skrip atau antar user.
- Ketika Anda perlu **portabilitas POSIX**.

---

## 5.3.7 Contoh Skrip Lengkap

### Skrip 1: Proses Paralel dengan Process Substitution

```bash
#!/bin/bash
# Nama: paralel.sh
# Tujuan: Menjalankan beberapa perintah paralel dan menggabungkan

set -u

if [ $# -lt 2 ]; then
    printf 'Penggunaan: %s direktori pola\n' "$0" >&2
    exit 2
fi

DIR="$1"
POLA="$2"

if [ ! -d "$DIR" ]; then
    printf 'Error: %s bukan direktori.\n' "$DIR" >&2
    exit 2
fi

LC_ALL=C
export LC_ALL

# Proses setiap file .log secara paralel
{
    for file in "$DIR"/*.log; do
        [ -f "$file" ] || continue
        printf '%s\n' "$file"
    done
} | while IFS= read -r file; do
    grep -H "$POLA" "$file" &
done
wait

printf 'Selesai.\n'
```

**Catatan:** Ini menggunakan `&` untuk paralelisasi. Untuk kontrol lebih baik, gunakan `xargs -P`.

### Skrip 2: FIFO Producer-Consumer

```sh
#!/bin/sh
# Nama: fifo_pc.sh
# Tujuan: Producer-consumer dengan FIFO

set -u

FIFO="/tmp/myapp.$$"
RESULT="/tmp/hasil.$$"

# Cleanup
cleanup() {
    status=$?
    rm -f "$FIFO" "$RESULT"
    exit "$status"
}
trap cleanup EXIT INT TERM

# Buat FIFO
if ! mkfifo "$FIFO"; then
    printf 'Error: tidak dapat membuat FIFO.\n' >&2
    exit 1
fi

# Consumer — sort
sort "$FIFO" > "$RESULT" &
CONSUMER_PID=$!

# Producer — gabungkan dari dua sumber
{
    printf 'banana\n'
    printf 'apple\n'
    printf 'cherry\n'
    printf 'date\n'
    printf 'elderberry\n'
} > "$FIFO"

# Tunggu consumer
wait "$CONSUMER_PID"

# Tampilkan hasil
cat "$RESULT"
```

### Skrip 3: Multiple Output dengan FIFO

```sh
#!/bin/sh
# Nama: fan_out.sh
# Tujuan: Fan-out output ke beberapa consumer menggunakan FIFO

set -u

FIFO1="/tmp/out1.$$"
FIFO2="/tmp/out2.$$"

cleanup() {
    status=$?
    rm -f "$FIFO1" "$FIFO2"
    exit "$status"
}
trap cleanup EXIT INT TERM

mkfifo "$FIFO1" "$FIFO2" || exit 1

# Consumer 1: hanya error
grep "ERROR" < "$FIFO1" > errors.txt &
PID1=$!

# Consumer 2: hitung baris
wc -l < "$FIFO2" > count.txt &
PID2=$!

# Producer: bagi output ke dua consumer
# (Catatan: tee menulis ke stdout, jadi kita arahkan)
{
    cat log.txt
} | tee "$FIFO1" > "$FIFO2"

wait "$PID1" "$PID2"

printf 'Errors: %s baris\n' "$(wc -l < errors.txt)"
printf 'Total: %s baris\n' "$(cat count.txt)"
```

**Catatan:** `tee` menulis ke file dan stdout. Dengan FIFO sebagai file, ini bekerja.

### Skrip 4: Process Substitution untuk Menghindari File Temporary

```bash
#!/bin/bash
# Nama: tanpa_tmp.sh
# Tujuan: Menggabungkan output dari dua perintah tanpa file temporary

set -u

DIR="${1:-.}"

if [ ! -d "$DIR" ]; then
    printf 'Error: %s bukan direktori.\n' "$DIR" >&2
    exit 2
fi

LC_ALL=C
export LC_ALL

# Tanpa process substitution — perlu file temporary
# grep "error" "$DIR"/*.log > /tmp/err.$$
# grep "warn" "$DIR"/*.log > /tmp/warn.$$
# diff /tmp/err.$$ /tmp/warn.$$
# rm -f /tmp/err.$$ /tmp/warn.$$

# Dengan process substitution
diff <(grep "error" "$DIR"/*.log 2>/dev/null) \
     <(grep "warn" "$DIR"/*.log 2>/dev/null)
```

### Skrip 5: Fan-In — Menggabungkan Beberapa Sumber

```bash
#!/bin/bash
# Nama: fan_in.sh
# Tujuan: Menggabungkan output dari beberapa perintah

set -u

# Dua perintah menghasilkan data, digabung dan diurutkan
{
    cat <(printf 'zebra\napple\n') \
        <(printf 'banana\ncherry\n') \
        <(printf 'date\nelderberry\n')
} | sort

# Output:
# apple
# banana
# cherry
# date
# elderberry
# zebra
```

### Skrip 6: Monitor Log dengan Process Substitution

```bash
#!/bin/bash
# Nama: monitor.sh
# Tujuan: Monitor beberapa log sekaligus

set -u

if [ $# -eq 0 ]; then
    printf 'Penggunaan: %s file_log...\n' "$0" >&2
    exit 2
fi

# Monitor semua file, tampilkan error dengan prefix nama file
tail -f "$@" | grep --line-buffered "ERROR"
```

**Catatan:** `--line-buffered` tidak POSIX. Untuk portabilitas:

```bash
tail -f "$@" | awk '/ERROR/ { print; fflush() }'
```

---

## 5.3.8 Teknik Lanjutan: FD Kustom

### Menyimpan stdout Asli

```sh
#!/bin/sh

# Simpan stdout ke FD 3
exec 3>&1

# Alihkan stdout ke file
exec 1> /tmp/output.txt

echo "Ini ke file"

# Kembalikan stdout
exec 1>&3

echo "Ini ke terminal"

# Tutup FD 3
exec 3>&-
```

Penjelasan:

- `exec 3>&1` – Salin stdout ke FD 3.
- `exec 1> file` – Alihkan stdout ke file.
- `exec 1>&3` – Kembalikan stdout dari FD 3.

### Logging ke File dan Terminal

```sh
#!/bin/sh

LOG_FILE="/tmp/app.log"

# Simpan stdout dan stderr asli
exec 3>&1
exec 4>&2

# Fungsi log
log() {
    printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$*" >&3
    printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$*" >> "$LOG_FILE"
}

log "Pesan ke terminal dan file"

# Kembalikan
exec 3>&-
exec 4>&-
```

### Redirection Berkelompok

```sh
#!/bin/sh

# Semua output dalam blok ini ke file
{
    echo "Baris 1"
    echo "Baris 2"
    ls /tmp
} > /tmp/output.txt 2>&1
```

### FD untuk File Besar

```sh
#!/bin/sh

# Buka file sekali, tulis banyak kali
exec 3> /tmp/besar.txt

i=0
while [ "$i" -lt 1000 ]; do
    printf 'Baris %d\n' "$i" >&3
    i=$((i + 1))
done

exec 3>&-
```

**Keuntungan:** File dibuka sekali, bukan 1000 kali.

---

## 5.3.9 Process Substitution vs FIFO: Kapan Menggunakan?

### Process Substitution

**Kelebihan:**

- Sintaks ringkas.
- Tidak perlu membuat file FIFO.
- Cocok untuk one-shot.

**Kekurangan:**

- Tidak POSIX.
- Tidak bisa digunakan di semua shell.
- Terbatas untuk satu pembaca/penulis.

### FIFO

**Kelebihan:**

- POSIX.
- Nama di filesystem — bisa diakses dari mana saja.
- Multiple reader/writer (dengan hati-hati).
- Persisten.

**Kekurangan:**

- Perlu cleanup.
- Perlu handle blocking.
- Lebih verbose.

### Contoh Keputusan

**Kasus:** Membandingkan output dua perintah.

```sh
# Process substitution — ringkas
diff <(perintah1) <(perintah2)
```

```sh
# FIFO — portabel
mkfifo /tmp/a.$$ /tmp/b.$$
perintah1 > /tmp/a.$$ &
perintah2 > /tmp/b.$$ &
diff /tmp/a.$$ /tmp/b.$$
wait
rm -f /tmp/a.$$ /tmp/b.$$
```

**Kasus:** Loop yang memodifikasi variabel dari output perintah.

```sh
# Process substitution — variabel bertahan
count=0
while read -r line; do
    count=$((count + 1))
done < <(perintah)
```

```sh
# FIFO — variabel bertahan
mkfifo /tmp/f.$$
perintah > /tmp/f.$$ &
count=0
while read -r line; do
    count=$((count + 1))
done < /tmp/f.$$
wait
rm -f /tmp/f.$$
```

**Kasus:** Komunikasi antara dua skrip terpisah.

```sh
# FIFO — harus, karena process substitution tidak bisa antar proses
mkfifo /tmp/chat.$$
# Skrip 1: echo > /tmp/chat.$$
# Skrip 2: read < /tmp/chat.$$
```

---

## 5.3.10 Latihan

1. **Process Substitution Dasar:**
   - Bandingkan output `ls /etc` dan `ls /tmp` dengan `diff <() <()`.
   - Bandingkan dengan versi file temporary.

2. **While Read Tanpa Subshell:**
   - Tulis loop yang menghitung baris dari output `ls`.
   - Versi 1: `ls | while read`.
   - Versi 2: `while read < <(ls)`.
   - Bandingkan variabel counter.

3. **Fan-Out:**
   - Buat file log dengan ERROR, WARN, INFO.
   - Gunakan `tee` dan process substitution untuk memisahkan ke tiga file.
   - Bandingkan dengan tiga `grep` terpisah.

4. **FIFO Dasar:**
   - Buat FIFO di `/tmp`.
   - Terminal 1: `cat > fifo`.
   - Terminal 2: `cat < fifo`.
   - Ketik di terminal 1, lihat di terminal 2.

5. **FIFO Producer-Consumer:**
   - Tulis skrip dengan satu producer dan satu consumer.
   - Producer mengirim 10 angka.
   - Consumer menjumlahkan.
   - Cetak hasil.

6. **FIFO Multiple Producer:**
   - Tiga producer menulis ke satu FIFO.
   - Satu consumer membaca.
   - Amati urutan dan interleaving.

7. **Deadlock:**
   - Buat skrip yang deadlock pada FIFO.
   - Identifikasi penyebabnya.
   - Perbaiki.

8. **FD Kustom:**
   - Gunakan `exec 3> file` untuk menulis ke file.
   - Tulis 100 baris tanpa membuka file berulang.

9. **Logging dengan FD:**
   - Simpan stdout dan stderr asli.
   - Alihkan ke file.
   - Cetak pesan ke terminal asli via FD.

10. **Komunikasi Dua Arah:**
    - Buat dua FIFO (in dan out).
    - Skrip server membaca dari `in`, menulis ke `out`.
    - Skrip client sebaliknya.
    - Uji komunikasi.

11. **Process Substitution vs FIFO:**
    - Selesaikan tugas yang sama dengan kedua teknik.
    - Bandingkan keterbacaan dan portabilitas.

12. **Pipeline Paralel:**
    - Tulis pipeline yang memproses tiga file secara paralel.
    - Gabungkan hasilnya.

13. **Cleanup FIFO:**
    - Tulis skrip yang menggunakan FIFO dengan cleanup via trap.
    - Pastikan FIFO dihapus saat keluar, bahkan dengan Ctrl+C.

14. **Performance:**
    - Bandingkan tiga cara membaca output perintah dalam loop:
      - `perintah | while read`
      - `while read < <(perintah)`
      - FIFO + `while read`
    - Ukur dengan `time`.

---

## 5.3.11 Ringkasan Materi 3

- **File descriptor** adalah integer yang merepresentasikan koneksi ke file, pipe, atau device.
- **FD standar:** 0 (stdin), 1 (stdout), 2 (stderr). Bisa buka FD tambahan (3, 4, ...).
- **Process substitution** `<( )` dan `>( )`:
  - Membuat pipe, menggantikan dengan path.
  - Hanya di bash, ksh, zsh.
  - Berguna untuk `diff <(a) <(b)` dan `while read < <(cmd)`.
  - Menghindari file temporary.
- **Named pipe** (`mkfifo`):
  - POSIX. File khusus di filesystem.
  - Blocking: penulis menunggu pembaca, dan sebaliknya.
  - Untuk komunikasi antar-proses, multiple reader/writer.
- **Deadlock** bisa terjadi jika urutan buka salah. Selalu buka reader dulu, atau gunakan trap cleanup.
- **FD kustom** untuk menyimpan stdout asli, logging ke beberapa tujuan, atau menulis file besar.
- **Pipe** untuk alur linier; **process substitution** untuk file-like; **FIFO** untuk portabilitas dan persistensi.
- **Selalu cleanup** FIFO dan file temporary dengan trap.

**Prinsip utama:**

> **"Data adalah aliran. Kendalikan aliran, dan Anda mengendalikan sistem."**

---

## 📌 Selanjutnya

Materi 3 Level 5 selesai. Anda sekarang menguasai process substitution dan FIFO secara mendalam.

Berikutnya adalah **Materi 4: Signal Handling & Job Control** — kita akan membahas:

- **Signal** — review dan sinyal penting.
- **`trap` untuk sinyal** — `INT`, `TERM`, `HUP`, `USR1`, `USR2`.
- **Job control** — `&`, `jobs`, `fg`, `bg`, `wait`.
- **Mengelola proses latar belakang** dengan PID.
- **Menulis daemon sederhana** dengan shell.
- **SIGHUP dan reload konfigurasi.**
- **Signal masking dan forwarding.**
- **Process group dan session.**

## Materi 4: Signal Handling & Job Control

> **Catatan:** Ini adalah **materi keempat** dari Level 5, sesuai kurikulum yang sudah ditetapkan. Di Level 4 kita sudah menyinggung `trap` untuk cleanup. Sekarang kita akan membedah **signal** dan **job control** secara mendalam: dari sinyal individual, process group, session, hingga membangun **daemon sederhana** dengan shell. Setelah materi ini, Anda akan mampu mengelola proses dengan kontrol tingkat sistem operasi.

---

## 🎯 Tujuan Materi 4

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Memahami **signal** sebagai mekanisme komunikasi antar-proses.
2. Menguasai semua sinyal penting: `INT`, `TERM`, `HUP`, `USR1`, `USR2`, `QUIT`, `KILL`, `STOP`, `CONT`.
3. Menggunakan **`trap`** dengan benar untuk setiap sinyal.
4. Mengelola **proses latar belakang** dengan `&`, `jobs`, `fg`, `bg`, `wait`.
5. Memahami **process group** dan **session**.
6. Mengelola **PID** dan PID file dengan aman.
7. Menulis **daemon sederhana** dengan shell.
8. Menerapkan **SIGHUP** untuk reload konfigurasi.
9. Memahami **signal forwarding** dan masking.
10. Mengimplementasikan **graceful shutdown** dengan benar.

---

## 5.4.1 Signal — Review Mendalam

**Signal** adalah notifikasi asinkron yang dikirim kernel atau proses ke proses lain. Signal adalah mekanisme **interrupt** di level sistem operasi.

### Karakteristik Signal

1. **Asinkron** — Dapat datang kapan saja.
2. **Ringan** — Hanya integer kecil (1–64).
3. **Tidak membawa data** — Kecuali `sigqueue()` (POSIX real-time).
4. **Dapat di-handle, diabaikan, atau dibiarkan default.**

### Daftar Sinyal POSIX

| Sinyal | Nomor | Default | Dapat Ditangkap | Keterangan |
|--------|-------|---------|-----------------|------------|
| `SIGHUP` | 1 | Terminate | Ya | Terminal ditutup |
| `SIGINT` | 2 | Terminate | Ya | Ctrl+C |
| `SIGQUIT` | 3 | Core dump | Ya | Ctrl+\ |
| `SIGILL` | 4 | Core dump | Ya | Instruksi ilegal |
| `SIGTRAP` | 5 | Core dump | Ya | Trace trap |
| `SIGABRT` | 6 | Core dump | Ya | Abort |
| `SIGBUS` | 7 | Core dump | Ya | Bus error |
| `SIGFPE` | 8 | Core dump | Ya | Floating-point exception |
| `SIGKILL` | 9 | Terminate | **Tidak** | Kill paksa |
| `SIGUSR1` | 10 | Terminate | Ya | User-defined 1 |
| `SIGSEGV` | 11 | Core dump | Ya | Segmentation violation |
| `SIGUSR2` | 12 | Terminate | Ya | User-defined 2 |
| `SIGPIPE` | 13 | Terminate | Ya | Broken pipe |
| `SIGALRM` | 14 | Terminate | Ya | Alarm |
| `SIGTERM` | 15 | Terminate | Ya | Terminasi sopan |
| `SIGSTKFLT` | 16 | Terminate | Ya | Stack fault (Linux) |
| `SIGCHLD` | 17 | Ignore | Ya | Child process terminated |
| `SIGCONT` | 18 | Continue | Ya | Lanjutkan |
| `SIGSTOP` | 19 | Stop | **Tidak** | Stop paksa |
| `SIGTSTP` | 20 | Stop | Ya | Ctrl+Z |
| `SIGTTIN` | 21 | Stop | Ya | Background read dari tty |
| `SIGTTOU` | 22 | Stop | Ya | Background write ke tty |
| `SIGURG` | 23 | Ignore | Ya | Urgent socket |
| `SIGXCPU` | 24 | Core dump | Ya | CPU limit |
| `SIGXFSZ` | 25 | Core dump | Ya | File size limit |
| `SIGVTALRM` | 26 | Terminate | Ya | Virtual timer |
| `SIGPROF` | 27 | Terminate | Ya | Profiling timer |
| `SIGWINCH` | 28 | Ignore | Ya | Window size change |
| `SIGIO` | 29 | Terminate | Ya | I/O possible |
| `SIGPWR` | 30 | Terminate | Ya | Power failure |
| `SIGSYS` | 31 | Core dump | Ya | Bad syscall |

**Catatan:** Nomor sinyal dapat berbeda antar sistem. Di Linux x86_64, `SIGUSR1` adalah 10, tetapi di MIPS bisa berbeda. **Selalu gunakan nama, bukan nomor, di skrip.**

### Sinyal yang Tidak Dapat Ditangkap

- `SIGKILL` (9) — Membunuh paksa.
- `SIGSTOP` (19) — Menghentikan paksa.

Keduanya **tidak dapat** di-handle, diabaikan, atau di-block. Ini menjamin kernel selalu dapat menghentikan proses.

### Sinyal Default

Setiap sinyal memiliki **aksi default**:

- **Terminate** — Proses dihentikan.
- **Core dump** — Proses dihentikan + dump memory ke file `core`.
- **Stop** — Proses dihentikan sementara (dapat dilanjutkan dengan `SIGCONT`).
- **Ignore** — Sinyal diabaikan.
- **Continue** — Proses dilanjutkan.

---

## 5.4.2 Mengirim Sinyal

### `kill` — Perintah POSIX

```sh
kill -SIGNAL PID
```

Penjelasan:

- `kill` — Nama perintah (meskipun bukan hanya untuk "kill").
- `-SIGNAL` — Nama sinyal: `-TERM`, `-INT`, `-HUP`, `-USR1`, `-USR2`, `-KILL`, `-STOP`, `-CONT`, dll.
- `PID` — Process ID target.

### Contoh

```sh
kill -TERM "$PID"    # Terminasi sopan
kill -INT "$PID"     # Interrupt
kill -HUP "$PID"     # Hangup (reload)
kill -USR1 "$PID"    # User-defined
kill -KILL "$PID"    # Kill paksa
kill -STOP "$PID"    # Stop
kill -CONT "$PID"    # Lanjutkan
```

### Default: `SIGTERM`

```sh
kill "$PID"          # Sama dengan kill -TERM
```

### `kill -0` — Cek Keberadaan

```sh
if kill -0 "$PID" 2>/dev/null; then
    echo "Proses $PID masih hidup"
else
    echo "Proses $PID tidak ada"
fi
```

Penjelasan:

- `kill -0` — Tidak mengirim sinyal, hanya memeriksa.
- Exit status `0` — Proses ada dan kita punya izin.
- Exit status non-zero — Proses tidak ada atau izin ditolak.

**Jebakan:** Jika kita tidak punya izin untuk mengirim sinyal ke proses (bukan pemilik, bukan root), `kill -0` juga gagal. Jadi `kill -0` tidak 100% akurat untuk "proses ada".

### `pkill` dan `pgrep` — Tidak POSIX

```sh
pkill -TERM myapp        # Kill semua proses bernama "myapp"
pgrep myapp              # Cari PID proses bernama "myapp"
```

**Tidak POSIX.** GNU/BSD. Untuk portabilitas, gunakan `ps` + `grep` + `kill`:

```sh
ps -eo pid,comm | awk '$2 == "myapp" { print $1 }' | xargs kill -TERM
```

### Nama Sinyal vs Nomor

```sh
kill -15 "$PID"    # SIGTERM
kill -TERM "$PID"  # SIGTERM
```

**Selalu gunakan nama** untuk portabilitas. Nomor bisa berbeda antar arsitektur.

---

## 5.4.3 `trap` — Menangkap Sinyal

Sudah dibahas di Level 4, tetapi kita perdalam.

### Sintaks

```sh
trap 'perintah' SINYAL...
```

### Contoh: Menangkap `INT`

```sh
#!/bin/sh

trap 'echo "Menerima SIGINT, keluar dengan bersih"; exit 130' INT

echo "Tekan Ctrl+C untuk keluar"
while :; do
    sleep 1
done
```

Penjelasan:

- `trap '...' INT` — Daftarkan handler untuk `SIGINT`.
- `exit 130` — Konvensi: 128 + 2 (nomor SIGINT).
- Handler dijalankan ketika Ctrl+C.

### Contoh: Menangkap `EXIT`

```sh
#!/bin/sh

cleanup() {
    echo "Cleanup dijalankan"
    rm -f /tmp/data.$$
}

trap cleanup EXIT

echo "Mulai"
# ...
echo "Selesai"
```

`cleanup` dijalankan **apapun** penyebab keluar — normal, error, atau sinyal.

### Contoh: Menangkap `EXIT`, `INT`, `TERM`

```sh
#!/bin/sh

cleanup() {
    status=$?
    echo "Cleanup (status=$status)" >&2
    rm -f /tmp/data.$$
    exit "$status"
}

trap cleanup EXIT INT TERM

echo "Mulai"
sleep 100
echo "Selesai"
```

Penjelasan:

- `status=$?` — Simpan exit code sebelum diubah.
- `exit "$status"` — Keluar dengan status yang sama.
- Jika di-Ctrl+C, cleanup dijalankan via `INT` → `exit 130`. Trap `EXIT` juga dijalankan.

**Jebakan:** Jika trap `INT` memanggil `exit`, trap `EXIT` juga akan dijalankan. Ini bisa menyebabkan cleanup dijalankan dua kali.

**Solusi:**

```sh
#!/bin/sh

CLEANED=0

cleanup() {
    [ "$CLEANED" -eq 1 ] && return 0
    CLEANED=1
    status=$?
    echo "Cleanup (status=$status)" >&2
    rm -f /tmp/data.$$
    exit "$status"
}

trap cleanup EXIT INT TERM
```

### Reset Trap

```sh
trap - INT
```

Penjelasan:

- `-` — Reset ke default.
- Sinyal `INT` kembali ke perilaku normal.

### Ignore Trap

```sh
trap '' INT
```

Penjelasan:

- `''` — String kosong. Mengabaikan sinyal.
- `SIGINT` tidak akan menghentikan skrip.
- Berguna untuk operasi kritis.

**Jebakan:** Untuk `SIGTERM`, jika Anda mengabaikannya, proses tidak bisa dihentikan dengan sopan. Hanya `SIGKILL` yang bisa. Gunakan dengan hati-hati.

### Melihat Trap Aktif

```sh
trap -p
```

Penjelasan:

- `-p` — Print semua trap dalam format yang bisa dieksekusi ulang.
- **Tidak POSIX.**

Untuk portabel, tidak ada cara langsung.

### Trap di Subshell

```sh
#!/bin/sh

trap 'echo "Induk"' EXIT

(
    trap 'echo "Anak"' EXIT
    echo "Dalam subshell"
)
echo "Setelah subshell"
```

Output:

```
Dalam subshell
Anak
Setelah subshell
Induk
```

Penjelasan:

- Setiap subshell memiliki trap sendiri.
- Trap induk tidak diwariskan.

### Trap di Fungsi

```sh
#!/bin/sh

fungsi() {
    trap 'echo "Dalam fungsi"' EXIT
    echo "Fungsi dipanggil"
}

fungsi
echo "Setelah fungsi"
```

Output:

```
Fungsi dipanggil
Setelah fungsi
```

**Catatan:** Trap `EXIT` di dalam fungsi **menggantikan** trap di level skrip, bukan menambahkan. Ketika fungsi selesai, trap tidak dijalankan (karena skrip belum exit).

Untuk menjalankan cleanup di akhir fungsi, gunakan trap terpisah:

```sh
fungsi() {
    trap 'echo "Cleanup fungsi"; trap - EXIT' EXIT
    # ...
}
```

Atau, lebih mudah: gunakan fungsi cleanup biasa yang dipanggil manual.

---

## 5.4.4 Sinyal Khusus: `SIGHUP`

`SIGHUP` (Hangup) memiliki sejarah menarik.

### Sejarah

Pada masa terminal fisik, `SIGHUP` dikirim ketika koneksi terminal terputus (modem hang up). Program yang berjalan di terminal akan menerima `SIGHUP` dan default-nya adalah terminate.

### Modern

Sekarang, `SIGHUP` digunakan untuk **reload konfigurasi** oleh banyak daemon:

- `nginx -s reload` mengirim `SIGHUP`.
- `sshd` reload konfigurasi pada `SIGHUP`.
- Banyak daemon lain.

### Contoh: Reload Konfigurasi

```sh
#!/bin/sh

CONFIG=""

load_config() {
    if [ -f "/etc/myapp/myapp.conf" ]; then
        # Muat ulang konfigurasi
        CONFIG=$(cat /etc/myapp/myapp.conf)
        echo "Konfigurasi dimuat ulang: $(date)" >&2
    fi
}

trap load_config HUP

load_config

echo "Daemon berjalan. Kirim SIGHUP untuk reload."
while :; do
    sleep 60
done
```

Uji:

```sh
kill -HUP "$PID"
```

### `nohup` — Mengabaikan SIGHUP

```sh
nohup perintah &
```

Penjelasan:

- `nohup` — Jalankan perintah, abaikan `SIGHUP`.
- Output ke `nohup.out` jika stdout adalah terminal.
- Berguna untuk menjalankan proses yang tidak boleh mati saat terminal ditutup.

---

## 5.4.5 Job Control

**Job control** adalah kemampuan shell untuk mengelola beberapa proses dari satu terminal.

### Konsep

- **Job** — Sekelompok proses yang dijalankan sebagai satu unit.
- **Foreground** — Proses yang mengontrol terminal. Menerima input.
- **Background** — Proses yang berjalan tanpa mengontrol terminal.

### `&` — Background

```sh
sleep 100 &
```

Penjelasan:

- `&` — Jalankan di latar belakang.
- Shell mencetak job number dan PID: `[1] 12345`.
- Shell langsung mengembalikan prompt.

### `jobs` — Daftar Job

```sh
jobs
```

Output:

```
[1]+  Running    sleep 100 &
[2]-  Running    sleep 200 &
```

Penjelasan:

- `+` — Job saat ini (default untuk `fg` dan `bg`).
- `-` — Job sebelumnya.
- Nomor job (`[1]`, `[2]`) — Untuk referensi.

**Tidak POSIX.** POSIX mendefinisikan `jobs`, tetapi format tidak dijamin.

### `fg` — Foreground

```sh
fg %1
```

Penjelasan:

- `fg` — Bawa job ke foreground.
- `%1` — Job number 1.
- `%+` atau `%%` — Job saat ini.
- `%-` — Job sebelumnya.

`fg` tanpa argumen membawa job saat ini.

### `bg` — Background

```sh
bg %1
```

Penjelasan:

- `bg` — Lanjutkan job di latar belakang.
- Berguna untuk job yang di-suspend dengan Ctrl+Z.

### Ctrl+Z — Suspend

Tekan `Ctrl+Z` untuk suspend proses foreground:

```
^Z
[1]+  Stopped    sleep 100
```

Proses di-stop (`SIGTSTP`). Gunakan `bg` untuk melanjutkan di background, atau `fg` untuk foreground.

### `wait` — Tunggu Job

```sh
wait %1
wait "$PID"
wait
```

Penjelasan:

- `wait %1` — Tunggu job 1.
- `wait "$PID"` — Tunggu proses dengan PID.
- `wait` — Tunggu semua job.
- Exit status `wait` adalah exit status job yang ditunggu.

### `disown` — Hapus dari Job Table

```sh
disown %1
```

Penjelasan:

- `disown` — Hapus job dari tabel shell.
- Job tetap berjalan, tetapi tidak lagi dilacak oleh shell.
- **Tidak POSIX.** Bash.

Untuk portabilitas, gunakan `nohup` atau `setsid`.

### `setsid` — Session Baru

```sh
setsid perintah &
```

Penjelasan:

- `setsid` — Jalankan perintah di session baru.
- Proses tidak terpengaruh oleh signal terminal.
- Berguna untuk daemon.

**Tidak POSIX.** Tersedia di sebagian besar Unix.

### Contoh: Job Control

```sh
#!/bin/sh

# Jalankan 3 job di background
sleep 10 &
PID1=$!

sleep 20 &
PID2=$!

sleep 30 &
PID3=$!

echo "Job dijalankan: $PID1 $PID2 $PID3"

# Tunggu semua
wait

echo "Semua job selesai"
```

### Contoh: Tunggu Satu Per Satu

```sh
#!/bin/sh

for i in 1 2 3; do
    (sleep "$i" && echo "Selesai $i") &
done

wait

echo "Semua selesai"
```

### Contoh: Batasi Paralel

```sh
#!/bin/sh

MAX_JOBS=3
count=0

for file in *.txt; do
    # Proses file di background
    (proses "$file") &
    count=$((count + 1))
    
    if [ "$count" -ge "$MAX_JOBS" ]; then
        wait
        count=0
    fi
done

wait
echo "Selesai"
```

**Catatan:** `wait` tanpa argumen menunggu **semua** job. Untuk kontrol lebih baik, gunakan `jobs -p` (tidak POSIX) atau track PID.

### Contoh: Track PID

```sh
#!/bin/sh

MAX_JOBS=3
pids=""

for file in *.txt; do
    (proses "$file") &
    pid=$!
    pids="$pids $pid"
    
    # Hitung jumlah job aktif
    aktif=0
    for p in $pids; do
        if kill -0 "$p" 2>/dev/null; then
            aktif=$((aktif + 1))
        fi
    done
    
    # Jika sudah MAX_JOBS, tunggu satu selesai
    while [ "$aktif" -ge "$MAX_JOBS" ]; do
        sleep 0.1
        aktif=0
        for p in $pids; do
            if kill -0 "$p" 2>/dev/null; then
                aktif=$((aktif + 1))
            fi
        done
    done
done

# Tunggu semua
for p in $pids; do
    wait "$p" 2>/dev/null || true
done

echo "Selesai"
```

**Catatan:** Ini kurang efisien karena polling. Untuk solusi serius, gunakan `xargs -P`.

---

## 5.4.6 Process Group dan Session

### Process Group

**Process group** adalah kumpulan proses yang dapat menerima sinyal bersama.

```sh
ps -o pid,pgid,command
```

Output:

```
  PID  PGID COMMAND
 1234  1234 sh
 1235  1234 sleep 100
 1236  1234 sleep 200
```

Penjelasan:

- `PID` — Process ID.
- `PGID` — Process Group ID.
- Semua proses dalam satu shell berbagi PGID yang sama.

### Session

**Session** adalah kumpulan process group. Setiap session memiliki **controlling terminal** (opsional).

```sh
ps -o pid,sid,pgid,command
```

Output:

```
  PID   SID  PGID COMMAND
 1234  1234  1234 sh
 1235  1234  1234 sleep 100
```

Penjelasan:

- `SID` — Session ID.

### Foreground Process Group

Pada satu waktu, hanya **satu process group** yang menjadi foreground — menerima input dari terminal.

Ketika Anda menjalankan `perintah &`, shell menempatkan proses di background, dan process group lain (shell) tetap foreground.

### Sinyal ke Process Group

```sh
kill -TERM -"$PGID"
```

Penjelasan:

- `-PGID` — Tanda minus sebelum PGID berarti kirim ke seluruh process group.
- Semua proses dalam group menerima sinyal.

**Berguna untuk:** Menghentikan semua proses anak sekaligus.

### Contoh: Kill Process Tree

```sh
#!/bin/sh

# Jalankan proses yang membuat anak
proses_kompleks &
PID=$!

# ... nanti ...

# Kill seluruh process group
kill -TERM -"$PID" 2>/dev/null || kill -TERM "$PID"
```

**Catatan:** Untuk mendapatkan PGID, gunakan:

```sh
PGID=$(ps -o pgid= -p "$PID" | tr -d ' ')
```

---

## 5.4.7 PID File Management

**PID file** menyimpan PID proses yang berjalan. Berguna untuk:

- Mencegah dua instance.
- Mengirim sinyal ke proses.
- Cek status.

### Pola Standar

```sh
#!/bin/sh

PIDFILE="/var/run/myapp.pid"

# Cek apakah sudah berjalan
if [ -f "$PIDFILE" ]; then
    old_pid=$(cat "$PIDFILE")
    
    if kill -0 "$old_pid" 2>/dev/null; then
        echo "Sudah berjalan (PID: $old_pid)" >&2
        exit 1
    fi
    
    echo "PID file stale, menghapus" >&2
    rm -f "$PIDFILE"
fi

# Tulis PID
echo $$ > "$PIDFILE"

# Cleanup
cleanup() {
    status=$?
    rm -f "$PIDFILE"
    exit "$status"
}
trap cleanup EXIT INT TERM

# ... kode ...
```

### PID File Atomic

**Jebakan:** Antara cek dan tulis, proses lain bisa menyisipkan.

```sh
# Atomic dengan noclobber
set -C
if ! echo $$ > "$PIDFILE" 2>/dev/null; then
    set +C
    echo "Sudah berjalan" >&2
    exit 1
fi
set +C
```

### Membaca PID dengan Aman

```sh
if [ -f "$PIDFILE" ]; then
    old_pid=$(cat "$PIDFILE")
    
    # Validasi bahwa itu angka
    case "$old_pid" in
        ''|*[!0-9]*)
            echo "PID file korup" >&2
            rm -f "$PIDFILE"
            ;;
        *)
            if kill -0 "$old_pid" 2>/dev/null; then
                echo "Sudah berjalan (PID: $old_pid)" >&2
                exit 1
            fi
            rm -f "$PIDFILE"
            ;;
    esac
fi
```

---

## 5.4.8 Menulis Daemon Sederhana

**Daemon** adalah proses yang berjalan di latar belakang, tidak terikat terminal.

### Karakteristik Daemon

1. **Tidak memiliki controlling terminal.**
2. **Berjalan di session sendiri.**
3. **Menutup stdin, stdout, stderr** atau alihkan ke log.
4. **Berjalan di direktori root** atau direktori kerja tetap.
5. **Umask di-set** untuk mencegah izin yang tidak diinginkan.
6. **Menulis PID file.**
7. **Menangani sinyal dengan bersih.**

### Contoh Daemon Sederhana

```sh
#!/bin/sh
# Nama: daemon.sh
# Tujuan: Daemon sederhana yang menulis timestamp ke log

set -u

# Konfigurasi
PIDFILE="/tmp/daemon.pid"
LOGFILE="/tmp/daemon.log"
INTERVAL=5

# Fungsi logging
log() {
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >> "$LOGFILE"
}

# Cleanup
cleanup() {
    status=$?
    log "Daemon berhenti (status=$status)"
    rm -f "$PIDFILE"
    exit "$status"
}

# Handler sinyal
shutdown() {
    log "Menerima sinyal shutdown"
    RUNNING=0
}

reload() {
    log "Reload konfigurasi"
}

# Trap
trap cleanup EXIT INT TERM
trap shutdown INT TERM
trap reload HUP

# Cek sudah berjalan
if [ -f "$PIDFILE" ]; then
    old_pid=$(cat "$PIDFILE")
    if kill -0 "$old_pid" 2>/dev/null; then
        echo "Daemon sudah berjalan (PID: $old_pid)" >&2
        exit 1
    fi
    rm -f "$PIDFILE"
fi

# Tulis PID
echo $$ > "$PIDFILE"

# Daemonisasi: jalankan di background, lepas dari terminal
# Jika dijalankan manual dengan &, ini sudah cukup.
# Untuk daemonisasi penuh, gunakan setsid atau double-fork.

log "Daemon dimulai (PID: $$)"

# Loop utama
RUNNING=1
while [ "$RUNNING" -eq 1 ]; do
    log "Bekerja..."
    # Tunggu interval, tapi responsif terhadap sinyal
    i=0
    while [ "$i" -lt "$INTERVAL" ] && [ "$RUNNING" -eq 1 ]; do
        sleep 1
        i=$((i + 1))
    done
done

log "Keluar dari loop"
```

### Cara Menjalankan

```sh
# Foreground
./daemon.sh

# Background
./daemon.sh &

# Daemonisasi penuh
setsid ./daemon.sh < /dev/null > /dev/null 2>&1 &
```

### Daemonisasi dengan Double-Fork

Pola daemon klasik menggunakan **double-fork**:

1. Fork.
2. Parent keluar (daemon diadopsi oleh init).
3. `setsid()` — Session baru, tidak ada controlling terminal.
4. Fork lagi (opsional).
5. Ubah direktori kerja ke `/`.
6. Set `umask`.
7. Redirect stdin, stdout, stderr ke `/dev/null` atau log.

Di shell, ini tidak bisa sepenuhnya karena `setsid` adalah syscall. Tetapi `setsid` command bisa digunakan:

```sh
setsid ./daemon.sh < /dev/null > /dev/null 2>&1 &
```

### Menghentikan Daemon

```sh
if [ -f /tmp/daemon.pid ]; then
    kill -TERM "$(cat /tmp/daemon.pid)"
fi
```

### Reload Daemon

```sh
kill -HUP "$(cat /tmp/daemon.pid)"
```

---

## 5.4.9 Signal Forwarding

Ketika skrip Anda menjalankan proses lain, sinyal yang diterima skrip **tidak otomatis** diteruskan ke proses anak.

### Masalah

```sh
#!/bin/sh

trap 'echo "Menerima INT"' INT

sleep 100
```

Jika Anda menekan Ctrl+C, `sleep` menerima `SIGINT` (karena satu process group), tetapi skrip juga menerima. Trap skrip dijalankan, tetapi `sleep` mungkin masih berjalan.

### Solusi: Forwarding

```sh
#!/bin/sh

child_pid=""

forward() {
    sig="$1"
    if [ -n "$child_pid" ] && kill -0 "$child_pid" 2>/dev/null; then
        kill -"$sig" "$child_pid"
    fi
}

trap 'forward TERM' TERM
trap 'forward INT' INT

sleep 100 &
child_pid=$!

wait "$child_pid"
```

Penjelasan:

- Jalankan child di background.
- Simpan PID.
- Trap mengirim sinyal ke child.
- `wait` menunggu child.

### Contoh: Wrapper yang Forward Sinyal

```sh
#!/bin/sh
# Wrapper untuk menjalankan perintah dengan forwarding sinyal

if [ $# -eq 0 ]; then
    echo "Penggunaan: $0 perintah [arg...]" >&2
    exit 2
fi

child_pid=""

cleanup() {
    status=$?
    if [ -n "$child_pid" ] && kill -0 "$child_pid" 2>/dev/null; then
        kill -TERM "$child_pid"
        wait "$child_pid" 2>/dev/null
    fi
    exit "$status"
}

forward() {
    sig="$1"
    if [ -n "$child_pid" ] && kill -0 "$child_pid" 2>/dev/null; then
        kill -"$sig" "$child_pid"
    fi
}

trap cleanup EXIT
trap 'forward INT' INT
trap 'forward TERM' TERM
trap 'forward HUP' HUP

"$@" &
child_pid=$!

wait "$child_pid"
status=$?

exit "$status"
```

**Catatan:** Ini adalah pola yang digunakan oleh banyak wrapper seperti `timeout`, `sudo`, dll.

---

## 5.4.10 Graceful Shutdown

**Graceful shutdown** adalah menghentikan proses dengan bersih: menyelesaikan pekerjaan, membersihkan sumber daya, dan keluar.

### Prinsip

1. **Tangkap sinyal** `TERM` dan `INT`.
2. **Set flag** untuk menghentikan loop.
3. **Selesaikan pekerjaan** yang sedang berjalan.
4. **Bersihkan sumber daya** (file, lock, PID file).
5. **Keluar dengan status** yang sesuai.

### Contoh

```sh
#!/bin/sh

RUNNING=1
CURRENT_FILE=""

shutdown() {
    echo "Menerima sinyal shutdown" >&2
    RUNNING=0
}

cleanup() {
    status=$?
    echo "Cleanup..." >&2
    [ -n "$CURRENT_FILE" ] && rm -f "$CURRENT_FILE"
    rm -f /tmp/myapp.pid
    exit "$status"
}

trap shutdown INT TERM
trap cleanup EXIT

echo "Berjalan (PID $$). Ctrl+C untuk berhenti."

while [ "$RUNNING" -eq 1 ]; do
    CURRENT_FILE="/tmp/myapp.$$"
    echo "data" > "$CURRENT_FILE"
    
    # Simulasi kerja
    i=0
    while [ "$i" -lt 5 ] && [ "$RUNNING" -eq 1 ]; do
        sleep 1
        i=$((i + 1))
    done
    
    rm -f "$CURRENT_FILE"
    CURRENT_FILE=""
done

echo "Keluar dengan bersih"
```

### Timeout untuk Shutdown

Jika proses tidak merespons sinyal `TERM`, gunakan `KILL` setelah timeout:

```sh
#!/bin/sh

graceful_shutdown() {
    PID="$1"
    TIMEOUT="${2:-10}"
    
    kill -TERM "$PID" 2>/dev/null
    
    i=0
    while [ "$i" -lt "$TIMEOUT" ]; do
        if ! kill -0 "$PID" 2>/dev/null; then
            return 0
        fi
        sleep 1
        i=$((i + 1))
    done
    
    echo "Proses tidak merespons, menggunakan SIGKILL" >&2
    kill -KILL "$PID" 2>/dev/null
    return 0
}
```

---

## 5.4.11 Contoh Skrip Lengkap

### Skrip 1: Service Wrapper

```sh
#!/bin/sh
# Nama: service.sh
# Tujuan: Service wrapper dengan start/stop/status/reload

set -u

PIDFILE="/tmp/myapp.pid"
LOGFILE="/tmp/myapp.log"
DAEMON="/path/to/daemon.sh"

log() {
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" | tee -a "$LOGFILE" >&2
}

start() {
    if [ -f "$PIDFILE" ]; then
        pid=$(cat "$PIDFILE")
        if kill -0 "$pid" 2>/dev/null; then
            echo "Sudah berjalan (PID: $pid)" >&2
            return 1
        fi
        rm -f "$PIDFILE"
    fi
    
    log "Memulai..."
    "$DAEMON" &
    
    # Tunggu PID file dibuat
    i=0
    while [ "$i" -lt 10 ] && [ ! -f "$PIDFILE" ]; do
        sleep 1
        i=$((i + 1))
    done
    
    if [ -f "$PIDFILE" ]; then
        echo "Berjalan (PID: $(cat "$PIDFILE"))"
    else
        echo "Gagal memulai" >&2
        return 1
    fi
}

stop() {
    if [ ! -f "$PIDFILE" ]; then
        echo "Tidak berjalan" >&2
        return 1
    fi
    
    pid=$(cat "$PIDFILE")
    log "Menghentikan (PID: $pid)..."
    
    kill -TERM "$pid" 2>/dev/null
    
    # Tunggu
    i=0
    while [ "$i" -lt 10 ]; do
        if ! kill -0 "$pid" 2>/dev/null; then
            rm -f "$PIDFILE"
            echo "Berhenti"
            return 0
        fi
        sleep 1
        i=$((i + 1))
    done
    
    log "Proses tidak merespons, SIGKILL"
    kill -KILL "$pid" 2>/dev/null
    rm -f "$PIDFILE"
    echo "Dipaksa berhenti"
}

status() {
    if [ ! -f "$PIDFILE" ]; then
        echo "Tidak berjalan"
        return 3
    fi
    
    pid=$(cat "$PIDFILE")
    
    if kill -0 "$pid" 2>/dev/null; then
        echo "Berjalan (PID: $pid)"
        return 0
    else
        echo "PID file ada tetapi proses tidak berjalan"
        return 1
    fi
}

reload() {
    if [ ! -f "$PIDFILE" ]; then
        echo "Tidak berjalan" >&2
        return 1
    fi
    
    pid=$(cat "$PIDFILE")
    kill -HUP "$pid" 2>/dev/null
    echo "Sinyal reload dikirim"
}

case "${1:-}" in
    start)   start ;;
    stop)    stop ;;
    status)  status ;;
    reload)  reload ;;
    restart)
        stop
        sleep 1
        start
        ;;
    *)
        echo "Penggunaan: $0 {start|stop|status|reload|restart}" >&2
        exit 2
        ;;
esac
```

### Skrip 2: Timeout Wrapper

```sh
#!/bin/sh
# Nama: timeout.sh
# Tujuan: Jalankan perintah dengan timeout

set -u

if [ $# -lt 2 ]; then
    echo "Penggunaan: $0 detik perintah [arg...]" >&2
    exit 2
fi

TIMEOUT="$1"
shift

case "$TIMEOUT" in
    ''|*[!0-9]*)
        echo "Timeout harus angka positif" >&2
        exit 2
        ;;
esac

# Jalankan perintah di background
"$@" &
child_pid=$!

# Tunggu dengan timeout
elapsed=0
while [ "$elapsed" -lt "$TIMEOUT" ]; do
    if ! kill -0 "$child_pid" 2>/dev/null; then
        # Perintah selesai
        wait "$child_pid"
        exit $?
    fi
    sleep 1
    elapsed=$((elapsed + 1))
done

# Timeout — kill
echo "Timeout setelah ${TIMEOUT}s" >&2
kill -TERM "$child_pid" 2>/dev/null

# Tunggu sebentar untuk cleanup
sleep 1

if kill -0 "$child_pid" 2>/dev/null; then
    kill -KILL "$child_pid" 2>/dev/null
fi

wait "$child_pid" 2>/dev/null
exit 124    # Konvensi timeout
```

**Catatan:** Perintah `timeout` sudah ada di GNU coreutils dan sebagian besar sistem. Untuk portabilitas, wrapper ini berguna.

### Skrip 3: Worker Pool Sederhana

```sh
#!/bin/sh
# Nama: pool.sh
# Tujuan: Jalankan tugas dengan batas paralel

set -u

MAX_JOBS=4
TASKS=""

# Fungsi yang dijalankan sebagai worker
worker() {
    task="$1"
    printf 'Memproses: %s (PID %d)\n' "$task" "$$"
    sleep 2
    printf 'Selesai: %s\n' "$task"
}

# Tambah task
add_task() {
    TASKS="$TASKS $1"
}

# Tunggu slot kosong
wait_slot() {
    while :; do
        aktif=0
        for pid in $(jobs -p 2>/dev/null); do
            aktif=$((aktif + 1))
        done
        
        [ "$aktif" -lt "$MAX_JOBS" ] && return 0
        sleep 0.5
    done
}

# Proses tugas
for i in 1 2 3 4 5 6 7 8 9 10; do
    wait_slot
    worker "task-$i" &
done

wait
echo "Semua tugas selesai"
```

**Catatan:** `jobs -p` tidak POSIX. Untuk portabilitas, gunakan tracking PID manual (lihat 5.4.5).

---

## 5.4.12 Latihan

1. **Signal Dasar:**
   - Tulis skrip yang menangkap `INT` dan mencetak pesan.
   - Uji dengan Ctrl+C.
   - Uji dengan `kill -INT`.

2. **Trap EXIT:**
   - Tulis skrip yang membuat file temporary.
   - Trap `EXIT` untuk menghapusnya.
   - Uji dengan Ctrl+C dan `kill -TERM`.

3. **SIGHUP Reload:**
   - Tulis skrip yang membaca konfigurasi.
   - Trap `HUP` untuk reload.
   - Uji dengan `kill -HUP`.

4. **Job Control:**
   - Jalankan 3 `sleep` di background.
   - `jobs` untuk melihat.
   - `fg` untuk bawa satu ke foreground.
   - Ctrl+Z untuk suspend.
   - `bg` untuk background.
   - `wait` untuk tunggu semua.

5. **PID File:**
   - Tulis skrip dengan PID file.
   - Coba jalankan dua instance.
   - Instance kedua harus gagal.

6. **Daemon:**
   - Tulis daemon sederhana yang menulis timestamp ke log setiap 5 detik.
   - PID file, trap, graceful shutdown.
   - Uji dengan `kill -TERM`.

7. **Signal Forwarding:**
   - Tulis wrapper yang meneruskan `INT` dan `TERM` ke child.
   - Uji dengan Ctrl+C.
   - Pastikan child dihentikan dengan bersih.

8. **Graceful Shutdown:**
   - Tulis skrip dengan loop yang mengecek flag `RUNNING`.
   - Trap `TERM` untuk set flag.
   - Uji dengan `kill -TERM`.

9. **Timeout:**
   - Tulis wrapper timeout.
   - Uji dengan perintah yang cepat dan lambat.
   - Pastikan exit code sesuai.

10. **Process Group:**
    - Tulis skrip yang menjalankan proses dengan anak.
    - Kirim sinyal ke seluruh process group.
    - Uji dengan `kill -TERM -PGID`.

11. **Reload:**
    - Tulis daemon yang membaca file konfigurasi setiap `SIGHUP`.
    - Uji dengan mengubah konfigurasi dan mengirim `HUP`.

12. **Service Wrapper:**
    - Implementasi `start`, `stop`, `status`, `reload`, `restart`.
    - Uji semua subcommand.

13. **Worker Pool:**
    - Tulis worker pool dengan batas paralel.
    - Jalankan 20 task dengan 4 worker.
    - Pastikan tidak lebih dari 4 proses aktif.

14. **Signal Safety:**
    - Tulis skrip yang menangani `INT` di tengah operasi kritis.
    - Pastikan cleanup dijalankan.
    - Uji dengan mengirim `INT` di berbagai titik.

---

## 5.4.13 Ringkasan Materi 4

- **Signal** adalah notifikasi asinkron dari kernel atau proses.
- **Sinyal penting**: `INT`, `TERM`, `HUP`, `USR1`, `USR2`, `KILL`, `STOP`, `CONT`, `CHLD`.
- `SIGKILL` dan `SIGSTOP` **tidak dapat ditangkap**.
- `kill -SIGNAL PID` untuk mengirim sinyal. `kill -0 PID` untuk cek keberadaan.
- **`trap`** untuk menangkap sinyal: `trap 'handler' SIGNAL...`.
- Trap `EXIT` dijalankan apapun penyebab keluar. Gunakan untuk cleanup.
- **Job control**: `&`, `jobs`, `fg`, `bg`, `wait`, `disown`.
- **Process group** dan **session** mengelompokkan proses untuk manajemen sinyal.
- **PID file** untuk melacak proses. Gunakan atomic write (`noclobber`).
- **Daemon** berjalan di background, tanpa controlling terminal.
- **Signal forwarding** untuk meneruskan sinyal ke proses anak.
- **Graceful shutdown**: trap sinyal, set flag, selesaikan pekerjaan, cleanup.
- **Service wrapper** dengan `start`, `stop`, `status`, `reload`.
- **Worker pool** untuk batas paralel.

**Prinsip utama:**

> **"Proses adalah entitas. Signal adalah komunikasi. Kendalikan keduanya, dan Anda mengendalikan sistem."**

---

## 📌 Selanjutnya

Materi 4 Level 5 selesai. Anda sekarang menguasai signal handling dan job control secara mendalam.

Berikutnya adalah **Materi 5: Kontribusi Open Source** — ini adalah **materi terakhir** dari Level 5 dan dari seluruh kurikulum. Kita akan membahas:

- **Standar proyek** open source: POSIX, shellcheck, testing.
- **Panduan gaya** proyek (Google Shell Style Guide, dll).
- **Code review** skrip shell.
- **Testing lintas platform** dengan CI/CD.
- **Dokumentasi** untuk proyek open source.
- **Distribusi** via package manager.
- **Berkontribusi** ke proyek yang sudah ada.
- **Menulis skrip** yang dapat digunakan orang lain.
- **Etika dan lisensi** open source.

## Materi 5: Kontribusi Open Source

> **Catatan:** Ini adalah **materi kelima** dan **terakhir** dari Level 5 — sekaligus **materi terakhir dari seluruh kurikulum**. Kita akan menutup perjalanan ini dengan membahas bagaimana membawa skrip Anda dari "berfungsi di komputer sendiri" menjadi "digunakan oleh ribuan orang di seluruh dunia". Kita akan membahas standar proyek, code review, CI/CD, distribusi, dan etika open source. Setelah materi ini, Anda siap berkontribusi ke ekosistem shell global.

---

## 🎯 Tujuan Materi 5

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Memahami **ekosistem open source** dan peran skrip shell di dalamnya.
2. Mengikuti **standar proyek** yang diakui: POSIX, ShellCheck, testing.
3. Menerapkan **panduan gaya** yang digunakan proyek besar.
4. Melakukan **code review** yang konstruktif untuk skrip shell.
5. Menyiapkan **CI/CD** untuk testing lintas platform.
6. Menulis **dokumentasi** yang memadai untuk proyek open source.
7. Mendistribusikan skrip via **package manager** dan saluran lain.
8. **Berkontribusi** ke proyek open source yang sudah ada.
9. Memahami **lisensi** dan **etika** open source.
10. Menutup kurikulum dengan **roadmap** untuk terus berkembang.

---

## 5.5.1 Ekosistem Open Source dan Skrip Shell

### Peran Skrip Shell di Open Source

Skrip shell adalah **lem** yang menyatukan sistem Unix. Hampir setiap proyek open source memiliki skrip shell:

- **Build script** — `configure`, `Makefile`, `build.sh`.
- **Instalasi** — `install.sh`.
- **CI/CD** — GitHub Actions, GitLab CI, Travis CI.
- **Maintenance** — backup, deployment, monitoring.
- **Wrapper** — pembungkus program lain.
- **Utilitas** — alat bantu kecil.

### Contoh Proyek Terkenal

| Proyek | Skrip Shell |
|--------|-------------|
| Linux kernel | `scripts/` — banyak skrip build |
| Git | `git-sh-setup`, `git-filter-branch` |
| Docker | `dockerd-entrypoint.sh` |
| Homebrew | Formula dalam Ruby, tetapi banyak helper shell |
| NGINX | `nginx-init` |
| autoconf | `configure` yang dihasilkan |
| rbenv / pyenv | Skrip shell untuk version management |
| nvm | Skrip shell untuk Node version management |

### Apa yang Membuat Skrip Open Source Berhasil?

1. **Portabel** — Berjalan di banyak sistem.
2. **Teruji** — Ada test otomatis.
3. **Terdokumentasi** — README, man page, komentar.
4. **Konsisten** — Gaya kode seragam.
5. **Aman** — Tidak rentan terhadap serangan.
6. **Aktif** — Dipelihara, ada respons terhadap issue.
7. **Berlisensi jelas** — MIT, Apache, GPL.

---

## 5.5.2 Standar Proyek: POSIX, ShellCheck, Testing

### POSIX sebagai Standar Minimum

Proyek yang ingin portabel harus mengikuti POSIX. Checklist (review dari Level 4):

- [ ] Shebang `#!/bin/sh`.
- [ ] Tidak ada `[[ ]]`, `(( ))`, `local`, `source`, array, `<<<`, `$'...'`, `{a,b}`.
- [ ] Kutip semua variabel.
- [ ] Gunakan `printf`, bukan `echo -e` / `echo -n`.
- [ ] `getopts` untuk parsing argumen.
- [ ] Trap untuk cleanup.

### ShellCheck sebagai Standar Kualitas

ShellCheck adalah **de facto standard** untuk analisis statis skrip shell.

**Konfigurasi `.shellcheckrc`:**

```
shell=sh
severity=warning
enable=all
external-sources=true
```

Penjelasan:

- `shell=sh` — Dialect default.
- `severity=warning` — Hanya tampilkan warning dan error.
- `enable=all` — Aktifkan semua pemeriksaan.
- `external-sources=true` — Periksa file yang di-source.

**Menjalankan ShellCheck:**

```sh
shellcheck -s sh skrip.sh
shellcheck -s sh lib/*.sh
find . -name "*.sh" -exec shellcheck -s sh {} +
```

**Integrasi dengan Git Hook:**

`.git/hooks/pre-commit`:

```sh
#!/bin/sh

changed=$(git diff --cached --name-only --diff-filter=ACM | grep '\.sh$')

if [ -z "$changed" ]; then
    exit 0
fi

echo "Menjalankan shellcheck..."
if ! shellcheck -s sh $changed; then
    echo "ShellCheck gagal. Commit dibatalkan." >&2
    exit 1
fi
```

### Testing sebagai Standar

Setiap proyek serius harus memiliki test.

**Struktur test:**

```
test/
├── unit/
│   ├── test_string.sh
│   └── test_file.sh
├── integration/
│   └── test_cli.sh
├── fixtures/
│   ├── input.txt
│   └── expected.txt
└── run_all.sh
```

**`test/run_all.sh`:**

```sh
#!/bin/sh

set -u

SCRIPT_DIR=$(dirname "$0")
case "$SCRIPT_DIR" in
    /*) ;;
    *) SCRIPT_DIR="$PWD/$SCRIPT_DIR" ;;
esac

PASS=0
FAIL=0

run_test() {
    file="$1"
    printf 'Menjalankan: %s\n' "$file"
    if sh "$file"; then
        PASS=$((PASS + 1))
    else
        FAIL=$((FAIL + 1))
        printf 'GAGAL: %s\n' "$file" >&2
    fi
}

for test in "$SCRIPT_DIR"/unit/*.sh "$SCRIPT_DIR"/integration/*.sh; do
    [ -f "$test" ] || continue
    run_test "$test"
done

printf '\n%d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
```

**Framework test: `shunit2`**

```sh
#!/bin/sh
# test/unit/test_string.sh

. "$(dirname "$0")/../../lib/string.sh"

test_trim_spasi() {
    assertEquals "hello" "$(str_trim '  hello  ')"
}

test_trim_tanpa_spasi() {
    assertEquals "hello" "$(str_trim 'hello')"
}

test_upper() {
    assertEquals "HELLO" "$(str_upper 'hello')"
}

. shunit2
```

### Standar Dokumentasi

Setiap skrip harus memiliki:

1. **Header** — Nama, deskripsi, penulis, lisensi.
2. **Dokumentasi fungsi** — Argumen, output, return.
3. **README** — Overview, instalasi, penggunaan.
4. **CHANGELOG** — Riwayat perubahan.
5. **LICENSE** — Lisensi.
6. **CONTRIBUTING** — Panduan kontribusi.
7. **Man page** (opsional) — Dokumentasi formal.

---

## 5.5.3 Panduan Gaya Proyek

### Google Shell Style Guide

Google memiliki **Shell Style Guide** yang diakui luas. Poin-poin utama:

**1. Shebang:**

```sh
#!/bin/sh    # POSIX
#!/bin/bash  # Bash (dengan fitur bash)
```

**2. Indentasi:** 2 spasi (Google) atau 4 spasi. Konsisten.

**3. Panjang baris:** Maksimum 80 karakter.

**4. Nama file:** Huruf kecil dengan underscore, akhiran `.sh`.

**5. Nama fungsi:** Huruf kecil dengan underscore.

**6. Variabel:** Huruf kecil dengan underscore. Konstanta HURUF BESAR.

**7. Kutip variabel:** Selalu `"$var"`.

**8. Gunakan `$(...)` bukan backtick.**

**9. Gunakan `[[ ]]` di bash, `[ ]` di POSIX.**

**10. Cek return value:**

```sh
if ! perintah; then
    echo "Error" >&2
    exit 1
fi
```

**11. Gunakan `local` di fungsi (bash).**

**12. Hindari `eval`.**

**13. Komentar untuk kode kompleks.**

**14. Baris kosong antar fungsi.**

### Contoh Kode Sesuai Gaya Google

```sh
#!/bin/sh
#
# Backup file .txt dari direktori sumber.

readonly SUMBER="/home/budi/dokumen"
readonly TUJUAN="/mnt/backup"

# backup_file: Menyalin file .txt.
#
# Argumen:
#   $1 - File sumber.
#   $2 - Direktori tujuan.
backup_file() {
    local file="$1"
    local tujuan="$2"
    
    if [ ! -f "$file" ]; then
        echo "Error: $file tidak ada" >&2
        return 1
    fi
    
    cp -p "$file" "$tujuan/"
}

main() {
    mkdir -p "$TUJUAN" || exit 1
    
    for file in "$SUMBER"/*.txt; do
        [ -f "$file" ] || continue
        backup_file "$file" "$TUJUAN"
    done
}

main "$@"
```

### Alternatif: Shell Style Guide Lain

- **Google Shell Style Guide** — Paling banyak diikuti.
- **Chromium Shell Style** — Mirip Google.
- **FreeBSD Style** — Untuk proyek BSD.

Pilih satu dan konsisten.

---

## 5.5.4 Code Review untuk Skrip Shell

### Mengapa Code Review Penting?

1. **Menangkap bug** sebelum production.
2. **Meningkatkan kualitas** kode.
3. **Berbagi pengetahuan** antar kontributor.
4. **Konsistensi** gaya dan praktik.
5. **Keamanan** — Menangkap kerentanan.

### Checklist Code Review

**Fungsionalitas:**

- [ ] Apakah skrip melakukan apa yang dimaksud?
- [ ] Apakah ada edge case yang tidak ditangani?
- [ ] Apakah error handling memadai?
- [ ] Apakah ada race condition?

**Portabilitas:**

- [ ] Apakah shebang tepat?
- [ ] Apakah ada bashism?
- [ ] Apakah menggunakan opsi non-POSIX?
- [ ] Apakah berjalan di `dash`, `bash`, `ksh`?

**Keamanan:**

- [ ] Apakah variabel dikutip?
- [ ] Apakah ada `eval`?
- [ ] Apakah input disanitasi?
- [ ] Apakah temporary file aman?
- [ ] Apakah ada symlink attack?

**Kualitas:**

- [ ] Apakah nama variabel dan fungsi deskriptif?
- [ ] Apakah ada dokumentasi?
- [ ] Apakah ada test?
- [ ] Apakah ShellCheck lulus?

**Gaya:**

- [ ] Apakah indentasi konsisten?
- [ ] Apakah panjang baris wajar?
- [ ] Apakah komentar bermakna?

### Contoh Komentar Code Review

**Buruk:**

```
Ini salah.
```

**Baik:**

```
Baris 15: `$file` tidak dikutip. Jika nama file mengandung spasi,
`rm $file` akan menghapus file yang salah. Gunakan `rm "$file"`.

Contoh:
  file="my doc.txt"
  rm $file        # Menghapus "my" dan "doc.txt"
  rm "$file"      # Menghapus "my doc.txt"
```

### Review dengan Tool

- **GitHub Pull Requests** — Diskusi inline.
- **GitLab Merge Requests** — Sama.
- **Reviewable.io** — Untuk review mendalam.
- **Gerrit** — Untuk proyek besar.

### Etika Code Review

1. **Fokus pada kode**, bukan orang.
2. **Jelaskan mengapa**, bukan hanya apa.
3. **Beri contoh** kode yang benar.
4. **Apresiasi** yang baik.
5. **Terima feedback** dengan terbuka.
6. **Jangan bloating** — Jika tidak penting, jangan komentari.

---

## 5.5.5 CI/CD untuk Skrip Shell

**CI/CD** (Continuous Integration / Continuous Deployment) mengotomatiskan testing dan deployment.

### GitHub Actions

`.github/workflows/test.yml`:

```yaml
name: Test

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest]
        shell: [sh, bash, dash]
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Install shellcheck
        run: |
          if [ "$RUNNER_OS" = "Linux" ]; then
            sudo apt-get install -y shellcheck
          elif [ "$RUNNER_OS" = "macOS" ]; then
            brew install shellcheck
          fi
      
      - name: Run ShellCheck
        run: |
          find . -name "*.sh" -exec shellcheck -s sh {} +
      
      - name: Run tests
        run: |
          ${{ matrix.shell }} test/run_all.sh
```

Penjelasan:

- `matrix.os` — Test di Ubuntu dan macOS.
- `matrix.shell` — Test dengan sh, bash, dash.
- `actions/checkout` — Checkout kode.
- `shellcheck` — Analisis statis.
- `test/run_all.sh` — Test.

### GitLab CI

`.gitlab-ci.yml`:

```yaml
stages:
  - lint
  - test

shellcheck:
  stage: lint
  image: koalaman/shellcheck-alpine:stable
  script:
    - shellcheck -s sh bin/myapp lib/*.sh lib/command/*.sh

test:
  stage: test
  image: alpine:latest
  before_script:
    - apk add --no-cache bash dash
  script:
    - sh test/run_all.sh
    - bash test/run_all.sh
    - dash test/run_all.sh
```

### Travis CI

`.travis.yml`:

```yaml
language: shell
os:
  - linux
  - osx

before_install:
  - if [ "$TRAVIS_OS_NAME" = "linux" ]; then sudo apt-get install -y shellcheck; fi
  - if [ "$TRAVIS_OS_NAME" = "osx" ]; then brew install shellcheck; fi

script:
  - shellcheck -s sh bin/myapp lib/*.sh
  - sh test/run_all.sh
  - bash test/run_all.sh
```

### Pre-commit Hook

`.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/koalaman/shellcheck-precommit
    rev: v0.9.0
    hooks:
      - id: shellcheck
        args: [-s, sh]
```

### Badge

Tambahkan badge ke README:

```markdown
[![Test](https://github.com/user/repo/actions/workflows/test.yml/badge.svg)](https://github.com/user/repo/actions/workflows/test.yml)
```

---

## 5.5.6 Dokumentasi untuk Proyek Open Source

### README.md

```markdown
# MyApp

MyApp adalah CLI tool untuk ... (deskripsi singkat).

[![Test](https://github.com/user/myapp/actions/workflows/test.yml/badge.svg)](https://github.com/user/myapp/actions/workflows/test.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Fitur

- Fitur 1
- Fitur 2
- Fitur 3

## Instalasi

### Dari source

```sh
git clone https://github.com/user/myapp.git
cd myapp
make install
```

### Dari package manager

```sh
# Debian/Ubuntu
apt-get install myapp

# macOS
brew install myapp
```

## Penggunaan

```sh
myapp init
myapp run --output /tmp
myapp status
```

## Dokumentasi

- [Arsitektur](doc/ARCHITECTURE.md)
- [Kontribusi](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)

## Lisensi

MIT — lihat [LICENSE](LICENSE).

## Kontributor

- Budi Santoso (@budi)
- Ani Rahayu (@ani)
```

### CONTRIBUTING.md

```markdown
# Panduan Kontribusi

Terima kasih atas minat Anda untuk berkontribusi!

## Cara Berkontribusi

1. Fork repository.
2. Buat branch fitur: `git checkout -b feature/fitur-baru`.
3. Commit perubahan: `git commit -m 'feat: tambah fitur baru'`.
4. Push ke branch: `git push origin feature/fitur-baru`.
5. Buat Pull Request.

## Standar Kode

- Ikuti POSIX sh.
- Jalankan `shellcheck -s sh` sebelum commit.
- Tambahkan test untuk fitur baru.
- Dokumentasikan fungsi dengan format standar.

## Test

```sh
make test
```

## Gaya Commit

- `feat:` — Fitur baru.
- `fix:` — Bug fix.
- `docs:` — Dokumentasi.
- `test:` — Test.
- `refactor:` — Refactoring.

## Lisensi

Dengan berkontribusi, Anda setuju bahwa kontribusi Anda dilisensikan
di bawah MIT License.
```

### CHANGELOG.md

```markdown
# Changelog

Semua perubahan penting didokumentasikan di file ini.

Format berdasarkan [Keep a Changelog](https://keepachangelog.com/).
Versioning berdasarkan [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- Fitur baru yang sedang dikembangkan.

## [1.2.0] - 2026-01-15

### Added
- Subcommand `status`.
- Dukungan konfigurasi JSON.

### Changed
- Refaktor modul `config`.

### Fixed
- Bug parsing argumen dengan spasi (#42).

## [1.1.0] - 2026-01-01

### Added
- Subcommand `run`.
- Logging dengan level.

## [1.0.0] - 2025-12-15

### Added
- Rilis pertama.
- Subcommand `init`.
```

### Man Page

`doc/myapp.1`:

```roff
.TH MYAPP 1 "2026-01-01" "1.0.0" "User Commands"
.SH NAME
myapp \- CLI tool untuk ...
.SH SYNOPSIS
.B myapp
[\fIOPTIONS\fR] \fICOMMAND\fR [\fIARGS\fR]
.SH DESCRIPTION
.B myapp
adalah ...
.SH OPTIONS
.TP
.B \-h, \-\-help
Tampilkan bantuan.
.TP
.B \-v, \-\-verbose
Mode verbose.
.SH COMMANDS
.TP
.B init
Inisialisasi konfigurasi.
.TP
.B run
Jalankan operasi utama.
.SH EXAMPLES
.PP
Inisialisasi:
.PP
.nf
.RS
myapp init
.RE
.fi
.SH SEE ALSO
.BR sh (1),
.BR bash (1)
.SH AUTHOR
Budi Santoso <budi@example.com>
```

Install man page:

```makefile
install-man:
	install -d $(DESTDIR)$(PREFIX)/share/man/man1
	install -m 644 doc/myapp.1 $(DESTDIR)$(PREFIX)/share/man/man1/
```

---

## 5.5.7 Distribusi via Package Manager

### Distribusi Sederhana: Tarball

```sh
tar czf myapp-1.0.0.tar.gz \
    --exclude='.git' \
    --exclude='*.log' \
    bin/ lib/ test/ doc/ \
    README.md LICENSE CHANGELOG.md CONTRIBUTING.md Makefile

sha256sum myapp-1.0.0.tar.gz > myapp-1.0.0.tar.gz.sha256
```

### Homebrew (macOS/Linux)

Buat formula `myapp.rb`:

```ruby
class Myapp < Formula
  desc "CLI tool untuk ..."
  homepage "https://github.com/user/myapp"
  url "https://github.com/user/myapp/archive/v1.0.0.tar.gz"
  sha256 "abc123..."
  license "MIT"

  def install
    bin.install "bin/myapp"
    lib.install Dir["lib/*.sh"]
    (lib/"myapp/command").install Dir["lib/command/*.sh"]
  end

  test do
    system "#{bin}/myapp", "version"
  end
end
```

Submit ke [homebrew-core](https://github.com/Homebrew/homebrew-core).

### Debian/Ubuntu

Buat paket `.deb` dengan `dh_make`:

```sh
# Struktur
myapp-1.0.0/
├── debian/
│   ├── control
│   ├── changelog
│   ├── copyright
│   ├── rules
│   └── install
└── ...
```

`debian/control`:

```
Source: myapp
Section: utils
Priority: optional
Maintainer: Budi Santoso <budi@example.com>
Build-Depends: debhelper (>= 13)
Standards-Version: 4.5.0

Package: myapp
Architecture: all
Depends: ${misc:Depends}
Description: CLI tool untuk ...
 MyApp adalah ...
```

Build:

```sh
dpkg-buildpackage -us -uc
```

### Arch Linux (AUR)

Buat `PKGBUILD`:

```bash
pkgname=myapp
pkgver=1.0.0
pkgrel=1
pkgdesc="CLI tool untuk ..."
arch=('any')
url="https://github.com/user/myapp"
license=('MIT')
source=("$url/archive/v$pkgver.tar.gz")
sha256sums=('abc123...')

package() {
    cd "$srcdir/myapp-$pkgver"
    install -Dm755 bin/myapp "$pkgdir/usr/bin/myapp"
    install -Dm644 lib/*.sh "$pkgdir/usr/lib/myapp/"
    install -Dm644 lib/command/*.sh "$pkgdir/usr/lib/myapp/command/"
}
```

### Alpine Linux

Buat `APKBUILD`:

```
pkgname=myapp
pkgver=1.0.0
pkgrel=0
pkgdesc="CLI tool untuk ..."
url="https://github.com/user/myapp"
license="MIT"
arch="noarch"
depends=""
makedepends=""
source="$pkgname-$pkgver.tar.gz::https://github.com/user/myapp/archive/v$pkgver.tar.gz"
builddir="$srcdir/myapp-$pkgver"

package() {
    mkdir -p "$pkgdir/usr/bin"
    install -m 755 bin/myapp "$pkgdir/usr/bin/myapp"
    mkdir -p "$pkgdir/usr/lib/myapp/command"
    cp lib/*.sh "$pkgdir/usr/lib/myapp/"
    cp lib/command/*.sh "$pkgdir/usr/lib/myapp/command/"
}
```

### Distribusi Universal: `install.sh`

```sh
#!/bin/sh
# install.sh — Instalasi universal

set -eu

PREFIX="${PREFIX:-/usr/local}"
BINDIR="$PREFIX/bin"
LIBDIR="$PREFIX/lib/myapp"

# Cek user
if [ "$(id -u)" -eq 0 ]; then
    :
elif [ -w "$PREFIX" ]; then
    :
else
    echo "Error: butuh root atau PREFIX yang dapat ditulis." >&2
    exit 1
fi

# Cek dependensi
for cmd in sh mkdir cp chmod; do
    if ! command -v "$cmd" > /dev/null 2>&1; then
        echo "Error: $cmd tidak ditemukan." >&2
        exit 1
    fi
done

# Install
install -d "$BINDIR" "$LIBDIR" "$LIBDIR/command"
install -m 755 bin/myapp "$BINDIR/myapp"
install -m 644 lib/*.sh "$LIBDIR/"
install -m 644 lib/command/*.sh "$LIBDIR/command/"

echo "Instalasi selesai:"
echo "  Binary: $BINDIR/myapp"
echo "  Library: $LIBDIR"
```

---

## 5.5.8 Berkontribusi ke Proyek yang Sudah Ada

### Langkah-langkah

**1. Pilih proyek:**

- Cari proyek yang Anda gunakan.
- Lihat issue `good first issue` atau `help wanted`.
- Pastikan proyek aktif (commit terbaru).

**2. Pelajari proyek:**

- Baca README, CONTRIBUTING.
- Baca kode.
- Pahami arsitektur.
- Jalankan test.

**3. Fork dan clone:**

```sh
git clone https://github.com/your-username/proyek.git
cd proyek
git remote add upstream https://github.com/original/proyek.git
```

**4. Buat branch:**

```sh
git checkout -b fix/bug-123
```

**5. Lakukan perubahan:**

- Ikuti gaya kode proyek.
- Tambahkan test.
- Update dokumentasi.

**6. Test:**

```sh
make test
shellcheck -s sh skrip.sh
```

**7. Commit:**

```sh
git add .
git commit -m "fix: perbaiki parsing argumen dengan spasi

Fixes #123"
```

**8. Push dan PR:**

```sh
git push origin fix/bug-123
```

Buka Pull Request di GitHub.

**9. Respons review:**

- Jawab komentar.
- Perbaiki sesuai feedback.
- Push commit tambahan.
- Bersabar.

**10. Merge:**

Setelah disetujui, maintainer akan merge.

### Etika Kontribusi

1. **Baca CONTRIBUTING** sebelum mulai.
2. **Satu PR, satu fitur.** Jangan campur banyak perubahan.
3. **Commit message yang baik.**
4. **Test sebelum push.**
5. **Jangan marah jika ditolak.**
6. **Terima feedback dengan terbuka.**
7. **Berkontribusi jangka panjang**, bukan hanya sekali.

### Menemukan Proyek

- **GitHub Explore** — Trending, topic.
- **Good First Issue** — [goodfirstissue.dev](https://goodfirstissue.dev)
- **Up For Grabs** — [up-for-grabs.net](https://up-for-grabs.net)
- **First Timers Only** — [firsttimersonly.com](https://www.firsttimersonly.com)

---

## 5.5.9 Lisensi dan Etika Open Source

### Lisensi Umum

| Lisensi | Karakteristik |
|---------|---------------|
| **MIT** | Permisif, hanya butuh attribution |
| **Apache 2.0** | Permisif, + patent grant |
| **BSD** | Permisif, mirip MIT |
| **GPL v2/v3** | Copyleft, derivative harus GPL |
| **LGPL** | Copyleft lemah, untuk library |
| **AGPL** | Copyleft kuat, untuk network service |
| **Unlicense** | Public domain |

### Memilih Lisensi

**Untuk skrip shell:**

- **MIT** — Paling populer, sederhana, permisif.
- **Apache 2.0** — Jika butuh patent grant.
- **GPL** — Jika ingin memastikan derivative tetap open source.

**Untuk proyek kecil, MIT biasanya pilihan terbaik.**

### Menambahkan Lisensi

Buat file `LICENSE`:

```
MIT License

Copyright (c) 2026 Budi Santoso

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

Tambahkan header lisensi ke setiap file skrip:

```sh
#!/bin/sh
#
# MyApp — CLI tool untuk ...
# Copyright (c) 2026 Budi Santoso
# Licensed under MIT License. Lihat LICENSE.
#
```

### Etika Open Source

1. **Hormati lisensi.** Jangan gunakan kode tanpa attribution.
2. **Berkontribusi balik.** Jika Anda menggunakan proyek, pertimbangkan kontribusi.
3. **Jangan "leech".** Jangan hanya mengambil tanpa memberi.
4. **Bersikap sopan.** Ingat, maintainer adalah sukarelawan.
5. **Dokumentasikan perubahan.** Changelog, commit message.
6. **Jangan fork tanpa alasan.** Coba kontribusi ke upstream dulu.
7. **Hargai waktu maintainer.** Buat PR yang siap, bukan "tolong perbaiki".

---

## 5.5.10 Studi Kasus: Proyek Shell Open Source

### `shellcheck` — Analisis Statis

- **Repo:** [github.com/koalaman/shellcheck](https://github.com/koalaman/shellcheck)
- **Bahasa:** Haskell
- **Lisensi:** GPL v3
- **Fokus:** Analisis statis untuk shell
- **Kontribusi:** Menambah pemeriksaan, memperbaiki bug, dokumentasi.

### `shunit2` — Framework Testing

- **Repo:** [github.com/kward/shunit2](https://github.com/kward/shunit2)
- **Bahasa:** Shell (POSIX)
- **Lisensi:** Apache 2.0
- **Fokus:** Unit testing untuk shell
- **Kontribusi:** Menambah assertion, memperbaiki kompatibilitas.

### `bats` — Bash Automated Testing

- **Repo:** [github.com/bats-core/bats-core](https://github.com/bats-core/bats-core)
- **Bahasa:** Bash
- **Lisensi:** MIT
- **Fokus:** Testing untuk bash
- **Kontribusi:** Fitur baru, dokumentasi.

### `acme.sh` — ACME Client

- **Repo:** [github.com/acmesh-official/acme.sh](https://github.com/acmesh-official/acme.sh)
- **Bahasa:** Shell (POSIX)
- **Lisensi:** GPL v3
- **Fokus:** Let's Encrypt client dalam shell murni
- **Kontribusi:** Dukungan provider DNS baru.

### `rbenv` / `pyenv`

- **Repo:** [github.com/rbenv/rbenv](https://github.com/rbenv/rbenv)
- **Bahasa:** Shell
- **Lisensi:** MIT
- **Fokus:** Version manager
- **Kontribusi:** Plugin, dukungan sistem.

### `nvm` — Node Version Manager

- **Repo:** [github.com/nvm-sh/nvm](https://github.com/nvm-sh/nvm)
- **Bahasa:** Shell (POSIX)
- **Lisensi:** MIT
- **Fokus:** Node.js version manager
- **Kontribusi:** Dukungan shell, fitur baru.

**Pelajaran:** Proyek shell open source sukses memiliki:
- Fokus jelas.
- Dokumentasi baik.
- Test otomatis.
- Komunitas aktif.
- Portabilitas.

---

## 5.5.11 Menulis Skrip untuk Digunakan Orang Lain

### Prinsip Desain

**1. Portabel.** Berjalan di sebanyak mungkin sistem.

**2. Predictable.** Perilaku konsisten, terdokumentasi.

**3. Safe.** Tidak merusak data, tidak rentan.

**4. Composable.** Bekerja dengan alat Unix lain.

**5. Documented.** README, man page, `--help`.

**6. Configurable.** Default yang baik, tetapi dapat dikonfigurasi.

**7. Testable.** Ada test otomatis.

**8. Versioned.** Semantic versioning.

### Contoh: CLI Tool yang Baik

```sh
#!/bin/sh
#
# mytool — Melakukan sesuatu yang berguna.
#
# Penggunaan: mytool [opsi] file...
#
# Opsi:
#   -h, --help      Tampilkan bantuan
#   -v, --verbose   Mode verbose
#   -o, --output    File output
#   -V, --version   Tampilkan versi
#
# Exit Codes:
#   0 - Sukses
#   1 - Error umum
#   2 - Argumen tidak valid
#

set -u

VERSION="1.0.0"
VERBOSE=0
OUTPUT=""

usage() {
    cat <<EOF
Penggunaan: mytool [opsi] file...

Deskripsi panjang tentang mytool.

Opsi:
  -h, --help      Tampilkan bantuan ini
  -v, --verbose   Mode verbose
  -o, --output    File output (default: stdout)
  -V, --version   Tampilkan versi

Contoh:
  mytool file.txt
  mytool -v -o out.txt file1.txt file2.txt
EOF
}

# Parsing argumen
while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=1
            shift
            ;;
        -V|--version)
            echo "$VERSION"
            exit 0
            ;;
        -o|--output)
            if [ -z "${2:-}" ]; then
                echo "Error: --output memerlukan argumen." >&2
                exit 2
            fi
            OUTPUT="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "Error: opsi tidak dikenal: $1" >&2
            usage >&2
            exit 2
            ;;
        *)
            break
            ;;
    esac
done

if [ $# -eq 0 ]; then
    echo "Error: tidak ada file yang diberikan." >&2
    usage >&2
    exit 2
fi

# Proses
for file in "$@"; do
    if [ ! -r "$file" ]; then
        echo "Warning: $file tidak dapat dibaca, dilewati." >&2
        continue
    fi
    
    if [ "$VERBOSE" -eq 1 ]; then
        echo "Memproses: $file" >&2
    fi
    
    if [ -n "$OUTPUT" ]; then
        cat "$file" >> "$OUTPUT"
    else
        cat "$file"
    fi
done

exit 0
```

**Karakteristik:**

- Header lengkap.
- `set -u`.
- Fungsi `usage`.
- Parsing argumen yang jelas.
- Validasi input.
- Output ke stdout, error ke stderr.
- Exit code konsisten.

---

## 5.5.12 Roadmap Setelah Kurikulum

Selamat! Anda telah menyelesaikan kurikulum. Apa selanjutnya?

### Praktik Berkelanjutan

1. **Tulis skrip setiap hari.** Otomatiskan tugas rutin.
2. **Baca skrip orang lain.** GitHub, proyek open source.
3. **Kontribusi ke proyek.** Mulai dari dokumentasi, lalu kode.
4. **Ikut komunitas.** Reddit r/bash, Stack Overflow, IRC.
5. **Tulis blog.** Bagikan pengetahuan.
6. **Ajarkan orang lain.** Mengajar adalah belajar terbaik.

### Topik Lanjutan

- **`awk` mendalam** — Bahasa pemrograman sendiri.
- **`sed` mendalam** — Editor stream yang kuat.
- **`perl`** — Untuk tugas yang terlalu kompleks untuk shell.
- **`python`** — Untuk tugas yang memerlukan struktur data.
- **`make`** — Build system.
- **`autotools`** — `autoconf`, `automake`.
- **`ansible`** — Konfigurasi manajemen.
- **`docker`** — Containerization.
- **`kubernetes`** — Orkestrasi.

### Sertifikasi

- **Linux Professional Institute (LPI)** — LPIC-1, LPIC-2.
- **Red Hat Certified System Administrator (RHCSA)** — Fokus RHEL.
- **CompTIA Linux+** — Vendor-neutral.

### Buku Lanjutan

- *The Linux Command Line* — William Shotts.
- *Classic Shell Scripting* — Arnold Robbins, Nelson Beebe.
- *bash Cookbook* — Carl Albing, JP Vossen.
- *Unix Power Tools* — Shelley Powers, dkk.
- *The Art of Unix Programming* — Eric S. Raymond.
- *Shell Scripting: Expert Recipes* — Steve Parker.

### Komunitas

- **r/bash** — Reddit.
- **r/commandline** — Reddit.
- **Stack Overflow** — Tag `shell`, `bash`, `posix`.
- **Unix & Linux Stack Exchange** — Q&A.
- **Freenode IRC** — `#bash`, `#posix`.
- **Libera.Chat** — `#bash`.

---

## 5.5.13 Latihan

1. **Buat Proyek Open Source:**
   - Pilih ide skrip sederhana yang berguna.
   - Buat repository di GitHub.
   - Tambahkan README, LICENSE, CONTRIBUTING.
   - Publikasikan.

2. **ShellCheck:**
   - Install ShellCheck.
   - Jalankan pada proyek Anda.
   - Perbaiki semua peringatan.

3. **Test:**
   - Tulis test untuk proyek Anda.
   - Gunakan `shunit2` atau framework lain.
   - Tambahkan ke CI.

4. **CI/CD:**
   - Setup GitHub Actions.
   - Test di Linux dan macOS.
   - Test dengan `sh`, `bash`, `dash`.

5. **Dokumentasi:**
   - Tulis README yang komprehensif.
   - Tulis man page.
   - Tambahkan CHANGELOG.

6. **Distribusi:**
   - Buat tarball.
   - Buat formula Homebrew (jika relevan).
   - Buat `install.sh`.

7. **Code Review:**
   - Minta orang lain me-review kode Anda.
   - Lakukan review untuk orang lain.
   - Terapkan feedback.

8. **Kontribusi ke Proyek Lain:**
   - Cari issue `good first issue`.
   - Buat PR.
   - Respons review.

9. **Lisensi:**
   - Pilih lisensi untuk proyek Anda.
   - Tambahkan header lisensi ke setiap file.

10. **Presentasi:**
    - Tulis blog post tentang proyek Anda.
    - Presentasi ke komunitas.
    - Bagikan di media sosial.

11. **Maintenance:**
    - Respons issue dan PR.
    - Rilis versi baru.
    - Update dokumentasi.

12. **Refleksi:**
    - Review seluruh kurikulum.
    - Identifikasi area yang perlu diperdalam.
    - Buat rencana belajar lanjutan.

---

## 5.5.14 Ringkasan Materi 5

- **Ekosistem open source** untuk shell mencakup build script, instalasi, CI/CD, dan utilitas.
- **Standar proyek**: POSIX, ShellCheck, testing, dokumentasi.
- **Panduan gaya**: Google Shell Style Guide, konsistensi.
- **Code review**: fungsionalitas, portabilitas, keamanan, kualitas, gaya.
- **CI/CD**: GitHub Actions, GitLab CI, Travis CI. Test lintas platform.
- **Dokumentasi**: README, CONTRIBUTING, CHANGELOG, man page.
- **Distribusi**: tarball, Homebrew, Debian, Arch, Alpine, `install.sh`.
- **Kontribusi**: fork, branch, commit, PR, review, merge.
- **Lisensi**: MIT, Apache, GPL. Pilih sesuai kebutuhan.
- **Etika**: hormati lisensi, berkontribusi balik, sopan, sabar.
- **Studi kasus**: ShellCheck, shunit2, bats, acme.sh, rbenv, nvm.
- **Roadmap**: praktik berkelanjutan, topik lanjutan, komunitas.

**Prinsip utama:**

> **"Kode yang baik adalah kode yang dibagikan. Pengetahuan yang baik adalah pengetahuan yang diajarkan."**

---
# SELAMAT!
## 🎉 KURIKULUM SELESAI!

Anda telah menyelesaikan **seluruh kurikulum sh/POSIX Standard** dari Level 1 hingga Level 5. Ini adalah pencapaian yang luar biasa.

### Rekap Perjalanan

**Level 1 – Fondasi:**
- Pengenalan shell & POSIX.
- Terminal & lingkungan.
- Skrip pertama & shebang.
- Perintah dasar.

**Level 2 – Blok Bangunan:**
- Variabel & ekspansi parameter.
- Kondisional (`if`, `test`, `case`).
- Loop (`for`, `while`, `until`).
- Fungsi.

**Level 3 – Teknik Lanjutan:**
- Input/Output & redirection.
- Command substitution & pipeline.
- Pattern matching & text processing.
- Aritmatika.

**Level 4 – Profesional:**
- Error handling & defensive programming.
- Portabilitas.
- Debugging.
- Keamanan.
- Praktik terbaik & gaya kode.

**Level 5 – Tingkat Dewa:**
- Optimasi performa.
- Arsitektur skrip kompleks.
- Process substitution & FIFO.
- Signal handling & job control.
- Kontribusi open source.

### Yang Telah Anda Kuasai

Anda sekarang mampu:

✅ Menulis skrip POSIX yang portabel di Linux, macOS, BSD.
✅ Menguasai semua konstruksi bahasa shell: variabel, kondisi, loop, fungsi.
✅ Memproses teks dengan `grep`, `sed`, `awk`.
✅ Mengelola I/O, pipeline, dan process substitution.
✅ Menulis skrip yang aman dari command injection, path injection, symlink attack.
✅ Mendebug skrip dengan `set -x`, `shellcheck`, dan strategi sistematis.
✅ Mengoptimalkan performa hingga 1000x.
✅ Membangun arsitektur modular untuk proyek kompleks.
✅ Mengelola signal, job control, dan daemon.
✅ Berkontribusi ke ekosistem open source.

### Kata Penutup

Shell adalah **bahasa yang hidup**. Ia berevolusi selama 50 tahun dan akan terus ada selama Unix ada. Menguasai shell berarti menguasai **fondasi** dari hampir semua sistem modern: server, cloud, container, embedded.

Ingat:

> **"Orang yang menguasai shell menguasai sistem."**

Tetapi ingat juga:

> **"Dengan kekuatan besar datang tanggung jawab besar."**

Gunakan kemampuan Anda untuk:
- **Membangun**, bukan merusak.
- **Membantu**, bukan menyakiti.
- **Mengajar**, bukan menyombong.
- **Berkontribusi**, bukan hanya mengambil.

### Terima Kasih

Terima kasih telah mengikuti kurikulum ini hingga selesai. Semoga perjalanan Anda di dunia shell POSIX membawa manfaat bagi Anda dan orang lain.

**Selamat berkarya!** 🚀

---

## 📌 Referensi Lengkap

### Spesifikasi Resmi
- **IEEE Std 1003.1-2017** — POSIX.1 Base Specifications.
- **The Open Group Base Specifications** — [pubs.opengroup.org](https://pubs.opengroup.org/onlinepubs/9699919799/)

### Buku
- *The Linux Command Line* — William Shotts.
- *Classic Shell Scripting* — Arnold Robbins, Nelson Beebe.
- *bash Cookbook* — Carl Albing, JP Vossen.
- *Unix Power Tools* — Shelley Powers, dkk.
- *The Art of Unix Programming* — Eric S. Raymond.
- *Shell Scripting: Expert Recipes* — Steve Parker.
- *Learning the bash Shell* — Cameron Newham, Bill Rosenblatt.

### Sumber Online
- **ShellCheck** — [shellcheck.net](https://www.shellcheck.net)
- **Google Shell Style Guide** — [google.github.io/styleguide/shellguide.html](https://google.github.io/styleguide/shellguide.html)
- **Bash Hackers Wiki** — [wiki.bash-hackers.org](https://wiki.bash-hackers.org)
- **Greg's Wiki** — [mywiki.wooledge.org](https://mywiki.wooledge.org)
- **POSIX Shell Tutorial** — [shellscript.sh](https://www.shellscript.sh)
- **Explain Shell** — [explainshell.com](https://explainshell.com)

### Komunitas
- **Unix & Linux Stack Exchange** — [unix.stackexchange.com](https://unix.stackexchange.com)
- **Stack Overflow** — Tag `shell`, `bash`, `posix`.
- **Reddit** — r/bash, r/commandline, r/linux.
- **IRC** — Libera.Chat `#bash`, `#posix`.

---

**Akhir dari Kurikulum sh/POSIX Standard.**  
**Level 1 → Level 5: Selesai.**

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

