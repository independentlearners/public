# **[Bagian 1: Dasar-Dasar Function][1]**

Bagian ini adalah fondasi penting. Function (fungsi) adalah blok bangunan fundamental dalam hampir semua bahasa pemrograman, termasuk Lua. Memahami fungsi secara mendalam akan membuka jalan untuk memahami konsep-konsep yang lebih kompleks.

### 1.1 Pengenalan Function

#### **Apa itu function dan mengapa penting**

- **Definisi Function (Fungsi):**
  Dalam pemrograman, **function** (sering juga disebut prosedur, subroutine, atau method dalam konteks lain) adalah kumpulan pernyataan (statement) yang dikelompokkan bersama untuk melakukan tugas tertentu. Bayangkan function sebagai resep: Anda memberinya beberapa bahan (input/parameter), ia melakukan serangkaian langkah (proses di dalam function), dan mungkin menghasilkan hidangan jadi (output/return value).

- **Terminologi Penting:**

  - **Statement (Pernyataan):** Instruksi tunggal yang dapat dieksekusi oleh interpreter Lua. Contoh: `x = 10`, `print("Halo")`.
  - **Blok Kode (Code Block):** Sekumpulan pernyataan. Dalam Lua, blok kode seringkali dibatasi oleh keyword seperti `function`...`end`, `if`...`end`, `for`...`end`.

- **Mengapa Function Penting:**
  1.  **Reusabilitas (Reusable):** Sekali Anda menulis function, Anda dapat menggunakannya berkali-kali di berbagai bagian program Anda tanpa harus menulis ulang kode yang sama. Ini menghemat waktu dan mengurangi potensi kesalahan.
  2.  **Modularitas (Modularity):** Memecah program besar menjadi function-function yang lebih kecil membuat kode lebih terorganisir, lebih mudah dibaca, dan lebih mudah dikelola. Setiap function memiliki tanggung jawab spesifik.
  3.  **Abstraksi (Abstraction):** Anda dapat menggunakan function tanpa perlu tahu detail implementasi internalnya. Anda hanya perlu tahu apa yang dilakukan function tersebut, input apa yang dibutuhkan, dan output apa yang dihasilkan. Contohnya, Anda menggunakan `print()` tanpa perlu tahu bagaimana Lua secara internal mengirim teks ke layar.
  4.  **Pengelolaan Kompleksitas (Complexity Management):** Dengan memecah masalah kompleks menjadi sub-masalah yang lebih kecil dan menyelesaikannya dengan function, program secara keseluruhan menjadi lebih mudah dipahami dan dikembangkan.

#### **Sintaks dasar function di Lua**

Ada dua cara utama untuk mendefinisikan function di Lua:

1.  **Statement Deklarasi Function:** Ini adalah cara yang paling umum.

    - **Sintaks Dasar:**
      ```lua
      function nama_function (parameter1, parameter2, ...)
          -- isi function (blok kode)
          -- bisa ada return value
      end
      ```
    - **Penjelasan Sintaks:**

      - `function`: Keyword Lua yang menandakan dimulainya definisi sebuah function.
      - `nama_function`: Nama yang Anda berikan untuk function tersebut. Aturan penamaan variabel berlaku di sini (biasanya dimulai dengan huruf atau underscore, diikuti huruf, angka, atau underscore).
      - `(parameter1, parameter2, ...)`: Daftar parameter (opsional). Parameter adalah variabel lokal khusus untuk function yang akan menerima nilai ketika function dipanggil. Jika tidak ada parameter, Anda tetap menggunakan tanda kurung `()`. Tanda `...` menunjukkan bahwa function dapat menerima jumlah argumen variabel (akan dibahas nanti).
      - `-- isi function (blok kode)`: Bagian ini adalah tempat Anda menulis logika atau instruksi yang akan dijalankan ketika function dipanggil.
      - `end`: Keyword Lua yang menandakan berakhirnya definisi function.

    - **Contoh Kode:**

      ```lua
      -- Mendefinisikan function bernama 'sapa' dengan satu parameter 'nama'
      function sapa(nama)
        local pesan = "Halo, " .. nama .. "!" -- '..' adalah operator konkatenasi string
        print(pesan) -- 'print' adalah function bawaan Lua untuk menampilkan output
      end

      -- Memanggil function 'sapa' dengan argumen "Lua Programmer"
      sapa("Lua Programmer") -- Output: Halo, Lua Programmer!
      sapa("Dunia")        -- Output: Halo, Dunia!
      ```

    - **Penjelasan Kode Contoh:**
      - `function sapa(nama)`: Kita mendefinisikan function bernama `sapa` yang menerima satu parameter `nama`.
      - `local pesan = "Halo, " .. nama .. "!"`: Di dalam function, kita membuat variabel lokal `pesan`. Nilainya adalah hasil penggabungan string "Halo, ", nilai dari parameter `nama`, dan "!".
      - `print(pesan)`: Kita memanggil function bawaan `print` untuk menampilkan isi variabel `pesan`.
      - `sapa("Lua Programmer")`: Ini adalah _pemanggilan function_ (function call). Kita memanggil function `sapa` dan memberikan nilai string `"Lua Programmer"` sebagai _argumen_ untuk parameter `nama`.
      - **Parameter vs. Argumen:**
        - **Parameter:** Variabel yang dideklarasikan dalam definisi function (misalnya `nama` dalam `function sapa(nama)`).
        - **Argumen:** Nilai aktual yang dilewatkan ke function saat function tersebut dipanggil (misalnya `"Lua Programmer"` dalam `sapa("Lua Programmer")`).

