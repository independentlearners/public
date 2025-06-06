# **[4. Complete Model I/O (Explicit File Descriptors)][0]**

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

#

Dengan operasi-operasi ini, Anda memiliki perangkat lengkap untuk memanipulasi konten file secara detail menggunakan Complete Model.

#

### 4.3 File Status dan Metadata

**Deskripsi Konkret:**
Setelah Anda memiliki file handle, seringkali Anda perlu mengetahui statusnya—apakah file tersebut masih terbuka? Atau Anda mungkin perlu melakukan operasi tingkat rendah seperti memaksa data untuk ditulis ke disk. Bagian ini mencakup utilitas untuk mengelola dan memeriksa status file handle Anda.

**`file:flush()` untuk memaksa penulisan:**

- **Konsep**: Untuk alasan efisiensi, ketika Anda menggunakan `file:write()`, data yang Anda tulis tidak selalu langsung disimpan ke media fisik (seperti hard disk atau SSD). Sebaliknya, sistem operasi seringkali menyimpannya terlebih dahulu di sebuah area memori sementara yang disebut **buffer**. Data dalam buffer ini baru akan "dibersihkan" (flushed) atau ditulis ke disk ketika buffer penuh, ketika file ditutup (`file:close()`), atau ketika program berakhir. Metode `file:flush()` memungkinkan Anda untuk secara manual memaksa sistem operasi untuk segera menulis semua data yang tertahan di buffer ke file.
- **Terminologi**:
  - **Buffer**: Area penyimpanan sementara di memori. Mengumpulkan data dalam buffer sebelum menulisnya dalam satu blok besar ke disk jauh lebih cepat daripada menulis setiap potongan data kecil secara terpisah.
  - **Flush**: Operasi untuk membersihkan buffer dengan menulis isinya ke tujuan akhir (file).
- **Sintaks**: `local success, errorMessage = filehandle:flush()`
  - `filehandle`: File handle yang valid dan terbuka untuk penulisan.
- **Return Value**: Mengembalikan `true` jika berhasil, atau `nil` dan pesan error jika gagal.
- **Kapan digunakan?**
  - **Logging**: Jika Anda menulis file log, Anda mungkin ingin pesan log segera terlihat di file, terutama saat men-debug, tanpa harus menunggu file ditutup.
  - **Komunikasi Antar-Proses**: Jika satu program menulis ke file (atau pipe) yang sedang dibaca oleh program lain, `flush()` memastikan bahwa program kedua akan segera melihat data yang baru ditulis.
  - **Ketahanan Data**: Dalam aplikasi kritis, memanggil `flush()` setelah penulisan data penting dapat mengurangi risiko kehilangan data jika program crash sebelum file ditutup secara normal.

**`io.type()` untuk mengecek status file handle:**

- **Konsep**: Fungsi `io.type()` adalah alat diagnostik yang sangat berguna. Ia memeriksa sebuah variabel dan mengembalikan string yang mendeskripsikan tipenya. Ini sangat berguna untuk file handle karena ia dapat membedakan antara file yang masih terbuka dan file yang sudah ditutup.
- **Sintaks**: `local typeString = io.type(object)`
  - `object`: Variabel yang ingin Anda periksa (misalnya, file handle).
- **Return Value yang Relevan untuk I/O**:
  - **`"file"`**: Jika `object` adalah file handle yang sedang **terbuka**.
  - **`"closed file"`**: Jika `object` adalah file handle yang sudah **ditutup**.
  - `nil`: Jika `object` adalah `nil`.
  - String lain untuk tipe data lain (`"number"`, `"string"`, dll.).

**Mengecek apakah file terbuka atau tertutup:**
Cara paling langsung untuk memeriksa status file handle adalah dengan menggunakan `io.type()`.

```lua
local file = io.open("test.txt", "w")
print(io.type(file))  -- Akan mencetak: "file"

file:close()
print(io.type(file))  -- Akan mencetak: "closed file"
```

**Mendapatkan Informasi File (Metadata):**
Pustaka `io` standar Lua cukup minimalis dalam hal mendapatkan metadata file (seperti ukuran file, tanggal modifikasi, dll.) secara langsung. Namun, ada beberapa trik dan fungsi dari pustaka `os` yang bisa digunakan:

