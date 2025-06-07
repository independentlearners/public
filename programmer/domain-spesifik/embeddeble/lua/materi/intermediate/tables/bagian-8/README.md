# **[BAGIAN 8: WEAK TABLES (TOPIK KRUSIAL YANG DIPERLUAS)][0]**

Kita akan masuk ke topik yang merupakan kelanjutan logis dari Garbage Collection dan sangat penting untuk pola desain tingkat lanjut: **Weak Tables**. Jika table biasa memegang isinya dengan "genggaman kuat" yang mencegahnya dibersihkan oleh GC, maka weak table memegangnya dengan "genggaman lemah", memungkinkan GC untuk mengambil isinya jika tidak ada lagi yang membutuhkannya.

### **1. Konsep Weak References**

💡 **Deskripsi Konsep**
Secara default, ketika Anda menempatkan sebuah objek (seperti table atau fungsi) ke dalam table lain, table penampung tersebut menciptakan **referensi yang kuat** (*strong reference*) ke objek tersebut. Referensi yang kuat ini memberitahu Garbage Collector (GC): "Hei, objek ini sedang digunakan, jangan dibuang!". Selama ada setidaknya satu referensi kuat yang menunjuk ke sebuah objek, objek tersebut tidak akan pernah dianggap "sampah".

**Weak Reference** adalah jenis referensi spesial yang **diabaikan** oleh Garbage Collector. Jika satu-satunya referensi yang menunjuk ke sebuah objek adalah referensi-referensi lemah, maka GC akan menganggap objek tersebut sebagai sampah dan bebas untuk membersihkannya.

**Weak Table** adalah sebuah table yang referensinya terhadap kunci (*keys*), nilai (*values*), atau keduanya bersifat lemah. Ini sangat berguna untuk membuat **cache** atau mekanisme asosiasi data tanpa menyebabkan kebocoran memori (*memory leaks*). Anda dapat mengasosiasikan data dengan sebuah objek, dan ketika objek utama itu sendiri hilang, data asosiasinya akan ikut hilang secara otomatis.

---

### **2. `__mode` Metamethod (k, v, kv)**

💡 **Deskripsi Konsep**
Anda tidak membuat weak table dengan fungsi khusus. Sebaliknya, Anda membuat table biasa dan membuatnya "lemah" dengan cara mengatur metatable-nya. Metamethod yang mengontrol kelemahan ini adalah `__mode`.

Nilai dari `__mode` adalah sebuah string yang dapat berisi:
* `"k"`: Membuat **kunci** (*keys*) dari table menjadi lemah. Jika sebuah objek yang digunakan sebagai kunci tidak lagi memiliki referensi kuat dari tempat lain, maka seluruh entri (pasangan kunci-nilai) akan dihapus dari table.
* `"v"`: Membuat **nilai** (*values*) dari table menjadi lemah. Jika sebuah objek yang digunakan sebagai nilai tidak lagi memiliki referensi kuat, entrinya akan dihapus.
* `"kv"`: Membuat kunci **dan** nilai menjadi lemah. Entri akan dihapus jika kunci *atau* nilainya menjadi sampah.

**Contoh Kode 25: Menggunakan Weak Table (`__mode = "k"`) sebagai Cache Metadata**
Bayangkan kita ingin menyimpan "metadata" untuk berbagai objek, tetapi kita tidak ingin cache metadata ini mencegah objek-objek tersebut dibersihkan dari memori.

```lua
-- Membuat cache metadata dengan kunci yang lemah
local metadata_cache = {}
local mt = { __mode = "k" } -- 'k' untuk weak keys
setmetatable(metadata_cache, mt)

-- Objek utama kita
local player_obj = { name = "Srikandi", id = 123 }

-- Mengasosiasikan metadata dengan objek player
metadata_cache[player_obj] = { last_login = "2025-06-07" }

-- Tunjukkan bahwa data ada
print("Metadata untuk player:", metadata_cache[player_obj].last_login)

-- Sekarang, mari kita 'hapus' objek player satu-satunya
-- dengan menghilangkan satu-satunya referensi kuat ke objek tersebut.
player_obj = nil

-- Paksa GC untuk berjalan (untuk demonstrasi)
collectgarbage("collect")

-- Coba akses lagi, seharusnya sudah tidak ada
print("\n--- Setelah GC berjalan ---")
-- 'pairs' akan menunjukkan bahwa table sekarang kosong
for k, v in pairs(metadata_cache) do
    print("Entri ditemukan:", k, v) -- Baris ini tidak akan pernah tercetak
end
print("Cache metadata sekarang kosong.")
```

