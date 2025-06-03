# **[Modul 3: Scope dan Lifetime (Minggu 3)][1]**

Modul ini akan membawa Anda lebih dalam untuk memahami di mana saja sebuah variabel dapat diakses (scope) dan berapa lama sebuah variabel ada dalam memori (lifetime).

### 3.1 Variable Scope

Scope menentukan visibilitas atau jangkauan akses sebuah variabel. Lua memiliki aturan scope yang jelas, terutama perbedaan antara variabel global dan lokal.

#### **Global Variables (3 jam)**

- **Global Scope Characteristics**

  - **Deskripsi Konkret**: Variabel global adalah variabel yang dapat diakses dari mana saja dalam program Lua Anda, baik itu di level utama skrip, di dalam fungsi, atau di dalam blok kode lainnya, kecuali jika ada variabel lokal dengan nama yang sama yang "menutupi" (shadowing) variabel global tersebut.
  - **Terminologi & Konsep**:
    - **Scope (Lingkup)**: Wilayah dalam kode di mana sebuah identifier (nama variabel, fungsi, dll.) valid dan dapat digunakan.
    - **Global Scope**: Lingkup terluar dalam sebuah program. Identifier yang dideklarasikan di sini dapat diakses dari mana saja.
    - **Environment (Lingkungan)**: Di Lua, variabel global disimpan dalam sebuah tabel khusus yang disebut environment table.
  - **Karakteristik Utama**:
    1.  **Akses Universal**: Dapat diakses dan dimodifikasi dari bagian mana pun dalam skrip.
    2.  **Penyimpanan**: Disimpan dalam tabel environment global, yang secara default adalah `_G`.
    3.  **Deklarasi Implisit**: Jika Anda menugaskan nilai ke sebuah nama variabel tanpa menggunakan kata kunci `local`, Lua akan menganggapnya sebagai variabel global (atau akan mencari variabel global dengan nama tersebut). Jika tidak ditemukan, Lua akan membuat entri baru di tabel global.
  - **Contoh Kode**:

    ```lua
    namaGlobal = "Saya Global" -- Variabel global dibuat

    function cekGlobal()
        print("Di dalam fungsi:", namaGlobal) -- Mengakses variabel global
        globalLain = "Dibuat di fungsi, tapi tetap global" -- Variabel global baru
    end

    cekGlobal()
    print("Di luar fungsi:", namaGlobal)
    print("Global lain:", globalLain)
    -- Output:
    -- Di dalam fungsi: Saya Global
    -- Di luar fungsi: Saya Global
    -- Global lain: Dibuat di fungsi, tapi tetap global
    ```

- **`_G` Table Understanding**

  - **Deskripsi Konkret**: `_G` (atau `_ENV` di Lua 5.2+ untuk lingkungan saat ini, yang defaultnya merujuk ke tabel global) adalah tabel khusus di Lua yang menyimpan semua variabel global. Saat Anda mendeklarasikan atau mengakses variabel global `x`, Anda sebenarnya sedang mengakses `_G["x"]` (atau `_G.x`).
  - **Terminologi & Konsep**:
    - **Environment Table**: Tabel yang digunakan Lua untuk mencari nama variabel.
    - **`_G`**: Variabel global yang sudah terdefinisi yang menunjuk ke tabel environment global itu sendiri.
    - **`_ENV` (Lua 5.2+)**: Variabel yang menentukan environment untuk sebuah fungsi. Secara default, `_ENV` di scope global adalah tabel global itu sendiri. Konsep `_ENV` lebih lanjut akan dibahas di Modul 5. Untuk sekarang, anggap `_G` sebagai referensi utama ke tabel global.
  - **Cara Kerja**:
    - `x = 10` setara dengan `_G.x = 10` atau `_G["x"] = 10`.
    - `print(x)` setara dengan `print(_G.x)` atau `print(_G["x"])`.
  - **Contoh Kode**:

    ```lua
    variabelSaya = "Halo dari _G"

    print(_G.variabelSaya)  -- Output: Halo dari _G
    print(_G["variabelSaya"]) -- Output: Halo dari _G

    _G.nilaiLain = 123
    print(nilaiLain)        -- Output: 123

    -- _G juga berisi fungsi-fungsi bawaan Lua seperti print, type, dll.
    print(_G.print == print) -- Output: true
    print(type(_G))        -- Output: table
    ```

  - **Iterasi Variabel Global**: Anda bisa mengiterasi isi tabel `_G` untuk melihat semua variabel global (termasuk fungsi bawaan), meskipun ini jarang dilakukan dalam praktik sehari-hari kecuali untuk debugging atau alat introspeksi.
    ```lua
    -- Hati-hati, ini bisa mencetak banyak hal!
    -- for nama, nilai in pairs(_G) do
    --     if type(nilai) ~= "function" and type(nilai) ~= "table" then -- Filter sederhana
    --         print("Global:", nama, "-", nilai)
    --     end
    -- end
    ```

- **Global Variable Creation**

  - **Deskripsi Konkret**: Variabel global dibuat ketika Anda pertama kali menugaskan nilai ke sebuah nama variabel yang belum dideklarasikan sebagai `local` di scope saat itu atau scope yang melingkupinya.
  - **Mekanisme**:
    1.  Lua mencari variabel lokal dengan nama tersebut.
    2.  Jika tidak ada lokal, Lua mencari variabel global (entri di tabel `_G`) dengan nama tersebut.
    3.  Jika tidak ada global, Lua akan _membuat_ entri baru di tabel `_G` dengan nama tersebut dan menugaskan nilainya.
  - **Contoh Kode**:

    ```lua
    -- Jika 'counter' belum ada di _G dan bukan lokal, ini akan membuat global 'counter'
    counter = 0
    print(_G.counter) -- Output: 0

    function tambahCounter()
        -- Tidak ada 'local counter' di sini, jadi ini merujuk ke global 'counter'
        counter = counter + 1
    end

    tambahCounter()
    print(counter) -- Output: 1 (global 'counter' termodifikasi)

    -- Jika salah ketik dan tidak menggunakan 'local'
    local skorPemain = 100
    -- skorrPemain = 110 -- Salah ketik 'skorr' (dua r)
                       -- Ini akan membuat variabel GLOBAL baru bernama 'skorrPemain'
                       -- bukan mengubah 'skorPemain' lokal.
                       -- Ini adalah sumber bug yang umum jika tidak hati-hati.

    -- Untuk menghindari pembuatan global yang tidak disengaja, biasakan mendeklarasikan
    -- variabel dengan 'local' atau pastikan Anda tahu sedang memodifikasi global yang sudah ada.
    ```

    Praktik terbaik untuk mencegah pembuatan global yang tidak disengaja adalah dengan selalu mendeklarasikan variabel baru menggunakan `local`. Beberapa environment pengembangan atau linter bahkan bisa memberi peringatan jika Anda menugaskan ke nama global yang belum dikenal.

