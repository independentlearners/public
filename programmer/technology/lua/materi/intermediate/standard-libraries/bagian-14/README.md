<!--
<details>
  <summary>📃 Daftar Isi</summary>

</details>

Baik, kita masuk ke **Modul 14: Struktur Data & Array Processing dengan LuaJIT FFI**.

-->

# **[Modul 14 – Struktur Data & Array Processing dengan FFI][0]**

### Deskripsi & Peran

* Pada modul sebelumnya kita membangun **binding C buatan sendiri** (math & string).
* Modul ini melangkah lebih jauh: **mengelola struktur data (array, struct) langsung dari C di dalam Lua** dengan FFI.
* Peran dalam kurikulum: melatih efisiensi memory & pemahaman bagaimana data diwakili di level rendah.
* Filosofi: dengan FFI, kita tidak hanya bisa memanggil fungsi, tapi juga bisa **mengelola memory seolah-olah kita sedang coding C**, namun tetap dari Lua.

---

## Mini Proyek: Array Dinamis (Dynamic Array)

Struktur:

```
libarray.c       → Implementasi array di C
libarray.h       → Header
array_bind.lua   → Binding Lua
array_demo.lua   → Demo pemakaian
```

---

### File `libarray.c`

```c
// libarray.c
#include "libarray.h"
#include <stdlib.h>
#include <string.h>

struct DynArray {
    int *data;
    size_t size;
    size_t capacity;
};

DynArray* da_new(size_t capacity) {
    DynArray* arr = (DynArray*)malloc(sizeof(DynArray));
    arr->data = (int*)malloc(capacity * sizeof(int));
    arr->size = 0;
    arr->capacity = capacity;
    return arr;
}

void da_free(DynArray* arr) {
    free(arr->data);
    free(arr);
}

void da_push(DynArray* arr, int value) {
    if (arr->size >= arr->capacity) {
        arr->capacity *= 2;
        arr->data = (int*)realloc(arr->data, arr->capacity * sizeof(int));
    }
    arr->data[arr->size++] = value;
}

int da_get(DynArray* arr, size_t index) {
    if (index >= arr->size) return -1; // sederhana: error code
    return arr->data[index];
}

size_t da_size(DynArray* arr) {
    return arr->size;
}
```

---

### File `libarray.h`

```c
// libarray.h
#ifndef LIBARRAY_H
#define LIBARRAY_H

#include <stddef.h>

typedef struct DynArray DynArray;

DynArray* da_new(size_t capacity);
void da_free(DynArray* arr);
void da_push(DynArray* arr, int value);
int da_get(DynArray* arr, size_t index);
size_t da_size(DynArray* arr);

#endif
```

---

### Kompilasi

Linux:

```bash
gcc -shared -fPIC -o libarray.so libarray.c
```

Windows:

```bash
gcc -shared -o libarray.dll libarray.c
```

---

### File `array_bind.lua`

```lua
local ffi = require("ffi")

ffi.cdef[[
typedef struct DynArray DynArray;

DynArray* da_new(size_t capacity);
void da_free(DynArray* arr);
void da_push(DynArray* arr, int value);
int da_get(DynArray* arr, size_t index);
size_t da_size(DynArray* arr);
]]

local lib = ffi.load("./libarray.so")

local M = {}

-- wrapper
function M.new(capacity)
  local arr = lib.da_new(capacity)
  return ffi.gc(arr, lib.da_free) -- otomatis free
end

M.push = lib.da_push
M.get  = lib.da_get
M.size = lib.da_size

return M
```

---

### File `array_demo.lua`

```lua
local array = require("array_bind")

-- buat array kapasitas awal 2
local arr = array.new(2)

array.push(arr, 10)
array.push(arr, 20)
array.push(arr, 30)

print("Array size:", array.size(arr))
print("Index 0:", array.get(arr, 0))
print("Index 1:", array.get(arr, 1))
print("Index 2:", array.get(arr, 2))
```

---

# Bedah Kode

### `libarray.c`

* `DynArray` menyimpan pointer `int *data`, jumlah elemen (`size`), kapasitas (`capacity`).
* `da_new` → alokasi awal.
* `da_free` → bebaskan memory.
* `da_push` → menambahkan elemen, resize otomatis bila penuh.
* `da_get` → ambil elemen pada indeks.
* `da_size` → kembalikan jumlah elemen.

