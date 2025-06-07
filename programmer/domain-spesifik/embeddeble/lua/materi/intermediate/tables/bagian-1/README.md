# **[BAGIAN 1: DASAR-DASAR TABLES][0]**

Bagian ini akan memperkenalkan Anda pada konsep `table`, cara membuatnya, dan mengisinya dengan data. Ini adalah fondasi dari semua yang akan kita pelajari tentang Lua.

### **1. Pengenalan dan Konsep Tables**

💡 **Deskripsi Konsep**
Di banyak bahasa pemrograman lain (seperti Dart yang pernah Anda pelajari), Anda akan menemukan berbagai jenis struktur data: *Arrays* (daftar), *Maps* (kamus/objek), *Sets*, dan lainnya. Lua menyederhanakan ini secara drastis. Lua hanya memiliki satu struktur data yang sangat kuat dan fleksibel yang disebut **table**.

Sebuah `table` di Lua adalah sebuah *associative array*. Ini berarti ia menyimpan koleksi pasangan **kunci-nilai** (key-value pairs). Anda bisa membayangkannya sebagai lemari dengan banyak laci. Setiap laci memiliki label (ini adalah `key`) dan berisi sesuatu (ini adalah `value`).

Keunikan `table` Lua:
* **Fleksibel**: Kunci (`key`) dan nilai (`value`) bisa berupa tipe data apa pun (kecuali `nil` untuk kunci).
* **Dinamis**: Anda bisa menambah dan menghapus elemen kapan saja.
* **Multiguna**: Bisa digunakan untuk merepresentasikan array, kamus (hash maps), objek, namespace, dan banyak lagi.

**Terminologi Penting:**
* **Table**: Struktur data fundamental di Lua.
* **Key**: "Label" atau "indeks" yang Anda gunakan untuk mengakses sebuah nilai di dalam table.
* **Value**: Data yang disimpan di dalam table, yang diakses menggunakan `key`.
* **Element**: Kombinasi dari sebuah `key` dan `value` di dalam table.

---

### **2. Konstruksi dan Inisialisasi Tables**

💡 **Deskripsi Konsep**
"Konstruksi" adalah proses membuat sebuah table. Anda dapat membuat table kosong atau langsung mengisinya dengan data saat dibuat ("inisialisasi").

#### **Sintaks Dasar: Table Constructor**
Cara paling umum untuk membuat table adalah dengan menggunakan *table constructor*, yang direpresentasikan oleh kurung kurawal `{}`.

**Contoh Kode 1: Membuat Table Kosong**
```lua
-- Membuat sebuah table kosong untuk menyimpan profil pemain.
local playerProfile = {}
```

**Penjelasan Per-Sintaksis:**
* `--`: Ini adalah komentar. Teks apa pun setelah `--` dalam satu baris akan diabaikan oleh Lua.
* `local`: Ini adalah kata kunci untuk mendeklarasikan variabel dengan **lingkup lokal** (local scope). Artinya, variabel `playerProfile` hanya akan ada dan bisa diakses di dalam blok kode tempat ia dibuat. Menggunakan `local` adalah praktik terbaik untuk menghindari konflik nama dan meningkatkan performa.
* `playerProfile`: Ini adalah nama variabel yang kita berikan.
* `=`: Ini adalah operator penugasan (*assignment operator*), yang memberikan nilai di sebelah kanan ke variabel di sebelah kiri.
* `{}`: Ini adalah *table constructor*. Dalam kasus ini, ia membuat sebuah table yang baru dan kosong.

---

#### **Inisialisasi Table (Mengisi Data Sejak Awal)**
Anda bisa langsung mengisi table saat membuatnya. Ada dua gaya utama: gaya daftar (*list-style*) dan gaya rekaman (*record-style*).

**Contoh Kode 2: Inisialisasi Gaya Daftar (List-style)**
Gaya ini digunakan untuk membuat table yang berperilaku seperti array atau daftar.

```lua
-- Membuat daftar buah-buahan
local fruits = {"Apple", "Banana", "Orange"}
```

