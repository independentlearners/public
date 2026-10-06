# Level 4 – Profesional  
## Materi 1: Error Handling & Defensive Programming

> **Catatan:** Ini adalah **materi pertama** dari Level 4, sesuai kurikulum yang sudah ditetapkan. Kita akan membahas cara membuat skrip yang **tahan banting** — tidak hanya berjalan saat semuanya normal, tetapi juga menangani kegagalan dengan elegan, membersihkan sumber daya, dan memberikan pesan yang berguna. Setelah materi ini, skrip Anda akan berhenti "diam-diam gagal" dan mulai "gagal dengan terhormat".

---

## 🎯 Tujuan Materi 1

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Memahami **exit code** sebagai bahasa universal kegagalan.
2. Menguasai `$?` dan kapan harus memeriksanya.
3. Menggunakan `set -e` (errexit) dengan benar **dan** memahami jebakannya.
4. Menggunakan `set -u` (nounset) untuk mendeteksi variabel tak terdefinisi.
5. Memahami `set -o pipefail` (meskipun tidak POSIX) dan alternatifnya.
6. Menguasai **`trap`** untuk menangkap sinyal dan kejadian `EXIT`.
7. Menulis **cleanup handler** yang selalu dijalankan.
8. Menerapkan **defensive programming**: validasi input, cek precondition, fail fast.
9. Membuat **temporary file** yang aman.
10. Menulis **log** yang informatif dan konsisten.
11. Menghindari **silent failure** yang membuat bug sulit dilacak.

---

## 4.1.1 Filosofi Error Handling di Shell

Di banyak bahasa pemrograman, error ditangani dengan **exception**. Di shell, error ditangani dengan **exit code** dan **konvensi**.

Masalah utama skrip shell pemula:

1. **Silent failure** — Perintah gagal, tetapi skrip terus berjalan seolah tidak terjadi apa-apa.
2. **No cleanup** — File temporary tertinggal, lock tidak dilepas.
3. **Unclear error** — Pesan error tidak informatif, sulit dilacak.
4. **Cascade failure** — Kegagalan kecil menyebabkan kegagalan besar yang membingungkan.

**Prinsip defensive programming:**

> **Fail fast, fail loud, fail clean.**

- **Fail fast** — Deteksi error sedini mungkin, jangan biarkan menyebar.
- **Fail loud** — Beri pesan error yang jelas, jangan diam.
- **Fail clean** — Bersihkan sumber daya sebelum keluar.

---

## 4.1.2 Exit Code: Bahasa Universal Kegagalan

Setiap perintah di Unix mengembalikan **exit code** (exit status) — integer 0–255.

### Konvensi Exit Code

| Kode | Arti |
|------|------|
| `0` | Sukses |
| `1` | Error umum |
| `2` | Kesalahan penggunaan (misuse of shell builtins) |
| `126` | Perintah tidak dapat dieksekusi (izin ditolak) |
| `127` | Perintah tidak ditemukan |
| `128` | Exit argument tidak valid |
| `128+N` | Proses dihentikan oleh sinyal N |
| `130` | Dihentikan oleh `SIGINT` (Ctrl+C) — 128+2 |
| `143` | Dihentikan oleh `SIGTERM` — 128+15 |

### Melihat Exit Code

```sh
ls /tmp
echo "$?"
```

Penjelasan:

- `ls /tmp` – Perintah apa pun.
- `$?` – Variabel spesial berisi exit code perintah terakhir.
- `0` – Sukses.
- `2` – Misalnya direktori tidak ada.

```sh
ls /tidak/ada
echo "$?"
```

Output:

```
ls: cannot access '/tidak/ada': No such file or directory
2
```

### Exit Code dari Sinyal

```sh
sleep 100
# Tekan Ctrl+C
echo "$?"
```

Output:

```
130
```

Penjelasan:

- `130 = 128 + 2` – `SIGINT` adalah sinyal nomor 2.
- Konvensi: `128 + N` untuk sinyal N.

### Exit Code Kustom

Skrip Anda bisa mengembalikan exit code kustom untuk memberi tahu pemanggil **jenis** kegagalan:

```sh
#!/bin/sh

if [ ! -f "$1" ]; then
    echo "Error: file tidak ada" >&2
    exit 2
fi

if [ ! -r "$1" ]; then
    echo "Error: file tidak dapat dibaca" >&2
    exit 3
fi

# ... proses ...
exit 0
```

Penjelasan:

- `exit 2` – Error karena file tidak ada.
- `exit 3` – Error karena izin.
- `exit 0` – Sukses.

Pemanggil bisa memeriksa `$?` untuk mengetahui jenis kegagalan.

---

## 4.1.3 `$?` — Memeriksa Exit Status

`$?` harus diperiksa **segera** setelah perintah, karena akan ditimpa oleh perintah berikutnya.

### Contoh yang Salah

```sh
grep "pola" file.txt
echo "Exit code: $?"
```

Penjelasan:

- Ini **benar** — `echo` belum dijalankan saat `$?` diekspansi.
- Tapi hati-hati: jika ada perintah lain di antaranya, `$?` berubah.

```sh
grep "pola" file.txt
echo "Cek"           # Perintah ini mengubah $?
echo "Exit code: $?" # Ini $? dari echo, bukan grep
```

### Contoh yang Benar

```sh
if grep -q "pola" file.txt; then
    echo "Ditemukan"
else
    echo "Tidak ditemukan"
fi
```

Penjelasan:

- `if` langsung mengevaluasi exit status `grep`.
- Tidak ada `$?` eksplisit.
- Ini adalah pola yang lebih bersih.

### Menyimpan Exit Code

```sh
grep "pola" file.txt
status=$?
echo "Exit code: $status"
```

Penjelasan:

- `status=$?` – Simpan exit code ke variabel.
- Setelah itu, `$?` bisa berubah tanpa masalah.

### `$?` dalam Fungsi

```sh
fungsi() {
    return 42
}

fungsi
echo "$?"    # 42
```

Penjelasan:

- `return N` – Fungsi mengembalikan exit code `N`.
- `$?` setelah pemanggilan fungsi berisi `N`.

---

## 4.1.4 `set -e` — Exit on Error (Errexit)

`set -e` membuat shell **keluar** jika ada perintah yang gagal (exit code non-zero).

### Contoh Tanpa `set -e`

```sh
#!/bin/sh
echo "Mulai"
ls /tidak/ada
echo "Selesai"
```

Output:

```
Mulai
ls: cannot access '/tidak/ada': No such file or directory
Selesai
```

Penjelasan:

- `ls` gagal, tetapi skrip tetap berjalan.
- "Selesai" tetap tercetak meskipun ada error.
- Ini adalah **silent failure** — berbahaya.

### Contoh Dengan `set -e`

```sh
#!/bin/sh
set -e

echo "Mulai"
ls /tidak/ada
echo "Selesai"
```

Output:

```
Mulai
ls: cannot access '/tidak/ada': No such file or directory
```

Penjelasan:

- Setelah `ls` gagal, skrip langsung keluar.
- "Selesai" tidak tercetak.
- Exit code skrip adalah exit code `ls` (2).

### Jebakan `set -e`

`set -e` **tidak sesederhana yang terlihat**. Ada banyak pengecualian yang bisa membuatnya tidak berfungsi.

**Jebakan 1: Perintah dalam `if`**

```sh
set -e
if grep -q "pola" file.txt; then
    echo "Ditemukan"
fi
echo "Lanjut"
```

Penjelasan:

- `grep` gagal (tidak ditemukan), tetapi **tidak** menyebabkan skrip keluar.
- Karena `grep` adalah kondisi `if`, kegagalannya "diharapkan".
- `set -e` **tidak** berlaku untuk perintah yang merupakan bagian dari `if`, `while`, `until`, atau `&&`/`||`.

**Jebakan 2: Perintah dalam `&&` atau `||`**

```sh
set -e
false && echo "Tidak akan tercetak"
echo "Lanjut"    # Tetap berjalan
```

Penjelasan:

- `false` gagal, tetapi karena bagian dari `&&`, tidak menyebabkan keluar.
- Ini adalah perilaku yang diinginkan.

**Jebakan 3: Perintah dalam Pipeline**

```sh
set -e
false | true
echo "Lanjut"    # Tetap berjalan
```

Penjelasan:

- Exit code pipeline adalah exit code **perintah terakhir** (`true` = 0).
- `set -e` melihat exit code 0, jadi tidak keluar.
- Ini adalah jebakan besar: jika perintah pertama gagal, Anda tidak tahu.

**Jebakan 4: Subshell**

```sh
set -e
( false; echo "Dalam subshell" )
echo "Lanjut"
```

Penjelasan:

- `false` di dalam subshell menyebabkan subshell keluar.
- Tetapi shell induk tetap berjalan.
- Output: "Dalam subshell" **tidak** tercetak, tetapi "Lanjut" tercetak.

**Jebakan 5: Command Substitution**

```sh
set -e
hasil=$(false)
echo "Lanjut"
```

Penjelasan:

- `false` di dalam `$( )` gagal.
- Di sebagian shell, ini **tidak** menyebabkan keluar.
- Di shell lain, ini menyebabkan keluar.
- **Tidak portabel.**

**Jebakan 6: Fungsi**

```sh
set -e

fungsi() {
    false
    echo "Dalam fungsi"
}

fungsi
echo "Setelah fungsi"
```

Penjelasan:

- `false` di dalam fungsi menyebabkan fungsi keluar.
- Tetapi apakah skrip keluar? Tergantung shell.
- Di `dash`, skrip keluar. Di `bash` tanpa `set -e` di fungsi, mungkin tidak.

### Kesimpulan tentang `set -e`

`set -e` berguna, tetapi **tidak bisa diandalkan sendiri**. Banyak penulis skrip profesional **menghindari** `set -e` dan memeriksa exit code secara eksplisit.

**Rekomendasi:**

1. Gunakan `set -e` untuk skrip sederhana.
2. Untuk skrip kompleks, periksa exit code secara eksplisit.
3. Selalu uji perilaku `set -e` di shell target.

---

## 4.1.5 `set -u` — Treat Unset Variables as Error

`set -u` membuat shell **error** jika Anda menggunakan variabel yang tidak di-set.

### Contoh Tanpa `set -u`

```sh
#!/bin/sh
echo "Nama: $nama"
```

Output:

```
Nama: 
```

Penjelasan:

- `$nama` tidak di-set, tetapi shell menggantinya dengan string kosong.
- Ini bisa menyembunyikan bug — Anda pikir variabel di-set, tetapi tidak.

### Contoh Dengan `set -u`

```sh
#!/bin/sh
set -u
echo "Nama: $nama"
```

Output:

```
sh: nama: parameter not set
```

Penjelasan:

- Shell langsung error dan keluar.
- Ini **fail fast** — lebih baik daripada diam-diam menggunakan nilai kosong.

### Menggunakan `${var:-default}` dengan `set -u`

```sh
set -u
echo "${nama:-Anonim}"
```

Output:

```
Anonim
```

Penjelasan:

- `${nama:-Anonim}` aman meskipun `set -u` aktif.
- Ekspansi parameter dengan default **tidak** melanggar `set -u`.

### `${var:?pesan}` dengan `set -u`

```sh
set -u
: "${nama:?Variabel nama wajib diisi}"
```

Output:

```
sh: nama: Variabel nama wajib diisi
```

Penjelasan:

- Ini adalah cara eksplisit untuk memvalidasi variabel wajib.

### Jebakan `set -u`

**Jebakan 1: `$@` dan `$*` saat tidak ada argumen**

```sh
set -u
echo "$@"
```

Output (bash):

```
bash: $@: unbound variable
```

Beberapa shell menganggap `$@` sebagai variabel yang tidak di-set jika tidak ada argumen. Untuk aman:

```sh
set -u
echo "${@:-}"
```

**Jebakan 2: Variabel dari Environment**

```sh
set -u
echo "$PATH"    # OK jika di-set
echo "$UNSET"   # Error
```

Jika skrip Anda mengandalkan environment variable yang mungkin tidak ada, gunakan default:

```sh
: "${EDITOR:=vi}"
```

---

## 4.1.6 `set -o pipefail` — Tidak POSIX

`set -o pipefail` membuat exit code pipeline menjadi **exit code perintah pertama yang gagal**, bukan exit code perintah terakhir.

### Tanpa `pipefail`

```sh
false | true
echo "$?"    # 0 (dari true)
```

### Dengan `pipefail`

```sh
set -o pipefail
false | true
echo "$?"    # 1 (dari false)
```

### Portabilitas

`set -o pipefail` **tidak POSIX**. Ini ekstensi bash/ksh. Untuk skrip portabel, gunakan alternatif:

**Alternatif 1: Periksa setiap perintah secara terpisah**

```sh
perintah1 > /tmp/out.$$
status1=$?

perintah2 < /tmp/out.$$
status2=$?

rm -f /tmp/out.$$

if [ "$status1" -ne 0 ] || [ "$status2" -ne 0 ]; then
    echo "Pipeline gagal" >&2
    exit 1
fi
```

**Alternatif 2: Simpan exit code dengan trik**

```sh
{ perintah1; echo $? > /tmp/status.$$; } | perintah2
status1=$(cat /tmp/status.$$)
rm -f /tmp/status.$$
```

Rumit, tetapi portabel.

**Alternatif 3: Gunakan `set -e` dan struktur ulang**

Sering kali, lebih baik menghindari pipeline yang bergantung pada `pipefail`. Struktur ulang skrip agar setiap perintah diperiksa.

---

## 4.1.7 `trap` — Menangkap Sinyal dan Kejadian

`trap` adalah perintah POSIX untuk menjalankan kode ketika **sinyal** diterima atau ketika skrip **keluar**.

### Sintaks

```sh
trap 'perintah' SINYAL...
```

Penjelasan:

- `trap` – Kata kunci.
- `'perintah'` – Kode yang akan dijalankan. Harus dikutip.
- `SINYAL...` – Nama sinyal atau nomor. Bisa beberapa.

### Sinyal Umum

| Sinyal | Nomor | Arti |
|--------|-------|------|
| `EXIT` | — | Ketika skrip keluar (normal atau error) |
| `INT` | 2 | Interrupt (Ctrl+C) |
| `TERM` | 15 | Terminasi (default `kill`) |
| `HUP` | 1 | Hangup (terminal ditutup) |
| `QUIT` | 3 | Quit (Ctrl+\) |
| `USR1` | 10 | User-defined 1 |
| `USR2` | 12 | User-defined 2 |

### Contoh 1: Trap `EXIT`

```sh
#!/bin/sh

cleanup() {
    echo "Membersihkan..."
    rm -f /tmp/data.$$
}

trap cleanup EXIT

echo "Mulai"
touch /tmp/data.$$
echo "Selesai"
```

Output:

```
Mulai
Selesai
Membersihkan...
```

Penjelasan:

- `trap cleanup EXIT` – Daftarkan fungsi `cleanup` untuk dijalankan ketika skrip keluar.
- `cleanup` dijalankan **apapun** penyebab keluar — normal, error, atau sinyal.
- Ini adalah cara terbaik untuk membersihkan sumber daya.

### Contoh 2: Trap dengan Exit Code

```sh
#!/bin/sh

cleanup() {
    status=$?
    echo "Keluar dengan status: $status"
    rm -f /tmp/data.$$
    exit "$status"
}

trap cleanup EXIT

echo "Mulai"
false
echo "Tidak akan tercetak jika set -e"
```

Penjelasan:

- Di dalam `cleanup`, `$?` berisi exit code **sebelum** trap dipanggil.
- Simpan ke variabel `status` sebelum perintah lain mengubahnya.
- `exit "$status"` – Keluar dengan status yang sama agar exit code tidak berubah.

### Contoh 3: Trap Sinyal

```sh
#!/bin/sh

bersihkan() {
    echo "Menerima sinyal, membersihkan..."
    rm -f /tmp/data.$$
    exit 130
}

trap bersihkan INT TERM

echo "Tekan Ctrl+C untuk berhenti"
while :; do
    sleep 1
done
```

Penjelasan:

- `trap bersihkan INT TERM` – Tangani `SIGINT` dan `SIGTERM`.
- Ketika Ctrl+C ditekan, `bersihkan` dijalankan.
- `exit 130` – Exit code konvensional untuk `SIGINT`.

### Contoh 4: Trap untuk Ignore Sinyal

```sh
trap '' INT
```

Penjelasan:

- `''` – String kosong. Mengabaikan sinyal.
- Skrip tidak akan berhenti saat Ctrl+C ditekan.
- Berguna untuk operasi kritis yang tidak boleh diinterupsi.

### Contoh 5: Reset Trap

```sh
trap - INT
```

Penjelasan:

- `-` – Reset trap ke default.
- Sinyal `INT` kembali ke perilaku normal.

### Contoh 6: Trap dan Subshell

```sh
#!/bin/sh

trap 'echo "Induk: EXIT"' EXIT

(
    trap 'echo "Anak: EXIT"' EXIT
    echo "Dalam subshell"
)
echo "Setelah subshell"
```

Output:

```
Dalam subshell
Anak: EXIT
Setelah subshell
Induk: EXIT
```

Penjelasan:

- Subshell memiliki trap sendiri.
- Trap induk tidak diwariskan ke subshell (kecuali di beberapa shell).

### Contoh 7: Trap untuk Logging

```sh
#!/bin/sh

LOG="/tmp/skrip.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> "$LOG"
}

trap 'log "Skrip keluar dengan status $?"' EXIT

log "Skrip dimulai"
# ... kerja ...
log "Skrip selesai"
```

Output di log:

```
2026-01-01 12:00:00 - Skrip dimulai
2026-01-01 12:00:00 - Skrip selesai
2026-01-01 12:00:00 - Skrip keluar dengan status 0
```

---

## 4.1.8 Cleanup Handler yang Benar

Cleanup handler adalah penggunaan `trap` yang paling penting.

### Pola Standar

```sh
#!/bin/sh

TMPFILE=""

cleanup() {
    status=$?
    [ -n "$TMPFILE" ] && rm -f "$TMPFILE"
    exit "$status"
}

trap cleanup EXIT INT TERM

TMPFILE=$(mktemp)
# ... gunakan TMPFILE ...
```

Bedah:

- `TMPFILE=""` – Inisialisasi variabel.
- `cleanup`:
  - `status=$?` – Simpan exit code.
  - `[ -n "$TMPFILE" ] && rm -f "$TMPFILE"` – Hapus file jika ada.
  - `exit "$status"` – Keluar dengan status yang sama.
- `trap cleanup EXIT INT TERM` – Daftarkan handler.
- `TMPFILE=$(mktemp)` – Buat file temporary.

### Mengapa `exit "$status"`?

Tanpa `exit`, exit code skrip akan menjadi exit code perintah terakhir di `cleanup`. Ini bisa mengubah exit code skrip secara tidak sengaja.

```sh
cleanup() {
    rm -f "$TMPFILE"    # Exit code dari rm
}
```

Jika `rm` sukses, exit code skrip menjadi 0 meskipun skrip aslinya gagal.

### Mengapa `[ -n "$TMPFILE" ]`?

Jika `mktemp` gagal, `TMPFILE` kosong. `rm -f ""` akan error. Cek dulu.

### Cleanup untuk Multiple Resource

```sh
#!/bin/sh

TMPFILE1=""
TMPFILE2=""
LOCKFILE=""

cleanup() {
    status=$?
    [ -n "$TMPFILE1" ] && rm -f "$TMPFILE1"
    [ -n "$TMPFILE2" ] && rm -f "$TMPFILE2"
    [ -n "$LOCKFILE" ] && rm -f "$LOCKFILE"
    exit "$status"
}

trap cleanup EXIT INT TERM
```

---

## 4.1.9 Signal Handling

Sinyal adalah cara sistem operasi memberi tahu proses tentang kejadian.

### Sinyal Penting untuk Skrip

| Sinyal | Nomor | Default | Kapan Dikirim |
|--------|-------|---------|---------------|
| `SIGHUP` | 1 | Terminate | Terminal ditutup |
| `SIGINT` | 2 | Terminate | Ctrl+C |
| `SIGQUIT` | 3 | Core dump | Ctrl+\ |
| `SIGTERM` | 15 | Terminate | `kill` default |
| `SIGKILL` | 9 | Terminate | `kill -9` — **tidak bisa ditangkap** |
| `SIGUSR1` | 10 | Terminate | User-defined |
| `SIGUSR2` | 12 | Terminate | User-defined |

**Penting:** `SIGKILL` (9) **tidak bisa ditangkap**. Jika seseorang menjalankan `kill -9`, skrip Anda tidak bisa membersihkan. Karena itu, jangan mengandalkan cleanup untuk hal-hal kritis.

### Contoh: Graceful Shutdown

```sh
#!/bin/sh

RUNNING=1

shutdown() {
    echo "Menerima sinyal shutdown..."
    RUNNING=0
}

trap shutdown INT TERM

while [ "$RUNNING" -eq 1 ]; do
    echo "Bekerja..."
    sleep 1
done

echo "Keluar dengan bersih"
```

Penjelasan:

- `RUNNING=1` – Flag loop.
- `shutdown` – Set flag ke 0.
- Loop terus berjalan sampai flag 0.
- Skrip keluar dari loop dengan bersih.

### Contoh: Reload Konfigurasi

```sh
#!/bin/sh

reload() {
    echo "Reload konfigurasi..."
    # ... baca ulang konfigurasi ...
}

trap reload HUP

while :; do
    sleep 60
done
```

Penjelasan:

- `SIGHUP` sering digunakan untuk reload konfigurasi.
- Banyak daemon (nginx, sshd) menggunakan ini.

### Mengirim Sinyal

```sh
kill -TERM "$PID"
kill -INT "$PID"
kill -HUP "$PID"
```

Penjelasan:

- `kill -SIGNAL PID` – Mengirim sinyal ke proses.
- Default `kill PID` mengirim `SIGTERM`.

### `kill -0` — Cek Keberadaan Proses

```sh
if kill -0 "$PID" 2>/dev/null; then
    echo "Proses $PID masih hidup"
else
    echo "Proses $PID tidak ada"
fi
```

Penjelasan:

- `kill -0 PID` – Tidak mengirim sinyal, hanya memeriksa.
- Exit 0 jika proses ada, non-zero jika tidak.

---

## 4.1.10 Logging yang Baik

Log adalah alat debugging dan audit. Log yang baik:

1. **Konsisten** — Format yang sama di seluruh skrip.
2. **Informatif** — Berisi timestamp, level, dan pesan.
3. **Berbeda** — stdout untuk output normal, stderr untuk error.
4. **Terpisah** — Log bisa diarahkan ke file tanpa mengganggu output.

### Fungsi Log Sederhana

```sh
log() {
    level="$1"
    shift
    pesan="$*"
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $pesan" >&2
}

log_info()  { log "INFO"  "$@"; }
log_warn()  { log "WARN"  "$@"; }
log_error() { log "ERROR" "$@"; }
```

Bedah:

- `level="$1"` – Argumen pertama adalah level.
- `shift` – Buang argumen pertama.
- `pesan="$*"` – Sisa argumen sebagai pesan.
- `date '+%Y-%m-%d %H:%M:%S'` – Timestamp.
- `>&2` – Log ke stderr agar tidak mengganggu stdout.

**Penggunaan:**

```sh
log_info "Program dimulai"
log_warn "File tidak ditemukan, menggunakan default"
log_error "Gagal membuka koneksi"
```

Output:

```
[2026-01-01 12:00:00] [INFO] Program dimulai
[2026-01-01 12:00:00] [WARN] File tidak ditemukan, menggunakan default
[2026-01-01 12:00:00] [ERROR] Gagal membuka koneksi
```

### Log ke File dan Terminal

```sh
log() {
    level="$1"
    shift
    pesan="$*"
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    baris="[$timestamp] [$level] $pesan"
    echo "$baris" >&2
    [ -n "$LOG_FILE" ] && echo "$baris" >> "$LOG_FILE"
}
```

Penjelasan:

- `LOG_FILE` – Variabel global. Jika di-set, log juga ke file.
- `[ -n "$LOG_FILE" ]` – Cek jika di-set.

### Level Log

Standar level (dari rendah ke tinggi):

1. `DEBUG` — Informasi detail untuk debugging.
2. `INFO` — Informasi umum.
3. `WARN` — Peringatan, tetapi program tetap berjalan.
4. `ERROR` — Error yang dapat ditangani.
5. `FATAL` — Error yang tidak dapat ditangani; program berhenti.

