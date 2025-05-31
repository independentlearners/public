# **[3\. Operator dan Kontrol Flow][3]**

Operator digunakan untuk melakukan operasi pada variabel dan nilai, sedangkan struktur kontrol alur (kontrol flow) digunakan untuk mengatur urutan eksekusi pernyataan dalam program berdasarkan kondisi atau iterasi tertentu.

---

### 3.1 Operator Aritmatika

Operator aritmatika digunakan untuk melakukan perhitungan matematis.

- **Deskripsi:** Lua menyediakan operator aritmatika standar untuk operasi penjumlahan, pengurangan, perkalian, pembagian, modulo (sisa bagi), dan eksponensial (pangkat). Penting untuk diingat bahwa di Lua 5.1 (basis LuaJIT yang digunakan Neovim), operasi pembagian (`/`) selalu menghasilkan angka _floating-point_. Operasi modulo `a % b` didefinisikan sebagai `a - floor(a/b)*b`.
- **Implementasi dalam Neovim:** Digunakan dalam berbagai skenario, seperti kalkulasi posisi window/cursor, perhitungan skor dalam _fuzzy finder_, penyesuaian _padding_, atau logika apa pun yang melibatkan angka.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (Arithmetic Operators): [https://www.lua.org/manual/5.1/manual.html\#2.5.1](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.5.1)
  - Programming in Lua, 1st ed. (Arithmetic): [https://www.lua.org/pil/3.1.html](https://www.lua.org/pil/3.1.html)

**Contoh Kode:**

```lua
local a = 10
local b = 3

print("a + b =", a + b)   -- Penjumlahan, Output: 13
print("a - b =", a - b)   -- Pengurangan, Output: 7
print("a * b =", a * b)   -- Perkalian, Output: 30
print("a / b =", a / b)   -- Pembagian (selalu float di Lua 5.1), Output: 3.333...
print("a % b =", a % b)   -- Modulo/sisa bagi, Output: 1 (10 dibagi 3 adalah 3 sisa 1)
print("a ^ b =", a ^ b)   -- Eksponensial (a pangkat b), Output: 1000 (10^3)

local c = 5
local d = 2
print("c ^ d =", c ^ d)   -- Output: 25 (5^2)

local e = 10.5
local f = 2.0
print("e / f =", e / f)   -- Output: 5.25
print("e % f =", e % f)   -- Output: 0.5 (10.5 = 5 * 2.0 + 0.5)
```

**Cara Menjalankan Kode:**

1.  Simpan kode di atas dalam sebuah file, misalnya `operator_aritmatika.lua`.
2.  Buka terminal atau command prompt.
3.  Jalankan menggunakan interpreter Lua dengan perintah: `lua operator_aritmatika.lua`.
4.  Di Neovim, Anda dapat mengeksekusi potongan kode atau file melalui perintah `:lua ...` atau `:luafile ...`.

**Penjelasan Kode:**

- `local a = 10` dan `local b = 3`: Mendeklarasikan dan menginisialisasi dua variabel lokal `a` dan `b`.
- `print("a + b =", a + b)`: Menjumlahkan `a` dan `b` (`10 + 3 = 13`) dan mencetak hasilnya.
- `print("a - b =", a - b)`: Mengurangkan `b` dari `a` (`10 - 3 = 7`) dan mencetak hasilnya.
- `print("a * b =", a * b)`: Mengalikan `a` dan `b` (`10 * 3 = 30`) dan mencetak hasilnya.
- `print("a / b =", a / b)`: Membagi `a` dengan `b` (`10 / 3`). Di Lua 5.1/LuaJIT, hasil pembagian selalu berupa _floating-point_, jadi outputnya adalah `3.3333333333333`.
- `print("a % b =", a % b)`: Operasi modulo. `10 % 3` menghasilkan sisa `1` karena $10 = 3 \\times 3 + 1$.
- `print("a ^ b =", a ^ b)`: Operasi eksponensial. `10 ^ 3` berarti $10^3 = 1000$.
- Sisa kode mendemonstrasikan operasi ini dengan angka lain, termasuk _floating-point_.

---

### 3.2 Operator Relasional

Operator relasional digunakan untuk membandingkan dua nilai. Hasil dari operasi relasional selalu berupa nilai boolean (`true` atau `false`).

- **Deskripsi:** Operator-operator ini meliputi kesetaraan (`==`), ketidaksetaraan (`~=`), lebih besar dari (`>`), lebih kecil dari (`<`), lebih besar dari atau sama dengan (`>=`), dan lebih kecil dari atau sama dengan (`<=`). Perhatikan bahwa operator "tidak sama dengan" di Lua adalah `~=` (bukan `!=` seperti di banyak bahasa lain). Operator relasional dapat digunakan untuk membandingkan angka dan string. Perbandingan string dilakukan secara leksikografis (sesuai urutan alfabet). Untuk tipe data tabel, fungsi, dan _userdata_, operator `==` memeriksa kesetaraan referensi (apakah keduanya merujuk ke objek yang sama di memori), bukan kesetaraan struktural (apakah isinya sama).
- **Implementasi dalam Neovim:** Sangat fundamental untuk logika kondisional, misalnya, memeriksa apakah nilai konfigurasi sama dengan nilai tertentu, apakah nomor baris saat ini lebih besar dari batas, atau apakah tipe file adalah "lua".
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (Relational Operators): [https://www.lua.org/manual/5.1/manual.html\#2.5.2](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.5.2)
  - Programming in Lua, 1st ed. (Relational Operators): [https://www.lua.org/pil/3.2.html](https://www.lua.org/pil/3.2.html)

**Contoh Kode:**

```lua
print("10 == 10 adalah", 10 == 10)     -- Sama dengan, Output: true
print("10 == 5 adalah", 10 == 5)       -- Sama dengan, Output: false
print("10 ~= 5 adalah", 10 ~= 5)       -- Tidak sama dengan, Output: true
print("10 ~= 10 adalah", 10 ~= 10)     -- Tidak sama dengan, Output: false
print("10 > 5 adalah", 10 > 5)         -- Lebih besar, Output: true
print("10 < 5 adalah", 10 < 5)         -- Lebih kecil, Output: false
print("10 >= 10 adalah", 10 >= 10)     -- Lebih besar atau sama, Output: true
print("10 <= 10 adalah", 10 <= 10)     -- Lebih kecil atau sama, Output: true

-- Perbandingan string (leksikografis)
print("'apple' == 'apple' adalah", 'apple' == 'apple') -- Output: true
print("'apple' < 'banana' adalah", 'apple' < 'banana') -- Output: true
print("'Zebra' < 'apple' adalah", 'Zebra' < 'apple')   -- Output: false (karena 'Z' > 'a' dalam ASCII)
                                                      -- Perbandingan case-sensitive

-- Perbandingan tipe berbeda umumnya false, kecuali untuk nil
print("10 == '10' adalah", 10 == '10') -- Output: false (angka tidak sama dengan string)

-- Perbandingan dengan nil
local var
print("var == nil adalah", var == nil) -- Output: true (var belum diinisialisasi)
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya.

**Penjelasan Kode:**

- Setiap baris `print` mengevaluasi ekspresi relasional dan mencetak hasilnya (`true` atau `false`).
- `10 == 10`: Memeriksa apakah 10 sama dengan 10. Hasilnya `true`.
- `10 ~= 5`: Memeriksa apakah 10 tidak sama dengan 5. Hasilnya `true`.
- `'apple' < 'banana'`: Membandingkan string secara leksikografis. Karena 'a' datang sebelum 'b' dalam urutan alfabet, hasilnya `true`.
- `'Zebra' < 'apple'`: Perbandingan ini _case-sensitive_. Nilai ASCII 'Z' (90) lebih besar dari nilai ASCII 'a' (97), jadi `'Zebra'` dianggap "lebih besar" dari `'apple'`. Hasilnya `false`.
- `10 == '10'`: Lua melakukan perbandingan tipe yang ketat. Angka `10` tidak sama dengan string `'10'`. Hasilnya `false`.
- `var == nil`: Jika `var` belum diinisialisasi, nilainya adalah `nil`. Jadi, perbandingannya dengan `nil` adalah `true`.

---

### 3.3 Operator Logika

Operator logika digunakan untuk menggabungkan atau memodifikasi ekspresi boolean.

- **Deskripsi:** Lua memiliki tiga operator logika: `and`, `or`, dan `not`.
  - `and`: Mengembalikan operand pertamanya jika operand tersebut adalah `false` atau `nil`; jika tidak, ia mengembalikan operand keduanya.
  - `or`: Mengembalikan operand pertamanya jika operand tersebut bukan `false` dan bukan `nil`; jika tidak, ia mengembalikan operand keduanya.
  - `not`: Selalu mengembalikan `true` atau `false`. Mengembalikan `true` jika operandnya adalah `false` atau `nil`, dan `false` sebaliknya.
  - Operator `and` dan `or` menggunakan _short-circuit evaluation_: operand kedua hanya dievaluasi jika diperlukan.
  - Idiom umum `result = condition and value_if_true or value_if_false` digunakan sebagai alternatif untuk ekspresi kondisional ternary. Namun, ini memiliki kelemahan: jika `value_if_true` kebetulan adalah `false` atau `nil`, maka `value_if_false` akan selalu dikembalikan, yang mungkin bukan perilaku yang diinginkan. Konstruksi ini bekerja dengan asumsi bahwa `value_if_true` selalu merupakan nilai _truthy_.
- **Terminologi:**
  - **Short-circuit evaluation:** Proses di mana operand kedua dari operator logika (`and`, `or`) hanya dievaluasi jika hasil keseluruhan ekspresi belum dapat ditentukan dari operand pertama.
- **Implementasi dalam Neovim:** Digunakan untuk membangun kondisi yang kompleks, misalnya, "jika plugin A aktif _dan_ tipe file adalah X, maka lakukan Y", atau "jika konfigurasi Z ada _atau_ ada nilai default, gunakan itu".
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (Logical Operators): [https://www.lua.org/manual/5.1/manual.html\#2.5.3](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.5.3)
  - Programming in Lua, 1st ed. (Logical Operators): [https://www.lua.org/pil/3.3.html](https://www.lua.org/pil/3.3.html)

**Contoh Kode:**

```lua
print("true and false adalah", true and false)   -- Output: false
print("true and true adalah", true and true)     -- Output: true
print("false and true adalah", false and true)   -- Output: false (true tidak dievaluasi)

print("true or false adalah", true or false)     -- Output: true (false tidak dievaluasi)
print("false or true adalah", false or true)     -- Output: true
print("false or false adalah", false or false)   -- Output: false

print("not true adalah", not true)               -- Output: false
print("not false adalah", not false)             -- Output: true
print("not nil adalah", not nil)                 -- Output: true
print("not 0 adalah", not 0)                   -- Output: false (karena 0 adalah truthy)

-- Short-circuit evaluation dan sifat 'and'/'or'
local a = 10
local b -- nil
local result_and = a and "a is truthy" -- 'a' truthy, jadi 'result_and' mendapat nilai kedua
print("result_and:", result_and)      -- Output: a is truthy

local result_or = b or "b is falsy (nil)" -- 'b' falsy (nil), jadi 'result_or' mendapat nilai kedua
print("result_or:", result_or)        -- Output: b is falsy (nil)

local name = nil
local default_name = "Pengguna"
local user_name = name or default_name -- Jika 'name' nil, gunakan 'default_name'
print("User name:", user_name)           -- Output: Pengguna

-- Idiom ternary (dengan caveat)
local condition = true
local value_if_true = "Benar"
local value_if_false = "Salah"
local ternary_result = condition and value_if_true or value_if_false
print("Ternary result (condition true):", ternary_result) -- Output: Benar

condition = false
ternary_result = condition and value_if_true or value_if_false
print("Ternary result (condition false):", ternary_result) -- Output: Salah

-- Caveat: Jika value_if_true adalah false atau nil
local tricky_value_if_true = false -- atau nil
condition = true
local tricky_result = condition and tricky_value_if_true or value_if_false
print("Tricky ternary result:", tricky_result) -- Output: Salah (bukan tricky_value_if_true yaitu false)
-- Untuk kasus ini, if-then-else lebih aman:
if condition then
    tricky_result = tricky_value_if_true
else
    tricky_result = value_if_false
end
print("Tricky result (aman):", tricky_result)
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya.

**Penjelasan Kode:**

- Baris-baris awal mendemonstrasikan hasil dasar dari operator `and`, `or`, dan `not` dengan nilai `true` dan `false`.
- `not nil` adalah `true`, dan `not 0` adalah `false` (karena `0` adalah _truthy_).
- `local result_and = a and "a is truthy"`: Karena `a` (nilai `10`) adalah _truthy_, operator `and` mengembalikan operand keduanya, yaitu string `"a is truthy"`.
- `local result_or = b or "b is falsy (nil)"`: Karena `b` adalah `nil` (_falsy_), operator `or` mengembalikan operand keduanya, yaitu string `"b is falsy (nil)"`.
- `local user_name = name or default_name`: Ini adalah idiom umum untuk memberikan nilai default. Jika `name` adalah `nil` atau `false`, `user_name` akan mendapatkan nilai `default_name`.
- Blok "Idiom ternary" mendemonstrasikan bagaimana `and` dan `or` dapat digunakan untuk meniru operator ternary.
  - Jika `condition` adalah `true`, `condition and value_if_true` mengevaluasi ke `value_if_true`. Kemudian `value_if_true or value_if_false` akan mengevaluasi ke `value_if_true` (dengan asumsi `value_if_true` bukan `false` atau `nil`).
  - Jika `condition` adalah `false`, `condition and value_if_true` mengevaluasi ke `condition` (yaitu `false`). Kemudian `false or value_if_false` akan mengevaluasi ke `value_if_false`.
- Bagian "Caveat" menunjukkan batasan idiom ternary ini: jika `value_if_true` itu sendiri adalah `false` (atau `nil`), maka bagian `or value_if_false` akan dievaluasi, menghasilkan `value_if_false` bahkan ketika `condition` adalah `true`. Struktur `if-then-else` lebih aman dan jelas dalam kasus seperti itu.

---

### 3.4 Kontrol Flow Structures (Struktur Kontrol Alur)

Struktur kontrol alur memungkinkan Anda untuk mengubah urutan eksekusi pernyataan, memungkinkan program membuat keputusan atau mengulang tugas.

#### If-Then-Else

- **Deskripsi:** Struktur `if` digunakan untuk mengeksekusi blok kode secara kondisional. Jika kondisi dalam `if` bernilai _truthy_, blok `then` dieksekusi. Anda dapat menambahkan satu atau lebih kondisi `elseif` dan blok `else` opsional yang akan dieksekusi jika tidak ada kondisi sebelumnya yang terpenuhi. Setiap struktur `if` harus diakhiri dengan `end`.
- **Implementasi dalam Neovim:** Pengambilan keputusan dasar, seperti mengaktifkan fitur berdasarkan konfigurasi, menjalankan perintah berbeda berdasarkan mode editor, atau menangani input pengguna.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (If statement): [https://www.lua.org/manual/5.1/manual.html\#2.4.4](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.4.4)
  - Programming in Lua, 1st ed. (If Then Else): [https://www.lua.org/pil/4.3.1.html](https://www.lua.org/pil/4.3.1.html)

**Contoh Kode:**

```lua
local score = 85

if score >= 90 then
    print("Excellent")
elseif score >= 80 then
    print("Good")            -- Ini yang akan tercetak
elseif score >= 70 then
    print("Average")
else
    print("Poor")
end

local temperature = 30
local is_raining = false

if temperature > 28 and not is_raining then
    print("Cuaca panas dan tidak hujan, cocok untuk keluar!")
elseif is_raining then
    print("Sedang hujan, lebih baik di rumah.")
else
    print("Cuaca sejuk.")
end
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya.

**Penjelasan Kode:**

- `local score = 85`: Inisialisasi variabel `score`.
- `if score >= 90 then ...`: Kondisi pertama (`85 >= 90`) adalah `false`.
- `elseif score >= 80 then ...`: Kondisi kedua (`85 >= 80`) adalah `true`. Blok `print("Good")` dieksekusi, dan sisa `elseif` atau `else` diabaikan.
- Contoh kedua dengan `temperature` dan `is_raining` menunjukkan penggunaan operator logika `and` dan `not` dalam kondisi `if`.

#### While Loop

- **Deskripsi:** Loop `while` mengeksekusi blok kode berulang kali selama kondisi yang diberikan bernilai _truthy_. Kondisi diperiksa _sebelum_ setiap iterasi. Jika kondisi awalnya `false`, blok kode tidak akan pernah dieksekusi.
- **Implementasi dalam Neovim:** Berguna untuk tugas yang perlu diulang selama kondisi tertentu terpenuhi, misalnya, memproses item dalam antrian hingga antrian kosong, atau menunggu suatu event.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (While statement): [https://www.lua.org/manual/5.1/manual.html\#2.4.5](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.4.5)
  - Programming in Lua, 1st ed. (While): [https://www.lua.org/pil/4.3.2.html](https://www.lua.org/pil/4.3.2.html)

**Contoh Kode:**

```lua
local i = 1
while i <= 5 do
    print("Iterasi while:", i)
    i = i + 1  -- Penting: jangan lupa memperbarui variabel kontrol loop!
end
-- Output:
-- Iterasi while: 1
-- Iterasi while: 2
-- Iterasi while: 3
-- Iterasi while: 4
-- Iterasi while: 5

local countdown = 3
while countdown > 0 do
    print("Countdown:", countdown)
    countdown = countdown - 1
end
print("Blast off!")
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya.

**Penjelasan Kode:**

- `local i = 1`: Inisialisasi variabel counter `i`.
- `while i <= 5 do ... end`: Loop akan berlanjut selama `i` kurang dari atau sama dengan `5`.
- `print("Iterasi while:", i)`: Mencetak nilai `i` saat ini.
- `i = i + 1`: Menaikkan nilai `i`. Jika ini tidak dilakukan, loop akan menjadi tak terbatas (infinite loop) karena kondisi `i <= 5` akan selalu `true`.
- Contoh `countdown` serupa, tetapi menghitung mundur.

#### Repeat-Until Loop

- **Deskripsi:** Loop `repeat ... until` mirip dengan loop `while`, tetapi dengan dua perbedaan utama:
  1.  Blok kode dieksekusi _setidaknya satu kali_ sebelum kondisi diperiksa.
  2.  Loop berlanjut selama kondisi bernilai _falsy_ dan berhenti ketika kondisi menjadi _truthy_. (Berlawanan dengan `while` yang berlanjut selama kondisi _truthy_).
  <!-- end list -->
  - Variabel lokal yang dideklarasikan di dalam blok `repeat...until` memiliki scope yang mencakup kondisi `until`.
- **Implementasi dalam Neovim:** Berguna ketika suatu aksi perlu dilakukan setidaknya sekali dan kemudian diulang berdasarkan hasil aksi tersebut, misalnya, meminta input pengguna hingga input valid diberikan.
- **Sumber Dokumentasi Lua:**
  - Lua 5.1 Reference Manual (Repeat statement): [https://www.lua.org/manual/5.1/manual.html\#2.4.5](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.4.5)
  - Programming in Lua, 1st ed. (Repeat): [https://www.lua.org/pil/4.3.2.html](https://www.lua.org/pil/4.3.2.html)

**Contoh Kode:**

```lua
local j = 1
repeat
    print("Iterasi repeat-until:", j)
    j = j + 1
until j > 5
-- Output:
-- Iterasi repeat-until: 1
-- Iterasi repeat-until: 2
-- Iterasi repeat-until: 3
-- Iterasi repeat-until: 4
-- Iterasi repeat-until: 5

local input
repeat
    -- Dalam implementasi nyata, Anda akan meminta input di sini
    -- Misalnya: io.write("Masukkan 'stop': ")
    -- input = io.read()
    -- print("Anda memasukkan: " .. input)
    input = "stop" -- Simulasi input untuk contoh ini
    print("Mencoba input:", input)
until input == "stop"
print("Loop repeat-until selesai.")
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya. Untuk contoh input interaktif, Anda bisa menghapus komentar pada bagian `io.write` dan `io.read` jika menjalankan di terminal Lua standar (mungkin tidak berfungsi seperti yang diharapkan langsung di `:lua` Neovim tanpa penanganan input khusus).

**Penjelasan Kode:**

- `local j = 1`: Inisialisasi variabel `j`.
- `repeat ... until j > 5`: Blok kode di dalam `repeat` dieksekusi. Kemudian kondisi `j > 5` diperiksa.
  - Iterasi 1: `j=1`. `print` dijalankan. `j` menjadi `2`. `2 > 5` adalah `false`. Loop berlanjut.
  - ...
  - Iterasi 5: `j=5`. `print` dijalankan. `j` menjadi `6`. `6 > 5` adalah `true`. Loop berhenti.
- Contoh `input` menunjukkan bagaimana loop ini dapat digunakan untuk mengulang hingga kondisi tertentu (input pengguna adalah "stop") terpenuhi.

#### For Loop

Lua memiliki dua jenis loop `for`: numerik dan generik.

1.  **Numeric For Loop (Loop For Numerik):**

    - **Deskripsi:** Digunakan untuk mengulang blok kode sejumlah tertentu kali. Loop ini menggunakan variabel kontrol yang secara otomatis diinisialisasi dan diinkrementasi (atau didekrementasi).
    - **Sintaks:** `for variabel = awal, akhir, langkah do ... end`
      - `variabel`: Variabel kontrol loop (bersifat lokal untuk loop). Nilainya tidak boleh diubah secara manual di dalam loop.
      - `awal`: Nilai awal variabel kontrol.
      - `akhir`: Batas akhir variabel kontrol. Loop berlanjut selama variabel belum melewati batas ini (tergantung `langkah`).
      - `langkah` (opsional): Nilai penambahan/pengurangan untuk variabel kontrol setiap iterasi. Defaultnya adalah `1`.
    - **Implementasi dalam Neovim:** Iterasi melalui rentang angka, misalnya, memproses baris dari nomor X hingga Y dalam buffer.
    - **Sumber Dokumentasi Lua:**
      - Lua 5.1 Reference Manual (Numeric For): [https://www.lua.org/manual/5.1/manual.html\#2.4.6](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.4.6)
      - Programming in Lua, 1st ed. (Numeric for): [https://www.lua.org/pil/4.3.4.html](https://www.lua.org/pil/4.3.4.html)

2.  **Generic For Loop (Loop For Generik):**

    - **Deskripsi:** Digunakan untuk melakukan iterasi atas koleksi nilai, seperti elemen dalam tabel. Loop ini bekerja dengan fungsi _iterator_. Fungsi iterator dipanggil pada setiap iterasi untuk menghasilkan nilai berikutnya dari koleksi.
    - **Sintaks:** `for var_1, ..., var_n in explist do ... end`
      - `explist` dievaluasi sekali. Hasilnya harus berupa tiga nilai: fungsi iterator, _state_ (keadaan), dan nilai awal untuk variabel kontrol pertama.
      - Lua menyediakan beberapa fungsi iterator bawaan, yang paling umum adalah:
        - `ipairs(t)`: Untuk iterasi atas elemen array dalam tabel `t` (indeks numerik berurutan mulai dari 1). Berhenti pada indeks `nil` pertama. Mengembalikan indeks dan nilai.
        - `pairs(t)`: Untuk iterasi atas semua elemen (pasangan kunci-nilai) dalam tabel `t`, termasuk bagian array dan bagian _hash_. Urutan iterasi tidak ditentukan untuk bagian _hash_. Mengembalikan kunci dan nilai.
    - **Implementasi dalam Neovim:** Sangat umum digunakan untuk mengiterasi item konfigurasi dalam tabel, hasil dari fungsi API Neovim (yang sering mengembalikan tabel), baris-baris dalam buffer, daftar plugin, dll.
    - **Sumber Dokumentasi Lua:**
      - Lua 5.1 Reference Manual (Generic For): [https://www.lua.org/manual/5.1/manual.html\#2.4.6](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%232.4.6)
      - Lua 5.1 Reference Manual (`ipairs`, `pairs`): [https://www.lua.org/manual/5.1/manual.html\#5.1](https://www.google.com/search?q=https://www.lua.org/manual/5.1/manual.html%235.1)
      - Programming in Lua, 1st ed. (Generic for): [https://www.lua.org/pil/4.3.5.html](https://www.lua.org/pil/4.3.5.html)
      - Programming in Lua, 1st ed. (Iterators and Generic for): [https://www.lua.org/pil/7.html](https://www.lua.org/pil/7.html)

**Contoh Kode:**

```lua
-- Numeric for loop
print("--- Numeric For Loop ---")
-- Dari 1 sampai 5, langkah default 1
for i = 1, 5 do
    print("Numeric i:", i)
end
-- Output: 1, 2, 3, 4, 5

-- Dari 10 sampai 1, langkah -2
for k = 10, 1, -2 do
    print("Numeric k:", k)
end
-- Output: 10, 8, 6, 4, 2

-- Variabel loop adalah lokal
-- print(i) -- Error, i tidak terlihat di sini jika di luar blok for


-- Generic for loop
print("--- Generic For Loop ---")
local fruits = {"apple", "banana", "orange", "grape"}

-- Menggunakan ipairs (untuk array-like tables)
print("Menggunakan ipairs:")
for index, fruit_name in ipairs(fruits) do
    print("Index:", index, "Fruit:", fruit_name)
end
-- Output:
-- Index: 1 Fruit: apple
-- Index: 2 Fruit: banana
-- Index: 3 Fruit: orange
-- Index: 4 Fruit: grape

local person_data = {name = "John Doe", age = 30, city = "Jakarta"}

-- Menggunakan pairs (untuk semua key-value pairs dalam tabel)
print("Menggunakan pairs:")
for key, value in pairs(person_data) do
    print("Key:", key, "Value:", value)
end
-- Output (urutan mungkin berbeda):
-- Key: name Value: John Doe
-- Key: age Value: 30
-- Key: city Value: Jakarta

-- Contoh ipairs berhenti pada nil
local mixed_table = {"a", "b", nil, "d"}
print("ipairs dengan nil di tengah:")
for idx, val in ipairs(mixed_table) do
    print(idx, val) -- Hanya akan mencetak "a" dan "b"
end
```

**Cara Menjalankan Kode:** Sama seperti contoh sebelumnya.

**Penjelasan Kode:**

- **Numeric For Loop:**
  - `for i = 1, 5 do ... end`: Variabel `i` akan mengambil nilai dari 1 hingga 5 (inklusif), dengan langkah 1 (default).
  - `for k = 10, 1, -2 do ... end`: Variabel `k` akan mulai dari 10, dan setiap iterasi nilainya dikurangi 2, hingga mencapai atau melewati 1. Jadi, nilainya akan menjadi 10, 8, 6, 4, 2.
  - Variabel kontrol (`i`, `k`) bersifat lokal untuk blok loop `for`.
- **Generic For Loop:**
  - `local fruits = {"apple", "banana", "orange", "grape"}`: Sebuah tabel yang berperan sebagai array.
  - `for index, fruit_name in ipairs(fruits) do ... end`: `ipairs(fruits)` adalah iterator yang mengembalikan indeks numerik dan nilai yang sesuai untuk setiap elemen dalam bagian array dari tabel `fruits`.
  - `local person_data = {name = "John Doe", ...}`: Sebuah tabel yang berperan seperti dictionary atau map.
  - `for key, value in pairs(person_data) do ... end`: `pairs(person_data)` adalah iterator yang mengembalikan pasangan kunci dan nilai untuk semua entri dalam tabel `person_data`. Urutan iterasi untuk `pairs` tidak dijamin untuk bagian non-array.
  - `local mixed_table = {"a", "b", nil, "d"}`: `ipairs` akan berhenti ketika menemukan elemen `nil` pertama dalam urutan numerik. Jadi, ia hanya akan mengiterasi "a" dan "b".

---

Dengan penguasaan operator dan struktur kontrol alur ini, Anda memiliki alat yang diperlukan untuk membangun logika yang kompleks dan dinamis dalam plugin Neovim Anda.

> - **[Ke Atas](#)**
> - **[Selanjutnya][1]**
> - **[Sebelumnya][2]**
> - **[Kurikulum][4]**

[1]: ../4-struktur-data-kompleks/README.md
[2]: ../2-variable/README.md
[3]: ../../README.md/#3-operator-dan-kontrol-flow
[4]: ../../../../../README.md
