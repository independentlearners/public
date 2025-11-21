Sekarang kita akan naik ke level yang lebih tinggi, di mana kita tidak hanya menggunakan fungsi yang ada, tetapi juga mulai mengimplementasikan konsep-konsep matematika yang kompleks dari awal. Kita juga akan membahas aspek-aspek krusial yang membedakan seorang programmer amatir dari seorang profesional: performa, optimisasi, dan cara men-debug kode numerik secara efektif.

> _Catatan: Kurikulum asli menempatkan Level 8.5 sebelum Level 8. Untuk alur pembelajaran yang lebih logis, saya akan membahas Level 7, diikuti oleh Level 8 (Performa & Optimisasi), dan kemudian Level 8.5 (Debugging & Profiling), karena biasanya kita mengoptimalkan dan men-debug kode setelah kita membangunnya._

---

### LEVEL 7: ADVANCED MATHEMATICAL CONCEPTS

Di level ini, kita akan membangun struktur data dan algoritma matematika kita sendiri, sering kali dengan memanfaatkan metamethods yang telah kita pelajari di Level 6.5.

#### **7.1 Complex Numbers**

- **Topik**: Mengimplementasikan aritmetika bilangan kompleks.

- **Konsep**: Bilangan kompleks adalah angka yang memiliki bagian real dan bagian imajiner, biasanya ditulis sebagai `a + bi`, di mana `i` adalah satuan imajiner (`sqrt(-1)`). Mereka sangat penting dalam bidang teknik elektro, pemrosesan sinyal, dan fraktal. Kita dapat merepresentasikannya di Lua menggunakan tabel dan metamethods.

