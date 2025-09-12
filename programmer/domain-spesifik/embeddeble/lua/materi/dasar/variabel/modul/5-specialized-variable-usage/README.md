# **[Modul 5: Specialized Variable Usage (Minggu 5)][1]**

Modul ini akan mengeksplorasi penggunaan variabel dalam konteks yang lebih khusus dan canggih, terutama bagaimana variabel berinteraksi dengan closures, environment Lua, dan metatables untuk menciptakan fungsionalitas yang dinamis dan terkontrol.

### 5.1 Variable dalam Closures

Bagian ini akan memperdalam pemahaman Anda tentang bagaimana variabel lokal dari fungsi luar (upvalues) ditangkap dan digunakan oleh fungsi dalam (closures), serta pola-pola lanjutan yang dimungkinkannya.

#### **Closure Fundamentals (3 jam)**

- **Closure Creation Mechanisms**

  - **Deskripsi Konkret**: Closure di Lua dibuat secara otomatis setiap kali sebuah fungsi didefinisikan di dalam fungsi lain (fungsi luar) dan fungsi dalam tersebut mereferensikan satu atau lebih variabel lokal dari fungsi luar. Closure adalah kombinasi dari fungsi dalam itu sendiri dan environment (lingkup leksikal) tempat ia diciptakan, termasuk referensi ke variabel lokal fungsi luar (upvalues) yang dibutuhkannya.
  - **Terminologi & Konsep (Pengingat dari Modul 3)**:
    - **Lexical Scoping (Static Scoping)**: Scope variabel ditentukan oleh struktur teks kode, bukan oleh call stack. Fungsi "mengingat" scope tempat ia didefinisikan.
    - **Upvalue**: Variabel lokal dari fungsi luar yang diakses atau "ditangkap" oleh fungsi dalam (closure).
  - **Mekanisme Pembuatan**:
    1.  Sebuah fungsi (misalnya, `innerFunc`) didefinisikan di dalam fungsi lain (`outerFunc`).
    2.  `innerFunc` merujuk ke variabel lokal yang dideklarasikan di dalam `outerFunc` (misalnya, `localVarOuter`).
    3.  Ketika `outerFunc` dieksekusi dan `innerFunc` dibuat, sebuah closure terbentuk. Closure ini "membawa" referensi ke `localVarOuter`.
    4.  Bahkan setelah `outerFunc` selesai dieksekusi, jika closure (`innerFunc`) masih dapat diakses (misalnya, dikembalikan oleh `outerFunc` atau ditugaskan ke variabel yang lebih persisten), ia masih dapat mengakses dan memanipulasi `localVarOuter` (yang sekarang menjadi upvalue-nya).
  - **Contoh Kode**:

    ```lua
    function outerFunction(initialValue)
        local outerVar = initialValue -- Variabel lokal fungsi luar

        -- innerFunction adalah closure karena ia "menangkap" outerVar
        local function innerFunction(increment)
            outerVar = outerVar + increment -- Mengakses dan memodifikasi outerVar (upvalue)
            return outerVar
        end

        return innerFunction -- Mengembalikan closure
    end

    local closureInstance1 = outerFunction(10)
    local closureInstance2 = outerFunction(100)

    print("Closure 1, Panggilan 1:", closureInstance1(1))  -- Output: 11
    print("Closure 1, Panggilan 2:", closureInstance1(5))  -- Output: 16 (outerVar untuk closure1 adalah 16)

    print("Closure 2, Panggilan 1:", closureInstance2(10)) -- Output: 110 (outerVar untuk closure2 adalah 110, terpisah)
    ```

    Setiap kali `outerFunction` dipanggil, instance baru dari `outerVar` dan `innerFunction` (closure) dibuat. Masing-masing closure memiliki environment upvalue-nya sendiri.

- **Upvalue Capture Behavior**

  - **Deskripsi Konkret**: Ketika sebuah variabel lokal dari fungsi luar ditangkap oleh closure, Lua memastikan variabel tersebut tetap ada di memori selama closure yang mereferensikannya masih ada. Ini berarti masa hidup variabel lokal tersebut diperpanjang melebihi eksekusi fungsi luarnya.
  - **Detail Penangkapan**:
    - **By Reference (Biasanya)**: Upvalue biasanya ditangkap "by reference". Artinya, closure memegang referensi ke variabel lokal asli. Jika ada beberapa closure di dalam fungsi luar yang sama yang semuanya menangkap variabel lokal yang sama, mereka semua akan berbagi dan memodifikasi instance variabel yang sama.
    - **Satu Instans per Deklarasi Lokal**: Variabel lokal dari fungsi luar hanya memiliki satu instans per pemanggilan fungsi luar tersebut, tidak peduli berapa banyak closure di dalamnya yang mereferensikannya.
  - **Contoh Kode (Berbagi Upvalue)**:

    ```lua
    function createSharedUpvalueAccessors()
        local sharedData = 0 -- Variabel lokal yang akan menjadi upvalue bersama

        local incrementer = function()
            sharedData = sharedData + 1
            return sharedData
        end

        local decrementer = function()
            sharedData = sharedData - 1
            return sharedData
        end

        local getter = function()
            return sharedData
        end

        return incrementer, decrementer, getter
    end

    local inc, dec, get = createSharedUpvalueAccessors()

    print("Awal:", get())   -- Output: 0
    inc()
    inc()
    print("Setelah 2x inc:", get()) -- Output: 2
    dec()
    print("Setelah 1x dec:", get()) -- Output: 1
    ```

    `incrementer`, `decrementer`, dan `getter` semuanya adalah closure yang berbagi dan memodifikasi upvalue `sharedData` yang sama.

- **Closure Variable Sharing**

  - **Deskripsi Konkret**: Seperti yang ditunjukkan di atas, beberapa closure yang didefinisikan dalam scope leksikal yang sama dan mereferensikan variabel lokal yang sama dari fungsi luar akan berbagi akses ke instance variabel (upvalue) tersebut. Perubahan yang dilakukan oleh satu closure akan terlihat oleh closure lainnya.
  - **Implikasi**: Ini adalah mekanisme kuat untuk menciptakan fungsi-fungsi yang berkolaborasi dan berbagi state tersembunyi (private) tanpa menggunakan variabel global.
  - **Contoh Pola**: Sering digunakan dalam pembuatan objek dengan metode yang berbagi state internal atau dalam implementasi modul.

