# **[Modul 4: Advanced Variable Concepts (Minggu 4)][1]**

Modul ini bertujuan untuk memberikan pemahaman tentang bagaimana Lua menangani referensi ke data, bagaimana data bisa di-alias, serta konsep mutabilitas dan cara-cara untuk menciptakan struktur data yang bersifat (atau seolah-olah bersifat) immutable.

### 4.1 Variable References dan Aliasing

Bagian ini akan menjelaskan perbedaan antara tipe nilai dan tipe referensi di Lua, bagaimana aliasing bekerja, dan berbagai mekanisme untuk menyalin data.

#### **Reference Semantics (3 jam)**

- **Value vs Reference Types**

  - **Deskripsi Konkret**: Di Lua, tipe data dapat dikategorikan berdasarkan bagaimana nilainya disimpan dan diteruskan.
    - **Tipe Nilai (Value Types)**: Variabel yang bertipe nilai menyimpan nilai data itu sendiri secara langsung. Ketika Anda menugaskan variabel tipe nilai ke variabel lain, atau meneruskannya ke fungsi, salinan dari nilai tersebut yang dibuat. Tipe data di Lua yang berperilaku sebagai tipe nilai adalah: `nil`, `boolean`, dan `number`.
    - **Tipe Referensi (Reference Types)**: Variabel yang bertipe referensi tidak menyimpan data objek secara langsung, melainkan menyimpan sebuah "referensi" atau "pointer" ke lokasi objek tersebut di memori. Ketika Anda menugaskan variabel tipe referensi ke variabel lain, atau meneruskannya ke fungsi, hanya referensinya yang disalin, bukan objek datanya itu sendiri. Kedua variabel tersebut akan menunjuk ke objek data yang sama di memori. Tipe data di Lua yang berperilaku sebagai tipe referensi adalah: `table`, `function`, `userdata`, dan `thread`.
  - **Terminologi & Konsep**:
    - **Semantik Nilai (Value Semantics)**: Operasi pada variabel (seperti assignment atau passing ke fungsi) bekerja pada salinan independen dari data.
    - **Semantik Referensi (Reference Semantics)**: Operasi pada variabel bekerja pada referensi ke data asli, sehingga perubahan melalui satu referensi akan terlihat oleh referensi lain yang menunjuk ke data yang sama.
  - **Contoh Kode**:

    ```lua
    -- Tipe Nilai (Number)
    local a = 10
    local b = a  -- 'b' mendapatkan salinan nilai dari 'a'

    b = 20       -- Mengubah 'b' tidak mempengaruhi 'a'
    print("Tipe Nilai:")
    print("a =", a)  -- Output: a = 10
    print("b =", b)  -- Output: b = 20

    -- Tipe Referensi (Table)
    local t1 = { value = 100 }
    local t2 = t1 -- 't2' mendapatkan salinan referensi dari 't1', keduanya menunjuk ke tabel yang sama

    t2.value = 200 -- Mengubah isi tabel melalui 't2'
    print("\nTipe Referensi:")
    print("t1.value =", t1.value) -- Output: t1.value = 200 (terpengaruh)
    print("t2.value =", t2.value) -- Output: t2.value = 200

    -- Perbandingan referensi
    local t3 = { value = 200 }
    print(t1 == t2) -- Output: true (t1 dan t2 merujuk ke objek yang sama)
    print(t1 == t3) -- Output: false (t1 dan t3 merujuk ke objek tabel yang berbeda, meskipun isinya sama)
    ```

- **Table Reference Behavior**

  - **Deskripsi Konkret**: Tabel di Lua adalah tipe referensi. Ketika Anda menugaskan satu variabel tabel ke variabel lain, Anda hanya menyalin referensinya. Modifikasi pada tabel melalui satu variabel akan terlihat oleh variabel lain yang mereferensikan tabel yang sama.
  - **Implikasi**:
    - Meneruskan tabel ke fungsi: Fungsi menerima referensi ke tabel asli. Jika fungsi memodifikasi isi tabel tersebut, perubahan tersebut akan permanen dan terlihat di luar fungsi.
    - Beberapa variabel dapat "memiliki" tabel yang sama.
  - **Contoh Kode**:

    ```lua
    local dataSaya = { nama = "Alice", umur = 30 }

    function ubahUmur(tabelData, umurBaru)
        -- 'tabelData' di sini adalah referensi ke 'dataSaya'
        tabelData.umur = umurBaru
        tabelData.status = "Diubah" -- Menambah field baru juga akan terlihat
    end

    local referensiLain = dataSaya -- referensiLain juga menunjuk ke tabel yang sama

    print("Sebelum diubah:", referensiLain.nama, referensiLain.umur, referensiLain.status)
    -- Output: Sebelum diubah: Alice   30   nil

    ubahUmur(dataSaya, 31)

    print("Setelah diubah (via dataSaya):", dataSaya.nama, dataSaya.umur, dataSaya.status)
    -- Output: Setelah diubah (via dataSaya): Alice   31   Diubah
    print("Setelah diubah (via referensiLain):", referensiLain.nama, referensiLain.umur, referensiLain.status)
    -- Output: Setelah diubah (via referensiLain): Alice   31   Diubah
    ```

