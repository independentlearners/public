# 📚 **Bagian 2: Loop Structures**

Struktur perulangan (loop) memungkinkan Anda untuk menjalankan blok kode yang sama berulang kali, baik untuk jumlah iterasi tertentu maupun selama kondisi tertentu terpenuhi. Ini sangat penting untuk mengotomatisasi tugas-tugas yang repetitif.

---

### 2.1 While dan Repeat-Until Loops

**Durasi yang Disarankan:** 3-4 jam

Loop `while` dan `repeat...until` adalah loop yang dikontrol oleh kondisi. Perbedaan utama terletak pada kapan kondisi tersebut dievaluasi.

#### **Deskripsi Konkret**

- **`while` loop**: Mengevaluasi kondisi _sebelum_ setiap iterasi. Jika kondisi benar (truthy), blok kode di dalam loop dieksekusi. Jika kondisi salah (falsy) dari awal, blok kode tidak akan pernah dieksekusi.
- **`repeat...until` loop**: Mengeksekusi blok kode _terlebih dahulu_, kemudian mengevaluasi kondisi di akhir iterasi. Blok kode akan selalu dieksekusi setidaknya satu kali. Loop akan terus berlanjut selama kondisi _salah_ (falsy), dan berhenti ketika kondisi menjadi benar (truthy).

#### **Terminologi dan Konsep Mendasar**

- **Iterasi (Iteration)**: Satu kali eksekusi blok kode di dalam loop.
- **Kondisi Loop (Loop Condition)**: Ekspresi yang menentukan apakah loop akan melanjutkan iterasi berikutnya atau berhenti.
- **Infinite Loop (Loop Tak Terhingga)**: Loop yang kondisinya tidak pernah terpenuhi untuk menghentikannya, sehingga berjalan terus menerus. Ini biasanya merupakan bug, kecuali dirancang secara sengaja dengan mekanisme keluar lain (misalnya `break`).

#### **Topik yang Dipelajari (Sesuai Kurikulum dan Penjelasan Tambahan)**

- **Syntax dan semantik `while` loop**:

  - **Sintaks**:
    ```lua
    while <kondisi> do
        -- blok kode yang akan diulang
    end
    ```
  - **Semantik (Cara Kerja)**:
    1.  Kondisi dievaluasi.
    2.  Jika kondisi `true` (atau nilai truthy lainnya):
        a. Blok kode di dalam `do...end` dieksekusi.
        b. Kembali ke langkah 1.
    3.  Jika kondisi `false` atau `nil`:
        a. Loop berakhir, dan eksekusi program berlanjut ke pernyataan setelah `end`.
  - **Contoh Kode**:

    ```lua
    local hitunganMundur = 3
    while hitunganMundur > 0 do
        print(hitunganMundur)
        hitunganMundur = hitunganMundur - 1 -- Penting: ubah variabel kondisi di dalam loop!
    end
    print("Mulai!")
    -- Output:
    -- 3
    -- 2
    -- 1
    -- Mulai!

    local inputPengguna = ""
    -- Loop akan terus berjalan selama inputPengguna bukan "keluar"
    -- Perhatikan bagaimana ini mirip dengan loop "do-while" di bahasa lain karena kita
    -- mungkin perlu mendapatkan input setidaknya sekali, tetapi `while` tetap memeriksa kondisi di awal.
    -- Untuk perilaku "jalankan setidaknya sekali", `repeat...until` lebih cocok.

    -- Contoh: Loop yang tidak pernah dijalankan
    local kondisiAwalSalah = false
    while kondisiAwalSalah do
        print("Ini tidak akan pernah tercetak")
    end
    ```

