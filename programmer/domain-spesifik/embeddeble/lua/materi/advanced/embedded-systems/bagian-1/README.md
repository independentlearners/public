### Daftar Isi Panduan Belajar

- [**Fase 1: Fondasi Pemrograman Lua**](#fase-1-fondasi-pemrograman-lua)
  - [1.1. Pengenalan Lua: Filosofi dan Karakteristik](#11-pengenalan-lua-filosofi-dan-karakteristik)
  - [1.2. Sintaks Dasar: Variabel, Tipe Data, dan Struktur Kontrol](#12-sintaks-dasar-variabel-tipe-data-dan-struktur-kontrol)
  - [1.3. Tables: Struktur Data Universal di Lua](#13-tables-struktur-data-universal-di-lua)
  - [1.4. Functions dan Closures: Blok Pembangun Logika](#14-functions-dan-closures-blok-pembangun-logika)
  - [1.5. Metatables dan Metamethods: Kustomisasi Perilaku](#15-metatables-dan-metamethods-kustomisasi-perilaku)
  - [1.6. Coroutines: Multitasking Kooperatif](#16-coroutines-multitasking-kooperatif)
  - [1.7. Manajemen Memori dan Garbage Collection](#17-manajemen-memori-dan-garbage-collection)
- [**Fase 2: Lua untuk Embedded Systems**](#fase-2-lua-untuk-embedded-systems)
  - [2.1. Konsep Inti Embedded Systems](#21-konsep-inti-embedded-systems)
  - [2.2. Lua vs. C dalam Dunia Embedded](#22-lua-vs-c-dalam-dunia-embedded)
  - [2.3. Lua C API: Jembatan Antar Dua Dunia](#23-lua-c-api-jembatan-antar-dua-dunia)
  - [2.4. Arsitektur eLua dan Lingkungan Eksekusi](#24-arsitektur-elua-dan-lingkungan-eksekusi)
- [**Langkah Selanjutnya dan Rekomendasi**](#langkah-selanjutnya-dan-rekomendasi)

---

## **Fase 1: Fondasi Pemrograman Lua**

Fase ini adalah yang paling krusial. Tanpa pemahaman yang kokoh di sini, fase-fase berikutnya akan terasa sangat sulit. Kita akan fokus pada fitur-fitur unik Lua yang membuatnya sangat kuat untuk _embedded systems_.

### **1.1. Pengenalan Lua: Filosofi dan Karakteristik**

- **Deskripsi Konkrit**: Lua adalah bahasa skrip (bukan bahasa terkompilasi seperti C/C++) yang dirancang untuk menjadi **ringan (lightweight)**, **cepat (fast)**, dan **mudah disematkan (embeddable)** ke dalam aplikasi lain. Filosofi utamanya adalah menyediakan mekanisme inti yang kuat dan fleksibel (seperti _metatables_ dan _coroutines_), alih-alih menyediakan pustaka yang besar dan kaku. Ini membuatnya ideal untuk lingkungan dengan sumber daya terbatas seperti _microcontrollers_.

- **Terminologi Kunci**:

  - **Scripting Language**: Bahasa yang dieksekusi oleh sebuah _interpreter_ saat runtime, bukan dikompilasi menjadi kode mesin terlebih dahulu. Ini memungkinkan pengembangan yang cepat dan fleksibilitas.
  - **Interpreter**: Program yang membaca kode sumber baris per baris dan menjalankannya secara langsung.
  - **Embeddable**: Didesain agar mudah diintegrasikan ke dalam program yang ditulis dalam bahasa lain (biasanya C/C++). Lua bertindak sebagai "otak" scripting untuk "otot" C.
  - **Lightweight**: Jejak memori (memory footprint) dari interpreter Lua sangat kecil, seringkali hanya beberapa ratus kilobyte, yang sangat cocok untuk _embedded systems_.

- **Referensi**:

  - [Sejarah dan Filosofi Desain Lua](https://www.lua.org/ddj.html)
  - [Halaman Resmi Lua](https://www.lua.org/start.html)

### **1.2. Sintaks Dasar: Variabel, Tipe Data, dan Struktur Kontrol**

- **Deskripsi Konkrit**: Seperti bahasa lainnya, Lua memiliki variabel untuk menyimpan data, tipe data untuk mendefinisikan jenis data, dan struktur kontrol untuk mengatur alur eksekusi program. Yang membedakan Lua adalah kesederhanaan dan beberapa keunikannya.

- **Terminologi dan Konsep**:

  - **Dynamic Typing**: Tipe data terikat pada nilai, bukan pada variabel. Kita tidak perlu mendeklarasikan tipe variabel.
  - **Tipe Data Utama**:
    - `nil`: Merepresentasikan ketiadaan nilai (mirip `null` di Dart).
    - `boolean`: `true` atau `false`. Hanya `false` dan `nil` yang dianggap sebagai kondisi salah; semua nilai lain (termasuk `0` dan string kosong `""`) adalah benar.
    - `number`: Secara default merepresentasikan angka _floating-point_ presisi ganda (double).
    - `string`: Urutan byte yang tidak dapat diubah (immutable).
    - `function`: Fungsi adalah warga kelas satu (_first-class citizen_), artinya dapat disimpan dalam variabel, dioperasikan, dan dikembalikan oleh fungsi lain.
    - `table`: Struktur data utama di Lua (akan kita bahas mendalam).
    - `userdata`: Tipe data yang memungkinkan data C untuk disimpan dalam variabel Lua.
    - `thread`: Merepresentasikan _coroutine_.
  - **Scope Variabel**: Variabel di Lua secara default bersifat **global**. Ini adalah salah satu hal yang harus sangat diwaspadai. Untuk membuat variabel lokal, gunakan kata kunci `local`. Selalu gunakan `local` kecuali Kita benar-benar membutuhkan variabel global.

- **Sintaks Dasar dan Contoh Kode**:

  ```lua
  -- Variabel dan Tipe Data
  local nama = "Andi"          -- String (gunakan 'local' untuk scope lokal)
  local umur = 25              -- Number
  local sudahMenikah = false   -- Boolean
  local pekerjaan = nil        -- Nil

  -- Mencetak tipe dari variabel
  print(type(nama))            --> string
  print(type(pekerjaan))       --> nil

  -- Struktur Kontrol: if-then-else
  if umur > 17 then
    print(nama .. " adalah seorang dewasa.") -- '..' adalah operator konkatenasi string
  else
    print(nama .. " adalah seorang anak-anak.")
  end

  -- Struktur Kontrol: Looping (for)
  -- Dari 1 sampai 5
  for i = 1, 5, 1 do
    print("Iterasi ke: " .. i)
  end

  -- Struktur Kontrol: Looping (while)
  local hitunganMundur = 3
  while hitunganMundur > 0 do
    print(hitunganMundur)
    hitunganMundur = hitunganMundur - 1
  end
  print("Mulai!")
  ```

- **Referensi**:

  - [Programming in Lua (Edisi Pertama): Tipe dan Nilai](https://www.lua.org/pil/1.html)
  - [Learn Lua in Y Minutes](https://learnxinyminutes.com/docs/lua/)

### **1.3. Tables: Struktur Data Universal di Lua**

- **Deskripsi Konkrit**: Ini adalah konsep **paling penting** di Lua. Lupakan `Array`, `List`, `Map`, `Set` dari bahasa lain. Di Lua, semuanya adalah `table`. _Table_ adalah struktur data hibrida yang dapat berperilaku seperti array (list), _hash map_ (kamus), atau bahkan objek.

- **Terminologi dan Konsep**:

  - **Associative Array**: Sebuah koleksi pasangan kunci-nilai (`key-value`).
  - **Array/List-like part**: Ketika kunci adalah bilangan bulat berurutan (1, 2, 3, ...), _table_ berperilaku seperti array. **Penting**: Indeks di Lua dimulai dari **1**, bukan 0.
  - **Hash/Dictionary-like part**: Ketika kunci adalah tipe data lain (string, angka, dll), _table_ berperilaku seperti _map_ atau kamus.
  - **Constructor**: Cara membuat _table_, menggunakan kurung kurawal `{}`.

- **Sintaks Dasar dan Contoh Kode**:

  ```lua
  -- 1. Table sebagai Array/List
  local warna = {"merah", "kuning", "hijau"} -- Kunci 1, 2, 3 di-generate otomatis
  print(warna[1]) -- -> merah (indeks dimulai dari 1)
  table.insert(warna, "biru") -- Menambah item di akhir
  print(#warna) -- -> 4 (operator '#' mengembalikan panjang bagian array)

  -- 2. Table sebagai Dictionary/Map
  local data_mahasiswa = {
    nama = "Budi",
    nim = "12345",
    aktif = true
  }
  print(data_mahasiswa.nama) -- -> Budi (sintaks gula untuk data_mahasiswa["nama"])
  print(data_mahasiswa["nim"]) -- -> 12345

  -- 3. Table sebagai struktur hibrida
  local campuran = { "apel", "jeruk", [10] = "mangga", nama = "Toko Buah" }
  print(campuran[1]) -- -> apel
  print(campuran[2]) -- -> jeruk
  print(campuran[10]) -- -> mangga
  print(campuran.nama) -- -> Toko Buah
  print(#campuran) -- -> 2 (operator '#' hanya bekerja pada urutan integer yang tidak terputus mulai dari 1)
  ```

- **Representasi Visual**:
  Bayangkan sebuah _table_ sebagai sebuah kotak ajaib yang bisa menyimpan data dengan label apa pun.

  ```
  Table: data_mahasiswa
  +-----------------+
  | Kunci  | Nilai  |
  |--------|--------|
  | "nama" | "Budi" |
  | "nim"  | "12345"|
  | "aktif"| true   |
  +-----------------+
  ```

- **Referensi**:

  - [Programming in Lua - Tables](https://www.lua.org/pil/2.5.html)

### **1.4. Functions dan Closures: Blok Pembangun Logika**

- **Deskripsi Konkrit**: Fungsi di Lua adalah unit dasar untuk membungkus logika yang dapat digunakan kembali. Seperti yang disebutkan, mereka adalah _first-class citizen_, memberikan kekuatan ekspresif yang luar biasa. _Closures_ adalah fitur canggih yang memungkinkan fungsi untuk "mengingat" lingkungan tempat ia dibuat.

- **Terminologi dan Konsep**:

  - **First-Class Citizen**: Dapat diperlakukan seperti nilai lainnya: disimpan dalam variabel, dijadikan argumen fungsi, dan dikembalikan sebagai hasil fungsi.
  - **Anonymous Function**: Fungsi tanpa nama.
  - **Closure**: Sebuah fungsi yang "menangkap" variabel-variabel _non-local_ dari _scope_ induknya. Bahkan setelah _scope_ induknya selesai dieksekusi, fungsi tersebut masih memiliki akses ke variabel-variabel tersebut. Ini adalah konsep fundamental untuk _event-driven programming_ dan _state management_.

- **Sintaks Dasar dan Contoh Kode**:

  ```lua
  -- Definisi fungsi standar
  local function sapa(nama)
    return "Halo, " .. nama .. "!"
  end
  print(sapa("Dunia")) -- -> Halo, Dunia!

  -- Fungsi sebagai nilai dalam variabel (anonymous function)
  local kali_dua = function(x)
    return x * 2
  end
  print(kali_dua(10)) -- -> 20

  -- Contoh Closure
  local function buat_penghitung()
    local counter = 0
    -- Fungsi di dalam fungsi ini adalah sebuah closure
    return function()
      counter = counter + 1
      return counter
    end
  end

  local c1 = buat_penghitung()
  print(c1()) -- -> 1
  print(c1()) -- -> 2 (variabel 'counter' tetap hidup dan diingat oleh c1)

  local c2 = buat_penghitung()
  print(c2()) -- -> 1 ('counter' untuk c2 terpisah dari c1)
  ```

- **Referensi**:

  - [Programming in Lua - Functions](https://www.lua.org/pil/5.html)
  - [Lua Users Wiki - Functions](http://lua-users.org/wiki/FunctionsTutorial)

### **1.5. Metatables dan Metamethods: Kustomisasi Perilaku**

- **Deskripsi Konkrit**: Jika _tables_ adalah jantungnya Lua, _metatables_ adalah jiwanya. Ini adalah mekanisme yang paling kuat dan seringkali paling disalahpahami di Lua. Sebuah _metatable_ adalah _table_ biasa yang Kita lampirkan ke _table_ lain untuk mengubah perilakunya. Fungsi-fungsi di dalam _metatable_ disebut _metamethods_. Ini adalah kunci untuk mengimplementasikan OOP, pewarisan (_inheritance_), dan banyak pola canggih lainnya.

- **Terminologi dan Konsep**:

  - **Metatable**: Sebuah _table_ yang mendefinisikan perilaku baru untuk _table_ lain.
  - **Metamethod**: Kunci khusus dalam _metatable_ (selalu berupa string dengan awalan `__`) yang menunjuk ke sebuah fungsi. Fungsi ini akan dipanggil ketika operasi tertentu dilakukan pada _table_ utama.
  - `__index`: Metamethod yang paling umum. Dipanggil ketika Kita mencoba mengakses kunci yang **tidak ada** (`nil`) di sebuah _table_. Ini adalah dasar untuk pewarisan (mencari metode di kelas induk).
  - `__newindex`: Dipanggil ketika Kita mencoba **menetapkan nilai** ke kunci yang tidak ada.
  - `__tostring`: Dipanggil ketika Kita mencoba mengonversi _table_ ke string (misalnya dengan `print()`).
  - `__add`, `__mul`, dll.: Memungkinkan Kita mendefinisikan operasi aritmatika pada _tables_.

- **Sintaks Dasar dan Contoh Kode (Implementasi OOP Sederhana)**:

  ```lua
  -- 1. Definisikan "kelas" sebagai sebuah table
  local Vector = {}
  Vector.__index = Vector -- Penting! Saat metode tidak ditemukan di instance, cari di table Vector itu sendiri.

  -- 2. Buat "constructor"
  function Vector.new(x, y)
    local instance = {x = x, y = y} -- Buat instance baru (sebuah table)
    setmetatable(instance, Vector)   -- Lampirkan metatable (Vector) ke instance
    return instance
  end

  -- 3. Definisikan sebuah "metode"
  function Vector:magnitude() -- ':' adalah sintaks gula untuk function Vector.magnitude(self)
    return math.sqrt(self.x^2 + self.y^2)
  end

  -- 4. Definisikan metamethod untuk 'menjumlahkan' dua vektor
  function Vector.__add(v1, v2)
    return Vector.new(v1.x + v2.x, v1.y + v2.y)
  end

  -- 5. Definisikan metamethod untuk representasi string
  function Vector.__tostring(v)
      return "Vector("..v.x..", "..v.y..")"
  end

  -- Penggunaan
  local vec1 = Vector.new(3, 4)
  local vec2 = Vector.new(1, 2)

  print(vec1:magnitude()) -- -> 5.0 (memanggil metode)
  local vec3 = vec1 + vec2  -- Memanggil metamethod __add
  print(vec3)             -- Memanggil metamethod __tostring -> Vector(4, 6)
  ```

- **Referensi**:

  - [Programming in Lua - Metatables](https://www.lua.org/pil/13.html) (URL di file berbeda, ini yang lebih relevan untuk pengenalan)
  - [Lua Users Wiki - Metatables Tutorial](http://lua-users.org/wiki/MetatablesTutorial)

### **1.6. Coroutines: Multitasking Kooperatif**

- **Deskripsi Konkrit**: Lupakan _threads_ preemptif yang rumit dan rawan _race condition_. Lua menyediakan _coroutines_, sebuah bentuk _multitasking_ yang **kooperatif**. Artinya, sebuah _task_ (coroutine) akan berjalan sampai ia secara eksplisit "mengalah" (_yield_), memberikan kontrol kembali ke program utama. Program utama kemudian dapat "melanjutkan" (_resume_) _coroutine_ tersebut kapan saja. Ini sangat cocok untuk _embedded systems_ di mana Kita perlu mengelola banyak _task_ (membaca sensor, mengupdate layar, menunggu koneksi jaringan) tanpa overhead dari sistem operasi _real-time_ (RTOS) yang kompleks.

- **Terminologi dan Konsep**:

  - **Cooperative Multitasking**: Setiap _task_ berjalan secara sukarela menyerahkan kontrol CPU.
  - **Preemptive Multitasking**: Sistem operasi dapat menginterupsi _task_ kapan saja untuk menjalankan _task_ lain (model _thread_ pada umumnya).
  - `coroutine.create()`: Membuat _coroutine_ baru dari sebuah fungsi.
  - `coroutine.resume()`: Memulai atau melanjutkan eksekusi _coroutine_.
  - `coroutine.yield()`: Menjeda eksekusi _coroutine_ dan mengembalikan kontrol (beserta nilai) ke pemanggil `resume`.
  - `coroutine.status()`: Memeriksa status _coroutine_ (`running`, `suspended`, `dead`).

- **Sintaks Dasar dan Contoh Kode**:

  ```lua
  local function sensor_reader()
    local i = 0
    while true do
      i = i + 1
      print("Sensor membaca data...")
      -- Mensimulasikan pembacaan data, lalu 'mengalah'
      -- dan mengirimkan data yang dibaca
      coroutine.yield("Data Sensor ke-" .. i)
    end
  end

  -- Buat coroutine
  local sensor_co = coroutine.create(sensor_reader)

  -- Jalankan loop utama
  for j = 1, 3 do
    print("Loop utama: Melakukan tugas lain...")
    -- Lanjutkan coroutine sensor untuk mendapatkan data
    local status, data = coroutine.resume(sensor_co)
    if status then
      print("Loop utama: Menerima '" .. data .. "'")
    end
    -- Lakukan hal lain sebelum iterasi berikutnya...
    -- os.execute("sleep 1") -- contoh di sistem non-embedded
  end

  --[[ Output yang diharapkan:
  Loop utama: Melakukan tugas lain...
  Sensor membaca data...
  Loop utama: Menerima 'Data Sensor ke-1'
  Loop utama: Melakukan tugas lain...
  Sensor membaca data...
  Loop utama: Menerima 'Data Sensor ke-2'
  Loop utama: Melakukan tugas lain...
  Sensor membaca data...
  Loop utama: Menerima 'Data Sensor ke-3'
  --]]
  ```

- **Referensi**:

  - [Programming in Lua - Coroutines](https://www.lua.org/pil/9.html)
  - [Lua Users Wiki - Coroutines Tutorial](http://lua-users.org/wiki/CoroutinesTutorial)

### **1.7. Manajemen Memori dan Garbage Collection**

- **Deskripsi Konkrit (Materi Tambahan)**: Ini adalah topik yang sering terlewatkan oleh pemula tetapi sangat **penting** untuk _embedded systems_. Lua mengelola memori secara otomatis menggunakan _Garbage Collector_ (GC). Memahami cara kerjanya memungkinkan Kita menulis kode yang efisien dan menghindari jeda tak terduga yang dapat mengganggu aplikasi _real-time_.

- **Terminologi dan Konsep**:

  - **Garbage Collector (GC)**: Proses otomatis yang menemukan dan membebaskan memori yang tidak lagi digunakan oleh program.
  - **Incremental GC**: GC di Lua tidak menghentikan seluruh program untuk membersihkan memori (_stop-the-world_). Sebaliknya, ia bekerja dalam langkah-langkah kecil (_increments_), diselingi dengan eksekusi program normal. Ini mengurangi jeda (_latency_) dan sangat penting untuk _embedded systems_.
  - **Memory Footprint**: Jumlah total memori yang digunakan oleh interpreter Lua dan skrip Kita.
  - **Tips Optimasi**:
    1.  **Gunakan kembali _tables_**: Membuat _table_ baru terus-menerus (`{}`) dalam sebuah _loop_ adalah sumber utama "sampah" memori. Jika memungkinkan, bersihkan dan gunakan kembali _table_ yang ada.
    2.  **Gunakan `local`**: Variabel lokal lebih cepat diakses dan lebih mudah bagi GC untuk menentukan kapan mereka tidak lagi dibutuhkan.
    3.  **Hati-hati dengan _closures_**: _Closures_ dapat menahan referensi ke _tables_ atau data besar, mencegahnya dikumpulkan oleh GC. Pastikan Kita tidak secara tidak sengaja menahan data yang tidak perlu.

- **Contoh Kode (Anti-Pattern dan Pola yang Baik)**:

  ```lua
  -- ANTI-PATTERN: Membuat table baru di setiap iterasi loop
  function process_data_bad()
    for i = 1, 100000 do
      local t = {x = i, y = i*2} -- Membuat 100,000 table baru!
      -- proses t...
    end
    -- GC harus bekerja keras membersihkan semua table ini.
  end

  -- POLA YANG BAIK: Menggunakan kembali table
  function process_data_good()
    local t = {} -- Buat table satu kali di luar loop
    for i = 1, 100000 do
      t.x = i
      t.y = i*2
      -- proses t...
    end
    -- Hanya satu table yang dibuat. Jauh lebih efisien.
  end
  ```

- **Referensi**:

  - [Programming in Lua - Garbage Collection](https://www.lua.org/pil/7.html)
  - [Lua Users Wiki - Memory Management](http://lua-users.org/wiki/MemoryManagement)

---

## **Fase 2: Lua untuk Embedded Systems**

Setelah memiliki fondasi Lua yang kuat, sekarang saatnya kita masuk ke konteks _embedded_. Fase ini menjelaskan _mengapa_ dan _bagaimana_ Lua digunakan di dunia _microcontrollers_.

### **2.1. Konsep Inti Embedded Systems**

- **Deskripsi Konkrit**: Sebuah _embedded system_ (sistem tertanam) adalah kombinasi dari perangkat keras komputer dan perangkat lunak yang dirancang untuk fungsi tertentu dalam sistem yang lebih besar. Berbeda dengan PC umum, mereka tidak dimaksudkan untuk serba guna. Contoh: _firmware_ di dalam mesin cuci, sistem manajemen mesin mobil, atau _drone_.

- **Terminologi Kunci**:

  - **Microcontroller (MCU)**: Sebuah komputer kecil dalam satu sirkuit terpadu. Berisi prosesor, memori (RAM), dan periferal I/O (input/output). Contoh: ESP32, STM32, ATmega328 (di Arduino).
  - **Firmware**: Perangkat lunak permanen yang diprogram ke dalam memori _read-only_ dari perangkat keras.
  - **Resource-Constrained**: Memiliki sumber daya yang sangat terbatas (RAM dalam kilobyte, kecepatan CPU dalam MHz, penyimpanan dalam megabyte).
  - **Real-time Constraints**: Tuntutan untuk menyelesaikan tugas dalam batas waktu yang ketat. Gagal memenuhi batas waktu dapat menyebabkan kegagalan sistem.
    - **Hard Real-time**: Batas waktu yang mutlak tidak boleh dilewatkan (misal: sistem pengereman ABS mobil).
    - **Soft Real-time**: Melewatkan batas waktu akan menurunkan kualitas layanan, tetapi tidak menyebabkan kegagalan total (misal: _streaming_ video).
  - **Peripherals**: Komponen fungsional pada MCU seperti GPIO, ADC, UART, I2C, SPI.

- **Referensi**:

  - [Embedded Engineering Roadmap GitHub](https://github.com/m3y54m/Embedded-Engineering-Roadmap)

### **2.2. Lua vs. C dalam Dunia Embedded**

- **Deskripsi Konkrit**: C adalah raja tak terbantahkan di dunia _embedded_ karena memberikan kontrol tingkat rendah (_low-level_) dan performa maksimal. Namun, pengembangan dalam C lambat, rawan kesalahan (terutama manajemen memori manual), dan sulit untuk diubah. Lua hadir sebagai pelengkap, bukan pengganti. Lua digunakan untuk **logika tingkat tinggi**, sementara C menangani **tugas kritis performa dan interaksi perangkat keras langsung**.

- **Representasi Visual (Arsitektur Umum)**:

  ```
  +---------------------------------+
  |      Logika Aplikasi (LUA)      |  <-- Cepat dikembangkan, fleksibel, mudah diubah.
  | (Manajemen state, alur bisnis,  |      (e.g., "Jika suhu > 30, nyalakan kipas")
  |  konfigurasi pengguna, UI)      |
  +---------------------------------+
  |          Lua C API              |  <-- Jembatan / Lem
  +---------------------------------+
  | Fungsi-fungsi Kritis (C)        |  <-- Cepat dieksekusi, kontrol penuh.
  | (Driver hardware, algoritma      |      (e.g., fungsi C untuk membaca sensor suhu,
  |  pemrosesan sinyal, protokol)   |       fungsi C untuk mengontrol pin GPIO kipas)
  +---------------------------------+
  |             HARDWARE            |
  +---------------------------------+
  ```

- **Perbandingan**:

  - **Kecepatan Pengembangan**: Lua jauh lebih cepat. Kita tidak perlu kompilasi ulang untuk setiap perubahan kecil.
  - **Manajemen Memori**: Lua (otomatis/GC) lebih aman dan mudah daripada C (manual `malloc`/`free`).
  - **Performa Eksekusi**: C jauh lebih cepat dan lebih deterministik.
  - **Jejak Memori**: Interpreter Lua membutuhkan memori, tetapi seringkali total ukuran kode (C + Lua) bisa lebih kecil karena logika di Lua lebih ringkas.
  - **Keamanan**: Menjalankan skrip Lua lebih aman daripada menjalankan kode C yang ditulis dengan buruk. Kesalahan dalam skrip Lua biasanya tidak akan merusak seluruh sistem.

- **Referensi**:

  - [Real-Time Logic: Lua vs C for Embedded](https://realtimelogic.com/articles/Using-Lua-for-Embedded-Development-vs-Traditional-C-Code)

### **2.3. Lua C API: Jembatan Antar Dua Dunia**

- **Deskripsi Konkrit**: Ini adalah antarmuka pemrograman aplikasi (API) yang memungkinkan kode C untuk berinteraksi dengan interpreter Lua. Kita bisa menggunakan C untuk memanggil fungsi Lua, dan sebaliknya, Kita bisa menggunakan Lua untuk memanggil fungsi C. Ini adalah **mekanisme inti** yang memungkinkan arsitektur hibrida (C+Lua) bekerja.

- **Terminologi dan Konsep**:

  - **The Stack**: Konsep sentral di C API. Ini adalah tumpukan virtual (bukan _call stack_ C) yang digunakan untuk bertukar data antara C dan Lua. C mendorong (_push_) nilai ke _stack_, Lua mengambilnya. Lua mendorong hasil ke _stack_, C mengambilnya.
  - `lua_State*`: Pointer ke seluruh state runtime Lua. Setiap interaksi C API memerlukan pointer ini.
  - **Binding**: Proses mengekspos fungsi C agar dapat dipanggil dari Lua.

- **Contoh Kode (Sangat Disederhanakan)**:
  Mengekspos fungsi C `set_led(status)` ke Lua agar bisa dipanggil sebagai `led(true)`.

  **Kode C (`my_module.c`):**

  ```c
  #include "lua.h"
  #include "lauxlib.h"

  // Fungsi C asli yang mengontrol hardware
  void hardware_set_led(int status) {
      // ... kode low-level untuk menyalakan/mematikan LED ...
      printf("C: LED diatur ke status %d\n", status);
  }

  // Fungsi 'pembungkus' yang akan diekspos ke Lua
  static int lua_set_led(lua_State *L) {
      // 1. Ambil argumen pertama dari stack Lua
      int status = lua_toboolean(L, 1);

      // 2. Panggil fungsi C asli
      hardware_set_led(status);

      // 3. Beri tahu Lua berapa banyak nilai yang dikembalikan (dalam hal ini, 0)
      return 0;
  }

  // Daftar fungsi yang akan didaftarkan ke Lua
  static const struct luaL_Reg my_lib[] = {
      {"led", lua_set_led},
      {NULL, NULL} // Penanda akhir
  };

  // Fungsi utama untuk membuka library ini di Lua
  int luaopen_my_module(lua_State *L) {
      luaL_newlib(L, my_lib);
      return 1;
  }
  ```

  **Kode Lua (`main.lua`):**

  ```lua
  -- Impor library C yang kita buat
  local my_module = require("my_module")

  print("Lua: Menyalakan LED...")
  my_module.led(true) -- Ini memanggil fungsi C 'lua_set_led'

  print("Lua: Mematikan LED...")
  my_module.led(false)
  ```

- **Referensi**:

  - [Programming in Lua - The C API](https://www.lua.org/pil/24.html)
  - [Lua Users Wiki - Binding Code to Lua](http://lua-users.org/wiki/BindingCodeToLua)

### **2.4. Arsitektur eLua dan Lingkungan Eksekusi**

- **Deskripsi Konkrit**: **eLua (Embedded Lua)** adalah sebuah proyek yang bertujuan untuk membawa kekuatan penuh Lua ke dunia _microcontrollers_. Ini bukan hanya interpreter Lua; ini adalah platform lengkap yang mencakup interpreter, modul-modul yang sudah dibuat untuk mengakses periferal perangkat keras, dan sebuah _shell_ untuk interaksi langsung dengan perangkat.

- **Representasi Visual Arsitektur eLua**:

  ```
  +--------------------------------------------+
  |             Aplikasi Kita (Lua)            |
  | (main.lua, modules, etc.)                  |
  +--------------------------------------------+
  |           Modul eLua (Lua/C)               |
  | (PIO, ADC, UART, I2C, SPI, NET, etc.)      |
  +--------------------------------------------+
  |               Lua VM (Interpreter)         |
  +--------------------------------------------+
  | Platform Abstraction Layer (PAL)           |  <-- Lapisan abstraksi
  +--------------------------------------------+
  | Driver Hardware Spesifik (C/Assembly)      |
  +--------------------------------------------+
  |        Hardware (MCU, Peripherals)         |
  +--------------------------------------------+
  ```

- **Terminologi dan Konsep**:

  - **Platform Abstraction Layer (PAL)**: Lapisan perangkat lunak yang menyembunyikan detail perangkat keras yang berbeda. Ini memungkinkan eLua (dan kode Lua Kita) berjalan di berbagai jenis MCU tanpa perubahan. Kita menulis `pio.set(pin, pio.HIGH)`, dan PAL menerjemahkannya ke operasi register yang benar untuk STM32, LPC, atau MCU lainnya.
  - **Modules**: Pustaka yang disediakan oleh eLua untuk mengontrol perangkat keras, seperti `pio` untuk GPIO, `adc` untuk ADC, `uart` untuk komunikasi serial, dll. Ini adalah implementasi dari konsep "binding" C ke Lua yang sudah kita bahas.

- **Referensi**:

  - [Situs Resmi eLua Project](https://eluaproject.net/)
  - [Dokumentasi Arsitektur eLua](https://www.google.com/search?q=http.eluaproject.net/doc/v0.9/en_arch_overview.html)

---

### **Langkah Selanjutnya dan Rekomendasi**

- **Fase 3 (Hardware Interface)**: Ini adalah aplikasi langsung dari Fase 2. Kita akan belajar menggunakan modul-modul eLua (atau NodeMCU untuk ESP8266/ESP32) untuk mempraktikkan semua yang telah Kita pelajari. Ini adalah bagian yang paling menyenangkan, di mana Kita bisa melihat kode Kita berinteraksi dengan dunia fisik (menyalakan LED, membaca sensor, menggerakkan motor).

- **Fase 4 (Real-time Systems)**: Di sini, konsep _coroutines_ dari Fase 1 menjadi sangat relevan. Kita akan belajar bagaimana membangun sistem yang responsif menggunakan _event loops_ dan _state machines_, pola yang sangat umum dalam _firmware_.

- **Audit dan Penyesuaian**: Kurikulum ini sudah sangat lengkap. Penambahan yang telah dilakukan lebih berfokus pada pendalaman konsep-konsep kunci (seperti GC dan C API) yang penting untuk pemahaman fundamental, bukan hanya penggunaan praktis. Untuk seorang pemula total, mungkin perlu menambahkan fase "0" yaitu "Pengenalan Elektronika Dasar" (apa itu voltase, arus, resistor, LED, GPIO), tetapi asumsi saya adalah Kita bisa mempelajarinya secara paralel.

#

Sangat disarankan agar Kita untuk benar-benar **mempraktikkan setiap contoh kode**. Dapatkan sebuah _development board_ yang didukung dengan baik oleh Lua (seperti ESP32 dengan NodeMCU, atau board yang kompatibel dengan eLua) dan coba setiap konsep satu per satu. Teori tanpa praktik tidak akan membawa Kita pada penguasaan.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

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
