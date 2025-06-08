# **[Bagian 10: Real-World Applications][0]**

Setelah mendalami teori, pola, dan praktik terbaik, sekarang kita akan melihat bagaimana semua konsep function ini diterapkan dalam berbagai domain di dunia nyata. Bagian ini menunjukkan bagaimana function menjadi tulang punggung dalam berbagai bidang di mana Lua populer, mulai dari pengembangan web berkinerja tinggi hingga scripting game dan otomatisasi sistem.

**Daftar Isi Bagian 10:**

- [Pengembangan Web (Web Development)](#101-pengembangan-web-web-development)
- [Pengembangan Game (Game Development)](#102-pengembangan-game-game-development)
- [Pemrograman Sistem (System Programming)](#103-pemrograman-sistem-system-programming)

---

### 10.1 Pengembangan Web (Web Development)

Lua sering digunakan dalam pengembangan web, terutama di lingkungan yang menuntut performa tinggi, seperti di dalam server web Nginx melalui platform OpenResty, atau menggunakan framework seperti Lapis dan Sailor.

#### **Handler Functions**

Dalam konteks web, _handler_ adalah sebuah function yang bertanggung jawab untuk memproses permintaan (request) HTTP yang masuk dan menghasilkan sebuah respons.

- **Contoh (OpenResty):** Anda mendefinisikan function Lua yang akan dieksekusi pada berbagai fase dari siklus hidup request Nginx.

  ```lua
  -- dalam file nginx.conf
  -- location /api {
  --     content_by_lua_block {
  --         ngx.say("Halo dari handler Lua!")
  --     }
  -- }

  -- ngx.say adalah function yang disediakan OpenResty untuk mengirim respons.
  ```

#### **Middleware Patterns**

Middleware adalah sebuah function (atau serangkaian function) yang berada di antara server dan _route handler_ akhir. Middleware melakukan tugas-tugas umum seperti otentikasi, logging, atau modifikasi request/response.

- **Pola:** Middleware sering diimplementasikan sebagai rantai function (seringkali closure). Setiap function menerima request, melakukan tugasnya, dan kemudian memanggil function `next()` untuk meneruskan kontrol ke middleware berikutnya dalam rantai.

#### **Route Handlers**

Routing adalah proses memetakan sebuah URL dan metode HTTP (GET, POST, dll.) ke sebuah function handler spesifik. Framework web Lua menyediakan cara yang bersih untuk mendefinisikan rute-rute ini.

- **Contoh (Gaya Framework Lapis):**

  ```lua
  local lapis = require("lapis")
  local app = lapis.Application()

  -- Memetakan path "/" ke sebuah function handler anonim
  app:get("/", function(self)
      return "Selamat datang di halaman utama!"
  end)

  -- Memetakan path "/users/:id" ke handler lain
  app:get("/users/:id", function(self)
      local userId = self.params.id
      return "Anda melihat profil pengguna #" .. userId
  end)

  return app
  ```

#### **Template Functions**

Seperti yang telah dibahas sebelumnya, function digunakan untuk mem-parsing file template (misalnya, HTML) dan menyuntikkan data dinamis ke dalamnya untuk menghasilkan halaman web akhir yang dikirim ke browser pengguna.

---

### 10.2 Pengembangan Game (Game Development)

Lua sangat dominan sebagai bahasa scripting di industri game. Ia digunakan di berbagai engine dan framework, termasuk Roblox, Defold, Solar2D (sebelumnya Corona SDK), dan LÖVE (sering disebut Love2D). Functions adalah cara utama developer game menuliskan logika permainan.

#### **Event Handlers (Callbacks)**

Kebanyakan framework game modern berbasis event. Alih-alih satu loop tak terbatas yang Anda tulis sendiri, Anda mendefinisikan serangkaian function callback khusus yang akan dipanggil oleh engine pada waktu yang tepat.

- **Pola di LÖVE:** Framework LÖVE mengharapkan Anda untuk mendefinisikan beberapa function global utama.
  - `love.load()`: Dipanggil sekali saat game dimulai, biasanya untuk memuat aset seperti gambar dan suara.
  - `love.update(dt)`: Dipanggil di setiap frame. Di sinilah semua logika permainan (pergerakan, fisika, AI) diperbarui. Argumen `dt` adalah _delta time_—waktu yang telah berlalu sejak frame terakhir, penting untuk gerakan yang mulus.
  - `love.draw()`: Dipanggil di setiap frame setelah `update`, digunakan untuk menggambar semua elemen game ke layar.
  - `love.keypressed(key, scancode, isrepeat)`: Contoh event handler input, dipanggil setiap kali sebuah tombol keyboard ditekan.

#### **State Machines dengan Functions**

Manajemen state game (misalnya, menu utama, bermain, layar game over) sering diimplementasikan menggunakan pola State Machine. Setiap state dapat direpresentasikan sebagai sebuah table yang berisi sekumpulan function.

- **Contoh Pola:**

  ```lua
  StateMenu = {
      enter = function() print("Memasuki Menu Utama") end,
      update = function(dt) if love.keyboard.isDown("enter") then switchState(StatePlaying) end end,
      draw = function() love.graphics.print("Tekan Enter untuk Mulai", 300, 300) end
  }

  -- Di loop utama:
  function love.update(dt)
      currentState.update(dt)
  end
  ```

#### **AI Behavior Functions**

Logika kecerdasan buatan (AI) untuk karakter non-pemain (NPC) sering ditulis dalam Lua. Function dapat mendefinisikan perilaku sederhana ("jika pemain dekat, serang") atau menjadi bagian dari sistem yang lebih kompleks seperti _Behavior Trees_ atau _Finite State Machines_, di mana setiap "aksi" atau "state" adalah sebuah function Lua.

#### **Scripting Patterns**

Function memungkinkan desainer game untuk membuat skrip untuk event, quest, atau dialog tanpa perlu menyentuh kode inti engine (yang biasanya ditulis dalam C++). Engine akan memanggil function-function Lua ini berdasarkan nama pada saat yang tepat dalam permainan.

---

### 10.3 Pemrograman Sistem (System Programming)

Lua juga merupakan alat yang hebat untuk tugas-tugas pemrograman sistem, otomasi, dan sebagai "lem" yang merekatkan berbagai komponen perangkat lunak.

#### **File Processing Functions**

Function digunakan untuk membungkus logika pemrosesan file, membuat kode lebih bersih dan dapat digunakan kembali. Library standar `io` menyediakan blok bangunan dasar untuk ini.

#### **Network Handling**

Meskipun library standar Lua terbatas, ekosistemnya kaya akan modul untuk pemrograman jaringan. Modul-modul ini dapat ditemukan dan diinstal menggunakan **LuaRocks**, manajer paket untuk modul Lua. Library seperti `LuaSocket` menyediakan antarmuka berbasis function untuk membuat klien dan server TCP/UDP, menangani koneksi, dan mengirim data.

#### **Process Management**

Function `os.execute(command)` memungkinkan eksekusi perintah shell eksternal. Untuk kontrol yang lebih mendalam (seperti forking, piping, dan signal handling pada sistem mirip Unix), library eksternal seperti `luaposix` (tersedia di LuaRocks) menyediakan function-function yang memetakan langsung ke panggilan sistem POSIX.

#### **Configuration Functions**

Salah satu penggunaan Lua yang paling elegan adalah sebagai file konfigurasi itu sendiri. Daripada mem-parsing format kustom seperti INI atau XML, aplikasi utama cukup mengeksekusi skrip Lua konfigurasi menggunakan `dofile()`. Skrip ini kemudian menggunakan function-function yang disediakan oleh aplikasi utama untuk mengatur parameter.

- **Contoh:**
  ```lua
  -- dalam file config.lua
  set_window_size(1280, 720)
  set_fullscreen(false)
  add_user("admin", "password123")
  ```
  Pendekatan ini sangat fleksibel karena Anda mendapatkan kekuatan penuh dari bahasa pemrograman (loop, kondisi, function) untuk logika konfigurasi Anda.

---

**Sumber Referensi untuk Bagian 10:**

1.  OpenResty Best Practices - lua-resty-core Repository: [https://github.com/openresty/lua-resty-core](https://github.com/openresty/lua-resty-core)
2.  Lua-Users Wiki - Web Development: [http://lua-users.org/wiki/WebDevelopment](http://lua-users.org/wiki/WebDevelopment)
3.  Lua-Users Wiki - Game Development: [http://lua-users.org/wiki/GameDevelopment](http://lua-users.org/wiki/GameDevelopment)
4.  LÖVE Wiki - Main Page and Callbacks: [https://love2d.org/wiki/Main_Page](https://love2d.org/wiki/Main_Page), [https://love2d.org/wiki/love.update](https://love2d.org/wiki/love.update), [https://love2d.org/wiki/love.draw](https://love2d.org/wiki/love.draw), [https://love2d.org/wiki/love.keypressed](https://love2d.org/wiki/love.keypressed)
5.  Lua-Users Wiki - System Programming: [http://lua-users.org/wiki/SystemProgramming](http://lua-users.org/wiki/SystemProgramming)
6.  LuaRocks - The Lua package manager: [https://luarocks.org/](https://luarocks.org/)

---

Kita telah menyelesaikan Bagian 10. Kurikulum Anda masih memiliki tiga bagian terakhir yang sangat teknis dan menarik: Serialisasi, Iterator Kustom, dan Sandboxing. Selanjutnya kita akan membahas **Bagian 11: Function Serialization dan Persistence**.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../bagian-9/README.md
[selanjutnya]: ../bagian-11/README.md

<!----------------------------------------------------->

[0]: ../../function/README.md#bagian-10-devemopment-web-game-and-programming-system
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
