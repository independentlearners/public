<details>
  <summary>
    <strong>Kurikulum</strong>
    <div style="font-size: 11px; color: grey; margin-left: 24px;"><i>Membangun Fondasi Ahli CLI</i></div>
  </summary>
  <div style="padding-left: 25px; margin-top: 8px;">

# **[Membangun Fondasi Ahli CLI][0]**

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

Kurikulum ini mencakup empat fase utama:
1.  **Foundation (Pemula):** Membangun pemahaman dasar tentang terminal, navigasi sistem file, dan cara mencari bantuan.
2.  **Intermediate (Menengah):** Menguasai manajemen file, proses, dan konsep inti seperti *piping* dan *redirection*.
3.  **Advanced (Mahir):** Belajar *shell scripting*, termasuk logika kondisional, perulangan, dan fungsi untuk otomasi.
4.  **Expert/Enterprise (Ahli):** Mengintegrasikan terminal dengan teknologi profesional seperti Git, SSH, dan Docker.

Setiap modul dan sub-bagian telah dijelaskan secara mendalam, termasuk konsep filosofis, contoh implementasi, terminologi kunci, praktik terbaik, dan potensi kesalahan umum.

Dengan menyelesaikan seluruh kurikulum ini, Anda telah memperoleh fondasi yang kuat untuk menjadi seorang ahli dalam penggunaan CLI dan siap untuk menghadapi tantangan teknis yang lebih kompleks.

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

[1]: ../terminal/bagian-1/README.md
[2]: ../terminal/bagian-2/README.md
[3]: ../terminal/bagian-3/README.md
[4]: ../terminal/bagian-4/README.md
[0]: ../../programmer/domain-spesifik/README.md

</div>
</details>

<details>
  <summary>
    <strong>Ringkasan & Pengenalan </strong>
    <div style="font-size: 11px; color: grey; margin-left: 24px;"><i>Perbedaan CLI dan Terminal</i></div>
  </summary>
  <div style="padding-left: 25px; margin-top: 8px;">

# 
**CLI** (Command Line Interface) dan **terminal** adalah dua istilah yang sering digunakan secara bergantian, tetapi sebenarnya memiliki makna yang berbeda

---

### **1. Definisi**

#### **CLI (Command Line Interface)**

- **Apa Itu?**  
  CLI adalah metode interaksi dengan komputer di mana pengguna mengetik perintah teks untuk menjalankan tugas.

  - CLI bisa berupa shell (seperti Bash, Zsh, atau PowerShell) atau program lain yang menerima input teks.
  - Contoh: `git`, `docker`, `npm`.

- **Karakteristik:**
  - Berbasis teks.
  - Memerlukan pengetahuan tentang sintaks perintah.
  - Biasanya lebih cepat dan lebih efisien untuk tugas tertentu dibandingkan GUI (Graphical User Interface).

#### **Terminal**

- **Apa Itu?**  
  Terminal adalah aplikasi atau perangkat yang memungkinkan pengguna berinteraksi dengan CLI.

  - Di masa lalu, terminal adalah perangkat fisik (seperti teletype).
  - Sekarang, terminal biasanya berupa aplikasi perangkat lunak (seperti GNOME Terminal, iTerm2, atau Windows Terminal).

- **Karakteristik:**
  - Menyediakan antarmuka untuk CLI.
  - Menampilkan output dan menerima input dari pengguna.
  - Bisa menjalankan berbagai shell atau program CLI.

---

### **2. Perbedaan Utama**

| Aspek              | CLI                                           | Terminal                                |
| ------------------ | --------------------------------------------- | --------------------------------------- |
| **Definisi**       | Metode interaksi berbasis teks                | Antarmuka untuk berinteraksi dengan CLI |
| **Bentuk Fisik**   | Tidak memiliki bentuk fisik                   | Perangkat keras atau perangkat lunak    |
| **Contoh**         | Bash, PowerShell, Git                         | GNOME Terminal, iTerm2, CMD             |
| **Fungsi**         | Menerima dan mengeksekusi perintah            | Menampilkan output dan input            |
| **Ketergantungan** | Dapat digunakan tanpa terminal (misal: skrip) | Membutuhkan CLI untuk berfungsi         |

---

### **3. Hubungan Antara CLI dan Terminal**

- **Terminal sebagai Wadah**:  
  Terminal adalah "wadah" atau "jendela" yang memungkinkan pengguna berinteraksi dengan CLI.  
  Contoh: Di GNOME Terminal, Anda bisa menjalankan shell seperti Bash atau Zsh.

- **CLI sebagai Isi**:  
  CLI adalah "isi" atau "inti" dari interaksi yang terjadi di terminal.  
  Contoh: Saat Anda mengetik `ls` di terminal, CLI (shell) yang menerjemahkan dan mengeksekusi perintah tersebut.

---

### **4. Analogi untuk Memahami Hubungan Mereka**

Bayangkan **CLI** sebagai **bahasa** yang Anda gunakan untuk berkomunikasi, dan **terminal** sebagai **telepon** yang memungkinkan Anda berbicara menggunakan bahasa tersebut.

- **Terminal**: Telepon (alat untuk berkomunikasi).
- **CLI**: Bahasa yang Anda gunakan (misal: Bash, PowerShell).
- **Shell**: Salah satu "bahasa" CLI yang populer.

---

### **5. Mengapa Ada Dua Istilah?**

1. **Perbedaan Fungsional**:

   - **CLI** merujuk pada metode interaksi (berbasis teks).
   - **Terminal** merujuk pada alat yang memungkinkan interaksi tersebut.

2. **Sejarah**:

   - **Terminal** muncul lebih dulu sebagai perangkat fisik untuk berinteraksi dengan komputer.
   - **CLI** berkembang sebagai metode untuk menggunakan terminal secara efisien.

3. **Konteks Penggunaan**:
   - **CLI** digunakan ketika membahas perintah atau sintaks (misal: "Gunakan CLI untuk menginstal paket").
   - **Terminal** digunakan ketika membahas antarmuka atau aplikasi (misal: "Buka terminal untuk menjalankan perintah").

---

### **6. Contoh Penggunaan**

#### **CLI**

- Menjalankan perintah di shell:

  ```bash
  ls -l
  git commit -m "Update README"
  ```

- Menggunakan program CLI:
  ```bash
  curl https://example.com
  docker run -d nginx
  ```

#### **Terminal**

- Membuka aplikasi terminal:

  - GNOME Terminal (Linux).
  - iTerm2 (macOS).
  - Windows Terminal (Windows).

- Menjalankan shell di terminal:
  ```bash
  # Di terminal, jalankan shell
  bash
  zsh
  pwsh
  ```

---

### **7. Kesimpulan**

- **CLI**: Metode interaksi berbasis teks dengan komputer.
- **Terminal**: Alat (fisik atau perangkat lunak) yang memungkinkan interaksi dengan CLI.
- **Shell**: Salah satu jenis CLI yang populer.

Dua istilah ini ada karena mereka merujuk pada aspek yang berbeda dari interaksi berbasis teks.

# Kompendium Komprehensif: Shortcut Terminal dalam Ekosistem Komputasi Modern

## Analisis

Shortcut terminal merepresentasikan aspek fundamental dalam interaksi manusia-komputer melalui antarmuka berbasis teks. Analisis terhadap berbagai jenis shortcut terminal mengungkapkan beberapa konsep kunci:

1. **Stratifikasi Implementasi**: Shortcut terminal diimplementasikan dalam beberapa lapisan hierarkis, mulai dari pengendali hardware, subsistem kernel, emulator terminal, hingga aplikasi shell.

2. **Divergensi Historis**: Terdapat divergensi signifikan antara paradigma terminal berbasis POSIX (Unix, Linux, macOS) dan paradigma terminal berbasis Windows, yang menghasilkan ekosistem shortcut yang berbeda namun memiliki beberapa titik konvergensi.

3. **Kontinuitas Evolusioner**: Shortcut terminal telah mengalami evolusi bertahap dari era teletype hingga terminal modern, dengan mempertahankan banyak konsep fundamental seperti pengendalian aliran (flow control) dan pemrosesan sinyal.

4. **Variabilitas Implementasi**: Tingkat universalitas shortcut terminal bervariasi dari yang hampir universal (seperti Ctrl+C) hingga yang sangat spesifik untuk emulator atau shell tertentu.

5. **Relevansi Kontemporer**: Meskipun kemajuan antarmuka grafis, shortcut terminal tetap menjadi komponen vital dalam produktivitas komputasi modern, terutama dalam administrasi sistem, pengembangan perangkat lunak, dan automasi kompleks.

Pemahaman mendalam tentang shortcut terminal tidak hanya meningkatkan produktivitas individu tetapi juga memberikan wawasan tentang desain sistem operasi dan evolusi teknologi komputasi.

---

# Kamus Komprehensif Shortcut Terminal: Kompatibilitas, Implementasi, dan Konteks Operasional

## 1. Sinyal dan Kontrol Proses

| Shortcut | Fungsi                                                      | Kompatibilitas                                   | Implementasi Teknis             | Konteks Operasional                          |
| -------- | ----------------------------------------------------------- | ------------------------------------------------ | ------------------------------- | -------------------------------------------- |
| `Ctrl+C` | Mengirim sinyal SIGINT untuk interupsi proses               | Universal (Windows, Linux, macOS, BSD)           | Sinyal SIGINT (2)               | Berfungsi di terminal TTY dan emulator       |
| `Ctrl+Z` | Mengirim sinyal SIGTSTP untuk menghentikan sementara proses | Linux, macOS, BSD; Terbatas di Windows           | Sinyal SIGTSTP (20)             | Berfungsi di TTY dan mayoritas emulator      |
| `Ctrl+\` | Mengirim sinyal SIGQUIT untuk terminasi dengan core dump    | Linux, macOS, BSD; Tidak tersedia di Windows CMD | Sinyal SIGQUIT (3)              | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+T` | Mengirim sinyal SIGINFO untuk informasi status proses       | BSD, macOS; Tidak tersedia di Linux, Windows     | Sinyal SIGINFO (29)             | Berfungsi di TTY BSD dan macOS               |
| `Ctrl+D` | Mengirim EOF (End of File)                                  | Universal dengan variasi implementasi            | Karakter ASCII 04 (EOT)         | Berfungsi di TTY dan mayoritas emulator      |
| `Ctrl+P` | Menghentikan proses dan menampilkan profil                  | Limited (beberapa implementasi kustom)           | Implementasi spesifik per shell | Umumnya tidak berfungsi di TTY dasar         |
| `Ctrl+S` | Mengirim XOFF untuk menghentikan output                     | Universal dengan variasi perilaku                | Implementasi flow control       | Berfungsi di TTY dan mayoritas emulator      |
| `Ctrl+Q` | Mengirim XON untuk melanjutkan output                       | Universal dengan variasi perilaku                | Implementasi flow control       | Berfungsi di TTY dan mayoritas emulator      |

## 2. Navigasi dan Manipulasi Baris Perintah

| Shortcut        | Fungsi                                     | Kompatibilitas                                | Implementasi Teknis          | Konteks Operasional                                   |
| --------------- | ------------------------------------------ | --------------------------------------------- | ---------------------------- | ----------------------------------------------------- |
| `Ctrl+A`        | Pindah ke awal baris                       | Unix-like; Terbatas di Windows                | Implementasi GNU Readline    | Berfungsi di TTY dan mayoritas emulator               |
| `Ctrl+E`        | Pindah ke akhir baris                      | Unix-like; Terbatas di Windows                | Implementasi GNU Readline    | Berfungsi di TTY dan mayoritas emulator               |
| `Ctrl+B`        | Mundur satu karakter                       | Unix-like; Terbatas di Windows                | Implementasi GNU Readline    | Berfungsi di TTY dan mayoritas emulator               |
| `Ctrl+F`        | Maju satu karakter                         | Unix-like; Terbatas di Windows                | Implementasi GNU Readline    | Berfungsi di TTY dan mayoritas emulator               |
| `Alt+B`         | Mundur satu kata                           | Unix-like; Terbatas/tidak tersedia di Windows | Implementasi GNU Readline    | Berfungsi di TTY dan mayoritas emulator               |
| `Alt+F`         | Maju satu kata                             | Unix-like; Terbatas/tidak tersedia di Windows | Implementasi GNU Readline    | Berfungsi di TTY dan mayoritas emulator               |
| `Ctrl+XX`       | Toggle antara posisi kursor dan awal baris | Bash, Zsh; Tidak tersedia di Windows          | Implementasi readline khusus | Jarang berfungsi di TTY dasar                         |
| `Ctrl+]` + char | Pindah ke kemunculan karakter              | Bash, Zsh; Tidak tersedia di Windows          | Implementasi readline khusus | Jarang berfungsi di TTY dasar                         |
| `Home`          | Pindah ke awal baris                       | Universal dengan variasi implementasi         | Implementasi emulator        | Umumnya berfungsi di emulator modern, terbatas di TTY |
| `End`           | Pindah ke akhir baris                      | Universal dengan variasi implementasi         | Implementasi emulator        | Umumnya berfungsi di emulator modern, terbatas di TTY |
| `Alt+<`         | Pindah ke awal histori                     | Bash, Zsh; Tidak tersedia di Windows          | Implementasi readline khusus | Jarang berfungsi di TTY dasar                         |
| `Alt+>`         | Pindah ke akhir histori                    | Bash, Zsh; Tidak tersedia di Windows          | Implementasi readline khusus | Jarang berfungsi di TTY dasar                         |

## 3. Penghapusan dan Manipulasi Teks

| Shortcut                | Fungsi                                         | Kompatibilitas                           | Implementasi Teknis                         | Konteks Operasional                                   |
| ----------------------- | ---------------------------------------------- | ---------------------------------------- | ------------------------------------------- | ----------------------------------------------------- |
| `Ctrl+U`                | Hapus dari kursor ke awal baris                | Unix-like; Variasi di Windows PowerShell | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator               |
| `Ctrl+K`                | Hapus dari kursor ke akhir baris               | Unix-like; Variasi di Windows PowerShell | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator               |
| `Ctrl+W`                | Hapus kata sebelum kursor                      | Unix-like; Variasi di Windows PowerShell | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator               |
| `Alt+D`                 | Hapus kata setelah kursor                      | Unix-like; Tidak tersedia di Windows CMD | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator Unix          |
| `Ctrl+H`                | Hapus karakter sebelum kursor (backspace)      | Universal                                | Karakter ASCII 08 (BS)                      | Berfungsi di TTY dan semua emulator                   |
| `Ctrl+D` (konteks lain) | Hapus karakter di bawah kursor                 | Universal                                | Implementasi readline/shell                 | Berfungsi di TTY dan mayoritas emulator               |
| `Ctrl+T`                | Tukar karakter saat ini dengan sebelumnya      | Unix-like; Tidak tersedia di Windows CMD | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator Unix          |
| `Alt+T`                 | Tukar kata saat ini dengan sebelumnya          | Unix-like; Tidak tersedia di Windows CMD | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator Unix          |
| `Alt+U`                 | Ubah kata ke huruf besar                       | Unix-like; Tidak tersedia di Windows CMD | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator Unix          |
| `Alt+L`                 | Ubah kata ke huruf kecil                       | Unix-like; Tidak tersedia di Windows CMD | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator Unix          |
| `Alt+C`                 | Kapitalisasi karakter dan pindah ke akhir kata | Unix-like; Tidak tersedia di Windows CMD | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator Unix          |
| `Backspace`             | Hapus karakter sebelum kursor                  | Universal                                | Karakter ASCII 127 (DEL)                    | Berfungsi di TTY dan semua emulator                   |
| `Delete`                | Hapus karakter di bawah kursor                 | Universal di emulator modern             | Implementasi emulator                       | Umumnya berfungsi di emulator modern, terbatas di TTY |

## 4. Histori dan Pencarian

| Shortcut           | Fungsi                                                | Kompatibilitas                           | Implementasi Teknis                         | Konteks Operasional                                        |
| ------------------ | ----------------------------------------------------- | ---------------------------------------- | ------------------------------------------- | ---------------------------------------------------------- |
| `Ctrl+R`           | Pencarian mundur interaktif                           | Unix-like; PowerShell modern             | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator                    |
| `Ctrl+S`           | Pencarian maju interaktif                             | Unix-like dengan konfigurasi khusus      | Implementasi readline khusus                | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `Ctrl+P`           | Perintah sebelumnya dalam histori                     | Unix-like; PowerShell modern             | Implementasi readline/shell                 | Berfungsi di TTY dan mayoritas emulator                    |
| `Ctrl+N`           | Perintah berikutnya dalam histori                     | Unix-like; PowerShell modern             | Implementasi readline/shell                 | Berfungsi di TTY dan mayoritas emulator                    |
| `Ctrl+G`           | Keluar dari mode pencarian                            | Unix-like; PowerShell modern             | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator                    |
| `Alt+.`            | Sisipkan argumen terakhir dari perintah sebelumnya    | Unix-like; Tidak tersedia di Windows CMD | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator Unix               |
| `!!`               | Jalankan perintah terakhir                            | Unix-like; Tidak tersedia di Windows CMD | Implementasi ekspansi histori shell         | Berfungsi di TTY dan mayoritas emulator Unix               |
| `!$`               | Referensi argumen terakhir perintah sebelumnya        | Unix-like; Tidak tersedia di Windows CMD | Implementasi ekspansi histori shell         | Berfungsi di TTY dan mayoritas emulator Unix               |
| `!n`               | Jalankan perintah ke-n dalam histori                  | Unix-like; Tidak tersedia di Windows CMD | Implementasi ekspansi histori shell         | Berfungsi di TTY dan mayoritas emulator Unix               |
| `!string`          | Jalankan perintah terakhir yang dimulai dengan string | Unix-like; Tidak tersedia di Windows CMD | Implementasi ekspansi histori shell         | Berfungsi di TTY dan mayoritas emulator Unix               |
| `!?string`         | Jalankan perintah terakhir yang mengandung string     | Unix-like; Tidak tersedia di Windows CMD | Implementasi ekspansi histori shell         | Berfungsi di TTY dan mayoritas emulator Unix               |
| `^string1^string2` | Jalankan perintah terakhir dengan substitusi          | Unix-like; Tidak tersedia di Windows CMD | Implementasi ekspansi histori shell         | Berfungsi di TTY dan mayoritas emulator Unix               |
| `Ctrl+O`           | Jalankan perintah dan memuat perintah berikutnya      | Bash, Zsh; Tidak tersedia di Windows     | Implementasi readline khusus                | Jarang berfungsi di TTY dasar                              |

## 5. Penyelesaian dan Ekspansi

