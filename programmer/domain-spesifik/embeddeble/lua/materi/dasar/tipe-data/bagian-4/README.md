# **[4. Tipe Data Lanjutan - _Expert Level_][0]**

Bagian ini akan membahas tipe-tipe data yang menjadi jembatan antara Lua dan sistem lain, dimulai dengan `userdata`, yang merupakan kunci untuk integrasi dengan C/C++. Pada level ini, kita akan membahas tipe data yang memungkinkan Lua untuk melakukan hal-hal yang melampaui scripting murni, seperti mengelola data dari bahasa C, menjalankan beberapa alur eksekusi secara bersamaan (kooperatif), dan berinteraksi secara mendalam dengan _host application_.

### **4.1 Tipe `userdata` - Panduan Lengkap**

- **Deskripsi**: Tipe `userdata` adalah tipe data Lua yang paling unik. Ia memungkinkan Anda untuk menyimpan data C mentah (seperti _pointer_ atau _struct_) di dalam variabel Lua. Dari sudut pandang skrip Lua, `userdata` adalah sebuah "kotak hitam" (_black box_); Anda tidak bisa memodifikasi isinya secara langsung dari Lua. Kegunaan utamanya adalah untuk memungkinkan kode C (program _host_) mengekspos objek atau datanya ke Lua, sehingga skrip Lua dapat memanipulasi data dari program _host_ tersebut. Perilaku `userdata` di dalam Lua hampir seluruhnya ditentukan oleh **metatables** yang diatur dari sisi C.

- **API (Application Programming Interface)**: Sebelum kita melangkah lebih jauh, penting untuk memahami istilah **API**. Dalam konteks ini, **Lua C API** adalah sekumpulan fungsi C yang disediakan oleh pustaka Lua. Fungsi-fungsi ini memungkinkan program yang ditulis dalam C atau C++ untuk "berbicara" dengan interpreter Lua: membuat state Lua, memuat dan menjalankan skrip, mendorong data ke Lua, memanggil fungsi Lua, dan mengambil data dari Lua. `Userdata` adalah salah satu mekanisme utama yang digunakan dalam interaksi ini.

#### **Arsitektur _Light Userdata_ vs _Full Userdata_**

Lua menyediakan dua jenis `userdata`, masing-masing dengan tujuan dan karakteristik yang berbeda.

- **_Light Userdata_**:

  - **Apa itu?**: _Light userdata_ pada dasarnya adalah sebuah pembungkus (_wrapper_) untuk _pointer_ C mentah (`void*`). Ia tidak lebih dari sebuah nilai yang menyimpan alamat memori.
  - **Karakteristik**:
    - **Hanya Nilai**: Ia adalah nilai, bukan objek. Dua _light userdata_ yang menunjuk ke alamat yang sama akan dianggap sama oleh Lua (`==`).
    - **Tidak Punya Metatable Individual**: Anda tidak bisa memberikan _metatable_ yang unik untuk setiap _light userdata_. Semua _light userdata_ berbagi satu _metatable_ per-tipe di dalam _registry_ Lua (jika diatur).
    - **Tidak Dikelola oleh Garbage Collector (GC)**: Ini adalah poin paling penting. Lua tidak mengelola memori yang ditunjuk oleh _light userdata_. Pemrogram C yang membuat _pointer_ tersebut **sepenuhnya bertanggung jawab** untuk mengalokasikan dan membebaskan memori tersebut. Jika C membebaskan memori sementara Lua masih memegang _light userdata_ ke sana, ini akan menjadi _dangling pointer_ yang berbahaya.
  - **Kapan Digunakan?**: Ideal untuk merepresentasikan _handle_ atau _pointer_ sederhana yang siklus hidupnya dikelola di luar Lua, atau ketika Anda perlu melewatkan _pointer_ C bolak-balik antara fungsi C melalui Lua.