- **Accessing Globals Dynamically**

  - **Deskripsi Konkret**: Karena variabel global disimpan dalam tabel `_G`, Anda dapat mengaksesnya secara dinamis menggunakan nama variabel sebagai string kunci.
  - **Sintaks**: `_G[namaVariabelString]`
  - **Penggunaan**: Berguna dalam situasi metaprogramming atau ketika nama variabel yang akan diakses tidak diketahui sampai runtime.
  - **Contoh Kode**:

    ```lua
    pemain1_skor = 100
    pemain2_skor = 150

    function dapatkanSkor(nomorPemain)
        local namaVar = "pemain" .. nomorPemain .. "_skor" -- Membuat nama variabel secara dinamis: "pemain1_skor"
        return _G[namaVar] -- Mengakses variabel global menggunakan string nama
    end

    print(dapatkanSkor(1)) -- Output: 100
    print(dapatkanSkor(2)) -- Output: 150

    -- Menetapkan global secara dinamis
    _G["statusPermainan"] = "Berlangsung"
    print(statusPermainan) -- Output: Berlangsung
    ```

- **Global Pollution Concerns**

  - **Deskripsi Konkret**: "Global pollution" atau polusi global terjadi ketika terlalu banyak variabel dideklarasikan di scope global. Ini dapat menyebabkan beberapa masalah.
  - **Masalah Akibat Polusi Global**:
    1.  **Name Clashes (Konflik Nama)**: Meningkatkan risiko konflik nama antara variabel Anda, variabel dari library, atau bahkan variabel internal Lua. Variabel baru dapat secara tidak sengaja menimpa nilai variabel global yang sudah ada dengan nama yang sama.
    2.  **Reduced Readability & Maintainability**: Sulit untuk melacak dari mana sebuah variabel global berasal atau di mana saja ia dimodifikasi. Kode menjadi kurang modular dan lebih sulit dipahami.
    3.  **Debugging Lebih Sulit**: Ketika terjadi bug terkait nilai variabel, jika variabel tersebut global, sumber perubahan bisa ada di mana saja dalam kode.
    4.  **Coupling (Ketergantungan Antar Modul)**: Modul-modul yang berkomunikasi melalui variabel global menjadi sangat bergantung satu sama lain, mengurangi kemandirian dan reusabilitas modul.
    5.  **Performa**: Akses ke variabel global sedikit lebih lambat daripada akses ke variabel lokal di Lua karena melibatkan pencarian hash di tabel `_G`. (Akan dibahas lebih lanjut).
  - **Contoh Masalah**:

    ```lua
    -- Library A
    -- result = "Hasil dari Library A"

    -- Library B (tidak sadar 'result' sudah ada)
    -- result = "Hasil dari Library B"

    -- Kode Anda
    -- print(result) -- Hasilnya mungkin tidak terduga, tergantung library mana yang terakhir dieksekusi
    ```

  - **Solusi**: Minimalkan penggunaan variabel global. Sebisa mungkin gunakan variabel lokal dan teruskan data antar fungsi melalui parameter dan return values. Gunakan tabel sebagai namespace untuk mengelompokkan variabel dan fungsi terkait (konsep modul).

#### **Local Variables (3 jam)**

Variabel lokal adalah kunci untuk menulis kode Lua yang terstruktur dan efisien.

- **`local` Keyword Usage**

  - **Deskripsi Konkret**: Kata kunci `local` digunakan untuk mendeklarasikan variabel yang scope-nya terbatas pada blok kode tempat ia didefinisikan.
  - **Sintaks**:
    ```lua
    local namaVariabel
    local var1, var2 = nilai1, nilai2
    local var3 = ekspresi
    ```
  - **Manfaat Utama**:
    1.  **Menghindari Polusi Global**: Variabel lokal tidak mencemari tabel global `_G`.
    2.  **Mencegah Konflik Nama**: Mengurangi risiko konflik nama karena scope-nya terbatas.
    3.  **Peningkatan Readability**: Lebih mudah untuk melihat di mana variabel didefinisikan dan digunakan.
    4.  **Potensi Performa Lebih Baik**: Akses ke variabel lokal umumnya lebih cepat daripada global.
    5.  **Memungkinkan Lexical Scoping**: Dasar untuk fitur seperti closure.
  - **Contoh Kode**:

    ```lua
    local x = 10 -- x adalah lokal untuk scope file ini (atau chunk)

    function tesLokal()
        local y = 20 -- y adalah lokal untuk fungsi tesLokal
        print("Di dalam fungsi, x:", x) -- Mengakses x dari scope luar
        print("Di dalam fungsi, y:", y)

        if y > 10 then
            local z = 30 -- z adalah lokal untuk blok if ini
            print("Di dalam if, z:", z)
        end
        -- print(z) -- Error! z tidak dikenal di sini, di luar blok if-nya.
    end

    tesLokal()
    print("Di luar fungsi, x:", x)
    -- print(y) -- Error! y tidak dikenal di sini, lokal di tesLokal.

    -- Output:
    -- Di dalam fungsi, x: 10
    -- Di dalam fungsi, y: 20
    -- Di dalam if, z: 30
    -- Di luar fungsi, x: 10
    ```

  - **Deklarasi Tanpa Inisialisasi**: Variabel lokal yang dideklarasikan tanpa nilai awal akan otomatis bernilai `nil`.
    ```lua
    local data
    print(data) -- Output: nil
    ```

