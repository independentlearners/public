# **[1. Fondasi Sistem Tipe Lua][0]**

Bagian ini akan membahas dasar-dasar bagaimana Lua menangani tipe data. Memahami fondasi ini sangat penting karena akan memengaruhi cara Anda menulis kode dan memahami perilaku program Lua Anda.

### **1.1 Filosofi _Dynamic Typing_**

Lua adalah bahasa pemrograman yang menggunakan _dynamic typing_ (pengetikan dinamis). Ini berarti Anda tidak perlu secara eksplisit mendeklarasikan tipe data dari sebuah variabel sebelum menggunakannya. Tipe data variabel ditentukan secara otomatis pada saat _runtime_ (waktu eksekusi) berdasarkan nilai yang diisikan ke variabel tersebut.

#### **Konsep _Type System_ dan _Runtime Type Checking_**

- **_Type System_ (Sistem Tipe)**

  - **Deskripsi**: _Type System_ adalah sekumpulan aturan dalam bahasa pemrograman yang menentukan bagaimana nilai-nilai (data) dikategorikan ke dalam tipe-tipe yang berbeda (seperti angka, teks, boolean) dan bagaimana bahasa tersebut menangani operasi antar tipe data yang berbeda. Aturan ini membantu memastikan bahwa operasi dalam program dilakukan pada tipe data yang sesuai, sehingga mencegah kesalahan.
  - **Di Lua**: Lua memiliki sistem tipe yang sederhana namun kuat. Variabel dalam Lua tidak memiliki tipe; hanya nilai yang memiliki tipe. Ini berarti sebuah variabel dapat menyimpan nilai integer pada satu waktu, dan kemudian menyimpan nilai string di waktu lain.

- **_Runtime Type Checking_ (Pemeriksaan Tipe Saat _Runtime_)**

  - **Deskripsi**: Ini adalah proses di mana tipe data dari sebuah variabel atau nilai diperiksa selama program sedang berjalan (_runtime_), bukan selama kompilasi. Jika ada operasi yang tidak valid antar tipe data (misalnya, mencoba menjumlahkan angka dengan tabel tanpa aturan khusus), kesalahan akan muncul saat program dieksekusi.
  - **Di Lua**: Lua sepenuhnya melakukan _runtime type checking_. Ini memberikan fleksibilitas tinggi karena Anda tidak terikat dengan deklarasi tipe di awal.

    - **Contoh Sederhana**:

      ```lua
      -- Tidak perlu deklarasi tipe variabel
      variabelKu = 10
      print(type(variabelKu)) -- Output: number

      variabelKu = "Halo Lua!"
      print(type(variabelKu)) -- Output: string

      -- Contoh operasi yang akan menyebabkan error saat runtime jika tidak sesuai
      -- variabelKu = "teks" + 5 -- Ini akan menyebabkan error karena mencoba menjumlahkan string dengan number
      ```

      - **Penjelasan Sintaksis**:
        - `--`: Digunakan untuk komentar satu baris. Teks setelah `--` hingga akhir baris akan diabaikan oleh interpreter Lua.
        - `variabelKu = 10`: Ini adalah pernyataan _assignment_ (penugasan).
          - `variabelKu`: Nama variabel.
          - `=`: Operator penugasan, memberikan nilai di sebelah kanan ke variabel di sebelah kiri.
          - `10`: Nilai literal berupa angka.
        - `print()`: Fungsi bawaan Lua untuk mencetak nilai ke output standar (biasanya konsol).
        - `type()`: Fungsi bawaan Lua yang mengembalikan tipe dari nilai yang diberikan sebagai string (misalnya, "number", "string", "table", dll.).

  - **Kelebihan _Dynamic Typing_**:
    - **Fleksibilitas**: Variabel dapat digunakan kembali untuk menyimpan tipe data yang berbeda.
    - **Prototipe Cepat**: Memungkinkan pengembangan dan pengujian ide dengan lebih cepat karena tidak perlu banyak deklarasi tipe.
  - **Kekurangan _Dynamic Typing_**:
    - **Deteksi Error Lambat**: Kesalahan terkait tipe baru terdeteksi saat _runtime_, yang mungkin lebih sulit untuk di-debug dibandingkan jika terdeteksi saat kompilasi.
    - **Potensi Overhead Performa**: Pemeriksaan tipe saat _runtime_ dapat menambah sedikit _overhead_ pada performa, meskipun implementasi Lua sangat efisien.

