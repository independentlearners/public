Tentu, mari kita lanjutkan. Bagian ini akan menjadi penyelaman mendalam ke dalam salah satu fitur paling fundamental dan kuat di Lua. Memahaminya dengan baik akan membuka tingkat pemrograman yang baru.

---

## **Bagian 4: Closures dan Upvalues**

Kita telah menyentuh konsep ini secara singkat, tetapi di sini kita akan membedahnya secara detail. Closures adalah mekanisme di balik banyak pola canggih di Lua, mulai dari privasi data hingga pemrograman fungsional.

**Daftar Isi Bagian 4:**

- [Memahami Closures](#41-memahami-closures)
- [Penerapan Praktis Closures](#42-penerapan-praktis-closures)
- [Pola Closure Tingkat Lanjut](#43-pola-closure-tingkat-lanjut)

---

### 4.1 Memahami Closures

#### **Apa itu closure?**

Secara formal, _closure_ adalah sebuah function yang "mengingat" lingkungan leksikal tempat ia diciptakan. Ini berarti ia dapat mengakses variabel dari scope luarnya, bahkan setelah scope luar tersebut selesai dieksekusi. Di Lua, function adalah _closure_. Mereka tidak hanya berisi kode, tetapi juga keterikatan pada variabel di sekitarnya.

#### **Lexical Scoping**

Untuk memahami closures, kita harus memahami _lexical scoping_, yang merupakan aturan scope yang digunakan oleh Lua.

- Aturan ini menyatakan bahwa sebuah function yang bersarang di dalam function lain dapat mengakses variabel dari function yang menampungnya.
- Lingkup (scope) dari sebuah variabel lokal dimulai dari pernyataan setelah deklarasinya dan berlangsung hingga akhir blok tempat ia dideklarasikan.
- Ketika Lua mengkompilasi sebuah function, ia menyimpan informasi tentang variabel-variabel yang diaksesnya yang berasal dari scope luar.

<!-- end list -->

```lua
function scopeLuar()
    local x = 10 -- Variabel lokal di scopeLuar
    local y = 20

    local function scopeDalam()
        -- 'scopeDalam' dapat mengakses 'x' karena aturan lexical scoping.
        print("Di dalam scopeDalam, x adalah " .. x)
    end

    scopeDalam()
    print("Di dalam scopeLuar, y adalah " .. y)
end

scopeLuar()
-- Output:
-- Di dalam scopeDalam, x adalah 10
-- Di dalam scopeLuar, y adalah 20
```

#### **Upvalues dalam Detail**

- **Definisi:** Ketika sebuah function lokal mereferensikan variabel lokal dari function yang menaunginya, variabel ini disebut _upvalue_.

- **Mekanisme:** Lua mendeteksi bahwa variabel lokal (`x` dalam contoh di bawah) masih dibutuhkan oleh function dalam (`increment`) bahkan setelah function luar (`buatCounter`) selesai dieksekusi. Lua kemudian "menutup" (closes over) variabel tersebut, menjadikannya sebuah upvalue. Upvalue ini akan tetap "hidup" selama function dalam (closure) masih dapat diakses.

- **Instansiasi Unik:** Setiap closure memiliki instans upvalue-nya sendiri yang independen. Jika Anda memanggil function "pabrik" dua kali, Anda akan mendapatkan dua closure yang berbeda, masing-masing dengan set upvalue-nya sendiri yang terpisah.

- **Contoh Kode:**

  ```lua
  function buatCounter()
      local count = 0 -- Variabel lokal ini akan menjadi upvalue

      -- 'increment' adalah closure yang menutup 'count'
      return function ()
          count = count + 1
          return count
      end
  end

  local counterA = buatCounter() -- Membuat closure pertama. Ia punya 'count'-nya sendiri.
  local counterB = buatCounter() -- Membuat closure kedua. Ia punya 'count'-nya sendiri yang berbeda.

  print("A:", counterA()) -- Output: A: 1
  print("A:", counterA()) -- Output: A: 2
  print("B:", counterB()) -- Output: B: 1 (Counter B independen dari A)
  print("A:", counterA()) -- Output: A: 3 (Counter A melanjutkan state-nya)
  ```

  Dalam contoh ini, `counterA` dan `counterB` berbagi kode function yang sama, tetapi masing-masing memiliki upvalue `count` yang independen.

#### **Closure vs. Global Variables**

Perbedaan utamanya adalah **kontrol akses** dan **state**.

- **Global Variable:** Satu entitas tunggal yang dapat diakses dan dimodifikasi dari mana saja dalam program. Ini rentan terhadap modifikasi yang tidak disengaja.
- **Upvalue dalam Closure:** Bertindak seperti variabel "privat". Ia hanya dapat diakses oleh closure yang menutupnya. Ini menyediakan enkapsulasi yang kuat.

<!-- end list -->

```lua
-- Menggunakan Global Variable (Buruk)
g_counter = 0
function incrementGlobal()
    g_counter = g_counter + 1
    return g_counter
end
-- Siapapun bisa mengubah g_counter secara langsung:
g_counter = 100
print(incrementGlobal()) -- Output: 101

-- Menggunakan Closure (Baik)
local counter = buatCounter() -- 'count' di dalamnya terlindungi
print(counter()) -- Output: 1
print(counter()) -- Output: 2
-- Tidak ada cara untuk mengakses 'count' dari luar secara langsung.
```

---

### 4.2 Penerapan Praktis Closures

Kemampuan closures untuk mempertahankan state dan menyediakan privasi data membuatnya sangat berguna untuk berbagai pola pemrograman.

#### **Factory Functions**

Pola ini menggunakan function untuk membuat dan mengkonfigurasi function lain. `buatCounter` dan `buatPengali` dari bagian sebelumnya adalah contoh sempurna dari _factory functions_. Mereka "memproduksi" function baru yang disesuaikan dengan state awal atau parameter tertentu.

#### **Simulasi Private Variables**

Closures adalah cara idiomatis di Lua untuk mensimulasikan variabel privat seperti dalam Object-Oriented Programming.

- **Contoh: Akun Bank**

  ```lua
  function buatAkunBank(saldoAwal)
      local saldo = saldoAwal or 0 -- 'saldo' adalah variabel privat (upvalue)

      -- Table yang berisi function-function (method) publik
      local akun = {}

      function akun.deposit(jumlah)
          saldo = saldo + jumlah
      end

      function akun.tarik(jumlah)
          if jumlah <= saldo then
              saldo = saldo - jumlah
              return true
          else
              return false, "Saldo tidak mencukupi"
          end
      end

      function akun.getSaldo()
          return saldo
      end

      return akun -- Mengembalikan 'objek' dengan method publik
  end

  local akunSaya = buatAkunBank(100)
  print("Saldo awal:", akunSaya.getSaldo()) -- Output: 100

  akunSaya.deposit(50)
  print("Saldo setelah deposit:", akunSaya.getSaldo()) -- Output: 150

  local sukses, pesan = akunSaya.tarik(200)
  if not sukses then
      print("Gagal tarik: " .. pesan) -- Output: Gagal tarik: Saldo tidak mencukupi
  end

  -- Tidak ada cara untuk mengubah 'saldo' secara langsung
  -- akunSaya.saldo = 1000000 -- Ini hanya akan membuat field baru di table 'akunSaya',
                            -- tidak akan mengubah upvalue 'saldo' yang asli.
  print("Saldo akhir:", akunSaya.getSaldo()) -- Output: 150 (saldo asli tetap aman)
  ```

#### **Stateful Functions**

Karena closures mempertahankan state melalui upvalues, mereka ideal untuk membuat function yang perilakunya bergantung pada panggilan sebelumnya. Iterator, generator, dan state machine adalah contoh utama dari _stateful functions_. `counter` adalah contoh paling sederhana dari function yang stateful.

#### **Event Handlers dengan Closures**

Dalam pengembangan GUI, game, atau aplikasi berbasis event, closures sangat berguna untuk menjadi _event handler_ (penangan event).

- **Konsep:** Ketika sebuah event terjadi (misalnya, tombol diklik), sebuah function _callback_ dieksekusi. Jika callback ini adalah sebuah closure, ia dapat dengan mudah berinteraksi dengan objek atau data yang relevan dengan event tersebut, tanpa perlu variabel global.

- **Contoh Hipotetis:**

  ```lua
  function createButton(label, action)
      local button = { label = label }
      -- 'action' di sini bisa menjadi closure
      function button:onClick()
          print("Tombol '" .. self.label .. "' diklik!")
          action() -- Menjalankan aksi yang terikat
      end
      return button
  end

  local skor = 0 -- Variabel yang ingin kita ubah

  -- Membuat tombol di mana aksinya adalah sebuah closure
  -- yang "mengingat" 'skor'.
  local tombolTambahSkor = createButton("Tambah 10 Poin", function()
                                                              skor = skor + 10
                                                              print("Skor sekarang: " .. skor)
                                                          end)

  -- Simulasi klik event
  tombolTambahSkor:onClick() -- Output: Tombol 'Tambah 10 Poin' diklik!
                             -- Output: Skor sekarang: 10
  tombolTambahSkor:onClick() -- Output: Tombol 'Tambah 10 Poin' diklik!
                             -- Output: Skor sekarang: 20
  ```

---

### 4.3 Pola Closure Tingkat Lanjut

#### **Closure-based Modules**

Pola modul yang umum di Lua adalah sebuah file yang mendefinisikan semua function-nya sebagai lokal, lalu mengembalikan sebuah table yang berisi function-function yang ingin diekspos secara publik. Variabel lokal di level atas file (di luar function manapun) dapat bertindak sebagai state privat untuk seluruh modul, karena mereka menjadi upvalues untuk function-function publik tersebut.

#### **Decorator Pattern**

Decorator adalah sebuah function yang mengambil function lain dan "membungkusnya" dengan fungsionalitas tambahan, lalu mengembalikan function yang sudah dibungkus tersebut. Ini adalah aplikasi HOF dan closures.

- **Contoh: Decorator Logging**

  ```lua
  function denganLogging(fn)
      return function(...) -- Mengembalikan closure baru
          print("Memanggil function...")
          local hasil = {fn(...)} -- Memanggil function asli
          print("...Function selesai.")
          return unpack(hasil) -- Mengembalikan hasil asli
      end
  end

  local function tambah(a, b)
      return a + b
  end

  -- "Mendekorasi" function tambah
  local tambahYangBawel = denganLogging(tambah)

  local jumlah = tambahYangBawel(5, 3)
  print("Hasilnya:", jumlah)
  -- Output:
  -- Memanggil function...
  -- ...Function selesai.
  -- Hasilnya: 8
  ```

#### **Currying dan Partial Application**

- **Currying:** Adalah teknik mengubah sebuah function yang menerima banyak argumen menjadi serangkaian function yang masing-masing menerima satu argumen.
- **Partial Application:** Lebih umum di Lua, ini adalah proses membuat function baru dengan "memperbaiki" (fixing) satu atau lebih argumen dari function yang ada. Factory function `buatPengali` yang kita lihat sebelumnya adalah contoh sempurna dari _partial application_.

#### **Memory Management dengan Closures**

- **Implikasi Memori:** Closures menjaga upvalue mereka tetap "hidup". Ini berarti selama sebuah closure ada di memori, variabel-variabel yang menjadi upvalue-nya tidak akan di-_garbage collect_ (dibersihkan oleh pengumpul sampah Lua), bahkan jika tidak ada referensi lain ke variabel tersebut.
- **Potensi Kebocoran Memori (Memory Leaks):** Anda harus berhati-hati. Jika Anda menyimpan sebuah closure (yang merujuk pada upvalue besar, seperti table data yang besar) dalam sebuah variabel global atau tempat lain yang berumur panjang, data tersebut tidak akan pernah dibersihkan. Pastikan untuk melepaskan referensi ke closure (misalnya dengan mengaturnya ke `nil`) jika sudah tidak digunakan lagi agar garbage collector bisa bekerja.

---

**Sumber Referensi untuk Bagian 4:**

1.  Programming in Lua (4th Edition) - [6.1 Closures](https://www.lua.org/pil/6.1.html)
2.  Lua 5.4 Reference Manual - [3.5 Lexical Scoping](https://www.lua.org/manual/5.4/manual.html#3.5)
3.  Lua-Users Wiki - [Closures Tutorial](http://lua-users.org/wiki/ClosuresTutorial)
4.  Programming in Lua (4th Edition) - [6. Higher-Order Functions](https://www.lua.org/pil/6.html) (Relevan karena HOF dan closure sangat terkait)
5.  Lua-Users Wiki - [Currying](http://lua-users.org/wiki/CurriedLua)
6.  Lua-Users Wiki - [Lua Tutorial](http://lua-users.org/wiki/LuaTutorial) (Sebagai sumber pola-pola umum)

---

Kita telah menyelesaikan penyelaman mendalam ke dalam closures. Ini adalah konsep yang padat, tetapi sangat fundamental untuk penguasaan Lua. Berikutnya, kita akan melihat bagaimana function berinteraksi dengan sistem meta-programming Lua di **Bagian 5: Metatables dan Functions**.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

<!----------------------------------------------------->

[0]: ../../README.md
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