- **Block Scope Boundaries**

  - **Deskripsi Konkret**: Di Lua, "blok" adalah unit dasar untuk scope variabel lokal. Sebuah blok bisa berupa:
    - Seluruh file Lua (disebut _chunk_).
    - Isi dari sebuah fungsi.
    - Badan dari `if`, `elseif`, `else` statement.
    - Badan dari `while`, `repeat ... until`, `for` loop.
    - Blok `do ... end` eksplisit.
  - **Aturan**: Variabel lokal yang dideklarasikan di dalam sebuah blok hanya terlihat (visible) dan dapat diakses dari titik deklarasinya hingga akhir blok tersebut (termasuk blok-blok yang bersarang di dalamnya, kecuali di-shadow).
  - **`do ... end` Blocks**: Digunakan secara eksplisit untuk membuat scope lokal baru, seringkali untuk membatasi masa hidup variabel sementara.
    ```lua
    local a = 1
    do
        local a = 10 -- 'a' ini adalah variabel lokal baru, men-shadow 'a' luar
        local b = 20 -- 'b' hanya ada di dalam blok do ini
        print("Dalam do block, a =", a) -- Output: Dalam do block, a = 10
        print("Dalam do block, b =", b) -- Output: Dalam do block, b = 20
    end
    print("Luar do block, a =", a) -- Output: Luar do block, a = 1 (mengacu ke 'a' luar)
    -- print(b) -- Error! 'b' tidak dikenal di sini
    ```
  - **Contoh dengan Loop**:
    ```lua
    for i = 1, 3 do
        local pesan = "Iterasi ke-" .. i -- 'pesan' lokal untuk setiap iterasi blok for
        print(pesan)
    end
    -- print(pesan) -- Error! 'pesan' tidak dikenal di sini
    -- print(i) -- Variabel loop 'i' juga lokal untuk blok for
    ```

- **Function Parameter Scope**

  - **Deskripsi Konkret**: Parameter yang didefinisikan dalam deklarasi fungsi bertindak sebagai variabel lokal di dalam scope fungsi tersebut. Nilainya diisi oleh argumen yang diberikan saat fungsi dipanggil.
  - **Sifat**:
    - Lokal untuk fungsi.
    - Dibuat saat fungsi dipanggil.
    - Hancur (atau tidak lagi dapat diakses langsung) saat fungsi selesai dieksekusi (masa hidupnya mungkin diperpanjang oleh closure).
  - **Contoh Kode**:

    ```lua
    function sapa(nama, gelar) -- 'nama' dan 'gelar' adalah parameter, bersifat lokal
        local sapaanLengkap = "Halo, " .. gelar .. " " .. nama .. "!"
        print(sapaanLengkap)
        -- nama = "Diubah" -- Ini hanya mengubah 'nama' lokal di dalam fungsi
    end

    local namaSaya = "Budi"
    sapa(namaSaya, "Tn.") -- Output: Halo, Tn. Budi!
    print(namaSaya)      -- Output: Budi (namaSaya di luar tidak terpengaruh)
    -- print(nama)       -- Error! 'nama' (parameter) tidak dikenal di sini
    ```

- **Loop Variable Scope**

  - **Deskripsi Konkret**: Variabel kontrol dalam `for` loop (baik numerik maupun generik) bersifat lokal terhadap blok loop tersebut.
  - **For Numerik**: `for var = start, end, step do ... end`
    - `var` adalah lokal untuk badan loop. Setiap iterasi bisa dianggap memiliki instans `var` sendiri (terutama penting jika `var` ditangkap oleh closure). Nilainya tidak bisa diubah secara manual di dalam loop untuk mempengaruhi iterasi.
  - **For Generik**: `for var1, var2, ... in iteratorFunc, state, initialVal do ... end`
    - `var1, var2, ...` adalah lokal untuk badan loop. Nilainya diperbarui oleh `iteratorFunc` di setiap iterasi.
  - **Contoh Kode**:

    ```lua
    print("--- For Numerik ---")
    for i = 1, 3 do
        print("Dalam loop i:", i) -- 'i' adalah lokal
    end
    -- print(i) -- Error jika di Lua 5.1 (i tidak dikenal). Di Lua 5.0, i akan global jika tidak ada local i.
              -- Di Lua modern (5.1+), variabel loop for selalu lokal.

    local nama = "Luar Loop"
    for nama = 1, 2 do -- 'nama' ini adalah variabel LOKAL BARU yang men-shadow 'nama' luar
        print("Dalam loop, nama (angka):", nama)
    end
    print("Luar loop, nama (string):", nama) -- Output: Luar loop, nama (string): Luar Loop

    print("--- For Generik ---")
    local myTable = {a=1, b=2, c=3}
    for k, v in pairs(myTable) do -- 'k' dan 'v' adalah lokal
        print("Dalam loop generik:", k, v)
    end
    -- print(k, v) -- Error! k dan v tidak dikenal di sini.
    ```

- **Nested Scope Resolution**

  - **Deskripsi Konkret**: Ketika Lua menemui sebuah nama variabel, ia akan mencarinya mulai dari scope terdalam (blok saat ini) dan bergerak keluar ke scope yang melingkupinya secara berurutan, hingga mencapai scope global. Proses ini disebut resolusi nama.
  - **Aturan Pencarian**:
    1.  Cek apakah ada variabel lokal dengan nama tersebut di blok saat ini.
    2.  Jika tidak ada, cek di blok yang melingkupinya secara langsung.
    3.  Ulangi langkah 2 hingga mencapai scope terluar (fungsi terluar atau chunk utama).
    4.  Jika masih tidak ditemukan sebagai lokal, Lua akan menganggapnya sebagai variabel global (mengakses `_G[namaVariabel]`).
  - **Contoh Kode**:

    ```lua
    local varLuar = "Saya di luar"

    function fungsiPertama()
        local varTengah = "Saya di tengah"
        print("F1:", varLuar) -- Menemukan varLuar dari scope di atasnya

        function fungsiKedua()
            local varDalam = "Saya di dalam"
            print("F2:", varLuar)  -- Menemukan varLuar
            print("F2:", varTengah) -- Menemukan varTengah
            print("F2:", varDalam)  -- Menemukan varDalam (lokal saat ini)

            local varLuar = "Shadowing varLuar di F2" -- Ini membuat varLuar BARU yang lokal untuk F2
            print("F2 (shadowed):", varLuar)
        end

        fungsiKedua()
        print("F1 (setelah F2):", varTengah)
    end

    fungsiPertama()
    print("Global Scope:", varLuar)

    -- Output:
    -- F1: Saya di luar
    -- F2: Saya di luar
    -- F2: Saya di tengah
    -- F2: Saya di dalam
    -- F2 (shadowed): Shadowing varLuar di F2
    -- F1 (setelah F2): Saya di tengah
    -- Global Scope: Saya di luar
    ```