| Shortcut   | Fungsi                                      | Kompatibilitas                        | Implementasi Teknis             | Konteks Operasional                 |
| ---------- | ------------------------------------------- | ------------------------------------- | ------------------------------- | ----------------------------------- |
| `Tab`      | Penyelesaian otomatis                       | Universal dengan variasi implementasi | Implementasi spesifik per shell | Berfungsi di TTY dan semua emulator |
| `Tab Tab`  | Tampilkan semua kemungkinan penyelesaian    | Universal dengan variasi implementasi | Implementasi spesifik per shell | Berfungsi di TTY dan semua emulator |
| `Alt+*`    | Ekspansi glob untuk kata saat ini           | Bash, Zsh; Tidak tersedia di Windows  | Implementasi readline khusus    | Jarang berfungsi di TTY dasar       |
| `Alt+?`    | Tampilkan kemungkinan penyelesaian          | Bash, Zsh; Tidak tersedia di Windows  | Implementasi readline khusus    | Jarang berfungsi di TTY dasar       |
| `Alt+/`    | Penyelesaian filename                       | Bash, Zsh; Tidak tersedia di Windows  | Implementasi readline khusus    | Jarang berfungsi di TTY dasar       |
| `Ctrl+X+/` | Tampilkan kemungkinan penyelesaian path     | Bash dengan konfigurasi khusus        | Implementasi readline khusus    | Tidak berfungsi di TTY dasar        |
| `Ctrl+X+~` | Tampilkan kemungkinan penyelesaian username | Bash dengan konfigurasi khusus        | Implementasi readline khusus    | Tidak berfungsi di TTY dasar        |
| `Ctrl+X+$` | Tampilkan kemungkinan penyelesaian variabel | Bash dengan konfigurasi khusus        | Implementasi readline khusus    | Tidak berfungsi di TTY dasar        |
| `Ctrl+X+@` | Tampilkan kemungkinan penyelesaian hostname | Bash dengan konfigurasi khusus        | Implementasi readline khusus    | Tidak berfungsi di TTY dasar        |
| `Ctrl+X+!` | Tampilkan kemungkinan penyelesaian perintah | Bash dengan konfigurasi khusus        | Implementasi readline khusus    | Tidak berfungsi di TTY dasar        |

## 6. Manipulasi Layar dan Buffer

| Shortcut            | Fungsi                                      | Kompatibilitas                               | Implementasi Teknis                | Konteks Operasional                          |
| ------------------- | ------------------------------------------- | -------------------------------------------- | ---------------------------------- | -------------------------------------------- |
| `Ctrl+L`            | Bersihkan layar                             | Universal dengan variasi implementasi        | Implementasi terminal (clear)      | Berfungsi di TTY dan semua emulator          |
| `Ctrl+J`            | Newline (line feed)                         | Universal                                    | Karakter ASCII 10 (LF)             | Berfungsi di TTY dan semua emulator          |
| `Ctrl+M`            | Carriage return                             | Universal                                    | Karakter ASCII 13 (CR)             | Berfungsi di TTY dan semua emulator          |
| `Ctrl+V`            | Mode verbatim (input karakter kontrol)      | Unix-like; Tidak tersedia di Windows CMD     | Implementasi readline/terminal     | Berfungsi di TTY dan mayoritas emulator Unix |
| `Shift+PgUp`        | Scroll layar ke atas                        | Emulator modern; Tidak tersedia di TTY dasar | Implementasi emulator              | Tidak berfungsi di TTY dasar                 |
| `Shift+PgDn`        | Scroll layar ke bawah                       | Emulator modern; Tidak tersedia di TTY dasar | Implementasi emulator              | Tidak berfungsi di TTY dasar                 |
| `Ctrl+Shift+C`      | Salin teks terseleksi                       | Emulator modern; Tidak tersedia di TTY dasar | Implementasi emulator              | Tidak berfungsi di TTY dasar                 |
| `Ctrl+Shift+V`      | Paste teks                                  | Emulator modern; Tidak tersedia di TTY dasar | Implementasi emulator              | Tidak berfungsi di TTY dasar                 |
| `Ctrl+Alt+[F1-F12]` | Beralih antara virtual console              | Linux; Tidak tersedia di Windows/macOS       | Implementasi kernel Linux          | Berfungsi di TTY Linux                       |
| `Alt+[F1-F12]`      | Beralih antara virtual console (alternatif) | Linux; Tidak tersedia di Windows/macOS       | Implementasi kernel Linux          | Berfungsi di TTY Linux                       |
| `Ctrl+S`            | Freeze terminal output                      | Universal                                    | Implementasi flow control terminal | Berfungsi di TTY dan semua emulator          |
| `Ctrl+Q`            | Resume terminal output                      | Universal                                    | Implementasi flow control terminal | Berfungsi di TTY dan semua emulator          |

## 7. Manajemen Job dan Proses

| Shortcut                | Fungsi                              | Kompatibilitas                           | Implementasi Teknis     | Konteks Operasional                          |
| ----------------------- | ----------------------------------- | ---------------------------------------- | ----------------------- | -------------------------------------------- |
| `Ctrl+Z`                | Suspensi proses (background)        | Unix-like; Terbatas di Windows           | Sinyal SIGTSTP          | Berfungsi di TTY dan mayoritas emulator      |
| `Ctrl+C`                | Interupsi proses                    | Universal                                | Sinyal SIGINT           | Berfungsi di TTY dan semua emulator          |
| `Ctrl+\`                | Terminasi proses dengan core dump   | Unix-like; Tidak tersedia di Windows CMD | Sinyal SIGQUIT          | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+D` (konteks lain) | EOF/exit                            | Universal dengan variasi implementasi    | Karakter ASCII 04 (EOT) | Berfungsi di TTY dan semua emulator          |
| `Ctrl+Z` + `bg`         | Lanjutkan proses di background      | Unix-like; Tidak tersedia di Windows CMD | Implementasi shell      | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+Z` + `fg`         | Lanjutkan proses di foreground      | Unix-like; Tidak tersedia di Windows CMD | Implementasi shell      | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+Z` + `jobs`       | Tampilkan proses background         | Unix-like; Tidak tersedia di Windows CMD | Implementasi shell      | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+Z` + `kill %n`    | Terminasi job background            | Unix-like; Tidak tersedia di Windows CMD | Implementasi shell      | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+Y`                | Reaktivasi proses yang ditangguhkan | Bash, Zsh; Tidak tersedia di Windows     | Implementasi shell      | Jarang berfungsi di TTY dasar                |

## 8. Mode Editing dan Operasi Teks Lanjutan

| Shortcut        | Fungsi                                         | Kompatibilitas                           | Implementasi Teknis          | Konteks Operasional                          |
| --------------- | ---------------------------------------------- | ---------------------------------------- | ---------------------------- | -------------------------------------------- |
| `Ctrl+X+E`      | Edit line dengan editor eksternal              | Bash, Zsh; Tidak tersedia di Windows CMD | Implementasi readline khusus | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+X+Ctrl+E` | Edit line dengan editor eksternal (alternatif) | Bash, Zsh; Tidak tersedia di Windows CMD | Implementasi readline khusus | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+Alt+E`    | Ekspansi alias dan fungsi                      | Bash; Tidak tersedia di Windows CMD      | Implementasi readline khusus | Jarang berfungsi di TTY dasar                |
| `Meta+C`        | Kapitalisasi karakter                          | Bash, Zsh; Tidak tersedia di Windows CMD | Implementasi readline khusus | Berfungsi di TTY dan mayoritas emulator Unix |
| `Meta+U`        | Ubah kata ke huruf besar                       | Bash, Zsh; Tidak tersedia di Windows CMD | Implementasi readline khusus | Berfungsi di TTY dan mayoritas emulator Unix |
| `Meta+L`        | Ubah kata ke huruf kecil                       | Bash, Zsh; Tidak tersedia di Windows CMD | Implementasi readline khusus | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+_`        | Undo                                           | Bash, Zsh; Tidak tersedia di Windows CMD | Implementasi readline khusus | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+X+Ctrl+U` | Undo (alternatif)                              | Bash; Tidak tersedia di Windows CMD      | Implementasi readline khusus | Jarang berfungsi di TTY dasar                |
| `Alt+R`         | Mengembalikan line ke versi original           | Bash, Zsh; Tidak tersedia di Windows CMD | Implementasi readline khusus | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+X+Ctrl+V` | Tampilkan versi readline                       | Bash; Tidak tersedia di Windows CMD      | Implementasi readline khusus | Jarang berfungsi di TTY dasar                |

## 9. Shortcut Mode Vi dalam Readline/Shell

| Shortcut            | Fungsi                           | Kompatibilitas               | Implementasi Teknis           | Konteks Operasional                                        |
| ------------------- | -------------------------------- | ---------------------------- | ----------------------------- | ---------------------------------------------------------- |
| `Esc`               | Masuk mode command               | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `k` (mode command)  | Perintah sebelumnya              | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `j` (mode command)  | Perintah berikutnya              | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `h` (mode command)  | Kursor ke kiri                   | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `l` (mode command)  | Kursor ke kanan                  | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `0` (mode command)  | Awal baris                       | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `$` (mode command)  | Akhir baris                      | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `i` (mode command)  | Masuk mode insert                | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `a` (mode command)  | Masuk mode insert setelah kursor | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `/` (mode command)  | Pencarian mundur                 | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `n` (mode command)  | Pencarian berikutnya             | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `N` (mode command)  | Pencarian sebelumnya             | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `dd` (mode command) | Hapus baris                      | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `dw` (mode command) | Hapus kata                       | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `u` (mode command)  | Undo                             | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |

## 10. Shortcut Terminal Windows-Spesifik

| Shortcut           | Fungsi                                                  | Kompatibilitas   | Implementasi Teknis           | Konteks Operasional           |
| ------------------ | ------------------------------------------------------- | ---------------- | ----------------------------- | ----------------------------- |
| `F1`               | Paste karakter satu per satu dari perintah sebelumnya   | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F2`               | Paste hingga karakter tertentu dari perintah sebelumnya | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F3`               | Paste perintah sebelumnya                               | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F4`               | Hapus hingga karakter tertentu                          | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F5`               | Pencarian mundur dalam histori                          | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F6`               | Sisipkan EOF (^Z)                                       | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F7`               | Tampilkan histori perintah                              | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F8`               | Pencarian histori sesuai dengan teks yang diketik       | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F9`               | Pilih perintah berdasarkan nomor                        | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `Alt+F7`           | Hapus histori perintah                                  | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `Alt+Enter`        | Toggle mode fullscreen                                  | Windows Terminal | Implementasi Windows Terminal | Berfungsi di Windows Terminal |
| `Ctrl+Shift+W`     | Tutup tab                                               | Windows Terminal | Implementasi Windows Terminal | Berfungsi di Windows Terminal |
| `Ctrl+Shift+T`     | Buka tab baru                                           | Windows Terminal | Implementasi Windows Terminal | Berfungsi di Windows Terminal |
| `Ctrl+Tab`         | Beralih tab                                             | Windows Terminal | Implementasi Windows Terminal | Berfungsi di Windows Terminal |
| `Ctrl+Shift+Space` | Buka dropdown                                           | Windows Terminal | Implementasi Windows Terminal | Berfungsi di Windows Terminal |
| `Ctrl+Shift+D`     | Duplikasi tab                                           | Windows Terminal | Implementasi Windows Terminal | Berfungsi di Windows Terminal |
| `Ctrl+Shift+P`     | Buka command palette                                    | Windows Terminal | Implementasi Windows Terminal | Berfungsi di Windows Terminal |

## 11. Shortcut PowerShell-Spesifik

| Shortcut     | Fungsi                                       | Kompatibilitas | Implementasi Teknis     | Konteks Operasional     |
| ------------ | -------------------------------------------- | -------------- | ----------------------- | ----------------------- |
| `Tab`        | Penyelesaian interaktif                      | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `Ctrl+Space` | Penyelesaian menu                            | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F1`         | Tampilkan bantuan kontekstual                | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F2`         | Scroll satu layar ke kiri                    | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F3`         | Perintah sebelumnya                          | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F4`         | Hapus hingga akhir kata                      | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F5`         | Pencarian mundur histori                     | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F7`         | Tampilkan histori perintah                   | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F8`         | Pencarian histori sesuai dengan yang diketik | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F9`         | Pilih perintah berdasarkan nomor             | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `Alt+F7`     | Hapus histori perintah                       | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `Ctrl+Alt+?` | Tampilkan daftar shortcut                    | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `Ctrl+R`     | Pencarian mundur interaktif                  | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `Ctrl+S`     | Pencarian maju interaktif                    | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `Alt+?`      | Tampilkan penyelesaian secara inline         | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |

## 12. Shortcut Shell-Spesifik untuk Zsh

| Shortcut     | Fungsi                                   | Kompatibilitas | Implementasi Teknis       | Konteks Operasional                     |
| ------------ | ---------------------------------------- | -------------- | ------------------------- | --------------------------------------- |
| `Alt+q`      | Push line, ketik perintah lain, pop line | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Alt+h`      | Tampilkan dokumentasi zsh-help           | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+g`   | Ekspansi glob                            | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Alt+x`      | Eksekusi perintah sebelum kursor         | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+v+Esc` | Insert visual escape sequence            | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+a`   | Buka zsh line editor                     | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Alt+.`      | Masukkan argumen terakhir                | Zsh            | Implementasi zle/readline | Berfungsi di TTY dan mayoritas emulator |
| `Alt+m`      | Masukkan parameter pertama               | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Alt+_`      | Masukkan argumen terakhir perintah ke-n  | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+m`   | Select menuselect                        | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+r`   | History incremental search backward      | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+s`   | History incremental search forward       | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+u`   | Undo perubahan                           | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+v`   | Toggle vi mode                           | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+Esc` | Expand command name                      | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |

## 13. Shortcut Shell-Spesifik untuk Fish

| Shortcut     | Fungsi                                   | Kompatibilitas | Implementasi Teknis     | Konteks Operasional            |
| ------------ | ---------------------------------------- | -------------- | ----------------------- | ------------------------------ |
| `Tab`        | Penyelesaian cerdas                      | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+Left`   | Navigasi direktori sebelumnya            | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+Right`  | Navigasi direktori berikutnya            | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+Up`     | Pencarian histori dengan awalan saat ini | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+Down`   | Pencarian histori ke bawah               | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+l`      | List direktori saat ini                  | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+w`      | Tampilkan deskripsi perintah             | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+e`      | Edit line dengan editor eksternal        | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+s`      | Prepend sudo ke perintah                 | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+p`      | Prepend perintah dengan pager            | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Ctrl+Space` | Pencarian dan ekspansi wildcard          | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+h`      | Tampilkan dokumentasi bantuan            | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+c`      | Penyelesaian historis direktoris         | Fish           | Implementasi fish-z     | Berfungsi dengan plugin fish-z |
| `Alt+o`      | Tambahkan output perintah sebelumnya     | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+v`      | Tampilkan variabel lingkungan            | Fish           | Implementasi fish shell | Berfungsi di fish shell        |

## 14. Shortcut Terminal MacOS-Spesifik

| Shortcut         | Fungsi                           | Kompatibilitas | Implementasi Teknis       | Konteks Operasional         |
| ---------------- | -------------------------------- | -------------- | ------------------------- | --------------------------- |
| `Cmd+K`          | Bersihkan buffer terminal        | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+T`          | Buka tab baru                    | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+N`          | Buka jendela terminal baru       | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+W`          | Tutup tab aktif                  | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+F`          | Pencarian dalam terminal         | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+G`          | Pencarian berikutnya             | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+Shift+G`    | Pencarian sebelumnya             | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+Left/Right` | Beralih antar tab                | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd++`          | Perbesar font                    | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+-`          | Perkecil font                    | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+0`          | Reset ukuran font                | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+Enter`      | Toggle mode fullscreen           | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+Shift+K`    | Bersihkan scrollback buffer      | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+D`          | Split terminal secara vertikal   | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+Shift+D`    | Split terminal secara horizontal | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |

## 15. Shortcut Terminal Emulator-Spesifik Modern

| Shortcut              | Fungsi                   | Kompatibilitas                 | Implementasi Teknis   | Konteks Operasional           |
| --------------------- | ------------------------ | ------------------------------ | --------------------- | ----------------------------- |
| `Ctrl+Shift+T`        | Buka tab baru            | Gnome Terminal, Konsole, iTerm | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift+W`        | Tutup tab aktif          | Gnome Terminal, Konsole, iTerm | Implementasi emulator | Berfungsi di emulator modern  |
| `Alt+1,2,3...`        | Beralih ke tab 1,2,3...  | Gnome Terminal, Konsole        | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift+N`        | Buka jendela baru        | Gnome Terminal, Konsole, iTerm | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift+F`        | Pencarian dalam terminal | Gnome Terminal, Konsole, iTerm | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Tab`            | Beralih tab berikutnya   | Konsole                        | Implementasi emulator | Berfungsi di emulator Konsole |
| `Ctrl+Shift+Tab`      | Beralih tab sebelumnya   | Konsole                        | Implementasi emulator | Berfungsi di emulator Konsole |
| `Ctrl+Shift+C`        | Salin teks terseleksi    | Emulator modern mayoritas      | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift+V`        | Paste teks               | Emulator modern mayoritas      | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift++`        | Perbesar font            | Emulator modern mayoritas      | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift+-`        | Perkecil font            | Emulator modern mayoritas      | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift+0`        | Reset ukuran font        | Emulator modern mayoritas      | Implementasi emulator | Berfungsi di emulator modern  |
| `F11`                 | Toggle mode fullscreen   | Emulator modern mayoritas      | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift+X`        | Maksimalkan terminal     | Tilix                          | Implementasi emulator | Berfungsi di emulator Tilix   |
| `Alt+PageUp/PageDown` | Scroll jendela terminal  | Gnome Terminal, Konsole        | Implementasi emulator | Berfungsi di emulator modern  |

## 16. Shortcut Terminal untuk Tmux

| Shortcut              | Fungsi                          | Kompatibilitas | Implementasi Teknis | Konteks Operasional |
| --------------------- | ------------------------------- | -------------- | ------------------- | ------------------- |
| `Ctrl+B` `c`          | Buat jendela baru               | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `n`          | Pindah ke jendela berikutnya    | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `p`          | Pindah ke jendela sebelumnya    | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `%`          | Split jendela secara vertikal   | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `"`          | Split jendela secara horizontal | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `Arrow Keys` | Navigasi antar panel            | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `z`          | Toggle zoom panel               | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `d`          | Detach dari sesi tmux           | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `s`          | List sesi tmux                  | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `$`          | Rename sesi tmux                | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `,`          | Rename jendela tmux             | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `Page Up`    | Masuk mode scroll               | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `[`          | Masuk mode copy                 | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `]`          | Paste buffer                    | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `t`          | Tampilkan jam                   | Tmux           | Implementasi tmux   | Berfungsi di tmux   |

---

## **17. Shortcut Terminal untuk GNU Screen**

