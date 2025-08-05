### **[Fase 3: Mahir (Advanced)][0]**

**Level:** Mahir (Advanced)

Pada fase ini, Anda akan belajar untuk berpikir seperti seorang pengotomatisasi. Anda tidak hanya akan mengedit teks, tetapi juga akan mengajarkan Helix cara melakukan pekerjaan Anda. Ini akan secara drastis meningkatkan produktivitas Anda, terutama saat menghadapi tugas-tugas yang repetitif.

-----

### **Modul 5: Makro dan Skrip Otomatisasi**

**Struktur Pembelajaran Internal:**

1.  **Deskripsi Konkret & Peran dalam Kurikulum**
2.  **Konsep Kunci & Filosofi Mendalam**
      * Makro: Mesin Perekam Ulang Aksi
      * Integrasi `Shell Command`: Menghubungkan Editor dan Terminal
3.  **Sintaks Dasar / Contoh Implementasi Inti**
      * Merekam, Memutar Ulang, dan Menyimpan Makro
      * Menjalankan Perintah Shell dari Helix
      * Studi Kasus: Otomatisasi Refactoring Kode
4.  **Terminologi Esensial & Penjelasan Detil**
      * `Macro` (Makro)
      * `Shell Command` (Perintah Shell)
      * `Pipe` (`|`)
      * `Refactoring` (Refactoring)
5.  **Rekomendasi Visualisasi**
6.  **Hubungan dengan Modul Lain**
7.  **Sumber Referensi Lengkap**
8.  **Tips dan Praktik Terbaik**
9.  **Potensi Kesalahan Umum & Solusi**

-----

### **1. Deskripsi Konkret & Peran dalam Kurikulum**

Modul ini akan mengajarkan Anda dua konsep utama untuk otomasi: **makro** dan **perintah shell**. Secara konkret, Anda akan belajar cara merekam serangkaian penekanan tombol dan memutarnya kembali, serta cara menjalankan perintah terminal langsung dari dalam Helix.

Peran modul ini adalah untuk mengubah Anda dari pengguna editor yang terampil menjadi **"pengembang alur kerja"**. Anda akan mulai melihat tugas-tugas berulang bukan sebagai pekerjaan membosankan, tetapi sebagai peluang untuk membuat alat yang lebih baik. Menguasai makro dan integrasi shell akan memungkinkan Anda menghemat waktu yang signifikan dalam jangka panjang.

### **2. Konsep Kunci & Filosofi Mendalam**

#### **Makro: Mesin Perekam Ulang Aksi**

Filosofi di balik makro sederhana: jika Anda menemukan diri Anda melakukan serangkaian tindakan yang sama berulang kali, rekamlah. Makro di Helix adalah urutan perintah yang direkam dan dapat diputar kembali. Ini sangat berguna untuk tugas-tugas repetitif yang tidak bisa diotomatisasi dengan `search` dan `replace` biasa.

  * **Sifat Makro:**
      * **Stateful:** Makro mengingat `state` (keadaan) dari editor saat direkam. Jadi, jika Anda merekam pergerakan kursor 3 baris ke bawah, makro akan selalu menggerakkan kursor 3 baris ke bawah, bukan ke baris absolut yang sama.
      * **Ephemeral:** Makro yang direkam secara default hanya ada selama sesi Helix saat ini. Untuk menyimpannya, Anda harus memetakannya ke `keybinding` di file konfigurasi.

#### **Integrasi `Shell Command`: Menghubungkan Editor dan Terminal**

Helix memiliki integrasi yang kuat dengan **terminal** atau **shell**. Ini memungkinkan Anda menjalankan perintah eksternal langsung dari dalam editor.

  * **Filosofi:** Editor adalah tempat Anda mengedit teks, dan terminal adalah tempat Anda memproses teks. Integrasi shell memungkinkan kedua dunia ini berinteraksi. Anda bisa mengirimkan seleksi teks ke sebuah perintah shell, membiarkan perintah tersebut memprosesnya, dan kemudian menempatkan hasilnya kembali ke dalam editor.

  * **Contoh:** Anda bisa mengirimkan sebuah blok kode ke `formatter` eksternal seperti `black` (Python) atau `prettier` (JavaScript), dan hasilnya akan langsung menggantikan blok kode di editor Anda.

### **3. Sintaks Dasar / Contoh Implementasi Inti**

