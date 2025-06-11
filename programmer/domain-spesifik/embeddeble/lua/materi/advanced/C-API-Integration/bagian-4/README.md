Setelah menguasai tipe-tipe data primitif, kita sekarang siap untuk memasuki ranah yang paling kuat dan fleksibel dalam ekosistem Lua. Bagian ini akan membahas struktur data yang menjadi tulang punggung hampir semua program Lua, serta mekanisme canggih untuk memperluas fungsionalitasnya dan mengintegrasikan data C secara langsung.

# **[Bagian IV: Struktur Data Kompleks][0]**

Di sinilah kekuatan sejati Lua sebagai bahasa yang dapat ditanamkan mulai bersinar. Kita akan belajar tentang tabel, struktur data universal Lua, dan kemudian metatable yang memungkinkan kita mengubah perilakunya. Terakhir, kita akan membahas userdata, jembatan langsung untuk membawa data C Anda ke dalam dunia Lua.

---

### **Bagian IV, Topik 11 & 12: Table Creation, Manipulation, dan Array Operations**

Di Lua, hanya ada satu struktur data: **tabel**. Namun, tabel ini sangat serbaguna. Ia bisa berfungsi sebagai kamus (dictionary/hash map), larik (array), atau bahkan sebagai dasar untuk membuat objek. Sebuah tabel adalah kumpulan pasangan kunci-nilai (key-value pairs).

#### **Membuat dan Mengisi Tabel dari C**

1.  **Membuat Tabel Baru**:
    `void lua_newtable (lua_State *L);`
    Fungsi ini membuat sebuah tabel kosong baru dan mendorongnya ke puncak stack.

2.  **Mengisi Field Tabel**: Ada beberapa cara untuk mengisi tabel dari C, setelah tabel tersebut berada di stack.
    - **Cara Mudah (untuk key string)**: `lua_setfield(L, table_index, "key");`
      Fungsi ini mengambil nilai dari puncak stack dan menetapkannya ke _field_ dengan nama `"key"` di dalam tabel yang berada pada `table_index`. Nilai tersebut di-pop dari stack.
    - **Cara Umum (untuk key apa pun)**: `lua_settable(L, table_index);`
      Ini lebih fleksibel. Alur kerjanya:
      1.  Pastikan tabel ada di `table_index`.
      2.  Push _key_ ke stack.
      3.  Push _value_ ke stack.
      4.  Panggil `lua_settable`. Fungsi ini akan mem-pop _key_ dan _value_, lalu melakukan penetapan `tabel[key] = value`.
    - **Cara Cepat (untuk key integer/array)**: `lua_seti(L, table_index, i);`
      Ini adalah versi `lua_settable` yang dioptimalkan untuk kunci integer. Ia mem-pop nilai dari puncak stack dan menetapkannya ke `tabel[i]`.

#### **Membaca Field Tabel dari C**

Sama seperti mengisi, ada beberapa cara untuk membaca data dari tabel. Operasi ini akan mendorong nilai yang ditemukan ke puncak stack.

- **Cara Mudah (untuk key string)**: `int lua_getfield (lua_State *L, int table_index, const char *key);`
- **Cara Umum (untuk key apa pun)**: `int lua_gettable (lua_State *L, int table_index);`
- **Cara Cepat (untuk key integer/array)**: `int lua_geti (lua_State *L, int table_index, lua_Integer i);`

#### **Melakukan Iterasi pada Tabel**

- **Iterasi Gaya Array**: Jika tabel Anda digunakan sebagai array (kunci 1, 2, 3, ...), cara termudah adalah dengan perulangan `for` standar.

  1.  Dapatkan panjang array dengan `luaL_len(L, table_index)`.
  2.  Lakukan loop dari 1 hingga panjang tersebut.
  3.  Di dalam loop, gunakan `lua_geti()` untuk mendapatkan elemen.
  4.  **Penting**: `pop` elemen tersebut setelah diproses agar stack tetap bersih.

