# **[5. Error Handling dalam I/O][0]**

Operasi I/O (Input/Output) sangat rentan terhadap error. File mungkin tidak ada, izin akses mungkin ditolak, disk bisa penuh, atau media bisa dilepas. Program yang baik tidak boleh _crash_ (berhenti secara tidak normal) saat hal-hal ini terjadi. Sebaliknya, ia harus mampu menangani error ini dengan anggun.

### 5.1 Penanganan Error Dasar

**Deskripsi Konkret:**
Penanganan error dasar melibatkan teknik-teknik paling langsung untuk mendeteksi dan merespons kegagalan dalam operasi I/O. Dua pendekatan yang paling umum adalah memeriksa nilai kembali (return value) dari sebuah fungsi dan menggunakan fungsi `assert()`.

**Mengecek return value dari `io.open()`:**

- **Konsep**: Ini adalah cara paling fundamental dan umum untuk menangani error di Lua. Seperti yang telah kita lihat, banyak fungsi I/O (terutama `io.open()`) dirancang untuk mengembalikan `nil` sebagai indikasi kegagalan, diikuti dengan pesan error sebagai nilai kedua.
- **Pola Implementasi**: Selalu simpan hasil dari `io.open()` ke dalam dua variabel, satu untuk file handle dan satu untuk pesan error. Kemudian, gunakan pernyataan `if` untuk memeriksa apakah file handle yang dikembalikan adalah `nil`.

**Contoh Kode (Pola Standar):**

```lua
local filename = "data_pengguna.txt"
local file, err_msg = io.open(filename, "r")

-- Penjelasan Sintaks:
-- local file, err_msg: Mendeklarasikan dua variabel untuk menampung hasil dari io.open().
--                      'file' akan berisi file handle jika berhasil, atau nil jika gagal.
--                      'err_msg' akan berisi string pesan error jika gagal.
-- io.open(filename, "r"): Mencoba membuka file dalam mode baca.

if not file then
    -- 'not file' akan true jika 'file' adalah nil.
    io.stderr:write("Gagal membuka file '" .. filename .. "'.\n")
    io.stderr:write("Alasan: " .. (err_msg or "Tidak ada pesan error spesifik.") .. "\n")
    -- Di sini Anda bisa memutuskan untuk menghentikan program atau mencoba recovery.
    -- return false -- Contoh: Keluar dari fungsi saat ini.
else
    -- Jika berhasil, 'file' adalah file handle yang valid.
    print("File '" .. filename .. "' berhasil dibuka.")
    -- ... lanjutkan operasi pada file ...
    file:close()
end
```

Pola ini memberi Anda kontrol penuh untuk memutuskan apa yang harus dilakukan ketika terjadi error—Anda bisa mencetak pesan, mencoba nama file lain, atau keluar dari program.

**Menggunakan `assert()` untuk error handling:**

- **Konsep**: `assert()` adalah fungsi bawaan Lua yang berfungsi sebagai "penjaga". Ia memeriksa kondisi argumen pertamanya. Jika kondisi tersebut `true` (atau nilai apa pun selain `false` dan `nil`), `assert()` tidak melakukan apa-apa dan mengembalikan semua argumennya. Namun, jika kondisi tersebut `false` atau `nil`, `assert()` akan **memunculkan error (raise an error)**, yang biasanya akan menghentikan eksekusi skrip.
- **Sintaks**: `assert(condition, message)`
  - `condition`: Ekspresi yang dievaluasi. Jika `nil` atau `false`, error akan dipicu.
  - `message` (opsional): String yang akan ditampilkan sebagai pesan error. Jika tidak disediakan, `assert` akan menggunakan pesan default "assertion failed\!".
- **Pola dengan `io.open()`**: Anda bisa menggabungkan `io.open()` langsung dengan `assert()`. Karena `io.open()` mengembalikan file handle (nilai `true`-ish) saat berhasil dan `nil` saat gagal, ini bekerja dengan sempurna.

**Contoh Kode (Menggunakan `assert()`):**

