# **[14. Event Handling di Neovim (Penanganan Event)][1]**

Neovim adalah aplikasi yang sangat digerakkan oleh event (event-driven). Banyak tindakan pengguna atau perubahan state internal memicu "event". Plugin dapat "mendengarkan" event-event ini dan menjalankan kode tertentu sebagai respons, memungkinkan integrasi yang mendalam dengan alur kerja editor. Mekanisme utama untuk ini adalah _autocommands_. Memahami bagaimana menangani event adalah fundamental untuk membuat plugin yang dinamis dan responsif terhadap apa yang terjadi di dalam editor.

---

### 14.1 Konsep Event dan Autocommands

- **Deskripsi Konsep:**
  - **Event-Driven Programming (Pemrograman Berbasis Event):** Ini adalah paradigma pemrograman di mana alur program ditentukan oleh terjadinya event. Daripada program berjalan lurus dari awal hingga akhir, ia bereaksi terhadap pemicu eksternal atau internal.
  - **Events di Neovim:** Neovim memancarkan (emits) berbagai macam event selama operasinya. Contoh event meliputi:
    - `BufEnter`: Ketika sebuah buffer dimasuki (menjadi buffer aktif di sebuah jendela).
    - `BufWritePost`: Setelah sebuah buffer berhasil ditulis ke file.
    - `InsertEnter`: Ketika beralih ke mode Insert.
    - `FileType`: Ketika tipe file sebuah buffer terdeteksi atau diatur.
    - `VimEnter`: Setelah Neovim selesai startup.
    - `TextChanged`, `TextChangedI`: Ketika teks berubah di mode Normal atau Insert.
      Dan masih banyak lagi.
  - **Autocommands (Perintah Otomatis, `au`):** Mekanisme di Neovim yang memungkinkan Anda untuk secara otomatis menjalankan perintah Vimscript atau memanggil fungsi Lua ketika event tertentu terjadi, seringkali dengan kondisi tambahan seperti pola nama file atau tipe file. Autocommands adalah cara utama plugin "mengaitkan diri" ke siklus hidup dan aktivitas editor.
- **Terminologi:**
  - **Event:** Kejadian atau sinyal yang dipancarkan oleh Neovim yang menandakan bahwa sesuatu telah terjadi (misalnya, file dibuka, mode diubah).
  - **Autocommand (au):** Sebuah perintah atau fungsi yang dijadwalkan untuk dieksekusi secara otomatis sebagai respons terhadap satu atau lebih event.
  - **Autocommand Group (augroup):** Sebuah wadah untuk mengelompokkan autocommand terkait. Sangat penting untuk manajemen autocommand, terutama untuk mencegah duplikasi saat skrip/plugin dimuat ulang.
  - **Callback Function (Fungsi Panggil Balik):** Fungsi Lua yang disediakan ke autocommand yang akan dipanggil oleh Neovim ketika event yang sesuai terpicu.
  - **Event Pattern (Pola Event):** Filter tambahan untuk autocommand (misalnya, `*.lua`, `*.py`) yang menentukan bahwa autocommand hanya akan aktif untuk file yang cocok dengan pola tersebut.
- **Implementasi dalam Neovim:** Autocommands adalah tulang punggung dari banyak fungsionalitas plugin:
  - Menjalankan linter setelah file disimpan (`BufWritePost`).
  - Memuat konfigurasi spesifik proyek saat memasuki direktori tertentu (`DirChanged`).
  - Mengatur opsi buffer berdasarkan tipe file (`FileType`).
  - Membersihkan state plugin saat Neovim keluar (`VimLeavePre`).
- **Sumber Dokumentasi Neovim:**
  - `:h autocmd` (Konsep umum autocommand di Vim/Neovim).
  - `:h autocommand-events` (Daftar lengkap semua event yang tersedia).
  - `:h {event}` (misalnya, `:h BufEnter` untuk detail tentang event spesifik).

---

### 14.2 Membuat Autocommands dengan Lua

Neovim menyediakan API Lua (`vim.api`) untuk membuat dan mengelola autocommands dan augroups secara terprogram.

#### Autocommand Groups (`augroup`)

Sangat disarankan untuk mendefinisikan semua autocommand plugin Anda di dalam sebuah _augroup_ yang dinamai secara unik. Ini memudahkan pengelolaan, terutama pembersihan.

