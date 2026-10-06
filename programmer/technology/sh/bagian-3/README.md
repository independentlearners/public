# Level 3 – Teknik Lanjutan  
## Materi 1: Input/Output & Redirection (Mendalam)

> **Catatan:** Ini adalah **materi pertama** dari Level 3. Di Level 1 dan 2 kita sudah menggunakan redirection sederhana seperti `>` dan `<`. Sekarang kita akan membedahnya **sampai ke level file descriptor**, memahami bagaimana kernel mengelola I/O, dan menguasai teknik-teknik canggih seperti here document, here string, dan penggandaan file descriptor. Setelah materi ini, Anda akan mampu mengarahkan aliran data dengan presisi bedah.

---

## 🎯 Tujuan Materi 1

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Menjelaskan konsep **file descriptor** dan tiga descriptor standar (0, 1, 2).
2. Menguasai semua operator redirection POSIX: `>`, `>>`, `<`, `2>`, `&>`, `>&`, `<<`, `<<-`, `<>`.
3. Memahami urutan evaluasi redirection dan jebakannya.
4. Menggunakan **here document** dengan benar, termasuk ekspansi dan quoting.
5. Menggunakan **here string** (meskipun tidak POSIX) dan alternatifnya.
6. Menggandakan file descriptor dengan `n>&m` dan `n<&m`.
7. Menutup file descriptor dengan `n>&-`.
8. Membaca input pengguna dengan `read` dan memisahkan field.
9. Menulis skrip yang mengarahkan stdout dan stderr secara terpisah.
10. Menghindari jebakan klasik seperti `> file 2>&1` vs `2>&1 > file`.

---

## 3.1.1 Filosofi I/O di Unix

Unix didasarkan pada filosofi **"everything is a file"**. Setiap proses memiliki **file descriptor** — angka yang merepresentasikan koneksi ke file, pipe, socket, atau device.

Ketika sebuah proses dimulai, kernel secara otomatis membuka tiga file descriptor:

| FD | Nama | Default | Simbol |
|----|------|---------|--------|
| 0 | Standard Input | Keyboard | `stdin` |
| 1 | Standard Output | Terminal | `stdout` |
| 2 | Standard Error | Terminal | `stderr` |

**File descriptor** adalah integer kecil (biasanya 0–1023) yang menjadi indeks ke tabel file yang dibuka oleh proses. Ketika Anda menulis `echo "halo"`, shell menulis ke FD 1. Ketika `grep` menemukan error, ia menulis ke FD 2.

### Mengapa stdout dan stderr Dipisahkan?

Ini adalah keputusan desain yang brilian:

- **stdout** – Output normal program. Bisa dialihkan ke file atau pipe.
- **stderr** – Pesan error dan diagnostik. Tetap ke terminal agar pengguna melihatnya.

Contoh:

```sh
grep "pola" file.txt > hasil.txt
```

Penjelasan:

- Output yang cocok ditulis ke `hasil.txt`.
- Pesan error (misalnya file tidak ada) tetap muncul di terminal.
- Ini memungkinkan Anda memproses output tanpa kehilangan pesan error.

### Melihat File Descriptor Terbuka

```sh
ls -l /proc/$$/fd
```

Penjelasan:

- `/proc/$$/fd` – Direktori virtual (Linux) yang menampilkan FD terbuka dari proses dengan PID `$$`.
- `ls -l` – Menampilkan symlink ke target setiap FD.
- Contoh output:
  ```
  lrwx------ 1 budi users 64 Jan  1 12:00 0 -> /dev/pts/0
  lrwx------ 1 budi users 64 Jan  1 12:00 1 -> /dev/pts/0
  lrwx------ 1 budi users 64 Jan  1 12:00 2 -> /dev/pts/0
  ```
- `0`, `1`, `2` adalah stdin, stdout, stderr. Semuanya menunjuk ke terminal `/dev/pts/0`.

`/proc` adalah fitur Linux. Di BSD/macOS, gunakan `lsof -p $$`.

---

## 3.1.2 Operator Redirection Dasar

### `>` — Redirect stdout (Truncate)

```sh
echo "Halo" > file.txt
```

Penjelasan kata demi kata:

- `echo "Halo"` – Perintah yang mencetak "Halo" ke stdout.
- `>` – Operator redirection. Mengarahkan stdout ke file.
- `file.txt` – Target. Jika file tidak ada, dibuat. Jika ada, **isinya ditimpa** (truncate ke nol).
- Shell membuka `file.txt` dengan flag `O_WRONLY | O_CREAT | O_TRUNC`, lalu mengganti FD 1 proses dengan FD file tersebut.

**Jebakan:** `>` menimpa tanpa peringatan. Untuk mencegah, gunakan `set -C` (noclobber):

```sh
set -C
echo "Halo" > file.txt    # Error jika file sudah ada
echo "Halo" >| file.txt   # Paksa timpa (override noclobber)
```

Penjelasan:

- `set -C` – **Noclobber**. Mencegah `>` menimpa file yang ada.
- `>|` – Operator **force clobber**. Menimpa meskipun noclobber aktif.

### `>>` — Redirect stdout (Append)

```sh
echo "Baris baru" >> file.txt
```

Penjelasan:

- `>>` – Append. Menambahkan ke akhir file.
- Jika file tidak ada, dibuat.
- Shell membuka dengan flag `O_WRONLY | O_CREAT | O_APPEND`.

### `<` — Redirect stdin

```sh
wc -l < file.txt
```

Penjelasan:

- `<` – Mengarahkan stdin dari file.
- Shell membuka `file.txt` untuk dibaca, mengganti FD 0 proses dengan FD file.
- `wc -l` membaca dari stdin, bukan dari keyboard.
- Output: jumlah baris.

**Perbedaan dengan argumen:**

```sh
wc -l file.txt       # wc menerima nama file sebagai argumen
wc -l < file.txt     # wc membaca dari stdin
```

- Versi pertama: `wc` membuka file sendiri, dan output menyertakan nama file.
- Versi kedua: shell yang membuka file, `wc` tidak tahu nama file, output hanya angka.

### `2>` — Redirect stderr

```sh
ls /tidak/ada 2> error.txt
```

Penjelasan:

- `2>` – Mengarahkan FD 2 (stderr) ke file.
- `2` adalah nomor file descriptor. Tidak ada spasi antara `2` dan `>`.
- **Spasi antara `2` dan `>`** akan membuat shell menganggap `2` sebagai argumen, bukan FD. Jangan tulis `2 >`.

### `2>>` — Append stderr

```sh
ls /tidak/ada 2>> error.txt
```

Penjelasan:

- `2>>` – Append stderr ke file.

### `&>` — Redirect stdout dan stderr (Bukan POSIX)

```sh
perintah &> output.txt
```

Penjelasan:

- `&>` – Mengarahkan stdout **dan** stderr ke file yang sama.
- **`&>` tidak POSIX.** Ini ekstensi bash. Untuk POSIX, gunakan `> file 2>&1`.

### `>&` — Duplikasi File Descriptor

```sh
perintah > output.txt 2>&1
```

Penjelasan kata demi kata:

- `> output.txt` – Arahkan stdout (FD 1) ke `output.txt`.
- `2>&1` – Arahkan FD 2 (stderr) ke **salinan** FD 1. Artinya, stderr sekarang menunjuk ke target yang sama dengan stdout, yaitu `output.txt`.
- `&1` – Tanda `&` diikuti angka berarti "file descriptor", bukan file bernama `1`.
- **Urutan penting.** `> file 2>&1` berbeda dari `2>&1 > file`.

### `<>` — Buka untuk Baca dan Tulis

```sh
perintah <> file.txt
```

Penjelasan:

- `<>` – Membuka file untuk **baca dan tulis**.
- Jarang digunakan, tetapi berguna untuk file yang perlu dibaca dan ditulis bersamaan.
- Contoh: mengedit file di tempat dengan `read` dan `write`.

### Tabel Ringkasan Operator

| Operator | Arti | POSIX |
|----------|------|-------|
| `> file` | stdout ke file (truncate) | ✅ |
| `>> file` | stdout ke file (append) | ✅ |
| `< file` | stdin dari file | ✅ |
| `2> file` | stderr ke file | ✅ |
| `2>> file` | stderr append | ✅ |
| `&> file` | stdout + stderr ke file | ❌ |
| `> file 2>&1` | stdout + stderr ke file | ✅ |
| `<> file` | buka baca-tulis | ✅ |
| `>| file` | force clobber | ✅ |

---

## 3.1.3 Urutan Evaluasi Redirection

Ini adalah topik yang **sangat sering disalahpahami**. Urutan redirection **dari kiri ke kanan**.

### Contoh 1: `> file 2>&1` (Benar)

```sh
perintah > output.txt 2>&1
```

Langkah:

1. `> output.txt` – Buka `output.txt` untuk tulis. FD 1 sekarang menunjuk ke file.
2. `2>&1` – Gandakan FD 1 (yang sudah menunjuk ke file) ke FD 2. FD 2 sekarang menunjuk ke file yang sama.

Hasil: stdout dan stderr ke `output.txt`.

### Contoh 2: `2>&1 > file` (Salah)

```sh
perintah 2>&1 > output.txt
```

Langkah:

1. `2>&1` – Gandakan FD 1 (yang masih menunjuk ke terminal) ke FD 2. FD 2 sekarang menunjuk ke terminal.
2. `> output.txt` – Buka file untuk tulis. FD 1 sekarang menunjuk ke file.

Hasil: stdout ke `output.txt`, tetapi stderr tetap ke terminal.

**Ini bukan yang biasanya diinginkan.** Urutan sangat penting.

### Contoh 3: `> file1 2> file2`

```sh
perintah > stdout.txt 2> stderr.txt
```

Langkah:

1. `> stdout.txt` – FD 1 ke `stdout.txt`.
2. `2> stderr.txt` – FD 2 ke `stderr.txt`.

Hasil: stdout dan stderr dipisahkan.

### Contoh 4: `2>&1 > file1 > file2`

```sh
perintah 2>&1 > file1 > file2
```

Langkah:

1. `2>&1` – FD 2 = terminal.
2. `> file1` – FD 1 = `file1`.
3. `> file2` – FD 1 = `file2` (menimpa redirection sebelumnya).

Hasil: stdout ke `file2`, stderr ke terminal. Redirection `> file1` tidak berguna karena ditimpa.

### Aturan Emas

> **Redirection dievaluasi dari kiri ke kanan. Setiap redirection menggantikan yang sebelumnya untuk FD yang sama.**

---

## 3.1.4 Menggandakan dan Menutup File Descriptor

### `n>&m` — Gandakan FD m ke FD n

```sh
perintah 3>&1
```

Penjelasan:

- `3>&1` – Buat FD 3 sebagai salinan FD 1.
- FD 3 sekarang menunjuk ke tempat yang sama dengan FD 1.
- Berguna untuk menyimpan referensi ke stdout sebelum diubah.

### `n<&m` — Gandakan FD m ke FD n (Input)

```sh
perintah 3<&0
```

Penjelasan:

- `3<&0` – FD 3 sebagai salinan FD 0 (stdin).

### `n>&-` — Tutup FD n

```sh
perintah 3>&-
```

Penjelasan:

- `3>&-` – Tutup FD 3.
- Berguna untuk mencegah proses anak mewarisi FD yang tidak perlu.

### `n<&-` — Tutup FD n (Input)

```sh
perintah 3<&-
```

Penjelasan:

- Menutup FD 3 untuk input.

### Contoh Praktis: Menukar stdout dan stderr

```sh
perintah 3>&1 1>&2 2>&3 3>&-
```

Penjelasan kata demi kata:

1. `3>&1` – Simpan stdout asli ke FD 3.
2. `1>&2` – Arahkan stdout ke stderr.
3. `2>&3` – Arahkan stderr ke stdout asli (FD 3).
4. `3>&-` – Tutup FD 3.

Hasil: stdout dan stderr **ditukar**. Output normal pergi ke stderr, error pergi ke stdout.

Ini adalah pola klasik yang harus Anda hafal.

### Contoh: Mengirim Output ke Beberapa Tujuan

```sh
perintah > output.txt 3>&1 1>&2 2>&3 | tee log.txt
```

Penjelasan:

- Ini rumit. Mari sederhanakan dengan `tee`:
  ```sh
  perintah 2>&1 | tee output.txt
  ```
- `tee` membaca dari stdin, menulis ke stdout **dan** ke file.
- `2>&1` menggabungkan stderr ke stdout, lalu pipe ke `tee`.
- Hasil: output terlihat di terminal **dan** tersimpan di file.

---

## 3.1.5 Here Document (`<<`)

**Here document** adalah cara untuk memberikan input multi-baris ke sebuah perintah langsung di dalam skrip.

### Sintaks Dasar

```sh
perintah <<DELIMITER
baris 1
baris 2
baris 3
DELIMITER
```

Penjelasan:

- `<<DELIMITER` – Operator here document. `DELIMITER` adalah penanda akhir.
- `baris 1`, `baris 2`, `baris 3` – Isi here document.
- `DELIMITER` – Penanda akhir. Harus berada di awal baris, tanpa spasi di depan.

### Contoh 1: `cat` dengan Here Document

```sh
cat <<EOF
Halo, dunia!
Ini adalah beberapa baris.
EOF
```

Output:

```
Halo, dunia!
Ini adalah beberapa baris.
```

Penjelasan:

- `<<EOF` – Here document dengan delimiter `EOF`.
- Semua baris hingga `EOF` menjadi stdin untuk `cat`.
- `EOF` di akhir menandai akhir input.

### Contoh 2: Ekspansi Variabel

```sh
nama="Budi"
cat <<EOF
Halo, $nama!
Hari ini $(date +%A).
EOF
```

Output:

```
Halo, Budi!
Hari ini Senin.
```

Penjelasan:

- Here document **melakukan ekspansi parameter** (`$nama`), **command substitution** (`$(date)`), dan **arithmetic expansion** (`$(( ))`).
- Ini disebut **unquoted here document**.

### Contoh 3: Tanpa Ekspansi (Quoted Delimiter)

```sh
nama="Budi"
cat <<'EOF'
Halo, $nama!
Hari ini $(date +%A).
EOF
```

Output:

```
Halo, $nama!
Hari ini $(date +%A).
```

Penjelasan:

- `<<'EOF'` – Delimiter dikutip dengan tanda kutip tunggal.
- Ini mencegah **semua** ekspansi: parameter, command substitution, arithmetic.
- Berguna untuk menulis skrip atau kode yang mengandung `$` atau backtick.

### Contoh 4: Delimiter dengan Backslash

```sh
cat <<\EOF
Halo, $nama!
EOF
```

Penjelasan:

- `<<\EOF` – Backslash sebelum delimiter juga mencegah ekspansi.
- Sama efeknya dengan `<<'EOF'` atau `<<"EOF"`.

### Contoh 5: Here Document ke Perintah Lain

```sh
grep "error" <<EOF
baris 1
baris 2 error
baris 3
EOF
```

Output:

```
baris 2 error
```

Penjelasan:

- Here document menjadi stdin untuk `grep`.

### Contoh 6: Here Document ke `read`

```sh
read -r nama <<EOF
Budi Santoso
EOF
echo "Nama: $nama"
```

Output:

```
Nama: Budi Santoso
```

Penjelasan:

- `read` membaca satu baris dari here document.

### Contoh 7: Beberapa Here Document

```sh
cat <<EOF1
Bagian 1
EOF1
cat <<EOF2
Bagian 2
EOF2
```

Penjelasan:

- Setiap here document memiliki delimiter sendiri.
- Delimiter harus unik dalam satu perintah.

### `<<-` — Here Document dengan Tab Stripping

```sh
if true; then
    cat <<-EOF
	Baris dengan tab di depan
	Baris lain
	EOF
fi
```

Penjelasan:

- `<<-EOF` – Tanda minus setelah `<<`.
- Menghapus **tab** (bukan spasi) di awal setiap baris, termasuk delimiter.
- Berguna untuk indentasi di dalam blok `if`, `for`, dll.
- **Spasi tidak dihapus**, hanya tab.

### Jebakan Here Document

1. **Delimiter harus di awal baris** (kecuali `<<-` yang mengizinkan tab).
   ```sh
   cat <<EOF
   teks
    EOF     # ❌ ada spasi di depan
   ```
   Error: delimiter tidak ditemukan.

2. **Delimiter case-sensitive**:
   ```sh
   cat <<EOF
   teks
   eof     # ❌ beda case
   ```
   Error.

3. **Ekspansi terjadi** kecuali delimiter dikutip:
   ```sh
   cat <<EOF
   $variabel    # Diekspansi
   EOF

   cat <<'EOF'
   $variabel    # Tidak diekspansi
   EOF
   ```

4. **Here document di dalam pipeline**:
   ```sh
   cat <<EOF | grep "error"
   baris 1
   baris 2 error
   EOF
   ```
   Ini valid. Here document menjadi stdin `cat`, output `cat` di-pipe ke `grep`.

---

## 3.1.6 Here String (`<<<`) — Tidak POSIX

Bash dan beberapa shell modern mendukung **here string**:

```sh
grep "error" <<< "baris 1 error"
```

Penjelasan:

- `<<< "string"` – Mengirim string sebagai stdin.
- **Tidak POSIX.** Untuk portabilitas, gunakan `echo` atau here document:
  ```sh
  echo "baris 1 error" | grep "error"
  ```
  atau
  ```sh
  grep "error" <<EOF
  baris 1 error
  EOF
  ```

---

## 3.1.7 Membaca Input dengan `read`

Perintah `read` adalah cara utama untuk membaca input baris per baris.

### Sintaks Dasar

```sh
read [-r] [-p prompt] variabel...
```

Penjelasan:

- `read` – Membaca satu baris dari stdin.
- `-r` – **Raw mode**. Mencegah backslash diinterpretasikan sebagai escape.
- `-p prompt` – **Tidak POSIX**. Menampilkan prompt (bash).
- `variabel...` – Satu atau lebih nama variabel.

