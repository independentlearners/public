### Daftar Isi (Bagian VIII)

- [**BAGIAN VIII: PERFORMANCE DAN OPTIMIZATION**](#bagian-viii-performance-dan-optimization)
  - [8.1 Pattern Performance Analysis](#81-pattern-performance-analysis)
  - [8.2 Alternative Pattern Libraries](#82-alternative-pattern-libraries)
  - [8.3 Pattern Caching dan Memoization](#83-pattern-caching-dan-memoization)
  - [8.4 JIT Compilation Benefits](#84-jit-compilation-benefits)

---

## **[BAGIAN VIII: PERFORMANCE DAN OPTIMIZATION][0]**

### 8.1 Pattern Performance Analysis

Anda tidak bisa mengoptimalkan apa yang tidak Anda ukur. Langkah pertama adalah menganalisis di mana letak bottleneck (hambatan) kinerja.

- **Benchmarking Pattern Matching**: Ini adalah proses mengukur waktu eksekusi kode Anda untuk membandingkan pendekatan yang berbeda. Cara termudah di Lua adalah menggunakan `os.clock()`.

  ```lua
  local text_besar = string.rep("data:123, ", 100000)
  local pola = "(%d+)"

  local start_time = os.clock()

  -- Operasi yang akan diukur
  for _ in string.gmatch(text_besar, pola) do
    -- Lakukan sesuatu yang ringan
  end

  local end_time = os.clock()
  print(string.format("Waktu eksekusi: %.4f detik", end_time - start_time))
  ```

- **Profiling Tools dan Techniques**: Untuk analisis yang lebih dalam, Anda memerlukan _profiler_. Profiler akan memberitahu Anda fungsi mana yang paling banyak memakan waktu CPU. Lua standar tidak memiliki profiler bawaan, tetapi **LuaJIT** memiliki profiler yang sangat kuat yang terintegrasi di dalamnya.

- **Memory Usage dan CPU Usage Analysis**: Analisis kinerja bukan hanya tentang kecepatan CPU.

  - **Penggunaan CPU**: Pola yang kompleks dengan banyak _backtracking_ (misalnya, `(.*.*)`) bisa sangat membebani CPU.
  - **Penggunaan Memori**: Setiap _capture_ yang Anda buat dengan `()` membuat salinan substring baru. Pada teks yang sangat besar dengan ribuan kecocokan, ini dapat menghasilkan banyak "sampah" (garbage) yang harus dibersihkan oleh Garbage Collector (GC), yang juga memakan waktu. Terkadang, lebih baik menggunakan `string.find` untuk mendapatkan indeks dan `string.sub` secara manual jika Anda hanya perlu memproses data di tempat.

---

### 8.2 Alternative Pattern Libraries

Ketika pattern bawaan Lua tidak cukup cepat atau tidak cukup kuat, saatnya beralih ke library eksternal.

- **LPeg Deep Dive**: Seperti yang dibahas sebelumnya, keuntungan kinerja utama LPeg adalah ia **mengkompilasi** pola Anda menjadi bytecode internal. Ini berarti pola yang sama yang digunakan berulang kali tidak perlu di-parse ulang setiap saat, tidak seperti fungsi `string` standar Lua. Ini membuatnya ideal untuk parsing yang kompleks dan berulang.
- **Rex (PCRE untuk Lua)**: Ada beberapa library (seperti `lrexlib`) yang menyediakan _bindings_ ke engine **PCRE** (Perl Compatible Regular Expressions) yang sangat populer.
  - **Kelebihan**: Anda mendapatkan kekuatan penuh dari Regex tradisional, termasuk fitur-fitur yang tidak ada di Lua seperti alternasi `|`, quantifier `{}`, dan _lookarounds_ yang kompleks. Sintaksnya mungkin juga lebih familiar bagi mereka yang datang dari bahasa lain.
  - **Kekurangan**: Menambahkan dependensi eksternal yang besar (library PCRE itu sendiri) dan seringkali lebih lambat untuk tugas-tugas sederhana dibandingkan pattern bawaan Lua karena overhead dari mesin yang lebih kompleks.
- **Performance Comparisons (Perbandingan Kinerja)**: Aturan praktisnya adalah:
  1.  **Untuk pencocokan sederhana dan tidak berulang**: Pattern bawaan Lua seringkali yang tercepat.
  2.  **Untuk parsing kompleks, rekursif, atau pola yang digunakan berulang kali**: LPeg hampir selalu menjadi pemenangnya.
  3.  **Ketika Anda mutlak membutuhkan fitur Regex lengkap**: Gunakan library binding PCRE.

---

### 8.3 Pattern Caching dan Memoization

Ini adalah teknik untuk menghindari pekerjaan berulang.

- **Compiled Pattern Caching**: Ini adalah strategi utama untuk LPeg. Definisikan pola Anda sekali, simpan dalam variabel lokal, dan gunakan kembali.

  ```lua
  local lpeg = require("lpeg")
  -- Pola dikompilasi SEKALI di sini
  local number_patt = lpeg.R("09")^1

  -- Digunakan berkali-kali tanpa kompilasi ulang
  for i = 1, 1000 do
    number_patt:match(tostring(i))
  end
  ```

- **Memoization**: Ini adalah bentuk caching di mana Anda menyimpan _hasil_ dari pemanggilan fungsi. Jika fungsi dipanggil lagi dengan argumen yang sama persis, ia akan langsung mengembalikan hasil yang tersimpan tanpa menjalankan logika lagi.

  **Contoh: Memoization untuk Fungsi Parsing**

  ```lua
  local parse_cache = {}

  function memoized_parse(input_string)
    -- Periksa apakah hasil sudah ada di cache
    if parse_cache[input_string] then
      return parse_cache[input_string]
    end

    -- Jika tidak, lakukan pekerjaan yang mahal
    local result = --[[ lakukan parsing yang kompleks pada input_string ]]

    -- Simpan hasilnya di cache sebelum mengembalikannya
    parse_cache[input_string] = result
    return result
  end
  ```

  Ini sangat berguna jika Anda tahu program Anda akan sering mencoba mem-parse string yang sama berulang kali.

---

### 8.4 JIT Compilation Benefits

**LuaJIT** adalah implementasi Lua berkinerja sangat tinggi dengan compiler Just-In-Time (JIT). Menggunakan LuaJIT dapat secara drastis mempercepat kode Anda tanpa perubahan apa pun.

- **LuaJIT Pattern Optimizations**: Compiler JIT di LuaJIT sangat cerdas. Ia dapat "melihat" loop yang sering menjalankan fungsi `string.match` atau `gsub`. Ia akan men-JIT-kompilasi seluruh loop tersebut, termasuk panggilan ke fungsi C dari library string, menjadi kode mesin yang sangat efisien.
- **FFI Integration untuk Performance**: Fitur andalan LuaJIT adalah **Foreign Function Interface (FFI)**. Ini memungkinkan Anda untuk memanggil fungsi dari library C secara langsung dari kode Lua Anda, tanpa perlu menulis kode C atau _binding_ yang rumit. Untuk kinerja absolut, Anda bisa menggunakan FFI untuk memanggil library parsing C berkecepatan tinggi secara langsung dengan overhead yang minimal.
- **Profile-Guided Optimization**: LuaJIT secara otomatis memprofil kode Anda saat berjalan. Ia mengidentifikasi "hot code" (bagian kode yang paling sering dieksekusi) dan memfokuskan upaya optimisasinya di sana. Ini berarti loop pemrosesan teks Anda kemungkinan besar akan mendapatkan manfaat paling banyak dari JIT.

---

Dengan pemahaman tentang analisis kinerja dan optimisasi ini, Anda sekarang dapat membuat pilihan yang cerdas tentang alat dan teknik mana yang akan digunakan untuk pekerjaan tersebut. Anda tahu cara mengukur, cara memilih library yang tepat, dan cara memanfaatkan teknik canggih seperti caching dan JIT.

#

Selanjutnya, kita akan menerapkan semua yang telah kita pelajari sejauh ini ke berbagai domain aplikasi dunia nyata.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-7/README.md
[selanjutnya]: ../bagian-9/README.md

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
