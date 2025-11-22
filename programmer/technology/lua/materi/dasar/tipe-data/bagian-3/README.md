# **[3. Tipe Data Kompleks - _Advanced_][0]**

Setelah menguasai tipe-tipe primitif, kita akan beralih ke tipe data yang memiliki struktur dan perilaku yang lebih kompleks. Tipe-tipe ini—`function`, `table`, `userdata`, dan `thread`—adalah inti dari program-program Lua yang canggih. Ini adalah area di mana kekuatan ekspresif dan fleksibilitas Lua benar-benar bersinar. Kita akan mulai dengan tipe `function`, yang merupakan salah satu konsep paling fundamental dan kuat dalam bahasa ini.

### **3.1 Tipe `function` - Internal Fungsi**

Di Lua, fungsi adalah **_first-class citizens_** (warga kelas satu). Ini adalah konsep sentral yang berarti fungsi diperlakukan sama seperti tipe data lainnya (seperti `number` atau `string`). Artinya, sebuah fungsi dapat:

- Disimpan dalam variabel.
- Disimpan di dalam _field_ tabel.
- Diberikan sebagai argumen ke fungsi lain (disebut _higher-order function_).
- Dikembalikan sebagai hasil dari fungsi lain.

Sifat ini membuka jalan bagi banyak pola pemrograman yang kuat, terutama yang bergaya fungsional.

#### **_Function Prototypes_ dan _Bytecode_**

- **Deskripsi**: Saat Anda menjalankan skrip Lua, interpreter tidak langsung membaca dan mengeksekusi kode teks Anda baris per baris. Sebaliknya, Lua melalui tahap **kompilasi**, di mana kode sumber diubah menjadi format perantara yang lebih efisien yang disebut **_bytecode_**.

  - **Terminologi**:
    - **_Bytecode_**: Ini adalah serangkaian instruksi level rendah yang dirancang untuk dieksekusi oleh **Lua Virtual Machine (VM)**, bukan oleh CPU secara langsung. Setiap instruksi melakukan operasi sederhana seperti mengambil nilai lokal, menjumlahkan dua angka, atau memanggil fungsi lain. _Bytecode_ jauh lebih cepat untuk dieksekusi daripada menginterpretasikan ulang kode teks setiap saat.
    - **_Function Prototype_ (`Proto`)**: Setiap blok fungsi dalam kode Anda (baik `function nama() ... end` maupun `function() ... end`) dikompilasi menjadi sebuah struktur data internal yang disebut _prototype_ atau `Proto`. `Proto` ini adalah cetak biru (template) dari sebuah fungsi.
  - **Isi dari `Proto`**: Sebuah _prototype_ berisi semua informasi statis tentang sebuah fungsi, termasuk:
    - _Bytecode_ (instruksi-instruksi untuk dieksekusi).
    - Sebuah "kolam" konstanta (nilai-nilai seperti angka dan string yang digunakan oleh fungsi).
    - Informasi tentang jumlah parameter.
    - Informasi tentang variabel lokal.
    - Informasi tentang _upvalues_ (akan kita bahas selanjutnya).

- **Pentingnya Membedakan _Prototype_ dan _Closure_**:
  `Proto` adalah sebuah template. Ketika Lua mengeksekusi kode yang mendefinisikan sebuah fungsi, ia tidak langsung menggunakan `Proto` tersebut. Sebaliknya, ia membuat sebuah _instance_ baru yang disebut **_closure_**. _Closure_ inilah nilai aktual bertipe `function` yang Anda gunakan dalam program. Sebuah _closure_ pada dasarnya adalah pasangan dari:

  1.  Sebuah pointer ke `Proto` (cetak birunya).
  2.  Satu set referensi ke variabel-variabel di luar lingkupnya (disebut _upvalues_).

  Ini berarti, jika Anda mendefinisikan fungsi di dalam sebuah loop, Anda akan membuat beberapa _closure_ yang berbeda, tetapi semuanya akan berbagi `Proto` yang sama persis, sehingga sangat efisien dari segi memori.

- **Contoh Konseptual**:

  ```lua
  -- Tahap Kompilasi:
  -- Kode 'function tambah(a, b) return a + b end' diubah menjadi sebuah 'Proto'.
  -- Proto ini berisi bytecode seperti:
  -- 1. GETPARAM 0  (ambil parameter 'a')
  -- 2. GETPARAM 1  (ambil parameter 'b')
  -- 3. ADD         (jumlahkan keduanya)
  -- 4. RETURN      (kembalikan hasilnya)

  function tambah(a, b)
      return a + b
  end

  -- Tahap Runtime:
  -- Saat baris 'function tambah...' dieksekusi, Lua membuat sebuah 'closure'.
  -- Closure 'tambah' ini menunjuk ke 'Proto' yang dibuat tadi.
  local fungsiLain = tambah -- 'fungsiLain' sekarang menunjuk ke closure yang sama.

  print(type(tambah)) -- Output: function
  ```

- **Sumber**:
  - Buku PIL menjelaskan hubungan antara kompilasi, _bytecode_, dan fungsi.

---

#### **_Closures_, _Upvalues_, dan _Lexical Scoping Deep Dive_**