#### **Lexical Scoping (2 jam)**

Lexical scoping (juga dikenal sebagai static scoping) adalah aturan scope yang fundamental di Lua.

- **Static Scoping Rules**

  - **Deskripsi Konkret**: "Lexical" atau "static" scoping berarti scope sebuah variabel ditentukan oleh struktur teks (source code) program pada saat kompilasi, bukan oleh bagaimana fungsi dipanggil (runtime call stack, yang merupakan ciri dynamic scoping). Dengan kata lain, di mana sebuah variabel dapat diakses ditentukan oleh di mana ia tertulis dalam kode.
  - **Konsep**: Ketika sebuah fungsi didefinisikan, ia "mengingat" scope tempat ia didefinisikan. Jadi, ketika fungsi tersebut kemudian dijalankan (mungkin dari scope yang berbeda), ia masih memiliki akses ke variabel-variabel yang ada di scope tempat ia _didefinisikan_ (scope leksikalnya).
  - **Implikasi**: Ini memungkinkan fungsi mengakses variabel dari fungsi yang melingkupinya, bahkan setelah fungsi luar tersebut selesai dieksekusi. Ini adalah dasar dari _closures_.
  - **Contoh Kode**:

    ```lua
    local x = 10

    function tampilkanX()
        print(x) -- 'x' di sini selalu merujuk ke 'x' lokal yang didefinisikan di atas,
                 -- tidak peduli dari mana tampilkanX() dipanggil.
    end

    function tesScope()
        local x = 20 -- Ini adalah 'x' yang berbeda, lokal untuk tesScope()
        tampilkanX()   -- Ini akan mencetak 10, bukan 20, karena tampilkanX()
                       -- terikat secara leksikal ke 'x' yang bernilai 10.
        print(x)     -- Ini akan mencetak 20.
    end

    tesScope()
    -- Output:
    -- 10
    -- 20
    ```

- **Variable Shadowing**

  - **Deskripsi Konkret**: Terjadi ketika sebuah variabel yang dideklarasikan di scope dalam memiliki nama yang sama dengan variabel di scope luar. Variabel dalam akan "menutupi" atau "menyembunyikan" (shadow) variabel luar selama ia berada dalam scope-nya. Variabel luar tidak hilang, hanya saja tidak dapat diakses secara langsung dengan nama tersebut dari dalam scope di mana shadowing terjadi.
  - **Contoh Kode**:

    ```lua
    local pesan = "Pesan Global (sebenarnya lokal untuk chunk)"

    function ujiShadow()
        print("Sebelum shadow:", pesan) -- Output: Pesan Global (sebenarnya lokal untuk chunk)

        local pesan = "Pesan Lokal di Fungsi" -- Ini men-shadow 'pesan' luar
        print("Setelah shadow:", pesan)   -- Output: Pesan Lokal di Fungsi

        if true then
            local pesan = "Pesan Sangat Lokal di If" -- Ini men-shadow 'pesan' di fungsi
            print("Di dalam if:", pesan) -- Output: Pesan Sangat Lokal di If
        end

        print("Setelah if, masih di fungsi:", pesan) -- Output: Pesan Lokal di Fungsi
    end

    ujiShadow()
    print("Di luar fungsi:", pesan) -- Output: Pesan Global (sebenarnya lokal untuk chunk)
    ```

  - **Perhatian**: Shadowing bisa menjadi sumber kebingungan jika tidak digunakan dengan hati-hati. Kadang disengaja untuk memberi nama yang lebih relevan pada variabel lokal tanpa khawatir konflik, tetapi bisa juga tidak disengaja dan menyebabkan bug.

- **Scope Chain Resolution**

  - **Deskripsi Konkret**: Ini adalah istilah lain untuk "Nested Scope Resolution" yang telah dibahas. Ketika Lua mencari nilai sebuah variabel, ia mengikuti "rantai scope" (scope chain) dari scope saat ini ke scope yang melingkupinya, hingga ke environment global.
  - **Visualisasi (Konseptual)**:
    ```
    Scope Terdalam (misal, blok 'if' di dalam fungsi terdalam)
        | (cari di sini dulu)
        V
    Scope Fungsi Terdalam
        | (jika tidak ketemu, cari di sini)
        V
    Scope Fungsi yang Melingkupinya
        | (dst...)
        V
    Scope Chunk/File Utama (lokal untuk file)
        | (jika tidak ketemu sebagai lokal)
        V
    Scope Global (_G)
    ```

- **Closure Variable Capture**

  - **Deskripsi Konkret**: Closure adalah fitur inti yang dimungkinkan oleh lexical scoping. Sebuah closure adalah fungsi yang "mengingat" environment tempat ia dibuat, artinya ia memiliki akses ke variabel-variabel lokal dari fungsi luar yang melingkupinya, bahkan setelah fungsi luar tersebut selesai dieksekusi dan variabel-variabel tersebut seharusnya sudah "keluar dari scope" secara normal. Variabel-variabel dari fungsi luar yang diakses oleh fungsi dalam ini disebut "upvalues".
  - **Mekanisme**: Ketika sebuah fungsi dalam (inner function) mereferensikan variabel lokal dari fungsi luar (outer function), Lua memastikan variabel tersebut tetap hidup selama fungsi dalam masih bisa diakses.
  - **Contoh Kode**:

    ```lua
    function pembuatCounter()
        local hitungan = 0 -- 'hitungan' adalah variabel lokal untuk pembuatCounter

        -- Fungsi dalam ini, bersama dengan environment-nya (termasuk 'hitungan'), membentuk closure.
        local function counterIncrement()
            hitungan = hitungan + 1
            return hitungan
        end

        return counterIncrement -- Mengembalikan fungsi dalam
    end

    local c1 = pembuatCounter() -- c1 sekarang adalah closure
    local c2 = pembuatCounter() -- c2 adalah closure lain, dengan 'hitungan'-nya sendiri

    print(c1()) -- Output: 1 ('hitungan' untuk c1 adalah 1)
    print(c1()) -- Output: 2 ('hitungan' untuk c1 adalah 2)

    print(c2()) -- Output: 1 ('hitungan' untuk c2 adalah 1, terpisah dari c1)
    print(c1()) -- Output: 3 ('hitungan' untuk c1 adalah 3)
    ```

    Di sini, `hitungan` adalah variabel lokal untuk `pembuatCounter`. Ketika `pembuatCounter` selesai dan mengembalikan `counterIncrement`, `hitungan` tidak hilang. Ia "ditangkap" oleh closure `counterIncrement` dan tetap ada selama `c1` atau `c2` ada. Setiap panggilan ke `pembuatCounter` menciptakan environment baru, sehingga `c1` dan `c2` memiliki instans `hitungan` yang independen.

