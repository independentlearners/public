### **[Fase III: Advanced (Mahir)][0]**

Melalui fase sebelumnya, Anda telah menguasai dasar-dasar navigasi dan manipulasi data. Sekarang, kita akan memasuki fase yang mengubah Anda dari pengguna menjadi **kreator**. Kita akan membahas **shell scripting**, yaitu kemampuan untuk menulis program mini yang mengotomatisasi tugas. 

Fase ini adalah tentang memanfaatkan kekuatan penuh dari CLI. Anda akan belajar bagaimana mengotomasi tugas, membuat alur kerja Anda sendiri, dan mengelola sistem dengan efisiensi tingkat tinggi.

#### **Modul 3.1: Shell Scripting 101 (Dasar-dasar Skrip Shell)**

<details>
  <summary>📃 Daftar Isi</summary>

-----

  * **Struktur Pembelajaran Internal:**

      * Apa itu Shell Scripting dan Mengapa Penting?
      * Filosofi Otomasi dan Efisiensi.
      * Langkah Pertama: Membuat dan Menjalankan Skrip Sederhana.
      * Konsep Variabel dalam Skrip.
      * Struktur Logika: Kondisional (`if-then-else`) dan Perulangan (`for`, `while`).
      * Fungsi dalam Skrip Shell.

</details>