Ini adalah salah satu konsep paling kuat namun sering disalahpahami di Lua. Mari kita bedah satu per satu.

- **_Lexical Scoping_ (Lingkup Leksikal)**:

  - **Deskripsi**: _Lexical scoping_ (juga dikenal sebagai _static scoping_) berarti visibilitas sebuah variabel ditentukan oleh lokasinya di dalam kode sumber. Sebuah fungsi yang berada di dalam fungsi lain (fungsi bersarang) dapat "melihat" dan mengakses variabel lokal dari fungsi yang membungkusnya.
  - **Aturan Sederhana**: Ketika sebuah fungsi membutuhkan variabel, ia akan mencarinya dengan urutan berikut:
    1.  Di antara variabel lokalnya sendiri (termasuk parameter).
    2.  Jika tidak ditemukan, ia mencari di fungsi yang membungkusnya (lingkup luar).
    3.  Proses ini berlanjut ke lingkup yang lebih luar lagi, hingga mencapai lingkup global.

- **_Closure_**:

  - **Deskripsi**: Seperti yang disebutkan, setiap fungsi di Lua adalah sebuah _closure_. Sebuah _closure_ adalah sebuah fungsi yang "mengingat" lingkup leksikal tempat ia didefinisikan. Ia membawa "lingkungannya" (yaitu, variabel-variabel dari fungsi luarnya yang ia butuhkan) bersamanya, bahkan setelah fungsi luarnya selesai dieksekusi.

- **_Upvalue_**:

  - **Deskripsi**: _Upvalue_ adalah mekanisme di balik bagaimana _closure_ bekerja. Ketika sebuah fungsi dalam (inner) mereferensikan variabel lokal dari fungsi luar (outer), Lua membuat sebuah **_upvalue_**. _Upvalue_ ini adalah sebuah referensi yang "menjembatani" _closure_ dengan variabel lokal di lingkup luarnya.
  - **Siklus Hidup**: Ketika fungsi luar selesai dieksekusi, variabel lokalnya yang direferensikan oleh fungsi dalam (melalui _upvalue_) tidak akan dihancurkan. Sebaliknya, variabel tersebut "dipindahkan" dari _stack_ dan tetap hidup, terikat pada _closure_ tersebut. Variabel ini sekarang hanya bisa diakses melalui _closure_ itu.

- **Contoh Klasik: Pabrik Penghitung (_Counter Factory_)**
  Contoh ini dengan sempurna mendemonstrasikan ketiga konsep di atas.

  ```lua
  function buatPenghitung()
      -- 'i' adalah variabel lokal untuk buatPenghitung.
      local i = 0

      -- Fungsi anonim di bawah ini adalah sebuah closure.
      -- Ia akan "menutup" (close over) variabel 'i'.
      return function()
          -- Saat dipanggil, ia mengakses 'i' melalui sebuah upvalue.
          i = i + 1
          return i
      end
  end

  -- p1 adalah sebuah closure. Ia memiliki upvalue sendiri yang merujuk ke 'i' miliknya.
  local p1 = buatPenghitung()
  print("Penghitung 1:", p1()) -- Output: Penghitung 1: 1
  print("Penghitung 1:", p1()) -- Output: Penghitung 1: 2

  -- p2 adalah closure BARU. Ia juga memanggil buatPenghitung() dan
  -- mendapatkan variabel 'i' yang baru dan terpisah.
  local p2 = buatPenghitung()
  print("Penghitung 2:", p2()) -- Output: Penghitung 2: 1
  print("Penghitung 1:", p1()) -- Output: Penghitung 1: 3 (p1 tidak terpengaruh oleh p2)
  ```

  - **Penjelasan Kode**:
    1.  `function buatPenghitung()`: Ini adalah "pabrik" yang tugasnya membuat dan mengembalikan fungsi penghitung.
    2.  `local i = 0`: Setiap kali `buatPenghitung` dipanggil, ia membuat variabel lokal `i` yang baru, yang dimulai dari 0.
    3.  `return function() ... end`: Ini adalah inti dari _closure_. `buatPenghitung` mengembalikan sebuah fungsi baru (fungsi anonim). Fungsi ini tidak memiliki variabel lokal `i`, tetapi karena aturan _lexical scoping_, ia dapat melihat `i` dari `buatPenghitung`.
    4.  `i = i + 1`: Di dalam _closure_, `i` adalah sebuah **_upvalue_**. Setiap kali _closure_ ini dipanggil, ia memodifikasi `i` yang sama yang telah "ditangkapnya".
    5.  `local p1 = buatPenghitung()`: `p1` sekarang berisi sebuah _closure_ yang memiliki referensi ke sebuah `i` yang nilainya 0.
    6.  `p1()`: Memanggil _closure_ ini akan menambah `i` menjadi 1 dan mengembalikannya. Memanggilnya lagi akan menambah `i` yang sama menjadi 2, dan seterusnya. `i` ini tetap hidup meskipun `buatPenghitung` sudah selesai dieksekusi.
    7.  `local p2 = buatPenghitung()`: Ini membuat _closure_ **kedua** yang benar-benar terpisah. Ia memiliki referensi ke `i` yang **baru**, yang juga dimulai dari 0. Inilah sebabnya `p1` dan `p2` memiliki status penghitung yang independen.

