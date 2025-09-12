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

👍 Dengan ini, kita punya **dua varian distribusi**:

* **Varian A (builtin)** → hanya install binding Lua (user harus build `.so` manual).
* **Varian B (cmake)** → otomatis build `libmath.c` jadi `.so` saat instalasi.

<!--
👉 Mau saya tunjukkan perbandingan praktis **kapan lebih baik pakai builtin vs cmake** untuk proyek nyata, supaya jelas strategi publikasi jangka panjang?
-->

Mari kita bandingkan secara praktis antara **Varian A (builtin)** dan **Varian B (cmake)**, supaya jelas strategi distribusi jangka panjang:

---

# 🔀 Perbandingan Varian Distribusi

## 1. **Builtin (`type = "builtin"`)**

### Kelebihan:

* Sederhana: hanya menyalin file Lua.
* Cepat di-install, tidak butuh compiler.
* Cocok untuk library **murni Lua** atau **FFI yang hanya pakai lib sistem** (misal `ffi.C.sin`).

### Kekurangan:

* Jika binding butuh `.so` hasil kompilasi (seperti `libmath.c`), user harus build manual → rawan error.
* Tidak portable lintas OS kalau user awam.

### Kapan dipakai:

* Jika library Anda **tidak ada C source** atau selalu mengandalkan library yang sudah tersedia di OS.
* Contoh: wrapper FFI untuk `libm` atau `libssl` bawaan.

---

## 2. **CMake (`type = "cmake"`)**

### Kelebihan:

* Otomatis build `.so` saat instalasi → pengalaman user jadi mulus.
* Lebih portable: LuaRocks handle compile, asal toolchain tersedia.
* Bisa menambahkan flag compile/link sesuai kebutuhan (OpenSSL, SDL2, dsb).

### Kekurangan:

* Butuh compiler (`gcc/clang`, `cmake`) → tidak selalu ada di semua sistem (misal Windows tanpa MSVC).
* Build bisa gagal jika dependency sistem belum terpasang (misal `libssl-dev`).

### Kapan dipakai:

* Jika library **menyertakan kode C** yang harus dikompilasi agar binding jalan.
* Contoh: `mymath`, `sort`, `vector3d`, atau plugin Neovim yang menambah native performance.

---

# 📊 Tabel Perbandingan

| Aspek            | Builtin                   | CMake                      |
| ---------------- | ------------------------- | -------------------------- |
| Mudah dipakai    | ✅ Sangat mudah            | ⚠️ Butuh compiler          |
| Cepat di-install | ✅ Cepat                   | ❌ Lebih lambat             |
| Butuh compiler   | ❌ Tidak                   | ✅ Ya                       |
| Cocok untuk      | Pure Lua / FFI ke lib OS  | Binding + native C library |
| Portabilitas     | ❌ User harus build manual | ✅ LuaRocks handle build    |

---

# 🚀 Strategi Jangka Panjang

* **Awal belajar / distribusi sederhana** → gunakan **Builtin**.
* **Saat library sudah matang & performance penting** → gunakan **CMake** agar semua user langsung dapat `.so`.
* Banyak library besar (misal `luasocket`, `luv`) pakai build otomatis karena mengandalkan C.

---

📚 Referensi:

