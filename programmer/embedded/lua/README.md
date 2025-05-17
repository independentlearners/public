Mau jadi master Lua? Mulailah dari akar dokumentasi resminya. Pertaman antara Lua 5.0 dan Lua 5.4.6 ada empat rilis minor besar (5.1, 5.2, 5.3, dan 5.4), masing-masing memperkenalkan perubahan-perubahan signifikan di bahasa, pustaka, dan API C. Jika kita hanya menghitung **fitur‐fitur utama** yang dicantumkan di tiap “readme” resmi. **Tip cepat:** Selalu sesuaikan versi manual dengan versi interpreter Lua yang kamu pakai. Jangan sampai membaca doc 5.4 sementara runtime-mu masih 5.1—bisa bikin kepala cenut! 😉

1. **Manual Resmi (Reference Manual)**
   – Lua 5.4: [https://www.lua.org/manual/5.4/](https://www.lua.org/manual/5.4/)
   – Daftar versi lain (5.1, 5.2, 5.3): [https://www.lua.org/manual.html](https://www.lua.org/manual.html)
   Di sini kamu dapat membaca spesifikasi Bahasa Lua, library standar, dan behaviour tiap fungsi built-in.

2. **Tutorial “Programming in Lua”**
   Buku resmi yang ditulis oleh pencipta Lua, Roberto Ierusalimschy.
   – Edisi online (Lua 5.3): [https://www.lua.org/pil/](https://www.lua.org/pil/)
   Versi cetak juga tersedia kalau kamu suka baca “hard copy”.

3. **Lua-users Wiki**
   Kumpulan tips, trik, contoh kode, dan FAQ dari komunitas:
   [https://lua-users.org/wiki/](https://lua-users.org/wiki/)

4. **Source Code & Langkah Build**
   Kalau mau dalami implementasi, cek kode sumber di:
   [https://www.lua.org/source.html](https://www.lua.org/source.html)

- **Lua 5.1 (21 Feb 2006)**:

  1. Modul system baru
  2. Garbage collector inkremental
  3. Mekanisme varargs baru
  4. Syntax baru untuk long strings & komentar
  5. Operator `mod` (%) dan `length` (#)
  6. Metatable untuk semua tipe
  7. Konfigurasi via `luaconf.h`
  8. Parser yang sepenuhnya reentrant ([lua.org][1])

- **Lua 5.2 (05 Des 2011)**:

  1. `pcall` & metamethods bisa di-`yield`
  2. Skema leksikal untuk global (`_ENV`)
  3. Ephemeron tables
  4. Pustaka bitwise ops (`bit32`)
  5. Light C functions
  6. Emergency garbage collector
  7. Statement `goto`
  8. Finalizer untuk table ([lua.org][2])

- **Lua 5.3 (12 Jan 2015)**:

  1. Tipe integer 64-bit (default)
  2. Dukungan resmi untuk 32-bit numbers
  3. Operator bitwise bawaan
  4. Dukungan dasar UTF-8
  5. Fungsi pack/unpack (seri nilai) ([lua.org][3])

- **Lua 5.4 (02 Mei 2023, tepatnya 5.4.6)**:

  1. Mode generasional untuk GC
  2. Variabel “to-be-closed”
  3. Variabel `const`
  4. Userdata dapat banyak user values
  5. Implementasi baru `math.random`
  6. Sistem peringatan (warning)
  7. Info debug argumen & return
  8. Semantik baru untuk `for` integer
  9. Argumen opsional `init` pada `string.gmatch`
  10. Fungsi `lua_resetthread` & `coroutine.close`
  11. Koersi string→number dipindah ke pustaka string ([lua.org][4])

**Total fitur utama**: 8 (5.1) + 8 (5.2) + 5 (5.3) + 11 (5.4) = **32 perubahan besar**.

Lua sendiri sejak awal dirancang sebagai bahasa _multi-paradigm_: utamanya **prosedural** dengan fasilitas **data description**, tapi juga mendukung **pemrograman fungsional** (first-class functions, closures), **object-oriented** ringan lewat tabel & metatable, serta **coroutines** untuk _collaborative multithreading_ ([Lua][1], [Wikipedia][2]). Sepanjang seri 5.x—dari 5.0 ke 5.4—karakternya tetap sama, tetapi **fitur inti** dan **mekanisme implementasi** berkembang cukup signifikan.

---

## 1. Lua 5.1 (rilis 21 Feb 2006)

**Fitur baru utama** (dibanding 5.0) ([Lua][3]):

- **Module system**: `module`/`require`, memudahkan pemisahan kode
- **Incremental GC**: pengumpulan sampah berjalan bertahap
- **Varargs**: `...` dengan `select` & `arg`
- **Long strings/komentar**: `[[ … ]]`
- **Operator `%` (mod) & `#` (length)**
- **Metatable untuk semua tipe**
- **Konfigurasi via `luaconf.h`**
- **Parser reentrant**

### Contoh kode 5.1

```lua
-- modul sederhana di file mymodule.lua
local M = {}
function M.greet(name)
  return "Halo, " .. name
end
return M

-- di main.lua
local mod = require("mymodule")
print(mod.greet("Pelajar"))
```

---

## 2. Lua 5.2 (rilis 16 Des 2011)

**Perubahan sejak 5.1** ([Lua][4]):

- `pcall` & metamethods **bisa di-yield**
- Skema global baru via **\_ENV**
- **Ephemeron tables** (weak-key/value advanced)
- **Bitwise ops** di pustaka `bit32`
- **Light C functions**
- **Emergency GC**
- **`goto`** statement
- **Finalizers** untuk tabel

### Contoh kode 5.2

```lua
-- skema _ENV: fungsi terisolasi
local _ENV = {print = print}  -- batasi global
function f()
  print(x)        -- x tidak di-resolve ke global luar
end

-- goto & label
local i = 1
::loop_start::
if i > 3 then return end
print(i)
i = i + 1
goto loop_start
```

---

## 3. Lua 5.3 (rilis 12 Jan 2015)

**Perubahan sejak 5.2** ([Lua][5]):

- **Tipe integer** (64-bit default)
- Dukungan 32-bit numbers
- **Operator bitwise** built-in (`&`, `|`, `~`, `<<`, `>>`)
- **UTF-8** library dasar (`utf8.*`)
- **Pack/unpack** nilai (`string.pack`, `string.unpack`)

### Contoh kode 5.3

```lua
-- integer vs float
local i = 5    -- integer
local f = 2.5  -- float
print(i + f)   -- 7.5

-- bitwise
print((5 & 3), (5 << 1))  -- 1, 10

-- packing
local s = string.pack("<I4I4", 100, 200)
local a, b = string.unpack("<I4I4", s)
print(a, b)  -- 100, 200
```

---

## 4. Lua 5.4 (rilis 02 Mei 2023; sekarang 5.4.6)

**Perubahan sejak 5.3** ([Lua][6]):

1. **Generational GC**
2. **To-be-closed variables** (`<close>`)
3. **`const` variables**
4. Userdata bisa **many user values**
5. `math.random` baru
6. **Warning system**
7. Debug info args & return
8. Semantik baru untuk **`for` integer**
9. Argumen opsional `init` di `string.gmatch`
10. Fungsi `lua_resetthread` & `coroutine.close`
11. Koersi string→number dipindah ke pustaka _string_
    …+ perbaikan minor & API tweaks

### Contoh kode 5.4

```lua
-- to-be-closed: memastikan file ditutup
local f <close> = io.open("data.txt", "r")
for line in f:lines() do
  print(line)
end  -- f:close() otomatis

-- const
local const x = 10
-- x = 5  --> error: cannot assign to const ‘x’

-- warning system
warn("Ini hanya peringatan")
```

---

## Panduan Belajar & Migrasi untuk Pelajar

1. **Instal interpreter versi spesifik** (mis. `lua5.1`, `lua5.2`, …)
2. **Baca “Changes” di manual resmi** untuk tiap versi (lihat link manual di lua.org/manual/5.x/readme.html)
3. **Tuliskan ulang contoh kecil** di tiap versi; uji perilaku (contoh varargs, metatable, `goto`, integer dsb.)
4. **Gunakan compatibility switches** di C API jika embed (lihat `luaL_newstate` flags)
5. **Perbandingkan output & error**: catat apa yang berubah (mis. `module` dihapus di 5.2)
6. **Jurnal kode**: buat catatan singkat tiap eksperimen dan hasilnya
7. **Bergabung komunitas** (lua-users mailing list, StackOverflow) untuk kasus nyata
8. **Tantangan mini-project**: porting script 5.1 sederhana ke 5.4, lalu terapkan fitur baru (mis. `const`, to-be-closed)

[1]: https://www.lua.org/manual/5.1/manual.html?utm_source=chatgpt.com "Lua 5.1 Reference Manual"
[2]: https://en.wikipedia.org/wiki/Lua?utm_source=chatgpt.com "Lua"
[3]: https://www.lua.org/versions.html?utm_source=chatgpt.com "version history - Lua"
[4]: https://www.lua.org/manual/5.2/readme.html?utm_source=chatgpt.com "Lua 5.2 readme"
[5]: https://www.lua.org/manual/5.3/readme.html?utm_source=chatgpt.com "Lua 5.3 readme"
[6]: https://www.lua.org/manual/5.4/readme.html "Lua 5.4 readme"

Selain itu, setiap rilis juga membawa **puluhan–ratusan** perbaikan bug, optimasi kinerja, dan tweak kecil di API C yang tidak tercatat sebagai “fitur utama”. Jadi jika ditotal keseluruhan — termasuk semua minor tweaks — jumlahnya jelas jauh lebih banyak, tetapi secara ringkas ada empat “loncatan” versi dengan **32 fitur baru utama**. Dengan cara iteratif—menjalankan, mengamati, dan mencatat—pelajar akan memahami **evolusi gaya koding** dan **peningkatan mekanisme** di tiap versi Lua. Jika menemui ketidakcocokan, dokumentasikan di catatan pribadi agar proses migrasi proyek nyata lebih mulus. Semangat eksperimen!

[1]: https://www.lua.org/versions.html?utm_source=chatgpt.com "version history - Lua"
[2]: https://www.lua.org/manual/5.2/readme.html?utm_source=chatgpt.com "Lua 5.2 readme"
[3]: https://www.lua.org/manual/5.3/readme.html?utm_source=chatgpt.com "Lua 5.3 readme"
[4]: https://www.lua.org/manual/5.4/readme.html?utm_source=chatgpt.com "Lua 5.4 readme"
