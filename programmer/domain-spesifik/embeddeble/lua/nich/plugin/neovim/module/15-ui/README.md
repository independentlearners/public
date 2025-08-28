# **[15. User Interface (UI) - Elemen Dasar][1]**

Bagian ini akan membahas cara-cara dasar plugin Lua Anda dapat berkomunikasi dengan pengguna, seperti menampilkan pesan, meminta input, dan menyajikan pilihan sederhana. Neovim menyediakan beberapa mekanisme untuk ini, dari fungsi Lua standar hingga API UI yang lebih modern dan dapat diperluas.

---

### 15.1 Pesan dan Notifikasi

Menampilkan pesan kepada pengguna adalah cara fundamental untuk memberikan umpan balik, status, atau informasi kesalahan.

#### `print()`

- **Deskripsi Konsep:** `print()` adalah fungsi Lua standar yang Anda kenal. Dalam konteks Neovim, output dari `print()` biasanya diarahkan ke area pesan Neovim.
- **Sintaks Per Baris:**
  ```lua
  print(arg1, arg2, ..., argN)
  ```
  - `arg1, arg2, ..., argN`: Satu atau lebih argumen dari tipe apa pun. `print` akan mencoba mengonversi setiap argumen menjadi string. Argumen-argumen tersebut akan dicetak ke output standar, dipisahkan oleh karakter tab secara default (perilaku ini bisa berbeda sedikit tergantung lingkungan Lua, tetapi di Neovim, mereka biasanya dipisahkan spasi atau dikonkatenasi tergantung bagaimana Neovim menangani stream `print`).
- **Perilaku di Neovim:**
  - Output muncul di area pesan (command-line area).
  - Jika banyak pesan dicetak berturut-turut, hanya yang terakhir yang mungkin terlihat langsung; sisanya dapat dilihat dengan perintah `:messages`.
  - `print()` bersifat sinkron dan akan langsung mencetak.
  - Umumnya digunakan untuk debugging cepat atau pesan log sederhana selama pengembangan. Untuk notifikasi yang lebih terlihat dan berstruktur kepada pengguna, `vim.notify()` lebih disukai.
