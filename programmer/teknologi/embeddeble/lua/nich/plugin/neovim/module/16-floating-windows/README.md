# **[16. UI Lanjutan - Floating Windows dan UI Kustom][1]**

Setelah memahami elemen UI dasar, kini saatnya menjelajahi cara membuat antarmuka yang lebih kompleks dan terintegrasi di Neovim. Floating windows adalah komponen kunci untuk UI modern, sementara API extmarks dan highlighting memungkinkan kustomisasi tampilan yang sangat detail. Ini adalah area di mana Anda dapat benar-benar membuat plugin Anda menonjol dengan antarmuka pengguna yang kaya dan interaktif.

---

### 16.1 Floating Windows

- **Deskripsi Konsep:**
  - **Floating Windows (Jendela Mengambang):** Adalah jendela khusus di Neovim yang "mengambang" di atas grid editor utama, tidak terikat pada tata letak jendela standar (splits). Mereka sangat fleksibel dan dapat dikonfigurasi dalam hal ukuran, posisi, tampilan (border, style), dan perilaku (apakah bisa difokus, interaksi mouse).
  - **Kegunaan Umum:** Floating windows adalah fondasi untuk banyak elemen UI modern di Neovim, seperti:
    - Menu auto-completion (misalnya, oleh `nvim-cmp`).
    - Jendela diagnostik (error/warning dari LSP).
    - Jendela preview (misalnya, untuk Telescope).
    - Pop-up informasi, bantuan, atau input kustom.
    - Palet perintah.
- **Terminologi:**
  - **Floating Window:** Jendela yang tidak terikat pada tata letak standar dan dapat diposisikan secara absolut atau relatif.
  - **Anchor (Jangkar):** Titik pada floating window (misalnya, sudut Barat Laut/NW) yang digunakan sebagai referensi untuk penentuan posisinya.
  - **Z-index:** Urutan tumpukan untuk floating windows; nilai yang lebih tinggi akan tampil di atas jendela dengan z-index lebih rendah.
- **Implementasi dalam Neovim:** Menguasai floating windows memungkinkan Anda membuat antarmuka yang kaya dan tidak mengganggu alur kerja utama pengguna. Mereka adalah alat esensial untuk menampilkan informasi kontekstual atau menyediakan interaksi sekunder.
- **Sumber Dokumentasi Neovim:**
  - `:h api-float` (Gambaran umum dan konsep floating window).
  - `:h nvim_open_win()` (Fungsi utama untuk membuat floating window).
  - `:h nvim_win_set_config()` (Untuk memodifikasi konfigurasi jendela yang sudah ada).
  - `:h nvim_win_get_config()` (Untuk mendapatkan konfigurasi jendela saat ini).
  - `:h nvim_win_close()` (Untuk menutup jendela).

#### Membuat dan Mengkonfigurasi Floating Windows

Fungsi utama untuk membuat floating window adalah `vim.api.nvim_open_win()`.