### Log dengan Filter Level

```sh
LOG_LEVEL="${LOG_LEVEL:-INFO}"

_log_level_num() {
    case "$1" in
        DEBUG) echo 0 ;;
        INFO)  echo 1 ;;
        WARN)  echo 2 ;;
        ERROR) echo 3 ;;
        FATAL) echo 4 ;;
        *)     echo 99 ;;
    esac
}

log() {
    level="$1"
    shift
    pesan="$*"

    level_num=$(_log_level_num "$level")
    min_num=$(_log_level_num "$LOG_LEVEL")

    [ "$level_num" -ge "$min_num" ] || return 0

    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $pesan" >&2
}
```

Penjelasan:

- `LOG_LEVEL` – Level minimum yang dicetak.
- `level_num` – Konversi level ke angka.
- `[ "$level_num" -ge "$min_num" ]` – Hanya cetak jika level >= minimum.
- Jika `LOG_LEVEL=WARN`, maka `DEBUG` dan `INFO` tidak dicetak.

---

## 4.1.11 Defensive Programming Patterns

### Pattern 1: Validasi Argumen di Awal

```sh
#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Penggunaan: $0 file" >&2
    exit 2
fi

FILE="$1"

if [ ! -f "$FILE" ]; then
    echo "Error: '$FILE' bukan file." >&2
    exit 2
fi
```

### Pattern 2: Fail Fast

```sh
: "${REQUIRED_VAR:?REQUIRED_VAR harus di-set}"
```

Penjelasan:

- `:?` – Error dan keluar jika variabel tidak di-set atau kosong.
- Pesan error ke stderr.

### Pattern 3: Precondition Check

```sh
if ! command -v "grep" > /dev/null 2>&1; then
    echo "Error: grep tidak tersedia." >&2
    exit 1
fi
```

Penjelasan:

- `command -v` – Cek keberadaan perintah.
- Buang output.
- Error jika tidak ada.

### Pattern 4: Periksa Direktori

```sh
DIR="/data"

if [ ! -d "$DIR" ]; then
    echo "Error: $DIR bukan direktori." >&2
    exit 1
fi

if [ ! -w "$DIR" ]; then
    echo "Error: $DIR tidak dapat ditulis." >&2
    exit 1
fi
```

### Pattern 5: Periksa Ruang Disk

```sh
minimum_mb=100

tersedia_kb=$(df -k "$DIR" | awk 'NR==2 { print $4 }')
tersedia_mb=$((tersedia_kb / 1024))

if [ "$tersedia_mb" -lt "$minimum_mb" ]; then
    echo "Error: ruang disk kurang dari ${minimum_mb}MB." >&2
    exit 1
fi
```

### Pattern 6: Validasi Angka

```sh
validasi_angka() {
    case "$1" in
        ''|*[!0-9]*) return 1 ;;
    esac
    return 0
}

if ! validasi_angka "$1"; then
    echo "Error: '$1' bukan angka." >&2
    exit 1
fi
```

### Pattern 7: Idempotent

Skrip idempotent bisa dijalankan berkali-kali tanpa efek samping berbeda.

```sh
# Buruk: gagal jika direktori sudah ada
mkdir "$DIR"

# Baik: tidak gagal jika sudah ada
mkdir -p "$DIR"
```

### Pattern 8: Atomic Operation

Untuk operasi file, gunakan file temporary dan `mv` (rename bersifat atomic di filesystem yang sama):

```sh
tmp="$OUTPUT.tmp.$$"
echo "data baru" > "$tmp"
mv "$tmp" "$OUTPUT"
```

Penjelasan:

- Tulis ke file temporary.
- `mv` – Rename atomic. File target diganti sekaligus.
- Jika proses terputus di tengah, file target tidak rusak.

### Pattern 9: Trap untuk Cleanup

Sudah dibahas. Selalu gunakan trap untuk membersihkan.

### Pattern 10: Guard terhadap Perintah Berbahaya

```sh
if [ -z "$DIR" ] || [ "$DIR" = "/" ]; then
    echo "Error: DIR tidak boleh kosong atau /" >&2
    exit 1
fi

rm -rf "$DIR"
```

Penjelasan:

- Cek `$DIR` sebelum `rm -rf`.
- Mencegah `rm -rf /` atau `rm -rf ""`.

---

## 4.1.12 Temporary File yang Aman

**Jangan** gunakan nama file temporary yang dapat diprediksi seperti `/tmp/data.txt`. Penyerang bisa membuat symlink atau file yang bertabrakan.

### Buruk

```sh
TMP="/tmp/data.txt"
echo "rahasia" > "$TMP"
```

Masalah:

- Nama dapat diprediksi.
- Bisa ditimpa oleh pengguna lain.
- Symlink attack: penyerang membuat `/tmp/data.txt` sebagai symlink ke file sensitif.

### Baik: `mktemp`

```sh
TMPFILE=$(mktemp) || {
    echo "Error: tidak dapat membuat file temporary." >&2
    exit 1
}
```

Penjelasan:

- `mktemp` – Membuat file dengan nama acak, izin `0600`.
- `|| { ... }` – Handle error.
- File ada di `/tmp` dengan nama seperti `/tmp/tmp.XXXXXXXXXX`.

### `mktemp -d` untuk Direktori

```sh
TMPDIR=$(mktemp -d) || exit 1
```

Penjelasan:

- `-d` – Buat direktori temporary.

### `mktemp` dengan Template (GNU)

```sh
TMPFILE=$(mktemp /tmp/myapp.XXXXXX)
```

Penjelasan:

- `XXXXXX` – Enam karakter acak.
- **Tidak POSIX.** POSIX `mktemp` hanya menerima satu argumen template.

Untuk portabilitas:

```sh
TMPFILE=$(mktemp) || exit 1
```

### Cleanup dengan Trap

```sh
#!/bin/sh

TMPFILE=""

cleanup() {
    status=$?
    [ -n "$TMPFILE" ] && rm -f "$TMPFILE"
    exit "$status"
}

trap cleanup EXIT INT TERM

TMPFILE=$(mktemp) || {
    echo "Error: mktemp gagal." >&2
    exit 1
}

echo "data" > "$TMPFILE"
# ... gunakan ...
```

### Direktori Temporary

```sh
TMPDIR=""

cleanup() {
    status=$?
    [ -n "$TMPDIR" ] && rm -rf "$TMPDIR"
    exit "$status"
}

trap cleanup EXIT INT TERM

TMPDIR=$(mktemp -d) || exit 1
```

### Jebakan `mktemp`

1. **Beberapa sistem tidak memiliki `mktemp`** — meskipun jarang di Unix modern.
2. **`mktemp` tanpa template** — Beberapa versi lama memerlukan template.
3. **Performa** — `mktemp` memanggil syscall, tetapi cepat.

---

## 4.1.13 Lock File

**Lock file** mencegah dua instance skrip berjalan bersamaan.

### Pola Sederhana

```sh
LOCKFILE="/var/lock/myapp.lock"

if [ -e "$LOCKFILE" ]; then
    echo "Error: skrip sedang berjalan (lock: $LOCKFILE)." >&2
    exit 1
fi

echo $$ > "$LOCKFILE"
trap 'rm -f "$LOCKFILE"' EXIT INT TERM
```

Penjelasan:

- `[ -e "$LOCKFILE" ]` – Cek keberadaan lock.
- `echo $$ > "$LOCKFILE"` – Tulis PID ke lock.
- Trap untuk hapus lock saat keluar.

**Jebakan:** Ada **race condition**. Antara cek dan tulis, proses lain bisa menyisipkan.

### Pola Atomik dengan `noclobber`

```sh
LOCKFILE="/var/lock/myapp.lock"

set -C    # noclobber
if ! echo $$ > "$LOCKFILE" 2>/dev/null; then
    echo "Error: tidak dapat membuat lock." >&2
    exit 1
fi
set +C    # matikan noclobber

trap 'rm -f "$LOCKFILE"' EXIT INT TERM
```

Penjelasan:

- `set -C` – Aktifkan noclobber.
- `echo $$ > "$LOCKFILE"` – Gagal jika file sudah ada (atomic).
- `2>/dev/null` – Sembunyikan error.
- `set +C` – Matikan noclobber.

### Pola dengan `mkdir` (Atomic)

`mkdir` bersifat atomic — gagal jika direktori sudah ada.

```sh
LOCKDIR="/var/lock/myapp.lock"

if ! mkdir "$LOCKDIR" 2>/dev/null; then
    echo "Error: skrip sedang berjalan." >&2
    exit 1
fi

trap 'rmdir "$LOCKDIR"' EXIT INT TERM
```

Penjelasan:

- `mkdir` – Atomic. Gagal jika direktori sudah ada.
- `rmdir` – Hapus direktori (hanya jika kosong).

### Lock dengan Timeout

```sh
LOCKDIR="/var/lock/myapp.lock"
TIMEOUT=30
i=0

while ! mkdir "$LOCKDIR" 2>/dev/null; do
    i=$((i + 1))
    if [ "$i" -ge "$TIMEOUT" ]; then
        echo "Error: timeout menunggu lock." >&2
        exit 1
    fi
    sleep 1
done

trap 'rmdir "$LOCKDIR"' EXIT INT TERM
```

### Jebakan Lock File

1. **Stale lock** — Jika skrip crash, lock mungkin tertinggal.
   - Solusi: Simpan PID di lock, periksa apakah PID masih hidup.
2. **Race condition** — Gunakan operasi atomic (`mkdir`, `noclobber`).
3. **Symlink attack** — Gunakan direktori dengan izin ketat.

---

## 4.1.14 Contoh Skrip Lengkap

### Skrip 1: Skrip dengan Semua Pattern

```sh
#!/bin/sh
# Nama: robust.sh
# Tujuan: Demonstrasi error handling lengkap

set -u

# Konfigurasi
LOG_FILE="/tmp/robust.log"
LOCKDIR="/tmp/robust.lock"
TMPFILE=""

# Fungsi logging
log() {
    level="$1"
    shift
    pesan="$*"
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    baris="[$timestamp] [$level] $pesan"
    echo "$baris" >&2
    [ -n "$LOG_FILE" ] && echo "$baris" >> "$LOG_FILE"
}

log_info()  { log "INFO"  "$@"; }
log_warn()  { log "WARN"  "$@"; }
log_error() { log "ERROR" "$@"; }

# Cleanup
cleanup() {
    status=$?
    [ -n "$TMPFILE" ] && rm -f "$TMPFILE"
    [ -d "$LOCKDIR" ] && rmdir "$LOCKDIR" 2>/dev/null
    log_info "Skrip keluar dengan status $status"
    exit "$status"
}

trap cleanup EXIT INT TERM

# Validasi argumen
if [ $# -ne 1 ]; then
    log_error "Penggunaan: $0 file"
    exit 2
fi

FILE="$1"

# Validasi file
if [ ! -f "$FILE" ]; then
    log_error "File '$FILE' tidak ada."
    exit 2
fi

if [ ! -r "$FILE" ]; then
    log_error "File '$FILE' tidak dapat dibaca."
    exit 2
fi

# Lock
if ! mkdir "$LOCKDIR" 2>/dev/null; then
    log_error "Skrip sedang berjalan."
    exit 1
fi

# Temporary file
TMPFILE=$(mktemp) || {
    log_error "Tidak dapat membuat temporary file."
    exit 1
}

# Kerja utama
log_info "Memproses $FILE"

if ! grep -q "ERROR" "$FILE"; then
    log_warn "Tidak ada ERROR di $FILE"
else
    grep "ERROR" "$FILE" > "$TMPFILE"
    jumlah=$(wc -l < "$TMPFILE")
    log_info "Ditemukan $jumlah baris ERROR"
fi

log_info "Selesai"
```

### Skrip 2: Daemon Sederhana dengan Signal Handling

```sh
#!/bin/sh
# Nama: daemon.sh
# Tujuan: Daemon sederhana dengan signal handling

set -u

PIDFILE="/tmp/daemon.pid"
RUNNING=1

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

cleanup() {
    status=$?
    log "Shutdown (status=$status)"
    rm -f "$PIDFILE"
    exit "$status"
}

shutdown() {
    log "Menerima sinyal shutdown"
    RUNNING=0
}

reload() {
    log "Reload konfigurasi"
    # ... baca ulang konfigurasi ...
}

trap cleanup EXIT
trap shutdown INT TERM
trap reload HUP

# Cek sudah berjalan
if [ -f "$PIDFILE" ]; then
    old_pid=$(cat "$PIDFILE")
    if kill -0 "$old_pid" 2>/dev/null; then
        echo "Daemon sudah berjalan (PID: $old_pid)" >&2
        exit 1
    fi
    log "Stale PID file, menghapus"
    rm -f "$PIDFILE"
fi

# Tulis PID
echo $$ > "$PIDFILE"
log "Daemon dimulai (PID: $$)"

# Loop utama
while [ "$RUNNING" -eq 1 ]; do
    log "Bekerja..."
    sleep 5
done

log "Keluar dari loop"
```

### Skrip 3: Batch Processor dengan Error Handling

```sh
#!/bin/sh
# Nama: batch.sh
# Tujuan: Memproses banyak file dengan error handling

set -u

LOG_FILE=""
TMPFILE=""
BERHASIL=0
GAGAL=0

log() {
    level="$1"
    shift
    echo "[$level] $*" >&2
}

cleanup() {
    status=$?
    [ -n "$TMPFILE" ] && rm -f "$TMPFILE"
    log "INFO" "Berhasil: $BERHASIL, Gagal: $GAGAL"
    exit "$status"
}

trap cleanup EXIT INT TERM

if [ $# -eq 0 ]; then
    log "ERROR" "Penggunaan: $0 file..."
    exit 2
fi

TMPFILE=$(mktemp) || exit 1

for file in "$@"; do
    if [ ! -f "$file" ]; then
        log "WARN" "Skip: $file bukan file"
        GAGAL=$((GAGAL + 1))
        continue
    fi

    if grep -q "ERROR" "$file"; then
        log "INFO" "Error ditemukan di: $file"
    fi

    BERHASIL=$((BERHASIL + 1))
done

log "INFO" "Selesai"
```

---

## 4.1.15 Latihan

1. **Exit Code:**
   - Tulis skrip yang mengembalikan exit code berbeda untuk setiap jenis error (file tidak ada = 2, izin = 3, dll).
   - Uji dengan `$?`.

2. **`set -e`:**
   - Tulis skrip dengan `set -e`.
   - Uji perilakunya dengan `if`, `&&`, pipeline.
   - Jelaskan mengapa `set -e` tidak keluar di setiap kasus.

3. **`set -u`:**
   - Tulis skrip dengan `set -u`.
   - Coba akses variabel yang tidak di-set.
   - Gunakan `${var:-default}` untuk menanganinya.

4. **`trap EXIT`:**
   - Tulis skrip yang membuat file temporary.
   - Daftarkan trap untuk menghapusnya.
   - Uji dengan Ctrl+C di tengah eksekusi. Apakah file terhapus?

5. **Trap Sinyal:**
   - Tulis skrip yang menangkap `INT` dan `TERM`.
   - Cetak pesan sebelum keluar.
   - Uji dengan `kill -TERM`.

6. **Logging:**
   - Buat fungsi log dengan level (DEBUG, INFO, WARN, ERROR).
   - Log ke file dan terminal.
   - Filter berdasarkan `LOG_LEVEL`.

7. **Validasi:**
   - Tulis skrip yang menerima direktori sebagai argumen.
   - Validasi: ada, direktori, dapat ditulis.
   - Return exit code berbeda untuk setiap error.

8. **Temporary File:**
   - Gunakan `mktemp` untuk membuat file.
   - Pastikan cleanup dengan trap.
   - Uji symlink attack dengan `/tmp/fixed.txt` — mengapa berbahaya?

9. **Lock File:**
   - Buat lock dengan `mkdir`.
   - Coba jalankan dua instance. Instance kedua harus gagal.
   - Pastikan lock dihapus saat keluar.

10. **Daemon:**
    - Tulis daemon sederhana dengan PID file.
    - Tangani `SIGTERM` dan `SIGHUP`.
    - Log setiap kejadian.

11. **Atomic Write:**
    - Tulis skrip yang menulis file konfigurasi.
    - Gunakan file temporary dan `mv`.
    - Uji dengan memutus proses di tengah.

12. **Defensive:**
    - Refaktor skrip yang menggunakan `rm -rf $DIR` tanpa validasi.
    - Tambahkan cek bahwa `$DIR` tidak kosong dan bukan `/`.

---

## 4.1.16 Ringkasan Materi 1

- **Exit code** adalah bahasa universal kegagalan: `0` sukses, non-zero gagal.
- `$?` harus diperiksa segera setelah perintah.
- `set -e` (errexit) berguna tetapi punya banyak jebakan. Uji di shell target.
- `set -u` (nounset) mendeteksi variabel tak terdefinisi; gunakan `${var:-default}` untuk pengecualian.
- `set -o pipefail` tidak POSIX; gunakan alternatif untuk portabilitas.
- **`trap`** untuk menangkap sinyal (`INT`, `TERM`, `HUP`) dan kejadian `EXIT`.
- **Cleanup handler** wajib untuk skrip yang membuat sumber daya.
- **Logging** dengan level (DEBUG, INFO, WARN, ERROR) dan timestamp.
- **Defensive programming**: validasi argumen, fail fast, precondition check.
- **Temporary file** harus dibuat dengan `mktemp`, bukan nama yang dapat diprediksi.
- **Lock file** dengan `mkdir` (atomic) mencegah dua instance.
- **Atomic write** dengan file temporary dan `mv`.
- **Fail fast, fail loud, fail clean.**

---

## 📌 Selanjutnya

Materi 1 Level 4 selesai. Anda sekarang menguasai error handling dan defensive programming secara mendalam.

Berikutnya adalah **Materi 2: Portabilitas** — kita akan membahas:

- Menghindari "bashisms" yang tidak ada di POSIX.
- Checklist kepatuhan POSIX.
- Menguji di berbagai shell (`dash`, `bash --posix`, `ksh`).
- Shebang portabel.
- Perbedaan perilaku antar shell.
- Tool `shellcheck` dengan mode POSIX.
- Teknik menulis skrip yang benar-benar portabel.

## Materi 2: Portabilitas

> **Catatan:** Ini adalah **materi kedua** dari Level 4, sesuai kurikulum yang sudah ditetapkan. Kita akan membahas cara menulis skrip yang **benar-benar portabel** di semua sistem Unix-like — Linux, macOS, BSD, Solaris, dan bahkan sistem tertanam. Setelah materi ini, Anda akan mampu menulis skrip yang berjalan di `dash`, `bash --posix`, `ksh`, dan shell POSIX lainnya tanpa perubahan.

---

## 🎯 Tujuan Materi 2

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Menjelaskan apa itu **"bashism"** dan mengapa berbahaya.
2. Mengidentifikasi **perbedaan perilaku** antar shell.
3. Menguasai **checklist kepatuhan POSIX** untuk skrip.
4. Menguji skrip di berbagai shell: `dash`, `bash --posix`, `ksh`.
5. Memilih **shebang** yang tepat untuk portabilitas.
6. Menghindari **konstruksi non-POSIX** yang umum.
7. Menggunakan **`shellcheck -s sh`** untuk mendeteksi masalah portabilitas.
8. Menulis skrip yang berjalan di **lingkungan terbatas** (BusyBox, Alpine, embedded).
9. Memahami **perbedaan locale** dan dampaknya pada portabilitas.
10. Membangun **pustaka portabel** yang dapat digunakan lintas sistem.

---

## 4.2.1 Apa Itu Portabilitas?

**Portabilitas** adalah kemampuan sebuah skrip untuk berjalan di berbagai sistem tanpa modifikasi. Di dunia shell, ini berarti:

1. **Portabilitas shell** — Skrip berjalan di shell apa pun yang mengklaim POSIX.
2. **Portabilitas sistem** — Skrip berjalan di Linux, macOS, BSD, Solaris, dll.
3. **Portabilitas utilitas** — Skrip tidak bergantung pada opsi GNU-spesifik yang tidak ada di BSD.
4. **Portabilitas locale** — Skrip berperilaku sama di locale apa pun.

Portabilitas **bukan** berarti "berjalan di semua hal". Sebuah skrip POSIX tidak akan berjalan di Windows CMD atau PowerShell. Tetapi ia akan berjalan di **semua sistem Unix-like**.

### Mengapa Portabilitas Penting?

1. **Skrip instalasi** — Harus berjalan di sistem pengguna yang beragam.
2. **CI/CD** — Berjalan di container Alpine, Ubuntu, macOS.
3. **Embedded** — Router, IoT, NAS dengan BusyBox.
4. **Distribusi** — Skrip yang dibagikan ke orang lain.
5. **Maintenance** — Skrip yang berumur panjang, melewati banyak sistem.

### Trade-off

Portabilitas memiliki biaya:

- **Fitur terbatas** — Tidak bisa menggunakan fitur bash yang nyaman.
- **Kode lebih verbose** — Beberapa hal memerlukan lebih banyak baris.
- **Performa** — Kadang lebih lambat karena harus menggunakan perintah eksternal.

**Keputusan:** Tentukan target Anda. Jika skrip hanya untuk sistem Anda sendiri, bashism OK. Jika untuk distribusi, gunakan POSIX.

---

## 4.2.2 "Bashism" — Fitur Bash yang Tidak POSIX

**Bashism** adalah fitur yang ada di bash tetapi tidak ada di POSIX `sh`. Menggunakannya membuat skrip Anda tidak portabel ke `dash`, `ksh`, atau shell POSIX lainnya.

### Daftar Bashism Umum

#### 1. `[[ ]]` — Double Bracket Test

```sh
# Bashism
if [[ "$var" == "value" ]]; then
    ...
fi
```

```sh
# POSIX
if [ "$var" = "value" ]; then
    ...
fi
```

Penjelasan:

- `[[ ]]` – Kata kunci bash. Tidak perlu kutip, mendukung regex, `==`.
- `[ ]` – Perintah POSIX. Perlu kutip, gunakan `=`, tidak ada regex.

#### 2. `==` dalam `[ ]`

```sh
# Bashism (meskipun bash mentoleransi)
[ "$a" == "$b" ]
```

```sh
# POSIX
[ "$a" = "$b" ]
```

#### 3. `$'...'` — ANSI-C Quoting

```sh
# Bashism
echo $'Halo\nDunia'
```

```sh
# POSIX — gunakan printf
printf 'Halo\nDunia\n'
```

Penjelasan:

- `$'...'` – Menerjemahkan escape seperti `\n`, `\t`.
- POSIX tidak mendefinisikannya. Gunakan `printf`.

#### 4. `{a,b,c}` — Brace Expansion

```sh
# Bashism
echo {1..10}
echo file{1,2,3}.txt
```

```sh
# POSIX
i=1
while [ "$i" -le 10 ]; do
    echo "$i"
    i=$((i + 1))
done

# Untuk file{1,2,3}
for suffix in 1 2 3; do
    echo "file${suffix}.txt"
done
```

#### 5. `$(< file)` — Read File

```sh
# Bashism
content=$(< file.txt)
```

```sh
# POSIX
content=$(cat file.txt)
```

#### 6. `local` — Local Variables

```sh
# Bashism (sebenarnya didukung banyak shell, tapi tidak POSIX)
fungsi() {
    local var="nilai"
}
```

```sh
# POSIX — gunakan konvensi penamaan
fungsi() {
    _fungsi_var="nilai"
}
```

Penjelasan:

- `local` didukung `dash`, `bash`, `ksh`, `zsh`, tetapi **tidak** didefinisikan POSIX.
- Untuk portabilitas maksimal, gunakan prefix unik.

#### 7. `function` Keyword

```sh
# Bashism
function nama {
    ...
}
```

```sh
# POSIX
nama() {
    ...
}
```

#### 8. `source` — Source File

```sh
# Bashism
source file.sh
```

```sh
# POSIX
. file.sh
```

#### 9. `echo -e` dan `echo -n`

```sh
# Bashism (tidak portabel)
echo -e "Halo\nDunia"
echo -n "Tanpa newline"
```

```sh
# POSIX — gunakan printf
printf 'Halo\nDunia\n'
printf 'Tanpa newline'
```

Penjelasan:

- `echo -e` – Mengaktifkan escape. Tidak POSIX.
- `echo -n` – Menonaktifkan newline. Tidak POSIX.
- **Selalu gunakan `printf`** untuk kontrol penuh.

#### 10. `let` — Arithmetic Command

