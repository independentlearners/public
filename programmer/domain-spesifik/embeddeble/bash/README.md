> **[Belajar CLI/Terminal Baris Perintah][0]**

# **Kurikulum Komprehensif: Menguasai Shell Scripting (Bash)**

Kurikulum ini adalah peta jalan untuk menguasai seni otomasi di lingkungan berbasis Unix/Linux. Shell scripting bukan hanya tentang menulis kode, tetapi tentang memahami dan memanfaatkan kekuatan baris perintah secara maksimal.

#### **Prasyarat**

- **Wajib:** Literasi komputer dasar. Kemampuan untuk membuka aplikasi dan mengelola file. Tidak diperlukan latar belakang pemrograman sama sekali.
- **Direkomendasikan:** Keingintahuan tentang cara kerja sistem operasi dan keinginan untuk membuat pekerjaan yang berulang menjadi lebih efisien.

#### **Alat Esensial**

- **Terminal Emulator:** Bawaan dari sistem operasi Linux atau macOS. Untuk Windows, direkomendasikan menggunakan **Windows Subsystem for Linux (WSL2)**.
- **Shell:** **Bash (Bourne-Again Shell)**. Ini adalah shell default di sebagian besar distribusi Linux dan tersedia di macOS/WSL, menjadikannya standar de-facto.
- **Editor Teks:** Apa pun dari `nano` (untuk pemula), `vim`, hingga IDE modern seperti **Visual Studio Code** dengan ekstensi **`shellcheck`** dan **`Shellman`**.
- **ShellCheck:** Alat analisis statis yang **wajib** digunakan untuk menemukan kesalahan umum dan praktik buruk dalam skrip Anda. [https://www.shellcheck.net/](https://www.shellcheck.net/)

#### **Estimasi Waktu & Level**

- **Fase 1 (Fondasi):** 2-3 minggu (Tingkat Pemula)
- **Fase 2 (Menengah):** 4-6 minggu (Tingkat Menengah)
- **Fase 3 (Mahir):** 4-6 minggu (Tingkat Mahir)
- **Fase 4 (Pakar):** Pembelajaran berkelanjutan (Tingkat Pakar/Enterprise)

**Total Waktu Belajar Inti:** Sekitar 3-4 bulan untuk mencapai tingkat kemahiran yang sangat solid.

---

### **[Fase 1: Fondasi – Berinteraksi dengan Shell (Tingkat Pemula)][1]**

**Tujuan Fase:** Membangun kenyamanan di baris perintah, memahami konsep fundamental interaksi dengan shell, dan menulis skrip pertama yang fungsional.

---

#### **Modul 1.1: Filosofi dan Lingkungan Shell**

1. **Deskripsi Konkret:** Modul ini memperkenalkan Anda pada "mengapa" dari baris perintah. Anda akan belajar apa itu shell, perbedaannya dengan terminal, dan prinsip-prinsip desain yang membuatnya begitu kuat dan bertahan lama.
2. **Konsep Dasar dan Filosofi:**
    - **The Unix Philosophy:**
      1. _Tulis program yang melakukan satu hal dan melakukannya dengan baik._ Contoh: `grep` hanya untuk mencari teks.
      2. _Tulis program yang bekerja bersama._ Ini adalah dasar dari penggunaan _pipes_.
      3. _Tulis program untuk menangani aliran teks, karena itu adalah antarmuka universal._
    - **Shell sebagai Interpreter Perintah:** Shell bukanlah terminal (jendela hitam). Shell adalah program yang berjalan di dalam terminal, yang tugasnya membaca perintah Anda, menafsirkannya, dan meminta kernel sistem operasi untuk menjalankannya.
3. **Sintaks Dasar/Contoh Implementasi Inti:**

    - Tidak ada kode skrip di sini, hanya interaksi:

      ```bash
      # Mengetahui shell apa yang sedang Anda gunakan
      echo $SHELL

      # Melihat di mana program 'ls' berada
      which ls

      # Mendapatkan bantuan untuk sebuah perintah
      man ls
      ```

4. **Terminologi Kunci:**
    - **Terminal:** Aplikasi yang menyediakan antarmuka jendela untuk berinteraksi dengan shell.
    - **Shell:** Program interpreter perintah (misalnya, `bash`, `zsh`, `sh`). Ini adalah lingkungan pemrograman itu sendiri.
    - **Command Line Interface (CLI):** Antarmuka pengguna berbasis teks.
    - **Kernel:** Inti dari sistem operasi yang mengelola sumber daya perangkat keras dan perangkat lunak.
5. **Daftar Isi:**
    - Sejarah Singkat Unix dan Shell
    - Membedakan Terminal, Konsol, dan Shell
    - Memahami Filosofi Unix
    - Navigasi Dasar: `pwd`, `ls`, `cd`
    - Mendapatkan Bantuan: `man`, `tldr`, `--help`
6. **Sumber Referensi:**
    - [The Art of Unix Programming (Eric S. Raymond)](http://www.catb.org/~esr/writings/taoup/html/)
    - [Linux Command Line for Beginners (Ubuntu)](https://ubuntu.com/tutorials/command-line-for-beginners)

---

#### **Modul 1.2: Perintah Fundamental dan I/O Redirection**

1. **Deskripsi Konkret:** Anda akan belajar bagaimana menggabungkan perintah-perintah sederhana menjadi alur kerja yang kuat menggunakan _redirection_ dan _pipes_. Ini adalah keterampilan paling fundamental dalam shell scripting.
2. **Konsep Dasar dan Filosofi:** Di dunia Unix/Linux, hampir semuanya direpresentasikan sebagai file. Setiap program secara default memiliki tiga aliran data: Standard Input (stdin), Standard Output (stdout), dan Standard Error (stderr). Dengan mengarahkan aliran ini, Anda dapat mengontrol input dan output program.
3. **Sintaks Dasar/Contoh Implementasi Inti:**

    ```bash
    # Menulis output dari 'ls -l' ke dalam file 'daftar_file.txt'
    ls -l > daftar_file.txt

    # Menambahkan output ke file yang sudah ada
    date >> daftar_file.txt

    # Menggunakan output 'cat' sebagai input untuk 'grep' (mencari kata 'Dokumen')
    cat daftar_file.txt | grep "Dokumen"

    # Mengarahkan pesan error ke file terpisah
    find / -name "rahasia.txt" 2> error.log
    ```

4. **Terminologi Kunci:**
    - **Standard Input (stdin, fd 0):** Aliran data masukan default, biasanya dari keyboard.
    - **Standard Output (stdout, fd 1):** Aliran data keluaran default, biasanya ke layar.
    - **Standard Error (stderr, fd 2):** Aliran untuk pesan kesalahan, juga biasanya ke layar.
    - **Pipe (`|`):** Operator yang mengirimkan `stdout` dari perintah di sebelah kiri menjadi `stdin` dari perintah di sebelah kanan.
    - **Redirection (`>`, `>>`, `<`):** Operator untuk mengarahkan aliran data ke atau dari file.
5. **Daftar Isi:**
    - Memahami Standard Streams: stdin, stdout, stderr
    - Output Redirection: `>` (timpa) dan `>>` (tambahkan)
    - Input Redirection: `<`
    - Kekuatan Pipes (`|`): Merangkai Perintah
    - Menggabungkan dan Mengarahkan Stream (`2>&1`)
    - Perintah Esensial: `cat`, `grep`, `head`, `tail`, `wc`, `sort`, `uniq`
6. **Sumber Referensi:**
    - [I/O Redirection (The Linux Documentation Project)](https://tldp.org/LDP/abs/html/io-redirection.html)
    - [Ryans Tutorials - Pipes and Redirection](https://ryanstutorials.net/linuxtutorial/piping.php)
7. **Visualisasi:**
    - Diagram alur sangat direkomendasikan di sini untuk mengilustrasikan bagaimana data mengalir dari `stdout` satu perintah ke `stdin` perintah berikutnya melalui sebuah _pipe_.

---

#### **Modul 1.3: Skrip Pertama Anda, Variabel, dan Ekspansi**

1. **Deskripsi Konkret:** Anda akan menulis, menyimpan, dan menjalankan skrip shell pertama Anda. Modul ini mencakup konsep variabel untuk menyimpan data dan bagaimana shell melakukan ekspansi (mengganti variabel dan perintah dengan nilainya).
2. **Konsep Dasar dan Filosofi:** Skrip adalah cara untuk menyimpan urutan perintah dalam sebuah file agar dapat dieksekusi kembali. Variabel memungkinkan skrip menjadi dinamis dan dapat digunakan kembali, bukan hanya urutan perintah yang statis.
3. **Sintaks Dasar/Contoh Implementasi Inti:**

    ```bash
    # File: sapa.sh
    #!/bin/bash

    # 1. Deklarasi variabel (tanpa spasi di sekitar '=')
    NAMA="Andi"

    # 2. Menggunakan variabel (ekspansi)
    echo "Halo, $NAMA!"

    # 3. Command Substitution: menyimpan output perintah ke variabel
    LOKASI_SAAT_INI=$(pwd)
    echo "Anda berada di direktori: $LOKASI_SAAT_INI"

    # 4. Membaca input dari pengguna
    echo -n "Masukkan kota Anda: "
    read KOTA
    echo "Senang bertemu dengan Anda dari $KOTA!"
    ```

    - Untuk menjalankan: `chmod +x sapa.sh` lalu `./sapa.sh`

4. **Terminologi Kunci:**
    - **Shebang (`#!`):** Baris pertama dalam skrip yang memberitahu sistem operasi interpreter mana yang harus digunakan untuk menjalankan skrip ini.
    - **Variable:** Nama simbolis yang terkait dengan sebuah nilai.
    - **Expansion:** Proses di mana shell mengganti elemen seperti `$VARIABEL` atau `$(perintah)` dengan nilainya sebelum menjalankan baris perintah.
    - **Quoting:** Penggunaan tanda kutip (`"` atau `'`) untuk mengontrol kapan ekspansi terjadi. `"` (double quotes) mengizinkan ekspansi, `'` (single quotes) mencegahnya.
5. **Daftar Isi:**
    - Struktur Skrip: Shebang dan Komentar
    - Membuat Skrip Dapat Dieksekusi (`chmod`)
    - Deklarasi dan Penggunaan Variabel
    - Perbedaan antara Double Quotes (`"`) dan Single Quotes (`'`)
    - Command Substitution: `$(...)` vs. Backticks (`` ` ``)
    - Membaca Input Pengguna dengan `read`
    - Arithmetic Expansion: `$((...))`
6. **Sumber Referensi:**
    - [Bash Guide for Beginners - Chapter 3: The Bash environment](https://tldp.org/LDP/Bash-Beginners-Guide/html/Bash-Beginners-Guide.html%23chap_03)
    - [Greg's Wiki - BashFAQ/050 (Quoting)](https://mywiki.wooledge.org/Quotes)

---

### **[Fase 2: Menengah – Struktur, Kontrol, dan Manipulasi Teks (Tingkat Menengah)][2]**

**Tujuan Fase:** Menguasai elemen-elemen pemrograman standar (kondisional, perulangan, fungsi) dan menggunakan alat bantu teks yang kuat untuk memproses data.

---

#### **Modul 2.1: Struktur Kondisional**

1. **Deskripsi Konkret:** Anda akan belajar bagaimana membuat skrip Anda mengambil keputusan berdasarkan kondisi tertentu menggunakan `if`, `else`, dan `case`.
2. **Konsep Dasar dan Filosofi:** Logika kondisional adalah inti dari semua pemrograman. Ini memungkinkan skrip untuk bereaksi secara berbeda terhadap input, status sistem, atau hasil perintah yang berbeda, membuatnya jauh lebih cerdas dan fleksibel.
3. **Sintaks Dasar/Contoh Implementasi Inti:**

    ```bash
    #!/bin/bash

    # Perbandingan string
    if [[ "$1" == "mulai" ]]; then
      echo "Memulai layanan..."
    elif [[ "$1" == "berhenti" ]]; then
      echo "Menghentikan layanan..."
    else
      echo "Penggunaan: $0 {mulai|berhenti}"
      exit 1 # Keluar dengan status error
    fi

    # Perbandingan angka
    JUMLAH_FILE=$(ls | wc -l)
    if (( JUMLAH_FILE > 10 )); then
      echo "Peringatan: Direktori ini memiliki banyak file."
    fi

    # Mengecek keberadaan file
    if [[ -f "/etc/passwd" ]]; then
      echo "File passwd ditemukan."
    fi
    ```

4. **Terminologi Kunci:**
    - **`if/then/elif/else/fi`:** Kata kunci untuk membangun blok kondisional.
    - **`test` atau `[`:** Perintah tradisional untuk evaluasi kondisi.
    - **`[[ ... ]]`:** Kata kunci Bash modern yang lebih kuat dan aman untuk evaluasi kondisi.
    - **Exit Code (`$?`):** Nilai numerik yang dikembalikan oleh setiap perintah setelah selesai. `0` berarti sukses, nilai lain berarti gagal.
5. **Daftar Isi:**
    - Memahami Exit Codes (`$?`)
    - Struktur `if ... then ... fi`
    - Menggunakan `test` (`[ ... ]`) vs. `[[ ... ]]`
    - Operator Perbandingan String, Angka, dan File
    - Menggabungkan Kondisi (AND `&&`, OR `||`)
    - Struktur `case ... esac` untuk pencocokan pola
6. **Sumber Referensi:**
    - [Bash Conditional Expressions (Bash Manual)](https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html)
    - [Greg's Wiki - BashFAQ/031 (if/test)](https://mywiki.wooledge.org/BashFAQ/031)

---

#### **Modul 2.2: Perulangan (Loops)**

1. **Deskripsi Konkret:** Pelajari cara mengotomatiskan tugas-tugas yang berulang pada serangkaian item (seperti file atau baris teks) menggunakan perulangan `for`, `while`, dan `until`.
2. **Konsep Dasar dan Filosofi:** Perulangan adalah pilar otomasi. Daripada menjalankan perintah yang sama secara manual berulang kali, Anda dapat menginstruksikan shell untuk melakukannya untuk Anda, menghemat waktu dan mengurangi kesalahan manusia.
3. **Sintaks Dasar/Contoh Implementasi Inti:**

    ```bash
    #!/bin/bash

    # Perulangan FOR pada daftar item
    for BUAH in apel jeruk mangga; do
      echo "Saya suka $BUAH"
    done

    # Perulangan FOR pada file di direktori saat ini
    for FILE in *.txt; do
      echo "Memproses file: $FILE"
      cp "$FILE" "$FILE.bak"
    done

    # Perulangan WHILE untuk membaca file baris per baris (cara yang benar)
    while IFS= read -r BARIS; do
      echo "Baris data: $BARIS"
    done < data.csv
    ```

4. **Terminologi Kunci:**
    - **`for` loop:** Melakukan iterasi pada daftar kata atau item yang telah ditentukan.
    - **`while` loop:** Terus berjalan selama kondisi tertentu bernilai benar. Ideal untuk membaca input.
    - **`until` loop:** Terus berjalan selama kondisi tertentu bernilai salah.
    - **`IFS` (Internal Field Separator):** Variabel khusus yang menentukan bagaimana shell memisahkan kata. Penting saat membaca file.
5. **Daftar Isi:**
    - Perulangan `for` (termasuk C-style: `for ((i=0; i<5; i++))` )
    - Perulangan `while` dan `until`
    - Pola yang Benar untuk Membaca File Baris demi Baris
    - Mengontrol Perulangan: `break` dan `continue`
6. **Sumber Referensi:**
    - [Bash Loops (ryanstutorials.net)](https://ryanstutorials.net/bash-scripting-tutorial/bash-loops.php)
    - [Greg's Wiki - BashFAQ/001 (Reading a file line-by-line)](https://mywiki.wooledge.org/BashFAQ/001)

---

#### **Modul 2.3: Fungsi dan Cakupan (Scoping)**

1. **Deskripsi Konkret:** Belajar bagaimana mengorganisir kode Anda ke dalam blok-blok yang dapat digunakan kembali yang disebut fungsi. Ini membuat skrip lebih mudah dibaca, di-debug, dan dipelihara.
2. **Konsep Dasar dan Filosofi:** Sesuai prinsip _Don't Repeat Yourself (DRY)_, fungsi memungkinkan Anda untuk mendefinisikan logika yang kompleks sekali dan memanggilnya berkali-kali dari berbagai tempat dalam skrip Anda.
3. **Sintaks Dasar/Contoh Implementasi Inti:**

    ```bash
    #!/bin/bash

    # Mendefinisikan fungsi
    buat_cadangan() {
      # Periksa apakah argumen diberikan
      if [[ -z "$1" ]]; then
        echo "Error: Nama file diperlukan." >&2
        return 1 # Mengembalikan exit code gagal
      fi

      # Gunakan variabel lokal agar tidak "bocor" ke luar fungsi
      local file_asli="$1"
      local file_cadangan="${file_asli}.bak"

      echo "Mencadangkan $file_asli ke $file_cadangan..."
      cp "$file_asli" "$file_cadangan"
    }

    # Memanggil fungsi dengan argumen
    buat_cadangan "laporan.txt"
    buat_cadangan "data_penting.csv"
    ```

4. **Terminologi Kunci:**
    - **Function:** Blok kode yang diberi nama dan dapat dipanggil.
    - **Positional Parameters (`$1`, `$2`, ...):** Variabel khusus di dalam fungsi yang menampung argumen yang dilewatkan saat fungsi dipanggil. `$0` adalah nama skrip itu sendiri.
    - **`return`:** Perintah untuk keluar dari fungsi dengan exit code tertentu.
    - **Scope:** Konteks di mana sebuah variabel dapat diakses.
    - **`local`:** Kata kunci untuk mendeklarasikan variabel yang cakupannya terbatas hanya di dalam fungsi.
5. **Daftar Isi:**
    - Sintaks Deklarasi Fungsi
    - Melewatkan Argumen (Positional Parameters)
    - Mengembalikan Nilai (melalui Exit Codes dan `stdout`)
    - Cakupan Variabel: Global vs. Lokal (`local`)
    - Membuat Pustaka Fungsi (sourcing scripts)
6. **Sumber Referensi:**
    - [Bash Functions (The Linux Documentation Project)](https://tldp.org/LDP/abs/html/functions.html)
    - [Greg's Wiki - BashFAQ/053 (Variable Scope)](https://mywiki.wooledge.org/BashFAQ/053)

---

### **[Fase 3: Mahir – Skrip yang Andal dan Profesional (Tingkat Mahir)][3]**

**Tujuan Fase:** Mengubah skrip sederhana menjadi alat yang kuat, aman, dan siap produksi dengan penanganan kesalahan yang baik, antarmuka pengguna yang layak, dan praktik terbaik.

---

#### **Modul 3.1: Penanganan Kesalahan (Error Handling)**

1. **Deskripsi Konkret:** Pelajari cara membuat skrip Anda berhenti dengan aman ketika terjadi kesalahan, alih-alih melanjutkan eksekusi dengan status yang tidak dapat diprediksi.
2. **Konsep Dasar dan Filosofi:** Dalam produksi, lebih baik skrip gagal total dan memberi tahu Anda, daripada gagal sebagian secara diam-diam dan merusak data. Filosofi "fail-fast" ini penting untuk keandalan.
3. **Sintaks Dasar/Contoh Implementasi Inti:**

    ```bash
    #!/bin/bash

    # --- The Robust Script Template ---
    # Berhenti jika ada perintah yang gagal
    set -o errexit
    # atau set -e

    # Berhenti jika menggunakan variabel yang belum didefinisikan
    set -o nounset
    # atau set -u

    # Berhenti jika ada perintah dalam pipe yang gagal
    set -o pipefail

    # Fungsi yang akan dipanggil saat skrip keluar (karena error atau selesai)
    cleanup() {
      echo "Menjalankan pembersihan..."
      rm -f /tmp/file_sementara.$$
    }

    # Menangkap sinyal EXIT, INT, TERM untuk menjalankan fungsi cleanup
    trap cleanup EXIT INT TERM

    echo "Membuat file sementara..."
    touch /tmp/file_sementara.$$

    echo "Menjalankan perintah yang mungkin gagal..."
    ls /direktori/yang/tidak/ada

    # Baris ini tidak akan pernah dijalankan karena 'set -e'
    echo "Skrip selesai dengan sukses."
    ```

4. **Terminologi Kunci:**
    - **`set` options:** Opsi bawaan shell untuk mengubah perilakunya (`-e`, `-u`, `-o pipefail` adalah yang paling penting).
    - **`trap`:** Perintah untuk "menangkap" sinyal sistem (seperti `Ctrl+C` atau saat skrip keluar) dan menjalankan kode tertentu sebagai respons.
    - **Signal:** Notifikasi perangkat lunak yang dikirim ke suatu proses untuk memberitahunya tentang suatu peristiwa.
5. **Daftar Isi:**
    - Mode "Unofficial Strict Mode": `set -euo pipefail`
    - Menangkap Sinyal dengan `trap` untuk Pembersihan (Cleanup)
    - Menulis Pesan Error ke `stderr`
    - Strategi Penanganan Error yang Dapat Diprediksi
6. **Sumber Referensi:**
    - [Unofficial Bash Strict Mode](http://redsymbol.net/articles/unofficial-bash-strict-mode/)
    - [Bash Trap Command (Linuxize)](https://linuxize.com/post/bash-trap-command/)

---

#### **Modul 3.2: Mem-parsing Argumen Baris Perintah**

1. **Deskripsi Konkret:** Buat skrip Anda lebih profesional dengan menerima opsi dan argumen seperti alat baris perintah standar (misalnya, `ls -l -h`).
2. **Konsep Dasar dan Filosofi:** Antarmuka baris perintah yang konsisten dan dapat diprediksi membuat alat Anda lebih mudah digunakan dan diintegrasikan dengan alat lain. Menggunakan mekanisme standar untuk parsing argumen adalah kunci untuk mencapai ini.
3. **Sintaks Dasar/Contoh Implementasi Inti:**

    ```bash
    #!/bin/bash

    usage() {
      echo "Penggunaan: $0 [-f NAMA_FILE] [-v]"
      exit 1
    }

    # Inisialisasi variabel
    FILE=""
    VERBOSE=0

    # Menggunakan getopts untuk mem-parsing opsi
    while getopts ":f:v" opt; do
      case "${opt}" in
        f)
          FILE=${OPTARG}
          ;;
        v)
          VERBOSE=1
          ;;
        *)
          usage
          ;;
      esac
    done

    if [[ -z "$FILE" ]]; then
        echo "Error: Opsi -f diperlukan."
        usage
    fi

    echo "File = $FILE"
    echo "Verbose = $VERBOSE"
    ```

4. **Terminologi Kunci:**
    - **Option (Opsi):** Argumen yang mengubah perilaku skrip, biasanya diawali dengan `-` (mis., `-v`).
    - **Argument (Argumen):** Nilai yang diberikan ke sebuah opsi (mis., `laporan.txt` dalam `-f laporan.txt`).
    - **`getopts`:** Perintah bawaan shell (POSIX-compliant) untuk mem-parsing opsi sederhana.
    - **`OPTARG`:** Variabel yang digunakan oleh `getopts` untuk menyimpan nilai argumen dari sebuah opsi.
5. **Daftar Isi:**
    - Argumen Posisi Sederhana (`$1`, `$@`, `$*`)
    - Menggunakan `getopts` untuk Parsing Opsi
    - Menangani Opsi dengan dan tanpa Argumen
    - Menulis Fungsi `usage()` atau `help()`
    - Perbedaan antara `getopts` (bawaan) dan `getopt` (eksternal)
6. **Sumber Referensi:**
    - [Parsing command-line arguments in Bash (Stack Abuse)](https://stackabuse.com/how-to-parse-command-line-arguments-in-bash/)
    - [Greg's Wiki - BashFAQ/035 (getopts)](https://mywiki.wooledge.org/BashFAQ/035)

---

### **[Fase 4: Pakar – Aplikasi Skala Enterprise dan Keamanan (Tingkat Pakar)][4]**

**Tujuan Fase:** Menerapkan keterampilan scripting dalam skenario dunia nyata yang kompleks, dengan fokus kuat pada keamanan, interoperabilitas, dan kinerja.

---

#### **Modul 4.1: Otomatisasi Tugas Administrasi Sistem**

1. **Deskripsi Konkret:** Terapkan semua yang telah Anda pelajari untuk membuat skrip praktis yang digunakan oleh Administrator Sistem dan insinyur DevOps setiap hari.
2. **Konsep Dasar dan Filosofi:** Nilai sejati dari shell scripting terletak pada kemampuannya untuk mengotomatiskan tugas-tugas yang membosankan, rawan kesalahan, dan memakan waktu, memungkinkan para profesional TI untuk fokus pada masalah yang lebih besar.
3. **Sintaks Dasar/Contoh Implementasi Inti:**
    - **Studi Kasus 1: Skrip Cadangan (Backup) Otomatis**
      - Menggunakan `tar` untuk mengarsipkan direktori.
      - Menambahkan stempel waktu ke nama file cadangan.
      - Menghapus cadangan lama (rotasi).
      - Menggunakan `cron` untuk menjadwalkan skrip agar berjalan setiap malam.
    - **Studi Kasus 2: Skrip Pemantauan (Monitoring) Sederhana**
      - Mengecek penggunaan disk dengan `df`.
      - Mengecek penggunaan memori dengan `free`.
      - Mengecek apakah suatu proses (misalnya, web server) berjalan dengan `pgrep`.
      - Mengirim email peringatan jika ambang batas terlampaui.
4. **Daftar Isi:**
    - Studi Kasus: Skrip Backup Direktori Web
    - Studi Kasus: Skrip Analisis Log Sederhana
    - Studi Kasus: Skrip Manajemen Pengguna
    - Menjadwalkan Skrip dengan `cron`
5. **Sumber Referensi:**
    - [DigitalOcean - Cron Tutorial](https://www.digitalocean.com/community/tutorials/how-to-use-cron-to-automate-tasks-ubuntu-1804)
    - [Kumpulan skrip administrasi sistem di GitHub (untuk inspirasi)](https://github.com/trimstray/bash-admins-toolkit)

---

#### **Modul 4.2: Pertimbangan Keamanan dalam Shell Scripting**

1. **Deskripsi Konkret:** Ini adalah modul krusial yang relevan dengan minat Anda pada cybersecurity. Anda akan belajar tentang jebakan keamanan umum dalam skrip shell dan cara menghindarinya.
2. **Konsep Dasar dan Filosofi:** Skrip shell, terutama yang berjalan dengan hak akses tinggi, adalah vektor serangan yang potensial jika tidak ditulis dengan hati-hati. Memahami bagaimana shell menginterpretasikan input adalah kunci untuk mencegah kerentanan.
3. **Sintaks Dasar/Contoh Implementasi Inti:**
    - **Kerentanan (JANGAN DILAKUKAN):**

      ```bash
      # RENTAN TERHADAP INJECTION
      FILENAME=$1
      echo "Menghapus file: $FILENAME"
      rm $FILENAME # Jika FILENAME adalah "; rm -rf /", ini bencana
      ```

    - **Perbaikan (LAKUKAN INI):**

      ```bash
      # AMAN
      FILENAME="$1" # Selalu kutip ekspansi variabel!
      echo "Menghapus file: $FILENAME"
      rm -- "$FILENAME" # '--' mencegah interpretasi opsi lebih lanjut
      ```

4. **Terminologi Kunci:**
    - **Shell Injection / Command Injection:** Kerentanan di mana penyerang dapat menyuntikkan dan menjalankan perintah sewenang-wenang melalui input yang tidak divalidasi.
    - **Quoting:** Pertahanan nomor satu melawan injection.
    - **Parsing `ls`:** Praktik buruk mengandalkan output `ls` untuk diproses, karena dapat mengandung karakter tak terduga.
5. **Daftar Isi:**
    - Bahaya Command Injection dan Cara Mencegahnya
    - Pentingnya Mengutip (Quoting) Semua Variabel
    - Mengapa Anda Tidak Boleh Mem-parsing Output `ls`
    - Penggunaan Aman File Sementara dengan `mktemp`
    - Menjalankan Skrip dengan Hak Akses Terendah yang Diperlukan
    - Menggunakan `shellcheck` secara Religius
6. **Sumber Referensi:**
    - [ShellCheck - Gallery of bad code](https://github.com/koalaman/shellcheck/wiki/Gallery-of-bad-code)
    - [OWASP - Command Injection](https://owasp.org/www-community/attacks/Command_Injection)

---

#### **Modul 4.3: Interoperabilitas dengan Alat dan Bahasa Lain**

1. **Deskripsi Konkret:** Shell scripting sering bertindak sebagai "lem" yang merekatkan berbagai alat. Modul ini mengajarkan cara berinteraksi dengan format data modern seperti JSON dan memanggil API.
2. **Konsep Dasar dan Filosofi:** Shell sangat baik dalam mengelola proses dan alur file, tetapi tidak ideal untuk manipulasi data yang kompleks. Mengetahui cara mendelegasikan tugas ke alat yang tepat (seperti `jq` untuk JSON atau Python untuk data science) adalah ciri seorang skripter yang efektif.
3. **Sintaks Dasar/Contoh Implementasi Inti:**

    ```bash
    #!/bin/bash

    # 1. Menggunakan curl untuk memanggil API
    # 2. Menggunakan jq untuk mem-parsing respons JSON dan mengambil satu field
    HARGA_BTC_USD=$(curl -s "https://api.coindesk.com/v1/bpi/currentprice.json" | jq -r '.bpi.USD.rate')

    echo "Harga Bitcoin saat ini: $HARGA_BTC_USD USD"

    # Memanggil skrip Python dan menangkap outputnya
    HASIL_PERHITUNGAN=$(python3 hitung_kompleks.py)
    ```

4. **Terminologi Kunci:**
    - **`curl`:** Alat baris perintah untuk mentransfer data dengan URL, esensial untuk berinteraksi dengan API web.
    - **`jq`:** Prosesor JSON baris perintah yang sangat kuat.
    - **API (Application Programming Interface):** Antarmuka yang memungkinkan berbagai program perangkat lunak berkomunikasi satu sama lain.
5. **Daftar Isi:**
    - Berinteraksi dengan Web API menggunakan `curl` atau `wget`
    - Mem-parsing dan Memanipulasi JSON dengan `jq`
    - Memproses CSV dengan `awk` atau `csvkit`
    - Memanggil skrip Python/Perl/Ruby dari Bash dan menangkap hasilnya
    - Studi Kasus: Skrip yang mengambil data cuaca dari API dan menampilkannya
6. **Sumber Referensi:**
    - [jq Manual](https://stedolan.github.io/jq/manual/)
    - [Everything curl](https://everything.curl.dev/)

---

### **Sumber Daya Komunitas & Validasi Keahlian**

- **Komunitas:**
  - **Stack Overflow:** Tag `[bash]`, `[shell]`, dan `[shell-script]` sangat aktif.
  - **Reddit:** Subreddit r/bash, r/commandline, dan r/linux.
  - **Freenode/Libera.Chat IRC:** Kanal `#bash`.
- **Sertifikasi & Validasi Keahlian:**
  - Meskipun tidak ada sertifikasi khusus "Bash", keahlian shell scripting adalah komponen inti dari sertifikasi Linux yang dihormati:
    1. **CompTIA Linux+:** Memvalidasi keterampilan dasar hingga menengah.
    2. **LPIC-1 (Linux Professional Institute):** Setara dengan Linux+.
    3. **RHCSA (Red Hat Certified System Administrator):** Sertifikasi yang sangat dihormati yang menuntut kemahiran shell scripting tingkat tinggi untuk otomasi dan administrasi.
  - Portofolio di GitHub yang berisi skrip yang bersih, terdokumentasi dengan baik, dan aman adalah bukti keahlian yang sangat kuat.

### **Hasil Pembelajaran (Learning Outcomes)**

Setelah menyelesaikan kurikulum ini, Anda akan mampu:

1. **Menjelaskan dan menerapkan** filosofi Unix dalam pemecahan masalah sehari-hari.
2. **Menguasai baris perintah Linux/Unix**, termasuk manipulasi file, proses, dan aliran data.
3. **Menulis skrip Bash yang terstruktur, efisien, dan mudah dibaca** menggunakan variabel, kondisional, perulangan, dan fungsi.
4. **Memproses file teks dan data terstruktur** (seperti CSV dan JSON) secara efektif dari baris perintah.
5. **Mengembangkan skrip yang aman dan andal** untuk lingkungan produksi, dengan penanganan kesalahan yang kuat dan pertahanan terhadap kerentanan umum.
6. **Mengotomatiskan tugas-tugas administrasi sistem yang kompleks**, seperti backup, monitoring, dan manajemen pengguna.
7. **Mengintegrasikan skrip shell dengan alat lain**, API web, dan bahasa pemrograman yang berbeda untuk membangun alur kerja yang kompleks.

---

Kurikulum ini dirancang untuk membawa Anda dari pemula yang belum pernah menulis skrip, hingga menjadi seorang ahli yang mampu mengotomatiskan tugas-tugas kompleks, mengelola sistem, dan menulis skrip yang aman dan andal untuk lingkungan enterprise, kurikulum ini disajikan dalam bahasa Indonesia yang formal, terstruktur, dan mudah diakses, dengan penekanan pada pemahaman filosofi di balik setiap konsep; sebuah pendekatan yang sangat relevan dengan minat pada rekayasa sistem dan keamanan siber.

---

### **Audit Kurikulum**

**Beberapa Observasi dan Rekomendasi Penambahan/Perbaikan (Jika Perlu):**

- **Prasyarat:** Sudah jelas.
- **Alat Esensial:** Daftar alat sudah memadai.
- **Estimasi Waktu & Level:** Realistis.

-----

**Fase 1: Fondasi – Berinteraksi dengan Shell (Tingkat Pemula)**

- **Modul 1.1: Filosofi dan Lingkungan Shell:**
  - **Gambaran Struktur:** Sangat bagus, mencakup filosofi Unix yang krusial.
  - **Rekomendasi:** Tidak ada rekomendasi penambahan atau perbaikan signifikan. Ini adalah fondasi yang kuat.
- **Modul 1.2: Perintah Fundamental dan I/O Redirection:**
  - **Gambaran Struktur:** Inti dari interaksi shell.
  - **Rekomendasi:** Visualisasi diagram alur untuk I/O _redirection_ dan _pipes_ akan sangat membantu di sini, seperti yang sudah Anda indikasikan.
- **Modul 1.3: Skrip Pertama Anda, Variabel, dan Ekspansi:**
  - **Gambaran Struktur:** Transisi yang bagus dari perintah tunggal ke skrip.
  - **Rekomendasi:** Penjelasan lebih lanjut tentang _exit status_ dan penggunaan `echo $?` secara lebih eksplisit sebagai bagian dari _debugging_ awal bisa ditambahkan di modul ini atau di awal Fase 2.

-----

**Fase 2: Menengah – Struktur, Kontrol, dan Manipulasi Teks (Tingkat Menengah)**

- **Modul 2.1: Struktur Kondisional:**
  - **Gambaran Struktur:** Standar pemrograman dasar.
  - **Rekomendasi:** Sudah mencakup perbandingan penting (`[[...]]` vs `[...]`).
- **Modul 2.2: Perulangan (Loops):**
  - **Gambaran Struktur:** Esensial untuk otomasi.
  - **Rekomendasi:** Penjelasan mendalam tentang _globbing_ (perluasan _wildcard_) dan bagaimana hal itu berinteraksi dengan perulangan `for` akan sangat berguna.
- **Modul 2.3: Fungsi dan Cakupan (Scoping):**
  - **Gambaran Struktur:** Penting untuk modularitas.
  - **Rekomendasi:** Konsep _sourcing scripts_ dan penggunaannya sebagai _library_ fungsi disebutkan, ini bagus dan perlu didalami.

-----

**Fase 3: Mahir – Skrip yang Andal dan Profesional (Tingkat Mahir)**

- **Modul 3.1: Penanganan Kesalahan (Error Handling):**
  - **Gambaran Struktur:** Sangat krusial untuk skrip _production-grade_.
  - **Rekomendasi:** Penjelasan tentang `exit` dan penggunaan _exit codes_ yang konsisten akan memperkuat modul ini.
- **Modul 3.2: Mem-parsing Argumen Baris Perintah:**
  - **Gambaran Struktur:** Membuat skrip lebih fleksibel.
  - **Rekomendasi:** Membedakan kapan harus menggunakan argumen posisi sederhana vs. `getopts` akan bermanfaat.

-----

**Fase 4: Pakar – Aplikasi Skala Enterprise dan Keamanan (Tingkat Pakar)**

- **Modul 4.1: Otomatisasi Tugas Administrasi Sistem:**
  - **Gambaran Struktur:** Aplikasi nyata dari semua yang telah dipelajari.
  - **Rekomendasi:** Studi kasus yang spesifik akan sangat membantu.
- **Modul 4.2: Pertimbangan Keamanan dalam Shell Scripting:**
  - **Gambaran Struktur:** Sangat relevan dengan minat Anda pada _cybersecurity_.
  - **Rekomendasi:** Penekanan pada `shellcheck` sebagai alat _preventive_ sudah ada, ini harus ditekankan secara maksimal.
- **Modul 4.3: Interoperabilitas dengan Alat dan Bahasa Lain:**
  - **Gambaran Struktur:** Shell sebagai "lem" sistem.
  - **Rekomendasi:** Studi kasus dengan `jq` dan `curl` sangat relevan.

-----

**Sumber Daya Komunitas & Validasi Keahlian:**

- **Gambaran Struktur:** Sangat bagus, memberikan arah yang jelas untuk pengembangan karir.
- **Rekomendasi:** Tidak ada rekomendasi.

-----

**Hasil Pembelajaran (Learning Outcomes):**

- **Gambaran Struktur:** Jelas dan terukur.
- **Rekomendasi:** Tidak ada rekomendasi.

-----

**Kesimpulan Audit:**

Kurikulum ini adalah fondasi yang sangat kokoh. Penambahan yang saya rekomendasikan bersifat melengkapi dan mendalamkan, bukan korektif terhadap kesalahan fundamental. Kita dapat melanjutkan dengan pendalaman setiap bagian.

- **[Home][domain-spesifik]**

[domain-spesifik]: ../../README.md
[0]:../../../../CLI/terminal/README.md
[1]:../bash/bagian-1/README.md
[2]:../bash/bagian-2/README.md
[3]:../bash/bagian-3/README.md
[4]:../bash/bagian-4/README.md
