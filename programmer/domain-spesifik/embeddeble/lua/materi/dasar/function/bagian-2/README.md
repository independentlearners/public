# **[Bagian 2: Parameter dan Return Values][1]**

Setelah memahami dasar-dasar function, penting untuk menguasai bagaimana cara mengirimkan informasi ke dalam function (parameter) dan bagaimana function mengembalikan hasil (return values). Lua menawarkan beberapa mekanisme yang fleksibel untuk ini.

### 2.1 Parameter Handling

Bagian ini akan fokus pada berbagai cara function di Lua dapat menerima dan mengelola argumen yang diberikan saat pemanggilan.

#### **Fixed parameters (Parameter Tetap)**

Ini adalah bentuk parameter yang paling dasar dan sudah kita singgung sebelumnya. Function didefinisikan untuk menerima sejumlah parameter yang sudah ditentukan namanya.

- **Konsep Dasar (Review):**

  - Anda mendeklarasikan function dengan sejumlah nama parameter tertentu.
  - Saat function dipanggil, argumen yang diberikan akan di-assign ke parameter tersebut berdasarkan urutannya.
  - Jika argumen yang diberikan lebih sedikit, parameter yang tidak mendapatkan nilai akan menjadi `nil`.
  - Jika argumen lebih banyak, argumen tambahan akan diabaikan (kecuali jika function tersebut juga dirancang untuk menerima argumen variabel, yang akan dibahas selanjutnya).

- **Contoh Kode (Review):**

  ```lua
  local function sapaPengguna(nama, usia)
    -- 'nama' dan 'usia' adalah fixed parameters
    if nama == nil or usia == nil then
      print("Informasi tidak lengkap!")
    else
      print("Halo, " .. nama .. "! Anda berusia " .. usia .. " tahun.")
    end
  end

  sapaPengguna("Andi", 30)    -- Output: Halo, Andi! Anda berusia 30 tahun.
  sapaPengguna("Budi")        -- Output: Informasi tidak lengkap! (karena usia adalah nil)
  sapaPengguna("Citra", 25, "Jakarta") -- Output: Halo, Citra! Anda berusia 25 tahun. ("Jakarta" diabaikan)
  ```

#### **Variable arguments (...) (Argumen Variabel)**

Lua memungkinkan Anda mendefinisikan function yang dapat menerima jumlah argumen yang bervariasi. Ini sangat berguna untuk function seperti `print`, `string.format`, atau ketika Anda ingin membuat function yang fleksibel.

- **Sintaks:**
  Simbol tiga titik (`...`) digunakan dalam daftar parameter untuk menandakan bahwa function tersebut menerima argumen variabel. `...` ini disebut _vararg expression_.

  ```lua
  function namaFunction(...)
      -- Kode untuk mengakses argumen variabel
  end

  -- Bisa juga dikombinasikan dengan fixed parameters
  -- Fixed parameters harus selalu mendahului '...'
  function namaFunctionDenganFixed(param1, param2, ...)
      -- param1 dan param2 akan diisi seperti biasa
      -- sisanya akan masuk ke '...'
  end
  ```

