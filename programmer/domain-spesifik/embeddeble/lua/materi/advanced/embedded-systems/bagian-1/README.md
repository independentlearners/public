### Daftar Isi Panduan Belajar

- [](#)
    - [Daftar Isi (Lanjutan)](#daftar-isi-lanjutan)
  - [**Fase 3: Hardware Interface dan Peripheral Control**](#fase-3-hardware-interface-dan-peripheral-control)
    - [**3.1. GPIO: Gerbang Menuju Dunia Fisik**](#31-gpio-gerbang-menuju-dunia-fisik)
    - [**3.2. ADC: Mengukur Dunia Analog**](#32-adc-mengukur-dunia-analog)
    - [**3.3. PWM: Mengontrol Intensitas dan Kecepatan**](#33-pwm-mengontrol-intensitas-dan-kecepatan)
    - [**3.4. Komunikasi Serial: UART**](#34-komunikasi-serial-uart)
    - [**3.5. Komunikasi Serial: I2C**](#35-komunikasi-serial-i2c)
    - [**3.6. Komunikasi Serial: SPI**](#36-komunikasi-serial-spi)
    - [**3.7. Timer dan Counter: Mengukur Waktu**](#37-timer-dan-counter-mengukur-waktu)
    - [**3.8. Interrupt Handling: Merespons Kejadian Seketika**](#38-interrupt-handling-merespons-kejadian-seketika)
  - [**Fase 4: Real-time Systems dan Scheduling**](#fase-4-real-time-systems-dan-scheduling)
    - [**4.1. Konsep Real-time: Ketepatan Waktu adalah Kunci**](#41-konsep-real-time-ketepatan-waktu-adalah-kunci)
    - [**4.2. Penjadwalan Tugas (Task Scheduling) dengan Coroutines**](#42-penjadwalan-tugas-task-scheduling-dengan-coroutines)
    - [**4.3. Event-driven Programming: Reaksi Terhadap Stimulus**](#43-event-driven-programming-reaksi-terhadap-stimulus)
    - [**4.4. State Machines: Mengelola Perilaku Kompleks**](#44-state-machines-mengelola-perilaku-kompleks)
    - [**Langkah Selanjutnya**](#langkah-selanjutnya)
- [](#-1)
    - [Daftar Isi (Lanjutan)](#daftar-isi-lanjutan-1)
  - [**Fase 5: Networking dan Communication**](#fase-5-networking-dan-communication)
    - [**5.1. TCP/IP Stack: Fondasi Jaringan**](#51-tcpip-stack-fondasi-jaringan)
    - [**5.2. WiFi: Konektivitas Nirkabel**](#52-wifi-konektivitas-nirkabel)
    - [**5.3. HTTP: Berkomunikasi dengan Web**](#53-http-berkomunikasi-dengan-web)
    - [**5.4. MQTT: Protokol Wajib untuk IoT**](#54-mqtt-protokol-wajib-untuk-iot)
  - [**Fase 6: IoT dan Cloud Integration**](#fase-6-iot-dan-cloud-integration)
    - [**6.1. Arsitektur IoT: Gambaran Besar**](#61-arsitektur-iot-gambaran-besar)
    - [**6.2. Integrasi Platform Cloud**](#62-integrasi-platform-cloud)
    - [**6.3. Serialisasi Data: JSON dan Format Efisien**](#63-serialisasi-data-json-dan-format-efisien)
    - [**6.4. Keamanan dan Enkripsi: SSL/TLS**](#64-keamanan-dan-enkripsi-ssltls)
    - [**6.5. OTA Updates: Pembaruan Jarak Jauh**](#65-ota-updates-pembaruan-jarak-jauh)
    - [**Langkah Selanjutnya**](#langkah-selanjutnya-1)

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

Sangat disarankan agar Kita untuk benar-benar **mempraktikkan setiap contoh kode**. Dapatkan sebuah _development board_ yang didukung dengan baik oleh Lua (seperti ESP32 dengan NodeMCU, atau board yang kompatibel dengan eLua) dan coba setiap konsep satu per satu. Teori tanpa praktik tidak akan membawa Kita pada penguasaan. Berikutnya kita akan menyelami interaksi langsung dengan perangkat keras, yang merupakan inti dari pemrograman _embedded systems_. Setelah itu, kita akan membahas bagaimana mengelola tugas-tugas secara efisien menggunakan konsep sistem _real-time_.

### Daftar Isi (Lanjutan)

- [](#)
    - [Daftar Isi (Lanjutan)](#daftar-isi-lanjutan)
  - [**Fase 3: Hardware Interface dan Peripheral Control**](#fase-3-hardware-interface-dan-peripheral-control)
    - [**3.1. GPIO: Gerbang Menuju Dunia Fisik**](#31-gpio-gerbang-menuju-dunia-fisik)
    - [**3.2. ADC: Mengukur Dunia Analog**](#32-adc-mengukur-dunia-analog)
    - [**3.3. PWM: Mengontrol Intensitas dan Kecepatan**](#33-pwm-mengontrol-intensitas-dan-kecepatan)
    - [**3.4. Komunikasi Serial: UART**](#34-komunikasi-serial-uart)
    - [**3.5. Komunikasi Serial: I2C**](#35-komunikasi-serial-i2c)
    - [**3.6. Komunikasi Serial: SPI**](#36-komunikasi-serial-spi)
    - [**3.7. Timer dan Counter: Mengukur Waktu**](#37-timer-dan-counter-mengukur-waktu)
    - [**3.8. Interrupt Handling: Merespons Kejadian Seketika**](#38-interrupt-handling-merespons-kejadian-seketika)
  - [**Fase 4: Real-time Systems dan Scheduling**](#fase-4-real-time-systems-dan-scheduling)
    - [**4.1. Konsep Real-time: Ketepatan Waktu adalah Kunci**](#41-konsep-real-time-ketepatan-waktu-adalah-kunci)
    - [**4.2. Penjadwalan Tugas (Task Scheduling) dengan Coroutines**](#42-penjadwalan-tugas-task-scheduling-dengan-coroutines)
    - [**4.3. Event-driven Programming: Reaksi Terhadap Stimulus**](#43-event-driven-programming-reaksi-terhadap-stimulus)
    - [**4.4. State Machines: Mengelola Perilaku Kompleks**](#44-state-machines-mengelola-perilaku-kompleks)
    - [**Langkah Selanjutnya**](#langkah-selanjutnya)
- [](#-1)
    - [Daftar Isi (Lanjutan)](#daftar-isi-lanjutan-1)
  - [**Fase 5: Networking dan Communication**](#fase-5-networking-dan-communication)
    - [**5.1. TCP/IP Stack: Fondasi Jaringan**](#51-tcpip-stack-fondasi-jaringan)
    - [**5.2. WiFi: Konektivitas Nirkabel**](#52-wifi-konektivitas-nirkabel)
    - [**5.3. HTTP: Berkomunikasi dengan Web**](#53-http-berkomunikasi-dengan-web)
    - [**5.4. MQTT: Protokol Wajib untuk IoT**](#54-mqtt-protokol-wajib-untuk-iot)
  - [**Fase 6: IoT dan Cloud Integration**](#fase-6-iot-dan-cloud-integration)
    - [**6.1. Arsitektur IoT: Gambaran Besar**](#61-arsitektur-iot-gambaran-besar)
    - [**6.2. Integrasi Platform Cloud**](#62-integrasi-platform-cloud)
    - [**6.3. Serialisasi Data: JSON dan Format Efisien**](#63-serialisasi-data-json-dan-format-efisien)
    - [**6.4. Keamanan dan Enkripsi: SSL/TLS**](#64-keamanan-dan-enkripsi-ssltls)
    - [**6.5. OTA Updates: Pembaruan Jarak Jauh**](#65-ota-updates-pembaruan-jarak-jauh)
    - [**Langkah Selanjutnya**](#langkah-selanjutnya-1)

---

## **Fase 3: Hardware Interface dan Peripheral Control**

Di fase ini, kita akan menggunakan modul-modul yang disediakan oleh _firmware_ seperti eLua atau NodeMCU untuk mengendalikan berbagai periferal pada _microcontroller_. Ini adalah penerapan praktis dari Lua C API yang telah kita bahas; fungsi-fungsi C yang rumit untuk mengontrol register perangkat keras dibungkus menjadi fungsi Lua yang sederhana.

### **3.1. GPIO: Gerbang Menuju Dunia Fisik**

- **Deskripsi Konkrit**: GPIO (General-Purpose Input/Output) adalah pin digital pada MCU yang dapat Anda program sebagai input (untuk membaca sinyal, misal dari tombol) atau sebagai output (untuk mengirim sinyal, misal untuk menyalakan LED). Ini adalah bentuk interaksi paling dasar dengan dunia luar.

- **Terminologi Kunci**:

  - **Pin**: Kaki fisik pada chip MCU.
  - **Input**: Mode di mana pin "mendengarkan" level tegangan dari luar (tinggi/HIGH atau rendah/LOW).
  - **Output**: Mode di mana pin "mengeluarkan" level tegangan (tinggi/HIGH atau rendah/LOW).
  - **HIGH/LOW**: Merepresentasikan nilai digital 1 (biasanya 3.3V atau 5V) dan 0 (biasanya 0V/GND).
  - **Pull-up/Pull-down Resistor**: Resistor internal yang dapat diaktifkan untuk memastikan pin input memiliki status default (HIGH atau LOW) saat tidak terhubung ke apa pun, mencegah kondisi "mengambang" (_floating_).

- **Contoh Kode (Gaya eLua/NodeMCU)**:

  ```lua
  -- Asumsikan LED terhubung ke pin 2, dan tombol ke pin 4
  local led_pin = 2
  local button_pin = 4

  -- 1. Konfigurasi pin
  -- Mengatur pin LED sebagai output
  pio.pin.setdir(pio.OUTPUT, led_pin)

  -- Mengatur pin tombol sebagai input dengan pull-up resistor internal
  -- Artinya, jika tombol tidak ditekan, pin akan membaca HIGH (1)
  pio.pin.setdir(pio.INPUT, button_pin)
  pio.pin.setpull(pio.PULLUP, button_pin)

  -- 2. Mengontrol output
  print("Menyalakan LED...")
  pio.pin.setval(1, led_pin) -- Set pin ke HIGH (1)
  -- Tunggu 2 detik (fungsi 'tmr.delay' akan dibahas nanti)
  tmr.delay(2000)
  print("Mematikan LED...")
  pio.pin.setval(0, led_pin) -- Set pin ke LOW (0)

  -- 3. Membaca input
  local nilai_tombol = pio.pin.getval(button_pin)

  if nilai_tombol == 0 then
    print("Tombol sedang ditekan!")
  else
    print("Tombol tidak ditekan.")
  end
  ```

- **Referensi**:

  - [eLua PIO Module Documentation](https://www.google.com/search?q=http.eluaproject.net/doc/v0.9/en_refman_gen_pio.html)

### **3.2. ADC: Mengukur Dunia Analog**

- **Deskripsi Konkrit**: Dunia nyata bersifat analog (kontinu), bukan digital (diskrit). Sensor seperti sensor suhu, cahaya, atau potensiometer menghasilkan sinyal tegangan yang bervariasi. ADC (Analog-to-Digital Converter) adalah periferal yang mengubah sinyal tegangan analog ini menjadi nilai digital yang dapat dibaca oleh MCU.

- **Terminologi Kunci**:

  - **Analog Signal**: Sinyal yang nilainya dapat bervariasi secara kontinu dalam suatu rentang.
  - **Resolution**: Jumlah bit yang digunakan ADC untuk merepresentasikan sinyal analog. ADC 10-bit dapat menghasilkan 2^10 = 1024 nilai berbeda (0-1023). ADC 12-bit menghasilkan 4096 nilai (0-4095). Semakin tinggi resolusi, semakin presisi pengukurannya.
  - **Sampling Rate**: Seberapa sering ADC mengambil sampel (mengukur) sinyal analog per detik.

- **Contoh Kode (Gaya eLua/NodeMCU)**:

  ```lua
  -- Asumsikan sensor analog terhubung ke channel ADC 0
  local adc_channel = 0
  local VREF = 3.3 -- Tegangan referensi ADC (biasanya 3.3V)
  local RESOLUTION = 10 -- Resolusi ADC 10-bit

  -- Membaca nilai digital mentah dari ADC
  -- NodeMCU: adc.read(adc_channel)
  -- eLua: adc.getval(adc_channel)
  local raw_value = adc.read(adc_channel) -- Hasilnya akan antara 0 dan 1023

  -- Mengonversi nilai mentah ke tegangan
  local voltage = (raw_value / (2^RESOLUTION - 1)) * VREF

  print("Nilai mentah ADC: " .. raw_value)
  print("Tegangan terukur: " .. string.format("%.2f", voltage) .. "V")
  ```

- **Referensi**:

  - [eLua ADC Module Documentation](https://www.google.com/search?q=http.eluaproject.net/doc/v0.9/en_refman_gen_adc.html)

### **3.3. PWM: Mengontrol Intensitas dan Kecepatan**

- **Deskripsi Konkrit**: PWM (Pulse Width Modulation) adalah teknik untuk menghasilkan sinyal analog semu dari pin digital. Caranya adalah dengan menyalakan dan mematikan pin digital dengan sangat cepat. Dengan mengubah rasio waktu "nyala" terhadap waktu total (disebut _duty cycle_), kita bisa mengontrol daya rata-rata yang dikirim. Ini sangat berguna untuk mengontrol kecerahan LED, kecepatan motor DC, atau posisi motor servo.

- **Terminologi Kunci**:

  - **Frequency**: Seberapa sering siklus PWM berulang per detik (dalam Hertz).
  - **Duty Cycle**: Persentase waktu sinyal dalam keadaan HIGH dalam satu periode. 0% berarti selalu OFF, 100% berarti selalu ON, 50% berarti nyala setengah waktu.
  - **Period**: Waktu yang dibutuhkan untuk satu siklus lengkap (1 / frekuensi).

- **Representasi Visual**:

  ```
  Duty Cycle 25%: |`~|___|`~|___|`~|___  (Daya rendah)
  Duty Cycle 50%: |`~`~|___|`~`~|___  (Daya sedang)
  Duty Cycle 75%: |`~`~`~|_|`~`~`~|_  (Daya tinggi)
  ```

- **Contoh Kode (Gaya eLua/NodeMCU)**:

  ```lua
  -- Asumsikan LED yang dapat diredupkan terhubung ke pin PWM
  local pwm_pin = 5
  local pwm_id = 1 -- ID untuk channel PWM
  local frekuensi = 1000 -- 1000 Hz, cukup untuk LED

  -- Setup PWM
  -- NodeMCU: pwm.setup(pwm_pin, frekuensi, 0) -- pin, frekuensi, duty cycle awal (0-1023)
  -- eLua: pwm.setup(pwm_id, frekuensi, 0) -- id, frekuensi, duty cycle awal (0-100)
  pwm.setup(pwm_pin, frekuensi, 0)
  pwm.start(pwm_pin)

  -- Redupkan LED dari mati ke terang penuh
  print("Meredupkan LED...")
  for duty = 0, 1023 do -- Loop untuk duty cycle (format NodeMCU)
    pwm.setduty(pwm_pin, duty)
    tmr.delay_us(500) -- delay kecil dalam mikrodetik
  end

  print("LED pada kecerahan penuh.")
  pwm.stop(pwm_pin)
  ```

- **Referensi**:

  - [eLua PWM Module Documentation](https://www.google.com/search?q=http.eluaproject.net/doc/v0.9/en_refman_gen_pwm.html)

### **3.4. Komunikasi Serial: UART**

- **Deskripsi Konkrit**: UART (Universal Asynchronous Receiver-Transmitter) adalah salah satu bentuk komunikasi serial paling sederhana dan umum. Ini memungkinkan komunikasi dua arah antara dua perangkat menggunakan dua kabel: TX (Transmit) dan RX (Receive). Ini sering digunakan untuk debugging (mencetak log ke komputer), atau berkomunikasi dengan modul lain seperti GPS atau GSM.

- **Terminologi Kunci**:

  - **Asynchronous**: Tidak ada sinyal clock bersama. Kedua perangkat harus setuju pada kecepatan yang sama sebelumnya.
  - **Baud Rate**: Kecepatan komunikasi, dalam bit per detik. Nilai umum adalah 9600, 115200.
  - **TX (Transmit)**: Pin untuk mengirim data. TX satu perangkat terhubung ke RX perangkat lain.
  - **RX (Receive)**: Pin untuk menerima data. RX satu perangkat terhubung ke TX perangkat lain.
  - **Start/Stop Bit**: Bit tambahan yang dikirim untuk menandai awal dan akhir setiap byte data, membantu sinkronisasi.

- **Contoh Kode (Gaya eLua/NodeMCU)**:

  ```lua
  -- Inisialisasi UART dengan baud rate 9600
  local uart_id = 0
  local baud_rate = 9600
  uart.setup(uart_id, baud_rate, 8, uart.PARITY_NONE, uart.STOPBITS_1)

  -- Mengirim data melalui UART
  uart.write(uart_id, "Halo dari MCU!\n")

  -- Menerima data (biasanya dilakukan dengan callback/interrupt)
  uart.on("data", function(data)
    print("Data diterima dari UART: " .. data)
  end)
  ```

- **Referensi**:

  - [eLua UART Module Documentation](https://www.google.com/search?q=http.eluaproject.net/doc/v0.9/en_refman_gen_uart.html)

### **3.5. Komunikasi Serial: I2C**

- **Deskripsi Konkrit**: I2C (Inter-Integrated Circuit) adalah protokol komunikasi serial yang memungkinkan satu perangkat utama (_master_, biasanya MCU) untuk berkomunikasi dengan banyak perangkat bawahan (_slaves_, misal sensor, memori, layar) hanya dengan menggunakan **dua kabel**: SDA (Serial Data) dan SCL (Serial Clock). Setiap _slave_ di bus memiliki alamat unik.

- **Terminologi Kunci**:

  - **Master**: Perangkat yang menginisiasi komunikasi dan menghasilkan sinyal clock.
  - **Slave**: Perangkat yang merespons master.
  - **SDA (Serial Data Line)**: Jalur untuk transfer data dua arah.
  - **SCL (Serial Clock Line)**: Jalur untuk sinyal clock yang disinkronkan oleh master.
  - **Device Address**: Alamat 7-bit unik untuk setiap slave di bus.

- **Representasi Visual**:

  ```
        +----------+      +----------------+      +----------------+
  MCU   |  Master  |      | Sensor (0x68)  |      | EEPROM (0x50)  |
        |          |      |                |      |                |
        |      SCL |<----->| SCL            |<----->| SCL            |
        |      SDA |<----->| SDA            |<----->| SDA            |
        +----------+      +----------------+      +----------------+
  ```

- **Contoh Kode (Gaya eLua/NodeMCU)**:

  ```lua
  local i2c_id = 0
  local sda_pin, scl_pin = 5, 6
  local slave_address = 0x68 -- Alamat sensor, misal MPU6050

  -- Inisialisasi I2C
  i2c.setup(i2c_id, sda_pin, scl_pin, i2c.FAST) -- FAST mode = 400kHz

  -- Membaca register dari slave
  i2c.start(i2c_id) -- Mulai komunikasi
  i2c.address(i2c_id, slave_address, i2c.TRANSMITTER) -- Kirim alamat slave (mode tulis)
  i2c.write(i2c_id, 0x75) -- Tulis alamat register yang ingin dibaca (misal WHO_AM_I)
  i2c.stop(i2c_id) -- Hentikan (atau restart)

  i2c.start(i2c_id)
  i2c.address(i2c_id, slave_address, i2c.RECEIVER) -- Kirim alamat slave (mode baca)
  local data = i2c.read(i2c_id, 1) -- Baca 1 byte
  i2c.stop(i2c_id)

  print("Data dari I2C slave: " .. data)
  ```

- **Referensi**:

  - [eLua I2C Module Documentation](https://www.google.com/search?q=http.eluaproject.net/doc/v0.9/en_refman_gen_i2c.html)
  - [Tutorial Protokol I2C](https://www.electronics-tutorials.ws/comms/i2c-protocol.html)

### **3.6. Komunikasi Serial: SPI**

- **Deskripsi Konkrit**: SPI (Serial Peripheral Interface) adalah protokol komunikasi serial **sinkron** lainnya. Biasanya lebih cepat dari I2C dan bersifat _full-duplex_ (bisa mengirim dan menerima data secara bersamaan). SPI menggunakan lebih banyak kabel (biasanya 4) dan cocok untuk periferal berkecepatan tinggi seperti kartu SD, layar grafis, dan beberapa jenis sensor.

- **Terminologi Kunci**:

  - **Full-duplex**: Transfer data dua arah secara simultan.
  - **MISO (Master In, Slave Out)**: Jalur data dari Slave ke Master.
  - **MOSI (Master Out, Slave In)**: Jalur data dari Master ke Slave.
  - **SCK (Serial Clock)**: Sinyal clock dari Master.
  - **CS/SS (Chip Select / Slave Select)**: Pin yang digunakan Master untuk memilih _slave_ mana yang akan diajak bicara. Setiap _slave_ membutuhkan pin CS sendiri.

- **Contoh Kode (Gaya eLua/NodeMCU)**:

  ```lua
  local spi_id = 1
  local cs_pin = 4 -- Pin Chip Select
  local clock_speed = 1000000 -- 1 MHz

  -- Konfigurasi pin CS sebagai output
  pio.pin.setdir(pio.OUTPUT, cs_pin)
  pio.pin.setval(1, cs_pin) -- Non-aktifkan slave (biasanya CS aktif LOW)

  -- Setup SPI
  spi.setup(spi_id, spi.MASTER, clock_speed, 8, 0) -- id, mode, speed, bits, CPHA/CPOL

  -- Mengirim dan menerima data
  local data_to_send = {0x9F, 0x00, 0x00} -- Perintah JEDEC ID untuk flash memory

  pio.pin.setval(0, cs_pin) -- Aktifkan slave
  local received_data = spi.send(spi_id, data_to_send)
  pio.pin.setval(1, cs_pin) -- Non-aktifkan slave

  print("Data diterima dari SPI slave:")
  for i, byte in ipairs(received_data) do
    print(string.format("Byte %d: 0x%02X", i, byte))
  end
  ```

- **Referensi**:

  - [eLua SPI Module Documentation](https://www.google.com/search?q=http.eluaproject.net/doc/v0.9/en_refman_gen_spi.html)
  - [SparkFun - Serial Peripheral Interface (SPI)](https://learn.sparkfun.com/tutorials/serial-peripheral-interface-spi)

### **3.7. Timer dan Counter: Mengukur Waktu**

- **Deskripsi Konkrit**: Timer adalah periferal perangkat keras yang sangat penting. Mereka dapat digunakan untuk menghitung waktu dengan presisi tinggi, menghasilkan penundaan (_delay_) tanpa memblokir eksekusi (tidak seperti `sleep`), atau memicu aksi (seperti _interrupt_) secara periodik.

- **Terminologi Kunci**:

  - **Prescaler**: Pembagi frekuensi yang memperlambat clock input ke timer, memungkinkan pengukuran interval waktu yang lebih lama.
  - **Periodic Mode**: Timer akan di-reset dan memicu event setiap kali mencapai nilai tertentu.
  - **One-shot Mode**: Timer akan berjalan sekali dan kemudian berhenti.

- **Contoh Kode (Gaya eLua/NodeMCU)**:

  ```lua
  local timer_id = 0
  local interval_ms = 1000 -- 1000 ms = 1 detik

  -- Membuat alarm yang berulang setiap 1 detik
  tmr.alarm(timer_id, interval_ms, tmr.ALARM_AUTO, function()
    print("Satu detik telah berlalu!")
    -- Di sini Anda bisa meletakkan kode yang perlu dijalankan secara periodik,
    -- misalnya membaca sensor.
  end)
  ```

- **Referensi**:

  - [eLua Timer Module Documentation](https://www.google.com/search?q=http.eluaproject.net/doc/v0.9/en_refman_gen_tmr.html)

### **3.8. Interrupt Handling: Merespons Kejadian Seketika**

- **Deskripsi Konkrit**: _Interrupt_ adalah sinyal dari perangkat keras (atau perangkat lunak) ke prosesor yang menandakan bahwa ada sebuah kejadian penting yang membutuhkan perhatian segera. Ketika _interrupt_ terjadi, prosesor akan menjeda tugasnya saat ini, menjalankan kode khusus yang disebut _Interrupt Service Routine_ (ISR), lalu melanjutkan tugasnya. Ini jauh lebih efisien daripada terus-menerus memeriksa status perangkat (disebut _polling_).

- **Terminologi Kunci**:

  - **Polling**: Secara aktif memeriksa status perangkat dalam sebuah loop. Boros daya dan waktu CPU.
  - **Interrupt**: Mekanisme berbasis kejadian. CPU hanya bekerja saat dibutuhkan.
  - **ISR (Interrupt Service Routine)**: Fungsi khusus yang dieksekusi sebagai respons terhadap _interrupt_. ISR harus sangat cepat dan singkat.
  - **Callback Function**: Di lingkungan tingkat tinggi seperti Lua, kita biasanya mendaftarkan fungsi Lua sebagai _callback_ yang akan dipanggil ketika _interrupt_ terjadi.

- **Contoh Kode (Interrupt pada Pin GPIO)**:

  ```lua
  local button_pin = 4
  pio.pin.setdir(pio.INPUT, button_pin)

  -- Mendaftarkan fungsi callback untuk interrupt pada pin tombol
  -- Trigger ketika pin berubah dari HIGH ke LOW (tombol ditekan)
  pio.pin.settrig(pio.FALLING, button_pin, function(level)
    -- INI ADALAH "ISR" VERSI LUA
    -- Jaga agar kode di sini sangat singkat!
    print("Tombol ditekan! (Terdeteksi via interrupt)")
  end)

  print("Sistem siap menerima input. Coba tekan tombol.")
  -- Program utama bisa melakukan hal lain di sini,
  -- tanpa perlu memeriksa tombol terus-menerus.
  ```

- **Referensi**:

  - [eLua Interrupts Architecture](https://www.google.com/search?q=http.eluaproject.net/doc/v0.9/en_arch_interrupts.html)

---

## **Fase 4: Real-time Systems dan Scheduling**

Fase ini berfokus pada teknik perangkat lunak untuk mengelola kompleksitas dan waktu dalam aplikasi _embedded_.

### **4.1. Konsep Real-time: Ketepatan Waktu adalah Kunci**

- **Deskripsi Konkrit**: Seperti yang dibahas sebelumnya, sistem _real-time_ dinilai tidak hanya dari kebenaran hasil logisnya, tetapi juga dari ketepatan waktu dihasilkannya hasil tersebut. Lua, sebagai bahasa yang diinterpretasi dengan _garbage collector_, secara tradisional bukan pilihan utama untuk sistem _hard real-time_. Namun, untuk _soft real-time_ (di mana sedikit keterlambatan masih bisa ditoleransi), Lua sangat mumpuni, terutama jika GC-nya bersifat _incremental_.

- **Terminologi Kunci**:

  - **Determinism**: Kemampuan sistem untuk menghasilkan output yang sama dan dalam waktu yang sama untuk input yang sama. Kode C yang ditulis dengan baik lebih deterministik daripada skrip Lua.
  - **Latency**: Waktu tunda antara input/kejadian dan respons sistem.
  - **Jitter**: Variasi dalam _latency_. Jitter yang tinggi tidak diinginkan dalam sistem _real-time_.

- **Referensi**:

  - [Real-Time Operating Systems (RTOS) Concepts](https://www.geeksforgeeks.org/real-time-operating-system-rtos/)

### **4.2. Penjadwalan Tugas (Task Scheduling) dengan Coroutines**

- **Deskripsi Konkrit**: Dalam aplikasi _embedded_ yang nyata, Anda perlu melakukan banyak hal "secara bersamaan": membaca sensor, mengupdate tampilan, berkedip LED, dan memeriksa koneksi jaringan. Karena MCU biasanya hanya memiliki satu inti prosesor, "kebersamaan" ini adalah ilusi yang diciptakan oleh penjadwal (_scheduler_). Dengan _coroutines_, kita bisa membuat penjadwal kooperatif sederhana di Lua.

- **Konsep**:
  Buat sebuah _scheduler_ yang menyimpan daftar _coroutines_ yang siap dijalankan. Dalam _loop_ utamanya, _scheduler_ mengambil satu _coroutine_, menjalankannya (`coroutine.resume`), dan _coroutine_ itu akan berjalan sampai ia `coroutine.yield()`. Ketika `yield` dipanggil, kontrol kembali ke _scheduler_, yang kemudian dapat menjalankan _coroutine_ berikutnya.

- **Contoh Kode (Scheduler Kooperatif Sederhana)**:

  ```lua
  local scheduler = {}
  scheduler.tasks = {}

  function scheduler.add_task(func)
    table.insert(scheduler.tasks, coroutine.create(func))
  end

  function scheduler.run()
    while #scheduler.tasks > 0 do
      for i, task in ipairs(scheduler.tasks) do
        local status, err = coroutine.resume(task)
        if not status then -- Coroutine selesai atau error
          table.remove(scheduler.tasks, i)
          if err then print("Error:", err) end
        end
      end
    end
  end

  -- Definisikan beberapa tugas
  scheduler.add_task(function()
    for i=1, 5 do
      print("Tugas A: Langkah " .. i)
      coroutine.yield() -- Serahkan kontrol
    end
  end)

  scheduler.add_task(function()
    for i=1, 3 do
      print("Tugas B: Langkah " .. i)
      coroutine.yield() -- Serahkan kontrol
    end
  end)

  -- Jalankan scheduler
  scheduler.run()
  ```

- **Referensi**:

  - [Lua Users Wiki - Cooperative Multitasking](http://lua-users.org/wiki/CooperativeMultitasking)

### **4.3. Event-driven Programming: Reaksi Terhadap Stimulus**

- **Deskripsi Konkrit**: Ini adalah paradigma pemrograman di mana alur program ditentukan oleh kejadian (_events_), seperti _interrupt_ dari perangkat keras, data yang tiba di port serial, atau timer yang berakhir. Ini adalah model yang sangat alami untuk _embedded systems_. Alih-alih satu _loop_ besar yang melakukan segalanya, Anda memiliki _loop_ utama yang sederhana (sering disebut _event loop_) yang menunggu kejadian dan kemudian memanggil fungsi _handler_ yang sesuai.

- **Konsep**: Kombinasikan _interrupts_, _timers_, dan _callbacks_. _Interrupt_ dari pin akan memasukkan sebuah "kejadian tombol ditekan" ke dalam antrian. _Loop_ utama memeriksa antrian ini dan menjalankan _handler_ yang terkait. Model ini sangat efisien karena CPU bisa dalam mode hemat daya saat tidak ada kejadian yang perlu diproses.

- **Contoh Kode (Pola Event Loop)**:

  ```lua
  local event_queue = {}

  -- Fungsi ini dipanggil oleh ISR (harus cepat)
  local function on_button_press_isr()
    table.insert(event_queue, {type="BUTTON_PRESS", value=true})
  end

  -- Daftarkan ISR ke interrupt pin
  -- pio.pin.settrig(..., on_button_press_isr)

  -- Loop utama / Event Loop
  while true do
    if #event_queue > 0 then
      local event = table.remove(event_queue, 1) -- Ambil event pertama

      if event.type == "BUTTON_PRESS" then
        -- Proses event di sini (bisa lebih lambat)
        print("Event 'BUTTON_PRESS' sedang diproses di loop utama.")
        -- nyalakan_led(), kirim_data(), dll.
      end
    end
    -- Lakukan tugas latar belakang lain atau masuk mode hemat daya
  end
  ```

- **Referensi**:

  - [Lua Users Wiki - Event-driven Programming](http://lua-users.org/wiki/EventDrivenProgramming)

### **4.4. State Machines: Mengelola Perilaku Kompleks**

- **Deskripsi Konkrit**: Banyak perangkat _embedded_ memiliki perilaku yang dapat dimodelkan sebagai _Finite State Machine_ (FSM). Perangkat berada dalam satu keadaan (_state_) pada satu waktu. Berdasarkan input atau kejadian, perangkat dapat bertransisi ke keadaan lain. Contoh: Pintu otomatis memiliki keadaan `TERBUKA`, `TERTUTUP`, `MEMBUKA`, `MENUTUP`. Sensor gerak (input) akan memicu transisi dari `TERTUTUP` ke `MEMBUKA`.

- **Konsep**: Implementasikan FSM menggunakan variabel untuk menyimpan _state_ saat ini. Gunakan struktur `if-then-else` atau `table` berisi fungsi untuk mendefinisikan apa yang harus dilakukan di setiap _state_ dan bagaimana transisi terjadi. Ini membuat kode lebih terorganisir, lebih mudah dipahami, dan lebih mudah di-debug daripada serangkaian `if` yang bersarang dan berantakan.

- **Contoh Kode (FSM untuk Lampu Lalu Lintas)**:

  ```lua
  local state = "MERAH" -- State awal

  local function handle_state()
    if state == "MERAH" then
      print("Lampu MERAH. Berhenti.")
      -- Setelah 10 detik, ubah state
      tmr.alarm(0, 10000, tmr.ALARM_SINGLE, function() state = "HIJAU" end)

    elseif state == "HIJAU" then
      print("Lampu HIJAU. Jalan.")
      -- Setelah 10 detik, ubah state
      tmr.alarm(0, 10000, tmr.ALARM_SINGLE, function() state = "KUNING" end)

    elseif state == "KUNING" then
      print("Lampu KUNING. Hati-hati.")
      -- Setelah 3 detik, ubah state
      tmr.alarm(0, 3000, tmr.ALARM_SINGLE, function() state = "MERAH" end)
    end
  end

  -- Loop utama hanya memanggil handler state saat ini
  -- (Ini bisa digabungkan dengan event loop)
  tmr.alarm(1, 100, tmr.ALARM_AUTO, handle_state) -- Panggil handle_state setiap 100ms
  ```

- **Referensi**:

  - [Lua Users Wiki - State Machines](http://lua-users.org/wiki/FiniteStateMachine)
  - [Embedded.com - State Machine Design](https://www.embedded.com/state-machine-design-in-c/)

---

### **Langkah Selanjutnya**

Anda sekarang memiliki pemahaman yang kuat tentang bagaimana Lua berinteraksi dengan perangkat keras dan bagaimana mengelola tugas-tugas dalam lingkungan _embedded_. Fase-fase berikutnya (Networking, IoT, Cloud Integration) akan membangun di atas fondasi ini, menggunakan periferal komunikasi (seperti UART, SPI) untuk terhubung ke jaringan (WiFi, Ethernet) dan menerapkan protokol tingkat tinggi (HTTP, MQTT).

Pemahaman tentang _event-driven programming_ dan _state machines_ akan sangat krusial saat Anda mulai membangun aplikasi IoT yang kompleks yang harus mengelola koneksi jaringan, input sensor, dan interaksi pengguna secara bersamaan.

#

Sekarang kita akan memasuki ranah konektivitas. Fase ini akan menunjukkan bagaimana perangkat _embedded_ Anda yang tadinya berdiri sendiri dapat berkomunikasi dengan perangkat lain, baik di jaringan lokal maupun di internet. Ini adalah jembatan menuju dunia _Internet of Things_ (IoT).

### Daftar Isi (Lanjutan)

- [](#)
    - [Daftar Isi (Lanjutan)](#daftar-isi-lanjutan)
  - [**Fase 3: Hardware Interface dan Peripheral Control**](#fase-3-hardware-interface-dan-peripheral-control)
    - [**3.1. GPIO: Gerbang Menuju Dunia Fisik**](#31-gpio-gerbang-menuju-dunia-fisik)
    - [**3.2. ADC: Mengukur Dunia Analog**](#32-adc-mengukur-dunia-analog)
    - [**3.3. PWM: Mengontrol Intensitas dan Kecepatan**](#33-pwm-mengontrol-intensitas-dan-kecepatan)
    - [**3.4. Komunikasi Serial: UART**](#34-komunikasi-serial-uart)
    - [**3.5. Komunikasi Serial: I2C**](#35-komunikasi-serial-i2c)
    - [**3.6. Komunikasi Serial: SPI**](#36-komunikasi-serial-spi)
    - [**3.7. Timer dan Counter: Mengukur Waktu**](#37-timer-dan-counter-mengukur-waktu)
    - [**3.8. Interrupt Handling: Merespons Kejadian Seketika**](#38-interrupt-handling-merespons-kejadian-seketika)
  - [**Fase 4: Real-time Systems dan Scheduling**](#fase-4-real-time-systems-dan-scheduling)
    - [**4.1. Konsep Real-time: Ketepatan Waktu adalah Kunci**](#41-konsep-real-time-ketepatan-waktu-adalah-kunci)
    - [**4.2. Penjadwalan Tugas (Task Scheduling) dengan Coroutines**](#42-penjadwalan-tugas-task-scheduling-dengan-coroutines)
    - [**4.3. Event-driven Programming: Reaksi Terhadap Stimulus**](#43-event-driven-programming-reaksi-terhadap-stimulus)
    - [**4.4. State Machines: Mengelola Perilaku Kompleks**](#44-state-machines-mengelola-perilaku-kompleks)
    - [**Langkah Selanjutnya**](#langkah-selanjutnya)
- [](#-1)
    - [Daftar Isi (Lanjutan)](#daftar-isi-lanjutan-1)
  - [**Fase 5: Networking dan Communication**](#fase-5-networking-dan-communication)
    - [**5.1. TCP/IP Stack: Fondasi Jaringan**](#51-tcpip-stack-fondasi-jaringan)
    - [**5.2. WiFi: Konektivitas Nirkabel**](#52-wifi-konektivitas-nirkabel)
    - [**5.3. HTTP: Berkomunikasi dengan Web**](#53-http-berkomunikasi-dengan-web)
    - [**5.4. MQTT: Protokol Wajib untuk IoT**](#54-mqtt-protokol-wajib-untuk-iot)
  - [**Fase 6: IoT dan Cloud Integration**](#fase-6-iot-dan-cloud-integration)
    - [**6.1. Arsitektur IoT: Gambaran Besar**](#61-arsitektur-iot-gambaran-besar)
    - [**6.2. Integrasi Platform Cloud**](#62-integrasi-platform-cloud)
    - [**6.3. Serialisasi Data: JSON dan Format Efisien**](#63-serialisasi-data-json-dan-format-efisien)
    - [**6.4. Keamanan dan Enkripsi: SSL/TLS**](#64-keamanan-dan-enkripsi-ssltls)
    - [**6.5. OTA Updates: Pembaruan Jarak Jauh**](#65-ota-updates-pembaruan-jarak-jauh)
    - [**Langkah Selanjutnya**](#langkah-selanjutnya-1)

---

## **Fase 5: Networking dan Communication**

Di sini kita akan memanfaatkan modul-modul jaringan yang ada di _firmware_ seperti NodeMCU (untuk ESP8266/ESP32) atau eLua dengan tambahan modul jaringan. Konsepnya sama: fungsi-fungsi C yang kompleks untuk mengelola koneksi jaringan dibungkus menjadi API Lua yang sederhana.

### **5.1. TCP/IP Stack: Fondasi Jaringan**

- **Deskripsi Konkrit**: TCP/IP (Transmission Control Protocol/Internet Protocol) adalah serangkaian protokol komunikasi yang menjadi dasar dari internet. Anda tidak perlu tahu setiap detailnya, tetapi pahami bahwa ini adalah sistem berlapis yang menangani segala hal mulai dari pengalamatan perangkat di jaringan hingga memastikan data sampai tanpa kesalahan. Untuk seorang programmer, interaksi kita dengan TCP/IP biasanya melalui _sockets_.

- **Terminologi Kunci**:

  - **Socket**: Titik akhir (endpoint) untuk komunikasi. Bayangkan sebagai "pintu" di perangkat Anda dengan nomor spesifik (disebut _port_) tempat data bisa masuk dan keluar.
  - **IP Address**: Alamat unik perangkat Anda di jaringan (misal: `192.168.1.10`).
  - **Port**: Nomor yang mengidentifikasi aplikasi atau layanan spesifik di dalam perangkat (misal: port 80 untuk HTTP).
  - **TCP (Transmission Control Protocol)**: Protokol yang berorientasi koneksi (_connection-oriented_) dan andal (_reliable_). Ia memastikan semua data sampai, dalam urutan yang benar. Cocok untuk transfer file atau web Browse.
  - **UDP (User Datagram Protocol)**: Protokol tanpa koneksi (_connectionless_) dan tidak andal. Data "ditembakkan" begitu saja. Lebih cepat tetapi data bisa hilang atau tidak berurutan. Cocok untuk _streaming_ video atau game.

- **Contoh Kode (TCP Client Sederhana dengan NodeMCU)**:

  ```lua
  -- Membuat TCP client untuk terhubung ke server
  local client = net.createConnection(net.TCP, 0) -- 0 untuk non-secure

  -- Callback ketika koneksi berhasil
  client:on("connection", function(sck)
    print("Terhubung ke server!")
    -- Mengirim data ke server
    sck:send("Halo dari klien ESP32!")
  end)

  -- Callback ketika menerima data dari server
  client:on("receive", function(sck, payload)
    print("Menerima data: " .. payload)
    sck:close() -- Tutup koneksi setelah menerima balasan
  end)

  -- Callback ketika koneksi terputus
  client:on("disconnection", function(sck)
    print("Koneksi terputus.")
  end)

  -- Hubungkan ke server (ganti dengan IP dan port server Anda)
  client:connect(8080, "192.168.1.5")
  ```

- **Referensi**:

  - [Dokumentasi LuaSocket](https://lunarmodules.github.io/luasocket/) (dasar dari banyak implementasi socket di Lua)
  - [eLua Net Module](https://www.google.com/search?q=http.eluaproject.net/doc/v0.9/en_refman_gen_net.html)

### **5.2. WiFi: Konektivitas Nirkabel**

- **Deskripsi Konkrit**: Ini adalah teknologi yang memungkinkan perangkat Anda terhubung ke jaringan lokal (LAN) dan internet tanpa kabel. Untuk perangkat IoT seperti ESP32, modul WiFi adalah komponen inti.

- **Terminologi Kunci**:

  - **Station (STA) Mode**: Mode di mana perangkat Anda bertindak sebagai klien yang terhubung ke sebuah _Access Point_ (AP) WiFi, seperti router di rumah Anda.
  - **Access Point (AP) Mode**: Mode di mana perangkat Anda bertindak sebagai router mini. Perangkat lain (seperti ponsel) bisa terhubung langsung ke perangkat Anda. Berguna untuk konfigurasi awal.
  - **SSID (Service Set Identifier)**: Nama jaringan WiFi Anda (misal: "RumahKu").
  - **Password**: Kata sandi untuk jaringan WiFi Anda.

- **Contoh Kode (Menghubungkan ESP32/NodeMCU ke WiFi)**:

  ```lua
  local ssid = "RumahKu"
  local password = "password_rahasia"

  -- Atur mode ke Station (STA)
  wifi.setmode(wifi.STATION)

  -- Konfigurasi koneksi
  wifi.sta.config({ssid = ssid, pwd = password})

  -- Hubungkan
  wifi.sta.connect()

  print("Menghubungkan ke WiFi...")

  -- Gunakan timer untuk memeriksa status koneksi secara berkala
  tmr.alarm(1, 1000, tmr.ALARM_AUTO, function()
    local status = wifi.sta.status()
    if status == wifi.sta.GOT_IP then
      print("Berhasil terhubung! Alamat IP: " .. wifi.sta.getip())
      tmr.stop(1) -- Hentikan timer jika sudah terhubung
    else
      print("Status koneksi: " .. status)
    end
  end)
  ```

- **Referensi**:

  - [NodeMCU WiFi Module Documentation](https://nodemcu.readthedocs.io/en/latest/modules/wifi/)

### **5.3. HTTP: Berkomunikasi dengan Web**

- **Deskripsi Konkrit**: HTTP (Hypertext Transfer Protocol) adalah protokol yang menjalankan World Wide Web. Perangkat Anda dapat bertindak sebagai **klien HTTP** untuk mengambil data dari API (misalnya, data cuaca) atau sebagai **server HTTP** untuk menyajikan halaman web sederhana yang bisa Anda akses dari browser untuk mengontrol perangkat.

- **Terminologi Kunci**:

  - **HTTP Client**: Pihak yang memulai permintaan (misal: browser atau MCU Anda).
  - **HTTP Server**: Pihak yang merespons permintaan (misal: `google.com` atau MCU Anda).
  - **GET Request**: Meminta data dari server.
  - **POST Request**: Mengirim data ke server untuk diproses (misal, mengirimkan formulir).
  - **REST API (Representational State Transfer API)**: Gaya arsitektur populer untuk layanan web yang menggunakan metode HTTP standar (GET, POST, PUT, DELETE) untuk berinteraksi dengan sumber daya.

- **Contoh Kode**:

  **1. Sebagai Klien HTTP (Mengambil data JSON dari API)**

  ```lua
  -- Mengambil data dari API placeholder
  http.get("https://jsonplaceholder.typicode.com/todos/1", nil, function(code, data)
    if (code < 0) then
      print("Permintaan HTTP gagal")
    else
      print("Kode status: " .. code)
      print("Data diterima: " .. data)
      -- 'data' adalah string JSON, kita bisa mem-parsing-nya
      -- local obj = sjson.decode(data)
      -- print("Judul: " .. obj.title)
    end
  end)
  ```

  **2. Sebagai Server HTTP (Mengontrol LED dari Browser)**

  ```lua
  local led_pin = 2
  pio.pin.setdir(pio.OUTPUT, led_pin)

  -- Buat server di port 80
  local srv = net.createServer(net.TCP)
  srv:listen(80, function(conn)
    conn:on("receive", function(sck, request)
      -- Cek URL yang diminta
      if string.find(request, "GET /led_on") then
        pio.pin.setval(1, led_pin) -- Nyalakan LED
      elseif string.find(request, "GET /led_off") then
        pio.pin.setval(0, led_pin) -- Matikan LED
      end

      -- Kirim halaman HTML sederhana sebagai balasan
      local html_response = "<h1>Kontrol LED</h1><a href='/led_on'>Nyalakan</a> | <a href='/led_off'>Matikan</a>"
      sck:send("HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n" .. html_response)
      sck:close()
    end)
  end)
  ```

- **Referensi**:

  - [NodeMCU HTTP Module Documentation](https://nodemcu.readthedocs.io/en/latest/modules/http/)

### **5.4. MQTT: Protokol Wajib untuk IoT**

- **Deskripsi Konkrit**: MQTT (Message Queuing Telemetry Transport) adalah protokol _publish-subscribe_ yang sangat ringan, dirancang khusus untuk perangkat dengan sumber daya terbatas dan jaringan yang tidak andal. Ini adalah standar de-facto untuk komunikasi IoT.

- **Terminologi Kunci**:

  - **Publish-Subscribe Pattern**: Pengirim pesan (_publisher_) tidak mengirim pesan langsung ke penerima (_subscriber_). Sebaliknya, _publisher_ mengirim pesan ke sebuah "topik" di server pusat yang disebut _broker_. _Subscriber_ yang tertarik pada topik tersebut akan menerima pesan tersebut dari _broker_.
  - **Broker**: Server pusat yang menerima semua pesan dari _publisher_ dan meneruskannya ke _subscriber_ yang relevan.
  - **Topic**: String yang bertindak sebagai "saluran" untuk pesan (misal: `rumah/kamar_tidur/suhu`).
  - **QoS (Quality of Service)**: Level jaminan pengiriman pesan (0: paling banyak sekali, 1: setidaknya sekali, 2: tepat sekali).

- **Representasi Visual**:

  ```
                    +----------------+
                    | MQTT Broker    |
                    +----------------+
                         ^      |
  Publish ke topik     |      |  Kirim ke subscriber
  "sensor/suhu"        |      |
                       |      v
  +----------------+   |   +----------------+
  | Sensor Suhu    | --+   | Aplikasi Ponsel|
  | (Publisher)    |       | (Subscriber)   |
  +----------------+       +----------------+
  ```

- **Contoh Kode (Klien MQTT dengan NodeMCU)**:

  ```lua
  -- Inisialisasi klien MQTT
  -- "my_device_id" harus unik untuk setiap perangkat
  local mqtt_client = mqtt.Client("my_device_id", 120) -- 120 detik timeout

  mqtt_client:on("connect", function(client)
    print("Terhubung ke broker MQTT")
    -- Berlangganan (subscribe) ke topik untuk menerima perintah
    client:subscribe("perintah/led", 0, function(client)
      print("Berhasil subscribe ke topik perintah/led")
    end)
  end)

  -- Callback ketika pesan diterima
  mqtt_client:on("message", function(client, topic, data)
    print("Menerima pesan - Topik: " .. topic .. ", Data: " .. data)
    if topic == "perintah/led" then
      if data == "ON" then pio.pin.setval(1, led_pin) end
      if data == "OFF" then pio.pin.setval(0, led_pin) end
    end
  end)

  -- Hubungkan ke broker publik (gunakan broker sendiri untuk produksi)
  mqtt_client:connect("broker.hivemq.com", 1883, 0)

  -- Mempublikasikan (publish) data sensor setiap 5 detik
  tmr.alarm(2, 5000, tmr.ALARM_AUTO, function()
    local suhu = 27.5 -- baca dari sensor asli
    print("Mengirim data suhu...")
    mqtt_client:publish("sensor/suhu", suhu, 0, 0)
  end)
  ```

- **Referensi**:

  - [NodeMCU MQTT Module Documentation](https://nodemcu.readthedocs.io/en/latest/modules/mqtt/)
  - [Spesifikasi MQTT](https://mqtt.org/mqtt-specification/)

---

## **Fase 6: IoT dan Cloud Integration**

Fase ini membawa kita ke level berikutnya: menghubungkan perangkat kita ke platform cloud besar untuk penyimpanan data, analisis, dan manajemen skala besar.

### **6.1. Arsitektur IoT: Gambaran Besar**

- **Deskripsi Konkrit**: Sistem IoT yang lengkap biasanya terdiri dari beberapa lapisan:

  1.  **Perangkat (Device Layer)**: "Benda" itu sendiri, seperti sensor suhu atau lampu pintar kita yang menjalankan Lua.
  2.  **Komunikasi (Connectivity Layer)**: Bagaimana perangkat terhubung (WiFi, seluler, dll.) dan protokol yang digunakan (MQTT, HTTP).
  3.  **Platform Cloud (Platform Layer)**: "Otak" dari sistem. Tempat data diterima, disimpan, diproses, dan dianalisis. Contoh: AWS IoT, Google Cloud IoT, Azure IoT.
  4.  **Aplikasi (Application Layer)**: Antarmuka pengguna akhir, seperti dasbor web atau aplikasi seluler yang menampilkan data dan memungkinkan pengguna mengirim perintah.

- **Referensi**:

  - [Panduan Arsitektur IoT](https://www.iotforall.com/iot-architecture-guide)

### **6.2. Integrasi Platform Cloud**

- **Deskripsi Konkrit**: Platform seperti AWS IoT Core atau Google Cloud IoT Core pada dasarnya menyediakan _MQTT broker_ yang aman dan berskala besar. Alih-alih terhubung ke broker publik, perangkat Anda akan terhubung ke _endpoint_ spesifik yang disediakan oleh platform cloud, menggunakan sertifikat keamanan untuk otentikasi.

- **Konsep**: Prosesnya mirip dengan contoh MQTT di atas, tetapi dengan beberapa langkah tambahan yang penting:

  1.  **Provisioning**: Mendaftarkan perangkat Anda di platform cloud untuk mendapatkan kredensial keamanan (sertifikat dan kunci privat).
  2.  **Secure Connection**: Klien MQTT Anda harus dikonfigurasi untuk menggunakan koneksi SSL/TLS dan menyajikan sertifikatnya saat menghubungkan ke _endpoint_ broker cloud.
  3.  **Rules Engine**: Setelah data masuk ke cloud (misalnya, data suhu), Anda dapat membuat aturan (mis. "Jika suhu \> 30, kirim notifikasi email") untuk memproses data tersebut secara otomatis.

- **Referensi**:

  - [AWS IoT Device SDKs](https://docs.aws.amazon.com/iot/latest/developerguide/iot-sdks.html)
  - [Dokumentasi Google Cloud IoT Core](https://cloud.google.com/iot-core/docs) (Perhatikan: Google Cloud IoT Core akan dihentikan, tetapi konsepnya tetap relevan dan diterapkan di layanan lain).

### **6.3. Serialisasi Data: JSON dan Format Efisien**

- **Deskripsi Konkrit**: Saat mengirim data melalui jaringan, kita perlu mengubah struktur data kompleks (seperti _table_ Lua) menjadi format yang bisa ditransmisikan (seperti string atau urutan byte). Proses ini disebut **serialisasi**.

- **Terminologi Kunci**:

  - **JSON (JavaScript Object Notation)**: Format serialisasi berbasis teks yang sangat populer dan mudah dibaca manusia. Ini adalah pilihan yang baik untuk memulai.
  - **MessagePack, CBOR**: Format serialisasi biner. Mereka menghasilkan data yang jauh lebih kecil dan lebih cepat untuk di-parse oleh mesin dibandingkan JSON. Ini sangat penting untuk perangkat _embedded_ yang ingin menghemat _bandwidth_ dan daya baterai.
  - **Parsing/Decoding**: Proses kebalikan dari serialisasi, mengubah data kembali dari format transmisi menjadi struktur data asli.

- **Contoh Kode (Serialisasi ke JSON di Lua)**:

  ```lua
  -- Butuh library JSON, misalnya cjson atau sjson yang sering ada di NodeMCU
  local sjson = require("cjson")

  local data_sensor = {
    timestamp = 1678886400,
    sensor = "DHT22",
    suhu = 27.5,
    kelembaban = 65.2
  }

  -- Serialisasi table Lua menjadi string JSON
  local json_string = sjson.encode(data_sensor)

  print(json_string)
  -- Output: {"timestamp":1678886400,"sensor":"DHT22","suhu":27.5,"kelembaban":65.2}

  -- Kirim 'json_string' ini melalui MQTT atau HTTP POST
  -- mqtt_client:publish("sensor/data", json_string, 0, 0)
  ```

- **Referensi**:

  - [LuaRocks - rxi/json (library JSON populer)](https://luarocks.org/modules/rxi/json)
  - [MessagePack for Lua](https://luarocks.org/modules/fperrad/lua-messagepack)

### **6.4. Keamanan dan Enkripsi: SSL/TLS**

- **Deskripsi Konkrit**: Mengirim data melalui jaringan publik tanpa enkripsi adalah ide yang sangat buruk. SSL (Secure Sockets Layer) dan penggantinya, TLS (Transport Layer Security), adalah protokol kriptografi yang menyediakan komunikasi aman melalui jaringan. Ini adalah 'S' dalam HTTPS.

- **Konsep**: TLS menyediakan tiga hal:

  1.  **Enkripsi**: Mencegah pihak ketiga mengintip data Anda.
  2.  **Otentikasi**: Memastikan Anda terhubung ke server yang benar (bukan penipu), dan server memastikan perangkat Anda adalah perangkat yang sah. Ini dilakukan melalui _sertifikat digital_.
  3.  **Integritas**: Memastikan data tidak diubah selama transmisi.

- **Implementasi**: Di NodeMCU/Lua, ini biasanya sesederhana menggunakan API yang mendukung SSL/TLS. Contoh: `mqtt.Client` alih-alih `mqtt.Client`, dan menghubungkan ke port aman (misal, 8883 untuk MQTT aman) serta menyediakan sertifikat yang diperlukan.

- **Referensi**:

  - [LuaCrypto - Library Kriptografi untuk Lua](https://luarocks.org/modules/luarocks/luacrypto)
  - [Praktik Terbaik Keamanan IoT](https://www.iotforall.com/iot-security-best-practices)

### **6.5. OTA Updates: Pembaruan Jarak Jauh**

- **Deskripsi Konkrit**: OTA (Over-The-Air) adalah mekanisme untuk memperbarui perangkat lunak (_firmware_) pada perangkat _embedded_ dari jarak jauh, tanpa memerlukan koneksi fisik. Ini adalah fitur **wajib** untuk produk IoT yang sudah disebar di lapangan.

- **Konsep Proses OTA**:

  1.  **Pemicu**: Perangkat dapat secara berkala memeriksa server untuk pembaruan, atau pembaruan dapat dipicu oleh perintah MQTT.
  2.  **Unduh**: Perangkat mengunduh file _firmware_ baru dari server (biasanya melalui HTTP). _Firmware_ baru ini disimpan di partisi memori yang terpisah.
  3.  **Verifikasi**: Perangkat memverifikasi integritas dan keaslian _firmware_ yang diunduh (misalnya dengan memeriksa _hash_ atau tanda tangan digital).
  4.  **Reboot**: Jika verifikasi berhasil, perangkat akan reboot dan menginstruksikan _bootloader_ untuk memuat dari partisi _firmware_ yang baru. Jika gagal, ia akan tetap menggunakan _firmware_ lama.

- **Referensi**:

  - [Dokumentasi NodeMCU OTA Updates](https://nodemcu.readthedocs.io/en/latest/modules/ota/)

---

### **Langkah Selanjutnya**

Dengan selesainya Fase 5 dan 6, Anda telah menempuh perjalanan dari mengedipkan satu LED hingga menghubungkan perangkat Anda dengan aman ke cloud. Anda sekarang memiliki semua blok bangunan fundamental untuk menciptakan proyek IoT yang canggih.

Fase-fase berikutnya dalam kurikulum Anda (System Integration, Testing, Deployment, Advanced Topics) berfokus pada pematangan proyek Anda dari prototipe menjadi produk yang andal, dapat dipelihara, dan siap produksi.

Kita dapat melanjutkan ke Fase 7 dan 8, yang mencakup penggunaan _framework_ seperti OpenWrt, integrasi dengan RTOS, dan yang terpenting, cara menguji dan men-debug sistem Anda secara efektif.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../README.md
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
