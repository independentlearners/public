### **Daftar Isi**

- [Fase 1: Dasar-Dasar Pemrograman Lua (Minggu 1-3)](#fase-1-dasar-dasar-pemrograman-lua-minggu-1-3)
  - [1.1 Pengenalan Lua](#11-pengenalan-lua)
  - [1.2 Sintaks Dasar Lua](#12-sintaks-dasar-lua)
  - [1.3 Struktur Kontrol](#13-struktur-kontrol)
  - [1.4 Functions dan Scope](#14-functions-dan-scope)
- [Fase 2: Struktur Data dan Konsep Lanjutan (Minggu 4-6)](#fase-2-struktur-data-dan-konsep-lanjutan-minggu-4-6)
  - [2.1 Tables - Struktur Data Utama Lua](#21-tables---struktur-data-utama-lua)
  - [2.2 Object-Oriented Programming (OOP) dalam Lua](#22-object-oriented-programming-oop-dalam-lua)
  - [2.3 Coroutines dan Asynchronous Programming](#23-coroutines-dan-asynchronous-programming)
  - [2.4 Metaprogramming dan Advanced OOP](#24-metaprogramming-dan-advanced-oop)
  - [2.5 Error Handling dan Debugging](#25-error-handling)
  - [2.6 File I/O dan Data Persistence](#26-file-io-dan-data-persistence)
- [Fase 3: LuaJIT dan Performance Optimization (Minggu 7-9)](#fase-3-luajit-dan-performance-optimization-minggu-7-9)
  - [3.1 LuaJIT Fundamentals](#31-luajit-fundamentals)
  - [3.2 Foreign Function Interface (FFI)](#32-foreign-function-interface-ffi)
- [Fase 4: Pengenalan Game Engine - LÖVE 2D (Minggu 10-13)](#fase-4-pengenalan-game-engine---löve-2d-minggu-10-13)
  - [4.1 Setup dan Dasar LÖVE 2D](#41-setup-dan-dasar-löve-2d)
  - [4.2 Graphics dan Rendering](#42-graphics-dan-rendering)
- [Fase 5 & 6: Game Mechanics & Advanced Development](#fase-5--6-game-mechanics--advanced-development)
  - [5.2 Physics dan Collision Detection](#52-physics-dan-collision-detection)
  - [5.4 Entity-Component-System (ECS) Pattern](#54-entity-component-system-ecs-pattern)
  - [6.3 Networking dan Multiplayer](#63-networking-dan-multiplayer)
- [Fase 7, 8, & 9: Proyek, Industri, dan Spesialisasi](#fase-7-8--9-proyek-industri-dan-spesialisasi)
- [Rekomendasi Tambahan](#rekomendasi-tambahan)

---

## [Fase 1: Dasar-Dasar Pemrograman Lua (Minggu 1-3)][1]

Fase ini adalah fondasi Anda. Meskipun Anda memiliki pengalaman dengan Dart, penting untuk memahami kekhasan dan filosofi Lua yang membuatnya berbeda dan sangat efisien untuk _scripting_ dalam game.

### 1.1 Pengenalan Lua

- **Apa itu Lua dan Sejarahnya?**

  - **Deskripsi:** Lua adalah bahasa pemrograman tingkat tinggi yang bersifat _procedural_, _dynamically typed_, dan dirancang untuk menjadi bahasa _scripting_ yang ringan dan dapat disematkan (_embeddable_). Dibuat pada tahun 1993 di Brazil, namanya berarti "Bulan" dalam bahasa Portugis.
  - **Konteks Game Dev:** Dalam industri game, Lua tidak digunakan untuk membuat game engine dari nol (yang biasanya menggunakan C++), melainkan untuk menulis "logika" atau "perilaku" game di atas engine tersebut. Ini memungkinkan desainer game dan programmer untuk dengan cepat mengubah mekanik, AI, atau UI tanpa perlu mengkompilasi ulang seluruh engine, mempercepat proses iterasi secara drastis.
  - **Terminologi:**
    - **Dynamically Typed:** Anda tidak perlu mendeklarasikan tipe data sebuah variabel (seperti `int` atau `String` di Dart). Tipe data akan ditentukan secara otomatis saat program berjalan.
    - **Embeddable:** Kode Lua dapat dengan mudah diintegrasikan dan dipanggil dari dalam aplikasi yang ditulis dalam bahasa lain (umumnya C/C++).

- **Filosofi dan Keunggulan Lua:**

  - **Minimalis:** Lua memiliki inti yang sangat kecil dan sederhana. Fitur-fitur kompleks seperti _class_ atau _inheritance_ tidak ada secara bawaan, namun dapat "dibangun" menggunakan mekanisme dasar yang disediakan.
  - **Cepat:** Untuk sebuah bahasa _scripting_ yang diinterpretasi, Lua sangat cepat. Terlebih lagi dengan adanya LuaJIT (akan dibahas nanti).
  - **Portabel:** Ditulis dalam ANSI C, Lua dapat dijalankan di hampir semua platform.
  - **Struktur Data Tunggal:** Kekuatan utama Lua adalah `table`, satu-satunya struktur data bawaan yang dapat merepresentasikan _array_, _dictionary_ (atau _map_), _set_, dan bahkan _object_.

### 1.2 Sintaks Dasar Lua

Di bagian ini, kita akan melihat "daging" dari bahasa Lua itu sendiri.

- **Variabel dan Tipe Data:**

  - **Deskripsi:** Variabel adalah nama yang kita berikan untuk menyimpan nilai. Di Lua, variabel bersifat _case-sensitive_ (`nama` berbeda dengan `Nama`).
  - **Sintaks Deklarasi:**

    ```lua
    -- Deklarasi variabel lokal (best practice)
    local namaPemain = "Arcade"
    local skor = 0
    local isGameOver = false

    -- Variabel global (hindari jika tidak perlu)
    versiGame = 1.0

    -- Deklarasi ganda
    local x, y, z = 10, 20, 30
    ```

  - **Tipe Data Utama:**
    1.  **`nil`**: Merepresentasikan ketiadaan nilai. Variabel yang belum diinisialisasi akan memiliki nilai `nil`. Ini juga digunakan untuk menghapus variabel dari `table`.
    2.  **`boolean`**: `true` atau `false`. Di Lua, hanya `false` dan `nil` yang dianggap sebagai kondisi "salah"; angka 0 dan string kosong "" dianggap `true`.
    3.  **`number`**: Secara default merepresentasikan angka floating-point presisi ganda (seperti `double` di bahasa lain).
    4.  **`string`**: Kumpulan karakter. Bisa dibuat dengan kutip satu (`'...'`) atau kutip dua (`"..."`). String di Lua bersifat _immutable_ (tidak bisa diubah).
    5.  **`function`**: Fungsi adalah warga kelas satu di Lua, artinya bisa disimpan dalam variabel, dioperasikan, dan dijadikan argumen seperti tipe data lain.
    6.  **`table`**: Struktur data fundamental di Lua. Akan dibahas mendalam di Fase 2.
    7.  **`userdata`**: Tipe data khusus yang memungkinkan data C/C++ disimpan dalam variabel Lua. Digunakan untuk interaksi dengan engine.
    8.  **`thread`**: Merepresentasikan _coroutine_.

- **Operasi Matematika dan Logika:**

  - **Matematika:** `+` (tambah), `-` (kurang), `*` (kali), `/` (bagi), `%` (modulo/sisa bagi), `^` (pangkat).
  - **Logika:** `and`, `or`, `not`. Operator `and` dan `or` bersifat _short-circuit_.
    - `a and b`: Jika `a` adalah `false` atau `nil`, hasilnya `a`. Jika tidak, hasilnya `b`.
    - `a or b`: Jika `a` bukan `false` atau `nil`, hasilnya `a`. Jika tidak, hasilnya `b`.
  - **Relasional:** `==` (sama dengan), `~=` (tidak sama dengan), `<`, `>`, `<=`, `>=`.
  - **Contoh Kode:**

    ```lua
    local skor = 100
    skor = skor + 50 * 2 -- Hasil: 200

    local canEnter = (skor > 150) and (not isGameOver) -- Hasil: true

    -- Penggunaan 'or' untuk nilai default
    local nama = userInput or "Guest" -- Jika userInput nil, nama akan menjadi "Guest"
    ```

- **String Manipulation:**

  - **Konkatenasi (Penggabungan):** Menggunakan operator `..`
    ```lua
    local sapaan = "Halo, "
    local nama = "Dunia"
    local pesan = sapaan .. nama .. "!" -- Hasil: "Halo, Dunia!"
    ```
  - **Fungsi String:** Lua memiliki library `string` yang kuat.
    ```lua
    local teks = "Lua itu seru!"
    print(string.len(teks)) -- Panjang string: 13
    print(string.upper(teks)) -- LUA ITU SERU!
    print(string.sub(teks, 5, 7)) -- Mengambil substring: "itu"
    ```

### 1.3 Struktur Kontrol

Ini adalah cara kita mengendalikan alur eksekusi program.

- **Conditional Statements (if, elseif, else):**

  ```lua
  local suhu = 25
  if suhu > 30 then
      print("Panas!")
  elseif suhu > 20 and suhu <= 30 then
      print("Hangat.")
  else
      print("Dingin.")
  end -- Semua blok di Lua diakhiri dengan 'end'
  ```

- **Loops (for, while, repeat-until):**

  - **`for` loop (numerik):**
    ```lua
    -- Menghitung dari 1 sampai 5
    for i = 1, 5, 1 do -- format: start, end, step
        print("Iterasi ke-" .. i)
    end
    ```
  - **`while` loop:** Cek kondisi di awal.
    ```lua
    local nyawa = 3
    while nyawa > 0 do
        print("Nyawa tersisa: " .. nyawa)
        nyawa = nyawa - 1
    end
    ```
  - **`repeat-until` loop:** Cek kondisi di akhir (dijalankan minimal sekali).
    ```lua
    local input
    repeat
        print("Masukkan 'keluar' untuk berhenti:")
        input = io.read()
    until input == "keluar"
    ```

### 1.4 Functions dan Scope

- **Deklarasi dan Pemanggilan:**

  ```lua
  -- Cara 1
  local function sapa(nama)
      print("Halo, " .. nama)
  end

  -- Cara 2 (fungsi sebagai nilai)
  local sapa = function(nama)
      print("Halo, " .. nama)
  end

  sapa("Andi") -- Memanggil fungsi
  ```

- **Parameter dan Return Values:** Fungsi bisa mengembalikan beberapa nilai.

  ```lua
  local function getPosisi()
      return 100, 250 -- Mengembalikan dua nilai, x dan y
  end

  local pemainX, pemainY = getPosisi()
  print("Posisi pemain: x=" .. pemainX .. ", y=" .. pemainY)
  ```

- **Local vs Global Variables (SANGAT PENTING):**

  - **Terminologi:**
    - **`local`**: Variabel hanya ada di dalam blok (function, loop, if) tempat ia dideklarasikan. **Selalu gunakan `local` secara default.** Ini mencegah "polusi" _namespace global_, menghindari bug, dan seringkali lebih cepat karena diakses melalui register, bukan pencarian di _global table_.
    - **`global`**: Variabel dapat diakses dari mana saja di seluruh skrip. Ini bisa berbahaya karena bagian kode yang berbeda bisa saling menimpa nilai variabel tanpa disadari.

  <!-- end list -->

  ```lua
  local skor = 0 -- Variabel lokal

  function tambahSkor(nilai)
      -- 'skor' disini merujuk ke variabel lokal di luar
      skor = skor + nilai
  end

  tambahSkor(10)
  print(skor) -- Hasil: 10
  ```

---

## Fase 2: Struktur Data dan Konsep Lanjutan (Minggu 4-6)

Di fase ini, Anda akan belajar tentang `table`, jantung dari Lua, dan bagaimana menggunakannya untuk membangun konsep yang lebih kompleks seperti OOP.

### 2.1 Tables - Struktur Data Utama Lua

- **Deskripsi:** `table` adalah satu-satunya mekanisme struktur data di Lua. Ini adalah _associative array_ yang bisa diindeks dengan tipe data apa pun (kecuali `nil`).
- **Array-style Tables:** Menggunakan angka sebagai kunci (indeks dimulai dari 1).
  ```lua
  local senjata = {"pedang", "panah", "tombak"}
  print(senjata[1]) -- Hasil: pedang
  ```
- **Dictionary-style Tables:** Menggunakan string (atau tipe lain) sebagai kunci.
  ```lua
  local pemain = {
      nama = "Zelda",
      level = 5,
      hp = 100,
      isAlive = true
  }
  print(pemain.nama) -- Cara akses 1 (dot notation)
  print(pemain["level"]) -- Cara akses 2 (bracket notation)
  ```
- **Metatables dan Metamethods (KONSEP KUNCI):**

  - **Deskripsi:** Ini adalah mekanisme _metaprogramming_ paling kuat di Lua. _Metatable_ adalah `table` biasa yang Anda lampirkan ke `table` lain untuk mengubah perilakunya. Di dalam _metatable_, Anda mendefinisikan _metamethods_ (fungsi yang namanya diawali `__`) yang akan dipanggil ketika operasi tertentu dilakukan pada `table` asli.
  - **Contoh Paling Umum (`__index`):** Digunakan untuk meniru OOP (inheritance) dan menyediakan nilai default. `__index` dipanggil ketika Anda mencoba mengakses kunci yang tidak ada di dalam sebuah `table`.
  <!-- end list -->

  ```lua
  -- Bayangkan ini adalah 'blueprint' atau 'class'
  local Vector = { x = 0, y = 0 }
  Vector.__index = Vector -- Metamethod __index merujuk ke dirinya sendiri

  -- Fungsi untuk membuat 'instance' baru
  function Vector:new(o)
    o = o or {}
    setmetatable(o, self)
    return o
  end

  -- Membuat objek baru dari blueprint Vector
  local v1 = Vector:new{ x = 10, y = 20 }
  local v2 = Vector:new{ }

  print(v1.x) -- Hasil: 10 (ada di v1)
  print(v2.x) -- Hasil: 0 (tidak ada di v2, Lua mencari di metatable.__index, yaitu Vector)
  ```

### 2.2 Object-Oriented Programming (OOP) dalam Lua

- **Deskripsi:** Lua tidak memiliki konsep `class` seperti Dart. OOP di Lua disimulasikan menggunakan `tables` dan `metatables`. Contoh `Vector` di atas adalah fondasi dari OOP di Lua.
- **Inheritance Patterns:** Dapat dicapai dengan mengatur `metatable` anak untuk menunjuk ke `table` induk melalui `__index`.
- **Encapsulation:** Kurang ketat dibanding bahasa lain. Biasanya dilakukan dengan konvensi (misalnya, properti "privat" diawali dengan garis bawah `_namaProperti`) dan penggunaan _closures_ untuk menyembunyikan data.

### 2.3 Coroutines dan Asynchronous Programming

- **Konsep Dasar:** Berbeda dari _multi-threading_ biasa (pre-emptive), _coroutines_ di Lua bersifat _cooperative_. Artinya, sebuah _coroutine_ hanya akan "menyerah" (pause) jika ia secara eksplisit memintanya, memberikan kontrol kembali ke program utama. Ini sangat berguna untuk animasi, AI, atau urutan kejadian yang berlangsung selama beberapa _frame_ tanpa memblokir seluruh game.
- **Terminologi & Sintaks:**

  - `coroutine.create(f)`: Membuat _coroutine_ baru dari fungsi `f`.
  - `coroutine.resume(co, ...)`: Memulai atau melanjutkan eksekusi _coroutine_ `co`.
  - `coroutine.yield(...)`: Menjeda eksekusi _coroutine_ dan mengembalikan nilai ke pemanggil `resume`.
  <!-- end list -->

  ```lua
  local function fadeOut()
      for i = 1, 10 do
          print("Alpha: " .. (1 - i*0.1))
          coroutine.yield() -- Jeda, tunggu frame berikutnya
      end
      print("Fade out selesai!")
  end

  local co = coroutine.create(fadeOut)

  -- Di dalam game loop (misalnya di love.update):
  -- coroutine.resume(co) -- Panggil ini setiap frame
  ```

### 2.4 Metaprogramming dan Advanced OOP

- **Deskripsi:** _Metaprogramming_ adalah "kode yang menulis kode" atau memodifikasi perilaku dasar bahasa. Di Lua, ini hampir seluruhnya dilakukan melalui `metatables`. Anda bisa meng-override operator (`__add`, `__mul`), pemanggilan fungsi (`__call`), dan banyak lagi.

### 2.5 Error Handling

- **`pcall` (Protected Call):** Cara aman untuk memanggil fungsi yang mungkin gagal. Ia tidak akan menghentikan program, melainkan mengembalikan status sukses dan hasil atau pesan error.

  ```lua
  local status, hasil = pcall(function()
      -- kode yang mungkin error
      return 10 / 0
  end)

  if not status then
      print("Terjadi error: " .. hasil)
  else
      print("Sukses, hasilnya: " .. hasil)
  end
  ```

### 2.6 File I/O dan Data Persistence

- **Deskripsi:** Untuk menyimpan dan memuat data game, seperti skor tertinggi atau status permainan.
- **Sintaks Dasar:**

  ```lua
  -- Menulis ke file
  local file = io.open("savegame.txt", "w") -- 'w' untuk write
  file:write("level=5\n")
  file:write("skor=1000\n")
  file:close()

  -- Membaca dari file
  local file = io.open("savegame.txt", "r") -- 'r' untuk read
  for baris in file:lines() do
      print("Membaca: " .. baris)
  end
  file:close()
  ```

---

## Fase 3: LuaJIT dan Performance Optimization (Minggu 7-9)

### 3.1 LuaJIT Fundamentals

- **Deskripsi:** LuaJIT (Just-In-Time Compiler) adalah implementasi Lua alternatif yang sangat cepat. Ia menganalisis kode Lua Anda saat berjalan dan mengkompilasi bagian-bagian yang sering dieksekusi menjadi kode mesin asli, memberikan peningkatan performa yang dramatis. Banyak game engine modern (termasuk Defold) dan framework (seperti LÖVE di beberapa platform) menggunakannya.
- **LuaJIT vs Standard Lua:** LuaJIT umumnya jauh lebih cepat, terutama untuk loop dan operasi matematika berat. Namun, ia berbasis pada Lua 5.1, jadi beberapa fitur dari Lua 5.2+ mungkin tidak ada.

### 3.2 Foreign Function Interface (FFI)

- **Deskripsi:** Fitur andalan LuaJIT. FFI memungkinkan Anda memanggil fungsi dari library C (file `.dll`, `.so`, atau `.dylib`) langsung dari Lua tanpa perlu menulis kode "lem" C yang rumit (dikenal sebagai _bindings_). Ini sangat berguna untuk integrasi dengan library grafis, fisika, atau audio yang ditulis dalam C.
- **Contoh Konseptual:**

  ```lua
  -- (Ini hanya contoh konseptual, butuh library C yang sesuai)
  local ffi = require("ffi")

  -- Deklarasikan fungsi C yang ingin Anda panggil
  ffi.cdef[[
      // Dari header file C, misalnya 'math.h'
      double sin(double x);
      void msvcrt.system(const char *command);
  ]]

  -- Panggil fungsi C seperti fungsi Lua biasa
  local result = ffi.C.sin(1.57) -- Memanggil sin() dari library C
  print(result)

  ffi.C.system("echo Halo dari C!") -- Menjalankan command shell
  ```

- **Referensi:**
  - **LuaJIT Official Site:** [https://luajit.org/](https://luajit.org/)
  - **FFI Tutorial:** [https://luajit.org/ext_ffi_tutorial.html](https://luajit.org/ext_ffi_tutorial.html)

---

## Fase 4: Pengenalan Game Engine - LÖVE 2D (Minggu 10-13)

### 4.1 Setup dan Dasar LÖVE 2D

- **Deskripsi:** LÖVE bukanlah game engine dengan editor visual seperti Unity atau Godot. Ia adalah _framework_. Anda menulis kode Lua dalam file `main.lua`, dan LÖVE menyediakan API (kumpulan fungsi) untuk grafis, audio, input, fisika, dll. Ini memberikan kebebasan penuh namun juga tanggung jawab lebih besar pada programmer.

- **Visualisasi Konsep:**

  ```
  +--------------------------------+
  |         ANDA MENULIS INI         |
  |                                |
  |   +------------------------+   |
  |   |      main.lua          |   |
  |   | (Logika Game Anda)     |   |
  |   +------------------------+   |
  +--------------------------------+
                |
                v
  +--------------------------------+
  |         LÖVE MENYEDIAKAN INI     |
  |                                |
  |   +------------------------+   |
  |   | love.graphics          |   |
  |   | love.audio             |   |
  |   | love.keyboard          |   |
  |   | ...etc                 |   |
  |   +------------------------+   |
  +--------------------------------+
  ```

- **Callback Functions Utama:**

  - `love.load()`: Dijalankan sekali saat game dimulai. Tempat untuk memuat aset (gambar, suara) dan menginisialisasi variabel.
  - `love.update(dt)`: Dijalankan setiap frame. Tempat untuk semua logika game (gerakan, AI, cek kondisi). `dt` (delta time) adalah waktu sejak frame terakhir, penting untuk gerakan yang konsisten di berbagai kecepatan komputer.
  - `love.draw()`: Dijalankan setiap frame setelah `update`. Tempat untuk semua kode menggambar. Jangan pernah menaruh logika game di sini.

- **Struktur Proyek Sederhana:**

  ```
  mygame/
  ├── main.lua
  └── player.png
  ```

  Untuk menjalankan, cukup seret folder `mygame` ke file `love.exe`.

- **Referensi:**

  - **LÖVE Official Website:** [https://love2d.org/](https://love2d.org/)
  - **LÖVE Wiki (Dokumentasi Utama):** [https://love2d.org/wiki/Main_Page](https://love2d.org/wiki/Main_Page)

### 4.2 Graphics dan Rendering

- **Sintaks Dasar dalam `love.draw()`:**

  ```lua
  function love.load()
      playerImage = love.graphics.newImage("player.png")
      playerX = 100
      playerY = 200
  end

  function love.update(dt)
      -- Logika untuk menggerakkan playerX dan playerY
      if love.keyboard.isDown("d") then
          playerX = playerX + 200 * dt -- gerakan berbasis waktu
      end
  end

  function love.draw()
      -- Menggambar gambar pemain
      love.graphics.draw(playerImage, playerX, playerY)

      -- Menggambar persegi panjang
      love.graphics.setColor(1, 0, 0) -- Merah (R, G, B antara 0 dan 1)
      love.graphics.rectangle("fill", 50, 50, 100, 80) -- mode, x, y, width, height

      -- Menggambar teks
      love.graphics.setColor(1, 1, 1) -- Putih
      love.graphics.print("Hello LÖVE!", 400, 300)
  end
  ```

---

## Fase 5 & 6: Game Mechanics & Advanced Development

Di fase ini, Anda mulai membangun sistem yang lebih kompleks. Kita akan menyoroti beberapa konsep kunci.

### 5.2 Physics dan Collision Detection

- **Deskripsi:** LÖVE memiliki modul `love.physics` yang merupakan pembungkus dari engine fisika Box2D. Ini memungkinkan Anda membuat simulasi fisika yang realistis (gravitasi, tumbukan, gaya).
- **Konsep Kunci:**
  - **World:** "Dunia" fisika dengan gravitasi tertentu.
  - **Body:** Objek fisik (bisa statis, dinamis, atau kinematik).
  - **Shape:** Bentuk geometri dari body untuk deteksi tumbukan (lingkaran, poligon).
  - **Fixture:** Mengikat sebuah _shape_ ke sebuah _body_ dan mendefinisikan propertinya (kepadatan, gesekan, pantulan).

### 5.4 Entity-Component-System (ECS) Pattern

- **Deskripsi:** Ini adalah pola arsitektur yang sangat populer dalam pengembangan game modern karena fleksibilitas dan performanya. Alih-alih menggunakan OOP tradisional di mana objek membundel data dan perilaku (misal, objek `Player` punya `posisi`, `hp`, dan fungsi `update()`), ECS memisahkan semuanya.
- **Visualisasi Konsep:**
  - **Entity:** Hanyalah sebuah ID unik. Contoh: `1`, `2`, `3`.
  - **Component:** Hanyalah data mentah. Contoh: `PositionComponent {x=10, y=20}`, `SpriteComponent {image="...png"}`, `HealthComponent {hp=100}`.
  - **System:** Hanyalah logika (fungsi) yang beroperasi pada _semua entitas_ yang memiliki _kumpulan komponen tertentu_. Contoh: `RenderSystem` akan mencari semua entitas yang punya `PositionComponent` DAN `SpriteComponent`, lalu menggambarnya. `PhysicsSystem` akan mencari semua entitas yang punya `PositionComponent` DAN `VelocityComponent` lalu memperbarui posisinya.
- **Keuntungan:** Mudah untuk menambah atau menghapus fitur. Ingin membuat objek bisa ditembak? Cukup tambahkan `ShootableComponent`. Ingin membuatnya tidak bisa bergerak? Hapus `VelocityComponent`. Ini jauh lebih fleksibel daripada hierarki warisan OOP yang kaku.
- **Library:** LÖVE tidak memiliki ECS bawaan. Anda perlu menggunakan library pihak ketiga. Salah satu yang populer adalah **tiny-ecs**.
  - **Referensi:** [https://github.com/bakpakin/tiny-ecs](https://github.com/bakpakin/tiny-ecs)

### 6.3 Networking dan Multiplayer

- **UDP vs TCP:**
  - **TCP (Transmission Control Protocol):** Terjamin, berurutan, tapi lebih lambat. Cocok untuk game berbasis giliran (catur, kartu) atau data yang harus sampai utuh (chat).
  - **UDP (User Datagram Protocol):** Cepat, tidak ada jaminan pengiriman atau urutan. Cocok untuk game real-time (FPS, balapan) di mana data posisi terbaru lebih penting daripada data lama yang mungkin hilang.
- **Arsitektur Client-Server:** Model paling umum. Satu server pusat mengelola state game, dan semua pemain (klien) mengirimkan input ke server dan menerima update dari server. Ini mencegah kecurangan karena klien tidak bisa memanipulasi state game secara langsung.

---

## Fase 7, 8, & 9: Proyek, Industri, dan Spesialisasi

Fase-fase akhir ini berfokus pada penerapan, pemolesan, dan melihat bagaimana Lua digunakan di dunia nyata.

- **Roblox (Luau):** Roblox menggunakan dialek Lua yang sedikit dimodifikasi yang disebut Luau, yang menambahkan beberapa fitur seperti _static type checking_ opsional untuk performa dan kejelasan kode yang lebih baik.
- **World of Warcraft Addons:** Ini adalah contoh klasik penggunaan Lua. Seluruh antarmuka pengguna (UI) WoW dapat dimodifikasi dan diperluas menggunakan addon yang ditulis dalam Lua.
- **Defold Engine:** Engine game 2D gratis yang menggunakan Lua sebagai bahasa scripting utamanya. Sangat dioptimalkan untuk performa, terutama di perangkat mobile.
  - **Referensi:** [https://defold.com/](https://defold.com/)
- **Deployment:** LÖVE memudahkan pembuatan game untuk Windows, macOS, dan Linux. Untuk mobile (Android/iOS), prosesnya sedikit lebih rumit dan memerlukan beberapa langkah tambahan yang dijelaskan di wiki LÖVE.

---

### Rekomendasi Tambahan:

1.  **Praktik Sejak Dini:** Jangan menunggu sampai Fase 4 untuk mulai membuat sesuatu. Setelah Anda mempelajari `table` dan fungsi di Fase 1, coba buat game teks sederhana di terminal, seperti tebak angka atau Tic-Tac-Toe. Ini akan memperkuat pemahaman fundamental Anda.
2.  **Pahami "The Lua Way":** Karena Anda datang dari Dart/OOP, Anda mungkin tergoda untuk mereplikasi pola `class` secara ketat. Luangkan waktu untuk benar-benar memahami bagaimana `metatables` dan `closures` bekerja. Seringkali, solusi yang paling "Lua-banget" bukanlah meniru bahasa lain, melainkan menggunakan kekuatan unik Lua.
3.  **Baca Kode Orang Lain:** Setelah Anda nyaman dengan dasar-dasar LÖVE, lihatlah proyek-proyek open-source di [Awesome LÖVE 2D](https://github.com/love2d-community/awesome-love2d). Melihat bagaimana programmer berpengalaman menstrukturkan game mereka adalah pelajaran yang tak ternilai.
4.  **Jangan Takut pada Matematika:** Pengembangan game, bahkan 2D, akan melibatkan matematika (vektor, trigonometri dasar). Jangan menghindarinya. Banyak sumber daya online yang menjelaskan konsep-konsep ini dalam konteks game.

---

### **Deep Dive: Fase 5.4 - Entity-Component-System (ECS) Pattern**

#### 1. Mengapa Kita Membutuhkan ECS? Masalah dengan OOP Tradisional di Game

Siapapun yang datang dari latar belakang OOP mungkin berpikir: "Saya akan membuat sebuah `class` Player, sebuah `class` Enemy, dan sebuah `class` Bullet."

```lua
-- Pendekatan OOP Tradisional (Konseptual)
Player = {}
Player.new = function()
  local self = { hp = 100, x = 0, y = 0, damage = 10 }
  self.move = function(...) ... end
  self.attack = function(...) ... end
  self.draw = function(...) ... end
  return self
end
```

Ini bekerja baik untuk proyek kecil. Tapi bayangkan skenario ini:

- Anda ingin membuat musuh yang tidak bisa bergerak, tapi bisa menembak (`StationaryTurret`).
- Anda ingin membuat peti harta karun yang bisa dihancurkan seperti musuh, tapi tidak bisa bergerak atau menyerang (`DestructibleChest`).
- Anda ingin NPC bisa berbicara, dan pemain juga bisa, tapi musuh tidak.

Dengan OOP, Anda akan terjebak dalam jaring warisan (inheritance) yang rumit. `StationaryTurret` mewarisi dari `Enemy`? Tapi `move()`-nya bagaimana? `DestructibleChest` mewarisi dari `GameObject`? Ini cepat menjadi kaku dan sulit dikelola. Masalah ini sering disebut **"The God Object Problem"** atau **hierarki warisan yang rapuh**.

**ECS memecahkan masalah ini dengan membalik logikanya: Alih-alih objek _memiliki_ data dan perilaku, kita definisikan entitas sebagai _kumpulan_ data, dan sistem menyediakan perilakunya.**

#### 2. Tiga Pilar ECS: Membedah Konsep

Seperti yang dijelaskan sebelumnya, ECS terdiri dari tiga bagian:

- **Entity (Entitas):** **Siapa?**

  - Ini BUKAN sebuah objek. Anggap saja ini sebagai sebuah nomor ID atau "paku" kosong di papan. Ia tidak punya data, tidak punya logika. Ia hanya ada untuk menandai keberadaan sesuatu. Contoh: `Entitas 1` adalah pemain, `Entitas 2` adalah musuh, `Entitas 3` adalah peluru.

- **Component (Komponen):** **Apa?**

  - Ini HANYALAH data. Sebuah `table` Lua sederhana yang tidak memiliki fungsi di dalamnya. Setiap komponen merepresentasikan satu aspek atau "sifat" dari sebuah entitas.
  - **Contoh Komponen:**
    ```lua
    -- Hanya data posisi
    local Position = { x = 0, y = 0 }
    -- Hanya data kecepatan
    local Velocity = { dx = 0, dy = 0 }
    -- Hanya data untuk bisa digambar
    local Renderable = { image = "player.png", scale = 1 }
    -- Hanya data untuk bisa diserang
    local Health = { current = 100, max = 100 }
    -- Hanya data untuk menandai bahwa ini adalah pemain
    local PlayerTag = {} -- Bisa juga table kosong
    ```

- **System (Sistem):** **Bagaimana?**
  - Ini adalah LOGIKA murni. Sebuah fungsi atau modul yang berjalan dan hanya peduli pada entitas yang memiliki _kombinasi komponen tertentu_.
  - **Contoh Sistem:**
    - `MovementSystem`: Akan mencari **semua entitas** yang memiliki komponen `Position` DAN `Velocity`. Kemudian, ia akan mengubah data di `Position` berdasarkan data di `Velocity`.
    - `RenderSystem`: Akan mencari **semua entitas** yang memiliki komponen `Position` DAN `Renderable`. Kemudian, ia akan menggambar gambar dari `Renderable` di koordinat `Position`.
    - `DamageSystem`: Akan mencari **semua entitas** yang terlibat dalam sebuah tumbukan, lalu memeriksa apakah keduanya punya komponen `Health` dan `Damage`, lalu mengurangi `Health`.

**Visualisasi Komposisi vs Warisan:**

- **Warisan (OOP):** Sebuah `Player` **ADALAH** `Character`.
- **Komposisi (ECS):** Sebuah `Entitas` **MEMILIKI** `Position`, `Health`, dan `Sprite`.

#### 3. Implementasi Praktis dengan LÖVE 2D dan `tiny-ecs`

LÖVE tidak punya ECS bawaan. Kita akan gunakan library pihak ketiga yang populer, ringan, dan mudah digunakan bernama **`tiny-ecs`**.

- **Langkah 1: Setup Proyek**

  1.  Unduh file `tiny.lua` dari repositori GitHub-nya.
      - **Link Langsung:** [https://github.com/bakpakin/tiny-ecs/blob/master/tiny.lua](https://github.com/bakpakin/tiny-ecs/blob/master/tiny.lua)
  2.  Buat struktur folder proyek Anda seperti ini:
      ```
      my-ecs-game/
      ├── tiny.lua       -- Library ECS
      └── main.lua       -- Kode game kita
      ```

- **Langkah 2: Kode `main.lua`**

  Mari kita buat game super sederhana di mana satu kotak (pemain) bisa digerakkan, dan beberapa kotak lain (musuh) bergerak secara otomatis.

  ```lua
  --[[
      main.lua - Contoh Praktis ECS
  ]]

  -- 1. Muat library ECS
  local tiny = require 'tiny'

  -- Global variable untuk ECS world
  world = nil

  function love.load()
      -- 2. Inisialisasi 'Dunia' ECS kita
      world = tiny.world()

      -- 3. DEFINISI KOMPONEN (hanya data)
      Position = tiny.component(function(x, y)
          return { x = x or 0, y = y or 0 }
      end)

      Velocity = tiny.component(function(dx, dy)
          return { dx = dx or 0, dy = dy or 0 }
      end)

      -- Komponen untuk bisa digambar
      Drawable = tiny.component(function(r, g, b, size)
          return { color = {r or 1, g or 1, b or 1}, size = size or 20 }
      end)

      -- Komponen penanda (tag) untuk pemain
      PlayerControlled = tiny.component()

      -- 4. DEFINISI SISTEM (hanya logika)
      MovementSystem = tiny.system(function(e, dt) -- 'e' adalah entitas
          -- Sistem ini beroperasi pada setiap entitas 'e' yang memiliki Position DAN Velocity
          e.position.x = e.position.x + e.velocity.dx * dt
          e.position.y = e.position.y + e.velocity.dy * dt
      end)
      -- Filter: Sistem ini HANYA akan berjalan pada entitas dengan komponen ini
      MovementSystem.filter = tiny.require(Position, Velocity)

      PlayerInputSystem = tiny.system(function(e)
          local speed = 200
          if love.keyboard.isDown('d') then e.velocity.dx = speed
          elseif love.keyboard.isDown('a') then e.velocity.dx = -speed
          else e.velocity.dx = 0 end

          if love.keyboard.isDown('s') then e.velocity.dy = speed
          elseif love.keyboard.isDown('w') then e.velocity.dy = -speed
          else e.velocity.dy = 0 end
      end)
      -- Filter: Sistem ini HANYA berjalan pada entitas yang bisa dikontrol pemain
      PlayerInputSystem.filter = tiny.require(PlayerControlled, Velocity)


      -- 5. PEMBUATAN ENTITAS (komposisi)
      -- Buat entitas pemain
      local player = world:new()
      world:add(player,
          Position(400, 300),         -- Punya posisi
          Velocity(),                -- Punya kecepatan (awalnya 0)
          Drawable(0, 1, 0, 30),     -- Bisa digambar (hijau, ukuran 30)
          PlayerControlled()         -- Bisa dikontrol pemain
      )

      -- Buat beberapa entitas musuh
      for i = 1, 5 do
          world:new(
              Position(math.random(800), math.random(600)),
              Velocity(math.random(-50, 50), math.random(-50, 50)),
              Drawable(1, 0, 0, 15) -- Merah, ukuran 15
          )
      end
  end

  function love.update(dt)
      -- 6. JALANKAN SISTEM
      -- Jalankan sistem input untuk entitas yang relevan
      world:update(PlayerInputSystem, dt)
      -- Jalankan sistem pergerakan untuk SEMUA entitas yang bisa bergerak
      world:update(MovementSystem, dt)

      -- Perhatikan betapa bersihnya fungsi update utama kita!
  end

  function love.draw()
      -- 7. Membuat sistem render "on-the-fly"
      local renderFilter = tiny.require(Position, Drawable)
      for id, e in world:each(renderFilter) do
          love.graphics.setColor(e.drawable.color)
          love.graphics.rectangle('fill', e.position.x, e.position.y, e.drawable.size, e.drawable.size)
      end
      love.graphics.setColor(1,1,1) -- Reset warna
  end
  ```

#### 4. Analisis dan Keuntungan dari Kode di Atas

1.  **Fleksibilitas Luar Biasa:**

    - Ingin membuat musuh yang tidak bergerak? Cukup hapus `Velocity()` saat membuatnya. `MovementSystem` akan mengabaikannya secara otomatis.
    - Ingin membuat item yang bisa digambar tapi tidak bergerak dan tidak bisa dikontrol? Cukup buat entitas dengan `Position()` dan `Drawable()`.
    - Ingin pemain tidak bisa bergerak untuk sementara (misal saat cutscene)? Anda bisa buat `world:remove(player, PlayerControlled)` untuk menonaktifkan input, dan `world:add(player, PlayerControlled)` untuk mengaktifkannya kembali. Anda tidak perlu mengubah `class` atau menambah `if` statement yang rumit.

2.  **Kode yang Terorganisir:**

    - Semua logika pergerakan ada di `MovementSystem`.
    - Semua logika input ada di `PlayerInputSystem`.
    - Data terpisah dan jelas (Komponen).
    - Fungsi `love.update()` tetap bersih dan hanya berfungsi sebagai "dirigen" yang memanggil sistem-sistem pada waktunya.

3.  **Potensi Performa:**
    - Secara konseptual, `MovementSystem` memproses semua data posisi dan kecepatan secara berurutan di memori. Ini jauh lebih efisien untuk cache CPU dibandingkan melompat-lompat antar objek yang berbeda di memori seperti pada pendekatan OOP.

Ini adalah contoh bagaimana Anda harus mendekati setiap topik lanjutan di kurikulum: pahami masalah yang coba diselesaikannya, pecah konsepnya, temukan alat (library) yang relevan, dan bangun prototipe kecil untuk membuktikan pemahaman Anda. Dari sini, Anda bisa mulai menambahkan `HealthSystem`, `CollisionSystem`, dan lainnya untuk membangun game yang kompleks.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../README.md
[selanjutnya]: ../README.md

<!-------------------------------------------------->

[0]: ../README.md
[1]: ../../game-development/materi/README.md

<!-- [2]: ../ -->
