# **[Modul 11: LuaJIT & FFI][0]**

**Disini kita akan:**

* Memahami konsep inti LuaJIT dan FFI secara ringkas namun akurat (dengan rujukan resmi).
* Membuat **mini-project** lengkap: *Vector3D menggunakan LuaJIT FFI* (module) + *Particle simulation* (latihan/praktik).
* **Memahami setiap baris kode** dalam kedua file itu — tidak ada bagian yang dilewatkan.
* Tambahkan instruksi instalasi, cara menjalankan, dan catatan praktik terbaik / bahaya.

Semua penjelasan disusun secara teknis, dan bisa dijadikan referensi pembelajaran mandiri.

---

# 1. Inti Modul — ringkasan singkat (dengan referensi)

* **LuaJIT** adalah implementasi Lua dengan JIT (Just-In-Time) compiler yang sering jauh lebih cepat daripada interpreter biasa. LuaJIT menyertakan **FFI (Foreign Function Interface)** yang memungkinkan Anda mendeklarasikan tipe C, membuat `struct`/array, dan memanggil fungsi C langsung dari Lua tanpa menulis binding C manual. ([LuaJIT][1])
* FFI cocok untuk jumlah besar operasi numerik / akses memori terstruktur karena menghindari overhead pemanggilan C biasa; namun FFI juga membawa risiko (unsafe memory, tipe yang tidak tervalidasi) sehingga harus dipakai hati-hati. Baca panduan resmi FFI untuk semantik dan praktik. ([LuaJIT][2])
* Di Arch Linux (contoh distro Anda), paket `luajit` tersedia di repositori resmi; pasang `luajit` untuk menjalankan skrip ini. ([Arch Linux][3])

---

# 2. Mini-project 1 — **Module Vector3D FFI**

Tujuan: buat modul `vector3d_ffi.lua` yang mendefinisikan tipe C `vec3` lewat `ffi.cdef`, menetapkan `ffi.metatype` dengan metamethod (addition, subtraction, multiplication (dot/skalar), tostring) dan method (magnitude, normalize, cross). Module ini menggantikan versi Lua murni dan binding C: lebih ringkas, performan tinggi pada LuaJIT.

Simpan file `vector3d_ffi.lua`.

```lua
-- vector3d_ffi.lua
-- Modul Vector3D menggunakan LuaJIT FFI
local ffi = require("ffi")

-- 1) deklarasi tipe C (struct vec3)
ffi.cdef[[
typedef struct { double x; double y; double z; } vec3;
]]

-- 2) definisi table metode (dipakai oleh __index)
local methods = {}

function methods:magnitude()
  -- 'self' adalah cdata vec3
  return math.sqrt(self.x*self.x + self.y*self.y + self.z*self.z)
end

function methods:normalize()
  local mag = self:magnitude()
  if mag == 0 then
    return ffi.new("vec3", 0.0, 0.0, 0.0)
  end
  return ffi.new("vec3", self.x / mag, self.y / mag, self.z / mag)
end

function methods:cross(other)
  return ffi.new("vec3",
    self.y * other.z - self.z * other.y,
    self.z * other.x - self.x * other.z,
    self.x * other.y - self.y * other.x
  )
end

function methods:dot(other)
  return self.x*other.x + self.y*other.y + self.z*other.z
end

-- 3) metamethods (operasi + - * tostring)
local mt = {
  __index = methods,
  __add = function(a,b) return ffi.new("vec3", a.x + b.x, a.y + b.y, a.z + b.z) end,
  __sub = function(a,b) return ffi.new("vec3", a.x - b.x, a.y - b.y, a.z - b.z) end,
  __mul = function(a,b)
    -- jika salah satu number => skalar * vektor
    if type(a) == "number" then
      return ffi.new("vec3", a * b.x, a * b.y, a * b.z)
    elseif type(b) == "number" then
      return ffi.new("vec3", b * a.x, b * a.y, b * a.z)
    else
      -- kedua vektor => dot product (kembalikan number)
      return a.x*b.x + a.y*b.y + a.z*b.z
    end
  end,
  __tostring = function(v) return string.format("(%g, %g, %g)", v.x, v.y, v.z) end
}

-- 4) buat ctype dengan metatype
local vec3 = ffi.metatype("vec3", mt)

-- 5) modul publik (constructor)
local M = {}
M.new = function(x,y,z) return vec3(x or 0.0, y or 0.0, z or 0.0) end
return M
```

