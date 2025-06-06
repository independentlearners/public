# **[Bagian IV: Advanced Chunk Techniques (Teknik Chunk Tingkat Lanjut)][0]**

Bagian ini akan mengajarkan Anda cara mengamankan eksekusi chunk, mengelola memorinya secara efisien, dan bahkan membuat kode secara dinamis saat program berjalan.

#### **9. Sandboxing dan Security (Keamanan dan Isolasi)**

_Sandboxing_ adalah teknik mengisolasi sebuah chunk kode, membatasi apa yang bisa ia lihat dan lakukan untuk mencegah perilaku berbahaya atau tidak diinginkan. Ini sangat penting jika Anda menjalankan kode dari sumber yang tidak tepercaya, seperti plugin atau skrip buatan pengguna. Fondasinya adalah manajemen lingkungan (`_ENV`) yang telah kita bahas di Bagian III.

##### **9.1 Security Model Design (Desain Model Keamanan)**

- **Deskripsi Konkret:**
  Sebelum menulis kode sandboxing, Anda harus berpikir seperti seorang peretas. Desain model keamanan adalah tentang perencanaan proaktif. Anda harus mengidentifikasi potensi ancaman dan mendefinisikan aturan keamanan yang ketat untuk sistem Anda.

- **Terminologi dan Konsep:**

  - **Threat Modeling (Pemodelan Ancaman):** Proses mengidentifikasi potensi ancaman. Pertanyaannya adalah: "Apa hal terburuk yang bisa dilakukan oleh chunk kode ini?" Contoh: menghapus file, mencuri data, membuat program crash, menggunakan CPU 100% tanpa henti.
  - **Attack Surface Analysis (Analisis Area Serangan):** Proses mengidentifikasi semua titik di mana chunk yang tidak tepercaya dapat berinteraksi dengan sistem Anda. Setiap fungsi yang Anda sediakan di dalam `_ENV` adalah bagian dari _attack surface_. Semakin sedikit fungsi yang Anda berikan, semakin kecil area serangan Anda.

- **Contoh Proses Berpikir:**
  1.  **Aset:** Data pengguna yang sensitif.
  2.  **Ancaman:** Skrip plugin mencoba membaca data ini dan mengirimkannya ke internet.
  3.  **Area Serangan:** Fungsi `io.open` (untuk membaca file) dan `socket.connect` (untuk koneksi jaringan).
  4.  **Strategi Pertahanan:** Buat `_ENV` kustom yang tidak menyertakan modul `io` dan `socket`.

##### **9.2 Resource Limitation (Pembatasan Sumber Daya)**

- **Deskripsi Konkret:**
  Selain membatasi fungsi apa yang bisa dipanggil, sandbox yang baik juga harus membatasi _berapa banyak_ sumber daya yang bisa digunakan, seperti waktu CPU, memori, dan akses I/O.

- **Teknik dan Contoh:**

  - **CPU Time Limitations (Pembatasan Waktu CPU):** Mencegah _infinite loops_. Ini dapat dicapai dengan menggunakan _debug hooks_. Hook ini adalah fungsi yang dipanggil oleh Lua VM setiap beberapa instruksi.

    ```lua
    local start_time = os.clock()
    local max_execution_time = 0.5 -- detik

    -- Fungsi hook ini akan dipanggil setiap 1000 instruksi
    local function cpu_limiter_hook()
      if os.clock() - start_time > max_execution_time then
        error("Waktu eksekusi skrip melebihi batas!")
      end
    end

    local untrusted_code = "while true do end"
    local func = load(untrusted_code, nil, "t", {})

    -- Atur hook untuk thread/coroutine yang akan menjalankan kode
    debug.sethook(func, cpu_limiter_hook, "", 1000)

    local status, err = pcall(func)
    print("Eksekusi selesai. Status:", status, "Pesan:", err)
    -- Output: Eksekusi selesai. Status: false Pesan: ...Waktu eksekusi skrip melebihi batas!
    ```

  - **Memory Usage Controls (Kontrol Penggunaan Memori):** Mencegah skrip menggunakan semua memori sistem. Cara paling efektif adalah melalui C API dengan mengganti fungsi alokasi memori default Lua. Dari sisi Lua murni, cara terbaik adalah dengan tidak menyediakan fungsi yang dapat membuat objek besar secara tidak terkendali (misalnya, membaca file besar ke dalam string).

  - **I/O and Network Access Restrictions (Pembatasan Akses I/O dan Jaringan):** Ini adalah aplikasi paling umum dari sandboxing `_ENV`. Cukup dengan tidak menyertakan modul `io` dan `socket` (atau modul jaringan kustom lainnya) di dalam lingkungan yang Anda sediakan.