### Contoh 1: Satu Variabel

```sh
printf "Nama: "
read -r nama
echo "Halo, $nama"
```

Penjelasan:

- `printf "Nama: "` – Mencetak prompt tanpa newline.
- `read -r nama` – Membaca satu baris, menyimpan di `nama`.
- Input pengguna tidak menyertakan newline.

### Contoh 2: Beberapa Variabel

```sh
echo "Budi Santoso Jakarta" | {
    read -r nama kota
    echo "Nama: $nama"
    echo "Kota: $kota"
}
```

Output:

```
Nama: Budi
Kota: Santoso Jakarta
```

Penjelasan:

- `read -r nama kota` – Membaca dua field.
- Field pertama (`Budi`) ke `nama`.
- Sisa baris (`Santoso Jakarta`) ke `kota`.
- **Variabel terakhir menerima sisa baris**, termasuk spasi.

### Contoh 3: `IFS` untuk Memisahkan Field

```sh
echo "Budi:Santoso:Jakarta" | {
    IFS=: read -r nama tengah kota
    echo "Nama: $nama"
    echo "Tengah: $tengah"
    echo "Kota: $kota"
}
```

Output:

```
Nama: Budi
Tengah: Santoso
Kota: Jakarta
```

Penjelasan:

- `IFS=:` – Set IFS ke `:` **hanya untuk perintah `read`**.
- `read` memisahkan input berdasarkan `:`.
- Setiap variabel menerima satu field.
- Jika ada lebih banyak field dari variabel, variabel terakhir menerima sisanya.

### Contoh 4: `read` dengan `-r`

```sh
echo 'path\with\backslash' | {
    read -r line
    echo "$line"
}
```

Output:

```
path\with\backslash
```

Tanpa `-r`:

```sh
echo 'path\with\backslash' | {
    read line
    echo "$line"
}
```

Output:

```
pathwithbackslash
```

Penjelasan:

- Tanpa `-r`, backslash menghilang.
- **Selalu gunakan `-r`** kecuali Anda benar-benar memerlukan interpretasi escape.

### Contoh 5: `read` dengan Timeout (Bukan POSIX)

```sh
if read -t 5 -r jawaban; then
    echo "Anda menjawab: $jawaban"
else
    echo "Waktu habis."
fi
```

Penjelasan:

- `-t 5` – **Tidak POSIX**. Timeout 5 detik.
- Untuk portabilitas, tidak ada cara langsung. Gunakan `stty` atau perintah lain.

### Contoh 6: `read` dari File

```sh
while IFS= read -r line; do
    echo "Baris: $line"
done < file.txt
```

Sudah dibahas di Level 2. Ini adalah pola membaca file yang paling aman.

### Return Status `read`

- `0` – Berhasil membaca baris.
- Non-zero – EOF atau error.

```sh
while read -r line; do
    # ...
done < file.txt
```

Loop berhenti ketika `read` mengembalikan non-zero (EOF).

### `read` dan Baris Terakhir Tanpa Newline

```sh
while IFS= read -r line || [ -n "$line" ]; do
    echo "$line"
done < file.txt
```

Penjelasan:

- `|| [ -n "$line" ]` – Jika `read` gagal (EOF) tetapi `$line` tidak kosong, tetap proses.
- Ini menangani file yang tidak diakhiri newline.

---

## 3.1.8 Redirect ke `/dev/null`

`/dev/null` adalah **file device** yang membuang semua yang ditulis ke sana. Membaca dari `/dev/null` menghasilkan EOF.

### Membuang Output

```sh
perintah > /dev/null
```

Penjelasan:

- stdout dibuang.
- stderr tetap ke terminal.

```sh
perintah > /dev/null 2>&1
```

Penjelasan:

- stdout dan stderr dibuang.

Atau dengan urutan yang lebih ringkas:

```sh
perintah 2>&1 > /dev/null    # ❌ Salah
```

Ingat urutan! Yang benar:

```sh
perintah > /dev/null 2>&1
```

### Mengecek Keberadaan Perintah

```sh
if command -v grep > /dev/null 2>&1; then
    echo "grep tersedia"
fi
```

Penjelasan:

- `command -v grep` – Mencetak path `grep` jika ada.
- `> /dev/null 2>&1` – Buang output dan error.
- Hanya exit status yang penting.

### Membaca dari `/dev/null`

```sh
read -r line < /dev/null
echo "Status: $?"
```

Output:

```
Status: 1
```

Penjelasan:

- `/dev/null` langsung EOF.
- `read` mengembalikan `1`.

---

## 3.1.9 Redirection dalam Pipeline

Pipeline (`|`) menghubungkan stdout satu perintah ke stdin perintah berikutnya.

```sh
perintah1 | perintah2 | perintah3
```

Penjelasan:

- stdout `perintah1` menjadi stdin `perintah2`.
- stdout `perintah2` menjadi stdin `perintah3`.
- stderr **tidak** melalui pipe.

### Menggabungkan stderr ke Pipeline

```sh
perintah1 2>&1 | perintah2
```

Penjelasan:

- `2>&1` menggabungkan stderr ke stdout sebelum pipe.
- stderr sekarang melalui pipe.

### Jebakan: Subshell

Setiap sisi pipeline berjalan di **subshell** (di sebagian besar shell). Variabel yang di-set di sisi kiri atau kanan tidak bertahan di shell induk.

```sh
count=0
echo "a" | while read -r line; do
    count=$((count + 1))
done
echo "$count"    # 0, bukan 1
```

Solusi: redirection `<` alih-alih pipe, atau gunakan command substitution.

### Redirection di Tengah Pipeline

```sh
perintah1 | perintah2 > output.txt
```

Penjelasan:

- `> output.txt` hanya berlaku untuk `perintah2`.
- stdout `perintah1` masuk ke `perintah2`, stdout `perintah2` ke file.

---

## 3.1.10 Contoh Skrip Lengkap

### Skrip 1: Logging dengan Timestamp

```sh
#!/bin/sh
# Nama: logger.sh
# Tujuan: Mencatat pesan dengan timestamp

LOG_FILE="/tmp/app.log"

log() {
    level="$1"
    shift
    pesan="$*"
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    printf '[%s] [%s] %s\n' "$timestamp" "$level" "$pesan"
}

# Log ke file dan terminal
{
    log "INFO" "Program dimulai"
    log "WARN" "Ini peringatan"
    log "ERROR" "Ini error"
} 2>&1 | tee -a "$LOG_FILE"
```

Bedah:

- `log` mencetak ke stdout.
- `{ ... } 2>&1 | tee -a "$LOG_FILE"` – 
  - `{ ... }` – Command group.
  - `2>&1` – Gabungkan stderr ke stdout.
  - `| tee -a "$LOG_FILE"` – Alirkan ke `tee`, yang menulis ke stdout **dan** append ke file.
- `tee -a` – Append, bukan timpa.

### Skrip 2: Konfigurasi dengan Here Document

```sh
#!/bin/sh
# Nama: buat_config.sh
# Tujuan: Membuat file konfigurasi dari template

NAMA_APP="${1:?Penggunaan: $0 nama_app}"
PORT="${2:-8080}"
DB_HOST="${DB_HOST:-localhost}"

cat > "config_${NAMA_APP}.ini" <<EOF
# Konfigurasi untuk $NAMA_APP
# Dibuat: $(date '+%Y-%m-%d %H:%M:%S')

[server]
port = $PORT
host = 0.0.0.0

[database]
host = $DB_HOST
name = ${NAMA_APP}_db
EOF

echo "Konfigurasi dibuat: config_${NAMA_APP}.ini"
```

Bedah:

- `cat > "config_${NAMA_APP}.ini" <<EOF` – 
  - `cat` – Perintah.
  - `> "config_${NAMA_APP}.ini"` – stdout `cat` diarahkan ke file.
  - `<<EOF` – Here document sebagai stdin `cat`.
- Here document berisi variabel yang diekspansi.
- Hasil: file konfigurasi dengan nilai aktual.

### Skrip 3: Backup dengan Logging Terpisah

```sh
#!/bin/sh
# Nama: backup_log.sh
# Tujuan: Backup dengan stdout dan stderr terpisah

SUMBER="${1:?Penggunaan: $0 direktori}"
TUJUAN="${2:-backup}"
LOG_DIR="/var/log/backup"

mkdir -p "$LOG_DIR"

timestamp=$(date '+%Y%m%d_%H%M%S')
LOG_OUT="${LOG_DIR}/backup_${timestamp}.log"
LOG_ERR="${LOG_DIR}/backup_${timestamp}.err"

if [ ! -d "$SUMBER" ]; then
    echo "Error: $SUMBER bukan direktori." >&2
    exit 1
fi

{
    echo "Backup dimulai: $(date)"
    cp -R "$SUMBER" "$TUJUAN"
    echo "Backup selesai: $(date)"
} > "$LOG_OUT" 2> "$LOG_ERR"

status=$?

if [ "$status" -eq 0 ]; then
    echo "Backup sukses. Log: $LOG_OUT"
else
    echo "Backup gagal. Error: $LOG_ERR" >&2
    exit "$status"
fi
```

Bedah:

- `> "$LOG_OUT" 2> "$LOG_ERR"` – stdout ke file log, stderr ke file error.
- `status=$?` – Simpan exit status.
- `exit "$status"` – Keluar dengan status yang sama.

### Skrip 4: Menu dengan Here Document

```sh
#!/bin/sh
# Nama: menu_help.sh
# Tujuan: Menampilkan bantuan dengan here document

tampilkan_bantuan() {
    cat <<'EOF'
Penggunaan: menu_help.sh [opsi]

Opsi:
  -h, --help      Tampilkan bantuan ini
  -v, --version   Tampilkan versi
  -f FILE         Proses file

Contoh:
  menu_help.sh -f data.txt
EOF
}

case "${1:-}" in
    -h|--help)
        tampilkan_bantuan
        ;;
    -v|--version)
        echo "Versi 1.0.0"
        ;;
    *)
        echo "Gunakan -h untuk bantuan." >&2
        exit 1
        ;;
esac
```

Bedah:

- `<<'EOF'` – Quoted delimiter, tidak ada ekspansi.
- Berguna untuk teks yang mengandung `$` atau backtick.

### Skrip 5: Membaca Konfigurasi

```sh
#!/bin/sh
# Nama: baca_config.sh
# Tujuan: Membaca file konfigurasi key=value

CONFIG_FILE="${1:?Penggunaan: $0 file_config}"

if [ ! -r "$CONFIG_FILE" ]; then
    echo "Error: $CONFIG_FILE tidak dapat dibaca." >&2
    exit 1
fi

while IFS='=' read -r key value; do
    # Skip komentar dan baris kosong
    case "$key" in
        ''|\#*) continue ;;
    esac

    # Hapus spasi di ujung
    key=$(printf '%s' "$key" | tr -d ' ')
    value=$(printf '%s' "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    echo "Key: $key = Value: $value"
done < "$CONFIG_FILE"
```

Bedah:

- `IFS='=' read -r key value` – Pisahkan berdasarkan `=`.
- `case "$key" in ''|\#*) continue ;; esac` – Skip baris kosong dan komentar (diawali `#`).
- `tr -d ' '` – Hapus spasi dari key.
- `sed` – Hapus spasi di ujung value.

---

## 3.1.11 Latihan

1. **Redirect Dasar:**
   - Jalankan `ls /etc /tidak/ada > out.txt 2> err.txt`.
   - Periksa isi `out.txt` dan `err.txt`.
   - Jalankan lagi dengan `> out.txt 2>&1`. Apa bedanya?

2. **Urutan Redirection:**
   - Jalankan `ls /etc /tidak/ada 2>&1 > out.txt`.
   - Ke mana stderr pergi? Ke mana stdout pergi?
   - Bandingkan dengan `> out.txt 2>&1`.

3. **Here Document:**
   - Buat skrip yang menggunakan here document untuk mencetak pesan multi-baris.
   - Gunakan `<<EOF` (dengan ekspansi) dan `<<'EOF'` (tanpa ekspansi).
   - Bandingkan outputnya.

4. **Here Document ke Perintah:**
   - Gunakan here document untuk memberikan input ke `grep`.
   - Cari kata "error" dalam beberapa baris.

5. **`read` dengan IFS:**
   - Buat file `data.csv` dengan format `nama,umur,kota`.
   - Baca setiap baris dengan `IFS=, read -r nama umur kota`.
   - Cetak setiap field.

6. **Menukar stdout dan stderr:**
   - Tulis perintah yang menukar stdout dan stderr.
   - Uji dengan perintah yang menghasilkan keduanya.

7. **Logging:**
   - Tulis skrip yang mencatat output ke file log **dan** menampilkan di terminal.
   - Gunakan `tee`.

8. **Membuang Output:**
   - Tulis skrip yang memeriksa apakah `git` tersedia.
   - Buang semua output dan error.
   - Cetak pesan sesuai.

9. **File Descriptor:**
   - Buka FD 3 ke file, tulis sesuatu, lalu tutup.
   - Gunakan `exec 3> file.txt`, `echo "halo" >&3`, `exec 3>&-`.

10. **Konfigurasi:**
    - Buat file `app.conf` dengan format `KEY=value`.
    - Baca dan cetak setiap pasangan.
    - Skip baris komentar.

---

## 3.1.12 Ringkasan Materi 1

- Setiap proses memiliki tiga file descriptor standar: 0 (stdin), 1 (stdout), 2 (stderr).
- Operator redirection POSIX: `>`, `>>`, `<`, `2>`, `2>>`, `<>`, `n>&m`, `n<&m`, `n>&-`.
- **Urutan redirection penting.** `> file 2>&1` berbeda dari `2>&1 > file`.
- `&>` bukan POSIX; gunakan `> file 2>&1`.
- **Here document** (`<<`) memberikan input multi-baris. Gunakan delimiter yang dikutip (`<<'EOF'`) untuk mencegah ekspansi.
- `<<-` menghapus tab di awal baris.
- **Here string** (`<<<`) tidak POSIX; gunakan `echo |` atau here document.
- `read -r` adalah cara aman membaca input. Gunakan `IFS=` untuk mempertahankan spasi.
- `/dev/null` membuang output.
- Pipeline menghubungkan stdout ke stdin; stderr tidak melalui pipe kecuali digabungkan.
- Setiap sisi pipeline berjalan di subshell.

---

## 📌 Selanjutnya

Materi 1 Level 3 selesai. Anda sekarang menguasai I/O dan redirection secara mendalam.

Berikutnya adalah **Materi 2: Command Substitution & Pipeline** — kita akan membahas:

- `$(...)` vs backtick — mengapa `$(...)` lebih baik.
- Filosofi Unix: program kecil yang saling terhubung.
- `xargs` untuk batch processing.
- Process substitution (`<( )`) — meskipun tidak POSIX, penting untuk diketahui.
- Named pipe (`mkfifo`).
- Performa pipeline dan kapan menghindari subshell.
- Membangun pipeline kompleks untuk pemrosesan data.

## Materi 2: Command Substitution & Pipeline

> **Catatan:** Ini adalah **materi kedua** dari Level 3. Command substitution dan pipeline adalah dua pilar filosofi Unix. Tanpa keduanya, shell hanyalah kumpulan perintah terpisah. Dengan keduanya, Anda bisa merangkai program-program kecil menjadi solusi kompleks. Kita akan bedah sampai ke level proses, subshell, dan file descriptor.

---

## 🎯 Tujuan Materi 2

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Menguasai **command substitution** dengan `$( )` dan backtick, serta memahami mengapa `$( )` lebih unggul.
2. Memahami **filosofi Unix**: "lakukan satu hal dengan baik, dan sambungkan".
3. Membangun **pipeline** kompleks dan memahami cara kerja di level proses.
4. Menguasai **`xargs`** untuk batch processing yang efisien.
5. Memahami **process substitution** `<( )` dan `>( )` — meskipun tidak POSIX, sangat berguna.
6. Menggunakan **named pipe** (`mkfifo`) untuk komunikasi antar proses.
7. Menghindari **jebakan subshell** yang menyebabkan variabel "hilang".
8. Mengoptimalkan performa pipeline: kapan menggunakan `xargs`, kapan loop, kapan pipeline.
9. Menulis pipeline yang aman terhadap nama file dengan spasi dan karakter khusus.

---

## 3.2.1 Command Substitution — Dasar

**Command substitution** menggantikan sebuah perintah dengan **output** perintah tersebut. Output ditangkap, newline di akhir dihapus, dan hasilnya menjadi bagian dari perintah yang lebih besar.

### Dua Sintaks

**Sintaks 1: `$(...)` — Modern, POSIX**

```sh
tanggal=$(date +%Y-%m-%d)
echo "$tanggal"
```

**Sintaks 2: Backtick `` `...` `` — Kuno, POSIX**

```sh
tanggal=`date +%Y-%m-%d`
echo "$tanggal"
```

Keduanya menghasilkan output yang sama. Tetapi `$(...)` **jauh lebih unggul**.

### Mengapa `$(...)` Lebih Baik?

**Alasan 1: Nesting**

```sh
# Dengan $(...)
echo "Hari ini $(date +%A), minggu ke-$(date +%V)"

# Dengan backtick — harus escape
echo "Hari ini `date +%A`, minggu ke-`date +%V`"
```

Backtick **tidak bisa di-nest** tanpa escape yang membingungkan:

```sh
# Backtick dengan nesting — mimpi buruk
echo "`echo \`echo halo\``"
```

Bandingkan dengan `$(...)`:

```sh
echo "$(echo "$(echo halo)")"
```

Jelas, `$(...)` lebih bersih.

**Alasan 2: Keterbacaan**

Backtick (`` ` ``) mudah tertukar dengan kutip tunggal (`'`). Di font tertentu, mereka terlihat hampir sama.

**Alasan 3: Escaping**