- **Multiple Closure Interactions**

  - **Deskripsi Konkret**: Ketika Anda memiliki beberapa instance closure yang dibuat dari fungsi pabrik (factory function) yang sama, setiap instance akan memiliki set upvalue-nya sendiri yang independen, kecuali jika fungsi pabrik tersebut secara eksplisit dirancang untuk membuat closure yang berbagi upvalue dari scope yang lebih tinggi lagi.
  - **Perbedaan antara Berbagi dan Independen**:
    - **Berbagi**: Jika beberapa closure didefinisikan _di dalam pemanggilan fungsi luar yang sama_ dan mereferensikan _variabel lokal yang sama dari fungsi luar tersebut_.
    - **Independen**: Jika beberapa closure adalah hasil dari _pemanggilan fungsi luar yang berbeda_. Setiap pemanggilan fungsi luar menciptakan environment lokal baru, sehingga variabel lokal yang ditangkap oleh closure yang dihasilkan juga baru dan independen.
  - **Contoh (Pengulangan dari `outerFunction` untuk Kejelasan)**:

    ```lua
    function outerFunction(initialValue)
        local outerVar = initialValue
        return function(increment)
            outerVar = outerVar + increment
            return outerVar
        end
    end

    local c1 = outerFunction(0)  -- c1 punya 'outerVar' sendiri, mulai dari 0
    local c2 = outerFunction(10) -- c2 punya 'outerVar' sendiri, mulai dari 10

    c1(1); c1(1) -- outerVar c1 menjadi 2
    c2(5)       -- outerVar c2 menjadi 15

    print("c1 state:", c1(0)) -- Output: 2 (menunjukkan state terakhir outerVar c1)
    print("c2 state:", c2(0)) -- Output: 15 (menunjukkan state terakhir outerVar c2)
    ```

- **Memory Implications**

  - **Deskripsi Konkret**: Upvalue yang ditangkap oleh closure akan tetap ada di memori selama closure itu sendiri masih dapat dijangkau (referenced) oleh program. Ini berarti objek atau data yang dirujuk oleh upvalue tersebut juga tidak akan di-garbage collected.
  - **Potensi Memory Leak**: Jika sebuah closure yang memiliki masa hidup panjang (misalnya, callback yang terdaftar secara global atau dalam objek yang persisten) menangkap upvalue yang merujuk ke data besar, dan closure tersebut tidak pernah "dilepaskan", maka data besar tersebut juga tidak akan pernah di-GC, yang dapat menyebabkan memory leak.
  - **Contoh**:

    ```lua
    local dataBesar = { string.rep("x", 1024*1024) } -- Data 1MB
    local closureGlobal

    function setGlobalClosure()
        local dataLokalDitangkap = dataBesar -- dataLokalDitangkap mereferensikan dataBesar
        closureGlobal = function()
            -- Fungsi ini tidak melakukan apa-apa dengan dataLokalDitangkap,
            -- tapi tetap menangkapnya sebagai upvalue.
            print("Closure global dipanggil")
        end
    end

    setGlobalClosure()
    dataBesar = nil -- Mencoba melepaskan referensi asli ke dataBesar

    -- Meskipun dataBesar di-set nil, objek string 1MB masih hidup karena
    -- ditangkap oleh 'dataLokalDitangkap' yang merupakan upvalue dari 'closureGlobal',
    -- dan 'closureGlobal' masih ada.

    -- Jika closureGlobal tidak lagi dibutuhkan:
    -- closureGlobal = nil -- Ini akan memungkinkan dataLokalDitangkap dan objek dataBesar untuk di-GC.
    ```

  - **Penting**: Sadari variabel apa saja yang ditangkap oleh closure dan berapa lama closure tersebut akan hidup.

#### **Advanced Closure Patterns (2 jam)**

Closure adalah alat yang sangat serbaguna di Lua, memungkinkan berbagai pola pemrograman canggih.

- **Factory Functions**

  - **Deskripsi Konkret**: Fungsi pabrik adalah fungsi yang tugas utamanya adalah membuat dan mengembalikan fungsi lain (seringkali closure). Fungsi yang dikembalikan biasanya dikonfigurasi atau memiliki state yang diinisialisasi oleh argumen yang diberikan ke fungsi pabrik.
  - **Contoh**: `outerFunction` dan `createSharedUpvalueAccessors` dari contoh sebelumnya adalah fungsi pabrik. Mereka membuat dan mengembalikan fungsi (closure) dengan state atau perilaku tertentu.

    ```lua
    function createGreeter(greetingWord)
        local prefix = greetingWord -- Upvalue
        return function(name)
            print(prefix .. ", " .. name .. "!")
        end
    end

    local sapaHalo = createGreeter("Halo")
    local sapaSelamatPagi = createGreeter("Selamat Pagi")

    sapaHalo("Budi")             -- Output: Halo, Budi!
    sapaSelamatPagi("Citra")   -- Output: Selamat Pagi, Citra!
    ```