##### **9.3 Capability-based Security (Keamanan Berbasis Kemampuan)**

- **Deskripsi Konkret:**
  Ini adalah model keamanan yang lebih canggih dan fleksibel daripada sekadar "ya" atau "tidak". Alih-alih memberikan akses ke seluruh modul (seperti `io`), Anda memberikan "kemampuan" (capability) spesifik dalam bentuk fungsi yang sudah dikonfigurasi. Kemampuan ini seperti token atau tiket sekali pakai.

- **Terminologi dan Konsep:**

  - **Capability/Token:** Sebuah objek (biasanya fungsi atau tabel) yang memberikan hak untuk melakukan operasi yang sangat spesifik.
  - **Permission Delegation:** Skrip yang memiliki sebuah kemampuan dapat memberikan kemampuan tersebut (atau versi yang lebih terbatas) kepada skrip lain.

- **Contoh:**
  Bayangkan Anda ingin skrip pengguna bisa menulis ke _satu file log tertentu saja_, dan tidak ke file lain.

  ```lua
  -- Di kode utama Anda (yang tepercaya)
  local function create_logger_for(plugin_name)
    -- Objek 'kemampuan'
    local logger_capability = {}
    local log_file_path = "/var/logs/" .. plugin_name .. ".log"

    function logger_capability.write(message)
      -- Fungsi ini memiliki akses ke 'io' karena ia didefinisikan
      -- di lingkup tepercaya. 'io' adalah upvalue-nya.
      local f = io.open(log_file_path, "a")
      if f then
        f:write(os.date() .. ": " .. message .. "\n")
        f:close()
      end
    end
    return logger_capability
  end

  -- Sekarang, berikan kemampuan ini ke skrip yang tidak tepercaya
  local user_script = "logger.write('Plugin berhasil dimuat!')"
  local sandbox_env = {
    -- Skrip pengguna hanya menerima objek 'logger'.
    -- Ia tidak pernah melihat 'io', 'os', atau path file.
    logger = create_logger_for("user_plugin_A")
  }

  local user_func = load(user_script, nil, "t", sandbox_env)
  pcall(user_func)
  ```

  Dalam contoh ini, `logger_capability` adalah token yang memberikan hak untuk menulis ke satu file spesifik. Skrip pengguna tidak dapat menyalahgunakannya untuk menulis ke `/etc/passwd` karena ia tidak memiliki akses ke `io.open`.

---

#### **10. Memory Management dan Garbage Collection (Manajemen Memori dan GC)**

Setiap chunk yang Anda muat, setiap fungsi yang Anda buat, dan setiap tabel yang Anda gunakan, semuanya memakan memori. Lua mengelola memori ini secara otomatis menggunakan _Garbage Collector_ (GC).

##### **10.1 Chunk Memory Lifecycle (Siklus Hidup Memori Chunk)**

- **Deskripsi Konkret:**
  Sebuah chunk, setelah dimuat, menjadi sebuah _objek fungsi_ (closure) di dalam memori Lua. Ia akan tetap ada di memori selama masih ada referensi yang "hidup" menunjuk ke sana.

- **Siklus Hidup:**
  1.  **Alokasi:** Memori dialokasikan saat Anda memanggil `load`, `loadstring`, atau `loadfile`. Proses ini menciptakan prototipe fungsi, konstanta, dan instruksi bytecode di memori.
  2.  **Referensi:** Hasil dari `load` adalah sebuah fungsi. Selama Anda menyimpan fungsi ini dalam sebuah variabel, ia dianggap "direferensikan" dan tidak akan dihapus.
      ```lua
      local my_chunk = load("print('hello')") -- 1. Alokasi. 'my_chunk' memegang referensi.
      my_chunk() -- Memori masih digunakan.
      my_chunk = nil -- 3. Referensi dihilangkan.
      ```
  3.  **Koleksi (Collection):** Setelah tidak ada lagi variabel yang menunjuk ke fungsi chunk tersebut, GC bebas untuk menghapusnya dari memori dan menggunakan kembali ruang tersebut.

