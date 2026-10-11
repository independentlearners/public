# **[Fase 3: Mahir – Skrip yang Andal dan Profesional (Tingkat Mahir)][1]**

**Tujuan Fase:** Mengubah skrip sederhana menjadi alat yang kuat, aman, dan siap produksi dengan penanganan kesalahan yang baik, antarmuka pengguna yang layak, dan praktik terbaik.

-----

## **Modul 3.1: Penanganan Kesalahan (Error Handling)**

### **Struktur Pembelajaran Internal:**

1. Filosofi "Fail-Fast" dan Keandalan Skrip
2. Mode "Unofficial Strict Mode": `set -euo pipefail`
3. Menangkap Sinyal dengan `trap` untuk Pembersihan
4. Menulis Pesan Error ke `stderr`
5. Strategi Penanganan Error yang Dapat Diprediksi
6. Alat Bantu Debugging: `set -x`, `bash -n`, dan `shellcheck`
7. `PIPESTATUS`, `trap ... ERR`, dan `set -o errtrace`
8. File Sementara yang Aman dengan `mktemp`
9. Validasi Variabel dengan `${VAR:?}`

### **1. Deskripsi Konkret & Peran dalam Kurikulum:**

Dalam modul ini, Anda akan belajar bagaimana membuat skrip Anda menjadi "tangguh" dan "bertanggung jawab". Artinya, ketika ada sesuatu yang salah, skrip tidak akan hanya diam-diam melanjutkan dengan asumsi yang salah atau merusak data. Sebaliknya, ia akan berhenti dengan aman, memberi tahu Anda apa yang salah, dan bahkan membersihkan sumber daya sementara yang mungkin ditinggalkannya. Ini adalah langkah penting untuk beralih dari skrip pribadi yang sederhana ke skrip yang dapat diandalkan dalam lingkungan produksi atau otomatisasi yang kompleks.

Peran modul ini adalah untuk menanamkan pemikiran defensif dalam penulisan skrip. Sama seperti dalam pengembangan Dart/Flutter di mana Anda perlu menangani *exception* dan *error* untuk menjaga stabilitas aplikasi, di Bash Anda perlu mengantisipasi kegagalan perintah dan memastikan skrip bereaksi secara tepat. Memahami penanganan kesalahan akan membedakan skrip amatir dari skrip profesional yang dapat dipercaya.

### **2. Konsep Kunci & Filosofi Mendalam:**

#### **2.1. Filosofi "Fail-Fast":**

Inti dari penanganan kesalahan yang baik adalah filosofi "fail-fast" (gagal cepat). Ini berarti jika terjadi kondisi kesalahan, skrip harus segera berhenti dan mengumumkan kegagalannya, daripada mencoba untuk "menerjang" kesalahan tersebut dan berpotensi menyebabkan masalah yang lebih besar atau kerusakan data di kemudian hari.

* **Mengapa Penting?**
  * **Pencegahan Kerusakan:** Mencegah skrip melanjutkan operasi yang salah dengan data yang tidak valid.
  * **Deteksi Dini:** Kesalahan terdeteksi lebih cepat, mempermudah *debugging*.
  * **Keandalan:** Skrip menjadi lebih dapat diprediksi dan diandalkan dalam lingkungan otomatis.

#### **2.2. Integritas dan Idempoten:**

Dalam konteks penanganan kesalahan, idealnya skrip harus berusaha untuk bersifat **idempoten**; yaitu, menjalankan skrip berkali-kali akan menghasilkan hasil yang sama seolah-olah hanya dijalankan sekali. Penanganan kesalahan yang kuat membantu mendekati ideal ini dengan memastikan pembersihan sumber daya dan status yang konsisten. Contoh praktis: sebelum membuat direktori, periksa dulu apakah direktori sudah ada (`mkdir -p`), dan sebelum menulis file, gunakan pola tulis-ke-temp-lalu-rename untuk menghindari file setengah jadi.

#### **2.3. Sinyal Sistem dan Interupsi:**

Sistem operasi Unix berkomunikasi dengan proses melalui **sinyal**. Sinyal seperti `INT` (Interrupt, biasanya dari `Ctrl+C`), `TERM` (Terminate, sinyal untuk mengakhiri proses), atau `EXIT` (sinyal yang dikirim saat proses berakhir, baik sukses maupun gagal) adalah mekanisme yang dapat Anda "tangkap" menggunakan perintah `trap` untuk melakukan tindakan pembersihan sebelum skrip benar-benar berhenti.

#### **2.4. *Exit Status* sebagai Bahasa Kesuksesan/Kegagalan:**

*Exit status* (nilai `$?`) adalah cara standar setiap perintah Unix mengkomunikasikan hasil eksekusinya. Nilai `0` berarti sukses, non-nol berarti gagal. Penanganan kesalahan sangat bergantung pada pemeriksaan *exit status* ini, baik secara implisit melalui `set -e` maupun secara eksplisit melalui pernyataan `if`.

### **3. Sintaks Dasar / Contoh Implementasi Inti:**

#### **3.1. Mode "Unofficial Strict Mode": `set -euo pipefail`:**

**Rekomendasi Mutlak:** Mulai setiap skrip Bash non-trivial Anda dengan baris berikut:

```bash
#!/bin/bash
set -euo pipefail # Unofficial Bash Strict Mode
```

* **`set -e` atau `set -o errexit`:**

  * **Perilaku:** Segera keluar dari skrip jika ada perintah yang gagal (mengembalikan *exit status* non-nol).
  * **Pengecualian:** `set -e` **tidak** akan keluar jika perintah yang gagal berada di dalam kondisi `if`, `while`, `until`, `&&`, `||`, tanda `!` (negasi), atau *subshell* dalam *command substitution* yang *output*-nya tidak ditangkap.

    ```bash
    #!/bin/bash
    echo "=== Contoh set -e ==="
    set -e

    echo "Perintah 1: Membuat direktori"
    mkdir -p test_dir_e   # -p membuat idempoten: tidak error jika sudah ada

    echo "Perintah 2: Mencoba membuat direktori yang sudah ada (akan gagal)"
    mkdir test_dir_e      # Ini akan menyebabkan skrip berhenti karena set -e

    echo "Baris ini tidak akan pernah dijalankan."
    ```

  * **Cara menjalankan:** Simpan sebagai `contoh_e.sh`, lalu:
    ```bash
    chmod +x contoh_e.sh
    ./contoh_e.sh
    ```
  * **Output yang diharapkan:** Pesan "Perintah 1..." dan "Perintah 2...", lalu skrip berhenti dengan pesan error dari `mkdir` (`mkdir: cannot create directory 'test_dir_e': File exists`). Baris terakhir tidak tercetak.
  * **Bersihkan:** `rmdir test_dir_e`