---

#### **_Internal Value Representation (TValue Structure)_**

- **Deskripsi**: Di dalam interpreter Lua, setiap nilai direpresentasikan menggunakan sebuah struktur data internal yang disebut `TValue` (Tagged Value). Struktur ini tidak hanya menyimpan data aktual (seperti angka atau pointer ke string) tetapi juga sebuah "tag" yang mengindikasikan tipe dari data tersebut.
- **Struktur `TValue` (Konseptual)**:
  Secara konseptual, `TValue` bisa dibayangkan memiliki dua bagian utama:

  1.  **`Value`**: Bagian yang menyimpan data sebenarnya. Isi dari bagian ini bergantung pada tipe data. Misalnya, untuk angka, ia menyimpan nilai floating-point; untuk string, ia menyimpan pointer ke string; untuk tabel, ia menyimpan pointer ke struktur tabel, dan seterusnya.
  2.  **`tt_` (Type Tag)**: Bagian yang menyimpan informasi tipe data dari nilai tersebut. Tag ini adalah sebuah enumerasi atau integer yang membedakan antara `nil`, `boolean`, `number`, `string`, `table`, `function`, `userdata`, dan `thread`.

- **Pentingnya `TValue`**:

  - Struktur `TValue` adalah inti dari sistem tipe dinamis Lua. Ketika Anda memanggil fungsi `type(x)`, Lua pada dasarnya melihat _tag_ tipe di dalam `TValue` yang merepresentasikan `x`.
  - Ini memungkinkan Lua untuk secara efisien menentukan tipe nilai apa pun pada saat _runtime_ dan melakukan operasi yang sesuai atau melaporkan kesalahan tipe.

- **Sumber untuk Detail Lebih Lanjut**:
  - Kode sumber resmi Lua, khususnya file `lobject.h`, adalah tempat terbaik untuk melihat definisi aktual dari `TValue` dan konstanta tipe terkait.
  - Komunitas Lua Wiki (lua-users.org) juga sering memiliki penjelasan mendalam tentang internal Lua.

---

#### **_Tagged Values_ dan _Union Types_**

- **_Tagged Values_**:

  - **Deskripsi**: Seperti yang dibahas di atas, `TValue` di Lua adalah contoh klasik dari _tagged value_. "Tag" (dalam `tt_`) secara eksplisit menandai tipe dari nilai yang disimpan. Ini berbeda dengan sistem di mana tipe hanya implisit dari konteks atau lokasi memori.
  - **Implementasi**: Tag ini memungkinkan interpreter Lua untuk dengan cepat mengetahui tipe data apa yang sedang ditangani tanpa perlu analisis kompleks. Misalnya, ketika Lua melakukan operasi penjumlahan `a + b`, ia akan terlebih dahulu memeriksa tag tipe dari `a` dan `b`. Jika keduanya adalah angka (atau dapat dikonversi menjadi angka), penjumlahan dilakukan. Jika tidak, Lua mungkin akan mencari metamethod `__add` (akan dibahas nanti) atau melaporkan error.

- **_Union Types_ (dalam Konteks Representasi Internal)**:

  - **Deskripsi**: Bagian `Value` dari `TValue` dapat dianggap sebagai semacam _union_ dalam bahasa C. _Union_ adalah struktur data yang dapat menyimpan berbagai jenis data di lokasi memori yang sama, tetapi hanya satu jenis pada satu waktu. Pilihan jenis data yang aktif di _union_ ditentukan oleh nilai _tag_.
  - **Di Lua**: Karena `TValue` harus bisa menyimpan berbagai jenis nilai Lua (angka, pointer ke string, pointer ke tabel, dll.), bagian penyimpan datanya menggunakan mekanisme yang mirip _union_. _Tag_ tipe (`tt_`) memberi tahu interpreter cara menginterpretasikan bit-bit yang ada di bagian nilai tersebut.
    - Misalnya, jika `tt_` menandakan `LUA_TNUMBER`, maka bit-bit di bagian `Value` diinterpretasikan sebagai angka _floating-point_.
    - Jika `tt_` menandakan `LUA_TSTRING`, maka bit-bit di bagian `Value` diinterpretasikan sebagai pointer ke data string.

