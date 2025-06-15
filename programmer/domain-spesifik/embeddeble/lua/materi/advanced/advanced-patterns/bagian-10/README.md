Kita telah menjelajahi aplikasi dunia nyata dari pattern matching, yang menunjukkan _apa_ yang bisa kita bangun. Sekarang, kita akan menyelam lebih dalam ke tingkat implementasi yang paling fundamental untuk membuka tingkat kinerja dan kemampuan tertinggi: integrasi dengan C API. Bagian ini adalah jembatan antara dunia skrip Lua yang fleksibel dan dunia C yang berkinerja tinggi.

---

### Daftar Isi (Bagian X)

- [**BAGIAN X: C API INTEGRATION**](#bagian-x-c-api-integration)
  - [10.1 C API Pattern Integration](#101-c-api-pattern-integration)
  - [10.2 Custom Pattern Implementations](#102-custom-pattern-implementations)
  - [10.3 Native Library Bindings](#103-native-library-bindings)

---

## **[BAGIAN X: C API INTEGRATION][0]**

C API adalah antarmuka yang memungkinkan kode C untuk berinteraksi dengan state Lua. Anda dapat memanipulasi data Lua, memanggil fungsi Lua, dan mengekspos fungsi C ke Lua. Ini adalah kunci untuk memperluas kemampuan Lua dan mengoptimalkan bottleneck kinerja.

### 10.1 C API Pattern Integration

Ini adalah skenario di mana program C yang lebih besar menyematkan (embed) Lua sebagai mesin skrip, dan program C tersebut ingin memanfaatkan fungsi pattern matching Lua yang cepat dan sederhana.

- **Konsep**: Kode C Anda memanggil fungsi `string.match` atau `string.gsub` yang ada di dalam state Lua.
- **Alur Kerja**:
  1.  **Dapatkan Fungsi**: Dari C, dapatkan fungsi `string.match` dari global state Lua dan letakkan di atas tumpukan (stack) Lua.
  2.  **Siapkan Argumen**: Dorong (push) string subjek dan string pattern ke atas tumpukan.
  3.  **Panggil Fungsi**: Gunakan `lua_pcall` untuk memanggil fungsi tersebut dengan argumen yang telah disiapkan.
  4.  **Ambil Hasil**: Ambil hasil (misalnya, string yang ditangkap atau `nil`) dari tumpukan kembali ke dalam variabel C Anda.
- **Kasus Penggunaan**: Sebuah aplikasi C++ (misalnya, editor teks atau game engine) yang memungkinkan pengguna untuk memasukkan pattern sederhana untuk pencarian. Daripada menyertakan library regex C yang terpisah, aplikasi dapat menggunakan mesin Lua yang sudah disematkan untuk melakukan pencarian tersebut.

---

### 10.2 Custom Pattern Implementations

Ini adalah kebalikannya: Anda menulis fungsi pattern matching Anda sendiri di C untuk kinerja maksimal atau fungsionalitas khusus, lalu mengeksposnya agar bisa dipanggil dari skrip Lua.

- **Konsep**: Membuat fungsi C yang dapat dipanggil dari Lua dan terdaftar sebagai bagian dari sebuah modul.
- **Alasan**:
  - **Kinerja Kritis**: Untuk pola pencocokan yang sangat spesifik yang menjadi bottleneck utama dalam aplikasi Anda, fungsi C yang ditulis tangan hampir pasti akan lebih cepat daripada implementasi berbasis Lua atau LPeg.
  - **Memperluas Kemampuan**: Anda bisa mengimplementasikan algoritma pencocokan yang tidak ada di Lua, misalnya, pencocokan fuzzy (seperti algoritma Levenshtein) atau pencocokan berdasarkan model statistik, lalu menghadirkannya sebagai fungsi sederhana di Lua.
- **Alur Kerja**:
  1.  **Tulis Fungsi C**: Buat sebuah fungsi C dengan signature `int nama_fungsi(lua_State *L)`.
  2.  **Ambil Argumen**: Di dalam fungsi C, gunakan fungsi `lua_tostring`, `lua_tonumber`, dll., untuk mengambil argumen dari tumpukan Lua.
  3.  **Lakukan Logika**: Jalankan algoritma pencocokan kustom Anda pada data yang diambil.
  4.  **Kirim Hasil**: Gunakan `lua_pushstring`, `lua_pushboolean`, dll., untuk mendorong hasil kembali ke tumpukan.
  5.  **Daftarkan Fungsi**: Buat sebuah tabel (modul) di C dan daftarkan fungsi Anda ke dalamnya, lalu daftarkan modul tersebut ke dalam state Lua.

---

### 10.3 Native Library Bindings

Ini adalah pendekatan yang paling umum dan praktis: membuat "jembatan" antara Lua dan library C/C++ pihak ketiga yang sudah ada dan teruji.

- **Konsep**: Anda tidak menulis ulang logikanya, tetapi Anda menulis "lem" (glue code) menggunakan C API untuk membuat fungsi-fungsi dari library C asli dapat dipanggil dari Lua.
- **Contoh**:
  - **Integrasi PCRE**: Library seperti `lrexlib` adalah modul C yang memuat library PCRE. Ia mengekspos fungsi seperti `rex.match`. Saat Anda memanggil `rex.match(str, patt)` dari Lua, kode C di `lrexlib` mengambil `str` dan `patt` dari tumpukan, meneruskannya ke fungsi `pcre_exec()` dari library PCRE, mengambil hasilnya, dan mendorong hasil tersebut kembali ke tumpukan Lua.
  - **Integrasi ICU untuk Unicode**: International Components for Unicode (ICU) adalah library C/C++ yang sangat komprehensif untuk pemrosesan teks tingkat lanjut. Sebuah _binding_ Lua ke ICU akan memberikan kemampuan yang jauh melampaui library `utf8` standar Lua, seperti:
    - Pencocokan pola yang sadar akan aturan Unicode yang kompleks.
    - _Collation_ (pengurutan teks) yang benar untuk berbagai bahasa.
    - Analisis batas teks (menemukan kata, kalimat, atau pemisah baris sesuai dengan aturan linguistik yang berbeda).
  - **Binding XML**: Library seperti LuaExpat adalah binding untuk parser XML Expat yang populer dan berkinerja tinggi. Ia memungkinkan parsing XML yang jauh lebih cepat dan lebih andal daripada yang bisa dilakukan dengan pattern murni.

---

Bagian ini telah membuka pintu ke tingkat optimisasi dan ekstensibilitas tertinggi. Dengan C API, Anda tidak lagi terbatas pada apa yang bisa dilakukan oleh Lua sendiri; Anda dapat mengintegrasikan kekuatan seluruh ekosistem library C ke dalam skrip Anda.

#

Selanjutnya, kita akan beralih ke aspek yang sama pentingnya: bagaimana memastikan semua pola yang kita tulis, baik sederhana maupun kompleks, benar, andal, dan aman melalui pengujian dan debugging.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-9/README.md
[selanjutnya]: ../bagian-11/README.md

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
