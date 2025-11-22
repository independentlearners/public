# LEVEL 5

<details>
<summary>Gemini 2.5 Pro</summary>

</details>

#

<details>
<summary>Gemini 2.5 Flash</summary>

# **LEVEL 5: UTF-8 & UNICODE HANDLING (LUA 5.3+)**

Pada level ini, kita akan membahas bagaimana Lua menangani karakter Unicode dan pengkodean UTF-8. Sejak Lua 5.3, ada peningkatan dukungan bawaan untuk UTF-8, menjadikannya topik penting bagi siapa pun yang bekerja dengan teks yang bukan hanya ASCII.

### **5.1 Memahami UTF-8 dan Unicode**

Sebelum kita menyelam ke dalam fungsi, penting untuk memahami konsep dasar di balik UTF-8 dan Unicode.

- **Unicode: Character set dan code points**

  - **Unicode**: Sebuah standar internasional yang bertujuan untuk mengkodekan, mewakili, dan menangani teks dari semua sistem penulisan di dunia. Ini adalah _character set_ universal.
  - **Character Set**: Sebuah koleksi karakter, seperti huruf, angka, simbol, dan emoji. ASCII adalah _character set_ kecil yang hanya mencakup karakter Inggris dasar. Unicode adalah _character set_ yang jauh lebih besar dan inklusif.
  - **Code Point**: Setiap karakter dalam Unicode diberi nomor unik, yang disebut _code point_. Code point biasanya direpresentasikan dalam format heksadesimal dengan awalan `U+`, misalnya `U+0041` untuk 'A', `U+00E1` untuk 'á', atau `U+1F600` untuk emoji wajah tersenyum (😀).
  - **Contoh**:

    - Karakter 'A' (Latin Capital Letter A) memiliki code point `U+0041`.
    - Karakter 'é' (Latin Small Letter E with Acute) memiliki code point `U+00E9`.
    - Karakter '你好' (Ni hao) terdiri dari dua karakter: '你' (U+4F60) dan '好' (U+597D).

  - **Penting**: Unicode adalah _daftar karakter_ dan _nomor uniknya_. Ini bukan tentang bagaimana karakter-karakter tersebut disimpan dalam memori atau ditransmisikan. Di sinilah _encoding_ berperan.

  - **Sumber Terverifikasi**: Unicode Consortium (Official Website), Wikipedia: Unicode.

- **UTF-8: Variable-width encoding untuk Unicode**

  - **UTF-8 (Unicode Transformation Format - 8-bit)**: Ini adalah **encoding** (skema pengkodean) yang paling umum dan fleksibel untuk Unicode. Ini adalah encoding _variable-width_, yang berarti karakter yang berbeda dapat menggunakan jumlah byte yang berbeda.
  - **Bagaimana Cara Kerjanya**:
    - Karakter ASCII (U+0000 hingga U+007F) dikodekan menggunakan **1 byte**. Ini berarti teks ASCII lama adalah UTF-8 yang valid, membuat UTF-8 _backward compatible_ dengan ASCII.
    - Karakter Unicode lainnya dikodekan menggunakan **2, 3, atau 4 byte**.
      - Karakter umum Latin yang diperpanjang (misalnya huruf beraksen) seringkali 2 byte.
      - Karakter CJK (Cina, Jepang, Korea) umumnya 3 byte.
      - Emoji dan karakter jarang lainnya seringkali 4 byte.
  - **Keuntungan UTF-8**:
    - **Efisiensi Ruang**: Karakter yang paling umum (ASCII) hanya membutuhkan 1 byte, menghemat ruang dibandingkan encoding _fixed-width_ (misalnya UTF-32).
    - **Kompatibilitas ASCII**: Memudahkan transisi dari sistem berbasis ASCII.
    - **Fleksibilitas**: Dapat merepresentasikan semua karakter Unicode.
  - **Implikasi untuk String di Lua**: Karena UTF-8 menggunakan _variable-width_, satu "karakter" dalam arti visual atau logis (satu _code point_ Unicode) mungkin terdiri dari beberapa byte. Ini berarti bahwa:

    - `string.len()` (operator `#`) mengembalikan **jumlah byte**, bukan jumlah karakter Unicode.
    - `string.sub()` bekerja pada **posisi byte**, bukan posisi karakter Unicode.
    - `string.find()` dan pola lainnya bekerja pada **byte**, bukan pada _code points_ Unicode. Ini bisa menjadi masalah jika pola Anda ingin mencocokkan karakter logis, bukan urutan byte.

  - **Sumber Terverifikasi**: UTF-8.com, Wikipedia: UTF-8.

