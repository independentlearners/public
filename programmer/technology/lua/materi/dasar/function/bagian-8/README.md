# **[Bagian 8: Advanced Function Techniques][0]**

Bagian ini adalah puncak dari perjalanan kita dalam memahami function. Kita akan menggabungkan semua yang telah dipelajari—closures, higher-order functions, metatables—untuk menciptakan pola-pola yang sangat kuat, dinamis, dan fleksibel.

**Daftar Isi Bagian 8:**

- [Komposisi dan Perantaian Function](#81-komposisi-dan-perantaian-function)
- [Generasi Function Dinamis dan Metaprogramming](#82-generasi-function-dinamis-dan-metaprogramming)
- [Introspeksi Function](#83-introspeksi-function)

---

### 8.1 Komposisi dan Perantaian Function

Teknik-teknik ini berakar pada gaya pemrograman fungsional, yang menekankan penggunaan function sebagai blok bangunan utama.

#### **Composing Functions (Komposisi Function)**

Komposisi adalah tindakan menggabungkan dua atau lebih function untuk menghasilkan function baru. Output dari satu function menjadi input untuk function berikutnya, menciptakan sebuah alur proses.

- **Contoh Kode:**

  ```lua
  -- HOF untuk melakukan komposisi
  local function compose(f, g)
      return function(...)
          return f(g(...))
      end
  end

  local function trim(s) -- Menghapus spasi di awal/akhir
      return s:match("^%s*(.-)%s*$")
  end

  local function toUpper(s) -- Mengubah ke huruf besar
      return s:upper()
  end

  -- Membuat function baru dari komposisi trim dan toUpper
  local normalize = compose(toUpper, trim)

  print("'" .. normalize("   halo dunia!   ") .. "'")
  -- Output: 'HALO DUNIA!'
  ```

  Komposisi adalah cara yang elegan untuk membangun fungsionalitas kompleks dari bagian-bagian yang lebih kecil dan dapat digunakan kembali.

#### **Method Chaining (Perantaian Method)**

Ini adalah pola di mana pemanggilan beberapa method pada sebuah objek dapat dirangkai dalam satu pernyataan. Ini dimungkinkan dengan membuat setiap method dalam rantai mengembalikan objek itu sendiri (`self`).

- **Contoh Kode:**

  ```lua
  local Vector = {}
  Vector.__index = Vector

  function Vector.new(x, y)
      return setmetatable({x = x, y = y}, Vector)
  end

  function Vector:add(other)
      self.x = self.x + other.x
      self.y = self.y + other.y
      return self -- Kunci dari method chaining!
  end

  function Vector:scale(factor)
      self.x = self.x * factor
      self.y = self.y * factor
      return self -- Kembalikan 'self' lagi
  end

  function Vector:__tostring()
      return string.format("Vector(%.2f, %.2f)", self.x, self.y)
  end

  local v1 = Vector.new(1, 2)
  local v2 = Vector.new(3, 4)

  -- Melakukan perantaian method
  local result = v1:add(v2):scale(2)

  print(result) -- Output: Vector(8.00, 12.00)
  ```

#### **Pipeline Patterns**

Mirip dengan komposisi, pipeline pattern menerapkan serangkaian transformasi pada sebuah nilai. Ini sering dianggap lebih mudah dibaca karena alurnya dari kiri ke kanan, meniru operator `|` di shell Unix.

- **Contoh Kode:**

  ```lua
  local function pipe(value, ...)
      local funcs = {...}
      local result = value
      for i = 1, #funcs do
          result = funcs[i](result)
      end
      return result
  end

  local input = "   contoh pipeline   "

  local output = pipe(input,
      trim,       -- Langkah 1
      toUpper,    -- Langkah 2
      function(s) return s .. "!" end -- Langkah 3
  )

  print("'" .. output .. "'") -- Output: 'CONTOH PIPELINE!'
  ```

---

### 8.2 Generasi Function Dinamis dan Metaprogramming 

Metaprogramming adalah ide tentang "kode yang menulis kode". Lua sangat cocok untuk ini berkat sifat dinamisnya dan function `load`.

#### **Creating Functions at Runtime (`load`)**

Function `load` (sebelumnya dikenal sebagai `loadstring`) adalah inti dari metaprogramming di Lua.

- `load(chunk, chunkname, mode, env)`: Menerima sepotong kode Lua dalam bentuk string (`chunk`) dan mencoba mengkompilasinya menjadi sebuah function.

- Jika kompilasi berhasil, ia mengembalikan function yang telah dikompilasi.

- Jika gagal, ia mengembalikan `nil` dan pesan error.

- Function yang dihasilkan ini kemudian dapat dieksekusi seperti function lainnya.

- **Contoh Kode:**

  ```lua
  local codeString = "return function(a, b) return a + b end"

  -- Mengkompilasi string menjadi sebuah 'pabrik' function
  local factory, err = load(codeString)
  if not factory then
      error(err)
  end

  -- 'factory()' akan mengeksekusi kode dan mengembalikan function penambah
  local penambah = factory()

  print(penambah(10, 20)) -- Output: 30
  ```

#### **Code Generation dan Template Functions**

Dengan `load`, Anda bisa membuat template engine sederhana. Anda membuat string dengan placeholder, mengganti placeholder dengan nilai, lalu mengkompilasi string yang dihasilkan menjadi function.

- **Contoh Kode:**

  ```lua
  function createTemplate(templateString)
      -- Mengganti placeholder {{nama}} dengan kode Lua
      local code = "return '" .. templateString:gsub("{{(.-)}}", "' .. tostring(%1) .. '") .. "'"
      local func, err = load(code, "template", "t", {tostring=tostring})
      if not func then error(err) end
      return func
  end

  local template = createTemplate("Halo, {{nama}}! Selamat datang di {{kota}}.")

  local data = { nama = "Andi", kota = "Jakarta" }
  -- Mengekstrak data menjadi environment yang bisa diakses oleh template
  local env = setmetatable(data, {__index = _G})

  -- Menjalankan template dengan data
  local hasil = template()
  -- `load` dengan environment belum dijalankan.
  -- Cara yang lebih sederhana adalah dengan `load` lalu `pcall` dengan environment
  -- atau dengan cara di atas. Mari kita sederhanakan.

  -- Pendekatan yang lebih umum:
  function runTemplate(templateString, data)
      local code = "return '" .. templateString:gsub("{{(.-)}}", "' .. tostring(data.%1) .. '") .. "'"
      local func, err = load(code)
      if not func then error(err) end
      setfenv(func, {data = data, tostring = tostring}) -- setfenv untuk Lua 5.1
      return func()
  end

  -- Di Lua 5.2+ _ENV lebih umum
  -- Mari kita gunakan cara yang lebih modern
  function runTemplateModern(templateString, data)
      local code = "return function(data) return '" .. templateString:gsub("{{(.-)}}", "' .. tostring(data.%1) .. '") .. "' end"
      local factory, err = load(code)
      if not factory then error(err) end
      local templateFunc = factory()
      return templateFunc(data)
  end


  print(runTemplateModern("Halo, {{nama}}! Selamat datang di {{kota}}.", {nama="Budi", kota="Bandung"}))
  -- Output: Halo, Budi! Selamat datang di Bandung.
  ```

#### **AST Manipulation dan Macro Systems**

Ini adalah bentuk metaprogramming yang paling canggih, seringkali bersifat eksperimental di Lua.

- **AST (Abstract Syntax Tree):** Adalah representasi terstruktur dari kode sumber. Daripada bekerja dengan string, Anda bekerja dengan "objek" yang merepresentasikan function, variabel, loop, dll.
- **Proses:** Parse kode Lua -\> AST -\> Transformasi AST -\> Hasilkan kode Lua baru dari AST yang diubah.
- **Macros:** Teknik ini memungkinkan pembuatan _macro_, yaitu kode yang berjalan pada saat kompilasi untuk mengubah kode lain. Meskipun tidak ada sistem makro bawaan seperti di bahasa Lisp, komunitas telah membuat berbagai library untuk mensimulasikannya. Ini memungkinkan hal-hal seperti penambahan sintaks baru ke bahasa atau optimasi otomatis.

---

### 8.3 Introspeksi Function

Introspeksi adalah kemampuan sebuah program untuk memeriksa dirinya sendiri saat runtime. Lua menyediakan `debug library` untuk melakukan introspeksi pada eksekusi kode, terutama pada function dan call stack.

#### **Debug Library dan `debug.getinfo`**

Function utama untuk introspeksi adalah `debug.getinfo`.

- `debug.getinfo(func_or_level, what_string)`: Mengambil informasi tentang sebuah function atau sebuah pemanggilan di call stack.

- `func_or_level`: Bisa berupa function object, atau angka yang merepresentasikan level di stack (1 adalah function yang sedang berjalan, 2 adalah yang memanggilnya, dst.).

- `what_string`: Sebuah string yang menentukan informasi apa yang ingin Anda ambil. Contoh:

  - `S`: informasi sumber (`source`, `linedefined`, dll.).
  - `n`: informasi nama (`name`, `namewhat`).
  - `l`: baris saat ini (`currentline`).
  - `u`: jumlah upvalue (`nups`) dan parameter (`nparams`).

- **Contoh Kode:**

  ```lua
  local function contohFungsi(param1)
      local upvalue_contoh = "upvalue"
      print("Baris ini dieksekusi")
  end

  local info = debug.getinfo(contohFungsi, "Snu")

  for k, v in pairs(info) do
      print(k, "-->", v)
  end
  -- Output (kurang lebih):
  -- source --> @(stdin)
  -- nparams --> 1
  -- linedefined --> 1
  -- what --> Lua
  -- short_src --> (stdin)
  -- namewhat -->
  -- name --> contohFungsi
  -- nups --> 0
  -- lastlinedefined --> 4
  ```

#### **Stack Traces (`debug.traceback`)**

Function `debug.traceback()` menghasilkan sebuah string yang berisi _call stack trace_ dari titik saat ia dipanggil. Ini sangat berguna untuk membuat pesan error yang informatif.

- **Contoh Kode:**

  ```lua
  function c() error("terjadi kesalahan di C") end
  function b() c() end
  function a() b() end

  -- xpcall adalah 'protected call' yang menerima error handler
  xpcall(a, function(err)
      print("Error terdeteksi: " .. tostring(err))
      print("--- STACK TRACE ---")
      print(debug.traceback())
      print("-------------------")
  end)
  ```

#### **Profiling Functions**

`debug library` memungkinkan pembuatan profiler sederhana dengan menggunakan _hooks_.

- **`debug.sethook(hook_func, mask)`**: Mengatur sebuah `hook_func` untuk dipanggil pada event-event tertentu (ditentukan oleh `mask`).
- **Masks:**
  - `"c"`: dipanggil saat function di-call.
  - `"r"`: dipanggil saat function me-return.
  - `"l"`: dipanggil pada setiap baris kode baru.
- **Proses Profiling:** Anda bisa mengatur hook untuk mencatat waktu (`os.clock()`) pada event 'call' dan 'return' untuk mengukur berapa lama setiap function berjalan. Meskipun ini sangat kuat, untuk profiling yang serius, biasanya lebih baik menggunakan library profiler yang sudah ada.

---

**Sumber Referensi untuk Bagian 8:**

1.  Lua-Users Wiki - [Functional Programming](http://lua-users.org/wiki/FunctionalProgramming)
2.  Lua-Users Wiki - [Function Composition in Lua](http://lua-users.org/wiki/FunctionComposition)
3.  Lua-Users Wiki - [Dynamic Code Generation](http://lua-users.org/wiki/DynamicCodeGeneration)
4.  Programming in Lua (1st Edition) - [8. Compilation, Execution, and Errors](https://www.lua.org/pil/8.html)
5.  Lua-Users Wiki - [Meta Programming](http://lua-users.org/wiki/MetaProgramming)
6.  mr.gy/blog - [Experimental Meta-Programming for Lua](https://mr.gy/blog/lua-meta-programming.html)
7.  Programming in Lua (1st Edition) - [23. The Debug Library](https://www.lua.org/pil/23.html)
8.  Lua 5.4 Reference Manual - [4.7 The Debug Library](https://www.lua.org/manual/5.4/manual.html#4.7)

---

Kita telah menyelesaikan Bagian 8 yang penuh dengan teknik-teknik canggih. Selanjutnya kita akan beralih ke **Bagian 9: Patterns dan Best Practices**, di mana kita akan melihat bagaimana menerapkan konsep-konsep ini dalam pola desain yang teruji dan praktik terbaik untuk penanganan error dan pengujian.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../bagian-7/README.md
[selanjutnya]: ../bagian-9/README.md

<!----------------------------------------------------->

[0]: ../../function/README.md#bagian-8-advanced-function-techniques
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
