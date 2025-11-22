Setelah memahami cara membuat data dan fungsi saling berinteraksi, sekarang kita akan fokus pada aspek-aspek yang krusial untuk aplikasi dunia nyata: stabilitas, efisiensi, dan kecepatan. Bagian ini membahas bagaimana mengelola memori dengan bijak dan bagaimana menulis kode integrasi yang berkinerja tinggi.

# **[Bagian VI: Memory Management dan Performance][0]**

Aplikasi yang berjalan lama seperti server atau game tidak bisa mentolerir kebocoran memori (memory leak) atau jeda performa (stutter). Di bagian ini, kita akan belajar cara bekerja sama dengan Garbage Collector (GC) Lua, cara mengambil alih kontrol alokasi memori sepenuhnya, dan strategi untuk mengoptimalkan kode C API Anda.

---

### **Bagian VI, Topik 19: Memory Management Strategies**

Lua memiliki _garbage collector_ (GC) otomatis yang hebat, tetapi saat Anda menggabungkan dua dunia—memori yang dikelola C (`malloc`/`free`) dan memori yang dikelola Lua (GC)— Anda perlu strategi agar tidak ada yang bocor.

#### **Integrasi dengan Garbage Collector (GC)**

Konsep intinya adalah Lua hanya tahu cara mengelola memori yang _ia alokasikan_. Lua tidak tahu tentang memori yang Anda `malloc` di C. Jembatan antara kedua dunia ini adalah metamethod `__gc`.

- **Metamethod `__gc`**: Ini adalah "kait" atau _hook_ yang disediakan Lua. Jika sebuah _full userdata_ memiliki metatable dengan field `__gc`, Lua akan memanggil fungsi C yang terkait dengan `__gc` **tepat sebelum** userdata tersebut akan dibersihkan oleh GC.

**Strategi Umum:**
Ini memungkinkan pola yang sangat kuat: userdata Lua bertindak sebagai "penjaga" atau _handle_ untuk sumber daya C.

1.  Di C, Anda membuat sebuah `struct` yang menyimpan sumber daya eksternal (misalnya, `FILE*` dari `fopen`, koneksi database, atau memori yang dialokasikan dengan `malloc`).
2.  Anda membuat sebuah _full userdata_ yang isinya adalah pointer ke `struct` C tersebut.
3.  Anda membuat metatable untuk userdata ini dengan metamethod `__gc`.
4.  Fungsi C yang menjadi `__gc` akan bertanggung jawab untuk melepaskan sumber daya C (misalnya, memanggil `fclose` atau `free`).

Dengan cara ini, bahkan jika pengguna skrip Lua lupa menutup sumber daya secara manual, saat handle userdata tersebut tidak lagi dapat dijangkau dan menjadi sampah, GC Lua akan secara otomatis memicu pembersihan di sisi C, mencegah kebocoran sumber daya.

#### **Mengontrol GC dari C**

Anda juga bisa mengontrol perilaku GC secara manual dari C menggunakan `lua_gc(L, what, data)`.

- `lua_gc(L, LUA_GCCOLLECT, 0);`: Memaksa siklus penuh pengumpulan sampah. Berguna untuk membersihkan memori pada saat-saat tertentu (misalnya, saat pergantian level di game).
- `lua_gc(L, LUA_GCSTOP, 0);`: Menghentikan GC.
- `lua_gc(L, LUA_GCRESTART, 0);`: Menjalankan kembali GC.
- `lua_gc(L, LUA_GCSTEP, ...);`: Melakukan satu langkah inkremental GC. Berguna untuk menyebar beban kerja GC dari waktu ke waktu untuk menghindari jeda yang panjang.

#### **Contoh Kode: Handle File yang Aman dengan `__gc`**

