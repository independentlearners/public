# **[13. Neovim API - Interaksi dengan Editor][1]**

Neovim menyediakan dua cara utama bagi skrip Lua untuk berinteraksi dengan fungsionalitas inti editor: melalui namespace `vim.fn` (untuk memanggil fungsi Vimscript) dan namespace `vim.api` (untuk API Lua Neovim yang lebih modern dan terstruktur). Ini adalah inti dari pengembangan plugin Neovim, karena di sinilah kode Lua Anda mulai "berbicara" dan mengontrol editor Neovim itu sendiri. Pemahaman yang baik tentang API ini memungkinkan Anda memanipulasi buffer, jendela, opsi, dan banyak lagi.

---

### 13.1 Akses Fungsi Vim (`vim.fn`)

- **Deskripsi Konsep:** Namespace `vim.fn` memungkinkan Anda untuk memanggil hampir semua fungsi bawaan Vimscript dan fungsi Vimscript yang didefinisikan pengguna (user-defined) langsung dari Lua. Ini menyediakan jembatan ke fungsionalitas Vim yang luas yang mungkin belum memiliki padanan langsung di `vim.api` atau jika Anda lebih familiar dengan fungsi Vimscript tertentu.
- **Terminologi:**
  - **Fungsi Vim (Vim Functions):** Fungsi yang biasanya Anda panggil dalam skrip Vim (file `.vim`). Ini termasuk fungsi bawaan seperti `expand()`, `getline()`, `setline()`, dan fungsi kustom yang Anda definisikan dengan `function! MyFunc() ... endfunction`.
  - **Namespace `vim.fn`:** Tabel Lua yang disediakan oleh Neovim di mana setiap field-nya adalah fungsi Vim yang dapat dipanggil.
- **Sintaks Per Baris (Elemen Kunci):**
  - **Pemanggilan Fungsi:**
    ```lua
    local hasil = vim.fn.nama_fungsi_vim(argumen1, argumen2, ...)
    ```
    - `vim.fn`: Namespace tempat semua fungsi Vim berada.
    - `nama_fungsi_vim`: Nama fungsi Vim yang ingin Anda panggil (misalnya, `getcwd`, `expand`, `strdisplaywidth`).
    - `argumen1, argumen2, ...`: Argumen yang diteruskan ke fungsi Vim.
  - **Konversi Tipe Data:** Penting untuk diingat bahwa ada konversi tipe data otomatis antara Lua dan Vimscript:
    - String Lua ↔ String Vim
    - Angka Lua ↔ Angka Vim
    - Boolean Lua (`true`/`false`) ↔ Angka Vim (`1`/`0`)
    - Tabel Lua (array-like) ↔ List Vim
    - Tabel Lua (dictionary-like) ↔ Dictionary Vim
    - `nil` Lua ↔ `v:null` atau nilai khusus Vim (misalnya, string kosong atau 0 tergantung fungsi).
      Kadang-kadang, konversi ini bisa memiliki nuansa atau batasan tertentu yang perlu diperhatikan.
- **Implementasi dalam Neovim:** `vim.fn` berguna untuk:
  - Mengakses fungsi Vim yang tidak (atau belum) ada di `vim.api`.
  - Porting skrip Vim yang ada ke Lua secara bertahap.
  - Tugas-tugas sederhana di mana fungsi Vimscript sudah sangat dikenal.
- **Sumber Dokumentasi Neovim:**
  - `:h vim.fn` (Buka Neovim dan ketik perintah ini)
  - `:h lua-vim-stdlib`
  - Dokumentasi untuk fungsi Vim spesifik, misalnya `:h expand()` atau `:h getcwd()`.

**Contoh Kode (`vim.fn`):**

