## 8\. Error Handling dan Debugging (Penanganan Kesalahan dan Debugging)

Bagian ini akan membahas mekanisme penanganan kesalahan di Lua, cara memunculkan dan menangkap kesalahan, serta beberapa alat dasar untuk debugging kode Lua Anda. Error Handling dan Debugging. Kemampuan untuk menangani kesalahan secara efektif dan melakukan debug adalah keterampilan penting untuk membangun perangkat lunak yang andal dan stabil, termasuk plugin Neovim.

---

### 8.1 Error Types dan Handling (Jenis Kesalahan dan Penanganannya)

- **Deskripsi Konsep Error Handling:** Kesalahan (error) adalah bagian tak terhindarkan dari pengembangan perangkat lunak. Penanganan kesalahan yang baik bertujuan untuk:
  - **Mencegah Program Crash:** Menangkap kesalahan agar tidak menghentikan eksekusi seluruh program (atau dalam konteks Neovim, mengganggu editor).
  - **Memberikan Umpan Balik yang Jelas:** Memberi tahu pengguna atau developer tentang apa yang salah.
  - **Memungkinkan Pemulihan:** Jika memungkinkan, program dapat mencoba pulih dari kesalahan atau melanjutkan eksekusi dalam kondisi yang aman.
    Di Lua, ketika sebuah kesalahan terjadi, Lua biasanya akan menghentikan eksekusi dan "mengurai tumpukan" (unwind the stack), mencari _protected call_ yang mungkin menangani kesalahan tersebut. Jika tidak ada, program akan berhenti dengan pesan kesalahan.
- **Terminologi:**
  - **Error (Kesalahan):** Suatu kondisi abnormal yang terjadi selama eksekusi program.
  - **Exception (Eksepsi):** Istilah yang sering digunakan di bahasa lain untuk error; di Lua, kita biasanya hanya menyebutnya "error".
  - **Stack Traceback (Jejak Tumpukan):** Daftar pemanggilan fungsi yang mengarah ke titik di mana kesalahan terjadi, berguna untuk debugging.
  - **Protected Call (Panggilan Terlindungi):** Cara untuk memanggil fungsi sedemikian rupa sehingga jika kesalahan terjadi di dalam fungsi tersebut, kesalahan itu ditangkap dan tidak langsung menghentikan program.
- **Implementasi dalam Neovim:** Sangat penting untuk plugin. Kesalahan yang tidak tertangani dalam plugin dapat menyebabkan perilaku aneh, atau bahkan membuat Neovim tidak stabil. Gunakan `pcall` atau `xpcall` saat memanggil fungsi API Neovim yang mungkin gagal, atau saat menjalankan kode yang bergantung pada input eksternal atau konfigurasi pengguna. Untuk melaporkan kesalahan kepada pengguna, gunakan fungsi seperti `vim.notify("Pesan error", vim.log.levels.ERROR)` atau `vim.api.nvim_err_writeln("Pesan error")`.

#### Basic Error Handling (Penanganan Kesalahan Dasar)

Lua menyediakan dua fungsi utama untuk memunculkan kesalahan secara eksplisit: `error()` dan `assert()`.

- **`error(message [, level])`**
  - **Deskripsi:** Fungsi ini memunculkan (raises/throws) sebuah kesalahan. Eksekusi normal dihentikan.
  - **Sintaks:**
    - `message`: Argumen pertama, biasanya sebuah string, yang menjadi pesan kesalahan. Ini adalah nilai yang akan ditangkap oleh `pcall` atau `xpcall`.
    - `level` (opsional): Angka yang menentukan bagaimana Lua mendapatkan lokasi di mana kesalahan dilaporkan.
      - Level 1 (default): Kesalahan dilaporkan terjadi di lokasi pemanggilan fungsi `error`.
      - Level 2: Kesalahan dilaporkan terjadi di lokasi fungsi yang memanggil fungsi yang memanggil `error`.
      - Level 0: Tidak menambahkan informasi lokasi apa pun ke pesan.
