> [guide][1]

# Kurikulum Pembelajaran Neovim

**Target Pembelajar:** Individu yang ingin menguasai editor teks berbasis terminal yang kuat dan sangat dapat disesuaikan. Kurikulum ini dirancang untuk pengembang perangkat lunak, administrator sistem, dan siapa pun yang membutuhkan alat pengeditan teks yang efisien dan fleksibel. Kurikulum ini mengasumsikan Anda sudah familiar dengan penggunaan terminal/CLI dasar.

**Hasil Pembelajaran (Learning Outcomes):**
Setelah menyelesaikan kurikulum ini, Anda akan dapat:

  * Memahami secara mendalam filosofi **modal editing** dan navigasi Neovim.
  * Mengkonfigurasi Neovim dari nol menggunakan bahasa **Lua** dan mengelola plugin dengan efisien.
  * Menavigasi, mengedit, dan memodifikasi teks dengan sangat cepat menggunakan perintah-perintah yang kuat.
  * Mengintegrasikan Neovim dengan ekosistem pengembangan modern, termasuk **LSP** (Language Server Protocol), **sistem kontrol versi**, dan utilitas eksternal.
  * Mengotomatiskan alur kerja (workflow) dengan membuat **macro** dan **skrip** kustom.
  * Membangun editor yang sepenuhnya personal dan produktif, bahkan berkontribusi pada ekosistem Neovim.

**Prasyarat:**

  * **Wajib:** Pengalaman dasar dengan **CLI** dan sistem operasi **Unix-like** (seperti **Arch Linux** yang Anda gunakan).
  * **Wajib:** Pemahaman dasar tentang bahasa pemrograman **Lua** (akan dijelaskan lebih lanjut di fase pemula).
  * **Opsional (untuk tingkat lanjut):** Pemahaman dasar tentang **Git**.

**Alat Esensial:**

  * Terminal (Terminal Emulator) seperti **Alacritty, Kitty, atau WezTerm**.
  * Sistem Operasi **Arch Linux** atau OS lain.
  * **Neovim** (dengan versi terbaru, 0.9.x ke atas, untuk mendukung fitur modern).
  * **Git** untuk manajemen plugin.
  * **Terdapat compiler/runtime untuk bahasa pemrograman yang ingin Anda kembangkan** (contoh: `rustup` untuk Rust, `node` untuk JavaScript).

**Rekomendasi Waktu:**

  * **Fase 1 (Pemula):** Sekitar 2-3 minggu (dengan latihan harian).
  * **Fase 2 (Menengah):** Sekitar 1-2 bulan.
  * **Fase 3 (Mahir):** Sekitar 2-4 bulan.
  * **Fase 4 (Ahli):** Waktu tidak terbatas, akan terus berlanjut.

-----

### **Fase 1: Pemula (Foundation)**

**Level:** Pemula (Beginner)

Fase ini berfokus pada penguasaan dasar-dasar Neovim, filosofi pengeditan modalnya, dan konsep navigasi dasar. Tujuannya adalah membuat Anda merasa nyaman di lingkungan editor Neovim yang minimalis.

#### **Modul 1: Pengenalan Neovim dan Filosofi Modal Editing**

**Deskripsi Konkret:**
Modul ini memperkenalkan Anda pada Neovim, editor yang merupakan evolusi dari **Vim**, serta paradigma **modal editing** yang menjadi inti dari kekuatannya. Anda akan belajar bagaimana mode yang berbeda memungkinkan Anda untuk melakukan tugas-tugas spesifik dengan cepat.

**Konsep Dasar dan Filosofi:**
Neovim adalah editor teks open-source yang berfokus pada ekstensibilitas (extensibility) dan kegunaan (usability). Meskipun dibangun di atas fondasi Vim, Neovim memodernisasi arsitekturnya dengan menyediakan API modern, server *remote* (untuk integrasi GUI), dan menggunakan **Lua** sebagai bahasa skrip utama (selain Vimscript). Filosofi utamanya adalah **modal editing**, di mana editor memiliki mode berbeda (misalnya, **Normal, Insert, Visual, Command-line**). Ini mengurangi kelelahan akibat kombinasi tombol `Ctrl`/`Alt` dan meningkatkan efisiensi.

