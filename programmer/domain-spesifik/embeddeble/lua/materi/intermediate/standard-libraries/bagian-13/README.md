<!--
<details>
  <summary>📃 Daftar Isi</summary>

</details>

Baik, kita lanjut ke **Modul 13: Membuat Binding ke Library C Buatan Sendiri**.

-->

# **[Modul 13 – Binding ke Library C Buatan Sendiri][0]**

### Deskripsi & Peran

* Pada modul sebelumnya, kita mengakses **library eksternal yang sudah ada** (misalnya OpenSSL).
* Kali ini, kita akan membuat **library C sederhana buatan sendiri**, lalu memanggilnya dari Lua lewat FFI.
* Peran dalam kurikulum: ini melatih kita untuk **mengontrol penuh** alur dari kode native → ke binding → ke Lua.
* Filosofi: “jembatan” antara dunia *low-level* (C) dengan *high-level* (Lua) ada di tangan kita.

---

## Mini Proyek: Library Matematika Kustom

Struktur:

```
libmath.c        → Library C (kompilasi ke .so/.dll)
libmath.h        → Header C
math_bind.lua    → Binding Lua dengan FFI
math_demo.lua    → Demo pemanggilan binding
```

---

### File `libmath.c`

```c
// libmath.c
#include "libmath.h"
#include <math.h>

double add(double a, double b) {
    return a + b;
}

double sub(double a, double b) {
    return a - b;
}

double mul(double a, double b) {
    return a * b;
}

double divide(double a, double b) {
    if (b == 0.0) return 0.0; // sederhana: hindari div 0
    return a / b;
}

double hypotenuse(double x, double y) {
    return sqrt(x*x + y*y);
}
```

---

### File `libmath.h`

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

---

### Kompilasi

Linux:

```bash
gcc -shared -fPIC -o libmath.so libmath.c
```

Windows (mingw):

```bash
gcc -shared -o libmath.dll libmath.c
```

---

### File `math_bind.lua`

```lua
local ffi = require("ffi")

ffi.cdef[[
double add(double a, double b);
double sub(double a, double b);
double mul(double a, double b);
double divide(double a, double b);
double hypotenuse(double x, double y);
]]

-- load library buatan sendiri
local libmath = ffi.load("./libmath.so")  -- di Windows: "./libmath.dll"

local M = {}

M.add = libmath.add
M.sub = libmath.sub
M.mul = libmath.mul
M.divide = libmath.divide
M.hypotenuse = libmath.hypotenuse

return M
```

---

### File `math_demo.lua`

```lua
local mathlib = require("math_bind")

print("2 + 3 =", mathlib.add(2, 3))
print("5 - 1 =", mathlib.sub(5, 1))
print("4 * 6 =", mathlib.mul(4, 6))
print("8 / 2 =", mathlib.divide(8, 2))
print("Hypotenuse(3,4) =", mathlib.hypotenuse(3, 4))
```

---

# Bedah Kode

### `libmath.c`

* Fungsi sederhana: `add`, `sub`, `mul`, `divide`, `hypotenuse`.
* Semua fungsi bertipe `double`.
* `hypotenuse` menggunakan `sqrt` dari `<math.h>`.

### `libmath.h`

* Header file agar fungsi dikenali compiler.
* Dipakai juga untuk `ffi.cdef` di Lua.

### `math_bind.lua`

* **ffi.cdef** mendeklarasikan fungsi C yang tersedia.
* **ffi.load("./libmath.so")** membuka library hasil kompilasi.
* Membuat wrapper `M` agar mudah dipanggil dari Lua.

### `math_demo.lua`

* Memanggil fungsi binding.
* Menunjukkan hasil operasi.

---

# Contoh Output

```
2 + 3 = 5.0
5 - 1 = 4.0
4 * 6 = 24.0
8 / 2 = 4.0
Hypotenuse(3,4) = 5.0
```

---

# Visualisasi Alur

```
math_demo.lua
   │
   ▼
require("math_bind")
   │
   ▼
ffi.cdef → deklarasi header C
   │
   ▼
ffi.load("./libmath.so")
   │
   ▼
libmath.add / sub / mul / divide / hypotenuse
   │
   ▼
fungsi dipanggil di Lua
```

---

# Praktik Terbaik

* Simpan library kustom di folder khusus (`/usr/local/lib` atau project root).
* Gunakan namespace atau prefix agar nama fungsi unik (`mymath_add` bukan sekadar `add`).
* Pisahkan header dan implementasi agar mudah dibaca.
* Untuk proyek besar → gunakan `cmake` atau `meson`.

---

# Potensi Kesalahan

* Lupa menambahkan `-fPIC` saat compile → gagal load di Linux.
* Salah path library di `ffi.load` → error “cannot open shared object file”.
* Perbedaan nama file: `.so` (Linux), `.dylib` (macOS), `.dll` (Windows).
* Salah deklarasi di `ffi.cdef` → bisa crash.

---

📌 Dengan ini, Anda sudah membuat **library C sendiri, compile, lalu dipanggil lewat LuaJIT FFI**.
<!--
Apakah Anda ingin saya tambahkan satu **mini proyek ekstra** (misalnya library C untuk *string utils* atau *array processing*) agar sebelum lanjut ke Modul 14 kita punya dua variasi binding?

Baik, kita buat **mini proyek ekstra** untuk melengkapi Modul 13. Kali ini kita fokus ke **library C untuk String Utilities**.

-->

# Mini Proyek Ekstra: String Utilities Library

