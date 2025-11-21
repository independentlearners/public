# **[19. Struktur Plugin dan Manajemen Dependensi][1]**

Bagian ini akan memandu Anda melalui konvensi struktur direktori standar untuk plugin Neovim, bagaimana Neovim memuat plugin Anda, konsep _entry point_ umum menggunakan fungsi `setup()`, dan cara menangani dependensi eksternal.

---

### 19.1 Struktur Direktori Plugin

- **Deskripsi Konsep:**
  - **Pentingnya Struktur Standar:** Neovim mencari dan memuat file plugin dari direktori-direktori tertentu yang ada di dalam _runtimepath_ (`'rtp'`). Mengikuti struktur direktori standar memastikan bahwa Neovim dapat menemukan dan memuat berbagai komponen plugin Anda (seperti kode Lua utama, skrip VimL pelengkap, dokumentasi, atau kode spesifik untuk tipe file tertentu) pada waktu yang tepat dan dengan cara yang benar. Struktur yang baik juga memudahkan pengguna lain (dan Anda di masa depan) untuk memahami dan berkontribusi pada plugin Anda.
  - **Runtime Path (`'rtp'`):** Ini adalah opsi Neovim yang berisi daftar path direktori yang dipindai untuk file plugin, dokumentasi, skema warna, dll. Plugin manager biasanya akan menambahkan path direktori plugin Anda ke `'rtp'`. Anda bisa melihatnya dengan `:echo &rtp`.
- **Terminologi:**
  - **Plugin Directory Structure (Struktur Direktori Plugin):** Tata letak folder dan file yang direkomendasikan untuk sebuah plugin Neovim.
  - **Runtime Path (`rtp`):** Daftar direktori tempat Neovim mencari file runtime (plugin, sintaks, indentasi, dll.).
