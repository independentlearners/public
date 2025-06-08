# **[BAGIAN 13: ADVANCED PATTERNS DAN TEKNIK][0]**

Kita akan beralih dari optimasi tingkat rendah ke pola arsitektur dan teknik tingkat tinggi. Bagian ini adalah tentang menggunakan tables untuk mengimplementasikan pola-pola desain yang kuat yang akan membuat kode Anda lebih bersih, lebih fleksibel, dan sering kali lebih cerdas.

Ini adalah teknik yang digunakan oleh programmer berpengalaman untuk menyelesaikan masalah-masalah umum dalam rekayasa perangkat lunak.

### **1. Serialization dan Persistence**

**Konsep**:

- **Serialization**: Proses mengubah data dalam memori (seperti table Lua) menjadi format string atau biner yang dapat disimpan ke dalam file atau dikirim melalui jaringan.
- **Persistence**: Kemampuan untuk menyimpan "keadaan" (state) dari data Anda sehingga dapat dipulihkan nanti, bahkan setelah program ditutup dan dibuka kembali.

**Implementasi**: Salah satu cara paling elegan untuk serialisasi di Lua adalah dengan mengubah table menjadi string yang merupakan **kode Lua yang valid**. Saat Anda menjalankan string ini, ia akan membangun kembali table aslinya.

**Tantangan**:

- **Fungsi**: Serialisasi fungsi sulit dilakukan.
- **Circular References**: Jika sebuah table berisi referensi ke dirinya sendiri (`t.self = t`), serializer sederhana akan masuk ke dalam loop tak terbatas.
- **Userdata**: Tipe data dari C tidak dapat diserialisasi dengan cara ini.

**Contoh Kode 35: Serializer Table Sederhana**

```lua
-- Fungsi ini hanya menangani string, angka, boolean, dan table bersarang.
function serialize(o)
    if type(o) == "string" then
        return string.format("%q", o)
    elseif type(o) == "number" or type(o) == "boolean" then
        return tostring(o)
    elseif type(o) == "table" then
        local parts = {}
        for k, v in pairs(o) do
            local key_str = "[" .. serialize(k) .. "]"
            local val_str = serialize(v)
            table.insert(parts, string.format("%s = %s", key_str, val_str))
        end
        return "{" .. table.concat(parts, ", ") .. "}"
    else
        error("Tidak bisa serialize tipe: " .. type(o))
    end
end

-- --- Penggunaan ---
local player_data = {
    name = "Laksmana",
    level = 99,
    inventory = {"Panah Abadi", "Jubah Gaib"},
    is_legend = true
}

local serialized_string = serialize(player_data)
print("String Hasil Serialisasi:\n", serialized_string)

-- Untuk memulihkan (deserialization), kita cukup jalankan string tersebut
local load_func = load("return " .. serialized_string)
local restored_data = load_func()

print("\nData yang dipulihkan:", restored_data.name)
```

### **2. Factory Patterns dan Builder Patterns**

**Konsep**: Pola desain ini adalah tentang memisahkan logika pembuatan objek dari pengguna objek tersebut.

- **Factory**: Sebuah fungsi yang tugasnya adalah membuat dan mengembalikan instance objek. Kita sudah menggunakan ini di bagian OOP dengan fungsi `ClassName:new()`. Tujuannya adalah untuk menyembunyikan detail konstruksi.
- **Builder**: Pola yang digunakan untuk membangun objek yang kompleks selangkah demi selangkah. Ini sangat berguna ketika sebuah objek memiliki banyak parameter konfigurasi. Builder memungkinkan Anda menulis kode konstruksi yang sangat mudah dibaca.

**Contoh Kode 36: Menggunakan Builder Pattern**

```lua
local PizzaBuilder = {}
PizzaBuilder.mt = { __index = PizzaBuilder }

function PizzaBuilder:new(size)
    local builder = { _config = { size = size, toppings = {} } }
    return setmetatable(builder, self.mt)
end

function PizzaBuilder:withTopping(topping)
    table.insert(self._config.toppings, topping)
    return self -- Mengembalikan self memungkinkan method chaining
end

function PizzaBuilder:withCheese(cheese_type)
    self._config.cheese = cheese_type
    return self
end

function PizzaBuilder:build()
    print("Membangun pizza " .. self._config.size .. " dengan keju " .. self._config.cheese ..
              " dan topping: " .. table.concat(self._config.toppings, ", "))
    return self._config -- Mengembalikan produk akhir
end

-- --- Penggunaan ---
local my_pizza = PizzaBuilder:new("Large")
    :withCheese("Mozzarella")
    :withTopping("Pepperoni")
    :withTopping("Mushroom")
    :build()
```

