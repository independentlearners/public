### Daftar Isi Pembelajaran

Berikut adalah peta jalan untuk materi yang akan kita bahas. Tautan di bawah ini akan membawa Anda langsung ke bagian yang relevan.

- **Materi yang Telah Dibahas (Ringkasan)**

  - **Bagian 1-5**: Membahas dasar-dasar kontrol alur, perulangan, pola-pola canggih (tabel, fungsional, metatabel), dan penanganan error.
  - **Bagian 6**: Mendalami Coroutine sebagai fitur inti untuk pemrograman konkuren dan asinkron di Lua.

- **Materi Saat Ini: Optimasi Performa**

  - [**Bagian 7: Performance Optimization**](https://www.google.com/search?q=%23-bagian-7-performance-optimization)
    - [7.1 Analisis Performa Kontrol Alur](https://www.google.com/search?q=%2371-analisis-performa-kontrol-alur)
    - [7.2 Manajemen Memori dalam Kontrol Alur](https://www.google.com/search?q=%2372-manajemen-memori-dalam-kontrol-alur)

---

## 📚 **Bagian 7: Performance Optimization**

Menulis kode yang benar adalah prioritas pertama, tetapi menulis kode yang cepat dan efisien juga penting, terutama untuk aplikasi yang sensitif terhadap performa seperti game atau sistem pemrosesan data bervolume tinggi. Bagian ini fokus pada bagaimana pilihan struktur kontrol alur Anda dan cara Anda mengelola memori dapat memengaruhi performa.

Prinsip utama dalam optimasi adalah: **Jangan menebak, ukurlah\!** Selalu gunakan alat _profiling_ atau _benchmarking_ untuk menemukan bagian kode yang benar-benar lambat (_bottleneck_) sebelum mencoba mengoptimalkannya.

### 7.1 Analisis Performa Kontrol Alur

**Durasi yang Disarankan:** 3-4 jam

Bagian ini membahas teknik untuk menganalisis dan meningkatkan kecepatan eksekusi dari struktur kontrol alur Anda.

#### **Deskripsi Konkret**

Analisis performa kontrol alur melibatkan pengukuran kecepatan berbagai pendekatan (misalnya, `if/else` vs tabel lookup), memahami bagaimana kompiler seperti LuaJIT mengoptimalkan kode Anda, dan menerapkan teknik manual seperti _loop unrolling_ untuk mengurangi overhead.

#### **Terminologi dan Konsep Mendasar**

- **Benchmarking**: Proses menjalankan bagian kode tertentu berulang kali untuk mengukur waktu eksekusi rata-ratanya. Ini digunakan untuk membandingkan performa dari dua atau lebih implementasi.
- **Profiling**: Proses menganalisis program saat berjalan untuk melihat di mana ia menghabiskan sebagian besar waktunya (fungsi mana yang paling sering dipanggil atau paling lama dieksekusi). Ini membantu mengidentifikasi _bottleneck_.
- **JIT (Just-In-Time) Compilation**: Teknik di mana kode sumber (atau bytecode) dikompilasi menjadi kode mesin asli saat program dijalankan. LuaJIT adalah implementasi Lua berkinerja sangat tinggi yang menggunakan JIT. Kompiler JIT sangat pandai mengoptimalkan loop dan kode yang sering dijalankan ("hot code").
- **Branch Prediction (Prediksi Cabang)**: Fitur pada CPU modern di mana prosesor mencoba menebak hasil dari sebuah cabang kondisional (seperti `if`) sebelum hasilnya benar-benar diketahui. Jika tebakannya benar, eksekusi berjalan sangat cepat. Jika salah, ada penalti performa karena CPU harus membuang pekerjaan spekulatif dan memulai dari jalur yang benar.
- **Loop Unrolling**: Teknik optimasi manual atau oleh kompiler di mana tubuh loop diduplikasi beberapa kali untuk mengurangi jumlah total evaluasi kondisi loop dan instruksi loncatan, dengan potensi mengorbankan ukuran kode.

#### **Topik yang Dipelajari (Sesuai Kurikulum dan Penjelasan Tambahan)**

- **Benchmarking different control structures (Benchmarking berbagai struktur kontrol)**:

  - **Deskripsi**: Anda dapat menulis fungsi sederhana untuk mengukur waktu yang dibutuhkan untuk menjalankan loop atau fungsi jutaan kali, lalu membandingkan hasilnya.
  - **Contoh Kode (Benchmarking `if/elseif` vs. Tabel Dispatch)**:

    ```lua
    local function benchmark(nama, jumlahIterasi, func)
        local startTime = os.clock()
        for i = 1, jumlahIterasi do
            func(i)
        end
        local endTime = os.clock()
        print(string.format("Benchmark '%s': %.4f detik", nama, endTime - startTime))
    end

    local iterasi = 10000000

    -- Pendekatan 1: if/elseif
    local function testIfElse(i)
        local val = i % 4
        if val == 0 then return "nol"
        elseif val == 1 then return "satu"
        elseif val == 2 then return "dua"
        else return "tiga"
        end
    end

    -- Pendekatan 2: Tabel Dispatch
    local dispatchTable = {"nol", "satu", "dua", "tiga"}
    local function testTable(i)
        local val = i % 4
        return dispatchTable[val + 1] -- +1 karena indeks Lua mulai dari 1
    end

    benchmark("if/elseif chain", iterasi, testIfElse)
    benchmark("Table Dispatch", iterasi, testTable)
    ```

    **Catatan**: Hasil dari benchmark ini dapat sangat bervariasi tergantung pada versi Lua, apakah Anda menggunakan LuaJIT, dan arsitektur CPU Anda. Seringkali, untuk kasus sederhana seperti ini, tabel dispatch akan lebih cepat.

- **JIT compilation considerations (LuaJIT) (Pertimbangan kompilasi JIT)**:

  - **Deskripsi**: LuaJIT memiliki "tracer" yang merekam kode yang sering dieksekusi (seperti loop) dan mengkompilasinya menjadi kode mesin yang sangat dioptimalkan.
  - **Implikasi untuk Kontrol Alur**:
    - **Loop Sederhana**: LuaJIT sangat menyukai numeric `for` loop dengan batas yang diketahui. Ini adalah jenis loop yang paling mudah untuk dioptimalkan.
    - **Hindari "NYI"**: Beberapa fitur atau pola Lua tidak dapat di-JIT oleh LuaJIT (Not Yet Implemented). Misalnya, memodifikasi tabel saat iterasi dengan `pairs` dapat menyebabkan tracer berhenti. Menggunakan `pcall`/`xpcall` juga bisa mengganggu JIT. Periksa dokumentasi LuaJIT untuk daftar lengkapnya.
    - **Tipe Stabil**: Usahakan agar tipe variabel di dalam loop tetap stabil. Jangan mengubah variabel dari angka menjadi string lalu kembali lagi. Ini membingungkan kompiler JIT.

- **Branch prediction optimization (Optimasi prediksi cabang)**:

  - **Deskripsi**: Untuk memaksimalkan performa, Anda ingin membantu CPU membuat tebakan yang benar sesering mungkin. CPU biasanya mengasumsikan bahwa pola cabang (apakah `if` akan `true` atau `false`) akan tetap sama.
  - **Praktik**: Susun `if/elseif` Anda sehingga kasus yang paling umum terjadi diperiksa terlebih dahulu.

    ```lua
    -- Kurang optimal jika 99% 'event' adalah 'update'
    -- if event.type == "keypress" then
    --     -- ...
    -- elseif event.type == "mouseclick" then
    --     -- ...
    -- elseif event.type == "update" then -- Kasus paling umum ada di akhir
    --     -- ...
    -- end

    -- Lebih baik
    if event.type == "update" then -- Periksa kasus paling umum terlebih dahulu
        -- ...
    elseif event.type == "keypress" then
        -- ...
    elseif event.type == "mouseclick" then
        -- ...
    end
    ```

    Dengan menempatkan kasus yang paling sering terjadi di depan, Anda mengurangi jumlah "salah tebak" oleh CPU.

- **Loop unrolling techniques (Teknik loop unrolling)**:

  - **Deskripsi**: Mengurangi overhead loop dengan memproses beberapa elemen per iterasi.
  - **Contoh Kode**:

    ```lua
    local data = {}
    for i = 1, 1000000 do data[i] = i end

    -- Loop biasa
    local sum1 = 0
    local start1 = os.clock()
    for i = 1, #data do
        sum1 = sum1 + data[i]
    end
    print("Biasa:", os.clock() - start1)

    -- Loop unrolled (manual)
    local sum2 = 0
    local n = #data
    local start2 = os.clock()
    for i = 1, n, 4 do -- Langkah diperbesar menjadi 4
        sum2 = sum2 + data[i]
        sum2 = sum2 + data[i+1]
        sum2 = sum2 + data[i+2]
        sum2 = sum2 + data[i+3]
    end
    -- Perlu menangani sisa elemen jika panjang data bukan kelipatan 4
    print("Unrolled:", os.clock() - start2)
    ```

  - **Peringatan**: Ini adalah optimasi tingkat rendah. LuaJIT seringkali melakukan ini secara otomatis dan mungkin lebih baik dari implementasi manual Anda. Lakukan ini hanya jika profiling menunjukkan bahwa overhead loop adalah _bottleneck_ yang signifikan dan JIT tidak menanganinya untuk Anda.

#### **Sumber Belajar (dari README.md)**:

- [LuaJIT Performance Guide](http://wiki.luajit.org/Numerical-Computing-Performance-Guide)
- [Lua Performance Tips](http://lua-users.org/wiki/OptimisationTips)

---

### 7.2 Manajemen Memori dalam Kontrol Alur

**Durasi yang Disarankan:** 2-3 jam

Performa tidak hanya tentang kecepatan CPU, tetapi juga tentang seberapa efisien Anda menggunakan memori. Pembuatan objek yang berlebihan dapat membebani _Garbage Collector_ (GC), yang dapat menyebabkan jeda atau "stutter" pada program Anda.

#### **Deskripsi Konkret**

Manajemen memori dalam konteks kontrol alur berfokus pada menghindari pembuatan objek (terutama tabel dan _closure_) yang tidak perlu di dalam loop yang sering dijalankan, karena setiap objek yang dibuat pada akhirnya harus dibersihkan oleh GC.

#### **Terminologi dan Konsep Mendasar**

- **Garbage Collection (GC)**: Proses otomatis di Lua yang membebaskan memori yang digunakan oleh objek yang tidak lagi dapat dijangkau dari bagian mana pun dari program.
- **Memory Allocation (Alokasi Memori)**: Proses memesan ruang di memori untuk objek baru (misalnya, saat Anda membuat tabel `{}`).
- **Weak References (Referensi Lemah)**: Referensi ke sebuah objek yang tidak mencegah objek tersebut dikumpulkan oleh GC. Jika satu-satunya referensi ke sebuah objek adalah referensi lemah, GC bebas untuk menghapus objek tersebut. Ini diimplementasikan di Lua menggunakan _weak tables_.

#### **Topik yang Dipelajari (Sesuai Kurikulum dan Penjelasan Tambahan)**

- **Garbage collection impact (Dampak garbage collection)**:

  - **Deskripsi**: GC Lua adalah _incremental_, artinya ia bekerja dalam langkah-langkah kecil untuk mencoba menghindari jeda yang lama. Namun, jika Anda membuat objek baru dengan sangat cepat (misalnya, ribuan tabel per detik), GC mungkin harus bekerja lebih keras atau melakukan siklus penuh yang dapat menyebabkan jeda yang terlihat.
  - **Implikasi**: Loop yang berjalan ribuan kali per frame dalam sebuah game adalah kandidat utama untuk optimasi memori.

- **Memory-efficient loop patterns (Pola loop yang efisien memori)**:

  - **Deskripsi**: Pola utama adalah menghindari alokasi di dalam loop. Gunakan kembali objek yang ada jika memungkinkan.
  - **Contoh Kode (Menghindari Alokasi Tabel)**:

    ```lua
    -- Pola TIDAK EFISIEN: membuat tabel baru setiap pemanggilan
    local function getVector(x, y)
        return {x=x, y=y} -- Alokasi tabel baru setiap saat
    end

    local function prosesBanyakVector_Buruk()
        for i = 1, 10000 do
            local v = getVector(i, i)
            -- lakukan sesuatu dengan v
        end
        -- 10,000 tabel dibuat dan kemudian menjadi sampah
    end

    -- Pola LEBIH EFISIEN: menggunakan kembali satu tabel
    local reusableVector = {x=0, y=0}
    local function updateVector(t, x, y)
        t.x = x
        t.y = y
        return t
    end

    local function prosesBanyakVector_Baik()
        for i = 1, 10000 do
            local v = updateVector(reusableVector, i, i)
            -- lakukan sesuatu dengan v
        end
    end
    ```

- **Avoiding unnecessary allocations (Menghindari alokasi yang tidak perlu)**:

  - **Deskripsi**: Selain tabel, pembuatan fungsi anonim (_closures_) di dalam loop juga merupakan alokasi.
  - **Contoh Kode (Menghindari Alokasi Closure)**:

    ```lua
    -- Pola TIDAK EFISIEN: membuat closure baru di setiap iterasi
    local function iterasiBuruk(list, action)
        for i, v in ipairs(list) do
            action(function() return v * 2 end) -- Closure baru dibuat di setiap iterasi
        end
    end

    -- Pola LEBIH EFISIEN: definisikan fungsi di luar loop
    local function myProcessor(val)
        return val * 2
    end

    local function iterasiBaik(list, action)
        for i, v in ipairs(list) do
            -- Lakukan sesuatu dengan v dan myProcessor
            -- Jika `action` benar-benar perlu fungsi, cara ini mungkin tidak langsung berlaku,
            -- tapi idenya adalah untuk menghindari `function() ... end` di dalam loop panas.
        end
    end

    -- Contoh yang lebih konkret:
    -- BURUK
    for i = 1, 100 do
        -- table.sort membutuhkan fungsi pembanding.
        -- Fungsi ini dibuat ulang 100 kali.
        table.sort(myTable, function(a, b) return a.score > b.score end)
    end

    -- BAIK
    local function compareScores(a, b)
        return a.score > b.score
    end
    for i = 1, 100 do
        -- Gunakan kembali fungsi yang sama. Tidak ada alokasi baru.
        table.sort(myTable, compareScores)
    end
    ```

- **Weak references untuk control structures (Referensi lemah untuk struktur kontrol)**:

  - **Deskripsi**: Anda dapat membuat sebuah tabel menjadi _weak table_ dengan mengatur metatabelnya.
    - `__mode = "k"`: Membuat _kunci_ (keys) dalam tabel menjadi lemah.
    - `__mode = "v"`: Membuat _nilai_ (values) dalam tabel menjadi lemah.
    - `__mode = "kv"`: Membuat kunci dan nilai menjadi lemah.
  - **Penggunaan**: Ini berguna jika Anda menggunakan tabel untuk mengasosiasikan data dengan objek tanpa mencegah objek tersebut di-GC. Misalnya, sebuah tabel yang memetakan objek game ke data AI-nya. Jika objek game dihapus (tidak ada referensi kuat lain ke sana), entri di tabel AI akan dihapus secara otomatis oleh GC, mencegah kebocoran memori.
  - **Contoh Kode**:

    ```lua
    local objectData = {}
    setmetatable(objectData, {__mode = "k"}) -- Kunci adalah referensi lemah

    local obj1 = { name = "Player" }
    local obj2 = { name = "Enemy" }

    objectData[obj1] = "Data untuk Player"
    objectData[obj2] = "Data untuk Enemy"

    print("Data untuk obj1:", objectData[obj1]) -- Data untuk Player

    -- Hapus semua referensi kuat ke obj1
    obj1 = nil

    -- Minta GC untuk berjalan (hanya untuk demonstrasi, jangan lakukan ini di kode produksi)
    collectgarbage()

    -- Entri untuk obj1 sekarang mungkin sudah hilang dari tabel objectData
    -- (tergantung pada waktu GC)
    print("Data untuk obj1 setelah GC:", objectData[obj1]) -- Kemungkinan besar nil

    print("Data untuk obj2:", objectData[obj2]) -- Masih ada karena obj2 masih ada
    ```

#### **Sumber Belajar (dari README.md)**:

- [Programming in Lua: Garbage Collection](https://www.lua.org/pil/17.html)
- [Lua Memory Management](http://lua-users.org/wiki/GarbageCollection) (merujuk ke halaman wiki lua-users)

---

Kita telah membahas pentingnya optimasi performa dan bagaimana pilihan kontrol alur serta manajemen memori Anda dapat memengaruhinya. Ingatlah bahwa keterbacaan dan kebenaran kode harus selalu menjadi prioritas, dan optimasi hanya boleh dilakukan setelah pengukuran membuktikan adanya kebutuhan. Selanjutnya adalah **Bagian 8: Design Patterns dan Best Practices**.