- **Function Reference Behavior**

  - **Deskripsi Konkret**: Fungsi di Lua juga merupakan tipe referensi (dan first-class values). Variabel yang menyimpan fungsi sebenarnya menyimpan referensi ke objek fungsi tersebut.
  - **Implikasi**:
    - Anda dapat memiliki beberapa nama variabel yang merujuk ke fungsi yang sama.
    - Fungsi dapat disimpan dalam tabel, diteruskan sebagai argumen, dan dikembalikan dari fungsi lain, semua melalui referensinya.
  - **Contoh Kode**:

    ```lua
    local function sapaAsli(nama)
        print("Halo, " .. nama .. "!")
    end

    local sapaAlias = sapaAsli -- sapaAlias sekarang merujuk ke fungsi yang sama dengan sapaAsli

    sapaAsli("Dunia")   -- Output: Halo, Dunia!
    sapaAlias("Lua")    -- Output: Halo, Lua! (memanggil fungsi yang sama)

    print(sapaAsli == sapaAlias) -- Output: true (keduanya merujuk ke objek fungsi yang sama)

    local operasi = {
        tambah = function(a, b) return a + b end
    }
    local fungsiTambah = operasi.tambah -- fungsiTambah merujuk ke fungsi yang sama di dalam tabel
    print(fungsiTambah(5, 3)) -- Output: 8
    ```

- **Shallow vs Deep Copying**

  - **Deskripsi Konkret**: Ketika Anda ingin membuat salinan dari sebuah tabel (karena tabel adalah tipe referensi, penugasan biasa hanya menyalin referensi), ada dua jenis utama penyalinan:
    - **Shallow Copy (Salinan Dangkal)**: Membuat tabel baru, dan menyalin elemen-elemen dari tabel asli ke tabel baru. Jika elemen-elemen tersebut adalah tipe nilai (number, boolean, string), nilainya disalin. _Namun_, jika elemen-elemen tersebut adalah tipe referensi (misalnya, tabel lain atau fungsi), maka hanya referensinya yang disalin. Artinya, tabel baru dan tabel asli akan berbagi referensi ke sub-objek yang sama.
    - **Deep Copy (Salinan Mendalam)**: Membuat tabel baru, dan secara rekursif menyalin semua elemen. Jika sebuah elemen adalah tipe referensi (seperti sub-tabel), deep copy akan membuat salinan baru dari sub-tabel tersebut juga, dan seterusnya. Hasilnya adalah dua tabel yang sepenuhnya independen, termasuk semua sub-objeknya (kecuali ada circular references yang perlu ditangani khusus).
  - **Terminologi & Konsep**:
    - **Independensi Data**: Deep copy menghasilkan salinan yang sepenuhnya independen. Shallow copy menghasilkan salinan yang masih berbagi beberapa data (sub-objek tipe referensi) dengan aslinya.
  - **Contoh Kode (Shallow Copy)**:

    ```lua
    function shallowCopy(original)
        local copy = {}
        for k, v in pairs(original) do
            copy[k] = v -- Menyalin nilai (jika value type) atau referensi (jika reference type)
        end
        return copy
    end

    local tAsli = {
        a = 1,
        b = "hello",
        c = { x = 10, y = 20 } -- Sub-tabel
    }

    local tShallow = shallowCopy(tAsli)

    -- Mengubah tipe nilai di tShallow tidak mempengaruhi tAsli
    tShallow.a = 2
    print("tAsli.a:", tAsli.a)     -- Output: tAsli.a: 1
    print("tShallow.a:", tShallow.a) -- Output: tShallow.a: 2

    -- Mengubah isi sub-tabel melalui tShallow AKAN mempengaruhi tAsli
    -- karena tShallow.c dan tAsli.c merujuk ke tabel {x=10, y=20} yang sama
    tShallow.c.x = 99
    print("tAsli.c.x:", tAsli.c.x)     -- Output: tAsli.c.x: 99 (terpengaruh)
    print("tShallow.c.x:", tShallow.c.x) -- Output: tShallow.c.x: 99

    print(tAsli == tShallow)     -- Output: false (tabel utamanya berbeda objek)
    print(tAsli.c == tShallow.c) -- Output: true (sub-tabelnya merujuk objek yang sama)
    ```

    Implementasi deep copy lebih kompleks dan akan dibahas di "Copy Mechanisms".

