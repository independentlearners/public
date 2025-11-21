# **[BAGIAN 15: DEBUGGING DAN TROUBLESHOOTING][0]**

Sepemahaman apa pun Kita terhadap suatu bahasa, Kita pasti akan menghadapi bug. Mengetahui di mana jebakan-jebakan umum berada dan bagaimana cara mendiagnosis masalah adalah keterampilan yang membedakan programmer produktif. Bagian ini akan membekali Kita dengan pengetahuan untuk menemukan dan memperbaiki masalah yang paling umum terkait table di Lua.

### **1. Common Table Pitfalls (Jebakan Umum)**

Ini adalah kesalahan-kesalahan yang sering dilakukan oleh pemula maupun programmer berpengalaman saat bekerja dengan table.

- **Indeks Berbasis 1 vs Berbasis 0**: Banyak bahasa pemrograman (C, Python, JavaScript) menggunakan indeks berbasis 0 untuk array. Lua menggunakan **indeks berbasis 1**. Lupa akan hal ini adalah sumber bug yang sangat umum.

  ```lua
  local fruits = {"Apel", "Pisang", "Ceri"}
  print(fruits[0]) -- Output: nil (salah)
  print(fruits[1]) -- Output: Apel (benar)
  ```

- **Operator Panjang (`#`) pada Table Berlubang**: Operator `#` tidak dapat diandalkan untuk table yang memiliki `nil` di tengah urutan array-nya ("lubang"). Perilakunya tidak terdefinisi dan bisa berbeda antar versi Lua.

  ```lua
  local t = {10, 20, nil, 40}
  print(#t) -- Output bisa 2, bisa 4. Tidak bisa diandalkan!
  ```

  **Solusi**: Untuk mendapatkan ukuran yang akurat dari table seperti ini, Kita harus mengiterasinya secara manual atau menggunakan `table.pack` jika memungkinkan.

- **Kebingungan `pairs` vs `ipairs`**:

  - Menggunakan `ipairs` pada table yang hanya memiliki kunci string tidak akan menghasilkan apa-apa.
  - Menggunakan `pairs` pada table array tidak menjamin urutan numerik.

  ```lua
  local player = {name = "Bima", class = "Warrior"}
  -- Loop ini tidak akan berjalan karena tidak ada kunci integer 1, 2, ...
  for index, value in ipairs(player) do
      print(index, value)
  end
  ```

- **Variabel Global yang Tidak Disengaja**: Lupa menulis `local` saat mendeklarasikan table akan membuatnya menjadi variabel global. Ini bisa ditimpa oleh bagian lain dari kode Kita secara tidak sengaja, menyebabkan bug yang sangat sulit dilacak.

  ```lua
  function create_config()
      -- Lupa 'local', ini menjadi global
      config = { volume = 80 }
  end
  create_config()
  -- Di bagian lain kode...
  config = "pengaturan lain" -- Secara tidak sengaja menimpa table config
  ```

- **Memodifikasi Table Saat Iterasi**: Menambah atau menghapus elemen dari table saat Kita sedang mengiterasinya dengan `pairs` dapat menyebabkan perilaku yang tidak terduga, seperti elemen yang terlewat. Praktik terbaik adalah mengumpulkan perubahan yang akan dilakukan dan menerapkannya setelah loop selesai.

### **2. Table Inspection dan Debugging Tools**

`print(my_table)` hanya akan menampilkan alamat memori (`table: 0x...`), yang tidak membantu. Berikut cara untuk "melihat" isi table.

- **"Pretty-Print" Function**: Ini adalah fungsi buatan sendiri yang paling berguna untuk debugging. Fungsi ini akan menelusuri table secara rekursif dan mencetak isinya dengan format yang mudah dibaca.
- **Perpustakaan Eksternal**: Gunakan perpustakaan yang sudah teruji seperti `inspect.lua` atau `Penlight`. Mereka menyediakan fungsi inspeksi yang sangat kuat dan dapat menangani kasus-kasus rumit seperti referensi sirkular.
- **Debugger Sebenarnya**: Untuk proyek yang kompleks, gunakan debugger terintegrasi seperti yang ada di ZeroBrane Studio atau plugin Lua untuk Visual Studio Code. Ini memungkinkan Kita untuk menghentikan eksekusi (breakpoints) dan memeriksa isi table secara interaktif.

