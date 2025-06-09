### Daftar Isi

- [**Level 1: Dasar-Dasar OOP dan Konsep Lua**](#level-1-dasar-dasar-oop-dan-konsep-lua)
  - [1.1 Pengenalan OOP di Lua](#11-pengenalan-oop-di-lua)
  - [1.2 Memahami Tables sebagai Objects](#12-memahami-tables-sebagai-objects)
  - [1.3 First-Class Functions](#13-first-class-functions)
- [**Level 2: Implementasi Dasar OOP**](#level-2-implementasi-dasar-oop)
  - [2.1 Membuat Objects Sederhana](#21-membuat-objects-sederhana)
  - [2.2 Methods dan Self Parameter](#22-methods-dan-self-parameter)
  - [2.3 Constructor Pattern](#23-constructor-pattern)
- [**Level 3: Teknik OOP Menengah**](#level-3-teknik-oop-menengah)
  - [3.1 Pengenalan Metatables](#31-pengenalan-metatables)
  - [3.2 Class Simulation](#32-class-simulation)
  - [3.3 Encapsulation Techniques](#33-encapsulation-techniques)
- [**Level 4: Inheritance dan Polymorphism**](#level-4-inheritance-dan-polymorphism)
  - [4.1 Single Inheritance](#41-single-inheritance)
- [**Level 5: Advanced OOP Patterns**](#level-5-advanced-oop-patterns)
  - [5.1 Complete Metamethods Suite](#51-complete-metamethods-suite)
  - [5.3 Composition vs Inheritance](#53-composition-vs-inheritance)
- [**Level 6: OOP Libraries dan Pendekatan Alternatif**](#level-6-oop-libraries-dan-pendekatan-alternatif)
  - [6.1 Analisis OOP Libraries](#61-analisis-oop-libraries)
- [**Level 7: Best Practices dan Optimization**](#level-7-best-practices-dan-optimization)
  - [7.1 Pertimbangan Performa](#71-pertimbangan-performa)
  - [7.2 Organisasi Kode](#72-organisasi-kode)
- [**Sumber Referensi Tambahan**](#sumber-referensi-tambahan)

---

## Level 1: Dasar-Dasar OOP dan Konsep Lua

Pada level ini, kita akan membangun fondasi paling krusial. Memahami bagian ini dengan baik akan membuat sisa perjalanan jauh lebih mudah. Kunci utama di Lua adalah **table**.

### 1.1 Pengenalan OOP di Lua

**Terminologi:**

- **Object-Oriented Programming (OOP):** Sebuah paradigma atau gaya pemrograman yang mengorganisir kode di sekitar "objek". Objek ini membungkus data (properti) dan perilaku (metode) menjadi satu kesatuan.
- **Encapsulation (Enkapsulasi):** Ide untuk menyembunyikan detail internal sebuah objek dan hanya mengekspos fungsionalitas yang diperlukan. Bayangkan sebuah mobil: Anda tidak perlu tahu cara kerja mesin untuk bisa mengendarainya; Anda hanya perlu setir, pedal gas, dan rem.
- **Abstraction (Abstraksi):** Proses menyederhanakan konsep yang kompleks dengan memodelkan kelas-kelas yang sesuai dengan masalah, dan hanya menampilkan informasi yang relevan.
- **Inheritance (Pewarisan):** Kemampuan sebuah objek (anak) untuk mewarisi properti dan metode dari objek lain (induk). Ini memungkinkan penggunaan ulang kode.
- **Polymorphism (Polimorfisme):** "Banyak bentuk". Kemampuan objek yang berbeda untuk merespons pesan (panggilan metode) yang sama dengan cara yang berbeda. Contoh: `hewan:bersuara()`. Objek `kucing` akan mengeong, objek `anjing` akan menggonggong.

**Mengapa Lua Berbeda: Prototype-based vs Class-based**
Ini adalah perbedaan paling fundamental.

- **Class-based (seperti di Dart, Java, C++):** Anda mendefinisikan sebuah "cetak biru" (class). Kemudian, Anda membuat "turunan" atau "instance" dari cetak biru tersebut. Cetak biru dan turunannya adalah dua hal yang berbeda.
- **Prototype-based (seperti di Lua, JavaScript):** Tidak ada konsep "class" yang kaku. Sebaliknya, Anda membuat objek. Untuk membuat objek baru yang serupa, Anda _mengklaoning_ atau _meniru_ objek yang sudah ada (prototipe). Di Lua, setiap objek bisa menjadi prototipe untuk objek lainnya.

Fondasi dari semua ini di Lua adalah **table**.

### 1.2 Memahami Tables sebagai Objects

Di Lua, `table` adalah satu-satunya struktur data bawaan yang kompleks. Ia adalah sebuah array asosiatif, yang berarti Anda bisa menggunakan tipe data apa pun sebagai kunci (indeks), tidak hanya angka. Karena fleksibilitas ini, `table` bisa digunakan untuk merepresentasikan segalanya: array, dictionary, namespace, dan yang terpenting, **objek**.

**Konsep:**
Sebuah objek pada dasarnya adalah kumpulan `properti` (data) dan `metode` (fungsi). Kita bisa dengan mudah merepresentasikannya menggunakan `table`.

**Sintaks Dasar:**

```lua
-- Mendefinisikan sebuah "objek" pemain menggunakan table
local Player = {
    -- Properti (Data)
    name = "Hero",
    health = 100,
    mana = 50,

    -- Metode (Perilaku/Fungsi)
    attack = function()
        print("Hero attacks!")
    end,

    heal = function(amount)
        -- 'Player.health' merujuk ke properti health di dalam table Player ini
        Player.health = Player.health + amount
        print("Hero heals for " .. amount .. " points. Current health: " .. Player.health)
    end
}

-- Mengakses properti
print("Player's name: " .. Player.name) -- Output: Player's name: Hero

-- Memanggil metode
Player.attack() -- Output: Hero attacks!
Player.heal(20) -- Output: Hero heals for 20 points. Current health: 120
```

### 1.3 First-Class Functions

**Terminologi:**

- **First-Class Citizen (Warga Kelas Satu):** Dalam bahasa pemrograman, sebuah entitas (seperti fungsi) disebut "first-class" jika ia bisa diperlakukan seperti data biasa. Artinya, ia bisa:
  1.  Disimpan dalam variabel.
  2.  Dilewatkan sebagai argumen ke fungsi lain.
  3.  Dikembalikan sebagai hasil dari fungsi lain.
  4.  Disimpan dalam struktur data (seperti table).

Lua memperlakukan fungsi sebagai _first-class citizen_. Ini adalah kunci untuk OOP di Lua. Karena fungsi bisa disimpan di dalam table, kita bisa membuat "metode" seperti yang ditunjukkan pada contoh di atas.

**Konsep Method vs Function:**

- **Function:** Blok kode yang berdiri sendiri.
- **Method:** Sebuah fungsi yang "dimiliki" oleh sebuah objek (disimpan di dalam table) dan biasanya beroperasi pada data objek tersebut.

<!-- end list -->

```lua
-- Ini adalah fungsi biasa
local function sayHello()
    print("Hello!")
end

-- Mari kita buat objek
local Greeter = {}

-- Kita "melampirkan" fungsi sayHello ke objek Greeter dan memberinya nama 'greet'
Greeter.greet = sayHello

-- Sekarang, 'greet' adalah sebuah metode dari objek Greeter
Greeter.greet() -- Output: Hello!
```

---

## Level 2: Implementasi Dasar OOP

Sekarang kita akan menggunakan fondasi dari Level 1 untuk mulai membangun pola OOP yang lebih formal.

### 2.1 Membuat Objects Sederhana

Pada dasarnya, ini adalah apa yang sudah kita lakukan. Setiap kali Anda membuat `table` dan mengisinya dengan data dan fungsi, Anda sedang membuat objek sederhana.

```lua
-- Objek untuk merepresentasikan sebuah mobil
local car = {
    brand = "Toyota",
    model = "Avanza",
    year = 2023,
    speed = 0,

    accelerate = function(increase)
        car.speed = car.speed + increase
    end,

    brake = function(decrease)
        car.speed = car.speed - decrease
    end
}

-- Mengakses dan memodifikasi data
print("Initial speed: " .. car.speed)
car.accelerate(50)
print("Speed after accelerating: " .. car.speed)
car.brake(20)
print("Speed after braking: " .. car.speed)
```

Masalahnya: Jika kita ingin membuat 10 mobil, kita harus menyalin-tempel kode ini 10 kali. Ini tidak efisien. Kita akan menyelesaikan masalah ini sebentar lagi.

### 2.2 Methods dan Self Parameter

**Masalah:** Pada contoh `car` di atas, kita secara eksplisit menulis `car.speed`. Bagaimana jika kita menamai variabelnya `myCar`? Metode `accelerate` akan rusak karena ia mencari `car`, bukan `myCar`.

**Solusi: Parameter `self`**
Lua menyediakan cara elegan untuk mengatasi ini melalui _colon operator_ (`:`).

**Terminologi:**

- **Dot Operator (`.`):** Digunakan untuk mengakses anggota table. `table.key`.
- **Colon Operator (`:`):** Gula sintaksis (_syntactic sugar_) untuk mendefinisikan dan memanggil metode. Ia secara otomatis menambahkan parameter tersembunyi bernama `self` sebagai argumen pertama. `self` ini merujuk pada objek tempat metode itu dipanggil.

**Perbandingan Sintaks:**

```lua
local Character = { name = "Aragorn", health = 100 }

-- Mendefinisikan metode DENGAN dot operator (cara manual)
function Character.takeDamage(character_instance, amount)
    character_instance.health = character_instance.health - amount
    print(character_instance.name .. " takes " .. amount .. " damage.")
end

-- Mendefinisikan metode DENGAN colon operator (cara otomatis)
function Character:showHealth()
    -- 'self' secara otomatis merujuk ke objek yang memanggil metode ini.
    -- Jadi, 'self.name' sama dengan 'Character.name' dalam kasus ini.
    print(self.name .. "'s health: " .. self.health)
end

-- Memanggil metode DENGAN dot operator
Character.takeDamage(Character, 10) -- Anda harus memberikan objeknya secara manual

-- Memanggil metode DENGAN colon operator
Character:showHealth() -- Lua secara otomatis memberikan 'Character' sebagai 'self'
```

**Aturan Praktis:**

- Gunakan titik dua (`:`) saat **mendefinisikan** fungsi yang dimaksudkan sebagai metode.
- Gunakan titik dua (`:`) saat **memanggil** metode pada sebuah objek.

### 2.3 Constructor Pattern

Untuk mengatasi masalah "menyalin-tempel" objek, kita menggunakan pola _Factory Function_ atau _Constructor_. Ini adalah fungsi yang tugasnya membuat dan mengembalikan objek baru yang sudah terkonfigurasi.

**Konsep:**
Sebuah "pabrik" (fungsi) yang menerima spesifikasi (parameter) dan menghasilkan produk (objek).

**Sintaks Dasar:**

```lua
-- Ini adalah "Constructor" atau "Factory Function" kita
function createCharacter(name, health, mana)
    -- 1. Buat table kosong sebagai dasar objek baru
    local newCharacter = {}

    -- 2. Isi propertinya dengan parameter yang diberikan
    newCharacter.name = name
    newCharacter.health = health
    newCharacter.mana = mana

    -- 3. Definisikan metodenya
    function newCharacter:introduce()
        print("Hello, my name is " .. self.name)
    end

    function newCharacter:takeDamage(amount)
        self.health = self.health - amount
        print(self.name .. " now has " .. self.health .. " HP.")
    end

    -- 4. Kembalikan objek yang sudah jadi
    return newCharacter
end

-- Sekarang kita bisa membuat banyak "instance" karakter
local player1 = createCharacter("Gandalf", 100, 200)
local player2 = createCharacter("Legolas", 120, 80)

player1:introduce() -- Output: Hello, my name is Gandalf
player2:introduce() -- Output: Hello, my name is Legolas

player2:takeDamage(30) -- Output: Legolas now has 90 HP.
```

Masalahnya: Setiap objek baru (`player1`, `player2`) memiliki salinan _sendiri_ dari semua fungsinya (`introduce`, `takeDamage`). Ini boros memori. Bayangkan jika ada 1000 karakter, maka akan ada 1000 salinan fungsi `introduce`. Kita perlu cara agar semua objek berbagi fungsi yang sama. Di sinilah `metatable` berperan.

---

## Level 3: Teknik OOP Menengah

Ini adalah level di mana keajaiban OOP Lua yang sebenarnya dimulai.

### 3.1 Pengenalan Metatables

**Terminologi:**

- **Metatable:** Sebuah `table` biasa yang memberikan "perilaku khusus" pada `table` lain. Ia seperti buku panduan untuk sebuah table.
- **Metamethod:** Kunci khusus di dalam `metatable` (selalu diawali dengan dua garis bawah, misal `__index`) yang mendefinisikan perilaku tersebut.

**Konsep:**
Bayangkan Anda mencoba mengambil kunci `warna` dari sebuah table `mobil`, tetapi kunci itu tidak ada (`mobil.warna` adalah `nil`). Biasanya, Lua akan mengembalikan `nil`. Tapi, jika `mobil` memiliki `metatable` dengan metamethod `__index`, Lua akan memeriksa `__index` untuk melihat apa yang harus dilakukan selanjutnya.

**Metamethod `__index`:**
`__index` adalah metamethod yang paling penting untuk OOP. Ia memberitahu Lua di mana harus mencari kunci jika kunci tersebut tidak ditemukan di dalam table asli.

**Visualisasi Sederhana:**
`objek` ---\> (mencari `metode`) ---\> Tidak ketemu\!
`objek` ---\> (cek metatable) ---\> Ada `__index`?
`__index` ---\> (menunjuk ke `table_prototipe`)
`objek` ---\> (mencari `metode` di `table_prototipe`) ---\> Ketemu\!

**Sintaks Dasar:**

```lua
-- 1. Prototipe atau "Class" kita. Ia akan menyimpan semua metode.
local Character = {}
function Character:introduce()
    print("I am " .. self.name)
end

-- 2. "Constructor" kita, sekarang lebih efisien
function createCharacter(name)
    -- Buat instance (objek baru) hanya dengan datanya
    local newInstance = { name = name }

    -- Atur metatable untuk instance baru ini.
    -- __index diatur ke prototipe Character kita.
    setmetatable(newInstance, { __index = Character })

    return newInstance
end

-- 3. Membuat objek
local warrior = createCharacter("Conan")
local mage = createCharacter("Merlin")

-- 4. Memanggil metode
warrior:introduce() -- Output: I am Conan
mage:introduce()  -- Output: I am Merlin
```

**Bagaimana ini bekerja?**

1.  Kita memanggil `warrior:introduce()`.
2.  Lua mencari kunci `"introduce"` di dalam table `warrior`. Tidak ada\! `warrior` hanya punya `name`.
3.  Lua memeriksa apakah `warrior` punya metatable. Ada\!
4.  Lua memeriksa apakah metatable itu punya `__index`. Ada\! Nilainya adalah table `Character`.
5.  Lua sekarang mencari kunci `"introduce"` di dalam table `Character`. Ketemu\!
6.  Lua memanggil fungsi itu dengan `warrior` sebagai `self`. `self.name` menjadi `warrior.name`.

Sekarang, `warrior` dan `mage` tidak lagi menyimpan salinan fungsi `introduce`. Mereka berdua berbagi satu fungsi yang sama yang ada di `Character`. Ini sangat efisien.

### 3.2 Class Simulation

Apa yang baru saja kita lakukan di 3.1 adalah simulasi `class` paling dasar di Lua.

- Table `Character` bertindak sebagai **"Class"** atau prototipe. Ia berisi semua perilaku (metode).
- Table `warrior` dan `mage` bertindak sebagai **"Instance"** atau objek. Mereka berisi semua data (properti).
- Fungsi `createCharacter` bertindak sebagai **"Constructor"**.
- `setmetatable` dengan `__index` adalah "lem" yang menghubungkan instance ke class-nya.

Ini adalah pola yang paling umum dan fundamental untuk OOP di Lua.

### 3.3 Encapsulation Techniques

Enkapsulasi adalah tentang menyembunyikan data. Di Lua, secara default, semua yang ada di table bersifat `public`. Kita bisa meniru anggota `private` menggunakan _closures_.

**Terminologi:**

- **Closure:** Sebuah fungsi yang "mengingat" lingkungan tempat ia dibuat. Ia bisa mengakses variabel lokal dari fungsi induknya, bahkan setelah fungsi induk itu selesai dieksekusi.

**Konsep:**
Kita akan mendefinisikan variabel "private" di dalam constructor. Karena variabel ini bersifat `local`, ia tidak bisa diakses dari luar. Namun, metode yang didefinisikan di dalam constructor yang sama bisa mengaksesnya karena mereka membentuk sebuah closure.

**Sintaks Dasar:**

```lua
function createBankAccount(initialBalance)
    -- Variabel "private". 'balance' adalah variabel lokal untuk createBankAccount.
    local balance = initialBalance

    -- Objek yang akan kita kembalikan.
    local account = {}

    -- Metode "public". Metode ini didefinisikan di dalam scope yang sama
    -- dengan 'balance', jadi ia bisa mengaksesnya (closure).
    function account:deposit(amount)
        balance = balance + amount
        print("Deposited: " .. amount)
    end

    function account:withdraw(amount)
        if balance >= amount then
            balance = balance - amount
            print("Withdrew: " .. amount)
        else
            print("Insufficient funds!")
        end
    end

    function account:getBalance()
        -- Metode ini memberikan akses 'read-only' ke balance.
        return balance
    end

    return account
end

local myAccount = createBankAccount(100)

myAccount:deposit(50)
print("Current balance: " .. myAccount:getBalance()) -- Output: Current balance: 150

myAccount:withdraw(200) -- Output: Insufficient funds!

-- Mencoba mengakses 'balance' secara langsung akan gagal.
print(myAccount.balance) -- Output: nil (karena 'balance' tidak ada di table 'account')
```

---

## Level 4: Inheritance dan Polymorphism

Pewarisan di Lua dibangun di atas konsep `metatable` yang sama.

### 4.1 Single Inheritance

**Konsep:**
Sebuah "class" anak dapat mewarisi semua metode dari "class" induk. Jika sebuah metode tidak ditemukan di anak, Lua akan mencarinya di induk. Ini dicapai dengan mengatur `__index` dari metatable anak ke class induk.

**Visualisasi:**
`Instance` -\> (tidak ketemu) -\> `Child Class` -\> (`__index` menunjuk ke Parent Class) -\> `Parent Class` -\> (ketemu)

**Sintaks Dasar:**

```lua
-- =================
-- PARENT CLASS: Shape
-- =================
local Shape = { area = 0 }
function Shape:getArea()
    return self.area
end
function Shape:printInfo()
    print("This is a generic shape.")
end

-- =================
-- CHILD CLASS: Rectangle
-- =================
-- Rectangle "mewarisi" dari Shape.
local Rectangle = {}
setmetatable(Rectangle, { __index = Shape }) -- INHERITANCE!

-- Constructor untuk Rectangle
function Rectangle:new(width, height)
    local newInstance = {
        width = width,
        height = height
    }
    -- Setiap instance Rectangle menggunakan Rectangle sebagai prototipenya
    setmetatable(newInstance, { __index = self })
    return newInstance
end

-- Method overriding (Polimorfisme)
-- Rectangle punya versi 'printInfo'-nya sendiri
function Rectangle:printInfo()
    print("I am a rectangle with width " .. self.width .. " and height " .. self.height)
end

-- Metode khusus Rectangle
function Rectangle:calculateArea()
    self.area = self.width * self.height
end

-- ============
-- PENGGUNAAN
-- ============
local myRect = Rectangle:new(10, 5)
myRect:calculateArea()

-- Memanggil metode yang diwarisi dari Shape
print("Area: " .. myRect:getArea()) -- Output: Area: 50

-- Memanggil metode yang di-override (Polimorfisme)
myRect:printInfo() -- Output: I am a rectangle with width 10 and height 5

-- Contoh objek induk
local genericShape = { area = 99 }
setmetatable(genericShape, {__index = Shape})
genericShape:printInfo() -- Output: This is a generic shape.
```

Pada contoh ini, ketika `myRect:getArea()` dipanggil:

1.  Lua tidak menemukan `getArea` di `myRect`.
2.  Ia mencari di prototipe `myRect`, yaitu `Rectangle`. Tidak ada juga.
3.  `Rectangle` memiliki metatable yang `__index`-nya menunjuk ke `Shape`.
4.  Lua sekarang mencari `getArea` di `Shape`. Ketemu\!

---

## Level 5: Advanced OOP Patterns

### 5.1 Complete Metamethods Suite

`__index` hanyalah salah satu dari banyak metamethod. Metamethod lain memungkinkan kita untuk "menimpa" (`overload`) operator-operator dasar Lua.

**Contoh:** Bagaimana cara "menjumlahkan" dua objek `Vector`?

```lua
local Vector = {}
Vector.__index = Vector -- Cara singkat untuk membuat prototipe menunjuk ke dirinya sendiri

function Vector:new(x, y)
    return setmetatable({x = x, y = y}, Vector)
end

-- Metamethod untuk penambahan (+)
function Vector.__add(vec1, vec2)
    local newX = vec1.x + vec2.x
    local newY = vec1.y + vec2.y
    return Vector:new(newX, newY)
end

-- Metamethod untuk representasi string (digunakan oleh print())
function Vector.__tostring(vec)
    return "Vector(" .. vec.x .. ", " .. vec.y .. ")"
end

-- Metamethod untuk perbandingan kesamaan (==)
function Vector.__eq(vec1, vec2)
    return vec1.x == vec2.x and vec1.y == vec2.y
end

-- PENGGUNAAN
local v1 = Vector:new(10, 20)
local v2 = Vector:new(5, 7)
local v3 = Vector:new(10, 20)

local v4 = v1 + v2 -- Memanggil __add

print("v1 is " .. tostring(v1)) -- Memanggil __tostring. Output: v1 is Vector(10, 20)
print("v4 is " .. tostring(v4)) -- Output: v4 is Vector(15, 27)

print(v1 == v2) -- Memanggil __eq. Output: false
print(v1 == v3) -- Memanggil __eq. Output: true
```

Metamethod lain yang berguna: `__sub` (-), `__mul` (\*), `__div` (/), `__lt` (\<), `__le` (\<=), `__newindex` (dipanggil saat kunci baru ditambahkan), `__call` (membuat table bisa dipanggil seperti fungsi), `__gc` (dipanggil saat objek dikumpulkan oleh garbage collector).

### 5.3 Composition vs Inheritance

**Prinsip:** "Favor composition over inheritance" (Lebih utamakan komposisi daripada pewarisan).

- **Inheritance:** Hubungan "adalah sebuah" (IS-A). `Rectangle` adalah sebuah `Shape`. Ini menciptakan hirarki yang kaku.
- **Composition:** Hubungan "memiliki sebuah" (HAS-A). `Mobil` memiliki sebuah `Mesin`. Objek dibangun dengan merakit komponen-komponen lain. Ini lebih fleksibel.

**Konsep:**
Daripada membuat class `Player` mewarisi dari `Movable` dan `Attackable`, kita buat objek `player` yang _memiliki_ komponen `movable` dan `attackable`.

**Sintaks Dasar (Pola Komponen):**

```lua
-- Komponen untuk kemampuan bergerak
local Movable = {}
function Movable:new(x, y)
    return { x = x, y = y, speed = 5 }
end
function Movable:move(dx, dy)
    self.x = self.x + dx * self.speed
    self.y = self.y + dy * self.speed
    print("Moved to " .. self.x .. ", " .. self.y)
end

-- Komponen untuk kemampuan menyerang
local Attackable = {}
function Attackable:new(damage)
    return { damage = damage }
end
function Attackable:attack(target)
    print("Dealt " .. self.damage .. " damage to " .. target.name)
end

-- Entitas yang dibangun dari komponen
function createPlayer(name)
    local player = { name = name }

    -- Tambahkan komponen
    player.position = Movable:new(0, 0)
    player.combat = Attackable:new(10)

    -- Metode "penerus" (forwarding methods)
    function player:move(...)
        Movable.move(self.position, ...)
    end

    function player:attack(...)
        Attackable.attack(self.combat, ...)
    end

    return player
end

local hero = createPlayer("Hero")
local villain = { name = "Villain" }

hero:move(1, 0) -- Output: Moved to 5, 0
hero:attack(villain) -- Output: Dealt 10 damage to Villain
```

Ini adalah dasar dari arsitektur _Entity-Component-System_ (ECS) yang sangat populer di pengembangan game.

---

## Level 6: OOP Libraries dan Pendekatan Alternatif

Meskipun Anda bisa (dan seharusnya belajar) membuat sistem OOP sendiri dari awal, ada banyak library yang menyediakan "gula sintaksis" untuk membuat kode terlihat lebih seperti bahasa class-based.

### 6.1 Analisis OOP Libraries

Berikut adalah beberapa yang populer, beserta link dan deskripsinya:

- **middleclass**
  - **Deskripsi:** Salah satu library OOP paling populer dan matang untuk Lua. Menyediakan sintaks `class`, `inheritance`, `mixins`, dan banyak lagi. Sangat direkomendasikan jika Anda menginginkan sistem class yang solid.
  - **Link:** [https://github.com/kikito/middleclass](https://github.com/kikito/middleclass)
- **30log**
  - **Deskripsi:** Library OOP yang minimalis dan ringan. Fokus pada inheritance tunggal dan mixins. Bagus jika Anda butuh sesuatu yang sederhana tanpa banyak fitur tambahan.
  - **Link:** [https://github.com/Yonaba/30log](https://github.com/Yonaba/30log)
- **SECL (Simple Embedded Class-system for Lua)**
  - **Deskripsi:** Library yang sangat kecil dan sederhana untuk membuat class dan inheritance. Cocok untuk proyek-proyek di mana ukuran library menjadi pertimbangan.
  - **Link:** [https://github.com/yslect/secl](https://www.google.com/search?q=https://github.com/yslect/secl)
- **Penlight**
  - **Deskripsi:** Ini bukan hanya library OOP, melainkan library utilitas umum yang sangat besar dan berguna untuk Lua. Di dalamnya terdapat modul `pl.class` yang menyediakan fungsionalitas OOP yang kuat.
  - **Link:** [https://github.com/lunarmodules/Penlight](https://github.com/lunarmodules/Penlight)

**Kapan Menggunakannya?**
Gunakan library jika Anda bekerja dalam tim besar di mana sintaks yang konsisten sangat penting, atau jika Anda ingin mempercepat pengembangan dan tidak mau "menemukan kembali roda". Namun, sangat penting untuk memahami cara kerjanya di balik layar (seperti yang dijelaskan di Level 1-5) agar Anda bisa melakukan debug secara efektif.

---

## Level 7: Best Practices dan Optimization

### 7.1 Pertimbangan Performa

- **Caching Metode:** Seperti yang kita lihat, setiap kali Anda memanggil metode yang diwariskan, Lua harus melakukan pencarian (`__index`). Pada aplikasi yang sangat kritis performa (misal, di dalam loop game yang berjalan 60 kali per detik), pencarian ini bisa menjadi overhead.

  - **Teknik Optimasi:** Anda bisa "menyalin" metode dari prototipe ke instance saat pertama kali diakses. Ini mempercepat panggilan berikutnya tetapi mengorbankan memori.

  <!-- end list -->

  ```lua
  -- Metatable yang melakukan caching
  local mt = {}
  mt.__index = function(instance, key)
      local value = TheClass[key] -- Cari di class
      if value ~= nil then
          instance[key] = value -- Salin ke instance untuk panggilan berikutnya
          return value
      end
  end
  ```

- **Pola Konstruktor:** Hindari membuat fungsi baru di dalam konstruktor jika memungkinkan. Letakkan semua metode di dalam table prototipe untuk menghemat memori.

### 7.2 Organisasi Kode

**Module Pattern:** Aturan terbaik adalah menempatkan setiap "class" dalam file-nya sendiri, yang dikenal sebagai _module_.

**Contoh (`player.lua`):**

```lua
-- player.lua

-- 1. Buat table lokal untuk class kita
local Player = {}
Player.__index = Player

-- 2. Definisikan constructor
function Player:new(name)
    print("Creating new player: " .. name)
    return setmetatable({ name = name }, self)
end

-- 3. Definisikan metode
function Player:sayHello()
    print("Hello from " .. self.name)
end

-- 4. Kembalikan table class agar bisa di-require oleh file lain
return Player
```

**Contoh (`main.lua`):**

```lua
-- main.lua

-- Muat modul Player. Lua akan menjalankan player.lua dan mengembalikan
-- nilai yang di-return (yaitu table Player).
local Player = require("player")

-- Gunakan class yang sudah diimpor
local p1 = Player:new("Alice")
local p2 = Player:new("Bob")

p1:sayHello()
p2:sayHello()
```

Pola ini menjaga kode Anda tetap bersih, terorganisir, dan dapat digunakan kembali.

---

## Kesimpulan dan Langkah Selanjutnya

Anda sekarang memiliki peta jalan yang sangat detail. Uraian di atas telah mengubah kurikulum Anda menjadi materi pembelajaran yang kohesif.

**Saran Saya untuk Anda:**

1.  **Praktik, Praktik, Praktik:** Ambil setiap konsep, buka editor teks, dan coba jalankan kodenya. Ubah-ubah kodenya. Lihat apa yang terjadi jika Anda menghapus `setmetatable`. Apa yang terjadi jika Anda menggunakan `.` bukan `:`? Pengalaman langsung adalah guru terbaik.
2.  **Bangun Proyek Kecil:** Cobalah membuat game teks petualangan sederhana. Anda akan butuh `Room`, `Player`, `Item`, `Monster`. Ini adalah latihan OOP yang sempurna.
3.  **Baca "Programming in Lua":** Terutama bab 13 (Metatables) dan 16 (OOP). Ini adalah sumber definitif.
4.  **Jelajahi Library (Setelah Paham Dasar):** Setelah Anda merasa nyaman dengan `metatable` dan `__index`, coba gunakan salah satu library seperti `middleclass` untuk melihat bagaimana ia menyederhanakan prosesnya.

Dengan mengikuti jalur ini, Anda tidak hanya akan belajar "cara menggunakan OOP di Lua", tetapi Anda akan benar-benar **memahami** cara kerjanya di tingkat fundamental. Ini akan memberi Anda kekuatan untuk merancang sistem yang kompleks, melakukan debug secara efisien, dan mengadaptasi pola apa pun yang Anda butuhkan untuk proyek apa pun di masa depan. **Selamat belajar\!**

### Sumber Referensi Tambahan

- **Dokumentasi Resmi:**
  - [Programming in Lua (Edisi Pertama, gratis online)](https://www.lua.org/pil/)
  - [Lua 5.4 Reference Manual](https://www.lua.org/manual/5.4/)
- **Komunitas dan Contoh Kode:**
  - [Lua-users Wiki: Object Oriented Programming](http://lua-users.org/wiki/ObjectOrientedProgramming) (Sangat direkomendasikan, berisi banyak pola berbeda)
  - [Lua Gists di GitHub](https://www.google.com/search?q=https://gist.github.com/search%3Fl%3DLua%26q%3Doop) (Contoh-contoh dari berbagai developer)

#

> - **[Ke Atas](#)**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

<!-- > - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]** -->

[domain]: ../../../../../README.md
[kurikulum]: ../../README.md

<!-- [sebelumnya]: ../../string/bagian-7/README.md
[selanjutnya]: ../bagian-2/README.md -->
