# **BAGIAN 4: TABLE LIBRARY DAN FUNGSI BUILT-IN**

Sebelumnya kita telah memahami cara membuat, memanipulasi, dan bahkan "mengintip" cara kerja table di level rendah. Sekarang, kita akan melengkapinya dengan perangkat yang sangat berguna: **Pustaka `table` (Table Library)**. Pustaka ini adalah kumpulan fungsi bawaan Lua yang dirancang untuk melakukan operasi umum pada table, terutama yang digunakan sebagai **daftar** atau **array** (sequence). Menggunakan fungsi-fungsi ini lebih efisien dan tidak rentan kesalahan daripada menulis logikanya sendiri dari awal.

💡 **Deskripsi Konsep**
Anggaplah pustaka `table` sebagai "kotak peralatan" resmi dari Lua untuk table. Daripada Anda harus membuat sendiri fungsi untuk menyisipkan elemen di tengah daftar dan menggeser semua elemen lainnya secara manual, Lua sudah menyediakannya untuk Anda. Fungsi-fungsi ini umumnya diimplementasikan dalam C, membuatnya sangat cepat.

Kita akan membahas fungsi-fungsi yang paling penting satu per satu.

---

### **1. `table.insert`, `table.remove`, `table.sort`**

Kelompok fungsi ini adalah fondasi untuk memanipulasi table yang berperan sebagai daftar dinamis.

#### **`table.insert(list, [pos], value)`**

- **Tujuan**: Menyisipkan sebuah elemen baru ke dalam table-daftar.
- **Sintaks**:
  - `table.insert(nama_table, nilai)`: Menyisipkan `nilai` di akhir daftar.
  - `table.insert(nama_table, posisi, nilai)`: Menyisipkan `nilai` di `posisi` tertentu, dan menggeser elemen-elemen setelahnya ke kanan (indeksnya bertambah).

**Contoh Kode 11: Menggunakan `table.insert`**

```lua
local numbers = {10, 20, 40}

print("Sebelum insert:", table.concat(numbers, ", "))

-- Menyisipkan 50 di akhir daftar
table.insert(numbers, 50)
print("Setelah insert akhir:", table.concat(numbers, ", "))

-- Menyisipkan 30 di posisi ke-3
table.insert(numbers, 3, 30)
print("Setelah insert tengah:", table.concat(numbers, ", "))
```

**Hasil Eksekusi**:

```
Sebelum insert: 10, 20, 40
Setelah insert akhir: 10, 20, 40, 50
Setelah insert tengah: 10, 20, 30, 40, 50
```

**Penjelasan Per-Sintaksis:**

- `table.concat(numbers, ", ")`: Kita menggunakan `table.concat` (yang akan dibahas detail di bawah) untuk mencetak isi table dengan rapi, dipisahkan oleh koma.
- `table.insert(numbers, 50)`: Karena posisi tidak ditentukan, Lua menambahkan `50` ke akhir table. Table menjadi `{10, 20, 40, 50}`.
- `table.insert(numbers, 3, 30)`: Lua menyisipkan `30` di posisi `3`. Elemen yang tadinya di posisi 3 (`40`) dan seterusnya digeser ke kanan. Table menjadi `{10, 20, 30, 40, 50}`.

---

#### **`table.remove(list, [pos])`**

- **Tujuan**: Menghapus elemen dari table-daftar. Fungsi ini juga mengembalikan elemen yang dihapus.
- **Sintaks**:
  - `table.remove(nama_table)`: Menghapus elemen **terakhir** dari daftar.
  - `table.remove(nama_table, posisi)`: Menghapus elemen dari `posisi` tertentu, dan menggeser elemen-elemen setelahnya ke kiri untuk menutup celah.

**Contoh Kode 12: Menggunakan `table.remove`**

```lua
local letters = {"a", "b", "x", "c", "d"}

print("Sebelum remove:", table.concat(letters, ", "))

-- Menghapus elemen di posisi ke-3 ("x")
local removedElement = table.remove(letters, 3)
print("Elemen yg dihapus:", removedElement) -- Output: Elemen yg dihapus: x
print("Setelah remove tengah:", table.concat(letters, ", ")) -- Output: Setelah remove tengah: a, b, c, d

-- Menghapus elemen terakhir ("d")
table.remove(letters)
print("Setelah remove akhir:", table.concat(letters, ", ")) -- Output: Setelah remove akhir: a, b, c
```

