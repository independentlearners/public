# **[4. Complete Model I/O (Explicit File Descriptors)][1]**

Berbeda dengan Simple Model yang mengandalkan file input/output default, Complete Model mengharuskan Anda untuk secara eksplisit membuka file, melakukan operasi padanya menggunakan _file handle_ yang dikembalikan, dan kemudian secara eksplisit menutupnya. Ini memberikan fleksibilitas dan kontrol yang jauh lebih besar.

### 4.1 Membuka dan Menutup File

**Deskripsi Konkret:**
Langkah pertama dalam bekerja dengan file menggunakan Complete Model adalah membukanya menggunakan fungsi `io.open()`. Fungsi ini, jika berhasil, akan mengembalikan sebuah _file handle_ (sebuah objek yang merepresentasikan file yang terbuka). Setelah selesai menggunakan file, sangat penting untuk menutupnya menggunakan metode `file:close()` pada file handle tersebut.

**`io.open()` dengan berbagai mode (r, w, a, r+, w+, a+):**

- **Konsep**: Fungsi `io.open()` digunakan untuk membuka sebuah file dengan mode tertentu yang menentukan jenis operasi apa yang diizinkan pada file tersebut.
- **Sintaks**: `local file, errorMessage = io.open(filename, mode)`
  - `filename`: String yang berisi nama (dan path jika perlu) dari file yang akan dibuka.
  - `mode`: String yang menentukan mode akses. Mode-mode yang umum adalah:
    - **`"r"` (read - baca)**:
      - Membuka file untuk dibaca.
      - Kursor file (posisi baca/tulis) ditempatkan di awal file.
      - File harus sudah ada. Jika tidak, `io.open()` akan mengembalikan `nil` dan pesan error.
    - **`"w"` (write - tulis)**:
      - Membuka file untuk ditulis.
      - Jika file sudah ada, **isinya akan dihapus (truncate)** dan file dimulai dari kosong.
      - Jika file belum ada, file baru akan dibuat.
      - Kursor file ditempatkan di awal file.
    - **`"a"` (append - tambah di akhir)**:
      - Membuka file untuk ditulis, dengan data baru ditambahkan di akhir file.
      - Jika file belum ada, file baru akan dibuat.
      - Kursor file ditempatkan di akhir file, sehingga tulisan baru tidak menghapus konten lama.
    - **`"r+"` (read plus - baca dan tulis)**:
      - Membuka file untuk dibaca dan ditulis.
      - File harus sudah ada.
      - Kursor file ditempatkan di awal file.
    - **`"w+"` (write plus - tulis dan baca)**:
      - Membuka file untuk ditulis dan dibaca.
      - Jika file sudah ada, **isinya akan dihapus**.
      - Jika file belum ada, file baru akan dibuat.
      - Kursor file ditempatkan di awal file.
    - **`"a+"` (append plus - tambah dan baca)**:
      - Membuka file untuk dibaca dan ditulis, dengan data baru ditambahkan di akhir file.
      - Jika file belum ada, file baru akan dibuat.
      - Kursor file ditempatkan di akhir file untuk penulisan awal, tetapi bisa dipindahkan untuk membaca.
  - **Return Value**:
    - Jika berhasil: mengembalikan _file handle_ (objek bertipe `file`).
    - Jika gagal: mengembalikan `nil` diikuti dengan string pesan error, dan terkadang kode error numerik (tergantung sistem operasi).

**`file:close()` dan pentingnya menutup file:**

- **Konsep**: Setelah Anda selesai melakukan operasi pada file, Anda harus menutupnya menggunakan metode `close()` pada file handle.
- **Sintaks**: `local success, errorMessage = filehandle:close()`
  - `filehandle`: Variabel yang menyimpan file handle yang dikembalikan oleh `io.open()`.
  - **Metode (`:`)**: Tanda titik dua (`:`) digunakan untuk memanggil _metode_ pada sebuah objek. `close()` adalah metode dari objek file.
- **Return Value**:
  - Mengembalikan `true` jika file berhasil ditutup.
  - Mengembalikan `nil` diikuti pesan error jika terjadi masalah saat menutup.
