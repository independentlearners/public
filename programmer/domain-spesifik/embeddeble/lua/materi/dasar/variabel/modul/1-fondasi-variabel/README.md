# **[Modul 1: Fondasi Variabel (Minggu 1)][1]**

Modul ini bertujuan untuk membangun pemahaman dasar Anda tentang variabel dalam Lua, mulai dari konsep paling mendasar hingga karakteristik unik Lua dan tipe data yang tersedia.

### 1.1 Pengenalan Variabel di Lua

Bagian ini mengenalkan Anda pada apa itu variabel dalam konteks Lua, bagaimana menamakannya, dan beberapa sifat fundamental dari variabel di Lua.

#### **Konsep Dasar (2 jam)**

- **Definisi dan Fungsi Variabel**

  - **Deskripsi Konkret**: Variabel adalah nama simbolis yang merepresentasikan atau merujuk ke sebuah nilai yang disimpan dalam memori komputer, kita tidak akan pernah tau dimana komputer itu menyimpannya. Jadi anggap saja variabel sebagai sebuah "wadah" atau "label" yang bisa Anda gunakan untuk menyimpan dan mengambil data. Fungsi utamanya adalah untuk menyimpan informasi yang dapat digunakan dan dimanipulasi selama program berjalan.
  - **Terminologi & Konsep**:
    - **Identifier**: kalimat atau nama yang Anda berikan untuk sebuah variabel (misalnya, `umur`, `namaPengguna`).
    - **Nilai (Value)**: Data aktual yang disimpan dalam variabel (misalnya, `25`, `"Alice"`).
    - **Memori (Memory)**: Tempat dalam sistem komputer di mana nilai tersebut disimpan. Variabel memberi kita cara yang mudah untuk merujuk ke lokasi memori ini.
    - **Assignment (Penugasan)**: Proses memberikan nilai ke sebuah variabel.
  - **Sintaks Dasar**: Di Lua, penugasan dilakukan menggunakan tanda **_sama-dengan_** (`=`).
    ```lua
    namaVariabel = nilai
    ```
  - **Contoh Kode**:

    ```lua
    -- Mendefinisikan variabel dan memberinya nilai
    nama = "Budi"  -- Variabel 'nama' menyimpan string "Budi"
    umur = 30      -- Variabel 'umur' menyimpan angka 30
    sudahMenikah = false -- Variabel 'sudahMenikah' menyimpan boolean false

    -- Menggunakan variabel
    print(nama)  -- Output: Budi
    print(umur)  -- Output: 30
    ```

- **Perbedaan Variabel dengan Konstanta**

  - **Deskripsi Konkret**: Variabel, sesuai namanya, nilainya dapat berubah (mutable) selama eksekusi program. Konstanta, di sisi lain, adalah identifier yang nilainya ditetapkan sekali dan idealnya tidak boleh berubah.
  - **Terminologi & Konsep**:
    - **Mutable**: Dapat diubah nilainya setelah didefinisikan.
    - **Immutable**: Tidak dapat diubah nilainya setelah didefinisikan.
  - **Detail Lua**: Lua secara bawaan tidak memiliki kata kunci `const` atau mekanisme enforce konstanta seperti di beberapa bahasa lain (misalnya, `const` di JavaScript atau `final` di Dart). Variabel di Lua pada dasarnya bersifat mutable.
  - **Konvensi untuk Konstanta**: Oleh karenanya para Programmer Lua sering menggunakan konvensi penamaan untuk menandakan sifat dari sebuah variabel ketika diperlakukan sebagai konstanta, maka mereka menggunakan huruf kapital, hal semacam ini sering disebut sebagai "SCREAMING_SNAKE_CASE" atau "UPPER_CASE_WITH_UNDERSCORES" (bukan snake_case atau camelCase).

    ```lua
    NAMA_APLIKASI = "Kalkulator Super"
    PI = 3.14159
    VERSITERBAIK = "1.0.2"

    -- Secara teknis, nilainya masih bisa diubah:
    -- PI = 3.14 -- Ini diizinkan oleh Lua, tapi melanggar konvensi
    ```

  - **Simulasi Konstanta (Tingkat Lanjut)**: Nantinya, dalam modul yang lebih lanjut (seperti metatables), Anda akan belajar cara untuk membuat tabel yang field-nya berperilaku seolah-olah read-only, memberikan proteksi lebih untuk nilai yang dimaksudkan sebagai konstanta.

- **Variable Naming Conventions di Lua**

  - **Deskripsi Konkret**: Karena secara default variabel di lua bersifat global atau dinamis serta tidak adanya sebuah tipe data yang menunjukan sifat akan suatu variabel maka terdapat sebuah aturan dan praktik umum yang dilakukan oleh para programmer saat memberi nama pada sebuah variabel untuk meningkatkan keterbacaan dan pemeliharaan kode dimana ini sangat berguna untuk mengidentifikasi sifat dari sebuah variabel di lua. Aturan-aturan lainnya juga berlaku untuk menghindari perbedaan antara variabel dengan kata kunci atau kode pada bahasa dimana bagian ini adalah sebuah bagian wajib 
  - **Aturan Dasar Lua**:
    1.  Nama variabel bisa terdiri dari huruf, angka, dan garis bawah (`_`). _**Opsional | Bast-Practice**_
    2.  Nama variabel tidak boleh dimulai dengan angka. **_Wajib_**
    3.  Nama variabel bersifat case-sensitive (lihat poin berikutnya).
    4.  Nama variabel tidak boleh sama dengan reserved words (kata kunci Lua).
  - **Konvensi Umum (Praktik Terbaik)**:
    - **`snake_case`**: Kata-kata dipisahkan oleh garis bawah, dan semuanya menggunakan huruf kecil. Ini sangat umum untuk variabel lokal.
      ```lua
      jumlah_item = 10
      nama_pengguna_aktif = "admin"
      ```
    - **`camelCase`**: Kata pertama huruf kecil, kata berikutnya diawali huruf kapital. Kurang umum untuk variabel lokal di Lua dibandingkan `snake_case`, tapi kadang digunakan, terutama jika mengikuti gaya dari C API atau library tertentu.
      ```lua
      jumlahItem = 10
      namaPenggunaAktif = "admin"
      ```
    - **`PascalCase` (atau `UpperCamelCase`)**: Setiap kata diawali huruf kapital. Sering digunakan untuk "kelas" atau modul (tabel yang berperan sebagai namespace atau blueprint objek).
      ```lua
      UserModule = {}
      GameSettings = {}
      ```
    - **`UPPER_SNAKE_CASE`**: Semua huruf kapital, dipisahkan garis bawah. Seperti dibahas sebelumnya, ini sering digunakan untuk menandakan bahwa sebuah variabel tersebut didefinisikan sebagai konstanta.
      ```lua
      MAX_CONNECTIONS = 100
      DEFAULT_TIMEOUT = 5000
      ```
    - **Deskriptif**: Pilih nama yang jelas mendeskripsikan tujuan atau isi variabel. Hindari nama yang terlalu pendek dan ambigu seperti `x`, `y`, `a`, `b` kecuali dalam konteks yang sangat terbatas (misalnya, variabel loop sementara atau koordinat).
  - **Konsistensi**: Pilih satu gaya penamaan (misalnya, `snake_case` untuk variabel lokal) dan gunakan secara konsisten di seluruh proyek Anda.

