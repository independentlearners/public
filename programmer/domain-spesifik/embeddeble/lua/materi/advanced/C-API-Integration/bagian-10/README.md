Setelah membangun berbagai aplikasi dan menerapkan pola-pola arsitektur, langkah selanjutnya dalam siklus hidup pengembangan perangkat lunak adalah memastikan kualitas, keandalan, dan performa. Bagian ini akan membekali Anda dengan teknik dan alat untuk menguji, men-debug, dan menganalisis performa kode integrasi C-Lua Anda.

## Bagian X: Testing dan Debugging

Menulis kode hanyalah separuh dari pekerjaan. Memastikan kode tersebut berfungsi dengan benar, menemukan dan memperbaiki bug saat terjadi, serta mengoptimalkan bagian yang lambat adalah hal yang membedakan proyek hobi dari perangkat lunak tingkat produksi.

---

### **Bagian X, Topik 41: Unit Testing C API Code**

Bagaimana cara menguji sebuah fungsi C yang berinteraksi dengan stack Lua? Mengujinya secara terisolasi di C sangatlah sulit. Strategi yang paling efektif adalah **menguji kode C Anda dari Lua**.

- **Strategi**:
  1.  Kompilasi kode ekstensi C Anda menjadi sebuah pustaka bersama (`.so` atau `.dll`).
  2.  Gunakan sebuah _test framework_ Lua seperti **Busted**. Busted menyediakan struktur untuk menulis tes (`describe`, `it`) dan serangkaian fungsi _assertion_ (`assert.are.equal`, `assert.is_true`, dll.) untuk memvalidasi hasil.
  3.  Tulis sebuah skrip tes Lua (`_spec.lua`) yang melakukan `require()` pada modul C Anda.
  4.  Di dalam skrip tes, panggil fungsi-fungsi C Anda dengan berbagai input dan gunakan _assertions_ untuk memverifikasi bahwa outputnya, efek sampingnya (misalnya, modifikasi tabel), dan penanganan error-nya sudah sesuai dengan yang diharapkan.
- **Mocking**: Jika fungsi C Anda bergantung pada bagian lain dari aplikasi Anda, Anda dapat membuat "mock" atau tiruan dari dependensi tersebut dalam bentuk tabel atau fungsi Lua, lalu meneruskannya ke fungsi C Anda untuk pengujian yang terisolasi.

#### **Sumber Referensi:**

- **Testing Framework**: [Busted - Olivine Labs](https://github.com/olivine-labs/busted)
- **Referensi Komunitas**: [Lua-Users Wiki - Unit Testing](http://lua-users.org/wiki/UnitTesting)
- **Referensi Tambahan**: [Stack Overflow - Tagged 'lua+unit-testing+c-api'](https://stackoverflow.com/questions/tagged/lua+unit-testing+c-api)

---

### **Bagian X, Topik 42: Debugging Techniques**

Ketika terjadi bug, tantangannya adalah mengetahui apakah masalahnya ada di sisi C atau di sisi Lua. Anda memerlukan alat yang dapat melihat kedua dunia tersebut.

- **Menggunakan C Debugger (GDB)**: Ini adalah alat utama Anda untuk sisi C.
  - Anda menjalankan aplikasi host C Anda di bawah GDB (atau LLDB di macOS, atau debugger Visual Studio di Windows).
  - Anda dapat mengatur _breakpoints_ di dalam fungsi-fungsi C Anda, bahkan yang dipanggil dari Lua.
  - Saat breakpoint terpicu, Anda dapat memeriksa variabel C, memori, dan _call stack_ C.
  - **Kekuatan Tambahan**: Komunitas Lua telah mengembangkan skrip GDB yang memungkinkan Anda untuk memeriksa isi dari _virtual stack_ Lua (`lua_State *L`) langsung dari dalam GDB. Ini sangat kuat karena Anda dapat melihat dengan tepat data apa yang Lua kirimkan ke C saat terjadi masalah.
- **Menggunakan Lua Debugger**: Untuk men-debug logika skrip Lua itu sendiri, Anda dapat menggunakan debugger Lua. Ini akan memungkinkan Anda untuk melangkah baris per baris melalui kode Lua, memeriksa variabel Lua, dll. Debugger ini dibangun di atas Debug API yang kita bahas di Bagian VII.
- **Pendekatan Gabungan**: Sesi debugging yang efektif seringkali melibatkan penggunaan kedua alat tersebut, memungkinkan Anda untuk melompat antara perspektif C dan Lua untuk melacak sumber masalah.

#### **Sumber Referensi:**

- **Panduan GDB**: [Lua-Users Wiki - Debugging With Gdb](http://lua-users.org/wiki/DebuggingWithGdb)
- **Referensi Tambahan**: [Stack Overflow - Tagged 'lua+debugging+c-api'](https://stackoverflow.com/questions/tagged/lua+debugging+c-api)

---

### **Bagian X, Topik 43: Profiling dan Performance Analysis**

"Jangan menebak-nebak, ukur!" adalah mantra dari optimasi performa. _Profiling_ adalah proses mengukur di mana aplikasi Anda menghabiskan sebagian besar waktunya.

- **Dua Dunia untuk Di-profil**: Sama seperti debugging, Anda perlu menganalisis performa di kedua sisi.
  1.  **Profiling Kode C**: Gunakan alat standar seperti `gprof`, Valgrind (`callgrind`), atau `perf` (di Linux). Anda mengkompilasi aplikasi Anda dengan flag profiling, menjalankannya, dan alat tersebut akan menghasilkan laporan yang menunjukkan fungsi C mana yang paling memakan waktu CPU.
  2.  **Profiling Kode Lua**: Gunakan profiler khusus Lua.
      - **Sampling Profiler**: Secara berkala memeriksa fungsi Lua mana yang sedang berjalan. Overhead-nya rendah.
      - **Instrumenting Profiler**: Menggunakan Debug API (`lua_sethook`) untuk melacak setiap panggilan fungsi. Lebih akurat tetapi overhead-nya lebih tinggi.
      - **`stapxx`**: Contoh alat canggih untuk LuaJIT yang menggunakan SystemTap untuk profiling dengan overhead sangat rendah di lingkungan produksi.
- **Strategi**:
  1.  Lakukan profiling tingkat tinggi untuk menentukan apakah bottleneck utama ada di C atau Lua.
  2.  Jika di C, gunakan profiler C untuk menelusuri lebih dalam.
  3.  Jika di Lua, gunakan profiler Lua untuk menemukan skrip atau fungsi yang lambat.
  4.  Setelah "hotspot" ditemukan, Anda dapat memutuskan strategi optimasi: menulis ulang kode Lua agar lebih efisien, atau memindahkan fungsi Lua yang kritis tersebut ke C untuk performa maksimal.

#### **Sumber Referensi:**

- **Teknik Profiling**: [Lua-Users Wiki - Profiling Lua Code](http://lua-users.org/wiki/ProfilingLuaCode)
- **Contoh Alat**: [OpenResty stapxx](https://github.com/openresty/stapxx)

---

Dengan penguasaan atas testing, debugging, dan profiling, Anda kini memiliki siklus kerja rekayasa perangkat lunak yang lengkap. Anda tidak hanya dapat membangun fungsionalitas, tetapi juga memastikan fungsionalitas tersebut benar, andal, dan cepat.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

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