- **`vim.api.nvim_create_augroup(name, opts)`**
  - **Deskripsi:** Membuat (atau membersihkan) sebuah augroup.
  - **Sintaks Per Baris:**
    ```lua
    local group_id_or_name = "NamaGrupPluginSaya" -- Nama unik untuk grup
    local opts_table = {
        clear = true -- Sangat penting!
    }
    -- vim.api.nvim_create_augroup(name_string, options_table)
    local augroup_id = vim.api.nvim_create_augroup(group_id_or_name, opts_table)
    ```
    - `group_id_or_name` (string): Nama yang unik secara global untuk augroup Anda. Konvensi yang baik adalah menggunakan nama plugin Anda sebagai prefix.
    - `opts_table` (table): Tabel opsi. Opsi yang paling penting adalah:
      - `clear` (boolean):
        - Jika `true`: Sebelum membuat grup (jika belum ada) atau hanya jika grup sudah ada, semua autocommand yang ada di dalam grup dengan nama ini akan dihapus terlebih dahulu. Ini **sangat penting** untuk mencegah autocommand diduplikasi setiap kali skrip/plugin Anda dimuat ulang (misalnya, saat sourcing ulang file konfigurasi atau saat Neovim melakukan `runtimeเกี่ยวกับการโหลดไฟล์`).
        - Jika `false` (default): Autocommand baru akan ditambahkan ke grup tanpa menghapus yang lama. Ini biasanya tidak diinginkan untuk definisi plugin.
  - **Nilai Kembali:** Integer yang merupakan ID dari augroup yang dibuat/dibersihkan. ID ini dapat digunakan saat membuat autocommand. (Namun, lebih umum menggunakan nama string grup).
- **Sumber Dokumentasi Neovim:**
  - `:h nvim_create_augroup()`

#### Creating Autocommands (`autocmd`)

Setelah augroup dibuat (atau dipastikan bersih), Anda dapat menambahkan autocommand ke dalamnya.

- **`vim.api.nvim_create_autocmd(event, opts)`**

  - **Deskripsi:** Membuat sebuah autocommand baru.
  - **Sintaks Per Baris:**

    ```lua
    -- event_spec bisa berupa string tunggal atau tabel string (untuk beberapa event)
    local event_spec = "BufWritePost" -- atau {"BufWritePost", "BufEnter"}

    local opts_table_autocmd = {
        group = "NamaGrupPluginSaya", -- atau augroup_id dari nvim_create_augroup
        pattern = "*.lua",           -- Opsional: pola file (glob)
        -- buffer = buffer_handle,   -- Opsional: untuk autocommand buffer-lokal
        desc = "Deskripsi autocommand saya", -- Opsional: untuk inspeksi
        -- callback = fungsi_lua_saya, -- Jika menggunakan fungsi Lua
        command = "echo 'File Lua disimpan!'", -- Jika menggunakan perintah Vim
        -- once = false,             -- Opsional: true jika hanya dijalankan sekali
        -- nested = false            -- Opsional: true untuk mengizinkan autocommand bersarang
    }
    -- vim.api.nvim_create_autocmd(event_or_events_list, options_table)
    local autocmd_id = vim.api.nvim_create_autocmd(event_spec, opts_table_autocmd)
    ```

    - `event_spec` (string | table):
      - String tunggal: Nama event (misalnya, `"BufEnter"`, `"VimLeave"`).
      - Tabel string: Daftar nama event (misalnya, `{"BufEnter", "BufWinEnter"}`). Autocommand akan terpicu oleh salah satu event dalam daftar ini.
    - `opts_table_autocmd` (table): Tabel yang berisi konfigurasi untuk autocommand. Field yang umum digunakan:
      - `group` (string | integer, opsional tapi sangat disarankan): Nama atau ID dari augroup tempat autocommand ini akan dimasukkan. Jika tidak ada, ia masuk ke grup global (kurang ideal untuk plugin).
      - `pattern` (string | table, opsional): Pola _glob_ untuk mencocokkan nama file (misalnya, `"*.txt"`, `{"*.lua", "*.md"}`). Jika tidak dispesifikasikan, defaultnya adalah `*` (cocok untuk semua file).
      - `buffer` (integer, opsional): Handle buffer untuk membuat autocommand buffer-lokal (hanya aktif untuk buffer tersebut). Defaultnya tidak buffer-lokal.
      - `callback` (function | string, opsional): Fungsi Lua yang akan dipanggil ketika event terjadi dan kondisi lain (pattern, buffer) terpenuhi. Fungsi ini akan menerima satu argumen berupa tabel yang berisi informasi tentang event. Atau, bisa berupa string kode Lua yang akan dieksekusi.
      - `command` (string, opsional): Perintah Ex Vimscript yang akan dieksekusi. Biasanya Anda menggunakan `callback` ATAU `command`, bukan keduanya.
      - `desc` (string, opsional): Deskripsi singkat tentang apa yang dilakukan autocommand ini. Berguna untuk debugging dan inspeksi (`:augroup NamaGrupPluginSaya`).
      - `once` (boolean, opsional): Jika `true`, autocommand akan otomatis dihapus setelah dieksekusi pertama kali. Defaultnya `false`.
      - `nested` (boolean, opsional): Jika `true`, mengizinkan autocommand ini memicu event lain yang mungkin memiliki autocommand terkait. Defaultnya `false` untuk mencegah loop tak terbatas.

  - **Nilai Kembali:** Integer yang merupakan ID unik dari autocommand yang baru dibuat. ID ini dapat digunakan untuk menghapusnya nanti jika diperlukan.

