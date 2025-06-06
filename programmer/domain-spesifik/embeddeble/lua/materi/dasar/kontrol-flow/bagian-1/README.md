# 📚 **[Bagian 1: Fundamental Control Flow][0]**

Bagian ini adalah fondasi dari bagaimana sebuah program membuat keputusan dan mengulang tugas. Tanpa pemahaman yang kuat di sini, akan sulit untuk membangun logika program yang kompleks.

### 1.1 Pernyataan Kondisional (Conditional Statements)

**Durasi yang Disarankan:** 3-4 jam

Pernyataan kondisional memungkinkan program Anda untuk menjalankan blok kode tertentu hanya jika kondisi tertentu terpenuhi. Ini adalah cara program "membuat keputusan".

#### **Deskripsi Konkret**
Pernyataan kondisional mengevaluasi sebuah ekspresi (kondisi). Jika kondisi tersebut bernilai "benar" (truthy), maka satu blok kode akan dieksekusi. Jika "salah" (falsy), blok kode tersebut akan dilewati, atau blok kode alternatif (jika ada) yang akan dieksekusi.

#### **Terminologi dan Konsep Mendasar**

* **Kondisi (Condition)**: Sebuah ekspresi yang dievaluasi menjadi nilai boolean (benar atau salah) atau nilai yang dianggap "truthy" atau "falsy" oleh Lua.
* **Truthiness di Lua**: Di Lua, ada dua nilai yang dianggap "salah" (falsy): `false` dan `nil`. Semua nilai lainnya (termasuk angka 0, string kosong `""`, dan tabel kosong `{}`) dianggap "benar" (truthy). Ini adalah poin penting yang sering membingungkan pemrogram dari bahasa lain.
* **Blok Kode (Code Block)**: Sekumpulan satu atau lebih pernyataan yang dieksekusi bersama-sama. Dalam Lua, blok kode untuk `if`, `elseif`, dan `else` diakhiri dengan `end`.
* **Operator Perbandingan**: Digunakan untuk membandingkan dua nilai.
    * `==` (sama dengan)
    * `~=` (tidak sama dengan) – Perhatikan ini bukan `!=` seperti di banyak bahasa lain.
    * `<` (kurang dari)
    * `>` (lebih dari)
    * `<=` (kurang dari atau sama dengan)
    * `>=` (lebih dari atau sama dengan)
* **Operator Logika**: Digunakan untuk mengkombinasikan beberapa kondisi.
    * `and`: Menghasilkan `true` jika kedua operan `true`. Jika operan pertama `false` atau `nil`, ia mengembalikan operan pertama tersebut tanpa mengevaluasi operan kedua. Jika tidak, ia mengembalikan operan kedua.
    * `or`: Menghasilkan `true` jika salah satu operan `true`. Jika operan pertama bukan `false` dan bukan `nil`, ia mengembalikan operan pertama tersebut tanpa mengevaluasi operan kedua. Jika tidak, ia mengembalikan operan kedua.
    * `not`: Membalik nilai boolean dari operannya. `not true` adalah `false`, `not false` adalah `true`. `not nil` juga `true`. `not <nilai_truthy_selain_true>` adalah `false`.

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

* **Statement `if`, `else`, `elseif`**:
    * **Deskripsi**: Ini adalah struktur dasar untuk pengambilan keputusan. `if` memulai kondisi, `elseif` menyediakan kondisi alternatif jika sebelumnya salah, dan `else` menangani kasus di mana semua kondisi sebelumnya salah.
    * **Penggunaan**: Gunakan `if` untuk kondisi tunggal. Tambahkan `else` untuk alternatif jika kondisi tidak terpenuhi. Gunakan `elseif` untuk memeriksa beberapa kondisi secara eksklusif.
    * **Contoh (Gabungan)**:
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

* **Operator perbandingan dan logika**:
    * **Deskripsi**: Operator ini adalah "alat" yang Anda gunakan untuk membangun kondisi dalam pernyataan `if`.
        * **Perbandingan**: `==`, `~=`, `<`, `>`, `<=`, `>=`. Perhatikan bahwa perbandingan string bersifat leksikografis (berdasarkan urutan karakter). Perbandingan tabel, fungsi, userdata, dan thread dilakukan berdasarkan referensi (dua tabel hanya `==` jika mereka adalah objek yang sama persis di memori).
        * **Logika**: `and`, `or`, `not`.
            * `and` dan `or` menggunakan *short-circuit evaluation*. Artinya, jika hasil ekspresi sudah bisa ditentukan dari operan pertama, operan kedua tidak akan dievaluasi. Ini penting untuk diketahui karena bisa memengaruhi performa dan juga bisa digunakan untuk trik tertentu (misalnya, `local x = a and b` akan memberi `x` nilai `a` jika `a` falsy, atau `b` jika `a` truthy).
            * `not` selalu mengembalikan `true` atau `false`.
    * **Contoh (Operator Logika dengan Short-Circuit)**:
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

