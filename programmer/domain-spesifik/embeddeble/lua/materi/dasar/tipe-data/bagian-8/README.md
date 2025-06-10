# **[8. FFI dan Tipe Data _Native_][1]**

Bagian ini berfokus secara eksklusif pada **LuaJIT**, sebuah _compiler Just-In-Time_ (JIT) berkinerja tinggi untuk bahasa Lua 5.1. Sementara Lua standar menggunakan `userdata` untuk berinteraksi dengan C, LuaJIT menyediakan mekanisme yang jauh lebih kuat dan langsung yang disebut **Foreign Function Interface (FFI)**.

Pustaka FFI memungkinkan Anda untuk memanggil fungsi C eksternal dan menggunakan struktur data C **langsung dari kode Lua murni**, tanpa perlu menulis kode "lem" C sama sekali. Ini menghasilkan kinerja yang jauh lebih tinggi dan integrasi yang lebih sederhana.

### **8.1 Arsitektur FFI vs. Lua C API**

Mari kita bandingkan kedua pendekatan tersebut.

- **Lua C API Standar (dengan `userdata`)**:

  - **Alur Kerja**: Anda menulis kode C (sebuah "pembungkus" atau "binding") yang menggunakan Lua C API untuk membuat `userdata`, mengatur metatable-nya, dan mengekspos fungsi ke Lua. Kode C ini harus dikompilasi menjadi sebuah pustaka bersama (_shared library_) (`.so` atau `.dll`) yang kemudian dapat di-`require()` oleh Lua.
  - **Kelebihan**: Bekerja pada interpreter Lua standar mana pun. Sangat fleksibel.
  - **Kekurangan**: Membutuhkan pengetahuan tentang C dan Lua C API. Bisa membosankan untuk ditulis dan dipelihara. Memperkenalkan lapisan perantara yang menambah _overhead_ antara Lua dan C.

- **LuaJIT FFI**:
  - **Alur Kerja**: Anda menulis **kode Lua murni**. Anda mendeklarasikan signature fungsi C dan struktur data yang Anda butuhkan menggunakan `ffi.cdef()`. Kemudian Anda dapat langsung memanggil fungsi C dan membuat data C (`cdata`) seolah-olah mereka adalah bagian asli dari Lua.
  - **Kelebihan**: Sangat cepat (seringkali mendekati kecepatan C native). Tidak memerlukan kode lem C. Jauh lebih sederhana dan cepat untuk menulis _binding_.
  - **Kekurangan**: Spesifik untuk lingkungan LuaJIT.

---

### **8.2 Deklarasi Tipe FFI dan Pemanggilan Fungsi**

#### **Mendeklarasikan Tipe dan Fungsi dengan `ffi.cdef`**

Inti dari pustaka FFI adalah `ffi.cdef()`. Fungsi ini menerima sebuah string yang berisi deklarasi bergaya C.

- **Deskripsi**: Anda menggunakan `ffi.cdef` untuk "mengajari" LuaJIT tentang tipe C dan prototipe fungsi yang ingin Anda gunakan. LuaJIT akan mem-parsing deklarasi ini dan memahami ukuran, _alignment_, dan struktur dari data C tersebut.
- **Contoh**:

  ```lua
  -- Kode ini harus dijalankan dengan LuaJIT
  local ffi = require("ffi")

  -- Deklarasikan tipe dan fungsi C di dalam string multi-baris
  ffi.cdef[[
      /* Komentar bergaya C diizinkan */
      // Tipe dasar
      typedef int int32_t;
      typedef unsigned int uint32_t;

      // Sebuah struct C
      typedef struct {
          uint32_t x;
          uint32_t y;
      } point_t;

      // Prototipe fungsi C dari pustaka standar
      // Kita mendeklarasikan fungsi 'printf' dari pustaka standar C
      int printf(const char *format, ...);

      // Sebuah fungsi dari 'my_math_lib.so' hipotetis
      point_t add_points(point_t a, point_t b);
  ]]
  ```

#### **Memuat Pustaka dan Memanggil Fungsi**

Setelah dideklarasikan, Anda dapat memuat sebuah _shared library_ dan memanggil fungsi-fungsinya.

- **`ffi.load(nama_pustaka)`**: Fungsi ini memuat sebuah _shared library_. LuaJIT secara otomatis menyediakan akses ke pustaka sistem standar, yang seringkali dikelompokkan di bawah `ffi.C`.
- **Pemanggilan Fungsi**: Anda memanggil fungsi C seolah-olah mereka adalah fungsi Lua, biasanya melalui objek pustaka (`ffi.C` untuk pustaka standar C).

- **Contoh**:

  ```lua
  -- Memanggil fungsi pustaka standar C
  local ffi = require("ffi")
  ffi.cdef("int printf(const char *format, ...);")

  -- ffi.C adalah namespace khusus untuk simbol pustaka standar C
  ffi.C.printf("Halo dari printf C! Angkanya adalah %d.\n", 123)

  -- Contoh untuk pustaka kustom (hipotetis)
  -- local my_lib = ffi.load("my_math_lib")
  -- local p1 = ffi.new("point_t", { 10, 20 })
  -- local p2 = ffi.new("point_t", { 30, 40 })
  -- local result = my_lib.add_points(p1, p2)
  -- ffi.C.printf("Hasil: { x=%d, y=%d }\n", result.x, result.y)
  ```

---

### **8.3 Tipe `cdata`: Representasi Data _Native_**

Ketika Anda membuat atau menerima data dari pustaka FFI, data tersebut memiliki tipe khusus yang disebut `cdata` (C data).

#### **Membuat, Mengakses, dan Meng-cast `cdata`**

