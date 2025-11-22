# Framework Lua: Pilihan Powerhouse yang Multiplatform dan Cepat

Dokumen ini menyajikan **rekomendasi framework Lua** yang memenuhi kriteria berikut:

- **Powerful**: Memiliki fitur lengkap untuk berbagai skenario (GUI, web, plugin, dsb.).
- **Multiplatform / Cross-platform**: Dapat berjalan di Linux, Windows, macOS, bahkan perangkat mobile.
- **Stabil & Cepat**: Mengandalkan LuaJIT atau runtime yang dioptimalkan untuk performa tinggi.
- **Mudah Diadopsi**: Komunitas cukup besar, dokumentasi resmi tersedia, serta contoh–contoh praktis yang bisa dijadikan pijakan.

> ⚠️ Dokumen ini disusun dalam gaya dokumentasi resmi, mudah dipahami, dan ringkas.  
> Nada penjelasan bersifat **membara semangat**, sejalan dengan tujuan membangun proyek Lua berskala besar—mulai dari plugin Neovim hingga IDE terminal-based.

---

## Daftar Isi

1. [Ringkasan Framework](#ringkasan-framework)
2. [Detail Tiap Framework](#detail-tiap-framework)
   - [1. LÖVE (Love2D)](#1-lÖve-love2d)
   - [2. OpenResty](#2-openresty)
   - [3. Neovim (runtime)](#3-neovim-runtime)
   - [4. Fennel + Aniseed / Hotpot](#4-fennel--aniseed--hotpot)
   - [5. MoonScript](#5-moonscript)
3. [Rekomendasi Utama Berdasarkan Kebutuhan](#rekomendasi-utama-berdasarkan-kebutuhan)
4. [Tips Lanjutan & Catatan](#tips-lanjutan--catatan)
5. [Contoh Boilerplate Sederhana (Opsional)](#contoh-boilerplate-sederhana-opsional)

---

## Ringkasan Framework

| No. | Framework                     | Use Case Utama                             | Platform (Cross-platform)               | Keunggulan Utama                                       |
| --- | ----------------------------- | ------------------------------------------ | --------------------------------------- | ------------------------------------------------------ |
| 1   | **LÖVE (Love2D)**             | Game 2D / GUI aplikasi ringan              | Windows / macOS / Linux / Android / iOS | Sangat cepat (SDL + LuaJIT), ekosistem game kuat       |
| 2   | **OpenResty**                 | Web server / Backend service               | Windows / macOS / Linux                 | Performa tinggi (berbasis Nginx + LuaJIT)              |
| 3   | **Neovim (runtime)**          | Plugin Neovim & CLI tool berbasis terminal | Windows / macOS / Linux                 | Native Lua support, battle-tested, modular tinggi      |
| 4   | **Fennel + Aniseed / Hotpot** | Reactive programming / Macro system        | Windows / macOS / Linux                 | Gaya functional (ala Clojure), kuat untuk proyek besar |
| 5   | **MoonScript**                | Sintaks modern & ekspresif dalam Lua       | Windows / macOS / Linux                 | Readability lebih tinggi, transpile ke Lua murni       |

---

## Detail Tiap Framework

### 1. LÖVE (Love2D)

**Deskripsi Singkat**  
LÖVE (alias Love2D) adalah framework open-source berbasis Lua yang dikhususkan untuk pengembangan **game 2D** dan **aplikasi GUI ringan**. Dengan **SDL** dan **LuaJIT** sebagai fondasi, Love2D menawarkan performa sangat tinggi, rendering yang halus, serta API yang intuitif.

- **Use Case Utama**

  - Game 2D (platformer, puzzle, dsb.)
  - Aplikasi GUI sederhana (misal: prototipe editor teks, visualizer)
  - Demo interaktif, prototipe aplikasi berbasis grafik

- **Platform (Cross-platform)**

  - **Desktop**: Windows, macOS, Linux
  - **Mobile**: Android, iOS
  - (Komunitas juga menyediakan skrip untuk macOS App Store / Android APK)

- **Keunggulan**

  1. **Performa Ekstrem** – Memanfaatkan LuaJIT + SDL, frame rate stabil di >60 fps.
  2. **Multiplatform** – Satu kode ► dibuild ke berbagai platform tanpa banyak modifikasi.
  3. **API Intuitif** – Mudah dipelajari, dokumentasi resmi lengkap dengan contoh.
  4. **Ekosistem Aktif** – Banyak library pendukung (physics, GUI, networking).

- **Catatan / Tips**
  - Jika membangun **IDE terminal-based** dengan tampilan TUI (text-based UI), Love2D bisa jadi “senjata rahasia” untuk melesatkan kosakata GUI Anda.
  - Dokumentasi resmi: https://love2d.org/wiki/Main_Page

---

### 2. OpenResty

**Deskripsi Singkat**  
OpenResty adalah **web platform** yang menggabungkan **Nginx** dengan modul **LuaJIT**, memungkinkan Anda menulis logika aplikasi backend secara langsung menggunakan Lua. Sangat cocok untuk layanan RESTful, microservices, API gateway, dan proxy yang memerlukan latensi rendah serta throughput tinggi.

- **Use Case Utama**

  - Backend service / REST API
  - Server proxy / API gateway
  - Aplikasi real-time (WebSocket, SSE)

- **Platform (Cross-platform)**

  - Windows (melalui WSL)
  - Linux (Ubuntu, CentOS, dsb.)
  - macOS

- **Keunggulan**

  1. **Performa Tinggi** – Memanfaatkan kekuatan Nginx + event-driven architecture + LuaJIT.
  2. **Modular & Scalable** – Mudah mengatur konfigurasi Nginx + script Lua untuk routing, middleware, caching.
  3. **Ekosistem Luas** – Banyak plugin dan modul third-party (koneksi ke Redis, PostgreSQL, MySQL).

- **Catatan / Tips**

  - Gunakan OpenResty untuk membangun **microservices** yang ringan, responsif, tapi tetap mudah di-scale secara horizontal.
  - Contoh file konfigurasi sederhana (Nginx + Lua):

    ```nginx
    worker_processes  1;

    events {
        worker_connections  1024;
    }

    http {
        lua_shared_dict cache 10m;

        server {
            listen 8080;

            location /hello {
                content_by_lua_block {
                    ngx.say("Halo, dunia!")
                }
            }
        }
    }
    ```

  - Dokumentasi resmi: https://openresty.org/en

---

### 3. Neovim (runtime)

**Deskripsi Singkat**  
Sejak rilis Neovim 0.5, **native Lua support** di Neovim membuat ekosistem plugin Lua berkembang pesat. Anda bisa memanfaatkan API bawaan Neovim untuk membangun **plugin**, **extension** (seperti LSP client), atau tool CLI terintegrasi dengan editor.

- **Use Case Utama**

  - Plugin Neovim (autocomplete, syntax highlighting, refactoring tools)
  - Alat CLI berbasis terminal (misal: wrapper Git, task runner)
  - Proyek IDE terminal-based setara VSCode (menggunakan Neovim sebagai mesin)

- **Platform (Cross-platform)**

  - Windows, macOS, Linux

- **Keunggulan**

  1. **Native LuaJIT** – Kinerja plugin nyaris tak terasa, startup time singkat.
  2. **API yang Konsisten** – Dokumentasi API lengkap, mudah memanggil fungsi-fungsi Neovim.
  3. **Komunitas Besar** – Banyak plugin populer (Telescope, Lualine, nvim-treesitter) sebagai referensi.
  4. **Modularitas** – Membangun plugin modular dengan struktur folder yang rapi (misal: `lua/<nama_plugin>/init.lua`).

- **Catatan / Tips**
  - **Plenary.nvim**: Library utilitas serbaguna untuk plugin Neovim (unit test, path, job control).
  - **Telescope.nvim**: Contoh plugin yang sepenuhnya ditulis dengan Lua, pattern-matching, dan modular.
  - Contoh struktur direktori plugin sederhana:
    ```
    my-plugin/
    ├── lua/
    │   └── my_plugin/
    │       ├── init.lua
    │       ├── commands.lua
    │       └── utils.lua
    ├── plugin/
    │   └── my_plugin.vim
    └── README.md
    ```
  - Dokumentasi Neovim API: https://neovim.io/doc/user/lua.html

---

### 4. Fennel + Aniseed / Hotpot

**Deskripsi Singkat**  
Fennel adalah bahasa yang _transpile_ ke Lua, terinspirasi oleh Clojure, dengan **macro system** kuat. Aniseed (untuk Neovim) atau Hotpot (untuk proyek umum) mengintegrasikan Fennel agar Anda dapat menulis kode dengan paradigma **functional** dan **reactive**.

- **Use Case Utama**

  - Proyek besar dengan kebutuhan makro & DSL (domain-specific language)
  - Pembangunan plugin Neovim dengan gaya Clojure-like (hot-reload, REPL)
  - Struktur kode yang sangat modular & deklaratif

- **Platform (Cross-platform)**

  - Windows, macOS, Linux (karena Fennel hanya perlu Lua runtime)

- **Keunggulan**

  1. **Gaya Functional Programming** – Immutability, macro, REPL interaktif.
  2. **Macro System Kuat** – Bisa membangun DSL internal untuk mempermudah penulisan kode kompleks.
  3. **Hot Reloading** – Di Neovim, Aniseed memungkinkan Anda reload kode Fennel tanpa restart editor.

- **Catatan / Tips**
  - Memerlukan pengetahuan tentang paradigma functional & Lisp syntax.
  - Contoh snippet Fennel sederhana (Hello World):
    ```fennel
    (print "Halo dari Fennel!")
    ```
    ➜ akan di-transpile menjadi `print("Halo dari Fennel!")`.
  - Dokumentasi Fennel: https://fennel-lang.org/
  - Aniseed (Neovim plugin untuk Fennel): https://github.com/Olical/aniseed

---

### 5. MoonScript

**Deskripsi Singkat**  
MoonScript adalah bahasa yang _transpile_ ke Lua, menawarkan sintaks yang lebih **ekspresif**, mirip CoffeeScript. Cocok untuk Anda yang menginginkan kode lebih ringkas tanpa meninggalkan ekosistem Lua.

- **Use Case Utama**

  - Meningkatkan readability kode Lua
  - Proyek web backend (misal: dengan Lapis)
  - Aplikasi CLI atau plugin Neovim dengan sintaks lebih nyaman

- **Platform (Cross-platform)**

  - Windows, macOS, Linux (kompatibel dengan Lua interpreter apa pun)

- **Keunggulan**

  1. **Sintaks Modern & Ekspresif** – Kurang tanda kurung, indentasi minimal.
  2. **Transpile Otomatis** – Kode MoonScript di-compile jadi Lua murni, tetap pakai ekosistem Lua.
  3. **Komunitas Cukup Aktif** – Banyak modul pihak ketiga untuk MoonScript.

- **Catatan / Tips**
  - Contoh snippet MoonScript sederhana:
    ```moonscript
    greet = (name) ->
      print "Halo, #{name}!"
    greet "Dunia"
    ```
    ➜ Disubstitusi menjadi:
    ```lua
    local greet
    greet = function(name)
      return print("Halo, " .. name .. "!")
    end
    greet("Dunia")
    ```
  - Dokumentasi MoonScript: https://moonscript.org/

---

## Rekomendasi Utama Berdasarkan Kebutuhan

| **Tujuan / Use Case**                       | **Framework Utama**                                |
| ------------------------------------------- | -------------------------------------------------- |
| Plugin Neovim & IDE terminal-based          | **Neovim (runtime)** + mengandalkan `plenary.nvim` |
| Backend high-performance & scalable service | **OpenResty**                                      |
| Aplikasi GUI / Game 2D                      | **LÖVE (Love2D)**                                  |
| Proyek dengan gaya functional & macro       | **Fennel + Aniseed / Hotpot**                      |
| Kode Lua lebih ekspresif & readable         | **MoonScript**                                     |

> 🚀 Dengan framework yang tepat, Anda siap “menaklukkan dunia” pengembangan plugin, backend, maupun aplikasi GUI berbasis Lua.

---

## Tips Lanjutan & Catatan Penting

1. **Gunakan LuaJIT**

   - Sebagian besar framework di atas menganjurkan atau mengandalkan **LuaJIT** sebagai interpreter utama.
   - LuaJIT dapat meningkatkan performa eksekusi kode Lua hingga 2–3× dibanding Lua standar (Puc-Ri Lua).

2. **Membangun Boilerplate Sendiri**

   - Jika target utama Anda adalah **plugin Neovim**, buat boilerplate yang memisahkan logika (folder `lua/`) dan entry point (folder `plugin/`).
   - Sertakan file `README.md` yang menjelaskan cara instalasi, penggunaan, dan kontribusi.

3. **Manfaatkan Ekosistem & Paket Manager**

   - Neovim: `packer.nvim` atau `lazy.nvim` sebagai plugin manager.
   - LuaRocks: Package manager untuk library Lua di luar Neovim.
   - Love2D: Luar biasa banyak modul yang tersedia di `love2d.org`.

4. **Kontrol Versi & Continuous Integration (CI)**

   - Gunakan Git untuk version control, sertakan `.gitignore` standar untuk proyek Lua (abaikan `*.luac`, `bin/`, `obj/`).
   - Integrasi CI (GitHub Actions, GitLab CI) untuk otomatisasi testing (via Busted atau Telescope unit test untuk Neovim).

5. **Dependency Injection & Modularisasi**

   - Pecah kode menjadi modul-modul kecil agar mudah diuji, mudah dimaintain.
   - Misalnya, di Neovim: `lua/my_plugin/utils.lua`, `lua/my_plugin/lsp.lua`, dsb.

6. **Catatan Performa**

   - Untuk OpenResty, pastikan Anda menggunakan teknik caching (shared dictionary, proxy cache).
   - Untuk Love2D, optimalkan gambar / audio agar ukuran tidak terlalu besar, gunakan atlas sprite jika perlu.

7. **Belajar dari Proyek Open Source Lokal**
   - Cari referensi plugin Neovim buatan komunitas Indonesia (banyak repo di GitHub) untuk melihat pola implementasi yang sesuai standar.
   - Berkontribusi ulang (fork, pull-request) agar menambah wawasan dan portofolio Anda.

---

#

<!-- > - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]** -->

> - **[Ke Atas](#)**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../README.md
[kurikulum]: ../README.md

<!-- [sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md -->

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