- **Case Sensitivity dan Reserved Words**

  - **Deskripsi Konkret**:
    - **Case Sensitivity**: Lua membedakan antara huruf besar dan huruf kecil dalam nama variabel dan kata kunci. Artinya, `namaVariabel`, `NamaVariabel`, dan `namavariabel` dianggap sebagai tiga variabel yang berbeda.
    - **Reserved Words (Kata Kunci)**: Ini adalah kata-kata yang memiliki makna khusus dalam bahasa Lua dan tidak dapat digunakan sebagai nama variabel, fungsi, atau identifier lainnya.
  - **Contoh Case Sensitivity**:

    ```lua
    myVariable = 10
    myvariable = 20
    MyVariable = 30

    print(myVariable) -- Output: 10
    print(myvariable) -- Output: 20
    print(MyVariable) -- Output: 30
    ```

  - **Reserved Words Lua (Contoh umum, daftar bisa sedikit berbeda antar versi Lua, namun ini yang inti)**:
    `and`, `break`, `do`, `else`, `elseif`, `end`, `false`, `for`, `function`, `goto`, `if`, `in`, `local`, `nil`, `not`, `or`, `repeat`, `return`, `then`, `true`, `until`, `while`
    Anda tidak bisa menamai variabel seperti ini:
    ```lua
    -- Ini akan menyebabkan error
    -- local = 10 -- Error: 'local' adalah reserved word
    -- if = true  -- Error: 'if' adalah reserved word
    ```

- **Unicode Support dalam Nama Variabel**

  - **Deskripsi Konkret**: Lua modern (terutama Lua 5.3 dan setelahnya) memiliki dukungan yang lebih baik untuk UTF-8. Ini berarti Anda berpotensi menggunakan karakter Unicode (seperti aksara non-Latin, emoji, dll.) dalam string dan komentar. Untuk nama variabel, dukungan bisa bergantung pada versi Lua dan bagaimana source code Anda diinterpretasikan.
  - **Konsep**:
    - **UTF-8**: Skema pengkodean karakter variabel-lebar yang umum digunakan untuk merepresentasikan Unicode.
  - **Detail Lua**:
    - Secara tradisional, identifier di Lua lebih aman jika menggunakan karakter ASCII (huruf a-z, A-Z, angka 0-9, dan underscore).
    - Lua 5.3+ secara resmi mendukung UTF-8, termasuk dalam library string untuk manipulasi karakter UTF-8. Namun, penggunaan karakter Unicode non-ASCII dalam nama variabel mungkin masih kurang portabel atau dapat menyebabkan masalah dengan beberapa tools atau editor.
  - **Rekomendasi Praktis**: Meskipun mungkin secara teknis bisa di beberapa setup, untuk portabilitas dan keterbacaan maksimum oleh tim yang beragam, umumnya disarankan untuk tetap menggunakan karakter ASCII untuk nama variabel dalam proyek kolaboratif atau yang ditujukan untuk distribusi luas.
  - **Contoh (Potensial, tergantung environment)**:

    ```lua
    -- Mungkin bekerja di Lua 5.3+ dengan setup yang benar
    -- local π = 3.14159
    -- local namaPengguna = "Joko"
    -- print(π)

    -- Lebih aman dan portabel:
    local pi_value = 3.14159
    local namaPengguna = "Joko"
    print(pi_value)
    ```

#### **Karakteristik Unik Lua (2 jam)**

Bagian ini membahas fitur-fitur yang membuat Lua menonjol atau berbeda dari banyak bahasa pemrograman lain.

- **Dynamic Typing System**

  - **Deskripsi Konkret**: Dalam sistem tipe dinamis, tipe data sebuah variabel tidak ditentukan pada saat deklarasi, melainkan ditentukan pada saat runtime berdasarkan nilai yang ditugaskan padanya. Variabel yang sama dapat menyimpan tipe data yang berbeda pada waktu yang berbeda selama eksekusi program.
  - **Terminologi & Konsep**:
    - **Static Typing**: Tipe variabel harus dideklarasikan saat kode ditulis dan diperiksa saat kompilasi (contoh: Java, C++, Dart dengan sound null safety).
    - **Dynamic Typing**: Tipe variabel diperiksa saat runtime. Lua, Python, JavaScript adalah contoh bahasa dengan tipe dinamis.
  - **Implikasi di Lua**:
    - Fleksibilitas: Anda tidak perlu mendeklarasikan tipe variabel.
    - Satu variabel bisa menyimpan tipe berbeda:
  - **Sintaks Dasar & Contoh Kode**:

    ```lua
    myData = 10          -- myData sekarang adalah number
    print(type(myData))  -- Output: number

    myData = "Halo Lua"  -- myData sekarang adalah string
    print(type(myData))  -- Output: string

    myData = true        -- myData sekarang adalah boolean
    print(type(myData))  -- Output: boolean
    ```

    Ini berbeda dengan Dart (terutama dengan sound null safety) di mana Anda biasanya mendeklarasikan tipe: `int count = 10; String name = "Dart";` dan `count = "hello";` akan menjadi error.