- **Sintaks Per Baris (Kunci untuk `vim.api.nvim_open_win`):**

  ```lua
  -- vim.api.nvim_open_win(buffer_handle, enter_bool, config_table)
  local buffer_untuk_float = vim.api.nvim_create_buf(false, true) -- false: not listed, true: scratch
  local harus_fokus_setelah_buka = true -- Apakah jendela baru akan langsung difokus
  local konfigurasi_jendela_float = {
      relative = 'editor', -- Posisi relatif terhadap 'editor', 'win', 'cursor', atau 'mouse'
      -- anchor   = 'NW',    -- Jangkar floating window (NW, NE, SW, SE) - default NW
      width    = 40,      -- Lebar dalam kolom
      height   = 10,      -- Tinggi dalam baris
      -- bufpos   = {10, 5}, -- Jika relative='win', posisi [baris, kolom] (0-idx) di grid buffer jendela induk
      row      = 5,       -- Posisi baris di layar (jika relative='editor')
      col      = 10,      -- Posisi kolom di layar (jika relative='editor')
      focusable= true,     -- Apakah jendela bisa menerima fokus (default true)
      external = false,    -- Jika true, UI eksternal akan menggambar jendela (default false)
      style    = 'minimal',-- 'minimal' menghilangkan nomor baris, dll. (default)
      border   = 'single', -- Tipe border: "none", "single", "double", "rounded", "shadow",
                           -- atau tabel kustom: {'╔', '═', ...} (8 karakter)
      zindex   = 100,     -- Urutan tumpukan (default 50), nilai lebih tinggi di atas
      -- noautocmd = false -- Jika true, jangan picu event autocommand saat membuka
  }

  local id_jendela_float, err = pcall(vim.api.nvim_open_win,
                                      buffer_untuk_float,
                                      harus_fokus_setelah_buka,
                                      konfigurasi_jendela_float)
  if id_jendela_float and type(id_jendela_float) == "number" then
      -- Berhasil, id_jendela_float adalah handle jendela baru
  else
      -- Gagal, err berisi pesan error
  end
  ```

  - `buffer_untuk_float` (integer): Handle buffer yang akan ditampilkan di floating window. Anda biasanya akan membuat buffer baru (seringkali buffer "scratch" yang tidak terdaftar) untuk konten floating window.
  - `harus_fokus_setelah_buka` (boolean): Jika `true`, fokus akan pindah ke floating window yang baru dibuat.
  - `konfigurasi_jendela_float` (table): Ini adalah tabel kunci yang mendefinisikan semua aspek floating window. Beberapa field penting:
    - `relative` (string): Menentukan titik acuan untuk posisi.
      - `'editor'`: Posisi ( `row`, `col`) relatif terhadap grid editor keseluruhan.
      - `'win'`: Posisi ( `bufpos` = `{baris, kolom}`) relatif terhadap jendela tertentu (ditentukan oleh `win` di `config_table`, atau jendela saat ini jika tidak ada). `baris` dan `kolom` di `bufpos` adalah 0-indeks.
      - `'cursor'`: Posisi relatif terhadap posisi kursor.
      - `'mouse'`: Posisi relatif terhadap posisi mouse (jarang digunakan langsung).
    - `anchor` (string): Titik jangkar pada floating window itu sendiri yang akan diposisikan pada `row`/`col` atau `bufpos`. Pilihan: `'NW'` (North-West/Kiri-Atas, default), `'NE'`, `'SW'`, `'SE'`.
    - `width` (integer), `height` (integer): Dimensi floating window dalam kolom dan baris.
    - `row` (integer), `col` (integer): Baris dan kolom layar (0-indeks dari kiri atas editor) jika `relative = 'editor'`.
    - `focusable` (boolean): Jika `true` (default), pengguna dapat memindahkan fokus ke jendela ini. Jika `false`, jendela hanya untuk tampilan.
    - `zindex` (integer): Mengontrol urutan tumpukan. Jendela dengan `zindex` lebih tinggi akan muncul di atas jendela dengan `zindex` lebih rendah. Default adalah `50`. Jendela kursor biasanya memiliki `zindex` tinggi (misalnya, 250).
    - `border` (string | table): Mendefinisikan gaya border. Bisa string seperti `"none"`, `"single"`, `"double"`, `"rounded"`, `"shadow"`, atau tabel yang mendefinisikan setiap karakter border secara kustom (8 karakter: kiri-atas, atas, kanan-atas, kanan, kanan-bawah, bawah, kiri-bawah, kiri). Contoh: `border = {"┌", "─", "┐", "│", "┘", "─", "└", "│"}`.
    - `style` (string): `"minimal"` adalah gaya umum yang menghilangkan banyak elemen UI standar jendela (seperti nomor baris, sign column, dll.), cocok untuk pop-up.

- **Mengelola Konten:** Setelah floating window dibuat dan Anda memiliki handle buffer-nya, Anda dapat memanipulasi kontennya menggunakan fungsi API buffer seperti `vim.api.nvim_buf_set_lines()` atau `vim.api.nvim_buf_set_text()`.
- **Memodifikasi Konfigurasi Jendela yang Ada:** `vim.api.nvim_win_set_config(window_handle, config_table)` dapat digunakan untuk mengubah opsi jendela floating yang sudah ada.
- **Menutup Jendela:** `vim.api.nvim_win_close(window_handle, force_bool)` digunakan untuk menutup jendela. `force_bool = true` akan menutupnya bahkan jika ada perubahan yang belum disimpan (untuk buffer terkait).

**Contoh Kode (Membuat Floating Window Sederhana):**