- **Masalah dengan penanganan string non-ASCII di Lua sebelum 5.3 (byte-based)**

  Sebelum Lua 5.3, pustaka string standar Lua sepenuhnya **byte-agnostic**. Ini berarti semua fungsi string (seperti `string.len`, `string.sub`, `string.find`, `string.upper`, dll.) memperlakukan string sebagai urutan byte. Mereka tidak memiliki pemahaman tentang _encoding_ karakter seperti UTF-8.

  - **Contoh Masalah**:

    - **Panjang String**: `string.len("你好")` akan mengembalikan `6` (karena '你' adalah 3 byte dan '好' adalah 3 byte dalam UTF-8), bukan `2` (jumlah karakter logis).
    - **Substring**: `string.sub("你好", 1, 3)` akan mengembalikan '你', tetapi `string.sub("你好", 4, 6)` akan mengembalikan '好'. Jika Anda mencoba `string.sub("你好", 1, 4)`, itu akan menghasilkan karakter yang rusak karena Anda memotong di tengah byte-sequence karakter kedua.
    - **Uppercase/Lowercase**: `string.upper("你好")` akan mengembalikan "你好" juga, karena tidak ada pemetaan uppercase untuk karakter CJK. Bahkan untuk karakter Latin beraksen, `string.upper("é")` akan mengembalikan "é" karena fungsi ini hanya bekerja untuk rentang ASCII.
    - **Pattern Matching**: Pola seperti `%a` atau `%l` hanya cocok dengan karakter ASCII. Mereka tidak akan cocok dengan 'é' atau 'ñ'.
    - **Iterasi**: Mengiterasi string menggunakan `for i = 1, #s do char = s:sub(i,i) ... end` akan mengiterasi byte, bukan karakter Unicode.

  - **Implikasi**: Untuk bekerja dengan teks multibahasa sebelum Lua 5.3, Anda harus menggunakan pustaka eksternal (misalnya `utf8` module yang populer di luar core Lua) atau menulis logika penanganan byte Anda sendiri, yang rumit dan rentan kesalahan.

  - **Sumber Terverifikasi**: Lua 5.2 Reference Manual (tidak ada `utf8` table), berbagai diskusi komunitas Lua sebelum 5.3.

### **5.2 `utf8` Library (Lua 5.3+)**

Dengan diperkenalkannya Lua 5.3, Lua menambahkan pustaka `utf8` standar. Pustaka ini menyediakan fungsi-fungsi yang sadar Unicode dan UTF-8, memungkinkan Anda untuk bekerja dengan karakter logis, bukan hanya byte.

- **`utf8.len()`: Character count, not byte count**

  - **Tujuan**: Mengembalikan jumlah karakter Unicode (code points) dalam sebuah string UTF-8 yang valid, bukan jumlah byte.
  - **Sintaks Dasar**: `utf8.len(s [, i [, j]])`
    - `s`: String yang akan dihitung panjangnya.
    - `i` (opsional): Indeks byte awal (default 1).
    - `j` (opsional): Indeks byte akhir (default `#s`).
  - **Return Values**:
    - Jika string adalah UTF-8 valid: Jumlah karakter Unicode.
    - Jika string tidak valid UTF-8: Mengembalikan `nil` diikuti oleh posisi byte pertama yang tidak valid.
  - **Contoh Kode**:

    ```lua
    local s1 = "Hello"
    local s2 = "你好世界" -- Ni Hao Shi Jie (Hello World dalam Mandarin)
    local s3 = "éxample" -- 'é' adalah karakter 2 byte
    local s4 = "😀" -- Emoji, biasanya 4 byte
    local s5 = "Invalid \xC3\x28 String" -- Byte sequence tidak valid untuk UTF-8

    print("String:", s1, "Bytes:", #s1, "Chars (utf8.len):", utf8.len(s1))
    -- Output: String: Hello Bytes: 5 Chars (utf8.len): 5

    print("String:", s2, "Bytes:", #s2, "Chars (utf8.len):", utf8.len(s2))
    -- Output: String: 你好世界 Bytes: 12 Chars (utf8.len): 4 (3 byte per karakter)

    print("String:", s3, "Bytes:", #s3, "Chars (utf8.len):", utf8.len(s3))
    -- Output: String: éxample Bytes: 8 Chars (utf8.len): 7 (e adalah 2 byte, xample adalah 6 byte)

    print("String:", s4, "Bytes:", #s4, "Chars (utf8.len):", utf8.len(s4))
    -- Output: String: 😀 Bytes: 4 Chars (utf8.len): 1

    local len, pos_error = utf8.len(s5)
    print("String:", s5, "Bytes:", #s5, "Chars (utf8.len):", len, "Error at:", pos_error)
    -- Output: String: Invalid �( String Bytes: 19 Chars (utf8.len): nil Error at: 9
    ```

  - **Sumber Terverifikasi**: Lua 5.4 Reference Manual Section 6.7 (UTF8 Library).