**Penjelasan Per-Sintaksis:**

- `local removedElement = table.remove(letters, 3)`: Elemen di posisi 3 (`"x"`) dihapus. Elemen-elemen setelahnya (`"c"`, `"d"`) digeser ke kiri. Nilai yang dihapus (`"x"`) disimpan di variabel `removedElement`.
- `table.remove(letters)`: Karena posisi tidak ditentukan, elemen terakhir (`"d"`) dihapus.

---

#### **`table.sort(list, [comp])`**

- **Tujuan**: Mengurutkan elemen dalam sebuah table-daftar secara **in-place** (table aslinya yang diubah).
- **Sintaks**:
  - `table.sort(nama_table)`: Mengurutkan berdasarkan perbandingan standar Lua (angka diurutkan secara numerik, string secara alfabetis).
  - `table.sort(nama_table, fungsi_pembanding)`: Mengurutkan menggunakan logika khusus yang Anda definisikan dalam sebuah fungsi.

**Contoh Kode 13: Menggunakan `table.sort`**

```lua
-- 1. Pengurutan standar
local scores = {100, 23, 55, 89, 7}
table.sort(scores)
print("Skor terurut:", table.concat(scores, ", ")) -- Output: 7, 23, 55, 89, 100

-- 2. Pengurutan dengan fungsi pembanding (descending/menurun)
local function sortDescending(a, b)
    return a > b
end
table.sort(scores, sortDescending)
print("Skor terurut menurun:", table.concat(scores, ", ")) -- Output: 100, 89, 55, 23, 7

-- 3. Pengurutan table of tables
local players = {
    {name="Sita", score=85},
    {name="Rama", score=100},
    {name="Laksmana", score=90}
}
table.sort(players, function(a, b) return a.score < b.score end)

-- Mencetak hasil
for i, p in ipairs(players) do
    print(p.name, p.score)
end
```

**Penjelasan Per-Sintaksis:**

- `table.sort(scores)`: Mengurutkan table `scores` dari nilai terkecil ke terbesar.
- `function sortDescending(a, b) return a > b end`: Ini adalah fungsi pembanding. `table.sort` akan memanggil fungsi ini berulang kali dengan dua elemen (`a` dan `b`). Jika fungsi mengembalikan `true`, artinya `a` harus berada sebelum `b` di hasil akhir. Di sini, `a > b` berarti kita ingin angka yang lebih besar diletakkan di awal.
- `table.sort(players, function(a, b) return a.score < b.score end)`: Contoh yang sangat umum. Kita mengurutkan table `players` berdasarkan field `score` dari setiap table di dalamnya. `a` dan `b` adalah table pemain (misal, `{name="Sita", score=85}`). Kita membandingkan `a.score` dan `b.score`.

---

### **2. `table.concat`, `table.unpack`, `table.pack` (Lua 5.2+)**

#### **`table.concat(list, [sep], [i], [j])`**

- **Tujuan**: Menggabungkan elemen string atau angka dari sebuah table-daftar menjadi satu string tunggal.
- **Sintaks**: `sep` adalah string pemisah (opsional), `i` adalah indeks awal (default 1), dan `j` adalah indeks akhir (default panjang table).

(Kita sudah melihat contohnya di atas, ia sangat berguna untuk debugging dan menampilkan data).

#### **`table.unpack(list, [i], [j])`**

- **Tujuan**: Mengembalikan semua elemen dari sebuah table-daftar sebagai serangkaian nilai terpisah. Ini kebalikan dari `table.pack`.
- **Catatan Versi**: Di Lua 5.1 dan LuaJIT, fungsi ini adalah fungsi global `unpack()`. Di Lua 5.2+, ia dipindahkan ke dalam pustaka table menjadi `table.unpack()`.

**Contoh Kode 14: Menggunakan `table.unpack`**

```lua
local args = {"Hello", "Lua", "World"}

-- Mencetak setiap elemen sebagai argumen terpisah untuk print()
print(table.unpack(args)) -- Output: Hello   Lua   World

-- Menggunakan unpack untuk mencari nilai maksimum
local numbers = {15, 30, 25}
local max_val = math.max(table.unpack(numbers))
print("Nilai maksimum:", max_val) -- Output: Nilai maksimum: 30
```

