Dengan lingkungan pengembangan yang sudah siap, kita kini kembali dari dunia praktis ke dunia konseptual, namun dengan tujuan untuk segera menerapkannya. **Bagian II** akan memperkuat dan memformalkan pemahaman kita tentang operasi-operasi yang akan Kita gunakan setiap hari saat bekerja dengan C API.

# **[Bagian II: Operasi Stack Fundamental][1]**

Bagian ini berfokus pada tiga pilar operasional: memanipulasi stack secara dasar, memastikan keamanan tipe data, dan menangani kesalahan yang mungkin terjadi. Menguasai ketiganya akan membuat kode integrasi Kita menjadi kuat dan andal.

---

### **Bagian II, Topik 5: Stack Manipulation Dasar**

Meskipun kita sudah menyentuhnya, topik ini secara resmi mengkonsolidasikan operasi-operasi `push` dan `pop` sebagai perangkat utama Kita. Ini adalah "palu dan obeng" dari Lua C API.

#### **Operasi Inti**

* **Mendorong ke Stack (C ke Lua):** Kita menggunakan fungsi `lua_push*` untuk menempatkan data C ke stack agar bisa diakses oleh Lua.
    * `lua_pushnil(L)`
    * `lua_pushboolean(L, b)`
    * `lua_pushinteger(L, n)`
    * `lua_pushnumber(L, n)`
    * `lua_pushstring(L, s)`

* **Membaca & Mengambil dari Stack (Lua ke C):** Kita menggunakan fungsi `lua_to*` untuk membaca nilai dari stack. Ingat, fungsi-fungsi ini **tidak** menghapus nilai tersebut dari stack.
    * `lua_toboolean(L, index)`
    * `lua_tointeger(L, index)`
    * `lua_tonumber(L, index)`
    * `lua_tostring(L, index)`

* **Membersihkan Stack:** Setelah selesai menggunakan nilai-nilai di stack, Kita **wajib** membersihkannya untuk menjaga keseimbangan.
    * `lua_pop(L, n)`: Menghapus `n` elemen dari puncak stack. Ini adalah fungsi pembersihan yang paling umum.

