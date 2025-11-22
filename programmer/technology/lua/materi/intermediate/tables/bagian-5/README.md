# **[BAGIAN 6: METAMETHODS LENGKAP (TAMBAHAN KOMPREHENSIF)][0]**

💡 **Deskripsi Konsep**
Setiap metamethod adalah kunci khusus dalam sebuah metatable yang fungsinya dipanggil secara otomatis oleh Lua ketika operasi tertentu dilakukan pada table yang terkait. Kita akan mengelompokkannya berdasarkan jenis operasinya. Ini adalah inti dari kustomisasi perilaku di Lua. Dengan menguasai metamethods, Anda bisa membuat table berperilaku seperti angka, fungsi, atau struktur data kompleks yang Anda rancang sendiri.

Untuk contoh di seluruh bagian ini, kita akan membangun sebuah "kelas" `Vector` sederhana, yang merepresentasikan sebuah vektor 2D dengan koordinat `x` dan `y`.

```lua
-- Kerangka dasar 'kelas' Vector yang akan kita gunakan
local Vector = {}
Vector.mt = {} -- Metatable kita

function Vector.new(x, y)
    -- Factory function untuk membuat objek vector baru
    return setmetatable({x = x, y = y}, Vector.mt)
end

-- Mari definisikan metamethod di dalam Vector.mt
```
Setiap contoh metamethod di bawah ini akan ditambahkan ke dalam `Vector.mt`.

---

### **1. Arithmetic Metamethods**

Metamethods ini memungkinkan table Anda untuk merespons operator aritmatika. Fungsinya biasanya menerima dua operan (table pertama dan nilai kedua) dan harus mengembalikan hasilnya.

* `__add`: untuk operasi penjumlahan (`+`)
* `__sub`: untuk operasi pengurangan (`-`)
* `__mul`: untuk operasi perkalian (`*`)
* `__div`: untuk operasi pembagian (`/`)
* `__mod`: untuk operasi modulo (`%`)
* `__pow`: untuk operasi pangkat (`^`)
* `__unm`: untuk operasi negasi unary (`-table`)

**Contoh Kode 20: Implementasi Metamethod Aritmatika pada `Vector`**
```lua
-- Tambahkan ini ke dalam kerangka Vector kita
Vector.mt.__add = function(v1, v2)
    -- Menjumlahkan dua vector
    return Vector.new(v1.x + v2.x, v1.y + v2.y)
end

Vector.mt.__mul = function(v, scalar)
    -- Mengalikan vector dengan sebuah angka (scalar)
    return Vector.new(v.x * scalar, v.y * scalar)
end

Vector.mt.__unm = function(v)
    -- Negasi sebuah vector
    return Vector.new(-v.x, -v.y)
end

-- --- CONTOH PENGGUNAAN ---
local v1 = Vector.new(10, 20)
local v2 = Vector.new(5, 7)

local v3 = v1 + v2 -- Memanggil __add
local v4 = v1 * 2   -- Memanggil __mul
local v5 = -v2      -- Memanggil __unm

-- (Kita butuh __tostring untuk print yang bagus, kita akan tambahkan nanti)
print(v3.x, v3.y) -- Output: 15  27
print(v4.x, v4.y) -- Output: 20  40
print(v5.x, v5.y) -- Output: -5  -7
```

**Penjelasan Per-Sintaksis:**
* `Vector.mt.__add = function(v1, v2) ... end`: Saat Lua melihat `v1 + v2`, ia menemukan metamethod `__add` di metatable `v1`. Lua memanggil fungsi ini, memberikan `v1` sebagai argumen pertama dan `v2` sebagai yang kedua. Fungsi ini mengembalikan `Vector` baru yang merupakan hasil penjumlahan.
* `Vector.mt.__mul = function(v, scalar) ... end`: Sama seperti di atas, ini menangani `v1 * 2`.
* `Vector.mt.__unm = function(v) ... end`: Operator negasi bersifat *unary* (hanya satu operan), sehingga fungsinya hanya menerima satu argumen: table itu sendiri.

---

### **2. Relational Metamethods**

Metamethods ini digunakan untuk operasi perbandingan. Tanpa ini, `t1 == t2` hanya akan `true` jika `t1` dan `t2` adalah objek yang sama persis di memori.

* `__eq`: untuk perbandingan kesetaraan (`==`).
* `__lt`: untuk perbandingan "lebih kecil dari" (`<`).
* `__le`: untuk perbandingan "lebih kecil dari atau sama dengan" (`<=`).

**Aturan Penting**: Lua menangani `~=` (tidak sama dengan), `>` (lebih besar dari), dan `>=` (lebih besar dari atau sama dengan) secara otomatis jika Anda sudah mendefinisikan `__eq` dan `__lt`. Misalnya, `a > b` akan dievaluasi sebagai `b < a`.

