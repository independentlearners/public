# **[11. Konkurensi dan Paralelisme][0]**

Meskipun Lua tidak memiliki dukungan bawaan untuk paralelisme sejati (menjalankan beberapa tugas secara serentak pada beberapa inti CPU), model _coroutine_-nya menyediakan fondasi yang sangat kuat untuk **konkurensi**. Penting untuk memahami perbedaan antara kedua konsep ini.

- **Konkurensi (_Concurrency_)**: Adalah tentang menangani **banyak tugas sekaligus**, tetapi tidak harus menjalankannya pada saat yang bersamaan. Ini adalah tentang menstrukturkan program Anda sehingga dapat beralih di antara tugas-tugas yang berbeda tanpa menunggu satu tugas selesai sepenuhnya. _Coroutine_ adalah alat utama Lua untuk konkurensi.
- **Paralelisme (_Parallelism_)**: Adalah tentang menjalankan **banyak tugas secara bersamaan**, biasanya dengan memanfaatkan beberapa inti prosesor. Paralelisme sejati di Lua hanya dapat dicapai dengan menggunakan pustaka pihak ketiga yang berinteraksi dengan _thread_ sistem operasi.

### **11.1 Pola Konkurensi Berbasis _Coroutine_**

_Coroutines_ memungkinkan Anda untuk menulis kode yang melakukan operasi yang memakan waktu (seperti menunggu I/O jaringan atau membaca file besar) tanpa memblokir seluruh program.

#### **_Event Loop_ dan _Scheduler_**

Pola yang paling umum untuk konkurensi di Lua adalah dengan menggunakan sebuah **_event loop_** (atau _scheduler_).

- **Deskripsi**: _Scheduler_ adalah sebuah fungsi atau loop utama yang tugasnya mengelola sekumpulan _coroutines_. Ia me-_resume_ satu _coroutine_, membiarkannya berjalan hingga ia melakukan `yield`, dan kemudian beralih ke _coroutine_ berikutnya.
- **_Yielding_ pada Operasi I/O**: Ketika sebuah _coroutine_ perlu melakukan operasi yang memakan waktu (misalnya, mengunduh data dari web), ia tidak menunggu secara pasif. Sebaliknya, ia akan memulai operasi non-blokir dan kemudian melakukan `yield`, mengembalikan kontrol ke _scheduler_. _Scheduler_ kemudian dapat menjalankan _coroutine_ lain. Ketika operasi I/O selesai, _scheduler_ akan diberitahu (misalnya, melalui _callback_ atau _polling_) dan akan me-_resume_ _coroutine_ yang asli dengan hasilnya.

- **Contoh Konseptual _Scheduler_ Sederhana**:

  ```lua
  local tasks = {} -- Daftar coroutine yang akan dijalankan

  -- Fungsi untuk menambahkan tugas baru ke scheduler
  function addTask(func)
      local co = coroutine.create(func)
      table.insert(tasks, co)
  end

  -- Scheduler utama
  function runScheduler()
      while #tasks > 0 do
          for i = #tasks, 1, -1 do -- Loop dari belakang agar aman saat menghapus
              local co = tasks[i]
              local status, err = coroutine.resume(co)
              if not status then -- Jika ada error
                  print("Error dalam coroutine:", err)
                  table.remove(tasks, i) -- Hapus dari scheduler
              elseif coroutine.status(co) == "dead" then
                  table.remove(tasks, i) -- Hapus jika sudah selesai
              end
          end
          -- Di scheduler nyata, akan ada jeda kecil di sini atau menunggu I/O
      end
      print("Semua tugas selesai.")
  end

  -- Definisikan beberapa tugas
  addTask(function()
      for i = 1, 3 do
          print("Tugas A, langkah", i)
          coroutine.yield() -- Serahkan kontrol
      end
      print("Tugas A selesai.")
  end)

  addTask(function()
      for i = 1, 2 do
          print("Tugas B, langkah", i)
          coroutine.yield() -- Serahkan kontrol
      end
      print("Tugas B selesai.")
  end)

  runScheduler()
  ```

  **Output akan menunjukkan tugas A dan B berjalan secara bersisipan.**