- **Reference Equality Testing**

  - **Deskripsi Konkret**: Operator kesetaraan `==` di Lua memiliki perilaku berbeda untuk tipe nilai dan tipe referensi.

    - **Tipe Nilai (`nil`, `boolean`, `number`)**: `==` membandingkan nilai aktualnya.
      ```lua
      print(10 == 10)        -- Output: true
      print(true == true)    -- Output: true
      local a = 5; local b = 5
      print(a == b)        -- Output: true
      ```
    - **Tipe Referensi (`table`, `function`, `userdata`, `thread`)**: `==` membandingkan apakah kedua operan merujuk ke **objek yang sama persis di memori**. Ia tidak membandingkan isi objeknya. Dua tabel atau dua fungsi dianggap sama hanya jika keduanya adalah referensi ke objek yang identik.

      ```lua
      local t1 = {a = 1}
      local t2 = {a = 1}
      local t3 = t1

      print(t1 == t2) -- Output: false (t1 dan t2 adalah dua objek tabel berbeda, meskipun isinya sama)
      print(t1 == t3) -- Output: true (t1 dan t3 merujuk ke objek tabel yang sama)

      local f1 = function() return 1 end
      local f2 = function() return 1 end
      local f3 = f1
      print(f1 == f2) -- Output: false (dua objek fungsi berbeda)
      print(f1 == f3) -- Output: true (merujuk ke objek fungsi yang sama)
      ```

    - **String**: Meskipun string secara konseptual adalah urutan byte, Lua sering melakukan _interning_ untuk string. Ini berarti string dengan isi yang sama mungkin (tetapi tidak dijamin selalu) merujuk ke objek string yang sama di memori. Oleh karena itu, perbandingan `==` untuk string membandingkan isinya, dan ini efisien.
      ```lua
      local s1 = "halo"
      local s2 = "ha" .. "lo" -- Membuat string baru "halo"
      print(s1 == s2) -- Output: true (isi sama)
      ```

#### **Aliasing Patterns (2 jam)**

Aliasing terjadi ketika lebih dari satu nama variabel merujuk ke lokasi memori atau objek yang sama. Ini adalah konsekuensi alami dari semantik referensi.

- **Creating Variable Aliases**

  - **Deskripsi Konkret**: Ini adalah bentuk aliasing paling dasar, di mana Anda menugaskan variabel tipe referensi ke variabel lain. Kedua variabel menjadi alias satu sama lain untuk objek yang dirujuk.
  - **Contoh Kode**:

    ```lua
    local dataAsli = { nilai = 42 }
    local aliasData = dataAsli -- aliasData adalah alias untuk dataAsli

    aliasData.nilai = 99
    print(dataAsli.nilai) -- Output: 99 (karena keduanya menunjuk ke tabel yang sama)
    ```

- **Module Aliasing**

  - **Deskripsi Konkret**: Modul di Lua biasanya adalah tabel. Anda dapat membuat alias lokal untuk sebuah modul (atau sub-tabel dalam modul) untuk kemudahan akses atau untuk mempersingkat nama.
  - **Manfaat**: Kode lebih ringkas, terkadang sedikit peningkatan performa karena akses lokal lebih cepat daripada akses global berulang.
  - **Contoh Kode**:

    ```lua
    -- Misalkan ada modul 'matematikaKompleks' yang di-require
    -- local matematikaKompleks = require("matematikaKompleksPanjangSekaliNamanya")

    -- Membuat alias lokal
    -- local mk = matematikaKompleks
    -- local fungsiPenting = matematikaKompleks.subModul.fungsiSangatPenting

    -- Penggunaan:
    -- mk.tambah(1, 2)
    -- fungsiPenting()

    -- Contoh dengan modul string (yang sudah global)
    local str = string -- 'str' menjadi alias lokal untuk tabel global 'string'
    local s_upper = str.upper("tes") -- Menggunakan alias lokal
    print(s_upper) -- Output: TES
    ```

- **Function Aliasing**

  - **Deskripsi Konkret**: Sama seperti variabel lain, fungsi adalah first-class values dan memiliki semantik referensi. Anda dapat membuat alias untuk fungsi.
  - **Penggunaan**:
    - Memberi nama alternatif yang lebih deskriptif atau lebih pendek.
    - Menyimpan referensi ke fungsi asli sebelum mungkin di-override (misalnya, untuk monkey patching dengan tetap bisa memanggil implementasi asli).
  - **Contoh Kode**:

    ```lua
    local function fungsiOriginalYangPanjangNamanya(x)
        return x * x
    end

    local kuadrat = fungsiOriginalYangPanjangNamanya -- 'kuadrat' adalah alias

    print(kuadrat(5)) -- Output: 25

    -- Monkey patching (contoh, hati-hati penggunaannya)
    local print_asli = print -- Simpan alias ke print asli
    _G.print = function(...) -- Ganti print global (jangan lakukan ini sembarangan!)
        print_asli("LOG:", ...) -- Panggil print asli melalui alias
    end

    print("Halo") -- Output: LOG:  Halo
    _G.print = print_asli -- Kembalikan print asli
    ```

- **Table Field Aliasing**

  - **Deskripsi Konkret**: Anda dapat membuat variabel lokal yang merupakan alias ke sebuah field (entri) di dalam tabel. Jika field tersebut berisi tipe referensi (misalnya, sub-tabel), maka alias tersebut akan merujuk ke sub-tabel yang sama. Jika field berisi tipe nilai, variabel lokal akan mendapatkan salinan nilai tersebut.
  - **Contoh Kode**:

    ```lua
    local konfigurasi = {
        pengguna = { nama = "Budi", id = 101 },
        sistem = { versi = "1.2" }
    }

    -- Alias ke sub-tabel 'pengguna'
    local userConfig = konfigurasi.pengguna
    userConfig.nama = "Siti" -- Mengubah melalui alias
    print(konfigurasi.pengguna.nama) -- Output: Siti (tabel asli terpengaruh)

    -- Alias ke field dengan tipe nilai
    local versiSistem = konfigurasi.sistem.versi -- versiSistem mendapat salinan string "1.2"
    versiSistem = "1.3" -- Hanya mengubah variabel lokal 'versiSistem'
    print(konfigurasi.sistem.versi) -- Output: 1.2 (tabel asli tidak terpengaruh)
    ```

  - **Perhatian**: Perilaku tergantung apakah field yang di-alias itu sendiri adalah tipe nilai atau tipe referensi.