---

## Penjelasan **baris demi baris** (`vector3d_ffi.lua`)

Saya akan menjelaskan setiap kelompok baris — untuk setiap baris/expresssion, apa fungsinya, kenapa diperlukan.

### Baris 1–2

```lua
-- vector3d_ffi.lua
-- Modul Vector3D menggunakan LuaJIT FFI
```

Komentar: dokumentasi singkat file.

### Baris 3

```lua
local ffi = require("ffi")
```

* Muat library FFI dari LuaJIT. `ffi` memberi fungsi: `cdef`, `new`, `metatype`, dll. Tanpa ini kode FFI tidak jalan (hanya ada di LuaJIT).
* **Catatan eksekusi**: `require("ffi")` memuat modul internal LuaJIT; bukan modul `.so` biasa.

(Rujukan FFI docs: ext\_ffi.) ([LuaJIT][4])

### Baris 6–10

```lua
ffi.cdef[[
typedef struct { double x; double y; double z; } vec3;
]]
```

* `ffi.cdef` menerima teks deklarasi C (header-like). Di sini kita mendefinisikan `typedef struct` bernama `vec3` yang memiliki tiga `double`: `x,y,z`.
* Setelah ini, dari Lua Anda bisa membuat nilai bertipe `vec3` dengan `ffi.new("vec3", x,y,z)`.
* Ini **tidak** mengompilasi C, melainkan memberitahu FFI tentang layout tipe supaya LuaJIT bisa mengalokasikan dan mengakses memory seolah-olah itu struct C.
* Penting: deklarasi harus mengikuti sintaks C yang valid (lihat FFI tutorial). ([LuaJIT][2])

### Baris 13

```lua
local methods = {}
```

* Table lokal untuk menyimpan method-method instance seperti `magnitude`, `normalize`, `cross`, `dot`. Kita gunakan ini sebagai `__index` pada metatype supaya `v:magnitude()` dan `v:cross(other)` bekerja.

### Baris 15–18 (magnitude)

```lua
function methods:magnitude()
  -- 'self' adalah cdata vec3
  return math.sqrt(self.x*self.x + self.y*self.y + self.z*self.z)
end
```

* `function methods:magnitude()` adalah sugar untuk `function methods.magnitude(self)`.
* `self` adalah objek `vec3` (FFI cdata). Kita dapat mengakses bidangnya sebagai `self.x` dll.
* Fungsi mengembalikan magnitudo (√(x²+y²+z²)). Menggunakan `math.sqrt` dari Lua.
* Performa: JIT akan mengoptimalkan loop/hot call jika dipanggil berulang.

### Baris 20–27 (normalize)

```lua
function methods:normalize()
  local mag = self:magnitude()
  if mag == 0 then
    return ffi.new("vec3", 0.0, 0.0, 0.0)
  end
  return ffi.new("vec3", self.x / mag, self.y / mag, self.z / mag)
end
```

* Hitung magnitudo kemudian bagi setiap komponen.
* Jika `mag == 0` kembalikan vektor nol untuk menghindari pembagian dengan nol.
* Fungsi **tidak** mengubah `self`; ia mengembalikan **vektor baru** (`ffi.new` menghasilkan cdata baru).

### Baris 29–37 (cross)

```lua
function methods:cross(other)
  return ffi.new("vec3",
    self.y * other.z - self.z * other.y,
    self.z * other.x - self.x * other.z,
    self.x * other.y - self.y * other.x
  )
end
```

* Implementasi cross product: hasil adalah vector yang orthogonal ke `self` dan `other`.
* Mengembalikan `ffi.new("vec3", ...)`.

### Baris 39–41 (dot)

```lua
function methods:dot(other)
  return self.x*other.x + self.y*other.y + self.z*other.z
end
```

* Dot product mengembalikan `number`.

### Baris 44–64 (metamethods)

