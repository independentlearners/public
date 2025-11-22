<!--
<details>
  <summary>📃 Daftar Isi</summary>

</details>
Baik, kita lanjut ke **Modul 15: Optimisasi & Profiling dalam LuaJIT + FFI**.

---

-->

# **[Modul 15 – Optimisasi & Profiling][0]**

### Deskripsi & Peran

* Setelah kita bisa memanggil library C lewat FFI, pertanyaan berikutnya: **seberapa cepat ini dibandingkan Lua murni?**
* Modul ini mengajarkan cara **profiling** (mengukur performa kode) dan **optimisasi** (menulis kode agar lebih efisien).
* Filosofi: jangan optimasi membabi buta; selalu **ukur dulu**. Profiling adalah dasar sebelum optimasi.

---

## Bagian A: Profiling Waktu Eksekusi

### Contoh `profile_lua.lua`

```lua
-- Fungsi fibonacci sederhana (rekursif) di Lua
local function fib_lua(n)
  if n < 2 then return n end
  return fib_lua(n-1) + fib_lua(n-2)
end

local start = os.clock()
print("fib_lua(30) =", fib_lua(30))
print("Waktu Lua   :", os.clock() - start, "detik")
```

**Penjelasan:**

* `fib_lua` → contoh perhitungan CPU-bound.
* `os.clock()` → mengukur waktu CPU.
* Cetak hasil dan durasi.

---

## Bagian B: Profiling dengan FFI (panggil fungsi C)

### File `fib.c`

```c
// fib.c
long fib_c(int n) {
    if (n < 2) return n;
    return fib_c(n-1) + fib_c(n-2);
}
```

### Kompilasi

```bash
gcc -O2 -fPIC -shared -o libfib.so fib.c
```

### File `fib_bind.lua`

```lua
local ffi = require("ffi")

ffi.cdef[[
long fib_c(int n);
]]

local lib = ffi.load("./libfib.so")

return lib
```

### File `profile_ffi.lua`

```lua
local lib = require("fib_bind")

local start = os.clock()
print("fib_c(30) =", lib.fib_c(30))
print("Waktu FFI :", os.clock() - start, "detik")
```

---

## Bedah Perbandingan

* `fib_lua(30)` di Lua bisa makan waktu \~0.3–0.5 detik.
* `fib_c(30)` via FFI jauh lebih cepat (sekitar 0.01 detik).
* **Pelajaran:** fungsi berat sebaiknya dipindahkan ke C via FFI.

---

## Bagian C: Profiling dengan `luajit -jv`

LuaJIT menyediakan opsi JIT profiling:

```bash
luajit -jv profile_lua.lua
```

* `-jv` → menampilkan trace JIT: bagian mana yang dijadikan native code, mana yang tidak.
* Dari sini kita tahu apakah fungsi sudah di-*JIT compile* atau masih diinterpretasi.

---

## Bagian D: Praktik Optimisasi

1. **Gunakan local** → variabel global lambat di Lua.

   ```lua
   local sin = math.sin
   local cos = math.cos
   -- panggil sin/cos banyak kali lebih cepat
   ```

2. **Hindari alokasi string berulang** → gunakan buffer.

3. **FFI struct/array** → gunakan jika butuh operasi numerik besar:

   ```lua
   local ffi = require("ffi")
   local arr = ffi.new("double[1000000]")
   ```

4. **Benchmark sebelum optimasi**:

   ```lua
   local start = os.clock()
   for i=1,1e6 do arr[i-1] = i end
   print("Durasi:", os.clock() - start)
   ```

---

## Visualisasi Alur Profiling

```
Kode Lua   ───► os.clock() ───► ukur waktu eksekusi
    │
    ▼
Bandingkan dengan
    │
    ▼
Kode C via FFI ───► lebih cepat (native machine code)
```

---

## Praktik Terbaik

* **Profiling dulu** sebelum optimasi (gunakan `os.clock` atau tools eksternal seperti `perf`, `valgrind`, `oprofile`).
* **FFI cocok untuk numerik berat** atau algoritma intensif.
* Untuk logika ringan (misalnya manipulasi tabel kecil), Lua murni cukup.

---

## Potensi Kesalahan