-----

  * **Deskripsi Konkret & Peran dalam Kurikulum:**
    Modul ini adalah titik puncak dari kurikulum Anda. **Shell script** adalah program teks sederhana yang berisi urutan perintah-perintah shell. Perannya sangat krusial: mengotomasi tugas-tugas yang repetitif, meminimalkan kesalahan manusia, dan memungkinkan Anda melakukan pekerjaan besar dengan satu perintah tunggal. Di sinilah Anda benar-benar akan merasa seperti seorang ahli, karena Anda tidak lagi hanya menggunakan alat, tetapi mulai membangunnya.

  * **Konsep Kunci & Filosofi Mendalam:**

      * **Otomasi (Automation):** Filosofi inti dari *shell scripting*. Daripada melakukan tugas yang sama berulang kali (misalnya, menyalin file, mengunduh data, mencadangkan direktori), Anda menulis skrip sekali saja dan menjalankannya kapan pun Anda butuhkan. Ini menghemat waktu, energi, dan membebaskan Anda untuk fokus pada masalah yang lebih kompleks.
      * **Shebang (`#!`):** Ini adalah baris pertama yang wajib ada di setiap skrip. **Shebang** memberi tahu sistem operasi "program mana yang harus saya gunakan untuk menjalankan skrip ini?". Baris ini sangat penting karena memastikan skrip Anda dieksekusi oleh interpreter yang benar, misalnya Bash.

  * **Sintaks Dasar / Contoh Implementasi Inti:**

      * **Langkah 1: Membuat Skrip Pertama**
        Buat file baru dengan ekstensi `.sh`. Kita akan menggunakan editor teks berbasis CLI favorit Anda, seperti **Vim** atau **Nano**.

        ```bash
        nano first_script.sh
        ```

        Kemudian, ketik kode berikut:

        ```bash
        #!/bin/bash
        # Baris di atas adalah Shebang, dan '#' adalah komentar.

        echo "Skrip saya berjalan!"
        echo "Tanggal saat ini adalah: $(date)"
        ```

        **Penjelasan:**

          * `#!/bin/bash`: Shebang yang menyatakan interpreter yang digunakan adalah Bash.
          * `# ...`: Tanda pagar (`#`) menunjukkan bahwa baris itu adalah komentar dan akan diabaikan oleh Bash. Ini penting untuk membuat skrip Anda mudah dibaca.
          * `echo ...`: Perintah `echo` yang sudah Anda kenal, sekarang digunakan di dalam skrip.
          * `$(date)`: Ini adalah sintaks **substitusi perintah** (*command substitution*). Bash akan menjalankan perintah di dalam tanda `()` dan mengganti `$(date)` dengan hasilnya.

      * **Langkah 2: Memberikan Izin Eksekusi**
        Secara default, skrip baru tidak dapat dijalankan. Anda harus memberikannya izin eksekusi (*executable permission*) menggunakan perintah `chmod`.

        ```bash
        chmod +x first_script.sh
        ```

        **Penjelasan:**

          * **`chmod`** (change mode): Perintah untuk mengubah izin file.
          * **`+x`**: Menambahkan izin eksekusi (`x`) kepada pengguna.

      * **Langkah 3: Menjalankan Skrip**
        Jalankan skrip Anda dengan menentukan jalur relatifnya.

        ```bash
        ./first_script.sh
        # Output:
        # Skrip saya berjalan!
        # Tanggal saat ini adalah: Thu 28 Aug 2025 12:55:53 PM WIB
        ```

        **Penjelasan:**

          * `./`: Merujuk ke direktori saat ini. Ini memberi tahu shell untuk menjalankan skrip yang berada di direktori tempat Anda berada.

      * **Konsep Variabel:**
        Sama seperti dalam bahasa pemrograman lainnya, variabel digunakan untuk menyimpan nilai.

        ```bash
        #!/bin/bash

        NAMA="Ali"
        PESAN="Selamat datang, $NAMA!"

        echo $PESAN
        ```

        **Penjelasan:**

          * `NAMA="Ali"`: Memberikan nilai "Ali" ke variabel `NAMA`. Perhatikan **tidak ada spasi di sekitar `=`**.
          * `$PESAN`: Mengakses nilai dari variabel `PESAN` dengan menambahkan tanda `$` di depannya.

  * **Terminologi Esensial & Penjelasan Detil:**

      * **Shell Script:** Sebuah program komputer yang dirancang untuk dieksekusi oleh shell Unix/Linux.
      * **Shebang (`#!`):** Karakter `#!` diikuti oleh jalur ke interpreter (misalnya `/bin/bash`). Fungsinya adalah untuk memastikan file tersebut dieksekusi oleh program yang benar.
      * **Komentar (Comments):** Baris yang dimulai dengan `#` yang digunakan untuk memberikan catatan di dalam skrip. Ini tidak akan dieksekusi.
      * **Variabel (Variable):** Sebuah nama yang merepresentasikan sebuah nilai. Nilai ini bisa berupa string, angka, atau hasil dari sebuah perintah.
      * **Substitusi Perintah (Command Substitution):** Mekanisme di mana keluaran dari suatu perintah dimasukkan sebagai bagian dari perintah lain. Sintaksnya adalah `$(perintah)`.

  * **Rekomendasi Visualisasi:**
    Diagram alur sederhana yang menunjukkan langkah-langkah dalam membuat dan menjalankan skrip akan sangat membantu.

    ```
    ┌───────────────────────────┐
    │     TULIS SKRIP           │
    │ (Contoh: first_script.sh) │
    └───────────┬───────────────┘
                │
                ▼
    ┌───────────────────────────┐
    │     BERI IZIN EKSEKUSI    │
    │ (Contoh: chmod +x ...)    │
    └───────────┬───────────────┘
                │
                ▼
    ┌───────────────────────────┐
    │      JALANKAN SKRIP       │
    │ (Contoh: ./...)           │
    └───────────────────────────┘
    ```

  * **Hubungan dengan Modul Lain:**
    *Shell scripting* adalah tujuan akhir dari semua yang telah Anda pelajari di **Fase I** dan **Fase II**. Anda akan menggunakan perintah-perintah yang sudah Anda kuasai (`ls`, `cp`, `grep`, `find`) sebagai blok bangunan untuk membuat skrip yang lebih besar. Konsep `piping` dan `redirection` akan sangat sering digunakan dalam skrip untuk memproses data. Skrip yang Anda buat di sini juga dapat menjadi alat pribadi Anda untuk administrasi sistem yang akan dibahas lebih lanjut di **Fase IV**.

  * **Tips dan Praktik Terbaik:**

      * **Gunakan Tanda Kutip (`"` atau `'`):** Selalu gunakan tanda kutip di sekitar variabel, terutama jika nilainya mengandung spasi, untuk menghindari kesalahan. Gunakan `echo "$NAMA"` daripada `echo $NAMA`.
      * **Buat Skrip Modular:** Buat skrip yang lebih kecil yang melakukan satu tugas, lalu panggil skrip-skrip tersebut dari skrip yang lebih besar.

  * **Potensi Kesalahan Umum & Solusi:**

      * **Kesalahan:** Lupa `#!/bin/bash` atau mengetiknya dengan salah.
      * **Solusi:** Pastikan baris shebang ada dan benar di baris paling atas, tanpa spasi di depannya.
      * **Kesalahan:** Lupa memberikan izin eksekusi dengan `chmod`.
      * **Solusi:** Jika Anda mendapatkan pesan `Permission denied` saat mencoba menjalankan skrip, ingatlah untuk menjalankan `chmod +x nama_skrip.sh`.

---

