## Daftar Isi Pembahasan: Modul 1

- [**Modul 1: Lingkungan & Persiapan**](#modul-1-lingkungan--persiapan)
  - [1. Topik 001: Selamat Datang di Dunia Lua](#topik-001-selamat-datang-di-dunia-lua)
  - [2. Topik 002: Filosofi Lua](#topik-002-filosofi-lua)
  - [3. Topik 003: Sejarah Lua](#topik-003-sejarah-lua)
  - [4. Topik 004: Mengapa Lua Digunakan](#topik-004-mengapa-lua-digunakan)
  - [5. Topik 005: Instalasi Lua](#topik-005-instalasi-lua)
  - [6. Topik 006: Lua vs Bahasa Lain](#topik-006-lua-vs-bahasa-lain)
  - [7. Topik 007: Editor/IDE](#topik-007-editoride)
  - [8. Topik 008: Penguasaan Command Line](#topik-008-penguasaan-command-line)
  - [9. Topik 009: Penggunaan REPL](#topik-009-penggunaan-repl)
  - [10. Topik 010: Skrip Lua Pertama](#topik-010-skrip-lua-pertama)
  - [11. Topik 011: Argumen Skrip](#topik-011-argumen-skrip)
  - [12. Topik 012: Konfigurasi Lingkungan](#topik-012-konfigurasi-lingkungan)

---

## **Modul 1: Lingkungan & Persiapan**

Modul ini adalah fondasi dari segala fondasi. Tujuannya adalah untuk menyiapkan "bengkel kerja" Anda dan memahami "jiwa" dari alat yang akan kita gunakan. Tanpa pemahaman di sini, belajar coding akan terasa seperti mencoba merakit furnitur tanpa membaca manualnya terlebih dahulu.

### **Topik 001: Selamat Datang di Dunia Lua**

- **Referensi Resmi:** [Beranda Lua.org](https://www.lua.org/)

**Deskripsi Konkret**
Selamat datang\! Lua adalah sebuah bahasa pemrograman. Anggap saja seperti bahasa manusia (misalnya Inggris atau Jepang), tetapi dirancang khusus untuk memberi perintah kepada komputer. Lua dikenal karena **kecil**, **cepat**, dan **mudah dipelajari**. Nama "Lua" (diucapkan "LU-ah") berasal dari bahasa Portugis yang berarti "Bulan" 🌙.

**Konsep Inti & Terminologi**

- **Bahasa Pemrograman (Programming Language):** Sekumpulan aturan (sintaks) dan kata-kata (kata kunci) yang memungkinkan manusia menulis instruksi yang dapat dimengerti dan dijalankan oleh komputer.
- **Skrip (Script):** Sebuah file teks yang berisi instruksi-instruksi dalam bahasa pemrograman. Komputer akan membaca skrip ini dari atas ke bawah dan melakukan apa yang diperintahkan.
- **Interpreter:** Program khusus yang tugasnya membaca skrip Anda baris per baris, menerjemahkannya menjadi bahasa mesin yang dimengerti komputer secara langsung, dan menjalankannya. Lua adalah bahasa yang di-_interpret_ (interpreted language), berbeda dengan bahasa yang di-_compile_ (seperti C++ atau Java) di mana seluruh skrip harus diterjemahkan terlebih dahulu menjadi satu file program yang bisa dieksekusi.

**Analogi untuk Pemula**
Bayangkan Anda ingin seorang koki membuatkan kue.

- **Resep** adalah **Skrip Lua** Anda. Isinya langkah-langkah detail.
- **Anda** yang membacakan resep itu kepada koki adalah **Interpreter Lua**.
- **Koki** adalah **Komputer**.
  Anda membaca resep satu per satu ("Masukkan 3 butir telur"), dan koki langsung mengerjakannya. Anda tidak memberikan seluruh buku resep kepada koki untuk dibaca sendiri; Anda menafsirkannya untuknya.

**Menuju Praktik**
Dalam tutorial praktik, langkah pertama kita adalah memastikan "dapur" kita (komputer) sudah memiliki "koki" dan "pembaca resep" (interpreter Lua). Kita akan mengunduh dan menginstalnya. Tidak ada kode yang ditulis di tahap ini, hanya persiapan.

### **Topik 002: Filosofi Lua**

- **Referensi Resmi:** [Tentang Lua](https://www.lua.org/about.html)

**Deskripsi Konkret**
Setiap alat diciptakan dengan sebuah tujuan atau filosofi. Filosofi Lua adalah menjadi bahasa yang **sederhana, kecil, portabel, cepat, dan mudah ditanamkan (embeddable)**. Lua tidak mencoba menjadi "satu bahasa untuk semua masalah". Sebaliknya, ia dirancang untuk menjadi bagian dari sebuah sistem yang lebih besar, seperti "lem super" yang bisa menghubungkan berbagai komponen perangkat lunak.

**Konsep Inti & Terminologi**

- **Minimalis (Minimalism):** Lua hanya menyediakan fitur-fitur yang paling esensial. Banyak fungsionalitas canggih (seperti OOP) tidak "terpasang" secara bawaan, tetapi dapat "dirakit" menggunakan mekanisme dasar yang disediakan. Ini membuat inti bahasanya sangat kecil dan mudah dipahami.
- **Portabel (Portable):** Kode Lua ditulis dalam standar ANSI C, yang berarti interpreter Lua dapat dijalankan di hampir semua platform, dari server raksasa hingga perangkat mikrokontroler kecil, tanpa perlu banyak perubahan.
- **Embeddable:** Ini adalah filosofi kunci Lua. Lua dirancang agar sangat mudah "ditanamkan" atau diintegrasikan ke dalam aplikasi yang ditulis dalam bahasa lain (biasanya C/C++). Aplikasi utama akan menangani tugas-tugas berat (misalnya rendering grafis 3D), sementara Lua digunakan untuk menulis logika yang lebih fleksibel (misalnya perilaku musuh dalam game, konfigurasi UI).

**Analogi untuk Pemula**
Bayangkan Anda membangun rumah dari balok LEGO.

- Bahasa seperti C++ atau Java adalah balok-balok LEGO yang besar dan spesifik (dinding, jendela, pintu). Mereka kuat tapi kaku.
- Lua adalah gumpalan **tanah liat (clay)** yang bisa Anda bentuk menjadi apapun. Anda tidak akan membangun seluruh rumah dari tanah liat, tetapi Anda akan menggunakannya untuk mengisi celah, membuat hiasan unik, atau menyatukan dua bagian LEGO yang tidak pas. Fleksibilitasnya adalah kekuatannya.

**Menuju Praktik**
Memahami filosofi ini membantu kita memilih masalah yang tepat untuk diselesaikan dengan Lua. Dalam tutorial kita, kita akan memulai dengan skrip sederhana yang menunjukkan bagaimana Lua bisa melakukan tugas-tugas kecil dengan efisien, sebelum kita menanamkannya dalam proyek LÖVE2D yang lebih besar.

### **Topik 003: Sejarah Lua**

- **Referensi Resmi:** [Sejarah Lua](https://www.lua.org/history.html)

**Deskripsi Konkret**
Lua lahir pada tahun 1993 di Tecgraf (sekarang bagian dari PUC-Rio, sebuah universitas di Brasil). Para penciptanya—Roberto Ierusalimschy, Luiz Henrique de Figueiredo, dan Waldemar Celes—membutuhkan bahasa skrip yang sederhana untuk proyek-proyek rekayasa dan visualisasi data mereka. Mereka tidak menemukan yang cocok, jadi mereka membuatnya sendiri. Sejarah ini penting karena menjelaskan mengapa Lua sangat berfokus pada portabilitas dan kemudahan integrasi dengan C/C++.

**Konsep Inti & Terminologi**

- **In-house:** Awalnya dikembangkan untuk kebutuhan internal sebuah organisasi, bukan untuk publik.
- **Open Source:** Sejak awal, kode sumber Lua tersedia secara bebas untuk dilihat, dimodifikasi, dan didistribusikan oleh siapa saja, yang mendorong adopsinya secara luas.

**Analogi untuk Pemula**
Bayangkan seorang mekanik handal yang tidak bisa menemukan kunci pas dengan ukuran yang pas untuk memperbaiki mobil langka. Akhirnya, ia memutuskan untuk membuat kunci pas sendiri di bengkelnya. Kunci pas itu ternyata sangat bagus dan serbaguna sehingga mekanik lain mulai meminta untuk dibuatkan juga. Itulah Lua.

**Menuju Praktik**
Sejarah ini tidak memiliki dampak langsung pada kode yang kita tulis, tetapi memberikan konteks. Kita akan melihat jejak sejarah ini saat nanti mempelajari C API (Modul 14), yang merupakan "pintu" untuk menanamkan Lua ke aplikasi lain, sebuah tujuan yang sudah ada sejak kelahirannya.

### **Topik 004: Mengapa Lua Digunakan**

- **Referensi Resmi:** [Penggunaan Lua](https://www.lua.org/uses.html)

**Deskripsi Konkret**
Karena filosofinya yang unik, Lua sangat populer di domain-domain tertentu di mana kecepatan, fleksibilitas, dan ukuran kecil menjadi prioritas.

- **Pengembangan Game:** Ini adalah "rumah" terbesar Lua. Banyak game engine (seperti _Roblox_, _World of Warcraft_, _Angry Birds_, _Celeste_) menggunakannya untuk skrip logika game, desain level, dan perilaku AI.
- **Aplikasi Web:** Terutama dengan platform OpenResty, yang menanamkan Lua ke dalam web server Nginx untuk menangani jutaan permintaan dengan sangat cepat.
- **Sistem Embedded:** Digunakan dalam perangkat keras seperti router, TV, dan mikrokontroler (misalnya NodeMCU) untuk konfigurasi dan otomasi.
- **Plugin Aplikasi:** Program seperti _Adobe Lightroom_, _Redis_, dan _Neovim_ menggunakan Lua untuk memungkinkan pengguna menulis plugin dan memperluas fungsionalitasnya.

**Menuju Praktik**
Dengan memilih LÖVE2D sebagai framework praktik kita, kita langsung terjun ke salah satu domain paling populer untuk Lua: pengembangan game. Ini akan memberikan kita pengalaman langsung tentang mengapa Lua begitu dicintai di industri ini.

### **Topik 005: Instalasi Lua**

- **Referensi Resmi:** [Unduh & Instal](https://www.lua.org/download.html)
- **Sumber Tambahan:**
  - **Untuk Windows:** [LuaForWindows (berbasis Lua 5.1, bagus untuk memulai)](https://github.com/rjpcomputing/luaforwindows/releases) atau [Scoop](https://scoop.sh/) (`scoop install lua`).
  - **Untuk macOS:** [Homebrew](https://brew.sh/) (`brew install lua`).
  - **Untuk Linux:** Manajer paket bawaan (`sudo apt-get install lua5.4` untuk Debian/Ubuntu, `sudo dnf install lua` untuk Fedora).

**Deskripsi Konkret**
Untuk mulai menggunakan Lua, kita perlu menginstal **interpreter Lua** di komputer kita. Interpreter ini adalah program yang akan membaca dan menjalankan skrip Lua kita. Proses instalasinya bervariasi tergantung pada sistem operasi Anda (Windows, macOS, atau Linux).

**Konsep Inti & Terminologi**

- **Binary:** File program yang sudah jadi dan siap dijalankan. Anda tinggal mengunduh dan menjalankannya.
- **Source Code:** Kode sumber mentah dari interpreter Lua itu sendiri. Opsi ini untuk pengguna tingkat lanjut yang ingin meng-_compile_ (membangun) program dari awal.
- **Package Manager (Manajer Paket):** Alat bantu di macOS dan Linux (seperti Homebrew, APT, DNF) yang mengotomatiskan proses pengunduhan, instalasi, dan pembaruan perangkat lunak. Ini adalah cara yang paling direkomendasikan.
- **PATH Environment Variable:** Sebuah "daftar alamat" yang digunakan oleh sistem operasi Anda untuk menemukan program. Setelah Lua terinstal, kita perlu memastikan lokasinya ditambahkan ke PATH agar kita bisa memanggilnya dari direktori mana pun di terminal.

**Visualisasi Sederhana: PATH**

```
Anda di Terminal: > lua myscript.lua

Sistem Operasi: "Hmm, apa itu 'lua'? Mari kita cari di daftar alamat (PATH)."

PATH = [
  C:\Windows\System32,
  C:\Program Files\Git\bin,
  C:\Program Files\Lua\bin  <-- "Aha! Ketemu! Programnya ada di sini."
]

Sistem Operasi: (Menjalankan C:\Program Files\Lua\bin\lua.exe dengan myscript.lua)
```

**Menuju Praktik**
Ini adalah **langkah praktik pertama** dalam tutorial kita.

1.  Buka terminal atau command prompt.
2.  Ikuti instruksi instalasi untuk sistem operasi Anda.
3.  Setelah selesai, ketik `lua -v` dan tekan Enter. Jika instalasi berhasil, Anda akan melihat sesuatu seperti `Lua 5.4.6`. Ini adalah konfirmasi bahwa "pembaca resep" kita sudah siap di "dapur".

### **Topik 006: Lua vs Bahasa Lain**

- **Referensi Resmi:** [Fitur Lua](https://www.lua.org/about.html#features)

**Deskripsi Konkret**
Memahami Lua seringkali lebih mudah dengan membandingkannya dengan bahasa lain yang mungkin pernah Anda dengar. Perbandingan ini bukan untuk menentukan mana yang "terbaik", tetapi untuk memahami "kapan" dan "mengapa" kita memilih Lua.

**Konsep Inti & Perbandingan**

- **Lua vs. Python:**

  - **Python:** Dianggap sebagai bahasa skrip _general-purpose_ (serba guna) yang "sudah termasuk baterai" (_batteries included_). Python datang dengan pustaka standar yang sangat besar untuk pengembangan web, analisis data, AI, dll. Ia adalah pisau Swiss Army yang hebat.
  - **Lua:** Adalah pisau bedah. Sangat kecil, sangat tajam, dan dirancang untuk satu pekerjaan utama: menjadi bahasa skrip yang cepat dan ringan yang dapat ditanamkan di dalam aplikasi lain. Lua tidak datang dengan pustaka web atau AI; Anda menambahkannya sesuai kebutuhan.

- **Lua vs. C++ / C\# / Java:**

  - **C++ / C\# / Java:** Ini adalah bahasa _systems-level_ atau _enterprise-level_ yang besar, kuat, dan biasanya di-_compile_. Mereka digunakan untuk membangun fondasi aplikasi: game engine, sistem operasi, aplikasi perbankan. Mereka sangat cepat dalam eksekusi tetapi lebih lambat dalam pengembangan dan lebih rumit.
  - **Lua:** Seringkali hidup _di dalam_ aplikasi C++. Game engine ditulis dalam C++, tetapi logika misi atau perilaku item ditulis dalam Lua. Ini memungkinkan desainer dan penulis skrip untuk mengubah game tanpa perlu meng-_compile_ ulang seluruh engine, mempercepat proses pengembangan secara dramatis.

**Analogi untuk Pemula**
Bayangkan membangun sebuah mobil balap Formula 1.

- **C++** adalah **mesin, sasis, dan suspensi**. Ini adalah inti rekayasa yang kompleks, membutuhkan presisi tinggi, dan memberikan performa maksimal.
- **Python** adalah **seluruh garasi Anda**, lengkap dengan semua alat, komputer diagnostik, dan suku cadang. Anda bisa membangun banyak hal dengannya.
- **Lua** adalah **laptop yang dibawa pembalap ke dalam kokpit**. Laptop ini terhubung ke mesin utama dan digunakan untuk melakukan _tuning_ secara _real-time_: menyesuaikan campuran bahan bakar, strategi pengereman, dll. Ia kecil, cepat, dan terintegrasi erat dengan sistem utama untuk memberikan fleksibilitas.

**Menuju Praktik**
Pemahaman ini akan menjadi jelas saat kita menggunakan LÖVE2D. LÖVE2D sendiri (engine-nya) ditulis dalam C++. Namun, semua kode yang _kita_ tulis untuk membuat game akan berada dalam Lua. Kita akan merasakan langsung sinergi antara sistem performa tinggi (engine) dan skrip fleksibel (kode game kita).

### **Topik 007: Editor/IDE**

- **Referensi Komunitas:** [Dukungan Editor](https://lua-users.org/wiki/LuaEditorSupport)

**Deskripsi Konkret**
Anda bisa menulis kode Lua di editor teks paling sederhana sekalipun (seperti Notepad), tetapi menggunakan alat yang tepat akan membuat hidup Anda jauh lebih mudah. Alat-alat ini terbagi dalam dua kategori: Editor Teks dan IDE.

**Konsep Inti & Terminologi**

- **Editor Teks (Code Editor):** Program ringan untuk menulis kode. Editor modern memiliki fitur seperti:
  - **Syntax Highlighting:** Memberi warna berbeda pada kata kunci, string, dan angka agar kode lebih mudah dibaca.
  - **Auto-completion:** Menyarankan nama fungsi atau variabel saat Anda mengetik.
  - **Linting:** Menandai potensi kesalahan atau pelanggaran gaya penulisan kode secara langsung.
- **IDE (Integrated Development Environment):** "Paket lengkap" yang lebih berat. IDE mencakup semua fitur editor teks, ditambah:
  - **Debugger:** Alat untuk menjalankan kode baris per baris untuk menemukan bug.
  - **Integrasi Build System:** Tombol untuk meng-_compile_ atau menjalankan proyek kompleks.
  - **Manajemen Proyek:** Fitur untuk mengelola banyak file dalam sebuah proyek.

**Rekomendasi untuk Pemula**
**Visual Studio Code (VS Code)** adalah pilihan terbaik saat ini. Ia adalah editor teks yang sangat kuat dan dapat diubah menjadi IDE yang nyaris sempurna dengan beberapa ekstensi.

- **Link Unduh:** [https://code.visualstudio.com/](https://code.visualstudio.com/)
- **Ekstensi Esensial untuk Lua:**
  - [**Lua by sumneko**](https://marketplace.visualstudio.com/items?itemName=sumneko.lua): Ini adalah standar emas. Memberikan analisis kode, auto-completion, dan pemformatan yang sangat canggih.
  - [**vscode-lua**](https://marketplace.visualstudio.com/items?itemName=trixnz.vscode-lua): Alternatif lain yang juga populer.

**Menuju Praktik**
Langkah praktik kedua kita adalah:

1.  Unduh dan instal Visual Studio Code.
2.  Buka tab Ekstensi (icon balok di sisi kiri).
3.  Cari "Lua" dan instal ekstensi `sumneko.lua`.
4.  Sekarang "bengkel kerja" kita sudah memiliki meja kerja yang canggih.

### **Topik 008: Penguasaan Command Line**

- **Referensi Resmi:** [Interpreter Standalone](https://www.lua.org/manual/5.4/manual.html#6)

**Deskripsi Konkret**
_Command Line Interface_ (CLI), juga dikenal sebagai **Terminal** (di macOS/Linux) atau **Command Prompt/PowerShell** (di Windows), adalah cara berinteraksi dengan komputer menggunakan perintah berbasis teks. Bagi seorang programmer, ini adalah alat yang fundamental, seperti palu bagi seorang tukang kayu. Anda akan menggunakannya untuk menjalankan skrip, mengelola file, dan menggunakan alat-alat pengembangan lainnya.

**Konsep Inti & Perintah Dasar**

- **Prompt:** Simbol yang menunjukkan terminal siap menerima perintah (misalnya `$` atau `>`).
- **Direktori (Folder):** Lokasi file di komputer Anda.
- **Perintah Dasar yang Wajib Diketahui:**
  - `pwd` (Print Working Directory): Menampilkan direktori tempat Anda berada saat ini.
  - `ls` (List) di macOS/Linux atau `dir` di Windows: Menampilkan daftar file dan folder di direktori saat ini.
  - `cd` (Change Directory): Pindah ke direktori lain. Contoh: `cd Documents` untuk pindah ke folder Documents. `cd ..` untuk kembali ke satu level direktori di atasnya.
  - **Menjalankan Skrip Lua:** Perintah `lua namafile.lua` memberitahu interpreter `lua` untuk menjalankan skrip bernama `namafile.lua`.

**Analogi untuk Pemula**
Menggunakan antarmuka grafis (klik-klik mouse) itu seperti berbelanja di supermarket di mana semua barang sudah ditata di rak. Menggunakan command line itu seperti berbicara langsung dengan staf gudang. Anda harus tahu persis apa yang Anda inginkan dan di mana letaknya ("Saya mau barang X dari lorong 5, rak 3"), tetapi jauh lebih cepat dan lebih kuat jika Anda tahu apa yang Anda lakukan.

**Menuju Praktik**
Kita akan membuat sebuah folder khusus untuk proyek Lua kita (misalnya, `ProyekLua`).

1.  Buka terminal.
2.  Gunakan `cd` untuk menavigasi ke tempat Anda ingin membuat folder (misalnya, `cd Documents`).
3.  Buat folder baru (misalnya, `mkdir ProyekLua`).
4.  Masuk ke folder tersebut: `cd ProyekLua`.
5.  Gunakan `pwd` untuk memastikan Anda berada di lokasi yang benar. Inilah "area kerja" kita untuk semua skrip selanjutnya.

### **Topik 009: Penggunaan REPL**

- **Referensi Resmi:** [Mode Interaktif](https://www.lua.org/manual/5.4/manual.html#6)

**Deskripsi Konkret**
**REPL** adalah singkatan dari **Read-Eval-Print Loop**. Ini adalah mode interaktif dari interpreter Lua di mana Anda bisa mengetikkan satu baris kode, dan hasilnya akan langsung ditampilkan. Ini adalah "kertas coret-coretan" atau "kalkulator canggih" Anda untuk mencoba ide-ide kecil dengan cepat tanpa perlu membuat file.

**Siklus REPL**

1.  **Read:** Terminal membaca baris kode yang Anda ketik.
2.  **Eval:** Interpreter Lua mengevaluasi (menjalankan) kode tersebut.
3.  **Print:** Hasil dari evaluasi dicetak ke layar.
4.  **Loop:** Proses kembali ke langkah 1, siap untuk perintah berikutnya.

**Cara Menggunakan**
Cukup buka terminal Anda dan ketik `lua`, lalu tekan Enter. Anda akan melihat prompt Lua (`>`).

**Sintaks Dasar & Contoh**

```
> print("Halo dari REPL!")
Halo dari REPL!
> 2 + 3
5
> my_variable = "Ini adalah tes"
> print(my_variable)
Ini adalah tes
```

Untuk keluar dari REPL, tekan `Ctrl+C` atau `Ctrl+Z` (tergantung sistem operasi).

**Menuju Praktik**
Sebelum menulis skrip pertama kita, kita akan "pemanasan" di REPL.

1.  Buka terminal.
2.  Jalankan `lua`.
3.  Coba beberapa operasi matematika sederhana (`5 * 10`).
4.  Buat sebuah variabel dan cetak nilainya.
    Ini membangun kepercayaan diri dan membiasakan Anda dengan sintaks dasar Lua dalam lingkungan yang bebas risiko.

### **Topik 010: Skrip Lua Pertama**

- **Referensi Resmi:** [Memulai](https://www.lua.org/manual/5.4/manual.html#1)

**Deskripsi Konkret**
Ini adalah momen "Hello, World\!"—tradisi sakral dalam belajar bahasa pemrograman. Kita akan menulis program pertama kita yang sesungguhnya, menyimpannya dalam sebuah file, dan menjalankannya. Program ini akan melakukan satu hal sederhana: mencetak teks ke layar.

**Konsep Inti & Terminologi**

- **File Ekstensi `.lua`:** Semua file skrip Lua harus diakhiri dengan ekstensi `.lua` (misalnya `hello.lua`). Ini adalah cara kita memberitahu sistem operasi (dan editor teks) bahwa file ini berisi kode Lua.
- **Fungsi `print()`:** Fungsi bawaan Lua yang paling dasar. Apapun yang Anda letakkan di dalam tanda kurungnya akan ditampilkan di terminal.
- **String:** Tipe data untuk teks. String di Lua dibuat dengan mengapit teks di antara tanda kutip ganda (`"`) atau tunggal (`'`).

**Contoh Kode: `hello.lua`**

```lua
-- Ini adalah skrip Lua pertama saya.
-- Baris yang diawali dengan dua tanda hubung adalah komentar dan akan diabaikan.
print("Hello, World!")
```

**Langkah-langkah Menjalankan**

1.  Buka VS Code.
2.  Buat file baru dan tempelkan kode di atas.
3.  Simpan file dengan nama `hello.lua` di dalam folder `ProyekLua` yang sudah kita buat.
4.  Buka terminal dan pastikan Anda berada di dalam folder `ProyekLua` (gunakan `cd` jika perlu).
5.  Ketik perintah: `lua hello.lua` dan tekan Enter.

**Output yang Diharapkan:**

```
Hello, World!
```

**Menuju Praktik**
Langkah ini adalah inti dari tutorial praktik untuk modul ini. Melakukan proses ini dari awal hingga akhir—membuat folder, membuka editor, menulis kode, menyimpan file, dan menjalankannya dari terminal—mencakup semua yang telah kita pelajari sejauh ini.

### **Topik 011: Argumen Skrip**

- **Referensi Resmi:** [Variabel `arg`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%236.1%5D(https://www.lua.org/manual/5.4/manual.html%236.1)>)

**Deskripsi Konkret**
Terkadang, kita ingin memberikan informasi ke dalam skrip kita saat kita menjalankannya. Misalnya, sebuah skrip yang menyapa pengguna, kita ingin bisa memberitahu nama pengguna tersebut dari luar. Ini dilakukan melalui **argumen baris perintah (command-line arguments)**.

**Konsep Inti & Terminologi**

- **Tabel `arg`:** Saat Anda menjalankan skrip Lua, interpreter secara otomatis membuat sebuah tabel (struktur data seperti daftar) bernama `arg`. Tabel ini berisi semua argumen yang Anda berikan setelah nama skrip.
- **Indeks Tabel:** Elemen dalam tabel diakses menggunakan nomor indeks. `arg[1]` adalah argumen pertama, `arg[2]` adalah yang kedua, dan seterusnya. `arg[0]` biasanya berisi nama skrip itu sendiri.

**Contoh Kode: `sapa.lua`**

```lua
-- sapa.lua: Skrip untuk menyapa pengguna berdasarkan argumen.

local nama = arg[1]  -- Ambil argumen pertama dan simpan di variabel 'nama'
local kota = arg[2]  -- Ambil argumen kedua dan simpan di variabel 'kota'

-- Operator 'or' di sini digunakan untuk memberikan nilai default
-- jika argumen tidak diberikan (nil).
nama = nama or "Dunia"
kota = kota or "Bumi"

print("Halo, " .. nama .. " dari " .. kota .. "!")
-- Operator '..' digunakan untuk menggabungkan string.
```

**Cara Menjalankan**
Buka terminal di folder `ProyekLua` dan coba beberapa variasi:

1.  `lua sapa.lua` -\> Output: `Halo, Dunia dari Bumi!`
2.  `lua sapa.lua Budi` -\> Output: `Halo, Budi dari Bumi!`
3.  `lua sapa.lua Citra Jakarta` -\> Output: `Halo, Citra dari Jakarta!`

**Menuju Praktik**
Dalam tutorial, kita akan membuat skrip `sapa.lua` ini. Ini mengajarkan konsep penting tentang bagaimana sebuah program dapat menerima input eksternal, membuatnya jauh lebih dinamis dan dapat digunakan kembali.

### **Topik 012: Konfigurasi Lingkungan**

- **Referensi Resmi:** [Package Path](https://www.lua.org/manual/5.4/manual.html#6.3)

**Deskripsi Konkret**
Saat proyek Anda tumbuh lebih besar, Anda akan mulai memecah kode Anda menjadi beberapa file (disebut **modul**) atau menggunakan modul yang dibuat oleh orang lain. Lua perlu tahu di mana harus mencari file-file ini. Lokasi pencarian ini dikonfigurasi dalam sebuah "buku alamat" yang disebut `package.path`.

**Konsep Inti & Terminologi**

- **Modul (Module):** Sebuah file Lua yang berisi sekumpulan fungsi atau data yang dapat digunakan kembali.
- **`require()`:** Fungsi yang Anda gunakan untuk memuat sebuah modul. Contoh: `local math_tools = require("matematika_saya")`.
- **`package.path`:** Sebuah string khusus yang berisi daftar pola lokasi di mana Lua akan mencari file `.lua` ketika Anda memanggil `require()`. Tanda tanya (`?`) dalam path adalah placeholder yang akan diganti dengan nama modul yang Anda coba muat.

**Melihat Path Bawaan**
Anda bisa melihat `package.path` Anda saat ini dengan menjalankannya di REPL:

```lua
> print(package.path)
-- Outputnya akan terlihat seperti ini (bisa berbeda-beda):
-- ./?.lua;C:\Program Files\Lua\5.4\lua\?.lua;...
```

Ini berarti Lua akan mencari:

1.  Di direktori saat ini (`./?.lua`).
2.  Di folder instalasi Lua (`C:\Program Files\Lua\5.4\lua\?.lua`).
3.  Dan seterusnya.

**Analogi untuk Pemula**
Bayangkan Anda meminta asisten untuk mengambilkan buku berjudul "Sejarah".

- `require("Sejarah")` adalah perintah Anda.
- `package.path` adalah daftar instruksi yang Anda berikan kepada asisten: "Pertama, cari di meja saya. Jika tidak ada, cari di rak buku ruang kerja. Jika masih tidak ada, cari di perpustakaan kota."
  Asisten akan berhenti mencari begitu ia menemukan buku tersebut.

**Menuju Praktik**
Untuk saat ini, kita tidak akan mengubah `package.path`. Konsep ini diperkenalkan sekarang agar Anda tahu itu ada. Kita akan mempraktikkannya secara mendalam nanti di **Modul 11: Modul & Paket**, di mana kita akan belajar cara membuat modul kita sendiri dan mengaturnya dalam struktur proyek yang rapi. Untuk sekarang, cukup tahu bahwa selama file `.lua` kita berada di folder yang sama, `require()` akan dapat menemukannya.

---

**Selamat\!** Anda telah menyelesaikan Modul 1. "Bengkel kerja" Anda sekarang sepenuhnya siap. Anda telah menginstal peralatannya, menyiapkan meja kerja yang canggih, memahami filosofi di balik alat-alat Anda, dan berhasil membuat serta menjalankan produk pertama Anda. Anda siap untuk mulai membangun sesuatu yang lebih substantif di modul-modul berikutnya.