- **Private Variable Simulation**

  - **Deskripsi Konkret**: Lua tidak memiliki kata kunci `private` atau `public` seperti di beberapa bahasa OOP. Namun, closure dapat digunakan untuk mensimulasikan variabel privat. Variabel lokal dari fungsi luar yang ditangkap sebagai upvalue oleh fungsi-fungsi dalam (metode) hanya dapat diakses melalui metode-metode tersebut.
  - **Pola**:
    1.  Fungsi luar (konstruktor atau pabrik objek) mendeklarasikan variabel lokal (yang akan menjadi "privat").
    2.  Fungsi luar mendefinisikan fungsi-fungsi dalam (yang akan menjadi "metode publik") yang mengakses atau memodifikasi variabel lokal tersebut.
    3.  Fungsi luar mengembalikan tabel yang berisi metode-metode publik ini. Variabel lokal asli tidak diekspos secara langsung.
  - **Contoh Kode**:

    ```lua
    function createBankAccount(initialBalance)
        local balance = initialBalance -- 'balance' adalah variabel "privat"

        local deposit = function(amount)
            if amount > 0 then
                balance = balance + amount
                print("Deposit " .. amount .. ". Saldo baru: " .. balance)
            else
                print("Jumlah deposit tidak valid.")
            end
        end

        local withdraw = function(amount)
            if amount > 0 and amount <= balance then
                balance = balance - amount
                print("Withdraw " .. amount .. ". Saldo baru: " .. balance)
            else
                print("Jumlah withdraw tidak valid atau saldo tidak cukup.")
            end
        end

        local getBalance = function()
            return balance
        end

        -- Mengekspos hanya metode publik
        return {
            deposit = deposit,
            withdraw = withdraw,
            getBalance = getBalance
            -- 'balance' tidak ada di tabel ini, jadi tidak bisa diakses langsung dari luar
        }
    end

    local myAccount = createBankAccount(100)
    myAccount.deposit(50)    -- Output: Deposit 50. Saldo baru: 150
    myAccount.withdraw(30)   -- Output: Withdraw 30. Saldo baru: 120
    print("Saldo saat ini:", myAccount.getBalance()) -- Output: 120
    -- print(myAccount.balance) -- Akan menghasilkan 'nil' karena 'balance' tidak diekspos
                             -- dan jika mencoba myAccount.balance = 0 juga tidak akan mempengaruhi balance internal.
    ```

- **Module Pattern Implementation**

  - **Deskripsi Konkret**: Pola modul menggunakan closure untuk menciptakan namespace dan menyembunyikan detail implementasi internal. Variabel dan fungsi lokal di dalam file modul tidak terlihat dari luar kecuali jika secara eksplisit diekspos (biasanya dengan menambahkannya ke tabel yang dikembalikan oleh modul).
  - **Pola (Sederhana)**:

    ```lua
    -- my_module.lua
    local moduleData = {} -- Bisa juga tabel modulnya langsung

    local privateVariable = "Ini rahasia modul"
    local privateCounter = 0

    local function privateHelperFunction()
        privateCounter = privateCounter + 1
        print("Helper dipanggil, counter:", privateCounter)
    end

    function moduleData.doSomethingPublic(param)
        privateHelperFunction()
        return "Publik melakukan: " .. param .. " dengan " .. privateVariable
    end

    function moduleData.getCounter()
        return privateCounter
    end

    return moduleData -- Hanya mengekspos 'moduleData' dan isinya
    ```

    Dalam contoh ini, `privateVariable`, `privateCounter`, dan `privateHelperFunction` adalah "privat" untuk modul karena mereka adalah variabel lokal (atau upvalue untuk fungsi publik) dan tidak ditambahkan ke tabel `moduleData` yang dikembalikan.

- **Callback dengan State**

  - **Deskripsi Konkret**: Closure sangat berguna untuk membuat fungsi callback yang mempertahankan state di antara pemanggilan. Callback adalah fungsi yang diteruskan sebagai argumen ke fungsi lain dan akan dipanggil nanti (misalnya, saat event terjadi).
  - **Contoh**:

    ```lua
    function createEventCounter(eventName)
        local count = 0 -- State yang dipertahankan oleh closure callback
        return function() -- Ini adalah closure callback
            count = count + 1
            print("Event '" .. eventName .. "' terjadi. Total: " .. count .. " kali.")
        end
    end

    -- Misalkan ada sistem event
    local eventHandlers = {}
    function registerEventHandler(name, handler)
        eventHandlers[name] = handler
    end
    function triggerEvent(name)
        if eventHandlers[name] then
            eventHandlers[name]()
        end
    end

    local onClickCounter = createEventCounter("click")
    local onKeyPressCounter = createEventCounter("keypress")

    registerEventHandler("click", onClickCounter)
    registerEventHandler("keypress", onKeyPressCounter)

    triggerEvent("click")     -- Output: Event 'click' terjadi. Total: 1 kali.
    triggerEvent("keypress")  -- Output: Event 'keypress' terjadi. Total: 1 kali.
    triggerEvent("click")     -- Output: Event 'click' terjadi. Total: 2 kali.
    ```

    Setiap callback (`onClickCounter`, `onKeyPressCounter`) memiliki state `count`-nya sendiri yang independen.