- **Sumber**:
  - PIL memiliki dua bab yang didedikasikan untuk topik ini, menjelaskan _lexical scoping_ dan implementasi _closures_.

---

#### **Lingkungan Fungsi (_Function Environments_) dan `_ENV`**

- **Deskripsi**: Konsep "variabel global" di Lua sebenarnya adalah ilusi. Semua variabel yang tampaknya global sebenarnya adalah _field_ di dalam sebuah tabel khusus yang disebut **tabel lingkungan (_environment table_)**.
- **Sebelum Lua 5.2: `_G`**: Di Lua versi lama, hanya ada satu tabel lingkungan global untuk semua skrip, yang disimpan dalam variabel global `_G`. Mengakses variabel `x` sama dengan menulis `_G.x`.
- **Sejak Lua 5.2: `_ENV`**: Lua 5.2 memperkenalkan konsep yang lebih fleksibel: `_ENV`.

  - Setiap _closure_ sekarang memiliki **lingkungannya sendiri**. Lingkungan ini adalah tabel yang digunakan untuk mencari variabel bebas (variabel yang bukan lokal atau _upvalue_).
  - Secara default, lingkungan untuk setiap _closure_ adalah tabel global `_G`.
  - `_ENV` sendiri diimplementasikan sebagai _upvalue_ pertama yang "diwariskan" oleh sebuah _closure_ dari lingkungannya. Ini berarti Anda bisa mengubah lingkungan sebuah fungsi.

- **Penggunaan Utama: _Sandboxing_**:
  Kemampuan untuk mengatur `_ENV` per fungsi adalah alat yang sangat kuat untuk **_sandboxing_**—membatasi apa yang bisa diakses oleh sebuah potongan kode. Anda bisa memberikan sebuah fungsi lingkungan kosong atau lingkungan yang hanya berisi fungsi-fungsi "aman" yang Anda izinkan.

- **Contoh _Sandboxing_**:

  ```lua
  -- Kode tidak tepercaya yang ingin kita jalankan
  local kodeTidakTepercaya = [[
      -- Kode ini mencoba mengakses file sistem, yang berbahaya
      -- local f = io.open("rahasia.txt", "w")
      -- f:write("dihack!")
      -- f:close()

      -- Kode ini hanya boleh mengakses fungsi yang kita berikan
      cetakAman("Halo dari dalam sandbox!")
      local hasil = tambah(5, 10)
      cetakAman("Hasil penjumlahan: " .. hasil)
      -- cetakAman(io) -- Ini akan error karena 'io' tidak ada di lingkungan custom
  ]]

  -- 1. Buat lingkungan custom (sandbox)
  local envAman = {
      tambah = function(a, b) return a + b end,
      cetakAman = print -- Kita berikan akses ke fungsi 'print' tapi dengan nama lain
  }

  -- 2. Muat kode sebagai fungsi, tetapi belum dieksekusi
  local fungsiSandbox = load(kodeTidakTepercaya, "Kode_Aman", "t", envAman)
  -- Argumen ke-4 dari 'load' mengatur _ENV untuk fungsi yang baru dibuat.

  -- 3. Jalankan fungsi di dalam sandbox-nya
  if fungsiSandbox then
      local status, err = pcall(fungsiSandbox)
      if not status then
          print("Error dalam sandbox:", err)
      end
  else
      print("Gagal memuat kode.")
  end
  ```

  - **Penjelasan Sintaksis**:
    - `[[ ... ]]`: Kurung siku ganda digunakan untuk membuat string literal multi-baris. Sangat berguna untuk menampung blok kode.
    - `load(chunk, [chunkname], [mode], [env])`: Fungsi bawaan yang sangat kuat. Ia mengkompilasi sepotong kode Lua (`chunk`) menjadi sebuah fungsi (tanpa menjalankannya).
      - `chunk`: String yang berisi kode Lua.
      - `chunkname`: Nama untuk potongan kode, berguna untuk pesan error.
      - `mode`: Bisa `"t"` (teks), `"b"` (bytecode), atau `"bt"`.
      - `env`: Argumen kunci. Ini adalah tabel yang akan menjadi `_ENV` (lingkungan) untuk fungsi yang baru dibuat.
    - `pcall(f, ...)`: _Protected Call_. Ia memanggil fungsi `f` dengan aman. Jika ada error selama eksekusi `f`, `pcall` akan "menangkap" error tersebut dan tidak akan menghentikan seluruh program. Ia mengembalikan status (`true` jika berhasil, `false` jika error) dan nilai _return_ dari fungsi atau pesan error.

- **Sumber**:
  - PIL bab 14 adalah referensi utama untuk lingkungan.
  - Komunitas wiki memiliki banyak tutorial tentang `_ENV` dan _sandboxing_.

---

#### **Implementasi _Varargs_ dan Fungsi `select`**

