# **[9. OOP di Lua - _Deep Dive_][1]**

Meskipun Lua tidak memiliki konsep "kelas" bawaan seperti bahasa-bahasa seperti Java atau C++, sistem metatable-nya yang kuat memungkinkan implementasi pemrograman berorientasi objek (OOP) yang elegan dan fleksibel. Model OOP di Lua adalah **berbasis prototipe (_prototype-based_)**.

### **9.1 _Prototype-based_ vs _Class-based Inheritance_**

- **_Class-based Inheritance_ (Pewarisan Berbasis Kelas)**:

  - **Konsep**: Model ini, yang digunakan oleh Java, C#, C++, dll., memiliki perbedaan yang kaku antara "kelas" dan "objek (instance)". Kelas adalah cetak biru; objek adalah realisasi dari cetak biru tersebut. Pewarisan terjadi antar kelas (sebuah kelas anak mewarisi dari kelas induk). Anda tidak bisa membuat objek tanpa mendefinisikan kelasnya terlebih dahulu.
  - **Struktur**: Hubungan "is-a" didefinisikan secara kaku pada level kelas.

- **_Prototype-based Inheritance_ (Pewarisan Berbasis Prototipe)**:

  - **Konsep**: Model ini, yang digunakan oleh Lua, JavaScript, dan Self, tidak memiliki konsep kelas yang kaku. Hanya ada **objek**. Setiap objek dapat berfungsi sebagai **prototipe** (model atau contoh) untuk objek lain. Pewarisan terjadi antar objek. Sebuah objek baru dapat mewarisi properti dan perilaku langsung dari objek lain yang sudah ada.
  - **Struktur**: Hubungan "behaves-like" didefinisikan antar objek.

- **Implementasi di Lua**:
  Di Lua, pewarisan prototipe dicapai dengan menggunakan metatable, khususnya dengan _metamethod_ `__index`.

  - **Prototipe**: Adalah sebuah tabel biasa yang berisi metode-metode bersama.
  - **Objek**: Adalah tabel lain yang berisi data unik untuk instance tersebut.
  - **Hubungan**: Metatable dari objek diatur sedemikian rupa sehingga _field_ `__index`-nya menunjuk ke tabel prototipe.

- **Contoh**:

  ```lua
  -- 'Shape' adalah prototipe kita.
  local Shape = { area = 0 }

  function Shape:printArea()
      print("Area dari bentuk ini adalah: " .. self.area)
  end

  -- 'Square' adalah prototipe lain yang mewarisi dari 'Shape'.
  local Square = {}
  setmetatable(Square, { __index = Shape }) -- Square sekarang mewarisi dari Shape

  function Square:new(sisi)
      local obj = { sisi = sisi }
      setmetatable(obj, self)
      self.__index = self
      return obj
  end

  function Square:calculateArea()
      self.area = self.sisi * self.sisi
  end

  -- Membuat instance
  local s1 = Square:new(10)
  s1:calculateArea()

  -- Memanggil metode yang didefinisikan di Square
  print("Sisi dari s1:", s1.sisi)

  -- Memanggil metode yang diwarisi dari Shape
  s1:printArea() -- Output: Area dari bentuk ini adalah: 100
  ```

  Dalam contoh ini, `s1` adalah objek, prototipenya adalah `Square`, dan prototipe dari `Square` adalah `Shape`. Ini membentuk sebuah "rantai prototipe".

- **Sumber**:
  - Buku "Programming in Lua" (PIL) bab 16 secara khusus membahas OOP.
  - Komunitas wiki memiliki banyak tutorial tentang berbagai pola OOP di Lua.

---

### **9.2 Pola-pola Pewarisan (_Inheritance Patterns_)**

Ada beberapa cara untuk menstrukturkan OOP di Lua. Pola "kelas" tunggal yang telah kita lihat adalah yang paling umum.

- **_Single Inheritance_ (Pewarisan Tunggal)**:
  Ini adalah pola yang paling umum, di mana sebuah prototipe mewarisi dari satu prototipe lain. Implementasinya persis seperti contoh `Square` dan `Shape` di atas, menggunakan `__index`.