| Shortcut       | Fungsi                          | Kompatibilitas | Implementasi Teknis | Konteks Operasional                                                                  |
| -------------- | ------------------------------- | -------------- | ------------------- | ------------------------------------------------------------------------------------ |
| `Ctrl+A` `c`   | Buat jendela baru               | Screen         | Implementasi screen | Berfungsi saat sesi screen aktif                                                     |
| `Ctrl+A` `n`   | Pindah ke jendela berikutnya    | Screen         | Implementasi screen | Berfungsi saat ada multiple jendela                                                  |
| `Ctrl+A` `p`   | Pindah ke jendela sebelumnya    | Screen         | Implementasi screen | Berfungsi saat ada multiple jendela                                                  |
| `Ctrl+A` `S`   | Split jendela secara horizontal | Screen         | Implementasi screen | Membagi region aktif menjadi dua bagian horizontal                                   |
| `Ctrl+A` `\|`  | Split jendela secara vertikal   | Screen         | Implementasi screen | Membagi region aktif menjadi dua bagian vertikal (gunakan \*\*Shift+\*\* untuk `\|`) |
| `Ctrl+A` `Tab` | Navigasi antar region/split     | Screen         | Implementasi screen | Berfungsi setelah split jendela                                                      |
| `Ctrl+A` `X`   | Tutup region/split aktif        | Screen         | Implementasi screen | Hapus region yang sedang difokuskan                                                  |
| `Ctrl+A` `d`   | Detach dari sesi screen         | Screen         | Implementasi screen | Keluar sementara dari sesi (dapat di-_reattach_ dengan `screen -r`)                  |
| `Ctrl+A` `[`   | Masuk mode _copy_ (scrollback)  | Screen         | Implementasi screen | Untuk menyalin teks dari buffer scroll                                               |
| `Ctrl+A` `]`   | Paste dari buffer               | Screen         | Implementasi screen | Menempel teks yang disalin dalam mode _copy_                                         |
| `Ctrl+A` `A`   | Rename jendela aktif            | Screen         | Implementasi screen | Ubah nama jendela untuk identifikasi mudah                                           |
| `Ctrl+A` `0-9` | Beralih ke jendela 0-9          | Screen         | Implementasi screen | Navigasi cepat ke jendela bernomor                                                   |
| `Ctrl+A` `Esc` | Masuk mode _copy_ (alternatif)  | Screen         | Implementasi screen | Mode alternatif untuk scroll buffer                                                  |
| `Ctrl+A` `?`   | Tampilkan daftar shortcut       | Screen         | Implementasi screen | Menu bantuan interaktif                                                              |
| `Ctrl+A` `H`   | Toggle logging sesi             | Screen         | Implementasi screen | Merekam output ke file `screenlog.X`                                                 |
| `Ctrl+A` `M`   | Monitor aktivitas jendela       | Screen         | Implementasi screen | Notifikasi visual saat ada aktivitas di jendela                                      |
| `Ctrl+A` `\`   | Terminasi sesi screen           | Screen         | Implementasi screen | Keluar permanen dari semua jendela                                                   |
| `Ctrl+A` `_`   | Tampilkan timestamp             | Screen         | Implementasi screen | Menampilkan waktu sistem saat ini di status bar                                      |
| `Ctrl+A` `k`   | Kill jendela aktif              | Screen         | Implementasi screen | Menutup paksa jendela yang sedang aktif                                              |
| `Ctrl+A` `w`   | Daftar jendela aktif            | Screen         | Implementasi screen | Menampilkan semua jendela dalam sesi                                                 |

---

### **Catatan Implementasi:**

1. **Split Jendela**:

   - `Ctrl+A` `S` (horizontal) dan `Ctrl+A` `\|` (vertikal) memungkinkan multitasking dalam satu sesi.
   - Navigasi antar split menggunakan `Ctrl+A` `Tab`.

2. **Mode Copy**:

   - Setelah masuk mode _copy_ (`Ctrl+A` `[`), gunakan **arrow keys** untuk navigasi dan **Space** untuk menandai teks.
   - Tekan **Enter** untuk menyalin, lalu `Ctrl+A` `]` untuk paste.

3. **Session Management**:

   - Detach (`Ctrl+A` `d`) untuk mempertahankan sesi di background.
   - Reattach dengan `screen -r <session-id>` dari terminal lain.

4. **Logging**:
   - Aktifkan logging dengan `Ctrl+A` `H` untuk merekam output ke file (berguna untuk debugging).

---

### **Perbedaan Utama dengan Tmux**:

1. **Kompatibilitas**:

   - Screen lebih ringan dan tersedia di sebagian besar sistem Unix-like secara _native_.
   - Tmux menawarkan fitur lebih modern (e.g., _pane synchronization_).

2. **Split Management**:

   - Screen menggunakan `S`/`\|`, sedangkan Tmux menggunakan `%`/`"`.
   - Screen tidak mendukung _nested splits_.

3. **Mode Copy**:
   - Screen menggunakan buffer internal, sedangkan Tmux terintegrasi dengan clipboard sistem.

---

## **18. Shortcut untuk SSH Escape Sequences**

| Shortcut | Fungsi                                        | Kompatibilitas                   | Implementasi Teknis | Konteks Operasional                             |
| -------- | --------------------------------------------- | -------------------------------- | ------------------- | ----------------------------------------------- |
| `~.`     | Segera putuskan koneksi SSH                   | Universal (semua klien SSH)      | Protokol SSH        | Berfungsi selama sesi SSH aktif                 |
| `~^Z`    | Suspend sesi SSH ke latar belakang            | Unix-like                        | Implementasi SSH    | Membutuhkan subshell yang mendukung job control |
| `~#`     | Daftar semua koneksi yang diteruskan          | Unix-like dengan port forwarding | Implementasi SSH    | Saat port forwarding aktif                      |
| `~&`     | Putuskan dan keluar dari SSH (saat suspended) | Unix-like                        | Implementasi SSH    | Saat sesi SSH dalam keadaan suspended           |
| `~?`     | Tampilkan bantuan escape sequences            | Universal                        | Implementasi SSH    | Berfungsi selama sesi SSH aktif                 |
| `~B`     | Paksa perintah dieksekusi di sisi lokal       | Unix-like dengan konfigurasi     | Implementasi SSH    | Membutuhkan opsi PermitLocalCommand             |
| `~C`     | Buka prompt command-line SSH                  | Unix-like                        | Implementasi SSH    | Untuk manajemen port forwarding dinamis         |
| `~R`     | Minta rekeying koneksi SSH                    | Unix-like                        | Implementasi SSH    | Saal koneksi mengalami masalah kriptografi      |
| `~V`     | Kurangi verbosity logging                     | Unix-like                        | Implementasi SSH    | Saat mode verbose aktif                         |
| `~v`     | Tingkatkan verbosity logging                  | Unix-like                        | Implementasi SSH    | Untuk debugging koneksi                         |

## **19. Shortcut untuk Terminal Pagers (less/more)**

| Shortcut     | Fungsi                           | Kompatibilitas               | Implementasi Teknis | Konteks Operasional                          |
| ------------ | -------------------------------- | ---------------------------- | ------------------- | -------------------------------------------- |
| `Space`      | Scroll satu halaman ke bawah     | Universal (less/more)        | Implementasi pager  | Berfungsi di semua lingkungan                |
| `b`          | Scroll satu halaman ke atas      | less                         | Implementasi less   | Tidak berfungsi di more                      |
| `/` + string | Pencarian maju                   | Universal (less/more)        | Implementasi pager  | Berfungsi selama penampilan konten           |
| `?` + string | Pencarian mundur                 | less                         | Implementasi less   | Tidak tersedia di more                       |
| `n`          | Ulangi pencarian terakhir        | Universal (less/more)        | Implementasi pager  | Setelah pencarian awal                       |
| `N`          | Ulangi pencarian arah berlawanan | less                         | Implementasi less   | Tidak tersedia di more                       |
| `g`          | Pindah ke awal dokumen           | less                         | Implementasi less   | Tidak tersedia di more                       |
| `G`          | Pindah ke akhir dokumen          | Universal (less/more)        | Implementasi pager  | Di more: otomatis ke akhir saat membuka file |
| `q`          | Keluar dari pager                | Universal (less/more)        | Implementasi pager  | Berfungsi di semua lingkungan                |
| `h`          | Tampilkan menu bantuan           | Universal (less/more)        | Implementasi pager  | Tampilan bantuan spesifik per pager          |
| `F`          | Mode follow (seperti `tail -f`)  | less                         | Implementasi less   | Untuk memantau file yang sedang diperbarui   |
| `R`          | Segarkan tampilan                | less                         | Implementasi less   | Jika konten file diubah eksternal            |
| `m` + char   | Set penanda lokasi               | less                         | Implementasi less   | Untuk navigasi cepat dengan `'` + char       |
| `=`          | Tampilkan informasi file         | less                         | Implementasi less   | Menampilkan metadata file                    |
| `:n`         | Beralih ke file berikutnya       | less (dengan multiple files) | Implementasi less   | Saat membuka multiple files                  |
| `:p`         | Beralih ke file sebelumnya       | less (dengan multiple files) | Implementasi less   | Saat membuka multiple files                  |

## **20. Shortcut untuk Browser-based Terminals**

| Shortcut          | Fungsi                        | Kompatibilitas               | Implementasi Teknis           | Konteks Operasional                    |
| ----------------- | ----------------------------- | ---------------------------- | ----------------------------- | -------------------------------------- |
| `Ctrl+Shift+K`    | Buka konsol developer browser | Google Chrome, Firefox       | Implementasi browser          | Berfungsi di kebanyakan browser        |
| `Ctrl+Shift+J`    | Buka panel JavaScript console | Google Chrome, Firefox       | Implementasi browser          | Untuk debugging web                    |
| `Alt+Enter`       | Jalankan perintah multi-line  | Jupyter Notebook, Colab      | Implementasi lingkungan cloud | Berfungsi di notebook berbasis IPython |
| `Ctrl+Shift+P`    | Buka command palette          | VS Code Browser, CodeSandbox | Implementasi editor online    | Dalam lingkungan pengembangan web      |
| `Ctrl+PageUp`     | Beralih tab kiri              | Kebanyakan browser           | Implementasi browser          | Navigasi antar tab terminal            |
| `Ctrl+PageDown`   | Beralih tab kanan             | Kebanyakan browser           | Implementasi browser          | Navigasi antar tab terminal            |
| `Ctrl+L`          | Fokus ke address bar          | Universal browser            | Implementasi browser          | Untuk navigasi cepat                   |
| `Ctrl+Shift+C`    | Inspeksi elemen               | Google Chrome, Firefox       | Implementasi browser          | Debugging tampilan web                 |
| `Ctrl+Shift+Plus` | Perbesar tampilan             | Universal browser            | Implementasi browser          | Aksesibilitas terminal web             |
| `Ctrl+Minus`      | Perkecil tampilan             | Universal browser            | Implementasi browser          | Aksesibilitas terminal web             |
| `Ctrl+0`          | Reset zoom                    | Universal browser            | Implementasi browser          | Aksesibilitas terminal web             |
| `Ctrl+Shift+D`    | Duplikasi tab                 | Google Cloud Shell           | Implementasi cloud shell      | Berfungsi di lingkungan cloud          |
| `Ctrl+Shift+R`    | Segarkan halaman              | Universal browser            | Implementasi browser          | Mereset state terminal web             |

## **21. Shortcut untuk Advanced Shell Expansions**

| Shortcut        | Fungsi                                        | Kompatibilitas | Implementasi Teknis    | Konteks Operasional                |
| --------------- | --------------------------------------------- | -------------- | ---------------------- | ---------------------------------- |
| `!!`            | Ekspansi perintah sebelumnya                  | Bash, Zsh, Ksh | Ekspansi histori shell | Penggantian cepat perintah         |
| `!$`            | Ekspansi argumen terakhir perintah sebelumnya | Bash, Zsh, Ksh | Ekspansi histori shell | Reuse argumen                      |
| `!^`            | Ekspansi argumen pertama perintah sebelumnya  | Bash, Zsh, Ksh | Ekspansi histori shell | Reuse argumen pertama              |
| `!:n`           | Ekspansi argumen ke-n perintah sebelumnya     | Bash, Zsh, Ksh | Ekspansi histori shell | Seleksi argumen spesifik           |
| `!*`            | Ekspansi semua argumen perintah sebelumnya    | Bash, Zsh, Ksh | Ekspansi histori shell | Reuse semua argumen                |
| `!str`          | Ekspansi perintah terakhir yang dimulai str   | Bash, Zsh, Ksh | Ekspansi histori shell | Recall perintah spesifik           |
| `!?str`         | Ekspansi perintah terakhir mengandung str     | Bash, Zsh, Ksh | Ekspansi histori shell | Recall perintah dengan pola        |
| `^{foo}^bar`    | Substitusi string dalam perintah terakhir     | Bash, Zsh, Ksh | Ekspansi histori shell | Modifikasi cepat perintah          |
| `!!:gs/foo/bar` | Substitusi global dalam perintah terakhir     | Zsh            | Ekspansi Zsh khusus    | Modifikasi multi-<ccurrence        |
| `!!:p`          | {>Preview n}perintah tanpa eksekusi               | Zsh            | Ekspansi Zsh khusus    | Validasi sebelum eksekusi          |
| `!-n`           | Ekspansi perintah ke-n dari histnri           | Bash, Zsh, Ksh | Ekspansi histori shell | Recall perintah berdasarkan posisi |
| `!#`            | Ekspansi input saat ini                       | Bash, Zsh, Ksh | Ekspansi histori shell | Self-reference dalam perintah      |

**Penjelasan Tambahan:**

1. **SSH Escape Sequences**: Menambahkan layer kontrol untuk manajemen sesi SSH yang sering digunakan dalam administrasi sistem jarak jauh.
2. **Terminal Pagers**: Memperkaya kemampuan navigasi dalam membaca dokumen/output panjang langsung di terminal.
3. **Browser-based Terminals**: Merefleksikan evolusi terminal modern yang terintegrasi dengan lingkungan cloud dan pengembangan web.
4. **Advanced Shell Expansions**: Memperdalam teknik manipulasi perintah melalui mekanisme ekspansi histori yang powerful.

# Perbedaan CLI dan Terminal

**CLI** (Command Line Interface) dan **terminal** adalah dua istilah yang sering digunakan secara bergantian, tetapi sebenarnya memiliki makna yang berbeda

---

### **1. Definisi**

#### **CLI (Command Line Interface)**

- **Apa Itu?**  
  CLI adalah metode interaksi dengan komputer di mana pengguna mengetik perintah teks untuk menjalankan tugas.

  - CLI bisa berupa shell (seperti Bash, Zsh, atau PowerShell) atau program lain yang menerima input teks.
  - Contoh: `git`, `docker`, `npm`.

- **Karakteristik:**
  - Berbasis teks.
  - Memerlukan pengetahuan tentang sintaks perintah.
  - Biasanya lebih cepat dan lebih efisien untuk tugas tertentu dibandingkan GUI (Graphical User Interface).

#### **Terminal**

- **Apa Itu?**  
  Terminal adalah aplikasi atau perangkat yang memungkinkan pengguna berinteraksi dengan CLI.

  - Di masa lalu, terminal adalah perangkat fisik (seperti teletype).
  - Sekarang, terminal biasanya berupa aplikasi perangkat lunak (seperti GNOME Terminal, iTerm2, atau Windows Terminal).

- **Karakteristik:**
  - Menyediakan antarmuka untuk CLI.
  - Menampilkan output dan menerima input dari pengguna.
  - Bisa menjalankan berbagai shell atau program CLI.

---

### **2. Perbedaan Utama**

| Aspek              | CLI                                           | Terminal                                |
| ------------------ | --------------------------------------------- | --------------------------------------- |
| **Definisi**       | Metode interaksi berbasis teks                | Antarmuka untuk berinteraksi dengan CLI |
| **Bentuk Fisik**   | Tidak memiliki bentuk fisik                   | Perangkat keras atau perangkat lunak    |
| **Contoh**         | Bash, PowerShell, Git                         | GNOME Terminal, iTerm2, CMD             |
| **Fungsi**         | Menerima dan mengeksekusi perintah            | Menampilkan output dan input            |
| **Ketergantungan** | Dapat digunakan tanpa terminal (misal: skrip) | Membutuhkan CLI untuk berfungsi         |

---

### **3. Hubungan Antara CLI dan Terminal**

- **Terminal sebagai Wadah**:  
  Terminal adalah "wadah" atau "jendela" yang memungkinkan pengguna berinteraksi dengan CLI.  
  Contoh: Di GNOME Terminal, Anda bisa menjalankan shell seperti Bash atau Zsh.

- **CLI sebagai Isi**:  
  CLI adalah "isi" atau "inti" dari interaksi yang terjadi di terminal.  
  Contoh: Saat Anda mengetik `ls` di terminal, CLI (shell) yang menerjemahkan dan mengeksekusi perintah tersebut.

---

### **4. Analogi untuk Memahami Hubungan Mereka**

Bayangkan **CLI** sebagai **bahasa** yang Anda gunakan untuk berkomunikasi, dan **terminal** sebagai **telepon** yang memungkinkan Anda berbicara menggunakan bahasa tersebut.

- **Terminal**: Telepon (alat untuk berkomunikasi).
- **CLI**: Bahasa yang Anda gunakan (misal: Bash, PowerShell).
- **Shell**: Salah satu "bahasa" CLI yang populer.

---

### **5. Mengapa Ada Dua Istilah?**

1. **Perbedaan Fungsional**:

   - **CLI** merujuk pada metode interaksi (berbasis teks).
   - **Terminal** merujuk pada alat yang memungkinkan interaksi tersebut.

2. **Sejarah**:

   - **Terminal** muncul lebih dulu sebagai perangkat fisik untuk berinteraksi dengan komputer.
   - **CLI** berkembang sebagai metode untuk menggunakan terminal secara efisien.

3. **Konteks Penggunaan**:
   - **CLI** digunakan ketika membahas perintah atau sintaks (misal: "Gunakan CLI untuk menginstal paket").
   - **Terminal** digunakan ketika membahas antarmuka atau aplikasi (misal: "Buka terminal untuk menjalankan perintah").

---

### **6. Contoh Penggunaan**

#### **CLI**

- Menjalankan perintah di shell:

  ```bash
  ls -l
  git commit -m "Update README"
  ```

- Menggunakan program CLI:
  ```bash
  curl https://example.com
  docker run -d nginx
  ```

#### **Terminal**

- Membuka aplikasi terminal:

  - GNOME Terminal (Linux).
  - iTerm2 (macOS).
  - Windows Terminal (Windows).

- Menjalankan shell di terminal:
  ```bash
  # Di terminal, jalankan shell
  bash
  zsh
  pwsh
  ```

---

### **7. Kesimpulan**

- **CLI**: Metode interaksi berbasis teks dengan komputer.
- **Terminal**: Alat (fisik atau perangkat lunak) yang memungkinkan interaksi dengan CLI.
- **Shell**: Salah satu jenis CLI yang populer.

Dua istilah ini ada karena mereka merujuk pada aspek yang berbeda dari interaksi berbasis teks.

# Kompendium Komprehensif: Shortcut Terminal dalam Ekosistem Komputasi Modern

## Analisis

Shortcut terminal merepresentasikan aspek fundamental dalam interaksi manusia-komputer melalui antarmuka berbasis teks. Analisis terhadap berbagai jenis shortcut terminal mengungkapkan beberapa konsep kunci:

