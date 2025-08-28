# **[2\. Tipe Data dan Variabel][2]**

Memahami tipe data dan cara kerja variabel adalah fundamental dalam mempelajari bahasa pemrograman apa pun, termasuk Lua. Lua memiliki sistem tipe data yang dinamis dan beberapa tipe data primitif yang akan kita bahas.

---

### 2.1 Tipe Data Primitif

Tipe data primitif adalah tipe data dasar yang disediakan oleh bahasa pemrograman. Lua memiliki beberapa tipe data primitif utama: `nil`, `boolean`, `number`, dan `string`.

#### Nil

- **Deskripsi:** `nil` adalah tipe data khusus di Lua yang hanya memiliki satu nilai, yaitu `nil`. Tipe ini digunakan untuk merepresentasikan "tidak adanya nilai", "kosong", atau "tidak terdefinisi". Variabel yang belum diberi nilai secara eksplisit akan memiliki nilai `nil` secara default. `nil` juga sering digunakan untuk menandakan ketiadaan hasil yang bermakna dari suatu operasi atau untuk menghapus variabel dari _scope_.
- **Terminologi:**
  - **Nil:** Secara harfiah berarti "tidak ada" atau "nol".
- **Implementasi dalam Neovim:** Dalam pengembangan plugin Neovim, `nil` sering digunakan untuk memeriksa apakah suatu konfigurasi telah diatur oleh pengguna, apakah suatu fungsi mengembalikan hasil yang valid, atau untuk mengindikasikan bahwa suatu sumber daya tidak tersedia.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (Basis LuaJIT yang digunakan Neovim) [https://www.lua.org/manual/5.1/manual.html\#2.2](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.2) (Bagian "Values and Types")

**Contoh Kode:**

```lua
-- Mendeklarasikan variabel tanpa memberinya nilai awal
local an_empty_variable -- Variabel ini akan bernilai nil secara default

-- Mendeklarasikan variabel dan menginisialisasinya dengan nil secara eksplisit
local another_empty_var = nil

print(an_empty_variable)
print(another_empty_var)

-- Mengecek apakah variabel bernilai nil
if an_empty_variable == nil then
    print("an_empty_variable adalah nil")
end

-- Menggunakan nil untuk "menghapus" nilai dari variabel global (meskipun lebih baik menghindari global)
-- myGlobalVar = 10
-- print(myGlobalVar) -- Output: 10
-- myGlobalVar = nil
-- print(myGlobalVar) -- Output: nil
```

**Cara Menjalankan Kode:**

1.  Simpan kode di atas dalam sebuah file, misalnya `coba_nil.lua`.
2.  Buka terminal atau command prompt.
3.  Jalankan menggunakan interpreter Lua dengan perintah: `lua coba_nil.lua`.
4.  Di Neovim, Anda dapat mengeksekusi kode Lua secara langsung dengan perintah `:lua print(nil)` atau menjalankan file dengan `:luafile coba_nil.lua`.

**Penjelasan Kode:**

- `local an_empty_variable`: Mendeklarasikan variabel lokal bernama `an_empty_variable`. Karena tidak ada nilai yang di-assign padanya saat deklarasi, Lua secara otomatis memberinya nilai `nil`.
- `local another_empty_var = nil`: Mendeklarasikan variabel lokal `another_empty_var` dan secara eksplisit memberinya nilai `nil`.
- `print(an_empty_variable)`: Mencetak nilai dari `an_empty_variable` ke konsol. Outputnya akan menjadi `nil`.
- `print(another_empty_var)`: Mencetak nilai dari `another_empty_var` ke konsol. Outputnya juga akan menjadi `nil`.
- `if an_empty_variable == nil then ... end`: Ini adalah contoh bagaimana `nil` digunakan dalam kondisi. Operator `==` digunakan untuk memeriksa kesetaraan.
- `print("an_empty_variable adalah nil")`: Baris ini akan dieksekusi karena kondisi di atasnya (`an_empty_variable == nil`) adalah benar.

#### Boolean

- **Deskripsi:** Tipe data `boolean` merepresentasikan nilai kebenaran dan hanya memiliki dua kemungkinan nilai: `true` (benar) dan `false` (salah). Boolean sangat penting dalam struktur kontrol alur program, seperti pernyataan `if` dan loop.
  Dalam Lua, ada konsep _falsy values_ (nilai yang dianggap salah) dan _truthy values_ (nilai yang dianggap benar) dalam konteks kondisi boolean:
  - **Falsy values**: Hanya `false` dan `nil` yang dianggap sebagai nilai salah.
  - **Truthy values**: Semua nilai lain selain `false` dan `nil` dianggap sebagai nilai benar, termasuk angka `0` dan string kosong `""`. Ini adalah perbedaan penting dibandingkan beberapa bahasa pemrograman lain.
- **Terminologi:**
  - **Boolean:** Dinamai dari George Boole, seorang matematikawan yang mengembangkan aljabar Boolean.
- **Implementasi dalam Neovim:** Digunakan secara ekstensif dalam pengaturan plugin (misalnya, `enable_feature = true`), logika kondisional untuk menjalankan perintah, atau menentukan status suatu operasi.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual: [https://www.lua.org/manual/5.1/manual.html\#2.2](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.2)

**Contoh Kode:**

```lua
local is_active = true
local has_permission = false

print(is_active)    -- Output: true
print(has_permission) -- Output: false

-- Contoh penggunaan dalam kondisi
if is_active then
    print("Sistem aktif.")
else
    print("Sistem tidak aktif.")
end

if not has_permission then
    print("Tidak memiliki izin.")
end

-- Demonstrasi Falsy dan Truthy values
print("--- Falsy dan Truthy ---")
if false then print("Ini tidak akan tercetak (false)") end
if nil then print("Ini tidak akan tercetak (nil)") end

if true then print("Ini akan tercetak (true)") end
if 0 then print("Ini akan tercetak (0 adalah truthy)") end
if "" then print("Ini akan tercetak (string kosong adalah truthy)") end
if {} then print("Ini akan tercetak (tabel kosong adalah truthy)") end
if function() end then print("Ini akan tercetak (fungsi adalah truthy)") end
```

**Cara Menjalankan Kode:** Sama seperti contoh `nil` sebelumnya, simpan ke file `.lua` dan jalankan dengan `lua namafile.lua` atau melalui Neovim.

**Penjelasan Kode:**

- `local is_active = true`: Mendeklarasikan variabel lokal `is_active` dan memberinya nilai boolean `true`.
- `local has_permission = false`: Mendeklarasikan variabel lokal `has_permission` dan memberinya nilai boolean `false`.
- `print(is_active)`: Mencetak `true`.
- `print(has_permission)`: Mencetak `false`.
- `if is_active then ... end`: Kondisi ini akan mengevaluasi `true` karena `is_active` adalah `true`, sehingga blok di dalamnya dieksekusi.
- `if not has_permission then ... end`: Operator `not` adalah operator logika negasi. `not has_permission` akan dievaluasi menjadi `not false`, yaitu `true`. Jadi, blok di dalamnya dieksekusi.
- Baris-baris berikutnya mendemonstrasikan bagaimana `false`, `nil`, `0`, `""`, tabel kosong `{}`, dan fungsi diperlakukan dalam konteks boolean. Hanya `false` dan `nil` yang tidak akan menjalankan blok `print`.

#### [Number][3]

- **Deskripsi:** Lua secara tradisional hanya memiliki satu tipe data numerik, yaitu `number`. Secara default, tipe `number` ini merepresentasikan angka _floating-point_ presisi ganda (double-precision floating-point numbers). Meskipun demikian, LuaJIT (yang digunakan oleh Neovim, berdasarkan Lua 5.1) dan versi Lua yang lebih baru dapat melakukan optimasi untuk merepresentasikan bilangan bulat (integer) secara internal jika memungkinkan, demi efisiensi. Anda dapat menulis angka dalam format desimal, notasi ilmiah, dan heksadesimal (dimulai dengan `0x`).
- **Terminologi:**
  - **Floating-point:** Sistem representasi angka yang dapat menangani bilangan pecahan dengan presisi tertentu.
  - **Double-precision:** Menggunakan 64 bit untuk menyimpan angka floating-point, memberikan rentang dan presisi yang lebih besar dibandingkan single-precision (32 bit).
  - **Notasi Ilmiah (Scientific Notation):** Cara ringkas untuk menulis angka yang sangat besar atau sangat kecil, menggunakan `e` atau `E` untuk eksponen basis 10 (contoh: `1.23e-4` berarti $1.23 \\times 10^{-4}$).
  - **Heksadesimal (Hexadecimal):** Sistem bilangan basis 16, menggunakan angka 0-9 dan huruf A-F.
- **Implementasi dalam Neovim:** Digunakan untuk pengaturan yang memerlukan angka (misalnya, ukuran font, jumlah baris), perhitungan posisi, indeks, dan berbagai operasi matematis dalam logika plugin.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual: [https://www.lua.org/manual/5.1/manual.html\#2.2](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.2)
  - Perbedaan Integer di Lua 5.3+: [https://www.lua.org/manual/5.3/manual.html\#2.1](https://www.google.com/search?q=https://www.lua.org/manual/5.3/manual.html%232.1) (Perlu diingat Neovim menggunakan LuaJIT/Lua 5.1)

**Contoh Kode:**

```lua
local integer_val = 42
local float_val = 3.14159
local scientific_val = 1.23e-4  -- Ini sama dengan 0.000123
local hex_val = 0xFF          -- Ini adalah 255 dalam desimal (15*16^1 + 15*16^0)

print("Integer:", integer_val)       -- Output: Integer: 42
print("Float:", float_val)           -- Output: Float: 3.14159
print("Scientific:", scientific_val) -- Output: Scientific: 0.000123
print("Hexadecimal:", hex_val)       -- Output: Hexadecimal: 255

-- Operasi aritmatika
local sum = integer_val + 5.5
print("Sum:", sum)                   -- Output: Sum: 47.5
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya.

**Penjelasan Kode:**

- `local integer_val = 42`: Meskipun ditulis sebagai bilangan bulat, Lua akan menyimpannya sebagai tipe `number`.
- `local float_val = 3.14159`: Contoh angka floating-point.
- `local scientific_val = 1.23e-4`: Contoh angka dalam notasi ilmiah. `e-4` berarti dikalikan $10^{-4}$.
- `local hex_val = 0xFF`: Contoh angka dalam format heksadesimal. `0x` adalah prefiks yang menandakan bilangan heksadesimal. `FF` dalam heksadesimal adalah `255` dalam desimal.
- `print(...)`: Mencetak nilai-nilai variabel tersebut beserta labelnya.
- `local sum = integer_val + 5.5`: Menunjukkan operasi aritmatika antara dua angka. Hasilnya akan menjadi angka floating-point.

#### String

- **Deskripsi:** String di Lua adalah urutan (sekuens) karakter yang tidak dapat diubah (immutable). Ini berarti sekali sebuah string dibuat, isinya tidak dapat dimodifikasi secara langsung; operasi yang tampaknya memodifikasi string sebenarnya membuat string baru. String dapat berisi karakter apa pun, termasuk byte null (`\0`), dan Lua menangani encoding karakter secara netral (biasanya diasumsikan UTF-8 dalam konteks modern seperti Neovim).
  Anda dapat mendefinisikan string menggunakan:
  - Tanda kutip tunggal (`'...'`).
  - Tanda kutip ganda (`"..."`).
  - Kurung siku ganda `[[...]]` untuk string multi-baris (literal string panjang). String dalam kurung siku ganda dapat mencakup beberapa baris, dan karakter escape (seperti `\n`) tidak diproses di dalamnya, kecuali jika baris baru pertama setelah `[[` diabaikan jika itu adalah karakter newline.
- **Terminologi:**
  - **Immutable:** Nilainya tidak dapat diubah setelah dibuat.
  - **Concatenation:** Proses penggabungan dua atau lebih string menjadi satu string.
  - **String Interpolation:** Fitur di beberapa bahasa yang memungkinkan penyisipan ekspresi langsung ke dalam literal string. Lua tidak memiliki ini secara bawaan.
- **Implementasi dalam Neovim:** Sangat penting untuk menampilkan pesan kepada pengguna, membuat perintah Ex, menentukan path file, bekerja dengan konten buffer, nama variabel, kunci dalam tabel konfigurasi, dan banyak lagi.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (Strings): [https://www.lua.org/manual/5.1/manual.html\#2.2](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.2)
  - Lua 5.1 Reference Manual (string library): [https://www.lua.org/manual/5.1/manual.html\#5.4](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%235.4) (untuk `string.format`)

**Contoh Kode:**

```lua
local single_quote_str = 'Halo Dunia dari kutip tunggal!'
local double_quote_str = "Halo Dunia dari kutip ganda!"

local multiline_str = [[
Ini adalah string
yang mencakup
beberapa baris.
Karakter escape seperti \n tidak diproses di sini.
]]

print(single_quote_str)
print(double_quote_str)
print(multiline_str)

-- String Concatenation (Penggabungan String)
-- Menggunakan operator '..' (dua titik)
local sapaan = "Halo"
local nama_pengguna = "Lua User"
local pesan_lengkap = sapaan .. " " .. nama_pengguna .. "!" -- Menggabungkan tiga string
print(pesan_lengkap) -- Output: Halo Lua User!

-- String "Interpolation" (simulasi menggunakan string.format)
-- Lua tidak memiliki interpolasi string bawaan seperti `${variabel}`.
-- Cara umum adalah menggunakan fungsi string.format().
local umur = 30
local kota = "Jakarta"

-- %s untuk string, %d untuk angka desimal (integer)
local info_pengguna = string.format("Nama: %s, Umur: %d, Kota: %s", nama_pengguna, umur, kota)
print(info_pengguna) -- Output: Nama: Lua User, Umur: 30, Kota: Jakarta

-- Panjang string menggunakan operator '#'
print("Panjang string 'pesan_lengkap':", #pesan_lengkap)
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya.

**Penjelasan Kode:**

- `local single_quote_str = '...'`: Mendefinisikan string menggunakan kutip tunggal.
- `local double_quote_str = "..."`: Mendefinisikan string menggunakan kutip ganda. Tidak ada perbedaan fungsional antara keduanya, pilih salah satu dan konsisten.
- `local multiline_str = [[...]]`: Mendefinisikan string multi-baris. Perhatikan bagaimana baris baru di dalam `[[...]]` dipertahankan dalam string.
- `local pesan_lengkap = sapaan .. " " .. nama_pengguna .. "!"`: Operator `..` digunakan untuk menggabungkan string. ` " "` adalah string spasi yang ditambahkan di antara `sapaan` dan `nama_pengguna`.
- `local info_pengguna = string.format(...)`:
  - `string.format`: Fungsi dari pustaka `string` standar Lua yang digunakan untuk memformat string, mirip dengan `sprintf` di C.
  - `"Nama: %s, Umur: %d, Kota: %s"`: String format. `%s` adalah penanda tempat (placeholder) untuk string, dan `%d` adalah penanda tempat untuk bilangan bulat desimal.
  - `nama_pengguna, umur, kota`: Variabel yang nilainya akan menggantikan penanda tempat secara berurutan.
- `print("Panjang string 'pesan_lengkap':", #pesan_lengkap)`: Operator unary `#` ketika diterapkan pada string akan mengembalikan panjang (jumlah byte/karakter) dari string tersebut.

---

### 2.2 Variabel dan Scope

Variabel adalah nama simbolis yang merujuk ke suatu nilai. _Scope_ (lingkup) variabel menentukan di bagian mana dari kode suatu variabel dapat diakses.

#### Local vs Global Variables

Lua mendukung dua jenis scope utama untuk variabel: _local_ dan _global_.

- **Global Variables (Variabel Global):**

  - Jika Anda mendeklarasikan variabel tanpa menggunakan kata kunci `local`, variabel tersebut akan menjadi global.
  - Variabel global dapat diakses dari mana saja dalam program (di semua file atau modul yang berjalan dalam instance Lua yang sama), kecuali jika di-shadow oleh variabel lokal dengan nama yang sama.
  - **Dalam pengembangan plugin Neovim (dan praktik pemrograman Lua yang baik secara umum), penggunaan variabel global sangat tidak disarankan.** Alasannya adalah karena dapat menyebabkan _namespace pollution_ (pencemaran ruang nama), di mana variabel Anda mungkin bertabrakan dengan variabel lain yang memiliki nama sama dari Neovim itu sendiri, plugin lain, atau pustaka Lua lainnya. Ini dapat menyebabkan bug yang sulit dilacak. Variabel global disimpan dalam sebuah tabel khusus bernama `_G`.

- **Local Variables (Variabel Lokal):**

  - Variabel lokal dideklarasikan menggunakan kata kunci `local`.
  - Scope variabel lokal terbatas pada blok di mana ia dideklarasikan. Sebuah "blok" bisa berupa file Lua itu sendiri, sebuah fungsi, sebuah loop (`for`, `while`), atau blok `do ... end` eksplisit.
  - Variabel lokal lebih efisien diakses oleh Lua dibandingkan variabel global.
  - **Selalu gunakan `local` untuk variabel Anda dalam pengembangan plugin Neovim kecuali ada alasan yang sangat spesifik dan disengaja untuk tidak melakukannya.**

- **Blok `do ... end`:**

  - Anda dapat membuat blok scope baru secara eksplisit menggunakan `do ... end`. Variabel lokal yang dideklarasikan di dalam blok ini hanya akan ada di dalam blok tersebut.

- **Best Practice (Praktik Terbaik):** Selalu gunakan `local` untuk mendeklarasikan variabel dalam pengembangan plugin untuk menghindari _namespace pollution_ dan meningkatkan keterbacaan serta pemeliharaan kode.

- **Implementasi dalam Neovim:** Penggunaan `local` adalah fundamental. Semua file Lua plugin Anda secara efektif adalah sebuah blok. Fungsi-fungsi dalam plugin Anda juga menciptakan blok baru untuk variabel lokal. Ini membantu menjaga plugin Anda tetap modular dan terisolasi dari bagian lain sistem Neovim.

- **Sumber Dokumentasi Lua:**

  - Lua 5.1 Reference Manual (Variables): [https://www.lua.org/manual/5.1/manual.html\#2.3](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.3)
  - Lua 5.1 Reference Manual (Visibility Rules/Scope): [https://www.lua.org/manual/5.1/manual.html\#2.6](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.6)
  - Programming in Lua (PiL), Edisi Pertama (untuk Lua 5.0, konsep scope masih relevan): [https://www.lua.org/pil/4.2.html](https://www.lua.org/pil/4.2.html)

**Contoh Kode:**

```lua
-- Global variable (hindari ini dalam pengembangan plugin)
-- Jika dijalankan, variabel ini akan menjadi bagian dari tabel _G
global_var = "Saya adalah variabel global"

-- Local variable (direkomendasikan)
local local_var = "Saya adalah variabel lokal di scope file ini"

function testScope()
    local function_local_var = "Saya lokal untuk fungsi testScope"
    print(function_local_var) -- OK
    print(local_var)          -- OK, bisa akses local_var dari scope luar (file)
    print(global_var)         -- OK, variabel global bisa diakses di mana saja

    if true then
        local block_local_var = "Saya lokal untuk blok if ini"
        print(block_local_var) -- OK
    end

    -- print(block_local_var) -- Error: block_local_var tidak terlihat di sini (di luar scope blok if)
                            -- Untuk menjalankan tanpa error, baris ini harus dikomentari
end

testScope()

-- print(function_local_var) -- Error: function_local_var tidak terlihat di sini (di luar scope fungsi)
                           -- Untuk menjalankan tanpa error, baris ini harus dikomentari

print("--- Contoh Scope dengan do...end ---")
local x = 10
print("x sebelum blok do:", x) -- Output: 10

do
    local x = 20 -- Variabel x ini berbeda (di-shadow) dari x di luar
    local inner_var = "Hanya terlihat di dalam blok do...end ini"
    print("x di dalam blok do:", x) -- Output: 20
    print(inner_var)               -- Output: Hanya terlihat di dalam blok do...end ini
end

print("x setelah blok do:", x) -- Output: 10 (kembali ke x yang di luar blok)
-- print(inner_var)           -- Error: inner_var tidak terlihat di sini
                             -- Untuk menjalankan tanpa error, baris ini harus dikomentari

-- Mengakses variabel global melalui _G
print(_G.global_var) -- Output: Saya adalah variabel global
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya. Anda mungkin perlu mengomentari baris-baris yang akan menyebabkan error untuk melihat bagian lain dari kode berjalan.

**Penjelasan Kode:**

- `global_var = "..."`: Mendeklarasikan variabel global. Di Neovim, ini akan membuat `vim.g.global_var` jika diatur dari konteks global Lua Neovim, atau `_G.global_var` dalam Lua murni. Sebaiknya dihindari.
- `local local_var = "..."`: Mendeklarasikan variabel lokal yang scopnya adalah seluruh file ini.
- `function testScope() ... end`: Mendefinisikan fungsi. Fungsi menciptakan scope baru.
- `local function_local_var = "..."`: Variabel lokal yang hanya ada di dalam fungsi `testScope`.
- `if true then ... end`: Blok `if` juga menciptakan scope baru untuk variabel lokal yang dideklarasikan di dalamnya.
- `local block_local_var = "..."`: Variabel lokal yang hanya ada di dalam blok `if`. Mencoba mengaksesnya di luar blok `if` akan menghasilkan error (`nil`).
- `do ... end`: Blok ini menciptakan scope baru.
- `local x = 20` (di dalam `do...end`): Variabel `x` ini adalah variabel lokal baru yang berbeda dari `x` di luar blok. Ini disebut _shadowing_. Di dalam blok `do...end`, `x` ini "menutupi" `x` yang ada di scope luar.
- `_G.global_var`: Variabel global secara teknis disimpan dalam tabel khusus bernama `_G`. Anda bisa mengaksesnya melalui tabel ini.

---

Pemahaman yang baik tentang tipe data dan variabel, khususnya perbedaan antara variabel lokal dan global serta bagaimana scope bekerja, adalah kunci untuk menulis kode Lua yang bersih, efisien, dan mudah dikelola, terutama dalam konteks pengembangan plugin Neovim yang kompleks.

> - **[Ke Atas](#2-tipe-data-dan-variabel)**
> - **[Selanjutnya](../3-operator-kontrolFlow/README.md)**
> - **[Sebelumnya](../1-dasar/README.md)**
> - **[Kurikulum][4]**
> - **[Domain Spesifik][5]**

[5]: ../../../../../../../README.md
[4]: ../../../../../README.md
[2]: ../../README.md
[3]: ../../../../../materi/dasar/tipe-data/number/README.md