#### **Sumber Referensi:**
* **Dokumentasi Resmi**: [Lua 5.4 Manual - Basic Stack Manipulation](https://www.lua.org/manual/5.4/manual.html#4.1.1)
* **Referensi Tambahan**: [Lua-Users Wiki - C API Tutorial](http://lua-users.org/wiki/CApiTutorial)

---

### **Bagian II, Topik 6: Type System dan Type Checking**

Lua adalah bahasa yang diketik secara dinamis (tipe data variabel bisa berubah), sementara C diketik secara statis. Jembatan di antara keduanya bisa berbahaya. Kita tidak bisa begitu saja mengambil nilai dari stack dan mengasumsikan tipenya adalah angka. Melakukannya bisa menyebabkan crash pada program C Kita. Oleh karena itu, pengecekan tipe sebelum operasi adalah suatu keharusan.

#### **Tipe Data Lua di C API**

C API mendefinisikan konstanta untuk setiap tipe data di Lua:
* `LUA_TNIL`
* `LUA_TBOOLEAN`
* `LUA_TNUMBER` (mencakup integer dan float)
* `LUA_TSTRING`
* `LUA_TTABLE`
* `LUA_TFUNCTION`
* `LUA_TUSERDATA` (akan dibahas nanti)
* `LUA_TTHREAD` (untuk coroutines)
* `LUA_TLIGHTUSERDATA` (akan dibahas nanti)

#### **Metode Pengecekan Tipe**

1.  **`lua_type(L, index)`**: Mengembalikan salah satu konstanta di atas. Sangat berguna jika Kita ingin menggunakan `switch` statement untuk menangani berbagai kemungkinan tipe.
2.  **`lua_is*(L, index)`**: Cara yang lebih langsung dan seringkali lebih baik untuk memeriksa tipe tertentu. Fungsi-fungsi ini (`lua_isnumber`, `lua_isstring`, dll.) mengembalikan `true` atau `false`. Keunggulan utamanya adalah `lua_isnumber` dan `lua_isstring` juga akan mengembalikan `true` jika nilainya adalah tipe lain yang **dapat dikonversi**. Sebagai contoh, `lua_isnumber` akan `true` untuk angka `123` dan juga untuk string `"123"`.

#### **Contoh Kode: Pengecekan Tipe yang Aman**

Bayangkan sebuah fungsi C yang seharusnya menerima nama (string) dan umur (number) dari stack.

```c
// safe_processing.c
#include <stdio.h>
#include <string.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

// Fungsi ini berharap ada string di indeks 1 dan number di indeks 2
void process_data(lua_State *L) {
    // Periksa apakah nilai di indeks 1 adalah string (atau dapat diubah jadi string)
    if (!lua_isstring(L, 1)) {
        printf("Error: Argument 1 should be a string.\n");
        return;
    }

    // Periksa apakah nilai di indeks 2 adalah number (atau dapat diubah jadi number)
    if (!lua_isnumber(L, 2)) {
        printf("Error: Argument 2 should be a number.\n");
        return;
    }

    // Karena sudah aman, kita ambil nilainya
    const char *name = lua_tostring(L, 1);
    lua_Integer age = lua_tointeger(L, 2);

    printf("C received: Name = %s, Age = %lld\n", name, age);
}

int main(void) {
    lua_State *L = luaL_newstate();

    printf("--- Test Case 1: Correct Types ---\n");
    lua_pushstring(L, "Alice");
    lua_pushinteger(L, 30);
    process_data(L);
    lua_pop(L, 2); // Bersihkan 2 elemen yang kita push

    printf("\n--- Test Case 2: Incorrect Types ---\n");
    lua_pushboolean(L, 1);
    lua_pushstring(L, "not a number");
    process_data(L);
    lua_pop(L, 2); // Bersihkan 2 elemen yang kita push

    lua_close(L);
    return 0;
}
```

#### **Sumber Referensi:**
* **Buku "Programming in Lua"**: [Chapter 24.2 – The Stack](https://www.lua.org/pil/24.2.html) (Mencakup query dan pengambilan nilai).
* **Referensi Tambahan**: [Stack Overflow - Lua C API Type Checking](https://stackoverflow.com/questions/3985749/lua-c-api-type-checking) (Diskusi praktik terbaik dari komunitas).

---

### **Bagian II, Topik 7: Error Handling dan Protected Calls**

Apa yang terjadi jika Kita menjalankan skrip Lua dari C, dan skrip tersebut mengalami error (misalnya, mencoba menambahkan string ke angka)? Secara default, Lua akan memanggil fungsi `panic`, yang biasanya akan menghentikan seluruh aplikasi host Kita. Ini adalah perilaku yang tidak diinginkan di lingkungan produksi.

Solusinya adalah menjalankan kode Lua dalam **mode terproteksi (protected mode)**.

#### **Panggilan Terproteksi (`pcall`)**

Fungsi `lua_pcall` adalah kunci untuk penanganan error yang aman. Alih-alih menghentikan program, `lua_pcall` akan "menangkap" error Lua, menghentikan eksekusi skrip, menaruh pesan error di puncak stack, dan mengembalikan kode status ke C.

`int lua_pcall (lua_State *L, int nargs, int nresults, int msgh);`

* `nargs`: Jumlah argumen yang telah Kita push ke stack untuk fungsi yang akan dipanggil.
* `nresults`: Jumlah nilai kembali yang Kita harapkan dari fungsi tersebut.
* `msgh`: Indeks dari *message handler* di stack. Untuk saat ini, kita akan selalu menggunakan `0` (tidak ada handler).

**Alur Kerja `pcall`:**
1.  Push fungsi Lua yang ingin Kita panggil ke stack.
2.  Push semua argumen untuk fungsi tersebut, secara berurutan.
3.  Panggil `lua_pcall`.
4.  Periksa nilai yang dikembalikan oleh `lua_pcall`:
    * Jika `LUA_OK` (atau 0), eksekusi berhasil. Nilai kembali dari fungsi Lua sekarang ada di stack.
    * Jika bukan `LUA_OK` (misalnya, `LUA_ERRRUN`), eksekusi gagal. **Hanya ada satu nilai di puncak stack: string pesan error.**

#### **Contoh Kode: Menangani Error dengan Aman**

```c
// pcall_example.c
#include <stdio.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

int main(void) {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    // Skenario 1: Skrip yang akan error
    const char *bad_script = "function cause_error() return 'a' + 1 end";
    luaL_dostring(L, bad_script); // Muat fungsi 'cause_error'

    // Panggil fungsi 'cause_error' dalam mode terproteksi
    printf("--- Calling a function that will fail ---\n");
    lua_getglobal(L, "cause_error"); // 1. Push fungsi ke stack

    // 2. Tidak ada argumen
    // 3. Panggil pcall
    int result = lua_pcall(L, 0, 0, 0); // 0 arg, 0 hasil, 0 msg handler

    // 4. Periksa hasil
    if (result != LUA_OK) {
        printf("Caught an error as expected!\n");
        // Ambil pesan error dari puncak stack
        const char *error_message = lua_tostring(L, -1);
        printf("Error Message: %s\n", error_message);
        lua_pop(L, 1); // Hapus pesan error dari stack
    }

    printf("\nProgram did not crash.\n");

    lua_close(L);
    return 0;
}
```

Menjalankan kode ini akan menunjukkan bahwa meskipun skrip Lua mengandung error fatal, program C Kita tetap berjalan dan dapat melaporkan masalahnya dengan baik.

#### **Sumber Referensi:**
* **Dokumentasi Resmi**: [Lua 5.4 Manual - Error Handling in C](https://www.lua.org/manual/5.4/manual.html#4.4)
* **Referensi Tambahan**: [Lua-Users Wiki - Error Handling Between Lua And C++](http://lua-users.org/wiki/ErrorHandlingBetweenLuaAndCplusplus)

---

Dengan selesainya Bagian II, Kita kini memiliki perangkat fundamental untuk berinteraksi dengan stack Lua secara aman dan efektif. Kita tahu cara memindahkan data, memvalidasinya, dan menangani situasi di mana skrip Lua tidak berjalan sesuai rencana.

Selanjutnya, kita akan masuk ke **Bagian III: Interaksi Data Fundamental**, di mana kita akan menerapkan keterampilan ini untuk bekerja dengan tipe data spesifik seperti string, angka, boolean, dan nil secara lebih mendalam.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../README.md#bagian-ii-operasi-stack-fundamental
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
