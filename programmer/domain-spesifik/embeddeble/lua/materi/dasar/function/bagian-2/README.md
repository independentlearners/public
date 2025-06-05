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
  - Programming in Lua - Variable Number of Arguments: [https://www.lua.org/pil/5.2.html](https://www.lua.org/pil/5.2.html)
  - Lua Users Wiki - Variable Arguments: [http://lua-users.org/wiki/VarargTheSecondLook](http://lua-users.org/wiki/VarargTheSecondLook)

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

Kita sudah menyelesaikan sub-bagian 2.1 mengenai berbagai cara menangani parameter. Selanjutnya, kita akan masuk ke "2.2 Multiple Return Values" untuk melihat lebih detail bagaimana function di Lua dapat mengembalikan banyak hasil.

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