### `libarray.h`

* Deklarasi fungsi agar bisa diakses FFI.

### `array_bind.lua`

* `ffi.cdef` mendeklarasikan struct & fungsi.
* `ffi.gc(arr, lib.da_free)` → otomatis memanggil `da_free` saat garbage collected.
* API Lua menjadi `array.new`, `array.push`, `array.get`, `array.size`.

### `array_demo.lua`

* Buat array kapasitas awal 2.
* Tambahkan 3 elemen → array otomatis resize ke 4.
* Cetak size dan isi array.

---

# Contoh Output

```
Array size: 3
Index 0: 10
Index 1: 20
Index 2: 30
```

---

# Visualisasi Alur

```
array_demo.lua
   │
   ▼
array_bind.lua
   │
   ▼
ffi.cdef → deklarasi struct & fungsi
   │
   ▼
ffi.load("./libarray.so")
   │
   ▼
da_new / da_push / da_get / da_size
   │
   ▼
DynArray (C) diakses dari Lua
```

---

# Praktik Terbaik

* Gunakan `ffi.gc` untuk mengelola memory otomatis.
* Selalu periksa error (misalnya `da_get` dengan indeks out-of-range).
* Mulai dari tipe sederhana (int), lalu bisa diperluas ke tipe kompleks (struct).

---

# Potensi Kesalahan

* Lupa `ffi.gc` → memory leak.
* `da_get` tanpa validasi → crash.
* Salah kompilasi (`-fPIC`) → library gagal diload.

---

📌 Dengan modul ini, Anda sudah bisa **membuat dan mengelola struktur data C (Dynamic Array) langsung dari Lua dengan FFI**.
<!--
Apakah Anda ingin saya tambahkan satu lagi contoh **binding struct yang lebih kompleks** (misalnya `struct Person` dengan field nama & umur), atau langsung kita gas ke **Modul 15**?
-->
# Binding `Person` (struct) — contoh binding struct yang lebih kompleks + penjelasan lengkap

Kita akan membuat library C kecil yang mendefinisikan `Person` (nama + umur), lalu memanggilnya dari LuaJIT melalui FFI. Semua kode akan dijelaskan **baris demi baris** — tujuan, fungsi, dan implikasi memori/keamanan akan dijelaskan.

---

## Ringkasan singkat sebelum mulai

* **Bahasa & teknologi**: library ditulis **C** (bahasa sistem, kompilasi ke `.so`/`.dll`), binding dilakukan dengan **LuaJIT FFI** (LuaJIT adalah implementasi Lua dengan JIT; FFI adalah fitur untuk memanggil C langsung).
* **Kenapa ini penting**: praktis untuk mengekspor objek/struktur kompleks dari C ke Lua, mengelola memori di tingkat C, dan menyediakan API yang lebih kaya untuk skrip Lua.
* **Yang harus dipersiapkan untuk mengembangkan lebih lanjut**: pengetahuan C (malloc/free, pointer, string), toolchain (gcc/clang), LuaJIT (runtime), debugging tools (gdb/valgrind), serta keterampilan memastikan kecocokan `ffi.cdef` dengan header C.

---

# 1) Kode C — `libperson.h` (header)

```c
// libperson.h
#ifndef LIBPERSON_H
#define LIBPERSON_H

#include <stddef.h>

typedef struct Person Person;

Person* person_new(const char* name, int age);
void person_free(Person* p);

const char* person_get_name(Person* p);   // pointer ke internal name (jangan free)
int person_get_age(Person* p);

void person_set_name(Person* p, const char* name); // mengganti name (meng-free lama, duplikat baru)
void person_set_age(Person* p, int age);

#endif // LIBPERSON_H
```

### Penjelasan `libperson.h` baris demi baris

* `#ifndef LIBPERSON_H` / `#define LIBPERSON_H` … `#endif`
  → **Include guard**: mencegah header didefinisikan dua kali saat kompilasi. Standar praktik C.
* `#include <stddef.h>`
  → menyertakan definisi tipe ukuran (`size_t`) bila diperlukan (di sini hanya safety).
* `typedef struct Person Person;`
  → deklarasi *incomplete type*; memberi nama tipe `Person` agar bisa dipakai sebagai pointer di API (encapsulation).
