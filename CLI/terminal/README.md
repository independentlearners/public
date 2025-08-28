# **[Pengenalan Kurikulum: Membangun Fondasi Ahli CLI][0]**

Kurikulum ini dirancang untuk mengubah Anda dari pengguna awam menjadi seorang **"Shell Virtuoso"**, yaitu seseorang yang tidak hanya tahu cara menggunakan terminal, tetapi juga memahami filosofi, struktur, dan kekuatan fundamental di baliknya. Kita akan menjelajahi **Bash** sebagai shell utama di Linux dan **Termux** sebagai lingkungan terminal yang luar biasa di Android. Kurikulum ini tidak hanya mengajarkan perintah, tetapi juga cara berpikir secara **Unix-way**: membuat program kecil yang melakukan satu hal dengan baik, kemudian menggabungkannya.

**Prasyarat:**

  * **Sistem Operasi:** Pemasangan Arch Linux (atau distribusi Linux lain) dan aplikasi Termux di perangkat Android.
  * **Pengetahuan Dasar Komputer:** Pemahaman tentang konsep file, folder, dan navigasi dasar.
  * **Sikap Pembelajar:** Keinginan untuk menghadapi kurva pembelajaran yang curam namun sangat bermanfaat.

**Alat Esensial:**

  * Terminal emulator bawaan di Arch Linux (seperti `alacritty`, `kitty`, atau `gnome-terminal`).
  * Aplikasi Termux di Android.
  * Editor teks berbasis CLI seperti **Vim** atau **Neovim** (sangat disarankan) atau **Nano**.

**Hasil Pembelajaran (Learning Outcomes):**
Setelah menyelesaikan kurikulum ini, Anda akan mampu:

  * Menguasai navigasi, manipulasi file, dan manajemen proses di lingkungan CLI.
  * Memahami konsep *piping*, *redirection*, dan *scripting* shell untuk mengotomatisasi tugas.
  * Menyesuaikan dan mengkonfigurasi shell (`Bash` atau `Zsh`) untuk alur kerja yang efisien.
  * Menganalisis, mendiagnosis, dan menangani kesalahan sistem secara profesional.
  * Menulis skrip shell yang canggih untuk otomasi dan administrasi sistem.
  * Mengembangkan pemahaman yang mendalam tentang filosofi Linux dan sistem operasi berbasis Unix.

-----

### **[Fase I: Foundation (Pemula)][1]**

**Estimasi Waktu:** 20-30 Jam
**Level:** Pemula

Fase ini adalah fondasi yang kokoh. Tujuannya adalah membuat Anda merasa nyaman dan fasih dengan navigasi dasar di terminal, memahami struktur file Linux, dan menjalankan perintah-perintah sederhana. Anda akan belajar bagaimana terminal "berpikir" dan merespons.

