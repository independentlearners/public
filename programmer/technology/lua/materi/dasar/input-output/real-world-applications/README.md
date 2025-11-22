# **[11. Real-world Applications][0]**

> _(Catatan: Pada kurikulum tidak menyertakan sumber referensi spesifik untuk bagian ini. Penjelasan berikut didasarkan pada penerapan praktis dari konsep-konsep yang telah dibahas sebelumnya.)_

Pada bagian ini, kita akan menggabungkan semua teknik I/O, pola desain, dan praktik terbaik yang telah kita diskusikan untuk membangun komponen aplikasi yang fungsional dan sering ditemui dalam pengembangan perangkat lunak.

### 11.1 Configuration File Handling

**Deskripsi Konkret:**
Hampir setiap aplikasi yang kompleks memerlukan konfigurasi—pengaturan seperti nama host database, port server, kunci API, atau mode debug. Menyimpan pengaturan ini di dalam kode (_hardcoding_) adalah praktik yang buruk. Sebaliknya, kita menyimpannya di file konfigurasi eksternal. Tugas umum adalah membaca konfigurasi ini saat aplikasi dimulai dan terkadang menuliskannya kembali jika ada perubahan.

**Reading config files:**
Ini melibatkan pembukaan file konfigurasi, membaca baris per baris, dan mengurai setiap baris (biasanya format `key = value`) untuk mengisi sebuah tabel Lua yang akan menyimpan semua pengaturan.

**Writing configuration back:**
Ini adalah proses kebalikannya: mengiterasi tabel konfigurasi di Lua dan menulis setiap pasangan kunci-nilai kembali ke file, seringkali dengan format yang rapi dan komentar.

**Format-specific handling (JSON-like, INI-like):**

- **INI-like**: Format sederhana berbasis `key = value`, terkadang dengan seksi `[section_name]`. Sangat mudah diurai dengan `string.match` seperti yang telah kita lihat.
- **JSON (JavaScript Object Notation)**: Format yang sangat populer untuk konfigurasi dan API. Strukturnya lebih kompleks (mendukung objek bersarang, array, boolean, null). Mengurai dan membuat JSON secara manual di Lua sangat tidak disarankan karena rumit dan rentan error. **Solusi standar** untuk ini adalah menggunakan pustaka eksternal yang andal seperti `dkjson` (murni Lua) atau `lua-cjson` (lebih cepat, berbasis C).

**Contoh Kode (Pengelola Konfigurasi INI-like):**

```lua
-- File: config_manager.lua

local ConfigManager = {}

-- Membaca file .conf dan memuatnya ke dalam tabel
function ConfigManager.load(filename)
    local config = {}
    local file, err = io.open(filename, "r")
    if not file then
        return nil, "Gagal membuka file config: " .. (err or "")
    end

    for line in file:lines() do
        -- Pola key = value, dengan trim spasi dan mengabaikan komentar '#'
        local key, value = string.match(line, "^%s*([%w_]+)%s*=%s*([^#]+)")
        if key then
            -- Trim spasi dari value
            value = value:match("^%s*(.-)%s*$")
            config[key] = value
        end
    end
    file:close()
    return config
end

-- Menyimpan tabel konfigurasi kembali ke file
function ConfigManager.save(filename, config_table, header_comment)
    local file, err = io.open(filename, "w")
    if not file then
        return false, "Gagal menyimpan file config: " .. (err or "")
    end

    if header_comment then
        file:write("# " .. header_comment .. "\n\n")
    end

    for key, value in pairs(config_table) do
        file:write(string.format("%s = %s\n", key, tostring(value)))
    end

    file:close()
    return true
end

-- --- Demo Penggunaan ---
-- 1. Membuat file konfigurasi dummy
local initial_config = {
    hostname = "localhost",
    port = 3306,
    db_user = "root",
    enable_cache = true
}
ConfigManager.save("app.conf", initial_config, "Konfigurasi Aplikasi Database")
print("File 'app.conf' telah dibuat.")

-- 2. Membaca konfigurasi dari file
local loaded_config, err_load = ConfigManager.load("app.conf")
if not loaded_config then
    io.stderr:write(err_load .. "\n")
else
    print("\nKonfigurasi berhasil dimuat:")
    for k,v in pairs(loaded_config) do print(string.format("  - %s: %s", k, v)) end

    -- 3. Memodifikasi dan menyimpan kembali
    loaded_config.port = 3307 -- Ubah port
    loaded_config.db_user = "app_user" -- Ubah user
    loaded_config.timeout = 30 -- Tambah key baru

    ConfigManager.save("app.conf", loaded_config, "Konfigurasi yang Diperbarui")
    print("\nKonfigurasi telah dimodifikasi dan disimpan kembali ke 'app.conf'.")
end

os.remove("app.conf") -- Membersihkan
```

