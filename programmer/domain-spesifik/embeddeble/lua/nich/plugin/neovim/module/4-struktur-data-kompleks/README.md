# **[4\. Struktur Data Kompleks][1]**

Lua hanya memiliki satu mekanisme untuk membuat struktur data kompleks, yaitu `table`. Fleksibilitasnya memungkinkan `table` untuk digunakan sebagai array, dictionary (hash map), objek, dan berbagai struktur data lainnya.

---

### 4.1 Tables - Struktur Data Utama Lua

- **Deskripsi:** `Table` di Lua adalah tipe data fundamental yang mengimplementasikan _associative arrays_. Ini berarti `table` adalah kumpulan pasangan kunci-nilai, di mana kunci (indeks) dapat berupa tipe data apa pun kecuali `nil` dan NaN (Not a Number), dan nilai juga dapat berupa tipe data apa pun. `Table` tidak memiliki ukuran tetap dan dapat tumbuh atau menyusut secara dinamis. Karena sifat asosiatifnya, `table` dapat digunakan untuk merepresentasikan berbagai struktur data:
  - **Array:** Dengan menggunakan bilangan bulat sebagai kunci.
  - **Dictionary (atau Hash Map):** Dengan menggunakan string atau tipe data lain sebagai kunci.
  - **Record/Struct:** Dengan menggunakan nama field (string) sebagai kunci.
  - **Object:** Dalam pemrograman berorientasi objek (akan dibahas nanti).
- **Terminologi:**
  - **Associative Array:** Koleksi pasangan kunci-nilai di mana kunci tidak harus berupa urutan numerik.
  - **1-based Indexing:** Secara konvensi, Lua menggunakan indeks yang dimulai dari 1 untuk bagian array dari tabel (misalnya, elemen pertama ada di indeks 1, bukan 0 seperti di banyak bahasa lain).
  - **Hash Part:** Bagian dari tabel di mana kunci adalah non-numerik atau numerik tetapi tidak dalam urutan sekuensial yang dimulai dari 1.
  - **Array Part:** Bagian dari tabel di mana kunci adalah bilangan bulat sekuensial yang dimulai dari 1.