- **_Varargs_ (Argumen Variabel)**:

  - **Deskripsi**: Lua memungkinkan Anda untuk membuat fungsi yang menerima jumlah argumen yang bervariasi. Ini didefinisikan dengan menempatkan `...` sebagai parameter terakhir dalam daftar parameter fungsi.
  - **Sintaks**: `function nama(param1, ...)`

- **Bekerja dengan `...`**:

  - Di dalam fungsi, `...` berperilaku seperti sebuah ekspresi yang menghasilkan semua argumen variabel tersebut secara berurutan.
  - Anda bisa meneruskannya langsung ke fungsi lain (`print(...)`).
  - Anda bisa mengemasnya ke dalam tabel: `local args = {...}`.

- **Fungsi `select`**:
  Membuat tabel hanya untuk menghitung atau mengakses satu argumen bisa jadi tidak efisien. Lua menyediakan fungsi `select` yang dioptimalkan untuk bekerja dengan daftar argumen variabel.

  - `select('#', ...)`: Mengembalikan **jumlah** argumen variabel. Tanda `#` adalah string literal. Ini jauh lebih efisien daripada `#{...}`.
  - `select(n, ...)`: Mengembalikan semua argumen **mulai dari posisi ke-`n`**.

- **Contoh Penggunaan**:

  ```lua
  function cetakSemua(...)
      -- Menghitung jumlah argumen dengan cara efisien
      local n = select('#', ...)
      print("Jumlah argumen yang diterima:", n)

      -- Mencetak semua argumen
      print("Argumen-argumennya adalah:")
      for i = 1, n do
          -- Memilih argumen ke-i
          local arg = select(i, ...)
          print(string.format("  Argumen %d: %s", i, tostring(arg)))
      end

      -- Mengambil semua argumen dari posisi ke-2 dan seterusnya
      local argumenSisa = { select(2, ...) }
      print("Argumen dari posisi ke-2:", table.concat(argumenSisa, ", "))
  end

  cetakSemua("halo", true, 123, {x=1})
  ```

  - **Penjelasan Kode**:
    1.  `function cetakSemua(...)`: Mendefinisikan fungsi yang menerima argumen variabel.
    2.  `local n = select('#', ...)`: Memanggil `select` dengan argumen pertama `'#'` untuk mendapatkan jumlah argumen dalam `...`.
    3.  `for i = 1, n do ... end`: Melakukan loop sebanyak jumlah argumen.
    4.  `local arg = select(i, ...)`: Di setiap iterasi, `select` dipanggil dengan indeks `i`. Ini mengembalikan argumen pada posisi ke-`i`. Karena kita hanya butuh yang pertama, sisanya diabaikan.
    5.  `local argumenSisa = { select(2, ...) }`: `select(2, ...)` akan menghasilkan semua argumen dari yang kedua hingga terakhir. Tanda kurung kurawal `{...}` mengemas hasil-hasil ini ke dalam sebuah tabel baru.

- **Sumber**:
  - PIL membahas _varargs_ secara detail.
  - Komunitas wiki memberikan wawasan lebih lanjut tentang penggunaannya.

---

#### **_Tail Call Optimization_ (TCO)**

- **Deskripsi**: TCO adalah fitur optimisasi penting yang memungkinkan Lua menjalankan jenis rekursi tertentu tanpa batas, tanpa menyebabkan _stack overflow_.

  - **_Tail Call_**: Sebuah _tail call_ adalah pemanggilan fungsi yang merupakan **aksi terakhir mutlak** dari sebuah fungsi. Tidak boleh ada lagi operasi setelah pemanggilan tersebut, bahkan operasi aritmetika sederhana sekalipun.
    - `return g(x)` **ADALAH** _tail call_.
    - `return g(x) + 1` **BUKAN** _tail call_ (karena ada operasi `+ 1` setelah `g(x)` kembali).
    - `g(x)` **BUKAN** _tail call_ (karena fungsi `f` masih harus melakukan `return` setelah `g(x)` selesai).

- **Cara Kerja TCO**:
  Ketika Lua mendeteksi sebuah _tail call_, ia tidak membuat _stack frame_ baru untuk fungsi yang dipanggil. Sebaliknya, ia **menggunakan kembali _stack frame_ dari fungsi saat ini**. Fungsi yang dipanggil secara efektif menggantikan fungsi pemanggil di _call stack_.

- **Manfaat**:
  Ini memungkinkan **rekursi tak terbatas** (selama pemanggilannya adalah _tail call_). Ini sangat berguna untuk mengimplementasikan algoritma seperti _state machine_ atau perulangan dalam gaya fungsional.