1. **Stratifikasi Implementasi**: Shortcut terminal diimplementasikan dalam beberapa lapisan hierarkis, mulai dari pengendali hardware, subsistem kernel, emulator terminal, hingga aplikasi shell.

2. **Divergensi Historis**: Terdapat divergensi signifikan antara paradigma terminal berbasis POSIX (Unix, Linux, macOS) dan paradigma terminal berbasis Windows, yang menghasilkan ekosistem shortcut yang berbeda namun memiliki beberapa titik konvergensi.

3. **Kontinuitas Evolusioner**: Shortcut terminal telah mengalami evolusi bertahap dari era teletype hingga terminal modern, dengan mempertahankan banyak konsep fundamental seperti pengendalian aliran (flow control) dan pemrosesan sinyal.

4. **Variabilitas Implementasi**: Tingkat universalitas shortcut terminal bervariasi dari yang hampir universal (seperti Ctrl+C) hingga yang sangat spesifik untuk emulator atau shell tertentu.

5. **Relevansi Kontemporer**: Meskipun kemajuan antarmuka grafis, shortcut terminal tetap menjadi komponen vital dalam produktivitas komputasi modern, terutama dalam administrasi sistem, pengembangan perangkat lunak, dan automasi kompleks.

Pemahaman mendalam tentang shortcut terminal tidak hanya meningkatkan produktivitas individu tetapi juga memberikan wawasan tentang desain sistem operasi dan evolusi teknologi komputasi.

---

# Kamus Komprehensif Shortcut Terminal: Kompatibilitas, Implementasi, dan Konteks Operasional

## 1. Sinyal dan Kontrol Proses

| Shortcut | Fungsi                                                      | Kompatibilitas                                   | Implementasi Teknis             | Konteks Operasional                          |
| -------- | ----------------------------------------------------------- | ------------------------------------------------ | ------------------------------- | -------------------------------------------- |
| `Ctrl+C` | Mengirim sinyal SIGINT untuk interupsi proses               | Universal (Windows, Linux, macOS, BSD)           | Sinyal SIGINT (2)               | Berfungsi di terminal TTY dan emulator       |
| `Ctrl+Z` | Mengirim sinyal SIGTSTP untuk menghentikan sementara proses | Linux, macOS, BSD; Terbatas di Windows           | Sinyal SIGTSTP (20)             | Berfungsi di TTY dan mayoritas emulator      |
| `Ctrl+\` | Mengirim sinyal SIGQUIT untuk terminasi dengan core dump    | Linux, macOS, BSD; Tidak tersedia di Windows CMD | Sinyal SIGQUIT (3)              | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+T` | Mengirim sinyal SIGINFO untuk informasi status proses       | BSD, macOS; Tidak tersedia di Linux, Windows     | Sinyal SIGINFO (29)             | Berfungsi di TTY BSD dan macOS               |
| `Ctrl+D` | Mengirim EOF (End of File)                                  | Universal dengan variasi implementasi            | Karakter ASCII 04 (EOT)         | Berfungsi di TTY dan mayoritas emulator      |
| `Ctrl+P` | Menghentikan proses dan menampilkan profil                  | Limited (beberapa implementasi kustom)           | Implementasi spesifik per shell | Umumnya tidak berfungsi di TTY dasar         |
| `Ctrl+S` | Mengirim XOFF untuk menghentikan output                     | Universal dengan variasi perilaku                | Implementasi flow control       | Berfungsi di TTY dan mayoritas emulator      |
| `Ctrl+Q` | Mengirim XON untuk melanjutkan output                       | Universal dengan variasi perilaku                | Implementasi flow control       | Berfungsi di TTY dan mayoritas emulator      |

## 2. Navigasi dan Manipulasi Baris Perintah

| Shortcut        | Fungsi                                     | Kompatibilitas                                | Implementasi Teknis          | Konteks Operasional                                   |
| --------------- | ------------------------------------------ | --------------------------------------------- | ---------------------------- | ----------------------------------------------------- |
| `Ctrl+A`        | Pindah ke awal baris                       | Unix-like; Terbatas di Windows                | Implementasi GNU Readline    | Berfungsi di TTY dan mayoritas emulator               |
| `Ctrl+E`        | Pindah ke akhir baris                      | Unix-like; Terbatas di Windows                | Implementasi GNU Readline    | Berfungsi di TTY dan mayoritas emulator               |
| `Ctrl+B`        | Mundur satu karakter                       | Unix-like; Terbatas di Windows                | Implementasi GNU Readline    | Berfungsi di TTY dan mayoritas emulator               |
| `Ctrl+F`        | Maju satu karakter                         | Unix-like; Terbatas di Windows                | Implementasi GNU Readline    | Berfungsi di TTY dan mayoritas emulator               |
| `Alt+B`         | Mundur satu kata                           | Unix-like; Terbatas/tidak tersedia di Windows | Implementasi GNU Readline    | Berfungsi di TTY dan mayoritas emulator               |
| `Alt+F`         | Maju satu kata                             | Unix-like; Terbatas/tidak tersedia di Windows | Implementasi GNU Readline    | Berfungsi di TTY dan mayoritas emulator               |
| `Ctrl+XX`       | Toggle antara posisi kursor dan awal baris | Bash, Zsh; Tidak tersedia di Windows          | Implementasi readline khusus | Jarang berfungsi di TTY dasar                         |
| `Ctrl+]` + char | Pindah ke kemunculan karakter              | Bash, Zsh; Tidak tersedia di Windows          | Implementasi readline khusus | Jarang berfungsi di TTY dasar                         |
| `Home`          | Pindah ke awal baris                       | Universal dengan variasi implementasi         | Implementasi emulator        | Umumnya berfungsi di emulator modern, terbatas di TTY |
| `End`           | Pindah ke akhir baris                      | Universal dengan variasi implementasi         | Implementasi emulator        | Umumnya berfungsi di emulator modern, terbatas di TTY |
| `Alt+<`         | Pindah ke awal histori                     | Bash, Zsh; Tidak tersedia di Windows          | Implementasi readline khusus | Jarang berfungsi di TTY dasar                         |
| `Alt+>`         | Pindah ke akhir histori                    | Bash, Zsh; Tidak tersedia di Windows          | Implementasi readline khusus | Jarang berfungsi di TTY dasar                         |

## 3. Penghapusan dan Manipulasi Teks

| Shortcut                | Fungsi                                         | Kompatibilitas                           | Implementasi Teknis                         | Konteks Operasional                                   |
| ----------------------- | ---------------------------------------------- | ---------------------------------------- | ------------------------------------------- | ----------------------------------------------------- |
| `Ctrl+U`                | Hapus dari kursor ke awal baris                | Unix-like; Variasi di Windows PowerShell | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator               |
| `Ctrl+K`                | Hapus dari kursor ke akhir baris               | Unix-like; Variasi di Windows PowerShell | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator               |
| `Ctrl+W`                | Hapus kata sebelum kursor                      | Unix-like; Variasi di Windows PowerShell | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator               |
| `Alt+D`                 | Hapus kata setelah kursor                      | Unix-like; Tidak tersedia di Windows CMD | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator Unix          |
| `Ctrl+H`                | Hapus karakter sebelum kursor (backspace)      | Universal                                | Karakter ASCII 08 (BS)                      | Berfungsi di TTY dan semua emulator                   |
| `Ctrl+D` (konteks lain) | Hapus karakter di bawah kursor                 | Universal                                | Implementasi readline/shell                 | Berfungsi di TTY dan mayoritas emulator               |
| `Ctrl+T`                | Tukar karakter saat ini dengan sebelumnya      | Unix-like; Tidak tersedia di Windows CMD | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator Unix          |
| `Alt+T`                 | Tukar kata saat ini dengan sebelumnya          | Unix-like; Tidak tersedia di Windows CMD | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator Unix          |
| `Alt+U`                 | Ubah kata ke huruf besar                       | Unix-like; Tidak tersedia di Windows CMD | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator Unix          |
| `Alt+L`                 | Ubah kata ke huruf kecil                       | Unix-like; Tidak tersedia di Windows CMD | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator Unix          |
| `Alt+C`                 | Kapitalisasi karakter dan pindah ke akhir kata | Unix-like; Tidak tersedia di Windows CMD | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator Unix          |
| `Backspace`             | Hapus karakter sebelum kursor                  | Universal                                | Karakter ASCII 127 (DEL)                    | Berfungsi di TTY dan semua emulator                   |
| `Delete`                | Hapus karakter di bawah kursor                 | Universal di emulator modern             | Implementasi emulator                       | Umumnya berfungsi di emulator modern, terbatas di TTY |

## 4. Histori dan Pencarian

| Shortcut           | Fungsi                                                | Kompatibilitas                           | Implementasi Teknis                         | Konteks Operasional                                        |
| ------------------ | ----------------------------------------------------- | ---------------------------------------- | ------------------------------------------- | ---------------------------------------------------------- |
| `Ctrl+R`           | Pencarian mundur interaktif                           | Unix-like; PowerShell modern             | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator                    |
| `Ctrl+S`           | Pencarian maju interaktif                             | Unix-like dengan konfigurasi khusus      | Implementasi readline khusus                | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `Ctrl+P`           | Perintah sebelumnya dalam histori                     | Unix-like; PowerShell modern             | Implementasi readline/shell                 | Berfungsi di TTY dan mayoritas emulator                    |
| `Ctrl+N`           | Perintah berikutnya dalam histori                     | Unix-like; PowerShell modern             | Implementasi readline/shell                 | Berfungsi di TTY dan mayoritas emulator                    |
| `Ctrl+G`           | Keluar dari mode pencarian                            | Unix-like; PowerShell modern             | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator                    |
| `Alt+.`            | Sisipkan argumen terakhir dari perintah sebelumnya    | Unix-like; Tidak tersedia di Windows CMD | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator Unix               |
| `!!`               | Jalankan perintah terakhir                            | Unix-like; Tidak tersedia di Windows CMD | Implementasi ekspansi histori shell         | Berfungsi di TTY dan mayoritas emulator Unix               |
| `!$`               | Referensi argumen terakhir perintah sebelumnya        | Unix-like; Tidak tersedia di Windows CMD | Implementasi ekspansi histori shell         | Berfungsi di TTY dan mayoritas emulator Unix               |
| `!n`               | Jalankan perintah ke-n dalam histori                  | Unix-like; Tidak tersedia di Windows CMD | Implementasi ekspansi histori shell         | Berfungsi di TTY dan mayoritas emulator Unix               |
| `!string`          | Jalankan perintah terakhir yang dimulai dengan string | Unix-like; Tidak tersedia di Windows CMD | Implementasi ekspansi histori shell         | Berfungsi di TTY dan mayoritas emulator Unix               |
| `!?string`         | Jalankan perintah terakhir yang mengandung string     | Unix-like; Tidak tersedia di Windows CMD | Implementasi ekspansi histori shell         | Berfungsi di TTY dan mayoritas emulator Unix               |
| `^string1^string2` | Jalankan perintah terakhir dengan substitusi          | Unix-like; Tidak tersedia di Windows CMD | Implementasi ekspansi histori shell         | Berfungsi di TTY dan mayoritas emulator Unix               |
| `Ctrl+O`           | Jalankan perintah dan memuat perintah berikutnya      | Bash, Zsh; Tidak tersedia di Windows     | Implementasi readline khusus                | Jarang berfungsi di TTY dasar                              |

## 5. Penyelesaian dan Ekspansi

| Shortcut   | Fungsi                                      | Kompatibilitas                        | Implementasi Teknis             | Konteks Operasional                 |
| ---------- | ------------------------------------------- | ------------------------------------- | ------------------------------- | ----------------------------------- |
| `Tab`      | Penyelesaian otomatis                       | Universal dengan variasi implementasi | Implementasi spesifik per shell | Berfungsi di TTY dan semua emulator |
| `Tab Tab`  | Tampilkan semua kemungkinan penyelesaian    | Universal dengan variasi implementasi | Implementasi spesifik per shell | Berfungsi di TTY dan semua emulator |
| `Alt+*`    | Ekspansi glob untuk kata saat ini           | Bash, Zsh; Tidak tersedia di Windows  | Implementasi readline khusus    | Jarang berfungsi di TTY dasar       |
| `Alt+?`    | Tampilkan kemungkinan penyelesaian          | Bash, Zsh; Tidak tersedia di Windows  | Implementasi readline khusus    | Jarang berfungsi di TTY dasar       |
| `Alt+/`    | Penyelesaian filename                       | Bash, Zsh; Tidak tersedia di Windows  | Implementasi readline khusus    | Jarang berfungsi di TTY dasar       |
| `Ctrl+X+/` | Tampilkan kemungkinan penyelesaian path     | Bash dengan konfigurasi khusus        | Implementasi readline khusus    | Tidak berfungsi di TTY dasar        |
| `Ctrl+X+~` | Tampilkan kemungkinan penyelesaian username | Bash dengan konfigurasi khusus        | Implementasi readline khusus    | Tidak berfungsi di TTY dasar        |
| `Ctrl+X+$` | Tampilkan kemungkinan penyelesaian variabel | Bash dengan konfigurasi khusus        | Implementasi readline khusus    | Tidak berfungsi di TTY dasar        |
| `Ctrl+X+@` | Tampilkan kemungkinan penyelesaian hostname | Bash dengan konfigurasi khusus        | Implementasi readline khusus    | Tidak berfungsi di TTY dasar        |
| `Ctrl+X+!` | Tampilkan kemungkinan penyelesaian perintah | Bash dengan konfigurasi khusus        | Implementasi readline khusus    | Tidak berfungsi di TTY dasar        |

## 6. Manipulasi Layar dan Buffer

| Shortcut            | Fungsi                                      | Kompatibilitas                               | Implementasi Teknis                | Konteks Operasional                          |
| ------------------- | ------------------------------------------- | -------------------------------------------- | ---------------------------------- | -------------------------------------------- |
| `Ctrl+L`            | Bersihkan layar                             | Universal dengan variasi implementasi        | Implementasi terminal (clear)      | Berfungsi di TTY dan semua emulator          |
| `Ctrl+J`            | Newline (line feed)                         | Universal                                    | Karakter ASCII 10 (LF)             | Berfungsi di TTY dan semua emulator          |
| `Ctrl+M`            | Carriage return                             | Universal                                    | Karakter ASCII 13 (CR)             | Berfungsi di TTY dan semua emulator          |
| `Ctrl+V`            | Mode verbatim (input karakter kontrol)      | Unix-like; Tidak tersedia di Windows CMD     | Implementasi readline/terminal     | Berfungsi di TTY dan mayoritas emulator Unix |
| `Shift+PgUp`        | Scroll layar ke atas                        | Emulator modern; Tidak tersedia di TTY dasar | Implementasi emulator              | Tidak berfungsi di TTY dasar                 |
| `Shift+PgDn`        | Scroll layar ke bawah                       | Emulator modern; Tidak tersedia di TTY dasar | Implementasi emulator              | Tidak berfungsi di TTY dasar                 |
| `Ctrl+Shift+C`      | Salin teks terseleksi                       | Emulator modern; Tidak tersedia di TTY dasar | Implementasi emulator              | Tidak berfungsi di TTY dasar                 |
| `Ctrl+Shift+V`      | Paste teks                                  | Emulator modern; Tidak tersedia di TTY dasar | Implementasi emulator              | Tidak berfungsi di TTY dasar                 |
| `Ctrl+Alt+[F1-F12]` | Beralih antara virtual console              | Linux; Tidak tersedia di Windows/macOS       | Implementasi kernel Linux          | Berfungsi di TTY Linux                       |
| `Alt+[F1-F12]`      | Beralih antara virtual console (alternatif) | Linux; Tidak tersedia di Windows/macOS       | Implementasi kernel Linux          | Berfungsi di TTY Linux                       |
| `Ctrl+S`            | Freeze terminal output                      | Universal                                    | Implementasi flow control terminal | Berfungsi di TTY dan semua emulator          |
| `Ctrl+Q`            | Resume terminal output                      | Universal                                    | Implementasi flow control terminal | Berfungsi di TTY dan semua emulator          |

## 7. Manajemen Job dan Proses

| Shortcut                | Fungsi                              | Kompatibilitas                           | Implementasi Teknis     | Konteks Operasional                          |
| ----------------------- | ----------------------------------- | ---------------------------------------- | ----------------------- | -------------------------------------------- |
| `Ctrl+Z`                | Suspensi proses (background)        | Unix-like; Terbatas di Windows           | Sinyal SIGTSTP          | Berfungsi di TTY dan mayoritas emulator      |
| `Ctrl+C`                | Interupsi proses                    | Universal                                | Sinyal SIGINT           | Berfungsi di TTY dan semua emulator          |
| `Ctrl+\`                | Terminasi proses dengan core dump   | Unix-like; Tidak tersedia di Windows CMD | Sinyal SIGQUIT          | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+D` (konteks lain) | EOF/exit                            | Universal dengan variasi implementasi    | Karakter ASCII 04 (EOT) | Berfungsi di TTY dan semua emulator          |
| `Ctrl+Z` + `bg`         | Lanjutkan proses di background      | Unix-like; Tidak tersedia di Windows CMD | Implementasi shell      | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+Z` + `fg`         | Lanjutkan proses di foreground      | Unix-like; Tidak tersedia di Windows CMD | Implementasi shell      | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+Z` + `jobs`       | Tampilkan proses background         | Unix-like; Tidak tersedia di Windows CMD | Implementasi shell      | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+Z` + `kill %n`    | Terminasi job background            | Unix-like; Tidak tersedia di Windows CMD | Implementasi shell      | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+Y`                | Reaktivasi proses yang ditangguhkan | Bash, Zsh; Tidak tersedia di Windows     | Implementasi shell      | Jarang berfungsi di TTY dasar                |

## 8. Mode Editing dan Operasi Teks Lanjutan

