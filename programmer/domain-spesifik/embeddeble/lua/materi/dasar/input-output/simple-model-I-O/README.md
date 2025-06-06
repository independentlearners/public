# **[3. Simple Model I/O (Implicit File Descriptors)][0]**

Seperti yang telah disinggung sebelumnya, Simple Model I/O di Lua menyederhanakan operasi baca/tulis dengan menggunakan konsep _input file default_ dan _output file default_. Lua secara implisit mengelola file descriptor untuk aliran ini.

### 3.1 Operasi Input Dasar

**Deskripsi Konkret:**
Dalam Simple Model, operasi input dasar dilakukan menggunakan fungsi `io.read()` yang sudah kita kenal, namun kini kita akan lebih fokus pada bagaimana ia berinteraksi dengan _input file default_ yang bisa saja bukan lagi keyboard (stdin), melainkan sebuah file. Fungsi `io.input()` digunakan untuk mengubah input file default ini.

**`io.read()` dengan berbagai mode (`*all`, `*line`, `*number`, n):**
Kita sudah membahas mode-mode ini di Bagian 2.1. Perilaku `io.read()` dengan mode-mode ini tetap sama, perbedaannya adalah sumber datanya. Jika `io.input()` telah digunakan untuk mengarahkan input ke sebuah file, maka `io.read()` akan membaca dari file tersebut, bukan dari `stdin`.

- **`*all` (atau `*a`)**: Membaca seluruh isi dari input file default saat ini, mulai dari posisi kursor hingga akhir file (EOF). Mengembalikan seluruh konten sebagai satu string.
- **`*line` (atau `*l`)**: Membaca baris berikutnya dari input file default saat ini. Mengembalikan baris tersebut sebagai string (tanpa karakter newline di akhir, umumnya). Jika sudah EOF, mengembalikan `nil`.
- **`*number` (atau `*n`)**: Membaca sebuah angka dari input file default saat ini. Melewati spasi, lalu membaca data yang bisa diinterpretasikan sebagai angka. Mengembalikan `number` jika berhasil, `nil` jika gagal.
- **`n` (angka positif)**: Membaca `n` karakter dari input file default saat ini. Mengembalikan string berisi `n` karakter, atau `nil` jika EOF tercapai sebelum `n` karakter terbaca.

**`io.input()` untuk mengatur input file:**

- **Konsep**: Fungsi `io.input()` digunakan untuk mengatur atau mengganti _input file default_.
- **Sintaks**:
  - `io.input()`: Mengembalikan file handle dari input file default saat ini.
  - `io.input(filename)`: Mencoba membuka file dengan nama `filename` dalam mode baca (`"r"`) dan menjadikannya sebagai input file default. Jika berhasil, semua operasi `io.read()` selanjutnya akan membaca dari file ini. Jika gagal (misalnya file tidak ada atau tidak ada izin baca), akan terjadi error.
  - `io.input(filehandle)`: Mengatur file handle yang sudah terbuka (misalnya dari `io.open()`) sebagai input file default.
- **Penting**: Ketika Anda mengganti input file default ke sebuah file menggunakan `io.input(filename)`, file tersebut secara implisit dibuka oleh Lua. Lua juga akan secara otomatis menutup file input default sebelumnya jika file tersebut dibuka oleh `io.input`. Namun, praktik yang lebih baik untuk pengelolaan file yang eksplisit adalah menggunakan Complete Model (`io.open()`, `file:read()`, `file:close()`).
- **Mengembalikan ke `stdin`**: Untuk mengembalikan input file default ke standard input, Anda bisa menggunakan `io.input(io.stdin)`.

**Contoh Kode:**

**1. Membuat file contoh `data.txt` (buat file ini secara manual di direktori yang sama dengan skrip Lua Anda):**
Isi `data.txt`:

```
Ini baris pertama.
Ini baris kedua.
12345
Beberapa teks lagi.
```

**2. Skrip Lua (`simple_input.lua`):**

