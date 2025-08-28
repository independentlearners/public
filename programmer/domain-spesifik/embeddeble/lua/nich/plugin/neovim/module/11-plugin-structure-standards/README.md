# **[11. Interaksi dengan Sistem File dan OS][1]**

Bagian ini akan membahas bagaimana Lua dapat berinteraksi dengan sistem file untuk operasi baca/tulis dan direktori, serta cara menjalankan perintah sistem operasi dan mengakses variabel lingkungan. Lebih lanjutnya bahwa bagian ini adalah interaksi dengan Sistem File dan OS. Kemampuan untuk membaca dan menulis file, serta menjalankan perintah sistem operasi, adalah fungsionalitas penting untuk banyak plugin, misalnya untuk membaca file konfigurasi, menyimpan data, atau berinteraksi dengan alat baris perintah (command-line tools).

---

### 11.1 Akses Sistem File

Lua menyediakan pustaka `io` standar untuk operasi input/output, termasuk operasi pada file. Untuk operasi direktori yang lebih canggih, pustaka eksternal seperti LuaFileSystem (`lfs`) sering digunakan, atau dalam konteks Neovim, `vim.loop` (libuv) menyediakan fungsionalitas serupa yang terintegrasi dengan baik.

#### Reading Files (Membaca File)

- **Deskripsi Konsep:** Membaca file melibatkan pembukaan file dalam mode baca, membaca isinya (seluruhnya, baris per baris, atau sejumlah byte tertentu), dan kemudian menutup file tersebut.
- **Fungsi dan Metode Kunci (`io` library):**
  - **`io.open(filename, mode)`**
    - **Sintaks:** `local file_handle, error_message = io.open(nama_file_string, mode_string)`
    - `filename`: String yang berisi path ke file.
    - `mode`: String yang menentukan mode akses. Mode umum untuk membaca:
      - `"r"`: Mode baca (default). Error jika file tidak ada.
      - `"rb"`: Mode baca biner.
    - **Nilai Kembali:** Jika berhasil, mengembalikan _file handle_ (objek yang merepresentasikan file terbuka). Jika gagal (misalnya, file tidak ditemukan, tidak ada izin), mengembalikan `nil` diikuti dengan string pesan error.
  - **`file_handle:read(...)`** (metode pada file handle)
    - **Sintaks:** `local content = file_handle:read(format_string_atau_angka)`
    - Membaca dari file sesuai format yang diberikan:
      - `"*a"` atau `"*all"`: Membaca seluruh isi file dari posisi saat ini hingga akhir.
      - `"*l"` atau `"*line"`: Membaca baris berikutnya (hingga karakter newline). Karakter newline tidak termasuk dalam string hasil jika file dalam mode teks. Mengembalikan `nil` jika akhir file (EOF) tercapai.
      - `"*n"` atau `"*number"`: Membaca sebuah angka dari file.
      - `angka`: Membaca sejumlah `angka` byte dari file.
    - **Nilai Kembali:** String atau angka yang dibaca, atau `nil` jika EOF atau error.
  - **`file_handle:lines()`** (metode pada file handle)
    - **Sintaks:** `for line in file_handle:lines() do ... end`
    - Mengembalikan sebuah _iterator function_ yang dapat digunakan dalam loop `for` generik untuk membaca file baris per baris. Ini lebih efisien untuk file besar daripada membaca seluruhnya sekaligus.
  - **`file_handle:close()`** (metode pada file handle)
    - **Sintaks:** `local success, error_message = file_handle:close()`
    - Menutup file handle. Penting untuk selalu menutup file setelah selesai digunakan untuk melepaskan sumber daya sistem dan memastikan data tertulis (jika dalam mode tulis).
    - **Nilai Kembali:** `true` jika berhasil, atau `nil` plus pesan error jika gagal.
