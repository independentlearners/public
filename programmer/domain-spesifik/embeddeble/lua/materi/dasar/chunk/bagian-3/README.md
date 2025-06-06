# **[Bagian III: Loading dan Execution (Runtime)][0]**

Sebelumnya kita telah memahami bagaimana Lua mengkompilasi kode menjadi bytecode, sekarang kita akan mempelajari bagaimana bytecode tersebut dimuat (loading) dan dijalankan (execution) oleh Lua Virtual Machine (VM). Berikut ini adalah bagian di mana kode Anda benar-benar "hidup". Menguasai bagian ini akan memberi Anda kendali penuh atas bagaimana, kapan, dan di mana kode Anda dieksekusi, serta lingkungan apa yang bisa diaksesnya. Jadi ini fokus pada interaksi antara kode terkompilasi (bytecode) Anda dan Lua Virtual Machine (VM).

#### **6. Chunk Loading Mechanisms (Mekanisme Pemuatan Chunk)**

Lua menyediakan beberapa fungsi untuk memuat chunk kode. Memahami perbedaan di antara mereka sangatlah penting.

##### **6.1 Dynamic Loading Functions (Fungsi Pemuatan Dinamis)**

- **Deskripsi Konkret:**
  Ini adalah fungsi-fungsi inti Lua untuk memuat chunk dari berbagai sumber (seperti string atau stream) saat program sedang berjalan (runtime). Perbedaan utama dari fungsi seperti `dofile` adalah bahwa fungsi-fungsi ini **hanya memuat dan mengkompilasi chunk, tetapi tidak langsung menjalankannya**. Mereka mengembalikan sebuah fungsi yang merepresentasikan chunk tersebut, yang bisa Anda jalankan nanti.

- **Terminologi dan Fungsi Kunci:**

  - **`load(chunk, [chunkname], [mode], [env])`**: Fungsi paling serbaguna. Ia memuat sebuah chunk dari sebuah _sumber_. Sumber ini bisa berupa string atau sebuah _reader function_ (fungsi yang menyediakan potongan-potongan chunk, berguna untuk memuat dari file atau jaringan secara bertahap).
  - **`loadstring(string, [chunkname])`**: Ini adalah versi sederhana dari `load` yang khusus untuk memuat chunk dari sebuah string. Di Lua 5.1, ini adalah fungsi terpisah, tetapi di versi lebih baru, `loadstring(s)` hanyalah alias untuk `load(s)`.

- **Sintaks dan Contoh:**
  Perhatikan perbedaan krusial ini: `load` mengembalikan sebuah fungsi, atau `nil` plus pesan error.

  ```lua
  -- Menggunakan load() dengan string
  local chunk_func, err = load("print('Halo dari chunk yang dimuat!')")

  if chunk_func then
    print("Chunk berhasil dikompilasi. Siap untuk dieksekusi.")
    -- Sekarang kita jalankan fungsi yang dikembalikan
    chunk_func() -- Output: Halo dari chunk yang dimuat!
  else
    print("Error kompilasi:", err)
  end

  -- Contoh yang mengandung error sintaks
  local bad_chunk_func, err_msg = load("print('oops'") -- Kurung tutupnya hilang

  if not bad_chunk_func then
    print("Gagal memuat chunk. Alasannya:", err_msg)
    -- Output: Gagal memuat chunk. Alasannya: [string "print('oops'"]:1: unexpected symbol near '<eof>'
  end
  ```

- **Mengapa Ini Penting?**
  Kemampuan untuk memuat kode tanpa langsung menjalankannya sangat hebat. Ini memungkinkan Anda untuk:
  - Mengkompilasi kode sekali dan menjalankannya berkali-kali.
  - Memvalidasi sintaks kode dari pengguna sebelum menjalankannya.
  - Menerapkan sistem plugin, di mana plugin dimuat saat startup tetapi hanya dieksekusi saat dibutuhkan.

##### **6.2 File-based Loading (Pemuatan Berbasis File)**