```lua
-- file: vim_fn_example.lua
-- Kode ini HARUS dijalankan di dalam Neovim, misalnya dengan :luafile vim_fn_example.lua

print("--- Menggunakan vim.fn ---")

-- 1. Mendapatkan direktori kerja saat ini (mirip 'pwd')
-- vim.fn.getcwd() memanggil fungsi Vim getcwd().
-- Tidak ada argumen yang diperlukan untuk getcwd().
local current_dir = vim.fn.getcwd()
print("Direktori kerja saat ini:", current_dir) -- Output: (path direktori Anda)

-- 2. Meng-expand path khusus Vim
-- vim.fn.expand('%:h') memanggil fungsi Vim expand() dengan argumen '%:h'.
-- '%:h' dalam Vim berarti "head" (direktori) dari nama file buffer saat ini.
-- Agar ini bekerja dengan baik, jalankan di buffer yang sudah disimpan ke file.
local file_dir = vim.fn.expand('%:h')
if file_dir == "" then
    print("Direktori file saat ini: (Tidak ada nama file buffer atau buffer belum disimpan)")
else
    print("Direktori file saat ini:", file_dir)
end

-- 3. Menghitung lebar tampilan string (memperhitungkan karakter multi-byte)
-- vim.fn.strdisplaywidth("contoh teks 日本語") memanggil fungsi Vim strdisplaywidth().
local text_to_measure = "Contoh 日本語"
local display_width = vim.fn.strdisplaywidth(text_to_measure)
print(string.format("Lebar tampilan untuk '%s': %d kolom", text_to_measure, display_width))
-- Output akan lebih besar dari #text_to_measure jika ada karakter multi-byte.

-- 4. Mendapatkan input dari pengguna
-- vim.fn.input("Prompt: ") memanggil fungsi Vim input() untuk menampilkan prompt dan menerima input.
-- Ini adalah operasi blocking, Neovim akan menunggu input.
-- local user_input = vim.fn.input("Masukkan nama Anda: ")
-- if user_input ~= nil and user_input ~= "" then
--     print("Halo, " .. user_input)
-- else
--     print("Tidak ada input atau input dibatalkan.")
-- end
-- (Dikommentari agar tidak memblokir eksekusi otomatis contoh lain)
print("Contoh vim.fn.input() dikomentari untuk menghindari blokir.")

-- 5. Memeriksa apakah sebuah fitur didukung
-- vim.fn.has("nvim-0.7") memeriksa apakah fitur "nvim-0.7" ada (versi Neovim).
-- Mengembalikan 1 jika ada (truthy di Lua), 0 jika tidak (falsy di Lua).
if vim.fn.has("nvim-0.7") == 1 then
    print("Neovim versi 0.7 atau lebih tinggi terdeteksi via vim.fn.has().")
else
    print("Neovim versi lebih lama dari 0.7 atau fitur tidak terdeteksi.")
end
```

**Cara Menjalankan Kode:**

1.  Buka Neovim.
2.  Simpan kode di atas ke sebuah file, misalnya `vim_fn_example.lua`.
3.  Jalankan dari Neovim dengan perintah `:luafile vim_fn_example.lua`. Anda juga bisa mengetik baris-baris individual diawali dengan `:lua ` (misalnya, `:lua print(vim.fn.getcwd())`).

**Penjelasan Kode Keseluruhan (`vim_fn_example.lua`):**

- Setiap panggilan `vim.fn.nama_fungsi(...)` mengeksekusi fungsi Vimscript yang sesuai.
- `vim.fn.getcwd()`: Mengembalikan string path direktori kerja saat ini.
- `vim.fn.expand('%:h')`: Mengembalikan string path direktori dari file yang sedang diedit. Jika buffer tidak memiliki nama file terkait (misalnya, buffer baru yang belum disimpan), ini mungkin mengembalikan string kosong.
- `vim.fn.strdisplaywidth(...)`: Berguna untuk menghitung berapa banyak kolom layar yang akan digunakan oleh sebuah string, penting untuk UI.
- `vim.fn.input(...)`: Contoh fungsi interaktif yang memblokir.
- `vim.fn.has(...)`: Cara standar di Vimscript (dan via `vim.fn`) untuk memeriksa keberadaan fitur atau versi.

---

### 13.2 API Lua Neovim (`vim.api`)