* `Person* person_new(const char* name, int age);`
  → deklarasi konstruktor: menerima string nama dan umur, mengembalikan pointer ke `Person` yang dialokasikan.
* `void person_free(Person* p);`
  → fungsi untuk membebaskan objek `Person`.
* `const char* person_get_name(Person* p);`
  → mengembalikan pointer ke buffer internal `name`. **Catatan**: ini menunjuk ke memori internal `Person` dan **tidak** boleh di-`free` oleh pemanggil.
* `int person_get_age(Person* p);`
  → mengembalikan umur.
* `void person_set_name(Person* p, const char* name);`
  → mengganti nama; implementasi harus **free** buffer lama lalu duplikat string baru.
* `void person_set_age(Person* p, int age);`
  → set umur.

> Tujuan header: mendefinisikan kontrak API supaya `ffi.cdef` di Lua bisa menirunya secara akurat.

---

# 2) Kode C — `libperson.c` (implementasi)

```c
// libperson.c
#include "libperson.h"
#include <stdlib.h>
#include <string.h>

struct Person {
    char* name; // pointer ke heap-allocated C string
    int age;
};

static char* dup_string(const char* s) {
    if (s == NULL) return NULL;
    size_t len = strlen(s);
    char* r = (char*)malloc(len + 1);
    if (r == NULL) return NULL;
    memcpy(r, s, len);
    r[len] = '\0';
    return r;
}

Person* person_new(const char* name, int age) {
    Person* p = (Person*)malloc(sizeof(Person));
    if (p == NULL) return NULL;
    p->name = dup_string(name ? name : "");
    p->age = age;
    return p;
}

void person_free(Person* p) {
    if (p == NULL) return;
    if (p->name) free(p->name);
    free(p);
}

const char* person_get_name(Person* p) {
    if (p == NULL) return NULL;
    return (const char*)p->name;
}

int person_get_age(Person* p) {
    if (p == NULL) return -1;
    return p->age;
}

void person_set_name(Person* p, const char* name) {
    if (p == NULL) return;
    if (p->name) {
        free(p->name);
        p->name = NULL;
    }
    p->name = dup_string(name ? name : "");
}

void person_set_age(Person* p, int age) {
    if (p == NULL) return;
    p->age = age;
}
```

### Penjelasan `libperson.c` baris demi baris

* `#include "libperson.h"`
  → sertakan deklarasi fungsi & tipe agar definisi sesuai header.
* `#include <stdlib.h>` dan `#include <string.h>`
  → `malloc`, `free`, `strlen`, `memcpy`.
* `struct Person { char* name; int age; };`
  → definisi struktur: `name` pointer ke C-string di heap; `age` int.
* `static char* dup_string(const char* s)`
  → helper lokal (static => internal linkage) untuk duplikasi string:

  * `if (s == NULL) return NULL;` → safety.
  * `size_t len = strlen(s);` → panjang.
  * `malloc(len + 1)` → alokasi memori +1 untuk `\0`.
  * `memcpy` salin isi.
  * `r[len] = '\0';` tambahkan terminator.
  * `return r;` kembalikan pointer baru yang caller harus `free`.
    → Alasan: jangan gunakan `strdup` (tidak standar di semua platform); implementasi portable ini aman.
* `Person* person_new(const char* name, int age)`
  → buat struct di heap:

  * `Person* p = malloc(sizeof(Person));` alokasi.
  * `if (p == NULL) return NULL;` cek kegagalan.
  * `p->name = dup_string(name ? name : "");` duplikasi nama; jika `name` NULL, gunakan empty string.
  * `p->age = age;` set umur.
  * `return p;`
* `void person_free(Person* p)`
  → bebaskan: jika `p==NULL` return; free `p->name` bila ada; free `p`.
  → Penting: pemanggil (Lua) harus memastikan `person_free` dipanggil setidaknya lewat finalizer atau manual.
* `const char* person_get_name(Person* p)`
  → jika `p==NULL` return NULL; else return `p->name`. Ini **pointer internal**; pemanggil harus menyalinnya jika ingin menyimpan lama.
* `int person_get_age(Person* p)`
  → jika `p==NULL` return -1; else return `p->age`.