```lua
local mt = {
  __index = methods,
  __add = function(a,b) return ffi.new("vec3", a.x + b.x, a.y + b.y, a.z + b.z) end,
  __sub = function(a,b) return ffi.new("vec3", a.x - b.x, a.y - b.y, a.z - b.z) end,
  __mul = function(a,b)
    if type(a) == "number" then
      return ffi.new("vec3", a * b.x, a * b.y, a * b.z)
    elseif type(b) == "number" then
      return ffi.new("vec3", b * a.x, b * a.y, b * a.z)
    else
      return a.x*b.x + a.y*b.y + a.z*b.z
    end
  end,
  __tostring = function(v) return string.format("(%g, %g, %g)", v.x, v.y, v.z) end
}
```

* `__index = methods` → otomatis menyediakan semua function di `methods` sebagai `v:method()` ketika mengakses field yang tidak ada di instance. Ini memungkinkan `v:magnitude()` bekerja.
* `__add` & `__sub` → mengembalikan `vec3` baru hasil penjumlahan/pengurangan komponen.
* `__mul` → tiga kasus: `number * vec` (skalar), `vec * number`, `vec * vec` (dot → number). `type()` pada operand mengecek apakah `a` atau `b` adalah Lua number. Ketika keduanya cdata vec3, `type(a)` tidak mengembalikan "cdata" sebagai "number", sehingga masuk ke cabang terakhir.

  * **Catatan**: perilaku ini membuat operator `*` bekerja seperti pada implementasi C sebelumnya: fleksibel tapi pengguna harus ingat konteks (dot product vs skalar).
* `__tostring` → format string untuk `print(v)`.

### Baris 67

```lua
local vec3 = ffi.metatype("vec3", mt)
```

* `ffi.metatype` mengasosiasikan metatable `mt` ke ctype `"vec3"`. Hasilnya `vec3` menjadi *constructor* tipe: memanggil `vec3(1,2,3)` membuat nilai `vec3`.
* Ini membuat cdata bertingkah seperti object: operator overloading & method lookup bekerja.

(Rujukan FFI metatype semantics.) ([LuaJIT][5])

### Baris 70–72

```lua
local M = {}
M.new = function(x,y,z) return vec3(x or 0.0, y or 0.0, z or 0.0) end
return M
```

* Kemasan module: kembalikan tabel dengan fungsi `new`. Anda bisa juga langsung `return vec3` tetapi pola `M.new` mirip dengan modul Lua konvensional dan memudahkan migrasi dari modul non-FFI.

---

## Cara menjalankan modul FFI ini

1. Pastikan Anda menjalankan **luajit**, bukan `lua`. Contoh:

   ```bash
   luajit -v    # cek versi
   ```
2. Letakkan `vector3d_ffi.lua` di folder kerja, lalu gunakan dari script:

   ```lua
   local Vec3 = require("vector3d_ffi")
   local a = Vec3.new(1,2,3)
   local b = Vec3.new(4,5,6)
   print(a, b)            -- menggunakan __tostring
   print("a+b=", a+b)
   print("a·b=", a*b)     -- dot product
   print("a x b=", a:cross(b))
   print("|a|=", a:magnitude(), "normalized", a:normalize())
   ```
3. Jalankan: `luajit main.lua` atau `luajit -l vector3d_ffi -e '...'` sesuai kebutuhan.

---

# 3. Mini-project 2 — **Particle Simulation (FFI arrays)**

Tujuan: tunjukkan cara buat array `vec3[n]` di FFI (kontigu memori), inisialisasi posisi & kecepatan, dan lakukan update sederhana (Euler integration). Ini mendemonstrasikan keunggulan FFI untuk array besar dan akses cepat ke memori.

Simpan file `particle_sim_ffi.lua`.