### **11.2 _OS-level Threading_ vs. _Coroutines_**

| Fitur               | _Coroutines_ (Konkurensi Kooperatif)                                                                                               | _OS Threads_ (Paralelisme Preemptif)                                                                                                                             |
| :------------------ | :--------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Penjadwalan**     | **Kooperatif**: Sebuah _coroutine_ hanya berhenti berjalan jika ia secara eksplisit memanggil `yield()`.                           | **Preemptif**: Sistem Operasi dapat menghentikan (_preempt_) sebuah _thread_ kapan saja untuk memberikan giliran pada _thread_ lain.                             |
| **Paralelisme**     | **Tidak ada paralelisme sejati**. Hanya satu _coroutine_ yang berjalan pada satu waktu per _thread_ OS.                            | **Paralelisme sejati**. Beberapa _thread_ dapat berjalan secara bersamaan pada beberapa inti CPU.                                                                |
| **Berbagi Data**    | **Aman secara default**. Karena hanya satu yang berjalan pada satu waktu, tidak ada _race condition_ saat mengakses data bersama.  | **Berbahaya**. Memerlukan mekanisme sinkronisasi yang kompleks (seperti _mutex_, _semaphores_) untuk mencegah _race condition_.                                  |
| **Biaya (_Cost_)**  | **Sangat ringan**. Membuat _coroutine_ sangat murah dan cepat. Anda bisa memiliki ribuan _coroutines_ tanpa masalah.               | **Berat**. Membuat _thread_ OS relatif mahal dan memakan sumber daya sistem. Jumlah _thread_ biasanya terbatas.                                                  |
| **Kapan Digunakan** | Ideal untuk konkurensi tingkat tinggi, terutama untuk tugas yang terikat I/O (_I/O-bound_), seperti server jaringan, game, dan UI. | Dibutuhkan untuk tugas yang terikat CPU (_CPU-bound_) yang dapat dipecah menjadi bagian-bagian yang benar-benar independen untuk memanfaatkan beberapa inti CPU. |

- **Pustaka untuk _Threading_ di Lua**: Untuk mendapatkan paralelisme sejati, Anda perlu menggunakan pustaka pihak ketiga seperti `lua-llthreads2` atau `lanes` yang menyediakan _binding_ ke _thread_ sistem operasi.

---

## **12. Pola Desain Sistem Tipe**

Bagian ini membahas pola-pola tingkat tinggi untuk bekerja dengan tipe data secara lebih terstruktur dan aman, melampaui penggunaan dasar `type()` dan metatable.

### **12.1 Penandaan Tipe (_Type Tagging_) dan _Dispatch_**

- **Deskripsi**: Ini adalah sebuah pola di mana Anda secara eksplisit menambahkan sebuah _field_ (biasanya bernama `type` atau `kind`) ke dalam tabel Anda untuk menandai "jenis" dari objek tersebut. Ini dapat digunakan sebagai alternatif atau pelengkap dari pemeriksaan metatable.
- **_Function Dispatch_**: Anda kemudian dapat menggunakan _field_ ini untuk melakukan _dispatch_, yaitu memilih fungsi yang benar untuk menangani objek tersebut.

- **Contoh**:

  ```lua
  function createCircle(radius)
      return { type = "circle", radius = radius }
  end

  function createRectangle(width, height)
      return { type = "rectangle", width = width, height = height }
  end

  -- Fungsi dispatch yang menghitung luas
  function calculateArea(shape)
      if shape.type == "circle" then
          return math.pi * shape.radius^2
      elseif shape.type == "rectangle" then
          return shape.width * shape.height
      else
          error("Tipe bentuk tidak dikenal: " .. tostring(shape.type))
      end
  end

  local c = createCircle(10)
  local r = createRectangle(5, 4)

  print("Luas Lingkaran:", calculateArea(c))
  print("Luas Persegi Panjang:", calculateArea(r))
  ```

  Pola ini sangat umum dalam bahasa dengan pengetikan dinamis dan sangat mudah untuk di-debug.