- **Manfaat Kombinasi _Tagged Values_ dan _Unions_**:

  - **Efisiensi Memori**: _Union_ memungkinkan `TValue` memiliki ukuran yang tetap (atau setidaknya terkontrol) terlepas dari tipe data yang disimpannya, karena memori yang sama digunakan kembali untuk tipe yang berbeda.
  - **Fleksibilitas Tipe Dinamis**: Kombinasi ini adalah fondasi teknis yang memungkinkan Lua menjadi bahasa dengan pengetikan dinamis secara efisien.

- **Sumber untuk Detail Lebih Lanjut**:
  - Header `ltm.h` dalam kode sumber Lua mendefinisikan _Tag Methods_ dan bagaimana tag digunakan dalam operasi.
  - Diskusi tentang implementasi Lua di lua-users.org sering menyentuh aspek ini.

Memahami konsep `TValue`, _tagged values_, dan bagaimana _union_ digunakan secara internal membantu menghargai efisiensi dan desain elegan di balik sistem tipe Lua. Meskipun Anda tidak berinteraksi langsung dengan `TValue` saat menulis kode Lua sehari-hari, pengetahuan ini berguna untuk pemahaman yang lebih dalam, terutama saat mempertimbangkan performa atau interaksi dengan C API Lua.

---

### **1.2 _Type System Internals_**

Setelah memahami filosofi umum, mari kita lihat beberapa mekanisme internal dan fungsi yang digunakan Lua untuk bekerja dengan tipe data.

#### **Fungsi `type()` dan _Advanced Type Inspection_**

- **Fungsi `type()` Bawaan**:

  - **Deskripsi**: Fungsi `type()` adalah cara paling dasar dan umum untuk mengetahui tipe dari sebuah nilai di Lua. Fungsi ini menerima satu argumen (nilai yang ingin diperiksa) dan mengembalikan sebuah string yang merepresentasikan tipe dari nilai tersebut.
  - **Kemungkinan Nilai Kembali**: String yang dikembalikan oleh `type()` bisa berupa salah satu dari berikut:

    - `"nil"` (untuk nilai `nil`)
    - `"number"` (untuk angka, baik integer maupun float)
    - `"string"` (untuk teks)
    - `"boolean"` (untuk `true` atau `false`)
    - `"table"` (untuk tabel)
    - `"function"` (untuk fungsi Lua atau C)
    - `"thread"` (untuk coroutine)
    - `"userdata"` (untuk data C yang dikelola Lua)

  - **Sintaks Dasar**:

    ```lua
    type(variabel_atau_nilai)
    ```

    - **Penjelasan Sintaksis**:
      - `type`: Nama fungsi bawaan.
      - `( ... )`: Kurung pembuka dan penutup untuk argumen fungsi.
      - `variabel_atau_nilai`: Argumen yang akan diperiksa tipenya. Ini bisa berupa variabel, nilai literal, atau hasil dari ekspresi lain.

  - **Contoh Penggunaan**:

    ```lua
    local angka = 100
    local teks = "Halo"
    local tabelKu = {1, 2, 3}
    local fungsiKu = function() print("Fungsi dipanggil") end
    local tidakAda = nil
    local benarSalah = true

    print("Tipe dari angka:", type(angka))       -- Output: Tipe dari angka: number
    print("Tipe dari teks:", type(teks))        -- Output: Tipe dari teks: string
    print("Tipe dari tabelKu:", type(tabelKu))  -- Output: Tipe dari tabelKu: table
    print("Tipe dari fungsiKu:", type(fungsiKu)) -- Output: Tipe dari fungsiKu: function
    print("Tipe dari tidakAda:", type(tidakAda))  -- Output: Tipe dari tidakAda: nil
    print("Tipe dari benarSalah:", type(benarSalah)) -- Output: Tipe dari benarSalah: boolean
    print("Tipe dari 3.14:", type(3.14))        -- Output: Tipe dari 3.14: number
    print("Tipe dari type:", type(type))        -- Output: Tipe dari type: function (ya, fungsi 'type' itu sendiri adalah tipe function!)
    ```

    - **Penjelasan Sintaksis Kode Contoh**:
      - `local angka = 100`:
        - `local`: Keyword untuk mendeklarasikan variabel lokal. Variabel lokal hanya dapat diakses dalam blok di mana ia didefinisikan (misalnya, di dalam file ini, atau di dalam fungsi jika didefinisikan di sana). Menggunakan `local` umumnya adalah praktik yang baik untuk menghindari polusi _global namespace_ dan dapat meningkatkan performa karena aksesnya lebih cepat.
        - `angka`: Nama variabel lokal.
        - `= 100`: Penugasan nilai `100` (tipe number) ke variabel `angka`.
      - `print("Tipe dari angka:", type(angka))`:
        - `print()`: Fungsi untuk mencetak. Dapat menerima beberapa argumen yang dipisahkan koma, yang akan dicetak berurutan dengan spasi sebagai pemisah default (di beberapa implementasi) atau tab.
        - `"Tipe dari angka:"`: Nilai string literal.
        - `type(angka)`: Panggilan fungsi `type` dengan variabel `angka` sebagai argumen. Hasilnya (string `"number"`) akan menjadi argumen kedua untuk `print`.