**Terminologi Kunci:**

  * **Neovim:** Sebuah editor teks modern, open-source, dan sangat dapat diperluas.
  * **Modal Editing:** Paradigma pengeditan di mana editor memiliki mode-mode berbeda untuk fungsi berbeda.
  * **Normal Mode:** Mode default di Neovim untuk navigasi dan perintah.
  * **Insert Mode:** Mode untuk mengetik teks.
  * **Visual Mode:** Mode untuk memilih blok teks.
  * **Command-line Mode:** Mode untuk menjalankan perintah dengan diawali `:`.
  * **Vimscript:** Bahasa skrip asli Vim.
  * **Lua:** Bahasa skrip modern dan ringan yang digunakan Neovim untuk konfigurasi dan plugin.

**Sintaks Dasar/Contoh Implementasi Inti:**

  * Memulai Neovim: `nvim` atau `nvim <nama_file>`
  * Keluar: `  :q ` (Command-line)
  * Menyimpan dan keluar: `  :wq `
  * Masuk ke **Insert Mode:** `i`
  * Kembali ke **Normal Mode:** `ESC`

**Daftar Isi:**

  * Sejarah singkat Neovim dan hubungannya dengan Vim.
  * Pengenalan mode-mode dasar: Normal, Insert, Visual.
  * Perintah dasar untuk membuka, menyimpan, dan menutup file.
  * Perbedaan filosofi antara Neovim dan editor GUI tradisional.