```lua
-- particle_sim_ffi.lua
local ffi = require("ffi")
local VecMod = require("vector3d_ffi") -- menggunakan modul sebelumnya
local vec3c = ffi.typeof("vec3")       -- ctype constructor (alias)

-- parameter simulasi
local N = 10000         -- jumlah partikel (sesuaikan RAM / JIT)
local STEPS = 200       -- jumlah iterasi
local dt = 0.016        -- timestep (~60 FPS)

-- alokasi array cdata: positions & velocities (kontigu)
local positions = ffi.new("vec3[?]", N)
local velocities = ffi.new("vec3[?]", N)

-- inisialisasi sebaran acak (gunakan math.random)
math.randomseed(os.time())
for i = 0, N-1 do
  positions[i] = vec3c(math.random(), math.random(), math.random())
  velocities[i] = vec3c((math.random()-0.5)*0.1, 0, (math.random()-0.5)*0.1)
end

-- loop utama (hot loop -> JIT akan mengoptimalkan jika stabil)
local t0 = os.clock()
for step = 1, STEPS do
  for i = 0, N-1 do
    -- Euler integration tanpa gaya: p += v * dt
    local v = velocities[i]
    positions[i].x = positions[i].x + v.x * dt
    positions[i].y = positions[i].y + v.y * dt
    positions[i].z = positions[i].z + v.z * dt
    -- (opsional) batas sederhana agar tidak melayang tak terbatas
    if positions[i].x > 100 then positions[i].x = -100 end
  end
end
local t1 = os.clock()
print(string.format("Sim selesai — partikel=%d steps=%d time=%.3fs", N, STEPS, t1 - t0))

-- contoh akses hasil (tampilkan 5 pertama)
for i = 0, 4 do
  print(i, positions[i])
end
```

---

## Penjelasan **rincian** (`particle_sim_ffi.lua`)

Saya uraikan semua baris / alasan:

### Baris 1–3

```lua
local ffi = require("ffi")
local VecMod = require("vector3d_ffi") -- menggunakan modul sebelumnya
local vec3c = ffi.typeof("vec3")       -- ctype constructor (alias)
```

* `ffi` dimuat.
* Kita require modul `vector3d_ffi` yang dibuat sebelumnya (mengembalikan tabel berisi `new`). Kita tidak *harus* menggunakan `VecMod` langsung di loop karena kita memakai `ffi.typeof` untuk membuat constructor ctype cepat. `ffi.typeof("vec3")` memberi constructor `vec3c` yang bisa dipanggil: `vec3c(x,y,z)` — sedikit lebih cepat daripada `VecMod.new` karena pemanggilan lebih langsung ke ctype. Ini pola umum untuk performa.
* Alasan memakai `ffi.typeof` di simulasi: mengurangi overhead pembuatan cdata di inner loop.

### Baris 6–9 (param)

```lua
local N = 10000
local STEPS = 200
local dt = 0.016
```

* Parameter simulasi: jumlah partikel, langkah, dan timestep. Anda bisa menyesuaikan `N`/`STEPS` agar mesin Anda mampu.

### Baris 12–13 (alokasi array)

```lua
local positions = ffi.new("vec3[?]", N)
local velocities = ffi.new("vec3[?]", N)
```

* `ffi.new("vec3[?]", N)` membuat C array kontigu berukuran `N` elemen dari tipe `vec3`. Aksesnya via indeks 0..N-1.
* Keuntungan: memori terdistribusi secara kontigu → akses cache-friendly dan cepat, cocok untuk JIT optimisasi.

### Baris 16–21 (inisialisasi)

```lua
math.randomseed(os.time())
for i = 0, N-1 do
  positions[i] = vec3c(math.random(), math.random(), math.random())
  velocities[i] = vec3c((math.random()-0.5)*0.1, 0, (math.random()-0.5)*0.1)
end
```

* `math.randomseed` set seed. Loop menginisialisasi posisi dan kecepatan tiap partikel.
* Indeks pada array FFI dimulai dari 0 (beda dengan table Lua yang biasa dari 1) — penting diingat.
* `velocities[i]` menggunakan vektor kecil kecepatan. Nilai skala kecil supaya update tidak melompat besar.

### Baris 24–33 (main loop)

```lua
local t0 = os.clock()
for step = 1, STEPS do
  for i = 0, N-1 do
    local v = velocities[i]
    positions[i].x = positions[i].x + v.x * dt
    positions[i].y = positions[i].y + v.y * dt
    positions[i].z = positions[i].z + v.z * dt
    if positions[i].x > 100 then positions[i].x = -100 end
  end
end
local t1 = os.clock()
```

