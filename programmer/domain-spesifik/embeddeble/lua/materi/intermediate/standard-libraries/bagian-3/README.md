# [Modul 3 — Table Library (`table`)][0]


<details>
  <summary>📃 Daftar Isi</summary>

---

### Struktur Pembelajaran Internal (mini-TOC)

* **3.1 Pengenalan Table**

  * Konsep dasar table (array, dictionary, mixed table)
  * Filosofi: satu struktur serbaguna
  * Representasi memory
* **3.2 Operasi Dasar Table**

  * Membuat, mengakses, memperbarui table
  * Iterasi dengan `pairs` dan `ipairs`
  * Panjang table `#`
* **3.3 Fungsi-Fungsi Table Library**

  * `table.insert`, `table.remove`, `table.concat`, `table.sort`, `table.unpack`
  * Studi kasus manajemen daftar
* **3.4 Table sebagai Dictionary & Set**

  * Key → value mapping
  * Implementasi set dengan table
* **3.5 Table & Metatable (pengantar ringan)**

  * Bagaimana metatable mengubah perilaku table
  * `__index`, `__newindex`
* Latihan & kuiz singkat
* Praktik terbaik & kesalahan umum
* Visualisasi

</details>

---

## 3.1 Pengenalan Table

### Deskripsi & Peran

Table adalah **satu-satunya struktur data kompleks bawaan di Lua**. Semua hal selain primitive (number, string, boolean, nil) dibangun dengan table. Fungsi table:

* Array: daftar dengan indeks numerik
* Dictionary: mapping key → value
* Object: dengan metatable
* Set, record, graph, dsb.

### Filosofi

* Lua memilih **satu struktur universal** agar bahasa tetap sederhana namun fleksibel.
* Table bersifat **reference type**: artinya assignment hanya memindahkan referensi, bukan copy isi.
* Tidak ada perbedaan sintaks antara array dan dictionary — semuanya adalah table.

### Sintaks dasar

```lua
-- array
local arr = {10, 20, 30}
print(arr[1])  -- 10 (Lua array dimulai dari indeks 1)

-- dictionary
local dict = {name="Ameer", level=5}
print(dict.name)       -- "Ameer"
print(dict["level"])   -- 5

-- mixed
local mixed = {1, 2, a=100, b=200}
```

---

## 3.2 Operasi Dasar Table

### Membuat & mengubah

```lua
local t = {}
t[1] = "satu"
t["dua"] = 2
print(t[1], t["dua"])
```

### Iterasi

* `pairs(t)` → semua key-value
* `ipairs(t)` → hanya numeric index berurut dari 1 hingga elemen pertama nil

```lua
local arr = {10, 20, 30}
for i, v in ipairs(arr) do
  print(i, v)
end

local dict = {a=1, b=2}
for k, v in pairs(dict) do
  print(k, v)
end
```

### Panjang `#`

```lua
local arr = {10, 20, 30}
print(#arr)  -- 3
```

⚠️ Catatan: `#` hanya valid untuk array berurut tanpa lubang (`nil` di tengah membuat hasil tak terdefinisi).

---

## 3.3 Fungsi-Fungsi Table Library

### Daftar fungsi utama

* **`table.insert(t, [pos], val)`** → menambah elemen
* **`table.remove(t, [pos])`** → hapus elemen
* **`table.concat(t, [sep], [i], [j])`** → gabungkan string array
* **`table.sort(t, [comp])`** → urutkan array
* **`table.unpack(t, [i], [j])`** → ekstrak elemen jadi multiple values

### Contoh implementasi

```lua
local arr = {"lua", "python", "dart"}

table.insert(arr, "rust")
print(table.concat(arr, ", "))  -- "lua, python, dart, rust"

table.remove(arr, 2)
print(table.concat(arr, ", "))  -- "lua, dart, rust"

table.sort(arr)
print(table.concat(arr, ", "))  -- "dart, lua, rust"

local a, b, c = table.unpack(arr)
print(a, b, c)  -- "dart" "lua" "rust"
```

### Studi kasus

Mengelola daftar todo:

```lua
local todo = {}
table.insert(todo, "Belajar Lua")
table.insert(todo, "Membuat plugin Neovim")

for i, task in ipairs(todo) do
  print(i, task)
end
```

---

## 3.4 Table sebagai Dictionary & Set

### Dictionary

```lua
local scores = {Ameer=95, Budi=88}
print(scores["Ameer"])
```

### Set

Gunakan key boolean:

```lua
local set = {apple=true, banana=true}
print(set.apple)     -- true
print(set.orange)    -- nil
```

---

## 3.5 Table & Metatable (pengantar ringan)

### Konsep

Metatable memberi “perilaku tambahan” ke table. Misalnya:

* `__index` untuk default value
* `__newindex` untuk kontrol assignment

### Contoh

```lua
local defaults = {color="blue", size="M"}
local t = {}
setmetatable(t, {__index = defaults})

print(t.color)  -- "blue" (fallback ke defaults)
```

---

## Visualisasi (ASCII Diagram)

```
┌─────────────────────────────┐
│          Table              │
│ ┌────────────┬────────────┐ │
│ │ Array Part │ Hash Part  │ │
│ │ (1,2,3,..) │ (key=val)  │ │
│ └────────────┴────────────┘ │
│   ┌─────────────────────┐   │
│   │  Metatable (opsi)   │   │
│   │  __index, __add...  │   │
│   └─────────────────────┘   │
└─────────────────────────────┘
```

---

## Praktik Terbaik

* Gunakan `local` untuk table yang tidak global.
* Hindari `#` jika table bisa memiliki `nil` di tengah.
* Untuk data berurutan, gunakan indeks numerik mulai dari 1.
* Untuk struktur dictionary, gunakan key string agar lebih jelas.
* Gunakan `pairs` untuk dictionary, `ipairs` untuk array.

---

## Kesalahan Umum & Solusi

* **Mengira array dimulai dari 0** → di Lua mulai dari 1.
* **Menggunakan `#` pada table dengan lubang** → hasil tak pasti. Solusi: gunakan counter manual.
* **Lupa bahwa table adalah reference** → assignment ke variable lain hanya menyalin referensi. Untuk clone, butuh fungsi khusus.

---

## Latihan & Kuiz

1. Buat program yang menyimpan daftar nama, lalu hapus nama ke-2 menggunakan `table.remove`.
2. Implementasikan fungsi `is_member(set, val)` untuk mengecek apakah elemen ada di set.
3. Apa output dari kode berikut?

   ```lua
   local t = {1,2,3}
   local t2 = t
   t2[1] = 100
   print(t[1])
   ```

   (jawaban: `100`, karena table adalah reference).

---

## Hubungan dengan Modul Lain

* **Modul 4 (Math):** table sering dipakai untuk menyimpan data numerik yang akan diproses.
* **Modul 5 (I/O):** hasil parsing file sering disimpan dalam table.
* **Modul 8 (Debug):** debug tools menampilkan isi table.
* **Modul 13 (Coroutine):** data queue sering diimplementasikan dengan table.

---

## Referensi

* Lua 5.4 Reference Manual — [Table manipulation](https://www.lua.org/manual/5.4/manual.html#6.6)
* Programming in Lua (Ierusalimschy) — Bab 5 & 6 tentang table
* Lua-users wiki — [Table Library Tutorial](http://lua-users.org/wiki/TableLibraryTutorial)
* Artikel: [Understanding Tables in Lua](https://dev.to/kartik2406/understanding-tables-in-lua-2jpa)

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

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
