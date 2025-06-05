# 📚 **Bagian 3: Flow Control Statements**

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
