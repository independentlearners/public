# **[BAGIAN 11: TABLES SEBAGAI STRUKTUR DATA][0]**

Setelah menjelajahi pola desain tingkat tinggi seperti OOP, sekarang kita akan kembali ke salah satu kegunaan paling mendasar dan kuat dari table: sebagai fondasi untuk mengimplementasikan berbagai struktur data klasik.

Fleksibilitas table Lua yang luar biasa berarti Anda tidak memerlukan tipe data yang berbeda untuk array, kamus, atau set. Semuanya bisa diimplementasikan secara efisien menggunakan table, dan bagian ini akan menunjukkan caranya.

💡 **Deskripsi Konsep**
Di banyak bahasa, Anda harus memilih struktur data yang tepat untuk tugas tertentu (misalnya, `List` vs `HashMap` di Java/Dart). Di Lua, `table` adalah kanvas kosong yang bisa Anda bentuk menjadi struktur data apa pun yang Anda butuhkan. Kuncinya adalah memahami pola implementasi untuk masing-masingnya.

### **1. Array/List dan Dictionary/Hash Tables**

Ini bukanlah implementasi yang perlu Anda bangun, melainkan dua "mode" alami dari table itu sendiri.

- **Array/List**: Ketika Anda menggunakan table dengan kunci integer berurutan yang dimulai dari 1, Anda secara efektif menggunakannya sebagai array atau list. Ini adalah penggunaan paling umum untuk menyimpan daftar item.
- **Dictionary/Hash Table**: Ketika Anda menggunakan string atau tipe data lain (selain integer berurutan) sebagai kunci, Anda menggunakannya sebagai kamus (juga dikenal sebagai hash map atau associative array). Ini berguna untuk menyimpan data dengan label deskriptif.

Lua menangani kedua kasus ini secara internal dan bahkan dapat mencampurkannya dalam satu table yang sama.

```lua
local myCharacter = {
    -- Bagian Array/List (untuk inventory)
    "Pedang", "Perisai", "Ramuan Merah",

    -- Bagian Dictionary/Hash (untuk statistik)
    name = "Ksatria Baja",
    level = 50,
    is_active = true
}

-- Mengakses bagian array
print("Item pertama:", myCharacter[1]) -- Output: Pedang

-- Mengakses bagian dictionary
print("Level karakter:", myCharacter.level) -- Output: 50
```

### **2. Nested Tables dan Struktur Kompleks**

Karena nilai dalam sebuah table bisa berupa tipe data apa pun, termasuk table lain, Anda dapat dengan mudah membuat struktur data hierarkis atau bersarang. Ini sangat mirip dengan format JSON dan sangat berguna untuk file konfigurasi atau merepresentasikan objek data yang rumit.

**Contoh Kode 30: Konfigurasi Game dengan Nested Tables**

```lua
local gameConfig = {
    window = {
        title = "Petualangan Lua",
        width = 1280,
        height = 720
    },
    audio = {
        master_volume = 0.8,
        music_enabled = true
    },
    -- Daftar objek table
    initial_enemies = {
        { name = "Goblin", hp = 30 },
        { name = "Orc", hp = 80 }
    }
}

-- Mengakses data bersarang
print("Lebar jendela:", gameConfig.window.width) -- Output: 1280
print("HP musuh kedua:", gameConfig.initial_enemies[2].hp) -- Output: 80
```

### **3. Stack (Tumpukan - LIFO)**

**Konsep**: LIFO (Last-In, First-Out). Item terakhir yang Anda masukkan adalah item pertama yang Anda keluarkan. Bayangkan tumpukan piring.

**Implementasi**: Stack sangat efisien di Lua menggunakan fungsi dari `table` library.

- **Push** (menambah item ke atas tumpukan): `table.insert(stack, item)`
- **Pop** (mengambil item teratas): `table.remove(stack)`

**Contoh Kode 31: Implementasi Stack**