* `void person_set_name(Person* p, const char* name)`
  → jika `p==NULL` return; free `p->name` jika ada; duplikat `name` via `dup_string` dan set ke `p->name`.
  → Alasan: menghindari kebocoran memori dan memastikan `p->name` selalu di-`malloc` yang cocok untuk `free`.
* `void person_set_age(Person* p, int age)`
  → set `p->age`.

> Catatan keamanan: fungsi melakukan pemeriksaan `NULL` untuk ketahanan. Namun jika `dup_string` gagal (malloc gagal) kita tidak memeriksa di semua tempat — untuk produksi, semua malloc harus diperiksa dan diperlakukan dengan benar.

---

# 3) Kompilasi library C

### Linux (contoh)

```bash
gcc -O2 -fPIC -shared -o libperson.so libperson.c
```

**Penjelasan opsi**

* `-O2` : optimisasi.
* `-fPIC` : buat kode posisi-independent (diperlukan untuk shared library).
* `-shared` : hasilkan shared object (.so).
* `-o libperson.so` : nama file output.

### Windows (MinGW)

```bash
gcc -O2 -shared -o libperson.dll libperson.c
```

> Pastikan path library berada di current directory atau `package.cpath`/`PATH` agar `ffi.load` dapat menemukannya.

---

# 4) Binding Lua (LuaJIT FFI) — `person_bind.lua`

```lua
-- person_bind.lua
local ffi = require("ffi")

ffi.cdef[[
typedef struct Person Person;

Person* person_new(const char* name, int age);
void person_free(Person* p);

const char* person_get_name(Person* p);
int person_get_age(Person* p);

void person_set_name(Person* p, const char* name);
void person_set_age(Person* p, int age);
]]

-- load shared library (sesuaikan ekstensi pada Windows)
local lib = ffi.load("./libperson.so") -- atau "./libperson.dll"

local Person = {}   -- table pustaka
Person.__index = Person

-- constructor: mengembalikan "objek" Lua yang membungkus pointer C
function Person.new(name, age)
  local p = lib.person_new(name or "", age or 0)
  if p == nil then error("person_new gagal") end
  -- pasang finalizer supaya person_free dipanggil saat GC
  local managed = ffi.gc(p, lib.person_free)
  local obj = setmetatable({ cdata = managed }, Person)
  return obj
end

-- method get_name
function Person:get_name()
  local c = lib.person_get_name(self.cdata)
  if c == nil then return nil end
  return ffi.string(c) -- salin C-string ke Lua string
end

-- method get_age
function Person:get_age()
  return lib.person_get_age(self.cdata)
end

-- method set_name
function Person:set_name(newname)
  lib.person_set_name(self.cdata, newname)
end

-- method set_age
function Person:set_age(newage)
  lib.person_set_age(self.cdata, newage)
end

-- optional: destroy manual (jika ingin free sebelum GC)
function Person:free()
  -- lepaskan finalizer lalu panggil free manual
  local c = self.cdata
  if c ~= nil then
    ffi.gc(c, nil)         -- hapus finalizer
    lib.person_free(c)     -- free sekarang
    self.cdata = nil
  end
end

return Person
```

### Penjelasan `person_bind.lua` baris demi baris

* `local ffi = require("ffi")`
  → muat modul FFI (perlu dijalankan menggunakan `luajit`, bukan `lua` biasa).
* `ffi.cdef[[ ... ]]`
  → mendeklarasikan API C sesuai header `libperson.h`. Pastikan tanda tangan fungsi sama persis.

  * `typedef struct Person Person;` mendeklarasikan tipe nama `Person` agar `Person*` bisa digunakan.
  * Fungsi-fungsi lain dideklarasikan sama seperti header.
* `local lib = ffi.load("./libperson.so")`
  → load shared library. Gunakan `./libperson.dll` di Windows.
* `local Person = {}; Person.__index = Person`
  → kita membuat table `Person` yang akan berperan sebagai *class* / prototype untuk objek Lua.
