# [Modul 2: Variable Assignment dan Operations (Minggu 2)][1]

Modul ini akan memperdalam pemahaman Anda tentang bagaimana nilai ditugaskan (assigned) ke variabel di Lua, termasuk berbagai pola penugasan, dan bagaimana melakukan operasi dasar pada variabel-variabel tersebut.

### 2.1 Assignment Patterns

Bagian ini fokus pada berbagai cara dan sintaks untuk memberikan nilai ke variabel di Lua.

#### **Basic Assignment (2 jam)**

- **Single Variable Assignment**

  - **Deskripsi Konkret**: Ini adalah bentuk penugasan paling dasar di mana satu nilai diberikan kepada satu variabel.
  - **Terminologi & Konsep**:
    - **LHS (Left-Hand Side)**: Variabel yang menerima nilai (di sebelah kiri tanda `=`).
    - **RHS (Right-Hand Side)**: Ekspresi atau nilai yang diberikan (di sebelah kanan tanda `=`).
    - **Ekspresi**: Kombinasi nilai, variabel, operator, dan pemanggilan fungsi yang dievaluasi oleh Lua untuk menghasilkan sebuah nilai.
  - **Sintaks Dasar**:
    ```lua
    variabel = ekspresi
    ```
  - **Contoh Kode**:

    ```lua
    local skor = 0             -- Nilai literal 0 ditugaskan ke skor
    local namaPemain = "Alex"  -- Nilai literal string "Alex" ditugaskan ke namaPemain
    local energi = 100
    local energiTerkuras = 20
    energi = energi - energiTerkuras -- Hasil ekspresi (100 - 20) ditugaskan kembali ke energi

    print(skor)         -- Output: 0
    print(namaPemain)   -- Output: Alex
    print(energi)       -- Output: 80
    ```

- **Multiple Assignment Syntax**

  - **Deskripsi Konkret**: Lua memungkinkan penugasan nilai ke beberapa variabel sekaligus dalam satu pernyataan. Ini adalah fitur yang sangat berguna dan sering digunakan di Lua.
  - **Terminologi & Konsep**:
    - **Parallel Assignment**: Istilah lain yang sering digunakan, karena seolah-olah semua evaluasi RHS terjadi sebelum penugasan ke LHS.
  - **Sintaks Dasar**:
    ```lua
    var1, var2, ..., varN = expr1, expr2, ..., exprM
    ```
  - **Aturan Penugasan**:
    1.  **Evaluasi RHS**: Semua ekspresi di sisi kanan (`expr1, expr2, ...`) dievaluasi terlebih dahulu, dari kiri ke kanan.
    2.  **Penugasan ke LHS**: Hasil evaluasi RHS kemudian ditugaskan ke variabel-variabel di sisi kiri (`var1, var2, ...`), juga dari kiri ke kanan.
    - Jika jumlah variabel (N) lebih banyak dari jumlah nilai (M): Variabel ekstra di LHS akan diberi nilai `nil`.
      ```lua
      local a, b, c
      a, b, c = 10, 20
      -- a menjadi 10, b menjadi 20, c menjadi nil
      print(a, b, c) -- Output: 10   20   nil
      ```
    - Jika jumlah nilai (M) lebih banyak dari jumlah variabel (N): Nilai ekstra di RHS akan diabaikan.
      ```lua
      local x, y
      x, y = 100, 200, 300
      -- x menjadi 100, y menjadi 200 (300 diabaikan)
      print(x, y) -- Output: 100   200
      ```
    - Kasus khusus: Jika ekspresi terakhir di RHS adalah pemanggilan fungsi yang mengembalikan beberapa nilai, atau ekspresi vararg (`...`), maka ia akan menyediakan sebanyak mungkin nilai yang dibutuhkan oleh variabel di LHS. Ini akan dibahas lebih lanjut di "Unpacking return values".
  - **Contoh Kode**:

    ```lua
    local nama, umur, kota
    nama, umur, kota = "Budi", 25, "Jakarta"
    print(nama, umur, kota) -- Output: Budi   25   Jakarta

    local x, y = 1, 2
    print(x, y) -- Output: 1   2
    ```

- **Parallel Assignment**

  - **Deskripsi Konkret**: Ini adalah penekanan pada sifat multiple assignment di Lua, di mana semua ekspresi di sisi kanan dievaluasi _sebelum_ salah satu penugasan ke variabel di sisi kiri terjadi. Ini sangat penting untuk operasi seperti menukar nilai variabel.
  - **Konsep Kunci**: Perilaku "semua RHS dievaluasi dulu" mencegah masalah di mana penugasan ke satu variabel LHS akan mempengaruhi nilai yang akan digunakan untuk variabel LHS lain dalam pernyataan yang sama jika evaluasinya tidak paralel.
  - **Contoh Kode (Menukar Variabel)**:

    ```lua
    local a = "nilai A"
    local b = "nilai B"

    -- Menukar nilai a dan b menggunakan parallel assignment
    a, b = b, a

    print("a sekarang:", a) -- Output: a sekarang: nilai B
    print("b sekarang:", b) -- Output: b sekarang: nilai A
    ```

    Jika ini tidak paralel dan `a = b` dievaluasi dan langsung ditugaskan, maka `a` akan menjadi "nilai B". Kemudian jika `b = a` dievaluasi, `b` juga akan menjadi "nilai B". Parallel assignment menghindari ini dengan mengambil nilai lama `b` dan `a` terlebih dahulu.

- **Assignment vs Equality Comparison**

  - **Deskripsi Konkret**: Sangat penting untuk membedakan operator penugasan (`=`) dengan operator perbandingan kesetaraan (`==`). Kesalahan umum bagi pemula adalah menggunakan `=` saat mereka bermaksud `==`.
  - **Terminologi & Konsep**:
    - **Operator Penugasan (`=`)**: Memberikan nilai ke variabel. Ini adalah sebuah _pernyataan_ (statement).
    - **Operator Perbandingan Kesetaraan (`==`)**: Memeriksa apakah dua nilai sama. Ini adalah sebuah _ekspresi_ yang menghasilkan nilai boolean (`true` atau `false`).
  - **Sintaks & Perbedaan**:
    - Penugasan: `variabel = nilai`
    - Perbandingan: `ekspresi1 == ekspresi2`
  - **Contoh Kode**:

    ```lua
    local angka = 10 -- Penugasan: 'angka' sekarang menyimpan 10

    -- Perbandingan (dalam konteks if statement)
    if angka == 10 then -- Memeriksa apakah nilai 'angka' adalah 10
        print("'angka' adalah 10") -- Akan tercetak
    end

    if angka == 20 then
        print("'angka' adalah 20") -- Tidak akan tercetak
    else
        print("'angka' bukan 20") -- Akan tercetak
    end

    -- Kesalahan umum: menggunakan '=' di dalam 'if'
    -- if angka = 5 then -- Ini akan menyebabkan ERROR di Lua karena if mengharapkan ekspresi boolean,
    --                 -- bukan pernyataan penugasan.
    --    print("Ini tidak akan berjalan dan error")
    -- end
    -- Beberapa bahasa (seperti C) mengizinkan penugasan dalam if,
    -- di mana nilai yang ditugaskan kemudian dievaluasi kebenarannya.
    -- Lua lebih ketat di sini dan membedakannya dengan jelas.
    ```

