### Daftar Isi (Bagian I)

- [**BAGIAN I: FONDASI PATTERN MATCHING**](#bagian-i-fondasi-pattern-matching)
  - [1.1 Pengenalan Filosofi Pattern Matching Lua](#11-pengenalan-filosofi-pattern-matching-lua)
  - [1.2 Character Classes - Lengkap dan Mendalam](#12-character-classes---lengkap-dan-mendalam)
  - [1.3 Pattern Modifiers dan Quantifiers Lanjutan](#13-pattern-modifiers-dan-quantifiers-lanjutan)
  - [1.4 Pattern Internals dan Optimizations](#14-pattern-internals-dan-optimizations)

---

## **[BAGIAN I: FONDASI PATTERN MATCHING][0]**

Bagian ini adalah fondasi mutlak. Tanpa pemahaman yang kokoh di sini, mustahil untuk melanjutkan ke teknik yang lebih canggih. Kita akan membedah "DNA" dari sistem pattern matching Lua.

### 1.1 Pengenalan Filosofi Pattern Matching Lua

Sebelum menulis satu baris kode pun, sangat penting untuk memahami _filosofi_ di balik _patterns_ Lua. Ini akan mencegah kebingungan dan frustrasi di kemudian hari.

- **Perbedaan Fundamental: Lua Patterns vs. Regex Tradisional**
  - **Analogi**: Jika Regex (seperti PCRE) adalah sebuah pisau tentara Swiss dengan seratus alat, maka Lua Patterns adalah sebuah pisau bedah (scalpel): lebih terbatas, tetapi sangat tajam, cepat, dan efisien untuk tugas-tugas spesifiknya.
  - **Perbedaan Utama**:
    - **Terbatas**: Lua patterns sengaja tidak mengimplementasikan semua fitur Regex. Tidak ada operator alternasi (`|`), _non-capturing groups_ (`(?:...)`), _lookarounds_ (lookahead/lookbehind), atau quantifier kompleks seperti `{n,m}`.
    - **Sintaks Berbeda**: Karakter "ajaib" (magic characters) diawali dengan `%`, bukan `\` (misalnya `%d` untuk digit, bukan `\d`). Karakter yang memiliki arti khusus dalam pattern (seperti `( ) . % + - * ? [ ] ^ $`) harus di-escape dengan `%`.
  - **Mengapa Berbeda? Filosofi Minimalis dan Efisiensi**
    - Tujuan utama desain Lua adalah menjadi bahasa yang kecil, portabel, dan mudah disematkan (embeddable). Mesin Regex yang lengkap seperti PCRE bisa berukuran lebih besar dari seluruh interpreter Lua standar.
    - Dengan menjaga fitur pattern matching tetap minimalis, Lua memastikan bahwa library string-nya tetap kecil dan memiliki performa yang sangat cepat untuk operasi-operasi umum. Keputusan ini adalah pertukaran sadar antara kelengkapan fitur dan efisiensi.

### 1.2 Character Classes - Lengkap dan Mendalam

_Character classes_ adalah blok bangunan paling dasar dari sebuah pattern. Mereka mendefinisikan _jenis_ karakter apa yang ingin kita cocokkan.

- **Magic Characters**: Ini adalah kelas-kelas karakter yang sudah ditentukan sebelumnya.

  - `%a`: Huruf (alphabetic)
  - `%d`: Angka (digit)
  - `%l`: Huruf kecil (lowercase)
  - `%u`: Huruf besar (uppercase)
  - `%w`: Karakter alfanumerik (huruf dan angka)
  - `%s`: Karakter spasi (whitespace), termasuk spasi, tab, newline.
  - `%p`: Tanda baca (punctuation)
  - `%c`: Karakter kontrol (control characters)
  - `%x`: Digit heksadesimal
  - `%z`: Karakter `\0` (null character)

- **Complement Classes (Kelas Kebalikan)**: Dengan menggunakan versi huruf besar dari kelas di atas, Anda membalikkan artinya (mencocokkan semua karakter yang **bukan** bagian dari kelas tersebut).

  - `%A`: Bukan huruf
  - `%D`: Bukan angka
  - `%S`: Bukan spasi, dan seterusnya.

- **Custom Character Sets (`[]` dan `[^]`)**: Ketika kelas bawaan tidak cukup, Anda bisa mendefinisikan set Anda sendiri.

  - `[aeiou]`: Mencocokkan salah satu dari vokal huruf kecil.
  - `[a-zA-Z0-9]`: Mencocokkan karakter alfanumerik apa pun (sama dengan `%w`).
  - `[^0-9]`: Mencocokkan karakter apa pun yang **bukan** angka (sama dengan `%D`).

**Contoh Kode:**

```lua
local text = "User: John Doe, ID: 123-456!"

-- Mencari nama pengguna (serangkaian huruf dan spasi)
local name = string.match(text, "%u%l* %u%l*")
print("Name:", name) -- Output: Name: John Doe

-- Menghapus semua yang bukan digit dari ID
local id_text = "ID: 123-456!"
local cleaned_id = string.gsub(id_text, "%D", "")
print("Cleaned ID:", cleaned_id) -- Output: Cleaned ID: 123456

-- Mencari karakter pertama yang merupakan vokal atau angka
local found = string.match(text, "[aeiou0-9]")
print("Found:", found) -- Output: Found: o (dari John)
```

### 1.3 Pattern Modifiers dan Quantifiers Lanjutan

_Quantifiers_ menentukan _berapa kali_ sebuah karakter atau kelas harus muncul.

- **Quantifiers Dasar (Greedy/Serakah)**: Secara default, quantifiers di Lua bersifat "greedy". Artinya, mereka akan mencoba mencocokkan urutan karakter _terpanjang_ yang memungkinkan.

  - `*`: Mencocokkan 0 kali atau lebih (serakah).
  - `+`: Mencocokkan 1 kali atau lebih (serakah).
  - `?`: Mencocokkan 0 atau 1 kali.
  - `.`: Mencocokkan karakter apa pun.

- **Non-Greedy Matching (`-`)**: Ini adalah salah satu fitur unik Lua yang sering disalahpahami. Quantifier `-` adalah kebalikan dari `*`. Ia akan mencoba mencocokkan urutan karakter _terpendek_ yang memungkinkan.

  - **Penting**: `-` bukan modifier yang bisa digabungkan dengan `+` atau `?`. Ia adalah quantifier tersendiri.

**Contoh Greedy vs Non-Greedy:**

```lua
local text = "<b>bold text</b> and <i>italic text</i>"

-- Greedy match: `.+` mencocokkan dari '<' pertama hingga '>' terakhir
print(string.match(text, "<.+>"))
-- Output: <b>bold text</b> and <i>italic text</i>

-- Non-greedy match: `.-` mencocokkan dari '<' pertama hingga '>' pertama yang ditemui
print(string.match(text, "<.->"))
-- Output: <b>
```

_Catatan_: Contoh di atas menunjukkan `.` sebelum quantifier. `string.match("<b>", "<.->")` akan cocok dengan `<b>`.

- **Balanced Matching (`%bxy`)**: Ini adalah "senjata rahasia" pattern Lua, sangat kuat untuk parsing teks berstruktur. `%bxy` mencocokkan sebuah string yang dimulai dengan `x`, diakhiri dengan `y`, dan pasangan `x` dan `y` di dalamnya seimbang.
  - Contoh paling umum adalah `%b()`, yang sempurna untuk mencocokkan konten di dalam tanda kurung, bahkan jika tanda kurung tersebut bersarang.

**Contoh Balanced Matching:**

```lua
local code = "function(arg1, function(arg2) print(arg2) end)"

-- Mencocokkan seluruh isi dari tanda kurung terluar
local inner_code = string.match(code, "%b()")
print(inner_code)
-- Output: (arg1, function(arg2) print(arg2) end)
```

- **Frontier Patterns (`%f[set]`)**: Ini adalah _zero-width assertion_, artinya ia tidak "memakan" karakter apa pun, tetapi mencocokkan posisi di antara karakter. `%f[set]` mencocokkan posisi di mana karakter sebelumnya tidak ada di dalam `set`, dan karakter berikutnya ada di dalam `set`. Ini sangat berguna untuk menemukan batasan kata (word boundaries).

**Contoh Frontier Pattern:**

```lua
local text = "the cat is on the mat"

-- Mencetak setiap kata di baris baru
-- %f[%w] cocok dengan posisi sebelum 't', 'c', 'i', 'o', 't', 'm'
-- %w+ mencocokkan kata itu sendiri
for word in string.gmatch(text, "%f[%w]%w+") do
  print(word)
end
-- Output:
-- the
-- cat
-- is
-- on
-- the
-- mat
```

### 1.4 Pattern Internals dan Optimizations

Memahami sedikit tentang cara kerja mesin pattern di balik layar dapat membantu Anda menulis pattern yang lebih efisien.

- **Lua Pattern Engine Internals**: Mesin pattern matching Lua diimplementasikan dalam file `lstrlib.c` di source code Lua. Ini bukan mesin NFA/DFA seperti Regex modern, melainkan menggunakan pendekatan _recursive descent_. Ini berarti fungsi matching memanggil dirinya sendiri secara rekursif untuk menangani sub-pattern.
- **Implikasi Performa**:
  - Untuk pattern sederhana, pendekatan ini sangat cepat.
  - Untuk pattern yang melibatkan banyak _backtracking_ (misalnya, quantifier serakah yang kompleks), performanya bisa menurun karena setiap kegagalan akan menyebabkan mesin "mundur" dan mencoba jalur lain.
- **Pattern Compilation dan Caching**: Penting untuk diketahui bahwa Lua **tidak** melakukan "kompilasi" atau "caching" pattern. Setiap kali Anda memanggil `string.match(str, pat)`, string `pat` akan di-parse dari awal.
  - **Optimisasi**: Jika Anda menggunakan pattern yang sama dan kompleks berulang kali di dalam loop yang ketat, performa bisa sedikit terpengaruh. Dalam kasus seperti ini, menggunakan library eksternal seperti **LPeg** (yang akan kita bahas di Bagian IV) menjadi solusi yang jauh lebih baik, karena LPeg mengkompilasi pattern menjadi bytecode untuk eksekusi yang sangat cepat.

---

Dengan menguasai fondasi di Bagian I ini, Anda telah memahami filosofi, sintaks dasar, dan mekanisme inti dari pattern matching di Lua. Anda sekarang siap untuk membangun di atas fondasi ini dan mempelajari teknik yang lebih kuat seperti _captures_ dan konstruksi pattern yang kompleks di bagian selanjutnya.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
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