* **Evaluasi kondisi truthiness di Lua**:
    * **Deskripsi**: Seperti yang disebutkan, hanya `false` dan `nil` yang dianggap "salah" (falsy). Semua nilai lain (angka 0, string kosong `""`, tabel kosong `{}`) adalah "benar" (truthy).
    * **Implikasi**: Ini berbeda dari banyak bahasa lain (misalnya JavaScript atau Python) di mana 0 atau string kosong bisa jadi falsy. Kesalahan dalam memahami ini bisa menyebabkan bug yang sulit dideteksi.
    * **Contoh (Perbandingan dengan bahasa lain)**:
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

* **Nested conditionals (Kondisional Bersarang)**:
    * **Deskripsi**: Anda dapat menempatkan satu pernyataan `if` di dalam blok kode pernyataan `if` atau `else` lainnya.
    * **Penggunaan**: Berguna untuk logika yang lebih kompleks di mana satu keputusan bergantung pada keputusan lain.
    * **Perhatian**: Terlalu banyak level kondisional bersarang dapat membuat kode sulit dibaca dan dipelihara. Pertimbangkan untuk merefaktor (menyusun ulang) kode jika nesting menjadi terlalu dalam (misalnya, menggunakan fungsi, guard clauses, atau tabel lookup).
    * **Contoh**:
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
    * **Alternatif untuk Nested (Guard Clause Pattern)**: Daripada `if A then if B then ... end end`, Anda bisa menggunakan "guard clause" untuk keluar lebih awal jika kondisi tidak terpenuhi.
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

* **Pattern matching sederhana**:
    * **Deskripsi**: Dalam konteks `if/elseif`, ini merujuk pada penggunaan serangkaian `elseif` untuk mencocokkan nilai variabel dengan beberapa kemungkinan nilai literal (konstan). Ini adalah bentuk paling dasar dari "pencocokan pola".
    * **Penggunaan**: Ketika Anda memiliki satu variabel dan ingin melakukan tindakan berbeda berdasarkan beberapa nilai spesifiknya.
    * **Contoh**:
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
        Ini adalah pendahulu dari teknik *switch-case* yang akan dibahas selanjutnya, yang sering diimplementasikan menggunakan tabel di Lua.

#### **Penjelasan Mendalam Tambahan**
* **Keterbacaan**: Usahakan agar kondisi Anda mudah dibaca. Jika kondisi menjadi terlalu panjang atau kompleks, pertimbangkan untuk memecahnya menjadi variabel boolean sementara atau fungsi.
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
* **Hindari Redundansi**: Jangan mengulang evaluasi yang sama.
* **Urutan `elseif`**: Urutan `elseif` penting jika beberapa kondisi bisa `true` untuk nilai input yang sama. Lua akan menjalankan blok kode dari kondisi pertama yang `true` dan mengabaikan sisanya.

