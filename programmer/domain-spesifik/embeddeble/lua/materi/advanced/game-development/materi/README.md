### **Daftar Isi**

- [](#)
  - [**Deep Dive: Fase 6.1 - Shaders dan GLSL untuk Efek Visual Lanjutan**](#deep-dive-fase-61---shaders-dan-glsl-untuk-efek-visual-lanjutan)
    - [1. Apa Itu Shader? Memindahkan Beban dari CPU ke GPU](#1-apa-itu-shader-memindahkan-beban-dari-cpu-ke-gpu)
    - [2. Dua Jenis Shader Utama dalam 2D](#2-dua-jenis-shader-utama-dalam-2d)
    - [3. Bahasa untuk Shader: Pengenalan GLSL](#3-bahasa-untuk-shader-pengenalan-glsl)
    - [4. Implementasi Praktis: Efek Riak Air (Water Ripple) di LÖVE](#4-implementasi-praktis-efek-riak-air-water-ripple-di-löve)
    - [5. Kekuatan yang Telah Anda Buka](#5-kekuatan-yang-telah-anda-buka)
- [](#-1)
  - [**Deep Dive: Fase 6.2 - Kecerdasan Buatan (AI) dengan Behavior Trees**](#deep-dive-fase-62---kecerdasan-buatan-ai-dengan-behavior-trees)
    - [1. Mengapa Kita Butuh Sesuatu yang Lebih Baik dari `if/else`?](#1-mengapa-kita-butuh-sesuatu-yang-lebih-baik-dari-ifelse)
    - [2. Konsep Inti: Node dan Status Eksekusi](#2-konsep-inti-node-dan-status-eksekusi)
    - [3. Jenis-Jenis Node: Bata Pembangun Perilaku](#3-jenis-jenis-node-bata-pembangun-perilaku)
      - [**A. Composite Nodes (Node Alur Kontrol)**](#a-composite-nodes-node-alur-kontrol)
      - [**B. Leaf Nodes (Node Aksi/Daun)**](#b-leaf-nodes-node-aksidaun)
    - [4. Visualisasi: AI Penjaga Sederhana](#4-visualisasi-ai-penjaga-sederhana)
    - [5. Implementasi Konseptual dalam Lua](#5-implementasi-konseptual-dalam-lua)
    - [6. Keuntungan yang Anda Dapatkan](#6-keuntungan-yang-anda-dapatkan)
- [](#-2)
- [](#-3)

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

Setelah membangun fondasi yang kuat dengan arsitektur game (ECS), langkah selanjutnya yang logis dalam perjalanan penguasaan Anda adalah mendalami **Fase 6: Advanced Game Development**. Secara spesifik, kita akan melakukan _deep dive_ pada salah satu topik yang paling berdampak secara visual dan teknis: **Fase 6.1 - Advanced Graphics Techniques: Shaders dan GLSL**.

Menguasai _shader_ adalah gerbang untuk menciptakan game yang tidak hanya berfungsi dengan baik, tetapi juga memiliki tampilan yang unik, modern, dan artistik. Ini adalah skill yang memisahkan game "buatan sendiri" dari game yang terlihat profesional.

---

### **Deep Dive: Fase 6.1 - Shaders dan GLSL untuk Efek Visual Lanjutan**

#### 1. Apa Itu Shader? Memindahkan Beban dari CPU ke GPU

Selama ini, saat Anda menggunakan `love.graphics.draw()` atau `love.graphics.rectangle()`, Anda memberikan perintah sederhana ke CPU. CPU kemudian meneruskannya ke GPU (Graphics Processing Unit) untuk digambar menggunakan serangkaian operasi standar. Anda tidak punya kendali atas _bagaimana_ setiap piksel digambar.

**Shader mengubah ini sepenuhnya.**

- **Definisi:** Shader adalah program kecil yang Anda tulis sendiri, yang berjalan langsung di GPU untuk setiap vertex (titik sudut) dan setiap piksel dari gambar yang Anda render.
- **Tujuannya:** Memberikan Anda kendali penuh atas posisi akhir setiap titik dan warna akhir setiap piksel.
- **Mengapa Penting?** GPU dirancang untuk melakukan ribuan kalkulasi matematika sederhana secara paralel. Dengan memindahkan logika visual ke shader, Anda bisa menciptakan efek yang sangat kompleks (seperti pencahayaan dinamis, riak air, blur) dengan performa yang jauh lebih tinggi daripada jika Anda mencoba melakukannya di CPU (misalnya, dengan memanipulasi data gambar piksel per piksel di Lua).

#### 2. Dua Jenis Shader Utama dalam 2D

Dalam konteks LÖVE 2D, Anda akan berinteraksi dengan dua jenis shader utama:

1.  **Vertex Shader:**

    - **Kapan Berjalan?** Berjalan satu kali untuk setiap _titik sudut_ (vertex) dari bentuk yang Anda gambar. (Sebuah persegi panjang punya 4 vertex).
    - **Tugas Utama:** Menghitung dan menentukan posisi akhir dari vertex tersebut di layar. Di 2D, ini sering digunakan untuk efek seperti "bergoyang" (wobble) atau distorsi skala.

2.  **Pixel Shader (atau Fragment Shader):**
    - **Kapan Berjalan?** Berjalan satu kali untuk setiap _piksel_ di dalam bentuk tersebut, setelah Vertex Shader selesai.
    - **Tugas Utama:** Menghitung dan menentukan warna akhir dari piksel tersebut. **Di sinilah sebagian besar keajaiban efek 2D terjadi.** Grayscale, sepia, glow, riak air, penyesuaian warna, semuanya dilakukan di sini.

**Visualisasi Alur Kerja:**

`CPU (Kode Lua)` -> Kirim data (posisi, gambar, variabel) -> `GPU`
`GPU`:

1.  Jalankan **Vertex Shader** untuk setiap sudut -> Tentukan bentuk akhir.
2.  Jalankan **Pixel Shader** untuk setiap piksel di dalam bentuk itu -> Tentukan warna akhir setiap piksel.
3.  Tampilkan di layar.

#### 3. Bahasa untuk Shader: Pengenalan GLSL

Shader tidak ditulis dalam Lua. Mereka ditulis dalam bahasa C-like khusus yang disebut **GLSL (OpenGL Shading Language)**. LÖVE menggunakan varian spesifik yang disebut **GLSL ES 1.0**. Anda tidak perlu menjadi ahli C, tetapi Anda perlu memahami sintaks dasarnya.

**Konsep Kunci GLSL untuk Pixel Shader:**

- `vec2`, `vec3`, `vec4`: Tipe data vektor untuk menyimpan 2, 3, atau 4 angka. `vec4` sangat umum digunakan untuk warna RGBA (Red, Green, Blue, Alpha).
- `sampler2D`: Merepresentasikan sebuah gambar/tekstur yang Anda kirim dari Lua.
- `uniform`: Variabel yang nilainya Anda kirim dari kode Lua ke shader. Ini adalah jembatan komunikasi utama. Contoh: `uniform float time;` atau `uniform vec2 lightPosition;`.
- `texture2D(sampler, coordinates)`: Fungsi bawaan untuk mengambil warna dari sebuah `sampler2D` (gambar) pada koordinat UV tertentu (antara 0.0 dan 1.0).
- `gl_FragColor`: Variabel global spesial di pixel shader. Warna apa pun yang Anda masukkan ke variabel ini akan menjadi warna akhir piksel di layar.

#### 4. Implementasi Praktis: Efek Riak Air (Water Ripple) di LÖVE

Mari kita buat efek yang membuat gambar terlihat beriak seperti permukaan air. Efek ini dicapai dengan menggeser (offset) koordinat pembacaan gambar menggunakan fungsi sinus.

- **Langkah 1: Setup Proyek**
  Buat struktur folder seperti ini:

  ```
  my-shader-game/
  ├── main.lua          -- Kode LÖVE kita
  ├── ripple.glsl       -- Kode shader kita
  └── image.png         -- Gambar apapun untuk diberi efek
  ```

- **Langkah 2: Kode `main.lua`**

  ```lua
  --[[
      main.lua - Menggunakan shader untuk efek visual
  ]]
  function love.load()
      -- Muat gambar yang akan kita beri efek
      myImage = love.graphics.newImage('image.png')

      -- Muat file shader kita
      -- LÖVE secara otomatis akan mendeteksi kode vertex dan pixel shader di dalamnya
      rippleShader = love.graphics.newShader('ripple.glsl')

      -- Variabel untuk mengontrol efek dari waktu ke waktu
      time = 0
  end

  function love.update(dt)
      -- Update variabel waktu setiap frame
      time = time + dt
  end

  function love.draw()
      -- Posisikan gambar di tengah layar
      local x = (love.graphics.getWidth() - myImage:getWidth()) / 2
      local y = (love.graphics.getHeight() - myImage:getHeight()) / 2

      -- 1. AKTIFKAN SHADER
      love.graphics.setShader(rippleShader)

      -- 2. KIRIM VARIABEL (UNIFORM) DARI LUA KE SHADER
      -- Kita mengirim nilai 'time' kita ke variabel 'uniform float u_time' di GLSL
      rippleShader:send("u_time", time)

      -- 3. GAMBAR OBJEK SEPERTI BIASA
      -- Semua yang digambar setelah setShader() akan terpengaruh olehnya
      love.graphics.draw(myImage, x, y)

      -- 4. NONAKTIFKAN SHADER (PENTING!)
      -- Agar objek lain yang digambar setelah ini tidak ikut terpengaruh
      love.graphics.setShader()

      -- Teks ini tidak akan terpengaruh shader
      love.graphics.print("Teks ini normal.", 10, 10)
  end
  ```

- **Langkah 3: Kode Shader `ripple.glsl`**

  Salin dan tempel kode berikut ke dalam file `ripple.glsl`. Kode ini berisi kedua jenis shader (vertex dan pixel).

  ```glsl
  // ======== VERTEX SHADER ========
  // (Tugasnya hanya meneruskan data ke pixel shader)
  // 'attribute' adalah data per-vertex yang dikirim LÖVE secara default
  attribute vec4 VertexPosition;
  attribute vec4 VertexColor;
  attribute vec2 TexelCoord;

  // 'varying' adalah cara kita mengirim data dari vertex ke pixel shader
  varying vec4 v_color;
  varying vec2 v_texCoord;

  // LÖVE mengirimkan ini secara otomatis
  uniform mat4 TransformMatrix;
  uniform mat4 ProjectionMatrix;

  vec4 position(mat4 transform_projection, vec4 vertex_position) {
      return transform_projection * vertex_position;
  }

  // ======== PIXEL SHADER ========
  // (Di sinilah keajaiban terjadi)
  // 'varying' diterima dari vertex shader
  varying vec4 v_color;
  varying vec2 v_texCoord;

  // 'uniform' diterima dari kode Lua (love.graphics.send)
  uniform sampler2D MainTex; // Gambar utama kita (LÖVE mengirim ini secara otomatis)
  uniform float u_time; // Variabel waktu yang kita kirim dari Lua

  vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
      // Buat salinan koordinat tekstur agar bisa kita modifikasi
      vec2 uv = v_texCoord;

      // Hitung pergeseran (offset) menggunakan fungsi sinus
      // Ini menciptakan gelombang horizontal dan vertikal
      float horizontal_wave = sin(uv.y * 20.0 + u_time * 5.0) * 0.02;
      float vertical_wave = cos(uv.x * 20.0 + u_time * 5.0) * 0.02;

      // Terapkan pergeseran ke koordinat tekstur
      uv.x += horizontal_wave;
      uv.y += vertical_wave;

      // Ambil warna piksel dari gambar asli menggunakan koordinat yang sudah dimodifikasi
      vec4 final_color = texture2D(MainTex, uv);

      // Kembalikan warna akhir, dikalikan dengan warna vertex (untuk transparansi, dll.)
      return final_color * v_color;
  }
  ```

**Jika Anda menjalankan proyek LÖVE ini, Anda akan melihat gambar Anda meliuk-liuk dan berdistorsi seolah-olah berada di bawah permukaan air.**

#### 5. Kekuatan yang Telah Anda Buka

Dengan memahami alur kerja ini, Anda kini bisa:

- Membuat efek pencahayaan 2D dengan mengirim posisi cahaya sebagai `uniform`.
- Membuat efek grayscale dengan mengambil rata-rata komponen R, G, B dari warna piksel.
- Membuat transisi layar (seperti _wipe_ atau _dissolve_) dengan menerapkan shader ke seluruh layar.
- Membuat efek _CRT scanlines_, _blur_, _shockwave_, dan ratusan efek visual lainnya.

Ini adalah langkah besar menuju penguasaan pengembangan game. Anda tidak lagi dibatasi oleh fungsi gambar bawaan, tetapi dapat menciptakan estetika visual yang unik sesuai dengan visi artistik Anda.

#

Kita telah membahas arsitektur data dengan **ECS** dan presentasi visual dengan **Shaders**. Sekarang, kita akan melakukan _deep dive_ ke dalam "otak" dari entitas game Anda: **Fase 6.2 - AI dan Game Logic**, dengan fokus pada teknik modern yang sangat kuat dan modular: **Behavior Trees (Pohon Perilaku)**.

Menguasai Behavior Trees (BTs) akan memungkinkan Anda untuk membangun AI yang kompleks, dapat diprediksi, dan mudah untuk di-debug serta diperluas, jauh melampaui apa yang bisa dicapai dengan rantai `if-elseif-else` yang rumit.

---

### **Deep Dive: Fase 6.2 - Kecerdasan Buatan (AI) dengan Behavior Trees**

#### 1. Mengapa Kita Butuh Sesuatu yang Lebih Baik dari `if/else`?

Untuk AI sederhana, Anda mungkin menulis sesuatu seperti ini di dalam `update` musuh:

```lua
if canSeePlayer(self) then
    self:chasePlayer()
elseif self.health < 20 then
    self:flee()
else
    self:patrol()
end
```

Ini bekerja, tetapi cepat menjadi "Spaghetti Code". Bagaimana jika Anda ingin menambahkan kondisi "jika kehabisan amunisi, cari amunisi"? Atau "jika mendengar suara, selidiki"? Rantai `if/else` menjadi sangat panjang, sulit dibaca, dan sulit dikelola.

Alternatif lain adalah **Finite State Machine (FSM)**, di mana AI berada dalam satu state (misalnya, `PATROL`, `CHASE`, `ATTACK`) dan bisa bertransisi ke state lain. Ini lebih baik, tetapi bisa menderita **"State Explosion"**. Untuk setiap state, Anda harus mendefinisikan transisi ke semua state lain yang memungkinkan, yang bisa menjadi sangat rumit.

**Behavior Trees menawarkan solusi yang lebih baik:** Mereka bersifat hierarkis dan modular, memungkinkan Anda membangun perilaku kompleks dari "bata-bata" logika yang sederhana dan dapat digunakan kembali.

#### 2. Konsep Inti: Node dan Status Eksekusi

Sebuah Behavior Tree adalah pohon yang terdiri dari berbagai jenis **node**. Pohon ini "dijalankan" dari atas ke bawah pada setiap frame (atau interval waktu tertentu) untuk memutuskan tindakan apa yang harus diambil oleh AI.

Setiap node yang dijalankan akan mengembalikan salah satu dari tiga status:

- `SUCCESS` (Sukses): Tugas node telah selesai dengan sukses.
- `FAILURE` (Gagal): Tugas node tidak dapat diselesaikan.
- `RUNNING` (Berjalan): Tugas node membutuhkan lebih dari satu frame untuk selesai (misalnya, berjalan ke suatu titik).

Status ini sangat penting karena menentukan bagaimana node induk akan melanjutkan eksekusi pohon.

#### 3. Jenis-Jenis Node: Bata Pembangun Perilaku

Ada dua kategori utama node: **Composite Nodes** (yang mengontrol alur) dan **Leaf Nodes** (yang melakukan aksi).

##### **A. Composite Nodes (Node Alur Kontrol)**

Ini adalah cabang-cabang di pohon Anda. Mereka tidak melakukan aksi sendiri, tetapi mengarahkan alur eksekusi ke anak-anak mereka berdasarkan aturan tertentu.

1.  **Sequence (Urutan | Simbol: `->`)**

    - **Tugas:** Menjalankan anak-anaknya secara berurutan, dari kiri ke kanan.
    - **Aturan:**
      - Jika seorang anak mengembalikan `FAILURE`, Sequence akan segera berhenti dan mengembalikan `FAILURE`. Ia tidak akan mencoba anak berikutnya.
      - Jika seorang anak mengembalikan `RUNNING`, Sequence akan segera berhenti dan mengembalikan `RUNNING`. Pada frame berikutnya, ia akan melanjutkan dari anak yang sama.
      - Hanya jika **semua** anaknya mengembalikan `SUCCESS`, maka Sequence akan mengembalikan `SUCCESS`.
    - **Analogi:** Mengikuti resep masakan. "Ambil mangkuk" -> "Masukkan tepung" -> "Aduk". Jika Anda gagal mengambil mangkuk, Anda tidak melanjutkan ke langkah berikutnya.

2.  **Selector (Pilihan | Simbol: `?`)**
    - **Tugas:** Mencoba setiap anaknya secara berurutan sampai salah satunya berhasil.
    - **Aturan:**
      - Jika seorang anak mengembalikan `SUCCESS`, Selector akan segera berhenti dan mengembalikan `SUCCESS`. Ia tidak akan mencoba anak berikutnya.
      - Jika seorang anak mengembalikan `RUNNING`, Selector akan segera berhenti dan mengembalikan `RUNNING`. Pada frame berikutnya, ia akan melanjutkan dari anak yang sama.
      - Hanya jika **semua** anaknya mengembalikan `FAILURE`, maka Selector akan mengembalikan `FAILURE`.
    - **Analogi:** Mencari kunci. "Cek saku?" (Gagal) -> "Cek tas?" (Gagal) -> "Cek meja?" (Sukses! Berhenti mencari).

##### **B. Leaf Nodes (Node Aksi/Daun)**

Ini adalah ujung dari cabang pohon, tempat pekerjaan sebenarnya dilakukan.

1.  **Action (Aksi)**

    - **Tugas:** Melakukan sesuatu di dalam dunia game. Contoh: `AttackPlayer()`, `MoveToLocation()`, `PlaySound('Aku melihatmu!')`.
    - **Status Kembali:** Bisa `SUCCESS` (serangan selesai), `FAILURE` (pemain di luar jangkauan serangan), atau `RUNNING` (sedang dalam perjalanan ke suatu lokasi).

2.  **Condition (Kondisi)**
    - **Tugas:** Memeriksa keadaan dunia game. Ini adalah versi `if` dari Behavior Tree. Contoh: `IsPlayerInRange()`, `IsHealthLow()`, `HasAmmunition()`.
    - **Status Kembali:** Hanya `SUCCESS` (jika kondisi benar) atau `FAILURE` (jika kondisi salah). Mereka tidak pernah mengembalikan `RUNNING`.

#### 4. Visualisasi: AI Penjaga Sederhana

Mari kita rancang AI untuk penjaga yang berpatroli, tetapi akan mengejar dan menyerang pemain jika ia berada dalam jangkauan.

```
          [? Selector: Logika Utama]
         /                          \
        /                            \
[-> Sequence: Serang Pemain]      [-> Sequence: Patroli]
 |-----------------------------|      |--------------------------|
/              |               \     /                          \
[? IsPlayerInAttackRange?] [ChasePlayer] [AttackPlayer] [? HasPatrolPoint?] [MoveToPatrolPoint]
```

**Bagaimana pohon ini dibaca dari atas ke bawah:**

1.  **Selector Utama (?)**: Coba opsi pertama, yaitu `Sequence: Serang Pemain`.
2.  **Sequence Serang (->)**:
    - Coba anak pertamanya, `Condition: IsPlayerInAttackRange?`.
    - **Jika Gagal** (pemain terlalu jauh), maka `Sequence Serang` ini gagal. Selector Utama sekarang akan mencoba opsi keduanya, yaitu `Sequence: Patroli`.
    - **Jika Sukses** (pemain cukup dekat), `Sequence Serang` melanjutkan ke anak keduanya, `Action: ChasePlayer`. Jika `ChasePlayer` masih berjalan (`RUNNING`), seluruh pohon akan mengembalikan `RUNNING` dan mencoba lagi dari node `ChasePlayer` pada frame berikutnya. Jika sudah sampai (`SUCCESS`), ia melanjutkan ke `Action: AttackPlayer`.
3.  **Sequence Patroli (->)**: Ini hanya akan berjalan jika seluruh `Sequence Serang` gagal. Ia akan mencari titik patroli baru dan berjalan ke sana.

#### 5. Implementasi Konseptual dalam Lua

Anda tidak perlu membuat framework BT dari nol (banyak library tersedia), tetapi memahami cara kerjanya sangatlah penting.

```lua
-- Kerangka kerja node dasar (sangat disederhanakan)
local Node = {}
function Node:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

-- Kerangka untuk Aksi
local Action = Node:new()
function Action:new(actionFunc)
    local o = Node:new{ run = actionFunc }
    return o
end

-- Kerangka untuk Sequence
local Sequence = Node:new()
function Sequence:new(children)
    local o = Node:new{ children = children }
    function o:run(agent)
        for _, child in ipairs(self.children) do
            local status = child:run(agent)
            if status == "FAILURE" or status == "RUNNING" then
                return status -- Hentikan sequence
            end
        end
        return "SUCCESS" -- Semua anak berhasil
    end
    return o
end

-- (Kerangka untuk Selector akan serupa tetapi dengan logika yang berbeda)

-- --- Implementasi Aksi dan Kondisi untuk AI kita ---
function IsPlayerInRange(agent)
    -- Logika untuk mengecek jarak pemain...
    if distance(agent, player) < agent.attackRange then
        return "SUCCESS"
    else
        return "FAILURE"
    end
end

function AttackPlayer(agent)
    -- Logika untuk menyerang pemain...
    agent:attack()
    return "SUCCESS"
end

-- --- Membangun Pohon untuk AI Tertentu ---
local guard_ai_tree = Sequence:new({
    Action:new(IsPlayerInRange),
    Action:new(AttackPlayer)
})


-- --- Di dalam loop update AI ---
function Guard:update(dt)
    -- Jalankan pohon perilaku untuk memutuskan apa yang harus dilakukan
    guard_ai_tree:run(self)
end
```

Kode di atas adalah ilustrasi. Library BT yang sebenarnya akan mengelola status `RUNNING` dengan lebih baik.

#### 6. Keuntungan yang Anda Dapatkan

- **Modularitas & Reusabilitas:** Node `MoveTo` dapat digunakan untuk patroli, mengejar pemain, atau melarikan diri. Anda hanya perlu menempatkannya di cabang yang berbeda dari pohon.
- **Skalabilitas:** Ingin menambahkan perilaku "melarikan diri saat sekarat"? Cukup tambahkan `Selector` baru di paling atas dengan cabang pertama `Sequence: Lari Saat Sekarat` dan cabang kedua adalah seluruh logika lama Anda. Anda tidak perlu menyentuh kode yang sudah ada.
- **Mudah Di-debug:** Karena sifatnya yang visual dan hierarkis, Anda bisa melacak dengan tepat di mana keputusan AI gagal, hanya dengan melihat node mana yang mengembalikan `FAILURE`.

Dengan menguasai ECS untuk _apa_ itu entitas, Shaders untuk _bagaimana_ mereka terlihat, dan Behavior Trees untuk _mengapa_ mereka melakukan apa yang mereka lakukan, Anda telah membangun tiga pilar utama yang dibutuhkan untuk menciptakan game yang kompleks dan dinamis.

#

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