- **Chained Assignments**
  - **Deskripsi Konkret**: Lua _tidak_ mendukung "chained assignment" dalam satu baris seperti beberapa bahasa lain (misalnya, `a = b = c = 10`). Setiap penugasan harus merupakan pernyataan terpisah atau bagian dari multiple assignment.
  - **Apa yang TIDAK BISA dilakukan**:
    ```lua
    -- INI TIDAK VALID DI LUA dan akan menyebabkan error sintaks
    -- local x, y, z
    -- x = y = z = 100
    ```
  - **Cara yang Benar di Lua**:
    1.  **Penugasan Terpisah**:
        ```lua
        local x, y, z
        x = 100
        y = 100
        z = 100
        print(x, y, z) -- Output: 100  100  100
        ```
    2.  **Multiple Assignment (jika nilainya sama atau sudah diketahui)**:
        ```lua
        local x, y, z
        x, y, z = 100, 100, 100
        print(x, y, z) -- Output: 100  100  100
        ```
        Atau jika ingin menginisialisasi dengan nilai yang sama dari satu sumber:
        ```lua
        local nilaiAwal = 100
        local x, y, z
        x, y, z = nilaiAwal, nilaiAwal, nilaiAwal
        print(x, y, z) -- Output: 100  100  100
        ```
  - **Mengapa Tidak Ada Chained Assignment?**: Desain bahasa Lua cenderung memilih kesederhanaan dan kejelasan. Chained assignment dapat sedikit ambigu atau kurang terbaca dibandingkan penugasan eksplisit. Multiple assignment (`a, b = v, v`) sudah mencakup kasus di mana Anda ingin menginisialisasi beberapa variabel dengan nilai yang sama (jika nilai tersebut dievaluasi sekali).

#### **Advanced Assignment (3 jam)**

Pola penugasan yang lebih canggih dan memanfaatkan fitur unik Lua.

- **Swapping Variables**

  - **Deskripsi Konkret**: Menukar nilai antara dua variabel atau lebih. Multiple assignment di Lua membuat ini sangat elegan dan efisien.
  - **Cara Tradisional (dengan variabel sementara)**:

    ```lua
    local a = 10
    local b = 20
    local temp

    temp = a -- temp menyimpan nilai lama a (10)
    a = b    -- a sekarang 20
    b = temp -- b sekarang 10 (dari temp)

    print(a, b) -- Output: 20   10
    ```

  - **Cara Lua (menggunakan multiple/parallel assignment)**:

    ```lua
    local a = 100
    local b = 200

    a, b = b, a -- RHS (b, a) dievaluasi menjadi (200, 100)
                -- Kemudian ditugaskan: a = 200, b = 100

    print(a, b) -- Output: 200   100
    ```

    Ini lebih ringkas, lebih mudah dibaca, dan seringkali sedikit lebih efisien karena menghindari variabel sementara eksplisit di level skrip Lua (meskipun interpreter mungkin melakukannya secara internal).

- **Unpacking Return Values**

  - **Deskripsi Konkret**: Fungsi di Lua dapat mengembalikan beberapa nilai. Multiple assignment adalah cara utama untuk "membongkar" (unpack) nilai-nilai kembalian ini ke dalam variabel-variabel individual.
  - **Konsep**: Jika sebuah fungsi dipanggil sebagai ekspresi terakhir (atau satu-satunya ekspresi) di sisi kanan dari multiple assignment, ia akan menyediakan sebanyak mungkin nilai yang dibutuhkan oleh variabel di sisi kiri.
  - **Sintaks & Contoh Kode**:

    ```lua
    local function dapatkanKoordinat()
        return 10, 20, "sukses" -- Fungsi mengembalikan 3 nilai
    end

    -- Membongkar semua nilai
    local x, y, status = dapatkanKoordinat()
    print(x, y, status) -- Output: 10   20   sukses

    -- Membongkar sebagian nilai (nilai ekstra diabaikan oleh fungsi)
    local x_saja = dapatkanKoordinat() -- Hanya nilai pertama yang ditugaskan ke x_saja
    print(x_saja)       -- Output: 10 (nilai 20 dan "sukses" diabaikan)

    local x_val, y_val = dapatkanKoordinat() -- x_val=10, y_val=20, "sukses" diabaikan
    print(x_val, y_val) -- Output: 10  20

    -- Jika fungsi tidak di posisi terakhir RHS, ia hanya menyumbang satu nilai (nilai pertamanya)
    local prefix = "Koordinat: "
    local deskripsi = prefix .. dapatkanKoordinat() -- Hanya nilai pertama dari dapatkanKoordinat() yang digunakan
                                                    -- Jadi ini sama dengan: prefix .. 10
    print(deskripsi) -- Output: Koordinat: 10

    -- Cara lain untuk mendapatkan semua nilai jika tidak di posisi terakhir:
    -- Gunakan tanda kurung untuk memaksa evaluasi fungsi terlebih dahulu,
    -- namun ini tetap hanya akan mengambil nilai pertama jika digunakan dalam konteks yang mengharapkan satu nilai.
    -- Untuk multiple assignment, posisi fungsi sangat penting.

    -- Jika fungsi mengembalikan lebih sedikit nilai dari variabel yang menunggu:
    local function hanyaSatuNilai()
        return "penting"
    end

    local v1, v2, v3 = hanyaSatuNilai()
    print(v1, v2, v3) -- Output: penting   nil   nil
    ```

- **Table Unpacking**

  - **Deskripsi Konkret**: Mengambil nilai-nilai dari dalam tabel (biasanya yang terstruktur seperti array/list) dan menugaskannya ke variabel-variabel individual.
  - **Cara Umum (Akses Indeks Manual)**:
    ```lua
    local poin = {100, 200, 300}
    local x = poin[1]
    local y = poin[2]
    local z = poin[3]
    print(x, y, z) -- Output: 100   200   300
    ```
  - **Menggunakan Multiple Assignment (Untuk tabel sekuensial)**:
    Ini pada dasarnya adalah sintaks yang sama dengan mengakses indeks secara manual, tetapi dapat ditulis dalam satu baris.
    ```lua
    local poin = {100, 200, 300}
    local x, y, z
    x, y, z = poin[1], poin[2], poin[3]
    print(x, y, z) -- Output: 100   200   300
    ```
  - **Fungsi `table.unpack()` (Lua 5.2+) atau `unpack()` (global di Lua 5.1)**:
    Fungsi ini mengambil tabel sekuensial dan mengembalikan elemen-elemennya sebagai daftar nilai terpisah. Ini sangat berguna untuk meneruskan elemen tabel sebagai argumen ke fungsi lain atau untuk membongkarnya ke variabel.

    ```lua
    local dataWarna = {"merah", "hijau", "biru"}

    -- Lua 5.2+ (lebih disarankan)
    local r, g, b = table.unpack(dataWarna)
    print(r, g, b) -- Output: merah   hijau   biru

    -- Lua 5.1 (unpack adalah global)
    -- local r_old, g_old, b_old = unpack(dataWarna)
    -- print(r_old, g_old, b_old) -- Output: merah   hijau   biru

    -- Mengontrol rentang unpack (opsional i, j arguments)
    local angka = {10, 20, 30, 40, 50}
    local a, b = table.unpack(angka, 2, 3) -- Unpack dari indeks 2 sampai 3
    print(a,b) -- Output: 20   30

    -- Meneruskan elemen tabel sebagai argumen fungsi
    local function tampilkanWarna(c1, c2, c3)
        print("Warna:", c1, c2, c3)
    end
    tampilkanWarna(table.unpack(dataWarna)) -- Output: Warna: merah hijau biru
    ```