- **_Full Userdata_**:
  - **Apa itu?**: _Full userdata_ adalah sebuah blok memori mentah yang **dialokasikan oleh Lua itu sendiri** atas permintaan dari C. Ini bukan hanya sebuah _pointer_, tetapi sebuah objek memori yang sebenarnya.
  - **Karakteristik**:
    - **Objek**: Setiap _full userdata_ adalah objek yang unik. Dua _full userdata_ yang dibuat secara terpisah tidak akan pernah sama (`==`), bahkan jika isinya identik.
    - **Punya Metatable Individual**: Anda dapat (dan seharusnya) memberikan _metatable_ yang unik untuk setiap _full userdata_. Inilah yang memberinya perilaku seperti objek di Lua (metode, operator, dll.).
    - **Dikelola oleh Garbage Collector (GC) Lua**: Ini adalah keuntungan utamanya. Ketika tidak ada lagi referensi ke sebuah _full userdata_ dari sisi Lua, _garbage collector_ Lua akan secara otomatis membebaskan blok memori yang dialokasikannya. Anda juga bisa menentukan sebuah _finalizer_ (`__gc` metamethod) untuk melakukan pembersihan tambahan.
  - **Kapan Digunakan?**: Ideal untuk merepresentasikan objek atau struktur data C/C++ yang siklus hidupnya ingin Anda serahkan kepada Lua. Ini adalah cara paling umum dan aman untuk mengekspos objek kompleks ke Lua.

---

#### **Integrasi _Metatable Userdata_**

Kekuatan sebenarnya dari `userdata` (khususnya _full userdata_) datang dari kemampuannya untuk diintegrasikan dengan sistem _metatable_ Lua. Ini memungkinkan Anda untuk mendefinisikan perilaku `userdata` dan membuatnya terasa seperti objek Lua asli.

- **Bagaimana Cara Kerjanya?**:
  Dari sisi C, setelah Anda membuat _full userdata_, Anda membuat atau mengambil sebuah _metatable_ (yang merupakan tabel Lua biasa) dan mengaturnya sebagai _metatable_ untuk _userdata_ tersebut. _Metatable_ ini biasanya berisi _field-field_ yang nilainya adalah fungsi-fungsi C.

- **Meniru Objek dengan `__index`**:
  _Metamethod_ yang paling penting untuk meniru objek adalah `__index`. Ketika skrip Lua mencoba mengakses sebuah _field_ dari `userdata` (misalnya, `my_vec:length()`), Lua akan melihat bahwa _field_ `length` tidak ada di dalam data mentah `userdata` itu sendiri. Kemudian, ia akan memeriksa _metatable_ dari `userdata` tersebut:

  1.  Jika `metatable.__index` adalah sebuah fungsi, Lua akan memanggil fungsi tersebut.
  2.  Jika `metatable.__index` adalah sebuah tabel, Lua akan mencari _field_ `length` di dalam tabel `__index` tersebut.

  Pola yang paling umum adalah mengatur `metatable.__index = metatable`, sehingga metode-metode dapat dicari di dalam _metatable_ itu sendiri.

- **Contoh Konseptual (Objek Vektor 2D)**:
  Bayangkan kita membuat tipe `Vector` di C dan ingin mengeksposnya ke Lua.

  **Di sisi C (Konsep):**

  1.  Buat _metatable_ bernama `"MyLib.Vector"`.
  2.  Isi _metatable_ ini dengan fungsi-fungsi C:
      - `metatable["add"] = c_vector_add`
      - `metatable["length"] = c_vector_length`
      - `metatable["__tostring"] = c_vector_tostring`
  3.  Set `metatable.__index = metatable`.
  4.  Saat membuat `Vector` baru, buat _full userdata_ dan pasangkan dengan _metatable_ ini.

  **Di sisi Lua:**

  ```lua
  -- new_vector adalah fungsi C yang membuat userdata Vector baru.
  local v1 = MyLib.new_vector(3, 4)
  local v2 = MyLib.new_vector(1, 2)

  -- Lua melihat v1:add, tidak menemukan 'add' di userdata,
  -- lalu mencari di metatable.__index dan menemukan fungsi C untuk 'add'.
  local v3 = v1:add(v2)

  -- Lua melihat print(v3), memanggil __tostring dari metatable.
  print(v3) -- Output mungkin: Vector(4, 6)

  -- Lua mencari 'length' di metatable dan memanggil fungsi C-nya.
  print("Panjang v3:", v3:length()) -- Output mungkin: Panjang v3: 7.21...
  ```

- **Sumber**:
  - PIL Bab 28.2 memberikan penjelasan yang sangat baik tentang bagaimana _metatables_ memberikan kehidupan pada `userdata`.
  - Komunitas wiki menyediakan contoh-contoh praktis.

---

#### **Integrasi C API: `lua_newuserdatauv()` dan `lua_touserdata()`**

