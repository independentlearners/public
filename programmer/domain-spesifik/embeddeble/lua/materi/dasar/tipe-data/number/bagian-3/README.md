# LEVEL 3: ADVANCED ARITHMETIC

Di level ini, kita akan membahas fungsi-fungsi yang menjadi tulang punggung dalam aplikasi ilmiah, rekayasa, dan grafis.

#### **3.1 Trigonometric Functions**

- **Topik**: `sin`, `cos`, `tan`, `asin`, `acos`, `atan`, `atan2`.

- **Konsep Fundamental**: Fungsi trigonometri di Lua, seperti dalam kebanyakan bahasa pemrograman, bekerja dengan **radian**, bukan derajat. Radian adalah satuan standar untuk mengukur sudut dalam matematika, berdasarkan radius lingkaran.

  - `2π` radian = `360` derajat
  - `π` radian = `180` derajat

- **Materi dan Penjelasan**:

  - **Konversi Radian vs. Derajat**: Anda harus selalu mengonversi sudut Anda ke radian sebelum menggunakannya dalam fungsi trigonometri. Library `math` menyediakan cara mudah untuk ini (`math.rad` dan `math.deg` yang akan dibahas di 3.2).

    ```lua
    -- Konversi 90 derajat ke radian
    local angle_in_degrees = 90
    local angle_in_radians = math.rad(angle_in_degrees)
    print(angle_in_radians) -- Output: 1.5707963267949 (yaitu, π/2)

    -- Sekarang kita bisa menggunakan fungsi cosinus
    -- Cosinus dari 90 derajat adalah 0
    print(math.cos(angle_in_radians)) -- Output: 6.12...e-17 (angka yang sangat kecil, mendekati 0)
    -- Kenapa tidak persis 0? Ini adalah contoh dari keterbatasan presisi floating-point!
    ```

  - **Fungsi Dasar**:

    - `math.sin(rad)`: Menghitung sinus dari sudut `rad`.
    - `math.cos(rad)`: Menghitung kosinus dari sudut `rad`.
    - `math.tan(rad)`: Menghitung tangen dari sudut `rad`.

  - **Fungsi Invers (Arcus)**: Fungsi-fungsi ini melakukan kebalikannya; mereka mengambil rasio dan mengembalikan sudut (dalam radian).

    - `math.asin(ratio)`: Menghitung arcus sinus. Mengembalikan sudut yang sinusnya adalah `ratio`. Input harus antara -1 dan 1.
    - `math.acos(ratio)`: Menghitung arcus kosinus. Input harus antara -1 dan 1.
    - `math.atan(ratio)`: Menghitung arcus tangen.

  - **`math.atan2(y, x)`**: Ini adalah "arcus tangen dua argumen" yang sangat berguna.

    - **Problem**: `math.atan(y/x)` tidak dapat membedakan antara sudut di kuadran yang berlawanan. Misalnya, `atan(1/-1)` dan `atan(-1/1)` keduanya akan menjadi `atan(-1)`, sehingga Anda kehilangan informasi tentang apakah `y` atau `x` yang negatif.
    - **Solusi**: `math.atan2(y, x)` menggunakan tanda dari `y` dan `x` untuk menentukan sudut yang benar di antara semua 360 derajat (atau `2π` radian). Ini sangat penting dalam pemrograman game dan grafis untuk menghitung sudut objek.

    <!-- end list -->

    ```lua
    -- (y, x) -> (1, -1) adalah di kuadran II (sekitar 135 derajat)
    print(math.deg(math.atan2(1, -1))) -- Output: 135.0

    -- (y, x) -> (-1, 1) adalah di kuadran IV (sekitar -45 atau 315 derajat)
    print(math.deg(math.atan2(-1, 1))) -- Output: -45.0

    -- Menggunakan atan biasa akan memberikan hasil yang sama untuk keduanya
    print(math.deg(math.atan(-1))) -- Output: -45.0 (Informasi kuadran hilang)
    ```

#### **3.2 Logarithmic dan Exponential Functions**

