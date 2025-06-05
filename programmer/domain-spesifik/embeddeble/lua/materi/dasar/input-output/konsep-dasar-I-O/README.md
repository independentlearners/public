# **[1. Konsep Dasar Input/Output][1]**

Bagian ini akan memperkenalkan Anda pada konsep fundamental dari Input/Output (I/O) dalam konteks pemrograman, khususnya di Lua.

### 1.1 Pengenalan I/O di Lua

**Deskripsi Konkret:**
Input/Output (I/O) merujuk pada komunikasi antara program komputer dengan dunia luar. **Input** adalah data yang diterima oleh program, sedangkan **Output** adalah data yang dikirimkan oleh program. Dalam Lua, operasi I/O memungkinkan program Anda untuk membaca data dari berbagai sumber (seperti keyboard pengguna, file) dan menulis data ke berbagai tujuan (seperti layar konsol, file).

**Konsep Dasar Input dan Output dalam Pemrograman:**

- **Input**: Proses memasukkan data ke dalam program. Ini bisa berupa:
  - Input pengguna melalui keyboard.
  - Membaca data dari sebuah file.
  - Menerima data melalui jaringan.
  - Input dari sensor atau perangkat keras lainnya.
- **Output**: Proses mengeluarkan data dari program. Ini bisa berupa:
  - Menampilkan teks atau grafis di layar.
  - Menulis data ke sebuah file.
  - Mengirim data melalui jaringan.
  - Mengontrol perangkat keras.

**Perbedaan antara stdin, stdout, dan stderr:**
Ini adalah tiga aliran data standar (standard streams) yang umum ada di banyak sistem operasi dan lingkungan pemrograman:

- **stdin (Standard Input)**:

  - **Konsep**: Ini adalah aliran input default untuk sebuah program. Secara bawaan, stdin biasanya terhubung ke keyboard. Ketika program Anda mengharapkan input tanpa secara spesifik menentukan sumbernya, ia akan membaca dari stdin.
  - **Terminologi**: "Aliran" (stream) di sini berarti urutan data yang mengalir dari sumber ke tujuan. "Default" berarti pengaturan standar yang digunakan jika tidak ada yang lain ditentukan.
  - **Di Lua**: `io.stdin` adalah file handle yang merepresentasikan standard input. Anda bisa membaca darinya menggunakan fungsi seperti `io.stdin:read()`.

- **stdout (Standard Output)**:

  - **Konsep**: Ini adalah aliran output default untuk sebuah program. Secara bawaan, stdout biasanya terhubung ke layar konsol atau terminal. Ketika Anda mencetak sesuatu ke konsol (misalnya menggunakan `print()` di Lua), output tersebut dikirim ke stdout.
  - **Terminologi**: "Konsol" atau "terminal" adalah antarmuka teks tempat Anda bisa berinteraksi dengan sistem operasi atau menjalankan program baris perintah.
  - **Di Lua**: `io.stdout` adalah file handle yang merepresentasikan standard output. Anda bisa menulis ke sana menggunakan fungsi seperti `io.stdout:write()`. Fungsi `print()` secara default menulis ke `io.stdout`.

- **stderr (Standard Error)**:
  - **Konsep**: Ini adalah aliran output lain yang khusus digunakan untuk pesan kesalahan (error messages) dan diagnostik. Sama seperti stdout, stderr secara bawaan biasanya terhubung ke layar konsol. Memisahkan pesan error ke stderr memungkinkan pengguna atau program lain untuk membedakan antara output normal program dan pesan error. Misalnya, output normal bisa dialihkan ke file, sementara pesan error tetap tampil di layar.
  - **Terminologi**: "Diagnostik" adalah informasi yang membantu dalam mengidentifikasi masalah atau status program.
  - **Di Lua**: `io.stderr` adalah file handle yang merepresentasikan standard error. Anda bisa menulis pesan error ke sana menggunakan `io.stderr:write()`.

**Contoh Kode Sederhana (Konseptual):**

Bayangkan Anda menjalankan program Lua dari terminal.

1.  **Input (stdin)**: Anda mengetikkan nama Anda saat program meminta.
    ```lua
    -- (Akan dibahas lebih detail di bagian io.read())
    print("Masukkan nama Anda:")
    local nama = io.read() -- Membaca dari stdin
    ```