- **Deskripsi Konkret:**
  Ini adalah cara paling umum untuk menjalankan skrip Lua, yaitu dengan memuatnya langsung dari file.

- **Terminologi dan Fungsi Kunci:**

  - **`dofile(filename)`**: Sebuah fungsi sederhana yang melakukan dua hal: membuka file, memuat isinya sebagai chunk, dan **langsung mengeksekusinya**. Jika terjadi error (baik saat kompilasi maupun eksekusi), error tersebut akan "meledak" (propagate). `dofile` adalah cara cepat dan praktis untuk menjalankan skrip.
  - **`loadfile(filename, [mode], [env])`**: Mirip seperti `load`, tetapi sumbernya adalah nama file. Ia **hanya memuat dan mengkompilasi** isi file, lalu mengembalikan chunk sebagai fungsi. Ia tidak menjalankan kodenya. Ini memberi Anda kontrol lebih besar dibandingkan `dofile`.

- **Sintaks dan Contoh:**

  ```lua
  -- Asumsikan kita punya file bernama "skripku.lua" berisi: print("Skripku berjalan!")

  -- Menggunakan dofile (cara cepat)
  -- Ini akan langsung mencetak "Skripku berjalan!" ke konsol.
  dofile("skripku.lua")

  -- Menggunakan loadfile (cara yang lebih terkontrol)
  local my_script, err = loadfile("skripku.lua")

  if my_script then
    print("Skrip berhasil dimuat, akan dijalankan sekarang.")
    -- my_script adalah sebuah fungsi, kita panggil untuk menjalankannya
    my_script() -- Baru di sini "Skripku berjalan!" akan tercetak.
  else
    print("Gagal memuat file:", err)
  end
  ```

##### **6.3 Memory-based Loading (Pemuatan Berbasis Memori)**

- **Deskripsi Konkret:**
  Ini merujuk pada pemuatan chunk yang sudah ada di memori, biasanya sebagai bytecode biner, bukan sebagai teks kode sumber. Ini sering digunakan dalam integrasi dengan C, di mana data bytecode bisa disimpan dalam sebuah array C dan dimuat tanpa perlu menyentuh sistem file.

- **Konsep:**
  - Fungsi `load` dapat menerima bytecode biner langsung jika disajikan sebagai string Lua. Lua cukup pintar untuk mendeteksi header bytecode dan memuatnya secara langsung, melewati tahap parsing dan code generation, sehingga sangat cepat.
  - **Zero-copy loading**: Teknik canggih (biasanya di level C API) di mana Lua dapat mengeksekusi bytecode langsung dari buffer memori Anda tanpa perlu menyalinnya ke area memori yang dikelola Lua, sehingga menghemat memori.

---

#### **7. Execution Environment Management (Manajemen Lingkungan Eksekusi)**

Setiap chunk yang berjalan membutuhkan sebuah "lingkungan" (environment). Lingkungan ini menentukan variabel dan fungsi apa saja yang bisa dilihat dan diakses oleh chunk tersebut.

##### **7.1 Global Environment dan \_G**

- **Deskripsi Konkret:**
  Secara default, setiap chunk berjalan dalam satu lingkungan global yang sama. Di versi Lua sebelum 5.2, lingkungan ini disimpan dalam sebuah tabel global khusus bernama `_G`. Ketika kode Anda mencoba mengakses variabel yang tidak dideklarasikan secara lokal (misalnya, `print("halo")`), Lua akan mencarinya di dalam tabel `_G` ini (`_G["print"]`).

- **Konsep:**

  - **`_G`**: Sebuah tabel Lua biasa yang berisi semua fungsi dan variabel global (seperti `print`, `tostring`, `pairs`, dll.). Anda bisa memanipulasi `_G` seperti tabel lainnya.
  - `x = 10` (tanpa `local`) pada dasarnya adalah singkatan dari `_G.x = 10`.