- **Iterator Creation**

  - **Deskripsi Konkret**: For loop generik di Lua (`for k, v in iteratorFunc, state, initialVal do ... end`) menggunakan fungsi iterator. Closure adalah cara yang sangat umum dan elegan untuk membuat fungsi iterator yang stateful. Fungsi iterator dipanggil berulang kali dan harus mengembalikan nilai berikutnya dalam urutan setiap kali, mempertahankan state dari iterasi sebelumnya.
  - **Pola Iterator Sederhana**: Sebuah fungsi pabrik iterator mengembalikan:
    1.  Fungsi iterator (closure).
    2.  State awal (seringkali tabel yang menyimpan data dan indeks saat ini).
    3.  Nilai inisial untuk variabel kontrol pertama (sering `nil`).
  - **Contoh (Iterator untuk rentang angka dengan langkah)**:

    ```lua
    function rangeIterator(startVal, endVal, stepVal)
        local current = startVal
        local stop = endVal
        local step = stepVal or 1

        -- Ini adalah fungsi iterator (closure)
        return function()
            if (step > 0 and current <= stop) or (step < 0 and current >= stop) then
                local valueToReturn = current
                current = current + step -- Update state (upvalue 'current')
                return valueToReturn
            else
                return nil -- Akhir iterasi
            end
        end
        -- Tidak perlu mengembalikan state atau initialVal jika iterator mengelola semua statenya
        -- secara internal sebagai upvalues dan tidak butuh input dari for loop selain dirinya sendiri.
        -- For loop generik mengharapkan iterator, state, dan initial_value.
        -- Jika iterator adalah closure yang mengelola semua state internalnya sebagai upvalue,
        -- maka 'state' dan 'initial_value' bisa 'nil' atau nilai dummy karena tidak digunakan oleh iteratornya.
        -- Namun, pola yang lebih umum adalah iterator menerima 'state' dan 'control_variable'.
    end

    -- Penggunaan:
    print("Range 1 to 5, step 1:")
    for i in rangeIterator(1, 5, 1) do
        print(i)
    end
    -- Output: 1, 2, 3, 4, 5

    print("\nRange 10 to 0, step -2:")
    for num in rangeIterator(10, 0, -2) do
        print(num)
    end
    -- Output: 10, 8, 6, 4, 2, 0

    -- Pola iterator yang lebih sesuai dengan sintaks for k,v in iterator, state, initial_val
    function createRangeIterator(start_val, end_val, step_val)
        local state = { current = start_val, limit = end_val, step = step_val or 1 }

        local function iterator_func(st, _) -- state table, control_variable (biasanya nil di awal)
            if (st.step > 0 and st.current > st.limit) or (st.step < 0 and st.current < st.limit) then
                return nil -- Selesai
            end
            local value_to_return = st.current
            st.current = st.current + st.step
            return value_to_return
        end
        return iterator_func, state, nil -- iterator function, state table, initial control_var value
    end

    print("\nRange (pola for): 1 to 3")
    for val in createRangeIterator(1, 3) do
        print(val)
    end
    ```

#### **Praktik (3 jam)**

- **Building Closure-Based Modules**:
  - Buat modul kalkulator sederhana (`calculator.lua`) yang memiliki fungsi `add`, `subtract`, `multiply`, `divide`. Modul ini juga harus menyimpan histori operasi terakhir yang dilakukan (misalnya, nama operasi dan hasilnya) sebagai "variabel privat" yang hanya bisa diakses melalui fungsi `getLastOperation()`.
- **State Machine Implementation**:
  - Implementasikan state machine sederhana menggunakan closure. Misalnya, lampu lalu lintas (merah -> hijau -> kuning -> merah). Setiap fungsi state (misalnya, `handleRedState`, `handleGreenState`) bisa menjadi closure yang tahu state berikutnya dan bagaimana transisi. Fungsi utama `nextState()` akan memanggil fungsi state saat ini.
- **Event Handler dengan Closure**:
  - Kembangkan contoh `EventCounter` di atas. Buat fungsi `createDebouncedHandler(eventName, delayMs, originalHandler)` yang mengembalikan closure. Closure ini, ketika dipanggil berulang kali, hanya akan memanggil `originalHandler` setelah `delayMs` berlalu tanpa panggilan baru ke closure debounced tersebut. (Ini memerlukan cara untuk menjadwalkan/membatalkan timer, yang mungkin di luar lingkup Lua standar murni, jadi bisa disederhanakan menjadi "hanya panggil jika X detik telah berlalu sejak panggilan terakhir").
- **Performance Optimization (pada Closure)**:
  - Meskipun closure sangat berguna, pembuatan closure di dalam loop yang sangat ketat performa bisa memiliki overhead.
  - Skenario: Bandingkan performa fungsi yang membuat closure baru di setiap iterasi loop versus fungsi yang menggunakan satu closure yang dibuat di luar loop dan menerima parameter yang berubah. Ini lebih tentang _kapan_ membuat closure daripada closure itu sendiri lambat.

### 5.2 Metavariables dan Environment

Bagian ini membahas bagaimana variabel (khususnya yang merujuk ke tabel dan fungsi) dapat perilakunya dikustomisasi menggunakan metatables, dan bagaimana environment (`_ENV`) mempengaruhi resolusi variabel. Istilah "Metavariables" dalam kurikulum ini kemungkinan besar merujuk pada bagaimana metatables dan metamethods (yang sering disimpan dalam variabel di dalam metatable) mempengaruhi perilaku _variabel yang menyimpan tabel_ atau bagaimana variabel global dicari melalui environment.

#### **Environment Variables (2 jam)**

- **`_ENV` Understanding**

  - **Deskripsi Konkret**: Sejak Lua 5.2, `_ENV` adalah variabel khusus (sebuah _upvalue_ untuk setiap fungsi Lua) yang nilainya adalah tabel yang digunakan sebagai _environment_ pertama ketika fungsi tersebut mencoba mengakses variabel global. Ketika Anda menulis `x` di dalam sebuah fungsi, Lua pertama-tama mencari `x` sebagai variabel lokal. Jika tidak ditemukan, Lua akan mencari `_ENV.x` (yaitu, field `x` di dalam tabel yang dirujuk oleh `_ENV`).
  - **Default `_ENV`**:
    - Di scope global (di luar fungsi mana pun), `_ENV` secara default adalah tabel global `_G`.
    - Ketika sebuah fungsi didefinisikan, ia mewarisi `_ENV` dari scope tempat ia didefinisikan.
  - **Perbedaan dengan `_G`**:
    - `_G` selalu merujuk ke tabel global utama.
    - `_ENV` adalah environment _saat ini_ untuk pencarian variabel bebas (variabel yang bukan lokal atau upvalue). Sebuah fungsi bisa memiliki `_ENV` yang berbeda dari `_G`.
  - **Contoh**:

    ```lua
    x = 10 -- Ini sama dengan _G.x = 10 (karena di scope global, _ENV == _G)
    print(_ENV.x) -- Output: 10

    function foo()
        print("foo _ENV.x:", _ENV.x) -- Secara default, _ENV di foo juga _G
        y = 20 -- Membuat global y (_G.y) karena _ENV adalah _G
    end
    foo() -- Output: foo _ENV.x: 10
    print(_G.y) -- Output: 20
    ```