- **Implementasi dalam Neovim:** Cocok untuk debugging internal plugin Anda. Misalnya, untuk mencetak nilai variabel pada titik tertentu.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (`print`): [https://www.lua.org/manual/5.1/manual.html\#pdf-print](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%23pdf-print)

**Contoh Kode (`print()`):**

```lua
-- file: print_example.lua
-- Jalankan di Neovim: :luafile print_example.lua
-- Atau :lua print("Pesan ini dari :lua print()")

print("--- Menggunakan print() di Neovim ---")

local user_name = "Pengembang Plugin"
local plugin_version = "0.1.0"

-- Mencetak string sederhana
print("Plugin sedang dimuat...")

-- Mencetak beberapa argumen, akan dikonversi ke string dan digabung
print("Nama Pengguna:", user_name, "Versi Plugin:", plugin_version)

-- Mencetak tabel (akan menampilkan alamat memori, bukan isinya secara detail)
local my_table = { key = "value", num = 123 }
print("Isi tabel (alamat):", my_table) -- Output: Isi tabel (alamat): table: 0x........
-- Untuk mencetak isi tabel dengan lebih baik, gunakan vim.print() atau fungsi kustom
print("Isi tabel (dengan vim.print):")
vim.print(my_table) -- vim.print() adalah versi Neovim yang lebih baik untuk inspeksi tabel
```

**Cara Menjalankan Kode:**

1.  Buka Neovim.
2.  Simpan kode di atas ke file, misalnya `print_example.lua`.
3.  Jalankan dengan perintah `:luafile print_example.lua`.
4.  Anda akan melihat output terakhir di area pesan. Untuk melihat semua pesan yang dicetak, ketik `:messages`.

**Penjelasan Kode Keseluruhan (`print_example.lua`):**

- Baris-baris `print()` akan mengirim outputnya ke area pesan Neovim.
- `print("Isi tabel (alamat):", my_table)` menunjukkan bahwa `print()` standar Lua tidak secara otomatis menampilkan isi tabel secara detail, melainkan representasi string defaultnya (biasanya alamat memori).
- `vim.print(my_table)` adalah fungsi khusus Neovim yang lebih baik untuk mencetak inspeksi tabel Lua, menampilkan kunci dan nilainya secara rekursif.

#### `vim.notify()`

- **Deskripsi Konsep:** `vim.notify()` adalah API Neovim yang dirancang khusus untuk menampilkan notifikasi kepada pengguna. Notifikasi ini bisa lebih menonjol daripada output `print()` (misalnya, muncul sebagai jendela mengambang sementara) dan dapat dikategorikan berdasarkan tingkat kepentingan (error, warning, info).
- **Sintaks Per Baris:**
  ```lua
  vim.api.nvim_notify(message_string, level_integer, opts_table)
  -- atau alias yang lebih mudah:
  vim.notify(message_string, level_integer, opts_table)
  ```
  - `message_string` (string, wajib): Teks pesan notifikasi yang akan ditampilkan. Dapat berisi karakter newline `\n`.
  - `level_integer` (integer, opsional): Tingkat kepentingan pesan. Gunakan konstanta dari `vim.log.levels`:
    - `vim.log.levels.ERROR` (0): Untuk kesalahan.
    - `vim.log.levels.WARN` (1): Untuk peringatan.
    - `vim.log.levels.INFO` (2): Untuk pesan informasi (default jika `level` dihilangkan atau `nil`).
    - `vim.log.levels.DEBUG` (3): Untuk pesan debug.
    - `vim.log.levels.TRACE` (4): Untuk pesan trace yang sangat detail.
      Tingkat ini dapat mempengaruhi bagaimana notifikasi ditampilkan (misalnya, ikon atau warna yang berbeda, tergantung konfigurasi UI notifikasi).
  - `opts_table` (table, opsional): Tabel yang berisi opsi tambahan untuk notifikasi:
    - `title` (string, opsional): Judul untuk jendela notifikasi.
    - `icon` (string, opsional): Karakter ikon untuk ditampilkan bersama pesan (misalnya, "✓", "❌", "💡").
    - `timeout` (integer, opsional): Durasi dalam milidetik sebelum notifikasi otomatis ditutup (jika didukung oleh backend UI).
    - `on_open` (function, opsional): Callback yang dipanggil saat notifikasi dibuka.
    - `on_close` (function, opsional): Callback yang dipanggil saat notifikasi ditutup.
    - `plugin` (string, opsional): Nama plugin yang menghasilkan notifikasi, untuk logging.
    - `keep` (function, opsional): Fungsi yang dipanggil untuk menentukan apakah notifikasi harus tetap ada (untuk notifikasi yang bisa di-update).
- **Implementasi dalam Neovim:** Ini adalah cara standar dan direkomendasikan bagi plugin untuk menampilkan pesan informatif, peringatan, atau kesalahan kepada pengguna.
- **Sumber Dokumentasi Neovim:**
  - `:h vim.notify()`
  - `:h nvim_notify()` (fungsi API yang mendasarinya)
  - `:h vim.log.levels`

**Contoh Kode (`vim.notify()`):**

```lua
-- file: notify_example.lua
-- Jalankan di Neovim: :luafile notify_example.lua

print("--- Menggunakan vim.notify() ---")

-- Notifikasi INFO sederhana
vim.notify("Plugin Anda berhasil dimuat.", vim.log.levels.INFO, { title = "Status Plugin" })

-- Notifikasi WARN dengan ikon
vim.notify("Konfigurasi 'opsi_lama' sudah usang.\nGunakan 'opsi_baru' sebagai gantinya.", vim.log.levels.WARN, {
    title = "Peringatan Konfigurasi",
    icon = "⚠️"
})

-- Notifikasi ERROR
local success_operation = false -- Simulasi operasi gagal
if not success_operation then
    vim.notify("Gagal menjalankan operasi penting! Periksa log untuk detail.", vim.log.levels.ERROR, {
        title = "Kegagalan Kritis Plugin"
    })
end

-- Notifikasi DEBUG (mungkin hanya terlihat jika level log Neovim diatur untuk menampilkan debug)
vim.notify("Nilai variabel x adalah: " .. tostring(123), vim.log.levels.DEBUG, { title = "Debug Internal" })

-- Notifikasi tanpa level (default ke INFO) dan tanpa opsi
vim.notify("Ini adalah notifikasi standar.")
```

**Cara Menjalankan Kode:**
Sama seperti contoh `print()`, jalankan file ini dari dalam Neovim. Notifikasi akan muncul (biasanya sebagai jendela mengambang kecil, tergantung konfigurasi Neovim Anda).

**Penjelasan Kode Keseluruhan (`notify_example.lua`):**

- Beberapa panggilan `vim.notify` dibuat dengan level yang berbeda (`INFO`, `WARN`, `ERROR`, `DEBUG`) dan beberapa dengan opsi `title` dan `icon`.
- Ini mendemonstrasikan bagaimana plugin dapat memberikan umpan balik yang lebih terstruktur dan terlihat kepada pengguna dibandingkan dengan `print()`.

---

### 15.2 Input Pengguna

Seringkali plugin perlu meminta input teks dari pengguna.

#### `vim.fn.input()` - _Reiterasi_

- **Deskripsi Konsep:** Seperti yang dibahas di Bagian 13.1, `vim.fn.input()` adalah cara untuk memanggil fungsi `input()` Vimscript. Ini adalah cara sederhana untuk mendapatkan input teks, tetapi bersifat _blocking_.
- **Sintaks Per Baris (Review):**

  ```lua
  -- Opsi 1: Hanya prompt
  local hasil_input = vim.fn.input("Masukkan nama Anda: ")

  -- Opsi 2: Prompt dan teks default
  local hasil_input_default = vim.fn.input("Masukkan email: ", "user@example.com")

  -- Opsi 3: Prompt, teks default, dan tipe completion (jika ada)
  -- completion_type bisa seperti "file", "directory", "customlist,MyVimListFunc"
  local path_input = vim.fn.input("Masukkan path file: ", "", "file")
  ```

  - Argumen pertama adalah string prompt atau tabel opsi (lihat `:h input()`).
  - Argumen kedua (opsional) adalah teks default.
  - Argumen ketiga (opsional) adalah jenis penyelesaian (completion) yang akan digunakan.

- **Nilai Kembali:** String yang dimasukkan pengguna, atau string kosong jika pengguna membatalkan dengan `<Esc>` (atau jika ada error, bisa `nil` dalam beberapa kasus langka, jadi selalu baik untuk memeriksa).
- **Penting:** **Blocking\!** Neovim akan berhenti menunggu input pengguna. Ini bisa mengganggu jika digunakan dalam konteks di mana responsivitas UI penting.
- **Sumber Dokumentasi Neovim:**
  - `:h vim.fn.input()` (alias Lua)
  - `:h input()` (fungsi Vimscript asli)

#### `vim.ui.input()`

- **Deskripsi Konsep:** `vim.ui.input()` adalah bagian dari antarmuka UI Neovim yang lebih modern dan dapat diperluas (`vim.ui`). Tujuannya adalah untuk menyediakan cara standar bagi plugin untuk meminta input, di mana tampilan dan nuansa sebenarnya dari prompt input dapat dikustomisasi oleh pengguna atau plugin UI lain (misalnya, menggunakan input GUI jika Neovim disematkan atau memiliki frontend GUI).
- **Sintaks Per Baris:**

  ```lua
  -- vim.ui.input(opts_table, on_confirm_callback)
  local opts_input_ui = {
      prompt = "Masukkan nama proyek: ", -- Pesan prompt yang ditampilkan
      default = "Proyek Baru",           -- Nilai default (opsional)
      completion = "file",               -- Jenis completion (opsional, misal "file", "dir", "shellcmd")
      -- highlight = function(input_str, cursor_pos) ... end, -- Fungsi untuk highlight kustom (opsional)
      -- ... opsi lain ...
  }

  local function handle_project_name(input_value)
      -- input_value adalah string yang dimasukkan, atau nil jika dibatalkan
      if input_value then
          print("Nama proyek diterima (via vim.ui.input): " .. input_value)
      else
          print("Input nama proyek dibatalkan (via vim.ui.input).")
      end
  end

  vim.ui.input(opts_input_ui, handle_project_name)
  ```

  - `opts_input_ui` (table): Tabel konfigurasi untuk input:
    - `prompt` (string, wajib): Teks yang ditampilkan kepada pengguna.
    - `default` (string, opsional): Nilai awal untuk input field.
    - `completion` (string, opsional): Jenis completion yang akan digunakan (misalnya, `"file"`, `"directory"`, `"shellcmd"`, atau bahkan fungsi kustom via `vim.ui.set_completion_filter`).
    - `highlight` (function, opsional): Fungsi callback `(input_string, cursor_pos) -> highlights_table` yang dapat digunakan untuk memberikan highlighting kustom pada teks input secara dinamis.
    - `cancel_text` (string, opsional): Teks yang dikembalikan jika input dibatalkan (default `nil`).
  - `on_confirm_callback` (function, wajib): Fungsi callback yang akan dipanggil setelah pengguna selesai memasukkan input (menekan Enter) atau membatalkan. Fungsi ini menerima satu argumen:
    - `input_value` (string | nil): String yang dimasukkan pengguna, atau `nil` jika input dibatalkan (misalnya, dengan `<Esc>`).

- **Perilaku:**
  - Implementasi default `vim.ui.input` di TUI Neovim (tanpa plugin UI eksternal) bersifat _blocking_, mirip dengan `vim.fn.input()`.
  - Namun, keindahan `vim.ui` adalah bahwa plugin UI pihak ketiga (misalnya, untuk GUI atau UI kustom) dapat "mengambil alih" implementasi `vim.ui.input`, dan implementasi tersebut _bisa jadi_ asinkron dan non-blocking. Plugin Anda tidak perlu tahu detailnya; ia hanya menggunakan `vim.ui.input` standar.
- **Implementasi dalam Neovim:** Direkomendasikan untuk input pengguna dalam plugin modern karena memungkinkan konsistensi UI dan potensi untuk pengalaman pengguna yang lebih baik jika UI kustom digunakan.
- **Sumber Dokumentasi Neovim:**
  - `:h vim.ui.input()`
  - `:h ui-ext` (tentang ekstensibilitas UI)

**Contoh Kode (`vim.fn.input` dan `vim.ui.input`):**

```lua
-- file: user_input_example.lua
-- Jalankan di Neovim

print("--- Input Pengguna ---")

-- 1. Menggunakan vim.fn.input() (blocking)
print("\n--- Menggunakan vim.fn.input() ---")
local fn_name = vim.fn.input("vim.fn.input() -> Masukkan nama Anda: ", "Anonim")
if fn_name ~= "" and fn_name ~= nil then -- input() bisa mengembalikan string kosong jika Esc atau hanya Enter
    print("Halo (dari vim.fn.input), " .. fn_name .. "!")
else
    print("Input dari vim.fn.input() dibatalkan atau kosong.")
end

-- 2. Menggunakan vim.ui.input() (defaultnya blocking di TUI, tapi extensible)
print("\n--- Menggunakan vim.ui.input() ---")
local ui_input_opts = {
    prompt = "vim.ui.input() -> Masukkan nama kota: ",
    default = "Jakarta",
    completion = nil -- tidak ada completion khusus untuk contoh ini
}

-- Definisikan callback untuk menangani hasil input
local function city_input_callback(kota)
    if kota then -- kota adalah string jika pengguna menekan Enter
        vim.notify("Kota yang Anda pilih (via vim.ui.input): " .. kota, vim.log.levels.INFO)
    else -- kota adalah nil jika pengguna membatalkan (misalnya, dengan Esc)
        vim.notify("Pemilihan kota dibatalkan (via vim.ui.input).", vim.log.levels.WARN)
    end
end

-- Panggil vim.ui.input
print("Memanggil vim.ui.input(). Neovim akan menunggu input...")
vim.ui.input(ui_input_opts, city_input_callback)
print("Setelah panggilan vim.ui.input() kembali (jika blocking).") -- Baris ini akan menunggu jika TUI default
```

**Cara Menjalankan Kode:**
Jalankan file ini dari dalam Neovim. Anda akan diminta untuk memasukkan input dua kali.

**Penjelasan Kode Keseluruhan (`user_input_example.lua`):**

- Bagian `vim.fn.input()`: Meminta nama pengguna, dengan "Anonim" sebagai default. Hasilnya langsung diproses karena `vim.fn.input` mengembalikan nilai secara langsung setelah blocking.
- Bagian `vim.ui.input()`:
  - `ui_input_opts` mendefinisikan prompt dan nilai default.
  - `city_input_callback` adalah fungsi yang akan dieksekusi _setelah_ pengguna selesai dengan prompt `vim.ui.input`. Ia memeriksa apakah input (`kota`) diberikan atau `nil` (dibatalkan).
  - `vim.ui.input(ui_input_opts, city_input_callback)`: Memicu prompt input. Dengan TUI default, ini akan memblokir, dan setelah pengguna selesai, `city_input_callback` akan segera dipanggil.

---

### 15.3 Menu Sederhana (Select)

Kadang-kadang Anda ingin pengguna memilih satu dari beberapa opsi yang telah ditentukan.

#### `vim.fn.inputlist()`

- **Deskripsi Konsep:** Fungsi Vimscript `inputlist()` yang dapat diakses melalui `vim.fn`, menampilkan daftar pilihan bernomor kepada pengguna. Pengguna memilih dengan mengetik nomor. Bersifat _blocking_.
- **Sintaks Per Baris:**
  ```lua
  -- textlist_lua adalah tabel Lua berisi string-string pilihan.
  local choices_list = {
      "Pilihan Pertama",
      "Pilihan Kedua: Apel",
      "Pilihan Ketiga: Jeruk"
  }
  -- vim.fn.inputlist(list_vim_atau_lua)
  local chosen_index = vim.fn.inputlist(choices_list)
  ```
  - `textlist_lua` (table): Sebuah tabel Lua yang berisi string-string yang akan ditampilkan sebagai pilihan. Neovim akan menampilkannya sebagai daftar bernomor.
- **Nilai Kembali:** Angka integer yang merupakan indeks (berbasis 1) dari pilihan yang dipilih pengguna. Mengembalikan `0` jika pengguna membatalkan (misalnya, dengan `<Esc>`) atau memasukkan nomor yang tidak valid.
- **Penting:** **Blocking\!**
- **Sumber Dokumentasi Neovim:**
  - `:h vim.fn.inputlist()`
  - `:h inputlist()`

#### `vim.ui.select()`

- **Deskripsi Konsep:** Bagian dari antarmuka `vim.ui` untuk menyajikan daftar pilihan kepada pengguna. Seperti `vim.ui.input`, ini dapat diperluas dan dapat memiliki backend UI yang berbeda.
- **Sintaks Per Baris:**

  ```lua
  -- items_list adalah tabel Lua berisi pilihan. Bisa string atau tabel.
  local items_to_select = { "Merah", "Hijau", "Biru", {label="Kuning Spesial", value="Y_SP"}}

  local opts_select_ui = {
      prompt = "Pilih warna favorit Anda:", -- Prompt yang ditampilkan (opsional)
      format_item = function(item_value)   -- Fungsi untuk memformat tampilan item (opsional)
          if type(item_value) == "table" and item_value.label then
              return item_value.label .. " (kode: " .. item_value.value .. ")"
          end
          return tostring(item_value)
      end,
      kind = "color_picker", -- Hint untuk UI (opsional, misal "file", "lsp_symbol")
      -- ... opsi lain ...
  }

  local function handle_color_choice(chosen_item, item_index)
      -- chosen_item adalah item aktual yang dipilih dari items_to_select
      -- (bisa string atau tabel {label, value} dalam contoh ini).
      -- item_index adalah indeks (berbasis 1) dari item yang dipilih dalam items_list asli.
      -- Keduanya nil jika dibatalkan.
      if chosen_item then
          local display_val
          if type(chosen_item) == "table" then
              display_val = chosen_item.value
          else
              display_val = chosen_item
          end
          print("Warna dipilih (via vim.ui.select): " .. display_val .. " (pada indeks " .. item_index .. ")")
      else
          print("Pemilihan warna dibatalkan (via vim.ui.select).")
      end
  end

  vim.ui.select(items_to_select, opts_select_ui, handle_color_choice)
  ```

  - `items_to_select` (table, wajib): Tabel Lua yang berisi item-item pilihan. Setiap elemen bisa berupa:
    - String: Akan ditampilkan apa adanya.
    - Tabel: Bisa memiliki field khusus (misalnya `label` untuk teks tampilan, dan field lain untuk data internal) yang dapat diproses oleh `format_item` atau callback `on_choice`.
  - `opts_select_ui` (table, opsional): Tabel konfigurasi untuk menu pilihan:
    - `prompt` (string, opsional): Pesan yang ditampilkan di atas daftar pilihan.
    - `format_item` (function, opsional): Fungsi callback `(item) -> display_string`. Menerima satu item dari `items_to_select` dan harus mengembalikan string yang akan ditampilkan untuk item tersebut dalam daftar.
    - `kind` (string, opsional): String yang memberikan petunjuk kepada backend UI tentang "jenis" item yang dipilih (misalnya, `"file"`, `"command"`, `"lsp_document_symbol"`). Ini dapat mempengaruhi presentasi UI (misalnya, menambahkan ikon).
  - `on_choice_callback` (function, wajib): Fungsi callback yang dipanggil setelah pengguna membuat pilihan atau membatalkan. Menerima dua argumen:
    - `chosen_item` (any | nil): Item aktual dari `items_to_select` yang dipilih pengguna. Ini adalah nilai aslinya, bukan hanya string tampilan. Akan `nil` jika dibatalkan.
    - `item_index` (integer | nil): Indeks (berbasis 1) dari item yang dipilih dalam `items_to_select` asli. Akan `nil` jika dibatalkan.

- **Perilaku:** Mirip `vim.ui.input`, implementasi default di TUI bersifat blocking. UI kustom bisa membuatnya non-blocking.
- **Implementasi dalam Neovim:** Sangat berguna untuk meminta pengguna memilih dari daftar opsi yang terbatas, seperti memilih tindakan, file, atau konfigurasi.
- **Sumber Dokumentasi Neovim:**
  - `:h vim.ui.select()`

**Contoh Kode (`vim.fn.inputlist` dan `vim.ui.select`):**

```lua
-- file: select_example.lua
-- Jalankan di Neovim

print("--- Menu Pilihan Sederhana ---")

-- 1. Menggunakan vim.fn.inputlist() (blocking)
print("\n--- Menggunakan vim.fn.inputlist() ---")
local fruit_options_fn = {
    "1. Apel", -- inputlist biasanya mengharapkan Anda memformat nomornya sendiri
    "2. Jeruk",
    "3. Pisang"
}
-- Untuk inputlist, lebih baik tidak menyertakan nomor di string jika Anda ingin hasil indeksnya bersih.
-- Neovim akan menampilkan nomornya.
local fruit_options_clean = {"Apel", "Jeruk", "Pisang"}

print("Memanggil vim.fn.inputlist()...")
-- vim.fn.inputlist() akan menampilkan:
--   Pilih buah:
--   1: Apel
--   2: Jeruk
--   3: Pisang
local chosen_fruit_index = vim.fn.inputlist(fruit_options_clean)

if chosen_fruit_index > 0 and chosen_fruit_index <= #fruit_options_clean then
    print("Buah dipilih (via vim.fn.inputlist): " .. fruit_options_clean[chosen_fruit_index] .. " (indeks " .. chosen_fruit_index .. ")")
else
    print("Pemilihan buah dari vim.fn.inputlist() dibatalkan atau tidak valid.")
end


-- 2. Menggunakan vim.ui.select() (defaultnya blocking di TUI, tapi extensible)
print("\n--- Menggunakan vim.ui.select() ---")
local color_items_ui = {
    "Merah",
    "Hijau",
    { value = "BLUE_CODE", display = "Biru Langit"}, -- Item kustom sebagai tabel
    "Kuning"
}

local ui_select_opts = {
    prompt = "vim.ui.select() -> Pilih warna favorit Anda:",
    format_item = function(item)
        -- Jika item adalah tabel dengan field 'display', gunakan itu.
        -- Jika tidak, konversi item ke string.
        if type(item) == "table" and item.display then
            return "🎨 " .. item.display -- Tambahkan ikon kecil
        end
        return " > " .. tostring(item)
    end,
    kind = "color" -- Memberi petunjuk jenis item
}

local function color_choice_callback(selected_item, idx)
    if selected_item then
        local actual_value
        if type(selected_item) == "table" and selected_item.value then
            actual_value = selected_item.value
        else
            actual_value = selected_item
        end
        vim.notify(string.format("Warna dipilih: %s (dari item asli, indeks %d)", tostring(actual_value), idx), vim.log.levels.INFO, {title="Pilihan UI Select"})
    else
        vim.notify("Pemilihan warna dibatalkan.", vim.log.levels.WARN, {title="Pilihan UI Select"})
    end
end

print("Memanggil vim.ui.select(). Neovim akan menunggu pilihan...")
vim.ui.select(color_items_ui, ui_select_opts, color_choice_callback)
print("Setelah panggilan vim.ui.select() kembali (jika blocking).")
```

**Cara Menjalankan Kode:**
Jalankan file ini dari dalam Neovim. Anda akan disajikan dua menu pilihan secara berurutan.

**Penjelasan Kode Keseluruhan (`select_example.lua`):**

- **Bagian `vim.fn.inputlist()`:**
  - `fruit_options_clean`: Tabel string sederhana. `vim.fn.inputlist` akan menampilkan ini dengan nomor.
  - Hasilnya adalah indeks (atau 0).
- **Bagian `vim.ui.select()`:**
  - `color_items_ui`: Daftar pilihan yang lebih kompleks, termasuk string dan tabel (untuk `Biru Langit`).
  - `ui_select_opts`:
    - `prompt`: Pesan yang ditampilkan.
    - `format_item`: Fungsi kustom untuk mengubah cara setiap item ditampilkan dalam daftar (menambahkan ikon atau memformat item tabel).
    - `kind`: Petunjuk jenis item.
  - `color_choice_callback`: Fungsi yang dipanggil setelah pengguna memilih. Ia menerima `selected_item` (item asli dari `color_items_ui`) dan `idx` (indeksnya). Ini memungkinkan Anda mendapatkan data yang lebih kaya daripada hanya indeks.

---

Menggunakan elemen UI dasar ini memungkinkan plugin Anda untuk berinteraksi dengan pengguna secara lebih efektif. `vim.notify` adalah standar untuk pesan, sementara `vim.ui.input` dan `vim.ui.select` menyediakan cara yang modern dan dapat diperluas untuk input dan pilihan, yang selaras dengan filosofi desain Neovim. Selalu pertimbangkan sifat blocking dari beberapa fungsi ini dan dampaknya pada pengalaman pengguna, terutama `vim.fn.input` dan `vim.fn.inputlist`.

> Pada bagian berikutnya, kit akan masuk pada pembahasan yang lebih mendalam tentang UI

> - **[Ke Atas](#)**
> - **[Selanjutnya][4]**
> - **[Sebelumnya][3]**
> - **[Kurikulum][2]**
> - **[Domain Spesifik][5]**

[5]: ../../../../../../../README.md
[4]: ../16-floating-windows/README.md
[3]: ../14-async-programming/README.md
[2]: ../../../../../README.md
[1]: ../../README.md