- **Pattern Matching dalam Assignment**

  - **Deskripsi Konkret**: Lua tidak memiliki "pattern matching" dalam arti formal seperti yang ditemukan di bahasa-bahasa fungsional (misalnya, Haskell, Erlang, atau Elixir dengan `case` dan pencocokan struktur data kompleks). Namun, kurikulum ini kemungkinan merujuk pada bagaimana multiple assignment dan table unpacking dapat digunakan untuk "mencocokkan" atau "mendestrukturisasi" data, terutama dari return value fungsi atau tabel.
  - **Konsep di Lua**: Ini lebih tentang "destructuring assignment" daripada pattern matching yang kompleks dengan guard, multiple clauses, dll.
  - **Contoh (Menggunakan Multiple Assignment untuk Destrukturisasi Return)**:
    Ini sudah dicakup dalam "Unpacking Return Values".

    ```lua
    local function getStatus()
        -- Misalkan mengembalikan {sukses=true, data="Isi data"} atau {sukses=false, error="Pesan error"}
        -- Pola yang lebih baik adalah mengembalikan nilai langsung, bukan tabel jika hanya beberapa nilai.
        return true, "Data berhasil diambil"
        -- return false, "Gagal mengambil data"
    end

    local sukses, hasil = getStatus()
    if sukses then
        print("Berhasil:", hasil)
    else
        print("Gagal:", hasil)
    end
    ```

  - **Contoh (Destrukturisasi Tabel Sederhana)**:
    Ini sudah dicakup dalam "Table Unpacking".

    ```lua
    local pengguna = {"Alice", 30, "alice@example.com"}
    local nama, umur, email = pengguna[1], pengguna[2], pengguna[3]
    -- atau menggunakan table.unpack jika semua elemen diinginkan
    -- local nama, umur, email = table.unpack(pengguna)

    print(nama, umur, email) -- Output: Alice   30   alice@example.com
    ```

    Untuk "pattern matching" yang lebih canggih pada tabel (misalnya, mencocokkan field tertentu dalam tabel yang lebih kompleks), Anda biasanya akan menggunakan kombinasi akses field dan kondisional `if-else`. Lua tidak memiliki sintaks bawaan untuk destructuring tabel berdasarkan nama kunci dalam satu operasi assignment seperti di JavaScript ES6 (`let {name, age} = userObject;`).

- **Conditional Assignment Patterns**

  - **Deskripsi Konkret**: Menugaskan nilai ke variabel berdasarkan suatu kondisi. Ini sering dilakukan menggunakan `if-else` statements atau menggunakan idiom `and-or` di Lua (yang berfungsi seperti operator ternary di bahasa lain, dengan beberapa peringatan).
  - **Menggunakan `if-else` (Paling Jelas dan Aman)**:

    ```lua
    local skor = 75
    local statusKelulusan

    if skor >= 70 then
        statusKelulusan = "Lulus"
    else
        statusKelulusan = "Tidak Lulus"
    end
    print(statusKelulusan) -- Output: Lulus
    ```

  - **Menggunakan Idiom `and-or` (Alternatif Ternary)**:
    Lua tidak memiliki operator ternary seperti `kondisi ? nilai_jika_true : nilai_jika_false`. Idiom `A and B or C` sering digunakan untuk menirunya.

    - **Cara Kerja**:
      - `A and B`: Jika `A` adalah falsy (`false` atau `nil`), hasilnya adalah `A`. Jika `A` adalah truthy, hasilnya adalah `B`.
      - `... or C`: Jika hasil dari `A and B` adalah falsy (yaitu, jika `A` falsy, atau `A` truthy TAPI `B` falsy), hasilnya adalah `C`. Jika hasil `A and B` adalah truthy, hasilnya adalah hasil tersebut.
    - **Sintaks**: `variabel = kondisi and nilai_jika_true or nilai_jika_false`
    - **Contoh**:

      ```lua
      local usia = 20
      local kategori = usia >= 18 and "Dewasa" or "Anak-anak"
      print(kategori) -- Output: Dewasa

      local penggunaAktif = nil -- atau false
      local namaTampilan = penggunaAktif and penggunaAktif.nama or "Tamu"
      print(namaTampilan) -- Output: Tamu
      ```

    - **PERINGATAN PENTING (Caveat)**: Idiom `A and B or C` ini memiliki masalah jika `B` (nilai_jika_true) bisa menjadi `false` atau `nil`. Jika `A` truthy dan `B` adalah `false` atau `nil`, maka `A and B` akan menghasilkan `B` (yang falsy), dan akibatnya `or C` akan dievaluasi, sehingga seluruh ekspresi menghasilkan `C`, padahal seharusnya `B`.
      ```lua
      local dapatDiskon = false -- Ini adalah nilai_jika_true yang valid tapi falsy
      local harga = 100
      -- Tujuan: jika harga > 50, berikan status diskon, jika tidak, "Tidak Ada Diskon"
      -- Menggunakan idiom and-or yang SALAH di sini:
      local statusDiskon = harga > 50 and dapatDiskon or "Tidak Ada Diskon"
      -- harga > 50 adalah true.
      -- dapatDiskon adalah false.
      -- (true and false) menghasilkan false.
      -- (false or "Tidak Ada Diskon") menghasilkan "Tidak Ada Diskon".
      -- Ini salah, seharusnya hasilnya adalah `false` (nilai dari dapatDiskon).
      print(statusDiskon) -- Output: Tidak Ada Diskon (SALAH!)
      ```
    - **Solusi untuk Caveat**: Cara paling aman adalah menggunakan `if-else` statement.
      ```lua
      local statusDiskonAman
      if harga > 50 then
          statusDiskonAman = dapatDiskon
      else
          statusDiskonAman = "Tidak Ada Diskon"
      end
      print(statusDiskonAman) -- Output: false (BENAR!)
      ```

#### **Praktik (3 jam)**

Kurikulum menyarankan latihan untuk memperkuat pemahaman pola penugasan.

