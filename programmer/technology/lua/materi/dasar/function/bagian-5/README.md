# **[Bagian 5: Metatables dan Functions][0]**

Bagian ini akan menunjukkan bagaimana Anda dapat mengubah perilaku dasar dari nilai-nilai di Lua, khususnya membuat table berperilaku seperti function, dan bahkan memodifikasi perilaku dari function itu sendiri menggunakan `metatables`.

**Daftar Isi Bagian 5:**

- [`__call` Metamethod: Membuat Table Dapat Dipanggil](#__call-metamethod-membuat-table-dapat-dipanggil)
- [Function Metatables: Memodifikasi Perilaku Function](#function-metatables-memodifikasi-perilaku-function)

---

### `__call` Metamethod: Membuat Table Dapat Dipanggil

Secara default, hanya function (dan userdata tertentu) yang dapat "dipanggil" menggunakan operator `()`. Namun, dengan `metatables`, Anda dapat memberikan kemampuan ini pada table.

#### **Pengantar Singkat Metatables**

- **Metatable:** Adalah sebuah table Lua biasa yang berisi _metamethod_.
- **Metamethod:** Adalah field khusus di dalam metatable (dengan nama seperti `__add`, `__index`, `__tostring`) yang mendefinisikan bagaimana sebuah objek (misalnya table lain) harus berperilaku ketika mengalami operasi tertentu.
- **`setmetatable(table, metatable)`:** Function ini digunakan untuk mengaitkan sebuah `table` dengan `metatable`-nya.

#### **Membuat Tables Callable (`__call`)**

Metamethod `__call` memungkinkan Anda mendefinisikan sebuah aksi yang akan terjadi ketika Lua mencoba memanggil sebuah nilai seolah-olah itu adalah sebuah function.

- **Cara Kerja:**

  1.  Anda memiliki sebuah table, sebut saja `objek`.
  2.  Anda membuat metatable, sebut saja `mt`.
  3.  Anda mendefinisikan field `__call` di dalam `mt`. Nilai dari `mt.__call` haruslah sebuah function.
  4.  Anda mengaitkan `objek` dengan `mt` menggunakan `setmetatable(objek, mt)`.
  5.  Sekarang, ketika Anda mencoba memanggil `objek(...)`, Lua akan melihat bahwa `objek` bukanlah function, tetapi memiliki metatable dengan field `__call`. Lua kemudian akan mengeksekusi function yang ada di `mt.__call`.
  6.  Argumen pertama yang diterima oleh function `__call` adalah `objek` itu sendiri, diikuti oleh semua argumen lain yang Anda berikan dalam pemanggilan.

- **Contoh: Function-like Objects (Functors)**
  Mari kita buat sebuah "functor" yang merepresentasikan sebuah deret penambahan.

  ```lua
  -- 1. Buat 'objek' table. Ia menyimpan state.
  local Deret = { base = 10 }

  -- 2. Buat metatable
  local mt = {}

  -- 3. Definisikan metamethod __call
  -- Argumen pertama adalah table itu sendiri ('Deret' dalam kasus ini)
  function mt.__call(objekDeret, nilaiTambah)
      return objekDeret.base + nilaiTambah
  end

  -- 4. Kaitkan metatable dengan table
  setmetatable(Deret, mt)

  -- 5. Sekarang 'Deret' dapat dipanggil seperti function
  local hasil = Deret(5) -- Ini akan memicu mt.__call(Deret, 5)
  print("Hasil deret:", hasil) -- Output: Hasil deret: 15

  -- Kita bisa membuat 'pabrik' untuk objek seperti ini
  local function BuatDeret(baseValue)
      local t = { base = baseValue }
      setmetatable(t, mt) -- Menggunakan metatable yang sama
      return t
  end

  local deretSeratus = BuatDeret(100)
  print(deretSeratus(25)) -- Output: 125
  ```

  Dengan pola ini, Anda bisa membuat objek yang menyimpan state internal (`base`) tetapi juga memiliki satu "aksi utama" yang bisa dipanggil dengan mudah.

---

### Function Metatables: Memodifikasi Perilaku Function 
Yang lebih menarik lagi, function itu sendiri juga bisa memiliki metatable. Ini membuka pintu untuk teknik meta-pemrograman yang sangat canggih seperti _decorators_ tanpa mengubah kode asli dari function tersebut.

#### **Setting Metatables untuk Functions**

Sama seperti table, Anda menggunakan `setmetatable(nama_function, mt)`. Namun, sebagian besar metamethod (seperti `__index` atau `__add`) tidak berlaku untuk function. Satu-satunya yang sangat berguna dalam konteks ini adalah `__call`.

- **Bagaimana `__call` Bekerja pada Function:**
  Jika sebuah function `f` memiliki metatable dengan field `__call`, maka ketika Anda memanggil `f(...)`, **function asli `f` tidak langsung dieksekusi**. Sebaliknya, Lua akan mengeksekusi function yang ada di `metatable.__call`. Function asli `f` akan dilewatkan sebagai argumen pertama ke function `__call` tersebut, diikuti oleh argumen-argumen lainnya.

- **Contoh: Decorator Sederhana**
  Mari kita buat sebuah decorator yang "membungkus" function apapun untuk menghitung berapa kali ia telah dipanggil.

  ```lua
  local function BuatWrapperPenghitung()
      local hitungan = 0 -- Upvalue untuk menyimpan hitungan
      local mt = {}

      -- Metamethod __call yang akan dieksekusi
      function mt.__call(funcAsli, ...) -- funcAsli adalah function yang didekorasi
          hitungan = hitungan + 1
          print("Function ini telah dipanggil " .. hitungan .. " kali.")
          -- Panggil function asli dan kembalikan hasilnya
          return funcAsli(...)
      end
      return mt
  end

  -- Function asli kita
  local function sapa(nama)
      print("Halo, " .. nama .. "!")
  end

  -- Buat metatable-nya
  local metatableSapa = BuatWrapperPenghitung()

  -- Terapkan metatable ke function 'sapa'
  setmetatable(sapa, metatableSapa)

  -- Sekarang panggil 'sapa' seperti biasa
  sapa("Dunia")
  -- Output:
  -- Function ini telah dipanggil 1 kali.
  -- Halo, Dunia!

  sapa("Lua")
  -- Output:
  -- Function ini telah dipanggil 2 kali.
  -- Halo, Lua!
  ```

  Perhatikan bahwa kita tidak mengubah kode di dalam function `sapa` sama sekali. Perilakunya diubah dari luar.

#### **Function Introspection dan Modification**

Pola di atas adalah bentuk modifikasi function. Kita dapat menggunakannya untuk "mengintip" (introspect) argumen dan hasil, atau mengubah perilaku secara dinamis.

- **Contoh: Memoization Otomatis**
  Kita bisa membuat decorator yang secara otomatis menambahkan caching (memoization) ke function manapun yang perhitungannya mahal.

  ```lua
  local function denganMemoization(func)
      local cache = {} -- Cache disimpan sebagai upvalue
      local mt = {}

      function mt.__call(funcAsli, arg)
          -- Cek apakah hasil untuk argumen ini sudah ada di cache
          if cache[arg] then
              print("(Mengambil dari cache untuk arg: " .. arg .. ")")
              return cache[arg]
          else
              print("(Menghitung untuk arg: " .. arg .. ")")
              local hasil = funcAsli(arg) -- Panggil function asli
              cache[arg] = hasil -- Simpan hasil ke cache
              return hasil
          end
      end

      setmetatable(func, mt)
      return func
  end

  -- Function mahal yang ingin kita optimasi
  local function fibonacci(n)
      if n < 2 then return n end
      return fibonacci(n - 1) + fibonacci(n - 2)
  end

  -- Terapkan decorator memoization
  fibonacci = denganMemoization(fibonacci)

  print(fibonacci(8)) -- Akan menghitung semua langkah
  print("-------------------")
  print(fibonacci(8)) -- Akan langsung mengambil dari cache
  ```

#### **Debugging dengan Function Metatables**

Anda bisa menggunakan teknik ini untuk membuat wrapper debug yang mencatat setiap panggilan ke sebuah function, termasuk argumen dan nilai kembaliannya.
Meskipun ini adalah demonstrasi yang kuat dari kekuatan metatables, untuk debugging yang serius dan introspeksi yang mendalam (seperti mengakses informasi baris, variabel lokal, dll.), Lua menyediakan `debug library` yang merupakan alat yang lebih standar dan kuat.

---

**Sumber Referensi untuk Bagian 5:**

1.  Programming in Lua (4th Edition) - 13. Metatables and Metamethods: [https://www.lua.org/pil/13.html](https://www.lua.org/pil/13.html)
2.  Lua 5.4 Reference Manual - 2.4 Metatables and Metamethods: [https://www.lua.org/manual/5.4/manual.html\#2.4](https://www.lua.org/manual/5.4/manual.html#2.4)
3.  Lua-Users Wiki - Function Metatable: [http://lua-users.org/wiki/FunctionMetatable](http://lua-users.org/wiki/FunctionMetatable)
4.  Programming in Lua (4th Edition) - 23. The Debug Library: [https://www.lua.org/pil/23.html](https://www.lua.org/pil/23.html)

---

Kita telah menyelesaikan Bagian 5, yang menunjukkan bagaimana sistem meta Lua dapat bersinggungan dengan function untuk menciptakan perilaku yang dinamis dan tak terduga. Selanjutnya, kita akan beralih ke topik yang sama sekali berbeda namun sangat penting dalam banyak aplikasi Lua: **Bagian 6: Coroutines dan Functions**.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md

<!----------------------------------------------------->

[0]: ../../function/README.md#bagian-5-metatables-dan-functions
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