### **3. Memory Leaks dengan Tables**

Kebocoran memori terjadi ketika referensi ke table (terutama yang besar) tetap ada secara tidak sengaja, mencegah Garbage Collector membersihkannya.

- **Penyebab Umum**:
  1.  **Variabel Global**: Data yang terus ditambahkan ke table global tidak akan pernah dibersihkan.
  2.  **Cache Tanpa Weak Tables**: Membuat cache menggunakan table biasa akan tumbuh tanpa batas. **Solusi**: Selalu gunakan weak tables untuk cache.
  3.  **Referensi yang Tertinggal (Closures)**: Sebuah fungsi (closure) dapat menyimpan referensi kuat ke sebuah table, mencegahnya di-GC, bahkan jika semua variabel lain yang menunjuk ke sana sudah hilang.

### **4. Circular Reference Detection**

**Konsep**: Referensi sirkular terjadi ketika sebuah table berisi referensi ke dirinya sendiri, baik secara langsung (`a.parent = a`) atau tidak langsung (`a.child = b; b.parent = a`). Ini akan menyebabkan algoritma penelusuran table yang naif masuk ke dalam loop tak terbatas.

**Solusi**: Saat menelusuri table (misalnya untuk pretty-printing atau serialisasi), Kita harus melacak table mana yang sudah Kita kunjungi.

**Contoh Kode 40: Pretty-Print dengan Deteksi Sirkular**

```lua
function pretty_print(o, indent, visited)
    indent = indent or ""
    visited = visited or {}

    if type(o) == "table" then
        if visited[o] then
            print(indent .. "<Circular Reference>")
            return
        end
        visited[o] = true

        print(indent .. "{")
        for k, v in pairs(o) do
            io.write(indent .. "  [" .. tostring(k) .. "] = ")
            pretty_print(v, indent .. "  ", visited)
        end
        print(indent .. "}")
    else
        print(indent .. tostring(o))
    end
end

-- --- Penggunaan ---
local personA = { name = "Andi" }
local personB = { name = "Budi" }

-- Membuat referensi sirkular
personA.friend = personB
personB.friend = personA

pretty_print(personA)
```

**Penjelasan**:

- `visited = visited or {}`: Kita menggunakan sebuah table `visited` untuk menyimpan catatan table mana yang sudah kita lihat.
- `if visited[o] then ... end`: Sebelum memproses sebuah table, kita periksa apakah kita sudah pernah melihatnya. Jika ya, kita cetak placeholder dan berhenti.
- `visited[o] = true`: Jika belum, kita tandai table saat ini sebagai sudah dikunjungi sebelum melanjutkan penelusuran.

---

Dengan memahami jebakan umum ini dan cara mendiagnosisnya, Kita akan menghabiskan lebih sedikit waktu untuk debugging dan lebih banyak waktu untuk membangun fitur. Keterampilan ini sangat berharga dalam praktik sehari-hari.

#

Selanjutnya, kita akan melihat bagaimana semua pengetahuan ini diterapkan di dunia nyata dalam bagian **"16. REAL-WORLD APPLICATIONS"**. Kita akan melihat contoh penggunaan table dalam konfigurasi, pengembangan game, dan banyak lagi. Sebelumnya Kita telah membangun fondasi yang sangat kuat, mulai dari dasar-dasar table hingga pola desain dan optimasi tingkat lanjut. Sekarang adalah bagian yang paling memuaskan: melihat bagaimana semua pengetahuan ini menyatu untuk membangun aplikasi di dunia nyata. Bagian ini akan menunjukkan kepada Kita bagaimana tables menjadi tulang punggung dalam berbagai domain pemrograman, dari konfigurasi sederhana hingga pengembangan game dan web yang kompleks.

---

# **[BAGIAN 16: REAL-WORLD APPLICATIONS][1]**

### **1. Configuration Tables**