- **Direktori Umum dan Tujuannya:**
  Misalkan nama plugin Anda adalah `my-cool-plugin`. Berikut adalah struktur direktori umum yang mungkin Anda gunakan:

  ```
  my-cool-plugin/
  ├── lua/
  │   └── my-cool-plugin/
  │       ├── init.lua        -- Modul utama Lua, entry point (seringkali berisi fungsi setup())
  │       ├── utils.lua       -- Modul utilitas
  │       ├── core.lua        -- Logika inti plugin
  │       └── ...             -- Modul-modul lain
  ├── plugin/
  │   └── my_cool_plugin.lua  -- (atau .vim) Skrip yang di-source Neovim saat startup.
  │                           -- Untuk plugin Lua, ini bisa sangat minimal, hanya me-require modul utama dari lua/.
  ├── ftplugin/
  │   ├── lua_mycoolplugin.lua -- (atau python.vim, dll.) Skrip untuk filetype 'lua' (atau 'python').
  │   └── ...                 -- Skrip spesifik untuk filetype lain.
  ├── doc/
  │   └── my-cool-plugin.txt  -- File dokumentasi (help) plugin.
  │   └── tags                -- Dihasilkan oleh :helptags.
  ├── after/
  │   └── plugin/
  │       └── my_cool_plugin_override.lua -- Di-source setelah semua skrip plugin/ standar.
  ├── syntax/
  │   └── mycustomlanguage.vim -- Definisi highlight sintaks untuk bahasa kustom.
  ├── indent/
  │   └── mycustomlanguage.vim -- Skrip indentasi untuk bahasa kustom.
  └── README.md               -- Informasi umum tentang plugin, instalasi, penggunaan.
  ```

  - **`lua/nama-plugin/`**: Ini adalah tempat utama untuk semua kode Lua plugin Anda.
    - **`init.lua` (di dalam `lua/nama-plugin/`)**: Ini adalah file yang akan dimuat ketika pengguna melakukan `require('nama-plugin')`. Biasanya, file ini mengekspos fungsi `setup()` utama plugin dan mungkin fungsi publik lainnya.
    - **File Lua Lain (`utils.lua`, `core.lua`, dll.)**: Modul-modul tambahan yang berisi logika terorganisir dari plugin Anda. Mereka di-`require` oleh `init.lua` atau modul lain.
  - **`plugin/`**: File-file di sini (baik `.vim` maupun `.lua`) akan di-source (dijalankan) secara otomatis oleh Neovim saat startup, setelah file konfigurasi pengguna (`init.lua` atau `init.vim`) dimuat.
    - Untuk plugin yang mayoritas ditulis dalam Lua, file di sini mungkin hanya satu baris yang melakukan `require('nama-plugin').setup({})` atau memanggil fungsi inisialisasi lain dari modul Lua Anda. Ini juga tempat yang baik untuk mendefinisikan perintah global (`:UserCommand`) atau pemetaan global awal jika diperlukan.
  - **`ftplugin/` (FileType Plugin):** File-file di sini di-source secara otomatis ketika sebuah buffer dengan tipe file tertentu dibuka atau ketika `:set filetype=<tipefile>` dijalankan.
    - Nama file mengikuti format `<tipefile>.vim`, `<tipefile>_<namapengenal>.vim`, atau untuk Lua, seringkali `<tipefile>_<namapengenal>.lua` atau diletakkan dalam subdirektori `<tipefile>/<namapengenal>.lua`.
    - Berguna untuk pengaturan, pemetaan, atau autocommand yang hanya relevan untuk tipe file tertentu. Misalnya, `ftplugin/lua_mycoolplugin.lua` akan berjalan untuk file Lua.
  - **`doc/`**: Berisi file dokumentasi plugin Anda dalam format standar help Vim (`.txt`).
    - Anda perlu menjalankan `:helptags path/to/my-cool-plugin/doc` (atau `:helptags ALL` jika path plugin ada di rtp) agar Neovim mengindeks file help Anda sehingga dapat diakses melalui `:help my-cool-plugin`.
  - **`after/`**: Direktori ini memungkinkan Anda untuk menyediakan skrip yang di-source _setelah_ semua direktori dengan nama yang sama (misalnya, `plugin/`, `ftplugin/`) di runtimepath telah diproses. Berguna untuk menimpa pengaturan default dari plugin lain atau dari Neovim itu sendiri, atau untuk memastikan kode Anda berjalan terakhir.
  - **Direktori Lain (`syntax/`, `indent/`, `colors/`, `autoload/` untuk VimL):** Digunakan untuk komponen spesifik seperti definisi sintaks, skrip indentasi, skema warna, atau fungsi VimL yang dimuat secara otomatis (on-demand). Jika plugin Anda murni Lua dan tidak menyediakan ini, direktori ini mungkin tidak diperlukan.

- **Implementasi dalam Neovim:** Mengikuti konvensi ini memastikan bahwa Neovim dan plugin manager dapat menangani plugin Anda dengan benar. Ini juga memudahkan pengguna untuk memahami bagaimana plugin Anda diorganisir.
- **Sumber Dokumentasi Neovim:**
  - `:h 'runtimepath'`
  - `:h load-plugins` (Bagaimana plugin dimuat)
  - `:h add-plugin` (Struktur direktori dasar)
  - `:h packages` (Tentang paket Neovim, yang juga menggunakan struktur serupa)
  - `:h ftplugin-name` (Penamaan file ftplugin)

---

### 19.2 Entry Point dan Lifecycle (Titik Masuk dan Siklus Hidup)

