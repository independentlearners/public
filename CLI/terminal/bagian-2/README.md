### **[Fase II: Intermediate (Menengah)][0]**

Fase ini adalah jembatan dari sekadar "menggunakan" menjadi "menguasai". Anda akan belajar bagaimana memanipulasi file, mengelola program, dan menghubungkan perintah-perintah kecil untuk melakukan tugas yang lebih besar.

#### **Modul 2.1: Mastering File & Process Management (Menguasai Manajemen File & Proses)**

<details>
  <summary>📃 Daftar Isi</summary>

---

* **Struktur Pembelajaran Internal:**
    * Konsep `I/O` (Input/Output) dan *Standard Streams*.
    * Manajemen File: `cp`, `mv`, `rm`, `touch`.
    * Melihat Isi File: `cat`, `less`.
    * Pengantar Manajemen Proses: `ps`, `top`, `kill`.

</details>

---

* **Deskripsi Konkret & Peran dalam Kurikulum:**
    Modul ini adalah tentang tindakan. Di sini, Anda akan melampaui navigasi dan mulai melakukan perubahan nyata pada sistem file Anda. Anda akan belajar cara menyalin, memindahkan, menghapus, dan membuat file. Lebih penting lagi, Anda akan mendapatkan pemahaman awal tentang bagaimana program berjalan di latar belakang dan bagaimana cara menghentikannya jika diperlukan. Ini adalah langkah pertama Anda dalam menjadi seorang administrator sistem yang cakap.

* **Konsep Kunci & Filosofi Mendalam:**
    * **Konsep I/O dan *Standard Streams*:** Setiap program di Linux memiliki tiga "aliran data" standar:
        1.  **`stdin` (Standard Input):** Tempat program menerima masukan. Defaultnya dari keyboard.
        2.  **`stdout` (Standard Output):** Tempat program mengirimkan keluaran yang berhasil. Defaultnya ke layar terminal.
        3.  **`stderr` (Standard Error):** Tempat program mengirimkan pesan kesalahan. Defaultnya juga ke layar terminal, tetapi terpisah dari `stdout`.

        Konsep ini adalah fondasi dari **piping** (`|`) dan **redirection** (`>`, `<`) yang akan kita bahas di modul berikutnya. Filosofinya adalah "program yang melakukan satu hal dengan baik." Dengan memisahkan aliran data, kita bisa menggabungkan program-program ini seperti lego, di mana output dari satu program bisa menjadi input untuk program lain.

* **Sintaks Dasar / Contoh Implementasi Inti:**

    * **Manajemen File:**
        * **`cp` (copy):** Menyalin file atau direktori.
            * **Sintaks:** `cp [sumber] [tujuan]`
            * **Contoh:** `cp my_notes.txt ~/Documents/` (menyalin `my_notes.txt` ke direktori `Documents` di *home directory*).
        * **`mv` (move):** Memindahkan atau mengganti nama file/direktori.
            * **Sintaks:** `mv [sumber] [tujuan]`
            * **Contoh:** `mv old_name.txt new_name.txt` (mengganti nama file).
            * **Contoh:** `mv my_notes.txt ~/backup/` (memindahkan file ke direktori `backup`).
        * **`rm` (remove):** Menghapus file.
            * **Sintaks:** `rm [file]`
            * **Contoh:** `rm unused.txt`
            * **PERHATIAN:** Perintah `rm` sangat kuat dan **tidak memiliki keranjang sampah**. Sekali Anda menghapus, file tersebut hilang. Selalu gunakan opsi `-i` untuk konfirmasi interaktif jika Anda tidak yakin (`rm -i file.txt`). Gunakan opsi `-r` untuk menghapus direktori secara rekursif (`rm -r my_folder`).

    * **Melihat Isi File:**
        * **`cat` (concatenate):** Menampilkan seluruh isi file.
            * **Contoh:** `cat report.log`
        * **`less`:** Menampilkan isi file satu layar penuh pada satu waktu, memungkinkan Anda menggulir. Ini lebih baik untuk file yang besar.
            * **Contoh:** `less large_report.log` (Gunakan `q` untuk keluar).

    * **Manajemen Proses:**
        * **`ps` (process status):** Menampilkan daftar proses yang sedang berjalan.
            * **Contoh:** `ps aux` (menampilkan semua proses milik semua pengguna).
        * **`top` atau `htop`:** Monitor proses yang interaktif, mirip dengan *Task Manager* di Windows.
            * **Contoh:** `htop` (jika terinstal) menampilkan daftar proses, penggunaan CPU, memori, dan lainnya secara *real-time*.
        * **`kill`:** Mengirim sinyal ke proses untuk mengakhirinya.
            * **Sintaks:** `kill [PID]` (PID = Process ID, nomor unik proses).
            * **Studi Kasus:** Jika sebuah program macet, Anda bisa menemukan PID-nya dengan `ps` atau `htop`, lalu mengakhirinya.
                1.  Cari PID: `ps aux | grep "nama_program"`
                2.  Akhiri proses: `kill [PID_yang_ditemukan]`

