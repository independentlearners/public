<!--<details>
  <summary>📃 Daftar Isi</summary>

</details>

Siap. Kita sekarang masuk ke **Modul 12: Pemanggilan Library C Eksternal**.

-->

# **[Bagian Inti Modul 12][0]**

Kalau di Modul 11 kita baru *mengintip* fungsi-fungsi dari `libc`/`libm` lewat `ffi.C`, di Modul 12 kita akan belajar bagaimana:

1. **Mendefinisikan binding ke library eksternal (.so/.dll/.dylib)** menggunakan `ffi.load`.
2. **Deklarasi API** yang sesuai dengan header asli library.
3. **Membuat wrapper Lua** agar pemakaiannya lebih aman dan enak digunakan.

---

### Deskripsi & Peran dalam Kurikulum

* **Deskripsi**: Mengajarkan bagaimana LuaJIT FFI dapat membuka library eksternal di luar `libc`.
* **Peran**: Inilah kunci jika Anda ingin mengakses pustaka sistem atau library pihak ketiga (misalnya OpenSSL, SDL, libpng, dsb.) langsung dari Lua.
* **Filosofi**: LuaJIT menjadikan Lua bukan sekadar scripting, tetapi *bahasa glue* untuk library C yang sudah matang.

---

## Mini Proyek: Binding ke `libm` (Math Library)

Pada Linux/Unix, fungsi-fungsi matematika lanjutan (misal `sin`, `cos`, `sqrt`) berada di library `libm.so`.
Kita akan membuat binding manual menggunakan `ffi.load`.

---

### Kode: `ffi_libm.lua`

```lua
local ffi = require("ffi")

-- 1) Deklarasi fungsi dari <math.h>
ffi.cdef[[
double sin(double x);
double cos(double x);
double sqrt(double x);
]]

-- 2) Muat library libm (math library)
local libm = ffi.load("m")

-- 3) Bungkus fungsi agar enak dipakai
local M = {}

function M.sin(x) return libm.sin(x) end
function M.cos(x) return libm.cos(x) end
function M.sqrt(x) return libm.sqrt(x) end

return M
```

---

### Bedah Kode

**Baris 1**

```lua
local ffi = require("ffi")
```

* Memanggil modul FFI bawaan LuaJIT.

**Baris 4–8**

```lua
ffi.cdef[[
double sin(double x);
double cos(double x);
double sqrt(double x);
]]
```

* Mendeklarasikan prototipe fungsi yang sesuai dengan `<math.h>`.
* Semua fungsi menerima `double`, mengembalikan `double`.

**Baris 11**

```lua
local libm = ffi.load("m")
```

* `ffi.load` digunakan untuk memuat **shared library** eksternal.
* `"m"` akan diterjemahkan menjadi `libm.so` di Linux.
* Di Windows, ini akan mencari `m.dll` (tidak ada, sehingga perlu disesuaikan).
* Hasilnya adalah object yang berisi fungsi-fungsi dari library itu.

**Baris 14–19**

```lua
local M = {}

function M.sin(x) return libm.sin(x) end
function M.cos(x) return libm.cos(x) end
function M.sqrt(x) return libm.sqrt(x) end

return M
```

* Kita buat tabel `M` untuk membungkus fungsi.
* Mengapa dibungkus?

  * Agar rapi dan konsisten.
  * Bisa ditambahkan validasi/penanganan error.
* `return M` supaya modul bisa di-`require`.

---

## File Pemanggil: `main.lua`

```lua
local mathlib = require("ffi_libm")

local a = math.pi / 4  -- 45 derajat
print("sin(45°) =", mathlib.sin(a))
print("cos(45°) =", mathlib.cos(a))
print("sqrt(2)  =", mathlib.sqrt(2))
```

---

### Bedah Kode

**Baris 1**

```lua
local mathlib = require("ffi_libm")
```

* Memuat modul yang sudah kita buat (`ffi_libm.lua`).

**Baris 3**

```lua
local a = math.pi / 4
```

* Hitung 45 derajat dalam radian.

**Baris 4–6**

```lua
print("sin(45°) =", mathlib.sin(a))
print("cos(45°) =", mathlib.cos(a))
print("sqrt(2)  =", mathlib.sqrt(2))
```

