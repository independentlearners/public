# 📚 **Bagian 4: Advanced Control Flow Patterns**

Bagian ini akan memperkenalkan Anda pada teknik-teknik yang lebih abstrak dan kuat untuk mengelola alur program. Ini seringkali melibatkan penggunaan fitur-fitur unik Lua seperti tabel dan fungsi sebagai nilai kelas satu (first-class values) serta metatabel untuk menciptakan logika kontrol yang fleksibel dan ekspresif.

### 4.1 Table-Driven Control Flow

**Durasi yang Disarankan:** 4-5 jam

Kita sudah sedikit menyinggung ini saat membahas simulasi `switch-case`. Pola ini memperluas ide tersebut, di mana tabel digunakan secara ekstensif untuk mengarahkan alur program, seringkali menggantikan banyak pernyataan kondisional `if/else` yang bercabang.

#### **Deskripsi Konkret**

Table-driven control flow adalah sebuah teknik di mana perilaku atau alur program ditentukan oleh data yang tersimpan dalam tabel, bukan oleh serangkaian instruksi kondisional yang tetap (hardcoded). Tabel ini bisa berisi fungsi (untuk tindakan), data lain (untuk konfigurasi), atau bahkan tabel lain (untuk sub-logika).

#### **Terminologi dan Konsep Mendasar**

- **Dispatch Table (Tabel Pengiriman)**: Tabel yang memetakan kunci (seringkali string atau angka yang mewakili kondisi atau perintah) ke fungsi atau data yang menentukan tindakan selanjutnya.
- **State Machine (Mesin Keadaan)**: Model komputasi di mana sistem dapat berada dalam salah satu dari sejumlah keadaan (state) terbatas. Transisi dari satu keadaan ke keadaan lain dipicu oleh input atau kondisi. Tabel sering digunakan untuk merepresentasikan state dan transisinya.
- **Command Pattern (Pola Perintah)**: Pola desain perilaku di mana sebuah objek digunakan untuk merangkum semua informasi yang dibutuhkan untuk melakukan tindakan atau memicu suatu kejadian di waktu mendatang. Tabel fungsi dapat digunakan untuk mengimplementasikan varian sederhana dari pola ini.

#### **Topik yang Dipelajari (Sesuai Kurikulum dan Penjelasan Tambahan)**

- **State machines menggunakan tables (Mesin Keadaan menggunakan tabel)**:

  - **Deskripsi**: Anda dapat merepresentasikan setiap _state_ (keadaan) dari sistem Anda sebagai sebuah entri dalam tabel. Setiap entri ini bisa berupa tabel lain yang mendefinisikan tindakan (fungsi) untuk berbagai _event_ (kejadian/input) yang mungkin terjadi saat berada dalam state tersebut, serta state berikutnya setelah tindakan dilakukan.
  - **Contoh Kode**: Mesin keadaan sederhana untuk lampu lalu lintas.

    ```lua
    local lampuLaluLintas = {}
    lampuLaluLintas.currentState = "merah" -- Keadaan awal

    -- Definisi state dan transisinya
    lampuLaluLintas.states = {
        merah = {
            deskripsi = "Lampu Merah: Berhenti!",
            timerHabis = function(self)
                print("Timer merah habis. Mengubah ke hijau.")
                self.currentState = "hijau"
            end,
            adaKendaraanDarurat = function(self)
                print("Kendaraan darurat! Tetap merah atau kembali ke merah.")
                self.currentState = "merah" -- Contoh sederhana
            end
        },
        hijau = {
            deskripsi = "Lampu Hijau: Jalan!",
            timerHabis = function(self)
                print("Timer hijau habis. Mengubah ke kuning.")
                self.currentState = "kuning"
            end
        },
        kuning = {
            deskripsi = "Lampu Kuning: Hati-hati!",
            timerHabis = function(self)
                print("Timer kuning habis. Mengubah ke merah.")
                self.currentState = "merah"
            end
        }
    }

    -- Fungsi untuk memproses event
    function lampuLaluLintas:handleEvent(eventName)
        local stateActions = self.states[self.currentState]
        if stateActions and stateActions[eventName] then
            print("Status Saat Ini:", stateActions.deskripsi)
            stateActions[eventName](self) -- Panggil fungsi aksi, 'self' merujuk ke tabel lampuLaluLintas
            print("Status Baru:", self.states[self.currentState].deskripsi)
        else
            print("Event '" .. eventName .. "' tidak valid untuk state '" .. self.currentState .. "'")
        end
        print("---")
    end

    -- Simulasi
    lampuLaluLintas:handleEvent("timerHabis") -- Dari merah ke hijau
    lampuLaluLintas:handleEvent("timerHabis") -- Dari hijau ke kuning
    lampuLaluLintas:handleEvent("adaKendaraanDarurat") -- Event tidak ada di kuning
    lampuLaluLintas:handleEvent("timerHabis") -- Dari kuning ke merah
    ```

  - **Penjelasan Mendalam**:
    - Struktur di atas sangat fleksibel. Anda bisa menambahkan state baru atau event baru dengan mudah.
    - Setiap fungsi aksi menerima `self` (dalam hal ini, `lampuLaluLintas`) sehingga bisa memodifikasi `currentState` atau data lain dalam objek state machine.
    - Ini jauh lebih terorganisir daripada serangkaian `if/elseif` yang panjang untuk setiap kombinasi state dan event.

