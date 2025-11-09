### **[Fase I: Foundation (Pemula)][0]**

<details>
  <summary>📃 Daftar Isi</summary>

-----

#### **Modul 1.1: The Grand Tour - Memulai Perjalanan di Terminal**

  * **Struktur Pembelajaran Internal:**

      * Apa itu Terminal dan Shell?
      * Filosofi dan Peran Command-Line Interface (CLI)
      * Mengenal Tampilan Awal: Prompt dan Kursor
      * Menjalankan Perintah Pertama: `echo`
      * Perintah-Perintah Fondasi: `whoami`, `date`, `hostname`
---

</details>

  * **Deskripsi Konkret & Peran dalam Kurikulum:**
    Modul ini adalah pintu gerbang Anda menuju dunia Linux dan Termux berbasis teks. Di sini, Anda akan mengenal antarmuka yang sangat berbeda dari lingkungan desktop grafis yang biasa Anda gunakan. Tujuannya bukan hanya untuk mengajarkan perintah, melainkan juga untuk menanamkan rasa nyaman dan pemahaman dasar tentang bagaimana berinteraksi dengan sistem tanpa mouse. Menguasai modul ini akan menghilangkan rasa takut dan membangun fondasi mental yang kuat, di mana Anda menyadari bahwa terminal adalah alat yang logis dan kuat, bukan kotak hitam yang menakutkan.

  * **Konsep Kunci & Filosofi Mendalam:**

      * **Shell sebagai Penerjemah:** Bayangkan **shell** (`bash` di Linux, `sh` di Termux) sebagai seorang penerjemah super cepat yang duduk di antara Anda dan inti sistem operasi (kernel). Anda mengetikkan perintah dalam bahasa yang dimengerti shell, dan shell menerjemahkan perintah itu ke bahasa biner yang dapat dieksekusi oleh kernel.
      * **Terminal Emulator sebagai Jendela:** Terminal emulator (`alacritty`, `kitty`, `Termux`) hanyalah sebuah jendela atau aplikasi visual yang menyediakan tempat bagi shell untuk berinteraksi dengan Anda. Ini adalah wadah, bukan isinya. Anda dapat memiliki banyak jendela terminal yang berbeda, tetapi semuanya berinteraksi dengan shell yang sama atau berbeda.
      * **Filosofi CLI:** CLI menganut filosofi **minimalisme, kecepatan, dan akurasi**. Dengan menghilangkan elemen grafis, CLI menjadi sangat ringan dan tidak menguras sumber daya. Setiap perintah adalah instruksi yang tepat, mengurangi ambiguitas dan meningkatkan efisiensi. Ini memungkinkan otomasi dan *scripting* yang hampir mustahil dilakukan dengan GUI.

  * **Sintaks Dasar / Contoh Implementasi Inti:**
    Saat Anda pertama kali membuka terminal, Anda akan melihat sebuah *prompt*. Prompt ini adalah tanda bahwa shell siap menerima perintah. Tampilannya mungkin bervariasi, tetapi umumnya akan terlihat seperti ini:

    `[nama_pengguna]@[nama_host]:[direktori_saat_ini]$`
    Contoh: `user@archlinux:~$`

    Di sinilah Anda akan mulai mengetikkan perintah.

      * **Perintah `echo`:** Perintah ini sangat mendasar. Fungsinya adalah untuk menampilkan teks ke layar. Ini sering digunakan dalam skrip untuk memberikan pesan kepada pengguna.

          * **Sintaks:** `echo [teks]`
          * **Studi Kasus:** Mari kita coba perintah klasik "Hello, World\!".
            ```bash
            echo "Selamat datang di dunia CLI!"
            ```
            **Penjelasan:**
              * **`echo`**: Ini adalah perintah.
              * **`"Selamat datang di dunia CLI!"`**: Ini adalah argumen yang diberikan kepada perintah `echo`. Tanda kutip (`"`) digunakan untuk memastikan seluruh kalimat diperlakukan sebagai satu kesatuan.

      * **Perintah `whoami`:** Sederhana, perintah ini akan menampilkan nama pengguna yang sedang masuk. Ini sangat berguna untuk memastikan Anda berada di akun yang benar.

          * **Sintaks:** `whoami`
          * **Contoh:**
            ```bash
            whoami
            # Output: user
            ```

      * **Perintah `date`:** Menampilkan tanggal dan waktu sistem saat ini. Anda juga bisa menambahkan argumen untuk memformat tampilannya.

          * **Sintaks:** `date`
          * **Contoh:**
            ```bash
            date
            # Output: Thu 28 Aug 2025 12:34:12 PM WIB
            ```

      * **Perintah `hostname`:** Menampilkan nama komputer Anda. Ini berguna untuk mengidentifikasi perangkat di jaringan.

          * **Sintaks:** `hostname`
          * **Contoh:**
            ```bash
            hostname
            # Output: archlinux
            ```

  * **Terminologi Esensial & Penjelasan Detil:**

      * **Terminal (`TTY`):** Singkatan dari *Teletypewriter*, merujuk pada perangkat input/output teks fisik di masa lalu. Sekarang, ini adalah aplikasi yang menyediakan antarmuka teks.
      * **Shell:** Program penerjemah perintah yang membaca input dari pengguna dan mengirimkannya ke kernel untuk dieksekusi. Ada banyak jenis shell, seperti `Bash`, `Zsh`, dan `sh`.
      * **Prompt (`$` atau `#`):** Tanda visual yang menunjukkan bahwa shell siap menerima perintah. Tanda `$` biasanya menunjukkan pengguna biasa, sementara `#` menunjukkan pengguna *root* (administrator).
      * **Perintah (Command):** Kata kunci yang dapat dikenali oleh shell untuk menjalankan program atau fungsi tertentu (misalnya, `ls`, `cd`, `echo`).
      * **Argumen (Argument):** Nilai atau parameter yang diberikan kepada perintah untuk memodifikasi perilaku atau memberikan data yang diperlukan (misalnya, nama file, opsi).

  * **Rekomendasi Visualisasi:**
    Visualisasi alur kerja **pengguna -\> terminal emulator -\> shell -\> kernel** akan sangat membantu pemahaman.

    ```
    ┌───────────────────────────┐
    │          Anda             │
    └───────────┬───────────────┘
                │ Anda mengetik: 'echo "Halo"'
                ▼
    ┌───────────────────────────┐
    │      Terminal Emulator    │
    │      (Misal: Termux)      │
    └───────────┬───────────────┘
                │ Meneruskan input ke Shell
                ▼
    ┌───────────────────────────┐
    │           Shell           │
    │        (Misal: Bash)      │
    │     (Penerjemah Perintah) │
    └───────────┬───────────────┘
                │ Shell memproses & menjalankan
                ▼
    ┌───────────────────────────┐
    │          Kernel           │
    │     (Inti OS, Pelaksana)  │
    └───────────────────────────┘
    ```

  * **Hubungan dengan Modul Lain:**
    Modul ini adalah prasyarat mutlak untuk semua modul berikutnya. Pemahaman tentang *prompt*, cara kerja perintah, dan konsep dasar shell akan menjadi fondasi untuk navigasi (Modul 1.2), mencari bantuan (Modul 1.3), dan semua topik lanjutan lainnya. Tanpa modul ini, pembelajaran akan terasa seperti mencoba berenang tanpa air.

  * **Tips dan Praktik Terbaik:**

      * **Jangan Takut Eksperimen:** Cobalah ketik perintah acak dan lihat apa yang terjadi. Terminal tidak akan rusak hanya karena Anda mencoba.
      * **Gunakan Tombol `Tab`:** Fitur **autokomplit** sangat berguna. Cukup ketik beberapa huruf pertama dari sebuah perintah atau nama file, lalu tekan `Tab`. Shell akan melengkapinya secara otomatis, mencegah kesalahan ketik.
      * **Gunakan Panah Atas & Bawah:** Gunakan tombol panah atas (`▲`) untuk melihat perintah yang baru saja Anda ketik, dan panah bawah (`▼`) untuk kembali ke perintah yang lebih baru. Ini sangat membantu untuk mengulangi atau memodifikasi perintah.

  * **Potensi Kesalahan Umum & Solusi:**

      * **Kesalahan:** Mengetikkan perintah dengan spasi yang salah. Contoh: `ls-l` bukan `ls -l`.
      * **Solusi:** Perhatikan setiap spasi. Sintaks CLI sangat sensitif terhadap spasi. Spasi memisahkan perintah dari opsinya dan dari argumennya.
      * **Kesalahan:** Tidak mendapatkan output yang diharapkan, atau mendapatkan pesan `command not found`.
      * **Solusi:** Ini sering terjadi karena salah ketik. Periksa kembali ejaan perintahnya. Jika Anda tidak yakin, gunakan autokomplit dengan tombol `Tab`. Jika masih tidak bisa, itu berarti perintah tersebut belum terinstal di sistem Anda.

