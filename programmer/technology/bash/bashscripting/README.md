# **[Kurikulum Masif "Mastery in Bash Scripting: From Zero to Enterprise Automation"][0]**

Kurikulum ini dirancang untuk membawa seseorang yang belum pernah membuka terminal (command line) hingga mampu membangun sistem otomasi infrastruktur yang kompleks.

-----

# 📜 Pengantar & Persiapan

**Estimasi Waktu Total:** 4 - 8 Bulan (tergantung intensitas belajar).
**Target Audiens:** Mulai dari non-IT, SysAdmin, Developer, hingga DevOps Engineer.

### Prasyarat & Alat Esensial

1.  **Sistem Operasi:** Linux (Ubuntu/Fedora), macOS, atau Windows dengan WSL2 (Windows Subsystem for Linux).
2.  **Terminal Emulator:** iTerm2 (Mac), Windows Terminal (Windows), atau default Terminal (Linux).
3.  **Text Editor:** VS Code (rekomendasi pemula) atau Vim/Nano (untuk yang ingin purist).
4.  **Mentalitas:** Keinginan untuk mengetik daripada mengklik.

-----

# [Phase 1: The Foundation – Berbicara dengan Kernel][1]

**Tingkat:** Pemula | **Estimasi Waktu:** 2 - 3 Minggu

Fase ini bukan tentang memprogram, melainkan tentang **navigasi** dan memahami bagaimana manusia berinteraksi dengan inti komputer tanpa antarmuka grafis (GUI).