```lua
-- Menyimpan input file default awal (biasanya stdin)
local default_stdin = io.input()
print("Input default awal adalah stdin.")

-- Mencoba mengatur "data.txt" sebagai input file default
-- Lua akan mencoba membuka "data.txt" dalam mode baca ("r") secara implisit
local status, err = pcall(function() io.input("data.txt") end)

if not status then
    io.stderr:write("Gagal mengatur 'data.txt' sebagai input: " .. (err or "unknown error") .. "\n")
    -- Jika gagal, pastikan input kembali ke stdin
    io.input(default_stdin)
else
    print("Input default sekarang adalah 'data.txt'.")

    -- Membaca baris pertama dari data.txt
    print("\nMembaca dengan *line:")
    local baris1 = io.read("*line")
    -- Penjelasan Sintaks io.read("*line"):
    -- io.read: Fungsi untuk membaca dari input file default.
    -- "*line": Mode untuk membaca satu baris.
    if baris1 then
        print("Baris 1: " .. baris1)
    else
        print("Gagal membaca baris 1 atau sudah EOF.")
    end

    -- Membaca baris kedua dari data.txt
    local baris2 = io.read("*l") -- "*l" adalah alias untuk "*line"
    if baris2 then
        print("Baris 2: " .. baris2)
    else
        print("Gagal membaca baris 2 atau sudah EOF.")
    end

    -- Membaca angka dari data.txt
    print("\nMembaca dengan *number:")
    local angka = io.read("*n")
    -- Penjelasan Sintaks io.read("*n"):
    -- "*n": Mode untuk membaca sebuah angka.
    if angka then
        print("Angka terbaca: " .. angka .. " (Tipe: " .. type(angka) .. ")")
    else
        print("Gagal membaca angka atau bukan angka pada posisi ini.")
    end

    -- Membaca 5 karakter berikutnya
    print("\nMembaca dengan angka (5 karakter):")
    local limaKarakter = io.read(5)
    -- Penjelasan Sintaks io.read(5):
    -- 5: Mode untuk membaca 5 karakter.
    if limaKarakter then
        print("Lima karakter: '" .. limaKarakter .. "'")
    else
        print("Gagal membaca 5 karakter atau EOF.")
    end

    -- Mengembalikan input default ke stdin
    io.input(default_stdin)
    print("\nInput default telah dikembalikan ke stdin.")

    -- (File "data.txt" yang dibuka implisit oleh io.input("data.txt")
    -- akan ditutup otomatis ketika io.input(default_stdin) dipanggil,
    -- atau ketika program berakhir jika tidak diubah lagi)
end

-- Meminta input dari pengguna (sekarang dari stdin lagi)
print("\nMasukkan nama Anda (dari stdin):")
local namaPengguna = io.read("*l")
if namaPengguna then
    print("Halo, " .. namaPengguna .. "!")
else
    print("Gagal membaca dari stdin atau EOF.")
end
```

**Penjelasan Kode `simple_input.lua`:**

- `local default_stdin = io.input()`:
  - `io.input()`: Tanpa argumen, fungsi ini mengembalikan file handle dari input file default saat ini (yang biasanya adalah `io.stdin` pada awal program).
  - `default_stdin`: Variabel untuk menyimpan file handle ini agar kita bisa kembali ke `stdin` nanti.
- `local status, err = pcall(function() io.input("data.txt") end)`:
  - `pcall(func, ...)`: _Protected Call_. Ini adalah cara aman untuk memanggil fungsi (`func`) yang mungkin menimbulkan error. Jika `func` berjalan tanpa error, `pcall` mengembalikan `true` diikuti hasil dari `func`. Jika `func` error, `pcall` mengembalikan `false` diikuti pesan error.
  - `function() io.input("data.txt") end`: Ini adalah fungsi anonim yang memanggil `io.input("data.txt")`. Kita menggunakan `pcall` karena `io.input("namafile")` akan error jika file tidak bisa dibuka, yang akan menghentikan skrip.
  - `io.input("data.txt")`: Mencoba membuka "data.txt" dan menjadikannya input file default.
- `if not status then ...`: Jika `pcall` mengembalikan `status` sebagai `false`, berarti ada error saat mencoba `io.input("data.txt")`.
- `io.read("*line")`, `io.read("*l")`, `io.read("*n")`, `io.read(5)`: Semua ini sekarang membaca dari "data.txt" karena itu adalah input file default.
- `io.input(default_stdin)`: Mengembalikan input file default ke `stdin` yang telah disimpan sebelumnya. Ini juga menyebabkan file "data.txt" yang dibuka oleh `io.input` sebelumnya ditutup.
- `local namaPengguna = io.read("*l")`: Sekarang `io.read()` akan membaca dari `stdin` lagi.

