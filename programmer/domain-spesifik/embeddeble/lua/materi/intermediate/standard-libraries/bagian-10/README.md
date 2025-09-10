# [Modul 10 — C API][0]

Modul ini adalah jembatan antara **Lua** dengan **bahasa C**, memungkinkan kita membuat **fungsi ekstensi, binding library, dan embedding Lua di aplikasi C**.

<details>
  <summary>📃 Daftar Isi</summary>

---

### Struktur Pembelajaran Internal (mini-TOC)

* **10.1 Pengenalan C API**

  * Apa itu C API
  * Dua arah: *Embedding* dan *Extending*
* **10.2 Struktur Dasar Program C dengan Lua**

  * Inisialisasi Lua state
  * Menjalankan kode Lua dari C
* **10.3 Membuat Fungsi C untuk Dipanggil dari Lua**

  * Registrasi fungsi C
  * Contoh fungsi sederhana
* **10.4 Mengakses Data Lua dari C**

  * Stack Lua
  * Fungsi `lua_gettable`, `lua_settable`
* **10.5 Studi Kasus**

  * Membuat modul `mymath` di C
  * Memanggilnya dari Lua
* **10.6 Praktik Terbaik & Potensi Kesalahan**
* **10.7 Latihan & Kuiz**
* Visualisasi

</details>

---

## 10.1 Pengenalan C API

### Deskripsi & Peran

* **C API** = kumpulan fungsi C yang memungkinkan interaksi dengan Lua.
* Ada dua pola utama:

  1. **Embedding** → Menanamkan Lua ke aplikasi C (C memanggil Lua).
  2. **Extending** → Memperluas Lua dengan fungsi C (Lua memanggil C).

### Filosofi

* Lua dirancang **mudah diintegrasikan** dengan C.
* Semua hal di Lua dapat diakses melalui **stack** (tumpukan).

---

## 10.2 Struktur Dasar Program C dengan Lua

### Contoh: Menjalankan kode Lua dari C

```c
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

int main(void) {
    lua_State *L = luaL_newstate();  // buat state baru
    luaL_openlibs(L);                // buka library standar Lua

    luaL_dostring(L, "print('Halo dari Lua!')");

    lua_close(L);  // tutup state
    return 0;
}
```

* `luaL_newstate()` → buat lingkungan Lua baru.
* `luaL_openlibs(L)` → load semua library standar Lua (`math`, `table`, dll).
* `luaL_dostring` → jalankan string Lua langsung.
* `lua_close(L)` → tutup state untuk membebaskan memori.

---

## 10.3 Membuat Fungsi C untuk Dipanggil dari Lua

### Fungsi C sederhana

```c
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

// Fungsi C: tambah dua angka
int l_add(lua_State *L) {
    double a = luaL_checknumber(L, 1); // ambil argumen 1
    double b = luaL_checknumber(L, 2); // ambil argumen 2
    lua_pushnumber(L, a + b);          // hasil ke stack
    return 1;  // jumlah return value
}

int main(void) {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    lua_register(L, "c_add", l_add); // daftar fungsi sebagai c_add

    luaL_dostring(L, "print('Hasil:', c_add(10, 20))");

    lua_close(L);
    return 0;
}
```

👉 Output:

```
Hasil: 30
```

---

## 10.4 Mengakses Data Lua dari C

* **Stack Lua** adalah pusat komunikasi. Semua argumen masuk ke stack, semua hasil keluar dari stack.

Contoh akses tabel:

```c
lua_getglobal(L, "t");     // ambil tabel global t
lua_getfield(L, -1, "x");  // ambil t.x
double x = lua_tonumber(L, -1);
```

👉 `-1` artinya elemen paling atas di stack.

---

## 10.5 Studi Kasus: Modul `mymath` di C

### File `mymath.c`

```c
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

// Faktorial
int l_factorial(lua_State *L) {
    int n = luaL_checkinteger(L, 1);
    int res = 1;
    for (int i = 1; i <= n; i++) res *= i;
    lua_pushinteger(L, res);
    return 1;
}

// Modul registrasi
int luaopen_mymath(lua_State *L) {
    luaL_Reg funcs[] = {
        {"factorial", l_factorial},
        {NULL, NULL}
    };
    luaL_newlib(L, funcs);
    return 1;
}
```