```lua
-- file: floating_window_example.lua
-- Jalankan di Neovim: :luafile floating_window_example.lua

print("--- Contoh Floating Window ---")

-- 1. Fungsi untuk membuat dan menampilkan floating window dengan teks
local function show_simple_float(title_text, content_lines)
    -- Buat buffer baru untuk floating window (scratch buffer)
    -- vim.api.nvim_create_buf(is_listed_bool, is_scratch_bool)
    local buf_handle, err_buf = pcall(vim.api.nvim_create_buf, false, true)
    if not buf_handle or type(buf_handle) ~= "number" then
        print("Error membuat buffer untuk float:", err_buf or buf_handle)
        return
    end

    -- Isi buffer dengan konten
    -- vim.api.nvim_buf_set_lines(buffer_handle, start_idx, end_idx, strict_idx_bool, lines_table)
    vim.api.nvim_buf_set_lines(buf_handle, 0, -1, false, content_lines)

    -- Tentukan konfigurasi untuk floating window
    local editor_width = vim.api.nvim_get_option("columns")
    local editor_height = vim.api.nvim_get_option("lines")

    local float_width = math.floor(editor_width * 0.6)
    local float_height = math.min(#content_lines + 2, math.floor(editor_height * 0.5)) -- Tinggi konten + border

    local float_config = {
        relative = 'editor',
        anchor = 'NW', -- Jangkar di sudut kiri atas floating window
        width = float_width,
        height = float_height,
        row = math.floor((editor_height - float_height) / 2), -- Tengah vertikal
        col = math.floor((editor_width - float_width) / 2),  -- Tengah horizontal
        focusable = true,
        style = 'minimal',
        border = 'rounded', -- Atau "single", "double", dll.
        title = title_text, -- Opsi title (baru di Neovim versi lebih baru, cek :h nvim_open_win)
                           -- Jika title tidak didukung langsung, bisa ditambahkan sebagai baris pertama buffer
                           -- dan border diatur dengan 'title_pos'.
        zindex = 150
    }

    -- Buka floating window
    -- vim.api.nvim_open_win(buffer_handle, enter_bool, config_table)
    local win_handle, err_win = pcall(vim.api.nvim_open_win, buf_handle, true, float_config)

    if not win_handle or type(win_handle) ~= "number" then
        print("Error membuka floating window:", err_win or win_handle)
        -- Hapus buffer jika jendela gagal dibuat (opsional, tergantung logika)
        vim.api.nvim_buf_delete(buf_handle, {force = true})
        return
    end

    print("Floating window dibuat dengan handle:", win_handle, "dan buffer handle:", buf_handle)

    -- Menambahkan keymap untuk menutup floating window dengan 'q' atau '<Esc>' di jendela tersebut
    -- vim.api.nvim_buf_set_keymap(buffer_handle, mode, lhs, rhs, opts)
    vim.api.nvim_buf_set_keymap(buf_handle, "n", "q", "<Cmd>lua vim.api.nvim_win_close("..win_handle..", true)<CR>", {noremap=true, silent=true, nowait=true})
    vim.api.nvim_buf_set_keymap(buf_handle, "n", "<Esc>", "<Cmd>lua vim.api.nvim_win_close("..win_handle..", true)<CR>", {noremap=true, silent=true, nowait=true})

    return win_handle, buf_handle
end

-- Panggil fungsi untuk menampilkan float
local float_content = {
    "Ini adalah Floating Window Keren!",
    "---------------------------------",
    "Anda bisa menampilkan informasi apa pun di sini.",
    "Misalnya, bantuan konteks, hasil perintah, dll.",
    "",
    "Tekan 'q' atau '<Esc>' untuk menutup jendela ini."
}
local float_win, float_buf = show_simple_float("Info Penting", float_content)

-- Untuk memodifikasi setelah dibuat (contoh):
-- if float_win then
--   vim.defer_fn(function()
--     if vim.api.nvim_win_is_valid(float_win) then
--       print("Memodifikasi konfigurasi float...")
--       vim.api.nvim_win_set_config(float_win, {border = "double", width = 50})
--       vim.api.nvim_buf_set_lines(float_buf, -2, -1, false, {"Konten diupdate!"})
--     end
--   end, 2000) -- Setelah 2 detik
-- end
```

**Cara Menjalankan Kode:**
Jalankan file ini dari dalam Neovim. Sebuah floating window akan muncul di tengah editor. Tekan `q` atau `<Esc>` di dalam floating window tersebut untuk menutupnya.

**Penjelasan Kode Keseluruhan (`floating_window_example.lua`):**

- `show_simple_float(title_text, content_lines)`: Fungsi utama untuk membuat float.
  - `vim.api.nvim_create_buf(false, true)`: Membuat buffer "scratch" baru yang tidak terdaftar di daftar buffer standar dan akan dihapus saat tidak ada jendela yang menampilkannya.
  - `vim.api.nvim_buf_set_lines(...)`: Mengisi buffer dengan konten yang diberikan.
  - Perhitungan `float_width`, `float_height`, `row`, `col`: Menghitung dimensi dan posisi agar float muncul di tengah editor.
  - `float_config`: Tabel konfigurasi yang mendetailkan bagaimana floating window akan ditampilkan (relatif terhadap editor, border rounded, z-index tinggi, dll.). Opsi `title` ditambahkan (cek versi Neovim Anda untuk dukungannya, jika tidak, judul bisa jadi baris pertama buffer).
  - `vim.api.nvim_open_win(...)`: Fungsi API yang sebenarnya membuka jendela. Dibungkus `pcall` untuk penanganan error.
  - `vim.api.nvim_buf_set_keymap(...)`: Mengatur keymap lokal untuk buffer floating window. `q` dan `<Esc>` akan memanggil `vim.api.nvim_win_close()` untuk menutup jendela tersebut.
- Bagian yang dikomentari di akhir menunjukkan cara memodifikasi konfigurasi (`nvim_win_set_config`) dan konten (`nvim_buf_set_lines`) jendela floating yang sudah ada, menggunakan `vim.defer_fn` untuk menunda eksekusi.

---

### 16.2 Elemen UI Kustom dengan API

Selain floating windows, Neovim menyediakan API untuk "menggambar" atau menambahkan elemen visual langsung ke buffer, yang sangat berguna untuk anotasi, diagnostik, atau UI kustom yang lebih terintegrasi. Ini terutama dicapai melalui _extmarks_ dan _highlighting_.

- **Deskripsi Konsep:** Anda dapat melampirkan data dan properti visual ke posisi atau rentang tertentu dalam buffer tanpa mengubah teks buffer itu sendiri. Ini memungkinkan:
  - **Virtual Text:** Menampilkan teks tambahan di samping atau di akhir baris yang bukan bagian dari konten file (misalnya, pesan error inline, anotasi tipe).
  - **Highlighting Kustom:** Menerapkan grup highlight tertentu ke rentang teks atau baris.
  - **Signs:** Menampilkan ikon di signcolumn.
  - **Conceal:** Menyembunyikan bagian teks dan menggantinya dengan karakter lain.