Dalam backtick, backslash memiliki arti khusus. Dalam `$(...)`, backslash diperlakukan normal.

```sh
# Backtick — backslash di dalam string
echo "`echo "a\\b"`"     # Perilaku tidak konsisten antar shell

# $(...) — jelas
echo "$(echo "a\\b")"
```

**Aturan:** Selalu gunakan `$(...)`. Backtick hanya untuk kompatibilitas dengan skrip kuno.

### Mekanisme Command Substitution

Apa yang terjadi ketika shell mengeksekusi:

```sh
hasil=$(ls /tmp)
```

Langkah demi langkah:

1. **Parsing** — Shell mem-parsing `hasil=$(ls /tmp)`.
2. **Fork** — Shell memanggil `fork()` untuk membuat proses anak.
3. **Pipe** — Shell membuat **pipe** (saluran komunikasi antar-proses).
4. **Exec** — Proses anak menjalankan `ls /tmp` dengan stdout diarahkan ke ujung tulis pipe.
5. **Read** — Shell induk membaca dari ujung baca pipe hingga EOF.
6. **Wait** — Shell induk menunggu proses anak selesai.
7. **Substitute** — Shell mengganti `$(ls /tmp)` dengan output yang ditangkap.
8. **Assignment** — Hasil disimpan di variabel `hasil`.

**Poin penting:** Command substitution berjalan di **subshell**. Setiap perubahan variabel di dalamnya **tidak** mempengaruhi shell induk.

```sh
x=1
y=$(x=99; echo "$x")
echo "x=$x, y=$y"    # x=1, y=99
```

Penjelasan:

- `$(x=99; echo "$x")` berjalan di subshell.
- `x=99` hanya mengubah `x` di subshell.
- Di shell induk, `x` tetap `1`.
- Output subshell (`99`) ditangkap ke `y`.

### Menghapus Newline di Akhir

Command substitution **menghapus semua newline di akhir** output:

```sh
hasil=$(printf "baris1\nbaris2\n\n\n")
echo "[$hasil]"
```

Output:

```
[baris1
baris2]
```

Newline di akhir dihapus, tetapi newline di tengah dipertahankan.

**Jebakan:** Jika Anda memerlukan newline di akhir, tambahkan karakter dummy lalu hapus:

```sh
hasil=$(printf "baris1\nbaris2\n"; echo x)
hasil=${hasil%x}
```

### Word Splitting pada Command Substitution

Jika command substitution **tidak dikutip**, hasilnya mengalami **word splitting** dan **globbing**:

```sh
file="my document.txt"
daftar=$(ls)
echo $daftar    # Dipecah berdasarkan IFS
```

Untuk mencegah:

```sh
echo "$daftar"    # Dianggap satu string
```

**Aturan:** Selalu kutip command substitution: `"$(...)"`.

### Contoh 1: Menyimpan Tanggal

```sh
tanggal=$(date '+%Y-%m-%d')
echo "Hari ini: $tanggal"
```

Penjelasan:

- `date '+%Y-%m-%d'` – Mencetak tanggal dalam format YYYY-MM-DD.
- `$(...)` – Menangkap output.
- `tanggal` – Variabel menyimpan string tanggal.

### Contoh 2: Menghitung Baris File

```sh
jumlah=$(wc -l < file.txt)
echo "Jumlah baris: $jumlah"
```

Penjelasan:

- `wc -l < file.txt` – Menghitung baris. Menggunakan redirection `<` agar `wc` membaca dari stdin, bukan argumen. Ini mencegah output menyertakan nama file.
- Tanpa `<`, output: `42 file.txt`. Dengan `<`, output: `42`.

### Contoh 3: Menangkap Output Multi-Baris

```sh
daftar_file=$(ls -1)
echo "$daftar_file"
```

Penjelasan:

- `ls -1` – Satu file per baris.
- `$(...)` – Menangkap seluruh output.
- `"$daftar_file"` – Mencetak dengan newline dipertahankan.

Untuk memproses per baris:

```sh
printf '%s\n' "$daftar_file" | while IFS= read -r file; do
    echo "File: $file"
done
```

Penjelasan:

- `printf '%s\n' "$daftar_file"` – Mencetak variabel dengan newline (menggantikan `echo` yang tidak portabel untuk multi-baris).
- Pipe ke `while read`.

### Contoh 4: Nested Command Substitution

```sh
echo "Hostname: $(hostname), Waktu: $(date '+%H:%M:%S')"
```

Penjelasan:

- Dua command substitution dalam satu perintah.
- Dieksekusi secara berurutan.

```sh
echo "Total file .txt: $(ls *.txt 2>/dev/null | wc -l)"
```

Penjelasan:

- `ls *.txt 2>/dev/null` – Mencari file `.txt`, buang error.
- `| wc -l` – Menghitung.
- `$(...)` – Menangkap hasil.

---

## 3.2.2 Filosofi Unix dan Pipeline

### Filosofi Unix

Doug McIlroy, pencipta pipe, merumuskan filosofi Unix:

> **"Write programs that do one thing and do it well. Write programs to work together. Write programs to handle text streams, because that is a universal interface."**

Artinya:

1. Setiap program melakukan **satu hal** dengan baik.
2. Program-program **bekerja sama** melalui teks.
3. **Teks** adalah antarmuka universal.

Contoh: `grep` mencari. `sort` mengurutkan. `uniq` menghilangkan duplikat. `wc` menghitung. Masing-masing sederhana, tetapi dikombinasikan menjadi alat yang sangat kuat.

### Pipeline: `|`

**Pipeline** menghubungkan stdout satu perintah ke stdin perintah berikutnya.

```sh
perintah1 | perintah2 | perintah3
```

Penjelasan:

- `|` – Operator pipe. Membuat saluran antar-proses.
- stdout `perintah1` menjadi stdin `perintah2`.
- stdout `perintah2` menjadi stdin `perintah3`.
- stderr **tidak** melalui pipe; tetap ke terminal.

### Mekanisme Pipeline

Apa yang terjadi ketika shell mengeksekusi:

```sh
ls -l | grep ".txt" | wc -l
```

Langkah demi langkah:

1. **Parsing** — Shell mem-parsing pipeline.
2. **Fork 1** — Shell membuat proses anak untuk `ls -l`.
3. **Fork 2** — Shell membuat proses anak untuk `grep ".txt"`.
4. **Fork 3** — Shell membuat proses anak untuk `wc -l`.
5. **Pipe 1** — Shell membuat pipe antara `ls` dan `grep`.
   - stdout `ls` → ujung tulis pipe 1.
   - stdin `grep` → ujung baca pipe 1.
6. **Pipe 2** — Shell membuat pipe antara `grep` dan `wc`.
   - stdout `grep` → ujung tulis pipe 2.
   - stdin `wc` → ujung baca pipe 2.
7. **Exec** — Setiap proses anak menjalankan perintahnya.
8. **Wait** — Shell menunggu semua proses anak selesai.
9. **Exit Status** — Exit status pipeline adalah exit status **perintah terakhir**.

**Poin penting:** Setiap perintah dalam pipeline berjalan di **subshell** (di sebagian besar shell). Ini berarti:

- Variabel yang di-set tidak bertahan.
- Perubahan direktori tidak bertahan.
- Perubahan `umask` tidak bertahan.

### Contoh Pipeline Sederhana

**Menghitung file `.txt`:**

```sh
ls -1 | grep "\.txt$" | wc -l
```

Penjelasan:

- `ls -1` – Daftar file, satu per baris.
- `grep "\.txt$"` – Filter yang berakhiran `.txt`. `\.` meng-escape titik; `$` adalah akhir baris.
- `wc -l` – Hitung baris.

**Mencari proses:**

```sh
ps aux | grep "python" | grep -v "grep"
```

Penjelasan:

- `ps aux` – Semua proses.
- `grep "python"` – Filter yang mengandung "python".
- `grep -v "grep"` – Buang baris yang mengandung "grep" (grep itu sendiri ikut muncul).

**Mengurutkan dan menghilangkan duplikat:**

```sh
cut -d: -f1 /etc/passwd | sort | uniq
```

Penjelasan:

- `cut -d: -f1 /etc/passwd` – Ambil field pertama (username).
- `sort` – Urutkan.
- `uniq` – Hilangkan duplikat **berurutan** (karena itu butuh `sort` dulu).

### Exit Status Pipeline

Exit status pipeline adalah exit status **perintah terakhir**:

```sh
false | true
echo "$?"    # 0, karena true sukses
```

```sh
true | false
echo "$?"    # 1, karena false gagal
```

**Jebakan:** Jika perintah pertama gagal tetapi yang terakhir sukses, exit status pipeline adalah `0`. Untuk memperbaiki, gunakan `pipefail` (tidak POSIX):

```sh
set -o pipefail    # Tidak POSIX
false | true
echo "$?"          # 1
```

Untuk portabilitas, periksa setiap perintah secara terpisah atau gunakan trik:

```sh
{ false; echo $? > /tmp/status.$$; } | true
status=$(cat /tmp/status.$$)
rm -f /tmp/status.$$
```

Rumit. Untuk skrip POSIX, sering kali cukup memeriksa exit status pipeline keseluruhan.

### Pipeline vs Perintah Berurutan

```sh
# Berurutan: perintah kedua menunggu pertama selesai
perintah1; perintah2

# Pipeline: berjalan bersamaan
perintah1 | perintah2
```

Dalam pipeline, `perintah1` dan `perintah2` berjalan **bersamaan**. `perintah1` menulis ke pipe, `perintah2` membaca. Jika `perintah1` menulis lebih cepat dari `perintah2` membaca, pipe akan penuh dan `perintah1` akan menunggu.

---

## 3.2.3 Jebakan Subshell dalam Pipeline

Ini adalah jebakan paling berbahaya dalam pipeline. Wajib dipahami.

### Masalah

```sh
count=0
echo "a" | while read -r line; do
    count=$((count + 1))
done
echo "count=$count"
```

Output:

```
count=0
```

**Mengapa?** Karena `while ... done` berjalan di **subshell** sebagai bagian dari pipeline.

### Mengapa Subshell?

Karena setiap sisi pipeline adalah proses terpisah. Untuk menjalankan `while` di sisi kanan pipe, shell membuat proses anak (fork). Perubahan variabel di proses anak tidak terlihat oleh induk.

### Solusi 1: Redirection

```sh
count=0
while read -r line; do
    count=$((count + 1))
done < <(echo "a")
```

Penjelasan:

- `< <(...)` – Process substitution. Menggantikan pipe dengan file descriptor.
- Namun, **process substitution tidak POSIX**. Untuk POSIX, gunakan file atau pipe ke file:

```sh
echo "a" > /tmp/data.$$
count=0
while read -r line; do
    count=$((count + 1))
done < /tmp/data.$$
rm -f /tmp/data.$$
echo "count=$count"
```

### Solusi 2: Command Group

```sh
count=0
{
    while read -r line; do
        count=$((count + 1))
    done
    echo "count=$count"    # Dalam group
} < file.txt
```

Penjelasan:

- `{ ... }` – Command group. Berjalan di shell saat ini.
- `< file.txt` – Redirection di group.

### Solusi 3: Gunakan Perintah yang Mengembalikan Nilai

```sh
count=$(grep -c "" file.txt)
```

Penjelasan:

- `grep -c ""` – Hitung baris (pola kosong cocok dengan semua).
- Output ditangkap, tidak perlu loop.

### Kapan Subshell Tidak Masalah?

Jika Anda tidak perlu mempertahankan perubahan variabel, subshell tidak masalah:

```sh
cat file.txt | grep "error" | wc -l
```

Tidak ada variabel yang di-set, tidak ada masalah.

---

## 3.2.4 `xargs` — Batch Processing

`xargs` membaca item dari stdin dan menjalankan perintah dengan item tersebut sebagai argumen. Ini adalah alat yang sangat kuat untuk menghindari loop yang lambat.

### Sintaks Dasar

```sh
xargs [opsi] [perintah [argumen-awal...]]
```

Penjelasan:

- `xargs` – Membaca dari stdin.
- Secara default, memisahkan input berdasarkan whitespace.
- Menjalankan perintah dengan item sebagai argumen.
- Jika perintah tidak diberikan, default adalah `echo`.

### Contoh 1: Menghapus File

```sh
find . -name "*.tmp" | xargs rm
```

Penjelasan:

- `find . -name "*.tmp"` – Mencetak path file `.tmp`.
- `| xargs rm` – Menjalankan `rm` dengan file-file tersebut sebagai argumen.
- Jika banyak file, `xargs` membagi menjadi beberapa pemanggilan `rm` agar tidak melebihi batas argumen sistem.

### Contoh 2: Menentukan Jumlah Argumen per Perintah

```sh
find . -name "*.txt" | xargs -n 1 rm
```

Penjelasan:

- `-n 1` – Satu argumen per pemanggilan `rm`.
- Menjalankan `rm file1`, `rm file2`, dst.
- Berguna untuk perintah yang hanya menerima satu argumen.

### Contoh 3: Menggunakan Placeholder

```sh
find . -name "*.txt" | xargs -I {} cp {} /backup/
```

Penjelasan:

- `-I {}` – **Replace string**. Setiap `{}` digantikan dengan item dari input.
- `cp {} /backup/` – Untuk setiap file, jalankan `cp file /backup/`.
- `-I` menyebabkan `xargs` memproses **satu item sekaligus**.
- **Catatan:** `-I` mengubah perilaku; `xargs` tidak lagi menggabungkan beberapa item.

### Contoh 4: `-0` untuk Nama File dengan Spasi

```sh
find . -name "*.txt" -print0 | xargs -0 rm
```

Penjelasan:

- `-print0` – `find` mencetak path dipisahkan NUL (`\0`), bukan newline.
- `xargs -0` – Membaca input dipisahkan NUL.
- Ini menangani nama file dengan spasi, tab, newline.
- **`-print0` dan `-0` tidak POSIX.** Ekstensi GNU. Untuk portabilitas, gunakan `find -exec`.

### Contoh 5: `xargs` dengan Perintah Shell

```sh
find . -name "*.txt" | xargs -I {} sh -c 'echo "File: $1"' sh {}
```

Penjelasan:

- `sh -c 'perintah' sh {}` – Menjalankan shell dengan `{}` sebagai argumen.
- Di dalam `sh -c`, `$1` mengacu ke argumen pertama (yang di-pass sebagai `{}`).
- `sh` kedua adalah `$0` untuk shell, konvensi.
- Berguna untuk logika kompleks per item.

### Contoh 6: `xargs -P` untuk Paralel (Tidak POSIX)

```sh
find . -name "*.jpg" | xargs -P 4 -I {} convert {} {}.png
```

Penjelasan:

- `-P 4` – **Parallel**. Jalankan 4 proses bersamaan.
- **Tidak POSIX.** Ekstensi GNU.
- Sangat berguna untuk mempercepat pemrosesan batch.

### Contoh 7: `xargs` dengan `-t` (Verbose, Tidak POSIX)

```sh
echo "file.txt" | xargs -t rm
```

Output (ke stderr):

```
rm file.txt
```

Penjelasan:

- `-t` – **Trace**. Mencetak perintah yang dijalankan sebelum mengeksekusinya.
- Berguna untuk debugging.
- Tidak POSIX.

### Jebakan `xargs`

**Jebakan 1: Input Kosong**

```sh
find . -name "*.tmp" | xargs rm
```

Jika tidak ada file `.tmp`, `xargs rm` akan menjalankan `rm` **tanpa argumen**, yang error. Untuk mencegah, gunakan `-r` (GNU):

```sh
find . -name "*.tmp" | xargs -r rm
```

`-r` tidak POSIX. Untuk POSIX, gunakan:

```sh
files=$(find . -name "*.tmp")
if [ -n "$files" ]; then
    echo "$files" | xargs rm
fi
```

**Jebakan 2: Nama File dengan Spasi**

```sh
echo "file penting.txt" | xargs rm
```

`xargs` akan memecah menjadi `file` dan `penting.txt`, lalu menjalankan `rm file penting.txt`. Ini menghapus dua file yang berbeda!

**Solusi:** Gunakan `-0` dengan `-print0`, atau `-I {}`.

**Jebakan 3: `xargs` Memanggil Shell**

```sh
echo "hello; rm -rf /" | xargs sh -c
```

Jika input tidak dipercaya, ini adalah **command injection**. Jangan gunakan `xargs sh -c` dengan input dari pengguna.

**Jebakan 4: Argumen Terlalu Panjang**

`xargs` secara otomatis membagi argumen agar tidak melebihi `ARG_MAX`. Tetapi jika satu argumen saja sudah terlalu panjang, `xargs` akan error.

---

## 3.2.5 Process Substitution — Tidak POSIX

**Process substitution** adalah fitur bash/ksh/zsh yang memungkinkan Anda menggunakan output perintah sebagai file.

### Sintaks

```sh
perintah <(perintah_lain)
```

Penjelasan:

- `<(perintah_lain)` – Menjalankan `perintah_lain`, membuat named pipe atau `/dev/fd`, dan menggantikan `<(...)` dengan path ke pipe tersebut.
- `perintah` melihat `<(...)` sebagai nama file.

### Contoh 1: `diff` Dua Perintah

```sh
diff <(ls /dir1) <(ls /dir2)
```

Penjelasan:

- `<(...)` – Menjalankan `ls`, hasilnya tersedia sebagai file.
- `diff` membandingkan dua file.
- **Tidak POSIX.** Untuk portabilitas, gunakan file temporary:

```sh
ls /dir1 > /tmp/a.$$
ls /dir2 > /tmp/b.$$
diff /tmp/a.$$ /tmp/b.$$
rm -f /tmp/a.$$ /tmp/b.$$
```

### Contoh 2: `while read` dengan Process Substitution

```sh
while IFS= read -r line; do
    echo "Baris: $line"
done < <(grep "error" log.txt)
```

Penjelasan:

- `< <(grep ...)` – Process substitution sebagai input.
- Loop berjalan di shell saat ini, **bukan** subshell.
- Variabel yang di-set di dalam loop bertahan.

Ini adalah **keuntungan utama** process substitution: menghindari jebakan subshell.

### Contoh 3: Output Process Substitution

```sh
tee >(gzip > log.gz) >(wc -l > count.txt) < log.txt > /dev/null
```

Penjelasan:

- `>(gzip > log.gz)` – Process substitution untuk output. `tee` menulis ke pipe, `gzip` membacanya.
- `tee` menulis ke dua pipe sekaligus.
- Rumit, tetapi sangat kuat.

### Alternatif POSIX

Karena process substitution tidak POSIX, gunakan file temporary atau named pipe (lihat berikutnya).

---

## 3.2.6 Named Pipe (`mkfifo`)

**Named pipe** (FIFO) adalah file khusus yang berperilaku seperti pipe, tetapi memiliki nama di filesystem.

### Membuat Named Pipe

```sh
mkfifo /tmp/mypipe
```

Penjelasan:

- `mkfifo` – Membuat FIFO.
- `/tmp/mypipe` – Path FIFO.

### Menggunakan Named Pipe

**Terminal 1:**

```sh
cat > /tmp/mypipe
```

**Terminal 2:**

```sh
cat < /tmp/mypipe
```

Penjelasan:

- Terminal 1 menulis ke pipe.
- Terminal 2 membaca dari pipe.
- Keduanya **blocking**: penulis menunggu pembaca, dan sebaliknya.

### Contoh: Komunikasi Antar Proses

```sh
#!/bin/sh
# Producer
mkfifo /tmp/data.fifo

# Consumer di latar belakang
(while IFS= read -r line; do
    echo "Diterima: $line"
done < /tmp/data.fifo) &

# Producer menulis
echo "Pesan 1" > /tmp/data.fifo
echo "Pesan 2" > /tmp/data.fifo

wait
rm -f /tmp/data.fifo
```

Penjelasan:

- `mkfifo` – Membuat FIFO.
- `(...) &` – Consumer di latar belakang.
- `echo ... > fifo` – Producer menulis.
- `wait` – Tunggu consumer selesai.
- `rm` – Hapus FIFO.

### Kapan Menggunakan Named Pipe?

- Komunikasi antar proses yang tidak bisa di-pipe langsung.
- Menghindari subshell (dengan `while read < fifo`).
- Sebagai pengganti process substitution di shell POSIX.

### Jebakan Named Pipe

- **Blocking:** Membuka FIFO untuk baca akan memblokir sampai ada yang menulis, dan sebaliknya.
- **Satu pembaca:** FIFO hanya bisa dibaca oleh satu proses pada satu waktu.
- **Harus dihapus:** FIFO tetap ada setelah proses selesai.

---

## 3.2.7 Optimasi Performa

### Pipeline vs Loop

```sh
# Lambat: loop dengan perintah eksternal per iterasi
while IFS= read -r line; do
    echo "$line" | grep "error"
done < file.txt

# Cepat: satu grep
grep "error" file.txt
```

Penjelasan:

- Versi loop menjalankan `grep` sekali per baris.
- Versi pipeline menjalankan `grep` sekali untuk seluruh file.
- Untuk 10.000 baris, versi loop 10.000 kali lebih lambat.

### Pipeline vs `xargs`

```sh
# Loop lambat
for file in *.txt; do
    gzip "$file"
done

# xargs lebih cepat (tapi tidak lebih cepat dari gzip multiple)
find . -name "*.txt" | xargs gzip
```

Penjelasan:

- `xargs` menggabungkan beberapa file menjadi satu pemanggilan `gzip`.
- `gzip` bisa memproses banyak file sekaligus.
- Jauh lebih efisien.

### Pipeline vs `sed`/`awk`

```sh
# Loop lambat
while IFS= read -r line; do
    echo "$line" | sed 's/foo/bar/g'
done < file.txt

# Sed langsung
sed 's/foo/bar/g' file.txt
```

### Kapan Loop Tetap Perlu?

- Ketika ada state antar-baris.
- Ketika logika kondisional kompleks.
- Ketika memproses input interaktif.
- Ketika memanggil fungsi shell sendiri.

### Prinsip Umum

1. **Gunakan perintah yang memproses banyak item sekaligus** (grep, sed, awk, xargs) alih-alih loop.
2. **Hindari memanggil perintah eksternal di dalam loop** jika bisa dipindahkan ke luar.
3. **Gunakan built-in shell** (parameter expansion, `case`, `[ ]`) daripada perintah eksternal untuk manipulasi string sederhana.
4. **Batasi subshell** — setiap `$(...)` dan setiap sisi pipeline membuat proses.

---

## 3.2.8 Contoh Skrip Lengkap

### Skrip 1: Analisis Log

```sh
#!/bin/sh
# Nama: analisis_log.sh
# Tujuan: Menganalisis file log dengan pipeline

LOG_FILE="${1:?Penggunaan: $0 file_log}"

if [ ! -r "$LOG_FILE" ]; then
    echo "Error: $LOG_FILE tidak dapat dibaca." >&2
    exit 1
fi

echo "=== Ringkasan Log ==="
echo "Total baris: $(wc -l < "$LOG_FILE")"
echo "Total error: $(grep -c "ERROR" "$LOG_FILE")"
echo "Total warning: $(grep -c "WARN" "$LOG_FILE")"
echo

echo "=== 5 Error Terakhir ==="
grep "ERROR" "$LOG_FILE" | tail -n 5
echo

echo "=== 10 Pesan Paling Sering ==="
grep -o "ERROR: [^ ]*" "$LOG_FILE" | sort | uniq -c | sort -rn | head -n 10
```

Bedah:

- `wc -l < "$LOG_FILE"` – Hitung baris tanpa nama file.
- `grep -c "ERROR"` – Hitung kecocokan.
- `grep -o "ERROR: [^ ]*"` – **Only matching**. Ambil hanya bagian yang cocok.
  - `[^ ]*` – Satu atau lebih karakter selain spasi.
- `sort | uniq -c | sort -rn | head -n 10` – Urutkan, hitung, urutkan berdasarkan jumlah, ambil 10 teratas.

### Skrip 2: Batch Rename

```sh
#!/bin/sh
# Nama: batch_rename.sh
# Tujuan: Mengganti nama file .jpeg menjadi .jpg

DIR="${1:-.}"

if [ ! -d "$DIR" ]; then
    echo "Error: $DIR bukan direktori." >&2
    exit 1
fi

find "$DIR" -type f -name "*.jpeg" | while IFS= read -r file; do
    newfile="${file%.jpeg}.jpg"
    if [ -e "$newfile" ]; then
        echo "Skip: $newfile sudah ada." >&2
        continue
    fi
    mv "$file" "$newfile"
    echo "Renamed: $file -> $newfile"
done
```

Bedah:

- `find "$DIR" -type f -name "*.jpeg"` – Cari file `.jpeg`.
- `| while IFS= read -r file` – Baca per baris (aman untuk spasi).
- `${file%.jpeg}.jpg` – Hapus akhiran `.jpeg`, tambah `.jpg`.
- `[ -e "$newfile" ]` – Cek jika target ada.
- `mv "$file" "$newfile"` – Rename.

**Catatan:** Untuk nama file dengan newline, ini rusak. Untuk portabilitas maksimal, gunakan `find -exec sh -c '...' sh {} +`.

### Skrip 3: Pencarian Paralel dengan `xargs`

```sh
#!/bin/sh
# Nama: cari_paralel.sh
# Tujuan: Mencari pola di banyak file secara paralel (GNU xargs)

POLA="${1:?Penggunaan: $0 pola}"
DIR="${2:-.}"

if [ ! -d "$DIR" ]; then
    echo "Error: $DIR bukan direktori." >&2
    exit 1
fi

find "$DIR" -type f -print0 | \
    xargs -0 -P 4 -I {} sh -c '
        if grep -q "$1" "$2" 2>/dev/null; then
            echo "Ditemukan di: $2"
        fi
    ' sh "$POLA" {}
```

Bedah:

- `-print0` – Pisahkan dengan NUL.
- `xargs -0` – Baca NUL.
- `-P 4` – Paralel 4 proses.
- `-I {}` – Placeholder.
- `sh -c '...' sh "$POLA" {}` – Shell script. `$1` = `$POLA`, `$2` = `{}`.
- `grep -q` – Quiet, hanya exit status.

**Catatan:** `-P` dan `-I` tidak POSIX. Untuk skrip POSIX, hilangkan `-P` dan `-print0`.

### Skrip 4: Penggabungan File dengan Named Pipe

```sh
#!/bin/sh
# Nama: gabung_fifo.sh
# Tujuan: Menggabungkan dua sumber dengan FIFO

FIFO="/tmp/gabung.$$"
mkfifo "$FIFO" || exit 1

# Consumer
sort "$FIFO" > hasil_sorted.txt &
CONSUMER_PID=$!

# Producer
{
    cat file1.txt
    cat file2.txt
} > "$FIFO"

wait "$CONSUMER_PID"
rm -f "$FIFO"

echo "Hasil: hasil_sorted.txt"
```

Bedah:

- `mkfifo "$FIFO"` – Buat FIFO.
- `sort "$FIFO" > hasil_sorted.txt &` – Consumer di latar belakang.
- `{ ... } > "$FIFO"` – Producer menulis ke FIFO.
- `wait "$CONSUMER_PID"` – Tunggu consumer.
- `rm -f "$FIFO"` – Bersihkan.

---

## 3.2.9 Latihan

1. **Command Substitution:**
   - Tulis skrip yang menyimpan tanggal, waktu, dan hostname ke variabel.
   - Cetak dengan format: "Pada [tanggal] [waktu] di [hostname]".

2. **Nested Substitution:**
   - Gunakan `$(...)` bersarang untuk menghitung jumlah file di direktori yang namanya mengandung tanggal hari ini.

3. **Pipeline Sederhana:**
   - Pipeline: `ps aux | grep "python" | grep -v grep | wc -l`.
   - Jelaskan setiap langkah.

4. **Subshell:**
   - Tulis skrip yang menghitung baris dengan pipeline.
   - Coba gunakan variabel counter di dalam `while` setelah pipe.
   - Apa yang terjadi? Mengapa?

5. **`xargs`:**
   - Gunakan `find` dan `xargs` untuk menghapus semua file `.bak` di direktori.
   - Tangani kasus tidak ada file `.bak`.
   - Tangani nama file dengan spasi.

6. **`xargs -I`:**
   - Buat file `daftar.txt` berisi nama-nama file.
   - Untuk setiap file, jalankan `cp` ke `/tmp/`.
   - Gunakan `xargs -I`.

7. **Process Substitution (bash):**
   - Bandingkan output dari `ls /etc` dan `ls /tmp`.
   - Gunakan `diff <(ls /etc) <(ls /tmp)`.

8. **Named Pipe:**
   - Buat FIFO.
   - Satu terminal menulis, terminal lain membaca.
   - Amati perilaku blocking.

9. **Optimasi:**
   - Tulis skrip yang membaca file dan mencari baris mengandung "error".
   - Versi 1: loop dengan `grep` per baris.
   - Versi 2: satu `grep`.
   - Bandingkan waktu dengan `time`.

10. **Pipeline Kompleks:**
    - Ambil 10 kata paling sering dari file teks.
    - Gunakan `tr`, `sort`, `uniq`, `head`.

---

## 3.2.10 Ringkasan Materi 2

- **Command substitution** `$(...)` lebih unggul dari backtick: nesting, keterbacaan, escaping.
- Command substitution berjalan di **subshell** — variabel tidak bertahan.
- Selalu kutip: `"$(...)"` untuk mencegah word splitting.
- **Filosofi Unix**: program kecil yang bekerja sama melalui teks.
- **Pipeline** `|` menghubungkan stdout ke stdin. Setiap sisi berjalan di subshell.
- Exit status pipeline adalah exit status perintah terakhir.
- **`xargs`** untuk batch processing; `-0` dan `-print0` untuk nama file dengan spasi.
- **Process substitution** `<( )` dan `>( )` menghindari subshell, tapi tidak POSIX.
- **Named pipe** (`mkfifo`) untuk komunikasi antar proses yang portabel.
- **Optimasi**: gunakan `grep`, `sed`, `awk`, `xargs` alih-alih loop dengan perintah eksternal.
- **Jebakan subshell**: pipeline membuat subshell; variabel yang di-set tidak bertahan.

---

## 📌 Selanjutnya

Materi 2 Level 3 selesai. Anda sekarang menguasai command substitution dan pipeline secara mendalam.

Berikutnya adalah **Materi 3: Pattern Matching & Text Processing** — kita akan membahas:

- Globbing mendalam: `*`, `?`, `[ ]`, `[! ]`, `[[:class:]]`.
- Regular Expression POSIX: BRE vs ERE.
- `grep` mendalam: semua opsi, regex, dan trik.
- `sed` mendalam: substitusi, alamat, hold space, multiple commands.
- `awk` mendalam: field, pattern-action, variabel, fungsi.
- Ekspansi parameter untuk manipulasi string (`${var#pattern}`, dll).

## Materi 3: Pattern Matching & Text Processing

> **Catatan:** Ini adalah **materi ketiga** dari Level 3, sesuai kurikulum yang sudah ditetapkan. Kita akan membahas **pattern matching** (globbing dan ekspansi parameter) serta **text processing** (`grep`, `sed`, `awk`) dengan regex POSIX. Setelah materi ini, Anda akan mampu memanipulasi teks dengan presisi bedah — mencari, mengganti, mengekstrak, dan mentransformasi data teks dalam skala apa pun.

---

## 🎯 Tujuan Materi 3

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Menguasai **globbing** (`*`, `?`, `[ ]`, `[! ]`, `[[:class:]]`) secara mendalam.
2. Memahami perbedaan **globbing** dan **regex** — dua hal yang sering tertukar.
3. Menguasai **ekspansi parameter** untuk manipulasi string: `${var#pattern}`, `${var%pattern}`, `${var##pattern}`, `${var%%pattern}`.
4. Memahami **POSIX Regular Expression**: BRE (Basic) dan ERE (Extended).
5. Menguasai **`grep`** secara mendalam: semua opsi penting, regex, dan trik.
6. Menguasai **`sed`**: substitusi, alamat, multiple commands, hold space.
7. Menguasai **`awk`**: field, pattern-action, variabel, dan fungsi.
8. Memilih alat yang tepat: kapan `grep`, kapan `sed`, kapan `awk`.
9. Menghindari jebakan regex yang membuat pola tidak cocok.

---

## 3.3.1 Globbing — Pattern Matching oleh Shell

**Globbing** adalah ekspansi wildcard oleh **shell** (bukan oleh perintah). Shell melihat pola, mencari file yang cocok, dan menggantikan pola dengan daftar file.

### Karakter Wildcard

| Pola | Arti |
|------|------|
| `*` | Cocok dengan nol atau lebih karakter apa pun (kecuali `/`) |
| `?` | Cocok dengan tepat satu karakter apa pun (kecuali `/`) |
| `[abc]` | Cocok dengan satu karakter dari himpunan `a`, `b`, `c` |
| `[a-z]` | Cocok dengan satu karakter dalam rentang `a`–`z` |
| `[!abc]` | Cocok dengan satu karakter **bukan** `a`, `b`, `c` |
| `[^abc]` | Sama seperti `[!abc]` (beberapa shell) |
| `[[:alpha:]]` | Cocok dengan satu karakter alfabet |
| `[[:digit:]]` | Cocok dengan satu digit |
| `[[:alnum:]]` | Alfabet atau digit |
| `[[:space:]]` | Whitespace (spasi, tab, newline) |
| `[[:upper:]]` | Huruf besar |
| `[[:lower:]]` | Huruf kecil |
| `[[:punct:]]` | Tanda baca |

### Contoh Globbing

```sh
echo *.txt
```

Penjelasan:

- `*` – Cocok dengan nol atau lebih karakter.
- `.txt` – Literal.
- Shell mencari file di direktori saat ini yang berakhiran `.txt`.
- Hasilnya, `echo` menerima daftar file sebagai argumen terpisah.

```sh
echo file?.txt
```

Penjelasan:

- `?` – Tepat satu karakter.
- Cocok dengan `file1.txt`, `fileA.txt`, tetapi **tidak** `file12.txt`.

```sh
echo [abc]*.txt
```

Penjelasan:

- `[abc]` – Satu karakter: `a`, `b`, atau `c`.
- `*` – Sisa apa pun.
- Cocok dengan `apple.txt`, `banana.txt`, `cat.txt`, tetapi tidak `dog.txt`.

```sh
echo [!0-9]*.txt
```

Penjelasan:

- `[!0-9]` – Satu karakter **bukan** digit.
- Cocok dengan `apple.txt`, tetapi tidak `1file.txt`.

```sh
echo [[:digit:]]*.txt
```

Penjelasan:

- `[[:digit:]]` – Satu digit.
- Cocok dengan `1file.txt`, `9cat.txt`, tetapi tidak `apple.txt`.

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

### Globbing Tidak Cocok: Perilaku Default

Jika tidak ada file yang cocok, shell POSIX membiarkan pola **literal**:

```sh
echo *.xyz
```

Output (jika tidak ada file `.xyz`):

```
*.xyz
```

Ini bisa menjadi jebakan. Dalam loop:

```sh
for file in *.txt; do
    [ -f "$file" ] || continue
    # ...
done
```

Penjelasan:

- Jika tidak ada file `.txt`, `$file` = `"*.txt"`.
- `[ -f "*.txt" ]` gagal, `continue` dijalankan.
- Loop tidak melakukan apa pun.

### Globbing Tidak Melintasi `/`

```sh
echo /etc/*.conf
```

Penjelasan:

- `*` cocok dengan file di `/etc` saja, tidak masuk subdirektori.
- Untuk rekursif, gunakan `find` atau `**` (dengan `globstar` di bash, tidak POSIX).

