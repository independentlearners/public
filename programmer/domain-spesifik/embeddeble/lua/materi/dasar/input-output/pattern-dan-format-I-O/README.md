# 6. Pattern dan Format I/O

Sejauh ini kita telah membaca dan menulis data sebagai blok teks, baris per baris, atau sejumlah karakter. Namun, di dunia nyata, data seringkali memiliki struktur tertentu—seperti file CSV, file konfigurasi, atau log. Bagian ini akan membahas cara mengenali (parsing) pola data saat membaca dan cara memformat data secara presisi saat menulis.

*(Catatan: Kurikulum Anda tidak menyertakan sumber referensi spesifik untuk bagian ini. Penjelasan berikut didasarkan pada pustaka `string` standar Lua, yang merupakan bagian inti dari bahasa tersebut. Anda selalu dapat merujuk ke Dokumentasi Resmi Lua untuk detail lebih lanjut tentang fungsi `string`.)*

### 6.1 Reading Patterns

**Deskripsi Konkret:**
Membaca pola berarti mengurai (parsing) data mentah (biasanya string) untuk mengekstrak informasi yang bermakna. Daripada hanya mendapatkan sebaris teks, Anda ingin mengambil bagian-bagian spesifik dari baris tersebut, seperti nama pengguna, ID, dan tanggal dari sebuah baris log. Alat utama untuk ini di Lua adalah fungsi `string.match()` yang dikombinasikan dengan operasi I/O.

**Pattern untuk membaca data terstruktur:**
* **Konsep**: Data terstruktur adalah data yang diorganisir dalam format yang dapat diprediksi. Contoh:
    * **CSV (Comma-Separated Values)**: `Alice,30,alice@email.com`
    * **Key-Value**: `hostname = server01`
    * **Log**: `[2025-06-07 10:30:00] [INFO] User 'bob' logged in.`
* **Strategi**: Pola umumnya adalah membaca file baris per baris (menggunakan `file:lines()`), lalu pada setiap baris, gunakan fungsi `string.match()` untuk mengekstrak data yang Anda butuhkan.

**Menggunakan `string.match()` dengan I/O:**
* **`string.match()`**: Fungsi ini mencoba mencocokkan sebuah *pattern* (pola) di dalam sebuah string.
* **Sintaks**: `local capture1, capture2, ... = string.match(s, pattern)`
    * `s`: String sumber tempat pencarian dilakukan.
    * `pattern`: String yang mendeskripsikan pola yang dicari.
    * `capture1, ...`: Jika pola mengandung *captures* `()`, fungsi ini akan mengembalikan bagian-bagian dari string yang cocok dengan *captures* tersebut. Jika tidak ada *captures*, ia mengembalikan seluruh bagian yang cocok. Jika tidak ada yang cocok, ia mengembalikan `nil`.
* **Dasar-dasar Lua Patterns (Pola Lua)**:
    * Pola di Lua mirip tetapi **tidak sama** dengan Regular Expressions (Regex) standar. Mereka lebih sederhana namun tetap kuat.
    * **Karakter Dasar**: Cocok dengan dirinya sendiri (misalnya, `a` cocok dengan "a").
    * **Class Karakter**:
        * `%d`: cocok dengan digit (angka).
        * `%w`: cocok dengan karakter alfanumerik (huruf dan angka).
        * `%s`: cocok dengan spasi (spasi, tab, newline).
        * `%a`: cocok dengan huruf.
        * `.` (titik): cocok dengan karakter *apa pun*.
    * **Pengulang (Repeats)**:
        * `*`: cocok dengan 0 atau lebih pengulangan dari class sebelumnya. Bersifat *greedy* (mencoba mencocokkan sebanyak mungkin).
        * `+`: cocok dengan 1 atau lebih pengulangan. *Greedy*.
        * `-`: cocok dengan 0 atau lebih pengulangan. Bersifat *non-greedy* (mencoba mencocokkan sesedikit mungkin). Ini sangat berguna.
        * `?`: cocok dengan 0 atau 1 pengulangan (opsional).
    * **Captures `()`**: Menandai bagian dari pola yang ingin Anda ekstrak sebagai hasil.
    * **Anchors**:
        * `^`: Menandai awal dari string.
        * `$`: Menandai akhir dari string.