2.  **Function Expression (Anonymous Function) yang Disimpan ke Variabel:** Function di Lua adalah "first-class citizen" (akan dijelaskan di bawah), yang berarti mereka bisa diperlakukan seperti nilai lainnya (angka, string, dll.), termasuk disimpan dalam variabel.

    - **Sintaks Dasar:**
      ```lua
      local nama_variable = function (parameter1, parameter2, ...)
                              -- isi function
                              -- bisa ada return value
                            end
      ```
    - **Penjelasan Sintaks:**

      - `local nama_variable =`: Kita mendeklarasikan variabel (biasanya lokal) dan langsung mengisinya dengan sebuah definisi function.
      - `function (parameter1, ...) ... end`: Ini adalah _function expression_. Perhatikan tidak ada nama function setelah keyword `function` (karena namanya adalah nama variabelnya). Function seperti ini sering disebut _anonymous function_ atau fungsi anonim.

    - **Contoh Kode:**

      ```lua
      -- Mendefinisikan function anonim dan menyimpannya di variabel 'tambah'
      local tambah = function(a, b)
                       local hasil = a + b
                       return hasil -- 'return' mengirimkan nilai kembali ke pemanggil
                     end

      -- Memanggil function melalui variabel
      local angka1 = 5
      local angka2 = 3
      local jumlah = tambah(angka1, angka2) -- Memanggil function 'tambah'
      print(angka1 .. " + " .. angka2 .. " = " .. jumlah) -- Output: 5 + 3 = 8
      ```

    - **Penjelasan Kode Contoh:**
      - `local tambah = function(a, b)`: Sebuah function anonim yang menerima dua parameter `a` dan `b` didefinisikan dan nilainya (yaitu function itu sendiri) disimpan dalam variabel lokal `tambah`.
      - `local hasil = a + b`: Di dalam function, `a` dan `b` dijumlahkan, hasilnya disimpan di variabel lokal `hasil`.
      - `return hasil`: Function ini mengembalikan nilai dari variabel `hasil`. Keyword `return` digunakan untuk mengakhiri eksekusi function dan (opsional) mengirimkan satu atau lebih nilai kembali ke kode yang memanggilnya.
      - `local jumlah = tambah(angka1, angka2)`: Function `tambah` dipanggil dengan argumen `angka1` (bernilai 5) dan `angka2` (bernilai 3). Nilai yang dikembalikan oleh `tambah` (yaitu 8) disimpan dalam variabel `jumlah`.

    Kedua cara definisi di atas hampir setara. Bentuk `function nama_function() ... end` sebenarnya adalah "syntactic sugar" (cara penulisan yang lebih manis/mudah) untuk `nama_function = function() ... end`.

#### **Perbedaan function dengan statement lainnya**

- **Statement:** Sebuah instruksi tunggal yang melakukan aksi. Contoh:

  - `x = 10` (assignment statement)
  - `print("Hello")` (pemanggilan function, yang juga merupakan statement)
  - `if x > 5 then print("Besar") end` (control structure statement)
    Statement dieksekusi secara berurutan (kecuali dikendalikan oleh control flow seperti `if` atau loop).

- **Function Definition:** Bukan instruksi yang langsung dieksekusi untuk melakukan tugas utama function tersebut. Mendefinisikan function berarti Anda _menciptakan_ sebuah resep atau cetak biru. Kode di dalam function _tidak berjalan_ saat definisi dibuat.

- **Function Call:** Ini adalah statement yang _mengeksekusi_ kode di dalam function yang telah didefinisikan sebelumnya. Ketika function dipanggil, alur program melompat ke awal function, menjalankan kode di dalamnya, dan kemudian (biasanya) kembali ke titik setelah pemanggilan.

**Singkatnya:**

- Statement adalah aksi.
- Function definition adalah pembuatan cetak biru untuk sekumpulan aksi.
- Function call adalah perintah untuk melakukan aksi berdasarkan cetak biru tersebut.

#### **Function sebagai first-class citizen**

Ini adalah konsep yang sangat kuat di Lua dan bahasa pemrograman fungsional lainnya. Artinya, **function diperlakukan sama seperti tipe data lainnya** (seperti angka, string, atau table). Ini membawa beberapa implikasi penting:

1.  **Bisa disimpan dalam variabel:**
    Seperti yang sudah kita lihat pada contoh "Function Expression".

    ```lua
    local cetakPesan = function(pesan)
                         print("Pesan Anda: " .. pesan)
                       end
    cetakPesan("Belajar Lua!") -- Memanggil function melalui variabel
    ```

2.  **Bisa dilewatkan sebagai argumen ke function lain (Higher-Order Functions):**
    Function yang menerima function lain sebagai argumen atau mengembalikan function sebagai hasilnya disebut _higher-order function_.

    ```lua
    function jalankanDuaKali(fn, argumen)
      fn(argumen) -- Panggilan pertama
      fn(argumen) -- Panggilan kedua
    end

    function sapaPagi(nama)
      print("Selamat pagi, " .. nama .. "!")
    end

    jalankanDuaKali(sapaPagi, "Budi")
    -- Output:
    -- Selamat pagi, Budi!
    -- Selamat pagi, Budi!
    ```

    - **Penjelasan Kode:**
      - `jalankanDuaKali` adalah higher-order function. Ia menerima `fn` (yang diharapkan adalah sebuah function) dan `argumen`.
      - `sapaPagi` adalah function biasa.
      - `jalankanDuaKali(sapaPagi, "Budi")`: Kita memanggil `jalankanDuaKali`, melewatkan function `sapaPagi` sebagai argumen pertama dan string `"Budi"` sebagai argumen kedua. Di dalam `jalankanDuaKali`, `fn` akan merujuk ke `sapaPagi`.

3.  **Bisa dikembalikan sebagai hasil dari function lain (Higher-Order Functions):**

    ```lua
    function buatPenambah(jumlahTambah)
      local penambahKhusus = function(angkaAwal)
                               return angkaAwal + jumlahTambah
                             end
      return penambahKhusus -- Mengembalikan sebuah function
    end

    local tambahLima = buatPenambah(5) -- tambahLima sekarang adalah function yang akan menambahkan 5
    local tambahSepuluh = buatPenambah(10) -- tambahSepuluh adalah function yang akan menambahkan 10

    print(tambahLima(20))  -- Output: 25 (karena 20 + 5)
    print(tambahSepuluh(20)) -- Output: 30 (karena 20 + 10)
    ```

    - **Penjelasan Kode:**
      - `buatPenambah` adalah higher-order function yang mengembalikan function lain.
      - Ketika `buatPenambah(5)` dipanggil, ia menciptakan function baru (`penambahKhusus`) yang "mengingat" bahwa `jumlahTambah` adalah 5 (ini terkait konsep _closure_, akan dibahas nanti). Function baru ini kemudian dikembalikan dan disimpan di `tambahLima`.
      - `tambahLima(20)` kemudian memanggil function yang disimpan tersebut dengan argumen 20.

