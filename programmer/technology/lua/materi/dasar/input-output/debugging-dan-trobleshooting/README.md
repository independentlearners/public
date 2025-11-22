# **[13. Advanced Topics II][0]**

Bagian ini membahas topik-topik yang lebih terspesialisasi namun sangat penting untuk aplikasi modern, seperti mengubah kode dan data menjadi format yang dapat disimpan, menangani berbagai set karakter, dan berinteraksi dengan metadata sistem file.

#

### 13.1 Serialization

**Deskripsi Konkret:**
Serialisasi (_serialization_) adalah proses mengubah struktur data atau state objek (seperti tabel atau fungsi di Lua) menjadi format (biasanya string atau urutan byte) yang dapat disimpan ke dalam file atau dikirim melalui jaringan. Data yang telah diserialisasi ini nantinya dapat "dibangkitkan" kembali (deserialisasi) ke bentuk aslinya.

**`string.dump` untuk Lua functions:**

- **Konsep**: Ini adalah fitur unik dan kuat di Lua. `string.dump` melakukan serialisasi pada sebuah **fungsi Lua**, mengubahnya menjadi representasi biner dari _bytecode_ fungsi tersebut. Ini pada dasarnya adalah fungsi yang sudah "di-precompile".
- **Kegunaan**:
  - **Mempercepat Pemuatan**: Memuat bytecode yang sudah dikompilasi (menggunakan `load()`) jauh lebih cepat daripada memuat file teks `.lua` dan mem-parsingnya saat runtime.
  - **Menyembunyikan Kode Sumber**: Anda dapat mendistribusikan file bytecode tanpa harus menyertakan kode sumber `.lua` aslinya.
- **Penting**: `string.dump` hanya menserialisasi _definisi_ fungsi. Ia **tidak** menyimpan _upvalues_ (variabel lokal dari lingkup luar yang digunakan oleh fungsi tersebut), kecuali untuk upvalue yang nilainya juga merupakan fungsi global.
- **Sintaks**: `local binaryChunk = string.dump(myFunction, stripDebugInfo)`
  - `myFunction`: Fungsi Lua yang akan diserialisasi.
  - `stripDebugInfo` (opsional, boolean): Jika `true`, informasi debug (seperti nomor baris dan nama variabel lokal) akan dihapus dari bytecode untuk memperkecil ukuran.

**Contoh `string.dump` dan `load()`:**

```lua
-- Fungsi yang akan kita serialisasi
local function tambah(a, b)
    local hasil = a + b
    print("Menjalankan fungsi 'tambah', hasil:", hasil)
    return hasil
end

-- 1. Serialisasi fungsi ke bytecode
local dumped_function = string.dump(tambah)
print("Fungsi telah di-dump menjadi " .. #dumped_function .. " byte bytecode.")

-- 2. Simpan bytecode ke file
local file, err = io.open("fungsi.luac", "wb") -- 'c' untuk compiled
if file then
    file:write(dumped_function)
    file:close()
else
    error("Gagal menyimpan bytecode: " .. (err or ""))
end

-- 3. Muat dan jalankan bytecode dari file
local file_read, err_read = io.open("fungsi.luac", "rb")
if file_read then
    local bytecode_dari_file = file_read:read("*a")
    file_read:close()

    -- load() melakukan deserialisasi
    local fungsi_bangkit, err_load = load(bytecode_dari_file)
    if fungsi_bangkit then
        print("\nFungsi berhasil di-load dari bytecode.")
        -- Jalankan fungsi yang telah dibangkitkan
        fungsi_bangkit(10, 20)
    else
        error("Gagal me-load bytecode: " .. (err_load or ""))
    end
end

os.remove("fungsi.luac")
```

**Creating custom serialization formats:**

- **Konsep**: Ini adalah tentang serialisasi **data**, bukan kode. Tugas yang paling umum adalah mengubah sebuah tabel Lua menjadi string yang, jika dieksekusi sebagai kode Lua, akan menghasilkan kembali tabel tersebut. Ini adalah cara yang sangat sederhana dan kuat untuk menyimpan data konfigurasi atau state.
- **Strategi**: Buat fungsi yang mengiterasi tabel secara rekursif dan membangun string yang merepresentasikan tabel tersebut, misalnya `"return { key = \"value\", list = { 1, 2, 3 } }"`.

**Interfacing with standard formats (XML, JSON, etc):**