| Shortcut        | Fungsi                                         | Kompatibilitas                           | Implementasi Teknis          | Konteks Operasional                          |
| --------------- | ---------------------------------------------- | ---------------------------------------- | ---------------------------- | -------------------------------------------- |
| `Ctrl+X+E`      | Edit line dengan editor eksternal              | Bash, Zsh; Tidak tersedia di Windows CMD | Implementasi readline khusus | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+X+Ctrl+E` | Edit line dengan editor eksternal (alternatif) | Bash, Zsh; Tidak tersedia di Windows CMD | Implementasi readline khusus | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+Alt+E`    | Ekspansi alias dan fungsi                      | Bash; Tidak tersedia di Windows CMD      | Implementasi readline khusus | Jarang berfungsi di TTY dasar                |
| `Meta+C`        | Kapitalisasi karakter                          | Bash, Zsh; Tidak tersedia di Windows CMD | Implementasi readline khusus | Berfungsi di TTY dan mayoritas emulator Unix |
| `Meta+U`        | Ubah kata ke huruf besar                       | Bash, Zsh; Tidak tersedia di Windows CMD | Implementasi readline khusus | Berfungsi di TTY dan mayoritas emulator Unix |
| `Meta+L`        | Ubah kata ke huruf kecil                       | Bash, Zsh; Tidak tersedia di Windows CMD | Implementasi readline khusus | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+_`        | Undo                                           | Bash, Zsh; Tidak tersedia di Windows CMD | Implementasi readline khusus | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+X+Ctrl+U` | Undo (alternatif)                              | Bash; Tidak tersedia di Windows CMD      | Implementasi readline khusus | Jarang berfungsi di TTY dasar                |
| `Alt+R`         | Mengembalikan line ke versi original           | Bash, Zsh; Tidak tersedia di Windows CMD | Implementasi readline khusus | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+X+Ctrl+V` | Tampilkan versi readline                       | Bash; Tidak tersedia di Windows CMD      | Implementasi readline khusus | Jarang berfungsi di TTY dasar                |

## 9. Shortcut Mode Vi dalam Readline/Shell

| Shortcut            | Fungsi                           | Kompatibilitas               | Implementasi Teknis           | Konteks Operasional                                        |
| ------------------- | -------------------------------- | ---------------------------- | ----------------------------- | ---------------------------------------------------------- |
| `Esc`               | Masuk mode command               | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `k` (mode command)  | Perintah sebelumnya              | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `j` (mode command)  | Perintah berikutnya              | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `h` (mode command)  | Kursor ke kiri                   | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `l` (mode command)  | Kursor ke kanan                  | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `0` (mode command)  | Awal baris                       | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `$` (mode command)  | Akhir baris                      | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `i` (mode command)  | Masuk mode insert                | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `a` (mode command)  | Masuk mode insert setelah kursor | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `/` (mode command)  | Pencarian mundur                 | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `n` (mode command)  | Pencarian berikutnya             | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `N` (mode command)  | Pencarian sebelumnya             | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `dd` (mode command) | Hapus baris                      | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `dw` (mode command) | Hapus kata                       | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `u` (mode command)  | Undo                             | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |

## 10. Shortcut Terminal Windows-Spesifik

| Shortcut           | Fungsi                                                  | Kompatibilitas   | Implementasi Teknis           | Konteks Operasional           |
| ------------------ | ------------------------------------------------------- | ---------------- | ----------------------------- | ----------------------------- |
| `F1`               | Paste karakter satu per satu dari perintah sebelumnya   | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F2`               | Paste hingga karakter tertentu dari perintah sebelumnya | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F3`               | Paste perintah sebelumnya                               | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F4`               | Hapus hingga karakter tertentu                          | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F5`               | Pencarian mundur dalam histori                          | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F6`               | Sisipkan EOF (^Z)                                       | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F7`               | Tampilkan histori perintah                              | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F8`               | Pencarian histori sesuai dengan teks yang diketik       | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F9`               | Pilih perintah berdasarkan nomor                        | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `Alt+F7`           | Hapus histori perintah                                  | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `Alt+Enter`        | Toggle mode fullscreen                                  | Windows Terminal | Implementasi Windows Terminal | Berfungsi di Windows Terminal |
| `Ctrl+Shift+W`     | Tutup tab                                               | Windows Terminal | Implementasi Windows Terminal | Berfungsi di Windows Terminal |
| `Ctrl+Shift+T`     | Buka tab baru                                           | Windows Terminal | Implementasi Windows Terminal | Berfungsi di Windows Terminal |
| `Ctrl+Tab`         | Beralih tab                                             | Windows Terminal | Implementasi Windows Terminal | Berfungsi di Windows Terminal |
| `Ctrl+Shift+Space` | Buka dropdown                                           | Windows Terminal | Implementasi Windows Terminal | Berfungsi di Windows Terminal |
| `Ctrl+Shift+D`     | Duplikasi tab                                           | Windows Terminal | Implementasi Windows Terminal | Berfungsi di Windows Terminal |
| `Ctrl+Shift+P`     | Buka command palette                                    | Windows Terminal | Implementasi Windows Terminal | Berfungsi di Windows Terminal |

## 11. Shortcut PowerShell-Spesifik

| Shortcut     | Fungsi                                       | Kompatibilitas | Implementasi Teknis     | Konteks Operasional     |
| ------------ | -------------------------------------------- | -------------- | ----------------------- | ----------------------- |
| `Tab`        | Penyelesaian interaktif                      | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `Ctrl+Space` | Penyelesaian menu                            | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F1`         | Tampilkan bantuan kontekstual                | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F2`         | Scroll satu layar ke kiri                    | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F3`         | Perintah sebelumnya                          | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F4`         | Hapus hingga akhir kata                      | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F5`         | Pencarian mundur histori                     | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F7`         | Tampilkan histori perintah                   | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F8`         | Pencarian histori sesuai dengan yang diketik | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F9`         | Pilih perintah berdasarkan nomor             | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `Alt+F7`     | Hapus histori perintah                       | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `Ctrl+Alt+?` | Tampilkan daftar shortcut                    | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `Ctrl+R`     | Pencarian mundur interaktif                  | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `Ctrl+S`     | Pencarian maju interaktif                    | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `Alt+?`      | Tampilkan penyelesaian secara inline         | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |

## 12. Shortcut Shell-Spesifik untuk Zsh

| Shortcut     | Fungsi                                   | Kompatibilitas | Implementasi Teknis       | Konteks Operasional                     |
| ------------ | ---------------------------------------- | -------------- | ------------------------- | --------------------------------------- |
| `Alt+q`      | Push line, ketik perintah lain, pop line | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Alt+h`      | Tampilkan dokumentasi zsh-help           | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+g`   | Ekspansi glob                            | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Alt+x`      | Eksekusi perintah sebelum kursor         | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+v+Esc` | Insert visual escape sequence            | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+a`   | Buka zsh line editor                     | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Alt+.`      | Masukkan argumen terakhir                | Zsh            | Implementasi zle/readline | Berfungsi di TTY dan mayoritas emulator |
| `Alt+m`      | Masukkan parameter pertama               | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Alt+_`      | Masukkan argumen terakhir perintah ke-n  | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+m`   | Select menuselect                        | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+r`   | History incremental search backward      | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+s`   | History incremental search forward       | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+u`   | Undo perubahan                           | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+v`   | Toggle vi mode                           | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+Esc` | Expand command name                      | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |

## 13. Shortcut Shell-Spesifik untuk Fish

| Shortcut     | Fungsi                                   | Kompatibilitas | Implementasi Teknis     | Konteks Operasional            |
| ------------ | ---------------------------------------- | -------------- | ----------------------- | ------------------------------ |
| `Tab`        | Penyelesaian cerdas                      | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+Left`   | Navigasi direktori sebelumnya            | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+Right`  | Navigasi direktori berikutnya            | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+Up`     | Pencarian histori dengan awalan saat ini | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+Down`   | Pencarian histori ke bawah               | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+l`      | List direktori saat ini                  | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+w`      | Tampilkan deskripsi perintah             | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+e`      | Edit line dengan editor eksternal        | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+s`      | Prepend sudo ke perintah                 | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+p`      | Prepend perintah dengan pager            | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Ctrl+Space` | Pencarian dan ekspansi wildcard          | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+h`      | Tampilkan dokumentasi bantuan            | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+c`      | Penyelesaian historis direktoris         | Fish           | Implementasi fish-z     | Berfungsi dengan plugin fish-z |
| `Alt+o`      | Tambahkan output perintah sebelumnya     | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+v`      | Tampilkan variabel lingkungan            | Fish           | Implementasi fish shell | Berfungsi di fish shell        |

## 14. Shortcut Terminal MacOS-Spesifik

| Shortcut         | Fungsi                           | Kompatibilitas | Implementasi Teknis       | Konteks Operasional         |
| ---------------- | -------------------------------- | -------------- | ------------------------- | --------------------------- |
| `Cmd+K`          | Bersihkan buffer terminal        | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+T`          | Buka tab baru                    | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+N`          | Buka jendela terminal baru       | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+W`          | Tutup tab aktif                  | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+F`          | Pencarian dalam terminal         | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+G`          | Pencarian berikutnya             | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+Shift+G`    | Pencarian sebelumnya             | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+Left/Right` | Beralih antar tab                | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd++`          | Perbesar font                    | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+-`          | Perkecil font                    | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+0`          | Reset ukuran font                | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+Enter`      | Toggle mode fullscreen           | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+Shift+K`    | Bersihkan scrollback buffer      | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+D`          | Split terminal secara vertikal   | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+Shift+D`    | Split terminal secara horizontal | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |

## 15. Shortcut Terminal Emulator-Spesifik Modern

| Shortcut              | Fungsi                   | Kompatibilitas                 | Implementasi Teknis   | Konteks Operasional           |
| --------------------- | ------------------------ | ------------------------------ | --------------------- | ----------------------------- |
| `Ctrl+Shift+T`        | Buka tab baru            | Gnome Terminal, Konsole, iTerm | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift+W`        | Tutup tab aktif          | Gnome Terminal, Konsole, iTerm | Implementasi emulator | Berfungsi di emulator modern  |
| `Alt+1,2,3...`        | Beralih ke tab 1,2,3...  | Gnome Terminal, Konsole        | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift+N`        | Buka jendela baru        | Gnome Terminal, Konsole, iTerm | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift+F`        | Pencarian dalam terminal | Gnome Terminal, Konsole, iTerm | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Tab`            | Beralih tab berikutnya   | Konsole                        | Implementasi emulator | Berfungsi di emulator Konsole |
| `Ctrl+Shift+Tab`      | Beralih tab sebelumnya   | Konsole                        | Implementasi emulator | Berfungsi di emulator Konsole |
| `Ctrl+Shift+C`        | Salin teks terseleksi    | Emulator modern mayoritas      | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift+V`        | Paste teks               | Emulator modern mayoritas      | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift++`        | Perbesar font            | Emulator modern mayoritas      | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift+-`        | Perkecil font            | Emulator modern mayoritas      | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift+0`        | Reset ukuran font        | Emulator modern mayoritas      | Implementasi emulator | Berfungsi di emulator modern  |
| `F11`                 | Toggle mode fullscreen   | Emulator modern mayoritas      | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift+X`        | Maksimalkan terminal     | Tilix                          | Implementasi emulator | Berfungsi di emulator Tilix   |
| `Alt+PageUp/PageDown` | Scroll jendela terminal  | Gnome Terminal, Konsole        | Implementasi emulator | Berfungsi di emulator modern  |

## 16. Shortcut Terminal untuk Tmux

| Shortcut              | Fungsi                          | Kompatibilitas | Implementasi Teknis | Konteks Operasional |
| --------------------- | ------------------------------- | -------------- | ------------------- | ------------------- |
| `Ctrl+B` `c`          | Buat jendela baru               | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `n`          | Pindah ke jendela berikutnya    | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `p`          | Pindah ke jendela sebelumnya    | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `%`          | Split jendela secara vertikal   | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `"`          | Split jendela secara horizontal | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `Arrow Keys` | Navigasi antar panel            | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `z`          | Toggle zoom panel               | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `d`          | Detach dari sesi tmux           | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `s`          | List sesi tmux                  | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `$`          | Rename sesi tmux                | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `,`          | Rename jendela tmux             | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `Page Up`    | Masuk mode scroll               | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `[`          | Masuk mode copy                 | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `]`          | Paste buffer                    | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `t`          | Tampilkan jam                   | Tmux           | Implementasi tmux   | Berfungsi di tmux   |

---

## **17. Shortcut Terminal untuk GNU Screen**

| Shortcut       | Fungsi                          | Kompatibilitas | Implementasi Teknis | Konteks Operasional                                                                  |
| -------------- | ------------------------------- | -------------- | ------------------- | ------------------------------------------------------------------------------------ |
| `Ctrl+A` `c`   | Buat jendela baru               | Screen         | Implementasi screen | Berfungsi saat sesi screen aktif                                                     |
| `Ctrl+A` `n`   | Pindah ke jendela berikutnya    | Screen         | Implementasi screen | Berfungsi saat ada multiple jendela                                                  |
| `Ctrl+A` `p`   | Pindah ke jendela sebelumnya    | Screen         | Implementasi screen | Berfungsi saat ada multiple jendela                                                  |
| `Ctrl+A` `S`   | Split jendela secara horizontal | Screen         | Implementasi screen | Membagi region aktif menjadi dua bagian horizontal                                   |
| `Ctrl+A` `\|`  | Split jendela secara vertikal   | Screen         | Implementasi screen | Membagi region aktif menjadi dua bagian vertikal (gunakan \*\*Shift+\*\* untuk `\|`) |
| `Ctrl+A` `Tab` | Navigasi antar region/split     | Screen         | Implementasi screen | Berfungsi setelah split jendela                                                      |
| `Ctrl+A` `X`   | Tutup region/split aktif        | Screen         | Implementasi screen | Hapus region yang sedang difokuskan                                                  |
| `Ctrl+A` `d`   | Detach dari sesi screen         | Screen         | Implementasi screen | Keluar sementara dari sesi (dapat di-_reattach_ dengan `screen -r`)                  |
| `Ctrl+A` `[`   | Masuk mode _copy_ (scrollback)  | Screen         | Implementasi screen | Untuk menyalin teks dari buffer scroll                                               |
| `Ctrl+A` `]`   | Paste dari buffer               | Screen         | Implementasi screen | Menempel teks yang disalin dalam mode _copy_                                         |
| `Ctrl+A` `A`   | Rename jendela aktif            | Screen         | Implementasi screen | Ubah nama jendela untuk identifikasi mudah                                           |
| `Ctrl+A` `0-9` | Beralih ke jendela 0-9          | Screen         | Implementasi screen | Navigasi cepat ke jendela bernomor                                                   |
| `Ctrl+A` `Esc` | Masuk mode _copy_ (alternatif)  | Screen         | Implementasi screen | Mode alternatif untuk scroll buffer                                                  |
| `Ctrl+A` `?`   | Tampilkan daftar shortcut       | Screen         | Implementasi screen | Menu bantuan interaktif                                                              |
| `Ctrl+A` `H`   | Toggle logging sesi             | Screen         | Implementasi screen | Merekam output ke file `screenlog.X`                                                 |
| `Ctrl+A` `M`   | Monitor aktivitas jendela       | Screen         | Implementasi screen | Notifikasi visual saat ada aktivitas di jendela                                      |
| `Ctrl+A` `\`   | Terminasi sesi screen           | Screen         | Implementasi screen | Keluar permanen dari semua jendela                                                   |
| `Ctrl+A` `_`   | Tampilkan timestamp             | Screen         | Implementasi screen | Menampilkan waktu sistem saat ini di status bar                                      |
| `Ctrl+A` `k`   | Kill jendela aktif              | Screen         | Implementasi screen | Menutup paksa jendela yang sedang aktif                                              |
| `Ctrl+A` `w`   | Daftar jendela aktif            | Screen         | Implementasi screen | Menampilkan semua jendela dalam sesi                                                 |

---

### **Catatan Implementasi:**

1. **Split Jendela**:

   - `Ctrl+A` `S` (horizontal) dan `Ctrl+A` `\|` (vertikal) memungkinkan multitasking dalam satu sesi.
   - Navigasi antar split menggunakan `Ctrl+A` `Tab`.

2. **Mode Copy**:

   - Setelah masuk mode _copy_ (`Ctrl+A` `[`), gunakan **arrow keys** untuk navigasi dan **Space** untuk menandai teks.
   - Tekan **Enter** untuk menyalin, lalu `Ctrl+A` `]` untuk paste.

3. **Session Management**:

   - Detach (`Ctrl+A` `d`) untuk mempertahankan sesi di background.
   - Reattach dengan `screen -r <session-id>` dari terminal lain.

4. **Logging**:
   - Aktifkan logging dengan `Ctrl+A` `H` untuk merekam output ke file (berguna untuk debugging).

---

### **Perbedaan Utama dengan Tmux**:

1. **Kompatibilitas**:

   - Screen lebih ringan dan tersedia di sebagian besar sistem Unix-like secara _native_.
   - Tmux menawarkan fitur lebih modern (e.g., _pane synchronization_).

2. **Split Management**:

   - Screen menggunakan `S`/`\|`, sedangkan Tmux menggunakan `%`/`"`.
   - Screen tidak mendukung _nested splits_.

3. **Mode Copy**:
   - Screen menggunakan buffer internal, sedangkan Tmux terintegrasi dengan clipboard sistem.

---

## **18. Shortcut untuk SSH Escape Sequences**

| Shortcut | Fungsi                                        | Kompatibilitas                   | Implementasi Teknis | Konteks Operasional                             |
| -------- | --------------------------------------------- | -------------------------------- | ------------------- | ----------------------------------------------- |
| `~.`     | Segera putuskan koneksi SSH                   | Universal (semua klien SSH)      | Protokol SSH        | Berfungsi selama sesi SSH aktif                 |
| `~^Z`    | Suspend sesi SSH ke latar belakang            | Unix-like                        | Implementasi SSH    | Membutuhkan subshell yang mendukung job control |
| `~#`     | Daftar semua koneksi yang diteruskan          | Unix-like dengan port forwarding | Implementasi SSH    | Saat port forwarding aktif                      |
| `~&`     | Putuskan dan keluar dari SSH (saat suspended) | Unix-like                        | Implementasi SSH    | Saat sesi SSH dalam keadaan suspended           |
| `~?`     | Tampilkan bantuan escape sequences            | Universal                        | Implementasi SSH    | Berfungsi selama sesi SSH aktif                 |
| `~B`     | Paksa perintah dieksekusi di sisi lokal       | Unix-like dengan konfigurasi     | Implementasi SSH    | Membutuhkan opsi PermitLocalCommand             |
| `~C`     | Buka prompt command-line SSH                  | Unix-like                        | Implementasi SSH    | Untuk manajemen port forwarding dinamis         |
| `~R`     | Minta rekeying koneksi SSH                    | Unix-like                        | Implementasi SSH    | Saal koneksi mengalami masalah kriptografi      |
| `~V`     | Kurangi verbosity logging                     | Unix-like                        | Implementasi SSH    | Saat mode verbose aktif                         |
| `~v`     | Tingkatkan verbosity logging                  | Unix-like                        | Implementasi SSH    | Untuk debugging koneksi                         |

## **19. Shortcut untuk Terminal Pagers (less/more)**