- **Sumber Dokumentasi Neovim:**
  - `:h nvim_create_autocmd()`

#### Deleting Autocommands (Menghapus Autocommand)

Meskipun menggunakan `clear = true` pada `nvim_create_augroup` adalah cara paling umum untuk mengelola siklus hidup autocommand plugin, Anda juga bisa menghapus autocommand individual.

- **`vim.api.nvim_del_autocmd(id)`**
  - **Deskripsi:** Menghapus autocommand berdasarkan ID-nya.
  - **Sintaks Per Baris:**
    ```lua
    -- Misalkan autocmd_id adalah ID yang dikembalikan oleh nvim_create_autocmd
    -- vim.api.nvim_del_autocmd(autocmd_id_integer)
    vim.api.nvim_del_autocmd(autocmd_id_yang_ingin_dihapus)
    ```
    - `id` (integer): ID dari autocommand yang ingin dihapus.
- **`vim.api.nvim_clear_autocmds(opts)`**
  - **Deskripsi:** Menghapus beberapa autocommand berdasarkan kriteria.
  - **Sintaks:** `vim.api.nvim_clear_autocmds(options_table)`
    - `options_table` (table): Dapat berisi `group`, `event`, `pattern`, `buffer` untuk menentukan autocommand mana yang akan dihapus. Jika tabel kosong, semua autocommand (di semua grup) akan dihapus (berbahaya!).
- **Sumber Dokumentasi Neovim:**
  - `:h nvim_del_autocmd()`
  - `:h nvim_clear_autocmds()`

**Contoh Kode (Membuat Grup dan Autocommand):**