- **Mendapatkan Ukuran File**: Cara paling umum untuk mendapatkan ukuran file menggunakan file handle yang terbuka adalah dengan `seek`:
  1.  Simpan posisi kursor saat ini: `local current_pos = file:seek()`
  2.  Pindahkan kursor ke akhir file: `local size = file:seek("end")`
  3.  Kembalikan kursor ke posisi semula: `file:seek("set", current_pos)`
- **Mendapatkan Informasi Lain**: Untuk metadata yang lebih kaya (seperti tanggal modifikasi, izin akses), pustaka `io` tidak menyediakannya. Anda biasanya akan memerlukan pustaka eksternal seperti **LuaFileSystem (LFS)**, yang menyediakan fungsi `lfs.attributes(filepath)` untuk mendapatkan informasi ini. Pustaka `os` standar juga memiliki beberapa fungsi terkait waktu, tetapi tidak secara langsung untuk mendapatkan waktu modifikasi file.

**Contoh Kode (`file_status.lua`):**

```lua
-- Membuka file untuk demonstrasi
local file, err = io.open("status_demo.txt", "w+")
if not file then
    io.stderr:write("Gagal membuka file: " .. (err or "") .. "\n")
    return
end

-- 1. Mengecek tipe file handle yang terbuka
print("--- Status Awal ---")
print("Tipe handle setelah dibuka:", io.type(file)) -- Seharusnya "file"

-- 2. Menggunakan file:flush()
print("\n--- Menggunakan file:flush() ---")
file:write("Data pertama yang akan di-flush.\n")
print("Data ditulis ke buffer...")
-- Pada titik ini, data mungkin belum ada di disk.

local ok, flush_err = file:flush()
-- Penjelasan Sintaks file:flush():
-- file: File handle.
-- :flush(): Memanggil metode 'flush' untuk memaksa penulisan dari buffer ke disk.
if ok then
    print("file:flush() berhasil. Data sekarang seharusnya ada di disk.")
else
    io.stderr:write("Gagal melakukan flush: " .. (flush_err or "") .. "\n")
end

file:write("Data kedua setelah flush.\n")
print("Data kedua ditulis ke buffer...")


-- 3. Mendapatkan ukuran file menggunakan seek
print("\n--- Mendapatkan Ukuran File ---")
local current_pos = file:seek()
print("Posisi saat ini sebelum cek ukuran:", current_pos)

local file_size = file:seek("end")
-- Penjelasan Sintaks file:seek("end"):
-- :seek("end"): Memindahkan kursor ke akhir file dan mengembalikan posisi tersebut,
--              yang secara efektif adalah ukuran file dalam byte.
print("Ukuran file (dari seek 'end'):", file_size, "bytes")

file:seek("set", current_pos) -- Kembalikan kursor ke posisi semula
print("Posisi setelah dikembalikan:", file:seek())


-- 4. Menutup file dan mengecek statusnya
print("\n--- Menutup File dan Pengecekan Akhir ---")
file:close()
print("File telah ditutup.")

print("Tipe handle setelah ditutup:", io.type(file)) -- Seharusnya "closed file"

-- 5. Mencoba operasi pada file yang sudah ditutup
print("\nMencoba operasi pada handle yang sudah ditutup...")
-- Operasi pada file yang sudah ditutup akan menghasilkan error.
-- Kita gunakan pcall (Protected Call) untuk menangkap error ini tanpa menghentikan skrip.
local status, error_msg = pcall(function()
    file:write("Mencoba menulis lagi.")
end)

-- Penjelasan Sintaks pcall():
-- pcall(func): Menjalankan fungsi 'func' dalam mode terproteksi.
-- status: Akan 'false' jika terjadi error di dalam 'func'.
-- error_msg: Akan berisi pesan error jika status adalah 'false'.

if not status then
    print("Operasi gagal seperti yang diharapkan.")
    print("Pesan error:", error_msg)
else
    print("Ini tidak seharusnya terjadi!")
end

-- Membersihkan file demo
local os = require("os")
os.remove("status_demo.txt")
print("\nFile 'status_demo.txt' telah dihapus.")
```

**Penjelasan Kode `file_status.lua`:**