- **No Variable Declarations Required**

  - **Deskripsi Konkret**: Di Lua, Anda dapat mulai menggunakan variabel hanya dengan menugaskan nilai padanya. Tidak ada keharusan untuk "mendeklarasikan" variabel dengan kata kunci khusus sebelum penggunaan pertamanya, _kecuali_ jika Anda ingin membuatnya menjadi variabel lokal.
  - **Terminologi & Konsep**:
    - **Deklarasi (Declaration)**: Memberitahu kompiler/interpreter tentang keberadaan variabel dan namanya (dan tipenya di bahasa statis).
    - **Definisi (Definition)**: Selain mendeklarasikan, juga mengalokasikan memori untuk variabel (dan bisa juga menginisialisasi dengan nilai).
    - **Global Variable**: Variabel yang dapat diakses dari mana saja dalam program.
    - **Local Variable**: Variabel yang cakupannya (scope) terbatas pada blok atau fungsi tempat ia didefinisikan.
  - **Detail Lua**:
    - Jika Anda menugaskan nilai ke nama variabel baru tanpa kata kunci `local`, Lua akan membuat variabel **global** secara default.
      ```lua
      -- Ini membuat variabel global bernama 'pesanGlobal'
      pesanGlobal = "Ini adalah variabel global"
      ```
    - Penggunaan variabel global yang tidak disengaja bisa menjadi sumber bug yang sulit dilacak karena nilainya bisa diubah dari bagian mana pun dalam kode.
    - Untuk membuat variabel **lokal**, Anda _harus_ menggunakan kata kunci `local`. Ini adalah praktik terbaik di Lua untuk membatasi cakupan variabel.
      ```lua
      local pesanLokal = "Ini adalah variabel lokal"
      ```
      Konsep `local` dan cakupan variabel (scope) akan dibahas lebih detail di Modul 3. Namun, penting untuk diketahui sejak awal bahwa `local` adalah kata kunci penting untuk manajemen variabel yang baik.
  - **Sintaks Dasar & Contoh Kode**:

    ```lua
    -- Variabel global (implisit)
    x = 10
    y = "hello"

    function cekGlobal()
        print(x) -- Bisa diakses karena global
        z = 30   -- Ini juga membuat 'z' menjadi global jika belum ada 'local z'
    end

    cekGlobal()
    print(z) -- Output: 30 (karena 'z' dibuat global di dalam fungsi)

    -- Variabel lokal (eksplisit)
    local a = 100
    local b = "world"

    function cekLokal()
        local c = 200 -- 'c' hanya ada di dalam fungsi ini
        print(a)      -- Bisa diakses karena 'a' ada di scope luar fungsi ini (lexical scoping)
        -- print(x)   -- 'x' juga bisa diakses
    end

    cekLokal()
    -- print(c) -- Error: 'c' adalah variabel lokal di 'cekLokal' dan tidak dikenal di sini
    ```

- **Automatic Memory Management**

  - **Deskripsi Konkret**: Lua mengelola alokasi dan dealokasi memori secara otomatis menggunakan mekanisme yang disebut Garbage Collector (GC). Anda sebagai programmer tidak perlu secara manual mengalokasikan memori saat membuat variabel atau membebaskan memori saat variabel tidak lagi digunakan.
  - **Terminologi & Konsep**:
    - **Memory Allocation**: Proses memesan ruang di memori komputer untuk menyimpan data.
    - **Memory Deallocation**: Proses melepaskan ruang memori yang telah dipesan agar bisa digunakan kembali.
    - **Garbage Collector (GC)**: Program atau proses di latar belakang yang secara otomatis mengidentifikasi dan membebaskan memori yang tidak lagi dapat dijangkau atau digunakan oleh program.
    - **Memory Leak**: Situasi di mana memori yang seharusnya sudah tidak terpakai tidak berhasil dibebaskan oleh GC, menyebabkan penggunaan memori program terus meningkat.
  - **Detail Lua**:
    - GC di Lua biasanya bekerja secara incremental dan menggunakan algoritma seperti mark-and-sweep.
    - Anda tidak perlu khawatir tentang `malloc` dan `free` seperti di C untuk data Lua.
    - Meskipun otomatis, pemahaman tentang bagaimana GC bekerja bisa membantu dalam menulis kode yang lebih efisien dan menghindari memory leak (misalnya, dengan tidak menyimpan referensi yang tidak perlu ke objek besar). Topik ini akan dibahas lebih lanjut di Modul 3 dan 4.
  - **Implikasi**: Menyederhanakan pengembangan karena programmer tidak dibebani manajemen memori manual yang rentan error.

- **First-Class Values Concept**

  - **Deskripsi Konkret**: Di Lua, beberapa tipe data, terutama fungsi, diperlakukan sebagai "first-class citizens". Ini berarti mereka dapat diperlakukan seperti nilai lainnya: disimpan dalam variabel, diteruskan sebagai argumen ke fungsi lain, dikembalikan sebagai hasil dari fungsi, dan disimpan dalam tabel.
  - **Terminologi & Konsep**:
    - **First-Class Citizen (dalam konteks bahasa pemrograman)**: Entitas yang mendukung semua operasi yang umumnya tersedia untuk entitas lain, seperti:
      1.  Dapat ditugaskan ke variabel.
      2.  Dapat diteruskan sebagai argumen.
      3.  Dapat dikembalikan dari fungsi.
      4.  Dapat disimpan dalam struktur data (seperti tabel di Lua).
  - **Detail Lua**:
    - **Fungsi**: Adalah contoh paling kuat dari first-class values di Lua. Ini memungkinkan pola pemrograman fungsional yang kuat.
    - **Tabel**: Juga merupakan first-class values.
    - **Threads (Coroutines)**: Juga first-class values.
  - **Sintaks Dasar & Contoh Kode (Fungsi sebagai First-Class Value)**:

    ```lua
    -- 1. Fungsi ditugaskan ke variabel
    local sapa = function(nama)
        print("Halo, " .. nama .. "!")
    end

    sapa("Dunia") -- Output: Halo, Dunia!

    -- 2. Fungsi diteruskan sebagai argumen
    local function operasikan(a, b, func)
        return func(a, b)
    end

    local tambah = function(x, y) return x + y end
    local kali = function(x, y) return x * y end

    hasilTambah = operasikan(5, 3, tambah)
    hasilKali = operasikan(5, 3, kali)

    print(hasilTambah) -- Output: 8
    print(hasilKali)   -- Output: 15

    -- 3. Fungsi dikembalikan dari fungsi lain (factory function)
    local function pembuatSapaan(awalan)
        return function(nama)
            print(awalan .. ", " .. nama .. "!")
        end
    end

    local sapaPagi = pembuatSapaan("Selamat Pagi")
    local sapaMalam = pembuatSapaan("Selamat Malam")

    sapaPagi("Ani")   -- Output: Selamat Pagi, Ani!
    sapaMalam("Budi") -- Output: Selamat Malam, Budi!

    -- 4. Fungsi disimpan dalam tabel
    local operasiMatematika = {
        tambah = tambah,
        kurang = function(x,y) return x-y end
    }
    print(operasiMatematika.tambah(10,2)) -- Output: 12
    print(operasiMatematika.kurang(10,2)) -- Output: 8
    ```

    Konsep ini sangat penting dan akan dieksplorasi lebih lanjut, terutama saat membahas closures dan modul.