Ini adalah dua fungsi C API fundamental untuk bekerja dengan `userdata`. Kode berikut adalah C, bukan Lua, dan menunjukkan bagaimana program _host_ berinteraksi dengan Lua.

- **`lua_newuserdatauv(lua_State *L, size_t size, int nuvalue)`**:

  - **Tujuan**: Fungsi ini digunakan di C untuk membuat _full userdata_ baru.
  - **Cara Kerja**:

    1.  `size_t size`: Menentukan berapa bita memori yang harus dialokasikan oleh Lua untuk `userdata` ini (misalnya, `sizeof(MyVectorStruct)`).
    2.  `int nuvalue`: Jumlah "nilai pengguna" Lua yang terkait dengannya (fitur lanjutan, seringkali 1 untuk metatable).
    3.  Fungsi ini mengalokasikan memori, mendorong _full userdata_ yang baru ke atas _stack_ Lua, dan mengembalikan sebuah `void*` pointer ke blok memori yang baru dialokasikan.
    4.  Kode C kemudian dapat menggunakan pointer ini untuk menginisialisasi data di dalamnya.

  - **Contoh Konseptual C**:

    ```c
    // Ini adalah kode C
    typedef struct { double x; double y; } Vector;

    static int new_vector(lua_State *L) {
        // Ambil argumen x dan y dari stack Lua
        double x = luaL_checknumber(L, 1);
        double y = luaL_checknumber(L, 2);

        // Buat userdata baru dengan ukuran struct Vector
        // dan 1 user value (untuk metatable)
        Vector *p = (Vector *)lua_newuserdatauv(L, sizeof(Vector), 1);

        // Set metatable untuk userdata yang baru dibuat
        luaL_setmetatable(L, "MyLib.Vector");

        // Inisialisasi data di dalam userdata
        p->x = x;
        p->y = y;

        return 1; // Kembalikan userdata yang ada di puncak stack ke Lua
    }
    ```

- **`lua_touserdata(lua_State *L, int index)`**:

  - **Tujuan**: Fungsi ini digunakan di C untuk mendapatkan kembali pointer `void*` dari `userdata` yang ada di _stack_ Lua.
  - **Cara Kerja**:
    1.  `int index`: Menentukan posisi `userdata` di _stack_ Lua.
    2.  Fungsi ini mengembalikan pointer ke data mentah. Jika nilai di `index` bukan _userdata_ (atau _light userdata_), ia mengembalikan `NULL`.
  - **Penting**: Sebelum menggunakan pointer yang dikembalikan, kode C yang baik harus memverifikasi bahwa `userdata` tersebut adalah tipe yang benar, biasanya dengan memeriksa apakah _metatable_-nya cocok dengan yang diharapkan. Ini mencegah C mencoba mengoperasikan data yang salah.

  - **Contoh Konseptual C**:

    ```c
    // Ini adalah kode C
    static int vector_add(lua_State *L) {
        // Periksa dan ambil userdata pertama (self)
        Vector *v1 = (Vector *)luaL_checkudata(L, 1, "MyLib.Vector");
        // Periksa dan ambil userdata kedua
        Vector *v2 = (Vector *)luaL_checkudata(L, 2, "MyLib.Vector");

        // Buat userdata baru untuk hasil
        Vector *result = (Vector *)lua_newuserdatauv(L, sizeof(Vector), 1);
        luaL_setmetatable(L, "MyLib.Vector");

        // Lakukan operasi
        result->x = v1->x + v2->x;
        result->y = v1->y + v2->y;

        return 1; // Kembalikan userdata hasil
    }
    ```

    _`luaL_checkudata` adalah makro pembantu yang melakukan `lua_touserdata` dan pemeriksaan *metatable* dalam satu langkah._

- **Sumber**:
  - Manual Lua adalah referensi utama untuk semua fungsi C API.
  - Tutorial C API di komunitas wiki sangat membantu untuk pemula.

---

#### **Manajemen Memori untuk _Userdata_**

Manajemen memori adalah aspek kritis saat menjembatani C dan Lua.

- **_Light Userdata_**: Tanggung jawab ada pada **pemrogram C**. Lua tidak tahu apa-apa tentang memori yang ditunjuk. Anda harus memastikan memori tidak dibebaskan selama Lua masih mungkin menggunakannya.

- **_Full Userdata_**: Tanggung jawab utama ada pada **Garbage Collector (GC) Lua**. Lua akan membebaskan blok memori utama yang dialokasikan oleh `lua_newuserdatauv` ketika `userdata` tersebut tidak lagi dapat dijangkau dari skrip Lua.