* **`set -u` atau `set -o nounset`:**

  * **Perilaku:** Segera keluar jika mencoba menggunakan variabel yang belum didefinisikan. Gunakan `${VAR:-default}` untuk memberikan nilai *default*, `${VAR:=default}` untuk mengisi sekaligus, atau `${VAR:?pesan}` untuk memaksa error dengan pesan kustom.

    ```bash
    #!/bin/bash
    echo "=== Contoh set -u ==="
    set -u

    DEFINED_VAR="nilai yang sudah didefinisikan"
    echo "Variabel terdefinisi: $DEFINED_VAR"

    # Aman untuk variabel yang mungkin belum ada:
    echo "Dengan default: ${MAYBE_VAR:-'nilai default'}"

    # Memaksa error dengan pesan kustom:
    # echo "Wajib: ${WAJIB_VAR:?'WAJIB_VAR harus diisi!'}"

    # Baris berikut akan menyebabkan skrip berhenti karena set -u:
    # echo "Variabel belum didefinisikan: $UNDEFINED_VAR"
    ```

  * **Cara menjalankan:** Hapus tanda komentar pada baris `$UNDEFINED_VAR` untuk melihat efeknya. Output yang diharapkan saat error: `contoh_u.sh: line N: UNDEFINED_VAR: unbound variable`.

* **`set -o pipefail`:**

  * **Perilaku:** Mengatur *exit status* dari sebuah *pipeline* menjadi *exit status* dari perintah yang gagal pertama (dari kiri ke kanan), bukan hanya *exit status* dari perintah terakhir.

    ```bash
    #!/bin/bash
    echo "=== Contoh set -o pipefail ==="
    set -euo pipefail

    echo "Mencoba memproses data dari perintah yang gagal di pipe..."
    false | wc -l   # false gagal (exit 1), wc sukses (exit 0)

    echo "Baris ini tidak akan pernah dijalankan karena pipefail."
    ```

  * **Output yang diharapkan:** Skrip berhenti setelah `false | wc -l`. Tanpa `pipefail`, skrip akan melanjutkan karena `wc` mengembalikan 0.

#### **3.2. Menangkap Sinyal dengan `trap` untuk Pembersihan:**

**Sintaks Umum:**

```bash
trap 'PERINTAH_ATAU_FUNGSI' SINYAL1 SINYAL2 ...
```

**Template Skrip Robust (Diperbaiki):**

```bash
#!/bin/bash
set -euo pipefail

# Variabel untuk menghindari cleanup ganda
CLEANUP_DONE=0

cleanup() {
  # Hindari cleanup ganda saat INT/TERM memicu EXIT
  if (( CLEANUP_DONE )); then
    return
  fi
  CLEANUP_DONE=1

  echo "--- Menjalankan pembersihan ---" >&2
  # Hapus file/direktori sementara jika ada
  if [[ -n "${TEMP_DIR:-}" && -d "$TEMP_DIR" ]]; then
    echo "Menghapus direktori sementara: $TEMP_DIR" >&2
    rm -rf "$TEMP_DIR"
  fi
  echo "Pembersihan selesai." >&2
}

# Tangkap EXIT (selalu), INT (Ctrl+C), TERM (kill)
trap cleanup EXIT
trap 'exit 130' INT    # 130 = 128 + 2 (SIGINT)
trap 'exit 143' TERM   # 143 = 128 + 15 (SIGTERM)

# Buat direktori sementara yang aman
TEMP_DIR="$(mktemp -d -t myapp.XXXXXX)"
echo "--- Skrip dimulai. TEMP_DIR=$TEMP_DIR ---"

touch "$TEMP_DIR/data.tmp"
echo "Melakukan pekerjaan..."
sleep 1

echo "Simulasi kegagalan..."
ls /direktori/palsu_yang_tidak_ada   # set -e akan menghentikan skrip

echo "Baris ini tidak akan tercapai."
```

* **Penjelasan:**
  * `trap cleanup EXIT` memastikan `cleanup` **selalu** dipanggil saat skrip keluar (sukses maupun gagal).
  * `trap 'exit 130' INT` dan `trap 'exit 143' TERM` memaksa skrip keluar dengan *exit code* standar Unix, sehingga `EXIT` kemudian memicu `cleanup`. Ini menghindari cleanup ganda.
  * `CLEANUP_DONE` sebagai pengaman kedua.
  * `mktemp -d` lebih aman daripada `/tmp/nama_file.$$` karena membuat nama unik yang tidak dapat diprediksi (mencegah serangan symlink).

#### **3.3. Menulis Pesan Error ke `stderr`:**

```bash
echo "Pesan error atau peringatan" >&2
```

**Contoh:**

```bash
#!/bin/bash
set -euo pipefail

validate_input() {
  local USER_INPUT="${1:-}"
  if [[ -z "$USER_INPUT" ]]; then
    echo "Error: Input tidak boleh kosong." >&2
    return 1
  fi
  if [[ "$USER_INPUT" == "admin" ]]; then
    echo "Peringatan: Pengguna 'admin' memiliki hak istimewa." >&2
  fi
  echo "Input diterima: $USER_INPUT"
  return 0
}

validate_input "JohnDoe"     # Output ke stdout
validate_input "" || exit 1  # Error ke stderr, keluar dengan status 1
```

* **Cara menjalankan & memisahkan stream:**
  ```bash
  chmod +x script.sh
  ./script.sh 2>errors.log 1>output.log
  ```

#### **3.4. Strategi Penanganan Error yang Dapat Diprediksi:**

* **Pengecekan Eksplisit yang Aman terhadap `set -e`:**

  ```bash
  #!/bin/bash
  set -euo pipefail

  download_file() {
    local URL="$1"
    local OUTPUT_FILE="$2"

    echo "Mencoba mengunduh '$URL' ke '$OUTPUT_FILE'..."
    # Gunakan 'if !' agar set -e tidak mematikan skrip di sini
    if ! wget -q -O "$OUTPUT_FILE" "$URL"; then
      echo "Error: Gagal mengunduh file dari $URL." >&2
      return 1
    fi
    echo "File berhasil diunduh."
    return 0
  }

  if download_file "http://invalid.url/nonexistent.txt" "downloaded_file.txt"; then
    echo "Lanjutkan pemrosesan file..."
  else
    echo "Operasi pengunduhan gagal, tidak melanjutkan." >&2
    exit 1
  fi
  ```

* **Eksekusi Kondisional dengan `||`:**

  ```bash
  #!/bin/bash
  set -euo pipefail

  # Fungsi harus didefinisikan SEBELUM dipanggil
  download_from_primary() {
    echo "Mencoba sumber utama..."
    return 1  # Simulasi gagal
  }

  download_from_backup() {
    echo "Mencoba sumber cadangan..."
    return 0  # Simulasi sukses
  }

  # Gunakan fungsi setelah didefinisikan
  download_from_primary || download_from_backup || {
    echo "Semua sumber gagal!" >&2
    exit 1
  }
  ```

  * **Catatan:** Blok `{ ... }` memerlukan spasi di sekitar kurung kurawal dan titik koma sebelum kurung penutup.