- **`utf8.char()`: Convert code points to UTF-8 string**

  - **Tujuan**: Membuat string UTF-8 dari satu atau lebih _code points_ Unicode numerik.
  - **Sintaks Dasar**: `utf8.char(c1 [, c2 ...])`
    - `c1, c2, ...`: Satu atau lebih _code points_ Unicode (angka).
  - **Contoh Kode**:

    ```lua
    print(utf8.char(0x41)) -- U+0041 (A)
    -- Output: A

    print(utf8.char(0x00E9)) -- U+00E9 (é)
    -- Output: é

    print(utf8.char(0x4F60, 0x597D)) -- U+4F60 (你), U+597D (好)
    -- Output: 你好

    print(utf8.char(0x1F600)) -- U+1F600 (😀)
    -- Output: 😀
    ```

  - **Sumber Terverifikasi**: Lua 5.4 Reference Manual Section 6.7.

- **`utf8.codes()`: Iterator for code points**

  - **Tujuan**: Mengembalikan sebuah _iterator_ yang dapat digunakan dalam loop `for` untuk mengulang setiap _code point_ Unicode dalam sebuah string UTF-8. Ini adalah cara yang benar untuk mengiterasi karakter di Lua 5.3+.
  - **Sintaks Dasar**: `utf8.codes(s)`
    - `s`: String UTF-8.
  - **Return Values**:
    - Fungsi _iterator_ yang mengembalikan `(byte_position, code_point)` untuk setiap karakter.
  - **Contoh Kode**:

    ```lua
    local kalimat = "Lua adalah ❤️"

    print("Iterasi karakter:")
    for byte_pos, cp in utf8.codes(kalimat) do
        print("Posisi byte:", byte_pos, "Code Point:", cp, "Char:", utf8.char(cp))
    end
    -- Output:
    -- Posisi byte: 1 Code Point: 76 Char: L
    -- Posisi byte: 2 Code Point: 117 Char: u
    -- Posisi byte: 3 Code Point: 97 Char: a
    -- Posisi byte: 4 Code Point: 32 Char:
    -- Posisi byte: 5 Code Point: 97 Char: a
    -- Posisi byte: 6 Code Point: 100 Char: d
    -- Posisi byte: 7 Code Point: 97 Char: a
    -- Posisi byte: 8 Code Point: 108 Char: l
    -- Posisi byte: 9 Code Point: 97 Char: a
    -- Posisi byte: 10 Code Point: 104 Char: h
    -- Posisi byte: 11 Code Point: 32 Char:
    -- Posisi byte: 12 Code Point: 2764 Char: ❤️ (Ini mungkin akan tercetak sebagai 1 karakter dalam konsol yang mendukung Unicode)
    ```

  - **Sumber Terverifikasi**: Lua 5.4 Reference Manual Section 6.7.