- **_Advanced Type Inspection_ (Inspeksi Tipe Lanjutan)**:

  - Meskipun `type()` sangat berguna, terkadang Anda memerlukan informasi yang lebih spesifik, terutama ketika berhadapan dengan `userdata` atau ketika ingin membedakan antara berbagai jenis _callable objects_ (objek yang bisa dipanggil seperti fungsi).
  - Untuk `userdata`, `type()` hanya akan mengembalikan `"userdata"`. Jika Anda ingin mengetahui tipe spesifik dari `userdata` yang dibuat dari C, Anda biasanya akan menggunakan _metatables_ dan mekanisme internal yang terkait dengan _metatable_ tersebut. Ini akan dibahas lebih detail di bagian "Tipe Userdata" dan "Sistem Metatable".
  - Lua tidak memiliki cara bawaan yang sangat "canggih" untuk inspeksi tipe di luar `type()` dan pemeriksaan _metatable_ karena filosofi desainnya yang ramping. Namun, kombinasi `type()`, `getmetatable()`, dan `rawtype()` (yang lebih baru dan akan dibahas selanjutnya) mencakup sebagian besar kebutuhan.

- **Mengapa Inspeksi Tipe Penting?**

  - **Validasi Input**: Memastikan fungsi menerima argumen dengan tipe yang diharapkan.
  - **Kontrol Alur Program**: Mengambil keputusan berbeda berdasarkan tipe data.
  - **Debugging**: Membantu memahami keadaan variabel saat mencari kesalahan.
  - **Interaksi dengan C**: Saat bekerja dengan `userdata` dari C, memverifikasi tipe sangat krusial.

- **Sumber**:
  - Dasar-dasar tipe data dan fungsi `type()` dibahas dalam "Programming in Lua" (PIL).
  - Banyak tutorial juga menjelaskan penggunaan dasar `type()`.

---

#### **`getmetatable()` dan Teknik `rawtype()`**

Selain `type()`, Lua menyediakan fungsi lain yang bisa memberi kita wawasan lebih dalam tentang nilai, terutama ketika berhadapan dengan tabel dan userdata, serta metatables.