#### **3.5. Alat Bantu Debugging: `set -x`, `bash -n`, dan `shellcheck`:**

* **`set -x`:** Mencetak setiap perintah yang dieksekusi ke `stderr` dengan prefiks `+`. Berguna untuk melacak alur skrip.
  ```bash
  # Aktifkan hanya di bagian yang dicurigai
  set -x
  cp "$SRC" "$DST"
  set +x
  ```

* **`bash -n`:** Memeriksa sintaks skrip tanpa mengeksekusinya (dry-run sintaks).
  ```bash
  bash -n myscript.sh
  ```

* **`shellcheck`:** Linter statis untuk skrip shell yang mendeteksi ratusan pola kesalahan umum.
  ```bash
  shellcheck myscript.sh
  ```

* **`set -v`:** Mencetak baris skrip saat dibaca (bukan saat dieksekusi).

#### **3.6. `PIPESTATUS`, `trap ... ERR`, dan `set -o errtrace`:**

* **`PIPESTATUS`:** Array berisi *exit status* setiap perintah dalam *pipeline* terakhir.
  ```bash
  #!/bin/bash
  set -uo pipefail
  # Tanpa set -e, agar kita bisa memeriksa PIPESTATUS

  false | true | false
  echo "Status setiap perintah: ${PIPESTATUS[@]}"   # Output: 1 0 1
  ```

* **`trap ... ERR`:** Dijalankan setiap kali perintah gagal, bukan hanya pada `EXIT`.
  ```bash
  #!/bin/bash
  set -eE  # -E = errtrace: agar trap ERR diwariskan ke fungsi/subshell

  on_error() {
    local exit_code=$?
    local line_no=${1:-?}
    echo "Error di baris $line_no, exit code $exit_code" >&2
  }
  trap 'on_error $LINENO' ERR
  ```

* **`set -o errtrace` (`-E`):** Memastikan `trap ERR` juga aktif di dalam fungsi dan *subshell*.

#### **3.7. File Sementara yang Aman dengan `mktemp`:**

Selalu gunakan `mktemp` untuk file atau direktori sementara. Ini menghindari tabrakan nama dan kerentanan symlink.

```bash
#!/bin/bash
set -euo pipefail

TMPFILE="$(mktemp)"              # File sementara
TMPDIR="$(mktemp -d)"            # Direktori sementara

cleanup() {
  rm -f "$TMPFILE"
  rm -rf "$TMPDIR"
}
trap cleanup EXIT

echo "data" > "$TMPFILE"
echo "File temp: $TMPFILE"
echo "Dir temp:  $TMPDIR"
```

#### **3.8. Validasi Variabel dengan `${VAR:?}`:**

Memaksa error dengan pesan kustom jika variabel kosong atau tidak didefinisikan.

```bash
#!/bin/bash
set -euo pipefail

: "${API_KEY:?API_KEY wajib diisi sebelum menjalankan skrip ini.}"
echo "API_KEY terisi, panjang: ${#API_KEY}"
```

### **4. Terminologi Kunci:**

* **Penanganan Kesalahan (Error Handling):** Proses mengidentifikasi, merespons, dan mengelola kondisi kesalahan selama eksekusi skrip.
* **Filosofi "Fail-Fast":** Prinsip desain agar program segera berhenti saat mendeteksi kondisi kesalahan.
* **`set` options:** Perintah bawaan Bash untuk mengubah perilaku *shell*.
  * `set -e` (`errexit`): Keluar segera saat perintah gagal.
  * `set -u` (`nounset`): Keluar saat menggunakan variabel yang belum didefinisikan.
  * `set -o pipefail`: *Exit status* pipeline = status perintah gagal pertama.
  * `set -x` (`xtrace`): Cetak perintah yang dieksekusi.
  * `set -E` (`errtrace`): Warisi `trap ERR` ke fungsi/subshell.
  * `set -v` (`verbose`): Cetak baris skrip saat dibaca.
* **`trap`:** Menangkap sinyal (`EXIT`, `INT`, `TERM`, `ERR`, dll.) dan menjalankan fungsi/perintah sebagai respons.
* **Sinyal (Signal):** Komunikasi asinkron ke proses (`INT`, `TERM`, `KILL`, `HUP`).
* **`stderr`:** *File descriptor* 2, untuk pesan error dan diagnostik.
* **`PIPESTATUS`:** Array *exit status* setiap perintah dalam pipeline terakhir.
* **`mktemp`:** Membuat file/direktori sementara dengan nama unik dan aman.
* **`shellcheck`:** Linter statis untuk skrip shell.
* **Idempoten:** Operasi yang hasilnya sama meski dijalankan berulang kali.
* **`$$`:** PID dari shell saat ini (kurang aman untuk nama file, gunakan `mktemp`).
* **`${VAR:?pesan}`:** Memaksa error dengan pesan kustom jika `VAR` kosong/tidak terdefinisi.

### **5. Rekomendasi Visualisasi:**

* **Diagram Alur dengan `set -e`:** *Flowchart* dengan panah keluar setiap kali perintah gagal.
* **Diagram Pipeline dengan `pipefail`:** Ilustrasi *exit status* yang mengalir ke belakang dari setiap perintah ke awal pipeline.
* **Diagram Sinyal dan `trap`:** Skrip dengan panah sinyal (`Ctrl+C`, `kill`) masuk, memicu `trap`, lalu pembersihan, baru exit.
* **Diagram Siklus Hidup `mktemp` + `trap cleanup EXIT`:** Buat → pakai → bersihkan.

### **6. Hubungan dengan Modul Lain:**

Terhubung erat dengan **Modul 2.1 (Struktur Kondisional)** untuk pemeriksaan `$?`, dan **Modul 2.3 (Fungsi)** untuk fungsi `cleanup` dan nilai balik bermakna. Penanganan kesalahan kokoh adalah prasyarat untuk **Modul 3.2 (Argumen)** dan **Modul 3.3 (Regex)**, serta untuk **Modul 4.x (Skala Enterprise)**.

### **7. Sumber Referensi Lengkap:**

* **Unofficial Bash Strict Mode:** <http://redsymbol.net/articles/unofficial-bash-strict-mode/>
* **Bash Trap Command (Linuxize):** <https://linuxize.com/post/bash-trap-command/>
* **Bash Manual: The Set Builtin:** <https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html>
* **Bash Manual: Signals:** <https://www.gnu.org/software/bash/manual/html_node/Signals.html>
* **ShellCheck:** <https://www.shellcheck.net/>
* **Google Shell Style Guide:** <https://google.github.io/styleguide/shellguide.html>
* **Error Handling in Bash (Stack Abuse):** <https://stackabuse.com/error-handling-in-bash/>