* **Terminologi Esensial & Penjelasan Detil:**
    * **File:** Koleksi data yang disimpan di dalam direktori.
    * **Proses (Process):** Sebuah program yang sedang berjalan. Setiap proses memiliki ID unik, yang disebut **PID**.
    * **PID (Process ID):** Nomor identifikasi unik yang diberikan oleh sistem operasi kepada setiap proses.
    * **Concatenate (Menggabungkan):** `cat` secara teknis berarti "menggabungkan," karena ia dapat menggabungkan isi dari beberapa file dan menampilkannya sebagai satu output.

* **Potensi Kesalahan Umum & Solusi:**
    * **Kesalahan:** Menggunakan `rm` tanpa berpikir. Ini adalah kesalahan yang paling sering dan paling fatal bagi pemula.
    * **Solusi:** Selalu gunakan `rm -i` atau setidaknya pikirkan dua kali sebelum menekan `Enter` pada perintah `rm`. Pelajari cara membuat alias untuk perintah `rm` yang secara otomatis menyertakan `-i`.
    * **Kesalahan:** Mencoba menghapus direktori dengan `rm` tanpa opsi `-r`.
    * **Solusi:** `rm` tidak akan menghapus direktori. Gunakan `rmdir` (untuk direktori kosong) atau `rm -r` (untuk direktori dan isinya).

* **Hubungan dengan Modul Lain:**
    Keterampilan manajemen file ini adalah dasar untuk semua kegiatan administrasi sistem. Anda akan menggunakannya untuk mengatur skrip shell yang akan Anda pelajari di **Fase III**. Pengetahuan tentang manajemen proses sangat penting untuk *troubleshooting* dan administrasi sistem yang mendalam.

-----

#### **Modul 2.2: Piping, Redirection, dan Kekuatan Pencarian (`grep`, `find`)**

<details>
  <summary>📃 Daftar Isi</summary>

---

  * **Struktur Pembelajaran Internal:**

      * Konsep `Piping` (`|`): Menghubungkan Perintah.
      * Konsep `Redirection` (`>`, `>>`, `<`): Mengubah Aliran Data.
      * Menggabungkan Perintah: Studi Kasus Praktis.
      * Pencarian Teks dengan `grep`: Sintaks & Contoh.
      * Pencarian File dengan `find`: Sintaks & Opsi Lanjutan.
      * Kombinasi `grep`, `find`, `xargs`, dan Perintah Lain.

---