- **Contoh Perbandingan**:

  ```lua
  -- TANPA TCO (Akan Stack Overflow untuk n besar)
  function faktorial_buruk(n)
      if n == 0 then
          return 1
      else
          -- BUKAN tail call, karena ada perkalian setelah pemanggilan rekursif
          return n * faktorial_buruk(n - 1)
      end
  end

  -- DENGAN TCO (Aman untuk n besar)
  function faktorial_baik(n, acc)
      -- 'acc' (accumulator) adalah parameter untuk menyimpan hasil antara
      acc = acc or 1
      if n == 0 then
          return acc
      else
          -- INI ADALAH tail call! Tidak ada operasi setelah pemanggilan.
          return faktorial_baik(n - 1, n * acc)
      end
  end

  -- print(faktorial_buruk(20000)) -- Akan menyebabkan 'stack overflow'
  print(faktorial_baik(20000))   -- Akan berjalan dengan baik (meski hasilnya sangat besar dan menjadi 'inf')
  ```

  - **Penjelasan Kode**:
    1.  `faktorial_buruk`: Pada baris `return n * faktorial_buruk(...)`, setelah `faktorial_buruk` kembali dengan hasilnya, fungsi saat ini masih harus melakukan perkalian dengan `n`. Ini bukan aksi terakhir. Setiap panggilan menumpuk di _stack_.
    2.  `faktorial_baik`: Pada baris `return faktorial_baik(...)`, tidak ada lagi yang harus dilakukan. Nilai dari `n-1` dan `n * acc` dihitung **sebelum** pemanggilan. Hasil dari pemanggilan rekursif ini langsung dikembalikan oleh fungsi saat ini. _Stack frame_ dapat digunakan kembali.

- **Sumber**:
  - PIL menjelaskan TCO dengan sangat baik.
  - Komunitas wiki memberikan lebih banyak contoh tentang _proper tail recursion_.

Kita baru saja menyelesaikan bagian yang sangat mendalam tentang fungsi di Lua. Ini adalah fondasi untuk memahami pemrograman tingkat lanjut di Lua.

---

### **3.2 Tipe `table` - Penguasaan Tabel Secara Menyeluruh**

Tipe `table` adalah satu-satunya mekanisme struktur data yang disediakan oleh Lua. Fleksibilitasnya luar biasa; sebuah tabel dapat digunakan untuk merepresentasikan berbagai struktur data, termasuk:

- **_Arrays_ (Larik)**: Daftar elemen yang diindeks oleh angka (misalnya, 1, 2, 3, ...).
- **_Dictionaries_ (Kamus) atau _Maps_**: Koleksi pasangan kunci-nilai (key-value) yang tidak berurutan, di mana kuncinya bisa berupa string atau tipe data lain.
- **_Objects_ (Objek)**: Dengan menggunakan fungsi sebagai nilai, tabel dapat meniru objek dalam pemrograman berorientasi objek.
- **_Sets_, _Queues_, dan struktur data lainnya**.

Semua kekuatan ini berasal dari implementasi dasarnya sebagai _hash table_ yang sangat dioptimalkan.

#### **Implementasi _Hash Table_ Internal**

- **Deskripsi**: Di intinya, setiap tabel Lua adalah sebuah **_hash table_** (tabel hash) atau _associative array_ (larik asosiatif). Ini berarti ia menyimpan data dalam bentuk pasangan **kunci-nilai** (_key-value pairs_). Anda dapat menggunakan hampir semua nilai Lua (kecuali `nil` dan `NaN`) sebagai kunci untuk menyimpan nilai lain.
- **Terminologi**:

  - **_Hashing_**: Ketika Anda menyisipkan pasangan kunci-nilai (misalnya, `t["nama"] = "Andi"`), Lua mengambil kunci (`"nama"`) dan melewatkannya ke sebuah **fungsi hash**. Fungsi ini mengubah kunci menjadi sebuah angka (disebut **hash**) yang digunakan sebagai indeks untuk menentukan di mana nilai (`"Andi"`) harus disimpan dalam sebuah larik (array) internal. Proses ini memungkinkan pencarian, penyisipan, dan penghapusan nilai dengan waktu yang sangat cepat, rata-rata dalam waktu konstan (O(1)).
  - **_Collision_ (Tabrakan)**: Terkadang, dua kunci yang berbeda dapat menghasilkan nilai hash yang sama. Ini disebut _collision_. Lua secara otomatis menangani ini di belakang layar, biasanya dengan menggunakan teknik seperti _chaining_, di mana semua pasangan kunci-nilai yang bertabrakan diindeks yang sama akan dirangkai dalam sebuah _linked list_. Anda sebagai pemrogram tidak perlu khawatir tentang ini, tetapi ini adalah bagian dari cara kerja internalnya.

- **Contoh Penggunaan Berbagai Kunci**:

  ```lua
  local t = {}

  -- Kunci string (paling umum)
  t["nama"] = "Budi"
  t.umur = 30 -- Notasi titik adalah 'syntactic sugar' untuk kunci string

  -- Kunci number
  t[1] = "Elemen pertama"
  t[100] = "Elemen ke-100"

  -- Kunci boolean
  t[true] = "Ya"

  -- Tabel lain sebagai kunci
  local kunciTabel = {}
  t[kunciTabel] = "Nilai yang diasosiasikan dengan tabel"

  print(t.nama)             -- Output: Budi
  print(t[1])               -- Output: Elemen pertama
  print(t[true])            -- Output: Ya
  print(t[kunciTabel])      -- Output: Nilai yang diasosiasikan dengan tabel
  ```

  - **Penjelasan Sintaksis**:
    - `t = {}`: Membuat sebuah tabel kosong.
    - `t["nama"] = "Budi"`: Notasi kurung siku `[]` adalah cara umum untuk mengakses tabel. Ini bekerja untuk semua jenis kunci.
    - `t.umur = 30`: Notasi titik `.` adalah cara pintas yang lebih mudah dibaca, tetapi **hanya berfungsi untuk kunci yang merupakan string dan bukan _keyword_ Lua**. `t.umur` sama persis dengan `t["umur"]`.