- **Mengakses Argumen Variabel:**
  Di dalam function, ekspresi `...` akan menghasilkan semua argumen variabel sebagai serangkaian nilai. Ada beberapa cara untuk mengaksesnya:

  1.  **Menyimpan ke dalam table (packing):** Cara paling umum adalah mengemas semua argumen variabel ke dalam sebuah table.

      ```lua
      function cetakSemua(...)
        local argumen = {...} -- Mengemas semua argumen variabel ke dalam table 'argumen'
        -- 'argumen' sekarang adalah table biasa yang berisi semua nilai yang dilewatkan
        for i, v in ipairs(argumen) do
          print("Argumen ke-" .. i .. ": " .. tostring(v))
        end
      end

      cetakSemua("halo", 10, true, {kota = "Jogja"})
      -- Output:
      -- Argumen ke-1: halo
      -- Argumen ke-2: 10
      -- Argumen ke-3: true
      -- Argumen ke-4: table: 0x.... (alamat memori table)
      ```

      - `local argumen = {...}`: Tiga titik di dalam `{...}` akan mengumpulkan semua argumen variabel menjadi sebuah table sekuensial (array-like).
      - `ipairs(argumen)`: Iterator yang umum digunakan untuk table sekuensial. `i` adalah indeks numerik, `v` adalah nilainya.

  2.  **Menggunakan `select()`:** Function bawaan `select()` sangat berguna untuk bekerja dengan argumen variabel.

      - `select('#', ...)`: Mengembalikan jumlah total argumen variabel yang dilewatkan.
      - `select(n, ...)`: Mengembalikan argumen variabel mulai dari indeks `n` hingga argumen terakhir.

      ```lua
      function infoArgumen(...)
        local jumlahArg = select('#', ...)
        print("Jumlah argumen diterima: " .. jumlahArg)

        if jumlahArg > 0 then
          local argPertama = select(1, ...)
          print("Argumen pertama: " .. tostring(argPertama))
        end

        if jumlahArg >= 3 then
          print("Argumen ketiga dan seterusnya:")
          -- Melewatkan argumen ke-3 dan seterusnya ke function lain
          -- (atau bisa juga diproses satu per satu dengan loop dan select(i, ...))
          local argKetiga = select(3, ...)
          print(argKetiga) -- Akan mencetak argumen ke-3
          -- Jika ada argumen ke-4, ke-5 dst. mereka juga akan ada di sini
          -- namun print hanya akan efektif menampilkan yang pertama jika tidak di-unpack
          -- atau jika function yang menerima adalah vararg juga.
        end
      end

      infoArgumen("apel", "jeruk", "mangga", "pisang")
      -- Output:
      -- Jumlah argumen diterima: 4
      -- Argumen pertama: apel
      -- Argumen ketiga dan seterusnya:
      -- mangga (print hanya menampilkan yang pertama dari multiple values secara default)

      -- Untuk mencetak semua mulai dari argumen ketiga:
      function cetakMulaiDariKetiga(...)
          local jumlahArg = select('#', ...)
          if jumlahArg >= 3 then
              print("Mulai dari argumen ketiga:")
              for i = 3, jumlahArg do
                  local arg = select(i, ...) -- select(i,...) mengembalikan nilai ke-i hingga akhir
                                             -- tapi karena kita assign ke satu variabel 'arg'
                                             -- 'arg' hanya akan mengambil nilai ke-i.
                                             -- Cara yang lebih baik untuk iterasi adalah packing ke table atau sbb:
                  print(select(i, ...)) -- Ini akan print hanya argumen ke-i, karena select(i,...) mengembalikan
                                        -- arg_i, arg_i+1, ..., arg_n. 'print' akan mengambil yang pertama
                                        -- dari daftar ini (yaitu arg_i) jika tidak dalam konteks multiple assignment
                                        -- atau pemanggilan function vararg lain.
              end

              -- Cara yang lebih idiomatis untuk mencetak semua mulai dari N:
              -- local function cetakSisa(...) print(...) end
              -- cetakSisa(select(3, ...))
          end
      end
      -- Contoh penggunaan select untuk meneruskan varargs:
      function tampilkanSemua(...)
          print(...) -- print adalah vararg function
      end

      function prosesDanTampilkanMulaiN(n, ...)
          local num_varargs = select('#', ...)
          if n <= num_varargs then
              tampilkanSemua(select(n, ...)) -- Melewatkan argumen ke-n dan seterusnya ke tampilkanSemua
          end
      end

      prosesDanTampilkanMulaiN(2, "satu", "dua", "tiga", "empat")
      -- Output: dua	tiga	empat
      ```

      Penggunaan `select` lebih efisien daripada mengemas ke table jika Anda hanya butuh jumlahnya atau beberapa argumen awal, karena tidak ada alokasi table baru.

  3.  **Melewatkan ke function lain:** Anda bisa langsung melewatkan `...` ke function lain yang juga menerima argumen variabel.

      ```lua
      function logger(prefix, ...)
        -- Mengemas argumen variabel ke dalam table untuk diproses
        local args = {...}
        local pesan = prefix .. ": "
        for i, v in ipairs(args) do
          pesan = pesan .. tostring(v)
          if i < #args then
            pesan = pesan .. ", " -- Tambahkan koma antar argumen
          end
        end
        print(pesan)
      end

      function wrapperLogger(...)
        logger("INFO", ...) -- Melewatkan semua argumen variabel dari wrapperLogger ke logger
      end

      wrapperLogger("Transaksi berhasil", "ID_123", 1000)
      -- Output: INFO: Transaksi berhasil, ID_123, 1000
      ```

- **Contoh dengan Fixed dan Variable Arguments:**

  ```lua
  function formatPesan(level, pesanUtama, ...)
    local detail = {...}
    local teksLengkap = "[" .. string.upper(level) .. "] " .. pesanUtama
    if #detail > 0 then
      teksLengkap = teksLengkap .. " | Rincian: " .. table.concat(detail, ", ")
    end
    print(teksLengkap)
  end

  formatPesan("error", "Gagal koneksi ke database")
  -- Output: [ERROR] Gagal koneksi ke database

  formatPesan("warning", "Disk hampir penuh", "Partisi /dev/sda1", "Sisa 5GB")
  -- Output: [WARNING] Disk hampir penuh | Rincian: Partisi /dev/sda1, Sisa 5GB
  ```

  - `string.upper(level)`: Mengubah string `level` menjadi huruf besar.
  - `table.concat(detail, ", ")`: Menggabungkan semua elemen dalam table `detail` menjadi satu string, dengan pemisah ", ".

