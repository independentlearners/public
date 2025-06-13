Kita telah bergerak dari mencocokkan teks, mengekstrak data, memanipulasi string, hingga mem-parsing bahasa formal dengan LPeg. Sekarang, kita akan memasuki ranah yang lebih abstrak dan kuat: **Metaprogramming**. Ini adalah tentang menulis program yang menulis atau memanipulasi program lain (atau dirinya sendiri). Dalam konteks ini, kita akan menggunakan pattern sebagai alat untuk membangun logika yang dinamis, menciptakan bahasa mini, dan bahkan menghasilkan kode.

---

### Daftar Isi (Bagian VI)

- [**BAGIAN VI: METAPROGRAMMING DENGAN PATTERNS**](#bagian-vi-metaprogramming-dengan-patterns)
  - [6.1 Dynamic Pattern Generation](#61-dynamic-pattern-generation)
  - [6.2 Pattern-based DSL Creation](#62-pattern-based-dsl-creation)
  - [6.3 Metatable Integration](#63-metatable-integration)
  - [6.4 Code Generation dengan Patterns](#64-code-generation-dengan-patterns)

---

## **[BAGIAN VI: METAPROGRAMMING DENGAN PATTERNS][0]**

Metaprogramming adalah salah satu fitur paling canggih dari bahasa dinamis seperti Lua. Alih-alih menulis pattern sebagai string statis, kita akan membuatnya "hidup" dan beradaptasi sesuai kebutuhan program saat runtime.

### 6.1 Dynamic Pattern Generation

Ini adalah bentuk metaprogramming yang paling sederhana, di mana kita membangun string pattern secara terprogram.

- **Runtime Pattern Construction**: Daripada menulis pattern yang kaku, kita buat fungsi yang merakitnya berdasarkan input.
- **Pattern Factory Functions**: Fungsi yang tugasnya adalah "memproduksi" pattern.

**Contoh: Membuat Pattern Pencarian dari Daftar Kata**

```lua
--- Fungsi ini membuat pattern LPeg untuk mencocokkan salah satu kata dari sebuah tabel.
-- @param words Tabel berisi string kata-kata.
-- @return pattern LPeg.
function createWordMatcher(words)
  local lpeg = require("lpeg")
  local pattern = lpeg.P(false) -- Mulai dengan pattern yang selalu gagal

  for _, word in ipairs(words) do
    pattern = pattern + lpeg.P(word) -- Tambahkan setiap kata sebagai pilihan
  end

  return pattern
end

local keywords = {"error", "warning", "info"}
local log_matcher = createWordMatcher(keywords)

print(log_matcher:match("error: system failure"))   -- Output: error
print(log_matcher:match("info: user logged in"))    -- Output: info
print(log_matcher:match("debug: value is nil"))     -- Output: nil
```

- **Conditional Pattern Selection**: Sebuah fungsi dapat memilih pattern mana yang akan digunakan berdasarkan konteks. Misalnya, sebuah parser bisa mencoba pattern untuk tanggal format AS (`MM/DD/YYYY`), dan jika gagal, ia secara dinamis mencoba pattern format Eropa (`DD/MM/YYYY`).

### 6.2 Pattern-based DSL Creation

_DSL_ adalah singkatan dari _Domain-Specific Language_, yaitu bahasa komputer mini yang dirancang untuk domain masalah yang sangat spesifik. Pattern, khususnya LPeg, adalah mesin yang sempurna untuk mem-parse DSL ini.

- **Custom Syntax Definition**: Anda mendefinisikan "tata bahasa" atau sintaks dari bahasa mini Anda.
- **Pattern Interpretation Engines**: Anda menggunakan LPeg untuk menulis parser yang menafsirkan sintaks tersebut dan mengubahnya menjadi sesuatu yang dapat dieksekusi oleh Lua (misalnya, tabel data atau pemanggilan fungsi).
- **Syntax Sugar**: DSL seringkali menyediakan "pemanis sintaksis" (syntax sugar), yaitu cara penulisan yang lebih mudah dan lebih ekspresif untuk tugas yang jika tidak, akan memerlukan kode yang bertele-tele.

**Contoh: DSL Sederhana untuk Query Log**
Bayangkan kita ingin sintaks query seperti: `from:server1 level:error "system failure"`.

```lua
local lpeg = require("lpeg")

-- Grammar untuk DSL query kita
local space = lpeg.S(" ")^1
local word = (lpeg.P(1) - space)^1
local quoted = lpeg.P('"') * lpeg.C((lpeg.P(1) - lpeg.P('"'))^0) * lpeg.P('"')

-- Aturan untuk 'key:value'
local pair = lpeg.Cg(lpeg.C(word) * lpeg.P(":") * lpeg.C(word), "pair")
-- Aturan untuk teks bebas dalam kutipan
local freetext = lpeg.Cg(quoted, "freetext")

local query_part = pair + freetext
local full_query = lpeg.Ct(query_part * (space * query_part)^0)

-- Fungsi untuk mengubah hasil parse menjadi tabel yang lebih berguna
local function process_captures(captures)
    local result = {freetext = {}}
    for _, cap in ipairs(captures) do
        if cap.tag == "pair" then
            result[cap[1]] = cap[2] -- cap[1] adalah key, cap[2] adalah value
        elseif cap.tag == "freetext" then
            table.insert(result.freetext, cap[1])
        end
    end
    return result
end

-- Gabungkan parser dengan prosesor
local parser = full_query / process_captures

local result = parser:match('from:server1 level:error "system failure"')

print("Hasil Query:")
print(" from:", result.from)       -- Output:  from:   server1
print(" level:", result.level)      -- Output:  level:  error
print(" freetext:", result.freetext[1]) -- Output:  freetext:       system failure
```

### 6.3 Metatable Integration

Di sinilah dua fitur paling kuat dari Lua bertemu: metatables yang mengubah perilaku tabel, dan pattern yang memproses teks. Kombinasi keduanya menghasilkan solusi yang sangat elegan.

- **Pattern Matching dalam Metamethods**: Anda bisa memicu operasi pattern matching di dalam metamethod seperti `__index` atau `__newindex`.

**Contoh: Tabel Konfigurasi "Cerdas"**
Bayangkan sebuah tabel konfigurasi di mana Anda bisa meminta nilai dengan format `config.background_color_hex`. Metamethod `__index` akan menangkap permintaan ini, mem-parsing `background_color_hex` untuk mengetahui bahwa Anda meminta warna `background_color` dalam format `hex`, lalu mengembalikannya.

```lua
local config_data = {
  background_color = { r = 255, g = 100, b = 50 }
}

local mt = {
  __index = function(tbl, key)
    -- Coba parse key, misal "background_color_hex"
    local color_name, format = string.match(key, "([a-z_]+)_(hex)")

    if color_name and format then
      local color = rawget(tbl, color_name) -- Akses data mentah
      if color then
        -- Lakukan konversi
        return string.format("#%02x%02x%02x", color.r, color.g, color.b)
      end
    end
    return nil
  end
}

setmetatable(config_data, mt)

print(config_data.background_color_hex) -- Output: #ff6432
```

- **Object-Oriented Pattern Matching**: Sebuah objek bisa memiliki metodenya sendiri untuk melakukan pencocokan, menggunakan pattern yang mungkin disimpan secara internal di dalam objek itu sendiri.

### 6.4 Code Generation dengan Patterns

Ini adalah langkah terakhir dalam metaprogramming: menggunakan pattern untuk menghasilkan kode sumber atau format teks terstruktur lainnya.

- **Template Engines**: Ini adalah aplikasi yang paling umum. Kita sudah melihatnya di Bagian III dengan `string.gsub` dan fungsi callback. Sebuah pattern `(${...})` digunakan untuk menemukan placeholder dalam file template, dan fungsi callback menggantinya dengan data dari sebuah tabel untuk menghasilkan output akhir (misalnya, file HTML atau email).
- **Code Transformation Tools**: Anda dapat menulis skrip yang membaca file kode, menggunakan pattern untuk menemukan sintaks atau pemanggilan fungsi tertentu, dan menggantinya dengan versi yang diperbarui. Ini sangat berguna untuk melakukan refactoring kode secara otomatis.
- **AST Manipulation**: Setelah Anda mem-parse kode menjadi Abstract Syntax Tree (AST) menggunakan LPeg (seperti di Bagian IV), AST ini hanyalah sebuah struktur tabel Lua. Anda bisa menelusuri pohon ini, memodifikasi nodenya, lalu menulis fungsi "unparser" atau "generator" yang mengubah AST yang telah dimodifikasi itu kembali menjadi string kode sumber, baik dalam bahasa asli maupun bahasa target yang berbeda (misalnya, transpiler).

---

Bagian ini telah menunjukkan bagaimana pattern dapat ditingkatkan dari alat analisis teks menjadi komponen inti dari sistem dinamis yang canggih. Anda telah belajar cara membuat pattern saat runtime, merancang bahasa mini, dan bahkan menghasilkan kode. Selanjutnya, kita akan bergeser dari pattern yang berfokus pada string ke pattern pemrograman yang lebih luas, seperti coroutines dan state machines, dan melihat bagaimana konsep-konsep ini dapat berinteraksi.

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

[0]: ../README.md#bagian-vi-metaprogramming-dengan-patterns
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