- **Sumber**:
  - Manual Lua memberikan deskripsi umum tentang tabel.
  - PIL Bab 3 memberikan pengenalan yang sangat baik tentang tabel sebagai larik asosiatif.

---

#### **Optimisasi Bagian _Array_ vs Bagian _Hash_**

- **Deskripsi**: Untuk membuat operasi pada urutan seperti _array_ menjadi super cepat, Lua tidak mengimplementasikan tabel murni sebagai _hash table_ tunggal. Sebaliknya, secara internal, tabel adalah **struktur hibrida** yang terdiri dari dua bagian utama: sebuah **bagian _array_** dan sebuah **bagian _hash_**.

  - **Bagian _Array_ (_Array Part_)**: Ini adalah sebuah larik (array) C standar yang dioptimalkan untuk menyimpan nilai-nilai dengan kunci **integer positif berurutan** (1, 2, 3, 4, ...). Mengakses elemen di bagian ini secepat mengakses elemen array di C atau Java (indeks langsung), tanpa perlu _hashing_.
  - **Bagian _Hash_ (_Hash Part_)**: Bagian ini adalah _hash table_ tradisional dan digunakan untuk menyimpan semua pasangan kunci-nilai lainnya: kunci string, kunci numerik non-sekuensial atau non-positif, kunci berupa fungsi, tabel, dll.

- **Bagaimana Lua Memutuskan?**:
  Lua secara dinamis mengelola batas antara kedua bagian ini. Ketika Anda menambahkan elemen, Lua mungkin akan memutuskan untuk memindahkan elemen dari bagian _hash_ ke bagian _array_ (atau sebaliknya) untuk menjaga efisiensi. Proses ini disebut **_re-hashing_**, di mana Lua menganalisis kunci-kunci dan mengalokasikan ulang ukuran kedua bagian untuk mendapatkan performa terbaik.

- **Contoh Tabel Hibrida**:

  ```lua
  local t = {}
  t[1] = "a"       -- Masuk ke bagian array
  t[2] = "b"       -- Masuk ke bagian array
  t[3] = "c"       -- Masuk ke bagian array
  t["nama"] = "Hibrida" -- Masuk ke bagian hash
  t[10] = "d"      -- Mungkin masuk ke bagian hash karena urutan 'lompat' dari 3 ke 10
  t.isActive = true  -- Masuk ke bagian hash

  -- Akses ke t[1], t[2], t[3] sangat cepat.
  -- Akses ke t["nama"] atau t[10] melibatkan proses hashing.
  ```

- **Implikasi Performa**:

  - Untuk data yang bersifat seperti daftar atau urutan, selalu usahakan menggunakan kunci integer berurutan yang dimulai dari 1 (`t[1], t[2], ...`). Ini akan memanfaatkan bagian _array_ yang sangat cepat.
  - Mengetahui ukuran tabel sebelumnya dapat membantu. Jika Anda tahu sebuah tabel akan memiliki 1 juta elemen _array_, Anda bisa "pra-alokasi" (meski tidak ada fungsi langsung, membuat loop inisialisasi bisa membantu), yang dapat mengurangi jumlah _re-hash_ yang mahal.

- **Sumber**:
  - PIL membahas struktur hibrida tabel ini dan memberikan detail lebih lanjut tentang performa di bab selanjutnya.

---

#### **Penelusuran Tabel: `pairs()` vs `ipairs()` vs `next()`**

Lua menyediakan beberapa cara untuk melakukan iterasi (menelusuri) elemen-elemen dalam sebuah tabel. Pilihan yang tepat bergantung pada bagian tabel mana yang ingin Anda telusuri.

- **`ipairs(t)`**:

  - **Deskripsi**: `ipairs` adalah iterator yang dirancang khusus untuk menelusuri **bagian _array_** dari tabel `t`.
  - **Perilaku**: Ia mengiterasi pasangan indeks-nilai (`i`, `v`) mulai dari indeks `1`, berlanjut ke `2`, `3`, dan seterusnya, hingga ia menemukan **kunci integer pertama yang nilainya `nil`**. Setelah itu, ia berhenti.
  - **Jaminan**: `ipairs` menjamin urutan iterasi (1, 2, 3, ...).
  - **Penggunaan**: Gunakan `ipairs` ketika Anda memperlakukan tabel sebagai sebuah _array_ dan ingin memproses elemen-elemennya secara berurutan.

- **`pairs(t)`**:

  - **Deskripsi**: `pairs` adalah iterator umum yang menelusuri **semua** pasangan kunci-nilai dalam tabel `t`, baik yang ada di bagian _array_ maupun di bagian _hash_.
  - **Perilaku**: Ia akan melewati semua kunci yang nilainya tidak `nil`.
  - **Jaminan**: `pairs` **TIDAK memberikan jaminan urutan apa pun**. Urutan penelusuran bisa tampak acak dan dapat berubah saat elemen ditambahkan atau dihapus. Jangan pernah bergantung pada urutan dari `pairs`.
  - **Penggunaan**: Gunakan `pairs` ketika Anda memperlakukan tabel sebagai kamus (_dictionary_) atau _map_, di mana urutan tidak penting.