- **Materi dan Penjelasan**:

  ```lua
  -- Implementasi sederhana Bilangan Kompleks
  local Complex = {}
  Complex.__index = Complex

  function Complex.new(real, imag)
    return setmetatable({ r = real, i = imag }, Complex)
  end

  -- Metamethod untuk representasi string
  function Complex.__tostring(c)
    if c.i >= 0 then
      return string.format("%g+%gi", c.r, c.i)
    else
      return string.format("%g%gi", c.r, c.i)
    end
  end

  -- Metamethod untuk penjumlahan: (a+bi) + (c+di) = (a+c) + (b+d)i
  function Complex.__add(c1, c2)
    return Complex.new(c1.r + c2.r, c1.i + c2.i)
  end

  -- Metamethod untuk perkalian: (a+bi) * (c+di) = (ac-bd) + (ad+bc)i
  function Complex.__mul(c1, c2)
    local real = c1.r * c2.r - c1.i * c2.i
    local imag = c1.r * c2.i + c1.i * c2.r
    return Complex.new(real, imag)
  end

  -- Penggunaan:
  local c1 = Complex.new(3, 2)  -- 3+2i
  local c2 = Complex.new(1, 7)  -- 1+7i

  print("c1 =", c1) -- Output: c1 = 3+2i
  print("c2 =", c2) -- Output: c2 = 1+7i
  print("c1 + c2 =", c1 + c2) -- Output: c1 + c2 = 4+9i
  print("c1 * c2 =", c1 * c2) -- Output: c1 * c2 = -11+23i
  ```

  Library eksternal seperti yang bisa ditemukan di [LuaRocks](https://www.google.com/search?q=https://luarocks.org/search%3Fq%3Dcomplex) menyediakan implementasi yang lebih lengkap dan teruji.

#### **7.2 Matrix Operations**

- **Topik**: Aljabar linear dasar.

- **Konsep**: Matriks adalah susunan angka persegi panjang yang digunakan secara ekstensif dalam grafika komputer (untuk transformasi seperti rotasi, skala, translasi), statistik, dan penyelesaian sistem persamaan linear.

- **Materi dan Penjelasan**:

  - **Representasi Matriks**: Cara paling umum di Lua adalah menggunakan tabel di dalam tabel (table of tables).

    ```lua
    -- Matriks 2x3
    local my_matrix = {
      { 1, 2, 3 }, -- Baris 1
      { 4, 5, 6 }  -- Baris 2
    }

    -- Mengakses elemen di baris 2, kolom 1
    print(my_matrix[2][1]) -- Output: 4
    ```

  - **Operasi Dasar**: Seperti bilangan kompleks, operasi matriks (penjumlahan, perkalian) dapat diimplementasikan dengan fungsi atau metamethods. Perkalian matriks lebih rumit daripada penjumlahan.
  - **Determinan dan Inversi**: Ini adalah konsep aljabar linear yang lebih maju.
    - **Determinan**: Nilai skalar yang dapat dihitung dari matriks persegi. Berguna untuk mengetahui apakah matriks memiliki invers.
    - **Inversi**: "Kebalikan" dari sebuah matriks, mirip dengan `1/x` untuk sebuah angka. Sangat penting untuk "membatalkan" transformasi dalam grafis.
  - **Rekomendasi**: Untuk operasi matriks yang serius, sangat disarankan untuk menggunakan library yang sudah ada dari [LuaRocks (pencarian: matrix)](https://luarocks.org/search?q=matrix) karena implementasinya rumit dan rentan terhadap kesalahan.

#### **7.3 Statistical Functions**

- **Topik**: Statistik deskriptif.

- **Konsep**: Meringkas dan menganalisis kumpulan data untuk memahami karakteristik utamanya.

- **Materi dan Penjelasan**:

  - **Mean, Median, Mode**:
    - **Mean (Rata-rata)**: Jumlah total nilai dibagi dengan jumlah nilai.
    - **Median**: Nilai tengah dari kumpulan data yang telah diurutkan.
    - **Mode**: Nilai yang paling sering muncul.
  - **Standard Deviation dan Variance**:
    - **Variance (Variansi)**: Ukuran seberapa tersebar data dari rata-rata.
    - **Standard Deviation (Simpangan Baku)**: Akar kuadrat dari varians, memberikan ukuran sebaran dalam satuan yang sama dengan data asli.
  - **Contoh Implementasi Sederhana**:

    ```lua
    local dataset = { 2, 4, 4, 4, 5, 5, 7, 9 }

    function calculate_mean(tbl)
      local sum = 0
      for _, v in ipairs(tbl) do sum = sum + v end
      return sum / #tbl
    end

    function calculate_stddev(tbl)
      local mean = calculate_mean(tbl)
      local sum_sq_diff = 0
      for _, v in ipairs(tbl) do
        sum_sq_diff = sum_sq_diff + (v - mean)^2
      end
      local variance = sum_sq_diff / #tbl
      return math.sqrt(variance)
    end

    print("Mean:", calculate_mean(dataset)) -- Output: Mean: 5.0
    print("Standard Deviation:", calculate_stddev(dataset)) -- Output: Standard Deviation: 2.0
    ```

  - Untuk analisis statistik yang lebih kompleks, gunakan library khusus dari [LuaRocks (pencarian: statistics)](https://luarocks.org/search?q=statistics).

---

### LEVEL 8: PERFORMANCE & OPTIMIZATION

Menulis kode yang benar adalah satu hal; menulis kode yang cepat adalah hal lain. Ini sangat penting dalam game dan komputasi volume tinggi.

#### **8.1 Numerical Performance**

- **Topik**: Mengoptimalkan komputasi matematis.
- **Materi dan Penjelasan**:

  - **Integer vs Float Performance**: Di Lua 5.3+, operasi pada `integer` umumnya lebih cepat daripada pada `float`. Gunakan integer jika Anda tidak memerlukan presisi desimal.
  - **Optimisasi Loop**: Hindari mengakses variabel global berulang kali di dalam loop yang ketat (tight loop). Simpan fungsi atau nilai dalam variabel lokal.

    ```lua
    -- Lambat
    -- for i = 1, 1000000 do y = math.sin(i) end

    -- Cepat
    local sin = math.sin -- Simpan fungsi dalam variabel lokal
    for i = 1, 1000000 do
      local y = sin(i)
    end
    ```

  - **LuaJIT-Specific Optimizations**: [LuaJIT](https://luajit.org/) adalah implementasi Lua berkinerja sangat tinggi. Ia menggunakan **Just-In-Time (JIT) compiler** untuk mengubah skrip Lua Anda menjadi kode mesin asli saat runtime. Untuk komputasi numerik yang berat, LuaJIT bisa puluhan hingga ratusan kali lebih cepat dari Lua standar. Memahami cara menulis kode yang "JIT-friendly" adalah sebuah disiplin tersendiri.

#### **8.2 Numerical Precision dan Stability**

- **Topik**: Masalah presisi floating point.
- **Materi dan Penjelasan**:

  - **IEEE 754 Standard Basics**: Standar yang mendefinisikan bagaimana angka floating-point direpresentasikan dalam biner. Inilah alasan mengapa `0.1 + 0.2` tidak sama persis dengan `0.3`.
  - **Epsilon Comparisons**: Jangan pernah membandingkan dua angka float untuk kesetaraan persis dengan `==`. Sebagai gantinya, periksa apakah perbedaan absolut di antara keduanya lebih kecil dari nilai "epsilon" (ambang batas) yang sangat kecil.

    ```lua
    function float_equals(a, b, epsilon)
      epsilon = epsilon or 1e-10
      return math.abs(a - b) < epsilon
    end

    local a = 0.1 + 0.2
    local b = 0.3

    print(a == b)                 -- Output: false
    print(float_equals(a, b))     -- Output: true
    ```

  - **Catastrophic Cancellation**: Mengurangi dua angka yang nilainya berdekatan dapat menyebabkan hilangnya presisi secara signifikan. Waspadai ini dalam algoritma Anda.

#### **8.3 Big Number Libraries**

- **Topik**: Aritmetika presisi sewenang-wenang (Arbitrary precision arithmetic).
- **Materi dan Penjelasan**:
  - **Kapan Menggunakannya**: Ketika angka `integer` 64-bit atau `float` double-precision tidak cukup besar atau tidak cukup presisi. Ini umum dalam kriptografi (kunci yang sangat besar) atau perhitungan ilmiah/finansial presisi tinggi.
  - **Library yang Tersedia**: Library seperti `lua-gmp` menyediakan kemampuan untuk bekerja dengan angka yang ukurannya hanya dibatasi oleh memori komputer Anda.
  - **Trade-off Performa**: Operasi pada "bignum" jauh lebih lambat daripada operasi numerik asli karena semuanya dilakukan dalam perangkat lunak. Gunakan hanya jika benar-benar diperlukan. Cari di [LuaRocks (pencarian: bignum)](https://luarocks.org/search?q=bignum) untuk opsi yang tersedia.

---

### LEVEL 8.5: DEBUGGING & PROFILING MATHEMATICAL CODE

Kode numerik terkenal sulit untuk di-debug. Kesalahan sering kali tidak menyebabkan crash, tetapi hasil yang salah secara diam-diam.

#### **8.5.1 Mathematical Debugging Techniques**

- **Topik**: Men-debug komputasi numerik.
- **Materi dan Penjelasan**:
  - **Pengujian Berbasis Assertion**: Gunakan `assert()` untuk memeriksa kondisi atau _invariant_ matematika yang harus selalu benar.
    ```lua
    function safe_sqrt(x)
      assert(x >= 0, "Tidak bisa mengakarkuadratkan angka negatif!")
      return math.sqrt(x)
    end
    ```
  - **Logging Intermediate Calculations**: Cetak nilai-nilai antara dalam perhitungan yang kompleks untuk melihat di mana penyimpangan terjadi.
  - **Unit Testing**: Gunakan framework pengujian seperti [Busted](https://busted.org/) untuk membuat serangkaian tes otomatis untuk fungsi matematika Anda, termasuk kasus-kasus ekstrem (`0`, `NaN`, `inf`).

#### **8.5.2 Performance Profiling**

- **Topik**: Mengukur performa matematika.
- **Materi dan Penjelasan**:
  - **Timing Operations**: Gunakan `os.clock()` untuk mengukur waktu yang dibutuhkan suatu fungsi untuk dieksekusi.
  - **Identifikasi Bottleneck**: Profiling membantu Anda menemukan bagian kode yang paling lambat ("bottleneck") sehingga Anda dapat memfokuskan upaya optimisasi Anda di sana.
  - **Alat Profiling**: LuaJIT memiliki profiler bawaan yang sangat kuat yang dapat memberi Anda laporan terperinci tentang di mana waktu dihabiskan dalam kode Anda.

#### **8.5.3 Numerical Validation**

- **Topik**: Memastikan kebenaran perhitungan.
- **Materi dan Penjelasan**:
  - **Reference Implementation Testing**: Uji fungsi Anda terhadap implementasi yang sudah terbukti benar dari bahasa atau library lain (misalnya, SciPy di Python).
  - **Property-Based Testing**: Alih-alih menguji input dan output tertentu, Anda menguji _properti_ yang harus dimiliki fungsi Anda. Misalnya, untuk fungsi `sort`, propertinya adalah "output harus selalu terurut" dan "output harus mengandung elemen yang sama dengan input".
  - **Regression Testing**: Setiap kali Anda memperbaiki bug, tambahkan tes yang mereplikasi bug tersebut untuk memastikan itu tidak akan pernah muncul lagi.

---

Kita telah membahas cara membangun, mengoptimalkan, dan memvalidasi kode numerik tingkat lanjut. Sekarang kita telah sampai di bagian akhir dari perjalanan ini. Setelah membangun fondasi, menguasai fungsi, dan belajar tentang optimisasi, sekarang saatnya melihat bagaimana semua ini digunakan dalam aplikasi dunia nyata dan bagaimana cara memperluas kemampuan matematika Lua lebih jauh lagi dengan alat dan pustaka eksternal.

---

### LEVEL 9: PRACTICAL APPLICATIONS

Teori tidak ada artinya tanpa praktik. Di level ini, kita akan melihat bagaimana konsep matematika yang telah kita pelajari diterapkan di berbagai domain.

#### **9.1 Financial Calculations**

- **Topik**: Uang dan matematika keuangan.
- **Aturan Emas**: **Jangan pernah menggunakan float standar untuk merepresentasikan uang\!** Kesalahan pembulatan kecil pada floating-point (`0.1 + 0.2` tidak sama dengan `0.3`) dapat menyebabkan perbedaan sen yang signifikan dalam perhitungan keuangan, yang tidak dapat diterima.
- **Solusi**: Representasikan uang sebagai **integer** dalam unit terkecilnya (misalnya, sen, bukan dolar).

  ```lua
  -- Jangan lakukan ini:
  -- local price_float = 10.50 -- $10.50
  -- local tax_float = 0.87   -- $0.87
  -- local total_float = price_float + tax_float -- Mungkin menjadi 11.370000000000001

  -- Lakukan ini:
  local price_in_cents = 1050
  local tax_in_cents = 87
  local total_in_cents = price_in_cents + tax_in_cents -- Dijamin 1137

  -- Saat menampilkan ke pengguna, baru konversi kembali
  print(string.format("Total: $%.2f", total_in_cents / 100)) -- Output: Total: $11.37
  ```

- **Materi dan Penjelasan**:
  - **Perhitungan Bunga (Interest Calculations)**: Menghitung bunga sederhana atau bunga majemuk.
  - **Amortisasi Pinjaman (Loan Amortization)**: Menghitung jadwal pembayaran pinjaman dari waktu ke waktu.
  - Untuk perhitungan yang sangat kompleks atau memerlukan presisi tinggi di luar jangkauan integer, gunakan pustaka desimal khusus dari [LuaRocks (pencarian: decimal)](https://luarocks.org/search?q=decimal).

#### **9.2 Game Mathematics**

- **Topik**: Matematika untuk pengembangan game.
- **Materi dan Penjelasan**:

  - **Operasi Vektor 2D/3D**: Tulang punggung dari hampir semua hal dalam game. Vektor (yang kita implementasikan di Level 6.5) digunakan untuk merepresentasikan posisi, kecepatan, dan arah. Operasi seperti penjumlahan vektor digunakan untuk pergerakan.
  - **Deteksi Tabrakan (Collision Detection)**: Menggunakan matematika (misalnya, uji jarak antar lingkaran, perpotongan kotak pembatas) untuk menentukan apakah dua objek game saling bersentuhan.
  - **Interpolasi (Interpolation - lerp, slerp)**: Digunakan untuk menciptakan gerakan yang mulus. **Lerp** (Linear Interpolation) adalah yang paling umum.

    ```lua
    -- Fungsi lerp sederhana untuk nilai
    function lerp(start, finish, amount)
      return start + (finish - start) * amount
    end

    -- Menggerakkan objek dari posisi x=0 ke x=100 secara mulus
    local current_pos = 0
    local target_pos = 100

    -- Dalam game loop, Anda akan melakukan ini setiap frame:
    -- current_pos = lerp(current_pos, target_pos, 0.1) -- Bergerak 10% mendekati target setiap frame
    -- print(current_pos)
    ```

  - **Fungsi Kebisingan (Noise Functions)**: Seperti Perlin Noise, digunakan untuk menghasilkan medan (terrain), tekstur, dan pola yang tampak alami secara prosedural.
  - Pustaka dan framework game seperti [LÖVE 2D](https://love2d.org/wiki/Category:Modules) sudah menyediakan banyak fungsi matematika ini.

#### **9.3 Scientific Computing**

- **Topik**: Metode numerik.
- **Konsep**: Menggunakan komputer untuk menemukan solusi perkiraan untuk masalah matematika yang terlalu sulit untuk diselesaikan secara analitis (dengan rumus).
- **Materi dan Penjelasan**:
  - **Integrasi Numerik**: Memperkirakan area di bawah kurva.
  - **Algoritma Pencarian Akar (Root Finding)**: Menemukan di mana sebuah fungsi bernilai nol (`f(x) = 0`).
  - **Penyelesaian Persamaan Diferensial**: Memodelkan sistem yang berubah seiring waktu, seperti simulasi fisika.
  - Ini adalah bidang yang sangat terspesialisasi. Untuk tugas-tugas ini, Anda hampir selalu akan menggunakan pustaka khusus dari [LuaRocks (pencarian: science, numerical)](https://luarocks.org/search?q=science).

---

### LEVEL 10: EXTERNAL LIBRARIES & TOOLS

Lua sendiri kuat, tetapi kekuatannya yang sebenarnya terletak pada kemampuannya untuk berintegrasi dengan kode lain.

#### **10.1 Popular Math Libraries**

- **Topik**: Memperluas kemampuan matematika Lua.
- **Materi dan Penjelasan**:
  - **LuaJIT FFI dengan Pustaka Matematika**: [FFI (Foreign Function Interface)](http://luajit.org/ext_ffi_tutorial.html) pada LuaJIT adalah fitur revolusioner. Ini memungkinkan Anda untuk memanggil fungsi dari pustaka C (seperti `glibc` `libm` yang berisi fungsi matematika) **langsung dari kode Lua** tanpa menulis sebaris pun kode C. Ini sangat cepat dan kuat.
  - **Integrasi Torch/OpenResty**: Proyek seperti [Torch](http://torch.ch/) (untuk machine learning) dan [OpenResty](https://openresty.org/) (untuk web) sangat bergantung pada komputasi numerik berperforma tinggi di Lua (biasanya LuaJIT).

#### **10.2 Interfacing dengan C Math Libraries**

- **Topik**: Menggunakan pustaka C dari Lua.
- **Materi dan Penjelasan**: Ada dua cara utama:
  1.  **Membuat Ekstensi C (Lua C Extensions)**: Ini adalah cara tradisional. Anda menulis kode "lem" dalam bahasa C yang menggunakan [Lua C API](https://www.lua.org/manual/5.4/manual.html#4) untuk membuat fungsi C Anda tersedia bagi skrip Lua. Ini menawarkan kontrol penuh tetapi membutuhkan pengetahuan C dan proses kompilasi.
  2.  **Menggunakan FFI (LuaJIT)**: Seperti yang dijelaskan di atas, FFI sering kali lebih mudah untuk sekadar memanggil fungsi yang ada dari pustaka `.dll` atau `.so`.

#### **10.3 Testing Mathematical Code**

- **Topik**: Pengujian unit untuk kode numerik.
- **Materi dan Penjelasan**: Ini adalah pengulangan dari Level 8.5, menekankan pentingnya validasi.
  - **Teknik Assertion untuk Floating Point**: Gunakan perbandingan epsilon, bukan `==`.
  - **Property-Based Testing**: Uji properti matematika alih-alih nilai spesifik.
  - **Benchmarking**: Pastikan fungsi kustom Anda tidak hanya benar tetapi juga berkinerja baik.
  - Gunakan [framework pengujian](https://luarocks.org/search?q=test) seperti Busted atau Telescope.

---

### Referensi Tambahan & Langkah Selanjutnya

Kurikulum ini, yang diuraikan dari file Anda, telah memberi Anda peta jalan yang komprehensif. Berikut adalah sumber daya dari file asli Anda yang sangat berharga untuk melanjutkan pembelajaran Anda:

- **Dokumentasi Resmi**:
  - [Lua 5.4 Reference Manual](https://www.lua.org/manual/5.4/)
  - [Programming in Lua (4th edition)](https://www.lua.org/pil/)
- **Sumber Daya Komunitas**:
  - [Lua Users Wiki](http://lua-users.org/wiki/)
  - [Stack Overflow Lua Tag](https://stackoverflow.com/questions/tagged/lua)
- **Pustaka dan Alat**:
  - [LuaRocks Package Manager](https://luarocks.org/)
  - [LuaJIT Documentation](https://luajit.org/)
  - [LÖVE 2D Game Framework](https://love2d.org/)

Dengan menyelesaikan uraian kurikulum ini, Anda sekarang memiliki pemahaman yang jauh lebih dalam tentang "mengapa" dan "bagaimana" di balik setiap topik. Anda tidak hanya tahu fungsi apa yang harus dipanggil, tetapi juga menyadari nuansa versi, jebakan presisi, pertimbangan performa, dan kekuatan ekspresif dari metamethods.

#

Anda sekarang diperlengkapi dengan baik untuk tidak hanya menggunakan Lua untuk matematika, tetapi juga untuk membangun, mengoptimalkan, dan memvalidasi solusi numerik Anda sendiri untuk masalah apa pun yang Anda hadapi. **Selamat\!**

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-6/README.md
[selanjutnya]: ../bagian-8/README.md

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