### Globbing vs Regex

Ini adalah **perbedaan paling penting** yang harus dipahami:

| Aspek | Globbing | Regex |
|-------|----------|-------|
| Diekspansi oleh | Shell | Perintah (`grep`, `sed`, `awk`) |
| `*` | Nol atau lebih karakter apa pun | Nol atau lebih dari karakter sebelumnya |
| `?` | Tepat satu karakter | Nol atau satu dari karakter sebelumnya (ERE) |
| `.` | Literal titik | Karakter apa pun |
| `[ ]` | Himpunan karakter | Himpunan karakter (sama) |
| `^` | Bukan di awal (jika `[^]`) | Awal baris |
| `$` | Literal dolar | Akhir baris |

**Contoh penting:**

```sh
# Globbing: cocok dengan file apa pun yang diakhiri .txt
ls *.txt

# Regex: cocok dengan string apa pun yang diakhiri .txt
grep ".*\.txt" file.txt
```

- Dalam globbing, `*` berarti "apa pun".
- Dalam regex, `*` berarti "ulangi karakter sebelumnya nol atau lebih kali".
- Untuk "apa pun" dalam regex, gunakan `.*` (titik = karakter apa pun, bintang = ulangi).

---

## 3.3.2 Ekspansi Parameter untuk Manipulasi String

POSIX mendefinisikan operator ekspansi parameter untuk memanipulasi string tanpa memanggil perintah eksternal. Ini **jauh lebih cepat** daripada `sed` atau `awk` untuk operasi sederhana.

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

- `#` – Hapus **awalan terpendek** yang cocok dengan `pattern`.
- `*/` – Pola glob: apa pun diikuti `/`.
- `#*/` menghapus awalan terpendek yang diakhiri `/`, yaitu `/` pertama.

### `${var##pattern}` — Hapus Awalan Terpanjang

```sh
echo "${file##*/}"
```

Output:

```
laporan.txt
```

Penjelasan:

- `##` – Hapus **awalan terpanjang**.
- `##*/` menghapus semua hingga `/` terakhir.

### `${var%pattern}` — Hapus Akhiran Terpendek

```sh
echo "${file%.*}"
```

Output:

```
/home/budi/laporan
```

Penjelasan:

- `%` – Hapus **akhiran terpendek**.
- `.*` – Pola: titik diikuti apa pun.
- `%.*` menghapus `.txt`.

### `${var%%pattern}` — Hapus Akhiran Terpanjang

```sh
file="arsip.tar.gz"
echo "${file%%.*}"
```

Output:

```
arsip
```

Penjelasan:

- `%%` – Hapus akhiran terpanjang.
- `%%.*` menghapus dari titik pertama.

Bandingkan:

```sh
echo "${file%.*}"    # arsip.tar
echo "${file%%.*}"   # arsip
```

### Tabel Ringkasan

| Operator | Posisi | Panjang |
|----------|--------|---------|
| `#` | Awalan | Terpendek |
| `##` | Awalan | Terpanjang |
| `%` | Akhiran | Terpendek |
| `%%` | Akhiran | Terpanjang |

### Contoh Praktis: Ekstrak Path

```sh
path="/var/log/syslog.1.gz"

echo "Direktori: ${path%/*}"      # /var/log
echo "Nama file: ${path##*/}"     # syslog.1.gz
echo "Ekstensi: ${path##*.}"      # gz
echo "Tanpa ekstensi: ${path%.*}" # /var/log/syslog.1
echo "Base tanpa semua ekstensi: ${path%%.*}"  # /var/log/syslog
```

### Pola Kompleks

```sh
file="prefix_20240101_suffix.txt"

# Hapus awalan hingga underscore pertama
echo "${file#*_}"       # 20240101_suffix.txt

# Hapus awalan hingga underscore terakhir
echo "${file##*_}"      # suffix.txt

# Hapus akhiran dari underscore terakhir
echo "${file%_*}"       # prefix_20240101

# Hapus akhiran dari underscore pertama
echo "${file%%_*}"      # prefix
```

### Jebakan: Pola adalah Globbing, Bukan Regex

```sh
var="hello.txt"
echo "${var%.*}"    # hello
echo "${var%\.*}"   # hello.txt (backslash bukan escape di globbing)
```

Penjelasan:

- Dalam ekspansi parameter, pola adalah **globbing pattern**, bukan regex.
- Backslash bukan escape. Gunakan `[.]` atau `.` literal.

```sh
echo "${var%[.]*}"  # hello
```

### Mengganti Substring — Tidak POSIX

Bash mendukung `${var/old/new}` untuk mengganti substring:

```sh
var="hello world"
echo "${var/world/posix}"   # hello posix
```

**Ini tidak POSIX.** Untuk skrip portabel, gunakan `sed`:

```sh
echo "$var" | sed 's/world/posix/'
```

Namun, banyak shell modern mendukungnya. Gunakan hanya jika Anda tahu target shell Anda.

---

## 3.3.3 POSIX Regular Expression: BRE dan ERE

POSIX mendefinisikan **dua jenis** regular expression:

1. **BRE (Basic Regular Expression)** – Digunakan oleh `grep` (tanpa `-E`) dan `sed`.
2. **ERE (Extended Regular Expression)** – Digunakan oleh `grep -E`, `awk`.

Perbedaan utama: ERE mendukung lebih banyak metakarakter tanpa escape.

### Metakarakter Dasar

| Karakter | Arti | BRE | ERE |
|----------|------|-----|-----|
| `.` | Karakter apa pun | ✅ | ✅ |
| `*` | Nol atau lebih dari sebelumnya | ✅ | ✅ |
| `^` | Awal baris | ✅ | ✅ |
| `$` | Akhir baris | ✅ | ✅ |
| `[...]` | Himpunan karakter | ✅ | ✅ |
| `[^...]` | Negasi himpunan | ✅ | ✅ |
| `\+` | Satu atau lebih | `\+` | `+` |
| `\?` | Nol atau satu | `\?` | `?` |
| `\|` | Alternasi | `\|` | `\|` |
| `\{n,m\}` | Kuantifier | `\{n,m\}` | `{n,m}` |
| `\(...\)` | Grup | `\(...\)` | `(...)` |

**Perhatikan:** Di BRE, `+`, `?`, `|`, `{}`, `()` harus di-escape dengan backslash untuk mendapatkan arti khusus. Di ERE, mereka adalah metakarakter langsung.

### Kelas Karakter POSIX

POSIX mendefinisikan **character classes** yang portabel:

| Kelas | Arti |
|-------|------|
| `[[:alpha:]]` | Huruf |
| `[[:digit:]]` | Digit |
| `[[:alnum:]]` | Huruf atau digit |
| `[[:space:]]` | Whitespace |
| `[[:upper:]]` | Huruf besar |
| `[[:lower:]]` | Huruf kecil |
| `[[:punct:]]` | Tanda baca |
| `[[:blank:]]` | Spasi atau tab |
| `[[:cntrl:]]` | Karakter kontrol |
| `[[:graph:]]` | Karakter yang dapat dicetak (kecuali spasi) |
| `[[:print:]]` | Karakter yang dapat dicetak (termasuk spasi) |
| `[[:xdigit:]]` | Digit heksadesimal |

**Gunakan kelas ini alih-alih `[a-z]`** untuk portabilitas lintas locale.

### Contoh Regex

**BRE:**

```sh
grep "^error" log.txt        # baris dimulai dengan "error"
grep "error$" log.txt        # baris diakhiri "error"
grep "[0-9]\{3\}" log.txt    # tiga digit
grep "colou\?r" log.txt      # "color" atau "colour"
grep "cat\|dog" log.txt      # "cat" atau "dog"
```

**ERE:**

```sh
grep -E "^error" log.txt
grep -E "error$" log.txt
grep -E "[0-9]{3}" log.txt
grep -E "colou?r" log.txt
grep -E "cat|dog" log.txt
```

### Grup dan Backreference

**BRE:**

```sh
echo "2024-01-15" | sed 's/\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\)/\3\/\2\/\1/'
```

Output:

```
15/01/2024
```

Penjelasan:

- `\(...\)` – Grup penangkapan.
- `\1`, `\2`, `\3` – Backreference ke grup.
- `\{4\}` – Kuantifier: tepat 4 kali.

**ERE:**

```sh
echo "2024-01-15" | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})/\3\/\2\/\1/'
```

### Jebakan Regex

1. **`.` cocok dengan apa pun, termasuk yang tidak Anda inginkan:**
   ```sh
   grep "1.5" file.txt   # Cocok dengan "1.5", "125", "1a5"
   grep "1\.5" file.txt  # Hanya "1.5"
   ```

2. **`*` mengulangi karakter sebelumnya, bukan "apa pun":**
   ```sh
   grep "*.txt" file.txt   # Salah! Cocok dengan nol atau lebih dari karakter sebelumnya
   grep ".*\.txt" file.txt # Benar: apa pun diikuti .txt
   ```

3. **`^` dan `$` adalah anchor, bukan literal:**
   ```sh
   grep "^abc" file.txt   # Baris dimulai dengan "abc"
   grep "\^abc" file.txt  # Literal "^abc"
   ```

4. **Greedy matching:** Regex POSIX bersifat **greedy** — mencocokkan sebanyak mungkin.
   ```sh
   echo "<a><b>" | sed 's/<.*>//'    # Output: (kosong)
   echo "<a><b>" | sed 's/<[^>]*>//g' # Output: (kosong, tapi per grup)
   ```
   Untuk non-greedy, POSIX tidak mendukung. Gunakan trik dengan kelas negasi.

---

## 3.3.4 `grep` — Pencarian Pola

`grep` adalah alat pencarian teks paling fundamental. Kita sudah menyinggungnya di Level 1. Sekarang kita perdalam.

### Sintaks Lengkap

```sh
grep [opsi] pola [file...]
```

### Opsi Penting

| Opsi | Arti | POSIX |
|------|------|-------|
| `-i` | Abaikan case | ✅ |
| `-v` | Balik (tidak cocok) | ✅ |
| `-c` | Hitung kecocokan | ✅ |
| `-n` | Tampilkan nomor baris | ✅ |
| `-l` | Tampilkan nama file saja | ✅ |
| `-h` | Sembunyikan nama file | ✅ |
| `-r` | Rekursif | ❌ |
| `-E` | ERE | ✅ |
| `-F` | Fixed string | ✅ |
| `-w` | Cocokkan kata utuh | ❌ |
| `-x` | Cocokkan seluruh baris | ✅ |
| `-o` | Hanya bagian yang cocok | ❌ |
| `-q` | Quiet (hanya exit status) | ✅ |
| `-A n` | Tampilkan n baris setelah | ❌ |
| `-B n` | Tampilkan n baris sebelum | ❌ |
| `-C n` | Tampilkan n baris sekitar | ❌ |
| `--` | Akhir opsi | ✅ |

### Contoh 1: Mencari dengan Konteks

```sh
grep -C 2 "ERROR" log.txt
```

Penjelasan:

- `-C 2` – Tampilkan 2 baris sebelum dan sesudah kecocokan.
- **Tidak POSIX.** Ekstensi GNU. Untuk portabilitas, gunakan `awk`.

### Contoh 2: Mencari Kata Utuh

```sh
grep -w "error" log.txt
```

Penjelasan:

- `-w` – **Word boundary**. Cocok hanya jika "error" adalah kata utuh.
- "error" cocok, "errors" tidak.
- **Tidak POSIX.** Alternatif POSIX:

```sh
grep -E "(^|[^[:alnum:]_])error([^[:alnum:]_]|$)" log.txt
```

Penjelasan:

- `(^|[^[:alnum:]_])` – Awal baris atau karakter non-alfanumerik/underscore.
- `error` – Kata yang dicari.
- `([^[:alnum:]_]|$)` – Karakter non-alfanumerik/underscore atau akhir baris.

### Contoh 3: Mencari Seluruh Baris

```sh
grep -x "error" log.txt
```

Penjelasan:

- `-x` – Cocok hanya jika seluruh baris sama dengan pola.
- Cocok dengan baris yang isinya tepat "error".

### Contoh 4: Hanya Bagian yang Cocok

```sh
grep -o "[0-9]\{3\}" log.txt
```

Penjelasan:

- `-o` – **Only matching**. Tampilkan hanya bagian yang cocok, bukan seluruh baris.
- `[0-9]\{3\}` – Tiga digit.
- **Tidak POSIX.** Alternatif POSIX: gunakan `sed` atau `awk`.

### Contoh 5: Mencari Banyak Pola

```sh
grep -E "error|warning|critical" log.txt
```

Penjelasan:

- `-E` – ERE.
- `|` – Alternasi.
- Cocok dengan salah satu dari tiga kata.

### Contoh 6: Mencari File

```sh
grep -l "TODO" *.sh
```

Penjelasan:

- `-l` – **List**. Tampilkan hanya nama file yang mengandung pola.
- Berguna untuk mencari file tertentu.

```sh
grep -L "TODO" *.sh
```

Penjelasan:

- `-L` – **List files without match**. Tampilkan file yang **tidak** mengandung pola.
- **Tidak POSIX.** Ekstensi GNU.

### Contoh 7: Fixed String

```sh
grep -F "a.b.c" file.txt
```

Penjelasan:

- `-F` – **Fixed**. Perlakukan pola sebagai string literal, bukan regex.
- `.` tidak dianggap metakarakter.
- Lebih cepat untuk string literal.

### Contoh 8: Mencari dari Stdin

```sh
ps aux | grep "[p]ython"
```

Penjelasan:

- `[p]ython` – Trik klasik untuk menghindari `grep` mencocokkan dirinya sendiri.
- Pola `[p]ython` cocok dengan "python", tetapi bukan string "[p]ython".
- Karena `grep` sendiri memiliki argumen `[p]ython`, ia tidak cocok dengan dirinya sendiri.

### Contoh 9: Exit Status `grep`

```sh
if grep -q "error" log.txt; then
    echo "Ada error"
else
    echo "Tidak ada error"
fi
```

Penjelasan:

- `-q` – Quiet. Tidak mencetak apa pun, hanya exit status.
- `0` – Ada kecocokan.
- `1` – Tidak ada kecocokan.
- `2` – Error (file tidak ada, dll).

### Contoh 10: Menghitung dengan `-c`

```sh
grep -c "ERROR" log.txt
```

Penjelasan:

- `-c` – Count. Menghitung **baris** yang cocok, bukan jumlah kecocokan.
- Jika satu baris mengandung dua "ERROR", tetap dihitung satu.

### Contoh 11: Negasi

```sh
grep -v "^#" config.txt
```

Penjelasan:

- `-v` – Invert. Tampilkan baris yang **tidak** cocok.
- `^#` – Baris dimulai dengan `#`.
- Hasil: semua baris kecuali komentar.

### Contoh 12: Beberapa File

```sh
grep "error" *.log
```

Penjelasan:

- Setiap baris output diawali nama file: `file.log:baris yang cocok`.
- Gunakan `-h` untuk menyembunyikan nama file.

### Jebakan `grep`

1. **Pola dimulai `-`:** Gunakan `--` atau `-e`:
   ```sh
   grep -- "-error" file.txt
   grep -e "-error" file.txt
   ```

2. **BRE vs ERE:** `grep` default BRE. Untuk ERE, gunakan `-E`.

3. **Locale:** `[a-z]` bisa mencakup huruf beraksen di beberapa locale. Gunakan `[[:lower:]]` untuk portabilitas.

4. **Performa:** `grep` pada file besar bisa lambat. Gunakan `LC_ALL=C` untuk mempercepat:
   ```sh
   LC_ALL=C grep "pattern" file.txt
   ```
   Penjelasan: `LC_ALL=C` menonaktifkan pemrosesan multibyte, membuat `grep` lebih cepat.

---

## 3.3.5 `sed` — Stream Editor

`sed` adalah editor aliran yang memproses teks baris per baris. Ini adalah alat yang sangat kuat untuk substitusi, penghapusan, dan transformasi.

### Sintaks Dasar

```sh
sed [opsi] 'perintah' [file...]
```

Penjelasan:

- `sed` – Stream editor.
- `'perintah'` – Perintah sed. Dikutip untuk melindungi dari shell.
- `file...` – File input. Jika tidak ada, baca dari stdin.

### Substitusi: `s/pola/pengganti/flags`

```sh
sed 's/lama/baru/' file.txt
```

Penjelasan:

- `s` – **Substitute**.
- `/lama/` – Pola yang dicari.
- `/baru/` – Pengganti.
- `/` – Delimiter. Bisa diganti dengan karakter lain jika pola mengandung `/`.
- Secara default, hanya mengganti **kemunculan pertama** per baris.

### Flags pada `s`

| Flag | Arti |
|------|------|
| `g` | Global — ganti semua kemunculan |
| `p` | Print — cetak baris jika substitusi terjadi |
| `n` | Ganti kemunculan ke-n |
| `i` | Case-insensitive (GNU, tidak POSIX) |

### Contoh 1: Ganti Semua

```sh
sed 's/error/ERROR/g' log.txt
```

Penjelasan:

- `g` – Global. Ganti semua kemunculan "error" di setiap baris.

### Contoh 2: Delimiter Alternatif

```sh
sed 's|/usr/local|/opt|g' file.txt
```

Penjelasan:

- `|` – Delimiter alternatif. Berguna jika pola mengandung `/`.
- Mengganti `/usr/local` menjadi `/opt`.

### Contoh 3: Menghapus Baris

```sh
sed '/^#/d' config.txt
```

Penjelasan:

- `/^#/` – Alamat: baris yang dimulai dengan `#`.
- `d` – **Delete**. Hapus baris.
- Hasil: komentar dihapus.

### Contoh 4: Mencetak Baris Tertentu

```sh
sed -n '5,10p' file.txt
```

Penjelasan:

- `-n` – **No auto-print**. Secara default, sed mencetak setiap baris. `-n` menonaktifkan ini.
- `5,10p` – Cetak baris 5 hingga 10.
- `p` – Print.

### Contoh 5: Alamat dengan Pola

```sh
sed -n '/error/p' log.txt
```

Penjelasan:

- `/error/` – Alamat: baris yang mengandung "error".
- `p` – Print.
- Hasil: hanya baris dengan "error".

### Contoh 6: Multiple Commands

```sh
sed -e 's/foo/bar/' -e 's/baz/qux/' file.txt
```

Penjelasan:

- `-e` – **Expression**. Setiap `-e` adalah perintah terpisah.
- Dua substitusi dijalankan berurutan.

Atau dalam satu string:

```sh
sed 's/foo/bar/; s/baz/qux/' file.txt
```

Penjelasan:

- `;` – Pemisah perintah dalam satu string.

### Contoh 7: Substitusi dengan Backreference

```sh
sed 's/\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\)/\3\/\2\/\1/' file.txt
```

Penjelasan:

- `\(...\)` – Grup penangkapan (BRE).
- `\1`, `\2`, `\3` – Backreference.
- Mengubah `YYYY-MM-DD` menjadi `DD/MM/YYYY`.

### Contoh 8: Insert dan Append

```sh
sed '/pattern/i\
Baris sebelum' file.txt
```

Penjelasan:

- `i\` – **Insert**. Menyisipkan baris sebelum baris yang cocok.
- `\` di akhir baris `i` untuk melanjutkan ke baris berikutnya.

```sh
sed '/pattern/a\
Baris sesudah' file.txt
```

Penjelasan:

- `a\` – **Append**. Menyisipkan baris setelah baris yang cocok.

### Contoh 9: Change

```sh
sed '/pattern/c\
Baris pengganti' file.txt
```

Penjelasan:

- `c\` – **Change**. Mengganti seluruh baris yang cocok dengan teks baru.

### Contoh 10: Hold Space

`sed` memiliki dua buffer: **pattern space** (baris saat ini) dan **hold space** (penyimpanan sementara).

| Perintah | Arti |
|----------|------|
| `h` | Copy pattern space ke hold space |
| `H` | Append pattern space ke hold space |
| `g` | Copy hold space ke pattern space |
| `G` | Append hold space ke pattern space |
| `x` | Tukar pattern space dan hold space |

Contoh: Membalik urutan baris

```sh
sed -n '1!G;h;$p' file.txt
```

Penjelasan:

- `1!G` – Untuk semua baris kecuali baris pertama, append hold space ke pattern space.
- `h` – Copy pattern space ke hold space.
- `$p` – Cetak pattern space di baris terakhir.
- Hasil: baris terbalik.

### Contoh 11: Menggunakan `sed` sebagai Filter

```sh
echo "hello world" | sed 's/world/posix/'
```

Output:

```
hello posix
```

### Contoh 12: Substitusi Case-Insensitive (GNU)

```sh
sed 's/error/ERROR/gi' log.txt
```

Penjelasan:

- `i` – Case-insensitive.
- **Tidak POSIX.** Untuk portabilitas, gunakan `[Ee][Rr][Rr][Oo][Rr]`.

### Contoh 13: Menghapus Baris Kosong

```sh
sed '/^$/d' file.txt
```

Penjelasan:

- `^$` – Baris kosong (awal diikuti akhir).
- `d` – Hapus.

### Contoh 14: Menghapus Spasi di Awal/Akhir

```sh
sed 's/^[[:space:]]*//;s/[[:space:]]*$//' file.txt
```

Penjelasan:

- `^[[:space:]]*` – Spasi di awal.
- `[[:space:]]*$` – Spasi di akhir.
- Dua substitusi dipisahkan `;`.

### Jebakan `sed`

1. **Delimiter `/` dalam pola:** Gunakan delimiter lain.
   ```sh
   sed 's|/path/to|/new/path|' file.txt
   ```

2. **`sed` memproses baris per baris:** Tidak bisa mencocokkan pola lintas baris tanpa `N` atau `-z`.

3. **`sed -i` (in-place):** **Tidak POSIX.** Untuk edit di tempat portabel:
   ```sh
   sed 's/foo/bar/' file.txt > file.tmp && mv file.tmp file.txt
   ```

4. **Greedy matching:** Sama seperti regex lainnya.

---

## 3.3.6 `awk` — Pemrosesan Kolom

`awk` adalah bahasa pemrograman untuk pemrosesan teks. Ia memproses input baris per baris, memecah setiap baris menjadi field, dan menjalankan **pattern-action**.

### Sintaks Dasar

```sh
awk 'pattern { action }' file...
```

Penjelasan:

- `pattern` – Kondisi yang harus dipenuhi. Jika kosong, berlaku untuk semua baris.
- `{ action }` – Blok kode yang dijalankan.
- Jika `pattern` kosong, action dijalankan untuk semua baris.
- Jika `action` kosong, baris yang cocok dicetak.

### Field dan Variabel

| Variabel | Arti |
|----------|------|
| `$0` | Seluruh baris |
| `$1`, `$2`, ... | Field ke-1, ke-2, dst. |
| `NF` | Number of Fields (jumlah field) |
| `NR` | Number of Records (nomor baris saat ini) |
| `FNR` | File Number of Records (nomor baris per file) |
| `FS` | Field Separator (default: whitespace) |
| `OFS` | Output Field Separator (default: spasi) |
| `RS` | Record Separator (default: newline) |
| `ORS` | Output Record Separator (default: newline) |
| `FILENAME` | Nama file saat ini |

### Contoh 1: Cetak Kolom

```sh
awk '{ print $1 }' file.txt
```

Penjelasan:

- `{ print $1 }` – Cetak field pertama setiap baris.
- Field dipisahkan whitespace (spasi/tab) secara default.

### Contoh 2: Cetak Beberapa Kolom

```sh
awk '{ print $1, $3 }' file.txt
```

Penjelasan:

- `print $1, $3` – Cetak field 1 dan 3, dipisahkan `OFS` (default spasi).

### Contoh 3: Mengubah Field Separator

```sh
awk -F: '{ print $1 }' /etc/passwd
```

Penjelasan:

- `-F:` – Field separator adalah `:`.
- `{ print $1 }` – Cetak username.

Alternatif:

```sh
awk 'BEGIN { FS=":" } { print $1 }' /etc/passwd
```

### Contoh 4: Pattern-Action

```sh
awk '/error/ { print $0 }' log.txt
```

Penjelasan:

- `/error/` – Pattern: baris yang mengandung "error".
- `{ print $0 }` – Action: cetak seluruh baris.
- `$0` bisa dihilangkan: `print` saja.

### Contoh 5: Kondisi Numerik

```sh
awk '$3 > 100 { print $1, $3 }' data.txt
```

Penjelasan:

- `$3 > 100` – Pattern: field ke-3 lebih besar dari 100.
- Action: cetak field 1 dan 3.

### Contoh 6: BEGIN dan END

```sh
awk 'BEGIN { print "Mulai" } { print $0 } END { print "Selesai" }' file.txt
```

Penjelasan:

- `BEGIN { ... }` – Dijalankan **sebelum** memproses input.
- `{ ... }` – Dijalankan untuk setiap baris.
- `END { ... }` – Dijalankan **setelah** semua input diproses.

### Contoh 7: Menghitung Baris

```sh
awk 'END { print NR }' file.txt
```

Penjelasan:

- `NR` – Jumlah record (baris) yang diproses.
- `END` – Cetak setelah selesai.

### Contoh 8: Menjumlahkan Kolom

```sh
awk '{ total += $1 } END { print total }' angka.txt
```

Penjelasan:

- `total += $1` – Tambahkan field 1 ke variabel `total`.
- `END { print total }` – Cetak total setelah selesai.

### Contoh 9: Rata-Rata

```sh
awk '{ total += $1 } END { print total / NR }' angka.txt
```

Penjelasan:

- `total / NR` – Rata-rata.
- `NR` – Jumlah baris.

### Contoh 10: Format Output

```sh
awk '{ printf "%-10s %5d\n", $1, $2 }' data.txt
```

Penjelasan:

- `printf` – Format output.
- `%-10s` – String, lebar 10, rata kiri.
- `%5d` – Integer, lebar 5.
- `\n` – Newline.

### Contoh 11: Filter dan Transformasi

```sh
awk -F: '$3 >= 1000 { print $1, $3 }' /etc/passwd
```

Penjelasan:

- `-F:` – Separator `:`.
- `$3 >= 1000` – UID >= 1000 (biasanya user biasa).
- Cetak username dan UID.

### Contoh 12: Menggabungkan Field

```sh
awk '{ print $1 "-" $2 }' data.txt
```

Penjelasan:

- `$1 "-" $2` – Gabungkan field 1, tanda hubung, dan field 2.

### Contoh 13: Menghitung Frekuensi

```sh
awk '{ count[$1]++ } END { for (k in count) print k, count[k] }' data.txt
```

Penjelasan:

- `count[$1]++` – Array asosiatif. Increment counter untuk field 1.
- `END { for (k in count) ... }` – Iterasi semua kunci.
- Cetak kunci dan jumlahnya.

### Contoh 14: Menghapus Duplikat Berurutan

```sh
awk '!seen[$0]++' file.txt
```

Penjelasan:

- `seen[$0]++` – Increment counter untuk seluruh baris.
- `!seen[$0]` – True jika counter sebelumnya 0 (pertama kali).
- Action default: cetak.
- Hasil: hanya baris unik (yang pertama).

### Contoh 15: Multi-File

```sh
awk 'FNR == 1 { print "File: " FILENAME } { print }' file1.txt file2.txt
```

Penjelasan:

- `FNR == 1` – Baris pertama setiap file.
- `FILENAME` – Nama file saat ini.
- Cetak header sebelum isi setiap file.

### Contoh 16: Substitusi dengan `gsub`/`sub`

```sh
awk '{ gsub(/error/, "ERROR"); print }' log.txt
```

Penjelasan:

- `gsub(/error/, "ERROR")` – **Global substitute**. Ganti semua "error" dengan "ERROR".
- `sub` – Hanya kemunculan pertama.
- Mengubah `$0` secara langsung.

### Contoh 17: Menggunakan Variabel Shell

```sh
pola="error"
awk -v p="$pola" '$0 ~ p { print }' log.txt
```

Penjelasan:

- `-v p="$pola"` – Set variabel awk `p` dari variabel shell.
- `$0 ~ p` – Cocokkan `$0` dengan pola `p`.
- `~` – Operator match.

### Contoh 18: Split

```sh
awk '{ n = split($0, arr, ","); for (i = 1; i <= n; i++) print arr[i] }' data.csv
```

Penjelasan:

- `split($0, arr, ",")` – Pecah `$0` berdasarkan `,` ke array `arr`.
- Mengembalikan jumlah elemen.
- Loop cetak setiap elemen.

### Contoh 19: Fungsi Bawaan

| Fungsi | Arti |
|--------|------|
| `length(s)` | Panjang string |
| `substr(s, m, n)` | Substring dari m, panjang n |
| `index(s, t)` | Posisi t dalam s |
| `tolower(s)` | Huruf kecil |
| `toupper(s)` | Huruf besar |
| `gsub(r, s)` | Substitusi global |
| `sub(r, s)` | Substitusi pertama |
| `match(s, r)` | Posisi match |
| `split(s, a, fs)` | Split |
| `sprintf(fmt, ...)` | Format |

### Contoh 20: `substr`

```sh
awk '{ print substr($0, 1, 10) }' file.txt
```

Penjelasan:

- `substr($0, 1, 10)` – 10 karakter pertama dari setiap baris.

### Jebakan `awk`

1. **`$0` vs `$1`:** `$0` seluruh baris, `$1` field pertama.
2. **Variabel shell dalam awk:** Gunakan `-v` atau kutip ganda dengan escape.
3. **`print` vs `printf`:** `print` menambahkan newline; `printf` tidak.
4. **FS diubah setelah input:** Set `FS` di `BEGIN` atau dengan `-F`.
5. **Locale:** Sama seperti `grep`, gunakan `LC_ALL=C` untuk performa.

---

## 3.3.7 Memilih Alat yang Tepat

| Tugas | Alat Terbaik |
|-------|--------------|
| Cari pola sederhana | `grep` |
| Cari dan ganti | `sed` |
| Proses kolom | `awk` |
| Manipulasi string sederhana | Ekspansi parameter |
| Filter baris | `grep` |
| Transformasi kompleks | `awk` |
| Substitusi multi-baris | `awk` atau `perl` |
| Hitung frekuensi | `awk` |
| Format output | `awk` |
| Hapus duplikat | `sort -u` atau `awk` |

### Contoh Keputusan

**Mencari "error" di file:**

```sh
grep "error" file.txt
```

**Mengganti "error" dengan "ERROR":**

```sh
sed 's/error/ERROR/g' file.txt
```

**Menghitung rata-rata kolom ke-3:**

```sh
awk '{ total += $3 } END { print total / NR }' data.txt
```

**Mengekstrak username dari `/etc/passwd`:**

```sh
cut -d: -f1 /etc/passwd
```

**Mengekstrak username dengan UID >= 1000:**

```sh
awk -F: '$3 >= 1000 { print $1 }' /etc/passwd
```

---

## 3.3.8 Contoh Skrip Lengkap

### Skrip 1: Analisis Log dengan `grep`, `sed`, `awk`

```sh
#!/bin/sh
# Nama: analisis.sh
# Tujuan: Menganalisis file log

LOG="${1:?Penggunaan: $0 file_log}"

if [ ! -r "$LOG" ]; then
    echo "Error: $LOG tidak dapat dibaca." >&2
    exit 1
fi

echo "=== Statistik ==="
echo "Total baris: $(wc -l < "$LOG")"
echo "Error: $(grep -c "ERROR" "$LOG")"
echo "Warning: $(grep -c "WARN" "$LOG")"
echo

echo "=== 5 Error Terakhir ==="
grep "ERROR" "$LOG" | tail -n 5
echo

echo "=== Jam dengan Error Terbanyak ==="
grep "ERROR" "$LOG" | \
    sed 's/.*\[\([0-9][0-9]\):.*/\1/' | \
    sort | uniq -c | sort -rn | head -n 5
```

Bedah:

- `grep -c` – Hitung.
- `sed 's/.*\[\([0-9][0-9]\):.*/\1/'` – Ekstrak jam dari format `[HH:MM:SS]`.
- `sort | uniq -c | sort -rn` – Hitung dan urutkan.

### Skrip 2: Konversi CSV ke Format Lain

```sh
#!/bin/sh
# Nama: csv_to_tsv.sh
# Tujuan: Konversi CSV ke TSV

CSV="${1:?Penggunaan: $0 file.csv}"

if [ ! -r "$CSV" ]; then
    echo "Error: $CSV tidak dapat dibaca." >&2
    exit 1
fi

awk -F, 'BEGIN { OFS="\t" } { $1=$1; print }' "$CSV"
```

Bedah:

- `-F,` – Input separator `,`.
- `BEGIN { OFS="\t" }` – Output separator tab.
- `$1=$1` – Memaksa awk membangun ulang `$0` dengan OFS baru.
- `print` – Cetak.

### Skrip 3: Validasi Email

```sh
#!/bin/sh
# Nama: validasi_email.sh
# Tujuan: Validasi format email sederhana

validasi_email() {
    echo "$1" | grep -E -q '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
}

