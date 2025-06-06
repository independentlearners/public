<details>
<summary>Gemini 2.5 Pro</summary>

</details>

#

<details>
<summary>Gemini 2.5 Flash</summary>

# **LEVEL 3: LUA PATTERNS**

Ini adalah topik yang krusial dan merupakan salah satu fitur string paling kuat di Lua. Penting untuk dicatat bahwa _Lua Patterns_ **bukanlah** _regular expressions_ penuh (regex) yang mungkin Anda kenal dari bahasa lain seperti Python atau JavaScript. Mereka lebih sederhana, lebih ringan, dan dioptimalkan untuk kinerja di Lua, tetapi tetap sangat fleksibel.

#

Lua Patterns adalah bahasa mini untuk mendeskripsikan urutan karakter. Ini digunakan oleh beberapa fungsi `string` seperti `string.find()`, `string.match()`, `string.gsub()`, dan `string.gmatch()`. Menguasai Lua Patterns akan membuka kemampuan Anda untuk melakukan pencarian, ekstraksi, dan penggantian string yang kompleks dengan sangat efisien.

### **3.1 Pengenalan Lua Patterns**

Bagian ini memperkenalkan apa itu Lua Patterns dan mengapa itu penting.

- **Apa itu Lua Pattern? Definisi dan Perbedaan dari Regex (Regular Expressions)**

  - **Definisi Lua Pattern**: Lua Pattern adalah sebuah "mini-language" yang digunakan untuk mendeskripsikan atau mencocokkan urutan karakter dalam string. Ini bukan bahasa pemrograman, melainkan sebuah pola yang digunakan oleh fungsi-fungsi string untuk menemukan atau memanipulasi teks.
  - **Perbedaan dari Regular Expressions (Regex)**: Ini adalah poin yang sangat penting untuk dipahami!
    - **Kompabilitas & Kompleksitas**:
      - **Lua Patterns**: Dirancang untuk sederhana, ringan, dan cepat. Ia memiliki fitur yang lebih terbatas dibandingkan regex penuh. Tidak ada fitur seperti _lookarounds_, _backreferences_ yang kompleks, atau _quantifier_ non-greedy yang umum dalam regex yang lebih modern (walaupun Lua memiliki `.-` sebagai non-greedy untuk beberapa kasus).
      - **Regex Penuh**: Ini adalah standar yang lebih kompleks dan kaya fitur (seperti Perl Compatible Regular Expressions / PCRE) yang ditemukan di banyak bahasa lain. Mereka menawarkan kekuatan yang jauh lebih besar dalam pencocokan pola, tetapi juga bisa lebih kompleks untuk ditulis dan berpotensi lebih lambat.
    - **Fitur Utama yang Hilang di Lua Patterns (dibandingkan Regex Penuh)**:
      - **`|` (OR operator)**: Tidak ada operator "ATAU" untuk mencocokkan pola A atau pola B secara langsung. Anda harus menggunakan _character sets_ atau pola alternatif secara manual.
      - **`?` (Lazy/Non-greedy Quantifier)**: Meskipun Lua memiliki `.-` dan `%s*` untuk beberapa kasus, ia tidak memiliki `?` universal sebagai _lazy quantifier_ setelah _quantifier_ lain (`*`, `+`).
      - **Lookarounds (Positive/Negative Lookahead/Lookbehind)**: Tidak ada cara untuk mencocokkan berdasarkan konteks di sekitar pola tanpa memasukkannya ke dalam kecocokan.
      - **Backreferences**: Tidak ada `\1`, `\2`, dll., untuk merujuk kembali ke _captured groups_ sebelumnya dalam pola.
      - **Groupings Non-Capturing `(?:...)`**: Semua kurung `()` adalah _capturing groups_.
    - **Mengapa Lua Memilih Ini?**: Desain Lua mengedepankan kesederhanaan, portabilitas, dan ukuran _footprint_ yang kecil. Regex penuh akan menambah kompleksitas dan ukuran interpreter secara signifikan. Lua Patterns cukup untuk sebagian besar tugas manipulasi string umum.
  - **Terminologi**:
    - **Pattern (Pola)**: Urutan karakter yang mendefinisikan sebuah kriteria pencarian atau pencocokan.
    - **Regular Expressions (Regex)**: Bahasa formal yang digunakan untuk menentukan pola pencarian string, dengan sintaks yang lebih kaya dan fitur yang lebih banyak daripada Lua Patterns.
  - **Sumber Terverifikasi**: Programming in Lua Chapter 20, Lua 5.4 Reference Manual Section 6.4.1.

- **Karakter Khusus (Magic Characters) dan Escape (%)**

  Beberapa karakter memiliki makna khusus (disebut "magic characters") dalam Lua Patterns. Jika Anda ingin mencocokkan karakter-karakter ini secara literal, Anda harus "meng-escape" mereka dengan menambahkan tanda persen (`%`) di depannya.

  - **Daftar Karakter Khusus**:
    - `( ) . % + - * ? [ ] ^ $`
  - **Cara Meng-escape**: Tambahkan `%` di depannya. Contoh: `%.` untuk mencocokkan titik literal, `%+` untuk mencocokkan tanda plus literal.
  - **Contoh Kode**:

    ```lua
    local teks = "Harga: $10.50 (Diskon 5%!)"

    -- Mencari tanda '$' literal
    local dolar_pos = string.find(teks, "%$", 1, true) -- Menggunakan plain=true juga efektif untuk literal
    print("Posisi $ (plain):", dolar_pos)
    -- Output: Posisi $ (plain): 8

    local dolar_pos_pattern = string.find(teks, "%$") -- Dengan pola, bukan plain
    print("Posisi $ (pattern):", dolar_pos_pattern)
    -- Output: Posisi $ (pattern): 8

    -- Mencari "5%" literal
    local persen_pos = string.find(teks, "5%%")
    print("Posisi 5%:", persen_pos)
    -- Output: Posisi 5%: 22

    -- Mencari titik literal
    local titik_pos = string.find(teks, "%.")
    print("Posisi titik:", titik_pos)
    -- Output: Posisi titik: 11

    -- Mencari kurung buka literal
    local kurung_pos = string.find(teks, "%(")
    print("Posisi kurung buka:", kurung_pos)
    -- Output: Posisi kurung buka: 14
    ```

    - **Penjelasan per Sintaksis**:
      - `string.find(teks, "%$")`: `%$` digunakan untuk mencocokkan karakter dolar (`$`) secara literal. Jika Anda hanya menggunakan `$`, itu akan diperlakukan sebagai jangkar akhir string (akan dibahas nanti).
      - `string.find(teks, "5%%")`: `%%` digunakan untuk mencocokkan karakter persen (`%`) secara literal. Satu `%` adalah karakter _escape_ untuk yang berikutnya.
      - `string.find(teks, "%.")`: `%.` digunakan untuk mencocokkan karakter titik (`.`) secara literal. Jika Anda hanya menggunakan `.`, itu berarti "cocokkan karakter apapun".
      - `string.find(teks, "%(")`: `%( `digunakan untuk mencocokkan karakter kurung buka literal.

  - **Sumber Terverifikasi**: Programming in Lua Chapter 20, Lua 5.4 Reference Manual Section 6.4.1.

