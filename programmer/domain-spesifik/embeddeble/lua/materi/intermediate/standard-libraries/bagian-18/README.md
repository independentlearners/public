# **[Modul 18: Distribusi & Publikasi Proyek][0]**

Di modul ini fokusnya bukan lagi pada membuat kode baru, tapi memastikan **library yang sudah kita bangun bisa dibagikan, dipakai, dan dipelihara dengan benar**.

---

# 📌 Struktur Pembelajaran Internal (Mini Daftar Isi)

1. **Konsep Distribusi & Publikasi**

   * Apa itu paket Lua (LuaRocks).
   * Mengapa distribusi penting (reusability, kolaborasi).

2. **Mempersiapkan Proyek untuk Publikasi**

   * Struktur folder sesuai standar.
   * Menulis file `rockspec`.

3. **Membuat Rockspec File**

   * Bagian-bagian utama.
   * Contoh `mylib-1.0-1.rockspec`.

4. **Testing Lokal Sebelum Publikasi**

   * Install rock secara lokal.
   * Validasi dengan `luarocks lint`.

5. **Publikasi ke LuaRocks.org**

   * Proses upload.
   * Praktik terbaik (semver, deskripsi jelas).

6. **Hubungan dengan Modul Lain**

   * Modul 16–17 (testing + CI) jadi pondasi agar library siap rilis.
   * Setelah publikasi → bisa dipakai plugin Neovim atau project lain.

---

# 1. Konsep Distribusi & Publikasi

* **LuaRocks** = package manager resmi ekosistem Lua.
* Tujuan: mempermudah pengguna lain meng-install binding yang sudah kita buat dengan perintah sederhana:

  ```bash
  luarocks install mylib
  ```
* Filosofi: *write once, share everywhere*.
* Dengan paket publik, kita bisa:

  * **Reuse** di project lain.
  * **Kolaborasi** dengan komunitas.
  * **Menjamin stabilitas** lewat versi (1.0.0, 1.1.0, dst).

---

# 2. Mempersiapkan Proyek untuk Publikasi

Struktur minimal:

```
mylib/
├── lua/
│   └── mylib.lua         # modul utama (bisa require "mylib")
├── csrc/
│   └── libmylib.c        # kode C (opsional)
├── rockspec/             # tempat file rockspec
│   └── mylib-1.0-1.rockspec
├── tests/
│   └── test_mylib.lua    # unit tests
├── README.md
└── LICENSE
```

> Visualisasi diagram struktur akan sangat membantu di sini.

---

# 3. Membuat Rockspec File

Contoh **`mylib-1.0-1.rockspec`**:

```lua
package = "mylib"
version = "1.0-1"
source = {
   url = "git+https://github.com/username/mylib.git",
   tag = "v1.0.0"
}
description = {
   summary = "MyLib: contoh binding Lua ke C",
   detailed = [[
      MyLib menyediakan binding ke berbagai fungsi C
      seperti math, string, array, dan lainnya.
   ]],
   license = "MIT",
   homepage = "https://github.com/username/mylib"
}
dependencies = {
   "lua >= 5.1"
}
build = {
   type = "builtin",
   modules = {
      mylib = "lua/mylib.lua"
   }
}
```

---

# 4. Testing Lokal Sebelum Publikasi

1. **Linting rockspec**:

   ```bash
   luarocks lint rockspec/mylib-1.0-1.rockspec
   ```

   → memastikan format benar.

2. **Install lokal**:

   ```bash
   luarocks make rockspec/mylib-1.0-1.rockspec
   ```

   → build & install langsung dari source.

3. **Test**:

   ```bash
   lua -e 'local m=require("mylib"); print(m.add(2,3))'
   ```

---

# 5. Publikasi ke LuaRocks.org