- **Deskripsi Konsep:**
  - **Bagaimana Neovim Memuat Plugin:**
    1.  Neovim memulai dan memuat file init pengguna (`init.lua` atau `init.vim`).
    2.  Neovim kemudian memindai direktori-direktori dalam `'runtimepath'`.
    3.  Semua file dalam direktori `plugin/**/*.vim` dan `plugin/**/*.lua` akan di-source (dijalankan). Ini adalah salah satu cara utama plugin diinisialisasi.
    4.  Modul Lua tidak secara otomatis di-`require` kecuali ada skrip (misalnya, dari direktori `plugin/`) yang secara eksplisit melakukannya.
    5.  Event seperti `FileType`, `BufEnter`, dll., akan memicu pemuatan skrip dari direktori terkait (`ftplugin/`, autocommands yang didefinisikan, dll.) sesuai kebutuhan.
  - **Entry Point (Titik Masuk):** Untuk plugin Lua modern, "titik masuk" utama seringkali adalah fungsi `setup()` yang diekspos oleh modul utama plugin (misalnya, dari `lua/nama-plugin/init.lua`). Pengguna memanggil fungsi ini dari konfigurasi Neovim mereka.
- **Terminologi:**
  - **Entry Point (Titik Masuk):** Fungsi atau skrip utama yang dipanggil untuk menginisialisasi dan mengkonfigurasi plugin.
  - **Plugin Lifecycle (Siklus Hidup Plugin):** Tahapan yang dilalui plugin, mulai dari pemuatan, inisialisasi, operasi, hingga (jika relevan) pembersihan saat Neovim keluar.
  - **`setup()` function:** Konvensi umum untuk fungsi konfigurasi utama plugin Lua.
- **Fungsi `setup()` yang Umum:**

  - **Tujuan:**
    - **Konfigurasi Terpusat:** Menyediakan satu tempat bagi pengguna untuk mengkonfigurasi plugin.
    - **Nilai Default:** Memungkinkan plugin menyediakan nilai konfigurasi default yang masuk akal.
    - **Inisialisasi:** Melakukan semua langkah yang diperlukan untuk membuat plugin siap digunakan (misalnya, mengatur autocommands, mendefinisikan perintah, menginisialisasi state internal).
  - **Sintaks Per Baris (Contoh Umum):**
    File `lua/my-cool-plugin/init.lua`:

    ```lua
    -- Mendefinisikan modul plugin kita
    local M = {}

    -- Tabel untuk menyimpan konfigurasi default plugin
    local default_config = {
        enable_feature_A = true,
        api_key = nil, -- Pengguna harus menyediakan ini
        max_items = 20,
        theme = "dark_default",
        performance_mode = "balanced" -- Opsi: "eco", "balanced", "max"
    }

    -- Tabel untuk menyimpan konfigurasi yang aktif (setelah digabung dengan opsi pengguna)
    M.active_config = {} -- Di-expose agar modul lain bisa baca jika perlu

    -- Fungsi setup() yang akan dipanggil oleh pengguna
    -- Menerima tabel 'user_opts' dari pengguna sebagai argumen.
    function M.setup(user_opts)
        -- 1. Gabungkan opsi pengguna dengan konfigurasi default.
        -- vim.tbl_deep_extend("force", default, user_opts_1, user_opts_2, ...)
        -- "force": jika kunci sama, nilai dari tabel yang lebih kanan akan menimpa.
        -- "error": error jika ada kunci duplikat (berguna untuk beberapa kasus).
        -- "keep": jika kunci sama, nilai dari tabel yang lebih kiri akan dipertahankan.
        M.active_config = vim.tbl_deep_extend("force",
                                            vim.deepcopy(default_config), -- Kirim salinan default agar default_config tidak termodifikasi
                                            user_opts or {}) -- user_opts atau tabel kosong jika nil

        -- 2. Validasi konfigurasi (opsional tapi bagus)
        if M.active_config.enable_feature_A and not M.active_config.api_key then
            vim.notify("MyCoolPlugin: Fitur A diaktifkan tetapi api_key tidak diset!", vim.log.levels.WARN)
            -- Bisa juga menonaktifkan fitur A jika konfigurasi penting tidak ada
            -- M.active_config.enable_feature_A = false
        end

        -- 3. Lakukan inisialisasi berdasarkan konfigurasi yang sudah digabung.
        -- Ini bisa termasuk:
        --   - Memuat sub-modul
        --   - Mengatur autocommands
        --   - Mendefinisikan perintah pengguna
        --   - Mengatur keymaps (meskipun seringkali diserahkan pada pengguna)

        -- Contoh memanggil fungsi init dari modul lain
        -- local core = require('my-cool-plugin.core')
        -- core.init(M.active_config)

        -- local autocmds = require('my-cool-plugin.autocmds')
        -- autocmds.setup(M.active_config)

        vim.notify("MyCoolPlugin berhasil di-setup!", vim.log.levels.INFO, {title = "MyCoolPlugin"})
        print("Konfigurasi aktif MyCoolPlugin:", vim.inspect(M.active_config))
    end

    -- Mengembalikan tabel modul M agar bisa di-require
    return M
    ```

  - **Pemanggilan oleh Pengguna (dalam `init.lua` pengguna):**
    ```lua
    -- Di file init.lua pengguna
    require('my-cool-plugin').setup({
        enable_feature_A = false,
        api_key = "kunci_rahasia_saya_123",
        theme = "light_custom"
        -- max_items tidak diset, jadi akan menggunakan nilai default (20)
    })
    ```