- **Deskripsi Konsep:** Namespace `vim.api` menyediakan antarmuka yang lebih modern, terstruktur, dan seringkali lebih efisien untuk berinteraksi dengan Neovim dari Lua. Fungsi-fungsi ini dirancang khusus untuk penggunaan programatik, seringkali menerima dan mengembalikan tipe data Lua secara lebih langsung (misalnya, booleans, handle numerik) dan menggunakan tabel (dictionaries) untuk opsi yang kompleks. API ini stabil dan menjadi cara yang direkomendasikan untuk sebagian besar interaksi editor.
- **Terminologi:**
  - **API Lua Neovim:** Sekumpulan fungsi yang diekspos melalui `vim.api` untuk mengontrol dan menginterogasi editor. Nama fungsinya biasanya diawali dengan `nvim_`.
  - **Handle:** Angka integer yang merepresentasikan entitas editor seperti buffer, jendela (window), atau tabpage. Ini memungkinkan operasi yang ditargetkan secara spesifik. `0` seringkali berarti "entitas saat ini" (misalnya, buffer saat ini, jendela saat ini).
- **Sintaks Per Baris (Elemen Kunci):**
  - **Pemanggilan Fungsi API:**
    ```lua
    local hasil = vim.api.nama_fungsi_nvim(argumen1, argumen2, ...)
    ```
    - `vim.api`: Namespace tempat semua fungsi API Neovim berada.
    - `nama_fungsi_nvim`: Nama fungsi API (misalnya, `nvim_get_current_buf`, `nvim_buf_set_lines`).
    - `argumen1, ...`: Argumen yang diperlukan oleh fungsi API tersebut. Perhatikan tipe data yang diharapkan (angka untuk handle, string, boolean, tabel untuk list atau dictionary).
  - **Error Handling:** Banyak fungsi `vim.api` akan memunculkan error Lua jika terjadi masalah (misalnya, handle tidak valid, argumen salah). Oleh karena itu, penting untuk membungkus panggilan API yang berpotensi gagal dalam `pcall` atau `xpcall` dalam kode plugin yang robust.
    ```lua
    local success, result_or_err = pcall(vim.api.nama_fungsi_nvim, arg1, arg2)
    if not success then
        print("Error API:", result_or_err)
    end
    ```
- **Implementasi dalam Neovim:** Ini adalah cara utama plugin modern berinteraksi dengan Neovim untuk tugas-tugas seperti:
  - Membaca dan memodifikasi konten buffer.
  - Mengelola tata letak jendela dan tab.
  - Mengatur opsi editor.
  - Mengeksekusi perintah Ex.
  - Mendefinisikan dan menghapus keymap.
- **Sumber Dokumentasi Neovim:**
  - `:h api` (dokumentasi umum untuk keseluruhan API, termasuk konvensi).
  - `:h lua-api` (spesifik untuk penggunaan API dari Lua).
  - Setiap fungsi API memiliki halaman help sendiri, misalnya `:h nvim_get_current_buf()`.

#### Key Areas (Area Kunci dari `vim.api`):

**1. Manipulasi Buffer:**

- **Sintaks Umum:** Fungsi-fungsi ini biasanya menerima _buffer handle_ (angka) sebagai argumen pertama. `0` berarti buffer saat ini.
- `vim.api.nvim_get_current_buf()`: Mengembalikan handle buffer saat ini.
- `vim.api.nvim_buf_line_count(buffer_handle)`: Mengembalikan jumlah baris dalam buffer.
- `vim.api.nvim_buf_get_lines(buffer_handle, start_line_idx, end_line_idx, include_nl_bool)`: Mendapatkan list (tabel Lua) dari baris-baris. Indeks berbasis 0. `end_line_idx = -1` berarti hingga akhir buffer. `include_nl_bool` menentukan apakah karakter newline diikutkan.
- `vim.api.nvim_buf_set_lines(buffer_handle, start_line_idx, end_line_idx, replace_nl_bool, lines_table)`: Mengatur/mengganti baris-baris.

**Contoh Kode (Buffer):**