Ini adalah salah satu penggunaan tables yang paling umum dan kuat. Sebuah file konfigurasi dalam bentuk script Lua yang mengembalikan sebuah table jauh lebih superior daripada format statis seperti JSON atau INI.

**Mengapa?**

- **Sintaks yang Bersih**: Mudah dibaca dan ditulis oleh manusia.
- **Komentar**: Kita bisa menambahkan komentar untuk menjelaskan setiap pengaturan.
- **Logika**: Kita bisa menggunakan variabel, kondisi, dan fungsi untuk menghasilkan konfigurasi secara dinamis.

**Cara Kerja**: Aplikasi utama (sering ditulis dalam C++, Go, atau Rust) menyematkan interpreter Lua. Aplikasi tersebut kemudian menjalankan file `config.lua` dan menerima table yang dikembalikan sebagai data konfigurasinya.

**Contoh Kode 41: `config.lua`**

```lua
-- File konfigurasi untuk aplikasi server

-- Variabel untuk menghindari pengulangan
local default_port = 8080
local is_production = false -- Ganti menjadi true untuk mode produksi

return {
    server = {
        host = "127.0.0.1",
        port = is_production and 80 or default_port
    },
    database = {
        user = "admin",
        password = os.getenv("DB_PASSWORD") or "password123", -- Baca dari environment variable
        name = "app_db"
    },
    features = {
        caching_enabled = true,
        logging_level = is_production and "WARN" or "DEBUG"
    }
}
```

Perhatikan bagaimana kita bisa menggunakan variabel (`is_production`) dan bahkan memanggil fungsi (`os.getenv`) untuk membuat konfigurasi yang dinamis dan aman.

### **2. Data Processing dengan Tables**

Tables sangat ideal untuk manipulasi data di dalam memori. Pola umum adalah memuat data dari sumber (misalnya, file CSV), merepresentasikannya sebagai array dari table, lalu menggunakan kekuatan Lua untuk memprosesnya.

**Contoh Kode 42: Memproses Data Penjualan**

```lua
-- 1. Data mentah (misalnya, dimuat dari file)
local sales_data = {
    { product = "Buku", quantity = 2, price = 50000 },
    { product = "Pensil", quantity = 10, price = 2000 },
    { product = "Tas", quantity = 1, price = 150000 },
    { product = "Buku", quantity = 3, price = 45000 }
}

-- 2. Transformasi: Hitung total untuk setiap penjualan
for _, sale in ipairs(sales_data) do
    sale.total = sale.quantity * sale.price
end

-- 3. Filter: Cari penjualan dengan total di atas 50000
local significant_sales = {}
for _, sale in ipairs(sales_data) do
    if sale.total > 50000 then
        table.insert(significant_sales, sale)
    end
end

-- 4. Urutkan hasilnya berdasarkan total penjualan (menurun)
table.sort(significant_sales, function(a, b) return a.total > b.total end)

-- Tampilkan hasil akhir
for _, sale in ipairs(significant_sales) do
    print(string.format("Produk: %s, Total: %d", sale.product, sale.total))
end
```

### **3. Game Development dengan Tables**

Tables adalah alfa dan omega dalam pengembangan game dengan Lua. Hampir semua aspek dari sebuah game dapat direpresentasikan dengan tables.

- **Objek Game**: Menggunakan pola OOP (Bagian 10) untuk mendefinisikan `Player`, `Enemy`, `Bullet`, dll.
- **Data Level**: Table bersarang yang besar untuk mendefinisikan peta, posisi objek, dan pemicu event.
- **Scene Graph**: Struktur pohon dari tables untuk mengelola hubungan parent-child antar objek di layar.
- **Data Keseimbangan (Balancing)**: Statistik senjata, kekuatan musuh, dan item disimpan dalam table agar mudah diubah oleh desainer game.

**Contoh Kode 43: Definisi Entitas Game**