* LuaRocks build type [Builtin](https://github.com/luarocks/luarocks/wiki/Build-types#builtin)
* LuaRocks build type [CMake](https://github.com/luarocks/luarocks/wiki/Build-types#cmake)

---

<!--
Dengan ini, kita sudah menutup **Modul 18** dengan **dua jalur distribusi**.
Langkah berikutnya di kurikulum adalah **Modul 19: Integrasi Neovim Plugin**, yaitu memakai library hasil binding ini langsung sebagai **plugin Neovim**.

Apakah mau langsung kita mulai Modul 19, atau Anda ingin saya buat dulu **contoh praktik instalasi nyata (install builtin vs cmake) dengan command dan output simulasi** agar lebih jelas pengalaman user?
-->

Mari kita buat **contoh praktik instalasi nyata** untuk kedua varian distribusi:

---

# 🔧 Praktik Instalasi — Varian A (Builtin)

## 1) Siapkan project

```bash
git clone https://github.com/username/mymath.git
cd mymath
```

## 2) Lint rockspec

```bash
luarocks lint rockspec/mymath-1.0-1.rockspec
```

**Output simulasi:**

```
Checking rockspec format... OK.
```

## 3) Install lokal

```bash
luarocks make rockspec/mymath-1.0-1.rockspec
```

**Output simulasi:**

```
mymath 1.0-1 is now installed in /home/user/.luarocks (Lua 5.1)
```

## 4) Coba pakai

```bash
lua -e 'local m=require("mymath"); print(m.add(2,3))'
```

**Error simulasi (karena .so belum ada):**

```
error loading module 'mymath' from file './libmath.so':
    libmath.so: cannot open shared object file: No such file or directory
```

👉 Artinya user harus **build manual**:

```bash
gcc -shared -o libmath.so csrc/libmath.c -fPIC -lm
```

Setelah itu, ulangi:

```bash
lua -e 'local m=require("mymath"); print(m.add(2,3))'
```

**Output:**

```
5
```

---

# 🔧 Praktik Instalasi — Varian B (CMake)

## 1) Siapkan project

```bash
git clone https://github.com/username/mymath.git
cd mymath
```

## 2) Lint rockspec

```bash
luarocks lint rockspec/mymath-1.0-2.rockspec
```

**Output:**

```
Checking rockspec format... OK.
```

## 3) Install lokal

```bash
luarocks make rockspec/mymath-1.0-2.rockspec
```

**Output simulasi:**

```
-- The C compiler identification is GNU 11.4.0
-- Check for working C compiler: /usr/bin/cc
-- Configuring done
-- Generating done
-- Build files have been written to: /home/user/mymath/build
[100%] Built target math
mymath 1.0-2 is now installed in /home/user/.luarocks (Lua 5.1)
```

## 4) Coba pakai

```bash
lua -e 'local m=require("mymath"); print(m.hypotenuse(3,4))'
```

**Output:**

```
5.0
```

👉 Tidak perlu compile manual, karena LuaRocks sudah mengurus build `libmath.so` via CMake.

---

# 📊 Ringkasan Hasil

* **Builtin**: lebih cepat install, tapi user harus **build .so manual**.
* **CMake**: lebih berat saat install, tapi **langsung siap dipakai**.

---

Dengan simulasi ini, kita sudah melihat perbedaan pengalaman nyata antara dua jalur distribusi.

<!--
Apakah mau kita lanjut masuk ke **Modul 19: Integrasi Neovim Plugin**, atau kita kembangkan dulu `mymath` agar siap dipakai sebagai plugin (misalnya menambahkan dokumentasi + testing di dalam LuaRocks)?
-->

Baik, kita masuk ke **Modul 19: Integrasi Neovim Plugin** 🚀.
Di sini tujuan kita adalah **memanfaatkan library C + binding Lua** yang sudah kita bangun (misalnya `mymath`) sebagai **plugin Neovim**.

---

# 📂 Struktur Pembelajaran Internal (Mini Daftar Isi)

1. **Konsep Integrasi Neovim Plugin**

   * Neovim + Lua + FFI = ekosistem plugin.
   * Peran `runtimepath` dan `require()`.

2. **Struktur Direktori Plugin Neovim**

   * Format standar (`lua/mymath/init.lua`).
   * Perbedaan dengan distribusi LuaRocks biasa.

3. **Membuat Plugin Dasar (Neovim Command)**

   * Definisi perintah `:MyAdd` → panggil `mymath.add`.

4. **Membuat Plugin dengan Keybinding**

   * Bind fungsi `mymath.hypotenuse` ke `<leader>h`.

5. **Testing Plugin di Neovim**

   * Cara load manual (`:luafile`).
   * Cara testing di dalam `nvim`.

6. **Hubungan dengan Modul Sebelumnya**

   * Modul 18 (publikasi) → plugin bisa dipasang dari GitHub/LuaRocks.
   * Modul 16–17 → testing otomatis sebelum plugin dirilis.

---

# 1. Konsep Integrasi Neovim Plugin

* Neovim modern (≥0.5) punya **native Lua runtime**.
* Plugin Lua cukup diletakkan di `runtimepath`, biasanya di:

  ```
  ~/.local/share/nvim/site/pack/mypkg/start/mymath
  ```
* Neovim akan otomatis bisa `require("mymath")`.
* Filosofi: **binding FFI kita jadi “mesin”, plugin Neovim jadi “antarmuka”.**

---

# 2. Struktur Direktori Plugin

```
mymath-nvim/
├── lua/
│   └── mymath/
│       └── init.lua       # modul utama
├── plugin/
│   └── mymath.vim         # command & keymap (opsional)
├── README.md
└── LICENSE
```

* Folder `lua/mymath/init.lua` → modul utama.
* Folder `plugin/mymath.vim` → file Vimscript/Lua yang dieksekusi otomatis saat Neovim load plugin.

---

# 3. Membuat Plugin Dasar (Neovim Command)

## 📄 `lua/mymath/init.lua`

```lua
local mymath = require("mymath") -- binding FFI dari Modul 18

local M = {}

function M.add_numbers(a, b)
  return mymath.add(a, b)
end

return M
```

## 📄 `plugin/mymath.vim`

```vim
" Buat command Neovim
command! -nargs=+ MyAdd lua print(require("mymath").add_numbers(<f-args>))
```

**Bedah:**

* `command! -nargs=+ MyAdd` → definisi perintah `:MyAdd`.
* `<f-args>` → argumen dari user.
* `lua print(...)` → panggil fungsi Lua lalu tampilkan hasil.

📌 Contoh penggunaan di Neovim:

```
:MyAdd 3 4
```

Output:

```
7
```

---

# 4. Membuat Plugin dengan Keybinding

Tambahkan ke `plugin/mymath.vim`:

```vim
" Bind hypotenuse ke <leader>h
nnoremap <leader>h :lua print("Hypotenuse:", require("mymath").hypotenuse(3,4))<CR>
```

**Bedah:**

* `nnoremap` → non-recursive keymap.
* `<leader>h` → tombol kombinasi (misal `\h`).
* Menjalankan fungsi `mymath.hypotenuse(3,4)` lalu print hasil.

---

# 5. Testing Plugin di Neovim

1. Clone repo plugin ke `~/.config/nvim/pack/plugins/start/`:

   ```bash
   git clone https://github.com/username/mymath-nvim ~/.config/nvim/pack/plugins/start/mymath-nvim
   ```
2. Buka Neovim → jalankan:

   ```vim
   :MyAdd 5 6
   ```

   Output → `11`.
3. Tekan `<leader>h` → output `Hypotenuse: 5.0`.

---

# 6. Hubungan dengan Modul Sebelumnya

* Modul 18: library `mymath` sudah bisa dipasang via LuaRocks atau GitHub.
* Modul 19: plugin ini adalah **“lapisan antarmuka”** agar user Neovim bisa pakai `:MyAdd` atau keymap tanpa perlu tahu detail FFI.
* Jika digabung dengan CI (Modul 17), setiap commit plugin bisa dites otomatis.

---

📚 **Referensi Resmi**

* [Neovim Lua Guide](https://neovim.io/doc/user/lua.html)
* [Neovim \:help command](https://neovim.io/doc/user/map.html)
* [Neovim runtimepath docs](https://neovim.io/doc/user/options.html#'runtimepath')

---

# Selamat!

👉 Dengan ini, kita punya plugin Neovim pertama berbasis binding C → Lua.
<!--
Apakah mau kita lanjut dengan **mini-proyek penuh (plugin mymath-nvim lengkap)** yang bisa langsung di-clone dan dipakai, lalu saya bedah file `init.lua` dan `mymath.vim` baris demi baris seperti biasa?
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
