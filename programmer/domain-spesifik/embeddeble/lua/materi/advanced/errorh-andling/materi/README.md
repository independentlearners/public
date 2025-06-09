### Daftar Isi Panduan Lengkap Error Handling di Lua

- [Bab 1: Dasar-Dasar Error Handling](#bab-1-dasar-dasar-error-handling)
- [Bab 2: Fungsi Error Dasar](#bab-2-fungsi-error-dasar)
- [Bab 3: Protected Calls - pcall()](#bab-3-protected-calls---pcall)
- [Bab 4: Extended Protected Calls - xpcall()](#bab-4-extended-protected-calls---xpcall)
- [Bab 5: Debug Library untuk Error Handling](#bab-5-debug-library-untuk-error-handling)
- [Bab 6: Error Patterns dan Best Practices](#bab-6-error-patterns-dan-best-practices)
- [Bab 7: Domain-Specific Error Handling](#bab-7-domain-specific-error-handling)
- [Bab 8: Metatable-Based Error Handling](#bab-8-metatable-based-error-handling)
- [Bab 9: Topik Lanjutan](#bab-9-topik-lanjutan)
- [Bab 10: Error Handling Libraries dan Frameworks](#bab-10-error-handling-libraries-dan-frameworks)
- [Bab 11: Error Handling Anti-patterns dan Pitfalls](#bab-11-error-handling-anti-patterns-dan-pitfalls)
- [Bab 12: Testing dan Quality Assurance](#bab-12-testing-dan-quality-assurance)
- [Bab 13: Optimisasi Performa](#bab-13-optimisasi-performa)
- [Daftar Referensi dan Sumber Daya](#daftar-referensi-dan-sumber-daya)

---

### Bab 1: Dasar-Dasar Error Handling

#### 1.1 Pengenalan Error Handling

- **Konsep Fundamental:** _Error handling_ (penanganan kesalahan) adalah proses dalam pemrograman untuk mengantisipasi, mendeteksi, dan merespons kesalahan (errors) yang terjadi saat program berjalan. Tujuannya adalah untuk mencegah program berhenti secara tiba-tiba (_crash_) dan memberikan cara yang lebih terkontrol untuk menangani masalah.
- **Pentingnya di Lua:** Lua sering digunakan sebagai bahasa skrip yang disematkan (_embedded_) dalam aplikasi yang lebih besar (misalnya game seperti Roblox atau software seperti Redis). Jika skrip Lua _crash_, ia bisa merusak seluruh aplikasi induk. _Error handling_ yang baik mengisolasi masalah di dalam skrip Lua, menjaga stabilitas aplikasi utama.
- **Error vs. Exception:**
  - **Error:** Di Lua, _error_ adalah kejadian yang mengganggu alur normal program. Biasanya ini adalah hasil dari operasi yang tidak valid, seperti mencoba menambahkan angka dengan teks. Saat _error_ terjadi, Lua akan mencari "penangan" (_handler_). Jika tidak ada, program akan berhenti dan menampilkan pesan _error_.
  - **Exception:** Konsep ini lebih formal di bahasa seperti Java, Python, atau Dart dengan `try...catch...finally`. Lua tidak memiliki sintaks `try-catch` bawaan, tetapi mensimulasikan fungsionalitas serupa menggunakan fungsi seperti `pcall` dan `xpcall`. Jadi, di Lua, kita "menangani error" alih-alih "menangkap pengecualian", meskipun tujuannya sama.

#### 1.2 Jenis-jenis Error dalam Lua

- **Syntax Errors (Kesalahan Sintaks):** Ini adalah kesalahan yang terjadi bahkan sebelum program dijalankan. Ini disebabkan oleh penulisan kode yang tidak sesuai dengan aturan tata bahasa Lua. Interpreter Lua akan menolak untuk menjalankan kode tersebut sama sekali.

  - **Contoh:** `local x = 10 function()` (lupa kata kunci `end`).
  - **Penanganan:** Ini tidak bisa ditangani saat runtime. Harus diperbaiki oleh programmer di kode sumber.

- **Runtime Errors (Kesalahan Saat Berjalan):** Ini adalah kesalahan yang terjadi saat program sedang dieksekusi. Ini biasanya disebabkan oleh data yang tidak valid atau kondisi tak terduga.

  - **Contoh:** `local result = 10 + "hello"` (mencoba menambahkan angka dan string).
  - **Penanganan:** Inilah fokus utama dari kurikulum ini. _Runtime errors_ dapat "ditangkap" dan ditangani menggunakan `pcall` atau `xpcall`.

- **Memory Errors dan Stack Overflow:**

  - **Memory Errors:** Terjadi ketika Lua kehabisan memori untuk dialokasikan, misalnya saat membuat tabel yang sangat besar dalam satu putaran.
  - **Stack Overflow:** "Stack" adalah area memori yang digunakan untuk menyimpan panggilan fungsi. Jika sebuah fungsi memanggil dirinya sendiri terus-menerus tanpa henti (rekursi tak terbatas), "tumpukan" ini akan penuh dan meluap (_overflow_).
  - **Contoh Stack Overflow:**
    ```lua
    function loop()
      return loop() -- Fungsi ini memanggil dirinya sendiri tanpa kondisi berhenti
    end
    loop() -- Akan menyebabkan error: "stack overflow"
    ```

- **Type Mismatch Errors:** Ini adalah jenis _runtime error_ yang paling umum, di mana sebuah operasi menerima tipe data yang salah.

  - **Contoh:** `print(table.concat({1, 2, 3}))` (Benar) vs `print(table.concat("hello"))` (Salah, argumen harus tabel).

### Bab 2: Fungsi Error Dasar

Bab ini membahas alat paling mendasar di Lua untuk secara eksplisit menghasilkan dan menangani _error_.

#### 2.1 Fungsi `error()`

Fungsi `error()` digunakan untuk sengaja menghentikan eksekusi dan memunculkan _error_ dengan pesan khusus.

- **Terminologi:**

  - **Throwing an error:** Istilah ini berarti "melemparkan" atau memunculkan sebuah _error_. `error()` adalah cara Lua untuk melakukan ini.

- **Sintaks Dasar:**

  ```lua
  error(message, level)
  ```

  - `message`: String atau objek apa pun yang akan menjadi pesan _error_.
  - `level`: Parameter opsional (angka) yang menentukan di mana lokasi _error_ dilaporkan. Akan dibahas di bawah.

- **Contoh Kode:**

  ```lua
  function withdraw(balance, amount)
    if balance < amount then
      -- Hentikan eksekusi dan berikan pesan error yang jelas
      error("Insufficient funds to withdraw " .. tostring(amount))
    end
    return balance - amount
  end

  withdraw(100, 200) -- Ini akan menghentikan skrip dan menampilkan pesan error.
  ```

- **Best Practices untuk Pesan Error:**

  - **Jelas dan Informatif:** Pesan harus menjelaskan _apa_ yang salah dan (jika mungkin) _mengapa_. "Insufficient funds" lebih baik daripada "Error 123".
  - **Sertakan Konteks:** Menyertakan nilai variabel yang menyebabkan masalah sangat membantu untuk _debugging_. Contoh di atas menyertakan `amount`.

#### 2.2 Fungsi `assert()`

Fungsi `assert()` adalah cara cepat untuk memeriksa apakah suatu kondisi benar (_true_). Jika kondisi salah (_false_ atau `nil`), `assert()` akan memunculkan _error_.

- **Sintaks Dasar:**

  ```lua
  assert(condition, message)
  ```

  - `condition`: Ekspresi yang dievaluasi. Jika hasilnya `false` atau `nil`, _error_ akan muncul.
  - `message`: Pesan _error_ opsional jika kondisi gagal. Jika tidak diberikan, pesannya adalah "assertion failed\!".

- **Contoh Kode:**

  ```lua
  function connectToDatabase(host)
    -- Pastikan parameter host diberikan. Jika tidak, program tidak boleh lanjut.
    assert(type(host) == "string", "Database host must be a string")
    print("Connecting to " .. host)
    -- ... logika koneksi
  end

  connectToDatabase("localhost") -- Berhasil
  connectToDatabase(nil)         -- Gagal dengan pesan: "Database host must be a string"
  ```

- **Kapan Menggunakan `assert()` vs `error()`:**

  - **Gunakan `assert()`** untuk memeriksa **kesalahan programmer** atau **kondisi yang seharusnya tidak pernah terjadi**. Ini adalah "penjaga" di awal fungsi untuk memastikan input valid atau keadaan internal konsisten. Ini menegaskan (_asserts_) bahwa suatu asumsi itu benar.
  - **Gunakan `error()`** untuk menangani **kesalahan runtime yang dapat diantisipasi** yang mungkin terjadi karena input pengguna atau sistem eksternal (misalnya, file tidak ditemukan, dana tidak cukup).

#### 2.3 Error Level Parameter

Parameter `level` pada fungsi `error()` sangat penting untuk _debugging_ karena ia memberitahu Lua di mana harus menunjuk jari saat _error_ terjadi.

- **Konsep:** "Call stack" (tumpukan panggilan) adalah daftar fungsi yang sedang aktif. Jika `A()` memanggil `B()`, dan `B()` memanggil `C()`, maka tumpukan panggilannya adalah `A -> B -> C`. Parameter `level` mengontrol seberapa jauh ke belakang dalam tumpukan ini _error_ dilaporkan.

  - **`level 1` (default):** Menunjuk ke lokasi di mana fungsi `error()` itu sendiri dipanggil. Ini yang paling umum digunakan.
  - **`level 2`:** Menunjuk ke lokasi di mana fungsi yang memanggil `error()` dipanggil. Berguna saat Anda membuat fungsi _helper_ untuk _error handling_.
  - **`level 0`:** Tidak menambahkan informasi lokasi apa pun.

- **Contoh Kode:**

  ```lua
  function reportError(message)
    -- Melempar error, tapi menyalahkan fungsi yang memanggil reportError
    error(message, 2)
  end

  function processData(data)
    if data == nil then
      -- Kita memanggil reportError, tapi error akan menunjuk ke baris ini
      reportError("Data cannot be nil")
    end
  end

  processData(nil)
  ```

  - **Outputnya akan terlihat seperti ini:** `.../my_script.lua:10: Data cannot be nil`. Baris ke-10 adalah tempat `processData` memanggil `reportError`, bukan baris di dalam `reportError` itu sendiri. Ini jauh lebih berguna untuk _debugging_.

### Bab 3: Protected Calls - `pcall()`

Inilah cara utama Lua untuk "menangkap" _runtime errors_ tanpa menghentikan program. `pcall` adalah singkatan dari _protected call_ (panggilan terproteksi).

#### 3.1 Konsep Protected Call

- **Konsep:** `pcall` mengeksekusi fungsi dalam "mode terproteksi". Jika _error_ terjadi di dalam fungsi tersebut, eksekusi tidak akan berhenti. Sebaliknya, `pcall` akan "menangkap" _error_ tersebut dan mengembalikannya sebagai hasil, memungkinkan program Anda untuk menanganinya dengan elegan.
- **Analogi:** Bayangkan Anda mengirim seorang penjinak bom (`fungsi`) untuk menjinakkan bom (`kode yang berisiko`). Anda (`program utama`) menunggu di luar zona aman. `pcall` adalah zona aman itu.
  - Jika penjinak bom berhasil, dia keluar dan melaporkan "sukses" beserta hasilnya.
  - Jika bom meledak, ledakannya tertahan di dalam zona aman. Penjinak bom tidak keluar, tetapi Anda menerima laporan "gagal" beserta pesan mengapa bom itu meledak. Program Anda tetap aman.

#### Representasi Visual Alur `pcall`

```mermaid
graph TD
    A[Mulai] --> B{Panggil pcall(fungsi, arg1, ...)}
    B --> C{Apakah error terjadi selama eksekusi 'fungsi'?};
    C -- Tidak --> D[status = true<br>hasil = nilai kembali dari 'fungsi'];
    C -- Ya --> E[status = false<br>hasil = pesan error];
    D --> F[Selesai];
    E --> F[Selesai];
```

- **Sintaks dan Return Values:**

  ```lua
  local status, result = pcall(func, arg1, arg2, ...)
  ```

  - `func`: Fungsi yang ingin Anda jalankan secara aman.
  - `arg1, arg2, ...`: Argumen untuk fungsi tersebut.
  - **Return Values:** `pcall` selalu mengembalikan dua nilai:
    1.  `status`: Boolean. `true` jika tidak ada _error_, `false` jika ada _error_.
    2.  `result`: Jika `status` adalah `true`, `result` berisi nilai-nilai yang dikembalikan oleh `func`. Jika `status` adalah `false`, `result` berisi pesan _error_.

- **Contoh Praktis (File Handling):**

  ```lua
  function readFile(path)
    local file = io.open(path, "r")
    if not file then
      -- Cara tradisional melempar error
      error("File not found: " .. path)
    end
    local content = file:read("*a")
    file:close()
    return content
  end

  -- Panggil fungsi readFile dalam mode terproteksi
  local status, content_or_error = pcall(readFile, "data_yang_tidak_ada.txt")

  if status then
    print("File content:")
    print(content_or_error)
  else
    print("Failed to read file.")
    -- content_or_error sekarang berisi pesan error, bukan konten file
    print("Error message: " .. content_or_error)
  end

  print("Program continues running...")
  ```

  Tanpa `pcall`, baris `pcall(...)` akan menghentikan seluruh skrip. Dengan `pcall`, program dapat melaporkan kegagalan dan melanjutkan eksekusi.

### Bab 4: Extended Protected Calls - `xpcall()`

`xpcall` (_extended protected call_) adalah versi `pcall` yang lebih kuat, memungkinkan Anda untuk menentukan "fungsi penangan error" (_error handler function_) kustom.

#### 4.1 Pengenalan `xpcall()`

- **Perbedaan `xpcall()` dengan `pcall()`:**

  - `pcall` hanya mengembalikan pesan _error_ dalam bentuk string.
  - `xpcall` memungkinkan Anda menjalankan fungsi lain saat _error_ terjadi. Fungsi ini bisa melakukan lebih dari sekadar mengembalikan string, seperti mencatat _error_ ke file, mengirim notifikasi, atau yang paling penting, mengumpulkan informasi _debugging_ tambahan (seperti _stack trace_).

- **Sintaks Dasar:**

  ```lua
  local status, result = xpcall(func, err_handler_func, arg1, arg2, ...)
  ```

  - `func`: Fungsi yang ingin dijalankan.
  - `err_handler_func`: Fungsi yang akan dipanggil HANYA JIKA `func` mengalami _error_. Pesan _error_ asli akan diteruskan sebagai argumen ke fungsi ini.

#### Representasi Visual Alur `xpcall`

```mermaid
graph TD
    A[Mulai] --> B{Panggil xpcall(fungsi, handler, ...)}
    B --> C{Error terjadi di 'fungsi'?};
    C -- Tidak --> D[status = true<br>hasil = return value dari 'fungsi'];
    C -- Ya --> E{Panggil handler(pesan_error_asli)};
    E --> F[status = false<br>hasil = return value dari 'handler'];
    D --> G[Selesai];
    F --> G[Selesai];
```

#### 4.2 Custom Error Handlers

Ini adalah inti dari kekuatan `xpcall`.

- **Terminologi:**

  - **Stack Trace (atau Backtrace):** Daftar urutan panggilan fungsi yang membawa program ke titik _error_. Ini sangat berharga untuk melacak "jejak" bug. Contoh: `main -> process_user -> update_profile -> error_here`.

- **Contoh Kode dengan Stack Trace:**

  ```lua
  -- Ini adalah fungsi error handler kustom kita
  function myErrorHandler(errorMessage)
    -- Dapatkan stack trace untuk melihat dari mana error berasal
    local traceback = debug.traceback()
    -- Kembalikan pesan error yang lebih kaya
    return "Error: " .. tostring(errorMessage) .. "\n" .. traceback
  end

  function causeError()
    -- Ini akan menyebabkan error karena nil + 10 tidak valid
    local a = nil
    return a + 10
  end

  -- Jalankan causeError dengan xpcall dan handler kustom kita
  local status, result = xpcall(causeError, myErrorHandler)

  if not status then
    print("An error occurred! Detailed report:")
    -- 'result' sekarang berisi string yang diformat oleh myErrorHandler
    print(result)
  end
  ```

  - **Outputnya akan jauh lebih informatif daripada `pcall`:**
    ```
    An error occurred! Detailed report:
    Error: ...attempt to perform arithmetic on a nil value
    stack traceback:
            ...:2: in function 'causeError'
            ...:12: in main chunk
    ```

- **Kapan Menggunakan `xpcall()`:** Gunakan `xpcall` saat Anda membutuhkan lebih dari sekadar pesan _error_. Ini sangat ideal untuk:

  - Lingkungan produksi di mana Anda ingin mencatat (_log_) detail _error_ selengkap mungkin ke file atau layanan monitoring.
  - Membuat _framework_ atau pustaka yang kuat yang memberikan informasi _debugging_ yang kaya kepada penggunanya.

### Bab 5: Debug Library untuk Error Handling

Pustaka `debug` di Lua adalah alat yang sangat kuat untuk introspeksi (melihat ke dalam) status program. Dalam konteks _error handling_, fungsi utamanya adalah `debug.traceback`.

#### 5.1 Debug Library Basics

- **`debug.traceback()`:** Fungsi ini menghasilkan string yang berisi _stack trace_ dari titik di mana ia dipanggil. Seperti yang kita lihat di contoh `xpcall`, ini adalah cara standar untuk mendapatkan konteks panggilan saat _error_ terjadi.

- **Contoh Penggunaan Langsung:**

  ```lua
  function level3()
    print("Generating traceback from here:")
    print(debug.traceback())
  end

  function level2()
    level3()
  end

  function level1()
    level2()
  end

  level1()
  ```

- **Variable Inspection:** Pustaka `debug` juga memungkinkan Anda untuk memeriksa variabel lokal dan _upvalues_ di berbagai level tumpukan, tetapi ini adalah teknik yang sangat canggih dan biasanya hanya digunakan untuk membangun _debugger_ khusus, bukan untuk _error handling_ sehari-hari.

### Bab 6: Error Patterns dan Best Practices

Menguasai alat adalah satu hal; menggunakannya dengan bijak adalah hal lain.

#### 6.1 Common Error Patterns

- **Error Handling dalam Modul:** Sebuah modul (file Lua yang di-`require`) tidak boleh menghentikan seluruh aplikasi. Modul yang baik akan menangani _error_ internalnya atau, jika perlu, mengembalikan `nil` dan pesan _error_ sebagai indikasi kegagalan.

  ```lua
  -- my_module.lua
  local M = {}

  function M.doSomethingRisky()
    -- ... kode yang mungkin gagal
    return "Success"
  end

  -- Bungkus pemanggilan dalam pcall untuk memastikan modul tidak crash
  local status, result = pcall(M.doSomethingRisky)

  if not status then
    -- Jika gagal, jangan lempar error, kembalikan indikasi kegagalan
    return nil, result
  end

  return M
  ```

- **API Error Responses:** Saat membuat API (baik itu API web atau API untuk pustaka), tetapkan konvensi pengembalian yang konsisten untuk _error_. Pola yang umum adalah mengembalikan `nil` diikuti dengan pesan _error_.

  ```lua
  -- Penggunaan
  local my_module, err = require("my_module")
  if not my_module then
    print("Failed to load module:", err)
  end
  ```

#### 6.2 Error Message Design

- **User-friendly vs. Developer-friendly:**

  - **Developer-friendly:** Berisi detail teknis, nama fungsi, nomor baris, _stack trace_. Tujuannya adalah untuk _debugging_. `xpcall` dengan `debug.traceback` menghasilkan ini.
  - **User-friendly:** Sederhana, tidak teknis, dan jika mungkin, memberikan saran. Pesan ini harus ditampilkan kepada pengguna akhir.
  - **Praktik Terbaik:** Tangkap _error_ yang _developer-friendly_, catat detailnya, lalu tampilkan pesan yang _user-friendly_ kepada pengguna.

  <!-- end list -->

  ```lua
  local status, err_msg = xpcall(doSomething, myErrorHandler)
  if not status then
    -- Log detail error untuk developer
    logToServer(err_msg)

    -- Tampilkan pesan sederhana ke pengguna
    showUIMessage("Oops! Something went wrong. Please try again later.")
  end
  ```

### Bab 7: Domain-Specific Error Handling

Cara Anda menangani _error_ sangat bergantung pada di mana kode Anda dijalankan.

- **Game Development (contoh: Roblox):**

  - **Terminologi:** **Luau** adalah dialek Lua yang sedikit dimodifikasi dan dioptimalkan yang digunakan oleh Roblox.
  - _Error_ tidak boleh membuat game _crash_. `pcall` dan `xpcall` sangat penting untuk membungkus logika game, terutama yang berinteraksi dengan input pemain atau jaringan.
  - _Error_ pada satu pemain tidak boleh memengaruhi pemain lain di server.
  - **Contoh:** Jika skrip untuk efek visual gagal, lebih baik efek itu tidak muncul daripada seluruh permainan berhenti untuk semua orang.

- **Web Development:**

  - _Error handling_ sering kali terikat dengan **kode status HTTP**.
  - _Error_ pada _backend_ Lua (misalnya, menggunakan framework seperti OpenResty) harus ditangkap.
  - _Error_ karena input yang buruk dari pengguna harus menghasilkan respons `400 Bad Request`.
  - _Error_ karena masalah server (misalnya, tidak bisa terhubung ke database) harus menghasilkan `500 Internal Server Error`.
  - Penting untuk tidak pernah membocorkan detail _error_ internal (seperti _stack trace_) dalam respons HTTP publik karena alasan keamanan.

### Bab 8: Metatable-Based Error Handling

Ini adalah topik yang sangat canggih dan kuat yang memanfaatkan sistem "meta" Lua. Ini memungkinkan Anda membuat objek _error_ kustom, mirip dengan kelas _Exception_ di bahasa OOP seperti Dart.

- **Prasyarat: Apa itu Metatable?**
  - Di Lua, semua variabel non-primitif (selain angka, string, boolean, nil) adalah **tabel**.
  - **Metatable** adalah tabel khusus yang dapat dilampirkan ke tabel lain. Metatable ini mendefinisikan "perilaku" tabel utama ketika operasi tertentu yang tidak biasa dilakukan padanya.
  - **Analogi:** Bayangkan sebuah tabel biasa adalah sepotong kayu. Ia tidak bisa melakukan banyak hal. Metatable adalah cetak biru yang memberi tahu kayu itu bagaimana harus bereaksi: "jika seseorang mencoba memotongmu, gunakan gergaji"; "jika seseorang mencoba mengecatmu, gunakan kuas".
  - **Metamethod:** Kunci di dalam metatable (seperti `__index`, `__tostring`) disebut _metamethod_.

#### 8.1 Custom Error Objects dengan Metatables

Alih-alih hanya "melempar" string pesan _error_, kita bisa melempar tabel yang berisi lebih banyak informasi. Metatables membuatnya lebih elegan.

- **`__tostring` Metamethod:** Metamethod ini dipanggil setiap kali Lua mencoba mengubah tabel menjadi string (misalnya, saat menggunakan `print()` atau menggabungkannya dengan string lain).

- **Contoh Kode:**

  ```lua
  -- Definisikan "blueprint" untuk objek error kita
  local CustomError = {}
  CustomError.__index = CustomError

  -- Metamethod yang akan dipanggil saat kita mencoba print() error kita
  function CustomError:__tostring()
    return string.format("[%s]: %s", self.code, self.message)
  end

  -- Fungsi untuk membuat instance error baru
  function CustomError:new(code, message)
    local instance = {
      code = code,
      message = message,
      timestamp = os.time()
    }
    -- Lampirkan blueprint (metatable) ke instance baru kita
    setmetatable(instance, self)
    return instance
  end

  -- -- -- -- -- PENGGUNAAN -- -- -- -- --
  function doRiskyOperation()
    -- Lemparkan objek error kustom kita, bukan hanya string
    error(CustomError:new("NETWORK_FAILURE", "Could not connect to auth server."))
  end

  local status, err_obj = pcall(doRiskyOperation)

  if not status then
    -- 'err_obj' sekarang adalah tabel error kita
    print("A recoverable error occurred.")
    print("Details: " .. tostring(err_obj)) -- __tostring akan dipanggil di sini
    print("Error code was: " .. err_obj.code)
    print("Happened at: " .. err_obj.timestamp)
  end
  ```

#### 8.2 Error Inheritance dengan Metatables

Dengan menggunakan metatable `__index`, kita dapat membuat hirarki _error_, di mana _error_ yang lebih spesifik dapat "mewarisi" properti dari _error_ yang lebih umum. Ini sangat mirip dengan pewarisan kelas di OOP.

- **Representasi Visual Hirarki Error:**
  ```mermaid
  graph TD
      BaseError --> NetworkError;
      BaseError --> DatabaseError;
      NetworkError --> TimeoutError;
  ```
- **Contoh Kode:**

  ```lua
  -- (Menggunakan 'CustomError' dari contoh sebelumnya sebagai 'BaseError')

  -- Buat tipe error yang lebih spesifik
  local NetworkError = CustomError:new()
  NetworkError.category = "Network"

  function NetworkError:__tostring()
    -- Panggil __tostring dari parent dan tambahkan info
    local base_str = CustomError.__tostring(self)
    return string.format("%s (Category: %s)", base_str, self.category)
  end

  -- -- -- -- -- PENGGUNAAN -- -- -- -- --
  local net_err = NetworkError:new("TIMEOUT", "Connection timed out after 30s")
  print(net_err) -- Output: [TIMEOUT]: Connection timed out after 30s (Category: Network)

  -- Kita bisa memeriksa tipe error
  if getmetatable(net_err) == NetworkError then
    print("This is a network error.")
  end
  ```

Ini memungkinkan penanganan _error_ yang lebih canggih, di mana Anda dapat menangani semua `NetworkError` dengan cara yang sama, atau menangani `TimeoutError` secara spesifik.

### Bab 9: Topik Lanjutan

#### 9.1 C/C++ Integration Error Handling

- **Terminologi:**
  - **FFI (Foreign Function Interface):** Sebuah mekanisme yang memungkinkan kode yang ditulis dalam satu bahasa untuk memanggil fungsi yang ditulis dalam bahasa lain. LuaJIT memiliki pustaka FFI yang sangat baik.
  - **Lua C API:** Cara standar untuk Lua (yang ditulis dalam C) berinteraksi dengan kode C/C++ lainnya.
- **Tantangan:** C++ menggunakan `try...catch` untuk _exceptions_, sementara Lua menggunakan `pcall`/`error()`. Keduanya harus dijembatani.
- **Solusi Umum:** Ketika memanggil fungsi C++ dari Lua, kode "perekat" (C++) harus menangkap semua _exception_ C++ (`catch(...)`) dan mengubahnya menjadi _error_ Lua menggunakan `lua_error()`. Sebaliknya, saat memanggil fungsi Lua dari C++, panggilan harus dibungkus dalam `lua_pcall()` untuk menangkap _error_ Lua dan mengubahnya menjadi kode _error_ C++ atau _exception_.
- **Pustaka:** Pustaka seperti [**sol2**](https://github.com/ThePhD/sol2) sangat membantu karena secara otomatis menangani penjembatanan ini untuk Anda.

#### 9.2 Coroutine Error Handling

- **Terminologi:**

  - **Coroutine:** Mirip dengan _thread_, tetapi berjalan secara kooperatif, bukan paralel. Sebuah coroutine adalah fungsi yang dapat dihentikan sementara (`yield`) dan dilanjutkan (`resume`) nanti. Mereka seperti "bookmark" dalam eksekusi fungsi.

- **Tantangan:** _Error_ dalam sebuah coroutine tidak menyebar keluar secara otomatis. Ia hanya menghentikan coroutine itu sendiri.

- **Penanganan:** Fungsi `coroutine.resume()` mengembalikan status yang mirip dengan `pcall`.

  - `local success, result_or_error = coroutine.resume(co, ...)`
  - Jika `success` adalah `true`, coroutine berjalan tanpa masalah (atau di-_yield_).
  - Jika `success` adalah `false`, coroutine mengalami _runtime error_, dan `result_or_error` berisi pesan _error_.

- **Contoh Kode:**

  ```lua
  local co = coroutine.create(function()
    print("Coroutine running...")
    error("Something went wrong inside the coroutine!")
  end)

  local success, message = coroutine.resume(co)

  print("Coroutine finished.")
  if not success then
    print("The coroutine failed with message:", message)
  end
  print("Main program continues.")
  ```

#### 9.3 Module Loading Error Handling

- Fungsi `require()` di Lua digunakan untuk memuat modul. Jika modul yang diminta tidak dapat ditemukan atau jika ada _error_ sintaks di dalam modul tersebut, `require()` akan memunculkan _error_.

- **Penanganan:** Untuk membuat pemuatan modul lebih tangguh (misalnya, untuk memuat modul opsional atau memiliki sistem _fallback_), bungkus `require()` dalam `pcall`.

- **Contoh Kode:**

  ```lua
  -- Coba muat modul 'advanced_features' yang mungkin tidak ada
  local status, advanced_module = pcall(require, "advanced_features")

  if status then
    print("Advanced features loaded successfully.")
    advanced_module.enable()
  else
    print("Advanced features not available. Running in basic mode.")
    -- 'advanced_module' di sini berisi pesan error dari require
    print("Reason: " .. advanced_module)
  end
  ```

### Bab 10: Error Handling Libraries dan Frameworks

Meskipun alat bawaan Lua kuat, terkadang pengembang menginginkan sintaks yang lebih familiar.

- **Third-party Libraries:** Pustaka seperti [**lua-error**](https://github.com/dmccuskey/lua-error) menyediakan fungsionalitas seperti `try...catch...finally` yang mungkin lebih nyaman bagi mereka yang berasal dari bahasa lain. Pustaka ini hanyalah "pembungkus" di sekitar `pcall` dan `xpcall` untuk memberikan sintaks yang lebih baik.

- **Contoh dengan `lua-error` ( hipotetis ):**

  ```lua
  local error = require 'error'

  error.try(function()
    -- Kode yang mungkin gagal
    risky_function()
  end)
  :catch(function(err)
    -- Blok ini berjalan jika ada error
    print("Caught an error:", err)
  end)
  :finally(function()
    -- Blok ini selalu berjalan, baik ada error maupun tidak
    print("Cleaning up resources.")
  end)
  ```

- **Membangun Framework Sendiri:** Dalam proyek besar, Anda mungkin membangun _framework_ penanganan _error_ kustom Anda sendiri menggunakan `xpcall` dan metatables, yang terintegrasi dengan sistem _logging_ dan _monitoring_ Anda.

### Bab 11: Error Handling Anti-patterns dan Pitfalls

Ini adalah bab terpenting untuk beralih dari "tahu cara" menjadi "tahu cara yang benar".

- **Silent Failures (Kegagalan Senyap):** Ini adalah dosa terbesar dalam _error handling_. Ini terjadi ketika Anda menangkap _error_ tetapi tidak melakukan apa-apa dengannya.

  - **Anti-pattern:**
    ```lua
    local status, err = pcall(doSomething)
    if not status then
      -- Tidak ada log, tidak ada pesan, tidak ada apa-apa.
      -- Program terus berjalan seolah-olah tidak ada yang salah.
    end
    ```
  - **Bahaya:** Ini menciptakan bug yang sangat sulit dilacak. Anda tidak tahu mengapa program Anda berperilaku aneh karena _error_ yang menjadi akar masalahnya telah "ditelan".
  - **Solusi:** Selalu lakukan sesuatu dengan _error_ yang ditangkap: catat (_log_), tampilkan pesan, atau coba pulihkan.

- **Overuse of `pcall`:** Membungkus setiap baris kode dengan `pcall` adalah ide yang buruk.

  - **Bahaya:** Ini dapat menyembunyikan bug programmer (seperti salah ketik nama variabel) dan membuat kode sulit dibaca dan di-debug.
  - **Solusi:** Gunakan `pcall` secara strategis di "titik batas" (_boundaries_) di mana program Anda berinteraksi dengan dunia luar yang tidak dapat diprediksi: operasi file, panggilan jaringan, input pengguna, pemuatan modul.

- **Inadequate Error Context:** Menangkap _error_ tetapi membuang semua informasi berharga.

  - **Anti-pattern:** `print("Error occurred.")`
  - **Solusi:** Selalu sertakan pesan _error_ asli, dan jika mungkin, _stack trace_ (menggunakan `xpcall` atau `debug.traceback`).

- **Information Leakage (Kebocoran Informasi):** Menampilkan pesan _error_ _developer-friendly_ yang mentah kepada pengguna akhir.

  - **Bahaya Keamanan:** Pesan _error_ dapat membocorkan informasi sensitif tentang struktur internal aplikasi Anda, path file di server, atau query database, yang dapat dieksploitasi oleh penyerang.
  - **Solusi:** Tangkap _error_ detail, catat di tempat yang aman (log file), dan tampilkan pesan umum yang ramah pengguna.

### Bab 12: Testing dan Quality Assurance

- **Unit Testing untuk Error Conditions:** Kerangka kerja pengujian seperti [Busted](https://www.google.com/search?q=http://olivinelabs.com/busted/) memungkinkan Anda untuk secara sengaja menguji bahwa kode Anda menghasilkan _error_ saat seharusnya.

  ```lua
  -- contoh tes dengan busted
  describe("withdraw function", function()
    it("should error if funds are insufficient", function()
      -- assert.error menegaskan bahwa fungsi di dalamnya akan melempar error
      assert.error(function()
        withdraw(100, 200)
      end)
    end)
  end)
  ```

- **Production Error Monitoring:** Di lingkungan produksi, Anda harus menggunakan sistem terpusat untuk mengumpulkan dan menganalisis _error_. Layanan seperti Sentry, Datadog, atau sistem _logging_ kustom sangat penting untuk memahami kesehatan aplikasi Anda secara _real-time_.

### Bab 13: Optimisasi Performa

- **Cost of Protected Calls:** `pcall` dan `xpcall` tidak gratis. Mereka memiliki _overhead_ kinerja karena perlu menyiapkan lingkungan yang aman untuk menangani potensi _error_.

- **Kapan Harus Peduli:** Dalam 99% kasus, keterbacaan dan keamanan lebih penting daripada _overhead_ kecil ini. Namun, jika Anda memiliki "hot path" (bagian kode yang dijalankan ribuan kali per detik), Anda mungkin perlu menghindari `pcall` di dalam loop tersebut. Lakukan _profiling_ terlebih dahulu untuk memastikan ini benar-benar menjadi _bottleneck_.

- **Resource Cleanup:** Saat _error_ terjadi, pastikan sumber daya seperti _handle_ file atau koneksi jaringan ditutup dengan benar. Pola `try...finally` (yang bisa disimulasikan dengan `pcall`) sangat berguna di sini.

  ```lua
  local file = assert(io.open("mydata.txt", "r"))
  local status, result = pcall(function()
    -- Lakukan pekerjaan dengan file di sini
    return file:read("*a")
  end)

  -- Blok 'cleanup' ini akan selalu berjalan
  file:close()

  if not status then
    error(result) -- Lemparkan kembali error setelah cleanup
  end
  ```

---

### Daftar Referensi dan Sumber Daya

Berikut adalah daftar tautan yang berguna berdasarkan kurikulum dan penjelasan di atas:

- **Dokumentasi Resmi Lua:**
  - [Programming in Lua (PiL), Error Handling (pcall/xpcall)](https://www.lua.org/pil/8.4.html)
  - [Fungsi `error`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%23pdf-error%5D(https://www.lua.org/manual/5.4/manual.html%23pdf-error)>)
  - [Fungsi `assert`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%23pdf-assert%5D(https://www.lua.org/manual/5.4/manual.html%23pdf-assert)>)
  - [Pustaka `debug`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%236.10%5D(https://www.lua.org/manual/5.4/manual.html%236.10)>)
- **Pustaka Pihak Ketiga:**
  - [lua-error (try-catch syntax)](https://github.com/dmccuskey/lua-error)
  - [sol2 (C++ Integration)](https://github.com/ThePhD/sol2)
  - [Busted (Testing Framework)](https://www.google.com/search?q=http://olivinelabs.com/busted/)
- **Tutorial dan Panduan Tambahan:**
  - [Lua-Users Wiki: Metamethods Tutorial](http://lua-users.org/wiki/MetamethodsTutorial)
  - [Gamedev Academy: Lua Error Handling](https://gamedevacademy.org/lua-error-handling-tutorial-complete-guide/)

### Audit Akhir dan Kesimpulan

Panduan yang diperluas ini sekarang mencakup semua aspek yang diminta. Saya telah:

1.  **Menganalisis dan Menguraikan** setiap bab dari kurikulum asli.
2.  **Menambahkan Penjelasan Detail** untuk setiap konsep dan terminologi.
3.  **Menyediakan Contoh Kode Konkret** dengan komentar untuk setiap topik.
4.  **Membuat Representasi Visual** (diagram Mermaid) untuk alur `pcall`, `xpcall`, dan hirarki _error_.
5.  **Menjelaskan Konsep Prasyarat** seperti metatables dan coroutines dari dasar.
6.  **Memberikan Konteks** untuk audiens dengan latar belakang OOP.
7.  **Menyertakan Tautan Langsung** ke sumber daya yang relevan.
8.  **Menekankan Praktik Terbaik dan Anti-pattern** untuk penguasaan sejati.

Dengan materi ini, Anda memiliki fondasi yang sangat kuat untuk tidak hanya menggunakan tetapi benar-benar **menguasai** penanganan kesalahan di Lua, yang akan memungkinkan Anda membangun aplikasi yang tangguh, andal, dan mudah di-debug dalam domain apa pun. Langkah selanjutnya yang paling logis dan krusial untuk mencapai **penguasaan** adalah dengan menerapkan semua teori ini ke dalam praktik. Pengetahuan akan benar-benar melekat ketika Anda sendiri yang menulis kodenya, menghadapi _error_, dan menyelesaikannya.

Untuk "melanjutkan", disarankan kita masuk ke sesi **Praktik Terpandu**. Disini akan diberikan serangkaian skenario atau sebuah proyek mini, dan Anda akan mencoba menyelesaikannya menggunakan konsep yang telah kita pelajari. Ini akan membantu Anda membangun "ingatan otot" dalam pengkodean.

Mari kita mulai dengan sebuah proyek mini yang akan menyentuh banyak aspek dari kurikulum ini.

---

### **Proyek Mini: Pemuat Modul Konfigurasi yang Tangguh (Robust Config Loader)**

**Tujuan Proyek:**
Membuat sebuah modul Lua yang bertugas untuk memuat file konfigurasi berformat JSON. Modul ini harus sangat tangguh: tidak boleh _crash_, harus memberikan pesan _error_ yang sangat jelas, dan harus bisa menangani berbagai macam masalah seperti file tidak ada, format JSON tidak valid, atau isi konfigurasi yang tidak sesuai ekspektasi.

Proyek ini akan memaksa kita menggunakan:

- `pcall` untuk menangani _error_ saat membaca file dan mem-parsing JSON.
- `assert` untuk validasi internal.
- `xpcall` dan `debug.traceback` untuk _logging_ _error_ yang detail.
- Metatables untuk membuat objek _error_ kustom yang informatif.

**Prasyarat:**
Proyek ini membutuhkan pustaka untuk mem-parsing JSON. Kita akan menggunakan salah satu yang populer dan sederhana. Anda tidak perlu menginstalnya, anggap saja kita memanggil fungsi dari pustaka tersebut. Saya akan menyediakan kode "pura-pura"-nya.

---

### **Langkah 1: Struktur Dasar dan Penanganan File Tidak Ditemukan**

**Tugas:**
Buat sebuah modul bernama `ConfigLoader.lua`. Modul ini akan memiliki satu fungsi utama: `ConfigLoader.load(filepath)`. Fungsi ini harus bisa menangani kasus di mana file yang diberikan di `filepath` tidak ada.

**Konsep yang Digunakan:**

- Struktur modul dasar.
- `io.open` untuk membaca file.
- `pcall` untuk menangani _error_ yang mungkin terjadi.

**Mari kita mulai. Coba Anda tulis kode untuk `ConfigLoader.lua` yang memenuhi tugas di atas. Jika Anda bingung, beri tahu saya, dan saya akan memberikan petunjuk atau contoh kodenya.**

#

<!-- > - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]** -->

> - **[Ke Atas](#)**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../README.md

<!-- [sebelumnya]: ../../string/bagian-7/README.md
[selanjutnya]: ../bagian-2/README.md -->