```lua
-- file: vim_api_buffer_example.lua
-- Jalankan di Neovim: :luafile vim_api_buffer_example.lua

print("--- vim.api - Manipulasi Buffer ---")

-- Mendapatkan handle buffer saat ini
-- vim.api.nvim_get_current_buf() tidak memerlukan argumen.
local current_buf_handle = vim.api.nvim_get_current_buf()
print("Handle buffer saat ini:", current_buf_handle)

-- Mendapatkan jumlah baris di buffer saat ini
-- vim.api.nvim_buf_line_count(buffer_handle)
local line_count = vim.api.nvim_buf_line_count(current_buf_handle)
print("Jumlah baris di buffer " .. current_buf_handle .. ":", line_count)

-- Mendapatkan beberapa baris pertama (misalnya, 5 baris) dari buffer saat ini
-- vim.api.nvim_buf_get_lines(buffer_handle, start_idx, end_idx, include_newline_bool)
-- Indeks baris berbasis 0. 'end_idx = -1' berarti hingga akhir buffer.
local start_idx = 0 -- baris pertama
local end_idx = 5   -- hingga baris kelima (tidak inklusif jika dihitung sebagai panjang, atau inklusif jika sebagai indeks akhir)
                    -- API: "end_idx is exclusive, or -1 for end of buffer"
                    -- Jadi, 0, 5 akan mengambil baris 0, 1, 2, 3, 4.
local include_newline = false
local lines_table, err_get = pcall(vim.api.nvim_buf_get_lines, current_buf_handle, start_idx, end_idx, include_newline)
if lines_table then -- pcall mengembalikan true jika tidak ada error
    print("Baris " .. start_idx+1 .. " hingga " .. end_idx .. " (atau akhir buffer jika lebih pendek):")
    for i, line_content in ipairs(lines_table) do
        print(string.format("  L%d: %s", start_idx + i, line_content))
    end
else
    print("Error mendapatkan baris:", err_get)
end

-- Menulis/mengganti beberapa baris di buffer saat ini
-- vim.api.nvim_buf_set_lines(buffer_handle, start_idx, end_idx, strict_indexing_bool, replacement_lines_table)
-- 'strict_indexing_bool': jika true, error jika end_idx melebihi batas. Jika false, disesuaikan.
-- Untuk mengganti baris 0 dan 1 (baris ke-1 dan ke-2 di editor):
local replacement_data = {
    "--- Baris ini diubah oleh Lua API ---",
    "--- Baris kedua juga diubah ---"
}
local set_start_idx = 0 -- Ganti mulai dari baris pertama (indeks 0)
local set_end_idx = 2   -- Ganti hingga sebelum baris ketiga (indeks 2), artinya baris indeks 0 dan 1 diganti.
                        -- Jika set_end_idx = set_start_idx, itu berarti menyisipkan sebelum set_start_idx.
local strict_indexing = false -- Lebih aman untuk tidak error jika indeks di luar batas sedikit.
local success_set, err_set = pcall(vim.api.nvim_buf_set_lines, current_buf_handle, set_start_idx, set_end_idx, strict_indexing, replacement_data)
if success_set then
    print("Baris berhasil diubah/disetel.")
else
    print("Error mengubah baris:", err_set)
end
```

**Penjelasan Kode Keseluruhan (Buffer):**

- Mengambil handle buffer saat ini (`nvim_get_current_buf`).
- Menghitung jumlah barisnya (`nvim_buf_line_count`).
- Mengambil 5 baris pertama (`nvim_buf_get_lines`). Perhatikan indeks berbasis 0 dan bagaimana `end_idx` bekerja. Panggilan dibungkus `pcall` untuk menangani error jika buffer tidak bisa diakses.
- Mengganti dua baris pertama buffer dengan teks baru (`nvim_buf_set_lines`). `strict_indexing` penting untuk bagaimana indeks di luar batas ditangani.

**2. Manajemen Jendela (Window):**

- **Sintaks Umum:** Fungsi-fungsi ini biasanya menerima _window handle_ (angka) sebagai argumen pertama. `0` berarti jendela saat ini.
- `vim.api.nvim_get_current_win()`: Mengembalikan handle jendela saat ini.
- `vim.api.nvim_win_get_height(window_handle)`: Mendapatkan tinggi jendela.
- `vim.api.nvim_win_set_width(window_handle, width_int)`: Mengatur lebar jendela.
- `vim.api.nvim_open_win(buffer_handle, enter_bool, config_table)`: Membuka jendela baru. `config_table` adalah tabel Lua yang berisi opsi konfigurasi jendela (misalnya, `relative`, `width`, `height`, `row`, `col`, `border`).

