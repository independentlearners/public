# Bash-Scripting

<details>
  <summary>📃 Daftar Kurikulum</summary>

- **[Belajar CLI/Terminal Baris Perintah][0]**
- **[71 Istilah dalam scripting][5]**
- **[Books Scripting][6]**

# **Kurikulum Komprehensif: Menguasai Shell Scripting (Bash)**

Kurikulum ini adalah peta jalan untuk menguasai inti dari seni otomasi di lingkungan berbasis Unix/Linux. Shell scripting bukan hanya tentang menulis kode, tetapi tentang memahami dan memanfaatkan kekuatan baris perintah secara maksimal.

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

### **[Fase 1: Fondasi – Berinteraksi dengan Shell (Tingkat Pemula)][bag1]**

**Tujuan Fase:** Membangun pemahaman dari nol tentang lingkungan shell, navigasi sistem berkas, aliran data, pembuatan skrip Bash, variabel, ekspansi, dan cara menjalankan skrip secara benar. Fokusnya bukan sekadar menghafal perintah, melainkan memahami apa yang dilakukan shell sebelum dan selama sebuah perintah dijalankan.

**Prasyarat:** Literasi komputer dasar. Tidak diperlukan pengalaman pemrograman sebelumnya.

**Lingkungan belajar:** Bash pada Linux (direkomendasikan), macOS, WSL2, atau lingkungan lain yang menyediakan Bash. Pengguna Arch Linux yang memakai Zsh sebagai shell utama dapat mempelajari Bash di container `systemd-nspawn` agar latihan tidak mencampur perilaku Zsh dan Bash.

---

#### **Modul 1.1: Fondasi, Filosofi, dan Lingkungan Shell**

1. **Deskripsi Konkret:** Memahami komponen yang terlibat saat perintah dijalankan, mengenali Bash yang benar-benar aktif, menggunakan terminal secara efektif, dan menyiapkan lingkungan latihan yang sesuai.
2. **Konsep Dasar dan Filosofi:**
    - **Sejarah singkat Unix dan shell:** peran shell dalam sistem Unix-like dan perkembangan shell utama.
    - **Terminal, konsol, shell, kernel, dan CLI:** definisi, perbedaan, serta hubungan antar-komponen.
    - **Alur eksekusi perintah:** input dari terminal, parsing dan ekspansi oleh shell, pencarian perintah, eksekusi proses, lalu keluaran ke terminal atau stream lain.
    - **Filosofi Unix:** program melakukan satu hal dengan baik; program dapat bekerja bersama; aliran teks sebagai antarmuka; kesederhanaan dan modularitas.
    - **Mengenali shell aktif:** membedakan `$SHELL`, `$0`, `$$`, `ps`, `BASH_VERSION`, dan `ZSH_VERSION`; `$SHELL` umumnya menunjukkan login shell, bukan selalu shell aktif.
    - **POSIX, Bash, dan Zsh:** mengenali standar portabilitas dan membedakan sintaks POSIX dari ekstensi Bash.
    - **Jenis shell dan file startup:** login, interactive non-login, dan non-interactive; peran `/etc/profile`, `~/.bash_profile`, `~/.bash_login`, `~/.profile`, serta `~/.bashrc`. Bash tidak membaca semua file profil pengguna sekaligus; ada aturan prioritas.
3. **Sintaks Dasar/Contoh Implementasi Inti:**

    ```bash
    # Periksa shell yang ditetapkan sebagai login shell
    printf 'Login shell: %s\n' "$SHELL"

    # Periksa shell/proses yang sedang berjalan
    printf 'Nama shell ($0): %s\n' "$0"
    ps -o comm= -p "$$"

    # BASH_VERSION tersedia ketika shell aktif adalah Bash
    printf 'Bash version: %s\n' "${BASH_VERSION- bukan Bash}"

    # Cari perintah tanpa mengandalkan utilitas non-POSIX `which`
    command -v bash
    type cd
    type ls

    # Navigasi dasar
    pwd
    ls -lah
    cd ..
    cd -
    ```