**Penjelasan Per-Sintaksis:**
* `local fruits = ...`: Sama seperti sebelumnya, kita membuat variabel lokal bernama `fruits`.
* `{ "Apple", "Banana", "Orange" }`: Di dalam constructor `{}`, kita menyediakan daftar nilai yang dipisahkan oleh koma.
    * `"Apple"`: Ini adalah nilai string.
* **Konsep Penting**: Ketika Anda tidak menentukan `key`, Lua secara otomatis akan menggunakan **angka integer berurutan** yang dimulai dari **1** sebagai `key`. Jadi, table `fruits` sebenarnya terlihat seperti ini di balik layar:
    * `key = 1`, `value = "Apple"`
    * `key = 2`, `value = "Banana"`
    * `key = 3`, `value = "Orange"`
   

**Contoh Kode 3: Inisialisasi Gaya Rekaman (Record-style)**
Gaya ini digunakan untuk membuat table yang berperilaku seperti objek atau kamus, di mana setiap elemen memiliki nama (`key`) yang deskriptif.

```lua
-- Membuat table yang merepresentasikan data seorang pemain
local player = {
    name = "Arjuna",
    level = 5,
    class = "Archer"
}
```

**Penjelasan Per-Sintaksis:**
* `name = "Arjuna"`: Ini adalah satu elemen. `name` adalah `key` (dalam bentuk string) dan `"Arjuna"` adalah `value`-nya. Sintaks `key = value` adalah cara mudah untuk mendefinisikan `key` berupa string yang merupakan identifier yang valid.
* `level = 5`: `level` adalah `key` dan `5` adalah `value` (dalam bentuk angka).
* `class = "Archer"`: `class` adalah `key` dan `"Archer"` adalah `value`.
* Pemisahan dengan koma `,` digunakan antar elemen.