### Deskripsi

* Library ini berisi fungsi manipulasi string sederhana di C, lalu kita panggil dari Lua.
* Fungsi yang disediakan:

  1. `to_upper` → mengubah string jadi huruf besar.
  2. `to_lower` → mengubah string jadi huruf kecil.
  3. `reverse` → membalik string.
  4. `concat` → menggabungkan dua string.

---

## File `libstrutils.c`

```c
// libstrutils.c
#include "libstrutils.h"
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

char* to_upper(const char* input) {
    size_t len = strlen(input);
    char* result = (char*)malloc(len + 1);
    for (size_t i = 0; i < len; i++) {
        result[i] = toupper((unsigned char)input[i]);
    }
    result[len] = '\0';
    return result;
}

char* to_lower(const char* input) {
    size_t len = strlen(input);
    char* result = (char*)malloc(len + 1);
    for (size_t i = 0; i < len; i++) {
        result[i] = tolower((unsigned char)input[i]);
    }
    result[len] = '\0';
    return result;
}

char* reverse(const char* input) {
    size_t len = strlen(input);
    char* result = (char*)malloc(len + 1);
    for (size_t i = 0; i < len; i++) {
        result[i] = input[len - i - 1];
    }
    result[len] = '\0';
    return result;
}

char* concat(const char* a, const char* b) {
    size_t len_a = strlen(a);
    size_t len_b = strlen(b);
    char* result = (char*)malloc(len_a + len_b + 1);
    strcpy(result, a);
    strcat(result, b);
    return result;
}

void free_str(char* str) {
    free(str);
}
```

---

## File `libstrutils.h`

```c
// libstrutils.h
#ifndef LIBSTRUTILS_H
#define LIBSTRUTILS_H

char* to_upper(const char* input);
char* to_lower(const char* input);
char* reverse(const char* input);
char* concat(const char* a, const char* b);
void free_str(char* str);

#endif
```

---

## Kompilasi

Linux:

```bash
gcc -shared -fPIC -o libstrutils.so libstrutils.c
```

Windows (mingw):

```bash
gcc -shared -o libstrutils.dll libstrutils.c
```

---

## File `strutils_bind.lua`

```lua
local ffi = require("ffi")

ffi.cdef[[
char* to_upper(const char* input);
char* to_lower(const char* input);
char* reverse(const char* input);
char* concat(const char* a, const char* b);
void free_str(char* str);
]]

local lib = ffi.load("./libstrutils.so") -- atau .dll di Windows

local M = {}

local function wrap(func)
  return function(...)
    local cstr = func(...)
    local lua_str = ffi.string(cstr)
    lib.free_str(cstr) -- bebaskan memori dari malloc
    return lua_str
  end
end

M.to_upper = wrap(lib.to_upper)
M.to_lower = wrap(lib.to_lower)
M.reverse  = wrap(lib.reverse)
M.concat   = wrap(lib.concat)

return M
```

---

## File `strutils_demo.lua`

```lua
local strutils = require("strutils_bind")

local s = "LuaJIT FFI"

print("Asli:", s)
print("Upper:", strutils.to_upper(s))
print("Lower:", strutils.to_lower(s))
print("Reverse:", strutils.reverse(s))
print("Concat:", strutils.concat(s, " Rocks!"))
```

---

# Bedah Kode

### `libstrutils.c`

* Menggunakan `malloc` untuk membuat string baru hasil operasi.
* `to_upper` dan `to_lower`: loop tiap karakter lalu gunakan `toupper`/`tolower`.
* `reverse`: membalik urutan string.
* `concat`: gabungkan string A dan B.
* `free_str`: fungsi untuk membebaskan memori hasil `malloc`.

### `libstrutils.h`

* Deklarasi fungsi agar bisa dipakai FFI.

### `strutils_bind.lua`

* `ffi.cdef` mendeklarasikan fungsi string.
* `wrap(func)` adalah helper untuk:

  * memanggil fungsi C,
  * mengubah hasil jadi string Lua,
  * memanggil `free_str` agar memori tidak bocor.
* Semua fungsi C dibungkus ke dalam fungsi Lua.

### `strutils_demo.lua`

* Menguji semua fungsi: uppercase, lowercase, reverse, concat.

---

# Contoh Output

```
Asli: LuaJIT FFI
Upper: LUAJIT FFI
Lower: luajit ffi
Reverse: IFF TIJauL
Concat: LuaJIT FFI Rocks!
```

---

# Praktik Terbaik

* Selalu sediakan fungsi `free_str` bila di C ada `malloc`.
* Jangan return pointer dari C tanpa cara membebaskannya.
* Bungkus semua fungsi dengan wrapper agar pengguna Lua tidak perlu peduli soal memory management.

---

# Potensi Kesalahan

* Lupa `free_str` → memory leak.
* Salah deklarasi panjang string → hasil rusak.
* Karakter non-ASCII bisa bermasalah karena `toupper`/`tolower` hanya aman untuk ASCII standar.

---

📌 Dengan ini, kita punya **dua variasi binding**:

1. **Math library** → operasi numerik.
2. **String utils library** → manipulasi teks.

Keduanya menunjukkan pola yang sama: buat library C → kompilasi → panggil lewat Lua FFI → bungkus jadi API ramah Lua.
<!--
Apakah Anda ingin kita lanjut ke **Modul 14** sekarang, atau mau saya buat satu contoh **array processing library** juga sebelum melompat?
-->
> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-12/README.md
[selanjutnya]: ../bagian-14/README.md

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