- **`ffi.new(tipe_c, [initializer])`**: Ini adalah cara utama untuk mengalokasikan data C baru.

  - `tipe_c`: Sebuah string dengan nama tipe C yang akan dibuat (misalnya, `"point_t"`, `"int[100]"`).
  - `initializer`: Sebuah tabel atau nilai Lua opsional untuk menginisialisasi data C.

- **Mengakses Data**:

  - **_Structs_**: Gunakan notasi titik (`.`) atau kurung siku (`[]`), sama seperti tabel Lua.
  - **_Arrays_**: Gunakan pengindeksan berbasis 0, sama seperti di C.
  - **_Pointers_**: Gunakan `[0]` untuk melakukan _dereference_ pada sebuah _pointer_.

- **`ffi.cast(tipe_c, nilai)`**: Melakukan _cast_ (perubahan tipe) pada sebuah nilai (seperti angka atau _pointer_ `cdata` lain) ke tipe C yang berbeda.

- **Contoh Lengkap**:

  ```lua
  local ffi = require("ffi")
  ffi.cdef[[
      typedef struct { double x; double y; } point_t;
  ]]

  -- 1. Membuat instance struct C
  -- Tabel { 3.5, 7.0 } digunakan untuk menginisialisasi field secara berurutan.
  local p1 = ffi.new("point_t", { 3.5, 7.0 })
  print(string.format("p1.x = %f, p1.y = %f", p1.x, p1.y))
  print("Tipe dari p1 adalah:", ffi.type(p1)) -- Output: cdata<point_t>

  -- 2. Membuat array C
  -- Membuat sebuah array berisi 5 integer.
  local arr = ffi.new("int[5]", {11, 22, 33, 44, 55})
  print("Elemen kedua dari array C (indeks berbasis 0):", arr[1]) -- Output: 22

  -- 3. Bekerja dengan pointer
  local p_ptr = ffi.new("point_t*") -- Membuat POINTER ke sebuah point_t
  p_ptr[0] = p1 -- Menetapkan nilai p1 ke lokasi yang ditunjuk oleh pointer

  -- Mengakses melalui pointer
  print("Mengakses x melalui pointer:", p_ptr.x) -- Sama dengan p_ptr[0].x

  -- 4. Casting
  local void_ptr = ffi.cast("void*", p_ptr)
  local original_ptr = ffi.cast("point_t*", void_ptr)
  print("Pointer berhasil di-cast kembali:", original_ptr.x == p1.x) -- Output: true
  ```

---

### **8.4 Manajemen Memori dan Finalisasi FFI**

- **GC Otomatis**: Memori yang dialokasikan oleh `ffi.new("ctype")` (di mana `ctype` bukan _pointer_) **dikelola oleh _garbage collector_ LuaJIT**. Ketika objek `cdata` tidak lagi direferensikan di Lua, memorinya akan dibebaskan. Ini adalah keuntungan besar.

- **_Finalizers_ dengan `ffi.metatype`**: Bagaimana jika _struct_ C Anda berisi _pointer_ ke memori yang dialokasikan secara manual yang perlu di-`free()`? Anda tidak bisa meletakkan metode `__gc` pada objek `cdata` secara langsung. Sebaliknya, Anda menggunakan `ffi.metatype()` untuk mengasosiasikan sebuah metatable (dengan metode `__gc`) dengan sebuah tipe C.

- **Contoh Finalizer**:

  ```lua
  local ffi = require("ffi")
  ffi.cdef[[
      typedef struct {
          char *name;
          int value;
      } my_object_t;

      void free(void *ptr); // dari pustaka standar C
  ]]

  -- Buat sebuah metatable untuk tipe C kita
  local my_object_metatable = {
      -- Finalizer __gc akan dipanggil saat my_object_t di-garbage collect
      __gc = function(cdata_obj)
          print("GC dipanggil untuk my_object_t, membebaskan nama:", ffi.string(cdata_obj.name))
          -- Kita harus membebaskan memori yang dikelola secara manual di dalam struct
          if cdata_obj.name ~= nil then
              ffi.C.free(cdata_obj.name)
          end
      end
  }

  -- Asosiasikan metatable dengan tipe C
  local my_object_t = ffi.metatype("my_object_t", my_object_metatable)

  -- Sebuah fungsi untuk membuat objek kita dengan benar
  function create_my_object(name, value)
      -- Alokasikan memori secara manual untuk string C
      local c_name = ffi.new("char[?]", #name + 1, name)
      -- Buat objek menggunakan konstruktor metatype khusus kita
      local obj = my_object_t({ name = c_name, value = value })
      return obj
  end

  local obj = create_my_object("TestObject", 100)
  obj = nil -- Hapus referensi terakhir

  collectgarbage() -- Paksa GC berjalan untuk demonstrasi
  -- Output di konsol akan menunjukkan: "GC dipanggil untuk my_object_t, membebaskan nama: TestObject"
  ```

  - **Penjelasan**:
    1.  Kita mendefinisikan sebuah _struct_ C yang berisi `char*`, yang akan kita kelola secara manual.
    2.  Kita membuat tabel Lua `my_object_metatable` dengan metode `__gc`. Metode ini tahu cara membersihkan _struct_ kita (dengan memanggil `ffi.C.free` pada _field_ `name`).
    3.  `ffi.metatype("my_object_t", ...)` menautkan tipe C kita ke metatable kita. Ini mengembalikan sebuah **konstruktor** untuk tipe C "yang disempurnakan" ini.
    4.  Ketika kita memanggil konstruktor ini `my_object_t(...)`, ia membuat objek `cdata` yang sekarang terikat pada _finalizer_ `__gc` kita.

#

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
[1]: ../README.md#8-ffi-dan-native-data-types
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