- **Performance Considerations**

  - **Akses Lokal vs Global/Tabel**:
    - Mengakses variabel lokal umumnya lebih cepat daripada mengakses variabel global atau field tabel.
    - Membuat alias lokal untuk fungsi global atau field tabel yang sering diakses dalam loop ketat dapat memberikan sedikit peningkatan performa. Ini disebut "caching" referensi ke lokal.
  - **Contoh (Caching)**:

    ```lua
    local data = {}
    for i = 1, 1000 do data[i] = { nilai = i } end

    local total = 0
    local startTime = os.clock()

    -- Tanpa caching field tabel
    for i = 1, 1000000 do
        local idx = (i % 1000) + 1
        total = total + data[idx].nilai -- Akses data[idx] lalu .nilai
    end
    print("Waktu tanpa cache field:", os.clock() - startTime, "Total:", total)

    total = 0
    startTime = os.clock()
    -- Dengan caching field tabel di dalam loop (kurang efektif jika field berubah per iterasi)
    -- Lebih efektif jika field yang di-cache konstan selama beberapa operasi
    for i = 1, 1000000 do
        local idx = (i % 1000) + 1
        local entri = data[idx] -- Cache referensi ke sub-tabel
        total = total + entri.nilai -- Akses field dari referensi lokal 'entri'
    end
    print("Waktu dengan cache field:", os.clock() - startTime, "Total:", total)
    ```

  - **Overhead Aliasing**: Membuat alias itu sendiri memiliki overhead yang sangat minimal. Manfaat performa hanya terasa jika akses yang dihindari (global atau deep table lookup) dilakukan sangat sering. Readability seringkali lebih penting daripada mikro-optimasi ini.

#### **Copy Mechanisms (2 jam)**

Mekanisme untuk membuat salinan independen dari data, terutama untuk tabel.

- **Shallow Copy Implementation**

  - **Deskripsi Konkret**: Membuat tabel baru dan menyalin setiap pasangan kunci-nilai dari tabel asli. Jika nilai adalah tipe referensi, hanya referensinya yang disalin.
  - **Implementasi Umum**:
    ```lua
    function shallowCopy(original)
        local copy = {}
        for k, v in pairs(original) do
            copy[k] = v
        end
        return copy
    end
    ```
  - **Contoh Penggunaan**: Sudah ditunjukkan di bagian "Shallow vs Deep Copying".

- **Deep Copy Strategies**

  - **Deskripsi Konkret**: Membuat salinan yang sepenuhnya independen dari tabel asli, termasuk semua sub-tabel (atau objek referensi lainnya) secara rekursif.
  - **Strategi Dasar**:
    1.  Buat tabel baru untuk salinan.
    2.  Iterasi melalui tabel asli.
    3.  Untuk setiap nilai:
        - Jika tipe nilai, salin nilainya.
        - Jika tipe referensi (khususnya tabel), panggil fungsi deep copy secara rekursif untuk nilai tersebut.
  - **Masalah yang Perlu Dipertimbangkan**:
    - **Circular References**: Jika tabel mengandung referensi ke dirinya sendiri atau ada siklus referensi antar sub-tabel. Tanpa penanganan khusus, deep copy rekursif akan masuk ke loop tak terbatas.
    - **Berbagi Referensi yang Disengaja**: Terkadang Anda mungkin ingin beberapa bagian dari struktur data yang disalin tetap berbagi referensi yang sama. Deep copy standar tidak melakukan ini.
    - **Tipe Referensi Selain Tabel**: Bagaimana menangani penyalinan fungsi, userdata, atau thread? Biasanya, fungsi hanya disalin referensinya (karena kode fungsi immutable). Userdata mungkin memerlukan logika penyalinan khusus.

- **Recursive Copying**

  - **Deskripsi Konkret**: Ini adalah inti dari implementasi deep copy untuk tabel. Fungsi deep copy memanggil dirinya sendiri untuk setiap sub-tabel yang ditemui.
  - **Contoh Implementasi Sederhana (Tanpa Penanganan Circular Reference)**:

    ```lua
    function simpleDeepCopy(original)
        if type(original) ~= "table" then
            return original -- Bukan tabel, kembalikan nilai asli (atau salinannya jika tipe nilai)
        end

        local copy = {}
        for k, v in pairs(original) do
            copy[k] = simpleDeepCopy(v) -- Panggil rekursif untuk menyalin nilai
        end
        return copy
    end

    local tAsli = { a = 1, b = { x = 10, y = { z = 20 } } }
    local tDeep = simpleDeepCopy(tAsli)

    tDeep.b.y.z = 99
    print("tAsli.b.y.z:", tAsli.b.y.z) -- Output: tAsli.b.y.z: 20 (tidak terpengaruh)
    print("tDeep.b.y.z:", tDeep.b.y.z) -- Output: tDeep.b.y.z: 99
    ```

