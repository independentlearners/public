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

[1]: https://www.gnu.org/s/bash/manual/bash.html?utm_source=chatgpt.com "Bash Reference Manual"
[2]: https://archlinux.org/packages/core/x86_64/man-db/?utm_source=chatgpt.com "man-db 2.13.1-1 (x86_64)"
[3]: https://man7.org/linux/man-pages/man1/bash.1.html?utm_source=chatgpt.com "bash(1) - Linux manual page"
[4]: https://man.archlinux.org/man/man.1.en?utm_source=chatgpt.com "man(1) - Arch manual pages"
[5]: https://tldp.org/LDP/abs/html/?utm_source=chatgpt.com "Advanced Bash-Scripting Guide"
[6]: https://tldp.org/LDP/abs/abs-guide.pdf?utm_source=chatgpt.com "Advanced Bash-Scripting Guide"
[7]: https://pubs.opengroup.org/onlinepubs/9799919799/?utm_source=chatgpt.com "The Open Group Base Specifications Issue 8"
[8]: https://www.shellcheck.net/?utm_source=chatgpt.com "ShellCheck – shell script analysis tool"
[9]: https://archlinux.org/packages/extra/x86_64/shellcheck/?utm_source=chatgpt.com "shellcheck 0.11.0-71 (x86_64)"
[10]: https://www.gnu.org/s/coreutils/manual/coreutils.html?utm_source=chatgpt.com "GNU Coreutils Manual"
[11]: https://devdocs.io/?utm_source=chatgpt.com "DevDocs API Documentation"
[12]: https://zealdocs.org/?utm_source=chatgpt.com "Zeal - Offline Documentation Browser"
[13]: https://zealdocs.org/download.html?utm_source=chatgpt.com "Download"
[14]: https://man.archlinux.org/?utm_source=chatgpt.com "Arch manual pages - Arch Linux"
[15]: https://savannah.gnu.org/git/?group=bash&utm_source=chatgpt.com "The GNU Bourne-Again SHell - Git Repositories [Savannah]"
[16]: https://books.google.com/books/about/Bash_Reference_Manual.html?id=fY2_rEP_pDYC&utm_source=chatgpt.com "Bash Reference Manual"
[17]: https://www.freecodecamp.org/news/bash-scripting-tutorial-linux-shell-script-and-command-line-for-beginners/?utm_source=chatgpt.com "Bash Scripting Tutorial – Linux Shell Script and Command ..."

</details>

<details>
  <summary>📃 Daftar Kurikulum</summary>

> **[Belajar CLI/Terminal Baris Perintah][0]**

> **[71 Istilah dalam scripting][5]**

> **[Nich scripting][6]**

# **Kurikulum Komprehensif: Menguasai Shell Scripting (Bash)**

Kurikulum ini adalah peta jalan untuk menguasai inti dari seni otomasi di lingkungan berbasis Unix/Linux. Shell scripting bukan hanya tentang menulis kode, tetapi tentang memahami dan memanfaatkan kekuatan baris perintah secara maksimal. Anda bisa menggunakan metode pendekatan di halaman ini atau jika ingin yang lebih detail lagi, anda bisa memeriksanya [disini][7]. Sedangkan halaman ini adalah dimana ketika anda ingin memahami bagian inti dari scripting.

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
    - Diagram alur untuk mengilustrasikan bagaimana data mengalir dari `stdout` satu perintah ke `stdin` perintah berikutnya melalui sebuah _pipe_.

    - Bayangkan alur data di shell Bash seperti rantai pipa air: setiap perintah mengalirkan "air data" dari **stdout**-nya (output standar) menuju **stdin** perintah berikutnya (input standar). Diagram sederhananya bisa anda bayangkan seperti ini

```bash
[ command1 ] ──stdout──▶─stdin──[ command2 ]
```

Misalnya:

```bash
ls | grep ".txt" | sort
```

Jika kita gambarkan lebih lengkap:

```bash
[ ls ] ──stdout──▶─stdin──[ grep ".txt" ] ──stdout──▶─stdin──[ sort ]
```

Penjelasan alirannya:

1. `ls` menulis daftar file ke **stdout**-nya.
2. Pipa (`|`) mengalihkan **stdout** `ls` menjadi **stdin** untuk `grep`.
3. `grep` menyaring data yang masuk dan menulis hasilnya ke **stdout**.
4. Pipa berikutnya lagi mengalihkan hasil `grep` ke **stdin** milik `sort`.
5. `sort` akhirnya menulis hasil akhir ke **stdout**, yang (jika tidak diarahkan ke file) akan tampil di terminal.

Kita bisa memperjelas dengan tambahan opsi redirect:

```bash
command1 | command2 | command3 > output.txt
```

```bash
[ command1 ] → [ command2 ] → [ command3 ] → (stdout) → output.txt
```

Setiap panah (`→`) di atas mewakili aliran data berbasis stream: teks, byte, atau baris.

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

    - Contoh lain dengan input nama dan kota.

    ```bash
    #!/bin/bash

    # 1. Deklarasi variabel (tanpa spasi di sekitar '=')
    echo -n "Masukkan Nama Anda :"
    read NAMA_ANDA

    # 4. Membaca input dari pengguna
    echo -n "Masukkan kota Anda: "
    read KOTA

    # 2. Menggunakan variabel (ekspansi)
    echo "Halo, $NAMA_ANDA!"
    echo "Senang bertemu dengan Anda dari $KOTA!"

    # 3. Command Substitution: menyimpan output perintah ke variabel
    LOKASI_SAAT_INI=$(pwd)
    echo "Anda berada di direktori: $LOKASI_SAAT_INI"
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

</details>

- **[Home][domain-spesifik]**

[domain-spesifik]: ../../README.md
[0]: ./../../../CLI_TUI/perintah/README.md
[1]:../bash/bagian-1/README.md
[2]:../bash/bagian-2/README.md
[3]:../bash/bagian-3/README.md
[4]:../bash/bagian-4/README.md
[5]:../bash/bagian-5/README.md
[6]:../bash/nich/README.md
[7]: ./bashscripting/README.md