**Penjelasan Kode**:

- **`ConfigManager.load`**: Menggunakan `io.open` dan `file:lines()` untuk membaca file. Pola `string.match` yang lebih canggih digunakan untuk menangani spasi di sekitar `=` dan mengabaikan komentar.
- **`ConfigManager.save`**: Menggunakan `io.open` mode `"w"`, iterasi `pairs()` pada tabel, dan `string.format` untuk menulis konfigurasi dengan rapi. Ini menunjukkan siklus penuh baca-modifikasi-tulis.

---

### 11.2 Log File Management

**Deskripsi Konkret:**
Logging (pencatatan) adalah proses merekam kejadian-kejadian penting saat aplikasi berjalan. Ini sangat vital untuk debugging, memantau kesehatan aplikasi, dan audit keamanan. Pengelolaan file log melibatkan penulisan log secara efisien dan mencegah file log tumbuh tanpa batas.

**Writing structured logs:**
Daripada hanya mencetak pesan, log yang baik memiliki struktur: timestamp, level (INFO, DEBUG, WARN, ERROR), dan pesan itu sendiri. Ini membuat log lebih mudah dibaca, difilter, dan dianalisis secara otomatis.

**Log rotation concepts:**
Jika aplikasi berjalan terus-menerus, file lognya bisa menjadi sangat besar (banyak gigabyte). _Log rotation_ adalah strategi untuk mengelola ini dengan mengarsipkan file log saat ini secara berkala (misalnya, setiap hari atau ketika ukurannya mencapai batas tertentu) dan memulai file log yang baru.

**Performance considerations:**
Menulis ke file adalah operasi yang relatif lambat. Jika aplikasi Anda menangani ribuan permintaan per detik, menulis ke file log untuk setiap permintaan bisa menjadi _bottleneck_ performa yang serius. Seperti yang dibahas di bagian optimasi, solusinya adalah dengan melakukan _buffering_ atau _batching_: kumpulkan pesan log di memori dan tulis ke file dalam satu blok besar secara berkala.

**Contoh Kode (Logger Sederhana dengan Rotasi saat Startup):**

```lua
-- File: simple_logger.lua

local Logger = {}
Logger.filename = "app.log"
Logger.log_level = "INFO" -- Level minimum untuk dicatat

local levels = { DEBUG=1, INFO=2, WARN=3, ERROR=4 }

-- Inisialisasi logger, termasuk rotasi
function Logger.init(filename)
    Logger.filename = filename or Logger.filename

    -- Konsep Rotasi Sederhana: saat startup, arsipkan log lama jika ada
    local old_log, err = io.open(Logger.filename, "r")
    if old_log then
        old_log:close() -- Tutup handle pengecekan
        local archive_name = Logger.filename .. ".1"
        -- Hapus arsip yang lebih lama jika ada
        local old_archive = io.open(archive_name, "r")
        if old_archive then
            old_archive:close()
            os.remove(archive_name)
        end
        os.rename(Logger.filename, archive_name)
        print(string.format("Logger: Log lama '%s' diarsipkan ke '%s'",
            Logger.filename, archive_name))
    end
end

-- Fungsi utama untuk menulis log
function Logger.log(level, message)
    level = string.upper(level)
    -- Jangan catat pesan di bawah level yang ditetapkan
    if (levels[level] or 0) < (levels[Logger.log_level] or 99) then
        return
    end

    -- Buka file dalam mode 'append' (tambah di akhir)
    local file, err = io.open(Logger.filename, "a")
    if not file then
        io.stderr:write("Gagal membuka file log: " .. (err or "") .. "\n")
        return
    end

    -- Buat entri log terstruktur
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local log_entry = string.format("[%s] [%s]: %s\n", timestamp, level, message)

    file:write(log_entry)
    file:close()
end

-- --- Demo Penggunaan ---
Logger.init("my_app.log")

Logger.log("INFO", "Aplikasi dimulai.")
Logger.log("DEBUG", "Ini pesan debug, seharusnya tidak muncul.") -- Karena level INFO
Logger.log("WARN", "Koneksi database lambat.")
Logger.log("ERROR", "Gagal memproses permintaan #12345.")
Logger.log("INFO", "Aplikasi selesai.")

print("\nPesan log telah ditulis ke 'my_app.log'.")
print("Jika Anda menjalankan ini lagi, 'my_app.log' akan menjadi 'my_app.log.1'")

-- Membersihkan
os.remove("my_app.log")
local f_archive = io.open("my_app.log.1", "r")
if f_archive then
    f_archive:close()
    os.remove("my_app.log.1")
end
```