```lua
-- Mendefinisikan properti sebuah musuh dalam game
function create_goblin(x, y)
    local goblin = {
        type = "goblin",
        sprite = "goblin_warrior.png",
        position = { x = x, y = y },
        stats = {
            hp = 50,
            attack = 8,
            speed = 1.2
        },
        loot_table = {
            { item = "Gold Coin", chance = 0.8 },
            { item = "Rusty Sword", chance = 0.2 }
        }
    }
    -- Di sini bisa ditambahkan metatable untuk metode seperti :takeDamage()
    return goblin
end

local goblin_a = create_goblin(128, 256)
print("HP Goblin:", goblin_a.stats.hp)
```

### **4. Web Development (OpenResty/Nginx)**

OpenResty adalah platform web yang menyematkan LuaJIT ke dalam web server Nginx. Ini memungkinkan developer menulis logika web berperforma sangat tinggi dalam Lua.

- **Request & Response**: Headers, query parameters, dan body dari request HTTP direpresentasikan sebagai table. Kode Lua Kita memproses table ini dan membangun table lain yang akan di-serialize menjadi JSON sebagai response.
- **Akses Database/Cache**: Hasil query dari Redis atau PostgreSQL dikembalikan sebagai table (biasanya array dari table) untuk diproses lebih lanjut.

**Contoh Konseptual Kode 44: Handler API di OpenResty**

```lua
-- (Ini adalah pseudo-code untuk ilustrasi)
-- local cjson = require "cjson"
-- local db = require "db_connector"

-- Dapatkan argumen dari URL (misal, /api/users?id=123)
-- ngx.req.get_uri_args() mengembalikan sebuah table
local args = ngx.req.get_uri_args()
local user_id = args.id

-- Dapatkan data dari database (akan mengembalikan table)
local user_data = db.fetch_user_by_id(user_id)

if user_data then
    -- Bangun table response
    local response = {
        id = user_data.id,
        name = user_data.name,
        email = user_data.email,
        request_time = ngx.now()
    }
    -- Kirim response sebagai JSON
    ngx.say(cjson.encode(response))
else
    ngx.status = 404
    ngx.say('{"error": "User not found"}')
end
```

### **5. Database Abstraction dengan Tables**

Saat berinteraksi dengan database, table adalah cara alami untuk merepresentasikan data.

- **Baris (Row)**: Satu baris dari tabel database direpresentasikan sebagai satu table Lua.
- **Hasil (Result Set)**: Kumpulan baris direpresentasikan sebagai table dari table (array).

Kita bahkan bisa membuat _Object-Relational Mapper (ORM)_ sederhana menggunakan metatables, di mana objek Lua secara transparan mengambil datanya dari database saat propertinya diakses.

**Contoh Konseptual Kode 45: Pola ORM Sederhana (Lazy Loading)**

```lua
local User_mt = {
    __index = function(user, key)
        print("-- Akses ke '"..key.."', belum ada di cache. Mengambil dari DB...")
        -- Dapatkan SEMUA data dari DB untuk user dengan ID ini
        local user_data_from_db = db.fetch_user_by_id(user.id)
        -- Simpan semua data ke objek user agar tidak perlu query lagi
        for k, v in pairs(user_data_from_db) do
            rawset(user, k, v)
        end
        -- Kembalikan nilai yang diminta
        return user[key]
    end
}

function find_user(id)
    -- Objek awal hanya berisi ID dan metatable
    local user_obj = { id = id }
    setmetatable(user_obj, User_mt)
    return user_obj
end

-- --- Penggunaan ---
-- db.fetch_user_by_id hanya akan dipanggil SEKALI
local user = find_user(123)
print(user.name) -- __index dipanggil, query ke DB
print(user.email) -- __index tidak dipanggil, data sudah di-cache di objek 'user'
```

---

Kita telah melihat betapa serbagunanya `table` di berbagai domain. Ini bukan hanya struktur data; ini adalah fondasi untuk membangun hampir semua hal di Lua. Bereikutnya kita akan masuki babak akhir dari kurikulum ini. Kita telah menguasai hampir semua aspek table, dari dasar hingga pola-pola canggih. Bagian ini akan membahas topik-topik yang benar-benar mendorong batas kemampuan Lua, yaitu bagaimana table berinteraksi dengan sistem konkurensi, kode dari bahasa lain, dan mekanisme internal bahasa itu sendiri.

