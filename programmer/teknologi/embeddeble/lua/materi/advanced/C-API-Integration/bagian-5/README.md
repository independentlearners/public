Kini kita sampai pada inti dari integrasi C-Lua. Bagian ini akan membahas mekanisme fundamental yang memungkinkan kedua bahasa saling memanggil fungsi. Anda akan belajar cara mengeksekusi kode Lua dari C, dan yang lebih penting, bagaimana cara "mengajarkan" Lua untuk memanggil fungsi yang Anda tulis di C.

## **[Bagian V: Function Calls dan Execution][0]**

Menguasai alur pemanggilan fungsi dua arah adalah kunci untuk membangun aplikasi yang benar-benar terintegrasi. Kita akan membahas pola-pola untuk memanggil Lua dari C, mendaftarkan fungsi C ke Lua, membuat fungsi C yang memiliki state (closures), dan bahkan mengelola tugas-tugas kooperatif (coroutines).

---

### **Bagian V, Topik 15: Calling Lua Functions from C**

Ini adalah alur di mana C bertindak sebagai "controller" dan memerintahkan Lua untuk menjalankan sebuah fungsi spesifik. Proses ini sepenuhnya dimediasi oleh stack.

#### **Alur Kerja Memanggil Fungsi Lua**

1.  **Dapatkan Fungsi**: Pertama, Anda harus mendapatkan fungsi Lua yang ingin dipanggil dan mendorongnya ke puncak stack. Cara paling umum adalah dengan `lua_getglobal(L, "nama_fungsi");`.
2.  **Dorong Argumen**: Dorong semua argumen yang diperlukan oleh fungsi Lua tersebut ke stack, secara berurutan. Argumen pertama didorong pertama, argumen kedua setelahnya, dan seterusnya.
3.  **Panggil Fungsi**: Gunakan `lua_pcall(L, nargs, nresults, 0);`.
    - `nargs`: Jumlah argumen yang baru saja Anda dorong ke stack.
    - `nresults`: Jumlah nilai kembali yang Anda harapkan. Gunakan `LUA_MULTRET` jika Anda ingin menerima semua nilai kembali.
4.  **Periksa Error**: Selalu periksa nilai yang dikembalikan oleh `lua_pcall`. Jika bukan `LUA_OK`, berarti terjadi error, dan pesan error kini berada di puncak stack.
5.  **Ambil Hasil**: Jika panggilan berhasil, semua argumen dan fungsi asli telah di-pop dari stack, dan digantikan oleh nilai-nilai kembali. Ambil nilai-nilai ini dari stack menggunakan fungsi `lua_to*`.
6.  **Bersihkan Stack**: Setelah mengambil hasil, pop nilai-nilai tersebut dari stack.

#### **Contoh Kode: Memanggil `add(x, y)` dari C**

```c
// call_lua_from_c.c
#include <stdio.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

int main(void) {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    // Muat skrip Lua yang mendefinisikan fungsi 'add'
    const char *lua_script = "function add(x, y) return x + y end";
    if (luaL_dostring(L, lua_script) != LUA_OK) {
        printf("Error loading script: %s\n", lua_tostring(L, -1));
        return 1;
    }

    // 1. Dapatkan fungsi 'add' dan push ke stack
    lua_getglobal(L, "add");

    // 2. Dorong argumen
    lua_pushnumber(L, 15); // Argumen pertama
    lua_pushnumber(L, 10); // Argumen kedua

    // 3. Panggil fungsi dengan 2 argumen dan 1 hasil
    if (lua_pcall(L, 2, 1, 0) != LUA_OK) {
        printf("Error running function: %s\n", lua_tostring(L, -1));
        return 1;
    }

    // 5. Ambil hasil dari puncak stack
    if (!lua_isnumber(L, -1)) {
        printf("Function did not return a number.\n");
        return 1;
    }
    double result = lua_tonumber(L, -1);
    printf("Result of add(15, 10) is %f\n", result);

    // 6. Bersihkan stack (pop hasil)
    lua_pop(L, 1);

    lua_close(L);
    return 0;
}
```

#### **Sumber Referensi:**

