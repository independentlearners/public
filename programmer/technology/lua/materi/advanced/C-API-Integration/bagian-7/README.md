Setelah membangun fondasi yang kuat, kita sekarang akan menjelajahi fitur-fitur yang memungkinkan Anda membangun sistem yang kompleks, aman, dan dapat diskalakan. Ini adalah perangkat yang membedakan integrasi dasar dari arsitektur tingkat profesional.

# **[Bagian VII: Advanced Features][0]**

Bagian ini adalah kumpulan "batu permata" dari C API. Kita akan membahas cara mengelola beberapa lingkungan Lua secara bersamaan, membangun hierarki objek yang rumit, menangani referensi data jangka panjang, mengintip ke dalam mesin Lua yang sedang berjalan, dan mengamankan aplikasi Anda dari skrip yang tidak tepercaya.

---

### **Bagian VII, Topik 22: Lua State Management**

Sebuah `lua_State` merepresentasikan seluruh lingkungan eksekusi Lua. Terkadang, Anda memerlukan lebih dari satu.

* **Tujuan Utama**: **Isolasi**. Setiap `lua_State` adalah sebuah dunia yang terpisah. Ia memiliki variabel global, fungsi, dan stack sendiri. Ini sangat penting untuk:
    * **Sandboxing**: Menjalankan skrip dari berbagai pengguna (misalnya, plugin) dalam lingkungan yang terisolasi total sehingga mereka tidak dapat saling mengganggu.
    * **Aplikasi Multi-threading**: `lua_State` **tidak aman untuk diakses dari banyak thread sistem operasi (OS threads) secara bersamaan**. Praktik standar dan teraman adalah: **satu `lua_State` per thread**. Komunikasi antar-state di thread yang berbeda harus dilakukan melalui mekanisme message-passing yang aman di sisi C.