- **Implementasi dalam Neovim:** `Table` adalah 'roti dan mentega' dari pengembangan plugin Neovim. Hampir semua data kompleks diatur menggunakan tabel:
  - Konfigurasi plugin (misalnya, `require('myplugin').setup({ option1 = true, list_items = {"a", "b"} })`).
  - Menyimpan state internal plugin.
  - Daftar item untuk UI (seperti hasil pencarian Telescope, item quickfix).
  - Representasi data dari API Neovim (misalnya, `vim.api.nvim_list_bufs()` mengembalikan tabel buffer).
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (Tables): [https://www.lua.org/manual/5.1/manual.html\#2.5.7](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.5.7)
  - Programming in Lua, 1st ed. (Chapter 2 - Tables and Chapter 11 - Data Structures): [https://www.lua.org/pil/2.5.html](https://www.lua.org/pil/2.5.html) dan [https://www.lua.org/pil/11.html](https://www.lua.org/pil/11.html)

#### Array-like Tables (Tabel Mirip Array)

Ketika tabel digunakan dengan kunci integer berurutan yang dimulai dari 1, ia berperilaku seperti array.

- **Deskripsi:** Bagian ini menunjukkan bagaimana tabel dapat digunakan sebagai array. Operator panjang `#` dapat digunakan untuk mendapatkan ukuran dari bagian array sebuah tabel (yaitu, jumlah elemen hingga indeks `nil` pertama dalam urutan numerik dari 1).
- **Fungsi `table.insert`:** Cara mudah untuk menambahkan elemen ke akhir array-like table atau pada posisi tertentu.

**Contoh Kode:**

```lua
-- Array dengan indeks numerik (1-based indexing)
local colors = {"red", "green", "blue"} -- Konstruktor tabel untuk array
print("Elemen pertama:", colors[1])       -- Output: red (indeks dimulai dari 1)
print("Elemen kedua:", colors[2])        -- Output: green
print("Ukuran tabel colors:", #colors)   -- Output: 3 (length operator)

-- Mengubah elemen
colors[1] = "darkred"
print("Elemen pertama setelah diubah:", colors[1]) -- Output: darkred

-- Menambah elemen di akhir menggunakan indeks langsung
colors[4] = "yellow"
print("Elemen keempat:", colors[4])      -- Output: yellow
print("Ukuran tabel colors sekarang:", #colors) -- Output: 4

-- Menambah elemen di akhir menggunakan table.insert
table.insert(colors, "purple")
print("Elemen kelima (setelah table.insert):", colors[5]) -- Output: purple
print("Ukuran tabel colors terakhir:", #colors)           -- Output: 5

-- Menambah elemen di posisi tertentu menggunakan table.insert
-- table.insert(nama_tabel, posisi_indeks, nilai)
table.insert(colors, 2, "orange") -- Menyisipkan "orange" di indeks 2
                                 -- Elemen lama di indeks 2 ke atas akan digeser
print("--- Tabel colors setelah menyisipkan 'orange' di indeks 2 ---")
for i = 1, #colors do
    print("Indeks", i, ":", colors[i])
end
-- Output yang diharapkan:
-- Indeks 1 : darkred
-- Indeks 2 : orange
-- Indeks 3 : green
-- Indeks 4 : blue
-- Indeks 5 : yellow
-- Indeks 6 : purple
print("Ukuran tabel colors final:", #colors) -- Output: 6
```

**Cara Menjalankan Kode:** Simpan sebagai file `.lua` dan jalankan dengan `lua namafile.lua` atau melalui Neovim.

**Penjelasan Kode:**

- `local colors = {"red", "green", "blue"}`: Ini adalah cara singkat untuk membuat tabel yang berperilaku seperti array. `"red"` akan memiliki indeks 1, `"green"` indeks 2, dan `"blue"` indeks 3.
- `print(colors[1])`: Mengakses elemen pada indeks 1.
- `print(#colors)`: Operator `#` (length) mengembalikan ukuran dari bagian array tabel. Untuk `colors`, awalnya adalah 3.
- `colors[1] = "darkred"`: Mengubah nilai pada indeks 1.
- `colors[4] = "yellow"`: Menambahkan elemen baru pada indeks 4. Ukuran tabel menjadi 4.
- `table.insert(colors, "purple")`: Fungsi `table.insert` tanpa argumen posisi akan menambahkan `"purple"` ke akhir tabel `colors`.
- `table.insert(colors, 2, "orange")`: Menyisipkan `"orange"` pada indeks 2. Elemen yang ada di indeks 2 (`"green"`) dan seterusnya akan digeser ke kanan (indeksnya bertambah).
- Loop `for` terakhir mencetak semua elemen untuk menunjukkan hasil akhir.

#### Hash Table / Dictionary

Ketika tabel digunakan dengan kunci string atau tipe data lain (selain integer berurutan dari 1), ia berperilaku seperti dictionary atau hash map.

- **Deskripsi:** Memungkinkan Anda menyimpan dan mengambil nilai menggunakan kunci yang lebih deskriptif (seringkali string). Ada dua cara utama untuk mengakses elemen: dot notation (jika kunci adalah string yang valid sebagai identifier Lua) dan bracket notation (untuk semua jenis kunci, termasuk string yang mengandung spasi atau variabel).

**Contoh Kode:**

```lua
-- Membuat tabel yang berperilaku seperti dictionary/hash map
local person = {
    name = "John Doe",  -- Kunci 'name' dengan nilai string "John Doe"
    age = 30,           -- Kunci 'age' dengan nilai numerik 30
    city = "Jakarta",
    ["is student"] = false -- Kunci dengan spasi, harus menggunakan bracket dan string
}

-- Akses menggunakan dot notation (untuk kunci yang valid sebagai identifier)
print("Nama (dot notation):", person.name)    -- Output: John Doe
print("Umur (dot notation):", person.age)      -- Output: 30

-- Akses menggunakan bracket notation (selalu bisa digunakan, terutama untuk kunci non-identifier)
print("Kota (bracket notation):", person["city"]) -- Output: Jakarta
print("Status pelajar:", person["is student"])  -- Output: false

-- Akses menggunakan bracket notation dengan variabel sebagai kunci
local key_to_access = "name"
print("Nama (dynamic key):", person[key_to_access]) -- Output: John Doe

-- Menambah field baru
person.occupation = "Developer"
person["country code"] = "ID"

print("Pekerjaan:", person.occupation)            -- Output: Developer
print("Kode Negara:", person["country code"])     -- Output: ID
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya.

**Penjelasan Kode:**

- `local person = { ... }`: Membuat tabel `person`.
  - `name = "John Doe"`: Ini adalah sintaksis gula untuk `["name"] = "John Doe"`. Kunci `name` (sebuah string) diasosiasikan dengan nilai `"John Doe"`.
  - `["is student"] = false`: Karena kunci `"is student"` mengandung spasi dan bukan identifier Lua yang valid, ia harus ditulis dalam tanda kurung siku dan kutip.
- `print(person.name)`: Mengakses nilai yang berasosiasi dengan kunci `name` menggunakan dot notation. Ini hanya berfungsi jika kunci adalah string yang tidak mengandung spasi atau karakter khusus dan tidak merupakan keyword Lua.
- `print(person["city"])`: Mengakses nilai menggunakan bracket notation. Ini selalu berfungsi untuk kunci string.
- `local key_to_access = "name"` kemudian `person[key_to_access]`: Menunjukkan bagaimana bracket notation memungkinkan penggunaan variabel yang berisi nama kunci untuk mengakses nilai secara dinamis.
- `person.occupation = "Developer"` dan `person["country code"] = "ID"`: Menambahkan pasangan kunci-nilai baru ke tabel.

#### Mixed Tables (Tabel Campuran)

Tabel di Lua dapat dengan mudah mencampur bagian array-like dan hash-like.

- **Deskripsi:** Satu tabel yang sama dapat memiliki elemen yang diindeks secara numerik dan elemen yang diindeks dengan string atau tipe lain. Operator panjang `#` masih akan mencoba memberikan panjang bagian array.

**Contoh Kode:**

```lua
local mixed = {
    "first element (array part)",      -- Indeks 1
    "second element (array part)",     -- Indeks 2
    name = "Mixed Table Example",      -- Kunci string 'name'
    [42] = "answer to everything",     -- Kunci numerik 42 (bukan bagian dari array sekuensial dari 1)
    is_mixed = true                    -- Kunci string 'is_mixed'
}

print("Elemen indeks 1:", mixed[1])               -- Output: first element (array part)
print("Nilai kunci 'name':", mixed.name)          -- Output: Mixed Table Example
print("Nilai kunci numerik 42:", mixed[42])       -- Output: answer to everything
print("Nilai kunci 'is_mixed':", mixed.is_mixed)  -- Output: true

-- Operator panjang '#' pada tabel campuran
-- Biasanya menghitung elemen array sekuensial dari indeks 1 hingga elemen nil pertama.
print("Panjang tabel mixed (#mixed):", #mixed)    -- Output: 2 (karena mixed[3] adalah nil)

mixed[3] = "third element (array part)"
print("Panjang tabel mixed setelah mixed[3] diisi:", #mixed) -- Output: 3
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya.

**Penjelasan Kode:**

- `local mixed = { ... }`: Mendefinisikan tabel campuran.
  - `"first element (array part)"` dan `"second element (array part)"` secara otomatis mendapatkan indeks numerik 1 dan 2.
  - `name = "Mixed Table Example"` adalah entri hash dengan kunci string.
  - `[42] = "answer to everything"` adalah entri hash dengan kunci numerik 42 (ini tidak dianggap bagian dari "array part" sekuensial untuk operator `#` karena ada lompatan dari indeks 2 ke 42).
- `print(#mixed)`: Akan menghasilkan `2`. Ini karena operator `#` mencari urutan kunci integer `1, 2, 3, ...` dan berhenti pada kunci integer pertama yang memiliki nilai `nil`. Dalam kasus ini, `mixed[3]` adalah `nil` pada awalnya.
- `mixed[3] = "third element (array part)"`: Setelah ini, `mixed[1]`, `mixed[2]`, dan `mixed[3]` semuanya memiliki nilai.
- `print("Panjang tabel mixed setelah mixed[3] diisi:", #mixed)`: Sekarang akan menghasilkan `3`.

#### Nested Tables (Tabel Bersarang)

Tabel dapat berisi tabel lain sebagai nilainya, memungkinkan pembuatan struktur data hierarkis.

- **Deskripsi:** Ini sangat berguna untuk mengorganisir data yang kompleks, seperti konfigurasi atau representasi objek yang memiliki sub-komponen.

**Contoh Kode:**

```lua
local config = {
    editor = {  -- 'editor' adalah kunci, nilainya adalah tabel lain
        theme = "dark",
        font_size = 14,
        plugins = { -- 'plugins' adalah kunci, nilainya adalah array-like table
            "lsp",
            "treesitter",
            "telescope"
        }
    },
    keybindings = { -- 'keybindings' adalah kunci, nilainya adalah tabel lain
        save = "<C-s>",
        quit = "<C-q>"
    }
}

-- Mengakses elemen dalam tabel bersarang
print("Tema editor:", config.editor.theme)                 -- Output: dark
print("Ukuran font editor:", config.editor.font_size)       -- Output: 14
print("Plugin pertama:", config.editor.plugins[1])        -- Output: lsp
print("Plugin ketiga:", config.editor.plugins[3])         -- Output: telescope
print("Keybinding untuk save:", config.keybindings.save)   -- Output: <C-s>

-- Mengubah nilai dalam tabel bersarang
config.editor.font_size = 16
config.editor.plugins[2] = "nvim-cmp" -- Mengganti 'treesitter'

print("Ukuran font editor baru:", config.editor.font_size) -- Output: 16
print("Plugin kedua (setelah diubah):", config.editor.plugins[2]) -- Output: nvim-cmp
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya.

**Penjelasan Kode:**

- `local config = { ... }`: Mendefinisikan tabel `config` yang kompleks.
- `editor = { ... }`: Nilai yang terkait dengan kunci `editor` adalah tabel lain, yang berisi konfigurasinya sendiri seperti `theme`, `font_size`, dan tabel `plugins` lainnya.
- `config.editor.theme`: Untuk mengakses `theme`, kita pertama-tama mengakses tabel `editor` dari `config` (`config.editor`), kemudian dari tabel hasil tersebut kita mengakses kunci `theme`.
- `config.editor.plugins[1]`: Mengakses tabel `plugins` di dalam `editor`, kemudian mengambil elemen pertama dari array-like table `plugins`.

---

### 4.2 Table Operations dan Methods (Operasi dan Metode Tabel)

Lua menyediakan pustaka `table` standar yang berisi fungsi-fungsi berguna untuk memanipulasi tabel, terutama bagian array-like.

#### Table Library Functions (Fungsi Pustaka Tabel)

- **Deskripsi:** Ini adalah fungsi-fungsi yang disediakan oleh modul `table` untuk melakukan operasi umum seperti pengurutan, penggabungan, penghapusan, dan penyisipan elemen dalam bagian array dari tabel.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (Table Manipulation): [https://www.lua.org/manual/5.1/manual.html\#5.5](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%235.5)
  - Programming in Lua, 1st ed. (Chapter 11 - Data Structures, covers table library): [https://www.lua.org/pil/11.1.html](https://www.lua.org/pil/11.1.html)

**Contoh Kode:**

```lua
local numbers = {3, 1, 4, 1, 5, 9, 2, 6}
print("Tabel numbers awal:", table.concat(numbers, ", "))

-- Sorting (Pengurutan)
-- table.sort(nama_tabel [, fungsi_komparasi])
-- Mengurutkan elemen tabel secara in-place (tabel asli dimodifikasi).
-- Default: urutan menaik (ascending).
table.sort(numbers)
print("Tabel numbers setelah diurutkan (ascending):", table.concat(numbers, ", "))
-- Output: 1, 1, 2, 3, 4, 5, 6, 9

-- Custom sort (Pengurutan kustom)
-- Menggunakan fungsi komparasi untuk urutan menurun (descending)
table.sort(numbers, function(a, b) return a > b end)
print("Tabel numbers setelah diurutkan (descending):", table.concat(numbers, ", "))
-- Output: 9, 6, 5, 4, 3, 2, 1, 1

-- Concatenation (Penggabungan elemen string dalam array)
-- table.concat(nama_tabel_array, [separator, [indeks_awal, [indeks_akhir]]])
-- Hanya bekerja pada bagian array dengan nilai string atau number (yang akan dikonversi ke string).
local words = {"Hello", "World", "from", "Lua"}
local sentence = table.concat(words, " ") -- Menggunakan spasi sebagai separator
print("Kalimat hasil concat:", sentence)     -- Output: Hello World from Lua

local partial_sentence = table.concat(words, "-", 2, 3) -- separator '-', dari indeks 2 sampai 3
print("Kalimat parsial:", partial_sentence) -- Output: World-from

-- Remove elements (Menghapus elemen)
-- table.remove(nama_tabel_array, [posisi_indeks])
-- Menghapus elemen pada 'posisi_indeks'. Jika posisi tidak diberikan, menghapus elemen terakhir.
-- Mengembalikan elemen yang dihapus. Elemen setelahnya digeser.
local items = {"A", "B", "C", "D", "E"}
print("Items awal:", table.concat(items, ", "))

local removed_item = table.remove(items, 2) -- Hapus elemen di indeks 2 ("B")
print("Item yang dihapus:", removed_item)    -- Output: B
print("Items setelah remove indeks 2:", table.concat(items, ", ")) -- Output: A, C, D, E

removed_item = table.remove(items) -- Hapus elemen terakhir ("E")
print("Item terakhir yang dihapus:", removed_item) -- Output: E
print("Items setelah remove terakhir:", table.concat(items, ", ")) -- Output: A, C, D

-- Insert elements (Menyisipkan elemen) - juga sudah dibahas di 4.1
-- table.insert(nama_tabel_array, [posisi_indeks,] nilai_baru)
table.insert(items, "X") -- Sisipkan "X" di akhir
print("Items setelah insert 'X' di akhir:", table.concat(items, ", ")) -- Output: A, C, D, X

table.insert(items, 1, "START") -- Sisipkan "START" di awal (indeks 1)
print("Items setelah insert 'START' di awal:", table.concat(items, ", ")) -- Output: START, A, C, D, X
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya.

**Penjelasan Kode:**

- `table.sort(numbers)`: Mengurutkan tabel `numbers` secara menaik. Tabel `numbers` dimodifikasi secara langsung.
- `table.sort(numbers, function(a, b) return a > b end)`: Mengurutkan `numbers` menggunakan fungsi komparasi kustom. Fungsi ini mengembalikan `true` jika `a` harus datang sebelum `b` (dalam kasus ini, jika `a` lebih besar dari `b`, untuk urutan menurun).
- `table.concat(words, " ")`: Menggabungkan semua elemen string dalam tabel `words` menjadi satu string, dengan setiap elemen dipisahkan oleh spasi.
- `table.concat(words, "-", 2, 3)`: Menggabungkan elemen dari indeks 2 hingga 3 dari tabel `words`, dipisahkan oleh tanda hubung.
- `table.remove(items, 2)`: Menghapus elemen pada indeks 2 dari tabel `items`. Elemen-elemen berikutnya akan digeser ke kiri untuk mengisi celah. Fungsi ini mengembalikan elemen yang dihapus.
- `table.remove(items)`: Jika posisi tidak ditentukan, `table.remove` menghapus elemen terakhir dari tabel.
- `table.insert(items, "X")` dan `table.insert(items, 1, "START")`: Mendemonstrasikan kembali `table.insert` untuk menambahkan elemen di akhir atau pada posisi tertentu.

#### Iterating Tables (Mengiterasi Tabel)

Cara paling umum untuk mengiterasi (melakukan perulangan) atas elemen-elemen tabel adalah menggunakan loop `for` generik dengan iterator `pairs` atau `ipairs`.

- **Deskripsi:**
  - `pairs(t)`: Iterator yang mengulang semua pasangan kunci-nilai dalam tabel `t`. Urutan iterasi tidak dijamin untuk bagian _hash_ (kunci non-numerik sekuensial). Ini menggunakan fungsi `next` secara internal.
  - `ipairs(t)`: Iterator yang mengulang pasangan indeks-nilai untuk bagian array dari tabel `t` (indeks numerik `1, 2, 3, ...`) hingga ditemukan indeks `nil` pertama. Urutan dijamin.
- **Implementasi dalam Neovim:** Keduanya sangat penting. `ipairs` untuk memproses daftar berurutan (misalnya, daftar buffer dari `vim.api.nvim_list_bufs()`). `pairs` untuk memproses tabel konfigurasi yang mungkin memiliki kunci string atau untuk inspeksi tabel secara umum.

**Contoh Kode:**

```lua
local data = {name = "Alice", age = 25, city = "Bandung", hobbies = {"reading", "hiking"}}

-- pairs() - iterasi semua key-value pairs (termasuk array part jika ada)
print("--- Menggunakan pairs() ---")
for key, value in pairs(data) do
    if type(value) == "table" then
        print(key .. ": (table) " .. table.concat(value, ", "))
    else
        print(key .. ": " .. tostring(value))
    end
end
-- Output (urutan mungkin bervariasi untuk kunci utama):
-- name: Alice
-- city: Bandung
-- hobbies: (table) reading, hiking
-- age: 25

local fruits_array = {"apple", "banana", "orange"}
fruits_array[5] = "grape" -- Membuat lubang (indeks 4 adalah nil)

-- ipairs() - iterasi hanya array part (sequential numeric keys dari 1)
-- Berhenti pada elemen nil pertama dalam urutan numerik.
print("--- Menggunakan ipairs() pada fruits_array ---")
for index, fruit in ipairs(fruits_array) do
    print("Indeks:", index, "Buah:", fruit)
end
-- Output:
-- Indeks: 1 Buah: apple
-- Indeks: 2 Buah: banana
-- Indeks: 3 Buah: orange
-- (Tidak akan mencetak 'grape' di indeks 5 karena fruits_array[4] adalah nil)

-- Jika ingin mengiterasi semua elemen numerik termasuk yang ada 'lubang',
-- Anda mungkin memerlukan loop numerik for dengan pemeriksaan nil, atau pairs.
print("--- Menggunakan pairs() pada fruits_array (untuk melihat semua) ---")
for key, value in pairs(fruits_array) do
    print("Kunci (pairs):", key, "Nilai:", value)
end
-- Output (urutan mungkin bervariasi, tapi akan menunjukkan semua):
-- Kunci (pairs): 1 Nilai: apple
-- Kunci (pairs): 2 Nilai: banana
-- Kunci (pairs): 3 Nilai: orange
-- Kunci (pairs): 5 Nilai: grape
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya.

**Penjelasan Kode:**

- `for key, value in pairs(data) do ... end`: Loop ini akan mengiterasi semua entri dalam tabel `data`. `key` akan berisi kunci (misalnya, `"name"`, `"age"`) dan `value` akan berisi nilai yang sesuai. Pemeriksaan `type(value) == "table"` ditambahkan untuk menangani kasus di mana nilai itu sendiri adalah tabel (seperti `hobbies`).
- `for index, fruit in ipairs(fruits_array) do ... end`: Loop ini menggunakan `ipairs` yang dirancang untuk bagian array. Ia akan mengiterasi dari indeks 1 (`"apple"`), 2 (`"banana"`), hingga 3 (`"orange"`). Karena `fruits_array[4]` adalah `nil` (tidak di-assign), `ipairs` akan berhenti di sana dan tidak akan mencapai `"grape"` di indeks 5.
- Loop `pairs` terakhir pada `fruits_array` menunjukkan bahwa `pairs` akan mengunjungi semua elemen yang ada, termasuk yang memiliki kunci numerik yang tidak sekuensial atau setelah `nil` jika menggunakan `ipairs`.

---

Tabel adalah struktur data yang sangat fundamental dan serbaguna di Lua. Penguasaan cara kerja tabel, termasuk berbagai cara untuk membuat, memodifikasi, dan mengiterasinya, adalah esensial untuk pengembangan plugin Neovim yang efektif.

> - **[Ke Atas](#)**
> - **[Selanjutnya][4]**
> - **[Sebelumnya][3]**
> - **[Kurikulum][2]**
> - **[Domain Spesifik][5]**

[5]: ../../../../../../../README.md
[1]: ../../README.md/#4-struktur-data-kompleks
[2]: ../../../../../README.md
[3]: ../3-operator-kontrolFlow/README.md
[4]: ../5-function/README.md