### **3.2 Character Classes**

**Character Classes** (kelas karakter) adalah shortcut atau cara ringkas untuk mencocokkan kelompok karakter tertentu. Mereka sangat umum dan memudahkan penulisan pola. Setiap _character class_ diawali dengan `%`.

- **Predefined Classes: %a, %c, %d, %g, %l, %p, %s, %u, %w, %x, %z**

  Lua menyediakan beberapa kelas karakter bawaan:

  - `%a`: Semua huruf alfabet (a-z, A-Z).
  - `%c`: Semua karakter kontrol (misalnya newline, tab).
  - `%d`: Semua digit desimal (0-9).
  - `%g`: Semua karakter yang dapat dicetak kecuali spasi (graphics characters). Ini adalah setara dengan `[^%s]`.
  - `%l`: Semua huruf kecil (a-z).
  - `%p`: Semua karakter tanda baca (punctuation characters).
  - `%s`: Semua karakter spasi (whitespace characters: spasi, tab, newline, carriage return, form feed, vertical tab).
  - `%u`: Semua huruf besar (A-Z).
  - `%w`: Semua karakter alfanumerik (huruf, angka, dan underscore `_`). Ini sering disebut "word character".
  - `%x`: Semua digit heksadesimal (0-9, a-f, A-F).
  - `%z`: Karakter dengan kode 0 (null character). (Jarang digunakan untuk manipulasi string umum)

  - **Penting**: Semua _character classes_ ini juga memiliki bentuk negasi dengan huruf besar. Misalnya:

    - `%A`: Karakter non-alfabet.
    - `%D`: Karakter non-digit.
    - `%S`: Karakter non-spasi.
    - Dan seterusnya.

  - **Contoh Kode**:

    ```lua
    local teks_campur = "Ini adalah Text dengan 123 Angka, dan simbol!@#."

    -- Mencocokkan semua huruf
    local hanya_huruf, _ = string.gsub(teks_campur, "%a", "_")
    print("Hanya huruf:", hanya_huruf)
    -- Output: Hanya huruf: ___ ______ ____ ____ _____, ____ _____!@#_

    -- Mencocokkan semua digit
    local hanya_digit, _ = string.gsub(teks_campur, "%d", "X")
    print("Hanya digit:", hanya_digit)
    -- Output: Hanya digit: Ini adalah Text dengan XXX Angka, dan simbol!@#

    -- Mencocokkan semua spasi
    local hanya_spasi, _ = string.gsub(teks_campur, "%s", "-")
    print("Hanya spasi:", hanya_spasi)
    -- Output: Hanya spasi: Ini-adalah-Text-dengan-123-Angka,-dan-simbol!@#.

    -- Mencocokkan semua non-whitespace (graphics characters)
    local hanya_non_spasi, _ = string.gsub(teks_campur, "%g", "_")
    print("Hanya non-spasi:", hanya_non_spasi)
    -- Output: Hanya non-spasi: ___ _______ ____ _______ ___ _____, ____ ________!@#_

    -- Mengambil semua huruf besar
    for char in string.gmatch(teks_campur, "%u") do
        io.write(char)
    end
    print()
    -- Output: TITAN
    ```

    - **Penjelasan per Sintaksis**:
      - `string.gsub(teks_campur, "%a", "_")`: Mengganti setiap karakter alfabet (`%a`) dengan `_`.
      - `string.gsub(teks_campur, "%d", "X")`: Mengganti setiap digit (`%d`) dengan `X`.
      - `string.gsub(teks_campur, "%s", "-")`: Mengganti setiap karakter spasi (`%s`) dengan `-`.
      - `string.gsub(teks_campur, "%g", "_")`: Mengganti setiap karakter grafis (non-spasi, `%g`) dengan `_`.
      - `for char in string.gmatch(teks_campur, "%u") do ... end`: Mengulang setiap karakter huruf besar (`%u`) yang ditemukan dalam string dan mencetaknya.

  - **Sumber Terverifikasi**: Programming in Lua Chapter 20, Lua 5.4 Reference Manual Section 6.4.1.

