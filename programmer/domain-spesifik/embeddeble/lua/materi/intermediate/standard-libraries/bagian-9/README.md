# [Modul 9 — Metatable & Metamethods][0]

Inilah fitur yang membuat Lua sangat fleksibel. Dengan **metatable**, kita bisa “mengajarkan” tabel berperilaku seperti tipe data baru. Metamethod adalah “aturan ajaib” yang menentukan bagaimana sebuah operasi dijalankan pada tabel.

<details>
  <summary>📃 Daftar Isi</summary>

---

### Struktur Pembelajaran Internal (mini-TOC)

* **9.1 Pengenalan Metatable**

  * Apa itu metatable
  * Filosofi: table sebagai objek universal
* **9.2 Dasar Metamethod**

  * Definisi metamethod
  * Cara memasang metatable dengan `setmetatable`
* **9.3 Metamethod Populer**

  * `__tostring`
  * `__add`, `__sub`, `__mul`, `__div`
  * `__index`, `__newindex`
  * `__call`
  * `__eq`, `__lt`, `__le`
* **9.4 Studi Kasus**

  * Membuat class sederhana (vektor 2D)
  * Overloading operator
  * Akses properti otomatis
* **9.5 Praktik Terbaik & Kesalahan Umum**
* **9.6 Latihan & Kuiz**
* Visualisasi

</details>

---

## 9.1 Pengenalan Metatable

### Deskripsi & Peran

* **Table** adalah satu-satunya struktur data kompleks di Lua.
* Dengan **metatable**, kita bisa memberikan **aturan khusus** pada tabel.
* Contoh: tabel yang bisa dijumlahkan, tabel yang bertindak seperti objek, tabel yang bisa dipanggil seperti fungsi.

### Filosofi

Lua minimalis. Tidak ada class atau OOP bawaan. Tapi dengan **metatable**, pengguna bisa membangun sendiri sistem OOP, operator overloading, atau DSL (domain-specific language).

---

## 9.2 Dasar Metamethod

### Membuat Metatable

```lua
local t = {}
local mt = {}

setmetatable(t, mt)  -- pasang mt sebagai metatable dari t
```

* `setmetatable(table, metatable)` → memasang metatable.
* `getmetatable(table)` → mengambil metatable.

### Contoh `__tostring`

```lua
local t = {1, 2, 3}
local mt = {
  __tostring = function(tbl)
    return "Isi: " .. table.concat(tbl, ", ")
  end
}
setmetatable(t, mt)

print(t)  -- "Isi: 1, 2, 3"
```

👉 Metamethod `__tostring` menentukan bagaimana tabel ditampilkan saat `print`.

---

## 9.3 Metamethod Populer

### 1. Operator Aritmetika

```lua
local Vec = {}
Vec.__index = Vec

function Vec.new(x, y)
  return setmetatable({x=x, y=y}, Vec)
end

function Vec.__add(a, b)
  return Vec.new(a.x + b.x, a.y + b.y)
end

local v1 = Vec.new(1, 2)
local v2 = Vec.new(3, 4)
local v3 = v1 + v2
print(v3.x, v3.y)  -- 4 6
```

👉 Dengan `__add`, kita bisa menjumlahkan dua tabel seolah-olah objek.

---

### 2. Akses Properti dengan `__index`

```lua
local mt = {
  __index = function(tbl, key)
    return key .. " tidak ada"
  end
}

local t = setmetatable({}, mt)
print(t.hello)  -- "hello tidak ada"
```

👉 `__index` dipanggil saat properti tidak ditemukan.

---

### 3. `__newindex`

```lua
local mt = {
  __newindex = function(tbl, key, value)
    print("Menambahkan:", key, "=", value)
    rawset(tbl, key, value)  -- simpan secara manual
  end
}

local t = setmetatable({}, mt)
t.name = "Lua"  -- "Menambahkan: name = Lua"
```

👉 `__newindex` dipanggil saat properti baru ditambahkan.

---

### 4. `__call`