**Parsing CSV dan format data lainnya:**
Mari kita lihat contoh praktisnya.

**1. File Contoh `produk.csv`:**
```
ID,Nama Produk,Harga,Stok
101,Buku Tulis,5000,150
102,Pensil 2B,1500,300
103,Penghapus,1000,250
104,"Penggaris Besi, 30cm",7500,75
```
Perhatikan baris terakhir memiliki koma di dalam nama produk yang diapit tanda kutip. Parsing CSV sederhana dengan `string.match` mungkin kesulitan dengan kasus seperti ini. Untuk contoh ini, kita akan fokus pada baris-baris sederhana terlebih dahulu.

**2. File Contoh `server.conf`:**
```
# File Konfigurasi Server
hostname = webserver.example.com
port = 8080
user = admin
enable_ssl = false
```

**3. Skrip Lua (`parsing_data.lua`):**
```lua
-- 1. Parsing file CSV sederhana
print("--- Parsing produk.csv ---")
local file_csv, err_csv = io.open("produk.csv", "r")

if not file_csv then
    io.stderr:write("Gagal membuka produk.csv: " .. (err_csv or "") .. "\n")
else
    local header = file_csv:read("*l") -- Baca dan abaikan baris header
    print("Header diabaikan:", header)

    for line in file_csv:lines() do
        -- Pola untuk CSV sederhana: angka, teks, angka, angka dipisahkan koma.
        -- ^([^,]+),([^,]+),([^,]+),([^,]+)$
        -- Penjelasan Pola:
        -- ^        : Mulai dari awal baris
        -- ([^,]+)  : Capture grup 1: Satu atau lebih karakter yang BUKAN koma.
        -- ,        : Literal koma
        -- ([^,]+)  : Capture grup 2
        -- ,        : Literal koma
        -- ([^,]+)  : Capture grup 3
        -- ,        : Literal koma
        -- ([^,]+)  : Capture grup 4
        -- $        : Sampai akhir baris
        local id, nama, harga, stok = string.match(line, "^([^,]+),([^,]+),([^,]+),([^,]+)$")

        -- Penjelasan Sintaks string.match():
        -- string.match: Memanggil fungsi 'match' dari pustaka 'string'.
        -- line: String sumber (satu baris dari file CSV).
        -- "^...$": Pola yang digunakan untuk mencocokkan dan mengekstrak.
        -- local id, nama, ...: Variabel-variabel untuk menampung hasil dari capture grup.

        if id then
            print(string.format("ID: %s, Nama: %-12s, Harga: %5d, Stok: %d",
                id, nama, tonumber(harga), tonumber(stok)))
        else
            print("Baris tidak cocok dengan pola CSV sederhana: " .. line)
        end
    end
    file_csv:close()
end
-- Catatan: Pola di atas tidak akan berhasil untuk baris ke-4 karena ada koma di dalam field.
-- Ini menunjukkan keterbatasan parsing manual dan perlunya library khusus untuk format kompleks.


-- 2. Parsing file konfigurasi key-value
print("\n--- Parsing server.conf ---")
local config = {} -- Gunakan tabel untuk menyimpan konfigurasi
local file_conf, err_conf = io.open("server.conf", "r")

if not file_conf then
    io.stderr:write("Gagal membuka server.conf: " .. (err_conf or "") .. "\n")
else
    for line in file_conf:lines() do
        -- Pola untuk key = value, abaikan spasi di sekitar =
        -- ^(%w+)[%s]*=[%s]*(.+)
        -- Penjelasan Pola:
        -- ^(%w+)    : Capture grup 1: Di awal baris, satu atau lebih karakter alfanumerik (key).
        -- [%s]* : Nol atau lebih karakter spasi.
        -- =        : Literal sama dengan.
        -- [%s]* : Nol atau lebih karakter spasi.
        -- (.+)     : Capture grup 2: Satu atau lebih karakter apa pun (value) sampai akhir baris.
        local key, value = string.match(line, "^(%w+)[%s]*=[%s]*(.+)$")

        if key then
            config[key] = value
            print(string.format("Menemukan konfigurasi: %s = %s", key, value))
        end
    end
    file_conf:close()

    print("\nKonfigurasi yang tersimpan di tabel:")
    if config.hostname then
        print("Hostname:", config.hostname)
        print("Port:", config.port)
        -- tonumber() diperlukan jika kita mau menggunakan nilai ini sebagai angka
        print("Port + 10:", tonumber(config.port) + 10)
    end
end
```
**Penjelasan Kode**:
* **Parsing CSV**: Skrip membaca file `produk.csv` baris per baris. Untuk setiap baris, ia mencoba mencocokkan pola `^([^,]+),([^,]+),([^,]+),([^,]+)$`. Pola `[^,]+` adalah trik yang sangat berguna, artinya "satu atau lebih karakter yang bukan koma". Setiap `([^,]+)` adalah *capture group* yang hasilnya disimpan ke variabel `id`, `nama`, `harga`, dan `stok`.
* **Parsing Key-Value**: Untuk file `server.conf`, pola `^%w+%s*=%s*(.+)` digunakan. `^%w+` mencocokkan *key* di awal baris, `%s*=%s*` mencocokkan `=` dengan spasi opsional di sekitarnya, dan `(.+)` menangkap sisa baris sebagai *value*. Hasilnya disimpan dalam sebuah tabel Lua bernama `config`.