- **Penjelasan Kode `setup()`:**
  - `local M = {}`: Pola modul Lua standar.
  - `default_config`: Tabel yang berisi semua opsi konfigurasi plugin beserta nilai defaultnya.
  - `M.active_config = {}`: Akan menyimpan konfigurasi final setelah digabung dengan opsi pengguna. Di-expose agar modul lain dalam plugin bisa mengakses konfigurasi jika perlu.
  - `M.setup(user_opts)`: Fungsi utama.
    - `user_opts or {}`: Memastikan `user_opts` selalu berupa tabel, bahkan jika pengguna memanggil `setup()` tanpa argumen.
    - `vim.tbl_deep_extend("force", vim.deepcopy(default_config), user_opts or {})`: Ini adalah baris kunci.
      - `vim.deepcopy(default_config)`: Membuat salinan dalam dari `default_config` agar tabel `default_config` asli tidak termodifikasi secara tidak sengaja.
      - `vim.tbl_deep_extend("force", ...) `: Menggabungkan tabel secara rekursif. Opsi `"force"` berarti jika ada kunci yang sama, nilai dari tabel yang lebih kanan (dalam hal ini `user_opts`) akan digunakan.
    - Validasi Konfigurasi: Contoh bagaimana Anda bisa memeriksa apakah konfigurasi yang diberikan pengguna valid atau konsisten.
    - Inisialisasi Lebih Lanjut: Tempat Anda akan memanggil fungsi setup untuk sub-modul, membuat autocommand, perintah, dll., berdasarkan `M.active_config`.
  - `return M`: Mengekspos modul (termasuk fungsi `setup` dan `active_config`) agar bisa di-`require`.

---

### 19.3 Manajemen Dependensi

- **Deskripsi Konsep:** Plugin Anda mungkin memerlukan plugin lain atau pustaka Lua eksternal untuk berfungsi dengan benar (dependensi wajib) atau untuk menyediakan fungsionalitas tambahan (dependensi opsional). Mengelola ini dengan baik adalah penting.
- **Terminologi:**
  - **Dependency (Dependensi):** Plugin atau pustaka lain yang dibutuhkan oleh plugin Anda.
  - **Plugin Manager (Manajer Plugin):** Alat (biasanya plugin Neovim itu sendiri, seperti `lazy.nvim`, `packer.nvim`, `vim-plug`) yang membantu pengguna menginstal, memperbarui, dan mengelola plugin Neovim dan dependensinya.