- **_Metamethod_ `__gc`**:

  - **Deskripsi**: Ini adalah _finalizer_ atau _destructor_ untuk _userdata_. Anda dapat menambahkan _metamethod_ `__gc` ke _metatable_ sebuah _full userdata_.
  - **Kapan Dipanggil?**: Tepat **sebelum** GC Lua akan membebaskan memori _userdata_, ia akan memeriksa apakah ada `__gc` _metamethod_. Jika ada, Lua akan memanggilnya dengan `userdata` itu sendiri sebagai argumen.
  - **Penggunaan**: `__gc` adalah tempat Anda melakukan pembersihan khusus. Misalnya, jika struktur C di dalam `userdata` Anda berisi _pointer_ ke memori lain yang Anda `malloc`, atau memegang _handle_ file yang perlu ditutup, atau merupakan pointer ke objek C++ yang perlu di-`delete`, fungsi `__gc` adalah tempat yang tepat dan aman untuk melakukan operasi pembersihan tersebut.

- **Contoh Konseptual `__gc`**:
  **Di Sisi C:**

  ```c
  // Anggaplah Vector kita sekarang berisi pointer ke data yang dialokasikan secara manual
  typedef struct { double *coords; } DynamicVector;

  // Fungsi 'new' akan melakukan malloc
  static int new_dyn_vector(lua_State *L) {
      DynamicVector *dv = (DynamicVector *)lua_newuserdatauv(L, sizeof(DynamicVector), 1);
      dv->coords = malloc(2 * sizeof(double)); // Alokasi manual
      // ... inisialisasi dan set metatable ...
      return 1;
  }

  // Fungsi __gc akan melakukan free
  static int dyn_vector_gc(lua_State *L) {
      DynamicVector *dv = (DynamicVector *)luaL_checkudata(L, 1, "MyLib.DynVector");
      printf("GC dipanggil untuk DynVector, membebaskan coords...\n");
      free(dv->coords); // Membersihkan memori yang dialokasikan secara manual
      return 0;
  }

  // Saat mendaftarkan metatable
  // luaL_newmetatable(L, "MyLib.DynVector");
  // lua_pushstring(L, "__gc");
  // lua_pushcfunction(L, dyn_vector_gc);
  // lua_settable(L, -3);
  // ...
  ```

  **Di Sisi Lua:**

  ```lua
  local v = MyLib.new_dyn_vector()
  -- ... gunakan v ...

  v = nil -- Hapus satu-satunya referensi ke userdata
  collectgarbage() -- Paksa GC berjalan (hanya untuk demonstrasi)
  -- Output di konsol C akan menunjukkan:
  -- "GC dipanggil untuk DynVector, membebaskan coords..."
  ```

- **Sumber**:
  - PIL Bab 28.3 membahas manajemen sumber daya dengan `__gc`.
  - Komunitas wiki memberikan contoh tentang `userdata` dengan _pointer_.

Kita telah membahas `userdata`, jembatan antara Lua dan C. Selanjutnya, kita akan membahas tipe `thread`, yang merupakan dasar dari _coroutines_ dan konkurensi kooperatif di Lua.

### **4.2 Tipe `thread` - Penguasaan _Coroutine_**

Meskipun tipenya bernama `thread`, penting untuk dipahami bahwa ini **bukanlah _OS thread_** (seperti _pthreads_ atau _Windows threads_). Sebuah nilai bertipe `thread` di Lua merepresentasikan sebuah **_coroutine_**.

- **Deskripsi _Coroutine_**: _Coroutine_ adalah sebuah alur eksekusi (seperti fungsi) yang dapat dihentikan (_paused_ atau _suspended_) di tengah jalan dan kemudian dilanjutkan kembali (_resumed_) dari titik di mana ia berhenti, sambil tetap mempertahankan status internalnya (variabel lokal, dll.). Ini memungkinkan **_cooperative multitasking_**, di mana berbagai _coroutine_ secara sukarela menyerahkan (_yield_) kontrol eksekusi satu sama lain, berbeda dengan _preemptive multitasking_ pada _OS threads_ di mana sistem operasi dapat menginterupsi sebuah _thread_ kapan saja.

#### **Mesin Status Internal _Coroutine_ (_Internal State Machine_)**