* `function Person.new(name, age)`
  → konstruktor Lua (pattern OOP di Lua):

  * `local p = lib.person_new(name or "", age or 0)` memanggil fungsi C. `name or ""` memastikan string non-nil.
  * `if p == nil then error("person_new gagal") end` — safety check.
  * `local managed = ffi.gc(p, lib.person_free)` — *kunci penting*:

    * `ffi.gc(cdata, finalizer)` mendaftarkan finalizer untuk cdata `p`. Saat `managed` tidak lagi dirujuk (GC), finalizer `lib.person_free` akan dipanggil.
    * Jadi kita tidak perlu memanggil `person_free` secara manual kecuali ingin.
  * `local obj = setmetatable({ cdata = managed }, Person)`:

    * Kita buat tabel Lua `obj` yang menyimpan `cdata` (pointer Person) dan set metatable `Person` sehingga `obj:method()` memanggil method pada `Person`.
  * `return obj` — mengembalikan objek Lua.
* `function Person:get_name()`

  * `local c = lib.person_get_name(self.cdata)` — memanggil C, mendapatkan `const char*` (pointer internal).
  * `if c == nil then return nil end`
  * `return ffi.string(c)` — *salin* C-string ke Lua string. Ini penting: `ffi.string` membuat salinan, sehingga setelah object di-free, string Lua tetap aman.
* `function Person:get_age()`

  * `return lib.person_get_age(self.cdata)` — langsung kembalikan integer.
* `function Person:set_name(newname)`

  * `lib.person_set_name(self.cdata, newname)` — panggil C untuk mengganti nama; implementasi C akan free buffer lama dan duplikat baru.
  * **Catatan**: `newname` adalah string Lua; FFI menyalin string ke buffer temporer untuk parameter `const char*` saat panggilan C.
* `function Person:set_age(newage)`

  * `lib.person_set_age(self.cdata, newage)`
* `function Person:free()` — manual destruction:

  * `ffi.gc(c, nil)` — batalkan finalizer (agar tidak double-free).
  * `lib.person_free(c)` — free sekarang.
  * `self.cdata = nil` — hilangkan referensi.
  * *Gunakan bila Anda ingin mengontrol waktu freed (mis. deterministik), namun berhati-hati terhadap penggunaan setelah freed.*
* `return Person` — modul mengembalikan table `Person` sebagai "class".

> Pola ini menghasilkan objek Lua yang mudah dipakai (`p = Person.new("Budi", 30); print(p:get_name())`), tetapi internals tetap pointer C yang dikelola oleh FFI + finalizer.

---

# 5) Demo penggunaan — `person_demo.lua`

```lua
local Person = require("person_bind")

local p = Person.new("Andi", 28)
print("Name:", p:get_name())
print("Age :", p:get_age())

p:set_age(29)
p:set_name("Andi Pratama")

print("After update - Name:", p:get_name())
print("After update - Age :", p:get_age())

-- contoh free manual (opsional)
p:free()

-- setelah free, jangan lagi akses p:get_name() (akan error / segfault)
```

### Penjelasan `person_demo.lua`

* `local Person = require("person_bind")` → muat binding.
* `local p = Person.new("Andi", 28)` → buat object; di balik layar allocate Person\* di C.
* `p:get_name()` / `p:get_age()` → panggil method.
* `p:set_age(29)` / `p:set_name(...)` → set values (panggilan ke C).
* `p:free()` → manual free; setelah ini `p.cdata` = `nil`, method menggunakan `self.cdata` akan gagal.

---

# 6) Hal-hal teknis, praktek terbaik dan potensi masalah (penting)

### Manajemen memori

* Kita memakai `ffi.gc(p, lib.person_free)` sehingga `person_free` akan dijalankan saat GC. Ini memudahkan, tetapi:

  * **GC tidak deterministik** — free akan terjadi saat GC berjalan; jika Anda butuh free segera (mis. file handle), gunakan `obj:free()` manual.
  * Jika Anda memanggil `obj:free()` manual, batalkan finalizer terlebih dahulu (`ffi.gc(c, nil)`) untuk menghindari **double free**.
* Untuk fungsi yang mengembalikan pointer internal (`person_get_name`) kita menyalinnya ke Lua string via `ffi.string` — metode ini aman karena string Lua adalah copy.

### Keamanan `ffi.cdef`

* `ffi.cdef` harus cocok persis dengan header — **tipe**, urutan parameter, dan return type harus sama. Jika tidak cocok -> segfault atau perilaku undefined.

### Portabilitas