- **Terminologi:**
  - **Extmark (Extended Mark):** Sebuah "penanda" di buffer yang dapat memiliki metadata dan properti visual terkait. Extmark memiliki ID dan dapat dikelola melalui namespace. Mereka "mengikuti" teks saat diedit.
  - **Namespace (`ns_id`):** ID integer yang digunakan untuk mengelompokkan extmark (atau highlight). Ini memungkinkan plugin untuk mengelola elemen UI-nya sendiri tanpa bertabrakan dengan plugin lain atau Neovim inti. Dibuat dengan `vim.api.nvim_create_namespace("NamaNamespaceUnik")`.
  - **Virtual Text:** Teks yang ditampilkan di layar tetapi tidak ada dalam konten file sebenarnya.
  - **Highlight Group:** Nama yang mendefinisikan sekumpulan atribut tampilan (warna foreground/background, bold, italic, dll.).
- **Implementasi dalam Neovim:** Sangat penting untuk plugin LSP (menampilkan diagnostik), plugin git (menampilkan status baris, blame), plugin debugger (menampilkan breakpoint), dan banyak lagi yang membutuhkan anotasi visual pada kode.
- **Sumber Dokumentasi Neovim:**
  - `:h extmark`
  - `:h nvim_buf_set_extmark()`
  - `:h nvim_buf_get_extmarks()`
  - `:h nvim_buf_del_extmark()`
  - `:h nvim_create_namespace()`
  - `:h nvim_set_hl()`
  - `:h nvim_get_hl_by_id()` / `:h nvim_get_hl_by_name()`

#### Menggambar Langsung ke Buffer (Konseptual)

Meskipun tidak "menggambar" dalam arti grafis, Anda selalu dapat memodifikasi teks buffer itu sendiri (misalnya, buffer scratch di floating window) untuk membuat UI. Namun, extmarks lebih canggih karena mereka non-invasif terhadap konten teks utama.

#### Menggunakan `nvim_buf_set_extmark()` untuk Elemen UI

- **Sintaks Per Baris (`nvim_buf_set_extmark`):**

  ```lua
  -- vim.api.nvim_buf_set_extmark(buffer_handle, namespace_id, line_idx, col_idx, opts_table)
  local buffer = 0 -- Buffer saat ini
  local ns_id = vim.api.nvim_create_namespace("MyPluginUI") -- Atau dapatkan ns_id yang sudah ada

  local line_target = 5   -- Baris ke-6 (0-indeks)
  local col_target = 0    -- Awal baris

  local extmark_opts = {
      -- id = existing_mark_id, -- Jika ingin update mark yang sudah ada
      -- end_line = end_line_idx, -- Untuk mark berjangkauan
      -- end_col = end_col_idx,   -- Untuk mark berjangkauan
      hl_group = "ErrorMsg", -- Nama grup highlight yang akan diterapkan pada rentang (jika end_line/col ada) atau baris
      virt_text = {{"👻 Pesan Virtual!", "Comment"}}, -- Tabel dari {teks_chunk, grup_highlight_chunk}
      virt_text_pos = 'eol', -- Posisi virtual text: 'eol', 'overlay', 'right_align'
      -- virt_text_hide = false, -- Jika true, sembunyikan teks buffer asli dan tampilkan virt_text
      -- conceal = 'X',          -- Karakter untuk menggantikan teks yang ditandai
      -- sign_text = ">>",       -- Teks untuk sign di signcolumn
      -- sign_hl_group = "Todo", -- Grup highlight untuk sign
      -- number_hl_group = "LineNr", -- Grup highlight untuk nomor baris
      -- line_hl_group = "CursorLine", -- Grup highlight untuk seluruh baris
      -- ... dan banyak opsi lainnya, lihat :h nvim_buf_set_extmark()
  }
  local mark_id, err = pcall(vim.api.nvim_buf_set_extmark, buffer, ns_id, line_target, col_target, extmark_opts)
  if mark_id and type(mark_id) == "number" then
      -- Berhasil, mark_id adalah ID dari extmark yang baru dibuat/diupdate
  else
      -- Gagal
  end
  ```

  - `buffer` (integer): Handle buffer target.
  - `ns_id` (integer): Namespace ID untuk extmark ini. Sangat disarankan untuk membuat namespace unik untuk plugin Anda (`vim.api.nvim_create_namespace("NamaPluginAnda")`) untuk mengelola extmark Anda sendiri dan membersihkannya (`vim.api.nvim_buf_clear_namespace`).
  - `line_target`, `col_target` (integer): Posisi awal (0-indeks) untuk extmark.
  - `extmark_opts` (table): Tabel opsi yang sangat kaya untuk mengontrol tampilan dan perilaku extmark:
    - `hl_group` (string): Menerapkan grup highlight ke rentang yang ditandai (jika `end_line`/`end_col` diset) atau ke seluruh baris jika `line_hl_group` digunakan.
    - `virt_text` (table): Tabel dari tabel-tabel kecil, di mana setiap sub-tabel adalah `{"text_chunk", "HighlightGroupForChunk"}`. Ini memungkinkan virtual text multi-warna/style.
    - `virt_text_pos` (string): `'eol'` (end of line - setelah teks baris), `'overlay'` (di atas teks pada `col_target`), `'right_align'` (rata kanan di jendela).
    - Banyak opsi lain untuk signs, conceal, dll. (lihat `:h nvim_buf_set_extmark()`).
  - **Nilai Kembali:** ID integer dari extmark yang dibuat/diupdate.