- **`assert(condition [, message])`**
  - **Deskripsi:** Fungsi ini melakukan "asertasi". Jika `condition` bernilai `true` (atau nilai _truthy_ apa pun), `assert` akan mengembalikan semua argumennya (termasuk `condition` itu sendiri dan `message` jika ada). Jika `condition` bernilai `false` atau `nil`, `assert` akan memunculkan kesalahan.
  - **Sintaks:**
    - `condition`: Ekspresi yang dievaluasi.
    - `message` (opsional): Pesan yang akan digunakan jika asertasi gagal. Jika tidak disediakan, pesan default seperti "assertion failed\!" akan digunakan. Jika `condition` salah, `message` akan diteruskan ke `error()`.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (`error`): [https://www.lua.org/manual/5.1/manual.html\#pdf-error](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%23pdf-error)
  - Lua 5.1 Reference Manual (`assert`): [https://www.lua.org/manual/5.1/manual.html\#pdf-assert](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%23pdf-assert)
  - Programming in Lua, 1st ed. (Chapter 10.1 - Error Function, Chapter 10.2 - Assert and Error Messages): [https://www.lua.org/pil/10.1.html](https://www.lua.org/pil/10.1.html)

**Contoh Kode:**

```lua
-- Fungsi untuk mendemonstrasikan error
function check_value(val)
    if type(val) ~= "number" then
        -- Memunculkan error dengan pesan kustom.
        -- Level 1 (default): error dilaporkan di baris 'error(...)' ini.
        error("Argumen harus berupa angka, diterima: " .. type(val))
    end
    if val < 0 then
        -- Memunculkan error, level 2: error dilaporkan di fungsi yang memanggil check_value.
        error("Angka tidak boleh negatif.", 2)
    end
    print("Nilai valid:", val)
end

function perform_check(data)
    print("Memeriksa data:", data)
    check_value(data) -- Pemanggilan yang mungkin memunculkan error dari check_value
    print("Pemeriksaan data selesai untuk:", data)
end

-- Contoh penggunaan 'error' (baris-baris ini akan menghentikan skrip jika tidak ditangani)
-- Untuk menjalankan contoh selanjutnya, Anda mungkin perlu mengomentari pemanggilan yang menyebabkan error.

-- perform_check("hello") -- Akan memunculkan error dari level 1 di check_value
-- perform_check(-5)    -- Akan memunculkan error dari level 2, menunjuk ke baris ini di perform_check

-- Penggunaan 'assert'
local function get_config_value(key, config_table)
    -- Memastikan bahwa config_table adalah tabel.
    -- Jika tidak, assert akan memunculkan error dengan pesan yang diberikan.
    assert(type(config_table) == "table", "Argumen kedua (config_table) harus berupa tabel.")

    local value = config_table[key]
    -- Memastikan bahwa kunci ada di dalam tabel.
    assert(value ~= nil, "Kunci '" .. key .. "' tidak ditemukan dalam konfigurasi.")
    return value
end

local my_config = { host = "localhost", port = 8080 }

-- Penggunaan assert yang berhasil
local host_val = assert(my_config.host, "Host tidak ada") -- host_val akan menjadi "localhost"
print("Host:", host_val)

local port_val = get_config_value("port", my_config)
print("Port:", port_val) -- Output: Port: 8080

-- Penggunaan assert yang akan gagal (jika tidak dikomentari)
-- local user_val = get_config_value("user", my_config)
-- print("User:", user_val) -- Akan memunculkan error: Kunci 'user' tidak ditemukan...

-- local invalid_config = "not a table"
-- get_config_value("host", invalid_config) -- Akan memunculkan error: Argumen kedua ... harus berupa tabel.
```

**Cara Menjalankan Kode:**
Simpan sebagai file `.lua`. Ketika Anda menjalankan dengan `lua namafile.lua`, eksekusi akan berhenti pada panggilan `error()` atau `assert()` yang gagal pertama kali, dan pesan kesalahan akan ditampilkan di terminal. Anda perlu mengomentari panggilan yang menyebabkan error untuk melanjutkan ke contoh berikutnya dalam file yang sama.

**Penjelasan Kode Keseluruhan:**

1.  **`check_value(val)`:**
    - Memeriksa tipe `val`. Jika bukan angka, `error("Argumen harus...")` dipanggil. Ini menghentikan eksekusi dan pesan kesalahan akan menunjuk ke baris ini di `check_value`.
    - Jika `val` adalah angka tetapi negatif, `error("Angka tidak boleh...", 2)` dipanggil. `level 2` berarti pesan kesalahan akan menunjuk ke baris di fungsi yang memanggil `check_value` (yaitu, di `perform_check`).
2.  **`perform_check(data)`:** Memanggil `check_value`. Jika `check_value` memunculkan error, `perform_check` juga akan berhenti.
3.  **`get_config_value(key, config_table)`:**
    - `assert(type(config_table) == "table", ...)`: Jika `config_table` bukan tabel, error dimunculkan.
    - `assert(value ~= nil, ...)`: Jika `value` (yang diambil dari `config_table[key]`) adalah `nil` (artinya kunci tidak ada), error dimunculkan.
    - Jika kedua asertasi lolos, nilai dikembalikan.
4.  Panggilan `get_config_value` dan `assert(my_config.host, ...)` mendemonstrasikan kasus berhasil dan gagal dari `assert`.

#### Protected Calls (pcall) (Panggilan Terlindungi)

`pcall` memungkinkan Anda menjalankan fungsi dalam mode "terlindungi", sehingga jika terjadi kesalahan di dalam fungsi tersebut, kesalahan tidak menghentikan program utama tetapi ditangkap oleh `pcall`.

- **Deskripsi:** `pcall` (protected call) memanggil sebuah fungsi dalam mode terlindungi.
- **Sintaks:** `local success, result_or_error = pcall(fungsi, arg1, arg2, ...)`
  - `fungsi`: Fungsi yang akan dipanggil.
  - `arg1, arg2, ...`: Argumen-argumen yang akan diteruskan ke `fungsi`.
  - **Nilai Kembali `pcall`:**
    - Jika `fungsi` berjalan tanpa kesalahan: `pcall` mengembalikan `true` sebagai `success`, diikuti oleh semua nilai yang dikembalikan oleh `fungsi` (sebagai `result_or_error` dan seterusnya).
    - Jika terjadi kesalahan di dalam `fungsi`: `pcall` mengembalikan `false` sebagai `success`, diikuti oleh objek kesalahan (biasanya string pesan kesalahan) sebagai `result_or_error`.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (`pcall`): [https://www.lua.org/manual/5.1/manual.html\#pdf-pcall](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%23pdf-pcall)
  - Programming in Lua, 1st ed. (Chapter 10.3 - Protected Calls): [https://www.lua.org/pil/10.3.html](https://www.google.com/search?q=https://www.lua.org/pil/10.3.html)

**Contoh Kode:**

```lua
local function risky_function_success()
    print("Di dalam risky_function_success: berjalan lancar.")
    return "Operasi berhasil", 100
end

local function risky_function_failure()
    print("Di dalam risky_function_failure: akan memunculkan error.")
    error("Sesuatu yang buruk terjadi di sini!")
    return "Ini tidak akan pernah dikembalikan" -- Kode setelah error tidak dieksekusi
end

print("--- Memanggil pcall dengan fungsi yang berhasil ---")
-- Memanggil risky_function_success menggunakan pcall.
-- Tidak ada argumen yang diteruskan ke risky_function_success.
local success1, val1, val2 = pcall(risky_function_success)
if success1 then
    print("pcall berhasil!")
    print("Nilai kembali 1:", val1) -- Output: Operasi berhasil
    print("Nilai kembali 2:", val2) -- Output: 100
else
    print("pcall gagal. Kesalahan:", val1) -- val1 akan menjadi pesan error
end

print("\n--- Memanggil pcall dengan fungsi yang gagal ---")
-- Memanggil risky_function_failure menggunakan pcall.
local success2, err_msg = pcall(risky_function_failure)
if success2 then
    print("pcall berhasil (ini tidak diharapkan). Hasil:", err_msg)
else
    print("pcall gagal seperti yang diharapkan!")
    print("Pesan Kesalahan yang Ditangkap:", err_msg) -- Output: Sesuatu yang buruk terjadi di sini!
end

print("\n--- Memanggil pcall dengan argumen untuk fungsi target ---")
local function divide(a, b)
    if b == 0 then
        error("Pembagian dengan nol tidak diizinkan.")
    end
    return a / b
end

-- Memanggil 'divide(10, 2)' melalui pcall
local success3, result3 = pcall(divide, 10, 2)
if success3 then
    print("Pembagian 10/2 berhasil. Hasil:", result3) -- Output: Hasil: 5
else
    print("Pembagian 10/2 gagal. Kesalahan:", result3)
end

-- Memanggil 'divide(10, 0)' melalui pcall
local success4, error_obj = pcall(divide, 10, 0)
if success4 then
    print("Pembagian 10/0 berhasil. Hasil:", error_obj)
else
    print("Pembagian 10/0 gagal seperti yang diharapkan.")
    print("Kesalahan yang Ditangkap:", error_obj) -- Output: Pembagian dengan nol tidak diizinkan.
end
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya. Kali ini, skrip tidak akan berhenti karena `pcall` menangkap kesalahan.

**Penjelasan Kode Keseluruhan:**

1.  **`risky_function_success()` dan `risky_function_failure()`:** Dua fungsi demo, satu berhasil dan satu gagal dengan `error()`.
2.  `local success1, val1, val2 = pcall(risky_function_success)`:
    - `pcall` memanggil `risky_function_success`.
    - Karena berhasil, `success1` menjadi `true`. `val1` menjadi `"Operasi berhasil"`, dan `val2` menjadi `100` (nilai-nilai yang dikembalikan oleh `risky_function_success`).
3.  `local success2, err_msg = pcall(risky_function_failure)`:
    - `pcall` memanggil `risky_function_failure`.
    - Karena `risky_function_failure` memunculkan error, `success2` menjadi `false`. `err_msg` menjadi string pesan error (`"Sesuatu yang buruk terjadi di sini!"`).
4.  `pcall(divide, 10, 2)` dan `pcall(divide, 10, 0)`:
    - Mendemonstrasikan bagaimana argumen (`10`, `2` atau `10`, `0`) diteruskan ke fungsi `divide` melalui `pcall`.
    - Kasus pertama berhasil, kasus kedua gagal dan `pcall` menangkap error "Pembagian dengan nol...".

#### xpcall for Advanced Error Handling (xpcall untuk Penanganan Kesalahan Tingkat Lanjut)

`xpcall` mirip dengan `pcall`, tetapi memungkinkan Anda menyediakan fungsi _handler_ kesalahan kustom.

- **Deskripsi:** `xpcall` (extended protected call) memanggil fungsi dalam mode terlindungi dan menyediakan fungsi _handler_ kesalahan.
- **Sintaks:** `local success, result_or_handler_return = xpcall(fungsi, fungsi_handler_error, arg1_fungsi, arg2_fungsi, ...)`
  - `fungsi`: Fungsi utama yang akan dipanggil.
  - `fungsi_handler_error`: Fungsi yang akan dipanggil jika terjadi kesalahan di dalam `fungsi`. Fungsi handler ini menerima satu argumen: objek kesalahan yang dimunculkan.
  - `arg1_fungsi, ...`: Argumen untuk `fungsi` utama (jika ada).
  - **Nilai Kembali `xpcall`:**
    - Jika `fungsi` berjalan tanpa kesalahan: `xpcall` mengembalikan `true` sebagai `success`, diikuti oleh semua nilai yang dikembalikan oleh `fungsi`.
    - Jika terjadi kesalahan di dalam `fungsi`: `fungsi_handler_error` dipanggil dengan objek kesalahan. `xpcall` kemudian mengembalikan `false` sebagai `success`, diikuti oleh nilai apa pun yang dikembalikan oleh `fungsi_handler_error`.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (`xpcall`): [https://www.lua.org/manual/5.1/manual.html\#pdf-xpcall](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%23pdf-xpcall)
  - Programming in Lua, 1st ed. (Chapter 10.4 - Error Handling and Diagnostics, mentions xpcall): [https://www.lua.org/pil/10.4.html](https://www.google.com/search?q=https://www.lua.org/pil/10.4.html)

**Contoh Kode:**

```lua
local function my_risky_operation()
    print("Di dalam my_risky_operation: akan memunculkan error.")
    error("Terjadi kesalahan yang sangat spesifik!")
end

-- Fungsi handler kesalahan kustom
-- Menerima objek kesalahan (err_obj) sebagai argumen.
local function my_error_handler(err_obj)
    print("--- Handler Kesalahan Kustom Dipanggil ---")
    print("Sebuah kesalahan terjadi. Objek kesalahan:", err_obj)
    print("Mencetak jejak tumpukan (stack traceback):")
    -- debug.traceback() menghasilkan string jejak tumpukan.
    -- Argumen kedua '2' untuk traceback agar dimulai dari fungsi sebelum handler ini.
    local trace = debug.traceback("Jejak:", 2)
    print(trace)
    print("--- Akhir Handler Kesalahan Kustom ---")
    -- Nilai yang dikembalikan oleh handler ini akan menjadi nilai kedua yang dikembalikan oleh xpcall.
    return "Kesalahan telah ditangani oleh handler kustom. Pesan asli: " .. tostring(err_obj)
end

print("--- Memanggil xpcall ---")
-- Memanggil my_risky_operation dengan my_error_handler.
-- Tidak ada argumen yang diteruskan ke my_risky_operation.
local success, result_from_xpcall = xpcall(my_risky_operation, my_error_handler)

if success then
    print("xpcall berhasil (tidak diharapkan). Hasil:", result_from_xpcall)
else
    print("xpcall gagal seperti yang diharapkan.")
    print("Hasil dari handler kesalahan (yang dikembalikan oleh xpcall):", result_from_xpcall)
end

-- Contoh xpcall dengan fungsi yang berhasil (handler tidak akan dipanggil)
local function safe_operation()
    print("Di dalam safe_operation: berjalan lancar.")
    return "Sukses besar!"
end

local success_safe, result_safe = xpcall(safe_operation, my_error_handler)
if success_safe then
    print("\nxpcall dengan safe_operation berhasil:")
    print("Hasil:", result_safe)
else
    print("\nxpcall dengan safe_operation gagal (tidak diharapkan).")
end
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya. `debug.traceback()` akan memberikan output yang detail.

**Penjelasan Kode Keseluruhan:**

1.  **`my_risky_operation()`:** Fungsi yang sengaja memunculkan error.
2.  **`my_error_handler(err_obj)`:**
    - Ini adalah fungsi yang akan dipanggil oleh `xpcall` jika `my_risky_operation` gagal.
    - Ia menerima objek kesalahan (`err_obj`) sebagai argumen.
    - Mencetak pesan kustom dan menggunakan `debug.traceback("Jejak:", 2)` untuk mendapatkan dan mencetak jejak tumpukan yang lebih detail. Argumen `2` pada `traceback` membantu menghilangkan frame panggilan handler itu sendiri dari jejak.
    - Mengembalikan string yang akan menjadi nilai hasil kedua dari `xpcall`.
3.  `local success, result_from_xpcall = xpcall(my_risky_operation, my_error_handler)`:
    - Memanggil `my_risky_operation`. Karena error terjadi, `my_error_handler` dipanggil dengan pesan error ("Terjadi kesalahan yang sangat spesifik\!").
    - `success` akan menjadi `false`.
    - `result_from_xpcall` akan menjadi nilai yang dikembalikan oleh `my_error_handler` (yaitu, string "Kesalahan telah ditangani...").
4.  Contoh dengan `safe_operation` menunjukkan bahwa jika tidak ada error, `xpcall` berperilaku mirip `pcall` (handler tidak dipanggil), mengembalikan `true` dan hasil dari fungsi utama.

---

### 8.2 Debugging Tools (Alat Debugging)

Lua menyediakan pustaka `debug` standar yang menawarkan beberapa fungsi untuk introspeksi dan debugging.

- **Deskripsi Konsep Debugging:** Debugging adalah proses menemukan dan memperbaiki kesalahan dalam kode. Selain menggunakan `print` untuk melacak nilai variabel, pustaka `debug` menyediakan cara yang lebih terprogram untuk memeriksa state program.

- **Implementasi dalam Neovim:** Pustaka `debug` dapat digunakan di dalam plugin Neovim. `debug.traceback()` sangat berguna untuk dicatat atau ditampilkan ketika error yang tidak terduga ditangkap. Fungsi seperti `debug.getlocal` lebih untuk skenario debugging tingkat lanjut atau saat membangun alat developer. Neovim juga memiliki fitur inspeksi sendiri (misalnya `:lua vim.print(...)` untuk mencetak tabel dengan baik, atau integrasi dengan debugger eksternal melalui DAP).

- **Sumber Dokumentasi Lua:**

  - Lua 5.1 Reference Manual (Debug Library): [https://www.lua.org/manual/5.1/manual.html\#5.9](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%235.9)
  - Programming in Lua, 1st ed. (Chapter 23 - The Debug Library): [https://www.lua.org/pil/23.html](https://www.lua.org/pil/23.html)

- **`debug.traceback ([thread,] [message [, level]])`**

  - **Deskripsi:** Mengembalikan string yang berisi jejak tumpukan panggilan (stack traceback).
  - **Sintaks:**
    - `thread` (opsional): Thread coroutine target (jarang digunakan secara langsung).
    - `message` (opsional): String yang akan ditambahkan di awal traceback.
    - `level` (opsional): Angka yang menentukan pada level tumpukan mana traceback dimulai.

- **`debug.getlocal ([thread,] level, local_index)`**

  - **Deskripsi:** Mengembalikan nama dan nilai dari variabel lokal dengan `local_index` pada fungsi di `level` tumpukan panggilan tertentu.
  - **Sintaks:**
    - `level`: Level tumpukan (1 adalah fungsi saat ini, 2 adalah fungsi yang memanggil fungsi saat ini, dst.).
    - `local_index`: Indeks variabel lokal (variabel lokal diindeks sesuai urutan kemunculannya dalam kode). Variabel parameter juga dihitung. Indeks positif untuk variabel reguler, negatif untuk varargs temporer.

**Contoh Kode:**

```lua
-- Menggunakan debug.traceback()
function func_c()
    print("Di dalam func_c. Mencetak traceback saat ini:")
    -- Mencetak traceback dari titik ini.
    -- Level 0: dimulai dari traceback itu sendiri.
    -- Level 1: dimulai dari func_c.
    print(debug.traceback("Trace dari func_c:", 0))
end

function func_b()
    print("Di dalam func_b.")
    func_c()
end

function func_a()
    print("Di dalam func_a.")
    func_b()
end

print("--- Memanggil func_a untuk melihat traceback ---")
func_a()

-- Menggunakan debug.getlocal() untuk inspeksi variabel lokal
local global_val_for_debug = "Saya global"

function inspect_my_locals(param1, param2)
    local local_str = "Halo Lokal"
    local local_num = 123
    local local_bool = true

    print("\n--- Inspeksi Variabel Lokal di dalam inspect_my_locals ---")
    -- Menginspeksi variabel lokal dari fungsi ini sendiri (level 1)
    local i = 1
    while true do
        -- debug.getlocal(level_tumpukan, indeks_variabel_lokal)
        -- Level 1 adalah fungsi saat ini (inspect_my_locals)
        local name, value = debug.getlocal(1, i)
        if not name then
            break -- Tidak ada lagi variabel lokal pada indeks ini
        end
        print(string.format("Lokal %d: Nama='%s', Tipe='%s', Nilai='%s'", i, name, type(value), tostring(value)))
        i = i + 1
    end
end

print("\n--- Memanggil inspect_my_locals ---")
inspect_my_locals("arg1", true)

-- Fungsi untuk menginspeksi lokal dari pemanggilnya
function inspect_callers_locals()
    print("\n--- Inspeksi Variabel Lokal dari Pemanggil (level 2) ---")
    local i = 1
    while true do
        -- Level 2 adalah fungsi yang memanggil inspect_callers_locals
        local name, value = debug.getlocal(2, i)
        if not name then
            break
        end
        print(string.format("Lokal Pemanggil %d: Nama='%s', Tipe='%s', Nilai='%s'", i, name, type(value), tostring(value)))
        i = i + 1
    end
end

function outer_function_for_caller_inspection()
    local outer_var1 = "Variabel luar 1"
    local outer_var2 = { key = "value" }
    inspect_callers_locals() -- inspect_callers_locals akan melihat outer_var1 dan outer_var2
end

print("\n--- Memanggil outer_function_for_caller_inspection ---")
outer_function_for_caller_inspection()
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya. Perhatikan output dari `debug.traceback()` dan `debug.getlocal()`.

**Penjelasan Kode Keseluruhan:**

1.  **`func_c()`, `func_b()`, `func_a()`:** Rangkaian pemanggilan fungsi untuk mendemonstrasikan `debug.traceback()`. Ketika `func_c()` dipanggil, ia mencetak jejak tumpukan yang menunjukkan urutan pemanggilan: `func_a` memanggil `func_b`, yang memanggil `func_c`.
2.  **`inspect_my_locals(param1, param2)`:**
    - Fungsi ini mendefinisikan beberapa parameter dan variabel lokal.
    - Loop `while true` dengan `debug.getlocal(1, i)` digunakan untuk mengiterasi dan mencetak semua variabel lokal yang ada di dalam `inspect_my_locals` itu sendiri (level 1). Ini termasuk parameter (`param1`, `param2`) dan variabel lokal yang didefinisikan (`local_str`, `local_num`, `local_bool`, dan `i` dari loop itu sendiri).
3.  **`inspect_callers_locals()` dan `outer_function_for_caller_inspection()`:**
    - `inspect_callers_locals` menggunakan `debug.getlocal(2, i)` untuk melihat variabel lokal dari fungsi yang memanggilnya (level 2).
    - Ketika `outer_function_for_caller_inspection` memanggil `inspect_callers_locals`, maka `inspect_callers_locals` akan dapat melihat dan mencetak variabel lokal `outer_var1` dan `outer_var2` dari `outer_function_for_caller_inspection`.

Pustaka `debug` bisa sangat membantu, tetapi seringkali untuk debugging plugin Neovim, kombinasi `print` yang cerdas, `vim.notify`, dan mungkin alat debugging eksternal (jika masalahnya sangat kompleks) lebih umum digunakan. Namun, mengetahui keberadaan `debug` library adalah aset.