```lua
-- assert() akan menangani kasus error secara otomatis.
-- Jika io.open() gagal, ia mengembalikan nil, yang membuat assert() memicu error.
-- Pesan error dari io.open() akan secara otomatis digunakan sebagai pesan error assert().
print("Mencoba membuka 'config.ini' dengan assert...")

local file = assert(io.open("config.ini", "r"))

-- Penjelasan Sintaks:
-- assert(...): Memanggil fungsi assert.
-- io.open("config.ini", "r"): Argumen pertama untuk assert. Hasil dari io.open()
--                              (yaitu file handle atau nil + err_msg) diteruskan ke assert.

-- Bagaimana ini bekerja:
-- 1. Jika io.open() berhasil:
--    - io.open() mengembalikan file_handle (bukan nil).
--    - assert(file_handle) -> kondisi true, assert tidak melakukan apa-apa.
--    - assert mengembalikan argumennya, jadi 'file' akan berisi file_handle.
-- 2. Jika io.open() gagal:
--    - io.open() mengembalikan nil, "file tidak ada", dst.
--    - assert(nil, "file tidak ada") -> kondisi false.
--    - assert memicu error dengan pesan "file tidak ada". Skrip berhenti.

print("File 'config.ini' berhasil dibuka dengan handle:", file)
-- ... lanjutkan operasi pada file ...
file:close()

-- Contoh dengan file yang tidak ada
print("\nMencoba membuka 'file_palsu.txt' dengan assert...")
-- Baris berikut akan menyebabkan skrip berhenti dengan pesan error.
local file_palsu = assert(io.open("file_palsu.txt", "r"))
-- Kode setelah baris ini tidak akan pernah dieksekusi.
print("Baris ini tidak akan pernah tercetak.")
```

**Kapan Menggunakan `assert()` vs `if`?**

- Gunakan **`if not file then ...`** ketika kegagalan membuka file adalah sesuatu yang bisa diantisipasi dan program Anda harus bisa pulih darinya (misalnya, dengan meminta nama file lain kepada pengguna). Ini adalah pendekatan _graceful handling_.
- Gunakan **`assert()`** ketika kegagalan membuka file adalah error fatal yang membuat program tidak mungkin melanjutkan. Contohnya, jika file konfigurasi utama tidak ada, program mungkin memang tidak bisa berjalan sama sekali. Ini adalah pendekatan _fail-fast_, yang membuat kode lebih ringkas dan langsung menghentikan program pada kondisi yang tidak seharusnya terjadi.

**Sumber Referensi dari Kurikulum:**