1. Buat akun di [luarocks.org](https://luarocks.org/).
2. Tambahkan kunci API (`luarocks upload` akan minta ini).
3. Upload:

   ```bash
   luarocks upload rockspec/mylib-1.0-1.rockspec \
     --api-key=SECRETTOKEN
   ```

Setelah itu, orang lain bisa langsung install dengan:

```bash
luarocks install mylib
```

---

# 6. Hubungan dengan Modul Lain

* **Modul 16 (coroutine/async)** → contoh library sudah dipakai.
* **Modul 17 (testing/CI)** → memastikan library stabil sebelum rilis.
* **Modul 18 (publikasi)** → hasil akhir siap dipakai siapa pun.

> Dengan ini kurikulum sudah sampai tahap **share & publish**, jadi hasil kerja Anda tidak hanya belajar pribadi tapi bisa berkontribusi nyata ke ekosistem open source.

---

📚 **Referensi resmi**:

* [LuaRocks Docs: Rockspec format](https://github.com/luarocks/luarocks/wiki/Rockspec-format)
* [LuaRocks upload](https://github.com/luarocks/luarocks/wiki/Uploading-a-rock)
* [LuaRocks CLI](https://luarocks.org/man/luarocks)

---

<!--
Apakah Anda mau saya langsung buatkan **mini proyek rockspec nyata** (misalnya untuk library `math_bind.lua` + `libmath.c`), lalu membedah isi `rockspec` baris demi baris seperti biasa?
-->

Baik, mari kita buat **mini-proyek publikasi**: kita akan menyiapkan **rockspec** untuk library kecil yang sudah kita bangun, yaitu `libmath` + binding Lua `math_bind.lua`.

---

# 📂 Struktur Proyek Mini (Distribusi `mymath`)

```
mymath/
├── lua/
│   └── mymath.lua         # binding Lua
├── csrc/
│   ├── libmath.c
│   └── libmath.h
├── rockspec/
│   └── mymath-1.0-1.rockspec
├── README.md
└── LICENSE
```

---

# 📄 Isi File

## 1) `csrc/libmath.c` & `csrc/libmath.h`

*(sama seperti yang sudah kita buat sebelumnya)*

```c
// libmath.h
#ifndef LIBMATH_H
#define LIBMATH_H
double add(double a, double b);
double sub(double a, double b);
double mul(double a, double b);
double divide(double a, double b);
double hypotenuse(double x, double y);
#endif
```

```c
// libmath.c
#include "libmath.h"
#include <math.h>

double add(double a, double b) { return a + b; }
double sub(double a, double b) { return a - b; }
double mul(double a, double b) { return a * b; }
double divide(double a, double b) { return b != 0 ? a / b : 0; }
double hypotenuse(double x, double y) { return sqrt(x*x + y*y); }
```

---

## 2) `lua/mymath.lua`

```lua
local ffi = require("ffi")

ffi.cdef[[
double add(double a, double b);
double sub(double a, double b);
double mul(double a, double b);
double divide(double a, double b);
double hypotenuse(double x, double y);
]]

local lib = ffi.load("libmath")

local M = {}
M.add = lib.add
M.sub = lib.sub
M.mul = lib.mul
M.divide = lib.divide
M.hypotenuse = lib.hypotenuse
return M
```

**Bedah:**

* Binding FFI ke `libmath.so`.
* Semua fungsi dikemas dalam tabel `M`.
* Bisa dipakai dengan:

  ```lua
  local mymath = require("mymath")
  print(mymath.add(3,4))
  ```

---

## 3) `rockspec/mymath-1.0-1.rockspec`

```lua
package = "mymath"
version = "1.0-1"
source = {
   url = "git+https://github.com/username/mymath.git",
   tag = "v1.0.0"
}
description = {
   summary = "MyMath: binding sederhana Lua ke libmath C",
   detailed = [[
      MyMath menyediakan fungsi aritmetika dasar dan hypotenuse
      yang diimplementasikan dalam bahasa C lalu diakses melalui FFI Lua.
   ]],
   license = "MIT",
   homepage = "https://github.com/username/mymath"
}
dependencies = {
   "lua >= 5.1"
}
build = {
   type = "builtin",
   modules = {
      mymath = "lua/mymath.lua"
   }
}
```

---

# 🔎 Bedah Rockspec Baris per Baris

```lua
package = "mymath"
```

* Nama paket. Orang lain akan menginstall dengan `luarocks install mymath`.

```lua
version = "1.0-1"
```

* Versi rock: `1.0` adalah versi library, `-1` adalah revisi rockspec.

```lua
source = {
   url = "git+https://github.com/username/mymath.git",
   tag = "v1.0.0"
}
```

* Lokasi source code.
* Bisa GitHub, GitLab, atau tarball.
* `tag` menandai versi release di repo.

```lua
description = {
   summary = "MyMath: binding sederhana Lua ke libmath C",
   detailed = [[
      MyMath menyediakan fungsi aritmetika dasar...
   ]],
   license = "MIT",
   homepage = "https://github.com/username/mymath"
}
```

* Informasi untuk dokumentasi di luar.

```lua
dependencies = {
   "lua >= 5.1"
}
```

* Paket ini butuh Lua 5.1 ke atas.

```lua
build = {
   type = "builtin",
   modules = {
      mymath = "lua/mymath.lua"
   }
}
```

* Tipe build: `builtin` artinya hanya menyalin file Lua.
* `mymath` akan dipasang ke `require "mymath"`.

⚠️ Perhatikan: `libmath.so` harus tersedia di PATH atau diinstal terpisah. Jika mau otomatis build `libmath.c`, kita bisa pakai `build = { type = "cmake" }` dengan definisi custom.

---

# 🚀 Testing Lokal

1. **Lint** rockspec:

   ```bash
   luarocks lint rockspec/mymath-1.0-1.rockspec
   ```
2. **Install lokal**:

   ```bash
   luarocks make rockspec/mymath-1.0-1.rockspec
   ```
3. **Coba jalankan**:

   ```bash
   lua -e 'local m=require("mymath"); print(m.hypotenuse(3,4))'
   ```

---

# 📚 Referensi Resmi

* [LuaRocks Rockspec Format](https://github.com/luarocks/luarocks/wiki/Rockspec-format)
* [Uploading a rock](https://github.com/luarocks/luarocks/wiki/Uploading-a-rock)
* [LuaRocks Command Line](https://luarocks.org/man/luarocks)

---

Dengan ini, kita sudah menutup **Modul 18: Distribusi dasar via LuaRocks**.
Kalau sudah jelas, kita bisa lanjut ke **Modul 19 (Integrasi Neovim Plugin)** di mana library ini dipakai sebagai plugin nyata Neovim.
<!--
Apakah mau langsung gas ke Modul 19 atau Anda ingin saya buatkan **varian rockspec dengan build CMake** (supaya `libmath.c` otomatis di-compile saat instalasi)?
-->

Mari kita buat **varian rockspec dengan dukungan build CMake**.
Tujuannya: ketika orang meng-install dengan `luarocks install mymath`, tidak hanya file Lua yang terpasang, tetapi juga file **C library (`libmath.c`) otomatis di-compile** menjadi `.so` dan siap dipanggil lewat FFI.

---

# 📄 Rockspec dengan CMake

Buat file: `rockspec/mymath-1.0-2.rockspec`

```lua
package = "mymath"
version = "1.0-2"
source = {
   url = "git+https://github.com/username/mymath.git",
   tag = "v1.0.1"
}
description = {
   summary = "MyMath: binding Lua ke libmath C dengan build otomatis via CMake",
   detailed = [[
      MyMath menyediakan fungsi aritmetika dasar (add, sub, mul, divide, hypotenuse)
      yang diimplementasikan dalam bahasa C lalu dibungkus oleh Lua FFI.
      Versi ini dilengkapi dengan build otomatis menggunakan CMake, sehingga
      library C akan dikompilasi saat instalasi.
   ]],
   license = "MIT",
   homepage = "https://github.com/username/mymath"
}
dependencies = {
   "lua >= 5.1"
}
build = {
   type = "cmake",
   build_pass = false,
   variables = {
      CMAKE_BUILD_TYPE = "Release"
   }
}
```

---

# 🔎 Bedah Rockspec Baris per Baris

```lua
package = "mymath"
version = "1.0-2"
```

* Nama paket tetap `mymath`.
* Versi dinaikkan menjadi `1.0-2` untuk membedakan dari versi sebelumnya (`builtin`).

```lua
source = {
   url = "git+https://github.com/username/mymath.git",
   tag = "v1.0.1"
}
```

* Sumber kode di GitHub.
* `tag` menandakan release baru (misalnya `v1.0.1`).

```lua
description = {
   summary = "MyMath: binding Lua ke libmath C dengan build otomatis via CMake",
   ...
}
```

* Ringkasan + detail deskripsi.
* Lisensi dan homepage wajib.

```lua
dependencies = {
   "lua >= 5.1"
}
```

* Minimal Lua 5.1.

```lua
build = {
   type = "cmake",
   build_pass = false,
   variables = {
      CMAKE_BUILD_TYPE = "Release"
   }
}
```

* `type = "cmake"` → LuaRocks akan menjalankan `cmake .` otomatis.
* `build_pass = false` → hasil build tidak diinstal ulang oleh LuaRocks (cukup library `.so`).
* `variables` → meneruskan argumen tambahan ke CMake (`Release`).

---

# 📂 CMakeLists.txt (disesuaikan untuk LuaRocks)

Tambahkan file `CMakeLists.txt` di root proyek:

```cmake
cmake_minimum_required(VERSION 3.10)
project(mymath C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

add_library(math SHARED csrc/libmath.c)
target_link_libraries(math m)
```

**Bedah:**

* Akan menghasilkan `libmath.so` di `build/`.
* FFI di `lua/mymath.lua` bisa memanggil `ffi.load("libmath")`.

---

# 🚀 Testing Lokal

1. **Lint rockspec**:

   ```bash
   luarocks lint rockspec/mymath-1.0-2.rockspec
   ```
2. **Build & install**:

   ```bash
   luarocks make rockspec/mymath-1.0-2.rockspec
   ```

   → Ini akan otomatis menjalankan CMake, build `libmath.so`, lalu menyalin `lua/mymath.lua` ke path LuaRocks.
3. **Test**:

   ```bash
   lua -e 'local m=require("mymath"); print(m.hypotenuse(3,4))'
   ```

   → Output `5`.

---

# 📚 Referensi Resmi

* [LuaRocks Build Type: cmake](https://github.com/luarocks/luarocks/wiki/Build-types#cmake)
* [CMake Documentation](https://cmake.org/cmake/help/latest/)

---

Dengan ini, kita punya **dua varian distribusi**:

* **Varian A (builtin)** → hanya install binding Lua (user harus build `.so` manual).
* **Varian B (cmake)** → otomatis build `libmath.c` jadi `.so` saat instalasi.
<!--
👉 Mau saya tunjukkan perbandingan praktis **kapan lebih baik pakai builtin vs cmake** untuk proyek nyata, supaya jelas strategi publikasi jangka panjang?
-->
> - **[Ke Atas](#)**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-17/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../
[2]: ../
[3]: ../
[4]: ../
[5]: ../