#### **Sumber Belajar (dari README.md)**:
* [Control Structures in Lua: If, Else, and Switch](https://coderscratchpad.com/control-structures-in-lua-if-else-and-switch/)
* [Lua-users Wiki: Control Structure Tutorial](http://lua-users.org/wiki/ControlStructureTutorial)
* [Programming in Lua: Control Structures](https://www.lua.org/pil/4.3.html)

---

### 1.2 Implementasi Switch-Case Pattern

**Durasi yang Disarankan:** 2-3 jam

Lua tidak memiliki pernyataan `switch` atau `case` bawaan seperti bahasa C, Java, atau JavaScript. Namun, pola ini dapat dengan mudah disimulasikan menggunakan tabel dan fungsi, yang seringkali lebih fleksibel.

#### **Deskripsi Konkret**
Pola *switch-case* memungkinkan Anda memilih satu blok kode untuk dieksekusi dari beberapa pilihan berdasarkan nilai sebuah ekspresi. Di Lua, ini biasanya dicapai dengan menggunakan tabel di mana *key* adalah "kasus" (case) dan *value* adalah fungsi yang akan dieksekusi atau hasil langsung.

#### **Terminologi dan Konsep Mendasar**

* **Tabel (Table)**: Struktur data fundamental di Lua, mirip dengan array asosiatif atau kamus (dictionary). Tabel bisa berisi pasangan kunci-nilai.
* **Dispatch Table**: Tabel yang digunakan untuk "mengirim" (dispatch) eksekusi ke fungsi yang sesuai berdasarkan suatu kunci.
* **Function as First-Class Citizen**: Di Lua, fungsi adalah nilai seperti halnya angka atau string. Mereka dapat disimpan dalam variabel, dilewatkan sebagai argumen ke fungsi lain, dikembalikan dari fungsi, dan disimpan dalam tabel. Ini adalah kunci untuk implementasi switch-case yang elegan.

#### **Topik yang Dipelajari (Sesuai Kurikulum dan Penjelasan Tambahan)**

* **Menggunakan table untuk simulasi switch-case**:
    * **Deskripsi**: Cara paling umum adalah membuat tabel di mana kunci-kuncinya adalah nilai yang ingin Anda cocokkan, dan nilai-nilainya adalah fungsi yang akan dieksekusi ketika kunci tersebut cocok.
    * **Sintaks Dasar dan Contoh Kode**:
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
    * **Penjelasan Mendalam**:
        * **Default Case**: Anda bisa menangani kasus "default" (jika tidak ada kunci yang cocok) dengan pemeriksaan `if actionToExecute then ... else ... end` seperti di atas, atau dengan metatable (akan dibahas nanti di kurikulum). Cara sederhana lain adalah dengan fungsi default:
            ```lua
            local function handleDefault()
                print("Perintah tidak diketahui.")
            end

            local command = "foo"
            local actionToExecute = actions[command] or handleDefault
            actionToExecute() -- Output "Perintah tidak diketahui."
            ```
        * **Nilai Langsung**: Tidak selalu harus fungsi. Nilai dalam tabel bisa berupa data apa pun.
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

* **Function dispatch patterns**:
    * **Deskripsi**: Ini adalah istilah yang lebih umum untuk pola di mana Anda menggunakan suatu nilai (seperti string perintah) untuk menentukan fungsi mana yang akan dipanggil. Simulasi switch-case menggunakan tabel fungsi adalah salah satu bentuk function dispatch.
    * **Manfaat**: Membuat kode lebih modular, mudah diperluas (cukup tambahkan entri baru ke tabel), dan seringkali lebih mudah dibaca daripada rantai `if/elseif` yang panjang.

* **Conditional table lookups**:
    * **Deskripsi**: Ini mengacu pada proses pengambilan nilai dari tabel berdasarkan suatu kondisi atau variabel, dan kemudian bertindak berdasarkan nilai yang ditemukan (atau tidak ditemukan).
    * **Contoh**: `actions[command]` adalah lookup. Kemudian Anda secara kondisional memanggilnya jika tidak `nil`.

* **Performance considerations (Pertimbangan Performa)**:
    * **Deskripsi**: Untuk sejumlah kecil kasus, rantai `if/elseif` mungkin sedikit lebih cepat karena overhead pembuatan tabel dan lookup. Namun, untuk jumlah kasus yang lebih besar, lookup tabel (yang dioptimalkan dengan baik di Lua, biasanya mendekati O(1) untuk hash part) bisa lebih cepat dan lebih terukur daripada serangkaian perbandingan string linear dalam `elseif`.
    * **Kapan Menggunakan**:
        * **`if/elseif`**: Cocok untuk 2-5 kasus, terutama jika urutan evaluasi penting atau kondisinya kompleks dan bukan sekadar perbandingan kesetaraan.
        * **Table Dispatch**: Sangat baik untuk banyak kasus (>5-10), di mana setiap kasus adalah pencocokan nilai sederhana. Meningkatkan keterbacaan dan kemudahan pemeliharaan secara signifikan.
    * **Penting**: Kecuali ini adalah bagian kode yang sangat kritis performa dan Anda telah melakukan *profiling* (pengukuran performa), pilihlah pendekatan yang paling mudah dibaca dan dipelihara. Premature optimization is the root of all evil.

#### **Penjelasan Mendalam Tambahan**
* **Fleksibilitas**: Tabel dispatch bisa lebih dari sekadar mencocokkan string. Kunci bisa berupa angka atau tipe data lain (meskipun string dan angka adalah yang paling umum).
* **Struktur Kode**: Pola ini membantu memisahkan logika "pemilihan" dari logika "aksi", yang merupakan prinsip desain yang baik.
* **Kasus dengan Fall-through**: Pola `switch` tradisional di beberapa bahasa memiliki "fall-through" (jika tidak ada `break`, eksekusi berlanjut ke kasus berikutnya). Ini tidak secara alami terjadi dengan pola tabel fungsi Lua, yang biasanya lebih aman dan kurang rentan error. Jika fall-through benar-benar dibutuhkan (jarang), Anda harus mengimplementasikannya secara eksplisit dalam fungsi yang dipanggil.

#### **Sumber Belajar (dari README.md)**:
* [Control Structures in Lua: If, Else, and Switch](https://coderscratchpad.com/control-structures-in-lua-if-else-and-switch/) (Meskipun judul menyebutkan switch, artikel ini kemungkinan besar membahas simulasi karena Lua tidak memiliki switch bawaan)
* [Lua-users Wiki: Switch Statement](http://lua-users.org/wiki/SwitchStatement) (Halaman ini pasti akan menjelaskan berbagai cara untuk menyimulasikan switch di Lua)

---

Ini adalah penjelasan untuk Bagian 1 dari kurikulum. Kita telah membahas pernyataan kondisional dasar dan bagaimana menyimulasikan pola switch-case di Lua. Fondasi ini sangat penting.
*"2.4 Tipe String - _Deep String Mechanics_"**. Siap untuk melanjutkan?

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[selanjutnya]: ../bagian-2/README.md

<!----------------------------------------------------->

[0]: ../README.md
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