- [EDUCBA: Lua File Operations](https://www.educba.com/lua-file/) (Sumber ini kemungkinan membahas pola `if not handle` dan mungkin `assert` sebagai bagian dari operasi file dasar).

---

### 5.2 Advanced Error Handling

**Deskripsi Konkret:**
Terkadang, menghentikan skrip saat terjadi error bukanlah pilihan. Anda mungkin ingin mencatat (log) error tersebut, melakukan pembersihan sumber daya (seperti menutup file lain yang sudah terbuka), dan kemudian melanjutkan eksekusi atau mencoba operasi alternatif. Untuk skenario ini, Lua menyediakan `pcall()` dan `xpcall()`.

**`pcall()` dan `xpcall()` untuk protected calls:**

- **`pcall()` (Protected Call)**

  - **Konsep**: `pcall()` menjalankan sebuah fungsi dalam "mode terproteksi". Jika terjadi error di dalam fungsi tersebut, `pcall()` akan _menangkap_ error tersebut alih-alih membiarkannya menghentikan program. Ia kemudian melaporkan status keberhasilan dan hasilnya.
  - **Sintaks**: `local success, result_or_error = pcall(function_to_call, arg1, arg2, ...)`
    - `function_to_call`: Fungsi yang ingin Anda jalankan.
    - `arg1, arg2, ...`: Argumen yang akan diteruskan ke `function_to_call`.
  - **Return Value**:
    - Jika **tidak ada error**: `success` akan `true`, dan `result_or_error` akan berisi nilai-nilai yang dikembalikan oleh `function_to_call`.
    - Jika **terjadi error**: `success` akan `false`, dan `result_or_error` akan berisi objek error (biasanya string pesan error).

- **`xpcall()` (Extended Protected Call)**

  - **Konsep**: `xpcall()` mirip dengan `pcall()`, tetapi dengan satu tambahan penting: ia memungkinkan Anda untuk menentukan **fungsi penangan error (error handler function)**. Jika terjadi error, fungsi penangan error ini akan dipanggil terlebih dahulu sebelum `xpcall()` kembali. Ini memberi Anda kesempatan untuk memproses error tersebut (misalnya, untuk logging yang lebih detail atau menambahkan informasi _stack traceback_).
  - **Sintaks**: `local success, result = xpcall(function_to_call, error_handler_function, arg1, ...)`
    - `error_handler_function`: Fungsi yang akan dipanggil jika terjadi error di dalam `function_to_call`. Fungsi ini menerima objek error sebagai argumennya. Apa yang dikembalikan oleh fungsi penangan error ini akan menjadi nilai `result` dari `xpcall` saat `success` adalah `false`.
  - **Return Value**: Sama seperti `pcall`, `success` adalah boolean. Jika `false`, `result` adalah nilai yang dikembalikan oleh `error_handler_function`.

**Custom error messages:**
Anda bisa membuat pesan error kustom dengan beberapa cara:

1.  Menggunakan `assert(condition, "Pesan kustom saya")`.
2.  Menggunakan fungsi `error("Pesan kustom saya")`. Fungsi `error()` ini akan langsung memicu error yang bisa ditangkap oleh `pcall` atau `xpcall`.

**Recovery dari error I/O:**
Ini adalah kekuatan utama `pcall`. Alih-alih hanya melaporkan error, Anda bisa membangun logika untuk pulih darinya. Contoh klasiknya adalah mencoba kembali operasi atau meminta input alternatif dari pengguna.

**Contoh Kode (`advanced_error_handling.lua`):**

```lua
-- Fungsi untuk menulis ke file, sengaja dibuat bisa gagal
function tulisKeFilePenting(filename, content)
    -- assert() di dalam fungsi ini akan memicu error jika file tidak bisa dibuka
    local file = assert(io.open(filename, "w"), "Tidak dapat membuka file penting: " .. filename)

    -- error() untuk custom error logic
    if type(content) ~= "string" then
        file:close() -- Pastikan file ditutup sebelum error
        error("Konten harus berupa string, diterima tipe: " .. type(content), 2)
        -- Angka '2' di error() menyesuaikan level stack trace, topik lebih lanjut.
    end

    file:write(content)
    file:close()
    return true -- Mengembalikan true jika sukses
end

-- 1. Menggunakan pcall untuk menangkap error
print("--- Menggunakan pcall ---")
-- Skenario sukses
local status_sukses, hasil_sukses = pcall(tulisKeFilePenting, "log.txt", "Semua berjalan lancar.")
-- Penjelasan Sintaks pcall:
-- pcall: Fungsi protected call.
-- tulisKeFilePenting: Fungsi yang akan dipanggil.
-- "log.txt", "Semua berjalan lancar.": Argumen untuk tulisKeFilePenting.
if status_sukses then
    print("pcall sukses:", hasil_sukses) -- hasil_sukses akan true
else
    print("pcall gagal:", hasil_sukses)
end

-- Skenario gagal (misalnya, di sistem Linux, path "/" tidak bisa ditulis oleh user biasa)
local status_gagal, hasil_gagal = pcall(tulisKeFilePenting, "/log.txt", "Coba tulis ke root.")
if not status_gagal then
    print("pcall gagal seperti yang diharapkan. Error:", hasil_gagal)
end

-- Skenario gagal dengan custom error dari error()
local status_tipe, hasil_tipe = pcall(tulisKeFilePenting, "log_tipe.txt", 12345)
if not status_tipe then
    print("pcall gagal karena tipe salah. Error:", hasil_tipe)
end


-- 2. Menggunakan xpcall dengan error handler
print("\n--- Menggunakan xpcall ---")
local function penanganError(err_msg)
    local debug_info = debug.traceback("Stack Trace:", 2)
    return "XPCall Menangkap Error!\n  Pesan: " .. tostring(err_msg) .. "\n" .. debug_info
end

-- Penjelasan Sintaks xpcall:
-- xpcall: Fungsi extended protected call.
-- tulisKeFilePenting: Fungsi yang akan dipanggil.
-- penanganError: Fungsi yang akan dipanggil JIKA terjadi error.
-- "/log_xpcall.txt", "konten": Argumen untuk tulisKeFilePenting.
local status_xp, hasil_xp = xpcall(tulisKeFilePenting, penanganError, "/log_xpcall.txt", "konten")

if not status_xp then
    print(hasil_xp) -- hasil_xp adalah string yang diformat oleh penanganError
end


-- 3. Recovery dari Error I/O
print("\n--- Recovery dari Error ---")
local filename_user
local file_handle
local attempts = 0

while not file_handle and attempts < 3 do
    attempts = attempts + 1
    print("\nPercobaan ke-" .. attempts)
    print("Masukkan nama file untuk dibaca:")
    filename_user = io.read()

    -- Menggunakan pcall untuk mencoba membuka file tanpa menghentikan program
    local status_buka, hasil_buka = pcall(io.open, filename_user, "r")

    if status_buka and hasil_buka then
        file_handle = hasil_buka -- hasil_buka adalah file handle jika sukses
        print("File '" .. filename_user .. "' berhasil dibuka!")
    else
        -- hasil_buka adalah pesan error jika gagal
        print("Gagal membuka file '" .. filename_user .. "'. Alasan: " .. (hasil_buka or "tidak diketahui"))
    end
end

if file_handle then
    print("Melanjutkan pemrosesan file...")
    -- ... lakukan sesuatu dengan file_handle ...
    file_handle:close()
    print("Pemrosesan selesai dan file ditutup.")
else
    print("\nGagal membuka file setelah 3 kali percobaan. Program keluar.")
end

-- Membersihkan file yang mungkin terbuat
os.remove("log.txt")
os.remove("log_tipe.txt")
```

**Penjelasan Kode `advanced_error_handling.lua`:**

- **`tulisKeFilePenting`**: Fungsi ini sengaja dibuat untuk bisa gagal. Ia menggunakan `assert` untuk error pembukaan file dan `error()` untuk error logika internal (tipe konten salah).
- **`pcall`**: Mendemonstrasikan bagaimana `pcall` bisa menangkap kedua jenis error dari `tulisKeFilePenting` tanpa menghentikan skrip. Ia mengembalikan status `false` dan pesan error.
- **`xpcall`**: Menunjukkan bagaimana `xpcall` bisa memberikan laporan error yang lebih kaya. Fungsi `penanganError` menggunakan `debug.traceback` untuk mendapatkan _stack trace_ (jejak pemanggilan fungsi), yang sangat membantu saat debugging. Pesan error yang ditampilkan ke pengguna menjadi lebih informatif.
- **Recovery**: Contoh `while` loop adalah implementasi nyata dari pemulihan error. Program tidak menyerah pada kegagalan pertama. Ia menggunakan `pcall` untuk mencoba membuka file. Jika gagal, ia memberitahu pengguna dan mengulang loop, memberi mereka kesempatan untuk memperbaiki nama file. Ini membuat program jauh lebih tangguh dan ramah pengguna.

**Sumber Referensi dari Kurikulum:**

- [TutorialsPoint: Lua Opening Files](https://www.tutorialspoint.com/lua/lua_opening_files.htm) (Sumber ini biasanya membahas berbagai cara membuka file dan kemungkinan error yang terjadi).
- Dokumentasi Resmi Lua (sumber paling otoritatif untuk fungsi-fungsi ini):
  - [`assert`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%23pdf-assert%5D(https://www.lua.org/manual/5.4/manual.html%23pdf-assert)>)
  - [`error`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%23pdf-error%5D(https://www.lua.org/manual/5.4/manual.html%23pdf-error)>)
  - [`pcall`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%23pdf-pcall%5D(https://www.lua.org/manual/5.4/manual.html%23pdf-pcall)>)
  - [`xpcall`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%23pdf-xpcall%5D(https://www.lua.org/manual/5.4/manual.html%23pdf-xpcall)>)

Dengan menguasai teknik-teknik ini, kita dapat menulis program Lua yang tidak hanya fungsional tetapi juga sangat andal dan tahan terhadap berbagai masalah yang mungkin terjadi di dunia nyata.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../complete-model-I-O/README.md
[selanjutnya]: ../bagian-4/README.md

<!----------------------------------------------------->

[0]: ../../input-output/README.md#5-error-handling-dalam-io
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