- **Sumber:**
  - Programming in Lua - [Variable Number of Arguments](https://www.lua.org/pil/5.2.html)
  - Lua Users Wiki - [Variable Arguments](http://lua-users.org/wiki/VarargTheSecondLook)

#### **Default parameter simulation (Simulasi Parameter Default)**

Lua tidak memiliki sintaks bawaan untuk nilai parameter default seperti di Python atau JavaScript. Namun, ini mudah disimulasikan menggunakan operator `or`.

- **Konsep:**
  Operator `or` di Lua mengembalikan operand pertamanya jika operand tersebut bukan `false` dan bukan `nil`. Jika operand pertama `false` atau `nil`, maka `or` akan mengembalikan operand keduanya.
  Kita bisa memanfaatkan ini: jika parameter tidak diberikan (sehingga nilainya `nil`), kita bisa meng-assign nilai default kepadanya.

- **Sintaks/Pola Umum:**

  ```lua
  function namaFunction(param1, param2)
    param1 = param1 or nilai_default_untuk_param1
    param2 = param2 or nilai_default_untuk_param2
    -- ...
  end
  ```

- **Contoh Kode:**

  ```lua
  function buatJendela(judul, lebar, tinggi, warnaLatar)
    judul = judul or "Jendela Baru"
    lebar = lebar or 800
    tinggi = tinggi or 600
    warnaLatar = warnaLatar or "putih"

    print("Membuat jendela:")
    print("  Judul: " .. judul)
    print("  Ukuran: " .. lebar .. "x" .. tinggi)
    print("  Warna Latar: " .. warnaLatar)
  end

  buatJendela("Editor Teks", 1024, 768, "abu-abu")
  -- Output:
  -- Membuat jendela:
  --   Judul: Editor Teks
  --   Ukuran: 1024x768
  --   Warna Latar: abu-abu

  buatJendela("Kalkulator", nil, 400) -- 'nil' untuk lebar agar defaultnya dipakai
  -- Output:
  -- Membuat jendela:
  --   Judul: Kalkulator
  --   Ukuran: 800x400  (lebar menggunakan default 800)
  --   Warna Latar: putih (warnaLatar menggunakan default)

  buatJendela()
  -- Output:
  -- Membuat jendela:
  --   Judul: Jendela Baru
  --   Ukuran: 800x600
  --   Warna Latar: putih
  ```

- **Perhatian:** Jika `false` adalah nilai yang valid untuk parameter Anda, pola `param = param or default` tidak akan bekerja sesuai harapan, karena `false or default` akan menghasilkan `default`. Dalam kasus seperti itu, Anda perlu pemeriksaan yang lebih eksplisit:

  ```lua
  function setFitur(aktif)
    if aktif == nil then
      aktif = true -- Default ke true jika tidak dispesifikkan
    end
    -- Sekarang 'aktif' bisa true, false, atau defaultnya jika tidak diberikan
    if aktif then
      print("Fitur diaktifkan.")
    else
      print("Fitur dinonaktifkan.")
    end
  end

  setFitur(true)  -- Output: Fitur diaktifkan.
  setFitur(false) -- Output: Fitur dinonaktifkan. (false adalah nilai valid)
  setFitur()      -- Output: Fitur diaktifkan. (menggunakan default)
  ```

#### **Named parameters menggunakan tables (Parameter Bernama Menggunakan Table)**

Ketika sebuah function memiliki banyak parameter, terutama jika beberapa bersifat opsional, mengingat urutan yang benar bisa menjadi sulit dan rawan kesalahan. Lua tidak mendukung parameter bernama secara native, tetapi ini bisa diemulasikan dengan sangat baik menggunakan table.

- **Konsep:**
  Alih-alih banyak parameter individual, function hanya menerima satu parameter: sebuah table. Kunci (key) dalam table ini bertindak sebagai nama parameter, dan nilai (value) yang terkait dengan kunci tersebut adalah argumennya.

- **Pola Umum:**

  ```lua
  function namaFunction(opsi)
    -- 'opsi' adalah sebuah table
    local param1 = opsi.namaParam1 or nilaiDefault1
    local param2 = opsi.namaParam2 or nilaiDefault2
    local param3 = opsi.namaParamLain -- Bisa juga tanpa default jika wajib
    -- ...
  end

  -- Pemanggilan:
  namaFunction({
    namaParam1 = nilaiA,
    namaParamLain = nilaiC
    -- namaParam2 tidak diberikan, akan menggunakan default
    -- urutan field dalam table tidak penting
  })
  ```

  Ketika memanggil function dengan argumen table tunggal seperti ini, tanda kurung `()` di sekitar table bersifat opsional. Jadi, `namaFunction{...}` juga valid.

- **Contoh Kode:**

  ```lua
  function buatKarakter(spesifikasi)
    local nama = spesifikasi.nama or "Tanpa Nama"
    local ras = spesifikasi.ras or "Manusia"
    local kelas = spesifikasi.kelas or "Petualang"
    local level = spesifikasi.level or 1
    local senjata = spesifikasi.senjata -- Opsional, bisa nil

    print("Membuat karakter baru:")
    print("  Nama: " .. nama)
    print("  Ras: " .. ras)
    print("  Kelas: " .. kelas)
    print("  Level: " .. level)
    if senjata then
      print("  Senjata: " .. senjata)
    end
    print("--------------------")
  end

  -- Memanggil dengan parameter bernama via table
  buatKarakter({
    nama = "Aragorn",
    ras = "Manusia (Dunedain)",
    kelas = "Ranger",
    level = 87,
    senjata = "Anduril"
  })

  buatKarakter{ -- Tanda kurung opsional untuk table literal tunggal
    nama = "Legolas",
    ras = "Elf",
    senjata = "Busur Galadhrim",
    level = 90
    -- kelas akan menggunakan default "Petualang"
  }

  buatKarakter({ras = "Kurcaci", senjata = "Kapak Perang"})
  -- nama, kelas, level akan menggunakan default
  ```

- **Keuntungan Parameter Bernama via Table:**

  1.  **Keterbacaan:** Pemanggilan function menjadi lebih jelas karena nama parameter eksplisit.
  2.  **Fleksibilitas Urutan:** Urutan field dalam table tidak penting.
  3.  **Mudah Menambah Parameter Baru:** Menambahkan parameter baru ke function tidak akan merusak pemanggilan yang sudah ada (selama parameter baru memiliki nilai default atau ditangani sebagai opsional).
  4.  **Baik untuk Banyak Parameter Opsional:** Sangat cocok ketika function memiliki banyak konfigurasi opsional.

- **Kekurangan:**
  1.  **Sedikit Lebih Verbose:** Penulisan pemanggilan sedikit lebih panjang.
  2.  **Overhead Kecil:** Membuat table untuk setiap pemanggilan memiliki sedikit overhead performa dibandingkan parameter biasa, namun biasanya ini tidak signifikan kecuali function dipanggil sangat sering dalam loop yang ketat.

Pola ini sangat umum di banyak library Lua dan merupakan cara yang baik untuk meningkatkan kejelasan API Anda.

---

### 2.2 Multiple Return Values

Salah satu fitur paling khas dan kuat di Lua adalah kemampuannya untuk mengembalikan lebih dari satu nilai dari sebuah function. Ini memungkinkan pola pemrograman yang efisien dan ekspresif, terutama untuk error handling dan iterasi.

**Daftar Isi Bagian 2.2:**

- [Di Balik `return` dengan Banyak Nilai](#di-balik-return-dengan-banyak-nilai)
- [Menangkap Hasil (Unpacking Return Values)](#menangkap-hasil-unpacking-return-values)
- [Alat Bantu `select()`](#alat-bantu-select)
- [Praktik Terbaik untuk Multiple Returns](#praktik-terbaik-untuk-multiple-returns)

---

#### Di Balik `return` dengan Banyak Nilai

Seperti yang telah kita lihat, sebuah function bisa mengembalikan serangkaian nilai dengan memisahkannya menggunakan koma pada pernyataan `return`.

- **Sintaks:**

  ```lua
  function dapatkanStatusServer()
      local terhubung = true
      local ping = 15 -- dalam milidetik
      local region = "Asia- Tenggara"
      return terhubung, ping, region
  end
  ```

- **Konsep Inti:**
  Ketika sebuah function mengembalikan banyak nilai, ia tidak mengemasnya ke dalam sebuah struktur data seperti table secara otomatis. Sebaliknya, Lua menangani ini sebagai sebuah _list_ atau _urutan_ nilai. Hal ini sangat efisien karena menghindari pembuatan table baru yang tidak perlu, yang bisa menghemat memori dan waktu proses.

- **Contoh Kode:**

  ```lua
  function parseURL(url)
      -- Ini adalah contoh sederhana, bukan implementasi parser URL yang lengkap
      local protokol, host = string.match(url, "(%a+)://([^/]+)")
      if protokol and host then
          return true, protokol, host -- Mengembalikan status sukses dan hasil
      else
          return false, "Format URL tidak valid" -- Mengembalikan status gagal dan pesan error
      end
  end

  local sukses, p, h = parseURL("https://www.lua.org")
  if sukses then
      print("Protokol: " .. p) -- Output: Protokol: https
      print("Host: " .. h)     -- Output: Host: www.lua.org
  end

  local sukses2, pesanError = parseURL("bukan url")
  if not sukses2 then
      print("Gagal: " .. pesanError) -- Output: Gagal: Format URL tidak valid
  end
  ```

  - **`string.match(...)`**: Ini adalah function bawaan Lua yang kuat untuk pencocokan pola (pattern matching). Di sini, ia mencari pola `protokol://host` dan mengembalikan `protokol` dan `host` sebagai dua nilai terpisah jika cocok.
  - Function `parseURL` menggunakan _multiple return values_ untuk secara efisien mengomunikasikan dua hal: apakah operasi berhasil, dan apa hasilnya (data yang valid atau pesan error).

---

#### Menangkap Hasil (Unpacking Return Values)

Cara Anda menangkap nilai kembalian ini sangat bergantung pada konteks pemanggilan function. Lua memiliki aturan spesifik tentang bagaimana _list_ nilai ini "disesuaikan".

- **Aturan Penyesuaian (Adjustment Rule):**

  1.  **Jika pemanggilan function adalah ekspresi terakhir dalam sebuah list ekspresi (misalnya, di sisi kanan dari sebuah assignment),** Lua akan menyesuaikan jumlah nilai kembalian agar sesuai dengan jumlah variabel di sisi kiri.
      - Variabel lebih banyak dari nilai: Variabel ekstra akan diisi `nil`.
      - Variabel lebih sedikit dari nilai: Nilai kembalian ekstra akan dibuang.
  2.  **Jika pemanggilan function _bukan_ ekspresi terakhir,** maka pemanggilan tersebut akan menghasilkan **tepat satu nilai** (nilai kembalian pertamanya).

- **Contoh Aturan Penyesuaian:**

  ```lua
  function f()
    return "a", "b", "c"
  end

  -- Kasus 1: Pemanggilan adalah ekspresi terakhir
  local x, y, z = f() -- x="a", y="b", z="c" (Jumlah pas)
  print(x, y, z)

  local x, y = f()    -- x="a", y="b" ('c' dibuang)
  print(x, y)

  local x, y, z, w = f() -- x="a", y="b", z="c", w=nil (Variabel ekstra diisi nil)
  print(x, y, z, w)

  print(f()) -- "print" adalah vararg, jadi semua nilai dari f() diteruskan. Output: a  b  c

  -- Kasus 2: Pemanggilan BUKAN ekspresi terakhir
  local x = f() -- Hanya nilai pertama yang diambil. x="a"
  print(x)

  local x = f(), "d" -- f() bukan yang terakhir, jadi hanya 'a' yang digunakan.
                     -- Akan terjadi error, karena ini sama seperti 'local x = "a", "d"'
                     -- yang merupakan sintaks assignment yang tidak valid.

  -- Cara yang benar jika ingin menggabungkan:
  local x, y = (f()) -- Tanda kurung memaksa f() hanya menghasilkan satu nilai. x="a", y=nil
  print(x, y)

  print("Hasil:", f()) -- f() bukan argumen terakhir (secara teknis), ia dievaluasi menjadi satu nilai.
                       -- Output: Hasil:	a
  ```

---

#### Alat Bantu `select()`

Function `select` adalah alat bantu yang kuat untuk menangani _list_ nilai, baik dari _varargs_ maupun dari hasil kembalian function lain.

- **`select('#', ...)`**: Mengembalikan jumlah total nilai dalam _list_.

- **`select(n, ...)`**: Mengembalikan semua nilai dari posisi ke-`n` dan seterusnya.

- **Contoh dengan Multiple Returns:**

  ```lua
  function cariData()
      -- Simulasi pencarian data yang bisa menghasilkan banyak atau sedikit data
      if os.time() % 2 == 0 then -- Bergantung pada waktu (detik) genap atau ganjil
          return "user1", "user2", "user3"
      else
          return "admin"
      end
  end

  -- Mendapatkan jumlah hasil tanpa harus menyimpannya ke table
  local jumlahHasil = select('#', cariData())
  print("Jumlah data ditemukan: " .. jumlahHasil)

  -- Mendapatkan hasil kedua dan seterusnya
  local hasilKeduaDanSeterusnya = {select(2, cariData())}
  -- Kita bungkus dengan table agar mudah diinspeksi
  print("Hasil kedua dan seterusnya:")
  for i, v in ipairs(hasilKeduaDanSeterusnya) do
      print(i, v)
  end
  ```

---

#### Praktik Terbaik untuk Multiple Returns

Menggunakan _multiple returns_ secara efektif dapat membuat kode Anda lebih bersih dan efisien.

1.  **Nilai Utama Selalu di Posisi Pertama:**
    Tempatkan nilai kembalian yang paling penting atau paling sering digunakan di posisi pertama. Ini memungkinkan pemanggil untuk dengan mudah menangkap nilai utama saja jika mereka tidak peduli dengan sisanya.

    ```lua
    local file, err = io.open("file.txt", "r") -- 'file' adalah nilai utama
    if not file then
        print("Error:", err)
    end
    ```

2.  **Gunakan untuk Error Handling (Pola `nil`, `errmsg`):**
    Pola paling umum di Lua untuk function yang bisa gagal adalah mengembalikan `nil` diikuti dengan string pesan error. Ini bekerja sangat baik dengan function `assert`.

    ```lua
    function bagi(a, b)
        if b == 0 then
            return nil, "Tidak bisa membagi dengan nol!"
        end
        return a / b
    end

    -- Cara standar:
    local hasil, pesanError = bagi(10, 0)
    if not hasil then
        print("Terjadi kesalahan: " .. pesanError)
    end

    -- Cara idiomatis dengan assert:
    -- assert() akan memeriksa argumen pertamanya. Jika nil atau false, ia akan
    -- memunculkan error dengan pesan dari argumen keduanya.
    local hasil2 = assert(bagi(10, 2))
    print("Hasil 10/2:", hasil2) -- Output: Hasil 10/2: 5.0

    -- baris di bawah ini akan menyebabkan program berhenti dengan error:
    -- print(assert(bagi(10, 0)))
    -- Output: ...: ...: Tidak bisa membagi dengan nol!
    ```

3.  **Jangan Berlebihan:**
    Meskipun bisa, mengembalikan 5 atau 6 nilai bisa membuat kode sulit dibaca. Jika nilai-nilai kembalian membentuk satu kesatuan logis yang kohesif (misalnya, data profil pengguna: nama, usia, email, alamat), seringkali lebih baik mengembalikannya sebagai satu **table**.

4.  **Gunakan untuk Iterator:**
    _Multiple return values_ adalah tulang punggung dari iterator stateless di Lua (seperti `ipairs` dan `pairs`). Mereka secara efisien mengembalikan state berikutnya tanpa perlu membuat table di setiap langkah iterasi. Topik ini akan dibahas mendalam di Bagian 12.

---

**Sumber Referensi untuk 2.2:**

1.  Programming in Lua - [Multiple Results](https://www.lua.org/pil/5.1.html)
2.  Lua Performance Tips - [Multiple Returns](http://lua-users.org/wiki/OptimisationTips)

#

### 2.3 Advanced Parameter Patterns

Bagian ini membahas teknik-teknik untuk menangani skenario parameter yang lebih kompleks, mulai dari meniru fitur bahasa lain hingga memastikan function Anda menerima data yang valid.

**Daftar Isi Bagian 2.3:**

- [Simulasi Function Overloading](#simulasi-function-overloading)
- [Validasi Parameter](#validasi-parameter)
- [Pengecekan Tipe dalam Parameter](#pengecekan-tipe-dalam-parameter)
- [Penanganan Error untuk Parameter Tidak Valid](#penanganan-error-untuk-parameter-tidak-valid)

---

#### Simulasi Function Overloading

_Function overloading_ adalah fitur di beberapa bahasa (seperti C++ atau Java) yang memungkinkan Anda mendefinisikan beberapa function dengan nama yang sama tetapi dengan daftar parameter yang berbeda (berbeda jumlah atau tipe). Lua tidak memiliki fitur ini secara bawaan; jika Anda mendefinisikan dua function dengan nama yang sama, yang kedua akan menimpa yang pertama.

Namun, kita dapat mensimulasikan perilaku ini dengan membuat satu function yang memeriksa tipe atau jumlah argumen yang diterimanya, lalu mengubah perilakunya sesuai dengan itu.

- **Konsep:**
  Buat satu function tunggal. Di dalamnya, gunakan struktur kontrol (`if-then-else`) untuk memeriksa argumen. Function bawaan `type()` adalah alat utama untuk ini.

- **Contoh Kode:**
  Misalkan kita ingin function `tambah` yang bisa menjumlahkan dua angka atau menggabungkan (concatenate) dua string.

  ```lua
  function tambah(a, b)
      -- Periksa tipe argumen pertama
      if type(a) == "number" and type(b) == "number" then
          -- Perilaku 1: Penjumlahan angka
          return a + b
      elseif type(a) == "string" and type(b) == "string" then
          -- Perilaku 2: Penggabungan string
          return a .. b
      else
          -- Perilaku default atau penanganan error
          error("Argumen harus berupa dua angka atau dua string", 2)
      end
  end

  print("Hasil angka:", tambah(10, 5))       -- Output: Hasil angka: 15
  print("Hasil string:", tambah("Halo, ", "Dunia!")) -- Output: Hasil string: Halo, Dunia!
  -- print(tambah(10, "Dunia")) -- Akan memicu error: ...: Argumen harus berupa dua angka atau dua string
  ```

- **Penjelasan Kode:**

  - `type(a) == "number"`: Memeriksa apakah argumen `a` adalah tipe angka.
  - `type(a) == "string"`: Memeriksa apakah `a` adalah tipe string.
  - `error(...)`: Function bawaan untuk memunculkan error dan menghentikan eksekusi jika argumen tidak valid (lebih lanjut di bawah).
    Pola ini memungkinkan satu nama function (`tambah`) untuk memiliki beberapa "perilaku" tergantung pada inputnya, secara efektif mensimulasikan _overloading_.

---

#### Validasi Parameter

Validasi parameter adalah proses memeriksa apakah argumen yang diberikan ke sebuah function memenuhi kriteria tertentu sebelum function melanjutkan eksekusinya. Ini adalah praktik pemrograman defensif yang sangat penting untuk mencegah bug dan error yang tidak terduga.

- **Tujuan Validasi:**

  - **Mencegah Error:** Menghindari error saat runtime yang mungkin terjadi jika function beroperasi pada data yang salah (misalnya, mencoba melakukan operasi matematika pada string).
  - **Memastikan Integritas Data:** Memastikan bahwa data yang diproses oleh function berada dalam keadaan yang diharapkan.
  - **Memberikan Umpan Balik yang Jelas:** Memberi tahu pengguna function (programmer lain atau diri Anda di masa depan) dengan jelas jika mereka menggunakan function tersebut secara salah.

- **Apa yang Divalidasi:**

  - **Keberadaan (Existence):** Memastikan parameter yang wajib diisi tidak `nil`.
  - **Tipe (Type):** Memastikan parameter memiliki tipe data yang benar (misal, `number`, `string`, `table`).
  - **Rentang (Range):** Untuk angka, memastikan nilainya berada dalam rentang yang valid (misal, persentase harus antara 0 dan 100).
  - **Format:** Untuk string, memastikan formatnya sesuai (misal, alamat email harus mengandung '@').

- **Contoh Kode:**

  ```lua
  function setTingkatKecerahan(level)
      -- Validasi Tipe
      if type(level) ~= "number" then
          error("Tingkat kecerahan harus berupa angka.", 2)
      end

      -- Validasi Rentang
      if level < 0 or level > 100 then
          error("Tingkat kecerahan harus antara 0 dan 100.", 2)
      end

      print("Tingkat kecerahan diatur ke: " .. level .. "%")
      -- Lanjutkan logika untuk mengatur kecerahan...
  end

  setTingkatKecerahan(75)  -- Valid
  -- setTingkatKecerahan("tinggi") -- Error: Tingkat kecerahan harus berupa angka.
  -- setTingkatKecerahan(110)    -- Error: Tingkat kecerahan harus antara 0 dan 100.
  ```

---

#### Pengecekan Tipe dalam Parameter

Seperti yang ditunjukkan di atas, alat fundamental untuk validasi di Lua adalah function bawaan `type()`.

- **Function `type()`:**
  `type()` menerima satu argumen dan mengembalikan sebuah string yang merepresentasikan tipe dari argumen tersebut. Kemungkinan nilai kembaliannya adalah: `"nil"`, `"number"`, `"string"`, `"boolean"`, `"table"`, `"function"`, `"thread"`, dan `"userdata"`.

- **Pola Penggunaan:**
  Pola `if type(param) ~= "tipe_yang_diharapkan" then ... end` adalah cara standar untuk menjaga function Anda.

  ```lua
  function prosesDataPengguna(data)
      -- Memastikan 'data' adalah sebuah table
      if type(data) ~= "table" then
          return nil, "Input harus berupa table"
      end

      -- Memastikan field wajib ada dan bertipe benar
      if type(data.id) ~= "number" then
          return nil, "Field 'id' wajib ada dan harus berupa angka"
      end
      if type(data.nama) ~= "string" then
          return nil, "Field 'nama' wajib ada dan harus berupa string"
      end

      print("Memproses pengguna #" .. data.id .. ": " .. data.nama)
      return true -- Mengindikasikan sukses
  end

  prosesDataPengguna({ id = 123, nama = "Alex" })
  prosesDataPengguna({ id = 456 }) -- Akan gagal validasi 'nama'
  ```

  Dalam contoh ini, kita menggunakan pendekatan "sopan" dengan mengembalikan `nil` dan pesan error, bukan menghentikan program.

---

#### Penanganan Error untuk Parameter Tidak Valid

Ketika validasi parameter gagal, Anda memiliki dua pilihan utama tentang bagaimana melaporkan kegagalan tersebut.

1.  **Pendekatan Sopan (Returning `nil` + `errmsg`):**
    Function mengembalikan `nil` sebagai nilai kembalian utama, diikuti dengan string yang menjelaskan errornya.

    - **Kapan digunakan:** Cocok untuk kesalahan yang bisa diprediksi atau "diharapkan" terjadi saat runtime (misal, input pengguna yang salah, file tidak ditemukan). Ini memberi pemanggil kesempatan untuk menangani error tersebut dengan anggun tanpa menghentikan seluruh program.
    - **Contoh:** Seperti pada function `prosesDataPengguna` di atas.

2.  **Pendekatan Tegas (Raising an Error):**
    Function secara paksa menghentikan eksekusi dan memunculkan pesan error. Ini menandakan adanya _bug_ atau kesalahan pemrograman yang harus diperbaiki, bukan sekadar input yang salah. Lua menyediakan dua function utama untuk ini: `error()` dan `assert()`.

    - **`error(message, level)`**

      - Menghentikan eksekusi dan menampilkan `message` sebagai pesan error.
      - Argumen `level` (opsional) menentukan di mana error dilaporkan dalam tumpukan pemanggilan (call stack). `level=1` (default) menunjuk ke baris tempat `error()` dipanggil. `level=2` menunjuk ke baris tempat function yang memanggil `error()` dipanggil. Menggunakan `level=2` seringkali lebih berguna untuk menunjuk ke "sumber" masalah di kode pemanggil.

    - **`assert(condition, message)`**

      - Merupakan function yang sangat berguna untuk melakukan _assertion_ (pernyataan).
      - Ia memeriksa apakah `condition`-nya `true` (atau nilai apapun selain `false` dan `nil`).
      - Jika kondisi terpenuhi, `assert` akan mengembalikan semua argumennya mulai dari `condition` itu sendiri. Ini memungkinkan Anda untuk membungkus pemanggilan function: `local result = assert(bisaGagal())`. Jika `bisaGagal()` mengembalikan `nil`, `assert` gagal. Jika mengembalikan nilai lain, `assert` akan mengembalikan nilai tersebut.
      - Jika kondisi `false` atau `nil`, `assert` akan memanggil `error(message)`, yang akan menghentikan program. Pesan default-nya adalah "assertion failed\!" jika `message` tidak diberikan.
      - `assert` adalah cara yang ringkas dan idiomatis untuk menyatakan bahwa suatu kondisi _harus_ benar pada titik tersebut dalam program.

<!-- end list -->

- **Contoh Perbandingan:**

  ```lua
  -- Menggunakan assert untuk validasi yang tegas
  function setKonfigurasi(config)
      assert(type(config) == "table", "Konfigurasi harus berupa table")
      assert(type(config.port) == "number", "config.port harus berupa angka")

      print("Port diatur ke:", config.port)
  end

  setKonfigurasi({ port = 8080 })

  -- Baris di bawah ini akan menghentikan program dengan pesan error yang jelas
  -- setKonfigurasi({ port = "port-salah" })
  -- Output: ...: ...: config.port harus berupa angka
  ```

  Memilih antara mengembalikan `nil` atau memunculkan `error` adalah keputusan desain penting. Gunakan `error`/`assert` untuk kesalahan pemrograman (prekondisi yang dilanggar) dan kembalikan `nil, errmsg` untuk kegagalan operasional yang bisa dipulihkan.

---

**Sumber Referensi untuk 2.3:**

1.  Lua Users Wiki - [Function Overloading](http://lua-users.org/wiki/FunctionOverloading)
2.  Programming in Lua (4th Edition) - [8.1 Assert and Error](https://www.lua.org/pil/8.1.html)

Kita telah menyelesaikan Bagian 2 secara keseluruhan, mencakup berbagai cara menangani parameter dan nilai kembalian, dari yang dasar hingga pola-pola yang lebih canggih. Berikutnya, kita akan memasuki **Bagian 3: Function Types dan Styles**, di mana kita akan menjelajahi berbagai "rasa" function, seperti function anonim, higher-order functions, dan rekursi.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][2]**
> - **[Sebelumnya][3]**
> - **[Kurikulum][4]**
> - **[Domain Spesifik][5]**

[5]: ../../../../../../README.md
[4]: ../../../../README.md
[3]: ../bagian-1/README.md
[2]: ../bagian-3/README.md
[1]: ../README.md/#bagian-2-parameter-dan-return-values
