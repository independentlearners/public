<!--<details>
  <summary>📃 Daftar Isi</summary>

</details>

Mantap, mari kita masuk ke **Bagian 3: Ekosistem Praktis**.
-->

# **[Bagian 3: Ekosistem Praktis][0]**

### Deskripsi & Peran dalam Kurikulum

* Tujuan: menunjukkan bagaimana **LuaJIT + FFI** digunakan di dunia nyata.
* Peran: Anda tidak hanya belajar teori, tapi juga melihat bagaimana pengetahuan ini dipakai pada software populer seperti **Neovim** atau game engine.
* Filosofi: Lua bukan hanya bahasa scripting ringan, tapi “lem” yang merekatkan sistem besar — cepat, fleksibel, dan bisa dipakai sebagai *extensibility language*.

---

### Kasus Nyata 1: Neovim Plugin

Neovim sejak versi awal ditulis dengan **LuaJIT** sebagai runtime.
Banyak plugin modern memakai FFI untuk memanggil fungsi **libuv** (library async yang dipakai Neovim).

#### Mini Proyek: Memanggil `getpid` dari C lewat Neovim

Buat file `nvim_pid.lua`:

```lua
local ffi = require("ffi")

-- 1) Deklarasi fungsi dari unistd.h (Linux)
ffi.cdef[[
int getpid(void);
]]

-- 2) Fungsi Lua untuk membungkus getpid
local function my_pid()
  return ffi.C.getpid()
end

-- 3) Jika dijalankan di Neovim: cetak PID Neovim
if vim and vim.api then
  vim.api.nvim_out_write("Neovim PID (via FFI): " .. my_pid() .. "\n")
else
  print("LuaJIT PID:", my_pid())
end
```

**Jalankan di Neovim**:

```vim
:luafile nvim_pid.lua
```

---

### Bedah Kode

**Baris 1**

```lua
local ffi = require("ffi")
```

* Memuat modul FFI bawaan Neovim (karena Neovim runtime adalah LuaJIT).

**Baris 4–6**

```lua
ffi.cdef[[
int getpid(void);
]]
```

* Mendeklarasikan fungsi `getpid()` dari `unistd.h`.
* Fungsi ini mengembalikan **PID (Process ID)** proses berjalan.

**Baris 9–11**

```lua
local function my_pid()
  return ffi.C.getpid()
end
```

* Membungkus pemanggilan C agar rapi.
* Fungsi ini akan dipanggil oleh Lua atau plugin Neovim.

**Baris 14–18**

```lua
if vim and vim.api then
  vim.api.nvim_out_write("Neovim PID (via FFI): " .. my_pid() .. "\n")
else
  print("LuaJIT PID:", my_pid())
end
```

* Mengecek apakah skrip dijalankan di dalam Neovim (`vim.api` tersedia).
* Jika iya, gunakan `vim.api.nvim_out_write` (fungsi resmi Neovim API) untuk menulis ke pesan Neovim.
* Jika tidak (hanya dijalankan dengan `luajit`), tampilkan lewat `print`.

---

### Kasus Nyata 2: Game Engine

Beberapa game engine (misalnya **LOVE2D**, **OpenResty**, bahkan binding ke **SDL**) menggunakan LuaJIT untuk scripting, dan FFI dipakai untuk langsung memanggil API grafis/audio C.

#### Mini Proyek: Memanggil `sleep` dari libc

File `ffi_sleep.lua`:

```lua
local ffi = require("ffi")

ffi.cdef[[
unsigned int sleep(unsigned int seconds);
]]

print("Tidur 2 detik...")
ffi.C.sleep(2)
print("Lanjut lagi!")
```

**Penjelasan**

* `sleep` adalah fungsi dari `<unistd.h>` (POSIX).
* `ffi.C.sleep(2)` menghentikan proses selama 2 detik.
* Cocok untuk simulasi atau game loop sederhana.

---

### Praktik Terbaik

* **Plugin Neovim**: gunakan FFI untuk fitur *khusus* yang tidak tersedia lewat API Lua biasa. Jangan terlalu bergantung agar tetap portabel.
* **Game Engine**: gunakan FFI untuk akses API low-level (misal OpenGL, SDL), tetapi bungkus dalam fungsi Lua yang aman agar mudah dipakai developer.
* **Server**: OpenResty (Nginx+LuaJIT) memakai FFI untuk performa tinggi dalam I/O HTTP.

---

### Visualisasi

```
+------------------+
|  Neovim (Core)   |   <-- Ditulis dengan C
+------------------+
         │
         ▼
  LuaJIT Runtime
   +---+   +---+
   |API|   |FFI|
   +---+   +---+
         │
         ▼
  Plugin Lua dengan FFI
   └── Memanggil fungsi libc / libuv
```

---

Dengan ini, **Ekosistem Praktis** sudah kita bedah: contoh di Neovim, game engine, dan server.
<!--
Apakah Anda siap kalau saya lanjut ke **Bagian 4: Pengembangan Proyek Skala Lebih Besar** (yaitu bagaimana menggabungkan semua hal yang sudah dipelajari menjadi satu proyek nyata), atau mau jeda dulu untuk memastikan bagian ini sudah mantap?
-->
> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

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
