# LEVEL 2: MATH LIBRARY BASICS

Ini adalah fungsi-fungsi dan konstanta paling umum yang akan Anda gunakan dari library `math`. Menguasai ini akan memungkinkan Anda menyelesaikan sebagian besar masalah matematika sehari-hari.

#### **2.1 Konstanta Matematika**

- **Topik**: `math.pi`, `math.huge`, `math.mininteger`, `math.maxinteger`.

- **Materi dan Penjelasan**:

  - **`math.pi`**: Ini adalah konstanta yang menyimpan nilai Pi (`π`), rasio keliling lingkaran terhadap diameternya. Nilainya kira-kira `3.141592653589793`.

    ```lua
    -- Menghitung luas lingkaran dengan radius 5
    local radius = 5
    local area = math.pi * (radius ^ 2)
    print(area) -- Output: 78.539816339745
    ```

  - **`math.huge`**: Mewakili nilai "tak hingga" (infinity) positif. Ini adalah angka yang lebih besar dari angka lainnya. Berguna untuk perbandingan awal.

    - **Terminologi**: Infinity bukanlah angka dalam artian normal; ini adalah konsep. `math.huge` adalah representasi Lua untuk konsep ini. Ada juga negatif infinity, yang bisa didapat dengan `-math.huge`.
    - **Contoh Kode**:

      ```lua
      print(math.huge > 9999999999999) -- Output: true
      print(-math.huge < -9999999999999) -- Output: true

      -- Kasus penggunaan umum: mencari nilai terkecil dalam sebuah list
      local numbers = {10, 4, 25, 8, -5}
      local smallest = math.huge -- Mulai dengan nilai tak hingga
      for _, num in ipairs(numbers) do
        if num < smallest then
          smallest = num
        end
      end
      print("Angka terkecil adalah:", smallest) -- Output: Angka terkecil adalah: -5
      ```

  - **`math.mininteger` dan `math.maxinteger` (Lua 5.3+)**: Konstanta ini mewakili nilai integer terkecil dan terbesar yang dapat direpresentasikan oleh Lua. Di sebagian besar sistem 64-bit modern, ini adalah rentang yang sangat besar.

    - **Konteks**: Ini terkait langsung dengan pengenalan subtype `integer` di Lua 5.3. Jika sebuah operasi integer menghasilkan angka di luar rentang ini, itu akan "wrap around" (integer overflow), yang akan kita bahas di Level 3.5.
    - **Contoh Kode (jalankan di Lua 5.3+)**:
      ```lua
      print(math.mininteger) -- Output: -9223372036854775808
      print(math.maxinteger) -- Output: 9223372036854775807
      ```

  - **`NaN` (Not a Number)**: Ini adalah nilai khusus yang dihasilkan dari operasi matematika yang tidak terdefinisi.

    - **Konsep**: Apa hasil dari `0/0`? Atau akar kuadrat dari -1? Jawabannya tidak ada dalam bilangan real. Lua merepresentasikan hasil ini sebagai `NaN`.
    - **Sifat Unik**: `NaN` adalah satu-satunya nilai di Lua yang tidak sama dengan dirinya sendiri. Ini adalah cara mendeteksi `NaN`.
    - **Contoh Kode**:

      ```lua
      local not_a_number = 0/0
      print(not_a_number) -- Output: nan (atau -nan tergantung sistem)

      print(not_a_number == 5)       -- Output: false
      print(not_a_number == not_a_number) -- Output: false (SANGAT PENTING!)

      -- Cara yang benar untuk memeriksa apakah sesuatu itu NaN
      local function is_nan(x)
        return x ~= x
      end

      print(is_nan(not_a_number)) -- Output: true
      print(is_nan(10))           -- Output: false
      ```

#### **2.2 Basic Math Functions**

- **Topik**: `abs`, `floor`, `ceil`, `min`, `max`.

- **Materi dan Penjelasan**:

  - **`math.abs(x)`**: Mengembalikan nilai absolut (nilai non-negatif) dari `x`.
    ```lua
    print(math.abs(-15)) -- Output: 15
    print(math.abs(15))  -- Output: 15
    ```
  - **`math.floor(x)`**: Membulatkan `x` ke bawah ke integer terdekat. Bayangkan "lantai" (floor).
    ```lua
    print(math.floor(5.9)) -- Output: 5.0
    print(math.floor(5.1)) -- Output: 5.0
    print(math.floor(-5.9))-- Output: -6.0 (menuju ke arah negatif yang lebih besar)
    ```
  - **`math.ceil(x)`**: Membulatkan `x` ke atas ke integer terdekat. Bayangkan "langit-langit" (ceiling).
    ```lua
    print(math.ceil(5.9)) -- Output: 6.0
    print(math.ceil(5.1)) -- Output: 6.0
    print(math.ceil(-5.9))-- Output: -5.0 (menuju ke arah nol)
    ```
  - **`math.min(...)` dan `math.max(...)`**: Menerima sejumlah argumen dan mengembalikan yang terkecil (`min`) atau terbesar (`max`).
    ```lua
    print(math.max(1, 10, -5, 100, 32)) -- Output: 100
    print(math.min(1, 10, -5, 100, 32)) -- Output: -5
    ```