- **Command patterns dengan function tables (Pola Perintah dengan tabel fungsi)**:

  - **Deskripsi**: Mirip dengan dispatch table yang sudah dibahas di Bagian 1.2, di sini tabel digunakan untuk menyimpan "perintah" sebagai fungsi. Ini memungkinkan Anda untuk memisahkan pemanggil perintah dari pelaksana perintah. Perintah dapat diantrekan, dibatalkan (jika diimplementasikan), atau dieksekusi secara dinamis.
  - **Contoh Kode**: Editor teks sederhana dengan perintah.

    ```lua
    local editor = { text = "" }

    local commands = {
        tulis = function(teksBaru)
            editor.text = editor.text .. teksBaru
            print("Teks saat ini: '" .. editor.text .. "'")
        end,
        hapusKarakterTerakhir = function()
            if #editor.text > 0 then
                editor.text = string.sub(editor.text, 1, -2)
            end
            print("Teks saat ini: '" .. editor.text .. "'")
        end,
        cetak = function()
            print("Final: '" .. editor.text .. "'")
        end
    }

    -- Fungsi untuk mengeksekusi perintah
    local function executeCommand(commandName, ...)
        local cmdFunc = commands[commandName]
        if cmdFunc then
            cmdFunc(...) -- Melewatkan argumen tambahan ke fungsi perintah
        else
            print("Perintah tidak dikenal: " .. commandName)
        end
    end

    executeCommand("tulis", "Halo ")
    executeCommand("tulis", "Dunia!")
    executeCommand("hapusKarakterTerakhir")
    executeCommand("cetak")
    executeCommand("simpan") -- Perintah tidak dikenal
    ```

- **Dispatch tables untuk complex control logic (Tabel Pengiriman untuk logika kontrol kompleks)**:

  - **Deskripsi**: Ini adalah perluasan dari simulasi switch-case (Bagian 1.2) untuk menangani logika yang lebih rumit. Kunci dalam tabel bisa berupa hasil evaluasi kondisi, dan nilai bisa berupa fungsi yang menangani sub-logika yang lebih kompleks, atau bahkan tabel dispatch lain untuk keputusan bertingkat.
  - **Contoh Kode**: Logika berdasarkan tipe pengguna dan aksi.

    ```lua
    local function handleAdminView() print("Admin melihat dasbor.") end
    local function handleAdminEdit() print("Admin mengedit konfigurasi.") end
    local function handleUserView() print("Pengguna melihat profil.") end
    local function handleUserEdit() print("Pengguna mengedit profil.") end
    local function handleGuestView() print("Tamu melihat halaman utama.") end

    local userActions = {
        admin = {
            lihat = handleAdminView,
            edit = handleAdminEdit
        },
        pengguna = {
            lihat = handleUserView,
            edit = handleUserEdit
        },
        tamu = {
            lihat = handleGuestView,
            edit = function() print("Tamu tidak bisa mengedit.") end -- Aksi default jika tidak ada
        }
    }

    local function performAction(userType, actionType)
        local typeSpecificActions = userActions[userType]
        if typeSpecificActions then
            local actionFunc = typeSpecificActions[actionType]
            if actionFunc then
                actionFunc()
            else
                print("Aksi '" .. actionType .. "' tidak valid untuk tipe pengguna '" .. userType .. "'.")
            end
        else
            print("Tipe pengguna '" .. userType .. "' tidak dikenal.")
        end
    end

    performAction("admin", "lihat")
    performAction("pengguna", "edit")
    performAction("tamu", "edit")
    performAction("editor", "lihat") -- Tipe pengguna tidak dikenal
    performAction("admin", "hapus")  -- Aksi tidak valid
    ```

- **Performance optimization techniques (Teknik optimasi performa)**:
  - **Deskripsi**: Sama seperti pada simulasi switch-case sederhana, lookup tabel di Lua umumnya sangat cepat (mendekati O(1) untuk bagian hash).
  - **Pertimbangan**:
    - **Ukuran Tabel**: Untuk tabel yang sangat besar, overhead memori bisa menjadi pertimbangan.
    - **Frekuensi Perubahan**: Jika tabel dispatch sering berubah, pastikan proses pembaruannya efisien.
    - **Caching**: Jika kunci untuk lookup tabel berasal dari perhitungan yang mahal, cache hasil perhitungan tersebut.
    - **Alternatif**: Untuk kasus yang sangat sederhana dan kritis performa, rantai `if/elseif` pendek mungkin sedikit lebih cepat, tetapi ini jarang signifikan dan seringkali mengorbankan keterbacaan dan kemudahan pemeliharaan. Utamakan kejelasan kecuali profiling menunjukkan adanya bottleneck.

#### **Penjelasan Mendalam Tambahan**

- **Keterbacaan dan Pemeliharaan**: Manfaat utama dari table-driven control flow adalah peningkatan keterbacaan dan kemudahan pemeliharaan untuk logika yang kompleks. Perubahan atau penambahan perilaku baru seringkali hanya melibatkan modifikasi data dalam tabel, bukan perubahan logika kode inti.
- **Fleksibilitas**: Data dalam tabel bisa dimuat dari file konfigurasi, memungkinkan perubahan perilaku program tanpa mengkompilasi ulang kode.

#### **Sumber Belajar (dari README.md)**:

- [Lua-users Wiki: Finite State Machine](http://lua-users.org/wiki/FiniteStateMachine)
- [Programming Patterns in Lua](http://lua-users.org/wiki/LuaTutorial) (Mungkin merujuk ke bagian "Lua Tutorial" di lua-users.org yang lebih luas yang mencakup berbagai pola)

---

### 4.2 Functional Control Flow

**Durasi yang Disarankan:** 3-4 jam

Pendekatan fungsional untuk kontrol alur menekankan penggunaan fungsi sebagai blok bangunan utama. Lua sangat mendukung paradigma ini karena fungsi adalah "first-class citizens".

#### **Deskripsi Konkret**

Functional control flow melibatkan penggunaan fungsi orde tinggi (higher-order functions), fungsi anonim (closures), dan teknik seperti komposisi fungsi untuk mengarahkan eksekusi program. Ini seringkali menghasilkan kode yang lebih deklaratif (Anda menyatakan _apa_ yang ingin dicapai, bukan _bagaimana_ langkah demi langkahnya) dan dapat mengurangi state yang bisa berubah (mutable state).

#### **Terminologi dan Konsep Mendasar**

- **First-Class Functions (Fungsi Kelas Satu)**: Di Lua, fungsi adalah tipe data seperti angka atau string. Mereka dapat disimpan dalam variabel, dilewatkan sebagai argumen ke fungsi lain, dikembalikan sebagai hasil dari fungsi lain, dan disimpan dalam tabel.
- **Higher-Order Functions (Fungsi Orde Tinggi)**: Fungsi yang melakukan setidaknya satu dari berikut ini:
  1.  Menerima satu atau lebih fungsi sebagai argumen.
  2.  Mengembalikan sebuah fungsi sebagai hasilnya.
- **Closure**: Fungsi yang "mengingat" lingkungan leksikal tempat ia didefinisikan, bahkan jika ia dieksekusi di luar lingkungan tersebut. Ini berarti ia memiliki akses ke variabel lokal (disebut _upvalues_) dari fungsi pembungkusnya. Iterator yang kita bahas sebelumnya seringkali adalah closure.
- **Immutability (Kekekalan)**: Prinsip di mana data tidak diubah setelah dibuat. Meskipun Lua tidak memberlakukan immutability secara ketat, gaya pemrograman fungsional sering berusaha meminimalkan modifikasi state.
- **Pure Functions (Fungsi Murni)**: Fungsi yang:
  1.  Outputnya hanya bergantung pada inputnya (tidak ada efek samping tersembunyi atau ketergantungan pada state global).
  2.  Tidak memiliki efek samping (tidak memodifikasi state di luar dirinya, seperti variabel global atau argumen yang dilewatkan melalui referensi).

#### **Topik yang Dipelajari (Sesuai Kurikulum dan Penjelasan Tambahan)**

- **Higher-order functions untuk control flow (Fungsi orde tinggi untuk kontrol alur)**:

  - **Deskripsi**: Daripada menulis loop eksplisit atau kondisional, Anda bisa menggunakan fungsi orde tinggi yang merangkum pola kontrol alur umum.
  - **Contoh**: Fungsi `forEach` sederhana yang menerapkan fungsi ke setiap elemen tabel.

    ```lua
    local function forEach(tabel, aksi)
        for k, v in pairs(tabel) do
            aksi(v, k) -- Memanggil fungsi 'aksi' dengan nilai dan kunci
        end
    end

    local angka = {10, 20, 30}
    forEach(angka, function(val, idx)
        print("Elemen ke-" .. idx .. ": " .. val * 2)
    end)
    -- Output:
    -- Elemen ke-1: 20
    -- Elemen ke-2: 40
    -- Elemen ke-3: 60

    local nama = {namaDepan="Budi", namaBelakang="Santoso"}
    forEach(nama, function(val, key)
        print(key .. ": " .. string.upper(val))
    end)
    -- Output (urutan tidak dijamin):
    -- namaDepan: BUDI
    -- namaBelakang: SANTOSO
    ```

- **Map, filter, reduce patterns (Pola map, filter, reduce)**:

  - **Deskripsi**: Ini adalah tiga fungsi orde tinggi yang sangat umum dalam pemrograman fungsional untuk memproses koleksi data.
    - **`map`**: Membuat tabel baru dengan menerapkan fungsi tertentu ke setiap elemen dari tabel asli. Hasilnya adalah tabel baru dengan ukuran yang sama.
    - **`filter`**: Membuat tabel baru yang berisi elemen-elemen dari tabel asli yang memenuhi kondisi tertentu (di mana fungsi predikat mengembalikan `true`).
    - **`reduce` (atau `fold`)**: Menerapkan fungsi secara kumulatif ke elemen-elemen tabel untuk mereduksinya menjadi satu nilai tunggal (misalnya, jumlah, rata-rata, atau penggabungan string).
  - **Contoh Kode**:

    ```lua
    -- Implementasi Map
    local function map(tabel, transformasi)
        local hasil = {}
        for i, v in ipairs(tabel) do -- Asumsi tabel adalah sequence untuk map sederhana
            hasil[i] = transformasi(v)
        end
        return hasil
    end

    -- Implementasi Filter
    local function filter(tabel, predikat)
        local hasil = {}
        local count = 0
        for _, v in ipairs(tabel) do -- Asumsi tabel adalah sequence
            if predikat(v) then
                count = count + 1
                hasil[count] = v
            end
        end
        return hasil
    end

    -- Implementasi Reduce (sederhana untuk sequence)
    local function reduce(tabel, fungsiGabung, nilaiAwal)
        local akumulator = nilaiAwal
        for _, v in ipairs(tabel) do
            akumulator = fungsiGabung(akumulator, v)
        end
        return akumulator
    end

    local angka = {1, 2, 3, 4, 5}

    -- Map: kalikan setiap angka dengan 2
    local angkaKaliDua = map(angka, function(x) return x * 2 end)
    forEach(angkaKaliDua, print) -- Output: 2, 4, 6, 8, 10 (masing-masing di baris baru)

    -- Filter: ambil angka genap
    local angkaGenap = filter(angka, function(x) return x % 2 == 0 end)
    forEach(angkaGenap, print) -- Output: 2, 4 (masing-masing di baris baru)

    -- Reduce: jumlahkan semua angka
    local jumlah = reduce(angka, function(total, n) return total + n end, 0)
    print("Jumlah: " .. jumlah) -- Output: Jumlah: 15
    ```

  - **Catatan**: Implementasi `map`, `filter`, `reduce` di atas adalah untuk tabel yang dianggap sebagai _sequence_ (array). Untuk tabel generik (dengan kunci non-numerik), perilakunya mungkin perlu disesuaikan (misalnya, `map` dan `filter` bisa menghasilkan tabel dengan kunci yang sama, atau `reduce` mungkin perlu menangani kunci juga).

- **Function composition (Komposisi Fungsi)**:

  - **Deskripsi**: Proses menggabungkan dua atau lebih fungsi untuk menghasilkan fungsi baru. Output dari satu fungsi menjadi input untuk fungsi berikutnya. Jika `f` dan `g` adalah fungsi, komposisi `(f o g)(x)` sama dengan `f(g(x))`.
  - **Contoh Kode**:

    ```lua
    local function tambahSatu(x) return x + 1 end
    local function kaliDua(x) return x * 2 end

    -- Komposisi manual
    local hasilManual = tambahSatu(kaliDua(5)) -- tambahSatu(10) -> 11
    print("Hasil manual: " .. hasilManual)

    -- Fungsi untuk komposisi (sederhana, dua fungsi)
    local function compose(f, g)
        return function(...) -- Menggunakan ... untuk argumen variabel
            return f(g(...))
        end
    end

    local tambahSatuSetelahKaliDua = compose(tambahSatu, kaliDua)
    local hasilKomposisi = tambahSatuSetelahKaliDua(5) -- sama dengan f(g(5))
    print("Hasil komposisi: " .. hasilKomposisi) -- Output: 11

    -- Contoh penggunaan dengan map
    local angka = {1, 2, 3}
    local angkaDiproses = map(angka, tambahSatuSetelahKaliDua)
    forEach(angkaDiproses, print) -- Output: 3, 5, 7
    ```

- **Tail call optimization (Optimasi Panggilan Ekor)**:

  - **Deskripsi**: Ini adalah fitur penting di Lua yang memungkinkan rekursi mendalam tanpa menyebabkan _stack overflow_ (penumpukan stack yang berlebihan). Sebuah "tail call" terjadi jika panggilan fungsi adalah tindakan terakhir yang dilakukan oleh fungsi lain sebelum kembali. Dalam kasus ini, Lua tidak membuat frame stack baru untuk panggilan ekor, melainkan menggunakan kembali frame stack saat ini.
  - **Syarat Tail Call**: Panggilan ke fungsi `g` dari fungsi `f` adalah tail call jika `f` tidak melakukan operasi apa pun setelah `g` kembali, kecuali mengembalikan nilai yang dikembalikan oleh `g`.

    ```lua
    -- INI ADALAH TAIL CALL
    function f(x)
        -- tidak ada operasi setelah g(x)
        return g(x)
    end

    -- INI BUKAN TAIL CALL (karena ada operasi + 1 setelah g(x) kembali)
    -- function f(x)
    --    return g(x) + 1
    -- end

    -- INI BUKAN TAIL CALL (karena nilai g(x) disimpan dulu)
    -- function f(x)
    --    local hasil = g(x)
    --    return hasil
    -- end
    -- Namun, `return (g(x))` BISA menjadi tail call tergantung versi Lua dan konteksnya.
    -- Aturan umumnya adalah: `return g(...)` adalah tail call.
    ```

  - **Implikasi untuk Kontrol Alur**: Tail call memungkinkan implementasi loop menggunakan rekursi tanpa batas stack. Ini sering digunakan dalam pemrograman fungsional murni untuk menggantikan loop.
  - **Contoh Kode (Faktorial dengan rekursi ekor)**:

    ```lua
    -- Faktorial rekursif biasa (bukan tail call, bisa stack overflow untuk n besar)
    -- function faktorialBiasa(n)
    --    if n == 0 then return 1
    --    else return n * faktorialBiasa(n - 1) -- Operasi '*' setelah panggilan rekursif
    --    end
    -- end

    -- Faktorial dengan rekursi ekor
    local function faktorialTailRecursiveInternal(n, akumulator)
        if n == 0 then
            return akumulator
        else
            -- Panggilan ke faktorialTailRecursiveInternal adalah tindakan terakhir
            return faktorialTailRecursiveInternal(n - 1, n * akumulator)
        end
    end

    local function faktorial(n)
        return faktorialTailRecursiveInternal(n, 1)
    end

    print("Faktorial dari 5: " .. faktorial(5)) -- Output: Faktorial dari 5: 120
    -- print("Faktorial dari 20000: " .. faktorial(20000)) -- Ini akan berjalan tanpa stack overflow
                                                        -- (tapi mungkin lama dan menghasilkan angka sangat besar)
    ```

  - Sumber: [Programming in Lua: Proper Tail Calls](https://www.lua.org/pil/6.3.html)

#### **Penjelasan Mendalam Tambahan**

- **Kelebihan Gaya Fungsional**:
  - **Keterbacaan (Declarative)**: Seringkali lebih mudah untuk memahami _apa_ yang dilakukan kode, bukan _bagaimana_ detail implementasinya.
  - **Modularitas**: Fungsi kecil yang murni mudah diuji dan digabungkan.
  - **Paralelisasi**: Kode fungsional murni (tanpa efek samping) lebih mudah dijalankan secara paralel (meskipun ini di luar cakupan Lua standar).
  - **Mengurangi Bug**: Lebih sedikit state yang bisa berubah berarti lebih sedikit tempat di mana bug bisa bersembunyi.
- **Kekurangan**:
  - **Overhead**: Membuat banyak fungsi kecil atau tabel sementara bisa memiliki overhead performa dibandingkan kode imperatif yang dioptimalkan. Namun, untuk banyak kasus, ini tidak signifikan.
  - **Kurva Belajar**: Bagi yang terbiasa dengan gaya imperatif, berpikir secara fungsional mungkin memerlukan penyesuaian.
  - **Tidak Selalu Cocok**: Untuk beberapa masalah, pendekatan imperatif mungkin lebih alami atau efisien.

#### **Sumber Belajar (dari README.md)**:

- [Functional Programming in Lua](http://lua-users.org/wiki/FunctionalProgramming)
- [Programming in Lua: Proper Tail Calls](https://www.lua.org/pil/6.3.html)

---

### 4.3 Metatable-Based Control Flow

**Durasi yang Disarankan:** 5-6 jam

Metatabel adalah fitur Lua yang sangat kuat yang memungkinkan Anda mengubah perilaku standar operasi pada tabel (dan userdata). Dengan metatabel, Anda bisa membuat tabel "berperilaku" seperti fungsi, atau merespons operasi indeks dengan cara yang dinamis, yang dapat digunakan untuk kontrol alur yang canggih.

#### **Deskripsi Konkret**

Metatable-based control flow menggunakan _metamethod_ yang didefinisikan dalam metatabel sebuah tabel untuk mencegat dan menangani operasi tertentu pada tabel tersebut. Ini memungkinkan implementasi pola seperti tabel yang bisa dipanggil (callable tables), properti dinamis, dan bahkan overloading operator untuk tujuan kontrol alur.

#### **Terminologi dan Konsep Mendasar**

- **Metatable (Metatabel)**: Tabel Lua biasa yang berisi _metamethod_. Setiap tabel di Lua dapat memiliki satu metatabel.
- **Metamethod**: Fungsi khusus yang Anda definisikan dalam metatabel. Kunci dalam metatabel untuk metamethod memiliki nama yang sudah ditentukan (misalnya, `__index`, `__newindex`, `__call`, `__add`, dll.). Ketika Lua akan melakukan operasi tertentu pada tabel yang memiliki metatabel dengan metamethod yang sesuai, Lua akan memanggil metamethod tersebut sebagai gantinya.
- **`__index`**: Metamethod yang dipanggil ketika Lua mencoba mengakses kunci yang tidak ada (nil) dalam sebuah tabel. Ini bisa berupa fungsi atau tabel lain.
- **`__newindex`**: Metamethod yang dipanggil ketika Lua mencoba menetapkan nilai ke kunci yang tidak ada (nil) dalam sebuah tabel.
- **`__call`**: Metamethod yang membuat tabel bisa "dipanggil" seolah-olah itu adalah fungsi.
- **Operator Overloading**: Mendefinisikan ulang perilaku operator standar (seperti `+`, `-`, `*`, `/`, `..` (concatenation)) untuk tabel melalui metamethod (misalnya, `__add`, `__sub`, `__mul`, `__div`, `__concat`).

#### **Topik yang Dipelajari (Sesuai Kurikulum dan Penjelasan Tambahan)**

- **`__call` metamethod untuk callable tables (Metamethod `__call` untuk tabel yang dapat dipanggil)**:

  - **Deskripsi**: Jika metatabel sebuah tabel `t` memiliki field `__call`, maka tabel `t` dapat dipanggil seperti fungsi: `t(...)`. Panggilan ini akan mengeksekusi fungsi yang ada di `metatable(t).__call`. Argumen pertama yang diterima fungsi `__call` adalah tabel `t` itu sendiri, diikuti oleh argumen yang dilewatkan saat pemanggilan.
  - **Penggunaan untuk Kontrol Alur**: Membuat objek yang berperilaku seperti fungsi, yang bisa berguna untuk state machines di mana state itu sendiri adalah callable table, atau untuk membuat antarmuka yang lebih bersih.
  - **Contoh Kode**:

    ```lua
    local Penghitung = {}
    Penghitung.__index = Penghitung -- Untuk metode objek, akan dibahas lebih detail di OOP

    function Penghitung:new(nilaiAwal)
        nilaiAwal = nilaiAwal or 0
        local instance = { nilai = nilaiAwal }
        setmetatable(instance, self) -- 'self' di sini adalah tabel Penghitung
        return instance
    end

    function Penghitung:tambah(jumlah)
        self.nilai = self.nilai + jumlah
    end

    function Penghitung:getNilai()
        return self.nilai
    end

    -- Membuat __call untuk Penghitung
    local mtPenghitung = getmetatable(Penghitung.new()) -- Ambil metatable dari sebuah instance
    -- Atau jika kita tahu Penghitung adalah metatabelnya: local mtPenghitung = Penghitung

    -- Misalkan kita ingin 'objek penghitung' bisa dipanggil untuk mereset nilainya
    mtPenghitung.__call = function(objPenghitung, nilaiReset)
        print("Objek penghitung dipanggil! Mereset nilai.")
        objPenghitung.nilai = nilaiReset or 0
        return objPenghitung:getNilai()
    end

    local c1 = Penghitung:new(5)
    c1:tambah(2)
    print("Nilai c1:", c1:getNilai()) -- Output: Nilai c1: 7

    -- Sekarang panggil objek c1 seolah-olah fungsi
    local nilaiSetelahReset = c1(100) -- Ini akan memanggil mtPenghitung.__call(c1, 100)
    print("Nilai c1 setelah dipanggil (reset):", c1:getNilai()) -- Output: 100
    print("Nilai kembali dari panggilan:", nilaiSetelahReset)   -- Output: 100
    ```

- **`__index` dan `__newindex` untuk dynamic control flow (Kontrol alur dinamis dengan `__index` dan `__newindex`)**:

  - **`__index`**:
    - **Deskripsi**: Jika `rawget(t, key)` adalah `nil`, Lua akan memeriksa `metatable(t).__index`.
      - Jika `__index` adalah **fungsi**, Lua akan memanggilnya: `result = mt.__index(t, key)`.
      - Jika `__index` adalah **tabel**, Lua akan mencari `key` di tabel `__index` tersebut: `result = mt.__index[key]`. Ini berguna untuk pewarisan (inheritance) atau menyediakan nilai default.
    - **Kontrol Alur**:
      - **Lazy Loading**: Menghasilkan atau memuat data hanya ketika diminta.
      - **Properti Dinamis**: Membuat properti yang nilainya dihitung saat diakses.
      - **Delegasi**: Mendelegasikan pencarian kunci ke tabel lain (dasar dari pewarisan prototipe di Lua).
  - **`__newindex`**:
    - **Deskripsi**: Jika `rawget(t, key)` adalah `nil` dan Anda mencoba `t[key] = value`, Lua akan memeriksa `metatable(t).__newindex`.
      - Jika `__newindex` adalah **fungsi**, Lua akan memanggilnya: `mt.__newindex(t, key, value)`.
      - Jika `__newindex` adalah **tabel**, Lua akan menetapkan nilai ke `key` di tabel `__newindex` tersebut: `mt.__newindex[key] = value`.
    - **Kontrol Alur**:
      - **Validasi**: Memvalidasi nilai sebelum ditetapkan.
      - **Logging**: Mencatat perubahan pada tabel.
      - **Read-only Tables**: Mencegah penambahan kunci baru.
  - **Contoh Kode (`__index` untuk nilai default dan properti dinamis)**:

    ```lua
    local defaults = { x = 0, y = 0, lebar = 100, tinggi = 50 }
    local mt = {
        __index = function(tabel, kunci)
            if kunci == "area" then
                -- Properti dinamis: area dihitung saat diakses
                return tabel.lebar * tabel.tinggi
            elseif defaults[kunci] ~= nil then
                print("Mengambil nilai default untuk '" .. kunci .. "'")
                return defaults[kunci]
            else
                return nil -- Kunci tidak ada di tabel maupun di defaults
            end
        end,
        __newindex = function(tabel, kunci, nilai)
            if type(nilai) == "number" then
                print("Menetapkan '" .. kunci .. "' = " .. nilai)
                rawset(tabel, kunci, nilai) -- rawset untuk menghindari rekursi __newindex
            else
                print("Error: Hanya nilai numerik yang diizinkan untuk '" .. kunci .. "'")
            end
        end
    }

    local konfigurasi = {}
    setmetatable(konfigurasi, mt)

    konfigurasi.lebar = 20 -- Memanggil __newindex
    print("Lebar:", konfigurasi.lebar) -- Mengambil nilai dari tabel (tidak via __index)
    print("Tinggi:", konfigurasi.tinggi) -- Memanggil __index (mengambil dari defaults)
    print("Area:", konfigurasi.area)   -- Memanggil __index (menghitung properti dinamis)
    konfigurasi.nama = "tes" -- Memanggil __newindex, akan ditolak
    konfigurasi.x = "bukanAngka" -- Memanggil __newindex, akan ditolak
    print("X:", konfigurasi.x) -- Memanggil __index (mengambil dari defaults karena penetapan gagal)
    ```

  - Sumber: [Programming in Lua: Metatables](https://www.lua.org/pil/13.html)

- **Control flow menggunakan operator overloading (Kontrol alur menggunakan overloading operator)**:

  - **Deskripsi**: Anda dapat mendefinisikan metamethod seperti `__add`, `__sub`, `__concat`, `__len`, `__eq`, `__lt`, `__le` untuk mengubah cara operator bekerja pada tabel Anda. Ini bisa digunakan untuk kontrol alur jika operator tersebut secara logis mewakili transisi atau operasi dalam domain masalah Anda.
  - **Contoh**: Menggunakan `..` (concatenation, `__concat`) untuk menggabungkan "path" atau state.

    ```lua
    local Path = {}
    Path.__index = Path

    function Path:new(initialPath)
        return setmetatable({ current = initialPath or "" }, self)
    end

    -- Overload operator '..' (__concat)
    Path.__concat = function(pathObj1, pathObj2_or_string)
        local p1 = pathObj1.current
        local p2 = type(pathObj2_or_string) == "string" and pathObj2_or_string or pathObj2_or_string.current

        -- Logika sederhana untuk menggabungkan path
        if p1 == "" then return Path:new(p2) end
        if p2 == "" then return Path:new(p1) end
        return Path:new(p1 .. "/" .. p2)
    end

    Path.__tostring = function(pathObj) return pathObj.current end

    local basePath = Path:new("/usr/local")
    local subPath = Path:new("bin")
    local fullPath = basePath .. subPath -- Menggunakan __concat
    print("Full path:", fullPath) -- Output: Full path: /usr/local/bin

    local anotherPath = fullPath .. "myprogram" -- Menggabungkan dengan string
    print("Another path:", anotherPath) -- Output: Another path: /usr/local/bin/myprogram
    ```

    Dalam konteks kontrol alur, ini mungkin kurang umum dibandingkan `__call` atau `__index`, tetapi bisa berguna untuk DSL (Domain-Specific Languages) tertentu.

- **Custom iteration dengan `__pairs` dan `__ipairs` (Iterasi kustom)**:

  - **Klarifikasi Penting**: Standar Lua hingga versi 5.3 tidak memiliki metamethod bernama `__pairs` atau `__ipairs` yang secara otomatis digunakan oleh fungsi global `pairs()` atau `ipairs()`.
    - `pairs(t)` secara tradisional bekerja dengan fungsi `next(t, nil)` untuk iterasi pertama, dan `next(t, kunciSebelumnya)` untuk selanjutnya.
    - `ipairs(t)` memiliki logika internalnya sendiri untuk iterasi sekuensial numerik mulai dari 1.
  - **Lua 5.4 memperkenalkan `__iter` metamethod**: Jika metatable sebuah objek memiliki field `__iter`, maka `pairs(objek)` akan memanggil `mt.__iter(objek)` untuk mendapatkan fungsi iterator, state, dan nilai kontrol awal, mirip dengan cara generic `for` loop bekerja. Ini adalah cara modern untuk kustomisasi iterasi dengan `pairs`.
  - **Interpretasi Kurikulum**: Poin "Custom iteration dengan `__pairs` dan `__ipairs`" dalam kurikulum mungkin merujuk pada:
    1.  Pola di mana Anda _mendefinisikan fungsi bernama_ `__pairs` atau `__ipairs` pada tabel Anda (bukan sebagai metamethod standar) dan kemudian memanggilnya secara eksplisit: `for k,v in mytable:__pairs() do ... end`.
    2.  Penggunaan `__index` untuk menyimulasikan perilaku iterator jika tabel itu sendiri adalah iterator stateful.
    3.  Penggunaan `__call` jika tabel itu sendiri adalah pabrik iterator yang bisa dipanggil.
    4.  Jika merujuk ke fitur yang lebih baru, ini akan selaras dengan `__iter` di Lua 5.4.
  - **Contoh (Menyimulasikan `__iter` atau iterator pabrik dengan `__call` untuk versi < 5.4)**:

    ```lua
    -- Pola 1: Fungsi biasa pada tabel (bukan metamethod standar)
    local MyIterableTable = {}
    MyIterableTable.data = {a=1, b=2, c=3}
    function MyIterableTable:myCustomPairs()
        -- Ini hanyalah contoh, implementasi sebenarnya akan lebih kompleks
        -- untuk mengembalikan iterator, state, dan var kontrol awal
        local keys = {}
        for k in pairs(self.data) do table.insert(keys, k) end
        table.sort(keys) -- Iterasi terurut berdasarkan kunci

        local i = 0
        local n = #keys
        return function() -- Fungsi iterator
            i = i + 1
            if i <= n then
                local k = keys[i]
                return k, self.data[k]
            end
        end
    end

    local myObj = { data = {val1=10, val2=20, val3=30} }
    setmetatable(myObj, { __index = MyIterableTable }) -- Agar bisa panggil myObj:myCustomPairs()

    print("\nIterasi dengan fungsi kustom pada tabel:")
    for k, v in myObj:myCustomPairs() do
        print(k, v)
    end

    -- Contoh dengan __iter (Lua 5.4+)
    -- local mtWithIter = {
    --     __iter = function(tabel_obj)
    --         -- Mengembalikan: iterator_func, state_obj, initial_control_var
    --         local data = tabel_obj.internal_data
    --         local keys = {}
    --         for k in pairs(data) do table.insert(keys, k) end
    --         table.sort(keys) -- Iterasi terurut
    --         local index = 0
    --         return function(tbl_state, var_kontrol)
    --             index = index + 1
    --             if keys[index] then
    --                 return keys[index], data[keys[index]]
    --             end
    --         end, tabel_obj, nil
    --     end
    -- }
    -- local objForPairs = { internal_data = {z=1, y=2, x=3} }
    -- setmetatable(objForPairs, mtWithIter)
    -- print("\nIterasi dengan __iter (Lua 5.4+):")
    -- for k, v in pairs(objForPairs) do
    --    print(k,v) -- Akan mencetak x=3, y=2, z=1 (terurut)
    -- end
    ```

  - **Sumber**: Referensi Lua 5.4 untuk `__iter`. [Metatables and Metamethods in Lua Programming Language](https://piembsystech.com/metatables-and-metamethods-in-lua-programming-language/) mungkin membahas konsep umum metamethod.

- **Metamethod-based state machines (Mesin keadaan berbasis metamethod)**:

  - **Deskripsi**: Anda dapat menggunakan `__index` atau `__call` untuk membuat implementasi state machine yang lebih dinamis.
    - Dengan `__call`: Setiap state bisa menjadi tabel yang bisa dipanggil. Memanggil state akan memicu transisi atau aksi.
    - Dengan `__index`: Mencoba mengakses "event" sebagai kunci pada tabel state saat ini dapat memicu fungsi yang terkait dengan event tersebut melalui `__index`.
  - **Contoh (`__call` untuk state)**:

    ```lua
    local function createState(nama, aksiDanTransisi)
        local state = {}
        state.nama = nama
        state.aksiDanTransisi = aksiDanTransisi or {}

        local mt = {
            __call = function(currentStateObj, event, context) -- 'context' adalah state machine utama
                print("State '" .. currentStateObj.nama .. "' menerima event '" .. event .. "'")
                local handler = currentStateObj.aksiDanTransisi[event]
                if type(handler) == "function" then
                    handler(context) -- Panggil handler dengan konteks state machine
                elseif type(handler) == "string" then -- Transisi ke state baru
                    print("Transisi dari '" .. currentStateObj.nama .. "' ke '" .. handler .. "'")
                    context.currentStateName = handler
                else
                    print("Tidak ada handler atau transisi untuk event '" .. event .. "' di state '" .. currentStateObj.nama .. "'")
                end
            end
        }
        return setmetatable(state, mt)
    end

    local sm = {
        states = {},
        currentStateName = nil
    }

    function sm:addState(stateObj)
        self.states[stateObj.nama] = stateObj
        if not self.currentStateName then
            self.currentStateName = stateObj.nama -- State pertama menjadi state awal
        end
    end

    function sm:trigger(event)
        local currentStateObj = self.states[self.currentStateName]
        if currentStateObj then
            currentStateObj(event, self) -- Memanggil state (menggunakan __call)
            print("Status SM sekarang: " .. self.currentStateName)
        else
            print("Error: State saat ini '" .. self.currentStateName .. "' tidak ditemukan.")
        end
        print("---")
    end

    -- Definisi state
    sm:addState(createState("idle", {
        mulai = "berjalan",
        info = function(ctx) print("Mesin sedang idle.") end
    }))
    sm:addState(createState("berjalan", {
        berhenti = "idle",
        jeda = "terjeda"
    }))
    sm:addState(createState("terjeda", {
        lanjut = "berjalan",
        stop_total = "idle"
    }))

    sm:trigger("info")
    sm:trigger("mulai")
    sm:trigger("jeda")
    sm:trigger("lanjut")
    sm:trigger("berhenti")
    sm:trigger("tidakAdaEvent")
    ```

- **Proxy patterns untuk control flow (Pola Proksi untuk kontrol alur)**:

  - **Deskripsi**: Sebuah tabel proksi menggunakan metatabel (terutama `__index` dan `__newindex`) untuk mencegat akses ke tabel "subjek" (tabel asli). Proksi dapat menambahkan logika sebelum atau sesudah mendelegasikan operasi ke subjek. Ini dapat digunakan untuk logging, kontrol akses, validasi, atau modifikasi alur berdasarkan kondisi tertentu sebelum operasi sebenarnya dilakukan.
  - **Contoh Kode (Proksi untuk Logging Akses)**:

    ```lua
    local function createLoggingProxy(targetTable, tableName)
        local proxy = {}
        local mt = {
            __index = function(p, key)
                print("LOG (" .. tableName .. "): Membaca kunci '" .. tostring(key) .. "'")
                local value = targetTable[key] -- Akses tabel target asli
                if type(value) == "function" then
                    -- Jika itu fungsi, kembalikan fungsi wrapper untuk log panggilan juga
                    return function(...)
                        print("LOG (" .. tableName .. "): Memanggil fungsi '" .. tostring(key) .. "'")
                        return value(...) -- Panggil fungsi asli dari target
                    end
                end
                return value
            end,
            __newindex = function(p, key, value)
                print("LOG (" .. tableName .. "): Menulis kunci '" .. tostring(key) .. "' dengan nilai '" .. tostring(value) .. "'")
                targetTable[key] = value -- Tulis ke tabel target asli
            end
        }
        setmetatable(proxy, mt)
        return proxy
    end

    local dataAsli = { nama = "Contoh Data", counter = 0, tambahCounter = function(self) self.counter = self.counter + 1 end }
    local dataProxy = createLoggingProxy(dataAsli, "DataPengguna")

    dataProxy.nama = "Data Baru" -- via __newindex
    print("Nama dari proxy:", dataProxy.nama) -- via __index
    dataProxy:tambahCounter() -- via __index (untuk mendapatkan fungsi) dan wrapper
    print("Counter dari proxy:", dataProxy.counter) -- via __index
    ```

#### **Penjelasan Mendalam Tambahan**

- **Kekuatan dan Kompleksitas**: Metatabel sangat kuat tetapi juga dapat membuat kode lebih sulit dipahami jika digunakan secara berlebihan atau untuk hal-hal yang tidak jelas. Gunakan dengan bijak.
- **Hierarki Metatabel**: `__index` bisa berupa tabel lain yang juga memiliki metatabel, memungkinkan pencarian berantai (sering digunakan untuk implementasi pewarisan dalam OOP).
- **Fungsi `rawget(t, k)` dan `rawset(t, k, v)`**: Fungsi-fungsi ini memungkinkan Anda mengakses tabel tanpa memicu metamethod `__index` atau `__newindex`. Ini penting di dalam implementasi metamethod itu sendiri untuk menghindari rekursi tak terbatas.
- **Fungsi `getmetatable(t)` dan `setmetatable(t, mt)`**: Digunakan untuk mendapatkan dan mengatur metatabel sebuah tabel. `setmetatable` mengembalikan tabel pertama `t`, sehingga bisa digunakan dalam ekspresi.

#### **Sumber Belajar (dari README.md)**:

- [Metatables and Metamethods in Lua Programming Language](https://piembsystech.com/metatables-and-metamethods-in-lua-programming-language/)
- [Programming in Lua: Metatables](https://www.lua.org/pil/13.html)
- [Metatables and Metamethods in Lua](https://coderscratchpad.com/metatables-and-metamethods-in-lua/)
- [Lua Metatables Tutorial](https://www.tutorialspoint.com/lua/lua_metatables.htm)

---

Ini adalah pembahasan yang cukup mendalam untuk Bagian 4. Anda sekarang memiliki gambaran tentang bagaimana tabel, fungsi orde tinggi, dan metatabel dapat digunakan untuk menciptakan pola kontrol alur yang sangat canggih dan fleksibel di Lua.