2.  **Output (stdout)**: Program menampilkan pesan sapaan.
    ```lua
    print("Halo, " .. nama .. "!") -- Mencetak ke stdout
    ```
3.  **Error (stderr)**: Jika terjadi kesalahan (misalnya, program mencoba membuka file yang tidak ada), pesan error akan ditampilkan.
    ```lua
    -- (Akan dibahas lebih detail di error handling)
    local file, err = io.open("file_tidak_ada.txt", "r")
    if not file then
        io.stderr:write("Error: " .. err .. "\n") -- Menulis error ke stderr
    end
    ```

**Penjelasan Sintaks Dasar dan Terminologi:**

- `print()`: Fungsi bawaan Lua untuk menampilkan output ke konsol (secara default ke `io.stdout`).
  - `print`: Nama fungsinya.
  - `("Masukkan nama Anda:")`: Argumen yang diberikan ke fungsi `print`. Dalam hal ini, sebuah string (teks yang diapit tanda kutip).
- `local nama = io.read()`:
  - `local`: Kata kunci untuk mendeklarasikan variabel lokal. Variabel lokal hanya dapat diakses dalam lingkup (scope) tempat ia didefinisikan.
  - `nama`: Nama variabel yang akan menyimpan input pengguna.
  - `=`: Operator assignment (penugasan), digunakan untuk memberikan nilai ke variabel.
  - `io.read()`: Fungsi dari pustaka `io` untuk membaca input. Akan dibahas lebih detail nanti.
- `..`: Operator konkatenasi (penggabungan) string di Lua.
- `io.stderr:write()`:
  - `io.stderr`: Merujuk pada file handle standard error.
  - `:`: Operator untuk memanggil metode pada sebuah objek (dalam hal ini, `write` adalah metode dari objek `io.stderr`).
  - `write()`: Metode untuk menulis string ke file handle tersebut.
  - `"\n"`: Karakter khusus yang berarti "baris baru" (newline).

**Sumber Referensi dari Kurikulum:**