- **_Multiple Inheritance_ (Pewarisan Ganda)**:
  Terkadang Anda ingin sebuah objek mewarisi perilaku dari dua atau lebih prototipe yang tidak berhubungan. Ini lebih kompleks tetapi dapat dicapai dengan membuat `__index` menjadi sebuah **fungsi**.

- **Contoh Pewarisan Ganda**:

  ```lua
  -- Buat fungsi pencarian untuk pewarisan ganda
  function search_in_parents(k, parents)
      for i = 1, #parents do
          local val = parents[i][k]
          if val then return val end
      end
      return nil
  end

  -- Prototipe 1: Serializable
  local Serializable = {}
  function Serializable:serialize() print("serializing...") end

  -- Prototipe 2: Loggable
  local Loggable = {}
  function Loggable:log(msg) print("LOG: " .. msg) end

  -- Kelas 'Player' yang mewarisi dari keduanya
  local Player = {}
  setmetatable(Player, {
      __index = function(t, k)
          -- Cari di tabel Player itu sendiri dulu, lalu di parents
          local val = rawget(t, k)
          if val then return val end
          return search_in_parents(k, {Serializable, Loggable})
      end
  })

  local p1 = {}
  setmetatable(p1, Player)
  p1:serialize() -- Output: serializing...
  p1:log("Player created") -- Output: LOG: Player created
  ```

  Di sini, `__index` menjadi fungsi dispatcher yang mencari metode di beberapa tabel induk.

- **_Mixins_**:
  Pola _mixin_ adalah alternatif lain. Daripada membuat rantai pewarisan, Anda menyalin _field_ dari beberapa tabel "sumber" ke dalam tabel "kelas" Anda. Ini lebih sederhana tetapi tidak dinamis; jika _mixin_ sumber berubah setelah penyalinan, kelas Anda tidak akan terpengaruh.

---

### **9.3 Enkapsulasi dan Privasi**

- **Enkapsulasi**: Adalah prinsip menggabungkan data (properti) dan metode yang beroperasi pada data tersebut ke dalam satu unit (objek). Lua secara alami mendukung ini karena tabel dapat berisi data dan fungsi.
- **Privasi**: Lua tidak memiliki kata kunci `private` atau `public` bawaan. Konsep privasi harus diemulasikan.

  - **Konvensi Penamaan**: Cara paling sederhana adalah dengan menggunakan konvensi, misalnya, mengawali _field_ "privat" dengan garis bawah (`_`). Ini tidak memberikan perlindungan nyata tetapi memberi sinyal kepada pemrogram lain untuk tidak mengaksesnya secara langsung.
    ```lua
    function Account:new(balance)
        local obj = { _balance = balance }
        setmetatable(obj, self)
        self.__index = self
        return obj
    end
    ```
  - **Enkapsulasi Sejati dengan _Closures_**: Untuk privasi yang sesungguhnya, Anda dapat menggunakan kekuatan _closures_. Metode-metode objek didefinisikan di dalam fungsi konstruktor, di mana mereka dapat mengakses variabel `local` dari konstruktor tersebut. Variabel-variabel ini benar-benar privat dan tidak dapat diakses dari luar.

- **Contoh Privasi dengan _Closure_**:

  ```lua
  function createAccount(initial_balance)
      -- 'balance' adalah variabel lokal, benar-benar privat.
      local balance = initial_balance

      -- 'obj' hanya berisi metode publik
      local obj = {}

      function obj:deposit(amount)
          balance = balance + amount
      end

      function obj:withdraw(amount)
          if amount > balance then error("Insufficient funds") end
          balance = balance - amount
      end

      function obj:getBalance()
          return balance
      end

      return obj
  end

  local acc1 = createAccount(100)
  acc1:deposit(50)
  print(acc1:getBalance()) -- Output: 150
  -- Tidak ada cara untuk mengakses 'balance' secara langsung.
  -- print(acc1.balance) -- Output: nil
  ```

  Kelemahan dari pola ini adalah setiap objek yang dibuat akan memiliki salinan dari semua fungsinya sendiri, yang menggunakan lebih banyak memori daripada model prototipe di mana metode dibagikan.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-8/README.md
[selanjutnya]: ../bagian-10/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../README.md#101-object-oriented-programming
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
