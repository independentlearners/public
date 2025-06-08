### Daftar Isi

- [**Pendahuluan: Memahami Kekuatan Pattern Matching di Lua**](#pendahuluan-memahami-kekuatan-pattern-matching-di-lua)
  - [Apa Itu Pattern Matching?](#apa-itu-pattern-matching)
  - [Terminologi Dasar yang Wajib Diketahui](#terminologi-dasar-yang-wajib-diketahui)
- [**Modul 1: Dasar-dasar Pattern Matching**](#modul-1-dasar-dasar-pattern-matching)
  - [1.1 Pengenalan Pattern Matching di Lua](#11-pengenalan-pattern-matching-di-lua)
  - [1.2 Arsitektur Pattern Engine](#12-arsitektur-pattern-engine)
  - [1.3 Sintaks Dasar Pattern](#13-sintaks-dasar-pattern)
- [**Modul 2: Magic Characters dan Escape Sequences**](#modul-2-magic-characters-dan-escape-sequences)
  - [2.1 Magic Characters Komprehensif](#21-magic-characters-komprehensif)
  - [2.2 Escape Sequences Lanjutan](#22-escape-sequences-lanjutan)
- [**Modul 3: Character Classes dan Sets**](#modul-3-character-classes-dan-sets)
  - [3.1 Character Classes Standar](#31-character-classes-standar)
  - [3.2 Custom Character Sets](#32-custom-character-sets)
  - [3.3 Character Class Optimization](#33-character-class-optimization)
- [**Modul 4: Quantifiers dan Modifiers**](#modul-4-quantifiers-dan-modifiers)
  - [4.1 Quantifiers Dasar](#41-quantifiers-dasar)
  - [4.2 Perbedaan Greedy vs Lazy Matching](#42-perbedaan-greedy-vs-lazy-matching)
  - [4.3 Keterbatasan Quantifiers](#43-keterbatasan-quantifiers)
- [**Modul 5: Anchors dan Positioning**](#modul-5-anchors-dan-positioning)
  - [5.1 Anchors Dasar](#51-anchors-dasar)
  - [5.2 Position Matching Strategies](#52-position-matching-strategies)
- [**Modul 6: Frontier Patterns (%f) - Fitur Lanjutan**](#modul-6-frontier-patterns-f---fitur-lanjutan)
  - [6.1 Pengenalan Frontier Patterns](#61-pengenalan-frontier-patterns)
  - [6.2 Implementasi Frontier Patterns](#62-implementasi-frontier-patterns)
  - [6.3 Frontier Pattern Use Cases](#63-frontier-pattern-use-cases)
- **Tidak semua modul di daftar isikan**

---

### Pendahuluan: Memahami Kekuatan Pattern Matching di Lua

Sebelum kita menyelam ke dalam modul pertama, mari kita siapkan fondasi pemahaman yang kokoh. Anda menyebutkan pernah belajar Dart dan OOP. Lupakan sejenak tentang _class_, _object_, dan _inheritance_. Lua memiliki pendekatan yang lebih sederhana dan seringkali lebih langsung, terutama dalam hal manipulasi teks.

#### Apa Itu Pattern Matching?

Bayangkan Anda memiliki sebuah buku yang sangat tebal dan Anda ingin menemukan semua kalimat yang menyebutkan "Pangeran Diponegoro" tetapi tidak diikuti oleh kata "ditangkap". Atau, Anda memiliki daftar nomor telepon dalam format yang berantakan dan ingin mengekstrak hanya nomor-nomor yang valid.

**Pattern Matching** adalah teknik untuk mencari, mencocokkan, dan memanipulasi potongan-potongan teks berdasarkan sebuah "pola" ( _pattern_ ) tertentu. Alih-alih mencari teks yang sama persis, Anda mendefinisikan _aturan_ atau _pola_ dari teks yang ingin Anda temukan.

Ini adalah salah satu alat paling kuat dalam pemrograman untuk tugas-tugas seperti:

- **Validasi Input:** Memastikan email, nomor telepon, atau kata sandi yang dimasukkan pengguna sesuai format.
- **Parsing Data:** Membaca file log, file konfigurasi, atau data dari web dan mengekstrak informasi spesifik darinya.
- **Transformasi Teks:** Mengubah format tanggal, mengganti nama variabel secara massal dalam kode, atau membersihkan data teks yang kotor.

#### Terminologi Dasar yang Wajib Diketahui

Sebelum kita melangkah lebih jauh, mari kita samakan pemahaman tentang beberapa istilah dasar:

- **String:** Dalam pemrograman, **string** adalah sekuens atau urutan karakter. Anggap saja ini sebagai teks biasa. Contoh: `"Halo dunia"`, `"user@example.com"`, atau `"12345"`. Di Lua, string diapit oleh tanda kutip ganda (`"`) atau tunggal (`'`).
- **Pattern (Pola):** Ini adalah sebuah _string_ khusus yang mendeskripsikan aturan pencarian. Pola ini bisa berisi karakter biasa (yang cocok dengan dirinya sendiri) dan "karakter ajaib" (_magic characters_) yang memiliki makna khusus. Contoh: `"%d%d%d"` adalah pola untuk mencari tiga digit angka secara berurutan.
- **Fungsi (Function):** Sebuah blok kode yang dapat diberi nama dan dipanggil untuk melakukan tugas tertentu. Di Lua, kita akan banyak menggunakan fungsi dari _library_ `string` seperti `string.find()`, `string.match()`, `string.gmatch()`, dan `string.gsub()`.
- **Literal Character (Karakter Literal):** Karakter biasa dalam sebuah pola yang cocok dengan dirinya sendiri. Dalam pola `"halo"`, `h`, `a`, `l`, dan `o` adalah karakter literal.
- **Magic Character (Karakter Ajaib):** Karakter yang memiliki makna khusus dalam sebuah pola, bukan untuk dicocokkan secara harfiah. Contohnya termasuk `.` (cocok dengan karakter apa pun), `%` (karakter _escape_), `*`, `+`, `?`, `^`, dan `$`.
- **Regular Expression (Regex):** Ini adalah "sepupu" dari _pattern matching_ Lua. Regex adalah sistem pencocokan pola yang sangat kuat dan menjadi standar di banyak bahasa pemrograman lain (seperti JavaScript, Python, Java). _Pattern_ Lua lebih sederhana, memiliki beberapa fitur unik (seperti _balanced delimiters_), dan sengaja dirancang agar lebih kecil dan lebih cepat dalam beberapa kasus, dengan mengorbankan beberapa fitur kompleks yang ada di Regex.

---

### Modul 1: Dasar-dasar Pattern Matching

Di modul ini, kita akan membangun fondasi paling dasar dari _pattern matching_ di Lua.

#### 1.1 Pengenalan Pattern Matching di Lua

**Konsep:**
Pattern matching di Lua adalah fitur bawaan yang terintegrasi ke dalam _string library_ standar. Tujuannya adalah menyediakan alat manipulasi teks yang kuat namun tetap ringan. Filosofi desain Lua sangat menekankan kesederhanaan dan ukuran yang kecil. Implementasi _pattern matching_ Lua hanya memakan kurang dari 500 baris kode C, sangat kontras dengan implementasi POSIX Regex yang bisa lebih dari 4000 baris. Ini berarti ada beberapa keterbatasan, tetapi juga beberapa keunggulan unik.

**Perbedaan Utama dengan Regular Expressions (Regex):**

- **Kesederhanaan:** Pola Lua lebih terbatas. Misalnya, tidak ada operator "atau" (`|`) seperti di Regex.
- **Kecepatan:** Karena implementasinya yang sederhana, untuk beberapa pola tertentu, Lua bisa lebih cepat.
- **Fitur Unik:** Lua memiliki fitur yang tidak umum di Regex, seperti _balanced pair matching_ (`%bxy`) yang sangat efisien untuk menemukan konten di antara kurung atau tag yang seimbang (misal: `( a (b) c )`).
- **Ukuran:** Implementasinya sangat kecil, sejalan dengan filosofi Lua sebagai bahasa skrip yang ringkas dan mudah disematkan (_embeddable_).

**Kegunaan:**
Sangat berguna untuk parsing log, validasi data sederhana, memformat ulang string, dan tugas-tugas lain di mana kekuatan penuh Regex tidak diperlukan.

**Sumber:** [Programming in Lua - Pattern-Matching Functions](https://www.lua.org/pil/20.1.html)

#### 1.2 Arsitektur Pattern Engine

**Konsep:**
Mesin _pattern matching_ Lua menggunakan pendekatan yang berbeda dari kebanyakan mesin Regex modern. Ia tidak mengkompilasi pola menjadi _bytecode_ yang kompleks. Sebaliknya, ia secara langsung menginterpretasikan string pola saat melakukan pencocokan. Ini biasanya diimplementasikan menggunakan pendekatan rekursif sederhana.

**Performa vs Regex:**

- **Keunggulan:** Untuk pola-pola sederhana dan pencocokan langsung, pendekatan Lua bisa lebih cepat karena tidak ada _overhead_ kompilasi.
- **Kelemahan:** Untuk pola yang sangat kompleks yang melibatkan banyak _backtracking_ (mencoba berbagai kemungkinan), mesin Regex yang dioptimalkan (seperti PCRE) seringkali jauh lebih unggul.

**Memory Footprint:**
Karena kesederhanaannya, jejak memori dari mesin _pattern_ Lua sangat kecil, membuatnya ideal untuk lingkungan dengan sumber daya terbatas, seperti pengembangan game atau perangkat tertanam (_embedded systems_).

**Sumber:** [GameDev Academy - Lua Pattern Matching Tutorial](https://gamedevacademy.org/lua-pattern-matching-tutorial-complete-guide/)

#### 1.3 Sintaks Dasar Pattern

**Konsep:**
Di Lua, sebuah _pattern_ hanyalah sebuah _string_. Anda tidak memerlukan sintaks khusus untuk membuatnya. Anda cukup menuliskannya di dalam tanda kutip. Fungsi-fungsi seperti `string.find()` akan menginterpretasikan string ini sebagai pola.

**Karakter Literal vs. Karakter Khusus:**

- **Karakter Literal:** Sebagian besar karakter akan cocok dengan dirinya sendiri. Pola `"hello"` akan mencari substring `"hello"`.
- **Karakter Khusus (Magic Characters):** Beberapa karakter memiliki arti khusus. Karakter-karakter ini adalah: `( ) . % + - * ? [ ] ^ $`. Kita akan membahasnya secara rinci di Modul 2.

**Contoh Kode Dasar:**
Mari kita gunakan `string.find()`, fungsi paling dasar untuk memulai. Fungsi ini mencari kemunculan pertama sebuah pola dalam sebuah string.

- **Sintaks:** `string.find(s, pattern, [init, [plain]])`
  - `s`: String sumber tempat kita mencari.
  - `pattern`: String pola yang ingin kita temukan.
  - `init` (opsional): Posisi awal pencarian (indeks dimulai dari 1).
  - `plain` (opsional): Jika `true`, maka `string.find` akan melakukan pencarian teks biasa tanpa menginterpretasikan _magic characters_.

<!-- end list -->

```lua
-- Persiapan: String yang akan kita gunakan
local teks = "Halo dunia, ini adalah hari yang cerah di tahun 2025."

-- Contoh 1: Mencari karakter literal sederhana
local startIndex, endIndex = string.find(teks, "dunia")

-- Memeriksa hasil
if startIndex then
  print("Pola 'dunia' ditemukan!")
  print("Dimulai dari indeks: " .. startIndex) -- Output: Dimulai dari indeks: 6
  print("Berakhir di indeks: " .. endIndex)   -- Output: Berakhir di indeks: 10

  -- Mengekstrak substring yang cocok
  print("Substring yang cocok: '" .. string.sub(teks, startIndex, endIndex) .. "'") -- Output: Substring yang cocok: 'dunia'
end

-- Contoh 2: Pola tidak ditemukan
local start, endp = string.find(teks, "selamat pagi")

if not start then
  print("Pola 'selamat pagi' tidak ditemukan.") -- Ini yang akan tercetak
end

-- Contoh 3: Menggunakan parameter 'init' untuk memulai pencarian dari posisi tertentu
-- Kita cari kata 'hari' setelah indeks ke-20
local startHari, endHari = string.find(teks, "hari", 20)
if startHari then
    print("Pola 'hari' ditemukan setelah indeks 20 pada posisi: " .. startHari) -- Output: Pola 'hari' ditemukan setelah indeks 20 pada posisi: 29
end
```

**Penjelasan Kode:**

- `local teks = ...`: Kita mendeklarasikan sebuah variabel lokal bernama `teks` yang berisi string target kita.
- `string.find(teks, "dunia")`: Kita memanggil fungsi `find` dari _library_ `string`. Fungsi ini mengembalikan dua nilai jika berhasil: indeks awal dan indeks akhir dari kecocokan. Jika tidak, ia mengembalikan `nil`.
- `if startIndex then ... end`: Ini adalah cara umum di Lua untuk memeriksa apakah pencarian berhasil. Jika `startIndex` bukan `nil`, maka blok `if` akan dieksekusi.
- `..`: Ini adalah operator untuk menggabungkan (konkatenasi) string di Lua.
- `string.sub(teks, startIndex, endIndex)`: Fungsi ini digunakan untuk mengambil sebagian dari string (_substring_) dari indeks awal hingga indeks akhir.

---

### Modul 2: Magic Characters dan Escape Sequences

Modul ini adalah jantung dari _pattern matching_. Memahami karakter-karakter ini adalah kunci untuk membangun pola yang kuat.

#### 2.1 Magic Characters Komprehensif

Ini adalah karakter-karakter yang memiliki makna khusus dan tidak cocok dengan dirinya sendiri secara harfiah.

- **. (Titik)**

  - **Fungsi:** Cocok dengan **satu karakter apa pun**.
  - **Contoh:** Pola `"h.i"` akan cocok dengan `"hai"`, `"hbi"`, `"h_i"`, `"h9i"`, tetapi tidak dengan `"hi"` atau `"haai"`.

  <!-- end list -->

  ```lua
  print(string.find("halo", "h.lo")) -- Output: 1  4 (cocok dengan 'a')
  print(string.find("h9lo", "h.lo")) -- Output: 1  4 (cocok dengan '9')
  ```

- **%**

  - **Fungsi:** Ini adalah karakter _escape_. Ia "menghilangkan" kekuatan sihir dari _magic character_ yang mengikutinya, atau memberikan kekuatan sihir pada karakter non-ajaib (membentuk _character class_).
  - **Konteks:** Digunakan untuk mencari _magic character_ secara harfiah. Misalnya, untuk mencari karakter titik (`.`), Anda harus menggunakan pola `"%."`.

  <!-- end list -->

  ```lua
  print(string.find("harga 5.000", "5.000"))  -- TIDAK AKAN BEKERJA SESUAI HARAPAN (karena '.' berarti 'karakter apa saja')
  -- Akan cocok dengan "5a000", "5b000", dll.

  print(string.find("harga 5.000", "5%.000")) -- Output: 7  12 (Ini cara yang benar)
  ```

- **() (Kurung)**

  - **Fungsi:** Membuat sebuah **capture group**. Bagian dari string yang cocok dengan pola di dalam kurung akan "ditangkap" (disimpan) untuk digunakan nanti, misalnya oleh `string.match` atau `string.gsub`.
  - **Konteks:** Sangat penting untuk mengekstrak data. Kita akan membahas ini secara mendalam di Modul 8.

  <!-- end list -->

  ```lua
  local s = "halo dari Lua"
  local cocok = string.match(s, "halo dari (%a+)")
  print(cocok) -- Output: Lua  (kata 'Lua' ditangkap oleh (%a+))
  ```

- **[ ] (Kurung Siku)**

  - **Fungsi:** Membuat sebuah **set karakter kustom**. Cocok dengan **satu karakter apa pun** yang ada di dalam kurung siku.
  - **Konteks:** Berguna saat Anda ingin mencocokkan salah satu dari beberapa karakter tertentu.
  - **Contoh:** `"[aeiou]"` akan cocok dengan satu huruf vokal kecil. `"[0123456789]"` akan cocok dengan satu digit angka.

  <!-- end list -->

  ```lua
  print(string.find("halo", "h[aiueo]lo")) -- Output: 1  4 (cocok karena 'a' ada di dalam set)
  print(string.find("helo", "h[aiueo]lo")) -- Output: nil (tidak cocok karena 'e' tidak ada di dalam set)
  ```

- **^ (di dalam `[]`)**

  - **Fungsi:** Jika `^` adalah karakter pertama di dalam `[]`, ia menegasikan set tersebut. Artinya, ia akan cocok dengan **satu karakter apa pun yang TIDAK ada** di dalam set.
  - **Contoh:** `"[^aeiou]"` akan cocok dengan satu karakter apa pun yang bukan huruf vokal kecil (misalnya, konsonan, angka, spasi).

  <!-- end list -->

  ```lua
  print(string.find("h_lo", "h[^aeiou]lo")) -- Output: 1  4 (cocok karena '_' bukan vokal)
  ```

- **^ (di awal pola)**

  - **Fungsi:** Sebuah **anchor**. Cocok dengan awal dari string.
  - **Konteks:** Berguna untuk memastikan pola hanya cocok jika berada di paling awal.

  <!-- end list -->

  ```lua
  print(string.find("halo dunia", "^halo")) -- Output: 1  4
  print(string.find("oh halo dunia", "^halo")) -- Output: nil
  ```

- **$**

  - **Fungsi:** Sebuah **anchor**. Cocok dengan akhir dari string.
  - **Konteks:** Memastikan pola hanya cocok jika berada di paling akhir.

  <!-- end list -->

  ```lua
  print(string.find("halo dunia", "dunia$")) -- Output: 6  10
  print(string.find("halo dunia ini", "dunia$")) -- Output: nil
  ```

- **+ - \* ? (Quantifiers)**

  - **Fungsi:** Menentukan _berapa kali_ item sebelumnya dalam pola boleh muncul.
  - `+`: Satu kali atau lebih.
  - `*`: Nol kali atau lebih.
  - `-`: Nol kali atau lebih (versi _lazy_ dari `*`, akan dibahas nanti).
  - `?`: Nol kali atau satu kali (opsional).
  - **Konteks:** Sangat penting untuk mencocokkan pola dengan panjang yang bervariasi. Akan dibahas lengkap di Modul 4.

**Sumber:** [Programming in Lua - Pattern Syntax](https://www.lua.org/pil/20.2.html)

#### 2.2 Escape Sequences Lanjutan

**Konsep:**
Karakter `%` adalah "kunci utama". Ia melakukan dua hal:

1.  **Menonaktifkan sihir:** `%` di depan _magic character_ (`.`, `(`, `)`, `+`, dll.) membuatnya diperlakukan sebagai karakter literal.
2.  **Mengaktifkan sihir:** `%` di depan huruf atau angka (yang biasanya literal) menciptakan _character class_ atau konstruksi khusus.

**Aturan Escape dalam Pattern:**

- Untuk mencocokkan salah satu dari `( ) . % + - * ? [ ] ^ $`, Anda harus mengawalinya dengan `%`.
- Untuk mencocokkan karakter `%` itu sendiri, Anda harus menulis `%%`.

**Contoh Kode:**

```lua
-- String target kita
local data = "Diskon 50% untuk item (A+B)!"

-- Mencari tanda kurung literal
local start, finish = string.find(data, "%(A%+B%)")
if start then
    print("Pola kurung ditemukan: " .. string.sub(data, start, finish)) -- Output: (A+B)
end

-- Mencari persen literal
local start_persen, finish_persen = string.find(data, "50%%")
if start_persen then
    print("Pola persen ditemukan: " .. string.sub(data, start_persen, finish_persen)) -- Output: 50%
end
```

**Penjelasan Kode:**

- `"%(A%+B%)"`:
  - `%(`: Mencari karakter `(` literal.
  - `A`: Mencari karakter `A` literal.
  - `%+`: Mencari karakter `+` literal. `+` adalah _magic character_ (quantifier), jadi kita butuh `%`.
  - `B`: Mencari karakter `B` literal.
  - `%)`: Mencari karakter `)` literal.
- `"50%%"`:
  - `50`: Mencari "50" literal.
  - `%%`: Mencari karakter `%` literal.

**Best Practices untuk Keamanan:**
Jika Anda membangun pola dari input pengguna, berhati-hatilah. Pengguna bisa saja memasukkan _magic character_ yang tidak Anda duga. Jika Anda ingin mencari string dari input pengguna secara harfiah, ada dua cara:

1.  **Gunakan parameter `plain` di `string.find`:**

    ```lua
    local userInput = "item (A+B)"
    -- Akan error jika tidak di-escape atau tanpa 'plain'
    -- local start, finish = string.find(data, userInput)

    -- Cara yang aman (mencari teks biasa)
    local start, finish = string.find(data, userInput, 1, true)
    if start then
        print("Input pengguna ditemukan secara literal!")
    end
    ```

2.  **Lakukan "escaping" pada input pengguna secara manual:** Anda bisa menggunakan `string.gsub` untuk mengganti semua _magic character_ di input pengguna dengan versi _escaped_-nya.

    ```lua
    local userInput = "item (A+B)!"
    -- Ganti setiap magic character 'c' dengan '%c'
    local escapedInput = string.gsub(userInput, "([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")

    print("Input yang sudah di-escape: " .. escapedInput)
    -- Output: item %(A%+B%)!

    -- Sekarang aman digunakan sebagai pola
    local start, finish = string.find(data, escapedInput)
    if start then
        print("Input pengguna ditemukan menggunakan pola yang di-escape!")
    end
    ```

---

### Modul 3: Character Classes dan Sets

Setelah memahami _magic characters_ dasar, sekarang kita akan belajar cara mencocokkan _jenis_ karakter, bukan hanya karakter spesifik.

#### 3.1 Character Classes Standar

Lua menyediakan "jalan pintas" berupa kode dua karakter yang diawali dengan `%` untuk mewakili kelompok-kelompok karakter yang umum. Ini membuat pola lebih ringkas dan mudah dibaca.

| Class    | Deskripsi                                  | Komplemen | Deskripsi Komplemen                        |
| :------- | :----------------------------------------- | :-------- | :----------------------------------------- |
| **`%a`** | Huruf (alphabetic)                         | **`%A`**  | Karakter apa pun selain huruf              |
| **`%d`** | Digit (angka 0-9)                          | **`%D`**  | Karakter apa pun selain digit              |
| **`%s`** | Karakter spasi (spasi, tab, newline, dll.) | **`%S`**  | Karakter apa pun selain spasi              |
| **`%w`** | Karakter alfanumerik (huruf dan angka)     | **`%W`**  | Karakter apa pun selain alfanumerik        |
| **`%l`** | Huruf kecil                                | **`%L`**  | Karakter apa pun selain huruf kecil        |
| **`%u`** | Huruf besar                                | **`%U`**  | Karakter apa pun selain huruf besar        |
| **`%c`** | Karakter kontrol                           | **`%C`**  | Karakter apa pun selain karakter kontrol   |
| **`%p`** | Karakter tanda baca (punctuation)          | **`%P`**  | Karakter apa pun selain tanda baca         |
| **`%x`** | Digit heksadesimal ([0-9a-fA-F])           | **`%X`**  | Karakter apa pun selain digit heksadesimal |
| **`%z`** | Karakter dengan representasi byte 0 (null) | **`%Z`**  | Karakter apa pun selain karakter null      |

**Contoh Kode:**

```lua
local teks = "User: John_Doe, ID: 1234, Aktif: true."

-- Mencari nama pengguna (kombinasi huruf, angka, dan '_')
-- %w+ berarti satu atau lebih karakter alfanumerik.
local user = string.match(teks, "User: (%w+)")
print("User ditemukan: " .. user) -- Output: John_Doe

-- Mencari ID (kombinasi angka)
-- %d+ berarti satu atau lebih digit.
local id = string.match(teks, "ID: (%d+)")
print("ID ditemukan: " .. id) -- Output: 1234

-- Mencari bagian yang bukan spasi, diikuti spasi, lalu diikuti bagian bukan spasi lagi
-- %S+ %S+
local bagian = string.match(teks, "(%S+%s%S+),")
print("Bagian ditemukan: '" .. bagian .. "'") -- Output: 'John_Doe, ID:'
```

#### 3.2 Custom Character Sets

Terkadang, _class_ standar tidak cukup spesifik. Anda mungkin ingin mencocokkan hanya huruf vokal, atau kombinasi huruf tertentu dan tanda baca. Di sinilah _custom sets_ menggunakan `[ ]` berperan.

- **Sintaks Dasar:** `[characters]`

  - `"[aeiou]"`: Cocok dengan satu `a`, `e`, `i`, `o`, atau `u`.

- **Range (Rentang):** `[start-end]`

  - `"[a-z]"`: Cocok dengan satu huruf kecil apa pun. Sama seperti `%l`.
  - `"[0-9]"`: Cocok dengan satu digit apa pun. Sama seperti `%d`.
  - `"[A-Fa-f0-9]"`: Cocok dengan satu digit heksadesimal. Sama seperti `%x`.

- **Kombinasi:** Anda bisa menggabungkan semuanya.

  - `"[a-zA-Z_]"`: Cocok dengan satu huruf (besar atau kecil) atau garis bawah.
  - `"[a-f0-9,;]"`: Cocok dengan satu digit heksadesimal rendah, koma, atau titik koma.

- **Negasi:** `[^characters]`

  - `"[^0-9]"`: Cocok dengan satu karakter apa pun yang bukan digit. Sama seperti `%D`.
  - `"[^ ]"`: Cocok dengan satu karakter apa pun yang bukan spasi.

**Contoh Kode:**

```lua
local kode_produk = "PROD-A3-XYZ"

-- Validasi format kode produk: 4 huruf besar, tanda hubung, 1 huruf A-E atau angka 1-5, tanda hubung, 3 huruf besar.
local format_valid = string.match(kode_produk, "^%u%u%u%u%-[A-E1-5]%-%u%u%u$")

if format_valid then
    print("Format kode produk '" .. kode_produk .. "' adalah valid.") -- Akan tercetak
end

local kode_produk_salah = "PROD-G7-XYZ"
local format_salah = string.match(kode_produk_salah, "^%u%u%u%u%-[A-E1-5]%-%u%u%u$")

if not format_salah then
    print("Format kode produk '" .. kode_produk_salah .. "' tidak valid.") -- Akan tercetak
end
```

**Penjelasan Pola:**

- `^...$`: Menggunakan _anchor_ untuk memastikan seluruh string cocok dengan pola, tidak hanya sebagian.
- `%u%u%u%u`: Empat huruf besar.
- `%-`: Tanda hubung literal.
- `[A-E1-5]`: Satu karakter yang merupakan `A`, `B`, `C`, `D`, `E`, `1`, `2`, `3`, `4`, atau `5`.
- `%u%u%u`: Tiga huruf besar.

#### 3.3 Character Class Optimization

**Konsep:**
Meskipun mesin _pattern_ Lua cepat, tidak semua pola diciptakan sama. Beberapa pola lebih efisien daripada yang lain.

- **Gunakan Class Bawaan:** Pola seperti `%d` biasanya sedikit lebih cepat daripada `[0-9]` karena implementasinya di C lebih langsung. Perbedaannya seringkali dapat diabaikan, tetapi untuk pemrosesan data bervolume sangat besar, ini bisa berarti.
- **Hindari Set Negasi yang Luas jika Memungkinkan:** Pola seperti `[^a]` harus memeriksa setiap karakter terhadap 'a'. Pola positif `[b-zB-Z0-9_...]` mungkin lebih spesifik, meskipun lebih panjang untuk ditulis.
- **Contoh:** Untuk memisahkan string berdasarkan koma, `string.gmatch(s, "[^,]+")` adalah pendekatan yang umum. Ini sangat efisien. Ini membaca semua karakter (`+`) yang bukan koma (`[^,]`).

<!-- end list -->

```lua
local csv_data = "apel,jeruk,mangga,durian"

print("Memisahkan data CSV:")
-- %w+ akan bekerja di sini, tapi [^,]+ lebih umum dan fleksibel
-- karena akan bekerja meskipun ada spasi atau karakter lain di dalam nilai.
for buah in string.gmatch(csv_data, "[^,]+") do
    print("- " .. buah)
end
```

**Output:**

```
Memisahkan data CSV:
- apel
- jeruk
- mangga
- durian
```

#

### Modul 4: Quantifiers dan Modifiers

Di modul sebelumnya, kita belajar mencocokkan _satu karakter_ dari sebuah _class_ atau _set_. Sekarang, kita akan belajar bagaimana cara mencocokkan _urutan_ karakter dengan panjang yang bervariasi. Inilah fungsi dari _quantifiers_.

#### 4.1 Quantifiers Dasar

**Konsep:**
_Quantifier_ adalah _magic character_ yang memodifikasi item tepat di sebelah kirinya (sebuah karakter literal, _class_, atau _set_) untuk menentukan berapa kali item tersebut harus muncul agar terjadi kecocokan.

- `+` **(Satu atau Lebih)**

  - **Fungsi:** Mencocokkan item sebelumnya **satu kali atau lebih**. Ini adalah versi "rakus" (_greedy_).
  - **Contoh:** Pola `"%d+"` akan cocok dengan `"1"`, `"12"`, `"123"`, dan seterusnya, tetapi tidak akan cocok dengan string kosong atau string tanpa angka.

- `*` **(Nol atau Lebih)**

  - **Fungsi:** Mencocokkan item sebelumnya **nol kali atau lebih**. Ini juga versi "rakus" (_greedy_).
  - **Contoh:** Pola `"%d*"` akan cocok dengan string kosong `""`, `"1"`, `"12"`, dan seterusnya.

- `?` **(Nol atau Satu)**

  - **Fungsi:** Mencocokkan item sebelumnya **nol kali atau satu kali**. Ini membuat item tersebut bersifat opsional.
  - **Contoh:** Pola `"https%?://"` akan cocok dengan `"http://"` dan `"https://"`.

- `-` **(Nol atau Lebih - _Lazy_)**

  - **Fungsi:** Versi "malas" (_lazy_ atau _non-greedy_) dari `*`. Ia akan mencocokkan item sebelumnya **nol kali atau lebih**, tetapi berusaha mencocokkan sesedikit mungkin karakter. Ini adalah salah satu _quantifier_ yang paling sering disalahpahami namun sangat kuat.
  - **Konteks:** Perbedaannya dengan `*` akan menjadi sangat jelas saat kita membahas _Greedy vs. Lazy Matching_ di bagian selanjutnya.

**Contoh Kode:**

```lua
local text1 = "File: report.txt, Ukuran: 45KB"
local text2 = "File: image.jpeg, Ukuran: 1MB"
local text3 = "File: data, Ukuran: 900B"

-- Menggunakan '+' untuk mengekstrak ekstensi file
-- %w+ : satu atau lebih karakter alfanumerik
-- %. : tanda titik literal
local ext1 = string.match(text1, "%.(%w+)")
print("Ekstensi file 1: " .. ext1) -- Output: txt

-- Menggunakan '?' untuk menangani kasus opsional
-- Misal, kita ingin mengekstrak nama file yang mungkin tidak punya ekstensi
local filename1 = string.match(text1, "File: (%w+%.?%w*)")
local filename3 = string.match(text3, "File: (%w+%.?%w*)")
print("Nama file 1: " .. filename1) -- Output: report.txt
print("Nama file 3: " .. filename3) -- Output: data

-- Penjelasan pola '(%w+%.?%w*)'
-- (%w+)     : Tangkap satu atau lebih karakter alfanumerik (misal: "report" atau "data")
-- %.?       : Tanda titik literal yang opsional (muncul nol atau satu kali)
-- %w* : Nol atau lebih karakter alfanumerik (ekstensinya)
```

**Sumber:** [GitHub Guide - Lua Pattern Matching](https://gist.github.com/spr2-dev/46ca9f4a6f933fa266bccd87fd15d09a)

#### 4.2 Perbedaan Greedy vs Lazy Matching

Ini adalah salah satu konsep terpenting dalam _pattern matching_. Memahaminya akan menyelamatkan Anda dari banyak kebingungan.

**Konsep:**

- **Greedy (Rakus):** Quantifier `*` dan `+` bersifat _greedy_. Artinya, mereka akan berusaha mencocokkan **sebanyak mungkin karakter** pada string sumber, selama sisa pola masih bisa dipenuhi. Mereka "memakan" semua yang mereka bisa, lalu "memuntahkannya" kembali satu per satu jika diperlukan agar sisa pola cocok.
- **Lazy (Malas):** Quantifier `-` bersifat _lazy_. Artinya, ia akan berusaha mencocokkan **sesedikit mungkin karakter** (bahkan nol karakter). Ia hanya akan "memakan" lebih banyak karakter jika sisa pola tidak dapat dicocokkan dengan kecocokan minimal.

**Visualisasi:**
Bayangkan kita punya string `teks = "<html><h1>Judul</h1></html>"` dan ingin mengekstrak konten di antara tag HTML pertama dan terakhir.

- **Kasus Greedy dengan Pola `"<.*>"`:**

  1.  `"<"` cocok dengan `<` pertama.
  2.  `.*` adalah _greedy_. Ia akan "memakan" semua karakter hingga akhir string: `html><h1>Judul</h1></html>`.
  3.  Sekarang giliran `">"` di pola untuk mencocokkan. Tapi string sudah habis.
  4.  Mesin _pattern_ melakukan _backtrack_. `.*` "memuntahkan" karakter terakhir (`>`) dan memberikannya pada `">"`. Cocok\!
  5.  Hasilnya: `<html><h1>Judul</h1></html>`. Ini bukan yang kita inginkan.

  <!-- end list -->

  ```
  Pola:  <      .* >
         |      |       |
  Teks:  <html><h1>Judul</h1></html>
         └─────┴───────┴─> Kecocokan Greedy
  ```

- **Kasus Lazy dengan Pola `"<.->"`:**

  1.  `"<"` cocok dengan `<` pertama.
  2.  `.-` adalah _lazy_. Ia mulai dengan mencocokkan nol karakter.
  3.  Sekarang giliran `">"` di pola untuk mencocokkan. Karakter berikutnya di teks adalah `h`. Tidak cocok.
  4.  Mesin _pattern_ melakukan _backtrack_. `.-` "memakan" satu karakter: `h`. Karakter berikutnya di teks adalah `t`. Masih tidak cocok dengan `>`.
  5.  Proses ini berlanjut. `.-` memakan `h`, `t`, `m`, `l`. Karakter berikutnya di teks adalah `>`. Cocok\!
  6.  Hasilnya: `<html>`. Ini adalah hasil yang benar untuk tag pertama.

  <!-- end list -->

  ```
  Pola:  <      .-      >
         |      |       |
  Teks:  <html><h1>Judul</h1></html>
         └─┴──┘
           Kecocokan Lazy
  ```

**Contoh Kode Perbandingan:**

```lua
local teks = "data = { kunci = 'nilai', lain = 'oke' }"

-- Tujuan: mengekstrak semua yang ada di dalam kurung kurawal {}

-- 1. Menggunakan '*' (Greedy)
local greedy_match = string.match(teks, "{(.*)}")
print("Greedy Match (*): '" .. greedy_match .. "'")
-- Output: " data = { kunci = 'nilai', lain = 'oke' } "
-- Penjelasan: `.*` memakan segalanya dari '{' pertama hingga '}' terakhir dalam string.

-- 2. Menggunakan '-' (Lazy)
-- Anggap kita punya string yang lebih rumit
local teks_rumit = "ambil {ini} bukan {itu}"
local lazy_match = string.match(teks_rumit, "{(.-)}")
print("Lazy Match (-): '" .. lazy_match .. "'")
-- Output: "ini"
-- Penjelasan: `.-` memakan karakter sesedikit mungkin sampai menemukan '}' pertama.

-- Kasus klasik: mengekstrak tag
local html = "Ini adalah <b>teks tebal</b> dan <i>teks miring</i>."
local greedy_tag = string.match(html, "<(.*)>")
local lazy_tag = string.match(html, "<(.-)>")
print("Tag Greedy: '<" .. greedy_tag .. ">'") -- Output: <b>teks tebal</b> dan <i>teks miring</i>
print("Tag Lazy: '<" .. lazy_tag .. ">'")   -- Output: <b>
```

**Implikasi Performa:**
Tidak ada aturan "satu lebih cepat dari yang lain". _Greedy matching_ bisa jadi lebih cepat jika kecocokan yang diinginkan memang panjang. _Lazy matching_ bisa lebih cepat jika kecocokan yang diinginkan pendek dan berada di awal. Kuncinya adalah memilih _quantifier_ yang tepat sesuai dengan apa yang ingin Anda capai untuk menghindari hasil yang salah dan _backtracking_ yang tidak perlu.

**Sumber:** [Stack Overflow - Lua vs Regex](https://stackoverflow.com/questions/2693334/lua-pattern-matching-vs-regular-expressions)

#### 4.3 Keterbatasan Quantifiers

Ini adalah salah satu perbedaan paling signifikan antara _pattern_ Lua dan Regex.

**Keterbatasan Utama:**
Di Lua, _quantifiers_ (`+`, `*`, `?`, `-`) **hanya bisa diterapkan pada item tunggal**:

- Sebuah karakter literal (contoh: `a+`)
- Sebuah _character class_ (contoh: `%d+`)
- Sebuah _character set_ (contoh: `[a-z]+`)

Mereka **TIDAK BISA** diterapkan pada _capture group_ (`()`).

**Contoh yang TIDAK VALID di Lua:**

```lua
-- Di Regex, Anda bisa melakukan ini untuk mencari "ha" yang berulang
-- (ha)+ akan cocok dengan "ha", "haha", "hahaha", dst.

-- KODE INI AKAN MENIMBULKAN ERROR DI LUA!
-- local teks = "hahaha"
-- local cocok = string.match(teks, "(ha)+") -- MALFORMED PATTERN (quantifier follows a capture)
```

**Workaround (Solusi Alternatif):**
Jadi, bagaimana cara kita mencapai hasil yang sama? Ada beberapa strategi, dari yang sederhana hingga yang canggih.

1.  **Pengulangan Manual (Untuk Jumlah Tetap):**
    Jika Anda tahu persis berapa kali pengulangan yang diinginkan, Anda cukup menulisnya berulang kali. Ini tidak fleksibel.

    ```lua
    -- Mencari "ha" yang diulang tepat 3 kali
    local teks = "hahaha"
    local cocok = string.match(teks, "(ha)(ha)(ha)")
    -- `string.match` akan mengembalikan capture untuk setiap grup
    -- Untuk mendapatkan string penuh, kita butuh capture di sekelilingnya
    local cocok_penuh = string.match(teks, "((ha)(ha)(ha))")
    print(cocok_penuh) -- Output: hahaha
    ```

2.  **Menggunakan Frontier Pattern (Canggih):**
    Untuk kasus tertentu seperti mencari kata berulang, kita bisa menggunakan `%f`. Ini akan kita bahas di Modul 6.

3.  **Menggunakan `string.gsub` dengan Fungsi (Sangat Kuat):**
    Ini adalah teknik yang paling fleksibel. Kita bisa menggunakan `string.gsub` untuk mencari pola dasar secara berulang, dan menggunakan fungsi untuk memproses setiap kecocokan.

    ```lua
    -- Tujuan: Menemukan semua pasangan kunci=nilai yang dipisahkan oleh ';'
    local data = "nama=John;umur=30;kota=Jakarta"
    local hasil = {} -- Kita akan simpan hasilnya di tabel

    -- Pola: (%w+) artinya 'tangkap nama kunci'
    -- =      artinya '=' literal
    -- ([^;]+) artinya 'tangkap nilai (semua karakter selain ;)'
    -- ;?     artinya ';' opsional di akhir
    string.gsub(data, "(%w+)=([^;]+);?", function(kunci, nilai)
      print("Menemukan -> Kunci: " .. kunci .. ", Nilai: " .. nilai)
      hasil[kunci] = nilai
    end)

    -- Sekarang tabel 'hasil' berisi data yang sudah diparsing
    print("Hasil di tabel, umur: " .. hasil.umur) -- Output: 30
    ```

4.  **Menggunakan Library Eksternal (Untuk Parsing Serius):**
    Ketika pola menjadi sangat kompleks dan membutuhkan pengulangan grup, itu pertanda bahwa Anda mungkin memerlukan alat yang lebih kuat. **LPEG (Lua Parsing Expression Grammars)** adalah library yang sangat populer dan kuat untuk tugas-tugas parsing di Lua. Ia dirancang untuk menangani struktur rekursif dan kompleks yang sulit atau tidak mungkin dilakukan dengan _pattern_ standar.

    - **Referensi:** [LPEG - Lua Parsing Expression Grammar](http://www.inf.puc-rio.br/~roberto/lpeg/)

**Sumber:** [Programming in Lua - Pattern Syntax](https://www.lua.org/pil/20.2.html)

---

### Modul 5: Anchors dan Positioning

_Anchors_ tidak mencocokkan karakter apa pun. Sebaliknya, mereka mencocokkan posisi: awal string, akhir string, atau batas-batas lainnya.

#### 5.1 Anchors Dasar

**Konsep:**
Kita sudah sedikit menyinggung ini, tapi mari kita perdalam. _Anchors_ memaksa pola Anda untuk hanya cocok di lokasi tertentu.

- `^` **(Start of String Anchor)**

  - **Fungsi:** Memastikan kecocokan hanya terjadi jika pola berada di **paling awal** dari string (atau subjek) yang dicari.
  - **Contoh:** `^%d+` hanya akan cocok jika sebuah string _dimulai_ dengan satu atau lebih digit.

- `$` **(End of String Anchor)**

  - **Fungsi:** Memastikan kecocokan hanya terjadi jika pola berada di **paling akhir** dari string.
  - **Penting:** Implementasi _anchor_ `$` di Lua hanya bekerja jika ia benar-benar karakter terakhir dari string pola. Pola seperti `"dunia$."` tidak akan bekerja sesuai harapan.

**Contoh Kode:**

```lua
local function cek_format(pola, str)
    if string.find(str, pola) then
        print("'" .. str .. "' COCOK dengan pola '" .. pola .. "'")
    else
        print("'" .. str .. "' TIDAK COCOK dengan pola '" .. pola .. "'")
    end
end

-- Pola 1: Dimulai dengan 'ID:'
local pola_awal = "^ID:"
cek_format(pola_awal, "ID:12345")     -- COCOK
cek_format(pola_awal, " User, ID:12345") -- TIDAK COCOK

-- Pola 2: Diakhiri dengan '.log'
local pola_akhir = "%.log$"
cek_format(pola_akhir, "error_2025.log")  -- COCOK
cek_format(pola_akhir, "error_2025.log.txt") -- TIDAK COCOK

-- Pola 3: Kombinasi anchor untuk mencocokkan seluruh string (validasi ketat)
-- Pola ini untuk memvalidasi username yang hanya boleh berisi huruf kecil dan angka,
-- panjang 4 sampai 8 karakter.
local pola_validasi = "^[a-z0-9][a-z0-9][a-z0-9][a-z0-9][a-z0-9]?[a-z0-9]?[a-z0-9]?[a-z0-9]?$"
-- Karena tidak ada quantifier grup, kita harus mengulanginya manual.

cek_format(pola_validasi, "user123") -- COCOK
cek_format(pola_validasi, "usr")      -- TIDAK COCOK (terlalu pendek)
cek_format(pola_validasi, "user_123") -- TIDAK COCOK (mengandung '_')
cek_format(pola_validasi, "user123 ") -- TIDAK COCOK (ada spasi di akhir)
```

#### 5.2 Position Matching Strategies

Dengan _anchors_, kita bisa menerapkan strategi pencocokan yang berbeda.

- **Whole String Matching (Mencocokkan Seluruh String):**
  Ini adalah penggunaan paling umum untuk validasi data. Dengan membungkus pola Anda dengan `^` dan `$`, Anda memaksa seluruh string untuk sesuai dengan pola tersebut, dari awal hingga akhir.

  - **Contoh:** Memvalidasi format Hex Color `#RRGGBB`.

    ```lua
    local pola_hex = "^#(%x%x%x%x%x%x)$"
    local warna1 = "#FF5733"
    local warna2 = "#ff5733" -- huruf kecil juga valid untuk hex
    local warna3 = "A#FF5733"

    print(string.match(warna1, pola_hex)) -- Output: FF5733
    print(string.match(warna2, pola_hex)) -- Output: ff5733
    print(string.match(warna3, pola_hex)) -- Output: nil
    ```

- **Partial Matching (Mencocokkan Sebagian):**
  Ini adalah perilaku default jika Anda tidak menggunakan _anchors_. Pola akan dicari di mana saja di dalam string. Ini berguna untuk ekstraksi data.

  - **Contoh:** Mengekstrak semua angka dari sebuah kalimat.
    ```lua
    local kalimat = "Ada 3 apel dan 15 jeruk, total 18 buah."
    print("Angka yang ditemukan:")
    for angka in string.gmatch(kalimat, "%d+") do
        print("- " .. angka)
    end
    -- Output: 3, 15, 18
    ```

- **Multi-line Considerations:**
  `^` dan `$` di Lua bekerja pada keseluruhan string subjek, bukan per baris. Jika Anda memiliki string yang berisi beberapa baris (dengan karakter `\n`), `^` hanya akan cocok di awal dari keseluruhan string, dan `$` hanya di akhir. Ini berbeda dengan beberapa mode di Regex yang memiliki _flag_ "multiline". Untuk memproses per baris di Lua, pendekatan yang paling umum adalah memisahkan string menjadi beberapa baris terlebih dahulu, lalu menerapkan pola pada setiap baris.

  ```lua
  local data_log = [[
  INFO: Aplikasi dimulai.
  WARN: Koneksi lambat.
  ERROR: Gagal memuat modul.
  ]]

  print("\nMemproses log baris per baris:")
  -- Pertama, pisahkan string menjadi baris-baris
  for baris in string.gmatch(data_log, "[^\n]+") do
      -- Sekarang kita bisa menggunakan ^ untuk mencari awal setiap 'baris'
      local level_error = string.match(baris, "^ERROR:")
      if level_error then
          print("Baris error ditemukan: " .. baris)
      end
  end
  -- Output: Baris error ditemukan: ERROR: Gagal memuat modul.
  ```

---

### Modul 6: Frontier Patterns (%f) - Fitur Lanjutan

Modul ini membahas `%f`, sebuah fitur yang tidak dimiliki oleh kebanyakan sistem Regex dan seringkali menjadi solusi elegan untuk masalah-masalah yang rumit, seperti pencarian "kata utuh" (_whole word searching_).

#### 6.1 Pengenalan Frontier Patterns

**Konsep:**
Bayangkan Anda berjalan di sepanjang sebuah string, karakter demi karakter. Sebuah **frontier** (perbatasan) bukanlah sebuah karakter, melainkan **posisi transisi** di antara dua karakter. _Frontier pattern_ `%f` adalah sebuah _assertion_ (pernyataan) yang bernilai benar jika posisi saat ini merupakan perbatasan antara karakter yang tidak ada dalam sebuah _set_ dan karakter yang ada di dalam _set_ tersebut.

- **Definisi Teknis:** Pola `%f[set]` cocok pada posisi kosong (tanpa memakan karakter) di mana karakter sebelumnya tidak termasuk dalam `set`, dan karakter berikutnya termasuk dalam `set`.
- **Analogi:** Anggap `set` adalah sebuah "negara". `%f[set]` adalah pos pemeriksaan perbatasan yang Anda lewati saat memasuki negara tersebut dari luar. Ia tidak cocok dengan wilayah di luar atau di dalam, tetapi tepat di titik transisinya.

**Sejarah dan Evolusi:**
Fitur ini adalah salah satu pembeda utama Lua dari sistem lain. Sementara Regex menggunakan `\b` untuk _word boundary_ (batas kata), `%f` di Lua jauh lebih fleksibel karena `set` perbatasannya bisa Anda definisikan sendiri. Anda bisa membuat perbatasan antara angka dan huruf, antara spasi dan non-spasi, dan kombinasi lainnya.

**Sumber:** [Lua-users Wiki - Frontier Pattern](http://lua-users.org/wiki/FrontierPattern)

#### 6.2 Implementasi Frontier Patterns

**Sintaks:**
Sintaksnya sederhana: `%f[set]`

- `%f`: Menandakan ini adalah _frontier pattern_.
- `[set]`: _Character set_ yang mendefinisikan "wilayah tujuan". `set` ini mengikuti semua aturan yang telah kita pelajari di Modul 3, termasuk `[a-z]`, `[^%s]`, dan penggunaan _character class_ seperti `%w`, `%d`, dll.

**Contoh Implementasi Dasar:**

- `%f[%w]`: Cocok pada posisi di mana karakter sebelumnya bukan alfanumerik (`%W`) dan karakter sesudahnya adalah alfanumerik (`%w`). Ini adalah transisi **memasuki** sebuah kata.
- `%f[%W]`: Cocok pada posisi di mana karakter sebelumnya adalah alfanumerik (`%w`) dan karakter sesudahnya bukan alfanumerik (`%W`). Ini adalah transisi **meninggalkan** sebuah kata.
- `%f[%d]`: Cocok pada transisi dari non-digit ke digit.
- `%f[a]`: Cocok pada transisi dari karakter apa pun selain 'a' ke karakter 'a'.

**Contoh Kode Word Boundary (Batas Kata):**
Mari kita lihat bagaimana `%f` bekerja dalam praktiknya.

```lua
local teks = "pro-cat-123"

-- Mencari transisi ke karakter alfanumerik (%w)
print("Mencari %f[%w]:")
for i in string.gmatch(teks, "()%f[%w]") do
  print("  Frontier ditemukan pada indeks: " .. i)
end
-- Output:
--   Frontier ditemukan pada indeks: 1 (awal string dianggap non-word)
--   Frontier ditemukan pada indeks: 5 (transisi dari '-' ke 'c')
--   Frontier ditemukan pada indeks: 9 (transisi dari '-' ke '1')

-- Mencari transisi ke karakter non-alfanumerik (%W)
print("\nMencari %f[%W]:")
for i in string.gmatch(teks, "()%f[%W]") do
  print("  Frontier ditemukan pada indeks: " .. i)
end
-- Output:
--   Frontier ditemukan pada indeks: 4 (transisi dari 'o' ke '-')
--   Frontier ditemukan pada indeks: 8 (transisi dari 't' ke '-')
--   Frontier ditemukan pada indeks: 12 (akhir string dianggap non-word)
```

**Penjelasan Kode:**

- `string.gmatch(teks, "()%f[%w]")`:
  - `()%f[%w]`: Ini adalah trik umum di Lua. `()` adalah _empty capture_ (tangkapan kosong). `gmatch` akan mengembalikan posisi dari tangkapan ini. Karena tangkapan ini berada tepat sebelum `%f`, kita mendapatkan indeks di mana _frontier_ itu cocok.
  - `%f` sendiri tidak mengonsumsi karakter apa pun, jadi kita perlu sesuatu untuk "dilihat", dan _empty capture_ sangat cocok untuk ini.

**Sumber:** [Stack Overflow - Lua vs Regex](https://stackoverflow.com/questions/2693334/lua-pattern-matching-vs-regular-expressions)

#### 6.3 Frontier Pattern Use Cases

**1. Whole Word Searching (Pencarian Kata Utuh)**
Ini adalah penggunaan `%f` yang paling klasik dan berguna. Bagaimana cara mencari kata `"cat"` tanpa cocok dengan `"caterpillar"` atau `"tomcat"`?

Caranya adalah dengan memastikan kata yang dicari diawali oleh perbatasan "masuk kata" (`%f[%w]`) dan diakhiri oleh perbatasan "keluar kata" (`%f[%W]`).

```lua
function searchWholeWord(word, text)
    -- Escape magic characters dalam kata yang dicari untuk keamanan
    local escapedWord = string.gsub(word, "([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")

    -- Buat pola frontier
    -- %f[%w] : Harus dimulai di perbatasan kata
    -- ..escapedWord.. : Kata yang kita cari
    -- %f[%W] : Harus diakhiri di perbatasan kata
    local pattern = "%f[%w]" .. escapedWord .. "%f[%W]"

    local found = string.find(text, pattern)
    if found then
        print("Ditemukan kata utuh '" .. word .. "' dalam teks.")
    else
        print("Tidak ditemukan kata utuh '" .. word .. "' dalam teks.")
    end
end

local kalimat = "The cat scattered the food. This is a catastrophe."

searchWholeWord("cat", kalimat)       -- Ditemukan
searchWholeWord("scattered", kalimat) -- Ditemukan
searchWholeWord("catastrophe", kalimat) -- Ditemukan
searchWholeWord("catas", kalimat)     -- Tidak Ditemukan

-- Kasus khusus: jika kata yang dicari adalah "cat"
-- Pola akan menjadi: %f[%w]cat%f[%W]
-- 1. Teks: "The cat scattered..."
--           ^
--           Posisi ini adalah %f[%w] (awal string -> 'c'). 'cat' cocok. Berikutnya ' '. Posisi antara 't' dan ' ' adalah %f[%W]. Sukses.
-- 2. Teks: "...a catastrophe."
--             ^
--             Posisi ini adalah %f[%w] (' ' -> 'c'). 'cat' cocok. Berikutnya 'a'. Posisi antara 't' dan 'a' BUKAN %f[%W]. Gagal.
```

**2. Context-Sensitive Matching (Pencocokan Sensitif Konteks)**
Anda bisa menggunakan `%f` untuk menemukan sesuatu hanya jika didahului oleh jenis karakter tertentu.

**Contoh:** Ekstrak angka hanya jika angka tersebut muncul tepat setelah mata uang.

```lua
local harga = "item1: 2500, item2: $50, item3: 75USD"

print("\nMengekstrak harga dalam USD:")
-- Pola:
-- %f[%d]  : Temukan transisi ke sebuah digit
-- (%d+)   : Tangkap satu atau lebih digit yang mengikuti transisi itu
for pos, angka in string.gmatch(harga, "()%f[%d](%d+)") do
    -- Cek karakter sebelum posisi frontier
    local char_before = string.sub(harga, pos - 1, pos - 1)
    if char_before == '$' or char_before == 'D' then -- 'D' dari USD
        print("  Harga ditemukan: " .. angka)
    end
end
-- Output:
--   Harga ditemukan: 50
--   Harga ditemukan: 75
```

**3. Text Parsing Applications (Aplikasi Parsing Teks)**
`%f` sangat bagus untuk memecah string berdasarkan perubahan tipe karakter.

**Contoh:** Pisahkan string yang berisi campuran huruf dan angka.

```lua
local data = "R2D2C3PO"
local hasil_parsing = {}

-- Gabungkan dua gmatch. Satu untuk huruf, satu untuk angka.
-- Atau cara yang lebih canggih: temukan semua perbatasan.
local gabungan = data
local i = 1
while true do
    -- Temukan perbatasan berikutnya (dari huruf ke angka atau sebaliknya)
    local p_ke_angka = string.find(gabungan, "%f[%d]", i)
    local p_ke_huruf = string.find(gabungan, "%f[%a]", i)

    -- Pilih perbatasan terdekat yang ada
    local p
    if not p_ke_angka then p = p_ke_huruf
    elseif not p_ke_huruf then p = p_ke_angka
    else p = math.min(p_ke_angka, p_ke_huruf)
    end

    if not p then break end

    -- Tambahkan spasi di posisi perbatasan
    gabungan = string.sub(gabungan, 1, p - 1) .. " " .. string.sub(gabungan, p)
    i = p + 1 -- Lanjutkan pencarian setelah spasi yang baru ditambahkan
end

print("\nHasil parsing '" .. data .. "': " .. gabungan)
-- Output: Hasil parsing 'R2D2C3PO': R 2 D 2 C 3 PO
```

**Sumber:** [Stack Overflow - Frontier Pattern](https://stackoverflow.com/questions/12156327/lua-frontier-pattern-match-whole-word-search)

---

### Modul 7: Balanced Delimiters (%b)

Bayangkan Anda perlu mengekstrak isi dari sebuah fungsi, termasuk semua kurung-kurung bersarang di dalamnya, atau mengambil konten dari sebuah tag XML yang kompleks. Di sinilah `%b` bersinar.

#### 7.1 Balanced Matching Fundamentals

**Konsep:**
_Balanced Delimiters_ (pembatas seimbang) adalah pasangan karakter pembuka dan penutup, seperti `()` (kurung biasa), `[]` (kurung siku), atau `{}` (kurung kurawal). Tantangan dalam _pattern matching_ adalah menemukan pasangan yang benar-benar cocok, terutama jika ada pasangan yang sama bersarang (_nested_) di dalamnya.

Pola `%bxy` dirancang khusus untuk ini.

- **Sintaks:** `%bxy`
  - `%b`: Tanda bahwa ini adalah pencocokan seimbang.
  - `x`: Karakter pembatas pembuka (misalnya, `(`).
  - `y`: Karakter pembatas penutup (misalnya, `)`).

**Cara Kerja:**
Ketika mesin _pattern_ Lua menemukan pola `%bxy`, ia akan:

1.  Mencari karakter pembuka `x` pertama.
2.  Setelah menemukannya, ia akan memindai maju sambil menghitung. Setiap kali bertemu `x` lagi, ia akan menambah hitungan. Setiap kali bertemu `y`, ia akan mengurangi hitungan.
3.  Pencocokan dianggap selesai ketika hitungan kembali ke nol (artinya karakter `y` penutup yang sesuai telah ditemukan).
4.  Hasilnya adalah seluruh blok, dari `x` pembuka pertama hingga `y` penutup yang sesuai.

**Contoh:** Pada string `(a (b (c)) d)`, jika kita menggunakan pola `%b()`, ia akan cocok dengan seluruh string karena kurung paling luar adalah pasangan yang seimbang.

**Keunggulan vs POSIX Regex:**
Ini adalah keunggulan besar. POSIX Regex standar tidak memiliki cara untuk menangani struktur bersarang dengan kedalaman arbitrer (tidak terbatas) karena ia tidak memiliki "memori" atau "hitungan". Untuk melakukan ini di sistem Regex lain, seringkali memerlukan fitur-fitur canggih seperti _recursive patterns_ yang tidak semua implementasi miliki. Di Lua, fitur ini sudah bawaan dan sangat efisien.

**Sumber:** [Stack Overflow - Lua vs Regex](https://stackoverflow.com/questions/2693334/lua-pattern-matching-vs-regular-expressions)

#### 7.2 Implementasi Balanced Matching

Mari kita lihat bagaimana `%b` digunakan dalam kode.

**1. Parentheses, Brackets, Braces:**
Ini adalah kasus penggunaan yang paling umum, terutama untuk mem-parsing kode atau data terstruktur.

```lua
local kode = "print(data[i].name)"

-- Mengekstrak argumen dari pemanggilan fungsi print()
local arg_fungsi = string.match(kode, "%b()")
print("Argumen fungsi: " .. arg_fungsi) -- Output: (data[i].name)

-- Mengekstrak indeks array dari 'data'
local indeks_array = string.match(kode, "%b[]")
print("Indeks array: " .. indeks_array) -- Output: [i]
```

**2. Custom Delimiter Pairs (Pasangan Pembatas Kustom):**
Anda tidak terbatas hanya pada kurung. `x` dan `y` bisa berupa karakter apa saja (yang tidak termasuk dalam _magic set_ `().%+-*?[]^$`).

```lua
local teks = "Pilih salah satu: <opsi1> atau <opsi2>."

-- Mengekstrak konten di antara '<' dan '>'
local opsi = string.match(teks, "%b<>")
print("Opsi pertama: " .. opsi) -- Output: <opsi1>
```

**3. Nested Structure Parsing (Parsing Struktur Bersarang):**
Di sinilah kekuatan sejati `%b` terlihat. Ia dengan mudah menangani kedalaman bersarang apa pun.

```lua
local data_lisp = "(add 10 (multiply 5 (subtract 4 2)))"

-- Pola %b() akan menemukan pasangan kurung terluar yang seimbang
local seluruh_ekspresi = string.match(data_lisp, "%b()")

print("Ekspresi LISP yang ditangkap: " .. seluruh_ekspresi)
-- Output: (add 10 (multiply 5 (subtract 4 2)))

-- Mari kita buktikan dengan string yang lebih kompleks
local html_like = "<div><p>Paragraf <span>teks</span></p></div>"
local div_content = string.match(html_like, "%b<>")
print("Konten DIV: " .. div_content)
-- Output: <div><p>Paragraf <span>teks</span></p></div>
```

Perhatikan bagaimana pada contoh `html_like`, `%b<>` menangkap dari `<div>` pertama hingga `</div>` terakhir, dengan benar mengabaikan tag-tag penutup antara seperti `</span>` dan `</p>`.

**Sumber:** [Stack Overflow - Optional Balanced Braces](https://stackoverflow.com/questions/50337786/lua-pattern-b-optional-balanced-braces-possible)

#### 7.3 Advanced Balanced Patterns

**Error Handling untuk Unbalanced Input:**
Apa yang terjadi jika input tidak seimbang? `string.match` (dan fungsi lainnya) akan gagal mencocokkan dan mengembalikan `nil`. Ini bisa kita manfaatkan sebagai cara untuk memvalidasi struktur.

```lua
local valid_code = "if (x > 0) then print('ok') end"
local invalid_code = "if (x > 0 then print('oops') end" -- kurung penutup hilang

local function cek_kurung(s)
    if string.find(s, "%b()") then
        print("Struktur kurung dalam string terlihat seimbang.")
    else
        print("Peringatan: Struktur kurung dalam string mungkin tidak seimbang.")
    end
end

cek_kurung(valid_code)   -- Output: Struktur kurung dalam string terlihat seimbang.
cek_kurung(invalid_code) -- Output: Peringatan: Struktur kurung dalam string mungkin tidak seimbang.
```

**Performance Considerations:**
Implementasi `%bxy` di Lua sangat efisien. Ia hanya melakukan pemindaian linear tunggal melalui string sambil menjaga sebuah penghitung. Ini jauh lebih cepat daripada mesin Regex berbasis _backtracking_ yang mencoba berbagai kemungkinan secara rekursif untuk tugas yang sama.

**Menangani Kasus "Opsional":**
Kurikulum menyebutkan "Optional Balanced Braces". Ini adalah skenario lanjutan di mana sebuah blok mungkin ada atau tidak ada. `%b` sendiri tidak bisa dibuat opsional dengan `?`. Solusinya adalah dengan mencoba beberapa pola secara berurutan.

**Contoh:** Kita ingin mengekstrak nama fungsi dan argumennya. Argumen dalam `()` bersifat opsional.

```lua
function parseFunctionCall(s)
    -- Pola 1: Mencari nama diikuti oleh blok kurung seimbang
    local nama, args = string.match(s, "(%w+)%s*(%b())")
    if nama then
        print("Fungsi '" .. nama .. "' dipanggil dengan argumen: " .. args)
        return
    end

    -- Pola 2: Jika Pola 1 gagal, cari nama saja (tanpa argumen)
    nama = string.match(s, "^(%w+)$")
    if nama then
        print("Fungsi '" .. nama .. "' dipanggil tanpa argumen.")
        return
    end

    print("Format pemanggilan fungsi tidak dikenali.")
end

parseFunctionCall("start_engine()")
parseFunctionCall("shutdown")
parseFunctionCall("set_value(key, value)")
-- Output:
-- Fungsi 'start_engine' dipanggil dengan argumen: ()
-- Fungsi 'shutdown' dipanggil tanpa argumen.
-- Fungsi 'set_value' dipanggil dengan argumen: (key, value)
```

Pendekatan ini—mencoba pola yang paling spesifik terlebih dahulu, lalu beralih ke yang lebih umum—adalah strategi yang sangat umum dan kuat dalam parsing menggunakan _pattern matching_ Lua.

**Sumber:** [Stack Overflow - Optional Balanced Braces](https://stackoverflow.com/questions/50337786/lua-pattern-b-optional-balanced-braces-possible)

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../README.md

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