```sh
# Bashism
let "x = 5 + 3"
```

```sh
# POSIX
x=$((5 + 3))
```

#### 11. `(( ))` — Arithmetic Command

```sh
# Bashism
if (( x > 5 )); then
    ...
fi
```

```sh
# POSIX
if [ "$x" -gt 5 ]; then
    ...
fi
```

Penjelasan:

- `$(( ))` – Arithmetic **expansion**. POSIX.
- `(( ))` – Arithmetic **command**. Bashism.

#### 12. `select` — Menu Loop

```sh
# Bashism
select opt in a b c; do
    ...
done
```

Tidak ada padanan POSIX. Gunakan `while` + `read` + `case`.

#### 13. `<<<` — Here String

```sh
# Bashism
grep "pola" <<< "$var"
```

```sh
# POSIX
echo "$var" | grep "pola"

# atau
grep "pola" <<EOF
$var
EOF
```

#### 14. Process Substitution `<(...)`

```sh
# Bashism
diff <(ls dir1) <(ls dir2)
```

```sh
# POSIX — gunakan file temporary
ls dir1 > /tmp/a.$$
ls dir2 > /tmp/b.$$
diff /tmp/a.$$ /tmp/b.$$
rm -f /tmp/a.$$ /tmp/b.$$
```

#### 15. `${var//old/new}` — Global Replace

```sh
# Bashism
echo "${var//foo/bar}"
```

```sh
# POSIX — gunakan sed
echo "$var" | sed 's/foo/bar/g'
```

#### 16. `${var:offset:length}` — Substring

```sh
# Bashism
echo "${var:0:5}"
```

```sh
# POSIX — gunakan cut
echo "$var" | cut -c1-5
```

#### 17. Array

```sh
# Bashism
arr=(a b c)
echo "${arr[0]}"
```

```sh
# POSIX — tidak ada array. Gunakan string dengan separator
arr="a b c"
for item in $arr; do
    echo "$item"
done
```

**Catatan:** POSIX tidak memiliki array. Ini adalah keterbatasan besar.

#### 18. `+=` untuk String

```sh
# Bashism
str="hello"
str+=" world"
```

```sh
# POSIX
str="hello"
str="${str} world"
```

#### 19. `$RANDOM`

```sh
# Bashism
echo $RANDOM
```

```sh
# POSIX — gunakan awk atau /dev/urandom
awk 'BEGIN { srand(); print int(rand() * 100) }'

# atau
od -An -N2 -tu2 /dev/urandom | tr -d ' '
```

#### 20. `set -o pipefail`

```sh
# Bashism
set -o pipefail
```

Tidak ada padanan POSIX. Gunakan alternatif (lihat Level 4 Materi 1).

#### 21. `trap ... ERR`

```sh
# Bashism
trap 'echo "Error"' ERR
```

POSIX hanya mendefinisikan `EXIT`, `INT`, `TERM`, `HUP`, dan sinyal lainnya. `ERR` tidak POSIX.

#### 22. `typeset` / `declare`

```sh
# Bashism
declare -i x=5
typeset -r KONSTANTA="nilai"
```

```sh
# POSIX — gunakan readonly
readonly KONSTANTA="nilai"
```

#### 23. `printf -v`

```sh
# Bashism
printf -v var "%s" "nilai"
```

```sh
# POSIX
var=$(printf "%s" "nilai")
```

#### 24. `echo` dengan Opsi

Secara umum, `echo` dengan opsi apa pun tidak portabel. Selalu gunakan `printf`.

#### 25. `$BASH_VERSION`, `$BASH_SOURCE`

```sh
# Bashism
echo "$BASH_VERSION"
echo "${BASH_SOURCE[0]}"
```

Tidak ada padanan POSIX. Untuk mendapatkan direktori skrip, gunakan:

```sh
SCRIPT_DIR=$(dirname "$0")
```

---

## 4.2.3 Checklist Kepatuhan POSIX

Gunakan checklist ini saat menulis skrip portabel:

### Shell

- [ ] Shebang `#!/bin/sh`.
- [ ] Tidak menggunakan `[[ ]]`.
- [ ] Tidak menggunakan `(( ))` sebagai perintah.
- [ ] Tidak menggunakan `function` keyword.
- [ ] Tidak menggunakan `local` (atau gunakan dengan kesadaran).
- [ ] Tidak menggunakan `source` — gunakan `.`.
- [ ] Tidak menggunakan `select`.
- [ ] Tidak menggunakan array.
- [ ] Tidak menggunakan `<<<`.
- [ ] Tidak menggunakan `<( )` atau `>( )`.
- [ ] Tidak menggunakan `$'...'`.
- [ ] Tidak menggunakan brace expansion `{a,b}`.
- [ ] Tidak menggunakan `let`.
- [ ] Tidak menggunakan `$RANDOM`.
- [ ] Tidak menggunakan `set -o pipefail`.
- [ ] Tidak menggunakan `trap ... ERR`.

### Variabel

- [ ] Selalu kutip: `"$var"`.
- [ ] Gunakan `${var}` untuk batas nama.
- [ ] Gunakan `${var:-default}` untuk default.
- [ ] Tidak menggunakan `${var//old/new}`.
- [ ] Tidak menggunakan `${var:offset:length}`.

### Perintah

- [ ] Gunakan `printf` alih-alih `echo` untuk kontrol.
- [ ] Gunakan `=` bukan `==` dalam `[ ]`.
- [ ] Gunakan `-eq`, `-ne`, `-gt`, `-lt`, `-ge`, `-le` untuk angka.
- [ ] Gunakan `command -v` bukan `which`.
- [ ] Gunakan `$(...)` bukan backtick (meskipun keduanya POSIX).
- [ ] Hindari `sed -i`.
- [ ] Hindari `grep -P`, `grep -r`, `grep -w`, `grep -o`.
- [ ] Hindari `find -print0`.
- [ ] Hindari `xargs -0`, `xargs -r`, `xargs -P`, `xargs -I`.

### Utilitas

- [ ] `sed` — gunakan BRE, bukan ERE (atau gunakan `sed -E` jika tersedia).
- [ ] `awk` — gunakan fitur POSIX.
- [ ] `date` — hindari `date -d` (GNU).
- [ ] `stat` — hindari, format berbeda-beda.
- [ ] `readlink -f` — hindari.
- [ ] `mktemp` — gunakan tanpa template.

---

## 4.2.4 Menguji di Berbagai Shell

### Shell yang Perlu Diuji

1. **`dash`** — Shell POSIX minimalis. Default `/bin/sh` di Debian/Ubuntu.
2. **`bash --posix`** — Bash dalam mode POSIX.
3. **`ksh`** — Korn shell.
4. **`busybox sh`** — Shell dalam BusyBox (embedded).
5. **`ash`** — Shell ringan (digunakan di Alpine, router).

### Cara Menguji

**1. Uji dengan `dash`:**

```sh
dash skrip.sh
```

**2. Uji dengan `bash --posix`:**

```sh
bash --posix skrip.sh
```

**3. Uji syntax tanpa eksekusi:**

```sh
sh -n skrip.sh
dash -n skrip.sh
bash -n skrip.sh
```

Penjelasan:

- `-n` – Noexec. Membaca dan memeriksa sintaks tanpa menjalankan.

**4. Uji dengan `busybox`:**

```sh
busybox sh skrip.sh
```

**5. Uji dengan `ksh`:**

```sh
ksh skrip.sh
```

### Perbedaan Perilaku yang Umum

| Fitur | dash | bash | ksh |
|-------|------|------|-----|
| `echo -e` | Tidak | Ya | Ya (bisa beda) |
| `echo -n` | Ya | Ya | Ya |
| `local` | Ya | Ya | Ya |
| `[[ ]]` | Tidak | Ya | Ya |
| Array | Tidak | Ya | Ya |
| `+=` string | Ya (versi baru) | Ya | Ya |
| Process substitution | Tidak | Ya | Ya |
| `$'...'` | Tidak | Ya | Ya |
| `$(< file)` | Ya (dash) | Ya | Ya |
| `trap ERR` | Tidak | Ya | Ya |
| `set -o pipefail` | Tidak | Ya | Ya |

**Catatan:** Perilaku bisa bervariasi antar versi. Selalu uji di sistem target.

---

## 4.2.5 Shebang yang Portabel

### Pilihan Shebang

**1. `#!/bin/sh` — Paling Portabel**

```sh
#!/bin/sh
```

Kelebihan:

- `/bin/sh` dijamin ada di semua sistem Unix-like.
- POSIX mengharuskan `/bin/sh` ada.

Kekurangan:

- Di sistem tertentu, `/bin/sh` adalah symlink ke `dash` (POSIX ketat) — tidak bisa menggunakan bashism.
- Di sistem lain, `/bin/sh` adalah symlink ke `bash` dalam mode POSIX.

**2. `#!/usr/bin/env sh` — Alternatif**

```sh
#!/usr/bin/env sh
```

Kelebihan:

- Mencari `sh` di `PATH`.
- Berguna jika `sh` tidak ada di `/bin/sh` (NixOS, Termux).

Kekurangan:

- `/usr/bin/env` mungkin tidak ada di semua sistem (jarang).
- Jika `PATH` dimodifikasi, bisa menemukan `sh` yang berbeda.

**3. `#!/bin/bash` — Tidak Portabel**

```sh
#!/bin/bash
```

Kelebihan:

- Bisa menggunakan fitur bash.

Kekurangan:

- Tidak ada di sistem minimalis (Alpine, BSD tanpa bash).
- Skrip tidak portabel.

**4. `#!/usr/bin/env bash` — Portabel untuk Bash**

```sh
#!/usr/bin/env bash
```

Kelebihan:

- Mencari bash di `PATH`.
- Bekerja di sistem di mana bash tidak di `/bin/bash` (macOS dengan Homebrew).

Kekurangan:

- Tetap bergantung pada bash.

### Rekomendasi

- **Skrip POSIX:** `#!/bin/sh`.
- **Skrip Bash:** `#!/usr/bin/env bash`.
- **Skrip portabel maksimal:** `#!/bin/sh`.

### Jebakan Shebang

1. **Spasi setelah `#!`:** `#! /bin/sh` — tidak portabel.
2. **Argumen:** `#!/bin/sh -e` — tidak portabel.
3. **CRLF:** `#!/bin/sh\r` — kernel tidak menemukan interpreter.
4. **Path relatif:** `#!sh` — kernel mencari di direktori saat ini, bukan `PATH`.

---

## 4.2.6 Utilitas: Perbedaan GNU vs BSD

Selain shell, **utilitas** juga berbeda antara GNU (Linux) dan BSD (macOS, FreeBSD).

### `sed`

**GNU sed:**

```sh
sed -i 's/foo/bar/' file.txt    # In-place
sed -E 's/(a)/\1/' file.txt     # ERE
```

**BSD sed:**

```sh
sed -i '' 's/foo/bar/' file.txt    # Perlu argumen kosong
sed -E 's/(a)/\1/' file.txt        # ERE (BSD juga mendukung)
```

**POSIX sed:**

```sh
sed 's/foo/bar/' file.txt > file.tmp && mv file.tmp file.txt
sed 's/\(a\)/\1/' file.txt    # BRE
```

Penjelasan:

- `-i` tidak POSIX.
- Untuk edit di tempat portabel: gunakan file temporary + `mv`.

### `date`

**GNU date:**

```sh
date -d "2026-01-01" +%A
date -d "yesterday" +%Y-%m-%d
```

**BSD date:**

```sh
date -j -f "%Y-%m-%d" "2026-01-01" +%A
```

**POSIX date:**

```sh
date +%Y-%m-%d
```

Penjelasan:

- `-d` (GNU) dan `-j -f` (BSD) tidak portabel.
- POSIX `date` hanya mendukung format output, bukan parsing tanggal.

### `grep`

**GNU grep:**

```sh
grep -r "pola" dir/       # Recursive
grep -o "pola" file.txt   # Only matching
grep -w "kata" file.txt   # Word boundary
grep -P "regex" file.txt  # Perl regex
```

**POSIX grep:**

```sh
grep "pola" file.txt
grep -E "pola1|pola2" file.txt
grep -F "literal" file.txt
```

Penjelasan:

- `-r`, `-o`, `-w`, `-P` tidak POSIX.
- Untuk recursive: `find dir/ -type f -exec grep "pola" {} +`.
- Untuk only matching: `sed -n 's/.*\(pola\).*/\1/p'`.

### `find`

**GNU find:**

```sh
find . -name "*.txt" -print0
find . -maxdepth 2 -name "*.txt"
```

**POSIX find:**

```sh
find . -name "*.txt"
find . -name "*.txt" -exec command {} \;
```

Penjelasan:

- `-print0` tidak POSIX.
- `-maxdepth` tidak POSIX. Gunakan `-prune`:
  ```sh
  find . -path './dir' -prune -o -name "*.txt" -print
  ```

### `xargs`

**GNU xargs:**

```sh
xargs -0 -r -P 4 -I {} command {}
```

**POSIX xargs:**

```sh
xargs command
xargs -n 1 command
xargs -I {} command {}
```

Penjelasan:

- `-0`, `-r`, `-P` tidak POSIX.
- `-I` POSIX, tetapi menyebabkan satu item per perintah.

### `stat`

`stat` memiliki format yang berbeda-beda:

```sh
stat -c "%s" file.txt    # GNU
stat -f "%z" file.txt    # BSD
```

**POSIX:** Tidak ada `stat`. Gunakan `ls -l` dan `awk`:

```sh
ls -l file.txt | awk '{ print $5 }'
```

### `readlink`

```sh
readlink -f file.txt    # GNU (resolve symlink)
```

**POSIX:** Tidak ada. Gunakan:

```sh
ls -l file.txt | awk '{ print $NF }'
```

### `mktemp`

```sh
mktemp                    # POSIX: buat file dengan nama acak
mktemp -d                 # Buat direktori
mktemp /tmp/foo.XXXXXX    # Template (GNU)
```

**POSIX:** `mktemp` tanpa argumen. Untuk direktori, `mktemp -d` didukung beberapa implementasi.

---

## 4.2.7 Locale dan Portabilitas

**Locale** mempengaruhi perilaku banyak perintah: `sort`, `grep`, `sed`, `awk`, `tr`, dll.

### Masalah Locale

```sh
echo "A" | tr '[:lower:]' '[:upper:]'
```

Output di locale `en_US.UTF-8`:

```
A
```

Output di locale `tr_TR.UTF-8` (Turki):

```
A
```

Tetapi:

```sh
echo "i" | tr '[:lower:]' '[:upper:]'
```

Output di `en_US`:

```
I
```

Output di `tr_TR`:

```
İ
```

Penjelasan:

- Di Turki, huruf kecil `i` menjadi `İ` (dotted capital I), bukan `I`.
- Ini bisa merusak skrip yang mengandalkan konversi case.

### Solusi: `LC_ALL=C`

```sh
LC_ALL=C tr '[:lower:]' '[:upper:]'
```

Penjelasan:

- `LC_ALL=C` – Set locale ke C (POSIX). Perilaku byte-oriented.
- `tr` sekarang bekerja pada byte, bukan karakter.
- Lebih cepat dan konsisten.

### `sort` dan Locale

```sh
printf "b\na\nB\nA\n" | sort
```

Output di locale `en_US.UTF-8`:

```
a
A
b
B
```

Output di `LC_ALL=C`:

```
A
B
a
b
```

Penjelasan:

- Locale `en_US` mengabaikan case dalam pengurutan.
- Locale `C` mengurutkan berdasarkan nilai byte (ASCII): huruf besar dulu.

### `grep` dan Character Class

```sh
grep "[a-z]" file.txt
```

Di locale `en_US.UTF-8`, `[a-z]` bisa mencakup huruf beraksen. Di `LC_ALL=C`, hanya `a`–`z` ASCII.

**Solusi:** Gunakan `[[:lower:]]` untuk portabilitas, atau `LC_ALL=C` untuk ASCII.

### Rekomendasi

- **Selalu set `LC_ALL=C`** untuk skrip yang melakukan operasi byte-level atau menginginkan konsistensi.
- **Gunakan `[[:class:]]`** daripada `[a-z]` untuk portabilitas locale.
- **Uji di locale berbeda** jika skrip berurusan dengan teks multibahasa.

```sh
#!/bin/sh
LC_ALL=C
export LC_ALL
```

---

## 4.2.8 Lingkungan Terbatas: BusyBox

**BusyBox** adalah kumpulan utilitas Unix dalam satu binary kecil. Digunakan di embedded systems, router, container Alpine.

### Karakteristik BusyBox

- Utilitas mungkin tidak mendukung semua opsi GNU.
- Shell `ash` adalah default.
- Beberapa utilitas mungkin disederhanakan.

### Contoh Perbedaan

**`sed` di BusyBox:**

```sh
# Tidak mendukung -i tanpa argumen
sed -i 's/foo/bar/' file.txt    # Mungkin error
```

**`grep` di BusyBox:**

```sh
# Tidak mendukung -P, -r
grep -r "pola" .    # Mungkin error
```

**`awk` di BusyBox:**

```sh
# Mungkin tidak mendukung semua fungsi
awk '{ print length($0) }' file.txt    # OK
awk 'BEGIN { print systime() }'        # Mungkin tidak
```

**`date` di BusyBox:**

```sh
# Format terbatas
date +%Y-%m-%d    # OK
date -d "yesterday"    # Tidak
```

### Menguji di BusyBox

```sh
# Install busybox (jika belum)
docker run --rm -v "$PWD:/work" -w /work busybox sh skrip.sh

# Atau di sistem dengan busybox
busybox sh skrip.sh
```

### Tips untuk BusyBox

1. Gunakan `printf` bukan `echo -e`.
2. Hindari `grep -r`, gunakan `find | xargs grep`.
3. Hindari `sed -i`, gunakan file temporary.
4. Uji setiap utilitas yang digunakan.
5. Dokumentasikan asumsi.

---

## 4.2.9 `shellcheck` untuk Portabilitas

**ShellCheck** adalah alat analisis statis untuk skrip shell. Ia mendeteksi bug, bashism, dan masalah portabilitas.

### Instalasi

```sh
# Debian/Ubuntu
apt-get install shellcheck

# macOS
brew install shellcheck

# Manual
# Download dari https://github.com/koalaman/shellcheck
```

### Menggunakan ShellCheck untuk POSIX

```sh
shellcheck -s sh skrip.sh
```

Penjelasan:

- `-s sh` – **Shell dialect**. Memberi tahu ShellCheck bahwa target adalah POSIX `sh`.
- ShellCheck akan menandai bashism dengan peringatan.

### Contoh Output

```sh
#!/bin/sh
var="hello"
if [[ "$var" == "hello" ]]; then
    echo "Sama"
fi
```

```sh
$ shellcheck -s sh skrip.sh
In skrip.sh line 3:
if [[ "$var" == "hello" ]]; then
   ^-- SC3010: In POSIX sh, [[ ]] is undefined.
             ^-- SC3014: In POSIX sh, == in place of = is undefined.
```

Penjelasan:

- `SC3010` – `[[ ]]` tidak POSIX.
- `SC3014` – `==` tidak POSIX untuk `[ ]`.

### Kode ShellCheck yang Sering Muncul

| Kode | Arti |
|------|------|
| SC1008 | Shebang tidak dikenal |
| SC2039 | Fitur tidak POSIX |
| SC2086 | Variabel tidak dikutip |
| SC2166 | Gunakan `-a`/`-o` atau `&&`/`\|\|` |
| SC3010 | `[[ ]]` tidak POSIX |
| SC3014 | `==` tidak POSIX |
| SC3028 | `$RANDOM` tidak POSIX |
| SC3045 | `read -p` tidak POSIX |
| SC3054 | Array tidak POSIX |
| SC3060 | `${var//...}` tidak POSIX |

### Mengabaikan Peringatan

Jika Anda sengaja menggunakan fitur non-POSIX:

```sh
# shellcheck disable=SC3010
if [[ "$var" == "hello" ]]; then
    ...
fi
```

### Konfigurasi `.shellcheckrc`

```sh
# .shellcheckrc
shell=sh
disable=SC2086
```

Penjelasan:

- `shell=sh` – Default dialect.
- `disable=SC2086` – Nonaktifkan peringatan tertentu.

---

## 4.2.10 Pustaka Portabel

Membangun pustaka yang dapat digunakan lintas sistem memerlukan disiplin.

### Prinsip Pustaka Portabel

1. **Hanya gunakan POSIX.**
2. **Dokumentasikan asumsi.**
3. **Sediakan fallback untuk fitur opsional.**
4. **Uji di berbagai shell.**

### Contoh Pustaka Portabel: `lib/string.sh`

```sh
# lib/string.sh: Fungsi string portabel.

# Cegah sourcing ganda
if [ -n "${_STRING_SH_LOADED:-}" ]; then
    return 0
fi
_STRING_SH_LOADED=1

# trim: Hapus spasi di awal/akhir.
trim() {
    printf '%s' "$1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# upper: Ubah ke huruf besar.
upper() {
    printf '%s' "$1" | tr '[:lower:]' '[:upper:]'
}

# lower: Ubah ke huruf kecil.
lower() {
    printf '%s' "$1" | tr '[:upper:]' '[:lower:]'
}

# contains: Cek substring.
contains() {
    case "$1" in
        *"$2"*) return 0 ;;
        *) return 1 ;;
    esac
}

# starts_with: Cek awalan.
starts_with() {
    case "$1" in
        "$2"*) return 0 ;;
        *) return 1 ;;
    esac
}

# ends_with: Cek akhiran.
ends_with() {
    case "$1" in
        *"$2") return 0 ;;
        *) return 1 ;;
    esac
}

# repeat: Ulangi string n kali.
repeat() {
    _str="$1"
    _n="$2"
    _i=0
    _result=""
    while [ "$_i" -lt "$_n" ]; do
        _result="${_result}${_str}"
        _i=$((_i + 1))
    done
    printf '%s' "$_result"
}
```

### Contoh Pustaka Portabel: `lib/file.sh`

```sh
# lib/file.sh: Fungsi file portabel.

if [ -n "${_FILE_SH_LOADED:-}" ]; then
    return 0
fi
_FILE_SH_LOADED=1

# file_exists: Cek keberadaan file.
file_exists() {
    [ -f "$1" ]
}

# dir_exists: Cek keberadaan direktori.
dir_exists() {
    [ -d "$1" ]
}

# file_readable: Cek file dapat dibaca.
file_readable() {
    [ -r "$1" ]
}

# file_writable: Cek file dapat ditulis.
file_writable() {
    [ -w "$1" ]
}

# file_empty: Cek file kosong.
file_empty() {
    [ ! -s "$1" ]
}

# file_size: Dapatkan ukuran file dalam byte.
file_size() {
    ls -l "$1" | awk '{ print $5 }'
}

# dirname_of: Dapatkan direktori dari path.
dirname_of() {
    case "$1" in
        */*) printf '%s' "${1%/*}" ;;
        *) printf '.' ;;
    esac
}

# basename_of: Dapatkan nama file dari path.
basename_of() {
    printf '%s' "${1##*/}"
}
```

Penjelasan:

- `dirname` dan `basename` adalah perintah eksternal. `dirname_of` dan `basename_of` menggunakan ekspansi parameter, lebih cepat.
- `file_size` menggunakan `ls -l` + `awk` karena `stat` tidak portabel.

### Menggunakan Pustaka

```sh
#!/bin/sh

SCRIPT_DIR=$(dirname "$0")
LIB_DIR="${SCRIPT_DIR}/lib"

. "${LIB_DIR}/string.sh"
. "${LIB_DIR}/file.sh"

if file_exists "/etc/passwd"; then
    echo "File ada"
    echo "Ukuran: $(file_size /etc/passwd) byte"
fi

nama=$(trim "  Budi  ")
echo "Nama: $(upper "$nama")"
```

**Jebakan:** `dirname "$0"` tidak selalu benar jika skrip dipanggil via symlink atau `PATH`. Untuk solusi yang lebih kuat, lihat Level 4 Materi 5.

---

## 4.2.11 Contoh Skrip Portabel Lengkap

### Skrip 1: Pencarian File Portabel

```sh
#!/bin/sh
# Nama: cari.sh
# Tujuan: Mencari file berdasarkan nama (portabel)

set -u

if [ $# -lt 2 ]; then
    echo "Penggunaan: $0 direktori pola" >&2
    exit 2
fi

DIR="$1"
POLA="$2"

if [ ! -d "$DIR" ]; then
    echo "Error: '$DIR' bukan direktori." >&2
    exit 2
fi

find "$DIR" -type f -name "$POLA" -print
```