- **Environment Manipulation**

  - **Deskripsi Konkret**: Anda dapat mengubah tabel `_ENV` untuk sebuah _chunk_ (file Lua) atau untuk fungsi tertentu guna mengontrol bagaimana variabel bebas dicari. Ini adalah mekanisme yang sangat kuat.
  - **Mengubah `_ENV` untuk Chunk**: Jika baris pertama sebuah chunk Lua adalah `local _ENV = some_table`, maka semua referensi ke variabel bebas di chunk tersebut akan dicari di `some_table` (dan apa pun yang di-setup oleh `some_table` melalui metamethod `__index`).
  - **Mengubah `_ENV` untuk Fungsi (melalui `load` atau C API)**: Fungsi `load()` (atau `loadstring()`, `loadfile()`) menerima argumen opsional kelima (`env`) yang menetapkan `_ENV` untuk fungsi yang di-compile. Fungsi `debug.setupvalue` juga dapat digunakan untuk mengubah upvalue `_ENV` dari sebuah fungsi Lua.
  - **Contoh (Mengubah `_ENV` untuk chunk)**:

    ```lua
    -- my_sandboxed_script.lua
    local custom_env = {
        print = print, -- Hanya ekspos 'print' dari global
        MY_VAR = 100,
        add = function(a,b) return a+b end
    }
    -- Baris berikut harus menjadi pernyataan PERTAMA yang dieksekusi di chunk
    -- untuk mengatur _ENV untuk seluruh chunk ini.
    -- Namun, _ENV sebagai variabel lokal hanya berlaku jika itu adalah upvalue pertama.
    -- Cara yang lebih umum untuk chunk adalah:
    -- setfenv(1, custom_env) -- di Lua 5.1
    -- atau di Lua 5.2+, deklarasi _ENV harus merupakan upvalue implisit pertama
    -- atau dimanipulasi saat loading chunk.

    -- Untuk demonstrasi yang lebih mudah dipahami di Lua 5.2+:
    -- Buat fungsi yang _ENV-nya diset saat kompilasi
    local script_code = [[
        print(MY_VAR)       -- Akan mencari MY_VAR di _ENV
        print(add(10, 5))   -- Akan mencari add di _ENV
        -- print(os.time()) -- Akan error jika 'os' tidak ada di _ENV
        GLOBAL_FROM_SCRIPT = "Halo dari skrip" -- Akan membuat entri di _ENV
    ]]

    local custom_env_for_script = {
        print = print,
        MY_VAR = 200,
        add = function(a,b) return a*b end -- Fungsi 'add' yang berbeda
    }
    -- setmetatable(custom_env_for_script, {__index = _G}) -- Opsional: fallback ke global jika tidak ditemukan

    local compiled_func, err = load(script_code, "sandboxed_chunk", "t", custom_env_for_script)
    if compiled_func then
        compiled_func()
        print("Dari luar, MY_VAR di custom_env:", custom_env_for_script.MY_VAR)
        print("Dari luar, GLOBAL_FROM_SCRIPT di custom_env:", custom_env_for_script.GLOBAL_FROM_SCRIPT)
    else
        print("Error kompilasi:", err)
    end
    -- Output:
    -- 200
    -- 50
    -- Dari luar, MY_VAR di custom_env: 200
    -- Dari luar, GLOBAL_FROM_SCRIPT di custom_env: Halo dari skrip
    ```

- **Sandboxing dengan Environments**

  - **Deskripsi Konkret**: Sandboxing adalah teknik untuk menjalankan kode yang tidak dipercaya (atau kode yang ingin diisolasi) dalam lingkungan yang terbatas, di mana aksesnya ke variabel global atau fungsi sistem dibatasi. Mengubah `_ENV` adalah cara utama untuk melakukan sandboxing di Lua 5.2+.
  - **Cara Kerja**:
    1.  Buat tabel environment kustom yang hanya berisi fungsi dan variabel yang aman untuk diakses oleh kode sandboxed.
    2.  Jalankan kode yang tidak dipercaya dengan `_ENV`-nya diatur ke tabel kustom ini.
    3.  (Opsional) Gunakan metatable pada tabel `_ENV` kustom, khususnya `__index = _G` (atau tabel lain yang lebih terbatas), untuk mengizinkan akses baca ke beberapa global tertentu, dan `__newindex` untuk mencegah pembuatan global baru yang tidak diinginkan di environment utama.
  - **Contoh**: Lihat contoh `custom_env_for_script` di atas. Jika `setmetatable` dengan `__index = _G` tidak dilakukan, maka skrip tersebut tidak akan bisa mengakses `os.time()` atau global lainnya kecuali yang secara eksplisit disediakan di `custom_env_for_script`.

- **Module Environments**

  - **Deskripsi Konkret**: Modul dapat memiliki environment-nya sendiri. Ketika sebuah modul ditulis, ia dapat (meskipun tidak selalu umum dilakukan secara eksplisit dengan `_ENV` di setiap fungsi) beroperasi seolah-olah dalam namespace-nya sendiri.
  - **Di Lua 5.1**: Fungsi `module("namaModul", package.seeall)` secara eksplisit membuat modul global dan mengatur environment fungsi-fungsi berikutnya di chunk itu untuk menulis ke tabel modul tersebut. `package.seeall` membuat global lama tetap bisa diakses. Praktik ini _tidak direkomendasikan_ lagi dan dihapus di Lua 5.2+.
  - **Di Lua 5.2+**: Modul standar adalah file Lua yang mengembalikan sebuah tabel. Variabel dan fungsi yang dideklarasikan `local` di dalam file modul bersifat privat untuk modul tersebut. Apa yang ditambahkan ke tabel yang dikembalikan menjadi antarmuka publik modul. `_ENV` di dalam fungsi-fungsi modul tersebut secara default adalah `_G`, kecuali jika modul tersebut dimuat dengan environment kustom.
  - **Sandboxed Module**: Anda bisa memuat modul dengan `loadfile` dan memberinya `_ENV` kustom jika Anda ingin modul tersebut beroperasi dalam sandbox atau dengan set global yang berbeda.