- **`repeat...until` loop dan perbedaannya dengan `while`**:

  - **Sintaks**:
    ```lua
    repeat
        -- blok kode yang akan diulang
    until <kondisi>
    ```
  - **Semantik (Cara Kerja)**:
    1.  Blok kode di dalam `repeat...until` dieksekusi (setidaknya satu kali).
    2.  Kondisi dievaluasi.
    3.  Jika kondisi `false` atau `nil`:
        a. Kembali ke langkah 1 (blok kode dieksekusi lagi).
    4.  Jika kondisi `true` (atau nilai truthy lainnya):
        a. Loop berakhir, dan eksekusi program berlanjut ke pernyataan setelah `until <kondisi>`.
  - **Perbedaan Utama dengan `while`**:
    1.  **Kapan Kondisi Diperiksa**: `while` memeriksa kondisi _sebelum_ iterasi; `repeat...until` memeriksa _setelah_ iterasi.
    2.  **Eksekusi Minimal**: Blok kode `repeat...until` selalu dieksekusi minimal satu kali; blok kode `while` mungkin tidak dieksekusi sama sekali.
    3.  **Logika Kondisi**: `while` loop berlanjut selama kondisi `true`; `repeat...until` loop berlanjut selama kondisi `false` (dan berhenti ketika `true`). Ini adalah poin penting yang sering terlewat.
  - **Contoh Kode**:

    ```lua
    local angka = 1
    repeat
        print("Angka: " .. angka)
        angka = angka + 1
    until angka > 3
    -- Output:
    -- Angka: 1
    -- Angka: 2
    -- Angka: 3

    -- Contoh untuk input pengguna, memastikan input diterima setidaknya sekali
    local passwordBenar = "rahasia123"
    local cobaPassword
    local jumlahPercobaan = 0
    repeat
        io.write("Masukkan password: ")
        cobaPassword = io.read() -- Fungsi io.read() digunakan untuk mendapatkan input dari pengguna
        jumlahPercobaan = jumlahPercobaan + 1
        if cobaPassword ~= passwordBenar then
            print("Password salah. Coba lagi.")
        end
    until cobaPassword == passwordBenar or jumlahPercobaan >= 3

    if cobaPassword == passwordBenar then
        print("Akses diberikan!")
    else
        print("Terlalu banyak percobaan gagal. Akses ditolak.")
    end
    ```

    Dalam contoh `repeat...until` di atas, pengguna akan diminta memasukkan password setidaknya satu kali. Loop akan berhenti jika password benar ATAU jika jumlah percobaan sudah mencapai 3 kali.

- **Loop guards dan infinite loop prevention (Penjaga Loop dan Pencegahan Loop Tak Terhingga)**:

  - **Deskripsi**: "Loop guard" adalah bagian dari kondisi loop atau logika di dalam loop yang memastikan loop tersebut pada akhirnya akan berhenti. Mencegah loop tak terhingga adalah krusial.
  - **Penyebab Umum Infinite Loop**:
    - Variabel kondisi tidak pernah diubah di dalam loop `while` atau `repeat...until` sehingga kondisi selalu `true` (untuk `while`) atau selalu `false` (untuk `repeat...until`).
    - Logika kondisi yang salah.
  - **Teknik Pencegahan**:
    1.  **Pastikan Variabel Kondisi Dimodifikasi**: Dalam `while` dan `repeat...until`, selalu pastikan bahwa ada sesuatu di dalam loop yang pada akhirnya akan membuat kondisi berhenti terpenuhi.
    2.  **Counter/Batas Maksimum**: Tambahkan variabel hitungan (counter) yang meningkat setiap iterasi, dan masukkan ke dalam kondisi loop untuk berhenti setelah sejumlah iterasi tertentu. Ini berguna sebagai pengaman.
        ```lua
        local hitungan = 0
        local maksIterasi = 1000
        while beberapaKondisiYangKompleks and hitungan < maksIterasi do
            -- lakukan sesuatu
            hitungan = hitungan + 1
        end
        if hitungan >= maksIterasi then
            print("Peringatan: Loop mencapai batas iterasi maksimum!")
        end
        ```
    3.  **Statement `break`**: (Akan dibahas lebih detail di Bagian 3) Anda dapat menggunakan `break` untuk keluar dari loop secara paksa dari dalam blok kode, bahkan jika kondisi utama loop masih terpenuhi. Ini berguna untuk kondisi keluar yang tidak mudah diekspresikan dalam kondisi loop utama.
  - **Contoh (Potensi Infinite Loop dan Perbaikannya)**:

    ```lua
    -- POTENSI INFINITE LOOP (JANGAN DIJALANKAN SEPERTI INI TANPA MODIFIKASI)
    -- local x = 1
    -- while x > 0 do
    --     print("x masih positif")
    --     -- Lupa mengubah nilai x, jadi x akan selalu 1, loop tak terhingga!
    -- end

    -- PERBAIKAN
    local x = 3
    while x > 0 do
        print("x masih positif: " .. x)
        x = x - 1 -- x diubah, sehingga loop akan berhenti
    end
    ```