### Modul 1.1: Anatomi Command Line Interface (CLI)

  * **Deskripsi Konkret:** Mempelajari cara membuka terminal, memahami struktur direktori (folder), dan menjalankan perintah dasar.
  * **Konsep Dasar & Filosofi:**
      * *Shell sebagai Penerjemah:* Komputer hanya mengerti biner. Shell (Bash) adalah penerjemah antara bahasa manusia (perintah teks) dan Kernel (otak OS).
      * *Filosofi Unix:* "Everything is a file." Hampir semua komponen di Linux, termasuk hardware, direpresentasikan sebagai file.
  * **Terminologi Kunci:**
      * **Shell:** Program yang menerima perintah teks dan meneruskannya ke sistem operasi.
      * **Bash (Bourne Again SHell):** Salah satu jenis Shell yang paling populer dan menjadi standar.
      * **Root:** Superuser atau administrator dengan akses penuh (berbahaya jika tidak hati-hati).
      * **Directory:** Istilah teknis untuk "folder".
  * **Daftar Isi:**
    1.  Navigasi File System (`cd`, `pwd`, `ls`).
    2.  Manipulasi File & Folder (`touch`, `mkdir`, `cp`, `mv`, `rm`).
    3.  Melihat isi file (`cat`, `less`, `head`, `tail`).
    4.  Manual Pages (`man`): Cara membaca buku manual digital.
  * **Sumber Referensi:**
      * [Linux Journey - Command Line](https://linuxjourney.com/lesson/the-shell)
      * [GNU Bash Manual](https://www.gnu.org/software/bash/manual/)
  * **Visualisasi:** Disarankan melihat diagram "Linux Directory Structure Tree" (Root `/` di atas, bercabang ke `/bin`, `/etc`, `/home`).

### Modul 1.2: Izin (Permissions) dan Lingkungan (Environment)

  * **Deskripsi Konkret:** Mengamankan file agar tidak sembarang orang bisa membacanya dan mengatur variabel lingkungan komputer.
  * **Konsep Dasar:** Linux adalah sistem *multi-user*. Keamanan dibangun di atas kepemilikan file (siapa yang boleh baca, tulis, atau eksekusi).
  * **Terminologi Kunci:**
      * **Chmod:** Perintah untuk mengubah mode izin file.
      * **Sudo:** "SuperUser DO". Menjalankan perintah dengan hak akses administrator sementara.
      * **PATH:** Variabel yang memberi tahu Shell di mana harus mencari program saat kita mengetik perintah.
  * **Daftar Isi:**
    1.  User & Groups (`chown`, `id`).
    2.  File Permissions (`rwx`, `chmod` angka vs simbol).
    3.  Environment Variables (`export`, `.bashrc`, `.profile`).
    4.  Alias: Membuat shortcut perintah sendiri.

-----

# [Phase 2: Core Scripting – Dari Pengguna menjadi Pemrogram][2]


**Tingkat:** Menengah | **Estimasi Waktu:** 4 - 6 Minggu

Di sini kita mulai menulis **Script**: sekumpulan perintah yang disimpan dalam file untuk dijalankan secara otomatis.

### Modul 2.1: Struktur Script & Variabel

  * **Deskripsi Konkret:** Membuat file `.sh` pertama, menjalankannya, dan menyimpan data dalam memori.
  * **Konsep Dasar:** Otomasi dimulai ketika kita berhenti mengetik perintah satu per satu dan mulai menyimpannya dalam urutan logis.
  * **Terminologi Kunci:**
      * **Shebang (`#!`):** Baris pertama dalam script (misal `#!/bin/bash`) yang memberi tahu sistem, "Tolong gunakan program Bash untuk menjalankan kode ini."
      * **Variable:** Wadah bernama untuk menyimpan data (teks atau angka) yang bisa berubah-ubah.
  * **Daftar Isi:**
    1.  The Shebang & Execution Permissions (`chmod +x`).
    2.  Variables (User defined vs System variables).
    3.  Command Substitution `$(command)`: Memasukkan hasil perintah ke dalam variabel.
    4.  Arithmetic Expansion `$((...))`: Melakukan matematika dasar.
  * **Visualisasi:** Diagram alur eksekusi script dari baris 1 ke bawah (Sequential execution).

### Modul 2.2: Logika Kontrol (Logic & Loops)

  * **Deskripsi Konkret:** Membuat script menjadi "cerdas" sehingga bisa mengambil keputusan (jika A maka B) dan melakukan tugas berulang.
  * **Konsep Dasar:** Komputer hebat dalam melakukan hal repetitif tanpa lelah. *Looping* (perulangan) adalah inti dari efisiensi.
  * **Terminologi Kunci:**
      * **Exit Code:** Status akhir sebuah perintah. `0` berarti sukses, angka lain berarti error.
      * **Conditional:** Pernyataan "Jika... Maka..." (`if/else`).
      * **Iteration:** Satu putaran dalam sebuah loop.
  * **Daftar Isi:**
    1.  Exit Status (`$?`) dan Operator Logika (`&&`, `||`).
    2.  Test Commands (`[ ]` vs `[[ ]]`).
    3.  Conditional Statements (`if`, `elif`, `else`, `case`).
    4.  Loops (`for`, `while`, `until`).
    5.  Break & Continue.
  * **Sumber Referensi:**
      * [Bash Guide for Beginners (TLDP) - Loops](https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_09_01.html)

-----

# [Phase 3: The Power of Pipes – Manipulasi Data][3]

**Tingkat:** Mahir | **Estimasi Waktu:** 4 - 6 Minggu

Ini adalah jantung dari kekuatan Linux/Unix. Memproses teks dalam jumlah besar dengan sangat cepat.

### Modul 3.1: I/O Redirection & Pipes

  * **Deskripsi Konkret:** Mengambil output dari satu program dan langsung menjadikannya input untuk program lain, serta menyimpan log ke file.
  * **Konsep Dasar & Filosofi:** *Unix Philosophy*: "Write programs that do one thing and do it well. Write programs to work together." Pipe (`|`) adalah lem yang menyatukan alat-alat kecil ini.
  * **Terminologi Kunci:**
      * **Stdin (0):** Input standar (biasanya keyboard).
      * **Stdout (1):** Output standar (layar terminal).
      * **Stderr (2):** Output khusus error.
      * **Pipe (`|`):** Saluran yang mengalirkan data dari proses kiri ke proses kanan.
  * **Daftar Isi:**
    1.  Standard Streams (0, 1, 2).
    2.  Redirection (`>`, `>>`, `2>`, `2>&1`).
    3.  Piping (`|`).
    4.  `/dev/null` (Black hole untuk membuang output yang tidak diinginkan).

### Modul 3.2: The Holy Trinity (Grep, Sed, Awk) & Regex

  * **Deskripsi Konkret:** Mencari teks, mengganti kata dalam ribuan file sekaligus, dan membuat laporan data tabular langsung di terminal.
  * **Terminologi Kunci:**
      * **Regex (Regular Expression):** Pola karakter untuk pencarian teks yang sangat canggih (misal: mencari pola email atau no HP).
      * **Stream Editor (Sed):** Mengedit teks secara otomatis saat teks tersebut "mengalir" melalui pipe.
  * **Daftar Isi:**
    1.  **Grep:** Pencarian pola teks (`grep -r`, `grep -v`).
    2.  **Regex Dasar:** Wildcards, Anchors (`^`, `$`), Character Classes.
    3.  **Sed:** Find and replace (`s/old/new/g`).
    4.  **Awk:** Pemrosesan data berbasis kolom/field (sangat powerful untuk log analysis).
  * **Sumber Referensi:**
      * [Grep, Sed, and Awk Tutorial](https://www.google.com/search?q=https://www.thegeekstuff.com/tag/awk/)

-----

# [Phase 4: Advanced Modular Scripting & System][4]

**Tingkat:** Expert | **Estimasi Waktu:** 4 - 5 Minggu

Membuat script yang robust, bisa menangani error, modular (fungsi), dan berinteraksi dengan jaringan.

### Modul 4.1: Fungsi, Array, & Modularitas

  * **Deskripsi Konkret:** Memecah script raksasa menjadi potongan kecil yang bisa digunakan ulang, dan menangani daftar data (array).
  * **Konsep Dasar:** *Don't Repeat Yourself (DRY)*. Jika Anda menulis kode yang sama dua kali, jadikan fungsi.
  * **Daftar Isi:**
    1.  Mendefinisikan Functions & Scope variable (`local` vs `global`).
    2.  Indexed Arrays & Associative Arrays (seperti Dictionary di Python).
    3.  Sourcing file lain (`source` atau `.`) untuk library script.
    4.  Argument Parsing (`getopts`) untuk membuat flag profesional (misal: `./script.sh -h -v`).

### Modul 4.2: Interoperabilitas & Jaringan

  * **Deskripsi Konkret:** Script Bash yang berbicara dengan internet, API, dan format data modern (JSON).
  * **Interoperabilitas:**
      * **cURL:** Untuk request HTTP (API calls).
      * **jq:** Tool wajib untuk memparsing JSON di terminal.
      * **SSH:** Mengontrol server jarak jauh lewat script.
  * **Daftar Isi:**
    1.  Transfer Data (`curl`, `wget`).
    2.  Parsing JSON dengan `jq`.
    3.  SSH Keys & Remote Command Execution.
    4.  Job Control (`bg`, `fg`, `jobs`) & `cron` (penjadwalan otomatis).

-----

# [Phase 5: Enterprise Automation & DevOps][5]


**Tingkat:** Enterprise/Architect | **Estimasi Waktu:** Terus menerus (Ongoing)

Penerapan Bash dalam skala industri, Cloud, dan CI/CD pipelines.

[Image of CI CD Pipeline Workflow]

### Modul 5.1: Defensive Coding & Debugging

  * **Deskripsi Konkret:** Membuat script yang "anti-gagal" dan aman untuk production.
  * **Konsep Dasar:** Asumsikan segala sesuatu akan gagal (file hilang, koneksi putus). Script harus bisa menangani kegagalan dengan anggun (*graceful degradation*).
  * **Terminologi Kunci:**
      * **Trap:** Menangkap sinyal sistem (misal saat user menekan Ctrl+C) untuk melakukan pembersihan sebelum script mati.
      * **Linter:** Alat pemeriksa kualitas kode otomatis.
  * **Daftar Isi:**
    1.  Bash Strict Mode (`set -euo pipefail`) - **Sangat Penting**.
    2.  Debugging Mode (`bash -x`).
    3.  Error Handling & Trap Signals.
    4.  Logging Best Practices (Timestamping logs).
  * **Alat Esensial:** `ShellCheck` (Wajib diinstall di VS Code untuk analisis statis).

### Modul 5.2: Cloud CLI & Container Automation

  * **Deskripsi Konkret:** Menggunakan Bash untuk mengontrol AWS/Google Cloud dan Docker. Bash adalah bahasa "perekat" di dunia Cloud.
  * **Daftar Isi:**
    1.  Wrapping Cloud CLI (AWS CLI / Azure CLI) dalam script.
    2.  Docker Automation: Scripting build & deploy process.
    3.  CI/CD Integration: Menulis langkah-langkah build di `GitLab CI` atau `GitHub Actions` menggunakan Bash.
    4.  Infrastructure as Code (pembungkus Terraform/Ansible).

-----

# 🎯 Ringkasan & Langkah Selanjutnya

### Hasil Pembelajaran (Learning Outcomes)

Setelah menyelesaikan kurikulum ini, Anda akan mampu:

1.  Menavigasi dan mengelola server Linux tanpa antarmuka grafis (GUI) dengan percaya diri.
2.  Membuat alat otomatisasi (tools) kustom untuk mempercepat pekerjaan tim.
3.  Menganalisis jutaan baris log server dalam hitungan detik menggunakan `awk` dan `sed`.
4.  Membangun pipeline CI/CD yang kompleks untuk deployment aplikasi.
5.  Melakukan troubleshooting sistem production dengan pemahaman mendalam tentang proses OS.

### Sertifikasi & Komunitas

  * **Sertifikasi:**
      * **LPIC-1 (Linux Professional Institute Certification):** Validasi dasar Linux yang kuat.
      * **RHCSA (Red Hat Certified System Administrator):** Standar emas untuk sysadmin, sangat berat di scripting dan command line.
  * **Komunitas:**
      * r/bash (Reddit)
      * StackOverflow (Tag: bash)
      * ShellCheck.net (Untuk validasi kode online)

-----

> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../bashscripting/bagian-1/README.md
[2]: ../bashscripting/bagian-2/README.md
[3]: ../bashscripting/bagian-3/README.md
[4]: ../bashscripting/bagian-4/README.md
[5]: ../bashscripting/bagian-5/README.md
[6]: ../bashscripting/bagian-6/README.md
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