- **Security Considerations**
  - **Bahaya `load` dengan Environment Tidak Aman**: Jika Anda menggunakan `load` (atau `loadstring`/`loadfile`) untuk menjalankan kode dari sumber eksternal dan memberinya `_ENV` yang memiliki akses ke fungsi berbahaya (seperti `os.execute`, `io.open` dengan mode tulis, atau C API yang tidak aman), ini bisa menjadi risiko keamanan besar.
  - **Escape dari Sandbox**: Sandbox yang dibuat hanya dengan `_ENV` sederhana (tanpa membatasi akses ke `debug` library atau C API yang bisa memanipulasi environment atau upvalues) mungkin tidak sepenuhnya aman. Kode berbahaya yang canggih mungkin bisa mencoba "kabur" dari sandbox.
  - **Prinsip Least Privilege**: Saat membuat environment untuk sandboxing, berikan hanya izin dan akses minimal yang benar-benar diperlukan oleh kode yang akan dijalankan.

#### **Metatable Variables (2 jam)**

Istilah "Metatable Variables" di sini diinterpretasikan sebagai bagaimana metatables (yang seringkali disimpan dalam variabel) dan metamethods (fungsi yang juga disimpan dalam variabel di dalam metatable) digunakan untuk mengontrol dan mendefinisikan perilaku _variabel yang menyimpan tabel_.

- **Metatable Storage**

  - **Deskripsi Konkret**: Metatable itu sendiri adalah tabel biasa. Anda dapat menyimpannya dalam variabel lokal atau global, sama seperti tabel lainnya. Fungsi `setmetatable(tabel, metatable)` mengasosiasikan `tabel` dengan `metatable`-nya.
  - **Pola Umum**: Seringkali, satu metatable digunakan bersama oleh banyak tabel yang memiliki perilaku serupa (misalnya, semua objek dari "kelas" tertentu berbagi metatable yang sama).
  - **Contoh**:

    ```lua
    local myMetatable = {
        __tostring = function(t) return "Tabel dengan nilai: " .. t.value end
    }

    local tabel1 = { value = 10 }
    setmetatable(tabel1, myMetatable)

    local tabel2 = { value = 20 }
    setmetatable(tabel2, myMetatable) -- tabel1 dan tabel2 berbagi myMetatable

    print(tabel1) -- Output: Tabel dengan nilai: 10
    print(tabel2) -- Output: Tabel dengan nilai: 20
    ```

- **Metamethod Variables**

  - **Deskripsi Konkret**: Metamethods (seperti `__index`, `__newindex`, `__add`, `__tostring`, dll.) adalah field khusus di dalam metatable. Nilai dari field ini biasanya adalah _fungsi_ (yang disimpan dalam "variabel" field tersebut). Fungsi-fungsi inilah yang dipanggil Lua ketika operasi tertentu dilakukan pada tabel yang memiliki metatable tersebut.
  - **Contoh**:

    ```lua
    local VectorMetatable = {} -- Variabel untuk menyimpan metatable

    -- Fungsi-fungsi yang akan menjadi metamethods
    local function vector_add(v1, v2)
        return { x = v1.x + v2.x, y = v1.y + v2.y } -- Implementasi __add
    end

    local function vector_tostring(v)
        return string.format("Vector(%s, %s)", tostring(v.x), tostring(v.y)) -- Implementasi __tostring
    end

    -- Menugaskan fungsi ke field metamethod di dalam VectorMetatable
    VectorMetatable.__add = vector_add
    VectorMetatable.__tostring = vector_tostring

    -- Fungsi untuk membuat vektor baru dengan metatable ini
    function newVector(x, y)
        local vec = { x = x, y = y }
        setmetatable(vec, VectorMetatable)
        return vec
    end

    local vA = newVector(1, 2)
    local vB = newVector(3, 4)

    local vC = vA + vB -- Memanggil VectorMetatable.__add (yaitu, fungsi vector_add)
    print(vC)          -- Memanggil VectorMetatable.__tostring (yaitu, fungsi vector_tostring)
                       -- Output: Vector(4, 6)
    ```

    Di sini, `VectorMetatable.__add` adalah "metamethod variable" yang menyimpan referensi ke fungsi `vector_add`.

- **`__index` dan `__newindex`**

  - **Deskripsi Konkret (Pengingat dari Modul 3 & 4)**:
    - **`__index`**: Dipanggil ketika Lua mencoba membaca field yang tidak ada secara langsung di dalam sebuah tabel. Jika `__index` adalah fungsi, ia dipanggil. Jika `__index` adalah tabel lain, Lua akan mencari field tersebut di tabel `__index` tersebut. Ini adalah dasar untuk inheritance (pewarisan) dan delegasi.
    - **`__newindex`**: Dipanggil ketika Lua mencoba menulis ke field yang tidak ada secara langsung di dalam sebuah tabel. Jika `__newindex` adalah fungsi, ia dipanggil. Ini digunakan untuk mengontrol penambahan field baru, membuat tabel read-only, atau mengarahkan penulisan ke tempat lain.
  - **Bagaimana Mereka Mempengaruhi Variabel**: Ketika sebuah variabel `myTableVar` menyimpan referensi ke sebuah tabel, dan Anda melakukan `myTableVar.someField` (baca) atau `myTableVar.someNewField = value` (tulis), metamethod `__index` atau `__newindex` dari metatable `myTableVar` (jika ada dan field tidak ada di `myTableVar` itu sendiri) akan menentukan hasil atau perilaku operasi tersebut. Jadi, metatable ini secara efektif mendefinisikan perilaku akses "variabel" field di dalam `myTableVar`.

