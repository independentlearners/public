Kita telah menguasai API pada tingkat fungsional dan teknis. Sekarang, mari kita perbesar pandangan kita dan melihat bagaimana semua bagian ini dirangkai untuk membentuk pola arsitektur yang kuat dan terbukti di dunia nyata. Bagian ini adalah tentang "gambaran besar" dari integrasi C-Lua.

## Bagian VIII: Integration Patterns

Di sini kita akan mempelajari cetak biru (blueprints) arsitektur untuk berbagai jenis aplikasi. Memahami pola-pola ini akan membantu Anda menstrukturkan proyek Anda secara bersih, efisien, dan dapat dipelihara.

---

### **Bagian VIII, Topik 30: Embedding Lua dalam C Applications**

Ini adalah pola yang paling umum, di mana aplikasi C/C++ yang besar (disebut _host_) menggunakan Lua sebagai mesin skrip internal. C adalah "pemilik rumah", dan Lua adalah "tamu" yang diundang untuk melakukan tugas-tugas tertentu.

- **Pola Arsitektur**:
  - **Mesin Konfigurasi**: Daripada menggunakan file `.ini` atau `.json` yang statis, gunakan skrip Lua sebagai file konfigurasi. Keuntungannya: Anda bisa memiliki logika, variabel, fungsi, dan struktur data yang kompleks langsung di dalam konfigurasi. Aplikasi C akan mengeksekusi skrip ini saat startup untuk mengisi struktur konfigurasinya.
  - **Sistem Plugin/Modding**: Aplikasi C mengekspos serangkaian fungsi inti ke Lua (menggunakan `lua_register`, `luaL_newlib`, dll.). Pengguna atau pengembang lain kemudian dapat menulis skrip `.lua` yang menggunakan API ini untuk memperluas fungsionalitas aplikasi tanpa menyentuh atau mengkompilasi ulang kode C inti. Ini adalah pola yang digunakan oleh World of Warcraft, Neovim, dan VLC.
  - **Mesin Logika Bisnis**: Inti aplikasi yang berkinerja tinggi (misalnya, server jaringan, pipeline pemrosesan data) ditulis dalam C. Namun, "aturan bisnis" yang sering berubah (misalnya, cara memproses permintaan HTTP, aturan validasi data) ditulis dalam Lua. Ini memungkinkan pembaruan logika dengan cepat tanpa me-restart server inti. OpenResty adalah contoh utama dari pola ini.

#### **Sumber Referensi:**