- **Upvalue Concepts**

  - **Deskripsi Konkret**: Upvalue adalah istilah yang digunakan Lua untuk merujuk pada variabel lokal eksternal (variabel dari fungsi yang melingkupi) yang diakses oleh sebuah closure. Dari perspektif fungsi dalam, variabel tersebut bukan lokal (karena didefinisikan di luar) dan bukan global, jadi ia adalah "upvalue".
  - **Sifat**:
    - Setiap closure memiliki daftar upvalue-nya sendiri.
    - Lua mengelola masa hidup upvalue ini. Jika beberapa closure menangkap variabel lokal yang sama dari fungsi luar, mereka akan berbagi upvalue yang sama (merujuk ke instans variabel yang sama).
  - **Contoh Kode (Berbagi Upvalue)**:

    ```lua
    function pembuatFungsiDenganUpvalueBersama()
        local dataBersama = 100

        local fungsiA = function()
            dataBersama = dataBersama + 1
            return dataBersama
        end

        local fungsiB = function()
            dataBersama = dataBersama * 2
            return dataBersama
        end

        return fungsiA, fungsiB
    end

    local fA, fB = pembuatFungsiDenganUpvalueBersama()

    print("fA:", fA()) -- fA: 101 (dataBersama menjadi 101)
    print("fB:", fB()) -- fB: 202 (dataBersama yang sama (101) dikali 2, menjadi 202)
    print("fA:", fA()) -- fA: 203 (dataBersama yang sama (202) ditambah 1, menjadi 203)
    ```

    Di sini, `fungsiA` dan `fungsiB` keduanya adalah closure yang menangkap variabel lokal `dataBersama` yang sama dari `pembuatFungsiDenganUpvalueBersama`. Oleh karena itu, mereka berbagi dan memodifikasi instans `dataBersama` yang sama.
    Closures dan upvalues adalah konsep yang sangat kuat di Lua, digunakan untuk stateful functions, object-oriented programming (simulasi private members), dan banyak pola canggih lainnya.

### 3.2 Variable Lifetime

Lifetime atau masa hidup variabel adalah durasi waktu selama eksekusi program di mana sebuah variabel ada di memori dan dapat diakses.

#### **Memory Management (2 jam)**

- **Automatic Garbage Collection**

  - **Deskripsi Konkret**: Seperti dibahas di Modul 1, Lua menggunakan Automatic Garbage Collection (GC). Ini berarti programmer tidak perlu secara manual mengalokasikan dan membebaskan memori untuk objek Lua (seperti tabel, string, fungsi, userdata). GC secara periodik berjalan untuk mengidentifikasi dan membebaskan memori yang ditempati oleh objek yang tidak lagi "reachable" (dapat dijangkau) oleh program.
  - **Jenis GC di Lua**: Implementasi GC Lua biasanya adalah _incremental mark-and-sweep collector_.
    - **Mark Phase**: GC menandai semua objek yang dapat dijangkau mulai dari "root" (misalnya, tabel global, stack register).
    - **Sweep Phase**: GC "menyapu" memori, membebaskan semua objek yang tidak ditandai (tidak terjangkau).
    - **Incremental**: GC melakukan pekerjaannya dalam langkah-langkah kecil (increment) untuk meminimalkan jeda panjang dalam eksekusi program utama.
  - **Fungsi Terkait GC**: Modul `collectgarbage()` menyediakan beberapa kontrol dan informasi tentang GC.
    - `collectgarbage("count")`: Mengembalikan jumlah memori (dalam KB) yang sedang digunakan Lua.
    - `collectgarbage("collect")`: Memaksa siklus pengumpulan sampah penuh.
    - `collectgarbage("step")`: Menjalankan satu langkah GC (jika GC bersifat incremental).
    - `collectgarbage("stop")`, `collectgarbage("restart")`: Menghentikan dan memulai kembali GC.
  - **Contoh**:

    ```lua
    print("Memori awal:", collectgarbage("count"), "KB") -- Mencetak penggunaan memori

    local t = {}
    for i = 1, 10000 do
        t[i] = "string panjang ke-" .. i -- Mengisi tabel dengan banyak data
    end
    print("Memori setelah alokasi:", collectgarbage("count"), "KB")

    t = nil -- Menghapus referensi ke tabel. Tabel sekarang bisa di-GC.
    collectgarbage("collect") -- Memaksa GC (biasanya tidak perlu dilakukan secara manual)
    print("Memori setelah GC:", collectgarbage("count"), "KB")
    ```

- **Variable Lifetime Cycles**

  - **Deskripsi Konkret**: Siklus hidup variabel terkait erat dengan scope dan bagaimana GC bekerja.
  - **Variabel Global**:
    - **Dibuat**: Saat pertama kali ditugaskan nilai (menjadi entri di `_G`).
    - **Hidup**: Selama program berjalan, kecuali jika secara eksplisit dihapus dengan menugaskan `nil` padanya (`namaGlobal = nil`), yang menghapusnya dari `_G`.
    - **Mati/Di-GC**: Objek yang dirujuk oleh variabel global akan tetap hidup selama variabel global itu ada. Jika variabel global di-`nil`-kan, objek yang dirujuknya bisa di-GC jika tidak ada referensi lain ke objek tersebut.
  - **Variabel Lokal**:
    - **Dibuat**: Saat deklarasi `local` dieksekusi.
    - **Hidup**: Selama blok scope tempat ia dideklarasikan aktif.
    - **Mati/Di-GC**: Ketika eksekusi keluar dari blok scope-nya, variabel lokal tersebut "keluar dari scope" dan tidak dapat diakses lagi secara langsung. Objek yang dirujuknya dapat dikumpulkan oleh GC jika tidak ada referensi lain (termasuk dari upvalue closure).
  - **Upvalues (untuk Variabel Lokal yang Ditangkap Closure)**:
    - Jika sebuah variabel lokal ditangkap oleh sebuah closure, masa hidupnya diperpanjang melebihi scope aslinya. Variabel tersebut (atau nilainya) tetap hidup selama closure yang mereferensikannya masih hidup dan dapat dijangkau.