Setiap _coroutine_ pada dasarnya adalah sebuah mesin status (_state machine_). Ia selalu berada dalam salah satu dari beberapa status yang mungkin, yang dapat Anda periksa menggunakan fungsi `coroutine.status(co)`.

- **Status-Status _Coroutine_**:

  1.  **`"running"`**: _Coroutine_ sedang aktif dieksekusi. Hanya ada satu _coroutine_ yang bisa berada dalam status `"running"` pada satu waktu (yaitu, _coroutine_ utama atau yang sedang di-_resume_).
  2.  **`"suspended"`**: _Coroutine_ sedang dihentikan. Ini bisa jadi karena ia baru saja dibuat dan belum pernah dijalankan, atau karena ia telah memanggil `coroutine.yield()`. Ini adalah status "istirahat" yang paling umum untuk sebuah _coroutine_.
  3.  **`"normal"`**: Ini adalah status yang sedikit lebih jarang. Sebuah _coroutine_ berada dalam status ini jika ia telah me-_resume_ _coroutine_ lain dan sedang menunggu _coroutine_ kedua tersebut untuk selesai atau melakukan _yield_. Ini terjadi saat Anda merangkai pemanggilan _coroutine_.
  4.  **`"dead"`**: _Coroutine_ telah menyelesaikan eksekusinya (baik dengan mencapai `end` dari fungsinya, `return`, atau karena terjadi _error_ yang tidak ditangani). _Coroutine_ yang sudah `"dead"` tidak dapat di-_resume_ lagi.

- **Contoh Memeriksa Status**:

  ```lua
  local co = coroutine.create(function()
      print("Coroutine berjalan...")
      coroutine.yield()
      print("Coroutine selesai.")
  end)

  print("Status awal:", coroutine.status(co)) -- Output: Status awal: suspended

  coroutine.resume(co)
  print("Status setelah yield:", coroutine.status(co)) -- Output: Status setelah yield: suspended

  coroutine.resume(co)
  print("Status setelah selesai:", coroutine.status(co)) -- Output: Status setelah selesai: dead
  ```

#### **`yield`, `resume`, dan Manajemen Status**

Ini adalah tiga pilar utama dalam bekerja dengan _coroutines_.

- **`coroutine.create(f)`**:

  - **Tujuan**: Membuat _coroutine_ baru.
  - **Sintaks**: Menerima sebuah fungsi `f` sebagai argumennya. Ia tidak menjalankan fungsi `f`, tetapi mengemasnya ke dalam sebuah objek `thread` baru dan mengembalikannya. _Coroutine_ yang baru dibuat ini berada dalam status **`"suspended"`**.

- **`coroutine.resume(co, ...)`**:

  - **Tujuan**: Memulai atau melanjutkan eksekusi _coroutine_ `co`.
  - **Sintaks**: Menerima _coroutine_ sebagai argumen pertama, diikuti oleh argumen-argumen lain yang akan dilewatkan ke dalam _coroutine_.
  - **Nilai Kembali**: `resume` mengembalikan beberapa nilai:
    1.  Nilai pertama adalah **boolean status**: `true` jika eksekusi berjalan tanpa _error_, `false` jika terjadi _error_.
    2.  Nilai-nilai berikutnya bergantung pada status:
        - Jika `true`: Nilai-nilai tersebut adalah argumen yang dilewatkan ke `coroutine.yield()` dari dalam _coroutine_.
        - Jika `false`: Nilai kedua adalah pesan _error_ atau objek _error_.

- **`coroutine.yield(...)`**:

  - **Tujuan**: Menghentikan _coroutine_ yang sedang berjalan dan mengembalikan kontrol ke fungsi yang me-_resume_-nya.
  - **Sintaks**: Hanya bisa dipanggil dari dalam sebuah _coroutine_. Argumen yang dilewatkan ke `yield` akan menjadi nilai kembali dari pemanggilan `coroutine.resume` yang sesuai.
  - **Nilai Kembali**: Ketika _coroutine_ di-_resume_ kembali, nilai-nilai yang dilewatkan ke `coroutine.resume` akan menjadi nilai kembali dari pemanggilan `coroutine.yield`.

