Setelah membahas pengujian dan keamanan, kita sekarang beralih ke pertimbangan praktis dalam menerapkan pola-pola ini di dunia nyata yang beragam. Sebuah skrip yang berjalan sempurna di mesin Windows Anda mungkin gagal di server Linux atau perangkat seluler. Bagian ini membahas cara menulis pattern yang portabel dan andal di berbagai platform dan lingkungan.

---

### Daftar Isi (Bagian XIII)

- [**BAGIAN XIII: CROSS-PLATFORM CONSIDERATIONS**](#bagian-xiii-cross-platform-considerations)
  - [13.1 Platform-specific Pattern Considerations](#131-platform-specific-pattern-considerations)
  - [13.2 Mobile Development Patterns](#132-mobile-development-patterns)
  - [13.3 Embedded Systems Patterns](#133-embedded-systems-patterns)

---

## **[BAGIAN XIII: CROSS-PLATFORM CONSIDERATIONS][0]**

Lua bangga akan portabilitasnya, tetapi sebagai programmer, kita harus membantu memastikan portabilitas tersebut, terutama saat berinteraksi dengan sistem file dan teks.

### 13.1 Platform-specific Pattern Considerations

- **Path Separator Patterns (Pola Pemisah Jalur)**: Ini adalah masalah lintas platform yang paling umum.

  - **Masalah**: Windows menggunakan backslash (`\`), sementara sistem mirip Unix (Linux, macOS) menggunakan slash (`/`). Skrip yang mencari `/` secara harfiah akan gagal di Windows.
  - **Solusi**: Tulis pattern yang menerima kedua pemisah. Gunakan set karakter `[/\\\\]` untuk mencocokkan salah satu. Perhatikan bahwa backslash perlu di-escape dua kali: sekali untuk string Lua, dan sekali untuk pattern. Pendekatan yang lebih bersih seringkali adalah menormalkan jalur di awal: ganti semua `\` menjadi `/` dan kemudian gunakan `/` secara konsisten di sisa kode Anda.

  <!-- end list -->

  ```lua
  local path_windows = "C:\\Users\\Budi\\Documents"

  -- Normalisasi jalur
  local path_normalized = string.gsub(path_windows, "\\", "/")
  print(path_normalized) -- Output: C:/Users/Budi/Documents

  -- Sekarang Anda bisa dengan aman mencari '/'
  local user = string.match(path_normalized, "/Users/([^/]+)")
  print("User:", user) -- Output: User: Budi
  ```

- **Line Ending Handling (Penanganan Akhir Baris)**:

  - **Masalah**: Windows menggunakan `CRLF` (`\r\n`), sementara Unix menggunakan `LF` (`\n`). Pattern yang mencari `\n` mungkin tidak berfungsi seperti yang diharapkan pada file teks yang berasal dari Windows.
  - **Solusi**: Buat pattern Anda fleksibel. Untuk mencocokkan akhir baris, gunakan `\r?\n`. Tanda tanya `?` membuat `\r` menjadi opsional, sehingga cocok dengan `\n` dan `\r\n`.

- **Encoding-aware Patterns (Pola Sadar Encoding)**: Seperti dibahas di Bagian III, jangan pernah mengasumsikan teks Anda adalah ASCII. Gunakan library `utf8` saat bekerja dengan teks yang mungkin berisi karakter internasional untuk memastikan `.` dan pattern lainnya bekerja pada tingkat karakter, bukan byte.

- **Locale Considerations (Pertimbangan Lokal)**: Lokal sistem dapat memengaruhi apa yang dianggap sebagai huruf atau angka. Pattern standar Lua sebagian besar _tidak_ sadar lokal (locale-agnostic), yang berarti `%a` akan selalu `[a-zA-Z]`. Ini bagus untuk konsistensi, tetapi jika Anda memerlukan pemrosesan yang benar-benar sesuai dengan aturan linguistik lokal, Anda perlu menggunakan library eksternal yang lebih kuat seperti binding untuk ICU.

### 13.2 Mobile Development Patterns

Mengembangkan untuk perangkat seluler (misalnya, menggunakan framework seperti Solar2D/Corona SDK) memiliki serangkaian kendala unik.

- **iOS/Android Specific Patterns**: Jalur file pada sistem operasi seluler sangat terstruktur dan berada dalam _sandbox_. Pattern dapat digunakan untuk mem-parsing dan memvalidasi jalur ke direktori-direktori spesifik seperti `system.DocumentsDirectory`.
- **Resource Constraint Handling (Penanganan Keterbatasan Sumber Daya)**: Ponsel memiliki memori dan daya CPU yang lebih terbatas daripada desktop.
  - Semua teknik optimisasi dari Bagian VIII menjadi sangat penting.
  - Hindari pattern yang serakah dan tidak efisien pada data besar.
  - Gunakan pola _lazy processing_ (pemrosesan malas) dengan coroutine atau iterator untuk memproses data besar agar tidak membebani memori.
- **Battery Optimization (Optimisasi Baterai)**: Loop yang menjalankan pattern matching yang intensif CPU akan menguras baterai dengan cepat. Kode Anda harus melakukan pekerjaannya seefisien mungkin dan kemudian membiarkan CPU kembali ke keadaan daya rendah.

### 13.3 Embedded Systems Patterns

Ini adalah lingkungan di mana Lua berasal dan bersinar, tetapi juga yang paling menantang.

- **Memory-constrained Pattern Matching (Pencocokan Pola dengan Memori Terbatas)**: Di sini, memori diukur dalam kilobyte.
  - Mengalokasikan banyak string capture adalah hal yang harus dihindari.
  - Memproses data dalam aliran (stream) adalah suatu keharusan, bukan pilihan.
  - Library besar seperti LPeg mungkin terlalu besar untuk muat di perangkat. Anda seringkali terbatas pada library `string` standar Lua dan harus menggunakannya dengan sangat bijaksana.
- **Real-time Pattern Processing (Pemrosesan Pola Real-time)**: Dalam beberapa sistem tertanam, respons harus terjadi dalam batas waktu yang sangat ketat (misalnya, dalam beberapa milidetik). Kinerja pattern harus dapat diprediksi dan deterministik. Kesederhanaan pattern bawaan Lua sebenarnya menjadi keuntungan di sini, karena perilakunya lebih mudah dianalisis daripada mesin regex yang kompleks.
- **Hardware-specific Optimizations**: Beberapa mikrokontroler mungkin memiliki akselerasi perangkat keras untuk operasi tertentu. Integrasi tingkat lanjut dapat melibatkan penulisan modul C kustom untuk memanfaatkan fitur-fitur ini.

---

Bagian ini telah memberi Anda perspektif tentang bagaimana lingkungan eksekusi memengaruhi cara Anda menulis pattern. Portabilitas membutuhkan desain yang cermat, dan kendala sumber daya memaksa kita untuk menerapkan teknik optimisasi yang paling efisien.

Selanjutnya, kita akan melihat ke cakrawala yang lebih jauh, mengeksplorasi bagaimana pattern matching berintegrasi dengan bidang-bidang mutakhir seperti machine learning dan teknologi-teknologi yang sedang berkembang.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-12/README.md
[selanjutnya]: ../bagian-14/README.md

<!----------------------------------------------------->

[0]: ../README.md#bagian-xiii-cross-platform-considerations
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