- **Topik**: `exp`, `log`, `log10`, `sqrt`, `pow`, `deg`, `rad`.
- **Materi dan Penjelasan**:

  - `math.exp(x)`: Menghitung `e^x`, di mana `e` adalah konstanta Euler (\~2.71828), dasar dari logaritma natural.
  - `math.log(x)`: Menghitung logaritma natural (basis `e`) dari `x`. Ini adalah kebalikan dari `exp`.
  - `math.log10(x)`: Menghitung logaritma basis 10 dari `x`. Usang di Lua 5.2+, tetapi `math.log` dengan argumen kedua dapat digunakan. Sejak Lua 5.3, `math.log(x, 10)` tidak ada, Anda harus menggunakan rumus.
  - **Menghitung Logaritma Basis Kustom**: Anda dapat menghitung logaritma dari basis apapun menggunakan rumus perubahan basis: `log_b(x) = log_a(x) / log_a(b)`.

    ```lua
    -- Menghitung log basis 2 dari 8 (jawabannya adalah 3)
    function log_base(x, base)
      return math.log(x) / math.log(base)
    end

    print(log_base(8, 2)) -- Output: 3.0
    print(log_base(100, 10)) -- Output: 2.0 (sama seperti math.log10(100))
    ```

  - `math.sqrt(x)`: Menghitung akar kuadrat dari `x`. Sama dengan `x ^ 0.5`. Input tidak boleh negatif.
  - `math.pow(x, y)`: Menghitung `x` pangkat `y`. Di versi Lua modern (5.3+), ini dianggap usang. Anda harus menggunakan operator `^`.
  - `math.rad(deg)`: Mengonversi sudut dari derajat ke radian.
  - `math.deg(rad)`: Mengonversi sudut dari radian ke derajat.

#### **3.3 Power Functions dan Roots**

- **Topik**: Berbagai cara menghitung pangkat dan akar.
- **Materi dan Penjelasan**:
  - **Operator `^` vs `math.pow()`**: Gunakan `^`. Ini adalah cara idiomatik modern di Lua dan terintegrasi lebih baik dengan aturan prioritas operator.
  - **`math.sqrt(x)` vs `x^0.5`**: Keduanya menghasilkan hasil yang sama untuk input positif. `math.sqrt` mungkin sedikit lebih cepat dan lebih eksplisit tentang niat Anda.
  - **Menghitung Akar ke-n (nth root)**: Anda dapat menghitung akar ke-n dari sebuah angka dengan menggunakan eksponen pecahan.
    ```lua
    -- Menghitung akar pangkat 3 dari 27 (jawabannya 3)
    local x = 27
    local n = 3
    local nth_root = x ^ (1/n)
    print(nth_root) -- Output: 3.0
    ```
  - **Basis Negatif dan Eksponen Pecahan**: Ini adalah area yang rumit. Dalam matematika, ini sering kali menghasilkan bilangan kompleks. Di Lua, ini biasanya akan menghasilkan `NaN`.
    ```lua
    print((-8)^(1/3)) -- Seharusnya -2, tapi komputasi float bisa rumit
    print((-1)^0.5)   -- Akar kuadrat dari -1. Hasilnya NaN.
    ```

---

# LEVEL 3.5: ERROR HANDLING & EDGE CASES

Kode numerik jarang sesederhana kelihatannya. Memahami cara menangani kasus-kasus ekstrem dan kesalahan adalah tanda seorang programmer yang kompeten.

#### **3.5.1 Mathematical Error Handling**