##### **10.2 GC Interaction dengan Chunks (Interaksi GC dengan Chunk)**

- **Deskripsi Konkret:**
  GC Lua adalah sebuah proses yang berjalan di latar belakang (secara bertahap/incremental) untuk menemukan dan menghapus objek yang tidak lagi dapat dijangkau dari kode Anda.

- **Terminologi dan Konsep:**

  - **Garbage Collector (GC):** Sistem otomatis untuk reklamasi memori.
  - **Root Set:** Titik awal pencarian GC. Ini termasuk tabel global (`_G`), registri Lua, dan stack C.
  - **Reachability (Keterjangkauan):** Jika sebuah objek dapat dicapai dengan mengikuti rantai referensi dari _root set_, maka objek tersebut "hidup". Objek yang tidak dapat dijangkau adalah "sampah" (garbage).
  - **Weak Tables:** Tabel khusus di mana referensi ke kunci atau nilai (atau keduanya) tidak dihitung oleh GC. Jika satu-satunya referensi ke sebuah chunk disimpan di dalam _weak table_, chunk tersebut dapat dikumpulkan oleh GC. Ini berguna untuk membuat cache.

- **Contoh Weak Table untuk Cache Chunk:**

  ```lua
  -- Cache untuk menyimpan chunk yang sudah dikompilasi
  -- Mode "v" berarti nilai dalam tabel ini adalah 'weak'.
  local chunk_cache = {}
  setmetatable(chunk_cache, {__mode = "v"})

  function get_chunk(script_path)
    if chunk_cache[script_path] then
      return chunk_cache[script_path] -- Ambil dari cache jika ada
    else
      local func = assert(loadfile(script_path))
      chunk_cache[script_path] = func -- Simpan di cache
      return func
    end
  end

  -- Setelah Anda memanggil get_chunk dan tidak lagi menyimpan hasilnya
  -- di tempat lain, GC bebas untuk menghapus chunk dari cache.
  ```

##### **10.3 Memory Profiling dan Optimization (Profil dan Optimasi Memori)**

- **Deskripsi Konkret:**
  _Profiling_ adalah proses mengukur dan menganalisis penggunaan memori aplikasi Anda untuk menemukan area yang boros atau mengalami kebocoran memori.

- **Teknik dan Alat:**
  - **`collectgarbage("count")`**: Fungsi bawaan yang mengembalikan total memori yang digunakan oleh Lua dalam kilobyte. Anda bisa memanggilnya secara berkala untuk memantau pertumbuhan memori.
  - **Memory Leak Detection (Deteksi Kebocoran Memori):** Kebocoran memori di Lua terjadi ketika Anda secara tidak sengaja menyimpan referensi ke objek yang seharusnya sudah tidak digunakan lagi, seringkali dalam tabel global. Cara mendeteksinya adalah dengan memantau `collectgarbage("count")`—jika terus meningkat tanpa batas, kemungkinan ada kebocoran.
  - **Profiling Tools:** Ada alat pihak ketiga yang dapat memberikan laporan detail tentang alokasi objek, atau Anda bisa menggunakan C API untuk mengganti fungsi alokasi memori Lua dan mencatat setiap alokasi yang terjadi.

---

#### **11. Dynamic Code Generation (Pembuatan Kode Dinamis)**

Ini adalah teknik metaprogramming di mana program Anda membuat program lain (dalam bentuk string kode Lua) dan kemudian mengeksekusinya.

##### **11.1 Runtime Code Construction (Konstruksi Kode saat Runtime)**

- **Deskripsi Konkret:**
  Anda dapat membuat string yang berisi kode Lua yang valid berdasarkan input, status, atau konfigurasi saat ini, lalu menggunakan `load()` untuk mengubah string tersebut menjadi fungsi yang dapat dieksekusi.

