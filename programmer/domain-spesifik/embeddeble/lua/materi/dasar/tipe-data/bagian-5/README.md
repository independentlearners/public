# **[5. Sistem Metatable - Penguasaan Menyeluruh][0]**

Kita telah tiba di salah satu bagian paling fundamental dan kuat dari Lua, yang menyatukan semua yang telah kita pelajari tentang tabel dan userdata: **Sistem Metatable.**

#

Sistem metatable adalah mekanisme _operator overloading_ di Lua. Ini adalah sebuah sistem yang memungkinkan Anda untuk mengubah perilaku standar dari sebuah nilai (biasanya tabel atau userdata) ketika operasi tertentu (seperti penjumlahan, pengindeksan, atau pemanggilan) dilakukan padanya. Dengan metatable, Anda dapat membuat tipe data Anda sendiri yang berperilaku seperti objek, vektor, atau struktur data kustom lainnya, yang terintegrasi secara mulus dengan sintaks Lua.

### **5.1 Arsitektur Metatable**

#### **Rantai Pencarian Metatable (_Lookup Chain_) dan Pewarisan (_Inheritance_)**

- **Deskripsi**: Ketika Lua mencoba melakukan sebuah operasi pada sebuah nilai, misalnya `a + b`, ia akan pertama-tama memeriksa apakah nilai tersebut mendukung operasi itu secara alami. Jika tidak (misalnya, mencoba menjumlahkan dua tabel), Lua akan memeriksa apakah nilai pertama (`a`) memiliki sebuah **metatable**.

  - **_Metatable_**: Sebuah tabel Lua biasa yang berisi _field-field_ khusus yang disebut **_metamethods_**. Nama _metamethod_ diawali dengan dua garis bawah (contoh: `__add`, `__index`).
  - **Proses Pencarian (_Lookup Process_)**:
    1.  Lua mendapatkan metatable dari operand (`getmetatable(a)`).
    2.  Jika metatable ada, Lua mencari _metamethod_ yang sesuai dengan operasi tersebut (misalnya, `__add` untuk penjumlahan).
    3.  Jika _metamethod_ ditemukan, Lua akan memanggilnya untuk melakukan operasi.
    4.  Jika metatable atau _metamethod_ tidak ditemukan, Lua akan melaporkan _error_.

- **Pewarisan dengan `__index`**:
  Metatable adalah dasar dari implementasi **pemrograman berorientasi objek (OOP) berbasis prototipe** di Lua. Mekanisme yang paling penting untuk ini adalah _metamethod_ `__index`.

  - **Pola Umum**: Anda membuat sebuah tabel "kelas" (prototipe) yang berisi semua metode. Kemudian, untuk setiap "objek" (yang juga merupakan tabel), Anda membuat metatable-nya sendiri dan mengatur `metatable.__index` untuk menunjuk ke tabel kelas tersebut.
  - **Alur Pencarian Metode**:
    1.  Anda memanggil sebuah metode pada objek: `objek:metode()`.
    2.  Lua mencoba mencari _field_ `"metode"` di dalam `objek`. Ia gagal karena _field_ tersebut tidak ada di sana.
    3.  Lua mendapatkan metatable dari `objek`.
    4.  Lua memeriksa _field_ `__index` di dalam metatable tersebut.
    5.  Karena `__index` menunjuk ke tabel "kelas", Lua sekarang mencari _field_ `"metode"` di dalam tabel "kelas" itu.
    6.  Ia berhasil menemukan metodenya dan memanggilnya.

- **Contoh Pewarisan Sederhana**:

  ```lua
  -- 1. Buat 'kelas' (prototipe)
  Vector = {}
  function Vector:new(x, y)
      local obj = {x = x, y = y}
      setmetatable(obj, self) -- 'self' di sini adalah tabel Vector
      self.__index = self     -- Atur __index untuk menunjuk ke diri sendiri (tabel Vector)
      return obj
  end

  function Vector:magnitude()
      -- 'self' di sini akan merujuk ke objek pemanggil (misal, v1)
      return math.sqrt(self.x^2 + self.y^2)
  end

  -- 2. Buat 'objek' atau 'instance'
  local v1 = Vector:new(3, 4)

  -- 3. Panggil metode
  -- Lua tidak menemukan 'magnitude' di v1, jadi ia mencari di metatable(v1).__index,
  -- yang merupakan tabel Vector, dan menemukannya di sana.
  print(v1:magnitude()) -- Output: 5
  ```

  - **Penjelasan Sintaksis**:
    - `function Vector:new(...)`: Penggunaan kolon (`:`) adalah _syntactic sugar_. Ini secara otomatis menambahkan parameter tersembunyi bernama `self` sebagai argumen pertama fungsi. `Vector:new(x, y)` setara dengan `function Vector.new(self, x, y)`.
    - `v1:magnitude()`: Pemanggilan metode dengan kolon juga _syntactic sugar_. Ini secara otomatis memberikan `v1` sebagai argumen pertama (`self`) ke fungsi `magnitude`. `v1:magnitude()` setara dengan `Vector.magnitude(v1)`.

