# **[17. Integrasi dengan Fitur Neovim Lainnya][1]**

Bagian ini akan membahas bagaimana plugin Lua Anda dapat berinteraksi dan memanfaatkan beberapa fitur paling transformatif di Neovim: Language Server Protocol (LSP) untuk kecerdasan kode, Treesitter untuk parsing kode tingkat lanjut, dan Telescope untuk pencarian fuzzy yang dapat diperluas. Anda akan menemukan bahwa kemampuan untuk mengintegrasikan plugin Anda dengan fitur-fitur canggih Neovim lainnya seperti LSP, Treesitter, dan plugin populer seperti Telescope, adalah kunci untuk menciptakan alat yang benar-benar kuat dan modern. Mari kita selami Bagian 17: Integrasi dengan Fitur Neovim Lainnya.

---

### 17.1 Language Server Protocol (LSP)

- **Deskripsi Konsep:**
  - **Language Server Protocol (LSP):** Adalah sebuah protokol terbuka (awalnya dikembangkan oleh Microsoft) yang mendefinisikan standar komunikasi antara editor atau IDE (sebagai "klien LSP") dan "language server" terpisah. Language server adalah proses yang menyediakan fungsionalitas pemahaman bahasa spesifik seperti auto-completion, go-to-definition, find-references, hover information, diagnostik (error/warning), dan pemformatan.
  - **Keuntungan LSP:**
    - **Dukungan Bahasa Universal:** Sebuah language server untuk suatu bahasa (misalnya, `pyright` untuk Python, `rust-analyzer` untuk Rust) dapat digunakan oleh _berbagai_ editor yang mendukung LSP, mengurangi duplikasi usaha dalam mengimplementasikan dukungan bahasa di setiap editor.
    - **Performa:** Analisis kode yang intensif seringkali dilakukan di proses server terpisah, sehingga tidak membebani thread utama editor.
    - **Fitur Kaya:** Memungkinkan fitur-fitur IDE canggih di editor teks seperti Neovim.
  - **Neovim sebagai Klien LSP:** Neovim memiliki klien LSP bawaan yang sangat mumpuni, diakses melalui namespace `vim.lsp` dan `vim.diagnostic`.
- **Terminologi:**
  - **LSP Client (Klien LSP):** Editor atau IDE (dalam kasus ini, Neovim) yang berkomunikasi dengan language server.
  - **Language Server:** Program eksternal yang menganalisis kode dan menyediakan layanan bahasa melalui LSP. **Anda perlu menginstal language server spesifik untuk bahasa yang ingin Anda gunakan** (misalnya, via `npm`, `pip`, atau manajer paket sistem).
  - **Capabilities (Kapabilitas):** Fitur-fitur yang didukung oleh klien LSP dan language server. Mereka "bernegosiasi" kapabilitas saat koneksi.
  - **Diagnostics (Diagnostik):** Pesan error, warning, atau informasi yang dihasilkan oleh language server tentang kode Anda.
  - **`on_attach`:** Fungsi callback yang sangat penting, dipanggil ketika klien LSP berhasil terhubung (attach) ke sebuah buffer. Di sinilah Anda biasanya mengatur keymap lokal-buffer untuk aksi LSP, mengaktifkan highlighting, dll.
- **Implementasi dalam Neovim:** Plugin Anda dapat:
  - Mengkonfigurasi dan memulai language server untuk tipe file tertentu.
  - Menyediakan UI kustom untuk fitur LSP (meskipun Neovim sudah memiliki UI default yang baik).
  - Menambahkan fungsionalitas di atas layanan LSP dasar.
- **Sumber Dokumentasi Neovim:**
  - `:h lsp` (Gambaran umum LSP di Neovim)
  - `:h vim.lsp` (Namespace utama untuk fungsi klien LSP)
  - `:h vim.diagnostic` (Namespace untuk mengelola dan menampilkan diagnostik)
  - `:h lsp-config` (Untuk konfigurasi umum klien LSP)
  - Dokumentasi spesifik untuk plugin konfigurasi LSP seperti `nvim-lspconfig` (sangat direkomendasikan untuk mempermudah pengaturan server).

#### Menggunakan `vim.lsp`

Modul `vim.lsp` adalah titik masuk utama untuk mengelola klien LSP. Plugin `nvim-lspconfig` sangat menyederhanakan konfigurasi untuk banyak language server umum, tetapi memahami API dasar `vim.lsp` tetap berguna.