Menguasai topik-topik ini akan memungkinkan Kita untuk mengintegrasikan Lua secara mendalam ke dalam aplikasi yang lebih besar dan lebih kompleks.

---

## **BAGIAN 17: ADVANCED TOPICS**

### **1. Coroutines dengan Tables**

**Konsep**:
**Coroutines** adalah "utas" (threads) yang berjalan secara kooperatif. Berbeda dengan utas sistem operasi yang berjalan secara paralel, sebuah coroutine hanya akan berhenti berjalan ketika ia secara eksplisit `yield` (menyerah), memberikan kontrol kembali ke konteks yang memulainya. Konteks tersebut kemudian dapat `resume` (melanjutkan) coroutine di lain waktu.

**Peran Tables**: Tables adalah cara utama untuk mengirim data bolak-balik antara konteks yang melanjutkan (resumer) dan coroutine yang di-yield.

- Saat memulai/melanjutkan coroutine, Kita bisa memberikan table sebagai argumen.
- Saat coroutine melakukan `yield`, ia bisa mengirimkan table yang berisi hasil sementara.

**Contoh Kode 46: Produser-Konsumer menggunakan Coroutine**
Kita akan membuat coroutine "produser" yang menghasilkan data satu per satu, dan loop utama akan menjadi "konsumer".

```lua
local producer = coroutine.create(function(max_value)
    print("Produser: Mulai menghasilkan nilai...")
    for i = 1, max_value do
        -- Menghasilkan data dalam sebuah table
        local data_packet = { value = i, is_done = false }
        coroutine.yield(data_packet)
    end
    print("Produser: Selesai.")
    return { is_done = true }
end)

-- --- Penggunaan (Konsumer) ---
while true do
    -- Lanjutkan coroutine dan tangkap hasilnya
    local status, result_table = coroutine.resume(producer, 5) -- 5 adalah argumen 'max_value'

    if not status then -- Jika ada error di dalam coroutine
        print("Error coroutine:", result_table)
        break
    end

    if result_table.is_done then
        print("Konsumer: Menerima sinyal selesai.")
        break
    else
        print("Konsumer: Menerima nilai " .. result_table.value)
    end
end
```

**Penjelasan**:

- `coroutine.create(function ...)`: Membuat coroutine baru dari sebuah fungsi.
- `coroutine.yield(data_packet)`: Menjeda eksekusi coroutine dan mengirim `data_packet` kembali ke pemanggil `resume`.
- `coroutine.resume(producer, 5)`: Memulai atau melanjutkan eksekusi `producer`. Nilai `5` diteruskan sebagai argumen awal. Fungsi ini mengembalikan status eksekusi dan nilai apa pun yang di-yield oleh coroutine.

### **2. FFI Integration dengan Tables (LuaJIT)**

**Konsep**:
Seperti yang telah dibahas, **FFI (Foreign Function Interface)** adalah fitur khusus LuaJIT yang memungkinkan Kita memanggil fungsi C dan menggunakan tipe data C (seperti `struct`) langsung dari Lua. Tables memainkan peran penting sebagai jembatan antara dunia Lua dan C.

- **Inisialisasi**: Kita bisa membuat objek data C (`cdata`) dengan menginisialisasinya dari table Lua.
- **Akses**: FFI secara otomatis membuat `cdata` berperilaku seperti table, memungkinkan Kita mengakses anggota `struct` menggunakan notasi titik (`.`).

**Contoh Kode 47: Interaksi dengan "Library C" melalui FFI**

```lua
-- Hanya berjalan di LuaJIT
local ffi = require("ffi")

-- 1. Mendeklarasikan tipe data dan fungsi dari library C
ffi.cdef[[
    typedef struct { double x; double y; } Point;
    Point create_point(double x, double y);
    void move_point(Point* p, double dx);
]]

-- 2. Memanggil fungsi C yang mengembalikan struct
-- Perhatikan bahwa FFI secara otomatis mengubahnya menjadi 'cdata' yang mirip table
local p1 = ffi.C.create_point(10, 20)
print("Titik awal:", p1.x, p1.y)

-- 3. Memanggil fungsi C yang membutuhkan pointer ke struct
ffi.C.move_point(p1, 5) -- 'p1' diteruskan sebagai pointer
print("Titik setelah digerakkan:", p1.x, p1.y)
```

