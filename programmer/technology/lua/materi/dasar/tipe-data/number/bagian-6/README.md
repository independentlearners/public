Kita akan menyelam lebih dalam ke "jeroan" angka dengan mempelajari operasi bitwise, yang memungkinkan kita memanipulasi representasi biner dari sebuah angka secara langsung. Setelah itu, kita akan menjelajahi salah satu fitur paling kuat di Lua, metamethods, yang memungkinkan kita untuk mendefinisikan ulang cara operator matematika bekerja pada tipe data kustom kita sendiri.

-----

### LEVEL 6: BIT OPERATIONS

Operasi bitwise (atau operasi bit) bekerja langsung pada bit (0 dan 1) yang membentuk sebuah angka integer. Ini sangat cepat dan efisien untuk tugas-tugas tertentu, seperti mengelola flag, mengompresi data, atau bekerja dengan protokol jaringan tingkat rendah.

#### **6.1 Bitwise Operations Basics (Lua 5.3+)**

Sejak Lua 5.3, operasi bitwise menjadi operator bawaan, membuatnya mudah dan efisien untuk digunakan. Operasi ini bekerja pada representasi integer 64-bit dari sebuah angka.

  * **Konsep**: Mari kita gunakan dua angka, `a = 5` (biner `0101`) dan `b = 3` (biner `0011`), sebagai contoh.

  * **Materi dan Penjelasan**:

      * **`&` (Bitwise AND)**: Menghasilkan bit `1` hanya jika kedua bit di posisi yang sama adalah `1`.
        ```
          0101  (5)
        & 0011  (3)
        ------
        = 0001  (1)
        ```
        ```lua
        print(5 & 3) -- Output: 1
        ```
      * **`|` (Bitwise OR)**: Menghasilkan bit `1` jika salah satu bit di posisi yang sama adalah `1`.
        ```
          0101  (5)
        | 0011  (3)
        ------
        = 0111  (7)
        ```
        ```lua
        print(5 | 3) -- Output: 7
        ```
      * **`~` (Bitwise XOR - Exclusive OR)**: Menghasilkan bit `1` jika bit di posisi yang sama berbeda.
        ```
          0101  (5)
        ~ 0011  (3)
        ------
        = 0110  (6)
        ```
        ```lua
        print(5 ~ 3) -- Output: 6
        ```
      * **`<<` (Left Shift)**: Menggeser semua bit ke kiri sebanyak N posisi, mengisi dengan 0 di kanan. Efeknya sama dengan mengalikan dengan `2^N`.
        ```lua
        -- 5 << 1  (geser 0101 ke kiri 1 posisi)
        print(5 << 1) -- Output: 10 (biner 1010)
        ```
      * **`>>` (Right Shift)**: Menggeser semua bit ke kanan sebanyak N posisi. Efeknya sama dengan pembagian integer dengan `2^N`.
        ```lua
        -- 5 >> 1 (geser 0101 ke kanan 1 posisi)
        print(5 >> 1) -- Output: 2 (biner 0010, bit terakhir hilang)
        ```
      * **`~` (Bitwise NOT)**: Membalik semua bit dari sebuah angka (0 menjadi 1, 1 menjadi 0) dalam representasi 64-bit.
        ```lua
        -- Ini akan menghasilkan angka negatif yang besar karena bit paling kiri (bit tanda) juga dibalik.
        print(~5)
        ```

#### **6.2 Bit Library (Lua 5.1/5.2)**

Untuk versi Lua sebelum 5.3, operasi bitwise disediakan oleh library `bit32`, yang bekerja pada integer 32-bit.

  * **Materi dan Penjelasan**: Fungsinya memetakan langsung ke operator modern:
      * `bit32.band(x, y)` adalah `x & y`
      * `bit32.bor(x, y)` adalah `x | y`
      * `bit32.bxor(x, y)` adalah `x ~ y`
      * `bit32.lshift(x, n)` adalah `x << n`
      * `bit32.rshift(x, n)` adalah `x >> n`
      * `bit32.bnot(x)` adalah `~x`
      * Fungsi tambahan seperti `bit32.extract(n, field, width)` dan `bit32.replace(n, v, field, width)` juga tersedia untuk manipulasi bit yang lebih canggih.

#### **6.3 Advanced Bit Manipulation**

  * **Topik**: Bit flags, masks, dan teknik lanjutan.
  * **Materi dan Penjelasan**:
      * **Menggunakan Bit untuk Flags**: Ini adalah penggunaan paling umum. Bayangkan Anda memiliki izin file: Baca, Tulis, Eksekusi. Anda dapat merepresentasikannya sebagai bit individu.
        ```lua
        -- Definisikan flag sebagai pangkat 2
        local PERM_READ = 1  -- Biner: 001
        local PERM_WRITE = 2 -- Biner: 010
        local PERM_EXEC = 4  -- Biner: 100

        -- Berikan izin Baca dan Eksekusi menggunakan bitwise OR
        local my_perms = PERM_READ | PERM_EXEC -- 001 | 100 = 101 (desimal 5)

        -- Untuk memeriksa izin, gunakan bitwise AND
        -- Apakah kita punya izin Tulis?
        if (my_perms & PERM_WRITE) > 0 then
          print("Punya izin tulis.")
        else
          print("Tidak punya izin tulis.") -- Ini yang akan tercetak
        end

        -- Apakah kita punya izin Baca?
        if (my_perms & PERM_READ) > 0 then
          print("Punya izin baca.") -- Ini yang akan tercetak
        end
        ```
      * **Bit Masks**: Sebuah "mask" adalah pola bit yang dirancang untuk memodifikasi atau membaca pola bit lain. Menggunakan AND dengan sebuah mask dapat digunakan untuk "menyaring" atau mengisolasi bit tertentu.