**Contoh Kode (Window):**

```lua
-- file: vim_api_window_example.lua
-- Jalankan di Neovim: :luafile vim_api_window_example.lua

print("\n--- vim.api - Manajemen Jendela ---")

-- Mendapatkan handle jendela saat ini
-- vim.api.nvim_get_current_win() tidak memerlukan argumen.
local current_win_handle = vim.api.nvim_get_current_win()
print("Handle jendela saat ini:", current_win_handle)

-- Mendapatkan tinggi jendela saat ini
-- vim.api.nvim_win_get_height(window_handle)
local height = vim.api.nvim_win_get_height(current_win_handle)
print("Tinggi jendela " .. current_win_handle .. ":", height .. " baris")

-- Mengatur lebar jendela saat ini menjadi 50 kolom
-- vim.api.nvim_win_set_width(window_handle, width)
local new_width = 50
local success_width, err_width = pcall(vim.api.nvim_win_set_width, current_win_handle, new_width)
if success_width then
    print("Lebar jendela diatur ke:", new_width)
else
    print("Error mengatur lebar jendela:", err_width)
end

-- Membuka jendela floating baru (contoh sederhana)
-- vim.api.nvim_open_win(buffer_handle, enter_bool, config_table)
-- 'buffer_handle': buffer yang akan ditampilkan (0 untuk buffer kosong baru)
-- 'enter_bool': apakah akan masuk ke jendela baru
-- 'config_table': tabel opsi untuk jendela
local buf_for_float = vim.api.nvim_create_buf(false, true) -- Buat buffer scratch (tidak terdaftar, bisa dihapus)
vim.api.nvim_buf_set_lines(buf_for_float, 0, -1, false, {"Ini adalah jendela floating!", "Dibuat dari Lua API."})

local float_config = {
    relative = 'editor', -- Relatif terhadap editor
    width = 40,
    height = 5,
    row = 5,
    col = 10,
    style = "minimal", -- Tidak ada number line, dll.
    border = "single"  -- Tipe border: "none", "single", "double", "rounded", dll.
}
local float_win_handle, err_float = pcall(vim.api.nvim_open_win, buf_for_float, true, float_config)
if float_win_handle and type(float_win_handle) == "number" then -- pcall mengembalikan true, float_win_handle adalah hasil pertama
    print("Jendela floating baru dibuka dengan handle:", float_win_handle)
    -- Untuk menutupnya setelah beberapa saat (memerlukan pemahaman tentang event loop/timer untuk cara non-blocking)
    -- vim.defer_fn(function() vim.api.nvim_win_close(float_win_handle, true) print("Jendela float ditutup.") end, 3000) -- Tutup setelah 3 detik
else
    print("Error membuka jendela floating:", err_float or float_win_handle) -- float_win_handle bisa jadi pesan error jika pcall mengembalikan false
end
print("Contoh vim.defer_fn untuk menutup float dikomentari agar tidak bergantung pada pemahaman async dulu.")
```

**Penjelasan Kode Keseluruhan (Window):**

- Mengambil handle jendela saat ini (`nvim_get_current_win`) dan tingginya (`nvim_win_get_height`).
- Mengatur lebar jendela saat ini (`nvim_win_set_width`).
- Membuat buffer baru (`nvim_create_buf`) dan mengisinya dengan beberapa baris.
- Membuka jendela floating baru (`nvim_open_win`) yang menampilkan buffer tersebut, dengan konfigurasi posisi, ukuran, dan border. Pemanggilan `nvim_open_win` dibungkus `pcall`.
- `vim.defer_fn` (dikomentari) adalah cara untuk menjadwalkan fungsi agar dijalankan nanti, berguna untuk tindakan sementara seperti menutup jendela pop-up.

**3. Manajemen Tab:** (Mirip dengan jendela, menggunakan `nvim_tabpage_...` functions)

**4. Opsi (Editor, Jendela, Buffer):**