- **Reference Counting Basics (sebagai konsep umum GC)**

  - **Deskripsi Konkret**: Reference counting adalah salah satu teknik GC di mana setiap objek memiliki penghitung yang melacak berapa banyak referensi (variabel atau objek lain) yang menunjuk padanya.
  - **Mekanisme**:
    - Ketika referensi baru dibuat ke objek, hitungannya bertambah.
    - Ketika referensi dihapus (misalnya, variabel keluar dari scope, atau ditugaskan objek lain), hitungannya berkurang.
    - Jika hitungan referensi sebuah objek mencapai nol, objek tersebut dianggap tidak terjangkau dan dapat dibebaskan memorinya.
  - **Kelebihan**: Pembebasan memori bisa cepat dan deterministik (segera setelah hitungan nol).
  - **Kekurangan**:
    - **Overhead**: Setiap operasi penugasan referensi memerlukan update hitungan.
    - **Circular References**: Tidak dapat menangani referensi siklik. Jika objek A merujuk ke B, dan B merujuk kembali ke A, hitungan referensi keduanya tidak akan pernah nol meskipun tidak ada referensi eksternal ke A atau B.
      ```lua
      -- Contoh konseptual circular reference
      -- local a = {}
      -- local b = {}
      -- a.refB = b
      -- b.refA = a
      -- a = nil
      -- b = nil
      -- Jika GC hanya reference counting, a dan b mungkin tidak ter-GC.
      ```
  - **Penting untuk Lua**: GC Lua _bukan_ murni reference counting. Ia menggunakan algoritma seperti mark-and-sweep yang dapat menangani circular references. Namun, memahami konsep reference counting berguna karena membantu memikirkan "keterjangkauan" objek.

- **Weak References Introduction**

  - **Deskripsi Konkret**: Referensi normal (strong reference) dari satu objek ke objek lain mencegah objek yang dirujuk dari pengumpulan sampah. Weak reference adalah jenis referensi yang _tidak_ mencegah objek yang dirujuk dari pengumpulan sampah. Jika satu-satunya referensi ke sebuah objek adalah weak references, objek tersebut dapat di-GC.
  - **Weak Tables di Lua**: Lua mengimplementasikan weak references melalui "weak tables". Sebuah tabel dapat memiliki kunci weak, nilai weak, atau keduanya.
    - **`mode = "k"`**: Kunci bersifat weak. Jika sebuah kunci objek hanya direferensikan oleh tabel ini (sebagai kunci weak), kunci tersebut dapat di-GC. Ketika kunci di-GC, entri key-value tersebut dihapus dari tabel.
    - **`mode = "v"`**: Nilai bersifat weak. Jika sebuah nilai objek hanya direferensikan oleh tabel ini (sebagai nilai weak), nilai tersebut dapat di-GC. Ketika nilai di-GC, entri key-value tersebut dihapus dari tabel (atau nilai dalam entri bisa menjadi `nil`, tergantung implementasi).
    - **`mode = "kv"`**: Kunci dan nilai keduanya bersifat weak.
  - **Penggunaan**: Berguna untuk membuat cache, asosiasi data ke objek tanpa mencegah objek tersebut di-GC, atau mengelola objek yang masa hidupnya tidak dikontrol secara langsung.
  - **Sintaks (menggunakan metatable `__mode`)**:

    ```lua
    local weakTableKunci = {}
    setmetatable(weakTableKunci, {__mode = "k"}) -- Kunci bersifat weak

    local objekKunci = {data = "kunci sementara"}
    weakTableKunci[objekKunci] = "Nilai terkait kunci"

    print(weakTableKunci[objekKunci]) -- Output: Nilai terkait kunci

    -- Sekarang, hapus satu-satunya referensi kuat ke objekKunci
    objekKunci = nil

    -- Paksa GC (untuk demonstrasi, dalam praktik GC berjalan otomatis)
    collectgarbage("collect")
    collectgarbage("collect") -- Kadang perlu >1 kali agar efek weak table terlihat

    -- Setelah objekKunci di-GC, entri di weakTableKunci akan hilang
    -- Mencoba mencetak isi weakTableKunci mungkin menunjukkan entri sudah tidak ada
    -- (cara pasti untuk mengecek adalah iterasi atau mencari kunci spesifik)
    -- for k, v in pairs(weakTableKunci) do print("Sisa di weak table:", k, v) end
    -- Outputnya akan kosong jika objekKunci sudah di-GC dan entri dihapus.
    ```

    Weak tables adalah konsep yang lebih lanjut dan akan dieksplorasi lagi di Modul Lanjutan jika ada.

- **Memory Leak Prevention**
  - **Deskripsi Konkret**: Memory leak terjadi ketika program secara tidak sengaja terus memegang referensi ke objek yang sebenarnya sudah tidak diperlukan lagi, sehingga mencegah GC membebaskan memori objek tersebut. Akibatnya, penggunaan memori program terus meningkat seiring waktu.
  - **Penyebab Umum di Lua**:
    1.  **Global Variables Tidak Di-`nil`-kan**: Variabel global yang menyimpan objek besar (misalnya, tabel berisi banyak data) dan tidak pernah di-`nil`-kan setelah tidak digunakan lagi.
    2.  **Referensi dalam Tabel**: Tabel yang terus menyimpan referensi ke objek, bahkan setelah objek tersebut secara logis sudah tidak relevan (misalnya, cache yang tidak pernah dibersihkan, listener yang tidak di-unregister).
    3.  **Closures Menangkap Variabel Besar**: Closure yang tetap hidup (misalnya, callback yang terdaftar) menangkap variabel (upvalue) yang merujuk ke objek besar, menjaga objek tersebut tetap hidup.
    4.  **Circular References (tanpa Weak Tables)**: Meskipun GC Lua bisa menangani circular references antar objek Lua, jika ada circular references yang melibatkan C userdata yang tidak dikelola dengan benar oleh GC Lua, ini bisa menjadi masalah.
  - **Strategi Pencegahan**:
    - **Minimalkan Global**: Gunakan variabel lokal sebisa mungkin.
    - **Bersihkan Referensi**: Jika variabel global atau field tabel menyimpan objek besar yang tidak lagi dibutuhkan, set nilainya ke `nil` untuk memungkinkan GC.
      ```lua
      dataBesarGlobal = { ...banyak data... }
      -- ...gunakan dataBesarGlobal...
      dataBesarGlobal = nil -- Penting setelah selesai!
      ```
    - **Gunakan Weak Tables**: Untuk cache atau asosiasi data di mana Anda tidak ingin mencegah objek utama di-GC.
    - **Kelola Listener/Callback**: Pastikan untuk membatalkan pendaftaran (unregister) callback atau listener ketika objek yang terkait sudah tidak ada, agar closure callback tidak menahan referensi yang tidak perlu.
    - **Perhatikan Upvalues**: Sadari variabel apa saja yang ditangkap oleh closure yang memiliki masa hidup panjang.