- **Implementasi dalam Neovim:** Plugin mungkin perlu membaca file konfigurasi kustom, file data, atau source code.
  - **Penting untuk Neovim:** Operasi `io` standar bersifat _blocking_. Untuk plugin Neovim, terutama untuk file besar atau file jaringan, penggunaan fungsi asinkron dari `vim.loop` (misalnya `vim.loop.fs_read`) sangat direkomendasikan untuk menghindari pembekuan UI. Pembahasan `vim.loop` lebih lanjut ada di bagian terkait API Neovim.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (I/O Library): [https://www.lua.org/manual/5.1/manual.html\#5.7](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%235.7)
  - Programming in Lua, 1st ed. (Chapter 21 - The Input/Output Library): [https://www.lua.org/pil/21.html](https://www.lua.org/pil/21.html)

**Contoh Kode (Membaca File):**
Misalkan ada file `data.txt` dengan isi:

```
Baris pertama.
Baris kedua dengan angka: 123
Baris ketiga dan terakhir.
```

File Lua:

```lua
-- file: read_example.lua

local file_path = "data.txt" -- Pastikan file ini ada di direktori yang sama

-- Cara 1: Membaca seluruh isi file
print("--- Membaca seluruh file ---")
-- io.open mengembalikan file handle atau (nil + error_msg)
local file, err_open = io.open(file_path, "r") -- "r" untuk mode baca

if not file then
    print("Error membuka file (baca semua):", err_open)
else
    -- file:read("*a") membaca seluruh isi file dari posisi saat ini.
    local content, err_read = file:read("*a")
    if not content and err_read then
        print("Error membaca file:", err_read)
    else
        print("Isi file:\n" .. (content or ""))
    end
    -- file:close() menutup file handle.
    file:close()
end

-- Cara 2: Membaca file baris per baris menggunakan iterator lines()
print("\n--- Membaca file baris per baris ---")
local file_lines, err_lines_open = io.open(file_path, "r")
if not file_lines then
    print("Error membuka file (baris per baris):", err_lines_open)
else
    print("Membaca baris:")
    local line_num = 1
    -- file:lines() mengembalikan iterator.
    for line in file_lines:lines() do
        -- 'line' berisi satu baris tanpa karakter newline di akhir (biasanya).
        print(string.format("Baris %d: %s", line_num, line))
        line_num = line_num + 1
    end
    file_lines:close()
end

-- Cara 3: Membaca bagian tertentu (misalnya, sejumlah byte atau angka)
-- Ini lebih kompleks dan biasanya untuk format file tertentu.
-- Contoh: membaca baris pertama lalu angka dari baris kedua.
print("\n--- Membaca bagian tertentu ---")
local file_partial, err_partial_open = io.open(file_path, "r")
if not file_partial then
    print("Error membuka file (parsial):", err_partial_open)
else
    local first_line = file_partial:read("*l") -- Baca baris pertama
    print("Baris pertama (parsial):", first_line)

    -- Untuk membaca angka, file harus diposisikan tepat sebelum angka.
    -- Ini hanya contoh sederhana, parsing file bisa rumit.
    -- Biasanya, Anda akan membaca baris lalu mem-parse stringnya.
    -- file_partial:read("*n") -- akan mencoba membaca angka; mungkin gagal jika tidak formatnya.
    -- Sebagai gantinya, mari baca baris kedua dan parse secara manual
    local second_line_str = file_partial:read("*l")
    if second_line_str then
        print("Baris kedua (string):", second_line_str)
        -- Mencari angka dalam string menggunakan string.match (pola regex sederhana)
        local num_in_line = string.match(second_line_str, "%d+") -- %d+ mencari satu atau lebih digit
        if num_in_line then
            print("Angka ditemukan di baris kedua:", tonumber(num_in_line))
        end
    end
    file_partial:close()
end
```

**Cara Menjalankan Kode:**

1.  Buat file `data.txt` di direktori yang sama dengan file Lua Anda, isi dengan teks contoh di atas.
2.  Simpan kode Lua di atas (misalnya sebagai `read_example.lua`).
3.  Jalankan dari terminal: `lua read_example.lua`.

**Penjelasan Kode Keseluruhan (`read_example.lua`):**

- **Cara 1:**
  - `io.open(file_path, "r")`: Membuka `data.txt` dalam mode baca (`"r"`).
  - Pemeriksaan `if not file then ...`: Penanganan error dasar jika file tidak bisa dibuka.
  - `file:read("*a")`: Membaca seluruh isi file.
  - `file:close()`: Menutup file.
- **Cara 2:**
  - Menggunakan `file:lines()` dalam loop `for` untuk membaca file baris per baris. Ini lebih memori-efisien untuk file besar.
- **Cara 3:**
  - Mendemonstrasikan `file:read("*l")` untuk membaca satu baris.
  - Menunjukkan contoh sederhana parsing string (menggunakan `string.match`) untuk mengekstrak angka dari baris, karena `file:read("*n")` memerlukan format angka yang sangat spesifik di file.

#### Writing Files (Menulis File)

- **Deskripsi Konsep:** Menulis file melibatkan pembukaan file dalam mode tulis (atau tambah), menulis data ke dalamnya, dan menutup file. Jika file dibuka dalam mode tulis (`"w"`) dan sudah ada, isinya biasanya akan terhapus (overwrite). Mode tambah (`"a"`) akan menambahkan data di akhir file.
- **Fungsi dan Metode Kunci (`io` library):**
  - **`io.open(filename, mode)`:**
    - Mode umum untuk menulis:
      - `"w"`: Mode tulis. Membuat file baru jika belum ada. Menghapus isi file jika sudah ada.
      - `"a"`: Mode tambah (append). Menulis di akhir file. Membuat file baru jika belum ada.
      - `"wb"`, `"ab"`: Mode tulis/tambah biner.
  - **`file_handle:write(...)`** (metode pada file handle)
    - **Sintaks:** `local success, error_message = file_handle:write(data1, data2, ...)`
    - Menulis argumen (string atau angka) ke file secara berurutan. Angka akan dikonversi menjadi string. Tidak ada pemformatan otomatis (misalnya, spasi atau baris baru) yang ditambahkan di antara argumen; Anda harus menyertakannya secara eksplisit jika diperlukan.
    - **Nilai Kembali:** Mengembalikan file handle itu sendiri jika berhasil, atau `nil` plus pesan error jika gagal.
  - **`file_handle:flush()`** (metode pada file handle)
    - **Sintaks:** `file_handle:flush()`
    - Memaksa penulisan semua data yang masih ada di buffer internal ke file di disk. `close()` juga melakukan flush.
- **Implementasi dalam Neovim:** Plugin mungkin perlu menulis file log, menyimpan konfigurasi yang dihasilkan, atau output dari suatu proses. Sekali lagi, pertimbangkan `vim.loop.fs_write` untuk operasi non-blocking.

**Contoh Kode (Menulis File):**

```lua
-- file: write_example.lua

local output_file_path = "output.txt"
local append_file_path = "append_log.txt"

-- Cara 1: Menulis ke file baru (atau menimpa yang sudah ada)
print("--- Menulis ke file (mode 'w') ---")
-- io.open dengan mode "w" untuk tulis.
local file_w, err_w = io.open(output_file_path, "w")
if not file_w then
    print("Error membuka file untuk tulis:", err_w)
else
    -- file:write() menulis string atau angka ke file.
    local succ_write1, err_write1 = file_w:write("Halo, ini baris pertama yang ditulis Lua.\n")
    if not succ_write1 then print("Error menulis baris 1:", err_write1) end

    local number_to_write = 42
    local succ_write2, err_write2 = file_w:write("Angka favorit saya adalah: ", number_to_write, ".\n")
    if not succ_write2 then print("Error menulis baris 2:", err_write2) end

    -- Menulis beberapa argumen sekaligus
    local succ_write3, err_write3 = file_w:write("Satu", " ", "Dua", " ", "Tiga", "\n")
    if not succ_write3 then print("Error menulis baris 3:", err_write3) end

    print("Data telah ditulis ke", output_file_path)
    file_w:close()
end

-- Cara 2: Menambah ke file (append mode 'a')
print("\n--- Menambah ke file (mode 'a') ---")
local file_a, err_a = io.open(append_file_path, "a") -- "a" untuk mode append
if not file_a then
    print("Error membuka file untuk append:", err_a)
else
    local timestamp = os.date("%Y-%m-%d %H:%M:%S") -- Mendapatkan timestamp saat ini
    file_a:write("[" .. timestamp .. "] Pesan log baru ditambahkan.\n")
    print("Data telah ditambahkan ke", append_file_path)
    file_a:close()
end

-- Untuk melihat hasilnya, periksa file output.txt dan append_log.txt
```

**Cara Menjalankan Kode:**

1.  Simpan kode Lua di atas (misalnya sebagai `write_example.lua`).
2.  Jalankan dari terminal: `lua write_example.lua`.
3.  Periksa isi file `output.txt` dan `append_log.txt` yang akan dibuat/diubah di direktori yang sama.

**Penjelasan Kode Keseluruhan (`write_example.lua`):**

- **Cara 1 (mode `"w"`):**
  - `io.open(output_file_path, "w")`: Membuka `output.txt` dalam mode tulis. Jika file sudah ada, isinya akan dihapus.
  - `file_w:write(...)`: Menulis beberapa baris data, termasuk string dan angka (yang dikonversi ke string). Perhatikan penggunaan `\n` untuk membuat baris baru secara manual.
  - `file_w:close()`: Menutup file, memastikan semua data tertulis ke disk.
- **Cara 2 (mode `"a"`):**
  - `io.open(append_file_path, "a")`: Membuka `append_log.txt` dalam mode tambah. Jika file tidak ada, akan dibuat. Jika ada, data baru akan ditambahkan di akhir.
  - `os.date(...)` digunakan untuk mendapatkan timestamp saat ini.
  - Pesan log dengan timestamp ditulis ke file.

#### Directory Operations (Operasi Direktori)

Lua standar tidak memiliki banyak fungsi bawaan untuk operasi direktori (seperti membuat direktori, mendaftar isi direktori). Untuk ini, pustaka eksternal seperti LuaFileSystem (`lfs`) umum digunakan.

- **LuaFileSystem (`lfs`):**
  - **Deskripsi:** Pustaka C portabel yang menyediakan akses ke sistem file. Ini bukan bagian dari Lua standar dan perlu diinstal secara terpisah jika belum tersedia di lingkungan Lua Anda (Neovim sering menyertakannya atau menyediakan alternatif melalui `vim.loop`).
  - **Cara Instalasi (Umum, mungkin berbeda tergantung sistem):** Menggunakan LuaRocks (manajer paket Lua): `luarocks install luafilesystem`.
  - **Sintaks Per Baris (Fungsi Kunci `lfs`):**
    - `local lfs = require('lfs')`: Memuat pustaka `lfs`.
    - `lfs.attributes(path [, nama_atribut])`: Mengembalikan tabel atribut untuk `path` (file atau direktori). Jika `nama_atribut` diberikan (misalnya, `"mode"`), hanya nilai atribut tersebut yang dikembalikan. Atribut `"mode"` bisa bernilai `"file"`, `"directory"`, `"link"`, dll.
    - `lfs.mkdir(nama_direktori)`: Membuat direktori baru. Mengembalikan `true` jika berhasil, atau `nil` plus pesan error.
    - `lfs.rmdir(nama_direktori)`: Menghapus direktori (biasanya harus kosong).
    - `for entry in lfs.dir(path_direktori) do ... end`: Iterator untuk mendapatkan nama-nama entri (file dan sub-direktori) di dalam `path_direktori`. Mengabaikan `.` dan `..`.
- **Alternatif Neovim (`vim.loop`):**
  - Neovim menyediakan akses ke fungsionalitas libuv melalui `vim.loop`, yang mencakup operasi file dan direktori yang komprehensif dan dapat digunakan secara asinkron.
  - Contoh fungsi `vim.loop`: `fs_stat`, `fs_readdir`, `fs_mkdir`, `fs_rmdir`. Penggunaannya biasanya melibatkan callback atau coroutine untuk operasi non-blocking. Ini adalah cara yang lebih disukai di Neovim.

**Contoh Kode (Menggunakan `lfs`):**

```lua
-- file: lfs_example.lua
-- PENTING: Kode ini memerlukan pustaka LuaFileSystem (lfs).
-- Jika Anda tidak memilikinya, require('lfs') akan gagal.
-- Di Neovim, lfs seringkali sudah tersedia atau bisa menggunakan vim.loop.

-- Coba muat lfs, tangani jika tidak ada
local success_lfs, lfs_or_err = pcall(require, 'lfs')

if not success_lfs then
    print("Error: Pustaka LuaFileSystem (lfs) tidak ditemukan.")
    print("Anda mungkin perlu menginstalnya, misalnya dengan 'luarocks install luafilesystem'")
    print("Jika menggunakan Neovim, pertimbangkan vim.loop untuk operasi direktori.")
else
    local lfs = lfs_or_err -- lfs berhasil dimuat
    print("Pustaka lfs berhasil dimuat.")

    local my_dir = "my_lua_test_dir"
    local my_file_in_dir = my_dir .. "/testfile.txt" -- Path file di dalam direktori

    -- 1. Membuat direktori
    print("\n--- Membuat Direktori ---")
    -- Cek dulu apakah sudah ada
    local dir_attrs = lfs.attributes(my_dir)
    if dir_attrs and dir_attrs.mode == "directory" then
        print("Direktori '" .. my_dir .. "' sudah ada.")
    else
        local success_mkdir, err_mkdir = lfs.mkdir(my_dir)
        if success_mkdir then
            print("Direktori '" .. my_dir .. "' berhasil dibuat.")
        else
            print("Gagal membuat direktori '" .. my_dir .. "':", err_mkdir)
        end
    end

    -- 2. Menulis file di dalam direktori baru (menggunakan io standar)
    if lfs.attributes(my_dir, "mode") == "directory" then
        local file_d, err_d = io.open(my_file_in_dir, "w")
        if file_d then
            file_d:write("Halo dari dalam direktori!\n")
            file_d:close()
            print("File '" .. my_file_in_dir .. "' berhasil ditulis.")
        else
            print("Gagal menulis file di direktori:", err_d)
        end
    end

    -- 3. Mendapatkan atribut path
    print("\n--- Atribut Path ---")
    local attr_dir = lfs.attributes(my_dir)
    if attr_dir then
        print("Atribut untuk '" .. my_dir .. "':")
        for k, v in pairs(attr_dir) do
            print(string.format("  %s: %s", k, tostring(v)))
        end
        print("Mode direktori '" .. my_dir .. "':", lfs.attributes(my_dir, "mode")) -- "directory"
    end

    local attr_file = lfs.attributes(my_file_in_dir)
    if attr_file then
         print("Mode file '" .. my_file_in_dir .. "':", attr_file.mode) -- "file"
    end

    -- 4. Mendaftar isi direktori
    print("\n--- Isi Direktori '" .. my_dir .. "' ---")
    if lfs.attributes(my_dir, "mode") == "directory" then
        -- lfs.dir() mengembalikan iterator.
        for entry in lfs.dir(my_dir) do
            -- 'entry' adalah nama file atau sub-direktori, tanpa path.
            -- Tidak termasuk "." dan "..".
            local entry_path = my_dir .. "/" .. entry
            local entry_mode = lfs.attributes(entry_path, "mode")
            print(string.format("Entri: %s (Tipe: %s)", entry, entry_mode or "unknown"))
        end
    end

    -- 5. Menghapus direktori (opsional, biasanya direktori harus kosong)
    -- Untuk menghapus direktori dengan isi, Anda perlu menghapus isinya dulu.
    -- Hapus file dulu:
    -- os.remove(my_file_in_dir)
    -- local success_rmdir, err_rmdir = lfs.rmdir(my_dir)
    -- if success_rmdir then
    --     print("\nDirektori '" .. my_dir .. "' berhasil dihapus.")
    -- else
    --     print("\nGagal menghapus direktori '" .. my_dir .. "':", err_rmdir or "mungkin tidak kosong")
    -- end
end
```

**Cara Menjalankan Kode (`lfs`):**

1.  Pastikan Anda memiliki LuaFileSystem (`lfs`) terinstal di lingkungan Lua Anda. Jika tidak, `require('lfs')` akan gagal.
2.  Simpan kode di atas dan jalankan dengan `lua lfs_example.lua`.
3.  Amati output dan pembuatan/pemeriksaan direktori `my_lua_test_dir`.

**Penjelasan Kode Keseluruhan (`lfs_example.lua`):**

- `pcall(require, 'lfs')`: Mencoba memuat `lfs` dengan aman. Jika gagal, pesan error akan ditampilkan.
- `lfs.mkdir(my_dir)`: Membuat direktori.
- `lfs.attributes(path, "mode")`: Digunakan untuk memeriksa apakah suatu path adalah direktori atau file.
- `lfs.dir(my_dir)`: Digunakan dalam loop `for` untuk mengiterasi semua entri di dalam direktori `my_dir`.
- Bagian yang dikomentari untuk `lfs.rmdir` menunjukkan cara menghapus direktori (biasanya harus kosong).

---

### 11.2 Menjalankan Perintah OS

Lua menyediakan cara untuk menjalankan perintah eksternal dari sistem operasi.

- **`os.execute(command)`**
  - **Deskripsi:** Menjalankan perintah sistem operasi `command` dan menunggu hingga selesai.
  - **Sintaks:** `local success_or_code, status_string, exit_code = os.execute(perintah_string)`
    - `perintah_string`: String yang berisi perintah yang akan dijalankan oleh shell sistem.
  - **Nilai Kembali:**
    - Jika perintah berhasil dijalankan dan keluar dengan status 0 (sukses di Unix-like), seringkali mengembalikan `true` (di beberapa implementasi Lua) atau `0`.
    - Jika perintah gagal atau keluar dengan status non-nol, bisa mengembalikan `nil` atau `false`, diikuti oleh string yang menjelaskan status (`"exit"` atau `"signal"`) dan kode keluar atau nomor sinyal. Perilaku pastinya bisa sedikit bervariasi antar sistem operasi dan versi Lua.
  - **Penting:** Ini adalah panggilan _blocking_. Skrip Lua akan berhenti dan menunggu perintah selesai.
- **`io.popen(command [, mode])`**
  - **Deskripsi:** Menjalankan `command` sebagai proses terpisah dan membuat _pipe_ (pipa) ke proses tersebut. Anda dapat membaca output dari perintah (jika `mode` adalah `"r"`, default) atau menulis input ke perintah (jika `mode` adalah `"w"`).
  - **Sintaks:** `local file_handle, error_message = io.popen(perintah_string, mode_string)`
    - `perintah_string`: Perintah yang akan dijalankan.
    - `mode_string` (opsional): `"r"` untuk membaca output perintah (default), `"w"` untuk menulis input ke perintah.
  - **Nilai Kembali:** Mengembalikan _file handle_ yang dapat digunakan dengan metode `read`, `lines` (jika mode `"r"`) atau `write` (jika mode `"w"`). Jika gagal memulai perintah, mengembalikan `nil` plus pesan error.
  - **`file_handle:close()` (untuk `io.popen`):** Menutup pipe. Ini juga akan menunggu proses perintah selesai dan mengembalikan status keluar yang mirip dengan `os.execute`.
  - **Penting:** `io.popen` sendiri tidak sepenuhnya blocking untuk _seluruh durasi_ perintah, tetapi operasi baca/tulis pada handle-nya bisa blocking.
- **Alternatif Neovim (`vim.fn.jobstart()`, `vim.loop.spawn()`):**
  - Untuk plugin Neovim, `vim.fn.jobstart()` atau `vim.loop.spawn()` adalah cara yang jauh lebih baik untuk menjalankan proses eksternal. Keduanya menawarkan kontrol asinkron, callback untuk menangani output/error, dan tidak memblokir UI Neovim.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (`os.execute`): [https://www.lua.org/manual/5.1/manual.html\#pdf-os.execute](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%23pdf-os.execute)
  - Lua 5.1 Reference Manual (`io.popen`): [https://www.lua.org/manual/5.1/manual.html\#pdf-io.popen](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%23pdf-io.popen)
  - Programming in Lua, 1st ed. (Chapter 22 - The Operating System Library, covers os.execute and io.popen): [https://www.lua.org/pil/22.html](https://www.lua.org/pil/22.html)

**Contoh Kode:**

```lua
-- file: os_commands_example.lua

print("--- Menggunakan os.execute ---")
-- Perintah sederhana, contoh untuk Unix-like. Di Windows, 'echo' juga ada.
-- 'ls -l' atau 'dir' untuk Windows.
local command_to_run_os_execute
if package.config:sub(1,1) == '\\' then -- Cek sederhana untuk Windows (pemisah path)
    command_to_run_os_execute = "dir /B *.lua" -- Daftar file .lua di Windows
else
    command_to_run_os_execute = "ls -l *.lua" -- Daftar file .lua di Unix-like
end

print("Menjalankan perintah:", command_to_run_os_execute)
-- os.execute() akan mencetak output perintah langsung ke stdout skrip ini.
local success_code, status_str, exit_code_val = os.execute(command_to_run_os_execute)

-- Interpretasi hasil os.execute bisa sedikit rumit dan bervariasi.
-- Seringkali, jika berhasil dan exit code 0, success_code bisa true atau 0.
if success_code == true or success_code == 0 then
    print("os.execute berhasil (atau exit code 0).")
    if status_str then -- Jika ada detail tambahan
        print("Status:", status_str, "Kode Keluar:", exit_code_val)
    end
else
    print("os.execute mungkin gagal atau exit code non-nol.")
    print("Hasil:", success_code, status_str, exit_code_val)
end

print("\n--- Menggunakan io.popen untuk membaca output perintah ---")
-- 'date' di Unix-like, 'echo %DATE% %TIME%' atau 'powershell Get-Date' di Windows.
local command_to_run_io_popen
if package.config:sub(1,1) == '\\' then
    command_to_run_io_popen = "powershell Get-Date -Format G"
else
    command_to_run_io_popen = "date"
end

print("Menjalankan perintah dengan io.popen:", command_to_run_io_popen)
-- io.popen() membuka pipe ke perintah. Mode "r" (default) untuk membaca output.
local pipe, err_popen = io.popen(command_to_run_io_popen, "r")

if not pipe then
    print("Error menjalankan io.popen:", err_popen)
else
    -- Membaca seluruh output dari pipe.
    local output = pipe:read("*a")
    pipe:close() -- Penting untuk menutup pipe; ini juga menunggu perintah selesai.
    print("Output dari '" .. command_to_run_io_popen .. "':\n" .. (output or ""))
end

-- Contoh io.popen untuk perintah yang menghasilkan banyak baris
local list_files_command
if package.config:sub(1,1) == '\\' then
    list_files_command = "dir /B" -- Daftar nama file/folder di Windows
else
    list_files_command = "ls -a" -- Daftar nama file/folder di Unix (termasuk hidden)
end

print("\n--- Membaca output baris per baris dari io.popen ---")
local pipe_ls, err_ls = io.popen(list_files_command)
if not pipe_ls then
    print("Error menjalankan io.popen untuk list files:", err_ls)
else
    print("Isi direktori saat ini (dari '".. list_files_command .."'):")
    for line in pipe_ls:lines() do
        print("  " .. line)
    end
    -- Status close() dari popen bisa dicek
    local ok, stat, code = pipe_ls:close()
    if ok then
      print("Perintah popen ("..list_files_command..") selesai. Status:", stat, "Kode:", code)
    else
      print("Perintah popen ("..list_files_command..") error saat close. Status:", stat, "Kode:", code)
    end
end
```

**Cara Menjalankan Kode:**

1.  Simpan kode Lua di atas.
2.  Jalankan dari terminal: `lua os_commands_example.lua`.
3.  Output akan bervariasi tergantung sistem operasi Anda (perintah `ls` vs `dir`, `date` vs `powershell Get-Date`).

**Penjelasan Kode Keseluruhan:**

- **`os.execute(...)`:** Menjalankan perintah `ls -l *.lua` (Unix) atau `dir /B *.lua` (Windows). Output dari perintah ini akan langsung tercetak ke konsol tempat skrip Lua dijalankan. Hasil `os.execute` kemudian dicetak.
- **`io.popen(..., "r")`:**
  - Pertama, menjalankan `date` (Unix) atau `powershell Get-Date` (Windows) dan outputnya dibaca seluruhnya menggunakan `pipe:read("*a")`.
  - Kedua, menjalankan `ls -a` (Unix) atau `dir /B` (Windows) dan outputnya dibaca baris per baris menggunakan iterator `pipe_ls:lines()`.
  - `pipe:close()` sangat penting untuk `io.popen` karena ia menunggu proses selesai dan mengembalikan status keluarannya.

---

### 11.3 Variabel Lingkungan (Environment Variables)

Lua dapat mengakses variabel lingkungan sistem operasi.

- **`os.getenv(varname)`**
  - **Deskripsi:** Mengambil nilai dari variabel lingkungan yang bernama `varname`.
  - **Sintaks:** `local value = os.getenv(nama_variabel_string)`
    - `nama_variabel_string`: Nama variabel lingkungan (case-sensitive pada beberapa sistem).
  - **Nilai Kembali:** String yang berisi nilai variabel lingkungan, atau `nil` jika variabel tersebut tidak terdefinisi.
- **Implementasi dalam Neovim:** Plugin mungkin perlu mengakses variabel lingkungan untuk konfigurasi (misalnya, path ke alat eksternal, token API) atau untuk menyesuaikan perilaku berdasarkan lingkungan pengguna.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (`os.getenv`): [https://www.lua.org/manual/5.1/manual.html\#pdf-os.getenv](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%23pdf-os.getenv)
  - Programming in Lua, 1st ed. (Chapter 22.1 - Running System Commands, mentions getenv): [https://www.lua.org/pil/22.1.html](https://www.lua.org/pil/22.1.html)

**Contoh Kode:**

```lua
-- file: env_vars_example.lua

print("--- Mengakses Variabel Lingkungan ---")

-- Mencoba mendapatkan beberapa variabel lingkungan umum
-- Nama variabel bisa berbeda antar OS.
local path_var = os.getenv("PATH")
if path_var then
    -- PATH bisa sangat panjang, jadi kita hanya cetak sebagian atau statusnya
    print("Variabel PATH ditemukan (panjang: " .. string.len(path_var) .. ").")
    -- print("PATH:", path_var) -- Hati-hati, bisa sangat panjang
else
    print("Variabel PATH tidak ditemukan.")
end

local home_var -- Nama bisa HOME (Unix) atau USERPROFILE (Windows)
if package.config:sub(1,1) == '\\' then -- Windows
    home_var = os.getenv("USERPROFILE")
    if not home_var then home_var = os.getenv("HOMEDRIVE") .. os.getenv("HOMEPATH") end
else -- Unix-like
    home_var = os.getenv("HOME")
end

if home_var then
    print("Variabel HOME/USERPROFILE ditemukan:", home_var)
else
    print("Variabel HOME/USERPROFILE tidak ditemukan.")
end

local user_var = os.getenv("USER") or os.getenv("USERNAME") -- USER di Unix, USERNAME di Windows
if user_var then
    print("Variabel USER/USERNAME ditemukan:", user_var)
else
    print("Variabel USER/USERNAME tidak ditemukan.")
end

-- Mengakses variabel yang mungkin tidak ada
local non_existent_var = os.getenv("MY_CUSTOM_NON_EXISTENT_VAR_12345")
if non_existent_var then
    print("Variabel kustom ditemukan:", non_existent_var)
else
    print("Variabel kustom 'MY_CUSTOM_NON_EXISTENT_VAR_12345' tidak ditemukan (ini diharapkan).")
end
```

**Cara Menjalankan Kode:**

1.  Simpan kode Lua di atas.
2.  Jalankan dari terminal: `lua env_vars_example.lua`.
3.  Output akan menampilkan nilai variabel lingkungan yang ada di sistem Anda.

**Penjelasan Kode Keseluruhan:**

- Kode ini menggunakan `os.getenv` untuk mencoba mengambil nilai dari beberapa variabel lingkungan umum seperti `PATH`, `HOME` (atau `USERPROFILE` di Windows), dan `USER` (atau `USERNAME`).
- Ia mencetak nilai variabel jika ditemukan, atau pesan bahwa variabel tidak ditemukan.
- Juga mencoba mengakses variabel yang kemungkinan besar tidak ada untuk menunjukkan bahwa `os.getenv` akan mengembalikan `nil` dalam kasus tersebut.

---

Interaksi dengan sistem file dan OS adalah kemampuan dasar yang penting. Namun, selalu ingat bahwa operasi I/O dan pemanggilan proses eksternal yang bersifat _blocking_ dapat berdampak negatif pada responsivitas plugin Neovim. Oleh karena itu, dalam konteks Neovim, sangat disarankan untuk mempelajari dan menggunakan API asinkron yang disediakan (seperti `vim.loop`) jika memungkinkan.

> - **[Ke Atas](#)**
> - **[Selanjutnya][4]**
> - **[Sebelumnya][3]**
> - **[Kurikulum][2]**
> - **[Domain Spesifik][5]**

[5]: ../../../../../../../README.md
[4]: ../12-lua-performance-best-practices/README.md
[3]: ../10-metatables/README.md
[2]: ../../../../../README.md
[1]: ../../README.md