#### **Sumber Referensi:**
* **Buku "Programming in Lua"**: [Chapter 24.1 – Multiple States](https://www.lua.org/pil/24.1.html)
* **Referensi Tambahan**: [Lua-Users Wiki - Threads Tutorial](http://lua-users.org/wiki/ThreadsTutorial) (Membahas keamanan thread dan state).

---

### **Bagian VII, Topik 23: Advanced Userdata Patterns**

Kita dapat meningkatkan pola userdata dasar untuk menciptakan hierarki objek yang kompleks, meniru sistem kelas dan pewarisan (inheritance) seperti di C++.

* **Pola Pewarisan**:
    1.  Buat metatable untuk "kelas" dasar, misalnya `Base.meta`.
    2.  Buat metatable untuk "kelas" turunan, misalnya `Derived.meta`.
    3.  Atur metamethod `__index` dari `Derived.meta` agar menunjuk ke `Base.meta`.
    4.  Sekarang, ketika sebuah metode dipanggil pada objek turunan, jika Lua tidak menemukannya di `Derived.meta`, ia akan secara otomatis mencari di `Base.meta`, secara efektif meniru pewarisan metode.

Ini memungkinkan Anda untuk membangun API yang kaya dan berorientasi objek di Lua, yang didukung oleh struktur data C yang efisien.

#### **Sumber Referensi:**
* **Buku "Programming in Lua"**: [Chapter 28.2 – Inheritance](https://www.lua.org/pil/28.2.html)
* **Referensi Tambahan**: [O'Reilly - Creating Solid APIs](https://www.oreilly.com/library/view/creating-solid-apis/9781491986301/ch04.html) (Membahas sistem kelas userdata).

---

### **Bagian VII, Topik 24: Registry dan Reference Management**

Bagaimana jika C perlu menyimpan referensi ke nilai Lua (seperti fungsi callback) untuk waktu yang lama? Menyimpannya di stack tidak mungkin. Menyimpannya di tabel global akan membuatnya terlihat oleh skrip Lua. Solusinya adalah **Registry**.

* **Registry**: Sebuah tabel tersembunyi yang dapat diakses oleh C (tetapi tidak oleh Lua secara langsung) pada pseudo-index `LUA_REGISTRYINDEX`. Registry tidak pernah di-garbage collect.
* **Sistem Referensi**: Anda menggunakan registry untuk membuat referensi yang stabil dan aman dari GC.
    * `int ref = luaL_ref(L, LUA_REGISTRYINDEX);`: Mengambil nilai dari puncak stack, menyimpannya di registry dengan kunci integer unik, dan mengembalikan kunci (referensi) tersebut.
    * `lua_rawgeti(L, LUA_REGISTRYINDEX, ref);`: Menggunakan referensi `ref` untuk mendorong kembali nilai yang tersimpan ke puncak stack.
    * `luaL_unref(L, LUA_REGISTRYINDEX, ref);`: Menghapus referensi dari registry, memungkinkan objek tersebut di-garbage collect jika tidak ada referensi lain.

Ini adalah mekanisme standar untuk mengelola callback atau objek Lua yang masa pakainya dikontrol oleh C.

#### **Sumber Referensi:**
* **Referensi Komunitas**: [Lua-Users Wiki - Registry And References](http://lua-users.org/wiki/RegistryAndReferences)
* **Referensi Tambahan**: [Stack Overflow - Tagged 'lua+registry+references'](https://stackoverflow.com/questions/tagged/lua+registry+references)

---

### **Bagian VII, Topik 25: Weak References dan Weak Tables**

Secara default, tabel memegang referensi "kuat" ke isinya, mencegahnya di-garbage collect. **Weak Table** memegang referensi "lemah", yang *tidak* mencegah GC.

* **Cara Kerja**: Anda membuat tabel biasa, lalu mengatur field `__mode` di metatablenya.
    * `__mode = "k"`: Kunci (keys) bersifat lemah.
    * `__mode = "v"`: Nilai (values) bersifat lemah.
    * `__mode = "kv"`: Keduanya bersifat lemah.
* **Kasus Penggunaan Utama**: Membuat *cache*. Bayangkan Anda ingin memetakan objek userdata ke data lain. Jika satu-satunya tempat objek userdata itu direferensikan adalah sebagai kunci di dalam cache Anda, Anda ingin objek itu bisa di-GC saat tidak lagi digunakan di tempat lain. Dengan membuat kunci tabel cache menjadi lemah (`__mode = "k"`), GC dapat mengklaim kembali objek tersebut, dan entri di cache akan hilang secara otomatis.

#### **Sumber Referensi:**
* **Buku "Programming in Lua"**: [Chapter 17 – Weak Tables](https://www.lua.org/pil/17.html)
* **Referensi Tambahan**: [Lua-Users Wiki - Weak Tables Tutorial](http://lua-users.org/wiki/WeakTablesTutorial)

---

### **Bagian VII, Topik 26: Debug API dan Introspection**

Lua menyediakan API debug yang kuat untuk mengintip ke dalam eksekusi state. Ini adalah fondasi untuk membangun debugger, profiler, dan alat analisis.

* **Hooks**: `lua_sethook` memungkinkan Anda mendaftarkan fungsi C untuk dipanggil pada event tertentu (setiap baris dieksekusi, setiap fungsi dipanggil/kembali).
* **Stack Walking**: `lua_getstack` dan `lua_getinfo` memungkinkan Anda untuk memeriksa call stack, mendapatkan informasi tentang setiap fungsi yang aktif (nama, sumber, nomor baris).
* **Inspeksi Variabel**: `lua_getlocal` dan `lua_getupvalue` memungkinkan Anda untuk membaca nilai variabel lokal dan upvalue dari sebuah fungsi pada stack.

Ini sangat berguna untuk menghasilkan pesan error yang kaya dengan *stack trace* lengkap.

#### **Sumber Referensi:**
* **Dokumentasi Resmi**: [Lua 5.4 Manual - The Debug Interface](https://www.lua.org/manual/5.4/manual.html#4.7)
* **Referensi Tambahan**: [Lua-Users Wiki - Debugging Lua Code](http://lua-users.org/wiki/DebuggingLuaCode)

---

### **Bagian VII, Topik 27: Module System Integration**

Bagaimana C dapat berpartisipasi dalam sistem `require()` Lua?

* **`package.preload`**: Ini adalah tabel kunci. Saat `require('mymodule')` dipanggil, Lua pertama kali memeriksa `package.preload['mymodule']`. Jika ada sebuah fungsi di sana (disebut *loader*), Lua akan memanggilnya.
* **Pola C**: Fungsi `luaopen_mylib` yang kita lihat sebelumnya adalah sebuah *loader*. Cara modern untuk mendaftarkannya adalah dengan `luaL_requiref(L, "mymodule", luaopen_mylib, 1)`. Fungsi ini secara cerdas akan mendaftarkan loader Anda ke `package.preload` jika modul belum dimuat, atau hanya mengambil modul yang sudah ada jika sudah dimuat sebelumnya.

#### **Sumber Referensi:**
* **Buku "Programming in Lua"**: [Chapter 15 – Modules and Packages](https://www.lua.org/pil/15.html)
* **Referensi Tambahan**: [Lua-Users Wiki - Module Definition](http://lua-users.org/wiki/ModuleDefinition)

---

### **Bagian VII, Topik 28: Sandboxing dan Security**

Saat menjalankan skrip yang tidak tepercaya, Anda harus membatasi apa yang bisa mereka lakukan. Ini disebut **sandboxing**.

* **Teknik Utama (`_ENV`)**: Di Lua modern, semua akses ke variabel "global" sebenarnya adalah akses ke field dari tabel lingkungan (`_ENV`) milik fungsi tersebut.
* **Pola Sandboxing**:
    1.  Buat sebuah tabel baru di C.
    2.  Isi tabel ini **hanya** dengan fungsi-fungsi yang Anda anggap aman (misalnya, `print`, `tostring`, tapi bukan `os.execute` atau `io.open`).
    3.  Gunakan `lua_setupvalue` untuk mengganti tabel `_ENV` dari chunk skrip yang tidak tepercaya dengan tabel aman yang baru saja Anda buat.
    4.  Sekarang, ketika skrip tersebut berjalan, ia hanya bisa "melihat" fungsi-fungsi aman yang Anda sediakan.

#### **Sumber Referensi:**
* **Referensi Komunitas**: [Lua-Users Wiki - SandBoxes](http://lua-users.org/wiki/SandBoxes)
* **Referensi Tambahan**: [Blog CloudFlare](https://blog.cloudflare.com/pushing-nginx-to-its-limit-with-lua/) (Menjelaskan penggunaan sandboxing di lingkungan produksi).

---

### **Bagian VII, Topik 29: Lua Auxiliary Library (lauxlib)**

Ini bukan fitur tunggal, melainkan seluruh perangkat pembantu yang membuat hidup Anda lebih mudah. Fungsi-fungsi dengan prefix `luaL_` ini adalah abstraksi tingkat tinggi di atas API inti (`lua_`).

* **Selalu Utamakan `lauxlib`**: Jika ada fungsi `luaL_*` yang bisa melakukan apa yang Anda butuhkan, gunakan itu. Kode Anda akan lebih pendek, lebih aman, dan lebih mudah dibaca.
* **Contoh**: Hampir semua yang telah kita bahas menggunakan `lauxlib`: `luaL_newstate`, `luaL_checknumber`, `luaL_newmetatable`, `luaL_ref`, `luaL_loadstring`, `luaL_newlib`, dan masih banyak lagi. `lauxlib` bukanlah "opsional", melainkan bagian standar dari praktik pemrograman C API yang baik.

#### **Sumber Referensi:**
* **Dokumentasi Resmi**: [Lua 5.4 Manual - The Auxiliary Library](https://www.lua.org/manual/5.4/manual.html#5)
* **Referensi Tambahan**: [Lua-Users Wiki - Lauxlib Functions](http://lua-users.org/wiki/LauxlibFunctions)

---

Dengan ini, kita telah menyelesaikan tur mendalam fitur-fitur canggih. Anda sekarang dibekali dengan pengetahuan untuk membangun hampir semua jenis integrasi, dari yang sederhana hingga yang paling kompleks dan aman.

Selanjutnya, kita akan melihat bagaimana semua konsep ini digabungkan dalam **Bagian VIII: Integration Patterns** untuk membentuk pola arsitektur aplikasi dunia nyata.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-6/README.md
[selanjutnya]: ../bagian-8/README.md

<!----------------------------------------------------->

[0]: ../README.md#bagian-vii-advanced-features
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
