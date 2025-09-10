# [Modul 11 — LuaJIT][0]

Ini modul yang sangat penting karena menyentuh performa dan integrasi tingkat lanjut antara **Lua**, **JIT (Just-In-Time compiler)**, serta interaksi langsung dengan **C FFI (Foreign Function Interface)**.

<details>
  <summary>📃 Daftar Isi</summary>

---

### Struktur Pembelajaran Internal (mini-TOC)

* **11.1 Pengenalan LuaJIT**

  * Apa itu LuaJIT
  * Perbedaan dengan Lua standar
* **11.2 Just-In-Time Compilation**

  * Mekanisme kerja JIT di LuaJIT
  * Kelebihan & keterbatasan
* **11.3 FFI Library**

  * Pengenalan FFI
  * Deklarasi tipe & fungsi C langsung di Lua
* **11.4 Optimisasi & Benchmark**

  * Performa vs Lua standar
  * Studi kasus kecil
* **11.5 Studi Kasus Mini-Project**

  * Membuat binding sederhana ke pustaka C (contoh: fungsi `printf` dari libc)
* **11.6 Praktik Terbaik & Potensi Masalah**
* **11.7 Latihan & Kuiz**
* Visualisasi

</details>

---

## 11.1 Pengenalan LuaJIT

### Deskripsi & Peran

* **LuaJIT** = implementasi alternatif dari Lua yang mendukung **Just-In-Time compilation**, sehingga script Lua bisa berjalan hampir secepat C dalam banyak kasus.
* Digunakan luas di **game engine** (misalnya Garry’s Mod, Roblox), aplikasi embedded, dan tool dengan kebutuhan performa tinggi.
* Perbedaan besar dari Lua standar:

  * Kompiler JIT → bytecode Lua langsung ditranslasi ke machine code.
  * Built-in **FFI library** → interop dengan C tanpa perlu menulis modul C manual.

---

## 11.2 Just-In-Time Compilation

### Filosofi

* Lua normal → script → bytecode → VM interpreter.
* LuaJIT → script → bytecode → JIT → machine code (eksekusi langsung CPU).
* Hasil: peningkatan performa signifikan pada loop intensif, perhitungan numerik, dsb.

### Visualisasi

```
Lua Script → Bytecode → (Lua VM) → Interpreter
Lua Script → Bytecode → (LuaJIT JIT) → Native CPU code
```

---

## 11.3 FFI Library

### Deskripsi

* FFI = Foreign Function Interface.
* Memungkinkan deklarasi tipe dan fungsi C **langsung di Lua**, tanpa perlu compile `.so`/`.dll` manual.

### Contoh Kode

```lua
local ffi = require("ffi")

ffi.cdef[[
int printf(const char *fmt, ...);
]]

ffi.C.printf("Halo dari C lewat LuaJIT!\n")
```

* `ffi.cdef` → mendefinisikan deklarasi C.
* `ffi.C` → akses ke library standar C (`libc`).
* `printf` bisa dipanggil langsung.

👉 Tidak perlu bikin modul C dengan GCC, cukup FFI.

---

## 11.4 Optimisasi & Benchmark

### Studi Kasus Performa

Contoh perulangan besar:

```lua
local N = 1e7
local sum = 0
for i=1,N do
  sum = sum + i
end
print(sum)
```

* Lua standar: relatif lambat (loop interpreted).
* LuaJIT: jauh lebih cepat karena loop di-JIT-kan jadi native code.

---

## 11.5 Mini-Project: Binding Fungsi C

### Proyek: Akses fungsi `sqrt` dari libc

```lua
local ffi = require("ffi")

ffi.cdef[[
double sqrt(double x);
]]

local libm = ffi.load("m")  -- library matematika C (libm.so)

print("akar(9) =", libm.sqrt(9))
print("akar(2) =", libm.sqrt(2))
```

### Penjelasan

* `ffi.cdef` → deklarasi `double sqrt(double x);`.
* `ffi.load("m")` → load `libm.so` (library matematika).
* `libm.sqrt(9)` → panggil fungsi C langsung.

👉 Dengan FFI, Lua bisa memanfaatkan library C secara langsung.

---

## 11.6 Praktik Terbaik

* Gunakan LuaJIT untuk aplikasi yang **CPU-bound** (loop besar, numeric-heavy).
* Untuk integrasi library C kompleks → gunakan FFI daripada menulis binding manual.
* Hindari terlalu sering `ffi.cdef` di runtime, definisikan sekali.
* Ingat: LuaJIT fokus pada Lua 5.1 compatibility (plus beberapa fitur 5.2/5.3). Jadi beberapa kode Lua 5.4 murni mungkin tidak kompatibel.

---

## 11.7 Potensi Masalah

* LuaJIT tidak selalu mendukung semua fitur baru Lua standar.
* Platform tertentu (misal ARM 64-bit dengan OS tertentu) bisa memiliki keterbatasan JIT.
* FFI memberi akses penuh ke memory C — salah pakai pointer bisa menyebabkan segfault.

---

## 11.8 Latihan & Kuiz

1. Gunakan FFI untuk binding `time_t time(time_t *t)` dari libc → cetak waktu sekarang.
2. Buat FFI binding untuk `strlen(const char*)` dan uji dengan string Lua.
3. Bandingkan kecepatan loop besar di Lua biasa vs LuaJIT.

---

## Referensi

* LuaJIT official: [http://luajit.org](http://luajit.org)
* LuaJIT FFI documentation: [http://luajit.org/ext\_ffi.html](http://luajit.org/ext_ffi.html)
* Benchmarks: [http://luajit.org/performance.html](http://luajit.org/performance.html)

---

<!--
Apakah Anda ingin saya **buat mini-project LuaJIT yang lebih kompleks**, misalnya binding ke library grafik (`SDL`/`OpenGL`) lewat FFI, atau kita lanjut ke **Modul 12: Coroutines & Concurrency**?
-->

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-10/README.md
[selanjutnya]: ../bagian-12/README.md

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
