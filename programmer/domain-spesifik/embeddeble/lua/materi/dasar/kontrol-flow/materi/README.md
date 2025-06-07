# 📚 **[Bagian 1: Fundamental Control Flow][1]**

Bagian ini adalah fondasi dari bagaimana sebuah program membuat keputusan dan mengulang tugas. Tanpa pemahaman yang kuat di sini, akan sulit untuk membangun logika program yang kompleks.

### 1.1 Pernyataan Kondisional (Conditional Statements)

**Durasi yang Disarankan:** 3-4 jam

Pernyataan kondisional memungkinkan program Anda untuk menjalankan blok kode tertentu hanya jika kondisi tertentu terpenuhi. Ini adalah cara program "membuat keputusan".

#### **Deskripsi Konkret**

Pernyataan kondisional mengevaluasi sebuah ekspresi (kondisi). Jika kondisi tersebut bernilai "benar" (truthy), maka satu blok kode akan dieksekusi. Jika "salah" (falsy), blok kode tersebut akan dilewati, atau blok kode alternatif (jika ada) yang akan dieksekusi.

#### **Terminologi dan Konsep Mendasar**

- **Kondisi (Condition)**: Sebuah ekspresi yang dievaluasi menjadi nilai boolean (benar atau salah) atau nilai yang dianggap "truthy" atau "falsy" oleh Lua.
- **Truthiness di Lua**: Di Lua, ada dua nilai yang dianggap "salah" (falsy): `false` dan `nil`. Semua nilai lainnya (termasuk angka 0, string kosong `""`, dan tabel kosong `{}`) dianggap "benar" (truthy). Ini adalah poin penting yang sering membingungkan pemrogram dari bahasa lain.
- **Blok Kode (Code Block)**: Sekumpulan satu atau lebih pernyataan yang dieksekusi bersama-sama. Dalam Lua, blok kode untuk `if`, `elseif`, dan `else` diakhiri dengan `end`.
- **Operator Perbandingan**: Digunakan untuk membandingkan dua nilai.
  - `==` (sama dengan)
  - `~=` (tidak sama dengan) – Perhatikan ini bukan `!=` seperti di banyak bahasa lain.
  - `<` (kurang dari)
  - `>` (lebih dari)
  - `<=` (kurang dari atau sama dengan)
  - `>=` (lebih dari atau sama dengan)
- **Operator Logika**: Digunakan untuk mengkombinasikan beberapa kondisi.
  - `and`: Menghasilkan `true` jika kedua operan `true`. Jika operan pertama `false` atau `nil`, ia mengembalikan operan pertama tersebut tanpa mengevaluasi operan kedua. Jika tidak, ia mengembalikan operan kedua.
  - `or`: Menghasilkan `true` jika salah satu operan `true`. Jika operan pertama bukan `false` dan bukan `nil`, ia mengembalikan operan pertama tersebut tanpa mengevaluasi operan kedua. Jika tidak, ia mengembalikan operan kedua.
  - `not`: Membalik nilai boolean dari operannya. `not true` adalah `false`, `not false` adalah `true`. `not nil` juga `true`. `not <nilai_truthy_selain_true>` adalah `false`.

#### **Sintaks Dasar dan Contoh Kode**

1.  **`if` Statement**: Menjalankan kode jika kondisi benar.

    ```lua
    -- Contoh 1: if sederhana
    local suhu = 30
    if suhu > 25 then
        print("Cuaca panas!") -- Akan dieksekusi
    end

    -- Contoh 2: Menggunakan operator logika 'and'
    local usia = 20
    local memilikiSIM = true
    if usia >= 17 and memilikiSIM then
        print("Boleh mengemudi.") -- Akan dieksekusi
    end

    -- Contoh 3: Truthiness dengan angka dan string
    if 0 then
        print("Angka 0 adalah truthy di Lua") -- Akan dieksekusi
    end

    if "" then
        print("String kosong adalah truthy di Lua") -- Akan dieksekusi
    end

    if nil then
        print("Ini tidak akan pernah dieksekusi karena nil adalah falsy")
    end
    ```

2.  **`if...else` Statement**: Menjalankan satu blok kode jika kondisi benar, dan blok kode lain jika salah.

    ```lua
    local nilaiUjian = 70
    if nilaiUjian >= 75 then
        print("Selamat, Anda lulus!")
    else
        print("Maaf, Anda perlu belajar lebih giat.") -- Akan dieksekusi
    end
    ```

3.  **`if...elseif...else` Statement**: Menguji beberapa kondisi secara berurutan.

    ```lua
    local hari = "Selasa"
    if hari == "Senin" then
        print("Hari pertama kerja.")
    elseif hari == "Rabu" then
        print("Pertengahan minggu!")
    elseif hari == "Jumat" then
        print("Menjelang akhir pekan!")
    else
        print("Hari biasa atau akhir pekan.") -- Akan dieksekusi untuk "Selasa"
    end
    ```

    Penting untuk diingat bahwa `elseif` hanya akan dievaluasi jika kondisi `if` atau `elseif` sebelumnya bernilai `false`. Segera setelah satu kondisi (dalam rantai `if/elseif`) terpenuhi dan blok kodenya dieksekusi, sisa `elseif` dan `else` akan dilewati.

#### **Topik yang Dipelajari (Sesuai Kurikulum dan Penjelasan Tambahan)**

- **Statement `if`, `else`, `elseif`**:

  - **Deskripsi**: Ini adalah struktur dasar untuk pengambilan keputusan. `if` memulai kondisi, `elseif` menyediakan kondisi alternatif jika sebelumnya salah, dan `else` menangani kasus di mana semua kondisi sebelumnya salah.
  - **Penggunaan**: Gunakan `if` untuk kondisi tunggal. Tambahkan `else` untuk alternatif jika kondisi tidak terpenuhi. Gunakan `elseif` untuk memeriksa beberapa kondisi secara eksklusif.
  - **Contoh (Gabungan)**:
    ```lua
    local skor = 85
    if skor >= 90 then
        print("Nilai A")
    elseif skor >= 80 then
        print("Nilai B") -- Akan dieksekusi
    elseif skor >= 70 then
        print("Nilai C")
    else
        print("Nilai D atau E")
    end
    ```

- **Operator perbandingan dan logika**:

  - **Deskripsi**: Operator ini adalah "alat" yang Anda gunakan untuk membangun kondisi dalam pernyataan `if`.
    - **Perbandingan**: `==`, `~=`, `<`, `>`, `<=`, `>=`. Perhatikan bahwa perbandingan string bersifat leksikografis (berdasarkan urutan karakter). Perbandingan tabel, fungsi, userdata, dan thread dilakukan berdasarkan referensi (dua tabel hanya `==` jika mereka adalah objek yang sama persis di memori).
    - **Logika**: `and`, `or`, `not`.
      - `and` dan `or` menggunakan _short-circuit evaluation_. Artinya, jika hasil ekspresi sudah bisa ditentukan dari operan pertama, operan kedua tidak akan dievaluasi. Ini penting untuk diketahui karena bisa memengaruhi performa dan juga bisa digunakan untuk trik tertentu (misalnya, `local x = a and b` akan memberi `x` nilai `a` jika `a` falsy, atau `b` jika `a` truthy).
      - `not` selalu mengembalikan `true` atau `false`.
  - **Contoh (Operator Logika dengan Short-Circuit)**:

    ```lua
    local namaPengguna = nil
    local dataDefault = "Guest"

    -- Jika namaPengguna adalah nil (falsy), maka 'or' akan mengembalikan operan kedua.
    local namaTampilan = namaPengguna or dataDefault
    print("Nama tampilan: " .. namaTampilan) -- Output: Nama tampilan: Guest

    local harusProses = true
    local fungsiBerat = function()
        print("Fungsi berat dipanggil")
        return true
    end

    -- fungsiBerat() hanya akan dipanggil jika harusProses adalah truthy.
    if harusProses and fungsiBerat() then
        print("Proses selesai.")
    end
    ```

- **Evaluasi kondisi truthiness di Lua**:

  - **Deskripsi**: Seperti yang disebutkan, hanya `false` dan `nil` yang dianggap "salah" (falsy). Semua nilai lain (angka 0, string kosong `""`, tabel kosong `{}`) adalah "benar" (truthy).
  - **Implikasi**: Ini berbeda dari banyak bahasa lain (misalnya JavaScript atau Python) di mana 0 atau string kosong bisa jadi falsy. Kesalahan dalam memahami ini bisa menyebabkan bug yang sulit dideteksi.
  - **Contoh (Perbandingan dengan bahasa lain)**:

    ```lua
    -- Di JavaScript, if (0) {} tidak akan jalan. Di Lua:
    if 0 then
        print("0 adalah truthy di Lua") -- Tercetak
    end

    if "" then
        print("String kosong adalah truthy di Lua") -- Tercetak
    end

    local tabelKosong = {}
    if tabelKosong then
        print("Tabel kosong adalah truthy di Lua") -- Tercetak
    end

    local kondisi = nil
    if not kondisi then
        print("Kondisi adalah nil (falsy), jadi 'not kondisi' adalah true.") -- Tercetak
    end
    ```

- **Nested conditionals (Kondisional Bersarang)**:

  - **Deskripsi**: Anda dapat menempatkan satu pernyataan `if` di dalam blok kode pernyataan `if` atau `else` lainnya.
  - **Penggunaan**: Berguna untuk logika yang lebih kompleks di mana satu keputusan bergantung pada keputusan lain.
  - **Perhatian**: Terlalu banyak level kondisional bersarang dapat membuat kode sulit dibaca dan dipelihara. Pertimbangkan untuk merefaktor (menyusun ulang) kode jika nesting menjadi terlalu dalam (misalnya, menggunakan fungsi, guard clauses, atau tabel lookup).
  - **Contoh**:

    ```lua
    local isLoggedIn = true
    local isAdmin = false
    local userStatus = "active"

    if isLoggedIn then
        print("Pengguna telah login.")
        if isAdmin then
            print("Akses admin diberikan.")
        else
            print("Akses pengguna standar.") -- Akan dieksekusi
            if userStatus == "active" then
                print("Status pengguna aktif.") -- Akan dieksekusi
            else
                print("Status pengguna tidak aktif.")
            end
        end
    else
        print("Pengguna belum login.")
    end
    ```

  - **Alternatif untuk Nested (Guard Clause Pattern)**: Daripada `if A then if B then ... end end`, Anda bisa menggunakan "guard clause" untuk keluar lebih awal jika kondisi tidak terpenuhi.

    ```lua
    local function prosesDataPengguna(isLoggedIn, isAdmin, userStatus)
        if not isLoggedIn then
            print("Pengguna belum login.")
            return -- Keluar dari fungsi lebih awal
        end
        print("Pengguna telah login.")

        if not isAdmin then
            print("Akses pengguna standar.")
            if userStatus ~= "active" then
                print("Status pengguna tidak aktif.")
                return -- Keluar
            end
            print("Status pengguna aktif.")
            -- Lanjutkan dengan logika pengguna standar aktif
            return
        end

        print("Akses admin diberikan.")
        -- Lanjutkan dengan logika admin
    end

    prosesDataPengguna(true, false, "active")
    ```

    Pola ini seringkali meningkatkan keterbacaan dengan mengurangi lekukan kode.

- **Pattern matching sederhana**:

  - **Deskripsi**: Dalam konteks `if/elseif`, ini merujuk pada penggunaan serangkaian `elseif` untuk mencocokkan nilai variabel dengan beberapa kemungkinan nilai literal (konstan). Ini adalah bentuk paling dasar dari "pencocokan pola".
  - **Penggunaan**: Ketika Anda memiliki satu variabel dan ingin melakukan tindakan berbeda berdasarkan beberapa nilai spesifiknya.
  - **Contoh**:

    ```lua
    local perintah = "mulai"

    if perintah == "mulai" then
        print("Memulai proses...")
    elseif perintah == "berhenti" then
        print("Menghentikan proses...")
    elseif perintah == "jeda" then
        print("Menjeda proses...")
    else
        print("Perintah tidak dikenal: " .. perintah)
    end
    ```

    Ini adalah pendahulu dari teknik _switch-case_ yang akan dibahas selanjutnya, yang sering diimplementasikan menggunakan tabel di Lua.

#### **Penjelasan Mendalam Tambahan**

- **Keterbacaan**: Usahakan agar kondisi Anda mudah dibaca. Jika kondisi menjadi terlalu panjang atau kompleks, pertimbangkan untuk memecahnya menjadi variabel boolean sementara atau fungsi.

  ```lua
  -- Kurang terbaca
  -- if (user.age > 18 and user.isVerified and (user.country == "ID" or user.country == "SG")) then ... end

  -- Lebih terbaca
  local isAdult = user.age > 18
  local isVerifiedUser = user.isVerified
  local isEligibleCountry = (user.country == "ID" or user.country == "SG")

  if isAdult and isVerifiedUser and isEligibleCountry then
      -- lakukan sesuatu
  end
  ```

- **Hindari Redundansi**: Jangan mengulang evaluasi yang sama.
- **Urutan `elseif`**: Urutan `elseif` penting jika beberapa kondisi bisa `true` untuk nilai input yang sama. Lua akan menjalankan blok kode dari kondisi pertama yang `true` dan mengabaikan sisanya.

#### **Sumber Belajar (dari README.md)**:

- [Control Structures in Lua: If, Else, and Switch](https://coderscratchpad.com/control-structures-in-lua-if-else-and-switch/)
- [Lua-users Wiki: Control Structure Tutorial](http://lua-users.org/wiki/ControlStructureTutorial)
- [Programming in Lua: Control Structures](https://www.lua.org/pil/4.3.html)

---

### 1.2 Implementasi Switch-Case Pattern

**Durasi yang Disarankan:** 2-3 jam

Lua tidak memiliki pernyataan `switch` atau `case` bawaan seperti bahasa C, Java, atau JavaScript. Namun, pola ini dapat dengan mudah disimulasikan menggunakan tabel dan fungsi, yang seringkali lebih fleksibel.

#### **Deskripsi Konkret**

Pola _switch-case_ memungkinkan Anda memilih satu blok kode untuk dieksekusi dari beberapa pilihan berdasarkan nilai sebuah ekspresi. Di Lua, ini biasanya dicapai dengan menggunakan tabel di mana _key_ adalah "kasus" (case) dan _value_ adalah fungsi yang akan dieksekusi atau hasil langsung.

#### **Terminologi dan Konsep Mendasar**

- **Tabel (Table)**: Struktur data fundamental di Lua, mirip dengan array asosiatif atau kamus (dictionary). Tabel bisa berisi pasangan kunci-nilai.
- **Dispatch Table**: Tabel yang digunakan untuk "mengirim" (dispatch) eksekusi ke fungsi yang sesuai berdasarkan suatu kunci.
- **Function as First-Class Citizen**: Di Lua, fungsi adalah nilai seperti halnya angka atau string. Mereka dapat disimpan dalam variabel, dilewatkan sebagai argumen ke fungsi lain, dikembalikan dari fungsi, dan disimpan dalam tabel. Ini adalah kunci untuk implementasi switch-case yang elegan.

#### **Topik yang Dipelajari (Sesuai Kurikulum dan Penjelasan Tambahan)**

- **Menggunakan table untuk simulasi switch-case**:

  - **Deskripsi**: Cara paling umum adalah membuat tabel di mana kunci-kuncinya adalah nilai yang ingin Anda cocokkan, dan nilai-nilainya adalah fungsi yang akan dieksekusi ketika kunci tersebut cocok.
  - **Sintaks Dasar dan Contoh Kode**:

    ```lua
    local function handleMulai()
        print("Memulai layanan...")
    end

    local function handleBerhenti()
        print("Menghentikan layanan...")
    end

    local function handleRestart()
        print("Merestart layanan...")
    end

    local actions = {
        ["mulai"] = handleMulai,
        ["berhenti"] = handleBerhenti,
        ["restart"] = handleRestart,
        ["status"] = function() -- Fungsi anonim langsung di dalam tabel
            print("Status layanan: Aktif")
        end
    }

    local command = "mulai"
    local actionToExecute = actions[command] -- Mengambil fungsi dari tabel

    if actionToExecute then
        actionToExecute() -- Memanggil fungsi: Output "Memulai layanan..."
    else
        print("Perintah tidak valid: " .. command)
    end

    -- Contoh lain dengan perintah berbeda
    command = "status"
    actionToExecute = actions[command]
    if actionToExecute then
        actionToExecute() -- Output "Status layanan: Aktif"
    else
        print("Perintah tidak valid: " .. command)
    end

    command = "tidakAda"
    actionToExecute = actions[command] -- Akan menjadi nil
    if actionToExecute then
        actionToExecute()
    else
        print("Perintah tidak valid: " .. command) -- Output "Perintah tidak valid: tidakAda"
    end
    ```

  - **Penjelasan Mendalam**:

    - **Default Case**: Anda bisa menangani kasus "default" (jika tidak ada kunci yang cocok) dengan pemeriksaan `if actionToExecute then ... else ... end` seperti di atas, atau dengan metatable (akan dibahas nanti di kurikulum). Cara sederhana lain adalah dengan fungsi default:

      ```lua
      local function handleDefault()
          print("Perintah tidak diketahui.")
      end

      local command = "foo"
      local actionToExecute = actions[command] or handleDefault
      actionToExecute() -- Output "Perintah tidak diketahui."
      ```

    - **Nilai Langsung**: Tidak selalu harus fungsi. Nilai dalam tabel bisa berupa data apa pun.
      ```lua
      local fruitColors = {
          apple = "merah",
          banana = "kuning",
          grape = "ungu"
      }
      local fruit = "banana"
      local color = fruitColors[fruit] or "tidak diketahui"
      print("Warna " .. fruit .. " adalah " .. color) -- Output: Warna banana adalah kuning
      ```

- **Function dispatch patterns**:

  - **Deskripsi**: Ini adalah istilah yang lebih umum untuk pola di mana Anda menggunakan suatu nilai (seperti string perintah) untuk menentukan fungsi mana yang akan dipanggil. Simulasi switch-case menggunakan tabel fungsi adalah salah satu bentuk function dispatch.
  - **Manfaat**: Membuat kode lebih modular, mudah diperluas (cukup tambahkan entri baru ke tabel), dan seringkali lebih mudah dibaca daripada rantai `if/elseif` yang panjang.

- **Conditional table lookups**:

  - **Deskripsi**: Ini mengacu pada proses pengambilan nilai dari tabel berdasarkan suatu kondisi atau variabel, dan kemudian bertindak berdasarkan nilai yang ditemukan (atau tidak ditemukan).
  - **Contoh**: `actions[command]` adalah lookup. Kemudian Anda secara kondisional memanggilnya jika tidak `nil`.

- **Performance considerations (Pertimbangan Performa)**:
  - **Deskripsi**: Untuk sejumlah kecil kasus, rantai `if/elseif` mungkin sedikit lebih cepat karena overhead pembuatan tabel dan lookup. Namun, untuk jumlah kasus yang lebih besar, lookup tabel (yang dioptimalkan dengan baik di Lua, biasanya mendekati O(1) untuk hash part) bisa lebih cepat dan lebih terukur daripada serangkaian perbandingan string linear dalam `elseif`.
  - **Kapan Menggunakan**:
    - **`if/elseif`**: Cocok untuk 2-5 kasus, terutama jika urutan evaluasi penting atau kondisinya kompleks dan bukan sekadar perbandingan kesetaraan.
    - **Table Dispatch**: Sangat baik untuk banyak kasus (>5-10), di mana setiap kasus adalah pencocokan nilai sederhana. Meningkatkan keterbacaan dan kemudahan pemeliharaan secara signifikan.
  - **Penting**: Kecuali ini adalah bagian kode yang sangat kritis performa dan Anda telah melakukan _profiling_ (pengukuran performa), pilihlah pendekatan yang paling mudah dibaca dan dipelihara. Premature optimization is the root of all evil.

#### **Penjelasan Mendalam Tambahan**

- **Fleksibilitas**: Tabel dispatch bisa lebih dari sekadar mencocokkan string. Kunci bisa berupa angka atau tipe data lain (meskipun string dan angka adalah yang paling umum).
- **Struktur Kode**: Pola ini membantu memisahkan logika "pemilihan" dari logika "aksi", yang merupakan prinsip desain yang baik.
- **Kasus dengan Fall-through**: Pola `switch` tradisional di beberapa bahasa memiliki "fall-through" (jika tidak ada `break`, eksekusi berlanjut ke kasus berikutnya). Ini tidak secara alami terjadi dengan pola tabel fungsi Lua, yang biasanya lebih aman dan kurang rentan error. Jika fall-through benar-benar dibutuhkan (jarang), Anda harus mengimplementasikannya secara eksplisit dalam fungsi yang dipanggil.

#### **Sumber Belajar (dari README.md)**:

- [Control Structures in Lua: If, Else, and Switch](https://coderscratchpad.com/control-structures-in-lua-if-else-and-switch/) (Meskipun judul menyebutkan switch, artikel ini kemungkinan besar membahas simulasi karena Lua tidak memiliki switch bawaan)
- [Lua-users Wiki: Switch Statement](http://lua-users.org/wiki/SwitchStatement) (Halaman ini pasti akan menjelaskan berbagai cara untuk menyimulasikan switch di Lua)

---

Ini adalah penjelasan untuk Bagian 1 dari kurikulum. Kita telah membahas pernyataan kondisional dasar dan bagaimana menyimulasikan pola switch-case di Lua. Fondasi ini sangat penting.
\*"2.4 Tipe String - _Deep String Mechanics_"\*\*.

# 📚 **[Bagian 2: Loop Structures][2]**

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

# 📚 **[Bagian 3: Flow Control Statements][3]**

Pernyataan kontrol alur (flow control statements) ini memberikan Anda cara untuk memodifikasi perilaku standar dari loop atau blok kode, seperti keluar dari loop lebih awal atau melompati bagian dari kode. Di Lua, ini melibatkan `break` dan `goto`, serta pola untuk menyimulasikan `continue`.

### 3.1 Break Statement

**Durasi yang Disarankan:** 2-3 jam

Statement `break` digunakan untuk menghentikan eksekusi loop (`for`, `while`, `repeat...until`) secara prematur, sebelum kondisi normal loop terpenuhi untuk berhenti.

#### **Deskripsi Konkret**

Ketika `break` dieksekusi di dalam sebuah loop, loop tersebut akan segera berhenti. Kontrol program kemudian akan dilanjutkan ke pernyataan pertama setelah blok loop tersebut.

#### **Terminologi dan Konsep Mendasar**

- **Premature Exit (Keluar Prematur)**: Mengakhiri loop sebelum semua iterasi yang dijadwalkan atau kondisi akhir normal tercapai.
- **Innermost Loop (Loop Terdalam)**: Jika `break` digunakan di dalam loop bersarang (nested loops), ia hanya akan menghentikan loop terdalam yang langsung membungkusnya.

#### **Topik yang Dipelajari (Sesuai Kurikulum dan Penjelasan Tambahan)**

- **Penggunaan `break` dalam loops**:

  - **Sintaks**:

    ```lua
    -- Di dalam while loop
    while kondisi do
        -- ...
        if kondisi_break then
            break -- Keluar dari while loop
        end
        -- ...
    end

    -- Di dalam repeat...until loop
    repeat
        -- ...
        if kondisi_break then
            break -- Keluar dari repeat...until loop
        end
        -- ...
    until kondisi_loop

    -- Di dalam for loop
    for i = awal, akhir do
        -- ...
        if kondisi_break then
            break -- Keluar dari for loop
        end
        -- ...
    end
    ```

  - **Contoh Kode**:

    ```lua
    print("Contoh break dalam while loop:")
    local angka = 0
    while angka < 10 do
        if angka == 5 then
            print("Mencapai angka 5, keluar dari loop!")
            break
        end
        print("Angka saat ini: " .. angka)
        angka = angka + 1
    end
    -- Output:
    -- Angka saat ini: 0
    -- Angka saat ini: 1
    -- Angka saat ini: 2
    -- Angka saat ini: 3
    -- Angka saat ini: 4
    -- Mencapai angka 5, keluar dari loop!

    print("\nContoh break dalam for loop (mencari elemen):")
    local daftarNama = {"Adi", "Budi", "Citra", "Desi"}
    local namaDicari = "Citra"
    local ditemukan = false
    for i, nama in ipairs(daftarNama) do
        if nama == namaDicari then
            print(namaDicari .. " ditemukan pada indeks " .. i)
            ditemukan = true
            break -- Tidak perlu mencari lagi
        end
    end
    if not ditemukan then
        print(namaDicari .. " tidak ditemukan.")
    end
    -- Output: Citra ditemukan pada indeks 3
    ```

- **Breaking dari nested loops (Keluar dari Loop Bersarang)**:

  - **Deskripsi**: `break` hanya menghentikan loop terdalam. Jika Anda ingin keluar dari beberapa level loop bersarang, Anda memerlukan teknik tambahan, seperti menggunakan variabel flag atau `goto`.
  - **Contoh dengan Flag**:
    ```lua
    print("\nKeluar dari nested loop menggunakan flag:")
    local keluarSemuaLoop = false
    for i = 1, 3 do
        if keluarSemuaLoop then break end -- Periksa flag untuk loop luar
        print("Loop luar i = " .. i)
        for j = 1, 3 do
            print("  Loop dalam j = " .. j)
            if i == 2 and j == 2 then
                print("    Kondisi break tercapai di i=" .. i .. ", j=" .. j)
                keluarSemuaLoop = true
                break -- Keluar dari loop dalam
            end
        end
    end
    -- Output:
    -- Loop luar i = 1
    --   Loop dalam j = 1
    --   Loop dalam j = 2
    --   Loop dalam j = 3
    -- Loop luar i = 2
    --   Loop dalam j = 1
    --   Loop dalam j = 2
    --     Kondisi break tercapai di i=2, j=2
    ```
  - **Menggunakan `goto` (untuk "labeled breaks")**: Ini akan dibahas lebih detail di bagian `goto`, tapi ini adalah salah satu penggunaannya yang sah.

- **Labeled breaks (menggunakan goto)**:

  - **Deskripsi**: Lua tidak memiliki sintaks `break <label>` secara langsung seperti beberapa bahasa lain. Namun, Anda dapat menyimulasikan perilaku ini menggunakan `goto` untuk melompat ke sebuah label yang ditempatkan setelah loop luar. Ini adalah cara yang lebih bersih untuk keluar dari loop bersarang yang dalam dibandingkan dengan multiple flags.
  - **Contoh dengan `goto`**:
    ```lua
    print("\nKeluar dari nested loop menggunakan goto (simulasi labeled break):")
    for i = 1, 3 do
        print("Loop luar i = " .. i)
        for j = 1, 3 do
            print("  Loop dalam j = " .. j)
            if i == 2 and j == 2 then
                print("    Kondisi break tercapai, melompat ke akhir_loop_bersarang")
                goto akhir_loop_bersarang
            end
        end
    end
    ::akhir_loop_bersarang:: -- Label tujuan
    print("Setelah loop bersarang (menggunakan goto)")
    -- Output:
    -- Loop luar i = 1
    --   Loop dalam j = 1
    --   Loop dalam j = 2
    --   Loop dalam j = 3
    -- Loop luar i = 2
    --   Loop dalam j = 1
    --   Loop dalam j = 2
    --     Kondisi break tercapai, melompat ke akhir_loop_bersarang
    -- Setelah loop bersarang (menggunakan goto)
    ```

- **Best practices dan anti-patterns (Praktik Terbaik dan Anti-Pola)**:
  - **Praktik Terbaik**:
    - Gunakan `break` untuk meningkatkan efisiensi ketika hasil yang diinginkan sudah tercapai (misalnya, dalam pencarian).
    - Gunakan `break` untuk menangani kondisi keluar yang tidak terduga atau khusus.
    - Jika loop memiliki banyak kondisi keluar, `break` bisa membuat logika lebih jelas daripada kondisi loop yang sangat kompleks.
  - **Anti-Pola**:
    - **Overuse of `break`**: Terlalu banyak `break` dalam satu loop bisa membuat alur kontrol sulit diikuti. Kadang-kadang, merevisi kondisi loop atau menggunakan struktur kontrol lain mungkin lebih baik.
    - **`break` sebagai pengganti kondisi loop yang jelas**: Jika logika keluar utama bisa diekspresikan dengan jelas dalam kondisi `while` atau `until`, itu biasanya lebih disukai.
    - **Menggunakan `break` yang menyebabkan sumber daya tidak dibersihkan**: Jika Anda melakukan alokasi sumber daya di awal loop dan membersihkannya di akhir, `break` di tengah bisa melewatkan pembersihan. Pastikan pembersihan (jika ada) dilakukan sebelum `break` atau menggunakan pola `goto` ke bagian cleanup (seperti yang akan dibahas nanti).

#### **Penjelasan Mendalam Tambahan**

- `break` hanya dapat muncul di dalam blok loop (`while`, `repeat`, `for`). Menempatkannya di luar loop akan menyebabkan error kompilasi.
- `break` adalah pernyataan, bukan ekspresi. Ia tidak mengembalikan nilai.

#### **Sumber Belajar (dari README.md)**:

- [Mastering Lua Break: A Quick Guide to Control Flow](https://luascripts.com/lua-break)
- [Lua-users Wiki: Control Structure Tutorial](http://lua-users.org/wiki/ControlStructureTutorial)

---

### 3.2 Continue Pattern Implementation

**Durasi yang Disarankan:** 2-3 jam

Lua tidak memiliki pernyataan `continue` bawaan seperti di bahasa C, Python, atau Java. Pernyataan `continue` biasanya digunakan untuk melompati sisa iterasi saat ini dalam sebuah loop dan melanjutkan ke iterasi berikutnya. Namun, perilaku ini dapat disimulasikan di Lua.

#### **Deskripsi Konkret**

Karena tidak ada `continue` langsung, kita mengimplementasikan polanya dengan cara lain untuk mencapai efek yang sama: melompati bagian akhir dari tubuh loop dan langsung memulai iterasi berikutnya (atau memeriksa kondisi untuk iterasi berikutnya).

#### **Terminologi dan Konsep Mendasar**

- **Skip Iteration (Melompati Iterasi)**: Mengabaikan sisa kode dalam iterasi loop saat ini dan beralih ke awal iterasi berikutnya.

#### **Topik yang Dipelajari (Sesuai Kurikulum dan Penjelasan Tambahan)**

- **Implementasi continue menggunakan nested blocks (blok bersarang `if`)**:

  - **Deskripsi**: Cara paling umum dan seringkali paling mudah dibaca adalah dengan membungkus sisa tubuh loop dalam sebuah blok `if`. Jika kondisi untuk "melanjutkan" (continue) terpenuhi, Anda _tidak_ masuk ke blok `if` tersebut.
  - **Contoh Kode**:

    ```lua
    print("\nSimulasi continue menggunakan blok if:")
    for i = 1, 10 do
        if i % 2 == 0 then
            -- Ini adalah "kondisi continue" (jika i genap, kita "melanjutkan")
            -- Tidak ada kode 'else' yang eksplisit, jadi sisa loop dilewati untuk i genap.
        else
            -- Blok ini hanya dieksekusi jika i tidak genap (yaitu, ganjil)
            print("Memproses angka ganjil: " .. i)
        end
        -- Kode setelah blok if-else (jika ada) akan selalu dijalankan
        -- Untuk 'continue' sejati, semua sisa loop harus ada di dalam 'else'
    end
    -- Output:
    -- Memproses angka ganjil: 1
    -- Memproses angka ganjil: 3
    -- Memproses angka ganjil: 5
    -- Memproses angka ganjil: 7
    -- Memproses angka ganjil: 9

    -- Pola yang lebih mirip 'continue' klasik:
    print("\nSimulasi continue lebih dekat (semua sisa loop di dalam 'else'):")
    for i = 1, 5 do
        local skip = false
        if i == 3 then -- Kondisi untuk "melanjutkan" (skip iterasi ini)
            print("Melompati iterasi untuk i = " .. i)
            skip = true
        end

        if not skip then
            -- Sisa tubuh loop
            print("Memproses i = " .. i)
        end
        -- Akhir tubuh loop
    end
    -- Output:
    -- Memproses i = 1
    -- Memproses i = 2
    -- Melompati iterasi untuk i = 3
    -- Memproses i = 4
    -- Memproses i = 5
    ```

    Pola yang lebih umum dan sering digunakan adalah dengan membalik kondisinya:

    ```lua
    print("\nSimulasi continue dengan kondisi if terbalik:")
    for i = 1, 5 do
        if i % 2 ~= 0 then -- Hanya proses jika i ganjil
            print("Angka ganjil yang diproses: " .. i)
            -- Bagian ini adalah "tubuh loop utama" setelah kondisi continue tidak terpenuhi
        end
        -- Tidak ada 'else', jadi jika i genap, blok di atas dilewati, mirip 'continue'
    end
    -- Output:
    -- Angka ganjil yang diproses: 1
    -- Angka ganjil yang diproses: 3
    -- Angka ganjil yang diproses: 5
    ```

- **Goto-based continue pattern (Pola continue berbasis `goto`)**:

  - **Deskripsi**: Sejak Lua 5.2, `goto` dapat digunakan untuk menyimulasikan `continue` dengan lebih presisi. Anda membuat label di akhir blok loop (sebelum `end` untuk `for`/`while`, atau sebelum `until` untuk `repeat`) dan melompat ke sana.
  - **Contoh Kode**:

    ```lua
    print("\nSimulasi continue menggunakan goto (Lua 5.2+):")
    for i = 1, 5 do
        if i == 3 then
            print("Melompati iterasi untuk i = " .. i .. " menggunakan goto")
            goto continue_loop -- Melompat ke label di akhir iterasi
        end
        print("Memproses i = " .. i)
        ::continue_loop:: -- Label untuk 'continue'
        -- Tidak ada pernyataan setelah label ini di dalam for loop agar ia berfungsi seperti continue
    end
    -- Output:
    -- Memproses i = 1
    -- Memproses i = 2
    -- Melompati iterasi untuk i = 3 menggunakan goto
    -- Memproses i = 4
    -- Memproses i = 5

    print("\nSimulasi continue dengan goto dalam while:")
    local j = 0
    while j < 5 do
        j = j + 1
        if j == 3 then
            print("Melompati iterasi untuk j = " .. j .. " menggunakan goto")
            goto continue_while_loop
        end
        print("Memproses j = " .. j)
        ::continue_while_loop::
    end
    -- Output:
    -- Memproses j = 1
    -- Memproses j = 2
    -- Melompati iterasi untuk j = 3 menggunakan goto
    -- Memproses j = 4
    -- Memproses j = 5

    -- Untuk repeat...until, label akan ditempatkan sebelum 'until'
    print("\nSimulasi continue dengan goto dalam repeat...until:")
    local k = 0
    repeat
        k = k + 1
        if k == 3 then
            print("Melompati iterasi untuk k = " .. k .. " menggunakan goto")
            goto continue_repeat_loop
        end
        print("Memproses k = " .. k)
        ::continue_repeat_loop::
    until k >= 5
    -- Output:
    -- Memproses k = 1
    -- Memproses k = 2
    -- Melompati iterasi untuk k = 3 menggunakan goto
    -- Memproses k = 4
    -- Memproses k = 5
    ```

  - **Penting**: Untuk `for` loop, variabel kontrol akan tetap diperbarui secara otomatis. Untuk `while` dan `repeat`, pastikan pembaruan variabel kondisi loop tetap terjadi jika Anda melompat. Dalam contoh `while` di atas, `j = j + 1` dilakukan _sebelum_ potensi `goto`.

- **Performance implications (Implikasi Performa)**:

  - **Deskripsi**: Perbedaan performa antara simulasi `continue` menggunakan blok `if` dan `goto` biasanya minimal dan jarang menjadi perhatian kecuali dalam loop yang sangat ketat dan sering dijalankan.
  - Penggunaan `goto` mungkin memiliki sedikit overhead, tetapi kompiler Lua modern (terutama LuaJIT) cukup canggih.

- **Readability vs functionality trade-offs (Pertukaran Keterbacaan vs Fungsionalitas)**:
  - **Blok `if`**: Seringkali lebih mudah dibaca dan dipahami bagi mereka yang tidak terbiasa dengan `goto` atau datang dari bahasa tanpa `goto`. Ini adalah pendekatan yang paling "aman" dari segi keterbacaan umum.
  - **`goto`**: Dapat membuat niat "continue" lebih eksplisit jika digunakan dengan disiplin (misalnya, selalu label bernama `continue_loop` atau sejenisnya, dan hanya digunakan untuk tujuan ini). Namun, penyalahgunaan `goto` dapat dengan cepat menyebabkan kode yang sulit dibaca ("spaghetti code").
  - **Pilihan**: Pilihlah metode yang membuat kode Anda paling jelas dan mudah dipelihara. Untuk kasus sederhana, blok `if` biasanya cukup. Jika loop sangat kompleks dan `goto` benar-benar menyederhanakan logika "skip ke iterasi berikutnya", maka itu bisa dipertimbangkan, tetapi dengan hati-hati.

#### **Penjelasan Mendalam Tambahan**

- **Mengapa Lua Tidak Memiliki `continue`?**: Para desainer Lua cenderung minimalis dan seringkali menghindari penambahan fitur jika fungsionalitasnya dapat dicapai dengan cara lain yang masuk akal, atau jika fitur tersebut dapat menyebabkan komplikasi (misalnya, interaksi dengan _closures_ atau _upvalues_ dalam kasus `continue`). Argumennya adalah bahwa `continue` seringkali dapat dihindari dengan menstrukturkan ulang kondisi loop atau menggunakan blok `if`.
- **Alternatif lain**: Kadang-kadang, memecah bagian loop menjadi fungsi terpisah bisa menjadi cara yang lebih bersih untuk mengelola logika kompleks, daripada menggunakan `break` atau simulasi `continue`.

#### **Sumber Belajar (dari README.md)**:

- [Lua Continue: Controlling Loop Flow with Ease](https://luascripts.com/lua-continue) (Kemungkinan besar akan membahas pola-pola ini)
- [Stack Overflow: Continue Statement in Lua](https://stackoverflow.com/questions/3524970/why-does-lua-have-no-continue-statement) (Diskusi komunitas yang baik tentang alasan dan alternatifnya)

---

### 3.3 Goto Statement

**Durasi yang Disarankan:** 3-4 jam

Statement `goto` (diperkenalkan di Lua 5.2) memungkinkan Anda untuk mentransfer kontrol eksekusi secara langsung ke titik lain dalam fungsi yang sama, yang ditandai dengan sebuah _label_. Penggunaannya kontroversial tetapi bisa berguna dalam situasi tertentu jika dipakai dengan bijak.

#### **Deskripsi Konkret**

`goto <nama_label>` akan menyebabkan eksekusi program melompat ke baris di mana `::<nama_label>::` didefinisikan.

#### **Terminologi dan Konsep Mendasar**

- **Label**: Sebuah penanda dalam kode dengan format `::<nama_label>::`. Nama label mengikuti aturan yang sama dengan nama variabel.
- **Scope of Label (Cakupan Label)**: Label memiliki cakupan blok di mana ia didefinisikan. Artinya, `goto` hanya bisa melompat ke label yang berada dalam cakupan yang sama atau cakupan pembungkus yang lebih luar. Yang penting, `goto` tidak bisa melompat _ke dalam_ sebuah blok.
- **Structured Programming (Pemrograman Terstruktur)**: Paradigma pemrograman yang bertujuan untuk meningkatkan kejelasan, kualitas, dan waktu pengembangan program komputer dengan menggunakan subrutin, struktur blok (urutan, seleksi, iterasi), dan menghindari penggunaan `goto` yang tidak terkendali.

#### **Topik yang Dipelajari (Sesuai Kurikulum dan Penjelasan Tambahan)**

- **Syntax dan aturan penggunaan `goto`**:

  - **Sintaks Label**: `::<nama_label>::`
  - **Sintaks Goto**: `goto <nama_label>`
  - **Aturan Utama**:
    1.  `goto` hanya dapat melompat ke label dalam fungsi saat ini. Anda tidak bisa `goto` ke fungsi lain atau dari fungsi lain.
    2.  `goto` tidak dapat melompat _ke dalam_ scope variabel lokal. Jika Anda melompat melewati deklarasi variabel lokal, variabel tersebut tidak akan terdefinisi.
        ```lua
        -- TIDAK VALID: Melompat ke dalam scope variabel lokal 'x'
        -- function tesGotoInvalid()
        --    goto melompat_masuk -- error!
        --    do
        --        local x = 10
        --        ::melompat_masuk::
        --        print(x)
        --    end
        -- end
        ```
    3.  Sebaliknya, `goto` dapat melompat _keluar_ dari blok. Jika ini terjadi, variabel lokal yang didefinisikan dalam blok tersebut akan keluar dari scope seperti biasa.
        ```lua
        -- VALID: Melompat keluar dari scope variabel lokal 'x'
        function tesGotoValidKeluar()
            do
                local x = 10
                print("Sebelum goto, x =", x) -- Tercetak
                goto melompat_keluar
                -- print("Ini tidak akan tercetak")
            end
            ::melompat_keluar::
            print("Setelah goto")
            -- print(x) -- Error, x sudah di luar scope
        end
        tesGotoValidKeluar()
        ```
  - **Contoh Kode Sederhana**:
    ```lua
    local count = 0
    ::ulangi_bagian_ini::
    count = count + 1
    print("Hitungan: " .. count)
    if count < 3 then
        goto ulangi_bagian_ini
    end
    print("Selesai menghitung.")
    -- Output:
    -- Hitungan: 1
    -- Hitungan: 2
    -- Hitungan: 3
    -- Selesai menghitung.
    -- (Ini adalah cara yang sangat sederhana untuk membuat loop, meskipun `while` atau `repeat` lebih disukai)
    ```

- **Label declarations dan scope (Deklarasi Label dan Cakupannya)**:

  - **Deklarasi**: `::nama_label::`. Label tidak menghasilkan kode apa pun; ia hanya penanda.
  - **Cakupan**: Label terlihat di seluruh blok tempat ia didefinisikan, termasuk blok-blok bersarang di dalamnya. Label tidak terlihat di luar bloknya.
    - Sebuah label dianggap berada dalam scope sebuah blok jika ia muncul di antara `do` dan `end` blok tersebut (atau `function...end`, `if...end`, dll.).
  - **Aturan Visibilitas**: Anda tidak bisa melompat ke label yang belum terlihat atau ke dalam blok di mana variabel lokal baru dideklarasikan setelah titik lompat.

- **Structured programming dengan `goto` (Pemrograman Terstruktur dengan `goto`)**:

  - **Deskripsi**: Meskipun `goto` sering dikaitkan dengan "spaghetti code" (kode yang alurnya melompat-lompat tidak karuan dan sulit diikuti), ada beberapa pola penggunaan `goto` yang dianggap "terstruktur" atau setidaknya dapat diterima dalam situasi terbatas:
    1.  **Simulasi `break <label>` atau `continue <label>`**: Seperti yang telah dibahas, untuk keluar dari loop bersarang atau menyimulasikan `continue`.
    2.  **Cleanup Terpusat**: Dalam fungsi yang kompleks yang mungkin memiliki beberapa titik keluar (misalnya, karena error), `goto` dapat digunakan untuk melompat ke satu bagian kode cleanup di akhir fungsi.
    3.  **Finite State Machines (Mesin Keadaan Terbatas)**: Kadang-kadang digunakan untuk transisi antar state, meskipun tabel dispatch seringkali lebih disukai.
  - **Prinsip**: Jika menggunakan `goto`, usahakan agar lompatan selalu maju (forward jump) ke titik yang tidak terlalu jauh, atau lompatan mundur yang jelas-jelas membentuk struktur loop terbatas. Hindari membuat alur yang bersilangan atau sulit dilacak.

- **Error handling patterns menggunakan `goto` (Pola Penanganan Error menggunakan `goto`)**:

  - **Deskripsi**: Ini adalah salah satu penggunaan `goto` yang paling sering diterima, terutama di bahasa seperti C yang tidak memiliki exception handling try-catch. Di Lua, `pcall` dan `xpcall` adalah cara utama menangani error, tetapi `goto` bisa digunakan untuk cleanup sebelum error dilempar ulang atau sebelum fungsi keluar.
  - **Contoh Kode (Cleanup sebelum error)**:

    ```lua
    local function prosesFile(namaFile)
        local file = io.open(namaFile, "r")
        if not file then
            print("Gagal membuka file: " .. namaFile)
            goto cleanup_resources -- Tidak ada sumber daya untuk dibersihkan di sini, tapi sebagai contoh
        end

        local dataPenting = file:read("*a")
        if not dataPenting then
            print("Gagal membaca data dari file.")
            goto cleanup_file -- Lompat untuk menutup file sebelum keluar
        end

        -- ... lakukan sesuatu dengan dataPenting ...
        print("Data berhasil diproses.")

        ::cleanup_file::
        if file then file:close() end
        ::cleanup_resources:: -- Label umum untuk semua cleanup
        print("Fungsi prosesFile selesai.")
        -- Jika error, Anda mungkin ingin mengembalikan status error
        if not dataPenting and file then return false, "Gagal membaca" end
        if not file then return false, "Gagal buka" end
        return true
    end

    prosesFile("file_yang_tidak_ada.txt")
    -- Buat file dummy.txt berisi "hello"
    -- io.open("dummy.txt", "w"):write("hello"):close()
    -- prosesFile("dummy.txt")
    ```

    Meskipun contoh di atas menunjukkan pola, di Lua, seringkali lebih idiomatik untuk menggunakan `pcall` untuk menangkap error dan melakukan cleanup di dalam blok `pcall` atau setelahnya, atau menggunakan struktur `if/else` yang baik.

- **Goto limitations dan restrictions (Batasan dan Pembatasan `goto`)**:
  - Tidak bisa melompat ke dalam scope variabel lokal. (Sangat penting!)
  - Tidak bisa melompat keluar dari sebuah fungsi.
  - Tidak bisa melompat ke dalam scope dari label itu sendiri (meskipun ini jarang terjadi).
  - Label harus unik dalam cakupannya.
  - Penggunaan `goto` yang berlebihan membuat kode sulit dibaca dan di-debug. Banyak pengembang menghindarinya kecuali untuk kasus-kasus yang sangat spesifik di mana alternatifnya lebih rumit.

#### **Penjelasan Mendalam Tambahan**

- **Sejarah dan Kontroversi**: Penggunaan `goto` secara luas dikritik oleh Edsger Dijkstra dalam suratnya tahun 1968 "Go To Statement Considered Harmful." Ini memicu gerakan menuju pemrograman terstruktur. Meskipun demikian, `goto` tetap ada di banyak bahasa dan bisa berguna jika digunakan dengan sangat hati-hati dan untuk pola yang terbatas.
- **Alternatif untuk `goto`**: Sebagian besar penggunaan `goto` dapat dihindari dengan:
  - Struktur loop dan kondisional yang baik (`if`, `while`, `repeat`, `for`).
  - Memecah fungsi menjadi fungsi-fungsi yang lebih kecil dan lebih fokus.
  - Menggunakan `return` lebih awal dari fungsi.
  - Menggunakan `pcall` atau `xpcall` untuk menangani error.
  - Menggunakan tabel dispatch untuk state machines.
- **Kapan `goto` Mungkin Bisa Diterima di Lua**:
  1.  Keluar dari loop bersarang yang dalam (simulasi `break <label>`).
  2.  Simulasi `continue` dalam loop yang kompleks di mana blok `if` menjadi canggung.
  3.  Optimasi manual dalam loop yang sangat kritis performa (sangat jarang, dan hanya setelah profiling, biasanya lebih relevan untuk kode C-like yang ditulis di Lua).
  4.  Mesin keadaan terbatas (state machines) yang ditulis secara langsung (meskipun tabel seringkali lebih bersih).

#### **Sumber Belajar (dari README.md)**:

- [Mastering Lua Goto: Quick Guide to Control Flow](https://luascripts.com/lua-goto)
- [Programming in Lua: The Complete Reference](https://www.lua.org/pil/) (PIL edisi ke-3 atau lebih baru akan membahas `goto` karena diperkenalkan di Lua 5.2. Edisi pertama mungkin tidak.)

---

Kita telah membahas `break`, pola untuk `continue`, dan penggunaan `goto`. Ini adalah alat yang ampuh, tetapi `goto` khususnya harus digunakan dengan sangat hati-hati untuk menjaga kode tetap terbaca dan terpelihara.

# 📚 **[Bagian 4: Advanced Control Flow Patterns][4]**

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

### Daftar Isi Pembelajaran

Bagian ini berfungsi sebagai peta jalan Anda. Tautan di bawah ini akan membawa Anda langsung ke bagian yang relevan dalam penjelasan ini.

- **Materi yang Telah Dibahas (Ringkasan)**

  - **Bagian 1**: Mempelajari dasar pengambilan keputusan dengan `if`, `elseif`, `else`, dan mensimulasikan `switch-case` menggunakan tabel.
  - **Bagian 2**: Menguasai perulangan dengan `while`, `repeat...until`, dan dua jenis `for` loop (numerik dan generik).
  - **Bagian 3**: Mempelajari cara mengontrol alur loop lebih lanjut dengan `break` dan `goto`, serta pola untuk menyimulasikan `continue`.
  - **Bagian 4**: Mendalami pola-pola canggih seperti kontrol alur berbasis tabel (state machines), fungsional (map, filter, reduce), dan berbasis metatabel (`__index`, `__call`).

- **Materi Saat Ini: Penanganan Error**

  - **Bagian 5: Error Handling dan Exception Flow**
    - [5.1 Dasar-Dasar Penanganan Error](#51-dasar-dasar-penanganan-error)
    - [5.2 Panggilan Terproteksi (`pcall`/`xpcall`)](#52-panggilan-terproteksi-pcallxpcall)

---

# 📚 **[Bagian 5: Error Handling dan Exception Flow][5]**

Penanganan error adalah aspek krusial dalam membuat program yang tangguh (_robust_). Program yang baik tidak hanya berjalan dengan benar pada input yang sempurna, tetapi juga dapat menangani situasi tak terduga (error) dengan anggun tanpa langsung mogok (_crash_). Lua menyediakan beberapa mekanisme untuk menangani error.

### 5.1 Dasar-Dasar Penanganan Error

**Durasi yang Disarankan:** 4-5 jam

Bagian ini membahas cara dasar untuk menghasilkan (memunculkan) error dan melakukan pemrograman defensif untuk mencegah error terjadi.

#### **Deskripsi Konkret**

Dasar penanganan error di Lua melibatkan fungsi `error()` untuk secara sengaja menghentikan eksekusi dan `assert()` untuk memeriksa apakah suatu kondisi benar, dan jika tidak, memunculkan error. Ini adalah alat utama Anda untuk menandakan bahwa sesuatu yang tidak diharapkan telah terjadi.

#### **Terminologi dan Konsep Mendasar**

- **Error Propagation (Propagasi Error)**: Jika sebuah error terjadi di dalam sebuah fungsi dan tidak ditangani, error tersebut akan "merambat" ke atas melalui tumpukan panggilan (_call stack_), dari fungsi pemanggil ke fungsi yang memanggilnya, dan seterusnya, hingga mencapai tingkat teratas dan menghentikan program.
- **Defensive Programming (Pemrograman Defensif)**: Gaya penulisan kode di mana Anda secara eksplisit memeriksa validitas input, asumsi, dan kondisi untuk memastikan program berperilaku seperti yang diharapkan dan mencegah error sebelum terjadi. `assert()` adalah alat utama untuk ini.
- **Stack Trace (Jejak Tumpukan)**: Laporan yang menunjukkan urutan pemanggilan fungsi yang sedang aktif pada saat error terjadi. Ini sangat berguna untuk debugging karena menunjukkan di mana dan bagaimana error tersebut muncul.

#### **Topik yang Dipelajari (Sesuai Kurikulum dan Penjelasan Tambahan)**

- **`error()` function dan error propagation**:

  - **Deskripsi**: Fungsi `error(pesan_error, level)` digunakan untuk menghentikan eksekusi program dan memunculkan pesan error. Ini adalah cara Lua untuk "melempar pengecualian" (_throw an exception_).
  - **Sintaks**: `error(message, [level])`
    - `message`: String (atau objek lain) yang akan menjadi pesan error.
    - `level` (opsional): Angka yang menentukan di mana error dilaporkan terjadi dalam stack trace.
      - `level = 1` (default): Melaporkan error terjadi di baris tempat `error()` dipanggil.
      - `level = 2`: Melaporkan error terjadi di baris tempat fungsi yang memanggil `error()` dipanggil.
      - `level = 0`: Tidak menyertakan informasi lokasi sama sekali.
  - **Contoh Kode**:

    ```lua
    local function bagi(a, b)
        if b == 0 then
            -- Memunculkan error secara eksplisit. Program akan berhenti di sini jika tidak ditangani.
            error("Pembagian dengan nol tidak diizinkan.", 2)
            -- level=2 membuat error dilaporkan di baris yang memanggil 'bagi', bukan di dalam 'bagi'.
            -- Ini lebih berguna bagi pengguna fungsi.
        end
        return a / b
    end

    local function hitung(x, y)
        print("Mencoba melakukan pembagian...")
        local hasil = bagi(x, y) -- Panggilan yang bisa menyebabkan error
        print("Hasilnya adalah: " .. hasil)
        return hasil
    end

    -- hitung(10, 2) -- Ini akan berjalan dengan baik
    -- hitung(10, 0) -- Ini akan memunculkan error dan menghentikan script.
    -- Output error dari hitung(10, 0):
    -- .../nama_file.lua:16: Pembagian dengan nol tidak diizinkan.
    -- stack traceback:
    --     [C]: in function 'error'
    --     .../nama_file.lua:4: in function 'bagi'
    --     .../nama_file.lua:16: in function 'hitung'  <-- Perhatikan error dilaporkan di sini karena level=2
    --     ...
    ```

  - **Propagasi**: Dalam contoh di atas, error yang dilempar oleh `bagi()` merambat ke `hitung()`. Karena `hitung()` tidak menanganinya, error tersebut merambat lebih jauh ke atas hingga menghentikan skrip.

- **`assert()` untuk defensive programming**:

  - **Deskripsi**: Fungsi `assert(kondisi, [pesan_error])` adalah alat pemrograman defensif yang sangat umum di Lua.
    - Jika `kondisi` adalah `true` (atau nilai truthy lainnya), `assert` akan mengembalikan semua argumennya (termasuk `kondisi` itu sendiri) dan eksekusi berlanjut.
    - Jika `kondisi` adalah `false` atau `nil`, `assert` akan memanggil `error(pesan_error)`. Jika `pesan_error` tidak diberikan, pesan defaultnya adalah "assertion failed\!".
  - **Penggunaan**: Ini sangat berguna untuk memvalidasi argumen fungsi, memeriksa nilai kembali dari fungsi lain, dan memastikan asumsi dalam kode Anda benar.
  - **Contoh Kode**:

    ```lua
    local function setUserAge(user, age)
        -- Memastikan argumen 'user' adalah sebuah tabel dan 'age' adalah angka positif.
        assert(type(user) == "table", "Argumen 'user' harus berupa tabel")
        assert(type(age) == "number" and age > 0, "Argumen 'age' harus angka positif")
        user.age = age
        print("Usia pengguna ditetapkan menjadi " .. age)
    end

    local user1 = {}
    setUserAge(user1, 30) -- Valid

    -- setUserAge(nil, 25) -- Akan error: "Argumen 'user' harus berupa tabel"
    -- setUserAge(user1, -5) -- Akan error: "Argumen 'age' harus angka positif"

    -- Menggunakan assert untuk memeriksa hasil panggilan fungsi
    local file, err_msg = io.open("file_yang_ada.txt", "r")
    -- Jika io.open gagal, ia mengembalikan nil dan pesan error.
    -- assert akan menangkap ini.
    -- local file = assert(io.open("file_yang_tidak_ada.txt", "r")) -- Akan error dengan pesan dari io.open
    -- print("File berhasil dibuka")
    -- if file then file:close() end
    ```

  - **`assert` sebagai Ekspresi**: Karena `assert` mengembalikan argumennya jika berhasil, ia bisa digunakan dalam sebuah ekspresi.
    ```lua
    local function getValue() return "nilai penting" end
    -- assert akan memeriksa apakah getValue() mengembalikan nilai truthy,
    -- dan jika ya, myValue akan diisi dengan nilai tersebut.
    local myValue = assert(getValue(), "getValue() gagal mengembalikan nilai")
    ```

- **Error message formatting (Format Pesan Error)**:

  - **Deskripsi**: Membuat pesan error yang jelas dan informatif sangat penting untuk debugging. `string.format` sering digunakan untuk ini.
  - **Praktik Terbaik**:
    - Sertakan informasi tentang apa yang salah.
    - Sebutkan nilai yang menyebabkan masalah.
    - Berikan petunjuk tentang apa yang seharusnya terjadi.
  - **Contoh Kode**:

    ```lua
    local function getItem(index)
        local items = {"a", "b", "c"}
        assert(type(index) == "number", string.format("Indeks harus berupa angka, tetapi mendapat %s", type(index)))
        assert(items[index], string.format("Indeks %d di luar batas (harus antara 1 dan %d)", index, #items))
        return items[index]
    end

    print(getItem(2)) -- b
    -- print(getItem("satu")) -- Akan error: Indeks harus berupa angka, tetapi mendapat string
    -- print(getItem(5))     -- Akan error: Indeks 5 di luar batas (harus antara 1 dan 3)
    ```

- **Error levels dan stack traces (Level Error dan Jejak Tumpukan)**:

  - **Deskripsi**: Seperti yang disebutkan, `level` pada `error()` mengontrol di mana lokasi error dilaporkan. Ini penting saat membuat fungsi pustaka (library). Anda ingin error dilaporkan dari sudut pandang _pengguna_ pustaka Anda, bukan dari dalam pustaka itu sendiri.
  - **Contoh Kasus Penggunaan `level=2`**:

    ```lua
    -- Bayangkan ini adalah bagian dari library `my_utils.lua`
    local M = {}
    function M.mustBePositive(val)
        if not (type(val) == "number" and val > 0) then
            -- level=2 membuat error menunjuk ke kode yang memanggil mustBePositive
            error("nilai harus positif, tetapi mendapat " .. tostring(val), 2)
        end
    end
    return M

    -- Sekarang di file lain (misalnya main.lua)
    -- local my_utils = require("my_utils")
    -- local function calculateSomething(input)
    --     my_utils.mustBePositive(input) -- Baris 5 di main.lua
    --     -- ...
    -- end
    -- calculateSomething(-10)
    -- Error akan dilaporkan di "main.lua:5", yang jauh lebih membantu
    -- daripada dilaporkan di dalam file "my_utils.lua".
    ```

#### **Penjelasan Mendalam Tambahan**

- **Error Objects**: Argumen pertama untuk `error()` dan `assert()` tidak harus berupa string. Anda bisa melemparkan tabel yang berisi informasi lebih detail, yang kemudian bisa ditangkap oleh `pcall` (dibahas selanjutnya).
- **Kapan Menggunakan `error` vs `assert`**:
  - Gunakan `assert` untuk memeriksa _pra-kondisi_ (asumsi tentang input atau state sebelum operasi) dan _pasca-kondisi_ (asumsi tentang output atau state setelah operasi). Ini adalah alat untuk pemrograman defensif.
  - Gunakan `error` ketika Anda mendeteksi kondisi error yang tidak dapat dipulihkan di tengah-tengah logika, di mana `assert` tidak cocok (misalnya, pembagian dengan nol, format file salah, dll.).

#### **Sumber Belajar (dari README.md)**:

- [Lua Error Handling](https://www.tutorialspoint.com/lua/lua_error_handling.htm)
- [Programming in Lua: Error Handling](https://www.lua.org/pil/8.4.html)

---

### 5.2 Panggilan Terproteksi (`pcall`/`xpcall`)

**Durasi yang Disarankan:** 3-4 jam

Jika `error` dan `assert` adalah cara untuk _memunculkan_ error, `pcall` dan `xpcall` adalah cara untuk _menangkap_ dan _menanganinya_ tanpa membuat program crash.

#### **Deskripsi Konkret**

`pcall` (_protected call_) mengeksekusi sebuah fungsi dalam "mode terproteksi". Jika terjadi error selama eksekusi fungsi tersebut, `pcall` akan menangkap error tersebut, tidak membiarkannya merambat, dan mengembalikan status error. `xpcall` (_extended protected call_) melakukan hal yang sama tetapi dengan tambahan fungsi penangan error (_error handler_) kustom.

#### **Terminologi dan Konsep Mendasar**

- **Protected Environment (Lingkungan Terproteksi)**: Konteks eksekusi yang dibuat oleh `pcall` atau `xpcall` di mana error yang terjadi tidak akan menghentikan program, melainkan akan ditangkap.
- **Error Handler Function (Fungsi Penangan Error)**: Fungsi yang dipanggil oleh `xpcall` ketika error terjadi. Fungsi ini menerima objek error sebagai argumen dan dapat memproses atau memformat ulang pesan error sebelum dikembalikan oleh `xpcall`.

#### **Topik yang Dipelajari (Sesuai Kurikulum dan Penjelasan Tambahan)**

- **`pcall()` untuk error recovery (Pemulihan error dengan `pcall`)**:

  - **Deskripsi**: `pcall(f, arg1, ...)` memanggil fungsi `f` dengan argumen `arg1, ...` dalam mode terproteksi.
  - **Nilai Kembali**:
    - **Jika tidak ada error**: `pcall` mengembalikan `true` diikuti oleh semua nilai yang dikembalikan oleh fungsi `f`.
    - **Jika ada error**: `pcall` mengembalikan `false` diikuti oleh objek error (biasanya string pesan error).
  - **Contoh Kode**:

    ```lua
    local function fungsiYangMungkinError(a, b)
        assert(type(a) == "number" and type(b) == "number", "Kedua argumen harus angka")
        if b == 0 then
            error("Pembagian dengan nol")
        end
        return a / b, "Sukses" -- Fungsi bisa mengembalikan beberapa nilai
    end

    -- Kasus Sukses
    local status, hasil1, hasil2 = pcall(fungsiYangMungkinError, 10, 2)
    print("Status:", status)
    print("Hasil 1:", hasil1)
    print("Hasil 2:", hasil2)
    -- Output:
    -- Status: true
    -- Hasil 1: 5
    -- Hasil 2: Sukses

    print("---")

    -- Kasus Error (Pembagian dengan nol)
    local statusErr, pesanError = pcall(fungsiYangMungkinError, 10, 0)
    print("Status:", statusErr)
    print("Pesan Error:", pesanError)
    -- Output:
    -- Status: false
    -- Pesan Error: ...:123: Pembagian dengan nol  (nomor baris bisa berbeda)

    print("---")

    -- Kasus Error (Tipe argumen salah)
    local statusErr2, pesanError2 = pcall(fungsiYangMungkinError, 10, "dua")
    print("Status:", statusErr2)
    print("Pesan Error:", pesanError2)
    -- Output:
    -- Status: false
    -- Pesan Error: ...:123: Kedua argumen harus angka (nomor baris bisa berbeda)

    print("\nEksekusi berlanjut setelah pcall, program tidak crash.")
    ```

  - **Penggunaan Umum**: Memanggil kode yang tidak Anda kontrol (misalnya, dari library pihak ketiga), melakukan operasi I/O yang bisa gagal, atau mengimplementasikan sistem plugin di mana plugin bisa saja error.

- **`xpcall()` dengan custom error handlers (`xpcall` dengan penangan error kustom)**:

  - **Deskripsi**: `xpcall(f, err_handler, arg1, ...)` mirip dengan `pcall`, tetapi jika terjadi error, ia akan memanggil fungsi `err_handler` terlebih dahulu dengan objek error sebagai argumen. Nilai yang dikembalikan oleh `err_handler` akan menjadi nilai yang dikembalikan oleh `xpcall` sebagai pesan error.
  - **Penggunaan**: Ini memungkinkan Anda untuk memproses error sebelum ditampilkan. Anda bisa menambahkan informasi debugging, stack trace yang lebih detail, atau memformatnya menjadi format log yang standar.
  - **Contoh Kode**:

    ```lua
    local function fungsiError()
        -- error({ code = 101, message = "File tidak ditemukan" }) -- Contoh error object
        variable_yang_tidak_ada = variable_yang_tidak_ada + 1 -- Ini akan menyebabkan error
    end

    local function myErrorHandler(err)
        print("--- Di dalam Error Handler Kustom ---")
        print("Objek error mentah:", err)
        -- 'debug.traceback()' adalah fungsi yang sangat berguna untuk mendapatkan stack trace
        local traceback = debug.traceback()
        print("Menambahkan stack trace...")
        return "Terjadi error: " .. tostring(err) .. "\n" .. traceback
    end

    local status, hasil_atau_error = xpcall(fungsiError, myErrorHandler)

    print("\n--- Hasil dari xpcall ---")
    print("Status:", status)
    print("Hasil/Error yang diformat:\n" .. hasil_atau_error)
    ```

    **Output akan terlihat seperti:**

    ```
    --- Di dalam Error Handler Kustom ---
    Objek error mentah: ...: attempt to perform arithmetic on a nil value (global 'variable_yang_tidak_ada')
    Menambahkan stack trace...

    --- Hasil dari xpcall ---
    Status: false
    Hasil/Error yang diformat:
    Terjadi error: ...: attempt to perform arithmetic on a nil value (global 'variable_yang_tidak_ada')
    stack traceback:
        ...: in function 'fungsiError'
        [C]: in function 'xpcall'
        ...
    ```

- **Error handling patterns dan best practices (Pola penanganan error dan praktik terbaik)**:

  - **Never swallow errors (Jangan pernah menelan error)**: Hindari blok `pcall` kosong yang menangkap error tetapi tidak melakukan apa-apa dengannya (tidak mencatat, tidak melaporkan). Ini membuat debugging menjadi mimpi buruk.
    ```lua
    -- ANTI-PATTERN: Menelan error
    -- local status, err = pcall(fungsiBerbahaya)
    -- if not status then
    --     -- Melakukan apa? Tidak ada. Error hilang begitu saja.
    -- end
    ```
  - **Resource Cleanup (Pembersihan Sumber Daya)**: `pcall` tidak secara otomatis membersihkan sumber daya (seperti file yang terbuka). Anda harus memastikan pembersihan dilakukan. Pola `try...finally` dari bahasa lain dapat disimulasikan, meskipun agak canggung.

    ```lua
    local file
    local status, err = pcall(function()
        file = assert(io.open("data.txt", "w"))
        file:write("sesuatu yang bisa error")
        -- Jika error terjadi di sini, blok 'finally' di bawah akan tetap berjalan
        error("simulasi error")
    end)

    -- Blok 'finally'
    if file then
        print("Membersihkan sumber daya file...")
        file:close()
    end

    if not status then
        print("Error ditangkap setelah cleanup: " .. err)
    end
    ```

    Pola ini memastikan `file:close()` dipanggil baik fungsi di dalam `pcall` berhasil maupun gagal.

  - **Gunakan `xpcall` untuk logging terpusat**: `xpcall` sangat baik untuk sistem logging di mana Anda ingin semua error memiliki format yang konsisten dan menyertakan informasi debugging yang kaya seperti stack trace.

- **Performance impact of protected calls (Dampak performa dari panggilan terproteksi)**:

  - **Deskripsi**: `pcall` dan `xpcall` memiliki overhead performa. Mereka perlu menyiapkan lingkungan terproteksi sebelum memanggil fungsi. Overhead ini mungkin tidak signifikan untuk operasi yang jarang atau sudah lambat (seperti I/O file), tetapi bisa menjadi masalah jika digunakan di dalam loop yang sangat ketat (_tight loop_).
  - **Aturan Praktis**: Jangan gunakan `pcall`/`xpcall` untuk kontrol alur normal yang tidak berhubungan dengan error. Gunakan mereka secara strategis di "batas" sistem Anda, di mana Anda berinteraksi dengan kode yang tidak dapat dipercaya atau operasi yang rentan gagal.

#### **Penjelasan Mendalam Tambahan**

- **`pcall` vs `xpcall`**:
  - Gunakan `pcall` untuk penanganan error yang sederhana, di mana Anda hanya perlu tahu apakah operasi berhasil atau gagal dan apa pesan errornya.
  - Gunakan `xpcall` ketika Anda memerlukan kontrol lebih besar atas bagaimana error dilaporkan. Kemampuan untuk menambahkan stack trace secara terprogram adalah keuntungan utamanya.

#### **Sumber Belajar (dari README.md)**:

- [Lua Error Handling](https://www.tutorialspoint.com/lua/lua_error_handling.htm)
- [Lua 5.4 Reference Manual](https://www.lua.org/manual/5.4/manual.html) (Bagian `pcall` dan `xpcall`)

---

Kita telah membahas cara memunculkan, menangkap, dan menangani error di Lua. Menguasai alat-alat ini akan membuat kode Anda jauh lebih andal dan mudah di-debug. Berikutnya kita akan memasuki salah satu fitur paling kuat dan unik di Lua: **Bagian 6: Coroutines - Advanced Asynchronous Control**. Ini adalah topik yang sangat menarik dan membuka banyak kemungkinan baru.

### Daftar Isi Pembelajaran

Berikut adalah peta jalan untuk materi yang akan kita bahas. Tautan di bawah ini akan membawa Anda langsung ke bagian yang relevan.

- **Materi yang Telah Dibahas (Ringkasan)**

  - **Bagian 1-4**: Membahas dasar-dasar kontrol alur, perulangan, `break`/`goto`, hingga pola-pola canggih menggunakan tabel, fungsi, dan metatabel.
  - **Bagian 5**: Mempelajari cara memunculkan, menangkap, dan menangani error secara tangguh menggunakan `error`, `assert`, `pcall`, dan `xpcall`.

- **Materi Saat Ini: Coroutines**

  - **Bagian 6: Coroutines - Advanced Asynchronous Control**
    - [6.1 Dasar-Dasar Coroutine](#61-dasar-dasar-coroutine)
    - [6.2 Pola Coroutine Tingkat Lanjut](#62-pola-coroutine-tingkat-lanjut)
    - [6.3 Pemrograman Asinkron dengan Coroutines](#63-pemrograman-asinkron-dengan-coroutines)

---

# 📚 **[Bagian 6: Coroutines - Advanced Asynchronous Control][6]**

Coroutine adalah salah satu fitur paling kuat di Lua. Mereka mirip dengan _threads_ (utas) dalam pemrograman konkuren, tetapi perbedaannya krusial: coroutine menjalankan _cooperative multitasking_, bukan _preemptive multitasking_. Artinya, sebuah coroutine hanya akan berhenti berjalan dan memberikan kontrol ke coroutine lain jika ia secara eksplisit memintanya.

Bayangkan coroutine seperti percakapan yang bisa dijeda. Anda bisa berbicara sebentar (menjalankan kode), lalu menjeda percakapan untuk membiarkan orang lain berbicara (menyerahkan kontrol), dan kemudian melanjutkan percakapan Anda tepat dari titik di mana Anda berhenti.

### 6.1 Dasar-Dasar Coroutine

**Durasi yang Disarankan:** 5-6 jam

Bagian ini membahas cara membuat, menjalankan, menjeda, dan melanjutkan coroutine, serta bagaimana mereka berkomunikasi satu sama lain.

#### **Deskripsi Konkret**

Dasar-dasar coroutine mencakup pembuatan sebuah "utas eksekusi" baru yang terpisah menggunakan `coroutine.create()`. Utas ini kemudian dapat dijalankan dengan `coroutine.resume()`, yang akan menjalankan kodenya hingga ia selesai atau secara eksplisit menjeda dirinya sendiri dengan `coroutine.yield()`.

#### **Terminologi dan Konsep Mendasar**

- **Coroutine**: Sebuah blok kode (fungsi) yang memiliki alur eksekusinya sendiri dan dapat menjeda serta melanjutkan eksekusi. Setiap coroutine memiliki tumpukan (stack) sendiri.
- **`resume`**: Perintah untuk memulai atau melanjutkan eksekusi sebuah coroutine.
- **`yield`**: Perintah yang dieksekusi _di dalam_ sebuah coroutine untuk menjeda eksekusinya dan mengembalikan kontrol (beserta nilai opsional) ke fungsi yang memanggil `resume`.
- **States (Keadaan)**: Sebuah coroutine dapat berada dalam salah satu dari beberapa keadaan:
  - `'running'`: Sedang aktif menjalankan kode.
  - `'suspended'`: Dijeda (setelah dibuat atau setelah memanggil `yield`).
  - `'dead'`: Telah selesai mengeksekusi kodenya atau dihentikan oleh error.
  - `'normal'`: Coroutine yang sedang melanjutkan coroutine lain.

#### **Topik yang Dipelajari (Sesuai Kurikulum dan Penjelasan Tambahan)**

- **Coroutine creation dengan `coroutine.create()`**:

  - **Deskripsi**: `coroutine.create(f)` membuat coroutine baru dari fungsi `f` tetapi tidak langsung menjalankannya. Fungsi `f` akan menjadi "tubuh" dari coroutine tersebut.
  - **Sintaks**: `co = coroutine.create(fungsi_tubuh_coroutine)`
  - **Nilai Kembali**: Mengembalikan objek coroutine (bertipe `thread`) dalam keadaan `'suspended'`.
  - **Contoh Kode**:

    ```lua
    local function tubuhCoroutine()
        print("Halo dari dalam coroutine!")
    end

    -- Membuat coroutine, tetapi belum menjalankannya.
    local co = coroutine.create(tubuhCoroutine)

    print("Tipe dari co:", type(co))       -- Output: thread
    print("Status co awal:", coroutine.status(co)) -- Output: suspended
    ```

- **`coroutine.resume()` dan `coroutine.yield()`**:

  - **`coroutine.resume(co, ...)`**:
    - **Deskripsi**: Memulai atau melanjutkan eksekusi coroutine `co`. Argumen tambahan akan dilewatkan sebagai parameter ke fungsi tubuh coroutine (jika ini adalah resume pertama) atau sebagai nilai kembali dari `coroutine.yield()` (jika ini adalah resume berikutnya).
    - **Nilai Kembali**: Mengembalikan `true` diikuti oleh nilai apa pun yang dilewatkan ke `yield` atau dikembalikan oleh fungsi coroutine. Jika terjadi error, mengembalikan `false` diikuti pesan error.
  - **`coroutine.yield(...)`**:
    - **Deskripsi**: Hanya bisa dipanggil dari dalam coroutine. Ini menjeda coroutine dan mengembalikan kontrol ke pemanggil `resume`. Nilai apa pun yang dilewatkan ke `yield` akan menjadi nilai kembali dari `resume`.
    - **Nilai Kembali**: Ketika coroutine dilanjutkan lagi, `yield` akan mengembalikan argumen tambahan yang dilewatkan ke `resume`.
  - **Contoh Interaksi `resume`/`yield`**:

    ```lua
    local co = coroutine.create(function(a, b)
        print("Coroutine dimulai dengan argumen:", a, b) -- a=10, b=20
        local hasilYield1 = coroutine.yield(a + b) -- Menjeda, mengembalikan 30 ke resume

        print("Coroutine dilanjutkan, mendapat nilai:", hasilYield1) -- hasilYield1 = "lanjutkan"
        local hasilYield2 = coroutine.yield(a - b) -- Menjeda, mengembalikan -10 ke resume

        print("Coroutine dilanjutkan lagi, mendapat nilai:", hasilYield2)
        return "Selesai!" -- Selesai, mengembalikan "Selesai!" ke resume
    end)

    print("Memulai coroutine pertama kali...")
    local status1, nilai1 = coroutine.resume(co, 10, 20)
    print("Status Resume 1:", status1) -- true
    print("Nilai dari Yield 1:", nilai1) -- 30
    print("Status coroutine setelah yield:", coroutine.status(co)) -- suspended
    print("---")

    print("Melanjutkan coroutine kedua kali...")
    local status2, nilai2 = coroutine.resume(co, "lanjutkan")
    print("Status Resume 2:", status2) -- true
    print("Nilai dari Yield 2:", nilai2) -- -10
    print("---")

    print("Melanjutkan coroutine ketiga kali...")
    local status3, nilai3 = coroutine.resume(co, "apa kabar?")
    print("Status Resume 3:", status3) -- true
    print("Nilai return dari coroutine:", nilai3) -- Selesai!
    print("Status coroutine setelah selesai:", coroutine.status(co)) -- dead
    ```

    Alur komunikasi ini sangat penting untuk dipahami:

    - `resume` -\> `argumen fungsi` (panggilan pertama)
    - `yield` -\> `nilai kembali resume`
    - `resume` -\> `nilai kembali yield`
    - `return` -\> `nilai kembali resume`

- **Coroutine states dan lifecycle (Keadaan dan Siklus Hidup Coroutine)**:

  - **Deskripsi**: Siklus hidup coroutine dikelola oleh fungsi-fungsi di dalam pustaka `coroutine`.
    - `coroutine.create()`: `suspended`
    - `coroutine.resume()`: `running` (selama eksekusi) -\> `suspended` (jika `yield`) atau `dead` (jika selesai/error).
    - `coroutine.status(co)`: Mengembalikan string yang merepresentasikan keadaan `co` saat ini (`'running'`, `'suspended'`, `'dead'`, `'normal'`).
  - **Fungsi Terkait Lainnya**:
    - `coroutine.running()`: Mengembalikan coroutine yang sedang berjalan saat ini. Jika dipanggil dari thread utama, mengembalikan thread utama itu sendiri.
    - `coroutine.isyieldable()`: Mengembalikan `true` jika coroutine yang sedang berjalan bisa di-`yield`.

#### **Penjelasan Mendalam Tambahan**

- **Perbedaan dengan Fungsi Biasa**: Fungsi biasa memiliki satu titik masuk (saat dipanggil) dan satu titik keluar (saat `return`). Coroutine memiliki banyak titik masuk (saat `resume`) dan banyak titik keluar (saat `yield` atau `return`).
- **Stack Terpisah**: Setiap coroutine memiliki stack Lua sendiri. Ini berarti variabel lokal di dalam coroutine tetap terjaga nilainya di antara jeda `yield` dan `resume`.
- **Error Handling**: Jika error terjadi di dalam coroutine, `coroutine.resume` akan menangkapnya dan mengembalikan `false` serta pesan error, mirip seperti `pcall`.

#### **Sumber Belajar (dari README.md)**:

- [Coroutines in Lua: Mastering Asynchronous Programming](https://luascripts.com/coroutines-in-lua)
- [Programming in Lua: Coroutines](https://www.lua.org/pil/9.1.html)
- [Lua Coroutines](https://www.tutorialspoint.com/lua/lua_coroutines.htm)

---

### 6.2 Pola Coroutine Tingkat Lanjut

**Durasi yang Disarankan:** 6-7 jam

Setelah memahami dasar-dasarnya, Anda dapat menggunakan coroutine untuk mengimplementasikan pola-pola pemrograman yang kuat dan elegan.

#### **Deskripsi Konkret**

Pola-pola ini menggunakan kemampuan jeda dan lanjut dari coroutine untuk memisahkan logika yang berbeda namun saling bekerja sama, seperti memisahkan kode yang menghasilkan data (produser) dari kode yang menggunakan data (konsumer).

#### **Topik yang Dipelajari (Sesuai Kurikulum dan Penjelasan Tambahan)**

- **Producer-consumer patterns (Pola Produser-Konsumer)**:

  - **Deskripsi**: Ini adalah pola klasik di mana satu bagian dari program (produser) menghasilkan data, dan bagian lain (konsumer) menggunakan data tersebut. Coroutine memungkinkan kedua bagian ini berjalan seolah-olah secara bersamaan, tanpa perlu buffer data sementara yang besar.
  - **Implementasi**:
    - Produser berjalan di dalam coroutine. Setiap kali ia memiliki data baru, ia memanggil `coroutine.yield(data_baru)`.
    - Konsumer (di luar coroutine) memanggil `coroutine.resume()` untuk mendapatkan data baru dari produser.
  - **Contoh Kode**:

    ```lua
    local function producer()
        local i = 0
        while i < 3 do
            i = i + 1
            local data = "Data ke-" .. i
            print("Produser: Menghasilkan", data)
            coroutine.yield(data) -- Kirim data ke konsumer
        end
        print("Produser: Selesai.")
    end

    local function consumer()
        local co_produser = coroutine.create(producer)
        print("Konsumer: Memulai produser.")

        while true do
            local status, dataDiterima = coroutine.resume(co_produser)
            if not status or coroutine.status(co_produser) == "dead" then
                print("Konsumer: Produser berhenti atau error.")
                break
            end
            print("Konsumer: Menerima", dataDiterima)
        end
    end

    consumer()
    ```

- **Pipeline processing dengan coroutines (Pemrosesan Pipa dengan Coroutine)**:

  - **Deskripsi**: Perluasan dari pola produser-konsumer. Output dari satu coroutine menjadi input untuk coroutine berikutnya, membentuk sebuah "pipa" pemrosesan data.
  - **Contoh Kode**: Pipa: `Sumber Data -> Filter Angka Ganjil -> Kuadratkan Angka`

    ```lua
    -- Tahap 1: Sumber Data (Produser)
    local function sumberData(batas)
        return coroutine.create(function()
            for i = 1, batas do coroutine.yield(i) end
        end)
    end

    -- Tahap 2: Filter (Konsumer dari tahap sebelumnya, Produser untuk tahap berikutnya)
    local function filterGanjil(sumber_co)
        return coroutine.create(function()
            while true do
                local status, val = coroutine.resume(sumber_co)
                if not val then break end
                if val % 2 ~= 0 then
                    coroutine.yield(val) -- Hanya teruskan jika ganjil
                end
            end
        end)
    end

    -- Tahap 3: Kuadratkan (Sama seperti filter)
    local function kuadratkan(sumber_co)
        return coroutine.create(function()
            while true do
                local status, val = coroutine.resume(sumber_co)
                if not val then break end
                coroutine.yield(val * val) -- Kuadratkan nilai
            end
        end)
    end

    -- Rangkai Pipa
    local pipa = kuadratkan(filterGanjil(sumberData(10)))

    -- Konsumer akhir: Jalankan pipa dan cetak hasilnya
    print("Hasil Pipa Pemrosesan:")
    while true do
        local status, hasil = coroutine.resume(pipa)
        if not hasil then break end
        print(hasil) -- 1*1=1, 3*3=9, 5*5=25, 7*7=49, 9*9=81
    end
    ```

- **Iterator implementation menggunakan coroutines (Implementasi Iterator dengan Coroutine)**:

  - **Deskripsi**: Coroutine adalah cara yang sangat elegan untuk membuat iterator yang kompleks (terutama yang _stateful_). Logika untuk menghasilkan nilai berikutnya bisa ditulis secara lurus di dalam tubuh coroutine, dan `yield` digunakan untuk mengembalikan setiap nilai.
  - **Contoh Kode**: Membuat iterator untuk permutasi sebuah tabel.

    ```lua
    local function createPermutationIterator(t)
        local function perm_generator(a, n)
            n = n or #a
            if n <= 1 then
                coroutine.yield(a) -- Menghasilkan satu permutasi
            else
                for i = 1, n do
                    a[n], a[i] = a[i], a[n] -- Tukar
                    perm_generator(a, n - 1)
                    a[n], a[i] = a[i], a[n] -- Kembalikan
                end
            end
        end

        -- Bungkus generator dalam coroutine
        local co = coroutine.create(function() perm_generator(t) end)

        -- Kembalikan fungsi yang memanggil resume pada coroutine
        return function()
            local status, value = coroutine.resume(co)
            return value
        end
    end

    print("\nIterator Permutasi:")
    local data = {"a", "b", "c"}
    for p in createPermutationIterator(data) do
        print(table.concat(p, " "))
    end
    ```

  - **Perbandingan**: Bandingkan betapa sederhananya logika `perm_generator` dibandingkan harus mengelola state permutasi secara manual dalam sebuah closure iterator biasa.

- **Error handling dalam coroutines**:

  - **Deskripsi**: Seperti yang disebutkan, `coroutine.resume` berfungsi seperti `pcall`. Jika error terjadi di dalam coroutine, `resume` akan mengembalikan `false` dan pesan error. Error tidak akan merambat keluar dan menghentikan program utama.
  - **Penting**: `coroutine.yield` tidak dapat dipanggil dari dalam C functions, metamethods (kecuali beberapa), atau iterator. Jika Anda mencoba, ini akan menyebabkan error.

- **Coroutine-based state machines**:

  - **Deskripsi**: Setiap state dapat diwakili oleh sebuah fungsi di dalam coroutine. Transisi antar state adalah pemanggilan fungsi biasa. Untuk menunggu event eksternal, coroutine bisa `yield`, dan event loop utama akan me-`resume` coroutine tersebut dengan data event yang relevan.
  - **Konsep**:

    ```lua
    local function state_machine()
        while true do
            -- State 1: Menunggu Input
            print("State: Menunggu Input")
            local input = coroutine.yield() -- Jeda, tunggu event loop memberikan input

            if input == "perintah_a" then
                -- State 2: Memproses Perintah A
                print("State: Memproses A")
                -- lakukan sesuatu...
            elseif input == "perintah_b" then
                -- State 3: Memproses Perintah B
                print("State: Memproses B")
                -- lakukan sesuatu...
            elseif input == "selesai" then
                break
            end
            -- Loop kembali ke state "Menunggu Input"
        end
    end
    -- Event loop akan membuat dan me-resume coroutine ini dengan event
    ```

#### **Sumber Belajar (dari README.md)**:

- [Coroutines in Lua: Concurrency Made Simple](https://coderscratchpad.com/coroutines-in-lua-concurrency-made-simple/)
- [Understanding Coroutines in Lua: Mastering Concurrency](https://softwarepatternslexicon.com/patterns-lua/9/1/)

---

### 6.3 Pemrograman Asinkron dengan Coroutines

**Durasi yang Disarankan:** 5-6 jam

Ini adalah aplikasi paling umum dan kuat dari coroutine: memungkinkan operasi yang memakan waktu (seperti I/O jaringan atau file) berjalan tanpa memblokir seluruh program.

#### **Deskripsi Konkret**

Dalam pemrograman asinkron (async), ketika sebuah tugas yang lama (misalnya, mengunduh file) dimulai, program tidak menunggu hingga tugas itu selesai. Sebaliknya, program melanjutkan eksekusi tugas lain. Ketika tugas yang lama itu akhirnya selesai, program akan diberitahu dan dapat melanjutkan pemrosesan hasilnya. Coroutine adalah mekanisme sempurna untuk menjeda tugas yang menunggu dan melanjutkannya nanti.

#### **Terminologi dan Konsep Mendasar**

- **Non-blocking I/O**: Operasi Input/Output (seperti membaca file atau soket jaringan) yang langsung kembali tanpa menunggu selesai. Program perlu memeriksa statusnya nanti.
- **Event Loop / Scheduler**: Komponen pusat dari program async. Ia bertugas memantau event (misalnya, "data dari jaringan telah tiba", "timer selesai") dan melanjutkan coroutine yang sesuai yang sedang menunggu event tersebut.
- **Cooperative Multitasking**: Seperti yang telah dibahas, tugas-tugas (coroutines) secara sukarela menyerahkan kontrol (`yield`), memungkinkan scheduler menjalankan tugas lain.
- **Async/Await Pattern**: Sintaks yang lebih manis untuk pemrograman async. `await` pada dasarnya adalah `yield` yang menunggu hasil dari operasi async, dan `async` menandai sebuah fungsi sebagai fungsi yang bisa menggunakan `await`. Lua tidak memiliki sintaks ini secara bawaan, tetapi dapat disimulasikan.

#### **Topik yang Dipelajari (Sesuai Kurikulum dan Penjelasan Tambahan)**

- **Non-blocking I/O patterns**:

  - **Deskripsi**: Daripada memanggil `socket:receive()` yang memblokir, Anda akan memanggil versi non-blocking yang memulai operasi dan langsung kembali. Event loop akan memantau soket. Ketika data siap, ia akan `resume` coroutine yang menunggu data tersebut.

- **Event-driven programming**:

  - **Deskripsi**: Model pemrograman di mana alur program ditentukan oleh event. Event loop adalah inti dari model ini. Coroutine memungkinkan penangan event (_event handler_) ditulis secara sekuensial dan mudah dibaca, meskipun di balik layar mereka dijeda dan dilanjutkan.

- **Scheduler implementation (Implementasi Scheduler)**:

  - **Deskripsi**: Scheduler adalah event loop yang mengelola sekumpulan coroutine. Ia menjalankan satu per satu sampai mereka `yield`. Ketika sebuah coroutine `yield` karena menunggu operasi I/O, scheduler akan mendaftarkan I/O tersebut ke pemantau (seperti `select` atau `epoll` di sistem operasi) dan melanjutkan coroutine lain yang siap jalan.
  - **Contoh Konseptual Scheduler Sederhana**:

    ```lua
    local scheduler = {}
    scheduler.tasks = {} -- Daftar coroutine yang siap dijalankan

    -- Fungsi untuk menjalankan tugas baru
    function scheduler:newTask(func)
        local co = coroutine.create(func)
        table.insert(self.tasks, co)
    end

    -- Fungsi async palsu
    function scheduler:sleep(detik)
        local waktuSelesai = os.time() + detik
        print("Coroutine menjeda selama", detik, "detik...")
        -- Dalam scheduler sungguhan, ini akan mendaftarkan timer
        -- dan yield tanpa memblokir. Di sini kita simulasi yield.
        while os.time() < waktuSelesai do
            coroutine.yield() -- Serahkan kontrol ke scheduler
        end
        print("Coroutine bangun.")
    end

    -- Loop utama scheduler
    function scheduler:run()
        while #self.tasks > 0 do
            -- Jalankan semua task yang siap
            for i = #self.tasks, 1, -1 do
                local co = self.tasks[i]
                local status = coroutine.resume(co)
                if coroutine.status(co) == "dead" then
                    -- Hapus task yang sudah selesai
                    table.remove(self.tasks, i)
                end
            end
            -- Dalam scheduler sungguhan, ada jeda singkat atau penantian event di sini.
            -- os.execute("sleep 0.1") -- jangan lakukan ini di kode nyata, ini memblokir!
        end
        print("Semua task selesai.")
    end

    -- Tambahkan beberapa tugas
    scheduler:newTask(function()
        print("Tugas 1: Mulai.")
        scheduler:sleep(1)
        print("Tugas 1: Selesai.")
    end)
    scheduler:newTask(function()
        print("Tugas 2: Mulai.")
        scheduler:sleep(2)
        print("Tugas 2: Selesai.")
    end)

    scheduler:run()
    ```

    **Catatan**: Contoh ini menyederhanakan banyak hal. Scheduler nyata jauh lebih kompleks dan terintegrasi dengan I/O non-blocking dari sistem operasi.

- **Async/await pattern simulation**:

  - **Deskripsi**: Anda bisa membuat fungsi `async` yang membungkus fungsi dalam coroutine dan `await` yang pada dasarnya adalah `yield` yang menunggu hasil.
  - **Contoh Konseptual**:

    ```lua
    -- Membutuhkan scheduler yang lebih canggih yang bisa menangani nilai yield
    local function await(promise)
        -- 'promise' adalah objek yang merepresentasikan hasil di masa depan
        return coroutine.yield(promise)
    end

    local function async(func)
        return function(...)
            -- `scheduler.newTask` perlu dimodifikasi untuk menangani promise
            scheduler:newTask(func, ...)
        end
    end

    -- Penggunaan
    -- local myAsyncFunc = async(function(url)
    --     print("Mengunduh dari", url)
    --     local data = await(http.get(url)) -- http.get mengembalikan 'promise'
    --     print("Data diterima:", #data, "bytes")
    --     return #data
    -- end)
    -- myAsyncFunc("https://google.com")
    ```

    Ini menunjukkan bagaimana sintaksnya bisa terlihat. Implementasi penuhnya memerlukan library async yang matang (seperti `lua-async` atau yang ada di dalam framework seperti OpenResty atau LÖVE).

#### **Sumber Belajar (dari README.md)**:

- [Coroutines and Asynchronous Execution in Lua Programming](https://piembsystech.com/coroutines-and-asynchronous-execution-in-lua-programming/)
- [Implementing Lua Coroutines For Asynchronous File Io](https://peerdh.com/blogs/programming-insights/implementing-lua-coroutines-for-asynchronous-file-io)

---

Kita telah menyelesaikan Bagian 6 yang sangat padat ini. Anda sekarang memiliki pemahaman dasar hingga lanjut tentang coroutine, mulai dari cara kerjanya, pola penggunaannya, hingga aplikasinya dalam pemrograman asinkron. Ini adalah salah satu konsep yang paling membedakan Lua dan membuka pintu untuk pengembangan aplikasi berperforma tinggi, terutama di bidang seperti game dan server jaringan. Selanjutnya adalah **Bagian 7: Performance Optimization**.

### Daftar Isi Pembelajaran

Berikut adalah peta jalan untuk materi yang akan kita bahas. Tautan di bawah ini akan membawa Anda langsung ke bagian yang relevan.

- **Materi yang Telah Dibahas (Ringkasan)**

  - **Bagian 1-5**: Membahas dasar-dasar kontrol alur, perulangan, pola-pola canggih (tabel, fungsional, metatabel), dan penanganan error.
  - **Bagian 6**: Mendalami Coroutine sebagai fitur inti untuk pemrograman konkuren dan asinkron di Lua.

- **Materi Saat Ini: Optimasi Performa**

  - **Bagian 7: Performance Optimization**
    - [7.1 Analisis Performa Kontrol Alur](#71-analisis-performa-kontrol-alur)
    - [7.2 Manajemen Memori dalam Kontrol Alur](#72-manajemen-memori-dalam-kontrol-alur)

---

# 📚 **[Bagian 7: Performance Optimization][7]**

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

### Daftar Isi Pembelajaran

Berikut adalah peta jalan untuk materi yang akan kita bahas. Tautan di bawah ini akan membawa Anda langsung ke bagian yang relevan.

- **Materi yang Telah Dibahas (Ringkasan)**

  - **Bagian 1-6**: Membahas dasar-dasar kontrol alur, perulangan, pola canggih, penanganan error, dan coroutine.
  - **Bagian 7**: Fokus pada optimasi performa melalui analisis CPU dan manajemen memori.

- **Materi Saat Ini: Pola Desain, Aplikasi, dan Framework**

  - **Bagian 8: Design Patterns dan Best Practices**
    - [8.1 Pola Desain Kontrol Alur](#81-pola-desain-kontrol-alur)
    - [8.2 Kualitas dan Keterpeliharaan Kode](#82-kualitas-dan-keterpeliharaan-kode)
  - [**Bagian 9: Domain-Specific Applications**](#-bagian-9-domain-specific-applications)
    - [9.1 Kontrol Alur Pengembangan Game](#91-kontrol-alur-pengembangan-game)
    - [9.2 Kontrol Alur Sistem Tertanam (Embedded)\*\*](#92-kontrol-alur-sistem-tertanam-embedded)
  - [**Bagian 10: Pola Kontrol Alur di Framework Populer (Tambahan)**](#-bagian-10-pola-kontrol-alur-di-framework-populer-tambahan)
    - [10.1 Event Loop di LÖVE 2D](#101-event-loop-di-löve-2d)
    - [10.2 Kontrol Alur Non-Blocking di OpenResty](#102-kontrol-alur-non-blocking-di-openresty)

---

# 📚 **[Bagian 8: Design Patterns dan Best Practices][8]**

Setelah memahami "bagaimana" cara kerja kontrol alur, bagian ini fokus pada "kapan" dan "mengapa" Anda harus menggunakan pola tertentu. Menerapkan pola desain yang tepat dan praktik terbaik akan membuat kode Anda tidak hanya berfungsi, tetapi juga elegan, dapat dipelihara (_maintainable_), dan dapat diskalakan (_scalable_).

### 8.1 Pola Desain Kontrol Alur

**Durasi yang Disarankan:** 4-5 jam

Pola desain adalah solusi umum yang dapat digunakan kembali untuk masalah yang sering terjadi dalam desain perangkat lunak.

#### **Deskripsi Konkret**

Bagian ini secara formal membahas beberapa pola desain yang telah kita singgung sebelumnya, memberikan nama dan struktur pada solusi-solusi tersebut untuk mempermudah komunikasi dan implementasi.

#### **Topik yang Dipelajari**

- **State Pattern Implementation**:

  - **Deskripsi**: Pola ini memungkinkan sebuah objek untuk mengubah perilakunya ketika keadaan internalnya berubah. Objek tampak seolah-olah mengubah kelasnya. Ini adalah formalisasi dari konsep _state machine_ yang telah kita bahas menggunakan tabel atau metatabel. Setiap _state_ dienkapsulasi dalam objeknya sendiri yang memiliki antarmuka (interface) yang sama.
  - **Contoh Konseptual**:

    ```lua
    -- State Interface
    local State = {}
    function State:new(context)
        return setmetatable({ context = context }, { __index = self })
    end
    function State:handle() error("harus diimplementasikan oleh state konkret") end

    -- Concrete States
    local StateA = State:new()
    function StateA:handle()
        print("Menangani di State A. Transisi ke State B.")
        self.context.state = StateB:new(self.context)
    end

    local StateB = State:new()
    function StateB:handle()
        print("Menangani di State B. Transisi ke State A.")
        self.context.state = StateA:new(self.context)
    end

    -- Context (Objek yang memiliki state)
    local Context = {}
    function Context:new()
        local instance = { state = nil }
        instance.state = StateA:new(instance) -- State awal
        return setmetatable(instance, { __index = self })
    end
    function Context:request()
        self.state:handle()
    end

    local context = Context:new()
    context:request() -- Output: Menangani di State A. Transisi ke State B.
    context:request() -- Output: Menangani di State B. Transisi ke State A.
    ```

- **Command Pattern untuk control flow**:

  - **Deskripsi**: Membungkus sebuah permintaan sebagai objek, sehingga memungkinkan Anda untuk memparameterisasi klien dengan permintaan yang berbeda, mengantrekan permintaan, dan mendukung operasi yang dapat dibatalkan. Kita sudah melihat implementasi sederhananya menggunakan tabel fungsi.
  - **Kapan Digunakan**: Berguna untuk sistem _undo/redo_, antrean tugas, atau memisahkan pemanggil perintah dari eksekutornya.

- **Strategy Pattern dengan function dispatch**:

  - **Deskripsi**: Pola ini memungkinkan pemilihan algoritma saat runtime. Anda mendefinisikan keluarga algoritma, membungkus masing-masing, dan membuatnya dapat dipertukarkan. Tabel dispatch fungsi adalah implementasi langsung dari pola ini.
  - **Perbedaan dengan State Pattern**: Fokus _Strategy_ adalah pada algoritma yang dapat dipertukarkan untuk satu tugas tertentu (misalnya, berbagai cara mengurutkan), sedangkan _State_ berfokus pada perubahan perilaku objek secara keseluruhan berdasarkan keadaannya.

- **Observer Pattern untuk event handling**:

  - **Deskripsi**: Mendefinisikan ketergantungan satu-ke-banyak antara objek sehingga ketika satu objek (subjek) mengubah keadaannya, semua dependennya (pengamat/observer) diberitahu dan diperbarui secara otomatis. Ini adalah dasar dari pemrograman berbasis kejadian (_event-driven_).
  - **Contoh Konseptual**:

    ```lua
    -- Subject (yang diamati)
    local Subject = {}
    function Subject:new()
        return { observers = {} }
    end
    function Subject:addObserver(observer)
        self.observers[observer] = observer
    end
    function Subject:notify(event)
        print("Subject: Memberi tahu observer tentang event '" .. event .. "'")
        for obs in pairs(self.observers) do
            obs:onNotify(event)
        end
    end

    -- Observer (yang mengamati)
    local Observer = {}
    function Observer:new(name)
        return { name = name }
    end
    function Observer:onNotify(event)
        print("Observer '" .. self.name .. "': Menerima notifikasi event '" .. event .. "'")
    end

    local subject = Subject:new()
    local observer1 = Observer:new("A")
    local observer2 = Observer:new("B")

    subject:addObserver(observer1)
    subject:addObserver(observer2)

    subject:notify("login")
    ```

#### **Sumber Belajar (dari README.md)**:

- [Lua Design Patterns](http://lua-users.org/wiki/LuaPatterns)
- [Object-Oriented Programming in Lua](http://lua-users.org/wiki/ObjectOrientedProgramming)

---

### 8.2 Kualitas dan Keterpeliharaan Kode

**Durasi yang Disarankan:** 3-4 jam

Menulis kode yang cerdas itu bagus, tetapi menulis kode yang jelas dan mudah dipahami oleh orang lain (dan diri Anda sendiri di masa depan) jauh lebih baik.

#### **Deskripsi Konkret**

Bagian ini membahas prinsip-prinsip untuk menulis kode yang bersih, mudah dibaca, dan mudah dimodifikasi, dengan fokus pada struktur kontrol alur.

#### **Topik yang Dipelajari**

- **Readable control flow structures (Struktur kontrol alur yang mudah dibaca)**:

  - Gunakan nama variabel yang deskriptif untuk kondisi.
  - Pilih struktur yang paling jelas untuk tugas tersebut (`if/else` vs tabel vs `while`).
  - Berikan komentar pada logika yang kompleks.

- **Avoiding deeply nested conditions (Menghindari kondisi bersarang yang dalam)**:

  - Seperti yang dibahas sebelumnya, kondisi bersarang yang dalam (`if...if...if...`) sulit diikuti.
  - Gunakan _guard clauses_ (keluar lebih awal dengan `return` atau `break`) untuk mengurangi level sarang.
  - Pecah menjadi fungsi-fungsi yang lebih kecil.
  - Gunakan tabel dispatch atau pola State jika sesuai.

- **Refactoring complex control logic (Refactoring logika kontrol yang kompleks)**:

  - **Refactoring** adalah proses menstrukturkan ulang kode yang ada—tanpa mengubah perilaku eksternal—untuk meningkatkan desain, keterbacaan, dan keterpeliharaannya.
  - Identifikasi bagian kode yang rumit dan terapkan teknik di atas untuk menyederhanakannya.

- **Documentation best practices (Praktik terbaik dokumentasi)**:

  - Dokumentasikan _mengapa_ kode melakukan sesuatu, bukan hanya _apa_ yang dilakukannya. Komentar `i = i + 1` tidak berguna, tetapi komentar `-- Gunakan goto untuk keluar dari loop bersarang karena flag akan mempersulit logika` sangat membantu.
  - Gunakan alat dokumentasi seperti [LDoc](https://github.com/lunarmodules/ldoc) untuk menghasilkan dokumentasi dari komentar kode Anda.

#### **Sumber Belajar (dari README.md)**:

- [Lua Style Guide](http://lua-users.org/wiki/LuaStyleGuide)
- [Clean Code Principles](https://github.com/ryanmcdermott/clean-code-javascript) (Meskipun untuk JavaScript, prinsip-prinsipnya bersifat universal)

---

# 📚 **[Bagian 9: Domain-Specific Applications][9]**

Bagian ini menerapkan semua konsep yang telah dipelajari ke dalam domain aplikasi tertentu, menunjukkan bagaimana pola kontrol alur yang berbeda lebih cocok untuk masalah yang berbeda.

### 9.1 Kontrol Alur Pengembangan Game

**Durasi yang Disarankan:** 4-5 jam

Pengembangan game sangat bergantung pada kontrol alur untuk mengelola state, input, dan rendering setiap frame.

#### **Topik yang Dipelajari**

- **Game state management (Manajemen state game)**: Menggunakan pola _State_ atau _state machine_ untuk mengelola state game utama (misalnya, menu utama, bermain, jeda, game over).
- **Frame-based execution patterns (Pola eksekusi berbasis frame)**: Konsep _game loop_ (misalnya `love.update(dt)` dan `love.draw()` di LÖVE) adalah bentuk utama dari kontrol alur, di mana logika game diperbarui dan digambar ulang pada setiap frame.
- **Input handling control flow (Kontrol alur penanganan input)**: Menggunakan _Observer pattern_ atau _Command pattern_ untuk memetakan input pemain (keyboard, mouse) ke tindakan dalam game.
- **Animation and timing control (Kontrol animasi dan waktu)**: Menggunakan loop dan _timers_ untuk mengontrol animasi sprite, transisi, dan event berbasis waktu. Coroutine sering digunakan di sini untuk skrip sekuensial yang kompleks (misalnya, cutscene).

#### **Sumber Belajar (dari README.md)**:

- [Lua Coding Tutorial - Complete Guide](https://gamedevacademy.org/lua-coding-tutorial-complete-guide/)
- [LÖVE 2D Documentation](https://love2d.org/wiki/Main_Page)

---

### 9.2 Kontrol Alur Sistem Tertanam (Embedded)

**Durasi yang Disarankan:** 3-4 jam

Sistem tertanam (seperti mikrokontroler) memiliki kendala sumber daya (memori dan CPU terbatas) yang memengaruhi pilihan kontrol alur.

#### **Topik yang Dipelajari**

- **Real-time control patterns (Pola kontrol waktu-nyata)**: Menggunakan loop yang sangat ketat dan terprediksi untuk memastikan respons dalam batas waktu tertentu.
- **Interrupt handling simulation (Simulasi penanganan interupsi)**: Menggunakan _callbacks_ atau _hooks_ untuk merespons event perangkat keras, mirip dengan pola _Observer_.
- **Resource-constrained programming (Pemrograman dengan sumber daya terbatas)**: Menghindari alokasi memori yang sering di dalam loop utama untuk mencegah beban pada GC. Menggunakan kembali objek adalah kunci.
- **Deterministic execution patterns (Pola eksekusi deterministik)**: Menulis kode yang menghasilkan output yang sama persis untuk input yang sama persis, yang penting untuk pengujian dan keandalan. Hindari ketergantungan pada hal-hal yang tidak menentu.

#### **Sumber Belajar (dari README.md)**:

- [Control Flow in Lua - Stack Overflow](https://stackoverflow.com/questions/11191923/control-flow-in-lua)
- [Embedded Lua Programming](http://lua-users.org/wiki/EmbeddedLua)

---

# 📚 **[Bagian 10: Pola Kontrol Alur di Framework Populer (Tambahan)][10]**

Bagian ini ditambahkan untuk menunjukkan bagaimana konsep kontrol alur abstrak (seperti _event loop_ dan _non-blocking I/O_ berbasis coroutine) diwujudkan dalam pustaka dan framework dunia nyata.

### Deskripsi Konkret

Melihat implementasi nyata akan memperkuat pemahaman Anda dan menunjukkan bagaimana teori diterapkan dalam praktik untuk membangun aplikasi berperforma tinggi.

#### **10.1 Event Loop di LÖVE 2D**

- **Deskripsi**: Framework game LÖVE 2D mengimplementasikan _game loop_ klasik, yang merupakan bentuk dari _event loop_. LÖVE menangani loop utama secara internal dan menyediakan fungsi _callback_ yang Anda implementasikan untuk menyisipkan logika Anda.
- **Pola Kontrol Alur**:
  - `love.load()`: Dipanggil sekali saat game dimulai. Digunakan untuk inisialisasi state, memuat aset. Ini adalah **titik masuk** utama.
  - `love.update(dt)`: Dipanggil berulang kali di setiap frame. `dt` (delta time) adalah waktu sejak frame terakhir. Semua pembaruan logika game (pergerakan, fisika, perubahan state) terjadi di sini. Ini adalah **loop utama** untuk logika.
  - `love.draw()`: Dipanggil setelah `update` di setiap frame. Digunakan untuk menggambar semua objek ke layar. Ini adalah **loop utama** untuk rendering.
  - `love.keypressed(key)`, `love.mousepressed(x, y, button)`: Ini adalah _callback_ penangan event. Mereka dipanggil oleh loop internal LÖVE ketika event yang sesuai terjadi. Ini adalah implementasi dari **Observer pattern**.

#### **10.2 Kontrol Alur Non-Blocking di OpenResty**

- **Deskripsi**: OpenResty adalah platform web yang dibangun di atas NGINX dan LuaJIT. Ia menggunakan "cosockets" yang mengimplementasikan I/O non-blocking secara transparan.
- **Pola Kontrol Alur**:

  - **Synchronous-Style Coding**: Pengembang menulis kode I/O (misalnya, koneksi database, panggilan API eksternal) seolah-olah itu sinkron dan memblokir.

    ```lua
    -- Kode di OpenResty
    local http = require "resty.http"
    local httpc = http.new()

    -- Panggilan ini TERLIHAT memblokir, tapi sebenarnya tidak.
    local res, err = httpc:request_uri("http://example.com/")

    if not res then
        ngx.say("gagal: ", err)
        return
    end

    ngx.say(res.body)
    ```

  - **Mekanisme di Balik Layar**: Ketika `httpc:request_uri` dipanggil, ia memulai operasi jaringan non-blocking. Kemudian, ia secara otomatis memanggil `coroutine.yield()` untuk menjeda coroutine saat ini dan mengembalikan kontrol ke scheduler NGINX. Scheduler NGINX dapat menangani ribuan koneksi lain sementara menunggu respons jaringan ini. Ketika respons tiba, scheduler secara otomatis memanggil `coroutine.resume()` pada coroutine yang dijeda dengan data respons, dan eksekusi kode Anda berlanjut dari baris berikutnya seolah-olah tidak ada jeda.
  - **Manfaat**: Ini adalah contoh sempurna dari penerapan coroutine untuk menyederhanakan pemrograman asinkron, seperti yang dibahas di Bagian 6.3.

#### **Sumber Belajar (Tambahan)**:

- [LÖVE 2D Wiki: love](https://love2d.org/wiki/love)
- [OpenResty Getting Started](https://openresty.org/en/getting-started.html)

---

### Daftar Isi Pembelajaran

Berikut adalah peta jalan untuk materi yang akan kita bahas. Tautan di bawah ini akan membawa Anda langsung ke bagian yang relevan.

- **Materi yang Telah Dibahas (Ringkasan)**

  - **Bagian 1-7**: Membahas dasar-dasar, pola lanjutan, penanganan error, coroutine, dan optimasi performa.
  - **Bagian 8-10**: Fokus pada pola desain, aplikasi domain-spesifik, dan contoh implementasi di framework dunia nyata.

- **Materi Saat Ini: Fitur Spesifik, Pola Khusus, dan Pengujian**

  - [**Bagian 11: Kontrol Alur dalam Berbagai Versi Lua**](#-bagian-11-kontrol-alur-dalam-berbagai-versi-lua)
    - [11.1 Fitur Kontrol Alur Spesifik Versi](#111-fitur-kontrol-alur-spesifik-versi)
    - [11.2 Optimasi Spesifik LuaJIT](#112-optimasi-spesifik-luajit)
  - [**Bagian 12: Specialized Control Flow Patterns**](#-bagian-12-specialized-control-flow-patterns)
    - [12.1 Kontrol Alur Berbasis Kejadian (Event-Driven)](#121-kontrol-alur-berbasis-kejadian-event-driven)
    - [12.2 Kontrol Alur Berbasis Kontinuasi (Continuation-Based)](#122-kontrol-alur-berbasis-kontinuasi-continuation-based)
    - [12.3 Kontrol Alur Domain-Specific Language (DSL)](#23-kontrol-alur-domain-specific-language-dsl)
  - [**Bagian 13: Pengujian dan Debugging**](#-bagian-13-pengujian-dan-debugging)
    - [13.1 Pengujian Kontrol Alur](#131-pengujian-kontrol-alur)
    - [13.2 Debugging Kontrol Alur](#132-debugging-kontrol-alur)

---

# 📚 **[Bagian 11: Kontrol Alur dalam Berbagai Versi Lua][11]**

Lua terus berkembang. Meskipun perubahannya cenderung evolusioner daripada revolusioner, beberapa versi memperkenalkan fitur atau mengubah perilaku yang relevan dengan kontrol alur. Memahami ini penting untuk portabilitas dan memanfaatkan fitur terbaru.

### 11.1 Fitur Kontrol Alur Spesifik Versi

**Durasi yang Disarankan:** 3-4 jam

#### **Deskripsi Konkret**

Bagian ini menyoroti perbedaan utama terkait kontrol alur antara versi-versi mayor Lua (5.1, 5.2, 5.3, 5.4), serta pertimbangan kompatibilitasnya.

#### **Topik yang Dipelajari**

- **Lua 5.1 vs 5.2 vs 5.3 vs 5.4 control flow differences**:

  - **Lua 5.1**: Dianggap sebagai "baseline" klasik yang masih banyak digunakan (terutama oleh LuaJIT). Tidak memiliki `goto`.
  - **Lua 5.2**:
    - **`goto` dan Label**: Perubahan terbesar. Memperkenalkan `goto` dan `::label::` yang memungkinkan kontrol alur yang lebih eksplisit untuk kasus-kasus seperti keluar dari loop bersarang atau simulasi `continue`.
    - **Yieldable pcall/xpcall**: `yield` sekarang dapat digunakan di dalam fungsi C yang dipanggil melalui `pcall` atau `xpcall`. Ini sangat meningkatkan kemampuan pemrograman asinkron.
    - `coroutine.running()` tidak lagi ada (digantikan oleh fungsi C API).
  - **Lua 5.3**:
    - **Integer Subtype**: Memperkenalkan tipe data integer 64-bit yang terpisah dari float (double-precision). Ini tidak secara langsung mengubah kontrol alur, tetapi kondisi yang melibatkan angka bisa berperilaku sedikit berbeda terkait pembulatan atau overflow.
    - **Bitwise Operators**: Menambahkan operator bitwise (`&`, `|`, `~`, `<<`, `>>`), memberikan cara baru untuk mengontrol alur berdasarkan flag bit.
  - **Lua 5.4**:

    - **`__close` Metamethod**: Memperkenalkan variabel _to-be-closed_. Variabel yang dideklarasikan dengan `<close>` akan memiliki metamethod `__close` yang dipanggil ketika variabel keluar dari scope. Ini menyediakan cara yang andal dan terstruktur untuk pembersihan sumber daya (_resource cleanup_), mirip dengan `try-with-resources` di Java atau `using` di C\#. Ini adalah tambahan besar untuk kontrol alur terkait error.

      ```lua
      local function createResource(name)
          local res = { name = name }
          setmetatable(res, {
              __close = function(self, has_error)
                  print(string.format("Menutup resource '%s'. Error terjadi: %s", self.name, tostring(has_error)))
              end
          })
          return res
      end

      do
          local res1 <close> = createResource("file_A")
          -- res1 akan ditutup secara otomatis di akhir blok 'do' ini
          print("Menggunakan resource file_A")
      end -- __close dipanggil di sini
      ```

    - **Generational GC**: Mode baru untuk Garbage Collector yang bisa meningkatkan performa dalam beberapa kasus dengan menangani objek berumur pendek secara lebih efisien. Ini bisa mengurangi frekuensi dan durasi jeda GC.

- **Backward compatibility considerations (Pertimbangan kompatibilitas mundur)**:

  - Kode yang ditulis untuk Lua 5.1 umumnya berjalan di versi lebih baru dengan sedikit modifikasi.
  - Kode yang menggunakan fitur lebih baru (`goto`, `__close`, integer 64-bit) tidak akan berjalan di interpreter yang lebih lama.
  - Selalu ketahui versi Lua target Anda saat mengembangkan.

#### **Sumber Belajar (dari README.md)**:

- [Lua 5.4 Reference Manual](https://www.lua.org/manual/5.4/manual.html) (dan manual untuk versi lainnya)
- [Lua 5.1 Reference Manual](https://www.scribd.com/document/93211508/LUA-5-1-Reference-Manual)
- [Lua Version Differences](http://lua-users.org/wiki/LuaVersionComparison)

---

### 11.2 Optimasi Spesifik LuaJIT

**Durasi yang Disarankan:** 2-3 jam

LuaJIT adalah implementasi Lua yang sangat cepat. Ia memiliki fitur dan pertimbangan performa sendiri yang melampaui Lua standar.

#### **Topik yang Dipelajari**

- **JIT compilation impact pada control flow**: Telah dibahas di Bagian 7. Intinya adalah JIT akan mencoba "meluruskan" kode Anda, terutama loop, menjadi kode mesin yang sangat cepat. Hindari pola yang "membingungkan" tracer JIT.
- **NYI (Not Yet Implemented) features**: Beberapa fitur Lua standar (terutama dari 5.2+) tidak diimplementasikan di LuaJIT atau tidak dapat di-JIT. Misalnya, LuaJIT berbasis pada Lua 5.1, tetapi telah mengadopsi beberapa fitur 5.2 seperti `goto`. Selalu periksa dokumentasi LuaJIT.
- **FFI integration dengan control flow (Integrasi FFI dengan kontrol alur)**:
  - **FFI (Foreign Function Interface)**: Fitur unggulan LuaJIT yang memungkinkan Anda memanggil fungsi dari pustaka C (`.dll`, `.so`) langsung dari Lua tanpa perlu menulis kode _binding_ C.
  - **Implikasi**:
    - **Performa**: Panggilan FFI jauh lebih cepat daripada mekanisme C API standar Lua.
    - **Kontrol Alur**: Anda bisa memanggil fungsi C yang memblokir, yang akan menjeda seluruh utas program. Atau, Anda bisa menggunakan FFI untuk berinteraksi dengan API non-blocking dari sistem operasi, lalu mengintegrasikannya dengan scheduler coroutine kustom Anda.
    - **JIT**: Panggilan melalui FFI dapat di-JIT oleh LuaJIT, artinya tracer dapat mengoptimalkan panggilan C tersebut seolah-olah itu adalah bagian dari kode Lua Anda.
    <!-- end list -->
    ```lua
    local ffi = require("ffi")
    -- Mendeklarasikan fungsi puts dari pustaka C standar
    ffi.cdef[[
        int puts(const char *str);
    ]]
    -- Memanggil fungsi C langsung dari Lua
    ffi.C.puts("Halo dari C via FFI!")
    ```
- **Performance profiling LuaJIT control structures**: LuaJIT menyediakan profiler built-in (`-jp`) yang kuat untuk melihat di mana JIT aktif, di mana tracer berhenti, dan di mana waktu dihabiskan. Ini adalah alat yang sangat penting untuk optimasi serius dengan LuaJIT.

#### **Sumber Belajar (dari README.md)**:

- [LuaJIT Performance Guide](http://wiki.luajit.org/Numerical-Computing-Performance-Guide)
- [LuaJIT Extensions](http://luajit.org/extensions.html) (Termasuk dokumentasi FFI)

---

# 📚 **[Bagian 12: Specialized Control Flow Patterns][12]**

Bagian ini membahas pola-pola yang lebih abstrak atau teoretis, yang sering digunakan untuk membangun sistem yang sangat fleksibel atau bahasa khusus domain.

### 12.1 Kontrol Alur Berbasis Kejadian (Event-Driven)

**Durasi yang Disarankan:** 4-5 jam

#### **Deskripsi Konkret**

Ini adalah pendalaman dari pola Observer dan konsep Event Loop. Alur program tidak lagi sekuensial dari atas ke bawah, melainkan ditentukan oleh terjadinya kejadian (event) eksternal atau internal.

#### **Topik yang Dipelajari**

- **Event loop implementation**: Seperti yang dibahas di Bagian 6, ini adalah loop pusat yang menunggu event dan mengirimkannya ke penangan yang tepat.
- **Observer pattern untuk control flow**: Telah dibahas di Bagian 8.
- **Event queue management (Manajemen antrean event)**: Event yang masuk dimasukkan ke dalam antrean. Event loop memproses event dari antrean satu per satu.
- **Callback-based control structures**: Metode paling dasar untuk event handling. Anda meneruskan fungsi (callback) yang akan dipanggil saat event terjadi.
- **Signal-slot patterns**: Varian dari Observer yang lebih terpisah, populer di framework GUI seperti Qt. Sebuah "sinyal" (event) dapat terhubung ke beberapa "slot" (callback).

---

### 12.2 Kontrol Alur Berbasis Kontinuasi (Continuation-Based)

**Durasi yang Disarankan:** 3-4 jam

#### **Deskripsi Konkret**

Ini adalah gaya pemrograman tingkat lanjut di mana fungsi tidak mengembalikan nilai secara langsung. Sebaliknya, mereka mengambil fungsi tambahan sebagai argumen—disebut _kontinuasi_—dan memanggil kontinuasi tersebut dengan hasilnya.

#### **Topik yang Dipelajari**

- **Continuation-passing style (CPS)**:

  - **Deskripsi**: Setiap fungsi diubah untuk mengambil argumen kontinuasi `k`. Alih-alih `return result`, fungsi akan memanggil `k(result)`.
  - **Contoh**:

    ```lua
    -- Gaya Langsung (Direct Style)
    local function tambah(a, b) return a + b end
    local function kuadrat(n) return n * n end
    local hasil = kuadrat(tambah(2, 3)) -- kuadrat(5) -> 25

    -- Gaya CPS (Continuation-Passing Style)
    local function tambah_cps(a, b, k) k(a + b) end
    local function kuadrat_cps(n, k) k(n * n) end

    -- Komposisi dalam CPS
    tambah_cps(2, 3, function(hasilTambah)
        kuadrat_cps(hasilTambah, function(hasilKuadrat)
            -- Ini adalah akhir dari 'call chain'
            print("Hasil CPS:", hasilKuadrat) -- Output: Hasil CPS: 25
        end)
    end)
    ```

  - **Implikasi**: Meskipun terlihat rumit, CPS membuat kontrol alur menjadi sangat eksplisit. Coroutine Lua dapat dianggap sebagai bentuk implementasi kontinuasi yang lebih mudah digunakan (di mana `yield` dan `resume` mengelola kontinuasi secara implisit).

---

### 12.3 Kontrol Alur Domain-Specific Language (DSL)

**Durasi yang Disarankan:** 4-5 jam

#### **Deskripsi Konkret**

Menggunakan fleksibilitas sintaks Lua (misalnya, pemanggilan fungsi tanpa tanda kurung untuk argumen string atau tabel tunggal) untuk menciptakan "bahasa" mini di dalam Lua yang sintaksnya meniru domain masalah, termasuk struktur kontrol alur kustom.

#### **Topik yang Dipelajari**

- **Creating control flow DSLs**:

  - **Contoh**: DSL untuk mendefinisikan resep masakan.

    ```lua
    -- Implementasi fungsi DSL
    function Resep(nama, blokDefinisi)
        print("Resep untuk:", nama)
        blokDefinisi()
    end
    function Langkah(deskripsi) print("- " .. deskripsi) end
    function Jika(kondisi, blokJika)
        if kondisi then blokJika() end
    end

    -- Penggunaan DSL
    local adonanMengembang = true
    Resep "Roti Sederhana" {
        Langkah "Campur tepung dan air.",
        Langkah "Uleni adonan.",
        Jika(adonanMengembang, function()
            Langkah "Kempiskan adonan."
        end),
        Langkah "Panggang selama 30 menit."
    }
    ```

- **Meta-programming untuk control flow**: Menggunakan metatabel untuk menciptakan DSL yang lebih canggih, di mana mengakses field tabel yang tidak ada dapat memicu logika kontrol alur.

---

# 📚 **[Bagian 13: Pengujian dan Debugging][13]**

Menulis kode hanyalah separuh dari pekerjaan. Memastikan kode tersebut benar dan dapat menemukan masalah ketika terjadi error adalah bagian yang sama pentingnya.

### 13.1 Pengujian Kontrol Alur

**Durasi yang Disarankan:** 3-4 jam

#### **Deskripsi Konkret**

Menulis tes otomatis untuk memverifikasi bahwa logika kontrol alur Anda (cabang `if`, loop, state machine) berperilaku seperti yang diharapkan dalam berbagai skenario.

#### **Topik yang Dipelajari**

- **Unit testing untuk control structures**: Menulis tes kecil dan terisolasi untuk setiap fungsi atau modul.
- **Code coverage analysis**: Alat yang mengukur persentase kode Anda yang dieksekusi oleh tes. Tujuannya adalah memastikan semua cabang `if/else` dan kasus loop telah diuji.
- **Edge case testing (Pengujian kasus tepi)**: Menguji skenario ekstrem atau tidak biasa (misalnya, input kosong, angka nol, nilai batas).
- **Framework**: [Busted](https://olivinelabs.com/busted/) dan [LuaUnit](https://github.com/bluebird75/luaunit) adalah framework pengujian populer untuk Lua.

---

### 13.2 Debugging Kontrol Alur

**Durasi yang Disarankan:** 2-3 jam

#### **Deskripsi Konkret**

Teknik dan alat untuk melacak eksekusi program Anda langkah demi langkah, memeriksa variabel, dan mendiagnosis mengapa alur tidak berjalan seperti yang diharapkan.

#### **Topik yang Dipelajari**

- **Debugging tools dan techniques**: Menggunakan pernyataan `print()` adalah cara paling dasar. Debugger yang lebih canggih memungkinkan Anda mengatur _breakpoints_ (titik henti), melangkah melalui kode, dan memeriksa variabel.
- **Tracing execution flow**: Menambahkan log untuk melihat urutan fungsi yang dipanggil dan keputusan yang dibuat.
- **Pustaka dan Alat**:
  - **`debug` library**: Pustaka standar Lua yang menyediakan fungsionalitas introspeksi tingkat rendah (misalnya, `debug.traceback()`).
  - **[MobDebug](https://github.com/pkulchenko/MobDebug)**: Debugger jarak jauh yang populer untuk Lua yang dapat diintegrasikan dengan IDE seperti VS Code.
  - **ZeroBrane Studio**: IDE Lua yang memiliki debugger terintegrasi.

---

Kita telah menyelesaikan semua materi pembelajaran dalam kurikulum. Anda sekarang memiliki panduan komprehensif dari dasar hingga konsep yang sangat canggih tentang kontrol alur di Lua.

### Daftar Isi Pembelajaran

- **Materi yang Telah Dibahas (Ringkasan)**

  - **Bagian 1-13**: Mencakup seluruh spektrum kontrol alur di Lua, mulai dari `if/else` dasar, loop, coroutine, hingga pola desain, optimasi, dan pengujian.

- **Materi Saat Ini: Proyek Akhir dan Penilaian Diri**

  - [**Bagian 14: Proyek Akhir dan Evaluasi**](#-bagian-14-proyek-akhir-dan-evaluasi)
    - [14.1 Proyek Akhir: Mengaplikasikan Pengetahuan](#141-proyek-akhir-mengaplikasikan-pengetahuan)
    - [14.2 Evaluasi dan Refleksi Diri](#142-evaluasi-dan-refleksi-diri)
  - [**Sumber Referensi Tambahan**](#-sumber-referensi-tambahan)
  - [**Checklist Kemahiran**](#-checklist-kemahiran)

---

## 📚 **Bagian 14: Proyek Akhir dan Evaluasi**

Ini adalah tahap di mana Anda beralih dari sekadar mempelajari konsep menjadi benar-benar _menggunakannya_ untuk memecahkan masalah. Proyek akhir adalah kesempatan Anda untuk berkreasi, menghadapi tantangan nyata, dan membuktikan pada diri sendiri bahwa Anda telah menguasai kontrol alur di Lua.

### 14.1 Proyek Akhir: Mengaplikasikan Pengetahuan

**Durasi:** Fleksibel (disarankan 10-20 jam)

#### **Deskripsi Konkret**

Tujuan proyek akhir adalah merancang dan membangun sebuah aplikasi kecil hingga menengah dari awal sampai akhir. Proyek ini harus secara sadar dirancang untuk menerapkan berbagai struktur kontrol alur yang telah Anda pelajari. Ini bukan hanya tentang membuat sesuatu yang berfungsi, tetapi tentang membuat sesuatu dengan desain kontrol alur yang disengaja dan efisien.

---

#### **Ide Proyek**

Pilihlah proyek yang menarik bagi Anda. Minat pribadi akan menjadi motivator terbesar. Berikut adalah beberapa ide yang dikategorikan berdasarkan pola kontrol alur utama yang akan ditekankan:

**A. Berbasis State Machine / Tabel Dispatch**
Proyek-proyek ini sangat baik untuk melatih penggunaan pola **State**, **Command**, dan **Table-Driven Control Flow**.

- **Game Petualangan Teks (Text-Based Adventure Game)**:

  - **Deskripsi**: Buat sebuah dunia di mana pemain dapat bergerak antar ruangan, mengambil item, dan berinteraksi dengan lingkungan menggunakan perintah teks (misalnya, "pergi utara", "ambil kunci").
  - **Kontrol Alur**: Setiap ruangan adalah sebuah _state_. Perintah pemain diproses menggunakan _tabel dispatch_. Inventaris dan interaksi item akan membutuhkan banyak logika kondisional.

- **Turn-Based RPG Sederhana**:

  - **Deskripsi**: Buat sistem pertarungan di mana pemain dan musuh bergiliran menyerang, bertahan, atau menggunakan item.
  - **Kontrol Alur**: Alur pertarungan adalah _state machine_ yang jelas (giliran pemain, giliran musuh, menang, kalah). Aksi pemain dapat dikelola dengan pola **Command**.

- **Simulasi Lalu Lintas**:

  - **Deskripsi**: Buat simulasi persimpangan jalan dengan lampu lalu lintas dan mobil.
  - **Kontrol Alur**: Lampu lalu lintas adalah _state machine_ (`merah` -\> `hijau` -\> `kuning`). Pergerakan mobil diatur oleh loop dan kondisi berdasarkan state lampu lalu lintas.

**B. Berbasis Coroutine / Pemrograman Asinkron**
Proyek-proyek ini akan memaksa Anda untuk berpikir secara asinkron dan mengelola tugas-tugas yang berjalan bersamaan.

- **Web Scraper Sederhana**:

  - **Deskripsi**: Buat program yang mengunduh beberapa halaman web secara bersamaan, mengekstrak informasi tertentu (misalnya, judul atau tautan), dan menyimpannya.
  - **Kontrol Alur**: Setiap unduhan halaman web dijalankan dalam _coroutine_-nya sendiri. Sebuah _scheduler_ sederhana akan mengelola coroutine ini, menggunakan I/O non-blocking (jika Anda menggunakan pustaka seperti `copas` atau `lua-async`).

- **Antrean Tugas (Task Queue Processor)**:

  - **Deskripsi**: Buat sistem di mana tugas-tugas (misalnya, memproses gambar, mengirim email) dapat ditambahkan ke antrean dan dieksekusi oleh beberapa "pekerja" secara bersamaan.
  - **Kontrol Alur**: Gunakan pola **Producer-Consumer**. "Pekerja" adalah _coroutine_ yang mengambil tugas dari antrean dan menjalankannya.

- **Sistem Dialog atau Cutscene Game**:

  - **Deskripsi**: Buat skrip untuk urutan dialog atau cutscene di mana teks muncul, karakter bergerak, ada jeda waktu, lalu berlanjut.
  - **Kontrol Alur**: Seluruh cutscene adalah satu _coroutine_ besar. `yield` digunakan untuk menunggu input pemain, menunggu waktu tertentu, atau menunggu animasi selesai.

**C. Berbasis DSL / Metaprogramming**
Proyek-proyek ini melatih kemampuan Anda untuk "membengkokkan" bahasa Lua sesuai kebutuhan Anda.

- **Parser File Konfigurasi Kustom**:

  - **Deskripsi**: Lua sering digunakan sebagai file konfigurasi. Buat DSL Anda sendiri yang lebih spesifik untuk aplikasi Anda (misalnya, mendefinisikan level game atau perilaku AI) dan tulis parser-nya.
  - **Kontrol Alur**: Anda akan mendefinisikan fungsi-fungsi yang menjadi "keyword" DSL Anda. Alur program saat memuat konfigurasi akan ditentukan oleh struktur file DSL tersebut.

- **Sistem Build/Automasi Sederhana**:

  - **Deskripsi**: Buat skrip seperti `Makefile` atau `Gulpfile` di Lua, di mana Anda dapat mendefinisikan tugas dan ketergantungannya.
  - **Kontrol Alur**: Gunakan tabel dan metatabel untuk mendefinisikan tugas. Alur eksekusi akan melompati tugas yang tidak perlu dijalankan ulang dan menangani dependensi.

---

#### **Langkah-Langkah Pengerjaan**

1.  **Perencanaan dan Desain (30%)**:

    - Pilih ide dan definisikan cakupan (fitur apa saja yang harus ada).
    - Gambarkan diagram alur atau state diagram untuk memvisualisasikan kontrol alur utama.
    - Rancang struktur data yang akan Anda gunakan.
    - Identifikasi di mana Anda akan menerapkan pola-pola spesifik yang telah dipelajari.

2.  **Implementasi (50%)**:

    - Mulai dengan kerangka dasar. Implementasikan loop utama atau state machine inti terlebih dahulu.
    - Terapkan fitur satu per satu.
    - Fokus pada penulisan kode yang bersih dan mudah dibaca. Terapkan praktik terbaik dari Bagian 8.
    - Jangan takut untuk melakukan _refactoring_ jika desain awal Anda ternyata kurang optimal.

3.  **Pengujian dan Debugging (20%)**:

    - Uji setiap fitur saat Anda membuatnya.
    - Tulis beberapa unit test untuk logika yang paling krusial menggunakan Busted atau LuaUnit.
    - Lakukan pengujian kasus tepi (edge cases). Apa yang terjadi jika input salah atau tidak terduga?

4.  **Dokumentasi**:

    - Buat file `README.md` untuk proyek Anda. Jelaskan apa fungsi proyek, bagaimana cara menjalankannya, dan yang terpenting, jelaskan pilihan desain Anda terkait kontrol alur.

---

### 14.2 Evaluasi dan Refleksi Diri

Tujuan dari tahap ini adalah untuk menginternalisasi apa yang telah Anda pelajari dengan meninjau kembali pekerjaan Anda dan mengidentifikasi kekuatan serta kelemahan Anda.

#### **Proses Refleksi**

Setelah proyek selesai, luangkan waktu untuk menjawab pertanyaan-pertanyaan berikut:

1.  **Tinjauan Kode (Code Review)**:

    - Bagian mana dari kode yang paling Anda banggakan? Mengapa?
    - Bagian mana yang paling sulit untuk ditulis atau di-debug? Apa yang membuatnya sulit?
    - Jika Anda memulai proyek ini lagi dari awal, apa yang akan Anda lakukan secara berbeda?
    - Apakah ada penggunaan `goto` yang bisa diganti dengan struktur yang lebih baik? Apakah ada rantai `if/else` yang panjang yang seharusnya menjadi tabel dispatch?

2.  **Penilaian Diri Berdasarkan Checklist**:

    - Jujurlah pada diri sendiri dan tinjau kembali **Checklist Kemahiran** di bawah ini. Beri tanda centang pada poin-poin yang Anda rasa benar-benar sudah dikuasai.

3.  **Identifikasi Kesenjangan (Gap)**:

    - Berdasarkan tinjauan dan checklist, area mana yang masih terasa lemah? Apakah itu coroutine? Metatabel? Optimasi performa?

4.  **Rencana Pembelajaran Selanjutnya**:

    - Buat rencana konkret untuk memperkuat area yang lemah. Mungkin dengan membaca ulang bagian terkait, mencari tutorial tambahan, atau membuat proyek kecil lain yang berfokus pada area tersebut.
    - Pikirkan tentang langkah selanjutnya: Apakah Anda ingin mendalami pengembangan game dengan LÖVE? Tertarik dengan pengembangan web performa tinggi dengan OpenResty? Atau mungkin berkontribusi pada proyek open-source Lua?

---

## 🔗 **Sumber Referensi Tambahan**

Gunakan sumber daya ini secara berkelanjutan untuk memperdalam pengetahuan Anda.

### Dokumentasi Resmi:

- [Lua 5.4 Reference Manual](https://www.lua.org/manual/5.4/manual.html)
- [Programming in Lua (4th Edition)](https://www.lua.org/pil/)

### Komunitas dan Forum:

- [Lua-users Wiki](http://lua-users.org/wiki/)
- [Lua Subreddit](https://www.reddit.com/r/lua/)
- [Stack Overflow Lua Questions](https://stackoverflow.com/questions/tagged/lua)

### Tools dan Library:

- [LuaJIT](https://luajit.org/) - Just-In-Time Compiler
- [LuaRocks](https://luarocks.org/) - Package Manager
- [ZeroBrane Studio](https://studio.zerobrane.com/) - IDE untuk Lua

---

## ✅ **Checklist Kemahiran**

Gunakan checklist ini sebagai alat evaluasi akhir. Anda dianggap telah menguasai kurikulum ini jika Anda dapat dengan percaya diri mengatakan "ya" pada setiap poin berikut:

- \[ ] **Mampu mengimplementasikan semua jenis kontrol alur di Lua dengan lancar** (termasuk `if`, `while`, `for`, `repeat`, `goto`, dan pola-pola berbasis tabel).
- \[ ] **Memahami trade-offs performa** dari berbagai pendekatan (misalnya, kapan tabel dispatch lebih baik daripada `if/else`).
- \[ ] **Mampu menangani error secara tangguh** menggunakan `pcall` dan `xpcall` untuk mencegah program crash.
- \[ ] **Mampu menggunakan coroutines** untuk mengelola tugas-tugas konkuren dan mengimplementasikan pola asinkron.
- \[ ] **Mampu mengoptimalkan kontrol alur untuk performa**, baik dari segi kecepatan CPU maupun penggunaan memori.
- \[ ] **Mampu menerapkan pola desain yang tepat** (State, Command, Observer) untuk membuat kode lebih terstruktur.
- \[ ] **Mampu melakukan debugging dan pengujian** pada logika kontrol alur yang kompleks.
- \[ ] **Mampu memilih struktur kontrol yang paling tepat** untuk setiap situasi, dengan mempertimbangkan keterbacaan, keterpeliharaan, dan performa.

---

Selamat\! Anda telah mencapai akhir dari kurikulum yang intensif ini. Perjalanan untuk menjadi seorang ahli tidak pernah benar-benar berakhir, tetapi dengan menyelesaikan semua tahapan ini, Anda telah membangun fondasi yang luar biasa kuat. Anda kini memiliki pemahaman yang mendalam dan komprehensif tentang jantung dari setiap program—kontrol alur—dalam salah satu bahasa skrip yang paling elegan dan kuat. Teruslah berlatih, teruslah membangun, dan teruslah belajar\!

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[selanjutnya]: ../../function/bagian-1/README.md
[sebelumnya]: ../../variabel/modul/5-specialized-variable-usage/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../README.md
[2]: ../README.md#-bagian-2-loop-structures
[3]: ../README.md#-bagian-3-flow-control-statements
[4]: ../README.md#-bagian-4-advanced-control-flow-patterns
[5]: ../README.md#-bagian-5-error-handling-dan-exception-flow
[6]: ../README.md#-bagian-6-coroutines---advanced-asynchronous-control
[7]: ../README.md#-bagian-7-performance-optimization
[8]: ../README.md#-bagian-8-design-patterns-dan-best-practices
[9]: ../README.md#-bagian-9-domain-specific-applications
[10]: ../README.md#-bagian-10-pola-kontrol-alur-di-framework-populer
[11]: ../README.md#-bagian-11-control-flow-dalam-berbagai-versi-lua
[12]: ../README.md#-bagian-12-specialized-control-flow-patterns
[13]: ../README.md#-bagian-13-control