#### **2.3 Rounding dan Truncation**

- **Topik**: Berbagai teknik pembulatan.

- **Materi dan Penjelasan**:

  - **`math.floor()` vs `math.ceil()`**: Seperti yang ditunjukkan di atas, `floor` selalu ke bawah, `ceil` selalu ke atas.

  - **`math.modf(x)`**: Fungsi ini memisahkan `x` menjadi bagian integer dan bagian pecahan. "modf" adalah singkatan dari "modifiable f". Ia mengembalikan dua nilai.

    ```lua
    local integer_part, fractional_part = math.modf(123.45)
    print(integer_part)   -- Output: 123.0
    print(fractional_part) -- Output: 0.450000000000003 (Melihat presisi float di sini!)

    local int_part, frac_part = math.modf(-5.9)
    print(int_part)       -- Output: -5.0
    print(frac_part)      -- Output: -0.9
    ```

    _Truncation_ (membuang desimal) untuk angka positif sama dengan `math.floor`, tetapi untuk angka negatif sama dengan `math.ceil`. `math.modf` adalah cara paling jelas untuk mendapatkan bagian integer (truncation).

  - **Implementasi Fungsi Pembulatan Kustom (Custom Rounding)**: Lua tidak memiliki fungsi "round to nearest" (bulatkan ke integer terdekat). Kita bisa membuatnya sendiri.

    ```lua
    -- Fungsi pembulatan standar
    function round(num)
      -- Tambahkan 0.5 dan bulatkan ke bawah. Ini secara efektif
      -- membulatkan ke integer terdekat.
      return math.floor(num + 0.5)
    end

    print(round(5.9)) -- Output: 6
    print(round(5.1)) -- Output: 5
    print(round(5.5)) -- Output: 6
    print(round(-2.7))-- Output: -3
    print(round(-2.2))-- Output: -2
    ```

  - **Banker's Rounding**: Ini adalah metode pembulatan lain (juga disebut "round half to even") di mana angka yang berakhiran `.5` dibulatkan ke angka genap terdekat. Tujuannya adalah untuk mengurangi bias statistik dalam kumpulan data besar. Ini tidak ada di library `math` standar tetapi dapat diimplementasikan jika diperlukan untuk aplikasi finansial atau ilmiah.

---

<h3 id="duaaa"></h3>

# LEVEL 2.5: COMPREHENSIVE MATH LIBRARY FUNCTIONS

Level ini berfungsi sebagai inventaris lengkap dan pengenalan fungsi-fungsi yang lebih terspesialisasi.

#### **2.5.1 Complete Function Inventory**

- **Topik**: Semua fungsi math library di Lua 5.1-5.4.
- **Materi**:
  - **Lua 5.1 (Basis)**: `abs`, `acos`, `asin`, `atan`, `atan2`, `ceil`, `cos`, `cosh`, `deg`, `exp`, `floor`, `fmod`, `frexp`, `huge`, `ldexp`, `log`, `log10`, `max`, `min`, `modf`, `pi`, `pow`, `rad`, `random`, `randomseed`, `sin`, `sinh`, `sqrt`, `tan`, `tanh`.
  - **Tambahan Lua 5.2**: `+ math.ult` (unsigned less than). Library `bit32` juga ditambahkan.
  - **Tambahan Lua 5.3**: `+ math.maxinteger`, `math.mininteger`, `math.tointeger`, `math.type`. `math.ult` juga ada di sini. `math.pow` menjadi usang dan digantikan oleh operator `^`.
  - **Lua 5.4**: Kumpulan fungsi tetap sama dengan 5.3.

#### **2.5.2 Hyperbolic Functions**