Penjelasan:

- Menggunakan `find` POSIX tanpa `-print0`.
- Tidak menggunakan `maxdepth`.
- Nama file dengan newline akan rusak, tetapi ini adalah kompromi portabilitas.

### Skrip 2: Pemroses CSV Portabel

```sh
#!/bin/sh
# Nama: proses_csv.sh
# Tujuan: Memproses CSV dengan awk POSIX

set -u

CSV="${1:?Penggunaan: $0 file.csv}"

if [ ! -r "$CSV" ]; then
    echo "Error: '$CSV' tidak dapat dibaca." >&2
    exit 2
fi

LC_ALL=C awk -F, '
NR == 1 {
    # Header
    for (i = 1; i <= NF; i++) {
        header[i] = $i
    }
    next
}
{
    for (i = 1; i <= NF; i++) {
        printf "%s=%s", header[i], $i
        if (i < NF) printf ", "
    }
    printf "\n"
}
' "$CSV"
```

Penjelasan:

- `LC_ALL=C` – Konsistensi locale.
- `awk -F,` – Field separator koma.
- `NR == 1` – Header.
- Semua fitur POSIX awk.

### Skrip 3: Utility dengan Fallback

```sh
#!/bin/sh
# Nama: portabel_util.sh
# Tujuan: Demonstrasi fallback untuk fitur opsional

set -u

# Cek apakah sed mendukung -E
if echo "test" | sed -E 's/(t)est/\1/' > /dev/null 2>&1; then
    SED_ERE="sed -E"
else
    SED_ERE="sed"
fi

# Cek mktemp -d
if mktemp -d > /dev/null 2>&1; then
    MKTEMP_D="mktemp -d"
else
    MKTEMP_D=""
fi

# Cek command -v
if command -v ls > /dev/null 2>&1; then
    HAS_COMMAND_V=1
else
    HAS_COMMAND_V=0
fi

# Fungsi untuk membuat direktori temporary
buat_tmpdir() {
    if [ -n "$MKTEMP_D" ]; then
        $MKTEMP_D
    else
        # Fallback
        tmpdir="/tmp/skrip.$$"
        mkdir "$tmpdir" || return 1
        printf '%s' "$tmpdir"
    fi
}

TMPDIR=$(buat_tmpdir) || exit 1
trap 'rm -rf "$TMPDIR"' EXIT INT TERM

echo "Temporary directory: $TMPDIR"
```

Penjelasan:

- Deteksi fitur saat runtime.
- Fallback jika fitur tidak tersedia.
- Ini adalah pola yang kuat untuk portabilitas maksimal.

### Skrip 4: Cross-Platform Date

```sh
#!/bin/sh
# Nama: tanggal.sh
# Tujuan: Mendapatkan tanggal kemarin (cross-platform)

set -u

# Coba GNU date
kemarin=$(date -d "yesterday" +%Y-%m-%d 2>/dev/null)

if [ -z "$kemarin" ]; then
    # Coba BSD date
    kemarin=$(date -v -1d +%Y-%m-%d 2>/dev/null)
fi

if [ -z "$kemarin" ]; then
    # Fallback: hitung manual dengan awk
    kemarin=$(awk 'BEGIN {
        t = systime() - 86400
        print strftime("%Y-%m-%d", t)
    }')
fi

echo "Kemarin: $kemarin"
```

Penjelasan:

- Coba `date -d` (GNU).
- Fallback ke `date -v` (BSD).
- Fallback terakhir: `awk` dengan `systime()` dan `strftime()`.
- `strftime` tidak POSIX awk, tetapi didukung banyak implementasi.

---

## 4.2.12 Latihan

1. **Identifikasi Bashism:**
   - Ambil skrip bash sederhana.
   - Identifikasi semua bashism.
   - Konversi ke POSIX.

2. **Uji di Berbagai Shell:**
   - Tulis skrip yang menggunakan `echo -n`.
   - Uji di `dash`, `bash`, `bash --posix`.
   - Bandingkan outputnya.

3. **`[[ ]]` vs `[ ]`:**
   - Tulis kondisi dengan `[[ ]]`.
   - Konversi ke `[ ]`.
   - Uji dengan variabel kosong, spasi, dan karakter khusus.

4. **Shebang:**
   - Tulis skrip dengan `#!/bin/sh`.
   - Jalankan dengan `dash`, `bash --posix`.
   - Ubah ke `#!/bin/bash`, ulangi.

5. **Utilitas:**
   - Coba `sed -i` di macOS dan Linux.
   - Tulis versi portabel dengan file temporary.

6. **Locale:**
   - Jalankan `printf "b\na\nB\nA\n" | sort`.
   - Ulangi dengan `LC_ALL=C`.
   - Bandingkan.

7. **BusyBox:**
   - Install BusyBox (atau gunakan Docker).
   - Uji skrip Anda di BusyBox.

8. **ShellCheck:**
   - Install ShellCheck.
   - Jalankan `shellcheck -s sh` pada skrip Anda.
   - Perbaiki semua peringatan.

9. **Fallback:**
   - Tulis fungsi yang mendeteksi apakah `mktemp -d` tersedia.
   - Jika tidak, gunakan fallback.

10. **Pustaka:**
    - Buat pustaka `lib/math.sh` yang portabel.
    - Berisi fungsi: `tambah`, `kurang`, `kali`, `bagi`.
    - Uji di `dash` dan `bash`.

11. **Skrip Portabel:**
    - Tulis skrip yang membaca file dan mencetak statistik (baris, kata, karakter).
    - Harus berjalan di `dash`, `bash --posix`, `ksh`.
    - Tidak boleh menggunakan `wc` dengan opsi non-POSIX.

12. **Dokumentasi:**
    - Ambil skrip yang Anda tulis.
    - Dokumentasikan asumsi portabilitas.
    - Tandai bagian yang mungkin tidak portabel.

---

## 4.2.13 Ringkasan Materi 2

- **Portabilitas** berarti skrip berjalan di berbagai sistem Unix-like tanpa modifikasi.
- **Bashism** adalah fitur bash yang tidak POSIX: `[[ ]]`, `(( ))`, `local`, `source`, `<<<`, array, `$'...'`, brace expansion, `let`, `$RANDOM`, `set -o pipefail`, `trap ERR`.
- **Checklist POSIX**: tidak menggunakan `[[ ]]`, `(( ))`, `function`, `source`, `select`, array, `<<<`, `<( )`, `$'...'`.
- **Shebang `#!/bin/sh`** adalah yang paling portabel.
- **Utilitas** berbeda antara GNU dan BSD: `sed -i`, `date -d`, `grep -r`, `grep -o`, `find -print0`, `xargs -0`, `stat`, `readlink -f`.
- **Locale** mempengaruhi `sort`, `grep`, `tr`. Gunakan `LC_ALL=C` untuk konsistensi.
- **BusyBox** adalah lingkungan terbatas dengan utilitas yang disederhanakan.
- **ShellCheck** dengan `-s sh` mendeteksi bashism dan masalah portabilitas.
- **Pustaka portabel** menggunakan hanya fitur POSIX, dengan fallback untuk fitur opsional.
- **Uji di berbagai shell**: `dash`, `bash --posix`, `ksh`, `busybox sh`.
- **Dokumentasikan asumsi** portabilitas skrip Anda.

---

## 📌 Selanjutnya

Materi 2 Level 4 selesai. Anda sekarang menguasai portabilitas secara mendalam.

Berikutnya adalah **Materi 3: Debugging** — kita akan membahas:

- `set -x` (xtrace) dan `set -v` (verbose).
- `PS4` — prompt tracing.
- `trap ERR` dan `trap DEBUG`.
- `set -n` untuk syntax check.
- `shellcheck` untuk debugging statis.
- Teknik tracing dengan `echo` dan `tee`.
- `bash -x` vs `sh -x`.
- Debugging pipeline dan subshell.
- Strategi debugging sistematis.

## Materi 3: Debugging

> **Catatan:** Ini adalah **materi ketiga** dari Level 4, sesuai kurikulum yang sudah ditetapkan. Kita akan membahas cara menemukan dan memperbaiki bug di skrip shell secara sistematis. Setelah materi ini, Anda tidak akan lagi "menebak-nebak" mengapa skrip gagal — Anda akan memiliki metodologi yang terstruktur untuk melacak, mengisolasi, dan memperbaiki masalah.

---

## 🎯 Tujuan Materi 3

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Mengaktifkan **`set -x`** (xtrace) untuk melacak eksekusi.
2. Menggunakan **`set -v`** (verbose) untuk melihat input mentah.
3. Mengustomisasi **`PS4`** untuk tracing yang informatif.
4. Menguasai **`trap ERR`** dan **`trap DEBUG`** (dengan catatan portabilitas).
5. Menggunakan **`set -n`** untuk syntax check tanpa eksekusi.
6. Memanfaatkan **`shellcheck`** sebagai alat debugging statis.
7. Melakukan tracing manual dengan `echo` dan `tee`.
8. Membandingkan **`bash -x`**, **`sh -x`**, dan **`dash -x`**.
9. Mendebug **pipeline** dan **subshell** yang bermasalah.
10. Menerapkan **strategi debugging sistematis** untuk masalah kompleks.
11. Menggunakan **`strace`** dan **`ltrace`** (opsional, tidak POSIX) untuk debugging tingkat rendah.

---

## 4.3.1 Filosofi Debugging di Shell

Debugging shell berbeda dari debugging di bahasa pemrograman modern. Tidak ada IDE dengan breakpoint, tidak ada debugger interaktif (kecuali `bash -x` dengan `DEBUG` trap). Yang ada:

1. **Tracing** — Melihat setiap perintah yang dieksekusi.
2. **Logging** — Mencatat nilai variabel dan alur.
3. **Analisis statis** — `shellcheck` menemukan masalah tanpa menjalankan.
4. **Isolasi** — Memperkecil masalah dengan mengurangi skrip.
5. **Reproduksi** — Membuat kasus uji yang konsisten.

**Prinsip debugging:**

> **"Bagi dua, uji, ulangi."**

Kurangi ruang pencarian dengan membagi skrip menjadi bagian-bagian, uji setiap bagian, dan fokus pada bagian yang bermasalah.

---

## 4.3.2 `set -x` — Xtrace

`set -x` (xtrace) membuat shell mencetak setiap perintah yang dieksekusi ke stderr, **setelah** ekspansi.

### Contoh Sederhana

```sh
#!/bin/sh

nama="Budi"
umur=25

set -x
echo "Halo, $nama"
echo "Umur: $umur"
set +x

echo "Selesai"
```

Output ke stderr:

```
+ echo 'Halo, Budi'
Halo, Budi
+ echo 'Umur: 25'
Umur: 25
+ set +x
Selesai
```

Penjelasan:

- `set -x` – Aktifkan xtrace.
- `+ ` – Prefix default dari xtrace (diatur oleh `PS4`).
- `echo 'Halo, Budi'` – Perintah **setelah** ekspansi. Perhatikan `$nama` sudah menjadi `Budi`.
- `set +x` – Nonaktifkan xtrace.
- Baris setelah `set +x` tidak ditrace.

### Mengaktifkan dari Command Line

```sh
sh -x skrip.sh
```

Penjelasan:

- `-x` – Opsi shell untuk xtrace.
- Skrip dijalankan dengan tracing aktif dari awal.

Anda bisa juga:

```sh
bash -x skrip.sh
dash -x skrip.sh
```

### Mengaktifkan Hanya untuk Bagian Tertentu

```sh
#!/bin/sh

fungsi_kompleks() {
    set -x
    # Bagian yang ingin di-trace
    ...
    set +x
    # Bagian lain
}
```

Penjelasan:

- Aktifkan tracing hanya di bagian yang bermasalah.
- Output lebih sedikit, lebih mudah dibaca.

### Tracing dengan Fungsi

```sh
#!/bin/sh

proses() {
    set -x
    a=5
    b=3
    hasil=$((a + b))
    set +x
    echo "$hasil"
}

proses
```

Output ke stderr:

```
+ a=5
+ b=3
+ hasil=8
+ set +x
```

### Jebakan `set -x`

**1. Output ke stderr, bukan stdout:**

```sh
sh -x skrip.sh > out.txt
```

`out.txt` berisi output normal. Tracing tetap muncul di terminal.

Untuk menangkap tracing:

```sh
sh -x skrip.sh 2> trace.txt
```

**2. Tracing terlalu verbose:**

Untuk skrip panjang, output bisa ribuan baris. Gunakan `PS4` untuk menambahkan konteks, atau aktifkan hanya di bagian tertentu.

**3. Nilai variabel besar:**

Jika variabel berisi string panjang, tracing bisa membanjiri terminal. Ini tidak bisa dihindari dengan `set -x`.

---

## 4.3.3 `set -v` — Verbose

`set -v` (verbose) membuat shell mencetak setiap baris **input** yang dibaca, **sebelum** ekspansi.

### Perbedaan `-x` dan `-v`

```sh
#!/bin/sh
nama="Budi"
set -v
echo "Halo, $nama"
set +v
```

Output dengan `-v`:

```
echo "Halo, $nama"
Halo, Budi
```

Penjelasan:

- `-v` mencetak baris **mentah**: `echo "Halo, $nama"` (dengan `$nama` belum diekspansi).
- `-x` mencetak baris **setelah ekspansi**: `+ echo 'Halo, Budi'`.

### Kapan Menggunakan `-v`?

- Untuk melihat perintah asli yang dieksekusi.
- Untuk memeriksa apakah loop membaca baris yang benar.
- Untuk melihat apakah here document diproses dengan benar.

### `-v` dan `-x` Bersamaan

```sh
sh -vx skrip.sh
```

Penjelasan:

- `-vx` – Aktifkan verbose dan xtrace.
- Output ganda: baris mentah dan baris setelah ekspansi.

Berguna untuk debugging mendalam, tetapi sangat verbose.

---

## 4.3.4 `PS4` — Prompt Tracing

`PS4` adalah variabel yang mengontrol prefix xtrace. Default-nya `+ `.

### Mengubah `PS4`

```sh
#!/bin/sh
PS4='+ ${LINENO}: '
set -x
echo "Halo"
set +x
```

Output:

```
+ 4: echo Halo
Halo
```

Penjelasan:

- `LINENO` – Nomor baris saat ini.
- `+ 4: ` – Prefix dengan nomor baris.
- Membantu menemukan baris mana yang menghasilkan output.

### `PS4` dengan Nama Fungsi (Bash, tidak POSIX)

```sh
PS4='+ ${FUNCNAME[0]:-main}:${LINENO}: '
```

Penjelasan:

- `${FUNCNAME[0]}` – Nama fungsi saat ini (bash).
- `:-main` – Default jika tidak dalam fungsi.
- **Tidak POSIX.**

### `PS4` Portabel

```sh
PS4='+ [${LINENO}] '
```

Penjelasan:

- Hanya `LINENO` yang portabel.
- Tidak ada nama fungsi portabel.

### Contoh `PS4` Informatif

```sh
#!/bin/sh
PS4='+${LINENO}:${0##*/}: '
set -x

fungsi() {
    echo "Dalam fungsi"
}

echo "Mulai"
fungsi
echo "Selesai"
```

Output:

```
+8:skrip.sh: echo Mulai
Mulai
+9:skrip.sh: fungsi
+5:skrip.sh: echo 'Dalam fungsi'
Dalam fungsi
+10:skrip.sh: echo Selesai
Selesai
```

Penjelasan:

- `8`, `9`, `10` – Nomor baris.
- `skrip.sh` – Nama skrip (dari `$0`).
- Memudahkan pelacakan alur.

### Menyimpan `PS4` Lama

```sh
OLD_PS4="$PS4"
PS4='+ ${LINENO}: '
set -x
# ...
set +x
PS4="$OLD_PS4"
```

---

## 4.3.5 `trap ERR` — Tidak POSIX

`trap ERR` menjalankan handler ketika perintah gagal (exit code non-zero).

### Contoh

```sh
#!/bin/bash
# Perhatikan: #!/bin/bash, bukan #!/bin/sh

trap 'echo "Error di baris $LINENO: $BASH_COMMAND"' ERR

false
echo "Tidak akan tercetak jika set -e"
```

Output:

```
Error di baris 6: false
```

Penjelasan:

- `trap ... ERR` – Bashism. Tidak POSIX.
- `LINENO` – Nomor baris.
- `BASH_COMMAND` – Perintah yang gagal.
- Hanya berfungsi di bash.

### Alternatif POSIX

POSIX tidak memiliki `trap ERR`. Gunakan:

**1. Fungsi wrapper:**

```sh
run() {
    "$@"
    status=$?
    if [ "$status" -ne 0 ]; then
        echo "Error: '$*' gagal dengan status $status" >&2
    fi
    return "$status"
}

run false
```

**2. `set -e` dengan trap EXIT:**

```sh
#!/bin/sh

trap 'echo "Error di baris sekitar $LINENO"' EXIT

set -e
false
echo "Tidak akan tercetak"
```

Penjelasan:

- `set -e` menyebabkan skrip keluar.
- `trap EXIT` dijalankan saat keluar, termasuk karena error.
- `LINENO` mungkin tidak akurat di semua shell.

**3. Periksa manual:**

```sh
if ! false; then
    echo "Error" >&2
fi
```

---

## 4.3.6 `trap DEBUG` — Tidak POSIX

`trap DEBUG` menjalankan handler **sebelum setiap perintah**. Ini seperti xtrace tetapi dengan kode kustom.

### Contoh (Bash)

```sh
#!/bin/bash

trap 'echo "DEBUG: $BASH_COMMAND"' DEBUG

echo "Halo"
nama="Budi"
echo "$nama"
```

Output:

```
DEBUG: echo "Halo"
Halo
DEBUG: nama="Budi"
DEBUG: echo "$nama"
Budi
```

Penjelasan:

- Handler dijalankan sebelum setiap perintah.
- Berguna untuk logging kustom.
- **Tidak POSIX.**

### Alternatif POSIX

Tidak ada. Gunakan `set -x` atau logging manual.

---

## 4.3.7 `set -n` — Syntax Check (Noexec)

`set -n` (noexec) membuat shell membaca skrip dan memeriksa sintaks **tanpa mengeksekusi**.

### Contoh

```sh
sh -n skrip.sh
```

Penjelasan:

- `-n` – Noexec. Periksa sintaks saja.
- Jika ada error sintaks, pesan error dicetak.
- Tidak ada perintah yang dijalankan.

### Contoh Skrip dengan Error

```sh
#!/bin/sh

if [ -f "file" ]; then
    echo "Ada"
# Lupa fi
```

```sh
$ sh -n skrip.sh
skrip.sh: 6: Syntax error: end of file unexpected (expecting "fi")
```

Penjelasan:

- Shell menemukan error sintaks dan melaporkannya.
- Baris 6 – Baris di mana error terdeteksi.

### Keterbatasan `set -n`

`set -n` hanya memeriksa **sintaks**, bukan **semantik**:

```sh
#!/bin/sh
echo "$undefined_variable"    # Sintaks OK, tapi runtime error
```

`sh -n` tidak akan menangkap ini.

### Menggunakan `-n` di Dalam Skrip

```sh
#!/bin/sh

if [ "$1" = "--check" ]; then
    set -n
fi

# Sisa skrip
echo "Halo"
```

Penjelasan:

- Jika argumen `--check`, aktifkan noexec.
- Skrip tidak akan mengeksekusi apa pun setelah `set -n`, hanya memeriksa sintaks.

---

## 4.3.8 `shellcheck` — Analisis Statis

`shellcheck` adalah alat yang menganalisis skrip tanpa menjalankannya. Ia menemukan bug, bashism, dan masalah portabilitas.

### Instalasi

```sh
# Debian/Ubuntu
apt-get install shellcheck

# macOS
brew install shellcheck

# Alpine
apk add shellcheck

# Fedora
dnf install ShellCheck
```

### Contoh Penggunaan

```sh
shellcheck skrip.sh
shellcheck -s sh skrip.sh
shellcheck -S warning skrip.sh
```

Penjelasan:

- `-s sh` – Tentukan shell dialect (POSIX sh).
- `-S warning` – Set severity minimum (error, warning, info, style).

### Contoh Output

```sh
#!/bin/sh
nama=$1
echo "Halo, $nama"
if [ $nama == "Budi" ]; then
    echo "Hai Budi"
fi
```

```sh
$ shellcheck -s sh skrip.sh

In skrip.sh line 3:
echo "Halo, $nama"
             ^-- SC2086: Double quote to prevent globbing and word splitting.

In skrip.sh line 4:
if [ $nama == "Budi" ]; then
        ^-- SC2086: Double quote to prevent globbing and word splitting.
              ^-- SC3014: In POSIX sh, == in place of = is undefined.
```

### Kode ShellCheck Penting

| Kode | Arti |
|------|------|
| SC1008 | Shebang tidak dikenal |
| SC2006 | Gunakan `$(...)` bukan backtick |
| SC2039 | Fitur tidak POSIX |
| SC2046 | Kutip untuk mencegah word splitting |
| SC2086 | Variabel tidak dikutip |
| SC2116 | `echo $(cmd)` — gunakan `cmd` saja |
| SC2164 | `cd` tanpa cek error |
| SC2181 | Cek `$?` daripada langsung `if` |
| SC3010 | `[[ ]]` tidak POSIX |
| SC3014 | `==` tidak POSIX |
| SC3045 | `read -p` tidak POSIX |
| SC3054 | Array tidak POSIX |

### Mengabaikan Peringatan Tertentu

```sh
# shellcheck disable=SC2086
echo $var
```

Atau di `.shellcheckrc`:

```
shell=sh
disable=SC2086,SC2046
```

### `shellcheck` untuk Debugging

`shellcheck` menemukan bug **sebelum** skrip dijalankan:

1. **Variabel tidak dikutip** — Sumber bug paling umum.
2. **Variabel tidak terdefinisi** — Penggunaan `$undefined`.
3. **Bashism** — Fitur non-POSIX.
4. **Perintah tidak ada** — Misalnya typo.
5. **Logika salah** — Misalnya `[ $a = $b ]` dengan `$a` kosong.

**Jadikan `shellcheck` bagian dari alur kerja Anda.** Jalankan sebelum commit, sebelum deploy, dan setelah setiap perubahan.

---

## 4.3.9 Tracing Manual dengan `echo` dan `tee`

Ketika `set -x` terlalu verbose atau tidak memberikan informasi yang cukup, gunakan tracing manual.

### Strategi 1: Echo Strategis

```sh
#!/bin/sh

echo "DEBUG: Mulai skrip" >&2
nama="$1"
echo "DEBUG: nama=$nama" >&2
# ...
```

Penjelasan:

- `>&2` – Kirim ke stderr agar tidak mengganggu stdout.
- Cetak nilai variabel di titik-titik kunci.

### Strategi 2: Fungsi Debug

```sh
#!/bin/sh

debug() {
    [ -n "${DEBUG:-}" ] || return 0
    echo "DEBUG: $*" >&2
}

debug "Mulai skrip"
nama="$1"
debug "nama=$nama"
debug "Proses selesai"
```

Penjelasan:

- `[ -n "${DEBUG:-}" ] || return 0` – Jika `DEBUG` kosong, tidak melakukan apa-apa.
- Aktifkan dengan `DEBUG=1 ./skrip.sh`.

### Strategi 3: `tee` untuk Melihat Aliran Data

```sh
cat file.txt | tee /tmp/debug.txt | grep "error"
```

Penjelasan:

- `tee` – Menulis ke file **dan** meneruskan ke pipe.
- `/tmp/debug.txt` – Menyimpan data yang melalui pipe.
- Berguna untuk melihat data di tengah pipeline.

### Strategi 4: Bisect Pipeline

```sh
# Pipeline asli
cat file.txt | grep "error" | awk '{ print $1 }' | sort -u
```

Jika hasilnya salah, bagi pipeline:

```sh
cat file.txt | grep "error"
cat file.txt | grep "error" | awk '{ print $1 }'
cat file.txt | grep "error" | awk '{ print $1 }' | sort -u
```

Penjelasan:

- Uji setiap tahap secara terpisah.
- Temukan tahap yang menghasilkan output tidak terduga.

### Strategi 5: Simpan Output ke File

```sh
#!/bin/sh

LOG="/tmp/skrip_debug.log"

{
    echo "Mulai: $(date)"
    echo "Argumen: $@"
    echo "PWD: $PWD"
    # ...
} >> "$LOG"
```