**Contoh Kode 21: Implementasi Metamethod Relasional**
```lua
-- Tambahkan ini ke dalam Vector.mt
Vector.mt.__eq = function(v1, v2)
    -- Dua vector dianggap sama jika x dan y keduanya sama
    return v1.x == v2.x and v1.y == v2.y
end

Vector.mt.__lt = function(v1, v2)
    -- Membandingkan berdasarkan panjang (magnitude) vector dari titik asal
    local mag1 = (v1.x^2 + v1.y^2)
    local mag2 = (v2.x^2 + v2.y^2)
    return mag1 < mag2
end

-- --- CONTOH PENGGUNAAN ---
local vA = Vector.new(3, 4) -- Magnitude^2 = 9 + 16 = 25
local vB = Vector.new(3, 4)
local vC = Vector.new(5, 12) -- Magnitude^2 = 25 + 144 = 169

print("vA == vB:", vA == vB) -- Output: vA == vB: true
print("vA == vC:", vA == vC) -- Output: vA == vC: false
print("vA < vC:", vA < vC)   -- Output: vA < vC: true
print("vC > vA:", vC > vA)   -- Output: vC > vA: true (otomatis dari __lt)
```

---

### **3. Indexing Metamethods**

Ini adalah dua metamethod yang paling penting, terutama untuk membuat struktur data dan OOP.

* `__index`: Dipanggil ketika Anda mencoba mengakses key yang **tidak ada** di dalam sebuah table (`value = myTable[non_existent_key]`).
* `__newindex`: Dipanggil ketika Anda mencoba menetapkan nilai ke key yang **tidak ada** di dalam sebuah table (`myTable[non_existent_key] = value`).

**`__index`** bisa berupa **table** atau **fungsi**.
* **Jika berupa table**: Lua akan secara otomatis mencari key yang hilang di dalam table `__index` ini. Ini adalah dasar dari **inheritance (pewarisan)** di Lua.
* **Jika berupa fungsi**: Lua akan memanggil fungsi tersebut dengan argumen `(table, key)`, dan hasil dari fungsi itulah yang akan dikembalikan.

**Contoh Kode 22: Menggunakan `__index` untuk Inheritance**
```lua
local Character = {}
function Character:sayName()
    print("My name is " .. self.name)
end

-- Buat player
local player = { name = "Arjuna" }

-- Metatable player akan menggunakan 'Character' sebagai __index
setmetatable(player, { __index = Character })

-- 'sayName' tidak ada di 'player', jadi Lua mencarinya di 'Character'
player:sayName() -- Output: My name is Arjuna
```
**Penjelasan Per-Sintaksis**:
* `setmetatable(player, { __index = Character })`: Kita memberitahu `player`: jika ada yang mencoba mengakses key yang tidak ada di dalammu, coba cari di table `Character`.
* `player:sayName()`: Panggilan ini setara dengan `player.sayName(player)`. Lua mencari key `"sayName"` di `player`. Tidak ketemu. Lua lalu memeriksa metatable dan melihat `__index` menunjuk ke `Character`. Lua kemudian mencari `"sayName"` di `Character`, menemukannya, dan memanggilnya.

---

### **4. Other Metamethods**

Ini adalah metamethods serbaguna lainnya.

* `__call`: Memungkinkan table untuk dipanggil seperti sebuah fungsi.
* `__tostring`: Mengontrol bagaimana table dikonversi menjadi string (untuk `print()` atau `tostring()`).
* `__len`: Menggantikan operator panjang (`#`).
* `__concat`: Menggantikan operator konkatenasi string (`..`).

**Contoh Kode 23: Implementasi Metamethod Lainnya**
```lua
-- Tambahkan ini ke dalam Vector.mt
Vector.mt.__tostring = function(v)
    return "Vector(x=" .. v.x .. ", y=" .. v.y .. ")"
end

Vector.mt.__len = function(v)
    -- 'Panjang' vector kita definisikan sebagai magnitude-nya
    return math.sqrt(v.x^2 + v.y^2)
end

Vector.mt.__call = function(v, action)
    -- Membuat vector bisa dipanggil untuk melakukan aksi
    if action == "normalize" then
        local len = #v -- ini akan memanggil __len kita
        return Vector.new(v.x / len, v.y / len)
    end
end

-- --- CONTOH PENGGUNAAN ---
local v = Vector.new(3, 4)

print(v)          -- Memanggil __tostring. Output: Vector(x=3, y=4)
print(#v)         -- Memanggil __len. Output: 5
local normalized_v = v("normalize") -- Memanggil __call
print(normalized_v) -- Output: Vector(x=0.6, y=0.8)
```
**Penjelasan Per-Sintaksis**:
* `print(v)`: Memanggil `__tostring` yang sudah kita definisikan.
* `print(#v)`: Operator `#` memanggil metamethod `__len` kita, mengembalikan panjang geometris, bukan jumlah elemen table.
* `v("normalize")`: Karena `v` memiliki metatable dengan `__call`, ia bisa dipanggil seperti fungsi. Ini setara dengan `Vector.mt.__call(v, "normalize")`.

---

Anda sekarang telah melihat kekuatan penuh dari metamethods. Anda dapat membuat tipe data Anda sendiri yang terintegrasi penuh dengan operator-operator bawaan Lua, membuatnya sangat ekspresif dan mudah digunakan. Selanjutnya kita akan masuk pada materi ke 7 dengan judul **"7. GARBAGE COLLECTION DAN FINALIZERS"**. Ini adalah topik penting yang berkaitan dengan manajemen memori dan memperkenalkan satu metamethod terakhir yang krusial: `__gc`. 

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-7/README.md

<!----------------------------------------------------->

[0]: ../README.md#6-metamethods-lengkap-tambahan-komprehensif
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