- **Circular Reference Handling (dalam Deep Copy)**

  - **Deskripsi Konkret**: Untuk mencegah loop tak terbatas saat melakukan deep copy pada tabel dengan referensi siklik, Anda perlu melacak tabel mana yang sudah pernah disalin.
  - **Strategi**: Gunakan tabel tambahan (misalnya, `copies_made`) untuk menyimpan pemetaan dari tabel asli ke salinannya. Sebelum menyalin sebuah sub-tabel, periksa apakah ia sudah ada di `copies_made`. Jika ya, gunakan salinan yang sudah ada. Jika tidak, buat salinan baru, simpan pemetaannya, lalu lanjutkan rekursi.
  - **Contoh Implementasi Deep Copy dengan Penanganan Circular Reference**:

    ```lua
    function deepCopy(original, copies_made)
        copies_made = copies_made or {} -- Tabel untuk melacak salinan

        if type(original) ~= "table" then
            return original
        end

        if copies_made[original] then -- Jika tabel ini sudah pernah disalin
            return copies_made[original] -- Kembalikan salinan yang sudah ada
        end

        local copy = {}
        copies_made[original] = copy -- Simpan referensi salinan ini

        for k, v in pairs(original) do
            copy[k] = deepCopy(v, copies_made) -- Teruskan tabel 'copies_made'
        end

        return copy
    end

    -- Tes dengan circular reference
    local a = { name = "A" }
    local b = { name = "B" }
    a.partner = b
    b.partner = a -- Circular reference: a.partner.partner == a

    local a_copy = deepCopy(a)

    print(a_copy.name)                -- Output: A
    print(a_copy.partner.name)        -- Output: B
    print(a_copy.partner.partner.name) -- Output: A
    print(a_copy.partner.partner == a_copy) -- Output: true (struktur siklik berhasil disalin)

    -- Pastikan tidak ada infinite loop dan objeknya berbeda dari asli
    a_copy.name = "A_Salinan"
    print(a.name) -- Output: A (asli tidak berubah)
    ```

- **Copy Performance Optimization**
  - **Deskripsi Konkret**: Deep copy bisa menjadi operasi yang mahal, terutama untuk tabel yang besar dan kompleks.
  - **Pertimbangan**:
    - **Kebutuhan**: Apakah deep copy benar-benar diperlukan? Mungkin shallow copy cukup, atau hanya menyalin bagian tertentu dari tabel.
    - **Frekuensi**: Seberapa sering operasi penyalinan dilakukan? Jika jarang, overhead mungkin bisa diterima.
    - **Ukuran Data**: Semakin besar dan dalam struktur tabel, semakin mahal operasinya.
  - **Teknik Optimasi Potensial (tergantung kasus)**:
    - **Selective Copying**: Hanya menyalin field atau sub-tabel yang benar-benar perlu independen.
    - **Copy-on-Write**: Strategi di mana data tidak disalin sampai ada upaya untuk memodifikasinya. Awalnya, hanya referensi yang dibagikan. Ini lebih kompleks untuk diimplementasikan.
    - **Menggunakan Library**: Untuk kasus yang sangat kritis, library eksternal yang ditulis dalam C mungkin menawarkan performa penyalinan yang lebih baik.
    - **Hindari Penyalinan Jika Tidak Perlu**: Desain program agar tidak terlalu sering membutuhkan deep copy. Misalnya, dengan menggunakan struktur data immutable atau meneruskan data tanpa memodifikasinya.

### 4.2 Variable Mutability

Bagian ini membahas konsep data yang dapat diubah (mutable) dan yang tidak dapat diubah (immutable), serta bagaimana mensimulasikan konstanta di Lua.

#### **Immutability Concepts (2 jam)**

- **Immutable vs Mutable Data**

  - **Deskripsi Konkret**:
    - **Mutable Data**: Objek yang nilainya atau isinya dapat diubah setelah objek tersebut dibuat. Di Lua, contoh utama tipe data yang mutable adalah `table`. Anda dapat menambah, menghapus, atau mengubah field dalam tabel setelah tabel dibuat.
    - **Immutable Data**: Objek yang nilainya atau isinya tidak dapat diubah setelah objek tersebut dibuat. Setiap operasi yang terlihat seperti "memodifikasi" objek immutable sebenarnya menghasilkan objek baru dengan nilai yang diubah. Di Lua, contoh utama tipe data yang immutable adalah `string`, `number`, `boolean`, `nil`.
  - **Contoh Perbandingan**:

    ```lua
    -- String (Immutable)
    local s = "halo"
    local s_upper = string.upper(s) -- string.upper() mengembalikan string BARU
    print("s:", s)               -- Output: s: halo (s asli tidak berubah)
    print("s_upper:", s_upper)   -- Output: s_upper: HALO

    -- Tabel (Mutable)
    local t = { nilai = 10 }
    t.nilai = 20          -- Mengubah isi tabel t secara langsung
    t.baru = "tambahan"   -- Menambah field baru ke tabel t
    print("t.nilai:", t.nilai, "t.baru:", t.baru) -- Output: t.nilai: 20 t.baru: tambahan
    ```