- **Custom Character Sets (`[ ]`) and Negation (`[^ ]`)**

  Anda dapat membuat kelas karakter Anda sendiri menggunakan tanda kurung siku `[]`. Ini memungkinkan Anda untuk mencocokkan karakter apa pun dari daftar yang Anda tentukan.

  - **Sintaks Dasar**: `[characters]`
    - Cocokkan karakter apa pun yang ada di dalam tanda kurung siku.
  - **Contoh Kode**:

    ```lua
    local kalimat = "Hello 123 World!@#"

    -- Mencocokkan huruf vokal
    local vokal_saja, _ = string.gsub(kalimat, "[aeiouAEIOU]", "_")
    print("Vokal diganti:", vokal_saja)
    -- Output: Vokal diganti: H_ll_ 123 W_rld!@#

    -- Mencocokkan angka atau spasi
    local angka_spasi_saja, _ = string.gsub(kalimat, "[0-9%s]", "X")
    -- '0-9' adalah rentang angka. '%s' adalah karakter spasi.
    print("Angka/Spasi diganti:", angka_spasi_saja)
    -- Output: Angka/Spasi diganti: HelloXXXWorld!@#

    -- Mencocokkan rentang karakter
    local rentang_huruf, _ = string.gsub(kalimat, "[a-c]", "X")
    print("Huruf a-c diganti:", rentang_huruf)
    -- Output: Huruf a-c diganti: HellX 123 World!@#
    ```

    - **Penjelasan per Sintaksis**:
      - `string.gsub(kalimat, "[aeiouAEIOU]", "_")`: Mengganti setiap karakter yang ada di dalam set `aeiouAEIOU` (yaitu, semua huruf vokal, baik kecil maupun besar) dengan `_`.
      - `string.gsub(kalimat, "[0-9%s]", "X")`: Mengganti setiap karakter yang merupakan digit (`0-9`) atau spasi (`%s`) dengan `X`. Anda dapat mencampur rentang dan kelas karakter dalam satu set.
      - `string.gsub(kalimat, "[a-c]", "X")`: Mengganti setiap karakter dalam rentang 'a' hingga 'c' dengan `X`.

  - **Negasi Custom Character Sets (`[^ ]`)**:
    Anda dapat membalikkan _character set_ dengan menambahkan `^` (caret) sebagai karakter pertama di dalam kurung siku. Ini berarti "cocokkan karakter apa pun yang **bukan** ada di dalam daftar ini".

    - **Sintaks Dasar**: `[^characters]`
    - **Contoh Kode**:

      ```lua
      local teks_validasi = "user_123@domain.com"

      -- Cocokkan karakter apapun yang BUKAN huruf, angka, atau underscore
      local hanya_valid, _ = string.gsub(teks_validasi, "[^%w_]", "")
      -- Menghapus semua karakter yang tidak valid untuk nama pengguna
      print("Hanya karakter valid:", hanya_valid)
      -- Output: Hanya karakter valid: user_123domaincom

      -- Cocokkan karakter apapun KECUALI angka
      local tanpa_angka, _ = string.gsub(teks_validasi, "[^0-9]", "")
      print("Hanya angka (asli):", tanpa_angka)
      -- Output: Hanya angka (asli): 123
      ```

      - **Penjelasan per Sintaksis**:
        - `string.gsub(teks_validasi, "[^%w_]", "")`:
          - `[^%w_]`: Mencocokkan karakter apa pun yang **bukan** `w` (word character: huruf, angka, underscore) dan **bukan** `_` (underscore literal). Singkatnya, ini cocok dengan karakter yang bukan huruf, angka, atau underscore. Karakter-karakter ini kemudian diganti dengan string kosong (`""`), yang secara efektif menghapusnya.
        - `string.gsub(teks_validasi, "[^0-9]", "")`: Mencocokkan karakter apa pun yang **bukan** digit (`0-9`). Ini akan menghapus semua karakter selain angka.

  - **Penting untuk `[ ]`**:

    - Di dalam `[]`, sebagian besar karakter khusus kehilangan makna "magic"-nya, kecuali:
      - `^`: Hanya khusus jika di awal `[]` (untuk negasi). Jika di tempat lain, itu adalah karakter `^` literal.
      - `-`: Hanya khusus jika di antara dua karakter (untuk mendefinisikan rentang, misal `a-z`). Jika di awal, akhir, atau setelah `^`, itu adalah karakter `-` literal.
      - `%`: Masih berfungsi untuk meng-escape karakter khusus atau memanggil kelas karakter (`%a`, `%d`, dll.).
    - Untuk mencocokkan `[` atau `]` literal di dalam _character set_, Anda harus meng-escape-nya: `[%[%]]`.

  - **Sumber Terverifikasi**: Programming in Lua Chapter 20, Lua 5.4 Reference Manual Section 6.4.1.

---

### **3.3 Quantifiers**

**Quantifiers** (kuantifier) adalah simbol yang menentukan berapa kali elemen pola sebelumnya harus muncul agar cocok.

