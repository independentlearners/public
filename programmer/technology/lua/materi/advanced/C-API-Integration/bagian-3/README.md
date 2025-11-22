Kita telah menguasai mekanisme dasar stack dan cara menangani error. Sekarang, kita akan mendalami detail penanganan tipe-tipe data primitif yang menjadi fondasi dari setiap skrip Lua. Bagian ini akan membahas nuansa dan praktik terbaik saat bekerja dengan string, angka, boolean, dan nil dari C.

# **[Bagian III: Interaksi Data Fundamental][1]**

Di bagian ini, kita akan menerapkan keterampilan manipulasi stack dari Bagian II untuk berinteraksi dengan tipe data spesifik. Memahami bagaimana C API menangani setiap tipe data, terutama terkait manajemen memori dan konversi, sangatlah krusial untuk mencegah bug.

---

### **Bagian III, Topik 8: String Manipulation**

String adalah salah satu tipe data yang paling sering berpindah tangan antara C dan Lua. Penanganan memori yang benar adalah kunci di sini.

#### **Mendorong dan Mengambil String**

* **Pushing:**
    * `lua_pushstring(L, const char *s)`: Untuk string C standar yang diakhiri dengan `\0`.
    * `lua_pushlstring(L, const char *s, size_t len)`: Untuk string dengan panjang yang ditentukan. Ini lebih aman dan efisien jika Kita sudah tahu panjangnya, dan **wajib** digunakan jika string Kita mungkin mengandung karakter `\0` (data biner).

* **Getting:**
    * `lua_tostring(L, index)`: Mengembalikan string dari stack.
    * `lua_tolstring(L, index, size_t *len)`: Mengembalikan string dan juga menuliskan panjangnya ke pointer `len`. Ini adalah pasangan dari `lua_pushlstring`.

#### **Manajemen Memori String: Aturan Emas**

1.  **Lua Mengelola Memorinya Sendiri**: Saat Kita memanggil `lua_pushstring`, Lua akan membuat **salinan internal** dari string tersebut. Artinya, setelah fungsi dipanggil, Kita bebas memodifikasi atau membebaskan buffer string asli di sisi C. Lua tidak lagi membutuhkannya.
2.  **Jangan Modifikasi Pointer dari Lua**: Saat Kita memanggil `lua_tostring`, Kita mendapatkan sebuah pointer ke memori internal Lua. Kita **dilarang keras** memodifikasi isi dari pointer ini.
3.  **Masa Pakai Pointer Terbatas**: Pointer yang dikembalikan oleh `lua_tostring` hanya dijamin valid selama nilai string tersebut masih ada di stack pada posisi tersebut. Begitu Kita melakukan `pop` pada nilai itu, pointer tersebut bisa menjadi tidak valid (*dangling pointer*). **Praktik terbaik**: Dapatkan pointer, gunakan segera, lalu lupakan. Jangan menyimpannya untuk digunakan nanti.

#### **Manipulasi String di C API**

Jangan pernah melakukan manipulasi string (seperti `strcat`) pada pointer yang Kita dapat dari `lua_tostring`. Cara yang benar dan efisien adalah dengan menggunakan API Lua itu sendiri.

* `void lua_concat (lua_State *L, int n);`: Mengambil `n` nilai dari puncak stack, menggabungkannya menjadi satu string, dan menggantikan `n` nilai tersebut dengan satu string hasil penggabungan.

#### **Contoh Kode: Menggabungkan String dengan Aman**

```c
// string_concat.c
#include <stdio.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

int main(void) {
    lua_State *L = luaL_newstate();

    // Push dua string ke stack
    lua_pushstring(L, "Hello, ");
    lua_pushstring(L, "world!");

    // Cek isi stack sebelum concat
    // Stack: "world!" (atas), "Hello, " (bawah)
    printf("Top of stack before concat: '%s'\n", lua_tostring(L, -1));

    // Gabungkan 2 nilai di puncak stack
    lua_concat(L, 2);

    // Cek isi stack setelah concat
    // Stack: "Hello, world!" (atas)
    printf("Stack size after concat: %d\n", lua_gettop(L));
    printf("Result on top of stack: '%s'\n", lua_tostring(L, -1));

    lua_close(L);
    return 0;
}
```