**Sumber Referensi dari Kurikulum:**

- [Programming in Lua: Simple I/O Model](https://www.lua.org/pil/21.1.html) (Sumber ini menjelaskan secara detail tentang Simple Model I/O, termasuk `io.input` dan `io.read`).
- Dokumentasi Resmi Lua:
  - [`io.input`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%23pdf-io.input%5D(https://www.lua.org/manual/5.4/manual.html%23pdf-io.input)>)
  - [`io.read`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%23pdf-io.read%5D(https://www.lua.org/manual/5.4/manual.html%23pdf-io.read)>)

Meskipun Simple Model ini terlihat mudah untuk beberapa kasus, penting untuk diingat bahwa pengelolaan file yang implisit bisa menjadi sumber kebingungan, terutama terkait kapan file dibuka dan ditutup. Untuk kontrol yang lebih baik, Complete Model lebih disarankan.

---

### 3.2 Operasi Output Dasar

**Deskripsi Konkret:**
Serupa dengan operasi input, Simple Model juga menyediakan cara mudah untuk melakukan output menggunakan fungsi `io.write()`. Output ini akan diarahkan ke _output file default_, yang awalnya adalah `stdout` (layar konsol). Fungsi `io.output()` digunakan untuk mengubah output file default ini.

**`io.write()` untuk menulis output:**

- **Konsep**: Fungsi `io.write()` menulis satu atau lebih argumen string (atau angka, yang akan dikonversi ke string) ke output file default saat ini. Berbeda dengan `print()`, `io.write()` tidak menambahkan karakter pemisah (seperti spasi atau tab) antar argumen dan tidak menambahkan karakter newline (`\n`) di akhir output secara otomatis. Anda harus menyertakannya secara eksplisit jika dibutuhkan.
- **Sintaks**: `io.write(arg1, arg2, ...)`
  - `arg1, arg2, ...`: Satu atau lebih nilai (string atau number) yang akan ditulis.
- **Return Value**: `io.write()` tidak mengembalikan nilai pada kesuksesan (atau lebih tepatnya, mengembalikan `true` jika operasi berhasil, tetapi biasanya nilai ini tidak ditangkap). Jika terjadi error, ia akan mengembalikan `nil` diikuti pesan error (meskipun dalam Simple Model, error I/O seringkali langsung menghentikan program jika tidak ditangani dengan `pcall` pada operasi seperti `io.output`).

**`io.output()` untuk mengatur output file:**

- **Konsep**: Fungsi `io.output()` digunakan untuk mengatur atau mengganti _output file default_.
- **Sintaks**:
  - `io.output()`: Mengembalikan file handle dari output file default saat ini.
  - `io.output(filename)`: Mencoba membuka file dengan nama `filename` dalam mode tulis (`"w"`) dan menjadikannya sebagai output file default. Jika file sudah ada, **isinya akan terhapus (overwrite)**. Jika file belum ada, akan dibuat file baru. Semua operasi `io.write()` dan `print()` selanjutnya akan menulis ke file ini. Jika gagal (misalnya karena masalah izin tulis), akan terjadi error.
  - `io.output(filehandle)`: Mengatur file handle yang sudah terbuka (misalnya dari `io.open()`) sebagai output file default.
- **Mengembalikan ke `stdout`**: Untuk mengembalikan output file default ke standard output, Anda bisa menggunakan `io.output(io.stdout)`.
- **Penting**: Sama seperti `io.input()`, ketika `io.output(filename)` digunakan, file dibuka secara implisit. Lua akan menutup output file default sebelumnya jika dibuka oleh `io.output`.

**`print()` vs `io.write()` - perbedaan dan kapan menggunakan:**

- **`print()`**:
  - **Tujuan Utama**: Untuk output yang cepat dan mudah dibaca manusia, biasanya ke konsol.
  - **Formatting**: Secara otomatis mengkonversi semua argumennya ke string. Jika ada beberapa argumen, `print()` akan menyisipkan karakter tab (`\t`) di antaranya. Setelah semua argumen dicetak, `print()` selalu menambahkan karakter newline (`\n`) di akhir.
  - **Output Default**: Selalu menulis ke output file default saat ini (`io.stdout` pada awalnya, atau file yang diset oleh `io.output()`).
  - **Contoh**: `print("Halo", "Dunia", 123)` akan menghasilkan: `Halo\tDunia\t123\n`
- **`io.write()`**:
  - **Tujuan Utama**: Untuk kontrol output yang lebih presisi, terutama saat menulis ke file atau ketika format output spesifik dibutuhkan (tanpa tambahan tab atau newline otomatis).
  - **Formatting**: Hanya menulis argumen apa adanya (setelah dikonversi ke string jika berupa angka). Tidak ada tab antar argumen, tidak ada newline di akhir kecuali Anda menambahkannya secara eksplisit.
  - **Output Default**: Menulis ke output file default saat ini.
  - **Contoh**: `io.write("Halo", "Dunia", 123)` akan menghasilkan: `HaloDunia123`
  - **Contoh dengan format**: `io.write("Halo, Dunia!\nNilai: ", 123, "\n")` akan menghasilkan:
    ```
    Halo, Dunia!
    Nilai: 123
    ```

**Kapan Menggunakan yang Mana?**

- Gunakan `print()` untuk:
  - Debugging cepat.
  - Menampilkan pesan status atau hasil sederhana ke konsol.
  - Ketika Anda ingin setiap output berada di baris baru dan tidak masalah dengan adanya tab antar item.
- Gunakan `io.write()` untuk:
  - Menulis data ke file dengan format yang terkontrol.
  - Membangun output baris per baris tanpa newline otomatis.
  - Menghindari tab otomatis antar argumen.
  - Ketika Anda perlu menulis ke `io.stderr` (`io.stderr:write(...)`).

**Contoh Kode (`simple_output.lua`):**

```lua
-- Menyimpan output file default awal (biasanya stdout)
local default_stdout = io.output()
print("Output default awal adalah stdout.") -- Ini akan tampil di konsol

-- Menggunakan io.write() ke stdout
io.write("Ini ditulis dengan io.write().")
io.write(" Tanpa newline otomatis.\n") -- Harus tambah \n manual
io.write("Argumen1", "Argumen2", 100, "\n") -- Tidak ada tab antar argumen

-- Menggunakan print() ke stdout
print("Ini ditulis dengan print().", "Dengan tab dan newline otomatis.")

-- Mencoba mengatur "output_simple.txt" sebagai output file default
-- Lua akan mencoba membuka "output_simple.txt" dalam mode tulis ("w")
local status_out, err_out = pcall(function() io.output("output_simple.txt") end)

if not status_out then
    io.stderr:write("Gagal mengatur 'output_simple.txt' sebagai output: " .. (err_out or "unknown error") .. "\n")
    io.output(default_stdout) -- Kembalikan ke stdout jika gagal
else
    print("Output default sekarang adalah 'output_simple.txt'.") -- Pesan ini masuk ke file!

    -- Semua io.write dan print sekarang akan masuk ke "output_simple.txt"
    io.write("Baris pertama ditulis ke file dengan io.write().\n")
    io.write("Angka: ", 123, ", String: 'contoh'\n")
    print("Baris ini ditulis ke file dengan print().", "Ada tab di sini.")
    print("Baris terakhir di file.")

    -- Mengembalikan output default ke stdout
    -- Penting: Ini juga akan "flush" (memastikan semua data tertulis)
    -- dan menutup "output_simple.txt" yang dibuka oleh io.output().
    io.output(default_stdout)
    print("\nOutput default telah dikembalikan ke stdout.") -- Ini tampil di konsol lagi
    print("Silakan cek file 'output_simple.txt'.")
end
```

**Penjelasan Kode `simple_output.lua`:**

- `local default_stdout = io.output()`: Menyimpan `io.stdout` untuk pemulihan.
- `io.write(...)` vs `print(...)` ke konsol: Mendemonstrasikan perbedaan formatting.
- `pcall(function() io.output("output_simple.txt") end)`: Mengatur "output_simple.txt" sebagai output default. Jika file sudah ada, isinya akan ditimpa.
- `print("Output default sekarang...")`: Setelah `io.output()` berhasil, pesan ini dan output berikutnya dari `io.write` dan `print` akan ditulis ke file "output_simple.txt".
- `io.output(default_stdout)`: Mengembalikan output ke konsol. Ini juga penting karena akan menutup file "output_simple.txt" yang dibuka secara implisit oleh `io.output("output_simple.txt")`.

**Isi `output_simple.txt` setelah menjalankan skrip:**

```
Output default sekarang adalah 'output_simple.txt'.	Dengan tab dan newline otomatis.
Baris pertama ditulis ke file dengan io.write().
Angka: 123, String: 'contoh'
Baris ini ditulis ke file dengan print().	Ada tab di sini.
Baris terakhir di file.
```

_(Perhatikan bahwa pesan "Output default sekarang adalah 'output_simple.txt'." juga masuk ke file, dan ada tab setelahnya karena menggunakan `print` dengan dua argumen string, meskipun yang kedua kosong dalam contoh ini. Seharusnya `print("Output default sekarang adalah 'output_simple.txt'.")` saja jika ingin satu baris tanpa tab di file.)_
_Revisi kecil untuk `output_simple.lua` agar lebih jelas di file:_

```lua
-- ... (bagian atas sama) ...
    io.output("output_simple.txt") -- Anggap berhasil
    -- Menulis pesan konfirmasi ke file
    io.write("Output default sekarang adalah 'output_simple.txt'.\n") -- Menggunakan io.write untuk kontrol

    -- Semua io.write dan print sekarang akan masuk ke "output_simple.txt"
    io.write("Baris pertama ditulis ke file dengan io.write().\n")
    io.write("Angka: ", 123, ", String: 'contoh'\n")
    print("Baris ini ditulis ke file dengan print().", "Ada tab di sini.") -- print akan tetap memberi tab
    print("Baris terakhir di file.")
-- ... (bagian bawah sama) ...
```

_Isi `output_simple.txt` (setelah revisi):_

```
Output default sekarang adalah 'output_simple.txt'.
Baris pertama ditulis ke file dengan io.write().
Angka: 123, String: 'contoh'
Baris ini ditulis ke file dengan print().	Ada tab di sini.
Baris terakhir di file.
```

**Sumber Referensi dari Kurikulum:**

- [TutorialsPoint: Lua File I/O](https://www.tutorialspoint.com/lua/lua_file_io.htm) (Sumber ini mencakup fungsi-fungsi dasar I/O termasuk `io.write` dan `io.output`).
- Dokumentasi Resmi Lua:
  - [`io.output`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%23pdf-io.output%5D(https://www.lua.org/manual/5.4/manual.html%23pdf-io.output)>)
  - [`io.write`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%23pdf-io.write%5D(https://www.lua.org/manual/5.4/manual.html%23pdf-io.write)>)
  - [`print`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%23pdf-print%5D(https://www.lua.org/manual/5.4/manual.html%23pdf-print)>)

---

### 3.3 Iterasi dengan `io.lines()`

**Deskripsi Konkret:**
Cara yang sangat umum dan nyaman untuk memproses file teks baris per baris adalah dengan menggunakan iterator `io.lines()`. Iterator ini memungkinkan Anda untuk dengan mudah membaca setiap baris dari sebuah file (atau dari input default) dalam sebuah loop.

**Membaca file baris per baris:**

- **Konsep**: `io.lines()` adalah sebuah _iterator factory_. Artinya, ketika Anda memanggil `io.lines()`, ia mengembalikan sebuah fungsi (iterator) yang, setiap kali dipanggil, akan menghasilkan baris berikutnya dari file hingga tidak ada lagi baris yang tersisa (EOF). Ini sangat cocok digunakan dengan loop `for` generik di Lua.
- **Sintaks**:
  - `io.lines()`: Menghasilkan iterator untuk membaca baris demi baris dari _input file default saat ini_. Input file default bisa diatur menggunakan `io.input(filename)`.
  - `io.lines(filename)`: Membuka file dengan nama `filename` dalam mode baca (`"r"`) dan menghasilkan iterator untuk membaca baris demi baris dari file tersebut. File ini akan ditutup secara otomatis ketika loop selesai atau jika loop dihentikan (misalnya dengan `break`). Ini adalah cara yang lebih umum dan lebih aman untuk menggunakan `io.lines` karena pengelolaan file (buka/tutup) ditangani secara otomatis.
  - `io.lines(filename, ...formats)`: (Lua 5.2+) Anda juga bisa menyediakan format baca seperti pada `io.read()` setelah nama file. Setiap iterasi akan menghasilkan nilai sesuai format tersebut.
- **Perilaku**: Setiap baris yang dibaca tidak menyertakan karakter newline di akhirnya. Jika terjadi error saat membaca, iterator akan memunculkan error.

**Pattern dan penggunaan `io.lines()`:**
Pola paling umum adalah menggunakan `io.lines(filename)` dalam sebuah `for` loop:

```lua
for baris in io.lines("namafile.txt") do
    -- Lakukan sesuatu dengan 'baris'
    print(baris)
end
```

**Contoh Kode:**

**1. Membuat file contoh `daftar_nama.txt`:**

```
Alice
Bob
Charlie
Diana
```

**2. Skrip Lua (`baca_baris.lua`):**

```lua
-- Contoh 1: Menggunakan io.lines(filename)
print("--- Membaca daftar_nama.txt baris per baris ---")
local line_count = 0
local status_lines, err_lines = pcall(function()
    for baris in io.lines("daftar_nama.txt") do
        -- Penjelasan Sintaks:
        -- for ... in ... do ... end: Ini adalah loop for generik di Lua.
        -- baris: Variabel lokal yang akan menerima setiap baris dari iterator.
        -- io.lines("daftar_nama.txt"): Memanggil iterator factory. Ia membuka file,
        --                               dan mengembalikan fungsi iterator. Loop 'for'
        --                               akan memanggil fungsi iterator ini berulang kali.

        line_count = line_count + 1
        print("Baris " .. line_count .. ": " .. baris)
    end
    -- File "daftar_nama.txt" akan otomatis ditutup di sini,
    -- baik loop selesai normal maupun jika ada 'break' atau error di dalam loop.
end)

if not status_lines then
    io.stderr:write("Error saat memproses daftar_nama.txt: " .. (err_lines or "unknown error") .. "\n")
end
print("Jumlah baris yang dibaca: " .. line_count)


-- Contoh 2: Menggunakan io.lines() dengan input file default
print("\n--- Mengatur input default dan menggunakan io.lines() ---")
local default_input_original = io.input() -- Simpan stdin
local status_input, err_input = pcall(function() io.input("daftar_nama.txt") end)

if not status_input then
    io.stderr:write("Gagal mengatur input ke daftar_nama.txt: " .. (err_input or "unknown error") .. "\n")
    io.input(default_input_original) -- Kembalikan ke stdin
else
    print("Input default sekarang adalah 'daftar_nama.txt'. Membaca dengan io.lines():")
    local count = 0
    for baris_default in io.lines() do -- Tanpa argumen, membaca dari input default
        -- Penjelasan Sintaks:
        -- io.lines(): Tanpa argumen, menggunakan input file default saat ini.
        count = count + 1
        print("Data ke-" .. count .. ": " .. baris_default)
    end
    -- Input file default sebelumnya ("daftar_nama.txt" yang dibuka oleh io.input())
    -- TIDAK otomatis ditutup oleh io.lines() tanpa argumen.
    -- Ia akan ditutup saat io.input() berikutnya dipanggil atau program berakhir.
    io.input(default_input_original) -- Kembalikan ke stdin (ini akan menutup "daftar_nama.txt")
    print("Input dikembalikan ke stdin.")
end
```

**Penjelasan Kode `baca_baris.lua`:**

- **Contoh 1 (`io.lines("daftar_nama.txt")`)**:
  - `for baris in io.lines("daftar_nama.txt") do ... end`: Ini adalah cara yang paling direkomendasikan. `io.lines` membuka file, dan loop `for` mengiterasi setiap baris. File ditutup secara otomatis setelah loop selesai atau jika terjadi `break`/error di dalam loop.
  - `line_count = line_count + 1`: Menghitung jumlah baris.
  - `print(...)`: Mencetak nomor baris dan isinya.
  - `pcall`: Digunakan untuk menangkap potensi error saat membuka atau membaca file.
- **Contoh 2 (`io.lines()` dengan input default)**:
  - `io.input("daftar_nama.txt")`: Mengatur "daftar_nama.txt" sebagai input default.
  - `for baris_default in io.lines() do ... end`: `io.lines()` tanpa argumen akan membaca dari "daftar_nama.txt".
  - **Penting**: Dalam kasus ini, `io.lines()` sendiri tidak bertanggung jawab menutup file yang ditetapkan sebagai input default oleh `io.input()`. File tersebut akan tetap terbuka sampai `io.input()` dipanggil lagi untuk menggantinya (misalnya ke `io.stdin`) atau program berakhir. Ini adalah salah satu alasan mengapa `io.lines(filename)` lebih disukai karena penanganan file yang lebih rapi.

**Sumber Referensi dari Kurikulum:**

- [W3schools: Lua File I/O Guide](https://w3schools.tech/tutorial/lua/lua_file_io) (Sumber ini kemungkinan memberikan contoh penggunaan `io.lines`).
- Dokumentasi Resmi Lua:
  - [`io.lines`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%23pdf-io.lines%5D(https://www.lua.org/manual/5.4/manual.html%23pdf-io.lines)>)

Fungsi `io.lines()` adalah alat yang sangat berguna dan sering dipakai untuk memproses konten file teks secara efisien di Lua.

---

### 3.4 Predefined File Descriptors

**Deskripsi Konkret:**
Lua, seperti banyak bahasa pemrograman lainnya, menyediakan akses ke aliran data standar (standard streams) melalui file descriptor yang sudah terdefinisi sebelumnya. Ini adalah `io.stdin`, `io.stdout`, dan `io.stderr`. Meskipun Simple Model seringkali menggunakan ini secara implisit, Anda juga bisa merujuk dan menggunakannya secara eksplisit.

**`io.stdin`, `io.stdout`, dan `io.stderr`:**

- **`io.stdin`**:

  - **Konsep**: File handle yang merepresentasikan Standard Input. Secara default, ini terhubung ke keyboard.
  - **Penggunaan Eksplisit**: Anda bisa menggunakan metode file handle langsung padanya, misalnya `io.stdin:read("*l")` untuk membaca satu baris dari keyboard. Ini setara dengan `io.read("*l")` jika input default tidak diubah.
  - **Terminologi**: "File handle" adalah objek yang merepresentasikan file atau aliran data yang terbuka.

- **`io.stdout`**:

  - **Konsep**: File handle yang merepresentasikan Standard Output. Secara default, ini terhubung ke layar konsol/terminal.
  - **Penggunaan Eksplisit**: Anda bisa menulis langsung ke sana, misalnya `io.stdout:write("Halo\n")`. Ini mirip dengan `io.write("Halo\n")` jika output default tidak diubah. Fungsi `print()` juga menulis ke `io.stdout` secara default.

- **`io.stderr`**:

  - **Konsep**: File handle yang merepresentasikan Standard Error. Secara default, ini juga terhubung ke layar konsol/terminal. Digunakan khusus untuk pesan error dan diagnostik.
  - **Penggunaan Eksplisit**: Umumnya digunakan untuk menulis pesan error, misalnya `io.stderr:write("Terjadi kesalahan!\n")`. Ini memastikan pesan error tetap terlihat bahkan jika `stdout` dialihkan ke file.

**Menggunakan standard streams secara eksplisit:**
Meskipun fungsi Simple Model seperti `io.read()` dan `io.write()` bekerja pada input/output _default_ (yang awalnya adalah `io.stdin` dan `io.stdout`), ada kalanya Anda ingin secara eksplisit membaca dari `stdin` atau menulis ke `stdout`/`stderr` terlepas dari apa input/output default saat ini.

**Contoh Kode (`standard_streams.lua`):**

```lua
-- Menggunakan io.stdin secara eksplisit
print("Masukkan sesuatu untuk io.stdin:read():")
local data_stdin = io.stdin:read("*l") -- Selalu membaca dari keyboard (standard input)
-- Penjelasan Sintaks:
-- io.stdin: File handle untuk standard input.
-- :read("*l"): Memanggil metode 'read' pada objek io.stdin dengan format "*l".

if data_stdin then
    print("Anda mengetik (via io.stdin:read): " .. data_stdin)
else
    io.stderr:write("Gagal membaca dari io.stdin atau EOF.\n")
end

-- Menggunakan io.stdout secara eksplisit
io.stdout:write("Ini ditulis menggunakan io.stdout:write().\n")
io.stdout:write("Output ini pasti ke konsol (standard output).\n")
-- Penjelasan Sintaks:
-- io.stdout: File handle untuk standard output.
-- :write(...): Memanggil metode 'write' pada objek io.stdout.

-- Menggunakan io.stderr secara eksplisit
io.stderr:write("Ini adalah pesan error yang ditulis ke io.stderr.\n")
-- Penjelasan Sintaks:
-- io.stderr: File handle untuk standard error.
-- :write(...): Memanggil metode 'write' pada objek io.stderr.

-- Contoh skenario di mana ini berguna:
-- Misalkan output default telah diubah ke file
local status_out, err_out = pcall(function() io.output("sementara.txt") end)
if not status_out then
    io.stderr:write("Gagal mengalihkan output ke sementara.txt: " .. (err_out or "") .. "\n")
else
    print("Pesan ini masuk ke sementara.txt (karena print menggunakan output default)")
    io.stdout:write("Pesan ini TETAP ke konsol (karena io.stdout eksplisit).\n")
    io.stderr:write("Pesan error ini juga TETAP ke konsol.\n")

    -- Membersihkan: kembalikan output default dan hapus file jika perlu
    io.output(io.stdout) -- Kembalikan ke stdout (menutup sementara.txt)
    print("\nOutput kembali ke konsol. Cek 'sementara.txt'.")
    -- Untuk menghapus file sementara (akan dibahas lebih lanjut di operasi file)
    -- local os = require("os")
    -- os.remove("sementara.txt")
    -- print("'sementara.txt' telah dihapus.")
end

-- Membaca lagi dari io.stdin setelah output mungkin dialihkan
print("\nMasukkan data lagi untuk io.stdin (setelah pengalihan output):")
local data_stdin_lagi = io.stdin:read()
if data_stdin_lagi then
    print("Input terakhir dari io.stdin: " .. data_stdin_lagi)
end
```

**Penjelasan Kode `standard_streams.lua`:**

- `io.stdin:read("*l")`: Membaca satu baris langsung dari standard input, tidak peduli apa `io.input()` terakhir kali diset.
- `io.stdout:write(...)`: Menulis langsung ke standard output.
- `io.stderr:write(...)`: Menulis langsung ke standard error.
- **Skenario Pengalihan**:
  - `io.output("sementara.txt")`: Mengubah output default ke file "sementara.txt".
  - `print("Pesan ini masuk...")`: Karena `print` menggunakan output default, ini masuk ke file.
  - `io.stdout:write("Pesan ini TETAP...")`: Ini menulis ke konsol karena `io.stdout` secara eksplisit menunjuk ke sana, bukan ke output default yang telah diubah.
  - `io.stderr:write("Pesan error ini...")`: Pesan error juga tetap ke konsol.
  - `io.output(io.stdout)`: Mengembalikan output default ke konsol.

Ini menunjukkan bagaimana Anda dapat memiliki kontrol yang lebih halus bahkan dalam kerangka Simple Model jika Anda perlu memastikan input/output dari/ke aliran standar tertentu.

**Sumber Referensi dari Kurikulum:**

- [Lua-users Wiki: Predefined Descriptors](http://lua-users.org/wiki/IoLibraryTutorial) (Bagian ini dalam tutorial IoLibrary kemungkinan merujuk pada `io.stdin`, `io.stdout`, `io.stderr`).
- [Programming in Lua: Complete Model](https://www.lua.org/pil/21.2.html) (Meskipun judulnya "Complete Model", bab ini juga membahas sifat dari `io.stdin`, `io.stdout`, dan `io.stderr` sebagai file handle yang selalu tersedia).
- Dokumentasi Resmi Lua (menyebutkan `io.stdin`, `io.stdout`, `io.stderr` sebagai bagian dari pustaka `io`):
  - [Lua 5.4 Manual - `io` library](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%236.8%5D(https://www.lua.org/manual/5.4/manual.html%236.8)>)

Dengan ini, kita telah mencakup dasar-dasar Simple Model I/O. Model ini sangat berguna untuk tugas-tugas cepat dan skrip sederhana. Namun, untuk aplikasi yang lebih kompleks yang memerlukan pengelolaan file yang lebih robust dan fleksibel, kita akan beralih ke **Complete Model I/O**, yang akan menjadi topik berikutnya.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../input-dasar-dari-pengguna/README.md
[selanjutnya]: ../complete-model-I-O/README.md

<!----------------------------------------------------->

[0]: ../README.md#3-simple-model-io-implicit-file-descriptors
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
