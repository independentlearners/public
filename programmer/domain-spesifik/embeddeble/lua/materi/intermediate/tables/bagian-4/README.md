# **BAGIAN 5: METATABLES DAN METAMETHODS**

Dibagian ini menunjukan bahwa kita telah sampai pada bagian yang bisa dibilang paling kuat dan unik dalam bahasa Lua. Setelah ini, cara Anda memandang `table` akan berubah total. Selamat datang di dunia metatables. Jika `table` adalah aktor di atas panggung, maka **metatable** adalah sutradara yang memberinya arahan dan perilaku yang tidak terduga. Ini adalah kunci untuk membuka _object-oriented programming_, _operator overloading_, dan berbagai teknik canggih lainnya di Lua.

### **1. Konsep Dasar Metatables**

💡 **Deskripsi Konsep**
Secara default, table adalah wadah data yang "bodoh". Ia tidak tahu cara menjumlahkan dirinya dengan table lain. Contoh:

```lua
local tableA = {1}
local tableB = {2}
-- local result = tableA + tableB -- Ini akan menghasilkan error!
```

Lua akan mengeluh: `attempt to perform arithmetic on a table value`.

**Metatable** adalah sebuah table Lua biasa yang Anda "lampirkan" ke table lain untuk mendefinisikan perilakunya saat menghadapi operasi yang tidak terdefinisi. Anggap saja metatable sebagai **buku panduan perilaku** untuk sebuah table.

Di dalam "buku panduan" (metatable) ini, ada "bab-bab" dengan nama khusus yang disebut **metamethods**. Setiap metamethod adalah sebuah _key_ yang namanya diawali dengan dua garis bawah (contoh: `__add`, `__index`, `__tostring`). _Value_ dari _key_ ini adalah sebuah **fungsi** yang akan dijalankan Lua ketika operasi terkait terjadi.

**Alur Kerja Metatable:**

1.  Lua mencoba melakukan operasi pada sebuah table (misalnya, `t1 + t2`).
2.  Lua memeriksa apakah operasi tersebut valid untuk table (untuk `+`, tidak).
3.  Lua memeriksa apakah table pertama (`t1`) memiliki metatable.
4.  Jika ya, Lua mencari metamethod yang sesuai (untuk `+`, metamethod-nya adalah `__add`) di dalam metatable tersebut.
5.  Jika metamethod `__add` ditemukan (dan berupa fungsi), Lua akan memanggil fungsi tersebut untuk melakukan operasi.
6.  Jika tidak ada metatable atau metamethod yang sesuai, Lua akan mengeluarkan error seperti di atas.

**Terminologi Penting:**

- **Metatable**: Sebuah table Lua biasa yang berisi definisi perilaku (metamethods) untuk table lain.
- **Metamethod**: Sebuah key khusus di dalam metatable (e.g., `__add`) yang nilainya adalah fungsi yang mendefinisikan sebuah perilaku.

---

### **2. `setmetatable` dan `getmetatable`**

Ini adalah dua fungsi utama yang Anda gunakan untuk mengelola hubungan antara table dan metatable-nya.

#### **`setmetatable(table, metatable)`**

- **Tujuan**: Fungsi ini digunakan untuk "memasang" atau "melampirkan" sebuah metatable ke sebuah table.
- **Sintaks**: `setmetatable(table_objek, table_sebagai_meta)`

Fungsi ini mengubah table pertama dan mengembalikannya, sehingga Anda bisa melakukan _chaining_: `local myTable = setmetatable({}, mt)`.

**Contoh Kode 17: Memasang Metatable**

```lua
-- 1. Table objek kita, sebuah vector sederhana
local myVector = { x = 10, y = 20 }

-- 2. Metatable kita, untuk saat ini masih kosong
local myMetatable = {}

-- 3. Memasang myMetatable ke myVector
setmetatable(myVector, myMetatable)

print("Metatable berhasil dipasang!")
```

**Penjelasan Per-Sintaksis:**

- `local myVector = { x = 10, y = 20 }`: Ini adalah table biasa yang akan kita beri perilaku khusus.
- `local myMetatable = {}`: Ini juga table biasa, yang akan kita gunakan sebagai "buku panduan".
- `setmetatable(myVector, myMetatable)`: Inilah intinya. Kita memberitahu Lua, "Hei, jika `myVector` menghadapi situasi yang tidak ia mengerti, lihatlah panduan di `myMetatable`."

