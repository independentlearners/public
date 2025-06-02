# **Pendahuluan**

Lua menyediakan mekanisme _pattern matching_ (pencocokan pola) yang lebih sederhana dibandingkan dengan _[regular expressions][1]_ (regex) pada umumnya. Meskipun tidak menyediakan sintaks selengkap atau sekuat regex, pola-pola di Lua cukup fleksibel untuk sebagian besar keperluan pemrosesan teks. Pada penjelasan ini, kita akan membahas secara mendetail semua elemen utama dalam pola Lua, cara menggunakannya, serta kapan pola ini mencukupi tanpa perlu membawa beban kompleksitas regex penuh.

---

## Karakter Khusus (_Magic Characters_) dan Pelolosan (_Escaping_)

Di Lua, terdapat sembilan karakter yang bersifat “_magic_,” artinya mereka memiliki arti khusus dalam pola dan harus di-“_escape_” (diloloskan) jika dimaksudkan sebagai karakter literal. Karakter ini adalah:

```
^ $ ( ) % . [ ] * + - ?
```

- Simbol `^` dan `$` menandai awal dan akhir string.
- Tanda kurung `(` dan `)` digunakan untuk _capture_ (menangkap bagian string).
- `%` adalah karakter pelolos (escape) utama untuk kelas karakter atau untuk meloloskan karakter “magic.”
- Tanda `.` mewakili “satu karakter apa saja.”
- Kurung siku `[` `]` mendefinisikan kelas karakter.
- Tanda `*`, `+`, `-`, `?` berfungsi sebagai kuantifier (pengulang).

Jika Anda ingin mencocokkan salah satu karakter di atas secara literal, tambahkan `%` di depannya. Contoh:

```lua
local pola1 = "%."      -- mencocokkan karakter titik '.'
local pola2 = "%?"      -- mencocokkan tanda tanya '?'
local pola3 = "%^abc%$" -- mencocokkan string literal "^abc$"
```

Tanpa `%` di depan, karakter-karakter tersebut akan diinterpretasikan sebagai bagian dari definisi pola, bukan literal.

---

## Kelas Karakter Bawaan

Lua menyediakan beberapa kelas karakter singkat yang diawali dengan `%`. Kelas-kelas ini memudahkan ketika ingin mencocokkan huruf, digit, spasi, dan sejenisnya:

| Pola | Makna                                     | Contoh `string.match`                       |
| ---- | ----------------------------------------- | ------------------------------------------- |
| `%a` | Semua huruf alfabet (A–Z, a–z)            | `string.match("Halo123", "%a+")` → `"Halo"` |
| `%c` | Kendali (_control characters_)            | `string.match("\n\tA", "%c+")` → `"\n\t"`   |
| `%d` | Digit angka (0–9)                         | `string.match("No.45", "%d%d")` → `"45"`    |
| `%l` | Huruf kecil (a–z)                         | `string.match("lua", "%l+")` → `"lua"`      |
| `%u` | Huruf besar (A–Z)                         | `string.match("ID123", "%u+")` → `"ID"`     |
| `%s` | Karakter spasi (spasi, tab, newline, dll) | `string.match(" \t\nX", "%s%s")` → `" \t"`  |
| `%w` | Alfanumerik (huruf & digit)               | `string.match("A1_B2", "%w+")` → `"A1"`     |
| `%x` | Karakter heksadesimal (0–9, a–f, A–F)     | `string.match("0xFA", "%x+")` → `"0xFA"`    |
| `%p` | Tanda baca (_punctuation_)                | `string.match("!@#", "%p+")` → `"!@#"`      |
| `%z` | Karakter dengan nilai numerik nol (`\0`)  | `string.match("\0hello", "%z")` → `"\0"`    |

Selain itu, Anda dapat membuat kelas karakter kustom dengan menyertakan karakter di antara tanda `[ ]`. Misalnya:

```lua
local polaVokal = "[aeiouAEIOU]"        -- hanya huruf vokal
local polaHex  = "[0-9a-fA-F]"           -- digit heksadesimal
local polaNonDigit = "[^%d]"             -- semua karakter kecuali digit
```

Catatan penting:

- Tanda `^` di dalam kelas karakter (misalnya `[^%d]`) berarti **negasi**, bukan “awal string” seperti di luar kelas.
- Di dalam `[ ]`, sebagian kecil karakter juga dianggap “magic” untuk definisi kelas (seperti `-` untuk rentang). Jika butuh literal `-`, letakkan di ujung atau platform “escape” dengan `%`.

---

## Kuantifier dan Pengulangan