### **8. Tips dan Praktik Terbaik:**

* Mulai setiap skrip dengan `set -euo pipefail`.
* Gunakan `trap cleanup EXIT` untuk pembersihan. Tambahkan `trap 'exit N' INT TERM` untuk *exit code* standar.
* Selalu gunakan `mktemp` untuk file/direktori sementara.
* Kirim semua diagnostik ke `stderr` (`>&2`).
* Berikan pesan error informatif: apa, mengapa, dan bagaimana memperbaiki.
* Gunakan `exit N` dengan `N` non-nol setelah error.
* Jalankan `shellcheck` dan `bash -n` sebelum *commit*.
* Untuk skrip produksi, gunakan *logging* terstruktur (JSON, `logger`, atau `journalctl`).

### **9. Potensi Kesalahan Umum & Solusi:**

* **Mengandalkan `$?` setelah `set -e`:** Gunakan `if ! perintah; then ...` atau `perintah || { ... }`.
* **Lupa mengutip perintah `trap`:** Gunakan kutipan tunggal: `trap 'echo pembersihan' EXIT` atau nama fungsi: `trap cleanup EXIT`.
* **Cleanup ganda dari `INT`/`TERM`:** Paksa `exit` di handler sinyal.
* **File sementara tidak dibersihkan pada `kill -9`:** Tidak dapat ditangkap. Gunakan `mktemp` dan desain idempoten.
* **Pesan error bercampur dengan output data:** Selalu `>&2`.
* **`pipefail` tanpa `set -e`:** Tidak akan menghentikan skrip. Gunakan bersamaan.
* **Menggunakan `$$` untuk nama file sementara:** Rentan symlink attack. Gunakan `mktemp`.

### **10. Latihan:**

1. Buat skrip yang membuat direktori `/tmp/latihan3_1.$$`, menulis file di dalamnya, lalu membersihkannya dengan `trap`. Uji dengan `Ctrl+C`.
2. Modifikasi agar skrip gagal dengan pesan kustom jika `$1` kosong (`${1:?...}`), dan panggil melalui `mktemp` untuk nama file sementara.
3. Gunakan `PIPESTATUS` untuk memeriksa status setiap perintah pada `grep pola file | sort | uniq -c` dan cetak mana yang gagal.
4. Jalankan `shellcheck` pada salah satu skrip lama Anda, perbaiki minimal 3 peringatan.

-----

## **Modul 3.2: Mem-parsing Argumen Baris Perintah**

### **Struktur Pembelajaran Internal:**

1. Filosofi Antarmuka Baris Perintah (CLI) yang Baik
2. Argumen Posisi Sederhana (`$1`, `$@`, `$*`, `shift`)
3. Menggunakan `getopts` untuk Parsing Opsi Singkat
4. Menangani Opsi dengan dan tanpa Argumen
5. Opsi Panjang (`--verbose`) dengan `getopt` GNU
6. Fungsi `usage()` atau `help()`
7. Akhiri Parsing Opsi dengan `--`
8. Validasi Argumen yang Ketat
9. Potensi Penambahan Materi: Parsing Manual untuk Kasus Khusus

### **1. Deskripsi Konkret & Peran dalam Kurikulum:**

Anda akan belajar merancang skrip agar menerima instruksi dan konfigurasi dari pengguna melalui baris perintah, seperti `ls -l` atau `cp -r sumber tujuan`. Anda akan membedakan **opsi** (diawali `-`) dan **argumen posisi** (data yang diproses). Fokus pada `getopts` (bawaan Bash) dan `getopt` (GNU, untuk opsi panjang).

Peran modul: meningkatkan **usability** dan **profesionalisme**. Skrip yang hanya bekerja dengan nilai *hardcoded* kurang fleksibel. Dengan mem-parsing argumen, skrip dapat digunakan non-interaktif, diintegrasikan dalam *pipeline* atau *cron*, dan diotomatisasi.

### **2. Konsep Kunci & Filosofi Mendalam:**

#### **2.1. Desain CLI yang Baik:**
Konsisten dengan konvensi Unix (`-v` untuk *verbose*, `-h` untuk *help*), jelas, prediktif, dan fleksibel.

#### **2.2. Pemisahan Konfigurasi dari Logika:**
Konfigurasi lewat argumen memisahkan *data* dari *logika*, membuat skrip modular dan mudah di-*debug*.

#### **2.3. Opsi vs. Argumen Posisi:**
Opsi **mengubah perilaku**; argumen posisi adalah **data** yang dioperasikan.

#### **2.4. Pentingnya `usage()`:**
Setiap CLI harus menyediakan cara bagi pengguna untuk mengetahui cara menggunakannya, biasanya melalui `-h`/`--help` yang mencetak ke `stderr` dan `exit 1` (atau `0` jika diminta eksplisit).

### **3. Sintaks Dasar / Contoh Implementasi Inti:**

#### **3.1. Argumen Posisi Sederhana:**

* `$0`: Nama skrip. `$1..$N`: Argumen posisi. `$#`: Jumlah argumen.
* `$@`: Semua argumen sebagai string terpisah. **Direkomendasikan.**
* `$*`: Semua argumen sebagai satu string. **Hindari** (masalah spasi).
* `shift N`: Menggeser argumen posisi ke kiri sebanyak N.

```bash
#!/bin/bash
set -euo pipefail

echo "Nama skrip: $0"
echo "Jumlah argumen: $#"

if [[ $# -lt 2 ]]; then
  echo "Penggunaan: $0 <nama_depan> <nama_belakang>" >&2
  exit 1
fi

NAMA_DEPAN="$1"
NAMA_BELAKANG="$2"
echo "Halo, $NAMA_DEPAN $NAMA_BELAKANG!"

echo "Semua argumen (menggunakan \$@):"
for ARG in "$@"; do
  echo "  - $ARG"
done

shift 2
echo "Argumen tersisa setelah shift 2:"
for FILE in "$@"; do
  echo "Memproses: $FILE"
done
```

#### **3.2. Menggunakan `getopts` untuk Opsi Singkat:**

**Sintaks:**

```bash
while getopts ":DAFTAR_OPSI" VAR_OPSI; do
  case "${VAR_OPSI}" in
    a) ... ;;
    b) ... ; VARIABEL="${OPTARG}" ;;
    :) echo "Error: Opsi -${OPTARG} butuh argumen." >&2; usage ;;
    \?) echo "Error: Opsi tidak valid: -${OPTARG}." >&2; usage ;;
  esac
done
shift $((OPTIND - 1))
```

* Titik dua di awal (`:`): mode *silent error reporting*.
* Titik dua setelah huruf (mis. `o:`): opsi membutuhkan argumen.
* `OPTARG`: Nilai argumen opsi.
* `OPTIND`: Indeks argumen berikutnya (untuk `shift`).

