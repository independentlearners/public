# **[12. Optimasi Performa dan Best Practices (Praktik Terbaik)][1]**

Bagian ini akan membahas manajemen memori di Lua, teknik dasar untuk profiling performa, dan serangkaian praktik terbaik yang dapat membantu Anda menulis kode Lua yang lebih cepat dan lebih mudah dipelihara untuk plugin Neovim. Optimasi Performa dan Best Practices. Menulis kode Lua yang efisien dan mengikuti praktik terbaik sangat penting, terutama dalam lingkungan seperti Neovim di mana responsivitas adalah kunci untuk pengalaman pengguna yang baik.

---

### 12.1 Memory Management (Manajemen Memori)

Lua menggunakan manajemen memori otomatis, yang membebaskan programmer dari tugas alokasi dan dealokasi memori manual. Namun, pemahaman dasar tentang cara kerjanya dapat membantu dalam menulis kode yang lebih efisien.

#### Garbage Collection (GC) (Pengumpulan Sampah)

- **Deskripsi Konsep:** Lua menggunakan _garbage collector_ (GC) otomatis untuk mengelola memori. GC secara periodik mencari dan mengklaim kembali memori yang ditempati oleh objek (seperti tabel, fungsi, string) yang tidak lagi dapat dijangkau atau digunakan oleh program. Di Lua 5.1 (basis LuaJIT yang digunakan Neovim), GC yang digunakan adalah _incremental mark-and-sweep collector_.
  - **Incremental:** GC tidak selalu menjalankan seluruh siklusnya sekaligus, yang bisa menyebabkan jeda panjang. Sebaliknya, ia bekerja dalam langkah-langkah kecil (increment) yang disisipkan selama eksekusi program normal, mengurangi jeda yang terlihat.
  - **Mark-and-Sweep:** Proses dua tahap:
    1.  **Mark (Tandai):** GC memulai dari objek-objek akar (root objects, seperti variabel global, tumpukan panggilan) dan melintasi semua objek yang dapat dijangkau, menandai mereka sebagai "hidup".
    2.  **Sweep (Sapu):** GC kemudian memeriksa semua objek di memori. Objek yang tidak ditandai (tidak terjangkau) dianggap sebagai sampah dan memorinya diklaim kembali untuk digunakan di masa depan.
- **Fungsi `collectgarbage(opt [, arg])`:**
  - **Deskripsi:** Menyediakan beberapa kontrol atas garbage collector.
  - **Sintaks Per Baris (Opsi Umum):**
    - `collectgarbage("collect")`: Memaksa siklus pengumpulan sampah penuh. Penggunaannya harus hati-hati karena dapat menyebabkan jeda.
    - `collectgarbage("count")`: Mengembalikan jumlah total memori (dalam Kilobyte) yang sedang digunakan oleh Lua.
    - `collectgarbage("step")`: Menjalankan satu langkah inkremental dari GC.
    - `collectgarbage("stop")`: Menghentikan GC (tidak disarankan kecuali untuk kasus yang sangat spesifik dan terkontrol).
    - `collectgarbage("restart")`: Memulai ulang GC jika sebelumnya dihentikan.
  - **Peringatan:** Secara umum, memanggil `collectgarbage` secara manual jarang diperlukan dan seringkali tidak disarankan dalam pengembangan plugin Neovim, karena GC Lua sudah dioptimalkan untuk bekerja secara otomatis. Intervensi manual bisa jadi kontraproduktif.
