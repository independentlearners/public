# **[BAGIAN 3: RAW TABLE OPERATIONS (TAMBAHAN PENTING)][0]**

Ini adalah topik yang sangat penting untuk mencapai penguasaan sejati, karena ini memungkinkan Anda untuk melewati beberapa mekanisme tingkat tinggi Lua, memberikan kontrol yang lebih presisi.

💡 **Deskripsi Konsep**
Bayangkan sebuah table di Lua memiliki dua lapisan:

1.  **Lapisan Perilaku (Behavior Layer):** Di lapisan ini, table bisa memiliki "perilaku khusus" yang didefinisikan oleh sesuatu yang disebut **metatable**. Misalnya, Anda bisa membuat table "tahu" cara mencari nilai di table lain jika nilai tersebut tidak ditemukan di dirinya sendiri. Atau Anda bisa "melarang" penambahan field baru. (Kita akan membahas Metatables secara mendalam di Bagian 5).
2.  **Lapisan Data Mentah (Raw Data Layer):** Ini adalah tempat data (key-value pairs) sebenarnya disimpan.

_Raw operations_ adalah fungsi-fungsi yang bekerja langsung pada **Lapisan Data Mentah**. Mereka sepenuhnya **mengabaikan** "perilaku khusus" apa pun yang didefinisikan di Lapisan Perilaku (metatables). Ini penting untuk performa dan untuk situasi di mana Anda perlu memastikan bahwa Anda berinteraksi dengan data asli table tanpa memicu efek samping dari metatable.

---

### **1. `rawget`, `rawset`, `rawlen`, `rawequal`**

Keempat fungsi ini adalah versi "mentah" dari operasi table yang paling umum.

#### **`rawget(table, key)`**

- **Tujuan**: Mendapatkan nilai dari sebuah table berdasarkan `key`. Ini adalah versi mentah dari `table[key]`. Ia tidak akan memanggil metamethod `__index`.
- **Sintaks**: `rawget(nama_table, kunci)`

**Contoh Kode 8: Perbedaan `rawget` dan Akses Normal**

```lua
-- Table cadangan
local defaults = { health = 100, mana = 50 }

-- Table utama pemain
local player = { name = "Bima" }

-- Metatable yang memberi tahu 'player' untuk mencari di 'defaults' jika key tidak ditemukan
local mt = {
    __index = defaults
}

-- Menetapkan metatable ke table player
setmetatable(player, mt)

-- 1. Akses Normal (menggunakan metatable)
print("Health (normal):", player.health) -- Output: Health (normal): 100

-- 2. Akses Mentah (mengabaikan metatable)
print("Health (rawget):", rawget(player, "health")) -- Output: Health (rawget): nil
```

**Penjelasan Per-Sintaksis:**

- `local mt = { __index = defaults }`: Kita membuat sebuah metatable. `__index` adalah metamethod yang akan kita bahas nanti. Secara singkat, ia memberitahu: "Jika `key` tidak ditemukan di `player`, coba cari di table `defaults`".
- `setmetatable(player, mt)`: Kita "memasang" metatable `mt` ke table `player`. Sekarang `player` punya perilaku khusus.
- `print(player.health)`: Ini adalah akses normal. Lua mencari `health` di `player`. Tidak ketemu. Karena ada metatable dengan `__index`, Lua kemudian mencari `health` di table `defaults`. Ketemu, nilainya `100`.
- `rawget(player, "health")`: Ini adalah akses mentah. `rawget` hanya mencari `health` di dalam table `player` itu sendiri. Karena tidak ada, ia langsung mengembalikan `nil` dan **tidak peduli** dengan metatable `__index` sama sekali.

#### **`rawset(table, key, value)`**

- **Tujuan**: Menetapkan nilai ke sebuah `key` di dalam table. Ini adalah versi mentah dari `table[key] = value`. Ia tidak akan memanggil metamethod `__newindex`.
- **Sintaks**: `rawset(nama_table, kunci, nilai_baru)`

**Contoh Kode 9: Perbedaan `rawset` dan Penugasan Normal**

```lua
-- Metatable yang melarang penambahan key baru
local mt_readonly = {
    __newindex = function(table, key, value)
        print("Error: Table ini read-only. Tidak bisa menambah key '" .. key .. "'.")
    end
}

local config = { host = "localhost" }
setmetatable(config, mt_readonly)

-- 1. Penugasan Normal (dihadang oleh metatable)
config.port = 8080 -- Output: Error: Table ini read-only. Tidak bisa menambah key 'port'.
print("Port (setelah coba set normal):", config.port) -- Output: Port (setelah coba set normal): nil

-- 2. Penugasan Mentah (berhasil, karena mengabaikan metatable)
rawset(config, "port", 8080)
print("Port (setelah rawset):", config.port) -- Output: Port (setelah rawset): 8080
```

**Penjelasan Per-Sintaksis:**

- `__newindex = function(...) ... end`: Metamethod `__newindex` dipicu ketika Anda mencoba menambahkan `key` baru ke table. Di sini, kita membuatnya mencetak pesan error.
- `config.port = 8080`: Penugasan normal ini mencoba menambahkan `key` "port" yang baru. Ini memicu `__newindex`, yang menjalankan fungsi error kita. Nilai `port` tidak pernah benar-benar ditambahkan ke table `config`.
- `rawset(config, "port", 8080)`: `rawset` bekerja langsung di data mentah table `config`. Ia mengabaikan `__newindex` dan berhasil menambahkan `key` "port" dengan `value` `8080`.

#### **`rawlen(table)`** (Lua 5.2+)