- **`next(t, [key])`**:

  - **Deskripsi**: `next` adalah fungsi iterator primitif. `pairs` sebenarnya dibangun di atas `next`.
  - **Perilaku**: `next(t, key)` mengembalikan pasangan kunci-nilai "berikutnya" setelah `key` dalam tabel `t`. Untuk memulai iterasi, Anda memanggil `next(t, nil)`. Ketika tidak ada lagi elemen, ia mengembalikan `nil`.
  - **Jaminan**: Sama seperti `pairs`, urutan penelusurannya tidak dijamin.

- **Contoh Perbandingan**:

  ```lua
  local t = {
      [1] = "apel",
      [2] = "pisang",
      [3] = "ceri",
      nama = "keranjang buah", -- bagian hash
      [5] = "mangga", -- 'lubang' di indeks 4
      pemilik = "Toko Buah Segar"  -- bagian hash
  }
  t[4] = nil -- Membuat 'lubang' secara eksplisit

  print("--- Iterasi dengan ipairs (berhenti di lubang) ---")
  for i, v in ipairs(t) do
      print(i, v)
      -- Output akan:
      -- 1   apel
      -- 2   pisang
      -- 3   ceri
      -- (Berhenti karena t[4] adalah nil)
  end

  print("\n--- Iterasi dengan pairs (semua elemen, tanpa urutan pasti) ---")
  for k, v in pairs(t) do
      print(k, v)
      -- Output akan mencakup SEMUA elemen (termasuk 'mangga' di indeks 5),
      -- tetapi urutannya tidak dijamin. Contoh output mungkin:
      -- 1   apel
      -- 2   pisang
      -- 3   ceri
      -- 5   mangga
      -- nama      keranjang buah
      -- pemilik   Toko Buah Segar
  end

  print("\n--- Iterasi manual dengan next ---")
  local k, v = next(t, nil) -- Ambil elemen pertama
  while k do
      print("Manual next:", k, v)
      k, v = next(t, k) -- Ambil elemen berikutnya
  end
  ```

- **Sumber**:
  - PIL Bab 7.1 memberikan penjelasan yang jelas tentang `pairs` dan `ipairs`.
  - Komunitas wiki memiliki tutorial tentang cara kerja iterator.

---

#### **Teknik Serialisasi Tabel dan _Deep Copy_**

- **Serialisasi (_Serialization_)**:

  - **Deskripsi**: Serialisasi adalah proses mengubah sebuah struktur data (seperti tabel Lua) menjadi format lain (biasanya string) yang dapat disimpan ke file, dikirim melalui jaringan, dan kemudian di-deserialisasi kembali menjadi tabel asli.
  - **Di Lua**: Lua tidak memiliki fungsi serialisasi bawaan. Anda harus menulisnya sendiri atau menggunakan pustaka pihak ketiga. Tantangannya adalah menangani berbagai tipe data, tabel bersarang, dan referensi siklik.
  - **Contoh Serializer Sederhana (Naive)**:

    ```lua
    function serialize(o)
        if type(o) == "number" or type(o) == "boolean" then
            return tostring(o)
        elseif type(o) == "string" then
            return string.format("%q", o) -- %q menambahkan kutip dan escape karakter
        elseif type(o) == "table" then
            local s = "{"
            for k,v in pairs(o) do
                s = s .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ","
            end
            return s .. "}"
        else
            error("Tidak dapat menserialisasi tipe: " .. type(o))
        end
    end

    local myTable = { name = "test", data = { 1, 2 } }
    local serializedString = serialize(myTable)
    print(serializedString) -- Output: {[serialize("name")]=serialize("test"),[serialize("data")]=serialize({[serialize(1)]=serialize(1),[serialize(2)]=serialize(2),}),} (demonstrasi konsep)
    ```

    _Peringatan_: Serializer di atas sangat sederhana dan akan gagal pada tabel siklik, fungsi, dan userdata.

- **_Deep Copy_ (Salinan Mendalam)**:

  - **Deskripsi**: Menyalin sebuah tabel (`t2 = t1`) hanya menyalin referensi, bukan isinya. `t1` dan `t2` akan menunjuk ke tabel yang sama. _Deep copy_ berarti membuat tabel baru dan secara rekursif menyalin semua isinya, termasuk menyalin tabel-tabel yang bersarang di dalamnya.
  - **Tantangan Utama**: Referensi siklik. Jika `t.self = t`, salinan rekursif yang naif akan masuk ke dalam perulangan tak terbatas.
  - **Solusi**: Gunakan tabel pelacak (_tracking table_) untuk menyimpan catatan tabel yang sudah disalin.

