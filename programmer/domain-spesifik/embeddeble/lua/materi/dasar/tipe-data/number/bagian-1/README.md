### **[Panduan Belajar Lengkap: Numbers & Math di Lua](#satuuu)**

Selamat datang di panduan komprehensif untuk menguasai representasi angka, operasi matematika, dan konsep komputasi numerik di bahasa pemrograman Lua. Kurikulum ini dirancang untuk membawa Anda dari nol hingga menjadi seorang ahli yang tidak hanya bisa menggunakan Lua untuk tugas-tugas matematis, tetapi juga memahami seluk-beluk performa, presisi, dan arsitektur di baliknya.

#### **Daftar Isi**

- [Persiapan Awal: Fondasi Sebelum Memulai](#persiapan-awal-fondasi-sebelum-memulai)
- [LEVEL 1.5: VERSION COMPATIBILITY & DIFFERENCES](#level-15-version-compatibility--differences)
- [LEVEL 1: FUNDAMENTAL NUMBERS](#level-1-fundamental-numbers)
- [LEVEL 2: MATH LIBRARY BASICS][1]
- [LEVEL 2.5: COMPREHENSIVE MATH LIBRARY FUNCTIONS][2]
- [LEVEL 3: ADVANCED ARITHMETIC][3]
- [LEVEL 3.5: ERROR HANDLING & EDGE CASES][4]
- [LEVEL 4: RANDOM NUMBERS & PROBABILITY][5]
- [LEVEL 5: NUMBER MANIPULATION & FORMATTING][6]
- [LEVEL 6: BIT OPERATIONS][7]
- [LEVEL 6.5: MATHEMATICAL METAMETHODS][8]
- [LEVEL 7: ADVANCED MATHEMATICAL CONCEPTS][9]
- [LEVEL 8: PERFORMANCE & OPTIMIZATION][10]
- [LEVEL 8.5: DEBUGGING & PROFILING MATHEMATICAL CODE][11]
- [LEVEL 9: PRACTICAL APPLICATIONS][12]
- [LEVEL 10: EXTERNAL LIBRARIES & TOOLS][13]
- [Referensi Tambahan][14]

---

# Persiapan Awal: Fondasi Sebelum Memulai

Sebelum kita menyelami kurikulum, mari kita siapkan fondasi yang kuat. Karena Anda memiliki latar belakang OOP dari Dart, beberapa konsep akan terasa familiar, tetapi mari kita pastikan dasarnya kokoh.

**1. Apa itu Lua?**
Lua adalah bahasa pemrograman yang ringan, cepat, dan mudah disematkan (embeddable). "Ringan" berarti ia memiliki jejak memori yang sangat kecil. "Cepat" berarti ia dieksekusi dengan efisien. "Mudah disematkan" berarti Lua dirancang untuk bekerja di dalam program lain sebagai bahasa skrip. Inilah sebabnya Lua sangat populer di game engine (seperti Roblox dan LÖVE 2D), aplikasi (seperti Adobe Lightroom), dan perangkat jaringan.

**2. Bagaimana Menjalankan Kode Lua? (Lingkungan Eksperimen Anda)**
Cara termudah untuk belajar dan bereksperimen adalah dengan menggunakan **REPL** (**R**ead-**E**val-**P**rint **L**oop). Ini adalah program baris perintah interaktif di mana Anda dapat mengetik kode Lua, dan ia akan langsung menjalankannya dan mencetak hasilnya.

- **Instalasi:** Kunjungi [halaman unduh resmi Lua](https://www.lua.org/download.html) untuk mendapatkan instruksi instalasi untuk sistem operasi Anda. Alternatif yang populer, terutama untuk performa, adalah [LuaJIT](https://luajit.org/download.html).
- **Menjalankan REPL:** Setelah terinstal, buka terminal atau command prompt Anda dan ketik `lua` atau `luajit`. Anda akan melihat prompt seperti `>`.

<!-- end list -->

```bash
> print("Halo, Lua!")
Halo, Lua!
> x = 10 + 5
> print(x)
15
```

Sepanjang panduan ini, Anda didorong untuk mencoba setiap contoh kode di REPL Anda.

**3. Konsep Fundamental: Bagaimana Komputer Melihat Angka?**
Di dunia nyata, angka adalah konsep abstrak. Di komputer, angka harus direpresentasikan menggunakan `bit` (0 atau 1). Ada dua kategori utama:

- **Integer (Bilangan Bulat):** Angka tanpa komponen desimal (misalnya, `-10`, `0`, `42`). Komputer menyimpannya dalam representasi biner langsung.
- **Floating-Point (Bilangan Titik Mengambang):** Angka dengan komponen desimal (misalnya, `3.14`, `-0.001`, `2.5e3`). Komputer menyimpannya menggunakan formula ilmiah yang disebut **notasi saintifik**, yang terdiri dari tiga bagian: tanda (positif/negatif), mantissa (digit signifikan), dan eksponen. Standar yang paling umum untuk ini adalah **IEEE 754**.

Memahami perbedaan ini sangat penting karena akan memengaruhi presisi, rentang, dan performa, seperti yang akan kita lihat di kurikulum.

---

# LEVEL 1.5: VERSION COMPATIBILITY & DIFFERENCES

Lua telah berevolusi. Memahami perbedaan utama antar versi, terutama terkait angka, akan menyelamatkan Anda dari kebingungan saat bekerja dengan basis kode yang berbeda.

#### **1.5.1 Lua Version Math Differences**

- **Topik**: Perbedaan implementasi matematika antar versi Lua.

- **Materi dan Penjelasan**:

  - **Lua 5.1**: Di versi ini, semua angka adalah _double-precision floating-point_.
    - **Terminologi**: "Double-precision" adalah format IEEE 754 64-bit. Pikirkan ini sebagai wadah yang sangat besar dan presisi untuk menyimpan angka, baik bulat maupun desimal. Bahkan angka `10` disimpan seolah-olah `10.0`. Ini menyederhanakan bahasa tetapi memiliki implikasi performa untuk operasi bilangan bulat murni.
  - **Lua 5.2**: Sebagian besar tetap sama dengan 5.1. Perubahan utamanya adalah penambahan `math.ult` untuk perbandingan bilangan _unsigned_. Kita akan membahas ini di level selanjutnya. Versi ini juga menambahkan `bit32` library untuk operasi bitwise.
  - **Lua 5.3**: Ini adalah perubahan besar. Lua 5.3 memperkenalkan **subtype integer**.
    - **Konsep**: Lua sekarang dapat secara internal membedakan antara bilangan bulat (integer 64-bit) dan bilangan desimal (float). Ini dilakukan secara otomatis. Jika sebuah angka tidak memiliki bagian desimal dan berada dalam rentang integer, Lua akan menyimpannya sebagai integer, yang lebih cepat untuk operasi aritmetika tertentu.
    - **Contoh Kode (hanya berfungsi di Lua 5.3+):**
      ```lua
      -- Di Lua 5.3+, Anda bisa mengecek tipenya
      print(math.type(10))    -- Output: integer
      print(math.type(10.0))  -- Output: float
      print(math.type(10.2))  -- Output: float
      ```
    - Versi ini juga menambahkan **operator bitwise** asli (`&`, `|`, `~`, dll.) dan konstanta `math.maxinteger`/`math.mininteger`.
  - **Lua 5.4**: Melanjutkan model dari 5.3 tanpa perubahan signifikan pada sistem angka atau library `math`.
  - **Pertimbangan Kompatibilitas Mundur (Backward Compatibility)**: Jika Anda menulis kode yang harus berjalan di Lua 5.1 atau 5.2, Anda tidak dapat mengasumsikan adanya tipe integer atau operator bitwise asli. Anda harus selalu memperlakukan angka sebagai `float` dan menggunakan library `bit32` untuk operasi bitwise.

#### **1.5.2 Number Representation Changes**

- **Topik**: Evolusi sistem number di Lua.

- **Materi dan Penjelasan**:

  - **Lua 5.1/5.2: Pure floating point (double)**: Seperti yang dijelaskan di atas, hanya ada satu jenis angka.
  - **Lua 5.3+: Integer dan float subtypes**: Sistem ganda ini diperkenalkan untuk efisiensi.
  - **Automatic Coercion Rules (Aturan Konversi Otomatis)**: Di Lua 5.3+, Lua secara otomatis mengonversi antara integer dan float jika diperlukan.

    - **Konsep**: Jika Anda melakukan operasi antara integer dan float, hasilnya akan menjadi float. Ini memastikan tidak ada kehilangan presisi.
    - **Contoh Kode (Lua 5.3+):**

      ```lua
      local a = 10      -- Lua menyimpannya sebagai integer
      local b = 5.5     -- Lua menyimpannya sebagai float
      local c = a + b   -- Operasi integer + float

      print(math.type(a)) -- Output: integer
      print(math.type(b)) -- Output: float
      print(math.type(c)) -- Output: float (dikonversi otomatis)
      print(c)            -- Output: 15.5
      ```

  - **Implikasi Performa**: Operasi pada integer (penjumlahan, pengurangan) umumnya lebih cepat daripada operasi pada float. Dengan memisahkan kedua tipe ini, Lua 5.3+ dapat mengoptimalkan kode yang banyak menggunakan bilangan bulat.
  - **Strategi Migrasi**: Saat memigrasikan kode dari Lua 5.2 ke 5.3, perhatikan operasi pembagian. Operator `/` sekarang selalu menghasilkan float (pembagian float), sedangkan operator baru `//` digunakan untuk pembagian integer.

---

# LEVEL 1: FUNDAMENTAL NUMBERS

Ini adalah dasar-dasar yang harus Anda kuasai. Ini adalah blok bangunan dari semua hal lain yang akan kita pelajari.

#### **1.1 Pengenalan Number Types di Lua**

- **Topik**: Integer vs Float, Representasi Angka.

- **Materi dan Penjelasan**:

  - Seperti yang dibahas di [Level 1.5](#-5), sebelum Lua 5.3, hanya ada satu tipe `number` (float). Sejak Lua 5.3, `number` memiliki dua sub-tipe: `integer` dan `float`.
  - Konversi otomatis terjadi untuk menjaga presisi.
  - **Literal Heksadesimal, Oktal, dan Biner**: Lua memungkinkan Anda untuk menulis angka dalam basis yang berbeda, yang sangat berguna dalam pemrograman tingkat rendah atau saat bekerja dengan data biner.
    - **Heksadesimal (basis 16)**: Diawali dengan `0x`. Menggunakan digit `0-9` dan `a-f`.
      ```lua
      local hex_val = 0xFF   -- Sama dengan 255 dalam desimal
      print(hex_val)         -- Output: 255
      ```
    - **Biner (basis 2)**: (Lua 5.2+) Diawali dengan `0b`.
    - **Oktal (basis 8)**: (Lua 5.2+) Diawali dengan `0o`.
      _Catatan: Dukungan untuk biner dan oktal secara resmi ditambahkan kemudian, meskipun beberapa implementasi mungkin memilikinya lebih awal._

#### **1.2 Basic Arithmetic Operations**

- **Topik**: `+`, `-`, `*`, `/`, `//`, `%`, `^`, unary minus.

- **Materi dan Penjelasan**:

  - **Operator dan Contoh**:

    - `+` (Penjumlahan): `5 + 3` -\> `8`
    - `-` (Pengurangan): `5 - 3` -\> `2`
    - `*` (Perkalian): `5 * 3` -\> `15`
    - `/` (Pembagian Float): `10 / 4` -\> `2.5`. Selalu menghasilkan float.
    - `//` (Pembagian Integer) (Lua 5.3+): `10 // 4` -\> `2`. Membuang bagian desimal.
    - `%` (Modulo/Sisa Pembagian): `10 % 3` -\> `1`. Hasilnya mengikuti tanda pembagi.
    - `^` (Eksponensiasi/Pangkat): `2 ^ 3` -\> `8`.
    - `-` (Unary Minus/Negasi): `-5`.

  - **Operator Precedence (Urutan Prioritas Operator)**: Ini menentukan urutan operasi dievaluasi. Sangat penting untuk dipahami untuk menghindari bug logika.

    1.  `^` (Pangkat)
    2.  `not`, `#`, `-` (unary)
    3.  `*`, `/`, `//`, `%`
    4.  `+`, `-`
    5.  `..` (Penyambungan string)
    6.  `<<`, `>>` (Bitwise shifts)
    7.  `&` (Bitwise AND)
    8.  `~` (Bitwise XOR)
    9.  `|` (Bitwise OR)
    10. `<`, `>`, `<=`, `>=`, `~=`, `==` (Relasional)
    11. `and`
    12. `or`

    <!-- end list -->

    - **Visualisasi Precedence**:
      ```
      Tingkat Tertinggi:      ^
                             |
      Tingkat Menengah:     * / %
                             |
      Tingkat Terendah:     + -
      ```
      Dalam ekspresi `3 + 5 * 2`, `5 * 2` (10) dievaluasi terlebih dahulu, kemudian `3 + 10`, menghasilkan `13`. Untuk mengubah urutan, gunakan tanda kurung: `(3 + 5) * 2` menghasilkan `16`.

  - **Associativity (Asosiativitas)**: Menentukan urutan untuk operator dengan prioritas yang sama. Sebagian besar operator bersifat _left-to-right_.

    - `8 - 4 - 2` dievaluasi sebagai `(8 - 4) - 2` -\> `4 - 2` -\> `2`.
    - **Pengecualian**: `^` (pangkat) dan `..` (penyambungan) bersifat _right-to-left_.
      - `2 ^ 3 ^ 2` dievaluasi sebagai `2 ^ (3 ^ 2)` -\> `2 ^ 9` -\> `512`. Ini standar dalam matematika.

#### **1.3 Number Literals dan Formats**

- **Topik**: Berbagai cara menulis angka di Lua.

- **Materi dan Penjelasan**:

  - **Desimal**: `123`, `123.45`
  - **Notasi Ilmiah (Scientific Notation)**: Berguna untuk angka yang sangat besar atau sangat kecil. `e` berarti "kali 10 pangkat".
    ```lua
    local speed_of_light = 3e8  -- Sama dengan 3 * (10^8) atau 300,000,000
    local planck_length = 1.6e-35
    print(speed_of_light) -- Output: 300000000
    ```
  - **Heksadesimal**: `0x1A` (desimal 26). Lua juga mendukung notasi heksadesimal untuk float, seperti `0x1.Ap4`, yang berguna dalam komputasi ilmiah tingkat lanjut.

#

<h3 id="satuuu"></h3>

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[home]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../bagian-2/README.md
[2]: ../bagian-2/README.md
[3]: ../bagian-3/README.md
[4]: ../bagian-3/README.md
[5]: ../bagian-4/README.md
[6]: ../bagian-5/README.md
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