- **Sintaks Umum:**
  - `vim.api.nvim_get_option(option_name_string)`: Mendapatkan nilai opsi global.
  - `vim.api.nvim_set_option(option_name_string, option_value)`: Mengatur nilai opsi global.
  - Ada juga `nvim_win_get_option`, `nvim_win_set_option`, `nvim_buf_get_option`, `nvim_buf_set_option` untuk opsi spesifik jendela/buffer.
- `option_value`: Tipe data harus sesuai dengan tipe opsi (boolean, string, number).

**Contoh Kode (Options):**

```lua
-- file: vim_api_options_example.lua
print("\n--- vim.api - Mengatur Opsi ---")

-- Mendapatkan nilai opsi global 'tabstop'
-- vim.api.nvim_get_option(name_string)
local tabstop_val = vim.api.nvim_get_option("tabstop")
print("Nilai 'tabstop' saat ini:", tabstop_val)

-- Mengatur nilai opsi global 'expandtab' menjadi true
-- vim.api.nvim_set_option(name_string, value)
local new_expandtab_val = true
local success_opt, err_opt = pcall(vim.api.nvim_set_option, "expandtab", new_expandtab_val)
if success_opt then
    print("'expandtab' diatur ke:", vim.api.nvim_get_option("expandtab")) -- Verifikasi
else
    print("Error mengatur 'expandtab':", err_opt)
end

-- Mengatur opsi spesifik buffer (misalnya, 'readonly' untuk buffer saat ini)
local current_buf_handle_opt = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_option(current_buf_handle_opt, "readonly", true)
print("Opsi 'readonly' untuk buffer " .. current_buf_handle_opt .. " diatur ke:", vim.api.nvim_buf_get_option(current_buf_handle_opt, "readonly"))
-- Kembalikan ke false agar bisa diedit lagi
vim.api.nvim_buf_set_option(current_buf_handle_opt, "readonly", false)
print("Opsi 'readonly' dikembalikan ke:", vim.api.nvim_buf_get_option(current_buf_handle_opt, "readonly"))
```

**Penjelasan Kode Keseluruhan (Options):**

- Mengambil nilai opsi global `tabstop` (`nvim_get_option`).
- Mengatur opsi global `expandtab` menjadi `true` (`nvim_set_option`) dan memverifikasinya.
- Mengatur opsi `readonly` spesifik untuk buffer saat ini (`nvim_buf_set_option`) dan kemudian mengembalikannya.

**5. Menjalankan Perintah (Commands):**

- **Sintaks Umum:**
  - `vim.api.nvim_command(command_string)`: Mengeksekusi satu perintah Ex (seperti yang Anda ketik setelah `:`).
  - `vim.api.nvim_exec(multiline_command_string, output_bool)`: Mengeksekusi serangkaian perintah Ex (bisa multi-baris). Jika `output_bool` adalah `true`, output perintah akan ditangkap dan dikembalikan sebagai string.
  - `vim.api.nvim_exec_lua(lua_code_string, args_table)`: Mengeksekusi kode Lua sebagai string.

**Contoh Kode (Commands):**

```lua
-- file: vim_api_commands_example.lua
print("\n--- vim.api - Menjalankan Perintah ---")

-- Mengeksekusi perintah Ex sederhana
-- vim.api.nvim_command(command_string)
local success_cmd, err_cmd = pcall(vim.api.nvim_command, "vsplit") -- Membuka vertical split
if success_cmd then
    print("Perintah 'vsplit' berhasil dieksekusi.")
    vim.api.nvim_command("q") -- Menutup split baru (jika itu yang aktif)
else
    print("Error menjalankan perintah 'vsplit':", err_cmd)
end

-- Mengeksekusi beberapa perintah dan menangkap output (jika ada)
-- vim.api.nvim_exec(src_string, output_bool)
local script_to_exec = [[
    echo "Halo dari nvim_exec"
    let g:my_nvim_exec_var = "Ini variabel global"
]]
local output_exec, err_exec = pcall(vim.api.nvim_exec, script_to_exec, true) -- true untuk menangkap output
if output_exec and type(output_exec) == "string" then -- pcall true, output_exec adalah hasil
    print("Output dari nvim_exec:", output_exec) -- Mungkin kosong jika echo tidak ditangkap oleh output_bool ini
                                                -- 'echo' biasanya ke message area, 'nvim_exec' output lebih untuk
                                                -- perintah yang mengembalikan sesuatu seperti :redir atau :execute
    print("Variabel g:my_nvim_exec_var (diakses via vim.g):", vim.g.my_nvim_exec_var)
else
    print("Error nvim_exec atau tidak ada output:", err_exec or output_exec)
end
-- Untuk menangkap echo, lebih baik:
local output_echo = vim.api.nvim_exec('echo "Pesan Echo"', true)
print("Output nvim_exec dari echo:", output_echo) -- Seharusnya "Pesan Echo\n"
```