- **Konsep**: Untuk format standar industri seperti JSON atau XML, jangan mencoba membuat parser Anda sendiri dari awal. Itu sangat rumit. Selalu gunakan pustaka yang sudah teruji.
- **JSON**: Gunakan `dkjson` atau `lua-cjson`.
  - `json.encode(myTable)`: Serialisasi tabel Lua menjadi string JSON.
  - `json.decode(jsonString)`: Deserialisasi string JSON menjadi tabel Lua.
- **XML**: Gunakan pustaka berbasis SAX atau DOM seperti `LuaExpat`.

**Sumber Referensi:**

- [Programming in Lua: `string.dump`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/pil/8.2.html%5D(https://www.lua.org/pil/8.2.html)>)

---

### 13.2 Character Encoding

**Deskripsi Konkret:**
_Encoding_ karakter adalah aturan yang memetakan karakter (seperti 'A', '€', '✓', 'あ') ke dalam urutan byte tertentu. Lua secara internal "agnostik" terhadap encoding; ia memperlakukan string sebagai urutan byte. Ini menjadi penting saat Anda bekerja dengan teks yang mengandung karakter di luar set ASCII standar, yang umum di dunia modern.

**UTF-8 and other encodings:**

- **ASCII**: Encoding lama yang hanya mendukung 128 karakter (Inggris dasar). Setiap karakter adalah 1 byte.
- **UTF-8**: Standar modern yang dominan. Ia dapat merepresentasikan setiap karakter Unicode.
  - Karakter ASCII tetap 1 byte, membuatnya kompatibel mundur.
  - Karakter non-ASCII menggunakan 2 hingga 4 byte.
  - Ini berarti panjang string dalam byte **tidak sama** dengan panjang string dalam karakter.

**Handling encoding in I/O:**
Saat Anda membaca file yang di-encode dalam UTF-8, string Lua Anda akan berisi urutan byte UTF-8. Masalah muncul saat Anda mencoba memanipulasinya dengan fungsi `string` standar:

- `string.len(s)` atau `#s`: Memberikan jumlah **byte**, bukan jumlah karakter.
- `string.sub(s, i, j)`: Mengekstrak substring berdasarkan posisi **byte**, yang dapat memotong karakter multi-byte di tengah dan menghasilkan data rusak.
- `string.reverse(s)`: Akan mengacak urutan byte dari karakter multi-byte, merusaknya.

**Lua 5.3+ UTF-8 library:**
Untuk mengatasi ini, Lua versi 5.3 dan yang lebih baru menyertakan pustaka `utf8` standar.

- **`utf8.len(s)`**: Menghitung jumlah **karakter** Unicode (codepoints) dengan benar.
- **`utf8.codes(s)`**: Mengembalikan sebuah iterator yang digunakan dalam loop `for` untuk mengakses setiap karakter satu per satu. Ini adalah cara yang benar untuk mengiterasi string UTF-8.
- **`utf8.offset(s, n, i)`**: Menghitung posisi byte dari karakter ke-`n`.

**Contoh Kode (Menangani UTF-8):**

```lua
-- File dengan konten UTF-8
local filename = "utf8_test.txt"
local file, err = io.open(filename, "w")
if not file then error(err) end
file:write("Halo, dunia! 👋 €")
file:close()

-- Membaca file
file, err = io.open(filename, "rb") -- Mode biner baik untuk menghindari masalah
if not file then error(err) end
local s = file:read("*a")
file:close()
os.remove(filename)

print("String UTF-8:", s)

-- Perbandingan fungsi standar vs. utf8
print("\n--- Perbandingan ---")
print("Panjang byte (#s):", #s)
print("Panjang karakter (utf8.len):", utf8.len(s))

-- Iterasi yang salah (per byte)
print("\nIterasi salah (per byte):")
for i = 1, #s do
    io.write(string.sub(s, i, i))
end
io.write("\n")

-- Iterasi yang benar (per karakter)
print("\nIterasi benar (dengan utf8.codes):")
for pos, codepoint in utf8.codes(s) do
    -- string.char() tidak bisa menangani codepoint > 255
    -- utf8.char() bisa
    io.write(utf8.char(codepoint))
end
io.write("\n")
```

**Penjelasan Kode**:

- String `s` berisi karakter multi-byte (emoji 👋 dan simbol euro €).
- `#s` akan memberikan jumlah byte yang lebih besar dari jumlah karakter sebenarnya. `utf8.len(s)` memberikan jumlah karakter yang benar.
- Contoh iterasi menunjukkan bagaimana `utf8.codes` memungkinkan kita untuk memproses string "per karakter" secara logis, meskipun representasi byte-nya bervariasi.

**Sumber Referensi:**

- [Lua 5.3 Reference Manual: `utf8` library](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.3/manual.html%236.5%5D(https://www.lua.org/manual/5.3/manual.html%236.5)>)

---

### 13.3 Filesystem Attributes

**Deskripsi Konkret:**
Atribut filesystem adalah metadata yang terkait dengan sebuah file atau direktori, di luar kontennya sendiri. Ini termasuk informasi seperti kapan file terakhir diubah, ukurannya, jenisnya (file, direktori, link), dan izin aksesnya.

**Permissions, timestamps, etc.:**
Pustaka `io` dan `os` standar Lua sangat terbatas dalam hal ini. Anda tidak bisa mendapatkan atau mengubah informasi ini dengan fungsi bawaan.

**Cross-platform attribute handling (using LFS):**
Sekali lagi, **LuaFileSystem (LFS)** adalah solusi standar untuk masalah ini. Ia menyediakan cara lintas-platform untuk mengakses atribut-atribut ini.

- **`lfs.attributes(filepath, [attributename])`**:
  - Fungsi utamanya. Jika dipanggil hanya dengan path file, ia mengembalikan sebuah tabel yang berisi semua atribut yang tersedia.
  - Anda juga bisa meminta satu atribut spesifik.
  - Atribut umum yang dikembalikan:
    - `mode`: Tipe file (misalnya, `"file"`, `"directory"`, `"link"`).
    - `size`: Ukuran file dalam byte.
    - `modification`: Timestamp (angka) kapan file terakhir diubah.
    - `access`: Timestamp akses terakhir.
    - `change`: Timestamp perubahan status terakhir.
- **`lfs.setmode(filepath, mode)`**: Untuk mengubah izin file (terutama berguna di sistem POSIX).

**Contoh Kode (Menggunakan LFS):**

```lua
-- PENTING: Membutuhkan LuaFileSystem terinstal ('luarocks install luafilesystem')

local status_lfs, lfs = pcall(require, "lfs")

if not status_lfs then
    print("LuaFileSystem (LFS) tidak ditemukan. Melewatkan contoh ini.")
else
    print("LFS ditemukan. Membuat file untuk inspeksi...")

    local filename = "attribute_test.txt"
    local file, err = io.open(filename, "w")
    if not file then error(err) end
    file:write("Konten untuk pengujian atribut.")
    file:close()

    print("\n--- Atribut untuk '" .. filename .. "' ---")
    local attrs, err_attr = lfs.attributes(filename)

    if not attrs then
        print("Gagal mendapatkan atribut:", err_attr)
    else
        for key, value in pairs(attrs) do
            -- Konversi timestamp menjadi format yang bisa dibaca manusia
            if key:match("modification|access|change") then
                print(string.format("  - %s: %s", key, os.date("%Y-%m-%d %H:%M:%S", value)))
            else
                print(string.format("  - %s: %s", key, tostring(value)))
            end
        end
    end

    os.remove(filename) -- Membersihkan
end
```

**Penjelasan Kode**:

- Kode ini dengan aman mencoba memuat LFS.
- Ia membuat file sementara, lalu memanggil `lfs.attributes()` pada file tersebut.
- Hasilnya adalah sebuah tabel yang kemudian diiterasi untuk mencetak semua metadata yang tersedia, mengubah timestamp menjadi tanggal yang bisa dibaca menggunakan `os.date()`.

**Sumber Referensi:**

- [LuaFileSystem Manual](https://www.google.com/search?q=https://keplerproject.github.io/luafilesystem/manual.html)

Dengan menguasai topik-topik ini, Anda dapat menangani skenario I/O yang jauh lebih canggih, mulai dari mengoptimalkan pemuatan kode, menangani teks internasional dengan benar, hingga berinteraksi secara mendalam dengan sistem file.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../integrations-dengan-other-systems/README.md
[selanjutnya]: ../platform-specific-considerations/README.md

<!----------------------------------------------------->

[0]: ../../input-output/README.md#13-debugging-dan-troubleshooting
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