**Sumber Referensi:**

  * [Dokumentasi Resmi Neovim: `nvimtutor`](https://www.google.com/search?q=%5Bhttps://neovim.io/doc/user/intro.html%5D\(https://neovim.io/doc/user/intro.html\)) (Jalankan perintah `nvimtutor` di terminal untuk tutorial interaktif).
  * [Situs Resmi Neovim](https://neovim.io/)
  * [Wiki Neovim](https://github.com/neovim/neovim/wiki)

-----

#### **Modul 2: Navigasi dan Manipulasi Teks Dasar**

**Deskripsi Konkret:**
Modul ini akan mengajarkan Anda cara bergerak di dalam file dengan cepat dan melakukan pengeditan teks dasar menggunakan kombinasi tombol-tombol yang efisien.

**Konsep Dasar dan Filosofi:**
Kekuatan Neovim terletak pada kemampuannya untuk mengombinasikan perintah `verb` (aksi) dan `noun` (objek). Contohnya, `d` (hapus) adalah *verb* dan `w` (kata) adalah *noun*. Mengombinasikan keduanya menjadi `dw` akan menghapus sebuah kata. Ini adalah konsep yang membuat Neovim jauh lebih cepat daripada editor lain.

**Terminologi Kunci:**

  * **Verb:** Perintah yang menentukan sebuah aksi, seperti hapus (`d`), salin (`y`), atau ganti (`c`).
  * **Noun (Text Object):** Unit teks yang menjadi target aksi, seperti kata (`w`), kalimat (`s`), atau blok kode (`{}`).
  * **Operator-Pending Mode:** Mode khusus yang menunggu `noun` setelah `verb` ditekan.

**Sintaks Dasar/Contoh Implementasi Inti:**

  * Navigasi:
      * `h`, `j`, `k`, `l`: Kiri, Bawah, Atas, Kanan.
      * `w`, `b`: Lompat ke awal kata berikutnya/sebelumnya.
      * `e`: Lompat ke akhir kata.
      * `G`: Lompat ke baris terakhir.
      * `gg`: Lompat ke baris pertama.
  * Manipulasi:
      * `dw`: Hapus kata.
      * `yw`: Salin kata.
      * `ci"`: Ganti teks di dalam tanda petik ganda.
      * `p`: Tempel (paste).
      * `u`: Undo (batalkan).

**Daftar Isi:**

  * Perintah navigasi dasar (huruf, baris, paragraf).
  * Kombinasi `verb` + `noun`.
  * Penggunaan `count` untuk mengulang perintah (contoh: `2dd` untuk hapus 2 baris).
  * Latihan praktis: Menggunakan **Visual Mode** untuk memilih dan memanipulasi teks.

**Sumber Referensi:**

  * [Tutorial ThePrimeagen: Vim for Newbies](https://www.google.com/search?q=https://www.youtube.com/watch%3Fv%3Dy3n93T9y4C0)
  * [Neovim Docs: `usr_04.txt` (Mengedit dengan gerakan)](https://www.google.com/search?q=%5Bhttps://neovim.io/doc/user/usr_04.html%5D\(https://neovim.io/doc/user/usr_04.html\))

-----

### **Fase 2: Menengah (Intermediate)**

**Level:** Menengah (Intermediate)

Fase ini adalah pintu gerbang menuju penguasaan Neovim. Anda akan belajar cara mengkonfigurasi editor menggunakan **Lua**, mengelola plugin, dan mengintegrasikannya dengan fitur-fitur modern.

#### **Modul 3: Konfigurasi dengan Lua dan Manajemen Plugin**

**Deskripsi Konkret:**
Anda akan beralih dari Vimscript ke **Lua** untuk mengelola konfigurasi Neovim. Anda akan mempelajari struktur dasar file konfigurasi, cara mengatur opsi global, dan cara menggunakan manajer plugin untuk menambahkan fungsionalitas baru.

**Konsep Dasar dan Filosofi:**
Neovim memisahkan diri dari Vim dengan mengadopsi **Lua** sebagai bahasa konfigurasi utama. Lua menawarkan performa yang lebih baik, sintaks yang lebih modern, dan integrasi yang lebih mudah dengan fitur-fitur modern. Konfigurasi Neovim sekarang berpusat pada file `init.lua`, yang memungkinkan pendekatan **modular** (membagi konfigurasi ke dalam beberapa file). Ini mempermudah pemeliharaan dan berbagi konfigurasi.

**Terminologi Kunci:**

  * **init.lua:** File konfigurasi utama Neovim.
  * **Plugin Manager:** Alat untuk mengelola plugin (menginstal, memperbarui, menghapus). Contoh: **`packer.nvim`, `lazy.nvim`**.
  * **Packer.nvim/Lazy.nvim:** Manajer plugin modern yang menggunakan Lua untuk konfigurasi.

**Sintaks Dasar/Contoh Implementasi Inti:**

  * Lokasi default file konfigurasi Neovim: `~/.config/nvim/init.lua`
  * Contoh file `init.lua` sederhana:
    ```lua
    -- Mengatur opsi editor
    vim.o.number = true
    vim.o.tabstop = 4
    vim.o.shiftwidth = 4
    vim.o.expandtab = true

    -- Memuat file konfigurasi lain
    require("plugins")
    require("keybindings")
    ```
  * Contoh konfigurasi manajer plugin:
    ```lua
    -- Menginstal plugin dengan lazy.nvim
    require("lazy").setup({
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
    })
    ```

**Daftar Isi:**

  * Perkenalan bahasa Lua.
  * Struktur file `init.lua` dan pemecahannya.
  * Memilih dan menggunakan manajer plugin (`lazy.nvim` direkomendasikan).
  * Menginstal plugin pertama Anda (contoh: **`nvim-treesitter`**).

**Sumber Referensi:**

  * [Neovim Docs: `lua-guide`](https://www.google.com/search?q=%5Bhttps://neovim.io/doc/user/lua.html%5D\(https://neovim.io/doc/user/lua.html\))
  * [Repositori GitHub `lazy.nvim`](https://www.google.com/search?q=%5Bhttps://github.com/folke/lazy.nvim%5D\(https://github.com/folke/lazy.nvim\))
  * [Panduan belajar Lua: `Lua Programming Language`](https://www.google.com/search?q=%5Bhttps://www.lua.org/pil/%5D\(https://www.lua.org/pil/\))

-----

#### **Modul 4: Integrasi Lingkungan Pengembangan (LSP, Tree-sitter, Git)**

**Deskripsi Konkret:**
Modul ini akan mengajarkan cara mengubah Neovim dari editor teks menjadi **Integrated Development Environment (IDE)** yang kuat dengan mengintegrasikan fitur-fitur modern seperti **LSP**, **Tree-sitter**, dan **Git**.

**Konsep Dasar dan Filosofi:**
Kekuatan Neovim terletak pada ekstensibilitasnya, terutama melalui integrasi dengan alat-alat eksternal. **LSP** (Language Server Protocol) adalah protokol standar yang memungkinkan Neovim berkomunikasi dengan server bahasa (language server) untuk mendapatkan fitur-fitur seperti *autocomplete*, diagnostik, dan *code formatting*. **Tree-sitter** adalah parser incremental yang menyediakan *syntax highlighting* yang cerdas dan struktur kode yang dapat dinavigasi. Integrasi dengan **Git** memungkinkan Anda mengelola versi tanpa meninggalkan editor.

**Terminologi Kunci:**

  * **LSP (Language Server Protocol):** Protokol standar untuk fitur-fitur pengembangan kode.
  * **LSP Client:** Bagian dari Neovim yang berkomunikasi dengan server bahasa.
  * **nvim-lspconfig:** Plugin yang mempermudah konfigurasi server bahasa.
  * **Tree-sitter:** Parser yang memungkinkan *syntax highlighting* dan navigasi yang lebih akurat.
  * **vim-fugitive:** Plugin Git yang sangat populer.

**Sintaks Dasar/Contoh Implementasi Inti:**

  * **Memasang plugin:**
      * `lazy.nvim` akan mengelola instalasi plugin `nvim-lspconfig` dan `nvim-treesitter`.
  * **Mengkonfigurasi LSP:**
    ```lua
    -- Contoh konfigurasi untuk rust-analyzer
    local lspconfig = require("lspconfig")
    lspconfig.rust_analyzer.setup{}
    ```
  * **Perintah Neovim untuk LSP:**
      * `gd`: Lompat ke definisi.
      * `K`: Melihat dokumentasi.
      * `gD`: Lompat ke deklarasi.

**Daftar Isi:**

  * Apa itu LSP dan mengapa itu penting.
  * Menginstal dan mengkonfigurasi server bahasa dengan `nvim-lspconfig`.
  * Menggunakan Tree-sitter untuk *syntax highlighting* dan *text object* yang lebih baik.
  * Integrasi dengan Git menggunakan plugin seperti `vim-fugitive` dan `gitsigns.nvim`.

**Sumber Referensi:**

  * [Repositori `nvim-lspconfig`](https://www.google.com/search?q=%5Bhttps://github.com/neovim/nvim-lspconfig%5D\(https://github.com/neovim/nvim-lspconfig\))
  * [Repositori `nvim-treesitter`](https://www.google.com/search?q=%5Bhttps://github.com/nvim-treesitter/nvim-treesitter%5D\(https://github.com/nvim-treesitter/nvim-treesitter\))

-----

### **Fase 3: Mahir (Advanced)**

**Level:** Mahir (Advanced)

Pada fase ini, Anda akan belajar cara membuat Neovim menjadi IDE yang super efisien dengan otomatisasi, *debugging*, dan *fuzzy finding* tingkat lanjut.

#### **Modul 5: Otomatisasi Alur Kerja dan Debugging**

**Deskripsi Konkret:**
Anda akan mempelajari cara merekam **macro** untuk mengotomatisasi tugas-tugas berulang. Anda juga akan mengintegrasikan **debug adapter** untuk men-debug kode langsung dari Neovim.

**Konsep Dasar dan Filosofi:**
Neovim dapat mengotomatisasi pekerjaan dengan `macro` (rekaman perintah) dan perintah `ex-commands`. Untuk *debugging*, Neovim menggunakan **DAP (Debug Adapter Protocol)**, protokol standar yang memungkinkan editor berkomunikasi dengan *debugger* eksternal. Ini menjadikan Neovim sebagai alat pengembangan yang lengkap.

**Terminologi Kunci:**

  * **Macro:** Urutan perintah yang direkam dan dapat diputar ulang.
  * **DAP (Debug Adapter Protocol):** Protokol standar untuk *debugging*.
  * **nvim-dap:** Plugin Neovim untuk mengimplementasikan DAP.
  * **Ex-commands:** Perintah yang dimulai dengan `:` di Command-line Mode.

**Sintaks Dasar/Contoh Implementasi Inti:**

  * Merekam macro: `q<nama_registri>` (misalnya, `qa`)
  * Menghentikan rekaman: `q`
  * Memutar ulang macro: `@<nama_registri>` (misalnya, `@a`)
  * Menggunakan DAP:
      * `require("dap").continue()`: Melanjutkan eksekusi.
      * `require("dap").toggle_breakpoint()`: Menambahkan *breakpoint*.

**Daftar Isi:**

  * Merekam dan memutar ulang makro.
  * Pengantar `ex-commands` dan penggunaannya.
  * Menginstal dan mengkonfigurasi `nvim-dap`.
  * Contoh *debugging* dengan bahasa populer seperti Rust atau Python.

**Sumber Referensi:**

  * [Neovim Docs: `usr_10.txt` (Macro)](https://www.google.com/search?q=%5Bhttps://neovim.io/doc/user/usr_10.html%5D\(https://neovim.io/doc/user/usr_10.html\))
  * [Repositori `nvim-dap`](https://www.google.com/search?q=%5Bhttps://github.com/mfussenegger/nvim-dap%5D\(https://github.com/mfussenegger/nvim-dap\))

-----

### **Fase 4: Ahli (Expert/Enterprise)**

**Level:** Ahli (Expert)

Ini adalah fase terakhir di mana Anda akan memiliki pemahaman mendalam tentang ekosistem Neovim. Anda akan mampu memodifikasi Neovim, menulis plugin sendiri, dan berkontribusi pada komunitas.

#### **Modul 6: Menulis Plugin Kustom dan Arsitektur Neovim**

**Identitas dan Bahasa Pemrograman:**
Neovim adalah proyek **open source** yang dikembangkan oleh komunitas global. Kode inti Neovim ditulis dalam bahasa **C** dan **Lua**, sementara sebagian besar plugin modern ditulis dalam **Lua**. Proyek ini dapat ditemukan di **GitHub** (Amerika Serikat) dan merupakan hasil kolaborasi dari pengembang di seluruh dunia.

**Deskripsi Konkret:**
Anda akan memahami arsitektur internal Neovim dan belajar cara membuat plugin kustom menggunakan Lua. Ini memungkinkan Anda untuk menambahkan fungsionalitas unik yang sesuai dengan kebutuhan spesifik Anda.

**Persyaratan untuk Pengembangan Mandiri/Modifikasi:**

  * **Bahasa Pemrograman:** Pemahaman mendalam tentang **Lua** dan **Vimscript** (untuk kompatibilitas). Pengetahuan tentang **C** akan sangat membantu untuk memahami kode inti Neovim.
  * **Konsep Wajib:**
      * **Git:** Sangat penting untuk berkolaborasi dan mengelola kode.
      * **API Neovim:** Memahami cara Neovim mengekspos fungsi-fungsi internalnya melalui API Lua.
      * **Arsitektur Plugin:** Memahami bagaimana plugin Neovim berinteraksi dengan editor.
  * **Pengalaman Opsional (Sangat Direkomendasikan):**
      * Pemahaman tentang **konsep asinkron** dan *event-driven programming*.

**Sintaks Dasar/Contoh Implementasi Inti:**

  * **Struktur dasar plugin Lua:**
    ```lua
    -- File: lua/my_plugin/init.lua
    local M = {}

    function M.my_command()
      print("Hello from my plugin!")
    end

    return M
    ```
  * **Memanggil API Lua Neovim:**
    ```lua
    vim.api.nvim_set_keymap('n', '<leader>my', ':lua require("my_plugin").my_command()<CR>', {noremap = true})
    ```

**Daftar Isi:**

  * Arsitektur Neovim: `init.lua`, `runtime`, dan API.
  * Cara membuat struktur plugin sederhana.
  * Menggunakan API Neovim untuk berinteraksi dengan buffer, window, dan keymap.
  * Prosedur kontribusi ke proyek Neovim atau plugin lain di GitHub.

**Sumber Referensi:**

  * [Neovim Docs: `dev-lua`](https://www.google.com/search?q=%5Bhttps://neovim.io/doc/user/dev_lua.html%5D\(https://neovim.io/doc/user/dev_lua.html\))
  * [Panduan Penulisan Plugin Neovim dengan Lua](https://github.com/nanotee/nvim-lua-guide)
  * [Repositori GitHub Neovim](https://github.com/neovim/neovim)

-----

### **Sumber Daya Komunitas & Penanganan Error**

**Komunitas:**

  * **GitHub Discussions:** Forum utama untuk diskusi dan pertanyaan. ([https://github.com/neovim/neovim/discussions](https://github.com/neovim/neovim/discussions))
  * **Reddit r/neovim:** Komunitas yang sangat aktif untuk berbagi konfigurasi, tips, dan trik. ([https://www.reddit.com/r/neovim/](https://www.reddit.com/r/neovim/))
  * **Discord Server:** Saluran komunikasi real-time.

**Penanganan Error:**
Neovim memiliki sistem diagnostik yang cukup baik. Ketika ada masalah dengan plugin atau konfigurasi, Anda sering akan melihat pesan error di baris perintah.

  * **`E5108: Error executing vim.lua`:** Menandakan ada kesalahan sintaks atau logika dalam file Lua Anda. Cek baris yang ditunjukkan pada pesan error.
  * **`Unknown command:`:** Ini berarti perintah yang Anda ketikkan tidak dikenali, mungkin plugin yang seharusnya menyediakan perintah tersebut belum dimuat atau tidak terinstal.
  * **`LSP client for... exited`:** Menunjukkan bahwa server bahasa yang Anda gunakan mengalami crash. Coba instal ulang server tersebut atau perbarui konfigurasinya.

Selalu periksa **log Neovim** dengan perintah `  :messages ` atau log LSP dengan `  :LspInfo `. Log ini sering kali memberikan petunjuk yang lebih rinci tentang akar masalah. Jika masih bingung, salin pesan error lengkap dan cari di GitHub atau Reddit. Komunitas Neovim sangat aktif dan responsif.

[1]: ../neovim/guide/README.md
