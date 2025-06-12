Kita telah menguasai pattern bawaan Lua, yang sangat efisien untuk tugas-tugas umum. Namun, seperti yang telah disinggung, ada batasan yang akan Kita temui, terutama saat berhadapan dengan data yang memiliki struktur bersarang atau rekursif (seperti HTML, JSON, atau kode pemrograman).

Untuk melampaui batasan ini, kita perlu beralih ke alat yang dirancang khusus untuk pekerjaan berat: **LPeg**. Bagian ini adalah lompatan besar dari *pattern matching* ke *parsing* sejati.

-----

### Catatan Penting: LPeg adalah Library Eksternal

Tidak seperti `string.match`, LPeg bukan bagian dari library standar Lua. Ini adalah library C yang sangat dioptimalkan yang perlu Kita tambahkan ke lingkungan Lua Kita. Cara paling umum untuk menginstalnya adalah melalui [LuaRocks](https://luarocks.org/), manajer paket untuk Lua:

```bash
luarocks install lpeg
```

Setelah terinstal, Kita dapat menggunakannya di dalam skrip Lua Kita dengan: `local lpeg = require("lpeg")`.

-----

### Daftar Isi (Bagian IV)

  * [**BAGIAN IV: LPEG - PARSING EXPRESSION GRAMMARS**](#bagian-iv-lpeg---parsing-expression-grammars)
      * [4.1 LPeg Fundamentals](#41-lpeg-fundamentals)
      * [4.2 LPeg Advanced Patterns](#42-lpeg-advanced-patterns)
      * [4.3 LPeg Captures dan Transformations](#43-lpeg-captures-dan-transformations)
      * [4.4 Building Complex Grammars](#44-building-complex-grammars)
      * [4.5 LPeg Performance Optimization](#45-lpeg-performance-optimization)
      * [4.6 Real-world LPeg Applications](#46-real-world-lpeg-applications)

-----


## **BAGIAN IV: LPEG - PARSING EXPRESSION GRAMMARS**

LPeg adalah implementasi dari *Parsing Expression Grammars* (PEG), sebuah formalisme untuk mendeskripsikan bahasa formal.


### 4.1 LPeg Fundamentals

  * **PEG vs Traditional Regex**

      * **PEG itu Pasti (Deterministic)**: Ini perbedaan paling fundamental. Dalam Regex, operator alternasi `|` bisa ambigu. Jika `A|B` cocok dengan `A`, mesin Regex mungkin masih harus *backtrack* dan mencoba `B` jika sisa pattern gagal. Dalam PEG, operator pilihan (ordered choice) `+` (atau `/` dalam notasi formal) bersifat serakah dan pasti. Jika `A + B` cocok dengan `A`, ia **tidak akan pernah** mencoba `B`. Ini menghilangkan ambiguitas dan membuat grammar lebih mudah diprediksi.
      * **Dibangun untuk Parsing**: Regex dirancang untuk "mencari", sementara PEG dirancang untuk "mem-parsing" seluruh input dari awal hingga akhir.

  * **Filosofi dan Keunggulan LPeg**

      * **Composable**: Kita membangun grammar kompleks dengan menggabungkan pattern-pattern kecil.
      * **Powerful**: Mampu mem-parsing struktur rekursif yang mustahil bagi pattern standar Lua.
      * **Cepat**: LPeg mengkompilasi grammar Kita menjadi bytecode internal sekali, sehingga eksekusi berulang kali sangat cepat.

  * **Konstruksi Pattern Dasar**
    LPeg menyediakan fungsi-fungsi untuk membuat pattern dasar:

      * `lpeg.P(string)`: Mencocokkan string literal. `lpeg.P("hello")`.
      * `lpeg.S(string)`: Mencocokkan salah satu karakter dari set. `lpeg.S("+-*/")`.
      * `lpeg.R("az", "09")`: Mencocokkan karakter dalam rentang (range). `lpeg.R("09")` cocok dengan satu digit.
      * `lpeg.P(n)`: Mencocokkan tepat `n` karakter.

  * **Operator Dasar**

      * Konkatenasi (`*`): `p1 * p2` mencocokkan `p1` diikuti oleh `p2`.
      * Pilihan Terurut (`+`): `p1 + p2` mencoba mencocokkan `p1`. Jika gagal, ia mencoba `p2`.
      * Repetisi (`^`): `patt^n` mencocokkan `patt` `n` kali atau lebih. `patt^0` cocok 0 kali atau lebih (seperti `*` di Regex). `patt^1` cocok 1 kali atau lebih (seperti `+` di Regex).

    <!-- end list -->

    ```lua
    local lpeg = require("lpeg")

    local digit = lpeg.R("09")
    local digits = digit^1 -- satu atau lebih digit
    local maybe_sign = lpeg.S("+-")^-1 -- nol atau satu tanda
    local integer = maybe_sign * digits

    -- Mencocokkan integer
    print(integer:match("123"))  -- Output: 123
    print(integer:match("-45"))  -- Output: -45
    print(integer:match("abc"))  -- Output: nil
    ```


### 4.2 LPeg Advanced Patterns

  * **Lookahead (Melihat ke Depan)**

      * **Positive Lookahead (`&patt`)**: Dinyatakan dengan operator `&`. `&patt` berhasil jika `patt` dapat dicocokkan di posisi saat ini, tetapi ia **tidak memakan (consume)** input apa pun.
      * **Negative Lookahead (`!patt`)**: Dinyatakan dengan operator `!`. `!patt` berhasil jika `patt` **tidak dapat** dicocokkan di posisi saat ini, dan juga tidak memakan input.

    <!-- end list -->

    ```lua
    local lpeg = require("lpeg")
    local letter = lpeg.R("az")

    -- Pattern untuk mencocokkan "end" hanya jika tidak diikuti oleh huruf lain (batasan kata)
    local end_of_word = lpeg.P("end") * !letter

    print(end_of_word:match("the end of the world")) -- Output: end
    print(end_of_word:match("the ending"))         -- Output: nil
    ```

  * **Grammar Definitions (Mendefinisikan Grammar)**

      * Ini adalah inti dari kekuatan LPeg. Kita mendefinisikan grammar menggunakan sebuah tabel, di mana setiap entri adalah sebuah "aturan" (rule). Aturan dapat merujuk satu sama lain, memungkinkan **rekursi**.
      * `lpeg.V(name)` digunakan untuk merujuk ke aturan lain (`name` adalah key dalam tabel grammar).

    **Contoh: Grammar untuk Tanda Kurung Seimbang**

    ```lua
    local lpeg = require("lpeg")

    -- "S" adalah aturan awal (start rule)
    local grammar = lpeg.P{
      "S",
      S = lpeg.P("(") * (lpeg.P(1) - lpeg.P(")"))^0 * lpeg.P(")") +
          lpeg.P("(") * lpeg.V("S")^0 * lpeg.P(")")
    }

    print(grammar:match("(a(b)c)"))  -- Output: (a(b)c)
    print(grammar:match("()(())"))  -- Output: ()(())
    print(grammar:match("(a(b"))     -- Output: nil
    ```


### 4.3 LPeg Captures dan Transformations

LPeg memiliki sistem *capture* yang jauh lebih canggih daripada pattern standar.

  * `lpeg.C(p)`: **Simple Capture**. Menangkap substring yang cocok dengan pattern `p`.
  * `lpeg.Ct(p)`: **Table Capture**. Mengumpulkan semua capture yang dibuat oleh `p` ke dalam sebuah tabel.
  * `p / function`: **Function Capture**. Meneruskan semua capture dari `p` ke sebuah fungsi dan mengganti hasil capture dengan apa pun yang dikembalikan oleh fungsi tersebut. Ini sangat kuat untuk membangun struktur data (seperti AST) secara langsung saat parsing.
  * `p / string`: **String Substitution Capture**. Mengganti kecocokan dengan string, bisa menggunakan backreferences `%n`.
  * `lpeg.Cg(p, name)`: **Group Capture**. Menangkap semua capture dari `p` dan menyimpannya dalam sebuah grup bernama `name`.

**Contoh: Parsing dan Transformasi CSV**

```lua
local lpeg = require("lpeg")

-- Aturan untuk satu field (bisa di dalam kutipan atau tidak)
local quoted_field = lpeg.P('"') * lpeg.C((lpeg.P(1) - lpeg.P('"'))^0) * lpeg.P('"')
local unquoted_field = lpeg.C((lpeg.P(1) - lpeg.S(',\n'))^0)
local field = quoted_field + unquoted_field

-- Aturan untuk satu baris (satu field, diikuti oleh nol atau lebih ",field")
local line = lpeg.Ct(field * (lpeg.P(",") * field)^0)

-- Parsing
local result = line:match('"budi",25,"jakarta"')
for k, v in ipairs(result) do
    print(k, v)
end
-- Output:
-- 1   budi
-- 2   25
-- 3   jakarta
```


### 4.4 Building Complex Grammars

  * **Recursive Grammar dan AST Construction**
    Dengan menggabungkan `lpeg.V`, `lpeg.Ct`, dan function captures, kita bisa membangun *Abstract Syntax Tree* (AST).

    **Contoh: Parser Ekspresi Aritmatika Sederhana (menjadi AST)**

    ```lua
    local lpeg = require("lpeg")

    -- Helper untuk membuat node AST
    function make_node(op)
      return function(l, r) return {tag = op, left = l, right = r} end
    end

    local grammar = lpeg.P{ "Expr",
      Expr    = lpeg.V"Term" * ( (lpeg.P"+" * lpeg.V"Term" / make_node("add")) +
                                 (lpeg.P"-" * lpeg.V"Term" / make_node("sub")) )^0,
      Term    = lpeg.V"Factor" * ( (lpeg.P"*" * lpeg.V"Factor" / make_node("mul")) +
                                   (lpeg.P"/" * lpeg.V"Factor" / make_node("div")) )^0,
      Factor  = lpeg.R"09"^1 / tonumber + lpeg.P"(" * lpeg.V"Expr" * lpeg.P")",
    }

    local ast = grammar:match("1+2*3")
    -- Hasilnya akan menjadi tabel Lua yang merepresentasikan struktur pohon dari operasi.
    -- (Akan sangat kompleks untuk dicetak di sini, tapi strukturnya adalah {tag="add", left=1, right={tag="mul", left=2, right=3}})
    ```


### 4.5 LPeg Performance Optimization

  * **Compilation Strategies**: Keuntungan performa terbesar datang dari fakta bahwa LPeg mengkompilasi grammar saat pertama kali dibuat. Praktik terbaik adalah mendefinisikan grammar Kita sekali dan menyimpannya dalam variabel lokal, lalu gunakan kembali variabel tersebut.
    ```lua
    -- Baik: Dibuat dan dikompilasi sekali
    local my_grammar = lpeg.P{...}
    for i=1, 1000 do my_grammar:match(inputs[i]) end

    -- Buruk: Dibuat dan dikompilasi ulang di setiap iterasi loop
    for i=1, 1000 do lpeg.P{...}:match(inputs[i]) end
    ```
  * **Memory Usage**: Hati-hati dengan capture. Jika Kita tidak memerlukan sebuah nilai, jangan menangkapnya. `lpeg.C` mengalokasikan string baru yang bisa memakan memori.


### 4.6 Real-world LPeg Applications

  * **Programming Language Parsers**: LPeg cukup kuat untuk mem-parsing bahasa pemrograman. Contoh paling terkenal adalah **MoonScript**, sebuah bahasa yang dikompilasi ke Lua, yang parser-nya dibuat menggunakan LPeg.
  * **Data Format Converters**: Mengonversi dari satu format data terstruktur ke format lain (misalnya, Markdown ke HTML, BBCode ke XML).
  * **Configuration File Processors**: Untuk file konfigurasi dengan sintaks yang kompleks dan aturan bersarang yang tidak bisa ditangani dengan mudah oleh pattern standar.

-----

Bagian ini telah membawa Kita dari matching sederhana ke dunia pembuatan parser. Kita sekarang memiliki alat untuk mendefinisikan dan mem-parsing hampir semua bahasa atau format data terstruktur. Di bagian selanjutnya, kita akan menerapkan pengetahuan ini untuk mem-parsing format data spesifik seperti XML dan JSON, baik dengan pattern maupun dengan library khusus.

#


> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

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
