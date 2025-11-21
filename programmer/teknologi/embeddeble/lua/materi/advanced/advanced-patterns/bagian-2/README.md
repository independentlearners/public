Setelah membangun fondasi tentang _apa_ itu pattern, sekarang kita akan fokus pada cara _menggunakannya_ untuk mengekstrak data dan mengontrol posisi pencocokan dengan presisi. Ini adalah langkah krusial yang mengubah Anda dari sekadar "menemukan" string menjadi "mem-parsing" dan "memahami" struktur data di dalamnya.

---

### Daftar Isi (Bagian II)

- [**BAGIAN II: ADVANCED PATTERN MATCHING**](#bagian-ii-advanced-pattern-matching)
  - [2.1 Captures - Komprehensif](#21-captures---komprehensif)
  - [2.2 Anchoring, Positioning, dan Boundaries](#22-anchoring-positioning-dan-boundaries)
  - [2.3 Complex Pattern Construction](#23-complex-pattern-construction)
  - [2.4 Error Handling dan Robust Parsing](#24-error-handling-dan-robust-parsing)

---

## **[BAGIAN II: ADVANCED PATTERN MATCHING][0]**

Di bagian ini, kita akan mempelajari "otak" dari operasi pattern matching: bagaimana cara menangkap (capture) informasi yang kita inginkan dan memastikan pencocokan terjadi tepat di tempat yang kita harapkan.

### 2.1 Captures - Komprehensif

_Captures_ adalah mekanisme untuk mengekstrak bagian spesifik dari string yang cocok dengan sub-pattern. Ini adalah fitur yang paling sering digunakan dalam parsing.

- **Simple Captures dengan `()`**

  - **Konsep**: Bagian mana pun dari pattern yang Anda bungkus dengan sepasang tanda kurung `()` akan "ditangkap" (captured). Fungsi seperti `string.match` akan mengembalikan nilai-nilai yang ditangkap ini sebagai hasil utamanya.
  - **Sintaks**: `string.match(teks, "(pattern_yang_ditangkap)")`

  <!-- end list -->

  ```lua
  local text = "Nama: Budi, Umur: 25"

  -- Menangkap nama dan umur
  local nama, umur = string.match(text, "Nama: (%a+), Umur: (%d+)")

  print("Nama yang ditangkap:", nama)   -- Output: Nama yang ditangkap: Budi
  print("Umur yang ditangkap:", umur)     -- Output: Umur yang ditangkap: 25
  ```

- **Numbered Captures dan Backreferences (`%n`)**

  - **Konsep**: Anda dapat merujuk kembali ke capture sebelumnya _di dalam pattern yang sama_ menggunakan `%1`, `%2`, dst. `%1` merujuk pada capture pertama, `%2` pada yang kedua, dan seterusnya. Ini sangat berguna untuk menemukan kata yang berulang atau memastikan tag HTML cocok.
  - **Sintaks**: `(pattern_pertama).*%1`

  <!-- end list -->

  ```lua
  local text1 = "word word"
  local text2 = "word other"

  -- Mencari kata yang diulang
  print(string.match(text1, "(%a+) %1")) -- Output: word
  print(string.match(text2, "(%a+) %1")) -- Output: nil

  -- Memvalidasi tag
  local html = "<b>Bold Text</b>"
  local tag_name, content = string.match(html, "<(%a+)>.*</%1>")
  print("Tag:", tag_name, "Content:", content) -- Output: Tag: b       Content: Bold Text
  ```

- **Position Captures dan Empty Captures (`()`)**

  - **Konsep**: Ini adalah fitur yang sangat cerdas namun sering terlewatkan. Sebuah capture kosong `()` tidak menangkap teks, melainkan menangkap _posisi_ (indeks numerik) saat ini di dalam string. Ini sangat berguna untuk mengetahui di mana sebuah sub-pattern ditemukan atau untuk memecah string.
  - **Sintaks**: `string.match(teks, "prefix()suffix")`

  <!-- end list -->

  ```lua
  local text = "hello-world"

  -- Menangkap posisi dari tanda hubung '-'
  local pos = string.match(text, "hello()%pworld")
  print("Posisi tanda hubung:", pos) -- Output: Posisi tanda hubung: 6

  -- Menggunakan gmatch untuk memecah string berdasarkan separator
  -- '()' akan menangkap posisi setelah setiap karakter non-separator
  local parts = {}
  for pos in string.gmatch("a,b,c", "([^,]*),?()") do
      -- Kita tidak menggunakan hasil capture pertama ([^,]*)
      -- kita menggunakan capture kedua '()' yang berisi posisi
      table.insert(parts, string.sub("a,b,c", #table.concat(parts, ",")+2, pos-2))
  end
  -- Ini adalah contoh lanjutan, cara yang lebih mudah adalah dengan gsub.
  -- Namun ini menunjukkan kekuatan position capture.
  ```

  _Catatan_: Panduan yang Anda sertakan menyebut `Position captures dengan %()`. Ini kemungkinan adalah typo dalam panduan tersebut; sintaks standar untuk position capture adalah dengan menggunakan capture kosong `()`. Tidak ada pattern khusus `%()` di Lua standar.

- **Nested Captures dan Hierarchical Parsing**

  - **Konsep**: Anda bisa menumpuk (nest) captures di dalam captures lain. Hasilnya akan dikembalikan sesuai urutan tanda kurung pembuka `(`.
  - **Sintaks**: `((luar) (dalam))`

  <!-- end list -->

  ```lua
  local text = "data:2025-06-12"

  -- Menangkap tanggal utuh, dan juga tahun, bulan, hari secara terpisah
  local full_date, year, month, day = string.match(text, "data:((%d%d%d%d)-(%d%d)-(%d%d))")

  print("Tanggal Lengkap:", full_date) -- Output: Tanggal Lengkap: 2025-06-12
  print("Tahun:", year)              -- Output: Tahun: 2025
  print("Bulan:", month)             -- Output: Bulan: 06
  print("Hari:", day)                -- Output: Hari: 12
  ```

### 2.2 Anchoring, Positioning, dan Boundaries

_Anchors_ tidak mencocokkan karakter, melainkan posisi. Mereka memastikan pattern Anda cocok di lokasi yang tepat.

- **Start Anchor (`^`) dan End Anchor (`$`)**

  - **Konsep**: `^` mengikat pattern ke awal string, sementara `$` mengikatnya ke akhir string. Ini penting untuk validasi input, memastikan seluruh string cocok dengan pattern, bukan hanya sebagian.
  - **Sintaks**: `^pattern` (harus dimulai dengan), `pattern$` (harus diakhiri dengan), `^pattern$` (harus sama persis).

  <!-- end list -->

  ```lua
  local str1 = "hello world"
  local str2 = "world hello"

  print(string.match(str1, "^hello")) -- Output: hello
  print(string.match(str2, "^hello")) -- Output: nil

  print(string.match(str1, "world$")) -- Output: world
  print(string.match(str2, "world$")) -- Output: nil
  ```

- **Word Boundaries Simulation**

  - **Konsep**: Seperti yang dibahas di Bagian I, Lua tidak memiliki `\b` seperti Regex. Kita mensimulasikannya menggunakan _frontier pattern_ `%f[set]`. Ini memungkinkan kita mencocokkan kata "cat" tanpa secara tidak sengaja cocok dengan "caterpillar".
  - **Sintaks**: `%f[%w]katakita%f[%W]`

  <!-- end list -->

  ```lua
  local text = "caterpillar and cat"

  -- Salah: akan cocok dengan "cat" di "caterpillar"
  print(string.find(text, "cat")) -- Output: 1  3

  -- Benar: menggunakan frontier pattern untuk memastikan batasan kata
  print(string.find(text, "%f[%w]cat%f[%W]")) -- Output: 17 19
  ```

- **Line Boundaries dalam Multiline Text**

  - **Konsep**: Penting untuk diingat bahwa `^` dan `$` di Lua standar berlaku untuk **keseluruhan string**, bukan setiap baris terpisah dalam string multiline. Jika Anda perlu memproses teks baris per baris, pendekatan yang umum adalah memecah string menjadi tabel berisi baris-baris, atau menggunakan pattern yang secara eksplisit mencari karakter newline (`\n`).

  <!-- end list -->

  ```lua
  local multiline_text = "line one\nline two\nline three"

  -- Ini akan gagal karena `^` berlaku untuk awal seluruh string ("line one...")
  print(string.match(multiline_text, "^line two")) -- Output: nil

  -- Cara yang benar adalah dengan mengiterasi setiap baris
  for line in string.gmatch(multiline_text, "([^\n]+)") do
      if string.match(line, "^line two") then
          print("Found:", line) -- Output: Found: line two
      end
  end
  ```

### 2.3 Complex Pattern Construction

Menulis pattern yang besar dan rumit secara monolitik itu sulit dibaca dan dirawat. Praktik terbaiknya adalah membangunnya dari bagian-bagian yang lebih kecil.

- **Pattern Composition (Komposisi Pattern)**

  - **Konsep**: Karena pattern hanyalah string, Anda dapat membangunnya menggunakan operator konkatenasi (`..`). Ini membuat pattern lebih modular dan mudah dibaca.

  <!-- end list -->

  ```lua
  -- Mendefinisikan blok bangunan
  local number_pattern = "%d+"
  local word_pattern = "%a+"
  local separator = "%s*:%s*" -- spasi opsional, titik dua, spasi opsional

  -- Menggabungkannya menjadi pattern yang kompleks
  local full_pattern = "^" .. word_pattern .. separator .. number_pattern .. "$"

  print("Pattern yang dibangun:", full_pattern) -- Output: Pattern yang dibangun: ^%a+%s*:%s*%d+$
  print(string.match("Key : 123", full_pattern)) -- Output: Key : 123
  ```

- **Recursive Patterns dan Dynamic Building**

  - **Konsep**: Lua patterns standar **tidak mendukung rekursi secara langsung**. Ini adalah batasan desain yang penting. Anda tidak bisa membuat pattern yang merujuk pada dirinya sendiri untuk mem-parsing struktur data bersarang yang arbitrer (seperti JSON atau XML).
  - **Solusi/Simulasi**: Masalah ini biasanya dipecahkan dengan:
    1.  **Menggunakan `string.gsub` dengan fungsi callback**: Fungsi ini dapat memanggil `gsub` atau `match` lagi pada substring yang ditangkap, menciptakan efek rekursif.
    2.  **Membangun Pattern secara Dinamis**: Sebuah fungsi dapat menerima argumen (misalnya, tingkat kedalaman) dan secara dinamis membangun string pattern yang sesuai untuk tingkat kedalaman tersebut.
    3.  **Menggunakan LPeg**: Untuk parsing yang benar-benar rekursif dan kompleks, solusi terbaik di Lua adalah menggunakan library **LPeg** (akan dibahas di Bagian IV), yang dirancang khusus untuk ini.

### 2.4 Error Handling dan Robust Parsing

Parser yang baik tidak hanya berhasil pada input yang valid, tetapi juga menangani input yang tidak valid dengan anggun.

- **Graceful Pattern Failure Handling**

  - **Konsep**: Untungnya, fungsi-fungsi pattern di Lua sudah dirancang untuk ini. `string.match` dan `string.find` hanya akan mengembalikan `nil` jika tidak ada kecocokan, tanpa menimbulkan error. Ini membuat pengecekan kegagalan menjadi sangat mudah.

  <!-- end list -->

  ```lua
  local text = "data tidak valid"
  local nama, umur = string.match(text, "Nama: (%a+), Umur: (%d+)")

  if nama and umur then
    print("Parsing berhasil:", nama, umur)
  else
    print("Parsing gagal: Format input tidak sesuai.")
  end
  -- Output: Parsing gagal: Format input tidak sesuai.
  ```

- **Debugging Complex Patterns**

  - **Strategi**:
    1.  **Pecah dan Taklukkan**: Jika pattern `A..B..C` gagal, uji `A`, `B`, dan `C` secara terpisah.
    2.  **Gunakan `string.find`**: Terkadang `string.match` mengembalikan `nil` karena capture Anda salah, bukan karena pattern utamanya tidak ditemukan. Gunakan `string.find` untuk melihat apakah pattern Anda _ditemukan_ di string, bahkan jika capture-nya gagal.
    3.  **Sederhanakan**: Ganti bagian yang kompleks (misalnya, `%b()`) dengan yang lebih sederhana (`.+`) untuk melihat apakah bagian lain dari pattern sudah benar.

---

Anda sekarang telah melampaui dasar-dasar pencocokan dan memasuki dunia parsing. Dengan _captures_, Anda dapat mengekstrak data; dengan _anchors_ dan _boundaries_, Anda dapat memastikan data diekstrak dari lokasi yang benar. Pada bagian selanjutnya, kita akan fokus pada `string.gsub`, di mana kita akan menggunakan kekuatan pattern ini untuk melakukan transformasi dan substitusi string yang canggih.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

<!----------------------------------------------------->

[0]: ../README.md#bagian-ii-advanced-pattern-matching
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