- **Tujuan**: Mengambil panjang "sequence" (bagian array) dari sebuah table. Ini adalah versi mentah dari operator panjang `#`. Ia tidak akan memanggil metamethod `__len`.
- **Sintaks**: `rawlen(nama_table)`

#### **`rawequal(a, b)`**

- **Tujuan**: Membandingkan apakah dua table adalah objek yang sama secara fisik (merujuk ke tempat yang sama di memori). Ini adalah versi mentah dari operator `==`. Ia tidak akan memanggil metamethod `__eq`.
- **Sintaks**: `rawequal(table1, table2)`

**Referensi untuk materi ini:**

- O'Reilly: rawget and rawset - [https://www.oreilly.com/library/view/lua-quick-start/9781789343229/abf0a818-b5b1-47ae-aea3-eb315edca6c8.xhtml](https://www.oreilly.com/library/view/lua-quick-start/9781789343229/abf0a818-b5b1-47ae-aea3-eb315edca6c8.xhtml)
- Wikibooks: Lua Programming Tables - [https://en.wikibooks.org/wiki/Lua_Programming/Tables](https://en.wikibooks.org/wiki/Lua_Programming/Tables)

---

### **2. `next()` Function dan Generic `for` Loop**

💡 **Deskripsi Konsep**
Jika `pairs()` adalah cara yang nyaman untuk menjelajahi seluruh table, maka `next()` adalah mesin fundamental yang menggerakkan `pairs()` di balik layar. Memahami `next()` berarti Anda memahami cara kerja iterasi di Lua pada level yang paling dasar.

`next()` adalah fungsi primitif untuk mengambil satu per satu pasangan key-value dari sebuah table.

**Sintaks dan Perilaku `next()`:**

- `next(table, key)`: Fungsi ini menerima dua argumen: table yang akan dijelajahi dan `key` sebelumnya. Ia akan mengembalikan `key` dan `value` **berikutnya** di dalam table.
- **Memulai Iterasi**: Untuk memulai dari awal, Anda memberikan `nil` sebagai `key` kedua: `next(table, nil)`. Ini akan mengembalikan pasangan key-value pertama.
- **Akhir Iterasi**: Ketika tidak ada lagi elemen di dalam table, `next()` akan mengembalikan `nil`.

**Contoh Kode 10: Iterasi Manual Menggunakan `next()` dan `while`**
Ini adalah cara `pairs()` bekerja di balik layar.

```lua
local player = {
    name = "Gatotkaca",
    level = 20,
    class = "Guardian"
}

-- Memulai iterasi dengan mendapatkan key-value pertama
local k, v = next(player, nil)

print("--- Iterasi manual dengan next() ---")
while k do
    -- Mencetak key-value saat ini
    print(tostring(k), tostring(v))
    -- Mendapatkan key-value berikutnya
    k, v = next(player, k)
end
```

**Penjelasan Per-Sintaksis:**

1.  `local k, v = next(player, nil)`: Kita memanggil `next` untuk pertama kalinya. `nil` sebagai argumen kedua memberitahu `next` untuk mengambil pasangan key-value **pertama**. Hasilnya (misalnya, `key` "name" dan `value` "Gatotkaca") disimpan di variabel lokal `k` dan `v`.
2.  `while k do`: Loop `while` akan terus berjalan selama `k` bukan `nil`. Karena `next` akan mengembalikan `nil` ketika iterasi selesai, `k` pada akhirnya akan menjadi `nil` dan loop akan berhenti.
3.  `print(...)`: Mencetak key dan value yang kita dapatkan saat ini.
4.  `k, v = next(player, k)`: Ini adalah langkah krusial. Kita memanggil `next` lagi, tetapi kali ini kita memberikannya `key` terakhir yang kita dapatkan (`k`). `next` menggunakan `key` ini untuk menemukan elemen berikutnya di dalam table. Hasilnya (key dan value berikutnya) kembali disimpan di `k` dan `v`, dan loop berlanjut.

**Hubungan `next()` dengan `for ... in pairs() ...`**
Sekarang Anda tahu cara kerja `next()`, Anda bisa melihat bahwa `for` loop generik adalah "gula sintaksis" (syntactic sugar) atau cara penulisan yang lebih nyaman untuk pola `while` di atas.

Kode ini:

```lua
for k, v in pairs(player) do
    print(k, v)
end
```

Secara konseptual, setara dengan ini:

```lua
for k, v in next, player, nil do
    print(k, v)
end
```

Dan keduanya adalah cara yang lebih ringkas untuk menulis loop `while` dengan `next()` yang kita lihat di Contoh Kode 10. `pairs(t)` pada dasarnya hanya mengembalikan tiga hal: fungsi `next`, table `t` itu sendiri, dan nilai awal `nil`.

**Referensi untuk materi ini:**

- Programming in Lua: Stateless Iterators - [https://www.lua.org/pil/7.3.html](https://www.lua.org/pil/7.3.html)

---

Anda telah menyelesaikan bagian penting lainnya. Memahami operasi "mentah" dan mekanisme iterasi fundamental seperti `next()` memisahkan pengguna biasa dari programmer Lua tingkat lanjut. Anda sekarang tahu cara berinteraksi dengan data table secara langsung dan memahami bagaimana salah satu loop paling umum di Lua, `for-pairs`, sebenarnya bekerja.

Selanjutnya, kita akan menjelajahi **"4. TABLE LIBRARY DAN FUNGSI BUILT-IN"**, yang menyediakan serangkaian alat bantu yang sangat berguna untuk memanipulasi table, terutama yang digunakan sebagai daftar/array.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

<!----------------------------------------------------->

[0]: ../README.md#3-raw-table-operations-tambahan-penting
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