- **Performance optimization untuk loops (Optimasi Performa untuk Loop)**:

  - **Deskripsi**: Meskipun optimasi mikro seringkali tidak diperlukan kecuali dalam kode yang sangat kritis, ada beberapa pertimbangan umum.
  - **Tips Awal**:

    1.  **Minimalkan Pekerjaan di Dalam Loop**: Jika ada perhitungan atau pemanggilan fungsi yang hasilnya tidak berubah antar iterasi, lakukan di luar loop.

        ```lua
        -- Kurang optimal
        -- local batas = dapatkanBatas() -- fungsi mahal
        -- local i = 0
        -- while i < 100 do
        --   local nilai = i * batas -- batas dihitung/diambil ulang terus menerus jika `dapatkanBatas()` dipanggil di sini
        --   -- ...
        --   i = i + 1
        -- end

        -- Lebih baik
        local batas = dapatkanBatas()
        local i = 0
        while i < 100 do
            local nilai = i * batas -- `batas` sudah di-cache
            -- ...
            i = i + 1
        end
        ```

    2.  **Pembuatan Tabel**: Hindari membuat tabel baru di setiap iterasi jika memungkinkan. Buat sekali di luar dan gunakan ulang atau isi di dalam loop.
    3.  **Untuk LuaJIT**: Kompiler Just-In-Time LuaJIT sangat baik dalam mengoptimalkan loop. Kode yang sederhana dan jelas seringkali menghasilkan performa terbaik. (Akan dibahas lebih lanjut di Bagian 7 dan 11).

  - **Penting**: Profiling (mengukur di mana program Anda menghabiskan waktu paling banyak) adalah kunci sebelum melakukan optimasi. Jangan mengoptimalkan secara prematur.

#### **Penjelasan Mendalam Tambahan**

- **Kapan Memilih `while` vs `repeat...until`**:
  - Gunakan `while` jika Anda ingin kondisi diperiksa _sebelum_ eksekusi pertama (blok kode mungkin tidak pernah berjalan).
  - Gunakan `repeat...until` jika Anda ingin blok kode dieksekusi _setidaknya sekali_ sebelum kondisi diperiksa. Ini umum untuk hal seperti validasi input pengguna.
- **Variabel Lokal dalam Loop**: Variabel yang dideklarasikan sebagai `local` di dalam blok `repeat...until` memiliki cakupan (scope) yang mencakup kondisi `until`. Ini berbeda dengan `while`, di mana variabel lokal di dalam `while...do...end` tidak terlihat oleh kondisi `while` itu sendiri jika dideklarasikan hanya di dalam blok.

  ```lua
  -- Untuk repeat...until
  local y
  repeat
      local x = math.random(10) -- x lokal untuk blok repeat
      print("x dalam repeat: " .. x)
      y = x -- y bisa diakses di kondisi until
  until y == 5
  print("Selesai dengan y = " .. y)

  -- Untuk while
  -- local kondisi = true
  -- while kondisi do
  --   local z = math.random(10) -- z lokal untuk blok while
  --   print("z dalam while: " .. z)
  --   if z == 5 then
  --     kondisi = false -- Harus mengubah variabel yang ada di luar scope lokal z
  --   end
  -- end
  -- -- print(z) -- Akan error karena z tidak terdefinisi di sini
  ```

#### **Sumber Belajar (dari README.md)**:

- [Control flow — Lua — Den's Website](https://dens.website/tutorials/lua/control-flow)
- [Programming in Lua: Control Structures](https://www.lua.org/pil/4.3.html)

---

### 2.2 For Loops (Numeric dan Generic)

**Durasi yang Disarankan:** 4-5 jam

Loop `for` di Lua hadir dalam dua bentuk utama: _numeric for_ dan _generic for_. Keduanya digunakan untuk iterasi, tetapi cara kerjanya berbeda.

#### **Deskripsi Konkret**

- **Numeric `for` loop**: Mengulang blok kode sejumlah kali tertentu, dengan variabel kontrol yang nilainya bertambah (atau berkurang) secara otomatis pada setiap iterasi.
- **Generic `for` loop**: Mengulang blok kode untuk setiap elemen dalam koleksi (seperti tabel), menggunakan fungsi _iterator_.

#### **Terminologi dan Konsep Mendasar**

- **Variabel Kontrol (Control Variable)**: Dalam numeric `for`, variabel yang nilainya berubah dari nilai awal hingga nilai akhir. Variabel ini bersifat lokal untuk loop.
- **Step (Langkah)**: Dalam numeric `for`, jumlah penambahan (atau pengurangan) variabel kontrol pada setiap iterasi. Defaultnya adalah 1.
- **Iterator Function (Fungsi Iterator)**: Fungsi khusus yang dipanggil oleh generic `for` loop pada setiap iterasi untuk mendapatkan elemen berikutnya dari koleksi.
- **State (Keadaan)**: Informasi yang disimpan oleh iterator di antara pemanggilan untuk melacak elemen mana yang sudah diproses dan mana yang berikutnya.
- **Invariant (Invarian Loop)**: Variabel kontrol dalam generic `for` yang nilainya adalah hasil dari pemanggilan fungsi iterator.

#### **Topik yang Dipelajari (Sesuai Kurikulum dan Penjelasan Tambahan)**

- **Numeric for loops (`for i = 1, 10 do`)**:

  - **Sintaks**:
    ```lua
    for var = <ekspresi_awal>, <ekspresi_batas> [, <ekspresi_langkah>] do
        -- blok kode
    end
    ```
    - `var`: Nama variabel kontrol (misalnya `i`, `j`, `k`). Variabel ini bersifat lokal untuk loop `for` dan tidak dapat diubah nilainya di dalam loop (meskipun Anda bisa membuat variabel lokal baru dengan nama yang sama di dalamnya, itu praktik yang buruk).
    - `ekspresi_awal`: Nilai awal variabel kontrol. Dievaluasi sekali sebelum loop dimulai.
    - `ekspresi_batas`: Nilai batas variabel kontrol. Loop berlanjut selama `var <= ekspresi_batas` (jika langkah positif) atau `var >= ekspresi_batas` (jika langkah negatif). Dievaluasi sekali sebelum loop dimulai.
    - `ekspresi_langkah` (opsional): Nilai penambahan (atau pengurangan jika negatif) untuk `var` setiap iterasi. Jika dihilangkan, defaultnya adalah `1`. Dievaluasi sekali sebelum loop dimulai.
  - **Semantik (Cara Kerja)**:
    1.  Semua tiga ekspresi (awal, batas, langkah) dievaluasi sekali sebelum loop dimulai.
    2.  Variabel kontrol diinisialisasi dengan `ekspresi_awal`.
    3.  Loop berlanjut selama kondisi batas terpenuhi.
    4.  Setelah setiap eksekusi blok kode, variabel kontrol diperbarui dengan menambahkan `ekspresi_langkah`.
  - **Contoh Kode**:

    ```lua
    -- Loop dari 1 sampai 5 (langkah default 1)
    print("Loop Naik:")
    for i = 1, 5 do
        print(i)
    end
    -- Output: 1, 2, 3, 4, 5

    -- Loop dari 10 sampai 1 dengan langkah -2
    print("\nLoop Turun dengan Langkah:")
    for i = 10, 1, -2 do
        print(i)
    end
    -- Output: 10, 8, 6, 4, 2

    -- Jika batas lebih kecil dari awal dan langkah positif (atau default), loop tidak berjalan
    print("\nLoop Tidak Berjalan:")
    for i = 5, 1 do
        print("Ini tidak akan tercetak: " .. i)
    end

    -- Variabel kontrol 'i' bersifat lokal
    local i = 100
    for i = 1, 3 do
        print("i di dalam loop: " .. i) -- Akan mencetak 1, 2, 3
    end
    print("i di luar loop: " .. i) -- Akan mencetak 100 (variabel i luar tidak terpengaruh)
    ```

  - **Penting**: Ekspresi batas dan langkah hanya dievaluasi _sekali_ sebelum loop dimulai. Mengubah variabel yang digunakan untuk menghitung batas atau langkah di dalam loop tidak akan mempengaruhi jumlah iterasi.

- **Generic for loops (`for k, v in pairs() do`)**:

  - **Sintaks**:
    ```lua
    for <var_1>, <var_2>, ..., <var_n> in <fungsi_iterator>, <state>, <var_kontrol_awal> do
        -- blok kode
    end
    ```
    Bentuk yang lebih umum dan sering digunakan adalah:
    ```lua
    for <kunci>, <nilai> in <iterator_expression> do
        -- blok kode
    end
    ```
    Contoh paling umum: `for k, v in pairs(tabel) do ... end` atau `for i, v in ipairs(tabel) do ... end`.
  - **Semantik (Cara Kerja)**:
    1.  Ekspresi iterator (misalnya `pairs(tabel)`) dipanggil. Ini mengembalikan tiga nilai: fungsi iterator sebenarnya, sebuah nilai _state_ (seringkali tabel itu sendiri), dan nilai awal untuk variabel kontrol iterator (seringkali `nil`).
    2.  Pada setiap iterasi:
        a. Fungsi iterator dipanggil dengan _state_ dan variabel kontrol iterator saat ini sebagai argumen.
        b. Fungsi iterator mengembalikan nilai-nilai baru untuk variabel-variabel loop (misalnya `kunci`, `nilai`).
        c. Jika nilai pertama yang dikembalikan oleh iterator adalah `nil`, loop berhenti.
        d. Jika tidak, variabel-variabel loop diisi dengan nilai yang dikembalikan, blok kode dieksekusi, dan nilai pertama yang dikembalikan oleh iterator digunakan sebagai input variabel kontrol untuk iterasi berikutnya.
  - **Contoh Kode**:

    ```lua
    local hariDalamMinggu = {"Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"}

    -- Menggunakan ipairs (untuk array/sequence)
    print("\nMenggunakan ipairs:")
    for indeks, namaHari in ipairs(hariDalamMinggu) do
        print(indeks .. ": " .. namaHari)
    end
    -- Output (indeks numerik berurutan dimulai dari 1):
    -- 1: Senin
    -- 2: Selasa
    -- ...
    -- 7: Minggu

    local dataPengguna = {
        nama = "Budi",
        usia = 30,
        kota = "Jakarta",
        [1] = "ElemenArray1" -- Contoh ada bagian array juga
    }

    -- Menggunakan pairs (untuk semua elemen dalam tabel, termasuk bagian array dan hash)
    print("\nMenggunakan pairs:")
    for kunci, nilai in pairs(dataPengguna) do
        print(tostring(kunci) .. " = " .. tostring(nilai))
    end
    -- Output (urutan tidak dijamin untuk bagian hash):
    -- nama = Budi
    -- usia = 30
    -- kota = Jakarta
    -- 1 = ElemenArray1
    -- (Urutan output bisa berbeda-beda)
    ```

- **Iterator functions dan custom iterators (Fungsi Iterator dan Iterator Kustom)**:

  - **Deskripsi**: Generic `for` sangat kuat karena Anda bisa membuat fungsi iterator sendiri untuk melintasi struktur data apa pun, atau bahkan menghasilkan nilai secara dinamis.
  - **Struktur Fungsi Iterator**: Sebuah fungsi iterator biasanya adalah _closure_ (fungsi yang "mengingat" variabel dari lingkup luarnya) yang mengelola keadaan internal. Pada setiap pemanggilan, ia mengembalikan elemen berikutnya, atau `nil` jika sudah selesai.
  - **Fungsi Pabrik Iterator (Iterator Factory)**: Seringkali, Anda membuat fungsi yang, ketika dipanggil, mengembalikan fungsi iterator, state, dan nilai kontrol awal. `pairs` dan `ipairs` adalah contoh fungsi pabrik iterator.
  - **Contoh Membuat Iterator Kustom (Sederhana)**: Iterator yang menghasilkan angka kuadrat hingga batas tertentu.

    ```lua
    local function kuadratIteratorFactory(batas)
        local n = 0 -- variabel state (upvalue untuk iterator)
        local function iteratorInternal()
            n = n + 1
            local nilaiKuadrat = n * n
            if nilaiKuadrat <= batas then
                return n, nilaiKuadrat -- mengembalikan dua variabel untuk loop for
            else
                return nil -- menandakan akhir iterasi
            end
        end
        return iteratorInternal -- hanya fungsi iterator yang dikembalikan, state (n) dan var kontrol awal (implisit)
                                 -- Lua akan menangani state dan var kontrol awal jika hanya satu fungsi yang dikembalikan
                                 -- atau Anda bisa secara eksplisit: return iteratorInternal, batas, 0
    end

    print("\nIterator Kustom (Kuadrat):")
    for angka, kuadratnya in kuadratIteratorFactory(50) do
        print("Angka: " .. angka .. ", Kuadrat: " .. kuadratnya)
    end
    -- Output:
    -- Angka: 1, Kuadrat: 1
    -- Angka: 2, Kuadrat: 4
    -- Angka: 3, Kuadrat: 9
    -- Angka: 4, Kuadrat: 16
    -- Angka: 5, Kuadrat: 25
    -- Angka: 6, Kuadrat: 36
    -- Angka: 7, Kuadrat: 49

    -- Contoh iterator yang mengembalikan tiga nilai yang diharapkan oleh generic for: iterator, state, control_variable
    local function lineIteratorFactory(str)
        local currentIndex = 1 -- state
        local function getNextLine(s, i) -- s adalah state (str), i adalah control_variable (currentIndex)
            local nextNewline = string.find(s, "\n", i)
            if nextNewline then
                return string.sub(s, i, nextNewline - 1), nextNewline + 1
            elseif i <= #s then -- Handle baris terakhir tanpa newline
                return string.sub(s, i), #s + 1
            else
                return nil -- Akhir iterasi
            end
        end
        -- Mengembalikan: fungsi iterator, state awal, variabel kontrol awal
        return getNextLine, str, currentIndex
    end

    print("\nIterator Baris Kustom:")
    local teksMultiBaris = "Baris pertama\nBaris kedua\nBaris ketiga"
    for baris, nextIndex in lineIteratorFactory(teksMultiBaris) do
        print("Ditemukan baris: '" .. baris .. "' (indeks berikutnya: " .. (nextIndex or "selesai") .. ")")
    end
    ```

- **`ipairs()` vs `pairs()` - kapan menggunakan masing-masing**:

  - **`ipairs(t)`**:
    - **I**terates over **p**airs (index, value) in the **a**rray part of a table `t`.
    - Artinya, ia hanya akan mengunjungi kunci numerik berurutan mulai dari `1` (`t[1]`, `t[2]`, `t[3]`, ...) sampai menemukan kunci numerik pertama yang `nil`.
    - Urutan iterasi dijamin (`1, 2, 3, ...`).
    - Gunakan `ipairs` ketika Anda ingin memproses tabel sebagai sebuah _sequence_ atau _array_ dan urutan penting.
    - Contoh: `local arr = {[1]="a", [2]="b", [4]="d"}`. `ipairs(arr)` hanya akan menghasilkan `1, "a"` dan `2, "b"`. `arr[3]` adalah `nil`, jadi iterasi berhenti. `arr[4]` tidak akan dikunjungi.
  - **`pairs(t)`**:
    - Iterates over all key-value pairs in a table `t`, termasuk bagian array dan bagian _hash_ (kunci non-numerik atau numerik yang tidak berurutan).
    - Urutan iterasi untuk elemen-elemen di bagian hash **tidak dijamin** dan bisa berbeda antar eksekusi atau versi Lua. Urutan untuk bagian array yang dikunjungi oleh `pairs` juga tidak dijamin berurutan numerik (meskipun seringkali demikian dalam implementasi praktis untuk bagian array yang padat).
    - Gunakan `pairs` ketika Anda ingin mengakses semua elemen dalam tabel dan urutan tidak krusial, atau ketika Anda bekerja dengan tabel yang lebih mirip _dictionary_ atau _set_.
  - **Contoh Perbandingan**:

    ```lua
    local myTable = {}
    myTable[1] = "apel"
    myTable[2] = "jeruk"
    myTable.warna = "merah"
    myTable[4] = "mangga" -- ada lubang di indeks 3

    print("\nMenggunakan ipairs pada myTable:")
    for i, v in ipairs(myTable) do
        print(i, v)
    end
    -- Output (hanya sampai indeks 2 karena myTable[3] adalah nil):
    -- 1 apel
    -- 2 jeruk

    print("\nMenggunakan pairs pada myTable:")
    for k, v in pairs(myTable) do
        print(tostring(k), v)
    end
    -- Output (urutan tidak dijamin untuk 'warna', bisa muncul di mana saja):
    -- 1 apel
    -- 2 jeruk
    -- warna merah
    -- 4 mangga
    ```

- **Stateless vs stateful iterators (Iterator Tanpa Keadaan vs Dengan Keadaan)**:
  - **Stateless Iterator**:
    - Fungsi iterator itu sendiri tidak menyimpan _state_ di antara pemanggilan.
    - Semua informasi yang dibutuhkan untuk mendapatkan elemen berikutnya diteruskan sebagai argumen (yaitu, _state_ eksternal dan variabel kontrol iterator saat ini).
    - `pairs` dan `ipairs` (dan fungsi `next` yang mereka gunakan secara internal) adalah contoh iterator tanpa keadaan. Fungsi `next` mengambil tabel (state) dan kunci sebelumnya (variabel kontrol) untuk menemukan kunci berikutnya.
  - **Stateful Iterator**:
    - Fungsi iterator (biasanya sebuah _closure_) menyimpan _state_ internalnya sendiri dalam _upvalues_ (variabel lokal dari fungsi pembungkusnya).
    - Fungsi iterator hanya memerlukan sedikit atau tanpa argumen untuk menghasilkan nilai berikutnya karena ia sudah tahu di mana ia terakhir berhenti.
    - Contoh `kuadratIteratorFactory` yang kita buat di atas menghasilkan _stateful iterator_ (`iteratorInternal` adalah closure yang menggunakan `n` sebagai upvalue).
  - **Struktur Generic For dan Tipe Iterator**:
    Generic `for` loop didesain untuk bekerja dengan iterator stateless dengan sintaks `for vars in iter, state, initial_control_var do`.
    Namun, jika `iter` (elemen pertama yang dikembalikan oleh ekspresi iterator) adalah sebuah fungsi, dan dua nilai lainnya (`state` dan `initial_control_var`) tidak disediakan (atau `nil`), Lua akan memanggil fungsi `iter` itu sendiri sebagai _iterator factory_. Jika pabrik ini mengembalikan sebuah fungsi (iterator sebenarnya), Lua akan menggunakan fungsi ini, dan mengelola `state` dan `control_var` secara implisit (biasanya `state` menjadi `nil` dan `control_var` menjadi `nil` untuk pemanggilan pertama ke iterator sebenarnya). Ini memungkinkan iterator stateful (yang seringkali hanya satu fungsi closure) untuk digunakan dengan mudah.
    Contoh `kuadratIteratorFactory` yang hanya mengembalikan `iteratorInternal` adalah contoh bagaimana iterator stateful dapat digunakan.

#### **Penjelasan Mendalam Tambahan**

- **Modifikasi Tabel Saat Iterasi**:
  - **Numeric `for`**: Nilai batas sudah ditentukan. Menambah/menghapus elemen dari tabel yang batasnya didasarkan pada `#tabel` tidak akan mengubah jumlah iterasi setelah loop dimulai.
  - **Generic `for` dengan `pairs`**: Perilaku memodifikasi tabel (menambah atau menghapus kunci) saat iterasi dengan `pairs` (yang menggunakan `next` secara internal) adalah _undefined_ untuk kunci yang belum dikunjungi, kecuali untuk kunci yang sedang dikunjungi (yang bisa di-set ke `nil` untuk menghapusnya). Menghapus kunci yang sudah dikunjungi aman. Sebaiknya hindari modifikasi kompleks pada tabel saat iterasi dengan `pairs` jika Anda tidak yakin dengan perilakunya.
  - **Generic `for` dengan `ipairs`**: `ipairs` lebih ketat. Jika Anda mengubah panjang array (misalnya, menyisipkan atau menghapus elemen yang menggeser indeks lain) saat iterasi dengan `ipairs`, perilakunya bisa tidak terduga. Umumnya, aman untuk mengubah nilai pada indeks yang ada, tetapi tidak aman untuk menambah/menghapus elemen yang mengubah "panjang" efektif array yang sedang diiterasi `ipairs`.
  - **Saran Umum**: Jika Anda perlu memodifikasi tabel secara signifikan saat iterasi, seringkali lebih aman untuk mengumpulkan perubahan yang diinginkan (misalnya, kunci yang akan dihapus) dalam tabel sementara, lalu lakukan modifikasi setelah loop selesai.
- **Variabel Kontrol di Generic For**: Sama seperti numeric `for`, variabel yang dideklarasikan di bagian `for <var1>, <var2> ...` bersifat lokal untuk loop.

#### **Sumber Belajar (dari README.md)**:

- [Lua Coding Tutorial - Complete Guide](https://gamedevacademy.org/lua-coding-tutorial-complete-guide/)
- [Programming in Lua: Iterators and Generic for](https://www.lua.org/pil/7.html)

---

Kita telah menyelesaikan pembahasan mengenai loop `while`, `repeat...until`, dan dua jenis loop `for` di Lua. Pemahaman yang baik tentang iterasi dan bagaimana `pairs` serta `ipairs` bekerja, termasuk konsep iterator, akan sangat membantu Anda dalam memproses data dan mengontrol alur program.



