
## 📚 **Bagian 9: Domain-Specific Applications**

Bagian ini menerapkan semua konsep yang telah dipelajari ke dalam domain aplikasi tertentu, menunjukkan bagaimana pola kontrol alur yang berbeda lebih cocok untuk masalah yang berbeda.

### 9.1 Kontrol Alur Pengembangan Game

**Durasi yang Disarankan:** 4-5 jam

Pengembangan game sangat bergantung pada kontrol alur untuk mengelola state, input, dan rendering setiap frame.

#### **Topik yang Dipelajari**

- **Game state management (Manajemen state game)**: Menggunakan pola _State_ atau _state machine_ untuk mengelola state game utama (misalnya, menu utama, bermain, jeda, game over).
- **Frame-based execution patterns (Pola eksekusi berbasis frame)**: Konsep _game loop_ (misalnya `love.update(dt)` dan `love.draw()` di LÖVE) adalah bentuk utama dari kontrol alur, di mana logika game diperbarui dan digambar ulang pada setiap frame.
- **Input handling control flow (Kontrol alur penanganan input)**: Menggunakan _Observer pattern_ atau _Command pattern_ untuk memetakan input pemain (keyboard, mouse) ke tindakan dalam game.
- **Animation and timing control (Kontrol animasi dan waktu)**: Menggunakan loop dan _timers_ untuk mengontrol animasi sprite, transisi, dan event berbasis waktu. Coroutine sering digunakan di sini untuk skrip sekuensial yang kompleks (misalnya, cutscene).

#### **Sumber Belajar (dari README.md)**:

- [Lua Coding Tutorial - Complete Guide](https://gamedevacademy.org/lua-coding-tutorial-complete-guide/)
- [LÖVE 2D Documentation](https://love2d.org/wiki/Main_Page)

---

### 9.2 Kontrol Alur Sistem Tertanam (Embedded)

**Durasi yang Disarankan:** 3-4 jam

Sistem tertanam (seperti mikrokontroler) memiliki kendala sumber daya (memori dan CPU terbatas) yang memengaruhi pilihan kontrol alur.

#### **Topik yang Dipelajari**

- **Real-time control patterns (Pola kontrol waktu-nyata)**: Menggunakan loop yang sangat ketat dan terprediksi untuk memastikan respons dalam batas waktu tertentu.
- **Interrupt handling simulation (Simulasi penanganan interupsi)**: Menggunakan _callbacks_ atau _hooks_ untuk merespons event perangkat keras, mirip dengan pola _Observer_.
- **Resource-constrained programming (Pemrograman dengan sumber daya terbatas)**: Menghindari alokasi memori yang sering di dalam loop utama untuk mencegah beban pada GC. Menggunakan kembali objek adalah kunci.
- **Deterministic execution patterns (Pola eksekusi deterministik)**: Menulis kode yang menghasilkan output yang sama persis untuk input yang sama persis, yang penting untuk pengujian dan keandalan. Hindari ketergantungan pada hal-hal yang tidak menentu.

#### **Sumber Belajar (dari README.md)**:

- [Control Flow in Lua - Stack Overflow](https://stackoverflow.com/questions/11191923/control-flow-in-lua)
- [Embedded Lua Programming](http://lua-users.org/wiki/EmbeddedLua)

---
