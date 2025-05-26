# Concatenation Operator

### Dasar

Concatenation operator di Lua dilambangkan dengan `..`. Fungsinya adalah untuk menggabungkan dua string menjadi satu string baru.

**Contoh:**

```lua
local foo = "Hello"
local bar = "world"
local result = foo .. bar
print(result) -- Output: "Helloworld"
```

Perhatikan bahwa tidak ada spasi antara `"Hello"` dan `"world"` karena kita tidak menambahkan spasi secara eksplisit.

### Menambahkan Spasi

Untuk menambahkan spasi antara dua string, kita dapat menambahkan string spasi secara eksplisit.

**Contoh:**

```Lua
local foo = "Hello"
local bar = "world"
local result = foo .. " " .. bar
print(result) -- Output: "Hello world"
```

### Menggabungkan String dengan Nilai Lain

Concatenation operator juga dapat digunakan untuk menggabungkan string dengan nilai lain yang dapat diubah menjadi string, seperti number.

**Contoh:**

```Lua
local foo = "Nilai: "
local bar = 42
local result = foo .. bar
print(result) -- Output: "Nilai: 42"
```

Perhatikan bahwa nilai number 42 diubah menjadi string secara otomatis.

### Menggabungkan String dengan Nilai yang Tidak Dapat Diubah Menjadi String

Jika kita mencoba menggabungkan string dengan nilai yang tidak dapat diubah menjadi string, seperti table atau function, maka akan terjadi error.

**Contoh:**

```Lua
local foo = "Nilai: "
local bar = {}
local result = foo .. bar
-- Error: attempt to concatenate a table value
```

### Menggunakan Concatenation Operator dengan Fungsi

Concatenation operator juga dapat digunakan dengan fungsi yang mengembalikan string.

**Contoh:**

```Lua
local function getName()
return "John Doe"
end

local result = "Nama: " .. getName()
print(result) -- Output: "Nama: John Doe"
```

### Menggunakan Concatenation Operator dengan Loop

Concatenation operator juga dapat digunakan dalam loop untuk menggabungkan string secara dinamis.

**Contoh:**

```Lua
local result = ""
for i = 1, 5 do
result = result .. tostring(i) .. " "
end
print(result) -- Output: "1 2 3 4 5 "
```

### Tips dan Trik

- Gunakan concatenation operator untuk menggabungkan string yang relatif kecil. Jika kamu perlu menggabungkan string yang sangat besar, maka menggunakan table dan fungsi `table.concat()` mungkin lebih efisien.
- Pastikan kamu menambahkan spasi atau karakter lain yang diperlukan secara eksplisit untuk menghindari hasil yang tidak diinginkan.
- Gunakan fungsi `tostring()` untuk mengubah nilai yang tidak dapat diubah menjadi string menjadi string sebelum menggabungkannya dengan string lain.

#### Demikian tutorial dasar-dasar hingga mahir tentang concatenation operator di Lua.