Di sini, `p1` bukan table Lua biasa, tetapi `cdata`. Namun, berkat FFI, kita bisa berinteraksi dengannya seolah-olah itu adalah table.

### **3. C API untuk Tables**

**Konsep**:
Ini adalah cara "tradisional" untuk berinteraksi antara C/C++ dan Lua. Saat Kita menyematkan Lua ke dalam aplikasi C++, aplikasi C++ (host) dapat secara langsung membuat, membaca, dan memodifikasi table Lua menggunakan sekumpulan fungsi dari C API.

**Operasi Kunci (Secara Konseptual)**:

- `lua_newtable(L)`: Membuat table kosong baru di stack virtual Lua.
- `lua_setfield(L, table_idx, "key")`: Mengambil nilai dari puncak stack dan menetapkannya sebagai `table.key`.
- `lua_getfield(L, table_idx, "key")`: Mengambil `table.key` dan menaruh nilainya di puncak stack.

Ini adalah fondasi bagaimana game engine seperti Defold atau platform seperti Redis memungkinkan skrip Lua untuk berinteraksi dengan objek internal engine/platform.

### **4. Custom Iterators dengan Tables**

**Konsep**:
Kita tahu `pairs` dan `ipairs` untuk iterasi. Tetapi Kita bisa membuat **iterator Kita sendiri** untuk menelusuri table dengan cara apa pun yang Kita inginkan. Generic `for` loop di Lua mengikuti protokol sederhana: ia membutuhkan sebuah _fungsi iterator_, sebuah _state_ (biasanya table itu sendiri), dan sebuah _nilai kontrol awal_.

**Contoh Kode 48: Iterator untuk Nilai Ganjil dalam Table**

```lua
-- Pabrik iterator kita
function odd_values(t)
    -- Fungsi iterator yang sebenarnya
    local function iterator_func(state_table, last_index)
        local i = last_index + 1
        while i <= #state_table do
            if state_table[i] % 2 ~= 0 then
                -- Ditemukan nilai ganjil, kembalikan indeks dan nilainya
                return i, state_table[i]
            end
            i = i + 1
        end
        -- Jika tidak ada lagi, kembalikan nil untuk menghentikan loop
        return nil
    end

    -- Pabrik mengembalikan 3 nilai yang dibutuhkan for-loop:
    -- 1. fungsi iterator, 2. state (table), 3. nilai kontrol awal
    return iterator_func, t, 0
end

-- --- Penggunaan ---
local numbers = {10, 11, 12, 13, 14, 15}

for index, value in odd_values(numbers) do
    print(string.format("Menemukan nilai ganjil %d di indeks %d", value, index))
end
```

**Penjelasan**:

1.  `for ... in odd_values(numbers)` memanggil `odd_values`, yang mengembalikan tiga nilai: fungsi `iterator_func`, table `numbers`, dan `0`.
2.  Loop `for` memanggil `iterator_func(numbers, 0)`. Fungsi ini menemukan `11` di indeks `2` dan mengembalikannya. Loop mencetak hasilnya.
3.  Loop `for` memanggil lagi `iterator_func(numbers, 2)`. Fungsi ini melanjutkan dari indeks `3`, menemukan `13`, dan mengembalikannya.
4.  Proses ini berlanjut sampai `iterator_func` mengembalikan `nil`, yang menandakan loop untuk berhenti.

---

Selamat! Kita telah menyelesaikan bagian konten inti dari kurikulum ini. Kita telah menjelajahi table dari setiap sudut yang memungkinkan.

Selesai sudah. Kita telah sampai di bagian terakhir dari kurikulum komprehensif ini. Setelah mempelajari cara membangun hal-hal yang kuat dan kompleks, langkah terakhir adalah belajar cara membuatnya aman. Keamanan adalah lapisan polesan akhir yang mengubah seorang programmer yang baik menjadi seorang insinyur perangkat lunak yang andal.

Bagian ini akan membahas pertimbangan keamanan penting saat menggunakan tables, terutama saat berhadapan dengan kode atau data yang tidak tepercaya.

