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

Kita telah melihat betapa serbagunanya `table` di berbagai domain. Ini bukan hanya struktur data; ini adalah fondasi untuk membangun hampir semua hal di Lua.

Selanjutnya, kita akan masuk ke dua bagian terakhir: **"17. ADVANCED TOPICS"** yang membahas integrasi dengan sistem lain, dan **"18. SECURITY CONSIDERATIONS"**. Siap untuk menyelesaikan kurikulum ini?

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