#### **Merekam, Memutar Ulang, dan Menyimpan Makro**

  * **Merekam Makro:**
    1.  Masuk ke **Normal Mode**.
    2.  Tekan `q`. Anda akan melihat indikator `recording` di baris status bawah.
    3.  Lakukan serangkaian tindakan yang ingin Anda rekam (navigasi, seleksi, modifikasi, dll.).
    4.  Tekan `q` lagi untuk menghentikan rekaman.
  * **Memutar Ulang Makro:**
    1.  Tekan `Q` (huruf kapital). Ini akan memutar ulang makro terakhir yang direkam.
  * **Menyimpan Makro (Memetakan ke `keybinding`):**
      * Anda dapat mengkonfigurasi makro untuk dijalankan dari file `config.toml`. Karena makro bersifat sementara, ini adalah cara untuk membuatnya permanen.
      * **Sintaks:**
    <!-- end list -->
    ```toml
    [keys.normal]
    "space m" = ":record-macro <macro_name>"
    ```
      * **Catatan:** Untuk saat ini, Anda hanya perlu memahami konsepnya. Implementasi yang lebih kompleks akan dibahas di Fase 4.

#### **Menjalankan Perintah Shell dari Helix**

  * **Menjalankan Perintah dan Mengganti Seleksi:**

      * `|` (pipe): Perintah ini akan mengirimkan seleksi teks ke `stdin` (input standar) dari perintah shell.
      * **Contoh:** Anda memiliki baris-baris kode yang tidak terurut dan ingin mengurutkannya secara alfabetis.
        1.  Pilih baris-baris tersebut.
        2.  Tekan `|`.
        3.  Ketik `sort` dan tekan `Enter`.
        4.  Teks yang dipilih akan diganti dengan versi yang sudah terurut.

  * **Menjalankan Perintah Tanpa Mengganti Seleksi:**

      * `:sh <perintah>`: Ini akan menjalankan perintah di terminal eksternal.
      * **Contoh:** Anda ingin melihat status Git dari dalam Helix.
        1.  Tekan `:` untuk masuk ke *command mode*.
        2.  Ketik `sh git status`.
        3.  Hasilnya akan ditampilkan di bawah baris perintah, dan Anda bisa menekannya untuk membukanya di panel baru.

#### **Studi Kasus: Otomatisasi Refactoring Kode**

Bayangkan Anda memiliki beberapa baris kode yang ingin Anda komentari:

```text
// Ini adalah baris 1
ini adalah baris 2
ini adalah baris 3
```

Anda ingin menambahkan `//` di awal baris 2 dan 3.

1.  Tempatkan kursor di awal baris 2.
2.  Mulai merekam makro dengan `q`.
3.  Tekan `_` dua kali untuk memilih baris.
4.  Tekan `I` (huruf kapital) untuk masuk ke **Insert Mode** di awal baris.
5.  Ketik ` //  `.
6.  Tekan `ESC` untuk kembali ke **Normal Mode**.
7.  Tekan `j` untuk pindah ke baris berikutnya.
8.  Tekan `q` untuk menghentikan rekaman.
9.  Tekan `Q` untuk memutar ulang makro.
10. ` //  ` akan ditambahkan di baris 3.

Ini adalah contoh sederhana bagaimana makro dapat menghemat waktu untuk tugas-tugas yang berulang.

### **4. Terminologi Esensial & Penjelasan Detil**

  * **`Macro` (Makro):**
      * **Arti:** Urutan penekanan tombol dan perintah yang direkam dan dapat diputar kembali.
      * **Maksud:** Ini adalah cara Helix mengotomatisasi tugas-tugas repetitif yang dilakukan di editor, seperti memformat baris teks, menambahkan komentar, atau memindahkan blok kode.
  * **`Shell Command` (Perintah Shell):**
      * **Arti:** Perintah yang dieksekusi di terminal (seperti `ls`, `grep`, `sort`, `sed`).
      * **Maksud:** Helix memungkinkan Anda menjalankan perintah-perintah ini dari dalam editor, menghubungkan kemampuan editor dengan kekuatan terminal.
  * **`Pipe` (`|`):**
      * **Arti:** Sebuah operator yang mengarahkan `output` (keluaran) dari satu perintah ke `input` (masukan) dari perintah lain.
      * **Maksud:** Di Helix, operator `|` digunakan untuk mengirimkan teks yang dipilih ke perintah shell untuk diproses, dan kemudian mengganti seleksi dengan output dari perintah tersebut.
  * **`Refactoring` (Refactoring):**
      * **Arti:** Proses restrukturisasi kode yang ada tanpa mengubah perilaku eksternalnya.
      * **Maksud:** Ini adalah salah satu kasus penggunaan makro yang paling umum, di mana Anda dapat mengotomatisasi perubahan pada struktur kode seperti mengganti nama variabel, mengekstrak fungsi, atau mengubah format.