Penjelasan:

- Kumpulkan semua informasi debug di satu file.
- Analisis setelah skrip selesai.

---

## 4.3.10 Membandingkan Shell Tracing

Setiap shell memiliki perilaku tracing yang sedikit berbeda.

### `sh -x` vs `bash -x` vs `dash -x`

```sh
#!/bin/sh
nama="Budi"
echo "Halo, $nama"
```

**`sh -x` (bash sebagai sh):**

```
+ nama=Budi
+ echo 'Halo, Budi'
Halo, Budi
```

**`dash -x`:**

```
+ nama=Budi
+ echo Halo, Budi
Halo, Budi
```

**`bash -x`:**

```
+ nama=Budi
+ echo 'Halo, Budi'
Halo, Budi
```

**Perbedaan:**

- `bash` menambahkan kutip tunggal pada argumen.
- `dash` tidak.
- Ini mempengaruhi keterbacaan, bukan fungsionalitas.

### `bash -x` dengan `PS4`

```sh
PS4='+ ${BASH_SOURCE}:${LINENO}: ' bash -x skrip.sh
```

Penjelasan:

- `BASH_SOURCE` – File sumber (bash).
- Menampilkan file dan nomor baris.
- **Tidak POSIX.**

### Perbedaan `-x` pada Pipeline

```sh
echo "a" | grep "b" | wc -l
```

**Bash `-x`:**

```
+ echo a
+ grep b
+ wc -l
0
```

**Dash `-x`:**

```
+ echo a
+ grep b
+ wc -l
0
```

Sama untuk pipeline sederhana. Perbedaan muncul dengan subshell dan fungsi.

---

## 4.3.11 Mendebug Pipeline

Pipeline adalah sumber bug yang umum karena:

1. **Subshell** — Variabel tidak bertahan.
2. **Exit status** — Hanya exit status perintah terakhir.
3. **Buffering** — Output bisa tertunda.
4. **stderr** — Tidak melalui pipe.

### Masalah 1: Variabel Hilang

```sh
count=0
echo "a" | while read -r line; do
    count=$((count + 1))
done
echo "$count"    # 0, bukan 1
```

**Debugging:**

```sh
set -x
count=0
echo "a" | while read -r line; do
    count=$((count + 1))
    echo "DEBUG: count=$count" >&2
done
echo "Setelah: count=$count"
```

Output:

```
+ count=0
+ echo a
+ while read -r line
+ count=1
DEBUG: count=1
+ while read -r line
+ echo Setelah: count=0
Setelah: count=0
```

Penjelasan:

- Di dalam loop, `count` menjadi 1.
- Setelah loop, `count` kembali 0.
- Ini konfirmasi bahwa loop berjalan di subshell.

**Solusi:** Redirection alih-alih pipe.

```sh
count=0
while read -r line; do
    count=$((count + 1))
done <<EOF
a
EOF
echo "$count"    # 1
```

### Masalah 2: Exit Status Pipeline

```sh
false | true
echo "$?"    # 0
```

**Debugging:**

```sh
false | true
echo "Status: $?"
```

Untuk melihat status setiap perintah:

```sh
{ false; echo "false: $?" >&2; } | { true; echo "true: $?" >&2; }
```

### Masalah 3: stderr Tidak Melalui Pipe

```sh
perintah 2>&1 | grep "error"
```

Penjelasan:

- `2>&1` – Gabungkan stderr ke stdout sebelum pipe.
- Sekarang stderr melalui pipe.

**Jebakan:**

```sh
perintah | grep "error" 2>&1
```

Ini mengarahkan stderr `grep` ke stdout, bukan stderr `perintah`.

### Masalah 4: Buffering

Output dari program yang di-pipe bisa di-buffer, menyebabkan keterlambatan.

```sh
tail -f log.txt | grep "error"
```

Output `grep` mungkin tertunda karena buffering.

**Solusi:** `grep --line-buffered` (GNU):

```sh
tail -f log.txt | grep --line-buffered "error"
```

**Tidak POSIX.** Untuk POSIX, tidak ada solusi mudah. Gunakan `awk` dengan `fflush()`.

---

## 4.3.12 Mendebug Subshell

Subshell adalah sumber kebingungan karena:

1. **Variabel tidak bertahan.**
2. **Exit code berbeda.**
3. **Sinyal tidak diwariskan.**

### Cara Mendeteksi Subshell

```sh
#!/bin/sh

echo "PID: $$"
( echo "PID dalam subshell: $$" )
```

Output:

```
PID: 1234
PID dalam subshell: 1234
```

Penjelasan:

- `$$` di dalam subshell **sama** dengan induk di sebagian shell.
- Untuk melihat PID sebenarnya, gunakan `$BASHPID` (bash) atau `sh -c 'echo $$'`.

**Cara portabel:**

```sh
echo "PID induk: $$"
sh -c 'echo "PID anak: $$"'
```

Output:

```
PID induk: 1234
PID anak: 1235
```

### Debugging Subshell dengan `set -x`

```sh
#!/bin/sh
set -x

echo "Sebelum"
(
    echo "Dalam subshell"
    false
    echo "Setelah false"
)
echo "Setelah subshell"
```

Output:

```
+ echo Sebelum
Sebelum
+ (
+ echo 'Dalam subshell'
Dalam subshell
+ false
+ echo 'Setelah false'
Setelah false
+ )
+ echo 'Setelah subshell'
Setelah subshell
```

Penjelasan:

- `( ... )` – Subshell. Tracing menampilkan `+ (` dan `+ )`.
- `false` di dalam subshell **tidak** menyebabkan shell induk keluar (tanpa `set -e`).

### Debugging Variabel Hilang

```sh
#!/bin/sh

hasil=$(false)
echo "Status: $?"
```

Penjelasan:

- `$(false)` – Command substitution di subshell.
- `$?` setelah `hasil=$(false)` adalah exit code **assignment**, bukan `false`.
- Untuk menangkap exit code `false`:

```sh
hasil=$(false)
status=$?
echo "Status: $status"    # 1
```

Tunggu — sebenarnya `hasil=$(false)` menghasilkan `$?` = 1 di sebagian shell. Perilaku ini **tidak konsisten**. Untuk aman:

```sh
hasil=$(false; echo "status=$?" > /tmp/status.$$)
status=$(cat /tmp/status.$$)
rm -f /tmp/status.$$
```

Rumit. Lebih baik hindari.

---

## 4.3.13 Strategi Debugging Sistematis

Berikut adalah metodologi yang dapat Anda terapkan untuk masalah apa pun.

### Langkah 1: Reproduksi Masalah

Buat kasus uji yang **konsisten**:

```sh
#!/bin/sh
# test.sh — Kasus uji minimal

# Set kondisi yang sama
cd /tmp
export LANG=C
# ... input yang sama ...
./skrip.sh arg1 arg2
```

Penjelasan:

- Isolasi variabel: locale, direktori, environment.
- Pastikan masalah dapat direproduksi.

### Langkah 2: Baca Pesan Error

Pesan error sering memberi petunjuk:

```
skrip.sh: 15: [: missing ]
```

- Baris 15.
- `[` tanpa `]`.
- Perbaiki.

```
skrip.sh: 20: foo: not found
```

- Baris 20.
- Perintah `foo` tidak ada.
- Cek typo atau `PATH`.

### Langkah 3: Perkecil Masalah

Buat versi minimal yang masih menunjukkan bug:

```sh
#!/bin/sh
# Ambil hanya bagian yang bermasalah
var=""
[ $var = "x" ]    # Error
```

### Langkah 4: Aktifkan Tracing

```sh
sh -x skrip_minimal.sh
```

### Langkah 5: Periksa Asumsi

Tulis asumsi Anda dan verifikasi:

```sh
echo "PWD: $PWD" >&2
echo "PATH: $PATH" >&2
echo "File ada: $(test -f "$file" && echo yes || echo no)" >&2
```

### Langkah 6: Uji di Shell Berbeda

```sh
dash skrip.sh
bash --posix skrip.sh
ksh skrip.sh
```

Jika berhasil di satu shell tetapi gagal di shell lain, kemungkinan bashism.

### Langkah 7: Gunakan `shellcheck`

```sh
shellcheck -s sh skrip.sh
```

### Langkah 8: Cari Bantuan

- Dokumentasi `man`.
- Stack Overflow.
- Forum.
- Diskusikan masalah dengan orang lain — menjelaskan sering membantu menemukan solusi.

### Langkah 9: Perbaiki dan Uji Ulang

Setelah perbaikan:

1. Uji kasus asli.
2. Uji kasus tepi (empty input, input dengan spasi, dll).
3. Uji di shell lain.
4. Jalankan `shellcheck` lagi.

### Langkah 10: Dokumentasikan

Tambahkan komentar di skrip tentang bug yang ditemukan dan mengapa perbaikannya demikian. Ini membantu di masa depan.

---

## 4.3.14 `strace` dan `ltrace` — Tingkat Rendah

**`strace`** dan **`ltrace`** melacak **system call** dan **library call**. Ini adalah alat tingkat rendah yang berguna ketika tracing shell tidak cukup.

**Catatan:** `strace` hanya Linux. `ltrace` juga. **Tidak POSIX.**

### `strace` — Trace System Calls

```sh
strace -f -o trace.txt sh skrip.sh
```

Penjelasan:

- `-f` – Follow fork (termasuk proses anak).
- `-o trace.txt` – Tulis ke file.
- `sh skrip.sh` – Perintah yang dijalankan.

Output `trace.txt` berisi semua syscall: `open`, `read`, `write`, `execve`, dll.

### Contoh: Debugging File Tidak Ditemukan

```sh
strace -e openat sh skrip.sh 2>&1 | grep "ENOENT"
```

Penjelasan:

- `-e openat` – Hanya lacak syscall `openat`.
- `grep "ENOENT"` – Filter "No such file or directory".
- Menemukan file apa yang gagal dibuka.

### `ltrace` — Trace Library Calls

```sh
ltrace sh skrip.sh
```

Penjelasan:

- Melacak panggilan ke library C (misalnya `malloc`, `strlen`).
- Berguna untuk debugging program C, kurang berguna untuk skrip shell.

### Kapan Menggunakan `strace`?

- Ketika skrip gagal tanpa pesan error yang jelas.
- Ketika perintah tidak ditemukan meskipun ada di `PATH`.
- Ketika file tidak ditemukan meskipun path benar.
- Ketika ada masalah izin.

---

## 4.3.15 Contoh Debugging Nyata

### Kasus 1: Variabel Kosong

**Skrip:**

```sh
#!/bin/sh

file="$1"

if [ $file = "penting.txt" ]; then
    echo "File penting!"
fi
```

**Gejala:**

```sh
$ ./skrip.sh
./skrip.sh: 5: [: =: unexpected operator
```

**Debugging:**

1. **Baca error:** `[: =: unexpected operator`. `[` menerima `=`, bukan string.
2. **Analisis:** `$file` kosong, sehingga `[ = "penting.txt" ]` — hanya tiga argumen setelah `[`, `test` bingung.
3. **Perbaiki:** Kutip variabel.

```sh
if [ "$file" = "penting.txt" ]; then
```

**Pelajaran:** Selalu kutip variabel dalam `[ ]`.

### Kasus 2: Loop Tidak Berjalan

**Skrip:**

```sh
#!/bin/sh

for file in $(ls *.txt); do
    echo "File: $file"
done
```

**Gejala:** File dengan spasi tidak diproses.

**Debugging:**

1. **Aktifkan tracing:**

```sh
sh -x skrip.sh
```

Output:

```
+ ls *.txt
+ for file in $(ls *.txt)
+ echo 'File: my'
File: my
+ echo 'File: document.txt'
File: document.txt
```

2. **Analisis:** `$(ls)` dipecah oleh word splitting.
3. **Perbaiki:**

```sh
for file in *.txt; do
    echo "File: $file"
done
```

**Pelajaran:** Gunakan globbing, bukan `$(ls)`.

### Kasus 3: Exit Code Pipeline

**Skrip:**

```sh
#!/bin/sh

grep "error" log.txt | wc -l
echo "Status: $?"
```

**Gejala:** Status selalu 0, meskipun `grep` gagal.

**Debugging:**

1. **Analisis:** Exit status pipeline adalah exit status perintah terakhir (`wc`).
2. **Perbaiki:** Periksa `grep` secara terpisah.

```sh
if grep -q "error" log.txt; then
    echo "Ada error"
else
    echo "Tidak ada error"
fi
```

**Pelajaran:** Exit status pipeline hanya perintah terakhir.

### Kasus 4: Path dengan Spasi

**Skrip:**

```sh
#!/bin/sh

DIR="/path dengan spasi"
cd $DIR
```

**Gejala:**

```
cd: too many arguments
```

**Debugging:**

1. **Tracing:**

```sh
+ cd /path dengan spasi
```

2. **Analisis:** `$DIR` dipecah menjadi tiga argumen.
3. **Perbaiki:**

```sh
cd "$DIR"
```

**Pelajaran:** Kutip path yang mengandung spasi.

### Kasus 5: Subshell Variabel

**Skrip:**

```sh
#!/bin/sh

count=0
cat file.txt | while read -r line; do
    count=$((count + 1))
done
echo "Baris: $count"
```

**Gejala:** Output `0`.

**Debugging:**

1. **Analisis:** Loop di sisi kanan pipe berjalan di subshell.
2. **Perbaiki:**

```sh
count=0
while read -r line; do
    count=$((count + 1))
done < file.txt
echo "Baris: $count"
```

**Pelajaran:** Pipe membuat subshell; gunakan redirection.

### Kasus 6: `if` Selalu True

**Skrip:**

```sh
#!/bin/sh

if [ "$1" = "start" ]; then
    echo "Memulai"
fi
```

**Gejala:** Selalu "Memulai" meskipun argumen bukan "start".

**Debugging:**

1. **Cek nilai:**

```sh
echo "Argumen: [$1]" >&2
```

Output: `Argumen: [start]` — tapi seharusnya tidak.

2. **Analisis:** `$1` mengandung karakter tak terlihat? Gunakan `od`:

```sh
printf '%s' "$1" | od -c
```

Output:

```
0000000   s   t   a   r   t  \r  \n
```

Ada `\r` (CRLF) di akhir!

3. **Perbaiki:** Hapus `\r` dari input, atau konversi file.

**Pelajaran:** File CRLF dapat menyebabkan bug tersembunyi.

---

## 4.3.16 Latihan

1. **Tracing Dasar:**
   - Tulis skrip dengan beberapa variabel dan perintah.
   - Jalankan dengan `sh -x`.
   - Jelaskan setiap baris output.

2. **`PS4`:**
   - Ubah `PS4` untuk menyertakan nomor baris.
   - Jalankan skrip dengan `set -x`.
   - Bandingkan dengan `PS4` default.

3. **`set -v` vs `set -x`:**
   - Tulis skrip yang menggunakan ekspansi variabel.
   - Jalankan dengan `set -v` dan `set -x`.
   - Bandingkan outputnya.

4. **`shellcheck`:**
   - Install `shellcheck`.
   - Jalankan pada skrip Anda.
   - Perbaiki semua peringatan.

5. **Debugging Pipeline:**
   - Buat pipeline yang menghasilkan output tidak terduga.
   - Debug dengan `tee` dan `set -x`.
   - Identifikasi masalahnya.

6. **Debugging Subshell:**
   - Tulis skrip yang menggunakan `$( )` atau pipe.
   - Coba modifikasi variabel di dalam.
   - Debug mengapa variabel tidak bertahan.

7. **Kasus CRLF:**
   - Buat file dengan CRLF (gunakan `printf 'baris\r\n'`).
   - Baca dengan `read`.
   - Debug mengapa ada `\r` di akhir.

8. **Debugging Sistematis:**
   - Ambil skrip yang memiliki bug.
   - Terapkan 10 langkah debugging.
   - Dokumentasikan prosesnya.

9. **`strace`:**
   - Gunakan `strace -e openat` pada skrip sederhana.
   - Identifikasi file yang dibuka.
   - Temukan file yang gagal dibuka.

10. **Reproduksi Bug:**
    - Buat skrip yang bug hanya muncul di kondisi tertentu (misalnya locale, waktu, input tertentu).
    - Buat skrip reproduksi minimal.

11. **Fungsi Debug:**
    - Tulis fungsi `debug` yang hanya mencetak jika `DEBUG` di-set.
    - Gunakan di skrip.
    - Uji dengan dan tanpa `DEBUG=1`.

12. **Logging untuk Debugging:**
    - Tulis skrip yang mencatat setiap langkah ke file log.
    - Sertakan timestamp, PID, dan pesan.
    - Analisis log setelah skrip selesai.

---

## 4.3.17 Ringkasan Materi 3

- **`set -x`** (xtrace) mencetak setiap perintah **setelah** ekspansi ke stderr.
- **`set -v`** (verbose) mencetak setiap baris **mentah** sebelum ekspansi.
- **`PS4`** mengontrol prefix xtrace; gunakan `${LINENO}` untuk nomor baris.
- **`trap ERR`** dan **`trap DEBUG`** tidak POSIX; hanya bash.
- **`set -n`** memeriksa sintaks tanpa eksekusi.
- **`shellcheck`** adalah alat analisis statis yang wajib digunakan.
- **Tracing manual** dengan `echo` dan `tee` untuk kasus spesifik.
- **Pipeline** memiliki jebakan: subshell, exit status, buffering.
- **Subshell** menyebabkan variabel tidak bertahan.
- **Strategi debugging**: reproduksi, perkecil, tracing, uji, perbaiki.
- **`strace`** dan **`ltrace`** untuk debugging tingkat rendah (Linux).
- **Selalu uji di shell berbeda** untuk memastikan portabilitas.

---

## 📌 Selanjutnya

Materi 3 Level 4 selesai. Anda sekarang menguasai debugging secara mendalam.

Berikutnya adalah **Materi 4: Keamanan Skrip Shell** — kita akan membahas:

- **Command injection** — penyebab dan pencegahan.
- **Quote** — mengapa kutip ganda adalah pertahanan utama.
- **Sanitasi input** — memvalidasi data dari pengguna.
- **Path injection** — bahaya `PATH` yang tidak aman.
- **Symlink attack** — pada file temporary.
- **Race condition** — TOCTOU.
- **`eval`** — mengapa harus dihindari.
- **SUID/SGID** — mengapa skrip shell tidak boleh SUID.
- **Environment variable** — bahaya yang diwariskan.
- **Praktik keamanan terbaik**.

## Materi 4: Keamanan Skrip Shell

> **Catatan:** Ini adalah **materi keempat** dari Level 4, sesuai kurikulum yang sudah ditetapkan. Kita akan membahas cara melindungi skrip Anda dari serangan yang memanfaatkan kelemahan umum: **command injection**, **path injection**, **symlink attack**, **race condition**, dan lainnya. Setelah materi ini, Anda akan mampu menulis skrip yang tidak hanya berfungsi, tetapi juga **aman** dari penyalahgunaan.

---

## 🎯 Tujuan Materi 4

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Memahami **model ancaman** (threat model) untuk skrip shell.
2. Mengenali dan mencegah **command injection**.
3. Menguasai **quoting** sebagai pertahanan utama.
4. Melakukan **sanitasi input** dengan benar.
5. Menghindari **path injection** dan bahaya `PATH` yang tidak aman.
6. Menulis **temporary file** yang aman dari symlink attack.
7. Memahami **race condition** (TOCTOU) dan cara mencegahnya.
8. Menghindari **`eval`** dan **`source`** yang berbahaya.
9. Memahami mengapa skrip shell **tidak boleh SUID/SGID**.
10. Mengelola **environment variable** dengan aman.
11. Menerapkan **prinsip hak istimewa minimal**.

---

## 4.4.1 Model Ancaman untuk Skrip Shell

Sebelum membahas serangan spesifik, kita perlu memahami **dari siapa** dan **bagaimana** skrip Anda bisa diserang.

### Siapa yang Bisa Menyerang?

1. **Pengguna lokal** — Orang yang memiliki akses ke sistem yang sama.
2. **Pengguna jarak jauh** — Jika skrip menerima input via jaringan.
3. **Proses lain** — Program lain di sistem yang sama.
4. **Penyerang yang mengontrol input** — Jika skrip membaca file, argumen, atau environment yang bisa dimodifikasi.
5. **Penyerang yang mengontrol lingkungan** — Misalnya `PATH`, `IFS`, `HOME`.

### Apa yang Bisa Dicapai Penyerang?

1. **Eksekusi kode arbitrer** — Menjalankan perintah sebagai user yang menjalankan skrip.
2. **Membaca file sensitif** — `/etc/shadow`, kunci SSH, token API.
3. **Menulis file** — Menyisipkan backdoor, mengubah konfigurasi.
4. **Meningkatkan hak istimewa** — Jika skrip berjalan sebagai root atau SUID.
5. **Denial of service** — Menghapus file, menghabiskan disk, mematikan layanan.

### Asumsi yang Salah

Banyak penulis skrip mengasumsikan:

- ❌ "Input pengguna selalu ramah."
- ❌ "File di `/tmp` aman."
- ❌ "Environment variable tidak akan dimodifikasi."
- ❌ "Skrip hanya dijalankan oleh saya."

**Asumsi ini berbahaya.** Skrip yang baik mengasumsikan input **tidak dapat dipercaya**.

---

## 4.4.2 Command Injection — Ancaman Terbesar

**Command injection** terjadi ketika input pengguna **dieksekusi** sebagai perintah shell, bukan diperlakukan sebagai data.

### Contoh Rentan 1: `eval`

```sh
#!/bin/sh

# RENTAN
echo "Masukkan nama file:"
read -r file
eval "ls $file"
```

Penjelasan:

- `read -r file` – Membaca input pengguna ke variabel `file`.
- `eval "ls $file"` – Mengevaluasi string sebagai perintah shell.
- Jika pengguna memasukkan `; rm -rf /`, maka perintah menjadi:
  ```sh
  ls ; rm -rf /
  ```
- **Malapetaka.**

**Perbaikan:**

```sh
#!/bin/sh

echo "Masukkan nama file:"
read -r file
ls "$file"
```

Penjelasan:

- `ls "$file"` – Tidak menggunakan `eval`.
- `"$file"` – Dikutip, sehingga karakter khusus tidak diinterpretasikan.

### Contoh Rentan 2: `eval` dengan Variabel

```sh
#!/bin/sh

# RENTAN
nama="$1"
eval "echo Halo, $nama"
```

Jika `$1` adalah `; rm -rf /`, maka:

```sh
eval "echo Halo, ; rm -rf /"
```

**Perbaikan:**

```sh
#!/bin/sh
nama="$1"
printf 'Halo, %s\n' "$nama"
```

Penjelasan:

- `printf` dengan `%s` – Memperlakukan `$nama` sebagai **data**, bukan kode.
- Tidak ada `eval`.

### Contoh Rentan 3: Backtick atau `$( )` dengan Input

```sh
#!/bin/sh

# RENTAN
file="$1"
hasil=`cat $file`
```

Jika `$1` adalah `; rm -rf /`, maka:

```sh
hasil=`cat ; rm -rf /`
```

**Perbaikan:**

```sh
#!/bin/sh
file="$1"
hasil=$(cat "$file")
```

Penjelasan:

- `"$file"` – Dikutip. Shell tidak memecah atau mengeksekusi karakter khusus.
- Perhatikan: `$1` masih bisa berupa path yang tidak valid, tetapi tidak bisa dieksekusi sebagai perintah.

### Contoh Rentan 4: `xargs` dengan `sh -c`

```sh
#!/bin/sh

# RENTAN
echo "$1" | xargs -I {} sh -c 'echo {}'
```

Jika `$1` adalah `; rm -rf /`, maka:

```sh
sh -c 'echo ; rm -rf /'
```

**Perbaikan:**

```sh
#!/bin/sh
printf '%s\n' "$1" | xargs -I {} sh -c 'printf "%s\n" "$1"' sh {}
```

Penjelasan:

- `sh -c 'printf "%s\n" "$1"' sh {}` – `{}` diteruskan sebagai argumen, bukan diinterpolasi ke string.
- `"$1"` di dalam `sh -c` mengacu ke argumen yang diteruskan.

### Contoh Rentan 5: `find -exec` dengan `sh -c`

```sh
#!/bin/sh

# RENTAN
find . -type f -exec sh -c 'echo $1' sh {} \;
```