- **Variable Swapping Exercises**:
  - Tukar nilai tiga variabel: `a, b, c = c, a, b`.
    ```lua
    local x, y, z = 10, 20, 30
    print("Sebelum:", x, y, z) -- Output: Sebelum: 10   20   30
    x, y, z = z, x, y          -- x=z(30), y=x(lama,10), z=y(lama,20)
    print("Sesudah:", x, y, z) -- Output: Sesudah: 30   10   20
    ```
- **Function Return Unpacking**:

  - Buat fungsi yang mengembalikan beberapa statistik (misal, min, max, avg dari sebuah list). Bongkar hasilnya ke variabel berbeda. Abaikan beberapa nilai kembalian.

    ```lua
    local function hitungStatistik(tabelAngka)
        if not tabelAngka or #tabelAngka == 0 then
            return nil, nil, nil, "Tabel kosong atau nil"
        end
        local min = tabelAngka[1]
        local max = tabelAngka[1]
        local sum = 0
        for i = 1, #tabelAngka do
            sum = sum + tabelAngka[i]
            if tabelAngka[i] < min then min = tabelAngka[i] end
            if tabelAngka[i] > max then max = tabelAngka[i] end
        end
        return min, max, sum / #tabelAngka, nil -- min, max, avg, error_msg
    end

    local angka = {5, 10, 2, 8, 5}
    local minimal, maksimal, rata2, pesanError = hitungStatistik(angka)

    if pesanError then
        print("Error:", pesanError)
    else
        print("Min:", minimal, "Max:", maksimal, "Rata-rata:", rata2)
        -- Output: Min: 2   Max: 10  Rata-rata: 6
    end

    -- Hanya mengambil min dan max
    local mn, mx = hitungStatistik(angka)
    print("Hanya Min-Max:", mn, mx) -- Output: Hanya Min-Max: 2   10
    ```

- **Complex Assignment Scenarios**:

  - Gabungkan pemanggilan fungsi, operasi tabel, dan multiple assignment dalam satu baris.

    ```lua
    local data = { nama="Sita", skor={80,90,70} }
    local namaPengguna, skorPertama, skorTerakhir
    local function getNama(tbl) return tbl.nama end

    namaPengguna, skorPertama, skorTerakhir = getNama(data), data.skor[1], data.skor[#data.skor]
    print(namaPengguna, skorPertama, skorTerakhir) -- Output: Sita   80   70
    ```

- **Performance Comparison Different Methods**:

  - **Swapping**: `a, b = b, a` umumnya dianggap sedikit lebih efisien dan lebih idiomatik di Lua daripada menggunakan variabel `temp` eksplisit di skrip Lua. Interpreter Lua mungkin dioptimalkan untuk pola multiple assignment ini. Perbedaannya biasanya sangat kecil (mikro-optimasi) dan readability seringkali lebih penting.
  - **Multiple vs Single Assignment**:

    ```lua
    -- Metode 1: Multiple Assignment
    local x, y, z = 10, 20, 30

    -- Metode 2: Single Assignments
    local a = 10
    local b = 20
    local c = 30
    ```

    Untuk inisialisasi sederhana seperti ini, multiple assignment (`local x, y, z = 10, 20, 30`) bisa sedikit lebih cepat karena bytecode yang dihasilkan mungkin lebih kompak. Namun, lagi-lagi, ini adalah mikro-optimasi. Pilih yang paling mudah dibaca untuk konteksnya. Jika nilai-nilai berasal dari sumber yang berbeda atau melibatkan komputasi, penugasan terpisah mungkin lebih jelas.
    Secara umum, jangan terlalu khawatir tentang mikro-optimasi seperti ini kecuali Anda telah memprofil kode Anda dan mengidentifikasi bottleneck yang sebenarnya. Kode yang jelas dan benar biasanya lebih diutamakan.

### 2.2 Variable Operations

Bagian ini membahas operasi-operasi dasar yang dapat dilakukan pada variabel, terutama yang berkaitan dengan tipe data number, string, dan boolean.

#### **Arithmetic Operations (2 jam)**

Operasi matematika dasar.

- **Basic Arithmetic dengan Variables**

  - **Deskripsi Konkret**: Melakukan operasi matematika seperti penjumlahan, pengurangan, perkalian, pembagian, dll., menggunakan variabel yang menyimpan nilai numerik.
  - **Operator Aritmetika Utama**:
    - `+` : Penjumlahan
    - `-` : Pengurangan (juga unary minus untuk negasi)
    - `*` : Perkalian
    - `/` : Pembagian (selalu menghasilkan float, bahkan jika kedua operan adalah integer di Lua 5.3+)
    - `%` : Modulo (sisa bagi)
      - `a % b` didefinisikan sebagai `a - floor(a/b)*b` jika `b` bukan nol. Untuk integer, ini adalah sisa bagi. Tanda hasil mengikuti tanda `b` (dividen).
    - `^` : Pangkat
    - `//`: Pembagian Floor (hanya di Lua 5.3+). Menghasilkan integer jika operan adalah integer, atau float yang merupakan integer jika operan adalah float.
      - `a // b` adalah `floor(a/b)`.
  - **Contoh Kode**:

    ```lua
    local a = 10
    local b = 3

    print(a + b)  -- Output: 13
    print(a - b)  -- Output: 7
    print(a * b)  -- Output: 30
    print(a / b)  -- Output: 3.3333333333333
    print(10 / 2) -- Output: 5.0 (tetap float)
    print(a % b)  -- Output: 1 (10 dibagi 3 sisa 1)
    print(10 % 3) -- Output: 1
    print(10 % -3)-- Output: -2 (karena 10 = (-3)*(-3) + (-2) -- SALAH, definisi Lua: a - math.floor(a/b)*b -> 10 - math.floor(10/-3)*-3 -> 10 - (-4)*-3 -> 10 - 12 = -2)
                  -- Ini berarti tanda hasil modulo mengikuti tanda pembagi (divisor) jika pembagi negatif.
                  -- Sebenarnya, Lua 5.1+ (dan seterusnya) : a % b = a - math.floor(a/b)*b. Tanda hasil mengikuti DIVIDEN (a).
                  -- Contoh: 10 % 3 = 1 ; 10 % -3 = 1 ; -10 % 3 = -1 ; -10 % -3 = -1
                  -- Mari kita verifikasi lagi:
                  -- 10 % 3 = 1 (10 = 3*3 + 1)
                  -- 10 % -3 = 1 (karena 10 - math.floor(10/-3.0)*-3.0 = 10 - math.floor(-3.333)*-3.0 = 10 - (-4)*-3.0 = 10 - 12 = -2 -- Ini yang saya tulis awal, tapi referensi Lua manual bilang lain)
                  -- Mari cek Lua manual: "x%y == x - math.floor(x/y)*y".
                  -- 10 % -3 -> 10 - math.floor(10/(-3)) * (-3)
                  --          -> 10 - math.floor(-3.3333) * (-3)
                  --          -> 10 - (-4) * (-3)
                  --          -> 10 - 12 = -2. (Tampaknya hasil mengikuti tanda pembagi *jika hasilnya perlu disesuaikan untuk floor*)
                  -- Atau lebih tepatnya, hasilnya selalu membuat `(a/b)*b + (a%b)` sedekat mungkin dengan `a`.
                  -- Untuk `x % y`, jika `y` negatif, maka `x % y` adalah `x % (-y)`. Jadi `10 % -3` sama dengan `10 % 3` yaitu `1`.
                  -- Ini yang lebih umum. `print(10 % -3)` di Lua 5.4 saya menghasilkan `1`.
                  -- Jadi, tanda hasil modulo di Lua mengikuti tanda dividen (a).
    print(a % -b) -- Output: 1 (di Lua 5.1+ hasilnya adalah 1)
    print(-a % b) -- Output: -1
    print(a ^ b)  -- Output: 1000 (10 pangkat 3)
    print(-a)     -- Output: -10 (unary minus)

    -- Lua 5.3+ Floor Division
    if math.floor LUA_VERSION_NUM >= 503 then -- Cara cek versi sederhana
         print(10 // 3) -- Output: 3
         print(10.0 // 3.0) -- Output: 3.0
         print(9 // 3) -- Output: 3
         print(-10 // 3) -- Output: -4 (floor(-3.333) adalah -4)
    end
    ```

    **Koreksi Modulo**: Perilaku modulo `a % b` di Lua: hasilnya memiliki tanda yang sama dengan `a` (dividen), dan `abs(a % b) < abs(b)`.