- **Sintaks dan Contoh:**

  ```lua
  -- Ini akan membuat variabel global 'pesan'
  pesan = "Ini variabel global"

  -- Anda bisa mengaksesnya secara eksplisit melalui _G
  print(_G.pesan) -- Output: Ini variabel global

  -- Menambahkan fungsi global baru
  _G.sapa = function() print("Halo Dunia!") end

  sapa() -- Output: Halo Dunia!
  ```

##### **7.2 \_ENV Variable Deep Dive**

- **Deskripsi Konkret:**
  Mulai Lua 5.2, cara kerja lingkungan diubah menjadi lebih fleksibel dan kuat. Alih-alih satu tabel `_G` yang ter-hardcode, setiap fungsi sekarang memiliki variabel lokal _upvalue_ bernama `_ENV`. Ketika sebuah chunk mencari variabel global, ia sekarang mencarinya di dalam tabel `_ENV` ini.

- **Perbedaan Kunci dari `_G`:**

  - **Lokal per Fungsi:** `_ENV` adalah variabel yang "dekat" dengan fungsi/chunk, bukan satu tabel global yang jauh.
  - **Bisa Diubah:** Anda bisa dengan mudah mengganti tabel `_ENV` untuk sebuah chunk, yang secara efektif mengubah seluruh "dunia" yang bisa dilihatnya. Secara default, `_ENV` untuk chunk utama diinisialisasi dengan tabel `_G`. Inilah yang membuatnya tetap kompatibel dengan kode lama.

- **Sintaks dan Contoh (Kekuatan `_ENV`):**
  Ini adalah dasar dari _sandboxing_. Kita bisa membuat lingkungan kosong untuk sebuah chunk.

  ```lua
  local untrusted_code = "print('Mencoba mencetak...') os.exit()" -- Kode ini berpotensi bahaya

  -- Buat lingkungan yang aman dan kosong
  local safe_env = {}

  -- Muat kode dengan lingkungan kustom kita
  local chunk_func, err = load(untrusted_code, "chunk_aman", "t", safe_env)

  if chunk_func then
    print("Menjalankan kode di dalam sandbox...")
    chunk_func() -- Ini akan ERROR!
  end
  ```

  Kode di atas akan gagal saat dieksekusi. Mengapa? Karena di dalam `safe_env`, tidak ada fungsi `print` dan tidak ada modul `os`. Chunk tersebut benar-benar terisolasi.

##### **7.3 Custom Environment Creation (Pembuatan Lingkungan Kustom)**

- **Deskripsi Konkret:**
  Ini adalah aplikasi praktis dari `_ENV`. Anda bisa membuat lingkungan kustom dan secara selektif memasukkan hanya fungsi-fungsi yang Anda izinkan untuk diakses oleh sebuah chunk.

- **Strategi:**

  1.  **Buat tabel lingkungan baru:** `local my_env = {}`.
  2.  **Isi dengan fungsi yang diizinkan:** `my_env.print = print` atau `my_env.tambah = function(a, b) return a+b end`.
  3.  **Gunakan sebagai argumen `env`** saat memanggil `load` atau `loadfile`.
  4.  Untuk keamanan ekstra, Anda bisa menggunakan _metatable_ pada `my_env` untuk mengontrol akses ke variabel yang tidak ada, alih-alih membiarkannya mengembalikan `nil`.

- **Contoh Lengkap Sandboxing:**

  ```lua
  local user_script = "cetak(tambah(5, 10))"

  -- 1. Buat lingkungan kustom
  local sandbox_env = {
    cetak = print, -- Beri akses ke 'print', tapi dengan nama 'cetak'
    tambah = function(a, b) return a + b end
  }

  -- 2. Muat skrip pengguna dengan lingkungan tersebut
  local user_func = load(user_script, "skrip_pengguna", "t", sandbox_env)

  -- 3. Jalankan dengan aman
  if user_func then
    local status, result = pcall(user_func) -- pcall untuk menangkap error runtime
    if not status then
      print("Error runtime di skrip pengguna:", result)
    end
    -- Output: 15
  end
  ```

---