```c
// gc_file_handle.c
// ... includes ...

#define FILE_HANDLE "MyFileHandle"

// Fungsi yang dipanggil saat userdata di-garbage collect
static int file_gc(lua_State *L) {
    FILE **pf = (FILE **)luaL_checkudata(L, 1, FILE_HANDLE);
    if (*pf) { // Pastikan file belum ditutup
        printf("GC is closing file handle %p\n", *pf);
        fclose(*pf);
        *pf = NULL;
    }
    return 0;
}

// Fungsi untuk membuka file dan membuat handle
static int file_new(lua_State *L) {
    const char *filename = luaL_checkstring(L, 1);
    // Buat userdata untuk menampung pointer ke FILE*
    FILE **pf = (FILE **)lua_newuserdata(L, sizeof(FILE *));

    // Set metatable-nya
    luaL_getmetatable(L, FILE_HANDLE);
    lua_setmetatable(L, -2);

    // Buka file dan simpan pointer di dalam userdata
    *pf = fopen(filename, "w");

    return 1; // Kembalikan userdata
}

int main(void) {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    // Buat metatable untuk tipe file handle kita
    luaL_newmetatable(L, FILE_HANDLE);
    lua_pushstring(L, "__gc");
    lua_pushcfunction(L, file_gc);
    lua_settable(L, -3); // metatable.__gc = file_gc
    lua_pop(L, 1);

    // Daftarkan fungsi 'new'
    lua_register(L, "new_file", file_new);

    // Jalankan skrip yang membuat handle tapi "lupa" menutupnya
    luaL_dostring(L, "f = new_file('test.txt')");

    printf("Handle created. Forcing garbage collection...\n");
    // Paksa GC untuk menunjukkan bahwa __gc akan dipanggil
    lua_gc(L, LUA_GCCOLLECT, 0);

    printf("Program finished.\n");
    lua_close(L);
    return 0;
}
```

#### **Sumber Referensi:**