**Penjelasan Kode Keseluruhan (Commands):**

- `vim.api.nvim_command("vsplit")`: Mengeksekusi perintah Ex `vsplit` untuk membuat jendela terpisah secara vertikal.
- `vim.api.nvim_exec(...)`: Mengeksekusi blok skrip Vimscript. `output_bool = true` mencoba menangkap output, meskipun untuk `echo` perilakunya mungkin tidak selalu intuitif; `nvim_exec` lebih untuk menangkap output dari perintah seperti `:redir`. Variabel global yang diset oleh skrip Vimscript (`g:my_nvim_exec_var`) dapat diakses dari Lua melalui `vim.g`.

**6. Keymaps:**

- **Sintaks Umum:**
  - `vim.api.nvim_set_keymap(mode_string, lhs_string, rhs_string, opts_table)`: Mengatur pemetaan kunci.
    - `mode_string`: Mode Vim (misalnya, `"n"` untuk Normal, `"i"` untuk Insert, `"v"` untuk Visual).
    - `lhs_string`: Bagian kiri pemetaan (tombol yang akan ditekan, misalnya `"<leader>p"`).
    - `rhs_string`: Bagian kanan pemetaan (aksi yang akan dilakukan, misalnya `":echo 'Halo'<CR>"` atau `"<Cmd>lua MyPlugin.action()<CR>"`).
    - `opts_table`: Tabel opsi (misalnya `{noremap = true, silent = true, desc = "Deskripsi keymap"}`).
  - `vim.api.nvim_del_keymap(mode_string, lhs_string)`: Menghapus pemetaan kunci.

**Contoh Kode (Keymaps):**

```lua
-- file: vim_api_keymap_example.lua
print("\n--- vim.api - Mengatur Keymap ---")

-- Fungsi Lua yang akan dipanggil oleh keymap
_G.my_plugin_action_from_keymap = function() -- Simpan di global agar rhs bisa menemukannya sederhana
    print("Aksi plugin dari keymap Lua dipanggil!")
    vim.api.nvim_notify("Keymap Lua berhasil!", vim.log.levels.INFO, {})
end

-- Mengatur keymap mode Normal: <leader>p akan memanggil fungsi Lua
-- vim.api.nvim_set_keymap(mode, lhs, rhs, opts_table)
local mode = "n"
local lhs = "<leader>lk" -- Misal leader adalah spasi, maka " spasi lk"
local rhs = '<Cmd>lua _G.my_plugin_action_from_keymap()<CR>' -- <Cmd> lebih aman dari :lua
local opts = {
    noremap = true,  -- Sangat direkomendasikan
    silent = true,   -- Tidak meng-echo perintah di command line
    desc = "Panggil aksi plugin Lua contoh" -- Deskripsi untuk :map atau plugin keymap
}

local success_keymap, err_keymap = pcall(vim.api.nvim_set_keymap, mode, lhs, rhs, opts)
if success_keymap then
    print(string.format("Keymap '%s' untuk mode '%s' berhasil diatur ke '%s'", lhs, mode, rhs))
    print("Coba tekan <leader>lk di mode Normal.")
else
    print("Error mengatur keymap:", err_keymap)
end

-- Untuk menghapus keymap (jika diperlukan):
-- vim.api.nvim_del_keymap(mode, lhs)
-- Contoh: pcall(vim.api.nvim_del_keymap, "n", "<leader>lk")
```

**Penjelasan Kode Keseluruhan (Keymaps):**

