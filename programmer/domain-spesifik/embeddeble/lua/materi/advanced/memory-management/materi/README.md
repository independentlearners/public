### Daftar Isi Pembelajaran

- [Level 1: Konsep Dasar Memory Management](#level-1-konsep-dasar-memory-management)
  - [1.1 Pengenalan Automatic Memory Management di Lua](#11-pengenalan-automatic-memory-management-di-lua)
  - [1.2 Object Creation dan Memory Allocation](#12-object-creation-dan-memory-allocation)
  - [1.3 Memory Lifecycle dan Object References](#13-memory-lifecycle-dan-object-references)
- [Level 2: Garbage Collection Fundamentals](#level-2-garbage-collection-fundamentals)
  - [2.1 Garbage Collection Algorithm di Lua](#21-garbage-collection-algorithm-di-lua)
  - [2.2 Garbage Collection Phases](#22-garbage-collection-phases)
  - [2.3 Reachability dan Object Graph](#23-reachability-dan-object-graph)
- [Level 3: Weak References dan Weak Tables](#level-3-weak-references-dan-weak-tables)
  - [3.1 Konsep Weak References](#31-konsep-weak-references)
  - [3.2 Weak Tables Implementation](#32-weak-tables-implementation)
  - [3.3 Weak Tables Use Cases](#33-weak-tables-use-cases)
- [Level 4: Finalizers dan Resource Management](#level-4-finalizers-dan-resource-management)
  - [4.1 Finalizers Fundamentals (\_\_gc)](#41-finalizers-fundamentals-__gc)
  - [4.2 Resource Management Best Practices](#42-resource-management-best-practices)
- [Level 5: Manual Garbage Collection Control](#level-5-manual-garbage-collection-control)
  - [5.1 Fungsi `collectgarbage()`](#51-fungsi-collectgarbage)
  - [5.2 GC Parameters Tuning](#52-gc-parameters-tuning)
- [Level 6: Memory Optimization Strategies](#level-6-memory-optimization-strategies)
  - [6.1 Memory-Efficient Data Structures](#61-memory-efficient-data-structures)
  - [6.2 String Interning dan Memory Sharing](#62-string-interning-dan-memory-sharing)
  - [6.3 Object Pooling Patterns](#63-object-pooling-patterns)
- [Level 7: Advanced Memory Management Topics](#level-7-advanced-memory-management-topics)
  - [7.1 Userdata Memory Management](#71-userdata-memory-management)
  - [7.2 LuaJIT-Specific Memory Management](#72-luajit-specific-memory-management)
  - [7.3 FFI Memory Management (LuaJIT-specific)](#73-ffi-memory-management-luajit-specific)
- [Level 8, 9, 10 dan Seterusnya](#level-8-9-10-dan-seterusnya)

---

## Level 1: Konsep Dasar Memory Management

Pada level ini, kita akan membangun fondasi pemahaman tentang bagaimana Lua menangani memori. Anggap ini sebagai perkenalan dengan "aturan main" dasar di dunia Lua.

### 1.1 Pengenalan Automatic Memory Management di Lua

**Deskripsi Konkret:**
Bayangkan Anda sedang memasak di dapur. Setiap kali Anda butuh bahan, Anda mengambilnya dari kulkas. Setelah selesai memasak, piring kotor, sisa bahan, dan kemasan menumpuk. Di dunia pemrograman, ada dua cara menangani "sampah" ini:

1.  **Manual Memory Management (seperti di C/C++):** Anda harus secara eksplisit membersihkan setiap sampah satu per satu. Jika Anda lupa membuang sisa kulit bawang, ia akan tetap di sana selamanya (ini disebut _memory leak_). Ini memberi Anda kontrol penuh, tetapi sangat rentan terhadap kesalahan.
2.  **Automatic Memory Management (seperti di Lua, Dart, Python):** Anda memiliki "asisten" (disebut **Garbage Collector** atau **GC**) yang secara otomatis akan berkeliling dan membersihkan semua sampah yang _sudah tidak Anda perlukan lagi_. Anda fokus pada memasak (menulis kode), dan asisten akan mengurus kebersihannya.

Lua menggunakan pendekatan kedua. Anda tidak perlu secara manual menghapus objek, _string_, atau _table_ dari memori. GC Lua akan melakukannya untuk Anda.

**Konsep & Terminologi:**

- **Memory Allocation:** Proses "mengambil" atau memesan sebagian dari memori komputer untuk menyimpan data (misalnya, saat Anda membuat _table_ baru).
- **Memory Deallocation:** Proses "mengembalikan" memori yang sudah tidak terpakai ke sistem agar bisa digunakan lagi. Di Lua, ini dilakukan secara otomatis oleh GC.
- **Garbage Collector (GC):** Sistem otomatis di dalam Lua yang bertugas mencari dan mendealokasi memori yang sudah tidak terpakai.

**Contoh Sederhana:**

```lua
-- Lua akan mengalokasikan memori untuk sebuah table
local myData = { name = "Budi", age = 25 }

print(myData.name) -- Output: Budi

-- Setelah blok 'do' ini selesai, variabel 'myData' tidak ada lagi.
-- Objek table yang sebelumnya dipegang oleh 'myData' sekarang menjadi "sampah"
-- karena tidak ada lagi yang bisa mengaksesnya.
-- GC Lua akan melihat ini dan di masa depan, saat ia berjalan,
-- memori yang digunakan oleh table ini akan dibersihkan.
do
  local myScopedData = { value = 100 }
  print(myScopedData.value)
end
-- 'myScopedData' sudah tidak bisa diakses di sini.
-- Table { value = 100 } sekarang menjadi kandidat untuk dibersihkan oleh GC.
```

**Sumber Referensi:**

- [Programming in Lua - Chapter 17](https://www.lua.org/pil/17.html)
- [Tutorialspoint - Lua Garbage Collection](https://www.tutorialspoint.com/lua/lua_garbage_collection.htm)

### 1.2 Object Creation dan Memory Allocation

**Deskripsi Konkret:**
Setiap kali Anda membuat sesuatu yang bukan merupakan tipe data sederhana (seperti angka atau boolean), Lua perlu mengalokasikan memori untuknya. Ini berlaku untuk "objek" utama di Lua.

**Konsep & Terminologi:**
Objek-objek utama di Lua yang membutuhkan alokasi memori dinamis adalah:

- **Tables:** Struktur data fundamental di Lua. `{}` adalah perintah untuk mengalokasikan memori untuk _table_ baru.
- **Functions:** Ya, fungsi di Lua adalah objek\! Saat Anda mendefinisikan sebuah fungsi, Lua mengalokasikan memori untuk menyimpan instruksi dan data terkait (seperti _upvalues_).
- **Strings:** Setiap teks unik dialokasikan memorinya sendiri. (Kita akan bahas optimisasi ini di Level 6).
- **Threads (Coroutines):** Representasi dari alur eksekusi. Membuat _coroutine_ baru akan mengalokasikan memori untuk _stack_-nya.
- **Userdata:** Objek khusus untuk menyimpan data dari C/C++ di dalam Lua.

**Proses Alokasi:**
Ketika Anda menulis `local t = {}`, proses berikut terjadi di balik layar:

1.  Kode Anda meminta _table_ baru.
2.  Interpreter Lua memanggil _memory allocator_ internalnya.
3.  _Allocator_ mencari blok memori yang cukup besar di _heap_ (area memori utama program) untuk menyimpan struktur data _table_.
4.  Jika ditemukan, _allocator_ mengembalikan alamat memori tersebut ke interpreter Lua.
5.  Variabel `t` Anda sekarang "menunjuk" ke alamat memori tersebut.

**Contoh Kode:**

```lua
-- Alokasi memori untuk sebuah table
local player = {
  name = "Siti",
  health = 100
}

-- Alokasi memori untuk sebuah string
-- Meskipun "Hello World" sama, Lua mungkin mengoptimalkannya (lebih lanjut di Level 6)
local greeting = "Hello World"
local farewell = "Goodbye World"

-- Alokasi memori untuk sebuah function (closure)
local function createCounter()
  local count = 0
  return function()
    count = count + 1
    return count
  end
end

-- Setiap panggilan ke createCounter() mengalokasikan memori untuk 'count'
-- dan fungsi anonim yang baru
local counter1 = createCounter()
local counter2 = createCounter()

-- Alokasi memori untuk sebuah thread (coroutine)
local co = coroutine.create(function()
  print("Inside coroutine")
end)
```

**Sumber Referensi:**

- [Programming in Lua - Chapter 17](https://www.lua.org/pil/17.html)
- [Coder Scratch Pad - Memory Management in Lua](https://coderscratchpad.com/memory-management-in-lua/)

### 1.3 Memory Lifecycle dan Object References

**Deskripsi Konkret:**
Setiap objek di Lua memiliki siklus hidup:

1.  **Creation (Penciptaan):** Memori dialokasikan (misalnya `t = {}`).
2.  **Usage (Penggunaan):** Objek digunakan oleh program Anda melalui variabel yang menunjuk padanya.
3.  **Destruction (Penghancuran):** Ketika tidak ada lagi variabel yang menunjuk ke objek tersebut, ia menjadi "sampah". GC kemudian akan menghancurkannya dan membebaskan memorinya.

Kunci untuk memahami kapan sesuatu menjadi "sampah" adalah konsep **referensi**.

**Konsep & Terminologi:**

- **Reference (Referensi):** Sebuah "penunjuk" atau "pegangan" dari sebuah variabel ke sebuah objek di memori. Dalam `local t = {}`, variabel `t` memegang referensi ke objek _table_.
- **Strong Reference (Referensi Kuat):** Ini adalah tipe referensi standar di Lua. Selama ada **setidaknya satu** referensi kuat yang menunjuk ke sebuah objek, objek tersebut **tidak akan pernah** dianggap sampah oleh GC. Ia akan tetap hidup.
- **Object Lifecycle:** Perjalanan objek dari alokasi hingga dealokasi.

**Visualisasi Sederhana:**

Bayangkan objek `{ name = "A" }` adalah sebuah balon. Variabel `varA` adalah tali yang memegang balon itu.

```lua
-- 1. Creation: Balon diciptakan, dan tali 'varA' memegangnya.
local varA = { name = "A" }

-- 2. Usage: Kita menggunakan balon melalui talinya.
print(varA.name)

-- Sekarang, kita ikat tali baru, 'varB', ke balon yang sama.
local varB = varA
-- Sekarang ada DUA tali (strong references) yang memegang balon.

-- Kita potong tali pertama.
varA = nil
-- Balon masih aman, karena tali 'varB' masih memegangnya.

-- Kita potong tali kedua.
varB = nil
-- 3. Destruction: Tidak ada tali lagi yang memegang balon.
-- Balon sekarang terbang bebas, menjadi "sampah".
-- GC akan melihatnya dan "meletuskannya" (membebaskan memori).
```

Memahami _strong reference_ adalah kunci absolut untuk mengerti mengapa beberapa objek tetap ada di memori sementara yang lain dibersihkan.

**Sumber Referensi:**

- [GameDev Academy - Lua Memory Management Tutorial](https://gamedevacademy.org/lua-memory-management-tutorial-complete-guide/)

---

## Level 2: Garbage Collection Fundamentals

Sekarang kita tahu "apa" yang dilakukan GC, mari kita selami "bagaimana" cara kerjanya. Ini sedikit lebih teknis, tetapi sangat penting untuk optimisasi.

### 2.1 Garbage Collection Algorithm di Lua

**Deskripsi Konkret:**
Lua tidak hanya memiliki satu jenis GC. Algoritmanya telah berevolusi untuk menjadi lebih efisien. Sejak versi 5.1, Lua menggunakan **Incremental Mark-and-Sweep Garbage Collector**. Pada Lua 5.4, diperkenalkan mode opsional baru: **Generational Garbage Collection**.

**Konsep & Terminologi:**

- **Incremental Mark-and-Sweep:** Bayangkan asisten pembersih (GC) yang tidak membersihkan seluruh rumah dalam sekali jalan (yang akan menghentikan semua aktivitas lain), tetapi melakukannya sedikit demi sedikit di sela-sela pekerjaan Anda. Ini mengurangi jeda (_pause_) yang dirasakan oleh aplikasi.

  - **Mark Phase (Fase Penandaan):** GC mulai dari titik-titik "akar" (variabel global, _stack_) dan menelusuri semua objek yang bisa dijangkau, memberinya tanda "masih digunakan".
  - **Sweep Phase (Fase Pembersihan):** GC memeriksa semua objek di memori. Jika sebuah objek tidak memiliki tanda "masih digunakan", ia akan dibersihkan (memorinya dibebaskan).

- **Tri-color Marking Algorithm:** Ini adalah teknik yang digunakan untuk membuat GC menjadi _incremental_. Bayangkan objek diwarnai:

  - **Putih (White):** Objek yang diasumsikan sampah (belum dikunjungi).
  - **Abu-abu (Gray):** Objek yang sudah dikunjungi dan ditandai "digunakan", tetapi anak-anaknya (objek yang direferensikannya) belum selesai diperiksa.
  - **Hitam (Black):** Objek yang sudah dikunjungi, ditandai "digunakan", dan semua anaknya juga sudah selesai diperiksa.
    GC bekerja dengan mengubah objek dari putih -\> abu-abu -\> hitam. Ini memungkinkan GC untuk berhenti di tengah jalan (misalnya, saat masih ada objek abu-abu) dan melanjutkannya lagi nanti tanpa kehilangan jejak.

- **Generational Garbage Collection (Lua 5.4+):** Ini didasarkan pada observasi ("hipotesis generasional") bahwa **objek yang baru dibuat cenderung cepat menjadi sampah**.

  - **Analogi:** Di sebuah kantor, sampah harian seperti cangkir kopi dan kertas memo (objek _muda_) lebih sering dibuang daripada perabotan seperti meja dan kursi (objek _tua_).
  - **Cara Kerja:** GC membagi objek menjadi dua "generasi": muda (_young_) dan tua (_old_). GC akan jauh lebih sering menjalankan siklus pembersihan pada generasi muda. Objek yang berhasil bertahan dari beberapa siklus pembersihan di generasi muda akan "dipromosikan" ke generasi tua, yang lebih jarang diperiksa. Ini membuat pengumpulan sampah sehari-hari menjadi sangat cepat.

**Sumber Referensi:**

- [Lua 5.4 Reference Manual - Garbage Collection](https://www.google.com/search?q=https://www.lua.org/manual/5.4/manual.html%232.5)
- [Understanding Lua's Garbage Collection - ACM](https://dl.acm.org/doi/fullHtml/10.1145/3414080.3414093) (Materi akademis yang sangat mendalam)

### 2.2 Garbage Collection Phases

**Deskripsi Konkret:**
Mari kita uraikan fase-fase dari algoritma _mark-and-sweep_ secara lebih detail.

**Konsep & Terminologi:**

1.  **Mark Phase (Fase Penandaan):**
    - **Tujuan:** Mengidentifikasi semua objek yang "hidup" atau dapat dijangkau.
    - **Proses:** Dimulai dari _root set_ (lihat 2.3), GC secara rekursif mengikuti setiap referensi. Setiap objek yang ditemui ditandai (misalnya, diubah warnanya dari putih menjadi abu-abu).
2.  **Sweep Phase (Fase Pembersihan):**
    - **Tujuan:** Membebaskan memori dari objek yang "mati" atau tidak dapat dijangkau.
    - **Proses:** GC melakukan pemindaian linear terhadap seluruh memori yang dikelolanya. Jika ia menemukan objek yang masih berwarna putih (tidak tertandai selama fase _mark_), objek tersebut dianggap sampah dan memorinya dikembalikan ke sistem. Objek yang berwarna hitam akan diubah kembali menjadi putih untuk persiapan siklus GC berikutnya.
3.  **Finalization Phase (Fase Finalisasi):**
    - **Tujuan:** Menjalankan "kehendak terakhir" dari sebuah objek sebelum dihancurkan.
    - **Proses:** Jika sebuah objek yang akan dibersihkan memiliki _metamethod_ `__gc` (sebuah finalizer, lihat Level 4), objek tersebut tidak langsung dihancurkan. Sebaliknya, ia dipindahkan ke daftar khusus. Lua kemudian akan memanggil fungsi `__gc` untuk setiap objek dalam daftar tersebut.

**Sumber Referensi:**

- [GameDev Academy - Lua Garbage Collection Tutorial](https://gamedevacademy.org/lua-garbage-collection-tutorial-complete-guide/)
- [Luadocs - Garbage Collection](https://cyevgeniy.github.io/luadocs/02_basic_concepts/ch05.html)

### 2.3 Reachability dan Object Graph

**Deskripsi Konkret:**
Konsep paling fundamental bagi GC adalah "reachability" (keterjangkauan). GC tidak peduli apakah sebuah objek "penting" bagi logika bisnis Anda; ia hanya peduli apakah objek tersebut bisa dijangkau dari titik awal yang telah ditentukan.

**Konsep & Terminologi:**

- **Root Set (Kumpulan Akar):** Titik awal yang dijamin ada oleh GC. Ini termasuk:
  - Tabel global (`_G`).
  - _Stack_ eksekusi saat ini (variabel lokal dari fungsi yang sedang berjalan).
  - Registry Lua (area internal untuk referensi C-API).
- **Object Graph (Grafik Objek):** Jaringan hubungan antar objek. Variabel dalam _root set_ adalah titik awal. Objek yang mereka referensikan adalah simpul (node) level pertama. Objek yang direferensikan oleh simpul-simpul tersebut adalah level kedua, dan seterusnya. Ini membentuk sebuah "jaring laba-laba" referensi.
- **Reachable vs Unreachable:**
  - **Reachable (Dapat Dijangkau):** Sebuah objek dianggap _reachable_ jika ada jalur dari _root set_ ke objek tersebut melalui grafik objek. Objek ini "hidup".
  - **Unreachable (Tidak Dapat Dijangkau):** Jika tidak ada jalur sama sekali dari _root set_ ke sebuah objek, objek tersebut _unreachable_ dan dianggap "sampah".
- **Circular References (Referensi Melingkar):** Ini adalah situasi di mana objek A mereferensikan objek B, dan objek B mereferensikan kembali objek A.
  - **Pertanyaan:** Apakah ini menyebabkan _memory leak_?
  - **Jawaban:** Di sistem GC yang naif (seperti _reference counting_ sederhana), ya. Tetapi di Lua, **tidak**. Algoritma _mark-and-sweep_ menangani ini dengan elegan. Jika tidak ada referensi dari _root set_ ke A maupun B, maka seluruh "pulau" terisolasi ini akan dianggap _unreachable_ dan akan dibersihkan bersama-sama.

**Visualisasi Object Graph:**

```
          [ ROOT SET ]
              |
              | (Strong Reference)
              v
       +-------------+
       |   Table A   |-----+
       | (globalVar) |     |
       +-------------+     |
             |             | (Strong Reference)
             v             v
      +-------------+   +-------------+
      |  Function F |   |   Table B   |
      +-------------+   +-------------+


       +-------------+   +-------------+
       |   Table C   |<-->|   Table D   |  <-- Circular Reference
       +-------------+   +-------------+
       (Tidak ada referensi dari ROOT atau A/B/F ke C/D)
```

- **Reachable:** `Table A`, `Function F`, `Table B`. Mereka tidak akan dibersihkan.
- **Unreachable:** `Table C` dan `Table D`. Meskipun mereka saling mereferensikan, tidak ada jalur dari `ROOT SET` ke mereka. Keduanya akan dibersihkan oleh GC.

**Sumber Referensi:**

- [Coder Scratch Pad - Memory Management in Lua](https://coderscratchpad.com/memory-management-in-lua/)

---

## Level 3: Weak References dan Weak Tables

Ini adalah salah satu fitur manajemen memori paling kuat di Lua. Jika _strong reference_ adalah rantai baja, _weak reference_ adalah benang sutra.

### 3.1 Konsep Weak References

**Deskripsi Konkret:**
Sebuah _weak reference_ (referensi lemah) ke sebuah objek **tidak akan mencegah** objek tersebut dikumpulkan oleh GC. Ini adalah pegangan "lemah" yang akan putus jika tidak ada pegangan "kuat" lain yang tersisa.

**Kapan Menggunakan Weak References?**
Gunakan ini ketika Anda ingin mereferensikan sebuah objek tanpa "memilikinya". Kasus penggunaan yang paling umum adalah untuk _caching_. Anda ingin menyimpan hasil komputasi yang mahal, tetapi jika tidak ada bagian lain dari program yang menggunakan objek tersebut dan memori menipis, Anda rela jika data _cache_ tersebut dibuang untuk memberi ruang.

**Perbedaan Strong vs Weak:**

- **Strong Reference:** "Saya _membutuhkan_ objek ini. Jangan buang."
- **Weak Reference:** "Saya ingin _mengawasi_ objek ini, tetapi jika tidak ada orang lain yang membutuhkannya, silakan buang."

### 3.2 Weak Tables Implementation

**Deskripsi Konkret:**
Di Lua, referensi lemah tidak diimplementasikan pada variabel individual, melainkan pada sebuah _table_ khusus yang disebut **Weak Table**. Anda membuat sebuah _table_ menjadi _weak_ dengan mengatur _metatable_-nya.

**Konsep & Terminologi:**

- **Metatable:** Sebuah _table_ yang mendefinisikan perilaku _table_ lain.
- **`__mode` Metafield:** Ini adalah kunci khusus dalam _metatable_. Jika Anda mengatur nilainya menjadi sebuah _string_, Anda mengubah _table_ utama menjadi _weak table_. Nilai yang mungkin adalah:
  - `'k'`: Membuat **kunci** (_keys_) dalam _table_ menjadi _weak_. Jika sebuah objek yang digunakan sebagai kunci tidak memiliki referensi kuat lain, entri tersebut akan dihapus dari _table_.
  - `'v'`: Membuat **nilai** (_values_) dalam _table_ menjadi _weak_. Jika sebuah objek yang digunakan sebagai nilai tidak memiliki referensi kuat lain, entri tersebut akan dihapus dari _table_.
  - `'kv'`: Membuat kunci dan nilai menjadi _weak_.

**Sintaks & Contoh Kode:**

**Contoh 1: Weak Values (`__mode = 'v'`)**

```lua
-- Table ini akan menyimpan nilai-nilai secara lemah.
local cache = {}
setmetatable(cache, { __mode = 'v' })

-- Buat sebuah objek (dengan referensi kuat dari 'key')
local key = { data = "Data Mahal" }

-- Simpan objek di cache.
-- 'cache' sekarang memiliki referensi lemah ke objek tersebut.
-- 'key' memiliki referensi kuat.
cache[1] = key

-- Hapus satu-satunya referensi kuat ke objek tersebut.
key = nil

-- Paksa GC untuk berjalan (hanya untuk demonstrasi)
collectgarbage("collect")

-- Tunggu sejenak agar GC bekerja
-- Coba akses lagi dari cache. Kemungkinan besar sudah nil.
-- Pada siklus GC berikutnya, entri cache[1] akan dihapus.
print(cache[1]) -- Output: nil
```

**Contoh 2: Weak Keys (`__mode = 'k'`)**
Ini berguna untuk mengasosiasikan data dengan objek tanpa mencegah objek tersebut dibersihkan.

```lua
-- Table ini akan menyimpan data untuk setiap objek. Kuncinya lemah.
local objectData = {}
setmetatable(objectData, { __mode = 'k' })

do
  local myObject = { id = 123 } -- Objek ini hanya hidup di dalam blok 'do'
  objectData[myObject] = "Ini adalah data tambahan untuk myObject"

  -- Saat ini, ada referensi kuat (myObject) dan referensi lemah (kunci di objectData)
  print(objectData[myObject]) -- Output: Ini adalah data tambahan...
end

-- Sekarang, variabel 'myObject' sudah di luar scope.
-- Tidak ada lagi referensi kuat ke table {id = 123}.
-- Karena kunci di 'objectData' lemah, ini tidak akan menahannya.

collectgarbage("collect")

-- Entri yang kuncinya adalah {id = 123} akan dihapus dari 'objectData'.
-- Kita tidak bisa lagi mengaksesnya, dan 'objectData' sekarang kosong.
```

**Sumber Referensi:**

- [Lua-users Wiki - Weak Tables Tutorial](http://lua-users.org/wiki/WeakTablesTutorial)
- [Programming in Lua - Chapter 17.1](https://www.lua.org/pil/17.1.html)

### 3.3 Weak Tables Use Cases

**Deskripsi Konkret:**
_Weak tables_ bukan hanya trik akademis; mereka memecahkan masalah nyata dengan sangat elegan.

- **Caching dengan Pembersihan Otomatis:** Seperti contoh di atas. Anda bisa menyimpan data yang mahal untuk dibuat. Jika data asli tidak lagi digunakan di mana pun, _cache_ akan secara otomatis membersihkan dirinya sendiri tanpa perlu logika manual.
- **Pola Desain Observer:** Anda bisa memiliki daftar "pengamat" (_observers_) dari sebuah subjek. Jika seorang pengamat dihancurkan (misalnya, karakter dalam game mati), Anda tidak ingin subjek terus memegang referensi ke sana, yang akan menyebabkannya tidak pernah dibersihkan (memory leak). Dengan menggunakan _weak table_ untuk menyimpan daftar pengamat, pengamat yang mati akan secara otomatis dihapus dari daftar.
- **Memoization yang Aman dari Sisi Memori:** _Memoization_ adalah teknik menyimpan hasil pemanggilan fungsi untuk input yang sama. Dengan menggunakan _weak table_ di mana kunci adalah argumen (jika argumennya adalah objek), Anda bisa memastikan bahwa cache memoization tidak secara tidak sengaja menjaga objek argumen tetap hidup selamanya.

**Sumber Referensi:**

- [Stack Overflow - Lua Weak References](https://stackoverflow.com/questions/7451734/lua-weak-references)

---

Ini baru mencakup 3 Level pertama dari kurikulum Anda. Seperti yang Anda lihat, setiap topik memerlukan penjelasan mendalam, definisi terminologi, dan contoh kode yang jelas. Saya akan melanjutkan dengan cara yang sama untuk level-level berikutnya.

Lanjutkan ke bagian selanjutnya jika Anda sudah siap.

## Level 4: Finalizers dan Resource Management

Jika _weak tables_ adalah tentang melepaskan objek dengan anggun, _finalizers_ adalah tentang melakukan "ritual pembersihan" terakhir sebelum sebuah objek benar-benar hilang.

### 4.1 Finalizers Fundamentals (`__gc`)

**Deskripsi Konkret:**
Sebuah _finalizer_ adalah fungsi yang Anda kaitkan dengan sebuah objek, yang akan dijalankan oleh Lua **tepat sebelum** GC menghancurkan objek tersebut. Ini adalah kesempatan terakhir Anda untuk berinteraksi dengan objek itu.

Di Lua, Anda mendefinisikan _finalizer_ dengan menggunakan _metamethod_ `__gc`.

**Kapan Menggunakan `__gc`?**
Gunakan ini untuk melepaskan **sumber daya eksternal** yang tidak dikelola oleh GC Lua. Contoh paling umum:

- _File handles_: Memastikan sebuah file yang Anda buka (`io.open`) ditutup dengan benar (`file:close()`).
- _Network connections_: Menutup koneksi TCP/socket.
- _Memori C/C++_: Jika Anda menggunakan _full userdata_ untuk membungkus pointer dari C, Anda harus memanggil `free()` dari C di dalam `__gc` untuk mencegah _memory leak_ di sisi C.

**Sintaks & Contoh Kode:**

```lua
-- Mari kita buat kelas 'FileWrapper' yang aman
FileWrapper = {}
FileWrapper.__index = FileWrapper

function FileWrapper.new(path, mode)
  local file, err = io.open(path, mode)
  if not file then return nil, err end

  local self = setmetatable({
    handle = file
  }, FileWrapper)

  return self
end

function FileWrapper:read(...)
  return self.handle:read(...)
end

-- Inilah bagian pentingnya: Finalizer
function FileWrapper:__gc()
  print("Finalizer dipanggil untuk file: "..tostring(self.handle))
  if self.handle then
    self.handle:close()
  end
end

-- Penggunaan
do
  local myFile = FileWrapper.new("test.txt", "w")
  if myFile then
    -- Lakukan sesuatu dengan file...
  end
  -- Saat 'myFile' keluar dari scope, ia menjadi kandidat untuk GC.
end

-- Paksa GC berjalan
collectgarbage("collect")
-- Output akan menampilkan: "Finalizer dipanggil untuk file: file (0x...)"
```

**Konsep Penting: Object Resurrection**
Selama eksekusi `__gc`, objek tersebut "dihidupkan kembali" untuk sementara. Jika Anda menyimpan referensi ke `self` di tempat lain (misalnya, di tabel global) di dalam fungsi `__gc`, objek tersebut akan menjadi _reachable_ lagi dan tidak jadi dihancurkan. Ini adalah praktik yang **sangat tidak dianjurkan** karena bisa menyebabkan perilaku yang membingungkan.

**Sumber Referensi:**

- [Lua 5.4 Reference Manual - `__gc`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%232.5.1%5D(https://www.lua.org/manual/5.4/manual.html%232.5.1)>)

### 4.2 Resource Management Best Practices

**Deskripsi Konkret:**
Menggunakan `__gc` adalah implementasi dari pola desain yang sangat penting yang disebut **RAII (Resource Acquisition Is Initialization)**.

**Konsep & Terminologi:**

- **RAII:** Pola ini menyatakan bahwa akuisisi sumber daya (membuka file, mengalokasikan memori) harus terjadi saat inisialisasi objek (dalam _constructor_ atau fungsi `new`), dan pelepasan sumber daya harus terjadi saat penghancuran objek (dalam _destructor_ atau `__gc`).
- **Manfaat:** Ini membuat manajemen sumber daya menjadi otomatis dan anti-rapuh. Anda tidak perlu ingat untuk memanggil `file:close()` di setiap kemungkinan jalur keluar dari fungsi Anda (termasuk saat terjadi error). Cukup pastikan objek dibuat, dan RAII akan menangani pembersihannya. Contoh `FileWrapper` di atas adalah implementasi RAII di Lua.

**Batasan dan Jebakan Finalizer:**
Finalizer sangat kuat, tetapi berbahaya jika disalahgunakan:

- **Urutan tidak dijamin:** Jika beberapa objek dengan `__gc` menjadi sampah pada saat yang sama, urutan eksekusi finalizer mereka tidak dapat diprediksi.
- **Jangan pernah `yield`:** Finalizer tidak boleh memanggil fungsi yang menghasilkan _yield_ (seperti `coroutine.yield`).
- **Penanganan Error:** Error di dalam `__gc` akan ditangkap oleh Lua dan biasanya dilaporkan, tetapi tidak akan menghentikan finalizer lain berjalan.
- **Waktu Tidak Dapat Diprediksi:** Anda tidak tahu _kapan_ `__gc` akan dipanggil. Itu hanya akan terjadi pada suatu saat setelah objek menjadi _unreachable_. Jangan mengandalkannya untuk tugas yang sensitif terhadap waktu.

---

## Level 5: Manual Garbage Collection Control

Meskipun GC Lua otomatis, Lua memberi Anda "tuas" untuk memengaruhinya secara manual. Ini berguna dalam skenario di mana Anda membutuhkan kontrol lebih besar atas performa.

### 5.1 Fungsi `collectgarbage()`

**Deskripsi Konkret:**
Fungsi `collectgarbage()` adalah antarmuka utama Anda untuk berinteraksi dengan GC. Anda bisa menghentikannya, memulainya, memicunya, dan menyetel parameternya.

**Sintaks & Contoh Kode:**

```lua
-- Mendapatkan jumlah memori yang sedang digunakan Lua (dalam KB)
local memory_used = collectgarbage("count")
print(string.format("Memory used: %.2f KB", memory_used))

-- Menghentikan GC otomatis
collectgarbage("stop")
print("GC dihentikan.")

-- Buat banyak 'sampah'
for i = 1, 10000 do
  local t = { a = i, b = i+1, c = i+2 }
end

local memory_after_garbage = collectgarbage("count")
print(string.format("Memory used after creating garbage (GC stopped): %.2f KB", memory_after_garbage))
-- Anda akan melihat penggunaan memori meningkat drastis.

-- Memulai kembali GC otomatis
collectgarbage("restart")
print("GC dimulai kembali.")

-- Memaksa satu siklus pengumpulan penuh
collectgarbage("collect")
print("Siklus GC penuh dipaksa.")

local memory_after_collect = collectgarbage("count")
print(string.format("Memory used after full collection: %.2f KB", memory_after_collect))
-- Penggunaan memori akan turun kembali.
```

**Mode-mode Utama `collectgarbage()`:**

- `"collect"`: Menjalankan satu siklus GC penuh.
- `"stop"`: Menghentikan GC dari berjalan secara otomatis.
- `"restart"`: Memulai kembali GC otomatis.
- `"count"`: Mengembalikan total memori yang digunakan Lua dalam kilobyte.
- `"step"`: Menjalankan satu "langkah" GC. Berguna untuk menyebar beban GC dari waktu ke waktu.
- `"isrunning"`: Mengembalikan `true` jika GC sedang berjalan.

**Kapan Menggunakan Kontrol Manual?**

- **Game Development:** Anda mungkin ingin menghentikan GC selama gameplay intens dan hanya menjalankan siklus penuh selama layar pemuatan (_loading screen_) untuk menghindari _stutter_ atau _hiccup_ yang merusak _frame rate_.
- **Real-time Systems:** Dalam aplikasi yang membutuhkan latensi sangat rendah, Anda bisa mengontrol kapan tepatnya jeda GC terjadi.

### 5.2 GC Parameters Tuning

**Deskripsi Konkret:**
Anda juga bisa "menyetel" seberapa agresif GC bekerja. Ini seperti mengatur seberapa sering asisten pembersih Anda berkeliling.

**Parameter Utama (via `collectgarbage("setpause")` dan `collectgarbage("setstepmul")`):**

- **Pause (`setpause`):** Mengontrol seberapa lama GC menunggu setelah menyelesaikan satu siklus penuh sebelum memulai yang baru. Nilai yang lebih tinggi berarti jeda lebih lama (GC lebih jarang berjalan). Nilai default adalah 200 (artinya menunggu sampai total memori menjadi 2x lipat sebelum memulai siklus baru).
- **Step Multiplier (`setstepmul`):** Mengontrol seberapa besar setiap "langkah" dari siklus GC. Nilai yang lebih tinggi berarti setiap langkah lebih besar (GC selesai lebih cepat, tetapi setiap jeda lebih terasa). Nilai yang lebih rendah membuat GC lebih "halus" tetapi membutuhkan waktu lebih lama untuk menyelesaikan satu siklus.

**Mode Generasional (Lua 5.4+):**
Anda bisa mengganti mode GC ke generasional.

```lua
-- Mengubah ke mode generasional
-- Parameter: minor_multiplier, major_multiplier
collectgarbage("generational", 0, 0) -- Angka 0 akan menggunakan default

-- Mengubah kembali ke mode incremental
collectgarbage("incremental", 200, 100, 2) -- Argumen adalah pause, stepmul, stepsize
```

**Kapan Menggunakan Mode Generasional?**
Mode ini seringkali lebih efisien untuk aplikasi yang membuat banyak objek berumur pendek, yang sangat umum. Ia bisa mengurangi latensi GC secara signifikan karena "koleksi minor" (pada generasi muda) sangat cepat.

---

## Level 6: Memory Optimization Strategies

Mengetahui cara kerja GC itu bagus. Mengetahui cara menulis kode yang "ramah" terhadap GC itu lebih baik. Ini adalah tentang mengurangi tekanan pada _memory manager_.

### 6.1 Memory-Efficient Data Structures

**Deskripsi Konkret:**
Cara Anda menyusun _tables_ bisa memiliki dampak besar pada penggunaan memori.

**Konsep & Terminologi:**

- **Array Part vs Hash Part:** Sebuah _table_ di Lua secara internal dioptimalkan. Jika Anda menggunakan kunci integer berurutan (1, 2, 3, ...), Lua akan menyimpannya dalam struktur seperti array yang sangat efisien. Jika Anda menggunakan kunci acak atau _string_, Lua harus menggunakan struktur _hash map_ yang lebih boros memori.
- **Table Pre-sizing:** Setiap kali Anda menambahkan elemen ke _hash part_ dari sebuah _table_ dan ia menjadi terlalu penuh, Lua harus melakukan **rehash**: ia membuat ruang baru yang lebih besar dan menyalin semua elemen lama ke sana. Proses ini memakan waktu dan bisa menyebabkan jeda. Jika Anda tahu sebelumnya berapa banyak elemen yang akan Anda simpan, Anda bisa "pra-alokasi" _table_ tersebut.

**Sintaks & Contoh Kode:**

```lua
-- Buruk: menyebabkan banyak rehash
local t1 = {}
for i = 1, 1000 do
  t1["key" .. i] = i -- Setiap penambahan bisa memicu rehash
end

-- Baik: pra-alokasi untuk hash part
-- table.create(array_size, hash_size)
-- Ini adalah fitur baru di Lua 5.3+
local t2 = table.create(0, 1000)
for i = 1, 1000 do
  t2["key" .. i] = i
end
```

**Aturan Praktis:**

- Gunakan _array-like tables_ (`{10, 20, 30}`) jika memungkinkan.
- Jika menggunakan _hash-like tables_ dengan ukuran yang diketahui, pra-alokasikan dengan `table.create` (jika tersedia).

### 6.2 String Interning dan Memory Sharing

**Deskripsi Konkret:**
Lua sangat cerdas dalam menangani _string_. Jika Anda membuat seratus variabel yang semuanya berisi teks `"hello"`, Lua hanya akan menyimpan teks `"hello"` **satu kali** di memori. Semua variabel tersebut akan menunjuk ke lokasi memori yang sama. Proses ini disebut **String Interning**.

**Manfaat:**

- **Penghematan Memori Luar Biasa:** Mencegah duplikasi data teks yang sama.
- **Perbandingan Cepat:** Membandingkan dua _string_ untuk kesamaan (`str1 == str2`) menjadi sangat cepat, karena Lua hanya perlu membandingkan alamat memori mereka, bukan membandingkan karakter per karakter.

**Implikasi:**

- Anda tidak perlu khawatir membuat _string_ yang sama berulang kali. Lua akan menanganinya untuk Anda.
- _String_ di Lua bersifat _immutable_ (tidak bisa diubah). Saat Anda melakukan `myString = myString .. "a"`, Anda tidak mengubah _string_ asli, tetapi membuat _string_ yang benar-benar baru. Melakukan ini berulang kali dalam sebuah _loop_ sangat tidak efisien karena menciptakan banyak "sampah" _string_ sementara.

**Contoh Kode (Inefisien vs Efisien):**

```lua
-- Buruk: menciptakan banyak string sementara yang menjadi sampah
local longString = ""
for i = 1, 1000 do
  longString = longString .. "x" -- Setiap iterasi membuat objek string baru
end

-- Baik: menggunakan table untuk mengumpulkan bagian-bagian
local parts = {}
for i = 1, 1000 do
  table.insert(parts, "x")
end
longString = table.concat(parts, "") -- Hanya satu alokasi besar di akhir
```

### 6.3 Object Pooling Patterns

**Deskripsi Konkret:**
GC itu cepat, tetapi tidak gratis. Membuat dan menghancurkan ribuan objek per detik (misalnya, peluru dalam game, partikel efek) akan memberi tekanan pada GC dan bisa menyebabkan jeda. **Object Pooling** adalah solusinya.

**Analogi:**
Daripada menggunakan cangkir kertas sekali pakai dan terus-menerus membuangnya (menciptakan sampah), Anda memiliki rak berisi cangkir keramik. Saat butuh minum, Anda ambil cangkir dari rak. Setelah selesai, Anda mencucinya dan meletakkannya kembali di rak untuk digunakan lagi nanti.

**Cara Kerja:**

1.  **Inisialisasi:** Buat sekumpulan objek ("pool") di awal dan tandai semuanya sebagai "tidak aktif".
2.  **Permintaan (`acquire`):** Saat Anda butuh objek baru, Anda tidak membuat yang baru. Anda meminta satu dari _pool_. _Pool_ akan mencari objek yang tidak aktif, mengaturnya kembali ke keadaan awal, dan memberikannya kepada Anda.
3.  **Pengembalian (`release`):** Saat Anda selesai dengan objek tersebut, Anda tidak menghapusnya (`obj = nil`). Anda mengembalikannya ke _pool_, di mana ia ditandai lagi sebagai "tidak aktif".

**Contoh Kode Sederhana:**

```lua
-- Pool untuk objek peluru
BulletPool = {}
BulletPool.pool = {}

function BulletPool.get()
  -- Coba ambil dari pool dulu
  if #BulletPool.pool > 0 then
    return table.remove(BulletPool.pool)
  else
    -- Jika pool kosong, buat yang baru
    return { x = 0, y = 0, isActive = true }
  end
end

function BulletPool.release(bullet)
  bullet.isActive = false
  table.insert(BulletPool.pool, bullet)
end

-- Penggunaan
local bulletsInAir = {}
-- Tembak peluru
local b1 = BulletPool.get()
table.insert(bulletsInAir, b1)

-- Peluru mengenai target
-- Daripada menghancurkannya, kembalikan ke pool
local hitBullet = table.remove(bulletsInAir, 1)
BulletPool.release(hitBullet)
```

Pola ini secara drastis mengurangi "churn" (tingkat pembuatan dan penghancuran objek), membuat kerja GC jauh lebih ringan.

---

## Level 7: Advanced Memory Management Topics

Sekarang kita memasuki area yang benar-benar membedakan seorang ahli Lua. Topik-topik ini seringkali spesifik untuk kasus penggunaan tingkat lanjut seperti integrasi C atau penggunaan LuaJIT.

### 7.1 Userdata Memory Management

**Deskripsi Konkret:**
_Userdata_ adalah "kotak hitam" ajaib yang memungkinkan Anda menyimpan data C/C++ mentah di dalam variabel Lua. Lua tidak tahu apa isinya, ia hanya tahu cara mengalokasikan dan (jika diberitahu) membebaskannya. Ada dua jenis:

- **Light Userdata:** Pada dasarnya hanyalah sebuah _pointer_ C (`void*`). Ini tidak dikelola oleh GC Lua. Ia hanyalah sebuah nilai. Jika Anda kehilangan semua referensi ke sana, nilai itu hilang, tetapi memori yang ditunjuknya di sisi C **tidak** dibebaskan. Anda bertanggung jawab 100% atas memorinya.
- **Full Userdata:** Ini adalah blok memori mentah yang **dikelola oleh GC Lua**. Lua mengalokasikan sejumlah byte untuk Anda. Anda bisa mengaitkan _metatable_ dengannya, yang berarti Anda bisa memberikan `__gc` _finalizer_ padanya. Ini adalah cara yang aman dan disukai untuk mengelola objek C/C++ di Lua.

**Kapan Menggunakannya?**
Saat Anda meng-embed Lua di aplikasi C/C++ dan ingin mengekspos objek C++ (misalnya, `GameObject*`, `DatabaseConnection*`) ke skrip Lua.

**Contoh Konseptual (C API):**

```c
// Di C
// Membuat full userdata baru berukuran sizeof(MyObject)
MyObject* obj = (MyObject*)lua_newuserdata(L, sizeof(MyObject));
// Panggil constructor C++ di memori yang sudah dialokasikan
new(obj) MyObject();

// Atur metatable-nya, yang berisi __gc untuk memanggil destructor
luaL_getmetatable(L, "MyObjectMeta");
lua_setmetatable(L, -2);
```

Di dalam `__gc` di metatable "MyObjectMeta", Anda akan memanggil destructor C++ untuk membersihkan objek tersebut dengan benar.

### 7.2 LuaJIT-Specific Memory Management

**Deskripsi Konkret:**
**LuaJIT** adalah implementasi Lua yang sangat cepat dengan _Just-In-Time (JIT) compiler_. Meskipun sangat kompatibel dengan Lua 5.1, ia memiliki beberapa keunikan dalam manajemen memori.

**Batasan Alamat 2GB:**
Ini adalah batasan paling terkenal dari LuaJIT. Pada sistem 64-bit, LuaJIT **hanya bisa mengalokasikan total sekitar 2GB memori** untuk semua objek Lua (tables, strings, dll.).

- **Mengapa?** Ini adalah pilihan desain untuk performa. LuaJIT menggunakan trik pengkodean pointer cerdas yang membatasi ruang alamat yang dapat digunakannya.
- **Implikasi:** Jika aplikasi Anda membutuhkan lebih dari 2GB RAM untuk data Lua, LuaJIT standar bukanlah pilihan yang tepat. Anda harus mencari solusi alternatif atau mengelola memori di luar kendali GC LuaJIT (misalnya, melalui FFI).

### 7.3 FFI Memory Management (LuaJIT-specific)

**Deskripsi Konkret:**
**FFI (Foreign Function Interface)** adalah fitur andalan LuaJIT. Ini memungkinkan Anda memanggil fungsi C dan menggunakan tipe data C (seperti `struct` dan `array`) langsung dari kode Lua tanpa perlu menulis C _binding_ manual. Ini sangat kuat.

**Manajemen Memori dengan FFI:**

- Memori yang dialokasikan menggunakan FFI (misalnya, `ffi.C.malloc()`) **tidak dikelola oleh GC LuaJIT**.
- Ini adalah pedang bermata dua:
  1.  **Keuntungan:** Anda bisa mengalokasikan memori di luar batas 2GB LuaJIT. Anda bisa mengelola buffer besar untuk data biner, gambar, dll.
  2.  **Kerugian:** Anda kembali ke **manajemen memori manual**. Anda **harus** secara manual memanggil `ffi.C.free()` untuk setiap blok memori yang Anda alokasikan dengan `ffi.C.malloc()`. Lupa melakukannya akan menyebabkan **memory leak** yang parah.

**Contoh Kode (Pola RAII dengan FFI):**
Cara terbaik untuk mengelola memori FFI adalah dengan membungkusnya dalam _table_ atau _full userdata_ dan menggunakan `__gc` untuk memastikan pembersihan.

```lua
local ffi = require("ffi")

-- Deklarasikan fungsi C yang akan kita gunakan
ffi.cdef[[
  void* malloc(size_t size);
  void free(void* ptr);
]]

-- Buat 'kelas' untuk buffer yang aman
local SafeBuffer_mt = {
  __gc = function(self)
    print("Membebaskan buffer FFI...")
    ffi.C.free(self.ptr)
  end
}

function createSafeBuffer(size)
  local ptr = ffi.C.malloc(size)
  local self = { ptr = ptr, size = size }
  return setmetatable(self, SafeBuffer_mt)
end

-- Penggunaan
do
  local myBuffer = createSafeBuffer(1024 * 1024) -- Alokasi 1MB
  -- Lakukan sesuatu dengan myBuffer.ptr
end

collectgarbage("collect")
-- Output: "Membebaskan buffer FFI..."
-- Memori dibebaskan secara otomatis saat 'myBuffer' menjadi sampah.
```

Pola ini menggabungkan kekuatan FFI dengan keamanan GC Lua, memberikan yang terbaik dari kedua dunia.

---

## Level 8: Performance Optimization

Mengetahui cara kerja GC dan memori adalah satu hal. Menggunakan pengetahuan itu untuk membuat aplikasi Anda berjalan secepat kilat adalah tujuan utamanya. Level ini fokus pada teknik dan strategi untuk memeras setiap ons performa dari kode Lua Anda.

### 8.1 GC Performance Tuning

**Deskripsi Konkret:**
_Performance tuning_ adalah seni menyeimbangkan antara penggunaan memori dan latensi aplikasi (jeda). Ini adalah sebuah pertukaran (_trade-off_):

- **GC Agresif:** Berjalan lebih sering, menjaga penggunaan memori tetap rendah, tetapi berisiko menyebabkan banyak jeda kecil yang bisa mengganggu.
- **GC Malas:** Berjalan lebih jarang, membiarkan penggunaan memori membengkak, tetapi menghasilkan jeda yang lebih sedikit (meskipun setiap jeda mungkin lebih lama saat akhirnya terjadi).

Tujuan Anda adalah menemukan titik manis untuk aplikasi spesifik Anda.

**Teknik Mengukur Dampak GC:**
Anda tidak bisa mengoptimalkan apa yang tidak bisa Anda ukur. Alat paling sederhana namun ampuh di Lua untuk _benchmarking_ adalah `os.clock()`.

**Konsep & Contoh Kode:**

```lua
-- Fungsi sederhana untuk mengukur waktu eksekusi
function benchmark(description, func)
  local startTime = os.clock()
  func() -- Jalankan fungsi yang ingin diukur
  local endTime = os.clock()
  print(string.format("%s, Waktu: %.4f detik", description, endTime - startTime))
end

-- Mari kita ukur berapa lama satu siklus GC penuh
benchmark("Tes siklus GC penuh", function()
  -- Paksa GC untuk membersihkan semua sampah yang mungkin ada
  collectgarbage("collect")
end)

-- Sekarang, buat banyak sampah
local garbage = {}
for i = 1, 50000 do
  garbage[i] = { a = i, b = "string" .. i }
end
garbage = nil -- Buat 50,000 table menjadi sampah

-- Ukur lagi. Kali ini, GC punya banyak pekerjaan.
benchmark("Tes siklus GC penuh dengan banyak sampah", function()
  collectgarbage("collect")
end)
```

Dengan menggunakan teknik ini, Anda bisa mengukur dampak dari berbagai bagian kode Anda atau menyetel parameter GC dan melihat efeknya secara langsung.

**Menyetel Parameter untuk Kasus Penggunaan Berbeda:**

- **Game atau Aplikasi Interaktif (Latensi Rendah adalah Kunci):**
  - **Tujuan:** Hindari jeda panjang dengan cara apa pun.
  - **Strategi:** Gunakan GC _incremental_ dan sebarkan bebannya.
  - **Implementasi:**
    ```lua
    -- Di awal frame game
    local startTime = os.clock()
    -- Jalankan GC hanya untuk waktu yang sangat singkat (misalnya, 1 milidetik)
    while os.clock() - startTime < 0.001 do
      collectgarbage("step", 1) -- Lakukan langkah kecil
    end
    ```
- **Skrip Batch atau Alat CLI (Throughput adalah Kunci):**
  - **Tujuan:** Selesaikan tugas secepat mungkin, jeda sesekali tidak masalah.
  - **Strategi:** Biarkan GC berjalan secara normal, atau bahkan picu secara manual di antara tugas-tugas besar.
  - **Implementasi:**
    ```lua
    processTask1()
    collectgarbage("collect") -- Bersih-bersih sebelum tugas berikutnya
    processTask2()
    ```

**Sumber Referensi:**

- [GameDev Academy - Lua Garbage Collection Tutorial](https://gamedevacademy.org/lua-garbage-collection-tutorial-complete-guide/)

### 8.2 Memory Access Patterns

**Deskripsi Konkret:**
Performa tidak hanya ditentukan oleh algoritma, tetapi juga oleh fisika. Cara Anda mengakses data di memori dapat memiliki dampak dramatis pada kecepatan karena cara kerja perangkat keras modern, terutama **CPU Cache**.

**Konsep & Terminologi:**

- **CPU Cache:** Anggap ini sebagai meja kerja kecil yang sangat cepat di sebelah CPU Anda. Memori utama (RAM) adalah rak buku besar di seberang ruangan. Jauh lebih cepat mengambil sesuatu dari meja kerja daripada berjalan ke rak buku. Ketika CPU membutuhkan data dari RAM, ia mengambilnya beserta data di sekitarnya dan menaruhnya di _cache_ (meja kerja), dengan asumsi Anda akan membutuhkan data terdekat itu segera.
- **Cache-Friendly (Lokalitas Data):** Kode yang mengakses memori secara berurutan (misalnya, `t[1]`, `t[2]`, `t[3]`, ...) disebut _cache-friendly_. CPU bisa dengan mudah menebak apa yang Anda butuhkan selanjutnya dan mengambilnya terlebih dahulu. Ini sangat cepat.
- **Cache-Unfriendly:** Kode yang melompat-lompat di memori secara acak (misalnya, mengikuti pointer dalam _linked list_ yang tersebar) akan sering menyebabkan _cache miss_—CPU harus pergi ke "rak buku" (RAM), yang jauh lebih lambat.
- **Memory Fragmentation:** Bayangkan sebuah buku catatan dengan banyak halaman kosong. Jika Anda mencoret-coret sedikit di setiap halaman, Anda mungkin memiliki banyak ruang kosong secara total, tetapi tidak ada satu halaman pun yang benar-benar kosong untuk gambar besar. Ini adalah fragmentasi. Dalam memori, ini berarti banyak blok memori kecil yang tidak terpakai tersebar di antara blok yang terpakai. Ini bisa menyulitkan _allocator_ untuk menemukan blok besar yang berdekatan saat dibutuhkan. Pola seperti _Object Pooling_ membantu mengurangi fragmentasi dengan mendaur ulang blok memori dengan ukuran yang sama.

**Implikasi Praktis:**

- **Array \> Hash Map (jika memungkinkan):** Mengiterasi _array part_ dari sebuah _table_ jauh lebih cepat daripada mengiterasi _hash part_-nya.

  ```lua
  -- Lebih Cepat (Cache-Friendly)
  local arrayPart = {10, 20, 30, 40, 50}
  for i = 1, #arrayPart do
    process(arrayPart[i])
  end

  -- Lebih Lambat (Potensial Cache-Unfriendly)
  local hashPart = {a=10, b=20, c=30, d=40, e=50}
  for k, v in pairs(hashPart) do
    process(v)
  end
  ```

- **Structure of Arrays (SoA) vs. Array of Structures (AoS):** Ini adalah pertimbangan tingkat lanjut.

  ```lua
  -- AoS (Array of Structures) - Umum tetapi bisa kurang efisien
  local players_AoS = {
    {x=1, y=5, health=100},
    {x=2, y=8, health=90},
    {x=3, y=2, health=120}
  }
  -- Saat memproses hanya posisi, data 'health' yang tidak relevan ikut dimuat ke cache.

  -- SoA (Structure of Arrays) - Seringkali lebih cepat untuk pemrosesan data besar
  local players_SoA = {
    x = {1, 2, 3},
    y = {5, 8, 2},
    health = {100, 90, 120}
  }
  -- Saat memproses semua posisi, hanya data 'x' dan 'y' yang diakses secara berurutan. Sangat cache-friendly.
  ```

**Sumber Referensi:**

- [LÖVE Forum - Memory Management Techniques](https://love2d.org/forums/viewtopic.php?t=86843)

---

## Level 9: Real-world Applications

Sekarang mari kita terapkan semua teori dan teknik ini untuk memecahkan masalah nyata dalam domain pengembangan yang berbeda.

### 9.1 Game Development Memory Management

**Tantangan Utama:**

- **Konsistensi Frame-rate:** GC yang berjalan di tengah-tengah aksi dapat menyebabkan _stutter_ atau jeda, yang sangat mengganggu pengalaman bermain.
- **Manajemen Aset:** Game memuat banyak aset besar (tekstur, model, suara) yang harus dikelola dengan hati-hati agar tidak kehabisan memori.
- **Banyak Objek Dinamis:** Peluru, partikel, efek visual, dll., yang dibuat dan dihancurkan terus-menerus.

**Strategi dan Solusi:**

1.  **Kontrol GC yang Ketat:**
    - **Solusi:** Hentikan GC otomatis selama gameplay (`collectgarbage("stop")`). Jalankan siklus penuh (`collectgarbage("collect")`) hanya pada saat-saat yang aman, seperti layar pemuatan, menu jeda, atau akhir level.
    - **Contoh:** Pemain masuk ke zona baru -\> tampilkan layar pemuatan -\> muat aset baru -\> jalankan `collectgarbage("collect")` -\> sembunyikan layar pemuatan -\> mulai kembali gameplay.
2.  **Object Pooling untuk Segalanya:**
    - **Solusi:** Jangan pernah membuat objek _gameplay_ (seperti peluru atau partikel) saat dibutuhkan. Gunakan pola _object pool_ yang solid untuk mendaur ulang objek-objek ini. Ini secara drastis mengurangi tekanan pada GC.
3.  **Manajemen Aset dengan RAII:**
    - **Solusi:** Saat memuat aset (misalnya, tekstur ke memori GPU), bungkus _handle_ aset tersebut dalam sebuah _userdata_ atau _table_ Lua yang memiliki `__gc` _finalizer_. Ketika objek Lua ini tidak lagi direferensikan (misalnya, level dibongkar), `__gc` akan dipanggil, yang kemudian memicu pelepasan aset dari memori GPU. Ini mencegah kebocoran sumber daya grafis.

**Sumber Referensi:**

- [GameDev Academy - Lua Memory Management Tutorial](https://gamedevacademy.org/lua-memory-management-tutorial-complete-guide/)
- [GameDev Academy - Lua Garbage Collection Tutorial](https://gamedevacademy.org/lua-garbage-collection-tutorial-complete-guide/)

### 9.2 Web Application Memory Management

**Tantangan Utama:**

- **Proses yang Berjalan Lama:** Server web adalah proses yang berjalan 24/7. Kebocoran memori sekecil apa pun akan menumpuk dari waktu ke waktu dan akhirnya menyebabkan server _crash_.
- **Manajemen Sesi dan Cache:** Perlu menyimpan data per pengguna atau hasil query yang sering diakses, tetapi juga harus bisa membersihkannya saat sudah tidak relevan.

**Strategi dan Solusi:**

1.  **Pencegahan Memory Leak:**
    - **Solusi:** Disiplin dalam memastikan tidak ada referensi yang tidak diinginkan yang tertinggal, terutama dalam _closure_ atau _callback_. Gunakan _monitoring_ (`collectgarbage("count")`) untuk melacak penggunaan memori dari waktu ke waktu. Jika terus meningkat tanpa batas, itu adalah tanda adanya kebocoran.
2.  **Manajemen Cache dan Sesi Cerdas:**
    - **Solusi:** Gunakan _weak tables_ secara ekstensif.
    - **Contoh Cache:** Buat _table_ _cache_ dengan nilai-nilai lemah (`__mode = 'v'`). Simpan hasil _query_ database yang mahal di sini. Jika hasil _query_ tersebut tidak lagi digunakan di bagian lain dari aplikasi, GC akan secara otomatis membersihkannya dari _cache_.
    - **Contoh Sesi:** Anda bisa mengasosiasikan data sesi dengan objek koneksi pengguna. Jika tabel data sesi menggunakan referensi lemah ke objek koneksi, saat pengguna terputus dan objek koneksinya dihancurkan, data sesinya dapat secara otomatis dikumpulkan oleh GC.

**Sumber Referensi:**

- [Tutorialspoint - Lua Table Memory Management](https://www.tutorialspoint.com/lua/lua_table_memory_management.htm)

### 9.3 Embedded Systems Memory Management

**Tantangan Utama:**

- **Lingkungan Sangat Terbatas:** Seringkali hanya memiliki beberapa kilobyte RAM. Setiap _byte_ berharga.
- **Kebutuhan akan Determinisme:** Perilaku sistem harus dapat diprediksi. Jeda GC yang tidak terduga bisa menjadi bencana.

**Strategi dan Solusi:**

1.  **Alokasi Minimalis:**
    - **Solusi:** Hindari alokasi memori saat runtime sebisa mungkin. Alokasikan semua _table_ dan buffer yang dibutuhkan saat startup. Alih-alih membuat _table_ baru, bersihkan dan gunakan kembali _table_ yang sudah ada.
2.  **Kontrol GC Absolut:**
    - **Solusi:** Hampir selalu nonaktifkan GC otomatis (`collectgarbage("stop")`). Rancang sistem agar hanya menjalankan `collectgarbage("collect")` pada waktu yang ditentukan dengan baik dan aman, ketika sistem sedang dalam keadaan diam.
3.  **Kode yang Sangat Efisien Memori:**
    - **Solusi:** Jangan pernah menggunakan konkatenasi _string_ dalam _loop_. Gunakan kembali objek. Pahami biaya memori dari setiap struktur data yang Anda buat. Seringkali, kode menjadi lebih "gaya C" dalam pendekatannya terhadap memori.

**Sumber Referensi:**

- [Coder Scratch Pad - Memory Management in Lua](https://coderscratchpad.com/memory-management-in-lua/)

---

## Level 10: Advanced Research Topics

Level ini untuk mereka yang ingin memahami "mengapa"-nya di balik semua ini pada tingkat akademis. Ini adalah tentang ilmu komputer di balik manajemen memori Lua.

### 10.1 Formal Verification of GC

**Deskripsi Konkret:**
Ini adalah cabang ilmu komputer teoretis di mana para peneliti menggunakan logika matematika untuk **membuktikan secara formal** bahwa algoritma GC Lua itu benar.

- **Apa yang dibuktikan?**
  - **Keamanan (Safety):** GC tidak akan pernah membebaskan memori dari objek yang masih bisa dijangkau (_live object_). Ini membuktikan bahwa GC tidak akan merusak program Anda.
  - **Keaktifan (Liveness):** Setiap objek yang menjadi tidak terjangkau (_garbage_) pada akhirnya akan dikumpulkan oleh GC. Ini membuktikan bahwa tidak ada kebocoran memori yang disebabkan oleh algoritma itu sendiri.
- **Mengapa ini penting?** Ini memberikan tingkat kepercayaan tertinggi pada keandalan inti dari runtime Lua.

**Sumber Referensi:**

- [Understanding Lua's Garbage Collection - ACM](https://dl.acm.org/doi/fullHtml/10.1145/3414080.3414093) (Ini adalah contoh makalah akademis yang menganalisis GC Lua.)

### 10.2 Alternative GC Strategies

**Deskripsi Konkret:**
_Mark-and-sweep_ bukanlah satu-satunya cara untuk mengelola memori. Mempelajari alternatifnya membantu kita memahami mengapa tim Lua membuat pilihan desain yang mereka lakukan.

- **Reference Counting:** Setiap objek memiliki penghitung berapa banyak referensi yang menunjuk padanya. Ketika penghitung mencapai nol, objek tersebut segera dihapus.
  - _Kelebihan:_ Penghancuran objek bersifat deterministik (terjadi segera setelah referensi terakhir hilang).
  - _Kekurangan:_ Tidak bisa menangani _circular references_ (objek A menunjuk B, B menunjuk A) tanpa "detektor siklus" tambahan yang kompleks. Overhead dari menaikkan dan menurunkan penghitung pada setiap penugasan referensi. (Python menggunakan pendekatan ini).
- **Concurrent Collectors:** Algoritma GC yang sangat canggih (seperti yang ada di Java modern) yang dirancang untuk berjalan secara bersamaan dengan program utama, meminimalkan jeda hingga hampir nol, tetapi dengan biaya kompleksitas dan overhead memori yang signifikan.

### 10.3 Memory Management Evolution

**Deskripsi Konkret:**
Manajemen memori di Lua tidak statis; ia telah berevolusi seiring waktu untuk memenuhi tuntutan baru.

- **Lua Awal:** Menggunakan GC _mark-and-sweep_ yang lebih sederhana dan non-incremental, yang dapat menyebabkan jeda yang signifikan.
- **Lua 5.1:** Memperkenalkan _incremental garbage collector_ (menggunakan algoritma tri-color), sebuah lompatan besar untuk aplikasi yang membutuhkan latensi rendah seperti game.
- **Lua 5.4:** Memperkenalkan _generational garbage collector_ sebagai mode opsional. Ini adalah pengakuan bahwa pola alokasi yang berbeda mendapat manfaat dari strategi GC yang berbeda, memberikan lebih banyak kekuatan dan kontrol kepada pengembang untuk menyetel performa.

Memahami evolusi ini menunjukkan komitmen berkelanjutan dari tim Lua untuk performa dan efisiensi.

---

### **Pesan Penutup**

Anda sekarang telah menyelesaikan perjalanan komprehensif melalui dunia manajemen memori Lua, dari konsep paling dasar hingga aplikasi dunia nyata dan bahkan teori akademis. Kurikulum yang Anda sediakan adalah kerangka yang luar biasa, dan dengan uraian ini, Anda memiliki panduan yang solid untuk mencapai penguasaan sejati.

Ingat, pengetahuan ini menjadi kekuatan nyata saat diterapkan. Bereksperimenlah, bangun proyek, ukur performa, dan jangan takut untuk menyelam lebih dalam. **Selamat berkarya\!**