**Penjelasan Per-Sintaksis**:
* `local mt = { __mode = "k" }`: Kita membuat metatable yang hanya berisi satu field, `__mode`, yang disetel ke `"k"`.
* `setmetatable(metadata_cache, mt)`: Kita menerapkan metatable ini ke `metadata_cache`, mengubahnya menjadi table dengan kunci yang lemah.
* `local player_obj = ...`: Ini adalah satu-satunya referensi kuat ke objek pemain kita.
* `metadata_cache[player_obj] = ...`: Di sini, `metadata_cache` memegang referensi *lemah* ke `player_obj`.
* `player_obj = nil`: Kita menghapus satu-satunya referensi kuat ke objek pemain. Sekarang, satu-satunya referensi yang tersisa adalah referensi lemah dari `metadata_cache`.
* `collectgarbage("collect")`: GC berjalan. Ia melihat objek pemain tidak memiliki referensi kuat, jadi ia menganggapnya sampah.
* Karena kunci di `metadata_cache` bersifat lemah, ketika GC membersihkan objek pemain, ia juga secara otomatis menghapus entri yang terkait dari `metadata_cache`.

---

### **3. Ephemeron Tables**

💡 **Deskripsi Konsep**
Sejak Lua 5.2, table dengan `__mode = "k"` (kunci lemah) diimplementasikan sebagai **Ephemeron Tables**. Ini adalah peningkatan penting yang menyelesaikan masalah subtle.

Secara sederhana, sebuah ephemeron table memiliki aturan tambahan: sebuah kunci hanya akan dianggap "sampah" jika **nilainya** tidak lagi merujuk kembali ke kunci tersebut. Dengan kata lain, referensi dari nilai ke kunci di dalam table yang sama tidak akan mencegah kunci tersebut dikumpulkan.

Untuk Anda sebagai pengguna, ini berarti perilaku `__mode = "k"` menjadi lebih intuitif dan bekerja seperti yang Anda harapkan, terutama dalam kasus-kasus rumit. Anda tidak perlu melakukan apa pun secara khusus; jika Anda menggunakan `__mode = "k"` di Lua modern, Anda sudah menggunakan perilaku ephemeron yang lebih baik.

---

### **4. Weak Tables dengan C API**

💡 **Deskripsi Konsep**
Ini adalah topik tingkat lanjut yang relevan ketika Anda menulis modul dalam bahasa C untuk digunakan di dalam Lua. Anda mungkin perlu membuat dan mengelola table Lua dari kode C Anda.

**Mengapa ini dibutuhkan?**
Bayangkan Anda menulis library C yang berinteraksi dengan game engine. Library C Anda mungkin perlu menyimpan referensi ke fungsi-fungsi callback Lua. Jika Anda menyimpannya di table Lua biasa dari sisi C, Anda akan menciptakan referensi kuat yang dapat menyebabkan kebocoran memori. Fungsi callback tersebut tidak akan pernah di-GC bahkan jika tidak ada lagi yang menggunakannya di sisi Lua.

Solusinya adalah, dari kode C, Anda membuat sebuah **weak table** di Lua untuk menyimpan referensi ke fungsi-fungsi tersebut. Dengan begitu, ketika fungsi callback tidak lagi digunakan di skrip Lua, GC bisa membersihkannya, dan weak table di sisi C akan secara otomatis melepaskannya.

Prosesnya secara konseptual (tanpa kode C) adalah:
1.  Dari C, gunakan fungsi-fungsi di Lua C API untuk membuat table baru di stack Lua.
2.  Buat table lain yang akan menjadi metatable.
3.  Dorong string `"__mode"` dan nilainya (misal, `"v"` untuk nilai lemah) ke stack dan atur sebagai field di metatable.
4.  Gunakan `lua_setmetatable` untuk memasang metatable tersebut ke table utama Anda.

Ini memastikan bahwa modul C Anda dapat berinteraksi dengan aman dengan sistem GC Lua tanpa menyebabkan kebocoran memori.

---

Anda telah menguasai salah satu konsep paling canggih di Lua. Weak tables sangat penting untuk arsitektur perangkat lunak yang kuat dan efisien. Selanjutnya akan membawa kita ke **"9. ADVANCED METATABLES"**, di mana kita akan melihat bagaimana konsep-konsep yang telah kita pelajari (terutama `__index` dan `__newindex`) dapat digabungkan untuk menciptakan pola-pola yang lebih kompleks seperti *operator overloading* dan *custom indexing*.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-7/README.md
[selanjutnya]: ../bagian-9/README.md

<!----------------------------------------------------->

[0]: ../README.md#8-weak-tables-topik-krusial-yang-diperluas
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