* `os.clock()` untuk mengukur waktu CPU yang diperlukan (sederhana).
* Double loop: outer over steps, inner over particle index — inner adalah *hot loop* yang akan mendapat manfaat JIT bila pola eksekusi stabil.
* Kita baca `v = velocities[i]` sekali per iterasi untuk mengurangi indexing berulang.
* Update posisi pakai operasi numerik sederhana (Euler). Akses dan update field `.x` `.y` `.z` pada cdata sangat cepat.
* Batas sederhana (wrap) untuk mencegah posisi melarikan diri ke nilai besar.

### Baris 35 (print hasil timing)

```lua
print(string.format("Sim selesai — partikel=%d steps=%d time=%.3fs", N, STEPS, t1 - t0))
```

* Menampilkan waktu total.

### Baris 38–40 (contoh output beberapa posisi)

```lua
for i = 0, 4 do
  print(i, positions[i])
end
```

* Menampilkan 5 partikel pertama. `positions[i]` di-print menggunakan metamethod `__tostring` yang sudah didefinisikan di `vector3d_ffi` module.

---

# 4. Prasyarat & Instruksi instalasi (singkat)

1. **Instal LuaJIT** (Arch Linux example):

   ```bash
   sudo pacman -S luajit
   ```

   Paket tersedia di repositori Arch (paket `luajit`). ([Arch Linux][3])

2. **Jalankan** skrip dengan interpreter `luajit` (bukan `lua`):

   ```bash
   luajit main.lua
   # atau
   luajit particle_sim_ffi.lua
   ```

3. Jika Anda menggunakan Neovim (embedded Lua 5.1/5.4), ingat bahwa FFI hanya hadir di **LuaJIT** (meskipun Neovim 0.5+ menyediakan LuaJIT/luajit-compat). Pastikan runtime Anda benar.

4. Baca dokumentasi FFI (cdef, metatype, semantics) untuk memahami batasan dan detil perilaku. ([LuaJIT][2])

---

# 5. Praktik terbaik, batasan & bahaya

* **Performance**: FFI cepat untuk operasi numerik dan akses memori terstruktur; gunakan `ffi.typeof` + `ffi.new("T[?]", n)` untuk alokasi array besar. JIT akan menempel pada loop yang stabil. (Dana JIT berpengaruh pada HOTT loops). ([LuaJIT][1])
* **Keamanan**: FFI memberi akses langsung ke memori — salah penanganan pointer/offset dapat menyebabkan crash (segfault) dan bug yang sulit ditelusuri. Gunakan validasi saat membaca input eksternal. Baca `FFI semantics`. ([LuaJIT][6])
* **Portabilitas**: LuaJIT mengikuti semantik Lua 5.1 (meskipun ada patch), jadi ada perbedaan jika Anda pindah ke Lua 5.3/5.4 murni. Untuk proyek lintas-platform, pastikan target runtime mendukung LuaJIT/FFI.
* **Tidak untuk sandboxing**: Jangan beri FFI akses ke kode pihak ketiga yang tidak dipercaya — FFI dapat memanggil fungsi C dan menulis memori.

---

# 6. Referensi (bahan bacaan yang wajib dibuka)

* LuaJIT FFI — overview & motivasi. ([LuaJIT][4])
* LuaJIT FFI Tutorial — contoh penggunaan `cdef`, `ffi.new`, `ffi.metatype`. ([LuaJIT][2])
* FFI API reference (fungsi-fungsi `ffi.*`). ([LuaJIT][5])
* Instalasi / paket Arch Linux (contoh distro): `luajit` di repositori extra. ([Arch Linux][3])

---

# 7. Rangkuman singkat & langkah berikutnya

* Anda sekarang memiliki dua artefak praktis:

  1. `vector3d_ffi.lua` — modul vektor berbasis FFI lengkap dengan metamethod & method.
  2. `particle_sim_ffi.lua` — contoh penggunaan array `vec3[n]` untuk simulasi sederhana (menunjukkan skenario hot loop yang diuntungkan oleh JIT + FFI).