### **3. Memoization dengan Tables**

**Konsep**: Memoization adalah teknik optimasi (sejenis caching) di mana hasil dari pemanggilan fungsi yang mahal (memakan waktu) disimpan dalam sebuah table. Jika fungsi tersebut dipanggil lagi dengan argumen yang sama, hasilnya diambil dari cache (table) alih-alih dihitung ulang.

Ini sangat efektif untuk fungsi rekursif seperti menghitung deret Fibonacci.

**Contoh Kode 37: Fungsi Fibonacci dengan Memoization**

```lua
local memo_cache = {} -- Table untuk cache kita

function fib(n)
    -- Jika hasil sudah ada di cache, langsung kembalikan
    if memo_cache[n] then
        return memo_cache[n]
    end

    -- Jika tidak, hitung hasilnya
    local result
    if n < 2 then
        result = n
    else
        result = fib(n - 1) + fib(n - 2)
    end

    -- Simpan hasil ke cache sebelum mengembalikannya
    memo_cache[n] = result
    return result
end

-- Panggilan pertama mungkin butuh sedikit waktu
print("Fibonacci ke-40 adalah:", fib(40))

-- Panggilan kedua (atau pemanggilan rekursif internal) akan sangat cepat
print("Fibonacci ke-35 adalah:", fib(35))
```

### **4. Lookup Tables dan Dispatch Tables**

**Konsep**: Ini adalah pola di mana Anda menggunakan table untuk menggantikan rantai `if/elseif/else` yang panjang.

- **Lookup Table (LUT)**: Anda menggunakan nilai sebagai kunci untuk langsung "mencari" hasil yang sesuai di dalam table.
- **Dispatch Table**: Varian dari LUT di mana nilai-nilai dalam table adalah **fungsi**. Ini memungkinkan Anda untuk "mengirim" (dispatch) eksekusi ke fungsi yang benar berdasarkan input, tanpa satu pun `if`.

Pola ini membuat kode lebih bersih, lebih mudah diperluas (cukup tambahkan entri baru ke table), dan sering kali lebih cepat.

**Contoh Kode 38: Menggunakan Dispatch Table untuk Aksi Karakter**

```lua
local Player = { name = "Arjuna" }

-- Metode yang menggunakan dispatch table
function Player:performAction(action_name, target)
    local dispatch_table = {
        attack = function(t)
            print(self.name .. " menyerang " .. t .. " dengan panah!")
        end,
        defend = function()
            print(self.name .. " mengambil posisi bertahan.")
        end,
        meditate = function()
            print(self.name .. " bermeditasi untuk memulihkan energi.")
        end
    }

    -- Cari fungsi yang sesuai di dispatch table
    local action_func = dispatch_table[action_name]

    -- Jika ditemukan, panggil fungsinya
    if action_func then
        action_func(target) -- 'target' akan menjadi nil jika tidak diberikan, tidak masalah
    else
        print(self.name .. " tidak tahu cara melakukan '" .. action_name .. "'.")
    end
end

-- --- Penggunaan ---
Player:performAction("attack", "Rahwana")
Player:performAction("meditate")
Player:performAction("dance") -- Aksi tidak ditemukan
```

---

Anda telah mempelajari beberapa pola arsitektur paling berguna yang dapat diimplementasikan dengan table. Teknik-teknik ini adalah inti dari penulisan kode Lua yang matang dan dapat dipelihara.

Selanjutnya, kita akan membahas topik yang lebih teknis namun penting: **"14. VERSION-SPECIFIC FEATURES"**, yang akan membahas perbedaan perilaku table antara versi-versi Lua dan LuaJIT.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-12/README.md
[selanjutnya]: ../bagian-14/README.md

<!----------------------------------------------------->

[0]: ../README.md
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
