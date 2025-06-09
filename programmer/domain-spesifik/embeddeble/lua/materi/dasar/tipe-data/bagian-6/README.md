# **[6. _Type Coercion_ dan _Conversion_ - _Expert_][0]**

Di Lua, ada dua cara bagaimana sebuah nilai dari satu tipe dapat diubah menjadi tipe lain:

- **_Coercion_ (Pemaksaan/Konversi Implisit)**: Terjadi secara otomatis oleh interpreter Lua dalam konteks tertentu, seperti saat menggunakan string dalam operasi aritmetika.
- **_Conversion_ (Konversi Eksplisit)**: Dilakukan secara sengaja oleh pemrogram menggunakan fungsi-fungsi bawaan seperti `tonumber()` dan `tostring()`.

Memahami perbedaan dan aturan dari keduanya sangat penting untuk menghindari _bug_ yang tidak terduga dan menulis kode yang jelas.

### **6.1 Aturan Konversi Tipe Implisit (_Implicit Type Coercion_)**

#### **Mekanika Pemaksaan Otomatis String-Angka**

- **Deskripsi**: Lua adalah salah satu dari sedikit bahasa pemrograman modern yang melakukan pemaksaan tipe (_coercion_) secara otomatis antara string dan angka dalam konteks aritmetika.

  - **Aturan Aritmetika**: Ketika sebuah string digunakan di tempat di mana angka diharapkan (misalnya, sebagai operand untuk `+`, `-`, `*`, `/`, `^`), Lua akan mencoba mengonversi string tersebut menjadi angka. Jika konversi berhasil, operasi akan dilanjutkan. Jika gagal, Lua akan melaporkan _error_.
  - **Aturan Konkatenasi**: Sebaliknya, operator konkatenasi (`..`) akan mencoba mengonversi angka menjadi string jika operand lainnya adalah string.

- **Contoh Penggunaan**:

  ```lua
  -- Coercion dari String ke Angka (Aritmetika)
  local hasil1 = "10" + 5          -- Lua mengubah "10" menjadi angka 10
  print(hasil1, type(hasil1))    -- Output: 15    number

  local hasil2 = "2.5" * "2"       -- Kedua string diubah menjadi angka
  print(hasil2, type(hasil2))    -- Output: 5.0   number

  -- Coercion dari Angka ke String (Konkatenasi)
  local pesan = "Ada " .. 3 .. " apel." -- Lua mengubah 3 menjadi string "3"
  print(pesan, type(pesan))      -- Output: Ada 3 apel. string

  -- Contoh yang akan Gagal
  -- local hasilError = "halo" + 5  -- Ini akan menyebabkan error saat runtime:
                                   -- attempt to perform arithmetic on a string value
  ```

- **Implikasi dan Praktik Terbaik**:

  - **Kenyamanan vs. Kejelasan**: _Coercion_ otomatis bisa membuat kode lebih ringkas, tetapi terkadang dapat menyembunyikan _bug_ atau membuat niat kode menjadi kurang jelas.
  - **Performa**: Proses konversi ini memiliki _overhead_ kecil. Dalam loop yang sangat ketat atau kode yang kritis terhadap performa, lebih baik melakukan konversi secara eksplisit satu kali di luar loop dan bekerja dengan tipe data yang konsisten.
  - **LuaJIT**: Perlu dicatat bahwa LuaJIT, sebuah implementasi _just-in-time compiler_ untuk Lua, tidak melakukan _coercion_ string ke angka di dalam jejak (_trace_) yang dikompilasinya karena alasan performa. Ini adalah perbedaan penting yang harus diingat saat menargetkan platform LuaJIT.

- **Sumber**:
  - PIL Bab 3.4 memberikan penjelasan mendalam tentang _coercion_.
  - Berbagai dokumentasi juga menyebutkan perilaku ini.

---

#### **Konversi Konteks Boolean (_Boolean Context Conversion_)**

- **Deskripsi**: Ini adalah bentuk lain dari _coercion_ implisit yang sudah kita bahas di bagian "truthiness". Ketika sebuah nilai digunakan dalam konteks di mana boolean diharapkan (misalnya, kondisi `if`, `while`, atau sebagai operand untuk `and`/`or`), Lua akan secara implisit "memaksa" nilai tersebut ke dalam konsep _truthy_ atau _falsy_ untuk tujuan evaluasi logika.

- **Aturan Utama (Pengingat)**:

  - Hanya **`nil`** dan **`false`** yang dianggap _falsy_ (salah).
  - **Semua nilai lainnya** dianggap _truthy_ (benar), termasuk angka `0`, string kosong `""`, dan tabel kosong `{}`.

- **Contoh**:

  ```lua
  local inputPengguna = ""

  -- Di sini, nilai string "" sedang "dikoersi" menjadi nilai boolean truthy
  -- untuk evaluasi kondisi if.
  if inputPengguna then
      print("Input dianggap truthy (meskipun kosong).")
  end

  local data = 0
  -- Operator 'not' memaksa 'data' (nilai 0, yang truthy) menjadi konsep boolean
  -- untuk dinegasikan, menghasilkan 'false'.
  local tidakAdaData = not data
  print(tidakAdaData) -- Output: false
  ```

  Penting untuk diingat bahwa _coercion_ ini tidak mengubah tipe asli dari variabel itu sendiri. `type(inputPengguna)` akan tetap `"string"`.

- **Sumber**:
  - Manual Lua menjelaskan evaluasi kondisional ini di bawah bagian ekspresi logika.
  - Komunitas wiki juga membahas operator logika.

---

### **6.2 Fungsi Konversi Eksplisit**