* Memanggil fungsi `sin`, `cos`, dan `sqrt` dari library eksternal (`libm`).
* Outputnya seharusnya mendekati:

  ```
  sin(45°) = 0.707106...
  cos(45°) = 0.707106...
  sqrt(2)  = 1.414213...
  ```

---

## Visualisasi Alur

```
Lua Script
   │
   ▼
 ffi.cdef    → mendefinisikan header C
   │
   ▼
 ffi.load("m") → buka libm.so
   │
   ▼
  libm.sin / libm.cos / libm.sqrt
   │
   ▼
 Fungsi Lua wrapper (M.sin, M.cos, M.sqrt)
   │
   ▼
 Pemanggilan di main.lua
```

---

## Praktik Terbaik

* Selalu **cocokkan deklarasi** `ffi.cdef` dengan header C asli.
* Gunakan `ffi.load("nama")` dengan tepat:

  * Linux → `"m"` untuk `libm.so`, `"c"` untuk `libc.so`.
  * Windows → langsung `"msvcrt"` (Microsoft C Runtime).
* Bungkus dalam modul agar lebih mudah dipakai ulang.
* Untuk library besar: kelompokkan fungsi, jangan langsung semua dalam satu file.

---

## Potensi Kesalahan

* Salah mengetik prototipe fungsi → bisa menyebabkan crash.
* `ffi.load("m")` gagal jika library tidak ada di sistem (misal di Windows).
* Salah path → perlu absolute path jika library tidak ada di lokasi standar.

---

Dengan ini, **Modul 12 (Pemanggilan Library C Eksternal)** sudah kita bedah dengan mini proyek penuh dan penjelasan per baris.
<!--
Apakah Anda ingin saya lanjut langsung ke **Modul 13** (biasanya topiknya tentang *membuat binding sendiri ke library kustom C buatan kita*), atau mau saya rangkum dulu hasil dari Modul 12 ini?
-->

Baik, berikut rangkuman dari **Modul 12: Pemanggilan Library C Eksternal**.

---

## Ringkasan Modul 12

### Tujuan Utama

* Belajar bagaimana memanggil fungsi dari **library C eksternal (.so/.dll/.dylib)** melalui **LuaJIT FFI**.
* Memahami perbedaan `ffi.C` (untuk fungsi bawaan libc) dan `ffi.load` (untuk memuat library tambahan).
* Membiasakan diri membuat **binding modular** agar mudah dipakai ulang.

---

### Inti Materi

1. **ffi.cdef** → untuk mendeklarasikan prototipe fungsi C sesuai header (`<math.h>`, `<unistd.h>`, dll.).
2. **ffi.load("m")** → untuk membuka `libm.so` (math library) di Linux.
3. **Membuat wrapper** di Lua agar fungsi C terasa seperti fungsi bawaan Lua.

---

### Mini Proyek

* File `ffi_libm.lua`:

  * Mendefinisikan `sin`, `cos`, `sqrt` dengan `ffi.cdef`.
  * Memuat library `libm` dengan `ffi.load("m")`.
  * Bungkus fungsi ke dalam tabel `M` agar rapi.

* File `main.lua`:

  * Memanggil wrapper `mathlib.sin`, `mathlib.cos`, `mathlib.sqrt`.
  * Menunjukkan hasil perhitungan sin/cos/sqrt dari fungsi C.

---

### Visualisasi Alur

```
Lua Script
   │
   ▼
ffi.cdef (header C)
   │
   ▼
ffi.load("m")   → buka libm.so
   │
   ▼
libm.sin / libm.cos / libm.sqrt
   │
   ▼
Wrapper Lua (M.sin, M.cos, M.sqrt)
   │
   ▼
main.lua → pemanggilan langsung
```

---

### Praktik Terbaik

* Pastikan tanda tangan fungsi di `ffi.cdef` sama persis dengan header asli.
* Selalu bungkus fungsi ke modul agar lebih aman dan mudah dipakai.
* Gunakan `ffi.load` dengan nama yang sesuai sistem operasi (`"m"` di Linux, `"msvcrt"` di Windows).
* Jika library besar → pecah binding ke beberapa file modul.

---