<!--
* Jika Anda ingin melanjutkan, pilihan berikut masuk akal:

  * `profiling` — bandingkan kecepatan antara versi Lua murni dan LuaJIT+FFI (saya bisa bantu benchmark terukur).
  * `FFI ↔ C` — tunjukan bagaimana memanggil fungsi di shared library (`.so`) lewat FFI (ffi.C atau ffi.load), contoh memanggil `libm` atau modul C yang Anda buat.
  * `LuaJIT advanced` — gunakan JIT pragmas, optimasi hot loops, atau safety patterns untuk mencegah segfault.

Pilih salah satu topik lanjutannya (mis. `benchmark`, `ffi_call_c`, `profiling`) jika Anda ingin saya kerjakan langsung.

-->

[1]: https://luajit.org/?utm_source=chatgpt.com "The LuaJIT Project"
[2]: https://luajit.org/ext_ffi_tutorial.html?utm_source=chatgpt.com "FFI Tutorial - LuaJIT"
[3]: https://archlinux.org/packages/extra/x86_64/luajit/?utm_source=chatgpt.com "luajit 2.1.1753364724-1 (x86_64) - Arch Linux"
[4]: https://luajit.org/ext_ffi.html?utm_source=chatgpt.com "FFI Library - LuaJIT"
[5]: https://luajit.org/ext_ffi_api.html?utm_source=chatgpt.com "ffi.* API Functions - LuaJIT"
[6]: https://luajit.org/ext_ffi_semantics.html?utm_source=chatgpt.com "FFI Semantics - LuaJIT"

<!--
Baik, saya luruskan dulu tentang posisi kita di **kurikulum** yang sedang kita dalami.

Saya sudah menuntun Anda sampai **Modul 11: LuaJIT & FFI** dengan mini-proyek `Vector3D` dan `Particle Simulation`. Jadi alur kurikulum yang sebelumnya telah kita audit dan kembangkan berjalan sebagai berikut:

1. **Fase Dasar** – instalasi, sintaks dasar, tipe data, fungsi, OOP sederhana.
2. **Fase Menengah** – modul, paket, struktur proyek, error handling, interaksi sistem.
3. **Fase Lanjutan** – integrasi Neovim plugin, abstraksi CLI, dan latihan dengan mini-proyek.
4. **Modul 8–10** – kita bahas topik seperti struktur data, algoritma dasar, dan integrasi praktis.
5. **Modul 11** – saat ini: **LuaJIT & FFI** sudah selesai kita kerjakan dengan contoh modul `vector3d_ffi.lua` dan simulasi partikel.

Artinya, **kurikulum Anda masih berlanjut setelah Modul 11**. Dari audit awal, biasanya setelah FFI ada materi lanjutan tentang:

* **Integrasi dengan C library eksternal** (memanggil fungsi `libc`, `libm`, atau shared library buatan sendiri).
* **Optimisasi & Profiling** — membandingkan Lua murni dengan FFI/JIT.
* **Ekosistem Praktis** — penggunaan LuaJIT dalam dunia nyata: misalnya untuk Neovim plugin yang membutuhkan kecepatan, atau embedding dalam aplikasi game/engine.
* **Pengembangan proyek skala lebih besar** — membuat kombinasi CLI + plugin + binding C ringan.

Saya ingin konfirmasi: apakah Anda ingin saya **lanjut langsung ke Modul 12** (yang harusnya setelah FFI, biasanya soal **pemanggilan library C lewat FFI**), atau Anda ingin saya **rekap kurikulum penuh lagi** dari awal fase sampai Modul 11 agar terlihat gambaran menyeluruh posisi belajar saat ini?
-->
Biasanya setelah FFI ada materi lanjutan tentang pengembanga mungkin anda tertarik bisa memilih beberapa diantara berikut:
<details>
  <summary>📃 Daftar Isi</summary>

**[Integrasi dengan C library eksternal][1]**

Optimisasi & Profiling

Ekosistem Praktis

Pengembangan proyek skala lebih besar

</details>
<!--
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
[1]: ../bagian-1/README.md
[2]: ../bagian-2/README.md
[3]: ../bagian-3/README.md
[4]: ../bagian-4/README.md
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
