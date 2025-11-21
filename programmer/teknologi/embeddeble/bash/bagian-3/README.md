# **[Fase 3: Mahir – Skrip yang Andal dan Profesional (Tingkat Mahir)][1]**

**Tujuan Fase:** Mengubah skrip sederhana menjadi alat yang kuat, aman, dan siap produksi dengan penanganan kesalahan yang baik, antarmuka pengguna yang layak, dan praktik terbaik.

-----

## **Modul 3.1: Penanganan Kesalahan (Error Handling)**

### **Struktur Pembelajaran Internal (Struktur Daftar Isi):**

1. Filosofi "Fail-Fast" dan Keandalan Skrip
2. Mode "Unofficial Strict Mode": `set -euo pipefail`
3. Menangkap Sinyal dengan `trap` untuk Pembersihan (Cleanup)
4. Menulis Pesan Error ke `stderr`
5. Strategi Penanganan Error yang Dapat Diprediksi
6. Potensi Penambahan Materi: `errexit` pada fungsi, *Conditional Execution* dengan `||` untuk *Error Handling*

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

#### **2.2. Integritas dan Idempoten (Idealisme):**

Dalam konteks penanganan kesalahan, idealnya skrip harus berusaha untuk bersifat **idempoten**; yaitu, menjalankan skrip berkali-kali akan menghasilkan hasil yang sama seolah-olah hanya dijalankan sekali. Meskipun sulit dicapai sepenuhnya di Bash, penanganan kesalahan yang kuat membantu mendekati ideal ini dengan memastikan pembersihan sumber daya dan status yang konsisten.

#### **2.3. Sinyal Sistem dan Interupsi:**

Sistem operasi Unix berkomunikasi dengan proses melalui **sinyal**. Sinyal seperti `INT` (Interrupt, biasanya dari `Ctrl+C`), `TERM` (Terminate, sinyal untuk mengakhiri proses), atau `EXIT` (sinyal yang dikirim saat proses berakhir, baik sukses maupun gagal) adalah mekanisme yang dapat Anda "tangkap" menggunakan perintah `trap` untuk melakukan tindakan pembersihan sebelum skrip benar-benar berhenti. Ini adalah bagian penting dari "fail-fast" dan pembersihan yang bertanggung jawab.

#### **2.4. *Exit Status* sebagai Bahasa Kesuksesan/Kegagalan:**

Seperti yang telah dibahas di Modul 2.1, *exit status* (nilai `$?`) adalah cara standar setiap perintah Unix mengkomunikasikan hasil eksekusinya. Penanganan kesalahan sangat bergantung pada pemeriksaan *exit status* ini, baik secara implisit melalui `set -e` maupun secara eksplisit melalui pernyataan `if`.

### **3. Sintaks Dasar / Contoh Implementasi Inti:**

#### **3.1. Mode "Unofficial Strict Mode": `set -euo pipefail`:**

Ini adalah set opsi yang sangat direkomendasikan untuk hampir semua skrip Bash non-trivial. Mereka memaksa skrip untuk bertindak lebih seperti program tradisional yang gagal dengan jelas saat menghadapi kondisi tak terduga.

* **`set -e` atau `set -o errexit`:**

  * **Perilaku:** Segera keluar dari skrip jika ada perintah yang gagal (yaitu, mengembalikan *exit status* non-nol).
  * **Pentingnya:** Mencegah skrip melanjutkan dengan hasil perintah yang gagal, yang dapat menyebabkan kesalahan berantai.
  * **Pengecualian:** `set -e` tidak akan keluar jika perintah yang gagal berada di dalam kondisi `if`, `while`, `until`, `&&`, `||`, atau *subshell* dalam *command substitution* yang *output*-nya tidak ditangkap. Ini dirancang untuk memungkinkan Anda memeriksa kegagalan secara eksplisit.

    <!-- end list -->

    ```bash
    #!/bin/bash

    echo "=== Contoh set -e ==="
    set -e

    echo "Perintah 1: Membuat direktori"
    mkdir test_dir_e

    echo "Perintah 2: Mencoba membuat direktori yang sudah ada (akan gagal)"
    mkdir test_dir_e # Ini akan menyebabkan skrip berhenti karena set -e

    echo "Baris ini tidak akan pernah dijalankan."
    ```

  * **Untuk menjalankan contoh ini:** Buat dan jalankan skripnya. Anda akan melihat `mkdir` kedua menyebabkan skrip berhenti tiba-tiba. Setelah dijalankan, hapus `test_dir_e` (`rmdir test_dir_e`) untuk percobaan selanjutnya.

* **`set -u` atau `set -o nounset`:**

  * **Perilaku:** Segera keluar dari skrip jika mencoba menggunakan variabel yang belum didefinisikan (kecuali jika variabel tersebut diuji keberadaannya secara khusus, misalnya dengan `${VAR:-default_val}`).
  * **Pentingnya:** Mencegah *bug* umum akibat *typo* pada nama variabel atau asumsi yang salah tentang ketersediaan variabel.

    <!-- end list -->

    ```bash
    #!/bin/bash

    echo "=== Contoh set -u ==="
    set -u

    # echo "Menggunakan variabel yang belum didefinisikan: $UNDEFINED_VAR" # Ini akan menyebabkan skrip berhenti

    # Cara aman menggunakan variabel yang mungkin belum didefinisikan:
    echo "Menggunakan variabel yang didefinisikan: $DEFINED_VAR" # Ini akan berhasil jika DEFIND_VAR sudah ada
    echo "Menggunakan variabel yang mungkin tidak ada, dengan default: ${MAYBE_VAR:-'nilai default'}"
    ```

  * **Untuk menjalankan contoh ini:** Hapus tanda komentar pada baris yang menggunakan `$UNDEFINED_VAR`.

* **`set -o pipefail`:**

  * **Perilaku:** Mengatur *exit status* dari sebuah *pipeline* (serangkaian perintah yang dihubungkan dengan `|`) menjadi *exit status* dari perintah yang gagal pertama (dari kiri ke kanan), bukan hanya *exit status* dari perintah terakhir.
  * **Pentingnya:** Tanpa ini, jika perintah di tengah *pipeline* gagal, tetapi perintah terakhir berhasil, seluruh *pipeline* akan dianggap berhasil oleh Bash. Ini adalah sumber *bug* yang sangat sulit dideteksi.

    <!-- end list -->

    ```bash
    #!/bin/bash

    echo "=== Contoh set -o pipefail ==="
    # set -e harus disertakan juga untuk menghentikan skrip jika pipefail terjadi
    set -euo pipefail

    echo "Mencoba memproses data dari perintah yang gagal di pipe..."
    # Contoh pipe: Perintah 'false' akan gagal (exit 1), tapi 'wc -l' akan berhasil (exit 0)
    # Tanpa pipefail, skrip akan mengira pipe ini berhasil.
    # Dengan pipefail, skrip akan melihat kegagalan 'false' dan berhenti.
    false | wc -l

    echo "Baris ini tidak akan pernah dijalankan karena 'pipefail'."
    ```

  * **Untuk menjalankan contoh ini:** Anda akan melihat skrip berhenti karena `false` mengembalikan *exit status* 1, dan `pipefail` menangkapnya.

**Rekomendasi Mutlak:** Mulai setiap skrip Bash Anda dengan baris berikut (atau varian lengkapnya):

```bash
#!/bin/bash
set -euo pipefail # Unofficial Bash Strict Mode
```

### **3.2. Menangkap Sinyal dengan `trap` untuk Pembersihan (Cleanup):**

Perintah `trap` memungkinkan Anda untuk menangkap sinyal yang dikirim ke skrip dan menjalankan perintah atau fungsi sebagai respons. Ini sangat berguna untuk membersihkan file sementara, mematikan proses latar belakang, atau mereset konfigurasi sebelum skrip keluar (baik secara normal maupun karena kesalahan).

**Sintaks Umum:**

```bash
trap 'PERINTAH_ATAU_FUNGSI' SINYAL1 SINYAL2 ...
```

**Contoh Template Skrip Robust:**