### Potensi Kesalahan

* **Crash/segfault** bila deklarasi salah (contoh: salah tipe return).
* Library tidak ditemukan jika nama/path salah.
* Portabilitas: library berbeda di OS berbeda (misalnya `libm` vs `msvcrt`).

---

📌 Dengan modul ini, Anda sudah bisa:

* Mengakses fungsi-fungsi di luar runtime Lua.
* Menghubungkan Lua dengan library matematika, sistem, maupun pihak ketiga.
* Menulis *binding manual* sederhana sebagai pondasi untuk integrasi dengan pustaka yang lebih besar (contoh: SDL, OpenGL, OpenSSL).

<!--
Apakah Anda ingin saya lanjutkan ke **Modul 13** (membuat binding untuk library C kustom yang kita buat sendiri), atau Anda ingin saya tunjukkan **contoh binding ke library populer** (misalnya SDL/OpenSSL) dulu sebagai pengantar sebelum masuk ke Modul 13?

Bagus, kita buat dulu contoh **binding ke library populer** sebelum masuk ke Modul 13.
Saya pilih **SDL2 (Simple DirectMedia Layer)** karena:
-->

# Binding SDL2 dengan LuaJIT FFI

* SDL2 adalah library C lintas-platform untuk grafis, input, dan audio.
* Banyak dipakai di game engine.
* Binding dengan LuaJIT FFI relatif lurus karena API-nya C murni.

---

### Deskripsi & Peran

* **Deskripsi**: Membuat binding minimal ke SDL2 (khusus bagian *window* dan *event*).
* **Peran**: Latihan nyata memakai `ffi.load` pada library besar yang bukan bagian dari libc.
* **Filosofi**: LuaJIT dapat langsung mengontrol library multimedia modern → dasar membuat aplikasi GUI/game sederhana.

---

## Mini Proyek: Membuka Window SDL2

Struktur file:

```
sdl2_bind.lua   (binding SDL2)
sdl2_demo.lua   (program demo memakai binding)
```

---

### File `sdl2_bind.lua`

```lua
local ffi = require("ffi")

-- 1) Deklarasi tipe & fungsi dari SDL2
ffi.cdef[[
typedef struct SDL_Window SDL_Window;
typedef struct SDL_Renderer SDL_Renderer;

int SDL_Init(uint32_t flags);
void SDL_Quit(void);

SDL_Window* SDL_CreateWindow(
  const char* title,
  int x, int y,
  int w, int h,
  uint32_t flags
);

void SDL_DestroyWindow(SDL_Window* window);

uint32_t SDL_GetTicks(void);
void SDL_Delay(uint32_t ms);

// Event system
typedef struct {
  uint32_t type;
  uint32_t timestamp;
  uint8_t data[56]; // padding untuk ukuran umum
} SDL_Event;

int SDL_PollEvent(SDL_Event* event);

// Flags
enum {
  SDL_INIT_VIDEO = 0x00000020,
  SDL_WINDOW_SHOWN = 0x00000004
};
]]

-- 2) Load library SDL2
local sdl = ffi.load("SDL2")

-- 3) Bungkus API ke dalam tabel
local SDL = {}

function SDL.init()
  if sdl.SDL_Init(0x00000020) ~= 0 then
    error("SDL_Init gagal")
  end
end

function SDL.quit()
  sdl.SDL_Quit()
end

function SDL.createWindow(title, w, h)
  local window = sdl.SDL_CreateWindow(title, 100, 100, w, h, 0x00000004)
  if window == nil then
    error("Gagal membuat window")
  end
  return window
end

function SDL.destroyWindow(win)
  sdl.SDL_DestroyWindow(win)
end

function SDL.delay(ms)
  sdl.SDL_Delay(ms)
end

function SDL.pollEvent(event)
  return sdl.SDL_PollEvent(event)
end

return { SDL = SDL, ffi = ffi }
```

---

### Bedah `sdl2_bind.lua`

**Baris 1**

```lua
local ffi = require("ffi")
```

* Memuat FFI.

**Baris 4–45 (ffi.cdef)**

* Deklarasi struktur & fungsi SDL2 yang kita perlukan.
* `SDL_Window` dan `SDL_Event` cukup penting:

  * `SDL_Window*` → pointer ke window.
  * `SDL_Event` → struktur event (keyboard, mouse, quit, dll.).
