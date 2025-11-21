# **[Bagian 9: Patterns dan Best Practices][0]**

Setelah mempelajari berbagai teknik canggih, saatnya kita melihat bagaimana teknik-teknik tersebut dirangkai menjadi pola desain yang teruji dan praktik terbaik untuk membuat kode yang tangguh dan andal. Bagian ini berfokus pada penerapan praktis dari semua konsep function yang telah kita pelajari. Kita akan membahas pola-pola desain umum, cara menangani kesalahan dengan benar, dan bagaimana menguji function Anda untuk memastikan kualitasnya.

**Daftar Isi Bagian 9:**

- [Pola Function yang Umum (Common Function Patterns)](#91-pola-function-yang-umum-common-function-patterns)
- [Penanganan Error (Error Handling)](#92-penanganan-error-error-handling)
- [Pengujian Function (Testing Functions)](#93-pengujian-function-testing-functions)

---

### 9.1 Pola Function yang Umum (Common Function Patterns)

Pola desain adalah solusi umum yang dapat digunakan kembali untuk masalah yang sering terjadi dalam desain perangkat lunak. Di Lua, function (terutama closures dan HOF) adalah alat utama untuk mengimplementasikan banyak dari pola-pola ini.

#### **Factory Pattern**

Pola Factory menyediakan cara untuk membuat objek (atau dalam kasus Lua, seringkali table atau closure) tanpa mengekspos logika pembuatannya secara langsung kepada klien.

- **Implementasi dengan Function:** Sebuah function "pabrik" menerima parameter konfigurasi dan mengembalikan sebuah instans baru. Kita telah melihat ini berkali-kali. `buatAkunBank` dan `buatCounter` adalah contoh sempurna dari pola Factory.

#### **Builder Pattern**

Pola Builder digunakan untuk memisahkan konstruksi objek yang kompleks dari representasinya, sehingga proses konstruksi yang sama dapat menciptakan representasi yang berbeda.

- **Implementasi dengan Function:** Di Lua, ini sering diimplementasikan menggunakan _method chaining_, di mana setiap function "builder" memodifikasi objek dan mengembalikan `self` untuk memungkinkan pemanggilan berikutnya.

- **Contoh Kode:**

  ```lua
  local QueryBuilder = {}
  QueryBuilder.__index = QueryBuilder

  function QueryBuilder.new(table)
      local self = setmetatable({}, QueryBuilder)
      self.parts = { "SELECT * FROM " .. table }
      return self
  end

  function QueryBuilder:where(condition)
      table.insert(self.parts, "WHERE " .. condition)
      return self -- Mengembalikan self untuk chaining
  end

  function QueryBuilder:orderBy(field)
      table.insert(self.parts, "ORDER BY " .. field)
      return self -- Mengembalikan self untuk chaining
  end

  function QueryBuilder:build()
      return table.concat(self.parts, " ")
  end

  -- Menggunakan builder dengan method chaining
  local query = QueryBuilder.new("users")
                    :where("age > 18")
                    :orderBy("name")
                    :build()

  print(query) -- Output: SELECT * FROM users WHERE age > 18 ORDER BY name
  ```

#### **Observer Pattern**

Pola Observer mendefinisikan ketergantungan satu-ke-banyak antara objek sehingga ketika satu objek (Subject) mengubah keadaannya, semua dependennya (Observers) diberitahu dan diperbarui secara otomatis.

- **Implementasi dengan Function:** Para "observer" seringkali adalah function _callback_. Subject menyimpan daftar function callback ini. Ketika sebuah event terjadi, Subject akan mengiterasi daftarnya dan memanggil setiap function.

- **Contoh Kode:**

  ```lua
  function createSubject()
      local self = { observers = {} } -- Daftar observers (callbacks)

      function self:subscribe(func)
          table.insert(self.observers, func)
      end

      function self:notify(...)
          print("SUBJECT: Memberi tahu semua observers...")
          for _, observer_func in ipairs(self.observers) do
              observer_func(...) -- Memanggil setiap callback
          end
      end

      return self
  end

  local subject = createSubject()

  -- Observer 1
  subject:subscribe(function(msg) print("OBSERVER 1 menerima: " .. msg) end)
  -- Observer 2 adalah closure
  local id = "OBSERVER 2"
  subject:subscribe(function(msg) print(id .. " menerima: " .. msg) end)

  subject:notify("Event pertama terjadi!")
  ```

#### **Strategy Pattern**

Pola Strategy memungkinkan Anda mendefinisikan sebuah keluarga algoritma, menempatkan masing-masing ke dalam kelas (atau function) terpisah, dan membuat objeknya dapat dipertukarkan.

- **Implementasi dengan Function:** Daripada kelas, kita bisa menggunakan function untuk merepresentasikan setiap "strategi". Sebuah function konteks kemudian akan menerima function strategi ini sebagai argumen dan mengeksekusinya.

- **Contoh Kode:**

  ```lua
  -- Konteks yang akan menjalankan strategi
  function createUploader(data)
      return function(strategy) -- Menerima function strategi
          print("Mempersiapkan data untuk diunggah...")
          strategy(data)
      end
  end

  -- Strategi 1: Unggah via HTTP
  local function httpUploadStrategy(data)
      print("Mengunggah '" .. data .. "' via HTTP...")
  end

  -- Strategi 2: Unggah via FTP
  local function ftpUploadStrategy(data)
      print("Mengunggah '" .. data .. "' via FTP...")
  end

  local uploader = createUploader("file_penting.zip")

  -- Menjalankan dengan strategi yang berbeda
  uploader(httpUploadStrategy) -- Output: ... Mengunggah 'file_penting.zip' via HTTP...
  uploader(ftpUploadStrategy)  -- Output: ... Mengunggah 'file_penting.zip' via FTP...
  ```

---

### 9.2 Penanganan Error (Error Handling) 

Menangani kesalahan dengan benar sangat penting untuk membuat program yang stabil. Lua menyediakan beberapa mekanisme untuk ini.

#### **`pcall` dan `xpcall`**

- **`pcall` (Protected Call):** Mengeksekusi sebuah function dalam "mode terlindungi". Jika tidak ada error, `pcall` mengembalikan `true` diikuti oleh semua nilai kembalian dari function tersebut. Jika terjadi error, ia akan "menangkap" error tersebut, mengembalikan `false` diikuti oleh pesan error, dan program tidak akan berhenti.

  ```lua
  local function bisaGagal()
      -- return 10 / 0 -- Untuk mensimulasikan error
      return "Sukses!"
  end

  local sukses, hasilAtauError = pcall(bisaGagal)
  if sukses then
      print("Berhasil:", hasilAtauError)
  else
      print("Gagal:", hasilAtauError)
  end
  ```

- **`xpcall` (Extended Protected Call):** Mirip dengan `pcall`, tetapi menerima argumen kedua, yaitu _message handler_. Jika terjadi error, Lua akan memanggil message handler ini _sebelum_ stack-nya "terurai" (unwind). Message handler ini menerima pesan error asli dan dapat mengembalikan pesan error baru yang lebih informatif. Ini sangat berguna untuk menambahkan stack traceback ke laporan error.

  ```lua
  local function errorHandler(err)
      return "Terjadi error: " .. tostring(err) .. "\n" .. debug.traceback()
  end

  local function gagalLagi() error("sesuatu yang buruk terjadi") end

  local sukses, hasil = xpcall(gagalLagi, errorHandler)
  if not sukses then
      print(hasil) -- 'hasil' akan berisi string yang diformat oleh errorHandler
  end
  ```

#### **Custom Error Handling dan Exception-like Patterns**

Anda dapat menggunakan `error()` untuk "melempar" (`throw`) sebuah error dan `pcall` untuk "menangkapnya" (`catch`), meniru mekanisme `try-catch` di bahasa lain. Anda bahkan bisa melempar table sebagai objek error untuk membawa lebih banyak informasi.

---

### 9.3 Pengujian Function (Testing Functions) 

Pengujian adalah proses verifikasi bahwa kode Anda bekerja seperti yang diharapkan. _Unit testing_ berfokus pada pengujian unit-unit terkecil dari kode, yang seringkali adalah function individu.

#### **Unit Testing untuk Functions**

Struktur dasarnya adalah menyiapkan input, menjalankan function, dan memeriksa (`assert`) apakah outputnya sesuai dengan yang diharapkan.

- **`assert(condition, message)`:** adalah alat utama untuk pengujian di Lua. Ia akan memunculkan error jika `condition`-nya `false` atau `nil`.

- **Contoh Kode:**

  ```lua
  -- function yang akan diuji
  local function tambah(a, b) return a + b end

  -- Test case 1
  assert(tambah(2, 2) == 4, "Test case 2+2 gagal")
  -- Test case 2
  assert(tambah(-1, 1) == 0, "Test case -1+1 gagal")

  print("Semua test case untuk 'tambah' berhasil.")
  ```

#### **Mock Functions**

_Mocking_ adalah teknik membuat objek atau function tiruan yang meniru perilaku dependensi nyata. Ini digunakan untuk mengisolasi function yang sedang diuji dari sistem eksternal seperti database, jaringan, atau file system.

- **Contoh Kode:**

  ```lua
  -- function ini bergantung pada io.write
  function simpanPesan(pesan)
      io.write("Menyimpan: " .. pesan)
  end

  -- Test case dengan mock
  do
      local pesanTersimpan = nil
      local original_io_write = io.write
      -- Membuat mock untuk io.write
      io.write = function(s) pesanTersimpan = s end

      simpanPesan("tes123")
      assert(pesanTersimpan == "Menyimpan: tes123")

      -- Kembalikan function asli setelah tes selesai
      io.write = original_io_write
  end
  ```

#### **Testing Closures**

Karena state internal closure (upvalues) bersifat privat, Anda tidak bisa mengujinya secara langsung. Anda harus mengujinya melalui antarmuka publiknya, sama seperti pengguna biasa akan menggunakannya, dan memeriksa apakah perilakunya sesuai dengan yang diharapkan setelah serangkaian pemanggilan.

#### **Testing Frameworks**

Untuk proyek yang lebih besar, sangat disarankan untuk menggunakan framework pengujian seperti `busted` atau `Telescope`. Framework ini menyediakan struktur untuk mengatur tes, assertion library yang lebih kaya, test runner, dan fitur-fitur lainnya yang membuat pengujian menjadi lebih mudah dan terorganisir.

---

**Sumber Referensi untuk Bagian 9:**

1.  Lua-Users Wiki - Lua Design Patterns: [http://lua-users.org/wiki/LuaDesignPatterns](http://lua-users.org/wiki/LuaDesignPatterns)
2.  Lua-Users Wiki - Programming Patterns in Lua: [http://lua-users.org/wiki/ProgrammingPatterns](http://lua-users.org/wiki/ProgrammingPatterns)
3.  Programming in Lua (1st Edition) - 8.4 Error Handling and Exceptions: [https://www.lua.org/pil/8.4.html](https://www.lua.org/pil/8.4.html)
4.  Lua-Users Wiki - Error Handling Tutorial: [http://lua-users.org/wiki/ErrorHandling](http://lua-users.org/wiki/ErrorHandling)
5.  Lua-Users Wiki - Unit Testing: [http://lua-users.org/wiki/UnitTesting](http://lua-users.org/wiki/UnitTesting)
6.  Lua-Users Wiki - Testing Frameworks: [http://lua-users.org/wiki/TestingFrameworks](http://lua-users.org/wiki/TestingFrameworks)

---

Kita telah menyelesaikan Bagian 9. Sekarang Anda memiliki pemahaman yang baik tentang bagaimana menerapkan pengetahuan function Anda ke dalam pola-pola yang kuat dan praktik terbaik.

#

Kurikulum ini masih memiliki beberapa bagian yang sangat menarik, termasuk aplikasi dunia nyata, serialisasi function, iterator kustom, dan sandboxing. Kita akan melanjutkan ke **Bagian 10: Real-World Applications** untuk melihat bagaimana function digunakan dalam domain spesifik.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../bagian-8/README.md
[selanjutnya]: ../bagian-10/README.md

<!----------------------------------------------------->

[0]: ../../function/README.md#bagian-9-patterns-dan-best-practices
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
