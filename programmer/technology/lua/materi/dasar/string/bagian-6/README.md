# LEVEL 6

<details>
<summary>Gemini 2.5 Pro</summary>

</details>

#

<details>
<summary>Gemini 2.5 Flash</summary>

# **LEVEL 6: ADVANCED TOPICS & LPEG**

Kita telah masuk ke level terakhir dari kurikulum ini dimana bagian ini adalah level yang akan memperkenalkan Anda pada salah satu pustaka pihak ketiga yang paling kuat dan unik di Lua untuk parsing dan manipulasi string yang kompleks: LPEG. Pada level ini, kita akan membahas topik-topik lanjutan yang mungkin tidak sering Anda gunakan setiap hari, tetapi sangat kuat ketika Anda membutuhkannya. Fokus utama adalah pada LPEG, pustaka _Parsing Expression Grammar_ yang sangat efisien.

### **6.1 LPEG: Parsing Expression Grammars for Lua**

**LPEG** (Lua Parsing Expression Grammars) adalah sebuah pustaka C yang diintegrasikan ke Lua, yang menyediakan fungsionalitas _pattern matching_ dan _parsing_ yang jauh lebih canggih daripada Lua Patterns standar. LPEG didasarkan pada konsep _Parsing Expression Grammars (PEGs)_, yang merupakan alternatif untuk _Regular Expressions (Regex)_ dan _Context-Free Grammars (CFGs)_.

