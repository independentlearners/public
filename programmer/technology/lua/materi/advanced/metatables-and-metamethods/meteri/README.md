### Daftar Isi

- [**Pengantar: Analogi untuk Memahami Metatables**](#pengantar-analogi-untuk-memahami-metatables)
- [**FASE 1: DASAR-DASAR KONSEPTUAL**](#fase-1-dasar-dasar-konseptual)
  - [1.1 Pemahaman Fundamental Metatables](#11-pemahaman-fundamental-metatables)
  - [1.2 Memahami Metamethods](#12-memahami-metamethods)
- [**FASE 2: FUNGSI DASAR DAN OPERASI**](#fase-2-fungsi-dasar-dan-operasi)
  - [2.1 Fungsi Inti: `setmetatable` dan `getmetatable`](#21-fungsi-inti-setmetatable-dan-getmetatable)
  - [2.2 Metamethods Dasar untuk Akses Data: `__index` dan `__newindex`](#22-metamethods-dasar-untuk-akses-data-__index-dan-__newindex)
- [**FASE 3: OPERATOR OVERLOADING**](#fase-3-operator-overloading)
  - [3.1 Metamethods Aritmatika](#31-metamethods-aritmatika)
  - [3.2 Metamethods Perbandingan](#32-metamethods-perbandingan)
  - [3.3 Metamethods Operasi Khusus](#33-metamethods-operasi-khusus)
- [**FASE 4: TEKNIK LANJUTAN**](#fase-4-teknik-lanjutan)
  - [4.1 Metamethod Pemanggilan Fungsi: `__call`](#41-metamethod-pemanggilan-fungsi-__call)
  - [4.2 Metamethods Garbage Collection: `__gc` dan `__mode`](#42-metamethods-garbage-collection-__gc-dan-__mode)
  - [4.3 Metamethods Iterator dan Perbedaan Versi](#43-metamethods-iterator-dan-perbedaan-versi)
- [**FASE 5: DESIGN PATTERNS DAN APLIKASI**](#fase-5-design-patterns-dan-aplikasi)
  - [5.1 Pola Pewarisan (Inheritance)](#51-pola-pewarisan-inheritance)
  - [5.2 Object-Oriented Programming (OOP) di Lua](#52-object-oriented-programming-oop-di-lua)
- [**FASE 6: KINERJA DAN OPTIMISASI**](#fase-6-kinerja-dan-optimisasi)
  - [6.1 Pertimbangan Kinerja](#61-pertimbangan-kinerja)
  - [6.2 Manajemen Memori](#62-manajemen-memori)
- [**Kesimpulan dan Langkah Selanjutnya**](#kesimpulan-dan-langkah-selanjutnya)

---

### Pengantar: Analogi untuk Memahami Metatables

Sebelum kita masuk ke detail teknis, mari kita gunakan sebuah analogi.

Bayangkan **Table** di Lua adalah sebuah objek biasa, misalnya sebuah boneka kayu. Boneka ini memiliki perilaku standar: ia hanya diam. Anda tidak bisa bertanya padanya "berapa tinggimu?" atau menyuruhnya "berjalan\!".

Sekarang, bayangkan Anda membuat sebuah **"buku aturan"** ajaib untuk boneka itu. Di dalam buku ini, Anda menulis:

- Jika seseorang mencoba menambahkan dua boneka, ukur tinggi keduanya, jumlahkan, dan buat boneka baru setinggi itu.
- Jika seseorang bertanya tentang sesuatu yang tidak dimiliki boneka (misalnya warna mata), lihatlah boneka prototipe di lemari dan berikan warna matanya.
- Jika seseorang mencoba "memanggil" boneka itu seolah-olah itu adalah fungsi, buat ia melambaikan tangan.

**Metatable** adalah "buku aturan" ajaib tersebut. **Metamethods** (`__add`, `__index`, `__call`) adalah aturan-aturan spesifik yang Anda tulis di dalamnya. Dengan melampirkan "buku aturan" ini ke boneka kayu Anda menggunakan fungsi `setmetatable()`, Anda telah mengubah perilakunya secara fundamental tanpa mengubah boneka itu sendiri.

Inilah inti kekuatan Metatables: **kemampuan untuk mendefinisikan ulang atau memperluas perilaku standar dari tables di Lua.** Bagi Anda yang datang dari Dart/OOP, ini adalah cara Lua untuk mengimplementasikan _operator overloading_, _inheritance_, _polymorphism_, dan konsep canggih lainnya, meskipun dengan cara yang lebih fleksibel dan berbasis prototipe.

## **[FASE 1: DASAR-DASAR KONSEPTUAL][0]**

Di fase ini, kita membangun fondasi mental tentang "apa" dan "mengapa" di balik metatables.

### 1.1 Pemahaman Fundamental Metatables

- **Apa itu Metatables dan mengapa penting?**

  - **Definisi**: Metatable adalah sebuah table Lua biasa yang berisi "aturan-aturan" (disebut metamethods) yang mendefinisikan bagaimana table lain (yang terhubung dengannya) harus berperilaku ketika operasi tertentu dilakukan padanya.
  - **Pentingnya**: Tanpa metatables, tables di Lua sangatlah terbatas. Anda tidak bisa menambahkan dua table, membandingkannya, atau mendeteksi ketika sebuah field yang tidak ada diakses. Metatables memberikan "kail" (hooks) untuk mencegat operasi-operasi ini dan menjalankan kode kustom, yang membuka pintu untuk pemrograman tingkat lanjut.

- **Perbedaan antara Tables biasa vs Tables dengan Metatables**

  - **Table Biasa**: Perilakunya baku dan tidak bisa diubah. Mencoba mengakses field yang tidak ada akan menghasilkan `nil`. Mencoba melakukan operasi aritmatika padanya akan menghasilkan error.
  - **Table dengan Metatable**: Perilakunya dapat disesuaikan. Mengakses field yang tidak ada dapat memicu pencarian di tempat lain. Operasi aritmatika dapat diberi makna baru.

- **Konsep "Hidden Tables" dan bagaimana mereka mempengaruhi behavior**

  - "Hidden Tables" adalah cara konseptual untuk memandang metatables. Mereka "tersembunyi" karena tidak secara langsung menjadi bagian dari data table itu sendiri. Anda harus menggunakan `getmetatable()` untuk "melihat" mereka. Pengaruhnya sangat besar: semua operasi yang "gagal" pada table utama (seperti mencari key yang tidak ada) akan didelegasikan ke metatable-nya untuk melihat apakah ada aturan (metamethod) yang bisa menanganinya.

### 1.2 Memahami Metamethods

- **Definisi dan fungsi Metamethods**

  - **Definisi**: Metamethod adalah key (string) khusus di dalam sebuah metatable (misalnya, `__index`, `__add`, `__tostring`) yang namanya diawali dengan dua garis bawah (`__`). Nilai yang terkait dengan key ini biasanya adalah sebuah fungsi.
  - **Fungsi**: Fungsi ini dipanggil secara otomatis oleh interpreter Lua ketika sebuah event atau operasi tertentu terjadi pada table yang terhubung dengan metatable tersebut.

- **Event-driven nature dari Metamethods**

  - Ini adalah konsep kunci. Anda tidak memanggil metamethod secara langsung. Sebaliknya, Anda mengatur mereka dan membiarkan Lua memanggilnya sebagai respons terhadap "event".
  - **Event**: Penjumlahan (`+`), pemanggilan fungsi (`()`), pengaksesan indeks (`[]`), dll.
  - **Contoh**: "Event" dari `t1 + t2` akan memicu pencarian "handler" `__add` di metatable `t1` atau `t2`.

- **Kapan dan mengapa Metamethods dipanggil**

  - Metamethods hanya dipanggil ketika operasi pada objek _tidak memiliki definisi standar_. Misalnya, Lua tahu cara menjumlahkan dua angka, jadi tidak ada metamethod yang dipanggil. Tapi Lua _tidak_ tahu cara menjumlahkan dua table. Di saat inilah Lua akan memeriksa keberadaan metamethod `__add` untuk mendapatkan instruksi.

---

## **FASE 2: FUNGSI DASAR DAN OPERASI**

Di sini kita mulai mempraktikkan konsep-konsep di atas dengan fungsi inti dan metamethods paling fundamental.

### 2.1 Fungsi Inti: `setmetatable` dan `getmetatable`

- **`setmetatable(table, metatable)`**: Fungsi ini melampirkan sebuah metatable ke sebuah table. Ini adalah "lem" yang menghubungkan objek Anda dengan "buku aturannya".

  - **Proteksi**: Sekali sebuah table memiliki metatable dengan field `__metatable`, `setmetatable` tidak akan bisa lagi mengubah metatable tersebut. Ini adalah mekanisme proteksi untuk mencegah modifikasi yang tidak diinginkan.

- **`getmetatable(table)`**: Fungsi ini digunakan untuk "inspeksi" atau _introspection_. Ia mengembalikan metatable dari sebuah table, atau `nil` jika tidak ada. Ini sangat berguna untuk debugging.

**Sintaks Dasar dan Contoh:**

```lua
-- 1. Table data kita (boneka kayu)
local myAccount = { balance = 100 }

-- 2. Metatable kita (buku aturan)
local mt = {}

-- 3. Menghubungkan myAccount dengan metatable 'mt'
setmetatable(myAccount, mt)

-- 4. Inspeksi: Memeriksa apakah hubungan itu ada
local retrieved_mt = getmetatable(myAccount)

print(retrieved_mt == mt) -- Output: true

-- Proteksi Metatable
mt.__metatable = "This metatable is locked!"
-- Sekarang coba ubah metatable dari myAccount (akan gagal)
local success, error_msg = pcall(setmetatable, myAccount, {})
print(success, error_msg) -- Output: false, cannot change a protected metatable
```

### 2.2 Metamethods Dasar untuk Akses Data: `__index` dan `__newindex`

Ini adalah dua metamethods yang paling sering digunakan dan menjadi dasar dari OOP di Lua.

- **`__index`: Menghandle missing keys**

  - **Trigger**: Dipanggil ketika Anda mencoba membaca sebuah key dari table yang _tidak ada_ (`nil`) di table tersebut.
  - **Analogi**: Bayangkan Anda bertanya pada seorang resepsionis (table) untuk file "X". Jika dia tidak memilikinya di mejanya, dia akan melihat instruksi `__index`.
  - **Perilaku**:
    - Jika `__index` berisi **table lain** (table B), Lua akan secara otomatis mencari key yang sama di table B. Ini adalah dasar dari pewarisan (inheritance).
    - Jika `__index` berisi sebuah **fungsi**, Lua akan memanggil fungsi itu dengan parameter `(table, key)` dan mengembalikan apapun yang dihasilkan fungsi tersebut.

- **`__newindex`: Controlling assignment ke missing keys**

  - **Trigger**: Dipanggil ketika Anda mencoba memberi nilai pada sebuah key yang _tidak ada_ (`nil`) di table tersebut.
  - **Analogi**: Mirip `__index`, tapi untuk penulisan. Jika seorang klien mencoba meninggalkan file baru "Y" di resepsionis, dan tidak ada laci berlabel "Y", resepsionis akan melihat instruksi `__newindex` untuk tahu apa yang harus dilakukan.
  - **Perilaku**:
    - Jika `__newindex` berisi **table lain**, penugasan akan dilakukan pada table lain tersebut, bukan pada table asli.
    - Jika `__newindex` berisi sebuah **fungsi**, fungsi itu akan dipanggil dengan parameter `(table, key, value)`.

**Contoh Visual dan Kode:**

```lua
-- Prototipe atau "Class" kita. Ini akan menjadi __index
local AccountPrototype = {
  balance = 0,
  withdraw = function(self, amount)
    self.balance = self.balance - amount
  end
}

-- Metatable yang akan kita gunakan
local mt = {
  __index = AccountPrototype, -- Jika key tidak ada di instance, cari di sini
  __newindex = function(tbl, key, value)
    if key == "balance" then
      print("Error: Cannot directly change balance. Use deposit() or withdraw().")
    else
      -- Untuk key lain, izinkan penambahan ke table asli
      rawset(tbl, key, value) -- rawset: Mengubah table tanpa memicu __newindex lagi
    end
  end
}

-- Membuat "instance" baru
function newAccount(initial_balance)
  local acc = { balance = initial_balance }
  setmetatable(acc, mt)
  return acc
end

-- Mari kita gunakan
local myAcc = newAccount(100)

-- 1. Mengakses key yang ADA di myAcc
print(myAcc.balance) -- Output: 100 (langsung dari myAcc)

-- 2. Mengakses key yang TIDAK ADA di myAcc -> __index dipicu
-- Lua mencari 'withdraw' di myAcc -> tidak ada.
-- Lua melihat metatable myAcc, menemukan __index = AccountPrototype.
-- Lua mencari 'withdraw' di AccountPrototype -> ada!
myAcc:withdraw(10) -- Ini berhasil
print(myAcc.balance) -- Output: 90

-- 3. Menulis ke key yang TIDAK ADA -> __newindex dipicu
myAcc.owner = "John Doe" -- 'owner' tidak ada, __newindex dipanggil. rawset akan menambahkannya.
print(myAcc.owner) -- Output: John Doe

-- 4. Mencoba menulis ke key yang sudah ADA (balance) -> __newindex TIDAK dipicu
myAcc.balance = 5000 -- Ini mengubah nilai balance secara langsung
print(myAcc.balance) -- Output: 5000

-- 5. Contoh __newindex yang memblokir
-- Sekarang, buat instance lain dan coba ubah balance secara ilegal
local protectedAcc = { }
setmetatable(protectedAcc, mt)
protectedAcc.balance = 999 -- Mencoba menulis ke key 'balance' yg tidak ada -> __newindex dipicu
-- Output: Error: Cannot directly change balance. Use deposit() or withdraw().
print(protectedAcc.balance) -- Output: nil (karena penugasan diblokir)
```

**Representasi Visual Alur `__index`:**

```
[ Coba akses `myAcc.withdraw` ]
        |
        V
[ Apakah 'withdraw' ada di `myAcc`? ] -- Tidak
        |
        V
[ Apakah `myAcc` punya metatable? ] -- Ya
        |
        V
[ Apakah metatable punya `__index`? ] -- Ya
        |
        V
[ Apa tipe `__index`? -> Table (`AccountPrototype`) ]
        |
        V
[ Cari 'withdraw' di `AccountPrototype` ] -- Ditemukan!
        |
        V
[ Kembalikan `AccountPrototype.withdraw` ]
```

---

## **FASE 3: OPERATOR OVERLOADING**

Di sini kita membuat table berperilaku seperti tipe data numerik atau lainnya dengan mendefinisikan ulang operator. Ini sangat mirip dengan _operator overloading_ di C++ atau Dart.

### 3.1 Metamethods Aritmatika

Anda dapat mendefinisikan perilaku untuk `+`, `-`, `*`, `/`, `%`, `^`, dan negasi.

- `__add`, `__sub`, `__mul`, `__div`, `__mod` (modulo), `__pow` (pangkat), `__unm` (unary minus).
- **Lua 5.3+**: Menambahkan metamethods untuk operasi bitwise: `__band` (&), `__bor` (|), `__bxor` (\~), `__bnot` (\~), `__shl` (\<\<), `__shr` (\>\>), dan `__idiv` (//, floor division).

**Contoh: Membuat Tipe Data `Vector`**

```lua
local Vector = {}
Vector.mt = {} -- Metatable untuk semua vector

function Vector.new(x, y)
  return setmetatable({x = x, y = y}, Vector.mt)
end

-- Mendefinisikan penjumlahan untuk Vector
Vector.mt.__add = function(v1, v2)
  return Vector.new(v1.x + v2.x, v1.y + v2.y)
end

-- Mendefinisikan negasi (unary minus)
Vector.mt.__unm = function(v)
  return Vector.new(-v.x, -v.y)
end

-- Penggunaan
local vec1 = Vector.new(10, 20)
local vec2 = Vector.new(3, 4)

local vec3 = vec1 + vec2 -- Lua memanggil Vector.mt.__add(vec1, vec2)
print(vec3.x, vec3.y) -- Output: 13  24

local vec4 = -vec1 -- Lua memanggil Vector.mt.__unm(vec1)
print(vec4.x, vec4.y) -- Output: -10 -20
```

### 3.2 Metamethods Perbandingan

- `__eq`: Dipanggil untuk operator kesetaraan (`==`). Penting: hanya dipanggil jika kedua objek memiliki tipe yang sama dan metatable `__eq` yang sama.
- `__lt`: Dipanggil untuk "lebih kecil dari" (`<`).
- `__le`: Dipanggil untuk "lebih kecil atau sama dengan" (`<=`).
- **Catatan**: Lua secara otomatis menangani `~=`, `>`, dan `>=`. `a ~= b` menjadi `not (a == b)`, dan `a > b` menjadi `b < a`. Anda hanya perlu mengimplementasikan `__eq`, `__lt`, dan `__le`.

**Contoh: Membandingkan Vector berdasarkan panjangnya**

```lua
-- Melanjutkan contoh Vector di atas...

-- Menghitung kuadrat panjang (lebih cepat dari akar kuadrat)
local function getLengthSq(v)
  return v.x^2 + v.y^2
end

-- Perbandingan kesetaraan
Vector.mt.__eq = function(v1, v2)
  return v1.x == v2.x and v1.y == v2.y
end

-- Perbandingan "lebih kecil dari"
Vector.mt.__lt = function(v1, v2)
  return getLengthSq(v1) < getLengthSq(v2)
end

-- Penggunaan
local vA = Vector.new(3, 4) -- Panjang 5
local vB = Vector.new(3, 4)
local vC = Vector.new(5, 12) -- Panjang 13

print(vA == vB) -- Output: true (karena __eq dipanggil)
print(vA == vC) -- Output: false

print(vA < vC)  -- Output: true (karena getLengthSq(vA) < getLengthSq(vC))
print(vC > vA)  -- Output: true (Lua mengubah ini menjadi vA < vC)
```

### 3.3 Metamethods Operasi Khusus

- `__concat`: Dipanggil untuk operator konkatenasi string (`..`).
- `__len`: Dipanggil untuk operator panjang (`#`).
- `__tostring`: Dipanggil oleh fungsi `print()` dan `tostring()`. Sangat berguna untuk debugging dan representasi objek yang mudah dibaca.

**Contoh: Menyempurnakan Tipe `Vector`**

```lua
-- Melanjutkan contoh Vector...

Vector.mt.__concat = function(v, s)
  -- Menggabungkan vector dengan string
  return tostring(v) .. s
end

Vector.mt.__len = function(v)
  -- Mengembalikan panjang geometris vector
  return math.sqrt(v.x^2 + v.y^2)
end

Vector.mt.__tostring = function(v)
  return "Vector(" .. v.x .. ", " .. v.y .. ")"
end

-- Penggunaan
local myVec = Vector.new(3, 4)

print(myVec) -- Output: Vector(3, 4) (karena __tostring)
print(#myVec) -- Output: 5.0 (karena __len)
print(myVec .. " is my vector.") -- Output: Vector(3, 4) is my vector. (karena __concat)
```

---

## **FASE 4: TEKNIK LANJUTAN**

Fase ini membawa kita ke beberapa fitur paling kuat dan unik dari metatables.

### 4.1 Metamethod Pemanggilan Fungsi: `__call`

- **`__call`: Membuat table bisa dipanggil seperti fungsi.**
  - **Trigger**: Ketika Anda mencoba "memanggil" sebuah table dengan `()`.
  - **Parameter**: Argumen pertama adalah table itu sendiri, diikuti oleh semua argumen yang diberikan saat pemanggilan.
  - **Aplikasi**: Membuat _functors_ (objek yang berperilaku seperti fungsi), atau pabrik objek (factory functions) yang lebih elegan.

**Contoh: Factory untuk `Vector`**

```lua
-- Daripada menggunakan Vector.new(x, y)
-- Kita ingin bisa melakukan Vector(x, y)

local Vector = {}
Vector.mt = {
    -- ... semua metamethod dari sebelumnya ...
}

-- Buat metatable untuk table Vector itu sendiri
local VectorMeta = {
  __call = function(self, x, y)
    -- 'self' di sini adalah table Vector
    -- 'x' dan 'y' adalah argumen yang diberikan
    return setmetatable({x = x, y = y}, Vector.mt)
  end
}
setmetatable(Vector, VectorMeta)

-- Penggunaan baru yang lebih bersih:
local v = Vector(7, 24) -- Terlihat seperti memanggil fungsi, padahal memicu __call
print(v) -- Output: Vector(7, 24)
```

### 4.2 Metamethods Garbage Collection: `__gc` dan `__mode`

Ini adalah topik yang sangat penting untuk manajemen memori, terutama saat berinteraksi dengan sumber daya eksternal (file, koneksi jaringan, objek C).

- **`__gc`: Finalizer**

  - **Trigger**: Dipanggil oleh _Garbage Collector_ (GC) tepat sebelum sebuah table akan dihapus dari memori (karena tidak ada referensi lagi ke table tersebut).
  - **Fungsi**: Berguna untuk melakukan _cleanup_, seperti menutup file handle atau melepaskan memori yang dialokasikan di C.

- **`__mode`: Weak References dan Weak Tables**

  - **Terminologi**:
    - **Strong Reference**: Referensi normal. Selama referensi ini ada, objek tidak akan di-GC. Semua referensi di Lua secara default adalah strong.
    - **Weak Reference**: Referensi yang _tidak_ mencegah objek di-GC. Jika sebuah objek hanya memiliki weak references, ia akan dihapus.
  - **`__mode`**: Metamethod ini memungkinkan sebuah table untuk memiliki weak references ke key atau valuenya.
  - **Nilai `__mode`**:
    - `"k"`: Key di dalam table bersifat weak.
    - `"v"`: Value di dalam table bersifat weak.
    - `"kv"`: Key dan value keduanya bersifat weak.
  - **Aplikasi**: Sangat berguna untuk membuat _cache_. Anda bisa menyimpan data di sebuah table tanpa khawatir data tersebut akan menumpuk dan menyebabkan memory leak, karena jika data tersebut tidak digunakan di tempat lain, GC akan otomatis membersihkannya dari cache.

**Contoh `__gc` dan `__mode` (Cache)**

```lua
-- Contoh __gc
local tempFile = { handle = io.open("temp.txt", "w") }
setmetatable(tempFile, {
  __gc = function(tf)
    print("Finalizer called: Closing temp file.")
    tf.handle:close()
  end
})
tempFile.handle:write("hello")
-- Saat 'tempFile' tidak lagi dapat dijangkau, __gc akan dipanggil
-- (Dalam skrip singkat, ini mungkin terjadi saat program berakhir)


-- Contoh __mode untuk Cache
local cache = {}
setmetatable(cache, {__mode = "v"}) -- Values bersifat weak

function getObject(id)
  -- Pertama, coba ambil dari cache
  if cache[id] then
    return cache[id]
  end

  -- Jika tidak ada, buat objek baru (misalnya, data besar)
  local obj = { data = "Data besar untuk ID: " .. id }
  cache[id] = obj -- Simpan di cache
  return obj
end

-- Penggunaan
local obj1 = getObject(1)
print("Objek 1 ada.")

-- Sekarang, buang satu-satunya strong reference ke obj1
obj1 = nil

-- Paksa garbage collector untuk berjalan (hanya untuk demo)
collectgarbage()

-- Coba akses lagi, seharusnya objek sudah hilang dari cache
local obj1_retrieved = getObject(1) -- akan membuat objek baru lagi

-- Catatan: Perilaku GC bisa kompleks. Di aplikasi nyata,
-- Anda tidak bisa berasumsi kapan tepatnya GC akan berjalan.
```

### 4.3 Metamethods Iterator dan Perbedaan Versi

Cara Lua menangani iterasi kustom telah berevolusi. Ini adalah area di mana pemahaman versi menjadi krusial.

- **`__pairs` (Lua 5.2+)**: Memungkinkan Anda mendefinisikan ulang perilaku `pairs()`. `pairs(t)` akan memeriksa `t` untuk metamethod `__pairs`. Jika ada, `__pairs` akan dipanggil untuk menyediakan fungsi iterator, state, dan nilai awal.
- **`__ipairs` (Lua 5.2, deprecated)**: Sama seperti `__pairs`, tapi untuk `ipairs()`. Ini tidak lagi digunakan di versi Lua modern.
- **Pola Iterasi Kustom (Semua Versi)**: Cara paling kompatibel adalah membuat fungsi iterator sendiri, yang tidak bergantung pada `__pairs` atau `__ipairs`.
- **`__close` (Lua 5.4+)**: Bagian dari fitur _to-be-closed variables_. Metamethod ini dipanggil ketika sebuah variabel lokal yang ditandai sebagai `<close>` keluar dari scope. Ini adalah cara modern dan terstruktur untuk manajemen sumber daya (RAII - Resource Acquisition Is Initialization).

**Contoh `__pairs` dan `__close`**

```lua
-- Contoh __pairs
local myObject = { a=1, b=2, c=3, hidden="secret" }
setmetatable(myObject, {
  __pairs = function(t)
    -- Iterator kustom yang menyembunyikan 'hidden'
    local keys = {}
    for k in pairs(t) do
      if k ~= "hidden" then table.insert(keys, k) end
    end

    local i = 0
    return function() -- Fungsi iterator
      i = i + 1
      if keys[i] then
        return keys[i], t[keys[i]]
      end
    end
  end
})

for k, v in pairs(myObject) do
  print(k, v) -- Output: a 1, b 2, c 3. 'hidden' tidak muncul.
end

-- Contoh __close (Lua 5.4+)
function newResource(name)
  local res = { name = name }
  return setmetatable(res, {
    __close = function(self, errorOccurred)
      print("Closing resource: " .. self.name .. ". Error status: " .. tostring(errorOccurred))
    end
  })
end

do
  local myRes <close> = newResource("DB Connection")
  print("Using resource " .. myRes.name)
  -- Saat blok 'do' berakhir, __close akan dipanggil secara otomatis
end
-- Output:
-- Using resource DB Connection
-- Closing resource: DB Connection. Error status: nil
```

---

## **FASE 5: DESIGN PATTERNS DAN APLIKASI**

Di sini kita menggabungkan semua yang telah kita pelajari untuk membangun pola pemrograman tingkat tinggi.

### 5.1 Pola Pewarisan (Inheritance)

- **Single Inheritance**: Ini adalah pola paling umum di Lua. Biasanya diimplementasikan dengan `__index` yang menunjuk ke table "parent" atau "prototype". Jika sebuah metode tidak ditemukan di "child", Lua akan mencarinya di "parent". Ini adalah _prototype-based inheritance_.
- **Multiple Inheritance**: Lebih kompleks, tetapi bisa dicapai. Biasanya, `__index` diatur ke sebuah fungsi yang secara manual mencari key di beberapa table "parent" secara berurutan. Ini memerlukan penanganan konflik jika beberapa parent memiliki metode dengan nama yang sama.

**Contoh Single Inheritance**

```lua
-- Kelas dasar
local Shape = { area = 0 }
function Shape:printArea()
  print("The area is: " .. self.area)
end

-- Kelas turunan
local Square = {}
setmetatable(Square, {__index = Shape}) -- Square mewarisi dari Shape

function Square:new(side)
  local obj = { side = side }
  -- Set __index ke kelas itu sendiri untuk method lookup
  setmetatable(obj, {__index = self})
  return obj
end

function Square:calculateArea()
  self.area = self.side * self.side
end

-- Penggunaan
local s1 = Square:new(10)
s1:calculateArea()
s1:printArea() -- Metode ini dipanggil dari Shape!
-- Output: The area is: 100
```

### 5.2 Object-Oriented Programming (OOP) di Lua

Lua tidak memiliki sintaks `class` seperti Dart, tetapi metatables memungkinkan kita untuk mensimulasikannya dengan sangat efektif. Pola di atas (`Square:new(...)`, `setmetatable(obj, {__index = self})`) adalah cara standar untuk membuat "konstruktor" dan "instance" di Lua.

- **Class-like structures**: Table `Square` bertindak sebagai "kelas".
- **Method definition dan `self`**: Menggunakan sintaks titik dua (`function Square:new(...)`) secara otomatis menambahkan parameter `self` yang tersembunyi, sama seperti `this` di Dart.
- **Polymorphism**: Dapat dicapai dengan memiliki objek yang berbeda yang mengimplementasikan metode dengan nama yang sama. Sebuah fungsi dapat memanggil `obj:draw()` tanpa perlu tahu apakah `obj` adalah `Square`, `Circle`, atau `Triangle`, selama mereka semua memiliki metode `draw`.

---

## **FASE 6: KINERJA DAN OPTIMISASI**

Ini adalah pertimbangan praktis saat menggunakan metatables secara ekstensif.

### 6.1 Pertimbangan Kinerja

- **Metatable Lookup Overhead**: Setiap kali metamethod dipanggil (misalnya, akses `__index`), ada sedikit overhead. Lua harus memeriksa key di table asli, gagal, menemukan metatable, dan kemudian memanggil metamethod.
- **Caching Strategies**: Jika sebuah metamethod `__index` melakukan komputasi yang mahal, Anda bisa melakukan caching. Setelah nilai dihitung, simpan langsung di table instance (`rawset(tbl, key, value)`). Akses berikutnya akan menemukan nilai itu secara langsung tanpa memicu `__index` lagi.

### 6.2 Manajemen Memori

- **Metatable Sharing**: Untuk menghemat memori, buat ribuan instance berbagi _satu_ metatable yang sama. Ini adalah praktik standar.
- **Avoiding Memory Leaks**: Pastikan Anda tidak secara tidak sengaja menciptakan _reference cycles_ (A menunjuk ke B, B menunjuk ke A) yang tidak dapat dipecah oleh weak tables, karena ini akan mencegah GC membersihkan objek-objek tersebut. Gunakan weak references (`__mode`) jika perlu untuk memutus siklus ini.

---

### Kesimpulan dan Langkah Selanjutnya

Anda sekarang memiliki peta jalan yang sangat detail untuk menguasai Metatables dan Metamethods di Lua. Kurikulum yang Anda sediakan, ditambah dengan penjelasan mendalam, analogi, dan contoh kode ini, memberikan fondasi yang lebih dari cukup.

**Saran untuk Pembelajaran:**

1.  **Praktik, Praktik, Praktik**: Ambil setiap contoh kode di sini, ketik ulang (jangan copy-paste), jalankan, dan modifikasi. Tanyakan pada diri sendiri, "apa yang terjadi jika saya mengubah ini?".
2.  **Bangun Proyek Kecil**: Buatlah proyek mini menggunakan konsep ini. Misalnya:
    - Sebuah library untuk aljabar linear dengan tipe data `Vector` dan `Matrix`.
    - Sebuah sistem "kelas" OOP sederhana untuk model game (misalnya, `Character`, `Enemy`, `Item`).
    - Sebuah proxy table yang mencatat (logs) setiap kali ada field yang dibaca atau ditulis.
3.  **Baca Sumber Referensi**: Kurikulum Anda memiliki daftar sumber yang fantastis. Sekarang setelah Anda memiliki gambaran besar, menyelam ke dalam "Programming in Lua" (PIL) atau referensi lain akan jauh lebih bermanfaat.
    - **Referensi Utama**: [Programming in Lua (PIL), Chapter 13](https://www.lua.org/pil/13.html) - Ini adalah sumber de-facto untuk belajar metatables.

Dengan pendekatan yang sistematis ini, Anda tidak hanya akan belajar _menggunakan_ metatables, tetapi Anda akan _memahami_ cara kerjanya di tingkat fundamental. Ini akan memungkinkan Anda untuk merancang API yang elegan, mengelola memori secara efisien, dan memecahkan masalah kompleks dengan solusi yang idiomatik dan kuat di Lua. Berikutnya kita akan menyelami teknik-teknik yang lebih canggih, kasus-kasus khusus, dan aplikasi dunia nyata yang menunjukkan kekuatan sejati dari metatables.

### Daftar Isi (Lanjutan)

- [**FASE 7: ADVANCED TECHNIQUES DAN EDGE CASES**](#fase-7-advanced-techniques-dan-edge-cases)
  - [7.1 Metatable Chaining](#71-metatable-chaining)
  - [7.2 Integration dengan C API](#72-integration-dengan-c-api)
  - [7.3 Debugging dan Troubleshooting](#73-debugging-dan-troubleshooting)
- [**FASE 8: REAL-WORLD APPLICATIONS**](#fase-8-real-world-applications)
  - [8.1 Domain-Specific Languages (DSL)](#81-domain-specific-languages-dsl)
  - [8.2 Game Development Applications](#82-game-development-applications)
  - [8.3 Library dan Framework Design](#83-library-dan-framework-design)
- [**Analisis Akhir Kurikulum dan Referensi**](#analisis-akhir-kurikulum-dan-referensi)

---

## **FASE 7: ADVANCED TECHNIQUES DAN EDGE CASES**

Fase ini adalah tentang mendorong batasan, memahami interaksi yang kompleks, dan belajar bagaimana menangani skenario yang tidak umum. Penguasaan di level ini membedakan seorang programmer Lua yang mahir dari yang biasa.

### 7.1 Metatable Chaining

- **Complex inheritance hierarchies (Pewarisan Bertingkat)**: Ini adalah perluasan alami dari pola pewarisan tunggal. Jika sebuah metatable sendiri memiliki metatable, Lua akan mengikuti rantai ini.

  - **Cara Kerja**: Ketika Anda mengakses `obj.key` dan `key` tidak ada di `obj`, Lua memeriksa `getmetatable(obj).__index`. Jika `__index` ini adalah sebuah table (sebut saja `Parent`) dan `key` juga tidak ada di `Parent`, Lua _tidak berhenti_. Ia akan memeriksa `getmetatable(Parent).__index` dan seterusnya, hingga rantai berakhir (menemukan `key` atau `__index` adalah `nil`/fungsi).
  - **Analogi**: Pikirkan ini sebagai rantai komando. Jika seorang prajurit tidak tahu perintah, ia bertanya pada sersan. Jika sersan tidak tahu, ia bertanya pada letnan, dan seterusnya ke atas.

- **Dynamic metatable modification (Modifikasi Metatable Dinamis)**: Karena metatables hanyalah table biasa, Anda dapat mengubahnya kapan saja saat program berjalan (runtime).

  - **Kekuatan**: Ini memungkinkan perubahan perilaku objek secara dinamis. Anda bisa "menukar" kelas sebuah objek atau menambahkan/menghapus kemampuan saat runtime.
  - **Risiko**: Ini adalah fitur yang sangat tajam. Mengubah metatable yang digunakan bersama oleh banyak objek akan secara instan memengaruhi semua objek tersebut, yang bisa menyebabkan perilaku tak terduga jika tidak dikelola dengan hati-hati.

- **Circular reference prevention (Pencegahan Referensi Sirkular)**: Ini adalah jebakan umum. Terjadi ketika rantai `__index` secara tidak sengaja menunjuk kembali ke dirinya sendiri.

  - **Contoh Masalah**: `TableA` memiliki metatable yang `__index`-nya adalah `TableB`. `TableB` memiliki metatable yang `__index`-nya adalah `TableA`. Jika Anda mencari key yang tidak ada di keduanya, Lua akan masuk ke dalam loop tak terbatas (`A -> B -> A -> B ...`) dan program akan crash dengan error "stack overflow".
  - **Solusi**: Rancang hierarki Anda dengan hati-hati untuk menjadi asiklik (seperti pohon, bukan jaring). Jika referensi dua arah diperlukan untuk data, gunakan _weak tables_ untuk salah satu arah untuk memutus siklus dari perspektif Garbage Collector.

**Contoh Kode Chaining dan Modifikasi Dinamis:**

```lua
-- Grandparent Class
local Entity = { isEntity = true }
function Entity:getID() return self.id end

-- Parent Class
local Character = { isCharacter = true }
setmetatable(Character, {__index = Entity}) -- Character mewarisi dari Entity

function Character:speak(message) print(self.name .. " says: " .. message) end

-- Child Class
local Player = { isPlayer = true, name = "Player" }
setmetatable(Player, {__index = Character}) -- Player mewarisi dari Character

-- Instance
local p1 = { id = 1 }
setmetatable(p1, {__index = Player})

-- Penggunaan Chaining
print(p1.isEntity)    -- Output: true (ditemukan di Entity melalui Character)
print(p1:getID())     -- Output: 1 (metode dari Entity)
p1:speak("Hello!")    -- Output: Player says: Hello! (metode dari Character)

-- Modifikasi Dinamis
local Monster = { isMonster = true }
setmetatable(Monster, {__index = Entity})
function Monster:growl() print("GRRRR!") end

print("Player is now becoming a monster...")
-- Ubah 'kelas' p1 saat runtime
setmetatable(p1, {__index = Monster})

-- p1 tidak bisa lagi berbicara, tapi sekarang bisa menggeram
-- pcall digunakan untuk menangkap error yang diharapkan
local success, result = pcall(function() p1:speak("Still me?") end)
print("Can speak?", success) -- Output: Can speak? false
p1:growl() -- Output: GRRRR!
```

### 7.2 Integration dengan C API

Ini adalah salah satu penggunaan metatables yang paling kuat, yaitu untuk menjembatani dunia Lua dengan kode C/C++.

- **Userdata metatables**:

  - **Terminologi**: `Userdata` adalah tipe data Lua yang mewakili pointer atau data mentah dari C. Lua dapat menyimpan dan meneruskannya, tetapi tidak dapat memanipulasinya secara langsung. Userdata adalah "kotak hitam" dari perspektif Lua.
  - **Peran Metatables**: Anda dapat melampirkan metatable ke `userdata`. Ini memungkinkan Anda untuk memberikan "antarmuka" Lua ke data C. Misalnya, Anda bisa membuat objek `userdata` yang mewakili koneksi database dari C, dan metatable-nya menyediakan fungsi Lua seperti `db:query()`, `db:close()`, dan `__gc` untuk menutup koneksi secara otomatis.

- **C function integration patterns**: Fungsi-fungsi di dalam metatable `userdata` biasanya adalah fungsi C yang telah didaftarkan ke Lua (menggunakan `lua_pushcfunction`). Fungsi C ini dapat memanipulasi data di dalam `userdata` secara langsung, memberikan fungsionalitas penuh pada objek "kotak hitam" tersebut.

- **Cross-language object binding**: Kombinasi `userdata` dan metatables adalah tulang punggung dari _binding_. Ini memungkinkan library C (seperti library grafis, fisika, atau AI) untuk diekspos ke skrip Lua dengan cara yang terasa alami dan "idiomatic" bagi programmer Lua, menyembunyikan semua detail implementasi C yang rumit.

### 7.3 Debugging dan Troubleshooting

Kode yang sangat bergantung pada metatables bisa sulit untuk di-debug. Mengetahui jebakan dan tekniknya sangat penting.

- **Common metatable pitfalls dan solutions (Jebakan Umum dan Solusinya)**:

  - **`__index` vs `__newindex`**: Lupa bahwa `__newindex` hanya terpicu untuk key yang _belum ada_. Untuk mencegat _semua_ penugasan, Anda perlu menggunakan proxy table.
  - **Lupa `self`**: Saat mendefinisikan metode, lupa menggunakan sintaks `: ` (`function table:method()`) atau secara manual mendeklarasikan `self` sebagai parameter pertama, menyebabkan error saat metode dipanggil.
  - **Metatable tidak terpasang**: Error paling sederhana, lupa memanggil `setmetatable`.
  - **`rawset`/`rawget`**: Lupa menggunakan `rawset` di dalam metamethod `__newindex`, menyebabkan rekursi tak terbatas.

- **Debugging metatable behavior**:

  - Gunakan `getmetatable(obj)` untuk memeriksa metatable suatu objek. Jika metatable dilindungi (`__metatable` field), gunakan `debug.getmetatable(obj)` yang akan selalu mengembalikannya.
  - Manfaatkan `__tostring` secara ekstensif. Membuat representasi string yang informatif untuk objek Anda akan sangat mempercepat proses debugging.
  - Gunakan `pcall` (Protected Call) untuk mengeksekusi kode yang mungkin gagal karena masalah metatable, memungkinkan Anda menangani error dengan anggun daripada membuat seluruh skrip crash.

- **Testing strategies untuk metatable-heavy code**:

  - Tulis unit test untuk setiap metamethod secara terpisah.
  - Uji kasus-kasus tepi: apa yang terjadi jika Anda menambahkan objek dengan tipe yang berbeda? Apa yang terjadi jika operand adalah `nil`?
  - Uji interaksi antar metamethods.
  - Uji rantai pewarisan dan pastikan metode yang benar dipanggil.

---

## **FASE 8: REAL-WORLD APPLICATIONS**

Di fase ini, kita melihat bagaimana semua konsep ini bersatu untuk membangun sistem yang kuat dan elegan.

### 8.1 Domain-Specific Languages (DSL)

Metatables memungkinkan Anda membengkokkan sintaks Lua untuk menciptakan "bahasa" kecil yang sangat ekspresif untuk domain masalah tertentu.

- **Creating expressive APIs**: Anda bisa merancang API yang terasa deklaratif. Misalnya, sebuah library UI bisa menggunakan `__call` untuk memungkinkan sintaks seperti ini:

  ```lua
  local ui = require("my_ui_lib")

  local myWindow = ui.Window { -- Menggunakan __call pada ui.Window
    title = "My App",
    width = 400,
    height = 300,

    ui.Button { -- __call lagi
      text = "OK",
      onClick = function() print("OK clicked!") end
    }
  }
  ```

  Di sini, `ui.Window` dan `ui.Button` bukan fungsi biasa, melainkan table dengan metamethod `__call` yang mem-parsing table argumen untuk membangun objek UI.

- **Configuration system design**: Gunakan `__index` untuk menyediakan nilai konfigurasi default. Pengguna hanya perlu menentukan nilai yang ingin mereka ubah.

  ```lua
  local defaultConfig = { theme = "dark", fontsize = 12 }
  local userConfig = { fontsize = 14 }

  setmetatable(userConfig, {__index = defaultConfig})

  print(userConfig.fontsize) -- Output: 14 (dari userConfig)
  print(userConfig.theme)   -- Output: dark (dari defaultConfig via __index)
  ```

### 8.2 Game Development Applications

Game adalah salah satu domain di mana fleksibilitas Lua dan metatables benar-benar bersinar.

- **Entity Component Systems (ECS)**: Metatables adalah alat yang sempurna untuk mengimplementasikan pola ECS di Lua.

  - Sebuah _entity_ bisa berupa table kosong.
  - _Components_ (seperti `position`, `renderable`, `physics`) adalah table yang dilampirkan ke entity.
  - Metatable entity bisa memiliki `__index` yang merupakan fungsi. Fungsi ini akan memeriksa key yang diminta dan meneruskannya ke komponen yang relevan. Misalnya, `myPlayer:draw()` akan dideteksi oleh `__index`, yang kemudian akan menemukan komponen `renderable` dan memanggil fungsi `draw` di dalamnya.

- **Resource management systems**: Seperti yang dibahas sebelumnya, `__gc` sangat penting untuk memastikan sumber daya grafis dan audio (tekstur, suara) dilepaskan dari memori saat objek game yang menggunakannya tidak lagi ada.

- **Event handling frameworks**: Anda dapat membuat sistem di mana `event:listen(callback)` dan `event:fire(...)` dapat disederhanakan.

### 8.3 Library dan Framework Design

Prinsip-prinsip ini berlaku untuk pembuatan alat apa pun yang dapat digunakan kembali di Lua.

- **API design best practices**: Gunakan metatables untuk menyembunyikan kompleksitas. Pengguna library Anda tidak perlu tahu _bagaimana_ objek Anda bekerja di dalam; mereka hanya perlu berinteraksi dengan antarmuka bersih yang Anda sediakan melalui metamethods.

- **Backwards compatibility strategies**: Jika Anda perlu mengganti nama sebuah properti di library Anda, Anda tidak perlu merusak kode pengguna lama. Anda bisa menggunakan `__index` dan `__newindex` untuk mencegat akses ke nama properti lama, mencetak peringatan "deprecated", dan secara transparan mengalihkannya ke properti baru.

- **Documentation dan usage patterns**: Dokumentasi untuk library berbasis metatable harus dengan jelas menyatakan perilaku yang di-override. Misalnya, "Objek ini mendukung operasi `+` untuk menggabungkan...", "Objek ini dapat dipanggil seperti fungsi untuk membuat instance baru...".

---

### Analisis Akhir Kurikulum dan Referensi

- **Historical Context**: Analisis perbedaan versi (misalnya, evolusi `__pairs`/`__ipairs`) sangat penting untuk menulis kode yang portabel dan memahami mengapa beberapa pola ada.
- **Performance Deep Dive**: Memahami overhead lookup dan strategi caching memisahkan kode produksi dari kode prototipe.
- **Real-world Patterns**: Contoh-contoh aplikasi di game dev, DSL, dan desain library mengubah pengetahuan teoritis menjadi keterampilan praktis.
- **Error Scenarios**: Mengetahui apa yang bisa salah dan bagaimana cara memperbaikinya adalah keterampilan yang tak ternilai.

**Estimasi Waktu dan Prasyarat** yang disebutkan (4-6 bulan dengan praktik konsisten, dan pemahaman dasar Lua) sangat realistis untuk tingkat penguasaan yang ditargetkan.

Dengan menyelesaikan uraian ini, Anda sekarang memiliki dokumen referensi yang komprehensif, dibangun di atas kerangka kurikulum yang sudah solid. Langkah selanjutnya adalah yang paling penting: **praktik**. Terapkan konsep-konsep ini. Bangun sesuatu. Uji batasannya. Hanya dengan begitu pemahaman mendalam ini akan menjadi keahlian sejati.

##### Semoga berhasil dalam perjalanan Anda menguasai salah satu fitur paling elegan dan kuat dalam bahasa Lua.


> - **[Ke Atas](#)**
> - **[Kurikulkum][1]**

[0]:../README.md
[1]:../../metatables-and-metamethods/README.md