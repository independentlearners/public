# **[7\. Modules dan Package Management (Modul dan Manajemen Paket)][1]**

Seiring dengan bertambahnya kompleksitas program, penting untuk memecah kode menjadi unit-unit yang lebih kecil dan terkelola. Lua menyediakan sistem modul sederhana namun kuat untuk tujuan ini. Modules dan Package Management. Ini adalah aspek penting dalam pengembangan perangkat lunak yang lebih besar, termasuk plugin Neovim, karena membantu mengorganisir kode menjadi bagian-bagian yang logis dan dapat digunakan kembali.

---

### 7.1 Module System (Sistem Modul)

- **Deskripsi Konsep Modul:** Modul di Lua adalah sebuah cara untuk mengelompokkan fungsi, variabel, dan data terkait ke dalam satu unit logis, biasanya dalam sebuah file Lua. Modul membantu dalam:
  - **Organisasi Kode:** Memecah kode menjadi bagian-bagian yang lebih kecil dan fokus.
  - **Enkapsulasi:** Menyembunyikan detail implementasi internal dan hanya mengekspos antarmuka publik (fungsi dan data yang relevan). Ini dicapai dengan menggunakan variabel lokal di dalam file modul untuk hal-hal yang bersifat privat.
  - **Namespace Management:** Mencegah polusi namespace global karena variabel dan fungsi dalam modul biasanya bersifat lokal atau diakses melalui tabel modul.
  - **Reuse (Penggunaan Kembali):** Modul dapat diimpor dan digunakan oleh bagian lain dari program atau oleh program lain.
- **`require` function:** Fungsi global `require` adalah cara utama untuk memuat dan menggunakan modul di Lua.
  - Ketika Anda memanggil `require('nama_modul')`, Lua akan mencari file modul tersebut.
  - Setelah ditemukan, Lua akan mengeksekusi file modul tersebut **hanya sekali**. Hasil yang dikembalikan oleh file modul (biasanya sebuah tabel) akan disimpan dalam cache (di `package.loaded`).
  - Panggilan `require` berikutnya untuk modul yang sama akan mengembalikan hasil yang sudah di-cache tersebut tanpa mengeksekusi ulang file modul.
- **Terminologi:**
  - **Module (Modul):** Sebuah file Lua yang mengembalikan sebuah nilai (biasanya tabel) yang berisi fungsionalitas yang diekspor.
  - **Package (Paket):** Secara umum merujuk pada koleksi modul. Di Lua, `package` juga merupakan nama pustaka standar yang menyediakan fungsi untuk sistem modul (misalnya, `package.path`).