Ini sebenarnya **aman** karena `{}` diteruskan sebagai argumen, bukan diinterpolasi. Tetapi jika Anda menulis:

```sh
find . -type f -exec sh -c "echo {}" \;
```

Ini **rentan** karena `{}` diinterpolasi ke string sebelum `sh -c` dijalankan.

### Aturan Emas Command Injection

> **Jangan pernah membiarkan input pengguna menjadi bagian dari perintah yang dieksekusi.**

Selalu:
1. **Kutip** variabel.
2. **Hindari `eval`.**
3. **Gunakan `printf` dengan format string** alih-alih interpolasi.
4. **Validasi input** sebelum digunakan.
5. **Gunakan argumen**, bukan string yang diinterpretasi.

---

## 4.4.3 Quoting — Pertahanan Utama

**Quoting** adalah pertahanan paling dasar dan paling penting. Memahami quoting adalah keterampilan wajib.

### Jenis Quoting di POSIX

| Jenis | Karakter | Efek |
|-------|----------|------|
| Backslash | `\` | Escape satu karakter |
| Single quote | `'...'` | Literal, tidak ada ekspansi |
| Double quote | `"..."` | Ekspansi parameter, tapi tidak word splitting/globbing |

### Single Quote — Paling Aman

```sh
echo 'Halo, $nama'
```

Output:

```
Halo, $nama
```

Penjelasan:

- Semua karakter di dalam `'...'` adalah literal.
- Tidak ada ekspansi parameter, command substitution, atau globbing.
- **Gunakan ini untuk string statis.**

**Jebakan:** Anda tidak bisa menyertakan single quote di dalam single quote.

```sh
echo 'It's a test'    # ❌ Error
```

**Solusi:**

```sh
echo 'It'\''s a test'    # Menggabungkan: 'It' + \' + 's a test'
```

Atau gunakan double quote:

```sh
echo "It's a test"
```

### Double Quote — Aman dengan Ekspansi

```sh
nama="Budi"
echo "Halo, $nama"
```

Output:

```
Halo, Budi
```

Penjelasan:

- `"..."` – Ekspansi parameter (`$nama`) terjadi.
- Command substitution (`$(...)`) terjadi.
- Arithmetic expansion (`$(( ))`) terjadi.
- **Tidak** ada word splitting.
- **Tidak** ada globbing.

**Gunakan ini untuk hampir semua kasus.**

### Backslash — Escape Satu Karakter

```sh
echo "Halo, \"dunia\""
```

Output:

```
Halo, "dunia"
```

Penjelasan:

- `\"` – Escape tanda kutip ganda.
- `\\` – Escape backslash.
- `\$` – Escape dolar.
- Di dalam double quote, backslash hanya memiliki arti khusus diikuti `$`, `` ` ``, `"`, `\`, dan newline.

### Contoh: Perbedaan Quoting

```sh
var="Halo Dunia"

echo $var        # Word splitting: Halo Dunia (dua argumen)
echo "$var"      # Satu argumen: Halo Dunia
echo '$var'      # Literal: $var
echo \$var       # Literal: $var (escape)
```

### Contoh: Quoting dengan Globbing

```sh
ls *.txt          # Globbing: daftar file .txt
ls "*.txt"        # Literal: *.txt (biasanya error)
ls '*.txt'        # Literal: *.txt
```

### Contoh: Quoting dengan Command Substitution

```sh
files=$(ls *.txt)
echo $files        # Word splitting: daftar file terpisah
echo "$files"      # Satu string dengan newline
```

### Aturan Emas Quoting

> **Selalu kutip variabel dan command substitution dengan `"..."` kecuali Anda memiliki alasan kuat untuk tidak.**

Pengecualian:

- Dalam assignment: `var=$other` (aman karena word splitting tidak terjadi di sisi kanan).
- Dalam `[ ]`: `[ -z "$var" ]` — selalu kutip.
- Dalam `case`: `case "$var" in ...`.

### Contoh Kode Rentan karena Tidak Quoting

```sh
#!/bin/sh

file="$1"
if [ -f $file ]; then    # ❌ Tidak dikutip
    rm $file              # ❌ Tidak dikutip
fi
```

Jika `$1` adalah `"file penting.txt"`:

- `[ -f $file ]` → `[ -f file penting.txt ]` → error.
- `rm $file` → `rm file penting.txt` → menghapus dua file.

**Perbaikan:**

```sh
#!/bin/sh
file="$1"
if [ -f "$file" ]; then
    rm "$file"
fi
```

### Quoting di `[ ]`

```sh
# Salah
[ $var = "x" ]     # Error jika $var kosong atau mengandung spasi

# Benar
[ "$var" = "x" ]
```

### Quoting di `case`

```sh
case "$var" in
    *.txt) echo "File teks" ;;
    *) echo "Lain" ;;
esac
```

Penjelasan:

- `"$var"` – Dikutip agar word splitting tidak terjadi.
- Pola `*.txt` **tidak** dikutip karena kita ingin globbing.

---

## 4.4.4 Sanitasi Input

**Sanitasi** adalah proses memvalidasi dan membersihkan input sebelum digunakan.

### Prinsip Sanitasi

1. **Whitelist** — Terima hanya karakter/nilai yang diizinkan.
2. **Blacklist** — Tolak karakter yang diketahui berbahaya (kurang aman).
3. **Validasi format** — Cek apakah input sesuai pola yang diharapkan.
4. **Batasi panjang** — Cegah input yang sangat panjang.

**Whitelist lebih baik daripada blacklist.**

### Contoh 1: Validasi Angka

```sh
validasi_angka() {
    case "$1" in
        ''|*[!0-9]*) return 1 ;;
    esac
    return 0
}

if ! validasi_angka "$1"; then
    echo "Error: '$1' bukan angka." >&2
    exit 1
fi
```

Penjelasan:

- `case "$1"` – Cocokkan input.
- `''` – String kosong: tolak.
- `*[!0-9]*` – Mengandung karakter selain 0-9: tolak.
- Hanya angka murni yang lolos.

### Contoh 2: Validasi Nama File

```sh
validasi_nama_file() {
    case "$1" in
        ''|*/*|*..*) return 1 ;;
    esac
    return 0
}
```

Penjelasan:

- `''` – Kosong: tolak.
- `*/*` – Mengandung `/`: tolak (mencegah path traversal).
- `*..*` – Mengandung `..`: tolak (mencegah direktori induk).
- Hanya nama file sederhana yang lolos.

**Catatan:** Ini mungkin terlalu ketat. Sesuaikan dengan kebutuhan.

### Contoh 3: Validasi Email (Sederhana)

```sh
validasi_email() {
    case "$1" in
        *@*.*) return 0 ;;
        *) return 1 ;;
    esac
}
```

Penjelasan:

- `*@*.*` – Mengandung `@` dan titik setelahnya.
- Validasi sederhana. Untuk validasi serius, gunakan `grep -E`.

```sh
validasi_email() {
    printf '%s' "$1" | grep -E -q '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
}
```

### Contoh 4: Validasi Path

```sh
validasi_path() {
    case "$1" in
        /*) return 0 ;;    # Absolute path
        *) return 1 ;;     # Relative: tolak (jika kita hanya menerima absolute)
    esac
}
```

### Contoh 5: Membatasi Panjang Input

```sh
read -r input

if [ "${#input}" -gt 100 ]; then
    echo "Error: input terlalu panjang (maks 100)." >&2
    exit 1
fi
```

Penjelasan:

- `${#input}` – Panjang string.
- `-gt 100` – Lebih dari 100.

### Contoh 6: Sanitasi untuk `eval` (Jika Terpaksa)

**Jangan gunakan `eval` dengan input pengguna.** Tetapi jika benar-benar terpaksa, sanitasi ketat:

```sh
# HANYA jika Anda tahu apa yang Anda lakukan
sanitasi() {
    printf '%s' "$1" | tr -d ';|&$`\\"'"'"'(){}[]<>'
}
```

Penjelasan:

- `tr -d` – Hapus karakter.
- Daftar karakter berbahaya.
- **Ini bukan jaminan.** `eval` tetap berbahaya.

### Aturan Sanitasi

> **Validasi semua input sebelum digunakan. Lebih baik menolak input yang valid daripada menerima input yang berbahaya.**

---

## 4.4.5 Path Injection

**Path injection** terjadi ketika penyerang memodifikasi `PATH` sehingga perintah yang Anda panggil menjalankan program berbahaya.

### Contoh Serangan

Skrip Anda:

```sh
#!/bin/sh
ls /tmp
```

Jika `PATH` di-set ke `/tmp:/usr/bin:/bin` dan penyerang meletakkan `/tmp/ls` yang berisi:

```sh
#!/bin/sh
rm -rf /home/budi/*
```

Maka saat Anda menjalankan skrip, `/tmp/ls` dieksekusi, bukan `/bin/ls`.

### Pencegahan

**1. Set `PATH` secara eksplisit di awal skrip:**

```sh
#!/bin/sh
PATH=/usr/bin:/bin
export PATH
```

Penjelasan:

- Set `PATH` ke nilai yang aman dan diketahui.
- Tidak mengandalkan `PATH` dari environment.

**2. Gunakan path absolut untuk perintah kritis:**

```sh
/bin/ls /tmp
/usr/bin/grep "pola" file.txt
```

Penjelasan:

- Tidak bergantung pada `PATH`.
- Tetapi path absolut mungkin berbeda antar sistem (portabilitas vs keamanan).

**3. Cek `PATH` sebelum digunakan:**

```sh
case ":$PATH:" in
    *:/tmp:*|*:.:*)
        echo "Error: PATH tidak aman." >&2
        exit 1
        ;;
esac
```

Penjelasan:

- `:$PATH:` – Tambahkan `:` di awal dan akhir untuk pencocokan.
- `*:/tmp:*` – Cek apakah `/tmp` ada di `PATH`.
- `*:.:*` – Cek apakah `.` (direktori saat ini) ada di `PATH`.
- Jika ya, tolak.

**4. Reset `PATH` saat menjalankan perintah eksternal:**

```sh
env -i PATH=/usr/bin:/bin command
```

Penjelasan:

- `env -i` – Mulai dengan environment kosong.
- `PATH=/usr/bin:/bin` – Set `PATH` yang aman.
- `command` – Perintah yang dijalankan.

### Contoh Skrip Aman

```sh
#!/bin/sh

# Set PATH yang aman
PATH=/usr/bin:/bin
export PATH

# Verifikasi perintah yang digunakan
for cmd in grep sed awk; do
    if ! command -v "$cmd" > /dev/null 2>&1; then
        echo "Error: $cmd tidak ditemukan." >&2
        exit 1
    fi
done

# Lanjutkan
grep "pola" file.txt
```

---

## 4.4.6 Symlink Attack pada Temporary File

**Symlink attack** terjadi ketika penyerang membuat symlink di lokasi yang akan digunakan skrip untuk file temporary.

### Contoh Serangan

Skrip Anda:

```sh
#!/bin/sh

TMPFILE="/tmp/myapp.tmp"
echo "data rahasia" > "$TMPFILE"
```

Penyerang (sebelum skrip dijalankan):

```sh
ln -s /etc/passwd /tmp/myapp.tmp
```

Ketika skrip Anda menulis ke `/tmp/myapp.tmp`, ia sebenarnya menulis ke `/etc/passwd`, merusak file sistem.

### Pencegahan: `mktemp`

```sh
#!/bin/sh

TMPFILE=$(mktemp) || {
    echo "Error: tidak dapat membuat temporary file." >&2
    exit 1
}

echo "data rahasia" > "$TMPFILE"
```

Penjelasan:

- `mktemp` – Membuat file dengan nama acak (misalnya `/tmp/tmp.a1B2c3D4`).
- Izin `0600` (hanya pemilik yang bisa membaca/menulis).
- Nama tidak dapat diprediksi, sehingga symlink attack tidak mungkin.
- `|| { ... }` – Handle error.

### Pencegahan: `mktemp -d` untuk Direktori

```sh
TMPDIR=$(mktemp -d) || exit 1
TMPFILE="$TMPDIR/data.txt"
```

Penjelasan:

- Direktori temporary dengan izin `0700`.
- File di dalamnya aman.

### Contoh Lengkap dengan Cleanup

```sh
#!/bin/sh

TMPFILE=""

cleanup() {
    status=$?
    [ -n "$TMPFILE" ] && rm -f "$TMPFILE"
    exit "$status"
}

trap cleanup EXIT INT TERM

TMPFILE=$(mktemp) || {
    echo "Error: mktemp gagal." >&2
    exit 1
}

echo "data" > "$TMPFILE"
# ... gunakan ...
```

### Jebakan `mktemp`

**1. `mktemp` tanpa argumen:**

```sh
mktemp    # POSIX: OK, buat file
```

**2. `mktemp` dengan template (GNU):**

```sh
mktemp /tmp/myapp.XXXXXX
```

- **Tidak POSIX.** POSIX hanya menerima template dengan `XXXXXX`.

**3. `TMPDIR`:**

- `mktemp` menggunakan `$TMPDIR` jika di-set, atau `/tmp`.
- Set `TMPDIR` yang aman:

```sh
TMPDIR=/var/tmp
export TMPDIR
```

---

## 4.4.7 Race Condition (TOCTOU)

**TOCTOU** — Time-of-Check to Time-of-Use. Terjadi ketika ada jeda antara **memeriksa** dan **menggunakan** sumber daya.

### Contoh Rentan

```sh
#!/bin/sh

if [ ! -f "$file" ]; then
    echo "data" > "$file"
fi
```

Penjelasan:

- `[ ! -f "$file" ]` – Cek apakah file tidak ada.
- Antara cek dan `echo >`, penyerang bisa membuat symlink.
- Jika `$file` adalah `/tmp/foo` dan penyerang membuat symlink ke `/etc/passwd`, maka `echo` menulis ke `/etc/passwd`.

### Pencegahan: Gunakan Operasi Atomic

**1. `mkdir` — Atomic:**

```sh
if mkdir "$LOCKDIR" 2>/dev/null; then
    # Berhasil membuat direktori
    ...
fi
```

Penjelasan:

- `mkdir` gagal jika direktori sudah ada.
- Tidak ada jeda antara cek dan buat.

**2. `noclobber`:**

```sh
set -C
if echo "data" > "$file" 2>/dev/null; then
    # Berhasil menulis
    ...
fi
set +C
```

Penjelasan:

- `set -C` – Aktifkan noclobber.
- `> "$file"` – Gagal jika file sudah ada.
- Atomic.

**3. `mktemp`:**

```sh
TMPFILE=$(mktemp) || exit 1
```

Penjelasan:

- `mktemp` membuat file secara atomic.
- Tidak ada jeda.

### Contoh: Lock File Atomic

```sh
#!/bin/sh

LOCKDIR="/var/lock/myapp.lock"

if ! mkdir "$LOCKDIR" 2>/dev/null; then
    echo "Error: skrip sedang berjalan." >&2
    exit 1
fi

trap 'rmdir "$LOCKDIR"' EXIT INT TERM
```

### Contoh: Menulis File Konfigurasi

```sh
#!/bin/sh

TMPFILE=$(mktemp) || exit 1

cat > "$TMPFILE" <<EOF
konfigurasi baru
EOF

mv "$TMPFILE" "/etc/myapp.conf"
```

Penjelasan:

- Tulis ke file temporary.
- `mv` – Rename atomic. Menggantikan file target sekaligus.
- Tidak ada jendela di mana file target dalam keadaan setengah tertulis.

---

## 4.4.8 `eval` — Hindari Seperti Wabah

**`eval`** mengevaluasi string sebagai perintah shell. Ini adalah fitur yang **sangat berbahaya** dan hampir selalu bisa dihindari.

### Mengapa `eval` Berbahaya?

```sh
eval "$input"
```

Jika `$input` adalah `rm -rf /`, maka `rm -rf /` dieksekusi. Tidak ada cara untuk "mengutip" `$input` agar aman — `eval` akan selalu menafsirkan string sebagai kode.

### Penggunaan `eval` yang "Sah"

Ada beberapa kasus di mana `eval` tampak diperlukan:

**1. Assignment dinamis:**

```sh
var="nama_variabel"
eval "$var=nilai"
```

Alternatif POSIX: tidak ada cara langsung. Tetapi sering kali, struktur ulang lebih baik.

**2. Indirection:**

```sh
nama="Budi"
var="nama"
eval "echo \$$var"
```

Alternatif: gunakan `eval` dengan hati-hati, atau struktur ulang.

**3. Multiple assignment dari `read`:**

```sh
read -r a b c    # Tidak butuh eval
```

**4. Membangun perintah dari variabel:**

```sh
cmd="ls -l"
eval "$cmd"
```

Alternatif:

```sh
set -- ls -l
"$@"
```

Atau:

```sh
ls -l    # Langsung
```

### Aturan `eval`

> **Jangan gunakan `eval` dengan input yang tidak dapat dipercaya. Bahkan dengan input yang dapat dipercaya, pertimbangkan alternatif.**

Jika Anda benar-benar harus menggunakan `eval`:

1. Sanitasi input dengan ketat.
2. Gunakan single quote untuk membungkus variabel:
   ```sh
   eval "perintah '$var'"
   ```
   Tetapi hati-hati: jika `$var` mengandung `'`, ini rusak.
3. Lebih baik: hindari sama sekali.

---

## 4.4.9 SUID/SGID — Jangan

**SUID** (Set User ID) dan **SGID** (Set Group ID) adalah bit izin yang membuat program berjalan dengan hak pemilik/grup, bukan hak user yang menjalankannya.

```sh
-rwsr-xr-x 1 root root /usr/bin/passwd
```

Penjelasan:

- `s` di posisi execute pemilik – SUID.
- `/usr/bin/passwd` berjalan sebagai root, meskipun dijalankan oleh user biasa.

### Mengapa Skrip Shell Tidak Boleh SUID?

1. **Shell tidak aman untuk SUID.** Shell membaca environment variable, file konfigurasi, dan `PATH`. Semua ini bisa dimanipulasi.
2. **Kernel menolak SUID pada skrip.** Di Linux modern, kernel mengabaikan bit SUID pada skrip shell.
3. **Banyak celah.** Bahkan jika kernel mengizinkan, shell memiliki banyak celah yang bisa dieksploitasi.

### Contoh Serangan SUID Shell

```sh
#!/bin/sh
# /usr/local/bin/myapp (SUID root)
cat /etc/secret.conf
```

Penyerang bisa memanipulasi environment:

```sh
PATH=/tmp:$PATH /usr/local/bin/myapp
```

Jika `/tmp/cat` berisi perintah berbahaya, dan skrip memanggil `cat` tanpa path absolut, penyerang bisa menjalankan kode sebagai root.

### Alternatif SUID

1. **Gunakan `sudo`** dengan konfigurasi yang ketat.
2. **Gunakan program C** yang dikompilasi dengan aman.
3. **Gunakan capabilities** (Linux) untuk memberikan hak spesifik.
4. **Gunakan daemon** yang berjalan sebagai root dan menerima perintah via socket.

### Aturan

> **Jangan pernah membuat skrip shell SUID. Tidak ada alasan yang cukup.**

---

## 4.4.10 Environment Variable yang Berbahaya

Environment variable diwariskan ke proses anak. Beberapa di antaranya dapat dimanipulasi untuk menyerang skrip.

### `PATH`

Sudah dibahas. Selalu set eksplisit.

### `IFS`

**IFS** (Internal Field Separator) mempengaruhi word splitting.

```sh
IFS=";"
echo "a;b;c"
```

Jika penyerang men-set `IFS` sebelum menjalankan skrip Anda, word splitting bisa berperilaku tidak terduga.

**Pencegahan:**

```sh
#!/bin/sh
IFS=' 
	'
```

Penjelasan:

- Set `IFS` ke default: spasi, tab, newline.
- Dilakukan di awal skrip.

### `ENV` dan `BASH_ENV`

`ENV` (untuk `sh`) dan `BASH_ENV` (untuk `bash`) menentukan file yang di-source saat shell startup.

Penyerang bisa men-set:

```sh
ENV=/tmp/malicious.sh
```

**Pencegahan:**

```sh
#!/bin/sh
unset ENV
unset BASH_ENV
```

### `CDPATH`

`CDPATH` mempengaruhi `cd`. Jika di-set, `cd foo` bisa mengubah direktori ke tempat yang tidak terduga.

**Pencegahan:**

```sh
unset CDPATH
```

### `GLOBIGNORE`

Bashism. Mempengaruhi globbing. Tidak POSIX.

### `LD_PRELOAD` dan `LD_LIBRARY_PATH`

Mempengaruhi dynamic linker. Bisa digunakan untuk menyuntikkan library berbahaya.

**Pencegahan:** Tidak ada cara langsung di skrip shell. Ini alasan mengapa SUID shell berbahaya.

### Membersihkan Environment

```sh
#!/bin/sh

# Bersihkan environment yang berbahaya
unset ENV
unset BASH_ENV
unset CDPATH
unset IFS
IFS=' 
	'

PATH=/usr/bin:/bin
export PATH
```

Atau jalankan skrip dengan environment bersih:

```sh
env -i PATH=/usr/bin:/bin HOME="$HOME" sh skrip.sh
```

---

## 4.4.11 Prinsip Hak Istimewa Minimal

**Prinsip hak istimewa minimal** (principle of least privilege) berarti: skrip harus berjalan dengan hak **sesedikit mungkin** yang diperlukan.

### Praktik

1. **Jangan jalankan sebagai root** kecuali benar-benar perlu.
2. **Batasi operasi** yang memerlukan hak istimewa.
3. **Drop privileges** setelah operasi kritis.
4. **Gunakan user khusus** untuk layanan.

### Contoh: Drop Privileges

```sh
#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: skrip harus dijalankan sebagai root." >&2
    exit 1
fi

# Lakukan operasi yang memerlukan root
# ...

# Drop ke user biasa
if command -v su > /dev/null 2>&1; then
    su -s /bin/sh nobody -c "perintah"
fi
```

**Catatan:** Implementasi drop privileges di shell sulit dan rawan. Untuk keamanan serius, gunakan bahasa pemrograman yang lebih aman.

### Cek User

```sh
if [ "$(id -u)" -eq 0 ]; then
    echo "Warning: skrip dijalankan sebagai root." >&2
fi
```

Penjelasan:

- `id -u` – Mencetak UID pengguna saat ini.
- `0` – UID root.

### Cek Group

```sh
if ! id -Gn | grep -q "sudo"; then
    echo "Error: Anda bukan anggota grup sudo." >&2
    exit 1
fi
```

---

## 4.4.12 Contoh Skrip Aman Lengkap

### Skrip 1: Skrip dengan Sanitasi Input

```sh
#!/bin/sh
# Nama: aman.sh
# Tujuan: Demonstrasi sanitasi input dan quoting

set -u

# Bersihkan environment berbahaya
unset ENV
unset BASH_ENV
unset CDPATH
unset IFS
IFS=' 
	'

PATH=/usr/bin:/bin
export PATH

# Validasi argumen
if [ $# -ne 1 ]; then
    printf 'Penggunaan: %s file\n' "$0" >&2
    exit 2
fi

file="$1"

# Validasi nama file: hanya huruf, angka, titik, dash, underscore
case "$file" in
    ''|*[!A-Za-z0-9._-]*)
        printf 'Error: nama file tidak valid: %s\n' "$file" >&2
        exit 2
        ;;
esac

# Cek keberadaan
if [ ! -f "$file" ]; then
    printf 'Error: file tidak ada: %s\n' "$file" >&2
    exit 2
fi

# Proses
printf 'Memproses file: %s\n' "$file"
grep "pola" "$file" || true
```

Penjelasan:

- `unset ENV` – Hapus environment berbahaya.
- `PATH=/usr/bin:/bin` – Set path aman.
- `case "$file"` – Validasi whitelist.
- `printf '%s'` – Menggunakan `printf` dengan format string untuk mencegah injeksi.
- `"$file"` – Selalu dikutip.

### Skrip 2: Skrip dengan Temporary File Aman

```sh
#!/bin/sh
# Nama: tmp_aman.sh

set -u

TMPFILE=""

cleanup() {
    status=$?
    [ -n "$TMPFILE" ] && rm -f "$TMPFILE"
    exit "$status"
}

trap cleanup EXIT INT TERM

TMPFILE=$(mktemp) || {
    printf 'Error: mktemp gagal.\n' >&2
    exit 1
}

printf 'Data rahasia\n' > "$TMPFILE"
printf 'File sementara: %s\n' "$TMPFILE"

# Gunakan file
cat "$TMPFILE"
```

### Skrip 3: Skrip dengan Lock Atomic

```sh
#!/bin/sh
# Nama: lock.sh

set -u

LOCKDIR="/tmp/myapp.lock"

if ! mkdir "$LOCKDIR" 2>/dev/null; then
    printf 'Error: skrip sedang berjalan.\n' >&2
    exit 1
fi

cleanup() {
    status=$?
    rmdir "$LOCKDIR" 2>/dev/null
    exit "$status"
}

trap cleanup EXIT INT TERM

printf 'Skrip berjalan dengan lock.\n'
sleep 5
printf 'Selesai.\n'
```

### Skrip 4: Skrip dengan Validasi Ketat

```sh
#!/bin/sh
# Nama: validasi_ketat.sh

set -u

validasi_angka() {
    case "$1" in
        ''|*[!0-9]*) return 1 ;;
    esac
    return 0
}

validasi_path() {
    case "$1" in
        /*) return 0 ;;
        *) return 1 ;;
    esac
}

if [ $# -ne 2 ]; then
    printf 'Penggunaan: %s angka path\n' "$0" >&2
    exit 2
fi

angka="$1"
path="$2"

if ! validasi_angka "$angka"; then
    printf 'Error: %s bukan angka.\n' "$angka" >&2
    exit 2
fi

if ! validasi_path "$path"; then
    printf 'Error: %s bukan path absolut.\n' "$path" >&2
    exit 2
fi

printf 'Angka: %s\n' "$angka"
printf 'Path: %s\n' "$path"
```

### Skrip 5: Skrip yang Menghindari `eval`

```sh
#!/bin/sh
# Nama: no_eval.sh

set -u

# RENTAN (jangan tiru)
# eval "echo $1"

# AMAN
printf 'Input: %s\n' "$1"

# Jika perlu mengeksekusi perintah dinamis, gunakan array (tidak POSIX)
# atau struktur ulang
case "$1" in
    list)
        ls -l
        ;;
    date)
        date
        ;;
    *)
        printf 'Perintah tidak dikenal: %s\n' "$1" >&2
        exit 1
        ;;
esac
```

---

## 4.4.13 Latihan

1. **Identifikasi Kerentanan:**
   - Ambil skrip yang menggunakan `eval`.
   - Identifikasi bagaimana penyerang bisa mengeksploitasi.
   - Tulis versi yang aman tanpa `eval`.

2. **Quoting:**
   - Tulis skrip yang menerima nama file.
   - Uji dengan nama file mengandung spasi, `*`, `;`.
   - Pastikan tidak ada injeksi.

3. **Sanitasi:**
   - Tulis fungsi `validasi_username` yang hanya menerima huruf, angka, underscore.
   - Uji dengan input valid dan berbahaya.

4. **Path Injection:**
   - Buat skrip yang memanggil `ls`.
   - Set `PATH=/tmp:$PATH` dan letakkan `ls` berbahaya di `/tmp`.
   - Amati apa yang terjadi.
   - Perbaiki skrip.

5. **Symlink Attack:**
   - Buat skrip yang menulis ke `/tmp/fixed.txt`.
   - Buat symlink `/tmp/fixed.txt` ke file lain.
   - Amati apa yang terjadi.
   - Perbaiki dengan `mktemp`.

6. **Race Condition:**
   - Tulis skrip yang menggunakan `[ ! -f file ]` diikuti `> file`.
   - Diskusikan bagaimana race condition bisa terjadi.
   - Perbaiki dengan `mkdir` atau `noclobber`.

7. **SUID:**
   - Jelaskan mengapa skrip shell SUID berbahaya.
   - Berikan contoh serangan.
   - Sebutkan alternatif.

8. **Environment:**
   - Tulis skrip yang menggunakan `PATH`.
   - Uji dengan `PATH` yang dimodifikasi.
   - Perbaiki dengan set `PATH` eksplisit.

9. **Lock File:**
   - Tulis skrip dengan lock file menggunakan `mkdir`.
   - Uji menjalankan dua instance.
   - Pastikan lock dibersihkan saat keluar.

10. **Atomic Write:**
    - Tulis skrip yang menulis file konfigurasi.
    - Gunakan file temporary dan `mv`.
    - Uji dengan memutus proses di tengah.

11. **Sanitasi vs Blacklist:**
    - Tulis dua versi sanitasi: whitelist dan blacklist.
    - Diskusikan mengapa whitelist lebih baik.

12. **Audit Skrip:**
    - Ambil skrip yang Anda tulis sebelumnya.
    - Audit untuk kerentanan keamanan.
    - Perbaiki setiap masalah.

---

## 4.4.14 Ringkasan Materi 4

- **Model ancaman** untuk skrip shell mencakup pengguna lokal, jarak jauh, dan proses lain.
- **Command injection** terjadi ketika input pengguna dieksekusi sebagai perintah. Hindari `eval`.
- **Quoting** adalah pertahanan utama. Selalu kutip: `"$var"`.
- **Sanitasi input** dengan whitelist, bukan blacklist.
- **Path injection** dicegah dengan set `PATH` eksplisit.
- **Symlink attack** dicegah dengan `mktemp`.
- **Race condition** (TOCTOU) dicegah dengan operasi atomic (`mkdir`, `noclobber`).
- **`eval`** harus dihindari. Hampir selalu ada alternatif.
- **SUID/SGID** pada skrip shell **tidak boleh**. Gunakan `sudo` atau program C.
- **Environment variable** berbahaya: `PATH`, `IFS`, `ENV`, `BASH_ENV`, `CDPATH`. Bersihkan di awal skrip.
- **Prinsip hak istimewa minimal**: jalankan dengan hak sesedikit mungkin.
- **Atomic write** dengan file temporary + `mv`.
- **Selalu audit** skrip Anda untuk kerentanan.

---

## 📌 Selanjutnya

Materi 4 Level 4 selesai. Anda sekarang menguasai keamanan skrip shell secara mendalam.

Berikutnya adalah **Materi 5: Praktik Terbaik & Gaya Kode** — ini adalah **materi terakhir** dari Level 4. Kita akan membahas:

- **Penamaan** variabel, fungsi, file.
- **Dokumentasi** skrip dan fungsi.
- **Header skrip** standar.
- **`getopts`** untuk parsing argumen.
- **Struktur skrip** dengan `main`.
- **Gaya kode**: indentasi, spasi, komentar.
- **Organisasi proyek** skrip.
- **Testing** skrip shell.
- **Version control** untuk skrip.
- **Distribusi** skrip.

## Materi 5: Praktik Terbaik & Gaya Kode

> **Catatan:** Ini adalah **materi kelima** dan **terakhir** dari Level 4, sesuai kurikulum yang sudah ditetapkan. Kita akan membahas cara menulis skrip yang **mudah dibaca**, **mudah dipelihara**, dan **mudah diuji**. Kode yang baik bukan hanya kode yang berfungsi, tetapi kode yang bisa dipahami oleh orang lain (dan diri Anda sendiri 6 bulan kemudian). Setelah materi ini, skrip Anda akan naik dari "berfungsi" menjadi "profesional".

---

## 🎯 Tujuan Materi 5

Setelah mempelajari materi ini, Anda diharapkan mampu:

1. Menerapkan **konvensi penamaan** yang konsisten untuk variabel, fungsi, dan file.
2. Menulis **header skrip** standar yang informatif.
3. Mendokumentasikan **fungsi** dengan format yang konsisten.
4. Menguasai **`getopts`** untuk parsing argumen yang profesional.
5. Menstruktur skrip dengan pola **`main`**.
6. Menerapkan **gaya kode** yang konsisten: indentasi, spasi, komentar.
7. Mengorganisasi **proyek skrip** dengan struktur direktori yang baik.
8. Menulis **test** untuk skrip shell.
9. Menggunakan **version control** (git) untuk skrip.
10. Mendistribusikan skrip dengan **cara yang benar**.
11. Membangun **pustaka** yang dapat digunakan ulang.

---

## 4.5.1 Filosofi Kode yang Baik

Kode yang baik memiliki karakteristik:

1. **Readable** — Mudah dibaca dan dipahami.
2. **Maintainable** — Mudah diubah dan diperluas.
3. **Testable** — Mudah diuji.
4. **Consistent** — Gaya yang konsisten di seluruh proyek.
5. **Documented** — Ada dokumentasi yang cukup.
6. **Portable** — Berjalan di lingkungan yang ditargetkan.

**Kutipan:**

> "Any fool can write code that a computer can understand. Good programmers write code that humans can understand." — Martin Fowler

> "Programs must be written for people to read, and only incidentally for machines to execute." — Harold Abelson

---

## 4.5.2 Konvensi Penamaan

### Variabel

**Aturan umum:**

- Gunakan **huruf kecil dengan underscore** untuk variabel lokal: `nama_file`, `jumlah_baris`.
- Gunakan **HURUF BESAR** untuk konstanta dan environment: `PATH`, `HOME`, `LOG_FILE`, `MAX_RETRY`.
- Hindari nama satu huruf kecuali untuk counter: `i`, `j`, `n`.
- Gunakan nama yang **deskriptif**: `file_count` bukan `fc`.

**Contoh:**

```sh
# Baik
nama_file="laporan.txt"
max_retry=3
LOG_FILE="/var/log/app.log"
i=0

# Buruk
nf="laporan.txt"
mr=3
lf="/var/log/app.log"
x=0
```

### Fungsi

**Aturan umum:**

- Gunakan **huruf kecil dengan underscore**: `baca_file`, `validasi_input`.
- Gunakan **kata kerja** untuk fungsi yang melakukan aksi: `proses_data`, `hitung_total`.
- Gunakan prefix `_` untuk fungsi internal: `_log_internal`.
- Hindari singkatan yang tidak jelas.

**Contoh:**

```sh
# Baik
hitung_total() { ... }
validasi_email() { ... }
_log() { ... }    # internal

# Buruk
ht() { ... }
ve() { ... }
f1() { ... }
```

### File

**Aturan umum:**

- Gunakan **huruf kecil dengan underscore atau dash**: `backup.sh`, `proses_log.sh`.
- Akhiran `.sh` untuk skrip shell.
- Akhiran `.bash` untuk skrip bash-spesifik.
- Hindari spasi di nama file.

**Contoh:**

```
backup.sh
proses_log.sh
lib/
  string.sh
  file.sh
```

### Konstanta

**Aturan umum:**

- Gunakan **HURUF BESAR dengan underscore**.
- Definisikan di awal skrip.
- Gunakan `readonly` jika tidak boleh diubah.

```sh
readonly VERSION="1.0.0"
readonly DEFAULT_TIMEOUT=30
readonly LOG_DIR="/var/log/app"
```

### Prefix untuk Variabel Lokal

Karena POSIX tidak memiliki `local`, gunakan prefix untuk menghindari tabrakan:

```sh
proses() {
    _proses_file="$1"
    _proses_count=0
    # ...
}
```

Untuk variabel global, gunakan nama yang deskriptif:

```sh
SKRIP_NAMA="myapp"
SKRIP_VERSION="1.0.0"
```

---

## 4.5.3 Header Skrip Standar

Setiap skrip profesional harus memiliki **header** di bagian atas. Header berisi informasi penting tentang skrip.

### Format Header

```sh
#!/bin/sh
#
# Nama: backup.sh
# Deskripsi: Backup file .txt dari direktori tertentu ke direktori tujuan.
# Penulis: Budi Santoso <budi@example.com>
# Tanggal: 2026-01-01
# Versi: 1.0.0
# Lisensi: MIT
#
# Penggunaan:
#   backup.sh [opsi] direktori_sumber [direktori_tujuan]
#
# Opsi:
#   -h, --help      Tampilkan bantuan
#   -v, --verbose   Mode verbose
#   -d, --dry-run   Simulasi tanpa menyalin
#
# Contoh:
#   backup.sh /home/budi/dokumen /mnt/backup
#   backup.sh -v /home/budi/dokumen
#
# Exit Codes:
#   0 - Sukses
#   1 - Error umum
#   2 - Argumen tidak valid
#   3 - Direktori sumber tidak ada
#
```

### Penjelasan Setiap Bagian

- **Shebang** — `#!/bin/sh`.
- **Nama** — Nama file skrip.
- **Deskripsi** — Satu atau dua kalimat tentang apa yang dilakukan skrip.
- **Penulis** — Nama dan email.
- **Tanggal** — Tanggal pembuatan atau update terakhir.
- **Versi** — Versi skrip (semantic versioning).
- **Lisensi** — Lisensi (MIT, GPL, dll).
- **Penggunaan** — Sintaks pemanggilan.
- **Opsi** — Daftar opsi yang didukung.
- **Contoh** — Contoh pemanggilan.
- **Exit Codes** — Arti setiap exit code.

### Contoh Header Minimal

```sh
#!/bin/sh
#
# backup.sh — Backup file .txt
#
# Penggunaan: backup.sh SUMBER [TUJUAN]
#
```

### Header dalam Bahasa Indonesia

Tidak ada aturan bahwa header harus bahasa Inggris. Gunakan bahasa yang paling nyaman untuk tim Anda. Konsisten.

---

## 4.5.4 Dokumentasi Fungsi

Setiap fungsi harus memiliki dokumentasi. Format yang konsisten memudahkan pembaca.

### Format Dokumentasi Fungsi

```sh
# nama_fungsi: Deskripsi singkat.
#
# Argumen:
#   $1 - Deskripsi argumen pertama.
#   $2 - Deskripsi argumen kedua.
#
# Output:
#   Deskripsi output ke stdout.
#
# Return:
#   0 - Sukses.
#   1 - Error karena X.
#   2 - Error karena Y.
#
# Contoh:
#   nama_fungsi arg1 arg2
nama_fungsi() {
    # ...
}
```

### Contoh

```sh
# baca_file: Membaca file dan mencetak isinya.
#
# Argumen:
#   $1 - Path ke file.
#
# Output:
#   Isi file ke stdout.
#
# Return:
#   0 - Sukses.
#   1 - File tidak ada.
#   2 - File tidak dapat dibaca.
baca_file() {
    file="$1"

    if [ ! -e "$file" ]; then
        printf 'Error: %s tidak ada.\n' "$file" >&2
        return 1
    fi

    if [ ! -r "$file" ]; then
        printf 'Error: %s tidak dapat dibaca.\n' "$file" >&2
        return 2
    fi

    cat "$file"
    return 0
}
```

### Komentar Inline

Komentar inline menjelaskan **mengapa**, bukan **apa**:

```sh
# Buruk: menjelaskan apa
i=$((i + 1))    # Increment i

# Baik: menjelaskan mengapa
i=$((i + 1))    # Lewati baris header
```

### Komentar untuk Kode Kompleks

```sh
# Konversi tanggal dari format DD/MM/YYYY ke YYYY-MM-DD
# Menggunakan backreference sed untuk menukar posisi grup
tanggal_iso=$(printf '%s' "$tanggal" | sed 's|\([0-9]*\)/\([0-9]*\)/\([0-9]*\)|\3-\2-\1|')
```

---

## 4.5.5 `getopts` — Parsing Argumen Profesional

`getopts` adalah perintah POSIX untuk parsing argumen. Ia menangani opsi pendek (`-v`, `-f file`) secara otomatis.

### Sintaks

```sh
while getopts "vhf:" opt; do
    case "$opt" in
        v) VERBOSE=1 ;;
        h) tampilkan_bantuan; exit 0 ;;
        f) FILE="$OPTARG" ;;
        \?) echo "Opsi tidak dikenal: -$OPTARG" >&2; exit 1 ;;
        :) echo "Opsi -$OPTARG memerlukan argumen." >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))
```

### Penjelasan Kata demi Kata

- `getopts "vhf:"` – String opsi.
  - `v` – Opsi `-v`, tanpa argumen.
  - `h` – Opsi `-h`, tanpa argumen.
  - `f:` – Opsi `-f`, **memerlukan argumen** (tanda `:` setelah huruf).
- `opt` – Variabel yang menampung opsi saat ini.
- `while getopts ...; do` – Loop selama ada opsi.
- `case "$opt" in` – Percabangan berdasarkan opsi.
- `v) VERBOSE=1 ;;` – Jika `-v`, set `VERBOSE=1`.
- `f) FILE="$OPTARG" ;;` – Jika `-f`, ambil argumen dari `$OPTARG`.
- `\?)` – Opsi tidak dikenal.
- `:)` – Opsi memerlukan argumen tetapi tidak diberikan.
- `shift $((OPTIND - 1))` – Geser argumen agar `$1`, `$2` menjadi argumen non-opsi.
  - `OPTIND` – Indeks argumen berikutnya.
  - `$((OPTIND - 1))` – Jumlah argumen yang diproses.

### Contoh Lengkap

```sh
#!/bin/sh

VERSION="1.0.0"
VERBOSE=0
OUTPUT=""

tampilkan_bantuan() {
    cat <<EOF
Penggunaan: $0 [opsi] file...

Opsi:
  -h          Tampilkan bantuan
  -v          Mode verbose
  -V          Tampilkan versi
  -o FILE     File output (default: stdout)
EOF
}

while getopts "hvVo:" opt; do
    case "$opt" in
        h)
            tampilkan_bantuan
            exit 0
            ;;
        v)
            VERBOSE=1
            ;;
        V)
            printf 'Versi %s\n' "$VERSION"
            exit 0
            ;;
        o)
            OUTPUT="$OPTARG"
            ;;
        \?)
            printf 'Opsi tidak dikenal: -%s\n' "$OPTARG" >&2
            exit 2
            ;;
        :)
            printf 'Opsi -%s memerlukan argumen.\n' "$OPTARG" >&2
            exit 2
            ;;
    esac
done

shift $((OPTIND - 1))

if [ $# -eq 0 ]; then
    printf 'Error: tidak ada file yang diberikan.\n' >&2
    exit 2
fi

[ "$VERBOSE" -eq 1 ] && printf 'Mode verbose aktif.\n' >&2

for file in "$@"; do
    if [ ! -r "$file" ]; then
        printf 'Skip: %s tidak dapat dibaca.\n' "$file" >&2
        continue
    fi

    if [ -n "$OUTPUT" ]; then
        cat "$file" >> "$OUTPUT"
    else
        cat "$file"
    fi
done
```

### Keterbatasan `getopts`

1. **Hanya opsi pendek** — `-v`, bukan `--verbose`.
2. **Tidak mendukung opsi panjang** — Untuk opsi panjang, perlu parsing manual.
3. **Tidak mendukung opsi opsional** — Opsi dengan argumen opsional tidak bisa.
4. **Tidak mendukung pengelompokan** — `-vv` diperlakukan sebagai dua `-v`? Ya, `getopts` mendukung ini.

### Parsing Opsi Panjang Manual

```sh
while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            tampilkan_bantuan
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=1
            shift
            ;;
        -o|--output)
            if [ -z "$2" ]; then
                printf 'Error: --output memerlukan argumen.\n' >&2
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
            printf 'Opsi tidak dikenal: %s\n' "$1" >&2
            exit 2
            ;;
        *)
            break
            ;;
    esac
done

# Sisa argumen di $@
```

### Kombinasi `getopts` dan Opsi Panjang

Untuk mendukung keduanya, sering kali dilakukan dengan:

1. Preprocess opsi panjang → konversi ke opsi pendek.
2. Gunakan `getopts` untuk opsi pendek.

```sh
# Preprocess opsi panjang
args=""
for arg in "$@"; do
    case "$arg" in
        --help) args="$args -h" ;;
        --verbose) args="$args -v" ;;
        --output=*) args="$args -o ${arg#--output=}" ;;
        *) args="$args $arg" ;;
    esac
done

# Gunakan getopts dengan args
# shellcheck disable=SC2086
set -- $args
```

**Catatan:** Ini tidak sempurna untuk argumen dengan spasi. Untuk kasus kompleks, parsing manual lebih baik.

---

## 4.5.6 Struktur Skrip dengan `main`

Pola `main` memisahkan definisi fungsi dari eksekusi. Ini membuat skrip mudah diuji.

### Tanpa `main`

```sh
#!/bin/sh

# Definisi fungsi
sapa() {
    echo "Halo, $1"
}

# Kode yang dieksekusi langsung
nama="$1"
if [ -z "$nama" ]; then
    echo "Error: nama kosong" >&2
    exit 1
fi
sapa "$nama"
```

Masalah:

- Kode dieksekusi saat sourcing.
- Sulit diuji.

### Dengan `main`

```sh
#!/bin/sh

# Definisi fungsi
sapa() {
    printf 'Halo, %s\n' "$1"
}

main() {
    if [ $# -eq 0 ]; then
        printf 'Error: nama kosong\n' >&2
        exit 1
    fi
    sapa "$1"
}

# Panggil main dengan semua argumen
main "$@"
```

Kelebihan:

- Fungsi dapat diuji secara terpisah dengan sourcing.
- Struktur jelas: definisi dulu, eksekusi kemudian.

### Pola dengan Deteksi Sourcing

```sh
#!/bin/sh

# ... definisi fungsi ...

main() {
    # ...
}

# Jalankan main hanya jika skrip dieksekusi, bukan di-source
if [ "${0##*/}" = "skrip.sh" ]; then
    main "$@"
