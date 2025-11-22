# **[BAGIAN 10: OBJECT-ORIENTED PROGRAMMING DENGAN TABLES][0]**

> Penting untuk dipahami: Lua tidak memiliki kata kunci `class` bawaan seperti bahasa lain (Dart, Java, C++). Sebaliknya, OOP di Lua adalah sebuah **pola desain** yang Anda bangun sendiri menggunakan table dan metatables. Ini memberikan fleksibilitas luar biasa.

💡 **Deskripsi Konsep**
OOP adalah cara mengorganisir kode dengan membundel data (properti) dan fungsi yang beroperasi pada data tersebut (metode) ke dalam satu unit yang disebut "objek". Di Lua, objek ini adalah sebuah table. Tiga pilar utama OOP yang akan kita implementasikan adalah:

1.  **Enkapsulasi**: Membundel data dan metode ke dalam satu objek.
2.  **Pewarisan (Inheritance)**: Membuat "kelas" baru yang mewarisi properti dan metode dari "kelas" yang sudah ada.
3.  **Polimorfisme (Polymorphism)**: Kemampuan objek dari kelas yang berbeda untuk merespons panggilan metode yang sama dengan cara yang spesifik untuk tipenya masing-masing.

---

### **1. Class Implementation menggunakan Tables**

💡 **Deskripsi Konsep**
Pola paling umum untuk mengimplementasikan "kelas" di Lua adalah dengan menggunakan **table prototipe**.

1.  **Table Prototipe ("Kelas")**: Satu table yang berisi semua **metode** (fungsi) yang akan dimiliki oleh semua objek dari kelas tersebut.
2.  **Metatable dengan `__index`**: Sebuah metatable yang `__index`-nya menunjuk ke table prototipe.
3.  **Fungsi Konstruktor (`new`)**: Sebuah fungsi yang membuat table baru (sebagai "instance" atau "objek"), menetapkan metatable padanya, dan mengisinya dengan data awal.

**Konsep Kunci: Operator Titik Dua (`:`)**
Lua menyediakan "gula sintaksis" (syntactic sugar) yang membuat OOP terasa lebih alami.

- **Saat Mendefinisikan Metode**: `function Class:method(arg1, arg2)` adalah cara singkat untuk `function Class.method(self, arg1, arg2)`. Lua secara implisit menambahkan argumen pertama bernama `self`.
- **Saat Memanggil Metode**: `myObject:method(arg1, arg2)` adalah cara singkat untuk `myObject.method(myObject, arg1, arg2)`. Lua secara implisit memberikan objek itu sendiri (`myObject`) sebagai argumen pertama.

`self` merujuk pada "instance" objek tempat metode tersebut dipanggil.

**Contoh Kode 28: Membuat "Kelas" `Character`**

```lua
-- 1. Table prototipe, ini adalah "Kelas" kita
local Character = {}
Character.mt = { __index = Character } -- Metatable menunjuk kembali ke kelas

-- 2. Fungsi Konstruktor
function Character:new(name, hp)
    local instance = {
        name = name,
        hp = hp
    }
    setmetatable(instance, self.mt)
    return instance
end

-- 3. Metode
function Character:takeDamage(amount)
    self.hp = self.hp - amount
    print(self.name .. " menerima " .. amount .. " kerusakan, HP sisa: " .. self.hp)
end

function Character:getStatus()
    return "Nama: " .. self.name .. ", HP: " .. self.hp
end


-- --- CONTOH PENGGUNAAN ---
local hero = Character:new("Gatotkaca", 200)
local slime = Character:new("Slime Biru", 50)

hero:takeDamage(30) -- Memanggil metode pada instance hero
slime:takeDamage(10) -- Memanggil metode pada instance slime

print(hero:getStatus())
print(slime:getStatus())
```

**Penjelasan Per-Sintaksis**:

- `Character.mt = { __index = Character }`: Ini adalah inti dari sistem ini. Ketika Anda memanggil `hero:getStatus()`, Lua mencari `"getStatus"` di table `hero`. Tidak ketemu. Lua lalu memeriksa metatable `hero` dan melihat `__index` menunjuk ke table `Character`. Lua lalu mencari `"getStatus"` di `Character`, menemukannya, dan memanggilnya.
- `function Character:new(...)`: Ini adalah fungsi factory. Perhatikan `self` di sini akan merujuk ke table `Character` itu sendiri. `self.mt` adalah cara mengakses `Character.mt`.
- `setmetatable(instance, self.mt)`: Memasang metatable ke instance baru, sehingga ia "tahu" di mana harus mencari metode.
- `function Character:takeDamage(amount)`: `self` di sini akan merujuk pada instance yang memanggilnya (entah `hero` atau `slime`), memungkinkan kita memodifikasi data unik instance tersebut (`self.hp`).