- **Variable Access Control**

  - **Deskripsi Konkret**: Menggunakan `__index` dan `__newindex` adalah cara utama untuk mengontrol akses (baca dan tulis) ke field-field sebuah tabel, yang pada gilirannya mengontrol bagaimana "variabel" (field) di dalam tabel tersebut berperilaku.
  - **Contoh (Read-Only dan Logging)**:

    ```lua
    function createControlledTable(initialData)
        local data = initialData or {}
        local mt = {
            __index = function(t, key)
                print("LOG: Membaca field '" .. tostring(key) .. "'")
                return rawget(data, key) -- Akses data internal
            end,
            __newindex = function(t, key, value)
                print("LOG: Mencoba menulis field '" .. tostring(key) .. "' dengan nilai '" .. tostring(value) .. "'")
                -- rawset(data, key, value) -- Jika ingin mengizinkan tulis ke data internal
                error("Tabel ini read-only untuk field baru!", 2) -- Atau cegah penulisan
            end
        }
        -- Khusus untuk field yang sudah ada di 'data' saat pembuatan, __newindex tidak akan terpicu
        -- Jika ingin field yang sudah ada juga read-only, 'data' harusnya proxy atau __newindex harus lebih canggih
        -- atau 'data' itu sendiri adalah tabel kosong dan semua akses awal lewat __newindex yang mengisi tabel lain.
        -- Cara sederhana: buat salinan internal dan jangan pernah ubah 'data' setelah setmetatable.
        local proxy = {}
        setmetatable(proxy, mt)

        -- Inisialisasi data internal melalui proxy, ini akan ter-log jika __newindex mengizinkan
        -- For read-only after creation:
        -- setmetatable(data, mt)
        -- return data
        -- For controlled access from start using proxy:
        for k,v in pairs(data) do rawset(proxy, k, v) end -- bypass __newindex for initial setup of proxy
                                                          -- or make 'data' private and mt.__index points to it

        return proxy -- Ini contoh dengan proxy, jika ingin data asli tidak disentuh
                       -- atau jika ingin kontrol lebih pada data yang sudah ada
    end

    local myData = createControlledTable({ x = 10 })
    -- myData.x = 10 -- Seharusnya dilakukan saat pembuatan controlled table jika field x ada
    -- atau __newindex mengizinkannya jika x belum ada di 'data' internal.

    -- Jika 'data' internal dilindungi oleh __newindex pada metatable-nya:
    -- Contoh dengan data internal yang dikontrol:
    function createProtectedStorage()
        local storage = {} -- Data "privat"
        local mt = {
            __index = function(t, key)
                print("Accessing:", key)
                return storage[key]
            end,
            __newindex = function(t, key, value)
                print("Setting:", key, "to", value)
                if key == "id" and storage.id then error("ID cannot be changed",2) end
                storage[key] = value
            end
        }
        return setmetatable({}, mt)
    end

    local protStore = createProtectedStorage()
    protStore.name = "Contoh"    -- Setting: name to Contoh
    protStore.id = 123          -- Setting: id to 123
    print(protStore.name)       -- Accessing: name --> Output: Contoh
    -- protStore.id = 456       -- Akan error: ID cannot be changed
    ```

- **Dynamic Behavior Implementation**

  - **Deskripsi Konkret**: Metatables memungkinkan tabel merespons operasi dengan cara yang dinamis dan kustom. Misalnya, sebuah tabel bisa berperilaku seolah-olah memiliki field tak terbatas yang nilainya dihitung secara on-the-fly, atau properti yang ketika diakses memicu logika tertentu.
  - **Contoh (Default Value atau Calculated Fields)**:

    ```lua
    local defaultValueTable_mt = {
        __index = function(t, key)
            -- Jika field tidak ada, kembalikan nilai default 0
            -- atau lakukan perhitungan dinamis
            if type(key) == "string" and string.match(key, "^sum_") then
                local numStr = string.sub(key, 5) -- Ambil bagian setelah "sum_"
                local num = tonumber(numStr)
                if num then return (rawget(t, "base") or 0) + num end
            end
            return 0 -- Default untuk field lain yang tidak ada
        end
    }

    local myDynamicTable = { base = 100 }
    setmetatable(myDynamicTable, defaultValueTable_mt)

    print(myDynamicTable.base)     -- Output: 100 (ada di tabel asli)
    print(myDynamicTable.x)        -- Output: 0 (tidak ada, __index mengembalikan default 0)
    print(myDynamicTable.y)        -- Output: 0
    print(myDynamicTable.sum_50)   -- Output: 150 (100 + 50, dihitung oleh __index)

    myDynamicTable.x = 10 -- Menulis ke field x, sekarang x ada di tabel asli
    print(myDynamicTable.x)        -- Output: 10 (tidak lagi lewat __index)
    ```

#### **Global Environment Management (2 jam)**

Mengelola dan mengkustomisasi environment global tempat variabel global disimpan.

- **Global Table Customization (`_G`)**

  - **Deskripsi Konkret**: Tabel global `_G` itu sendiri adalah tabel biasa. Artinya, Anda _bisa_ memberinya metatable untuk mengintersep akses ke variabel global.
  - **PERINGATAN**: Memodifikasi metatable dari `_G` adalah operasi yang sangat canggih dan berpotensi berbahaya. Ini dapat mengubah perilaku fundamental dari pencarian variabel global di seluruh skrip Lua Anda dan bisa sangat sulit untuk di-debug jika tidak dilakukan dengan benar. Gunakan dengan sangat hati-hati.
  - **Potensi Penggunaan (Teoretis/Canggih)**:
    - Logging semua akses ke global.
    - Mencegah pembuatan global baru yang tidak diinginkan secara ketat.
    - Mengimplementasikan perilaku default untuk global yang tidak terdefinisi.
  - **Contoh (Logging Akses Global - SANGAT HATI-HATI)**:

    ```lua
    -- JANGAN JALANKAN INI DI KODE PRODUKSI KECUALI ANDA TAHU PERSIS APA YANG DILAKUKAN
    -- local original_G_mt = getmetatable(_G) -- Simpan metatable asli jika ada (biasanya nil)

    -- local G_metatable = {
    --     __index = function(t, key)
    --         print("GLOBAL_ACCESS_LOG: Reading global '" .. tostring(key) .. "'")
    --         -- Jika ingin fallback ke perilaku normal (cari di _G itu sendiri):
    --         -- Hati-hati infinite recursion jika key tidak ada.
    --         -- Perlu cara untuk membedakan lookup awal dan lookup rekursif.
    --         -- Cara lebih aman: simpan _G asli atau gunakan rawget jika _G itu sendiri yang jadi target.
    --         return rawget(_G, key) -- Mengambil dari _G tanpa memicu __index lagi
    --     end,
    --     __newindex = function(t, key, value)
    --         print("GLOBAL_ACCESS_LOG: Writing global '" .. tostring(key) .. "' with value '" .. tostring(value) .. "'")
    --         rawset(_G, key, value) -- Menulis ke _G tanpa memicu __newindex lagi
    --     end
    -- }
    -- setmetatable(_G, G_metatable)

    -- testGlobal = 100 -- Akan ter-log oleh __newindex
    -- print(testGlobal)  -- Akan ter-log oleh __index
    ```

    Contoh di atas disederhanakan; implementasi yang robust lebih rumit untuk menghindari infinite loop dan menangani semua kasus.