- **`*` (zero or more), `+` (one or more), `-` (zero or more, non-greedy), `?` (optional)**

  - **`*` (Zero or More)**: Cocokkan elemen sebelumnya nol kali atau lebih. Ini adalah _greedy quantifier_, yang berarti ia akan mencoba mencocokkan sebanyak mungkin karakter.

    - **Sintaks Dasar**: `pattern*`
    - **Contoh Kode**:

      ```lua
      print(string.match("aaabbb", "a*b*"))
      -- Output: aaabbb (cocokkan semua 'a' dan semua 'b')

      print(string.match("Hello", "o*"))
      -- Output: o (cocokkan 'o')
      print(string.match("H", "o*"))
      -- Output:  (string kosong, karena 'o' muncul 0 kali)

      local teks_spasi = "Kata   dengan    banyak    spasi."
      local tanpa_spasi_ekstra, _ = string.gsub(teks_spasi, "%s+", " ")
      -- %s+ berarti satu atau lebih spasi. Mengganti semua urutan spasi dengan satu spasi.
      print("Tanpa spasi ekstra:", tanpa_spasi_ekstra)
      -- Output: Tanpa spasi ekstra: Kata dengan banyak spasi.
      ```

      - **Penjelasan per Sintaksis**:
        - `"a*b*"`: Mencocokkan nol atau lebih 'a' diikuti oleh nol atau lebih 'b'. Ini akan cocok dengan seluruh string `aaabbb`.
        - `"o*"`: Mencocokkan nol atau lebih 'o'. Jika ada 'o', itu akan cocok. Jika tidak ada (seperti pada "H"), itu akan cocok dengan string kosong di mana 'o' bisa ada (0 kali).
        - `string.gsub(teks_spasi, "%s+", " ")`: `"%s+"` mencocokkan satu atau lebih karakter spasi. Setiap urutan spasi (misalnya, tiga spasi, atau empat spasi) akan diganti dengan satu spasi tunggal. Ini adalah trik umum untuk menormalisasi spasi.

  - **`+` (One or More)**: Cocokkan elemen sebelumnya satu kali atau lebih. Juga _greedy_.

    - **Sintaks Dasar**: `pattern+`
    - **Contoh Kode**:

      ```lua
      print(string.match("aaabbb", "a+b+"))
      -- Output: aaabbb (cocokkan satu atau lebih 'a' dan satu atau lebih 'b')

      print(string.match("Hello", "o+"))
      -- Output: o
      print(string.match("H", "o+"))
      -- Output: nil (karena 'o' harus muncul minimal 1 kali)
      ```

      - **Penjelasan per Sintaksis**:
        - `"a+b+"`: Mirip dengan `*`, tetapi `a` dan `b` harus muncul setidaknya satu kali.
        - `"o+"`: Mencocokkan satu atau lebih 'o'. Jika tidak ada 'o' sama sekali (seperti pada "H"), kecocokan gagal dan `nil` dikembalikan.

  - **`-` (Zero or More, Non-greedy)**: Cocokkan elemen sebelumnya nol kali atau lebih, tetapi **sesedikit mungkin**. Ini adalah fitur khusus Lua yang mirip dengan _lazy quantifiers_ di regex penuh, tetapi hanya berlaku untuk pola yang bukan _character classes_ atau _items_ tunggal.

    - **Sintaks Dasar**: `pattern-`
    - **Contoh Kode**:

      ```lua
      local html = "<b>bold text</b> and <i>italic text</i>"

      -- Greedy: akan mencocokkan dari <b> pertama sampai </b> terakhir
      local greedy_match = string.match(html, "<b>.*</b>")
      print("Greedy Match:", greedy_match)
      -- Output: Greedy Match: <b>bold text</b> and <i>italic text</i></b> -- Salah!

      -- Non-greedy: akan mencocokkan hingga </b> pertama yang ditemukan
      local non_greedy_match = string.match(html, "<b>.-</b>")
      print("Non-Greedy Match:", non_greedy_match)
      -- Output: Non-Greedy Match: <b>bold text</b>

      local email_list = "Email1: user1@example.com, Email2: user2@test.net"
      -- Mencocokkan email sampai koma pertama
      for email in string.gmatch(email_list, ":%s*(.-),") do
          print("Email:", email)
      end
      -- Output: Email: user1@example.com
      -- (Pola ini tidak akan menemukan email kedua karena pola diakhiri dengan koma)

      -- Untuk email kedua, kita bisa buat pola yang lebih akurat
      for email in string.gmatch(email_list, "Email%d+:%s*(%S+)") do
          print("Email (lebih akurat):", email)
      end
      -- Output:
      -- Email (lebih akurat): user1@example.com,
      -- Email (lebih akurat): user2@test.net
      -- Catatan: %S+ akan mengambil string non-spasi sampai ketemu spasi atau akhir string.
      ```

      - **Penjelasan per Sintaksis**:
        - `<b>.*</b>`: `.` adalah "cocokkan karakter apapun". `*` adalah "nol atau lebih", dan sifatnya _greedy_. Ini berarti ia akan mencocokkan sebanyak mungkin karakter, sehingga `.*` akan mencocokkan dari `<b>` pertama hingga `</b>` terakhir di seluruh string, termasuk tag `<i>` di antaranya.
        - `<b>.-</b>`: `.-` adalah _non-greedy_. Ini juga mencocokkan nol atau lebih karakter apapun, tetapi _sesedikit mungkin_. Ini berarti ia akan berhenti pada `</b>` pertama yang ditemuinya, sehingga hanya `<b>bold text</b>` yang cocok.
        - `:%s*(.-),`: Pola ini mencari `:` diikuti nol atau lebih spasi, kemudian menangkap bagian string (`.-`) yang diakhiri oleh `,`. `.-` memastikan bahwa ia hanya menangkap sampai koma _pertama_ yang ditemui.

  - **`?` (Optional / Zero or One)**: Cocokkan elemen sebelumnya nol kali atau satu kali.

    - **Sintaks Dasar**: `pattern?`
    - **Contoh Kode**:

      ```lua
      local urls = {"http://example.com", "https://secure.org", "ftp://old.net"}

      for _, url in ipairs(urls) do
          local protocol = string.match(url, "https?://")
          -- 's?' berarti 's' bisa muncul 0 atau 1 kali
          print(url, "-> Protokol:", protocol)
      end
      -- Output:
      -- http://example.com -> Protokol: http://
      -- https://secure.org -> Protokol: https://
      -- ftp://old.net -> Protokol: nil

      local kalimat_opsional = "color"
      print(string.match(kalimat_opsional, "colou?r"))
      -- Output: color (cocokkan 'colour' atau 'color')

      local kalimat_opsional2 = "colour"
      print(string.match(kalimat_opsional2, "colou?r"))
      -- Output: colour
      ```

      - **Penjelasan per Sintaksis**:
        - `https?://`: Pola ini mencari `http` diikuti oleh karakter `s` yang bersifat opsional (`s?`), kemudian diikuti oleh `://`. Ini akan mencocokkan baik `http://` maupun `https://`.
        - `colou?r`: Pola ini mencari `colo` diikuti oleh karakter `u` yang bersifat opsional (`u?`), kemudian diikuti oleh `r`. Ini akan cocok dengan "color" (tanpa 'u') dan "colour" (dengan 'u').

  - **Sumber Terverifikasi**: Programming in Lua Chapter 20, Lua 5.4 Reference Manual Section 6.4.1.