**Contoh Lengkap dengan `-h`, `--`, dan Validasi:**

```bash
#!/bin/bash
set -euo pipefail

VERBOSE=0
OUTPUT_FILE="output.txt"
INPUT_FILE=""

usage() {
  cat >&2 <<EOF
Penggunaan: $0 [-v] [-h] [-o FILE_OUTPUT] [--] <file_input>...

  -v              Mode verbose.
  -h              Tampilkan bantuan ini.
  -o FILE_OUTPUT  File output (default: output.txt).
  --              Akhiri parsing opsi (untuk file yang diawali '-').
  <file_input>    Satu atau lebih file input (wajib).

Contoh:
  $0 -v -o hasil.log data1.txt data2.txt
  $0 -- -file_yang_diawali_dash.txt
EOF
  exit "${1:-1}"
}

while getopts ":vho:" opt; do
  case "${opt}" in
    v) VERBOSE=1 ;;
    h) usage 0 ;;
    o) OUTPUT_FILE="${OPTARG}" ;;
    :)
      echo "Error: Opsi -${OPTARG} memerlukan argumen." >&2
      usage
      ;;
    \?)
      echo "Error: Opsi tidak valid: -${OPTARG}." >&2
      usage
      ;;
  esac
done
shift $((OPTIND - 1))

# '--' sudah ditangani getopts secara otomatis (argumen setelah '--' tetap ada)
if [[ $# -lt 1 ]]; then
  echo "Error: Minimal satu file input wajib ditentukan." >&2
  usage
fi

if [[ "$VERBOSE" -eq 1 ]]; then
  echo "Mode verbose aktif." >&2
fi

for INPUT_FILE in "$@"; do
  if [[ ! -r "$INPUT_FILE" ]]; then
    echo "Error: File '$INPUT_FILE' tidak dapat dibaca." >&2
    exit 1
  fi
  echo "Memproses: $INPUT_FILE"
done

echo "Menulis output ke: $OUTPUT_FILE"
: > "$OUTPUT_FILE"   # Contoh: kosongkan file output
```

* **Cara menjalankan (uji semua skenario):**
  ```bash
  chmod +x script.sh
  ./script.sh -h
  ./script.sh file.txt
  ./script.sh -v file.txt
  ./script.sh -o hasil.log file.txt
  ./script.sh -x file.txt                 # Error: opsi tidak valid
  ./script.sh -o                          # Error: opsi butuh argumen
  ./script.sh -- -file.txt                # Memproses file yang diawali '-'
  ```

#### **3.3. Opsi Panjang dengan `getopt` GNU:**

`getopts` tidak mendukung opsi panjang. Untuk `--verbose`, gunakan `getopt` GNU (perhatikan tanpa `s`).

**Sintaks `getopt`:**

```bash
getopt -o vo:h --long verbose,output:,help -n "$0" -- "$@"
```

* `-o vo:h`: opsi singkat (`v`, `o:`, `h`).
* `--long verbose,output:,help`: opsi panjang (`output:` butuh argumen).
* `-n "$0"`: nama program untuk pesan error.
* `-- "$@"`: pemisah dan argumen.
* `eval set --` untuk mengatur ulang argumen posisi.

**Contoh:**

```bash
#!/bin/bash
set -euo pipefail

VERBOSE=0
OUTPUT_FILE="output.txt"

usage() {
  cat >&2 <<EOF
Penggunaan: $0 [-v|--verbose] [-h|--help] [-o FILE|--output FILE] [--] <file>...
EOF
  exit 1
}

# Parsing dengan getopt GNU
PARSED=$(getopt -o vho: --long verbose,help,output: -n "$0" -- "$@") || {
  echo "Error: parsing argumen gagal." >&2
  usage
}
eval set -- "$PARSED"

while true; do
  case "$1" in
    -v|--verbose) VERBOSE=1; shift ;;
    -h|--help)    usage ;;
    -o|--output)  OUTPUT_FILE="$2"; shift 2 ;;
    --)           shift; break ;;
    *)
      echo "Error: opsi tidak terduga: $1" >&2
      usage
      ;;
  esac
done

if [[ $# -lt 1 ]]; then
  echo "Error: minimal satu file input." >&2
  usage
fi

echo "Verbose: $VERBOSE, Output: $OUTPUT_FILE"
for f in "$@"; do
  echo "File: $f"
done
```

* **Catatan:** `getopt` GNU tidak tersedia secara *default* di macOS. Di sana, gunakan `getopts` atau parsing manual.

#### **3.4. Validasi Argumen yang Ketat:**

```bash
validate_file() {
  local f="$1"
  if [[ ! -e "$f" ]]; then
    echo "Error: '$f' tidak ada." >&2
    return 1
  fi
  if [[ ! -f "$f" ]]; then
    echo "Error: '$f' bukan file reguler." >&2
    return 1
  fi
  if [[ ! -r "$f" ]]; then
    echo "Error: '$f' tidak dapat dibaca." >&2
    return 1
  fi
  return 0
}
```

### **4. Terminologi Kunci:**

* **Argumen Baris Perintah:** Informasi yang dilewatkan ke skrip saat eksekusi.
* **Opsi (Option/Flag):** Argumen dengan awalan `-`/`--` yang mengubah perilaku.
* **Argumen Posisi:** Argumen yang maknanya ditentukan posisinya.
* **`getopts`:** Bawaan Bash untuk opsi singkat, POSIX-compliant.
* **`getopt`:** Program eksternal (GNU) yang mendukung opsi panjang dan penggabungan.
* **`OPTIND`, `OPTARG`:** Variabel khusus `getopts`.
* **`usage()`/`help()`:** Fungsi untuk mencetak cara pakai.
* **`shift`:** Menggeser argumen posisi ke kiri.
* **`--`:** Penanda akhir parsing opsi.
* **POSIX-compliant:** Mengikuti standar POSIX (portabel antar shell Unix).

### **5. Rekomendasi Visualisasi:**

* **Diagram Alur Parsing:** Skrip menerima `$@` → `getopts` mengiterasi → setiap opsi disimpan dalam variabel → `shift $((OPTIND-1))` → argumen posisi diproses.
* **Tabel Perbandingan `getopts` vs `getopt`.**

### **6. Hubungan dengan Modul Lain:**

Membangun di atas **Modul 1.3 (Variabel & Ekspansi)** dan **Modul 2.3 (Fungsi)**. **Modul 3.1 (Error Handling)** sangat penting untuk memvalidasi argumen. Fondasi untuk skrip kompleks di **Fase 3–4** (backup, deploy, parsing data).

### **7. Sumber Referensi Lengkap:**