</details>
 
  * **Deskripsi Konkret & Peran dalam Kurikulum:**
    Modul ini mengajarkan Anda seni menggabungkan perintah, yang merupakan esensi dari filosofi "Unix-way"—membuat program-program kecil yang melakukan satu hal dengan sangat baik, kemudian menggabungkan outputnya. Anda akan belajar bagaimana mengarahkan keluaran dari satu perintah ke input perintah lain (`piping`) atau ke sebuah file (`redirection`). Selain itu, Anda akan mendalami dua alat pencarian yang paling penting, `grep` dan `find`, yang akan menjadi senjata utama Anda untuk menemukan informasi di seluruh sistem, baik itu file maupun teks di dalamnya.

  * **Konsep Kunci & Filosofi Mendalam:**

      * **Piping (`|`):** Ini adalah pipa virtual yang mengalirkan **`stdout`** (keluaran standar) dari perintah di sisi kiri ke **`stdin`** (masukan standar) dari perintah di sisi kanan. Filosofinya sangat sederhana namun revolusioner: **aliran data**. Ini memungkinkan Anda membangun alur kerja yang kompleks dari perintah-perintah sederhana. Daripada membuat program raksasa yang melakukan segalanya, Anda cukup "merakit" perintah-perintah yang sudah ada.
      * **Redirection (`>`, `>>`, `<`):** Ini adalah proses mengalihkan aliran data. `>` mengarahkan `stdout` ke file, `>>` menambahkan `stdout` ke akhir file, dan `<` mengarahkan konten file sebagai `stdin` ke sebuah perintah. Ini membebaskan Anda dari interaksi keyboard-layar, memungkinkan Anda untuk menyimpan hasil perintah atau memproses data dari file tanpa mengetik.
      * **`grep` dan `find`:** Kedua perintah ini menganut filosofi **pencarian yang efisien**. `find` dirancang untuk mencari objek (file atau direktori) berdasarkan kriteria seperti nama, tipe, atau waktu, sementara `grep` (Global Regular Expression Print) dirancang untuk mencari konten (pola teks) di dalam file. Mereka adalah dua sisi dari mata uang yang sama dalam hal pencarian di sistem Linux.

  * **Sintaks Dasar / Contoh Implementasi Inti:**

      * **Contoh Piping:** Mari kita gabungkan perintah `ls -l` dan `grep`. Bayangkan Anda ingin mencari file atau direktori yang mengandung kata "Videos" dalam daftar panjang.

        ```bash
        ls -l | grep "Videos"
        ```

        **Penjelasan:**

        1.  **`ls -l`**: Mencetak daftar file secara rinci ke **`stdout`**.
        2.  **`|`**: Tanda pipa mengambil seluruh keluaran dari `ls -l`.
        3.  **`grep "Videos"`**: Menerima keluaran dari pipa sebagai `stdin`, kemudian mencari baris yang cocok dengan "Videos" dan mencetaknya.
            *Hasilnya: Anda hanya akan melihat baris yang relevan.*

      * **Contoh Redirection (`>`):** Anda ingin menyimpan daftar semua file di direktori Anda ke dalam sebuah file teks.

        ```bash
        ls -l > daftar_file.txt
        ```

        **Penjelasan:**

        1.  **`ls -l`**: Mencetak daftar file secara rinci ke **`stdout`**.
        2.  **`>`**: Mengarahkan seluruh `stdout` ke file `daftar_file.txt`. Jika file sudah ada, isinya akan **ditimpa**.

      * **Contoh Redirection (`>>`):** Anda ingin menambahkan daftar file baru ke file yang sudah ada tanpa menimpa isinya.

        ```bash
        echo "Daftar diperbarui pada `date`" >> daftar_file.txt
        ```

        **Penjelasan:**

        1.  **`echo`**: Mencetak pesan dan tanggal.
        2.  **`>>`**: Menambahkan pesan ke akhir file `daftar_file.txt`.

      * **Studi Kasus: Menggabungkan `find` dan `grep`:** Bayangkan Anda ingin mencari semua file `.log` di direktori saat ini yang berisi kata "error".

        ```bash
        find . -name "*.log" -exec grep -H "error" {} \;
        ```

        **Penjelasan:**

        1.  **`find . -name "*.log"`**: Mencari semua file dengan akhiran `.log` di direktori saat ini (`.`).
        2.  **`-exec`**: Opsi yang menjalankan perintah di setiap file yang ditemukan.
        3.  **`grep -H "error" {} \;`**: Menjalankan `grep` di setiap file. ` {}  ` adalah *placeholder* untuk nama file yang ditemukan oleh `find`. Opsi `-H` memastikan `grep` juga mencetak nama file tempat kecocokan ditemukan.

  * **Terminologi Esensial & Penjelasan Detil:**

      * **Pipa (Pipe):** Istilah slang untuk simbol `|`, sebuah mekanisme untuk menghubungkan keluaran dari satu proses ke masukan dari proses lain.
      * **Redirection (Pengalihan):** Proses mengalihkan aliran data dari lokasi defaultnya (keyboard atau layar) ke lokasi lain (file).
      * **`stdin`, `stdout`, `stderr`:**
          * `stdin` (Standard Input): Masukan data ke program.
          * `stdout` (Standard Output): Keluaran data dari program yang berhasil.
          * `stderr` (Standard Error): Keluaran pesan kesalahan.
      * **Regular Expression (Regex):** Pola karakter yang digunakan oleh `grep` untuk mencocokkan teks yang kompleks dan fleksibel.

  * **Rekomendasi Visualisasi:**
    Diagram alur data adalah cara terbaik untuk memvisualisasikan `piping` dan `redirection`.

    **Diagram Konsep Piping:**

    ```
    ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
    │  Perintah 1 ├───► │      |      ├───► │  Perintah 2 │
    │ (`ls -l`)   │     │    (Pipa)   │     │ (`grep`)    │
    │  (Output)   │     │             │     │ (Input)     │
    └─────────────┘     └─────────────┘     └─────────────┘
    ```

    **Diagram Konsep Redirection:**

    ```
    ┌─────────────┐     ┌─────────────┐     ┌─────────────┐ 
    │  Perintah 1 ├───► │      >      ├───► │     File    │
    │ (`ls -l`)   │     │ (Pengalihan)│     │             │
    │  (Output)   │     │             │     │(Penyimpanan)│
    └─────────────┘     └─────────────┘     └─────────────┘
    ```

  * **Hubungan dengan Modul Lain:**
    Modul ini adalah fondasi yang krusial untuk **Fase III** (*Shell Scripting*). Skrip shell sebagian besar terdiri dari rangkaian perintah-perintah yang dihubungkan dengan `piping` dan `redirection` untuk mengotomatisasi tugas. Tanpa pemahaman mendalam tentang modul ini, membuat skrip yang efisien dan andal hampir tidak mungkin. Keterampilan ini juga akan sangat berguna saat Anda berinteraksi dengan alat-alat canggih seperti **Git** atau **Docker** di **Fase IV**.

  * **Tips dan Praktik Terbaik:**

      * **Gabungkan:** Jangan ragu untuk menggabungkan beberapa perintah dengan pipa. Contoh: `ps aux | grep user | wc -l` (mencari berapa banyak proses yang dijalankan oleh pengguna saat ini).
      * **Gunakan `less` atau `more`:** Jika keluaran suatu perintah terlalu panjang, gunakan `| less` untuk melihatnya satu layar penuh pada satu waktu. Contoh: `find /etc -name "*.conf" | less`.
      * **Pelajari `regex`:** Untuk penggunaan `grep` yang profesional, luangkan waktu untuk mempelajari dasar-dasar ekspresi reguler.

  * **Potensi Kesalahan Umum & Solusi:**

      * **Kesalahan:** Menggunakan `>` (satu tanda) ketika Anda seharusnya menggunakan `>>` (dua tanda), sehingga menimpa data penting.
      * **Solusi:** Selalu cek ulang perintah Anda sebelum menekan `Enter`, terutama saat menggunakan `>`. Jika Anda tidak yakin, jalankan perintahnya terlebih dahulu tanpa pengalihan untuk melihat keluarannya, baru kemudian tambahkan `>>`.
      * **Kesalahan:** Menggunakan `piping` untuk perintah yang tidak membaca dari `stdin`. Tidak semua perintah bisa menerima input melalui pipa.
      * **Solusi:** Jika perintah Anda tidak berfungsi dengan pipa, cek manualnya dengan `man [nama_perintah]` dan cari bagian yang menyebutkan `stdin` atau `input`.

# Selamat!

Anda telah berhasil menguasai konsep yang membedakan pengguna CLI dari pengguna biasa. Dengan ini, Anda siap untuk melangkah lebih jauh dan membuat program mini Anda sendiri.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

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