- **`getmetatable()`**:

  - **Deskripsi**: Fungsi `getmetatable(object)` digunakan untuk mendapatkan _metatable_ dari sebuah objek (biasanya tabel atau userdata). Jika objek tidak memiliki _metatable_, fungsi ini akan mengembalikan `nil`. Jika objek memiliki _metatable_ tetapi _metamethod_ `__metatable` diatur dalam _metatable_ tersebut, maka `getmetatable` akan mengembalikan nilai dari `__metatable` tersebut (ini adalah cara untuk melindungi/menyembunyikan _metatable_ asli).
  - **_Metatable_?** Secara singkat, _metatable_ adalah tabel Lua biasa yang berisi _metamethod_. _Metamethod_ adalah fungsi-fungsi khusus yang memungkinkan Anda mengubah perilaku standar dari tabel atau userdata ketika operasi tertentu dilakukan padanya (misalnya, penjumlahan, pemanggilan, pengindeksan). Kita akan membahas _metatables_ secara sangat mendalam di Bagian 5.
  - **Sintaks Dasar**:

    ```lua
    local mt = getmetatable(objek_saya)
    ```

    - **Penjelasan Sintaksis**:
      - `local mt`: Variabel lokal `mt` untuk menyimpan hasil (metatable atau nil).
      - `getmetatable`: Nama fungsi bawaan.
      - `objek_saya`: Variabel atau nilai yang metatablenya ingin diambil.

  - **Contoh Penggunaan**:

    ```lua
    local tabelBiasa = {}
    local metatabelKu = { __index = function() return "Nilai default" end }

    setmetatable(tabelBiasa, metatabelKu) -- Mengatur metatabelKu sebagai metatable dari tabelBiasa

    local mt_tabelBiasa = getmetatable(tabelBiasa)

    if mt_tabelBiasa == metatabelKu then
        print("Metatable berhasil diambil dan sesuai!") -- Output ini akan tercetak
    else
        print("Metatable tidak ditemukan atau berbeda.")
    end

    local angka = 10
    local mt_angka = getmetatable(angka)
    print(type(mt_angka)) -- Output: nil (tipe dasar seperti number, string, boolean tidak memiliki metatable individual secara default,
                          -- meskipun ada metatable per-tipe yang digunakan Lua secara internal untuk operasi string library, misalnya)
                          --
    ```

    - **Penjelasan Sintaksis Kode Contoh**:
      - `local tabelBiasa = {}`: Membuat tabel kosong baru dan menyimpannya di `tabelBiasa`. `{}` adalah sintaks untuk membuat tabel.
      - `local metatabelKu = { __index = function() return "Nilai default" end }`: Membuat tabel lain yang akan berfungsi sebagai _metatable_.
        - `__index`: Ini adalah kunci khusus (sebuah _metamethod_). Jika Anda mencoba mengakses field yang tidak ada di `tabelBiasa`, Lua akan memeriksa apakah `metatabelKu` memiliki field `__index`. Jika `__index` adalah fungsi, fungsi tersebut akan dipanggil. Jika `__index` adalah tabel lain, Lua akan mencari field di tabel tersebut.
        - `function() return "Nilai default" end`: Sebuah fungsi anonim yang mengembalikan string `"Nilai default"`.
      - `setmetatable(tabelBiasa, metatabelKu)`: Fungsi bawaan untuk mengatur _metatable_ dari objek pertama (argumen pertama) menjadi objek kedua (argumen kedua).
      - `if mt_tabelBiasa == metatabelKu then ... else ... end`: Struktur kondisional standar. `==` adalah operator perbandingan kesetaraan.

