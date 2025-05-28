## [5\. Functions - Konsep Mendalam][5]

Bagian ini akan membahas secara mendalam tentang definisi fungsi, cara pemanggilan, fitur-fitur canggih seperti nilai kembali ganda, argumen variabel (varargs), closure, serta konsep fungsi sebagai _first-class citizen_ di Lua.

---

### 5.1 Function Definition dan Calling (Definisi dan Pemanggilan Fungsi)

Fungsi memungkinkan Anda untuk mengelompokkan serangkaian pernyataan menjadi satu unit logis yang dapat dipanggil berkali-kali dari berbagai bagian program Anda.

#### Basic Function Syntax (Sintaks Fungsi Dasar)

- **Deskripsi:** Fungsi di Lua didefinisikan menggunakan kata kunci `function`, diikuti oleh nama fungsi, daftar parameter dalam tanda kurung, isi fungsi, dan diakhiri dengan kata kunci `end`. Fungsi dapat mengembalikan satu atau lebih nilai menggunakan pernyataan `return`. Jika tidak ada pernyataan `return` eksplisit atau `return` tanpa nilai, fungsi akan mengembalikan `nil`.
- **Terminologi:**
  - **Parameter:** Variabel lokal dalam fungsi yang menerima nilai (argumen) ketika fungsi dipanggil.
  - **Argumen:** Nilai aktual yang diteruskan ke fungsi ketika fungsi tersebut dipanggil.
  - **Return Value:** Nilai yang dikirim kembali oleh fungsi setelah selesai dieksekusi.
