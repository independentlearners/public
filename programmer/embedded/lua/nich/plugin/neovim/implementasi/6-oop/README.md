## [6\. Object-Oriented Programming (OOP) di Lua][6]

Bagian ini akan menjelaskan bagaimana tabel dapat digunakan untuk merepresentasikan objek, dan bagaimana metatable memungkinkan implementasi pola OOP seperti pewarisan (inheritance) dan enkapsulasi. Sebelum melanjutkan perlu kita ketahui terlebih dahulu bahwa pada dasarnya Lua tidak memiliki konsep kelas (class) bawaan seperti bahasa OOP lainnya (misalnya Java atau C++). Namun, OOP disni dapat diimplementasikan di Lua menggunakan tabel dan fitur canggihnya yang disebut metatable. Pendekatan ini biasanya bersifat prototype-based.

---

### 6.1 Table sebagai Objects (Tabel sebagai Objek)

- **Deskripsi Konsep OOP di Lua:** Di Lua, objek pada dasarnya adalah tabel yang berisi data (disebut _fields_ atau _properties_) dan fungsi yang beroperasi pada data tersebut (disebut _methods_). Tidak ada perbedaan sintaksis khusus untuk "objek"; itu hanyalah sebuah tabel yang digunakan dengan cara tertentu.
- **Terminologi:**
  - **Object (Objek):** Sebuah entitas yang menggabungkan data (state) dan perilaku (metode) yang beroperasi pada data tersebut. Di Lua, ini direpresentasikan oleh tabel.
  - **Method (Metode):** Fungsi yang berasosiasi dengan objek (tabel) dan biasanya beroperasi pada data objek tersebut.
  - **`self`:** Sebuah parameter implisit (atau eksplisit) dalam metode yang merujuk pada objek itu sendiri (tabel tempat metode dipanggil).
- **Sintaks Per Baris (Elemen Kunci):**
  - **Definisi Metode dengan Colon Syntax (`:`):**
    ```lua
    function nama_tabel:nama_metode(parameter1, parameter2, ...)
        -- 'self' secara implisit adalah parameter pertama dan merujuk ke 'nama_tabel'
        -- self.field_objek
        -- ...
    end
    ```
    Ini adalah sintaksis gula (syntactic sugar) untuk:
    ```lua
    function nama_tabel.nama_metode(self, parameter1, parameter2, ...)
        -- 'self' secara eksplisit didefinisikan sebagai parameter pertama
        -- ...
    end
    ```
  - **Pemanggilan Metode dengan Colon Syntax (`:`):**
    ```lua
    objek:nama_metode(argumen1, argumen2, ...)
    ```
    Ini adalah sintaksis gula untuk:
    ```lua
    objek.nama_metode(objek, argumen1, argumen2, ...)
    ```
    Operator colon (`:`) secara otomatis menyediakan argumen pertama (yaitu tabel itu sendiri, yang dirujuk sebagai `self` di dalam metode) ke fungsi metode.