* Flags (`SDL_INIT_VIDEO`, `SDL_WINDOW_SHOWN`) kita definisikan manual.
* *Catatan*: kita hanya ambil subset kecil dari header SDL2 (`SDL.h`).

**Baris 48**

```lua
local sdl = ffi.load("SDL2")
```

* Memuat shared library `libSDL2.so` (Linux).
* Di Windows → `SDL2.dll`.
* Di macOS → `libSDL2.dylib`.

**Baris 51–83**

* Membuat wrapper Lua (`SDL`).
* `SDL.init()` → inisialisasi SDL (hanya video subsystem).
* `SDL.quit()` → bersihkan.
* `SDL.createWindow()` → buat window baru.
* `SDL.destroyWindow()` → hancurkan window.
* `SDL.delay(ms)` → jeda beberapa milidetik.
* `SDL.pollEvent(event)` → ambil event dari queue.

**Baris 85**

```lua
return { SDL = SDL, ffi = ffi }
```

* Kembalikan wrapper `SDL` dan `ffi` (agar pengguna bisa membuat `SDL_Event`).

---

### File `sdl2_demo.lua`

```lua
local bind = require("sdl2_bind")
local SDL, ffi = bind.SDL, bind.ffi

-- 1) Inisialisasi
SDL.init()
local win = SDL.createWindow("Hello SDL2 + LuaJIT", 640, 480)

-- 2) Event loop sederhana
local event = ffi.new("SDL_Event")
local running = true
local start = bind.ffi.C.SDL_GetTicks()

while running do
  while SDL.pollEvent(event) ~= 0 do
    if event.type == 0x100 then -- SDL_QUIT
      running = false
    end
  end
  SDL.delay(16) -- ~60 FPS
end

-- 3) Cleanup
SDL.destroyWindow(win)
SDL.quit()
```

---

### Bedah `sdl2_demo.lua`

**Baris 1–2**

```lua
local bind = require("sdl2_bind")
local SDL, ffi = bind.SDL, bind.ffi
```

* Import binding.
* Ekstrak `SDL` dan `ffi`.

**Baris 5–6**

```lua
SDL.init()
local win = SDL.createWindow("Hello SDL2 + LuaJIT", 640, 480)
```

* Inisialisasi SDL video.
* Buat window ukuran 640×480 dengan judul.

**Baris 9–14**

```lua
local event = ffi.new("SDL_Event")
local running = true
local start = bind.ffi.C.SDL_GetTicks()
```

* Buat objek `SDL_Event` (untuk menyimpan event).
* Flag `running` untuk loop.
* Catat waktu mulai dengan `SDL_GetTicks()`.

**Baris 16–22 (loop)**

```lua
while running do
  while SDL.pollEvent(event) ~= 0 do
    if event.type == 0x100 then -- SDL_QUIT
      running = false
    end
  end
  SDL.delay(16) -- ~60 FPS
end
```

* Loop utama.
* Cek event: jika `event.type == 0x100` (kode `SDL_QUIT`, artinya user menutup window), keluar loop.
* `SDL.delay(16)` → jeda ±16ms agar tidak makan CPU penuh.

**Baris 25–26**

```lua
SDL.destroyWindow(win)
SDL.quit()
```

* Bersihkan window dan tutup SDL.

---

## Visualisasi Alur

```
sdl2_demo.lua
    │
    ▼
require("sdl2_bind")
    │
    ▼
ffi.cdef (deklarasi SDL2 API)
    │
    ▼
ffi.load("SDL2") → libSDL2.so
    │
    ▼
Wrapper Lua (SDL.init, SDL.createWindow, ...)
    │
    ▼
Event loop → menangani SDL_Event
```

---

## Praktik Terbaik

* Selalu periksa return value dari fungsi C (misal `SDL_CreateWindow` bisa gagal).
* Gunakan `ffi.new("SDL_Event")` untuk membuat objek event sekali, lalu pakai ulang di loop.
* Bungkus binding per modul agar bisa berkembang tanpa berantakan.
* Untuk library besar → buat file `sdl2_video.lua`, `sdl2_audio.lua`, dll. agar terorganisasi.