4. **Terminologi Kunci:**
    - **Terminal emulator:** aplikasi yang menampilkan antarmuka teks.
    - **Shell:** program yang membaca dan menafsirkan perintah.
    - **Kernel:** inti sistem operasi yang mengelola proses, memori, dan perangkat.
    - **POSIX:** standar antarmuka dan perilaku sistem yang membantu portabilitas.
    - **Builtin:** perintah yang dijalankan sebagai bagian dari shell, seperti `cd`.
    - **Path:** alamat file atau direktori; berbeda dari variabel lingkungan `PATH`.
5. **Daftar Isi:**
    - Sejarah singkat Unix dan shell; terminal, konsol, shell, kernel, dan CLI.
    - Cara shell mem-parsing, memperluas, mencari, dan menjalankan perintah.
    - Filosofi Unix: program kecil, komposisi, aliran teks, kesederhanaan, dan modularitas.
    - Mengenali shell aktif dan membedakan `$SHELL` dari `$0`.
    - Navigasi sistem berkas: `pwd`, `ls`, `cd`, path absolut/relatif, `.`, `..`, `~`, dan `-`.
    - Membaca output `ls -l` dan mengenali tipe serta izin file.
    - Bantuan: `man`, `help`, `info`, `apropos`, `whatis`, `--help`, dan `tldr` (opsional).
    - Jenis shell dan file startup Bash.
    - POSIX vs Bash vs Zsh; builtin vs perintah eksternal.
    - Menyiapkan lingkungan latihan terisolasi dengan `systemd-nspawn` (opsional, direkomendasikan untuk pengguna Arch + Zsh).