**Penjelasan Kode**:

- **`Logger.init`**: Mengimplementasikan rotasi sederhana. Ia memeriksa apakah file log lama ada. Jika ya, ia mengganti namanya menjadi `.1` sebelum aplikasi mulai menulis log baru.
- **`Logger.log`**:
  - Memeriksa level log sebelum melakukan apa pun.
  - Membuka file dalam mode **`"a"` (append)**, yang sangat penting untuk logging agar tidak menimpa entri lama.
  - Menggunakan `os.date()` untuk mendapatkan timestamp dan `string.format()` untuk membuat entri log yang terstruktur dan mudah dibaca.
  - Menutup file setiap kali. _Catatan_: Untuk performa tinggi, Anda akan memodifikasi ini untuk menyimpan file handle tetap terbuka atau menggunakan buffer.

---

### 11.3 Data Processing Pipelines

**Deskripsi Konkret:**
Pipa pemrosesan data, sering disebut alur kerja **ETL (Extract, Transform, Load)**, adalah inti dari banyak aplikasi backend dan analisis data.

- **Extract**: Membaca data dari satu atau lebih sumber (misalnya, file CSV mentah, database, API).
- **Transform**: Membersihkan, memvalidasi, menggabungkan, mengagregasi, atau mengubah data mentah menjadi format yang lebih berguna.
- **Load**: Menulis data yang telah ditransformasi ke tujuan akhir (misalnya, database lain, file laporan, gudang data).

Lua, dengan kecepatannya dan kemudahan manipulasi tabel/string, sangat cocok untuk tugas-tugas ETL skala kecil hingga menengah.

**Contoh Kode (Pipa ETL Sederhana):**
Skenario: Kita mendapatkan file `sales_raw.csv` yang datanya kotor. Kita perlu membersihkannya dan menghasilkan `sales_summary.txt`.

**File `sales_raw.csv`:**

```
 SKU,ITEM, JUMLAH, HARGA SATUAN
SKU-001,Buku, 20 , 5100
 SKU-002, Pensil, 50,1450
invalid-line
SKU-001,Buku, 15,5150
SKU-003,Tas, 5, 75000
```