- **String Immutability**

  - **Deskripsi Konkret**: String di Lua bersifat immutable. Anda tidak dapat mengubah karakter individual dalam string yang sudah ada. Setiap operasi string (seperti konkatenasi, `string.sub`, `string.gsub`) yang tampaknya memodifikasi string akan selalu menghasilkan objek string baru.
  - **Implikasi**:
    - **Keamanan**: String yang diteruskan ke fungsi tidak dapat diubah oleh fungsi tersebut, mencegah efek samping yang tidak diinginkan.
    - **Interning Efisien**: Memungkinkan Lua untuk melakukan interning string (menyimpan hanya satu salinan string dengan isi yang sama) secara lebih aman dan efisien.
    - **Performa**: Pembuatan string baru secara berulang (misalnya, konkatenasi dalam loop panjang) bisa kurang efisien. Pola `table.concat` direkomendasikan untuk kasus seperti itu. (Telah dibahas di Modul 2).

- **Table Mutability**

  - **Deskripsi Konkret**: Tabel di Lua bersifat mutable. Anda dapat dengan bebas menambah, menghapus, atau mengubah nilai field (pasangan kunci-nilai) dalam sebuah tabel setelah tabel tersebut dibuat.
  - **Operasi Umum yang Menunjukkan Mutabilitas**:
    - `t.namaField = nilaiBaru` (mengubah atau menambah field)
    - `t[kunci] = nilaiBaru` (mengubah atau menambah field)
    - `t.namaField = nil` (menghapus field)
    - `table.insert(t, nilai)` (menambah elemen ke bagian array tabel)
    - `table.remove(t, indeks)` (menghapus elemen dari bagian array tabel)
  - **Implikasi**:
    - **Fleksibilitas**: Sangat mudah untuk memodifikasi struktur data seiring berjalannya program.
    - **Efek Samping**: Jika beberapa variabel merujuk ke tabel yang sama, perubahan melalui satu variabel akan mempengaruhi semua variabel lain tersebut. Ini bisa menjadi sumber bug jika tidak dikelola dengan hati-hati.

- **Creating Immutable Structures (Simulasi)**

  - **Deskripsi Konkret**: Karena tabel di Lua secara bawaan mutable, membuat struktur tabel yang benar-benar immutable memerlukan teknik tambahan. Tujuannya adalah untuk mencegah modifikasi setelah tabel "selesai" dibuat.
  - **Teknik Umum**:
    1.  **Konvensi**: Cara paling sederhana adalah dengan konvensi (misalnya, dokumentasi atau nama variabel) bahwa tabel tertentu tidak boleh diubah. Ini tidak memberikan proteksi teknis.
    2.  **Metatables (`__index`, `__newindex`, `__pairs`)**: Ini adalah cara paling kuat di Lua.
        - Set metatable pada tabel data Anda.
        - Metatable tersebut bisa memiliki field `__newindex` yang akan dipanggil setiap kali ada upaya untuk menambah atau mengubah field pada tabel data. Fungsi `__newindex` ini bisa memunculkan error untuk mencegah modifikasi.
        - Field `__index` bisa menunjuk ke tabel data asli (atau salinannya) untuk pembacaan.
        - Mungkin juga perlu mengoverride `__pairs` dan `__ipairs` jika Anda ingin mencegah iterasi yang dapat digunakan untuk mengambil referensi ke sub-tabel internal yang mungkin mutable.
    3.  **Fungsi "Constructor" yang Mengembalikan Salinan**: Fungsi yang membuat "objek" dapat mengembalikan salinan defensif atau menggunakan metatables untuk proteksi.
  - **Contoh dengan Metatable (dasar)**:

    ```lua
    function createImmutableTable(data)
        local readOnlyData = {} -- Tabel yang akan menyimpan data (bisa salinan)
        for k, v in pairs(data) do
            -- Jika v adalah tabel, idealnya v juga dibuat immutable secara rekursif
            readOnlyData[k] = v
        end

        local mt = {
            __index = readOnlyData, -- Untuk membaca, ambil dari readOnlyData
            __newindex = function(t, k, v)
                error("Attempt to modify a read-only table: field '" .. tostring(k) .. "'", 2)
            end,
            __pairs = function(t) -- Kontrol iterasi jika perlu
                return pairs(readOnlyData)
            end
            -- Mungkin juga __ipairs, __len
        }
        return setmetatable({}, mt) -- Kembalikan proxy table yang dilindungi metatable
    end

    local dataAwal = { nama = "Konstan", nilai = 100 }
    local tabelImmutable = createImmutableTable(dataAwal)

    print(tabelImmutable.nama) -- Output: Konstan

    -- Ini akan error:
    -- tabelImmutable.nilai = 200
    -- tabelImmutable.baru = "coba"
    ```

    Membuat struktur yang benar-benar deep immutable secara rekursif bisa lebih kompleks.