- `_G.my_plugin_action_from_keymap`: Fungsi Lua global sederhana yang akan dijalankan oleh keymap. (Menyimpannya di global adalah cara mudah untuk demo; dalam plugin nyata, Anda mungkin menggunakan `require('myplugin').action()`).
- `vim.api.nvim_set_keymap(...)`: Mengatur keymap.
  - `"n"`: Mode Normal.
  - `"<leader>lk"`: Kombinasi tombol.
  - `'<Cmd>lua _G.my_plugin_action_from_keymap()<CR>'`: Perintah yang dijalankan. `<Cmd>` adalah cara yang lebih aman dan modern untuk menjalankan perintah Ex dari mapping daripada menggunakan `:`. `_G` digunakan di sini untuk mengakses fungsi global yang kita definisikan. `<CR>` mensimulasikan penekanan Enter.
  - `opts`: Tabel opsi penting seperti `noremap` (mencegah pemetaan rekursif) dan `silent` (mencegah perintah di-echo). `desc` berguna untuk dokumentasi keymap.

---

### 13.3 Perbedaan dan Kapan Menggunakan Masing-masing

- **`vim.fn` (Fungsi Vim):**
  - **Kelebihan:**
    - Akses ke hampir semua fungsi VimL bawaan dan kustom.
    - Familiar bagi pengguna yang sudah lama menggunakan Vimscript.
    - Bisa lebih singkat untuk beberapa operasi sederhana.
  - **Kekurangan:**
    - Konversi tipe data antara Lua dan Vimscript bisa memiliki keanehan atau overhead.
    - Kurang terstruktur dibandingkan `vim.api`.
    - Beberapa fungsi `vim.fn` mungkin memiliki efek samping (side effects) yang sulit dikelola secara programatik atau mengembalikan nilai yang tidak konsisten (misalnya, string yang perlu di-parse, atau 0/1 untuk boolean).
    - Umumnya dianggap lebih lambat untuk operasi yang kompleks dibandingkan `vim.api` yang setara.
- **`vim.api` (API Lua Neovim):**
  - **Kelebihan:**
    - Antarmuka yang dirancang secara eksplisit untuk penggunaan programatik (awalnya untuk klien RPC, yang juga menguntungkan Lua).
    - Lebih terstruktur, jelas, dan konsisten dalam hal argumen dan nilai kembali.
    - Menggunakan tipe data Lua secara lebih alami (misalnya, boolean Lua adalah boolean, bukan 0/1).
    - Umumnya lebih cepat dan lebih robust.
    - Dirancang untuk stabilitas API jangka panjang.
    - Penanganan error lebih sering melalui error Lua yang bisa ditangkap `pcall`, bukan hanya nilai kembali yang ambigu.
  - **Kekurangan:**
    - Mungkin belum mencakup 100% dari semua fungsi VimL yang sangat spesifik atau jarang digunakan (meskipun cakupannya sangat luas).
    - Mungkin terasa sedikit lebih "bertele-tele" (verbose) untuk beberapa operasi yang sangat sederhana dibandingkan alias `vim.fn` yang sudah dikenal.
- **Rekomendasi Umum:**
  - **Prioritaskan `vim.api`** untuk semua pengembangan plugin Neovim baru. Ini adalah cara modern, lebih aman, dan lebih berperforma untuk berinteraksi dengan editor.
  - Gunakan `vim.fn` jika:
    - Tidak ada fungsi `vim.api` yang setara untuk fungsionalitas VimL yang Anda butuhkan.
    - Anda memanggil fungsi VimL kustom yang sudah ada.
    - Untuk tugas yang sangat sederhana di mana kenyamanan dan keakraban dengan fungsi VimL lebih diutamakan dan tidak ada implikasi performa yang signifikan.

Pemahaman tentang kedua antarmuka ini dan kapan menggunakan masing-masing akan memungkinkan Anda menulis plugin Neovim yang kuat dan efisien.

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][4]**
> - **[Sebelumnya][3]**
> - **[Kurikulum][2]**

[4]: ../14-async-programming/README.md
[3]: ../12-lua-performance-best-practices/README.md
[2]: ../../../../../README.md
[1]: ../../README.md/#13-testing-dan-quality-assurance