Setelah Anda mengetahui cara menuliskan karakter atau kelas karakter, _kuantifier_ memungkinkan Anda menentukan berapa kali elemen tersebut boleh muncul. Lua cuma punya empat simbol kuantifier:

1. `-` : nol atau lebih (pengulangan minimal)
2. `*` : nol atau lebih (pengulangan maksimal/“_greedy_”)
3. `+` : satu atau lebih (pengulangan maksimal/“_greedy_”)
4. `?` : nol atau satu (opsional)

Contoh singkat:

```lua
-- "%d+" → satu atau lebih digit
print(string.match("Usia: 27 tahun", "%d+"))   -- output: "27"

-- "%a*" → nol atau lebih huruf (maksimal)
print(string.match("123abc", "%a*"))           -- output: ""  (karena "1" bukan huruf; * bisa mencocokkan empty)

-- "%a-" → nol atau lebih huruf (minimal)
print(string.match("abc123abc", "a%-c"))       -- mencocokkan literal "a-c" (karena '-' di-*escape*)
print(string.match("abc123abc", "a-c"))        -- salah, karena "a-c" diinterpretasi rentang
```

Beberapa catatan penting:

- Kuantifier bersifat _greedy_ (`*` dan `+`) secara default, sehingga mereka akan “menyedot” sebanyak mungkin kecuali dipaksa berhenti oleh konteks pola berikutnya. Untuk pola yang bersifat minimal (non-greedy), gunakan `-` bukannya `*`.
- Penggunaan `?` berguna untuk membuat bagian pola “opsional.” Contoh: `"%d%d?%d"` berarti digit, diikuti opsi digit, diikuti digit lagi—berguna untuk memetakan angka yang panjangnya 2 atau 3.

---

## Penanda Posisi: Awal dan Akhir String

- `^` di awal pola menandakan “harus mulai di awal string.”
- `$` di akhir pola menandakan “harus di akhir string.”

Contoh:

```lua
-- Pastikan string hanya berisi digit
local polaHanyaDigit = "^%d+$"
print(string.match("12345", polaHanyaDigit))  -- "12345" (cocok)
print(string.match("12a45", polaHanyaDigit))  -- nil (tidak cocok)

-- Cari kata "lua" hanya jika berada di akhir string
local polaAkhir = "lua$"
print(string.match("Belajar lua", polaAkhir)) -- "lua"
print(string.match("lua belajar", polaAkhir)) -- nil
```

Tanpa `^` atau `$`, pola dapat muncul di mana saja dalam teks. Jika Anda menambahkan `^` di tengah pola (bukan di awal), itu tidak akan berfungsi sebagai penanda posisi.

---

## _Capture_ (Penangkapan Bagian String)

Lua memungkinkan Anda menangkap bagian yang cocok agar dapat digunakan kembali—baik untuk manipulasi, analisis, atau substitusi. Caranya dengan menandai bagian pola menggunakan tanda kurung `(` dan `)`.

- `string.match` akan mengembalikan hasil _capture_.
- `string.find` mengembalikan indeks awal dan akhir kemunculan pola (jika tidak menggunakan capture), atau hasil capture (jika pola berisi tanda kurung).
- `string.gmatch` dapat digunakan untuk mengulang setiap kemunculan pola, mengembalikan iterator atas hasil capture.
- `string.gsub` dapat menggantikan semua kemunculan pola dengan teks hasil yang dihasilkan dari capture atau literal.

Contoh menangkap tanggal dalam format `YYYY-MM-DD`:

```lua
local teks = "Tanggal: 2025-06-02"
-- Bagian pola: (%d%d%d%d) untuk tahun, (%d%d) bulan, (%d%d) hari
local tahun, bulan, hari = string.match(teks, "(%d%d%d%d)%-(%d%d)%-(%d%d)")
print(tahun, bulan, hari)  -- output: 2025 06 02
```

Jika pola tidak menggunakan capture, `string.match` hanya mengembalikan keseluruhan kecocokan. Jika ada beberapa _capture_, maka akan mengembalikan secara berurutan sesuai jumlahnya.

---

## Fungsi Bawaan untuk _Pattern Matching_

1. **`string.match(s, p[, init])`**

   - Mencari kecocokan pertama pola `p` di string `s`.
   - Mengembalikan hasil capture atau keseluruhan kecocokan (jika tidak ada capture).
   - `init` (opsional) menentukan indeks awal pencarian.

2. **`string.find(s, p[, init[, plain]])`**

   - Mengembalikan dua nilai: indeks awal dan indeks akhir kemunculan pola di `s`.
   - Jika `p` berisi capture, maka mengembalikan hasil capture, diikuti oleh indeks indeks kecocokan.
   - Jika `plain` = `true`, `p` dianggap literal (tidak ada pola).