- **Pentingnya Menutup File**:
  1.  **Flush Buffer**: Sistem operasi seringkali menyimpan data yang ditulis ke file dalam sebuah buffer di memori untuk efisiensi. Menutup file memastikan semua data dalam buffer tersebut benar-benar ditulis ke media penyimpanan (disk). Jika program Anda berakhir tanpa menutup file, sebagian data mungkin hilang.
  2.  **Melepaskan Sumber Daya**: Setiap file yang terbuka mengkonsumsi sumber daya sistem (seperti file descriptor). Menutup file akan melepaskan sumber daya ini. Jika program Anda membuka banyak file tanpa menutupnya, Anda bisa kehabisan sumber daya ini, menyebabkan error.
  3.  **Akses File Lain**: Pada beberapa sistem operasi, file yang sedang dibuka oleh satu proses mungkin tidak bisa diakses atau dimodifikasi oleh proses lain. Menutup file memungkinkan proses lain untuk mengaksesnya.

**Binary mode (rb, wb, ab, r+b, w+b, a+b):**

- **Konsep**: Selain mode teks di atas, Anda bisa menambahkan karakter `b` ke mode string untuk membuka file dalam _binary mode_ (mode biner). Misalnya, `"rb"`, `"wb"`, `"ab"`, `"r+b"`, `"w+b"`, `"a+b"`.
- **Perbedaan Utama Mode Teks vs Biner**:
  - **Mode Teks**: Pada beberapa sistem operasi (terutama Windows), mode teks melakukan translasi karakter tertentu. Misalnya, karakter newline (`\n`) mungkin ditulis ke file sebagai pasangan carriage return + line feed (`\r\n`), dan sebaliknya saat dibaca.
  - **Mode Biner**: Tidak ada translasi karakter. Setiap byte dibaca dan ditulis apa adanya. Ini penting untuk file yang bukan teks murni, seperti gambar, audio, file eksekusi, atau data terstruktur biner lainnya.
- **Kapan Menggunakan**: Selalu gunakan mode biner jika Anda bekerja dengan file yang bukan file teks biasa untuk memastikan integritas data. Untuk portabilitas, bahkan untuk file teks, kadang-kadang menggunakan mode biner bisa lebih aman jika Anda ingin menghindari translasi newline yang tidak terduga, meskipun ini berarti Anda harus menangani perbedaan newline antar OS secara manual jika perlu.

**Contoh Kode (`buka_tutup_file.lua`):**