Setelah menguasai dasar-dasar shell scripting, kita akan menyelami bagian yang paling esensial dalam pemrograman: logika dan kontrol alur. Ini adalah yang membedakan skrip sederhana dengan skrip yang cerdas dan adaptif.

-----

#### **Modul 3.1: Shell Scripting 101 (Lanjutan)**

<details>
  <summary>📃 Daftar Isi</summary>


  * **Struktur Pembelajaran Internal:**

      * Pernyataan Kondisional (`if-then-else-fi`): Logika Pengambilan Keputusan.
      * Jenis Perbandingan dalam Shell: Angka, String, dan File.
      * Struktur Perulangan (`for` dan `while`): Otomasi Tugas Berulang.
      * Fungsi Skrip: Memecah Skrip Besar menjadi Bagian Kecil.
      * Memahami `exit codes` dan Penanganan Kesalahan.

---

</details>

  * **Deskripsi Konkret & Peran dalam Kurikulum:**
    Modul ini mengajarkan skrip Anda untuk "berpikir". Anda tidak lagi hanya mengotomasi urutan perintah, tetapi membuat skrip yang bisa membuat keputusan berdasarkan kondisi (misalnya, "jika file ada, maka lakukan ini; jika tidak, lakukan yang lain") dan mengulangi tugas secara otomatis. Ini adalah fondasi dari semua skrip yang canggih, mulai dari skrip pencadangan data hingga alat administrasi sistem.

  * **Konsep Kunci & Filosofi Mendalam:**

      * **Kontrol Alur (Control Flow):** Ini adalah cara skrip mengatur urutan eksekusi perintahnya. Tanpa kontrol alur, skrip akan selalu menjalankan perintah dari atas ke bawah. Dengan kondisi dan perulangan, Anda dapat membuat skrip yang **dinamis** dan **responsif** terhadap lingkungan sekitar.
      * **Modularitas:** Konsep memecah skrip menjadi fungsi-fungsi yang lebih kecil. Filosofi ini menganut prinsip **"Do one thing well"** dari Unix. Sebuah fungsi harus melakukan satu tugas spesifik dengan baik, yang membuat kode lebih bersih, mudah dibaca, dan dapat digunakan kembali.

  * **Sintaks Dasar / Contoh Implementasi Inti:**

      * **Kondisional (`if`):** Digunakan untuk mengeksekusi blok kode hanya jika suatu kondisi terpenuhi.

          * **Sintaks:**
            ```bash
            if [ kondisi ]; then
              # Kode yang dijalankan jika kondisi benar
            fi
            ```
            `if` harus ditutup dengan `fi`.
          * **Contoh Praktis: Memeriksa Keberadaan File**
            ```bash
            #!/bin/bash

            FILE_TO_CHECK="laporan.txt"

            if [ -e "$FILE_TO_CHECK" ]; then
              echo "Berkas '$FILE_TO_CHECK' ditemukan. Sedang memproses..."
            else
              echo "Berkas '$FILE_TO_CHECK' tidak ditemukan. Menghentikan operasi."
            fi
            ```
            **Penjelasan:**
              * `[ -e "$FILE_TO_CHECK" ]`: Ini adalah ekspresi bersyarat. `[ ]` digunakan untuk menguji kondisi. `-e` adalah operator pengujian yang berarti "apakah file ini ada?". `$FILE_TO_CHECK` adalah variabel yang berisi nama file. Selalu gunakan tanda kutip ganda (`"`) untuk variabel yang mungkin berisi spasi.

      * **Perulangan (`for`):** Digunakan untuk mengulangi sebuah blok kode sejumlah kali tertentu.

          * **Sintaks:**
            ```bash
            for var in daftar; do
              # Kode yang diulang
            done
            ```
          * **Contoh Praktis: Memproses File Log**
            ```bash
            #!/bin/bash

            for file in *.log; do
              echo "Memproses berkas: $file"
              # Anda bisa menambahkan perintah lain di sini,
              # seperti 'grep' atau 'sed'
            done
            ```
            **Penjelasan:** Skrip ini akan berulang melalui semua file di direktori saat ini yang memiliki akhiran `.log`. Di setiap perulangan, variabel `file` akan berisi nama file saat ini.

      * **Fungsi:** Memungkinkan Anda untuk mengelompokkan blok kode yang dapat dipanggil kembali.

          * **Sintaks:**
            ```bash
            function nama_fungsi() {
              # Kode fungsi
            }
            ```
          * **Contoh Praktis:**
            ```bash
            #!/bin/bash

            function backup_file() {
              cp "$1" "$1.bak"
              echo "Cadangan berkas '$1' berhasil dibuat."
            }

            backup_file "dokumen_penting.txt"
            ```
            **Penjelasan:**
              * `backup_file()`: Mendefinisikan sebuah fungsi bernama `backup_file`.
              * `$1`: Ini adalah variabel posisi yang merujuk pada argumen pertama yang diberikan saat fungsi dipanggil.

      * **Exit Codes:** Setiap perintah dan skrip di Linux akan mengembalikan **kode keluar** (*exit code*) setelah selesai.

          * `0`: Menunjukkan keberhasilan (biasanya).
          * `1-255`: Menunjukkan kegagalan.
          * Anda bisa melihat kode keluar perintah terakhir dengan variabel `$?`.
          * **Contoh:**
            ```bash
            #!/bin/bash

            rm "file_yang_tidak_ada.txt"
            echo "Kode keluar perintah terakhir adalah: $?"
            # Output akan menjadi kode > 0, karena perintah gagal.
            ```

  * **Terminologi Esensial & Penjelasan Detil:**

      * **Kondisional (Conditional):** Sebuah pernyataan (`if`) yang menguji apakah suatu kondisi benar atau salah.
      * **Perulangan (Loop):** Struktur kontrol yang mengulangi eksekusi blok kode.
      * **Fungsi (Function):** Blok kode yang dapat digunakan kembali, diberi nama, dan dipanggil dari skrip utama atau skrip lain.
      * **Variabel Posisi (`$1`, `$2`, dst.):** Variabel khusus yang berisi argumen yang diberikan ke skrip atau fungsi saat dieksekusi.
      * **Exit Code (Kode Keluar):** Angka yang dikembalikan oleh setiap program untuk menunjukkan status eksekusinya. Ini adalah metode standar untuk penanganan kesalahan dalam skrip.

  * **Rekomendasi Visualisasi:**
    Diagram alur sederhana untuk pernyataan `if` dan `for` akan sangat berguna untuk memvisualisasikan logika.

    **Diagram Alur Kondisional:**

    ```
    ┌──────────┐
    │   MULAI  │
    └──────────┘
        │
        ▼
    ┌───────────────────┐
    │  [Apakah kondisi  │─(Benar)── ►┌───────────────────┐
    │     terpenuhi?]   │            │ Lakukan tugas A   │
    └───────────────────┘◄─(Salah)───└───────────────────┘
        │
        ▼
    ┌───────────────────┐
    │   Lanjutkan ke    │
    │   tugas lain      │
    └───────────────────┘
    ```

  * **Hubungan dengan Modul Lain:**
    Konsep yang dibahas di sini adalah inti dari **Fase IV**, di mana Anda akan mengintegrasikan skrip shell dengan teknologi lain. Misalnya, Anda bisa menulis skrip yang **jika** koneksi SSH berhasil, **maka** ia akan menyalin file menggunakan `scp` atau **memulai** kontainer Docker. Kemampuan untuk mengontrol alur skrip adalah kunci untuk semua tugas otomatisasi dan administrasi yang lebih canggih.

  * **Tips dan Praktik Terbaik:**

      * **Gunakan Tanda Kutip Ganda (`"`)**: Selalu gunakan tanda kutip ganda di sekitar variabel dalam ekspresi bersyarat, terutama saat membandingkan string. Contoh: `if [ "$NAMA" = "Ali" ]; then ...`
      * **Uji Kondisi Anda**: Sebelum menulis skrip, coba uji ekspresi bersyarat Anda di terminal langsung. Contoh: `[ -e "my_file.txt" ] && echo "Ada!"` akan memberi tahu Anda apakah ekspresi itu benar.

  * **Potensi Kesalahan Umum & Solusi:**

      * **Kesalahan:** Lupa spasi di dalam kurung siku `[ ]`. Contoh: `if [ -e"file" ]` (salah).
      * **Solusi:** Selalu pastikan ada spasi di dalam kurung siku, setelah `[`, sebelum `]`, dan di sekitar operator (`-e`, `=`, `!=`).
      * **Kesalahan:** Lupa menutup blok `if` dengan `fi` atau `for` dengan `done`.
      * **Solusi:** Shell akan memberikan pesan *syntax error*. Pastikan setiap blok yang Anda buka memiliki penutupnya.

# selamat!

Anda telah mencapai tonggak penting. Dengan pemahaman tentang logika dan perulangan, Anda sekarang dapat menulis skrip yang benar-benar kuat dan fleksibel.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../programmer/domain-spesifik/README.md
[kurikulum]: ../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

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