#### **Scope Best Practices (2 jam)**

Praktik terbaik dalam mengelola scope variabel untuk kode yang lebih baik.

- **Minimizing Global Usage**

  - **Mengapa**: Seperti dibahas dalam "Global Pollution Concerns", penggunaan global yang berlebihan menyebabkan masalah readability, maintainability, konflik nama, dan potensi performa.
  - **Cara**:

    - **Selalu Gunakan `local`**: Deklarasikan semua variabel sebagai `local` secara default, kecuali ada alasan yang sangat spesifik untuk menjadikannya global (misalnya, fungsi utama modul yang memang diekspos).
    - **Modul dan Namespace**: Kelompokkan fungsionalitas terkait ke dalam tabel (yang bisa jadi lokal), lalu ekspos tabel tersebut jika perlu, daripada mengekspos banyak fungsi/variabel global individual.

      ```lua
      -- Pola modul sederhana
      local M = {} -- Tabel modul bersifat lokal

      M.dataPenting = 123
      function M.lakukanSesuatu()
          return M.dataPenting * 2
      end

      -- Jika perlu diekspos global (jarang, biasanya return M dari file modul)
      -- MyModule = M
      -- Atau, jika ini adalah file modul: return M
      ```

    - **Parameter dan Return Values**: Lewatkan data antar fungsi menggunakan parameter dan nilai kembalian, bukan melalui variabel global.

- **Appropriate Local Usage**

  - **Prinsip Least Scope (Lingkup Terkecil)**: Deklarasikan variabel lokal sedekat mungkin dengan tempat ia pertama kali digunakan dan dalam scope sekecil mungkin yang masih mencakup semua penggunaannya.
  - **Manfaat**:
    - Mengurangi "jarak" antara deklarasi dan penggunaan, meningkatkan keterbacaan.
    - Meminimalkan masa hidup variabel, yang bisa membantu GC lebih cepat (meskipun dampak GC biasanya lebih besar untuk objek daripada variabel itu sendiri).
    - Mengurangi risiko shadowing yang tidak disengaja atau penggunaan variabel yang salah.
  - **Contoh**:

    ```lua
    function prosesData(dataList)
        -- Buruk: 'total' dideklarasikan terlalu awal jika hanya dipakai di loop nanti
        -- local total = 0

        if not dataList then
            local pesanError = "Data list tidak ada!" -- Baik: 'pesanError' hanya ada di blok ini
            print(pesanError)
            return
        end

        local total = 0 -- Baik: dideklarasikan tepat sebelum loop yang menggunakannya
        for i = 1, #dataList do
            local item = dataList[i] -- Baik: 'item' lokal untuk setiap iterasi
            if type(item) == "number" then
                total = total + item
            end
        end
        return total
    end
    ```

- **Performance Implications (Local vs Global Access Speed)**

  - **Akses Lokal Lebih Cepat**: Di Lua, mengakses variabel lokal umumnya lebih cepat daripada mengakses variabel global.
  - **Alasan**:
    - **Variabel Lokal**: Diimplementasikan sebagai array/register di stack frame fungsi. Aksesnya adalah operasi indeks array langsung, sangat cepat.
    - **Variabel Global**: Disimpan dalam tabel `_G`. Aksesnya melibatkan pencarian hash string di tabel tersebut, yang meskipun dioptimalkan, tetap lebih lambat daripada akses array langsung.
  - **Caching Global ke Lokal (Optimasi Umum)**: Jika Anda mengakses fungsi atau nilai global berulang kali dalam loop yang ketat performa, Anda bisa mendapatkan sedikit peningkatan kecepatan dengan menugaskannya ke variabel lokal di luar loop.
    ```lua
    -- Misalkan math.sin akan dipanggil ribuan kali dalam loop
    -- local sin = math.sin -- Cache fungsi global ke lokal
    -- for i = 1, 100000 do
    --     local hasil = sin(i * 0.01) -- Menggunakan 'sin' lokal
    --     -- ...
    -- end
    ```
  - **Peringatan**: Jangan melakukan optimasi ini secara prematur. Perbedaannya seringkali kecil dan mungkin tidak signifikan kecuali di bagian kode yang sangat kritis performa (hot path). Keterbacaan lebih utama. Profil kode Anda terlebih dahulu untuk menemukan bottleneck sebenarnya.

- **Code Maintainability**

  - **Bagaimana Scope Mempengaruhi**: Penggunaan scope yang baik (variabel lokal, lingkup terkecil) secara signifikan meningkatkan kemudahan pemeliharaan kode.
  - **Keuntungan**:
    - **Lebih Mudah Dipahami**: Jelas dari mana variabel berasal dan di mana saja ia relevan.
    - **Modifikasi Lebih Aman**: Mengubah variabel lokal memiliki risiko dampak yang lebih kecil ke bagian lain kode dibandingkan mengubah variabel global.
    - **Refactoring Lebih Mudah**: Bagian kode yang menggunakan variabel lokal lebih mudah dipindahkan atau diubah menjadi fungsi/modul terpisah.
    - **Debugging Lebih Sederhana**: Lingkup yang terbatas mempersempit area pencarian saat melacak bug terkait variabel.