- **Buku "Programming in Lua"**: [Chapter 23 – Garbage Collection](https://www.lua.org/pil/23.html) (Meskipun dari perspektif Lua, konsepnya sama).
- **Referensi Tambahan**: [Lua-Users Wiki - Garbage Collection](http://lua-users.org/wiki/GarbageCollection)

---

### **Bagian VI, Topik 20: Custom Allocators**

Untuk kontrol tingkat tertinggi, Lua memungkinkan Anda untuk mengganti fungsi alokasi memorinya secara keseluruhan. Alih-alih Lua memanggil `malloc`/`realloc`/`free` dari C standard library, ia akan memanggil fungsi yang Anda sediakan.

#### **Mengapa Menggunakan Custom Allocator?**

- **Integrasi dengan Engine**: Game engine atau aplikasi besar seringkali memiliki manajer memori sendiri (misalnya, _memory pool_) untuk mengurangi fragmentasi dan mempercepat alokasi.
- **Debugging**: Anda bisa membungkus alokator asli untuk mencatat (log) setiap permintaan alokasi dan pembebasan memori oleh Lua, sangat berguna untuk melacak kebocoran atau pola penggunaan memori.
- **Sistem Tertanam (Embedded)**: Di mana memori sangat terbatas dan perlu dikelola dengan sangat hati-hati dari area memori tertentu.

#### **Fungsi `lua_Alloc` dan `lua_newstate`**

Anda mendefinisikan sebuah fungsi alokator dengan signature `lua_Alloc`. Kemudian, Anda membuat state Lua menggunakan `lua_newstate(my_alloc_func, user_data)` alih-alih `luaL_newstate()`.

- `lua_newstate` menerima fungsi alokator Anda dan sebuah pointer `void*` yang akan diteruskan ke alokator Anda setiap kali dipanggil. Ini memungkinkan Anda untuk meneruskan pointer ke state manajer memori Anda.

#### **Sumber Referensi:**

- **Dokumentasi Resmi**: [Lua 5.4 Manual - `lua_Alloc`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%234.5%5D(https://www.lua.org/manual/5.4/manual.html%234.5)>)
- **Referensi Tambahan**: [Dokumentasi LuaJIT C API](https://github.com/LuaJIT/LuaJIT/blob/v2.1/doc/ext_c_api.html) (Meskipun LuaJIT, konsep alokatornya serupa dan dokumentasinya bagus).

---

### **Bagian VI, Topik 21: Performance Optimization**

Menulis kode yang _berfungsi_ itu satu hal; menulis kode yang _cepat_ adalah hal lain. Berikut adalah beberapa prinsip untuk menjaga integrasi C-Lua Anda tetap gesit.

#### **Prinsip Optimasi**

1.  **Minimalkan Lalu Lintas di Jembatan (Stack)**: Setiap panggilan dari C ke Lua atau sebaliknya memiliki overhead. Dalam loop yang sangat ketat (_hot loop_), hindari memanggil fungsi bolak-balik. Lakukan sebanyak mungkin pekerjaan di satu sisi (biasanya C untuk pemrosesan data mentah) sebelum mengembalikan hasilnya.

2.  **Hindari Alokasi Berulang**: Membuat tabel atau string baru di dalam loop adalah penyebab umum jeda performa karena membebani GC.

    - **Gunakan Kembali Tabel**: Jika sebuah fungsi C perlu mengembalikan sebuah tabel, pertimbangkan untuk menerima tabel sebagai argumen, membersihkannya, dan mengisinya kembali alih-alih membuat yang baru setiap saat.
    - **Hati-hati dengan Konkatenasi String**: Di Lua, `s = s .. "a"` membuat string baru setiap saat. Untuk penggabungan string yang intensif, gunakan `table.concat` atau bangun string di sisi C.

3.  **Gunakan API yang Tepat**:

    - Gunakan `lua_seti`/`lua_geti` untuk akses array, karena ini lebih cepat daripada `lua_setfield`/`lua_getfield`.
    - Gunakan `lua_pushlstring` jika Anda sudah tahu panjang string.
    - Gunakan `luaL_check*` di awal fungsi C Anda untuk validasi argumen yang cepat dan aman.

4.  **Profil Kode Anda\!**: Jangan menebak-nebak di mana letak bottleneck. Gunakan profiler (seperti `gprof` untuk C atau profiler Lua) untuk menemukan bagian kode yang paling lambat, dan fokuskan optimasi Anda di sana. Seringkali lebih efektif memindahkan satu fungsi kecil yang kritis ke C daripada mencoba mengoptimalkan seluruh skrip Lua.

5.  **Manajemen Referensi**: Jika C perlu menyimpan referensi ke objek Lua (seperti fungsi callback) untuk waktu yang lama, jangan biarkan begitu saja di stack. Gunakan **registry Lua**. Registry adalah tabel tersembunyi yang dapat diakses oleh C di mana Anda dapat menyimpan nilai Lua dengan aman tanpa khawatir akan di-garbage collect. Fungsi `luaL_ref` dan `luaL_unref` digunakan untuk ini. (Ini akan dibahas lebih lanjut di Bagian VII).

#### **Sumber Referensi:**

- **Referensi Komunitas**: [Lua-Users Wiki - Optimisation Tips](http://lua-users.org/wiki/OptimisationTips)
- **Referensi Tambahan**: [Stack Overflow - Tagged 'lua+performance+c-api'](https://stackoverflow.com/questions/tagged/lua+performance+c-api)

---

Dengan selesainya Bagian VI, Anda tidak hanya tahu cara membuat C dan Lua bekerja sama, tetapi juga cara membuatnya bekerja sama secara efisien dan andal. Anda sekarang siap untuk menangani skenario produksi yang menuntut.

Selanjutnya, kita akan menyelami topik-topik yang lebih dalam dan canggih di **Bagian VII: Advanced Features**, di mana kita akan membahas manajemen state yang kompleks, pola userdata tingkat lanjut, dan banyak lagi.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-5/README.md
[selanjutnya]: ../bagian-7/README.md

<!----------------------------------------------------->

[0]: ../README.md#bagian-vi-memory-management-dan-performance
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