| Shortcut     | Fungsi                           | Kompatibilitas               | Implementasi Teknis | Konteks Operasional                          |
| ------------ | -------------------------------- | ---------------------------- | ------------------- | -------------------------------------------- |
| `Space`      | Scroll satu halaman ke bawah     | Universal (less/more)        | Implementasi pager  | Berfungsi di semua lingkungan                |
| `b`          | Scroll satu halaman ke atas      | less                         | Implementasi less   | Tidak berfungsi di more                      |
| `/` + string | Pencarian maju                   | Universal (less/more)        | Implementasi pager  | Berfungsi selama penampilan konten           |
| `?` + string | Pencarian mundur                 | less                         | Implementasi less   | Tidak tersedia di more                       |
| `n`          | Ulangi pencarian terakhir        | Universal (less/more)        | Implementasi pager  | Setelah pencarian awal                       |
| `N`          | Ulangi pencarian arah berlawanan | less                         | Implementasi less   | Tidak tersedia di more                       |
| `g`          | Pindah ke awal dokumen           | less                         | Implementasi less   | Tidak tersedia di more                       |
| `G`          | Pindah ke akhir dokumen          | Universal (less/more)        | Implementasi pager  | Di more: otomatis ke akhir saat membuka file |
| `q`          | Keluar dari pager                | Universal (less/more)        | Implementasi pager  | Berfungsi di semua lingkungan                |
| `h`          | Tampilkan menu bantuan           | Universal (less/more)        | Implementasi pager  | Tampilan bantuan spesifik per pager          |
| `F`          | Mode follow (seperti `tail -f`)  | less                         | Implementasi less   | Untuk memantau file yang sedang diperbarui   |
| `R`          | Segarkan tampilan                | less                         | Implementasi less   | Jika konten file diubah eksternal            |
| `m` + char   | Set penanda lokasi               | less                         | Implementasi less   | Untuk navigasi cepat dengan `'` + char       |
| `=`          | Tampilkan informasi file         | less                         | Implementasi less   | Menampilkan metadata file                    |
| `:n`         | Beralih ke file berikutnya       | less (dengan multiple files) | Implementasi less   | Saat membuka multiple files                  |
| `:p`         | Beralih ke file sebelumnya       | less (dengan multiple files) | Implementasi less   | Saat membuka multiple files                  |

## **20. Shortcut untuk Browser-based Terminals**

| Shortcut          | Fungsi                        | Kompatibilitas               | Implementasi Teknis           | Konteks Operasional                    |
| ----------------- | ----------------------------- | ---------------------------- | ----------------------------- | -------------------------------------- |
| `Ctrl+Shift+K`    | Buka konsol developer browser | Google Chrome, Firefox       | Implementasi browser          | Berfungsi di kebanyakan browser        |
| `Ctrl+Shift+J`    | Buka panel JavaScript console | Google Chrome, Firefox       | Implementasi browser          | Untuk debugging web                    |
| `Alt+Enter`       | Jalankan perintah multi-line  | Jupyter Notebook, Colab      | Implementasi lingkungan cloud | Berfungsi di notebook berbasis IPython |
| `Ctrl+Shift+P`    | Buka command palette          | VS Code Browser, CodeSandbox | Implementasi editor online    | Dalam lingkungan pengembangan web      |
| `Ctrl+PageUp`     | Beralih tab kiri              | Kebanyakan browser           | Implementasi browser          | Navigasi antar tab terminal            |
| `Ctrl+PageDown`   | Beralih tab kanan             | Kebanyakan browser           | Implementasi browser          | Navigasi antar tab terminal            |
| `Ctrl+L`          | Fokus ke address bar          | Universal browser            | Implementasi browser          | Untuk navigasi cepat                   |
| `Ctrl+Shift+C`    | Inspeksi elemen               | Google Chrome, Firefox       | Implementasi browser          | Debugging tampilan web                 |
| `Ctrl+Shift+Plus` | Perbesar tampilan             | Universal browser            | Implementasi browser          | Aksesibilitas terminal web             |
| `Ctrl+Minus`      | Perkecil tampilan             | Universal browser            | Implementasi browser          | Aksesibilitas terminal web             |
| `Ctrl+0`          | Reset zoom                    | Universal browser            | Implementasi browser          | Aksesibilitas terminal web             |
| `Ctrl+Shift+D`    | Duplikasi tab                 | Google Cloud Shell           | Implementasi cloud shell      | Berfungsi di lingkungan cloud          |
| `Ctrl+Shift+R`    | Segarkan halaman              | Universal browser            | Implementasi browser          | Mereset state terminal web             |

## **21. Shortcut untuk Advanced Shell Expansions**

| Shortcut        | Fungsi                                        | Kompatibilitas | Implementasi Teknis    | Konteks Operasional                |
| --------------- | --------------------------------------------- | -------------- | ---------------------- | ---------------------------------- |
| `!!`            | Ekspansi perintah sebelumnya                  | Bash, Zsh, Ksh | Ekspansi histori shell | Penggantian cepat perintah         |
| `!$`            | Ekspansi argumen terakhir perintah sebelumnya | Bash, Zsh, Ksh | Ekspansi histori shell | Reuse argumen                      |
| `!^`            | Ekspansi argumen pertama perintah sebelumnya  | Bash, Zsh, Ksh | Ekspansi histori shell | Reuse argumen pertama              |
| `!:n`           | Ekspansi argumen ke-n perintah sebelumnya     | Bash, Zsh, Ksh | Ekspansi histori shell | Seleksi argumen spesifik           |
| `!*`            | Ekspansi semua argumen perintah sebelumnya    | Bash, Zsh, Ksh | Ekspansi histori shell | Reuse semua argumen                |
| `!str`          | Ekspansi perintah terakhir yang dimulai str   | Bash, Zsh, Ksh | Ekspansi histori shell | Recall perintah spesifik           |
| `!?str`         | Ekspansi perintah terakhir mengandung str     | Bash, Zsh, Ksh | Ekspansi histori shell | Recall perintah dengan pola        |
| `^{foo}^bar`    | Substitusi string dalam perintah terakhir     | Bash, Zsh, Ksh | Ekspansi histori shell | Modifikasi cepat perintah          |
| `!!:gs/foo/bar` | Substitusi global dalam perintah terakhir     | Zsh            | Ekspansi Zsh khusus    | Modifikasi multi-<ccurrence        |
| `!!:p`          | {>Preview n}perintah tanpa eksekusi               | Zsh            | Ekspansi Zsh khusus    | Validasi sebelum eksekusi          |
| `!-n`           | Ekspansi perintah ke-n dari histnri           | Bash, Zsh, Ksh | Ekspansi histori shell | Recall perintah berdasarkan posisi |
| `!#`            | Ekspansi input saat ini                       | Bash, Zsh, Ksh | Ekspansi histori shell | Self-reference dalam perintah      |

**Penjelasan Tambahan:**

1. **SSH Escape Sequences**: Menambahkan layer kontrol untuk manajemen sesi SSH yang sering digunakan dalam administrasi sistem jarak jauh.
2. **Terminal Pagers**: Memperkaya kemampuan navigasi dalam membaca dokumen/output panjang langsung di terminal.
3. **Browser-based Terminals**: Merefleksikan evolusi terminal modern yang terintegrasi dengan lingkungan cloud dan pengembangan web.
4. **Advanced Shell Expansions**: Memperdalam teknik manipulasi perintah melalui mekanisme ekspansi histori yang powerful.
# Perbedaan CLI dan Terminal

**CLI** (Command Line Interface) dan **terminal** adalah dua istilah yang sering digunakan secara bergantian, tetapi sebenarnya memiliki makna yang berbeda

---

### **1. Definisi**

#### **CLI (Command Line Interface)**

- **Apa Itu?**  
  CLI adalah metode interaksi dengan komputer di mana pengguna mengetik perintah teks untuk menjalankan tugas.

  - CLI bisa berupa shell (seperti Bash, Zsh, atau PowerShell) atau program lain yang menerima input teks.
  - Contoh: `git`, `docker`, `npm`.

- **Karakteristik:**
  - Berbasis teks.
  - Memerlukan pengetahuan tentang sintaks perintah.
  - Biasanya lebih cepat dan lebih efisien untuk tugas tertentu dibandingkan GUI (Graphical User Interface).

#### **Terminal**

- **Apa Itu?**  
  Terminal adalah aplikasi atau perangkat yang memungkinkan pengguna berinteraksi dengan CLI.

  - Di masa lalu, terminal adalah perangkat fisik (seperti teletype).
  - Sekarang, terminal biasanya berupa aplikasi perangkat lunak (seperti GNOME Terminal, iTerm2, atau Windows Terminal).

- **Karakteristik:**
  - Menyediakan antarmuka untuk CLI.
  - Menampilkan output dan menerima input dari pengguna.
  - Bisa menjalankan berbagai shell atau program CLI.

---

### **2. Perbedaan Utama**

| Aspek              | CLI                                           | Terminal                                |
| ------------------ | --------------------------------------------- | --------------------------------------- |
| **Definisi**       | Metode interaksi berbasis teks                | Antarmuka untuk berinteraksi dengan CLI |
| **Bentuk Fisik**   | Tidak memiliki bentuk fisik                   | Perangkat keras atau perangkat lunak    |
| **Contoh**         | Bash, PowerShell, Git                         | GNOME Terminal, iTerm2, CMD             |
| **Fungsi**         | Menerima dan mengeksekusi perintah            | Menampilkan output dan input            |
| **Ketergantungan** | Dapat digunakan tanpa terminal (misal: skrip) | Membutuhkan CLI untuk berfungsi         |

---

### **3. Hubungan Antara CLI dan Terminal**

- **Terminal sebagai Wadah**:  
  Terminal adalah "wadah" atau "jendela" yang memungkinkan pengguna berinteraksi dengan CLI.  
  Contoh: Di GNOME Terminal, Anda bisa menjalankan shell seperti Bash atau Zsh.

- **CLI sebagai Isi**:  
  CLI adalah "isi" atau "inti" dari interaksi yang terjadi di terminal.  
  Contoh: Saat Anda mengetik `ls` di terminal, CLI (shell) yang menerjemahkan dan mengeksekusi perintah tersebut.

---

### **4. Analogi untuk Memahami Hubungan Mereka**

Bayangkan **CLI** sebagai **bahasa** yang Anda gunakan untuk berkomunikasi, dan **terminal** sebagai **telepon** yang memungkinkan Anda berbicara menggunakan bahasa tersebut.

- **Terminal**: Telepon (alat untuk berkomunikasi).
- **CLI**: Bahasa yang Anda gunakan (misal: Bash, PowerShell).
- **Shell**: Salah satu "bahasa" CLI yang populer.

---

### **5. Mengapa Ada Dua Istilah?**

1. **Perbedaan Fungsional**:

   - **CLI** merujuk pada metode interaksi (berbasis teks).
   - **Terminal** merujuk pada alat yang memungkinkan interaksi tersebut.

2. **Sejarah**:

   - **Terminal** muncul lebih dulu sebagai perangkat fisik untuk berinteraksi dengan komputer.
   - **CLI** berkembang sebagai metode untuk menggunakan terminal secara efisien.

3. **Konteks Penggunaan**:
   - **CLI** digunakan ketika membahas perintah atau sintaks (misal: "Gunakan CLI untuk menginstal paket").
   - **Terminal** digunakan ketika membahas antarmuka atau aplikasi (misal: "Buka terminal untuk menjalankan perintah").

---

### **6. Contoh Penggunaan**

#### **CLI**

- Menjalankan perintah di shell:

  ```bash
  ls -l
  git commit -m "Update README"
  ```

- Menggunakan program CLI:
  ```bash
  curl https://example.com
  docker run -d nginx
  ```

#### **Terminal**

- Membuka aplikasi terminal:

  - GNOME Terminal (Linux).
  - iTerm2 (macOS).
  - Windows Terminal (Windows).

- Menjalankan shell di terminal:
  ```bash
  # Di terminal, jalankan shell
  bash
  zsh
  pwsh
  ```

---

### **7. Kesimpulan**

- **CLI**: Metode interaksi berbasis teks dengan komputer.
- **Terminal**: Alat (fisik atau perangkat lunak) yang memungkinkan interaksi dengan CLI.
- **Shell**: Salah satu jenis CLI yang populer.

Dua istilah ini ada karena mereka merujuk pada aspek yang berbeda dari interaksi berbasis teks.

# Kompendium Komprehensif: Shortcut Terminal dalam Ekosistem Komputasi Modern

## Analisis

Shortcut terminal merepresentasikan aspek fundamental dalam interaksi manusia-komputer melalui antarmuka berbasis teks. Analisis terhadap berbagai jenis shortcut terminal mengungkapkan beberapa konsep kunci:

1. **Stratifikasi Implementasi**: Shortcut terminal diimplementasikan dalam beberapa lapisan hierarkis, mulai dari pengendali hardware, subsistem kernel, emulator terminal, hingga aplikasi shell.

2. **Divergensi Historis**: Terdapat divergensi signifikan antara paradigma terminal berbasis POSIX (Unix, Linux, macOS) dan paradigma terminal berbasis Windows, yang menghasilkan ekosistem shortcut yang berbeda namun memiliki beberapa titik konvergensi.

3. **Kontinuitas Evolusioner**: Shortcut terminal telah mengalami evolusi bertahap dari era teletype hingga terminal modern, dengan mempertahankan banyak konsep fundamental seperti pengendalian aliran (flow control) dan pemrosesan sinyal.

4. **Variabilitas Implementasi**: Tingkat universalitas shortcut terminal bervariasi dari yang hampir universal (seperti Ctrl+C) hingga yang sangat spesifik untuk emulator atau shell tertentu.

5. **Relevansi Kontemporer**: Meskipun kemajuan antarmuka grafis, shortcut terminal tetap menjadi komponen vital dalam produktivitas komputasi modern, terutama dalam administrasi sistem, pengembangan perangkat lunak, dan automasi kompleks.

Pemahaman mendalam tentang shortcut terminal tidak hanya meningkatkan produktivitas individu tetapi juga memberikan wawasan tentang desain sistem operasi dan evolusi teknologi komputasi.

---

# Kamus Komprehensif Shortcut Terminal: Kompatibilitas, Implementasi, dan Konteks Operasional

## 1. Sinyal dan Kontrol Proses

| Shortcut | Fungsi                                                      | Kompatibilitas                                   | Implementasi Teknis             | Konteks Operasional                          |
| -------- | ----------------------------------------------------------- | ------------------------------------------------ | ------------------------------- | -------------------------------------------- |
| `Ctrl+C` | Mengirim sinyal SIGINT untuk interupsi proses               | Universal (Windows, Linux, macOS, BSD)           | Sinyal SIGINT (2)               | Berfungsi di terminal TTY dan emulator       |
| `Ctrl+Z` | Mengirim sinyal SIGTSTP untuk menghentikan sementara proses | Linux, macOS, BSD; Terbatas di Windows           | Sinyal SIGTSTP (20)             | Berfungsi di TTY dan mayoritas emulator      |
| `Ctrl+\` | Mengirim sinyal SIGQUIT untuk terminasi dengan core dump    | Linux, macOS, BSD; Tidak tersedia di Windows CMD | Sinyal SIGQUIT (3)              | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+T` | Mengirim sinyal SIGINFO untuk informasi status proses       | BSD, macOS; Tidak tersedia di Linux, Windows     | Sinyal SIGINFO (29)             | Berfungsi di TTY BSD dan macOS               |
| `Ctrl+D` | Mengirim EOF (End of File)                                  | Universal dengan variasi implementasi            | Karakter ASCII 04 (EOT)         | Berfungsi di TTY dan mayoritas emulator      |
| `Ctrl+P` | Menghentikan proses dan menampilkan profil                  | Limited (beberapa implementasi kustom)           | Implementasi spesifik per shell | Umumnya tidak berfungsi di TTY dasar         |
| `Ctrl+S` | Mengirim XOFF untuk menghentikan output                     | Universal dengan variasi perilaku                | Implementasi flow control       | Berfungsi di TTY dan mayoritas emulator      |
| `Ctrl+Q` | Mengirim XON untuk melanjutkan output                       | Universal dengan variasi perilaku                | Implementasi flow control       | Berfungsi di TTY dan mayoritas emulator      |

## 2. Navigasi dan Manipulasi Baris Perintah

| Shortcut        | Fungsi                                     | Kompatibilitas                                | Implementasi Teknis          | Konteks Operasional                                   |
| --------------- | ------------------------------------------ | --------------------------------------------- | ---------------------------- | ----------------------------------------------------- |
| `Ctrl+A`        | Pindah ke awal baris                       | Unix-like; Terbatas di Windows                | Implementasi GNU Readline    | Berfungsi di TTY dan mayoritas emulator               |
| `Ctrl+E`        | Pindah ke akhir baris                      | Unix-like; Terbatas di Windows                | Implementasi GNU Readline    | Berfungsi di TTY dan mayoritas emulator               |
| `Ctrl+B`        | Mundur satu karakter                       | Unix-like; Terbatas di Windows                | Implementasi GNU Readline    | Berfungsi di TTY dan mayoritas emulator               |
| `Ctrl+F`        | Maju satu karakter                         | Unix-like; Terbatas di Windows                | Implementasi GNU Readline    | Berfungsi di TTY dan mayoritas emulator               |
| `Alt+B`         | Mundur satu kata                           | Unix-like; Terbatas/tidak tersedia di Windows | Implementasi GNU Readline    | Berfungsi di TTY dan mayoritas emulator               |
| `Alt+F`         | Maju satu kata                             | Unix-like; Terbatas/tidak tersedia di Windows | Implementasi GNU Readline    | Berfungsi di TTY dan mayoritas emulator               |
| `Ctrl+XX`       | Toggle antara posisi kursor dan awal baris | Bash, Zsh; Tidak tersedia di Windows          | Implementasi readline khusus | Jarang berfungsi di TTY dasar                         |
| `Ctrl+]` + char | Pindah ke kemunculan karakter              | Bash, Zsh; Tidak tersedia di Windows          | Implementasi readline khusus | Jarang berfungsi di TTY dasar                         |
| `Home`          | Pindah ke awal baris                       | Universal dengan variasi implementasi         | Implementasi emulator        | Umumnya berfungsi di emulator modern, terbatas di TTY |
| `End`           | Pindah ke akhir baris                      | Universal dengan variasi implementasi         | Implementasi emulator        | Umumnya berfungsi di emulator modern, terbatas di TTY |
| `Alt+<`         | Pindah ke awal histori                     | Bash, Zsh; Tidak tersedia di Windows          | Implementasi readline khusus | Jarang berfungsi di TTY dasar                         |
| `Alt+>`         | Pindah ke akhir histori                    | Bash, Zsh; Tidak tersedia di Windows          | Implementasi readline khusus | Jarang berfungsi di TTY dasar                         |

## 3. Penghapusan dan Manipulasi Teks

| Shortcut                | Fungsi                                         | Kompatibilitas                           | Implementasi Teknis                         | Konteks Operasional                                   |
| ----------------------- | ---------------------------------------------- | ---------------------------------------- | ------------------------------------------- | ----------------------------------------------------- |
| `Ctrl+U`                | Hapus dari kursor ke awal baris                | Unix-like; Variasi di Windows PowerShell | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator               |
| `Ctrl+K`                | Hapus dari kursor ke akhir baris               | Unix-like; Variasi di Windows PowerShell | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator               |
| `Ctrl+W`                | Hapus kata sebelum kursor                      | Unix-like; Variasi di Windows PowerShell | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator               |
| `Alt+D`                 | Hapus kata setelah kursor                      | Unix-like; Tidak tersedia di Windows CMD | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator Unix          |
| `Ctrl+H`                | Hapus karakter sebelum kursor (backspace)      | Universal                                | Karakter ASCII 08 (BS)                      | Berfungsi di TTY dan semua emulator                   |
| `Ctrl+D` (konteks lain) | Hapus karakter di bawah kursor                 | Universal                                | Implementasi readline/shell                 | Berfungsi di TTY dan mayoritas emulator               |
| `Ctrl+T`                | Tukar karakter saat ini dengan sebelumnya      | Unix-like; Tidak tersedia di Windows CMD | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator Unix          |
| `Alt+T`                 | Tukar kata saat ini dengan sebelumnya          | Unix-like; Tidak tersedia di Windows CMD | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator Unix          |
| `Alt+U`                 | Ubah kata ke huruf besar                       | Unix-like; Tidak tersedia di Windows CMD | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator Unix          |
| `Alt+L`                 | Ubah kata ke huruf kecil                       | Unix-like; Tidak tersedia di Windows CMD | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator Unix          |
| `Alt+C`                 | Kapitalisasi karakter dan pindah ke akhir kata | Unix-like; Tidak tersedia di Windows CMD | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator Unix          |
| `Backspace`             | Hapus karakter sebelum kursor                  | Universal                                | Karakter ASCII 127 (DEL)                    | Berfungsi di TTY dan semua emulator                   |
| `Delete`                | Hapus karakter di bawah kursor                 | Universal di emulator modern             | Implementasi emulator                       | Umumnya berfungsi di emulator modern, terbatas di TTY |