- **Nil sebagai Default Value**

  - **Deskripsi Konkret**: Di Lua, `nil` adalah tipe data khusus yang merepresentasikan "tidak ada nilai" atau "absensi nilai". Variabel yang belum pernah ditugaskan nilai (variabel global yang belum diinisialisasi) secara otomatis memiliki nilai `nil`. `nil` juga digunakan untuk "menghapus" entri dari tabel global (dan dengan demikian, variabel global).
  - **Terminologi & Konsep**:
    - **`nil`**: Tipe data dan juga satu-satunya nilai dari tipe tersebut. Berbeda dengan `0` (angka nol) atau `""` (string kosong).
    - **Truthy dan Falsy**: Dalam konteks kondisional (seperti dalam `if`), `nil` dan `false` adalah satu-satunya nilai yang dianggap "falsy" (salah). Semua nilai lain (termasuk `0` dan string kosong `""`) dianggap "truthy" (benar).
  - **Detail Lua**:
    - Mengecek apakah variabel ada atau memiliki nilai seringkali dilakukan dengan membandingkannya dengan `nil`.
    - Menugaskan `nil` ke variabel global secara efektif menghapusnya dari environment global, memungkinkan garbage collector untuk mengklaim memori jika tidak ada referensi lain.
  - **Sintaks Dasar & Contoh Kode**:

    ```lua
    local a -- Variabel lokal 'a' dideklarasikan tapi tidak diinisialisasi, nilainya nil
    print(a)      -- Output: nil
    print(type(a))-- Output: nil

    local b = nil -- Secara eksplisit menugaskan nil
    print(b)      -- Output: nil

    -- Variabel global 'c' belum pernah ada, jadi jika diakses, nilainya nil
    print(c)      -- Output: nil (tidak error, hanya nil)
    print(type(c))-- Output: nil

    -- Menggunakan nil dalam kondisional
    if a == nil then
        print("Variabel 'a' adalah nil") -- Akan tercetak
    end

    -- Semua nilai selain false dan nil adalah truthy
    if 0 then print("0 adalah truthy") end         -- Akan tercetak
    if "" then print("String kosong adalah truthy") end -- Akan tercetak
    if {} then print("Tabel kosong adalah truthy") end -- Akan tercetak
    if not nil then print("not nil adalah truthy") end -- Akan tercetak
    if not false then print("not false adalah truthy") end -- Akan tercetak


    -- Menghapus variabel global (entri dari tabel _G)
    myGlobalVar = 100
    print(myGlobalVar) -- Output: 100

    myGlobalVar = nil  -- "Menghapus" myGlobalVar
    print(myGlobalVar) -- Output: nil
    ```

#### **Praktik Dasar (3 jam)**

Kurikulum menyebutkan praktik dasar seperti membuat variabel, eksperimen naming, case sensitivity, dan assignment patterns. Contoh-contoh di atas sudah mencakup ilustrasi untuk poin-poin ini. Untuk praktik mandiri, Anda bisa mencoba:

1.  **Membuat Variabel Pertama**:

    ```lua
    local nama_saya = "Pengguna Lua"
    local umur_saya = 25
    local hobi = {"membaca", "koding", "bersepeda"} -- ini tabel, akan dibahas nanti
    local aktif = true

    print("Nama:", nama_saya)
    print("Umur:", umur_saya)
    print("Aktif:", aktif)
    ```

2.  **Eksperimen dengan Naming Conventions**:
    - Coba buat variabel dengan `snake_case`, `camelCase`.
    - Buat variabel yang Anda anggap "konstanta" dengan `UPPER_SNAKE_CASE`.
    - Perhatikan mana yang paling mudah Anda baca.
3.  **Testing Case Sensitivity**:

    ```lua
    local temperature = 30
    local Temperature = "Panas"
    -- local temperature = 25 -- Ini akan error karena 'temperature' sudah dideklarasikan di scope yang sama
                         -- jika tanpa 'local', ini akan menimpa nilai 'temperature' sebelumnya.

    print(temperature) -- Output: 30
    print(Temperature) -- Output: Panas
    ```

4.  **Variable Assignment Patterns**:

    - **Single Assignment**: `a = 10`
    - **Multiple Assignment**: Menginisialisasi beberapa variabel sekaligus.

      ```lua
      local x, y, z
      print(x, y, z) -- Output: nil nil nil

      x, y, z = 10, "dua puluh", true
      print(x) -- Output: 10
      print(y) -- Output: "dua puluh"
      print(z) -- Output: true

      -- Jumlah nilai bisa lebih sedikit atau lebih banyak dari variabel
      local nama, kota
      nama, kota, negara = "Lina", "Bandung" -- negara akan menjadi nil
      print(nama, kota, negara) -- Output: Lina Bandung nil

      local warna1, warna2
      warna1, warna2 = "merah", "kuning", "hijau" -- "hijau" akan diabaikan
      print(warna1, warna2) -- Output: merah kuning
      ```

      Multiple assignment akan dibahas lebih lanjut di Modul 2.

### 1.2 Tipe Data dan Variabel

Bagian ini akan menguraikan delapan tipe data dasar di Lua dan bagaimana cara memeriksa serta mengonversi tipe data.

#### **Eight Basic Types (3 jam)**

Lua memiliki delapan tipe data dasar. Memahami masing-masing sangat krusial.