#### `nvim_set_hl()` untuk Highlight Kustom

- **Deskripsi Konsep:** Sebelum Anda dapat menggunakan nama highlight kustom di `hl_group` pada extmark (atau di tempat lain), Anda mungkin perlu mendefinisikannya terlebih dahulu jika itu bukan grup highlight standar Vim.
- **Sintaks Per Baris (`nvim_set_hl`):**
  ```lua
  -- vim.api.nvim_set_hl(namespace_id, name_string, val_table)
  local ns_highlight = 0 -- Namespace 0 untuk highlight global (dapat diakses oleh semua orang)
                         -- Atau ns_id plugin Anda jika ingin highlight terisolasi (jarang untuk definisi hl)
  local nama_grup_hl = "MyPluginErrorHighlight"
  local definisi_hl = {
      fg = "#FF0000",       -- Warna foreground (merah)
      bg = "#550000",       -- Warna background (merah tua)
      bold = true,
      italic = false,
      underline = false,
      undercurl = true,     -- Garis bergelombang di bawah (jika didukung terminal/GUI)
      -- reverse = true,
      -- strikethrough = true,
      -- link = "ErrorMsg" -- Alternatif: warisi semua dari grup highlight ErrorMsg
  }
  vim.api.nvim_set_hl(ns_highlight, nama_grup_hl, definisi_hl)
  ```
  - `ns_highlight` (integer): Namespace ID. Biasanya `0` digunakan untuk mendefinisikan grup highlight global yang dapat dirujuk berdasarkan namanya oleh plugin lain atau pengguna.
  - `nama_grup_hl` (string): Nama unik untuk grup highlight Anda (misalnya, `"MyPluginWarningText"`, `"MyPluginVirtHint"`).
  - `definisi_hl` (table): Tabel yang mendefinisikan atribut visual:
    - `fg` atau `foreground`: Warna teks (nama warna seperti `"Red"`, `"blue"`, atau kode hex `"#RRGGBB"`).
    - `bg` atau `background`: Warna latar belakang.
    - `bold`, `italic`, `underline`, `undercurl`, `strikethrough` (boolean).
    - `reverse` (boolean): Tukar warna foreground dan background.
    - `link` (string): Jika diset, grup ini akan mewarisi semua atribut dari grup highlight lain yang disebutkan (misalnya, `link = "Comment"` akan membuat grup Anda terlihat seperti `Comment`). `fg`, `bg`, dll., kemudian dapat digunakan untuk menimpa atribut tertentu dari grup yang di-link.
    - Atribut lain seperti `ctermfg`, `ctermbg`, `cterm` (untuk terminal 256 warna) juga bisa diset.

**Contoh Kode (Extmarks dan Highlight Kustom):**

