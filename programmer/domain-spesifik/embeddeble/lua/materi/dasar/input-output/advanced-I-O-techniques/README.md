# **[7. Advanced I/O Techniques][0]**

Teknik-teknik ini penting ketika Anda berhadapan dengan file yang bukan sekadar teks biasa, file yang ukurannya sangat besar, atau ketika Anda perlu mengelola beberapa file dan direktori sekaligus.

_(Catatan: Sama seperti bagian sebelumnya, kurikulum Anda tidak menyertakan sumber referensi spesifik untuk bagian ini. Penjelasan berikut didasarkan pada pustaka `io`, `string`, dan `os` standar Lua. Untuk fungsionalitas yang tidak ada di pustaka standar, seperti operasi direktori, akan disebutkan pustaka eksternal yang umum digunakan.)_

### 7.1 Binary File Operations

**Deskripsi Konkret:**
Tidak semua file berisi teks yang bisa dibaca manusia. Banyak format file—seperti gambar (JPEG, PNG), audio (MP3), video, atau data terstruktur kustom—disimpan dalam format **biner**, yaitu sebagai serangkaian byte mentah. Membaca dan menulis file-file ini memerlukan penanganan khusus untuk memastikan setiap byte diperlakukan sebagaimana mestinya, tanpa ada translasi karakter yang tidak diinginkan.

**Membaca dan menulis binary data:**

- **Kunci Utama**: Selalu buka file dalam **mode biner** dengan menambahkan `b` ke string mode pada `io.open()`.
  - **Baca Biner**: `"rb"` (read binary)
  - **Tulis Biner**: `"wb"` (write binary)
  - **Tambah Biner**: `"ab"` (append binary)
  - **Kombinasi**: `"r+b"`, `"w+b"`, `"a+b"`
- **Mengapa Mode Biner Penting?**: Pada beberapa sistem operasi (terutama Windows), mode teks secara otomatis mengubah karakter _newline_ (`\n`, byte 10) menjadi pasangan _carriage return + line feed_ (`\r\n`, byte 13 dan 10) saat menulis, dan sebaliknya saat membaca. Ini akan merusak file biner yang mungkin saja memiliki byte dengan nilai 10 atau 13 sebagai bagian dari datanya. Mode biner menonaktifkan semua translasi otomatis ini, memastikan data yang Anda baca atau tulis adalah byte-for-byte identik dengan yang ada di file.

**Byte manipulation:**
Setelah Anda membaca data biner ke dalam sebuah string Lua, Anda dapat memanipulasinya di level byte menggunakan dua fungsi `string` yang sangat penting:

- **`string.byte(s, [i], [j])`**:
  - Mengambil string `s` dan mengembalikan nilai numerik (0-255) dari byte pada posisi `i` hingga `j`.
  - Jika `i` dan `j` tidak disertakan, ia mengembalikan nilai byte pertama.
  - **Contoh**: `string.byte("ABC", 1)` akan mengembalikan `65` (kode ASCII untuk 'A').
- **`string.char(...)`**:
  - Melakukan kebalikannya: mengambil satu atau lebih argumen numerik (0-255) dan mengembalikannya sebagai string yang terdiri dari byte-byte tersebut.
  - **Contoh**: `string.char(65, 66, 67)` akan mengembalikan string `"ABC"`.

**Endianness considerations:**

- **Konsep**: Ini adalah topik yang sangat penting namun sering diabaikan saat menangani data biner. _Endianness_ merujuk pada urutan di mana byte-byte dari sebuah tipe data multi-byte (seperti integer 16-bit atau 32-bit) disimpan dalam memori atau file.
  - **Big-Endian**: Byte yang paling signifikan (Most Significant Byte - MSB) disimpan terlebih dahulu. Ini seperti cara kita menulis angka: digit ratusan datang sebelum puluhan. Contoh: Angka `4660` (atau `0x1234` dalam heksadesimal) akan disimpan sebagai `12` lalu `34`.
  - **Little-Endian**: Byte yang paling tidak signifikan (Least Significant Byte - LSB) disimpan terlebih dahulu. Contoh: Angka `4660` akan disimpan sebagai `34` lalu `12`.