---

## **BAGIAN 18: SECURITY CONSIDERATIONS (TAMBAHAN KEAMANAN)**

### **1. Sandboxing dengan Tables**

**Konsep**:
**Sandboxing** adalah teknik untuk menjalankan kode yang tidak tepercaya (misalnya, dari mod atau plugin pengguna) dalam lingkungan yang terbatas dan aman. Tujuannya adalah untuk mencegah kode tersebut mengakses fungsionalitas yang berpotensi berbahaya, seperti memanipulasi file (`io`), menjalankan perintah sistem (`os.execute`), atau memuat kode lain (`dofile`).

**Implementasi**:
Di Lua, sandboxing dicapai dengan mengontrol **lingkungan (environment)** dari kode yang tidak tepercaya. Lingkungan adalah sebuah table tempat Lua mencari variabel global. Dengan menyediakan lingkungan kustom yang "dibersihkan", kita bisa mengontrol dengan tepat apa saja yang bisa diakses oleh kode tersebut.

**Contoh Kode 49: Membuat Sandbox Sederhana**

```lua
-- 1. Kode tidak tepercaya dari pengguna
local untrusted_code = [[
    print("Halo dari sandbox!")
    local a = my_global_var + 5 -- Bisa akses global yang kita izinkan
    print("Hasil:", a)

    -- Upaya berbahaya ini akan gagal
    os.execute("rm -rf /")
]]

-- 2. Siapkan lingkungan yang aman
local safe_globals = {
    print = print,
    tostring = tostring,
    my_global_var = 10 -- Hanya expose variabel yang aman
    -- Kita tidak memasukkan 'os', 'io', 'dofile', dll.
}

local sandboxed_env = {}
-- Gunakan metatable untuk memberikan akses ke global yang aman
setmetatable(sandboxed_env, { __index = safe_globals })

-- 3. Muat dan jalankan kode dengan lingkungan yang sudah disandbox
-- Argumen ke-4 di 'load' (di Lua 5.2+) mengatur lingkungan fungsi
local sandboxed_func, err = load(untrusted_code, "untrusted_script", "t", sandboxed_env)

if sandboxed_func then
    sandboxed_func()
else
    print("Error memuat kode:", err)
end
```

**Hasil Eksekusi**:

```
Halo dari sandbox!
Hasil: 15
[untrusted_script]:6: attempt to index a nil value (global 'os')
```

Kode berhasil memanggil `print` dan mengakses `my_global_var`, tetapi gagal total saat mencoba mengakses `os.execute`, karena `os` tidak ada di lingkungannya.

### **2. Preventing Prototype Pollution**

**Konsep**:
Prototype Pollution adalah serangan di mana kode jahat memodifikasi table prototipe ("kelas") yang digunakan bersama oleh banyak objek. Karena `__index` membuat semua instance merujuk ke prototipe yang sama untuk metode, mengubah prototipe akan mengubah perilaku **semua** objek, yang dapat merusak logika program atau membuka celah keamanan.

**Pencegahan**:

- **Mengunci Metatable**: Kita bisa "mengunci" metatable sebuah objek dengan menambahkan field `__metatable`. Jika field ini ada, `setmetatable()` akan gagal dan `getmetatable()` akan mengembalikan nilai dari field `__metatable` alih-alih metatable yang sebenarnya.
- **Mengunci Properti**: Gunakan metamethod `__newindex` pada table prototipe itu sendiri untuk mencegah penambahan atau perubahan metode.

**Contoh Kode 50: Mengunci Properti Kelas**