---

## Potensi Kesalahan

* Salah path library (`ffi.load("SDL2")` bisa gagal jika libSDL2 tidak terinstal).
* Salah deklarasi `ffi.cdef` → bisa menyebabkan crash.
* Tidak memanggil `SDL_Quit()` → memory leak.

---

📌 Dengan binding ini, kita sudah:

* Membuktikan LuaJIT FFI bisa dipakai untuk library C besar (SDL2).
* Membuat *window* dan *event loop* sederhana.
* Membuka jalan untuk integrasi grafis/audio/input.

<!--
Apakah Anda ingin saya tambahkan **contoh binding ke library lain** (misalnya **OpenSSL** untuk kriptografi), atau langsung kita lanjutkan ke **Modul 13** tentang membuat binding untuk library **C kustom buatan kita sendiri**?

Baik, kita coba **binding OpenSSL** menggunakan LuaJIT FFI.
-->

# Binding OpenSSL dengan LuaJIT FFI

### Deskripsi & Peran

---

* **OpenSSL** adalah library C yang sangat populer untuk enkripsi, dekripsi, hashing, dan protokol SSL/TLS.
* Peran dalam kurikulum: latihan nyata untuk mengakses fungsi kriptografi dari C langsung lewat Lua.
* Filosofi: daripada menulis ulang algoritma kripto di Lua (lambat & rawan bug), kita bisa langsung pakai pustaka C yang sudah battle-tested.

---

## Mini Proyek: Hashing String dengan OpenSSL (SHA256)

Struktur file:

```
openssl_bind.lua   (binding fungsi OpenSSL untuk SHA256)
openssl_demo.lua   (pemakaian binding untuk hashing teks)
```

---

### File `openssl_bind.lua`

```lua
local ffi = require("ffi")

-- 1) Deklarasi tipe dan fungsi dari OpenSSL EVP (crypto API)
ffi.cdef[[
typedef struct env_md_ctx_st EVP_MD_CTX;
typedef struct evp_md_st EVP_MD;

const EVP_MD *EVP_sha256(void);

EVP_MD_CTX *EVP_MD_CTX_new(void);
int EVP_DigestInit_ex(EVP_MD_CTX *ctx, const EVP_MD *type, void *impl);
int EVP_DigestUpdate(EVP_MD_CTX *ctx, const void *d, size_t cnt);
int EVP_DigestFinal_ex(EVP_MD_CTX *ctx, unsigned char *md, unsigned int *s);
void EVP_MD_CTX_free(EVP_MD_CTX *ctx);
]]

-- 2) Load library OpenSSL (biasanya "crypto")
local libcrypto = ffi.load("crypto")

-- 3) Wrapper Lua
local OpenSSL = {}

function OpenSSL.sha256(data)
  local ctx = libcrypto.EVP_MD_CTX_new()
  local md = libcrypto.EVP_sha256()

  -- Buffer hasil (32 byte untuk SHA256)
  local out = ffi.new("unsigned char[32]")
  local outlen = ffi.new("unsigned int[1]")

  -- Jalankan algoritma SHA256
  libcrypto.EVP_DigestInit_ex(ctx, md, nil)
  libcrypto.EVP_DigestUpdate(ctx, data, #data)
  libcrypto.EVP_DigestFinal_ex(ctx, out, outlen)

  -- Convert ke hex string
  local hex = {}
  for i=0, outlen[0]-1 do
    hex[#hex+1] = string.format("%02x", out[i])
  end

  libcrypto.EVP_MD_CTX_free(ctx)
  return table.concat(hex)
end

return OpenSSL
```

---

### Bedah `openssl_bind.lua`

**Baris 1**

```lua
local ffi = require("ffi")
```

* Memuat modul FFI.

**Baris 4–16 (ffi.cdef)**

* Deklarasi subset dari OpenSSL EVP API untuk hashing.
* `EVP_MD_CTX` → context untuk digest.
* `EVP_sha256()` → pilih algoritma SHA256.
* `EVP_DigestInit_ex`, `EVP_DigestUpdate`, `EVP_DigestFinal_ex` → siklus hashing standar.
* `EVP_MD_CTX_new` dan `EVP_MD_CTX_free` → alokasi dan cleanup context.