- **Topik**: Domain errors, overflow, underflow.
- **Materi dan Penjelasan**:
  - **Perilaku Pembagian dengan Nol (Division by Zero)**: Lua mengikuti standar IEEE 754.
    - `1 / 0` -\> `inf` (Infinity)
    - `-1 / 0` -\> `-inf` (-Infinity)
    - `0 / 0` -\> `nan` (Not a Number)
  - **Akar Kuadrat dari Bilangan Negatif (Square root of negative numbers)**: Ini adalah "domain error" karena `sqrt` tidak terdefinisi untuk input negatif dalam bilangan real. Hasilnya `NaN`.
    ```lua
    print(math.sqrt(-4)) -- Output: nan
    ```
  - **Logaritma dari Bilangan Non-Positif (Logarithm of non-positive numbers)**: Domain logaritma adalah bilangan positif.
    - `math.log(0)` -\> `-inf`
    - `math.log(-1)` -\> `nan`
  - **Aturan Propagasi `NaN` (NaN propagation rules)**: Setiap operasi aritmetika yang melibatkan `NaN` akan menghasilkan `NaN`. Ini seperti "racun" yang menyebar melalui kalkulasi Anda, yang sebenarnya berguna untuk menandakan bahwa ada sesuatu yang salah di awal.
    ```lua
    local bad_value = math.sqrt(-1) -- ini adalah NaN
    local result = bad_value + 10
    print(result) -- Output: nan
    ```
  - **Aturan Aritmetika Tak Hingga (Infinity arithmetic rules)**:
    - `math.huge + 100` -\> `inf`
    - `math.huge * 2` -\> `inf`
    - `math.huge / 2` -\> `inf`
    - `math.huge - math.huge` -\> `nan` (tidak terdefinisi)
    - `math.huge / math.huge` -\> `nan` (tidak terdefinisi)

#### **3.5.2 Range dan Precision Limits**

- **Topik**: Batas numerik dan presisi.
- **Materi dan Penjelasan**:
  - **Presisi Floating Point dan Machine Epsilon**: Komputer tidak dapat merepresentasikan semua angka desimal dengan sempurna dalam biner. Ini mengarah pada kesalahan pembulatan kecil.
    ```lua
    -- Contoh klasik
    print(0.1 + 0.2) -- Output: 0.30000000000000004
    print(0.1 + 0.2 == 0.3) -- Output: false
    ```
    - **Terminologi: Machine Epsilon** adalah celah antara `1.0` dan angka floating-point berikutnya yang dapat direpresentasikan. Ini adalah ukuran presisi. Daripada membandingkan float dengan `==`, pendekatan yang lebih baik adalah memeriksa apakah perbedaannya lebih kecil dari epsilon kecil.
  - **Perilaku Integer Overflow (Lua 5.3+)**: Ketika operasi integer melebihi batas `math.maxinteger` atau `math.mininteger`, ia akan "membungkus" (wrap around).
    ```lua
    -- Jalankan di Lua 5.3+
    local max_int = math.maxinteger
    print(max_int)       -- Output: 9223372036854775807
    print(max_int + 1)   -- Output: -9223372036854775808 (wrap ke min_int)
    ```
  - **Kehilangan Signifikansi (Loss of Significance)** dan **Pembatalan Katastropik (Catastrophic Cancellation)**: Terjadi ketika Anda mengurangi dua angka yang sangat besar dan hampir sama. Kesalahan pembulatan kecil pada angka-angka asli dapat menjadi sangat besar secara proporsional pada hasilnya, menghapus banyak digit presisi yang benar. Ini adalah masalah numerik yang canggih yang perlu diwaspadai dalam komputasi ilmiah.

#### **3.5.3 Cross-Platform Considerations**

- **Topik**: Perilaku spesifik platform.
- **Materi dan Penjelasan**:
  - **Implementasi Math Library yang Berbeda**: Lua standar menggunakan library matematika C (`libm`) dari sistem operasi yang mendasarinya. Mungkin ada perbedaan kecil dalam implementasi fungsi-fungsi kompleks (seperti `sin` atau `log`) antara platform yang berbeda (misalnya, Windows vs. Linux).
  - **Perbedaan Presisi**: Perbedaan ini dapat menyebabkan hasil perhitungan floating-point yang sangat kompleks sedikit berbeda (mungkin di digit desimal ke-15 atau ke-16) antar platform. Untuk sebagian besar aplikasi, ini tidak menjadi masalah, tetapi untuk komputasi ilmiah yang deterministik, ini bisa menjadi pertimbangan.
  - **Variasi Performa**: Kecepatan eksekusi fungsi matematika juga dapat bervariasi tergantung pada perangkat keras dan kompilator C yang digunakan untuk membangun Lua.

#

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