- **Sintaks Per Baris (Elemen Kunci):**
  - **Memulai Language Server (Klien):**
    Biasanya menggunakan `vim.lsp.start_client(config)` atau fungsi pembungkus `vim.lsp.start(config)` (yang lebih baru dan lebih disukai).
    ```lua
    local lsp_config = {
        name = "mylang-server", -- Nama unik untuk konfigurasi klien ini
        cmd = {"nama_executable_language_server", "--arg1", "--arg2"}, -- Perintah untuk menjalankan server
        root_dir = vim.fs.dirname(vim.fs.find({'pyproject.toml', 'setup.py'}, {upward = true})[1] or vim.fn.getcwd()), -- Fungsi untuk menemukan root proyek
        -- capabilities = custom_capabilities_table, -- Opsional: kustomisasi kapabilitas klien
        on_attach = function(client, bufnr)
            -- Fungsi ini dipanggil setelah LSP client ter-attach ke buffer 'bufnr'.
            print("LSP client ID", client.id, "ter-attach ke buffer", bufnr)
            -- Di sini Anda akan mengatur keymap lokal-buffer, dll.
            -- Contoh: vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer = bufnr})
        end,
        handlers = { -- Opsional: kustomisasi handler untuk pesan LSP tertentu
            -- ["textDocument/publishDiagnostics"] = function(err, result, ctx, config) ... end,
        },
        -- filetypes = {"bahasa1", "bahasa2"}, -- Opsional: tipe file yang akan dilayani
        -- settings = { mylang_server_specific_setting = true }, -- Opsional: pengaturan spesifik server
    }
    -- vim.lsp.start(lsp_config) -- Memulai klien berdasarkan konfigurasi
    -- atau
    -- local client_id = vim.lsp.start_client(lsp_config)
    -- if client_id and client_id > 0 then
    --     vim.lsp.buf_attach_client(0, client_id) -- Attach ke buffer saat ini (jika start_client tidak otomatis)
    -- end
    ```
    - `name` (string): Nama untuk konfigurasi klien (berguna untuk debugging).
    - `cmd` (table): Perintah dan argumen untuk menjalankan language server.
    - `root_dir` (function | string): Fungsi yang menentukan direktori root proyek, atau path string. `vim.lsp.util.root_pattern` atau `vim.fs.find` sering digunakan di sini.
    - `capabilities` (table, opsional): Tabel untuk menyesuaikan kapabilitas yang diiklankan oleh klien Neovim ke server. Biasanya diambil dari `vim.lsp.protocol.make_client_capabilities()`.
    - `on_attach(client, bufnr)` (function, opsional tapi sangat penting): Callback yang dipanggil ketika server berhasil terhubung ke buffer `bufnr`. `client` adalah objek klien LSP. Di sinilah Anda biasanya mengatur keymap buffer-lokal untuk aksi LSP.
    - `handlers` (table, opsional): Memungkinkan Anda menimpa handler default Neovim untuk pesan LSP tertentu.
    - `filetypes` (table, opsional): Daftar tipe file yang akan memicu attachment otomatis klien ini.
    - `settings` (table, opsional): Pengaturan spesifik yang akan dikirim ke language server.
  - **Fungsi Permintaan LSP Umum (biasanya dipanggil dari `on_attach` atau keymap):**
    Semua fungsi ini biasanya beroperasi pada buffer saat ini atau buffer tertentu dan bersifat asinkron (menggunakan callback atau coroutine di baliknya).
    ```lua
    -- Di dalam on_attach(client, bufnr) atau keymap:
    -- vim.lsp.buf.hover() -- Menampilkan informasi hover
    -- vim.lsp.buf.definition() -- Lompat ke definisi
    -- vim.lsp.buf.references() -- Cari semua referensi
    -- vim.lsp.buf.implementation() -- Lompat ke implementasi
    -- vim.lsp.buf.type_definition() -- Lompat ke definisi tipe
    -- vim.lsp.buf.document_symbol() -- Daftar simbol dalam dokumen
    -- vim.lsp.buf.workspace_symbol("query") -- Cari simbol di workspace
    -- vim.lsp.buf.rename() -- Ganti nama simbol
    -- vim.lsp.buf.formatting_sync(opts) -- Format buffer (ada juga versi async)
    -- vim.lsp.buf.code_action() -- Tampilkan dan jalankan code actions
    ```
  - **Diagnostik (`vim.diagnostic`):**
    Language server mengirim diagnostik (error, warning). Namespace `vim.diagnostic` digunakan untuk mengonfigurasi bagaimana ini ditampilkan.
    ```lua
    -- Mengonfigurasi tampilan diagnostik (biasanya di setup global LSP Anda)
    vim.diagnostic.config({
        virtual_text = true, -- Tampilkan diagnostik sebagai virtual text
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
    })
    -- Membuka float diagnostik untuk posisi kursor saat ini
    -- vim.diagnostic.open_float(nil, {scope="cursor"})
    ```

**Contoh Kode (Konfigurasi LSP Sederhana - Konseptual):**