- **Implementasi dalam Neovim:** Meskipun API Neovim inti lebih bersifat prosedural/fungsional, Anda dapat menggunakan pola OOP dalam kode plugin Anda untuk mengorganisir komponen yang kompleks, seperti UI kustom, manajemen state yang rumit, atau pustaka utilitas yang lebih terstruktur.
- **Sumber Dokumentasi Lua:**
  - Programming in Lua, 1st ed. (Chapter 16 - Object-Oriented Programming): [https://www.lua.org/pil/16.html](https://www.lua.org/pil/16.html) (Mencakup dasar-dasar penggunaan tabel sebagai objek dan `self`).

**Contoh Kode:**

```lua
-- Simple object (Objek sederhana direpresentasikan sebagai tabel)
local person = {
    name = "John",
    age = 30,
    city = "New York"
}

-- Mendefinisikan metode menggunakan colon syntax (:)
-- 'self' akan secara implisit merujuk ke tabel 'person' ketika metode ini dipanggil pada 'person'.
function person:say_hello()
    print("Hello, I'm " .. self.name .. " from " .. self.city)
end

-- Mendefinisikan metode menggunakan dot notation (.)
-- Di sini, 'self' harus dideklarasikan secara eksplisit sebagai parameter pertama.
function person.get_age(self_param) -- Menggunakan nama 'self_param' untuk kejelasan
    return self_param.age
end

-- Memanggil metode menggunakan colon syntax (:)
person:say_hello()  -- Output: Hello, I'm John from New York
                    -- Ini setara dengan person.say_hello(person)

-- Memanggil metode 'get_age'
-- Cara 1: Menggunakan colon syntax (jika metode didefinisikan dengan colon atau parameter pertama adalah self)
-- Karena person.get_age(self_param) didefinisikan dengan parameter eksplisit,
-- pemanggilan dengan colon akan bekerja karena ia memasukkan 'person' sebagai argumen pertama.
print(person.name .. "'s age is " .. person:get_age()) -- Output: John's age is 30
                                                      -- Ini setara dengan person.get_age(person)

-- Cara 2: Menggunakan dot syntax dan meneruskan 'person' secara eksplisit
print(person.name .. "'s age (manual self) is " .. person.get_age(person)) -- Output: John's age (manual self) is 30
```

**Cara Menjalankan Kode:** Simpan sebagai file `.lua` dan jalankan dengan `lua namafile.lua` atau melalui Neovim.

**Penjelasan Kode Keseluruhan:**

1.  `local person = { ... }`: Mendefinisikan tabel `person` yang menyimpan data tentang seseorang. Ini adalah "objek" kita.
2.  `function person:say_hello() ... end`:
    - **Sintaks:** `function person:say_hello()` mendefinisikan metode `say_hello` pada tabel `person`. Operator `:` adalah sintaksis gula yang secara otomatis menambahkan parameter implisit bernama `self` sebagai parameter pertama fungsi. `self` akan merujuk pada tabel `person` ketika metode ini dipanggil.
    - `print("Hello, I'm " .. self.name .. " from " .. self.city)`: Di dalam metode, `self.name` mengakses field `name` dari tabel `person`, dan `self.city` mengakses field `city`.
3.  `function person.get_age(self_param) ... end`:
    - **Sintaks:** `function person.get_age(self_param)` mendefinisikan fungsi `get_age` sebagai field dari tabel `person`. Di sini, kita harus secara eksplisit mendefinisikan parameter (saya namakan `self_param` untuk menunjukkan bahwa ini adalah parameter yang akan menerima referensi objek) yang akan memegang referensi ke objek.
    - `return self_param.age`: Mengembalikan field `age` dari objek yang diteruskan.
4.  `person:say_hello()`:
    - **Sintaks:** Memanggil metode `say_hello` pada objek `person` menggunakan operator `:`. Ini secara otomatis meneruskan `person` sebagai argumen pertama (yang menjadi `self`) ke fungsi `say_hello`.
5.  `print(person.name .. "'s age is " .. person:get_age())`:
    - **Sintaks:** `person:get_age()` juga menggunakan colon. Meskipun `get_age` didefinisikan dengan `person.get_age(self_param)`, pemanggilan dengan colon tetap valid. Lua akan meneruskan `person` sebagai argumen pertama ke `get_age`, yang kemudian diterima oleh parameter `self_param`.
6.  `print(person.name .. "'s age (manual self) is " .. person.get_age(person))`:
    - **Sintaks:** Ini adalah cara pemanggilan "manual" yang setara jika menggunakan dot notation untuk mengambil fungsi dan kemudian memanggilnya, dengan meneruskan objek (`person`) secara eksplisit sebagai argumen pertama.

**Perbedaan `:` dan `.` dalam konteks fungsi tabel:**

- `tabel:fungsi(args)` kira-kira setara dengan `tabel.fungsi(tabel, args)`.
- `function tabel:fungsi(params) ... end` kira-kira setara dengan `function tabel.fungsi(self, params) ... end`.

Colon (`:`) menyediakan cara yang lebih nyaman untuk bekerja dengan metode dan objek, menyembunyikan manajemen parameter `self` secara otomatis.

---

### 6.2 Prototype-based OOP dengan Metatables (OOP Berbasis Prototipe dengan Metatable)

Karena Lua tidak memiliki kelas bawaan, metatable digunakan untuk mengimplementasikan banyak fitur OOP, termasuk pewarisan dan perilaku khusus objek.

- **Deskripsi Konsep OOP di Lua:** Pendekatan umum adalah membuat tabel "prototipe" (sering disebut "kelas" secara informal) yang berisi metode-metode. Objek "instance" kemudian dibuat sebagai tabel baru yang menggunakan metatable untuk "mewarisi" atau mendelegasikan perilaku ke tabel prototipe ini.
- **Terminologi:**
  - **Metatable:** Sebuah tabel Lua biasa yang field-fieldnya (disebut _metamethods_) mendefinisikan bagaimana tabel lain (yang memiliki metatable ini) berperilaku dalam operasi tertentu (seperti penjumlahan, pengindeksan, dll.).
  - **Metamethod:** Kunci khusus dalam metatable (misalnya, `__index`, `__newindex`, `__tostring`, `__add`) yang nilainya adalah fungsi yang akan dipanggil ketika operasi terkait dilakukan pada tabel utama.
  - **`__index`:** Metamethod yang paling penting untuk OOP. Jika Lua mencoba mengakses field dalam tabel dan field tersebut tidak ada (bernilai `nil`), Lua akan memeriksa apakah tabel tersebut memiliki metatable dengan field `__index`.
    - Jika `metatable.__index` adalah sebuah **tabel**, Lua akan mencari field yang diminta di dalam tabel `metatable.__index` tersebut. Ini adalah mekanisme dasar untuk pewarisan metode dari prototipe.
    - Jika `metatable.__index` adalah sebuah **fungsi**, Lua akan memanggil fungsi tersebut dengan tabel asli dan kunci yang diminta sebagai argumen.
  - **Prototype-based OOP:** Model OOP di mana objek baru dibuat dengan mengkloning objek yang sudah ada (prototipe), atau dengan mendelegasikan pencarian properti/metode ke objek prototipe.
- **Sintaks Per Baris (Elemen Kunci):**
  - `setmetatable(tabel, metatable_tabel)`: Fungsi global Lua yang mengatur `metatable_tabel` sebagai metatable untuk `tabel`.
  - `getmetatable(tabel)`: Fungsi global Lua yang mengembalikan metatable dari `tabel` (atau `nil` jika tidak ada).
  - `metatable_tabel.__index = tabel_prototipe` atau `metatable_tabel.__index = fungsi_handler`.
  - `metatable_tabel.__newindex = fungsi_handler`: Dipanggil ketika mencoba meng-assign nilai ke field yang tidak ada dalam tabel.
  - `metatable_tabel.__tostring = fungsi_handler`: Dipanggil ketika tabel perlu dikonversi menjadi string (misalnya, oleh `print()`).
  - `rawset(tabel, kunci, nilai)`: Meng-assign `nilai` ke `kunci` dalam `tabel` tanpa memicu metamethod `__newindex`.
  - `rawget(tabel, kunci)`: Mengambil nilai dari `kunci` dalam `tabel` tanpa memicu metamethod `__index`.

#### Metatable Basics (Dasar-Dasar Metatable)

Metatable memungkinkan kita untuk mengubah perilaku standar tabel.

- **Implementasi dalam Neovim:** Memahami metatable penting karena beberapa API Neovim atau pustaka Lua yang digunakan mungkin menggunakannya secara internal. Untuk plugin Anda, ini memungkinkan kustomisasi perilaku data Anda secara mendalam.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (Metatables): [https://www.lua.org/manual/5.1/manual.html\#2.8](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.8)
  - Lua 5.1 Reference Manual (`setmetatable`, `getmetatable`): [https://www.lua.org/manual/5.1/manual.html\#5.1](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%235.1)
  - Programming in Lua, 1st ed. (Chapter 13 - Metatables and Metamethods): [https://www.lua.org/pil/13.html](https://www.lua.org/pil/13.html)

**Contoh Kode:**

```lua
-- Mendefinisikan metatable 'mt'
local mt = {
    -- Metamethod '__add': dipanggil ketika operator '+' digunakan pada tabel dengan metatable ini.
    __add = function(table_a, table_b)
        -- Membuat tabel baru yang merupakan hasil penjumlahan 'koordinat' dari table_a dan table_b.
        local result_table = {
            x = table_a.x + table_b.x,
            y = table_a.y + table_b.y
        }
        return result_table
    end,

    -- Metamethod '__tostring': dipanggil ketika tabel perlu dikonversi menjadi string (misalnya oleh print()).
    __tostring = function(t)
        return "Point(" .. t.x .. ", " .. t.y .. ")"
    end,

    -- Metamethod '__eq': dipanggil ketika operator '==' digunakan.
    __eq = function(table_a, table_b)
        return table_a.x == table_b.x and table_a.y == table_b.y
    end
}

-- Membuat dua tabel 'point'
local point1 = {x = 1, y = 2}
local point2 = {x = 3, y = 4}
local point3 = {x = 1, y = 2} -- Poin lain dengan nilai yang sama seperti point1

-- Mengatur 'mt' sebagai metatable untuk point1 dan point2
setmetatable(point1, mt)
setmetatable(point2, mt)
setmetatable(point3, mt)

-- Sekarang kita bisa menggunakan operator '+' pada point1 dan point2
local sum_point = point1 + point2  -- Ini akan memanggil mt.__add(point1, point2)
print("Hasil penjumlahan poin:", sum_point) -- Akan menggunakan mt.__tostring pada sum_point jika sum_point juga punya mt
                                          -- (Dalam kasus ini, sum_point adalah tabel baru tanpa metatable eksplisit,
                                          -- jadi print akan mencetaknya sebagai tabel biasa kecuali kita set metatable-nya juga)
                                          -- Agar print(sum_point) menggunakan __tostring, mt.__add harus:
                                          -- setmetatable(result_table, mt) sebelum return.
                                          -- Mari kita perbaiki mt.__add untuk konsistensi:
mt.__add = function(table_a, table_b)
    local result_table = { x = table_a.x + table_b.x, y = table_a.y + table_b.y }
    setmetatable(result_table, mt) -- Set metatable untuk hasil juga
    return result_table
end
sum_point = point1 + point2 -- Panggil lagi dengan __add yang diperbarui
print("Hasil penjumlahan poin (dengan __tostring untuk hasil):", sum_point) -- Output: Point(4, 6)

-- Menggunakan print() pada point1 akan memanggil mt.__tostring(point1)
print("Point 1:", point1) -- Output: Point 1: Point(1, 2)
print("Point 2:", point2) -- Output: Point 2: Point(3, 4)

-- Menggunakan operator '==' akan memanggil mt.__eq
print("point1 == point2 adalah", point1 == point2) -- Output: false
print("point1 == point3 adalah", point1 == point3) -- Output: true
print("point1 == {x=1, y=2} adalah", point1 == {x=1, y=2}) -- Output: false (tabel literal baru tidak memiliki metatable mt)
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya.

**Penjelasan Kode Keseluruhan:**

1.  `local mt = { ... }`: Mendefinisikan sebuah metatable `mt`.
2.  `__add = function(table_a, table_b) ... end`: Mendefinisikan metamethod `__add`. Fungsi ini akan dipanggil ketika operator `+` digunakan antara dua tabel yang memiliki `mt` sebagai metatablenya. Ia menerima kedua tabel sebagai argumen (`table_a`, `table_b`). Versi yang diperbarui juga mengatur metatable untuk tabel hasil agar `__tostring` juga berlaku padanya.
3.  `__tostring = function(t) ... end`: Mendefinisikan metamethod `__tostring`. Fungsi ini dipanggil ketika Lua mencoba mengonversi tabel `t` (yang memiliki `mt` sebagai metatablenya) menjadi representasi string, misalnya, ketika digunakan dengan `print()`.
4.  `__eq = function(table_a, table_b) ... end`: Mendefinisikan metamethod `__eq`. Fungsi ini dipanggil ketika operator `==` digunakan antara dua tabel yang keduanya memiliki `mt` sebagai metatablenya (atau jika salah satu memiliki `__eq` dan yang lain tidak).
5.  `local point1 = {x = 1, y = 2}` dan `local point2 = {x = 3, y = 4}`: Membuat dua tabel biasa.
6.  `setmetatable(point1, mt)` dan `setmetatable(point2, mt)`: Mengatur `mt` sebagai metatable untuk `point1` dan `point2`. Sekarang, operasi tertentu pada `point1` dan `point2` akan diatur oleh `mt`.
7.  `local sum_point = point1 + point2`: Karena `point1` (operand kiri) memiliki metatable dengan `__add`, metamethod `mt.__add(point1, point2)` dipanggil.
8.  `print("Point 1:", point1)`: Karena `point1` memiliki metatable dengan `__tostring`, `mt.__tostring(point1)` dipanggil untuk menghasilkan representasi string dari `point1`.
9.  `point1 == point3`: Karena `point1` memiliki metatable dengan `__eq`, `mt.__eq(point1, point3)` dipanggil.

#### Class Implementation (Implementasi "Kelas")

Menggunakan metatable (khususnya `__index`), kita dapat mensimulasikan "kelas" dan "objek" (instance).

- **Deskripsi:** Pola umum adalah:
  1.  Buat tabel yang akan bertindak sebagai "kelas" (misalnya, `Person`). Tabel ini akan menyimpan metode-metode.
  2.  Atur `Kelas.__index = Kelas`. Ini berarti jika sebuah field tidak ditemukan dalam instance, Lua akan mencarinya di dalam tabel `Kelas` itu sendiri (tempat metode-metode disimpan).
  3.  Buat fungsi "konstruktor" (misalnya, `Person:new(...)`) yang:
      - Membuat tabel baru (instance).
      - Menginisialisasi data instance.
      - Mengatur metatable instance ke tabel "kelas" (`setmetatable(instance, Kelas)`). Ini penting agar `__index` bekerja.
- **Implementasi dalam Neovim:** Pola ini memungkinkan Anda membuat abstraksi yang lebih tinggi untuk komponen plugin. Misalnya, Anda bisa memiliki "kelas" `FloatingWindow` yang mengelola pembuatan, penampilan, dan interaksi dengan jendela mengambang Neovim.
- **Sumber Dokumentasi Lua:**
  - Programming in Lua, 1st ed. (Chapter 16.1 - Inheritance, membahas `__index`): [https://www.lua.org/pil/16.1.html](https://www.lua.org/pil/16.1.html)
  - Programming in Lua, 1st ed. (Chapter 16.2 - Multiple Inheritance, meskipun contoh ini single inheritance): [https://www.lua.org/pil/16.2.html](https://www.lua.org/pil/16.2.html)

**Contoh Kode:**

```lua
-- "Class" definition (Definisi "kelas" Person)
local Person = {}  -- 'Person' adalah tabel yang akan bertindak sebagai kelas/prototipe.
Person.__index = Person -- Kunci untuk pewarisan metode:
                        -- Jika field tidak ditemukan di instance, cari di tabel Person itu sendiri.

-- Constructor function (Fungsi "konstruktor" untuk membuat instance Person)
-- Didefinisikan sebagai metode dari tabel Person agar bisa dipanggil dengan Person:new()
-- 'self' di sini akan merujuk ke tabel Person.
function Person:new(name, age)
    -- Membuat tabel baru untuk instance.
    -- 'o' adalah konvensi, bisa juga 'obj', 'instance', dll.
    local o = {}

    -- Mengatur data spesifik instance.
    o.name = name or "Unknown" -- Gunakan 'name' jika ada, jika tidak "Unknown"
    o.age = age or 0

    -- Mengatur metatable untuk instance 'o'.
    -- 'self' di sini adalah tabel 'Person', jadi metatable dari 'o' adalah 'Person'.
    -- Karena Person.__index = Person, pencarian field yang gagal di 'o' akan dialihkan ke 'Person'.
    setmetatable(o, self)

    return o -- Mengembalikan instance baru.
end

-- Metode untuk "kelas" Person
function Person:say_hello()
    -- 'self' di sini akan merujuk ke instance (misalnya, 'john' atau 'jane')
    print("Hello, I'm " .. self.name .. " and I'm " .. self.age .. " years old.")
end

function Person:get_older()
    self.age = self.age + 1
    print(self.name .. " is now " .. self.age .. " years old.")
end

-- Usage (Penggunaan "kelas" Person)
-- Membuat instance baru dari Person menggunakan konstruktor 'new'
local john = Person:new("John", 25)
local jane = Person:new("Jane", 22)
local baby = Person:new() -- Menggunakan nilai default dari konstruktor

-- Memanggil metode pada instance
john:say_hello()  -- Output: Hello, I'm John and I'm 25 years old.
jane:say_hello()  -- Output: Hello, I'm Jane and I'm 22 years old.
baby:say_hello()  -- Output: Hello, I'm Unknown and I'm 0 years old.

john:get_older()  -- Output: John is now 26 years old.
john:say_hello()  -- Output: Hello, I'm John and I'm 26 years old.
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya.

**Penjelasan Kode Keseluruhan:**

1.  `local Person = {}`: Membuat tabel kosong `Person` yang akan berfungsi sebagai "kelas" atau prototipe.
2.  `Person.__index = Person`: Ini adalah baris kunci. Ketika `Person` digunakan sebagai metatable untuk sebuah instance, dan kita mencoba mengakses field (misalnya, metode `say_hello`) pada instance tersebut yang tidak ada secara langsung di instance, Lua akan melihat `Person.__index`. Karena `Person.__index` adalah `Person` itu sendiri, Lua akan mencari field tersebut di dalam tabel `Person`.
3.  `function Person:new(name, age) ... end`: Ini adalah fungsi "konstruktor".
    - `local o = {}`: Membuat tabel kosong yang akan menjadi instance baru.
    - `o.name = name or "Unknown"`, `o.age = age or 0`: Menginisialisasi data untuk instance `o`.
    - `setmetatable(o, self)`: Di sini, `self` merujuk pada tabel `Person` (karena `Person:new` dipanggil sebagai metode dari `Person`). Jadi, ini mengatur metatable dari instance `o` menjadi `Person`. Ini menghubungkan instance dengan "kelasnya".
    - `return o`: Mengembalikan instance yang baru dibuat.
4.  `function Person:say_hello() ... end` dan `function Person:get_older() ... end`: Ini adalah metode-metode yang didefinisikan dalam "kelas" `Person`. Ketika dipanggil pada sebuah instance (misalnya, `john:say_hello()`), `self` di dalam metode ini akan merujuk pada instance tersebut (`john`).
5.  `local john = Person:new("John", 25)`: Memanggil konstruktor untuk membuat instance baru. `john` adalah tabel yang memiliki `name` dan `age`, dan metatablenya adalah `Person`.
6.  `john:say_hello()`: Ketika ini dipanggil:
    - Lua mencari `john.say_hello`. Jika `john` tidak memiliki field `say_hello` secara langsung (dan biasanya tidak, karena metode ada di "kelas"), Lua akan memeriksa metatable `john`.
    - Metatable `john` adalah `Person`. Lua memeriksa `Person.__index`.
    - `Person.__index` adalah `Person`. Jadi Lua mencari `Person.say_hello`. Ini ditemukan.
    - Fungsi `Person.say_hello` kemudian dipanggil dengan `john` sebagai argumen `self` (karena penggunaan operator `:`).

#### Inheritance (Pewarisan)

Pewarisan memungkinkan satu "kelas" (kelas turunan/derived class) untuk mewarisi properti dan metode dari "kelas" lain (kelas dasar/base class).

- **Deskripsi:** Di Lua, pewarisan antar "kelas" (tabel prototipe) dapat dicapai dengan mengatur metatable dari kelas turunan sehingga `__index`-nya merujuk ke kelas dasar. Ini menciptakan rantai pencarian: jika field tidak ditemukan di instance, ia dicari di kelas instance; jika tidak ditemukan di sana, ia dicari di kelas dasar dari kelas instance, dan seterusnya.
- **Sintaks Per Baris (Elemen Kunci Tambahan untuk Pewarisan):**
  - `setmetatable(KelasTurunan, {__index = KelasDasar})`: Ini adalah cara umum untuk mengatur pewarisan. Ketika field dicari di `KelasTurunan` (misalnya, karena `KelasTurunan` adalah `__index` dari sebuah instance) dan tidak ditemukan, Lua akan melihat metatable dari `KelasTurunan`. Jika `__index` metatable tersebut adalah `KelasDasar`, pencarian dilanjutkan di `KelasDasar`.
  - Cara yang digunakan dalam dokumen (`setmetatable(Dog, Animal)` dimana `Animal.__index = Animal` dan `Dog.__index = Dog`):
    1.  Instance `d` dari `Dog`: `getmetatable(d)` adalah `Dog`. `Dog.__index` adalah `Dog`. Jadi `d.foo` mencari `Dog.foo`.
    2.  Jika `Dog.foo` tidak ada di field `Dog`, maka karena `Dog` punya metatable `Animal` (`setmetatable(Dog, Animal)`), Lua akan mencari `Animal.foo` (karena `Animal.__index = Animal`). Ini adalah rantai yang valid untuk membuat `Dog` (sebagai tabel) mewarisi dari `Animal` (sebagai tabel).

**Contoh Kode dari Dokumen (dengan analisis):**

```lua
-- Base class (Kelas Dasar: Animal)
local Animal = {}
Animal.__index = Animal -- Agar instance Animal bisa menemukan metode di Animal

function Animal:new(name)
    local obj = { name = name or "Unknown Animal" }
    setmetatable(obj, self) -- 'self' di sini adalah tabel Animal (jika dipanggil Animal:new())
                            -- atau bisa juga tabel kelas turunan jika dipanggil secara khusus.
    return obj
end

function Animal:speak()
    print(self.name .. " makes a sound.")
end

-- Derived class (Kelas Turunan: Dog)
local Dog = {} -- Tabel untuk "kelas" Dog
Dog.__index = Dog -- Agar instance Dog bisa menemukan metode di Dog

-- Mengatur pewarisan: Dog "mewarisi" dari Animal.
-- Jika suatu field (misalnya, metode) tidak ditemukan di Dog ketika Dog sendiri diindeks,
-- Lua akan mencarinya di Animal (karena Animal adalah metatable Dog, dan Animal.__index = Animal).
setmetatable(Dog, Animal)

-- Konstruktor untuk Dog
function Dog:new(name, breed)
    -- Memanggil 'new' dari Animal BUKAN sebagai metode pada instance Animal,
    -- tetapi lebih seperti memanggil fungsi statis atau fungsi dari prototipe Animal.
    -- 'self' di sini adalah tabel 'Dog'.
    -- Jadi, Animal.new(Dog, name) dipanggil.
    -- Di dalam Animal.new(self_param, name_param):
    --    self_param akan menjadi tabel Dog.
    --    obj_animal = {name = name_param}
    --    setmetatable(obj_animal, Dog) -- karena self_param adalah Dog
    --    return obj_animal
    -- Jadi, 'obj' di sini adalah tabel yang field 'name'-nya sudah di-set,
    -- dan metatablenya adalah Dog.
    local obj = Animal.new(self, name)

    obj.breed = breed or "Unknown Breed" -- Tambahkan properti spesifik Dog

    -- Baris ini sebenarnya redundan karena Animal.new(self, name) (dengan self=Dog)
    -- sudah mengatur metatable obj ke Dog.
    -- Namun, tidak berbahaya dan menegaskan bahwa metatable obj adalah Dog.
    setmetatable(obj, self) -- 'self' di sini adalah Dog.

    return obj
end

-- Override metode 'speak' dari Animal
function Dog:speak()
    print(self.name .. " barks!")
end

-- Metode spesifik untuk Dog
function Dog:get_breed()
    return self.breed
end

-- Usage (Penggunaan)
local generic_animal = Animal:new("Generic Creature")
generic_animal:speak() -- Output: Generic Creature makes a sound.

local buddy = Dog:new("Buddy", "Golden Retriever")
buddy:speak()  -- Output: Buddy barks! (Metode Dog:speak yang di-override dipanggil)
print(buddy.name .. "'s breed is " .. buddy:get_breed()) -- Output: Buddy's breed is Golden Retriever

-- Memanggil metode yang diwarisi (jika Dog tidak meng-override-nya)
-- Mari kita tambahkan metode ke Animal yang tidak di-override oleh Dog
function Animal:eat(food)
    print(self.name .. " is eating " .. (food or "something") .. ".")
end

buddy:eat("dog food") -- Output: Buddy is eating dog food.
                      -- Cara kerja:
                      -- 1. buddy:eat -> Lua cari buddy.eat (nil).
                      -- 2. Metatable buddy adalah Dog. Dog.__index adalah Dog. Lua cari Dog.eat.
                      -- 3. Jika Dog.eat nil, karena Dog punya metatable Animal (setmetatable(Dog, Animal)),
                      --    dan Animal.__index adalah Animal, Lua cari Animal.eat. Ditemukan.
                      -- 4. Animal.eat dipanggil dengan 'buddy' sebagai 'self'.
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya.

**Penjelasan Kode Keseluruhan (Pewarisan):**

1.  **Kelas `Animal`:**
    - Didefinisikan seperti kelas `Person` sebelumnya, dengan `Animal.__index = Animal`.
    - Memiliki konstruktor `Animal:new(name)` dan metode `Animal:speak()`.
2.  **Kelas `Dog`:**
    - `Dog.__index = Dog`: Untuk instance `Dog` agar mencari metode di tabel `Dog`.
    - `setmetatable(Dog, Animal)`: Ini adalah kunci pewarisan antar "kelas". Jika suatu field (misalnya, metode `eat` yang akan kita tambahkan) dicari di `Dog` (bukan instance, tapi tabel `Dog` itu sendiri, mungkin karena menjadi target dari `__index` sebuah instance) dan tidak ditemukan, Lua akan melihat metatable dari `Dog`, yaitu `Animal`. Karena `Animal.__index = Animal`, pencarian akan dilanjutkan ke `Animal`. Ini menciptakan rantai: `instance -> Dog -> Animal`.
3.  **`function Dog:new(name, breed) ... end` (Konstruktor `Dog`):**
    - `local obj = Animal.new(self, name)`: Di sini, `self` adalah `Dog`. Jadi ini sama dengan memanggil `Animal.new(Dog, name)`. Di dalam `Animal.new`, `self` (parameter pertama) akan menjadi `Dog`. Akibatnya, `obj` yang dikembalikan oleh `Animal.new` akan memiliki metatable yang diset ke `Dog`. Ini mungkin tampak sedikit berputar, tetapi tujuannya adalah agar `obj` yang baru dibuat sudah benar terhubung ke `Dog` sebagai metatablenya, sekaligus mendapatkan inisialisasi dasar (seperti `name`) dari logika `Animal.new`.
    - `obj.breed = breed or "Unknown Breed"`: Menambahkan properti spesifik `Dog`.
    - `setmetatable(obj, self)`: `self` di sini adalah `Dog`. Baris ini memastikan (atau menegaskan kembali) bahwa metatable dari `obj` (instance `Dog` yang baru) adalah `Dog`. Mengingat perilaku `Animal.new(self, name)` di atas, baris ini mungkin redundan tetapi tidak salah.
4.  **`function Dog:speak() ... end` (Override Metode):**
    - `Dog` mendefinisikan metode `speak` sendiri. Ini akan "meng-override" (menggantikan) metode `speak` yang diwarisi dari `Animal` untuk instance `Dog`.
5.  **`buddy:speak()`:** Memanggil versi `Dog:speak()` karena `buddy` adalah instance `Dog`, dan `Dog` memiliki metode `speak`.
6.  **`buddy:eat("dog food")` (Pewarisan Metode):**
    - Ketika `buddy:eat` dipanggil:
      - Lua mencari `eat` di `buddy` (tidak ada).
      - Metatable `buddy` adalah `Dog`, dan `Dog.__index` adalah `Dog`. Lua mencari `Dog.eat`. Jika `Dog` tidak mendefinisikan `eat` (seperti dalam contoh yang diperbarui), pencarian ini gagal di tabel `Dog` secara langsung.
      - Karena tabel `Dog` itu sendiri memiliki `Animal` sebagai metatablenya (`setmetatable(Dog, Animal)`), dan `Animal.__index` adalah `Animal`, Lua kemudian mencari `Animal.eat`.
      - `Animal.eat` ditemukan dan dipanggil dengan `buddy` sebagai `self`.

Pola OOP di Lua, meskipun tidak memiliki sintaks kelas bawaan, sangat fleksibel dan kuat berkat tabel dan metatable. Memahaminya akan membuka banyak kemungkinan dalam merancang plugin Neovim yang terstruktur dengan baik.

[6]: ../README.md/#6-object-oriented-programming-oop-di-lua