- [Programming in Lua: Chapter 21](https://www.lua.org/pil/21.html) (Meskipun sumber ini merujuk ke bab yang lebih luas, konsep stdin, stdout, dan stderr adalah fundamental dan dibahas dalam konteks I/O secara umum).

---

### 1.2 Model I/O di Lua

**Deskripsi Konkret:**
Lua menyediakan dua model utama untuk menangani operasi I/O: **Simple Model** dan **Complete Model**. Memahami kedua model ini penting karena mereka menawarkan cara yang berbeda dalam mengelola sumber dan tujuan data, terutama file.

**Simple Model (Implicit File Descriptors):**

- **Konsep**: Model ini menyederhanakan operasi I/O dengan menggunakan konsep _input file default_ dan _output file default_. Anda tidak secara eksplisit membuka atau menutup file-file default ini; Lua yang mengelolanya di belakang layar. Operasi seperti `io.read()` akan membaca dari input file default, dan `io.write()` akan menulis ke output file default.
- **Terminologi**:
  - **Implicit File Descriptors**: "Implicit" berarti tidak dinyatakan secara langsung atau jelas. "File Descriptor" adalah semacam penunjuk atau handle ke sebuah file yang dibuka oleh sistem operasi. Dalam Simple Model, Anda tidak berurusan langsung dengan file descriptor ini untuk input/output default.
  - **Input File Default**: Awalnya adalah `stdin`. Bisa diubah menggunakan `io.input(namafile)`.
  - **Output File Default**: Awalnya adalah `stdout`. Bisa diubah menggunakan `io.output(namafile)`.
- **Kelebihan**: Mudah digunakan untuk tugas-tugas sederhana seperti membaca input pengguna dan mencetak output ke konsol, atau untuk skrip yang hanya memproses satu file input dan menghasilkan satu file output.
- **Keterbatasan**: Kurang fleksibel jika Anda perlu bekerja dengan banyak file secara bersamaan, atau jika Anda memerlukan kontrol lebih besar atas bagaimana file dibuka, ditutup, atau di-seek (dipindahkan posisi baca/tulisnya).

**Contoh Sederhana (Simple Model):**

```lua
-- Menulis ke output file default (stdout secara bawaan)
io.write("Ini ditulis menggunakan Simple Model ke stdout.\n")

-- Mengubah output file default ke "output.txt"
local success, err_msg = io.output("output.txt")
if success then
    io.write("Ini ditulis ke file output.txt.\n")
    io.output(io.stdout) -- Mengembalikan output default ke stdout
    print("Output telah dikembalikan ke konsol.")
else
    io.stderr:write("Gagal mengganti output file: " .. err_msg .. "\n")
end

-- Membaca dari input file default (stdin secara bawaan)
print("Masukkan sesuatu:")
local data = io.read()
print("Anda memasukkan (dari stdin): " .. data)

-- (Contoh dengan io.input() akan lebih jelas setelah membahas io.open() di Complete Model,
-- karena io.input() bisa menerima file handle yang dibuka dengan io.open())
-- Namun, secara konseptual:
-- io.input("input.txt") -- Mengubah input default ke file "input.txt"
-- local baris_dari_file = io.read("*l") -- Membaca baris pertama dari "input.txt"
-- io.input(io.stdin) -- Mengembalikan input default ke stdin
```

**Penjelasan Sintaks:**

- `io.write("...")`:
  - `io.write`: Fungsi dari pustaka `io` untuk menulis data.
  - `"..."`: String yang akan ditulis.
  - `\n`: Karakter baris baru.
- `local success, err_msg = io.output("output.txt")`:
  - `io.output("output.txt")`: Mencoba untuk mengatur "output.txt" sebagai file output default.
    - Jika berhasil, ia mengembalikan `true` (atau file handle jika berhasil).
    - Jika gagal (misalnya karena masalah izin), ia mengembalikan `nil` diikuti pesan error.
  - `local success, err_msg`: Variabel `success` akan menampung nilai boolean (true/false) atau file handle, dan `err_msg` akan menampung pesan error jika ada. Ini adalah contoh dari multiple assignment di Lua.
- `if success then ... else ... end`: Struktur kondisional standar.
- `io.output(io.stdout)`: Mengembalikan output file default kembali ke standard output. `io.stdout` adalah file handle untuk stdout.
- `io.read()`: Membaca dari input file default.

**Complete Model (Explicit File Descriptors):**

- **Konsep**: Model ini memberi Anda kontrol penuh atas operasi file. Anda secara eksplisit membuka file menggunakan `io.open()`, yang mengembalikan sebuah _file handle_ (atau file descriptor). Semua operasi pada file tersebut (membaca, menulis, mencari posisi, menutup) dilakukan menggunakan metode pada file handle ini (misalnya, `file:read()`, `file:write()`, `file:close()`).
- **Terminologi**:
  - **Explicit File Descriptors**: "Explicit" berarti dinyatakan secara jelas. Anda secara manual mendapatkan dan menggunakan file handle.
  - **File Handle**: Sebuah objek yang merepresentasikan file yang terbuka. Objek ini memiliki metode-metode untuk berinteraksi dengan file. Di Lua, ini sering disebut sebagai `userdata` tipe `file`.
- **Kelebihan**: Jauh lebih fleksibel dan kuat. Anda dapat:
  - Bekerja dengan banyak file secara bersamaan.
  - Memiliki kontrol presisi atas mode pembukaan file (baca saja, tulis saja, tambah, binary, dll.).
  - Melakukan operasi acak seperti `seek`.
  - Menangani error dengan lebih baik untuk setiap operasi file.
- **Kapan digunakan**: Hampir selalu lebih disukai untuk operasi file yang lebih dari sekadar input/output konsol sederhana, terutama jika melibatkan banyak file atau membutuhkan kontrol spesifik.

**Contoh Sederhana (Complete Model):**

```lua
-- Membuka file untuk ditulis (write mode 'w')
local file, err_open = io.open("contoh.txt", "w")

if not file then
    io.stderr:write("Gagal membuka file untuk ditulis: " .. err_open .. "\n")
else
    -- Menulis ke file menggunakan file handle
    local bytes_written, err_write = file:write("Halo dari Complete Model!\n")
    if not bytes_written then
        io.stderr:write("Gagal menulis ke file: " .. err_write .. "\n")
    else
        print("Berhasil menulis " .. bytes_written .. " bytes ke contoh.txt")
    end

    -- Penting untuk menutup file setelah selesai
    local success_close, err_close = file:close()
    if not success_close then
        io.stderr:write("Gagal menutup file: " .. err_close .. "\n")
    else
        print("File contoh.txt berhasil ditutup.")
    end
end

-- Membuka file untuk dibaca (read mode 'r')
local file_baca, err_open_baca = io.open("contoh.txt", "r")

if not file_baca then
    io.stderr:write("Gagal membuka file untuk dibaca: " .. (err_open_baca or "unknown error") .. "\n")
else
    -- Membaca seluruh konten file
    local konten, err_read = file_baca:read("*a") -- "*a" atau "*all" untuk membaca semua
    if not konten and err_read then -- Periksa apakah konten nil DAN ada error
        io.stderr:write("Gagal membaca dari file: " .. err_read .. "\n")
    elseif konten then
        print("Isi file contoh.txt:")
        print(konten)
    else
        print("File kosong atau gagal membaca tanpa pesan error eksplisit.")
    end

    -- Menutup file
    file_baca:close()
end
```

**Penjelasan Sintaks:**

- `local file, err_open = io.open("contoh.txt", "w")`:
  - `io.open()`: Fungsi untuk membuka file.
    - Argumen pertama: `"contoh.txt"` (string) adalah nama file yang akan dibuka.
    - Argumen kedua: `"w"` (string) adalah mode pembukaan file. `"w"` berarti "write mode" (mode tulis). Jika file sudah ada, isinya akan dihapus. Jika file belum ada, akan dibuat file baru.
  - Mengembalikan dua nilai: file handle jika berhasil (disimpan di `file`), atau `nil` jika gagal. Jika gagal, nilai kedua adalah pesan error (disimpan di `err_open`).
- `if not file then ... end`: Memeriksa apakah pembukaan file gagal. `not file` akan `true` jika `file` adalah `nil`.
- `file:write("...")`:
  - `file`: File handle yang didapat dari `io.open()`.
  - `:write()`: Metode yang dipanggil pada file handle `file` untuk menulis data.
  - Mengembalikan jumlah byte yang ditulis jika berhasil, atau `nil` dan pesan error jika gagal.
- `file:close()`:
  - Metode untuk menutup file yang terkait dengan file handle `file`. Penting untuk selalu menutup file setelah selesai digunakan untuk memastikan semua data ditulis ke disk dan sumber daya sistem dilepaskan.
  - Mengembalikan `true` jika berhasil, atau `nil` dan pesan error jika gagal.
- `io.open("contoh.txt", "r")`: Membuka file dalam "read mode" (`"r"`). Hanya bisa membaca, tidak bisa menulis.
- `file_baca:read("*a")`:
  - `:read()`: Metode untuk membaca dari file handle.
  - `"*a"` (atau `"*all"`): Argumen yang memberitahu Lua untuk membaca seluruh isi file.
  - Mengembalikan konten file sebagai string jika berhasil, atau `nil` dan pesan error jika gagal.
- `err_open_baca or "unknown error"`: Ini adalah idiom Lua. Jika `err_open_baca` adalah `nil` atau `false` (yang tidak akan terjadi untuk pesan error string, tapi ini praktik yang baik), maka nilai `"unknown error"` akan digunakan.

**Sumber Referensi dari Kurikulum:**

- [Lua-users Wiki: IO Library Tutorial](http://lua-users.org/wiki/IoLibraryTutorial) (Sumber ini memberikan gambaran umum yang baik tentang kedua model ini).
- Referensi lebih spesifik untuk Simple Model dan Complete Model akan muncul di bagian-bagian berikutnya dari kurikulum.

Pemahaman awal tentang kedua model ini akan membantu Anda memilih pendekatan yang tepat saat Anda mulai menulis kode yang melibatkan I/O. Untuk sebagian besar aplikasi yang berinteraksi dengan file, **Complete Model** lebih direkomendasikan karena kontrol dan penanganan error yang lebih baik. **Simple Model** berguna untuk skrip cepat atau interaksi konsol dasar.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][2]**
> - **[Kurikulum][3]**
> - **[Domain Spesifik][4]**

[4]: ../../../../../../README.md
[3]: ../../../../README.md
[2]: ../input-dasar-dari-pengguna/README.md
[1]: ../README.md/#1-konsep-dasar-inputoutput