* **Parsing command-line arguments in Bash (Stack Abuse):** <https://stackabuse.com/how-to-parse-command-line-arguments-in-bash/>
* **Greg's Wiki - BashFAQ/035:** <https://mywiki.wooledge.org/BashFAQ/035>
* **Bash Manual: getopts:** <https://www.gnu.org/software/bash/manual/bash.html#getopts>
* **Bash Manual: Shell Parameters:** <https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameters>
* **util-linux getopt(1):** <https://man7.org/linux/man-pages/man1/getopt.1.html>

### **8. Tips dan Praktik Terbaik:**

* Prioritaskan `getopts` untuk opsi singkat; gunakan `getopt` GNU hanya jika butuh opsi panjang dan Anda dapat mengandalkan keberadaannya.
* Selalu `shift $((OPTIND - 1))` setelah `getopts`.
* Implementasikan `usage()` yang jelas, panggil dari `-h` dan dari kondisi error.
* Validasi setiap argumen: keberadaan, tipe (file/direktori), izin.
* Kutip ganda variabel argumen (`"$OPTARG"`, `"$1"`, `"$@"`).
* Gunakan `--` untuk mengakhiri opsi.
* Berikan pesan error ke `stderr` dan `exit` dengan kode non-nol.

### **9. Potensi Kesalahan Umum & Solusi:**

* **Lupa `shift $((OPTIND - 1))`:** Argumen posisi masih berisi opsi. Tambahkan setelah loop `getopts`.
* **Lupa titik dua di awal daftar opsi `getopts`:** Gunakan `":vo:"` untuk penanganan error kustom.
* **Keliru `getopt` vs `getopts`:** `getopt` (GNU) untuk opsi panjang; `getopts` bawaan untuk singkat.
* **Tidak memvalidasi argumen wajib:** Periksa setelah `shift`.
* **Menggunakan `getopt` di sistem non-GNU:** Sediakan fallback.
* **Tidak menangani `--`:** Argumen yang diawali `-` gagal diproses.

### **10. Latihan:**

1. Buat skrip `ganti_nama.sh` yang menerima `-d DIREKTORI`, `-p POLA`, dan `-v` untuk verbose. Wajib ada argumen posisi berupa nama file target.
2. Tambahkan `--help` dan `--verbose` menggunakan `getopt` GNU.
3. Uji bahwa `./ganti_nama.sh -- -file-aneh.txt` tetap memproses `-file-aneh.txt` dengan benar.

-----

## **Modul 3.3: Ekspresi Reguler (Regex) dan Manipulasi Teks Tingkat Lanjut**

### **Struktur Pembelajaran Internal:**

1. Filosofi "Teks adalah Antarmuka Universal"
2. Pengenalan Regex: BRE, ERE, PCRE
3. Pola Dasar: Literal, Metacharacter, Kuantifier, Kelas Karakter POSIX
4. `grep` Mendalam: `-o`, `-c`, `-q`, `-A/-B/-C`, `-P`, `-z`
5. `sed` Mendalam: `-i`, alamat, `c`/`i`/`a`, sintaks portabel
6. `awk` Mendalam: Array Asosiatif, `printf`, Kontrol Alur
7. Kelompok, Referensi Balik, dan `[[ =~ ]]`
8. Toolkit Manipulasi Teks: `cut`, `sort`, `uniq`, `tr`, `xargs`, `find -print0`
9. Potensi Penambahan Materi: `lookarounds`, PCRE, `ripgrep`

### **1. Deskripsi Konkret & Peran dalam Kurikulum:**

Modul ini tentang seni **Ekspresi Reguler (Regex)** dan alat manipulasi teks klasik Unix (`grep`, `sed`, `awk`) plus toolkit pendukung (`cut`, `sort`, `uniq`, `tr`, `xargs`). Ini adalah keterampilan inti untuk analisis log, *parsing* output, ekstraksi data, dan transformasi format.

Filosofi Unix: "Tulis program untuk menangani aliran teks, karena itu adalah antarmuka universal." Regex adalah jembatan untuk memanfaatkan filosofi ini.

### **2. Konsep Kunci & Filosofi Mendalam:**

#### **2.1. Teks sebagai Antarmuka Universal:**
Hampir semua output program Unix adalah teks, memungkinkan penggabungan via *pipe*.

#### **2.2. Pola, Bukan Pencarian Literal:**
Regex mendefinisikan *struktur*, bukan *string* spesifik.

#### **2.3. Tiga Rasa Regex:**
* **BRE (Basic Regular Expression):** Default `grep` dan `sed`. Meta `+`, `?`, `|`, `()`, `{}` harus di-*escape*.
* **ERE (Extended Regular Expression):** `grep -E`, `sed -E`. Meta di atas aktif secara langsung. **Direkomendasikan.**
* **PCRE (Perl Compatible Regular Expression):** `grep -P`, `ripgrep`. Mendukung *lookaround*, *backreference* di dalam pola, `\d`, `\w`, dll.

#### **2.4. `grep`, `sed`, `awk` — Tiga Pilar:**
* `grep`: *filter* baris.
* `sed`: *editor* aliran baris-per-baris.
* `awk`: *prosesor* berbasis kolom dan bahasa pemrograman mini.

### **3. Sintaks Dasar / Contoh Implementasi Inti:**

#### **3.1. Metacharacter dan Kelas POSIX:**

* `.` : sembarang karakter (kecuali newline)
* `*` : 0 atau lebih
* `+` : 1 atau lebih (ERE)
* `?` : 0 atau 1 (ERE)
* `^`, `$`: awal/akhir baris
* `[]`: kelas karakter; `[^...]`: negasi
* `|` : OR (ERE)
* `()`: grup (ERE)
* `\` : escape

**Kelas POSIX:**

| Kelas | Padanan |
|---|---|
| `[[:digit:]]` | `[0-9]` |
| `[[:alpha:]]` | `[A-Za-z]` |
| `[[:alnum:]]` | `[A-Za-z0-9]` |
| `[[:space:]]` | spasi, tab, newline |
| `[[:upper:]]`, `[[:lower:]]` | huruf besar/kecil |
| `[[:punct:]]` | tanda baca |
| `[[:xdigit:]]` | digit heksadesimal |

Kelas POSIX bersifat *locale-aware*, jadi lebih aman daripada rentang eksplisit.

#### **3.2. `grep` Mendalam:**

```bash
#!/bin/bash
set -euo pipefail
LOG=/tmp/latihan_grep.log

cat > "$LOG" <<'EOF'
2024-01-01 INFO  User login: alice
2024-01-01 ERROR Koneksi ke database gagal
2024-01-02 INFO  User login: bob
2024-01-02 WARN  Memori rendah
2024-01-03 ERROR Timeout pada request
2024-01-03 INFO  Proses selesai
EOF

echo "1) -c: hitung baris ERROR"
grep -c 'ERROR' "$LOG"          # Output: 2