```lua
local mt = {
  __call = function(tbl, a, b)
    return a + b
  end
}

local adder = setmetatable({}, mt)
print(adder(3, 4))  -- 7
```

👉 Membuat tabel bisa dipanggil seperti fungsi.

---

### 5. Perbandingan

```lua
local mt = {
  __eq = function(a, b) return a.x == b.x and a.y == b.y end,
  __lt = function(a, b) return (a.x + a.y) < (b.x + b.y) end,
  __le = function(a, b) return (a.x + a.y) <= (b.x + b.y) end
}
```

👉 Dengan ini, kita bisa memakai `==`, `<`, `<=` untuk objek custom.

---

## 9.4 Studi Kasus: Class Vektor 2D

```lua
local Vec = {}
Vec.__index = Vec

function Vec.new(x, y)
  return setmetatable({x=x, y=y}, Vec)
end

function Vec.__tostring(v)
  return "(" .. v.x .. "," .. v.y .. ")"
end

function Vec.__add(a, b)
  return Vec.new(a.x + b.x, a.y + b.y)
end

function Vec.__mul(a, b)
  return a.x * b.x + a.y * b.y  -- dot product
end

-- Penggunaan
local v1 = Vec.new(1, 2)
local v2 = Vec.new(3, 4)
print("v1 =", v1)         -- (1,2)
print("v2 =", v2)         -- (3,4)
print("v1+v2 =", v1+v2)   -- (4,6)
print("v1·v2 =", v1*v2)   -- 11
```

---

## Visualisasi

```
┌──────────────┐
│  Tabel: {x,y}│
└─────┬────────┘
      │ get/set
      ▼
┌──────────────┐
│ Metatable    │
│ __tostring   │
│ __add        │
│ __index      │
└──────────────┘
```

---

## Praktik Terbaik

* Gunakan metatable untuk **OOP, operator overloading, dan DSL**, bukan untuk hal kecil.
* Hindari terlalu banyak “sulap” agar kode tetap terbaca.
* Gunakan `rawset` / `rawget` jika ingin menghindari `__index`/`__newindex`.

---

## Potensi Kesalahan

* **Lupa setmetatable** → metamethod tidak aktif.
* **Menggunakan \_\_index salah** → bisa bikin loop tak berujung.
* **Membuat operasi ambigu** → operator terlalu banyak di-*overload*.

---

## Latihan & Kuiz

1. Buat metatable yang membuat tabel bisa dikalikan `*` sehingga semua elemen dikalikan konstanta.
2. Buat class `Matrix` dengan `__tostring` untuk menampilkan isi matriks.
3. Apa yang terjadi jika `__index` mengembalikan dirinya sendiri?
   (jawaban: bisa jadi infinite loop).

---

## Hubungan dengan Modul Lain

* **Modul 7 (Require):** class atau library berbasis metatable biasanya dipisah ke modul.
* **Modul 10 (C API):** metamethod bisa dikombinasikan dengan objek C.
* **Modul 13 (OOP):** OOP di Lua sepenuhnya bergantung pada metatable & `__index`.

---

## Referensi