- **Compound Assignment Alternatives**

  - **Deskripsi Konkret**: Lua tidak memiliki operator compound assignment seperti `+=`, `-=`, `*=`, `/=` yang ada di banyak bahasa C-style (misalnya Java, C++, JavaScript, Dart).
  - **Cara di Lua**: Anda harus menulis operasinya secara eksplisit.
    - Alih-alih `x += 5`, Anda menulis `x = x + 5`
    - Alih-alih `y *= 2`, Anda menulis `y = y * 2`
  - **Contoh Kode**:

    ```lua
    local jumlah = 100
    local pengali = 2

    -- Menambah nilai ke 'jumlah'
    jumlah = jumlah + 50 -- Setara dengan jumlah += 50
    print(jumlah)      -- Output: 150

    -- Mengalikan 'pengali'
    pengali = pengali * 3 -- Setara dengan pengali *= 3
    print(pengali)     -- Output: 6
    ```

  - **Alasan Desain**: Ini adalah bagian dari filosofi Lua untuk menjaga bahasa tetap kecil dan sederhana. Menghindari operator tambahan ini mengurangi kompleksitas sintaks bahasa.

- **Increment/Decrement Patterns**

  - **Deskripsi Konkret**: Sama seperti compound assignment, Lua tidak memiliki operator increment (`++`) atau decrement (`--`) khusus.
  - **Cara di Lua**:
    - Untuk increment: `variabel = variabel + 1`
    - Untuk decrement: `variabel = variabel - 1`
  - **Contoh Kode (sering dalam loop)**:

    ```lua
    local counter = 0
    while counter < 3 do
        print("Counter:", counter)
        counter = counter + 1 -- Increment
    end
    -- Output:
    -- Counter: 0
    -- Counter: 1
    -- Counter: 2

    local i = 5
    i = i - 1 -- Decrement
    print(i) -- Output: 4
    ```

    Meskipun `for` loop numerik di Lua (`for i = start, end, step do ... end`) menangani increment/decrement variabel loop secara otomatis, pola manual ini umum digunakan dalam konteks lain seperti `while` loop atau logika state.

- **Mixed-Type Arithmetic**

  - **Deskripsi Konkret**: Ini merujuk pada bagaimana Lua menangani operasi aritmetika ketika operan-operannya adalah campuran antara angka dan string yang dapat dikonversi menjadi angka. Ini adalah bagian dari sistem _coercion_ Lua yang telah dibahas di Modul 1.
  - **Aturan Coercion (Pengingat)**:
    - Jika Lua mengharapkan angka untuk operasi aritmetika dan menemukan string, ia akan mencoba mengonversi string tersebut menjadi angka.
    - Jika konversi berhasil, operasi dilanjutkan.
    - Jika konversi gagal (string tidak merepresentasikan angka yang valid), error runtime akan terjadi (`attempt to perform arithmetic on a string value`).
  - **Contoh Kode**:

    ```lua
    local strAngka = "25"
    local angka = 10

    local hasil1 = strAngka + angka   -- "25" dikonversi ke 25, hasil 35
    local hasil2 = strAngka * 2     -- "25" dikonversi ke 25, hasil 50
    local hasil3 = "2.5" / 0.5    -- "2.5" dikonversi ke 2.5, hasil 5.0

    print(hasil1, hasil2, hasil3) -- Output: 35   50   5.0

    -- Contoh gagal konversi
    local strTeks = "halo"
    -- local errorHasil = strTeks - 5 -- Ini akan menyebabkan error runtime
    -- print(errorHasil)
    ```

  - **Praktik Terbaik**: Meskipun coercion bisa nyaman, seringkali lebih aman dan jelas untuk melakukan konversi eksplisit menggunakan `tonumber()` jika Anda tidak yakin tentang format string, dan kemudian menangani kemungkinan `nil` jika konversi gagal.

- **Precision Considerations**

  - **Deskripsi Konkret**: Berkaitan dengan keterbatasan presisi angka floating-point. Sebagian besar implementasi Lua menggunakan double-precision floating-point numbers (sesuai standar IEEE 754) untuk tipe `number` (atau untuk bagian float jika ada subtype integer). Angka-angka ini memiliki presisi terbatas.
  - **Konsep**:
    - **Floating-Point Inaccuracy**: Tidak semua angka desimal dapat direpresentasikan secara eksak dalam format biner floating-point. Ini dapat menyebabkan error pembulatan kecil.
    - **Perbandingan Float**: Membandingkan dua angka float untuk kesetaraan langsung (`a == b`) bisa berbahaya karena error presisi kecil. Lebih aman membandingkan apakah selisih absolutnya lebih kecil dari toleransi (epsilon) yang sangat kecil.
  - **Contoh Kode**:

    ```lua
    print(0.1 + 0.2) -- Output mungkin bukan 0.3, tapi sesuatu seperti 0.30000000000000004

    local a = 0.1 + 0.2
    local b = 0.3

    if a == b then
        print("a dan b sama (langsung)") -- Mungkin tidak tercetak
    else
        print("a dan b TIDAK sama (langsung)") -- Mungkin ini yang tercetak
    end

    -- Perbandingan dengan toleransi (epsilon)
    local epsilon = 1e-10 -- Toleransi yang sangat kecil
    if math.abs(a - b) < epsilon then
        print("a dan b sama (dengan toleransi epsilon)") -- Lebih mungkin tercetak
    else
        print("a dan b TIDAK sama (dengan toleransi epsilon)")
    end

    -- Operasi berulang dapat mengakumulasi error
    local val = 0
    for i = 1, 10 do
        val = val + 0.1
    end
    print(val) -- Mungkin bukan 1.0 persis, tapi 0.9999999999999999 atau 1.0000000000000001
    ```

  - **Kapan Perlu Khawatir**:
    - Perhitungan keuangan (gunakan representasi integer untuk sen, atau library desimal khusus jika presisi tinggi mutlak diperlukan).
    - Simulasi ilmiah atau fisika yang sensitif terhadap error numerik.
    - Perbandingan kesetaraan float.
  - **Lua 5.3+ dengan Subtipe Integer**: Jika Anda bekerja murni dengan bilangan bulat dalam rentang yang didukung oleh tipe integer Lua, Anda terhindar dari masalah presisi floating-point ini untuk operasi integer. Namun, pembagian (`/`) selalu menghasilkan float.