```lua
-- File: etl_pipeline.lua

-- 1. EXTRACT: Membaca data mentah baris per baris.
--    Kita akan menggunakan iterator agar efisien memori.
function extract_sales_data(filename)
    local file, err = io.open(filename, "r")
    if not file then error("Sumber data tidak ditemukan: " .. filename) end
    return file:lines()
end

-- 2. TRANSFORM: Membersihkan dan memproses setiap baris.
function transform_and_aggregate(iterator)
    local aggregated_data = {} -- { ["SKU-001"] = {total_terjual=..., total_pendapatan=...}, ... }

    for line in iterator do
        -- Pola untuk mengekstrak, perhatikan spasi opsional di sekitar data.
        local sku, item, jumlah, harga = line:match("^%s*([^,]+),%s*([^,]+),%s*([^,]+),%s*([^,]+)%s*$")

        -- Validasi dan pembersihan data
        if sku and jumlah and harga then
            sku = sku:match("^%s*(.-)%s*$") -- Trim spasi
            jumlah = tonumber(jumlah)
            harga = tonumber(harga)

            -- Hanya proses data yang valid
            if sku:match("^SKU%-%d+$") and jumlah and harga then
                -- Inisialisasi jika SKU baru
                if not aggregated_data[sku] then
                    aggregated_data[sku] = {
                        item_name = item:match("^%s*(.-)%s*$"), -- Simpan nama item
                        total_terjual = 0,
                        total_pendapatan = 0
                    }
                end

                -- Agregasi data
                aggregated_data[sku].total_terjual = aggregated_data[sku].total_terjual + jumlah
                aggregated_data[sku].total_pendapatan = aggregated_data[sku].total_pendapatan + (jumlah * harga)
            end
        end
    end
    return aggregated_data
end

-- 3. LOAD: Menulis data yang sudah diagregasi ke file laporan.
function load_summary_report(filename, data)
    local file, err = io.open(filename, "w")
    if not file then error("Gagal membuat file laporan: " .. filename) end

    file:write("Laporan Ringkasan Penjualan\n")
    file:write("===========================\n")

    for sku, info in pairs(data) do
        local line = string.format("SKU: %-10s Item: %-10s Terjual: %-5d Pendapatan: Rp %d\n",
            sku, info.item_name, info.total_terjual, info.total_pendapatan)
        file:write(line)
    end

    file:close()
end


-- --- Jalankan Pipa ETL ---
print("Menjalankan Pipa ETL...")
pcall(function()
    -- Buat file data mentah
    local f = io.open("sales_raw.csv", "w")
    f:write(" SKU,ITEM, JUMLAH, HARGA SATUAN\n")
    f:write("SKU-001,Buku, 20 , 5100\n")
    f:write(" SKU-002, Pensil, 50,1450\n")
    f:write("invalid-line\n")
    f:write("SKU-001,Buku, 15,5150\n")
    f:write("SKU-003,Tas, 5, 75000 \n")
    f:close()

    -- Jalankan setiap langkah
    local lines_iterator = extract_sales_data("sales_raw.csv")
    local transformed_data = transform_and_aggregate(lines_iterator)
    load_summary_report("sales_summary.txt", transformed_data)

    print("Pipa ETL selesai. Silakan cek 'sales_summary.txt'.")
end)

-- Membersihkan
os.remove("sales_raw.csv")
os.remove("sales_summary.txt")

```

**Penjelasan Kode**:

- **Extract**: Fungsi `extract_sales_data` hanya bertanggung jawab untuk membuka file dan mengembalikan iterator `file:lines()`. Sederhana dan efisien.
- **Transform**: Fungsi `transform_and_aggregate` adalah intinya. Ia menerima iterator, melakukan loop, dan untuk setiap baris:
  - Mencoba mengurai data menggunakan `string.match`.
  - Membersihkan data (menghilangkan spasi dengan `trim`).
  - Memvalidasi data (memastikan `tonumber` berhasil dan SKU memiliki format yang benar).
  - Melakukan agregasi dengan menjumlahkan data untuk SKU yang sama dalam sebuah tabel.
- **Load**: Fungsi `load_summary_report` mengambil data yang sudah bersih dan teragregasi, lalu menggunakan `string.format` untuk menulis laporan yang rapi ke file tujuan.
- **Orkestrasi**: Bagian utama skrip memanggil ketiga fungsi ini secara berurutan, mengalirkan data dari satu tahap ke tahap berikutnya.

#

Contoh-contoh ini menunjukkan bagaimana I/O bukan hanya tentang membaca atau menulis, tetapi merupakan fondasi untuk membangun aplikasi yang berguna dan andal. Selanjutnya kita akan membahas "Integration dengan Other Systems".

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../best-practies-design-pattern/README.md
[selanjutnya]: ../integrations-dengan-other-systems/README.md

<!----------------------------------------------------->

[0]: ../../input-output/README.md#11-real-world-applications
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
