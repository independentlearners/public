<!--<details>
  <summary>📃 Daftar Isi</summary>

</details>

#
Baik, kita lanjut ke **Bagian 2: Optimisasi & Profiling**.
-->

# **[Bagian 2: Optimisasi & Profiling][0]**

### Deskripsi & Peran dalam Kurikulum

* **Optimisasi** berarti menulis kode dengan pola yang sesuai agar LuaJIT bisa memanfaatkan *JIT compiler* secara maksimal.
* **Profiling** adalah cara mengukur performa, menemukan bottleneck, dan membandingkan hasil antara Lua murni, LuaJIT, dan FFI.
* Peran dalam kurikulum: mengajarkan *bukan hanya bisa menulis kode jalan, tapi menulis kode yang cepat dan efisien*. Ini sangat relevan bila nanti Anda membangun plugin Neovim, CLI, atau sistem yang butuh performa tinggi.

---

### Konsep Kunci

1. **JIT hot loop** → LuaJIT akan mengompilasi loop yang cukup sering dipanggil menjadi kode mesin. Jadi loop sederhana dengan indeks numerik lebih optimal.
2. **FFI arrays** → lebih cepat daripada tabel Lua biasa karena data disimpan kontigu.
3. **Profiling** → menggunakan `os.clock()` atau pustaka seperti [LuaJIT’s jit.v](http://luajit.org/running.html) untuk tracing.

---

### Contoh Mini Proyek: Benchmark Fibonacci

Kita bandingkan:

1. Fibonacci rekursif (Lua murni, lambat).
2. Fibonacci iteratif (Lua murni, lebih cepat).
3. Fibonacci dengan FFI array untuk menyimpan hasil.

Simpan file `benchmark_fib.lua`:

```lua
local ffi = require("ffi")

-- 1) Versi rekursif (tidak efisien, banyak pemanggilan fungsi)
local function fib_recursive(n)
  if n < 2 then return n end
  return fib_recursive(n-1) + fib_recursive(n-2)
end

-- 2) Versi iteratif menggunakan tabel Lua
local function fib_iterative(n)
  local a, b = 0, 1
  for i = 2, n do
    a, b = b, a + b
  end
  return b
end

-- 3) Versi menggunakan FFI array
ffi.cdef "typedef uint64_t u64;"
local u64_array = ffi.typeof("u64[?]")

local function fib_ffi(n)
  local arr = u64_array(n+1)
  arr[0], arr[1] = 0, 1
  for i = 2, n do
    arr[i] = arr[i-1] + arr[i-2]
  end
  return arr[n]
end

-- Utility benchmarking
local function benchmark(fn, n, reps)
  local t0 = os.clock()
  local result
  for i = 1, reps do
    result = fn(n)
  end
  local t1 = os.clock()
  return result, (t1 - t0)
end

-- Jalankan benchmark
local N = 40
local reps = 5

print("Benchmark Fibonacci untuk n="..N)
local r1, t1 = benchmark(fib_recursive, N, 1) -- rekursif cukup sekali
print("Rekursif:", r1, "time=", t1)

local r2, t2 = benchmark(fib_iterative, N, reps)
print("Iteratif:", r2, "time=", t2)

local r3, t3 = benchmark(fib_ffi, N, reps)
print("FFI:", r3, "time=", t3)
```

---

### Bedah Kode

**Baris 1**

```lua
local ffi = require("ffi")
```

* Memuat modul FFI untuk tipe data array C.

**Baris 4–7 (fib\_recursive)**

```lua
local function fib_recursive(n)
  if n < 2 then return n end
  return fib_recursive(n-1) + fib_recursive(n-2)
end
```

* Fungsi klasik, sederhana tapi lambat karena memanggil dirinya berulang tanpa caching.
* Kompleksitas eksponensial → buruk untuk angka besar.

**Baris 10–15 (fib\_iterative)**

```lua
local function fib_iterative(n)
  local a, b = 0, 1
  for i = 2, n do
    a, b = b, a + b
  end
  return b
end
```

* Implementasi iteratif.
* Kompleksitas linear O(n), lebih cepat daripada rekursif.
* Menggunakan variabel lokal `a` dan `b` untuk efisiensi.

**Baris 18–19 (definisi tipe)**

```lua
ffi.cdef "typedef uint64_t u64;"
local u64_array = ffi.typeof("u64[?])"
```

* Deklarasi tipe alias `u64`.
* `ffi.typeof("u64[?]")` artinya kita bisa buat array `u64` dengan panjang dinamis.

**Baris 21–27 (fib\_ffi)**

```lua
local function fib_ffi(n)
  local arr = u64_array(n+1)
  arr[0], arr[1] = 0, 1
  for i = 2, n do
    arr[i] = arr[i-1] + arr[i-2]
  end
  return arr[n]
end
```

* Alokasi array `arr` dengan panjang `n+1`.
* Inisialisasi dua elemen pertama.
* Iterasi untuk mengisi seluruh array dengan formula Fibonacci.
* Return hasil di indeks `n`.
* **Lebih cepat** karena:

  * array kontigu → cache-friendly
  * tipe fixed-size (`u64`) → JIT bisa mengoptimalkan.

**Baris 30–37 (benchmark function)**

```lua
local function benchmark(fn, n, reps)
  local t0 = os.clock()
  local result
  for i = 1, reps do
    result = fn(n)
  end
  local t1 = os.clock()
  return result, (t1 - t0)
end
```

* Utilitas benchmarking sederhana.
* Mengukur waktu total dengan `os.clock()`.
* Mengulang eksekusi `reps` kali untuk kestabilan hasil.

**Baris 40–50 (jalankan benchmark)**

```lua
local N = 40
local reps = 5

print("Benchmark Fibonacci untuk n="..N)
local r1, t1 = benchmark(fib_recursive, N, 1)
print("Rekursif:", r1, "time=", t1)

local r2, t2 = benchmark(fib_iterative, N, reps)
print("Iteratif:", r2, "time=", t2)

local r3, t3 = benchmark(fib_ffi, N, reps)
print("FFI:", r3, "time=", t3)
```

* Menjalankan semua versi.
* Rekursif hanya sekali karena lambat.
* Iteratif dan FFI dijalankan 5 kali untuk reliabilitas.
* Menampilkan hasil Fibonacci ke-N dan waktu eksekusi.

---

### Hasil yang Diharapkan

* Rekursif: sangat lambat (bisa hitungan detik).
* Iteratif: cepat (ms).
* FFI: sedikit lebih cepat atau setara dengan iteratif, tapi skalanya lebih jelas untuk N besar.

---

### Praktik Terbaik

* Gunakan **variabel lokal** dalam loop (lebih cepat daripada variabel global).
* Gunakan **FFI arrays** untuk data besar / numerik.
* Hindari rekursi dalam perhitungan numerik intensif di Lua.
* Untuk profiling lebih lanjut, gunakan `luajit -jv` (verbose JIT) atau `luajit -jp` (profiling) seperti yang didokumentasikan di [running LuaJIT](http://luajit.org/running.html).

---

### Visualisasi

```
fib_recursive(n)
   └── banyak pemanggilan ulang (lambat)
fib_iterative(n)
   └── loop sederhana → cepat
fib_ffi(n)
   └── array kontigu dengan tipe fixed-size
       → lebih cepat lagi pada data besar
```

---

Dengan ini, bagian **Optimisasi & Profiling** sudah tuntas.
<!--
Apakah saya lanjut membedah **Bagian 3: Ekosistem Praktis** dengan contoh nyata (misalnya pemakaian FFI di Neovim plugin atau embedding dalam aplikasi lain)?
-->
> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

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