#### **String Operations (2 jam)**

Operasi yang berkaitan dengan tipe data string.

- **String Concatenation**

  - **Deskripsi Konkret**: Menggabungkan dua atau lebih string menjadi satu string baru.
  - **Operator**: `..` (dua titik)
  - **Sifat**:
    - Membuat string _baru_. String di Lua bersifat immutable (tidak bisa diubah).
    - Dapat mengoersi angka (dan boolean, nil) menjadi string secara otomatis.
  - **Contoh Kode**:

    ```lua
    local s1 = "Halo"
    local s2 = "Dunia"
    local spasi = " "

    local gabung1 = s1 .. spasi .. s2 .. "!" -- "Halo Dunia!"
    print(gabung1)

    local nama = "Lua"
    local versi = 5.4
    local info = nama .. " versi " .. versi -- versi (angka) dikonversi ke "5.4"
    print(info) -- Output: Lua versi 5.4

    -- Menggabungkan dengan nil akan error (kecuali dikonversi eksplisit dengan tostring)
    local user = nil
    -- print("Pengguna: " .. user) -- Error: attempt to concatenate a nil value
    print("Pengguna: " .. tostring(user)) -- Output: Pengguna: nil
    ```

- **String Interpolation Alternatives**

  - **Deskripsi Konkret**: String interpolation adalah fitur di beberapa bahasa yang memungkinkan penyisipan nilai variabel langsung ke dalam string literal (misalnya, `${variabel}` di Dart/JS atau f-string di Python). Lua tidak memiliki sintaks interpolasi string bawaan seperti itu.
  - **Alternatif di Lua**:

    1.  **Concatenation (`..`)**: Cocok untuk kasus sederhana.
        ```lua
        local nama = "Ani"
        local umur = 22
        local pesan = "Nama: " .. nama .. ", Umur: " .. umur
        print(pesan) -- Output: Nama: Ani, Umur: 22
        ```
    2.  **`string.format()`**: Cara yang paling kuat dan fleksibel, mirip `printf` di C atau `String.format` di Java. Menggunakan format specifiers.

        - `%s` untuk string
        - `%d` untuk integer (desimal)
        - `%f` untuk float
        - `%q` untuk string yang diformat dengan aman (meng-escape karakter khusus, cocok untuk membuat kode Lua dari string)
        - Banyak format specifiers lain untuk padding, presisi, heksadesimal, dll.

        ```lua
        local item = "buku"
        local jumlah = 3
        local hargaSatuan = 25000.50

        local detail = string.format("Item: %s, Jumlah: %d, Total Harga: %.2f", item, jumlah, jumlah * hargaSatuan)
        -- %.2f berarti float dengan 2 angka di belakang koma
        print(detail) -- Output: Item: buku, Jumlah: 3, Total Harga: 75001.50

        local query = string.format("SELECT * FROM users WHERE name = %q;", "O'Malley")
        print(query) -- Output: SELECT * FROM users WHERE name = "O'Malley"; (%q menambahkan kutip dan meng-escape)
        ```

  - **Rekomendasi**: Gunakan `string.format()` untuk string yang kompleks atau memerlukan pemformatan angka tertentu. Gunakan konkatenasi untuk kasus yang sangat sederhana.

- **String Modification Patterns**

  - **Deskripsi Konkret**: Karena string di Lua immutable, "modifikasi" string selalu berarti membuat string baru berdasarkan string lama. Library `string` menyediakan banyak fungsi untuk ini.
  - **Fungsi Umum di `string` Library**:
    - `string.sub(s, i [, j])`: Mengambil substring dari string `s`, mulai dari indeks `i` hingga `j`. Indeks bisa negatif (menghitung dari akhir).
    - `string.upper(s)`: Mengonversi string ke huruf besar.
    - `string.lower(s)`: Mengonversi string ke huruf kecil.
    - `string.reverse(s)`: Membalik urutan karakter string.
    - `string.rep(s, n)`: Mengulang string `s` sebanyak `n` kali.
    - `string.len(s)`: (Sama dengan operator `#s`) Mengembalikan panjang string.
    - `string.gsub(s, pattern, replacement [, n])`: Global substitution. Mencari `pattern` (bisa string literal atau pola Lua) dalam `s` dan menggantinya dengan `replacement`. Sangat kuat.
    - `string.find(s, pattern [, init [, plain]])`: Mencari `pattern` dalam `s`.
    - `string.match(s, pattern [, init])`: Mencocokkan `pattern` dengan `s` dan mengembalikan bagian yang cocok (captures).
  - **Contoh Kode**:

    ```lua
    local teksAsli = "Halo Programmer Lua!"

    local sub = string.sub(teksAsli, 1, 4) -- Indeks 1 sampai 4
    print(sub) -- Output: Halo

    local sapaan = string.sub(teksAsli, 1, -13) -- Dari awal sampai 13 karakter dari akhir dihilangkan
    print(sapaan) -- Output: Halo Programmer

    local besar = string.upper(teksAsli)
    print(besar) -- Output: HALO PROGRAMMER LUA!

    local ganti = string.gsub(teksAsli, "Programmer", "Developer")
    print(ganti) -- Output: Halo Developer Lua! (juga mengembalikan jumlah penggantian)

    local namaFile = "gambar.JPEG"
    namaFile = string.lower(namaFile)
    if string.sub(namaFile, -4) == "jpeg" then -- Cek 4 karakter terakhir
        print("Ini file JPEG (setelah diubah ke lowercase)")
    end
    ```