Untuk kontrol penuh, kejelasan, dan penanganan _error_ yang lebih baik, selalu lebih disukai untuk melakukan konversi secara eksplisit menggunakan fungsi bawaan.

#### **Penggunaan Lanjutan `tonumber()` dan Konversi Basis**

- **Deskripsi**: Fungsi `tonumber()` adalah cara standar dan aman untuk secara eksplisit mengubah sebuah nilai menjadi angka.

  - **Perilaku Dasar**: `tonumber(value)` mencoba mengonversi `value`. Jika berhasil, ia mengembalikan angka yang sesuai. Jika gagal, ia mengembalikan **`nil`**, bukan menyebabkan _error_. Ini membuatnya ideal untuk memvalidasi input dari pengguna atau sumber eksternal.

- **Konversi Basis (Penggunaan Lanjutan)**:
  `tonumber()` dapat menerima argumen kedua opsional, `base`, yang menentukan basis numerik dari string yang akan dikonversi. Basis dapat berupa integer apa pun dari 2 hingga 36.

- **Sintaks**: `tonumber(stringValue, base)`

- **Contoh**:

  ```lua
  -- Penggunaan dasar
  local num1 = tonumber("123.45")
  print(num1) -- Output: 123.45

  local not_a_num = tonumber("hello")
  print(not_a_num) -- Output: nil

  -- Penggunaan dengan basis
  local biner = tonumber("1101", 2)
  print("Biner '1101' adalah:", biner) -- Output: Biner '1101' adalah: 13

  local heksadesimal = tonumber("FF", 16)
  print("Heksadesimal 'FF' adalah:", heksadesimal) -- Output: Heksadesimal 'FF' adalah: 255

  local basis36 = tonumber("Z", 36)
  print("Basis 36 'Z' adalah:", basis36) -- Output: Basis 36 'Z' adalah: 35

  -- Lua juga mengenali format '0x' secara otomatis jika basis tidak ditentukan
  local hex_auto = tonumber("0xFF")
  print("0xFF otomatis:", hex_auto) -- Output: 0xFF otomatis: 255
  ```

- **Sumber**:
  - Manual Lua adalah referensi utama untuk `tonumber`.
  - Tutorial di komunitas wiki sering memberikan contoh tambahan.

---

#### **`tostring()` dan Representasi String Kustom**

- **Deskripsi**: Fungsi `tostring()` adalah cara eksplisit untuk mengonversi nilai apa pun menjadi representasi string-nya.

- **Perilaku Bawaan**:

  - `tostring(123)` -> `"123"`
  - `tostring(nil)` -> `"nil"`
  - `tostring(true)` -> `"true"`
  - `tostring({})` -> `"table: 0x..."` (alamat memori)
  - `tostring(function() end)` -> `"function: 0x..."` (alamat memori)

- **Representasi Kustom dengan `__tostring`**:
  Kekuatan sebenarnya dari `tostring()` muncul ketika digunakan dengan objek kustom (tabel atau userdata). Jika objek yang Anda berikan ke `tostring()` memiliki metatable dengan _metamethod_ `__tostring`, maka Lua akan memanggil fungsi `__tostring` tersebut dan menggunakan hasilnya sebagai representasi string. Ini sangat penting untuk debugging dan membuat output yang mudah dibaca. Fungsi `print()` juga secara otomatis memanggil `tostring()` pada argumennya.

- **Contoh**:
  Mari kita kembali ke "kelas" `Vector` kita dan tambahkan representasi string kustom.

  ```lua
  Vector = {}
  Vector.__index = Vector

  function Vector:new(x, y)
      return setmetatable({x = x, y = y}, self)
  end

  -- Menambahkan metamethod __tostring
  function Vector:__tostring()
      return string.format("Vector(x=%g, y=%g)", self.x, self.y)
  end

  -- Metode lain...
  function Vector:__add(other)
      return Vector:new(self.x + other.x, self.y + other.y)
  end

  -- Set __add di metatable
  Vector.__add = Vector.__add

  local v1 = Vector:new(3, 4)
  local v2 = Vector:new(7, 8)
  local v3 = v1 + v2 -- Menggunakan __add

  -- Tanpa __tostring, print(v1) akan mencetak sesuatu seperti "table: 0x1234abcd"
  -- Dengan __tostring, outputnya jauh lebih informatif.
  print("v1 adalah " .. tostring(v1))
  print("v2 adalah " .. tostring(v2))
  print("v3 (hasil penjumlahan) adalah:", v3) -- print() akan memanggil tostring() secara implisit
  ```

  **Output:**

  ```
  v1 adalah Vector(x=3, y=4)
  v2 adalah Vector(x=7, y=8)
  v3 (hasil penjumlahan) adalah: Vector(x=10, y=12)
  ```

  - **Penjelasan Sintaksis**:
    - `function Vector:__tostring()`: Mendefinisikan _metamethod_ `__tostring` untuk kelas `Vector`.
    - `string.format("Vector(x=%g, y=%g)", self.x, self.y)`: `string.format` digunakan untuk membuat string yang terformat dengan baik. `%g` adalah format yang memilih antara notasi desimal biasa atau notasi ilmiah, mana yang lebih pendek.

- **Sumber**:
  - Manual Lua adalah referensi utama untuk `tostring`.
  - Komunitas wiki juga membahas konversi ke string.

Kita telah membahas bagaimana Lua menangani konversi tipe. Pemahaman ini membantu Anda menulis kode yang lebih kuat dan dapat diprediksi.

Selanjutnya dalam kurikulum adalah **"7. _Memory Management_ - _Deep Dive_"**. Ini akan membawa kita lebih dalam ke cara kerja _garbage collector_ Lua, _weak tables_, dan finalisasi.

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
[1]: ../README.md#6-type-coercion-dan-conversion---expert
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
