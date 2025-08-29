# **[Kurikulum Lengkap Love2D: Dari Pemula Hingga Mahir (Versi Diperluas)][0]**

Kurikulum ini disusun secara sistematis untuk membangun pengetahuan Anda dari dasar hingga mahir. Topik-topik telah diperkaya dengan pola desain, arsitektur, dan teknik modern untuk memastikan Anda tidak hanya dapat membuat game, tetapi juga merancangnya dengan baik.

---

### Modul 1: Fondasi dan PersiapanTentu, berikut adalah kurikulum yang Anda minta, lengkap dengan tautan sumber yang relevan:

## Kurikulum Lengkap Love2D: Dari Pemula Hingga Mahir (Versi Diperluas)

Kurikulum ini disusun secara sistematis untuk membangun pengetahuan Anda dari dasar hingga mahir. Topik-topik telah diperkaya dengan pola desain, arsitektur, dan teknik modern untuk memastikan Anda tidak hanya dapat membuat game, tetapi juga merancangnya dengan baik.

---

### Modul 1: Fondasi dan Persiapan

- 1.1. **Apa itu LÖVE?**

  - Memahami filosofi dan kemampuan framework.
  - Sumber: [Halaman Utama Love2D](https://love2d.org/)

- 1.2. **Instalasi LÖVE**

  - Menginstal LÖVE di Windows, macOS, atau Linux.
  - Sumber: [Panduan Memulai - Love2D Wiki](https://love2d.org/wiki/Getting_Started)

- 1.3. **Pengantar Bahasa Pemrograman Lua**

  - LÖVE menggunakan Lua. Anda harus memahami sintaks dasar, tipe data, tabel (sangat penting\!), dan fungsi di Lua.

  - Sumber: [Belajar Lua dalam Y Menit (Panduan Cepat)](https://learnxinyminutes.com/docs/lua/)
  - Sumber Tambahan (Mendalam): [Buku Programming in Lua (Edisi Pertama Gratis)](https://www.lua.org/pil/contents.html)

- 1.4. **Struktur Proyek LÖVE**

  - Memahami peran file `main.lua`, `conf.lua`, dan cara menjalankan proyek.
  - Sumber: [Struktur Proyek - Love2D Wiki](https://www.google.com/search?q=https://love2d.org/wiki/Game_Distribution%23The_game_.love_file)

---

### Modul 2: Konsep Inti LÖVE

Modul ini mencakup fungsi-fungsi utama yang menjadi tulang punggung setiap game di LÖVE.

- 2.1. **Game Loop: load, update, draw**

  - Memahami alur eksekusi utama dalam sebuah game LÖVE.
  - Sumber: [Callback Utama love - Love2D Wiki](https://love2d.org/wiki/Category:Callbacks)

- 2.2. **Menggambar Bentuk Dasar**

  - Menggambar persegi, lingkaran, garis, dan poligon.
  - Sumber: [Modul love.graphics - Love2D Wiki](https://love2d.org/wiki/love.graphics)

- 2.3. **Sistem Koordinat dan Warna**

  - Memahami bagaimana koordinat (x, y) bekerja dan cara mengatur warna.
  - Sumber: [Fungsi love.graphics.setColor - Love2D Wiki](https://love2d.org/wiki/love.graphics.setColor)

- 2.4. **Menangani Input (Keyboard & Mouse)**

  - Mendeteksi penekanan tombol dan klik mouse.
  - Sumber (Keyboard): [Modul love.keyboard - Love2D Wiki](https://love2d.org/wiki/love.keyboard)
  - Sumber (Mouse): [Modul love.mouse - Love2D Wiki](https://love2d.org/wiki/love.mouse)

- 2.5. **Waktu dan Delta Time (dt)**
  - Konsep krusial untuk membuat gerakan yang mulus dan tidak bergantung pada kecepatan komputer.
  - Sumber: [Penjelasan love.update(dt) - Love2D Wiki](https://love2d.org/wiki/love.update)
  - Sumber Konseptual (Sangat Direkomendasikan): [Artikel "Fix Your Timestep\!" oleh Gaffer on Games](https://gafferongames.com/post/fix_your_timestep/)

---

### Modul 3: Grafis dan Aset Visual

Meningkatkan tampilan game Anda dari bentuk dasar menjadi dunia yang lebih hidup.

- 3.1. **Memuat dan Menampilkan Gambar (Sprite)**

  - Sumber: [Fungsi love.graphics.newImage - Love2D Wiki](https://love2d.org/wiki/love.graphics.newImage)

- 3.2. **Sprite Sheets dan Quads**

  - Teknik efisien untuk mengelola banyak gambar atau animasi dalam satu file.
  - Sumber: [Fungsi love.graphics.newQuad - Love2D Wiki](https://love2d.org/wiki/love.graphics.newQuad)

- 3.3. **Animasi Frame-by-Frame**

  - Ini adalah konsep, bukan fungsi tunggal. Tutorial ini menjelaskannya dengan baik.
  - Sumber: [Tutorial Animasi Sederhana - Simple Game Tutorials](https://www.google.com/search?q=https://www.youtube.com/watch%3Fv%3DF0S0-n0y6rA) (Cari tutorial animasi Love2D frame by frame)

- 3.4. **Teks dan Font**

  - Menampilkan teks dengan berbagai jenis font.
  - Sumber: [Fungsi love.graphics.print dan newFont - Love2D Wiki](https://love2d.org/wiki/love.graphics.print) dan [love.graphics.newFont - Love2D Wiki](https://love2d.org/wiki/love.graphics.newFont)

- 3.5. **Sistem Partikel (Particle Systems)**

  - Untuk efek seperti ledakan, asap, atau sihir.
  - Sumber: [Modul love.graphics.newParticleSystem - Love2D Wiki](https://love2d.org/wiki/love.graphics.newParticleSystem)

- 3.6. **Transformasi Grafis (Translate, Rotate, Scale)**

  - Menggerakkan, memutar, dan mengubah ukuran dunia game atau objek.
  - Sumber: [Stack Transformations (push, pop) - Love2D Wiki](https://love2d.org/wiki/love.graphics.push) dan [love.graphics.pop - Love2D Wiki](https://love2d.org/wiki/love.graphics.pop)

- 3.7. **Menggunakan Canvas (Rendering ke Tekstur)**
  - Menggambar ke tekstur tak terlihat untuk efek post-processing (seperti blur, bloom), peta cahaya, atau mini-map.
  - Sumber: [Modul love.graphics.newCanvas - Love2D Wiki](https://love2d.org/wiki/love.graphics.newCanvas)
  - Sumber Konseptual: [Tutorial Canvas - Sheepolution](https://www.google.com/search?q=https://sheepolution.com/learn/book/canvas)

---

### Modul 4: Audio

Menambahkan suara dan musik untuk membuat game lebih imersif.

- 4.1. **Memuat dan Memainkan Audio**
  - Membedakan antara efek suara (singkat) dan musik latar (panjang).
  - Sumber: [Modul love.audio - Love2D Wiki](https://love2d.org/wiki/love.audio)
  - Sumber: [Objek Source untuk Audio - Love2D Wiki](https://love2d.org/wiki/Source)

---

### Modul 5: Fisika dan Tabrakan

Membuat objek berinteraksi satu sama lain secara realistis.

- 5.1. **Deteksi Tabrakan Sederhana (AABB)**

  - Sebelum menggunakan mesin fisika, penting untuk memahami deteksi tabrakan manual.
  - Sumber Konseptual: [Tutorial Tabrakan AABB - MDN Web Docs (Konsepnya sama)](https://developer.mozilla.org/en-US/docs/Games/Techniques/2D_collision_detection)

- 5.2. **Pengenalan Mesin Fisika (love.physics)**

  - Memahami konsep World, Body, Shape, dan Fixture yang digunakan oleh Box2D.
  - Sumber: [Modul love.physics - Love2D Wiki](https://love2d.org/wiki/love.physics)

- 5.2.1. **Tipe-Tipe Body Fisika**

  - Memahami perbedaan fundamental antara Static (dinding), Dynamic (pemain), dan Kinematic (platform bergerak).
  - Sumber: [Penjelasan BodyType - Love2D Wiki](https://love2d.org/wiki/BodyType)

- 5.3. **Callback Tabrakan**
  - Mendeteksi kapan dua objek fisika mulai atau berhenti bersentuhan.
  - Sumber: [Callback pada objek World (beginContact) - Love2D Wiki](https://www.google.com/search?q=https://love2d.org/wiki/World:beginContact)

---

### Modul 6: Arsitektur Game dan Manajemen State

Topik arsitektural yang membedakan proyek kecil dari game yang terstruktur dengan baik dan dapat dikelola.

- 6.1. **Game States / Scene Management**

  - Mengelola berbagai layar game (menu utama, permainan, layar game over).
  - Sumber Konseptual: [Tutorial Game States - TUTSJAKE](https://www.google.com/search?q=https://www.youtube.com/watch%3Fv%3DF0S0-n0y6rA%26list%3DPLpT3tG4dYyvJ8_vB3Jp1r7_1f6_1f6_1f6_1f6_1f6_1f6_1f6_1f6%26index%3D6) (Cari tutorial manajemen state Love2D)
  - Sumber Pustaka Populer: [Pustaka hump.gamestate](https://github.com/vrld/hump/blob/master/gamestate.lua)

- 6.2. **Object-Oriented Programming (OOP) di Lua**

  - Mengorganisir kode ke dalam "kelas" dan "objek" untuk pemain, musuh, dll.
  - Sumber Konseptual: [Penjelasan OOP di Lua - Dev.to](https://www.google.com/search?q=https://dev.to/matheuscpereira/object-oriented-programming-in-lua-1n9e)
  - Sumber Pustaka Populer: [Pustaka 30log untuk OOP](https://www.google.com/search?q=https://github.com/airstrike/30log)

- 6.3. **Kamera (Camera)**

  - LÖVE tidak memiliki objek kamera bawaan. Anda harus membuatnya sendiri untuk mengikuti pemain atau menggerakkan dunia.
  - Sumber Konseptual: [Tutorial Kamera 2D - KidsCanCode (Prinsipnya berlaku untuk LÖVE)](https://www.google.com/search?q=https://kidscancode.org/godot_recipes/2d/camera/)
  - Sumber Pustaka Populer: [Pustaka hump.camera](https://github.com/vrld/hump/blob/master/camera.lua)

- 6.4. **Pola Arsitektur Alternatif: Entity-Component-System (ECS)**

  - Paradigma yang mengutamakan komposisi daripada pewarisan, sangat baik untuk game dengan banyak entitas dan perilaku yang dinamis.
  - Sumber Konseptual: [Pengantar ECS - Gamedev.net](https://www.google.com/search?q=https://www.gamedev.net/articles/programming/general-and-gameplay-programming/a-simple-entity-component-system-r2868/)
  - Sumber Pustaka Populer: [Pustaka tiny-ecs](https://github.com/bakpakin/tiny-ecs)

- 6.5. **Komunikasi Terpisah: Event/Signal System**
  - Memungkinkan berbagai bagian dari game (misal: UI dan Player) berkomunikasi tanpa harus saling terhubung langsung, mencegah kode menjadi kusut.
  - Sumber Pustaka Populer: [Pustaka hump.signal](https://github.com/vrld/hump/blob/master/signal.lua)

---

### Modul 7: Topik Lanjutan dan "Game Feel"

Fitur-fitur untuk membawa game Anda ke level selanjutnya dan membuatnya terasa lebih hidup.

- 7.1. **Shaders (GLSL)**

  - Memprogram kartu grafis secara langsung untuk efek visual kustom.
  - Sumber: [Modul love.graphics.newShader - Love2D Wiki](https://love2d.org/wiki/love.graphics.newShader)
  - Sumber Pengantar: [The Book of Shaders (Bacaan wajib untuk konsep shader)](https://thebookofshaders.com/)

- 7.2. **Menyimpan dan Memuat Data (love.filesystem)**

  - Untuk menyimpan skor tertinggi, progres game, dll.
  - Sumber: [Modul love.filesystem - Love2D Wiki](https://love2d.org/wiki/love.filesystem)

- 7.3. **Antarmuka Pengguna (UI)**

  - Membuat tombol, slider, dan elemen UI lainnya.
  - Sumber Pustaka Populer: [Pustaka SUIT (Simple User Interface Toolkit)](https://github.com/vrld/SUIT)

- 7.4. **Jaringan (love.network)**

  - Dasar-dasar untuk membuat game multiplayer.
  - Sumber: [Modul love.network - Love2D Wiki](https://www.google.com/search?q=https://love2d.org/wiki/love.network)

- 7.5. **Animasi Halus dengan Tweening**

  - Membuat transisi properti yang mulus (gerakan, ukuran, warna) untuk antarmuka atau objek game agar terasa lebih "juicy" dan profesional.
  - Sumber Pustaka Populer: [Pustaka hump.tween](https://www.google.com/search?q=https://github.com/vrld/hump/blob/master/tween.lua)

- 7.6. **Scripting Sekuensial dengan Coroutines**

  - Fitur Lua yang sangat kuat untuk mengelola urutan kejadian (seperti cutscenes, dialog, atau pola serangan AI) tanpa menghentikan game loop utama.
  - Sumber Konseptual: [Menggunakan Coroutines di Game - TUTSJAKE](https://www.google.com/search?q=https://www.youtube.com/watch%3Fv%3DsM3ZlK6E1kM) (Cari tutorial coroutine di game development)

- 7.7. **Dasar-dasar Generasi Konten Prosedural (PCG)**
  - Menciptakan level, medan, atau item secara algoritmik untuk meningkatkan replayability.
  - Sumber Konseptual (Noise): [Memahami Perlin Noise](https://www.google.com/search?q=https://catlikecoding.com/unity/tutorials/noise/)
  - Sumber Pustaka Populer (Noise): [Pustaka luanoise](https://www.google.com/search?q=https://github.com/mkottman/luanoise)

---

### Modul 8: Distribusi dan Rilis

Setelah game Anda selesai, bagikan kepada dunia\!

- 8.1. **Mengemas Game Anda**
  - Membuat file `.love` dan menggabungkannya menjadi aplikasi mandiri (`.exe`, `.app`).
  - Sumber: [Panduan Distribusi Game - Love2D Wiki](https://love2d.org/wiki/Game_Distribution)

---

### Modul 9: Komunitas dan Sumber Daya Eksternal

Tempat untuk bertanya, belajar lebih lanjut, dan menemukan pustaka siap pakai.

- 9.1. **Komunitas LÖVE**

  - Sumber: [Forum Resmi Love2D](https://love2d.org/forums/)
  - Sumber: [Server Discord Love2D](https://www.google.com/search?q=https://discord.com/invite/love2d)
    Sumber: [Komunitas LÖVE di Reddit](https://www.reddit.com/r/love2d/)

- 9.2. **Awesome-Love2D**
  - Daftar pustaka, proyek, dan sumber daya yang sangat lengkap yang dikurasi oleh komunitas.
  - Sumber: [Daftar Awesome-Love2D di GitHub](https://github.com/love2d-community/awesome-love2d)

#

<!-- > - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]** -->

> - **[Ke Atas](#)**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**
> - **[Tugas][tugas]**

[domain]: ../../domain-spesifik/README.md
[kurikulum]: ../../domain-spesifik/embeddeble/lua/README.md
[tugas]: ../../../../README.md

<!-- [sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md -->

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../
<!-- [2]: ../
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
[18]: ../ -->