echo "2) -o: cetak hanya yang cocok"
grep -oE '[A-Z]+' "$LOG"        # INFO, ERROR, ...

echo "3) -q: silent (exit status saja)"
if grep -q 'CRITICAL' "$LOG"; then
  echo "Ada CRITICAL"
else
  echo "Tidak ada CRITICAL (exit $?)"   # Output: Tidak ada CRITICAL (exit 1)
fi

echo "4) -A/-B/-C: konteks"
grep -B1 -A1 'WARN' "$LOG"

echo "5) -P (PCRE): lookbehind"
grep -oP '(?<=User login: )\w+' "$LOG"   # alice, bob

echo "6) -r: rekursif"
# grep -rn 'TODO' ./src

echo "7) -z: null-separated (untuk file dengan newline dalam nama)"
# find . -print0 | grep -z 'pola'

rm -f "$LOG"
```

* **Opsi penting lain:** `-i` (case-insensitive), `-v` (invert), `-n` (nomor baris), `-l` (nama file saja), `-L` (nama file yang tidak cocok), `-w` (whole word), `-x` (whole line).

#### **3.3. `sed` Mendalam:**

```bash
#!/bin/bash
set -euo pipefail
F=/tmp/latihan_sed.txt
cat > "$F" <<'EOF'
apel,jeruk,mangga
anggur,pisang
apel,anggur
EOF

echo "1) substitusi global: koma -> spasi"
sed 's/,/ /g' "$F"

echo "2) hapus baris berisi 'anggur'"
sed '/anggur/d' "$F"

echo "3) -i: edit in-place dengan backup .bak"
cp "$F" "$F.orig"
sed -i.bak 's/apel/APEL/g' "$F"
cat "$F"
# Sekarang $F sudah berubah, $F.bak berisi versi lama

echo "4) -n dan p: cetak hanya baris yang cocok"
sed -n '/jeruk/p' "$F.orig"

echo "5) ganti seluruh baris (c)"
sed '/^apel/c Baris APEL diganti' "$F.orig"

echo "6) sisipkan sebelum (i) dan setelah (a) - sintaks portabel GNU"
sed '/^anggur/i\--- Sebelum anggur ---' "$F.orig"
sed '/^anggur/a\--- Setelah anggur ---' "$F.orig"

echo "7) referensi balik: tukar dua kolom"
sed -E 's/^([^,]+),([^,]+)/\2,\1/' "$F.orig"

rm -f "$F" "$F.orig" "$F.bak"
```

* **Catatan Portabilitas:** Sintaks `i\`, `a\`, dan `c\` berbeda antara GNU `sed` (Linux) dan BSD `sed` (macOS). Di BSD/macOS, biasanya `sed -i ''` dan sintaks `i\` harus diikuti newline literal. Untuk skrip portabel, gunakan pendekatan berbasis `awk` atau `perl`.
* **`-i` pada macOS:** Gunakan `sed -i '' 's/a/b/'` (perhatikan argumen kosong).

#### **3.4. `awk` Mendalam:**

```bash
#!/bin/bash
set -euo pipefail
DATA=/tmp/latihan_awk.csv
cat > "$DATA" <<'EOF'
nama,usia,kota
Andi,30,Jakarta
Budi,25,Bandung
Citra,35,Surabaya
Dewi,28,Jakarta
EOF

echo "1) Filter kolom: usia > 28"
awk -F',' 'NR>1 && $2>28 { print $1, $2 }' "$DATA"

echo "2) printf untuk format rapi"
awk -F',' 'NR>1 { printf "%-8s %3d %s\n", $1, $2, $3 }' "$DATA"

echo "3) Array asosiatif: hitung per kota"
awk -F',' 'NR>1 { kota[$3]++ }
           END { for (k in kota) printf "%s: %d\n", k, kota[k] }' "$DATA"

echo "4) Kontrol alur dan fungsi"
awk -F',' 'NR>1 {
  if ($2 > 30) kategori="senior"; else kategori="junior";
  print $1, "=>", kategori
}' "$DATA"

echo "5) Total dan rata-rata"
awk -F',' 'NR>1 { sum+=$2; n++ }
           END { printf "Total=%d Rata-rata=%.2f\n", sum, sum/n }' "$DATA"

echo "6) Ganti delimiter output dengan -v OFS"
awk -F',' -v OFS='|' 'NR>1 { print $3, $1 }' "$DATA"

rm -f "$DATA"
```

* **Variabel khusus:** `$0` (baris), `$1..$NF` (kolom), `NF` (jumlah kolom), `NR` (nomor baris), `FNR` (baris dalam file saat ini), `FS`, `OFS`, `RS`, `ORS`.
* **Blok:** `BEGIN`, `END`, `pattern { action }`.

#### **3.5. Kelompok, Referensi Balik, dan `[[ =~ ]]`:**

Bash mendukung pencocokan regex dengan `[[ ... =~ ... ]]`:

```bash
#!/bin/bash
set -euo pipefail