- **Functional Programming Approaches**

  - **Deskripsi Konkret**: Pemrograman fungsional mendorong penggunaan data immutable dan fungsi murni (pure functions). Daripada memodifikasi data yang ada, operasi fungsional menghasilkan data baru dengan perubahan yang diinginkan.
  - **Di Lua**: Meskipun Lua bukan bahasa fungsional murni, ia mendukung banyak konsep fungsional.
    - Fungsi adalah first-class citizens.
    - Closures memungkinkan state yang terenkapsulasi.
    - Anda dapat menerapkan pola immutable dengan disiplin: setiap kali Anda "mengubah" tabel, Anda sebenarnya membuat tabel baru dengan perubahan tersebut.
  - **Contoh (Pola Fungsional Sederhana)**:

    ```lua
    -- Fungsi yang "menambah" elemen ke tabel secara immutable
    function tableAppendImmutable(originalTable, element)
        local newTable = {}
        for i = 1, #originalTable do
            newTable[i] = originalTable[i] -- Salin elemen lama
        end
        newTable[#newTable + 1] = element -- Tambah elemen baru
        return newTable -- Kembalikan tabel baru
    end

    local list1 = {1, 2, 3}
    local list2 = tableAppendImmutable(list1, 4)

    print("list1:", table.concat(list1, ",")) -- Output: list1: 1,2,3 (list1 tidak berubah)
    print("list2:", table.concat(list2, ",")) -- Output: list2: 1,2,3,4
    ```

    Pendekatan ini bisa lebih aman dalam hal state management tetapi bisa memiliki overhead performa karena pembuatan objek baru yang sering.

#### **Constant Simulation (2 jam)**

Mensimulasikan perilaku konstanta di Lua.

- **Constant Naming Conventions**

  - **Deskripsi Konkret**: Cara paling sederhana dan umum untuk menandakan bahwa sebuah variabel sebaiknya diperlakukan sebagai konstanta adalah melalui konvensi penamaan.
  - **Konvensi**: Gunakan huruf kapital semua dengan garis bawah sebagai pemisah (UPPER_SNAKE_CASE).
  - **Contoh**:
    ```lua
    local PI = 3.14159
    local MAX_USERS = 100
    local DEFAULT_TIMEOUT_MS = 5000
    ```
  - **Keterbatasan**: Ini murni konvensi. Lua tidak akan mencegah variabel ini untuk diubah nilainya. Ini bergantung pada disiplin programmer.

- **Read-Only Table Creation**

  - **Deskripsi Konkret**: Teknik ini menggunakan metatables untuk membuat tabel yang field-nya tidak dapat diubah atau ditambah setelah inisialisasi. Ini memberikan proteksi teknis.
  - **Metode**: Gunakan metatable dengan field `__newindex` yang memunculkan error jika ada upaya penulisan. Field `__index` bisa menunjuk ke tabel data internal.
  - **Contoh**: Sama seperti contoh `createImmutableTable` di atas.

    ```lua
    local SETTINGS = createImmutableTable({
        VERSION = "1.0.2",
        API_URL = "https://api.example.com"
    })

    print(SETTINGS.VERSION)
    -- SETTINGS.VERSION = "1.1.0" -- Akan error
    ```

- **Metatable-Based Protection**

  - **Deskripsi Konkret**: Ini adalah generalisasi dari "Read-Only Table Creation". Metatables (`__index`, `__newindex`, `__pairs`, `rawset`, `rawget`) adalah mekanisme utama di Lua untuk mengintersep dan mengkustomisasi perilaku operasi pada tabel, termasuk menjadikannya read-only atau mensimulasikan konstanta.
  - **Detail**:
    - `__newindex`: Mencegah penulisan.
    - `__index`: Mengontrol pembacaan. Bisa merujuk ke tabel data asli atau melakukan validasi tambahan.
    - `rawset(table, key, value)`: Dapat digunakan di dalam `__newindex` jika Anda perlu mengatur nilai internal pada tabel proxy itu sendiri, bukan pada tabel data yang dilindungi.
    - `rawget(table, key)`: Dapat digunakan di dalam `__index` untuk mengambil nilai dari tabel proxy tanpa memicu `__index` lagi.

- **Module-Level Constants**

  - **Deskripsi Konkret**: Ketika membuat modul, Anda dapat mendefinisikan konstanta di dalam scope lokal modul dan hanya mengeksposnya untuk dibaca (misalnya, melalui field di tabel modul yang dikembalikan). Jika tabel modul itu sendiri dibuat read-only menggunakan metatables, maka konstanta tersebut akan terlindungi.
  - **Contoh**:

    ```lua
    -- my_constants_module.lua
    local M = {}

    local INTERNAL_PI = 3.1415926535
    local DEBUG_MODE = false

    -- Ekspos sebagai field di tabel modul
    M.PI = INTERNAL_PI
    M.IS_DEBUG = DEBUG_MODE

    -- Untuk membuat M.PI dan M.IS_DEBUG benar-benar read-only dari luar,
    -- tabel M itu sendiri perlu dilindungi metatable.
    local function makeReadOnly(data)
        -- (Implementasi createImmutableTable seperti sebelumnya)
        local readOnlyData = {}
        for k,v in pairs(data) do readOnlyData[k] = v end
        local mt = {
            __index = readOnlyData,
            __newindex = function() error("Module constants are read-only", 2) end
        }
        return setmetatable({}, mt)
    end

    return makeReadOnly(M) -- Kembalikan versi read-only dari M
    ```

    Pengguna modul kemudian dapat melakukan `local consts = require("my_constants_module")` dan `consts.PI` akan terlindungi.