```lua
-- 1. Membuka file untuk ditulis ("w")
print("Mencoba membuka 'data_baru.txt' untuk ditulis...")
local file_w, err_w = io.open("data_baru.txt", "w")
-- Penjelasan Sintaks io.open():
-- local file_w, err_w: Mendeklarasikan dua variabel lokal.
--                      'file_w' akan menampung file handle jika berhasil, atau nil jika gagal.
--                      'err_w' akan menampung pesan error jika gagal.
-- io.open: Fungsi untuk membuka file.
-- "data_baru.txt": Nama file yang akan dibuka.
-- "w": Mode tulis. Jika file ada, isinya dihapus. Jika tidak, file baru dibuat.

if not file_w then
    io.stderr:write("Gagal membuka 'data_baru.txt' untuk ditulis: " .. (err_w or "unknown error") .. "\n")
else
    print("'data_baru.txt' berhasil dibuka dengan file handle:", file_w)
    -- Operasi tulis akan dibahas di bagian selanjutnya
    -- ... melakukan sesuatu dengan file ...
    io.write("Menulis sesuatu ke 'data_baru.txt' (melalui output default, bukan file handle langsung untuk demo ini). Isi sebenarnya nanti.\n")

    -- Menutup file
    local sukses_tutup, err_tutup = file_w:close()
    -- Penjelasan Sintaks file:close():
    -- file_w: Objek file handle.
    -- :close(): Memanggil metode 'close' pada objek file_w.
    -- sukses_tutup: Akan true jika berhasil, nil jika gagal.
    -- err_tutup: Pesan error jika gagal menutup.

    if sukses_tutup then
        print("'data_baru.txt' berhasil ditutup.")
    else
        io.stderr:write("Gagal menutup 'data_baru.txt': " .. (err_tutup or "unknown error") .. "\n")
    end
end

-- 2. Mencoba membuka file yang tidak ada dalam mode baca ("r")
print("\nMencoba membuka 'tidak_ada.txt' untuk dibaca...")
local file_r_gagal, err_r_gagal = io.open("tidak_ada.txt", "r")

if not file_r_gagal then
    print("Gagal membuka 'tidak_ada.txt' (ini diharapkan): " .. (err_r_gagal or "unknown error"))
else
    print("'tidak_ada.txt' terbuka? Ini tidak seharusnya terjadi.")
    file_r_gagal:close()
end

-- 3. Membuat file, menulis, menutup, lalu membuka untuk dibaca ("r")
print("\nMembuat dan membaca file 'contoh_baca.txt'...")
local file_buat, err_buat = io.open("contoh_baca.txt", "w")
if not file_buat then
    io.stderr:write("Gagal membuat 'contoh_baca.txt': " .. (err_buat or "") .. "\n")
else
    -- (Penulisan menggunakan file handle akan dibahas di 4.2)
    file_buat:write("Baris pertama untuk dibaca.\n")
    file_buat:write("Baris kedua.\n")
    file_buat:close()
    print("'contoh_baca.txt' dibuat dan ditutup.")

    local file_baca, err_baca = io.open("contoh_baca.txt", "r")
    if not file_baca then
        io.stderr:write("Gagal membuka 'contoh_baca.txt' untuk dibaca: " .. (err_baca or "") .. "\n")
    else
        print("'contoh_baca.txt' berhasil dibuka untuk dibaca.")
        -- (Pembacaan menggunakan file handle akan dibahas di 4.2)
        -- local konten = file_baca:read("*a")
        -- print("Isi file:", konten)
        file_baca:close()
        print("'contoh_baca.txt' ditutup setelah dibaca.")
    end
end

-- 4. Mode append ("a")
print("\nMenggunakan mode append ('a') pada 'data_baru.txt'...")
local file_a, err_a = io.open("data_baru.txt", "a") -- data_baru.txt sudah dibuat sebelumnya
if not file_a then
    io.stderr:write("Gagal membuka 'data_baru.txt' untuk append: " .. (err_a or "") .. "\n")
else
    print("'data_baru.txt' dibuka dalam mode append.")
    -- (Penulisan akan dibahas lebih detail nanti)
    file_a:write("Ini adalah data tambahan (appended).\n")
    print("Data ditambahkan ke 'data_baru.txt'.")
    file_a:close()
    print("'data_baru.txt' ditutup setelah append.")
end

-- 5. Mode r+
print("\nMenggunakan mode read-plus ('r+') pada 'data_baru.txt'...")
local file_rplus, err_rplus = io.open("data_baru.txt", "r+")
if not file_rplus then
    io.stderr:write("Gagal membuka 'data_baru.txt' dengan mode 'r+': " .. (err_rplus or "") .. "\n")
else
    print("'data_baru.txt' dibuka dalam mode 'r+'.")
    -- Anda bisa membaca dan menulis di sini. Kursor di awal.
    -- Contoh: membaca baris pertama (detail file:read() di 4.2)
    -- local barisAwal = file_rplus:read("*l")
    -- print("Baris awal (r+):", barisAwal)
    -- Contoh: menulis sesuatu di awal (akan menimpa)
    -- file_rplus:seek("set", 0) -- kembali ke awal (detail file:seek() di 4.2)
    -- file_rplus:write("DITIMPA!")
    file_rplus:close()
    print("'data_baru.txt' ditutup.")
end
```

**Penjelasan Kode `buka_tutup_file.lua`:**

- Setiap blok `io.open()` selalu diikuti pemeriksaan apakah `file_handle` yang dikembalikan adalah `nil`. Jika `nil`, berarti terjadi error, dan pesan errornya ada di variabel kedua.
- Setiap file yang berhasil dibuka kemudian ditutup dengan `file_handle:close()`. Hasil dari `close()` juga diperiksa.
- Contoh menunjukkan bagaimana mode `"r"` gagal jika file tidak ada.
- Contoh menunjukkan pembuatan file dengan `"w"`, penulisan sedikit data (detail penulisan akan ada di 4.2), lalu membukanya kembali dengan `"r"`.
- Mode `"a"` (append) digunakan untuk menambahkan data ke file yang sudah ada tanpa menghapus konten sebelumnya.
- Mode `"r+"` (dan serupa `"w+"`, `"a+"`) memungkinkan operasi baca dan tulis pada file yang sama.