---

### **3.4 Anchors and Bounds**

**Anchors** (jangkar) adalah karakter khusus yang tidak mencocokkan karakter sebenarnya, melainkan posisi dalam string. Mereka "menjangkar" pola ke awal atau akhir string, atau batas kata.

- **`^` (Start of string), `$` (End of string)**

  - **`^` (Start of String)**: Pola harus cocok di awal string.

    - **Sintaks Dasar**: `^pattern`
    - **Contoh Kode**:

      ```lua
      local teks = "Lua programming is fun. Lua is powerful."

      -- Mencari "Lua" di awal string
      print(string.find(teks, "^Lua"))
      -- Output: 1  3 (ditemukan di awal)

      -- Mencari "programming" di awal string (tidak cocok)
      print(string.find(teks, "^programming"))
      -- Output: nil
      ```

      - **Penjelasan per Sintaksis**:
        - `string.find(teks, "^Lua")`: `^` di awal pola `^Lua` mengharuskan pola `Lua` muncul di posisi paling awal (indeks 1) dari string `teks`.

  - **`$` (End of String)**: Pola harus cocok di akhir string.

    - **Sintaks Dasar**: `pattern$`
    - **Contoh Kode**:

      ```lua
      local teks = "Lua programming is fun. Lua is powerful."

      -- Mencari "powerful." di akhir string
      print(string.find(teks, "powerful.$"))
      -- Output: 31  40 (ditemukan di akhir)

      -- Mencari "fun." di akhir string (tidak cocok)
      print(string.find(teks, "fun.$"))
      -- Output: nil
      ```

      - **Penjelasan per Sintaksis**:
        - `string.find(teks, "powerful.$")`: `$` di akhir pola `powerful.$` mengharuskan pola `powerful.` muncul di posisi paling akhir dari string `teks`. Perhatikan bahwa titik `.` harus di-_escape_ (`%.`) jika Anda ingin mencocokkan titik literal, atau `$` akan berlaku setelah karakter apapun. Di sini, `.` dianggap sebagai karakter apapun yang diikuti oleh akhir string, jadi cocok. Jika stringnya "powerful" tanpa titik, pola ini tidak akan cocok.

  - **Menggabungkan `^` dan `$`**: Untuk mencocokkan seluruh string agar sesuai dengan pola tertentu.

    - **Contoh Kode**:

      ```lua
      local input_id = "ABCD123"

      -- Memastikan string hanya terdiri dari huruf besar dan angka
      if string.match(input_id, "^%u+%d*$") then
          print("ID valid:", input_id)
      else
          print("ID tidak valid:", input_id)
      end
      -- Output: ID valid: ABCD123

      local input_id_invalid = "AB-CD123"
      if string.match(input_id_invalid, "^%u+%d*$") then
          print("ID valid:", input_id_invalid)
      else
          print("ID tidak valid:", input_id_invalid)
      end
      -- Output: ID tidak valid: AB-CD123 (karena ada '-' yang tidak cocok dengan %u atau %d)
      ```

      - **Penjelasan per Sintaksis**:
        - `"^%u+%d*$"`:
          - `^`: Mulai dari awal string.
          - `%u+`: Harus ada satu atau lebih huruf kapital.
          - `%d*`: Diikuti oleh nol atau lebih digit.
          - `$`: Diakhiri di akhir string.
          - Pola ini memastikan bahwa seluruh string harus cocok dengan pola yang diberikan (dimulai dengan huruf kapital, diikuti oleh digit, dan tidak ada karakter lain).

  - **Sumber Terverifikasi**: Programming in Lua Chapter 20, Lua 5.4 Reference Manual Section 6.4.1.

- **Magic Character `.` (Any character)**

  Karakter titik (`.`) adalah _magic character_ yang mencocokkan **karakter tunggal apa pun** (kecuali karakter null `\0` yang tidak diizinkan dalam string Lua standar).

  - **Sintaks Dasar**: `.`
  - **Contoh Kode**:

    ```lua
    local kalimat = "cat, bat, hat, mat"

    -- Mencocokkan 3 karakter yang diakhiri dengan 'at'
    for word in string.gmatch(kalimat, ".at") do
        print(word)
    end
    -- Output:
    -- cat
    -- bat
    -- hat
    -- mat

    local nomor_telepon = "123-456-7890"
    -- Mencocokkan 3 digit, '-', 3 digit, '-', 4 digit
    local match = string.match(nomor_telepon, "%d%d%d-.%d%d%d-.%d%d%d%d")
    print("Nomor telepon:", match)
    -- Output: Nomor telepon: 123-456-7890

    -- Catatan: Lebih baik menggunakan character classes untuk presisi.
    -- Contoh yang lebih baik: string.match(nomor_telepon, "%d%d%d-%d%d%d-%d%d%d%d")
    -- atau string.match(nomor_telepon, "%d+-%d+-%d+")
    ```

    - **Penjelasan per Sintaksis**:
      - `".at"`: Mencocokkan karakter apa pun (`.`) diikuti oleh literal `"at"`. Ini akan menemukan "cat", "bat", "hat", dan "mat".
      - `"%d%d%d-.%d%d%d-.%d%d%d%d"`: Mencocokkan tiga digit (`%d%d%d`), diikuti oleh _escape_ `.` (titik literal), diikuti oleh tiga digit, diikuti oleh _escape_ `.` (titik literal), dan diikuti oleh empat digit.

  - **Sumber Terverifikasi**: Programming in Lua Chapter 20, Lua 5.4 Reference Manual Section 6.4.1.

---

Ini adalah akhir dari pembahasan mengenai Pengenalan, Character Classes, Quantifiers, dan Anchors. Anda telah belajar tentang fondasi penting dari Lua Patterns, termasuk perbedaan dari regex, penggunaan karakter khusus dan _escape_, berbagai _character classes_ bawaan, cara membuat _custom character sets_ (termasuk negasi), serta berbagai _quantifier_ untuk mengulang pola.