```lua
-- file: custom_ui_example.lua
-- Jalankan di Neovim: :luafile custom_ui_example.lua

print("--- Contoh Elemen UI Kustom ---")

-- 1. Buat namespace untuk plugin kita (jika belum ada)
local ns_id_myplugin
local existing_ns = vim.api.nvim_get_namespaces() -- nvim_get_namespaces mengembalikan map
for id, name in pairs(existing_ns) do
    if name == "MyAwesomePluginUI" then
        ns_id_myplugin = id
        break
    end
end
if not ns_id_myplugin then
    ns_id_myplugin = vim.api.nvim_create_namespace("MyAwesomePluginUI")
end
print("Namespace ID untuk 'MyAwesomePluginUI':", ns_id_myplugin)

-- 2. Definisikan beberapa grup highlight kustom
-- vim.api.nvim_set_hl(ns_id_untuk_hl, nama_grup, definisi_hl_tabel)
-- Namespace 0 agar bisa digunakan secara global berdasarkan nama.
vim.api.nvim_set_hl(0, "MyPluginHintText", { fg = "LightBlue", italic = true })
vim.api.nvim_set_hl(0, "MyPluginWarningLine", { bg = "LightYellow" }) -- Untuk highlight seluruh baris
vim.api.nvim_set_hl(0, "MyPluginErrorUnderline", { undercurl = true, sp = "Red" }) -- sp = special color for undercurl

print("Grup highlight kustom 'MyPluginHintText', 'MyPluginWarningLine', 'MyPluginErrorUnderline' telah didefinisikan.")

-- 3. Tambahkan beberapa extmarks ke buffer saat ini
local current_buf = vim.api.nvim_get_current_buf()

-- Tambahkan virtual text di akhir baris pertama (indeks 0)
-- Pastikan buffer Anda memiliki setidaknya satu baris.
if vim.api.nvim_buf_is_loaded(current_buf) and vim.api.nvim_buf_line_count(current_buf) > 0 then
    local virt_text_opts = {
        virt_text = { -- Tabel dari chunk: {text, highlight_group}
            {" ✨ Ini adalah petunjuk virtual! ", "MyPluginHintText"},
            {"(penting)", "Question"} -- Menggunakan grup highlight bawaan
        },
        virt_text_pos = 'eol', -- 'eol', 'overlay', 'right_align'
    }
    local mark_id1 = vim.api.nvim_buf_set_extmark(current_buf, ns_id_myplugin, 0, -1, virt_text_opts)
                                                            -- baris 0, kolom -1 (akhir baris untuk virt_text_pos='eol')
    if mark_id1 then print("Extmark virtual text dibuat dengan ID:", mark_id1, "di baris 1.") end

    -- Highlight seluruh baris ke-3 (indeks 2) sebagai peringatan
    -- Pastikan buffer memiliki setidaknya 3 baris.
    if vim.api.nvim_buf_line_count(current_buf) >= 3 then
        local line_hl_opts = {
            line_hl_group = "MyPluginWarningLine", -- Highlight seluruh baris
            -- end_line = 2, -- Bisa juga untuk rentang, tapi line_hl_group sudah cukup
        }
        local mark_id2 = vim.api.nvim_buf_set_extmark(current_buf, ns_id_myplugin, 2, 0, line_hl_opts)
        if mark_id2 then print("Extmark highlight baris dibuat dengan ID:", mark_id2, "di baris 3.") end
    end

    -- Tambahkan highlight undercurl untuk kata tertentu di baris ke-5 (indeks 4)
    -- Misalkan baris ke-5 berisi "Ini ada kata ERROR yang perlu diperbaiki."
    -- Anda perlu mencari posisi kata "ERROR".
    -- Untuk demo, kita asumsikan kata "ERROR" dimulai di kolom 12 dan panjangnya 5.
    -- Pastikan buffer memiliki setidaknya 5 baris dan konten yang sesuai.
    if vim.api.nvim_buf_line_count(current_buf) >= 5 then
        -- (Contoh ini mengasumsikan Anda tahu posisi kata "ERROR")
        -- Dalam plugin nyata, Anda akan menggunakan pencarian string atau hasil LSP/linter.
        local error_line = 4 -- Indeks baris (baris ke-5)
        local error_start_col = 12 -- Kolom mulai kata "ERROR" (0-indeks)
        local error_end_col = error_start_col + 5 -- Kolom akhir kata "ERROR"
        local error_hl_opts = {
            end_line = error_line, -- Hanya satu baris
            end_col = error_end_col,
            hl_group = "MyPluginErrorUnderline",
            -- Anda juga bisa menambahkan virt_text di sini jika mau
        }
        local mark_id3 = vim.api.nvim_buf_set_extmark(current_buf, ns_id_myplugin, error_line, error_start_col, error_hl_opts)
        if mark_id3 then print("Extmark error underline dibuat dengan ID:", mark_id3, "di baris 5.") end
        print("Silakan edit buffer Anda agar memiliki teks 'Ini ada kata ERROR yang perlu diperbaiki.' di baris 5 untuk melihat efeknya.")
    end
else
    print("Buffer saat ini tidak valid atau kosong. Tidak ada extmark yang ditambahkan.")
end

-- Untuk membersihkan namespace (menghapus semua extmark dari plugin ini di buffer tsb):
-- vim.api.nvim_buf_clear_namespace(current_buf, ns_id_myplugin, 0, -1)
-- print("Semua extmark dari namespace MyAwesomePluginUI di buffer saat ini telah dibersihkan (contoh).")
```

**Cara Menjalankan Kode:**

1.  Buka Neovim.
2.  Idealnya, buka buffer dengan beberapa baris teks. Misalnya, buat file baru dan tulis 5-6 baris.
3.  Simpan kode Lua di atas, misalnya sebagai `custom_ui_example.lua`.
4.  Jalankan dengan `:luafile custom_ui_example.lua`.
5.  Amati perubahan di buffer Anda: virtual text akan muncul di akhir baris pertama, baris ketiga akan di-highlight, dan jika Anda memiliki teks yang sesuai di baris kelima, kata "ERROR" akan digarisbawahi bergelombang.

**Penjelasan Kode Keseluruhan (`custom_ui_example.lua`):**

- **Namespace:** Sebuah namespace `MyAwesomePluginUI` dibuat atau diambil jika sudah ada. Ini penting untuk mengelola extmark yang dibuat oleh plugin ini.
- **Highlight Kustom:** Tiga grup highlight kustom (`MyPluginHintText`, `MyPluginWarningLine`, `MyPluginErrorUnderline`) didefinisikan menggunakan `vim.api.nvim_set_hl()`. Ini memungkinkan tampilan visual yang unik.
- **Virtual Text:** `nvim_buf_set_extmark` digunakan untuk menambahkan virtual text di akhir baris pertama. `virt_text` adalah tabel yang berisi chunk teks dan grup highlightnya.
- **Line Highlight:** Extmark lain digunakan untuk meng-highlight seluruh baris ketiga dengan grup `MyPluginWarningLine` melalui opsi `line_hl_group`.
- **Ranged Highlight (Undercurl):** Extmark ketiga digunakan untuk menerapkan `MyPluginErrorUnderline` ke rentang tertentu (disimulasikan untuk kata "ERROR") di baris kelima. Ini menggunakan `end_line` dan `end_col`.
- Bagian yang dikomentari di akhir menunjukkan cara membersihkan semua extmark yang dibuat oleh namespace plugin ini dari buffer.