- **Topik**: `math.sinh`, `math.cosh`, `math.tanh`.
- **Konsep**: Fungsi hiperbolik adalah analog dari fungsi trigonometri biasa, tetapi didefinisikan menggunakan hiperbola, bukan lingkaran. Mereka banyak digunakan dalam fisika dan rekayasa, misalnya untuk menghitung kurva kabel yang tergantung (catenary).
- **Materi dan Penjelasan**:
  - `math.sinh(x)`: Menghitung sinus hiperbolik dari `x`.
  - `math.cosh(x)`: Menghitung kosinus hiperbolik dari `x`.
  - `math.tanh(x)`: Menghitung tangen hiperbolik dari `x`.
  <!-- end list -->
  ```lua
  -- Contoh penggunaan, tidak memerlukan pemahaman matematika yang mendalam
  -- untuk sekadar memanggil fungsinya.
  local x = 1
  print(math.sinh(x)) -- Output: 1.1752011936438
  print(math.cosh(x)) -- Output: 1.5430806348152
  print(math.tanh(x)) -- Output: 0.76159415595576
  ```

#### **2.5.3 Advanced Math Functions**

- **Topik**: `math.frexp`, `math.ldexp`, `math.fmod`, `math.ult`.
- **Konsep**: Fungsi-fungsi ini digunakan untuk manipulasi tingkat rendah dari representasi floating-point atau untuk kasus-kasus khusus dalam aritmetika.
- **Materi dan Penjelasan**:

  - **`math.frexp(x)`**: Memecah angka `x` menjadi dua bagian: mantissa (sebagai nilai antara 0.5 dan 1) dan eksponen biner. Ini "membongkar" representasi float.
  - **`math.ldexp(m, e)`**: Kebalikan dari `frexp`. Ia mengambil mantissa `m` dan eksponen `e` dan menghitung `m * (2^e)`. Ini "merakit" kembali sebuah float.

    ```lua
    local num = 16.0
    local mantissa, exponent = math.frexp(num)
    print(mantissa, exponent) -- Output: 0.5   5   (karena 0.5 * 2^5 = 16)

    local reconstructed_num = math.ldexp(mantissa, exponent)
    print(reconstructed_num) -- Output: 16.0
    ```

  - **`math.fmod(x, y)`**: Menghitung sisa pembagian float, di mana hasilnya memiliki tanda yang sama dengan `x` (dividend). Ini berbeda dari operator `%` yang tandanya mengikuti `y` (divisor).

    ```lua
    print(math.fmod(5.5, 2)) -- Output: 1.5
    print(5.5 % 2)           -- Output: 1.5

    -- Perbedaannya terlihat dengan angka negatif
    print(math.fmod(-10, 3)) -- Output: -1.0 (tanda sama dengan -10)
    print(-10 % 3)           -- Output: 2.0  (tanda sama dengan 3)
    ```

  - **`math.ult(m, n)` (Lua 5.2+)**: Melakukan perbandingan "unsigned less than". Ini membandingkan dua integer seolah-olah mereka adalah bilangan `unsigned` (selalu positif). Berguna dalam operasi bitwise di mana bit tanda diperlakukan sebagai bit nilai.
    ```lua
    -- Di Lua 5.3+
    -- -1 sebagai integer 64-bit memiliki representasi biner yang sangat besar jika
    -- dibaca sebagai unsigned.
    print(math.ult(-1, 0)) -- Output: false
    print(math.ult(0, -1)) -- Output: true
    ```

#### **2.5.4 Type Checking dan Conversion Functions (Lua 5.3+)**

- **Topik**: `math.type`, `math.tointeger`.
- **Konsep**: Sejak Lua 5.3 memperkenalkan subtype integer dan float, fungsi-fungsi ini menyediakan cara untuk memeriksa dan mengonversi tipe-tipe ini secara eksplisit.
- **Materi dan Penjelasan**:

  - **`math.type(x)`**: Memeriksa apakah `x` adalah `integer`, `float`, atau `nil` jika bukan angka.
    ```lua
    print(math.type(10))     -- Output: integer
    print(math.type(10.0))   -- Output: float
    print(math.type("10"))   -- Output: nil
    ```
  - **`math.tointeger(x)`**: Mengonversi `x` menjadi integer jika memungkinkan. Jika `x` bukan angka atau memiliki bagian desimal, ia akan mengembalikan `nil`. Ini adalah cara yang "aman" untuk memastikan Anda memiliki integer.

    ```lua
    local num1 = 123.0
    local num2 = 123.45
    local num3 = "123"

    print(math.tointeger(num1)) -- Output: 123
    print(math.tointeger(num2)) -- Output: nil (karena ada bagian desimal)
    print(math.tointeger(num3)) -- Output: nil (karena ini string)
    ```

#

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