---

### **2. Inheritance dan Polymorphism**

💡 **Deskripsi Konsep**
**Inheritance** di Lua sangatlah elegan. Untuk membuat sebuah "sub-kelas" yang mewarisi dari "super-kelas", Anda hanya perlu membuat `__index` dari sub-kelas menunjuk ke super-kelas. Ini menciptakan **rantai prototipe (prototype chain)**.

**Polymorphism** muncul secara alami. Jika sub-kelas mendefinisikan metode dengan nama yang sama seperti super-kelas, metode sub-kelaslah yang akan digunakan (ini disebut _method overriding_). Jika tidak, pencarian akan berlanjut ke rantai prototipe.

**Contoh Kode 29: Membuat Sub-kelas `Mage` yang Mewarisi dari `Character`**

```lua
-- Sub-kelas Mage
local Mage = {}
setmetatable(Mage, { __index = Character }) -- <<< INILAH PEWARISANNYA!
Mage.mt = { __index = Mage }

-- Konstruktor Mage
function Mage:new(name, hp, mana)
    -- Panggil konstruktor dari kelas induk untuk setup awal
    local instance = Character:new(name, hp)
    -- Atur ulang metatable ke metatable Mage
    setmetatable(instance, self.mt)
    -- Tambahkan properti spesifik Mage
    instance.mana = mana
    return instance
end

-- Override metode getStatus
function Mage:getStatus()
    -- Panggil metode induk untuk mendapatkan status dasar
    local base_status = Character.getStatus(self)
    -- Tambahkan info spesifik Mage
    return base_status .. ", Mana: " .. self.mana
end

function Mage:castSpell()
    self.mana = self.mana - 25
    print(self.name .. " merapal mantra! Sisa mana: " .. self.mana)
end

-- --- CONTOH PENGGUNAAN POLIMORFISME ---
local generic_hero = Character:new("Prajurit", 150)
local master_wizard = Mage:new("Merlin", 100, 300)

master_wizard:castSpell()

-- Buat daftar karakter dari tipe yang berbeda
local party = { generic_hero, master_wizard }

print("\n--- Laporan Status Pesta ---")
for i, member in ipairs(party) do
    -- Panggil metode yang sama pada objek yang berbeda
    print(member:getStatus()) -- Ini adalah polimorfisme!
end
```

**Hasil Eksekusi**:

```
Merlin merapal mantra! Sisa mana: 275

--- Laporan Status Pesta ---
Nama: Prajurit, HP: 150
Nama: Merlin, HP: 100, Mana: 275
```

**Penjelasan Per-Sintaksis**:

- `setmetatable(Mage, { __index = Character })`: Ini adalah baris kunci pewarisan. Kita memberitahu `Mage`: "Jika ada metode yang tidak ditemukan di dalammu, cari di `Character`".
- `function Mage:new(...)`: Konstruktor `Mage` pertama-tama memanggil konstruktor `Character` untuk melakukan setup dasar, lalu menambahkan propertinya sendiri.
- `function Mage:getStatus()`: `Mage` mendefinisikan ulang `getStatus`. Ini adalah _method overriding_.
- `Character.getStatus(self)`: Di dalam `Mage:getStatus`, kita secara eksplisit memanggil versi metode dari `Character` menggunakan notasi titik dan memberikan `self` secara manual. Ini adalah cara standar untuk memanggil implementasi dari "super-kelas".
- `for i, member in ipairs(party) do ... end`: Loop ini menunjukkan polimorfisme. Kita memanggil `member:getStatus()` pada setiap objek. Lua secara otomatis akan memanggil implementasi `getStatus` yang benar—versi `Mage` untuk `master_wizard`, dan versi `Character` untuk `generic_hero`.

---

Anda sekarang telah mengimplementasikan pola OOP yang matang sepenuhnya di Lua. Pola berbasis prototipe ini sangat kuat dan fleksibel, dan merupakan fondasi dari banyak framework dan game engine yang menggunakan Lua. Selanjutnya dalam kurikulum, kita akan beralih dari pola OOP kembali ke penggunaan fundamental table sebagai berbagai jenis **"11. STRUKTUR DATA"** seperti Set, Stack, dan Queue.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-9/README.md
[selanjutnya]: ../bagian-11/README.md

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