---

### 16.3 Interaksi dengan Mouse (Dasar)

- **Deskripsi Konsep:** Neovim dapat menangkap input mouse jika dikonfigurasi (`:set mouse=a` atau mode spesifik lainnya). Secara teoritis, plugin dapat merespons klik mouse atau event mouse lainnya untuk memicu aksi, misalnya, pada elemen UI kustom atau floating window.
- **Implementasi di Neovim:**
  - **Event Autocommand:** Event mouse seperti `<LeftMouse>`, `<RightMouse>`, `<ScrollWheelUp>`, dll., dapat ditangkap oleh autocommands. Callback Lua kemudian dapat menentukan tindakan berdasarkan posisi mouse (`vim.fn.getmousepos()`) dan konteks (jendela, buffer, dll.).
  - **UI Kustom yang Kompleks:** Untuk UI yang sangat interaktif dengan mouse (misalnya, mengklik tombol di floating window), implementasinya bisa menjadi cukup rumit. Ini mungkin melibatkan:
    - Mendapatkan posisi klik.
    - Menentukan elemen UI apa (jika ada) yang ada di posisi tersebut (misalnya, dengan memeriksa posisi dan ukuran floating window atau area yang digambar secara kustom).
    - Memicu tindakan yang sesuai.
  - **Pustaka UI:** Pustaka UI pihak ketiga untuk Neovim mungkin menyediakan abstraksi tingkat lebih tinggi untuk menangani input mouse pada komponen mereka.
  - **Fokus Jendela:** Jika floating window bersifat `focusable`, Neovim akan menangani beberapa interaksi mouse dasar (seperti memfokuskan jendela saat diklik) secara otomatis.
- **Contoh Kode dari Dokumen (Analisis):**
  Contoh yang diberikan dalam dokumen untuk bagian "16.3 Interaksi dengan Mouse (Dasar)" sebenarnya adalah contoh lain dari pembuatan floating window (disebut "Popup Info"), bukan demonstrasi langsung penanganan event mouse. Oleh karena itu, kita akan menganalisisnya sebagai contoh floating window tambahan dan membahas konsep mouse secara terpisah.

**Contoh Kode (Floating Window "Popup Info" dari dokumen):**

```lua
-- file: popup_info_example.lua (sebenarnya contoh float, bukan mouse-event)
-- Jalankan di Neovim: :luafile popup_info_example.lua

print("--- Contoh Popup Info (Floating Window) ---")

-- Fungsi untuk menampilkan popup informasi di dekat kursor
local function show_popup_info_near_cursor(info_lines)
    -- Buat buffer scratch untuk popup
    local buf_handle = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf_handle, 0, -1, false, info_lines)

    -- Dapatkan posisi kursor saat ini untuk menempatkan popup
    -- vim.api.nvim_win_get_cursor(window_handle) mengembalikan {baris, kolom} (1-idx untuk baris, 0-idx untuk kolom)
    local cursor_pos = vim.api.nvim_win_get_cursor(0) -- 0 untuk jendela saat ini
    local cursor_screen_pos = vim.fn.screenpos(0, cursor_pos[1], cursor_pos[2]+1) -- Dapatkan posisi layar kursor
                                                                            -- screenpos butuh col 1-idx

    local popup_width = 0
    for _, line in ipairs(info_lines) do
        popup_width = math.max(popup_width, vim.fn.strdisplaywidth(line))
    end
    popup_width = math.min(popup_width + 2, 60) -- Lebar konten + padding, maks 60
    local popup_height = #info_lines + 2 -- Tinggi konten + padding border

    local popup_config = {
        relative = 'editor', -- Bisa juga 'win' jika ingin relatif thd jendela tertentu
        -- anchor = 'NW', -- Default
        width = popup_width,
        height = popup_height,
        -- Tempatkan sedikit di bawah dan di kanan kursor (jika memungkinkan)
        -- Posisi layar adalah 1-indeks, API row/col adalah 0-indeks
        row = cursor_screen_pos.row,  -- row (0-idx) = screen_row (1-idx) - 1. Di sini kita pakai screen_row langsung.
                                       -- API docs: 'row' is the global screen line
        col = cursor_screen_pos.col,  -- col (0-idx) = screen_col (1-idx) - 1
        focusable = false,       -- Biasanya popup info tidak perlu fokus
        style = 'minimal',
        border = 'single',
        zindex = 200             -- Di atas sebagian besar elemen lain
    }

    local win_id, err = pcall(vim.api.nvim_open_win, buf_handle, false, popup_config)

    if win_id and type(win_id) == "number" then
        print("Popup info ditampilkan, handle:", win_id)
        -- Tambahkan autocmd untuk menutup popup ini saat kursor bergerak atau mode berubah
        local group_popup = "PopupInfoAutocmds"
        vim.api.nvim_create_augroup(group_popup, { clear = true })
        vim.api.nvim_create_autocmd({"CursorMoved", "ModeChanged", "BufLeave"}, {
            group = group_popup,
            buffer = vim.api.nvim_get_current_buf(), -- Hanya aktif jika kursor bergerak di buffer ini
            once = true, -- Hanya jalankan sekali lalu hapus diri sendiri
            callback = function()
                if vim.api.nvim_win_is_valid(win_id) then
                    vim.api.nvim_win_close(win_id, true) -- Tutup popup
                    print("Popup info ditutup oleh autocommand.")
                end
                -- Bersihkan augroup juga setelah selesai
                vim.api.nvim_del_augroup_by_name(group_popup)
            end,
            desc = "Tutup popup info otomatis"
        })
    else
        print("Gagal menampilkan popup info:", err or win_id)
        vim.api.nvim_buf_delete(buf_handle, {force = true}) -- Bersihkan buffer jika gagal
    end
end

-- Panggil fungsi untuk menampilkan popup
local info_text = {
    "Informasi Kontekstual:",
    "  - Ini adalah detail tentang sesuatu.",
    "  - Muncul di dekat kursor Anda."
}
show_popup_info_near_cursor(info_text)
print("Coba gerakkan kursor atau ubah mode untuk menutup popup info.")
```