- **Contoh Komunikasi Dua Arah**:

  ```lua
  local co = coroutine.create(function(pesanAwal)
      print("Coroutine menerima:", pesanAwal) -- Menerima dari resume pertama

      local pesanDariResume = coroutine.yield("Kirim pesan ke pemanggil") -- Yield, mengirim "Kirim..."
      print("Coroutine menerima lagi:", pesanDariResume) -- Menerima dari resume kedua

      return "Selesai!", "Sukses!" -- Nilai kembali saat coroutine selesai
  end)

  print("Memulai coroutine...")
  -- resume pertama: mengirim "Halo Dunia"
  local status, pesanDariYield = coroutine.resume(co, "Halo Dunia")
  print(string.format("Status: %s, Pesan dari Yield: '%s'", status, pesanDariYield))

  print("\nMelanjutkan coroutine...")
  -- resume kedua: mengirim 42
  local statusFinal, hasil1, hasil2 = coroutine.resume(co, 42)
  print(string.format("Status: %s, Hasil: '%s', '%s'", statusFinal, hasil1, hasil2))

  -- Mencoba resume lagi
  local statusMati, err = coroutine.resume(co)
  print(string.format("\nStatus setelah mati: %s, Error: %s", statusMati, err))
  ```

  **Output:**

  ```
  Memulai coroutine...
  Coroutine menerima: Halo Dunia
  Status: true, Pesan dari Yield: 'Kirim pesan ke pemanggil'

  Melanjutkan coroutine...
  Coroutine menerima lagi: 42
  Status: true, Hasil: 'Selesai!', 'Sukses!'

  Status setelah mati: false, Error: cannot resume dead coroutine
  ```

  - **Penjelasan Alur**:
    1.  `coroutine.create` membuat `co` dalam keadaan _suspended_.
    2.  `resume(co, "Halo Dunia")` memulai `co`. `"Halo Dunia"` menjadi `pesanAwal`. `co` berjalan hingga `yield`, mengirim `"Kirim..."`. `resume` pertama selesai, mengembalikan `true` dan `"Kirim..."`.
    3.  `co` sekarang kembali _suspended_.
    4.  `resume(co, 42)` melanjutkan `co`. Nilai `42` menjadi nilai kembali dari `yield`. `co` berjalan hingga selesai, mengembalikan `"Selesai!"` dan `"Sukses!"`. `resume` kedua selesai, mengembalikan `true` dan kedua hasil tersebut.
    5.  `co` sekarang _dead_. `resume(co)` berikutnya gagal.

---

#### **Pola Komunikasi _Coroutine_**

_Coroutines_ memungkinkan pola-pola yang elegan untuk masalah-masalah seperti generator, _asynchronous I/O_, dan lainnya.

- **Pola Generator/Iterator**:
  Ini adalah salah satu penggunaan paling umum. Sebuah _coroutine_ digunakan untuk menghasilkan serangkaian nilai satu per satu, dan kita membungkusnya dalam sebuah fungsi untuk membuatnya bekerja seperti iterator dalam `for` loop.

  ```lua
  -- Fungsi ini adalah 'pabrik' iterator
  function angkaGanjil(maks)
      local co = coroutine.create(function()
          for i = 1, maks, 2 do
              coroutine.yield(i)
          end
      end)

      -- Kembalikan fungsi yang akan me-resume coroutine setiap kali dipanggil
      return function()
          local status, nilai = coroutine.resume(co)
          if status then
              return nilai
          else
              return nil -- Berhenti jika coroutine mati
          end
      end
  end

  print("Angka ganjil hingga 10:")
  -- Gunakan iterator dalam for loop
  for angka in angkaGanjil(10) do
      print(angka)
  end
  ```

  **Output:**

  ```
  Angka ganjil hingga 10:
  1
  3
  5
  7
  9
  ```

  - **Penjelasan Kode**:
    1.  `angkaGanjil(10)` tidak langsung menjalankan loop. Ia membuat _coroutine_ dan mengembalikan sebuah fungsi anonim (iterator).
    2.  Loop `for` memanggil fungsi iterator ini berulang kali.
    3.  Setiap panggilan ke iterator akan me-_resume_ _coroutine_.
    4.  _Coroutine_ akan berjalan hingga `yield(i)`, mengembalikan nilai ganjil berikutnya.
    5.  Nilai ini kemudian menjadi variabel `angka` dalam loop `for`.
    6.  Ketika _coroutine_ selesai (loop internalnya berakhir), `resume` berikutnya akan mengembalikan `status` `false`, dan iterator mengembalikan `nil`, yang menghentikan loop `for`.