* Mengukur waktu dengan `os.time()` (hanya resolusi detik) → gunakan `os.clock()` atau high-res timer.
* Membandingkan hasil tanpa optimisasi kompilasi (`-O2` di gcc) → hasil bias.
* Mengabaikan overhead FFI call: sekali-dua kali tidak terasa, tapi jika dipanggil jutaan kali per frame bisa signifikan.

---

📌 Dengan modul ini, Anda belajar:

* Cara profiling di Lua (os.clock).
* Cara membandingkan performa Lua murni vs FFI.
* Praktik optimisasi dasar di LuaJIT.

<!--
Apakah Anda ingin saya langsung buat **mini proyek profiling nyata** (misalnya bandingkan sorting 1 juta angka di Lua vs C lewat FFI), atau lanjut ke **Modul 16**?


-->
Mari kita buat **Mini Proyek Profiling Nyata: Sorting 1 Juta Angka**.
Tujuannya adalah membandingkan performa **sorting di Lua murni** vs **sorting di C lewat FFI**.
Seperti biasa, semua kode akan kita bedah **baris demi baris**.

---

# Struktur Proyek

```
libsort.c         → implementasi fungsi sorting di C
libsort.h         → header
sort_bind.lua     → binding FFI
sort_demo.lua     → demo & benchmarking
```

---

# 1) File `libsort.c`

```c
// libsort.c
#include "libsort.h"
#include <stdlib.h>

// implementasi quicksort sederhana
static int cmp_int(const void* a, const void* b) {
    int ia = *(const int*)a;
    int ib = *(const int*)b;
    return (ia > ib) - (ia < ib); // 1 jika a>b, -1 jika a<b, 0 jika sama
}

void sort_ints(int* arr, size_t n) {
    qsort(arr, n, sizeof(int), cmp_int);
}
```

### Penjelasan baris demi baris

* `#include "libsort.h"` → sertakan deklarasi fungsi.
* `#include <stdlib.h>` → diperlukan untuk `qsort`.
* `static int cmp_int(...)` → comparator untuk `qsort`.

  * Ambil dua pointer `a` & `b` → cast ke `int*`.
  * Kembalikan -1, 0, atau 1 untuk menentukan urutan.
* `void sort_ints(int* arr, size_t n)` → fungsi utama untuk sort array `int` sebanyak `n` elemen.

  * Panggil `qsort` (C standard library).

---

# 2) File `libsort.h`

```c
// libsort.h
#ifndef LIBSORT_H
#define LIBSORT_H

#include <stddef.h>

void sort_ints(int* arr, size_t n);

#endif
```

### Penjelasan

* Include guard → mencegah definisi ganda.
* `void sort_ints(int* arr, size_t n);` → deklarasi fungsi sorting.

---

# 3) Kompilasi Library

Linux:

```bash
gcc -O2 -fPIC -shared -o libsort.so libsort.c
```

Windows:

```bash
gcc -O2 -shared -o libsort.dll libsort.c
```

Penjelasan opsi:

* `-O2` → optimisasi.
* `-fPIC` → posisi-independent code (dibutuhkan `.so`).
* `-shared` → buat shared library.

---

# 4) File `sort_bind.lua`

```lua
-- sort_bind.lua
local ffi = require("ffi")

ffi.cdef[[
void sort_ints(int* arr, size_t n);
]]

local lib = ffi.load("./libsort.so") -- sesuaikan .dll di Windows

local M = {}

function M.sort(tbl)
  -- buat array C dari tabel Lua
  local n = #tbl
  local arr = ffi.new("int[?]", n, tbl)
  
  -- panggil fungsi C
  lib.sort_ints(arr, n)
  
  -- salin hasil kembali ke tabel Lua
  local result = {}
  for i=0, n-1 do
    result[#result+1] = arr[i]
  end
  return result
end

return M
```

### Penjelasan baris demi baris

* `local ffi = require("ffi")` → load FFI.
* `ffi.cdef[[ ... ]]` → deklarasikan fungsi `sort_ints`.
* `local lib = ffi.load("./libsort.so")` → load library C.
* `function M.sort(tbl)` → wrapper Lua:

  * `local n = #tbl` → jumlah elemen tabel Lua.
  * `local arr = ffi.new("int[?]", n, tbl)`
    → buat array C (`int[n]`), isi langsung dari tabel Lua.
  * `lib.sort_ints(arr, n)` → panggil C function.
  * Loop hasil array C dan salin ke tabel Lua `result`.