**Cara Menjalankan Kode:**
Jalankan dari Neovim. Sebuah floating window kecil akan muncul di dekat kursor Anda. Jika Anda menggerakkan kursor atau mengubah mode, popup tersebut akan otomatis tertutup.

**Penjelasan Kode Keseluruhan (`popup_info_example.lua`):**

- Fungsi `show_popup_info_near_cursor` membuat floating window.
- `vim.api.nvim_win_get_cursor(0)` mendapatkan posisi baris (1-indeks) dan kolom (0-indeks) kursor di jendela saat ini.
- `vim.fn.screenpos(0, baris, kolom_plus_1)` digunakan untuk mengkonversi posisi buffer ke posisi layar (1-indeks untuk baris dan kolom), yang kemudian digunakan untuk `row` dan `col` di `popup_config`.
- `popup_width` dihitung berdasarkan lebar konten terpanjang.
- Konfigurasi `popup_config` diatur agar jendela muncul di dekat kursor, tidak bisa difokus, dan memiliki z-index tinggi.
- **Penting:** Sebuah `autocmd` (`CursorMoved`, `ModeChanged`, `BufLeave`) dibuat dalam augroup `PopupInfoAutocmds`. Autocmd ini bersifat `once = true` dan memiliki callback yang akan menutup floating window jika valid, lalu menghapus augroup itu sendiri. Ini adalah pola umum untuk popup informasi sementara yang harus hilang saat konteksnya berubah.

**Mengenai Interaksi Mouse Sebenarnya:**
Dokumen Anda menyebutkan "Interaksi dengan Mouse (Dasar)" tetapi contohnya adalah floating window. Untuk benar-benar menangani klik mouse di dalam floating window Anda (misalnya, untuk membuat tombol yang bisa diklik):

1.  Anda perlu membuat floating window `focusable = true`.
2.  Anda perlu mengatur pemetaan mouse (misalnya, `<LeftMouse>`) yang bersifat buffer-lokal untuk buffer floating window tersebut.
    ```lua
    -- Di dalam fungsi pembuatan float, setelah win_id didapatkan:
    -- vim.api.nvim_buf_set_keymap(buf_handle, "n", "<LeftMouse>", "<Cmd>lua MyPlugin.handle_float_click("..win_id..","..buf_handle..")<CR>", {noremap=true, silent=true})
    ```
3.  Fungsi Lua `MyPlugin.handle_float_click` kemudian perlu:
    _ Mendapatkan posisi mouse saat klik (misalnya, menggunakan variabel yang diset oleh Vim seperti `v:mouse_winid`, `v:mouse_lnum`, `v:mouse_col` yang dapat diakses via `vim.fn` atau `vim.v`).
    _ Menentukan apakah klik tersebut mengenai "tombol" atau area interaktif di dalam konten buffer floating window Anda. \* Melakukan aksi yang sesuai.
    Ini adalah topik yang lebih lanjut dan bisa cukup kompleks.

---

Menggunakan floating windows, extmarks, dan highlight kustom memungkinkan Anda menciptakan antarmuka yang sangat kaya dan informatif untuk plugin Neovim. Meskipun interaksi mouse langsung bisa rumit, fungsionalitas dasar untuk menampilkan UI yang canggih sudah sangat kuat.

Kita telah menyelesaikan Bagian 16. Kita akan melanjutkan dengan integrasi dengan fitur-fitur Neovim yang lebih spesifik.

> - **[Ke Atas](#)**
> - **[Selanjutnya][4]**
> - **[Sebelumnya][3]**
> - **[Kurikulum][2]**
> - **[Domain Spesifik][5]**

[5]: ../../../../../../../README.md
[4]: ../17-lsp/README.md
[3]: ../15-ui/README.md
[2]: ../../../../../README.md
[1]: ../../README.md
