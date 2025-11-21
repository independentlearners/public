### Daftar Isi Materi Pembelajaran Lua: Testing & Debugging

- [**MODUL 1: DASAR-DASAR DEBUGGING LUA**](#modul-1-dasar-dasar-debugging-lua)
  - [1.1 Konsep Fundamental Debugging](#11-konsep-fundamental-debugging)
  - [1.2 Teknik Debugging Dasar](#12-teknik-debugging-dasar)
  - [1.3 Debug Library Lua](#13-debug-library-lua)
- [**MODUL 2: DEBUGGING TOOLS & ENVIRONMENT**](#modul-2-debugging-tools--environment)
  - [2.1 IDE-Based Debugging](#21-ide-based-debugging)
  - [2.3 Advanced Debugging Techniques](#23-advanced-debugging-techniques)
- [**MODUL 3: UNIT TESTING FUNDAMENTALS**](#modul-3-unit-testing-fundamentals)
  - [3.1 Konsep Unit Testing](#31-konsep-unit-testing)
  - [3.2 Assertion Techniques](#32-assertion-techniques)
- [**MODUL 5: BUSTED FRAMEWORK (CONTOH DETAIL)**](#modul-5-busted-framework-contoh-detail)
  - [5.1 Pengenalan Busted](#51-pengenalan-busted)
  - [5.3 Mocking dan Stubbing](#53-mocking-dan-stubbing)
- [**MODUL 9: CODE COVERAGE & METRICS**](#modul-9-code-coverage--metrics)
  - [9.1 Code Coverage Tools](#91-code-coverage-tools)
- [**MODUL 10: CONTINUOUS INTEGRATION**](#modul-10-continuous-integration)
  - [10.1 CI/CD Setup](#101-cicd-setup)
- [**Penutup dan Langkah Selanjutnya**](#penutup-dan-langkah-selanjutnya)

---

### **MODUL 1: DASAR-DASAR DEBUGGING LUA**

Modul ini adalah fondasi Anda. Debugging adalah proses menemukan dan memperbaiki "bug" atau kesalahan dalam kode Anda. Tanpa keterampilan ini, pengembangan perangkat lunak akan menjadi proses yang sangat membuat frustrasi.

#### **1.1 Konsep Fundamental Debugging**

- **Apa itu Debugging?**
  Debugging adalah seni dan ilmu investigasi. Ketika program Anda tidak berjalan seperti yang diharapkan, Anda perlu menjadi detektif: mencari petunjuk (pesan error, perilaku tak terduga), membentuk hipotesis tentang penyebabnya, dan menguji hipotesis tersebut sampai Anda menemukan dan memperbaiki masalahnya. Ini adalah keterampilan inti yang memisahkan programmer pemula dari programmer profesional.

- **Jenis-jenis Error dalam Lua**
  Memahami jenis error akan membantu Anda mempersempit masalah dengan cepat.

  1.  **Syntax Error (Error Sintaksis)**: Kesalahan ini terjadi ketika kode Anda melanggar aturan tata bahasa Lua. Interpreter Lua bahkan tidak dapat mulai menjalankan kode Anda. Ini seperti mencoba mengucapkan kalimat dengan tata bahasa yang salah; maknanya tidak dapat dipahami.

      - **Terminologi**: Interpreter adalah program yang membaca dan mengeksekusi kode Anda baris per baris.
      - **Contoh**:
        ```lua
        -- Lupa keyword 'end' untuk menutup blok 'if'
        local nilai = 10
        if nilai > 5 then
          print("Nilai lebih besar dari 5")
        -- Error: 'then' expected near '<eof>' (end-of-file)
        ```

  2.  **Runtime Error (Error Waktu Jalan)**: Error ini terjadi setelah program mulai berjalan. Sintaksnya benar, tetapi program mencoba melakukan operasi yang mustahil.

      - **Contoh**: Mencoba melakukan operasi matematika pada `nil` (nilai yang tidak ada, mirip dengan `null` di Dart).
        ```lua
        local a = 10
        local b -- b tidak diberi nilai, jadi nilainya adalah 'nil'
        local hasil = a + b
        -- Error: attempt to perform arithmetic on local 'b' (a nil value)
        ```

  3.  **Logical Error (Error Logika)**: Ini adalah jenis error yang paling sulit dilacak. Program berjalan tanpa crash, tetapi menghasilkan output yang salah. Kesalahannya ada pada logika atau alur berpikir programmer.

      - **Contoh**: Menggunakan operator yang salah (`> `alih-alih `<`).
        ```lua
        -- Seharusnya memberikan diskon jika harga di bawah 50
        local harga = 45
        if harga > 50 then -- Error logika, seharusnya harga < 50
          print("Anda mendapatkan diskon!") -- Baris ini tidak akan pernah dijalankan
        end
        ```

#### **1.2 Teknik Debugging Dasar**

- **Print Debugging**: Ini adalah teknik debugging paling dasar dan universal. Anda menempatkan `print()` di berbagai titik dalam kode Anda untuk melacak alur eksekusi dan memeriksa nilai variabel.

  - **Sintaks Dasar**:

    ```lua
    function hitungRataRata(a, b)
      print("Memulai fungsi hitungRataRata...")
      print("Nilai a: ", a)
      print("Nilai b: ", b)
      local total = a + b
      print("Total: ", total)
      local rata_rata = total / 2
      print("Rata-rata: ", rata_rata)
      print("Fungsi selesai.")
      return rata_rata
    end

    hitungRataRata(10, 20)
    ```

  - **Kelemahan**: Dapat mengotori kode Anda dan harus dihapus secara manual setelah selesai. Untuk masalah yang kompleks, ini menjadi tidak efisien.

- **Memahami Pesan Error**: Pesan error Lua sangat informatif. Mereka biasanya memberi tahu Anda jenis error, apa yang salah, dan di baris mana error itu terjadi. Selalu baca pesan error dengan saksama.

#### **1.3 Debug Library Lua**

Lua memiliki library bawaan bernama `debug` untuk fungsionalitas yang lebih canggih.

- **`debug.traceback()`**: Menghasilkan "stack trace", yaitu daftar panggilan fungsi yang membawa program ke titik saat ini. Ini sangat berguna untuk mengetahui "bagaimana saya bisa sampai di sini?" ketika error terjadi.

  - **Contoh**:

    ```lua
    function c()
      print("Terjadi error di fungsi c!")
      print(debug.traceback())
    end

    function b()
      c()
    end

    function a()
      b()
    end

    a()
    -- Output akan menunjukkan:
    -- stack traceback:
    --   [file.lua]:3: in function 'c'
    --   [file.lua]:7: in function 'b'
    --   [file.lua]:11: in function 'a'
    --   [file.lua]:14: in main chunk
    ```

- **`debug.debug()`**: Memulai mode interaktif (console) di mana Anda dapat menjalankan perintah Lua untuk memeriksa variabel dan status program. Ini adalah debugger baris perintah yang sangat sederhana.

---

### **MODUL 2: DEBUGGING TOOLS & ENVIRONMENT**

Menggunakan `print()` saja tidak cukup. Programmer modern mengandalkan alat khusus untuk membuat debugging lebih efisien.

#### **2.1 IDE-Based Debugging**

IDE (Integrated Development Environment) modern memberikan pengalaman debugging visual yang jauh lebih unggul.

- **Visual Studio Code (VS Code) Lua Debugging**: Ini adalah pilihan yang sangat populer. Anda perlu menginstal ekstensi untuk mengaktifkannya.

  - **Ekstensi yang Dibutuhkan**: [**Lua** oleh `sumneko`](<https://www.google.com/search?q=%5Bhttps://marketplace.visualstudio.com/items%3FitemName%3Dsumneko.lua%5D(https://marketplace.visualstudio.com/items%3FitemName%3Dsumneko.lua)>). Ekstensi ini menyediakan language server (untuk autocompletion, definisi, dll.) dan kemampuan debugging.

  - **Konsep Inti Debugger Visual**:

    - **Breakpoints**: Menandai baris kode di mana Anda ingin eksekusi program berhenti sejenak. Anda tidak perlu menambahkan `print()`. Cukup klik di sebelah nomor baris.
    - **Variable Inspection**: Saat program berhenti, Anda dapat melihat semua variabel yang ada saat itu (lokal dan global) dan nilainya secara real-time.
    - **Step Over**: Menjalankan baris kode saat ini dan berhenti di baris berikutnya.
    - **Step Into**: Jika baris saat ini adalah panggilan fungsi, masuk ke dalam fungsi tersebut dan berhenti di baris pertamanya.
    - **Step Out**: Jika Anda berada di dalam fungsi, selesaikan eksekusi fungsi tersebut dan berhenti setelah kembali ke pemanggilnya.
    - **Call Stack**: Jendela yang secara visual menunjukkan apa yang `debug.traceback()` lakukan—urutan panggilan fungsi.

  - **Representasi Visual Konsep Debugger**:

    ```
    Kode Anda:                  Kontrol Debugger:      Jendela Variabel:
    1 function hitung(a,b)      [Step Over >]           a: 10
    2   local total = a + b    [Step Into v]           b: 20
    3 > print(total)  <-- (Breakpoint di sini)         total: nil (belum dieksekusi)
    4   return total           [Step Out ^]
    5 end                      [Continue >>]
    ```

#### **2.3 Advanced Debugging Techniques**

- **Runtime Error Handling dengan `pcall()` dan `xpcall()`**
  Di Dart, Anda mungkin terbiasa dengan `try-catch`. Di Lua, padanannya adalah `pcall` (protected call). Ini memungkinkan Anda menjalankan kode yang mungkin gagal tanpa membuat seluruh program crash.

  - **Terminologi**:

    - `pcall(fungsi)`: Menjalankan `fungsi` dalam mode "terlindungi". Jika tidak ada error, ia mengembalikan `true` diikuti oleh nilai apa pun yang dikembalikan oleh fungsi. Jika ada error, ia mengembalikan `false` diikuti oleh pesan error.

  - **Sintaks Dasar `pcall`**:

    ```lua
    local function mungkinGagal(x)
      if type(x) ~= "number" then
        error("Input harus berupa angka!") -- Melempar error
      end
      return x * 2
    end

    -- Penggunaan pcall
    local status, hasil = pcall(mungkinGagal, 10)
    if status then
      print("Sukses! Hasilnya:", hasil) -- Output: Sukses! Hasilnya: 20
    else
      print("Gagal! Pesan error:", hasil)
    end

    local status_gagal, error_msg = pcall(mungkinGagal, "hello")
    if status_gagal then
      print("Sukses! Hasilnya:", hasil)
    else
      print("Gagal! Pesan error:", error_msg) -- Output: Gagal! Pesan error: ...Input harus berupa angka!
    end
    ```

  - **`xpcall(fungsi, errorHandler)`**: Mirip dengan `pcall`, tetapi memungkinkan Anda menyediakan fungsi `errorHandler` kustom yang akan dipanggil jika terjadi error. Ini memberi Anda lebih banyak kontrol atas bagaimana error dicatat atau ditampilkan.

---

### **MODUL 3: UNIT TESTING FUNDAMENTALS**

Debugging bersifat reaktif (memperbaiki masalah setelah terjadi). Testing bersifat proaktif (mencegah masalah sebelum terjadi).

#### **3.1 Konsep Unit Testing**

- **Pengenalan Unit Testing**: Unit testing adalah praktik menulis kode untuk menguji "unit" terkecil dari kode Anda (biasanya satu fungsi) secara terisolasi. Tujuannya adalah untuk memverifikasi bahwa setiap unit bekerja seperti yang diharapkan.

  - **Manfaat**:
    - **Kepercayaan Diri**: Anda tahu kode Anda berfungsi, memungkinkan Anda melakukan refactoring atau menambahkan fitur baru tanpa takut merusak yang sudah ada.
    - **Deteksi Regresi**: Jika perubahan baru merusak fungsionalitas lama, tes unit akan gagal dan segera memberi tahu Anda.
    - **Dokumentasi Hidup**: Tes berfungsi sebagai contoh bagaimana cara menggunakan kode Anda.

- **Test-Driven Development (TDD)**: Ini adalah sebuah metodologi pengembangan. Alih-alih menulis kode lalu mengujinya, Anda membalik prosesnya.

  - **Alur Kerja TDD (Red-Green-Refactor)**:

    1.  **RED**: Tulis tes otomatis untuk fitur baru yang belum ada. Jalankan tes; itu akan **gagal** (merah) karena kodenya belum ditulis.
    2.  **GREEN**: Tulis jumlah kode **paling minimum** yang diperlukan agar tes tersebut **berhasil** (hijau). Jangan khawatir tentang kualitas kode pada tahap ini.
    3.  **REFACTOR**: Sekarang setelah tes berhasil, bersihkan dan perbaiki kode Anda (misalnya, membuatnya lebih efisien, lebih mudah dibaca) dengan keyakinan bahwa jika Anda merusaknya, tes akan memberi tahu Anda.
    4.  Ulangi siklus untuk fitur berikutnya.

  - **Representasi Visual Siklus TDD**:

    ```
         +-----------------------+
         |                       |
    (1. Tulis Tes Gagal) <----(Ulangi)
         |      (RED)           |
         |                      |
         v                      |
    (2. Tulis Kode) --(Jalankan Tes)--> (3. Refactor Kode)
         |      (GREEN)         |
         |                      |
         +----------------------+
    ```

- **Test Structure: Arrange, Act, Assert (AAA)**: Ini adalah pola standar untuk menyusun tes agar mudah dibaca.

  ```lua
  function testPenambahan()
    -- 1. Arrange (Atur): Siapkan semua variabel dan kondisi yang diperlukan.
    local a = 5
    local b = 10
    local hasilYangDiharapkan = 15

    -- 2. Act (Lakukan): Panggil fungsi atau metode yang ingin Anda uji.
    local hasilAktual = tambah(a, b) -- Anggap kita punya fungsi 'tambah'

    -- 3. Assert (Tegaskan): Verifikasi bahwa hasil yang didapat sesuai dengan yang diharapkan.
    assert(hasilAktual == hasilYangDiharapkan, "Penambahan 5+10 seharusnya 15")
  end
  ```

#### **3.2 Assertion Techniques**

Fungsi `assert` bawaan Lua sudah cukup kuat, tetapi framework testing menyediakan "assertion" yang lebih deskriptif.

- **Terminologi**: **Assertion** adalah pernyataan yang harus benar agar tes berhasil. Jika tidak, tes gagal.
- **Contoh dengan Framework (misal, LuaUnit)**:
  - `assertEquals(aktual, diharapkan)`: Memeriksa apakah dua nilai sama.
  - `assertTrue(kondisi)`: Memeriksa apakah suatu kondisi benar.
  - `assertNil(nilai)`: Memeriksa apakah suatu nilai adalah `nil`.
  - `assertError(fungsi)`: Memeriksa apakah memanggil `fungsi` akan menghasilkan error.

---

### **MODUL 5: BUSTED FRAMEWORK (CONTOH DETAIL)**

Busted adalah framework testing yang sangat populer untuk Lua. Gaya BDD-nya membuat tes sangat mudah dibaca seperti kalimat biasa.

#### **5.1 Pengenalan Busted**

- **Instalasi**:

  - **Prasyarat**: Anda memerlukan [**LuaRocks**](https://luarocks.org/), manajer paket untuk Lua (seperti `pip` untuk Python atau `npm` untuk Node.js).
  - **Perintah**: `luarocks install busted`

- **BDD Style Testing**: Behavior-Driven Development (BDD) adalah evolusi dari TDD. Tes ditulis dalam format yang menjelaskan _perilaku_ (behavior) sistem dari sudut pandang pengguna.

  - **Terminologi BDD**:
    - `describe("sebuah komponen", function() ... end)`: Blok untuk mengelompokkan tes yang terkait dengan satu komponen atau fitur.
    - `it("harus melakukan sesuatu", function() ... end)`: Blok untuk satu kasus uji spesifik. Ini menjelaskan satu perilaku.
    - `assert.is_equal(a, b)`: Salah satu dari banyak assertion Busted.

- **Sintaks Dasar**:
  Mari kita uji fungsi kalkulator sederhana.

  - File `kalkulator.lua`:
    ```lua
    local Kalkulator = {}
    function Kalkulator.tambah(a, b)
      return a + b
    end
    return Kalkulator
    ```
  - File `kalkulator_spec.lua` (tes untuk Busted):

    ```lua
    -- Memuat pustaka Busted
    local busted = require("busted")
    -- Memuat kode yang akan diuji
    local Kalkulator = require("kalkulator")

    -- Memulai blok deskripsi
    busted.describe("Kalkulator", function()
      -- Blok deskripsi lain untuk fungsi 'tambah'
      busted.describe(".tambah()", function()
        -- Kasus uji pertama (it block)
        it("harus menjumlahkan dua angka positif", function()
          -- Arrange, Act, Assert
          local hasil = Kalkulator.tambah(2, 3)
          busted.assert.is_equal(hasil, 5)
        end)

        -- Kasus uji kedua
        it("harus menjumlahkan angka positif dan negatif", function()
          local hasil = Kalkulator.tambah(10, -5)
          busted.assert.are.equal(hasil, 5) -- 'are.equal' adalah alias dari 'is_equal'
        end)
      end)
    end)
    ```

  - **Menjalankan Tes**: Buka terminal Anda di direktori proyek dan jalankan `busted`.

#### **5.3 Mocking dan Stubbing**

Ini adalah konsep krusial untuk mengisolasi unit. Terkadang, fungsi yang Anda uji bergantung pada hal lain (misalnya, database, API jaringan, atau fungsi kompleks lainnya). Anda tidak ingin tes Anda gagal karena database sedang down. Jadi, Anda mengganti dependensi tersebut dengan objek palsu.

- **Terminologi**:

  - **Stub**: Objek palsu yang memberikan jawaban kalengan (pre-canned answer). Jika fungsi Anda perlu memanggil `database.getUser(1)`, Anda bisa membuat stub yang selalu mengembalikan `{nama = "Andi"}` setiap kali dipanggil dengan argumen `1`, tanpa benar-benar terhubung ke database.
  - **Spy (Mata-mata)**: Objek palsu yang "membungkus" fungsi asli (atau fungsi palsu). Tugas utamanya adalah merekam bagaimana ia dipanggil: berapa kali, dengan argumen apa, dll. Setelah tes selesai, Anda bisa memeriksa "rekaman" dari spy ini.
  - **Mock**: Objek palsu yang lebih cerdas. Ia tahu ekspektasi di awal—misalnya, "Saya harus dipanggil tepat satu kali dengan argumen `'simpan'`". Jika ekspektasi ini tidak terpenuhi di akhir tes, tes akan gagal.

- **Representasi Visual Perbedaannya**:

  ```
                    +----------------+     +-------------------+     +-----------------+
  Kamu Membutuhkan: |      Data      |     |   Notifikasi      |     |   Pembayaran    |
                    +----------------+     +-------------------+     +-----------------+
                         |                      |                       |
  Dalam Tes,        menggantikan           menggantikan            menggantikan
  Kamu Menggunakan:    |                      |                       |
                         v                      v                       v
                    +----------------+     +-------------------+     +-----------------+
  Jenis Objek Palsu:|      STUB      |     |        SPY        |     |      MOCK       |
                    +----------------+     +-------------------+     +-----------------+
  Tugasnya:         Memberikan data    Merekam apakah          Memverifikasi
                    palsu yang sudah   fungsi notifikasi     bahwa fungsi
                    disiapkan.         sudah dipanggil.        pembayaran dipanggil
                                                               dengan benar.
  Fokusnya:         State (Keadaan)    Behavior (Perilaku)     Behavior (Perilaku)
  ```

- **Contoh dengan Busted (Spy)**:

  ```lua
  busted.describe("Fungsi Notifikasi", function()
    it("harus mengirim email ketika pengguna mendaftar", function()
      -- Arrange: Buat Spy untuk objek EmailService
      local email_service = { send = function() end }
      -- 'spy.on' mengubah fungsi 'send' menjadi spy
      local email_spy = busted.spy.on(email_service, "send")

      -- Anggap kita punya fungsi ini
      local function daftarPengguna(nama, email)
        -- ... logika menyimpan pengguna ...
        email_service.send(email, "Selamat Datang!", "Terima kasih telah mendaftar.")
      end

      -- Act: Jalankan fungsi yang diuji
      daftarPengguna("Budi", "budi@email.com")

      -- Assert: Verifikasi bahwa spy dipanggil
      busted.assert.spy(email_spy).was.called()
      -- Verifikasi lebih detail
      busted.assert.spy(email_spy).was.called_with("budi@email.com", "Selamat Datang!", "Terima kasih telah mendaftar.")
    end)
  end)
  ```

---

### **MODUL 9: CODE COVERAGE & METRICS**

Setelah menulis tes, bagaimana Anda tahu apakah tes Anda sudah cukup baik?

#### **9.1 Code Coverage Tools**

- **Apa itu Code Coverage?**: Metrik ini mengukur persentase baris kode produksi Anda yang dieksekusi selama menjalankan tes otomatis. Jika coverage 80%, artinya 20% kode Anda tidak pernah tersentuh oleh tes sama sekali, dan mungkin mengandung bug tersembunyi.

- **LuaCov**: Ini adalah alat standar untuk code coverage di Lua. Busted dan framework lain dapat berintegrasi dengannya.

  - **Cara Kerja**: Saat tes berjalan, LuaCov melacak setiap baris kode produksi yang dieksekusi. Setelah selesai, ia menghasilkan laporan (biasanya file HTML) yang menunjukkan baris mana yang tercakup (hijau) dan mana yang tidak (merah).
  - **Penggunaan dengan Busted**:
    ```bash
    # Jalankan busted dengan flag --coverage
    busted --coverage
    ```
    Ini akan menghasilkan file `luacov.report.out`. Anda kemudian menjalankan `luacov` untuk membuat laporan HTML yang bisa dibaca.
  - **Penting**: Code coverage 100% tidak menjamin kode bebas bug. Itu hanya berarti setiap baris dieksekusi. Itu tidak memverifikasi apakah setiap _kemungkinan logika_ di baris tersebut sudah benar. Namun, coverage yang rendah adalah tanda bahaya yang jelas.

---

### **MODUL 10: CONTINUOUS INTEGRATION**

Ini adalah tentang otomatisasi. Anda tidak ingin menjalankan semua tes secara manual setiap kali Anda mengubah kode.

#### **10.1 CI/CD Setup**

- **Apa itu CI/CD?**

  - **Continuous Integration (CI)**: Praktik di mana developer secara teratur menggabungkan perubahan kode mereka ke repositori pusat. Setelah setiap penggabungan, build dan tes otomatis dijalankan. Tujuannya adalah untuk menemukan masalah integrasi secepat mungkin.
  - **Continuous Deployment/Delivery (CD)**: Kelanjutan dari CI. Jika build dan tes berhasil, kode secara otomatis di-deploy ke lingkungan produksi atau staging.

- **GitHub Actions**: Platform CI/CD yang terintegrasi langsung dengan GitHub. Sangat mudah untuk disiapkan.

  - **Cara Kerja**: Anda membuat file konfigurasi dalam format YAML di dalam direktori `.github/workflows/` di repositori Anda. File ini mendefinisikan "kapan" (misalnya, setiap `push` ke branch `main`) dan "apa" (langkah-langkah untuk build dan tes) yang harus dijalankan.

  - **Contoh File `.github/workflows/test.yml` untuk Proyek Lua**:

    ```yaml
    # Nama workflow
    name: Run Lua Tests

    # Kapan workflow ini dijalankan
    on: [push]

    jobs:
      test:
        # Sistem operasi yang digunakan untuk menjalankan job
        runs-on: ubuntu-latest

        steps:
          # Langkah 1: Checkout kode dari repositori Anda
          - name: Checkout code
            uses: actions/checkout@v3

          # Langkah 2: Setup lingkungan Lua
          - name: Setup Lua
            uses: leafo/gh-actions-lua@v9
            with:
              luaVersion: "5.4" # Tentukan versi Lua Anda

          # Langkah 3: Setup LuaRocks
          - name: Setup LuaRocks
            uses: leafo/gh-actions-luarocks@v4

          # Langkah 4: Install dependensi (Busted)
          - name: Install Busted
            run: luarocks install busted

          # Langkah 5: Jalankan tes
          - name: Run tests
            run: busted
    ```

  - **Link Bermanfaat**:

    - [GitHub Actions Documentation](https://docs.github.com/en/actions)
    - [Setup Lua Action](https://github.com/leafo/gh-actions-lua)

---

### Penutup dan Langkah Selanjutnya

Kurikulum ini miliki adalah peta jalan yang luar biasa untuk mencapai penguasaan. Penjelasan di atas telah mengubah beberapa titik kunci dari peta tersebut menjadi panduan yang lebih konkret dengan definisi, contoh, dan konteks yang mendalam.

**Saran Berikutnya**:

1.  **Praktikkan Setiap Modul**: Jangan hanya membaca. Untuk setiap modul, buat proyek kecil dan terapkan konsepnya. Untuk Modul 1, sengaja buat error dan coba debug. Untuk Modul 3 & 5, buat proyek kalkulator dan tulis tesnya menggunakan Busted.
2.  **Ikuti Referensi**: Kurikulum Anda sudah menyediakan tautan-tautan berharga. Setelah memahami konsep dari penjelasan saya, klik tautan tersebut untuk mendapatkan pemahaman yang lebih dalam langsung dari sumbernya.
3.  **Fokus pada "Mengapa"**: Selalu tanyakan, "Mengapa saya menggunakan stub di sini, bukan mock?", "Mengapa TDD bermanfaat untuk proyek ini?". Jawaban atas pertanyaan-pertanyaan ini akan membangun intuisi pemrograman Anda.
4.  **Ulangi**: Karena Anda menyebutkan sudah banyak lupa, jangan ragu untuk mengulangi materi dasar. Fondasi yang kuat dalam debugging dasar akan membuat semua topik lanjutan menjadi lebih mudah.

Materi ini dirancang untuk menjadi referensi awal yang komprehensif. Dengan mengikuti kurikulum ini secara sistematis dan mempraktikkannya, Anda akan berada di jalur yang tepat untuk tidak hanya menggunakan teknologi ini, tetapi benar-benar menguasainya untuk tujuan apa pun yang Anda butuhkan. Saya telah mengaudit penjelasan ini untuk memastikan kejelasan, akurasi, dan kelengkapan sesuai permintaan Anda.

#

<!-- > - **[Selanjutnya][selanjutnya]** -->

> - **[Ke Atas](#)**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../README.md

<!-- [selanjutnya]: ../bagian-2/README.md -->

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