- **Deklarasi Dependensi (untuk Pengguna):**
  - **Cara Utama: Melalui Plugin Manager:** Ini adalah metode yang paling umum dan sangat direkomendasikan.
    - Anda, sebagai pengembang plugin, harus dengan jelas mendokumentasikan dependensi plugin Anda di `README.md`.
    - Pengguna kemudian akan mendeklarasikan dependensi tersebut dalam konfigurasi plugin manager mereka. Plugin manager akan menangani pengunduhan dan pemastian bahwa dependensi dimuat sebelum plugin Anda (atau sesuai urutan yang ditentukan).
    - **Contoh Deklarasi (Sintaks `lazy.nvim`):**
      ```lua
      -- Di konfigurasi lazy.nvim pengguna
      return {
        "NamaPenggunaAnda/my-cool-plugin.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim", -- Dependensi wajib
          "MunifTanjim/nui.nvim",   -- Dependensi wajib lain
          { "stevearc/dressing.nvim", optional = true } -- Dependensi opsional
        },
        opts = { -- Opsi untuk my-cool-plugin
          api_key = "abc",
        }
      }
      ```
  - **Manual:** Jika tidak menggunakan plugin manager (jarang untuk pengguna Neovim modern), pengguna harus mengkloning atau mengunduh dependensi secara manual ke salah satu direktori di `runtimepath` mereka. Ini kurang praktis dan rentan error.
- **Pengecekan Dependensi Opsional dalam Kode Plugin Anda:**

  - Jika plugin Anda memiliki fitur yang hanya berfungsi jika plugin/pustaka lain ada, Anda harus memeriksa keberadaannya dengan aman menggunakan `pcall`.
  - **Sintaks Per Baris (Pengecekan dengan `pcall`):**

    ```lua
    -- Cek apakah plugin 'optional-dependency' tersedia
    -- pcall(require, "nama_modul_dependensi")
    local dep_ok, optional_dep_module = pcall(require, 'optional-dependency.main') -- atau nama modul utamanya

    if dep_ok then
        -- Dependensi tersedia, kita bisa menggunakan optional_dep_module
        print("Dependensi opsional 'optional-dependency' ditemukan. Mengaktifkan fitur X...")
        -- optional_dep_module.setup_feature_x()
    else
        -- Dependensi tidak tersedia
        print("Dependensi opsional 'optional-dependency' tidak ditemukan.")
        vim.notify("MyCoolPlugin: Fitur X memerlukan 'optional-dependency' yang tidak terinstal.", vim.log.levels.INFO, {title = "MyCoolPlugin"})
        -- Anda bisa memilih untuk menonaktifkan fitur terkait secara diam-diam
        -- atau memberi tahu pengguna.
    end
    ```

  - **Penjelasan Kode `pcall`:**
    - `pcall(require, 'nama_dependensi')`: Mencoba me-`require` modul dependensi. `pcall` (protected call) akan menangkap error jika `require` gagal (misalnya, modul tidak ditemukan) tanpa menghentikan skrip Anda.
    - `dep_ok` (boolean): `true` jika `require` berhasil, `false` jika gagal.
    - `optional_dep_module`: Jika `dep_ok` adalah `true`, ini adalah modul yang di-require. Jika `dep_ok` adalah `false`, ini adalah pesan error dari `require`.

- **Komunikasi Kebutuhan Dependensi:**
  - **`README.md`:** Selalu cantumkan semua dependensi (wajib dan opsional) dengan jelas di file README plugin Anda. Sertakan instruksi atau contoh tentang cara pengguna dapat menginstalnya (biasanya melalui plugin manager).
  - **Dokumentasi (`doc/`):** Sebutkan juga di dokumentasi help.

---

Dengan menstrukturkan plugin Anda dengan rapi, menyediakan entry point `setup()` yang jelas, dan mengelola dependensi secara bertanggung jawab, Anda akan membuat plugin yang lebih mudah digunakan, dipahami, dipelihara, dan diintegrasikan oleh komunitas Neovim.

#### Bagian selanjutnya akan membahas rilis dan distribusi plugin.

> - **[Ke Atas](#)**
> - **[Selanjutnya][4]**
> - **[Sebelumnya][3]**
> - **[Kurikulum][2]**
> - **[Domain Spesifik][5]**

[5]: ../../../../../../../README.md
[4]: ../20-rilis/README.md
[3]: ../18-testing/README.md
[2]: ../../../../../README.md
[1]: ../../../neovim/README.md