- **Buku "Programming in Lua"**: [Chapter 25.2 – Calling Lua Functions](https://www.lua.org/pil/25.2.html)
- **Referensi Tambahan**: [Lua-Users Wiki - Calling Lua From C](http://lua-users.org/wiki/CallingLuaFromC)

---

### **Bagian V, Topik 16: Registering C Functions untuk Lua**

Ini adalah kebalikannya: mengekspos fungsionalitas C agar dapat dipanggil dari skrip Lua. Ini sangat berguna untuk tugas-tugas yang membutuhkan performa tinggi atau akses ke sistem.

#### **Tanda Tangan `lua_CFunction`**

Setiap fungsi C yang ingin Anda daftarkan ke Lua harus memiliki tanda tangan (signature) yang spesifik:
`static int nama_fungsi(lua_State *L);`

- **Satu Argumen**: Selalu menerima `lua_State *L` sebagai satu-satunya argumen. Melalui `L` inilah Anda akan mendapatkan argumen dari Lua.
- **Return `int`**: Mengembalikan sebuah integer yang menyatakan **jumlah nilai kembali** yang telah Anda dorong ke stack untuk Lua.

#### **Alur Kerja di Dalam Fungsi C**

1.  Ambil argumen dari stack menggunakan `lua_to*` atau fungsi pembantu `luaL_check*` (misalnya, `luaL_checknumber`). Fungsi `check` lebih disukai karena ia akan secara otomatis memicu error Lua jika tipe argumen salah.
2.  Lakukan logika C Anda.
3.  Dorong nilai kembali (jika ada) ke stack menggunakan `lua_push*`.
4.  `return` jumlah nilai yang Anda dorong.

#### **Mendaftarkan Fungsi**

- **Satu Fungsi**: Gunakan `lua_register(L, "nama_di_lua", fungsi_c);`. Ini adalah makro yang mendaftarkan fungsi C Anda sebagai variabel global di Lua.
- **Satu Pustaka (Library)**: Cara yang lebih baik dan terorganisir adalah dengan membuat modul.
  1.  Buat sebuah array dari struct `luaL_Reg` yang memetakan nama di Lua ke fungsi C.
  2.  Panggil `luaL_newlib(L, nama_array_reg)`. Ini akan membuat sebuah tabel baru dan mengisi tabel tersebut dengan fungsi-fungsi dari array Anda.

#### **Contoh Kode: Membuat Library C Sederhana**

```c
// c_library_for_lua.c
#include <stdio.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

// Fungsi C yang akan kita ekspos
// Menghitung pangkat dua dari sebuah angka
static int c_square(lua_State *L) {
    // 1. Ambil argumen pertama (angka) dari stack
    double d = luaL_checknumber(L, 1);

    // 2. Lakukan logika C
    double result = d * d;

    // 3. Dorong hasil ke stack
    lua_pushnumber(L, result);

    // 4. Return 1 karena kita mengembalikan satu nilai
    return 1;
}

// Array yang memetakan nama Lua ke fungsi C
static const struct luaL_Reg mymathlib[] = {
    {"square", c_square},
    {NULL, NULL} // Penanda akhir array
};

// Fungsi ini akan dipanggil untuk membuka library
// Konvensi penamaan: luaopen_<namalibrary>
int luaopen_mymathlib(lua_State *L) {
    luaL_newlib(L, mymathlib);
    return 1;
}

int main(void) {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    // Daftarkan 'loader' untuk library kita
    luaL_requiref(L, "mymath", luaopen_mymathlib, 1);
    lua_pop(L, 1);

    // Sekarang kita bisa memanggil mymath.square() dari Lua
    const char *lua_code = "print('Square of 8 is', mymath.square(8))";
    luaL_dostring(L, lua_code);

    lua_close(L);
    return 0;
}
```

#### **Sumber Referensi:**

- **Buku "Programming in Lua"**: [Chapter 26 – C Functions](https://www.lua.org/pil/26.html)
- **Referensi Tambahan**: [Lua-Users Wiki - Simple Lua API Example](http://lua-users.org/wiki/SimpleLuaApiExample)

---

### **Bagian V, Topik 17: Closures dan Upvalues**

Bagaimana jika fungsi C Anda perlu menyimpan _state_ atau data pribadi di antara panggilan? Jawabannya adalah **C Closures**. Sebuah C Closure adalah fungsi C yang dibundel dengan satu atau lebih **upvalues**. Upvalue adalah nilai Lua yang terkait dengan sebuah closure, dapat diakses oleh fungsi C setiap kali dipanggil.

- **Pembuatan**: `lua_pushcclosure(L, func, n);`
  Sebelum memanggil ini, Anda harus mendorong `n` nilai ke stack. Nilai-nilai ini akan di-pop dan menjadi upvalue untuk `func`.
- **Akses Upvalue**: Di dalam fungsi C, Anda dapat mengakses upvalue menggunakan "pseudo-index" `lua_upvalueindex(i)`, di mana `i` adalah nomor upvalue (mulai dari 1).

Ini memungkinkan Anda membuat "pabrik" fungsi (function factory) yang setiap instance-nya memiliki state yang independen.

#### **Contoh Kode: Pabrik Counter**

```c
// closure_counter.c
// ... (includes) ...

// Fungsi C yang akan menjadi inti dari setiap counter
static int counter_func(lua_State *L) {
    // Ambil upvalue pertama (angka counter saat ini)
    double current_val = lua_tonumber(L, lua_upvalueindex(1));
    current_val++; // Tambah counter

    // Push nilai baru ke upvalue untuk panggilan berikutnya
    lua_pushnumber(L, current_val);
    lua_replace(L, lua_upvalueindex(1));

    // Kembalikan nilai saat ini ke Lua
    lua_pushnumber(L, current_val);
    return 1;
}

// Pabrik yang membuat counter baru
static int new_counter(lua_State *L) {
    // 1. Dorong nilai awal untuk upvalue (angka 0)
    lua_pushnumber(L, 0);

    // 2. Buat closure dengan 1 upvalue
    lua_pushcclosure(L, &counter_func, 1);

    // Kembalikan closure (fungsi counter baru) ke Lua
    return 1;
}

int main(void) {
    // ... (setup state, openlibs) ...
    lua_State *L = luaL_newstate(); luaL_openlibs(L);
    lua_register(L, "new_counter", new_counter); // Daftarkan pabrik kita

    const char *lua_code =
        "c1 = new_counter() \n"
        "c2 = new_counter() \n"
        "print(c1()) -- 1 \n"
        "print(c1()) -- 2 \n"
        "print(c2()) -- 1 (c2 independen dari c1) \n"
        "print(c1()) -- 3 \n";

    luaL_dostring(L, lua_code);
    lua_close(L);
    return 0;
}
```

#### **Sumber Referensi:**

- **Buku "Programming in Lua"**: [Chapter 27.3 – C Closures](https://www.lua.org/pil/27.3.html)
- **Referensi Tambahan**: [Stack Overflow - Tagged 'lua+closures+c-api'](https://stackoverflow.com/questions/tagged/lua+closures+c-api)

---

### **Bagian V, Topik 18: Coroutines dari C**

Coroutine di Lua memungkinkan multitasking kooperatif. Dari C, Anda dapat membuat dan mengontrol coroutine ini. Di C API, coroutine direpresentasikan sebagai `lua_State` baru, yang sering disebut sebagai "thread" (jangan bingung dengan thread sistem operasi).

#### **Alur Kerja Coroutine dari C**

1.  **Buat Coroutine**: `lua_State *co = lua_newthread(L);`. Ini membuat "thread" baru (`co`) yang memiliki stack sendiri tetapi berbagi state global dengan `L`. Objek thread ini juga didorong ke stack `L`.
2.  **Siapkan Coroutine**: Dorong fungsi utama coroutine ke stack _baru_ (`co`).
3.  **Jalankan/Lanjutkan**: `int status = lua_resume(co, L, nargs);`.
4.  **Periksa Status**:
    - `LUA_OK`: Coroutine selesai.
    - `LUA_YIELD`: Coroutine memanggil `coroutine.yield()` dan sekarang dijeda. Nilai yang di-_yield_ ada di stack `co`.
    - Kode error: Terjadi error di dalam coroutine.

Anda dapat memindahkan data bolak-balik antara state utama dan stack coroutine setiap kali ia di-yield dan di-resume.

#### **Sumber Referensi:**

- **Buku "Programming in Lua"**: [Chapter 9 – Coroutines](https://www.lua.org/pil/9.html) (Bab ini menjelaskan konsep coroutine di Lua, yang merupakan dasar untuk memahaminya dari C).
- **Referensi Tambahan**: [Lua-Users Wiki - Coroutines Tutorial](http://lua-users.org/wiki/CoroutinesTutorial)

---

Dengan selesainya Bagian V, Anda telah memperoleh seperangkat alat yang sangat kuat untuk komunikasi dua arah. Anda dapat membangun sistem di mana C menjadi inti yang efisien, dan Lua menyediakan lapisan logika yang dinamis dan fleksibel, dengan kedua dunia dapat saling berinteraksi secara mulus.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md

<!----------------------------------------------------->

[0]: ../README.md#bagian-v-function-calls-dan-execution
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