- **Iterasi Umum (Key-Value)**: Untuk mengiterasi semua pasangan key-value, gunakan `lua_next()`.
  `int lua_next (lua_State *L, int table_index);`
  Alur kerjanya sedikit rumit:
  1.  Push `nil` ke stack sebagai _key_ awal untuk memulai iterasi.
  2.  Panggil `lua_next()` di dalam sebuah `while` loop.
  3.  `lua_next()` akan mem-pop key dari iterasi sebelumnya, dan mendorong _key_ dan _value_ berikutnya.
  4.  Jika `lua_next()` mengembalikan 0, iterasi selesai.
  5.  Di dalam loop, Anda memiliki key di `stack[-2]` dan value di `stack[-1]`.
  6.  **Penting**: Pop _value_ (`lua_pop(L, 1)`) tetapi biarkan _key_ untuk iterasi berikutnya.

#### **Contoh Kode: Membuat dan Membaca Tabel**

```c
// table_example.c
#include <stdio.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

int main(void) {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    // 1. Membuat dan mengisi tabel
    lua_newtable(L); // Tabel sekarang di indeks -1

    // Mengisi dengan lua_setfield
    lua_pushstring(L, "John Doe");
    lua_setfield(L, -2, "name"); // t.name = "John Doe"

    // Mengisi dengan lua_seti (gaya array)
    lua_pushstring(L, "Apple");
    lua_seti(L, -2, 1); // t[1] = "Apple"
    lua_pushstring(L, "Banana");
    lua_seti(L, -2, 2); // t[2] = "Banana"

    // 2. Membaca dari tabel
    printf("--- Reading from table ---\n");
    lua_getfield(L, -1, "name");
    printf("Name: %s\n", lua_tostring(L, -1));
    lua_pop(L, 1); // Bersihkan stack

    // 3. Iterasi gaya array
    printf("\n--- Array-style iteration ---\n");
    lua_Integer len = luaL_len(L, -1);
    for (lua_Integer i = 1; i <= len; i++) {
        lua_geti(L, -1, i);
        printf("  t[%lld] = %s\n", i, lua_tostring(L, -1));
        lua_pop(L, 1);
    }

    // 4. Iterasi umum (key-value)
    printf("\n--- Generic key-value iteration ---\n");
    lua_pushnil(L); // Key awal
    while (lua_next(L, -2) != 0) {
        // key ada di -2, value di -1
        printf("  t['%s'] = '%s'\n",
               lua_tostring(L, -2),
               lua_tostring(L, -1));
        lua_pop(L, 1); // Pop value, biarkan key untuk iterasi berikutnya
    }

    lua_close(L);
    return 0;
}
```

#### **Sumber Referensi:**