```lua
-- file: lsp_integration_example.lua
-- Jalankan di Neovim, dan pastikan Anda memiliki language server yang sesuai terinstal
-- (misalnya, 'lua-language-server' atau 'pyright') dan nvim-lspconfig.
-- Contoh ini lebih konseptual karena setup LSP lengkap biasanya lebih terlibat.

print("--- Contoh Integrasi LSP (Konseptual) ---")

-- Fungsi on_attach yang umum digunakan
local function my_on_attach_func(client, bufnr)
    print(string.format("LSP Client ID %d ter-attach ke buffer %d. Nama: %s", client.id, bufnr, client.name))

    -- Aktifkan completion (jika server mendukung dan Anda punya plugin completion)
    -- if client.supports_method("textDocument/completion") then
    --   -- Setup untuk plugin completion Anda
    -- end

    -- Buat keymap buffer-lokal untuk aksi LSP
    local map_opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", map_opts, { desc = "LSP Hover" }))
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", map_opts, { desc = "LSP Definition" }))
    vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", map_opts, { desc = "LSP References" }))
    vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, vim.tbl_extend("force", map_opts, { desc = "LSP Code Action" }))
    vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, vim.tbl_extend("force", map_opts, { desc = "LSP Format" }))

    -- Highlight simbol di bawah kursor (jika didukung)
    if client.supports_method("textDocument/documentHighlight") then
        vim.cmd("autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()")
        vim.cmd("autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()")
        -- Perlu augroup yang benar untuk ini dalam plugin nyata
    end
    print("Keymap LSP dasar diatur untuk buffer", bufnr)
end

-- Konfigurasi untuk language server (misalnya, untuk Lua menggunakan lua-language-server)
-- Dalam prakteknya, Anda akan menggunakan nvim-lspconfig untuk ini.
-- Ini adalah contoh PENYEDERHANAAN untuk ilustrasi API.
local lua_lsp_config = {
    name = "lua-lsp-example",
    -- cmd harus path ke executable language server Anda
    cmd = { "lua-language-server" }, -- GANTI DENGAN PATH SEBENARNYA JIKA PERLU
    root_dir = vim.lsp.util.root_pattern("init.lua", ".git"), -- Mencari init.lua atau .git ke atas
    on_attach = my_on_attach_func,
    filetypes = { "lua" },
    settings = { -- Pengaturan spesifik untuk lua-language-server
        Lua = {
            diagnostics = { globals = {'vim'} }
        }
    }
}

-- Mencoba memulai klien (ini mungkin gagal jika server tidak terinstal atau cmd salah)
print("Mencoba memulai klien LSP untuk Lua...")
-- vim.lsp.start(lua_lsp_config) -- Fungsi start yang lebih baru (direkomendasikan)
-- atau:
local client_id, err_start = pcall(vim.lsp.start_client, lua_lsp_config)

if client_id and type(client_id) == "number" and client_id > 0 then
    print("Klien LSP untuk Lua berhasil didaftarkan dengan ID:", client_id)
    print("LSP akan mencoba attach saat Anda membuka file Lua.")
    -- Biasanya tidak perlu attach manual jika 'filetypes' diset dan event FileType terpicu.
    -- vim.lsp.buf_attach_client(0, client_id) -- Untuk attach ke buffer saat ini secara manual
else
    print("Gagal memulai/mendaftarkan klien LSP untuk Lua:", err_start or client_id)
    print("Pastikan 'lua-language-server' (atau server yang Anda konfigurasi) terinstal dan ada di PATH.")
end

-- Konfigurasi tampilan diagnostik
vim.diagnostic.config({
    virtual_text = { prefix = '●', spacing = 4 }, -- Opsi untuk virtual text
    signs = true,
    underline = true,
    update_in_insert = false, -- Jangan update saat mengetik di insert mode (bisa mengganggu)
    severity_sort = true,     -- Urutkan diagnostik berdasarkan tingkat keparahan
})

print("\nUntuk menguji, buka file Lua. Jika server berjalan & ter-attach, coba 'K' (hover) atau 'gd' (definition).")
-- Untuk melihat klien LSP aktif: :LspInfo
```

**Cara Menjalankan Kode:**