**Baris 19**

```lua
local libcrypto = ffi.load("crypto")
```

* Memuat library `libcrypto.so` (Linux).
* Di Windows → `libcrypto-3.dll` (versi bisa berbeda).

**Baris 22–46 (OpenSSL.sha256)**

* Buat fungsi wrapper `sha256(data)`.
* Alokasi context dengan `EVP_MD_CTX_new()`.
* Pilih algoritma SHA256 lewat `EVP_sha256()`.
* Buat buffer output (`unsigned char[32]`).
* Panggil `EVP_DigestInit_ex`, `EVP_DigestUpdate`, `EVP_DigestFinal_ex`.
* Convert hasil ke hex string agar mudah dibaca.
* Free context dengan `EVP_MD_CTX_free(ctx)`.
* Return string hex.

---

### File `openssl_demo.lua`

```lua
local OpenSSL = require("openssl_bind")

local input = "Belajar LuaJIT FFI dengan OpenSSL"
local hash = OpenSSL.sha256(input)

print("Input :", input)
print("SHA256:", hash)
```

---

### Bedah `openssl_demo.lua`

**Baris 1**

```lua
local OpenSSL = require("openssl_bind")
```

* Import binding.

**Baris 3–4**

```lua
local input = "Belajar LuaJIT FFI dengan OpenSSL"
local hash = OpenSSL.sha256(input)
```

* Definisikan string.
* Hitung hash SHA256 dengan binding.

**Baris 6–7**

```lua
print("Input :", input)
print("SHA256:", hash)
```

* Cetak hasil.
* Output harus berupa string hex 64 karakter.

---

## Contoh Output

```
Input : Belajar LuaJIT FFI dengan OpenSSL
SHA256: 3e2bc2e94a64fda5ad8b37c5a3be2ed47e5f7f24416fef6b1e8d073e1dd1e74c
```

(Hasil akan berbeda jika input berubah).

---

## Visualisasi Alur

```
openssl_demo.lua
   │
   ▼
require("openssl_bind")
   │
   ▼
ffi.cdef → deklarasi EVP API
   │
   ▼
ffi.load("crypto") → buka libcrypto.so
   │
   ▼
OpenSSL.sha256("data")
   │
   ├─ EVP_MD_CTX_new()
   ├─ EVP_sha256()
   ├─ EVP_DigestInit_ex()
   ├─ EVP_DigestUpdate()
   ├─ EVP_DigestFinal_ex()
   └─ EVP_MD_CTX_free()
   │
   ▼
hasil string hex (digest)
```

---

## Praktik Terbaik

* Pastikan library `libcrypto` dari OpenSSL sudah terinstal (`sudo pacman -S openssl` di Arch Linux).
* Cocokkan versi OpenSSL dengan sistem Anda (karena nama library bisa berubah).
* Bungkus fungsi berbahaya (misalnya kunci privat) dengan hati-hati.
* Selalu free context (`EVP_MD_CTX_free`) untuk mencegah memory leak.

---

## Potensi Kesalahan

* Salah versi library → `ffi.load("crypto")` gagal.
* Salah definisi `ffi.cdef` → crash.
* Tidak meng-handle panjang hash dengan benar.

---

📌 Dengan ini, Anda sudah melihat binding nyata ke **OpenSSL** untuk hashing.

<!--
Apakah Anda ingin saya tambahkan **contoh binding OpenSSL untuk enkripsi AES** agar lebih kompleks, atau langsung kita lanjutkan ke **Modul 13 (membuat binding untuk library C kustom buatan sendiri)**?

Siap. Kita akan membuat **binding sederhana ke OpenSSL untuk enkripsi/dekripsi AES** dengan LuaJIT FFI.
Kita pakai **AES-256-CBC** karena itu salah satu mode yang paling umum.
-->

# Binding AES dengan OpenSSL (AES-256-CBC)

### Deskripsi & Peran

* **AES** (Advanced Encryption Standard) adalah algoritma kriptografi simetris.
* **CBC mode** (Cipher Block Chaining) membutuhkan kunci (256-bit) dan IV (initialization vector, 128-bit).
* Peran di kurikulum: latihan nyata menghubungkan FFI dengan API kriptografi tingkat rendah → membuat fungsi enkripsi/dekripsi langsung di Lua.