---

### 6.2 Output Formatting

**Deskripsi Konkret:**
Sama pentingnya dengan membaca data terstruktur, menulis data dalam format yang rapi dan konsisten juga krusial. Daripada hanya menggabungkan string dengan `..`, Anda bisa menggunakan `string.format()` untuk membuat string yang terformat dengan baik, yang kemudian bisa ditulis ke file atau ditampilkan di konsol.

**`string.format()` untuk formatted output:**
* **Konsep**: `string.format()` membuat string berdasarkan sebuah "string format" (template) dan serangkaian argumen. Ini sangat mirip dengan fungsi `printf` di bahasa C.
* **Sintaks**: `local formattedString = string.format(formatstring, arg1, arg2, ...)`
    * `formatstring`: String template yang berisi teks biasa dan *format specifiers* (penentu format) yang diawali dengan `%`.
    * `arg1, arg2, ...`: Nilai-nilai yang akan dimasukkan ke dalam *specifiers*.
* **Format Specifiers Umum**:
    * `%s`: Menggantikan dengan string.
    * `%d`: Menggantikan dengan angka integer (desimal).
    * `%f`: Menggantikan dengan angka floating-point (pecahan).
    * `%q`: Menggantikan dengan string yang diformat dengan aman sehingga bisa dibaca kembali oleh Lua (misalnya, menambahkan tanda kutip dan escape characters jika perlu).
    * `%%`: Untuk memasukkan karakter `%` secara literal.
* **Modifiers (Pengubah Format)**: Anda bisa menambahkan angka di antara `%` dan huruf specifier untuk mengontrol tampilan.
    * `%5d`: Angka integer, diratakan kanan dalam ruang selebar 5 karakter.
    * `%-10s`: String, diratakan kiri dalam ruang selebar 10 karakter.
    * `%.2f`: Angka float, ditampilkan dengan tepat 2 angka di belakang koma.
    * `%04d`: Angka integer, diberi awalan nol hingga totalnya 4 digit.

**Template-based output:**
Konsepnya adalah membuat sebuah template string, lalu mengisinya dengan data dinamis menggunakan `string.format()`. Ini membuat kode lebih bersih dan lebih mudah dikelola daripada penggabungan string yang panjang dan rumit.