1.  **PENTING:** Anda harus memiliki language server yang sesuai terinstal dan dapat diakses di PATH sistem Anda. Untuk contoh Lua, ini biasanya `lua-language-server` (dapat diinstal dari berbagai sumber, misalnya Sumneko's). Jika Anda mencoba dengan bahasa lain, ganti `cmd` dan `filetypes`.
2.  Simpan kode Lua di atas.
3.  Jalankan di Neovim: `:luafile lsp_integration_example.lua`.
4.  Buka file Lua. Jika semua berjalan lancar, Anda akan melihat pesan bahwa klien ter-attach. Kemudian Anda bisa mencoba keymap yang diatur (misalnya, `K` untuk hover, `gd` untuk definisi pada simbol Lua).
5.  Gunakan `:LspInfo` untuk melihat status klien LSP yang aktif.

**Penjelasan Kode Keseluruhan (`lsp_integration_example.lua`):**

- `my_on_attach_func`: Fungsi callback yang sangat penting. Ketika server LSP berhasil terhubung ke sebuah buffer, fungsi ini dipanggil. Di dalamnya, kita mengatur keymap lokal-buffer (`K` untuk hover, `gd` untuk definisi, dll.) menggunakan `vim.keymap.set`. Ini membuat interaksi LSP menjadi mudah diakses. Juga ada contoh untuk `documentHighlight`.
- `lua_lsp_config`: Tabel konfigurasi untuk klien LSP.
  - `name`: Nama internal.
  - `cmd`: Perintah untuk menjalankan executable language server. **Ini harus disesuaikan dengan instalasi Anda.**
  - `root_dir`: Fungsi untuk menentukan direktori root proyek.
  - `on_attach`: Menggunakan fungsi yang kita definisikan di atas.
  - `filetypes`: Menentukan bahwa konfigurasi ini untuk file Lua.
  - `settings`: Pengaturan spesifik untuk `lua-language-server` (misalnya, memberitahu tentang global `vim`).
- `pcall(vim.lsp.start_client, lua_lsp_config)`: Mencoba memulai (mendaftarkan) klien LSP. Jika berhasil, `client_id` akan dikembalikan. Untuk Neovim versi lebih baru, `vim.lsp.start(config)` lebih disukai karena menangani beberapa detail secara otomatis.
- `vim.diagnostic.config`: Mengkonfigurasi bagaimana diagnostik (error, warning) dari LSP akan ditampilkan (misalnya, sebagai virtual text, tanda di sign column, garis bawah).

**Penting:** Plugin `nvim-lspconfig` sangat menyederhanakan bagian pembuatan `lsp_config` untuk banyak server. Ia menyediakan konfigurasi default yang baik dan cara mudah untuk menimpanya. Contoh di atas lebih untuk menunjukkan API `vim.lsp` dasar.

---

### 17.2 Treesitter

- **Deskripsi Konsep:**
  - **Treesitter:** Adalah sebuah library parser incremental yang kuat. Ia dapat membangun _concrete syntax tree_ (CST) yang akurat dan detail dari kode sumber secara efisien, bahkan jika kode tersebut memiliki error sintaks.
  - **Keuntungan Treesitter:**
    - **Highlighting Sintaks yang Lebih Baik:** Memungkinkan highlighting yang jauh lebih akurat dan kontekstual daripada regex tradisional.
    - **Analisis Kode Struktural:** Karena memiliki pohon sintaks, kita bisa memahami struktur kode (fungsi, kelas, blok, dll.) secara programatik.
    - **Operasi Teks Berbasis Struktur:** Memungkinkan text object baru (misalnya, "select current function"), navigasi, dan refactoring yang sadar akan struktur kode.
    - **Incremental Parsing:** Cepat memperbarui pohon sintaks saat kode diedit, tanpa perlu mem-parse ulang seluruh file.
  - **Neovim dan Treesitter:** Neovim mengintegrasikan Treesitter secara mendalam untuk highlighting, indentasi, text object, dan sebagai dasar untuk fitur-fitur lainnya.
- **Terminologi:**
  - **Parser Treesitter:** Kompilasi C/C++ spesifik untuk setiap bahasa (misalnya, `parser-lua.so`, `parser-python.so`) yang menghasilkan pohon sintaks. **Anda perlu menginstal parser untuk bahasa yang ingin Anda gunakan** (biasanya melalui `:TSInstall nama_bahasa`).
  - **Syntax Tree (Pohon Sintaks):** Representasi hierarkis dari struktur kode.
  - **Node (Simpul):** Elemen individual dalam pohon sintaks (misalnya, identifier, keyword, function definition, if statement). Setiap node memiliki tipe, rentang posisi, dan bisa memiliki children.
  - **Query (Kueri):** Bahasa berbasis S-expression (mirip Lisp) untuk mengambil node atau pola tertentu dari pohon sintaks. Sangat kuat untuk analisis kode.
- **Implementasi dalam Neovim:** Plugin Anda dapat menggunakan Treesitter untuk:
  - Mendapatkan informasi struktural tentang kode di buffer.
  - Membuat text object kustom.
  - Memberikan highlighting semantik tambahan.
  - Analisis dan transformasi kode.
- **Sumber Dokumentasi Neovim:**
  - `:h treesitter` (Gambaran umum)
  - `:h vim.treesitter` (Namespace utama Lua)
  - `:h lua-treesitter` (API Lua untuk Treesitter)
  - `:h treesitter-parsers` (Tentang parser bahasa)
  - `:h treesitter-query` (Tentang bahasa kueri Treesitter)

#### Menggunakan API Treesitter (`vim.treesitter`)

Modul `vim.treesitter` dan `vim.treesitter.query` menyediakan fungsi untuk bekerja dengan pohon sintaks dan kueri.

- **Sintaks Per Baris (Elemen Kunci):**

  - **Mendapatkan Parser dan Pohon:**

    ```lua
    -- Pastikan parser untuk bahasa buffer saat ini sudah terinstal
    -- vim.treesitter.get_parser(buffer_handle_atau_0_untuk_saat_ini, nama_bahasa_opsional)
    local parser = vim.treesitter.get_parser(0) -- 0 untuk buffer saat ini

    if parser then
        -- parser:parse() mengembalikan tabel pohon (satu pohon per rentang, biasanya satu)
        local tree = parser:parse()[1] -- Ambil pohon pertama
        if tree then
            -- tree:root() mengembalikan node akar dari pohon sintaks
            local root_node = tree:root()
            -- ... sekarang Anda bisa bekerja dengan root_node ...
        end
    end
    ```

  - **Bekerja dengan Node:** Objek Node memiliki banyak metode berguna:
    ```lua
    -- Misalkan 'node' adalah objek node Treesitter
    -- node:type() -> string (tipe node, misal "function_definition", "identifier")
    -- node:name() -> string (nama field jika node adalah child bernama dari parent, opsional)
    -- node:start() -> row, col, byte_offset (0-indeks)
    -- node:end_() -> row, col, byte_offset (0-indeks) (perhatikan underscore di akhir 'end_')
    -- node:child_count() -> number
    -- node:child(index) -> node_obj or nil
    -- node:named_child_count() -> number
    -- node:named_child(index) -> node_obj or nil
    -- node:parent() -> node_obj or nil
    -- node:iter_children() -> iterator (untuk loop for node_child in node:iter_children() do ... end)
    -- vim.treesitter.get_node_text(node, buffer_handle) -> string (teks yang dicakup node)
    -- atau node:text() (metode yang lebih baru/nyaman pada objek node jika ada)
    ```
  - **Menggunakan Kueri Treesitter:**

    ```lua
    local bahasa = vim.api.nvim_buf_get_option(0, "filetype") -- Dapatkan filetype buffer saat ini
    local kueri_string = [[
        (function_definition
            name: (identifier) @function.name) ; Kueri untuk nama fungsi
    ]]
    -- vim.treesitter.query.parse(bahasa_string, string_kueri)
    local ts_query, err_parse_query = vim.treesitter.query.parse(bahasa, kueri_string)

    if ts_query then
        -- ts_query:iter_captures(root_node_pohon, buffer_handle, start_line_idx, end_line_idx)
        -- Mengiterasi semua "capture" (@function.name dalam contoh ini)
        for capture_id, node_tertangkap, metadata in ts_query:iter_captures(root_node, 0, 0, -1) do
            -- capture_id adalah ID internal capture
            -- node_tertangkap adalah objek node yang cocok dengan capture
            -- metadata berisi info seperti nama capture (misal, "function.name")
            local capture_name = ts_query.captures[capture_id] -- Mendapatkan nama capture
            local text_node = vim.treesitter.get_node_text(node_tertangkap, 0)
            print(string.format("Capture '%s': Teks '%s' pada baris %d",
                                capture_name, text_node, node_tertangkap:start()))
        end
    else
        print("Error parsing kueri Treesitter:", err_parse_query)
    end
    ```

    - `kueri_string`: String yang berisi kueri Treesitter. Kueri menggunakan sintaks S-expression untuk mendefinisikan pola node. `@nama.capture` digunakan untuk "menangkap" node tertentu.
    - `vim.treesitter.query.parse(bahasa, kueri_string)`: Mem-parse string kueri untuk bahasa tertentu menjadi objek kueri yang dapat dieksekusi.
    - `ts_query:iter_captures(...)`: Mengeksekusi kueri pada pohon sintaks (dimulai dari `root_node`) untuk buffer tertentu dan rentang baris, dan mengembalikan iterator untuk semua node yang "tercapture".

**Contoh Kode (Menggunakan Treesitter untuk Menemukan Nama Fungsi):**

```lua
-- file: treesitter_example.lua
-- Jalankan di Neovim pada buffer Lua: :luafile treesitter_example.lua
-- Pastikan parser Lua untuk Treesitter terinstal (:TSInstall lua)

print("--- Contoh Integrasi Treesitter ---")

local current_buf = vim.api.nvim_get_current_buf()
local filetype = vim.api.nvim_buf_get_option(current_buf, "filetype")

if filetype ~= "lua" then
    print("Contoh ini dirancang untuk file Lua. Silakan buka file Lua.")
    return
end

-- 1. Dapatkan parser dan pohon sintaks untuk buffer saat ini
-- vim.treesitter.get_parser(bufnr [, lang])
local parser = vim.treesitter.get_parser(current_buf, "lua") -- Eksplisit minta parser lua
if not parser then
    print("Parser Treesitter untuk Lua tidak ditemukan/aktif. Pastikan sudah diinstal (:TSInstall lua).")
    return
end

-- parser:parse() mengembalikan tabel pohon. Biasanya hanya ada satu.
local tree = parser:parse()[1]
if not tree then
    print("Gagal mem-parse buffer dengan Treesitter.")
    return
end

local root_node = tree:root()
print("Root node type:", root_node:type()) -- Harusnya 'chunk' atau 'program' untuk Lua

-- 2. Definisikan kueri Treesitter untuk menangkap nama fungsi
-- Kueri ini spesifik untuk struktur sintaks Lua yang dihasilkan oleh parser Lua Treesitter.
local function_name_query_str = [[
(function_statement
  name: (identifier) @function.name)

(function_call
  name: (identifier) @function.call.name)  -- Menangkap nama fungsi yang dipanggil juga
]]
-- Struktur kueri bisa lebih kompleks, misalnya untuk menangkap nama fungsi dalam assignment:
-- (variable_declaration
--   (variable_list (variable name: (identifier) @function.name))
--   init: (function_expression))

-- vim.treesitter.query.parse(lang, query_string)
local query_obj, err_q_parse = vim.treesitter.query.parse("lua", function_name_query_str)

if not query_obj then
    print("Error parsing kueri Treesitter:", err_q_parse)
    return
end

print("\n--- Nama Fungsi yang Ditemukan (via Kueri Treesitter) ---")
-- query:iter_captures(root_node, bufnr, start_line, end_line)
-- Mengiterasi semua "captures" dalam kueri di seluruh buffer (0, -1)
local found_functions = {}
for id, node, metadata in query_obj:iter_captures(root_node, current_buf, 0, -1) do
    -- query_obj.captures adalah array nama capture ["function.name", "function.call.name"]
    local capture_name = query_obj.captures[id]
    local node_text = vim.treesitter.get_node_text(node, current_buf)
    local start_row, start_col = node:start() -- 0-indeks

    table.insert(found_functions, string.format("  Capture '%s': '%s' (Baris: %d, Kolom: %d)",
                                     capture_name, node_text, start_row + 1, start_col + 1))
end

if #found_functions > 0 then
    for _, func_info in ipairs(found_functions) do
        print(func_info)
    end
else
    print("Tidak ada nama fungsi yang cocok dengan kueri ditemukan di buffer ini.")
end

-- Contoh iterasi manual node (untuk pemahaman, kueri lebih kuat)
print("\n--- Iterasi Manual Child dari Root (Contoh) ---")
local direct_children_types = {}
for child_node in root_node:iter_children() do
    table.insert(direct_children_types, child_node:type())
end
print("Tipe-tipe node anak langsung dari root:", table.concat(direct_children_types, ", "))
```

**Cara Menjalankan Kode:**

1.  Pastikan Anda telah menginstal parser Treesitter untuk Lua di Neovim (`:TSInstall lua` atau pastikan sudah ada di `:TSInstallInfo`).
2.  Buka file Lua yang berisi beberapa definisi fungsi (misalnya, file `treesitter_example.lua` itu sendiri).
3.  Jalankan dari Neovim: `:luafile treesitter_example.lua`.

**Penjelasan Kode Keseluruhan (`treesitter_example.lua`):**

- Memeriksa apakah filetype adalah Lua dan apakah parser Lua tersedia.
- `parser:parse()[1]` mem-parse seluruh buffer saat ini dan mengembalikan pohon sintaks utama.
- `root_node = tree:root()` mendapatkan node akar dari pohon tersebut.
- `function_name_query_str`: String kueri Treesitter yang dirancang untuk menemukan node `function_statement` dan menangkap `identifier` yang merupakan `name`-nya (sebagai `@function.name`). Juga ditambahkan contoh untuk menangkap pemanggilan fungsi.
- `vim.treesitter.query.parse("lua", ...)`: Mengkompilasi string kueri menjadi objek kueri yang dapat digunakan.
- `query_obj:iter_captures(...)`: Loop ini adalah inti dari eksekusi kueri. Ia menemukan semua node dalam pohon yang cocok dengan bagian-bagian yang ditandai dengan `@...` (captures) dalam string kueri.
  - `id`: ID internal dari capture dalam kueri (misalnya, `@function.name` mungkin ID ke-1, `@function.call.name` ID ke-2).
  - `node`: Objek node Treesitter yang tertangkap.
  - `metadata`: Bisa berisi informasi tambahan tentang capture.
  - `query_obj.captures[id]`: Mengambil nama string dari capture (misalnya, `"function.name"`).
  - `vim.treesitter.get_node_text(node, current_buf)`: Mendapatkan teks aktual dari source code yang dicakup oleh `node`.
- Bagian "Iterasi Manual" hanya menunjukkan cara dasar untuk melihat anak-anak langsung dari root node, untuk kontras dengan kekuatan kueri.

---

### 17.3 Telescope (Integrasi dengan Plugin Populer)

- **Deskripsi Konsep:**
  - **Telescope.nvim:** Adalah plugin pencarian fuzzy (fuzzy finder) yang sangat populer dan dapat diperluas untuk Neovim. Ia memungkinkan pengguna untuk dengan cepat mencari file, buffer, simbol, command history, help tags, diagnostik LSP, dan banyak lagi, dengan UI yang interaktif dan preview.
  - **Ekstensibilitas:** Salah satu kekuatan utama Telescope adalah kemudahannya untuk diperluas. Plugin lain dapat menyediakan "source" (sumber data) kustom untuk Telescope, memungkinkan pengguna untuk mencari dan memilih dari data spesifik plugin tersebut menggunakan antarmuka Telescope yang sudah familiar.
- **Terminologi:**
  - **Picker:** Antarmuka Telescope secara keseluruhan yang menampilkan daftar item yang dapat dicari dan dipilih.
  - **Source (Sumber):** Logika yang menyediakan item-item untuk ditampilkan dalam picker. Setiap "builtin" Telescope (seperti `find_files`, `live_grep`) adalah sebuah source.
  - **Finder:** Komponen yang bertanggung jawab untuk menemukan dan memfilter item (misalnya, `find_files.lua` menggunakan `fd` atau `find`).
  - **Sorter:** Komponen yang mengurutkan item yang cocok.
  - **Previewer:** Komponen yang menampilkan preview untuk item yang sedang dipilih.
  - **Actions (Aksi):** Fungsi yang dapat dijalankan pada item yang dipilih atau pada state picker.
- **Implementasi dalam Neovim:** Jika plugin Anda mengelola sekumpulan data yang mungkin ingin dicari atau dipilih oleh pengguna (misalnya, daftar catatan, daftar proyek, TODO item), mengintegrasikannya dengan Telescope dapat memberikan pengalaman pengguna yang sangat baik.
- **Cara Integrasi Umum:**
  1.  **Membuat Custom Picker/Source:** Ini melibatkan pendefinisian fungsi yang menggunakan API Telescope (misalnya, dari `require('telescope.pickers')`, `require('telescope.finders')`, `require('telescope.sorters')`, `require('telescope.actions')`) untuk membuat picker baru. Anda perlu menyediakan:
      - **Finder:** Fungsi atau tabel yang menghasilkan daftar item awal. Setiap item biasanya adalah string atau tabel yang berisi data yang relevan.
      - **Entry Maker (Pembuat Entri):** Fungsi yang mengubah item mentah Anda menjadi format yang dipahami Telescope (biasanya tabel dengan field `value`, `display`, `ordinal`).
      - **Sorter:** Mengkonfigurasi bagaimana item diurutkan.
      - **Previewer:** (Opsional) Fungsi yang menampilkan preview untuk item yang dipilih.
      - **Actions:** (Opsional) Fungsi untuk tindakan kustom pada pemilihan.
  2.  **Mengekspos Picker:** Menyediakan perintah pengguna atau fungsi Lua yang dapat dipanggil untuk meluncurkan picker kustom Anda.
- **Sumber Dokumentasi Telescope:**
  - Dokumentasi resmi Telescope di repositori GitHub-nya adalah sumber terbaik: [https://github.com/nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) (terutama bagian "For Developers" atau "Custom Pickers").
  - `:h telescope` (jika Telescope terinstal).

**Contoh Kode (Membuat Picker Telescope Kustom Sederhana - Konseptual):**

```lua
-- file: telescope_integration_example.lua
-- Jalankan di Neovim: :luafile telescope_integration_example.lua
-- PENTING: Plugin Telescope.nvim harus terinstal agar kode ini berjalan.

print("--- Contoh Integrasi Telescope (Konseptual) ---")

-- Coba require modul-modul Telescope
local telescope_ok, telescope = pcall(require, "telescope")
local pickers_ok, pickers = pcall(require, "telescope.pickers")
local finders_ok, finders = pcall(require, "telescope.finders")
local sorters_ok, sorters = pcall(require, "telescope.sorters")
local actions_ok, actions = pcall(require, "telescope.actions")
local action_state_ok, action_state = pcall(require, "telescope.actions.state")

if not (telescope_ok and pickers_ok and finders_ok and sorters_ok and actions_ok and action_state_ok) then
    print("Error: Telescope.nvim atau salah satu modulnya tidak ditemukan.")
    print("Pastikan Telescope.nvim terinstal dengan benar.")
    return
end

-- Fungsi untuk membuat dan meluncurkan picker kustom
function ShowMyCustomTelescopePicker()
    -- Data contoh untuk ditampilkan di picker
    local my_custom_data = {
        { name = "Proyek Alpha", path = "/path/to/alpha", last_accessed = "2024-05-20" },
        { name = "Plugin Beta Keren", path = "/path/to/beta_plugin", last_accessed = "2024-05-28" },
        { name = "Dokumen Gamma", path = "/docs/gamma.md", last_accessed = "2024-05-01" },
        { name = "Catatan Delta Harian", path = "/notes/delta_2024-05-30.txt", last_accessed = "2024-05-30" },
    }

    -- Opsi untuk picker baru
    local picker_opts = {
        prompt_title = "Pilih Item Kustom Saya",
        -- Finder: menyediakan item-item mentah
        finder = finders.new_table({
            results = my_custom_data,
            -- Entry maker: mengubah item mentah menjadi format yang bisa ditampilkan Telescope
            entry_maker = function(entry_raw)
                return {
                    value = entry_raw, -- Nilai asli (seluruh tabel item)
                    display = string.format("%s (di %s)", entry_raw.name, entry_raw.path), -- Teks yang ditampilkan di picker
                    ordinal = entry_raw.name, -- Teks yang digunakan untuk pencarian fuzzy
                    -- Anda bisa menambahkan field lain di sini yang bisa digunakan oleh previewer atau actions
                    path_data = entry_raw.path,
                }
            end
        }),
        -- Sorter: bagaimana item diurutkan
        sorter = sorters.get_generic_fuzzy_sorter(), -- Sorter fuzzy generik
        -- Previewer: menampilkan preview untuk item yang dipilih
        previewer = telescope.extensions.previewers.new_buffer_previewer_maker({ -- Previewer sederhana ke buffer
            title = "Detail Item",
            get_buffer_by_name = function(_, entry)
                return entry.value.path -- Gunakan path sebagai nama buffer preview (unik)
            end,
            define_preview = function(self, entry, status) -- self adalah objek previewer
                -- Pastikan buffer preview valid
                if not self.state.bufnr or not vim.api.nvim_buf_is_valid(self.state.bufnr) then
                    print("Buffer preview tidak valid untuk", entry.value.name)
                    return
                end
                -- Isi buffer preview dengan detail item
                local content = {
                    "Nama Item: " .. entry.value.name,
                    "Path     : " .. entry.value.path,
                    "Akses Terakhir: " .. entry.value.last_accessed,
                    "---",
                    "Tekan <CR> untuk membuka path (contoh aksi).",
                }
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, content)
            end,
        }),
        -- Layout dan opsi lain bisa ditambahkan di sini
        layout_config = {
            horizontal = { preview_width = 0.6 }
        },
        -- Menambahkan action kustom
        attach_mappings = function(prompt_bufnr, map)
            -- Fungsi ini dipanggil untuk mengatur pemetaan di buffer prompt Telescope
            -- map('mode', 'lhs', function() action_code end, {opts})
            actions.select_default:replace(function()
                actions.close(prompt_bufnr) -- Tutup picker Telescope
                local selection = action_state.get_selected_entry()
                if selection then
                    vim.notify("Anda memilih: " .. selection.display)
                    print("Data lengkap pilihan:", vim.inspect(selection.value))
                    -- Contoh aksi: buka file jika path ada
                    -- vim.cmd("edit " .. vim.fn.fnameescape(selection.value.path))
                end
            end)
            return true -- Penting untuk mengembalikan true
        end,
    }

    -- Membuat dan menampilkan picker
    -- pickers.new(opts) mengembalikan objek picker, panggil :find() untuk menampilkannya
    local custom_picker = pickers.new(picker_opts)
    custom_picker:find()
    print("Picker Telescope kustom diluncurkan.")
end

-- Membuat perintah pengguna untuk meluncurkan picker kustom
-- vim.api.nvim_create_user_command(name, command_or_func, opts)
vim.api.nvim_create_user_command("MyTelescopePicker", ShowMyCustomTelescopePicker, {
    desc = "Luncurkan picker Telescope kustom saya"
})
print("Perintah pengguna :MyTelescopePicker telah dibuat.")
print("Ketik :MyTelescopePicker untuk meluncurkan picker.")
```

**Cara Menjalankan Kode:**

1.  **PENTING:** Pastikan Anda memiliki plugin `nvim-telescope/telescope.nvim` (dan dependensinya seperti `nvim-lua/plenary.nvim`) terinstal dengan benar di Neovim.
2.  Simpan kode Lua di atas.
3.  Jalankan di Neovim: `:luafile telescope_integration_example.lua`. Ini akan mendefinisikan fungsi dan perintah pengguna.
4.  Kemudian, jalankan perintah pengguna yang baru dibuat: `:MyTelescopePicker`.
5.  Antarmuka Telescope akan muncul dengan item-item kustom Anda. Anda bisa mencari, melihat preview, dan menekan Enter.

**Penjelasan Kode Keseluruhan (`telescope_integration_example.lua`):**

- **Pengecekan `require`:** Kode dimulai dengan mencoba memuat modul-modul Telescope yang diperlukan menggunakan `pcall` untuk menangani kasus jika Telescope tidak terinstal.
- **`ShowMyCustomTelescopePicker()`:** Fungsi utama yang membuat dan meluncurkan picker.
  - `my_custom_data`: Contoh data (array dari tabel) yang akan ditampilkan.
  - `picker_opts`: Tabel konfigurasi besar untuk `pickers.new()`.
    - `prompt_title`: Judul untuk picker.
    - `finder`: Menggunakan `finders.new_table` untuk menyediakan data dari tabel Lua.
      - `results`: Data mentah.
      - `entry_maker`: Fungsi yang sangat penting. Ia mengubah setiap item dalam `my_custom_data` menjadi format yang dipahami Telescope. Setiap entri yang dikembalikan harus memiliki setidaknya `value` (data asli), `display` (string yang ditampilkan di daftar), dan `ordinal` (string yang digunakan untuk pencarian/pengurutan).
    - `sorter`: Menggunakan `sorters.get_generic_fuzzy_sorter()` untuk pengurutan fuzzy standar.
    - `previewer`: Mendefinisikan previewer kustom menggunakan `previewers.new_buffer_previewer_maker`.
      - `get_buffer_by_name`: Mengelola buffer untuk preview.
      - `define_preview`: Fungsi yang dipanggil untuk mengisi buffer preview dengan konten berdasarkan `entry` yang sedang dipilih.
    - `layout_config`: Contoh konfigurasi tata letak (lebar preview).
    - `attach_mappings`: Fungsi untuk menimpa atau menambahkan keymap di dalam picker Telescope. Di sini, aksi default untuk Enter (`actions.select_default`) ditimpa untuk menutup picker dan kemudian melakukan sesuatu dengan item yang dipilih (`action_state.get_selected_entry()`).
  - `pickers.new(picker_opts)`: Membuat instance picker.
  - `custom_picker:find()`: Menampilkan picker ke pengguna.
- **`vim.api.nvim_create_user_command(...)`**: Membuat perintah pengguna `:MyTelescopePicker` yang akan memanggil fungsi `ShowMyCustomTelescopePicker` kita.

Integrasi dengan Telescope bisa sangat meningkatkan kegunaan plugin Anda dengan menyediakan antarmuka pencarian dan pemilihan yang kuat dan familiar bagi pengguna Neovim.

---

Kita telah membahas integrasi dengan tiga fitur Neovim yang sangat kuat: LSP, Treesitter, dan Telescope. Masing-masing adalah topik yang luas, tetapi pemahaman dasar tentang API dan konsepnya akan sangat membantu Anda sebagai pengembang plugin Neovim.

> - **[Ke Atas](#)**
> - **[Selanjutnya][4]**
> - **[Sebelumnya][3]**
> - **[Kurikulum][2]**
> - **[Domain Spesifik][5]**

[5]: ../../../../../../../README.md
[4]: ../18-testing/README.md
[3]: ../16-floating-windows/README.md
[2]: ../../../../../README.md
[1]: ../../README.md/#17-file-system-operations