- **Sumber**:
  - PIL Bab 9.3 membahas pola-pola seperti producer-consumer.
  - Komunitas wiki memiliki banyak tutorial tentang berbagai penggunaan _coroutines_.

---

#### **Penanganan _Error_ dalam _Coroutines_**

Penanganan _error_ dalam _coroutines_ berbeda dari fungsi biasa. _Error_ tidak "menyebar" ke atas di _call stack_ secara otomatis.

- **Batas _Error_**: Pemanggilan `coroutine.resume` berfungsi sebagai batas penanganan _error_, mirip seperti blok `try-catch` atau `pcall`. Jika terjadi _error_ di dalam _coroutine_, eksekusi _coroutine_ akan berhenti, dan `coroutine.resume` akan segera kembali.

  - `coroutine.resume` akan mengembalikan `false` sebagai status, diikuti dengan pesan _error_.
  - _Coroutine_ yang mengalami _error_ akan masuk ke status `dead`.

- **Contoh Penanganan _Error_**:

  ```lua
  local co = coroutine.create(function()
      print("Coroutine berjalan baik...")
      error("Sesuatu yang buruk terjadi!", 0) -- '0' menghapus info debugging dari pesan error
      print("Baris ini tidak akan pernah tercapai.")
  end)

  print("Mencoba me-resume coroutine yang akan error...")
  local status, pesanError = coroutine.resume(co)

  if not status then
      print("Gagal me-resume coroutine!")
      print("Pesan Error:", pesanError)
  end

  print("Status coroutine sekarang:", coroutine.status(co)) -- Output: dead
  ```

  **Output:**

  ```
  Mencoba me-resume coroutine yang akan error...
  Coroutine berjalan baik...
  Gagal me-resume coroutine!
  Pesan Error: Sesuatu yang buruk terjadi!
  Status coroutine sekarang: dead
  ```

- **`coroutine.wrap`**:

  - **Tujuan**: Menyediakan cara alternatif yang lebih sederhana untuk membuat dan menggunakan _coroutine_, terutama untuk pola iterator.
  - **Sintaks**: `coroutine.wrap(f)` menerima sebuah fungsi dan mengembalikan fungsi baru.
  - **Perilaku**: Setiap kali Anda memanggil fungsi yang dikembalikan, ia akan me-_resume_ _coroutine_. Nilai yang di-_yield_ akan dikembalikan langsung.
  - **Perbedaan Penanganan _Error_**: Jika terjadi _error_ di dalam _coroutine_ yang di-_wrap_, _error_ tersebut akan **disebarkan** ke pemanggil, sama seperti _error_ pada fungsi biasa. Ini berarti Anda bisa menangkapnya dengan `pcall`.

- **Contoh `coroutine.wrap`**:

  ```lua
  local f = coroutine.wrap(function()
      print("wrap: berjalan")
      coroutine.yield(1)
      error("oops")
  end)

  -- Penggunaan biasa
  print(f()) -- Output: wrap: berjalan, lalu 1

  -- Panggilan berikutnya akan menyebarkan error
  local status, err = pcall(f)
  if not status then
      print("pcall menangkap error dari wrap:", err)
  end
  ```

- **Kapan Menggunakan Mana?**:

  - Gunakan **`coroutine.create`/`resume`** ketika Anda membutuhkan kontrol penuh, terutama ketika pemanggil dan _coroutine_ perlu berkomunikasi dua arah atau ketika Anda perlu mengelola status _coroutine_ secara eksplisit.
  - Gunakan **`coroutine.wrap`** untuk kasus yang lebih sederhana seperti membuat iterator, di mana Anda hanya ingin mengambil nilai yang dihasilkan dan ingin penanganan _error_-nya terintegrasi dengan `pcall` secara alami.

- **Sumber**:
  - PIL Bab 9.4 membahas penanganan _error_.
  - Komunitas wiki memiliki halaman umum tentang penanganan _error_ yang relevan.

Kita telah menyelesaikan bagian Tipe Data Lanjutan. Anda sekarang memiliki pemahaman tentang bagaimana Lua berinteraksi dengan kode C (`userdata`) dan bagaimana ia menangani konkurensi (`thread`/`coroutine`).

#

Kurikulum selanjutnya adalah **"5. Sistem Metatable - _Complete Mastery_"**. Ini adalah topik yang sangat penting yang menyatukan banyak konsep yang telah kita bahas.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

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