```lua
local Stack = {}

function Stack.new() return {} end
function Stack.push(stack, item) table.insert(stack, item) end
function Stack.pop(stack) return table.remove(stack) end
function Stack.peek(stack) return stack[#stack] end
function Stack.isEmpty(stack) return #stack == 0 end

-- --- Penggunaan ---
local history = Stack.new()
Stack.push(history, "halaman1.html")
Stack.push(history, "halaman2.html")
Stack.push(history, "halaman3.html")

print("Halaman saat ini:", Stack.peek(history)) -- Output: halaman3.html

local last_page = Stack.pop(history)
print("Kembali ke halaman:", last_page) -- Output: halaman3.html
print("Halaman saat ini:", Stack.peek(history)) -- Output: halaman2.html
```

### **4. Queue (Antrian - FIFO)**

**Konsep**: FIFO (First-In, First-Out). Item pertama yang Anda masukkan adalah item pertama yang Anda keluarkan. Bayangkan antrian di kasir.

**Implementasi**:

- **Enqueue** (menambah item ke belakang antrian): `table.insert(queue, item)`
- **Dequeue** (mengambil item dari depan antrian): `table.remove(queue, 1)`

**Catatan Performa Penting**: `table.remove(queue, 1)` bisa menjadi lambat untuk antrian yang sangat besar karena semua elemen lain dalam table harus digeser ke kiri untuk mengisi celah. Untuk aplikasi berperforma tinggi, implementasi queue yang lebih baik menggunakan dua pointer atau _linked list_.

**Contoh Kode 32: Implementasi Queue Sederhana**

```lua
local Queue = {}

function Queue.new() return {} end
function Queue.enqueue(queue, item) table.insert(queue, item) end
function Queue.dequeue(queue) return table.remove(queue, 1) end
function Queue.peek(queue) return queue[1] end
function Queue.isEmpty(queue) return #queue == 0 end

-- --- Penggunaan ---
local task_queue = Queue.new()
Queue.enqueue(task_queue, "Cetak Dokumen A")
Queue.enqueue(task_queue, "Kirim Email B")
Queue.enqueue(task_queue, "Upload File C")

print("Tugas selanjutnya:", Queue.peek(task_queue)) -- Output: Cetak Dokumen A

local completed_task = Queue.dequeue(task_queue)
print("Tugas selesai:", completed_task) -- Output: Cetak Dokumen A
print("Tugas selanjutnya:", Queue.peek(task_queue)) -- Output: Kirim Email B
```

### **5. Set (Himpunan)**

**Konsep**: Sebuah koleksi yang hanya menyimpan nilai-nilai **unik**. Urutan tidak penting.

**Implementasi**: Pola standar di Lua adalah menggunakan table di mana **kunci** adalah item dalam set, dan **nilainya** adalah nilai placeholder (biasanya `true`). Ini membuat pengecekan keberadaan item menjadi sangat cepat.

**Contoh Kode 33: Implementasi Set**

```lua
local Set = {}

function Set.new(initial_items)
    local set = {}
    if initial_items then
        for _, item in ipairs(initial_items) do
            set[item] = true
        end
    end
    return set
end

function Set.add(set, item) set[item] = true end
function Set.remove(set, item) set[item] = nil end
function Set.has(set, item) return set[item] ~= nil end

-- --- Penggunaan ---
local skills = Set.new({"memanah", "berkuda"})

Set.add(skills, "memasak")
Set.add(skills, "memanah") -- Menambahkan duplikat tidak akan mengubah apa pun

print("Punya skill memasak?", Set.has(skills, "memasak")) -- Output: true
print("Punya skill berenang?", Set.has(skills, "berenang")) -- Output: false

Set.remove(skills, "berkuda")
print("Punya skill berkuda?", Set.has(skills, "berkuda")) -- Output: false
```

---

Anda sekarang telah melihat bagaimana satu tipe data `table` yang fleksibel dapat dibentuk untuk menjadi berbagai struktur data fundamental. Memahami pola-pola ini sangat penting untuk menulis kode yang bersih dan terorganisir.

#

Topik selanjutnya di kurikulum, **"12. PERFORMANCE DAN OPTIMASI TABLES"**, adalah kelanjutan yang sempurna, terutama setelah kita menyinggung masalah performa pada implementasi Queue. Kita akan membahas cara menggunakan table secara efisien.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-10/README.md
[selanjutnya]: ../bagian-12/README.md

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