#### **Modul 1.1: The Grand Tour - Memulai Perjalanan di Terminal**

  * **Deskripsi Konkret:** Ini adalah titik awal Anda. Kita akan mengenal antarmuka CLI, cara berinteraksi dengannya, dan memahami apa itu *shell* dan *terminal*. Kita akan menjalankan perintah pertama dan melihat hasilnya.
  * **Konsep Dasar dan Filosofi:**
      * **Shell:** Sebuah program penerjemah perintah (*command-line interpreter*) yang berfungsi sebagai antarmuka antara pengguna dan kernel sistem operasi. **Bash** (Bourne Again SHell) adalah shell standar di sebagian besar distro Linux, termasuk Arch. Filosofinya adalah menyediakan antarmuka yang sangat ringkas, cepat, dan kuat untuk mengontrol sistem.
      * **Terminal Emulator:** Sebuah aplikasi (seperti `alacritty` atau `Termux`) yang meniru perangkat terminal fisik. Ini hanyalah jendela atau wadah untuk shell.
  * **Sintaks Dasar/Contoh Implementasi Inti:**
      * Membuka terminal dan melihat *prompt* (`$`).
      * Perintah pertama: `echo "Hello, World!"`
      * `whoami`: Menampilkan nama pengguna saat ini.
      * `date`: Menampilkan tanggal dan waktu sistem.
  * **Terminologi Kunci:**
      * **Prompt (`$`):** Tanda yang menunjukkan bahwa shell siap menerima perintah.
      * **Command (Perintah):** Kata kunci yang memerintahkan shell untuk melakukan suatu tindakan (misalnya, `ls`, `cd`).
      * **Argument (Argumen):** Nilai atau parameter yang diberikan kepada perintah untuk memodifikasi perilakunya (misalnya, `ls -l`).
  * **Daftar Isi (Table of Contents):**
      * Mengenal Terminal, Shell, dan Prompt.
      * Perintah pertama: `echo`, `whoami`, `date`.
      * Memahami sintaks dasar: `perintah [opsi] [argumen]`.
  * **Sumber Referensi:**
      * Bash Reference Manual: [https://www.gnu.org/software/bash/manual/bash.html](https://www.gnu.org/software/bash/manual/bash.html)
      * Termux Wiki - Getting Started: [https://wiki.termux.com/wiki/Getting\_started](https://wiki.termux.com/wiki/Getting_started)

#### **Modul 1.2: Navigating the Filesystem (Berlayar di Sistem File)**

  * **Deskripsi Konkret:** Modul ini mengajarkan Anda cara bergerak di dalam struktur direktori Linux, yang berbeda dari Windows atau macOS. Anda akan belajar cara melihat file, berpindah antar direktori, dan memahami konsep direktori saat ini.
  * **Konsep Dasar dan Filosofi:**
      * **Everything is a File:** Dalam filosofi Unix/Linux, segalanya adalah file, termasuk perangkat keras, direktori, dan program. Struktur direktori hierarkis (`/`) adalah akar dari semuanya, menyediakan jalur yang konsisten untuk mengakses sumber daya.
      * **Home Directory (`~`):** Direktori yang diperuntukkan bagi setiap pengguna, tempat menyimpan file pribadi. Ini adalah titik awal yang aman untuk bereksperimen.
  * **Sintaks Dasar/Contoh Implementasi Inti:**
      * `pwd` (Print Working Directory): Menampilkan lokasi Anda saat ini.
      * `ls` (List): Mendaftar file dan direktori. Gunakan `ls -l` untuk detail.
      * `cd` (Change Directory): Berpindah ke direktori lain. Contoh: `cd /home/user` atau `cd ..` (kembali ke direktori induk).
      * `mkdir` (Make Directory): Membuat direktori baru.
  * **Terminologi Kunci:**
      * **Root Directory (`/`):** Direktori paling atas dalam hierarki file sistem Linux.
      * **Home Directory (`~`):** Jalan pintas ke direktori pribadi Anda.
      * **Relative Path:** Jalur yang relatif terhadap direktori saat ini (misalnya, `documents/`).
      * **Absolute Path:** Jalur lengkap dari root (`/`) (misalnya, `/home/user/documents`).
  * **Daftar Isi (Table of Contents):**
      * Struktur Direktori Linux.
      * Perintah Navigasi: `pwd`, `ls`, `cd`.
      * Jalur Absolut vs. Relatif.
      * Membuat dan Menghapus Direktori: `mkdir`, `rmdir`.
  * **Sumber Referensi:**
      * Filesystem Hierarchy Standard (FHS): [https://refspecs.linuxfoundation.org/FHS/fhs.html](https://www.google.com/search?q=https://refspecs.linuxfoundation.org/FHS/fhs.html)
      * Arch Wiki - Directories: [https://wiki.archlinux.org/title/Directory\_structure](https://www.google.com/search?q=https://wiki.archlinux.org/title/Directory_structure)

-----

### **[Fase II: Intermediate (Menengah)][2]**

**Estimasi Waktu:** 40-50 Jam
**Level:** Menengah

Fase ini membangun kemampuan Anda dengan memperkenalkan konsep-konsep kunci yang membuat CLI begitu kuat: manajemen file, *piping*, *redirection*, dan pencarian. Anda akan mulai mengotomatisasi tugas dan melihat potensi sebenarnya dari *command line*.

#### **Modul 2.1: Mastering File & Process Management (Menguasai Manajemen File & Proses)**

  * **Deskripsi Konkret:** Di modul ini, Anda akan belajar cara memanipulasi file dan mengelola proses yang berjalan di sistem. Anda akan menyalin, memindahkan, menghapus, melihat isi file, dan mengontrol program yang berjalan.
  * **Konsep Dasar dan Filosofi:**
      * **Standard Streams:** Shell Linux memiliki tiga "aliran" utama: **stdin** (input standar), **stdout** (output standar), dan **stderr** (error standar). Program membaca dari stdin dan menulis ke stdout/stderr. Ini adalah fondasi dari *piping* dan *redirection*.
      * **Process Management:** Setiap program yang dijalankan adalah sebuah proses. Anda akan belajar cara melihat dan mengontrol proses ini, termasuk menghentikan proses yang macet.
  * **Sintaks Dasar/Contoh Implementasi Inti:**
      * **File:**
          * `cp` (Copy): `cp file1.txt file2.txt`
          * `mv` (Move/Rename): `mv old_name new_name`
          * `rm` (Remove): `rm file_to_delete`
          * `cat` (Concatenate): `cat file.txt` untuk menampilkan isi file.
      * **Proses:**
          * `ps` (Process Status): `ps aux` untuk melihat semua proses yang berjalan.
          * `top` atau `htop`: Monitor proses interaktif.
          * `kill`: Mengakhiri proses dengan ID (`PID`). Contoh: `kill 1234`.
  * **Terminologi Kunci:**
      * **PID (Process ID):** Nomor unik yang diberikan ke setiap proses yang berjalan.
      * **Redirection (`>`, `>>`, `<`):** Mengarahkan output (atau input) dari perintah ke file. `>` menimpa, `>>` menambahkan.
      * **Piping (`|`):** Menghubungkan output dari satu perintah ke input perintah lain. Contoh: `ls | grep .txt`.
  * **Daftar Isi (Table of Contents):**
      * Menyalin, Memindahkan, dan Menghapus File.
      * Melihat dan Mencari Teks dalam File (`cat`, `less`, `grep`).
      * Konsep Standard Streams.
      * Pengenalan Piping (`|`) dan Redirection (`>`, `>>`).
      * Dasar-dasar Manajemen Proses (`ps`, `top`, `kill`).
  * **Sumber Referensi:**
      * GNU Coreutils Manual: [https://www.gnu.org/software/coreutils/manual/](https://www.gnu.org/software/coreutils/manual/)
      * Tux-Files - Pipes & Redirects: [http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html](http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html)

#### **Modul 2.2: The Power of `grep`, `find`, and `man` (Kekuatan Pencarian & Bantuan)**

  * **Deskripsi Konkret:** Modul ini mengajarkan Anda cara mencari file dan teks di seluruh sistem, sebuah keterampilan yang sangat penting untuk administrasi sistem dan *troubleshooting*. Anda juga akan belajar cara menggunakan `man` (manual) untuk mencari bantuan.
  * **Konsep Dasar dan Filosofi:**
      * **Manual Pages:** Setiap perintah di Linux memiliki halaman manual. `man` adalah perintah terpenting yang harus Anda kuasai. Filosofinya adalah `self-sufficiency`—semua dokumentasi ada di sistem Anda.
      * **Recursive Search:** `find` dirancang untuk mencari file secara rekursif, yaitu menjelajahi setiap direktori dan subdirektori dari titik awal. `grep` dirancang untuk mencari pola teks di dalam file.
  * **Sintaks Dasar/Contoh Implementasi Inti:**
      * `man ls`: Membuka halaman manual untuk perintah `ls`.
      * `grep "kata kunci" file.txt`: Mencari "kata kunci" di dalam `file.txt`.
      * `find . -name "filename.txt"`: Mencari file bernama `filename.txt` di direktori saat ini (`.`) dan subdirektorinya.
      * Kombinasi (`|`): `ls -l | grep "Jun"` untuk mencari file yang dimodifikasi pada bulan Juni.
  * **Terminologi Kunci:**
      * **Regular Expression (Regex):** Pola karakter yang digunakan untuk mencocokkan string. Digunakan secara luas oleh `grep` dan alat pencarian lainnya.
      * **Wildcard (`*`, `?`):** Karakter khusus yang digunakan untuk mencocokkan pola file atau direktori.
  * **Daftar Isi (Table of Contents):**
      * Mencari Bantuan: `man`, `info`, `apropos`.
      * Pencarian Teks dengan `grep` (Basic & Regex).
      * Pencarian File dengan `find` dan `locate`.
      * Menggabungkan `grep` dan `find` dengan `xargs`.
  * **Sumber Referensi:**
      * `man` (buka terminal, ketik `man man`): Dokumentasi dari perintah `man` itu sendiri.
      * `grep` man page: `man grep`.
      * `find` man page: `man find`.

-----

### **[Fase III: Advanced (Mahir)][3]**

**Estimasi Waktu:** 60-80 Jam
**Level:** Mahir

Anda sekarang berada di jalur untuk menjadi seorang ahli. Fase ini berfokus pada kekuatan sejati dari *shell scripting*, kustomisasi, dan administrasi sistem yang lebih dalam. Anda akan belajar mengotomatisasi tugas-tugas kompleks dan membuat alur kerja yang efisien.

#### **Modul 3.1: Shell Scripting 101 (Dasar-dasar Skrip Shell)**

  * **Deskripsi Konkret:** Ini adalah puncak dari kurikulum. Anda akan belajar cara menulis skrip shell, yang merupakan program mini yang mengotomatisasi serangkaian perintah. Skrip adalah alasan utama mengapa CLI sangat kuat.
  * **Konsep Dasar dan Filosofi:**
      * **Automation:** Filosofi utama dari skrip shell adalah otomasi. Mengubah tugas-tugas repetitif menjadi satu perintah sederhana, mengurangi kesalahan manusia dan menghemat waktu.
      * **Shebang (`#!`):** Baris pertama di setiap skrip shell yang memberi tahu sistem program mana yang akan digunakan untuk menjalankan skrip tersebut (misalnya, `#!/bin/bash`).
  * **Sintaks Dasar/Contoh Implementasi Inti:**
      * Skrip sederhana: Membuat file `myscript.sh`.
        ```bash
        #!/bin/bash

        echo "Skrip saya berjalan!"
        ls -l
        ```
      * Memberikan izin eksekusi: `chmod +x myscript.sh`
      * Menjalankan skrip: `./myscript.sh`
      * **Variabel:** `NAME="John Doe"`
      * **Kondisional:** `if`, `else`, `elif`. Contoh:
        ```bash
        if [ "$NAME" == "John Doe" ]; then
          echo "Hello, John."
        fi
        ```
      * **Looping:** `for`, `while`.
  * **Terminologi Kunci:**
      * **Shebang:** Baris pertama dalam skrip shell yang menentukan interpreter.
      * **Variable:** Wadah untuk menyimpan data.
      * **Control Flow:** Struktur skrip yang menentukan urutan eksekusi, seperti `if-else` dan *loops*.
  * **Daftar Isi (Table of Contents):**
      * Menulis Skrip Pertama: "Hello, Script\!"
      * Variabel dan Input Pengguna.
      * Kondisional (`if-else`) dan Perbandingan.
      * Perulangan (`for`, `while`).
      * Fungsi dalam Skrip.
      * Pentingnya *quoting* (tanda kutip) dan *exit codes*.
  * **Sumber Referensi:**
      * Bash Guide for Beginners: [https://tldp.org/LDP/Bash-Beginners-Guide/html/](https://tldp.org/LDP/Bash-Beginners-Guide/html/)
      * Advanced Bash-Scripting Guide: [https://tldp.org/LDP/abs/html/](https://tldp.org/LDP/abs/html/)

#### **Modul 3.2: Customization & Environment Variables (Kustomisasi & Variabel Lingkungan)**

  * **Deskripsi Konkret:** Modul ini akan mengajarkan Anda cara menyesuaikan *shell* Anda (`Bash` atau `Zsh`) agar sesuai dengan alur kerja Anda. Anda akan belajar tentang *alias*, *function*, dan variabel lingkungan untuk meningkatkan produktivitas.
  * **Konsep Dasar dan Filosofi:**
      * **Dotfiles:** File konfigurasi di Unix/Linux yang dimulai dengan titik (misalnya, `.bashrc`, `.profile`). Filosofinya adalah menyimpan konfigurasi di tempat yang tersembunyi namun mudah diakses.
      * **Variabel Lingkungan (`PATH`):** Variabel global yang berisi daftar direktori di mana shell harus mencari perintah yang dieksekusi. Memodifikasinya memungkinkan Anda menjalankan skrip dari mana saja.
  * **Sintaks Dasar/Contoh Implementasi Inti:**
      * Membuka file konfigurasi: `vim ~/.bashrc`
      * Membuat alias: `alias ll='ls -alF'`
      * Menambahkan direktori ke `PATH`: `export PATH="$HOME/bin:$PATH"`
  * **Terminologi Kunci:**
      * **Alias:** Nama pendek untuk perintah yang panjang atau kompleks.
      * **Environment Variable (Variabel Lingkungan):** Variabel yang tersedia untuk semua proses yang berjalan di dalam shell.
      * **Dotfiles:** File konfigurasi yang tersembunyi.
  * **Daftar Isi (Table of Contents):**
      * Memahami `~/.bashrc` dan `.profile`.
      * Membuat Alias untuk Perintah yang Sering Digunakan.
      * Pengenalan Variabel Lingkungan (`export`, `printenv`).
      * Modifikasi `PATH` untuk Skrip Pribadi.
  * **Sumber Referensi:**
      * Arch Wiki - Bash: [https://wiki.archlinux.org/title/Bash](https://wiki.archlinux.org/title/Bash)
      * Dotfiles on Github: [https://dotfiles.github.io/](https://dotfiles.github.io/)

-----

### **[Fase IV: Expert/Enterprise (Ahli/Profesional)][4]**

**Estimasi Waktu:** 80-100+ Jam
**Level:** Ahli

Fase ini adalah tentang menjadi seorang master. Anda akan menjelajahi konsep-konsep canggih, menguasai alat-alat yang kompleks, dan mengintegrasikan terminal dengan teknologi lain seperti Git, Cloud, dan container.

#### **Modul 4.1: Interoperability with Other Technologies (Integrasi & Interoperabilitas)**

  * **Deskripsi Konkret:** Terminal bukanlah dunia yang terisolasi. Modul ini mengajarkan Anda cara menggunakan terminal untuk berinteraksi dengan alat dan teknologi lain yang profesional.
  * **Konsep Dasar dan Filosofi:**
      * **Git as a CLI tool:** Git, sistem kontrol versi, dirancang dari awal untuk bekerja dengan sangat baik di CLI. Menguasainya melalui terminal adalah prasyarat untuk kolaborasi pengembangan profesional.
      * **API Interactions:** Menggunakan alat seperti `curl` atau `wget` untuk berinteraksi dengan API web, memungkinkan Anda mengotomatisasi tugas-tugas yang melibatkan layanan web.
  * **Sintaks Dasar/Contoh Implementasi Inti:**
      * Git: `git clone`, `git add`, `git commit`, `git push`.
      * SSH: `ssh user@hostname` untuk koneksi aman ke server.
      * `curl`: `curl https://api.github.com/users/octocat` untuk mendapatkan data dari GitHub API.
      * Menggabungkan `curl` dan `jq` (JSON Processor): `curl ... | jq '.name'` untuk memparsing data JSON.
  * **Terminologi Kunci:**
      * **Version Control:** Sistem untuk melacak perubahan pada kode dan file.
      * **SSH (Secure Shell):** Protokol jaringan yang aman untuk mengoperasikan layanan jaringan secara aman di jaringan yang tidak aman.
      * **API (Application Programming Interface):** Kumpulan aturan yang memungkinkan dua program untuk berkomunikasi.
  * **Daftar Isi (Table of Contents):**
      * Menguasai Git di Command Line.
      * Mengelola Server Jarak Jauh dengan SSH.
      * Menggunakan `curl` dan `wget` untuk Interaksi Web.
      * Manajemen Kontainer dengan Docker/Podman CLI.
  * **Sumber Referensi:**
      * Pro Git Book: [https://git-scm.com/book/en/v2](https://git-scm.com/book/en/v2)
      * Arch Wiki - SSH: [https://wiki.archlinux.org/title/SSH](https://wiki.archlinux.org/title/SSH)

-----

### **Sumber Daya Komunitas & Sertifikasi**

#### **Sumber Daya Komunitas:**

  * **Reddit:** `r/linux`, `r/linuxquestions`, `r/bash`, `r/archlinux`
  * **Stack Overflow:** Komunitas Q\&A terbesar untuk pertanyaan teknis.
  * **Arch Linux Wiki:** Sumber daya yang tak tertandingi untuk informasi teknis tentang Arch dan Linux secara umum.
  * **FreeCodeCamp:** Banyak tutorial video dan artikel tentang shell scripting.

#### **Sertifikasi:**

Meskipun tidak ada "Sertifikasi Terminal Shell" formal, penguasaan terminal adalah bagian inti dari sertifikasi profesional yang diakui secara global:

  * **CompTIA Linux+:** Uji keahlian dasar dan menengah dalam administrasi sistem Linux.
  * **LPIC-1 (Linux Professional Institute Certification):** Sertifikasi administrasi sistem Linux tingkat dasar.
  * **RHCSA (Red Hat Certified System Administrator):** Sertifikasi yang berfokus pada keterampilan praktis dalam administrasi sistem Red Hat Enterprise Linux.

Sertifikasi ini tidak secara eksklusif tentang terminal, tetapi Anda tidak akan bisa lulus tanpa penguasaan CLI yang mendalam. Penguasaan Anda terhadap kurikulum ini akan menempatkan Anda pada jalur yang tepat untuk meraihnya.

[0]: ../
[1]: ../terminal/bagian-1/README.md
[2]: ../terminal/bagian-2/README.md
[3]: ../terminal/bagian-3/README.md
[4]: ../terminal/bagian-4/README.md