### **12.2 Tipe Data Abstrak (_Abstract Data Types_ - ADT)**

- **Deskripsi**: ADT adalah model matematis untuk tipe data di mana perilaku didefinisikan oleh sekumpulan nilai dan sekumpulan operasi, tanpa mengungkapkan implementasi internalnya. Di Lua, ini berarti membuat "objek" yang representasi internalnya tersembunyi, dan interaksi hanya terjadi melalui API publik (sekumpulan fungsi).
- **Implementasi**: Pola _closure_ untuk privasi (yang kita bahas di bagian OOP) adalah cara sempurna untuk mengimplementasikan ADT.

- **Contoh (ADT untuk _Stack_)**:

  ```lua
  function createStack()
      -- 'elements' adalah representasi internal yang tersembunyi.
      local elements = {}

      -- 'api' adalah tabel yang berisi operasi publik.
      local api = {}

      function api:push(value)
          table.insert(elements, value)
      end

      function api:pop()
          if #elements == 0 then error("Stack kosong") end
          return table.remove(elements)
      end

      function api:size()
          return #elements
      end

      -- Hanya kembalikan API publik. Tidak ada cara untuk mengakses 'elements'
      -- secara langsung dari luar.
      return api
  end

  local myStack = createStack()
  myStack:push(10)
  myStack:push(20)
  print("Ukuran stack:", myStack:size()) -- Output: 2
  print("Pop:", myStack:pop())           -- Output: 20
  print("Pop:", myStack:pop())           -- Output: 10
  -- myStack:pop() -- Akan error: Stack kosong
  ```

---

## **13. Penanganan _Error_ dan Keamanan Tipe**

Menulis kode yang kuat berarti mengantisipasi dan menangani kondisi _error_ dengan baik, termasuk saat data yang diterima tidak memiliki tipe yang diharapkan.

### **13.1 Propagasi _Error_ Tingkat Lanjut**

- **Objek _Error_**: Daripada hanya melempar pesan string dengan `error("pesan")`, praktik yang lebih baik untuk aplikasi besar adalah melempar **objek _error_** (tabel). Ini memungkinkan Anda untuk menyertakan informasi yang jauh lebih kaya, seperti kode _error_, _stack trace_, dan konteks tambahan.
- **Contoh**:

  ```lua
  function doSomethingRisky(input)
      if type(input) ~= "number" then
          -- Lempar objek error
          error({
              code = "INVALID_ARGUMENT",
              message = "Input harus berupa angka",
              offending_value = input
          })
      end
      return input * 2
  end

  local status, err_obj = pcall(doSomethingRisky, "halo")

  if not status then
      print("Terjadi error!")
      print("  Kode: " .. err_obj.code)
      print("  Pesan: " .. err_obj.message)
      print("  Nilai Penyebab: " .. tostring(err_obj.offending_value))
  end
  ```

### **13.2 Asersi Tipe dan Pustaka Validasi**

- **Asersi (_Assertion_)**: Fungsi `assert(condition, message)` adalah alat pertahanan lini pertama Anda. Ia memeriksa apakah `condition` benar. Jika tidak, ia akan melempar _error_ dengan `message` yang diberikan. Menggunakannya di awal fungsi untuk memvalidasi tipe argumen adalah praktik yang sangat baik (dikenal sebagai _Design by Contract_).
  ```lua
  function setPosition(x, y)
      assert(type(x) == "number", "Argumen #1 'x' harus berupa angka")
      assert(type(y) == "number", "Argumen #2 'y' harus berupa angka")
      -- ...
  end
  ```
- **Pustaka Validasi**: Untuk validasi yang lebih kompleks (misalnya, memeriksa struktur tabel atau rentang nilai), menggunakan pustaka pihak ketiga seperti `busted` (untuk testing) atau pustaka validasi skema khusus dapat sangat membantu.