---

#### **Internal `setmetatable()` dan `getmetatable()`**

- **`setmetatable(table, metatable)`**:

  - **Tujuan**: Fungsi ini digunakan untuk **mengatur** atau **mengganti** metatable dari sebuah `table` (atau `userdata`).
  - **Perilaku**:
    - Argumen pertama adalah tabel yang metatable-nya ingin diatur.
    - Argumen kedua adalah tabel yang akan menjadi metatable-nya (bisa juga `nil` untuk menghapus metatable).
    - Fungsi ini mengembalikan argumen pertama (`table`), yang memungkinkan untuk melakukan _chaining_ seperti `local obj = setmetatable({}, mt)`.

- **`getmetatable(object)`**:

  - **Tujuan**: Fungsi ini digunakan untuk **mengambil** metatable dari sebuah `object`.
  - **Perilaku**:
    - Jika objek tidak memiliki metatable, ia mengembalikan `nil`.
    - Jika objek memiliki metatable, ia akan mengembalikannya.

- **Melindungi Metatable dengan `__metatable`**:
  Anda dapat mencegah kode lain untuk mengakses atau mengubah metatable Anda dengan menambahkan _field_ `__metatable` ke dalam metatable itu sendiri.

  - Jika `__metatable` ada di dalam sebuah metatable, maka:
    - `getmetatable(obj)` akan mengembalikan nilai dari _field_ `__metatable` tersebut, bukan metatable aslinya.
    - `setmetatable(obj, ...)` akan menyebabkan _error_.

- **Contoh Proteksi**:

  ```lua
  local mt = {
      __metatable = "Metatable ini dilindungi!"
  }
  local obj = setmetatable({}, mt)

  print(getmetatable(obj)) -- Output: Metatable ini dilindungi!

  -- Mencoba mengubah metatable akan menyebabkan error
  local status, err = pcall(function()
      setmetatable(obj, {})
  end)
  if not status then
      print("Error:", err) -- Output: Error: ... cannot change a protected metatable
  end
  ```

- **Sumber**:
  - Manual Lua adalah referensi utama untuk `setmetatable` dan `getmetatable`.
  - Tutorial di komunitas wiki juga membahas penggunaannya.

---

### **5.2 Referensi Lengkap _Metamethods_**

Berikut adalah daftar _metamethods_ utama dan fungsinya.

#### **_Metamethods_ Aritmetika**

Ini digunakan untuk meng-overload operator-operator aritmetika.

- `__add(a, b)`: untuk `a + b`
- `__sub(a, b)`: untuk `a - b`
- `__mul(a, b)`: untuk `a * b`
- `__div(a, b)`: untuk `a / b`
- `__mod(a, b)`: untuk `a % b`
- `__pow(a, b)`: untuk `a ^ b`
- `__unm(a)`: untuk `-a` (negasi unary)
- `__idiv(a, b)`: untuk `a // b` (pembagian _floor_)
- _Bitwise_ (Lua 5.3+): `__band`, `__bor`, `__bxor`, `__bnot`, `__shl`, `__shr`

**Contoh (`__add` untuk Vektor):**

```lua
local mt = {}
function mt.__add(v1, v2)
    return Vector:new(v1.x + v2.x, v1.y + v2.y) -- Menggunakan 'kelas' Vector dari contoh sebelumnya
end

-- Asumsikan v1 dan v2 adalah tabel Vector dengan 'mt' sebagai metatable-nya
-- local v3 = v1 + v2 -- Ini akan memanggil mt.__add
```

---

#### **_Metamethods_ Relasional**

Ini digunakan untuk meng-overload operator-operator perbandingan.

- `__eq(a, b)`: untuk `a == b`. Hanya dipanggil jika `a` dan `b` adalah tabel atau userdata dengan tipe yang sama.
- `__lt(a, b)`: untuk `a < b`
- `__le(a, b)`: untuk `a <= b`

**Aturan Penting**: Lua secara otomatis menerjemahkan operator lain. Anda hanya perlu menyediakan ketiga _metamethod_ di atas.

- `a > b` diterjemahkan menjadi `b < a` (memanggil `__lt`).
- `a >= b` diterjemahkan menjadi `b <= a` (memanggil `__le`).
- `a ~= b` diterjemahkan menjadi `not (a == b)` (memanggil `__eq`).