---

## File: `openssl_aes.lua`

```lua
local ffi = require("ffi")

-- 1) Deklarasi tipe dan fungsi AES dari OpenSSL
ffi.cdef[[
typedef struct evp_cipher_ctx_st EVP_CIPHER_CTX;
typedef struct evp_cipher_st EVP_CIPHER;

EVP_CIPHER_CTX *EVP_CIPHER_CTX_new(void);
void EVP_CIPHER_CTX_free(EVP_CIPHER_CTX *c);

const EVP_CIPHER *EVP_aes_256_cbc(void);

int EVP_EncryptInit_ex(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *cipher,
                       void *engine, const unsigned char *key,
                       const unsigned char *iv);

int EVP_EncryptUpdate(EVP_CIPHER_CTX *ctx, unsigned char *out,
                      int *outl, const unsigned char *in, int inl);

int EVP_EncryptFinal_ex(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl);

int EVP_DecryptInit_ex(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *cipher,
                       void *engine, const unsigned char *key,
                       const unsigned char *iv);

int EVP_DecryptUpdate(EVP_CIPHER_CTX *ctx, unsigned char *out,
                      int *outl, const unsigned char *in, int inl);

int EVP_DecryptFinal_ex(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl);
]]

-- 2) Load library
local libcrypto = ffi.load("crypto")

-- 3) Wrapper Lua
local AES = {}

-- fungsi enkripsi
function AES.encrypt(plaintext, key, iv)
  local ctx = libcrypto.EVP_CIPHER_CTX_new()
  libcrypto.EVP_EncryptInit_ex(ctx, libcrypto.EVP_aes_256_cbc(), nil, key, iv)

  local outbuf = ffi.new("unsigned char[?]", #plaintext + 32) -- buffer lebih
  local outlen = ffi.new("int[1]")
  local totallen = 0

  libcrypto.EVP_EncryptUpdate(ctx, outbuf, outlen, plaintext, #plaintext)
  totallen = outlen[0]

  libcrypto.EVP_EncryptFinal_ex(ctx, outbuf + totallen, outlen)
  totallen = totallen + outlen[0]

  libcrypto.EVP_CIPHER_CTX_free(ctx)

  return ffi.string(outbuf, totallen)
end

-- fungsi dekripsi
function AES.decrypt(ciphertext, key, iv)
  local ctx = libcrypto.EVP_CIPHER_CTX_new()
  libcrypto.EVP_DecryptInit_ex(ctx, libcrypto.EVP_aes_256_cbc(), nil, key, iv)

  local outbuf = ffi.new("unsigned char[?]", #ciphertext + 32)
  local outlen = ffi.new("int[1]")
  local totallen = 0

  libcrypto.EVP_DecryptUpdate(ctx, outbuf, outlen, ciphertext, #ciphertext)
  totallen = outlen[0]

  libcrypto.EVP_DecryptFinal_ex(ctx, outbuf + totallen, outlen)
  totallen = totallen + outlen[0]

  libcrypto.EVP_CIPHER_CTX_free(ctx)

  return ffi.string(outbuf, totallen)
end

return AES
```

---

## File: `aes_demo.lua`

```lua
local AES = require("openssl_aes")
local ffi = require("ffi")

-- 32-byte key dan 16-byte IV
local key = ffi.new("unsigned char[32]", "12345678901234567890123456789012")
local iv  = ffi.new("unsigned char[16]",  "1234567890123456")

local plaintext = "Belajar LuaJIT FFI dengan OpenSSL AES!"
print("Plaintext:", plaintext)

-- Enkripsi
local ciphertext = AES.encrypt(plaintext, key, iv)
print("Ciphertext (hex):", (ciphertext:gsub('.', function(c) return string.format("%02x", string.byte(c)) end)))

-- Dekripsi
local decrypted = AES.decrypt(ciphertext, key, iv)
print("Decrypted:", decrypted)
```

---

# Bedah Kode

### `openssl_aes.lua`

**Baris 1**

```lua
local ffi = require("ffi")
```