- **Masalah**: Arsitektur prosesor yang berbeda menggunakan endianness yang berbeda (misalnya, x86/x64 adalah Little-Endian, sementara banyak arsitektur jaringan dan prosesor lama adalah Big-Endian). Jika Anda membaca data biner yang ditulis pada sistem dengan endianness berbeda tanpa menanganinya, Anda akan mendapatkan nilai yang salah.
- **Penanganan di Lua**: Pustaka standar Lua **tidak memiliki dukungan bawaan** untuk konversi endianness. Anda harus melakukannya secara manual menggunakan operasi bitwise (di Lua 5.3+) atau manipulasi byte dengan `string.byte/char` dan matematika. Untuk aplikasi yang serius, sangat disarankan menggunakan pustaka eksternal seperti `lua-pack`.

**Contoh Kode (`binary_io.lua`):**

```lua
-- 1. Menulis data biner
function tulisStructBiner(filename, id, value)
    local file, err = io.open(filename, "wb") -- Mode 'write binary'
    if not file then return nil, err end

    -- Kita akan menulis:
    -- - ID (2 byte, Little-Endian)
    -- - Value (4 byte, Little-Endian)

    -- Konversi ID (misal: 258 atau 0x0102) ke 2 byte Little-Endian (02 01)
    local id_byte2 = math.floor(id / 256) -- MSB (01)
    local id_byte1 = id % 256          -- LSB (02)

    -- Konversi Value (misal: 66051 atau 0x010203) ke 3 byte Little-Endian (03 02 01)
    -- Untuk sederhana, anggap value hanya 3 byte
    local val_byte3 = math.floor(value / 65536)
    local val_byte2 = math.floor((value % 65536) / 256)
    local val_byte1 = value % 256

    -- Buat string biner
    local binary_string = string.char(id_byte1, id_byte2, val_byte1, val_byte2, val_byte3)
    -- Penjelasan Sintaks string.char():
    -- string.char(...): Membuat string dari nilai-nilai byte. Urutan penting!
    --                  Kita menempatkan byte LSB terlebih dahulu untuk Little-Endian.

    file:write(binary_string)
    file:close()
    print("File biner '" .. filename .. "' berhasil ditulis.")
    return true
end

-- 2. Membaca data biner
function bacaStructBiner(filename)
    local file, err = io.open(filename, "rb") -- Mode 'read binary'
    if not file then return nil, err end

    local data = file:read(5) -- Baca 5 byte yang kita tulis
    file:close()

    if not data or #data < 5 then
        return nil, "Gagal membaca 5 byte dari file."
    end

    -- Ekstrak byte-byte menggunakan string.byte
    -- Penjelasan Sintaks string.byte():
    -- string.byte(data, 1, 5): Mengambil nilai numerik dari byte 1 hingga 5 dari string 'data'.
    local b1, b2, b3, b4, b5 = string.byte(data, 1, 5)

    -- Rekonstruksi nilai dengan asumsi Little-Endian
    local id = b1 + (b2 * 256) -- LSB + (MSB * 256)
    local value = b3 + (b4 * 256) + (b5 * 65536)

    return {id=id, value=value}
end

-- --- Jalankan Demo ---
local target_file = "data.bin"
tulisStructBiner(target_file, 258, 66051)

local hasil_baca = bacaStructBiner(target_file)
if hasil_baca then
    print("\nData yang dibaca dari file biner:")
    print("ID:", hasil_baca.id)     -- Seharusnya 258
    print("Value:", hasil_baca.value) -- Seharusnya 66051
else
    print("Gagal membaca file biner.")
end

-- Membersihkan file
os.remove(target_file)
```

**Penjelasan Kode**:

- **`tulisStructBiner`**:
  - Membuka file dalam mode `"wb"` yang krusial.
  - Melakukan matematika sederhana untuk memecah angka `id` dan `value` menjadi byte-byte individual.
  - Menggunakan `string.char()` untuk merakit byte-byte ini menjadi sebuah string. Perhatikan urutan perakitan (`id_byte1, id_byte2`) yang sengaja dibuat Little-Endian.
  - Menulis string biner ini ke file.
- **`bacaStructBiner`**:
  - Membuka file dalam mode `"rb"`.
  - Membaca jumlah byte yang pasti (5 byte).
  - Menggunakan `string.byte()` untuk mengubah string biner yang dibaca kembali menjadi nilai-nilai numerik.
  - Melakukan matematika terbalik untuk merekonstruksi angka `id` dan `value` dari byte-byte tersebut, dengan asumsi format Little-Endian. `id = b1 + (b2 * 256)` adalah cara manual untuk membaca integer 16-bit Little-Endian.

---