**Contoh (`__eq` untuk Vektor):**

```lua
function mt.__eq(v1, v2)
    return v1.x == v2.x and v1.y == v2.y
end
```

---

#### **_Metamethods_ Akses Tabel**

Ini adalah _metamethod_ yang sangat penting untuk mengontrol bagaimana tabel diakses.

- **`__index(table, key)`**: Dipanggil ketika Lua mencoba mengakses `table[key]`, tetapi `key` **tidak ada** di dalam `table`.

  - **Jika `__index` adalah fungsi**: Fungsi tersebut dipanggil, dan hasilnya dikembalikan.
  - **Jika `__index` adalah tabel**: Lua akan mencari `key` di dalam tabel `__index` tersebut. (Ini adalah dasar pewarisan).

- **`__newindex(table, key, value)`**: Dipanggil ketika Lua mencoba untuk menetapkan `table[key] = value`, tetapi `key` **tidak ada** di dalam `table`.
  - **Jika `__newindex` adalah fungsi**: Fungsi tersebut dipanggil. Penugasan ke tabel asli **tidak terjadi** kecuali Anda melakukannya secara eksplisit di dalam fungsi `__newindex` (misalnya dengan `rawset(table, key, value)`).
  - **Jika `__newindex` adalah tabel**: Lua akan melakukan penugasan di dalam tabel `__newindex` tersebut, bukan di tabel asli.

**Contoh (`__index` dan `__newindex` untuk _read-only table_):**

```lua
local ro_mt = {
    __index = function(t, k)
        error("Kunci '" .. tostring(k) .. "' tidak ada di tabel read-only", 2)
    end,
    __newindex = function(t, k, v)
        error("Tidak dapat mengubah tabel read-only", 2)
    end
}

local data = {x = 10}
local ro_data = setmetatable({}, { __index = data, __newindex = ro_mt.__newindex })

print(ro_data.x) -- Output: 10 (ditemukan di 'data' melalui __index)
-- ro_data.y -- Akan error: Kunci 'y' tidak ada...
-- ro_data.x = 20 -- Akan error: Tidak dapat mengubah...
```

---

#### **_Metamethods_ Spesial**

Ini memberikan perilaku khusus lainnya.

- `__tostring(obj)`: Dipanggil oleh `tostring(obj)` atau `print(obj)`. Berguna untuk memberikan representasi string yang dapat dibaca dari objek Anda.
- `__len(obj)`: Dipanggil oleh operator panjang `#obj`.
- `__call(obj, ...)`: Sangat kuat. Ini memungkinkan sebuah tabel atau userdata untuk **dipanggil seperti sebuah fungsi**. `obj(...)` akan memanggil _metamethod_ `__call`, memberikan `obj` sebagai argumen pertama, diikuti oleh argumen-argumen lainnya.

**Contoh (`__call`):**

```lua
local obj = setmetatable({}, {
    __call = function(self, a, b)
        print("Objek dipanggil dengan argumen:", a, b)
        return a + b
    end
})

local hasil = obj(10, 20) -- Memanggil __call
print("Hasil:", hasil) -- Output: Hasil: 30
```

---

#### **_Metamethods_ Tingkat Lanjut**

Ini terkait dengan manajemen memori dan internal Lua.

- `__gc(obj)`: Seperti yang dibahas di bagian `userdata`, ini adalah _finalizer_. Dipanggil oleh _garbage collector_ sesaat sebelum sebuah objek (`userdata` atau tabel) akan dihancurkan. Gunakan untuk melepaskan sumber daya eksternal.
- `__mode`: Digunakan untuk membuat **_weak tables_ (tabel lemah)**. `__mode` adalah string yang bisa berisi:
  - `"k"`: Membuat **kunci** tabel menjadi _weak_. Jika sebuah objek hanya direferensikan sebagai kunci di tabel ini, ia dapat di-GC.
  - `"v"`: Membuat **nilai** tabel menjadi _weak_. Jika sebuah objek hanya direferensikan sebagai nilai di tabel ini, ia dapat di-GC.
  - `"kv"`: Membuat kunci dan nilai menjadi _weak_.
  - _Weak tables_ sangat berguna untuk _caching_ atau asosiasi data tanpa menyebabkan kebocoran memori (_memory leaks_).
- `__metatable`: Seperti yang telah dibahas, _field_ ini digunakan untuk melindungi metatable dari akses dan modifikasi eksternal.

Anda telah menyelesaikan bagian yang sangat penting tentang metatable. Dengan pengetahuan ini, Anda dapat memahami bagaimana OOP diimplementasikan di Lua dan bagaimana cara membuat tipe data Anda sendiri yang kuat dan ekspresif.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md

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