- **`io.type(file)`**: Pertama kali dipanggil setelah `io.open()`, ia mengembalikan `"file"`. Setelah `file:close()`, ia mengembalikan `"closed file"`. Ini adalah cara yang jelas dan andal untuk memeriksa apakah file handle masih dapat digunakan.
- **`file:flush()`**: Mendemonstrasikan bagaimana Anda bisa memaksa penulisan. Dalam skrip sederhana seperti ini, efeknya mungkin tidak terlihat jelas, tetapi konsepnya sangat penting untuk aplikasi yang lebih besar.
- **Mendapatkan Ukuran File**: Kode ini menunjukkan "trik" `seek` untuk mendapatkan ukuran file. Ini adalah pola yang sangat umum di Lua karena pustaka standar tidak memiliki fungsi `filesize()`.
- **Operasi pada File Tertutup**: Bagian ini menunjukkan apa yang terjadi jika Anda mencoba menggunakan file handle yang sudah ditutup. Ini akan menyebabkan error. Menggunakan `pcall` adalah cara standar untuk menangani potensi error seperti ini dengan anggun, daripada membiarkan program Anda crash. Pesan error yang umum adalah "attempt to use a closed file".

**Sumber Referensi dari Kurikulum:**

- [CoderscratchPad: File I/O in Lua](https://coderscratchpad.com/file-i-o-in-lua-reading-and-writing-files/) (Sumber ini kemungkinan membahas siklus hidup file, termasuk `flush` dan `close`).
- [Wizards of Lua: io.type Documentation](https://www.wizards-of-lua.net/modules/io/) (Sumber ini secara spesifik mendokumentasikan `io.type` dan nilai-nilai yang dikembalikannya).
- Dokumentasi Resmi Lua:
  - `file:flush`
  - `io.type`
    (Lihat bagian metode `file` dan fungsi `io` di manual referensi Lua).

---

### 4.4 Temporary Files

**Deskripsi Konkret:**
Kadang-kadang, program Anda memerlukan file untuk menyimpan data sementara selama eksekusi, tetapi Anda tidak ingin file tersebut meninggalkan "sampah" di sistem file setelah program selesai. Untuk kebutuhan ini, Lua menyediakan fungsi `io.tmpfile()` yang membuat file sementara yang akan dihapus secara otomatis.

**`io.tmpfile()` untuk membuat temporary files:**

- **Konsep**: Fungsi `io.tmpfile()` membuat sebuah file sementara dan membukanya dalam mode baca/tulis (`w+b`). File ini berperilaku seperti file biasa—Anda mendapatkan file handle dan bisa menggunakan `read`, `write`, `seek`, dll. padanya.
- **Sintaks**: `local temp_file, errorMessage = io.tmpfile()`
- **Return Value**:
  - Jika berhasil: mengembalikan file handle untuk file sementara tersebut.
  - Jika gagal: mengembalikan `nil` dan pesan error.

**Karakteristik dan lifecycle temporary files:**

- **Mode**: File sementara selalu dibuka dalam mode `"w+b"` (write-plus-binary). Ini berarti Anda bisa membaca dan menulis data biner apa adanya.
- **Lokasi**: Lokasi fisik file sementara ini ditentukan oleh sistem operasi. Anda tidak perlu tahu atau peduli di mana file ini dibuat.
- **Lifecycle (Siklus Hidup)**: Keajaiban `io.tmpfile()` adalah **penghapusan otomatis**. File sementara ini akan secara otomatis dihapus dari sistem file ketika:
  1.  File handle-nya ditutup secara eksplisit (`temp_file:close()`).
  2.  Program Lua berakhir (jika Anda tidak menutupnya secara manual).

**Use cases untuk temporary files:**

- **Data Antara**: Menyimpan hasil antara dari sebuah proses komputasi yang besar yang tidak muat di memori.
- **Input untuk Program Eksternal**: Anda bisa menulis data ke file sementara, lalu memberikan path file tersebut ke program atau perintah command-line lain yang membutuhkan input dari file. (Catatan: mendapatkan path dari `io.tmpfile` tidak trivial, seringkali lebih mudah menggunakan `os.tmpname()` untuk mendapatkan nama file sementara, lalu membukanya dengan `io.open()`). Namun, untuk data yang hanya diproses di dalam Lua, `io.tmpfile()` lebih aman.
- **Sorting Data Besar**: Membaca data dari sumber, menulisnya ke file sementara, melakukan sorting dengan membaca dan menulis antar beberapa file sementara, lalu menulis hasilnya ke tujuan akhir.
- **Pengujian**: Membuat data "mock" atau palsu dalam sebuah file sementara untuk diuji oleh suatu fungsi, tanpa harus membuat dan membersihkan file secara manual di direktori proyek Anda.

**Contoh Kode (`temporary_file.lua`):**

```lua
print("--- Membuat dan Menggunakan File Sementara ---")

-- Membuat file sementara
local tmpf, err = io.tmpfile()

-- Penjelasan Sintaks io.tmpfile():
-- io.tmpfile(): Fungsi yang tidak memerlukan argumen.
--               Mengembalikan file handle jika berhasil, atau nil dan error jika gagal.
-- tmpf: Variabel untuk menampung file handle sementara.

if not tmpf then
    io.stderr:write("Gagal membuat file sementara: " .. (err or "unknown error") .. "\n")
    return
end

print("Berhasil membuat file sementara. Handle:", tmpf)
print("Tipe handle:", io.type(tmpf)) -- Akan "file"

-- Menulis data ke file sementara
tmpf:write("Ini adalah data rahasia yang disimpan sementara.\n")
tmpf:write("Data ini tidak akan meninggalkan jejak.\n")
tmpf:write(string.rep("x", 100)) -- Menulis 100 karakter 'x'

print("Data telah ditulis ke file sementara.")

-- Mendapatkan ukuran data yang ditulis
local size = tmpf:seek("end")
print("Ukuran data di file sementara:", size, "bytes.")

-- Membaca kembali data tersebut
tmpf:seek("set", 0) -- Kembali ke awal untuk membaca
local content = tmpf:read("*a")

print("\n--- Konten yang dibaca kembali dari file sementara ---")
print(content)
print("-----------------------------------------------------")


-- Menutup file sementara
-- Saat baris ini dieksekusi, file fisik di disk akan dihapus oleh sistem operasi.
tmpf:close()
print("\nFile sementara telah ditutup. Pada titik ini, file fisik sudah dihapus.")
print("Tipe handle setelah ditutup:", io.type(tmpf)) -- Akan "closed file"

-- Setelah ditutup, file tersebut benar-benar hilang.
-- Tidak ada file 'sampah' yang tersisa di direktori Anda.
```

**Penjelasan Kode `temporary_file.lua`:**

- `io.tmpfile()`: Dipanggil untuk mendapatkan file handle (`tmpf`). Anda tidak perlu menyediakan nama file.
- **Operasi Baca/Tulis/Seek**: Anda dapat menggunakan `tmpf` sama seperti file handle lain yang didapat dari `io.open()`. Kode ini menulis beberapa baris data, lalu menggunakan `seek` dan `read` untuk memverifikasi kontennya.
- **`tmpf:close()`**: Ini adalah bagian kuncinya. Saat metode `close()` dipanggil pada file handle dari `io.tmpfile()`, file tersebut tidak hanya ditutup, tetapi juga dihapus dari sistem file. Ini adalah perilaku yang dijamin oleh pustaka standar Lua.
- **Tidak Ada Pembersihan Manual**: Perhatikan bahwa tidak ada panggilan `os.remove()`. `io.tmpfile()` menangani seluruh siklus hidup file dari pembuatan hingga pemusnahan.

**Sumber Referensi dari Kurikulum:**

- [TutorialsPoint: Lua File I/O](https://www.tutorialspoint.com/lua/lua_file_io.htm) (Sumber ini seringkali mencakup fungsi-fungsi standar seperti `io.tmpfile`).
- [Gammon: io.tmpfile Documentation](https://www.gammon.com.au/scripts/doc.php?lua=io.tmpfile)
- [Stack Overflow: Using io.tmpfile](https://stackoverflow.com/questions/72272594/using-io-tmpfile-with-shell-command-ran-via-io-popen-in-lua) (Diskusi ini bisa memberikan konteks penggunaan yang lebih spesifik).
- Dokumentasi Resmi Lua:
  - [`io.tmpfile`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%23pdf-io.tmpfile%5D(https://www.lua.org/manual/5.4/manual.html%23pdf-io.tmpfile)>)

Dengan ini, kita telah menyelesaikan eksplorasi Complete Model I/O. Anda sekarang memiliki pengetahuan untuk membuka, menutup, membaca, menulis, menavigasi, dan mengelola status file dengan kontrol penuh.

#

#### Selanjutnya kita akan membahas topik yang sangat penting: **Penanganan Error dalam I/O**.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../simple-model-I-O/README.md
[selanjutnya]: ../error-handling-I-O/README.md

<!----------------------------------------------------->

[0]: ../README.md#4-complete-model-io-explicit-file-descriptors
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
