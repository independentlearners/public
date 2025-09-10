# [Modul 7 — Package & Require (`package`, `require`)][0]

Modul ini adalah pintu gerbang agar program Lua tidak lagi monolitik, tapi bisa **dipecah menjadi modul** yang dapat dipanggil ulang. Ini juga kunci ketika kita ingin membuat **plugin**, **library**, atau mengatur struktur proyek besar.

<details>
  <summary>📃 Daftar Isi</summary>

---

### Struktur Pembelajaran Internal (mini-TOC)

* **7.1 Pengenalan Modularisasi di Lua**

  * Apa itu modul
  * Filosofi: *baterai kecil tapi extensible*
  * Hubungan dengan `package` dan `require`
* **7.2 Mekanisme `require`**

  * Bagaimana `require` bekerja
  * Path pencarian modul
  * Cache modul (once-per-load)
* **7.3 Tabel `package`**

  * `package.path`
  * `package.cpath`
  * `package.loaded`
* **7.4 Studi Kasus**

  * Membuat modul sendiri (`mymath.lua`)
  * Menggunakan modul eksternal dengan LuaRocks
* Latihan & kuiz
* Praktik terbaik & kesalahan umum
* Visualisasi

</details>

---

## 7.1 Pengenalan Modularisasi di Lua

### Deskripsi & Peran

* **Modul** = file Lua yang berisi kode (fungsi, tabel, konstanta) untuk digunakan ulang.
* **`require`** = cara memanggil modul di Lua.
* **`package`** = tabel global yang mengatur mekanisme pencarian & cache modul.

**Mengapa penting?**

* Memudahkan **organisasi kode** (misalnya `math_utils.lua`, `io_utils.lua`).
* Bisa berbagi library antar proyek.
* Landasan untuk membangun sistem plugin (contoh: Neovim plugin dengan Lua).

### Filosofi

Lua tidak memaksa sistem package yang berat. Hanya menyediakan **mekanisme ringan** (`require` + `package`) agar pengguna bebas mengatur.

---

## 7.2 Mekanisme `require`

### Dasar

```lua
-- file: mymath.lua
local M = {}

function M.square(x)
  return x * x
end

return M
```

```lua
-- file utama
local mymath = require("mymath")
print(mymath.square(5))  -- 25
```

👉 **Catatan:**

* Modul biasanya `return` sebuah tabel (`M`) berisi semua fungsi.
* `require("mymath")` mencari file `mymath.lua` sesuai `package.path`.

---

### Path pencarian

* Lua mencari modul berdasarkan `package.path`.
* Default (di Linux):

  ```
  ./?.lua
  /usr/local/share/lua/5.4/?.lua
  /usr/local/share/lua/5.4/?/init.lua
  /usr/local/lib/lua/5.4/?.lua
  ```
* `?` diganti dengan nama modul.
* Misalnya `require("utils.str")` akan mencoba mencari:

  * `./utils/str.lua`
  * `./utils/str/init.lua`

---

### Cache modul

* Saat modul pertama kali di-*require*, ia dieksekusi lalu disimpan di `package.loaded`.
* Pemanggilan berikutnya **tidak mengulang eksekusi**, melainkan mengembalikan hasil cache.

```lua
local m1 = require("mymath")
local m2 = require("mymath")
print(m1 == m2)  -- true
```

---

## 7.3 Tabel `package`

* **`package.path`** → path pencarian modul Lua. Bisa diubah:

  ```lua
  package.path = package.path .. ";/home/user/mylib/?.lua"
  ```
* **`package.cpath`** → path pencarian modul C (library eksternal `.so` atau `.dll`).
* **`package.loaded`** → daftar modul yang sudah dimuat.

```lua
for k, v in pairs(package.loaded) do
  print(k, v)
end
```

---

## 7.4 Studi Kasus

### Membuat modul sendiri

`string_utils.lua`:

```lua
local M = {}

function M.capitalize(str)
  return (str:gsub("^%l", string.upper))
end

return M
```

File utama:

```lua
local strutils = require("string_utils")
print(strutils.capitalize("lua"))  -- "Lua"
```

---

### Menggunakan modul eksternal dengan LuaRocks