fi
```

Penjelasan:

- `${0##*/}` – Nama file skrip tanpa path.
- Bandingkan dengan nama skrip yang diharapkan.
- Jika di-source, `$0` adalah shell induk, bukan skrip.

**Catatan:** Ini tidak sepenuhnya dapat diandalkan. `$0` bisa berbeda tergantung cara pemanggilan.

### Pola yang Lebih Baik

Gunakan variabel:

```sh
#!/bin/sh

# ... definisi fungsi ...

main() {
    # ...
}

# Cek apakah di-source
if [ "${SKRIP_SOURCED:-0}" != "1" ]; then
    main "$@"
fi
```

Saat sourcing:

```sh
SKRIP_SOURCED=1 . ./skrip.sh
```

---

## 4.5.7 Gaya Kode

### Indentasi

Gunakan **tab** atau **4 spasi** secara konsisten. Pilih satu dan patuhi.

```sh
# Dengan tab (tampilan mungkin berbeda)
if [ "$x" -gt 0 ]; then
	echo "Positif"
fi

# Dengan 4 spasi (lebih umum)
if [ "$x" -gt 0 ]; then
    echo "Positif"
fi
```

**Rekomendasi:** 4 spasi. Lebih portabel di editor.

### Spasi

**Sekitar operator:**

```sh
# Baik
a=$((b + c))
[ "$a" = "$b" ]

# Buruk
a=$((b+c))
[ "$a"="$b" ]
```

**Setelah `if`, `while`, `for`:**

```sh
# Baik
if [ "$x" -gt 0 ]; then
while [ "$i" -lt 10 ]; do
for file in *.txt; do

# Buruk
if[ "$x" -gt 0 ]; then
while["$i" -lt 10 ]; do
for file in *.txt;do
```

**Di dalam `[ ]`:**

```sh
# Baik
[ -f "$file" ]
[ "$a" = "$b" ]

# Buruk
[-f "$file"]
[ "$a" = "$b"]
```

### Baris Kosong

Gunakan baris kosong untuk memisahkan blok logis:

```sh
#!/bin/sh

# Konfigurasi
LOG_FILE="/var/log/app.log"
MAX_RETRY=3

# Fungsi
log() {
    printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$*" >&2
}

# Main
main() {
    log "Mulai"
    # ...
}

main "$@"
```

### Panjang Baris

Batasi panjang baris hingga **80–100 karakter**. Ini memudahkan pembacaan di terminal dan diff.

```sh
# Terlalu panjang
printf 'Ini adalah pesan yang sangat panjang yang melebihi batas 80 karakter dan sulit dibaca.\n'

# Lebih baik: pecah
printf '%s\n' \
    'Ini adalah pesan yang sangat panjang' \
    'yang dipecah menjadi beberapa baris.'
```

### Komentar

**Komentar header untuk setiap bagian:**

```sh
# ============================================
# Konfigurasi
# ============================================

LOG_FILE="/var/log/app.log"

# ============================================
# Fungsi
# ============================================

log() {
    # ...
}
```

**Komentar untuk fungsi:**

Sudah dibahas di 4.5.4.

**Hindari komentar yang jelas:**

```sh
# Buruk
i=$((i + 1))    # Tambah i

# Baik
i=$((i + 1))    # Lewati baris header
```

### Gaya `if`

```sh
# Gaya 1: then di baris yang sama
if [ "$x" -gt 0 ]; then
    echo "Positif"
fi

# Gaya 2: then di baris terpisah
if [ "$x" -gt 0 ]
then
    echo "Positif"
fi
```

Pilih satu dan konsisten. Gaya 1 lebih umum di skrip shell.

### Gaya `case`

```sh
case "$1" in
    start)
        mulai
        ;;
    stop)
        hentikan
        ;;
    *)
        echo "Tidak dikenal"
        ;;
esac
```

### Gaya Fungsi

```sh
# Gaya 1: { di baris yang sama
nama() {
    # ...
}

# Gaya 2: { di baris terpisah
nama()
{
    # ...
}
```

POSIX memerlukan `{` di baris yang sama dengan `()` atau di baris berikutnya, tetapi `}` harus di awal baris. Gaya 1 lebih umum.

---

## 4.5.8 Organisasi Proyek Skrip

Untuk proyek yang lebih besar, struktur direktori membantu.

### Struktur Sederhana

```
proyek/
├── skrip.sh
└── README.md
```

### Struktur Menengah

```
proyek/
├── bin/
│   └── main.sh
├── lib/
│   ├── string.sh
│   ├── file.sh
│   └── log.sh
├── test/
│   ├── test_string.sh
│   └── test_file.sh
├── doc/
│   └── README.md
└── Makefile
```

### Struktur Lengkap

```
proyek/
├── bin/              # Skrip yang dapat dieksekusi
│   └── myapp.sh
├── lib/              # Pustaka fungsi
│   ├── string.sh
│   ├── file.sh
│   └── log.sh
├── test/             # Test
│   ├── unit/
│   └── integration/
├── doc/              # Dokumentasi
│   ├── README.md
│   └── CHANGELOG.md
├── etc/              # Konfigurasi contoh
│   └── myapp.conf
├── Makefile          # Build/test/deploy
└── LICENSE
```

### Menemukan Direktori Skrip

Skrip perlu mengetahui lokasi pustaka. Cara portabel:

```sh
#!/bin/sh

# Dapatkan direktori skrip
SCRIPT_DIR=$(dirname "$0")

# Jika $0 adalah path relatif, konversi ke absolut
case "$SCRIPT_DIR" in
    /*) ;;
    *) SCRIPT_DIR="$PWD/$SCRIPT_DIR" ;;
esac

# Source pustaka
. "${SCRIPT_DIR}/../lib/log.sh"
. "${SCRIPT_DIR}/../lib/string.sh"
```

**Catatan:** `dirname "$0"` tidak selalu benar jika skrip dipanggil via symlink. Untuk solusi lebih kuat:

```sh
# Resolve symlink (tidak POSIX)
SCRIPT_PATH=$(readlink -f "$0" 2>/dev/null || echo "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
```

**Tidak POSIX.** Untuk portabilitas, terima keterbatasan.

### `Makefile` untuk Skrip

```makefile
.PHONY: all test install clean

PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
LIBDIR = $(PREFIX)/lib/myapp

all: test

test:
	@for t in test/*.sh; do \
		echo "Menjalankan $$t"; \
		sh "$$t" || exit 1; \
	done

install:
	install -d $(DESTDIR)$(BINDIR)
	install -d $(DESTDIR)$(LIBDIR)
	install -m 755 bin/myapp.sh $(DESTDIR)$(BINDIR)/myapp
	install -m 644 lib/*.sh $(DESTDIR)$(LIBDIR)/

clean:
	rm -f *.log
```

Penjelasan:

- `test` — Menjalankan semua test.
- `install` — Menyalin skrip ke sistem.
- `clean` — Membersihkan file temporary.

---

## 4.5.9 Testing Skrip Shell

Testing adalah bagian penting dari pengembangan profesional.

### Prinsip Testing

1. **Test setiap fungsi** secara terpisah.
2. **Test kasus tepi**: input kosong, spasi, karakter khusus.
3. **Test error handling**: file tidak ada, izin ditolak.
4. **Test portabilitas**: jalankan di shell berbeda.
5. **Otomatisasi**: test harus dapat dijalankan dengan satu perintah.

### Framework Testing Sederhana

```sh
#!/bin/sh
# test/run_tests.sh

PASS=0
FAIL=0

assert_eq() {
    expected="$1"
    actual="$2"
    message="${3:-}"

    if [ "$expected" = "$actual" ]; then
        PASS=$((PASS + 1))
        printf 'PASS: %s\n' "$message"
    else
        FAIL=$((FAIL + 1))
        printf 'FAIL: %s\n' "$message"
        printf '  Expected: [%s]\n' "$expected"
        printf '  Actual:   [%s]\n' "$actual"
    fi
}

# Source pustaka
. ./lib/string.sh

# Test trim
assert_eq "hello" "$(trim '  hello  ')" "trim spasi"
assert_eq "hello" "$(trim 'hello')" "trim tanpa spasi"
assert_eq "" "$(trim '   ')" "trim semua spasi"

# Test upper
assert_eq "HELLO" "$(upper 'hello')" "upper"
assert_eq "HELLO123" "$(upper 'hello123')" "upper dengan angka"

# Test contains
if contains "hello world" "world"; then
    assert_eq "0" "0" "contains: ada"
else
    assert_eq "0" "1" "contains: ada"
fi

if contains "hello" "xyz"; then
    assert_eq "0" "1" "contains: tidak ada"
else
    assert_eq "0" "0" "contains: tidak ada"
fi

# Ringkasan
printf '\n%d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
```

Penjelasan:

- `assert_eq` – Fungsi assertion sederhana.
- `PASS`, `FAIL` – Counter.
- Test dijalankan berurutan.
- Exit code 0 jika semua test lulus.

### Test dengan `diff`

```sh
#!/bin/sh

expected="output_yang_diharapkan"
actual=$(./skrip.sh arg1 arg2)

if [ "$expected" = "$actual" ]; then
    echo "OK"
else
    echo "FAIL"
    diff <(printf '%s\n' "$expected") <(printf '%s\n' "$actual")
fi
```

**Catatan:** Process substitution tidak POSIX. Untuk portabilitas, gunakan file temporary.

### Test Fixture

Buat data uji di direktori terpisah:

```
test/
├── fixtures/
│   ├── input.txt
│   └── expected.txt
└── run_tests.sh
```

```sh
#!/bin/sh

FIXTURES="$(dirname "$0")/fixtures"

actual=$(./skrip.sh "$FIXTURES/input.txt")
expected=$(cat "$FIXTURES/expected.txt")

if [ "$actual" = "$expected" ]; then
    echo "PASS"
else
    echo "FAIL"
    printf 'Expected:\n%s\n' "$expected"
    printf 'Actual:\n%s\n' "$actual"
fi
```

### Tools Testing

- **`shellcheck`** — Analisis statis.
- **`shunit2`** — Framework unit test untuk shell.
- **`bats`** — Bash Automated Testing System (bash-spesifik).
- **`shpec`** — Framework testing untuk shell.

### `shunit2` Contoh

```sh
#!/bin/sh
# test_string.sh

. ./lib/string.sh
. ./shunit2

testTrim() {
    assertEquals "hello" "$(trim '  hello  ')"
}

testUpper() {
    assertEquals "HELLO" "$(upper 'hello')"
}

. ./shunit2
```

Penjelasan:

- `shunit2` menyediakan `assertEquals`, `assertTrue`, dll.
- Fungsi test diawali `test`.

---

## 4.5.10 Version Control dengan Git

Skrip juga harus di-commit ke version control.

### `.gitignore` untuk Proyek Skrip

```
# File temporary
*.tmp
*.log
*.swp

# Direktori build
build/
dist/

# File konfigurasi lokal
.env
*.local

# File sistem
.DS_Store
Thumbs.db
```

### Commit Message yang Baik

```
Format:
<tipe>: <deskripsi singkat>

<deskripsi detail (opsional)>
```

Tipe:

- `feat` — Fitur baru.
- `fix` — Bug fix.
- `docs` — Dokumentasi.
- `style` — Format kode.
- `refactor` — Refactoring.
- `test` — Test.
- `chore` — Maintenance.

Contoh:

```
feat: tambah opsi --verbose di backup.sh

Menambahkan opsi -v/--verbose untuk menampilkan detail operasi.
Juga memperbaiki bug di validasi argumen.
```

### Branching

- `main` — Branch stabil.
- `develop` — Branch pengembangan.
- `feature/xxx` — Branch fitur.
- `bugfix/xxx` — Branch bug fix.

### Tag

Beri tag untuk rilis:

```sh
git tag -a v1.0.0 -m "Rilis versi 1.0.0"
git push origin v1.0.0
```

---

## 4.5.11 Distribusi Skrip

### Cara Distribusi

1. **File tunggal** — Skrip standalone.
2. **Tarball** — Arsip `.tar.gz`.
3. **Package manager** — `apt`, `dnf`, `brew`.
4. **Git clone** — Untuk proyek besar.

### Skrip Standalone

Skrip harus:
- Berisi semua yang diperlukan.
- Tidak bergantung pada pustaka eksternal (kecuali jika didokumentasikan).
- Portabel.

### Skrip dengan Pustaka

Jika skrip bergantung pada pustaka:

1. **Bundle pustaka** — Sertakan di dalam tarball.
2. **Install ke lokasi standar** — `/usr/local/lib/myapp/`.
3. **Dokumentasikan dependensi** — Di README.

### `install` untuk Deploy

```sh
#!/bin/sh
# install.sh

PREFIX="${PREFIX:-/usr/local}"
BINDIR="$PREFIX/bin"
LIBDIR="$PREFIX/lib/myapp"

# Buat direktori
mkdir -p "$BINDIR" "$LIBDIR" || exit 1

# Copy skrip
cp bin/myapp.sh "$BINDIR/myapp" || exit 1
chmod 755 "$BINDIR/myapp"

# Copy pustaka
cp lib/*.sh "$LIBDIR/" || exit 1
chmod 644 "$LIBDIR"/*.sh

echo "Instalasi selesai."
echo "Skrip: $BINDIR/myapp"
echo "Pustaka: $LIBDIR"
```

### Membuat Tarball

```sh
tar czf myapp-1.0.0.tar.gz \
    bin/ \
    lib/ \
    README.md \
    LICENSE
```

### Checksum

Selalu sertakan checksum untuk distribusi:

```sh
sha256sum myapp-1.0.0.tar.gz > myapp-1.0.0.tar.gz.sha256
```

Pengguna dapat memverifikasi:

```sh
sha256sum -c myapp-1.0.0.tar.gz.sha256
```

---

## 4.5.12 Membangun Pustaka yang Dapat Digunakan Ulang

### Prinsip Pustaka

1. **Satu tanggung jawab** — Satu file pustaka untuk satu domain (string, file, log).
2. **Guard sourcing ganda** — Cegah load berulang.
3. **Dokumentasi** — Setiap fungsi didokumentasikan.
4. **Test** — Setiap fungsi diuji.
5. **Portabilitas** — Hanya POSIX.
6. **Namespace** — Prefix fungsi untuk menghindari tabrakan.

### Contoh Pustaka dengan Namespace

```sh
# lib/str.sh

if [ -n "${_STR_SH_LOADED:-}" ]; then
    return 0
fi
_STR_SH_LOADED=1

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
```

Penjelasan:

- `_STR_SH_LOADED` — Guard.
- `str_` — Prefix namespace.
- Setiap fungsi hanya melakukan satu hal.

### Pustaka Logging

```sh
# lib/log.sh

if [ -n "${_LOG_SH_LOADED:-}" ]; then
    return 0
fi
_LOG_SH_LOADED=1

LOG_LEVEL="${LOG_LEVEL:-INFO}"
LOG_FILE="${LOG_FILE:-}"

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
    min_num=$(_log_level_num "$LOG_LEVEL")

    [ "$level_num" -ge "$min_num" ] || return 0

    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    baris="[$timestamp] [$level] $pesan"

    printf '%s\n' "$baris" >&2
    [ -n "$LOG_FILE" ] && printf '%s\n' "$baris" >> "$LOG_FILE"

    return 0
}

log_debug() { log "DEBUG" "$@"; }
log_info()  { log "INFO"  "$@"; }
log_warn()  { log "WARN"  "$@"; }
log_error() { log "ERROR" "$@"; }
log_fatal() { log "FATAL" "$@"; }
```

### Pustaka File

```sh
# lib/file.sh

if [ -n "${_FILE_SH_LOADED:-}" ]; then
    return 0
fi
_FILE_SH_LOADED=1

# file_ada: Cek keberadaan file.
file_ada() {
    [ -f "$1" ]
}

# dir_ada: Cek keberadaan direktori.
dir_ada() {
    [ -d "$1" ]
}

# file_bisa_dibaca: Cek izin baca.
file_bisa_dibaca() {
    [ -r "$1" ]
}

# file_ukuran: Dapatkan ukuran file dalam byte.
file_ukuran() {
    ls -l "$1" | awk '{ print $5 }'
}

# file_basename: Nama file tanpa direktori.
file_basename() {
    printf '%s' "${1##*/}"
}

# file_dirname: Direktori dari path.
file_dirname() {
    case "$1" in
        */*) printf '%s' "${1%/*}" ;;
        *) printf '.' ;;
    esac
}
```

### Menggunakan Pustaka

```sh
#!/bin/sh

SCRIPT_DIR=$(dirname "$0")

. "${SCRIPT_DIR}/lib/log.sh"
. "${SCRIPT_DIR}/lib/str.sh"
. "${SCRIPT_DIR}/lib/file.sh"

LOG_LEVEL=DEBUG
LOG_FILE="/tmp/myapp.log"

log_info "Program dimulai"

nama=$(str_trim "  Budi  ")
log_info "Nama: $nama"
log_info "Upper: $(str_upper "$nama")"

if file_ada "/etc/passwd"; then
    log_info "Ukuran: $(file_ukuran /etc/passwd) byte"
fi
```

---

## 4.5.13 Contoh Skrip Profesional Lengkap

Berikut adalah contoh skrip yang menerapkan semua praktik terbaik.

```sh
#!/bin/sh
#
# backup.sh — Backup file .txt dari direktori sumber ke direktori tujuan.
#
# Penulis: Budi Santoso <budi@example.com>
# Tanggal: 2026-01-01
# Versi:   1.0.0
# Lisensi: MIT
#
# Penggunaan:
#   backup.sh [opsi] SUMBER [TUJUAN]
#
# Opsi:
#   -h          Tampilkan bantuan
#   -v          Mode verbose
#   -V          Tampilkan versi
#   -d          Dry-run (simulasi)
#
# Exit Codes:
#   0 - Sukses
#   1 - Error umum
#   2 - Argumen tidak valid
#   3 - Sumber tidak valid
#

set -u

# ============================================================
# Konfigurasi
# ============================================================

readonly VERSION="1.0.0"
readonly DEFAULT_TUJUAN="backup"
readonly LOG_FILE="/tmp/backup.log"

VERBOSE=0
DRY_RUN=0

# ============================================================
# Fungsi Logging
# ============================================================

# log: Mencatat pesan dengan timestamp.
#
# Argumen:
#   $1 - Level (INFO, WARN, ERROR).
#   $@ - Pesan.
log() {
    level="$1"
    shift
    pesan="$*"
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    printf '[%s] [%s] %s\n' "$timestamp" "$level" "$pesan" >&2
    printf '[%s] [%s] %s\n' "$timestamp" "$level" "$pesan" >> "$LOG_FILE"
}

# ============================================================
# Fungsi Bantuan
# ============================================================

# tampilkan_bantuan: Menampilkan pesan bantuan.
tampilkan_bantuan() {
    cat <<EOF
Penggunaan: $0 [opsi] SUMBER [TUJUAN]

Backup file .txt dari direktori SUMBER ke direktori TUJUAN.
Jika TUJUAN tidak diberikan, default: $DEFAULT_TUJUAN

Opsi:
  -h          Tampilkan bantuan
  -v          Mode verbose
  -V          Tampilkan versi
  -d          Dry-run (simulasi)

Contoh:
  $0 /home/budi/dokumen
  $0 -v /home/budi/dokumen /mnt/backup
EOF
}

# tampilkan_versi: Menampilkan versi.
tampilkan_versi() {
    printf 'backup.sh versi %s\n' "$VERSION"
}

# ============================================================
# Fungsi Validasi
# ============================================================

# validasi_sumber: Memvalidasi direktori sumber.
#
# Argumen:
#   $1 - Path direktori sumber.
#
# Return:
#   0 - Valid.
#   3 - Tidak valid.
validasi_sumber() {
    sumber="$1"

    if [ ! -e "$sumber" ]; then
        log "ERROR" "Sumber tidak ada: $sumber"
        return 3
    fi

    if [ ! -d "$sumber" ]; then
        log "ERROR" "Sumber bukan direktori: $sumber"
        return 3
    fi

    if [ ! -r "$sumber" ]; then
        log "ERROR" "Sumber tidak dapat dibaca: $sumber"
        return 3
    fi

    return 0
}

# ============================================================
# Fungsi Utama
# ============================================================

# backup_file: Menyalin file .txt dari sumber ke tujuan.
#
# Argumen:
#   $1 - Direktori sumber.
#   $2 - Direktori tujuan.
#
# Return:
#   0 - Sukses.
backup_file() {
    sumber="$1"
    tujuan="$2"
    jumlah=0

    if [ "$DRY_RUN" -eq 1 ]; then
        log "INFO" "Dry-run: tidak ada file yang disalin."
    else
        mkdir -p "$tujuan" || {
            log "ERROR" "Tidak dapat membuat direktori: $tujuan"
            return 1
        }
    fi

    for file in "$sumber"/*.txt; do
        [ -f "$file" ] || continue

        nama=$(basename "$file")

        if [ "$DRY_RUN" -eq 1 ]; then
            [ "$VERBOSE" -eq 1 ] && log "INFO" "Akan disalin: $nama"
        else
            cp -p "$file" "$tujuan/" || {
                log "WARN" "Gagal menyalin: $nama"
                continue
            }
            [ "$VERBOSE" -eq 1 ] && log "INFO" "Disalin: $nama"
        fi

        jumlah=$((jumlah + 1))
    done

    log "INFO" "Total file: $jumlah"
    return 0
}

# ============================================================
# Fungsi Main
# ============================================================

main() {
    # Parsing argumen
    while getopts "hvVd" opt; do
        case "$opt" in
            h)
                tampilkan_bantuan
                exit 0
                ;;
            v)
                VERBOSE=1
                ;;
            V)
                tampilkan_versi
                exit 0
                ;;
            d)
                DRY_RUN=1
                ;;
            \?)
                printf 'Opsi tidak dikenal: -%s\n' "$OPTARG" >&2
                exit 2
                ;;
        esac
    done

    shift $((OPTIND - 1))

    # Validasi argumen posisi
    if [ $# -eq 0 ]; then
        printf 'Error: SUMBER harus diberikan.\n' >&2
        printf 'Gunakan -h untuk bantuan.\n' >&2
        exit 2
    fi

    SUMBER="$1"
    TUJUAN="${2:-$DEFAULT_TUJUAN}"

    # Validasi sumber
    validasi_sumber "$SUMBER"
    status=$?
    if [ "$status" -ne 0 ]; then
        exit "$status"
    fi

    # Mulai
    log "INFO" "Backup dimulai: $SUMBER -> $TUJUAN"

    backup_file "$SUMBER" "$TUJUAN"
    status=$?

    if [ "$status" -eq 0 ]; then
        log "INFO" "Backup selesai."
    else
        log "ERROR" "Backup gagal."
    fi

    exit "$status"
}

# ============================================================
# Eksekusi
# ============================================================

main "$@"
```

Penjelasan:

- Header lengkap.
- `set -u` untuk mendeteksi variabel tak terdefinisi.
- Konstanta di awal.
- Fungsi logging, bantuan, validasi, backup, main.
- `getopts` untuk parsing argumen.
- Dokumentasi setiap fungsi.
- Struktur `main`.
- Exit code yang konsisten.

---

## 4.5.14 Latihan

1. **Penamaan:**
   - Ambil skrip lama Anda.
   - Refaktor nama variabel dan fungsi agar deskriptif.
   - Terapkan konvensi: huruf kecil underscore untuk variabel, HURUF BESAR untuk konstanta.

2. **Header:**
   - Tambahkan header lengkap ke skrip Anda.
   - Sertakan deskripsi, penulis, tanggal, versi, penggunaan, opsi, exit codes.

3. **Dokumentasi Fungsi:**
   - Dokumentasikan setiap fungsi dengan format standar.
   - Sertakan argumen, output, return.

4. **`getopts`:**
   - Tulis skrip yang menerima `-v`, `-h`, `-o FILE`.
   - Gunakan `getopts`.
   - Tambahkan bantuan.

5. **Pola `main`:**
   - Refaktor skrip Anda untuk menggunakan pola `main`.
   - Pastikan fungsi dapat diuji terpisah.

6. **Gaya Kode:**
   - Terapkan 4 spasi indentasi.
   - Tambahkan spasi di sekitar operator.
   - Batasi panjang baris.

7. **Organisasi Proyek:**
   - Buat struktur `bin/`, `lib/`, `test/`.
   - Pindahkan fungsi ke pustaka.
   - Source dari `bin/`.

8. **Testing:**
   - Tulis test sederhana dengan `assert_eq`.
   - Uji fungsi pustaka.
   - Jalankan dengan `sh test/run_tests.sh`.

9. **Git:**
   - Inisialisasi git di proyek Anda.
   - Buat `.gitignore`.
   - Commit dengan pesan yang baik.
   - Buat tag `v1.0.0`.

10. **Distribusi:**
    - Buat `install.sh`.
    - Buat tarball.
    - Sertakan checksum.

11. **Pustaka:**
    - Buat pustaka `lib/math.sh` dengan fungsi `math_tambah`, `math_kurang`, dll.
    - Buat guard sourcing.
    - Dokumentasikan setiap fungsi.

12. **Audit:**
    - Audit skrip Anda terhadap semua praktik terbaik.
    - Identifikasi area yang perlu diperbaiki.
    - Perbaiki dan commit.

---

## 4.5.15 Ringkasan Materi 5

- **Penamaan**: huruf kecil underscore untuk variabel, HURUF BESAR untuk konstanta, prefix untuk fungsi internal.
- **Header skrip**: nama, deskripsi, penulis, tanggal, versi, penggunaan, opsi, exit codes.
- **Dokumentasi fungsi**: deskripsi, argumen, output, return, contoh.
- **`getopts`** untuk parsing opsi pendek; parsing manual untuk opsi panjang.
- **Pola `main`** memisahkan definisi dan eksekusi, memudahkan testing.
- **Gaya kode**: indentasi konsisten, spasi di sekitar operator, panjang baris terbatas, komentar yang bermakna.
- **Organisasi proyek**: `bin/`, `lib/`, `test/`, `doc/`.
- **Testing**: assertion sederhana, fixture, otomatisasi.
- **Version control**: git, commit message yang baik, tag.
- **Distribusi**: install script, tarball, checksum.
- **Pustaka**: satu tanggung jawab, guard sourcing, namespace, dokumentasi.

---

# Selamat!
## 🎉 Level 4 Selesai!

Anda telah menyelesaikan **Level 4 – Profesional**. Anda sekarang menguasai:

- **Error Handling & Defensive Programming** — trap, set -e, set -u, cleanup.
- **Portabilitas** — menghindari bashism, checklist POSIX, uji di berbagai shell.
- **Debugging** — set -x, PS4, trap ERR, shellcheck, strategi sistematis.
- **Keamanan** — command injection, quoting, sanitasi, symlink attack, SUID.
- **Praktik Terbaik & Gaya Kode** — penamaan, header, getopts, main, testing.

Anda sudah bisa menulis skrip yang **profesional**, **aman**, **portabel**, dan **mudah dipelihara**.

---

## 📌 Selanjutnya: Level 5 – Tingkat Dewa

Di Level 5, kita akan masuk ke topik yang membedakan **ahli** dari **master**:

- **Materi 1:** Optimasi Performa — menghindari fork, menggunakan built-in, paralelisasi.
- **Materi 2:** Arsitektur Skrip Kompleks — modularisasi, state management, konfigurasi.
- **Materi 3:** Process Substitution & FIFO — teknik lanjutan untuk komunikasi antar proses.
- **Materi 4:** Signal Handling & Job Control — trap, wait, jobs, daemon.
- **Materi 5:** Kontribusi Open Source — standar proyek, code review, testing lintas platform.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

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