#### **8. Virtual Machine Execution (Eksekusi Mesin Virtual)**

Ini adalah level terendah dari runtime, yaitu bagaimana Lua VM sebenarnya menjalankan instruksi bytecode.

##### **8.1 Lua VM Architecture (Arsitektur VM Lua)**

- **Deskripsi Konkret:**
  Lua VM tidak berjalan langsung di CPU fisik. Ini adalah program (ditulis dalam C) yang mensimulasikan sebuah CPU ideal. Arsitektur utamanya adalah **berbasis stack** dengan beberapa "register" virtual.

- **Konsep:**
  - **Stack-based Execution Model:** Sebagian besar operasi mengambil nilai dari atau menaruh hasil ke sebuah _stack_ (tumpukan). Ketika Anda memanggil fungsi, argumennya ditaruh di stack, dan fungsi tersebut mendapatkan "jendela" atau _stack frame_ sendiri untuk bekerja.
  - **Register Allocation Simulation:** Meskipun berbasis stack, VM Lua modern menggunakan skema register untuk menyimpan nilai lokal, yang jauh lebih efisien. Instruksi bytecode sering kali beroperasi pada register-register virtual ini, bukan langsung pada stack.

##### **8.2 Execution Context Management (Manajemen Konteks Eksekusi)**

- **Deskripsi Konkret:**
  VM perlu mengelola konteks dari setiap fungsi yang sedang berjalan.
  - **Call Stack:** Tumpukan panggilan fungsi. Jika `fungsiA()` memanggil `fungsiB()`, `fungsiB` akan berada di atas `fungsiA` di call stack. Inilah yang Anda lihat dalam _stack trace_ saat terjadi error.
  - **Coroutine Integration:** Coroutine (utas eksekusi kooperatif) adalah fitur kelas satu di Lua. Setiap coroutine memiliki stack-nya sendiri, memungkinkan beberapa "utas" eksekusi untuk berjalan di dalam satu thread OS, dengan kemampuan untuk `yield` (menjeda) dan `resume` (melanjutkan) eksekusi.
  - **Exception Handling:** Ketika error terjadi (`error()`) atau terdeteksi (misalnya, mencoba menambah string dengan angka), VM akan "menggulung balik" (unwind) call stack, mencari _protected call_ (seperti `pcall` atau `xpcall`) untuk menangani error tersebut.

##### **8.3 JIT Compilation Considerations**

- **Deskripsi Konkret:**
  **LuaJIT** adalah implementasi alternatif dari Lua yang menyertakan **Just-In-Time (JIT) Compiler**. Alih-alih hanya menginterpretasikan bytecode, LuaJIT akan menganalisis kode yang sering berjalan (hot paths) dan mengkompilasinya lebih lanjut menjadi kode mesin asli (native machine code) saat runtime. Ini bisa membuat eksekusi Lua menjadi sangat cepat, seringkali mendekati kecepatan kode C.

- **Perbedaan Penanganan Chunk:**
  - LuaJIT memiliki format bytecode sendiri yang tidak kompatibel dengan Lua standar.
  - Proses JIT-ing terjadi secara transparan. Anda cukup menjalankan skrip Anda dengan interpreter `luajit`.
  - **FFI (Foreign Function Interface):** Fitur andalan LuaJIT. Ini memungkinkan Anda untuk memanggil fungsi dari library C (`.dll` atau `.so`) langsung dari skrip Lua tanpa perlu menulis kode "lem" (glue code) dalam C. Ini sangat kuat untuk integrasi performa tinggi.
    - **Contoh FFI:** `local ffi = require("ffi"); ffi.cdef("int printf(const char *fmt, ...);"); ffi.C.printf("Halo dari C!")`

Anda kini telah memahami bagaimana kode Lua dimuat, bagaimana lingkungannya dikelola untuk keamanan dan fleksibilitas, dan bagaimana VM mengeksekusinya di level terendah. Dengan pengetahuan ini, Anda siap untuk mempelajari teknik-teknik yang lebih canggih.

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
