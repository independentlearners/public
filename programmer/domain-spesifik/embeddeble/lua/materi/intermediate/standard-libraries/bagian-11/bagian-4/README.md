<!--<details>
  <summary>📃 Daftar Isi</summary>

</details>
Baik, kita masuk ke **Bagian 4: Pengembangan Proyek Skala Lebih Besar**.

-->

# **[Bagian 4: Pengembangan Proyek Skala Lebih Besar][0]**

### Deskripsi & Peran dalam Kurikulum

* Di tahap ini, tujuan bukan lagi sekadar *belajar sintaks* atau *menguji fungsi kecil*.
* Anda akan mulai **mengintegrasikan semua kemampuan**: Lua murni, LuaJIT, FFI, struktur modul, serta praktik optimisasi.
* Perannya dalam kurikulum: melatih **pola pikir arsitektur proyek** — bagaimana membagi kode ke modul, menjaga keterbacaan, dan tetap memanfaatkan performa LuaJIT.

---

### Filosofi

* **Bangun dari modul kecil**: Vector3D, simulasi partikel, FFI binding.
* **Satukan dalam arsitektur**: satu aplikasi yang bisa di-*extend* dengan mudah.
* **Skalabilitas**: kode rapi, modular, dengan dokumentasi, sehingga proyek bisa tumbuh menjadi besar.

---

### Mini Proyek: **Simulasi Dunia Partikel dengan Modul**

Struktur proyek:

```
project/
 ├── vector3d_ffi.lua     (modul vector)
 ├── physics.lua          (modul fisika: update posisi, gaya gravitasi)
 ├── world.lua            (mengatur partikel & update)
 └── main.lua             (entry point)
```

---

#### 1. `vector3d_ffi.lua`

(kita pakai modul yang sudah dibuat sebelumnya – tidak saya ulang penuh di sini).

---

#### 2. `physics.lua`

```lua
local ffi = require("ffi")
local Vec3 = require("vector3d_ffi")

local Physics = {}

-- fungsi: update posisi dengan kecepatan
function Physics.integrate(pos, vel, dt)
  pos.x = pos.x + vel.x * dt
  pos.y = pos.y + vel.y * dt
  pos.z = pos.z + vel.z * dt
end

-- fungsi: tambahkan gravitasi sederhana (arah -Y)
function Physics.gravity(vel, g, dt)
  vel.y = vel.y - g * dt
end

return Physics
```

**Penjelasan**

* Modul `Physics` berisi fungsi-fungsi fisika.
* `integrate`: update posisi dengan rumus sederhana `p = p + v*dt`.
* `gravity`: mengurangi komponen `y` dari kecepatan sesuai percepatan gravitasi.

---

#### 3. `world.lua`

```lua
local ffi = require("ffi")
local Vec3 = require("vector3d_ffi")
local Physics = require("physics")

local vec3c = ffi.typeof("vec3")

local World = {}
World.__index = World

function World.new(n)
  local self = setmetatable({}, World)
  self.n = n
  self.positions = ffi.new("vec3[?]", n)
  self.velocities = ffi.new("vec3[?]", n)
  for i = 0, n-1 do
    self.positions[i] = vec3c(math.random()*10, math.random()*10+10, math.random()*10)
    self.velocities[i] = vec3c(0, 0, 0)
  end
  return self
end

function World:update(dt)
  for i = 0, self.n-1 do
    Physics.gravity(self.velocities[i], 9.8, dt)
    Physics.integrate(self.positions[i], self.velocities[i], dt)
  end
end

return World
```

**Penjelasan**

* `World.new(n)` → membuat dunia dengan `n` partikel.

  * `positions` dan `velocities` dialokasikan sebagai array FFI.
  * Posisi awal random, kecepatan nol.
* `update(dt)` → untuk setiap partikel, tambahkan gravitasi, lalu update posisi.
* `vec3c` alias dari `ffi.typeof("vec3")` untuk membuat vektor baru cepat.

---

#### 4. `main.lua`

```lua
local World = require("world")

math.randomseed(os.time())

local world = World.new(1000)
local steps = 100
local dt = 0.016

for s = 1, steps do
  world:update(dt)
end

-- cetak 5 partikel pertama
for i = 0, 4 do
  local p = world.positions[i]
  print(string.format("Particle %d: (%.2f, %.2f, %.2f)", i, p.x, p.y, p.z))
end
```

**Penjelasan**

* Membuat dunia dengan 1000 partikel.
* Jalankan simulasi selama 100 langkah (≈ 1,6 detik waktu simulasi).
* Cetak 5 partikel pertama untuk inspeksi.

---

### Visualisasi Struktur

```
main.lua (entry point)
   │
   ▼
 world.lua (atur array partikel)
   │
   ├── physics.lua (logika update)
   │
   └── vector3d_ffi.lua (tipe data vektor)
```

---

### Praktik Terbaik

* **Pisahkan logika** ke modul kecil agar mudah diuji.
* **Gunakan FFI arrays** untuk data numerik besar.
* **Tambahkan dokumentasi** di setiap modul agar jelas.
* **Benchmark**: ukur performa saat jumlah partikel ditambah.

---

### Potensi Kesalahan

* Lupa inisialisasi array → crash atau nilai sampah.
* Salah indeks (ingat FFI array mulai dari 0).
* Tidak hati-hati dengan operasi pointer/ffi → bisa segfault.

---

Dengan ini, **empat bagian lanjutan Modul 11 sudah kita bedah lengkap**:

1. Integrasi C library eksternal
2. Optimisasi & Profiling
3. Ekosistem Praktis
4. Proyek skala lebih besar

📌 Artinya, **Modul 11 selesai total**.

<!--
Apakah Anda ingin saya lanjut ke **Modul 12** dari kurikulum (pemanggilan library C eksternal yang lebih kompleks + binding shared library), atau kita buat dulu ringkasan singkat seluruh Modul 11 sebelum pindah?
-->

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

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