- **Implementasi dalam Neovim:** Struktur plugin Neovim modern sangat bergantung pada sistem modul Lua. Setiap plugin biasanya merupakan satu atau lebih modul. Konfigurasi pengguna seringkali memanggil fungsi `setup` dari modul utama plugin.
  - Misalnya, plugin bernama `my-cool-plugin` mungkin memiliki struktur file `lua/my-cool-plugin/init.lua` (modul utama) dan `lua/my-cool-plugin/utils.lua` (modul utilitas).
  - Pengguna akan memuatnya dengan `require('my-cool-plugin')` (yang memuat `init.lua`) atau `require('my-cool-plugin.utils')`.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (Modules): [https://www.lua.org/manual/5.1/manual.html\#5.3](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%235.3) (Mencakup `require`)
  - Programming in Lua, 1st ed. (Chapter 8 - Modules and Packages): [https://www.lua.org/pil/8.html](https://www.lua.org/pil/8.html)

#### Creating Modules (Membuat Modul)

Pola umum untuk membuat modul di Lua adalah:

1.  Buat tabel lokal (misalnya, `local M = {}`). Tabel ini akan menjadi "namespace" untuk modul dan akan berisi semua fungsi dan variabel yang ingin Anda ekspor.
2.  Definisikan fungsi dan variabel publik sebagai field dari tabel modul ini (misalnya, `function M.namaFungsi() ... end` atau `M.konstanta = nilai`).
3.  Fungsi atau variabel yang bersifat privat untuk modul (tidak ingin diekspos) dapat dideklarasikan sebagai `local` di dalam file modul dan tidak ditambahkan ke tabel modul `M`.
4.  Di akhir file modul, kembalikan tabel modul tersebut (`return M`).

<!-- end list -->

- **Sintaks Per Baris (Elemen Kunci dalam Pembuatan Modul):**
  - `local M = {}`: Mendeklarasikan tabel lokal `M` yang akan menjadi antarmuka publik modul. Nama `M` adalah konvensi, bisa nama lain.
  - `local function private_helper() ... end`: Fungsi helper yang bersifat lokal untuk file modul ini, tidak dapat diakses dari luar modul secara langsung.
  - `function M.add(a, b) ... end`: Mendefinisikan fungsi `add` sebagai field dari tabel `M`. Ini akan menjadi bagian dari antarmuka publik modul.
  - `M.PI = 3.14159`: Mendefinisikan konstanta `PI` sebagai field dari tabel `M`.
  - `return M`: Mengembalikan tabel `M`. Nilai inilah yang akan diterima oleh kode yang memanggil `require` untuk modul ini.

**Contoh Kode (Pembuatan Modul):**

File: `math_utils.lua`

```lua
-- file: math_utils.lua

-- 1. Buat tabel lokal untuk modul.
local M = {}

-- 2. Fungsi helper internal (privat untuk modul ini).
-- Tidak ditambahkan ke tabel M, jadi tidak bisa diakses dari luar.
local function private_log(message)
    print("[math_utils LOG]: " .. message)
end

-- 3. Definisikan fungsi publik sebagai field dari tabel M.
function M.add(a, b)
    private_log("Melakukan operasi penjumlahan.")
    return a + b
end

function M.multiply(a, b)
    private_log("Melakukan operasi perkalian.")
    return a * b
end

-- 4. Definisikan variabel/konstanta publik.
M.PI = 3.1415926535

-- 5. Kembalikan tabel modul di akhir file.
return M
```

**Cara Menjalankan Kode (Modul itu sendiri tidak "dijalankan" secara langsung, tetapi digunakan oleh file lain):**
Modul `math_utils.lua` di atas tidak akan menghasilkan output jika dijalankan sendiri (`lua math_utils.lua`) kecuali fungsi-fungsinya dipanggil. Ia dirancang untuk diimpor oleh file Lua lain.

**Penjelasan Kode Keseluruhan (`math_utils.lua`):**

- Kode ini mendefinisikan modul bernama `math_utils`.
- `local M = {}`: Membuat tabel yang akan menjadi "wadah" untuk semua hal yang ingin diekspos oleh modul ini.
- `local function private_log(message) ... end`: Ini adalah fungsi lokal. Karena tidak di-assign ke `M`, ia hanya dapat digunakan di dalam file `math_utils.lua` ini saja (misalnya, oleh `M.add` dan `M.multiply`). Ini adalah contoh enkapsulasi.
- `function M.add(a, b) ... end` dan `function M.multiply(a, b) ... end`: Ini adalah fungsi publik dari modul. Mereka ditambahkan sebagai field ke tabel `M`.
- `M.PI = 3.1415926535`: Ini adalah konstanta publik dari modul.
- `return M`: Baris ini sangat penting. Ketika file lain melakukan `require('math_utils')`, nilai yang dikembalikan oleh `require` adalah tabel `M` ini.

#### Using Modules (Menggunakan Modul)

Untuk menggunakan modul yang telah dibuat, Anda menggunakan fungsi `require()`.

- **Sintaks Per Baris (Elemen Kunci dalam Penggunaan Modul):**
  - `local nama_variabel_modul = require('nama_file_modul_tanpa_ekstensi')`: Memuat modul. `require` akan mencari file `nama_file_modul_tanpa_ekstensi.lua` (atau variasi lain tergantung `package.path` dan `package.cpath`). Jika berhasil, nilai yang dikembalikan oleh modul (tabel `M` dalam contoh kita) akan di-assign ke `nama_variabel_modul`.
  - `nama_variabel_modul.nama_fungsi_publik()`: Memanggil fungsi publik dari modul yang telah dimuat.
  - `local fungsi_tertentu = require('nama_modul').nama_fungsi_publik`: Cara untuk "mengimpor" hanya fungsi tertentu ke dalam variabel lokal untuk akses yang lebih mudah, meskipun ini hanya mengambil referensi ke fungsi tersebut dari tabel modul yang tetap dimuat sepenuhnya.

**Contoh Kode (Penggunaan Modul):**

File: `main_program.lua` (harus berada di direktori yang sama dengan `math_utils.lua` agar `require` menemukannya dengan mudah tanpa konfigurasi `package.path` tambahan)

```lua
-- file: main_program.lua

-- Cara 1: Memuat seluruh modul dan menyimpannya dalam variabel lokal.
-- 'math_utils' (variabel lokal) sekarang akan merujuk ke tabel M yang dikembalikan oleh 'math_utils.lua'.
print("Mencoba me-require 'math_utils'...")
local math_utils_module = require('math_utils') -- Nama modul tanpa ekstensi .lua

-- Memeriksa apakah modul berhasil dimuat
if math_utils_module then
    print("Modul 'math_utils' berhasil dimuat.")

    -- Menggunakan fungsi dan variabel dari modul
    local sum_result = math_utils_module.add(15, 7)
    print("15 + 7 =", sum_result) -- Output: [math_utils LOG]: Melakukan operasi penjumlahan.
                                 -- Output: 15 + 7 = 22

    local product_result = math_utils_module.multiply(6, 4)
    print("6 * 4 =", product_result) -- Output: [math_utils LOG]: Melakukan operasi perkalian.
                                     -- Output: 6 * 4 = 24

    print("Nilai PI dari modul:", math_utils_module.PI) -- Output: Nilai PI dari modul: 3.1415926535

    -- Mencoba mengakses fungsi privat (akan error jika tidak dikomentari)
    -- math_utils_module.private_log("Tes") -- Error: private_log adalah nil (tidak ada di tabel M)
else
    print("Gagal memuat modul 'math_utils'.")
end

print("--- Cara 2: Mengimpor fungsi spesifik secara manual ---")
-- 'require' tetap memuat seluruh modul dan mengembalikan tabelnya.
-- Kita hanya mengambil referensi ke fungsi 'add' dari tabel tersebut.
local add_func = require('math_utils').add
local multiply_func = require('math_utils').multiply -- require akan mengembalikan tabel yang sudah di-cache

local result_add_specific = add_func(100, 200)
print("100 + 200 (fungsi spesifik):", result_add_specific) -- Output: [math_utils LOG]: Melakukan operasi penjumlahan.
                                                          -- Output: 100 + 200 (fungsi spesifik): 300

local result_mult_specific = multiply_func(5,5)
print("5 * 5 (fungsi spesifik):", result_mult_specific)   -- Output: [math_utils LOG]: Melakukan operasi perkalian.
                                                          -- Output: 5 * 5 (fungsi spesifik): 25
```

**Cara Menjalankan Kode (Kedua File):**

1.  Pastikan kedua file (`math_utils.lua` dan `main_program.lua`) berada dalam direktori yang sama.
2.  Buka terminal di direktori tersebut.
3.  Jalankan file utama: `lua main_program.lua`.
    Output dari `private_log` di dalam `math_utils` akan muncul karena fungsi publiknya memanggilnya.

**Penjelasan Kode Keseluruhan (`main_program.lua`):**

- `local math_utils_module = require('math_utils')`: Memanggil fungsi `require` dengan nama modul `'math_utils'`. Lua akan mencari file `math_utils.lua` (atau `math_utils/init.lua`, dll., tergantung `package.path`). Jika ditemukan, file tersebut dieksekusi. Tabel `M` yang dikembalikan oleh `math_utils.lua` di-assign ke `math_utils_module`.
- `math_utils_module.add(15, 7)`: Memanggil fungsi `add` yang merupakan field dari tabel `math_utils_module`.
- `math_utils_module.PI`: Mengakses field `PI` dari tabel `math_utils_module`.
- `local add_func = require('math_utils').add`: Ini adalah cara lain untuk menggunakan modul. `require('math_utils')` akan (dalam kasus ini) mengembalikan tabel `M` yang sudah di-cache dari pemanggilan `require` sebelumnya. Kemudian, `.add` mengambil referensi ke fungsi `add` dari tabel tersebut dan menyimpannya di `add_func`. Ini berguna jika Anda hanya ingin menggunakan satu atau dua fungsi dari modul besar dan ingin nama yang lebih pendek.

---

### 7.2 Package Path dan Loading (Jalur Paket dan Pemuatan)

`require` tidak secara ajaib menemukan file. Ia menggunakan strategi pencarian berdasarkan path yang dikonfigurasi.

- **Deskripsi:** Lua menggunakan variabel dalam tabel `package` untuk mengontrol bagaimana modul dicari dan dimuat.

  - **`package.path`:** String yang berisi urutan _pola_ pencarian untuk file modul Lua, dipisahkan oleh titik koma (`;`). Setiap pola berisi tanda tanya (`?`) yang akan digantikan oleh `require` dengan nama modul yang diminta (dengan titik `.` dalam nama modul diganti dengan pemisah direktori sistem operasi, misalnya `/`).
  - **`package.cpath`:** Serupa dengan `package.path`, tetapi digunakan untuk mencari file modul C (pustaka dinamis).
  - **`package.loaded`:** Tabel yang digunakan oleh `require` untuk menyimpan cache modul yang telah dimuat. Kuncinya adalah nama modul, dan nilainya adalah hasil yang dikembalikan oleh modul. Jika `require('modul')` dipanggil dan `package.loaded['modul']` sudah ada, nilai yang di-cache ini akan langsung dikembalikan.
  - **`package.preload`:** Tabel di mana Anda dapat mendaftarkan fungsi _loader_ kustom untuk modul tertentu. Jika `require('modul')` dipanggil dan `package.preload['modul']` ada (dan merupakan fungsi), fungsi tersebut akan dipanggil untuk memuat modul, mengabaikan `package.path`.

- **Implementasi dalam Neovim:** Neovim secara otomatis mengkonfigurasi `package.path` untuk menyertakan direktori `lua/` dari semua direktori runtimepath Anda (termasuk direktori plugin Anda). Inilah sebabnya mengapa `require('my-plugin.utils')` dapat menemukan file `lua/my-plugin/utils.lua` di dalam direktori plugin Anda. Memahami `package.path` bisa berguna jika Anda perlu memuat modul dari lokasi non-standar atau saat men-debug masalah pemuatan modul.

- **Sintaks Per Baris (Elemen Kunci):**

  - `print(package.path)`: Mencetak string `package.path` saat ini.
  - `package.path = package.path .. ";/jalur/kustom/anda/?.lua"`: Menambahkan jalur pencarian kustom ke `package.path`. Perhatikan penggunaan `?.lua` sebagai pola.
  - `print(package.loaded["nama_modul"])`: Memeriksa apakah `nama_modul` sudah dimuat dan apa nilai yang dikembalikannya.

**Contoh Kode:**

```lua
-- Melihat package.path saat ini
print("--- package.path Awal ---")
print(package.path)
-- Outputnya akan bervariasi tergantung instalasi Lua Anda dan apakah dijalankan di Neovim.
-- Contoh output Lua standar mungkin: ./?.lua;/usr/local/share/lua/5.1/?.lua;...

-- Menambah custom path (ini hanya berlaku untuk sesi Lua saat ini)
-- Misalnya, Anda memiliki modul di direktori '../my_modules' relatif terhadap skrip saat ini
-- atau direktori absolut.
-- Tanda ';' memisahkan path. '?' adalah placeholder untuk nama modul.
-- Catatan: Mengubah package.path secara programatik mungkin bukan praktik terbaik untuk distribusi plugin,
-- lebih baik mengandalkan struktur direktori standar yang dipahami Neovim.
-- Ini lebih untuk pemahaman atau skrip lokal.

-- Contoh (jika Anda membuat direktori /tmp/custom_lua_modules/ dan file test_mod.lua di sana):
-- File: /tmp/custom_lua_modules/test_mod.lua
--   local M = {}
--   function M.greet() print("Hello from test_mod in custom path!") end
--   return M

-- package.path = package.path .. ";/tmp/custom_lua_modules/?.lua"
-- print("\n--- package.path Setelah Ditambah ---")
-- print(package.path)

-- local test_module
-- local success, err = pcall(function() test_module = require('test_mod') end)
-- if success and test_module then
--     test_module.greet()
-- else
--     print("Gagal memuat test_mod:", err)
-- end


-- Melihat modul yang sudah dimuat (setelah me-require math_utils dari contoh sebelumnya)
print("\n--- package.loaded ---")
-- Jika main_program.lua (yang me-require 'math_utils') sudah dijalankan dalam sesi yang sama
-- atau jika Anda menjalankan ini setelah require:
local mu_status = package.loaded["math_utils"]
if mu_status then
    print("'math_utils' ada di package.loaded.")
    -- mu_status akan menjadi tabel M yang dikembalikan oleh math_utils.lua
    print("PI dari package.loaded['math_utils']:", mu_status.PI)
else
    print("'math_utils' TIDAK ADA di package.loaded (mungkin belum di-require).")
end

-- Contoh dengan package.preload (jarang digunakan secara langsung oleh pengguna akhir)
package.preload["my_preloaded_module"] = function()
    print("Fungsi loader dari package.preload untuk 'my_preloaded_module' dipanggil.")
    local M_preload = {}
    M_preload.message = "Ini dari modul yang di-preload!"
    return M_preload
end

local preloaded_mod = require("my_preloaded_module")
print(preloaded_mod.message)

-- Jika Anda memanggil require lagi, fungsi loader tidak akan dipanggil lagi
local preloaded_mod_again = require("my_preloaded_module")
print("PI dari package.loaded['my_preloaded_module'] message:", preloaded_mod_again.message)
```

**Cara Menjalankan Kode:**
Simpan sebagai file `.lua`. Untuk bagian yang mencoba memuat dari `/tmp/custom_lua_modules/`, Anda perlu membuat direktori dan file tersebut agar berhasil.
Jika Anda menjalankan ini setelah menjalankan `main_program.lua` dalam interpreter Lua interaktif yang sama, `package.loaded["math_utils"]` akan ada. Jika dijalankan sebagai skrip terpisah, `math_utils` mungkin belum dimuat kecuali skrip ini juga me-`require`-nya.

**Penjelasan Kode Keseluruhan:**

- `print(package.path)`: Menampilkan string jalur pencarian yang digunakan `require` untuk modul Lua. Formatnya adalah daftar pola yang dipisahkan titik koma.
- Baris yang dikomentari untuk menambahkan jalur kustom menunjukkan bagaimana Anda bisa memperluas `package.path` untuk menyertakan direktori lain. `pcall` digunakan untuk menangani error jika modul tidak ditemukan.
- `package.loaded["math_utils"]`: Mengakses tabel `package.loaded` untuk melihat apakah modul `math_utils` sudah ada di cache. Jika sudah, nilainya adalah tabel yang dikembalikan oleh modul tersebut.
- `package.preload["my_preloaded_module"] = function() ... end`: Mendaftarkan fungsi _loader_ kustom untuk modul bernama `my_preloaded_module`. Ketika `require("my_preloaded_module")` dipanggil untuk pertama kali, fungsi ini akan dieksekusi, dan hasilnya akan di-cache di `package.loaded["my_preloaded_module"]`. Panggilan `require` berikutnya akan mengembalikan nilai yang di-cache.

---

Sistem modul Lua, meskipun sederhana, sangat efektif untuk membangun aplikasi yang terstruktur dan dapat dipelihara. Dalam konteks Neovim, ini adalah cara standar untuk mengatur kode plugin Anda.

> - **[Ke Atas](#)**
> - **[Selanjutnya][4]**
> - **[Sebelumnya][3]**
> - **[Kurikulum][2]**
> - **[Domain Spesifik][5]**

[5]: ../../../../../../../README.md
[1]: ../../README.md/#7-modules-dan-package-management
[2]: ../../../../../README.md
[3]: ../../module/6-oop/README.md
[4]: ../../module/8-error-handling-dan-debugging/README.md
