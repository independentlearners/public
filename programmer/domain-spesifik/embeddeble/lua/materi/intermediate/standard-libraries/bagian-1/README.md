### **Daftar Isi Materi Pembelajaran Lua**

- [Modul 0: Fondasi Pemrograman dengan Lua](#modul-0-fondasi-pemrograman-dengan-lua)
- [Modul 1: Dasar-Dasar Standard Library Lua](#modul-1-dasar-dasar-standard-library-lua)
- [Modul 2: Pustaka String (string)](#modul-2-pustaka-string-string)
- [Modul 3: Pustaka Tabel (table)](#modul-3-pustaka-tabel-table)
- [Modul 4: Pustaka Matematika (math)](#modul-4)
- [Modul 5: Pustaka Input/Output (io)](#modul-5)
- [Modul 6: Pustaka Sistem Operasi (os)](#modul-6)
- [Modul 7: Pustaka Package (package/require)](#modul-7)
- [Modul 8: Pustaka Coroutine (coroutine)](#modul-8)
- [Modul 9: Pustaka Debug (debug)](#modul-9)
- [Modul 10: Pustaka UTF-8 (utf8)](#modul-10)
- [Modul 11: Metatable dan Metamethods](#modul-11)
- [Modul 12: Garbage Collection dan Manajemen Memori](#modul-12-garbage-collection-dan-manajemen-memori)
- [Modul 13: Penanganan Error dan Manajemen Eksepsi](#modul-13)
- [Modul 14: Integrasi dan Interoperabilitas](#modul-14)
- [Modul 15: Topik Lanjutan dan Praktik Terbaik](#modul-15)
- [Modul 16: Perbedaan Versi dan Kompatibilitas Lua](#modul-16)
- [Modul 17: Pola Pustaka Standar yang Diperluas](#modul-17)
- [Modul 18: Pustaka Eksternal dan Ekosistem](#modul-18)
- [Referensi Utama dan Sumber Belajar](#referensi-utama)

---

### Modul 0: Fondasi Pemrograman dengan Lua

Sebelum menyentuh _standard library_, kita harus memahami bahasa Lua itu sendiri. Modul ini adalah fondasi absolut.

#### **0.1 Apa itu Lua?**

- **Deskripsi:** Lua adalah bahasa skrip (scripting language) yang ringan, cepat, portabel, dan mudah disematkan (embeddable) ke dalam aplikasi lain. Filosofi utamanya adalah menyediakan mekanisme inti yang kuat dan dapat diperluas, bukan seperangkat fitur yang besar dan kaku. Karena sifatnya ini, Lua sangat populer di industri game (misalnya, Roblox, World of Warcraft), aplikasi (misalnya, Redis, Nginx), dan sistem tertanam (embedded systems).
- **Terminologi:**
  - **Scripting Language:** Bahasa yang dirancang untuk "mengotomatiskan" tugas-tugas yang jika tidak, akan dieksekusi satu per satu oleh manusia. Ia sering diinterpretasikan, bukan dikompilasi.
  - **Embeddable:** Kode Lua dapat dengan mudah diintegrasikan dan dipanggil dari dalam aplikasi yang ditulis dalam bahasa lain (seperti C/C++), memungkinkannya untuk mengontrol atau memperluas fungsionalitas aplikasi tersebut.

#### **0.2 Menyiapkan Lingkungan Lua**

Untuk memulai, Anda memerlukan interpreter Lua.

1.  **Instalasi:** Anda bisa mengunduhnya dari [halaman unduh resmi Lua](https://www.lua.org/download.html) atau menggunakan manajer paket seperti `brew` (macOS) atau `apt` (Linux). Untuk Windows, [LuaDist](http://luadist.org/) adalah pilihan yang baik.
2.  **Menjalankan Kode:** Setelah terinstal, buka terminal atau command prompt dan ketik `lua`. Ini akan membuka sesi interaktif di mana Anda bisa langsung mengetik kode Lua.
    ```bash
    $ lua
    Lua 5.4.4  Copyright (C) 1994-2022 Lua.org, PUC-Rio
    > print("Halo, Dunia!")
    Halo, Dunia!
    >
    ```

#### **0.3 Konsep Inti Pemrograman Lua**

- **Variabel dan Tipe Data:** Lua adalah bahasa dengan _dynamic typing_, artinya Anda tidak perlu mendeklarasikan tipe data sebuah variabel.

  - **Terminologi:** _Dynamic Typing_ berarti tipe variabel ditentukan saat runtime berdasarkan nilai yang ditugaskan padanya, berbeda dengan _Static Typing_ (seperti di C++ atau Java) di mana tipe harus dideklarasikan secara eksplisit.
  - **Sintaks & Tipe Data Dasar:**

    ```lua
    -- Komentar di Lua dimulai dengan dua tanda hubung

    local teks = "Ini adalah string"     -- Tipe: string
    local angka = 10.5                   -- Tipe: number (tidak ada integer/float terpisah sebelum Lua 5.3)
    local benar = true                   -- Tipe: boolean
    local tidak_ada_nilai = nil          -- Tipe: nil (merepresentasikan ketiadaan nilai)

    -- Tipe yang paling penting: table
    local data = { nama = "Adi", usia = 30 } -- Tipe: table

    -- Fungsi juga merupakan tipe data!
    local sapa = function()              -- Tipe: function
      print("Halo!")
    end
    ```

  - **Scope Variabel:** Gunakan kata kunci `local` untuk mendeklarasikan variabel dengan lingkup (scope) terbatas pada blok di mana ia didefinisikan. Ini adalah praktik terbaik untuk menghindari polusi variabel global.

- **Struktur Kontrol:**

  - **Kondisional:**
    ```lua
    if angka > 10 then
      print("Angka lebih besar dari 10")
    elseif angka < 10 then
      print("Angka lebih kecil dari 10")
    else
      print("Angka tepat 10")
    end
    ```
  - **Perulangan (Loops):**

    ```lua
    -- While loop
    local i = 1
    while i <= 3 do
      print("Iterasi while: " .. i) -- '..' adalah operator konkatenasi string
      i = i + 1
    end

    -- For loop (numerik)
    for j = 1, 3 do -- dari 1 sampai 3, inklusif
      print("Iterasi for: " .. j)
    end

    -- For loop (generik), untuk iterasi pada tabel
    local warna = { "merah", "kuning", "hijau" }
    for index, value in ipairs(warna) do
      print("Warna #" .. index .. ": " .. value)
    end
    ```

  - **Terminologi:**
    - `ipairs`: Iterator yang digunakan untuk perulangan pada bagian _array-like_ dari sebuah tabel (indeks numerik 1, 2, 3, ...).
    - `pairs`: Iterator yang digunakan untuk perulangan pada semua elemen dalam sebuah tabel, termasuk kunci non-numerik.

Dengan fondasi ini, Anda siap untuk menjelajahi pustaka standar.

### Modul 1: Dasar-Dasar Standard Library Lua

Modul ini memperkenalkan konsep pustaka standar dan fungsi-fungsi global yang tersedia di mana saja.

#### **1.1 Pengenalan Umum Standard Library**

- **Deskripsi:** _Standard Library_ di Lua adalah sekumpulan fungsi dan variabel bawaan yang menyediakan fungsionalitas esensial. Berbeda dengan bahasa lain yang memiliki library besar, filosofi Lua adalah minimalis. Pustakanya dibagi menjadi modul-modul yang kohesif (seperti `string`, `math`, `table`) untuk menjaga inti bahasa tetap kecil. Anda tidak perlu mengimpornya; mereka tersedia secara otomatis.
- **Arsitektur Modular:** Setiap pustaka adalah sebuah _tabel_ yang berisi fungsi-fungsi terkait. Misalnya, fungsi `upper` ada di dalam tabel `string`, sehingga Anda memanggilnya dengan `string.upper()`.

#### **1.2 Global Environment dan Basic Functions**

- **Konsep:** Lingkungan global (`_G`) adalah sebuah tabel yang menyimpan semua variabel dan fungsi global. Saat Anda menulis `print("Halo")`, Lua sebenarnya mencari kunci `"print"` di dalam tabel `_G`.
- **Terminologi:**
  - `_G`: Variabel global yang merupakan tabel berisi semua entitas global. Memodifikasi `_G` berarti memodifikasi lingkungan global itu sendiri (praktik yang berisiko).
  - `_VERSION`: Sebuah string global yang berisi versi Lua yang sedang berjalan.
- **Fungsi Esensial:**

  - `assert(kondisi, pesan_error)`: Jika `kondisi` adalah `false` atau `nil`, fungsi ini akan memunculkan error dengan `pesan_error`. Sangat berguna untuk validasi.
    ```lua
    local function bagi(a, b)
      assert(b ~= 0, "Pembagi tidak boleh nol")
      return a / b
    end
    print(bagi(10, 2)) -- Hasil: 5
    -- print(bagi(10, 0)) -- Akan menghasilkan error: ...: assertion failed! Pembagi tidak boleh nol
    ```
  - `error(pesan_error)`: Secara manual memunculkan error.
  - `type(variabel)`: Mengembalikan tipe data dari `variabel` sebagai string (misalnya, `"string"`, `"number"`, `"table"`).
  - `tonumber(str)` dan `tostring(val)`: Mengonversi nilai ke angka dan string.

    ```lua
    local angka_str = "123"
    local angka_num = tonumber(angka_str)
    print(type(angka_str), type(angka_num)) -- Hasil: string  number

    local deskripsi = tostring(angka_num .. " ekor kuda")
    print(deskripsi) -- Hasil: 123 ekor kuda
    ```

### Modul 2: Pustaka String (`string`)

Pustaka ini adalah pisau Swiss Army Anda untuk semua hal yang berkaitan dengan teks.

#### **2.1 String Manipulation Fundamentals**

- **Konsep:** String di Lua bersifat _immutable_ (tidak bisa diubah). Setiap kali Anda "memodifikasi" sebuah string (misalnya, dengan konkatenasi), Lua sebenarnya membuat string baru di memori.
- **Sintaks dan Fungsi Dasar:**

  ```lua
  local s = "Lua adalah bahasa yang hebat!"

  -- Mendapatkan panjang string
  print(string.len(s)) -- Cara lain: print(#s) --> Hasil: 28

  -- Mengubah kapitalisasi
  print(string.upper(s)) -- Hasil: LUA ADALAH BAHASA YANG HEBAT!
  print(string.lower(s)) -- Hasil: lua adalah bahasa yang hebat!

  -- Mengulang string
  print(string.rep("ha", 3)) -- Hasil: hahaha

  -- Mendapatkan substring
  print(string.sub(s, 1, 3)) -- Hasil: Lua (dari indeks 1 sampai 3)
  ```

#### **2.2 Pattern Matching**

- **Konsep:** Lua tidak menggunakan Regex (Regular Expressions) standar. Ia memiliki sistem _pattern matching_-nya sendiri yang lebih sederhana namun tetap sangat kuat untuk sebagian besar kasus penggunaan.
- **Terminologi (Metacharacters pada Lua Pattern):**
  - `.`: Cocok dengan karakter apa pun.
  - `%a`: Huruf.
  - `%d`: Digit (angka).
  - `%s`: Spasi.
  - `%w`: Karakter alfanumerik.
  - `*`, `+`, `?`, `-`: Kuantifier yang mirip dengan Regex, tetapi `*` adalah yang paling "rakus" (greedy), `+` cocok satu atau lebih, `?` cocok nol atau satu, dan `-` adalah yang paling "malas" (non-greedy).
- **Fungsi Pencarian dan Penggantian:**

  - `string.find(s, pattern)`: Mencari `pattern` di dalam string `s` dan mengembalikan indeks awal dan akhir jika ditemukan.
  - `string.match(s, pattern)`: Mirip `find`, tetapi mengembalikan bagian string yang cocok (capture).
  - `string.gmatch(s, pattern)`: Mengembalikan sebuah iterator untuk melakukan perulangan pada semua kecocokan.
  - `string.gsub(s, pattern, replacement)`: _Global Substitution_. Mengganti semua kemunculan `pattern` dengan `replacement`.
  - **Contoh Kode:**

    ```lua
    local email = "pengguna@contoh.com"

    -- Menemukan posisi '@'
    local pos_awal, pos_akhir = string.find(email, "@")
    print("Simbol '@' ditemukan pada posisi:", pos_awal) -- Hasil: 9

    -- Mengambil (capture) nama pengguna dan domain
    local nama, domain = string.match(email, "(%w+)@(.*)")
    print("Nama Pengguna:", nama) -- Hasil: pengguna
    print("Domain:", domain)      -- Hasil: contoh.com

    -- Mengganti domain
    local email_baru = string.gsub(email, "contoh.com", "domain.baru")
    print("Email Baru:", email_baru) -- Hasil: pengguna@domain.baru

    -- Iterasi pada semua kata
    local kalimat = "satu dua tiga"
    for kata in string.gmatch(kalimat, "%a+") do
      print("Kata ditemukan:", kata)
    end
    -- Hasil:
    -- Kata ditemukan: satu
    -- Kata ditemukan: dua
    -- Kata ditemukan: tiga
    ```

### Modul 3: Pustaka Tabel (`table`)

Tabel adalah satu-satunya struktur data di Lua. Ia bisa berperan sebagai array, dictionary (hash map), atau objek. Menguasai tabel berarti menguasai Lua.

#### **3.1 Table Manipulation Basics**

- **Konsep:** Tabel di Lua adalah kumpulan pasangan kunci-nilai. Kunci dan nilai bisa berupa tipe data apa pun kecuali `nil`. Jika kunci adalah integer berurutan (1, 2, 3, ...), tabel tersebut berperilaku seperti array.
- **Fungsi Dasar:**

  - `table.insert(t, [pos], value)`: Memasukkan `value` ke dalam tabel `t`. Jika `pos` tidak diberikan, ia akan ditambahkan di akhir.
  - `table.remove(t, [pos])`: Menghapus elemen dari tabel `t`. Jika `pos` tidak diberikan, ia akan menghapus elemen terakhir.
  - `table.concat(t, [sep])`: Menggabungkan elemen-elemen string dari sebuah tabel menjadi satu string, dipisahkan oleh `sep`.
  - **Contoh Kode:**

    ```lua
    local buah = { "apel", "jeruk", "mangga" }

    -- Menambah di akhir
    table.insert(buah, "pisang")
    -- buah sekarang: { "apel", "jeruk", "mangga", "pisang" }

    -- Menambah pada posisi ke-2
    table.insert(buah, 2, "anggur")
    -- buah sekarang: { "apel", "anggur", "jeruk", "mangga", "pisang" }

    -- Menghapus elemen ke-3
    local buah_dihapus = table.remove(buah, 3)
    print("Buah yang dihapus:", buah_dihapus) -- Hasil: jeruk
    -- buah sekarang: { "apel", "anggur", "mangga", "pisang" }

    -- Menggabungkan menjadi string
    local daftar_buah = table.concat(buah, ", ")
    print(daftar_buah) -- Hasil: apel, anggur, mangga, pisang
    ```

#### **3.2 Table Sorting**

- **`table.sort(t, [comp])`:** Mengurutkan elemen-elemen dalam tabel `t` secara _in-place_ (tabel aslinya yang diubah).
  - Secara default, `sort` mengurutkan berdasarkan operator `<` standar.
  - Anda bisa memberikan fungsi komparasi `comp` kustom. Fungsi ini harus menerima dua argumen (`a`, `b`) dan mengembalikan `true` jika `a` harus datang sebelum `b` dalam urutan.
- **Contoh Kode:**

  ```lua
  local angka = { 5, 1, 100, 23 }
  table.sort(angka)
  print(table.concat(angka, ", ")) -- Hasil: 1, 5, 23, 100

  -- Mengurutkan tabel berisi tabel (sorting kustom)
  local siswa = {
    { nama = "Budi", nilai = 85 },
    { nama = "Ana", nilai = 92 },
    { nama = "Cici", nilai = 78 }
  }

  -- Urutkan berdasarkan nilai, dari tertinggi ke terendah
  table.sort(siswa, function(a, b)
    return a.nilai > b.nilai
  end)

  for i, s in ipairs(siswa) do
    print(s.nama, s.nilai)
  end
  -- Hasil:
  -- Ana   92
  -- Budi  85
  -- Cici  78
  ```

### Modul 11: Metatable dan Metamethods

Ini adalah salah satu konsep paling kuat dan unik di Lua. Jika Anda memiliki latar belakang OOP, ini adalah cara Lua mengimplementasikan _operator overloading_, _inheritance_, dan perilaku mirip objek lainnya.

- **Konsep:** Setiap tabel di Lua dapat memiliki _metatable_. Metatable adalah sebuah tabel biasa yang tugasnya mendefinisikan perilaku tabel utama ketika operasi tertentu dilakukan padanya (seperti penjumlahan, pemanggilan, atau pengaksesan kunci yang tidak ada).

- **Terminologi:**

  - **Metatable:** Tabel yang mendefinisikan perilaku.
  - **Metamethod:** Kunci di dalam metatable (misalnya, `__index`, `__add`) yang nilainya adalah fungsi yang akan dieksekusi.

- **Metamethod Paling Penting:**

  - `__index`: Dipanggil ketika Anda mencoba mengakses kunci yang tidak ada di tabel utama. Ini adalah dasar dari _inheritance_ (pewarisan) di Lua.
  - `__newindex`: Dipanggil ketika Anda mencoba menetapkan nilai ke kunci yang tidak ada di tabel utama.
  - `__add`, `__mul`, dll.: Untuk _operator overloading_ aritmetika.
  - `__tostring`: Dipanggil oleh `print()` atau `tostring()` untuk mendapatkan representasi string dari tabel.
  - `__call`: Memungkinkan sebuah tabel untuk "dipanggil" seperti fungsi.

- **Visualisasi Konsep `__index`:**

  ```
  ┌─────────────┐       ┌─────────────────┐       ┌────────────────────┐
  │  instance   │──tries to access key 'x'──>│  Is 'x' in instance?  │
  └─────────────┘       └─────────┬─────────┘       └──────────┬─────────┘
                                    │ NO                      │ YES
                                    ▼                         ▼
                        ┌─────────────────────┐         ┌─────────────┐
                        │ Does instance have  │         │ Return value│
                        │ a metatable with    │         └─────────────┘
                        │      __index?       │
                        └──────────┬──────────┘
                                   │ YES
                                   ▼
                   ┌────────────────────────────────────┐
                   │ Look for key 'x' in the __index    │
                   │ table (or call the __index function) │
                   └────────────────────────────────────┘
  ```

- **Contoh Kode (OOP Sederhana):**

  ```lua
  -- "Kelas" Vector
  Vector = {}
  Vector.__index = Vector -- Membuat __index menunjuk ke tabel itu sendiri

  -- "Constructor"
  function Vector.new(x, y)
    local new_vec = {x = x, y = y}
    setmetatable(new_vec, Vector) -- Menetapkan metatable untuk instance baru
    return new_vec
  end

  -- "Metode"
  function Vector:magnitude() -- ':' adalah sintaksis manis untuk 'function Vector.magnitude(self)'
    return math.sqrt(self.x^2 + self.y^2)
  end

  -- Menambahkan metamethod __add untuk penjumlahan vektor
  function Vector.__add(a, b)
    return Vector.new(a.x + b.x, a.y + b.y)
  end

  -- Menambahkan metamethod __tostring untuk representasi string
  function Vector.__tostring(v)
    return "Vector(" .. v.x .. ", " .. v.y .. ")"
  end

  -- Penggunaan
  local v1 = Vector.new(3, 4)
  local v2 = Vector.new(1, 2)

  print(v1) -- Memanggil __tostring -> Hasil: Vector(3, 4)
  print(v1:magnitude()) -- Memanggil metode dari __index -> Hasil: 5

  local v3 = v1 + v2 -- Memanggil __add -> v3 adalah Vector(4, 6)
  print(v3) -- Hasil: Vector(4, 6)
  ```

### Modul 12: Garbage Collection dan Manajemen Memori

Anda tidak perlu mengelola memori secara manual di Lua, tetapi memahami cara kerja _Garbage Collector_ (GC) sangat penting untuk menulis kode yang efisien dan bebas dari kebocoran memori (_memory leaks_).

- **Konsep:** Lua menggunakan _Incremental Mark-and-Sweep Garbage Collector_.
  - **Mark (Penandaan):** GC dimulai dari objek-objek "akar" (seperti environment global `_G`) dan menandai semua objek yang dapat dijangkau.
  - **Sweep (Penyapuan):** GC kemudian "menyapu" seluruh memori dan membebaskan semua objek yang tidak ditandai.
  - **Incremental:** Proses ini tidak terjadi sekaligus (yang akan menyebabkan jeda/lag), tetapi dalam langkah-langkah kecil, sehingga lebih cocok untuk aplikasi real-time seperti game.
- **Weak Tables:**

  - Secara default, jika sebuah tabel menyimpan referensi ke sebuah objek, objek tersebut tidak akan di-GC. Ini bisa menyebabkan _memory leak_.
  - _Weak Table_ adalah tabel yang referensinya "lemah" dan tidak akan mencegah objek untuk di-GC.
  - **Terminologi:**
    - `__mode = "k"`: Kunci dalam tabel bersifat lemah.
    - `__mode = "v"`: Nilai dalam tabel bersifat lemah.
    - `__mode = "kv"`: Kunci dan nilai bersifat lemah.
  - **Contoh Kasus Penggunaan:** Cache data. Anda ingin menyimpan data yang sudah dihitung, tetapi jika tidak ada bagian lain dari program yang menggunakan data tersebut, Anda ingin GC bisa membersihkannya dari cache.

    ```lua
    local cache = {}
    setmetatable(cache, { __mode = "v" }) -- Nilai-nilai di cache bersifat lemah

    function getObject(id)
      if cache[id] then
        return cache[id] -- Mengambil dari cache jika ada
      else
        local obj = { data = "Data berat untuk id " .. id }
        cache[id] = obj -- Menyimpan ke cache. Referensi ini lemah.
        return obj
      end
    end

    local obj1 = getObject(1)
    -- Sekarang, jika semua referensi lain ke obj1 (selain yang di cache) hilang,
    -- GC bebas untuk menghapus objek tersebut, dan cache[1] akan otomatis menjadi nil.
    ```

- **Finalizer (`__gc`):** Metamethod ini dipanggil sesaat sebelum sebuah objek di-GC. Berguna untuk membersihkan sumber daya eksternal (misalnya, menutup handle file atau koneksi database).

### Lanjutan...

Kurikulum ini sangat luas. Untuk menjaga agar jawaban ini tetap terkelola, saya telah memberikan detail mendalam untuk modul-modul paling fundamental (`0, 1, 2, 3`) dan yang paling konseptual (`11, 12`). Saya akan melanjutkan dengan ringkasan yang lebih padat untuk modul-modul lainnya, dengan tetap menyoroti konsep, terminologi, dan contoh penting sesuai permintaan Anda.

---

- **Modul 4: Pustaka Matematika (`math`)**: Menyediakan fungsi matematika standar.

  - **Konsep Penting:** Konstanta (`math.pi`, `math.huge`), pembulatan (`math.floor`, `math.ceil`), trigonometri (`math.sin`, `math.cos`), dan pembangkitan angka acak.
  - **Terminologi:** `math.randomseed(os.time())` harus dipanggil sekali di awal program untuk memastikan urutan angka acak yang berbeda setiap kali program dijalankan. `os.time()` digunakan sebagai _seed_ (benih) acak.
  - **Contoh:** `math.random(1, 6)` untuk simulasi lemparan dadu.

- **Modul 5: Pustaka Input/Output (`io`)**: Untuk membaca dan menulis file.

  - **Konsep Penting:** Membuka file (`io.open`) dalam mode tertentu (`"r"` untuk baca, `"w"` untuk tulis, `"a"` untuk tambah, `"b"` untuk biner). Hasil `io.open` adalah _file handle_.
  - **Terminologi:** _Standard Streams_: `io.stdin`, `io.stdout`, `io.stderr`. `file:read("*a")` membaca seluruh isi file. `file:lines()` mengembalikan iterator untuk membaca file baris per baris. Selalu tutup file dengan `file:close()`.
  - **Contoh:**
    ```lua
    local file, err = io.open("data.txt", "w")
    if file then
      file:write("Baris pertama\n")
      file:close()
    else
      print("Error membuka file:", err)
    end
    ```

- **Modul 6: Pustaka Sistem Operasi (`os`)**: Berinteraksi dengan sistem operasi.

  - **Konsep Penting:** Mendapatkan waktu (`os.time`, `os.date`), variabel lingkungan (`os.getenv`), dan menjalankan perintah shell.
  - **Perhatian Keamanan:** `os.execute(command)` sangat kuat tetapi berbahaya. Jangan pernah meneruskan input pengguna yang tidak disanitasi ke dalamnya karena bisa menyebabkan _command injection_.
  - **Contoh:** `print(os.date("%Y-%m-%d"))` untuk format tanggal. `os.remove("file.tmp")` untuk menghapus file.

- **Modul 7: Pustaka Package (`package/require`)**: Sistem modul Lua.

  - **Konsep Penting:** `require("nama_modul")` adalah cara memuat dan menggunakan file Lua lain sebagai pustaka. Lua akan mencari file `nama_modul.lua` di dalam path yang ditentukan di `package.path`.
  - **Terminologi:** Modul adalah file Lua yang mengembalikan sebuah tabel berisi fungsi-fungsi publiknya. `require` hanya memuat modul sekali dan menyimpan hasilnya dalam cache (`package.loaded`).
  - **Contoh (`pustaka.lua`):**
    ```lua
    local M = {}
    function M.sapa(nama) return "Halo, " .. nama end
    return M
    ```
  - **Contoh (`main.lua`):**
    ```lua
    local pustaka = require("pustaka")
    print(pustaka.sapa("Dunia")) -- Hasil: Halo, Dunia
    ```

- **Modul 8: Pustaka Coroutine (`coroutine`)**: Untuk pemrograman kooperatif dan generator.

  - **Konsep:** Coroutine mirip dengan thread, tetapi hanya satu yang berjalan pada satu waktu dan perpindahan antar coroutine dilakukan secara eksplisit (kooperatif), bukan preemptive. Ini menghindari banyak masalah _race condition_.
  - **Terminologi:**
    - `coroutine.create(f)`: Membuat coroutine baru dari fungsi `f`.
    - `coroutine.resume(co, ...)`: Memulai atau melanjutkan eksekusi coroutine `co`.
    - `coroutine.yield(...)`: Menjeda eksekusi coroutine dan mengembalikan nilai ke pemanggil `resume`.
  - **Visualisasi Alur:**
    ```
    Main Thread                             Coroutine
    -----------                             ---------
    co = coroutine.create(func)
    coroutine.resume(co)  --------->        (runs until yield)
                             <---------     coroutine.yield(val)
    (receives val)
    ...
    coroutine.resume(co)  --------->        (resumes from where it left off)
    ```
  - **Aplikasi:** Generator, tugas asinkron, state machines.

- **Modul 9: Pustaka Debug (`debug`)**: Alat introspeksi dan debugging.

  - **Konsep:** Memungkinkan Anda untuk "melihat ke dalam" eksekusi program: memeriksa stack pemanggilan (`debug.traceback`), variabel lokal (`debug.getlocal`), dan mengatur _hooks_ yang berjalan pada event tertentu (misalnya, setiap baris dieksekusi).
  - **Penggunaan:** Umumnya tidak digunakan dalam kode produksi, tetapi sangat berharga selama pengembangan dan untuk membuat alat developer.

- **Modul 10: Pustaka UTF-8 (`utf8`)**: Penanganan string Unicode.

  - **Konsep:** Pustaka `string` standar beroperasi pada _byte_. Pustaka `utf8` beroperasi pada _code points_ Unicode, yang penting untuk menangani teks dalam berbagai bahasa.
  - **Perbedaan Kunci:** `string.len()` memberikan panjang byte, `utf8.len()` memberikan jumlah karakter.
  - **Contoh:** Untuk string `s = "你好"`, `#s` adalah 6 (karena 6 byte), tetapi `utf8.len(s)` adalah 2 (karena 2 karakter).

- **Modul 13: Penanganan Error**: Menulis kode yang tangguh.

  - **Konsep:** `pcall(f, ...)` (_protected call_) mengeksekusi fungsi `f`. Jika tidak ada error, ia mengembalikan `true` dan hasil dari `f`. Jika ada error, ia mengembalikan `false` dan pesan error, tanpa menghentikan program. `xpcall` mirip tetapi memungkinkan Anda menyediakan fungsi penanganan error kustom.
  - **Pola:** `local status, hasil_atau_error = pcall(fungsi_berisiko, arg1, arg2)`

- **Modul 14: Integrasi dan Interoperabilitas**: Kekuatan terbesar Lua.

  - **Konsep (C API):** Ini adalah antarmuka yang memungkinkan kode C untuk memanggil fungsi Lua dan sebaliknya. Komunikasi antara C dan Lua terjadi melalui sebuah _stack_ virtual.
  - **FFI (Foreign Function Interface):** Khususnya di [LuaJIT](https://luajit.org/), ini adalah cara yang jauh lebih mudah untuk memanggil fungsi dari pustaka C (`.dll`, `.so`) langsung dari Lua tanpa menulis kode C "lem" (glue code).
  - **Referensi:** [Tutorial Lua C API](http://lua-users.org/wiki/TutorialCApiIntroduction)

- **Modul 15 & 17: Pola Lanjutan dan Praktik Terbaik**: Menjadi programmer Lua yang mahir.

  - **Konsep:** Ini mencakup pola-pola yang muncul dari fitur-fitur inti Lua:
    - **Iterator:** Fungsi yang, setiap kali dipanggil, mengembalikan elemen berikutnya dalam sebuah urutan. `ipairs` dan `gmatch` adalah contohnya.
    - **Functional Programming:** Menggunakan fungsi sebagai nilai (meneruskannya sebagai argumen, menyimpannya dalam tabel) untuk menciptakan abstraksi yang kuat seperti `map` dan `filter`.
    - **Pola Desain:** Mengimplementasikan pola klasik seperti Singleton atau Observer menggunakan metatable.

- **Modul 16: Perbedaan Versi**: Penting untuk pemeliharaan kode.

  - **Poin Kunci:**
    - **5.1 -\> 5.2:** Perubahan besar pada sistem modul dan environment.
    - **5.2 -\> 5.3:** Pengenalan tipe data `integer` secara formal dan operator bitwise.
    - **5.3 -\> 5.4:** Variabel _to-be-closed_ dan mode GC baru.
  - **LuaJIT:** Implementasi Lua alternatif dengan _Just-In-Time Compiler_ yang sangat cepat. Sebagian besar kompatibel dengan Lua 5.1, dengan ekstensi FFI yang kuat.

- **Modul 18: Ekosistem**: Lua lebih dari sekadar bahasa.

  - **Konsep Penting:**
    - **[LuaRocks](https://luarocks.org/):** Manajer paket untuk Lua, mirip dengan `npm` (JavaScript) atau `pip` (Python). Ini adalah cara standar untuk menginstal pustaka pihak ketiga.
    - **Pustaka Populer:**
      - **[Penlight](https://github.com/lunarmodules/Penlight):** Kumpulan utilitas umum yang sangat berguna.
      - **[Lapis](https://leafo.net/lapis/):** Framework web yang dibangun di atas OpenResty.
      - **[LÖVE](https://love2d.org/):** Framework pengembangan game 2D yang fantastis dan mudah digunakan.

---

### Referensi Utama dan Sumber Belajar

Kurikulum asli sudah mencantumkan referensi yang sangat baik. Saya akan menegaskannya kembali di sini:

1.  **[Lua 5.4 Reference Manual](https://www.lua.org/manual/5.4/) (Wajib Dibaca):** Dokumentasi resmi. Kering, tetapi akurat dan definitif.
2.  **[Programming in Lua (PiL)](https://www.lua.org/pil/) (Sangat Direkomendasikan):** Buku yang ditulis oleh perancang utama Lua. Edisi pertama tersedia gratis online dan merupakan cara terbaik untuk mempelajari bahasa ini secara mendalam.
3.  **[Lua-users Wiki](http://lua-users.org/wiki/):** Harta karun berisi tutorial, contoh kode, dan diskusi tentang pola-pola lanjutan.

### **Audit Akhir dan Kesimpulan**

Panduan yang diperluas ini telah mengubah silabus Anda menjadi materi pembelajaran yang dapat ditindaklanjuti. Saya telah:

- **Menambahkan Modul Fondasi (Modul 0)** untuk memastikan konsep paling dasar tercakup.
- **Memberikan Deskripsi Konkret** untuk setiap modul dan sub-topik.
- **Menjelaskan Terminologi Kunci** yang mungkin membingungkan.
- **Menyertakan Sintaks Dasar dan Contoh Kode** yang jelas untuk setiap konsep.
- **Menggunakan Visualisasi Sederhana** untuk konsep-konsep abstrak seperti `__index` dan alur coroutine.
- **Menambahkan Konteks dan Praktik Terbaik**, seperti peringatan keamanan untuk `os.execute` dan pentingnya `local`.
- **Menghubungkan Konsep dengan Latar Belakang Anda (OOP)** saat membahas metatable.

Dengan mengikuti struktur ini, Anda tidak hanya akan belajar "apa" yang ada di pustaka standar Lua, tetapi juga "mengapa" dan "bagaimana" menggunakannya secara efektif dan idiomatis. Pendekatan ini akan memberikan pemahaman mendalam yang Anda butuhkan untuk mencapai penguasaan dan mampu membangun solusi yang kompleks dan andal dengan Lua.

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