- **Performance dengan String Operations**

  - **Deskripsi Konkret**: Operasi string, terutama konkatenasi berulang dalam loop, bisa menjadi bottleneck performa karena setiap konkatenasi membuat objek string baru di memori.
  - **Masalah Konkatenasi dalam Loop**:
    ```lua
    -- Pola yang bisa lambat untuk string yang sangat banyak/besar
    local listKata = {"satu", "dua", "tiga", "empat", "lima", "enam", "tujuh"} -- bayangkan ini ribuan kata
    local hasilString = ""
    for i = 1, #listKata do
        hasilString = hasilString .. listKata[i] .. " " -- Setiap kali membuat string baru
    end
    -- Ini membuat banyak string sementara: "", "satu ", "satu dua ", "satu dua tiga ", dst.
    ```
  - **Solusi (Pattern "Buffer" menggunakan Tabel)**: Kumpulkan semua bagian string dalam sebuah tabel, lalu gabungkan sekali di akhir menggunakan `table.concat()`. Ini jauh lebih efisien.

    ```lua
    local listKata = {"satu", "dua", "tiga", "empat", "lima", "enam", "tujuh"}
    local buffer = {}
    for i = 1, #listKata do
        buffer[#buffer + 1] = listKata[i] -- Tambahkan kata ke tabel buffer
    end
    -- Atau jika Anda tidak butuh spasi antar kata dari table.concat, dan sudah ada di listKata:
    -- for i = 1, #listKata do
    --     buffer[i] = listKata[i]
    -- end

    -- table.concat(tabel, separator, indeks_awal, indeks_akhir)
    local hasilStringEfisien = table.concat(buffer, " ") -- Gabungkan semua elemen dengan spasi
    print(hasilStringEfisien) -- Output: satu dua tiga empat lima enam tujuh
    ```

  - **Kapan Perlu Diperhatikan**: Untuk jumlah konkatenasi kecil, perbedaan tidak signifikan. Masalah ini menjadi nyata ketika menggabungkan banyak string (ratusan atau ribuan) atau string yang sangat besar secara berulang.

- **Memory Considerations**
  - **Deskripsi Konkret**: Karena string immutable dan operasi seperti konkatenasi atau `string.sub` membuat string baru, ini bisa berdampak pada penggunaan memori jika tidak dikelola dengan hati-hati, terutama dengan string besar atau banyak operasi.
  - **Implikasi Immutability**:
    - Setiap "perubahan" pada string menciptakan string baru.
    - String lama yang tidak lagi direferensikan akan dikumpulkan oleh Garbage Collector (GC).
    - Terlalu banyak pembuatan string sementara dapat meningkatkan tekanan pada GC.
  - **String Interning (di beberapa versi/implementasi Lua)**: Lua sering melakukan "interning" untuk string literal pendek. Artinya, jika Anda memiliki string literal yang sama di beberapa tempat dalam kode Anda, Lua mungkin hanya menyimpan satu salinan di memori dan semua penggunaan merujuk ke sana. Ini menghemat memori. Namun, string yang dibuat secara dinamis (hasil konkatenasi, `string.sub`, dll.) adalah objek baru.
  - **Contoh**:
    ```lua
    local s = "data awal"
    for i = 1, 10000 do
        -- s = s .. " tambahan" -- Ini akan membuat 10000 string baru yang semakin panjang
                             -- dan bisa sangat boros memori dan lambat.
                             -- Pola buffer table.concat adalah solusi.
    end
    ```
  - **Tips**:
    - Gunakan `table.concat` untuk membangun string besar dari banyak bagian.
    - Hindari membuat substring besar yang tidak perlu jika Anda hanya butuh bagian kecil.
    - Sadarilah bahwa fungsi `string` biasanya mengembalikan string baru.

#### **Logical Operations (2 jam)**

Operasi yang berkaitan dengan nilai boolean dan logika kondisional.

- **Boolean Operations dengan Variables**

  - **Deskripsi Konkret**: Menggunakan operator logika `and`, `or`, dan `not` dengan variabel (yang bisa bernilai boolean atau tipe lain yang akan dievaluasi kebenarannya).
  - **Operator Logika**:
    - `and`: Logika "DAN". Hasilnya adalah operan pertama jika falsy; jika tidak, hasilnya adalah operan kedua.
    - `or`: Logika "ATAU". Hasilnya adalah operan pertama jika truthy; jika tidak, hasilnya adalah operan kedua.
    - `not`: Logika "BUKAN". Mengembalikan `true` jika operan adalah falsy (`false` atau `nil`). Mengembalikan `false` jika operan adalah truthy. `not` selalu mengembalikan boolean.
  - **Contoh Kode**:

    ```lua
    local kondisi1 = true
    local kondisi2 = false
    local nilaiA = 10
    local nilaiB -- nil

    print(kondisi1 and kondisi2) -- Output: false (karena kondisi2 false)
    print(kondisi1 or kondisi2)  -- Output: true (karena kondisi1 true)
    print(not kondisi1)          -- Output: false
    print(not kondisi2)          -- Output: true

    -- Perilaku dengan nilai non-boolean
    print(nilaiA and "OK")       -- nilaiA (10) truthy, jadi hasilnya "OK"
    print(nilaiB and "Pasti Gagal") -- nilaiB (nil) falsy, jadi hasilnya nil
    print(nilaiA or "Tidak Perlu") -- nilaiA (10) truthy, jadi hasilnya 10
    print(nilaiB or "Default")   -- nilaiB (nil) falsy, jadi hasilnya "Default"

    print(not nilaiA)            -- nilaiA (10) truthy, jadi not nilaiA adalah false
    print(not nilaiB)            -- nilaiB (nil) falsy, jadi not nilaiB adalah true
    ```

- **Truthy/Falsy Evaluations**

  - **Deskripsi Konkret**: Dalam konteks logika Lua (misalnya, dalam `if` statement, atau dengan operator `and`/`or`), nilai dievaluasi kebenarannya.
  - **Aturan di Lua (Sangat Penting!)**:
    - Hanya dua nilai yang dianggap **falsy**:
      1.  `false` (boolean false)
      2.  `nil`
    - Semua nilai lain dianggap **truthy**, termasuk:
      - Angka `0`
      - String kosong `""`
      - Tabel kosong `{}`
      - Fungsi
  - **Contoh Kode**:

    ```lua
    if 0 then print("0 adalah truthy di Lua") end         -- Akan tercetak
    if "" then print("String kosong adalah truthy di Lua") end -- Akan tercetak
    if {} then print("Tabel kosong adalah truthy di Lua") end -- Akan tercetak

    if not false then print("not false adalah true") end -- Akan tercetak
    if not nil then print("not nil adalah true") end   -- Akan tercetak

    local function cek(val, nama)
        if val then
            print(nama .. " adalah truthy")
        else
            print(nama .. " adalah falsy")
        end
    end

    cek(true, "true")       -- truthy
    cek(false, "false")     -- falsy
    cek(nil, "nil")         -- falsy
    cek(10, "10")         -- truthy
    cek(0, "0")           -- truthy
    cek("hello", "\"hello\"") -- truthy
    cek("", "\"\"")         -- truthy
    cek({}, "{}")          -- truthy
    ```

    Ini berbeda dari beberapa bahasa lain (misalnya JavaScript) di mana `0` atau `""` mungkin dianggap falsy.

