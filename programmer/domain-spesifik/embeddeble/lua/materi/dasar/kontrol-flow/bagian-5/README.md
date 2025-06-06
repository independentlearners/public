### Daftar Isi Pembelajaran

Bagian ini berfungsi sebagai peta jalan Anda. Tautan di bawah ini akan membawa Anda langsung ke bagian yang relevan dalam penjelasan ini.

- **Materi yang Telah Dibahas (Ringkasan)**

  - **Bagian 1**: Mempelajari dasar pengambilan keputusan dengan `if`, `elseif`, `else`, dan mensimulasikan `switch-case` menggunakan tabel.
  - **Bagian 2**: Menguasai perulangan dengan `while`, `repeat...until`, dan dua jenis `for` loop (numerik dan generik).
  - **Bagian 3**: Mempelajari cara mengontrol alur loop lebih lanjut dengan `break` dan `goto`, serta pola untuk menyimulasikan `continue`.
  - **Bagian 4**: Mendalami pola-pola canggih seperti kontrol alur berbasis tabel (state machines), fungsional (map, filter, reduce), dan berbasis metatabel (`__index`, `__call`).

- **Materi Saat Ini: Penanganan Error**

  - [**Bagian 5: Error Handling dan Exception Flow**](https://www.google.com/search?q=%23-bagian-5-error-handling-dan-exception-flow)
    - [5.1 Dasar-Dasar Penanganan Error](https://www.google.com/search?q=%2351-dasar-dasar-penanganan-error)
    - [5.2 Panggilan Terproteksi (`pcall`/`xpcall`)](https://www.google.com/search?q=%2352-panggilan-terproteksi-pcallxpcall)

---

## 📚 **Bagian 5: Error Handling dan Exception Flow**

Penanganan error adalah aspek krusial dalam membuat program yang tangguh (_robust_). Program yang baik tidak hanya berjalan dengan benar pada input yang sempurna, tetapi juga dapat menangani situasi tak terduga (error) dengan anggun tanpa langsung mogok (_crash_). Lua menyediakan beberapa mekanisme untuk menangani error.

### 5.1 Dasar-Dasar Penanganan Error

**Durasi yang Disarankan:** 4-5 jam

Bagian ini membahas cara dasar untuk menghasilkan (memunculkan) error dan melakukan pemrograman defensif untuk mencegah error terjadi.

#### **Deskripsi Konkret**

Dasar penanganan error di Lua melibatkan fungsi `error()` untuk secara sengaja menghentikan eksekusi dan `assert()` untuk memeriksa apakah suatu kondisi benar, dan jika tidak, memunculkan error. Ini adalah alat utama Anda untuk menandakan bahwa sesuatu yang tidak diharapkan telah terjadi.

#### **Terminologi dan Konsep Mendasar**

- **Error Propagation (Propagasi Error)**: Jika sebuah error terjadi di dalam sebuah fungsi dan tidak ditangani, error tersebut akan "merambat" ke atas melalui tumpukan panggilan (_call stack_), dari fungsi pemanggil ke fungsi yang memanggilnya, dan seterusnya, hingga mencapai tingkat teratas dan menghentikan program.
- **Defensive Programming (Pemrograman Defensif)**: Gaya penulisan kode di mana Anda secara eksplisit memeriksa validitas input, asumsi, dan kondisi untuk memastikan program berperilaku seperti yang diharapkan dan mencegah error sebelum terjadi. `assert()` adalah alat utama untuk ini.
- **Stack Trace (Jejak Tumpukan)**: Laporan yang menunjukkan urutan pemanggilan fungsi yang sedang aktif pada saat error terjadi. Ini sangat berguna untuk debugging karena menunjukkan di mana dan bagaimana error tersebut muncul.

#### **Topik yang Dipelajari (Sesuai Kurikulum dan Penjelasan Tambahan)**

- **`error()` function dan error propagation**:

  - **Deskripsi**: Fungsi `error(pesan_error, level)` digunakan untuk menghentikan eksekusi program dan memunculkan pesan error. Ini adalah cara Lua untuk "melempar pengecualian" (_throw an exception_).
  - **Sintaks**: `error(message, [level])`
    - `message`: String (atau objek lain) yang akan menjadi pesan error.
    - `level` (opsional): Angka yang menentukan di mana error dilaporkan terjadi dalam stack trace.
      - `level = 1` (default): Melaporkan error terjadi di baris tempat `error()` dipanggil.
      - `level = 2`: Melaporkan error terjadi di baris tempat fungsi yang memanggil `error()` dipanggil.
      - `level = 0`: Tidak menyertakan informasi lokasi sama sekali.
  - **Contoh Kode**:

    ```lua
    local function bagi(a, b)
        if b == 0 then
            -- Memunculkan error secara eksplisit. Program akan berhenti di sini jika tidak ditangani.
            error("Pembagian dengan nol tidak diizinkan.", 2)
            -- level=2 membuat error dilaporkan di baris yang memanggil 'bagi', bukan di dalam 'bagi'.
            -- Ini lebih berguna bagi pengguna fungsi.
        end
        return a / b
    end

    local function hitung(x, y)
        print("Mencoba melakukan pembagian...")
        local hasil = bagi(x, y) -- Panggilan yang bisa menyebabkan error
        print("Hasilnya adalah: " .. hasil)
        return hasil
    end

    -- hitung(10, 2) -- Ini akan berjalan dengan baik
    -- hitung(10, 0) -- Ini akan memunculkan error dan menghentikan script.
    -- Output error dari hitung(10, 0):
    -- .../nama_file.lua:16: Pembagian dengan nol tidak diizinkan.
    -- stack traceback:
    --     [C]: in function 'error'
    --     .../nama_file.lua:4: in function 'bagi'
    --     .../nama_file.lua:16: in function 'hitung'  <-- Perhatikan error dilaporkan di sini karena level=2
    --     ...
    ```

  - **Propagasi**: Dalam contoh di atas, error yang dilempar oleh `bagi()` merambat ke `hitung()`. Karena `hitung()` tidak menanganinya, error tersebut merambat lebih jauh ke atas hingga menghentikan skrip.

- **`assert()` untuk defensive programming**:

  - **Deskripsi**: Fungsi `assert(kondisi, [pesan_error])` adalah alat pemrograman defensif yang sangat umum di Lua.
    - Jika `kondisi` adalah `true` (atau nilai truthy lainnya), `assert` akan mengembalikan semua argumennya (termasuk `kondisi` itu sendiri) dan eksekusi berlanjut.
    - Jika `kondisi` adalah `false` atau `nil`, `assert` akan memanggil `error(pesan_error)`. Jika `pesan_error` tidak diberikan, pesan defaultnya adalah "assertion failed\!".
  - **Penggunaan**: Ini sangat berguna untuk memvalidasi argumen fungsi, memeriksa nilai kembali dari fungsi lain, dan memastikan asumsi dalam kode Anda benar.
  - **Contoh Kode**:

    ```lua
    local function setUserAge(user, age)
        -- Memastikan argumen 'user' adalah sebuah tabel dan 'age' adalah angka positif.
        assert(type(user) == "table", "Argumen 'user' harus berupa tabel")
        assert(type(age) == "number" and age > 0, "Argumen 'age' harus angka positif")
        user.age = age
        print("Usia pengguna ditetapkan menjadi " .. age)
    end

    local user1 = {}
    setUserAge(user1, 30) -- Valid

    -- setUserAge(nil, 25) -- Akan error: "Argumen 'user' harus berupa tabel"
    -- setUserAge(user1, -5) -- Akan error: "Argumen 'age' harus angka positif"

    -- Menggunakan assert untuk memeriksa hasil panggilan fungsi
    local file, err_msg = io.open("file_yang_ada.txt", "r")
    -- Jika io.open gagal, ia mengembalikan nil dan pesan error.
    -- assert akan menangkap ini.
    -- local file = assert(io.open("file_yang_tidak_ada.txt", "r")) -- Akan error dengan pesan dari io.open
    -- print("File berhasil dibuka")
    -- if file then file:close() end
    ```

  - **`assert` sebagai Ekspresi**: Karena `assert` mengembalikan argumennya jika berhasil, ia bisa digunakan dalam sebuah ekspresi.
    ```lua
    local function getValue() return "nilai penting" end
    -- assert akan memeriksa apakah getValue() mengembalikan nilai truthy,
    -- dan jika ya, myValue akan diisi dengan nilai tersebut.
    local myValue = assert(getValue(), "getValue() gagal mengembalikan nilai")
    ```

- **Error message formatting (Format Pesan Error)**:

  - **Deskripsi**: Membuat pesan error yang jelas dan informatif sangat penting untuk debugging. `string.format` sering digunakan untuk ini.
  - **Praktik Terbaik**:
    - Sertakan informasi tentang apa yang salah.
    - Sebutkan nilai yang menyebabkan masalah.
    - Berikan petunjuk tentang apa yang seharusnya terjadi.
  - **Contoh Kode**:

    ```lua
    local function getItem(index)
        local items = {"a", "b", "c"}
        assert(type(index) == "number", string.format("Indeks harus berupa angka, tetapi mendapat %s", type(index)))
        assert(items[index], string.format("Indeks %d di luar batas (harus antara 1 dan %d)", index, #items))
        return items[index]
    end

    print(getItem(2)) -- b
    -- print(getItem("satu")) -- Akan error: Indeks harus berupa angka, tetapi mendapat string
    -- print(getItem(5))     -- Akan error: Indeks 5 di luar batas (harus antara 1 dan 3)
    ```

- **Error levels dan stack traces (Level Error dan Jejak Tumpukan)**:

  - **Deskripsi**: Seperti yang disebutkan, `level` pada `error()` mengontrol di mana lokasi error dilaporkan. Ini penting saat membuat fungsi pustaka (library). Anda ingin error dilaporkan dari sudut pandang _pengguna_ pustaka Anda, bukan dari dalam pustaka itu sendiri.
  - **Contoh Kasus Penggunaan `level=2`**:

    ```lua
    -- Bayangkan ini adalah bagian dari library `my_utils.lua`
    local M = {}
    function M.mustBePositive(val)
        if not (type(val) == "number" and val > 0) then
            -- level=2 membuat error menunjuk ke kode yang memanggil mustBePositive
            error("nilai harus positif, tetapi mendapat " .. tostring(val), 2)
        end
    end
    return M

    -- Sekarang di file lain (misalnya main.lua)
    -- local my_utils = require("my_utils")
    -- local function calculateSomething(input)
    --     my_utils.mustBePositive(input) -- Baris 5 di main.lua
    --     -- ...
    -- end
    -- calculateSomething(-10)
    -- Error akan dilaporkan di "main.lua:5", yang jauh lebih membantu
    -- daripada dilaporkan di dalam file "my_utils.lua".
    ```

#### **Penjelasan Mendalam Tambahan**

- **Error Objects**: Argumen pertama untuk `error()` dan `assert()` tidak harus berupa string. Anda bisa melemparkan tabel yang berisi informasi lebih detail, yang kemudian bisa ditangkap oleh `pcall` (dibahas selanjutnya).
- **Kapan Menggunakan `error` vs `assert`**:
  - Gunakan `assert` untuk memeriksa _pra-kondisi_ (asumsi tentang input atau state sebelum operasi) dan _pasca-kondisi_ (asumsi tentang output atau state setelah operasi). Ini adalah alat untuk pemrograman defensif.
  - Gunakan `error` ketika Anda mendeteksi kondisi error yang tidak dapat dipulihkan di tengah-tengah logika, di mana `assert` tidak cocok (misalnya, pembagian dengan nol, format file salah, dll.).

#### **Sumber Belajar (dari README.md)**:

- [Lua Error Handling](https://www.tutorialspoint.com/lua/lua_error_handling.htm)
- [Programming in Lua: Error Handling](https://www.lua.org/pil/8.4.html)

---

### 5.2 Panggilan Terproteksi (`pcall`/`xpcall`)

**Durasi yang Disarankan:** 3-4 jam

Jika `error` dan `assert` adalah cara untuk _memunculkan_ error, `pcall` dan `xpcall` adalah cara untuk _menangkap_ dan _menanganinya_ tanpa membuat program crash.

#### **Deskripsi Konkret**

`pcall` (_protected call_) mengeksekusi sebuah fungsi dalam "mode terproteksi". Jika terjadi error selama eksekusi fungsi tersebut, `pcall` akan menangkap error tersebut, tidak membiarkannya merambat, dan mengembalikan status error. `xpcall` (_extended protected call_) melakukan hal yang sama tetapi dengan tambahan fungsi penangan error (_error handler_) kustom.

#### **Terminologi dan Konsep Mendasar**

- **Protected Environment (Lingkungan Terproteksi)**: Konteks eksekusi yang dibuat oleh `pcall` atau `xpcall` di mana error yang terjadi tidak akan menghentikan program, melainkan akan ditangkap.
- **Error Handler Function (Fungsi Penangan Error)**: Fungsi yang dipanggil oleh `xpcall` ketika error terjadi. Fungsi ini menerima objek error sebagai argumen dan dapat memproses atau memformat ulang pesan error sebelum dikembalikan oleh `xpcall`.

#### **Topik yang Dipelajari (Sesuai Kurikulum dan Penjelasan Tambahan)**

- **`pcall()` untuk error recovery (Pemulihan error dengan `pcall`)**:

  - **Deskripsi**: `pcall(f, arg1, ...)` memanggil fungsi `f` dengan argumen `arg1, ...` dalam mode terproteksi.
  - **Nilai Kembali**:
    - **Jika tidak ada error**: `pcall` mengembalikan `true` diikuti oleh semua nilai yang dikembalikan oleh fungsi `f`.
    - **Jika ada error**: `pcall` mengembalikan `false` diikuti oleh objek error (biasanya string pesan error).
  - **Contoh Kode**:

    ```lua
    local function fungsiYangMungkinError(a, b)
        assert(type(a) == "number" and type(b) == "number", "Kedua argumen harus angka")
        if b == 0 then
            error("Pembagian dengan nol")
        end
        return a / b, "Sukses" -- Fungsi bisa mengembalikan beberapa nilai
    end

    -- Kasus Sukses
    local status, hasil1, hasil2 = pcall(fungsiYangMungkinError, 10, 2)
    print("Status:", status)
    print("Hasil 1:", hasil1)
    print("Hasil 2:", hasil2)
    -- Output:
    -- Status: true
    -- Hasil 1: 5
    -- Hasil 2: Sukses

    print("---")

    -- Kasus Error (Pembagian dengan nol)
    local statusErr, pesanError = pcall(fungsiYangMungkinError, 10, 0)
    print("Status:", statusErr)
    print("Pesan Error:", pesanError)
    -- Output:
    -- Status: false
    -- Pesan Error: ...:123: Pembagian dengan nol  (nomor baris bisa berbeda)

    print("---")

    -- Kasus Error (Tipe argumen salah)
    local statusErr2, pesanError2 = pcall(fungsiYangMungkinError, 10, "dua")
    print("Status:", statusErr2)
    print("Pesan Error:", pesanError2)
    -- Output:
    -- Status: false
    -- Pesan Error: ...:123: Kedua argumen harus angka (nomor baris bisa berbeda)

    print("\nEksekusi berlanjut setelah pcall, program tidak crash.")
    ```

  - **Penggunaan Umum**: Memanggil kode yang tidak Anda kontrol (misalnya, dari library pihak ketiga), melakukan operasi I/O yang bisa gagal, atau mengimplementasikan sistem plugin di mana plugin bisa saja error.

- **`xpcall()` dengan custom error handlers (`xpcall` dengan penangan error kustom)**:

  - **Deskripsi**: `xpcall(f, err_handler, arg1, ...)` mirip dengan `pcall`, tetapi jika terjadi error, ia akan memanggil fungsi `err_handler` terlebih dahulu dengan objek error sebagai argumen. Nilai yang dikembalikan oleh `err_handler` akan menjadi nilai yang dikembalikan oleh `xpcall` sebagai pesan error.
  - **Penggunaan**: Ini memungkinkan Anda untuk memproses error sebelum ditampilkan. Anda bisa menambahkan informasi debugging, stack trace yang lebih detail, atau memformatnya menjadi format log yang standar.
  - **Contoh Kode**:

    ```lua
    local function fungsiError()
        -- error({ code = 101, message = "File tidak ditemukan" }) -- Contoh error object
        variable_yang_tidak_ada = variable_yang_tidak_ada + 1 -- Ini akan menyebabkan error
    end

    local function myErrorHandler(err)
        print("--- Di dalam Error Handler Kustom ---")
        print("Objek error mentah:", err)
        -- 'debug.traceback()' adalah fungsi yang sangat berguna untuk mendapatkan stack trace
        local traceback = debug.traceback()
        print("Menambahkan stack trace...")
        return "Terjadi error: " .. tostring(err) .. "\n" .. traceback
    end

    local status, hasil_atau_error = xpcall(fungsiError, myErrorHandler)

    print("\n--- Hasil dari xpcall ---")
    print("Status:", status)
    print("Hasil/Error yang diformat:\n" .. hasil_atau_error)
    ```

    **Output akan terlihat seperti:**

    ```
    --- Di dalam Error Handler Kustom ---
    Objek error mentah: ...: attempt to perform arithmetic on a nil value (global 'variable_yang_tidak_ada')
    Menambahkan stack trace...

    --- Hasil dari xpcall ---
    Status: false
    Hasil/Error yang diformat:
    Terjadi error: ...: attempt to perform arithmetic on a nil value (global 'variable_yang_tidak_ada')
    stack traceback:
        ...: in function 'fungsiError'
        [C]: in function 'xpcall'
        ...
    ```

- **Error handling patterns dan best practices (Pola penanganan error dan praktik terbaik)**:

  - **Never swallow errors (Jangan pernah menelan error)**: Hindari blok `pcall` kosong yang menangkap error tetapi tidak melakukan apa-apa dengannya (tidak mencatat, tidak melaporkan). Ini membuat debugging menjadi mimpi buruk.
    ```lua
    -- ANTI-PATTERN: Menelan error
    -- local status, err = pcall(fungsiBerbahaya)
    -- if not status then
    --     -- Melakukan apa? Tidak ada. Error hilang begitu saja.
    -- end
    ```
  - **Resource Cleanup (Pembersihan Sumber Daya)**: `pcall` tidak secara otomatis membersihkan sumber daya (seperti file yang terbuka). Anda harus memastikan pembersihan dilakukan. Pola `try...finally` dari bahasa lain dapat disimulasikan, meskipun agak canggung.

    ```lua
    local file
    local status, err = pcall(function()
        file = assert(io.open("data.txt", "w"))
        file:write("sesuatu yang bisa error")
        -- Jika error terjadi di sini, blok 'finally' di bawah akan tetap berjalan
        error("simulasi error")
    end)

    -- Blok 'finally'
    if file then
        print("Membersihkan sumber daya file...")
        file:close()
    end

    if not status then
        print("Error ditangkap setelah cleanup: " .. err)
    end
    ```

    Pola ini memastikan `file:close()` dipanggil baik fungsi di dalam `pcall` berhasil maupun gagal.

  - **Gunakan `xpcall` untuk logging terpusat**: `xpcall` sangat baik untuk sistem logging di mana Anda ingin semua error memiliki format yang konsisten dan menyertakan informasi debugging yang kaya seperti stack trace.

- **Performance impact of protected calls (Dampak performa dari panggilan terproteksi)**:

  - **Deskripsi**: `pcall` dan `xpcall` memiliki overhead performa. Mereka perlu menyiapkan lingkungan terproteksi sebelum memanggil fungsi. Overhead ini mungkin tidak signifikan untuk operasi yang jarang atau sudah lambat (seperti I/O file), tetapi bisa menjadi masalah jika digunakan di dalam loop yang sangat ketat (_tight loop_).
  - **Aturan Praktis**: Jangan gunakan `pcall`/`xpcall` untuk kontrol alur normal yang tidak berhubungan dengan error. Gunakan mereka secara strategis di "batas" sistem Anda, di mana Anda berinteraksi dengan kode yang tidak dapat dipercaya atau operasi yang rentan gagal.

#### **Penjelasan Mendalam Tambahan**

- **`pcall` vs `xpcall`**:
  - Gunakan `pcall` untuk penanganan error yang sederhana, di mana Anda hanya perlu tahu apakah operasi berhasil atau gagal dan apa pesan errornya.
  - Gunakan `xpcall` ketika Anda memerlukan kontrol lebih besar atas bagaimana error dilaporkan. Kemampuan untuk menambahkan stack trace secara terprogram adalah keuntungan utamanya.

#### **Sumber Belajar (dari README.md)**:

- [Lua Error Handling](https://www.tutorialspoint.com/lua/lua_error_handling.htm)
- [Lua 5.4 Reference Manual](https://www.lua.org/manual/5.4/manual.html) (Bagian `pcall` dan `xpcall`)

---

Kita telah membahas cara memunculkan, menangkap, dan menangani error di Lua. Menguasai alat-alat ini akan membuat kode Anda jauh lebih andal dan mudah di-debug. Berikutnya kita akan memasuki salah satu fitur paling kuat dan unik di Lua: **Bagian 6: Coroutines - Advanced Asynchronous Control**. Ini adalah topik yang sangat menarik dan membuka banyak kemungkinan baru. Siap untuk melanjutkan?
