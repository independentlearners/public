# Panduan Lengkap Operator dalam Lua

## Daftar Isi

1. [Pengantar Operator](#pengantar-operator)
2. [Operator Aritmatika](#operator-aritmatika)
3. [Operator Relasional](#operator-relasional)
4. [Operator Logika](#operator-logika)
5. [Operator Bitwise](#operator-bitwise)
6. [Operator String](#operator-string)
7. [Operator Panjang](#operator-panjang)
8. [Operator Tabel](#operator-tabel)
9. [Precedence dan Associativity](#precedence-dan-associativity)
10. [Operator Khusus dan Metamethods](#operator-khusus-dan-metamethods)
11. [Tips dan Trik Lanjutan](#tips-dan-trik-lanjutan)
12. [Refernsi](#referensi-lengkap)
13. [Kesimpulan](#kesimpulan)

---

## [Pengantar Operator](#daftar-isi)

Operator dalam Lua adalah simbol atau kata kunci yang digunakan untuk melakukan operasi pada operand (nilai atau variabel). Lua mendukung berbagai jenis operator yang dapat dikelompokkan berdasarkan fungsinya.

**Referensi**: [Lua 5.4 Reference Manual - Expressions](https://www.lua.org/manual/5.4/manual.html#3.4)

---

## [Operator Aritmatika](#daftar-isi)

Operator aritmatika digunakan untuk melakukan operasi matematika dasar.

### Operator Dasar

| Operator | Deskripsi          | Contoh   | Hasil |
| -------- | ------------------ | -------- | ----- |
| `+`      | Penjumlahan        | `5 + 3`  | `8`   |
| `-`      | Pengurangan        | `5 - 3`  | `2`   |
| `*`      | Perkalian          | `5 * 3`  | `15`  |
| `/`      | Pembagian (float)  | `5 / 2`  | `2.5` |
| `//`     | Pembagian bulat    | `5 // 2` | `2`   |
| `%`      | Modulo (sisa bagi) | `5 % 3`  | `2`   |
| `^`      | Eksponensial       | `2 ^ 3`  | `8`   |
| `-`      | Negasi (unary)     | `-5`     | `-5`  |

### Contoh Penggunaan

```lua
-- Operasi dasar
local a = 10
local b = 3

print(a + b)    -- 13
print(a - b)    -- 7
print(a * b)    -- 30
print(a / b)    -- 3.3333333333333
print(a // b)   -- 3 (floor division)
print(a % b)    -- 1
print(a ^ b)    -- 1000

-- Operasi dengan tipe data campuran
print(10 + 2.5)     -- 12.5
print("10" + 5)     -- 15 (string otomatis dikonversi)
```

### Perilaku Khusus

```lua
-- Pembagian dengan nol
print(5 / 0)        -- inf
print(-5 / 0)       -- -inf
print(0 / 0)        -- nan

-- Modulo dengan bilangan negatif
print(-7 % 3)       -- 2 (bukan -1)
print(7 % -3)       -- -2 (bukan 1)

-- Eksponensial dengan bilangan negatif
print((-2) ^ 3)     -- -8
print(-2 ^ 3)       -- -8 (unary minus memiliki precedence rendah)
```

**Referensi**: [Lua 5.4 Reference Manual - Arithmetic Operators](https://www.lua.org/manual/5.4/manual.html#3.4.1)

---

## [Operator Relasional](#daftar-isi)

Operator relasional digunakan untuk membandingkan dua nilai dan mengembalikan boolean.

### Operator Perbandingan

| Operator | Deskripsi             | Contoh   | Hasil  |
| -------- | --------------------- | -------- | ------ |
| `==`     | Sama dengan           | `5 == 5` | `true` |
| `~=`     | Tidak sama dengan     | `5 ~= 3` | `true` |
| `<`      | Lebih dari            | `3 < 5`  | `true` |
| `>`      | kurang dari           | `5 > 3`  | `true` |
| `<=`     | Lebih dari atau sama  | `3 <= 5` | `true` |
| `>=`     | kurang dari atau sama | `5 >= 5` | `true` |

### Aturan Perbandingan

```lua
-- Perbandingan tipe yang sama
print(5 == 5)           -- true
print("hello" == "hello") -- true
print({} == {})         -- false (tabel berbeda)

-- Perbandingan tipe berbeda
print(5 == "5")         -- false
print(nil == false)     -- false
print(0 == false)       -- false

-- Perbandingan string
print("a" < "b")        -- true (berdasarkan ASCII)
print("10" < "9")       -- true (perbandingan string, bukan numerik)

-- Perbandingan dengan nil
print(nil == nil)       -- true
print(5 ~= nil)         -- true
```

### Perilaku Khusus dengan NaN

```lua
local nan = 0/0
print(nan == nan)       -- false (NaN tidak sama dengan dirinya sendiri)
print(nan ~= nan)       -- true
print(nan < 5)          -- false
print(nan > 5)          -- false
```

**Referensi**: [Lua 5.4 Reference Manual - Relational Operators](https://www.lua.org/manual/5.4/manual.html#3.4.4)

---

## [Operator Logika](#daftar-isi)

Operator logika digunakan untuk operasi boolean dan memiliki sifat short-circuit evaluation.

### Operator Logika Dasar

| Operator | Deskripsi  | Perilaku                                                     |
| -------- | ---------- | ------------------------------------------------------------ |
| `and`    | Logika AND | Mengembalikan operand pertama jika false, atau operand kedua |
| `or`     | Logika OR  | Mengembalikan operand pertama jika true, atau operand kedua  |
| `not`    | Logika NOT | Mengembalikan true jika operand false, sebaliknya false      |

### Nilai Falsy dan Truthy

Dalam Lua, hanya `false` dan `nil` yang dianggap falsy. Semua nilai lainnya (termasuk 0, "", dan tabel kosong) dianggap truthy.

```lua
-- Nilai falsy
print(not false)        -- true
print(not nil)          -- true

-- Nilai truthy
print(not 0)            -- false
print(not "")           -- false
print(not {})           -- false
print(not "false")      -- false
```

### Short-Circuit Evaluation

```lua
-- AND operator
print(false and error("ini tidak akan dieksekusi"))  -- false
print(true and "hello")     -- "hello"
print(5 and 10)            -- 10
print(nil and 10)          -- nil

-- OR operator
print(true or error("ini tidak akan dieksekusi"))   -- true
print(false or "hello")    -- "hello"
print(5 or 10)             -- 5
print(nil or 10)           -- 10
```

### Pola Penggunaan Umum

```lua
-- Default value assignment
local name = user_input or "default"

-- Conditional execution
condition and doSomething()

-- Chaining conditions
local result = a and b and c or d

-- Safe navigation (mirip optional chaining)
local value = obj and obj.property and obj.property.value
```

**Referensi**: [Lua 5.4 Reference Manual - Logical Operators](https://www.lua.org/manual/5.4/manual.html#3.4.5)

---

## [Operator Bitwise](#daftar-isi)

Operator bitwise diperkenalkan di Lua 5.3 untuk operasi bit-level pada bilangan bulat.

### Operator Bitwise Dasar

| Operator | Deskripsi           | Contoh   | Hasil |
| -------- | ------------------- | -------- | ----- |
| `&`      | Bitwise AND         | `5 & 3`  | `1`   |
| `\|`     | Bitwise OR          | `5\|3`   | `7`   |
| `~`      | Bitwise XOR         | `5 ~ 3`  | `6`   |
| `>>`     | Right shift         | `8 >> 1` | `4`   |
| `<<`     | Left shift          | `4 << 1` | `8`   |
| `~`      | Bitwise NOT (unary) | `~5`     | `-6`  |

### Contoh Penggunaan

```lua
-- Operasi bitwise dasar
local a = 5   -- 101 dalam biner
local b = 3   -- 011 dalam biner

print(a & b)  -- 1 (001 dalam biner)
print(a | b)  -- 7 (111 dalam biner)
print(a ~ b)  -- 6 (110 dalam biner)
print(~a)     -- -6 (two's complement)

-- Shift operations
print(8 >> 1) -- 4 (1000 >> 1 = 0100)
print(4 << 1) -- 8 (0100 << 1 = 1000)
print(5 >> 2) -- 1 (101 >> 2 = 001)
print(5 << 2) -- 20 (101 << 2 = 10100)
```

### Aplikasi Praktis

```lua
-- Mengecek bit tertentu
function checkBit(number, position)
    return (number & (1 << position)) ~= 0
end

-- Mengset bit tertentu
function setBit(number, position)
    return number | (1 << position)
end

-- Mengclear bit tertentu
function clearBit(number, position)
    return number & ~(1 << position)
end

-- Contoh penggunaan
local flags = 0
flags = setBit(flags, 0)    -- Set bit 0
flags = setBit(flags, 2)    -- Set bit 2
print(flags)                -- 5 (101 dalam biner)
print(checkBit(flags, 1))   -- false
print(checkBit(flags, 2))   -- true
```

**Referensi**: [Lua 5.4 Reference Manual - Bitwise Operators](https://www.lua.org/manual/5.4/manual.html#3.4.2)

---

## [Operator String](#daftar-isi)

Lua menyediakan operator khusus untuk manipulasi string.

### Operator Concatenation

```lua
-- Operator .. untuk menggabungkan string
local first = "Hello"
local second = "World"
print(first .. " " .. second)  -- "Hello World"

-- Automatic coercion
print("Number: " .. 42)        -- "Number: 42"
print(10 .. 20)                -- "1020" (bukan 30)

-- Multiple concatenation
local result = "a" .. "b" .. "c" .. "d"
print(result)  -- "abcd"
```

### Perilaku Khusus

```lua
-- Concatenation dengan nil (error)
-- print("Hello" .. nil)  -- Error!

-- Concatenation dengan boolean (error)
-- print("Value: " .. true)  -- Error!

-- Solusi: gunakan tostring()
print("Value: " .. tostring(true))  -- "Value: true"
print("Nil: " .. tostring(nil))     -- "Nil: nil"
```

### Optimasi String Concatenation

```lua
-- Tidak efisien untuk banyak concatenation
local result = ""
for i = 1, 1000 do
    result = result .. i .. " "  -- Membuat string baru setiap iterasi
end

-- Lebih efisien menggunakan table.concat
local parts = {}
for i = 1, 1000 do
    parts[i] = tostring(i)
end
local result = table.concat(parts, " ")
```

**Referensi**: [Lua 5.4 Reference Manual - Concatenation](https://www.lua.org/manual/5.4/manual.html#3.4.6)

---

## [Operator Panjang](#daftar-isi)

Operator `#` digunakan untuk mendapatkan panjang dari string atau tabel.

### Panjang String

```lua
local str = "Hello World"
print(#str)              -- 11

-- Dengan karakter Unicode
local unicode = "Hëllö"
print(#unicode)          -- Panjang dalam bytes, bukan karakter

-- String kosong
print(#"")               -- 0
```

### Panjang Tabel (Array)

```lua
-- Array dengan index berurutan
local arr = {1, 2, 3, 4, 5}
print(#arr)              -- 5

-- Array dengan gap
local gapped = {1, 2, nil, 4, 5}
print(#gapped)           -- 2 (berhenti di nil pertama)

-- Tabel dengan key non-numerik
local mixed = {a = 1, b = 2, [1] = "first"}
print(#mixed)            -- 1 (hanya menghitung array part"../../../../../../embedded/lua/operator")
```

### Perilaku Tidak Terdefinisi

```lua
-- Hasil tidak terdefinisi untuk array dengan gap
local arr1 = {1, 2, nil, 4}
local arr2 = {1, 2, [4] = 4}

print(#arr1)  -- Mungkin 2 atau 4, tergantung implementasi
print(#arr2)  -- Mungkin 2 atau 4, tergantung implementasi

-- Solusi: gunakan fungsi custom
function safeLength(t)
    local count = 0
    for i = 1, math.huge do
        if t[i] == nil then break end
        count = count + 1
    end
    return count
end
```

**Referensi**: [Lua 5.4 Reference Manual - Length Operator](https://www.lua.org/manual/5.4/manual.html#3.4.7)

---

## [Operator Tabel](#daftar-isi)

Meskipun Lua tidak memiliki operator khusus untuk tabel, ada beberapa operasi penting terkait tabel.

### Indexing Operator

```lua
-- Square bracket notation
local t = {a = 1, b = 2, [3] = "three"}
print(t["a"])    -- 1
print(t[3])      -- "three"

-- Dot notation (syntactic sugar)
print(t.a)       -- 1 (sama dengan t["a"])
print(t.b)       -- 2

-- Dynamic indexing
local key = "a"
print(t[key])    -- 1
```

### Table Constructor

```lua
-- Array-style
local arr = {10, 20, 30}
-- Sama dengan: {[1] = 10, [2] = 20, [3] = 30}

-- Hash-style
local hash = {name = "John", age = 30}
-- Sama dengan: {["name"] = "John", ["age"] = 30}

-- Mixed
local mixed = {
    "first",           -- [1] = "first"
    "second",          -- [2] = "second"
    x = 10,           -- ["x"] = 10
    [5] = "fifth"     -- [5] = "fifth"
}
```

### Multiple Assignment

```lua
-- Multiple assignment dengan tabel
local a, b, c = 1, 2, 3
print(a, b, c)  -- 1    2    3

-- Dengan function yang mengembalikan multiple values
function getCoords()
    return 10, 20
end

local x, y = getCoords()
print(x, y)     -- 10   20

-- Unpacking tabel (Lua 5.2+)
local t = {1, 2, 3}
local a, b, c = table.unpack(t)
print(a, b, c)  -- 1    2    3
```

---

## [Precedence dan Associativity](#daftar-isi)

Urutan prioritas operator dalam Lua (dari tertinggi ke terendah):

### Tabel Precedence

| Precedence | Operator                          | Associativity |      |
| ---------- | --------------------------------- | ------------- | ---- |
| 8          | `^`                               | Right         |      |
| 7          | `not` `#` `-` (unary) `~` (unary) | Right         |      |
| 6          | `*` `/` `//` `%`                  | Left          |      |
| 5          | `+` `-`                           | Left          |      |
| 4          | `..`                              | Right         |      |
| 3          | `<<` `>>`                         | Left          |      |
| 2          | `&`                               | Left          |      |
| 1          | `~` (binary)                      | Left          |      |
| 0          | `` ` ``                           | `` ` ``       | Left |
| -1         | `<` `>` `<=` `>=` `~=` `==`       | Left          |      |
| -2         | `and`                             | Left          |      |
| -3         | `or`                              | Left          |      |

### Contoh Precedence

```lua
-- Tanpa tanda kurung
print(2 + 3 * 4)        -- 14 (bukan 20)
print(2 ^ 3 ^ 2)        -- 512 (2^(3^2), bukan (2^3)^2)
print(true or false and false)  -- true (or memiliki precedence rendah)

-- Dengan tanda kurung untuk klarifikasi
print((2 + 3) * 4)      -- 20
print((2 ^ 3) ^ 2)      -- 64
print((true or false) and false)  -- false
```

### Right Associativity

```lua
-- Operator dengan right associativity
print(2 ^ 3 ^ 2)        -- 512 (dibaca sebagai 2^(3^2))
print("a" .. "b" .. "c")  -- "abc" (dibaca sebagai "a"..("b".."c"))

-- Bandingkan dengan left associativity
print(10 - 5 - 2)       -- 3 (dibaca sebagai (10-5)-2)
print(20 / 4 / 2)       -- 2.5 (dibaca sebagai (20/4)/2)
```

**Referensi**: [Lua 5.4 Reference Manual - Operator Precedence](https://www.lua.org/manual/5.4/manual.html#3.4.8)

---

## [Operator Khusus dan Metamethods](#daftar-isi)

Lua memungkinkan overloading operator melalui metamethods, memberikan fleksibilitas untuk mendefinisikan perilaku operator pada tipe data custom.

### Metamethods untuk Operator

| Operator     | Metamethod | Deskripsi          |
| ------------ | ---------- | ------------------ |
| `+`          | `__add`    | Penjumlahan        |
| `-`          | `__sub`    | Pengurangan        |
| `*`          | `__mul`    | Perkalian          |
| `/`          | `__div`    | Pembagian          |
| `//`         | `__idiv`   | Pembagian bulat    |
| `%`          | `__mod`    | Modulo             |
| `^`          | `__pow`    | Eksponensial       |
| `-` (unary)  | `__unm`    | Negasi             |
| `&`          | `__band`   | Bitwise AND        |
| `\|`         | `__bor`    | Bitwise OR         |
| `~` (binary) | `__bxor`   | Bitwise XOR        |
| `~` (unary)  | `__bnot`   | Bitwise NOT        |
| `<<`         | `__shl`    | Left shift         |
| `>>`         | `__shr`    | Right shift        |
| `..`         | `__concat` | Concatenation      |
| `#`          | `__len`    | Length             |
| `==`         | `__eq`     | Equality           |
| `<`          | `__lt`     | Less than          |
| `<=`         | `__le`     | Less than or equal |

### Contoh Implementasi Vector

```lua
-- Membuat class Vector dengan operator overloading
local Vector = {}
Vector.__index = Vector

function Vector.new(x, y)
    local v = {x = x or 0, y = y or 0}
    setmetatable(v, Vector)
    return v
end

-- Overload operator penjumlahan
function Vector.__add(a, b)
    return Vector.new(a.x + b.x, a.y + b.y)
end

-- Overload operator pengurangan
function Vector.__sub(a, b)
    return Vector.new(a.x - b.x, a.y - b.y)
end

-- Overload operator perkalian (skalar)
function Vector.__mul(a, b)
    if type(a) == "number" then
        return Vector.new(a * b.x, a * b.y)
    elseif type(b) == "number" then
        return Vector.new(a.x * b, a.y * b)
    end
end

-- Overload operator pembagian
function Vector.__div(a, b)
    if type(b) == "number" then
        return Vector.new(a.x / b, a.y / b)
    end
end

-- Overload operator negasi
function Vector.__unm(a)
    return Vector.new(-a.x, -a.y)
end

-- Overload operator equality
function Vector.__eq(a, b)
    return a.x == b.x and a.y == b.y
end

-- Overload operator length
function Vector.__len(a)
    return math.sqrt(a.x^2 + a.y^2)
end

-- Overload tostring untuk debugging
function Vector.__tostring(a)
    return string.format("Vector(%.2f, %.2f)", a.x, a.y)
end

-- Contoh penggunaan
local v1 = Vector.new(3, 4)
local v2 = Vector.new(1, 2)

print(v1 + v2)      -- Vector(4.00, 6.00)
print(v1 - v2)      -- Vector(2.00, 2.00)
print(v1 * 2)       -- Vector(6.00, 8.00)
print(v1 / 2)       -- Vector(1.50, 2.00)
print(-v1)          -- Vector(-3.00, -4.00)
print(v1 == v2)     -- false
print(#v1)          -- 5.0
```

### Metamethods untuk Indexing

```lua
-- Membuat tabel dengan default value
function createDefaultTable(default)
    local t = {}
    local mt = {
        __index = function(table, key)
            return default
        end,
        __newindex = function(table, key, value)
            rawset(table, key, value)
        end
    }
    setmetatable(t, mt)
    return t
end

-- Contoh penggunaan
local scores = createDefaultTable(0)
print(scores.math)      -- 0 (default value)
scores.math = 85
print(scores.math)      -- 85
```

### Metamethods untuk Call

```lua
-- Membuat objek yang bisa dipanggil seperti function
local Counter = {}
Counter.__index = Counter

function Counter.new(start)
    local c = {value = start or 0}
    setmetatable(c, Counter)
    return c
end

-- Overload operator call
function Counter.__call(self, increment)
    self.value = self.value + (increment or 1)
    return self.value
end

-- Contoh penggunaan
local counter = Counter.new(10)
print(counter())        -- 11
print(counter(5))       -- 16
print(counter())        -- 17
```

**Referensi**: [Lua 5.4 Reference Manual - Metamethods](https://www.lua.org/manual/5.4/manual.html#2.4)

---

## [Tips dan Trik Lanjutan](#daftar-isi)

### 1. Short-Circuit Evaluation untuk Performance

```lua
-- Gunakan short-circuit untuk optimasi
if expensive_condition() and cheap_condition() then
    -- Urutkan kondisi dari yang termurah
end

-- Conditional assignment
local value = cache[key] or calculate_expensive_value(key)
```

### 2. Operator Precedence Tricks

```lua
-- Menggunakan precedence untuk code yang lebih bersih
local result = a and b or c  -- Ternary operator simulation

-- Hati-hati dengan edge case
local result = false and "never" or "always"  -- "always"
local result = nil and "never" or "always"    -- "always"
```

### 3. Bitwise Operations untuk Flags

```lua
-- Menggunakan bitwise untuk state management
local PERMISSIONS = {
    READ = 1,      -- 001
    WRITE = 2,     -- 010
    EXECUTE = 4    -- 100
}

function hasPermission(user, permission)
    return (user.permissions & permission) ~= 0
end

function grantPermission(user, permission)
    user.permissions = user.permissions | permission
end

function revokePermission(user, permission)
    user.permissions = user.permissions & ~permission
end

-- Contoh penggunaan
local user = {permissions = 0}
grantPermission(user, PERMISSIONS.READ | PERMISSIONS.WRITE)
print(hasPermission(user, PERMISSIONS.READ))    -- true
print(hasPermission(user, PERMISSIONS.EXECUTE)) -- false
```

### 4. String Concatenation Optimization

```lua
-- Untuk concatenation banyak string
local function joinStrings(strings, separator)
    return table.concat(strings, separator or "")
end

-- Lebih efisien daripada loop concatenation
local parts = {"Hello", "World", "From", "Lua"}
local result = joinStrings(parts, " ")
```

### 5. Safe Navigation Pattern

```lua
-- Pattern untuk menghindari nil access error
local function safeGet(obj, ...)
    local current = obj
    for _, key in ipairs({...}) do
        if type(current) ~= "table" then
            return nil
        end
        current = current[key]
    end
    return current
end

-- Penggunaan
local value = safeGet(data, "user", "profile", "name") or "Unknown"
```

### 6. Operator Overloading Best Practices

```lua
-- Selalu implement pasangan operator yang logis
-- Jika implement __lt, implement juga __le atau __eq
-- Jika implement __add, pertimbangkan __sub

-- Pastikan metamethods return tipe yang benar
function MyClass.__eq(a, b)
    -- Selalu return boolean untuk comparison
    return a.value == b.value
end

-- Gunakan rawget/rawset untuk menghindari infinite loop
function MyClass.__index(t, k)
    -- Gunakan rawget untuk mengakses tanpa trigger metamethod
    local value = rawget(t, k)
    if value then
        return value
    end
    -- Custom logic here
    return default_value
end
```

### 7. Error Handling dengan Operators

```lua
-- Gunakan pcall untuk operasi yang mungkin error
local function safeOperation(a, b, op)
    local success, result = pcall(op, a, b)
    if success then
        return result
    else
        return nil, result  -- return error message
    end
end

-- Contoh penggunaan
local result, error = safeOperation(a, b, function(x, y) return x / y end)
if result then
    print("Result:", result)
else
    print("Error:", error)
end
```

---

## [Referensi Lengkap](#daftar-isi)

### Dokumentasi Resmi Lua

- [Lua 5.4 Reference Manual](https://www.lua.org/manual/5.4/)
- [Expressions - Lua Manual](https://www.lua.org/manual/5.4/manual.html#3.4)
- [Metamethods - Lua Manual](https://www.lua.org/manual/5.4/manual.html#2.4)

### Tutorial dan Panduan Tambahan

- [Programming in Lua (4th edition)](https://www.lua.org/pil/)
- [Lua Users Wiki - Tutorials](http://lua-users.org/wiki/TutorialDirectory)
- [Learn Lua in 15 Minutes](https://tylerneylon.com/a/learn-lua/)

### Referensi Spesifik Operator

- [Lua 5.4 - Arithmetic Operators](https://www.lua.org/manual/5.4/manual.html#3.4.1)
- [Lua 5.4 - Bitwise Operators](https://www.lua.org/manual/5.4/manual.html#3.4.2)
- [Lua 5.4 - Coercions and Conversions](https://www.lua.org/manual/5.4/manual.html#3.4.3)
- [Lua 5.4 - Relational Operators](https://www.lua.org/manual/5.4/manual.html#3.4.4)
- [Lua 5.4 - Logical Operators](https://www.lua.org/manual/5.4/manual.html#3.4.5)
- [Lua 5.4 - Concatenation](https://www.lua.org/manual/5.4/manual.html#3.4.6)
- [Lua 5.4 - Length Operator](https://www.lua.org/manual/5.4/manual.html#3.4.7)
- [Lua 5.4 - Precedence](https://www.lua.org/manual/5.4/manual.html#3.4.8)

---

## [Kesimpulan](#daftar-isi)

Operator dalam Lua menyediakan fondasi yang kuat untuk manipulasi data dan kontrol alur program. Memahami perilaku setiap operator, precedence, dan kemampuan metamethods akan membantu Anda menulis code Lua yang lebih efisien dan ekspresif.

Kunci untuk menguasai operator Lua adalah:

1. Memahami perbedaan antara operator yang sama di bahasa lain
2. Memanfaatkan short-circuit evaluation untuk optimasi
3. Menggunakan metamethods untuk membuat tipe data custom yang intuitif
4. Memperhatikan precedence untuk menghindari bug yang sulit dilacak

## **Materi yang Dicakup:**

1. **Operator Aritmatika** - Semua operasi matematika dasar termasuk pembagian bulat dan modulo
2. **Operator Relasional** - Perbandingan dengan aturan khusus Lua
3. **Operator Logika** - Short-circuit evaluation dan konsep truthy/falsy
4. **Operator Bitwise** - Operasi bit-level yang diperkenalkan di Lua 5.3
5. **Operator String** - Concatenation dan optimasinya
6. **Operator Panjang** - Perilaku khusus dengan string dan tabel
7. **Precedence dan Associativity** - Urutan eksekusi operator
8. **Metamethods** - Overloading operator untuk tipe custom

## **Fitur Khusus Panduan:**

- **Contoh praktis** untuk setiap konsep
- **Referensi lengkap** ke dokumentasi resmi Lua
- **Tips dan trik lanjutan** untuk penggunaan optimal
- **Best practices** dalam implementasi
- **Perilaku khusus** yang sering diabaikan
- **Kasus edge cases** yang penting dipahami

## **Sumber Referensi yang Disertakan:**

- [Lua 5.4 Reference Manual](https://www.lua.org/manual/5.4/) - Dokumentasi resmi
- [Programming in Lua](https://www.lua.org/pil/) - Buku resmi penulis Lua
- [Lua Users Wiki](http://lua-users.org/wiki/) - Komunitas dan tutorial

Terus berlatih dengan contoh-contoh praktis dan jangan ragu untuk merujuk ke dokumentasi resmi Lua untuk detail implementasi yang lebih mendalam.

> - [Ke Atas](#)
> - [Domain Spesifik][domain-spesifik]
> - [Kurikulum][kurikulum]

[domain-spesifik]: ../../../../README.md
[kurikulum]: ../../README.md