- **Contoh Fungsi _Deep Copy_ dengan Penanganan Siklus**:

  ```lua
  function deepcopy(orig, copies)
      copies = copies or {}
      if type(orig) ~= 'table' then return orig end
      if copies[orig] then return copies[orig] end

      local copy = {}
      copies[orig] = copy

      for k, v in pairs(orig) do
          copy[deepcopy(k, copies)] = deepcopy(v, copies)
      end

      return copy
  end

  -- Contoh penggunaan
  local t1 = { a = 1, b = { x = 10, y = 20 } }
  t1.c = t1.b -- Referensi ke tabel yang sama
  t1.d = t1   -- Referensi siklik

  local t2 = deepcopy(t1)

  print(t1.b == t2.b) -- Output: false (tabel b telah disalin, bukan referensi yang sama)
  print(t2.c == t2.b) -- Output: true (struktur internal dipertahankan, t2.c dan t2.b merujuk ke tabel salinan yang sama)
  print(t2.d == t2)   -- Output: true (referensi siklik direproduksi dengan benar)
  ```

  - **Penjelasan Kode**:
    1.  `copies = copies or {}`: Tabel `copies` digunakan untuk melacak `tabel asli -> salinannya`.
    2.  `if copies[orig] then return copies[orig] end`: Ini adalah bagian krusial. Sebelum menyalin sebuah tabel, kita periksa apakah kita sudah pernah menyalinnya. Jika ya, kita kembalikan salinan yang sudah ada untuk menghindari perulangan tak terbatas.
    3.  `copies[orig] = copy`: Setelah membuat tabel salinan baru (`copy`), kita langsung mencatatnya di tabel `copies` sebelum melanjutkan rekursi.
    4.  `for k, v in pairs(orig) do ... end`: Loop ini melakukan iterasi pada tabel asli dan memanggil `deepcopy` secara rekursif untuk kunci dan nilainya.

- **Sumber**:
  - Komunitas wiki memiliki halaman yang didedikasikan untuk serialisasi dan penyalinan tabel.

---

#### **Tata Letak Memori dan Kinerja _Cache_**

- **Deskripsi**: Ini adalah topik optimisasi tingkat lanjut. Kinerja program tidak hanya bergantung pada algoritma, tetapi juga pada bagaimana data disusun di memori. CPU modern tidak membaca data langsung dari RAM utama; mereka menggunakan beberapa tingkat **_cache_**—memori super cepat yang kecil—untuk menyimpan data yang baru saja digunakan.
  - **_Cache Hit_ vs _Cache Miss_**: Jika data yang dibutuhkan CPU sudah ada di _cache_ (sebuah _cache hit_), aksesnya sangat cepat. Jika tidak (sebuah _cache miss_), CPU harus berhenti dan menunggu data diambil dari RAM yang jauh lebih lambat.
- **Prinsip Kelokalan (_Principle of Locality_)**:
  Program cenderung menunjukkan dua jenis kelokalan, yang dieksploitasi oleh _cache_:
  1.  **_Temporal Locality_ (Kelokalan Temporal)**: Jika Anda mengakses suatu data, kemungkinan besar Anda akan mengaksesnya lagi dalam waktu dekat.
  2.  **_Spatial Locality_ (Kelokalan Spasial)**: Jika Anda mengakses suatu data, kemungkinan besar Anda akan mengakses data lain yang lokasinya berdekatan di memori.
- **Implikasi untuk Tabel Lua**:

  - **Bagian _Array_ Sangat Ramah _Cache_**: Elemen-elemen di bagian _array_ sebuah tabel Lua disimpan secara berurutan (kontigu) di memori. Saat CPU mengambil `t[1]`, ia juga akan membawa `t[2]`, `t[3]`, `t[4]`, dll., ke dalam _cache_ pada saat yang sama (karena _spatial locality_). Oleh karena itu, melakukan iterasi pada bagian _array_ dengan `ipairs` sangat cepat karena hampir semua akses akan menjadi _cache hit_.
  - **Bagian _Hash_ Kurang Ramah _Cache_**: Elemen-elemen di bagian _hash_ tersebar di memori berdasarkan nilai hash kuncinya. Melakukan iterasi pada bagian ini dengan `pairs` dapat menyebabkan banyak _cache miss_ karena CPU harus melompat-lompat ke lokasi memori yang berbeda, yang secara signifikan lebih lambat.

- **Tips Optimisasi**:

  - Untuk data tabular atau daftar yang memerlukan pemrosesan berkecepatan tinggi (misalnya, posisi partikel, data game), **selalu prioritaskan penggunaan bagian _array_ dari tabel**.
  - Pikirkan tentang pola akses data Anda. Mengatur data Anda agar dapat diproses secara sekuensial seringkali memberikan peningkatan kinerja yang dramatis.

- **Sumber**:
  - Dokumen "Lua Performance Gems" memberikan wawasan mendalam tentang optimisasi.
  - Halaman tips optimisasi di komunitas wiki juga sangat berharga.

Kita telah menyelesaikan pembahasan mendalam tentang `table`. Ini adalah tipe data yang akan Anda gunakan terus-menerus. Selanjutnya adalah **"4. Tipe Data Lanjutan - Expert Level"**, dimulai dengan **"4.1 Tipe `userdata` - Complete Guide"**.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

<!----------------------------------------------------->

[0]: ../README.md#3-tipe-data-kompleks---advanced
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