1.  **nil**

    - **Deskripsi Konkret**: Tipe data yang hanya memiliki satu nilai, yaitu `nil` itu sendiri. Merepresentasikan ketiadaan nilai atau nilai yang tidak terdefinisi.
    - **Konsep**: Sering digunakan untuk menandakan sesuatu yang kosong, belum diinisialisasi, atau sebagai cara untuk "menghapus" entri dari tabel (termasuk variabel global).
    - **Sifat**: Dianggap `false` dalam konteks boolean (falsy).
    - **Contoh Kode**:

      ```lua
      local dataTidakAda
      print(type(dataTidakAda)) -- Output: nil
      print(dataTidakAda)      -- Output: nil

      if not dataTidakAda then
          print("Data tidak tersedia.") -- Akan tercetak
      end
      ```

2.  **boolean**

    - **Deskripsi Konkret**: Tipe data yang hanya memiliki dua kemungkinan nilai: `true` (benar) dan `false` (salah).
    - **Konsep**: Fundamental untuk logika kondisional dan alur kontrol dalam program.
    - **Sifat**: `false` (dan `nil`) adalah falsy. Semua nilai lain adalah truthy.
    - **Contoh Kode**:

      ```lua
      local lampuMenyala = true
      local pintuTerbuka = false

      print(type(lampuMenyala)) -- Output: boolean

      if lampuMenyala then
          print("Lampu sedang menyala.") -- Akan tercetak
      end

      if not pintuTerbuka then
          print("Pintu sedang tertutup.") -- Akan tercetak
      end
      ```

3.  **number**

    - **Deskripsi Konkret**: Merepresentasikan angka. Secara default di banyak versi Lua (sebelum 5.3 atau jika dikompilasi demikian), semua angka adalah _double-precision floating-point numbers_. Lua 5.3 memperkenalkan subtipe _integer_.
    - **Terminologi & Konsep**:
      - **Floating-point**: Angka yang bisa memiliki bagian desimal (contoh: 3.14, -0.01).
      - **Integer**: Bilangan bulat (contoh: 10, -5, 0).
    - **Detail Lua**:

      - **Lua < 5.3**: Semua angka adalah _double_.
        ```lua
        local n = 3
        local m = 3.0
        -- Di Lua < 5.3, n dan m akan disimpan dengan cara yang sama (double)
        ```
      - **Lua >= 5.3**: Lua dapat membedakan antara integer dan float. Jika sebuah angka ditulis tanpa titik desimal dan nilainya pas dalam representasi integer, Lua akan menyimpannya sebagai integer. Operasi aritmetika akan mempertahankan sifat integer jika memungkinkan.

        ```lua
        -- Di Lua 5.3+
        local i = 10     -- Dianggap integer
        local f = 10.0   -- Dianggap float
        local j = 10.5   -- Dianggap float
        local k = i + 1  -- k akan menjadi integer (11)
        local l = i + 0.5 -- l akan menjadi float (10.5)

        print(type(i)) -- Output: number (Lua tidak membedakan 'integer' dan 'float' dengan type())
                       -- Untuk membedakannya, gunakan math.type (Lua 5.3+)
        if math.type then -- Cek apakah math.type ada (Lua 5.3+)
            print("Tipe i:", math.type(i)) -- Output: Tipe i: integer
            print("Tipe f:", math.type(f)) -- Output: Tipe f: float
        end
        ```

    - **Notasi**: Angka bisa ditulis dalam notasi ilmiah (contoh: `3.14e-2` yang berarti `0.0314`, atau `2E8` yang berarti `200000000`). Mulai Lua 5.2, notasi heksadesimal untuk float juga didukung (contoh: `0x1.fp2` yang berarti $1.9375 \times 2^2 = 7.75$).
    - **Contoh Kode**:

      ```lua
      local usia = 25
      local harga = 150.75
      local suhu = -5.5
      local populasi = 7e9 -- 7 miliar

      print(type(usia)) -- Output: number
      print(harga + 10) -- Output: 160.75
      ```

4.  **string**

    - **Deskripsi Konkret**: Urutan (sequence) dari byte. Biasanya digunakan untuk merepresentasikan teks. String di Lua bersifat _immutable_, artinya sekali string dibuat, isinya tidak dapat diubah. Operasi yang terlihat seperti memodifikasi string sebenarnya membuat string baru.
    - **Terminologi & Konsep**:
      - **Immutable**: Tidak bisa diubah setelah dibuat.
      - **Concatenation (Penggabungan)**: Menggabungkan dua string atau lebih menjadi satu string baru, menggunakan operator `..`.
    - **Literal String**:

      - Dapat diapit oleh tanda kutip tunggal (`'...'`) atau tanda kutip ganda (`"..."`).
        ```lua
        local s1 = 'halo'
        local s2 = "dunia"
        ```
      - String multibaris dan string yang mengandung kutipan dapat dibuat menggunakan kurung siku ganda panjang (`[[...]]`, `[=[...]=]`, dst.).

        ```lua
        local puisi = [[
        Ini adalah baris pertama.
        Ini adalah baris kedua.
        Dan ini "kutipan" di dalamnya.
        ]]

        local data_xml = [=[
        <data>
            <item id="1">Isi</item>
        </data>
        ]=]
        ```

      - **Escape sequences**: Karakter khusus seperti `\n` (baris baru), `\t` (tab), `\\` (backslash), `\"` (kutip ganda), `\'` (kutip tunggal).
        ```lua
        local pesan = "Dia berkata: \"Halo!\"\nIni baris baru."
        print(pesan)
        -- Output:
        -- Dia berkata: "Halo!"
        -- Ini baris baru.
        ```

    - **Sifat**: String bisa berisi byte apa pun, termasuk null byte (`\0`), sehingga bisa digunakan untuk menyimpan data biner. Panjang string bisa didapatkan dengan operator `#`.
    - **Contoh Kode**:

      ```lua
      local namaDepan = "Alice"
      local namaBelakang = "Wonderland"
      local namaLengkap = namaDepan .. " " .. namaBelakang -- Penggabungan

      print(namaLengkap)        -- Output: Alice Wonderland
      print(type(namaLengkap))  -- Output: string
      print(#namaLengkap)       -- Output: 16 (panjang string)

      -- Immutability demo
      local s = "halo"
      local s_upper = string.upper(s) -- string.upper membuat string BARU
      print(s)        -- Output: halo (string asli tidak berubah)
      print(s_upper)  -- Output: HALO
      ```

