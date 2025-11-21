# **[Bagian 3: Function Types dan Styles][0]**

Di sini kita akan melihat bahwa function bukan hanya sekadar blok kode bernama. Mereka bisa tidak bernama (anonim), bisa berinteraksi satu sama lain (higher-order), dan bahkan bisa memanggil diri mereka sendiri (rekursif).

**Daftar Isi Bagian 3:**

- [Anonymous Functions (Fungsi Anonim)](#anonymous-functions-fungsi-anonimous)
- [Higher-Order Functions (Fungsi Tingkat Tinggi)](#higher-order-functions-fungsi-tingkat-tinggi)
- [Recursive Functions (Fungsi Rekursif)](#recursive-functions-fungsi-rekursif)

---

### Anonymous Functions (Fungsi Anonim)

Sebuah _anonymous function_ adalah function yang didefinisikan tanpa nama. Di Lua, ini sering disebut sebagai _function expression_. Karena function adalah nilai "first-class", Anda bisa membuatnya saat itu juga (inline) dan menggunakannya di mana saja nilai lain bisa digunakan.

- **Sintaks:**
  Bentuk dasarnya adalah keyword `function` diikuti oleh parameter dan `end`, tanpa ada nama di antaranya.

  ```lua
  function (parameter1, parameter2)
      -- isi function
  end
  ```

- **Konsep dan Penggunaan:**
  Function anonim sangat berguna dalam beberapa skenario:

  1.  **Function sebagai Argumen (Inline Functions / Lambda-style):**
      Penggunaan paling umum adalah melewatkan function secara langsung sebagai argumen ke _higher-order function_ lain. Ini membuat kode lebih ringkas karena Anda tidak perlu mendefinisikan function terpisah yang hanya akan digunakan satu kali.

      ```lua
      local angka = {5, 10, 2, 8}

      -- table.sort adalah higher-order function.
      -- Argumen keduanya adalah function pembanding opsional.
      -- Kita berikan sebuah function anonim secara langsung.
      table.sort(angka, function(a, b)
                            return a > b -- Urutkan secara descending (besar ke kecil)
                        end)

      -- Cetak hasilnya
      for i, v in ipairs(angka) do
          print(v)
      end
      -- Output:
      -- 10
      -- 8
      -- 5
      -- 2
      ```

      Istilah _Lambda-style_ sering digunakan untuk merujuk pada function kecil dan anonim seperti ini, yang terinspirasi dari kalkulus lambda.

  2.  **Menyimpan dalam Variabel:**
      Ini adalah cara mendefinisikan function yang sudah kita lihat. Secara teknis, ini adalah membuat function anonim dan langsung menugaskannya ke sebuah variabel.

      ```lua
      local sapa = function(nama)
                       return "Halo, " .. nama
                   end
      print(sapa("Alex")) -- Output: Halo, Alex
      ```

  3.  **Menyimpan dalam Table:**
      Function anonim dapat ditempatkan langsung di dalam sebuah table, seringkali untuk membuat "method" atau sekumpulan function terkait.

      ```lua
      local kalkulator = {
          tambah = function(a, b) return a + b end,
          kurang = function(a, b) return a - b end,
          -- Bisa ditulis dalam beberapa baris juga
          kali = function(a, b)
                     return a * b
                 end
      }

      print(kalkulator.tambah(5, 3)) -- Output: 8
      print(kalkulator.kali(5, 3)) -- Output: 15
      ```

---

### Higher-Order Functions (Fungsi Tingkat Tinggi)

Sebuah _higher-order function_ (HOF) adalah function yang beroperasi pada function lain. Ini bisa berarti ia menerima function sebagai argumen, atau mengembalikan function sebagai hasilnya. Konsep ini adalah inti dari paradigma pemrograman fungsional dan membuat Lua sangat powerful.

- **Functions yang Menerima Functions (Callback Patterns):**
  Ketika Anda melewatkan sebuah function sebagai argumen, function tersebut sering disebut _callback_. Function penerima akan "memanggil kembali" (call back) function yang Anda berikan pada waktu yang tepat. Contoh `table.sort` di atas adalah salah satu bentuknya.

  - **Contoh HOF `forEach`:**
    Mari kita buat HOF kita sendiri yang menerapkan sebuah aksi pada setiap elemen table.

    ```lua
    -- HOF yang menerima table dan sebuah function 'aksi'
    function forEach(myTable, aksi)
        assert(type(aksi) == "function", "Aksi harus berupa function")
        for i, v in ipairs(myTable) do
            aksi(v, i) -- Memanggil kembali function 'aksi' dengan nilai dan indeks
        end
    end

    local buah = {"Apel", "Jeruk", "Mangga"}

    -- Menggunakan forEach dengan function anonim sebagai callback
    forEach(buah, function(item, index)
                      print(index .. ": " .. item)
                  end)
    -- Output:
    -- 1: Apel
    -- 2: Jeruk
    -- 3: Mangga
    ```

- **Functions yang Mengembalikan Functions (Factory Functions):**
  HOF juga bisa "memproduksi" function baru. Ini sering digunakan untuk membuat function yang dispesialisasi berdasarkan parameter awal.

  - **Contoh `buatPengali`:**

    ```lua
    -- Ini adalah function "pabrik" atau HOF yang mengembalikan function
    function buatPengali(faktorPengali)
        -- Function anonim di bawah ini menjadi sebuah closure,
        -- "mengingat" nilai 'faktorPengali'.
        return function(angka)
                   return angka * faktorPengali
               end
    end

    local kaliDua = buatPengali(2) -- Membuat function yang akan selalu mengalikan dengan 2
    local kaliSepuluh = buatPengali(10) -- Membuat function yang akan selalu mengalikan dengan 10

    print(kaliDua(5))      -- Output: 10
    print(kaliSepuluh(7))  -- Output: 70
    ```

- **Function Composition:**
  Ini adalah teknik membuat function baru dengan menggabungkan dua atau lebih function, di mana output dari satu function menjadi input untuk function berikutnya.

  - **Contoh HOF `compose`:**

    ```lua
    function compose(f, g)
        -- Mengembalikan function baru yang menerapkan g, lalu f
        return function(x)
                   return f(g(x))
               end
    end

    local function tambahSatu(x) return x + 1 end
    local function kaliDua(x) return x * 2 end

    -- h(x) = kaliDua(tambahSatu(x))
    local tambahSatuLaluKaliDua = compose(kaliDua, tambahSatu)

    print(tambahSatuLaluKaliDua(5)) -- sama dengan kaliDua(tambahSatu(5)) -> kaliDua(6) -> 12
    ```

---

### Recursive Functions (Fungsi Rekursif)

Sebuah function dikatakan rekursif jika ia memanggil dirinya sendiri, baik secara langsung maupun tidak langsung. Rekursi adalah cara yang elegan untuk menyelesaikan masalah yang dapat dipecah menjadi sub-masalah yang lebih kecil dari jenis yang sama.

- **Struktur Dasar Rekursi:**
  Function rekursif yang benar harus memiliki dua bagian:

  1.  **Base Case (Kasus Dasar):** Sebuah kondisi yang menghentikan rekursi. Tanpa ini, function akan memanggil dirinya sendiri tanpa henti (infinite recursion) dan menyebabkan _stack overflow_.
  2.  **Recursive Step (Langkah Rekursif):** Bagian di mana function memanggil dirinya sendiri dengan argumen yang lebih "mendekati" base case.

- **Direct Recursion (Rekursi Langsung):**
  Function memanggil dirinya sendiri secara langsung.

  - **Contoh: Faktorial**

    ```lua
    function faktorial(n)
        -- Base Case: jika n adalah 0, berhenti.
        if n == 0 then
            return 1
        -- Recursive Step: kalikan n dengan faktorial dari n-1.
        else
            return n * faktorial(n - 1)
        end
    end

    print(faktorial(5)) -- 5 * 4 * 3 * 2 * 1 = 120
    ```

- **Tail Recursion (Tail Call Optimization / TCO):**
  Ini adalah konsep yang sangat penting di Lua. Sebuah _tail call_ adalah ketika sebuah function memanggil function lain sebagai aksi terakhirnya, dan tidak ada lagi yang perlu dilakukan setelah panggilan itu kembali. Lua mengenali panggilan seperti ini dan melakukan _Tail Call Optimization_ (TCO).
  Alih-alih membuat stack frame baru, Lua akan menggunakan kembali stack frame yang ada. Artinya, Anda bisa melakukan rekursi "tak terbatas" tanpa khawatir kehabisan memori stack, asalkan panggilannya adalah _tail call_.

  - **Contoh: Faktorial dengan Tail Recursion**
    `faktorial` di atas _bukan_ tail-recursive karena setelah `faktorial(n-1)` kembali, masih ada operasi perkalian (`n * ...`) yang harus dilakukan.
    Untuk membuatnya tail-recursive, kita gunakan _accumulator_.

    ```lua
    -- 'acc' (accumulator) membawa hasil sementara
    function faktorialTail(n, acc)
        acc = acc or 1 -- Nilai awal untuk accumulator

        -- Base Case
        if n == 0 then
            return acc
        -- Recursive Step (ini adalah tail call)
        else
            return faktorialTail(n - 1, n * acc)
        end
    end

    print(faktorialTail(5)) -- Output: 120
    -- Bahkan untuk angka besar, ini tidak akan stack overflow:
    -- print(faktorialTail(100000)) -- akan berjalan (walaupun hasilnya tak terhingga)
    ```

  Dalam `faktorialTail`, pemanggilan rekursif adalah hal terakhir yang dilakukan. Tidak ada operasi lain setelahnya.

- **Mutual Recursion (Rekursi Mutual):**
  Terjadi ketika dua atau lebih function saling memanggil satu sama lain. Seperti yang dibahas di 1.3, sintaks `local function` sangat penting di sini.

  ```lua
  local function is_even(n); -- Deklarasi forward (opsional tapi praktik baik)
  local function is_odd(n);

  function is_even(n)
      if n == 0 then
          return true
      else
          return is_odd(n - 1)
      end
  end

  function is_odd(n)
      if n == 0 then
          return false
      else
          return is_even(n - 1)
      end
  end

  print("Apakah 4 genap?", is_even(4)) -- Output: Apakah 4 genap? true
  print("Apakah 5 genap?", is_even(5)) -- Output: Apakah 5 genap? false
  ```

- **Memoization (untuk Optimasi):**
  Memoization adalah teknik optimasi untuk mempercepat function dengan menyimpan hasil komputasi yang mahal ke dalam _cache_ (biasanya sebuah table) dan menggunakannya kembali ketika input yang sama muncul lagi.

  - **Contoh: Fibonacci dengan Memoization**
    Perhitungan Fibonacci secara rekursif sangat tidak efisien karena banyak sub-masalah yang dihitung berulang kali.

    ```lua
    -- Cache untuk menyimpan hasil yang sudah dihitung
    local memo = {}

    function fib(n)
        -- Cek cache terlebih dahulu
        if memo[n] then
            return memo[n]
        end

        -- Base cases
        if n < 2 then
            return n
        end

        -- Hitung, simpan ke cache, lalu kembalikan
        local hasil = fib(n - 1) + fib(n - 2)
        memo[n] = hasil
        return hasil
    end

    print("Fibonacci ke-40:", fib(40)) -- Sangat cepat dengan memoization
    ```

---

**Sumber Referensi untuk Bagian 3:**

1.  Programming in Lua (4th Edition) - [6. Higher-Order Functions](https://www.lua.org/pil/6.html)
2.  Programming in Lua (4th Edition) - [6.3. Proper Tail Recursion](https://www.lua.org/pil/6.3.html)

Kita sudah menyelesaikan Bagian 3, yang mencakup berbagai gaya dan jenis function yang membuat Lua menjadi bahasa yang sangat dinamis. Berikutnya, kita akan menyelami salah satu konsep paling kuat dan terkadang membingungkan di Lua, yaitu **Bagian 4: Closures dan Upvalues**. Kita akan membahasnya secara lebih detail daripada di bagian pengantar.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

<!----------------------------------------------------->

[0]: ../README.md#bagian-3-function-types-dan-styles
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