```bash
#!/bin/bash

# --- The Robust Script Template ---
# 1. Unofficial Bash Strict Mode: Segera keluar jika ada kesalahan.
set -euo pipefail

# 2. Fungsi pembersihan: akan dijalankan saat skrip berakhir.
cleanup() {
  echo "--- Menjalankan pembersihan ---"
  if [[ -f "/tmp/myapp_temp_file.$$" ]]; then # $$ adalah PID skrip saat ini
    echo "Menghapus file sementara: /tmp/myapp_temp_file.$$"
    rm -f "/tmp/myapp_temp_file.$$"
  fi
  echo "Pembersihan selesai."
}

# 3. Menangkap sinyal: panggil fungsi cleanup pada EXIT, INT (Ctrl+C), TERM.
trap cleanup EXIT INT TERM

echo "--- Skrip dimulai ---"

echo "Membuat file sementara: /tmp/myapp_temp_file.$$"
touch "/tmp/myapp_temp_file.$$"

# Simulasikan pekerjaan skrip
echo "Melakukan beberapa pekerjaan..."
sleep 2

# Simulasikan kondisi kesalahan (akan memicu set -e dan trap EXIT)
echo "Simulasi kegagalan: mencoba listing direktori yang tidak ada..."
ls /direktori/palsu_yang_tidak_ada # Ini akan menyebabkan set -e menghentikan skrip

echo "Baris ini tidak akan pernah tercapai jika ada kesalahan." # Karena set -e

echo "--- Skrip selesai dengan sukses (jika tanpa error) ---"
```

* **Penjelasan `trap cleanup EXIT INT TERM`:**
  * `cleanup`: Nama fungsi yang akan dipanggil.
  * `EXIT`: Sinyal yang selalu dikirim saat skrip keluar, tidak peduli apakah berhasil atau gagal. Ini memastikan `cleanup` selalu dijalankan.
  * `INT`: Sinyal *interrupt* yang dikirim saat pengguna menekan `Ctrl+C`.
  * `TERM`: Sinyal *terminate* yang dikirim, biasanya oleh `kill` command.
* **Pentingnya `$$`:** `$$` adalah variabel khusus di Bash yang berisi Process ID (PID) dari skrip yang sedang berjalan. Menggunakannya dalam nama file sementara (`/tmp/myapp_temp_file.$$`) memastikan bahwa file sementara Anda unik untuk setiap *instance* skrip, mencegah konflik dan menjaga kebersihan.

### **3.3. Menulis Pesan Error ke `stderr`:**

Ketika skrip Anda mendeteksi kesalahan atau perlu memberikan informasi diagnostik yang penting, selalu cetak pesan tersebut ke **Standard Error (stderr)**, bukan Standard Output (stdout).

* **Mengapa?**
  * **Pemindahan *output* yang Bersih:** *Output* standar (`stdout`) biasanya dimaksudkan untuk data yang dihasilkan skrip (misalnya, hasil dari suatu perhitungan, daftar file). Jika Anda mengalihkan `stdout` skrip ke file, Anda tidak ingin pesan error juga masuk ke file data tersebut.
  * **Pesan Error Terpisah:** `stderr` dirancang khusus untuk pesan error, peringatan, atau diagnostik. Ini memungkinkan pengguna untuk menangkap dan memproses pesan error secara terpisah dari data normal.
  * **Standar Unix:** Ini adalah konvensi dasar dalam sistem Unix/Linux.

**Sintaks:**

```bash
echo "Pesan error atau peringatan" >&2
```

**Contoh:**

```bash
#!/bin/bash
set -euo pipefail

validate_input() {
  local USER_INPUT="$1"
  if [[ -z "$USER_INPUT" ]]; then
    echo "Error: Input tidak boleh kosong." >&2 # Pesan error ke stderr
    return 1
  fi
  if [[ "$USER_INPUT" == "admin" ]]; then
    echo "Peringatan: Pengguna 'admin' memiliki hak istimewa." >&2 # Peringatan ke stderr
  fi
  echo "Input diterima: $USER_INPUT" # Output data ke stdout
  return 0
}

# Contoh penggunaan
validate_input "JohnDoe" # Output ke stdout
validate_input ""        # Error ke stderr, skrip keluar karena set -e
```

### **3.4. Strategi Penanganan Error yang Dapat Diprediksi:**

Selain `set -euo pipefail` dan `trap`, ada beberapa strategi lain untuk membuat penanganan kesalahan lebih spesifik dan prediktif:

* **Pengecekan Explicit `if` `$?`:** Meskipun `set -e` menangani banyak kasus, terkadang Anda ingin menangani kegagalan secara spesifik tanpa menghentikan skrip.

    ```bash
    #!/bin/bash
    set -euo pipefail # Tetap gunakan strict mode secara default

    download_file() {
      local URL="$1"
      local OUTPUT_FILE="$2"

      echo "Mencoba mengunduh '$URL' ke '$OUTPUT_FILE'..."
      wget -q -O "$OUTPUT_FILE" "$URL" # -q: quiet, -O: output file
      if [[ $? -ne 0 ]]; then # Periksa exit status secara eksplisit
        echo "Error: Gagal mengunduh file dari $URL." >&2
        return 1
      fi
      echo "File berhasil diunduh."
      return 0
    }

    # Contoh penggunaan
    if download_file "http://invalid.url/nonexistent.txt" "downloaded_file.txt"; then
      echo "Lanjutkan pemrosesan file..."
      # Lanjutkan logika skrip
    else
      echo "Operasi pengunduhan gagal, tidak melanjutkan."
      exit 1 # Keluar dari skrip jika pengunduhan adalah langkah kritis
    fi
    ```

* **Eksekusi Kondisional dengan `||` (OR) untuk Error Handling:** Ini adalah cara singkat untuk menjalankan perintah lain jika perintah pertama gagal.

    ```bash
    #!/bin/bash
    # set -euo pipefail # Bisa dihidupkan atau tidak, tergantung apakah Anda ingin keluar total atau hanya menjalankan default

    echo "--- Contoh OR (||) untuk Error Handling ---"
    # Coba buat direktori; jika gagal, cetak pesan error dan keluar
    mkdir my_new_directory || { echo "Error: Gagal membuat direktori 'my_new_directory'." >&2; exit 1; }

    echo "Direktori berhasil dibuat atau sudah ada."

    # Coba unduh file; jika gagal, jalankan fungsi fallback
    download_data_from_primary_source || download_data_from_backup_source || { echo "Semua sumber gagal!" >&2; exit 1; }

    function download_data_from_primary_source() {
        echo "Mencoba sumber utama..."
        # Simulasikan kegagalan
        return 1
    }

    function download_data_from_backup_source() {
        echo "Mencoba sumber cadangan..."
        # Simulasikan keberhasilan
        return 0
    }
    ```

  * **Catatan:** Blok `{ ... }` memerlukan spasi di sekitar kurung kurawal dan titik koma (`;`) sebelum kurung kurawal penutup.

### **4. Terminologi Kunci:**

* **Penanganan Kesalahan (Error Handling):** Proses mengidentifikasi, merespons, dan mengelola kondisi kesalahan atau pengecualian yang terjadi selama eksekusi skrip.
* **Filosofi "Fail-Fast":** Prinsip desain di mana program (atau skrip) akan segera menghentikan eksekusinya saat mendeteksi kondisi kesalahan, daripada mencoba melanjutkan dengan asumsi yang salah.
* **`set` options:** Perintah bawaan Bash yang digunakan untuk mengubah perilaku *shell*.
  * **`set -e` (atau `set -o errexit`):** Menyebabkan skrip keluar segera jika ada perintah yang gagal (mengembalikan *exit status* non-nol).
  * **`set -u` (atau `set -o nounset`):** Menyebabkan skrip keluar segera jika mencoba menggunakan variabel yang belum didefinisikan.
  * **`set -o pipefail`:** Menyebabkan *exit status* dari sebuah *pipeline* menjadi *exit status* dari perintah yang gagal pertama dalam *pipeline* tersebut.
* **`trap`:** Perintah bawaan Bash untuk "menangkap" sinyal sistem atau kondisi khusus (`EXIT`) dan menjalankan perintah atau fungsi yang ditentukan sebagai respons.
* **Sinyal (Signal):** Komunikasi asinkron yang dikirim ke suatu proses untuk memberi tahu tentang suatu peristiwa (misalnya, `INT` dari `Ctrl+C`, `TERM` untuk mengakhiri, `KILL` untuk menghentikan paksa).
* **Standard Error (`stderr`):** Salah satu dari tiga *standard stream* I/O di Unix/Linux, digunakan khusus untuk *output* pesan error dan diagnostik. Dilambangkan dengan *file descriptor* `2`.
* **`$$`:** Variabel khusus Bash yang berisi Process ID (PID) dari *shell* saat ini (skrip yang sedang berjalan). Berguna untuk membuat file sementara unik.

### **5. Rekomendasi Visualisasi (Jika Diperlukan):**

* **Diagram Alur dengan `set -e`:** *Flowchart* yang menunjukkan panah keluar dari alur utama setiap kali ada perintah yang gagal, langsung ke *exit* skrip.
* **Diagram Alur *Pipeline* dengan `pipefail`:** Ilustrasi *pipeline* dengan beberapa perintah. Tunjukkan panah *exit status* yang mengalir ke belakang dari setiap perintah ke awal *pipeline*, dan bagaimana `pipefail` "menangkap" kegagalan pertama.
* **Diagram Sinyal dan `trap`:** Gambar skrip di tengah eksekusi, dengan panah sinyal (`Ctrl+C`, `kill`) masuk ke skrip yang kemudian mengaktifkan fungsi `trap` untuk pembersihan sebelum skrip berhenti.