5.  **function**

    - **Deskripsi Konkret**: Blok kode yang dapat dieksekusi, yang dapat menerima argumen (input) dan mengembalikan nilai (output). Fungsi di Lua adalah first-class values.
    - **Konsep**: Digunakan untuk mengorganisir kode menjadi unit-unit yang dapat digunakan kembali, melakukan tugas tertentu.
    - **Deklarasi Fungsi**:

      ```lua
      -- Cara 1: Sintaks umum
      function namaFungsi(parameter1, parameter2)
          -- isi fungsi
          return hasil -- opsional
      end

      -- Cara 2: Fungsi anonim ditugaskan ke variabel (lebih eksplisit menunjukkan sifat first-class)
      local namaFungsiLain = function(param1, param2)
          -- isi fungsi
          return hasil -- opsional
      end
      ```

    - **Contoh Kode**:

      ```lua
      local function tambah(a, b)
          return a + b
      end

      local hasil = tambah(5, 3)
      print(hasil)              -- Output: 8
      print(type(tambah))       -- Output: function
      ```

      Fungsi akan dibahas sangat mendalam di modul-modul berikutnya karena peran sentralnya di Lua (closures, modul, OOP).

6.  **userdata**

    - **Deskripsi Konkret**: Menyediakan cara bagi kode C (atau bahasa lain yang bisa berinteraksi dengan C API Lua) untuk membuat tipe data baru yang dapat dimanipulasi oleh Lua. Userdata adalah blok memori mentah yang dikelola oleh aplikasi host atau library C, bukan oleh Lua secara langsung, meskipun GC Lua dapat mengelolanya jika dikonfigurasi dengan benar.
    - **Terminologi & Konsep**:
      - **C API**: Antarmuka pemrograman aplikasi yang memungkinkan kode C berinteraksi dengan interpreter Lua.
      - **Full Userdata**: Blok memori yang dikelola oleh host. Lua hanya menyimpan pointer ke sana.
      - **Light Userdata**: Hanya sebuah pointer C (`void*`). Tidak dikelola oleh GC Lua.
    - **Penggunaan Umum**: Merepresentasikan objek atau struktur data dari library C di dalam Lua (misalnya, file handle, koneksi database, objek grafis).
    - **Manipulasi**: Biasanya dimanipulasi melalui fungsi-fungsi (seringkali fungsi C yang diekspos ke Lua) yang tahu bagaimana menginterpretasikan data mentah tersebut. Metatables sering digunakan untuk mendefinisikan operasi pada userdata.
    - **Contoh Kode (Konseptual, karena pembuatan userdata biasanya dari C)**:

      ```lua
      -- Misalkan ada fungsi C 'new_file_handle' yang mengembalikan userdata
      -- local file = io.open("contoh.txt", "r") -- io.open mengembalikan userdata (file handle)

      -- if file then
      --     print(type(file)) -- Output: userdata (atau 'file' tergantung implementasi io lib)
      --     local baris = file:read("*l") -- Memanggil metode pada userdata (via metatable)
      --     print(baris)
      --     file:close()
      -- else
      --     print("Gagal membuka file")
      -- end
      ```

      Anda akan lebih banyak berinteraksi dengan userdata jika Anda menggunakan library eksternal yang ditulis dalam C atau jika Anda menulis ekstensi C untuk Lua.

7.  **thread**

    - **Deskripsi Konkret**: Merepresentasikan _coroutine_ di Lua. Coroutine adalah bentuk komputasi konkuren kolaboratif. Berbeda dengan thread preemptive di sistem operasi, coroutine hanya berpindah eksekusi ketika secara eksplisit diminta.
    - **Terminologi & Konsep**:
      - **Concurrency (Konkurensi)**: Kemampuan untuk menjalankan beberapa tugas seolah-olah secara bersamaan.
      - **Collaborative Multitasking**: Coroutine menyerahkan kontrol secara sukarela.
      - **Preemptive Multitasking**: Sistem operasi dapat menginterupsi tugas kapan saja untuk memberi giliran pada tugas lain.
    - **Penggunaan Umum**: Untuk iterator, generator, logika state machine, tugas asinkron non-blocking (dalam beberapa framework).
    - **Modul `coroutine`**: Fungsi untuk membuat dan mengontrol thread (coroutine) ada di modul `coroutine` (misalnya `coroutine.create()`, `coroutine.resume()`, `coroutine.yield()`).
    - **Contoh Kode (Dasar)**:

      ```lua
      local co = coroutine.create(function(a, b)
          print("Coroutine dimulai dengan:", a, b)
          local hasil_yield_pertama = coroutine.yield(a + b) -- Menyerahkan kontrol, mengembalikan a+b
          print("Coroutine di-resume dengan:", hasil_yield_pertama)
          return a - b, "selesai" -- Selesai, mengembalikan dua nilai
      end)

      print(type(co))             -- Output: thread
      print(coroutine.status(co)) -- Output: suspended

      local status, val1 = coroutine.resume(co, 10, 5) -- Memulai/melanjutkan coroutine
      print(status, val1)         -- Output: true 15 (status eksekusi, hasil dari yield)
      print(coroutine.status(co)) -- Output: suspended (karena yield)

      local status2, val2, val3 = coroutine.resume(co, "data dari resume") -- Melanjutkan lagi
      print(status2, val2, val3)  -- Output: true 5 selesai (hasil dari return)
      print(coroutine.status(co)) -- Output: dead (karena sudah selesai)
      ```

      Coroutines adalah konsep yang kuat dan akan dibahas lebih lanjut.