```lua
-- file: autocmd_example.lua
-- Jalankan di Neovim: :luafile autocmd_example.lua

print("--- Membuat Autocommands dengan Lua ---")

-- 1. Definisikan nama grup yang unik untuk plugin/skrip Anda
local MY_AUGROUP_NAME = "MyLuaPluginEvents"

-- 2. Buat (atau bersihkan) augroup
-- vim.api.nvim_create_augroup(name, opts)
-- { clear = true } sangat penting untuk mencegah duplikasi saat skrip ini di-source ulang.
vim.api.nvim_create_augroup(MY_AUGROUP_NAME, { clear = true })
print("Augroup '" .. MY_AUGROUP_NAME .. "' dibuat/dibersihkan.")

-- 3. Definisikan fungsi callback untuk digunakan oleh autocommand
-- Fungsi callback menerima satu argumen (tabel) dengan detail event.
local function on_lua_file_save(event_args)
    print("--- Callback on_lua_file_save dipanggil ---")
    print("Event terpicu:", event_args.event)
    print("File yang cocok (match):", event_args.match) -- Path lengkap file
    print("Buffer handle:", event_args.buf)
    print("ID Autocommand:", event_args.id)
    print("Grup Autocommand:", event_args.group) -- ID grup, bukan nama
    vim.api.nvim_notify("File Lua '" .. vim.fn.fnamemodify(event_args.match, ":t") .. "' disimpan!", vim.log.levels.INFO, {title = "Plugin Saya"})
end

-- 4. Membuat autocommand untuk event BufWritePost pada file *.lua
-- vim.api.nvim_create_autocmd(event, opts)
local lua_save_autocmd_opts = {
    group = MY_AUGROUP_NAME,                     -- Kaitkan dengan augroup kita
    pattern = "*.lua",                           -- Hanya untuk file .lua
    desc = "Jalankan aksi setelah file Lua disimpan",
    callback = on_lua_file_save                  -- Fungsi Lua yang akan dipanggil
}
local lua_save_id = vim.api.nvim_create_autocmd("BufWritePost", lua_save_autocmd_opts)
if lua_save_id then
    print("Autocommand 'BufWritePost *.lua' dibuat dengan ID:", lua_save_id)
end

-- 5. Membuat autocommand lain untuk event FileType pada file python
-- Kali ini menggunakan 'command' string.
local python_ft_autocmd_opts = {
    group = MY_AUGROUP_NAME,
    pattern = "*.py",
    desc = "Echo pesan saat file Python terdeteksi",
    command = "echom 'File Python terdeteksi oleh autocommand Lua!'" -- Perintah Vim
}
local python_ft_id = vim.api.nvim_create_autocmd("FileType", python_ft_autocmd_opts)
if python_ft_id then
    print("Autocommand 'FileType *.py' dibuat dengan ID:", python_ft_id)
end

-- 6. Membuat autocommand untuk beberapa event sekaligus
local multi_event_opts = {
    group = MY_AUGROUP_NAME,
    pattern = "*", -- Semua file
    desc = "Notifikasi saat memasuki buffer atau jendela",
    callback = function(args)
        vim.api.nvim_notify(args.event .. " terpicu untuk buffer " .. args.buf, vim.log.levels.WARN, {})
    end
}
local multi_event_id = vim.api.nvim_create_autocmd({"BufEnter", "WinEnter"}, multi_event_opts)
if multi_event_id then
    print("Autocommand untuk BufEnter, WinEnter dibuat dengan ID:", multi_event_id)
end

-- Untuk melihat autocommand yang terdaftar:
-- :au MyLuaPluginEvents
-- (atau :au untuk semua)

-- Untuk menghapus autocommand individual (jika perlu, meskipun clear=true di augroup lebih umum)
-- if lua_save_id then
--     vim.api.nvim_del_autocmd(lua_save_id)
--     print("Autocommand dengan ID " .. lua_save_id .. " telah dihapus (contoh).")
-- end
```

**Cara Menjalankan Kode:**

1.  Buka Neovim.
2.  Simpan kode di atas ke file, misalnya `autocmd_example.lua`.
3.  Jalankan dengan `:luafile autocmd_example.lua`.
4.  Untuk menguji:
    - Buka file Lua (`.lua`) dan simpan (`:w`). Anda akan melihat output dari `on_lua_file_save` di area pesan atau notifikasi.
    - Buka file Python (`.py`) atau set filetype ke python (`:set ft=python`). Anda akan melihat pesan dari `echom`.
    - Pindah antar buffer atau jendela untuk memicu `BufEnter` / `WinEnter`.

**Penjelasan Kode Keseluruhan (`autocmd_example.lua`):**

- **`MY_AUGROUP_NAME`**: Mendefinisikan nama string untuk augroup.
- **`vim.api.nvim_create_augroup(...)`**: Membuat augroup. `{clear = true}` memastikan tidak ada duplikasi jika file ini di-source beberapa kali.
- **`on_lua_file_save(event_args)`**: Fungsi callback Lua. Ia menerima tabel `event_args` dan mencetak beberapa informasinya. Ia juga menggunakan `vim.api.nvim_notify` untuk menampilkan notifikasi.
- **Autocmd `BufWritePost *.lua`**: Autocommand ini terkait dengan grup `MY_AUGROUP_NAME`, hanya aktif untuk file yang cocok dengan pola `*.lua`, dan akan memanggil fungsi `on_lua_file_save` setelah file Lua disimpan.
- **Autocmd `FileType *.py`**: Autocommand ini menggunakan opsi `command` untuk menjalankan perintah Vim `echom` ketika tipe file Python terdeteksi.
- **Autocmd `{"BufEnter", "WinEnter"}`**: Contoh autocommand yang merespons beberapa event sekaligus, memanggil callback Lua sederhana yang memberi notifikasi.
- Bagian yang dikomentari untuk `nvim_del_autocmd` menunjukkan cara menghapus autocommand tertentu jika ID-nya diketahui.

---

### 14.3 Callback Functions (Fungsi Panggil Balik)

Ketika Anda menggunakan opsi `callback` dalam `nvim_create_autocmd`, fungsi Lua yang Anda sediakan akan menerima satu argumen. Argumen ini adalah tabel yang berisi informasi kontekstual tentang event yang memicu autocommand.