- **`utf8.offset()`: Byte offset for character index**

  - **Tujuan**: Mengembalikan posisi byte dari karakter Unicode ke-`n` dalam sebuah string, memungkinkan Anda untuk melakukan operasi seperti `string.sub` pada batasan karakter yang benar.
  - **Sintaks Dasar**: `utf8.offset(s, n [, i])`
    - `s`: String UTF-8.
    - `n`: Indeks karakter Unicode yang diinginkan (bukan indeks byte).
    - `i` (opsional): Posisi byte awal pencarian (default 1).
  - **Return Values**:
    - Posisi byte dari karakter ke-`n`.
    - `nil` jika `n` di luar batas string atau jika string tidak valid UTF-8.
  - **Contoh Kode**:

    ```lua
    local teks_unicode = "你好世界" -- 4 karakter, 12 byte

    -- Dapatkan posisi byte karakter ke-3 ('世')
    local pos_char3 = utf8.offset(teks_unicode, 3)
    print("Posisi byte karakter ke-3:", pos_char3)
    -- Output: Posisi byte karakter ke-3: 7 (karena char 1 (你) = 3 byte, char 2 (好) = 3 byte, jadi char 3 mulai dari byte 7)

    -- Dapatkan substring dari karakter ke-2 hingga ke-3
    local start_byte = utf8.offset(teks_unicode, 2)
    local end_byte = utf8.offset(teks_unicode, 4) -- Posisi byte setelah karakter ke-3, atau awal karakter ke-4
    if start_byte and end_byte then
        -- string.sub membutuhkan (start_byte, end_byte-1) untuk substring karakter tunggal,
        -- atau (start_byte, utf8.offset(s, n+1)-1) untuk n karakter.
        -- Cara paling aman: ambil seluruh string dari start_byte hingga end_byte berikutnya, atau gunakan iterasi

        -- Untuk mengambil satu karakter (char ke-2: '好')
        print("Karakter ke-2:", string.sub(teks_unicode, start_byte, utf8.offset(teks_unicode, 3)-1))
        -- Output: Karakter ke-2: 好

        -- Untuk mengambil dari karakter ke-2 hingga ke-3 ('好世')
        -- Cek dulu utf8.offset(teks_unicode, 4) ada atau tidak
        local end_of_third_char = utf8.offset(teks_unicode, 4)
        if end_of_third_char then
            print("Karakter ke-2 hingga ke-3:", string.sub(teks_unicode, start_byte, end_of_third_char - 1))
        else
            -- Jika karakter ke-4 tidak ada (misal ambil sampai akhir string)
            print("Karakter ke-2 hingga ke-3:", string.sub(teks_unicode, start_byte))
        end
        -- Output: Karakter ke-2 hingga ke-3: 好世
    end
    ```

  - **Penting**: `utf8.offset()` adalah jembatan antara indeks karakter logis dan indeks byte yang digunakan oleh `string.sub()`. Ini memungkinkan Anda untuk memotong atau mengambil bagian string berdasarkan karakter Unicode yang benar.

  - **Sumber Terverifikasi**: Lua 5.4 Reference Manual Section 6.7.

- **`utf8.charpattern` and `utf8.codepoint()`**

  - **`utf8.charpattern`**:

    - **Tujuan**: Ini bukan fungsi, melainkan sebuah **string pola** yang disimpan dalam pustaka `utf8`. Pola ini cocok dengan **satu karakter UTF-8 yang valid**.
    - **Kapan Digunakan**: Anda bisa menggunakan pola ini dengan `string.gmatch()` atau `string.find()` untuk mengiterasi atau mencari karakter UTF-8 dalam string.
    - **Contoh Kode**:

      ```lua
      local kalimat = "Hello, 你好! 😀"

      print("Menggunakan utf8.charpattern:")
      for char_utf8 in string.gmatch(kalimat, utf8.charpattern) do
          print(char_utf8)
      end
      -- Output: (setiap karakter akan dicetak pada baris baru, termasuk spasi, koma, dan emoji)
      -- H
      -- e
      -- l
      -- l
      -- o
      -- ,
      --
      -- 你
      -- 好
      -- !
      --
      -- 😀
      ```

      - **Penjelasan**: `string.gmatch(kalimat, utf8.charpattern)` akan menemukan setiap urutan byte yang valid yang membentuk satu karakter UTF-8 dalam `kalimat`. Ini adalah cara yang bagus untuk "memotong" string per karakter Unicode.

  - **`utf8.codepoint()`**:

    - **Tujuan**: Mengembalikan _code point_ numerik dari satu atau lebih karakter UTF-8 pada posisi byte tertentu.
    - **Sintaks Dasar**: `utf8.codepoint(s [, i [, j]])`
      - `s`: String UTF-8.
      - `i` (opsional): Posisi byte awal (default 1).
      - `j` (opsional): Posisi byte akhir (default `i`).
    - **Return Values**:
      - Satu atau lebih _code point_ numerik.
      - `nil` jika string tidak valid UTF-8 pada posisi tersebut.
    - **Contoh Kode**:

      ```lua
      local my_string = "Aé你"

      -- Dapatkan code point karakter pertama ('A')
      print(utf8.codepoint(my_string, 1))
      -- Output: 65 (0x41)

      -- Dapatkan code point karakter kedua ('é')
      print(utf8.codepoint(my_string, utf8.offset(my_string, 2)))
      -- Output: 233 (0x00E9)

      -- Dapatkan code point dari rentang byte (misal, dari karakter ke-1 sampai ke-3)
      -- Menggunakan iterasi utf8.codes lebih disarankan untuk ini
      print("All code points:")
      for byte_pos, cp in utf8.codes(my_string) do
          print(cp)
      end
      -- Output:
      -- 65
      -- 233
      -- 20320
      ```

      - **Penjelasan**: `utf8.codepoint(my_string, 1)` mengambil _code point_ dari karakter yang dimulai pada byte 1. `utf8.codepoint(my_string, utf8.offset(my_string, 2))` terlebih dahulu menemukan posisi byte awal karakter kedua menggunakan `utf8.offset()`, lalu mengambil _code point_ dari posisi tersebut.

  - **Sumber Terverifikasi**: Lua 5.4 Reference Manual Section 6.7.