8.  **table**

    - **Deskripsi Konkret**: Satu-satunya mekanisme struktur data built-in di Lua. Tabel adalah _associative array_ yang sangat fleksibel. Artinya, ia dapat diindeks tidak hanya dengan angka (seperti array biasa) tetapi juga dengan tipe data lain seperti string (kecuali `nil` dan NaN).
    - **Terminologi & Konsep**:
      - **Associative Array (Array Asosiatif)**: Kumpulan pasangan kunci-nilai (key-value pairs). Juga dikenal sebagai map, dictionary, atau hash table di bahasa lain.
      - **Key (Kunci)**: Identifier unik untuk mengakses nilai.
      - **Value (Nilai)**: Data yang disimpan, diakses melalui kunci.
    - **Penggunaan Umum**:
      - Sebagai array (list/daftar): Jika kunci adalah integer sekuensial mulai dari 1.
      - Sebagai dictionary (map/record): Jika kunci adalah string atau tipe lain.
      - Sebagai namespace (modul).
      - Untuk implementasi objek (OOP-style).
    - **Literal Tabel**: Dibuat menggunakan kurung kurawal `{}`.
    - **Sintaks Dasar & Contoh Kode**:

      ```lua
      -- Tabel kosong
      local t1 = {}
      print(type(t1)) -- Output: table

      -- Tabel sebagai array (list-style)
      local warna = {"merah", "kuning", "hijau"} -- Kunci implisit: 1, 2, 3
      print(warna[1]) -- Output: merah (Lua menggunakan indeks berbasis 1)
      print(warna[3]) -- Output: hijau
      print(#warna)   -- Output: 3 (operator # mengembalikan panjang bagian array)

      -- Tabel sebagai dictionary (record-style)
      local siswa = {
          nama = "Budi",
          umur = 17,
          ["kelas"] = "11A", -- Kunci string bisa juga ditulis seperti ini
          sudahLulus = false
      }
      print(siswa.nama)         -- Output: Budi (akses dot-notation untuk kunci string yg valid sbg identifier)
      print(siswa["umur"])      -- Output: 17 (akses bracket-notation, lebih umum)
      siswa.umur = 18           -- Mengubah nilai
      siswa.sekolah = "SMA Jaya" -- Menambah entri baru
      print(siswa.sekolah)      -- Output: SMA Jaya

      -- Tabel campuran
      local dataCampuran = {
          10, -- Indeks 1
          nama = "Campuran",
          20, -- Indeks 2
          [true] = "nilai boolean", -- Kunci boolean
          fungsi = function() print("Halo dari tabel") end
      }
      print(dataCampuran[1]) -- Output: 10
      print(dataCampuran.nama) -- Output: Campuran
      dataCampuran.fungsi()  -- Output: Halo dari tabel

      -- Menghapus entri dari tabel
      siswa.sudahLulus = nil -- Menghapus field 'sudahLulus'
      print(siswa.sudahLulus) -- Output: nil
      ```

      Tabel adalah jantung dari Lua dan akan dieksplorasi secara ekstensif di seluruh kurikulum.

#### **Type Checking dan Conversion (2 jam)**

Memahami bagaimana memeriksa tipe data dan melakukan konversi antar tipe sangat penting.

- **`type()` Function Usage**

  - **Deskripsi Konkret**: Fungsi bawaan `type()` mengembalikan string yang mendeskripsikan tipe dari nilai yang diberikan.
  - **Sintaks**: `type(variabel_atau_nilai)`
  - **Nilai Kembalian**: String yang mungkin: `"nil"`, `"boolean"`, `"number"`, `"string"`, `"function"`, `"userdata"`, `"thread"`, atau `"table"`.
  - **Contoh Kode**:

    ```lua
    print(type(123))         -- Output: number
    print(type("hello"))     -- Output: string
    print(type(true))        -- Output: boolean
    print(type(nil))         -- Output: nil
    print(type({}))          -- Output: table
    print(type(function() end)) -- Output: function

    local x
    print(type(x))           -- Output: nil
    ```

- **Automatic Type Conversion (Coercion)**

  - **Deskripsi Konkret**: Lua melakukan konversi tipe otomatis (coercion) dalam beberapa situasi, terutama antara string dan number dalam operasi aritmetika dan string concatenation.
  - **Terminologi & Konsep**:
    - **Coercion**: Konversi tipe implisit yang dilakukan oleh bahasa.
  - **Aturan Coercion Utama di Lua**:
    - **String ke Number**: Dalam operasi aritmetika, jika Lua menemukan string yang terlihat seperti angka, Lua akan mencoba mengonversinya menjadi angka.
      ```lua
      print("10" + 5)     -- Output: 15.0 (string "10" dikonversi ke angka 10)
      print("2" * "3")    -- Output: 6.0
      print("-5.5" + 1)   -- Output: -4.5
      -- print("hello" + 5) -- Error: attempt to perform arithmetic on a string value ("hello")
      ```
    - **Number ke String**: Dalam operasi penggabungan string (`..`), jika Lua menemukan angka, ia akan mengonversinya menjadi string.
      ```lua
      print("Umur: " .. 25) -- Output: Umur: 25 (angka 25 dikonversi ke string "25")
      print(10 .. 20)       -- Output: 1020 (angka 10 jadi "10", 20 jadi "20", lalu digabung)
      ```
  - **Perhatian**: Meskipun coercion bisa nyaman, terlalu bergantung padanya dapat membuat kode kurang jelas dan rentan terhadap error jika format string tidak sesuai harapan. Lebih baik melakukan konversi eksplisit jika ada keraguan.

- **Explicit Type Conversion**

  - **Deskripsi Konkret**: Lua menyediakan fungsi bawaan untuk mengonversi nilai dari satu tipe ke tipe lain secara eksplisit.
  - **Fungsi Utama**:

    - **`tonumber(nilai, basis)`**: Mencoba mengonversi `nilai` menjadi angka. Jika konversi gagal, mengembalikan `nil`. Argumen `basis` bersifat opsional (default 10) dan menentukan basis angka dalam string (misalnya, 2 untuk biner, 16 untuk heksadesimal).

      ```lua
      local angka1 = tonumber("123.45") -- Output: 123.45 (number)
      local angka2 = tonumber("101", 2)  -- Output: 5 (number, "101" biner adalah 5 desimal)
      local angka3 = tonumber("FF", 16)  -- Output: 255 (number, "FF" heksa adalah 255 desimal)
      local bukanAngka = tonumber("halo")-- Output: nil
      local angka4 = tonumber("  77 ") -- Lua 5.1+ bisa handle spasi di awal/akhir.
                                      -- Perilaku parsing bisa sedikit bervariasi antar versi minor Lua
                                      -- terutama terkait spasi atau format non-standar.

      print(angka1, angka2, angka3, bukanAngka, angka4)
      ```

    - **`tostring(nilai)`**: Mengonversi `nilai` menjadi representasi string-nya. Bekerja untuk semua tipe data.

      ```lua
      local s1 = tostring(123)          -- Output: "123" (string)
      local s2 = tostring(true)         -- Output: "true" (string)
      local s3 = tostring(nil)          -- Output: "nil" (string)
      local tabel = {}
      local s4 = tostring(tabel)        -- Output: "table: 0x..." (alamat memori tabel)
                                        -- Anda bisa mengganti ini dengan metatable __tostring

      print(s1, s2, s3, s4)
      ```

  - **Penting**: Selalu periksa hasil dari `tonumber()` karena bisa mengembalikan `nil`.