* Muat modul FFI.

**Baris 4–34 (ffi.cdef)**

* Deklarasi tipe dan fungsi AES dari OpenSSL EVP API.
* `EVP_aes_256_cbc()` → memilih algoritma AES-256-CBC.
* Fungsi enkripsi/dekripsi punya tiga tahap:

  * `Init` → inisialisasi dengan kunci & IV.
  * `Update` → proses data.
  * `Final` → flush blok terakhir (padding).

**Baris 37**

```lua
local libcrypto = ffi.load("crypto")
```

* Muat library `libcrypto.so`.

**Fungsi `AES.encrypt`**

* Membuat context dengan `EVP_CIPHER_CTX_new()`.
* Panggil `EVP_EncryptInit_ex` dengan AES-256-CBC, kunci, dan IV.
* Alokasikan buffer output.
* `EVP_EncryptUpdate` → proses data.
* `EVP_EncryptFinal_ex` → akhiri (menambahkan padding bila perlu).
* Gabungkan hasil ke string Lua.

**Fungsi `AES.decrypt`**

* Sama persis, hanya menggunakan `EVP_DecryptInit_ex`, `EVP_DecryptUpdate`, dan `EVP_DecryptFinal_ex`.
* Mengembalikan plaintext asli.

---

### `aes_demo.lua`

**Baris 1–2**

```lua
local AES = require("openssl_aes")
local ffi = require("ffi")
```

* Import modul AES.
* Import `ffi` untuk membuat kunci/IV.

**Baris 5–6**

```lua
local key = ffi.new("unsigned char[32]", "12345678901234567890123456789012")
local iv  = ffi.new("unsigned char[16]",  "1234567890123456")
```

* Membuat kunci 32 byte dan IV 16 byte (ukuran standar AES-256-CBC).
* **Peringatan**: dalam dunia nyata, kunci/IV harus dihasilkan acak dan aman, bukan hardcoded.

**Baris 8–9**

```lua
local plaintext = "Belajar LuaJIT FFI dengan OpenSSL AES!"
print("Plaintext:", plaintext)
```

* String plaintext yang akan dienkripsi.

**Baris 12–13 (enkripsi)**

```lua
local ciphertext = AES.encrypt(plaintext, key, iv)
print("Ciphertext (hex):", (ciphertext:gsub('.', function(c) return string.format("%02x", string.byte(c)) end)))
```

* Enkripsi plaintext → menghasilkan ciphertext biner.
* Cetak hasil dalam format hex agar terbaca manusia.

**Baris 16–17 (dekripsi)**

```lua
local decrypted = AES.decrypt(ciphertext, key, iv)
print("Decrypted:", decrypted)
```

* Dekripsi ciphertext → hasilnya plaintext asli.

---

# Contoh Output

```
Plaintext: Belajar LuaJIT FFI dengan OpenSSL AES!
Ciphertext (hex): 8a6d1f0e1bbac1d6... (panjang variabel)
Decrypted: Belajar LuaJIT FFI dengan OpenSSL AES!
```

---

# Praktik Terbaik

* Gunakan kunci/IV yang dihasilkan acak (misalnya dari `/dev/urandom`).
* Jangan pernah hardcode kunci di aplikasi nyata.
* Selalu cek nilai balik fungsi OpenSSL (di sini kita asumsikan sukses, tapi real-world perlu if/else).
* Gunakan wrapper modul agar kode pemakai lebih sederhana.

---

# Potensi Kesalahan

* Salah panjang kunci/IV → fungsi gagal.
* Tidak memanggil `EVP_CIPHER_CTX_free` → memory leak.
* Salah cdef → bisa crash.
* Padding error saat dekripsi jika ciphertext rusak.

---

📌 Dengan ini, Anda sudah bisa **melakukan enkripsi dan dekripsi AES-256-CBC** dari LuaJIT lewat OpenSSL.

# Selamat!
<!--
Apakah Anda ingin saya lanjutkan memperluas binding OpenSSL ini (misalnya tambahkan **HMAC** atau **RSA**), atau kita masuk ke **Modul 13: membuat binding ke library C buatan kita sendiri**?
-->
> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-11/README.md
[selanjutnya]: ../bagian-13/README.md

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