- **Deskripsi Konsep:** Fungsi callback memungkinkan logika yang lebih kompleks dan dinamis sebagai respons terhadap event, karena Anda dapat menggunakan semua kekuatan bahasa Lua di dalamnya, termasuk mengakses data event.
- **Struktur Argumen Callback:** Tabel yang diterima oleh fungsi callback (sering dinamai `args` atau `event_args` secara konvensi) memiliki beberapa field standar dan beberapa yang mungkin spesifik untuk event tertentu.
- **Field Umum dalam Tabel Argumen Callback:**
  - `id` (integer): ID dari autocommand yang terpicu.
  - `event` (string): Nama event yang sebenarnya terpicu (misalnya, `"BufEnter"`). Ini berguna jika satu autocommand mendaftar untuk beberapa event.
  - `group` (integer): ID dari augroup tempat autocommand ini berada.
  - `match` (string): Untuk event yang terkait dengan file (seperti `BufRead`, `BufWritePost`, `FileType` jika pattern digunakan), ini adalah path lengkap file yang menyebabkan autocommand cocok dan terpicu.
  - `buf` (integer): Nomor handle buffer yang terkait dengan event (misalnya, buffer yang dimasuki, buffer yang ditulis).
  - `file` (string): Nama file yang terkait dengan event (seringkali sama dengan `match` atau bagian dari itu).
  - `expand` (string): Bagaimana `<afile>`, `<abuf>`, dll. di-expand untuk autocommand ini.
  - Beberapa event mungkin menambahkan field tambahan ke tabel ini (misalnya, `TextChanged` mungkin memiliki info tentang perubahan teks). Periksa `:h autocmd-events-abc` dan event spesifik untuk detailnya.
- **Implementasi dalam Neovim:** Hampir semua logika plugin yang digerakkan oleh event akan melibatkan penulisan fungsi callback. Di dalamnya, Anda akan menggunakan `vim.api` atau `vim.fn` untuk berinteraksi lebih lanjut dengan editor berdasarkan konteks event.

**Contoh Fungsi Callback (sudah terlihat di contoh sebelumnya):**

```lua
local function my_event_handler(args)
    print("Event terdeteksi: " .. args.event)
    if args.event == "BufEnter" then
        print("Memasuki buffer dengan handle: " .. args.buf)
        if args.match and args.match ~= "" then
            print("File yang terkait dengan buffer (match): " .. args.match)
        end
    elseif args.event == "BufWritePost" then
        print("Buffer " .. args.buf .. " (" .. (args.match or "tidak ada file") .. ") telah disimpan.")
        -- Lakukan sesuatu setelah penyimpanan, misalnya, linting.
    end
    -- Anda bisa menggunakan vim.api lainnya di sini
    -- vim.api.nvim_buf_set_name(args.buf, "Nama Baru") -- Contoh (hati-hati!)
end

-- Mengaitkannya dengan augroup dan autocommand:
-- vim.api.nvim_create_augroup("MyCallbacks", { clear = true })
-- vim.api.nvim_create_autocmd({"BufEnter", "BufWritePost"}, {
--     group = "MyCallbacks",
--     pattern = "*",
--     callback = my_event_handler,
--     desc = "Contoh handler untuk beberapa event"
-- })
```

**Penjelasan Kode (Fungsi Callback):**

- Fungsi `my_event_handler` menerima satu argumen `args`.
- Di dalamnya, kita mengakses `args.event` untuk mengetahui event mana yang memicu panggilan.
- Bergantung pada event, kita bisa mengakses field lain seperti `args.buf` atau `args.match` untuk mendapatkan konteks lebih lanjut.
- Bagian yang dikomentari menunjukkan bagaimana fungsi callback ini akan dihubungkan ke sebuah autocommand.

---

Penanganan event melalui autocommand adalah mekanisme yang sangat kuat di Neovim. Dengan menggunakan `vim.api` untuk membuat augroup dan autocommand yang bersih, serta fungsi callback Lua yang cerdas, Anda dapat membuat plugin yang terintegrasi secara mulus dengan alur kerja pengguna dan state editor.

> - **[Ke Atas](#)**
> - **[Selanjutnya][4]**
> - **[Sebelumnya][3]**
> - **[Kurikulum][2]**
> - **[Domain Spesifik][5]**

[5]: ../../../../../../../README.md
[4]: ../15-ui/README.md
[3]: ../13-unit-testing-dengan-busted/README.md
[2]: ../../../../../README.md
[1]: ../../README.md/#14-advanced-plugin-development-patterns