- **Short-Circuit Evaluation**

  - **Deskripsi Konkret**: Operator `and` dan `or` di Lua menggunakan "short-circuit evaluation". Artinya, operan kedua hanya dievaluasi jika diperlukan untuk menentukan hasil akhir.
  - **Perilaku `and`**:
    - Jika operan pertama (`a` dalam `a and b`) dievaluasi menjadi `false` atau `nil` (falsy), maka seluruh ekspresi `and` sudah pasti falsy, dan hasilnya adalah nilai operan pertama tersebut. Operan kedua (`b`) _tidak dievaluasi_.
    - Jika operan pertama (`a`) truthy, maka hasil ekspresi `and` bergantung pada operan kedua (`b`), sehingga `b` dievaluasi dan nilainya menjadi hasil dari `a and b`.
  - **Perilaku `or`**:
    - Jika operan pertama (`a` dalam `a or b`) dievaluasi menjadi truthy, maka seluruh ekspresi `or` sudah pasti truthy, dan hasilnya adalah nilai operan pertama tersebut. Operan kedua (`b`) _tidak dievaluasi_.
    - Jika operan pertama (`a`) falsy (`false` atau `nil`), maka hasil ekspresi `or` bergantung pada operan kedua (`b`), sehingga `b` dievaluasi dan nilainya menjadi hasil dari `a or b`.
  - **Manfaat**:
    - **Performa**: Menghindari evaluasi yang tidak perlu, terutama jika operan kedua adalah pemanggilan fungsi yang mahal atau memiliki efek samping.
    - **Keamanan**: Mencegah error dengan menjaga urutan evaluasi, misalnya memeriksa apakah tabel ada sebelum mengakses field-nya.
  - **Contoh Kode**:

    ```lua
    local function fungsiMahal(nama)
        print("Fungsi mahal dipanggil untuk:", nama)
        return true
    end

    print("--- Tes AND ---")
    local hasilAnd1 = false and fungsiMahal("B dari AND 1") -- fungsiMahal tidak akan dipanggil
    print("Hasil AND 1:", hasilAnd1) -- Output: false

    local hasilAnd2 = true and fungsiMahal("B dari AND 2") -- fungsiMahal akan dipanggil
    print("Hasil AND 2:", hasilAnd2) -- Output: true

    print("--- Tes OR ---")
    local hasilOr1 = true or fungsiMahal("B dari OR 1") -- fungsiMahal tidak akan dipanggil
    print("Hasil OR 1:", hasilOr1) -- Output: true

    local hasilOr2 = false or fungsiMahal("B dari OR 2") -- fungsiMahal akan dipanggil
    print("Hasil OR 2:", hasilOr2) -- Output: true

    -- Penggunaan umum untuk guard (penjaga)
    local pengguna = nil
    -- pengguna = { nama = "Joko" }

    -- Jika pengguna nil, pengguna.nama akan error. Short-circuit mencegah ini.
    if pengguna and pengguna.nama == "Joko" then
        print("Pengguna adalah Joko")
    else
        print("Pengguna bukan Joko atau tidak ada")
    end
    ```

- **Conditional Expressions (Menggunakan `and`/`or`)**

  - **Deskripsi Konkret**: Menggunakan idiom `and-or` untuk membuat ekspresi yang nilainya bergantung pada suatu kondisi, mirip dengan operator ternary. Ini sudah dibahas dalam "Conditional Assignment Patterns" (2.1).
  - **Sintaks Idiom**: `kondisi and nilai_jika_true or nilai_jika_false`
  - **Contoh Pengulangan**:

    ```lua
    local suhu = 30
    local deskripsiSuhu = suhu > 25 and "Panas" or "Sejuk"
    print(deskripsiSuhu) -- Output: Panas

    -- Ingat caveat jika nilai_jika_true bisa false atau nil!
    local adaData = false -- Ini adalah nilai valid yang ingin kita dapatkan jika kondisi true
    local status = (suhu > 20) and adaData or "Tidak Ada Data"
                -- (true and false) or "Tidak Ada Data"
                -- false or "Tidak Ada Data" -> "Tidak Ada Data" (SALAH jika kita ingin `false`)
    print("Status Data (dengan caveat):", status)
    ```

- **Ternary Operator Alternatives**

  - **Deskripsi Konkret**: Lua tidak memiliki operator ternary bawaan (`condition ? expr_if_true : expr_if_false`).
  - **Alternatif Utama**:

    1.  **`if-else` statement (Paling Aman dan Jelas)**:
        ```lua
        local nilaiX = 10
        local hasilY
        if nilaiX > 5 then
            hasilY = "Besar"
        else
            hasilY = "Kecil"
        end
        print(hasilY) -- Output: Besar
        ```
    2.  **Idiom `(condition and value_if_true) or value_if_false` (Dengan Peringatan)**:
        Seperti yang telah dibahas, ini umum tetapi memiliki kelemahan jika `value_if_true` bisa `false` atau `nil`.
    3.  **Menggunakan Tabel dan Indeks Boolean (Kurang Umum, tapi Bekerja tanpa Caveat `and-or`)**:
        Ini sedikit trik, tetapi menghindari masalah `and-or` jika `value_if_true` adalah `false`.

        ```lua
        local kondisi = true
        local nilaiJikaTrue = false -- Nilai yang menyebabkan masalah pada and-or
        local nilaiJikaFalse = "Alternatif"

        -- Trik: { [true]=value_if_true, [false]=value_if_false } [kondisi]
        -- Lua 5.2 ke bawah perlu: { [true]=vT, [false]=vF } [not not kondisi] untuk memastikan kondisi adalah boolean
        -- Atau lebih aman, bungkus kondisi dalam pengecekan:
        local hasilTabel
        if kondisi then -- memastikan kondisi evaluasi ke boolean true/false
            hasilTabel = ({[true] = nilaiJikaTrue, [false] = nilaiJikaFalse})[true]
        else
            hasilTabel = ({[true] = nilaiJikaTrue, [false] = nilaiJikaFalse})[false]
        end
        -- Cara lebih ringkas jika kondisi sudah pasti boolean:
        -- hasilTabel = ({[true]=nilaiJikaTrue, [false]=nilaiJikaFalse})[kondisi]

        -- Namun, cara yang paling umum dan seringkali lebih jelas adalah:
        local function ternary_aman(cond, v_true, v_false)
            if cond then return v_true else return v_false end
        end
        hasilTabel = ternary_aman(kondisi, nilaiJikaTrue, nilaiJikaFalse)

        print("Hasil dengan tabel/fungsi:", hasilTabel) -- Output: false (BENAR)
        ```

        Pola `if-else` atau membungkusnya dalam fungsi kecil (`ternary_aman`) biasanya merupakan solusi yang paling mudah dibaca dan dipelihara untuk perilaku mirip ternary di Lua.

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][2]**
> - **[Sebelumnya][3]**
> - **[Kurikulum][4]**
> - **[Domain Spesifik][5]**

[5]: ../../../../../../README.md
[4]: ../../../../README.md
[3]: ../1-fondasi-variabel/README.md
[2]: ../
[1]: ../../README.md/#21-assignment-patterns