**Sumber Referensi dari Kurikulum:**

- [Programming in Lua: Complete I/O Model](https://www.lua.org/pil/21.2.html) (Sumber ini adalah referensi utama untuk Complete Model, termasuk `io.open` dan `file:close` beserta modenya).
- Dokumentasi Resmi Lua:
  - [`io.open`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%23pdf-io.open%5D(https://www.lua.org/manual/5.4/manual.html%23pdf-io.open)>)
  - Metode file handle seperti `close` (biasanya didokumentasikan bersama sebagai operasi pada `file` userdata yang dikembalikan `io.open`).

Menguasai `io.open()` dan `file:close()` dengan berbagai modenya adalah fondasi penting sebelum Anda dapat melakukan operasi baca/tulis yang lebih kompleks pada file. Selalu ingat untuk menutup file yang telah Anda buka\!

---

### 4.2 Operasi File Handle

**Deskripsi Konkret:**
Setelah sebuah file berhasil dibuka dengan `io.open()` dan Anda mendapatkan file handle-nya, Anda dapat melakukan berbagai operasi pada file tersebut, seperti membaca data, menulis data, membaca baris per baris, dan memindahkan posisi kursor di dalam file. Semua operasi ini dilakukan sebagai _metode_ yang dipanggil pada objek file handle.

**`file:read()` dengan berbagai parameter:**

- **Konsep**: Metode `file:read()` digunakan untuk membaca data dari file yang terkait dengan `filehandle`. Perilakunya mirip dengan `io.read()` dalam Simple Model, tetapi operasinya terjadi pada file handle spesifik, bukan pada input default.
- **Sintaks**: `local data1, data2, ... = filehandle:read(format1, format2, ...)`
  - `filehandle`: File handle yang valid dari `io.open()`.
  - `format1, format2, ...`: Satu atau lebih format string yang sama seperti pada `io.read()`:
    - `"*l"` atau `"*line"`: Membaca baris berikutnya (tanpa newline).
    - `"*n"` atau `"*number"`: Membaca sebuah angka.
    - `"*a"` atau `"*all"`: Membaca seluruh sisa file dari posisi kursor saat ini hingga EOF.
    - `angka` (integer positif): Membaca sejumlah `angka` byte (karakter).
- **Return Value**: Mengembalikan string atau angka yang dibaca sesuai format. Jika beberapa format diminta, mengembalikan beberapa nilai. Jika mencapai EOF sebelum format terpenuhi (kecuali `"*a"` yang mengembalikan string kosong pada EOF langsung), atau jika terjadi error baca, mengembalikan `nil` untuk format tersebut.

**`file:write()` untuk menulis ke file:**

- **Konsep**: Metode `file:write()` digunakan untuk menulis data ke file yang terkait dengan `filehandle`.
- **Sintaks**: `local success, errorMessage = filehandle:write(arg1, arg2, ...)`
  - `filehandle`: File handle yang valid dari `io.open()`. File harus dibuka dalam mode yang mengizinkan penulisan (misalnya "w", "a", "r+", "w+", "a+").
  - `arg1, arg2, ...`: Satu atau lebih string atau angka yang akan ditulis ke file. Angka akan dikonversi menjadi string. Tidak ada pemisah atau newline otomatis yang ditambahkan (seperti `io.write()`).
- **Return Value**:
  - Jika berhasil: mengembalikan `filehandle` itu sendiri.
  - Jika gagal: mengembalikan `nil` diikuti pesan error.

**`file:lines()` untuk iterasi:**

- **Konsep**: Metode `file:lines()` bekerja seperti `io.lines()`, tetapi ia beroperasi pada file handle spesifik, bukan pada input default atau file yang namanya diberikan sebagai argumen. Ia mengembalikan sebuah iterator yang akan menghasilkan baris demi baris dari file.
- **Sintaks**: `for baris in filehandle:lines() do ... end`
  - `filehandle`: File handle yang valid dari `io.open()`.
  - (Lua 5.2+) Anda juga bisa menyediakan format: `filehandle:lines(format1, ...)`
- **Penting**: Berbeda dengan `io.lines(filename)`, `file:lines()` tidak menutup file handle secara otomatis. Anda tetap bertanggung jawab untuk memanggil `filehandle:close()` setelah selesai.

**`file:seek()` untuk navigasi posisi file:**

- **Konsep**: Metode `file:seek()` digunakan untuk melihat atau mengubah posisi kursor baca/tulis saat ini di dalam file. Ini memungkinkan akses acak (random access) ke konten file, tidak hanya sekuensial.
- **Sintaks**: `local newPosition, errorMessage = filehandle:seek(whence, offset)`
  - `filehandle`: File handle yang valid.
  - `whence` (opsional, default: `"cur"`): String yang menentukan titik referensi untuk pencarian:
    - **`"set"`**: Posisi dihitung dari awal file. `offset` harus non-negatif.
    - **`"cur"`**: Posisi dihitung dari posisi kursor saat ini. `offset` bisa positif (maju) atau negatif (mundur).
    - **`"end"`**: Posisi dihitung dari akhir file. `offset` biasanya non-positif atau nol.
  - `offset` (opsional, default: `0`): Angka integer yang menentukan jumlah byte untuk bergerak.
- **Penggunaan Umum**:
  - `file:seek()`: Mengembalikan posisi kursor saat ini (dalam byte dari awal file) tanpa mengubahnya.
  - `file:seek("set", 0)`: Memindahkan kursor ke awal file.
  - `file:seek("end", 0)`: Memindahkan kursor ke akhir file.
  - `file:seek("cur", n)`: Maju `n` byte dari posisi saat ini.
  - `file:seek("cur", -n)`: Mundur `n` byte dari posisi saat ini.
- **Return Value**:
  - Jika berhasil: mengembalikan posisi kursor baru (dalam byte dari awal file).
  - Jika gagal: mengembalikan `nil` diikuti pesan error.
- **Catatan**: Tidak semua file stream mendukung `seek` (misalnya, terminal atau pipe). Operasi `seek` pada file yang dibuka dalam mode append (`"a"` atau `"a+"`) mungkin memiliki perilaku spesifik tergantung sistem operasi (biasanya, semua penulisan tetap terjadi di akhir file meskipun `seek` dipanggil).

**Contoh Kode (`operasi_filehandle.lua`):**

```lua
-- Persiapkan file contoh "operasi_data.txt"
local file_setup, err_setup = io.open("operasi_data.txt", "w")
if not file_setup then
    io.stderr:write("Gagal setup file: " .. (err_setup or "") .. "\n")
    return -- Keluar dari skrip jika setup gagal
end
file_setup:write("Baris pertama.\n")
file_setup:write("Baris kedua dengan angka 123.\n")
file_setup:write("Baris ketiga untuk seek.\n")
file_setup:write("Data Biner Contoh\0\1\2ABC") -- Sedikit data biner
file_setup:close()
print("File 'operasi_data.txt' telah disiapkan.\n")

-- 1. Membaca file dengan file:read()
print("--- Menggunakan file:read() ---")
local file_r, err_r = io.open("operasi_data.txt", "r") -- Mode baca teks
if not file_r then
    io.stderr:write("Gagal membuka untuk baca: " .. (err_r or "") .. "\n")
else
    -- Membaca seluruh file
    local semua_konten, err_read_all = file_r:read("*a")
    -- Penjelasan Sintaks file:read():
    -- file_r: File handle.
    -- :read: Metode untuk membaca.
    -- "*a": Format untuk membaca semua.
    -- semua_konten: Variabel untuk menyimpan hasil baca.
    -- err_read_all: Tidak umum untuk *a, tapi untuk format lain bisa ada error.
    if semua_konten then
        print("Isi seluruh file (mode teks):\n" .. semua_konten)
    else
        print("Gagal membaca seluruh file atau file kosong.")
    end
    file_r:close() -- Tutup file setelah selesai

    -- Membaca per bagian
    file_r, err_r = io.open("operasi_data.txt", "r") -- Buka lagi untuk demo baca per bagian
    if file_r then
        local baris1 = file_r:read("*l")
        print("Baris 1 (dibaca dengan *l): " .. (baris1 or "NIL"))

        local limaKarakter = file_r:read(5)
        print("5 karakter berikutnya: '" .. (limaKarakter or "NIL") .. "'")

        -- Mencoba membaca angka (akan gagal karena 'kedua' bukan angka)
        local angka = file_r:read("*n")
        if angka then
            print("Angka terbaca: " .. angka)
        else
            print("Gagal membaca angka pada posisi ini (diharapkan).")
            -- Karena *n gagal, ia membaca karakter sampai non-angka.
            -- Kita perlu 'membuang' sisa baris itu jika ingin lanjut ke baris berikutnya dengan *l
            file_r:read("*l") -- Buang sisa baris "kedua dengan angka 123."
        end
        local baris3 = file_r:read("*l") -- Seharusnya "Baris ketiga untuk seek."
        print("Baris berikutnya setelah percobaan *n: " .. (baris3 or "NIL"))

        file_r:close()
    end
end

-- 2. Menulis ke file dengan file:write()
print("\n--- Menggunakan file:write() ---")
local file_w, err_w = io.open("output_penulisan.txt", "w+") -- w+ untuk tulis dan baca
if not file_w then
    io.stderr:write("Gagal membuka untuk tulis: " .. (err_w or "") .. "\n")
else
    local bytes_written, err_write = file_w:write("Halo dari Lua!\n", "Ini baris kedua.\n")
    -- Penjelasan Sintaks file:write():
    -- file_w: File handle.
    -- :write: Metode untuk menulis.
    -- "Halo dari Lua!\n", "Ini baris kedua.\n": Argumen string yang akan ditulis.
    -- bytes_written: Sebenarnya io.write() yang ini mengembalikan file handle jika sukses.
    --                Yang mengembalikan jumlah bytes adalah socket:send atau beberapa lib lain.
    --                Untuk file:write(), cukup cek apakah return-nya adalah file handle itu sendiri (true-ish).
    -- err_write: Pesan error jika gagal.

    if not bytes_written then -- Seharusnya 'if not file_w then' setelah write, atau cek err_write
                              -- Cara yang lebih umum adalah jika file:write() gagal, ia return nil, msg
        io.stderr:write("Gagal menulis ke file: " .. (err_write or "unknown error") .. "\n")
    else
        print("Berhasil menulis ke 'output_penulisan.txt'.")
    end

    -- Membaca apa yang ditulis (karena mode w+)
    file_w:seek("set", 0) -- Kembali ke awal file untuk membaca
    local konten_tertulis = file_w:read("*a")
    print("Isi file setelah ditulis (dibaca ulang):\n" .. (konten_tertulis or "KOSONG"))

    file_w:close()
end

-- 3. Iterasi dengan file:lines()
print("\n--- Menggunakan file:lines() ---")
local file_l, err_l = io.open("operasi_data.txt", "r")
if not file_l then
    io.stderr:write("Gagal membuka untuk lines: " .. (err_l or "") .. "\n")
else
    print("Membaca 'operasi_data.txt' baris per baris:")
    local count = 0
    for baris in file_l:lines() do
        -- Penjelasan Sintaks file:lines():
        -- file_l: File handle.
        -- :lines(): Metode yang mengembalikan iterator.
        -- for baris in ... : Loop for generik.
        count = count + 1
        print("  Baris " .. count .. ": " .. baris)
    end
    -- Penting: file:lines() TIDAK menutup file secara otomatis.
    file_l:close()
    print("Selesai membaca dengan file:lines(). File ditutup.")
end

-- 4. Navigasi dengan file:seek()
print("\n--- Menggunakan file:seek() ---")
local file_s, err_s = io.open("operasi_data.txt", "rb") -- Buka dalam mode read binary untuk seek yang akurat
if not file_s then
    io.stderr:write("Gagal membuka untuk seek: " .. (err_s or "") .. "\n")
else
    local pos1 = file_s:seek() -- Dapatkan posisi saat ini (awal)
    -- Penjelasan Sintaks file:seek():
    -- file_s: File handle.
    -- :seek(): Metode untuk mendapatkan/mengatur posisi. Tanpa argumen, mendapatkan posisi.
    print("Posisi awal: " .. pos1) -- Harusnya 0

    file_s:seek("set", 15) -- Pindah ke byte ke-15 dari awal
    local pos2 = file_s:seek()
    print("Posisi setelah seek('set', 15): " .. pos2)
    local data_seek1 = file_s:read(10) -- Baca 10 byte dari sana
    print("Data setelah seek('set', 15): '" .. (data_seek1 or "") .. "'")

    file_s:seek("cur", 5) -- Maju 5 byte dari posisi saat ini
    local pos3 = file_s:seek()
    print("Posisi setelah seek('cur', 5): " .. pos3)

    file_s:seek("end", -10) -- Mundur 10 byte dari akhir file
    local pos4 = file_s:seek()
    print("Posisi setelah seek('end', -10): " .. pos4)
    local data_seek_akhir = file_s:read("*a") -- Baca sisa file
    print("Data dari seek('end', -10) hingga akhir: '" .. (data_seek_akhir or "") .. "'")

    file_s:close()
end
```

**Penjelasan Kode `operasi_filehandle.lua`:**

- **File Setup**: File `operasi_data.txt` dibuat terlebih dahulu dengan beberapa baris data untuk pengujian.
- **`file:read()`**:
  - Mendemonstrasikan pembacaan seluruh file (`"*a"`).
  - Menunjukkan pembacaan per bagian (`"*l"`, `angka`), dan bagaimana `"*n"` yang gagal dapat mempengaruhi posisi baca untuk pembacaan berikutnya jika tidak ditangani.
  - File dibuka ulang untuk setiap demo pembacaan agar posisi kursor kembali ke awal.
- **`file:write()`**:
  - Membuka file `output_penulisan.txt` dalam mode `"w+"` (tulis dan baca, konten lama dihapus).
  - Menulis beberapa string. Catatan: `file:write()` yang berhasil mengembalikan file handle itu sendiri. Pengecekan error yang lebih baik adalah `local ok, err = file:write(...) if not ok then ...`.
  - Menggunakan `file:seek("set", 0)` untuk kembali ke awal file, lalu `file:read("*a")` untuk memverifikasi apa yang telah ditulis.
- **`file:lines()`**:
  - Membuka `operasi_data.txt` dan mengiterasi baris-barisnya menggunakan `for` loop.
  - Menekankan bahwa `file:close()` harus dipanggil secara manual setelah loop selesai.
- **`file:seek()`**:
  - Membuka file dalam mode `"rb"` (read binary) untuk memastikan `offset` `seek` dihitung dalam byte secara akurat, tanpa translasi karakter newline yang mungkin terjadi di mode teks.
  - Menunjukkan cara mendapatkan posisi saat ini (`file:seek()`).
  - Mendemonstrasikan penggunaan `whence` `"set"`, `"cur"`, dan `"end"` dengan `offset` yang berbeda untuk memindahkan kursor dan membaca data dari posisi tersebut.

**Sumber Referensi dari Kurikulum:**

- [GameDev Academy: Lua File I/O Tutorial](https://gamedevacademy.org/lua-file-i-o-tutorial-complete-guide/) (Tutorial ini kemungkinan besar mencakup operasi-operasi file handle ini dengan contoh).
- Dokumentasi Resmi Lua (semua ini adalah metode dari objek `file`):
  - `file:read`
  - `file:write`
  - `file:lines`
  - `file:seek`
    (Lihat [Lua 5.4 Manual - 6.8.1 – Functions for the Complete Model](https://www.google.com/search?q=https://www.lua.org/manual/5.4/manual.html%236.8.1) atau bagian yang menjelaskan metode `file`.)

Dengan operasi-operasi ini, Anda memiliki perangkat lengkap untuk memanipulasi konten file secara detail menggunakan Complete Model. Berikutnya kita akan melanjutkan ke "File Status dan Metadata"

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][2]**
> - **[Sebelumnya][3]**
> - **[Kurikulum][4]**
> - **[Domain Spesifik][5]**

[5]: ../../../../../../README.md
[4]: ../../../../README.md
[3]: ../README.md/#3-simple-model-io-implicit-file-descriptors
[2]: ../error-handling-I-O/README.md
[1]: ../README.md/#4-complete-model-io-explicit-file-descriptors
