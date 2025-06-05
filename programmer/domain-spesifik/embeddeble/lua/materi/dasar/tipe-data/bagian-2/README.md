# **2. Tipe Data Primitif - _Deep Dive_**

Tipe data primitif adalah blok bangunan dasar dari data dalam Lua. Meskipun terlihat sederhana, pemahaman mendalam tentang masing-masing tipe ini, termasuk perilaku dan representasi internalnya, sangat penting untuk penguasaan Lua.

### **2.1 Tipe `nil` - Konsep Lanjutan**

Di Lua, `nil` adalah tipe data khusus yang hanya memiliki satu nilai, yaitu `nil` itu sendiri. Nilai `nil` digunakan untuk merepresentasikan ketiadaan atau "tidak ada nilai". Ini berbeda dari, misalnya, angka nol atau string kosong, yang merupakan nilai aktual.

#### **Semantik `nil` dan _Hole Semantics_**

- **Semantik `nil`**:

  - **Deskripsi**: `nil` digunakan untuk menandakan bahwa sebuah variabel belum diinisialisasi, atau bahwa suatu data tidak ada atau tidak valid. Variabel global yang belum diberi nilai akan secara otomatis memiliki nilai `nil`. Memberikan `nil` ke sebuah variabel global sama dengan menghapusnya (meskipun ini lebih ke efek samping dari bagaimana tabel global bekerja).
  - **Kegunaan Utama**:

    1.  **Representasi Ketiadaan**: Sebagai penanda bahwa data tidak ada.
    2.  **Penghapusan _Field_ Tabel**: Menetapkan `nil` ke sebuah _key_ dalam tabel akan menghapus _key_ dan nilainya dari tabel tersebut.
    3.  **Nilai _Return Default_**: Fungsi dapat mengembalikan `nil` untuk menandakan kegagalan atau ketiadaan hasil.

  - **Contoh Penggunaan `nil`**:

    ```lua
    local variabelBelumAda
    print(type(variabelBelumAda)) -- Output: nil
    print(variabelBelumAda)       -- Output: nil

    variabelBelumAda = 10
    print(type(variabelBelumAda)) -- Output: number
    print(variabelBelumAda)       -- Output: 10

    variabelBelumAda = nil        -- Menetapkan kembali ke nil
    print(type(variabelBelumAda)) -- Output: nil
    print(variabelBelumAda)       -- Output: nil

    -- Contoh pada tabel
    local dataPengguna = { nama = "Andi", usia = 30 }
    print(dataPengguna.kota)      -- Output: nil (karena field 'kota' tidak ada)

    dataPengguna.pekerjaan = "Programmer"
    print(dataPengguna.pekerjaan) -- Output: Programmer

    dataPengguna.pekerjaan = nil  -- Menghapus field 'pekerjaan' dari tabel
    print(dataPengguna.pekerjaan) -- Output: nil
    -- Sekarang, jika Anda iterasi tabel, 'pekerjaan' tidak akan muncul.
    ```

    - **Penjelasan Sintaksis**:
      - `local variabelBelumAda`: Variabel lokal dideklarasikan tanpa nilai awal, sehingga otomatis bernilai `nil`.
      - `dataPengguna = { nama = "Andi", usia = 30 }`: Inisialisasi tabel dengan _key-value pairs_.
        - `nama = "Andi"`: _Key_ `nama` (sebuah string) diberi nilai string `"Andi"`.
      - `dataPengguna.kota`: Akses _field_ `kota` dari tabel `dataPengguna` menggunakan notasi titik (`.`). Jika _field_ tidak ada, hasilnya `nil`.
      - `dataPengguna.pekerjaan = nil`: Menetapkan nilai `nil` ke _field_ `pekerjaan`. Ini secara efektif menghapus pasangan _key-value_ `pekerjaan` dari tabel `dataPengguna`.