- **Pola dan Contoh:**

  - **Template-based Generation:** Membuat fungsi "spesialis" yang sangat cepat untuk tugas tertentu.

    ```lua
    -- Bayangkan Anda perlu mengevaluasi formula matematika dari pengguna
    function create_formula_evaluator(formula_string)
      -- Contoh: formula_string adalah "x^2 + y/2"
      local code_string = "return function(x, y) return " .. formula_string .. " end"
      -- Hasilnya: "return function(x, y) return x^2 + y/2 end"

      local func, err = load(code_string)
      if not func then error(err) end

      return func() -- load() mengembalikan fungsi, kita panggil untuk mendapatkan fungsi internal
    end

    local my_eval = create_formula_evaluator("x^2 + y/2")
    print(my_eval(10, 20)) -- Output: 110.0
    ```

    Ini seringkali lebih cepat daripada parser dan evaluator yang ditulis dalam Lua murni.

##### **11.2 Code Injection Techniques (Teknik Injeksi Kode)**

- **Deskripsi Konkret:**
  Jika Anda membuat kode dinamis dari input pengguna, Anda harus sangat berhati-hati. Seorang pengguna jahat dapat memasukkan kode berbahaya ke dalam input, yang kemudian akan dieksekusi oleh program Anda. Ini disebut _Code Injection_.

- **Keamanan dan Validasi:**
  - **Sanitize Input:** Jangan pernah secara membabi buta menyambungkan string input dari pengguna ke dalam kode Anda. Validasi input secara ketat. Pastikan input hanya berisi karakter yang diizinkan (misalnya, angka, operator matematika, dan nama variabel yang aman).
  - **Contoh Tidak Aman:**
    ```lua
    -- Jika userInput adalah "10; os.execute('rm -rf /')"
    local code = "return " .. userInput
    load(code)() -- BOOM! Perintah berbahaya dieksekusi.
    ```
  - **Metode Aman:** Alih-alih menyusun kode, gunakan fungsi yang aman. Jika Anda butuh kalkulator, berikan fungsi `kalkulator(input)` yang mem-parsing input, bukan mengeksekusinya. Jika harus membuat kode, gunakan `string.format` dengan hati-hati dan validasi input secara agresif.

##### **11.3 DSL Implementation (Implementasi DSL)**

- **Deskripsi Konkret:**
  A **Domain-Specific Language (DSL)** adalah "bahasa mini" yang dirancang untuk domain masalah tertentu. Lua sangat cocok untuk menjadi host bagi DSL karena sintaksnya yang fleksibel (misalnya, pemanggilan fungsi tanpa tanda kurung) dan sistem lingkungannya yang dapat disesuaikan.

- **Contoh: DSL untuk Konfigurasi Jendela**
  Alih-alih menggunakan JSON atau XML yang kaku, Anda bisa membuat file konfigurasi yang terlihat seperti ini:

  _`config.win` (sebenarnya adalah file Lua)_

  ```lua
  window {
    title = "Jendela Aplikasi Saya",
    width = 800,
    height = 600,

    button {
      label = "OK",
      x = 700,
      y = 550
    }
  }
  ```

  _Cara kerjanya:_

  ```lua
  -- Di kode utama Anda
  local config_data = {}
  local config_env = {
    -- 'window' dan 'button' adalah fungsi di lingkungan kita
    window = function(t) config_data.window = t end,
    button = function(t) config_data.window.button = t end
  }

  -- Muat file konfigurasi dengan lingkungan DSL kita
  local func = assert(loadfile("config.win", "t", config_env))
  func() -- Eksekusi DSL

  -- Sekarang, data telah terisi di dalam tabel config_data
  print(config_data.window.title) -- Output: Jendela Aplikasi Saya
  print(config_data.window.button.label) -- Output: OK
  ```

  Di sini, `window { ... }` sebenarnya adalah pemanggilan fungsi `window` dengan satu argumen tabel. Ini adalah teknik yang sangat kuat untuk membuat file konfigurasi yang mudah dibaca dan kuat.

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