**Formatted writing ke file:**
Pola kerjanya sederhana:
1.  Siapkan data yang ingin Anda tulis.
2.  Gunakan `string.format()` untuk membuat string yang rapi dari data tersebut.
3.  Gunakan `file:write()` untuk menulis string yang sudah terformat itu ke file.

**Contoh Kode (`formatted_writing.lua`):**
```lua
-- Data yang akan kita tulis
local laporan_penjualan = {
    {id=101, nama="Buku Tulis", terjual=50, pendapatan=250000},
    {id=102, nama="Pensil 2B", terjual=120, pendapatan=180000},
    {id=103, nama="Penghapus", terjual=75, pendapatan=75000},
    {id=104, nama="Penggaris Besi, 30cm", terjual=20, pendapatan=150000},
}

-- Membuka file untuk menulis laporan
local file_laporan, err_laporan = io.open("laporan_penjualan.txt", "w")

if not file_laporan then
    io.stderr:write("Gagal membuat file laporan: " .. (err_laporan or "") .. "\n")
    return
end

-- Menulis header laporan yang diformat
local header_template = "%-5s %-25s %10s %15s\n"
local header_line = string.rep("-", 58) .. "\n" -- Garis pemisah

local header_text = string.format(header_template, "ID", "Nama Produk", "Terjual", "Pendapatan (Rp)")
-- Penjelasan Sintaks string.format():
-- string.format: Memanggil fungsi format.
-- header_template: String template dengan format specifiers.
--   "%-5s" : string, rata kiri, lebar 5.
--   "%-25s": string, rata kiri, lebar 25.
--   "%10s" : string, rata kanan, lebar 10.
--   "%15s" : string, rata kanan, lebar 15.
-- "ID", "Nama Produk", ...: Argumen yang akan mengisi specifiers.

file_laporan:write(header_text)
file_laporan:write(header_line)

-- Menulis setiap baris data menggunakan loop dan template
local data_template = "%-5d %-25s %10d %15.0f\n"
local total_pendapatan = 0

for _, item in ipairs(laporan_penjualan) do
    local baris_data = string.format(data_template, item.id, item.nama, item.terjual, item.pendapatan)
    -- Penjelasan Sintaks string.format() untuk data:
    -- data_template: Template untuk baris data.
    --   "%-5d"   : integer, rata kiri, lebar 5.
    --   "%-25s"  : string, rata kiri, lebar 25.
    --   "%10d"   : integer, rata kanan, lebar 10.
    --   "%15.0f" : float, 0 angka di belakang koma, rata kanan, lebar 15.
    -- item.id, item.nama, ...: Nilai dari tabel 'item'.

    file_laporan:write(baris_data)
    total_pendapatan = total_pendapatan + item.pendapatan
end

-- Menulis total di akhir
file_laporan:write(header_line)
local total_text = string.format("%-32s %15.0f\n", "Total Pendapatan:", total_pendapatan)
file_laporan:write(total_text)

-- Tutup file
file_laporan:close()

print("File 'laporan_penjualan.txt' telah berhasil dibuat.")
-- Sekarang, coba buka file tersebut untuk melihat hasilnya.
```

**Isi `laporan_penjualan.txt` setelah skrip dijalankan:**
```
ID    Nama Produk                 Terjual   Pendapatan (Rp)
----------------------------------------------------------
101   Buku Tulis                       50          250000
102   Pensil 2B                       120          180000
103   Penghapus                        75           75000
104   Penggaris Besi, 30cm             20          150000
----------------------------------------------------------
Total Pendapatan:                          655000
```
Hasilnya adalah laporan teks yang rapi dan mudah dibaca, semuanya berkat `string.format()`.

Dengan menggabungkan kemampuan membaca pola dan memformat output, Anda dapat membuat skrip I/O yang kuat untuk memproses, mengubah, dan menghasilkan file data terstruktur, yang merupakan tugas umum dalam banyak domain pemrograman.