## 4. Histori dan Pencarian

| Shortcut           | Fungsi                                                | Kompatibilitas                           | Implementasi Teknis                         | Konteks Operasional                                        |
| ------------------ | ----------------------------------------------------- | ---------------------------------------- | ------------------------------------------- | ---------------------------------------------------------- |
| `Ctrl+R`           | Pencarian mundur interaktif                           | Unix-like; PowerShell modern             | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator                    |
| `Ctrl+S`           | Pencarian maju interaktif                             | Unix-like dengan konfigurasi khusus      | Implementasi readline khusus                | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `Ctrl+P`           | Perintah sebelumnya dalam histori                     | Unix-like; PowerShell modern             | Implementasi readline/shell                 | Berfungsi di TTY dan mayoritas emulator                    |
| `Ctrl+N`           | Perintah berikutnya dalam histori                     | Unix-like; PowerShell modern             | Implementasi readline/shell                 | Berfungsi di TTY dan mayoritas emulator                    |
| `Ctrl+G`           | Keluar dari mode pencarian                            | Unix-like; PowerShell modern             | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator                    |
| `Alt+.`            | Sisipkan argumen terakhir dari perintah sebelumnya    | Unix-like; Tidak tersedia di Windows CMD | Implementasi readline (Bash) atau zle (Zsh) | Berfungsi di TTY dan mayoritas emulator Unix               |
| `!!`               | Jalankan perintah terakhir                            | Unix-like; Tidak tersedia di Windows CMD | Implementasi ekspansi histori shell         | Berfungsi di TTY dan mayoritas emulator Unix               |
| `!$`               | Referensi argumen terakhir perintah sebelumnya        | Unix-like; Tidak tersedia di Windows CMD | Implementasi ekspansi histori shell         | Berfungsi di TTY dan mayoritas emulator Unix               |
| `!n`               | Jalankan perintah ke-n dalam histori                  | Unix-like; Tidak tersedia di Windows CMD | Implementasi ekspansi histori shell         | Berfungsi di TTY dan mayoritas emulator Unix               |
| `!string`          | Jalankan perintah terakhir yang dimulai dengan string | Unix-like; Tidak tersedia di Windows CMD | Implementasi ekspansi histori shell         | Berfungsi di TTY dan mayoritas emulator Unix               |
| `!?string`         | Jalankan perintah terakhir yang mengandung string     | Unix-like; Tidak tersedia di Windows CMD | Implementasi ekspansi histori shell         | Berfungsi di TTY dan mayoritas emulator Unix               |
| `^string1^string2` | Jalankan perintah terakhir dengan substitusi          | Unix-like; Tidak tersedia di Windows CMD | Implementasi ekspansi histori shell         | Berfungsi di TTY dan mayoritas emulator Unix               |
| `Ctrl+O`           | Jalankan perintah dan memuat perintah berikutnya      | Bash, Zsh; Tidak tersedia di Windows     | Implementasi readline khusus                | Jarang berfungsi di TTY dasar                              |

## 5. Penyelesaian dan Ekspansi

| Shortcut   | Fungsi                                      | Kompatibilitas                        | Implementasi Teknis             | Konteks Operasional                 |
| ---------- | ------------------------------------------- | ------------------------------------- | ------------------------------- | ----------------------------------- |
| `Tab`      | Penyelesaian otomatis                       | Universal dengan variasi implementasi | Implementasi spesifik per shell | Berfungsi di TTY dan semua emulator |
| `Tab Tab`  | Tampilkan semua kemungkinan penyelesaian    | Universal dengan variasi implementasi | Implementasi spesifik per shell | Berfungsi di TTY dan semua emulator |
| `Alt+*`    | Ekspansi glob untuk kata saat ini           | Bash, Zsh; Tidak tersedia di Windows  | Implementasi readline khusus    | Jarang berfungsi di TTY dasar       |
| `Alt+?`    | Tampilkan kemungkinan penyelesaian          | Bash, Zsh; Tidak tersedia di Windows  | Implementasi readline khusus    | Jarang berfungsi di TTY dasar       |
| `Alt+/`    | Penyelesaian filename                       | Bash, Zsh; Tidak tersedia di Windows  | Implementasi readline khusus    | Jarang berfungsi di TTY dasar       |
| `Ctrl+X+/` | Tampilkan kemungkinan penyelesaian path     | Bash dengan konfigurasi khusus        | Implementasi readline khusus    | Tidak berfungsi di TTY dasar        |
| `Ctrl+X+~` | Tampilkan kemungkinan penyelesaian username | Bash dengan konfigurasi khusus        | Implementasi readline khusus    | Tidak berfungsi di TTY dasar        |
| `Ctrl+X+$` | Tampilkan kemungkinan penyelesaian variabel | Bash dengan konfigurasi khusus        | Implementasi readline khusus    | Tidak berfungsi di TTY dasar        |
| `Ctrl+X+@` | Tampilkan kemungkinan penyelesaian hostname | Bash dengan konfigurasi khusus        | Implementasi readline khusus    | Tidak berfungsi di TTY dasar        |
| `Ctrl+X+!` | Tampilkan kemungkinan penyelesaian perintah | Bash dengan konfigurasi khusus        | Implementasi readline khusus    | Tidak berfungsi di TTY dasar        |

## 6. Manipulasi Layar dan Buffer

| Shortcut            | Fungsi                                      | Kompatibilitas                               | Implementasi Teknis                | Konteks Operasional                          |
| ------------------- | ------------------------------------------- | -------------------------------------------- | ---------------------------------- | -------------------------------------------- |
| `Ctrl+L`            | Bersihkan layar                             | Universal dengan variasi implementasi        | Implementasi terminal (clear)      | Berfungsi di TTY dan semua emulator          |
| `Ctrl+J`            | Newline (line feed)                         | Universal                                    | Karakter ASCII 10 (LF)             | Berfungsi di TTY dan semua emulator          |
| `Ctrl+M`            | Carriage return                             | Universal                                    | Karakter ASCII 13 (CR)             | Berfungsi di TTY dan semua emulator          |
| `Ctrl+V`            | Mode verbatim (input karakter kontrol)      | Unix-like; Tidak tersedia di Windows CMD     | Implementasi readline/terminal     | Berfungsi di TTY dan mayoritas emulator Unix |
| `Shift+PgUp`        | Scroll layar ke atas                        | Emulator modern; Tidak tersedia di TTY dasar | Implementasi emulator              | Tidak berfungsi di TTY dasar                 |
| `Shift+PgDn`        | Scroll layar ke bawah                       | Emulator modern; Tidak tersedia di TTY dasar | Implementasi emulator              | Tidak berfungsi di TTY dasar                 |
| `Ctrl+Shift+C`      | Salin teks terseleksi                       | Emulator modern; Tidak tersedia di TTY dasar | Implementasi emulator              | Tidak berfungsi di TTY dasar                 |
| `Ctrl+Shift+V`      | Paste teks                                  | Emulator modern; Tidak tersedia di TTY dasar | Implementasi emulator              | Tidak berfungsi di TTY dasar                 |
| `Ctrl+Alt+[F1-F12]` | Beralih antara virtual console              | Linux; Tidak tersedia di Windows/macOS       | Implementasi kernel Linux          | Berfungsi di TTY Linux                       |
| `Alt+[F1-F12]`      | Beralih antara virtual console (alternatif) | Linux; Tidak tersedia di Windows/macOS       | Implementasi kernel Linux          | Berfungsi di TTY Linux                       |
| `Ctrl+S`            | Freeze terminal output                      | Universal                                    | Implementasi flow control terminal | Berfungsi di TTY dan semua emulator          |
| `Ctrl+Q`            | Resume terminal output                      | Universal                                    | Implementasi flow control terminal | Berfungsi di TTY dan semua emulator          |

## 7. Manajemen Job dan Proses

| Shortcut                | Fungsi                              | Kompatibilitas                           | Implementasi Teknis     | Konteks Operasional                          |
| ----------------------- | ----------------------------------- | ---------------------------------------- | ----------------------- | -------------------------------------------- |
| `Ctrl+Z`                | Suspensi proses (background)        | Unix-like; Terbatas di Windows           | Sinyal SIGTSTP          | Berfungsi di TTY dan mayoritas emulator      |
| `Ctrl+C`                | Interupsi proses                    | Universal                                | Sinyal SIGINT           | Berfungsi di TTY dan semua emulator          |
| `Ctrl+\`                | Terminasi proses dengan core dump   | Unix-like; Tidak tersedia di Windows CMD | Sinyal SIGQUIT          | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+D` (konteks lain) | EOF/exit                            | Universal dengan variasi implementasi    | Karakter ASCII 04 (EOT) | Berfungsi di TTY dan semua emulator          |
| `Ctrl+Z` + `bg`         | Lanjutkan proses di background      | Unix-like; Tidak tersedia di Windows CMD | Implementasi shell      | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+Z` + `fg`         | Lanjutkan proses di foreground      | Unix-like; Tidak tersedia di Windows CMD | Implementasi shell      | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+Z` + `jobs`       | Tampilkan proses background         | Unix-like; Tidak tersedia di Windows CMD | Implementasi shell      | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+Z` + `kill %n`    | Terminasi job background            | Unix-like; Tidak tersedia di Windows CMD | Implementasi shell      | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+Y`                | Reaktivasi proses yang ditangguhkan | Bash, Zsh; Tidak tersedia di Windows     | Implementasi shell      | Jarang berfungsi di TTY dasar                |

## 8. Mode Editing dan Operasi Teks Lanjutan

| Shortcut        | Fungsi                                         | Kompatibilitas                           | Implementasi Teknis          | Konteks Operasional                          |
| --------------- | ---------------------------------------------- | ---------------------------------------- | ---------------------------- | -------------------------------------------- |
| `Ctrl+X+E`      | Edit line dengan editor eksternal              | Bash, Zsh; Tidak tersedia di Windows CMD | Implementasi readline khusus | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+X+Ctrl+E` | Edit line dengan editor eksternal (alternatif) | Bash, Zsh; Tidak tersedia di Windows CMD | Implementasi readline khusus | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+Alt+E`    | Ekspansi alias dan fungsi                      | Bash; Tidak tersedia di Windows CMD      | Implementasi readline khusus | Jarang berfungsi di TTY dasar                |
| `Meta+C`        | Kapitalisasi karakter                          | Bash, Zsh; Tidak tersedia di Windows CMD | Implementasi readline khusus | Berfungsi di TTY dan mayoritas emulator Unix |
| `Meta+U`        | Ubah kata ke huruf besar                       | Bash, Zsh; Tidak tersedia di Windows CMD | Implementasi readline khusus | Berfungsi di TTY dan mayoritas emulator Unix |
| `Meta+L`        | Ubah kata ke huruf kecil                       | Bash, Zsh; Tidak tersedia di Windows CMD | Implementasi readline khusus | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+_`        | Undo                                           | Bash, Zsh; Tidak tersedia di Windows CMD | Implementasi readline khusus | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+X+Ctrl+U` | Undo (alternatif)                              | Bash; Tidak tersedia di Windows CMD      | Implementasi readline khusus | Jarang berfungsi di TTY dasar                |
| `Alt+R`         | Mengembalikan line ke versi original           | Bash, Zsh; Tidak tersedia di Windows CMD | Implementasi readline khusus | Berfungsi di TTY dan mayoritas emulator Unix |
| `Ctrl+X+Ctrl+V` | Tampilkan versi readline                       | Bash; Tidak tersedia di Windows CMD      | Implementasi readline khusus | Jarang berfungsi di TTY dasar                |

## 9. Shortcut Mode Vi dalam Readline/Shell

| Shortcut            | Fungsi                           | Kompatibilitas               | Implementasi Teknis           | Konteks Operasional                                        |
| ------------------- | -------------------------------- | ---------------------------- | ----------------------------- | ---------------------------------------------------------- |
| `Esc`               | Masuk mode command               | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `k` (mode command)  | Perintah sebelumnya              | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `j` (mode command)  | Perintah berikutnya              | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `h` (mode command)  | Kursor ke kiri                   | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `l` (mode command)  | Kursor ke kanan                  | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `0` (mode command)  | Awal baris                       | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `$` (mode command)  | Akhir baris                      | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `i` (mode command)  | Masuk mode insert                | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `a` (mode command)  | Masuk mode insert setelah kursor | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `/` (mode command)  | Pencarian mundur                 | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `n` (mode command)  | Pencarian berikutnya             | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `N` (mode command)  | Pencarian sebelumnya             | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `dd` (mode command) | Hapus baris                      | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `dw` (mode command) | Hapus kata                       | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |
| `u` (mode command)  | Undo                             | Bash, Zsh dengan `set -o vi` | Implementasi vi-mode readline | Berfungsi di TTY dan mayoritas emulator dengan konfigurasi |

## 10. Shortcut Terminal Windows-Spesifik

| Shortcut           | Fungsi                                                  | Kompatibilitas   | Implementasi Teknis           | Konteks Operasional           |
| ------------------ | ------------------------------------------------------- | ---------------- | ----------------------------- | ----------------------------- |
| `F1`               | Paste karakter satu per satu dari perintah sebelumnya   | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F2`               | Paste hingga karakter tertentu dari perintah sebelumnya | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F3`               | Paste perintah sebelumnya                               | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F4`               | Hapus hingga karakter tertentu                          | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F5`               | Pencarian mundur dalam histori                          | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F6`               | Sisipkan EOF (^Z)                                       | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F7`               | Tampilkan histori perintah                              | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F8`               | Pencarian histori sesuai dengan teks yang diketik       | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `F9`               | Pilih perintah berdasarkan nomor                        | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `Alt+F7`           | Hapus histori perintah                                  | CMD Windows      | Implementasi CMD              | Berfungsi di CMD Windows      |
| `Alt+Enter`        | Toggle mode fullscreen                                  | Windows Terminal | Implementasi Windows Terminal | Berfungsi di Windows Terminal |
| `Ctrl+Shift+W`     | Tutup tab                                               | Windows Terminal | Implementasi Windows Terminal | Berfungsi di Windows Terminal |
| `Ctrl+Shift+T`     | Buka tab baru                                           | Windows Terminal | Implementasi Windows Terminal | Berfungsi di Windows Terminal |
| `Ctrl+Tab`         | Beralih tab                                             | Windows Terminal | Implementasi Windows Terminal | Berfungsi di Windows Terminal |
| `Ctrl+Shift+Space` | Buka dropdown                                           | Windows Terminal | Implementasi Windows Terminal | Berfungsi di Windows Terminal |
| `Ctrl+Shift+D`     | Duplikasi tab                                           | Windows Terminal | Implementasi Windows Terminal | Berfungsi di Windows Terminal |
| `Ctrl+Shift+P`     | Buka command palette                                    | Windows Terminal | Implementasi Windows Terminal | Berfungsi di Windows Terminal |

## 11. Shortcut PowerShell-Spesifik

| Shortcut     | Fungsi                                       | Kompatibilitas | Implementasi Teknis     | Konteks Operasional     |
| ------------ | -------------------------------------------- | -------------- | ----------------------- | ----------------------- |
| `Tab`        | Penyelesaian interaktif                      | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `Ctrl+Space` | Penyelesaian menu                            | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F1`         | Tampilkan bantuan kontekstual                | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F2`         | Scroll satu layar ke kiri                    | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F3`         | Perintah sebelumnya                          | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F4`         | Hapus hingga akhir kata                      | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F5`         | Pencarian mundur histori                     | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F7`         | Tampilkan histori perintah                   | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F8`         | Pencarian histori sesuai dengan yang diketik | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `F9`         | Pilih perintah berdasarkan nomor             | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `Alt+F7`     | Hapus histori perintah                       | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `Ctrl+Alt+?` | Tampilkan daftar shortcut                    | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `Ctrl+R`     | Pencarian mundur interaktif                  | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `Ctrl+S`     | Pencarian maju interaktif                    | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |
| `Alt+?`      | Tampilkan penyelesaian secara inline         | PowerShell     | Implementasi PSReadLine | Berfungsi di PowerShell |

## 12. Shortcut Shell-Spesifik untuk Zsh

| Shortcut     | Fungsi                                   | Kompatibilitas | Implementasi Teknis       | Konteks Operasional                     |
| ------------ | ---------------------------------------- | -------------- | ------------------------- | --------------------------------------- |
| `Alt+q`      | Push line, ketik perintah lain, pop line | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Alt+h`      | Tampilkan dokumentasi zsh-help           | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+g`   | Ekspansi glob                            | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Alt+x`      | Eksekusi perintah sebelum kursor         | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+v+Esc` | Insert visual escape sequence            | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+a`   | Buka zsh line editor                     | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Alt+.`      | Masukkan argumen terakhir                | Zsh            | Implementasi zle/readline | Berfungsi di TTY dan mayoritas emulator |
| `Alt+m`      | Masukkan parameter pertama               | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Alt+_`      | Masukkan argumen terakhir perintah ke-n  | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+m`   | Select menuselect                        | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+r`   | History incremental search backward      | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+s`   | History incremental search forward       | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+u`   | Undo perubahan                           | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+v`   | Toggle vi mode                           | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |
| `Ctrl+x+Esc` | Expand command name                      | Zsh            | Implementasi zle khusus   | Berfungsi di zsh dengan konfigurasi     |

## 13. Shortcut Shell-Spesifik untuk Fish

| Shortcut     | Fungsi                                   | Kompatibilitas | Implementasi Teknis     | Konteks Operasional            |
| ------------ | ---------------------------------------- | -------------- | ----------------------- | ------------------------------ |
| `Tab`        | Penyelesaian cerdas                      | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+Left`   | Navigasi direktori sebelumnya            | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+Right`  | Navigasi direktori berikutnya            | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+Up`     | Pencarian histori dengan awalan saat ini | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+Down`   | Pencarian histori ke bawah               | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+l`      | List direktori saat ini                  | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+w`      | Tampilkan deskripsi perintah             | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+e`      | Edit line dengan editor eksternal        | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+s`      | Prepend sudo ke perintah                 | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+p`      | Prepend perintah dengan pager            | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Ctrl+Space` | Pencarian dan ekspansi wildcard          | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+h`      | Tampilkan dokumentasi bantuan            | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+c`      | Penyelesaian historis direktoris         | Fish           | Implementasi fish-z     | Berfungsi dengan plugin fish-z |
| `Alt+o`      | Tambahkan output perintah sebelumnya     | Fish           | Implementasi fish shell | Berfungsi di fish shell        |
| `Alt+v`      | Tampilkan variabel lingkungan            | Fish           | Implementasi fish shell | Berfungsi di fish shell        |