- **Configuration Management**

  - **Deskripsi Konkret**: Dalam manajemen konfigurasi, seringkali diinginkan agar nilai konfigurasi dimuat sekali dan kemudian tetap konstan selama runtime untuk mencegah perubahan yang tidak disengaja.
  - **Strategi**:
    1.  Muat konfigurasi dari file atau environment variables ke dalam sebuah tabel.
    2.  Setelah dimuat, gunakan teknik metatable (seperti `createImmutableTable`) untuk membuat versi read-only dari tabel konfigurasi tersebut.
    3.  Gunakan tabel read-only ini di seluruh aplikasi.
  - **Contoh Alur**:

    ```lua
    -- config_loader.lua
    local config_data = {
        port = 8080,
        db_host = "localhost",
        log_level = "INFO"
        -- Mungkin dimuat dari file JSON/YAML/Lua
    }

    -- (fungsi createImmutableTable dari contoh sebelumnya)
    function createImmutableTable(data)
        local readOnlyData = {}
        for k, v in pairs(data) do readOnlyData[k] = v end
        local mt = {
            __index = readOnlyData,
            __newindex = function(t, k, v) error("Configuration is read-only", 2) end
        }
        return setmetatable({}, mt)
    end


    local AppConfig = createImmutableTable(config_data)

    return AppConfig

    -- Di file lain:
    -- local CONFIG = require("config_loader")
    -- print(CONFIG.port)
    -- CONFIG.port = 9090 -- Akan error
    ```

- **Catatan tentang `const` di Lua 5.4**:
  Lua 5.4 memperkenalkan atribut `local nama <const> = nilai`. Ini membuat _binding_ variabel `nama` ke `nilai` menjadi konstan, artinya `nama` tidak bisa ditugaskan ulang untuk merujuk ke nilai lain.

  ```lua
  -- Hanya di Lua 5.4+
  local x <const> = 10
  -- x = 20 -- Akan error: attempt to assign to const variable 'x'

  local TBL <const> = { val = 1 }
  -- TBL = {} -- Akan error: attempt to assign to const variable 'TBL'
  TBL.val = 2 -- INI BOLEH! Isi tabel masih mutable.
  print(TBL.val) -- Output: 2
  ```

  Ini berbeda dari simulasi konstanta menggunakan metatables yang bertujuan membuat _isi_ tabel menjadi immutable. `const` di Lua 5.4 adalah tentang immutability referensi variabel lokal, bukan immutability objek yang dirujuk (jika objek tersebut mutable seperti tabel). Jadi, teknik simulasi konstanta dengan metatables masih sangat relevan jika Anda membutuhkan immutability konten tabel atau portabilitas ke versi Lua sebelum 5.4.

#### **Praktik (3 jam)**

Kurikulum menyarankan latihan untuk memperkuat pemahaman konsep-konsep ini.

- **Implementing Immutable Data Structures**:
  - Buat fungsi `deepImmutableCopy` yang secara rekursif membuat salinan tabel yang sepenuhnya immutable (termasuk sub-tabel), menggunakan metatables untuk proteksi `__newindex`. Pastikan menangani circular references jika diperlukan untuk salinan (meskipun untuk immutability, fokusnya pada pencegahan tulis).
- **Constant Protection Mechanisms**:
  - Implementasikan sebuah modul yang mengekspos beberapa konstanta. Gunakan metatable untuk memastikan konstanta tersebut tidak dapat diubah dari luar modul.
- **Performance Testing Mutability Approaches**:
  - Bandingkan performa antara:
    1.  Memodifikasi tabel mutable secara langsung.
    2.  Membuat tabel baru setiap kali ada "perubahan" (pendekatan fungsional/immutable).
    3.  Mengakses field dari tabel yang dilindungi metatable (untuk read-only).
  - Lakukan ini dalam loop dengan banyak iterasi untuk melihat perbedaan. Ukur menggunakan `os.clock()`.
- **Real-World Immutability Scenarios**:
  - Pikirkan skenario di mana data immutable sangat berguna. Contoh:
    - Event Sourcing: Menyimpan histori event sebagai objek immutable.
    - Konfigurasi Aplikasi: Seperti dibahas.
    - State Management di UI: Jika state UI immutable, lebih mudah melacak perubahan dan melakukan rendering ulang.

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][2]**
> - **[Sebelumnya][3]**
> - **[Kurikulum][4]**
> - **[Domain Spesifik][5]**

[5]: ../../../../../../../README.md
[4]: ../../../../README.md
[3]: ../3-scope-lifetime/README.md
[2]: ../5-specialized-variable-usage/README.md
[1]: ../../README.md/#21-assignment-patterns