---

#### **`getmetatable(table)`**

- **Tujuan**: Fungsi ini digunakan untuk memeriksa atau mendapatkan metatable yang saat ini terpasang pada sebuah table.
- **Sintaks**: `getmetatable(nama_table)`
- **Nilai Kembali**: Mengembalikan table metatable jika ada, atau `nil` jika tidak ada.

**Contoh Kode 18: Memeriksa Metatable**

```lua
-- Melanjutkan kode dari contoh sebelumnya...
local myVector = { x = 10, y = 20 }
local myMetatable = {}
setmetatable(myVector, myMetatable)

-- Mendapatkan metatable dari myVector
local retrieved_mt = getmetatable(myVector)

-- Memeriksa apakah metatable yang didapat sama dengan yang kita pasang
if retrieved_mt == myMetatable then
    print("Metatable yang didapat sama dengan yang asli.") -- Ini akan tercetak
end

-- Table lain yang tidak punya metatable
local anotherTable = {}
print("Metatable dari anotherTable:", getmetatable(anotherTable)) -- Output: Metatable dari anotherTable: nil
```

**Penjelasan Per-Sintaksis:**

- `local retrieved_mt = getmetatable(myVector)`: Kita meminta Lua untuk memberikan metatable yang terpasang pada `myVector` dan menyimpannya di variabel `retrieved_mt`.
- `if retrieved_mt == myMetatable then`: Kita membandingkan apakah table yang kita dapatkan (`retrieved_mt`) adalah objek yang sama persis di memori dengan `myMetatable` yang kita buat. Karena memang benar, kondisi ini `true`.
- `getmetatable(anotherTable)`: Karena `anotherTable` tidak pernah dipasangi metatable, fungsi ini mengembalikan `nil`.

#### **Contoh Lengkap Sederhana: Metamethod `__tostring`**

Mari kita lihat siklus lengkap dengan satu metamethod sederhana, `__tostring`, yang menentukan bagaimana sebuah table harus direpresentasikan sebagai string (misalnya saat di-`print`).

**Contoh Kode 19: Menggunakan `__tostring`**

```lua
local Vector = {}
Vector.mt = {
    -- Metamethod __tostring
    __tostring = function(vec)
        return "Vector(x=" .. vec.x .. ", y=" .. vec.y .. ")"
    end
}

function Vector.new(x, y)
    local new_vec = { x = x, y = y }
    setmetatable(new_vec, Vector.mt)
    return new_vec
end

-- Membuat instance vector baru
local v1 = Vector.new(10, 25)

-- Mencetak vector
print("Vector v1 adalah:", v1)
```

**Hasil Eksekusi**:

```
Vector v1 adalah: Vector(x=10, y=25)
```

**Tanpa** metatable, outputnya akan menjadi sesuatu seperti: `Vector v1 adalah: table: 0x7fae8c405d50`

**Penjelasan Per-Sintaksis**:

- `Vector.mt = { ... }`: Kita membuat sebuah metatable dan menyimpannya di dalam table `Vector` itu sendiri untuk kerapian.
- `__tostring = function(vec) ... end`: Kita mendefinisikan metamethod `__tostring`. Fungsinya menerima table itu sendiri sebagai argumen (`vec`) dan harus mengembalikan sebuah string.
- `function Vector.new(x, y) ... end`: Ini adalah "constructor" atau "factory function" kita. Ia membuat table vector baru, memasang metatable padanya, dan mengembalikannya.
- `print("Vector v1 adalah:", v1)`: Saat `print` mencoba mengubah `v1` menjadi string, Lua melihat ada metatable dengan metamethod `__tostring`. Alih-alih mencetak alamat memori, Lua memanggil fungsi yang kita sediakan untuk mendapatkan representasi string yang bagus.

---

Kini kita telah memahami konsep fundamental di balik metatables: mereka adalah table biasa yang berfungsi sebagai "buku panduan" yang dilampirkan ke table lain menggunakan `setmetatable` untuk mendefinisikan perilaku kustom melalui metamethods. Sekarang kita telah siap untuk menjelajahi berbagai "bab" dalam buku panduan tersebut. Di bagian selanjutnya, kita akan membahas **"6. METAMETHODS LENGKAP"**, melihat semua metamethods utama untuk aritmatika, perbandingan, dan pengindeksan. Mari kita mulai.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

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