- **Buku "Programming in Lua"**: [Chapter 25 – A First Example](https://www.lua.org/pil/25.html)
- **Referensi Tambahan**: [Lua-Users Wiki - Tables Tutorial](http://lua-users.org/wiki/TablesTutorial)

---

### **Bagian IV, Topik 13: Metatable dan Metamethods**

Ini adalah salah satu fitur paling kuat di Lua. **Metatable** adalah sebuah tabel biasa yang propertinya (disebut **metamethods**) mendefinisikan perilaku tabel lain saat operasi tertentu dilakukan padanya. Ini adalah cara Lua melakukan _operator overloading_ dan implementasi OOP.

#### **Metamethods Kunci**

- `__index`: Dipicu saat Anda mencoba mengakses field yang `nil` pada sebuah tabel. Ini bisa berupa:
  - **Sebuah tabel lain**: Lua akan mencari field tersebut di tabel ini (dasar untuk pewarisan/prototyping).
  - **Sebuah fungsi**: Fungsi ini akan dipanggil dengan tabel dan key sebagai argumen.
- `__newindex`: Dipicu saat Anda mencoba memberi nilai pada field yang `nil`.
- `__call`: Memungkinkan sebuah tabel untuk dipanggil seperti fungsi `t(...)`.
- `__tostring`: Mengontrol output saat `tostring(t)` dipanggil pada tabel.
- `__add`, `__sub`, `__mul`, dll.: Untuk _overloading_ operator aritmetika.

#### **Mengatur Metatable dari C**

- `int lua_setmetatable (lua_State *L, int obj_index);`: Mem-pop sebuah tabel dari puncak stack dan menetapkannya sebagai metatable untuk objek di `obj_index`.
- `int luaL_newmetatable (lua_State *L, const char *tname);`: Fungsi pembantu yang sangat berguna. Ia membuat metatable baru, menyimpannya di _registry_ Lua dengan nama `tname` (agar tidak dibuat ulang), dan mendorongnya ke stack. Ini adalah cara standar untuk membuat metatable untuk tipe data kustom.

#### **Sumber Referensi:**

- **Buku "Programming in Lua"**: [Chapter 13 – Metatables and Metamethods](https://www.lua.org/pil/13.html)
- **Referensi Tambahan**: [Lua-Users Wiki - Metatable Events](http://lua-users.org/wiki/MetatableEvents)

---

### **Bagian IV, Topik 14: Userdata dan Light Userdata**

Bagaimana cara membawa data C (seperti `struct` atau pointer) ke dalam Lua? Jawabannya adalah **userdata**.

#### **Full Userdata**

Ini adalah blok memori mentah yang dialokasikan oleh Lua dan dikelola oleh _garbage collector_ Lua. Lua tidak tahu apa isinya, tapi ia tahu cara mengelola memorinya.

- **Pembuatan**: `void *lua_newuserdata (lua_State *L, size_t size);`
  Fungsi ini mengalokasikan memori sebesar `size` byte, mendorong objek userdata ke stack, dan mengembalikan pointer `void*` ke blok memori tersebut ke C. Anda bisa meng-cast pointer ini ke tipe `struct` Anda.
- **Wajib Memiliki Metatable**: Userdata mentah tidak berguna. Anda harus memberinya metatable untuk mendefinisikan perilakunya (`__index` untuk metode, `__gc` untuk pembersihan, dll.).
- **Garbage Collection (`__gc`)**: Jika metatable userdata memiliki metamethod `__gc`, fungsi tersebut akan dipanggil tepat sebelum _garbage collector_ Lua membebaskan memori userdata. Ini memberi Anda kesempatan untuk melakukan pembersihan di sisi C (misalnya, `free()` memori lain, menutup file handle).

#### **Light Userdata**

Ini hanyalah sebuah nilai pointer `void*`.

- **Pembuatan**: `void lua_pushlightuserdata (lua_State *L, void *p);`
- **Perbedaan Kunci**:
  - **Bukan Memori**: Light userdata hanyalah sebuah pointer, bukan blok memori yang dikelola Lua.
  - **Tidak Ada `__gc`**: Karena tidak dikelola oleh _garbage collector_, tidak ada `__gc`. Anda bertanggung jawab penuh atas masa pakai memori yang ditunjuk oleh pointer tersebut.
  - **Ringan**: Tidak ada overhead. Cocok untuk merepresentasikan handle atau ID sederhana yang dikelola di tempat lain.

#### **Contoh Singkat OOP dengan Userdata**

Ini adalah pola yang sangat umum:

1.  Buat `struct` di C (mis. `Vector { double x, y; }`).
2.  Buat C functions untuk `new`, `add`, `tostring`, dll.
3.  Di C, buat metatable menggunakan `luaL_newmetatable`.
4.  Buat tabel metode (methods table) di C.
5.  Isi tabel metode dengan C functions Anda (`add`, `tostring`).
6.  Set `__index` dari metatable ke tabel metode ini.
7.  Set `__gc` dan metamethod lain (`__add`, `__tostring`) di metatable.
8.  Fungsi `new` Anda akan memanggil `lua_newuserdata`, mengisi `struct`-nya, dan menggunakan `lua_setmetatable` untuk menempelkan metatable yang sudah disiapkan.

#### **Sumber Referensi:**

- **Buku "Programming in Lua"**: [Chapter 28 – User-Defined Types in C](https://www.lua.org/pil/28.html)
- **Referensi Tambahan**: [Lua-Users Wiki - UserData With Pointer](http://lua-users.org/wiki/UserDataWithPointer)

---

Dengan menguasai tabel, metatable, dan userdata, Anda kini memiliki semua alat yang diperlukan untuk membuat abstraksi tingkat tinggi yang kuat. Anda dapat menciptakan "objek" di C dan membuatnya terlihat dan berfungsi seperti objek Lua asli, lengkap dengan metode, operator, dan manajemen memori otomatis.

Selanjutnya, kita akan beralih ke **Bagian V: Function Calls dan Execution**, di mana kita akan fokus pada seluk-beluk memanggil fungsi bolak-balik antara kedua bahasa.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

<!----------------------------------------------------->

[0]: ../README.md#bagian-iv-struktur-data-kompleks
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