- **`rawtype()` (Lua 5.4+)**:

  - **Deskripsi**: Fungsi `rawtype(value)` mirip dengan `type(value)`, tetapi ia selalu mengembalikan tipe dasar "nyata" dari nilai tersebut, tanpa memanggil _metamethod_ `__type` (jika ada). Fungsi `type()` dapat dipengaruhi oleh _metamethod_ `__type` jika _metamethod_ tersebut ada di _metatable_ sebuah objek. `rawtype()` mengabaikan ini dan memberikan tipe fundamental internal.
  - **Mengapa `rawtype()`?**: Sebelum Lua 5.4, jika sebuah tabel atau userdata memiliki _metatable_ dengan _metamethod_ `__type`, panggilan ke `type(obj)` akan memanggil `__type` tersebut dan mengembalikan hasilnya. Ini memungkinkan objek untuk "berpura-pura" memiliki tipe yang berbeda. `rawtype()` diperkenalkan untuk menyediakan cara yang andal untuk mendapatkan tipe aktual tanpa terpengaruh oleh kustomisasi perilaku ini.
  - **Sintaks Dasar**:
    ```lua
    local tipeAsli = rawtype(nilai_saya)
    ```
  - **Contoh Penggunaan (memerlukan Lua 5.4+ untuk `rawtype`)**:

    ```lua
    -- Contoh ini akan berfungsi seperti yang diharapkan di Lua 5.4+
    -- Di versi Lua sebelumnya, rawtype() tidak ada.

    local dataKu = {}
    local mt = {
        __type = function(obj)
            return "ObjekSpesial"
        end
    }
    setmetatable(dataKu, mt)

    print("type(dataKu):", type(dataKu))         -- Output di Lua yang mendukung __type: ObjekSpesial
                                               -- Output di Lua yang tidak mendukung __type atau jika mt.__type tidak ada: table
    -- Perilaku __type untuk fungsi type() bisa bervariasi interpretasinya antar versi minor Lua sebelum distandarisasi efeknya.
    -- Namun, konsep umumnya adalah __type bisa memodifikasi hasil type().

    -- Jika menggunakan Lua 5.4+
    -- print("rawtype(dataKu):", rawtype(dataKu))   -- Output: table

    -- Mari kita simulasikan untuk pemahaman, karena rawtype() lebih baru:
    -- Jika Lua 5.4+ tidak tersedia, Anda bisa membandingkan dengan perilaku getmetatable.
    -- Jika type(obj) berbeda dari yang diharapkan ("table" atau "userdata"), itu bisa jadi karena __type.

    local angka = 123
    -- print("rawtype(angka):", rawtype(angka)) -- Output: number (sama seperti type(angka))
    ```

- **Teknik Menggunakan `getmetatable()` dan `rawtype()`**:

  - **Identifikasi Tipe Userdata Kustom**: Saat bekerja dengan pustaka C, `userdata` seringkali memiliki _metatable_ tertentu yang mengidentifikasi jenisnya. Anda bisa mengambil _metatable_ dan membandingkannya dengan _metatable_ yang diketahui untuk menentukan tipe `userdata` secara spesifik.
    ```lua
    -- Asumsikan ada fungsi C yang membuat userdata dengan metatable spesifik 'MyLib.Widget.mt'
    -- local widget = myLib.newWidget()
    -- local mt_widget = getmetatable(widget)
    -- if mt_widget == MyLib.Widget.mt then
    --     print("Ini adalah objek Widget dari MyLib!")
    -- end
    ```
  - **Debugging Perilaku Metatable**: Jika perilaku tabel atau userdata aneh, `getmetatable()` adalah alat pertama untuk memeriksa _metatable_ apa (jika ada) yang terkait dengannya.
  - **Memastikan Tipe Fundamental**: `rawtype()` berguna dalam skenario di mana Anda perlu memastikan tipe dasar internal dari suatu nilai, terlepas dari apakah `__type` telah dioverride atau tidak. Ini penting untuk logika internal atau pustaka tingkat rendah yang tidak boleh tertipu oleh _overriding_ `type()`.

- **Sumber**:
  - Manual Lua adalah referensi utama untuk `getmetatable` dan `rawtype` (jika Anda melihat manual versi 5.4 atau lebih baru).
  - Komunitas Lua Wiki sering membahas penggunaan _metatables_ dan inspeksi tipe.

Ini adalah pengantar untuk fondasi sistem tipe di Lua. Memahami konsep-konsep ini akan sangat membantu Anda saat kita melangkah ke tipe data spesifik dan fitur-fitur yang lebih canggih.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[sebelumnya]: ../../string/bagian-7/README.md
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