- **Pengenalan LPEG: Apa itu PEG dan mengapa itu lebih unggul dari Regex untuk parsing kompleks**

  - **Apa itu PEG (Parsing Expression Grammar)?**:

    - PEG adalah cara formal untuk mendefinisikan bahasa, mirip dengan CFG, tetapi dirancang untuk _parsing_ yang efisien.
    - Berbeda dengan CFG yang bisa ambigu, PEG selalu _unambiguous_ (tidak ambigu). Ini berarti untuk setiap input, hanya ada satu cara untuk mengurainya.
    - PEG beroperasi dengan prinsip "pemilihan terurut" (ordered choice) dan "coba pertama" (first match wins). Ketika ada beberapa alternatif, aturan pertama yang cocok akan "menang", dan mesin tidak akan mencoba alternatif lain.

  - **Mengapa LPEG (PEG) Unggul dari Regex untuk Parsing Kompleks?**:

    1.  **Ambiguity (Ketidakjelasan)**:
        - **Regex**: Regex seringkali _ambigu_ untuk struktur bersarang atau kompleks. Contoh yang umum adalah mencoba mencocokkan HTML dengan Regex, yang seringkali gagal karena Regex tidak dapat secara efektif menangani struktur bersarang atau berpasangan dengan benar (karena Regex tidak memiliki kemampuan _recursive_ bawaan yang kuat seperti PEG).
        - **LPEG/PEG**: PEG secara inheren _unambiguous_. Ini membuatnya sangat cocok untuk _parsing_ bahasa pemrograman, format data (JSON, CSV yang kompleks), atau struktur bersarang (HTML, XML, kurung yang seimbang) dengan presisi. LPEG secara alami mendukung rekursi.
    2.  **Kemampuan Parsing vs. Matching**:
        - **Regex**: Dirancang terutama untuk _string matching_ dan _substitution_. Meskipun bisa mengekstrak data (`captures`), ia tidak dirancang untuk membangun _parse tree_ atau memahami struktur hierarkis bahasa.
        - **LPEG/PEG**: Dirancang untuk _parsing_. Ia tidak hanya mencocokkan pola, tetapi juga dapat membangun representasi terstruktur dari string yang diurai (misalnya, tabel data, AST/Abstract Syntax Tree).
    3.  **Power dan Ekspresivitas**:
        - **Lua Patterns**: Sederhana dan ringan, tidak bisa menangani rekursi, tidak ada operator OR yang universal, dll.
        - **Regex Penuh**: Lebih kuat dari Lua Patterns, tetapi masih memiliki keterbatasan untuk struktur bersarang, dan seringkali membutuhkan _backtracking_ yang mahal untuk pola kompleks.
        - **LPEG/PEG**: Jauh lebih kuat dan ekspresif daripada Regex untuk definisi bahasa. Ia dapat dengan mudah mendefinisikan tata bahasa untuk bahasa pemrograman, format konfigurasi, dan bahkan bahasa markup.
    4.  **Efisiensi**: LPEG seringkali sangat efisien. Ini dikompilasi menjadi sebuah _automaton_ (mesin keadaan) yang dapat mem-parsing string dalam waktu linier, menghindari _backtracking_ yang berlebihan yang dapat memperlambat Regex.

  - **Kapan Menggunakan LPEG**:

    - Ketika Lua Patterns standar tidak cukup (misalnya, perlu _parsing_ JSON, HTML sederhana, ekspresi matematika).
    - Ketika Anda perlu mengurai format data atau bahasa DSL (Domain Specific Language) kustom.
    - Ketika kinerja _parsing_ sangat penting.

  - **Penting**: LPEG bukan bagian dari pustaka standar Lua. Anda perlu menginstalnya secara terpisah (misalnya, melalui LuaRocks: `luarocks install lpeg`).

  - **Sumber Terverifikasi**:

    - [LPEG Homepage](http://www.inf.puc-rio.br/~roberto/lpeg/) (Roberto Ierusalimschy, penulis Lua dan LPEG)
    - [LPEG Reference Manual](http://www.inf.puc-rio.br/~roberto/lpeg/lpeg.html)
    - [Wikipedia: Parsing Expression Grammar](https://en.wikipedia.org/wiki/Parsing_expression_grammar)
    - [GitHub - daurnimator/lpeg_patterns](https://github.com/daurnimator/lpeg_patterns) (Contoh penggunaan LPEG)

- **Konsep Dasar LPEG: Pattern objects, operators, and captures**

  LPEG bekerja dengan membangun objek pola yang dapat digabungkan menggunakan operator khusus.

  - **Pola Dasar**:

    - `lpeg.P(string)`: Mencocokkan string literal.
    - `lpeg.P(n)`: Mencocokkan tepat `n` karakter apa pun.
    - `lpeg.S(set)`: Mencocokkan satu karakter dari set yang diberikan (mirip `[]`).
    - `lpeg.R(range)`: Mencocokkan satu karakter dalam rentang (`'az'`, `'09'`).
    - `lpeg.V(name)`: Mereferensikan pola lain (untuk rekursi).
    - `lpeg.any`: Mencocokkan satu karakter apa pun.
    - `lpeg.true`: Selalu berhasil tanpa mengkonsumsi input.
    - `lpeg.false`: Selalu gagal.

  - **Operator Pola**: LPEG menggunakan operator yang di-overload (overloaded operators) untuk menggabungkan pola.

    - `*` (kali): Nol atau lebih (`P*`).
    - `+` (tambah): Satu atau lebih (`P+`).
    - `-` (kurang): Seleksi terurut (Ordered Choice) / ATAU (`P1 - P2` berarti coba P1, jika gagal coba P2). Ini adalah pengganti `|` di regex.
    - `*` (multiplication / sequence): Urutan (`P1 * P2` berarti P1 diikuti P2).
    - `^` (power): Opsi (nol atau satu) (`P^0` sama dengan `P?` di regex).
    - `&` (ampersand): AND predikat (Peek ahead, tidak mengkonsumsi input) (`&P`).
    - `-` (unary minus): NOT predikat (Negative lookahead, tidak mengkonsumsi input) (`-P`).

  - **Captures (Penangkapan)**: LPEG memiliki sistem penangkapan yang jauh lebih canggih daripada Lua Patterns.

    - `P / value`: Mengganti kecocokan dengan nilai yang diberikan.
    - `P / function`: Memanggil fungsi dengan kecocokan sebagai argumen.
    - `P ^ 1`: Capture posisi (mulai dan akhir).
    - `P ^ -1`: Capture nilai kecocokan.
    - `P ^ 'table'`: Membuat tabel dari captures nested.
    - `P ^ 'true'`: Boolean capture (jika cocok).
    - `P ^ 'false'`: Boolean capture (jika tidak cocok).
    - `lpeg.C(P)`: Capture nilai kecocokan `P`.
    - `lpeg.Ct(P)`: Membuat tabel dari captures `P`.
    - `lpeg.Cg(P, name)`: Capture sebagai grup bernama.

  - **Fungsi Utama**:

    - `P:match(subject)`: Mencocokkan pola `P` ke string `subject`. Mengembalikan _captures_ atau `nil`.
    - `P:as_parser()`: Mengkonversi pola menjadi fungsi parser.

  - **Sumber Terverifikasi**: [LPEG Reference Manual](https://www.google.com/search?q=http://www.inf.puc-rio.edu/~roberto/lpeg/lpeg.html), [Lua-users.org Wiki - LPEG Tutorial](http://lua-users.org/wiki/LpegTutorial).

- **Contoh dasar LPEG: Pencocokan string, angka, dan set karakter**

  - **Contoh Kode**:

    ```lua
    local lpeg = require("lpeg") -- Pastikan LPEG sudah terinstal (luarocks install lpeg)

    -- 1. Mencocokkan string literal
    local greeting_pattern = lpeg.P("Hello World")
    print("Match 'Hello World':", greeting_pattern:match("Hello World"))
    -- Output: Match 'Hello World': Hello World (cocokkan string itu sendiri)
    print("Match 'Hello Lua':", greeting_pattern:match("Hello Lua"))
    -- Output: Match 'Hello Lua': nil

    -- 2. Mencocokkan angka (satu atau lebih digit)
    local digit_pattern = lpeg.R('09')^1 -- '09' adalah rentang, ^1 adalah satu atau lebih
    print("Match '12345':", digit_pattern:match("12345"))
    -- Output: Match '12345': 12345
    print("Match 'abc':", digit_pattern:match("abc"))
    -- Output: Match 'abc': nil

    -- 3. Mencocokkan set karakter (huruf vokal)
    local vowel_pattern = lpeg.S("AEIOUaeiou") -- Cocokkan salah satu karakter dalam set
    print("Match 'A':", vowel_pattern:match("A"))
    -- Output: Match 'A': A
    print("Match 'b':", vowel_pattern:match("b"))
    -- Output: Match 'b': nil

    -- 4. Urutan (Sequence)
    local date_pattern = lpeg.R('09')^2 * lpeg.P('/') * lpeg.R('09')^2 * lpeg.P('/') * lpeg.R('09')^4
    -- Contoh: DD/MM/YYYY
    print("Match '25/12/2024':", date_pattern:match("25/12/2024"))
    -- Output: Match '25/12/2024': 25/12/2024

    -- 5. Pilihan Terurut (Ordered Choice) - Operator Minus '-'
    local email_prefix = lpeg.S("AEIOU") - lpeg.S("aeiou") -- Cocokkan A, E, I, O, U (prioritas) atau a, e, i, o, u
    -- Ini sebenarnya akan selalu cocokkan AEIOU jika ada, kemudian aeiou.
    -- Ini lebih baik untuk mencocokkan 'kata kunci' atau 'identifier' dengan prioritas.
    local keyword_or_id = lpeg.P("function") - lpeg.R('az')^1 -- Coba "function" dulu, kalau tidak, coba 1+ huruf
    print("Match 'function':", keyword_or_id:match("function"))
    -- Output: Match 'function': function
    print("Match 'variable':", keyword_or_id:match("variable"))
    -- Output: Match 'variable': variable
    ```

    - **Penjelasan per Sintaksis**:
      - `lpeg.P("Hello World")`: Membuat pola yang secara harfiah cocok dengan string "Hello World".
      - `lpeg.R('09')^1`:
        - `lpeg.R('09')`: Pola yang cocok dengan satu digit (dari 0 hingga 9).
        - `^1`: Kuantifier "satu atau lebih".
      - `lpeg.S("AEIOUaeiou")`: Membuat pola yang cocok dengan satu karakter yang ada di dalam set karakter "AEIOUaeiou".
      - `lpeg.R('09')^2 * lpeg.P('/') * lpeg.R('09')^2 * lpeg.P('/') * lpeg.R('09')^4`:
        - `*`: Operator urutan. Pola-pola digabungkan secara berurutan.
        - `lpeg.R('09')^2`: Cocokkan dua digit.
        - `lpeg.P('/')`: Cocokkan karakter `/` literal.
        - Pola ini secara keseluruhan cocok dengan format tanggal `DD/MM/YYYY`.
      - `lpeg.P("function") - lpeg.R('az')^1`:
        - `-`: Operator pilihan terurut. Pertama coba cocokkan `lpeg.P("function")`. Jika itu berhasil, maka itu yang diambil. Jika tidak, baru coba `lpeg.R('az')^1` (satu atau lebih huruf kecil). Ini penting untuk _parsing_ bahasa di mana kata kunci memiliki prioritas atas identifier.

- **Pola rekursif dan penanganan nested structures (e.g., balanced parentheses)**

  Ini adalah kekuatan utama LPEG yang tidak dimiliki Lua Patterns standar. LPEG dapat dengan mudah mendefinisikan pola rekursif, yang memungkinkan Anda untuk mengurai struktur bersarang.

  - **Contoh (Balanced Parentheses)**:

    ```lua
    local lpeg = require("lpeg")

    local P = lpeg.P
    local V = lpeg.V -- Untuk mereferensikan pola rekursif

    local expr -- Deklarasi forward untuk rekursi

    -- Definisi Pola
    local ident = lpeg.R('az','AZ')^1 -- identifier: satu atau lebih huruf
    local number = lpeg.R('09')^1     -- number: satu atau lebih digit
    local spaces = lpeg.S(' \t')^0    -- nol atau lebih spasi/tab

    -- Sebuah "item" adalah identifier, number, atau sub-ekspresi dalam kurung
    local item = ident - number - P'(' * spaces * V('expr') * spaces * P')'

    -- Ekspresi adalah satu atau lebih item yang dipisahkan oleh spasi
    expr = item * (spaces * item)^0

    -- Buat pola utama yang mencocokkan seluruh string dan membuang spasi di akhir
    local full_parser = spaces * expr * spaces * -lpeg.any -- Match sampai akhir string (-lpeg.any memastikan tidak ada sisa)

    print("Match 'a':", full_parser:match("a"))
    -- Output: Match 'a': a
    print("Match 'a b':", full_parser:match("a b"))
    -- Output: Match 'a b': a b
    print("Match '(a)':", full_parser:match("(a)"))
    -- Output: Match '(a)': (a)
    print("Match '(a b)':", full_parser:match("(a b)"))
    -- Output: Match '(a b)': (a b)
    print("Match '(a (b c))':", full_parser:match("(a (b c))"))
    -- Output: Match '(a (b c))': (a (b c))
    print("Match '((a) (b))':", full_parser:match("((a) (b))"))
    -- Output: Match '((a) (b))': ((a) (b))
    print("Match '((a (b)) c)':", full_parser:match("((a (b)) c)"))
    -- Output: Match '((a (b)) c)': ((a (b)) c)
    print("Match '(a (b c)':", full_parser:match("(a (b c)")) -- Kurung tidak seimbang
    -- Output: Match '(a (b c)': nil
    print("Match 'a)':", full_parser:match("a)")) -- Kurung tidak seimbang
    -- Output: Match 'a)': nil
    ```

    - **Penjelasan per Sintaksis**:
      - `V('expr')`: Ini adalah bagian krusial untuk rekursi. `V` (variable) digunakan untuk mereferensikan pola lain berdasarkan namanya. Di sini, `V('expr')` mereferensikan pola `expr` itu sendiri.
      - `item = ident - number - P'(' * spaces * V('expr') * spaces * P')'`: Sebuah "item" dapat berupa identifier, number, ATAU (operator `-`) sebuah ekspresi yang dikelilingi oleh kurung. `P'(' * ... * P')'` membentuk pola untuk kurung, dan di dalamnya, `V('expr')` memungkinkan ekspresi untuk bersarang di dalam ekspresi lain.
      - `expr = item * (spaces * item)^0`: Sebuah ekspresi adalah satu atau lebih item yang dipisahkan oleh spasi.
      - `full_parser = spaces * expr * spaces * -lpeg.any`: Ini memastikan seluruh string diurai.
        - `spaces`: Mengabaikan spasi awal.
        - `expr`: Pola utama yang akan diurai.
        - `spaces`: Mengabaikan spasi akhir.
        - `-lpeg.any`: Predikat negasi. Ini memastikan bahwa setelah `expr` dan spasi akhir, tidak ada karakter lain yang tersisa di string. Jika ada sisa, pola akan gagal (`nil`). Ini adalah cara yang kuat untuk memastikan kecocokan "seluruh string".

  - **Sumber Terverifikasi**: [LPEG Reference Manual - Examples](https://www.google.com/search?q=http://www.inf.puc-rio.edu/~roberto/lpeg/lpeg.html%23examples), [Programming in Lua - LPEG Chapter (jika ada edisi yang membahasnya)](https://www.lua.org/pil/).

- **Menggunakan LPEG untuk mengurai data terstruktur (JSON, CSV sederhana)**

  LPEG sangat cocok untuk mengurai format data yang terstruktur. Meskipun tidak akan membangun parser JSON lengkap dalam contoh singkat, kita bisa melihat bagaimana elemen-elemen dasar dapat digabungkan.

  - **Contoh (CSV Sederhana)**:

    ```lua
    local lpeg = require("lpeg")

    local P = lpeg.P
    local S = lpeg.S
    local C = lpeg.C -- Capture
    local Ct = lpeg.Ct -- Capture sebagai tabel

    -- Pola untuk karakter non-koma atau non-newline (untuk nilai CSV)
    local value_char = S('\n,')^-1 * lpeg.any -- Mencocokkan karakter apa pun yang bukan koma atau newline
    local value = C(value_char^0)              -- Nilai bisa kosong

    -- Baris: nilai,nilai,...
    local line = Ct(value * (P(',') * value)^0)

    -- File CSV: baris\nbaris\n...
    local csv_file = Ct(line * (P('\n') * line)^0)

    local data_csv = [[
    Apel,100,Merah
    Jeruk,150,Oranye
    Mangga,200,Kuning
    ]]

    local parsed_data = csv_file:match(data_csv)

    print("Parsed CSV Data:")
    for i, row in ipairs(parsed_data) do
        print("Row", i, ":")
        for j, val in ipairs(row) do
            print("  ", j, ":", val)
        end
    end
    -- Output:
    -- Parsed CSV Data:
    -- Row 1 :
    --    1 : Apel
    --    2 : 100
    --    3 : Merah
    -- Row 2 :
    --    1 : Jeruk
    --    2 : 150
    --    3 : Oranye
    -- Row 3 :
    --    1 : Mangga
    --    2 : 200
    --    3 : Kuning
    ```

    - **Penjelasan per Sintaksis**:
      - `value_char = S('\n,')^-1 * lpeg.any`:
        - `S('\n,')^-1`: Ini adalah predikat negasi (`-1`) dari karakter set `'\n,'`. Ini berarti "cocokkan jika karakter berikutnya BUKAN newline atau koma".
        - `* lpeg.any`: Setelah memeriksa, cocokkan karakter apa pun.
        - Hasilnya: `value_char` akan cocok dengan satu karakter yang bukan pemisah (`\n` atau `,`).
      - `value = C(value_char^0)`:
        - `value_char^0`: Nol atau lebih karakter `value_char` (ini memungkinkan nilai kosong).
        - `C(...)`: Ini adalah _capture_ dasar di LPEG. Ini akan menangkap seluruh string yang cocok dengan `value_char^0`.
      - `line = Ct(value * (P(',') * value)^0)`:
        - `Ct(...)`: Ini adalah _capture_ yang mengumpulkan semua _nested captures_ ke dalam sebuah **tabel**.
        - `value`: Cocokkan nilai pertama di baris.
        - `(P(',') * value)^0`: Nol atau lebih pasangan "koma diikuti nilai".
        - Hasilnya: `line` akan mengembalikan sebuah tabel yang berisi semua nilai di baris tersebut.
      - `csv_file = Ct(line * (P('\n') * line)^0)`:
        - Sama seperti `line`, `csv_file` menggunakan `Ct` untuk mengumpulkan baris-baris ke dalam tabel utama.
        - `line`: Cocokkan baris pertama.
        - `(P('\n') * line)^0`: Nol atau lebih pasangan "newline diikuti baris".
        - Hasilnya: `csv_file` akan mengembalikan sebuah tabel yang berisi tabel-tabel baris.

  - **Sumber Terverifikasi**: [LPEG Reference Manual - Examples](https://www.google.com/search?q=http://www.inf.puc-rio.edu/~roberto/lpeg/lpeg.html%23examples), [Lua-users.org Wiki - LPEG Contoh](https://www.google.com/search?q=http://lua-users.org/wiki/LpegExamples).

---

### **6.2 Best Practices & Advanced Tips**

- **Pentingnya `string.find(s, p, init, true)` (plain search)**

  - Seperti yang dibahas sebelumnya, `string.find()` memiliki argumen keempat `plain`. Jika `plain` disetel ke `true`, `pattern` akan diperlakukan sebagai string literal dan **bukan** pola Lua.

  - **Kapan Digunakan**: Selalu gunakan `plain = true` ketika Anda hanya mencari substring literal dan tidak membutuhkan kekuatan pola Lua.

  - **Keuntungan**:

    - **Kinerja**: Pencarian _plain_ jauh lebih cepat daripada pencarian pola, karena tidak perlu memproses aturan pola.
    - **Keamanan**: Mencegah interpretasi karakter khusus pola (`.`, `*`, `+`, dll.) secara tidak sengaja.
    - **Klaritas Kode**: Jelas menunjukkan bahwa Anda mencari string harfiah.

  - **Contoh Kode**:

    ```lua
    local text = "harga Rp10.000 (diskon 5%)"

    -- Mencari "5%" sebagai pola (akan gagal atau salah tafsir tanpa escape)
    print("Pola '5%':", string.find(text, "5%")) -- Ini akan mencoba 5 diikuti pattern apa saja. Mungkin error.

    -- Mencari "5%" sebagai literal string (yang benar)
    print("Literal '5%':", string.find(text, "5%%")) -- Escape manual
    print("Literal '5%':", string.find(text, "5%", 1, true)) -- Plain search
    -- Output (kurang lebih):
    -- Pola '5%': nil (tergantung string dan versi Lua, bisa error atau nil)
    -- Literal '5%': 20	21
    -- Literal '5%': 20	21
    ```

  - **Sumber Terverifikasi**: Lua 5.4 Reference Manual Section 6.4 (string.find).

- **Membangun tabel dengan hasil `string.gmatch()`**

  - `string.gmatch()` mengembalikan sebuah _iterator_. Jika Anda ingin mengumpulkan semua hasil kecocokan ke dalam sebuah tabel, Anda harus melakukannya secara eksplisit.
  - **Contoh Kode**:

    ```lua
    local function collect_all_matches(s, pattern)
        local results = {}
        for match in string.gmatch(s, pattern) do
            table.insert(results, match)
        end
        return results
    end

    local sentence = "apple banana orange grape"
    local fruits = collect_all_matches(sentence, "%a+")

    print("Collected fruits:")
    for i, fruit in ipairs(fruits) do
        print(i, fruit)
    end
    -- Output:
    -- Collected fruits:
    -- 1	apple
    -- 2	banana
    -- 3	orange
    -- 4	grape
    ```

  - **Sumber Terverifikasi**: Lua-users.org Wiki (String Library Tutorial).

- **Menggunakan `string.dump()` untuk fungsi (bytecode) [Topik Tingkat Lanjut]**

  - `string.dump()` adalah fungsi yang mengubah fungsi Lua (dalam bentuk _closure_) menjadi representasi biner (_bytecode_) yang dapat disimpan ke file atau ditransmisikan. Ini adalah topik yang sangat tingkat lanjut dan lebih banyak terkait dengan _serialization_ atau _code generation_ daripada manipulasi string biasa.
  - **Sintaks Dasar**: `string.dump(function [, strip])`
    - `function`: Fungsi yang akan di-_dump_.
    - `strip` (opsional, boolean): Jika `true`, informasi _debug_ (nama variabel, nomor baris) akan dihapus dari bytecode.
  - **Contoh Konseptual (tidak selalu praktis untuk penggunaan sehari-hari)**:

    ```lua
    local my_func = function(x, y) return x + y end
    local bytecode = string.dump(my_func)

    -- Anda bisa menyimpan 'bytecode' ini ke file atau mengirimkannya
    -- Nanti, Anda bisa memuatnya kembali:
    local loaded_func = load(bytecode)

    print(loaded_func(5, 3)) -- Output: 8
    ```

  - **Peringatan**: `string.dump()` membuat bytecode yang tergantung pada versi Lua dan arsitektur CPU (endianness). Bytecode yang di-_dump_ di satu sistem mungkin tidak dapat dimuat di sistem lain jika ada perbedaan arsitektur atau versi Lua yang signifikan.
  - **Sumber Terverifikasi**: Lua 5.4 Reference Manual Section 6.4.

---

Dengan ini, kita telah menyelesaikan semua level dalam **KURIKULUM LENGKAP STRING LUA (REVISI 2025)**\!

Anda telah menempuh perjalanan dari dasar-dasar string hingga konsep lanjutan seperti LPEG dan penanganan Unicode. Anda sekarang memiliki pemahaman yang komprehensif tentang:

- Deklarasi string, _escape sequences_, dan _long strings_.
- Operasi fundamental seperti konkatenasi, panjang, dan perbandingan.
- Fungsi pustaka `string` untuk manipulasi (upper, lower, reverse, sub, rep).
- Fungsi pencarian (`find`, `match`, `gmatch`) dan penggunaannya.
- Fungsi modifikasi (`gsub`, `format`).
- **Lua Patterns** secara mendalam, termasuk _character classes_, _quantifiers_, _anchors_, dan _captures_.
- Teknik _string cleaning_ dan _validation_.
- Strategi _joining_ dan _splitting_ string yang efisien.
- Implikasi _immutability_ string dan optimasi kinerja.
- **Penanganan UTF-8 dan Unicode** dengan pustaka `utf8` di Lua 5.3+.
- Pengantar **LPEG** untuk _parsing_ yang kompleks dan rekursif.

Ini adalah dasar yang sangat kuat untuk setiap proyek Lua yang melibatkan manipulasi teks. Selamat\! Sekarang Anda bisa mulai mempraktikkan semua yang telah Anda pelajari dalam proyek nyata.

</details>

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-5/README.md
[selanjutnya]: ../bagian-7/README.md

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