-----

### LEVEL 6.5: MATHEMATICAL METAMETHODS

Ini adalah konsep yang mengubah permainan di Lua. Metamethods memungkinkan Anda untuk **meng-overload operator**, artinya Anda dapat mendefinisikan apa yang terjadi ketika operator seperti `+`, `-`, `*`, dll., digunakan pada tipe data Anda sendiri (biasanya tabel).

  * **Konsep Fundamental**:
      * **Metatable**: Sebuah tabel Lua biasa yang berisi "resep" perilaku untuk tabel lain.
      * **Metamethod**: Kunci dalam metatable yang namanya dimulai dengan dua garis bawah (contoh: `__add`). Nilainya adalah fungsi yang akan dieksekusi ketika operasi terkait dilakukan.

Mari kita buat tipe data `Vector` sederhana untuk mendemonstrasikan ini.

```lua
-- File: Vector.lua
local Vector = {}
Vector.__index = Vector -- Penting untuk OOP

function Vector.new(x, y)
  local self = setmetatable({}, Vector)
  self.x = x
  self.y = y
  return self
end
```

#### **6.5.1 Arithmetic Metamethods**

  * **Topik**: Overloading operator matematika.
  * **Materi dan Penjelasan**:
      * **`__add`, `__sub`, `__mul`, `__div`**: Mendefinisikan penjumlahan, pengurangan, perkalian, dan pembagian.
      * **`__unm`**: Mendefinisikan operasi unary minus (negasi).
        ```lua
        -- Menambahkan __add metamethod ke metatable Vector kita
        function Vector.__add(v1, v2)
          -- Buat vektor baru yang merupakan hasil penjumlahan v1 dan v2
          return Vector.new(v1.x + v2.x, v1.y + v2.y)
        end

        -- Menambahkan __unm untuk negasi
        function Vector.__unm(v)
          return Vector.new(-v.x, -v.y)
        end

        -- Sekarang kita bisa menggunakan operator '+' seolah-olah Vector adalah angka!
        local vA = Vector.new(10, 20)
        local vB = Vector.new(5, 8)

        local vC = vA + vB -- Lua secara otomatis memanggil Vector.__add(vA, vB)
        print(vC.x, vC.y) -- Output: 15  28

        local vD = -vA -- Lua memanggil Vector.__unm(vA)
        print(vD.x, vD.y) -- Output: -10  -20
        ```
      * Ada juga `__mod` (%), `__pow` (^), dan `__idiv` (//, Lua 5.3+).

#### **6.5.2 Comparison Metamethods**

  * **Topik**: Perbandingan matematis.
  * **Materi dan Penjelasan**:
      * **`__eq`**: Untuk memeriksa kesetaraan (`==`). Tanpa ini, `vA == vB` akan memeriksa apakah mereka adalah objek yang sama persis di memori, bukan apakah nilainya sama.
        ```lua
        function Vector.__eq(v1, v2)
          return v1.x == v2.x and v1.y == v2.y
        end

        local v1 = Vector.new(1, 2)
        local v2 = Vector.new(1, 2)
        local v3 = Vector.new(3, 4)

        print(v1 == v2) -- Output: true (berkat __eq)
        print(v1 == v3) -- Output: false
        ```
      * **`__lt` (less than) dan `__le` (less than or equal)**: Untuk operator pengurutan (`<`, `>`, `<=`, `>=`). Anda hanya perlu mendefinisikan `__lt` dan/atau `__le`. Lua secara cerdas akan membalikkan argumen untuk menangani `>` dan `>=`.
        ```lua
        -- Mari kita bandingkan vektor berdasarkan panjangnya (magnitudo kuadrat)
        function Vector.magnitudeSq(v)
          return v.x^2 + v.y^2
        end

        function Vector.__lt(v1, v2)
          return Vector.magnitudeSq(v1) < Vector.magnitudeSq(v2)
        end

        local vec_short = Vector.new(3, 4) -- magnitudo^2 = 25
        local vec_long = Vector.new(10, 1) -- magnitudo^2 = 101

        print(vec_short < vec_long) -- Output: true
        print(vec_long > vec_short) -- Output: true (Lua menggunakan __lt secara internal)
        ```

#### **6.5.3 Advanced Mathematical Metamethods**

  * **Topik**: Konversi string dan fitur lanjutan.
  * **Materi dan Penjelasan**:
      * **`__tostring`**: Dipanggil secara otomatis oleh `print()` atau ketika konversi eksplisit ke string dengan `tostring()` terjadi. Sangat berguna untuk debugging.
        ```lua
        function Vector.__tostring(v)
          return string.format("Vector(x=%g, y=%g)", v.x, v.y)
        end

        local my_vector = Vector.new(1.5, -7)
        print(my_vector) -- Output: Vector(x=1.5, y=-7)  (Jauh lebih informatif!)
        ```
      * **`__concat`**: Untuk operator penyambungan string `..`.
      * **`__call`**: Memungkinkan sebuah tabel untuk "dipanggil" seolah-olah itu adalah sebuah fungsi.

-----

Kita telah menyelesaikan dua level yang sangat padat konsep. Operasi bitwise memberi kita kontrol tingkat rendah, sementara metamethods memberi kita kekuatan ekspresif tingkat tinggi. Level selanjutnya akan membawa kita ke implementasi konsep matematika yang lebih kompleks.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-5/README.md
[selanjutnya]: ../bagian-7/README.md

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