### **6. Hubungan dengan Modul Lain:**

Modul ini secara fundamental terhubung dengan **Modul 2.1 (Struktur Kondisional)**, karena penanganan kesalahan bergantung pada pemeriksaan *exit status* (`$?`) dan membuat keputusan berdasarkan keberhasilan atau kegagalan. Ini juga terkait erat dengan **Modul 2.3 (Fungsi)**, karena fungsi harus dirancang untuk mengembalikan *exit status* yang bermakna, dan fungsi `cleanup` yang digunakan dengan `trap` adalah contoh penerapan fungsi. Konsep *exit status* yang diperkenalkan sejak Fase 1 menjadi sangat penting di sini. Penanganan kesalahan yang kokoh adalah prasyarat untuk menulis skrip yang akan mem-parsing argumen (Modul 3.2), berinteraksi dengan Regex (Modul 3.3), dan mengelola data yang sensitif di Fase 4.

### **7. Sumber Referensi Lengkap:**

* **Unofficial Bash Strict Mode:** [http://redsymbol.net/articles/unofficial-bash-strict-mode/](http://redsymbol.net/articles/unofficial-bash-strict-mode/)
  * **Detail:** Artikel klasik dan sangat direkomendasikan yang menjelaskan secara mendalam mengapa `set -euo pipefail` harus digunakan dalam skrip Bash.
* **Bash Trap Command (Linuxize):** [https://linuxize.com/post/bash-trap-command/](https://linuxize.com/post/bash-trap-command/)
  * **Detail:** Tutorial yang jelas dan ringkas tentang penggunaan perintah `trap` untuk menangkap sinyal dan menjalankan tindakan pembersihan.
* **Bash Manual: The Set Builtin:** [https://www.gnu.org/software/bash/manual/html\_node/The-Set-Builtin.html](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)
  * **Detail Tambahan (opsional):** Dokumentasi resmi Bash untuk perintah `set`, menjelaskan semua opsi yang tersedia.
* **Bash Manual: Signals:** [https://www.gnu.org/software/bash/manual/html\_node/Signals.html](https://www.gnu.org/software/bash/manual/html_node/Signals.html)
  * **Detail Tambahan (opsional):** Bagian dari manual Bash yang menjelaskan bagaimana Bash menangani sinyal.
* **Error Handling in Bash (Stack Abuse):** [https://stackabuse.com/error-handling-in-bash/](https://stackabuse.com/error-handling-in-bash/)
  * **Detail:** Sebuah artikel komprehensif yang membahas berbagai teknik penanganan kesalahan di Bash.

### **8. Tips dan Praktik Terbaik:**

* **Mulai dengan "Strict Mode":** Selalu masukkan `set -euo pipefail` di awal setiap skrip Bash Anda (setelah shebang `#!/bin/bash`). Ini adalah kebiasaan yang akan menghemat banyak waktu *debugging*.
* **Gunakan `trap cleanup EXIT`:** Ini adalah cara terbaik untuk memastikan sumber daya (file sementara, proses latar belakang) selalu dibersihkan, bahkan jika skrip mengalami kegagalan tak terduga.
* **Pesan Error ke `stderr`:** Konsistenlah dalam mengarahkan semua pesan error, peringatan, atau diagnostik ke `stderr` (`>&2`). Ini memisahkan *output* program dari pesan informasi.
* **Berikan Pesan Error yang Jelas:** Ketika skrip Anda gagal, pastikan pesan errornya informatif: sebutkan apa yang gagal, mengapa gagal (jika mungkin), dan bagaimana pengguna dapat memperbaikinya.
* **Gunakan `exit N`:** Setelah mencetak pesan error, gunakan `exit 1` (atau nilai non-nol lainnya) untuk secara eksplisit menghentikan skrip dengan *exit status* kegagalan. Ini memberitahu lingkungan pemanggil bahwa skrip tidak berhasil diselesaikan.
* **Logging:** Untuk skrip produksi, pertimbangkan untuk menerapkan sistem *logging* yang lebih canggih (misalnya, menulis log ke file) daripada hanya mencetak ke `stderr`.

### **9. Potensi Kesalahan Umum & Solusi:**

* **Kesalahan:** Mengandalkan `$?` setelah `set -e`.
  * **Penyebab:** Jika `set -e` aktif, skrip akan keluar segera setelah perintah gagal, jadi Anda mungkin tidak memiliki kesempatan untuk memeriksa `$?` secara eksplisit setelah kegagalan terjadi, kecuali Anda menempatkannya dalam kondisi `if` atau `||`.
  * **Solusi:** `set -e` dimaksudkan untuk *fail-fast*. Jika Anda perlu menangani kegagalan secara spesifik, letakkan perintah dalam `if` (`if ! perintah; then ...`) atau gunakan `||` (`perintah || { echo "Error"; exit 1; }`).
* **Kesalahan:** Tidak mengutip argumen pada `trap`.
  * **Penyebab:** `trap cleanup EXIT` akan memanggil fungsi `cleanup`. Namun, `trap "echo Cleanup..." EXIT` akan mengevaluasi "echo Cleanup..." saat `trap` didefinisikan, bukan saat sinyal diterima. Untuk menjalankan perintah saat sinyal diterima, perintah harus di dalam kutipan tunggal atau menjadi nama fungsi.
  * **Solusi:** `trap 'echo "Melakukan pembersihan..."' EXIT` (gunakan kutipan tunggal untuk perintah literal) atau `trap nama_fungsi EXIT`.
* **Kesalahan:** File sementara tidak dihapus saat skrip dihentikan paksa (misal, `kill -9`).
  * **Penyebab:** Sinyal `KILL` (sinyal 9) adalah sinyal yang tidak dapat ditangkap oleh `trap`. Ini mengakhiri proses secara paksa.
  * **Solusi:** Tidak ada cara untuk menangkap `KILL`. Desain skrip Anda agar idempoten dan dapat mengatasi sisa-sisa eksekusi sebelumnya, atau gunakan sistem file temporer yang dikelola secara otomatis oleh OS (`mktemp`).
* **Kesalahan:** Pesan error bercampur dengan *output* data.
  * **Penyebab:** Menggunakan `echo` tanpa `>&2` untuk pesan error.
  * **Solusi:** Selalu tambahkan `>&2` untuk pesan diagnostik atau error.
* **Kesalahan:** Variabel `pipefail` tidak berlaku karena `set -e` tidak aktif.
  * **Penyebab:** `pipefail` hanya memodifikasi *exit status* dari *pipeline*. Agar skrip benar-benar berhenti karena kegagalan di tengah *pipeline*, `set -e` juga harus aktif.
  * **Solusi:** Selalu gunakan `set -euo pipefail` bersamaan.

-----

Dengan penjelasan mendalam ini untuk Modul 3.1, Anda sekarang memiliki pemahaman yang kuat tentang penanganan kesalahan di Bash dan bagaimana membuat skrip Anda jauh lebih andal dan profesional.

Modul berikut ini akan mengajarkan Anda bagaimana membuat skrip Anda lebih fleksibel dan mudah digunakan dengan menerima input sebagai opsi dan argumen baris perintah.

-----

**Tujuan Fase:** Mengubah skrip sederhana menjadi alat yang kuat, aman, dan siap produksi dengan penanganan kesalahan yang baik, antarmuka pengguna yang layak, dan praktik terbaik.

-----

## **Modul 3.2: Mem-parsing Argumen Baris Perintah**

### **Struktur Pembelajaran Internal (Struktur Daftar Isi):**

1. Filosofi Antarmuka Baris Perintah (CLI) yang Baik
2. Argumen Posisi Sederhana (`$1`, `$@`, `$*`)
3. Menggunakan `getopts` untuk Parsing Opsi Singkat (`-a`, `-b`)
4. Menangani Opsi dengan dan tanpa Argumen (pada `getopts`)
5. Menulis Fungsi `usage()` atau `help()`
6. Melewatkan Argumen Sisa (Non-Opsi)
7. Potensi Penambahan Materi: Perbedaan antara `getopts` (bawaan) dan `getopt` (eksternal GNU)

### **1. Deskripsi Konkret & Peran dalam Kurikulum:**

Dalam modul ini, Anda akan belajar bagaimana merancang skrip Anda agar dapat menerima instruksi dan konfigurasi dari pengguna melalui baris perintah, mirip dengan bagaimana perintah standar Linux seperti `ls -l` atau `cp -r sumber tujuan` bekerja. Anda akan belajar membedakan antara **opsi (options)** yang diawali tanda hubung (misalnya `-v` untuk *verbose*) dan **argumen (arguments)** yang merupakan nilai atau file yang diproses skrip. Anda akan fokus pada penggunaan `getopts`, sebuah perintah bawaan Bash yang efisien untuk mem-parsing opsi singkat.

Peran modul ini adalah untuk meningkatkan **usability** dan **professionalisme** skrip Anda. Skrip yang hanya bekerja dengan nilai *hardcoded* atau input interaktif terbatas kurang fleksibel. Dengan mem-parsing argumen baris perintah, Anda membuat skrip Anda dapat digunakan secara non-interaktif, dapat diintegrasikan dengan skrip lain (misalnya dalam *pipeline* atau *cron job*), dan lebih mudah diotomatisasi. Ini adalah bagian integral dari membangun "alat" baris perintah yang sebenarnya, mirip dengan aplikasi Flutter yang menerima argumen saat diluncurkan atau konfigurasi awal.

### **2. Konsep Kunci & Filosofi Mendalam:**

#### **2.1. Desain Antarmuka Baris Perintah (CLI):**

CLI yang baik adalah seperti *User Interface* (UI) lainnya—ia harus intuitif, konsisten, dan dapat diprediksi. Ini berarti:

* **Konsistensi:** Mengikuti konvensi umum Unix (misalnya, `-v` untuk *verbose*, `-h` untuk *help*, `-f` untuk *file*).
* **Jelas:** Opsi dan argumen harus memiliki makna yang jelas.
* **Prediktif:** Pengguna harus dapat menebak bagaimana menggunakan skrip Anda berdasarkan nama opsi.
* **Fleksibilitas:** Memungkinkan pengguna untuk mengontrol perilaku skrip tanpa harus mengedit kode.

#### **2.2. Pemisahan Konfigurasi dari Logika:**

Melewatkan konfigurasi melalui argumen baris perintah memisahkan data konfigurasi dari logika inti skrip Anda. Ini membuat skrip lebih modular, lebih mudah untuk di-*debug*, dan lebih fleksibel karena perilaku dapat diubah tanpa memodifikasi kode.

#### **2.3. Opsi vs. Argumen Posisi:**

Penting untuk memahami perbedaan:

* **Opsi (Options/Flags):** Mengubah *perilaku* skrip. Mereka diawali dengan satu atau dua tanda hubung (misalnya `-v`, `--verbose`).
* **Argumen Posisi (Positional Arguments):** Adalah *data* yang akan dioperasikan oleh skrip (misalnya, `file.txt` dalam `cat file.txt`).

#### **2.4. Pentingnya Fungsi `usage()`:**

Setiap alat baris perintah yang baik harus menyediakan cara bagi pengguna untuk mengetahui cara menggunakannya. Fungsi `usage()` atau `help()` yang mencetak deskripsi singkat tentang cara memanggil skrip Anda, opsi yang tersedia, dan contoh penggunaan adalah praktik standar yang sangat penting.

### **3. Sintaks Dasar / Contoh Implementasi Inti:**

#### **3.1. Argumen Posisi Sederhana (`$1`, `$@`, `$*`):**

Ini adalah cara paling dasar untuk mengakses argumen baris perintah. Anda sudah familiar dengan ini dari **Modul 1.3 (Variabel dan Ekspansi)** dan **Modul 2.3 (Fungsi)**, di mana mereka digunakan untuk argumen fungsi.

* `$0`: Nama skrip yang sedang dieksekusi.
* `$1`, `$2`, `$3`, ...: Argumen posisi pertama, kedua, ketiga, dan seterusnya.
* `$#`: Jumlah total argumen posisi.
* `$@`: Mengembangkan ke setiap argumen sebagai string terpisah yang dikutip secara individual. **Direkomendasikan.**
* `$*`: Mengembangkan ke semua argumen sebagai satu string tunggal. **Hindari, karena masalah spasi.**

**Contoh:**

```bash
#!/bin/bash
set -euo pipefail

echo "Nama skrip ini adalah: $0"
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

# Contoh: Simulasikan memproses beberapa file
shift 2 # Menghapus dua argumen pertama (nama depan dan belakang)
echo "Argumen tersisa (setelah shift):"
for FILE in "$@"; do
  echo "Memproses file: $FILE"
done
```

* **`shift N`:** Perintah ini "menggeser" argumen posisi ke kiri. `shift 1` akan menghapus `$1` dan membuat `$2` menjadi `$1`, `$3` menjadi `$2`, dan seterusnya. `shift 2` akan menghapus dua argumen pertama. Ini berguna setelah memproses argumen posisi awal atau opsi.

#### **3.2. Menggunakan `getopts` untuk Parsing Opsi:**

`getopts` adalah perintah bawaan Bash yang dirancang khusus untuk mem-parsing opsi singkat (satu karakter, diawali satu tanda hubung, misal `-a`, `-b`, `-c`). Ini adalah cara **yang direkomendasikan** untuk menangani opsi di skrip Bash karena ini *POSIX-compliant* dan kuat.

**Sintaks Umum `getopts`:**

```bash
while getopts "DAFTAR_OPSI" VAR_OPSI; do
  case "${VAR_OPSI}" in
    opsi1)
      # Kode untuk opsi1
      ;;
    opsi2)
      # Kode untuk opsi2
      ;;
    :) # Menangani opsi yang membutuhkan argumen tetapi tidak diberi
      echo "Error: Opsi -${OPTARG} memerlukan argumen." >&2
      usage # Panggil fungsi usage
      ;;
    ?) # Menangani opsi yang tidak valid
      echo "Error: Opsi tidak valid: -${OPTARG}." >&2
      usage # Panggil fungsi usage
      ;;
  esac
done
```

**Penjelasan `DAFTAR_OPSI`:**

* Setiap huruf dalam `DAFTAR_OPSI` mewakili sebuah opsi yang valid (misalnya, `ab:c` berarti `-a`, `-b`, `-c`).
* Jika sebuah huruf diikuti oleh titik dua (`:`), itu berarti opsi tersebut **membutuhkan argumen**. Contoh: `b:` berarti `-b nilai`.
* Jika daftar opsi dimulai dengan titik dua (`:`), seperti `:ab:c`, ini mengubah perilaku `getopts` ke "silent error reporting". Ini memungkinkan kita untuk menangani error secara manual menggunakan `case` untuk `:)` dan `?)`. Ini adalah **praktik terbaik**.

**Variabel Khusus `getopts`:**

* `OPTIND`: Indeks dari argumen baris perintah berikutnya yang akan diproses. Berguna setelah `getopts` selesai untuk menemukan argumen posisi yang tersisa.
* `OPTARG`: Berisi argumen yang diberikan ke opsi (jika opsi membutuhkan argumen).
* `VAR_OPSI`: Variabel yang Anda tentukan sendiri dalam `while getopts`, yang akan berisi opsi yang ditemukan (`a`, `b`, `c`, dll.) dalam setiap iterasi.

**Contoh Utama:**

```bash
#!/bin/bash
set -euo pipefail

# Fungsi usage untuk menampilkan bantuan
usage() {
  echo "Penggunaan: $0 [-v] [-o FILE_OUTPUT] <file_input>"
  echo "  -v            : Mode verbose (menampilkan lebih banyak detail)."
  echo "  -o FILE_OUTPUT: Tentukan file output (default: output.txt)."
  echo "  <file_input>  : File input yang wajib diproses."
  exit 1
}

# Inisialisasi variabel default
VERBOSE=0
OUTPUT_FILE="output.txt"
INPUT_FILE="" # Ini akan menjadi argumen posisi setelah opsi

# Parsing opsi menggunakan getopts. Titik dua di awal untuk penanganan error kustom.
while getopts ":vo:" opt; do
  case "${opt}" in
    v)
      VERBOSE=1
      ;;
    o)
      OUTPUT_FILE="${OPTARG}"
      ;;
    :)
      echo "Error: Opsi -${OPTARG} memerlukan argumen." >&2
      usage
      ;;
    ?)
      echo "Error: Opsi tidak valid: -${OPTARG}." >&2
      usage
      ;;
  esac
done

# 'shift' argumen posisi sebanyak opsi yang telah diproses oleh getopts.
# Ini akan membuat argumen posisi yang tersisa dimulai dari $1 lagi.
shift $((OPTIND - 1))

# Argumen posisi pertama yang tersisa adalah INPUT_FILE
INPUT_FILE="${1:-}" # Gunakan ${1:-} untuk menghindari error jika tidak ada argumen

# Validasi input_file wajib
if [[ -z "$INPUT_FILE" ]]; then
  echo "Error: File input wajib ditentukan." >&2
  usage
fi

# Tampilkan hasil parsing
if [[ "$VERBOSE" -eq 1 ]]; then
  echo "Mode Verbose: Aktif"
fi
echo "File Input: $INPUT_FILE"
echo "File Output: $OUTPUT_FILE"

# Simulasikan pekerjaan
echo "Memproses data dari '$INPUT_FILE' dan menulis ke '$OUTPUT_FILE'..."
echo "Ini adalah contoh output." > "$OUTPUT_FILE"
echo "Selesai."
```

* **Cara Menjalankan Contoh:**
  * `./script.sh` (akan error karena `-z "$INPUT_FILE"`)
  * `./script.sh my_data.txt`
  * `./script.sh -v my_data.txt`
  * `./script.sh -o result.log my_data.txt`
  * `./script.sh -v -o result.log my_data.txt`
  * `./script.sh my_data.txt -v -o result.log` (urutan opsi tidak masalah dengan `getopts`)
  * `./script.sh -o my_data.txt` (akan error karena -o membutuhkan argumen)
  * `./script.sh -x my_data.txt` (akan error karena -x bukan opsi valid)

#### **3.3. Menulis Fungsi `usage()` atau `help()`:**

Fungsi ini adalah standar untuk memberikan informasi bantuan kepada pengguna. Ia harus mencetak *string* penggunaan (bagaimana skrip dipanggil dan opsi apa yang tersedia) ke `stderr` dan kemudian keluar dengan status error (misal `exit 1`).

* Lihat contoh di atas untuk implementasi lengkap dari fungsi `usage()`.
* Penting: Gunakan `>&2` untuk mengarahkan *output* `usage` ke *stderr*.

### **5. Terminologi Kunci:**

* **Argumen Baris Perintah (Command-Line Arguments):** Informasi yang dilewatkan ke skrip saat dieksekusi dari terminal.
* **Opsi (Option/Flag):** Argumen yang diawali dengan tanda hubung (`-` atau `--`) yang mengubah perilaku skrip.
* **Argumen (Argument):** Nilai yang diberikan ke sebuah opsi (misal, nama file setelah `-f`) atau argumen posisi.
* **Argumen Posisi (Positional Argument):** Argumen yang posisinya menentukan maknanya (misal, `$1`, `$2`).
* **`getopts`:** Perintah bawaan Bash untuk mem-parsing opsi baris perintah (`-a`, `-b val`). Cocok untuk opsi karakter tunggal.
* **`OPTIND`:** Variabel khusus yang dikelola oleh `getopts`. Berisi indeks dari argumen berikutnya yang akan diproses di `ARGV` (array argumen internal Bash).
* **`OPTARG`:** Variabel khusus yang dikelola oleh `getopts`. Berisi argumen yang diberikan ke opsi yang membutuhkan nilai (misalnya, `filename` jika opsi adalah `-f filename`).
* **`usage()` / `help()` function:** Fungsi umum dalam skrip yang mencetak pesan tentang cara menggunakan skrip (opsi, argumen) dan kemudian keluar.
* **`shift`:** Perintah bawaan Bash yang menggeser argumen posisi ke kiri (misalnya, `$2` menjadi `$1`). Berguna untuk menghapus opsi yang sudah diproses agar argumen posisi non-opsi dapat diakses sebagai `$1`, `$2`, dst.
* **POSIX-compliant:** Mengikuti standar Portable Operating System Interface. Perintah atau fitur yang *POSIX-compliant* akan bekerja di berbagai *shell* yang berbeda (Bash, Zsh, Dash) dan sistem Unix.

### **6. Hubungan dengan Modul Lain:**

Modul ini secara langsung membangun di atas **Modul 1.3 (Variabel dan Ekspansi)** untuk mengakses argumen posisi dan **Modul 2.3 (Fungsi)** untuk mengimplementasikan fungsi `usage()`. Penerapan **Modul 3.1 (Penanganan Kesalahan)** sangat penting di sini, karena Anda perlu memvalidasi argumen yang diterima dan keluar dengan status error jika argumen tidak valid atau ada yang hilang. Mem-parsing argumen adalah fondasi untuk skrip yang lebih kompleks di Fase 3 dan 4 yang memerlukan input dari pengguna, seperti skrip *backup* yang menerima direktori sumber dan tujuan, atau skrip *deploy* yang menerima nama lingkungan.

### **7. Sumber Referensi Lengkap:**

* **Parsing command-line arguments in Bash (Stack Abuse):** [https://stackabuse.com/how-to-parse-command-line-arguments-in-bash/](https://stackabuse.com/how-to-parse-command-line-arguments-in-bash/)
  * **Detail:** Menyediakan ikhtisar yang baik tentang argumen posisi dan penggunaan `getopts` dengan contoh yang jelas.
* **Greg's Wiki - BashFAQ/035 (getopts):** [https://mywiki.wooledge.org/BashFAQ/035](https://mywiki.wooledge.org/BashFAQ/035)
  * **Detail:** Sumber daya yang sangat direkomendasikan yang membahas penggunaan `getopts` secara mendalam, termasuk praktik terbaik dan penanganan kasus-kasus khusus.
* **Bash Manual: getopts:** [https://www.gnu.org/software/bash/manual/bash.html\#getopts](https://www.gnu.org/software/bash/manual/bash.html%23getopts)
  * **Detail Tambahan (opsional):** Dokumentasi resmi Bash untuk perintah `getopts`.
* **Bash Manual: Shell Parameters:** [https://www.gnu.org/software/bash/manual/bash.html\#Shell-Parameters](https://www.gnu.org/software/bash/manual/bash.html%23Shell-Parameters)
  * **Detail Tambahan (opsional):** Bagian dari manual Bash yang menjelaskan variabel parameter *shell* (termasuk `$1`, `$@`, `$#`, dll.).

### **8. Tips dan Praktik Terbaik:**

* **Prioritaskan `getopts`:** Untuk opsi karakter tunggal, `getopts` adalah pilihan terbaik karena merupakan bawaan Bash (tidak memerlukan program eksternal) dan *POSIX-compliant*.
* **Gunakan `shift` Setelah `getopts`:** Setelah perulangan `while getopts` selesai, gunakan `shift $((OPTIND - 1))` untuk menghapus semua opsi dan argumennya dari daftar argumen posisi (`$@`). Ini akan membuat argumen posisi yang tersisa (misalnya, nama file input) menjadi `$1`, `$2`, dst., yang lebih mudah diakses.
* **Implementasikan `usage()`:** Selalu sertakan fungsi `usage()` atau `help()` yang jelas. Panggil fungsi ini jika pengguna memberikan opsi tidak valid, melewatkan argumen wajib, atau meminta bantuan (`-h`). Pastikan *output*-nya ke `stderr`.
* **Validasi Argumen:** Jangan berasumsi argumen valid. Selalu validasi input pengguna (misalnya, apakah file ada, apakah angka benar). Ini sangat penting untuk keamanan dan keandalan skrip.
* **Kutip Variabel:** Selalu kutip ganda variabel yang berisi argumen (`"$OPTARG"`, `"$1"`) untuk menghindari masalah dengan spasi atau karakter khusus.

### **9. Potensi Kesalahan Umum & Solusi:**

* **Kesalahan:** Menggunakan `getopts` tanpa `shift $((OPTIND - 1))`.
  * **Penyebab:** Setelah `getopts` selesai memproses opsi, variabel posisi (`$1`, `$2`, dst.) masih akan menunjuk ke opsi dan argumennya. Ini membuat sulit untuk mengakses argumen posisi yang sebenarnya (non-opsi) setelahnya.
  * **Solusi:** Selalu tambahkan `shift $((OPTIND - 1))` setelah blok `while getopts` selesai. Ini akan memindahkan `OPTIND-1` posisi ke kiri, sehingga argumen non-opsi pertama menjadi `$1`.
* **Kesalahan:** Lupa titik dua di awal daftar opsi `getopts` (`while getopts "vo:" ...`).
  * **Penyebab:** Tanpa titik dua di awal, `getopts` akan mencetak pesan errornya sendiri ke `stderr` dan `VAR_OPSI` akan berisi `?` untuk opsi tidak valid atau `.` untuk opsi yang membutuhkan argumen tapi tidak diberi. Ini membuat penanganan error kustom dalam `case` tidak berfungsi seperti yang diharapkan.
  * **Solusi:** Selalu mulai daftar opsi `getopts` dengan titik dua (`:`) seperti `while getopts ":vo:" opt; do`. Ini mengaktifkan mode *silent error reporting* dan memungkinkan Anda mengendalikan pesan error.
* **Kesalahan:** Menggunakan `getopt` (dengan satu `t`) daripada `getopts` (dengan `ts`).
  * **Penyebab:** `getopt` adalah program eksternal (seringkali versi GNU), sedangkan `getopts` adalah bawaan Bash. Mereka memiliki sintaks dan perilaku yang berbeda. `getopt` lebih kompleks tetapi mendukung opsi panjang (`--verbose`).
  * **Solusi:** Untuk modul ini, fokuslah pada `getopts`. Jika Anda benar-benar membutuhkan opsi panjang, Anda perlu mempelajari `getopt` atau parsing manual (yang lebih rumit).
* **Kesalahan:** Tidak menangani argumen wajib.
  * **Penyebab:** Skrip tidak memverifikasi apakah semua argumen atau opsi wajib telah disediakan.
  * **Solusi:** Setelah parsing `getopts` dan `shift`, periksa apakah variabel untuk argumen wajib kosong atau tidak (misal, `if [[ -z "$INPUT_FILE" ]]; then usage; fi`).

-----

Anda kini telah menguasai cara mem-parsing argumen baris perintah, sebuah kemampuan penting untuk membuat skrip Bash Anda lebih interaktif dan profesional.

Modul berikut ini akan membuka pintu untuk kemampuan manipulasi teks yang sangat kuat, esensial dalam lingkungan Unix/Linux.

-----

**Tujuan Fase:** Mengubah skrip sederhana menjadi alat yang kuat, aman, dan siap produksi dengan penanganan kesalahan yang baik, antarmuka pengguna yang layak, dan praktik terbaik.

-----

## **Modul 3.3: Ekspresi Reguler (Regex) dan Manipulasi Teks Tingkat Lanjut**

### **Struktur Pembelajaran Internal (Struktur Daftar Isi):**

1. Filosofi "Teks adalah Antarmuka Universal"
2. Pengenalan Ekspresi Reguler (Regex)
3. Alat Baris Perintah untuk Regex: `grep`, `sed`, `awk`
4. Pola Dasar Regex: Karakter Literal, Metacharacter, Kuantifier
5. Kelompok (Groups) dan Referensi Balik (Backreferences)
6. Manipulasi Teks Tingkat Lanjut dengan `sed` dan `awk`
7. Potensi Penambahan Materi: PCRE (Perl Compatible Regular Expressions), *Lookarounds*

### **1. Deskripsi Konkret & Peran dalam Kurikulum:**

Modul ini adalah tentang menguasai seni dan ilmu **Ekspresi Reguler (Regex)**, sebuah bahasa mini untuk pencocokan dan manipulasi pola teks yang sangat kuat. Anda akan belajar bagaimana menggunakan Regex dengan alat-alat baris perintah klasik Unix seperti `grep` (untuk mencari), `sed` (untuk mengedit), dan `awk` (untuk pemrosesan teks berbasis kolom). Ini adalah keterampilan kunci yang diperlukan untuk analisis log, *parsing* *output*, ekstraksi data, dan transformasi format teks.

Peran modul ini sangat sentral dalam shell scripting. Ingat "Unix Philosophy" dari Modul 1.1: "Tulis program untuk menangani aliran teks, karena itu adalah antarmuka universal." Regex adalah jembatan yang memungkinkan Anda untuk benar-benar memanfaatkan filosofi ini. Banyak data yang akan Anda proses di lingkungan server, *log* sistem, *output* perintah, dan bahkan kode sumber, semuanya adalah teks. Menguasai Regex memungkinkan Anda untuk mengekstrak informasi spesifik, memfilter data, atau mengubahnya ke format yang diinginkan dengan presisi dan efisiensi yang luar biasa. Dalam konteks pemrograman, kemampuan ini mirip dengan penanganan *string* yang canggih di Dart atau bahasa lain, tetapi dilakukan langsung di baris perintah.

### **2. Konsep Kunci & Filosofi Mendalam:**

#### **2.1. Teks sebagai Antarmuka Universal:**

Ini adalah salah satu pilar filosofi Unix. Hampir semua *output* program di Unix/Linux adalah teks. Ini memungkinkan Anda untuk "merangkai" program bersama-sama menggunakan *pipes* dan menggunakan alat-alat standar yang bekerja dengan teks untuk memproses data dari berbagai sumber. Regex adalah kunci untuk membuka potensi penuh dari antarmuka teks ini.

#### **2.2. Pola, Bukan Pencarian Literal:**

Regex bukan hanya tentang mencari *string* yang sama persis. Ini tentang mendefinisikan *pola* yang cocok dengan banyak *string* yang berbeda tetapi memiliki struktur yang sama. Misalnya, Anda bisa mencari semua alamat IP, semua tanggal dalam format tertentu, atau semua baris yang dimulai dengan kata tertentu dan diakhiri dengan angka. Ini memberikan kekuatan dan fleksibilitas yang luar biasa dalam memproses data yang tidak terstruktur atau semi-terstruktur.

#### **2.3. Efisiensi dan Otomasi:**

Meskipun Regex bisa terlihat kompleks pada awalnya, begitu Anda menguasainya, Anda dapat menyelesaikan tugas manipulasi teks yang rumit dalam satu baris perintah (atau beberapa baris dalam skrip) yang akan membutuhkan banyak baris kode di bahasa pemrograman lain. Ini sangat meningkatkan efisiensi dan mempercepat proses otomasi.

#### **2.4. `grep`, `sed`, dan `awk`: Tiga Pilar Manipulasi Teks:**

Ketiga alat ini adalah *workhorse* di dunia Unix:

* **`grep`:** Dirancang untuk *mencari* baris yang cocok dengan pola Regex dan menampilkannya. (Filter)
* **`sed`:** Dirancang untuk *mengedit* aliran teks baris per baris. Paling sering digunakan untuk substitusi (mengganti satu pola dengan pola lain). (Editor Stream)
* **`awk`:** Lebih dari sekadar editor, `awk` adalah bahasa pemrograman kecil yang dirancang untuk *memproses teks berbasis kolom* atau bidang. Sangat kuat untuk ekstraksi dan pelaporan data. (Prosesor Berorientasi Kolom)

### **3. Sintaks Dasar / Contoh Implementasi Inti:**

#### **3.1. Pengenalan Ekspresi Reguler (Regex):**

Regex adalah urutan karakter yang membentuk pola pencarian.

* **Karakter Literal:** Cocok dengan dirinya sendiri (misal, `a` cocok dengan `a`).
* **Metacharacter:** Karakter dengan makna khusus.
  * `.` (titik): Cocok dengan karakter tunggal apa pun (kecuali *newline*).
  * `*` (asterisk): Cocok dengan 0 atau lebih dari karakter/grup sebelumnya.
  * `+` (plus): Cocok dengan 1 atau lebih dari karakter/grup sebelumnya.
  * `?` (tanda tanya): Cocok dengan 0 atau 1 dari karakter/grup sebelumnya.
  * `^` (caret): Cocok dengan awal baris.
  * `$` (dollar): Cocok dengan akhir baris.
  * `[ ]` (kurung siku): Cocok dengan salah satu karakter di dalamnya (misal, `[abc]` cocok dengan `a`, `b`, atau `c`).
    * `[a-z]`: Rentang huruf kecil.
    * `[0-9]`: Rentang digit.
    * `[^...]`: Negasi (cocok dengan karakter apa pun *kecuali* yang ada di dalamnya).
  * `|` (pipa): OR logis (misal, `apel|jeruk` cocok dengan `apel` atau `jeruk`).
  * `(` `)` (kurung): Mengelompokkan pola.
  * `\` (backslash): Meng-escape metacharacter (misal, `\.` cocok dengan titik literal).

**Contoh Umum:**

* `^From`: Baris yang dimulai dengan "From".
* `[0-9]{3}-[0-9]{3}-[0-9]{4}`: Pola nomor telepon (misal, `123-456-7890`).
* `[A-Za-z]+`: Satu atau lebih huruf.
* `.*`: Cocok dengan semua karakter hingga akhir baris.

#### **3.2. Menggunakan Regex dengan `grep`:**

`grep` (Global Regular Expression Print) mencari baris yang cocok dengan pola.

```bash
#!/bin/bash
set -euo pipefail

echo "=== Contoh Grep ==="
echo "Ini adalah baris pertama." > example.txt
echo "Baris kedua dengan kata kunci." >> example.txt
echo "Baris ketiga tanpa kata." >> example.txt
echo "Kata kunci muncul lagi." >> example.txt

echo "Mencari 'kata kunci':"
grep "kata kunci" example.txt

echo "Mencari baris yang dimulai dengan 'Baris' (dengan -E untuk extended regex):"
grep -E "^Baris" example.txt

echo "Mencari angka (dengan -E):"
echo "Produk A: 123" >> example.txt
echo "Produk B: 45" >> example.txt
grep -E "[0-9]+" example.txt

rm example.txt # Bersihkan
```

* **Opsi `grep` yang Penting:**
  * `-E` (atau `egrep`): Menggunakan *extended regular expressions* (EREs), yang mendukung `+`, `?`, `|`, `()` tanpa perlu di-*escape*. **Direkomendasikan.**
  * `-F` (atau `fgrep`): Mencari *string* literal (non-regex). Cepat untuk pencarian eksak.
  * `-i`: Abaikan kasus (case-insensitive).
  * `-v`: Invert match (tampilkan baris yang *tidak* cocok).
  * `-n`: Tampilkan nomor baris.
  * `-r`: Rekursif (cari di subdirektori).

#### **3.3. Menggunakan Regex dengan `sed`:**

`sed` (Stream Editor) digunakan untuk transformasi teks. Perintah `s` (substitusi) adalah yang paling umum.

**Sintaks `sed` substitusi:** `s/pola_regex/string_pengganti/flags`

```bash
#!/bin/bash
set -euo pipefail

echo "=== Contoh Sed ==="
echo "apel,jeruk,mangga" > fruits.txt
echo "anggur,pisang" >> fruits.txt

echo "Mengganti koma dengan spasi (g = global, semua kemunculan):"
sed 's/,/ /g' fruits.txt

echo "Menghapus baris yang mengandung 'anggur':"
sed '/anggur/d' fruits.txt # d = delete

echo "Mengganti baris yang dimulai dengan 'apel' dengan 'Ini adalah apel':"
sed '/^apel/c Ini adalah apel' fruits.txt # c = change (ganti seluruh baris)

echo "Menambahkan baris di atas setiap baris yang mengandung 'mangga':"
sed '/mangga/i\--- Baris Baru ---' fruits.txt # i = insert

rm fruits.txt # Bersihkan
```

* **Bendera (`flags`) `sed` yang Penting:**
  * `g`: Global (ganti semua kemunculan pola di setiap baris, bukan hanya yang pertama).
  * `i`: Case-insensitive (GNU sed).
  * `I`: Case-insensitive (BSD sed, termasuk macOS).
  * `p`: Print (cetak baris yang dimodifikasi, sering digunakan dengan `-n`).
  * `d`: Delete (hapus baris yang cocok).
  * `i`: Insert (sisipkan baris sebelum baris yang cocok).
  * `a`: Append (sisipkan baris setelah baris yang cocok).

#### **3.4. Menggunakan Regex dengan `awk`:**

`awk` adalah bahasa yang kuat untuk pemrosesan teks berbasis kolom. Secara *default*, `awk` memisahkan setiap baris menjadi "bidang" atau "kolom" berdasarkan spasi atau tab.

**Sintaks `awk`:** `awk 'pola { tindakan }' file`

```bash
#!/bin/bash
set -euo pipefail

echo "=== Contoh Awk ==="
echo "Nama,Usia,Kota" > data.csv
echo "Andi,30,Jakarta" >> data.csv
echo "Budi,25,Bandung" >> data.csv
echo "Citra,35,Surabaya" >> data.csv

echo "Mencetak kolom kedua (Usia) untuk setiap baris:"
awk -F',' '{ print $2 }' data.csv # -F',': delimiter adalah koma

echo "Mencetak baris yang usianya lebih dari 30:"
awk -F',' '$2 > 30 { print $0 }' data.csv # $0 = seluruh baris

echo "Mencetak nama dan usia dari baris yang mengandung 'Jakarta':"
awk -F',' '/Jakarta/ { print $1, $2 }' data.csv

echo "Menghitung total usia:"
awk -F',' 'BEGIN {sum=0} {sum+=$2} END {print "Total Usia:", sum}' data.csv

rm data.csv # Bersihkan
```

* **Pola `awk`:**
  * `BEGIN { ... }`: Kode yang dijalankan sebelum memproses file.
  * `END { ... }`: Kode yang dijalankan setelah memproses file.
  * `/regex/`: Mencocokkan baris dengan pola regex.
  * `kondisi`: Kondisi numerik atau string (misal, `$2 > 30`).
* **Variabel Khusus `awk`:**
  * `$0`: Seluruh baris saat ini.
  * `$1`, `$2`, ...: Bidang pertama, kedua, dan seterusnya.
  * `NF`: Jumlah bidang di baris saat ini.
  * `NR`: Nomor baris saat ini.
  * `FS`: Field Separator (sama dengan opsi `-F`).
  * `RS`: Record Separator (delimiter antar baris, default newline).
  * `OFS`: Output Field Separator (delimiter saat `print` dengan koma).
  * `ORS`: Output Record Separator.

#### **3.5. Kelompok (Groups) dan Referensi Balik (Backreferences):**

* **Kelompok `()`:** Mengelompokkan bagian dari pola regex.
* **Referensi Balik `\1`, `\2`, ...:** Digunakan dalam string pengganti (pada `sed`) untuk merujuk pada teks yang cocok dengan kelompok tertentu dalam pola.

<!-- end list -->

```bash
#!/bin/bash
set -euo pipefail

echo "=== Contoh Groups dan Backreferences ==="
echo "Nama: John Doe, ID: 12345" > id_list.txt
echo "Nama: Jane Smith, ID: 67890" >> id_list.txt

echo "Mengganti format 'Nama: X, ID: Y' menjadi 'ID Y (Nama X)':"
sed -E 's/Nama: ([^,]+), ID: ([0-9]+)/ID \2 (Nama \1)/' id_list.txt

rm id_list.txt # Bersihkan
```

* **Penjelasan Regex:**
  * `([^\,]+)`: Kelompok pertama. `[^,]` berarti cocok dengan karakter apa pun kecuali koma, `+` berarti satu atau lebih. Ini akan menangkap nama.
  * `([0-9]+)`: Kelompok kedua. `[0-9]` berarti digit, `+` berarti satu atau lebih. Ini akan menangkap ID.
  * `\1` dan `\2`: Dalam string pengganti, merujuk pada teks yang cocok dengan kelompok pertama dan kedua.

### **4. Terminologi Kunci & Penjelasan Detil:**

* **Ekspresi Reguler (Regular Expression / Regex / Regexp):** Urutan karakter yang mendefinisikan pola pencarian, digunakan untuk pencocokan dan manipulasi *string*.
* **`grep`:** Perintah baris perintah Unix untuk mencari baris yang cocok dengan pola ekspresi reguler.
* **`sed` (Stream Editor):** Editor aliran teks yang dapat melakukan operasi seperti pencarian, penggantian, penyisipan, dan penghapusan baris berdasarkan pola.
* **`awk`:** Bahasa pemrograman dan alat baris perintah yang dirancang khusus untuk memproses data berbasis teks (seringkali kolom atau bidang).
* **Metacharacter:** Karakter dalam Regex yang memiliki makna khusus (misal, `.`, `*`, `^`, `$`).
* **Kuantifier:** Karakter Regex yang menentukan berapa kali elemen sebelumnya dapat muncul (misal, `*`, `+`, `?`, `{n}`, `{n,}`, `{n,m}`).
* **Kelas Karakter (`[]`):** Pola dalam Regex yang cocok dengan salah satu karakter dalam daftar (misal, `[aeiou]`). Juga bisa berupa rentang (`[a-z]`) atau negasi (`[^0-9]`).
* **Anchor:** Metacharacter yang cocok dengan posisi, bukan karakter (misal, `^` untuk awal baris, `$` untuk akhir baris).
* **Kelompok Penangkapan (Capturing Groups):** Bagian dari pola Regex yang diapit kurung `()` yang "menangkap" teks yang cocok untuk digunakan kembali (misal, dalam referensi balik).
* **Referensi Balik (Backreferences):** Dalam string pengganti atau pola Regex, merujuk pada teks yang ditangkap oleh kelompok sebelumnya (misal, `\1`, `\2`).
* **Standard Input (stdin), Output (stdout), Error (stderr):** Aliran data dasar yang digunakan program Unix. Regex alat sering membaca dari `stdin` dan menulis ke `stdout`.
* **Delimiter:** Karakter pemisah yang digunakan oleh `sed` atau `awk` untuk memisahkan bidang atau pola. Untuk `sed` biasanya `/`, untuk `awk` biasanya spasi/tab secara *default* atau ditentukan dengan `-F`.

### **5. Rekomendasi Visualisasi (Jika Diperlukan):**

* **Infografis Karakter Regex:** Bagan visual yang menunjukkan setiap metacharacter Regex dengan contoh sederhana.
* **Alur `grep`, `sed`, `awk`:** Diagram yang menunjukkan bagaimana teks mengalir dari satu perintah ke perintah berikutnya melalui *pipe*, dengan setiap alat (grep, sed, awk) digambarkan sebagai "filter" atau "transformator" yang bekerja pada aliran teks.
* **Diagram Kerja `sed` `s///`:** Ilustrasi *string* asli, pola Regex yang cocok, dan bagaimana *string* pengganti menggunakan referensi balik untuk membentuk *output*.
* **Tabel `awk` Kolom:** Visualisasi file teks sebagai tabel, dengan panah yang menunjuk ke `$1`, `$2`, `$NF`, `$0` untuk menjelaskan konsep bidang.

### **6. Hubungan dengan Modul Lain:**

Modul ini secara langsung merupakan kelanjutan dari **Modul 1.2 (I/O Redirection)**, karena alat-alat Regex sering digunakan dalam *pipeline* untuk memproses aliran data. Pemahaman **Variabel dan Ekspansi (Modul 1.3)** sangat penting untuk menyimpan hasil manipulasi teks. Hasil dari perintah Regex (seperti *exit status* dari `grep` untuk kecocokan) dapat digunakan dalam **Struktur Kondisional (Modul 2.1)** untuk pengambilan keputusan dalam skrip. Penggunaan fungsi (**Modul 2.3**) dapat membungkus operasi Regex yang kompleks menjadi unit yang dapat digunakan kembali. Terakhir, Regex akan menjadi alat utama yang Anda gunakan dalam **Otomatisasi Tugas Administrasi Sistem (Modul 4.1)** untuk analisis log, dan **Keamanan (Modul 4.2)** untuk validasi input dan deteksi pola yang mencurigakan, serta **Interoperabilitas (Modul 4.3)** untuk mem-parsing data.

### **7. Sumber Referensi Lengkap:**

* **RegexOne - Learn Regex with interactive, in-browser exercises:** [https://regexone.com/](https://regexone.com/)
  * **Detail:** Sumber daya interaktif yang sangat baik untuk mempelajari dasar-dasar Regex dengan latihan langsung.
* **The Linux Documentation Project - Advanced Bash-Scripting Guide: Regular Expressions:** [https://tldp.org/LDP/abs/html/regexp.html](https://tldp.org/LDP/abs/html/regexp.html)
  * **Detail:** Penjelasan mendalam tentang Regex dalam konteks Bash, termasuk perbedaan antara *basic* dan *extended* Regex.
* **Ryan's Tutorials - Grep, Sed, Awk:** [https://ryanstutorials.net/linuxtutorial/grep.php](https://ryanstutorials.net/linuxtutorial/grep.php) [https://ryanstutorials.net/linuxtutorial/sed.php](https://ryanstutorials.net/linuxtutorial/sed.php) [https://ryanstutorials.net/linuxtutorial/awk.php](https://ryanstutorials.net/linuxtutorial/awk.php)
  * **Detail:** Tutorial yang jelas dan praktis untuk setiap alat, dengan banyak contoh.
* **Greg's Wiki - Why you shouldn't parse ls:** [https://mywiki.wooledge.org/ParsingLs](https://mywiki.wooledge.org/ParsingLs)
  * **Detail (Penting untuk Modul 4.2):** Meskipun ini tentang parsing `ls`, ini menekankan masalah fundamental dalam memproses *output* teks yang tidak dirancang untuk diproses mesin, yang sering melibatkan Regex.
* **Regular-Expressions.info:** [https://www.regular-expressions.info/](https://www.regular-expressions.info/)
  * **Detail:** Sumber daya paling komprehensif untuk Regex, mencakup berbagai *flavour* (PCRE, POSIX, dll.) dan konsep tingkat lanjut.

### **8. Tips dan Praktik Terbaik:**

* **Mulai dari Sederhana:** Jangan mencoba membangun Regex yang sangat kompleks sekaligus. Mulailah dengan pola kecil, uji, lalu tambahkan kompleksitas.
* **Gunakan `-E` untuk `grep` dan `sed` (jika tersedia):** *Extended Regular Expressions* lebih mudah dibaca dan ditulis karena Anda tidak perlu meng-*escape* metacharacter umum seperti `+`, `?`, `|`, `()`.
* **Pengujian Iteratif:** Uji Regex Anda secara iteratif pada *sample data* kecil. Gunakan `grep` terlebih dahulu untuk melihat kecocokan, lalu `sed` atau `awk` untuk transformasi.
* **Gunakan Alat Online:** Ada banyak situs web (misal, `regex101.com`, `regexr.com`) yang memungkinkan Anda menguji Regex secara interaktif dan memberikan penjelasan rinci. Manfaatkan ini\!
* **Pahami Perbedaan `grep`, `sed`, `awk`:** Masing-masing alat memiliki kekuatan spesifiknya. Pilih alat yang tepat untuk tugas yang tepat (filter, edit, proses kolom).
* **Gunakan Kutipan Tunggal (`'...'`) untuk Pola Regex:** Ini mencegah shell dari melakukan ekspansi pada karakter dalam pola Regex sebelum pola diteruskan ke alat (misal, `$` dan `*` akan diinterpretasikan oleh shell jika Anda menggunakan kutipan ganda).

### **9. Potensi Kesalahan Umum & Solusi:**

* **Kesalahan:** Lupa meng-*escape* metacharacter.
  * **Penyebab:** Karakter seperti `.`, `*`, `+`, `?`, `(`, `)`, `[`, `]`, `|`, `^`, `$` memiliki makna khusus dalam Regex. Jika Anda ingin mencocokkan karakter literalnya, Anda harus meng-*escape*-nya dengan `\`.
  * **Solusi:** `\.`, `\*`, `\+`, `\?`, `\(`, `\)`, `\[`, `\]`, `\|`, `\^`, `\$`. Atau, gunakan `grep -F` jika Anda hanya mencari *string* literal tanpa Regex.
* **Kesalahan:** Tidak menggunakan kutipan tunggal (`'...'`) pada pola Regex.
  * **Penyebab:** Jika Anda menggunakan kutipan ganda (`"..."`) atau tidak ada kutipan sama sekali, shell mungkin akan menginterpretasikan beberapa metacharacter (`$`, `*`, `?`, `[]`) sebelum pola Regex diteruskan ke `grep`, `sed`, atau `awk`, menyebabkan hasil yang tidak terduga.
  * **Solusi:** Selalu gunakan kutipan tunggal untuk pola Regex Anda: `grep 'pola' file`.
* **Kesalahan:** Menggunakan *Basic Regular Expressions* (BRE) dan lupa meng-*escape* metacharacter Extended Regex.
  * **Penyebab:** Secara *default*, `grep` dan `sed` menggunakan BRE, di mana karakter seperti `(`, `)`, `{`, `}`, `|`, `+`, `?` harus di-*escape* untuk memiliki makna khusus Regex.
  * **Solusi:** Gunakan opsi `-E` (atau perintah `egrep`) untuk `grep` dan `sed` jika Anda ingin menggunakan *Extended Regular Expressions* (EREs). Ini adalah praktik yang jauh lebih umum dan lebih mudah.
* **Kesalahan:** `sed` hanya mengganti kemunculan pertama pada setiap baris.
  * **Penyebab:** Secara *default*, perintah `s` di `sed` hanya mengganti kemunculan pertama pola pada setiap baris.
  * **Solusi:** Gunakan bendera `g` (global) di akhir perintah `s`: `sed 's/pola/pengganti/g'`.
* **Kesalahan:** Mem-parsing *output* `ls`.
  * **Penyebab:** *Output* `ls` tidak dirancang untuk diproses oleh program lain. Nama file bisa mengandung spasi, *newline*, atau karakter khusus lainnya yang akan merusak *parsing*.
  * **Solusi:** Gunakan `find -print0` dengan `xargs -0`, atau *globbing* sederhana (`*.txt`) jika memungkinkan, atau *array* Bash. Hindari mem-parsing `ls`\!

-----

**Selamat!** Anda telah mempelajari Ekspresi Reguler dan alat-alat manipulasi teks tingkat lanjut (`grep`, `sed`, `awk`). Ini adalah salah satu set keterampilan paling kuat yang dapat Anda miliki dalam shell scripting.

Dengan ini, Anda telah menyelesaikan **Fase 3: Mahir – Skrip yang Andal dan Profesional**. Kita akan segera masuk ke **Fase 4: Pakar – Aplikasi Skala Enterprise dan Keamanan (Tingkat Pakar)**.

> * **[Ke Atas](#)**
> * **[Selanjutnya][selanjutnya]**
> * **[Sebelumnya][sebelumnya]**
> * **[Kurikulum][kurikulum]**
> * **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

<!----------------------------------------------------->
 [1]: ../README.md