- **_Hole Semantics_ (Semantik Lubang) pada Tabel**:

  - **Deskripsi**: Ketika kita berbicara tentang "lubang" (_holes_) dalam konteks tabel Lua (yang diimplementasikan sebagai _array_ dan/atau _hash map_), `nil` memainkan peran kunci. Lua tidak memperbolehkan penyimpanan nilai `nil` secara eksplisit _di dalam bagian array_ dari sebuah tabel jika nilai `nil` tersebut akan menciptakan "lubang" yang memutuskan urutan sekuensial.
  - Maksudnya, operator panjang (`#`) dan fungsi seperti `ipairs` bekerja berdasarkan asumsi bahwa bagian _array_ (indeks numerik berurutan mulai dari 1) tidak memiliki `nil` di tengahnya. `nil` pertama yang ditemui menandakan akhir dari bagian sekuensial _array_.
  - **Perilaku dengan `ipairs` dan `#`**:

    - `ipairs`: Berhenti melakukan iterasi pada indeks numerik pertama yang nilainya `nil`.
    - Operator `#` (panjang): Mengembalikan panjang dari bagian sekuensial _array_ yang tidak terputus oleh `nil`. Perilakunya tidak terdefinisi jika ada _holes_ (nilai `nil`) di antara indeks numerik positif. Lebih tepatnya, Lua 5.1 dan seterusnya mendefinisikan `#t` sebagai "satu kurang dari indeks integer positif pertama yang `nil`, atau nol jika `t[1]` adalah `nil`." Ini berarti `nil` menandai batas.

  - **Contoh _Hole Semantics_**:

    ```lua
    local arrayKu = { "a", "b", "c" }
    print("Panjang arrayKu:", #arrayKu) -- Output: Panjang arrayKu: 3
    for i, v in ipairs(arrayKu) do
        print(i, v)
        -- Output:
        -- 1   a
        -- 2   b
        -- 3   c
    end

    local arrayDenganLubang = { "x", "y", nil, "z" }
    print("Panjang arrayDenganLubang:", #arrayDenganLubang) -- Output bisa 1, 2, atau tidak terdefinisi sesuai standar,
                                                          -- namun implementasi Lua cenderung menganggap batas di 'nil' pertama.
                                                          -- Di Lua 5.1+, ini akan menjadi 2.
                                                          -- (Manual 5.4 section 3.4.7 describes length operator)
    print("arrayDenganLubang[3] adalah:", arrayDenganLubang[3]) -- Output: arrayDenganLubang[3] adalah: nil

    print("Iterasi dengan ipairs pada arrayDenganLubang:")
    for i, v in ipairs(arrayDenganLubang) do
        print(i, v)
        -- Output:
        -- 1   x
        -- 2   y
        -- ipairs berhenti karena arrayDenganLubang[3] adalah nil
    end

    -- Untuk mengiterasi semua elemen termasuk yang setelah nil (jika ada bagian hash), gunakan pairs()
    print("Iterasi dengan pairs pada arrayDenganLubang:")
    for k, v in pairs(arrayDenganLubang) do
        print(k, v)
        -- Output akan mencakup semua elemen yang ada, termasuk 'z' di indeks 4 jika struktur internal menyimpannya.
        -- 1   x
        -- 2   y
        -- 4   z
        -- (Elemen dengan nilai nil, seperti indeks 3, tidak disimpan sebagai key-value pair, jadi tidak diiterasi oleh pairs)
    end
    ```

    - **Penjelasan Sintaksis**:
      - `#arrayKu`: Operator panjang. Digunakan untuk mendapatkan ukuran dari bagian _array_ sekuensial dari sebuah tabel.
      - `for i, v in ipairs(arrayKu) do ... end`: Loop `for` generik menggunakan iterator `ipairs`. `ipairs` mengiterasi pasangan indeks-nilai (integer, value) dalam tabel, mulai dari indeks 1, selama nilainya bukan `nil`.
        - `i`: Variabel untuk menyimpan indeks.
        - `v`: Variabel untuk menyimpan nilai.
        - `in ipairs(arrayKu)`: Menentukan bahwa loop akan menggunakan iterator yang dikembalikan oleh `ipairs(arrayKu)`.
      - `for k, v in pairs(arrayDenganLubang) do ... end`: Loop `for` generik menggunakan iterator `pairs`. `pairs` mengiterasi semua pasangan _key-value_ dalam tabel, termasuk bagian _hash_ dan bagian _array_ (tanpa urutan tertentu untuk bagian _hash_). Ia tidak akan mengembalikan _key_ yang nilainya `nil` karena `nil` menandakan ketiadaan _key_.

  - **Implikasi**: Jika Anda perlu menyimpan `nil` sebagai nilai yang valid dalam sebuah _array_ (misalnya, untuk merepresentasikan slot kosong yang berbeda dari "tidak ada slot sama sekali"), Anda tidak bisa menggunakan `nil` secara langsung jika ingin mempertahankan perilaku standar `#` dan `ipairs`. Solusinya adalah menggunakan _placeholder_ lain, seperti tabel khusus `false` (jika `false` tidak digunakan untuk hal lain).

- **Sumber**:
  - Dasar-dasar tipe `nil` dan penggunaannya dijelaskan di banyak sumber.
  - Perilaku `nil` dalam tabel sangat penting untuk dipahami.

---

#### **Pola _Nil Coalescing_ dan Praktik Terbaik**