* Nama library (`"./libperson.so"` vs `"libperson"` vs `.dll`) dan cara load berbeda antar OS. Di Linux gunakan `.so`; di macOS biasanya `.dylib`; di Windows `.dll`.

### Pengetahuan yang disarankan (agar dapat memodifikasi)

* Bahasa C: struktur, malloc/free, pointer, string handling.
* Lua & LuaJIT: cara FFI bekerja, metamethod, `ffi.gc`, `ffi.string`.
* Build toolchain: gcc/clang, `-fPIC`, shared lib linking.
* Debugging: `gdb`, `valgrind` (memory leak), cara membaca core dump.
* Jika ingin membuat binding besar: `pkg-config`, `cmake`, atau `meson` untuk manajemen build.

### Kesalahan umum & solusi cepat

* **Segfault saat akses setelah free**: pastikan tidak memakai `self.cdata` setelah `free()`; set `self.cdata = nil`.
* **Double-free**: jangan panggil `person_free` manual jika Anda masih memakai finalizer; hapus finalizer sebelum free manual (`ffi.gc(c, nil)`).
* **ffi.load gagal**: periksa path & nama library; `ldd libperson.so` periksa dependensi; di Linux, pastikan `libperson.so` ada di working directory atau LD\_LIBRARY\_PATH.
* **Salah `ffi.cdef`**: cocokkan header; gunakan fungsi minimal dulu, lalu tambah fungsi bertahap sehingga lebih mudah debugging.

---

# 7) Cara menjalankan (ringkasan langkah)

1. Kompilasi library:

   ```bash
   gcc -O2 -fPIC -shared -o libperson.so libperson.c
   ```
2. Jalankan demo menggunakan LuaJIT:

   ```bash
   luajit person_demo.lua
   ```

   (Pastikan `person_bind.lua`, `person_demo.lua`, `libperson.so` berada dalam direktori yang sama.)

---

# 8) Persyaratan & apa yang perlu Anda persiapkan untuk memodifikasi binding ini (sesuai permintaan profil Anda)

**Identitas teknologi lengkap**:

* Library C: **ditulis dalam bahasa C** (ISO C), menggunakan `malloc`/`free`, `string.h`.
* Binding: **LuaJIT FFI** (bagian dari LuaJIT, yang sendiri ditulis dalam C). FFI menyediakan fungsi `ffi.cdef`, `ffi.load`, `ffi.new`, `ffi.gc`, `ffi.string`.
* Runtime: **luajit** (bukan lua resmi) — jalankan `luajit` untuk script ini.

**Hal yang harus Anda kuasai / siapkan**:

* Bahasa C: pointer, alokasi memori, string management, header/implementation separation.
* Alat: `gcc` atau `clang`, akses terminal, editor (Anda sebut pakai Helix/neovim — cocok).
* LuaJIT terinstal: `luajit` di PATH.
* Tools debugging: `gdb`, `valgrind` (opsional tapi dianjurkan).
* Keterampilan praktis: bagaimana `ffi.cdef` harus mencerminkan header C; bagaimana mencegah double-free; kapan menggunakan `ffi.gc`.

---

# 9) Contoh output yang diharapkan saat menjalankan `person_demo.lua`

```
Name: Andi
Age : 28
After update - Name: Andi Pratama
After update - Age : 29
```

Jika `p:free()` dipanggil, lalu mencoba mengakses p lagi => kemungkinan error/segfault. Jangan akses setelah free.

---

<!--
# Penutup singkat dan langkah berikutnya

Saya telah membuat dan menjelaskan **lengkap** binding struct `Person` — dari header (`.h`), implementasi (`.c`), cara kompilasi, binding Lua (`person_bind.lua`), sampai demo (`person_demo.lua`). Semua baris kode telah dibedah dan tujuan/fungsinya dijelaskan.

Jika Anda siap, kita bisa **lanjut ke Modul 15** (mis. optimisasi berkelanjutan, profiling native-bound code, atau topik lain yang Anda tentukan).
Ketik satu kata pilihan Anda: `modul15` untuk lanjut, atau `ulangi` jika Anda ingin saya ulang penjelasan bagian tertentu (sebut nama file atau fungsi).
-->
> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-13/README.md
[selanjutnya]: ../bagian-15/README.md

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