- **Buku "Programming in Lua"**: [Part IV – The C API](https://www.lua.org/pil/part4.html) (Seluruh bagian ini didedikasikan untuk pola embedding).
- **Referensi Komunitas**: [Lua-Users Wiki - Embedding Lua](http://lua-users.org/wiki/EmbeddingLua)

---

### **Bagian VIII, Topik 31: Creating Lua Extensions/Libraries**

Ini adalah kebalikan dari embedding. Di sini, Lua adalah lingkungan utama, dan Anda menulis kode C untuk _memperluas_ kemampuan Lua. Tujuannya adalah untuk membuat sebuah file pustaka bersama (`.so` di Linux, `.dll` di Windows) yang dapat dimuat oleh skrip Lua mana pun melalui `require('nama_modul')`.

- **Alur Kerja**:
  1.  Tulis kode C Anda, pastikan ada fungsi pembuka `luaopen_namamodul(lua_State *L)`.
  2.  Kompilasi kode C Anda sebagai **shared library**, bukan executable. Di GCC/Clang, ini biasanya menggunakan flag `-shared` dan `-fPIC`.
  3.  Letakkan file `.so` atau `.dll` yang dihasilkan di lokasi yang dapat ditemukan oleh Lua (sesuai `package.cpath`).
- **Distribusi dengan LuaRocks**: LuaRocks adalah manajer paket untuk modul Lua. Anda dapat membuat file `rockspec` yang sederhana, yang merupakan resep bagi LuaRocks tentang cara mengunduh sumber C Anda, mengkompilasinya menjadi pustaka bersama di sistem pengguna, dan menginstalnya di lokasi yang benar. Ini adalah cara standar untuk mendistribusikan ekstensi C Anda ke komunitas.

#### **Sumber Referensi:**

- **Buku "Programming in Lua"**: [Chapter 26.2 – Writing C Libraries](https://www.lua.org/pil/26.2.html)
- **Panduan LuaRocks**: [Creating a rock](https://github.com/luarocks/luarocks/wiki/Creating-a-rock)

---

### **Bagian VIII, Topik 32: FFI Integration (LuaJIT)**

Pola ini spesifik untuk **LuaJIT**, sebuah implementasi Lua berkinerja sangat tinggi dengan compiler Just-In-Time. LuaJIT menyertakan pustaka **FFI (Foreign Function Interface)** yang revolusioner.

- **Apa itu FFI?**: FFI memungkinkan Anda untuk memanggil fungsi C dan menggunakan tipe data C (seperti `struct`) **langsung dari skrip Lua**, tanpa perlu menulis satu baris pun kode "lem" C.
- **Cara Kerja**:
  1.  Di dalam skrip Lua, Anda mendeklarasikan header C sebagai string menggunakan `ffi.cdef[[...]]`.
  2.  Anda memuat pustaka bersama C (`.so` atau `.dll`) menggunakan `ffi.load("nama_pustaka")`.
  3.  Anda sekarang dapat langsung memanggil fungsi-fungsi dari pustaka tersebut seolah-olah mereka adalah fungsi Lua.
- **FFI vs C API Tradisional**:
  - **C API**: Membutuhkan kode C untuk menjembatani setiap fungsi. **Pro**: Bekerja di semua versi Lua, kontrol penuh. **Kontra**: Butuh lebih banyak kode boilerplate.
  - **LuaJIT FFI**: Hampir tanpa boilerplate. **Pro**: Pengembangan super cepat, performa panggilan yang sangat baik. **Kontra**: Hanya berfungsi di LuaJIT.

#### **Sumber Referensi:**

- **Tutorial LuaJIT**: [LuaJIT FFI Tutorial](http://luajit.org/ext_ffi_tutorial.html)
- **Referensi Komunitas**: [Lua-Users Wiki - LuaJitFfi](http://lua-users.org/wiki/LuaJitFfi)

---

### **Bagian VIII, Topik 33: Callbacks dan Event Handling**

Ini adalah pola penting untuk aplikasi yang digerakkan oleh peristiwa (event-driven), seperti GUI atau server jaringan.

- **Pola**:
  1.  **Registrasi**: Skrip Lua memanggil fungsi C yang diekspos (misalnya, `on_event("klik", fungsi_callback_lua)`).
  2.  **Penyimpanan**: Fungsi C menyimpan `fungsi_callback_lua` tersebut dengan aman di **Registry** menggunakan `luaL_ref`. Kode C kini memegang sebuah referensi integer ke callback tersebut.
  3.  **Terjadi Peristiwa**: Sesuatu terjadi di aplikasi C (misalnya, loop utama mendeteksi klik mouse).
  4.  **Pemanggilan**: Kode C mengambil fungsi callback dari registry menggunakan referensi integernya, mendorongnya ke stack, mendorong argumen peristiwa (seperti koordinat mouse), lalu memanggilnya dengan aman menggunakan `lua_pcall`.

Pola ini adalah dasar untuk pemrograman asinkron di Lua. Loop utama C (misalnya, `epoll`) berjalan tanpa henti, dan ketika sebuah peristiwa siap, ia hanya meneruskan panggilan ke callback Lua yang sesuai tanpa memblokir.

#### **Sumber Referensi:**

- **Referensi Komunitas**: [Lua-Users Wiki - Callbacks In Lua](http://lua-users.org/wiki/CallbacksInLua)
- **Contoh Dunia Nyata**: [Proyek OpenResty lua-resty-core](https://github.com/openresty/lua-resty-core)

---

### **Bagian VIII, Topik 34: Inter-Language Integration**

Karena API Lua didasarkan pada C, yang merupakan "lingua franca" dalam pemrograman, Lua dapat diintegrasikan dengan hampir semua bahasa pemrograman lain.

- **Mekanisme**: Bahasa lain (Python, Java, C#, Go, dll.) menggunakan mekanismenya sendiri untuk memanggil fungsi C. Jembatan ini kemudian digunakan untuk memanggil fungsi-fungsi di dalam pustaka bersama Lua (`liblua.so`/`.dll`).
  - **Python**: Menggunakan `ctypes` atau `CFFI`.
  - **Java**: Menggunakan JNI (Java Native Interface).
  - **.NET/C#**: Menggunakan P/Invoke.
- **Pustaka Pembungkus (Wrapper Libraries)**: Untuk sebagian besar bahasa populer, seseorang telah membuat pustaka pembungkus yang menyediakan API yang lebih nyaman dan idiomatis, menyembunyikan kompleksitas manipulasi stack C API. Contohnya termasuk `lupa` untuk Python, KeraLua untuk .NET, dan `sol2` atau `luabind` untuk C++.

#### **Sumber Referensi:**

- **Referensi Komunitas**: [Lua-Users Wiki - Binding Code To Lua](http://lua-users.org/wiki/BindingCodeToLua)
- **Contoh Pustaka**: [sol2 (C++)](https://github.com/ThePhD/sol2)

---

Dengan memahami pola-pola integrasi ini, Anda kini memiliki perspektif arsitektural untuk merancang aplikasi Anda. Anda tahu kapan harus memilih embedding, kapan harus membuat ekstensi, dan bagaimana memanfaatkan pola-pola canggih seperti callback dan FFI.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-7/README.md
[selanjutnya]: ../bagian-9/README.md

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