- **Debugging Scope Issues**
  - **Masalah Umum**:
    - **Variabel `nil` yang Tidak Terduga**: Seringkali karena salah ketik nama variabel (membuat global implisit yang `nil` di tempat lain), atau variabel keluar dari scope.
    - **Shadowing Tidak Disengaja**: Variabel lokal menutupi variabel luar dengan nama yang sama, menyebabkan perilaku yang tidak diharapkan.
    - **Modifikasi Global yang Salah**: Variabel global diubah di tempat yang tidak terduga.
  - **Teknik Debugging**:
    - **`print()` Statements**: Cara paling dasar. Cetak nilai variabel di berbagai titik untuk memahami nilainya dan dari mana ia berasal. Cetak `type(variabel)` juga.
    - **Linter/Static Analyzer**: Alat seperti `luacheck` dapat membantu mendeteksi variabel global yang tidak dideklarasikan, shadowing, variabel lokal yang tidak terpakai, dll., sebelum runtime.
    - **Debugger**: Gunakan debugger interaktif (jika tersedia untuk environment Lua Anda, misalnya ZeroBrane Studio, atau plugin VS Code dengan adapter debug) untuk melangkah melalui kode, memeriksa nilai variabel, dan melihat call stack.
    - **Periksa `_G`**: Jika curiga ada polusi global, Anda bisa (dengan hati-hati) menginspeksi tabel `_G` untuk melihat variabel apa saja yang ada.
    - **Jadikan Lokal Lebih Dulu**: Saat ragu, selalu mulai dengan `local`. Jika Anda butuh akses dari scope yang lebih luas, baru pertimbangkan bagaimana mengeksposnya (misalnya, return value, parameter, atau, sebagai pilihan terakhir, global yang terencana).

#### **Praktik (3 jam)**

Kurikulum menyarankan latihan untuk memperkuat pemahaman scope dan lifetime.

- **Scope Debugging Exercises**:

  - Ambil potongan kode dengan bug terkait scope (misalnya, shadowing yang salah, penggunaan global yang tidak disengaja) dan coba temukan serta perbaiki.
  - Contoh Skenario Bug:

    ```lua
    -- Skenario 1: Salah ketik dan global implisit
    local totalSkor = 0
    function tambahPoin(poin)
        -- totalSkorr = totalSkor + poin -- Salah ketik 'totalSkorr'
        totalSkor = totalSkor + poin -- Perbaikan
    end
    tambahPoin(10)
    print(totalSkor) -- Jika salah, mungkin 0. Jika benar, 10.
    -- print(_G.totalSkorr) -- Jika salah ketik, ini akan punya nilai.

    -- Skenario 2: Shadowing
    local level = "mudah"
    function setLevel(newLevel)
        -- Ingin mengubah 'level' luar, tapi malah membuat lokal baru
        -- local level = newLevel -- Ini men-shadow 'level' luar
        level = newLevel -- Perbaikan: jangan pakai 'local' jika ingin akses scope luar
    end
    setLevel("sulit")
    print(level) -- Jika shadowing, tetap "mudah". Jika benar, "sulit".
    ```

- **Performance Testing Local vs Global**:

  - Buat loop yang sangat ketat yang mengakses variabel global berulang kali. Ukur waktunya.
  - Buat loop serupa yang mengakses variabel lokal yang sama (atau fungsi global yang dicache ke lokal). Ukur waktunya.
  - Gunakan `os.clock()` untuk pengukuran waktu sederhana.

    ```lua
    -- Contoh sederhana (hasil bisa bervariasi tergantung implementasi Lua & OS)
    -- Variabel global
    myGlobalVar = 10

    local function tesGlobal()
        local startTime = os.clock()
        local temp
        for i = 1, 20000000 do -- Loop besar
            temp = myGlobalVar
        end
        local endTime = os.clock()
        print("Waktu Akses Global:", endTime - startTime)
    end

    local function tesLokal()
        local myLocalVar = 10 -- Sama dengan myGlobalVar
        local startTime = os.clock()
        local temp
        for i = 1, 20000000 do -- Loop besar
            temp = myLocalVar
        end
        local endTime = os.clock()
        print("Waktu Akses Lokal:", endTime - startTime)
    end

    tesGlobal()
    tesLokal()
    ```

- **Memory Usage Monitoring (Konseptual)**:
  - Gunakan `collectgarbage("count")` sebelum dan sesudah membuat banyak objek atau menghapus referensi ke objek besar untuk melihat dampaknya (setelah memaksa GC jika perlu untuk observasi langsung).
  - Eksperimen dengan weak tables: Buat tabel dengan banyak objek, lalu buat weak table yang merujuk objek yang sama. Hapus referensi kuat, paksa GC, dan lihat apakah memori dari weak table berkurang (atau entri hilang).
- **Closure Creation Patterns**:

  - Buat fungsi yang mengembalikan closure yang mempertahankan state (seperti contoh `pembuatCounter`).
  - Buat beberapa closure dari fungsi pembuat yang sama dan amati bagaimana state mereka independen.
  - Buat fungsi yang mengembalikan beberapa closure yang berbagi upvalue yang sama (seperti contoh `pembuatFungsiDenganUpvalueBersama`). Amati bagaimana modifikasi melalui satu closure mempengaruhi yang lain.

    ```lua
    function pengelolaSaldo(saldoAwal)
        local saldo = saldoAwal or 0

        local tambah = function(jumlah)
            saldo = saldo + jumlah
            return saldo
        end

        local kurang = function(jumlah)
            if saldo >= jumlah then
                saldo = saldo - jumlah
                return saldo
            else
                return "Saldo tidak cukup"
            end
        end

        local cekSaldo = function()
            return saldo
        end

        return tambah, kurang, cekSaldo
    end

    local tmbhA, krgA, cekA = pengelolaSaldo(100)
    local tmbhB, krgB, cekB = pengelolaSaldo(50)

    print("A tambah 50:", tmbhA(50)) -- Saldo A: 150
    print("B tambah 10:", tmbhB(10)) -- Saldo B: 60
    print("A kurang 20:", krgA(20)) -- Saldo A: 130
    print("Cek Saldo A:", cekA())  -- Saldo A: 130
    print("Cek Saldo B:", cekB())  -- Saldo B: 60
    ```

---

Pembahasan Modul 3 mengenai Scope dan Lifetime telah selesai. Konsep-konsep ini, terutama variabel lokal, lexical scoping, dan closure, adalah pilar penting dalam pemrograman Lua yang efektif.

#

> - **[Ke Atas](#)**

<!-- > - **[Selanjutnya][2]** -->

> - **[Sebelumnya][3]**
> - **[Kurikulum][4]**
> - **[Domain Spesifik][5]**

[5]: ../../../../../../README.md
[4]: ../../../../README.md
[3]: ../2-assignment-patterns/README.md

<!-- [2]: ../ -->

[1]: ../../README.md/#31-variable-scope