### 7.2 Large File Handling

**Deskripsi Konkret:**
Bagaimana jika Anda perlu memproses file log sebesar 10 GB? Anda tidak bisa begitu saja menggunakan `file:read("*a")`, karena itu akan mencoba memuat seluruh 10 GB ke dalam RAM, yang kemungkinan besar akan menyebabkan program Anda crash karena kehabisan memori. Solusinya adalah dengan memproses file secara bertahap atau per potongan (_chunk_).

**Streaming large files / Memory-efficient reading:**

- **Konsep**: _Streaming_ adalah praktik membaca dan memproses file dalam potongan-potongan kecil yang ukurannya bisa diatur. Ini memastikan bahwa penggunaan memori program Anda tetap rendah dan konstan, tidak peduli seberapa besar ukuran file totalnya.

**Chunked processing:**

- **Pola Implementasi**: Pola yang paling umum untuk ini adalah menggunakan loop `while` yang terus membaca potongan data dengan ukuran tetap (misalnya, 4096 byte atau 8 KB) sampai `file:read()` mengembalikan `nil`, yang menandakan akhir file (End-Of-File).
- **Ukuran Chunk**: Ukuran chunk yang baik biasanya adalah kelipatan dari ukuran blok sistem file, seperti `4096` (4KB) atau `8192` (8KB). Ini seringkali memberikan performa I/O terbaik.

**Contoh Kode (`large_file_handler.lua`):**

```lua
-- Fungsi untuk memproses file besar secara efisien
function prosesFileBesar(filename)
    local file, err = io.open(filename, "rb") -- Mode biner seringkali lebih baik untuk ini
    if not file then
        return false, err
    end

    local chunk_size = 8192 -- Baca 8KB per potongan
    local total_bytes_processed = 0
    local line_count = 0 -- Contoh: kita akan hitung jumlah baris di file besar

    while true do
        local chunk = file:read(chunk_size)
        -- Penjelasan Sintaks file:read(chunk_size):
        -- file:read(): Membaca dari file handle.
        -- chunk_size: Jumlah byte yang akan dibaca.
        --             Jika sisa file lebih kecil dari chunk_size, ia akan membaca sisa tersebut.
        --             Jika sudah di akhir file, ia akan mengembalikan nil.

        if not chunk then
            break -- Keluar dari loop jika sudah tidak ada data (EOF)
        end

        total_bytes_processed = total_bytes_processed + #chunk

        -- Contoh pemrosesan chunk: menghitung karakter newline
        -- string.gmatch(chunk, "\n") mengembalikan iterator untuk setiap newline
        for _ in string.gmatch(chunk, "\n") do
            line_count = line_count + 1
        end

        -- Beri tanda kemajuan agar tidak terlihat hang
        io.write(string.format("\rMemproses... %.2f MB", total_bytes_processed / (1024*1024)))
        io.stdout:flush()
    end

    io.write("\nSelesai!\n")
    file:close()

    return {bytes = total_bytes_processed, lines = line_count}
end

-- --- Jalankan Demo ---
-- Membuat file dummy yang "besar" untuk diuji
print("Membuat file dummy 'large_dummy_file.txt'...")
local dummy_file, err_dummy = io.open("large_dummy_file.txt", "w")
if not dummy_file then
    io.stderr:write("Gagal membuat file dummy: "..(err_dummy or "").."\n")
else
    for i = 1, 50000 do
        dummy_file:write(string.format("Ini adalah baris nomor %d di file yang sangat besar.\n", i))
    end
    dummy_file:close()
end
print("File dummy dibuat.")

-- Proses file besar tersebut
local stats = prosesFileBesar("large_dummy_file.txt")
if stats then
    print(string.format("Total byte diproses: %d", stats.bytes))
    print(string.format("Total baris dihitung: %d", stats.lines))
else
    print("Gagal memproses file.")
end

-- Membersihkan
os.remove("large_dummy_file.txt")
```

**Penjelasan Kode**:

- **`while true do ... end`**: Membuat loop tak terbatas yang akan kita hentikan secara manual.
- **`local chunk = file:read(chunk_size)`**: Ini adalah inti dari teknik ini. Pada setiap iterasi, ia membaca maksimal `chunk_size` byte.
- **`if not chunk then break end`**: Jika `file:read()` mengembalikan `nil`, itu berarti kita telah mencapai akhir file, dan kita keluar dari loop menggunakan `break`.
- **Pemrosesan `chunk`**: Di dalam loop, Anda melakukan apa pun yang perlu Anda lakukan dengan potongan data tersebut. Dalam contoh ini, kita menghitung total byte dan mencari jumlah karakter newline (`\n`) untuk mengestimasi jumlah baris.
- **Penggunaan Memori**: Perhatikan bahwa variabel `chunk` akan digunakan kembali di setiap iterasi. Ini berarti penggunaan memori program hanya sebesar `chunk_size` (plus sedikit overhead), tidak peduli seberapa besar file aslinya.
- **`io.write("\r...")`**: Ini adalah trik konsol untuk menampilkan progress. Karakter `\r` (carriage return) mengembalikan kursor ke awal baris tanpa pindah ke baris baru, sehingga output berikutnya akan menimpa output progress sebelumnya. `io.stdout:flush()` memastikan progress ini langsung terlihat.

---

### 7.3 Multiple File Operations

**Deskripsi Konkret:**
Banyak tugas di dunia nyata melibatkan lebih dari satu file. Anda mungkin perlu menggabungkan beberapa file, menyalin file dari satu tempat ke tempat lain, atau mengelola struktur direktori.

**Membaca dari multiple files simultaneously:**
Tidak ada sihir di sini. Anda cukup membuka semua file yang Anda butuhkan, yang masing-masing akan memberi Anda file handle unik. Kemudian, dalam logika program Anda, Anda dapat membaca dari handle mana pun sesuai kebutuhan.

**File copying dan moving:**

- **Menyalin (Copying)**: Lua tidak memiliki fungsi `io.copy()`. Anda harus mengimplementasikannya sendiri. Caranya adalah dengan menggabungkan teknik yang telah kita pelajari:
  1.  Buka file sumber dalam mode baca biner (`"rb"`).
  2.  Buka file tujuan dalam mode tulis biner (`"wb"`).
  3.  Baca file sumber per potongan (chunked processing untuk efisiensi memori).
  4.  Tulis setiap potongan yang dibaca ke file tujuan.
  5.  Tutup kedua file.
- **Memindahkan (Moving/Renaming)**: Untuk memindahkan atau mengganti nama file, pustaka `os` standar menyediakan fungsi yang efisien:
  - **`os.rename(oldname, newname)`**: Mengganti nama `oldname` menjadi `newname`. Jika `oldname` dan `newname` berada di filesystem (drive) yang sama, ini adalah operasi yang sangat cepat. Jika berada di filesystem yang berbeda, perilakunya mungkin gagal atau bervariasi tergantung sistem operasi.
  - **Memindahkan Antar Filesystem**: Cara yang paling portabel untuk memindahkan file antar drive/filesystem adalah dengan menyalin file ke tujuan baru, lalu menghapus file sumbernya menggunakan `os.remove(oldname)`.

**Directory operations:**
Ini adalah kelemahan signifikan dari pustaka standar Lua. **Pustaka `io` dan `os` standar tidak memiliki fungsi untuk:**

- Membuat direktori (`mkdir`).
- Menghapus direktori (`rmdir`).
- Mendapatkan daftar isi direktori (`ls` atau `dir`).

Untuk melakukan operasi ini, komunitas Lua secara universal menggunakan pustaka eksternal bernama **LuaFileSystem (LFS)**. Jika Anda perlu melakukan operasi direktori, Anda harus menginstal LFS dan memuatnya dengan `local lfs = require("lfs")`.

**Contoh Kode (`multi_file_ops.lua`):**

