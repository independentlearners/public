### [Daftar Isi Materi Pembelajaran][0]

- [Tingkat 1: Fondasi Dasar](#tingkat-1-fondasi-dasar)
  - [1.1 Pengenalan Konsep Modules](#11-pengenalan-konsep-modules)
  - [1.2 Struktur File dan Organisasi Kode](#12-struktur-file-dan-organisasi-kode)
  - [1.3 require() Function - Dasar](#13-require-function---dasar)
- [Tingkat 2: Implementasi Module Sederhana](#tingkat-2-implementasi-module-sederhana)
  - [2.1 Membuat Module Pertama](#21-membuat-module-pertama)
  - [2.2 Local vs Global dalam Module (Enkapsulasi)](#22-local-vs-global-dalam-module-enkapsulasi)
  - [2.3 Module Return Patterns](#23-module-return-patterns)
- [Tingkat 3: Teknik Advanced Module](#tingkat-3-teknik-advanced-module)
  - [3.1 Module dengan State Management](#31-module-dengan-state-management)
  - [3.2 Metatable dalam Modules](#32-metatable-dalam-modules)
  - [3.3 Lazy Loading dan Dynamic Loading](#33-lazy-loading-dan-dynamic-loading)
  - [3.4 Custom Module Loaders](#34-custom-module-loaders)
- [Tingkat 4: Package Management](#tingkat-4-package-management)
  - [4.1 LuaRocks - Package Manager](#41-luarocks---package-manager)
  - [4.2 Package Search Paths (LUA_PATH)](#42-package-search-paths-lua_path)
- [Dan Seterusnya (hingga Tingkat 10)](#dan-seterusnya-hingga-tingkat-10)
  - Catatan: Untuk menjaga respons tetap terfokus dan tidak terlalu panjang, saya akan merinci beberapa tingkat pertama secara mendalam sebagai contoh, dan memberikan ringkasan untuk tingkat selanjutnya. Struktur yang sama dapat diterapkan untuk semua tingkat.

---

## Tingkat 1: Fondasi Dasar

Pada tingkat ini, kita akan membangun pemahaman fundamental tentang apa itu module dan mengapa ia sangat penting dalam pemrograman modern.

### 1.1 Pengenalan Konsep Modules

- **Deskripsi Konkret**:
  Sebuah **module** adalah sebuah file Lua yang berisi kode yang dapat digunakan kembali. Anggap saja ini seperti sebuah "kotak peralatan" (`toolbox`) di mana Anda menyimpan fungsi, variabel, atau data yang saling berhubungan. Daripada menulis semua kode Anda dalam satu file raksasa, Anda memecahnya menjadi beberapa file yang logis dan terorganisir.

  - **Terminologi**:
    - **Modularitas**: Ini adalah prinsip desain perangkat lunak yang menekankan pemisahan fungsionalitas program menjadi blok-blok independen yang dapat dipertukarkan, yang disebut module. Tujuannya adalah untuk membuat kode lebih mudah dikelola, dipahami, dan di-debug.
    - **Namespace**: Sebuah module menciptakan "namespace" atau ruang nama sendiri. Ini berarti fungsi atau variabel yang Anda definisikan di dalam satu module tidak akan bertabrakan dengan nama yang sama di module lain atau di kode utama Anda. Di Dart, setiap file secara alami adalah sebuah library (mirip module) yang mencegah konflik nama.
    - **Reusability (Dapat Digunakan Kembali)**: Anda bisa menggunakan module yang sama di berbagai proyek atau di berbagai bagian dari proyek yang sama.

- **Mengapa Diperlukan?**:

  1.  **Organisasi**: Memisahkan kode berdasarkan fungsionalitas (misalnya, `player.lua`, `inventory.lua`, `network.lua`).
  2.  **Pemeliharaan**: Lebih mudah memperbaiki atau memperbarui bagian kecil dari kode tanpa mengganggu bagian lain.
  3.  **Kolaborasi**: Beberapa programmer dapat mengerjakan module yang berbeda secara bersamaan.
  4.  **Mencegah Polusi Global**: Menghindari penggunaan variabel global yang dapat menyebabkan bug yang sulit dilacak.

- **Sumber**:

  - [Programming in Lua - Modules](https://www.lua.org/pil/15.html)
  - [Lua-users Wiki: Modules Tutorial](http://lua-users.org/wiki/ModulesTutorial)

### 1.2 Struktur File dan Organisasi Kode

- **Deskripsi Konkret**:
  Bagaimana Anda menata file dan folder proyek Anda sangat memengaruhi kemudahan pengembangan. Konvensi membantu orang lain (dan diri Anda di masa depan) untuk memahami struktur proyek dengan cepat.

- **Konvensi dan Praktik Terbaik**:

  - **Penamaan File**: Gunakan nama huruf kecil dengan pemisah garis bawah (`snake_case`), misalnya: `my_module.lua`, `player_controller.lua`. Ini adalah konvensi yang umum di komunitas Lua.
  - **Struktur Direktori**: Kelompokkan module terkait ke dalam direktori.
    ```
    project/
    ├── main.lua
    ├── config.lua
    └── lib/
        ├── utils.lua
        ├── player/
        │   ├── core.lua
        │   └── inventory.lua
        └── vendor/
            └── json.lua
    ```
  - `main.lua`: File utama yang memulai aplikasi Anda.
  - `lib/` atau `src/`: Direktori umum untuk menyimpan semua module Anda.
  - `lib/player/`: Sub-direktori untuk module yang spesifik untuk "player".
  - `vendor/` atau `external/`: Untuk library dari pihak ketiga.

- **Sumber**:

  - [Lua Style Guide - Modules](https://github.com/Olivine-Labs/lua-style-guide#modules)
  - [Lua-users Wiki: Directory Structure](http://lua-users.org/wiki/DirectoryStructure)

### 1.3 `require()` Function - Dasar

- **Deskripsi Konkret**:
  `require` adalah fungsi bawaan Lua yang menjadi jantung dari sistem module. Fungsinya adalah untuk **menemukan, memuat, dan menjalankan** sebuah module, lalu mengembalikan nilai yang diekspor oleh module tersebut. Yang terpenting, `require` cukup pintar untuk memastikan bahwa setiap module **hanya dimuat satu kali**, bahkan jika Anda memanggil `require` untuk module yang sama berkali-kali.

- **Sintaks Dasar**:

  ```lua
  -- Memuat module bernama 'my_module.lua'
  local my_module = require("my_module")

  -- Memuat module dari subdirektori
  -- Tanda titik '.' digunakan sebagai pemisah direktori
  local player_core = require("lib.player.core")
  ```

  Perhatikan bahwa Anda tidak menyertakan ekstensi `.lua` dalam string `require`.

- **Konsep Mendetail**:

  1.  **Path Resolution (Resolusi Path)**: Bagaimana `require` menemukan file Anda? Ia mencari di dalam sebuah variabel global bernama `package.path`. Ini adalah string yang berisi daftar pola lokasi file, dipisahkan oleh titik koma (`;`). Tanda tanya (`?`) di setiap pola akan digantikan oleh nama module yang Anda berikan.
      - Anda bisa melihat path default di sistem Anda dengan menjalankan: `print(package.path)`
  2.  **Mekanisme Caching**: `require` menggunakan sebuah tabel internal bernama `package.loaded`. Ketika Anda me-`require` sebuah module untuk pertama kalinya:
      a. Lua akan mencari file module.
      b. Jika ditemukan, Lua akan menjalankan kode di dalam file tersebut.
      c. Nilai yang dikembalikan (`return`) oleh module akan disimpan di `package.loaded["nama_module"]`.
      d. Nilai ini kemudian dikembalikan oleh fungsi `require`.
      Setiap panggilan `require` berikutnya untuk "nama_module" yang sama akan langsung mengembalikan nilai dari `package.loaded["nama_module"]` tanpa menjalankan ulang kode di dalam file. Ini sangat efisien.

- **Diagram Alur `require("my_module")`**:

  ```
  Start
    |
    v
  Apakah "my_module" ada di package.loaded (cache)?
    |
    +-- YA --> Kembalikan nilai dari cache. --> End
    |
    NO
    |
    v
  Cari file menggunakan package.path (misal, "my_module.lua")?
    |
    +-- TIDAK DITEMUKAN --> Error: module not found. --> End
    |
    DITEMUKAN
    |
    v
  Jalankan kode dalam file "my_module.lua".
    |
    v
  Ambil nilai yang di-'return' oleh module.
    |
    v
  Simpan nilai return ke dalam package.loaded["my_module"].
    |
    v
  Kembalikan nilai tersebut.
    |
    v
  End
  ```

- **Sumber**:

  - [Lua 5.4 Reference Manual - require](https://www.lua.org/manual/5.4/manual.html#pdf-require)
  - [Learn Lua in Y Minutes - Modules](https://learnxinyminutes.com/docs/lua/)

---

## Tingkat 2: Implementasi Module Sederhana

Sekarang kita akan mempraktikkan teori dengan membuat module kita sendiri.

### 2.1 Membuat Module Pertama

- **Deskripsi Konkret**:
  Cara paling umum untuk membuat module di Lua adalah dengan membuat sebuah tabel, mengisi tabel tersebut dengan fungsi dan data yang ingin Anda "ekspor", lalu mengembalikan tabel tersebut di akhir file.

- **Struktur Dasar dan Sintaks**:
  Mari kita buat module matematika sederhana bernama `vector.lua`.

  **File: `vector.lua`**

  ```lua
  -- 1. Buat tabel lokal yang akan menjadi 'tubuh' module kita.
  --    Menggunakan 'local' sangat penting!
  local Vector = {}

  -- 2. Definisikan fungsi atau data di dalam tabel tersebut.
  --    Ini adalah fungsi yang bisa diakses dari luar.
  function Vector.new(x, y)
    return {x = x, y = y}
  end

  function Vector.add(v1, v2)
    return Vector.new(v1.x + v2.x, v1.y + v2.y)
  end

  -- 3. Di akhir file, kembalikan tabel module tersebut.
  return Vector
  ```

  **File: `main.lua` (yang menggunakan module kita)**

  ```lua
  -- Muat module vector.lua
  local vector = require("vector")

  -- Gunakan fungsi dari module
  local vec1 = vector.new(10, 5)
  local vec2 = vector.new(3, 8)
  local vec3 = vector.add(vec1, vec2)

  print("Hasil penjumlahan vektor: x=" .. vec3.x .. ", y=" .. vec3.y)
  -- Output: Hasil penjumlahan vektor: x=13, y=13
  ```

- **Sumber**:

  - [Lua Tutorial - Creating Modules](https://www.tutorialspoint.com/lua/lua_modules.htm)
  - [ZeroBrane Studio - Module Tutorial](https://studio.zerobrane.com/doc-lua-modules)

### 2.2 Local vs Global dalam Module (Enkapsulasi)

- **Deskripsi Konkret**:
  **Enkapsulasi** adalah konsep OOP yang juga sangat relevan di sini. Ini berarti menyembunyikan detail implementasi internal dari sebuah module dan hanya mengekspos apa yang diperlukan. Di Lua, ini dicapai dengan kata kunci `local`.

  - **Variabel `local`**: Hanya dapat diakses di dalam file (atau blok kode) tempat ia didefinisikan. Ini adalah "private member" Anda.
  - **Variabel Global**: Jika Anda lupa menulis `local`, variabel tersebut akan menjadi global. Ini artinya, ia bisa diakses dan diubah oleh _semua_ file lain dalam proyek Anda. Ini sangat berbahaya dan harus dihindari karena dapat menyebabkan "polusi global" dan bug yang tidak terduga. Di Dart, tidak ada konsep global seperti ini secara default, yang membuatnya lebih aman.

- **Contoh Kode**:
  Mari kita perbarui module `vector.lua` dengan konstanta "private".

  **File: `vector.lua`**

  ```lua
  local Vector = {}

  -- Konstanta ini 'private' untuk module. Tidak bisa diakses dari main.lua
  local DEFAULT_MAGNITUDE = 1

  -- Fungsi ini juga 'private'. Ia hanya helper untuk fungsi lain di dalam module ini.
  local function format_vector(v)
    return "x=" .. v.x .. ", y=" .. v.y
  end

  function Vector.new(x, y)
    return {x = x or 0, y = y or 0} -- Memberi nilai default jika x atau y nil
  end

  function Vector.add(v1, v2)
    return Vector.new(v1.x + v2.x, v1.y + v2.y)
  end

  -- Fungsi 'public' ini menggunakan helper 'private'
  function Vector.display(v)
    print(format_vector(v))
  end

  return Vector
  ```

  **File: `main.lua`**

  ```lua
  local vector = require("vector")
  local my_vec = vector.new(5, 5)

  vector.display(my_vec) -- OK! Ini fungsi public. Output: x=5, y=5

  -- Ini akan menyebabkan error, karena format_vector adalah local di dalam module.
  -- print(vector.format_vector(my_vec)) --> ERROR: attempt to call a nil value

  -- Ini juga akan nil, karena DEFAULT_MAGNITUDE adalah local.
  -- print(vector.DEFAULT_MAGNITUDE) --> nil
  ```

- **Sumber**:

  - [Programming in Lua - Privacy](https://www.lua.org/pil/15.3.html)
  - [Lua-users Wiki: Scoping](http://lua-users.org/wiki/ScopeTutorial)

### 2.3 Module Return Patterns

- **Deskripsi Konkret**:
  Meskipun mengembalikan tabel adalah pola yang paling umum (95% kasus), sebuah module di Lua secara teknis dapat mengembalikan **nilai apa pun**. Ini memberikan fleksibilitas, tetapi juga bisa membingungkan jika tidak digunakan dengan bijak.

- **Pola-pola yang Umum**:

  1.  **Mengembalikan Tabel (Pola Paling Umum)**: Seperti yang sudah kita lihat. Ideal untuk mengelompokkan banyak fungsi.
  2.  **Mengembalikan Fungsi (Pola "Constructor" atau "Factory")**: Berguna jika module Anda hanya memiliki satu tujuan utama, yaitu membuat sesuatu.
      **File: `create_character.lua`**
      ```lua
      -- Module ini mengembalikan satu fungsi saja.
      return function(name, class)
        local character = {
          name = name,
          class = class,
          hp = 100
        }
        return character
      end
      ```
      **File: `main.lua`**
      ```lua
      local create_character = require("create_character")
      local hero = create_character("Aragorn", "Ranger")
      print(hero.name) -- Output: Aragorn
      ```
  3.  **Mengembalikan Nilai Tunggal**: Bisa berupa string (misalnya, module konfigurasi) atau angka. Jarang digunakan, tapi mungkin.

- **Sumber**:

  - [Lua Patterns - Module Patterns](http://lua-users.org/wiki/ModulePattern)

---

## Tingkat 3: Teknik Advanced Module

Di sini, kompleksitas mulai meningkat. Topik-topik ini akan memberi Anda kekuatan lebih dalam mendesain module yang canggih dan efisien.

### 3.1 Module dengan State Management

- **Deskripsi Konkret**:
  Terkadang, Anda ingin sebuah module memiliki "state" atau "keadaan" internal yang bertahan di seluruh program. Karena `require` hanya menjalankan module sekali, variabel lokal di dalam module akan tetap ada di memori. Ini dapat digunakan untuk mengimplementasikan pola seperti **Singleton**.

  - **Terminologi**:
    - **Singleton Pattern**: Sebuah pola desain yang memastikan sebuah "kelas" hanya memiliki satu instansi (objek) dan menyediakan titik akses global ke instansi tersebut. Dalam konteks Lua, ini berarti module yang selalu merepresentasikan entitas yang sama.

- **Contoh Kode (Singleton untuk Game Settings)**:
  **File: `game_settings.lua`**

  ```lua
  -- Tabel ini akan menyimpan state kita.
  local settings = {
      volume = 80,
      difficulty = "normal"
  }

  -- Module yang kita return adalah 'interface' untuk mengubah state.
  local SettingsManager = {}

  function SettingsManager.set_volume(vol)
      -- Batasi volume antara 0 dan 100
      settings.volume = math.max(0, math.min(100, vol))
      print("Volume diatur ke: " .. settings.volume)
  end

  function SettingsManager.get_volume()
      return settings.volume
  end

  function SettingsManager.set_difficulty(diff)
      settings.difficulty = diff
  end

  function SettingsManager.get_settings()
      -- Mengembalikan salinan agar state asli tidak bisa diubah sembarangan dari luar
      return { volume = settings.volume, difficulty = settings.difficulty }
  end

  return SettingsManager
  ```

  Di file lain, setiap kali Anda `require("game_settings")`, Anda akan mendapatkan `SettingsManager` yang sama dan berinteraksi dengan tabel `settings` internal yang sama.

- **Sumber**:

  - [Lua-users Wiki: Singleton Pattern](http://lua-users.org/wiki/SingletonPattern)

### 3.2 Metatable dalam Modules

- **Deskripsi Konkret**:
  **Metatables** adalah salah satu fitur paling kuat dan unik di Lua. Mereka memungkinkan Anda untuk mengubah perilaku sebuah tabel. Dalam konteks module, ini bisa digunakan untuk hal-hal canggih seperti membuat module yang seolah-olah bisa dipanggil seperti fungsi, atau untuk implementasi yang mirip dengan "class-based inheritance".

  - **Terminologi**:
    - **Metatable**: Sebuah tabel biasa yang berisi "meta-method".
    - **Metamethod**: Kunci khusus dalam metatable (seperti `__index`, `__newindex`, `__call`) yang akan dipanggil oleh Lua ketika operasi tertentu dilakukan pada tabel utama.
    - `__index`: Ini adalah metamethod yang paling sering digunakan. Jika Anda mencoba mengakses field yang tidak ada di dalam sebuah tabel, Lua akan memeriksa apakah tabel itu punya metatable dengan field `__index`. Jika ada, Lua akan mencari field yang hilang itu di dalam `__index`. Ini adalah dasar dari "inheritance" atau pewarisan di Lua.

- **Contoh Kode (Module sebagai "Class")**:
  Ini adalah pola yang sangat umum untuk meniru OOP di Lua.
  **File: `character.lua`**

  ```lua
  local Character = {}
  Character.__index = Character -- Arahkan __index ke diri sendiri. Ini trik kuncinya.

  -- Ini akan menjadi 'constructor' kita
  function Character.new(name)
    -- Buat instansi baru (sebuah tabel)
    local instance = {
      name = name,
      hp = 100
    }
    -- Atur metatable instansi ke 'class' kita (Character)
    setmetatable(instance, Character)
    return instance
  end

  -- Ini adalah 'method'
  function Character:take_damage(amount)
    self.hp = self.hp - amount
    print(self.name .. " menerima " .. amount .. " damage, sisa HP: " .. self.hp)
  end

  return Character
  ```

  **File: `main.lua`**

  ```lua
  local Character = require("character")

  local gandalf = Character.new("Gandalf")
  local balrog = Character.new("Balrog")

  -- Bagaimana ini bekerja?
  -- 1. Kita memanggil gandalf:take_damage(50)
  -- 2. Lua mencari 'take_damage' di dalam tabel 'gandalf'. Tidak ditemukan.
  -- 3. Lua melihat 'gandalf' punya metatable. Ia mencari metamethod '__index'.
  -- 4. __index menunjuk ke tabel 'Character'.
  -- 5. Lua mencari 'take_damage' di dalam tabel 'Character'. Ditemukan!
  -- 6. Lua memanggil fungsi tersebut. ':' memastikan 'self' adalah 'gandalf'.
  gandalf:take_damage(50) -- Output: Gandalf menerima 50 damage, sisa HP: 50
  balrog:take_damage(30) -- Output: Balrog menerima 30 damage, sisa HP: 70
  ```

  Pola ini sangat mirip dengan `class` di Dart. `Character` adalah "kelas", `Character.new` adalah "constructor", dan `gandalf` adalah "instansi". `__index` adalah mekanisme yang meniru pewarisan method.

- **Sumber**:

  - [Programming in Lua - Metatables](https://www.lua.org/pil/13.html)
  - [Lua-users Wiki: Metatables Tutorial](http://lua-users.org/wiki/MetatablesTutorial)

### 3.3 Lazy Loading dan Dynamic Loading

- **Deskripsi Konkret**:
  **Lazy Loading** adalah teknik untuk menunda pemuatan (`require`) sebuah module sampai ia benar-benar dibutuhkan. Ini sangat berguna untuk optimasi, terutama saat startup aplikasi. Daripada memuat 50 module di awal yang mungkin tidak semuanya langsung dipakai, Anda hanya memuatnya saat fungsi yang relevan dipanggil.

- **Contoh Kode**:
  Tanpa lazy loading:

  ```lua
  -- Semua dimuat di awal, meskipun kita mungkin hanya butuh satu.
  local json_parser = require("parsers.json")
  local xml_parser = require("parsers.xml")
  local csv_parser = require("parsers.csv")
  ```

  Dengan lazy loading:

  ```lua
  local parsers = {}
  function parsers.get(parser_type)
      if parser_type == "json" then
          -- Module baru di-require saat pertama kali dibutuhkan.
          if not parsers.json_parser then
              parsers.json_parser = require("parsers.json")
          end
          return parsers.json_parser
      elseif parser_type == "xml" then
          if not parsers.xml_parser then
              parsers.xml_parser = require("parsers.xml")
          end
          return parsers.xml_parser
      end
      -- ... dan seterusnya
  end

  -- Tidak ada module yang dimuat di sini.
  -- ... kode lain berjalan ...

  -- Baru di sini, saat kita butuh, 'parsers.json' akan dimuat.
  local my_json_parser = parsers.get("json")
  my_json_parser.parse("{'data': true}")
  ```

- **Sumber**:

  - [Lua Performance Tips - Modules](http://lua-users.org/wiki/OptimisationTips)

### 3.4 Custom Module Loaders

- **Deskripsi Konkret**:
  Ini adalah topik yang sangat canggih. Anda bisa mengganti atau memperluas cara kerja `require` itu sendiri. Lua menyimpan daftar fungsi "loader" di dalam tabel `package.loaders` (atau `package.searchers` di versi lebih baru). Saat `require("mod")` dipanggil, Lua akan mencoba setiap loader ini secara berurutan sampai salah satu berhasil memuat module. Anda bisa menyisipkan fungsi loader Anda sendiri ke dalam tabel ini untuk memuat module dari lokasi non-standar, seperti dari jaringan, database, atau file terkompresi.

- **Sumber**:

  - [Lua Custom Module Loaders (pada Tutorialspoint)](https://www.tutorialspoint.com/lua/lua_custom_module_loaders.htm) - _Perlu dicatat, Tutorialspoint baik untuk pengenalan, tetapi sumber resmi (buku PiL atau manual Lua) lebih akurat untuk detailnya._
  - [Loadkit](https://github.com/leafo/loadkit) - Sebuah library yang mempermudah pembuatan loader kustom.

---

## Tingkat 4: Package Management

Setelah Anda bisa membuat module, langkah selanjutnya adalah menggunakan module yang dibuat oleh orang lain dan mengelola dependensi tersebut secara efisien.

### 4.1 LuaRocks - Package Manager

- **Deskripsi Konkret**:
  Jika Dart punya `pub` dan Node.js punya `npm`, maka Lua punya **LuaRocks**. Ini adalah manajer paket standar de-facto untuk Lua. Sebuah "paket" di sini disebut **Rock**. LuaRocks membantu Anda untuk:

  1.  **Mencari** library (Rock) yang tersedia.
  2.  **Menginstal** library dengan satu perintah.
  3.  **Mengelola dependensi** (jika Rock A butuh Rock B, LuaRocks akan menginstal keduanya).
  4.  **Membuat** dan **mempublikasikan** Rock Anda sendiri.

- **Terminologi dan Perintah Dasar**:

  - **Rock**: Sebuah paket/library Lua.
  - **Rockspec**: Sebuah file metadata (`.rockspec`) yang mendeskripsikan sebuah Rock: namanya, versinya, dependensinya, dan bagaimana cara menginstalnya. Mirip dengan `pubspec.yaml` di Dart.
  - `luarocks install <nama_rock>`: Menginstal rock. Contoh: `luarocks install penlight`.
  - `luarocks search <kata_kunci>`: Mencari rock. Contoh: `luarocks search json`.
  - `luarocks remove <nama_rock>`: Menghapus rock.
  - `luarocks make`: Membuat dan menginstal rock dari file rockspec lokal.

- **Bagaimana Cara Kerjanya?**:
  Saat Anda menginstal sebuah rock, LuaRocks akan menempatkan file `.lua` di lokasi yang sudah diketahui oleh `package.path` Lua, dan file C (jika ada) di lokasi yang diketahui oleh `package.cpath`. Dengan begitu, setelah instalasi, Anda bisa langsung `require("nama_rock")` di kode Anda tanpa konfigurasi tambahan.

- **Sumber**:

  - [LuaRocks Official Website & Documentation](https://luarocks.org/)
  - [Creating a Rockspec](https://github.com/luarocks/luarocks/wiki/Creating-a-rock)

### 4.2 Package Search Paths (LUA_PATH)

- **Deskripsi Konkret**:
  Seperti yang dibahas di Tingkat 1, `require` mencari file berdasarkan `package.path` (untuk file Lua) dan `package.cpath` (untuk library C). Terkadang Anda perlu mengubah path ini, misalnya jika Anda menyimpan semua module proyek di direktori `src/` dan ingin `require("mymodule")` bekerja tanpa harus menulis `require("src.mymodule")`.

- **Cara Memodifikasi Path**:

  1.  **Variabel Lingkungan (Environment Variable)**: Cara paling umum. Anda bisa mengatur variabel `LUA_PATH` dan `LUA_CPATH` sebelum menjalankan skrip Lua Anda.
      - Di Linux/macOS: `export LUA_PATH="./src/?.lua;;"`
      - Di Windows: `set LUA_PATH=.\src\?.lua;;`
      - `./src/?.lua` berarti "cari file `.lua` di dalam direktori `src`".
      - `;;` berarti "setelah itu, cari juga di path default".
  2.  **Dalam Kode Lua**: Anda juga bisa memodifikasinya langsung di dalam skrip Anda (harus dilakukan sebelum `require` pertama). Ini kurang fleksibel tetapi berguna untuk distribusi aplikasi.
      ```lua
      -- Menambahkan direktori 'modules' ke awal path
      package.path = './modules/?.lua;' .. package.path
      local my_mod = require("my_mod_in_modules_folder")
      ```

- **Sumber**:

  - [Lua Manual - package.path](https://www.google.com/search?q=https://www.lua.org/manual/5.4/manual.html%23var-package.path)

---

## Dan Seterusnya (hingga Tingkat 10)

Kurikulum Anda berlanjut ke topik yang lebih canggih, yang semuanya membangun di atas fondasi ini. Berikut adalah ringkasan singkat tentang apa yang akan Anda pelajari di tingkat selanjutnya, dengan pendekatan yang sama:

- **Tingkat 5 (Struktur Project Advanced)**: Fokus pada bagaimana mengorganisir proyek besar. `init.lua` adalah file khusus yang akan dijalankan ketika Anda me-`require` sebuah direktori. Anda akan belajar cara menghindari "polusi global" secara disiplin dan mengelola konfigurasi untuk lingkungan yang berbeda (development, production).

- **Tingkat 6 (Debugging dan Testing)**: Sangat krusial. Anda akan belajar menggunakan framework seperti **Busted** untuk menulis unit test (mirip `package:test` di Dart) untuk memastikan module Anda bekerja dengan benar. Anda juga akan belajar mendiagnosis masalah umum seperti _circular dependencies_ (module A butuh B, dan B butuh A).

- **Tingkat 7 (C Extensions dan FFI)**: Ini adalah lompatan besar. Ketika performa menjadi sangat kritis atau Anda perlu menggunakan library C yang sudah ada, Anda punya dua pilihan:

  1.  **Lua C API**: Menulis kode C "lem" untuk mengekspos fungsi C ke Lua. Ini sangat kuat tapi rumit.
  2.  **FFI (Foreign Function Interface)**: Fitur dari **LuaJIT** (Just-In-Time compiler untuk Lua) yang memungkinkan Anda memanggil fungsi dari library C (`.dll`, `.so`) _langsung dari kode Lua_ tanpa menulis C. Ini jauh lebih mudah dan seringkali cukup cepat.

- **Tingkat 8 (Best Practices dan Patterns)**: Ini tentang menulis kode yang "idiomatic" dan elegan. Anda akan mempelajari pola desain (Factory, Observer) dalam konteks Lua dan cara mendesain API module yang bersih dan mudah digunakan oleh orang lain, termasuk cara mendokumentasikannya dengan alat seperti **LDoc**.

- **Tingkat 9 (Real-world Applications)**: Menganalisis kode dari proyek nyata seperti framework web **Lapis** atau game engine **LÖVE**. Ini akan menunjukkan bagaimana semua konsep yang telah Anda pelajari digabungkan dalam perangkat lunak skala besar.

- **Tingkat 10 (Mastery Projects)**: Proyek puncak untuk membuktikan penguasaan Anda. Mencoba membuat package manager sederhana atau arsitektur plugin akan memaksa Anda untuk memahami cara kerja sistem module di tingkat yang paling dalam.

### Audit Akhir dan Rekomendasi

Kurikulum ini, setelah dilengkapi dengan penjelasan mendetail, contoh kode, dan konteks seperti di atas, akan menjadi sumber daya yang sangat kuat untuk membawa Anda dari pemahaman dasar hingga penguasaan total atas sistem module dan package di Lua.

**Saran Terakhir**:

1.  **Praktik, Praktik, Praktik**: Untuk setiap konsep, buat file `.lua` kecil dan coba sendiri. Ubah kodenya, lihat apa yang terjadi.
2.  **Baca Kode Orang Lain**: Setelah Anda nyaman dengan dasar-dasarnya, buka GitHub dan cari library Lua yang populer (misalnya, `penlight`, `middleclass`). Baca kodenya dan coba pahami bagaimana mereka menstrukturkan module dan API mereka.
3.  **Gunakan IDE yang Tepat**: Seperti yang disarankan kurikulum, gunakan [VSCode dengan ekstensi Lua](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) atau [ZeroBrane Studio](https://studio.zerobrane.com/). Fitur seperti auto-completion dan go-to-definition akan sangat membantu saat menavigasi proyek dengan banyak module.

## Tingkat 5: Struktur Project Advanced

Pada tingkat ini, kita beralih dari membuat module individual ke merancang arsitektur keseluruhan dari sebuah aplikasi besar. Ini adalah tentang bagaimana semua module Anda bekerja sama secara harmonis.

### 5.1 Proyek Multi-file

- **Deskripsi Konkret**:
  Saat proyek tumbuh, Anda akan memiliki puluhan atau bahkan ratusan file. Mengelola ini membutuhkan lebih dari sekadar meletakkan semuanya dalam satu folder `lib/`. Anda akan mulai membuat sub-sistem, di mana setiap sub-sistem adalah sebuah direktori yang berisi beberapa module terkait.

- **Konsep Kunci: `init.lua`**
  `init.lua` adalah sebuah file dengan nama khusus. Jika Anda memiliki direktori bernama `player`, dan di dalamnya ada file `init.lua`, maka saat Anda menjalankan `require("player")`, Lua akan secara otomatis memuat `player/init.lua`. Ini memungkinkan sebuah direktori untuk bertindak seolah-olah ia adalah sebuah module tunggal.

- **Contoh Struktur dan Kode**:
  Bayangkan struktur direktori berikut:

  ```
  my_game/
  ├── main.lua
  └── lib/
      └── player/
          ├── init.lua
          ├── inventory.lua
          └── stats.lua
  ```

  **File: `lib/player/inventory.lua`**

  ```lua
  local Inventory = {}
  function Inventory.add_item(item) print("Menambahkan item: " .. item) end
  return Inventory
  ```

  **File: `lib/player/stats.lua`**

  ```lua
  local Stats = {}
  function Stats.increase_strength() print("Kekuatan bertambah!") end
  return Stats
  ```

  **File: `lib/player/init.lua` (File "Agregator")**

  ```lua
  -- init.lua bertugas mengumpulkan bagian-bagian lain dari sub-sistem 'player'
  -- dan menyajikannya sebagai satu module yang kohesif.

  local Player = {}

  -- Muat module lain yang berada di direktori yang sama
  -- 'player.inventory' karena Lua tahu kita berada dalam konteks 'player'
  Player.inventory = require("lib.player.inventory")
  Player.stats = require("lib.player.stats")

  function Player.new(name)
      print("Player " .. name .. " diciptakan.")
      return { name = name }
  end

  -- Kembalikan tabel 'Player' yang sudah dirakit
  return Player
  ```

  **File: `main.lua`**

  ```lua
  -- Kita hanya perlu me-require 'player'.
  -- Lua akan menemukan dan memuat 'lib/player/init.lua'.
  package.path = './lib/?.lua;' .. package.path -- Pastikan Lua tahu di mana mencari 'lib'

  local Player = require("player")

  local hero = Player.new("Lancelot") -- Dari init.lua
  Player.inventory.add_item("Excalibur") -- Dari inventory.lua
  Player.stats.increase_strength()     -- Dari stats.lua
  ```

  Pola ini sangat kuat untuk membangun library atau framework. Direktori menjadi unit organisasi utama.

- **Sumber**:

  - [Lua-users Wiki: Large Lua Projects](http://lua-users.org/wiki/LuaProjects)
  - [GitHub: Awesome Lua Projects](https://github.com/LewisJEllis/awesome-lua) (untuk melihat contoh nyata)

### 5.2 Manajemen Namespace

- **Deskripsi Konkret**:
  Ini adalah tentang disiplin untuk menjaga "ruang kerja" Anda tetap bersih. Seperti yang telah dibahas, masalah terbesar dalam program Lua yang tidak terstruktur adalah **polusi global**, yaitu ketika variabel atau fungsi secara tidak sengaja dibuat dalam scope global.

- **Konsep Kunci: Tabel Global `_G`**
  Di Lua, semua variabel global sebenarnya adalah field di dalam sebuah tabel khusus bernama `_G`. Saat Anda menulis `my_var = 10` (tanpa `local`), Anda sebenarnya sedang melakukan `_G.my_var = 10`. Memahami ini membuat bahaya polusi global menjadi sangat nyata.

- **Praktik Pencegahan**:

  1.  **Selalu Gunakan `local`**: Ini adalah aturan nomor satu. Biasakan diri Anda untuk selalu mengetik `local` sebelum deklarasi variabel baru.
  2.  **Module Pattern**: Dengan menggunakan pola module (`local M = {}; return M`), Anda secara inheren menghindari variabel global karena semua yang Anda definisikan bersifat `local` di dalam file atau merupakan field dari tabel `M` yang juga `local`.

  **Contoh Buruk (Polusi Global)**:

  ```lua
  -- file: utils.lua
  function helper_function()
      -- ...
  end
  -- 'helper_function' sekarang ada di _G.helper_function
  ```

  **Contoh Baik (Enkapsulasi)**:

  ```lua
  -- file: utils.lua
  local Utils = {}
  function Utils.helper_function()
      -- ...
  end
  return Utils
  ```

- **Sumber**:

  - [Lua-users Wiki: Namespaces](http://lua-users.org/wiki/NamespaceTutorial)
  - [Programming in Lua - Avoiding Global Variables](https://www.lua.org/pil/14.2.html)

### 5.3 Module Konfigurasi dan Lingkungan

- **Deskripsi Konkret**:
  Aplikasi Anda kemungkinan akan berjalan di lingkungan yang berbeda: di mesin Anda (**development**), di server pengujian (**testing**), dan untuk pengguna akhir (**production**). Setiap lingkungan mungkin memerlukan konfigurasi yang berbeda (misalnya, database yang berbeda, level logging, kunci API).

- **Pola Desain**:
  Strategi yang umum adalah memiliki satu module konfigurasi utama yang memuat konfigurasi spesifik lingkungan berdasarkan variabel lingkungan sistem (`environment variable`).

- **Contoh Kode**:
  Struktur file:

  ```
  config/
  ├── init.lua
  ├── development.lua
  └── production.lua
  ```

  **File: `config/development.lua`**

  ```lua
  return {
      database_host = "localhost",
      log_level = "debug",
      api_key = "DEV_API_KEY"
  }
  ```

  **File: `config/production.lua`**

  ```lua
  return {
      database_host = "prod.db.server.com",
      log_level = "warn",
      api_key = "PROD_API_KEY"
  }
  ```

  **File: `config/init.lua` (Loader Konfigurasi)**

  ```lua
  -- 1. Baca environment variable 'APP_ENV'. Default ke 'development'.
  local env = os.getenv("APP_ENV") or "development"

  print("Memuat konfigurasi untuk lingkungan: " .. env)

  -- 2. Bangun path ke module konfigurasi yang sesuai.
  local config_path = "config." .. env

  -- 3. Muat dan kembalikan konfigurasi tersebut.
  -- pcall digunakan untuk menangani error jika file config tidak ada.
  local success, config_data = pcall(require, config_path)
  if not success then
      error("Gagal memuat konfigurasi: " .. config_path)
  end

  return config_data
  ```

  **Cara Menggunakan**:
  Di terminal (sebelum menjalankan aplikasi):
  `export APP_ENV=production`
  `lua main.lua`

  Di dalam `main.lua`:
  `local config = require("config")`
  `print("Database host:", config.database_host)` --\> akan mencetak `prod.db.server.com`

- **Sumber**:

  - [12 Factor App - Config](https://12factor.net/config) (Ini adalah prinsip desain aplikasi umum, bukan spesifik Lua, tapi sangat relevan)

### 5.4 Module Hot-Reloading dan Live Updates

- **Deskripsi Konkret**:
  **Hot-reloading** adalah kemampuan untuk memperbarui kode module di aplikasi yang sedang berjalan _tanpa harus me-restart seluruh aplikasi_. Ini sangat berharga dalam game development (Anda bisa mengubah perilaku musuh saat game berjalan) atau pengembangan web (memperbarui logika endpoint tanpa downtime).

- **Tantangan Utama**:
  Seperti yang dibahas sebelumnya, `require` melakukan caching. Untuk me-reload sebuah module, Anda harus secara manual menghapus entri module tersebut dari `package.loaded`.

- **Implementasi Sederhana**:

  ```lua
  function hot_reload(module_name)
      print("Mencoba me-reload module: " .. module_name)
      -- Hapus cache untuk module ini
      package.loaded[module_name] = nil
      -- Panggil require lagi untuk memuat versi baru dari file
      local success, reloaded_module = pcall(require, module_name)

      if success then
          print("Module berhasil di-reload.")
          return reloaded_module
      else
          print("Error saat me-reload: " .. tostring(reloaded_module))
          return nil
      end
  end

  -- Contoh penggunaan
  local my_module = require("my_module")
  my_module.do_something()

  -- (Sekarang, Anda pergi dan mengubah file 'my_module.lua')

  -- Lakukan hot-reload
  my_module = hot_reload("my_module")
  my_module.do_something() -- Sekarang akan menjalankan versi baru!
  ```

- **Masalah State (Keadaan)**: Fungsi di atas me-reload kode, tetapi jika module Anda memiliki state (seperti pada contoh `game_settings`), state tersebut akan hilang dan direset ke nilai awal. Menjaga state selama hot-reload adalah masalah yang kompleks dan biasanya memerlukan arsitektur di mana state dan logika dipisahkan.

- **Sumber**:

  - [Lua Hot Reload Techniques](http://lua-users.org/wiki/HotCodeReloading)

---

## Tingkat 6: Debugging dan Testing Modules

Menulis kode hanyalah setengah dari pekerjaan. Memastikan kode itu benar dan memperbaikinya ketika salah adalah setengahnya lagi.

### 6.1 Strategi Testing Module

- **Deskripsi Konkret**:
  **Unit Testing** adalah proses menguji unit terkecil dari kode Anda (dalam hal ini, sebuah module) secara terisolasi untuk memverifikasi bahwa ia bekerja seperti yang diharapkan. Ini memberi Anda kepercayaan diri untuk mengubah kode karena Anda dapat dengan cepat memvalidasi bahwa perubahan Anda tidak merusak fungsionalitas yang ada.

- **Alat Utama: Busted**
  [Busted](https://olivinelabs.com/busted/) adalah framework testing yang populer dan ekspresif untuk Lua.

- **Contoh Kode (Testing dengan Busted)**:
  **File: `calculator.lua`**

  ```lua
  local M = {}
  function M.add(a, b) return a + b end
  return M
  ```

  **File: `spec/calculator_spec.lua` (File Test)**

  ```lua
  -- Muat 'busted'
  local busted = require("busted")
  -- Muat module yang akan diuji
  local calculator = require("calculator")

  -- 'describe' mengelompokkan tes untuk sebuah module
  busted.describe("Calculator Module", function()
      -- 'it' mendefinisikan sebuah test case spesifik
      busted.it("should add two numbers correctly", function()
          -- 'assert.are.equal' memverifikasi bahwa dua nilai sama
          busted.assert.are.equal(4, calculator.add(2, 2))
          busted.assert.are.equal(-1, calculator.add(5, -6))
      end)
  end)
  ```

  Anda kemudian menjalankan Busted dari terminal (`busted`), dan ia akan secara otomatis menemukan dan menjalankan file `_spec.lua` Anda.

- **Konsep Kunci: Mocking Dependencies**
  Jika module Anda bergantung pada module lain (misalnya, module yang mengakses database), Anda tidak ingin tes Anda benar-benar terhubung ke database. **Mocking** adalah teknik mengganti dependensi nyata dengan versi palsu yang terkontrol selama tes. Busted memiliki dukungan bawaan untuk ini.

- **Sumber**:

  - [Busted - Lua Testing Framework](https://olivinelabs.com/busted/)
  - [LuaUnit Testing Framework](https://github.com/bluebird75/luaunit) (Alternatif untuk Busted)

### 6.2 Debugging Masalah Module

- **Deskripsi Konkret**:
  Beberapa bug spesifik sering muncul saat bekerja dengan module. Mengetahui apa yang harus dicari dapat menghemat waktu berjam-jam.

- **Masalah Umum: Circular Dependencies (Dependensi Melingkar)**

  - **Apa itu?**: Terjadi ketika `module A` me-`require` `module B`, tetapi `module B` juga me-`require` `module A`.
  - **Gejala**: Ini adalah bug yang terkenal membingungkan. Saat `B` mencoba me-`require` `A`, `A` belum selesai memuat. Lua, untuk mencegah loop tak terbatas, akan mengembalikan "objek module awal" `A` yang masih kosong (`{}`) ke `B`. Akibatnya, `B` akan mendapatkan versi `A` yang tidak lengkap, dan kode Anda akan gagal dengan error seperti `attempt to index a nil value`.
  - **Visualisasi Alur Gagal**:
    1.  `main.lua` memanggil `require('A')`.
    2.  Eksekusi `A.lua` dimulai. Lua menempatkan penanda "sedang memuat" untuk `A` di `package.loaded`.
    3.  `A.lua` memanggil `require('B')`. Eksekusi `A.lua` dijeda.
    4.  Eksekusi `B.lua` dimulai.
    5.  `B.lua` memanggil `require('A')`.
    6.  **Masalah**: Lua melihat penanda "sedang memuat" untuk `A`. Daripada memulai ulang, ia langsung mengembalikan nilai yang ada di `package.loaded` untuk `A`, yang saat ini hanyalah sebuah tabel kosong.
    7.  `B.lua` selesai dieksekusi, menggunakan tabel `A` yang kosong.
    8.  Eksekusi kembali ke `A.lua`. Ia menerima module `B` yang sudah jadi.
    9.  `A.lua` selesai. Tapi sudah terlambat, `B` sudah terlanjur dibuat dengan versi `A` yang rusak.
  - **Solusi**:
    - **Refaktor**: Desain ulang dependensi Anda. Mungkin ada konsep C yang bisa diekstraksi ke `module C`, yang kemudian dibutuhkan oleh A dan B.
    - **`require` Lokal**: Tunda `require` di dalam fungsi yang membutuhkannya, bukan di tingkat atas file. Ini seringkali bisa memutus siklus.

- **Sumber**:

  - [Lua Debug Library](https://www.lua.org/manual/5.4/manual.html#6.5) (untuk debugging tingkat lanjut)
  - [ZeroBrane Studio Debugger](https://studio.zerobrane.com/doc-lua-debugging) (debugger visual sangat membantu)

### 6.3 Performance Profiling

- **Deskripsi Konkret**:
  **Profiling** adalah proses mengukur kode Anda untuk menemukan "hotspots" – bagian yang paling banyak menghabiskan waktu (CPU) atau memori. Saat bekerja dengan module, Anda mungkin ingin memprofil:

  - Waktu muat (`require`) saat startup.
  - Fungsi mana di dalam module yang paling sering dipanggil dan paling lambat.
  - Berapa banyak memori yang digunakan oleh module Anda.

- **Alat**:

  - **LuaJIT Profiler**: Jika Anda menggunakan LuaJIT (yang sangat disarankan untuk aplikasi yang mementingkan performa), ia memiliki profiler bawaan yang sangat kuat.
  - **Script Profiler Sederhana**: Anda dapat menulis profiler sederhana menggunakan `debug.sethook()` dan `os.clock()` untuk mengukur waktu eksekusi.

- **Sumber**:

  - [Lua Profiling Tools](http://lua-users.org/wiki/ProfilingLuaCode)
  - [LuaJIT Profiler](https://luajit.org/ext_profiler.html)

Langkah selanjutnya adalah Tingkat 7, di mana kita akan memasuki dunia C dan berinteraksi dengan kode di luar Lua. Ini adalah area yang sangat kuat untuk optimasi dan integrasi.

## Tingkat 7: C Extensions dan Foreign Modules

Ini adalah tingkat di mana Anda melampaui batas Lua murni. Anda akan belajar cara "mengikat" (binding) kode C ke dalam Lua. Ini dilakukan karena dua alasan utama: **performa** (operasi matematis berat atau pemrosesan data besar jauh lebih cepat di C) dan **integrasi** (menggunakan library C yang sudah ada yang tidak memiliki alternatif di Lua).

### 7.1 Lua C API untuk Modules

- **Deskripsi Konkret**:
  Lua C API adalah sekumpulan fungsi C yang disediakan oleh interpreter Lua. API ini memungkinkan kode C untuk berkomunikasi dengan _state_ Lua. Anda bisa menggunakannya untuk memanipulasi stack data Lua, memanggil fungsi Lua dari C, dan yang terpenting, menyediakan fungsi C agar bisa dipanggil dari Lua. Ini adalah cara "tradisional" untuk membuat C extensions.

- **Konsep Kunci: Fungsi `luaopen_*`**
  Saat Anda menulis `require("myclib")`, Lua tidak hanya mencari `myclib.lua`. Ia juga mencari library dinamis (seperti `myclib.so` di Linux atau `myclib.dll` di Windows) di `package.cpath`. Jika ditemukan, Lua akan mencari dan memanggil fungsi C di dalam library tersebut yang bernama `luaopen_myclib`. Fungsi inilah yang menjadi titik masuk (entry point) untuk module C Anda. Tugasnya adalah mendaftarkan semua fungsi C Anda ke dalam sebuah tabel dan mengembalikannya ke Lua.

- **Contoh Kode**:
  Bayangkan kita ingin membuat fungsi perkalian yang sangat cepat di C.

  **File C: `fast_math.c`**

  ```c
  #include "lua.h"
  #include "lauxlib.h"

  // Fungsi C yang ingin kita ekspos ke Lua.
  // Ia menerima state Lua sebagai argumen.
  static int c_multiply(lua_State *L) {
      // Ambil dua argumen dari stack Lua, yang merupakan angka.
      double num1 = luaL_checknumber(L, 1);
      double num2 = luaL_checknumber(L, 2);

      // Lakukan perhitungan.
      double result = num1 * num2;

      // Taruh (push) hasil kembali ke stack Lua.
      lua_pushnumber(L, result);

      // Kembalikan 1 untuk menandakan bahwa ada 1 nilai kembali di stack.
      return 1;
  }

  // Array yang mendefinisikan fungsi-fungsi dalam module kita.
  static const struct luaL_Reg fast_math_funcs[] = {
      {"multiply", c_multiply}, // Nama di Lua -> pointer ke fungsi C
      {NULL, NULL}              // Penanda akhir
  };

  // Ini adalah entry point yang akan dipanggil oleh 'require'.
  int luaopen_fast_math(lua_State *L) {
      // Buat tabel module dan daftarkan semua fungsi dari array di atas.
      luaL_newlib(L, fast_math_funcs);
      return 1; // Kembalikan tabel module yang sudah jadi.
  }
  ```

  **Proses Kompilasi (di Terminal Linux)**:
  `gcc -shared -fPIC -o fast_math.so fast_math.c -I/usr/include/lua5.4`

  **File Lua: `main.lua`**

  ```lua
  -- require akan menemukan dan memuat fast_math.so
  local fast_math = require("fast_math")

  -- Memanggil fungsi yang ditulis di C seolah-olah itu fungsi Lua biasa!
  local product = fast_math.multiply(12, 12)
  print("Hasil dari C:", product) -- Output: Hasil dari C: 144.0
  ```

- **Sumber**:

  - [Programming in Lua - The C API](https://www.lua.org/pil/24.html) (Bacaan wajib untuk topik ini)
  - [Lua 5.4 C API Reference](https://www.lua.org/manual/5.4/manual.html#4)

### 7.2 Integrasi FFI dan LuaJIT

- **Deskripsi Konkret**:
  **LuaJIT** adalah implementasi alternatif Lua yang sangat cepat berkat _Just-In-Time (JIT) compiler_-nya. Salah satu fitur andalannya adalah library **FFI (Foreign Function Interface)**. FFI memungkinkan Anda untuk memanggil fungsi dari library C dinamis (`.so`, `.dll`) **langsung dari kode Lua**, tanpa perlu menulis "kode lem" C sama sekali. Ini secara drastis menyederhanakan proses binding.

- **Perbandingan: C API vs. FFI**

  - **C API**: Memerlukan pengetahuan C, proses kompilasi terpisah, lebih banyak kode boilerplate, tetapi bekerja di Lua standar dan memberikan kontrol penuh.
  - **FFI**: Hampir tidak perlu kode C, deklarasi dilakukan di Lua, pengembangan jauh lebih cepat, tetapi memerlukan LuaJIT.

- **Contoh Kode (menggunakan FFI)**:
  Mari kita panggil fungsi `printf` dari library standar C.

  **File Lua: `main_ffi.lua` (dijalankan dengan `luajit main_ffi.lua`)**

  ```lua
  -- Muat library FFI
  local ffi = require("ffi")

  -- Deklarasikan 'header' C di dalam string Lua.
  -- Anda memberitahu FFI tentang fungsi yang ingin Anda gunakan.
  ffi.cdef[[
      // Deklarasi prototipe fungsi C standar
      int printf(const char *format, ...);
      int system(const char *command);
  ]]

  -- Muat library C standar. 'C' adalah namespace virtual untuk ini.
  local C = ffi.C

  -- Panggil fungsi C langsung dari Lua!
  C.printf("Hello from C, called via LuaJIT FFI! Num: %d\n", 123)
  C.system("echo 'This command is run by C!'")
  ```

  Seperti yang Anda lihat, ini jauh lebih ringkas dan tidak memerlukan kompilator C sama sekali selama pengembangan.

- **Sumber**:

  - [LuaJIT FFI Library](https://luajit.org/ext_ffi.html)
  - [LuaJIT FFI Tutorial](https://luajit.org/ext_ffi_tutorial.html)

### 7.3 Binding External Libraries

- **Deskripsi Konkret**:
  **Binding** adalah proses menciptakan "pembungkus" (wrapper) Lua untuk sebuah library C yang sudah ada. Tujuannya adalah untuk membuat API library C tersebut terasa "alami" saat digunakan dari Lua. Ini melibatkan lebih dari sekadar memanggil fungsi; Anda juga harus menangani struct, pointer, manajemen memori, dan penanganan error.

- **Tantangan Utama**:

  - **Manajemen Memori**: Jika C mengalokasikan memori, siapa yang bertanggung jawab untuk membebaskannya (`free`)? Lua punya _garbage collector_, C tidak. Anda perlu strategi yang jelas untuk mencegah kebocoran memori (memory leaks).
  - **Penanganan Error**: Fungsi C sering mengembalikan kode error (integer) atau menggunakan `errno`. Binding yang baik akan menerjemahkan ini menjadi error Lua yang idiomatis (`error()` atau `nil, error_message`).

- **Alat Otomatis: SWIG**
  Untuk library yang sangat besar dan kompleks (misalnya, library grafis, fisika, atau UI), menulis binding secara manual bisa sangat melelahkan. **SWIG (Simplified Wrapper and Interface Generator)** adalah alat yang dapat membaca file header C/C++ dan secara otomatis menghasilkan semua kode lem yang diperlukan untuk berbagai bahasa skrip, termasuk Lua.

- **Sumber**:

  - [SWIG Lua Bindings](https://www.google.com/search?q=http.www.swig.org/Doc4.0/Lua.html)
  - [Lua-users Wiki: Binding Code To Lua](http://lua-users.org/wiki/BindingCodeToLua)

---

## Tingkat 8: Best Practices dan Patterns

Setelah Anda menguasai "bagaimana" cara membuat module, tingkat ini fokus pada "bagaimana cara membuatnya dengan baik". Ini adalah tentang menulis kode yang bersih, dapat dipelihara, dan mudah digunakan oleh orang lain (termasuk diri Anda di masa depan).

### 8.1 Design Patterns untuk Modules

- **Deskripsi Konkret**:
  **Design Patterns** (Pola Desain) adalah solusi umum yang dapat digunakan kembali untuk masalah yang sering terjadi dalam desain perangkat lunak. Meskipun banyak pola berasal dari dunia OOP, prinsip-prinsipnya dapat diterapkan dengan elegan di Lua menggunakan tabel dan fungsi.

- **Contoh: Factory Pattern**
  Pola ini sangat cocok untuk Lua. Tujuannya adalah untuk menyediakan satu fungsi terpusat untuk membuat berbagai jenis "objek" (tabel) tanpa mengekspos logika pembuatannya yang rumit.

  **File: `entity_factory.lua`**

  ```lua
  local Factory = {}

  -- Fungsi 'private' untuk membuat entitas dasar
  local function create_base_entity(name, hp)
      return { name = name, hp = hp, x = 0, y = 0 }
  end

  -- Fungsi 'private' untuk entitas spesifik
  local function create_player(name)
      local p = create_base_entity(name, 100)
      p.mana = 50 -- Properti khusus player
      return p
  end

  local function create_monster(name)
      local m = create_base_entity(name, 25)
      m.is_hostile = true -- Properti khusus monster
      return m
  end

  -- Ini adalah satu-satunya fungsi 'public' dari Factory.
  -- Ia menyembunyikan semua detail pembuatan.
  function Factory.create(entity_type, name)
      if entity_type == "player" then
          return create_player(name)
      elseif entity_type == "monster" then
          return create_monster(name)
      else
          return nil, "Unknown entity type"
      end
  end

  return Factory
  ```

  **Penggunaan**: `local my_player = require("entity_factory").create("player", "Hero")`

- **Sumber**:

  - [Lua Design Patterns](http://lua-users.org/wiki/DesignPatterns)
  - [Programming in Lua - Design Patterns](https://www.lua.org/pil/16.html)

### 8.2 Dokumentasi dan Desain API

- **Deskripsi Konkret**:
  API (Application Programming Interface) dari module Anda adalah kumpulan fungsi publik yang Anda sediakan. Mendesain API yang baik sama pentingnya dengan menulis implementasi yang baik. API yang baik bersifat **konsisten, jelas, dan sederhana**. Dokumentasi yang baik adalah kunci agar orang lain dapat menggunakan API Anda.

- **Alat Dokumentasi: LDoc**
  **LDoc** adalah alat standar di ekosistem Lua untuk menghasilkan dokumentasi HTML dari komentar yang diformat secara khusus di dalam kode Anda.

- **Contoh Kode dengan Komentar LDoc**:

  ```lua
  local M = {}

  --- Menghitung jarak antara dua titik 2D.
  -- Menggunakan rumus Euclidean.
  -- @param p1 Tabel dengan field x dan y.
  -- @param p2 Tabel lain dengan field x dan y.
  -- @return Angka yang merepresentasikan jarak.
  -- @usage local dist = my_math.distance({x=0, y=0}, {x=3, y=4}) -- hasilnya 5
  function M.distance(p1, p2)
      local dx = p2.x - p1.x
      local dy = p2.y - p1.y
      return math.sqrt(dx^2 + dy^2)
  end

  return M
  ```

  Menjalankan LDoc pada file ini akan menghasilkan halaman web dokumentasi yang rapi.

- **Sumber**:

  - [LDoc Documentation Generator](https://github.com/lunarmodules/LDoc)
  - [Lua Style Guide - Documentation](https://github.com/Olivine-Labs/lua-style-guide#documentation)

### 8.3 Manajemen Versi dan Kompatibilitas

- **Deskripsi Konkret**:
  Saat module Anda mulai digunakan oleh orang lain (atau di banyak tempat dalam proyek Anda), memperbaruinya menjadi hal yang sensitif. Anda perlu cara untuk mengkomunikasikan jenis perubahan yang Anda buat.

- **Konsep Kunci: Semantic Versioning (SemVer)**
  Ini adalah standar yang diadopsi secara luas untuk penomoran versi perangkat lunak. Versi ditulis dalam format `MAJOR.MINOR.PATCH` (misalnya, `2.1.5`).

  - **MAJOR** (2): Diubah ketika Anda membuat perubahan yang **tidak kompatibel** (breaking change). Pengguna harus mengubah kode mereka untuk beradaptasi.
  - **MINOR** (1): Diubah ketika Anda **menambahkan fungsionalitas baru** yang bersifat _backward-compatible_ (tidak merusak kode lama).
  - **PATCH** (5): Diubah ketika Anda membuat **perbaikan bug** yang juga _backward-compatible_.

  Menggunakan SemVer memungkinkan pengguna module Anda (dan alat seperti LuaRocks) untuk mengelola pembaruan dengan aman.

- **Backward Compatibility (Kompatibilitas Mundur)**:
  Ini adalah tujuan mulia dalam desain library. Artinya, versi baru dari library Anda tidak akan merusak kode yang ditulis untuk versi sebelumnya. Ini membuat hidup pengguna Anda jauh lebih mudah.

- **Sumber**:

  - [Semantic Versioning Official Site](https://www.google.com/search?q=https.semver.org/)
  - [Lua Version Compatibility](http://lua-users.org/wiki/LuaVersionCompatibility) (Lebih tentang kompatibilitas antar versi Lua itu sendiri, tetapi relevan secara konsep)

---

Setelah menguasai teknik dan praktik terbaik ini, Anda sudah berada di level expert. Langkah selanjutnya adalah menerapkan semua pengetahuan ini dalam konteks aplikasi dunia nyata yang kompleks, yang akan kita bahas di Tingkat menuju terakhir

#

### Daftar Isi

- [Tingkat 9: Real-world Applications](#tingkat-9-real-world-applications)
  - [9.1 Modul dalam Web Framework (OpenResty, Lapis)](#91-modul-dalam-web-framework-openresty-lapis)
  - [9.2 Modul dalam Game Development (LÖVE 2D, Corona SDK)](#92-modul-dalam-game-development-love-2d-corona-sdk)
  - [9.3 Modul untuk Jaringan dan Sistem (LuaSocket, LFS)](#93-modul-untuk-jaringan-dan-sistem-luasocket-lfs)
  - [9.4 Modul untuk Embedded Systems dan IoT (NodeMCU)](#94-modul-untuk-embedded-systems-dan-iot-nodemcu)
- [Tingkat 10: Mastery Projects](#tingkat-10-mastery-projects)
  - [10.1 Membangun Package Manager Sendiri](#101-membangun-package-manager-sendiri)
  - [10.2 Merancang Arsitektur Plugin](#102-merancang-arsitektur-plugin)
  - [10.3 Berkontribusi pada Proyek Open Source](#103-berkontribusi-pada-proyek-open-source)
- [Kesimpulan Akhir: Jalan Seorang Master Lua](#kesimpulan-akhir-jalan-seorang-master-lua)

---

## Tingkat 9: Real-world Applications

Pada tingkat ini, kita akan melakukan studi kasus. Tujuannya adalah untuk melihat bagaimana semua konsep yang telah kita pelajari—mulai dari `require` sederhana hingga C extensions—diterapkan dalam proyek-proyek besar dan populer. Ini akan memberikan konteks dan pemahaman yang lebih dalam tentang "mengapa" di balik setiap teknik.

### 9.1 Modul dalam Web Framework (OpenResty, Lapis)

- **Deskripsi Konkret**: Lua mungkin bukan nama pertama yang muncul untuk pengembangan web, tetapi berkat LuaJIT dan OpenResty, ia menjadi pemain yang sangat kuat dalam ceruk _high-performance web services_.
- **Studi Kasus**:
  - **OpenResty**: Ini bukanlah sebuah framework, melainkan sebuah platform web yang sangat cepat dengan menggabungkan server Nginx dengan LuaJIT. Di OpenResty, hampir semua yang Anda lakukan adalah melalui modul Lua. Anda menulis "handler" untuk berbagai fase permintaan (request) Nginx. Modul-modul seperti `ngx.req`, `ngx.resp`, dan `ngx.socket` (yang sebenarnya adalah C-extensions yang sangat dioptimalkan) adalah API inti Anda untuk memanipulasi permintaan dan respons HTTP secara non-blocking. Arsitektur modular ini memungkinkan puluhan ribu koneksi simultan pada perangkat keras biasa.
  - **Lapis**: Lapis adalah framework web (mirip Ruby on Rails atau Django) yang dibangun _di atas_ OpenResty. Ia menyediakan struktur yang lebih akrab bagi pengembang web. Proyek Lapis diorganisir ke dalam modul-modul: aplikasi Anda adalah sebuah modul yang mengembalikan tabel rute, setiap _controller_ adalah modul, dan setiap _model_ adalah modul. Lapis sendiri adalah sekumpulan besar modul Lua yang Anda `require` untuk mendapatkan fungsionalitas seperti parsing parameter, rendering template, dan interaksi database.
- **Sumber**:
  - [Dokumentasi OpenResty](https://openresty.org/en/)
  - [Framework Lapis](https://leafo.net/lapis/)

### 9.2 Modul dalam Game Development (LÖVE 2D, Corona SDK)

- **Deskripsi Konkret**: Lua adalah bahasa skrip paling populer di industri game. Ia digunakan sebagai "lem" untuk mengontrol game engine yang ditulis dalam C++. Kecepatan iterasi Lua memungkinkan desainer game untuk mengubah logika permainan tanpa perlu mengkompilasi ulang seluruh engine.
- **Studi Kasus**:
  - **LÖVE 2D**: LÖVE adalah framework game 2D yang menyediakan serangkaian modul C++ yang kuat yang diekspos ke Lua. Anda memiliki `love.graphics` untuk menggambar, `love.audio` untuk suara, `love.physics` untuk simulasi fisika, dan banyak lagi. Struktur game LÖVE yang khas adalah memecah game menjadi "state" (keadaan) yang berbeda, di mana setiap state (misalnya, `menu.lua`, `gameplay.lua`, `gameover.lua`) adalah modul Lua yang mandiri. Modul-modul ini dipanggil oleh _callback_ utama (`love.load`, `love.update`, `love.draw`) untuk menjalankan permainan.
  - **Corona SDK (sekarang Solar2D)**: Mirip dengan LÖVE, Corona menyediakan API tingkat tinggi untuk pengembangan game mobile lintas platform. Seluruh logika game, dari animasi hingga interaksi UI, ditulis dalam file `.lua`. Corona menggunakan pendekatan modular untuk segalanya, termasuk _scene management_ (manajemen adegan) dan _widgets_ (elemen UI), memungkinkan pengembang untuk mengorganisir kode mereka ke dalam file-file logis yang dapat digunakan kembali.
- **Sumber**:
  - [LÖVE 2D Wiki](https://love2d.org/wiki/Main_Page)
  - [Dokumentasi Modul Corona SDK/Solar2D](https://www.google.com/search?q=https://docs.coronalabs.com/guide/programming/modules/index.html)

### 9.3 Modul untuk Jaringan dan Sistem (LuaSocket, LFS)

- **Deskripsi Konkret**: Di luar web dan game, Lua juga merupakan bahasa skrip serbaguna untuk tugas-tugas otomasi, jaringan, dan sistem.
- **Studi Kasus**:
  - **LuaSocket**: Ini adalah C-extension fundamental yang menyediakan akses tingkat rendah ke fungsionalitas jaringan. Ia menawarkan antarmuka Lua yang bersih untuk soket TCP dan UDP, memungkinkan Anda untuk membangun klien atau server jaringan kustom. Library tingkat lebih tinggi (seperti klien HTTP) seringkali dibangun menggunakan LuaSocket sebagai dasarnya. Ia adalah contoh sempurna dari modul C yang menyediakan fungsionalitas inti yang tidak ada di Lua standar.
  - **LuaFileSystem (LFS)**: Lua standar hanya memiliki sedikit fungsi untuk interaksi file. LFS adalah modul C yang mengisi kekosongan ini, menyediakan cara yang portabel (berfungsi sama di Windows, macOS, dan Linux) untuk berinteraksi dengan sistem file. Anda dapat menggunakan `lfs.attributes()` untuk mendapatkan informasi file, `lfs.mkdir()` untuk membuat direktori, dan `lfs.dir()` untuk mengulang file dalam sebuah direktori. Ini jauh lebih andal daripada menggunakan `os.execute()` dengan perintah shell spesifik platform.
- **Sumber**:
  - [Dokumentasi LuaSocket](http://w3.impa.br/~diego/software/luasocket/)
  - [Lua File System (LFS)](https://keplerproject.github.io/luafilesystem/)

### 9.4 Modul untuk Embedded Systems dan IoT (NodeMCU)

- **Deskripsi Konkret**: Ukuran Lua yang kecil dan kebutuhan memori yang rendah membuatnya ideal untuk sistem tertanam (embedded systems) dan perangkat Internet of Things (IoT) yang memiliki sumber daya terbatas.
- **Studi Kasus**:
  - **NodeMCU**: Ini adalah firmware populer untuk mikrokontroler murah seperti ESP8266 dan ESP32. Firmware ini menyertakan interpreter Lua. Pengguna menulis skrip Lua untuk mengontrol perangkat keras. Interaksi dengan pin GPIO, sensor, WiFi, dan periferal lainnya dilakukan dengan memanggil fungsi dari modul-modul yang telah dikompilasi sebelumnya ke dalam firmware (ditulis dalam C). Sebagai contoh, Anda akan menggunakan modul `gpio` untuk mengontrol pin, modul `wifi` untuk terhubung ke jaringan, dan modul `http` untuk mengirim data ke server. Skrip utama Anda (`init.lua`) bertindak sebagai orkestrator yang me-`require` dan menggunakan modul-modul ini untuk menjalankan logika perangkat IoT Anda.
- **Sumber**:
  - [Dokumentasi NodeMCU](https://nodemcu.readthedocs.io/en/latest/)

---

## Tingkat 10: Mastery Projects

Ini adalah tingkat akhir, di mana Anda beralih dari konsumen dan analis menjadi pencipta. Menyelesaikan proyek-proyek ini menunjukkan pemahaman yang mendalam tentang bagaimana sistem module bekerja dari dalam ke luar.

### 10.1 Membangun Package Manager Sendiri

- **Deskripsi Konkret**: Ini adalah proyek puncak untuk memahami `require`, `package.path`, dan manajemen dependensi. Tujuannya bukan untuk menggantikan LuaRocks, tetapi untuk memahami prinsip-prinsip dasarnya.
- **Rencana Proyek**:
  1.  **Definisikan Manifest**: Buat format file sederhana (misalnya, `deps.json`) untuk mendefinisikan dependensi proyek, seperti `{"penlight": "1.12.0"}`.
  2.  **Logika Fetch**: Tulis fungsi Lua yang membaca manifest ini dan mengunduh file sumber dependensi (misalnya, dari repositori Git atau URL langsung).
  3.  **Logika Instalasi**: Simpan dependensi yang diunduh ke direktori lokal, misalnya, `lua_modules/`.
  4.  **Resolusi Path**: Tulis skrip "pembungkus" (wrapper) yang secara dinamis memodifikasi `package.path` untuk menyertakan direktori `lua_modules/` sebelum menjalankan skrip utama Anda.
- **Sumber untuk Dipelajari**:
  - [Artikel: So You Want to Write a Package Manager](https://medium.com/@sdboyer/so-you-want-to-write-a-package-manager-4ae9c17d9527) (Konsep umum)
  - [Kode Sumber LuaRocks](https://github.com/luarocks/luarocks) (Untuk melihat bagaimana para profesional melakukannya)

### 10.2 Merancang Arsitektur Plugin

- **Deskripsi Konkret**: Banyak aplikasi hebat (seperti VSCode, Neovim, atau Photoshop) dapat diperluas melalui plugin. Merancang sistem seperti ini di Lua adalah latihan yang sangat baik dalam desain API modular dan hot-reloading.
- **Rencana Proyek**:
  1.  **Aplikasi Inti**: Buat aplikasi sederhana (misalnya, editor teks atau bot obrolan).
  2.  **Titik Ekstensi (Hooks)**: Definisikan "event" atau "hook" dalam aplikasi Anda, misalnya, `on_app_start`, `on_text_changed`, atau `on_chat_message`.
  3.  **Loader Plugin**: Tulis modul yang memindai direktori `plugins/`. Untuk setiap sub-direktori, ia akan me-`require` modul plugin.
  4.  **API Plugin**: Definisikan "kontrak" untuk plugin. Setiap modul plugin harus mengembalikan sebuah tabel yang berisi fungsi-fungsi yang sesuai dengan nama hook (misalnya, `plugin.on_chat_message = function(msg) ... end`).
  5.  **Dispatcher**: Ketika sebuah event terjadi di aplikasi inti, dispatcher akan mengulang semua plugin yang dimuat dan memanggil fungsi hook yang relevan.
- **Sumber untuk Dipelajari**:
  - [Lua-users Wiki: Plugin Architecture](http://lua-users.org/wiki/PluginArchitecture)
  - [Kode Sumber Awesome Window Manager](https://github.com/awesomeWM/awesome) (Contoh nyata dari aplikasi Lua yang sangat dapat diperluas)

### 10.3 Berkontribusi pada Proyek Open Source

- **Deskripsi Konkret**: Puncak dari penguasaan adalah berbagi pengetahuan Anda. Berkontribusi pada ekosistem Lua tidak hanya membantu orang lain tetapi juga mempertajam keterampilan Anda saat kode Anda ditinjau oleh pengembang berpengalaman.
- **Langkah-langkah untuk Memulai**:
  1.  **Pilih Proyek**: Temukan library atau alat Lua yang Anda gunakan dan sukai.
  2.  **Mulai dari yang Kecil**: Cara termudah untuk memulai adalah dengan memperbaiki kesalahan ketik dalam dokumentasi, menambahkan contoh penggunaan, atau menangani bug kecil yang ditandai sebagai "good first issue".
  3.  **Buat Modul Anda Sendiri**: Jika Anda telah membuat modul yang berguna untuk proyek Anda, pertimbangkan untuk membersihkannya, menambahkan dokumentasi yang baik, menulis file `.rockspec`, dan mempublikasikannya di LuaRocks.
- **Sumber**:
  - [GitHub - Topik Lua](https://github.com/topics/lua) (Untuk menemukan proyek)
  - [Panduan First Contributions](https://github.com/firstcontributions/first-contributions) (Panduan umum yang bagus untuk pemula open source)

---

### Kesimpulan Akhir: Jalan Seorang Master Lua

Anda sekarang memiliki peta jalan yang sangat lengkap. Kurikulum ini telah membawa Anda dari pertanyaan paling dasar ("Apa itu module?") hingga tantangan paling kompleks ("Bagaimana saya merancang sistem plugin?").

Kunci untuk mengubah pengetahuan ini menjadi keahlian sejati adalah **praktik yang konsisten dan disengaja**. Terapkan setiap konsep. Tulis kode, buat kesalahan, perbaiki, dan ulangi. Jangan hanya membaca tentang LÖVE 2D atau OpenResty; unduh mereka dan coba ubah salah satu contoh proyeknya.

#

Dengan mengikuti jalur ini, Anda tidak hanya akan belajar cara menggunakan modul dan paket di Lua. Anda akan memahami _filosofi_ di baliknya, memungkinkan Anda untuk menulis kode yang efisien, dapat dipelihara, dan elegan, serta merancang arsitektur perangkat lunak yang kuat dan fleksibel, apa pun tujuan Anda.

**Selamat berkarya\!**




#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../../tables/bagian-15/README.md
[selanjutnya]: ../../pattern-matching/README.md

<!-- ------------------------------------------------- -->

[0]: ../README.md