- **Implementasi dalam Neovim:** Fungsi adalah unit dasar untuk membangun logika plugin. Anda akan mendefinisikan fungsi untuk menangani perintah pengguna, callback untuk autocommands atau keymaps, fungsi utilitas, dan untuk mengorganisir kode plugin Anda menjadi modul-modul yang kohesif.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (Function Definitions): [https://www.lua.org/manual/5.1/manual.html\#2.5.8](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.5.8)
  - Lua 5.1 Reference Manual (Function Calls): [https://www.lua.org/manual/5.1/manual.html\#2.5.9](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.5.9)
  - Programming in Lua, 1st ed. (Chapter 5 - Functions): [https://www.lua.org/pil/5.html](https://www.lua.org/pil/5.html)

**Contoh Kode:**

```lua
-- Function declaration (Deklarasi fungsi)
-- Fungsi ini bernama 'greet' dan menerima satu parameter 'name'.
function greet(name)
    -- Menggabungkan string "Hello, " dengan nilai dari parameter 'name'.
    return "Hello, " .. name
end

-- Function call (Pemanggilan fungsi)
-- Memanggil fungsi 'greet' dengan argumen "World".
-- Nilai yang dikembalikan oleh fungsi 'greet' disimpan dalam variabel 'message'.
local message = greet("World")
print(message)  -- Output: Hello, World

-- Fungsi tanpa parameter dan tanpa nilai kembali eksplisit (akan mengembalikan nil)
function say_something()
    print("Ini fungsi tanpa parameter.")
    -- Tidak ada 'return' eksplisit, jadi fungsi ini mengembalikan nil.
end

local result_say = say_something() -- Output dari print: Ini fungsi tanpa parameter.
print("Hasil dari say_something:", result_say) -- Output: Hasil dari say_something: nil

-- Fungsi dengan beberapa parameter
function add_numbers(a, b)
    return a + b
end

local sum_result = add_numbers(10, 5)
print("Hasil penjumlahan:", sum_result) -- Output: Hasil penjumlahan: 15
```

**Cara Menjalankan Kode:** Simpan sebagai file `.lua` dan jalankan dengan `lua namafile.lua` atau melalui Neovim.

**Penjelasan Kode:**

- `function greet(name) ... end`: Mendefinisikan fungsi bernama `greet` yang menerima satu parameter `name`.
- `return "Hello, " .. name`: Pernyataan `return` mengembalikan hasil penggabungan string.
- `local message = greet("World")`: Memanggil fungsi `greet` dengan argumen `"World"`. Nilai yang dikembalikan (`"Hello, World"`) disimpan dalam variabel lokal `message`.
- `print(message)`: Mencetak isi `message`.
- `function say_something() ... end`: Mendefinisikan fungsi `say_something` tanpa parameter. Karena tidak ada `return` eksplisit, fungsi ini secara implisit mengembalikan `nil`.
- `local result_say = say_something()`: Memanggil `say_something`. Fungsi akan mencetak pesannya, dan `result_say` akan berisi `nil`.
- `function add_numbers(a, b) ... end`: Fungsi yang menerima dua parameter dan mengembalikan hasil penjumlahannya.

#### Anonymous Functions (Fungsi Anonim)

- **Deskripsi:** Fungsi di Lua adalah nilai _first-class_ (akan dibahas lebih lanjut). Ini berarti fungsi dapat dibuat tanpa nama eksplisit (anonim) dan di-assign ke variabel, disimpan dalam tabel, atau diteruskan sebagai argumen ke fungsi lain. Fungsi anonim sering digunakan untuk callback atau fungsi singkat yang tidak perlu nama global.
- **Terminologi:**
  - **Fungsi Anonim (Anonymous Function):** Fungsi yang didefinisikan tanpa nama resmi. Ia didefinisikan sebagai ekspresi.
- **Implementasi dalam Neovim:** Sangat umum digunakan untuk _callback_ dalam `vim.keymap.set` (untuk keymapping) atau `vim.api.nvim_create_autocmd` (untuk autocommands), di mana Anda mungkin hanya memerlukan fungsi kecil untuk tugas tertentu.

**Contoh Kode:**

```lua
-- Fungsi sebagai nilai yang di-assign ke variabel (ini adalah fungsi anonim)
local add = function(a, b)  -- 'add' adalah variabel yang menyimpan fungsi
    return a + b
end

print("Hasil dari fungsi anonim 'add':", add(3, 7)) -- Output: 10

-- Fungsi sebagai argumen untuk fungsi lain (higher-order function)
-- 'apply_operation' adalah fungsi yang menerima dua angka dan sebuah fungsi operasi.
local function apply_operation(a, b, operation_function)
    -- Memanggil fungsi 'operation_function' yang diteruskan sebagai argumen.
    return operation_function(a, b)
end

-- Meneruskan fungsi 'add' (yang menyimpan fungsi anonim) sebagai argumen
local result1 = apply_operation(5, 3, add)
print("Hasil apply_operation dengan 'add':", result1)  -- Output: 8

-- Meneruskan fungsi anonim secara langsung sebagai argumen
local result2 = apply_operation(10, 2, function(x, y) -- Fungsi anonim didefinisikan di tempat
    return x * y  -- Operasi perkalian
end)
print("Hasil apply_operation dengan fungsi perkalian anonim:", result2) -- Output: 20
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya.

**Penjelasan Kode:**

- `local add = function(a, b) ... end`: Sebuah fungsi anonim didefinisikan dan nilainya (referensi ke fungsi) di-assign ke variabel `add`. `add` sekarang dapat dipanggil seolah-olah itu adalah nama fungsi.
- `local function apply_operation(...) ... end`: Mendefinisikan fungsi `apply_operation` yang parameter ketiganya, `operation_function`, diharapkan adalah sebuah fungsi.
- `return operation_function(a, b)`: Di dalam `apply_operation`, fungsi yang diterima sebagai argumen dipanggil.
- `apply_operation(5, 3, add)`: Memanggil `apply_operation` dan meneruskan variabel `add` (yang berisi fungsi penjumlahan) sebagai argumen ketiga.
- `apply_operation(10, 2, function(x, y) ... end)`: Meneruskan fungsi anonim baru (untuk perkalian) secara langsung sebagai argumen ketiga saat memanggil `apply_operation`.

---

### 5.2 Advanced Function Features (Fitur Fungsi Tingkat Lanjut)

Lua menawarkan beberapa fitur canggih terkait fungsi yang sangat berguna.

#### Multiple Return Values (Nilai Kembali Ganda)

- **Deskripsi:** Fungsi di Lua dapat mengembalikan lebih dari satu nilai. Ketika fungsi dipanggil, Anda dapat menangkap nilai-nilai kembali ini dengan meng-assignnya ke beberapa variabel. Jika jumlah variabel lebih sedikit dari jumlah nilai yang dikembalikan, nilai kembali tambahan akan diabaikan. Jika jumlah variabel lebih banyak, variabel tambahan akan diberi nilai `nil`.
- **Implementasi dalam Neovim:** Banyak fungsi API Neovim mengembalikan beberapa nilai, misalnya, fungsi yang mengembalikan status keberhasilan dan hasil data, atau beberapa bagian informasi sekaligus (seperti posisi cursor yang mengembalikan baris dan kolom).
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (Multiple Results): [https://www.lua.org/manual/5.1/manual.html\#2.5](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.5) (bagian "Assignment")
  - Programming in Lua, 1st ed. (Multiple Results): [https://www.lua.org/pil/5.1.html](https://www.lua.org/pil/5.1.html)

**Contoh Kode:**

```lua
function get_name_and_age()
    local name = "John"
    local age = 25
    return name, age  -- Mengembalikan dua nilai: string 'name' dan number 'age'
end

-- Menangkap kedua nilai kembali
local person_name, person_age = get_name_and_age()
print("Nama:", person_name, "Umur:", person_age)  -- Output: Nama: John Umur: 25

-- Mengabaikan beberapa nilai kembali
-- Hanya menangkap nilai pertama, nilai kedua ('age') diabaikan
local name_only = get_name_and_age()
print("Nama saja:", name_only)  -- Output: Nama saja: John

-- Menggunakan underscore '_' untuk secara eksplisit mengabaikan nilai
-- Menangkap nilai kedua, mengabaikan nilai pertama
local _, age_only = get_name_and_age()
print("Umur saja:", age_only)  -- Output: Umur saja: 25

-- Menangkap lebih banyak variabel daripada nilai yang dikembalikan
local name_val, age_val, city_val = get_name_and_age()
print("Nama:", name_val, "Umur:", age_val, "Kota:", city_val)
-- Output: Nama: John Umur: 25 Kota: nil (karena fungsi hanya mengembalikan 2 nilai)

function get_coordinates()
    return 10, 20, "center"
end

local x, y = get_coordinates() -- x=10, y=20, "center" diabaikan
print("x:", x, "y:", y)
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya.

**Penjelasan Kode:**

- `function get_name_and_age() ... return name, age end`: Fungsi ini mengembalikan dua nilai, `name` dan `age`, yang dipisahkan oleh koma.
- `local person_name, person_age = get_name_and_age()`: Memanggil fungsi dan meng-assign dua nilai yang dikembalikan ke dua variabel `person_name` dan `person_age`.
- `local name_only = get_name_and_age()`: Jika hanya satu variabel yang disediakan di sisi kiri assignment, hanya nilai kembali pertama yang akan di-assign padanya. Nilai kembali lainnya diabaikan.
- `local _, age_only = get_name_and_age()`: Underscore `_` sering digunakan sebagai nama variabel untuk nilai yang ingin diabaikan secara eksplisit, demi kejelasan. Di sini, nilai pertama (`name`) diabaikan, dan nilai kedua (`age`) di-assign ke `age_only`.
- `local name_val, age_val, city_val = get_name_and_age()`: Jika ada lebih banyak variabel di sisi kiri daripada nilai yang dikembalikan, variabel tambahan akan di-assign `nil`.

#### Variable Arguments (Varargs) (Argumen Variabel)

- **Deskripsi:** Fungsi di Lua dapat didefinisikan untuk menerima jumlah argumen yang bervariasi. Ini dilakukan dengan menggunakan tiga titik (`...`) sebagai parameter terakhir dalam daftar parameter fungsi. Di dalam fungsi, argumen-argumen ini dapat diakses menggunakan ekspresi `...` juga. Cara umum untuk bekerja dengan varargs adalah dengan mengemasnya ke dalam tabel menggunakan `local args = {...}` atau menggunakan fungsi `select`.
- **Terminologi:**
  - **Varargs:** Singkatan dari _variable arguments_.
  - `select(index, ...)`: Fungsi bawaan. Jika `index` adalah angka, mengembalikan semua argumen dari `index` tersebut dan seterusnya. Jika `index` adalah string `"#"` , mengembalikan jumlah total varargs yang diteruskan.
- **Implementasi dalam Neovim:** Berguna untuk fungsi utilitas yang mungkin perlu menangani sejumlah input yang tidak pasti, seperti fungsi logging kustom, atau fungsi pembungkus (wrapper) untuk API lain yang menerima varargs.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (Varargs): [https://www.lua.org/manual/5.1/manual.html\#2.5.8](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.5.8) (bagian "Function Definitions")
  - Programming in Lua, 1st ed. (Variable Number of Arguments): [https://www.lua.org/pil/5.2.html](https://www.lua.org/pil/5.2.html)

**Contoh Kode:**

```lua
-- Fungsi 'sum' yang menerima jumlah argumen variabel
function sum(...)
    -- Mengemas semua argumen varargs ke dalam tabel bernama 'args'.
    -- Tanda kurung kurawal '{...}' digunakan untuk membuat tabel.
    local args_table = {...}
    local total = 0
    -- Menggunakan loop for numerik untuk iterasi melalui tabel 'args_table'.
    -- '#' adalah operator panjang, #args_table memberikan jumlah elemen dalam tabel.
    for i = 1, #args_table do
        total = total + args_table[i] -- Menambahkan setiap argumen ke 'total'.
    end
    return total
end

print("Sum(1, 2, 3):", sum(1, 2, 3))                -- Output: 6
print("Sum(10, 20, 30, 40, 50):", sum(10, 20, 30, 40, 50)) -- Output: 150
print("Sum():", sum())                               -- Output: 0 (tabel args kosong, loop tidak berjalan)

-- Menggunakan fungsi select() untuk varargs
function print_args_info(...)
    -- select("#", ...) mengembalikan jumlah argumen varargs.
    print("Total argumen:", select("#", ...))

    -- select(n, ...) mengembalikan argumen ke-n dan seterusnya.
    -- Di sini, kita hanya mengambil argumen pertama.
    local first_arg = select(1, ...)
    print("Argumen pertama:", first_arg)

    if select("#", ...) >= 2 then
        local second_arg = select(2, ...)
        print("Argumen kedua:", second_arg)
    end
end

print_args_info("apple", "banana", "cherry")
-- Output:
-- Total argumen: 3
-- Argumen pertama: apple
-- Argumen kedua: banana

print_args_info(100)
-- Output:
-- Total argumen: 1
-- Argumen pertama: 100
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya.

**Penjelasan Kode:**

- `function sum(...) ... end`: `...` dalam daftar parameter menunjukkan bahwa fungsi ini menerima argumen variabel.
- `local args_table = {...}`: Di dalam fungsi, `{...}` mengemas semua argumen variabel yang diteruskan ke dalam sebuah tabel bernama `args_table`.
- `for i = 1, #args_table do ... end`: Loop ini mengiterasi melalui tabel `args_table` untuk menjumlahkan semua elemennya.
- `function print_args_info(...) ... end`: Fungsi lain yang menggunakan varargs.
- `select("#", ...)`: Mengembalikan jumlah total argumen variabel yang diteruskan.
- `select(1, ...)`: Mengembalikan argumen variabel pertama. Jika ada argumen kedua, ketiga, dst., mereka juga akan "dikembalikan" oleh `select`, tetapi karena di-assign ke satu variabel `first_arg`, hanya yang pertama yang diambil (mirip perilaku multiple return).
- `select(2, ...)`: Mengembalikan argumen variabel kedua dan seterusnya.

#### Closures dan Lexical Scoping (Closure dan Lingkup Leksikal)

- **Deskripsi:**
  - **Lexical Scoping (Lingkup Leksikal):** Lua menggunakan lingkup leksikal (juga dikenal sebagai lingkup statis). Ini berarti variabel diakses berdasarkan lokasi di mana fungsi didefinisikan dalam kode sumber, bukan di mana fungsi tersebut dipanggil. Sebuah fungsi dalam dapat mengakses variabel dari fungsi luarnya.
  - **Closure:** Sebuah _closure_ adalah fungsi yang "mengingat" lingkungan (variabel) tempat ia diciptakan. Lebih tepatnya, closure adalah fungsi ditambah dengan referensi ke variabel-variabel lokal dari lingkup luarnya (disebut _upvalues_) yang diakses oleh fungsi tersebut. Bahkan jika fungsi luar telah selesai dieksekusi, closure masih dapat mengakses dan memodifikasi _upvalues_ ini.
  - **Upvalue:** Variabel lokal dari fungsi luar yang "ditangkap" atau dirujuk oleh fungsi dalam (closure).
- **Implementasi dalam Neovim:** Closure sangat kuat untuk membuat fungsi dengan state privat, atau untuk callback yang perlu mengingat konteks tertentu dari tempat mereka dibuat. Ini adalah konsep fundamental dalam banyak pola desain plugin, seperti membuat fungsi yang perilakunya dapat dikonfigurasi saat pembuatan.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (Visibility Rules): [https://www.lua.org/manual/5.1/manual.html\#2.6](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.6)
  - Programming in Lua, 1st ed. (Chapter 6 - More about Functions, covers Closures): [https://www.lua.org/pil/6.1.html](https://www.lua.org/pil/6.1.html)

**Contoh Kode:**

```lua
-- Fungsi 'create_counter' adalah fungsi luar.
function create_counter()
    local count = 0  -- 'count' adalah variabel lokal untuk 'create_counter'.
                     -- Ini akan menjadi 'upvalue' untuk fungsi dalam.

    -- Mengembalikan fungsi anonim (ini adalah closure).
    return function()
        count = count + 1  -- Fungsi dalam ini mengakses dan memodifikasi 'count' dari lingkup luarnya.
        return count
    end
end

-- Setiap pemanggilan 'create_counter' membuat instance 'count' yang baru dan independen.
local counter1 = create_counter() -- 'counter1' sekarang adalah closure.
local counter2 = create_counter() -- 'counter2' adalah closure lain, dengan 'count' sendiri.

print("Counter 1:", counter1())  -- Output: 1 ('count' dalam counter1 menjadi 1)
print("Counter 1:", counter1())  -- Output: 2 ('count' dalam counter1 menjadi 2)

print("Counter 2:", counter2())  -- Output: 1 ('count' dalam counter2 menjadi 1, independen dari counter1)
print("Counter 1:", counter1())  -- Output: 3 ('count' dalam counter1 menjadi 3)

-- Contoh lain: fungsi yang mengembalikan fungsi lain dengan parameter dari luar
function make_multiplier(x)
    -- 'x' adalah upvalue untuk fungsi anonim di bawah
    return function(y)
        return x * y
    end
end

local multiply_by_5 = make_multiplier(5) -- Membuat closure yang akan selalu mengalikan dengan 5
local multiply_by_10 = make_multiplier(10)

print("5 * 3 =", multiply_by_5(3))   -- Output: 15
print("10 * 7 =", multiply_by_10(7)) -- Output: 70
print("5 * 8 =", multiply_by_5(8))   -- Output: 40
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya.

**Penjelasan Kode:**

- `function create_counter() ... end`: Fungsi ini mendefinisikan variabel lokal `count` dan mengembalikan fungsi anonim.
- `local count = 0`: Variabel `count` ini adalah _upvalue_ untuk fungsi anonim yang dikembalikan.
- `return function() ... end`: Fungsi anonim ini adalah _closure_. Ketika `create_counter()` dipanggil, ia membuat lingkungan baru di mana `count` ada. Fungsi anonim ini "menangkap" `count` tersebut.
- `local counter1 = create_counter()`: `counter1` sekarang merujuk pada sebuah closure. Closure ini memiliki akses ke `count` spesifik yang dibuat saat `create_counter()` dipanggil untuk `counter1`.
- `local counter2 = create_counter()`: `counter2` merujuk pada closure lain, dengan instance `count` yang berbeda dan independen.
- Setiap kali `counter1()` atau `counter2()` dipanggil, mereka memodifikasi `count` masing-masing yang telah mereka "tangkap".
- Contoh `make_multiplier(x)` serupa: ia mengembalikan fungsi (closure) yang "mengingat" nilai `x` yang diteruskan saat `make_multiplier` dipanggil. `multiply_by_5` adalah fungsi yang akan selalu mengalikan argumennya dengan 5.

---

### 5.3 Function sebagai First-Class Citizens (Fungsi sebagai Warga Kelas Satu)

- **Deskripsi:** Di Lua, fungsi adalah "warga kelas satu" (first-class citizens). Ini berarti fungsi diperlakukan sama seperti tipe data lainnya (seperti angka, string, atau tabel). Fungsi dapat:
  1.  Disimpan dalam variabel (seperti yang terlihat pada fungsi anonim).
  2.  Disimpan sebagai field dalam tabel (ini adalah dasar untuk membuat "metode" dalam pemrograman berorientasi objek di Lua).
  3.  Diteruskan sebagai argumen ke fungsi lain.
  4.  Dikembalikan sebagai hasil dari fungsi lain.
- **Terminologi:**
  - **First-Class Citizen:** Entitas dalam bahasa pemrograman yang dapat muncul di mana pun entitas lain dari bahasa tersebut dapat muncul (misalnya, dapat di-assign ke variabel, diteruskan sebagai argumen, dikembalikan dari fungsi).
  - **Higher-Order Function (Fungsi Tingkat Tinggi):** Fungsi yang beroperasi pada fungsi lain, baik dengan mengambil fungsi sebagai argumen, mengembalikan fungsi, atau keduanya. Contohnya adalah fungsi `map`, `filter`, atau `sort` yang menerima fungsi komparasi.
- **Implementasi dalam Neovim:** Konsep ini sangat penting. Anda akan sering menyimpan fungsi dalam tabel untuk mengorganisir modul plugin (misalnya, `MyPlugin.setup = function() ... end`). Anda akan meneruskan fungsi sebagai callback ke API Neovim. Kemampuan untuk memperlakukan fungsi sebagai data memberikan fleksibilitas luar biasa dalam merancang plugin.

**Contoh Kode:**

```lua
-- 1. Fungsi disimpan dalam variabel (sudah kita lihat)
local my_print_function = print -- 'print' adalah fungsi, sekarang 'my_print_function' juga merujuk padanya
my_print_function("Dicetak menggunakan my_print_function")

-- 2. Fungsi disimpan dalam tabel
local math_operations = {
    add = function(a, b) return a + b end,
    subtract = function(a, b) return a - b end,
    multiply = function(a, b) return a * b end,
    divide = function(a, b) if b ~= 0 then return a / b else return "Error: Division by zero" end end
}

print("Penjumlahan (dari tabel):", math_operations.add(10, 5))      -- Output: 15
print("Pembagian (dari tabel):", math_operations.divide(10, 2))    -- Output: 5
print("Pembagian (dari tabel):", math_operations.divide(10, 0))    -- Output: Error: Division by zero

-- 3. Fungsi diteruskan sebagai argumen (sudah kita lihat dengan 'apply_operation')

-- 4. Fungsi dikembalikan sebagai hasil (sudah kita lihat dengan 'create_counter' dan 'make_multiplier')

-- Contoh Higher-Order Function: 'map'
-- Fungsi 'map' mengambil tabel (array-like) dan fungsi 'transform_func'.
-- Ia mengaplikasikan 'transform_func' ke setiap elemen tabel dan mengembalikan tabel baru dengan hasil transformasi.
function map_array(input_table, transform_func)
    local result_table = {}
    for i = 1, #input_table do
        result_table[i] = transform_func(input_table[i]) -- Memanggil transform_func untuk setiap elemen
    end
    return result_table
end

local numbers_list = {1, 2, 3, 4, 5}

-- Menggunakan 'map_array' untuk mengkuadratkan setiap angka
local squared_numbers = map_array(numbers_list, function(x) -- Fungsi anonim sebagai transform_func
    return x * x
end)

print("Angka asli:", table.concat(numbers_list, ", "))       -- Output: 1, 2, 3, 4, 5
print("Angka kuadrat:", table.concat(squared_numbers, ", ")) -- Output: 1, 4, 9, 16, 25

-- Menggunakan 'map_array' untuk mengubah setiap angka menjadi string dengan prefix
local stringified_numbers = map_array(numbers_list, function(x)
    return "Num-" .. x
end)
print("Angka stringified:", table.concat(stringified_numbers, ", ")) -- Output: Num-1, Num-2, Num-3, Num-4, Num-5
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya.

**Penjelasan Kode:**

- `local my_print_function = print`: Meng-assign fungsi `print` bawaan ke variabel baru.
- `local math_operations = { ... }`: Membuat tabel di mana beberapa fieldnya adalah fungsi. Ini memungkinkan pengelompokan fungsi terkait.
- `math_operations.add(10, 5)`: Memanggil fungsi `add` yang tersimpan di dalam tabel `math_operations`.
- `function map_array(input_table, transform_func) ... end`: Mendefinisikan fungsi `map_array` yang merupakan _higher-order function_. Ia mengambil `transform_func` (sebuah fungsi) sebagai argumen.
- `result_table[i] = transform_func(input_table[i])`: Memanggil fungsi `transform_func` yang diteruskan untuk setiap elemen.
- `map_array(numbers_list, function(x) return x * x end)`: Memanggil `map_array` dengan fungsi anonim yang mengkuadratkan argumennya.

---

Pemahaman yang solid tentang fungsi, termasuk fitur-fitur canggihnya dan sifatnya sebagai _first-class citizen_, akan sangat memberdayakan Anda dalam menulis kode Lua yang ekspresif, modular, dan kuat untuk plugin Neovim.

[5]: ../README.md/#5-functions---konsep-mendalam
