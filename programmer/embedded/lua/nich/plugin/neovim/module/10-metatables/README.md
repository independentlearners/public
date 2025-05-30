## [10\. Metatables - Kustomisasi Perilaku Tabel][10]

Seperti yang telah disinggung sebelumnya (di Bagian 6.2 tentang OOP), metatable adalah tabel Lua biasa yang dapat dikaitkan dengan tabel lain untuk mengubah perilakunya saat operasi tertentu dilakukan padanya. Ini memungkinkan tabel berperilaku lebih dari sekadar kumpulan kunci-nilai sederhana. Jadi ini adalah salah satu fitur paling kuat di Lua, yang memungkinkan Anda untuk mengubah dan memperluas perilaku standar tabel. Pemahaman mendalam tentang metatable sangat penting untuk pemrograman Lua tingkat lanjut dan beberapa pola desain OOP.

---

### 10.1 Konsep Metatable (Review dan Detail)

- **Deskripsi Konsep (Review):**
  Setiap tabel di Lua dapat memiliki satu _metatable_. Metatable ini adalah tabel Lua biasa yang field-fieldnya (disebut _metamethods_) mendefinisikan bagaimana tabel asli (yang memiliki metatable tersebut) akan berperilaku untuk operasi tertentu seperti penjumlahan, pengindeksan, pemanggilan, dll. Secara default, tabel baru tidak memiliki metatable.
- **Terminologi:**
  - **Metatable:** Tabel yang berisi metamethods.
  - **Metamethod:** Kunci khusus dalam metatable (dimulai dengan dua garis bawah, misalnya `__index`, `__add`) yang nilainya adalah fungsi yang dipanggil Lua saat operasi tertentu dilakukan pada tabel yang terkait.
- **Sintaks Per Baris (Fungsi Kunci):**
  - **`setmetatable(tabel, metatable_tabel)`:**
    - `tabel`: Tabel yang metatablenya ingin Anda atur atau ubah.
    - `metatable_tabel`: Tabel yang akan dijadikan metatable untuk `tabel`. Jika `nil`, metatable dari `tabel` akan dihapus (jika ada dan tidak dilindungi).
    - Fungsi ini mengembalikan `tabel` itu sendiri.
    - **Perlindungan Metatable:** Jika `metatable_tabel` memiliki field `__metatable`, maka nilai field `__metatable` inilah yang akan dikembalikan oleh `getmetatable`, dan `setmetatable` akan gagal jika mencoba mengubah metatable yang dilindungi (kecuali dari dalam C API).
  - **`getmetatable(tabel)`:**
    - `tabel`: Tabel yang metatablenya ingin Anda peroleh.
    - Fungsi ini mengembalikan metatable dari `tabel`.
    - Jika `tabel` tidak memiliki metatable, ia mengembalikan `nil`.
    - Jika metatable dari `tabel` memiliki field `__metatable`, maka `getmetatable` akan mengembalikan nilai dari field `__metatable` tersebut, bukan metatable aslinya. Ini adalah cara untuk "melindungi" metatable dari inspeksi atau modifikasi eksternal.