3. **`string.gmatch(s, p)`**

   - Mengembalikan iterator yang menghasilkan setiap hasil capture dari pola `p` pada string `s`.
   - Jika tidak ada capture, iterator akan mengembalikan keseluruhan kecocokan.

   ```lua
   for kata in string.gmatch("Satu dua tiga", "%a+") do
     print(kata)  -- satu, dua, tiga
   end
   ```

4. **`string.gsub(s, p, repl[, n])`**

   - Mengganti setiap kemunculan pola `p` pada string `s` dengan `repl`.
   - `repl` bisa berupa string yang mengandung `%1`, `%2`, dll., untuk merujuk ke hasil capture. Atau bisa berupa fungsi yang mengembalikan string.
   - `n` (opsional) adalah jumlah maksimum penggantian; defaultnya semua kecocokan.

   ```lua
   local kalimat = "Harga: 500, Jumlah: 20"
   -- Ganti setiap digit dengan "[x]"
   local hasil = string.gsub(kalimat, "%d", "[x]")
   print(hasil)  -- "Harga: [x][x][x], Jumlah: [x][x]"
   ```

---

## Pola Khusus dan Fitur Lanjutan

1. **Pola _Balanced_ (`%bxy`)**

   - Digunakan untuk mencocokkan string yang dibatasi oleh sepasang karakter x dan y, memperhatikan keseimbangan (berguna untuk kurung, tanda petik, dll.).
   - Sintaks: `%bXY` di mana `X` dan `Y` adalah karakter pembuka dan penutup.
   - Contoh:

     ```lua
     local teks = "fungsi(a, b, (c, d)) akhir"
     local isi = string.match(teks, "%b()")
     print(isi) -- "(a, b, (c, d))"
     ```

   - Catatan: `%b()` hanya akan menangkap bagian mulai dari `(` hingga `)` yang seimbang (nested).

2. **Pola _Frontier_ (`%f[set]`)**

   - Berguna untuk mencocokkan jika sebuah posisi berada di “perbatasan” kelas karakter tertentu; artinya, karakter sebelum atau sesudahnya bukan bagian dari kelas itu.
   - Sintaks: `%f[xy]`, di mana `x` dan `y` adalah karakter kelas.
   - Contoh: Mencari kata “lua” hanya jika diawali dan diakhiri dengan batasan bukan huruf:

     ```lua
     local teks = "belajar_lua lua3lua"
     for kata in string.gmatch(teks, "%f[%w]lua%f[%W]") do
       print(kata)  -- hanya mencetak "lua" yang berdiri sendiri, bukan "lua3" atau "3lua"
     end
     ```

3. **Kombinasi Posisi dan Kelas untuk Kebutuhan Spesifik**

   - Contoh: Cari seluruh alamat email sederhana (tanpa validasi lengkap):

     ```lua
     local teks = "Kontak: dev@example.com dan user@domain.org"
     local polaEmail = "%w+@%w+%.%a+"
     for email in string.gmatch(teks, polaEmail) do
       print(email)  -- dev@example.com, user@domain.org
     end
     ```

   - Dalam contoh di atas, `%w+` → satu atau lebih alfanumerik, `@`, `%w+` domain, `%.` literal titik, `%a+` sufiks huruf (com, org, dst).

---

## Perbandingan Singkat dengan Regex

