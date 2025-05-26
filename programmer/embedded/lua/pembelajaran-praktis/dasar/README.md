## Roadmap Belajar Praktis Lua: Tingkat Dasar

### Pelajaran 1: Persiapan Lingkungan

1. **Install Lua**

   - Unduh Lua 5.4 dari situs resmi: [https://www.lua.org/download.html](https://www.lua.org/download.html)
   - Verifikasi instalasi dengan menjalankan REPL (Read–Eval–Print Loop):

     ```bash
     lua -v      -- menampilkan versi Lua
     lua         -- masuk ke REPL
     ```

2. **Istilah Spesifik**

   - **REPL**: lingkungan interaktif untuk mengetes kode sebaris demi sebaris.
   - **Chunk**: unit eksekusi di Lua (bisa file `.lua` atau input di REPL).

---

### Pelajaran 2: Hello World & Struktur Dasar

1. **Hello World**
   Buat file `hello.lua`:

   ```lua
   -- ini komentar satu baris
   print("Hello, Lua!")  -- print ke konsol
   ```

   Jalankan:

   ```bash
   lua hello.lua
   ```

2. **Istilah Spesifik**

   - **Statement**: unit kode yang dieksekusi (contoh: `print(...)`).
   - **Komentar**: `--` untuk satu baris, `--[[ ... ]]` untuk multiline.

---

### Pelajaran 3: Variabel & Tipe Data

1. **Variabel**

   ```lua
   local x = 10             -- variabel lokal
   y = "Lua"              -- variabel global
   ```

2. **Tipe Data**

   - `nil`: nilai kosong atau tidak terdefinisi
   - `boolean`: true/false
   - `number`: angka (float/integer)
   - `string`: teks
   - `table`: struktur data utama (array/dictionary)
   - `function`: fungsi sebagai first-class value

3. **Praktik**

   - Coba cetak `type(x)`, `type(nil)`, `type(print)` di REPL.

---

### Pelajaran 4: Control Flow

### 1. Struktur If-Else

**Fungsi utama**: Mengambil keputusan tunggal berdasarkan kondisi, lalu mengeksekusi satu cabang kode saja.

```lua
local n = 0  -- coba ubah n ke nilai lain untuk mengamati perbedaan
if n > 5 then
  print("positif")
elseif n == 0 then
  print("nol")
else
  print("negatif")
end
```

### Alur eksekusi

1. Evaluasi ekspresi `n > 5`.

   - Jika **true**, jalankan blok `print("positif")`, lalu **lewat seluruh** blok `elseif`/`else`.

2. Jika tidak, lanjut cek `n == 0`.

   - Jika **true**, jalankan `print("nol")`, lalu keluar dari struktur.

3. Jika semua kondisi di atas **false**, jalankan blok `else` (`print("negatif")`).

### Ciri khas & penggunaan

- **One-time decision**: Evaluasi tepat **sekali saja** pada titik itu.
- **Cabang tunggal**: Hanya satu jalur kode yang akan dieksekusi.
- **Cocok** untuk:

  - Menentukan kategori/dispath berdasarkan nilai variabel (misal: level skor, status, flag boolean).
  - Mengecek kesalahan (error handling) sebelum melanjutkan ke proses utama.

---

### 2. Loop (Perulangan)

**Fungsi utama**: Menjalankan kembali blok kode **berulang kali** selama atau sampai kondisi tertentu terpenuhi.

#### A. `while … do … end`

```lua
local a = 1 -- variabel kontrol
while a < 5 do -- awal looping

  ---[[ dua baris ini disebut (Satu Iterasi)
  print(a, "ulangi")
  a = a + 10
  --]]

end -- akhir dari kode looping
```

- Kode diatas menghasilkan satu input seperti berikut:
  > 1 ulangi
- Jika ingin mengulang hingga lima baris output maka buang angka kosong `0`

Ketika kita menduplikasi menjadi dua iterasi maka akan menghasilkan perulangan ganda seperti berikut:

```lua
local a = 1
while a < 5 do
	print(a, "ulangi")
	a = a + 1
	print(a, "selsai")
	a = a + 1
end
```

- Output yang dihasilkan:

```
1       ulangi
2       selsai
3       ulangi
4       selsai
```

## _Perhatian Penting!_

> _Perhatikan bahwa ketika variabel `a` pada baris dalam blok berikut diinisialisasi sebagai angka semisal `5` atau angka yang lain seperti contoh `a = 1 + 10` serta nilai dalam kondisi pengecekan diatur sebagai nilai lebih besar pada variabel utama maka akan menghasilkan perulangan yang tidak akan pernah berhenti. Seperti contoh kode berikut **:**_
>
> ```lua
> local a = 1
> while a <= 3 do
> 	print(a, "ulangi")
> 	a = 1 + 1
> 	print(a, "selesai")
> end
> ```
>
> _Jadi deklarasi yang tepat adalah ditulils sebagai `a = a + 10` yang artinya variabel dicek kemudian diperbarui sebagai penambahan sekali mana semacam ini minimal akan di eksekusi sekali._
>
> ##### _Sebagai contoh penulisan yang benar seperti berikut:_
>
> ```lua
> local a = 1
> while a <= 3 do
> 	print(a, "ulangi")
> 	a = a + 1
> 	print(a, "selesai")
> end
> ```
>
> _Pada contoh diatas kita mendapatkan bahwa perulangan tanpa henti sudah tidak bisa dilakukan. Tetapi berbeda ketika pembaruan diinisialisasi sebagai `- Min` atau **Pengurangan** `a = a - 1` Maka ini juga akan menghasilkan **Perulangan Tanpa Batas** dengan nilai pengurangan yang akan terus menerus_
>
> ##### _Sebagai contoh penulisan yang **salah** seperti berikut:_
>
> ```lua
> local a = 1
> while a <= 3 do
> 	print(a, "ulangi")
> 	a = a - 1
> 	print(a, "selesai")
> end
> ```
>
> ##### _Materi mengenai ini sangat penting untuk diperhatikan demi menghidari **KESALAHAN FATAL!**. Pada intinya, buatlah untuk **mengarah pada satu tujuan dan jangan sampai membuat logika yang membingungkan!.**_

#

### Note:

- **Pre-test loop**: Kondisi `i <= 3` **dicek sebelum** setiap iterasi.
- **Berlaku 0–∞ kali**:

  - Jika kondisi awal sudah **false**, blok **tidak pernah** dijalankan.
  - Iterasi berlanjut selagi kondisi tetap `true`.

- **Use case**:

  - Ketika jumlah iterasi **tergantung** hasil perhitungan atau input yang bisa berubah-ubah.
  - Contoh: baca baris file sampai akhir, tunggu sinyal masuk, dsb.

---

#### B. `repeat … until …`

```lua
local i = 1
repeat
  print(i)
  i = i + 1
until i > 3
```

- **Post-test loop**: Blok kode **dijalankan dahulu sekali**, baru kondisi `i > 3` dicek diakhir.
- **Minimal 1 kali eksekusi**:

  - Meski kondisi sudah terpenuhi sejak awal, loop tetap jalan sekali.

- **Use case**:

  - Saat Anda **harus** mengeksekusi blok kode minimal sekali (misal: tampilkan menu, baca input, lalu cek apakah akan diulang).

---

#### C. `for start, limit, step do … end` (numeric for)

```lua
for i = 1, 5, 2 do  -- nilai i: 1, 3, 5
  print(i)
end
```

- **[Deterministik](https://github.com/ameerkulal/public/tree/main/programmer/embedded/lua/deterministik "public/tree/main/programmer/embedded/lua/deterministik")**:

  - `i` dimulai dari `start` (1), hingga melewati `limit` (5) dengan kenaikan `step` (2).
  - Jika step tidak dispesifikkan, default `1`.

- **Local scope**: Variabel `i` **hanya berlaku** di dalam blok `for`.
- **Jumlah iterasi pasti**: Diketahui sejak awal (disebut rentang `(limit - start) / step + 1`).
- **Use case**:

  - Melakukan perulangan sejumlah yang **sudah diketahui** (misal: proses setiap elemen array, hitung hingga n).

---

## 3. Perbandingan Ringkas

| Aspek                | If-Else                 | `while`                | `repeat…until`          | `for = , ,`          |
| -------------------- | ----------------------- | ---------------------- | ----------------------- | -------------------- |
| **Tujuan**           | Pilihan satu-jalur      | Ulang-lagi \[pre-test] | Ulang-lagi \[post-test] | Ulang-lagi terukur   |
| **Kondisi dicek**    | Sekali sebelum eksekusi | Sebelum tiap iterasi   | Setelah tiap iterasi    | Sebelum tiap iterasi |
| **Minimal eksekusi** | 0 (bila semua false)    | 0                      | 1                       | 0 (rentang kosong)   |
| **Jumlah iterasi**   | 1 x (branching)         | Dinamis (tak pasti)    | Dinamis (tak pasti)     | Deterministik        |
| **Variabel kontrol** | —                       | Eksternal              | Eksternal               | Lokal di dalam loop  |
| **Kapan digunakan**  | Menentukan jalur kode   | Perulangan tak pasti   | Pastikan minimal satu   | Perulangan pasti n   |

---

### Kapan pakai yang mana?

- **If-Else**: Untuk **mengambil keputusan** satu kali berdasarkan nilai/kondisi.
- **While**: Untuk perulangan **selama kondisi** masih terpenuhi, tanpa jaminan pernah dieksekusi.
- **Repeat…Until**: Untuk perulangan yang **harus** dijalankan minimal sekali lalu dicek kondisi berhenti.
- **For numeric**: Untuk perulangan dengan **jumlah iterasi yang sudah diketahui** di awal.

---

**Istilah Spesifik**

- **Branching**: percabangan if-elseif-else
- **Iteration**: pengulangan via loop
- **`nil` sebagai falsey**: only `false` dan `nil` dianggap false

##### Semoga penjelasan ini memberi gambaran jelas tentang perbedaan alur kontrol antara **If-Else** dan berbagai jenis **Loop** di Lua. Terus eksplorasi dan praktikkan setiap struktur untuk menguasai kapan harus memilih salah satunya!

#

### Pelajaran 5: Fungsi & Closure

1.  **Definisi Fungsi**

    ```lua
    function tambah(a, b)
      return a + b
    end
    print(tambah(2,3))  -- 5
    ```

2.  **Anonymous Function & Variadic**

    Dalam Lua, **Variadic** merujuk pada fungsi yang dapat menerima jumlah argumen yang bervariasi. Ini memungkinkan fungsi untuk menangani input dengan jumlah argumen yang tidak tetap.
    Di Lua, fungsi variadic didefinisikan dengan menggunakan tanda titik tiga `(...)` sebagai parameter terakhir dalam definisi fungsi.
    Contohnya:

    ```lua
    function contohVariadic(a, ...)
        print(a)
        for i, v in ipairs({...}) do
            print(v)
        end
    end

    contohVariadic(1, 2, 3, 4, 5)
    ```

    Pada contoh diatas, `a` akan bernilai `1,` dan `...` akan menangkap argumen `2, 3, 4,` dan `5`. Kemudian, kita menggunakan `{...}` untuk mengakses argumen-argumen tersebut sebagai tabel.

    **Contoh lainnya:**

    ```lua
    local f = function(...)
      local args = {...}
      print(#args)     -- jumlah argumen
    end
    f(1,2,3)          -- 3
    ```

    **Penjelasan:**

    - **`local f = function(...)`:**

      Ini mendefinisikan sebuah fungsi anonim **(anonymous function)** dan menyimpannya dalam variabel `lokal f`.

    - Tanda `...` dalam parameter fungsi menunjukkan bahwa fungsi ini adalah variadic, artinya fungsi ini dapat menerima jumlah argumen yang bervariasi.

    - **`local args = {...}`:**

      Di dalam fungsi, `{...}` digunakan untuk mengakses semua argumen yang diteruskan ke fungsi dan menyimpannya dalam sebuah tabel **(table)**.

    - Tabel ini kemudian disimpan dalam variabel `local args`.

    - **`print(#args)`:**

      `#args` digunakan untuk mendapatkan jumlah elemen dalam tabel args.

    - Operator `#` dalam Lua digunakan untuk mendapatkan panjang **(length)** dari sebuah string atau tabel.

    - Dalam konteks tabel, `#` mengembalikan indeks dari elemen terakhir dalam tabel yang memiliki indeks numerik berurutan dimulai dari `1`

    - **`f(1, 2, 3)`:**

      Ini memanggil fungsi `f()` dengan tiga argumen: `1, 2, dan 3.`

      **Eksekusi:**

    - Ketika `f(1, 2, 3)` dipanggil, argumen `1, 2,` dan `3` ditangkap oleh `...` dalam definisi fungsi.

    - Argumen-argumen ini kemudian disimpan dalam tabel args sebagai `{1, 2, 3}`.

    - Ketika `print(#args)` dijalankan,`#args` mengembalikan `3` karena ada tiga elemen dalam tabel `args`.

    - Oleh karena itu, output dari kode ini akan menjadi `3`, yang merupakan jumlah argumen yang diteruskan ke fungsi `f()`

    - Dengan demikian, kode tersebut mendemonstrasikan cara menggunakan fungsi variadic di Lua untuk menangkap dan menghitung jumlah argumen yang diteruskan ke sebuah fungsi.

    > Variadic sangat berguna ketika kita tidak tahu pasti berapa banyak argumen yang akan diterima oleh sebuah fungsi. Contoh nyata penggunaannya adalah dalam fungsi **`print()`** pada contoh pertama bawaan Lua, yang dapat menerima sejumlah argumen dan mencetaknya semua, contoh kedua seperti fungsi **`f()`** yang sudah kita bahas sebelumnya

3.  **Closure**

    ```lua
    function makeCounter()
      local count = 0
      return function()
        count = count + 1
        return count
      end
    end
    c = makeCounter()
    print(c())  -- 1
    print(c())  -- 2
    ```

4.  **Istilah Spesifik**

    - **First-class function**: fungsi bisa disimpan variabel, dilewat ke fungsi lain, dll.
    - **Closure**: fungsi yang "mengingat" lingkungan (upvalue) tempat ia dibuat.

---

> Setiap pelajaran dilengkapi contoh kode praktis dan istilah penting. Coba jalankan sendiri, modifikasi, dan catat pertanyaan apa pun yang muncul!

# Kode Saya

```lua
local i = 0
repeat
	print(i)
	i = i + 1
until i > 5

print("-------")

local i = 0
while i <= 5 do
	print(i)
	i = i + 1
end

print("-------")

for i = 1, 10, 4 do
	print(i)
end

print("-------")

function tambah(a, b)
	return a + b
end
print(tambah(2, 3))

print("-------")

function variadic(a, ...)
	print(a)
	for i, v in ipairs({ ... }) do
		print(v)
	end
end
variadic(1, 2, tambah(2, 3), 4.4, false, "Oke Goole")

print("-------")

local f = function(...)
	local args = { ... }
	print(#args)
end
f(3, 2, 1, 0)

print("-------")

function makeCounter()
	local count = 0
	return function()
		count = count + 1
		return count
	end
end

c = makeCounter()

print(c(), c(), c(), c(), c())
print(c())
print(c())
print(c())
print(c())
print(c())

------- Output:

-- 1       2       3       4       5
-- 6
-- 7
-- 8
-- 9
-- 10
```