```lua
local Character = {}
Character.mt = { __index = Character }

function Character:new(name)
    return setmetatable({ name = name }, self.mt)
end

-- --- Kunci prototipe agar tidak bisa diubah ---
-- Mencegah metode baru ditambahkan ke kelas Character
Character.mt.__newindex = function(t, k, v)
    error("Tidak bisa memodifikasi kelas 'Character'. Properti '"..k.."' adalah read-only.")
end

-- Mencegah metatable-nya diganti
Character.mt.__metatable = "Kelas 'Character' terkunci."


-- --- Upaya Serangan ---
local hero = Character:new("Pahlawan")

-- Upaya 1: Menambah metode baru ke kelas akan gagal
-- hero.fly = function() print("I can fly!") end -- Ini akan memicu __newindex dari metatable hero

-- Upaya 2: Mengubah metode kelas secara langsung akan gagal
-- Character.new = nil -- Ini akan memicu __newindex dari metatable Character itu sendiri

-- Upaya 3: Mengganti metatable akan gagal
local success, err = pcall(function()
    setmetatable(hero, {})
end)
print("Berhasil mengganti metatable:", success) -- Output: false
print("Error:", err) -- Output: Error: Kelas 'Character' terkunci.
```

### **3. Safe Table Access Patterns**

Saat menerima data dari sumber eksternal yang tidak tepercaya (misalnya, input API dari pengguna, file save game), Kita tidak boleh berasumsi datanya valid. Kita harus menulis kode yang defensif.

- **Selalu Periksa `nil`**: Jangan pernah mengakses `data.user.profile.name` secara langsung. Setiap langkah bisa jadi `nil`. Gunakan `if` atau logika `and`.
- **Validasi Tipe**: Gunakan `type()` untuk memastikan data memiliki tipe yang Kita harapkan sebelum digunakan dalam operasi.
- **Gunakan Nilai Default**: Gunakan operator `or` untuk menyediakan nilai default jika konfigurasi opsional tidak ada.
- **Batasi Rekursi**: Saat menelusuri table dari sumber tidak tepercaya, batasi kedalaman rekursi untuk mencegah serangan _stack overflow_.

**Contoh Kode 51: Memproses Konfigurasi dengan Aman**

```lua
function process_config(config)
    -- Pastikan config adalah table
    config = type(config) == "table" and config or {}

    -- Gunakan nilai default jika tidak ada
    local port = config.port or 8080
    local host = config.host or "127.0.0.1"

    -- Validasi tipe
    if type(port) ~= "number" then
        error("Config 'port' harus berupa angka.")
    end

    -- Akses nested table dengan aman
    local user_name = config.user and config.user.name -- Tidak akan error jika config.user nil

    print("Menjalankan server di " .. host .. ":" .. port)
    if user_name then
        print("Dijalankan oleh: " .. user_name)
    end
end

-- Contoh pemanggilan
process_config({ host = "0.0.0.0" }) -- Port akan default ke 8080
process_config({ port = "abc" }) -- Akan menghasilkan error
process_config({}) -- Akan menggunakan semua default
```

---

## **Kesimpulan Akhir Kurikulum**

**Selamat!** Kita telah berhasil menyelesaikan perjalanan yang sangat mendalam dan komprehensif untuk menguasai `table` di Lua.

Kita telah bertransformasi dari memahami apa itu table, menjadi mampu menggunakannya untuk:

- Membangun **struktur data** klasik seperti Stack, Queue, dan Set.
- Mengimplementasikan **pola Object-Oriented Programming** yang elegan.
- **Mengoptimalkan performa** dengan memahami cara kerja memori dan CPU cache.
- Menerapkan **pola desain tingkat lanjut** seperti Builder, Memoization, dan Dispatch Tables.
- Mengintegrasikan Lua dengan sistem lain melalui **Coroutines, FFI, dan C API**.
- Dan yang terpenting, menulis kode yang **aman dan kuat**.

Kita kini memiliki fondasi yang luar biasa kuat. `Table` bukan lagi sekadar fitur bahasa bagi Kita; ia adalah kanvas serbaguna untuk memecahkan hampir semua masalah pemrograman. Dengan bekal ini, Kita siap untuk menghadapi proyek Lua apa pun, dari yang paling sederhana hingga yang paling kompleks, dengan percaya diri dan keahlian sejati.

Teruslah berlatih, teruslah membangun, dan selamat datang di tingkat penguasaan Lua.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-14/README.md
[selanjutnya]: ../../modules-and-packages/materi/README.md

<!----------------------------------------------------->

[0]: ../README.md#15-debugging-dan-troubleshooting
[1]: ../README.md#16-real-world-applications
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