4.  **Bisa disimpan dalam table (termasuk sebagai method):**

    ```lua
    local kalkulator = {} -- Membuat table kosong

    kalkulator.tambah = function(a, b) return a + b end
    kalkulator.kurang = function(a, b) return a - b end

    print(kalkulator.tambah(7, 2)) -- Output: 9
    print(kalkulator.kurang(7, 2)) -- Output: 5
    ```

    - **Penjelasan Kode:**
      - Kita membuat table `kalkulator`.
      - Kemudian kita menambahkan dua entri ke table tersebut, `tambah` dan `kurang`, di mana nilai dari entri tersebut adalah function.
      - Function-function ini kemudian bisa dipanggil menggunakan sintaks `nama_table.nama_function()`.

Sifat "first-class citizen" ini membuat Lua sangat fleksibel dan mendukung paradigma pemrograman fungsional.

**Sumber Referensi untuk 1.1:**

- Lua 5.4 Reference Manual - Functions: [https://www.lua.org/manual/5.4/manual.html#3.4.11](https://www.lua.org/manual/5.4/manual.html#3.4.11)
- Programming in Lua (PIL) - Function Basics: [https://www.lua.org/pil/5.html](https://www.lua.org/pil/5.html)

---

### 1.2 Membuat Function Sederhana

Di bagian ini, kita akan memperdalam pemahaman tentang bagaimana membuat function, menangani input (parameter dan argumen), menghasilkan output (return values), dan perbedaan antara function yang dapat diakses dari mana saja (global) versus yang hanya dapat diakses dalam lingkup tertentu (lokal).

#### **Deklarasi function dengan `function` keyword**

Seperti yang telah kita singgung di 1.1, cara paling umum untuk mendeklarasikan function bernama di Lua adalah menggunakan keyword `function`.

- **Sintaks Umum (Review):**

  ```lua
  function nama_function(parameter1, parameter2)
      -- Badan function: serangkaian pernyataan
      -- yang melakukan tugas tertentu
      -- bisa ada pernyataan 'return' di sini
  end
  ```

- **Penjelasan Sintaks (Review):**

  - `function`: Keyword yang memulai definisi sebuah function.
  - `nama_function`: Pengidentifikasi (nama) yang akan digunakan untuk memanggil function ini. Sebaiknya pilih nama yang deskriptif, menjelaskan apa yang dilakukan function tersebut.
  - `(parameter1, parameter2)`: Daftar nama parameter, dipisahkan oleh koma. Ini adalah variabel placeholder yang akan menerima nilai ketika function dipanggil. Jika function tidak memerlukan input, tanda kurung tetap ditulis: `()`.
  - `Badan function`: Blok kode antara `function` dan `end` yang berisi instruksi-instruksi yang akan dieksekusi.
  - `end`: Keyword yang menandai akhir dari definisi function.

- **Contoh Deklarasi Function Sederhana:**

  ```lua
  -- Function untuk menghitung luas persegi panjang
  function hitungLuasPersegiPanjang(panjang, lebar)
    local luas = panjang * lebar -- Melakukan kalkulasi
    print("Luasnya adalah: " .. luas) -- Menampilkan hasil
  end

  -- Memanggil function
  hitungLuasPersegiPanjang(10, 5) -- Output: Luasnya adalah: 50
  hitungLuasPersegiPanjang(7, 3)  -- Output: Luasnya adalah: 21
  ```

- **Penjelasan Kode Contoh:**
  - `function hitungLuasPersegiPanjang(panjang, lebar)`: Mendefinisikan function bernama `hitungLuasPersegiPanjang` yang menerima dua parameter: `panjang` dan `lebar`.
  - `local luas = panjang * lebar`: Di dalam function, kita mendeklarasikan variabel lokal `luas` dan mengisinya dengan hasil perkalian `panjang` dan `lebar`. Menggunakan `local` di sini adalah praktik yang baik untuk membatasi lingkup variabel (lebih lanjut di "Local vs global functions").
  - `print("Luasnya adalah: " .. luas)`: Menampilkan hasil perhitungan ke konsol.
  - `hitungLuasPersegiPanjang(10, 5)`: Memanggil function `hitungLuasPersegiPanjang`. Nilai `10` menjadi argumen untuk parameter `panjang`, dan `5` menjadi argumen untuk parameter `lebar`.

#### **Parameter dan argument**

Konsep ini seringkali tertukar, jadi mari kita perjelas.

- **Parameter:**

  - Adalah variabel yang dideklarasikan dalam _definisi_ sebuah function.
  - Bertindak sebagai placeholder untuk nilai-nilai yang akan diterima function saat dipanggil.
  - Merupakan variabel lokal di dalam function tersebut. Artinya, parameter hanya bisa diakses dari dalam function tempat ia didefinisikan.
  - Dalam contoh `function sapa(nama)`, `nama` adalah sebuah parameter.

- **Argument:**

  - Adalah nilai _aktual_ yang dilewatkan ke sebuah function ketika function tersebut _dipanggil_.
  - Nilai-nilai ini akan disalin (atau dirujuk, tergantung tipe data) ke parameter yang sesuai.
  - Dalam contoh `sapa("Andi")`, `"Andi"` adalah sebuah argumen.

- **Bagaimana Argumen Dipetakan ke Parameter:**
  Lua memetakan argumen ke parameter berdasarkan urutan. Argumen pertama akan mengisi parameter pertama, argumen kedua ke parameter kedua, dan seterusnya.

  ```lua
  function deskripsiOrang(nama, usia, kota)
    print(nama .. " berumur " .. usia .. " tahun dan tinggal di " .. kota .. ".")
  end

  deskripsiOrang("Citra", 25, "Bandung")
  -- Output: Citra berumur 25 tahun dan tinggal di Bandung.
  -- "Citra" -> nama
  -- 25      -> usia
  -- "Bandung" -> kota
  ```

- **Ketidakcocokan Jumlah Argumen dan Parameter:**
  Lua cukup fleksibel dalam menangani ketidakcocokan jumlah argumen dan parameter:

  1.  **Argumen lebih banyak dari parameter:** Argumen ekstra akan diabaikan.

      ```lua
      function tampilkanDua(a, b)
        print("a = " .. tostring(a) .. ", b = " .. tostring(b))
      end

      tampilkanDua(10, 20, 30, 40) -- 30 dan 40 akan diabaikan
      -- Output: a = 10, b = 20
      ```

      - `tostring(a)`: Digunakan untuk mengonversi nilai `a` menjadi string, berguna jika `a` bisa jadi bukan string (misalnya `nil`).

  2.  **Argumen lebih sedikit dari parameter:** Parameter yang tidak mendapatkan argumen akan bernilai `nil`. `nil` adalah tipe data khusus di Lua yang merepresentasikan ketiadaan nilai.

      ```lua
      function tampilkanDua(a, b)
        print("a = " .. tostring(a) .. ", b = " .. tostring(b))
      end

      tampilkanDua(5)
      -- Output: a = 5, b = nil
      -- Parameter 'b' tidak mendapatkan argumen, sehingga nilainya nil.
      ```

      Anda bisa menangani kasus `nil` di dalam function jika perlu, misalnya dengan memberikan nilai default (akan dibahas di Bagian 2).

#### **Return values**

Function tidak hanya melakukan aksi, tetapi juga bisa mengembalikan satu atau lebih nilai ke kode yang memanggilnya. Ini dilakukan menggunakan keyword `return`.

- **Sintaks `return`:**

  ```lua
  return ekspresi1, ekspresi2, ...
  ```

  - `return`: Keyword untuk mengembalikan nilai.
  - `ekspresi1, ekspresi2, ...`: Satu atau lebih nilai atau ekspresi yang akan dievaluasi dan dikembalikan. Jika tidak ada ekspresi yang diberikan setelah `return`, atau jika `return` tidak ada sama sekali (dan function berakhir secara normal), function akan mengembalikan `nil` (atau tidak ada nilai jika dilihat dari konteks multiple assignment).

- **Mengembalikan Satu Nilai:**

  ```lua
  function kuadrat(angka)
    return angka * angka -- Mengembalikan hasil perkalian angka dengan dirinya sendiri
  end

  local hasil = kuadrat(4) -- Memanggil function dan menyimpan nilai kembaliannya
  print("Kuadrat dari 4 adalah " .. hasil) -- Output: Kuadrat dari 4 adalah 16

  local hasilLain = kuadrat(hasil) -- Menggunakan hasil sebelumnya sebagai input
  print("Kuadrat dari " .. hasil .. " adalah " .. hasilLain) -- Output: Kuadrat dari 16 adalah 256
  ```

  - **Penjelasan Kode:**
    - `function kuadrat(angka)`: Function ini mengambil satu parameter `angka`.
    - `return angka * angka`: Function mengembalikan hasil dari `angka` dikalikan `angka`.
    - `local hasil = kuadrat(4)`: `kuadrat(4)` dipanggil. Function ini mengembalikan `16`. Nilai `16` ini kemudian disimpan dalam variabel `hasil`.

- **Mengembalikan Banyak Nilai (Multiple Return Values):**
  Lua memiliki fitur yang sangat berguna yaitu kemampuan untuk mengembalikan lebih dari satu nilai dari sebuah function.

  ```lua
  function dapatkanKoordinat()
    local x = 10
    local y = 20
    return x, y -- Mengembalikan dua nilai: x dan y
  end

  -- Cara menangkap multiple return values
  local posX, posY = dapatkanKoordinat() -- posX akan berisi 10, posY akan berisi 20

  print("Posisi X: " .. posX) -- Output: Posisi X: 10
  print("Posisi Y: " .. posY) -- Output: Posisi Y: 20
  ```

  - **Penjelasan Kode:**
    - `return x, y`: Function `dapatkanKoordinat` mengembalikan dua nilai, yaitu nilai dari `x` dan nilai dari `y`.
    - `local posX, posY = dapatkanKoordinat()`: Ketika `dapatkanKoordinat()` dipanggil dalam konteks multiple assignment seperti ini, nilai kembalian pertama (`x`) di-assign ke `posX`, dan nilai kembalian kedua (`y`) di-assign ke `posY`.

- **Apa yang terjadi jika jumlah variabel penampung tidak cocok dengan jumlah return values?**

  1.  **Variabel lebih banyak dari nilai yang dikembalikan:** Variabel ekstra akan diisi `nil`.

      ```lua
      function beriSatuNilai()
        return 100
      end

      local v1, v2, v3 = beriSatuNilai()
      print(v1, v2, v3) -- Output: 100   nil   nil
      ```

  2.  **Variabel lebih sedikit dari nilai yang dikembalikan:** Nilai kembalian ekstra akan diabaikan.

      ```lua
      function beriTigaNilai()
        return "apel", "jeruk", "mangga"
      end

      local buah1 = beriTigaNilai()
      print(buah1) -- Output: apel (hanya nilai pertama yang ditangkap)

      local buahA, buahB = beriTigaNilai()
      print(buahA, buahB) -- Output: apel   jeruk
      ```

- **Pernyataan `return` Mengakhiri Function:**
  Ketika pernyataan `return` dieksekusi, function tersebut segera berhenti dan kembali ke pemanggil. Kode apapun setelah `return` di dalam function (pada path eksekusi yang sama) tidak akan dijalankan.

  ```lua
  function cekAngka(angka)
    if angka < 0 then
      return "Negatif" -- Jika angka negatif, function berhenti di sini
    end
    -- Kode ini hanya berjalan jika angka tidak negatif
    print("Memproses angka positif atau nol...")
    return "Non-negatif"
  end

  print(cekAngka(-5)) -- Output: Negatif
  print(cekAngka(10))
  -- Output:
  -- Memproses angka positif atau nol...
  -- Non-negatif
  ```

- **Function Tanpa `return` Eksplisit:**
  Jika sebuah function mencapai `end` tanpa mengeksekusi pernyataan `return` secara eksplisit, ia secara implisit mengembalikan `nil` (atau, lebih tepatnya, tidak ada hasil).

  ```lua
  function hanyaCetak(pesan)
    print(pesan)
    -- Tidak ada 'return' di sini
  end

  local hasilCetak = hanyaCetak("Halo!") -- "Halo!" akan dicetak
  print("Hasil function: " .. tostring(hasilCetak)) -- Output: Hasil function: nil
  ```

#### **Local vs global functions**

Di Lua, variabel (dan juga function, karena function adalah nilai) memiliki _scope_ atau lingkup. Scope menentukan di mana saja sebuah variabel atau function dapat diakses. Secara default, function yang Anda definisikan adalah **global**.

- **Global Functions:**

  - Dapat diakses dari mana saja dalam program Anda, termasuk dari dalam function lain atau file Lua lain (jika program Anda terdiri dari banyak file).
  - Didefinisikan tanpa keyword `local`.
  - **Sintaks (seperti yang telah kita lihat):**
    ```lua
    function namaGlobalFunction()
      print("Saya function global!")
    end
    ```
  - Function ini setara dengan:
    ```lua
    _G.namaGlobalFunction = function() -- _G adalah table yang menyimpan semua variabel global
      print("Saya function global!")
    end
    -- Atau (lebih umum ditulis):
    namaGlobalFunction = function()
      print("Saya function global!")
    end
    ```
  - **Kapan digunakan?** Sebaiknya dihindari jika tidak benar-benar diperlukan. Penggunaan variabel global secara berlebihan dapat menyebabkan:
    - **Name Clashes (Tabrakan Nama):** Jika Anda secara tidak sengaja mendefinisikan function global dengan nama yang sama di bagian kode yang berbeda, salah satunya akan menimpa yang lain.
    - **Kesulitan Melacak Kode:** Lebih sulit untuk memahami dari mana sebuah function global dipanggil atau dimodifikasi.
    - **Kurang Modular:** Membuat kode kurang portabel dan lebih sulit untuk diintegrasikan sebagai modul ke proyek lain.

- **Local Functions:**

  - Hanya dapat diakses dalam blok kode (scope) tempat mereka didefinisikan. Blok kode ini bisa berupa file itu sendiri, function lain, atau blok `do...end`.
  - Didefinisikan dengan menggunakan keyword `local` sebelum keyword `function`.
  - **Sintaks:**
    ```lua
    local function namaLocalFunction()
      print("Saya function lokal!")
    end
    ```
  - **Keuntungan menggunakan local function:**
    - **Menghindari Tabrakan Nama:** Karena hanya terlihat di lingkupnya, Anda bisa memiliki function lokal dengan nama yang sama di lingkup yang berbeda tanpa masalah.
    - **Enkapsulasi yang Lebih Baik:** Menyembunyikan detail implementasi. Hanya bagian dari kode yang benar-benar perlu tahu tentang function tersebut yang bisa mengaksesnya.
    - **Potensi Kinerja (sedikit):** Akses ke variabel lokal (termasuk function lokal) sedikit lebih cepat daripada variabel global di Lua karena cara Lua mencarinya.
    - **Praktik Terbaik:** Secara umum, **selalu usahakan untuk mendeklarasikan function (dan variabel) sebagai `local` kecuali Anda memiliki alasan kuat untuk membuatnya global.**

- **Contoh Perbandingan:**

  ```lua
  -- File: main.lua

  -- Ini adalah function global
  function utilityGlobal()
    print("Ini dari utilityGlobal.")
  end

  -- Ini adalah function lokal untuk file main.lua
  local function utilityLokalModule()
    print("Ini dari utilityLokalModule di main.lua.")
  end

  function prosesUtama()
    local data = "Data penting"

    -- Function lokal di dalam function prosesUtama
    local function prosesInternal()
      print("prosesInternal mengakses: " .. data) -- Bisa akses 'data' dari scope luar (closure)
      utilityGlobal() -- Bisa panggil global
      utilityLokalModule() -- Bisa panggil lokal dari scope file
    end

    print("Memulai prosesUtama...")
    prosesInternal() -- Memanggil function lokal
    -- utilityLokalLuar() -- Akan error jika dipanggil di sini karena scope-nya di bawah
  end

  local function utilityLokalLuar()
    print("Ini dari utilityLokalLuar di main.lua.")
    -- prosesInternal() -- Akan error, tidak bisa akses function lokal dari dalam prosesUtama
  end

  prosesUtama()
  utilityLokalLuar()
  -- utilityInternal() -- Akan error, tidak bisa dipanggil dari luar prosesUtama

  -- Jika kita coba panggil utilityLokalModule dari file lain (misal other.lua yang di-require),
  -- itu tidak akan bisa langsung diakses kecuali kita secara eksplisit "mengekspornya"
  -- (misalnya dengan menambahkannya ke sebuah table yang di-return oleh modul).
  ```

  - **Penjelasan Kode Contoh:**
    - `utilityGlobal`: Global, bisa diakses dari mana saja.
    - `utilityLokalModule`: Lokal untuk file `main.lua`. Bisa diakses oleh `prosesUtama` dan `utilityLokalLuar` karena mereka berada dalam lingkup file yang sama dan setelah definisi `utilityLokalModule`.
    - `prosesUtama`: Global (bisa juga dibuat lokal jika hanya untuk file ini).
    - `prosesInternal`: Lokal di dalam `prosesUtama`. Hanya bisa dipanggil dari dalam `prosesUtama` setelah definisinya. `prosesInternal` juga merupakan contoh _closure_ karena ia bisa mengakses variabel `data` dari lingkup `prosesUtama`.
    - `utilityLokalLuar`: Lokal untuk file `main.lua`.

Prinsipnya, batasi "visibilitas" atau "keterlihatan" function seminimal mungkin. Jika sebuah function hanya dibutuhkan oleh function lain, buatlah ia lokal di dalam function tersebut atau lokal di dalam modul/file yang sama.

**Sumber Referensi untuk 1.2:**

- Lua Tutorial - Functions: [https://www.tutorialspoint.com/lua/lua_functions.htm](https://www.tutorialspoint.com/lua/lua_functions.htm) (Menjelaskan dasar-dasar deklarasi, parameter, argumen, return values)
- Learn Lua in Y Minutes - Functions: [https://learnxinyminutes.com/docs/lua/](https://learnxinyminutes.com/docs/lua/) (Memberikan contoh ringkas tentang sintaks function, termasuk lokal)
- Programming in Lua (PIL) - Local Variables and Blocks: [https://www.lua.org/pil/4.2.html](https://www.lua.org/pil/4.2.html) (Walaupun judulnya variabel, konsep scope di sini berlaku juga untuk function lokal)

---

Selanjutnya kita akan masuk ke "1.3 Function Scope dan Visibility" yang akan memperdalam pembahasan `local`, `global`, serta mengenalkan `upvalue` dan `closure` secara dasar.

---

### 1.3 Function Scope dan Visibility

Scope (lingkup) menentukan di mana saja dalam kode Anda sebuah variabel atau function dapat diakses. Visibility (visibilitas) berkaitan erat dengan scope. Memahami ini krusial untuk menulis kode yang terstruktur, modular, dan bebas dari bug yang tidak terduga.

#### **Local functions**

Seperti yang telah dibahas sebelumnya, function lokal didefinisikan menggunakan keyword `local` dan hanya dapat diakses dalam blok kode tempat ia didefinisikan.

- **Sintaks (Review):**

  1.  Bentuk standar:
      ```lua
      local function namaFunctionLokal(parameter)
          -- isi function
      end
      ```
  2.  Bentuk ekspresi function (anonim) yang disimpan ke variabel lokal:
      `lua
local namaFunctionLokal = function(parameter)
                            -- isi function
                          end
`
      Kedua bentuk ini pada dasarnya melakukan hal yang sama: membuat function dan meng-assign-nya ke variabel lokal `namaFunctionLokal`. Bentuk pertama (`local function ...`) memiliki keistimewaan terkait "hoisting" yang akan kita bahas nanti, terutama untuk rekursi.

- **Lingkup Blok:**
  Sebuah "blok" di Lua bisa berupa:

  - Seluruh file (`.lua`). Function lokal yang didefinisikan di level terluar file hanya akan terlihat di dalam file tersebut.
  - Badan function lain. Function lokal yang didefinisikan di dalam function lain hanya terlihat di dalam function tersebut.
  - Blok `do ... end`.
  - Blok dalam struktur kontrol seperti `if ... then ... else ... end`, `for ... do ... end`, `while ... do ... end`.

- **Contoh Lingkup Function Lokal:**

  ```lua
  -- Lingkup file (atau "chunk" dalam terminologi Lua)
  local function utilitasFile()
    print("Ini adalah utilitas level file.")
  end

  function utama()
    local nilaiDalamUtama = "Data Utama"

    local function utilitasDalamUtama()
      print("Ini adalah utilitas di dalam function utama.")
      print("Mengakses: " .. nilaiDalamUtama) -- Bisa akses variabel lokal dari scope luar (closure)
      utilitasFile() -- Bisa panggil function lokal dari scope file
    end

    print("Memanggil utilitasDalamUtama dari dalam utama:")
    utilitasDalamUtama()

    -- utilitasFile() -- Bisa dipanggil di sini juga
  end

  print("Memanggil utama:")
  utama()

  print("Mencoba memanggil utilitasFile dari luar utama (tapi masih dalam file):")
  utilitasFile()

  -- print(nilaiDalamUtama) -- ERROR! Tidak bisa akses variabel lokal dari dalam function 'utama'
  -- utilitasDalamUtama() -- ERROR! Tidak bisa akses function lokal dari dalam function 'utama'
  ```

- **Penjelasan Kode Contoh:**

  - `utilitasFile`: Didefinisikan sebagai lokal di level file. Ia bisa dipanggil oleh `utama` dan juga dari luar `utama` (selama masih dalam file yang sama dan setelah definisinya).
  - `utama`: Sebuah function (global dalam contoh ini, tapi bisa juga `local function utama()`).
  - `nilaiDalamUtama`: Variabel lokal di dalam function `utama`.
  - `utilitasDalamUtama`: Function lokal yang didefinisikan _di dalam_ `utama`. Ia hanya bisa diakses dari dalam `utama`. Perhatikan bahwa `utilitasDalamUtama` bisa mengakses `nilaiDalamUtama`, ini adalah contoh dasar dari _closure_.
  - Pemanggilan yang di-komen (`-- ERROR!`) menunjukkan batasan scope.

- **Manfaat Utama Function Lokal:**
  - **Menghindari Polusi Global Space:** Mencegah tabrakan nama dengan function atau variabel di bagian lain kode atau di library lain.
  - **Enkapsulasi:** Menyembunyikan detail implementasi. Function yang hanya bersifat pembantu (helper) untuk function lain sebaiknya dibuat lokal.
  - **Keterbacaan:** Membuat lebih jelas bagian kode mana yang bergantung pada function tertentu.

#### **Global functions**

Function global didefinisikan tanpa keyword `local` dan secara default disimpan dalam tabel lingkungan global `_G`. Mereka dapat diakses dari mana saja dalam program Anda.

- **Sintaks (Review):**

  ```lua
  function namaFunctionGlobal(parameter)
      -- isi function
  end
  ```

  Ini secara efektif sama dengan:

  ```lua
  _G.namaFunctionGlobal = function(parameter)
                            -- isi function
                          end
  ```

- **Risiko Function Global:**

  - **Tabrakan Nama (Name Clashes):** Jika Anda atau library yang Anda gunakan secara tidak sengaja mendefinisikan function global lain dengan nama yang sama, salah satunya akan menimpa yang lain, seringkali menyebabkan bug yang sulit dilacak.
  - **Kesulitan Pemeliharaan:** Sulit untuk mengetahui semua tempat di mana function global dipanggil atau dimodifikasi, membuat refactoring atau debugging lebih kompleks.
  - **Modularitas Buruk:** Kode yang terlalu bergantung pada global cenderung kurang modular dan sulit diintegrasikan ke dalam proyek lain atau diuji secara terisolasi.

- **Kapan Menggunakan Global (dengan Hati-hati):**
  - Untuk API utama dari sebuah library/modul yang memang ditujukan untuk diakses secara global (meskipun praktik modul modern di Lua lebih menyarankan mengembalikan tabel berisi function).
  - Untuk fungsi yang sangat umum dan fundamental yang digunakan di banyak tempat (seperti `print`, `tostring` bawaan Lua).
  - Dalam skrip kecil dan sederhana di mana manajemen scope yang ketat mungkin berlebihan (namun, membiasakan diri dengan `local` tetap baik).

**Praktik Umum yang Baik:** Selalu gunakan `local` untuk function (dan variabel) kecuali ada alasan yang sangat spesifik dan disengaja untuk membuatnya global.

#### **Upvalues dan closures dasar**

Ini adalah konsep inti di Lua yang memungkinkan fleksibilitas luar biasa, terutama dalam pemrograman fungsional dan pembuatan modul.

- **Lexical Scoping (Static Scoping):**
  Lua menggunakan _lexical scoping_. Artinya, scope sebuah variabel ditentukan oleh di mana ia dideklarasikan dalam kode sumber secara fisik (leksikal), bukan oleh bagaimana function dipanggil (dynamic scoping).
  Ketika sebuah function didefinisikan di dalam function lain (nested function), function dalam (inner) dapat mengakses variabel lokal dari function luar (outer) tempat ia didefinisikan.

- **Upvalue:**
  Ketika sebuah function dalam (inner function) mengakses variabel lokal dari function luar (enclosing function) yang telah selesai dieksekusi, variabel lokal tersebut disebut **upvalue** untuk inner function tersebut. Lua memastikan bahwa variabel ini tetap "hidup" selama inner function masih bisa mengaksesnya, bahkan jika outer function sudah selesai berjalan dan variabel lokalnya seharusnya sudah "hilang".

- **Closure:**
  Sebuah **closure** adalah kombinasi dari sebuah function dan lingkungan leksikal tempat function tersebut didefinisikan. Lingkungan ini mencakup semua upvalue yang dirujuk oleh function tersebut.
  Sederhananya, function "mengingat" variabel-variabel dari tempat ia diciptakan. Setiap kali Anda membuat function yang mengakses variabel lokal dari scope luarnya, Anda membuat sebuah closure.

- **Contoh Closure dan Upvalue:**

  ```lua
  function buatCounter()
    local hitungan = 0 -- Variabel lokal 'hitungan' di scope 'buatCounter'

    -- Inner function 'increment' didefinisikan di sini
    local function increment()
      hitungan = hitungan + 1 -- Mengakses dan memodifikasi 'hitungan' dari scope 'buatCounter'
      return hitungan
    end

    return increment -- Mengembalikan inner function 'increment'
  end

  local counter1 = buatCounter() -- 'counter1' sekarang adalah sebuah closure
  local counter2 = buatCounter() -- 'counter2' adalah closure lain, dengan 'hitungan'-nya sendiri

  print("Counter 1:", counter1()) -- Output: Counter 1: 1 ('hitungan' untuk counter1 menjadi 1)
  print("Counter 1:", counter1()) -- Output: Counter 1: 2 ('hitungan' untuk counter1 menjadi 2)

  print("Counter 2:", counter2()) -- Output: Counter 2: 1 ('hitungan' untuk counter2 menjadi 1, terpisah dari counter1)
  print("Counter 1:", counter1()) -- Output: Counter 1: 3 ('hitungan' untuk counter1 menjadi 3)
  ```

- **Penjelasan Kode Contoh:**
  1.  `function buatCounter()`: Ini adalah function "pabrik" yang akan membuat function counter.
  2.  `local hitungan = 0`: `hitungan` adalah variabel lokal untuk `buatCounter`. Setiap kali `buatCounter` dipanggil, ia mendapatkan salinan `hitungan`-nya sendiri yang dimulai dari 0.
  3.  `local function increment()`: Ini adalah function dalam (inner function).
  4.  `hitungan = hitungan + 1`: `increment` mengakses dan memodifikasi `hitungan`. Karena `hitungan` adalah variabel lokal dari `buatCounter` (scope luarnya), `hitungan` menjadi sebuah **upvalue** untuk `increment`.
  5.  `return increment`: `buatCounter` mengembalikan function `increment`. Yang dikembalikan bukan hanya kode function `increment`, tetapi sebuah _closure_: function `increment` ditambah dengan kemampuannya untuk mengakses `hitungan` spesifik dari instansiasi `buatCounter` yang menciptakannya.
  6.  `local counter1 = buatCounter()`: `counter1` sekarang menyimpan closure. Closure ini "mengingat" `hitungan`-nya sendiri (yang dimulai dari 0).
  7.  `local counter2 = buatCounter()`: `counter2` menyimpan closure lain. Closure ini juga "mengingat" `hitungan`-nya sendiri (yang juga dimulai dari 0, tetapi ini adalah `hitungan` yang _berbeda_ dari milik `counter1`).
  8.  Setiap panggilan ke `counter1()` akan memodifikasi dan mengembalikan `hitungan` yang terikat pada `counter1`. Hal yang sama berlaku untuk `counter2()`. Keduanya independen.

Closure adalah mekanisme yang memungkinkan stateful function, private variable simulation, dan banyak pola pemrograman canggih lainnya di Lua.

#### **Function hoisting di Lua**

"Hoisting" adalah istilah yang sering dikaitkan dengan JavaScript, di mana deklarasi variabel dan function seolah-olah "diangkat" ke atas scope-nya. Lua memiliki perilaku yang sedikit berbeda dan lebih spesifik, terutama untuk deklarasi function lokal.

- **Tidak Ada Hoisting Umum seperti JavaScript:**
  Jika Anda mendefinisikan function lokal menggunakan sintaks ekspresi:

  ```lua
  -- CONTOH SALAH (ERROR)
  -- cobaPanggilSebelumDefinisi() -- Akan error: 'cobaPanggilSebelumDefinisi' adalah nil

  local cobaPanggilSebelumDefinisi = function()
    print("Dipanggil setelah definisi ekspresi.")
  end

  cobaPanggilSebelumDefinisi()
  ```

  Dalam kasus ini, `cobaPanggilSebelumDefinisi` adalah variabel lokal yang di-assign sebuah function. Sebelum baris assignment, `cobaPanggilSebelumDefinisi` bernilai `nil`.

- **Perilaku Khusus untuk `local function nama()`:**
  Ketika Lua menemukan deklarasi `local function foo() ... end`, ia memperlakukannya sedikit berbeda. Deklarasi ini sebenarnya adalah "syntactic sugar" (cara penulisan yang lebih mudah) untuk:

  ```lua
  local foo   -- 1. Nama 'foo' dideklarasikan sebagai lokal terlebih dahulu
  foo = function() -- 2. Kemudian, function di-assign ke 'foo'
      -- isi function, 'foo' sudah dikenal di sini untuk rekursi
  end
  ```

  Karena nama `foo` sudah dideklarasikan (meskipun belum di-assign function body-nya secara penuh hingga baris kedua virtual tersebut), nama `foo` sudah ada dalam scope blok tersebut. Ini memiliki dua implikasi penting:

  1.  **Rekursi Langsung (Direct Recursion):** Function dapat memanggil dirinya sendiri.

      ```lua
      local function faktorial(n)
        if n == 0 then
          return 1
        else
          return n * faktorial(n - 1) -- 'faktorial' sudah dikenal di sini
        end
      end
      print("Faktorial 5:", faktorial(5)) -- Output: Faktorial 5: 120
      ```

  2.  **Rekursi Mutual (Mutual Recursion) dan Pemanggilan Sebelum Definisi Teksual (dalam blok yang sama):**
      Beberapa function lokal dapat saling memanggil, bahkan jika definisi salah satu function muncul setelah pemanggilannya, selama semuanya dalam blok yang sama dan menggunakan sintaks `local function ...`.

      ```lua
      local function funcA()
        print("Dalam funcA, memanggil funcB.")
        funcB() -- funcB belum didefinisikan secara tekstual, tapi namanya sudah ada di scope
      end

      local function funcB()
        print("Dalam funcB.")
        -- funcA() -- Bisa juga panggil funcA dari sini jika perlu
      end

      funcA()
      -- Output:
      -- Dalam funcA, memanggil funcB.
      -- Dalam funcB.
      ```

      Ini bekerja karena ketika Lua memproses blok tersebut, nama `funcA` dan `funcB` (sebagai variabel lokal) diketahui sebelum badan function mereka sepenuhnya di-parse. Jadi, ketika badan `funcA` di-parse, ia tahu bahwa `funcB` adalah variabel lokal yang valid dalam scope saat ini (yang nantinya akan berisi function).

- **Kapan Perlu Hati-hati (Forward Declaration Manual):**
  Jika Anda menggunakan sintaks ekspresi (`local nama = function() ... end`) dan memerlukan rekursi mutual atau pemanggilan sebelum definisi, Anda perlu melakukan "forward declaration" secara manual:

  ```lua
  local funcX
  local funcY

  funcX = function()
    print("Dalam funcX, memanggil funcY jika belum selesai.")
    if funcY then funcY() end -- Perlu cek jika funcY sudah diassign
  end

  funcY = function()
    print("Dalam funcY, memanggil funcX.")
    -- funcX() -- funcX sudah pasti terdefinisi di sini
  end

  funcX() -- Memulai panggilan
  ```

  Namun, menggunakan `local function nama()` jauh lebih bersih untuk kasus rekursi mutual.

Jadi, meskipun Lua tidak memiliki "hoisting" dalam artian JavaScript yang mengangkat seluruh definisi, sintaks `local function nama()` menyediakan mekanisme yang memungkinkan nama function dikenal di seluruh bloknya, memfasilitasi rekursi dan penataan kode yang fleksibel.

**Sumber Referensi untuk 1.3:**

- Programming in Lua (PIL) - Local Variables and Blocks: [https://www.lua.org/pil/4.2.html](https://www.lua.org/pil/4.2.html) (Membahas scope variabel lokal, yang berlaku juga untuk function lokal dan dasar untuk upvalue).
- Lua Users Wiki - Scope Tutorial: [http://lua-users.org/wiki/ScopeTutorial](http://lua-users.org/wiki/ScopeTutorial) (Memberikan penjelasan tentang bagaimana scope bekerja di Lua, termasuk contoh untuk `local function`).
- Programming in Lua (PIL) - Closures (Bagian 6.1): [https://www.lua.org/pil/6.1.html](https://www.lua.org/pil/6.1.html) (Ini akan menjadi sumber utama ketika kita membahas closures lebih dalam, tapi konsep dasarnya relevan di sini).

---

Kita sudah menyelesaikan Bagian 1 dari kurikulum ini. Sejauh ini kita telah membahas pengenalan function, cara membuatnya, parameter & argumen, return values, serta perbedaan penting antara function lokal dan global, dilengkapi dengan konsep dasar upvalue, closure, dan perilaku "hoisting" khusus di Lua.

> - **[Ke Atas](#)**
> - **[Selanjutnya][2]**
> - **[Sebelumnya][3]**
> - **[Kurikulum][4]**
> - **[Domain Spesifik][5]**

[5]: ../../../../../../README.md
[4]: ../../../../README.md
[3]: ../../kontrol-flow/materi/README.md
[2]: ../bagian-2/README.md
[1]: ../README.md
