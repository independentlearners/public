<!--<details>
  <summary>📃 Daftar Isi</summary>

</details>

Baik, kita fokus dulu. Empat bagian lanjutan setelah **Modul 11 (LuaJIT & FFI)** tadi adalah:

1. **Integrasi dengan C library eksternal**
2. **Optimisasi & Profiling**
3. **Ekosistem Praktis**
4. **Pengembangan proyek skala lebih besar**

Sesuai permintaan Anda, saya akan **bedah satu per satu** seperti sebelumnya: setiap kode akan dijelaskan baris demi baris, fungsinya, dan tujuannya. Kita mulai dari **bagian pertama** dulu agar runtut dan mendalam.
-->

---

# **[Bagian 1: Integrasi dengan C Library Eksternal][0]**

### Deskripsi & Peran dalam Kurikulum

* Tujuan: memahami bagaimana memanggil fungsi C yang sudah ada di sistem (misalnya `libc` atau `libm`) langsung dari LuaJIT menggunakan FFI.
* Penting karena:

  * Ini membuka akses penuh ke pustaka sistem (fungsi matematika tingkat lanjut, operasi file tingkat rendah, jaringan, dsb.).
  * Menjadi jembatan untuk menggunakan library C yang tidak memiliki binding Lua resmi.
* Filosofi: LuaJIT bukan hanya interpreter, tapi jembatan ke dunia C. FFI menjadikan Lua bahasa "lem" yang bisa menempelkan berbagai pustaka C tanpa perlu menulis binding manual.

---

### Contoh Mini Proyek: Memanggil Fungsi `printf` & `cos` dari `libc/libm`

Simpan sebagai `ffi_c_example.lua`:

```lua
local ffi = require("ffi")

-- 1) Deklarasi fungsi C yang akan dipakai
ffi.cdef[[
int printf(const char *fmt, ...);
double cos(double x);
]]

-- 2) Memanggil fungsi dari libc (printf)
ffi.C.printf("Hello from C: %d %s\n", 2025, "LuaJIT FFI")

-- 3) Memanggil fungsi dari libm (cosinus)
local angle = math.pi / 3  -- 60 derajat
local result = ffi.C.cos(angle)
print("cos(60°) from C libm:", result)
```

---

### Bedah Kode

**Baris 1**

```lua
local ffi = require("ffi")
```

* Memuat modul FFI bawaan LuaJIT.
* Tanpa ini, tidak bisa mengakses fungsi C.

**Baris 4–7**

```lua
ffi.cdef[[
int printf(const char *fmt, ...);
double cos(double x);
]]
```

* `ffi.cdef` mendeklarasikan prototipe fungsi C yang kita perlukan.
* `printf` → didefinisikan di `libc`, dengan parameter format string dan variadic argument.
* `cos` → fungsi trigonometri di `libm`, menerima `double` dan mengembalikan `double`.
* Deklarasi harus sesuai header aslinya (misalnya `<stdio.h>` untuk `printf`, `<math.h>` untuk `cos`).

**Baris 10**

```lua
ffi.C.printf("Hello from C: %d %s\n", 2025, "LuaJIT FFI")
```

* `ffi.C` adalah namespace yang otomatis memetakan ke simbol-simbol dari *default C library* (biasanya `libc` pada Linux).
* Kita memanggil `printf` seolah-olah fungsi Lua.
* `%d` akan diganti angka, `%s` diganti string.
* Hasilnya: teks ditulis ke `stdout` oleh fungsi C asli.

**Baris 13–15**

```lua
local angle = math.pi / 3
local result = ffi.C.cos(angle)
print("cos(60°) from C libm:", result)
```

* `angle` diset ke π/3 radian (≈ 60 derajat).
* `ffi.C.cos` memanggil fungsi `cos` dari C standard math library.
* Hasilnya: `0.5` (nilai cos 60°).
* `print` dipakai untuk menunjukkan hasil ke terminal (bagian ini fungsi Lua biasa, bukan FFI).

---

### Praktik Terbaik & Potensi Kesalahan

* **Selalu cocokkan tanda tangan fungsi** dengan header C aslinya. Salah deklarasi bisa bikin crash (misalnya salah tipe return).
* **Variadic functions** (seperti `printf`) butuh ekstra hati-hati: pastikan argumen sesuai format string.
* Jangan gunakan FFI untuk library yang sudah ada binding stabilnya, kecuali memang perlu kecepatan/akses fitur tambahan.
* Gunakan dokumentasi header C (`man printf`, `man cos`) untuk validasi tanda tangan.

---

### Rekomendasi Visualisasi

Diagram sederhana untuk menunjukkan alurnya:

```
LuaJIT Script
    │
    ▼
[ ffi.cdef ]  --> mendeklarasikan fungsi C
    │
    ▼
[ ffi.C ] ----> namespace C symbols
    │
    ├── printf() -> output ke stdout
    └── cos()    -> hitung nilai trigonometrik
```

---

Dengan ini, bagian **Integrasi C library eksternal** sudah jelas.

<!--Apakah Anda ingin saya langsung membedah **Bagian 2: Optimisasi & Profiling** (lengkap dengan kode pembanding antara Lua murni vs FFI/JIT), atau menunggu dulu sampai bagian ini benar-benar mantap?-->


> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

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