- **Type Coercion Rules (Rangkuman & Penekanan)**

  - **Aritmetika**: Lua akan mencoba mengoersi operan string menjadi angka. Jika gagal, error.
  - **Concatenation (`..`)**: Lua akan mengoersi operan angka (atau boolean, nil) menjadi string.
  - **Perbandingan Relasional (`<`, `>`, `<=`, `>=`)**:
    - Jika kedua operan adalah angka, bandingkan sebagai angka.
    - Jika kedua operan adalah string, bandingkan secara leksikografis (alfabetis).
    - Jika tipe berbeda (misalnya, angka dan string), error akan terjadi. Lua tidak mencoba mengoersi tipe dalam perbandingan relasional selain untuk tipe yang sama.
      ```lua
      print(10 < 20)       -- Output: true
      print("apple" < "banana") -- Output: true
      -- print(10 < "20")   -- Error di Lua: attempt to compare number with string
      -- Namun, perbandingan kesetaraan (==, ~=) TIDAK melakukan koersi jika tipe berbeda
      print(10 == "10")    -- Output: false (karena number tidak sama dengan string)
      ```
  - **Kesetaraan (`==`, `~=`)**:
    - Jika tipe operan berbeda, hasilnya selalu `false` untuk `==` dan `true` untuk `~=`. Tidak ada coercion.
    - Jika tipe sama:
      - `nil`: `nil == nil` adalah `true`.
      - `number`, `boolean`, `string`: Bandingkan nilainya.
      - `table`, `function`, `userdata`, `thread`: Bandingkan berdasarkan referensi (identitas objek). Dua tabel hanya sama jika keduanya merujuk ke objek tabel yang sama persis di memori.
        ```lua
        local t1 = {}
        local t2 = {}
        local t3 = t1
        print(t1 == t2) -- Output: false (dua tabel berbeda meskipun isinya sama-sama kosong)
        print(t1 == t3) -- Output: true (t1 dan t3 merujuk ke tabel yang sama)
        ```

- **Common Type-Related Errors**

  - **`attempt to perform arithmetic on a <type> value (<detail>)`**: Terjadi jika Anda mencoba operasi aritmetika pada nilai yang bukan angka dan tidak bisa dikonversi ke angka (misalnya, `nil + 10`, `"hello" * 2`).
    ```lua
    local x -- nil
    -- print(x + 5) -- Error: attempt to perform arithmetic on a nil value
    ```
  - **`attempt to concatenate a <type> value (<detail>)`**: Biasanya terjadi jika mencoba menggunakan `..` dengan nilai yang tidak bisa dikonversi dengan baik, meskipun Lua cukup permisif di sini (angka, boolean dikonversi). Lebih sering terjadi dengan `nil`.
    ```lua
    local y -- nil
    -- print("Nilai y: " .. y) -- Error: attempt to concatenate a nil value
    -- Perbaikan:
    print("Nilai y: " .. tostring(y)) -- Output: Nilai y: nil
    ```
  - **`attempt to compare <type> with <type>`**: Saat menggunakan `<`, `>`, `<=`, `>=` antara tipe yang tidak kompatibel (misalnya, angka dan string).
    ```lua
    -- print(100 < "50") -- Error
    ```
  - **`attempt to call a <type> value (<detail>)`**: Mencoba memanggil sesuatu seolah-olah itu fungsi, padahal bukan.
    ```lua
    local z = 10
    -- z() -- Error: attempt to call a number value
    ```
  - **`attempt to index a <type> value (<detail>)`**: Mencoba mengindeks (menggunakan `.` atau `[]`) pada sesuatu yang bukan tabel (atau userdata dengan metatable yang sesuai), dan seringnya terjadi pada `nil`.

    ```lua
    local data -- nil
    -- print(data.field) -- Error: attempt to index a nil value ('data' is nil)

    local myTable = {}
    -- print(myTable.nonExistentField.subField) -- Error: attempt to index a nil value (myTable.nonExistentField adalah nil)
    ```

    Memahami pesan error ini penting untuk debugging.

#### **Praktik (3 jam)**

Kurikulum menyarankan latihan eksplorasi tipe, tes konversi, dan penanganan error. Contoh-contoh di atas sudah memberikan dasar untuk ini. Anda bisa mencoba:

1.  **Eksplorasi Tipe**: Buat variabel dengan berbagai tipe data, gunakan `type()` untuk memverifikasi.
2.  **Tes Konversi**:
    - Gunakan `tonumber()` dengan berbagai string (angka valid, angka dengan basis berbeda, teks non-angka) dan periksa hasilnya (apakah angka atau `nil`).
    - Gunakan `tostring()` pada semua tipe data.
    - Eksperimen dengan coercion: `print("5" + "5")`, `print(5 .. 5)`.
3.  **Error Handling untuk Type Mismatches**:

    - Sengaja buat error tipe (seperti di "Common Type-Related Errors") dan amati pesan errornya.
    - Coba gunakan `pcall` (protected call) untuk menangani error potensial saat melakukan konversi atau operasi yang rawan error tipe (ini konsep yang lebih lanjut tapi berguna):

      ```lua
      local status, hasil = pcall(function()
          return "abc" + 10 -- Ini akan error
      end)

      if not status then
          print("Terjadi error:", hasil) -- 'hasil' akan berisi pesan error
      else
          print("Hasilnya:", hasil)
      end
      -- Output: Terjadi error: attempt to perform arithmetic on a string value
      ```

4.  **Dynamic Typing Advantages/Disadvantages**:
    - **Advantages**: Fleksibilitas, prototipe cepat, kode lebih singkat (tidak perlu deklarasi tipe).
    - **Disadvantages**: Error tipe baru ketahuan saat runtime (bukan saat kompilasi), bisa lebih sulit untuk reasoning tentang kode (tipe variabel tidak selalu jelas tanpa menjalankan atau inspeksi mendalam), performa sedikit terpengaruh oleh type checking runtime.

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][2]**
> - **[Kurikulum][3]**
> - **[Domain Spesifik][4]**

[4]: ../../../../../../README.md
[3]: ../../../../README.md
[2]: ../2-assignment-patterns/README.md
[1]: ../../README.md/#11-pengenalan-variabel-di-lua