- **Implementasi dalam Neovim:** Metatable memungkinkan pembuatan struktur data yang lebih canggih dan API internal plugin yang lebih ekspresif. Misalnya, Anda bisa membuat tabel konfigurasi yang memiliki nilai default atau melakukan validasi saat field diatur. Pustaka Lua yang digunakan dalam ekosistem Neovim mungkin juga memanfaatkan metatable secara ekstensif.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (Metatables): [https://www.lua.org/manual/5.1/manual.html\#2.8](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.8)
  - Lua 5.1 Reference Manual (`setmetatable`, `getmetatable`): [https://www.lua.org/manual/5.1/manual.html\#5.1](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%235.1)
  - Programming in Lua, 1st ed. (Chapter 13 - Metatables and Metamethods): [https://www.lua.org/pil/13.html](https://www.lua.org/pil/13.html)

**Contoh Kode (Review Dasar):**

```lua
local my_data_table = { value = 10 }
local my_metatable = {
    -- Kita akan menambahkan metamethods di sini nanti
    __metatable = "Metatable ini dilindungi dari getmetatable langsung."
                -- Jika __metatable adalah string, getmetatable akan mengembalikan string ini.
                -- Jika __metatable adalah tabel lain, getmetatable akan mengembalikan tabel itu.
}

-- Mengatur metatable untuk my_data_table
setmetatable(my_data_table, my_metatable)

-- Mendapatkan metatable
local retrieved_mt = getmetatable(my_data_table)
print("Hasil dari getmetatable:", retrieved_mt) -- Output: Metatable ini dilindungi...

-- Jika __metatable tidak diset di my_metatable, maka retrieved_mt akan menjadi my_metatable itu sendiri.
-- Untuk melihat metatable sebenarnya dalam kasus terlindungi (biasanya tidak diperlukan atau tidak bisa dari Lua murni):
-- Jika my_metatable.__metatable tidak ada, maka:
-- print(getmetatable(my_data_table) == my_metatable) -- Akan true

-- Mencoba mengatur metatable lagi pada tabel yang metatablenya dilindungi oleh string __metatable
-- (sebenarnya, perlindungan __metatable lebih ke apa yang dikembalikan getmetatable,
-- setmetatable akan tetap bisa mengubahnya kecuali jika itu adalah metatable dari tipe data dasar C)
-- Untuk tabel Lua biasa, setmetatable masih bisa mengubah metatable yang punya field __metatable.
-- Perlindungan sebenarnya dari setmetatable adalah jika tabel itu sendiri adalah metatable dari tipe C.
-- Namun, jika `my_metatable.__metatable` ada, `getmetatable` akan mengembalikan nilai itu.
local new_metatable = {}
setmetatable(my_data_table, new_metatable)
print("getmetatable setelah set baru:", getmetatable(my_data_table) == new_metatable) -- Output: true
```

**Penjelasan Kode Keseluruhan (Review Dasar):**

- `my_data_table`: Tabel data biasa.
- `my_metatable`: Tabel yang akan menjadi metatable. Field `__metatable` ditambahkan untuk mendemonstrasikan bagaimana `getmetatable` dapat "menyembunyikan" metatable asli jika field ini ada.
- `setmetatable(my_data_table, my_metatable)`: Mengaitkan `my_metatable` dengan `my_data_table`.
- `getmetatable(my_data_table)`: Karena `my_metatable` memiliki field `__metatable`, nilai dari field inilah (`"Metatable ini dilindungi..."`) yang dikembalikan. Jika `__metatable` tidak ada di `my_metatable`, maka `getmetatable` akan mengembalikan `my_metatable` itu sendiri.
- Contoh kedua dengan `new_metatable` menunjukkan bahwa untuk tabel Lua biasa, `setmetatable` masih bisa mengubah metatable-nya, dan `getmetatable` akan mengembalikan metatable yang baru (atau field `__metatable` dari metatable baru tersebut jika ada).

---

### 10.2 Metamethod Umum

Berikut adalah beberapa metamethod yang paling umum digunakan dan perilakunya:

#### `__index`

- **Deskripsi:** Metamethod ini dipicu ketika Anda mencoba mengakses field (kunci) dalam sebuah tabel yang tidak ada (nilainya `nil`) di tabel tersebut secara langsung.
- **Sintaks dan Perilaku:**
  - **Jika `metatable.__index` adalah sebuah tabel (Tabel Prototipe):**
    ```lua
    -- mt adalah metatable
    -- prototype_table adalah tabel lain
    mt.__index = prototype_table
    ```
    Ketika `tabel[kunci]` diakses dan `tabel[kunci]` adalah `nil`, Lua akan secara otomatis mencari `prototype_table[kunci]`. Ini adalah mekanisme dasar untuk pewarisan (inheritance) di OOP Lua.
  - **Jika `metatable.__index` adalah sebuah fungsi:**
    ```lua
    mt.__index = function(tabel_asli, kunci_yang_dicari)
        -- Logika untuk menentukan nilai yang akan dikembalikan
        -- Bisa mengembalikan nilai apa pun.
        print("Metamethod __index dipanggil untuk kunci: " .. tostring(kunci_yang_dicari))
        if kunci_yang_dicari == "dynamic_field" then
            return "Nilai dinamis!"
        else
            return nil -- atau nilai default lainnya
        end
    end
    ```
    Ketika `tabel[kunci]` diakses dan `tabel[kunci]` adalah `nil`, Lua akan memanggil fungsi ini dengan `tabel_asli` (tabel tempat field dicari) dan `kunci_yang_dicari` sebagai argumen. Nilai yang dikembalikan oleh fungsi ini akan menjadi hasil dari ekspresi `tabel[kunci]`.
- **Penting:** `rawget(tabel, kunci)` dapat digunakan untuk mengakses field tabel tanpa memicu metamethod `__index`.

**Contoh Kode (`__index`):**

```lua
-- __index sebagai tabel (untuk pewarisan/delegasi)
local defaults = { x = 0, y = 0, color = "black" }
local mt_index_table = { __index = defaults }

local point_a = { color = "red", z = 10 } -- Hanya color dan z yang ada di point_a
setmetatable(point_a, mt_index_table)

print("point_a.x:", point_a.x)         -- Output: 0 (dari defaults melalui __index)
print("point_a.color:", point_a.color) -- Output: red (dari point_a sendiri)
print("point_a.z:", point_a.z)         -- Output: 10 (dari point_a sendiri)
print("point_a.non_existent:", point_a.non_existent) -- Output: nil (tidak ada di point_a atau defaults)

-- __index sebagai fungsi
local data_store = { value = 100 }
local mt_index_func = {
    __index = function(tbl, key)
        print("DEBUG: __index dipanggil untuk tabel dengan field 'value'=" .. tbl.value .. ", mencari kunci '" .. key .. "'")
        if key == "doubled_value" then
            return tbl.value * 2
        elseif string.sub(key, 1, 4) == "get_" then
            local actual_key = string.sub(key, 5) -- Ambil nama setelah "get_"
            return tbl[actual_key] -- Akses field asli (bisa memicu __index lagi jika rekursif dan tidak hati-hati)
        else
            return "Kunci tidak ditemukan dan tidak ada handler dinamis."
        end
    end
}
setmetatable(data_store, mt_index_func)

print("data_store.value:", data_store.value)               -- Output: 100 (langsung dari tabel)
print("data_store.doubled_value:", data_store.doubled_value) -- Output: DEBUG: __index ... 200
print("data_store.get_value:", data_store.get_value)       -- Output: DEBUG: __index ... 100
print("data_store.foo:", data_store.foo)                   -- Output: DEBUG: __index ... Kunci tidak ditemukan...

-- Menggunakan rawget untuk menghindari __index
print("rawget data_store.doubled_value:", rawget(data_store, "doubled_value")) -- Output: nil
```

**Penjelasan Kode Keseluruhan (`__index`):**

- **Bagian Tabel:** `defaults` adalah tabel prototipe. `point_a` diatur untuk menggunakan `defaults` melalui `mt_index_table.__index`. Ketika `point_a.x` diakses, karena `x` tidak ada di `point_a`, Lua mencari di `defaults.x`.
- **Bagian Fungsi:** `mt_index_func.__index` adalah sebuah fungsi. Ketika `data_store.doubled_value` diakses (dan `doubled_value` tidak ada di `data_store`), fungsi `__index` dipanggil. Fungsi ini secara dinamis menghitung atau mengambil nilai berdasarkan `key`. `rawget` digunakan untuk menunjukkan cara mengambil nilai tanpa memicu `__index`.

#### `__newindex`

- **Deskripsi:** Metamethod ini dipicu ketika Anda mencoba meng-assign nilai ke field (kunci) dalam sebuah tabel yang _belum ada_ (nilainya `nil`) di tabel tersebut secara langsung.
- **Sintaks dan Perilaku:**
  - **Jika `metatable.__newindex` adalah sebuah tabel:**
    Lua akan melakukan assignment pada tabel `metatable.__newindex` tersebut, bukan pada tabel asli. `tabel_asli[kunci_baru] = nilai_baru` menjadi `(metatable.__newindex)[kunci_baru] = nilai_baru`.
  - **Jika `metatable.__newindex` adalah sebuah fungsi:**
    ```lua
    mt.__newindex = function(tabel_asli, kunci_baru, nilai_yang_diassign)
        print("Metamethod __newindex dipanggil: Kunci='" .. tostring(kunci_baru) .. "', Nilai='" .. tostring(nilai_yang_diassign) .. "'")
        -- Logika untuk menangani assignment
        -- Misalnya, melarang assignment, menyimpannya di tempat lain, validasi, dll.
        -- Jika ingin melakukan assignment sebenarnya ke tabel asli, gunakan rawset:
        -- rawset(tabel_asli, kunci_baru, nilai_yang_diassign)
    end
    ```
    Ketika `tabel[kunci_baru] = nilai_baru` dieksekusi dan `tabel[kunci_baru]` awalnya `nil` (dan `rawget(tabel, kunci_baru)` juga `nil`), Lua akan memanggil fungsi ini.
- **Penting:**
  - `__newindex` **tidak** dipicu jika field sudah ada di tabel asli. Untuk mencegat modifikasi field yang sudah ada, Anda perlu kombinasi dengan `__index` (misalnya, membuat proxy).
  - `rawset(tabel, kunci, nilai)` dapat digunakan untuk meng-assign nilai ke field tabel tanpa memicu metamethod `__newindex`.

**Contoh Kode (`__newindex`):**

```lua
local my_config = { host = "localhost" }
local log_table = {}
local mt_newindex = {
    __newindex = function(tbl, key, value)
        print("INFO: __newindex dipanggil untuk key '" .. key .. "' dengan value '" .. tostring(value) .. "'")
        if key == "port" and type(value) ~= "number" then
            error("Port harus berupa angka!", 0) -- level 0 agar error dari sini
        end
        -- Simpan ke tabel asli menggunakan rawset untuk menghindari rekursi __newindex
        rawset(tbl, key, value)
        -- Atau log perubahan
        log_table[key] = { old_value = tbl[key], new_value = value, timestamp = os.time() }
        print("INFO: '" .. key .. "' di-set ke '" .. tostring(value) .. "' dalam my_config.")
    end
}
setmetatable(my_config, mt_newindex)

print("--- Percobaan __newindex ---")
my_config.port = 8080 -- Ini field baru, __newindex akan dipanggil
print("my_config.port setelah assignment:", my_config.port)

my_config.user = "admin" -- Field baru, __newindex dipanggil
print("my_config.user:", my_config.user)

my_config.host = "127.0.0.1" -- Field 'host' sudah ada, __newindex TIDAK dipanggil
print("my_config.host setelah diubah:", my_config.host)

-- my_config.port = "invalid" -- Akan error jika tidak dikomentari

print("\n--- Log Table ---")
for k, v in pairs(log_table) do
    print(string.format("Log untuk '%s': value %s -> %s at %s", k, tostring(v.old_value), tostring(v.new_value), v.timestamp))
end

-- Menggunakan rawset untuk bypass __newindex
rawset(my_config, "secret_key", "bypass123")
print("my_config.secret_key (via rawset):", my_config.secret_key)
print("Apakah 'secret_key' ada di log_table?", log_table["secret_key"] == nil) -- true, karena rawset tidak memicu __newindex
```

**Penjelasan Kode Keseluruhan (`__newindex`):**

- `my_config` adalah tabel awal. `mt_newindex.__newindex` adalah fungsi yang akan dipanggil setiap kali field baru ditambahkan ke `my_config`.
- Fungsi `__newindex` mencetak log, melakukan validasi (untuk `port`), dan kemudian menggunakan `rawset(tbl, key, value)` untuk benar-benar menambahkan field ke tabel asli. Jika `rawset` tidak digunakan dan kita hanya melakukan `tbl[key] = value` di dalam `__newindex`, itu akan menyebabkan loop tak terbatas jika `key` masih belum ada.
- `my_config.port = 8080` dan `my_config.user = "admin"` memicu `__newindex` karena `port` dan `user` adalah field baru.
- `my_config.host = "127.0.0.1"` **tidak** memicu `__newindex` karena field `host` sudah ada di `my_config`.
- `rawset(my_config, "secret_key", ...)` menambahkan field tanpa memicu `__newindex`.

#### `__call`

- **Deskripsi:** Memungkinkan sebuah tabel untuk dipanggil seolah-olah itu adalah fungsi.
- **Sintaks:**
  ```lua
  mt.__call = function(tabel_yang_dipanggil, arg1, arg2, ...)
      print("Metamethod __call dipanggil pada tabel:", tabel_yang_dipanggil)
      -- Logika ketika tabel dipanggil
      -- Bisa mengembalikan nilai apa pun.
      local sum = 0
      for i, v in ipairs({...}) do -- {...} adalah varargs (arg1, arg2, ...)
          sum = sum + v
      end
      return "Hasil pemanggilan tabel: " .. sum
  end
  ```
  Ketika `tabel_objek(arg_a, arg_b)` dieksekusi, Lua akan memanggil fungsi `__call` dengan `tabel_objek` sebagai argumen pertama, diikuti oleh `arg_a`, `arg_b`, dst.

**Contoh Kode (`__call`):**

```lua
local callable_table = { factor = 2 }
local mt_call = {
    __call = function(tbl, ...) -- Menerima tabel itu sendiri dan varargs
        print("callable_table dipanggil! Faktornya adalah:", tbl.factor)
        local args = {...}
        local result = {}
        for i, val in ipairs(args) do
            table.insert(result, val * tbl.factor)
        end
        return unpack(result) -- Mengembalikan hasil sebagai multiple return values
    end
}
setmetatable(callable_table, mt_call)

print("--- Percobaan __call ---")
local x, y, z = callable_table(10, 20, 30) -- Memanggil tabel seperti fungsi
print("Hasil dari callable_table(10, 20, 30):", x, y, z) -- Output: 20 40 60
```

**Penjelasan Kode Keseluruhan (`__call`):**

- `callable_table` adalah tabel yang ingin kita buat bisa dipanggil.
- `mt_call.__call` adalah fungsi yang akan dieksekusi. Ia menerima `callable_table` itu sendiri sebagai argumen pertama (`tbl`), diikuti oleh argumen lain yang diteruskan saat pemanggilan (ditangkap oleh `...`).
- Fungsi `__call` mengalikan setiap argumen dengan `tbl.factor` dan mengembalikan hasilnya.
- `callable_table(10, 20, 30)` memicu metamethod `__call`.

#### Metamethod Lainnya (Ringkasan)

- **`__tostring(tbl)`:** Dipanggil oleh `print(tbl)` atau `tostring(tbl)`. Harus mengembalikan string.
  ```lua
  local mt_tostring = { __tostring = function(t) return "MyTable(size=" .. #t .. ")" end }
  local my_list = {1,2,3}; setmetatable(my_list, mt_tostring)
  print(my_list) -- Output: MyTable(size=3)
  ```
- **Operator Aritmatika:**
  - `__add(a, b)` untuk `a + b`
  - `__sub(a, b)` untuk `a - b`
  - `__mul(a, b)` untuk `a * b`
  - `__div(a, b)` untuk `a / b`
  - `__mod(a, b)` untuk `a % b`
  - `__pow(a, b)` untuk `a ^ b`
  - `__unm(a)` untuk `-a` (unary minus)
  <!-- end list -->
  ```lua
  -- Contoh __add sudah ada di bagian Metatable Basics
  local mt_unm = { __unm = function(vec) return {x = -vec.x, y = -vec.y} end }
  local vec1 = {x=1, y=2}; setmetatable(vec1, mt_unm)
  local neg_vec1 = -vec1
  print(neg_vec1.x, neg_vec1.y) -- Output: -1 -2
  ```
- **`__concat(a, b)`:** Dipanggil untuk `a .. b`.
  ```lua
  local mt_concat = { __concat = function(s1, s2) return tostring(s1.val) .. " " .. tostring(s2.val) end }
  local str_obj1 = {val = "Hello"}; setmetatable(str_obj1, mt_concat)
  local str_obj2 = {val = "World"}; setmetatable(str_obj2, mt_concat) -- Bisa juga hanya satu yang punya mt
  print(str_obj1 .. str_obj2) -- Output: Hello World
  ```
- **`__len(tbl)`:** Dipanggil untuk `#tbl`. Harus mengembalikan angka.
  ```lua
  -- Misal kita ingin #tbl mengembalikan jumlah field, bukan hanya panjang array part
  local mt_len = { __len = function(t) local count = 0; for _ in pairs(t) do count = count + 1 end; return count end }
  local my_obj_len = {a=1,b=2,c=3}; setmetatable(my_obj_len, mt_len)
  print("#my_obj_len:", #my_obj_len) -- Output: 3
  ```
- **Operator Relasional:**
  - `__eq(a, b)` untuk `a == b`. Mengembalikan boolean. Jika `__eq` ada, Lua _tidak_ mencoba membalik operand.
  - `__lt(a, b)` untuk `a < b`. Mengembalikan boolean.
  - `__le(a, b)` untuk `a <= b`. Mengembalikan boolean.
  - (Untuk `>` dan `>=`, Lua menggunakan `__lt` dan `__le` dengan membalik operand: `a > b` adalah `b < a`, `a >= b` adalah `b <= a`).
  <!-- end list -->
  ```lua
  -- Contoh __eq sudah ada di bagian Metatable Basics
  local mt_lt = { __lt = function(v1, v2) return v1.priority < v2.priority end }
  local task1 = {priority=1}; setmetatable(task1, mt_lt)
  local task2 = {priority=2}; setmetatable(task2, mt_lt)
  print("task1 < task2:", task1 < task2) -- Output: true
  ```

---

### 10.3 Kasus Penggunaan Lanjutan

Metatable membuka banyak kemungkinan untuk pola desain tingkat lanjut.

#### Read-only Tables (Tabel Hanya-Baca)

- **Deskripsi:** Anda dapat membuat tabel yang isinya tidak dapat diubah setelah dibuat, atau tidak dapat ditambahi field baru.
- **Cara:** Gunakan `__newindex` untuk mencegah penambahan/modifikasi. `__index` bisa menunjuk ke tabel data internal yang sebenarnya.

**Contoh Kode:**

```lua
function create_readonly_table(initial_data)
    local internal_data = {} -- Tabel data aktual yang "tersembunyi"
    for k, v in pairs(initial_data or {}) do
        internal_data[k] = v
    end

    local mt_readonly = {
        __index = internal_data, -- Pembacaan dialihkan ke internal_data

        __newindex = function(tbl, key, value)
            error("Attempt to modify a read-only table (key: " .. tostring(key) .. ")", 2)
        end,

        __tostring = function(tbl)
            local s = "ReadOnlyTable { "
            for k,v in pairs(internal_data) do s = s .. tostring(k)..":"..tostring(v)..", " end
            if #s > string.len("ReadOnlyTable { ") then s = string.sub(s, 1, #s-2) end -- hapus koma terakhir
            return s .. " }"
        end
    }

    local proxy_table = {} -- Tabel proxy yang akan digunakan pengguna
    setmetatable(proxy_table, mt_readonly)
    return proxy_table
end

print("--- Percobaan Read-only Table ---")
local const_config = create_readonly_table({ version = "1.0", author = "LuaDev" })

print(const_config) -- Output: ReadOnlyTable { version:1.0, author:LuaDev }
print("Versi:", const_config.version) -- Output: Versi: 1.0

-- Mencoba mengubah atau menambah field (akan error jika tidak ditangani pcall)
local success_write, err_write = pcall(function() const_config.version = "2.0" end)
if not success_write then print("Error saat menulis:", err_write) end
-- Output: Error saat menulis: ...Attempt to modify a read-only table (key: version)

local success_add, err_add = pcall(function() const_config.new_field = "test" end)
if not success_add then print("Error saat menambah:", err_add) end
-- Output: Error saat menambah: ...Attempt to modify a read-only table (key: new_field)
```

**Penjelasan Kode Keseluruhan (Read-only Table):**

- `create_readonly_table` membuat tabel "hanya-baca".
- `internal_data`: Menyimpan data sebenarnya.
- `proxy_table`: Tabel yang dikembalikan ke pengguna. Metatablenya adalah `mt_readonly`.
- `mt_readonly.__index = internal_data`: Ketika field dibaca dari `proxy_table` dan tidak ada, Lua akan mencarinya di `internal_data`.
- `mt_readonly.__newindex`: Jika ada upaya untuk menulis ke `proxy_table` (baik field baru maupun yang sudah ada karena `__index` hanya untuk baca), fungsi ini akan dipanggil dan memunculkan error. Ini secara efektif membuat `proxy_table` menjadi hanya-baca.

#### Default Table Values (Nilai Default Tabel)

- **Deskripsi:** Jika sebuah kunci tidak ditemukan dalam tabel, Anda bisa membuatnya mengembalikan nilai default tertentu daripada `nil`.
- **Cara:** Gunakan `__index` sebagai fungsi.

**Contoh Kode:**

```lua
function create_table_with_defaults(default_values_table)
    local mt_default = {
        __index = function(tbl, key)
            -- Jika kunci tidak ada di 'tbl', kembalikan dari 'default_values_table'
            -- atau nilai default absolut jika tidak ada di sana juga.
            local default_val = default_values_table[key]
            if default_val ~= nil then
                print("INFO: Menggunakan nilai default untuk kunci '" .. key .. "': " .. tostring(default_val))
                return default_val
            else
                print("WARN: Kunci '" .. key .. "' tidak ditemukan dan tidak ada default.")
                return nil -- Atau default global seperti 0 atau "N/A"
            end
        end
    }
    local new_table = {}
    setmetatable(new_table, mt_default)
    return new_table
end

print("\n--- Percobaan Default Table Values ---")
local my_settings = create_table_with_defaults({
    theme = "dark",
    fontsize = 12,
    show_line_numbers = true
})

my_settings.user_name = "Alex" -- Ini adalah field baru yang ditambahkan langsung ke my_settings

print("User:", my_settings.user_name)          -- Output: Alex (langsung dari my_settings)
print("Tema:", my_settings.theme)            -- Output: INFO: ... dark
print("Font Size:", my_settings.fontsize)      -- Output: INFO: ... 12
print("Line Numbers:", my_settings.show_line_numbers) -- Output: INFO: ... true
print("Plugin Aktif:", my_settings.active_plugin) -- Output: WARN: ... nil
```

**Penjelasan Kode Keseluruhan (Default Table Values):**

- `create_table_with_defaults` mengembalikan tabel baru yang, ketika field yang tidak ada diakses, akan mencoba mengambil nilai dari `default_values_table` melalui metamethod `__index` (yang berupa fungsi).
- `my_settings.user_name = "Alex"` menambahkan field langsung ke `my_settings`.
- Ketika `my_settings.theme` diakses, karena tidak ada di `my_settings`, fungsi `__index` dipanggil, yang kemudian mengambil nilai dari `default_values_table.theme`.

#### Proxies dan Dynamic Dispatch (Proksi dan Dispatch Dinamis)

- **Deskripsi:**
  - **Proxy Table:** Sebuah tabel yang bertindak sebagai perantara untuk objek atau sumber daya lain. Semua operasi pada proxy dapat dicegat oleh metatablenya, yang kemudian dapat mendelegasikan, memodifikasi, atau mencatat operasi tersebut sebelum (atau setelah) berinteraksi dengan objek target sebenarnya.
  - **Dynamic Dispatch:** Menggunakan `__index` (atau `__call`) untuk secara dinamis menentukan fungsi mana yang akan dijalankan atau nilai apa yang akan dikembalikan berdasarkan kunci yang diminta atau argumen yang diberikan.
- **Cara:** Gunakan `__index`, `__newindex`, dan `__call` untuk mencegat operasi.

**Contoh Kode:**

```lua
-- Membuat Proxy untuk logging dan akses terkontrol
function create_logged_proxy(target_table)
    local mt_proxy = {
        __index = function(proxy_tbl, key)
            print("PROXY LOG (GET): Mengakses kunci '" .. tostring(key) .. "'")
            local value = target_table[key] -- Ambil dari tabel target asli
            if type(value) == "function" then
                print("PROXY LOG (GET): Kunci '" .. tostring(key) .. "' adalah fungsi.")
                -- Jika kita ingin memanggil fungsi target dengan 'target_table' sebagai self,
                -- kita bisa mengembalikan fungsi wrapper atau menanganinya secara berbeda.
                -- Untuk kesederhanaan, kita kembalikan fungsinya langsung.
            end
            return value
        end,

        __newindex = function(proxy_tbl, key, value)
            print("PROXY LOG (SET): Mencoba mengatur kunci '" .. tostring(key) .. "' ke '" .. tostring(value) .. "'")
            if key == "id" then -- Contoh: 'id' tidak boleh diubah
                print("PROXY WARN: Kunci 'id' tidak dapat diubah.")
                return -- Abaikan assignment
            end
            target_table[key] = value -- Set pada tabel target asli
            print("PROXY LOG (SET): Kunci '" .. tostring(key) .. "' diatur.")
        end,

        __call = function(proxy_tbl, ...)
            print("PROXY LOG (CALL): Proxy dipanggil sebagai fungsi.")
            -- Jika tabel target memiliki metode default untuk dipanggil atau jika proxy itu sendiri
            -- seharusnya bisa dipanggil, implementasikan di sini.
            -- Misalnya, panggil fungsi default pada target_table jika ada.
            if type(target_table.default_action) == "function" then
                return target_table.default_action(target_table, ...)
            else
                error("Proxy ini tidak dapat dipanggil sebagai fungsi (tidak ada default_action).")
            end
        end
    }

    local proxy = {}
    setmetatable(proxy, mt_proxy)
    return proxy
end

print("\n--- Percobaan Proxy Table ---")
local real_object = { data = "Data Rahasia", id = 101, process = function(self, val) return "Processed: "..self.data.." with "..val end }
function real_object:default_action(val1, val2) -- Menambah metode agar bisa dipanggil
    return "Default action called on proxy with: " .. tostring(val1) .. ", " .. tostring(val2)
end

local obj_proxy = create_logged_proxy(real_object)

print("Mengambil data:", obj_proxy.data)
-- Output: PROXY LOG (GET): Mengakses kunci 'data'
-- Output: Data Rahasia

obj_proxy.data = "Data Baru"
-- Output: PROXY LOG (SET): Mencoba mengatur kunci 'data' ke 'Data Baru'
-- Output: PROXY LOG (SET): Kunci 'data' diatur.
print("Data setelah diubah:", obj_proxy.data) -- Akan log lagi

obj_proxy.id = 202 -- Mencoba mengubah ID
-- Output: PROXY LOG (SET): Mencoba mengatur kunci 'id' ke '202'
-- Output: PROXY WARN: Kunci 'id' tidak dapat diubah.
print("ID setelah percobaan ubah:", obj_proxy.id) -- Tetap 101 (karena diambil dari real_object)

-- Memanggil metode melalui proxy
local processor_func = obj_proxy.process
if processor_func then
    -- Perhatikan: 'self' harus diatur dengan benar jika memanggil fungsi yang diambil.
    -- obj_proxy:process() akan menangani ini lebih baik jika 'process' dikenal oleh __index proxy
    -- atau jika kita mengembalikan fungsi yang sudah di-bind.
    -- Cara sederhana: panggil dengan real_object sebagai self.
    print("Hasil proses:", processor_func(real_object, "input data"))
end

-- Memanggil proxy sebagai fungsi
print(obj_proxy("arg1_for_call", 77))
-- Output:
-- PROXY LOG (CALL): Proxy dipanggil sebagai fungsi.
-- Default action called on proxy with: arg1_for_call, 77
```

**Penjelasan Kode Keseluruhan (Proxy Table):**

- `create_logged_proxy(target_table)`: Membuat tabel proxy yang "membungkus" `target_table`.
- `mt_proxy.__index`: Ketika field dibaca dari proxy, fungsi ini mencatat akses tersebut dan kemudian mengambil nilai dari `target_table` asli.
- `mt_proxy.__newindex`: Ketika field ditulis ke proxy, fungsi ini mencatatnya. Ia juga memiliki logika khusus untuk mencegah field `id` diubah. Assignment lain diteruskan ke `target_table`.
- `mt_proxy.__call`: Memungkinkan proxy dipanggil sebagai fungsi, yang mendelegasikannya ke `target_table.default_action` jika ada.
- Ini mendemonstrasikan bagaimana proxy dapat mencegat, mencatat, memvalidasi, atau mengubah operasi sebelum meneruskannya ke objek yang sebenarnya.

---

Metatable adalah alat yang sangat ekspresif di Lua. Dengan memahaminya, Anda dapat membuat abstraksi data dan perilaku yang sangat canggih, yang bisa sangat berguna dalam merancang plugin Neovim yang kompleks dan elegan.

[10]: ../../README.md/#10-neovim-integration-fundamentals