- **_Nil Coalescing_ (Penggabungan `nil`)**:

  - **Deskripsi**: _Nil coalescing_ adalah pola di mana Anda menyediakan nilai _default_ jika suatu ekspresi atau variabel menghasilkan `nil`. Lua tidak memiliki operator _nil-coalescing_ khusus seperti `??` di beberapa bahasa lain (misalnya, C# atau Swift). Namun, perilaku operator `or` di Lua sangat cocok untuk mencapai ini.
  - **Operator `or`**: Di Lua, operator `or` bekerja sebagai berikut:

    - Jika operand kirinya tidak `false` dan tidak `nil` (yaitu, "truthy"), maka `or` mengembalikan operand kiri tersebut tanpa mengevaluasi operand kanan.
    - Jika operand kirinya `false` atau `nil` (yaitu, "falsy"), maka `or` mengembalikan operand kanannya (apapun nilainya).

  - **Pola Umum**:

    ```lua
    local nilaiSebenarnya = mungkinNil atau nilaiDefault
    ```

    - **Penjelasan Sintaksis**:
      - `atau`: Ini adalah representasi kata kunci `or` dalam bahasa Indonesia seperti yang Anda gunakan di contoh lain. Dalam Lua standar, kata kuncinya adalah `or`. Saya akan menggunakan `or` untuk konsistensi dengan Lua.
      - `local nilaiSebenarnya = mungkinNil or nilaiDefault`:
        - `mungkinNil`: Variabel atau ekspresi yang bisa jadi `nil`.
        - `or`: Operator logika.
        - `nilaiDefault`: Nilai yang akan digunakan jika `mungkinNil` adalah `nil` atau `false`.
        - `nilaiSebenarnya`: Akan mendapatkan nilai `mungkinNil` jika `mungkinNil` bukan `nil` dan bukan `false`. Jika `mungkinNil` adalah `nil` atau `false`, `nilaiSebenarnya` akan mendapatkan `nilaiDefault`.

  - **Contoh Penggunaan**:

    ```lua
    function sapaPengguna(nama)
        local namaSapaan = nama or "Pengguna" -- Jika 'nama' nil atau false, gunakan "Pengguna"
        print("Halo, " .. namaSapaan .. "!")
    end

    sapaPengguna("Alice")   -- Output: Halo, Alice!
    sapaPengguna(nil)       -- Output: Halo, Pengguna!
    sapaPengguna()          -- Output: Halo, Pengguna! (argumen yang tidak diberikan otomatis nil)
    sapaPengguna(false)     -- Output: Halo, Pengguna! (penting diingat, 'false' juga memicu 'or')

    local konfigurasi = { port = 8080 }
    local portDigunakan = konfigurasi.port or 3000
    local hostDigunakan = konfigurasi.host or "127.0.0.1" -- konfigurasi.host adalah nil

    print("Port:", portDigunakan) -- Output: Port: 8080
    print("Host:", hostDigunakan) -- Output: Host: 127.0.0.1
    ```

    - **Penjelasan Sintaksis**:
      - `function sapaPengguna(nama) ... end`: Mendefinisikan fungsi bernama `sapaPengguna` yang menerima satu argumen `nama`.
      - `local namaSapaan = nama or "Pengguna"`: Pola _nil coalescing_ menggunakan `or`. Jika `nama` adalah `nil` (atau `false`), `namaSapaan` akan menjadi `"Pengguna"`.
      - `..`: Operator konkatenasi (penggabungan) string.
      - `sapaPengguna()`: Memanggil fungsi tanpa argumen. Argumen `nama` di dalam fungsi akan menjadi `nil`.

  - **Perhatian dengan `false`**: Karena `or` juga akan memilih operand kanan jika operand kiri adalah `false`, pola ini mungkin tidak selalu diinginkan jika `false` adalah nilai valid yang ingin Anda pertahankan. Jika Anda hanya ingin mengganti `nil` dan bukan `false`:

    ```lua
    local nilaiInput -- bisa jadi nil, false, atau nilai lain

    -- Hanya ganti jika nil
    local nilaiEfektif
    if nilaiInput == nil then
        nilaiEfektif = nilaiDefault
    else
        nilaiEfektif = nilaiInput
    end

    -- Atau, lebih ringkas (menggunakan fakta bahwa "a and b or c" mirip operator ternary, tapi hati-hati jika b bisa false)
    -- Pola yang lebih aman untuk "jika x nil maka y selain itu x" adalah:
    local nilaiEfektif = (nilaiInput == nil) and nilaiDefault or nilaiInput
    -- Namun ini bisa salah jika nilaiDefault sendiri adalah false/nil dan nilaiInput juga false/nil.
    -- Cara paling eksplisit dan aman jika 'false' harus dipertahankan:
    local nilaiDefault = "DefaultVal"
    local inputPengguna = false -- contoh input yang valid tapi 'falsy'

    -- Menggunakan 'or' akan salah jika 'false' adalah nilai valid yang ingin dipertahankan
    local hasilSalah = inputPengguna or nilaiDefault -- hasilSalah akan menjadi "DefaultVal"

    -- Cara yang benar jika false ingin dipertahankan
    local hasilBenar
    if inputPengguna == nil then
      hasilBenar = nilaiDefault
    else
      hasilBenar = inputPengguna -- akan menjadi 'false' di sini
    end
    print("Hasil Salah:", hasilSalah)
    print("Hasil Benar:", hasilBenar)
    ```

    Untuk kasus _nil coalescing_ yang ketat (hanya mengganti `nil`), pemeriksaan eksplisit `if x == nil then ...` adalah yang paling jelas dan aman.

- **Praktik Terbaik Terkait `nil`**:

  1.  **Inisialisasi Variabel Lokal**: Selalu inisialisasi variabel lokal. Jika tidak ada nilai awal yang berarti, inisialisasi ke `nil` secara eksplisit bisa meningkatkan kejelasan, meskipun Lua melakukannya secara implisit.
      ```lua
      local dataSaya = nil -- Lebih eksplisit
      -- ... kemudian diisi nanti
      ```
  2.  **Gunakan `nil` untuk Menghapus _Field_ Tabel**: Ini adalah cara idiomatis dan efisien untuk menghapus entri dari tabel.
      ```lua
      myTable.optionalField = nil -- Menghapus optionalField
      ```
  3.  **Hati-hati dengan `nil` dalam _Array_**: Seperti yang dibahas dalam _hole semantics_, hindari `nil` di tengah _array_ jika Anda bergantung pada `#` atau `ipairs` untuk perilaku sekuensial. Gunakan _placeholder_ jika perlu.
  4.  **Fungsi yang Mengembalikan Status**: Jika fungsi bisa gagal atau tidak menghasilkan nilai yang valid, mengembalikan `nil` (seringkali diikuti oleh pesan error sebagai nilai _return_ kedua) adalah pola umum.

      ```lua
      function cobaDapatkanData(id)
          if dataAdaUntuk(id) then
              return ambilData(id)
          else
              return nil, "Data tidak ditemukan untuk ID: " .. tostring(id)
          end
      end

      local data, err = cobaDapatkanData(123)
      if not data then
          print("Error:", err)
      else
          -- proses data
      end
      ```

  5.  **Pahami Perbedaan `nil` dan `false` dalam Kondisi**: Keduanya dievaluasi sebagai _falsy_ dalam kondisi, tetapi mereka adalah nilai yang berbeda (`nil ~= false`). Gunakan operator `or` untuk _nil coalescing_ dengan kesadaran bahwa ia juga akan mengganti `false`.

- **Sumber**:
  - Penggunaan `or` untuk nilai _default_ adalah pola umum yang didokumentasikan di komunitas.
  - Praktik terbaik seputar `nil` seringkali dipelajari melalui pengalaman dan diskusi komunitas.

---

### **2.2 Tipe Boolean - Sistem _Truthiness_**

Tipe boolean di Lua sangat sederhana: ia hanya memiliki dua nilai, `true` dan `false`. Namun, yang penting adalah bagaimana Lua memperlakukan nilai-nilai lain dalam konteks boolean (konsep _truthiness_).

#### **Aturan Konversi Boolean dan Kasus Tepi (_Edge Cases_)**

- **Aturan _Truthiness_ di Lua**:

  - **Deskripsi**: Dalam konteks di mana ekspresi boolean diharapkan (misalnya, dalam pernyataan `if`, kondisi `while`, operand untuk `and`, `or`, `not`), Lua memiliki aturan sederhana untuk menentukan apakah suatu nilai dianggap "truthy" (benar) atau "falsy" (salah).
  - **Aturan Utama**: Di Lua, **hanya `false` dan `nil` yang dianggap _falsy_**.
  - **Semua nilai lain dianggap _truthy_**. Ini termasuk:
    - Angka `0` (nol) adalah _truthy_.
    - String kosong `""` adalah _truthy_.
    - Tabel kosong `{}` adalah _truthy_.
    - Fungsi adalah _truthy_.

- **Contoh Aturan Konversi (Truthiness)**:

  ```lua
  if true then print("true adalah truthy") end        -- Output: true adalah truthy
  if false then print("false adalah truthy") else print("false adalah falsy") end -- Output: false adalah falsy
  if nil then print("nil adalah truthy") else print("nil adalah falsy") end    -- Output: nil adalah falsy

  if 0 then print("0 adalah truthy") end              -- Output: 0 adalah truthy
  if 1 then print("1 adalah truthy") end              -- Output: 1 adalah truthy
  if "" then print("String kosong adalah truthy") end -- Output: String kosong adalah truthy
  if "hello" then print("'hello' adalah truthy") end  -- Output: 'hello' adalah truthy
  if {} then print("Tabel kosong adalah truthy") end  -- Output: Tabel kosong adalah truthy
  if function() end then print("Fungsi adalah truthy") end -- Output: Fungsi adalah truthy
  ```

  - **Penjelasan Sintaksis**:
    - `if kondisi then ... end`: Struktur kondisional dasar. Blok kode setelah `then` dieksekusi jika `kondisi` dievaluasi menjadi _truthy_.
    - `if kondisi then ... else ... end`: Jika `kondisi` _truthy_, blok pertama dieksekusi. Jika `kondisi` _falsy_, blok setelah `else` dieksekusi.

- **Kasus Tepi (_Edge Cases_) dan Perbandingan dengan Bahasa Lain**:

  - **Angka `0`**: Banyak bahasa (seperti C, Python, JavaScript) memperlakukan angka `0` sebagai _falsy_. Di Lua, `0` adalah _truthy_. Ini adalah sumber kebingungan umum bagi pemrogram yang datang dari bahasa lain.

    ```lua
    local hitungan = 0
    if hitungan then -- Ini akan selalu true karena 0 adalah truthy
        print("Hitungan memiliki nilai (truthy).")
    else
        -- Blok ini tidak akan pernah tercapai dengan kondisi 'if hitungan'
        print("Hitungan adalah falsy.")
    end

    -- Cara yang benar untuk memeriksa apakah hitungan adalah nol:
    if hitungan == 0 then
        print("Hitungan adalah nol.")
    end
    ```

  - **String Kosong `""`**: Sama seperti angka `0`, string kosong `""` juga _truthy_ di Lua, berbeda dengan beberapa bahasa lain yang menganggapnya _falsy_.

    ```lua
    local namaPengguna = ""
    if namaPengguna then -- Ini akan true
        print("namaPengguna memiliki nilai (truthy).")
    end

    -- Cara yang benar untuk memeriksa string kosong:
    if namaPengguna == "" then
        print("namaPengguna adalah string kosong.")
    end
    ```

  - **Tidak Ada Konversi Implisit ke Boolean**: Lua tidak secara otomatis mengkonversi nilai ke `true` atau `false` kecuali dalam konteks boolean. Fungsi `type()` akan selalu mengembalikan tipe asli (`"number"`, `"string"`, dll.), bukan `"boolean"`, kecuali nilainya memang `true` atau `false`.

- **Mengapa Aturan Ini?**

  - Kesederhanaan: Aturan "hanya `false` dan `nil` yang _falsy_" mudah diingat dan konsisten.
  - Menghindari Ambiguitas: Tidak perlu khawatir apakah `0`, `0.0`, `""`, atau `[]` (array kosong di bahasa lain) akan berperilaku sebagai `false`.

- **Sumber**:
  - Dokumentasi dan tutorial Lua menjelaskan aturan _truthiness_ ini. Memahaminya sangat penting untuk menulis logika kondisional yang benar.

---

#### **Evaluasi Kondisional dan Logika _Short-Circuit_**

Operator logika di Lua (`and`, `or`, `not`) tidak hanya bekerja dengan nilai boolean `true` dan `false` tetapi juga memanfaatkan aturan _truthiness_ dan menerapkan evaluasi _short-circuit_.

- **Operator `not`**:

  - **Deskripsi**: Mengembalikan kebalikan boolean dari operandnya. Jika operand adalah _truthy_, `not` mengembalikan `false`. Jika operand adalah _falsy_ (`false` atau `nil`), `not` mengembalikan `true`. Hasil dari `not` selalu `true` atau `false`.
  - **Sintaks**: `not ekspresi`
  - **Contoh**:
    ```lua
    print(not true)     -- Output: false
    print(not false)    -- Output: true
    print(not nil)      -- Output: true
    print(not 0)        -- Output: false (karena 0 truthy)
    print(not "")       -- Output: false (karena "" truthy)
    print(not {})       -- Output: false (karena {} truthy)
    ```

- **Operator `and`**:

  - **Deskripsi**: Jika operand kiri (`a`) bernilai _falsy_ (`false` atau `nil`), `and` mengembalikan operand kiri tersebut dan operand kanan (`b`) tidak dievaluasi (ini adalah _short-circuiting_). Jika operand kiri (`a`) bernilai _truthy_, maka `and` mengembalikan operand kanan (`b`).
  - **Sintaks**: `a and b`
  - **Perilaku**:
    - `falsy_value and x` -> `falsy_value` (x tidak dievaluasi)
    - `truthy_value and x` -> `x`
  - **Contoh**:

    ```lua
    local function fungsiMahal()
        print("Fungsi Mahal Dipanggil!")
        return true
    end

    local hasil1 = false and fungsiMahal() -- fungsiMahal() TIDAK akan dipanggil
    print("Hasil1:", hasil1)               -- Output: Hasil1: false

    local hasil2 = true and fungsiMahal()  -- fungsiMahal() AKAN dipanggil
    print("Hasil2:", hasil2)               -- Output: Fungsi Mahal Dipanggil!
                                           --         Hasil2: true

    local pengguna = { nama = "Budi", umur = 25 }
    -- Ambil nama jika pengguna ada dan namanya ada
    local namaPengguna = pengguna and pengguna.nama
    print("Nama Pengguna:", namaPengguna) -- Output: Nama Pengguna: Budi

    pengguna = nil
    namaPengguna = pengguna and pengguna.nama -- pengguna.nama tidak akan dievaluasi karena pengguna adalah nil
    print("Nama Pengguna (setelah nil):", namaPengguna) -- Output: Nama Pengguna (setelah nil): nil
    ```

    - **Penjelasan `namaPengguna = pengguna and pengguna.nama`**:
      - Jika `pengguna` adalah `nil` (falsy), ekspresi `pengguna and ...` akan langsung mengembalikan `nil` (nilai dari `pengguna`) tanpa mencoba mengakses `pengguna.nama` (yang akan menyebabkan error jika `pengguna` adalah `nil`). Ini adalah cara aman untuk mengakses _nested properties_.

- **Operator `or`**:

  - **Deskripsi**: Jika operand kiri (`a`) bernilai _truthy_, `or` mengembalikan operand kiri tersebut dan operand kanan (`b`) tidak dievaluasi (_short-circuiting_). Jika operand kiri (`a`) bernilai _falsy_ (`false` atau `nil`), maka `or` mengembalikan operand kanan (`b`).
  - **Sintaks**: `a or b`
  - **Perilaku**:
    - `truthy_value or x` -> `truthy_value` (x tidak dievaluasi)
    - `falsy_value or x` -> `x`
  - **Contoh**:

    ```lua
    local function fungsiLain()
        print("Fungsi Lain Dipanggil!")
        return "nilai default dari fungsi"
    end

    local hasil3 = true or fungsiLain()   -- fungsiLain() TIDAK akan dipanggil
    print("Hasil3:", hasil3)              -- Output: Hasil3: true

    local hasil4 = nil or fungsiLain()    -- fungsiLain() AKAN dipanggil
    print("Hasil4:", hasil4)              -- Output: Fungsi Lain Dipanggil!
                                          --         Hasil4: nilai default dari fungsi

    local namaPanggilan = dapatkanNamaPanggilan() or "Kawan" -- Jika dapatkanNamaPanggilan() mengembalikan nil/false
    print("Sapa,", namaPanggilan)
    ```

    - **Penjelasan `namaPanggilan = dapatkanNamaPanggilan() or "Kawan"`**:
      - Jika `dapatkanNamaPanggilan()` mengembalikan nilai _truthy_ (misalnya, sebuah string nama), `namaPanggilan` akan mendapatkan nilai tersebut. `fungsiLain()` tidak dipanggil.
      - Jika `dapatkanNamaPanggilan()` mengembalikan `nil` atau `false`, `namaPanggilan` akan mendapatkan nilai `"Kawan"`.

- **Manfaat _Short-Circuit Logic_**:

  1.  **Performa**: Menghindari eksekusi kode yang tidak perlu atau mahal jika hasilnya sudah dapat ditentukan.
      ```lua
      if cekKondisiSederhana() and cekKondisiKompleks() then
          -- cekKondisiKompleks() hanya dipanggil jika cekKondisiSederhana() true
      end
      ```
  2.  **Keamanan**: Mencegah error akibat mencoba operasi pada nilai `nil`.
      ```lua
      if tabelSaya and tabelSaya.field and tabelSaya.field.subfield == "nilai" then
          -- Aman, karena evaluasi berhenti jika salah satu bagian adalah nil
      end
      ```
  3.  **Idiom Ringkas**: Memungkinkan penulisan kode yang lebih ringkas untuk nilai _default_ (menggunakan `or`) atau penjagaan kondisi (menggunakan `and`).

- **Pola Operator Ternary Semu**:
  Kombinasi `and` dan `or` sering digunakan untuk meniru operator ternary (`kondisi ? nilai_jika_benar : nilai_jika_salah`) yang ada di bahasa lain. Pola umumnya adalah: `kondisi and nilai_jika_benar or nilai_jika_salah`.

  ```lua
  local usia = 20
  local status = (usia >= 18) and "Dewasa" or "Anak-anak"
  print("Status:", status) -- Output: Status: Dewasa

  local inputValid = true
  local hasilRender = inputValid and "Data Valid" or "Data Error"
  print(hasilRender) -- Output: Data Valid
  ```

  - **Peringatan Penting**: Pola `a and b or c` ini memiliki **masalah jika `b` (nilai_jika_benar) bisa menjadi `false` atau `nil`**. Jika `kondisi` benar dan `nilai_jika_benar` adalah `false` atau `nil`, maka `kondisi and nilai_jika_benar` akan menghasilkan `nilai_jika_benar` (yang _falsy_), menyebabkan bagian `or nilai_jika_salah` dievaluasi, sehingga Anda mendapatkan `nilai_jika_salah` padahal seharusnya `nilai_jika_benar`.

    ````lua
    local kondisi = true
    local nilaiBenar = false -- Ini adalah nilai 'falsy'
    local nilaiSalah = "Salah"

        local hasil = kondisi and nilaiBenar or nilaiSalah
        print("Hasil (dengan bug potensial):", hasil) -- Output: Hasil (dengan bug potensial): Salah (BUG!)
                                                       -- Seharusnya 'false' (nilaiBenar)

        -- Cara yang lebih aman dan eksplisit adalah menggunakan if-else:
        local hasilAman
        if kondisi then
            hasilAman = nilaiBenar
        else
            hasilAman = nilaiSalah
        end
        print("Hasil Aman:", hasilAman) -- Output: Hasil Aman: false
        ```

    Jadi, meskipun umum, gunakan pola `a and b or c` dengan hati-hati dan sadar akan batasan ini.
    ````

- **Sumber**:
  - "Programming in Lua" (PIL) membahas evaluasi _short-circuit_.
  - Komunitas Lua Wiki juga memiliki penjelasan tentang logika boolean.

---

### **2.3 Tipe `number` - Representasi Internal**

Tipe `number` di Lua digunakan untuk merepresentasikan semua jenis angka, termasuk bilangan bulat (integer) dan bilangan riil (pecahan/desimal). Memahami bagaimana Lua menangani angka di balik layar sangat penting untuk menulis kode yang akurat secara matematis dan beperforma tinggi.

#### **Implementasi _IEEE 754 Double Precision_**

- **Deskripsi**: Secara historis, dan masih menjadi dasar utama, tipe `number` di Lua diimplementasikan menggunakan format **_double-precision floating-point_** sesuai dengan standar **IEEE 754**.

  - **Terminologi**:
    - **IEEE 754**: Ini adalah standar teknis yang paling banyak digunakan untuk komputasi _floating-point_. Standar ini mendefinisikan format angka (termasuk bagaimana mereka disimpan dalam bit), operasi aritmetika, dan nilai-nilai khusus seperti _infinity_ dan _NaN_.
    - **_Floating-Point_**: Sebuah cara untuk merepresentasikan angka riil (termasuk desimal) dalam format yang dapat mendukung rentang nilai yang sangat luas, baik sangat besar maupun sangat kecil. Angka ini direpresentasikan dalam bentuk semacam notasi ilmiah biner, yaitu `sign * mantissa * 2^exponent`.
    - **_Double Precision_**: Ini berarti setiap angka `number` di Lua disimpan menggunakan **64 bit** memori. Representasi 64-bit ini memberikan rentang nilai dan presisi yang sangat besar, cukup untuk hampir semua kebutuhan komputasi umum, mulai dari game hingga aplikasi ilmiah.

- **Representasi 64-bit**:
  Memori 64-bit untuk sebuah angka _double-precision_ dibagi menjadi tiga bagian:

  1.  **_Sign bit_ (1 bit)**: Menentukan apakah angka tersebut positif atau negatif.
  2.  **_Exponent_ (11 bit)**: Menentukan besarnya (skala) angka.
  3.  **_Mantissa_ atau _Fraction_ (52 bit)**: Menentukan digit-digit presisi dari angka tersebut.

- **Implikasi**:

  - **Satu Tipe Angka**: Sebelum Lua 5.3, tidak ada perbedaan internal antara bilangan bulat dan bilangan desimal. Angka `10` dan `10.0` disimpan dengan cara yang sama, yaitu sebagai _double-precision float_.
  - **Rentang Nilai Luas**: _Double-precision_ dapat menyimpan angka hingga sekitar $\pm1.8 \times 10^{308}$.
  - **Presisi Terbatas**: Meskipun presisinya tinggi, ia tetap terbatas. Ia dapat secara akurat merepresentasikan semua bilangan bulat hingga $2^{53}$ (sekitar 9 kuadriliun). Di atas nilai ini, tidak semua bilangan bulat dapat direpresentasikan dengan tepat, dan "celah" akan mulai muncul di antara bilangan bulat yang dapat direpresentasikan.

- **Contoh dalam Kode**:

  ```lua
  local a = 10
  local b = 10.0
  local c = 10.5

  -- Sebelum Lua 5.3, a dan b akan identik secara internal.
  -- Di Lua 5.3+, a kemungkinan akan disimpan sebagai integer, sementara b dan c sebagai float.
  -- Namun, perilakunya dalam operasi aritmetika tetap konsisten.

  print(type(a)) -- Output: number
  print(type(b)) -- Output: number
  print(type(c)) -- Output: number

  -- Contoh notasi ilmiah (eksponensial)
  local angkaBesar = 3.14e20  -- Sama dengan 3.14 * 10^20
  local angkaKecil = 5e-10   -- Sama dengan 5 * 10^-10

  print(angkaBesar)
  print(angkaKecil)
  ```

  - **Penjelasan Sintaksis**:
    - `3.14e20`: Notasi `e` digunakan untuk eksponen basis 10. `eN` berarti "dikalikan 10 pangkat N". Ini adalah cara standar untuk menulis angka yang sangat besar atau sangat kecil.

- **Sumber**:
  - Manual Lua mengonfirmasi penggunaan format angka default (secara historis _double_).
  - Banyak tutorial memberikan gambaran umum tentang tipe data ini.

---

#### **_Subtype_ Integer di Lua 5.3+**

- **Deskripsi**: Dimulai dari versi **Lua 5.3**, tipe `number` diperluas dengan _subtype_ (sub-tipe) **integer**. Ini adalah perubahan signifikan yang memungkinkan Lua untuk merepresentasikan bilangan bulat secara terpisah dari _floating-point_, membawa beberapa keuntungan.

  - **Terminologi**:
    - **Integer**: Bilangan bulat (tanpa komponen desimal). Di Lua, ini adalah integer bertanda (bisa positif atau negatif) dengan ukuran **64-bit**.
    - **Float**: Sub-tipe untuk merepresentasikan angka _floating-point_, tetap menggunakan _double-precision_ 64-bit IEEE 754.

- **Bagaimana Cara Kerjanya?**:

  - **Representasi Otomatis**: Lua secara otomatis menggunakan representasi integer untuk angka yang tidak memiliki bagian desimal dan berada dalam rentang integer 64-bit. Jika angka memiliki desimal, atau hasil operasi aritmetika menghasilkan desimal, Lua akan otomatis menggunakan representasi _float_.
  - **Promosi Otomatis**: Ketika operasi aritmetika dilakukan antara _integer_ dan _float_, _integer_ akan "dipromosikan" menjadi _float_ sebelum operasi dilakukan, dan hasilnya akan menjadi _float_.

- **Memeriksa Sub-tipe dengan `math.type`**:
  Fungsi `type()` akan tetap mengembalikan `"number"` untuk kedua sub-tipe tersebut. Untuk membedakannya, Lua 5.3+ menyediakan fungsi `math.type`.

  - **Sintaks `math.type`**:
    ```lua
    math.type(nilai_angka)
    ```
    - **Penjelasan Sintaksis**:
      - `math.type`: Fungsi di dalam pustaka `math` untuk memeriksa sub-tipe angka.
      - `nilai_angka`: Variabel atau nilai angka yang ingin diperiksa.
  - **Nilai Kembali**:
    - `"integer"` jika nilai tersebut direpresentasikan sebagai integer.
    - `"float"` jika nilai tersebut direpresentasikan sebagai float.
    - `nil` jika nilai yang diberikan bukan `number`.

- **Contoh Perbedaan Integer dan Float**:

  ```lua
  -- Contoh ini paling baik dijalankan di Lua 5.3 atau yang lebih baru
  local angkaInt = 100
  local angkaFloat = 100.0
  local angkaDesimal = 100.5
  local hasilCampuran = angkaInt + angkaDesimal

  print("Sub-tipe dari angkaInt:", math.type(angkaInt))         -- Output: Sub-tipe dari angkaInt: integer
  print("Sub-tipe dari angkaFloat:", math.type(angkaFloat))     -- Output: Sub-tipe dari angkaFloat: float
  print("Sub-tipe dari angkaDesimal:", math.type(angkaDesimal)) -- Output: Sub-tipe dari angkaDesimal: float
  print("Hasil campuran:", hasilCampuran)                      -- Output: Hasil campuran: 200.5
  print("Sub-tipe hasilCampuran:", math.type(hasilCampuran))   -- Output: Sub-tipe hasilCampuran: float

  -- Contoh lain:
  local x = 5
  local y = 2
  local hasilBagi = x / y  -- Pembagian (/) selalu menghasilkan float
  local hasilBagiBulat = x // y -- Pembagian floor (//) diperkenalkan di Lua 5.3, menghasilkan integer
  print("Hasil bagi (/):", hasilBagi, "Tipe:", math.type(hasilBagi)) -- Output: Hasil bagi (/): 2.5   Tipe: float
  print("Hasil bagi (//):", hasilBagiBulat, "Tipe:", math.type(hasilBagiBulat)) -- Output: Hasil bagi (//): 2   Tipe: integer
  ```

  - **Penjelasan Sintaksis**:
    - `/`: Operator pembagian standar. Di Lua, ini selalu melakukan pembagian _floating-point_ dan hasilnya selalu _float_.
    - `//`: Operator _floor division_ (pembagian ke bawah). Diperkenalkan di Lua 5.3, ia melakukan pembagian dan membulatkan hasilnya ke bawah ke integer terdekat. Hasilnya selalu _integer_.

- **Keuntungan Sub-tipe Integer**:

  1.  **Presisi**: Operasi pada bilangan bulat besar (hingga 64-bit) dijamin tepat, tanpa risiko _rounding error_ yang ada pada _float_.
  2.  **Operasi Bitwise**: Lua 5.3 memperkenalkan operator _bitwise_ (`&` untuk AND, `|` untuk OR, `~` untuk XOR, `<<` untuk left shift, `>>` untuk right shift) yang beroperasi secara eksklusif pada _integer_.
  3.  **Potensi Performa**: Operasi aritmetika pada integer bisa lebih cepat pada beberapa arsitektur CPU dibandingkan operasi _float_.

- **Sumber**:
  - Manual Lua 5.4 adalah referensi definitif untuk perilaku sub-tipe angka.
  - Komunitas Lua Wiki memberikan konteks dan contoh tambahan tentang tipe integer.

---

#### **Masalah Presisi dan Aritmetika _Floating Point_**

- **Deskripsi**: Aritmetika _floating-point_, meskipun sangat berguna, memiliki keterbatasan inheren yang penting untuk dipahami: tidak semua angka desimal dapat direpresentasikan dengan sempurna dalam format biner. Ini mirip dengan bagaimana 1/3 tidak dapat ditulis secara penuh dalam desimal (0.3333...). Dalam biner, angka seperti `0.1` atau `0.2` juga menjadi pecahan berulang yang tak terbatas, sehingga harus dibulatkan.
- **_Rounding Errors_ (Kesalahan Pembulatan)**:
  Pembulatan ini menyebabkan kesalahan kecil yang bisa menumpuk dan menyebabkan hasil yang tidak terduga, terutama saat membandingkan angka _float_ untuk kesetaraan.

  - **Contoh Klasik**:

    ```lua
    local a = 0.1
    local b = 0.2
    local hasil = a + b

    print(string.format("a + b = %.17f", hasil)) -- Mencetak dengan presisi tinggi
    -- Output: a + b = 0.30000000000000004

    if hasil == 0.3 then
        print("Hasilnya adalah 0.3")
    else
        print("Hasilnya BUKAN 0.3") -- Output ini yang akan tercetak!
    end
    ```

    - **Penjelasan Sintaksis**:
      - `string.format(format_string, ...)`: Fungsi dari pustaka `string` yang memformat string sesuai dengan aturan yang diberikan, mirip dengan `printf` di C.
        - `%.17f`: Aturan format untuk mencetak angka _float_ (`f`) dengan 17 digit di belakang koma. Ini berguna untuk "mengintip" representasi internal yang tidak presisi.

- **Praktik Terbaik untuk Menangani _Floats_**:

  1.  **Hindari Perbandingan Kesetaraan Langsung**: Jangan pernah membandingkan dua angka _float_ menggunakan `==` jika salah satunya adalah hasil dari kalkulasi.
  2.  **Gunakan Toleransi (_Epsilon_)**: Sebagai gantinya, periksa apakah selisih absolut antara kedua angka lebih kecil dari nilai toleransi yang sangat kecil (sering disebut _epsilon_).

      ```lua
      local a = 0.1 + 0.2
      local b = 0.3

      local epsilon = 1e-10 -- Toleransi yang sangat kecil

      if math.abs(a - b) < epsilon then
          print("a dan b dianggap sama.") -- Output ini yang akan tercetak
      else
          print("a dan b berbeda.")
      end
      ```

      - **Penjelasan Sintaksis**:
        - `math.abs(x)`: Fungsi dari pustaka `math` yang mengembalikan nilai absolut (nilai tanpa tanda negatif) dari `x`.

  3.  **Gunakan Integer Jika Memungkinkan**: Jika Anda bekerja dengan data yang seharusnya bersifat diskrit (misalnya, jumlah uang dalam sen, bukan dolar), simpan sebagai integer untuk menghindari masalah presisi.
  4.  **Waspada Penumpukan Error**: Dalam loop atau kalkulasi yang panjang, kesalahan pembulatan kecil dapat menumpuk menjadi besar. Sadari hal ini saat merancang algoritma numerik.

- **Sumber**:
  - Komunitas Lua Wiki memiliki artikel bagus tentang masalah _floating point_.
  - Buku "Programming in Lua" (PIL) juga memberikan nasihat praktis tentang menangani angka.

---

#### **Konstanta Matematis dan Nilai Spesial (`NaN`, _Infinity_)**

Standar IEEE 754 juga mendefinisikan nilai-nilai khusus untuk menangani situasi matematis yang tidak biasa, seperti hasil pembagian dengan nol. Lua menyediakan akses ke nilai-nilai ini melalui pustaka `math`.

- **_Infinity_ (Tak Terhingga)**:

  - **Deskripsi**: Mewakili konsep tak terhingga secara matematis. Ini terjadi dari operasi seperti pembagian angka dengan nol, atau ketika angka melebihi batas representasi _double-precision_.
  - **Di Lua**: Lua menyediakan konstanta `math.huge` untuk merepresentasikan nilai tak terhingga positif ($\infty$). Tak terhingga negatif dapat diperoleh dengan `-math.huge`.
  - **Contoh**:

    ```lua
    print(math.huge)      -- Output: inf (atau sejenisnya, tergantung sistem)
    print(-math.huge)     -- Output: -inf

    local hasil1 = 1 / 0
    local hasil2 = -1 / 0
    local hasil3 = math.huge * 2

    print(hasil1)         -- Output: inf
    print(hasil2)         -- Output: -inf
    print(hasil3)         -- Output: inf

    print(hasil1 == math.huge) -- Output: true
    ```

- **`NaN` (_Not a Number_)**:

  - **Deskripsi**: `NaN` adalah nilai spesial yang digunakan untuk merepresentasikan hasil dari operasi matematika yang tidak terdefinisi atau tidak valid, seperti `0/0` atau akar kuadrat dari angka negatif.
  - **Sifat Unik**: `NaN` memiliki sifat yang sangat aneh: **ia tidak sama dengan nilai apa pun, termasuk dirinya sendiri**. Ini adalah satu-satunya nilai di Lua yang berlaku `x ~= x`.
  - **Contoh dan Cara Memeriksa**:

    ```lua
    local hasilNan1 = 0 / 0
    local hasilNan2 = math.sqrt(-1) -- Akar kuadrat dari -1

    print(hasilNan1) -- Output: nan (atau sejenisnya)
    print(hasilNan2) -- Output: nan

    -- Perbandingan biasa akan gagal!
    if hasilNan1 == hasilNan2 then
        print("Dua NaN adalah sama (ini tidak akan tercetak)")
    else
        print("Dua NaN TIDAK sama") -- Output ini yang akan tercetak
    end

    if hasilNan1 == hasilNan1 then
        print("NaN sama dengan dirinya sendiri (ini tidak akan tercetak)")
    else
        print("NaN TIDAK sama dengan dirinya sendiri") -- Output ini yang akan tercetak
    end

    -- CARA YANG BENAR untuk memeriksa apakah sebuah nilai adalah NaN:
    local x = 0 / 0
    if x ~= x then
        print("Variabel x adalah NaN.") -- Output ini yang akan tercetak
    end
    ```

    - **Penjelasan Sintaksis**:
      - `math.sqrt(x)`: Fungsi dari pustaka `math` untuk menghitung akar kuadrat dari `x`.
      - `x ~= x`: Operator ketidaksamaan (`~=`) digunakan untuk memeriksa apakah `x` tidak sama dengan `x`. Karena hanya `NaN` yang memiliki properti ini, ini adalah cara idiomatis dan andal untuk mendeteksi `NaN`.

- **Sumber**:
  - Manual Lua mendokumentasikan `math.huge`.
  - Tutorial tentang pustaka `math` sering membahas nilai-nilai spesial ini.

Kita telah menyelesaikan _deep dive_ pada tipe `number`. Selanjutnya dalam kurikulum Anda adalah **"2.4 Tipe String - _Deep String Mechanics_"**. Siap untuk melanjutkan?