if [ $# -ne 1 ]; then
    echo "Penggunaan: $0 email" >&2
    exit 1
fi

if validasi_email "$1"; then
    echo "Email valid: $1"
else
    echo "Email tidak valid: $1" >&2
    exit 1
fi
```

Bedah:

- `grep -E -q` – ERE, quiet.
- `^[A-Za-z0-9._%+-]+` – Satu atau lebih karakter lokal.
- `@` – Literal.
- `[A-Za-z0-9.-]+` – Domain.
- `\.` – Titik literal.
- `[A-Za-z]{2,}$` – TLD minimal 2 huruf.

### Skrip 4: Laporan dengan `awk`

```sh
#!/bin/sh
# Nama: laporan.sh
# Tujuan: Laporan penjualan dari CSV

CSV="${1:?Penggunaan: $0 data.csv}"

awk -F, '
BEGIN {
    printf "%-15s %10s %10s\n", "Produk", "Jumlah", "Total"
    printf "%-15s %10s %10s\n", "------", "------", "-----"
}
NR > 1 {
    total[$1] += $2 * $3
    jumlah[$1] += $2
}
END {
    for (produk in total) {
        printf "%-15s %10d %10.2f\n", produk, jumlah[produk], total[produk]
    }
}
' "$CSV"
```

Bedah:

- `BEGIN` – Cetak header.
- `NR > 1` – Skip header CSV.
- `total[$1] += $2 * $3` – Akumulasi total per produk.
- `END` – Cetak laporan.

### Skrip 5: Pencarian dan Ganti Multi-File

```sh
#!/bin/sh
# Nama: cari_ganti.sh
# Tujuan: Cari dan ganti di banyak file

POLA="${1:?Penggunaan: $0 pola pengganti [direktori]}"
PENGGANTI="${2:?Penggunaan: $0 pola pengganti [direktori]}"
DIR="${3:-.}"

if [ ! -d "$DIR" ]; then
    echo "Error: $DIR bukan direktori." >&2
    exit 1
fi

find "$DIR" -type f | while IFS= read -r file; do
    if grep -q "$POLA" "$file" 2>/dev/null; then
        sed "s/$POLA/$PENGGANTI/g" "$file" > "$file.tmp" && \
            mv "$file.tmp" "$file"
        echo "Diubah: $file"
    fi
done
```

Bedah:

- `grep -q` – Cek apakah pola ada.
- `sed "s/$POLA/$PENGGANTI/g"` – Substitusi.
- `> "$file.tmp" && mv` – Edit di tempat secara portabel.

**Jebakan:** Pola dan pengganti dengan `/` bisa merusak `sed`. Gunakan delimiter lain atau escape.

---

## 3.3.9 Latihan

1. **Globbing:**
   - Buat file: `a.txt`, `b.txt`, `ab.txt`, `1.txt`.
   - Gunakan `echo` dengan pola `?.txt`, `[ab].txt`, `[!0-9].txt`.
   - Jelaskan hasilnya.

2. **Ekspansi Parameter:**
   - Berikan path `/home/budi/dokumen/laporan.tar.gz`.
   - Ekstrak direktori, nama file, ekstensi, dan nama tanpa ekstensi.
   - Gunakan `${var#}`, `${var##}`, `${var%}`, `${var%%}`.

3. **Regex BRE vs ERE:**
   - Gunakan `grep` untuk mencari baris yang mengandung tiga digit.
   - Tulis pola BRE dan ERE.
   - Bandingkan.

4. **`grep` dengan Konteks:**
   - Buat file log dengan baris "ERROR" dan sekitarnya.
   - Cari "ERROR" dengan `grep -C 2`.

5. **`sed` Substitusi:**
   - Ganti semua "foo" dengan "bar" di file.
   - Ganti hanya kemunculan pertama.
   - Gunakan delimiter alternatif untuk path.

6. **`sed` Hapus:**
   - Hapus semua baris komentar (`#`).
   - Hapus semua baris kosong.
   - Hapus baris 5–10.

7. **`awk` Kolom:**
   - Buat file CSV dengan nama, umur, kota.
   - Cetak nama dan kota saja.
   - Cetak yang umurnya > 30.
   - Hitung rata-rata umur.

8. **`awk` Frekuensi:**
   - Hitung frekuensi setiap kata di file teks.
   - Urutkan dari yang paling sering.

9. **`awk` Laporan:**
   - Buat file penjualan dengan produk, jumlah, harga.
   - Hitung total per produk.
   - Format output dengan `printf`.

10. **Pipeline Kombinasi:**
    - Ekstrak semua alamat email dari file.
    - Hitung frekuensinya.
    - Urutkan.

---

## 3.3.10 Ringkasan Materi 3

- **Globbing** adalah ekspansi wildcard oleh shell: `*`, `?`, `[ ]`, `[! ]`, `[[:class:]]`.
- **Globbing ≠ Regex.** `*` di globbing berarti "apa pun"; di regex berarti "ulangi".
- **Ekspansi parameter** `${var#pattern}`, `${var##pattern}`, `${var%pattern}`, `${var%%pattern}` untuk manipulasi string tanpa perintah eksternal.
- **POSIX Regex** memiliki dua jenis: BRE (Basic) dan ERE (Extended). ERE lebih mudah dibaca.
- **Character classes** `[[:alpha:]]`, `[[:digit:]]`, dll. untuk portabilitas.
- **`grep`** untuk pencarian pola. Opsi penting: `-i`, `-v`, `-c`, `-n`, `-E`, `-F`, `-q`.
- **`sed`** untuk substitusi, penghapusan, dan transformasi. Perintah penting: `s`, `d`, `p`, `i`, `a`, `c`.
- **`awk`** untuk pemrosesan kolom. Variabel penting: `$0`, `$1`, `NF`, `NR`, `FS`, `OFS`. Blok: `BEGIN`, action, `END`.
- **Pilih alat yang tepat:** `grep` untuk cari, `sed` untuk ganti, `awk` untuk kolom dan laporan.
- **Jebakan:** delimiter `sed`, greedy matching, locale, `sed -i` tidak POSIX.

---

## 📌 Selanjutnya

Materi 3 Level 3 selesai. Anda sekarang menguasai pattern matching dan text processing secara mendalam.

Berikutnya adalah **Materi 4: Aritmatika dalam Shell** — ini adalah **materi terakhir** dari Level 3. Kita akan membahas:

- `$(( ))` — arithmetic expansion.
- Operator aritmatika lengkap.
- `expr` — alternatif portabel.
- `let` — tidak POSIX.
- Floating-point dengan `awk` dan `bc`.
- Bitwise operations.
- Perbandingan numerik dalam `[ ]` vs `$(( ))`.
- Jebakan overflow dan pembagian dengan nol.

## Materi 4: Aritmatika dalam Shell

> **Catatan:** Ini adalah **materi keempat** dan **terakhir** dari Level 3, sesuai kurikulum yang sudah ditetapkan. Kita akan membahas aritmatika di shell dari yang paling dasar hingga teknik lanjutan: `$(( ))`, operator lengkap, `expr`, `let`, floating-point dengan `awk` dan `bc`, bitwise, serta jebakan overflow dan pembagian dengan nol. Setelah materi ini, Anda akan mampu melakukan perhitungan numerik dengan presisi dan portabilitas.

---

## 🎯 Tujuan Materi 4

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Menguasai **arithmetic expansion** `$(( ))` secara mendalam.
2. Memahami semua operator aritmatika yang didukung POSIX.
3. Menggunakan **`expr`** sebagai alternatif portabel untuk aritmatika dan string.
4. Memahami **`let`** dan mengapa tidak POSIX.
5. Melakukan **floating-point** dengan `awk` dan `bc`.
6. Menguasai **bitwise operations**.
7. Memahami **perbandingan numerik** di `[ ]` vs `$(( ))`.
8. Menghindari **overflow** dan **pembagian dengan nol**.
9. Menulis skrip yang melakukan perhitungan kompleks dengan aman.
10. Memilih alat yang tepat: `$(( ))`, `expr`, `awk`, atau `bc`.

---

## 3.4.1 Mengapa Aritmatika di Shell Itu Terbatas?

Shell dirancang untuk **memproses teks**, bukan untuk komputasi numerik. Keterbatasan utama:

1. **Hanya integer.** POSIX aritmatika hanya mendukung bilangan bulat. Tidak ada floating-point bawaan.
2. **Presisi terbatas.** Biasanya 64-bit, tetapi tergantung implementasi. Overflow bisa terjadi.
3. **Tidak ada tipe.** Semua nilai adalah string yang dikonversi ke integer saat diperlukan.
4. **Performa.** Shell bukan alat komputasi yang cepat; untuk perhitungan besar, gunakan `awk`.

Namun, untuk kebutuhan skrip sehari-hari (counter, indeks, perhitungan sederhana), aritmatika shell sudah cukup.

---

## 3.4.2 Arithmetic Expansion `$(( ))`

Ini adalah cara **paling modern dan direkomendasikan** untuk aritmatika di shell POSIX.

### Sintaks

```sh
hasil=$((ekspresi))
```

Penjelasan kata demi kata:

- `$((` – Pembuka arithmetic expansion.
- `ekspresi` – Ekspresi aritmatika integer.
- `))` – Penutup.
- Hasilnya adalah **string** representasi dari integer.

### Contoh 1: Penjumlahan

```sh
a=5
b=3
hasil=$((a + b))
echo "$hasil"
```

Output:

```
8
```

Penjelasan:

- `a=5` – Variabel `a` berisi string `"5"`.
- `b=3` – Variabel `b` berisi string `"3"`.
- `$((a + b))` – Shell mengonversi `a` dan `b` ke integer, menjumlahkan, dan mengembalikan `8`.
- `hasil` berisi string `"8"`.

### Contoh 2: Tanpa Variabel

```sh
echo $((5 + 3))
```

Output:

```
8
```

Penjelasan:

- Ekspresi literal langsung di dalam `$(( ))`.

### Contoh 3: Dalam String

```sh
a=10
echo "Nilai: $((a * 2))"
```

Output:

```
Nilai: 20
```

Penjelasan:

- Arithmetic expansion terjadi di dalam string.
- Hasilnya disisipkan ke string.

### Contoh 4: Assignment dengan Operator

```sh
i=0
i=$((i + 1))
echo "$i"    # 1
i=$((i + 1))
echo "$i"    # 2
```

Ini adalah pola counter klasik.

### Contoh 5: Nested Arithmetic

```sh
a=2
b=3
echo $(( (a + b) * 2 ))
```

Output:

```
10
```

Penjelasan:

- Tanda kurung `( )` untuk pengelompokan.
- Prioritas: kurung dulu, lalu perkalian.

---

## 3.4.3 Operator Aritmatika Lengkap

POSIX mendefinisikan operator berikut dalam `$(( ))`:

### Operator Aritmatika

| Operator | Arti | Contoh | Hasil |
|----------|------|--------|-------|
| `+` | Penjumlahan | `$((5 + 3))` | `8` |
| `-` | Pengurangan | `$((5 - 3))` | `2` |
| `*` | Perkalian | `$((5 * 3))` | `15` |
| `/` | Pembagian integer | `$((10 / 3))` | `3` |
| `%` | Modulo | `$((10 % 3))` | `1` |

### Operator Assignment

| Operator | Arti | Ekuivalen |
|----------|------|-----------|
| `=` | Assignment | `a = 5` |
| `+=` | Tambah dan assign | `a = a + 5` |
| `-=` | Kurang dan assign | `a = a - 5` |
| `*=` | Kali dan assign | `a = a * 5` |
| `/=` | Bagi dan assign | `a = a / 5` |
| `%=` | Modulo dan assign | `a = a % 5` |

Contoh:

```sh
i=10
i=$((i += 5))
echo "$i"    # 15

i=$((i -= 3))
echo "$i"    # 12

i=$((i *= 2))
echo "$i"    # 24
```

### Operator Perbandingan

| Operator | Arti |
|----------|------|
| `==` | Sama dengan |
| `!=` | Tidak sama |
| `<` | Kurang dari |
| `<=` | Kurang dari atau sama |
| `>` | Lebih dari |
| `>=` | Lebih dari atau sama |

Contoh:

```sh
a=5
b=3
echo $((a > b))    # 1 (true)
echo $((a < b))    # 0 (false)
echo $((a == 5))   # 1
```

Penjelasan:

- Dalam arithmetic expansion, **1 = true**, **0 = false**. Ini kebalikan dari exit status perintah!
- Berguna untuk ternary:

```sh
a=5
b=3
max=$((a > b ? a : b))
echo "$max"    # 5
```

### Operator Logika

| Operator | Arti |
|----------|------|
| `&&` | AND |
| `||` | OR |
| `!` | NOT |

Contoh:

```sh
echo $((1 && 1))    # 1
echo $((1 && 0))    # 0
echo $((1 || 0))    # 1
echo $((!0))        # 1
echo $((!1))        # 0
```

### Operator Bitwise

| Operator | Arti |
|----------|------|
| `&` | AND bitwise |
| `\|` | OR bitwise |
| `^` | XOR bitwise |
| `~` | NOT bitwise |
| `<<` | Left shift |
| `>>` | Right shift |

Contoh:

```sh
echo $((5 & 3))     # 1  (0101 & 0011 = 0001)
echo $((5 | 3))     # 7  (0101 | 0011 = 0111)
echo $((5 ^ 3))     # 6  (0101 ^ 0011 = 0110)
echo $((~5))        # -6 (bitwise NOT, komplemen dua)
echo $((5 << 1))    # 10 (0101 << 1 = 1010)
echo $((5 >> 1))    # 2  (0101 >> 1 = 0010)
```

### Operator Ternary

```sh
kondisi ? nilai_jika_benar : nilai_jika_salah
```

Contoh:

```sh
a=10
b=20
max=$((a > b ? a : b))
echo "$max"    # 20
```

### Prioritas Operator

Dari tertinggi ke terendah:

1. `( )` – Kurung
2. `!`, `~` – Unary NOT
3. `*`, `/`, `%` – Perkalian, pembagian, modulo
4. `+`, `-` – Penjumlahan, pengurangan
5. `<<`, `>>` – Shift
6. `<`, `<=`, `>`, `>=` – Perbandingan
7. `==`, `!=` – Kesetaraan
8. `&` – Bitwise AND
9. `^` – Bitwise XOR
10. `|` – Bitwise OR
11. `&&` – Logika AND
12. `||` – Logika OR
13. `? :` – Ternary
14. `=`, `+=`, dll. – Assignment

**Gunakan tanda kurung** untuk memperjelas dan menghindari kebingungan.

---

## 3.4.4 Variabel dalam Arithmetic Expansion

Anda bisa menggunakan variabel **tanpa** `$` di dalam `$(( ))`:

```sh
a=5
b=3
echo $((a + b))       # 8 (tanpa $)
echo $(($a + $b))     # 8 (dengan $)
```

Keduanya bekerja. Tanpa `$` lebih bersih dan menghindari ambiguitas.

### Jebakan: Nama Variabel vs String

```sh
a=5
b=3
echo $((a + b))    # 8
echo $((a + 1))    # 6
echo $((a + abc))  # 5 (abc dianggap variabel kosong = 0)
```

Penjelasan:

- `abc` tidak di-set, dianggap `0`.
- Ini bisa menyembunyikan bug. Selalu pastikan variabel di-set.

### Jebakan: Variabel dengan String Non-Numerik

```sh
a=hello
echo $((a + 1))
```

Output (bash):

```
bash: hello: syntax error: operand expected
```

Shell mencoba menafsirkan `hello` sebagai nama variabel, dan karena tidak ada, error.

Untuk aman, validasi:

```sh
case "$a" in
    ''|*[!0-9-]*) echo "Bukan angka" >&2; exit 1 ;;
esac
```

---

## 3.4.5 `expr` — Alternatif Portabel

`expr` adalah perintah eksternal POSIX untuk evaluasi ekspresi. Lebih lambat dari `$(( ))`, tetapi berguna untuk:
- Perbandingan string.
- Operasi yang memerlukan output sebagai exit status.

### Sintaks

```sh
expr argumen...
```

Setiap argumen dipisahkan spasi. Operator harus di-escape atau dikutip jika mengandung karakter shell.

### Contoh 1: Penjumlahan

```sh
hasil=$(expr 5 + 3)
echo "$hasil"    # 8
```

Penjelasan:

- `expr 5 + 3` – Menjalankan `expr` dengan tiga argumen: `5`, `+`, `3`.
- Output: `8`.

**Catatan:** Harus ada spasi di sekitar operator. `expr 5+3` akan error.

### Contoh 2: Perkalian (Perlu Escape)

```sh
hasil=$(expr 5 \* 3)
echo "$hasil"    # 15
```

Penjelasan:

- `*` adalah metakarakter shell. Harus di-escape: `\*`.
- Alternatif: kutip operator: `expr 5 '*' 3`.

### Contoh 3: Modulo

```sh
hasil=$(expr 10 % 3)
echo "$hasil"    # 1
```

### Contoh 4: Perbandingan Numerik

```sh
if expr 5 \> 3 > /dev/null; then
    echo "5 lebih besar"
fi
```

Penjelasan:

- `expr 5 \> 3` – Mengembalikan exit status `0` jika benar, `1` jika salah.
- Output `1` atau `0` bisa dibuang.
- **Catatan:** `>` harus di-escape, jika tidak dianggap redirection.

### Contoh 5: Perbandingan String

```sh
if expr "abc" = "abc" > /dev/null; then
    echo "Sama"
fi
```

Penjelasan:

- `=` untuk perbandingan string.

### Contoh 6: Panjang String

```sh
panjang=$(expr length "hello")
echo "$panjang"    # 5
```

Penjelasan:

- `length` – Fungsi `expr` untuk panjang string.
- **Tidak POSIX.** POSIX tidak mendefinisikan `length`. Gunakan `${#var}` sebagai gantinya.

### Contoh 7: Substring

```sh
sub=$(expr substr "hello world" 1 5)
echo "$sub"    # hello
```

Penjelasan:

- `substr string posisi panjang`.
- **Tidak POSIX.** Gunakan `cut` atau ekspansi parameter.

### Contoh 8: Pencarian Pola

```sh
hasil=$(expr "hello.txt" : '.*\.txt')
echo "$hasil"    # 9 (panjang yang cocok)
```

Penjelasan:

- `:` – Operator match.
- Mengembalikan panjang kecocokan atau `0`.
- Berguna untuk validasi.

**Contoh validasi angka:**

```sh
if expr "$1" : '[0-9][0-9]*$' > /dev/null; then
    echo "Angka valid"
fi
```

### Kapan Menggunakan `expr`?

- Ketika Anda perlu **exit status** dari perbandingan (untuk `if`).
- Ketika bekerja di lingkungan yang sangat terbatas (misalnya `sh` kuno).
- Untuk kompatibilitas maksimal.

### Kapan **Tidak** Menggunakan `expr`?

- Untuk aritmatika sederhana: `$(( ))` lebih cepat dan bersih.
- Untuk operasi string: ekspansi parameter lebih cepat.
- Untuk perhitungan besar: `awk` lebih cepat.

### Jebakan `expr`

1. **Operator harus di-escape:** `expr 5 \* 3`, bukan `expr 5 * 3`.
2. **Spasi wajib:** `expr 5+3` error.
3. **Exit status:** `expr` mengembalikan `1` jika hasil adalah `0` atau string kosong.
   ```sh
   expr 0
   echo "$?"    # 1 (karena hasil "0")
   ```
4. **Output bisa tercampur:** Selalu tangkap output dengan `$( )`.

---

## 3.4.6 `let` — Tidak POSIX

Bash dan ksh mendukung perintah `let`:

```sh
let "hasil = 5 + 3"
echo "$hasil"    # 8
```

Penjelasan:

- `let` – Menjalankan ekspresi aritmatika.
- Argumen dianggap ekspresi.
- **Tidak POSIX.** Jangan gunakan di skrip portabel.

Gunakan `$(( ))` sebagai gantinya.

---

## 3.4.7 Floating-Point dengan `awk`

POSIX aritmatika hanya integer. Untuk floating-point, gunakan `awk`.

### Contoh 1: Perhitungan Dasar

```sh
hasil=$(awk "BEGIN { print 3.14 * 2 }")
echo "$hasil"    # 6.28
```

Penjelasan:

- `awk "BEGIN { print ... }"` – Menjalankan `awk` tanpa input.
- `BEGIN` – Blok yang dijalankan sebelum memproses input.
- `print` – Mencetak hasil.
- Output ditangkap oleh `$( )`.

### Contoh 2: Presisi

```sh
hasil=$(awk "BEGIN { printf \"%.2f\n\", 10 / 3 }")
echo "$hasil"    # 3.33
```

Penjelasan:

- `printf "%.2f\n"` – Format floating-point dengan 2 desimal.
- `\n` – Newline.
- Backslash di-escape dalam kutip ganda.

### Contoh 3: Variabel dari Shell

```sh
a=10
b=3
hasil=$(awk -v a="$a" -v b="$b" "BEGIN { print a / b }")
echo "$hasil"    # 3.33333
```

Penjelasan:

- `-v a="$a"` – Set variabel awk `a` dari variabel shell.
- Ini adalah cara **aman** untuk meneruskan nilai ke `awk`.

**Jebakan:** Jangan interpolasi langsung ke string `awk`:

```sh
hasil=$(awk "BEGIN { print $a / $b }")    # ❌ Bisa injeksi
```

Jika `$a` berisi karakter khusus, bisa error atau berbahaya.

### Contoh 4: Perhitungan Kompleks

```sh
hasil=$(awk "BEGIN { printf \"%.4f\n\", (1 + 0.05) ^ 12 }")
echo "$hasil"    # 1.7959
```

Penjelasan:

- `^` – Operator pangkat di `awk`.
- Bunga majemuk 5% selama 12 periode.

### Contoh 5: Rata-Rata dari File

```sh
rata=$(awk '{ total += $1 } END { print total / NR }' angka.txt)
echo "Rata-rata: $rata"
```

Penjelasan:

- `total += $1` – Akumulasi field pertama.
- `NR` – Jumlah baris.
- `total / NR` – Rata-rata.

---

## 3.4.8 Floating-Point dengan `bc`

`bc` adalah kalkulator presisi arbitrer. Berguna ketika `awk` tidak cukup.

### Sintaks

```sh
echo "ekspresi" | bc
```

### Contoh 1: Perhitungan Dasar

```sh
hasil=$(echo "3.14 * 2" | bc)
echo "$hasil"    # 6.28
```

### Contoh 2: Menentukan Skala (Desimal)

```sh
hasil=$(echo "scale=2; 10 / 3" | bc)
echo "$hasil"    # 3.33
```

Penjelasan:

- `scale=2` – Set jumlah digit desimal ke 2.
- Default `bc` adalah integer (scale=0).

### Contoh 3: Pangkat

```sh
hasil=$(echo "2 ^ 10" | bc)
echo "$hasil"    # 1024
```

Penjelasan:

- `^` – Operator pangkat di `bc`.

### Contoh 4: Modulo

```sh
hasil=$(echo "10 % 3" | bc)
echo "$hasil"    # 1
```

### Contoh 5: Fungsi Matematika

`bc -l` memuat pustaka matematika:

```sh
hasil=$(echo "scale=4; s(1)" | bc -l)
echo "$hasil"    # 0.8414 (sinus 1 radian)
```

Penjelasan:

- `-l` – **Library**. Memuat fungsi `s` (sin), `c` (cos), `a` (arctan), `l` (ln), `e` (exp).
- `scale=4` – Presisi 4 desimal.

### Contoh 6: Akar Kuadrat

```sh
hasil=$(echo "scale=4; sqrt(2)" | bc -l)
echo "$hasil"    # 1.4142
```

### Perbandingan `awk` vs `bc`

| Aspek | `awk` | `bc` |
|-------|-------|------|
| Presisi | Double (terbatas) | Arbitrer |
| Kecepatan | Cepat | Sedang |
| Fungsi matematika | Terbatas | Lengkap dengan `-l` |
| Portabilitas | POSIX | POSIX |
| Kegunaan | Pemrosesan data | Kalkulasi presisi |

**Rekomendasi:** Gunakan `awk` untuk perhitungan sehari-hari; gunakan `bc` ketika butuh presisi tinggi atau fungsi matematika lanjutan.

---

## 3.4.9 Perbandingan Numerik: `[ ]` vs `$(( ))`

Ada dua cara membandingkan angka:

### Cara 1: `[ ]` (test)

```sh
if [ "$a" -gt "$b" ]; then
    echo "a > b"
fi
```

Penjelasan:

- `-gt`, `-lt`, `-eq`, `-ne`, `-ge`, `-le` – Operator numerik.
- Mengembalikan exit status `0` (true) atau `1` (false).
- Digunakan dalam `if`.

### Cara 2: `$(( ))`

```sh
if [ $((a > b)) -eq 1 ]; then
    echo "a > b"
fi
```

Penjelasan:

- `$((a > b))` mengembalikan `1` (true) atau `0` (false) **sebagai string**.
- Bandingkan dengan `1` untuk true.
- Lebih rumit; jarang digunakan.

### Perbedaan Penting

| Aspek | `[ ]` | `$(( ))` |
|-------|-------|----------|
| Return | Exit status | Integer (1/0) |
| True | Exit 0 | Nilai 1 |
| False | Exit non-zero | Nilai 0 |
| Penggunaan | `if [ ... ]` | `if [ $((...)) -eq 1 ]` |

**Rekomendasi:** Gunakan `[ ]` untuk perbandingan dalam `if`. Gunakan `$(( ))` untuk perhitungan.

### Contoh Kombinasi

```sh
a=10
b=20

# Perbandingan dengan [ ]
if [ "$a" -lt "$b" ]; then
    echo "$a < $b"
fi

# Perhitungan dengan $((
selisih=$((b - a))
echo "Selisih: $selisih"
```

---

## 3.4.10 Overflow dan Pembagian dengan Nol

### Overflow

Shell aritmatika biasanya menggunakan integer 64-bit (signed). Nilai maksimum:

```
9,223,372,036,854,775,807
```

Jika melebihi, terjadi **overflow** — nilai "berputar" ke negatif.

```sh
max=9223372036854775807
echo $((max + 1))
```

Output (bash):

```
-9223372036854775808
```

**Jebakan:** Shell tidak memberikan error. Hasilnya salah secara diam-diam.

**Solusi:**

- Gunakan `awk` untuk angka besar (double precision).
- Gunakan `bc` untuk presisi arbitrer.
- Periksa rentang sebelum operasi.

### Pembagian dengan Nol

```sh
echo $((10 / 0))
```

Output (bash):

```
bash: 10 / 0: division by 0 (error token is "0")
```

Error. Dalam skrip, ini akan menyebabkan exit non-zero.

**Solusi:** Validasi sebelum membagi:

```sh
if [ "$b" -eq 0 ]; then
    echo "Error: pembagian dengan nol" >&2
    exit 1
fi
hasil=$((a / b))
```

### Modulo dengan Nol

Sama seperti pembagian:

```sh
echo $((10 % 0))    # Error
```

---

## 3.4.11 Aritmatika dalam Loop

Pola yang sangat umum: menggunakan aritmatika untuk counter.

### Contoh 1: Counter Sederhana

```sh
i=0
while [ "$i" -lt 10 ]; do
    echo "Iterasi: $i"
    i=$((i + 1))
done
```

### Contoh 2: Total Akumulatif

```sh
total=0
for n in 1 2 3 4 5; do
    total=$((total + n))
done
echo "Total: $total"    # 15
```

### Contoh 3: Faktorial

```sh
n=5
hasil=1
i=1
while [ "$i" -le "$n" ]; do
    hasil=$((hasil * i))
    i=$((i + 1))
done
echo "$n! = $hasil"    # 120
```

### Contoh 4: Fibonacci

```sh
a=0
b=1
i=1
while [ "$i" -le 10 ]; do
    echo "$a"
    c=$((a + b))
    a=$b
    b=$c
    i=$((i + 1))
done
```

### Contoh 5: Deret Bilangan dengan `while`

```sh
i=1
while [ "$i" -le 100 ]; do
    if [ $((i % 3)) -eq 0 ]; then
        echo "$i habis dibagi 3"
    fi
    i=$((i + 1))
done
```

Penjelasan:

- `i % 3` – Modulo. Sisa bagi.
- `-eq 0` – Sama dengan nol.

---

## 3.4.12 Contoh Skrip Lengkap

### Skrip 1: Kalkulator Sederhana

```sh
#!/bin/sh
# Nama: kalkulator.sh
# Tujuan: Kalkulator aritmatika sederhana

if [ $# -ne 3 ]; then
    echo "Penggunaan: $0 angka1 operator angka2" >&2
    echo "Operator: + - x / %" >&2
    exit 1
fi

a="$1"
op="$2"
b="$3"

# Validasi angka
case "$a" in
    ''|*[!0-9-]*) echo "Error: '$a' bukan angka." >&2; exit 1 ;;
esac
case "$b" in
    ''|*[!0-9-]*) echo "Error: '$b' bukan angka." >&2; exit 1 ;;
esac

case "$op" in
    +) hasil=$((a + b)) ;;
    -) hasil=$((a - b)) ;;
    x|X|\*) hasil=$((a * b)) ;;
    /)
        if [ "$b" -eq 0 ]; then
            echo "Error: pembagian dengan nol." >&2
            exit 1
        fi
        hasil=$((a / b))
        ;;
    %)
        if [ "$b" -eq 0 ]; then
            echo "Error: modulo dengan nol." >&2
            exit 1
        fi
        hasil=$((a % b))
        ;;
    *)
        echo "Error: operator tidak dikenal: $op" >&2
        exit 1
        ;;
esac

echo "$a $op $b = $hasil"
```

Bedah:

- Validasi argumen dengan `case`.
- `$((a + b))` – Aritmatika.
- Cek pembagian dengan nol sebelum operasi.
- `x|X|\*` – Menerima `x`, `X`, atau `*` sebagai operator perkalian.

### Skrip 2: Statistik Sederhana

```sh
#!/bin/sh
# Nama: statistik.sh
# Tujuan: Menghitung statistik dari file angka

FILE="${1:?Penggunaan: $0 file_angka}"

if [ ! -r "$FILE" ]; then
    echo "Error: $FILE tidak dapat dibaca." >&2
    exit 1
fi

count=0
total=0
min=""
max=""

while IFS= read -r line; do
    # Skip baris kosong
    [ -z "$line" ] && continue

    # Validasi angka
    case "$line" in
        ''|*[!0-9-]*) 
            echo "Skip (bukan angka): $line" >&2
            continue
            ;;
    esac

    count=$((count + 1))
    total=$((total + line))

    if [ -z "$min" ] || [ "$line" -lt "$min" ]; then
        min="$line"
    fi

    if [ -z "$max" ] || [ "$line" -gt "$max" ]; then
        max="$line"
    fi
done < "$FILE"

if [ "$count" -eq 0 ]; then
    echo "Tidak ada angka valid." >&2
    exit 1
fi

rata=$(awk "BEGIN { printf \"%.2f\", $total / $count }")

echo "Jumlah data: $count"
echo "Total: $total"
echo "Minimum: $min"
echo "Maximum: $max"
echo "Rata-rata: $rata"
```

Bedah:

- Validasi angka dengan `case`.
- `total=$((total + line))` – Akumulasi.
- Perbandingan min/max dengan `[ ]`.
- Rata-rata dengan `awk` untuk floating-point.

### Skrip 3: Konversi Basis Bilangan

```sh
#!/bin/sh
# Nama: konversi.sh
# Tujuan: Konversi bilangan desimal ke basis lain

desimal="${1:?Penggunaan: $0 angka_desimal}"
basis="${2:-2}"

# Validasi
case "$desimal" in
    ''|*[!0-9]*) echo "Error: '$desimal' bukan angka non-negatif." >&2; exit 1 ;;
esac

case "$basis" in
    2|8|16) ;;
    *) echo "Error: basis harus 2, 8, atau 16." >&2; exit 1 ;;
esac

printf "Desimal: %d\n" "$desimal"
printf "Biner:   %s\n" "$(echo "obase=2; $desimal" | bc)"
printf "Oktal:   %s\n" "$(echo "obase=8; $desimal" | bc)"
printf "Heks:    %s\n" "$(echo "obase=16; $desimal" | bc)"
```

Bedah:

- `bc` dengan `obase` – Output base.
- `printf %d` – Format integer.

### Skrip 4: Timer Sederhana

```sh
#!/bin/sh
# Nama: timer.sh
# Tujuan: Countdown timer

detik="${1:?Penggunaan: $0 detik}"

case "$detik" in
    ''|*[!0-9]*) echo "Error: '$detik' bukan angka." >&2; exit 1 ;;
esac

while [ "$detik" -gt 0 ]; do
    menit=$((detik / 60))
    sisa=$((detik % 60))
    printf "\r%02d:%02d" "$menit" "$sisa"
    sleep 1
    detik=$((detik - 1))
done
printf "\r00:00\n"
echo "Waktu habis!"
```

Bedah:

- `detik / 60` – Menit.
- `detik % 60` – Sisa detik.
- `printf "\r%02d:%02d"` – Format MM:SS dengan carriage return.

### Skrip 5: Validasi Angka Portabel

```sh
#!/bin/sh
# Nama: validasi_angka.sh
# Tujuan: Validasi bahwa argumen adalah angka

validasi_angka() {
    case "$1" in
        ''|*[!0-9-]*) return 1 ;;
        -*) 
            # Cek sisa setelah tanda minus
            case "${1#-}" in
                ''|*[!0-9]*) return 1 ;;
            esac
            ;;
    esac
    return 0
}

if [ $# -eq 0 ]; then
    echo "Penggunaan: $0 angka..." >&2
    exit 1
fi

for arg in "$@"; do
    if validasi_angka "$arg"; then
        echo "Valid: $arg"
    else
        echo "Tidak valid: $arg" >&2
    fi
done
```

Bedah:

- `validasi_angka` menggunakan `case` untuk validasi.
- `${1#-}` – Hapus tanda minus di awal.
- Menangani angka positif dan negatif.

---

## 3.4.13 Latihan

1. **Aritmatika Dasar:**
   - Tulis skrip yang menerima dua angka dan mencetak hasil penjumlahan, pengurangan, perkalian, pembagian, dan modulo.
   - Validasi argumen.

2. **Counter:**
   - Loop dari 1 sampai 100, cetak hanya angka yang habis dibagi 5.

3. **Faktorial:**
   - Hitung faktorial dengan `while` dan `$(( ))`.
   - Uji dengan n=5, n=10.

4. **Fibonacci:**
   - Cetak 20 angka Fibonacci pertama.

5. **`expr`:**
   - Ulangi latihan 1 dengan `expr`.
   - Bandingkan sintaksnya.

6. **Floating-Point:**
   - Hitung rata-rata dari file berisi angka desimal.
   - Gunakan `awk`.

7. **`bc`:**
   - Hitung `2^100` dengan `bc`.
   - Hitung `sqrt(2)` dengan 10 desimal.

8. **Overflow:**
   - Coba hitung `9223372036854775807 + 1` dengan `$(( ))`.
   - Bandingkan dengan `awk` dan `bc`.

9. **Pembagian dengan Nol:**
   - Tulis skrip yang membagi dua angka dengan validasi pembagi bukan nol.

10. **Kalkulator:**
    - Buat kalkulator yang membaca operator dari input pengguna.
    - Loop sampai pengguna memilih keluar.

11. **Konversi:**
    - Konversi desimal ke biner, oktal, heksadesimal dengan `bc`.

12. **Bitwise:**
    - Tulis skrip yang menampilkan hasil operasi bitwise untuk dua angka.
    - Tampilkan dalam biner.

---

## 3.4.14 Ringkasan Materi 4

- **`$(( ))`** adalah cara modern dan direkomendasikan untuk aritmatika integer di shell POSIX.
- Operator lengkap: `+`, `-`, `*`, `/`, `%`, `=`, `+=`, `-=`, `*=`, `/=`, `%=`, `==`, `!=`, `<`, `<=`, `>`, `>=`, `&&`, `||`, `!`, `&`, `|`, `^`, `~`, `<<`, `>>`, `? :`.
- **`expr`** adalah alternatif portabel, tetapi lebih lambat dan perlu escape operator.
- **`let`** tidak POSIX; gunakan `$(( ))`.
- **Floating-point** menggunakan `awk` atau `bc`.
- **`awk`** untuk perhitungan cepat; **`bc`** untuk presisi arbitrer.
- Perbandingan numerik di `[ ]` menggunakan `-eq`, `-ne`, `-gt`, `-lt`, `-ge`, `-le`.
- **Overflow** tidak memberikan error; gunakan `awk`/`bc` untuk angka besar.
- **Pembagian dengan nol** menyebabkan error; validasi sebelum operasi.
- **Validasi angka** dengan `case` adalah cara portabel.

---

# Selamat!
## 🎉 Level 3 Selesai!

Anda telah menyelesaikan **Level 3 – Teknik Lanjutan**. Anda sekarang menguasai:

- Input/Output & Redirection secara mendalam.
- Command Substitution & Pipeline.
- Pattern Matching & Text Processing (`grep`, `sed`, `awk`).
- Aritmatika dalam Shell.

Anda sudah bisa menulis skrip yang **kompleks**, **efisien**, dan **portabel** untuk pemrosesan teks dan perhitungan.

---

## 📌 Selanjutnya: Level 4 – Profesional

Di Level 4, kita akan masuk ke topik yang membedakan penulis skrip **profesional** dari amatir:

- **Materi 1:** Error Handling & Defensive Programming — `trap`, `set -e`, exit code, logging.
- **Materi 2:** Portabilitas — menghindari "bashisms", checklist POSIX, menguji di berbagai shell.
- **Materi 3:** Debugging — `set -x`, `trap ERR`, `shellcheck`, teknik tracing.
- **Materi 4:** Keamanan Skrip Shell — command injection, quote, sanitasi input, `mktemp`.
- **Materi 5:** Praktik Terbaik & Gaya Kode — penamaan, dokumentasi, `getopts`.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

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