### **5.3 Best Practices for UTF-8 in Lua**

- **Always assume UTF-8 for new projects**

  - Di dunia modern, terutama di web atau aplikasi lintas platform, UTF-8 adalah standar _de facto_. Selalu berasumsi bahwa input Anda akan berupa UTF-8 dan output Anda harus berupa UTF-8.
  - Ini akan mencegah banyak masalah karakter yang rusak (mojibake) di kemudian hari.

- **Use `utf8` library for character-based operations**

  - Setiap kali Anda perlu melakukan operasi yang berkaitan dengan "karakter logis" (misalnya, menghitung jumlah karakter, memotong string berdasarkan karakter, mengiterasi per karakter, atau mengkonversi kasus untuk non-ASCII), selalu gunakan fungsi-fungsi dari pustaka `utf8`.
  - **Jangan** mengandalkan `string.len()`, `string.sub()`, atau pola `string` standar untuk karakter non-ASCII jika Anda ingin perilaku berbasis karakter.

- **Avoid mixing byte-based and character-based logic carelessly**

  - Berhati-hatilah saat mencampur operasi `string` bawaan (byte-based) dengan fungsi `utf8` (character-based).
  - Contoh: Jika Anda mengambil indeks byte dari `utf8.offset()` dan kemudian mencoba menggunakan `string.find()` dengan pola yang tidak _aware_ Unicode, Anda mungkin mendapatkan hasil yang tidak terduga.
  - Pastikan Anda memahami apakah Anda bekerja dengan indeks byte atau indeks karakter dalam setiap langkah.

- **Consider external libraries for advanced Unicode features (e.g., normalization, collation)**

  - Pustaka `utf8` standar di Lua 5.3+ menyediakan fungsionalitas dasar yang sangat baik untuk penanganan UTF-8.
  - Namun, ada fitur Unicode yang lebih canggih yang tidak disediakan oleh pustaka standar, seperti:
    - **Unicode Normalization**: Mengubah representasi karakter menjadi bentuk kanonik (misalnya, 'é' bisa dikodekan sebagai satu karakter atau sebagai 'e' diikuti karakter aksen).
    - **Collation (Sorting)**: Mengurutkan string berdasarkan aturan lokal Unicode (misalnya, di beberapa bahasa 'ä' datang setelah 'a', di bahasa lain setelah 'z').
    - **Word/Sentence Breaking**: Menentukan batasan kata atau kalimat yang benar dalam teks multibahasa.
    - **Case Conversion Beyond ASCII**: Mengkonversi kasus untuk karakter di luar rentang ASCII (misalnya, huruf kapital untuk 'ß' atau 'İ').
  - Untuk fitur-fitur ini, Anda kemungkinan besar perlu mencari pustaka pihak ketiga yang dioptimalkan untuk Lua, seperti `luautf8` (yang juga menyediakan beberapa fitur yang hilang dari `utf8` bawaan di Lua 5.3) atau solusi yang lebih komprehensif yang dibangun di atas ICU (International Components for Unicode).

---

Ini adalah akhir dari pembahasan **LEVEL 5: UTF-8 & UNICODE HANDLING**. Anda sekarang harus memiliki pemahaman yang solid tentang tantangan yang ditimbulkan oleh teks multibahasa, bagaimana UTF-8 bekerja, dan bagaimana memanfaatkan pustaka `utf8` di Lua 5.3+ untuk menangani karakter Unicode dengan benar. Dengan demikian kita dapat membangun aplikasi Lua yang lebih siap secara global. Bagian berikutnya, kita akan masuk ke **LEVEL 6: ADVANCED TOPICS & LPEG**. Ini adalah tingkat yang lebih lanjut yang akan membahas pustaka `lpeg` yang sangat kuat, sebuah pustaka _parsing expression grammar_ untuk Lua.

</details>

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md

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