* Lua 5.4 Reference Manual — [Metatables](https://www.lua.org/manual/5.4/manual.html#2.4)
* *Programming in Lua* — Bab 13–16: Metatables and Metamethods
* Lua-users wiki — [Metatable Tutorial](http://lua-users.org/wiki/MetatableTutorial)

---

Mari kita kerjakan **Mini-Project berbasis Metatable: Class `Vector3D` dengan Operator Overloading**, agar maksud dan fungsinya benar-benar jelas.

---

# 📂 File: `vector3d.lua`

```lua
-- vector3d.lua
-- Class Vector3D menggunakan metatable & metamethods

local Vector3D = {}
Vector3D.__index = Vector3D

-- Constructor
function Vector3D.new(x, y, z)
  return setmetatable({x = x or 0, y = y or 0, z = z or 0}, Vector3D)
end

-- Representasi string
function Vector3D.__tostring(v)
  return string.format("(%g, %g, %g)", v.x, v.y, v.z)
end

-- Penjumlahan vektor
function Vector3D.__add(a, b)
  return Vector3D.new(a.x + b.x, a.y + b.y, a.z + b.z)
end

-- Pengurangan vektor
function Vector3D.__sub(a, b)
  return Vector3D.new(a.x - b.x, a.y - b.y, a.z - b.z)
end

-- Perkalian skalar atau dot product
function Vector3D.__mul(a, b)
  if type(a) == "number" then
    return Vector3D.new(a * b.x, a * b.y, a * b.z) -- skalar * vektor
  elseif type(b) == "number" then
    return Vector3D.new(b * a.x, b * a.y, b * a.z) -- vektor * skalar
  else
    return a.x * b.x + a.y * b.y + a.z * b.z       -- dot product
  end
end

-- Perbandingan kesetaraan
function Vector3D.__eq(a, b)
  return a.x == b.x and a.y == b.y and a.z == b.z
end

-- Panjang vektor (magnitudo)
function Vector3D:magnitude()
  return math.sqrt(self.x^2 + self.y^2 + self.z^2)
end

-- Normalisasi vektor
function Vector3D:normalize()
  local mag = self:magnitude()
  if mag == 0 then return Vector3D.new(0, 0, 0) end
  return Vector3D.new(self.x / mag, self.y / mag, self.z / mag)
end

return Vector3D
```

---

# 📂 File: `main.lua`

```lua
-- main.lua
-- Contoh penggunaan class Vector3D

local Vec3 = require("vector3d")

local v1 = Vec3.new(1, 2, 3)
local v2 = Vec3.new(4, 5, 6)

print("v1 =", v1)
print("v2 =", v2)

-- Penjumlahan & Pengurangan
print("v1 + v2 =", v1 + v2)
print("v1 - v2 =", v1 - v2)

-- Dot product
print("v1 · v2 =", v1 * v2)

-- Skalar perkalian
print("2 * v1 =", 2 * v1)
print("v2 * 3 =", v2 * 3)

-- Kesetaraan
print("Apakah v1 == v2?", v1 == v2)
print("Apakah v1 == (1,2,3)?", v1 == Vec3.new(1,2,3))

-- Magnitudo & Normalisasi
print("|v1| =", v1:magnitude())
print("v1 normalized =", v1:normalize())
```

---

# 🔎 Bedah Kode

## 📂 File `vector3d.lua`

### Bagian Awal

```lua
local Vector3D = {}
Vector3D.__index = Vector3D
```

* `Vector3D = {}` → membuat tabel kosong untuk class.
* `Vector3D.__index = Vector3D` → trik standar OOP di Lua: jika properti tidak ada di objek, Lua akan mencari di `Vector3D`.

---

### Constructor

```lua
function Vector3D.new(x, y, z)
  return setmetatable({x = x or 0, y = y or 0, z = z or 0}, Vector3D)
end
```

* Membuat objek baru dengan field `x, y, z`.
* Jika tidak diisi, default = 0.
* `setmetatable(..., Vector3D)` → pasang `Vector3D` sebagai metatable objek, sehingga metamethod bisa dipakai.

---

### Representasi String

```lua
function Vector3D.__tostring(v)
  return string.format("(%g, %g, %g)", v.x, v.y, v.z)
end
```

* Fungsi ini dipanggil otomatis saat objek dicetak dengan `print()`.
* `%g` → format angka umum.
* Contoh: `(1, 2, 3)`.

---

### Operator `+`

```lua
function Vector3D.__add(a, b)
  return Vector3D.new(a.x + b.x, a.y + b.y, a.z + b.z)
end
```

* Overload operator `+`.
* Menjumlahkan komponen x, y, z dari dua vektor.

---

### Operator `-`

```lua
function Vector3D.__sub(a, b)
  return Vector3D.new(a.x - b.x, a.y - b.y, a.z - b.z)
end
```

* Overload operator `-`.
* Mengurangkan komponen satu per satu.

---

### Operator `*`

```lua
function Vector3D.__mul(a, b)
  if type(a) == "number" then
    return Vector3D.new(a * b.x, a * b.y, a * b.z)
  elseif type(b) == "number" then
    return Vector3D.new(b * a.x, b * a.y, b * a.z)
  else
    return a.x * b.x + a.y * b.y + a.z * b.z
  end
end
```

* Jika salah satu operand angka (`number`) → lakukan **perkalian skalar**.
* Jika keduanya vektor → lakukan **dot product**.
* Contoh:

  * `2 * v1` = `(2, 4, 6)`
  * `v1 * v2` = `1*4 + 2*5 + 3*6 = 32`.

---

### Operator `==`

```lua
function Vector3D.__eq(a, b)
  return a.x == b.x and a.y == b.y and a.z == b.z
end
```

* Membandingkan dua vektor berdasarkan semua komponennya.

---

### Method Magnitudo

```lua
function Vector3D:magnitude()
  return math.sqrt(self.x^2 + self.y^2 + self.z^2)
end
```

* Panjang vektor = √(x² + y² + z²).
* Contoh: |(1,2,3)| = √14 ≈ 3.741.

---

### Method Normalisasi

```lua
function Vector3D:normalize()
  local mag = self:magnitude()
  if mag == 0 then return Vector3D.new(0, 0, 0) end
  return Vector3D.new(self.x / mag, self.y / mag, self.z / mag)
end
```

* Normalisasi = membuat vektor unit (panjang = 1) ke arah yang sama.
* Jika magnitudo = 0 → kembalikan vektor nol.

---

### Return Modul

```lua
return Vector3D
```

👉 Agar modul bisa dipakai dengan `require("vector3d")`.

---

## 📂 File `main.lua`

### Import Modul

```lua
local Vec3 = require("vector3d")
```

👉 Mengimpor modul `vector3d.lua` dan menyimpannya ke variabel `Vec3`.

---

### Membuat Objek

```lua
local v1 = Vec3.new(1, 2, 3)
local v2 = Vec3.new(4, 5, 6)
```

👉 Membuat dua vektor.

---

### Operasi

```lua
print("v1 =", v1)              -- (1,2,3)
print("v2 =", v2)              -- (4,5,6)

print("v1 + v2 =", v1 + v2)    -- (5,7,9)
print("v1 - v2 =", v1 - v2)    -- (-3,-3,-3)

print("v1 · v2 =", v1 * v2)    -- 32
print("2 * v1 =", 2 * v1)      -- (2,4,6)
print("v2 * 3 =", v2 * 3)      -- (12,15,18)

print("Apakah v1 == v2?", v1 == v2)            -- false
print("Apakah v1 == (1,2,3)?", v1 == Vec3.new(1,2,3)) -- true

print("|v1| =", v1:magnitude())    -- 3.741...
print("v1 normalized =", v1:normalize()) -- (0.267, 0.535, 0.802)
```

---

# 📊 Visualisasi

```
┌─────────────────┐
│ v1 = (1,2,3)    │
│ v2 = (4,5,6)    │
└───┬─────────────┘
    │ +,-,*,==
    ▼
┌───────────────┐
│  Metatable    │
│  __add        │
│  __sub        │
│  __mul        │
│  __eq         │
│  __tostring   │
└───────────────┘
    │
    ▼
┌───────────────┐
│  Hasil operasi│
└───────────────┘
```

---

# 🔑 Inti Pemahaman

* **Metatable** dipasang dengan `setmetatable`.
* **Metamethods** mengubah perilaku operator: `+ - * == tostring`.
* Bisa membuat tabel berperilaku seperti **class dengan OOP**.
* Dengan pendekatan ini, Lua bisa dipakai untuk **grafik, fisika, AI, dan game dev** karena vektor adalah struktur fundamental.

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-8/README.md
[selanjutnya]: ../bagian-10/README.md

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