#### **Sumber Referensi:**
* **Buku "Programming in Lua"**: [Chapter 24.2.2 – Other Stack Operations](https://www.lua.org/pil/24.2.2.html)
* **Referensi Tambahan**: [Lua-Users Wiki - Strings Tutorial](http://lua-users.org/wiki/StringsTutorial)

---

### **Bagian III, Topik 9: Number dan Integer Operations**

Sejak Lua 5.3, ada pemisahan formal antara angka integer dan floating-point, yang juga tercermin di C API.

* **Tipe Data**:
    * `lua_Integer`: Tipe integer default, biasanya `long long`.
    * `lua_Number`: Tipe floating-point default, biasanya `double`.

* **Fungsi Utama**:
    * `lua_pushinteger(L, n)` dan `lua_pushnumber(L, n)`
    * `lua_tointeger(L, index)` dan `lua_tonumber(L, index)`
    * `lua_isinteger(L, index)`: Pengecekan baru untuk memeriksa apakah sebuah `lua_Number` di stack dapat direpresentasikan sebagai integer tanpa pembulatan.
    * `lua_isnumber(L, index)`: Memeriksa apakah sebuah nilai adalah angka atau string yang dapat diubah menjadi angka.

#### **Aritmetika di C API**

Sama seperti string, operasi aritmetika sebaiknya dilakukan oleh Lua VM.
`void lua_arith (lua_State *L, int op);`: Melakukan operasi aritmetika pada dua nilai teratas di stack, dan menggantinya dengan hasilnya.

* `op` adalah konstanta seperti `LUA_OPADD` (penjumlahan), `LUA_OPSUB` (pengurangan), `LUA_OPMUL` (perkalian), dll.

#### **Contoh Kode: Penjumlahan via C API**

```c
// number_ops.c
#include <stdio.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

int main(void) {
    lua_State *L = luaL_newstate();

    lua_pushinteger(L, 10);
    lua_pushnumber(L, 20.5);

    // Lakukan penjumlahan pada 2 nilai teratas
    lua_arith(L, LUA_OPADD);

    // Hasilnya sekarang ada di puncak stack
    if (lua_isnumber(L, -1)) {
        lua_Number result = lua_tonumber(L, -1);
        printf("Result of 10 + 20.5 is: %f\n", result);
    }

    lua_close(L);
    return 0;
}
```
#### **Sumber Referensi:**
* **Dokumentasi Resmi**: [Lua 5.4 Manual - Numbers](https://www.lua.org/manual/5.4/manual.html#3.4.3)
* **Referensi Tambahan**: [Stack Overflow - Tagged 'lua+c-api+numbers'](https://stackoverflow.com/questions/tagged/lua+c-api+numbers)

---

### **Bagian III, Topik 10: Boolean dan Nil Handling**

Penanganan boolean dan `nil` terlihat sederhana, tetapi memiliki satu konsep kunci yang harus dipahami: *truthiness*.

#### **Nil**
`nil` adalah tipe data tersendiri di Lua yang menandakan "tidak ada nilai".
* `lua_pushnil(L)`: Mendorong `nil` ke stack.
* `lua_isnil(L, index)`: Memeriksa apakah nilai pada `index` adalah `nil`.

#### **Boolean**
* `lua_pushboolean(L, b)`: Mendorong boolean. Di C, `0` akan menjadi `false`, dan nilai integer lainnya akan menjadi `true`.
* `lua_toboolean(L, index)`: Mengambil nilai dari stack sebagai boolean C.

#### **Konsep Kunci: Aturan "Truthiness" Lua**

Ini adalah salah satu sumber kesalahan paling umum bagi pemula. Di banyak bahasa, `0`, string kosong, atau array kosong dianggap "salah". **Di Lua, tidak demikian.**

Aturan di Lua sangat sederhana: **Hanya `false` dan `nil` yang dianggap salah**. Segala sesuatu yang lain—termasuk angka `0`, string kosong `""`, dan tabel kosong `{}`—dianggap **benar**.

Fungsi `lua_toboolean` secara otomatis mengikuti aturan ini.

#### **Contoh Kode: Mendemonstrasikan Truthiness**

```c
// truthiness.c
#include <stdio.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

void check_truthiness(lua_State *L, const char* value_name) {
    // Ambil nilai boolean dari puncak stack sesuai aturan Lua
    int is_true = lua_toboolean(L, -1);
    printf("Value '%s' is considered %s in Lua.\n",
           value_name, is_true ? "TRUE" : "FALSE");
    lua_pop(L, 1); // Bersihkan nilai dari stack
}

int main(void) {
    lua_State *L = luaL_newstate();

    // Nilai yang Falsy
    lua_pushnil(L);
    check_truthiness(L, "nil"); // Hasil: FALSE

    lua_pushboolean(L, 0); // 0 merepresentasikan 'false'
    check_truthiness(L, "false"); // Hasil: FALSE

    printf("\n");

    // Nilai yang Truthy
    lua_pushboolean(L, 1);
    check_truthiness(L, "true"); // Hasil: TRUE

    lua_pushnumber(L, 0);
    check_truthiness(L, "number 0"); // Hasil: TRUE

    lua_pushstring(L, "");
    check_truthiness(L, "empty string ''"); // Hasil: TRUE

    lua_newtable(L);
    check_truthiness(L, "empty table {}"); // Hasil: TRUE

    lua_close(L);
    return 0;
}
```

#### **Sumber Referensi:**
* **Buku "Programming in Lua"**: [Chapter 2.2 – Booleans and Nil](https://www.lua.org/pil/2.2.html)
* **Referensi Tambahan**: [Lua-Users Wiki - Booleans Tutorial](http://lua-users.org/wiki/BooleansTutorial)

---

Dengan selesainya Bagian III, Kita telah menguasai penanganan tipe-tipe data dasar. Kita sekarang mengerti pentingnya manajemen memori string, perbedaan tipe angka, dan aturan *truthiness* yang unik di Lua.

Fondasi ini sangat penting karena di bagian selanjutnya, **Bagian IV: Struktur Data Kompleks**, kita akan beralih ke tipe data paling kuat dan serbaguna di Lua: **tabel**.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../README.md#bagian-iii-interaksi-data-fundamental
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