EMAIL="user@example.com"
if [[ "$EMAIL" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
  echo "Email valid"
else
  echo "Email tidak valid"
fi

# Grup tangkapan tersedia di BASH_REMATCH
TANGGAL="2024-03-15"
if [[ "$TANGGAL" =~ ^([0-9]{4})-([0-9]{2})-([0-9]{2})$ ]]; then
  echo "Tahun: ${BASH_REMATCH[1]}"
  echo "Bulan: ${BASH_REMATCH[2]}"
  echo "Hari:  ${BASH_REMATCH[3]}"
fi
```

* **Penting:** Jangan kutip pola `=~` jika menggunakan regex; kutip variabelnya.
* **`sed` referensi balik:**

```bash
echo "Nama: John Doe, ID: 12345" | \
  sed -E 's/Nama: ([^,]+), ID: ([0-9]+)/ID \2 (Nama \1)/'
# Output: ID 12345 (Nama John Doe)
```

#### **3.6. Toolkit Manipulasi Teks:**

* **`cut`:** Ambil kolom/karakter.
  ```bash
  echo "a:b:c" | cut -d':' -f2        # b
  echo "abcdef" | cut -c1-3           # abc
  ```
* **`sort`:** Urutkan.
  ```bash
  sort file.txt
  sort -n -k2,2 file.txt              # numerik pada kolom 2
  sort -u file.txt                    # unik
  ```
* **`uniq`:** Deduplikasi (butuh input terurut).
  ```bash
  sort file.txt | uniq -c             # hitung frekuensi
  sort file.txt | uniq -d             # hanya yang duplikat
  ```
* **`tr`:** Translasi/hapus karakter.
  ```bash
  echo "abc" | tr 'a-z' 'A-Z'         # ABC
  echo "a b c" | tr -d ' '            # abc
  echo "a\nb" | tr -s '\n'            # squeeze newline
  ```
* **`xargs`:** Bangun argumen dari stdin.
  ```bash
  find . -name '*.tmp' -print0 | xargs -0 rm -f
  echo "a b c" | xargs -n1 echo       # satu per baris
  ```
* **`find -print0` + `xargs -0`:** Aman terhadap nama file dengan spasi/newline.

  ```bash
  # SALAH: rusak jika nama file mengandung spasi
  for f in $(ls *.txt); do ...; done

  # BENAR 1: glob expansion (aman untuk spasi, tidak untuk newline)
  for f in *.txt; do ...; done

  # BENAR 2: find + null-separator
  find . -name '*.txt' -print0 | while IFS= read -r -d '' f; do
    echo "Memproses: $f"
  done
  ```

### **4. Terminologi Kunci:**

* **Regex:** Pola untuk pencocokan string.
* **BRE, ERE, PCRE:** Tiga varian regex.
* **`grep`/`sed`/`awk`:** Filter/editor/prosesor teks.
* **Metacharacter:** Karakter dengan makna khusus (`.`, `*`, `+`, `?`, `[]`, `()`, `|`, `^`, `$`, `\`).
* **Kuantifier:** `*`, `+`, `?`, `{n}`, `{n,}`, `{n,m}`.
* **Kelas Karakter POSIX:** `[[:digit:]]`, `[[:alpha:]]`, dll.
* **Anchor:** `^`, `$`, `\b`, `\B`.
* **Grup Penangkapan:** `(...)`, diakses via `\1`, `\2`, atau `BASH_REMATCH`.
* **Referensi Balik:** `\1`, `\2`, ...
* **`BASH_REMATCH`:** Array grup tangkapan setelah `[[ =~ ]]`.
* **Delimiter:** Pemisah kolom (`-F` di awk, `-d` di cut).
* **Locale-aware:** Beradaptasi dengan pengaturan lokal.

### **5. Rekomendasi Visualisasi:**

* **Infografis Metacharacter dan Kelas POSIX.**
* **Diagram Alir Pipeline:** `cat file | grep ... | sed ... | awk ... | sort | uniq -c`.
* **Tabel Perbandingan BRE vs ERE vs PCRE.**
* **Diagram `find -print0` + `xargs -0`.**

### **6. Hubungan dengan Modul Lain:**

Melanjutkan **Modul 1.2 (I/O Redirection)** dan **1.3 (Variabel)**. Terkait **2.1 (Kondisional)** untuk pemeriksaan hasil `grep`. Menjadi fondasi **Modul 4.x** untuk analisis log, keamanan, dan interoperabilitas.

### **7. Sumber Referensi Lengkap:**

* **RegexOne (interaktif):** <https://regexone.com/>
* **Regular-Expressions.info:** <https://www.regular-expressions.info/>
* **TLDP ABS Guide - Regular Expressions:** <https://tldp.org/LDP/abs/html/regexp.html>
* **Ryan's Tutorials - Grep/Sed/Awk:** <https://ryanstutorials.net/linuxtutorial/>
* **Greg's Wiki - ParsingLs:** <https://mywiki.wooledge.org/ParsingLs>
* **GNU Grep Manual:** <https://www.gnu.org/software/grep/manual/>
* **GNU Sed Manual:** <https://www.gnu.org/software/sed/manual/>
* **GNU Awk Manual:** <https://www.gnu.org/software/gawk/manual/>
* **ripgrep:** <https://github.com/BurntSushi/ripgrep>

### **8. Tips dan Praktik Terbaik:**

* Mulai dari pola sederhana, uji, baru tambahkan kompleksitas.
* Gunakan `-E` untuk ERE di `grep`/`sed` (lebih mudah dibaca).
* Selalu uji regex pada sample kecil dengan `regex101.com` atau `regexr.com`.
* Gunakan kutipan tunggal (`'...'`) untuk pola regex agar shell tidak mengekspansi karakter.
* Pilih alat yang tepat: `grep` untuk filter, `sed` untuk edit, `awk` untuk kolom/logika.
* Untuk nama file yang tidak aman, gunakan `find -print0 | xargs -0` atau `while IFS= read -r -d ''`.
* Hindari mem-parsing `ls`; gunakan glob atau `find`.
* Prefer `ripgrep` (`rg`) jika tersedia untuk performa dan fitur.

### **9. Potensi Kesalahan Umum & Solusi:**

* **Lupa escape metacharacter:** Gunakan `\.`, `\*`, dst, atau `grep -F`.
* **Tidak mengutip pola:** Selalu kutip tunggal: `grep 'pola'`.
* **Memakai BRE tapi mengandalkan ERE:** Gunakan `-E`.
* **`sed` hanya mengganti kemunculan pertama:** Tambahkan bendera `g`: `sed 's/a/b/g'`.
* **Mem-parsing `ls`:** Gunakan `find -print0` atau glob.
* **`sed -i` di macOS vs Linux:** Perbedaan sintaks; sediakan cabang `case "$(uname)"` atau gunakan `perl -i` untuk portabilitas.
* **Lupa `NR>1` di `awk` untuk melewati header.**
* **Memakai `[[ =~ ]]` dengan pola yang dikutip:** Jangan kutip polanya; kutip variabelnya.
* **Mengabaikan return code `grep` di bawah `set -e`:** `grep` mengembalikan 1 jika tidak ada kecocokan. Gunakan `if grep -q ...; then`.

### **10. Latihan:**

1. Dari file `/var/log/syslog`, ekstrak semua alamat IP unik dan hitung frekuensinya dengan `grep -oE`, `sort`, dan `uniq -c`.
2. Buat skrip yang menerima file CSV, menggunakan `awk` untuk menghitung rata-rata kolom numerik, dan mencetak hasilnya dengan `printf`.
3. Gunakan `[[ =~ ]]` untuk memvalidasi apakah argumen `$1` adalah IPv4 yang valid.
4. Ganti semua ekstensi `.jpeg` menjadi `.jpg` pada semua file di direktori saat ini secara aman (uji dengan `find -print0` + `while read`).
5. Bandingkan hasil `grep 'ERROR' log` dengan `grep -E 'ERROR|WARN' log`, dan jelaskan perbedaannya.

-----

**Selamat!** Anda telah menyelesaikan **Fase 3: Mahir – Skrip yang Andal dan Profesional** secara lengkap, dengan penanganan kesalahan yang kokoh, parsing argumen yang profesional, serta kemampuan manipulasi teks tingkat lanjut. Anda siap masuk ke **Fase 4: Pakar – Aplikasi Skala Enterprise dan Keamanan**.

-----

> ⬆️ **[Ke Atas](#)**
> ➡️ **[Modul Berikutnya (Fase 4)][selanjutnya]**
> 📘 **[Kurikulum]**
> 🌐 **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ./../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

<!----------------------------------------------------->
 [1]: ../README.md