* `return M` → ekspor modul.

---

# 5) File `sort_demo.lua`

```lua
-- sort_demo.lua
local ffi = require("ffi")
local sort_c = require("sort_bind")

-- Fungsi sorting murni Lua (gunakan table.sort)
local function sort_lua(tbl)
  local copy = {table.unpack(tbl)}
  table.sort(copy)
  return copy
end

-- Buat data acak
math.randomseed(os.time())
local N = 1000000
local data = {}
for i=1,N do
  data[i] = math.random(1, 1000000)
end

-- Benchmark Lua sort
local start = os.clock()
local sorted_lua = sort_lua(data)
print("Lua sort waktu :", os.clock() - start, "detik")

-- Benchmark C sort (via FFI)
start = os.clock()
local sorted_c = sort_c.sort(data)
print("C sort waktu   :", os.clock() - start, "detik")

-- Verifikasi hasil sama
print("Cek elemen pertama (Lua vs C):", sorted_lua[1], sorted_c[1])
print("Cek elemen terakhir (Lua vs C):", sorted_lua[#sorted_lua], sorted_c[#sorted_c])
```

### Penjelasan baris demi baris

* `local sort_c = require("sort_bind")` → import binding.
* `local function sort_lua(tbl)` → buat salinan tabel, lalu `table.sort`.
* `math.randomseed(os.time())` → seed random.
* `local N = 1000000` → ukuran data = 1 juta.
* Loop generate angka random 1..1e6.
* **Benchmark Lua**:

  * `os.clock()` sebelum & sesudah.
  * Panggil `sort_lua(data)`.
  * Hitung durasi.
* **Benchmark C (via FFI)**:

  * Sama, tapi gunakan `sort_c.sort(data)`.
* **Verifikasi hasil**:

  * Bandingkan elemen pertama & terakhir → memastikan hasil sort sama.

---

# 6) Contoh Output (estimasi)

```
Lua sort waktu : 1.25 detik
C sort waktu   : 0.32 detik
Cek elemen pertama (Lua vs C): 1 1
Cek elemen terakhir (Lua vs C): 1000000 1000000
```

(Tergantung hardware, ukuran data, dan optimisasi compiler.)

---

# 7) Analisis

* **Lua `table.sort`** sudah dioptimalkan, tapi tetap berjalan di interpreter Lua.
* **C qsort via FFI** lebih cepat karena langsung dijalankan native code.
* Overhead FFI kecil dibanding keuntungan algoritma C.
* Untuk dataset besar (jutaan elemen), FFI → signifikan lebih cepat.

---

# 8) Praktik Terbaik

* Jangan selalu FFI untuk operasi kecil (misalnya sorting 10 angka) → overhead tidak sebanding.
* Cocok untuk **batch besar** (misalnya 1e6 elemen).
* Pastikan hasil diverifikasi (sorting berbeda bisa punya stabilitas berbeda).
* Gunakan `-O2` atau `-O3` saat compile C untuk performa maksimal.

---

# 9) Potensi Kesalahan

* **ffi.new("int\[?]", n, tbl)** hanya bisa jika `tbl` berisi angka int. Jika ada string → crash.
* Salah path `.so/.dll` → `ffi.load` gagal.
* Perbedaan ukuran int (`int` biasanya 32-bit). Jika butuh 64-bit → gunakan `long long`.

---

📌 Dengan mini proyek ini, Anda sudah melihat **profiling nyata**: sorting 1 juta angka di Lua vs C lewat FFI.
Bedanya bisa **3–5x lebih cepat** (atau lebih, tergantung sistem).



<!--
Apakah Anda ingin saya kembangkan proyek ini lebih jauh (misalnya bandingkan juga dengan implementasi **LuaJIT FFI array manual**), atau langsung lanjut ke **Modul 16**?
-->
> - **[Ke Atas](#)**
> - **[Sebelumnya][sebelumnya]**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-14/README.md
[selanjutnya]: ../bagian-16/README.md

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