### Kompilasi (Linux)

```bash
gcc -O2 -fPIC -shared -o mymath.so mymath.c -I/usr/include/lua5.4 -llua5.4
```

### Penggunaan di Lua

```lua
local mymath = require("mymath")
print(mymath.factorial(5))  -- 120
```

---

## 10.6 Praktik Terbaik

* Selalu cek tipe argumen dengan `luaL_check*`.
* Selalu `return` jumlah nilai yang dikembalikan ke Lua.
* Gunakan `luaL_newlib` untuk membuat modul dengan banyak fungsi.
* Jangan lupa `lua_close` untuk menghindari kebocoran memori.

---

## 10.7 Potensi Kesalahan

* **Lupa cek tipe argumen** → crash C.
* **Salah hitung jumlah return value** → stack tidak konsisten.
* **Tidak kompilasi dengan -fPIC / -shared** → modul tidak bisa di-*require*.

---

## 10.8 Latihan & Kuiz

1. Tambahkan fungsi `gcd(a, b)` di `mymath.c`.
2. Buat fungsi C yang mengembalikan string `"Halo dari C"`.
3. Apa yang terjadi jika fungsi C `return 0` tetapi `lua_push*` sudah dipanggil?
   (jawaban: nilai yang dipush akan diabaikan karena tidak dihitung di return count).

---

## Visualisasi

```
Lua (require "mymath") ──► C (luaopen_mymath)
           │
           ▼
   luaL_newlib → daftar fungsi
           │
           ▼
   mymath.factorial → panggil l_factorial()
```

---

## Referensi