---

## **14. _Testing_ dan _Quality Assurance_**

Memastikan kode Anda berfungsi seperti yang diharapkan dan tetap berfungsi saat Anda melakukan perubahan adalah sangat penting.

### **14.1 Strategi _Testing_ Sadar-Tipe**

- **_Unit Testing_ dengan Asersi Tipe**: Saat menulis _unit test_ (menggunakan _framework_ seperti Busted atau Testy), selain memeriksa hasil yang benar, sertakan juga tes yang secara eksplisit memeriksa bahwa fungsi Anda menangani tipe argumen yang salah dengan benar (misalnya, dengan melempar _error_ yang diharapkan).

- **_Property-Based Testing_**: Ini adalah teknik _testing_ tingkat lanjut di mana Anda tidak menulis tes untuk input spesifik, tetapi Anda mendefinisikan **properti** atau **invarian** yang harus selalu benar untuk tipe data Anda, apa pun inputnya. _Framework_ seperti `lua-quickcheck` kemudian akan secara otomatis menghasilkan ratusan input acak untuk mencoba mematahkan properti tersebut.

### **14.2 Alat Analisis Statis**

- **_Linters_ dan _Type Checkers_**: Karena Lua memiliki pengetikan dinamis, banyak _error_ tipe hanya ditemukan saat _runtime_. Alat analisis statis mencoba menemukan potensi masalah ini dengan menganalisis kode sumber Anda **sebelum** dijalankan.
  - **`luacheck`**: _Linter_ paling populer untuk Lua. Ia dapat mendeteksi variabel yang tidak terdefinisi, kode yang tidak terjangkau, dan banyak masalah gaya lainnya.
  - **_Dialects_ dengan Tipe**: Untuk keamanan tipe yang lebih kuat, Anda dapat menggunakan _dialect_ Lua yang menambahkan sintaks anotasi tipe, seperti **Teal** atau bahasa **Luau** (yang digunakan oleh Roblox). _Compiler_ untuk bahasa-bahasa ini kemudian dapat memeriksa ketidakcocokan tipe saat kompilasi.

---

## **15. Pola Integrasi Tingkat Lanjut**

### **15.1 Integrasi C/C++**

- **_Binding_ Struktur Data Kompleks**: Saat berinteraksi dengan pustaka C/C++ yang kompleks, Anda seringkali perlu melakukan lebih dari sekadar mengekspos beberapa fungsi. Anda mungkin perlu membuat _binding_ untuk struktur data yang saling terkait, yang mungkin berisi _pointer_, _union_, atau _bitfields_. Ini memerlukan pemahaman yang mendalam tentang C API Lua (atau FFI LuaJIT) untuk memastikan bahwa manajemen memori (`__gc`), konversi tipe, dan penanganan _error_ dilakukan dengan benar di seluruh batas bahasa.

### **15.2 Integrasi _Database_**

- **Pemetaan Tipe dengan _Database_ SQL**: Saat bekerja dengan _database_, tantangan utamanya adalah memetakan antara tipe data Lua dan tipe data SQL (misalnya, `TEXT`, `INTEGER`, `REAL`, `BLOB`). Pustaka _database_ Lua (seperti `LuaSQL` atau `lsqlite3`) menyediakan API untuk mengeksekusi kueri dan mengambil hasil. Anda harus cermat dalam menangani nilai `NULL` dari SQL (yang biasanya dipetakan ke `nil` di Lua) dan memastikan bahwa data yang Anda kirim ke _database_ memiliki tipe yang benar atau dikonversi dengan tepat untuk menghindari _SQL injection_ dan _error_ tipe data.

---

Selesai! Kita telah berhasil membahas seluruh kurikulum komprehensif ini dari awal hingga akhir.

### Selamat !

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-10/README.md
[selanjutnya]: ../bagian-12/README.md

<!----------------------------------------------------->

[0]: ../README.md#
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