### **5. Rekomendasi Visualisasi**

  * **Diagram Alur Makro:** Sebuah diagram sederhana yang menunjukkan langkah-langkah perekaman dan pemutaran ulang makro. Ini bisa menampilkan alur: `q` -\> Aksi -\> `q` -\> `Q`.
  * **Diagram Alur Integrasi Shell:** Diagram yang memvisualisasikan bagaimana seleksi teks mengalir (melalui `pipe`) dari Helix ke perintah shell dan kemudian kembali. Ini akan membantu pembelajar memahami konsep `stdin` dan `stdout` secara visual.

### **6. Hubungan dengan Modul Lain**

Modul ini adalah titik di mana semua yang telah Anda pelajari bertemu.

  * **Modul 1 & 2 (Navigasi & Seleksi):** Tanpa penguasaan navigasi dan seleksi yang efisien, makro Anda tidak akan efektif. Makro yang buruk akan membuang-buang waktu, sedangkan makro yang baik dibangun di atas gerakan yang tepat dan pemilihan teks yang akurat.
  * **Fase 4 (Ahli):** Konsep di sini adalah fondasi untuk kustomisasi tingkat lanjut. Di Fase 4, Anda akan belajar cara memprogram Helix untuk melakukan tugas-tugas yang lebih kompleks daripada sekadar makro sederhana.

### **7. Sumber Referensi Lengkap**

  * **Dokumentasi Resmi Helix:**
      * [Keymap: Macros](https://www.google.com/search?q=https://docs.helix-editor.com/keymap.html%23macros): Panduan singkat tentang cara menggunakan makro.
      * [Keymap: Command Palette](https://www.google.com/search?q=https://docs.helix-editor.com/keymap.html%23command-palette): Penjelasan tentang perintah yang dapat dijalankan dari `sh`.
  * **Sumber Belajar Shell Scripting:**
      * [Advanced Bash-Scripting Guide](http://tldp.org/LDP/abs/html/): Sumber daya klasik untuk belajar perintah-perintah shell.

### **8. Tips dan Praktik Terbaik**

  * **Perencanaan Makro:** Sebelum merekam, pikirkan langkah-langkah yang akan Anda ambil. Makro yang efisien adalah makro yang direncanakan. Gunakan perintah navigasi yang akurat (`w`, `b`, `_` dua kali) daripada pergerakan karakter per karakter.
  * **"Mental Dry-Run":** Selalu lakukan simulasi mental dari makro Anda sebelum merekamnya. Pastikan tidak ada langkah yang sia-sia atau tidak efisien.
  * **Periksa Perintah Shell:** Pastikan perintah shell yang Anda gunakan bekerja dengan benar di terminal sebelum Anda menggunakannya di Helix.

### **9. Potensi Kesalahan Umum & Solusi**

  * **Kesalahan:** Makro tidak bekerja dengan benar di baris lain.
      * **Solusi:** Ini sering terjadi karena makro bersifat `stateful`. Pastikan makro Anda menggunakan pergerakan relatif (`j` untuk turun satu baris) daripada absolut (`3j` untuk turun tiga baris).
  * **Kesalahan:** `|` (pipe) tidak melakukan apa-apa.
      * **Solusi:** Pastikan Anda telah memilih teks sebelum menekan `|`. Perintah ini membutuhkan seleksi.
  * **Kesalahan:** Perintah shell memberikan `error` yang tidak diharapkan.
      * **Solusi:** Cobalah jalankan perintah shell tersebut di terminal biasa. Jika ia juga memberikan error, berarti masalahnya ada pada perintah itu sendiri, bukan pada Helix.

-----

Dengan penguasaan makro dan integrasi shell, Anda sekarang dapat mengotomatisasi tugas-tugas rutin, membebaskan waktu Anda untuk hal-hal yang lebih penting. Anda telah melangkah dari pengguna editor ke seorang pengembang alur kerja.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
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