* Lua 5.4 Reference Manual — [The C API](https://www.lua.org/manual/5.4/manual.html#4)
* *Programming in Lua* (Bab 25–27: Extending Lua with C)
* Lua-users wiki — [C API Tutorial](http://lua-users.org/wiki/SimpleLuaApiExample)

---

Kita akan membuat **mini-project C API**: modul `vector3d` ditulis dalam **C** (menggunakan Lua C API) lalu dipanggil dari **Lua**. :

1. Tampilkan **kode C lengkap** (`vector3d.c`) yang membuat tipe userdata `Vector3D` + metamethods (`__tostring`, `__add`, `__sub`, `__mul`, `__eq`) dan methods (`magnitude`, `normalize`), serta fungsi konstruktor `Vector3D.new`.
2. Berikan **perintah kompilasi** (Linux/Arch fokus) dan penjelasan alternatif (pkg-config / path include / nama library).
3. Tampilkan contoh **`main.lua`** (pemakaian dari Lua).
4. **Bedah baris demi baris** kode C dan Lua — menjelaskan stack, return counts, kenapa tiap baris ada, serta catatan pengembangan/modifikasi.
5. Daftar **prasyarat** (apa yang harus Anda siapkan untuk memodifikasi/kompilasi) dan **tips debugging**.
6. Sertakan referensi resmi/sumber dokumentasi.

Kita akan langsung kerjakan semua di sini (tidak menunggu). Mari kita mulai.

---

## 1) Kode C lengkap — `vector3d.c`

Simpan sebagai `vector3d.c`.

```c
// vector3d.c
// Modul Lua C: Vector3D userdata dengan metamethods
// Build: lihat instruksi dalam dokumentasi di bawah

#include <math.h>
#include <stdio.h>
#include <string.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

// Nama metatable (harus unik di registry)
#define VEC3_MT "Vector3D"

// Struktur userdata untuk vektor 3D
typedef struct {
  double x;
  double y;
  double z;
} Vector3D;

// Helper: check & get userdata Vector3D pada stack index
static Vector3D *checkVector3D(lua_State *L, int idx) {
  return (Vector3D *) luaL_checkudata(L, idx, VEC3_MT);
}

// Constructor: Vector3D.new([x, y, z])
static int vector_new(lua_State *L) {
  double x = luaL_optnumber(L, 1, 0.0);
  double y = luaL_optnumber(L, 2, 0.0);
  double z = luaL_optnumber(L, 3, 0.0);

  Vector3D *v = (Vector3D *) lua_newuserdata(L, sizeof(Vector3D));
  v->x = x; v->y = y; v->z = z;

  // set metatable
  luaL_getmetatable(L, VEC3_MT);
  lua_setmetatable(L, -2);

  return 1; // userdata dikembalikan
}

// __tostring metamethod
static int vector_tostring(lua_State *L) {
  Vector3D *v = checkVector3D(L, 1);
  lua_pushfstring(L, "(%g, %g, %g)", v->x, v->y, v->z);
  return 1;
}

// __add metamethod: v + w
static int vector_add(lua_State *L) {
  Vector3D *a = checkVector3D(L, 1);
  Vector3D *b = checkVector3D(L, 2);

  Vector3D *r = (Vector3D *) lua_newuserdata(L, sizeof(Vector3D));
  r->x = a->x + b->x;
  r->y = a->y + b->y;
  r->z = a->z + b->z;

  luaL_getmetatable(L, VEC3_MT);
  lua_setmetatable(L, -2);
  return 1;
}

// __sub metamethod: v - w
static int vector_sub(lua_State *L) {
  Vector3D *a = checkVector3D(L, 1);
  Vector3D *b = checkVector3D(L, 2);

  Vector3D *r = (Vector3D *) lua_newuserdata(L, sizeof(Vector3D));
  r->x = a->x - b->x;
  r->y = a->y - b->y;
  r->z = a->z - b->z;

  luaL_getmetatable(L, VEC3_MT);
  lua_setmetatable(L, -2);
  return 1;
}

// __mul metamethod:
// - number * vector  -> vector (scale)
// - vector * number  -> vector (scale)
// - vector * vector  -> number (dot product)
static int vector_mul(lua_State *L) {
  if (lua_isnumber(L, 1) && luaL_testudata(L, 2, VEC3_MT)) {
    double s = lua_tonumber(L, 1);
    Vector3D *b = checkVector3D(L, 2);
    Vector3D *r = (Vector3D *) lua_newuserdata(L, sizeof(Vector3D));
    r->x = s * b->x; r->y = s * b->y; r->z = s * b->z;
    luaL_getmetatable(L, VEC3_MT); lua_setmetatable(L, -2);
    return 1;
  } else if (lua_isnumber(L, 2) && luaL_testudata(L, 1, VEC3_MT)) {
    Vector3D *a = checkVector3D(L, 1);
    double s = lua_tonumber(L, 2);
    Vector3D *r = (Vector3D *) lua_newuserdata(L, sizeof(Vector3D));
    r->x = a->x * s; r->y = a->y * s; r->z = a->z * s;
    luaL_getmetatable(L, VEC3_MT); lua_setmetatable(L, -2);
    return 1;
  } else { // assume both are Vector3D -> dot product
    Vector3D *a = checkVector3D(L, 1);
    Vector3D *b = checkVector3D(L, 2);
    double dot = a->x * b->x + a->y * b->y + a->z * b->z;
    lua_pushnumber(L, dot);
    return 1;
  }
}

// __eq metamethod: equality
static int vector_eq(lua_State *L) {
  Vector3D *a = checkVector3D(L, 1);
  Vector3D *b = checkVector3D(L, 2);
  lua_pushboolean(L, (a->x == b->x) && (a->y == b->y) && (a->z == b->z));
  return 1;
}

// method: magnitude (vector:magnitude())
static int vector_magnitude(lua_State *L) {
  Vector3D *v = checkVector3D(L, 1);
  double mag = sqrt(v->x * v->x + v->y * v->y + v->z * v->z);
  lua_pushnumber(L, mag);
  return 1;
}

// method: normalize (vector:normalize()) -> returns new Vector3D
static int vector_normalize(lua_State *L) {
  Vector3D *v = checkVector3D(L, 1);
  double mag = sqrt(v->x * v->x + v->y * v->y + v->z * v->z);
  if (mag == 0.0) {
    Vector3D *r = (Vector3D *) lua_newuserdata(L, sizeof(Vector3D));
    r->x = r->y = r->z = 0.0;
    luaL_getmetatable(L, VEC3_MT); lua_setmetatable(L, -2);
    return 1;
  }
  Vector3D *r = (Vector3D *) lua_newuserdata(L, sizeof(Vector3D));
  r->x = v->x / mag; r->y = v->y / mag; r->z = v->z / mag;
  luaL_getmetatable(L, VEC3_MT); lua_setmetatable(L, -2);
  return 1;
}

// Register methods (non-metamethods)
static const luaL_Reg vector_methods[] = {
  {"magnitude", vector_magnitude},
  {"normalize", vector_normalize},
  {NULL, NULL}
};

// Register metamethods & metamethod keys
static const luaL_Reg vector_metamethods[] = {
  {"__tostring", vector_tostring},
  {"__add",      vector_add},
  {"__sub",      vector_sub},
  {"__mul",      vector_mul},
  {"__eq",       vector_eq},
  {NULL, NULL}
};

// Module functions (constructor)
static const luaL_Reg vectorlib[] = {
  {"new", vector_new},
  {NULL, NULL}
};

// Module entry point
int luaopen_vector3d(lua_State *L) {
  // create metatable for userdata
  luaL_newmetatable(L, VEC3_MT);           // stack: mt

  // set metamethods onto metatable
  luaL_setfuncs(L, vector_metamethods, 0); // register __tostring,__add,...

  // set __index = metatable (so methods are found on metatable)
  lua_pushvalue(L, -1);                    // duplicate metatable
  lua_setfield(L, -2, "__index");          // mt.__index = mt

  // register normal methods into metatable (so they are accessible via obj:method)
  luaL_setfuncs(L, vector_methods, 0);

  // create module table and register constructor
  luaL_newlib(L, vectorlib);
  return 1;
}
```

---

## 2) Contoh penggunaan (Lua) — `main.lua`

Simpan `main.lua` di folder yang sama (agar `require` menemukan `vector3d.so` di CWD).

```lua
-- main.lua
local Vec3 = require("vector3d")

local v1 = Vec3.new(1, 2, 3)
local v2 = Vec3.new(4, 5, 6)

print("v1 =", v1)              -- uses __tostring
print("v2 =", v2)

print("v1 + v2 =", v1 + v2)
print("v1 - v2 =", v1 - v2)

print("v1 · v2 =", v1 * v2)   -- dot product -> number

print("2 * v1 =", 2 * v1)     -- scalar * vector -> vector
print("v2 * 3 =", v2 * 3)     -- vector * scalar -> vector

print("v1 magnitude =", v1:magnitude())
print("v1 normalized =", v1:normalize())

print("v1 == Vec3.new(1,2,3)?", v1 == Vec3.new(1,2,3))
```

---

## 3) Cara kompilasi (Linux / Arch Linux fokus)

### 3.a. Cara singkat (jika `pkg-config` tersedia untuk Lua)

Jika sistem punya pkg-config entry (contoh `lua5.4`), gunakan:

```bash
gcc -O2 -fPIC $(pkg-config --cflags lua5.4) -shared -o vector3d.so vector3d.c $(pkg-config --libs lua5.4)
```

`pkg-config` memberikan include path dan link flags yang sesuai sehingga lebih portable antar distro. Jika `lua5.4` tidak ada, coba `lua` atau `lua5.3` sesuai versi. ([Stack Overflow][1], [lua-users.org][2])

### 3.b. Contoh perintah manual (umum di banyak Linux)

Jika header ada di `/usr/include/lua5.4` dan library `-llua5.4`:

```bash
gcc -O2 -fPIC -I/usr/include/lua5.4 -shared -o vector3d.so vector3d.c -llua5.4 -lm
```

Atau jika library dinamika bernama `liblua.so`:

```bash
gcc -O2 -fPIC -I/usr/include/lua5.4 -shared -o vector3d.so vector3d.c -llua -lm
```

**Catatan**:

* `-fPIC` diperlukan untuk membuat shared object.
* Nama header path (`/usr/include/lua5.4`) dan library (`-llua5.4` atau `-llua`) bergantung pada distro / paket. Jika di Arch Linux Anda memasang `lua` dari repositori resmi, header biasanya tersedia; jika belum, pasang paket `lua` (sudah termasuk header) atau paket developer yang sesuai. Jika link gagal, periksa `pkg-config` atau file `.pc` di `/usr/lib/pkgconfig/`. ([lua-users.org][2], [linuxfromscratch.org][3])

### 3.c. Menjalankan

Setelah `vector3d.so` dibuat di direktori kerja yang sama dengan `main.lua`, jalankan:

```bash
lua main.lua
```

Jika `require("vector3d")` tidak menemukan file, Anda bisa menaruh `vector3d.so` di salah satu folder yang ada di `package.cpath` atau menambahkan path saat runtime:

```lua
package.cpath = package.cpath .. ";./?.so"
local Vec3 = require("vector3d")
```

---

## 4) Penjelasan & bedah kode — baris demi baris (rincian teknis)

Saya akan menjelaskan bagian-per-bagian kode `vector3d.c`. Saya akan menekankan **apa yang terjadi pada stack Lua**, **mengapa return count penting**, dan **cara userdata & metatable dikelola**.

### Header & struktur

```c
#include <math.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
```

* `math.h` untuk `sqrt`.
* `lua.h`, `lauxlib.h`, `lualib.h` adalah header resmi Lua C API. Mereka mendefinisikan `lua_State`, fungsi stack, `luaL_*` helper, dll. (lihat referensi oficial). ([lua.org][4])

```c
typedef struct {
  double x,y,z;
} Vector3D;
```

* `Vector3D` adalah struktur data C yang akan kita simpan sebagai `userdata` di Lua. `userdata` memberi ruang byte yang dikelola GC Lua.

### checkVector3D

```c
static Vector3D *checkVector3D(lua_State *L, int idx) {
  return (Vector3D *) luaL_checkudata(L, idx, VEC3_MT);
}
```

* `luaL_checkudata` memeriksa bahwa value pada `idx` adalah userdata yang memiliki metatable dengan nama `VEC3_MT`.
* Jika bukan, ia akan memicu error (luaL\_error) — memudahkan validasi tipe argumen pada C API.
* **Stack**: fungsi membaca dari stack; tidak mengubahnya (kecuali bila `luaL_checkudata` menghasilkan error). ([lua.org][5])

### Constructor `vector_new`

```c
double x = luaL_optnumber(L, 1, 0.0);
...
Vector3D *v = (Vector3D *) lua_newuserdata(L, sizeof(Vector3D));
v->x = x; ...
luaL_getmetatable(L, VEC3_MT);
lua_setmetatable(L, -2);
return 1;
```

* `luaL_optnumber(L,1,0.0)` membaca argumen pertama jika ada, atau 0.0 bila nil (opsional).
* `lua_newuserdata` mendorong (push) sebuah userdata baru ke stack dan mengembalikan pointer ke memorynya. Jadi setelah pemanggilan, top of stack adalah userdata.
* `luaL_getmetatable(L, VEC3_MT)` mendorong metatable (yang dibuat saat `luaopen_vector3d`) ke stack.
* `lua_setmetatable(L, -2)` meng-set metatable untuk userdata (objek pada indeks -2). Setelah `setmetatable`, userdata tetap di top stack.
* `return 1` memberi tahu Lua bahwa 1 nilai dikembalikan (userdata) — **sangat penting**: jumlah return harus sesuai jumlah value yang dipush ke stack.

### Metamethod `__tostring`

```c
Vector3D *v = checkVector3D(L, 1);
lua_pushfstring(L, "(%g, %g, %g)", v->x, v->y, v->z);
return 1;
```

* Dipanggil ketika `print(obj)` atau `tostring(obj)` dijalankan.
* `lua_pushfstring` mendorong string hasil format ke stack. Kembalikan 1.

### `__add`, `__sub`

* Kedua fungsi sama pola: ambil dua userdata (`checkVector3D`), buat userdata hasil baru dengan `lua_newuserdata`, set metatable, return 1.
* **Catatan**: kita mengembalikan userdata baru; caller di Lua menerima objek baru, hasil penjumlahan.

### `__mul` (lebih kompleks)

```c
if (lua_isnumber(L, 1) && luaL_testudata(L, 2, VEC3_MT)) { ... }
else if (lua_isnumber(L, 2) && luaL_testudata(L, 1, VEC3_MT)) { ... }
else { /* vector * vector -> dot */ ... }
```

* Karena operator `*` boleh dipanggil pada berbagai kombinasi (number × vector, vector × number, vector × vector) kita cek tipe operand secara berurutan.
* `luaL_testudata` memeriksa tanpa melempar error (mengembalikan NULL jika bukan), memudahkan narrow-check.
* Untuk skalar×vektor/vektor×skalar: hasil adalah userdata vektor baru (scale).
* Untuk vektor×vektor: hasilnya `lua_pushnumber` (dot product). **Perhatikan**: metamethod dapat mengembalikan *tipe berbeda* (userdata vs number) — ini sah tapi harus konsisten digunakan oleh program.

### `__eq`

* Melakukan perbandingan komponen (kondisi ketat `==` pada double). Mengembalikan boolean (`lua_pushboolean`).

### Methods: `magnitude`, `normalize`

* `vector_magnitude` membaca userdata di index 1 (metode dipanggil sebagai `obj:magnitude()` jadi `self` berada di posisi 1). Hitung sqrt dan `lua_pushnumber` hasilnya. Return 1.
* `vector_normalize` membuat userdata baru (hasil) dan kembalikan (tidak memodifikasi self).

**Catatan tentang metode**: dalam Lua, pemanggilan `obj:method()` sebenarnya memanggil `method(obj, ...)` — sehingga implementasi C mengasumsikan argumen pertama adalah userdata.

### Registrasi fungsi dan entry point `luaopen_vector3d`

```c
luaL_newmetatable(L, VEC3_MT);           // stack: mt
luaL_setfuncs(L, vector_metamethods, 0); // register __tostring,__add,...
lua_pushvalue(L, -1);                    // duplicate metatable
lua_setfield(L, -2, "__index");          // mt.__index = mt
luaL_setfuncs(L, vector_methods, 0);
luaL_newlib(L, vectorlib);
return 1;
```

* `luaL_newmetatable` membuat (atau mengambil jika sudah ada) tabel metatable dan menaruhnya di stack.
* `luaL_setfuncs` mendaftarkan fungsi C (array `luaL_Reg`) ke tabel pada top stack — metamethods (`__add`, dsb.) disimpan di metatable.
* Men-set `mt.__index = mt` membuat cara kerja metode: saat `obj:method()` dipanggil dan key tidak ada di userdata, Lua mencari di metatable.\_\_index; karena kita meletakkan method function di metatable, objek akan menemukan methodnya. Ini pola umum OOP di C-Lua binding.
* `luaL_setfuncs(L, vector_methods, 0)` juga menaruh method functions (seperti `magnitude`) ke metatable, sehingga `obj:magnitude` bisa ditemukan.
* `luaL_newlib(L, vectorlib)` membuat table modul (dengan constructor `new`) dan mengembalikannya. Karena `luaopen_vector3d` mendorong modul di stack top, `return 1` mengembalikan modul ke pemanggil `require`.

**Perilaku akhir**:

* Saat `require("vector3d")` dipanggil, Lua memanggil `luaopen_vector3d` (nama function harus `luaopen_<modulename>`). Fungsi ini mengembalikan table modul yang berisi `new`. Pengguna melakukan `Vec3 = require("vector3d")` dan memanggil `Vec3.new(1,2,3)`.

---

## 5) Prasyarat & apa yang perlu Anda siapkan untuk **mengembangkan / memodifikasi** modul ini

Minimal:

* **Pengetahuan**: Bahasa C (pointer, struct), dasar build tool (gcc/make), dan dasar Lua (fungsi, metatable, userdata).
* **Tooling**:

  * GCC/clang (compiler), `make` (opsional).
  * Paket `lua` dan header development (di beberapa distro: `lua` + `lua-devel` atau `lua5.4` package).
  * `pkg-config` (opsional, sangat membantu) atau cek path header `/usr/include/lua5.x`.
* **Untuk debugging**:

  * `lua` interpreter (untuk menjalankan `main.lua`), dan `gdb`/`valgrind` bila debug memory/misal.
* **Untuk Windows**: gunakan Mingw-w64 atau MSVC, dan sesuaikan opsi pembuatan `.dll`. Instruksi berbeda; saya dapat tuliskan bila diperlukan.

Ringkasan perintah instalasi contoh (Arch Linux):

```bash
sudo pacman -S base-devel lua
# jika perlu pkgconfig:
sudo pacman -S pkgconf
```

---

## 6) Tips debugging & common pitfalls

* **Versi Lua mismatch**: modul yang dikompilasi terhadap Lua 5.4 tidak akan cocok dengan interpreter Lua 5.1/5.3. Pastikan versi header & library cocok.
* **Linker errors**: jika `undefined reference to luaL_newlib` dll → link against correct `liblua` (lihat `-llua` vs `-llua5.4`). Gunakan `pkg-config` bila tersedia. ([Stack Overflow][1])
* **Jumlah return value**: setiap fungsi C harus `return N` sesuai jumlah nilai yang dipush ke stack. Salah hitung menghancurkan stack dan menimbulkan crash.
* **Memory**: userdata dikelola oleh GC Lua; jangan `free()` sendiri.
* **Type-check**: gunakan `luaL_checkudata` / `luaL_checknumber` untuk validasi sebelum operasi. Ini mencegah crash.

---

## 7) Sumber & bacaan resmi (penting)

* **Lua 5.4 Reference Manual — C API** (dokumen resmi). ([lua.org][4])
* **Programming in Lua — C API overview & examples** (Roberto Ierusalimschy). ([lua.org][5])
* **lua-users.org — Building Modules** (petunjuk platform/Makefile & contoh). ([lua-users.org][2])

---

## 8) Tes cepat (cek modul berjalan)

1. Kompilasi `vector3d.so` (lihat bagian 3).
2. Tempatkan `vector3d.so` + `main.lua` di satu folder.
3. Jalankan:

```bash
lua main.lua
```

4. Harusnya tampil output sesuai operasi (tostring, add, mul, magnitude, normalize).

---

<!--
## 9) Jika Anda ingin saya lakukan selanjutnya (opsional pilihan praktis)

* Saya dapat menyediakan **Makefile** siap pakai untuk Arch Linux / Linux umum.
* Saya dapat membuat **wrapper Lua** yang menambahkan factory functions (mis. `from_table`, `to_table`) dan dokumentasi API.
* Saya dapat menulis **instruksi Windows (MSVC/Mingw)** bila Anda butuh build cross-platform.
* Saya bisa menambahkan **cross product**, indexing (`__index` untuk 'x','y','z' via string keys), atau menambahkan **metamethod `__len`** dll.

---

Jika Anda mau, saya akan segera:

* (A) Buat **Makefile** dan file `README.build` untuk proyek ini (Arch Linux + fallback), **atau**
* (B) Tambahkan fitur: **cross product** & **index accessor** (`v.x` dan `v["x"]`) lalu bedah kode tambahan tersebut.

Pilih salah satu dari kata berikut supaya saya langsung kerjakan (jawab satu kata saja):

* `makefile` — saya buatkan Makefile + instruksi build lengkap.
* `cross` — saya tambahkan cross-product + indexing (`__index` override) dan jelaskan kodenya.
-->

[1]: https://stackoverflow.com/questions/52674554/how-do-i-compile-code-that-uses-lua-5-1s-c-api?utm_source=chatgpt.com "How do I compile code that uses Lua 5.1's C API? - Stack Overflow"
[2]: https://lua-users.org/wiki/BuildingModules?utm_source=chatgpt.com "lua-users wiki: Building Modules"
[3]: https://www.linuxfromscratch.org/blfs/view/11.1/general/lua52.html?utm_source=chatgpt.com "Lua-5.2.4 - Linux From Scratch!"
[4]: https://www.lua.org/manual/5.4/manual.html?utm_source=chatgpt.com "Lua 5.4 Reference Manual"
[5]: https://www.lua.org/pil/24.1.html?utm_source=chatgpt.com "Programming in Lua : 24.1 - Lua.org"

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-9/README.md
[selanjutnya]: ../bagian-11/README.md

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