6. **Sumber dan Materi Pendukung:**
    - [Bash Reference Manual](https://www.gnu.org/software/bash/manual/bash.html)
    - [The Art of Unix Programming](http://www.catb.org/~esr/writings/taoup/html/)
    - [The Open Group Base Specifications, Issue 8](https://pubs.opengroup.org/onlinepubs/9799919799/)
    - Dokumen `00-lingkungan-isolasi.md`: setup container Arch minimal, workflow host/container, bind mount, backup/restore, troubleshooting, dan pembersihan.

---

#### **Modul 1.2: Perintah Fundamental, Standard Streams, dan I/O Redirection**

1. **Deskripsi Konkret:** Memahami bagaimana program menerima input, menghasilkan output, melaporkan kesalahan, dan mengalirkan data ke program lain atau file.
2. **Konsep Dasar dan Filosofi:**
    - Setiap proses umumnya memiliki `stdin` (file descriptor 0), `stdout` (fd 1), dan `stderr` (fd 2).
    - Redirection mengubah tujuan atau sumber stream. Urutan redirection penting karena shell memprosesnya dari kiri ke kanan.
    - Pipe (`|`) menghubungkan `stdout` perintah kiri ke `stdin` perintah kanan; `stderr` tidak ikut dialirkan kecuali diarahkan secara eksplisit.
    - `>` menimpa file tujuan, sedangkan `>>` menambahkan ke akhir file. Redirection dapat mengosongkan file, sehingga perlu perhatian pada data penting.
    - `<>` membuka file untuk baca-tulis tanpa otomatis mengosongkan isinya; posisi baca/tulis dan file descriptor harus dipahami agar data tidak tertimpa.
    - `IFS= read -r` cocok untuk membaca baris teks, tetapi pemisahan berdasarkan koma saja bukan parser CSV lengkap.
3. **Sintaks Dasar/Contoh Implementasi Inti:**

    ```bash
    # Pisahkan output normal dan pesan error
    ls -la /etc > daftar-etc.txt 2> kesalahan-etc.txt

    # Gabungkan stdout dan stderr ke file yang sama
    perintah_yang_diuji > hasil.log 2>&1

    # Baca isi file melalui stdin
    wc -l < daftar-etc.txt

    # Hubungkan beberapa perintah melalui pipe
    grep 'ERROR' aplikasi.log | wc -l

    # Baca file baris demi baris tanpa menghapus backslash
    while IFS= read -r baris; do
        printf 'Baris: %s\n' "$baris"
    done < daftar-etc.txt

    # Simpan output sekaligus tampilkan di terminal
    ls -lah | tee daftar-file.txt
    ```

4. **Terminologi Kunci:**
    - **File descriptor (FD):** bilangan yang merujuk pada stream terbuka milik proses.
    - **Redirection:** pengalihan input/output.
    - **Pipe:** saluran yang meneruskan byte dari satu proses ke proses lain.
    - **Here-document (`<<`) dan here-string (`<<<`):** cara memberi input langsung; here-string adalah fitur Bash, bukan POSIX.
    - **`tee`:** menyalin input ke output standar dan file.
    - **Exit status:** angka hasil perintah; secara konvensi `0` berarti berhasil dan nilai nonzero menunjukkan kondisi lain/kegagalan.
5. **Daftar Isi:**
    - `stdin`, `stdout`, `stderr`, dan FD 0, 1, 2.
    - Output redirection: `>`, `>>`, `>|`, `&>`, `&>>`.
    - Input redirection: `<`, `<>`, here-document `<<`, `<<-`, dan here-string `<<<`.
    - Mengalihkan error: `2>`, `2>>`, `2>&1`, `1>&2`, dan `/dev/null`.
    - Mengapa `command > file 2>&1` berbeda dari `command 2>&1 > file`.
    - File descriptor tambahan dengan `exec`, termasuk membuka dan menutup FD.
    - Pipe `|`, Bash `|&`, dan status pipeline.
    - Perintah teks: `cat`, `grep`, `head`, `tail`, `wc`, `sort`, `uniq`, `cut`, `tr`, `tee`, `xargs`, `sed`, dan `awk`.
    - Penggunaan `find` dan `xargs` untuk nama file yang mengandung spasi atau newline, termasuk `-print0`/`-0` jika tersedia.
    - Batasan pemrosesan teks: CSV bukan selalu aman diproses dengan pemisahan sederhana.
6. **Sumber Referensi:**
    - [Bash Reference Manual — Redirections](https://www.gnu.org/software/bash/manual/html_node/Redirections.html)
    - [GNU Coreutils Manual](https://www.gnu.org/software/coreutils/manual/coreutils.html)
    - [The Open Group — Shell Command Language](https://pubs.opengroup.org/onlinepubs/9799919799/utilities/V3_chap02.html)

---

#### **Modul 1.3: Skrip Pertama, Variabel, PATH, dan Ekspansi**

1. **Deskripsi Konkret:** Menulis dan menjalankan skrip Bash, memahami cara sistem menemukan interpreter dan executable, menyimpan serta meneruskan nilai melalui variabel, menerima input dan argumen, dan memahami ekspansi shell sebelum perintah dijalankan.
2. **Konsep Dasar dan Filosofi:**
    - **Skrip dan shebang:** `#!/usr/bin/env bash` memilih interpreter; `env` mencari `bash` melalui `PATH`.
    - **Encoding dan line ending:** simpan skrip sebagai UTF-8 tanpa BOM dan gunakan LF. BOM (`EF BB BF`) di awal file dapat mengganggu pengenalan shebang pada lingkungan tertentu.
    - **Path file vs `PATH`:** path file menunjukkan lokasi file; `PATH` adalah daftar direktori yang dipisahkan oleh `:` untuk pencarian perintah tanpa path eksplisit.
    - **Variabel shell dan lingkungan:** variabel biasa berlaku di shell saat ini; `export` membuat variabel tersedia bagi proses anak. Variabel khusus Bash dan parameter posisi memiliki aturan tersendiri.
    - **Quoting dan ekspansi:** kutip ganda mengizinkan sebagian besar ekspansi tetapi mencegah word splitting dan pathname expansion pada hasil yang dikutip; kutip tunggal mempertahankan teks literal. Hasil ekspansi parameter tidak otomatis diparsing ulang sebagai sintaks shell.
    - **Input, argumen, dan status:** `read` untuk input interaktif, `$1`, `$2`, dan seterusnya untuk argumen, serta `$?` untuk status perintah terakhir.
    - **Keamanan dasar:** kutip ekspansi variabel saat nilainya harus menjadi satu argumen; gunakan `--` bila utilitas mendukungnya; jangan gunakan `eval` untuk input yang tidak tepercaya.
3. **Sintaks Dasar/Contoh Implementasi Inti:**

    ```bash
    #!/usr/bin/env bash

    NAMA="Andi"
    printf 'Halo, %s\n' "$NAMA"

    LINGKUNGAN="lab"
    export LINGKUNGAN
    bash -c 'printf "Lingkungan anak: %s\n" "$LINGKUNGAN"'

    # Lihat PATH dan temukan executable
    printf '%s\n' "$PATH"
    command -v bash
    type -a bash

    # Parameter posisi dan jumlah argumen
    printf 'Nama skrip: %s\n' "$0"
    printf 'Jumlah argumen: %s\n' "$#"
    printf 'Argumen pertama: %s\n' "${1-}"

    read -r -p 'Masukkan nama: ' nama_input
    printf 'Nama: %s\n' "$nama_input"

    DIREKTORI_SAAT_INI=$(pwd)
    JUMLAH=$((2 + 3))
    printf 'Lokasi: %s; hasil: %s\n' "$DIREKTORI_SAAT_INI" "$JUMLAH"
    ```

4. **Terminologi Kunci:**
    - **Shebang:** penanda interpreter pada awal skrip.
    - **BOM (Byte Order Mark):** penanda encoding yang tidak diperlukan untuk skrip Bash UTF-8 dan sebaiknya dihindari.
    - **Variabel shell:** nama yang menyimpan nilai dalam lingkungan shell.
    - **Variabel lingkungan:** variabel yang diekspor dan diwariskan proses anak.
    - **`PATH`:** daftar direktori pencarian executable; urutan direktori memengaruhi perintah yang ditemukan lebih dahulu.
    - **Parameter posisi:** `$0`, `$1` ...; `$#` menghitung argumen dan `"$@"` mempertahankan setiap argumen sebagai elemen terpisah.
    - **Parameter khusus:** misalnya `$?` (status terakhir), `$$` (PID shell), `$!` (PID job latar belakang terakhir), dan `$-` (opsi shell aktif).
    - **Ekspansi:** brace, tilde, parameter, command substitution, arithmetic, word splitting, pathname expansion, dan quote removal.
    - **Command injection:** terjadi ketika data tak tepercaya diperlakukan sebagai kode oleh parser shell, misalnya melalui `eval` atau `bash -c` dengan string yang dibangun secara tidak aman; ini berbeda dari word splitting atau globbing akibat ekspansi tanpa kutip.
5. **Daftar Isi:**
    - Struktur skrip, komentar, shebang, serta perbedaan `bash script.sh` dan `./script.sh`.
    - Izin file dan `chmod`; path relatif/absolut; mengapa skrip di direktori saat ini biasanya dipanggil dengan `./nama-skrip`.
    - Diagnosis eksekusi: shebang salah, interpreter tidak ada, izin, CRLF, BOM, dan encoding.
    - Pemeriksaan BOM dan line ending dengan `file`, `od`, atau `hexdump`; UTF-8 tanpa BOM dan LF.
    - Definisi, pembacaan, penghapusan, `readonly`, dan nilai default variabel.
    - Variabel lokal dalam fungsi sebagai pengantar; detail fungsi dan scoping lanjutan diperdalam pada fase berikutnya.
    - Contoh sederhana untuk setiap variabel dalam daftar materi: variabel lingkungan `HOME`, `USER`, `LOGNAME`, `SHELL`, `PWD`, `OLDPWD`, `PATH`, `LANG`, `LANGUAGE`, `LC_ALL`, `TERM`, `EDITOR`, `VISUAL`, `TMPDIR`, `XDG_CONFIG_HOME`, dan `XDG_STATE_HOME` (jika tersedia); serta variabel/parameter Bash `BASH_VERSION`, `BASH`, `BASHPID`, `BASH_SOURCE`, `BASH_LINENO`, `FUNCNAME`, `LINENO`, `RANDOM`, `SECONDS`, `EPOCHSECONDS` (jika didukung), `IFS`, `PS1`, `PS2`, `PS4`, `OPTIND`, `OPTARG`, `PIPESTATUS`, `BASHOPTS`, dan `SHELLOPTS`, dengan catatan konteks ketersediaannya.
    - `PATH` secara konkret: menampilkan dan memisahkan entri; membandingkan `command -v`, `type -a`, dan path absolut; menambahkan direktori sementara; menempatkan direktori di depan atau belakang; menghindari entri kosong yang dapat berarti direktori saat ini; memahami prioritas executable; dan mengatur perubahan permanen pada file startup yang tepat.
    - Parameter posisi `$0`, `$1` ...; `$#`, `"$@"`, `"$*"`, dan `shift`.
    - Input interaktif dengan `read`, `-r`, prompt, dan pemeriksaan input.
    - Exit status: `$?`, `exit`, status pipeline, serta pengantar `set -e`, `set -u`, dan `pipefail` beserta batasannya.
    - Urutan ekspansi Bash dan efek quoting; brace expansion adalah ekstensi Bash, bukan POSIX.
    - Perbedaan `echo` dan `printf`, dengan `printf` sebagai pilihan yang lebih dapat diprediksi untuk output skrip.
    - Keamanan dasar: quoting, opsi yang diawali `-`, nama file, `--`, `eval`, dan mengapa titik koma di dalam nilai variabel tidak otomatis dieksekusi sebagai sintaks shell.
    - Latihan: skrip sapa, menerima argumen, memeriksa variabel, menelusuri `PATH`, dan mendiagnosis masalah shebang/BOM.
6. **Sumber dan Materi Pendukung:**
    - [Bash Reference Manual](https://www.gnu.org/software/bash/manual/bash.html)
    - [ShellCheck](https://www.shellcheck.net/)
    - [Greg's Wiki — BashFAQ](https://mywiki.wooledge.org/BashFAQ)
    - Dokumen `bom.md`: BOM UTF-8 (`EF BB BF`), shebang, UTF-8 tanpa BOM, LF, dan pemeriksaan byte.
    - Materi lengkap Fase 1 pada `bagian-1/README.md` harus mengikuti cakupan di atas tanpa menghapus topik yang telah tercantum.

**Kriteria penyelesaian Fase 1:** Pelajar dapat menjelaskan alur dasar perintah, menavigasi sistem berkas, menemukan bantuan, membedakan shell dan POSIX, mengarahkan stream, menyusun pipeline teks, membuat dan menjalankan skrip Bash, menjelaskan `PATH` dan prioritas pencarian perintah, menggunakan variabel dan parameter, serta mendiagnosis masalah umum seperti quoting, izin eksekusi, BOM, dan line ending.

---

### **[Fase 2: Menengah – Struktur, Kontrol, dan Manipulasi Teks (Tingkat Menengah)][bag2]**

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

### **[Fase 3: Mahir – Skrip yang Andal dan Profesional (Tingkat Mahir)][bag3]**

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

### **[Fase 4: Pakar – Aplikasi Skala Enterprise dan Keamanan (Tingkat Pakar)][bag4]**

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

</details>

<details>
  <summary>📃 Daftar Sumber</summary>

# Tabel sumber dokumentasi & tooling (online → offline → CLI)

**Tabel komprehensif** (online → offline → CLI) untuk seluruh sumber dokumentasi Bash dan tooling pendukung yang relevan 

> Catatan: difokuskan pada sumber resmi dan mirror terpercaya (GNU, The Open Group, TLDP, man7/man.cx, ShellCheck, dll.). Untuk perintah instalasi terdapat contoh untuk **Arch Linux**  dan juga alternatif umum (Debian/Ubuntu). Semua link sumber tercantum sebagai sitasi pada baris terkait. ([GNU][1])


| Kategori                                |                                                                                                     Resource (judul) | Online (URL / apa cari)                                                                                                                 | Offline / file yang bisa disimpan                                                                                                                                                                   | Perintah CLI & instalasi (contoh Arch / umum)                                                                                                  | Kenapa penting / catatan                                                                                                  |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------: | --------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| **Dokumen resmi — Bash**                |                                                                          GNU **Bash Reference Manual** (`info bash`) | Manual resmi GNU Bash (halaman web GNU). ([GNU][1])                                                                                     | Bisa diakses offline lewat `info` setelah paket doc terpasang; PDF/HTML mirror tersedia. (unduh `https://www.gnu.org/s/bash/manual/bash.html` atau mirror PDF). ([GNU][1])                          | Baca: `info bash` atau `man bash` (ringkasan). <br>Install docs (Arch): `sudo pacman -S man-db man-pages` + `sudo mandb`. ([archlinux.org][2]) | **Sumber otoritatif** untuk behaviour Bash, expansions, quoting, job control. Gunakan sebagai referensi utama. ([GNU][1]) |
| **Man page (ringkasan cepat)**          |                                                      `man bash` — man-pages / man7 / man.cx mirrors. ([man7.org][3]) | Man page lokal (man-db + man-pages) — tersedia offline setelah instal. Juga mirror HTML (man7.org / man.cx). ([man7.org][3])            | Tampilkan cepat: `man bash` <br>Search keyword: `man -k <term>` / `apropos <term>` <br>Build cache: `sudo mandb`. ([man.archlinux.org][4])                                                          | Man page ideal untuk **SYNOPSIS**, opsi CLI, contoh cepat. Gunakan untuk lookup cepat. ([man7.org][3])                                         |                                                                                                                           |
| **Tutorial & praktik**                  |                                            **Advanced Bash-Scripting Guide** (TLDP) — Mendel Cooper. ([tldp.org][5]) | Online HTML + PDF (`abs-guide.pdf`) — simpan untuk referensi offline. ([tldp.org][6])                                                   | Unduh: `wget https://tldp.org/LDP/abs/abs-guide.pdf` (atau mirror). <br>Praktik: copy/snippet, jalankan di container.                                                                               | Panduan praktis, contoh pola scripting, banyak contoh nyata (berguna untuk belajar pola skrip). ([tldp.org][5])                                |                                                                                                                           |
| **Standar / Portabilitas**              |                             **POSIX / The Open Group** — Shell Command Language (sh spec). ([pubs.opengroup.org][7]) | HTML resmi dari The Open Group — bisa disimpan offline (HTML/PDF). ([pubs.opengroup.org][7])                                            | Baca: `https://pubs.opengroup.org/onlinepubs/` <br>Gunakan untuk cek fitur POSIX-kompatibel.                                                                                                        | Untuk portabilitas ( `/bin/sh` ), tentukan fitur yang safe dipakai. Penting jika target script harus portable. ([pubs.opengroup.org][7])       |                                                                                                                           |
| **Linter & static analysis**            |                                                                    **ShellCheck** (web + CLI). ([shellcheck.net][8]) | Web UI: shellcheck.net (paste & test). <br>Binary/packaged untuk offline: paket distro atau `shellcheck-bin` AUR. ([shellcheck.net][8]) | Install Arch: `sudo pacman -S shellcheck` (paket `extra`). <br>Debian/Ubuntu: `sudo apt install shellcheck`. <br>Lint: `shellcheck script.sh`. ([archlinux.org][9])                                 | Wajib pakai saat menulis/men-review skrip: temukan quoting, word-splitting, substitution bug. ([shellcheck.net][8])                            |                                                                                                                           |
| **Coreutils & utilitas pendukung**      |                      **GNU Coreutils manual** (grep/sed/awk/find ditunjuk melalui coreutils / gnu docs). ([GNU][10]) | Man pages lokal (`man grep`, `man sed`, `man awk`) — unduh paket `man-pages` & `coreutils`. ([GNU][10])                                 | Contoh: `man grep`, `man sed`, `man awk`, `man find` <br>Install coreutils (biasanya default): `sudo pacman -S coreutils` (umum sudah ada). ([GNU][10])                                             | Sering digunakan di skrip — pahami opsi utama (e.g. `-r`, `-P`, `-F`, `-E` untuk grep). ([GNU][10])                                            |                                                                                                                           |
| **Online aggregator / browser**         |                               **DevDocs** — webapp (offline-capable), cepat untuk lookup banyak doc. ([DevDocs][11]) | DevDocs mendukung mode offline (download docsets) → simpan di browser / gunakan app. ([DevDocs][11])                                    | Akses: `https://devdocs.io/` → Preferences → Download (offline). <br>Alternatif desktop: `devdocs-desktop` atau `DevDocs` electron build. ([DevDocs][11])                                           | Baik untuk referensi cepat multi-language; bisa digabung dengan Zeal/DevDocs offline. ([DevDocs][11])                                          |                                                                                                                           |
| **Offline doc browser (desktop)**       |                                           **Zeal** (Linux/Windows) / **Dash** (macOS) — docset offline. ([Zeal][12]) | Install Zeal → download docsets termasuk Bash, coreutils, POSIX, TLDP jika tersedia. ([Zeal][13])                                       | Install (Arch): `sudo pacman -S zeal` (atau unduh dari zealdocs.org). <br>Setelah terpasang: Tools → Docsets → Download. ([Zeal][12])                                                               | Berguna untuk browsing offline dengan UI cepat, cocok jika sering berpindah topik. ([Zeal][12])                                                |                                                                                                                           |
| **Man mirrors / HTML**                  |                          **man7.org** / **man.cx** / **man.archlinux.org** — mirror manpage lengkap. ([man7.org][3]) | Simpan halaman HTML atau gunakan `wget -r` untuk mirror topik tertentu (hati-hati bandwith). ([man7.org][3])                            | Contoh: buka `https://man7.org/linux/man-pages/man1/bash.1.html` atau `https://man.cx/bash(1)` untuk referensi cepat. ([man7.org][3])                                                               | Mirror man berguna jika man lokal tidak terpasang; juga bahan referensi cross-distro. ([man.archlinux.org][14])                                |                                                                                                                           |
| **Sumber kode (bila ingin modifikasi)** |                       **Bash source** — repository resmi (Savannah / GNU) + beberapa mirror GitHub. ([Savannah][15]) | Clone repo: `git clone git://git.sv.gnu.org/bash.git` atau mirror GitHub; simpan lokal untuk baca kode. ([Savannah][15])                | `git clone git://git.savannah.gnu.org/bash.git` (atau `git clone https://git.savannah.gnu.org/git/bash.git`) <br>Build: `./configure && make && sudo make install` (lihat README). ([Savannah][15]) | Hanya jika Anda ingin **memodifikasi/compile** Bash sendiri — butuh C toolchain, autoconf, readline, testing. ([Savannah][15])                 |                                                                                                                           |
| **Books & referensi cetak**             |                 *Bash Reference Manual* (printer-friendly / buku), buku tercetak + Google Books. ([Google Buku][16]) | Beli/unduh versi PDF/ebook; simpan pada koleksi pribadi.                                                                                | Unduh contoh PDF mirror: `wget <link-abs-guide.pdf>` atau simpan halaman.                                                                                                                           | Berguna untuk studi maraton offline dan pencetakan rujukan. ([tldp.org][6])                                                                    |                                                                                                                           |
| **Tutorial modern / articles**          | freeCodeCamp, DigitalOcean tutorials, blog teknik — bagus untuk pengantar & pattern modern. ([freecodecamp.org][17]) | Simpan artikel sebagai PDF / markdown untuk referensi pribadi.                                                                          | Cari & simpan: `wget <url>` atau `curl -o file.html <url>`.                                                                                                                                         | Praktis untuk start-to-finish tutorial (step-by-step). ([freecodecamp.org][17])                                                                |                                                                                                                           |
| **Utility bantu baca & search**         |                                       `rg` (ripgrep), `bat`, `less -R`, `fzf` — percepat navigasi dokumentasi lokal. | Instal via pacman: `sudo pacman -S ripgrep bat fzf`                                                                                     | `rg 'pattern' /usr/share/man -n` ; `bat file` ; `less -R file`                                                                                                                                      | Mempercepat pencarian contoh & highlight syntax saat membaca dokumen offline.                                                                  |                                                                                                                           |
| **Anki / flashcards (bahasa teknis)**   |                                                    buat deck sendiri (frasa dokumentatif, contoh `man` → terjemahan) | Ekspor impor `.apkg` untuk cadangan                                                                                                     | `anki` desktop atau `ankiconnect` plugin jika ingin automasi                                                                                                                                        | Sangat efektif untuk retention frasa dokumentatif.                                                                                             |                                                                                                                           |

---

# Petunjuk cepat (kata-per-kata) — perintah CLI penting & arti singkat

* `man bash` — buka manual ringkas Bash (SYNOPSIS / OPTIONS / EXAMPLES). ([man7.org][3])
* `info bash` — buka GNU Bash Reference Manual (node-based, lebih mendetail). ([GNU][1])
* `help <builtin>` — dokumentasi singkat untuk builtin Bash (contoh: `help read`).
* `bash -n script.sh` — syntax-check (baca tapi jangan eksekusi).
* `bash -x script.sh` atau `set -x` — tracing / debug: tampilkan perintah setelah substitusi.
* `shellcheck script.sh` — linter statis untuk menemukan bug & antipattern. ([shellcheck.net][8])
* `sudo pacman -S shellcheck man-db man-pages` — instal contoh di Arch. (lihat paket Arch). ([archlinux.org][9])

# Rekomendasi urutan pemakaian (praktis—hari pertama)

1. Pastikan `man`/`info` terpasang: `sudo pacman -S man-db man-pages` lalu `sudo mandb`. ([archlinux.org][2])
2. Buka `man bash` untuk overview; lalu `info bash` untuk bacaan mendalam. ([man7.org][3])
3. Unduh **Advanced Bash-Scripting Guide (PDF)** untuk latihan contoh: `wget https://tldp.org/LDP/abs/abs-guide.pdf`. ([tldp.org][6])
4. Pasang `shellcheck` dan jalankan `shellcheck` pada skrip contoh Anda. ([archlinux.org][9])
5. Jika sering offline, pasang **Zeal** dan download docsets Bash / coreutils / POSIX. ([Zeal][12])

# Sumber utama & bukti (sitasi ringkas)

* GNU Bash Reference Manual (official). ([GNU][1])
* `man` / man7.org / man.cx — mirrors man page. ([man7.org][3])
* Advanced Bash-Scripting Guide (TLDP) — HTML & PDF. ([tldp.org][5])
* POSIX / The Open Group (Shell Command Language). ([pubs.opengroup.org][7])
* ShellCheck (web + CLI linter). ([shellcheck.net][8])
* GNU Coreutils manual. ([GNU][10])
* DevDocs (multi-doc web aggregator, offline-capable) & Zeal offline doc browser. ([DevDocs][11])
* Bash source (Savannah / GNU git). ([Savannah][15])
* Arch package references (man-db, man-pages, shellcheck). ([archlinux.org][2])

---

[1]: https://www.gnu.org/s/bash/manual/bash.html "Bash Reference Manual"
[2]: https://archlinux.org/packages/core/x86_64/man-db "man-db 2.13.1-1 (x86_64)"
[3]: https://man7.org/linux/man-pages/man1/bash.1.html "bash(1) - Linux manual page"
[4]: https://man.archlinux.org/man/man.1.en "man(1) - Arch manual pages"
[5]: https://tldp.org/LDP/abs/html "Advanced Bash-Scripting Guide"
[6]: https://tldp.org/LDP/abs/abs-guide.pdf "Advanced Bash-Scripting Guide"
[7]: https://pubs.opengroup.org/onlinepubs/9799919799 "The Open Group Base Specifications Issue 8"
[8]: https://www.shellcheck.net "ShellCheck – shell script analysis tool"
[9]: https://archlinux.org/packages/extra/x86_64/shellcheck "shellcheck 0.11.0-71 (x86_64)"
[10]: https://www.gnu.org/s/coreutils/manual/coreutils.html "GNU Coreutils Manual"
[11]: https://devdocs.io "DevDocs API Documentation"
[12]: https://zealdocs.org "Zeal - Offline Documentation Browser"
[13]: https://zealdocs.org/download.html "Download"
[14]: https://man.archlinux.org "Arch manual pages - Arch Linux"
[15]: https://savannah.gnu.org/git/?group=bash "The GNU Bourne-Again SHell - Git Repositories [Savannah]"
[16]: https://books.google.com/books/about/Bash_Reference_Manual.html?id=fY2_rEP_pDYC "Bash Reference Manual"
[17]: https://www.freecodecamp.org/news/bash-scripting-tutorial-linux-shell-script-and-command-line-for-beginners "Bash Scripting Tutorial – Linux Shell Script and Command ..."

</details>

- **[Metode 7 Hari Belajar Bash][claude]** <span style="font-size: 11px; color: grey; margin-left: 24px;"><i>Nich Bash Scripting Khusus Konfigurasi Linux.</i></span>
- **[Home][domain-spesifik]**
- **[Others][others]** <span style="font-size: 11px; color: grey; margin-left: 24px;"><i>Mungkin bersifat Opsional.</i></span>
- **[ZSH][zsh]**
- **[SH][sh]**

[domain-spesifik]: ../../README.md
[0]: ./../../../CLI_TUI/perintah/README.md
[bag1]:../bash/bagian-1/README.md
[bag2]:../bash/bagian-2/README.md
[bag3]:../bash/bagian-3/README.md
[bag4]:../bash/bagian-4/README.md

<!-- [bag5]:../bash/bagian-5/README.md -->
<!-- [bag6]:../bash/nich/README.md -->
<!-- [bag7]: ./bashscripting/README.md -->
[claude]: ./claude/Kurikulum_Bash_Scripting_7_Hari.md
[others]: ./others/others.md
[zsh]: ./../zsh/zsh.md
[sh]: ./../sh/sh.md