-----

#### **Modul 1.2: Navigating the Filesystem (Berlayar di Sistem File)**

<details>
  <summary>📃 Daftar Isi</summary>

  * **Struktur Pembelajaran Internal:**

      * Filosofi "Everything is a File" dalam Konteks Linux.
      * Memahami Struktur Direktori Hierarkis.
      * Perintah Kunci untuk Navigasi: `pwd`, `ls`, `cd`.
      * Jalur (Paths): Absolut vs. Relatif.
      * Manipulasi Dasar Direktori: `mkdir` dan `rmdir`.

</details>

  * **Deskripsi Konkret & Peran dalam Kurikulum:**
    Modul ini adalah tentang penguasaan ruang. Di dunia CLI, tidak ada ikon folder yang bisa Anda klik. Sebaliknya, Anda akan menggunakan perintah untuk bergerak dari satu direktori ke direktori lain. Modul ini mengajarkan Anda "peta" dan "kompas" yang esensial untuk beroperasi di dalam sistem Linux. Penguasaan navigasi ini sangat penting karena hampir semua perintah lain (seperti menyalin atau menghapus file) membutuhkan pemahaman yang solid tentang di mana Anda berada dan di mana target Anda berada.

  * **Konsep Kunci & Filosofi Mendalam:**

      * **Filosofi "Everything is a File":** Ini adalah salah satu pilar utama filosofi Unix. Artinya, dari folder, program, bahkan perangkat keras seperti hard drive dan keyboard, semuanya direpresentasikan sebagai sebuah *file* di dalam sistem file. Konsep ini menyederhanakan cara program berinteraksi dengan sumber daya sistem, karena mereka hanya perlu membaca dan menulis ke "file" terlepas dari jenis perangkatnya.
      * **Struktur Hierarkis (Pohon):** Sistem file Linux diorganisasi dalam struktur seperti pohon terbalik. Semua dimulai dari satu direktori tunggal yang disebut **root (`/`)**. Di bawahnya terdapat direktori-direktori penting seperti `/home`, `/bin`, dan `/etc`.  Ini berbeda dengan Windows yang memiliki drive terpisah seperti `C:\`, `D:\`, dst. Di Linux, semua perangkat penyimpanan "dipasang" (*mounted*) ke dalam pohon ini.

  * **Sintaks Dasar / Contoh Implementasi Inti:**
    Kita akan menggunakan analogi navigasi di dalam sebuah rumah. Setiap ruangan adalah sebuah direktori.

      * **`pwd` (Print Working Directory):** Ini adalah kompas Anda. Ia memberi tahu Anda di mana Anda berada saat ini.

          * **Studi Kasus:** Bayangkan Anda masuk ke rumah dan ingin tahu di ruangan mana Anda berada.
            ```bash
            pwd
            # Output: /home/user
            ```
            **Penjelasan:** Perintah ini mencetak **jalur absolut** lengkap dari direktori saat ini, dimulai dari root (`/`).

      * **`ls` (List):** Ini adalah mata Anda. Perintah ini mencantumkan semua file dan direktori yang ada di "ruangan" tempat Anda berada.

          * **Studi Kasus:** Anda ingin melihat apa saja yang ada di ruangan (direktori) tempat Anda berada.
            ```bash
            ls
            # Output: Documents Downloads Pictures Public Videos
            ```
          * **Opsi Penting:** Opsi digunakan untuk mengubah perilaku perintah. Opsi diawali dengan tanda hubung (`-`).
              * `ls -l`: Menampilkan daftar file dalam format panjang (*long listing*), termasuk izin, pemilik, ukuran, dan tanggal modifikasi.
              * `ls -a`: Menampilkan semua file, termasuk file tersembunyi (*hidden files*) yang namanya diawali dengan titik (`.`). Ini sangat penting untuk melihat file konfigurasi seperti `.bashrc`.

      * **`cd` (Change Directory):** Ini adalah kaki Anda. Perintah ini memungkinkan Anda berpindah dari satu direktori ke direktori lain.

          * **Sintaks:** `cd [nama_direktori]`
          * **Studi Kasus (Menggunakan Jalur Relatif):** Anda berada di `/home/user` dan ingin masuk ke direktori `Documents`.
            ```bash
            cd Documents
            pwd
            # Output: /home/user/Documents
            ```
            **Penjelasan:** Ini adalah **jalur relatif**, karena Anda berpindah relatif terhadap lokasi Anda saat ini.
          * **Studi Kasus (Menggunakan Jalur Absolut):** Anda berada di direktori manapun dan ingin langsung menuju direktori `Pictures` di akun Anda.
            ```bash
            cd /home/user/Pictures
            pwd
            # Output: /home/user/Pictures
            ```
            **Penjelasan:** Ini adalah **jalur absolut**, karena Anda memberikan jalur lengkap dari root (`/`).

  * **Terminologi Esensial & Penjelasan Detil:**

      * **Direktori (Directory):** Istilah Linux untuk "folder".
      * **Root Directory (`/`):** Direktori paling atas dari semua struktur file, ibarat "pintu masuk" utama ke dalam sistem.
      * **Home Directory (`~`):** Direktori pribadi setiap pengguna. Simbol `~` adalah pintasan yang sangat berguna untuk merujuk ke direktori ini. Contoh: `cd ~` akan membawa Anda pulang.
      * **Path (Jalur):** Rute ke sebuah file atau direktori.
          * **Jalur Absolut (Absolute Path):** Jalur lengkap dari root (`/`) sampai ke file/direktori tujuan. Contoh: `/home/user/Documents/notes.txt`.
          * **Jalur Relatif (Relative Path):** Jalur yang dimulai dari direktori tempat Anda berada saat ini. Contoh: Jika Anda di `/home/user`, jalur relatif ke `notes.txt` adalah `Documents/notes.txt`.
      * **Direktori Induk (`..`):** Pintasan untuk merujuk ke direktori satu tingkat di atas direktori saat ini. Contoh: `cd ..` akan membawa Anda kembali ke direktori induk.
      * **Direktori Saat Ini (`.`):** Pintasan untuk merujuk ke direktori yang Anda tempati saat ini. Meskipun jarang digunakan dalam navigasi, ini penting dalam *scripting* atau saat menjalankan program.

  * **Potensi Kesalahan Umum & Solusi:**

      * **Kesalahan:** Menggunakan huruf kapital yang salah. Linux **case-sensitive**, artinya `Documents` berbeda dengan `documents`.
      * **Solusi:** Selalu periksa ejaan dan kapitalisasi. Gunakan tombol `Tab` untuk autokomplit.
      * **Kesalahan:** Kebingungan antara jalur absolut dan relatif.
      * **Solusi:** Jika Anda ragu, gunakan `pwd` untuk mengetahui lokasi Anda, dan gunakan jalur absolut (`/home/user/...`) untuk memastikan Anda sampai di tujuan yang benar.

  * **Hubungan dengan Modul Lain:**
    Keterampilan navigasi ini adalah prasyarat untuk seluruh kurikulum. `ls` akan menjadi alat pertama Anda untuk debugging. `cd` dan jalur akan digunakan di setiap perintah yang berinteraksi dengan file. Tanpa penguasaan ini, Anda tidak akan bisa melanjutkan ke manipulasi file yang lebih kompleks di Modul 2.1 atau menulis skrip yang logis.

#### **Modul 1.3: Memahami Bantuan & Dokumentasi (Manual Pages & --help)**

<details>
  <summary>📃 Daftar Isi</summary>

-----

**Struktur Pembelajaran Internal:**

      * Mengapa Belajar Mandiri itu Penting?
      * Penggunaan Dasar `man` (Manual Pages).
      * Membaca Halaman Manual secara Efektif.
      * Perbedaan antara `--help` dan `man`.
      * Memahami Struktur Perintah & Opsi.

</details>

-----

  * **Deskripsi Konkret & Peran dalam Kurikulum:**
    Modul ini mengajarkan Anda "bahasa" dari sistem itu sendiri. Bayangkan setiap perintah di Linux memiliki buku manual mini yang tersembunyi. `man` dan `--help` adalah kunci untuk membuka buku-buku tersebut. Menguasai modul ini akan memberdayakan Anda untuk menjelajahi fungsionalitas perintah apa pun tanpa harus mencarinya di internet. Ini adalah langkah pertama menuju kemandirian total dan pemahaman yang mendalam tentang sistem. Alih-alih hanya menghafal, Anda akan belajar cara "menemukan" dan "menguraikan" informasi yang Anda butuhkan.

  * **Konsep Kunci & Filosofi Mendalam:**

      * **Filosofi "Self-Sufficiency":** Filosofi Linux/Unix adalah tentang membuat pengguna mandiri. Sistem ini menyediakan semua alat yang Anda butuhkan untuk belajar dan menyelesaikan masalah sendiri. `man` adalah manifestasi paling nyata dari filosofi ini.
      * **Standardisasi:** Halaman manual memiliki format yang distandardisasi, yang berarti setelah Anda belajar cara membaca satu halaman manual, Anda pada dasarnya dapat membaca semuanya. Ini menciptakan konsistensi dan alur pembelajaran yang efisien.

  * **Sintaks Dasar / Contoh Implementasi Inti:**

      * **Perintah `man` (Manual Page):**

          * **Sintaks:** `man [nama_perintah]`
          * **Studi Kasus:** Mari kita gunakan perintah `ls` yang sudah kita kenal.
            ```bash
            man ls
            ```
            **Penjelasan:** Perintah ini akan membuka halaman manual untuk `ls`. Anda akan melihat layar penuh teks dengan berbagai bagian.
              * Gunakan tombol panah atas/bawah (`▲`/`▼`) untuk menggulir baris demi baris.
              * Gunakan `Page Up` / `Page Down` untuk menggulir halaman.
              * Tekan `q` untuk keluar dari halaman manual.
              * Tekan `/` untuk mencari kata kunci di dalam manual.
              * Untuk penggunaan `man` kita juga bisa dengan cara `man man`.  

      * **Membaca Halaman Manual:** Halaman manual dibagi menjadi beberapa bagian utama:

        1.  **NAME:** Nama perintah dan deskripsi singkat.
        2.  **SYNOPSIS:** Ringkasan sintaksis perintah. Ini menunjukkan bagaimana perintah digunakan secara umum. Contoh: `ls [OPTION]... [FILE]...`.
              * `[ ]`: Menunjukkan opsi atau argumen opsional.
              * `...`: Menunjukkan bahwa opsi atau argumen dapat diulang.
        3.  **DESCRIPTION:** Deskripsi yang lebih rinci tentang fungsionalitas perintah.
        4.  **OPTIONS:** Penjelasan mendalam tentang setiap opsi yang tersedia. Contoh: `-l` untuk format panjang, `-a` untuk semua file.
        5.  **EXAMPLES:** Contoh-contoh praktis penggunaan perintah.

      * **Perintah `--help`:** Banyak perintah memiliki opsi `--help` atau `-h` yang memberikan ringkasan singkat dari opsi-opsi yang paling sering digunakan, langsung di terminal tanpa membuka halaman penuh. Ini lebih cepat untuk referensi cepat.

          * **Sintaks:** `[nama_perintah] --help` atau `[nama_perintah] -h`
          * **Contoh:**
            ```bash
            ls --help
            ```
            **Penjelasan:** Ini akan menampilkan daftar opsi `ls` beserta deskripsinya, yang lebih ringkas dari halaman manual.

  * **Terminologi Esensial & Penjelasan Detil:**

      * **Manual Page (Man Page):** Halaman dokumentasi yang terinstal di sistem Anda untuk setiap perintah.
      * **Synopsis:** Ringkasan sintaksis, seperti "resep" untuk menggunakan perintah. Memahami bagian ini sangat krusial.
      * **Option (Opsi):** Parameter yang mengubah perilaku perintah. Opsi diawali dengan tanda hubung (`-`) untuk opsi satu huruf atau tanda hubung ganda (`--`) untuk opsi kata penuh. Contoh: `-l` vs. `--long`.
      * **Argument (Argumen):** Nilai yang diberikan ke perintah atau opsi. Dalam `ls -l file.txt`, `file.txt` adalah argumen.

  * **Rekomendasi Visualisasi:**
    Visualisasi sederhana yang membandingkan output `man` dan `--help` dapat menyoroti perbedaan antara dokumentasi mendalam dan referensi cepat.

    ```
    ┌──────────────────────────┐     ┌────────────────────────────┐
    │     man ls               │     │      ls --help             │
    └──────────┬───────────────┘     └──────────┬─────────────────┘
               │                                │
               │ (DOKUMENTASI LENGKAP & DETAIL) │ (RINGKASAN CEPAT)
               │                                │
    ┌──────────▼───────────────┐     ┌──────────▼─────────────────┐
    │ NAME                     │     │ USAGE: ls [OPTION]...      │
    │ SYNOPSIS                 │     │                            │
    │ DESCRIPTION              │     │ -l   use a long listing... │
    │ OPTIONS                  │     │ -a   do not ignore files...│
    │ EXAMPLES                 │     │       (dan seterusnya...)  │
    │      (dan seterusnya)    │     └────────────────────────────┘
    └──────────────────────────┘
    ```

  * **Hubungan dengan Modul Lain:**
    Modul ini adalah alat bantu fundamental untuk semua modul yang akan datang. Saat Anda mempelajari perintah baru di **Fase II** dan **Fase III**, Anda tidak lagi hanya akan bergantung pada kurikulum ini. Anda akan memiliki kemampuan untuk mendalami setiap perintah, memahami setiap opsi, dan memecahkan masalah sendiri.

  * **Tips dan Praktik Terbaik:**

      * **Perintah `apropos`:** Jika Anda tidak tahu nama perintahnya, tetapi tahu fungsinya, gunakan `apropos`. Contoh: `apropos "list directory"` akan menampilkan perintah yang relevan.
      * **Latihan Mandiri:** Setelah membaca setiap modul, cobalah menggunakan `man` atau `--help` pada perintah yang baru Anda pelajari. Ini akan melatih otot ingatan dan kemandirian Anda.

  * **Potensi Kesalahan Umum & Solusi:**

      * **Kesalahan:** Mencoba mencari manual untuk perintah yang tidak ada atau tidak terinstal.
      * **Solusi:** `man` akan merespons dengan `No manual entry for [nama_perintah]`. Ini adalah pesan yang jelas yang memberi tahu Anda bahwa perintah tersebut tidak dikenali oleh sistem. Solusinya adalah memastikan perintah tersebut sudah terinstal, atau periksa kembali ejaannya.

# Selamat!

Anda telah menyelesaikan fondasi kurikulum. Dengan tiga modul ini, Anda sekarang memiliki "peta", "kompas", dan "buku manual" untuk menjelajahi CLI. Ini adalah langkah yang sangat signifikan.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../programmer/domain-spesifik/README.md
[kurikulum]: ../README.md
[selanjutnya]: ../bagian-2/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../
[2]: ../
[3]: ../
[4]: ../
[5]: ../
[6]: ../
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