### **3.5 Captures**

**Captures** (penangkapan) adalah fitur dari Lua Patterns yang memungkinkan Anda untuk mengekstrak bagian spesifik dari sebuah string yang cocok dengan sub-pola tertentu. Ini dilakukan dengan menempatkan sub-pola di dalam tanda kurung `()`. Fungsi-fungsi seperti `string.match()`, `string.gsub()`, dan `string.gmatch()` dapat mengembalikan nilai-nilai yang ditangkap ini.

- **Menggunakan `()` untuk menangkap bagian dari string yang cocok**

  Ketika Anda menempatkan bagian dari pola di dalam tanda kurung `()`, Lua akan "menangkap" string yang cocok dengan bagian pola tersebut. Nilai yang ditangkap ini kemudian dapat dikembalikan oleh fungsi-fungsi seperti `string.match()` atau digunakan dalam fungsi pengganti di `string.gsub()`.

  - **Sintaks Dasar**: `(pattern_part)`

  - **Contoh Kode dengan `string.match()`**:

    ```lua
    local email = "john.doe@example.com"

    -- Menangkap username dan domain secara terpisah
    local username, domain = string.match(email, "(%a+%.?%a+)@(%a+%.%a+)")
    print("Username:", username)
    print("Domain:", domain)
    -- Output:
    -- Username: john.doe
    -- Domain: example.com

    local tanggal = "Tanggal: 2024-03-15"
    -- Menangkap tahun, bulan, dan tanggal secara terpisah
    local tahun, bulan, hari = string.match(tanggal, "(%d%d%d%d)-(%d%d)-(%d%d)")
    print("Tahun:", tahun, "Bulan:", bulan, "Hari:", hari)
    -- Output: Tahun: 2024  Bulan: 03  Hari: 15
    ```

    - **Penjelasan per Sintaksis**:
      - `"(%a+%.?%a+)@(%a+%.%a+)"`:
        - `(%a+%.?%a+)`: Capture pertama.
          - `%a+`: Satu atau lebih huruf (cocok dengan "john").
          - `%.?`: Titik literal opsional (cocok dengan `.`).
          - `%a+`: Satu atau lebih huruf (cocok dengan "doe").
          - Seluruhnya akan menangkap "john.doe".
        - `@`: Cocokkan karakter `@` literal.
        - `(%a+%.%a+)`: Capture kedua.
          - `%a+`: Satu atau lebih huruf (cocok dengan "example").
          - `%.`: Titik literal.
          - `%a+`: Satu atau lebih huruf (cocok dengan "com").
          - Seluruhnya akan menangkap "example.com".
      - `"(%d%d%d%d)-(%d%d)-(%d%d)"`:
        - Ini memiliki tiga capture, masing-masing menangkap empat digit, dua digit, dan dua digit, dipisahkan oleh tanda hubung `-`.

  - **Contoh Kode dengan `string.gsub()` dan Fungsi Pengganti**:
    Ketika `repl` di `string.gsub()` adalah sebuah fungsi, argumen yang diberikan ke fungsi tersebut adalah string yang cocok dengan seluruh pola, diikuti oleh nilai-nilai dari setiap _capture_.

    - **Contoh Kode**:

      ```lua
      local teks_nama = "Halo, nama saya Budi Santoso dan dia adalah Ani Wijaya."

      -- Balik nama depan dan nama belakang
      local teks_terbalik, _ = string.gsub(teks_nama, "(%u%a+)%s+(%u%a+)", function(depan, belakang)
          return belakang .. ", " .. depan
      end)
      print("Nama dibalik:", teks_terbalik)
      -- Output: Nama dibalik: Halo, nama saya Santoso, Budi dan dia adalah Wijaya, Ani.

      local data_produk = "Produk_A_123_ID, Produk_B_456_EU"
      -- Ekstrak ID dan ubah formatnya
      local data_baru, _ = string.gsub(data_produk, "Produk_(%u)_(%d+)_(%u%u)", function(tipe, id_num, region)
          return string.format("SKU-%s%s-%s", tipe, id_num, string.lower(region))
      end)
      print("Data produk baru:", data_baru)
      -- Output: Data produk baru: SKU-A123-id, SKU-B456-eu
      ```

      - **Penjelasan per Sintaksis**:
        - **Membalik Nama**:
          - Pola: `"(%u%a+)%s+(%u%a+)"`
            - `(%u%a+)`: Capture pertama. Mencocokkan satu huruf besar (`%u`) diikuti oleh satu atau lebih huruf (`%a+`). Ini akan menangkap "Budi" dan "Ani".
            - `%s+`: Cocokkan satu atau lebih spasi.
            - `(%u%a+)`: Capture kedua. Mencocokkan satu huruf besar (`%u`) diikuti oleh satu atau lebih huruf (`%a+`). Ini akan menangkap "Santoso" dan "Wijaya".
          - Fungsi pengganti: `function(depan, belakang)`
            - Fungsi ini menerima dua argumen: `depan` (dari capture pertama) dan `belakang` (dari capture kedua).
            - `return belakang .. ", " .. depan`: Menggabungkan `belakang`, koma-spasi, dan `depan` untuk menghasilkan string pengganti.
        - **Mengubah Format Produk**:
          - Pola: `"Produk_(%u)_(%d+)_(%u%u)"`
            - `Produk_`: Cocokkan string literal "Produk\_".
            - `(%u)`: Capture pertama. Mencocokkan satu huruf besar (misalnya 'A' atau 'B').
            - `_`: Cocokkan underscore literal.
            - `(%d+)`: Capture kedua. Mencocokkan satu atau lebih digit (misalnya '123' atau '456').
            - `_`: Cocokkan underscore literal.
            - `(%u%u)`: Capture ketiga. Mencocokkan dua huruf besar (misalnya 'ID' atau 'EU').
          - Fungsi pengganti: `function(tipe, id_num, region)`
            - Fungsi ini menerima tiga argumen, sesuai dengan tiga _captures_.
            - `string.format("SKU-%s%s-%s", tipe, id_num, string.lower(region))`: Membuat string baru dengan format "SKU-TIPEID-regionkecil". Perhatikan `string.lower(region)` untuk mengubah "ID" atau "EU" menjadi huruf kecil.

  - **Sumber Terverifikasi**: Programming in Lua Chapter 20, Lua 5.4 Reference Manual Section 6.4.1.