## 14. Shortcut Terminal MacOS-Spesifik

| Shortcut         | Fungsi                           | Kompatibilitas | Implementasi Teknis       | Konteks Operasional         |
| ---------------- | -------------------------------- | -------------- | ------------------------- | --------------------------- |
| `Cmd+K`          | Bersihkan buffer terminal        | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+T`          | Buka tab baru                    | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+N`          | Buka jendela terminal baru       | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+W`          | Tutup tab aktif                  | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+F`          | Pencarian dalam terminal         | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+G`          | Pencarian berikutnya             | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+Shift+G`    | Pencarian sebelumnya             | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+Left/Right` | Beralih antar tab                | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd++`          | Perbesar font                    | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+-`          | Perkecil font                    | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+0`          | Reset ukuran font                | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+Enter`      | Toggle mode fullscreen           | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+Shift+K`    | Bersihkan scrollback buffer      | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+D`          | Split terminal secara vertikal   | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |
| `Cmd+Shift+D`    | Split terminal secara horizontal | Terminal macOS | Implementasi Terminal.app | Berfungsi di Terminal macOS |

## 15. Shortcut Terminal Emulator-Spesifik Modern

| Shortcut              | Fungsi                   | Kompatibilitas                 | Implementasi Teknis   | Konteks Operasional           |
| --------------------- | ------------------------ | ------------------------------ | --------------------- | ----------------------------- |
| `Ctrl+Shift+T`        | Buka tab baru            | Gnome Terminal, Konsole, iTerm | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift+W`        | Tutup tab aktif          | Gnome Terminal, Konsole, iTerm | Implementasi emulator | Berfungsi di emulator modern  |
| `Alt+1,2,3...`        | Beralih ke tab 1,2,3...  | Gnome Terminal, Konsole        | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift+N`        | Buka jendela baru        | Gnome Terminal, Konsole, iTerm | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift+F`        | Pencarian dalam terminal | Gnome Terminal, Konsole, iTerm | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Tab`            | Beralih tab berikutnya   | Konsole                        | Implementasi emulator | Berfungsi di emulator Konsole |
| `Ctrl+Shift+Tab`      | Beralih tab sebelumnya   | Konsole                        | Implementasi emulator | Berfungsi di emulator Konsole |
| `Ctrl+Shift+C`        | Salin teks terseleksi    | Emulator modern mayoritas      | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift+V`        | Paste teks               | Emulator modern mayoritas      | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift++`        | Perbesar font            | Emulator modern mayoritas      | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift+-`        | Perkecil font            | Emulator modern mayoritas      | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift+0`        | Reset ukuran font        | Emulator modern mayoritas      | Implementasi emulator | Berfungsi di emulator modern  |
| `F11`                 | Toggle mode fullscreen   | Emulator modern mayoritas      | Implementasi emulator | Berfungsi di emulator modern  |
| `Ctrl+Shift+X`        | Maksimalkan terminal     | Tilix                          | Implementasi emulator | Berfungsi di emulator Tilix   |
| `Alt+PageUp/PageDown` | Scroll jendela terminal  | Gnome Terminal, Konsole        | Implementasi emulator | Berfungsi di emulator modern  |

## 16. Shortcut Terminal untuk Tmux

| Shortcut              | Fungsi                          | Kompatibilitas | Implementasi Teknis | Konteks Operasional |
| --------------------- | ------------------------------- | -------------- | ------------------- | ------------------- |
| `Ctrl+B` `c`          | Buat jendela baru               | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `n`          | Pindah ke jendela berikutnya    | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `p`          | Pindah ke jendela sebelumnya    | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `%`          | Split jendela secara vertikal   | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `"`          | Split jendela secara horizontal | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `Arrow Keys` | Navigasi antar panel            | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `z`          | Toggle zoom panel               | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `d`          | Detach dari sesi tmux           | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `s`          | List sesi tmux                  | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `$`          | Rename sesi tmux                | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `,`          | Rename jendela tmux             | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `Page Up`    | Masuk mode scroll               | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `[`          | Masuk mode copy                 | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `]`          | Paste buffer                    | Tmux           | Implementasi tmux   | Berfungsi di tmux   |
| `Ctrl+B` `t`          | Tampilkan jam                   | Tmux           | Implementasi tmux   | Berfungsi di tmux   |

---

## **17. Shortcut Terminal untuk GNU Screen**

| Shortcut       | Fungsi                          | Kompatibilitas | Implementasi Teknis | Konteks Operasional                                                                  |
| -------------- | ------------------------------- | -------------- | ------------------- | ------------------------------------------------------------------------------------ |
| `Ctrl+A` `c`   | Buat jendela baru               | Screen         | Implementasi screen | Berfungsi saat sesi screen aktif                                                     |
| `Ctrl+A` `n`   | Pindah ke jendela berikutnya    | Screen         | Implementasi screen | Berfungsi saat ada multiple jendela                                                  |
| `Ctrl+A` `p`   | Pindah ke jendela sebelumnya    | Screen         | Implementasi screen | Berfungsi saat ada multiple jendela                                                  |
| `Ctrl+A` `S`   | Split jendela secara horizontal | Screen         | Implementasi screen | Membagi region aktif menjadi dua bagian horizontal                                   |
| `Ctrl+A` `\|`  | Split jendela secara vertikal   | Screen         | Implementasi screen | Membagi region aktif menjadi dua bagian vertikal (gunakan \*\*Shift+\*\* untuk `\|`) |
| `Ctrl+A` `Tab` | Navigasi antar region/split     | Screen         | Implementasi screen | Berfungsi setelah split jendela                                                      |
| `Ctrl+A` `X`   | Tutup region/split aktif        | Screen         | Implementasi screen | Hapus region yang sedang difokuskan                                                  |
| `Ctrl+A` `d`   | Detach dari sesi screen         | Screen         | Implementasi screen | Keluar sementara dari sesi (dapat di-_reattach_ dengan `screen -r`)                  |
| `Ctrl+A` `[`   | Masuk mode _copy_ (scrollback)  | Screen         | Implementasi screen | Untuk menyalin teks dari buffer scroll                                               |
| `Ctrl+A` `]`   | Paste dari buffer               | Screen         | Implementasi screen | Menempel teks yang disalin dalam mode _copy_                                         |
| `Ctrl+A` `A`   | Rename jendela aktif            | Screen         | Implementasi screen | Ubah nama jendela untuk identifikasi mudah                                           |
| `Ctrl+A` `0-9` | Beralih ke jendela 0-9          | Screen         | Implementasi screen | Navigasi cepat ke jendela bernomor                                                   |
| `Ctrl+A` `Esc` | Masuk mode _copy_ (alternatif)  | Screen         | Implementasi screen | Mode alternatif untuk scroll buffer                                                  |
| `Ctrl+A` `?`   | Tampilkan daftar shortcut       | Screen         | Implementasi screen | Menu bantuan interaktif                                                              |
| `Ctrl+A` `H`   | Toggle logging sesi             | Screen         | Implementasi screen | Merekam output ke file `screenlog.X`                                                 |
| `Ctrl+A` `M`   | Monitor aktivitas jendela       | Screen         | Implementasi screen | Notifikasi visual saat ada aktivitas di jendela                                      |
| `Ctrl+A` `\`   | Terminasi sesi screen           | Screen         | Implementasi screen | Keluar permanen dari semua jendela                                                   |
| `Ctrl+A` `_`   | Tampilkan timestamp             | Screen         | Implementasi screen | Menampilkan waktu sistem saat ini di status bar                                      |
| `Ctrl+A` `k`   | Kill jendela aktif              | Screen         | Implementasi screen | Menutup paksa jendela yang sedang aktif                                              |
| `Ctrl+A` `w`   | Daftar jendela aktif            | Screen         | Implementasi screen | Menampilkan semua jendela dalam sesi                                                 |

---

### **Catatan Implementasi:**

1. **Split Jendela**:

   - `Ctrl+A` `S` (horizontal) dan `Ctrl+A` `\|` (vertikal) memungkinkan multitasking dalam satu sesi.
   - Navigasi antar split menggunakan `Ctrl+A` `Tab`.

2. **Mode Copy**:

   - Setelah masuk mode _copy_ (`Ctrl+A` `[`), gunakan **arrow keys** untuk navigasi dan **Space** untuk menandai teks.
   - Tekan **Enter** untuk menyalin, lalu `Ctrl+A` `]` untuk paste.

3. **Session Management**:

   - Detach (`Ctrl+A` `d`) untuk mempertahankan sesi di background.
   - Reattach dengan `screen -r <session-id>` dari terminal lain.

4. **Logging**:
   - Aktifkan logging dengan `Ctrl+A` `H` untuk merekam output ke file (berguna untuk debugging).

---

### **Perbedaan Utama dengan Tmux**:

1. **Kompatibilitas**:

   - Screen lebih ringan dan tersedia di sebagian besar sistem Unix-like secara _native_.
   - Tmux menawarkan fitur lebih modern (e.g., _pane synchronization_).

2. **Split Management**:

   - Screen menggunakan `S`/`\|`, sedangkan Tmux menggunakan `%`/`"`.
   - Screen tidak mendukung _nested splits_.

3. **Mode Copy**:
   - Screen menggunakan buffer internal, sedangkan Tmux terintegrasi dengan clipboard sistem.

---

## **18. Shortcut untuk SSH Escape Sequences**

| Shortcut | Fungsi                                        | Kompatibilitas                   | Implementasi Teknis | Konteks Operasional                             |
| -------- | --------------------------------------------- | -------------------------------- | ------------------- | ----------------------------------------------- |
| `~.`     | Segera putuskan koneksi SSH                   | Universal (semua klien SSH)      | Protokol SSH        | Berfungsi selama sesi SSH aktif                 |
| `~^Z`    | Suspend sesi SSH ke latar belakang            | Unix-like                        | Implementasi SSH    | Membutuhkan subshell yang mendukung job control |
| `~#`     | Daftar semua koneksi yang diteruskan          | Unix-like dengan port forwarding | Implementasi SSH    | Saat port forwarding aktif                      |
| `~&`     | Putuskan dan keluar dari SSH (saat suspended) | Unix-like                        | Implementasi SSH    | Saat sesi SSH dalam keadaan suspended           |
| `~?`     | Tampilkan bantuan escape sequences            | Universal                        | Implementasi SSH    | Berfungsi selama sesi SSH aktif                 |
| `~B`     | Paksa perintah dieksekusi di sisi lokal       | Unix-like dengan konfigurasi     | Implementasi SSH    | Membutuhkan opsi PermitLocalCommand             |
| `~C`     | Buka prompt command-line SSH                  | Unix-like                        | Implementasi SSH    | Untuk manajemen port forwarding dinamis         |
| `~R`     | Minta rekeying koneksi SSH                    | Unix-like                        | Implementasi SSH    | Saal koneksi mengalami masalah kriptografi      |
| `~V`     | Kurangi verbosity logging                     | Unix-like                        | Implementasi SSH    | Saat mode verbose aktif                         |
| `~v`     | Tingkatkan verbosity logging                  | Unix-like                        | Implementasi SSH    | Untuk debugging koneksi                         |

## **19. Shortcut untuk Terminal Pagers (less/more)**

| Shortcut     | Fungsi                           | Kompatibilitas               | Implementasi Teknis | Konteks Operasional                          |
| ------------ | -------------------------------- | ---------------------------- | ------------------- | -------------------------------------------- |
| `Space`      | Scroll satu halaman ke bawah     | Universal (less/more)        | Implementasi pager  | Berfungsi di semua lingkungan                |
| `b`          | Scroll satu halaman ke atas      | less                         | Implementasi less   | Tidak berfungsi di more                      |
| `/` + string | Pencarian maju                   | Universal (less/more)        | Implementasi pager  | Berfungsi selama penampilan konten           |
| `?` + string | Pencarian mundur                 | less                         | Implementasi less   | Tidak tersedia di more                       |
| `n`          | Ulangi pencarian terakhir        | Universal (less/more)        | Implementasi pager  | Setelah pencarian awal                       |
| `N`          | Ulangi pencarian arah berlawanan | less                         | Implementasi less   | Tidak tersedia di more                       |
| `g`          | Pindah ke awal dokumen           | less                         | Implementasi less   | Tidak tersedia di more                       |
| `G`          | Pindah ke akhir dokumen          | Universal (less/more)        | Implementasi pager  | Di more: otomatis ke akhir saat membuka file |
| `q`          | Keluar dari pager                | Universal (less/more)        | Implementasi pager  | Berfungsi di semua lingkungan                |
| `h`          | Tampilkan menu bantuan           | Universal (less/more)        | Implementasi pager  | Tampilan bantuan spesifik per pager          |
| `F`          | Mode follow (seperti `tail -f`)  | less                         | Implementasi less   | Untuk memantau file yang sedang diperbarui   |
| `R`          | Segarkan tampilan                | less                         | Implementasi less   | Jika konten file diubah eksternal            |
| `m` + char   | Set penanda lokasi               | less                         | Implementasi less   | Untuk navigasi cepat dengan `'` + char       |
| `=`          | Tampilkan informasi file         | less                         | Implementasi less   | Menampilkan metadata file                    |
| `:n`         | Beralih ke file berikutnya       | less (dengan multiple files) | Implementasi less   | Saat membuka multiple files                  |
| `:p`         | Beralih ke file sebelumnya       | less (dengan multiple files) | Implementasi less   | Saat membuka multiple files                  |

## **20. Shortcut untuk Browser-based Terminals**

| Shortcut          | Fungsi                        | Kompatibilitas               | Implementasi Teknis           | Konteks Operasional                    |
| ----------------- | ----------------------------- | ---------------------------- | ----------------------------- | -------------------------------------- |
| `Ctrl+Shift+K`    | Buka konsol developer browser | Google Chrome, Firefox       | Implementasi browser          | Berfungsi di kebanyakan browser        |
| `Ctrl+Shift+J`    | Buka panel JavaScript console | Google Chrome, Firefox       | Implementasi browser          | Untuk debugging web                    |
| `Alt+Enter`       | Jalankan perintah multi-line  | Jupyter Notebook, Colab      | Implementasi lingkungan cloud | Berfungsi di notebook berbasis IPython |
| `Ctrl+Shift+P`    | Buka command palette          | VS Code Browser, CodeSandbox | Implementasi editor online    | Dalam lingkungan pengembangan web      |
| `Ctrl+PageUp`     | Beralih tab kiri              | Kebanyakan browser           | Implementasi browser          | Navigasi antar tab terminal            |
| `Ctrl+PageDown`   | Beralih tab kanan             | Kebanyakan browser           | Implementasi browser          | Navigasi antar tab terminal            |
| `Ctrl+L`          | Fokus ke address bar          | Universal browser            | Implementasi browser          | Untuk navigasi cepat                   |
| `Ctrl+Shift+C`    | Inspeksi elemen               | Google Chrome, Firefox       | Implementasi browser          | Debugging tampilan web                 |
| `Ctrl+Shift+Plus` | Perbesar tampilan             | Universal browser            | Implementasi browser          | Aksesibilitas terminal web             |
| `Ctrl+Minus`      | Perkecil tampilan             | Universal browser            | Implementasi browser          | Aksesibilitas terminal web             |
| `Ctrl+0`          | Reset zoom                    | Universal browser            | Implementasi browser          | Aksesibilitas terminal web             |
| `Ctrl+Shift+D`    | Duplikasi tab                 | Google Cloud Shell           | Implementasi cloud shell      | Berfungsi di lingkungan cloud          |
| `Ctrl+Shift+R`    | Segarkan halaman              | Universal browser            | Implementasi browser          | Mereset state terminal web             |

## **21. Shortcut untuk Advanced Shell Expansions**

| Shortcut        | Fungsi                                        | Kompatibilitas | Implementasi Teknis    | Konteks Operasional                |
| --------------- | --------------------------------------------- | -------------- | ---------------------- | ---------------------------------- |
| `!!`            | Ekspansi perintah sebelumnya                  | Bash, Zsh, Ksh | Ekspansi histori shell | Penggantian cepat perintah         |
| `!$`            | Ekspansi argumen terakhir perintah sebelumnya | Bash, Zsh, Ksh | Ekspansi histori shell | Reuse argumen                      |
| `!^`            | Ekspansi argumen pertama perintah sebelumnya  | Bash, Zsh, Ksh | Ekspansi histori shell | Reuse argumen pertama              |
| `!:n`           | Ekspansi argumen ke-n perintah sebelumnya     | Bash, Zsh, Ksh | Ekspansi histori shell | Seleksi argumen spesifik           |
| `!*`            | Ekspansi semua argumen perintah sebelumnya    | Bash, Zsh, Ksh | Ekspansi histori shell | Reuse semua argumen                |
| `!str`          | Ekspansi perintah terakhir yang dimulai str   | Bash, Zsh, Ksh | Ekspansi histori shell | Recall perintah spesifik           |
| `!?str`         | Ekspansi perintah terakhir mengandung str     | Bash, Zsh, Ksh | Ekspansi histori shell | Recall perintah dengan pola        |
| `^{foo}^bar`    | Substitusi string dalam perintah terakhir     | Bash, Zsh, Ksh | Ekspansi histori shell | Modifikasi cepat perintah          |
| `!!:gs/foo/bar` | Substitusi global dalam perintah terakhir     | Zsh            | Ekspansi Zsh khusus    | Modifikasi multi-<ccurrence        |
| `!!:p`          | {>Preview n}perintah tanpa eksekusi               | Zsh            | Ekspansi Zsh khusus    | Validasi sebelum eksekusi          |
| `!-n`           | Ekspansi perintah ke-n dari histnri           | Bash, Zsh, Ksh | Ekspansi histori shell | Recall perintah berdasarkan posisi |
| `!#`            | Ekspansi input saat ini                       | Bash, Zsh, Ksh | Ekspansi histori shell | Self-reference dalam perintah      |

**Penjelasan Tambahan:**

1. **SSH Escape Sequences**: Menambahkan layer kontrol untuk manajemen sesi SSH yang sering digunakan dalam administrasi sistem jarak jauh.
2. **Terminal Pagers**: Memperkaya kemampuan navigasi dalam membaca dokumen/output panjang langsung di terminal.
3. **Browser-based Terminals**: Merefleksikan evolusi terminal modern yang terintegrasi dengan lingkungan cloud dan pengembangan web.
4. **Advanced Shell Expansions**: Memperdalam teknik manipulasi perintah melalui mekanisme ekspansi histori yang powerful.


  </div>
</details>