**Penjelasan Per-Sintaksis**:

- `print(table.unpack(args))`: Ini setara dengan menulis `print("Hello", "Lua", "World")`. `table.unpack` "membongkar" table menjadi tiga nilai kembali yang terpisah, yang kemudian diterima oleh `print`.
- `math.max(table.unpack(numbers))`: Fungsi `math.max` menerima sejumlah argumen angka dan mengembalikan yang terbesar. Ini setara dengan memanggil `math.max(15, 30, 25)`.

#### **`table.pack(...)` (Lua 5.2+)**

- **Tujuan**: Kebalikan dari `unpack`. Ia mengambil sejumlah argumen dan "mengemasnya" ke dalam satu table baru.
- **Fitur Khusus**: Table yang dihasilkan oleh `table.pack` memiliki field tambahan bernama `"n"` yang berisi jumlah total argumen yang diterima, **termasuk `nil`**. Ini sangat berguna.

**Contoh Kode 15: Menggunakan `table.pack`**

```lua
-- argumen dengan nil di tengah
local packedTable = table.pack(10, 20, nil, 40)

-- Memeriksa isi table
print("Isi table:", table.concat(packedTable, ", ", 1, packedTable.n))
print("Jumlah elemen (menurut field 'n'):", packedTable.n) -- Output: 4
print("Panjang table (operator #):", #packedTable) -- Output: 2 (operator # berhenti di nil)
```

**Penjelasan Per-Sintaksis**:

- `table.pack(10, 20, nil, 40)`: Mengemas empat argumen menjadi table `packedTable`.
- `packedTable.n`: `table.pack` secara otomatis membuat field `n` yang berisi `4` (jumlah total argumen).
- `#packedTable`: Operator panjang standar (`#`) berhenti menghitung pada `nil` pertama, sehingga ia hanya melaporkan panjang `2`. Inilah mengapa `table.pack` dan field `n`-nya sangat berharga ketika Anda perlu menangani daftar argumen yang mungkin berisi `nil`.

---

### **3. `table.move(source, start, end, target_pos, [dest])` (Lua 5.3+)**

- **Tujuan**: Fungsi yang sangat efisien untuk menyalin serangkaian elemen dari satu table ke table lain (atau di dalam table yang sama).
- **Sintaks**:
  - `source`: Table sumber.
  - `start`: Indeks awal di `source`.
  - `end`: Indeks akhir di `source`.
  - `target_pos`: Indeks di table tujuan tempat elemen pertama akan disalin.
  - `dest`: Table tujuan (opsional). Jika dihilangkan, `source` akan menjadi tujuan (memindahkan elemen di dalam table yang sama).

**Contoh Kode 16: Menggunakan `table.move`**

```lua
local source_table = {"a", "b", "c", "d", "e"}
local dest_table = {1, 2, 3}

-- Pindahkan elemen ke-2 sampai ke-4 ("b", "c", "d") dari source_table
-- ke dest_table, dimulai dari posisi ke-4 di dest_table
table.move(source_table, 2, 4, 4, dest_table)

print("Tabel tujuan setelah move:", table.concat(dest_table, ", "))
-- Output: 1, 2, 3, b, c, d
```

**Penjelasan Per-Sintaksis**:

- `table.move(source_table, 2, 4, 4, dest_table)`:
  - Ambil dari `source_table`.
  - Mulai dari indeks `2` (`"b"`).
  - Sampai indeks `4` (`"d"`).
  - Letakkan di `dest_table` mulai dari posisi `4`.
  - `dest_table[4]` menjadi `"b"`, `dest_table[5]` menjadi `"c"`, `dest_table[6]` menjadi `"d"`.

---

Anda sekarang memiliki kotak peralatan yang lengkap untuk memanipulasi table-daftar secara efisien. Menggunakan fungsi-fungsi ini akan membuat kode Anda lebih bersih, lebih mudah dibaca, dan seringkali lebih cepat.

#

Langkah berikutnya dalam kurikulum ini adalah membahas satu topik paling kuat dan mendefinisikan di Lua tepatnya pada materi: **"5. METATABLES DAN METAMETHODS"**. Ini adalah tempat di mana kita benar-benar mulai mengubah perilaku dasar table untuk menciptakan sistem yang kompleks seperti Object-Oriented Programming.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

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