**Referensi untuk materi ini:**
* Lua-users Wiki: Tables Tutorial - [http://lua-users.org/wiki/TablesTutorial](http://lua-users.org/wiki/TablesTutorial)
* W3Schools: Lua Tables - [https://w3schools.tech/tutorial/lua/lua_tables](https://w3schools.tech/tutorial/lua/lua_tables)

---

# **BAGIAN 2: OPERASI DASAR TABLES**

Sekarang setelah Anda tahu cara membuat table, mari kita pelajari cara mengakses, memodifikasi, dan menelusuri (iterasi) elemen-elemen di dalamnya.

### **1. Akses dan Modifikasi Elemen**

💡 **Deskripsi Konsep**
Setelah table dibuat, Anda perlu cara untuk membaca nilai di dalamnya dan mengubahnya atau menambahkan nilai baru. Lua menyediakan dua sintaks utama untuk ini: **dot notation** (`.`) dan **bracket notation** (`[]`).

**Terminologi Penting:**
* **Dot Notation (`.`):** Cara pintas untuk mengakses elemen yang `key`-nya adalah string dan merupakan nama variabel yang valid (tidak mengandung spasi, tidak diawali angka, dll). Contoh: `myTable.myKey`.
* **Bracket Notation (`[]`):** Cara yang lebih umum dan fleksibel. Anda bisa menggunakan tipe data apa pun sebagai `key` di dalam kurung siku, termasuk string (bahkan yang dengan spasi), angka, atau bahkan variabel lain. Contoh: `myTable["my key"]` atau `myTable[1]`.

**Contoh Kode 4: Mengakses Elemen Table**
Kita akan menggunakan table `player` dan `fruits` dari contoh sebelumnya.

```lua
-- Menggunakan dot notation untuk mengakses key berupa string
print(player.name)  -- Output: Arjuna

-- Menggunakan bracket notation untuk mengakses key berupa angka
print(fruits[1])    -- Output: Apple

-- Menggunakan bracket notation untuk mengakses key berupa string
-- Ini setara dengan player.class
print(player["class"]) -- Output: Archer
```

**Penjelasan Per-Sintaksis:**
* `print(...)`: Ini adalah fungsi bawaan Lua untuk menampilkan nilai ke konsol.
* `player.name`: Mengakses `value` dari `key` "name" di dalam table `player` menggunakan dot notation.
* `fruits[1]`: Mengakses `value` dari `key` `1` (angka) di dalam table `fruits` menggunakan bracket notation. Anda **tidak bisa** menulis `fruits.1`, ini akan menyebabkan error.
* `player["class"]`: Mengakses `value` dari `key` "class" menggunakan bracket notation. Ini berguna jika `key` Anda disimpan dalam variabel. Contoh:
    ```lua
    local keyToAccess = "level"
    print(player[keyToAccess]) -- Output: 5
    ```

**Contoh Kode 5: Modifikasi dan Penambahan Elemen**
Anda menggunakan sintaks yang sama dengan operator penugasan (`=`) untuk mengubah nilai yang ada atau menambahkan elemen baru.

```lua
-- Modifikasi nilai yang sudah ada
player.level = 6
print("Level sekarang: " .. player.level) -- Output: Level sekarang: 6

-- Menambahkan elemen baru (field baru) ke table player
player.guild = "Pandawa"
print(player.guild) -- Output: Pandawa

-- Menambahkan elemen baru ke table fruits
fruits[4] = "Grape"
print(fruits[4]) -- Output: Grape
```

**Penjelasan Per-Sintaksis:**
* `player.level = 6`: Lua mencari `key` "level" di table `player`. Karena sudah ada, nilainya ditimpa dari `5` menjadi `6`.
* `player.guild = "Pandawa"`: Lua mencari `key` "guild" di table `player`. Karena tidak ada, Lua membuat elemen baru dengan `key` "guild" dan `value` "Pandawa".
* `"Level sekarang: " .. player.level`: Operator `..` adalah operator konkatenasi (penggabungan) string di Lua.
* `fruits[4] = "Grape"`: Menambahkan elemen baru ke table `fruits` dengan `key` `4` dan `value` "Grape".

**Referensi untuk materi ini:**
* GameDev Academy: Lua Table Tutorial - [https://gamedevacademy.org/lua-table-tutorial-complete-guide/](https://gamedevacademy.org/lua-table-tutorial-complete-guide/)
* PiEmbSysTech: Understanding Tables - [https://piembsystech.com/understanding-tables-in-lua-programming-language/](https://piembsystech.com/understanding-tables-in-lua-programming-language/)

---

### **2. Iterasi dan Traversal Tables**

💡 **Deskripsi Konsep**
Iterasi atau *traversal* adalah proses "mengunjungi" atau "menelusuri" setiap elemen di dalam sebuah table, satu per satu, biasanya untuk melakukan sesuatu dengan setiap elemen tersebut. Cara paling umum untuk melakukan ini adalah dengan *generic `for` loop*.

Lua menyediakan dua fungsi iterator utama yang sangat penting untuk dipahami perbedaannya: `pairs()` dan `ipairs()`.

#### **`pairs()` vs `ipairs()` - Perbedaan dan Penggunaan**

**Terminologi Penting:**
* **Iterator**: Sebuah fungsi yang, setiap kali dipanggil, mengembalikan elemen berikutnya dari sebuah koleksi. `pairs` dan `ipairs` adalah pabrik iterator.
* **Generic `for` loop**: Bentuk `for` loop di Lua yang menggunakan iterator untuk menelusuri sebuah koleksi. Strukturnya adalah `for vars in iterator_factory do ... end`.

#### **`ipairs()` - Untuk Iterasi Bagian Array**
Gunakan `ipairs()` ketika Anda ingin menelusuri bagian **array/daftar** dari sebuah table.
* Ia akan berjalan dari `key` angka `1`, `2`, `3`, dan seterusnya.
* Ia akan **berhenti** ketika menemukan `key` angka pertama yang tidak ada (nilainya `nil`).
* Urutannya dijamin sekuensial (1, 2, 3, ...).

**Contoh Kode 6: Menggunakan `ipairs()`**
```lua
local fruits = {"Apple", "Banana", "Orange"}
fruits[5] = "Mango" -- Ada 'lubang' di indeks 4

print("--- Iterasi dengan ipairs ---")
for index, value in ipairs(fruits) do
    print("Indeks: " .. index .. ", Buah: " .. value)
end
```

**Penjelasan Per-Sintaksis:**
* `for index, value in ipairs(fruits) do`: Ini adalah `for` loop.
    * `ipairs(fruits)`: Memanggil fungsi `ipairs` pada table `fruits`. Ini akan menghasilkan iterator.
    * `for index, value in ...`: Untuk setiap langkah iterasi, iterator akan memberikan dua nilai: `key` (yang kita simpan di variabel `index`) dan `value` (yang kita simpan di variabel `value`).
* `end`: Menutup blok `for` loop.
* **Hasil Eksekusi**:
    ```
    --- Iterasi dengan ipairs ---
    Indeks: 1, Buah: Apple
    Indeks: 2, Buah: Banana
    Indeks: 3, Buah: Orange
    ```
    Perhatikan bahwa "Mango" di indeks `5` **tidak tercetak**. Ini karena `ipairs` berhenti setelah indeks `3`, karena indeks `4` tidak ada (nilainya `nil`).

#### **`pairs()` - Untuk Iterasi Semua Elemen**
Gunakan `pairs()` ketika Anda ingin menelusuri **semua** elemen di dalam table, tidak peduli apa pun `key`-nya (angka, string, dll).
* Ia akan mengunjungi setiap pasangan `key-value`.
* **Urutan iterasinya tidak dijamin!** Ini sangat penting untuk diingat. Jangan pernah mengandalkan urutan saat menggunakan `pairs`.

**Contoh Kode 7: Menggunakan `pairs()`**
```lua
local player = {
    name = "Arjuna",
    level = 6,
    class = "Archer",
    [1] = "inventory_slot_1" -- Menambahkan key angka
}

print("\n--- Iterasi dengan pairs ---")
for key, value in pairs(player) do
    print("Key: " .. tostring(key) .. ", Value: " .. tostring(value))
end
```

**Penjelasan Per-Sintaksis:**
* `for key, value in pairs(player) do`: Strukturnya mirip dengan `ipairs`, tetapi menggunakan `pairs` untuk mendapatkan iterator yang akan melewati *semua* elemen.
* `tostring(key)`: Kita menggunakan fungsi `tostring()` untuk memastikan `key` (yang bisa jadi angka atau string) diubah menjadi string sebelum digabungkan dengan string lain.
* **Hasil Eksekusi (Urutan bisa berbeda!)**:
    ```
    --- Iterasi dengan pairs ---
    Key: 1, Value: inventory_slot_1
    Key: name, Value: Arjuna
    Key: class, Value: Archer
    Key: level, Value: 6
    ```
    Perhatikan bahwa `pairs` mengunjungi semua elemen, baik yang `key`-nya string (`name`, `class`, `level`) maupun angka (`1`).

---
**Ringkasan Cepat:**

| Fitur | `ipairs()` | `pairs()` |
| :--- | :--- | :--- |
| **Bagian Table** | Hanya bagian array (indeks 1, 2, 3...) | Semua bagian (array dan hash) |
| **Kondisi Berhenti** | Berhenti di indeks integer pertama yang `nil` | Berjalan sampai semua elemen habis |
| **Urutan** | Dijamin sekuensial (1, 2, 3...) | **Tidak dijamin** |
| **Kapan Digunakan**| Saat Anda memperlakukan table sebagai **daftar/array**. | Saat Anda memperlakukan table sebagai **kamus/objek** atau butuh semua elemennya. |

---

Ini adalah akhir dari pengantar dasar mengenai Tables. Anda sekarang memiliki pemahaman yang kuat tentang apa itu table, cara membuatnya, mengisi, mengakses, memodifikasi, dan menelusurinya. Ini adalah keterampilan paling fundamental dalam pemrograman Lua.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md
[sebelumnya]:../../../dasar/input-output/advanced-topics/README.md
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