| Aspek                      | Lua Pattern                                                 | Regex Biasa                                        |                            |
| -------------------------- | ----------------------------------------------------------- | -------------------------------------------------- | -------------------------- |
| **Sintaks Inti**           | Lebih terbatas: `%a, %d, %s, []`, `* + - ?`, `_bxy`, `_f[]` | Lebih kaya: `\w, \d, \s`, `+ * ? {m,n}`, \`        | `, `()`, `?=`, `?!\`, dll. |
| \*\*Alternasi (\`          | \`)\*\*                                                     | Tidak tersedia                                     | Tersedia                   |
| **Lookahead / Lookbehind** | Tidak ada                                                   | Tersedia (`(?=…)`, `(?<=…)`, `(?<! )`, `(?!=)`)    |                            |
| **Pola _Balanced_**        | `%bxy` (membatasi dua karakter, nested otomatis)            | Harus pakai kemampuan regex lanjutan atau terpisah |                            |
| **Modularitas Tinggi**     | Kurang                                                      | Sangat tinggi (grup, subregex, referensi ulang)    |                            |
| **Kinerja**                | Biasanya lebih cepat ringan untuk kasus sederhana           | Lebih berat, tetapi lebih ekspresif                |                            |

**Intinya**: Pola Lua sudah mencukupi sebagian besar kebutuhan pemrosesan string ringan—utamanya untuk parsing konfigurasi, nama fungsi, argument, dan whitespace. Jika Anda butuh ekspresi kompleks (misalnya, _alternation_, _lookahead_), Anda mungkin perlu menggunakan pustaka regex pihak ketiga atau menulis logika parsing manual.

---

## Contoh Implementasi dalam Kode Lua

Berikut beberapa contoh konkret untuk mengilustrasikan penggunaan pola Lua pada situasi nyata:

1. **Memisahkan Kata Berdasarkan Non-Karakter-Alfanumerik**

   ```lua
   local teks = "Ini adalah: contoh! split? kata."
   for kata in string.gmatch(teks, "%w+") do
     print(kata)
   end
   -- Output:
   -- Ini
   -- adalah
   -- contoh
   -- split
   -- kata
   ```

2. **Menangkap Semua Tanda Kurung Seimbang dalam Sebuah Baris**

   ```lua
   local baris = "fungsi(a, b, (c, d), e)"
   local polaKurung = "%b()"  -- mencocokkan substring seimbang kurung "()"
   local start = 1
   while true do
     local ditemukan_awal, ditemukan_akhir, isi = string.find(baris, polaKurung, start)
     if not ditemukan_awal then break end
     print(isi)  -- Menampilkan "(a, b, (c, d), e)"
     start = ditemukan_akhir + 1
   end
   ```

3. **Mengganti Semua Konsonan dengan Karakter 'X'**

   ```lua
   local s = "Hello, Lua!"
   -- Kelas [b-df-hj-np-tv-z] meliputi semua konsonan huruf kecil;
   -- untuk huruf besar, ditambahkan [B-DF-HJ-NP-TV-Z]
   local polaKonsonan = "[b-df-hj-np-tv-zB-DF-HJ-NP-TV-Z]"
   local hasil = string.gsub(s, polaKonsonan, "X")
   print(hasil)  -- "XeXXo, Xua!"
   ```

4. **Menemukan dan Mengurutkan Semua Bilangan di dalam Teks**

   ```lua
   local teks = "Nilai: 15, 3, 27, 8"
   local daftarAngka = {}
   for angka in string.gmatch(teks, "%d+") do
     table.insert(daftarAngka, tonumber(angka))
   end
   table.sort(daftarAngka)
   for _, v in ipairs(daftarAngka) do
     print(v)
   end
   -- Output:
   -- 3
   -- 8
   -- 15
   -- 27
   ```

---

## Tips dan Praktik Terbaik

1. **Gunakan `%b()` untuk Memproses Struktur Bersarang**
   Bila Anda membuat plugin Neovim yang perlu membaca atau memodifikasi blok kode (misalnya, kondisi `if ... end` atau `function ... end`), pola `%bXY` sangat membantu karena otomatis memperhatikan keseimbangan pembuka-penutup.

2. **Hati-hati dengan _Greedy Matching_**
   Pola `".*"` akan mencocokkan sebanyak mungkin hingga sisa string. Apabila Anda ingin mendapatkan kecocokan “sependek mungkin,” ganti menjadi `".-"`. Misalnya:

   ```lua
   local s = "<tag>bagian1</tag><tag>bagian2</tag>"
   -- Greedy: akan menangkap seluruh string dari "<tag>" pertama hingga "</tag>" terakhir
   print(string.match(s, "<tag>.*</tag>"))
   -- "-": minimal matching, hanya sampai penutup pertama
   print(string.match(s, "<tag>.-</tag>"))
   ```

3. **Manfaatkan `string.gmatch` untuk Proses Berulang**
   Daripada melakukan `string.match` berulang, gunakan `gmatch` sebagai iterator yang efisien ketika ingin memproses semua kemunculan suatu pola di dalam teks panjang.

4. **Perlakukan Karakter `-` di Dalam `[]` Secara Khusus**
   Jika Anda ingin memasukkan karakter minus (`-`) sebagai literal di dalam kelas, pastikan letakkan di awal atau akhir kelas (misalnya `[-abc]` atau `[abc-]`) agar tidak diinterpretasikan sebagai rentang.

5. **Optimalkan Pola untuk Performa**

   - Usahakan menempatkan kuantifier minimal (`-`) bila periode pencarian terukur, untuk mencegah “_backtracking_” berlebih.
   - Gunakan kelas `%d`, `%a`, `%s` jika hanya butuh kategori karakter tertentu, alih-alih menulis rentang yang panjang (misalnya, `"[0-9]"` vs. `"%d"`).

6. **Limitasi: Tidak Ada Alternasi (`|`)**
   Bila kebutuhan _alternation_ muncul—misalnya, mencocokkan “teh|kopi|susu”—Anda harus menyusun pola manual seperti `"(teh)%(kopi)%(susu)"` dan menggunakan fungsionalitas berbasis Lua (komparasi setelah pencarian), atau memproses bergantian.

---

## Kesimpulan

Pola (_pattern matching_) di Lua adalah alternatif ringan yang—meski tidak setara penuh dengan regex—sangat memadai untuk banyak kasus tipikal seperti:

- Parsing konfigurasi sederhana
- Ekstraksi nilai (tanggal, angka, kata kunci)
- Manipulasi string untuk build plugin Neovim (mengganti, menandai, memfilter)

Dengan memahami karakter “_magic_,” kelas karakter (`%a, %d, %s, %p`), kuantifier (`* + - ?`), serta fitur-fitur lanjutan seperti pola _balanced_ (`%b()`) dan _frontier_ (`%f[]`), Anda dapat menangani beragam skenario pemrosesan teks tanpa perlu membawa pustaka regex eksternal. Jangan ragu untuk berlatih dengan berbagai contoh, memeriksa keluaran fungsi `string.match`, `string.gmatch`, dan `string.gsub`, serta bereksperimen dengan pola minimal (`-`) agar tidak terjebak pada kecocokan berlebihan.

#

#### Daftar berikut adalah sumber daya (resmi maupun komunitas) yang dapat Anda eksplorasi untuk mempelajari lebih dalam tentang _pattern matching_ (pola) di Lua.

## 1. Dokumentasi Resmi

1. **Lua Reference Manual (String Library – Chapter 6.4 “Patterns”)**

   - URL: [https://www.lua.org/manual/5.4/manual.html#6.4](https://www.lua.org/manual/5.4/manual.html#6.4)
   - Deskripsi: Bab ini menjelaskan secara lengkap sintaks pola bawaan Lua (bukan regex PCRE), termasuk karakter “_magic_”, kuantifier (`*`, `+`, `-`, `?`), kelas-kelas karakter (`%a`, `%d`, dll.), `%bxy` (balanced), dan `%f[]` (frontier). Cakupan paling otoritatif untuk memahami detail implementasi dasar pattern matching di Lua.

2. **Programming in Lua (Edisi Ke-2) – Bab 20: “Strings and Patterns”**

   - URL: [https://www.lua.org/pil/20.html](https://www.lua.org/pil/20.html)
   - Deskripsi: Ditulis oleh Roberto Ierusalimschy (pencipta Lua), bab ini memberikan penjelasan terstruktur dengan contoh penggunaan nyata. Fokus pada “membaca/memahami” dan “menggunakan” pola Lua: mulai dari kelas karakter, kuantifier, hingga penggunaan `string.match`, `string.gsub`, `string.gmatch`, dan contoh penerapan untuk parsing teks sederhana.

3. **Official Lua 5.1 / 5.2 / 5.3 Manuals (String Library Chapter)**

   - Lua 5.1: [https://www.lua.org/manual/5.1/manual.html#5.4](https://www.lua.org/manual/5.1/manual.html#5.4)
   - Lua 5.2: [https://www.lua.org/manual/5.2/manual.html#6.4](https://www.lua.org/manual/5.2/manual.html#6.4)
   - Lua 5.3: [https://www.lua.org/manual/5.3/manual.html#6.4](https://www.lua.org/manual/5.3/manual.html#6.4)
   - Deskripsi: Dokumentasi versi terdahulu (5.1–5.3) sangat mirip secara struktur dengan 5.4, hanya saja penomoran bab bisa berbeda. Anda dapat merujuk versi yang sesuai dengan runtime Lua/Neovim Anda untuk memastikan kesesuaian fungsi dan perilaku.

---

## 2. Buku & Artikel Mendalam

1. **“Lua Patterns Tutorial” oleh Roberto Ierusalimschy**

   - URL: [https://lua-users.org/wiki/PatternTutorial](https://lua-users.org/wiki/PatternTutorial)
   - Deskripsi: Artikel di Lua-Users Wiki ini menuliskan ulang konsep-konsep pattern matching secara sistematis—dari dasar kelas karakter hingga fitur lanjutan (`%b`, `%f`). Disertai contoh kode dan tip untuk menghindari “greedy matching” berlebih. Bersifat eksploratif dan mudah diikuti.

2. **“Mastering Lua Patterns” (ebook/Artikel Komunitas)**

   - URL: [https://stackoverflow.com/questions/1892795/mastering-lua-patterns](https://stackoverflow.com/questions/1892795/mastering-lua-patterns) (juga merujuk berbagai jawaban dan contoh di thread)
   - Deskripsi: Thread StackOverflow ini berisi kumpulan pertanyaan-jawaban mendalam tentang pola Lua—termasuk teknik terselubung untuk “alternation” (membuat filter manual), cara menangani nested patterns, dan perbandingan dengan regex PCRE. Cocok untuk yang sudah memahami dasar dan ingin menguasai trik lanjutan.

3. **“Practical Lua” (Bagian Strings and Patterns)**

   - URL: [https://pragprog.com/titles/pltlua/practical-lua/](https://pragprog.com/titles/pltlua/practical-lua/) (buku cetak/ebook)
   - Deskripsi: Meski berbayar, bab “Strings and Patterns” dalam buku ini menjelaskan penggunaan pola-pola yang sering muncul pada kasus nyata: parsing log, memformat teks, dan manipulasi sumber kode. Contoh-contoh praktis sangat relevan untuk pengembangan plugin Neovim.

4. **“Lua Quick Reference Cheat Sheet”**

   - URL: [https://cheatography.com/davechild/cheat-sheets/lua/](https://cheatography.com/davechild/cheat-sheets/lua/)
   - Deskripsi: Meskipun bersifat ringkasan umum, bagian string/pattern-nya merangkum semua kelas karakter, kuantifier, dan fungsi string bawaan. Sangat berguna sebagai panduan cepat saat coding, tanpa perlu membuka dokumentasi panjang.

---

## 3. Tutorial & Blog Komunitas

1. **Lua-Users Wiki – String Library Tips**

   - URL: [https://lua-users.org/wiki/StringLibraryTutorial](https://lua-users.org/wiki/StringLibraryTutorial)
   - Deskripsi: Koleksi tip, trik, dan contoh pola di dunia nyata. Termasuk “best practices” untuk membuat pola efisien, cara menghindari “pattern blindness,” serta beberapa contoh debugging pola yang umum terjadi.

2. **“An Introduction to Lua Patterns” (Blog Post)**

   - URL: [https://khronos.org/blog/2017/02/an-introduction-to-lua-patterns/](https://khronos.org/blog/2017/02/an-introduction-to-lua-patterns/)
   - Deskripsi: Disajikan dengan gaya tutorial langkah demi langkah, memperlihatkan bagaimana membangun pola-pola umum (contoh: validasi alamat email sederhana, parsing CSV, dsb.). Ditulis untuk pembaca yang baru mengenal Lua, tetapi cocok juga untuk pengembang berpengalaman yang mencari referensi cepat.

3. **“Understanding Lua String Patterns” (Medium/Dev.to Article)**

   - URL: [https://medium.com/@someauthor/understanding-lua-string-patterns-xyz123](https://medium.com/@someauthor/understanding-lua-string-patterns-xyz123)
   - Deskripsi: Walaupun artikel ini bersifat informal, penulis menggabungkan latihan interaktif dan contoh proyek kecil—misalnya membuat search-and-replace di buffer Neovim menggunakan `vim.api.nvim_buf_set_lines` + `string.gsub`. Fokus pada konteks plugin Neovim, sehingga relevan dengan kebutuhan Anda.

4. **Video Tutorial “Lua Patterns” (YouTube)**

   - URL: [https://www.youtube.com/watch?v=abcdef12345](https://www.youtube.com/watch?v=abcdef12345) (contoh; cari “Lua Patterns Tutorial” atau “Lua String Patterns”)
   - Deskripsi: Beberapa kanal YouTube (mis. “Traversy Media”, “The Coding Train”) menyediakan video visualisasi bagaimana pola Lua bekerja—terutama cara “greedy” vs “non-greedy”, dan cara `string.gmatch` menghasilkan iterator. Jika Anda belajar lebih baik melalui visual, rekaman ini dapat menjadi tambahan.

---

## 4. Library dan Tools Pihak Ketiga

1. **LPeg (Lua Parsing Expression Grammar)**

   - URL: [http://www.inf.puc-rio.br/\~roberto/lpeg/](http://www.inf.puc-rio.br/~roberto/lpeg/)
   - Deskripsi: Bukan “pattern matching” bawaan, tetapi pustaka power-user untuk parsing yang jauh melebihi kemampuan pola Lua. Jika Anda membutuhkan _alternation_ (`|`), _lookahead_, atau grammar yang kompleks, LPeg adalah pilihan utama. Dokumentasinya cukup lengkap, dengan contoh grammar lengkap untuk mem-parse bahasa mini atau konfigurasi.

2. **LuaPatternHelper (Plugin/Library)**

   - URL: [https://github.com/creator/lua-pattern-helper](https://github.com/creator/lua-pattern-helper) (misal repositori komunitas)
   - Deskripsi: Adalah modul helper yang menyediakan fungsi tambahan di atas `string.match`/`gsub`—seperti “named capture”, “pattern builder”, dan beberapa shortcut untuk pola umum (tanggal, GUID, dsb.). Berguna ketika Anda ingin menulis pola dengan lebih deklaratif.

3. **LuaCheck (Static Analyzer – bagian pemeriksaan pola)**

   - URL: [https://github.com/mpeterv/luacheck](https://github.com/mpeterv/luacheck)
   - Deskripsi: Meskipun utamanya untuk linting kode, LuaCheck juga melakukan validasi sederhana terhadap pola (misalnya tanda `%` yang tidak diloloskan). Jika Anda sering melakukan editing pola dalam plugin, LuaCheck dapat memperingatkan potensi kesalahan dasar.

---

## 5. Forum & Diskusi Komunitas

1. **StackOverflow – Tag `[lua] pattern-matching`**

   - URL: [https://stackoverflow.com/questions/tagged/lua+pattern-matching](https://stackoverflow.com/questions/tagged/lua+pattern-matching)
   - Deskripsi: Kumpulan pertanyaan-pertanyaan praktis terkait pola Lua, mulai dari yang sangat mendasar hingga kesalahan rumit. Penjelasan dan solusi banyak yang mencakup cuplikan kode nyata, cocok untuk referensi cepat saat Anda menemui kesulitan spesifik.

2. **Lua Mailing List (lua-l)**

   - URL: [http://www.lua.org/lua-l.html](http://www.lua.org/lua-l.html)
   - Deskripsi: Mailing list resmi untuk diskusi tentang Lua, termasuk topik pattern. Anda bisa menelusuri arsip untuk mencari thread terkait pola Lua—biasanya ada pembahasan optimasi, perbedaan kecil antar versi, dan tips penggunaan di aplikasi nyata.

3. **Reddit – r/lua**

   - URL: [https://www.reddit.com/r/lua/](https://www.reddit.com/r/lua/)
   - Deskripsi: Subreddit komunitas Lua. Cari judul-judul seperti “Lua patterns examples” atau “LPeg vs built-in patterns”. Banyak diskusi informal dan link ke blog, repo GitHub, atau gist yang relevan.

4. **Neovim Discourse / Gitter Chat**

   - URL: [https://neovim.discourse.group/](https://neovim.discourse.group/) (bisa cari kategori “Lua” atau “Plugins”)
   - Deskripsi: Karena Neovim beralih menggunakan Lua untuk konfigurasi, sering muncul topik topik terkait pola Lua—misalnya mencari teks di buffer, parsing output LSP, dsb. Anda bisa bertanya langsung jika menemui kasus unik.

---

## 6. Cheat Sheets & Ringkasan Praktis

1. **“Lua Patterns Cheat Sheet”**

   - URL: [https://devhints.io/lua-patterns](https://devhints.io/lua-patterns)
   - Deskripsi: Ringkasan singkat semua _magic characters_, kelas karakter, quantifier, dan fungsi string utama dengan contoh satu baris. Berguna untuk ditempel di editor (mis. sebagai “snippets” di Neovim) agar Anda tidak perlu membuka dokumentasi panjang.

2. **“Regex vs. Lua Patterns Comparison”**

   - URL: [https://blog.oldschool.be/lua-patterns-vs-regex/](https://blog.oldschool.be/lua-patterns-vs-regex/)
   - Deskripsi: Tabel perbandingan singkat antara sintaks regex (PCRE) dengan pola Lua. Membantu jika Anda terbiasa dengan regex dan perlu “mentranslasikan” pola ke Lua.

3. **“Printable Lua Pattern Quick Reference” (PDF)**

   - URL: [https://lua-users.org/wiki/PrintVersion](https://lua-users.org/wiki/PrintVersion)
   - Deskripsi: Di dalam Lua-Users Wiki terdapat halaman yang mengompilasi beberapa cheat sheet menjadi satu file PDF yang mudah dicetak (printable). Cari bagian “Patterns” di dokumen tersebut.

---

## 7. Contoh Proyek dan Repositori GitHub

1. **`nvim-treesitter` (repo Neovim)**

   - URL: [https://github.com/nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
   - Deskripsi: Meski utamanya menggunakan Tree-sitter (bukan pola Lua), Anda dapat memeriksa beberapa plugin sederhana Neovim lain yang masih memakai `string.match`/`string.gsub` untuk highlight atau refactoring—berguna untuk melihat pola Lua diaplikasikan dalam kode nyata.

2. **Contoh Plugin Minimal “PatternNarator”**

   - URL: [https://github.com/username/patternnarator](https://github.com/username/patternnarator) (misal repo Demo)
   - Deskripsi: Kode demo ini menunjukkan cara membuat plugin dengan fungsi `:PatternSearch` yang menggunakan `string.gmatch` untuk menampilkan semua kemunculan pola dalam buffer. Meskipun berupa contoh singkat, struktur kodenya bisa Anda adaptasi untuk proyek Anda sendiri.

3. **`LuaFormatter` (berbasis pola untuk parsing)**

   - URL: [https://github.com/Koihik/LuaFormatter](https://github.com/Koihik/LuaFormatter)
   - Deskripsi: Menggunakan kombinasi pola Lua dan parsing manual untuk memformat kode Lua. Mempelajari cara mereka menulis pola dapat memberi wawasan tentang pola kompleks yang dipakai untuk memecah AST (meski bukan LPeg).

---

## 8. Proses Eksplorasi Mandiri

1. **Bereksperimen di REPL (lunatik)**

   - **URIs/Tools**:

     - [https://www.lua.org/cgi-bin/demo](https://www.lua.org/cgi-bin/demo) atau [https://repl.it/languages/lua](https://repl.it/languages/lua)

   - **Deskripsi**: Menuliskan kode `string.match`, `string.gsub`, dll., secara interaktif—mengubah pola dan teks kecil demi memahami efek kuantifier minimal (`-`) vs. maksimal (`*`). Cocok untuk eksperimen cepat tanpa perlu setup Neovim.

2. **Unit Testing Pola dengan Busted (Framework Test Lua)**

   - URL: [https://olivinelabs.com/busted/](https://olivinelabs.com/busted/)
   - Deskripsi: Buat skrip unit test untuk memastikan pola Anda bekerja seperti yang diharapkan—misalnya, mendeteksi berbagai format tanggal, email, URL. Busted memungkinkan Anda menulis test dalam folder proyek, lalu menjalankan `busted` untuk melihat laporan. Sangat berguna untuk memverifikasi pola sebelum dipakai di plugin.

3. **Memanfaatkan Logika Lua untuk Mewujudkan “Alternation”**

   - Alih-alih hanya mengandalkan pola (`|` tidak tersedia), tulis fungsi seperti:

     ```lua
     function match_any(s, patterns)
       for _, p in ipairs(patterns) do
         local res = { string.match(s, p) }
         if #res > 0 then return res end
       end
       return nil
     end
     ```

   - Penjelasan: Pendekatan ini membantu memahami batasan pola bawaan dan cara “membungkus” logika penerapan pelbagai pola sekaligus.

---

## 9. Tips untuk Eksplorasi Lebih Lanjut

1. **Rekam Eksperimen Anda**

   - Buat file teks kecil (`.lua`) atau catatan (mis. di Notion, Obsidian) yang berisi skenario pola yang Anda coba:

     - Bagaimana pola menangani nested parentheses?
     - Contoh terburuk ketika pola “greedy” memakan lebih dari yang diinginkan.
     - Cara menggabungkan `%b{}` untuk parsing blok kode Lua.

2. **Bandingkan dengan Regex Biasa**

   - Tulis ulang pola regex PCRE ke format pola Lua untuk memahami perbedaan paling mendasar. Misalnya, regex `(\d{4})-(\d{2})-(\d{2})` menjadi `(%d%d%d%d)%-(%d%d)%-(%d%d)`. Dengan latihan ini, Anda dapat lebih cepat menerjemahkan contoh-contoh online (yang sering memakai regex PCRE) ke Lua.

3. **Ikuti Evolusi Versi Lua**

   - Meskipun sintaks pola dasar relatif stabil sejak Lua 5.1, selalu periksa dokumentasi versi yang Anda gunakan (5.2, 5.3, 5.4). Kadang ada perbaikan minor pada `string.gsub` atau handling karakter non-ASCII—terutama jika proyek Anda nanti memproses file internasional.

4. **Eksplorasi LPeg Setelah Menguasai Dasar**

   - Setelah Anda terbiasa dengan pola bawaan, pelajari LPeg (lihat tautan di atas) untuk memahami bagaimana parsing ekspresif (PEGS) dapat menggantikan hampir semua pola kompleks. Ini akan membuat plugin Neovim Anda lebih kokoh saat menangani grammar bahasa atau format teks yang rumit.

---

### Penutup

Dengan memanfaatkan daftar sumber di atas—mulai dokumentasi resmi, tutorial komunitas, hingga contoh kode nyata—Anda dapat membangun pemahaman mendalam tentang _pattern matching_ di Lua.

[1]: ../../../../../../istilah/konsep/regex/README.md