- **Variable Access Tracking**

  - **Deskripsi Konkret**: Mirip dengan kustomisasi `_G`, Anda dapat melacak akses variabel (terutama global atau field tabel tertentu) dengan menggunakan metatables (`__index`, `__newindex`) untuk mencatat (log) setiap operasi baca atau tulis.
  - **Aplikasi**: Debugging, profiling, atau audit keamanan untuk melihat bagaimana data tertentu diakses dan dimodifikasi.

- **Dynamic Global Creation**

  - **Deskripsi Konkret**: Secara default, jika Anda menulis ke nama variabel yang bukan lokal dan tidak ada di `_ENV` saat ini, Lua akan membuat field baru di tabel `_ENV` tersebut (yang defaultnya adalah `_G`).
  - **Mengontrol dengan `__newindex` pada `_ENV` atau `_G`**: Jika `_ENV` (atau `_G`) memiliki metamethod `__newindex`, maka upaya untuk membuat global baru akan memanggil fungsi `__newindex` tersebut. Ini dapat digunakan untuk mengizinkan, menolak, atau memodifikasi perilaku pembuatan global dinamis.
  - **Contoh (Mencegah Global Baru)**:
    ```lua
    -- (Pastikan ini dijalankan di environment yang aman untuk eksperimen)
    -- local mt_prevent_new_globals = {
    --     __newindex = function(t, key, value)
    --         -- Hanya izinkan penulisan ke global yang sudah ada (atau yang secara eksplisit didefinisikan)
    --         if rawget(t, key) ~= nil or key == "myAllowedNewGlobal" then
    --             rawset(t, key, value)
    --         else
    --             error("Attempt to create an undeclared global variable: " .. tostring(key), 2)
    --         end
    --     end,
    --     __index = _G -- Agar global yang sudah ada tetap bisa dibaca
    -- }
    -- Untuk Lua 5.2+, jika Anda ingin mempengaruhi _ENV di fungsi:
    -- local myRestrictedEnv = {}
    -- setmetatable(myRestrictedEnv, mt_prevent_new_globals)
    -- -- Kemudian jalankan kode dengan _ENV = myRestrictedEnv
    ```

- **Namespace Management**

  - **Deskripsi Konkret**: Namespace membantu mengorganisir kode dan mencegah konflik nama. Di Lua, namespace biasanya diimplementasikan menggunakan tabel.
  - **Variabel Global sebagai Namespace**: Sebaiknya dihindari. Daripada banyak variabel global, lebih baik satu variabel global yang merupakan tabel namespace.

    ```lua
    -- Buruk:
    -- utils_format = function() ... end
    -- utils_parse = function() ... end

    -- Baik:
    Utils = {}
    Utils.format = function() ... end
    Utils.parse = function() ... end
    ```

  - **Modul adalah Namespace Utama**: Pola modul standar (file Lua mengembalikan tabel) adalah cara terbaik untuk namespace management. Variabel di dalam modul bersifat lokal, dan hanya apa yang ditambahkan ke tabel yang dikembalikan yang menjadi publik di bawah "namespace" modul tersebut.
  - **Environment untuk Namespace**: `_ENV` bisa digunakan untuk membuat fungsi beroperasi seolah-olah di dalam namespace tertentu secara default untuk variabel bebasnya, meskipun ini kurang umum dibandingkan pola modul standar.

- **Module System Integration**
  - **Deskripsi Konkret**: Sistem modul Lua (`require`) berintegrasi dengan konsep environment.
    - `require("modulename")` akan mengeksekusi file `modulename.lua`. Kode di dalam file tersebut berjalan. Jika file tersebut mengembalikan nilai (biasanya tabel modul), `require` akan mengembalikan nilai tersebut dan juga menyimpannya di `package.loaded[modulename]` untuk mencegah pemuatan ulang.
    - Fungsi `loadfile` dapat digunakan untuk memuat chunk modul dengan `_ENV` kustom jika diperlukan isolasi atau environment yang berbeda dari `_G` default.
  - **Kaitan dengan Variabel**: Modul membantu mengelola scope variabel, menjadikan sebagian besar variabel modul bersifat lokal dan hanya mengekspos antarmuka yang terkontrol. Ini adalah praktik terbaik untuk menghindari polusi global dan menciptakan kode yang dapat dipelihara.

---

Ini menandai akhir dari "Kurikulum Lengkap Variabel di Lua". Anda sekarang telah menjelajahi konsep variabel di Lua dari dasar hingga penggunaan yang sangat canggih. Pemahaman yang kuat tentang variabel, scope, lifetime, referensi, mutabilitas, closure, metatables, dan environment akan menjadi fondasi yang sangat solid untuk menguasai aspek-aspek lain dari pemrograman Lua.

## **Selamat!**

> - **[Ke Atas](#)**
> - **[Sebelumnya][3]**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum Lengkap][2]**
> - **[Kurikulum Dasar][4]**
> - **[Domain Spesifik][5]**

[5]: ../../../../../../../README.md
[4]: ../../../../README.md
[3]: ../4-advanced-variable-concepts/README.md
[2]: ../../../../../README.md
[1]: ../../README.md
[selanjutnya]: ../../../kontrol-flow/materi/README.md