- **Indexed captures (`%n`) for `string.gsub()` substitution string**

  Selain menggunakan fungsi sebagai `repl`, `string.gsub()` juga memungkinkan Anda untuk mereferensikan kembali _captured values_ dalam string pengganti menggunakan `%n`, di mana `n` adalah nomor indeks dari _capture_ tersebut. `%0` merujuk pada seluruh string yang cocok.

  - **Sintaks Dasar**: `"%n"` (di dalam string pengganti)

  - **Contoh Kode**:

    ```lua
    local nama_file = "gambar_01_resolusi_besar.png"

    -- Mengubah format nama file: gambar_01_resolusi_besar.png -> resolusi_besar_gambar_01.png
    local nama_baru, _ = string.gsub(nama_file, "(%a+)_(%d%d)_(%a+)_(%a+)%.(%a+)", "%3_%4_%1_%2.%5")
    -- Pola: (gambar)_(01)_(resolusi)_(besar).(png)
    -- Pengganti: %3_%4_%1_%2.%5  (resolusi_besar_gambar_01.png)
    print("Nama file baru:", nama_baru)
    -- Output: Nama file baru: resolusi_besar_gambar_01.png

    local kalimat_terbalik = "Hello World"
    -- Balik urutan kata: World Hello
    local dibalik, _ = string.gsub(kalimat_terbalik, "(%a+)%s+(%a+)", "%2 %1")
    print("Dibalik:", dibalik)
    -- Output: Dibalik: World Hello

    local harga_lama = "Harga: $10.50"
    -- Tambahkan "(TERJUAL)" setelah harga
    local harga_baru, _ = string.gsub(harga_lama, "%$(%d+%.%d+)", "$%1 (TERJUAL)")
    -- %0 adalah seluruh kecocokan ($10.50), %1 adalah capture pertama (10.50)
    -- Di sini kita pakai %1 karena kita ingin mempertahankan '$' literal di depan.
    print("Harga baru:", harga_baru)
    -- Output: Harga baru: Harga: $10.50 (TERJUAL)
    ```

    - **Penjelasan per Sintaksis**:
      - `"(%a+)_(%d%d)_(%a+)_(%a+)%.(%a+)"`:
        - Capture 1: `(%a+)` -\> "gambar"
        - Capture 2: `(%d%d)` -\> "01"
        - Capture 3: `(%a+)` -\> "resolusi"
        - Capture 4: `(%a+)` -\> "besar"
        - Capture 5: `(%a+)` -\> "png"
      - `"%3_%4_%1_%2.%5"`: String pengganti ini menggunakan referensi indeks ke _captures_.
        - `%3`: Isi dari capture 3 ("resolusi")
        - `_`: Underscore literal
        - `%4`: Isi dari capture 4 ("besar")
        - `_`: Underscore literal
        - `%1`: Isi dari capture 1 ("gambar")
        - `_`: Underscore literal
        - `%2`: Isi dari capture 2 ("01")
        - `.` (titik literal)
        - `%5`: Isi dari capture 5 ("png")
      - `"(%a+)%s+(%a+)"`:
        - Capture 1: Kata pertama (`%a+`)
        - Capture 2: Kata kedua (`%a+`)
      - `"%2 %1"`: String pengganti membalik urutan kata.
      - `"%$(%d+%.%d+)"`:
        - Capture 1: Harga numerik (`%d+%.%d+`)
      - `"$%1 (TERJUAL)"`: String pengganti menggunakan `$` literal, diikuti oleh nilai dari capture 1 (`%1`), dan kemudian string literal "(TERJUAL)".

  - **Sumber Terverifikasi**: Programming in Lua Chapter 20, Lua 5.4 Reference Manual Section 6.4.1.

### **3.6 Advanced Patterns**