1. Instal [LuaRocks](https://luarocks.org).

   ```bash
   sudo pacman -S luarocks   # Arch Linux
   ```
2. Pasang modul, misalnya **inspect** (untuk pretty-print table):

   ```bash
   luarocks install inspect
   ```
3. Gunakan di Lua:

   ```lua
   local inspect = require("inspect")
   local t = {a=1, b={2,3}}
   print(inspect(t))
   ```

---

## Visualisasi (ASCII Diagram)

```
┌─────────────────────────────┐
│ require("mymath")           │
└───────────┬─────────────────┘
            │
 ┌──────────▼───────────┐
 │   package.path       │
 │   cari mymath.lua    │
 └──────────┬───────────┘
            │
 ┌──────────▼───────────┐
 │ eksekusi mymath.lua  │
 │ return M (table)     │
 └──────────┬───────────┘
            │
 ┌──────────▼───────────┐
 │ package.loaded.cache │
 │ modul disimpan sekali│
 └──────────────────────┘
```

---

## Praktik Terbaik

* Selalu kembalikan (`return`) **tabel modul**, jangan langsung fungsi tunggal, agar mudah diperluas.
* Gunakan `local` di dalam modul untuk mencegah polusi global.
* Susun modul dengan nama hierarki (`utils.math`, `utils.string`) untuk proyek besar.
* Jika butuh *reload* modul saat debugging:

  ```lua
  package.loaded["mymath"] = nil
  local mymath = require("mymath")
  ```

---

## Kesalahan Umum & Solusi

* **File modul tidak ditemukan** → periksa `package.path`.
* **Lupa `return` modul** → `require` akan mengembalikan `true`, bukan tabel.
* **Mengubah `package.path` tanpa menambahkan default** → gunakan `..` agar tidak kehilangan path bawaan.
* **Mengira `require` memuat ulang modul** → sebenarnya hanya sekali, gunakan `package.loaded` untuk reset.

---

## Latihan & Kuiz

1. Buat modul `math_ext.lua` dengan fungsi `factorial(n)`.
2. Ubah `package.path` agar bisa mencari modul dari folder `lib/`.
3. Apa hasil dari `require("foo")` jika `foo.lua` ada tapi tidak `return` apa pun?
   (jawaban: `true`).

---

## Hubungan dengan Modul Lain

* **Modul 3 (Table):** modul biasanya return tabel.
* **Modul 5 (I/O):** modul `io_utils` bisa dibuat untuk abstraksi file.
* **Modul 14 (C API):** `require` bisa memuat library C sebagai ekstensi.
* **Modul 16 (LuaRocks):** manajemen paket resmi berbasis `require`.

---

## Referensi

* Lua 5.4 Reference Manual — [The `require` Function](https://www.lua.org/manual/5.4/manual.html#pdf-require)
* Lua 5.4 Reference Manual — [The `package` library](https://www.lua.org/manual/5.4/manual.html#6.3)
* Lua-users wiki — [Modules Tutorial](http://lua-users.org/wiki/ModulesTutorial)
* LuaRocks — [https://luarocks.org](https://luarocks.org)

---

Kita akan membuat dua library sederhana: **`string_utils.lua`** dan **`math_utils.lua`**, lalu menggunakannya dalam **`main.lua`**. Proyek ini akan menunjukkan cara **membagi kode menjadi modul** dan bagaimana **`require`** memanggilnya.

---

# Mini-Project: Library Utilitas String & Math

## Struktur Folder

```
project/
│
├── main.lua
├── string_utils.lua
└── math_utils.lua
```

---

## 1. Modul String (`string_utils.lua`)

```lua
-- string_utils.lua
-- Modul utilitas string

local M = {}

-- Capitalize: ubah huruf pertama jadi besar
function M.capitalize(str)
  return (str:gsub("^%l", string.upper))
end

-- Reverse: balik string
function M.reverse(str)
  local rev = str:reverse()
  return rev
end

-- Count vowels: hitung huruf vokal
function M.count_vowels(str)
  local _, count = str:gsub("[AEIOUaeiou]", "")
  return count
end

return M
```

### Penjelasan:

* `M` = tabel yang berisi semua fungsi modul.
* `gsub("^%l", string.upper)` → ganti huruf pertama (`^%l`) dengan versi kapital.
* `str:reverse()` → fungsi bawaan Lua untuk membalik string.
* `gsub("[AEIOUaeiou]", "")` → ganti semua vokal dengan string kosong, hasil kedua (`count`) = jumlah penggantian.

---

## 2. Modul Math (`math_utils.lua`)

```lua
-- math_utils.lua
-- Modul utilitas matematika

local M = {}

-- Faktorial: n! = 1*2*...*n
function M.factorial(n)
  if n == 0 then return 1 end
  local res = 1
  for i = 1, n do
    res = res * i
  end
  return res
end

-- Cek prima
function M.is_prime(n)
  if n < 2 then return false end
  for i = 2, math.floor(math.sqrt(n)) do
    if n % i == 0 then return false end
  end
  return true
end

-- FPB (Faktor Persekutuan Terbesar) menggunakan Euclidean Algorithm
function M.gcd(a, b)
  while b ~= 0 do
    a, b = b, a % b
  end
  return a
end

return M
```

### Penjelasan:

* `factorial(n)` → faktorial.
* `is_prime(n)` → cek bilangan prima dengan membagi sampai akar kuadrat.
* `gcd(a, b)` → algoritma Euclidean untuk FPB.

---

## 3. Program Utama (`main.lua`)

```lua
-- main.lua
-- Program utama yang menggunakan modul string_utils & math_utils

local strutils = require("string_utils")
local mathutils = require("math_utils")

-- Contoh penggunaan modul string
print("=== String Utils ===")
local text = "lua programming"
print("Original:", text)
print("Capitalize:", strutils.capitalize(text))
print("Reverse:", strutils.reverse(text))
print("Jumlah vokal:", strutils.count_vowels(text))

-- Contoh penggunaan modul math
print("\n=== Math Utils ===")
local num = 5
print("Faktorial dari", num, ":", mathutils.factorial(num))
print("Apakah", num, "prima?", mathutils.is_prime(num))
print("FPB dari 36 dan 60:", mathutils.gcd(36, 60))
```

---

## Output Contoh

```
=== String Utils ===
Original: lua programming
Capitalize: Lua programming
Reverse: gnimmargorp aul
Jumlah vokal: 5

=== Math Utils ===
Faktorial dari 5 : 120
Apakah 5 prima?  true
FPB dari 36 dan 60: 12
```

---

## Visualisasi Alur Modul

```
┌───────────────────┐
│  main.lua         │
│  (program utama)  │
└───────┬───────────┘
        │
   ┌────▼─────┐    ┌─────────────┐
   │ require  │    │ require     │
   │ "string" │    │ "math"      │
   └────┬─────┘    └──────┬──────┘
        │                │
┌───────▼──────┐   ┌─────▼────────┐
│ string_utils │   │ math_utils   │
│ return table │   │ return table │
└──────────────┘   └──────────────┘
```

---

Mari kita **bedah seluruh isi kode mini-project Modul 7 (Library String & Math)** secara rinci, baris demi baris, agar langsung memahami maksudnya.

# 📂 File `string_utils.lua`

```lua
-- string_utils.lua
-- Modul utilitas string
```

👉 Komentar yang memberi tahu bahwa file ini adalah **modul string**.

```lua
local M = {}
```

👉 `M` adalah sebuah **tabel**. Semua fungsi modul akan dimasukkan ke dalam tabel ini.
Menggunakan `local` mencegah variabel ini bocor ke **ruang lingkup global**.

---

### Fungsi `capitalize`

```lua
function M.capitalize(str)
  return (str:gsub("^%l", string.upper))
end
```

* `M.capitalize` → menambahkan fungsi baru ke tabel modul `M`.
* `str:gsub("^%l", string.upper)`:

  * `^%l` → pola regex Lua, artinya “huruf kecil (`%l`) di awal string (`^`)”.
  * `string.upper` → fungsi bawaan Lua untuk mengubah huruf menjadi kapital.
  * `gsub` → mengganti sesuai pola.
* Jadi: **huruf pertama dari string dibuat kapital**.

  * Contoh: `"lua programming"` → `"Lua programming"`.

---

### Fungsi `reverse`

```lua
function M.reverse(str)
  local rev = str:reverse()
  return rev
end
```

* `str:reverse()` → fungsi bawaan Lua yang membalik string.
* Hasil disimpan ke `rev` lalu dikembalikan.
* Contoh: `"lua"` → `"aul"`.

---

### Fungsi `count_vowels`

```lua
function M.count_vowels(str)
  local _, count = str:gsub("[AEIOUaeiou]", "")
  return count
end
```

* `str:gsub("[AEIOUaeiou]", "")`:

  * `gsub` mengganti semua huruf vokal dengan string kosong.
  * Nilai kembalian `gsub` ada dua: string hasil penggantian, dan **jumlah penggantian**.
* Karena kita hanya butuh jumlah, hasil pertama diabaikan (`_`), hasil kedua (`count`) kita pakai.
* Contoh: `"lua programming"` → 5.

---

```lua
return M
```

👉 Modul harus **return** tabel yang berisi semua fungsinya.
Ketika file ini di-*require*, yang didapat adalah isi tabel `M`.

---

# 📂 File `math_utils.lua`

```lua
-- math_utils.lua
-- Modul utilitas matematika

local M = {}
```

👉 Sama seperti `string_utils.lua`, kita siapkan tabel modul `M`.

---

### Fungsi `factorial`

```lua
function M.factorial(n)
  if n == 0 then return 1 end
  local res = 1
  for i = 1, n do
    res = res * i
  end
  return res
end
```

* Faktorial: `n! = 1 × 2 × 3 × ... × n`.
* Jika `n == 0`, hasilnya `1` (definisi matematis).
* Loop `for` dipakai untuk mengalikan angka dari `1` sampai `n`.
* Contoh: `factorial(5)` → `120`.

---

### Fungsi `is_prime`

```lua
function M.is_prime(n)
  if n < 2 then return false end
  for i = 2, math.floor(math.sqrt(n)) do
    if n % i == 0 then return false end
  end
  return true
end
```

* Bilangan prima adalah bilangan lebih besar dari 1 yang hanya habis dibagi 1 dan dirinya sendiri.
* Jika `n < 2` → bukan prima.
* Loop dari `2` sampai akar kuadrat `n`:

  * Jika ada angka yang bisa membagi habis `n`, berarti bukan prima.
* Kalau lolos sampai akhir, berarti prima.
* Contoh: `is_prime(5)` → `true`.

---

### Fungsi `gcd`

```lua
function M.gcd(a, b)
  while b ~= 0 do
    a, b = b, a % b
  end
  return a
end
```

* FPB (Faktor Persekutuan Terbesar) menggunakan **Algoritma Euclidean**.
* Prinsip: `gcd(a, b) = gcd(b, a % b)`, terus ulang sampai `b = 0`.
* Contoh: `gcd(36, 60)` → `12`.

---

```lua
return M
```

👉 Mengembalikan tabel `M` agar bisa dipakai di `require`.

---

# 📂 File `main.lua`

```lua
-- main.lua
-- Program utama yang menggunakan modul string_utils & math_utils

local strutils = require("string_utils")
local mathutils = require("math_utils")
```

👉 `require("string_utils")` memuat file `string_utils.lua`.
👉 `require("math_utils")` memuat file `math_utils.lua`.
👉 Keduanya mengembalikan tabel fungsi yang disimpan ke variabel lokal.

---

### Bagian String

```lua
print("=== String Utils ===")
local text = "lua programming"
print("Original:", text)
print("Capitalize:", strutils.capitalize(text))
print("Reverse:", strutils.reverse(text))
print("Jumlah vokal:", strutils.count_vowels(text))
```

* Menampilkan teks asli: `"lua programming"`.
* `capitalize` → `Lua programming`.
* `reverse` → `gnimmargorp aul`.
* `count_vowels` → `5`.

---

### Bagian Math

```lua
print("\n=== Math Utils ===")
local num = 5
print("Faktorial dari", num, ":", mathutils.factorial(num))
print("Apakah", num, "prima?", mathutils.is_prime(num))
print("FPB dari 36 dan 60:", mathutils.gcd(36, 60))
```

* `factorial(5)` → `120`.
* `is_prime(5)` → `true`.
* `gcd(36, 60)` → `12`.

---

# Ringkasan Alur Program

1. **Modul dibuat** (`string_utils.lua`, `math_utils.lua`).
2. **Program utama (`main.lua`)** melakukan `require`.
3. Fungsi dari modul dipanggil lewat tabel (`strutils.capitalize`, `mathutils.factorial`).
4. Output ditampilkan ke layar.

---

# Visualisasi Alur

```
┌───────────────┐
│   main.lua    │
└──────┬────────┘
       │ require
 ┌─────▼────────┐       ┌─────────────┐
 │ string_utils │       │ math_utils  │
 │ return table │       │ return table│
 └─────┬────────┘       └─────┬──────┘
       │                      │
 ┌─────▼───────────────┐ ┌────▼──────────────┐
 │ capitalize/reverse  │ │ factorial/is_prime│
 │ count_vowels        │ │ gcd               │
 └─────────────────────┘ └───────────────────┘
```

---

# Inti Pemahaman

* **Modul** = file Lua yang berisi fungsi dalam tabel.
* **`require`** = cara memanggil modul.
* Dengan ini, kode menjadi **terstruktur**, bisa dipakai ulang, dan mudah diperbesar skalanya.

---

## Praktik Terbaik

* Selalu kembalikan **tabel modul** agar fleksibel.
* Gunakan `local` untuk variabel internal modul agar tidak bocor ke global.
* Pisahkan logika ke modul sesuai domain (string, math, io, dll.).

---

## Latihan

1. Tambahkan fungsi baru di `string_utils.lua`: `word_count(str)` untuk menghitung jumlah kata.
2. Tambahkan fungsi baru di `math_utils.lua`: `lcm(a, b)` (Kelipatan Persekutuan Terkecil).
3. Gunakan keduanya di `main.lua`.

---

<<!--
Apakah Anda ingin saya langsung perluas mini-project ini dengan latihan tambahan (menambah word_count di string_utils & lcm di math_utils), atau kita **lanjut ke Modul 8: Debug Library (debug)?
-->>

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-6/README.md
[selanjutnya]: ../bagian-8/README.md

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