- **Implementasi dalam Neovim:** Anda biasanya tidak perlu berinteraksi langsung dengan GC. Fokus pada penulisan kode yang bersih untuk menghindari tekanan berlebih pada GC.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (`collectgarbage`): [https://www.lua.org/manual/5.1/manual.html\#pdf-collectgarbage](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%23pdf-collectgarbage)
  - Programming in Lua, 1st ed. (Chapter 17 - Garbage Collection): [https://www.lua.org/pil/17.html](https://www.lua.org/pil/17.html)

**Contoh Kode (GC):**

```lua
-- file: gc_example.lua

print("--- Manajemen Memori dan GC ---")

-- Melihat penggunaan memori awal (dalam KB)
-- collectgarbage("count") mengembalikan total memori yang digunakan oleh Lua state.
local initial_memory = collectgarbage("count")
print(string.format("Memori awal digunakan: %.2f KB", initial_memory))

-- Membuat beberapa data untuk melihat perubahan memori
local data_table = {}
for i = 1, 10000 do
    data_table[i] = "String data nomor " .. i .. " ini cukup panjang untuk alokasi memori."
end

local memory_after_data = collectgarbage("count")
print(string.format("Memori setelah alokasi data_table: %.2f KB", memory_after_data))
print(string.format("Memori yang digunakan oleh data_table (perkiraan): %.2f KB", memory_after_data - initial_memory))

-- Menghapus referensi ke data_table agar bisa di-collect oleh GC
data_table = nil
print("Referensi ke data_table dihilangkan (data_table = nil).")

-- Memaksa siklus GC penuh (biasanya tidak disarankan dalam kode produksi)
-- collectgarbage("collect") menjalankan siklus penuh dari garbage collection.
collectgarbage("collect")
print("Siklus GC penuh dipaksa.")

local memory_after_gc = collectgarbage("count")
print(string.format("Memori setelah GC: %.2f KB", memory_after_gc))
print(string.format("Memori yang dibebaskan (perkiraan): %.2f KB", memory_after_data - memory_after_gc))
```

**Cara Menjalankan Kode:**
Simpan dan jalankan dengan `lua gc_example.lua`. Output akan menunjukkan perubahan penggunaan memori. Angka pastinya bisa bervariasi.

**Penjelasan Kode Keseluruhan (GC):**

- `collectgarbage("count")`: Digunakan untuk mendapatkan ukuran memori yang sedang digunakan oleh Lua pada berbagai titik.
- Sebuah tabel besar (`data_table`) dibuat untuk mengalokasikan memori.
- `data_table = nil`: Referensi ke tabel dihilangkan. Sekarang tabel tersebut menjadi "tidak terjangkau" dan menjadi kandidat untuk GC.
- `collectgarbage("collect")`: Memaksa GC untuk berjalan. Dalam skenario nyata, GC akan berjalan secara otomatis pada waktunya.
- Perbandingan penggunaan memori sebelum dan sesudah menunjukkan bahwa GC telah membebaskan memori (meskipun tidak selalu semua memori yang dialokasikan untuk `data_table` akan langsung kembali ke sistem operasi; Lua mungkin menyimpannya untuk penggunaan internal).

#### Avoiding Memory Leaks (Menghindari Kebocoran Memori)

- **Deskripsi Konsep:** Dalam bahasa dengan GC seperti Lua, "kebocoran memori" klasik (memori yang dialokasikan dan tidak pernah bisa dibebaskan) lebih jarang terjadi. Namun, yang lebih umum adalah situasi di mana program secara tidak sengaja mempertahankan _referensi_ ke objek yang sebenarnya sudah tidak diperlukan lagi. Karena objek ini masih "terjangkau" dari suatu tempat, GC tidak dapat mengklaim kembali memorinya. Ini secara efektif adalah kebocoran memori.
- **Penyebab Umum:**
  - **Variabel Global:** Variabel global yang menyimpan data besar dan tidak pernah di-`nil`-kan.
  - **Tabel sebagai Cache Tanpa Batas:** Cache yang terus tumbuh tanpa mekanisme untuk menghapus entri lama.
  - **Closure yang Menangkap Upvalue Besar:** Fungsi closure yang hidup lama dan mempertahankan referensi ke variabel lokal (upvalue) besar dari lingkup luarnya, padahal variabel tersebut sudah tidak relevan.
  - **Referensi Siklik (Circular References):** Meskipun GC Lua modern dapat menangani siklus sederhana antar tabel, siklus yang lebih kompleks atau yang melibatkan userdata C mungkin memerlukan perhatian manual (misalnya, menggunakan _weak tables_ atau memutus siklus secara eksplisit).
- **Tips Mencegah:**
  - **Gunakan Variabel Lokal:** Selalu gunakan `local` untuk membatasi lingkup variabel.
  - **Bersihkan Referensi:** Ketika sebuah objek (terutama yang besar) dalam tabel tidak lagi diperlukan, set field tabel yang merujuk padanya ke `nil`. Contoh: `my_table.large_object = nil`.
  - **Hati-hati dengan Upvalue:** Pastikan closure tidak menangkap lebih banyak data dari lingkup luar daripada yang benar-benar dibutuhkan.
  - **Weak Tables:** Jika Anda perlu membuat cache atau asosiasi di mana keberadaan kunci atau nilai tidak boleh mencegah objek lain di-GC, pertimbangkan penggunaan _weak tables_ (metatable dengan `__mode = "k"`, `"v"`, atau `"kv"`).

**Contoh Kode (Potensi Kebocoran dan Cara Menghindari):**

```lua
-- file: memory_leak_example.lua

print("--- Menghindari Kebocoran Memori ---")

-- Skenario 1: Referensi global (hindari ini)
-- global_data_cache = {} -- Hindari variabel global jika memungkinkan
-- function add_to_global_cache(key, data)
--     global_data_cache[key] = data -- Data akan tetap di sini selamanya kecuali dihapus manual
-- end

-- Skenario 2: Referensi dalam tabel yang tidak dihapus
local my_plugin_data = {}
my_plugin_data.active_buffers = {}

function track_buffer(buffer_id, buffer_content)
    print("Melacak buffer:", buffer_id)
    my_plugin_data.active_buffers[buffer_id] = {
        id = buffer_id,
        content = buffer_content, -- Bisa jadi string besar
        timestamp = os.time()
    }
end

function untrack_buffer(buffer_id)
    print("Berhenti melacak buffer:", buffer_id)
    -- Penting: Hapus referensi agar data buffer bisa di-GC.
    -- Jika baris di bawah ini dikomentari, memori untuk buffer_content akan "bocor".
    if my_plugin_data.active_buffers[buffer_id] then
        my_plugin_data.active_buffers[buffer_id] = nil
        print("Buffer", buffer_id, "dihapus dari pelacakan.")
    else
        print("Buffer", buffer_id, "tidak ditemukan dalam pelacakan.")
    end
end

-- Simulasi penggunaan
track_buffer(1, string.rep("A", 1024*10)) -- Melacak buffer dengan konten 10KB
track_buffer(2, string.rep("B", 1024*20)) -- Melacak buffer dengan konten 20KB

print("Jumlah buffer dilacak:", #my_plugin_data.active_buffers) -- Ini akan 0 jika key bukan integer sekuensial
                                                              -- Mari kita hitung dengan pairs
local count = 0; for _ in pairs(my_plugin_data.active_buffers) do count = count + 1 end
print("Jumlah buffer dilacak (via pairs):", count)

-- Misalkan buffer 1 sudah tidak aktif lagi
untrack_buffer(1)

count = 0; for _ in pairs(my_plugin_data.active_buffers) do count = count + 1 end
print("Jumlah buffer dilacak setelah untrack(1):", count) -- Seharusnya 1
if my_plugin_data.active_buffers[1] == nil then
    print("Data untuk buffer 1 sudah nil, siap di-GC.")
end

-- Memori sebelum GC (setelah untrack)
local mem_before = collectgarbage("count")
collectgarbage("collect")
local mem_after = collectgarbage("count")
print(string.format("Memori setelah untrack dan GC: %.2f KB (perubahan: %.2f KB)", mem_after, mem_after - mem_before))
```

**Cara Menjalankan Kode:**
Simpan dan jalankan. Amati pesan log. Jika Anda mengomentari baris `my_plugin_data.active_buffers[buffer_id] = nil` di `untrack_buffer`, Anda akan mensimulasikan kebocoran (data buffer 1 tetap di memori).

**Penjelasan Kode Keseluruhan:**

- `track_buffer`: Menambahkan data (yang bisa jadi besar) ke tabel `my_plugin_data.active_buffers`.
- `untrack_buffer`: Bertujuan untuk menghapus data buffer. Baris `my_plugin_data.active_buffers[buffer_id] = nil` sangat krusial. Tanpanya, meskipun buffer sudah tidak "aktif" secara logis, referensinya masih ada di tabel `active_buffers`, sehingga GC tidak bisa membebaskan memori yang digunakan oleh konten buffer tersebut.

---

### 12.2 Performance Profiling (Profiling Performa)

- **Deskripsi Konsep:** Profiling adalah proses menganalisis performa program untuk mengidentifikasi bagian-bagian kode (disebut _bottlenecks_ atau _hotspots_) yang berjalan lambat atau mengonsumsi sumber daya secara berlebihan. Dengan mengetahui bottleneck, upaya optimasi dapat difokuskan pada area yang paling berdampak.
- **Terminologi:**
  - **Profiling:** Proses mengukur karakteristik performa kode.
  - **Bottleneck (Leher Botol):** Bagian dari program yang secara signifikan membatasi kecepatan atau efisiensi keseluruhan.
  - **Hotspot:** Bagian kode yang paling sering dieksekusi atau menghabiskan waktu CPU paling banyak.
- **Implementasi dalam Neovim:** Untuk plugin yang kompleks, profiling bisa membantu menemukan fungsi-fungsi yang lambat yang mungkin mempengaruhi responsivitas Neovim.
  - **Neovim Built-in Profiler:** Neovim memiliki profiler bawaan yang dapat diaktifkan dengan `:profile start profile.log` dan perintah terkait (`:profile func`, `:profile file`) untuk mem-profile eksekusi Vimscript dan pemanggilan fungsi Lua. Ini bisa memberikan gambaran waktu yang dihabiskan di fungsi Lua yang dipanggil dari Vimscript.
  - **`debug.sethook` (Dasar):** Pustaka `debug` Lua dapat digunakan untuk membuat profiler sederhana secara programatik, misalnya dengan menghitung berapa kali setiap fungsi dipanggil atau berapa banyak instruksi Lua yang dijalankan.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (Debug Library, `sethook`, `gethook`): [https://www.lua.org/manual/5.1/manual.html\#5.9](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%235.9)
  - Programming in Lua, 1st ed. (Chapter 23.2 - Profiles): [https://www.lua.org/pil/23.2.html](https://www.lua.org/pil/23.2.html)

**Contoh Kode (Profiler Sederhana dengan `debug.sethook`):**

```lua
-- file: simple_profiler_example.lua
print("--- Profiler Sederhana ---")

local simple_profiler_data = {
    call_counts = {},  -- Untuk menyimpan jumlah panggilan per fungsi
    is_active = false
}

-- Hook function yang akan dipanggil oleh Lua
-- 'event' bisa "call", "return", "line", "count".
local function profiler_hook(event, line_or_nil)
    if event == "call" then
        -- debug.getinfo(level, "Snl"):
        -- S: source, n: name, l: currentline
        -- Level 2: informasi tentang fungsi yang baru saja dipanggil (yang memicu hook "call")
        local func_info = debug.getinfo(2, "Sn")
        if func_info and func_info.name then
            local func_name = func_info.name
            -- Jika source adalah "[C]", itu adalah fungsi C (misalnya, print, pairs)
            if func_info.source ~= "[C]" and func_info.what == "Lua" then
                simple_profiler_data.call_counts[func_name] = (simple_profiler_data.call_counts[func_name] or 0) + 1
            end
        end
    end
end

function simple_profiler_start()
    simple_profiler_data.call_counts = {} -- Reset data
    simple_profiler_data.is_active = true
    -- debug.sethook(hook_function, mask_string, count_optional)
    -- "c": panggil hook untuk setiap event "call".
    debug.sethook(profiler_hook, "c")
    print("Profiler dimulai.")
end

function simple_profiler_stop()
    debug.sethook() -- Menghentikan hook dengan tidak memberikan argumen.
    simple_profiler_data.is_active = false
    print("Profiler dihentikan.")
end

function simple_profiler_report()
    if simple_profiler_data.is_active then
        print("Profiler masih aktif. Hentikan dulu untuk laporan akurat.")
        return
    end
    print("\n--- Laporan Profiler (Jumlah Panggilan Fungsi) ---")
    local sorted_names = {}
    for name in pairs(simple_profiler_data.call_counts) do
        table.insert(sorted_names, name)
    end
    table.sort(sorted_names, function(a, b)
        return simple_profiler_data.call_counts[a] > simple_profiler_data.call_counts[b]
    end)

    for _, name in ipairs(sorted_names) do
        print(string.format("Fungsi '%s': dipanggil %d kali", name, simple_profiler_data.call_counts[name]))
    end
end

-- Contoh fungsi untuk di-profile
function foo() print("foo dipanggil") end
function bar() print("bar dipanggil"); foo() end
function baz() print("baz dipanggil"); bar(); foo() end

-- Menggunakan profiler
simple_profiler_start()

foo()
bar()
baz()
bar()
foo()

simple_profiler_stop()
simple_profiler_report()
```

**Cara Menjalankan Kode:**
Simpan dan jalankan. Output akan menunjukkan jumlah panggilan untuk fungsi `foo`, `bar`, dan `baz`.

**Penjelasan Kode Keseluruhan (Profiler Sederhana):**

- `simple_profiler_data`: Tabel untuk menyimpan data profiling (jumlah panggilan) dan status aktif.
- `profiler_hook(event, line_or_nil)`: Fungsi hook. Jika `event` adalah `"call"`, ia mendapatkan informasi tentang fungsi yang baru saja dipanggil menggunakan `debug.getinfo(2, "Sn")` (level 2 adalah fungsi yang dipanggil). Jika itu fungsi Lua (bukan C), jumlah panggilannya diinkrementasi.
- `simple_profiler_start()`: Mengatur `profiler_hook` untuk dipanggil pada setiap event `"c"` (pemanggilan fungsi).
- `simple_profiler_stop()`: Menghapus hook.
- `simple_profiler_report()`: Mencetak laporan yang diurutkan berdasarkan jumlah panggilan.
- Fungsi `foo`, `bar`, `baz` adalah fungsi contoh yang dipanggil untuk didemonstrasikan.

**External Tools (Alat Eksternal):**
Untuk profiling yang lebih mendalam (misalnya, waktu yang dihabiskan per baris, alokasi memori), alat eksternal khusus untuk Lua (seperti `LuaProfiler` jika bisa diintegrasikan) atau profiler sistem umumnya lebih cocok. Neovim sendiri menyediakan `:profile` untuk analisis performa terkait Vimscript dan pemanggilan fungsi Lua dari Vimscript.

---

### 12.3 Best Practices untuk Kode Lua di Neovim (Praktik Terbaik)

Mengikuti praktik terbaik dapat menghasilkan kode yang lebih bersih, lebih cepat, dan lebih mudah dipelihara.

#### Local vs Global Variables (Variabel Lokal vs Global) - _Reiterasi_

- **Konsep:** Seperti yang telah dibahas sebelumnya, selalu prioritaskan penggunaan variabel lokal (`local`) daripada variabel global.
- **Alasan:**
  - **Performa:** Akses ke variabel lokal jauh lebih cepat daripada variabel global. Variabel lokal disimpan dalam register atau diakses sebagai upvalue, sedangkan variabel global memerlukan pencarian dalam tabel global `_G`.
  - **Keterbacaan dan Pemeliharaan:** Lingkup yang jelas mengurangi kemungkinan modifikasi yang tidak disengaja.
  - **Menghindari Polusi Namespace:** Mengurangi risiko tabrakan nama dengan variabel lain di Neovim atau plugin lain.
- **Sintaks:** `local nama_variabel = nilai`

#### Table Pre-allocation (Pra-alokasi Tabel)

- **Deskripsi Konsep:** Jika Anda tahu perkiraan ukuran sebuah tabel (terutama bagian array-nya) sebelumnya, menginisialisasi tabel dengan kapasitas yang cukup dapat, dalam beberapa kasus, mengurangi jumlah realokasi memori yang diperlukan saat tabel tumbuh. Setiap kali tabel Lua perlu tumbuh melebihi kapasitasnya saat ini, Lua harus mengalokasikan blok memori baru yang lebih besar dan menyalin elemen-elemen lama.
- **Implementasi dan Peringatan (Lua 5.1/LuaJIT):**
  - **Tidak Ada Fungsi Standar `table.new(narr, nrec)`:** Pustaka `table` standar di Lua 5.1 (yang menjadi dasar LuaJIT yang digunakan Neovim) **tidak** memiliki fungsi seperti `table.new(jumlah_elemen_array, jumlah_elemen_record_hash)` yang ada di Lua 5.2+ untuk secara eksplisit melakukan pra-alokasi.
  - **Contoh yang Sering Disalahartikan:**
    ```lua
    -- INI BUKAN pra-alokasi kapasitas dalam satu langkah di Lua 5.1 standar.
    -- Ini adalah POPULASI tabel, yang mungkin melibatkan beberapa realokasi internal.
    local N = 1000
    local t = {} -- Tabel dibuat kosong.
    for i = 1, N do
        t[i] = i -- Setiap assignment bisa memicu realokasi jika kapasitas terlampaui.
    end
    ```
  - **Apa yang Bisa Dilakukan?**
    - Untuk bagian array, jika ukurannya diketahui dan tidak terlalu besar, Anda bisa menginisialisasi dengan `nil` untuk "memesan" slot, meskipun ini lebih boros secara sintaksis: `local arr = {nil, nil, nil, nil, nil}` (untuk 5 elemen).
    - LuaJIT mungkin memiliki optimasi internal atau fungsi FFI tertentu yang memungkinkan kontrol lebih besar, tetapi itu di luar lingkup Lua standar.
    - Secara umum, untuk Lua 5.1, biarkan tabel tumbuh secara dinamis. Implementasi tabel Lua sudah cukup efisien. Fokus pada algoritma yang baik lebih sering memberikan hasil performa yang lebih besar daripada mikro-optimasi pra-alokasi tanpa dukungan bahasa langsung.
  - **Pesan Dokumen Asli:** "Atau gunakan `table.new` jika tersedia" merujuk pada versi Lua yang lebih baru atau lingkungan Lua kustom yang mungkin menyediakannya.
- **Saran Praktis untuk Neovim:** Jangan terlalu khawatir tentang pra-alokasi tabel di Lua 5.1 kecuali Anda telah melakukan profiling dan menemukan bahwa pertumbuhan tabel adalah bottleneck signifikan.

#### Efficient String Operations (Operasi String yang Efisien)

- **Konsep:** String di Lua bersifat _immutable_ (tidak dapat diubah). Setiap kali Anda melakukan operasi yang tampaknya "memodifikasi" string (seperti konkatenasi), Lua sebenarnya membuat string baru di memori.
- **Masalah dengan Konkatenasi Berulang:**
  - **Sintaks Tidak Efisien (dalam loop ketat):**
    ```lua
    local s = ""
    for i = 1, 10000 do
        s = s .. "kata" .. i -- Membuat banyak string sementara
    end
    ```
  - **Solusi Lebih Baik (`table.concat`):** Kumpulkan semua bagian string dalam sebuah tabel, lalu gabungkan semuanya sekaligus menggunakan `table.concat`.
  - **Sintaks Efisien:**
    ```lua
    local parts = {}
    for i = 1, 10000 do
        table.insert(parts, "kata" .. i)
    end
    local s = table.concat(parts, "") -- Atau dengan separator: table.concat(parts, " ")
    ```
- **Fungsi `string.format`:** Untuk membangun string yang kompleks dari berbagai tipe data, `string.format` seringkali lebih bersih dan bisa lebih efisien daripada banyak konkatenasi manual.
- **Sumber Dokumentasi Lua:**
  - Programming in Lua, 1st ed. (Chapter 11.5 - String Concatenation): [https://www.lua.org/pil/11.5.html](https://www.lua.org/pil/11.5.html) (Meskipun PiL edisi pertama mungkin tidak menekankan `table.concat` sekuat edisi berikutnya, konsepnya tetap berlaku).

**Contoh Kode (Operasi String):**

```lua
print("\n--- Operasi String Efisien ---")

-- Tidak efisien untuk string besar/banyak iterasi
local start_time_inefficient = os.clock()
local s_inefficient = ""
for i = 1, 20000 do -- Jumlah iterasi ditingkatkan untuk melihat perbedaan
    s_inefficient = s_inefficient .. "x"
end
local time_inefficient = os.clock() - start_time_inefficient
print(string.format("Waktu konkatenasi string tidak efisien: %.4f detik (panjang: %d)", time_inefficient, #s_inefficient))

-- Lebih efisien menggunakan table.concat
local start_time_efficient = os.clock()
local parts_efficient = {}
for i = 1, 20000 do
    table.insert(parts_efficient, "x")
end
local s_efficient = table.concat(parts_efficient, "")
local time_efficient = os.clock() - start_time_efficient
print(string.format("Waktu dengan table.concat: %.4f detik (panjang: %d)", time_efficient, #s_efficient))
```

**Cara Menjalankan Kode:**
Simpan dan jalankan. Anda akan melihat perbedaan waktu eksekusi yang signifikan, terutama dengan jumlah iterasi yang besar.

**Penjelasan Kode Keseluruhan (Operasi String):**

- Dua loop dibuat, keduanya bertujuan untuk membuat string panjang yang terdiri dari banyak karakter "x".
- Loop pertama menggunakan operator konkatenasi `..` berulang kali. Ini membuat banyak string sementara di memori, yang lambat.
- Loop kedua mengumpulkan semua "x" ke dalam tabel `parts_efficient`, kemudian memanggil `table.concat(parts_efficient, "")` sekali untuk menggabungkan semuanya. Ini jauh lebih cepat.

#### Using `ipairs` vs `pairs` (Menggunakan `ipairs` vs `pairs`) - _Reiterasi_

- **Konsep:**
  - **`ipairs(t)`:** Iterator untuk bagian array dari tabel `t` (indeks numerik berurutan mulai dari 1, berhenti pada `nil` pertama). Dioptimalkan untuk array.
  - **`pairs(t)`:** Iterator untuk semua pasangan kunci-nilai dalam tabel `t` (termasuk bagian array dan hash). Menggunakan fungsi `next` secara internal. Urutan tidak dijamin untuk bagian hash.
- **Kapan Menggunakan Mana:**
  - Gunakan `ipairs` jika Anda hanya perlu mengiterasi bagian array sekuensial dari sebuah tabel. Ini umumnya lebih cepat.
  - Gunakan `pairs` jika Anda perlu mengiterasi semua elemen, termasuk yang memiliki kunci non-numerik atau kunci numerik yang tidak sekuensial (bagian hash).
- **Sintaks:**
  - `for index, value in ipairs(array_like_table) do ... end`
  - `for key, value in pairs(any_table) do ... end`

#### Asynchronous Operations (Operasi Asinkron) - _Reiterasi_

- **Konsep:** Untuk tugas yang memakan waktu (I/O file, jaringan, proses eksternal), gunakan operasi asinkron untuk mencegah pembekuan UI Neovim.
- **Cara di Neovim:** Manfaatkan coroutine bersama dengan API Neovim yang mendukung operasi asinkron, seperti:
  - `vim.loop` (libuv bindings) untuk I/O, timer, proses.
  - `vim.fn.jobstart()` untuk menjalankan proses eksternal secara asinkron.
  - Fungsi LSP atau API lain yang dirancang untuk bekerja secara asinkron.
- **Pola Umum:** Mulai operasi asinkron, sediakan fungsi callback, dan `yield` dari coroutine. Ketika operasi selesai, callback akan dipanggil, yang kemudian dapat me-`resume` coroutine dengan hasilnya. Pustaka seperti `plenary.nvim` menyediakan abstraksi `async/await` di atas ini.

---

Dengan menerapkan praktik terbaik ini dan memahami bagaimana Lua mengelola memori serta bagaimana cara mem-profile kode, Anda dapat membangun plugin Neovim yang tidak hanya fungsional tetapi juga berperforma baik dan andal.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][4]**
> - **[Sebelumnya][3]**
> - **[Kurikulum][2]**
> - **[Domain Spesifik][5]**

[5]: ../../../../../../../README.md
[4]: ../13-unit-testing-dengan-busted/README.md
[3]: ../11-plugin-structure-standards/README.md
[2]: ../../../../../README.md
[1]: ../../README.md