```lua
-- Fungsi untuk menyalin file
function copyFile(source, destination)
    print(string.format("Menyalin '%s' ke '%s'...", source, destination))
    local f_source, err_s = io.open(source, "rb")
    if not f_source then return false, "Gagal membuka sumber: " .. (err_s or "") end

    local f_dest, err_d = io.open(destination, "wb")
    if not f_dest then
        f_source:close() -- Jangan lupa tutup file sumber jika tujuan gagal dibuka
        return false, "Gagal membuka tujuan: " .. (err_d or "")
    end

    local chunk_size = 8192
    while true do
        local chunk = f_source:read(chunk_size)
        if not chunk then break end

        local ok, write_err = f_dest:write(chunk)
        if not ok then
            f_source:close()
            f_dest:close()
            return false, "Gagal menulis ke tujuan: " .. (write_err or "")
        end
    end

    f_source:close()
    f_dest:close()
    print("Salin selesai.")
    return true
end

-- --- Jalankan Demo ---
-- 1. Membuat file sumber untuk disalin
local file_sumber, _ = io.open("sumber.txt", "w")
file_sumber:write("Ini adalah konten dari file sumber.\n")
file_sumber:close()

-- 2. Menyalin file
copyFile("sumber.txt", "tujuan.txt")

-- 3. Memindahkan/Mengganti nama file
print("\nMengganti nama 'tujuan.txt' menjadi 'arsip.txt'...")
local ok_rename, err_rename = os.rename("tujuan.txt", "arsip.txt")
-- Penjelasan Sintaks os.rename():
-- os.rename(old, new): Memanggil fungsi 'rename' dari pustaka 'os'.
-- ok_rename: Akan 'true' jika berhasil, 'nil' jika gagal.
-- err_rename: Pesan error jika gagal.
if not ok_rename then
    io.stderr:write("Gagal mengganti nama: " .. (err_rename or "") .. "\n")
else
    print("Berhasil mengganti nama.")
end

-- 4. Operasi Direktori (dengan LuaFileSystem - LFS, sebagai CONTOH)
-- PENTING: Kode berikut HANYA akan berfungsi jika Anda memiliki LFS terinstal.
-- Ini untuk tujuan ilustrasi.
print("\n--- Contoh Operasi Direktori (membutuhkan LFS) ---")
local status_lfs, lfs = pcall(require, "lfs")
if not status_lfs then
    print("Pustaka LuaFileSystem (LFS) tidak ditemukan. Melewatkan contoh direktori.")
else
    print("LFS ditemukan. Melanjutkan contoh direktori.")
    local dir_name = "test_dir"
    print("Membuat direktori:", dir_name)
    lfs.mkdir(dir_name)

    print("Atribut dari 'arsip.txt':")
    for key, val in pairs(lfs.attributes("arsip.txt")) do
        print(string.format("  %s: %s", key, tostring(val)))
    end

    -- Pindahkan file ke direktori baru
    lfs.rename("arsip.txt", dir_name .. "/arsip.txt")
    print("Memindahkan 'arsip.txt' ke dalam 'test_dir'.")

    print("Isi dari direktori '"..dir_name.."':")
    for file in lfs.dir(dir_name) do
        if file ~= "." and file ~= ".." then
            print(" - " .. file)
        end
    end

    -- Membersihkan direktori (hapus file dulu, baru direktori)
    os.remove(dir_name .. "/arsip.txt")
    lfs.rmdir(dir_name)
    print("Direktori 'test_dir' telah dihapus.")
end

-- Membersihkan file awal
os.remove("sumber.txt")
-- os.remove("tujuan.txt") -- sudah di-rename
if lfs then -- jika lfs tidak ada, arsip.txt mungkin masih ada
    local f_check = io.open("arsip.txt", "r")
    if f_check then
        f_check:close()
        os.remove("arsip.txt")
    end
end
```

**Penjelasan Kode**:

- **`copyFile`**: Ini adalah implementasi textbook dari fungsi penyalinan file yang efisien dan aman. Ia menggunakan mode biner (`rb`/`wb`), pemrosesan per potongan, dan penanganan error yang baik (misalnya, memastikan file sumber ditutup jika file tujuan gagal dibuka).
- **`os.rename`**: Mendemonstrasikan cara yang benar dan sederhana untuk mengganti nama atau memindahkan file.
- **Contoh LFS**: Blok `if status_lfs then ... end` menunjukkan bagaimana Anda akan menggunakan LFS jika tersedia. Ia dengan aman mencoba memuat pustaka menggunakan `pcall(require, "lfs")`. Jika berhasil, ia menunjukkan cara membuat direktori (`lfs.mkdir`), mendapatkan atribut file (`lfs.attributes`), dan mendaftar isi direktori (`lfs.dir`). Ini melengkapi kurikulum dengan menunjukkan solusi standar untuk keterbatasan bawaan Lua.

Dengan teknik-teknik canggih ini, Anda siap untuk menangani hampir semua tugas I/O yang mungkin Anda hadapi, dari format data biner yang rumit hingga pemrosesan file berukuran besar dan pengelolaan struktur file yang kompleks.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../pattern-dan-format-I-O/README.md
[selanjutnya]: ../I-O-dengan-external-systems/README.md

<!----------------------------------------------------->

[0]: ../../input-output/README.md#7-advanced-io-techniques
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