- **`%bxy` (Balanced pairs)**

  Pola `%bxy` adalah pola khusus yang digunakan untuk mencocokkan string yang seimbang (misalnya, pasangan kurung buka dan tutup, tag HTML/XML, atau blok kode).

  - `x`: Karakter pembuka

  - `y`: Karakter penutup
    Pola ini akan mencocokkan dari `x` pertama yang ditemukan hingga `y` yang seimbang dengannya. Ini mengabaikan `x` atau `y` lain yang mungkin ada di antara mereka, selama mereka seimbang.

  - **Sintaks Dasar**: `%bxy`

  - **Contoh Kode**:

    ```lua
    local teks_kurung = "Ini adalah (teks dalam kurung (nested) dan lainnya)."

    -- Mencocokkan bagian dalam kurung kurawal
    local konten_kurung = string.match(teks_kurung, "%b()")
    print("Konten kurung:", konten_kurung)
    -- Output: Konten kurung: (teks dalam kurung (nested) dan lainnya)

    local html_snippet = "<div>Outer <b>bold text</b> and inner <i>italic</i> div.</div>"

    -- Mencocokkan tag <b> yang seimbang
    local bold_tag = string.match(html_snippet, "%b<>") -- mencocokkan <...>
    print("Tag bold:", bold_tag)
    -- Output: Tag bold: <div>Outer <b>bold text</b> and inner <i>italic</i> div.</div>
    -- Hati-hati! %b<> akan mencocokkan dari < pertama hingga > terakhir yang seimbang.
    -- Ini bagus untuk blok HTML, bukan tag individu.

    -- Untuk mencocokkan tag <b> spesifik, gunakan pola yang lebih spesifik:
    local specific_bold = string.match(html_snippet, "<b>(.-)</b>")
    print("Spesifik bold:", specific_bold)
    -- Output: Spesifik bold: bold text
    ```

    - **Penjelasan per Sintaksis**:
      - `string.match(teks_kurung, "%b()")`: Mencocokkan string dari tanda kurung buka `(` pertama hingga tanda kurung tutup `)` yang seimbang. Ini secara otomatis menangani kurung bersarang.
      - `string.match(html_snippet, "%b<>")`: Ini akan mencoba mencocokkan blok yang diapit oleh `<` dan `>`. Dalam kasus ini, itu akan mencocokkan seluruh `<div>` karena itu adalah pasangan `<` dan `>` yang paling luar.
      - `string.match(html_snippet, "<b>(.-)</b>")`: Ini adalah cara yang lebih umum dan disarankan untuk mengekstrak konten di antara tag HTML spesifik. Ini menggunakan `(.-)` untuk menangkap konten di antara tag `<b>` dan `</b>` secara non-greedy.

  - **Kapan Menggunakan `%bxy`**:

    - Untuk mengekstrak blok teks yang dibatasi oleh karakter pembuka/penutup yang sama (misalnya, semua teks dalam tanda kurung, semua blok di dalam `{}`).
    - Penting: `x` dan `y` harus karakter tunggal. Jika Anda ingin mencocokkan tag multi-karakter (misalnya `<div>` dan `</div>`), `%bxy` tidak akan berfungsi. Anda harus menggunakan pola yang lebih kompleks dengan `.` dan _quantifier_ seperti yang ditunjukkan pada contoh `<b>(.-)</b>`.

  - **Sumber Terverifikasi**: Programming in Lua Chapter 20, Lua 5.4 Reference Manual Section 6.4.1.

- **Pre-defined classes as single characters (`%x` where `x` is a letter)**

  Ini lebih merupakan klarifikasi daripada pola baru. Ketika Anda menggunakan `%a`, `%d`, `%s`, dll., mereka sebenarnya adalah singkatan untuk _character classes_. Anda bisa melihat mereka sebagai "karakter" yang cocok dengan satu elemen dari kelas tersebut. Ini berbeda dengan `.` yang mencocokkan karakter tunggal apapun.

  - **Contoh**:
    - `%d` cocok dengan **satu** digit.
    - `%s` cocok dengan **satu** spasi.
    - Anda kemudian menggunakan _quantifier_ (`+`, `*`, `?`) setelahnya untuk mencocokkan banyak karakter dari kelas tersebut (misalnya `%d+` untuk satu atau lebih digit).

- **Empty matches**

  Pola Lua dapat mencocokkan "string kosong" (yaitu, posisi di antara karakter). Ini biasanya terjadi ketika menggunakan _quantifier_ `*` atau `?` pada pola yang tidak ditemukan, atau saat menggunakan _anchors_ di akhir string, atau pada batas kata.

  - **Contoh Kode**:

    ```lua
    local teks = "abc"

    -- %d* akan mencocokkan string kosong di mana saja karena digit muncul 0 kali
    for start_pos, end_pos in string.gfind(teks, "%d*") do
        print("Match (posisi):", start_pos, end_pos)
    end
    -- Output (contoh di Lua 5.1/5.2+ mungkin berbeda sedikit dalam iterasi gfind/gmatch):
    -- Match (posisi): 1 0 (sebelum 'a') -- Ini adalah string kosong
    -- Match (posisi): 2 1 (antara 'a' dan 'b')
    -- Match (posisi): 3 2 (antara 'b' dan 'c')
    -- Match (posisi): 4 3 (setelah 'c')

    -- string.match("H", "o*") mengembalikan string kosong "" (bukan nil)
    -- (Ini karena match "o" nol kali berhasil)
    local result = string.match("H", "o*")
    print("Match 'o*' di 'H':", result, "(length:", #result, ")")
    -- Output: Match 'o*' di 'H':  (length: 0 )
    ```

    - **Penjelasan**: Ketika pola mencocokkan nol karakter (misalnya `a*` pada string yang tidak mengandung `a`, atau `.` pada string kosong), itu dianggap sebagai kecocokan "kosong". Ini penting untuk dipahami karena dapat memengaruhi perilaku iterasi atau penggantian.

  - **Sumber Terverifikasi**: Programming in Lua Chapter 20.

---

Dengan ini, kita telah menyelesaikan pembahasan mendalam tentang **LEVEL 3: LUA PATTERNS**. Ini adalah inti dari manipulasi string tingkat lanjut di Lua. Anda sekarang harus memahami:

- Perbedaan fundamental antara Lua Patterns dan Regular Expressions penuh.
- Pentingnya karakter khusus dan cara meng-escape-nya.
- Berbagai kelas karakter yang telah ditentukan dan cara membuat _character sets_ kustom Anda sendiri.
- Fungsi _quantifier_ (`*`, `+`, `-`, `?`) dan perbedaan antara _greedy_ dan _non-greedy_.
- Penggunaan _anchors_ (`^`, `$`) untuk mencocokkan posisi awal/akhir string.
- Cara menggunakan _captures_ `()` untuk mengekstrak sub-string yang cocok, baik dalam fungsi pengganti (`string.gsub()` dengan fungsi) maupun dengan referensi indeks (`%n`).
- Pola khusus `%bxy` untuk pasangan yang seimbang, dan konsep _empty matches_.

Pastikan untuk melatih pola-pola ini dengan berbagai skenario. Semakin Anda berlatih, semakin intuitif penggunaan Lua Patterns bagi Anda. Berikutnya, kita akan beralih ke **LEVEL 4: STRING UTILITIES & BEST PRACTICES**. Ini akan mencakup topik-topik seperti efisiensi, pembersihan string, dan tips umum untuk bekerja dengan string secara efektif.

</details>

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

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
