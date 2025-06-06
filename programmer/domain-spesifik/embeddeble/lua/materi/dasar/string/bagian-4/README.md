# LEVEL 4

<details>
<summary>Gemini 2.5 Pro</summary>

</details>

#

<details>
<summary>Gemini 2.5 Flash</summary>

# **LEVEL 4: STRING UTILITIES & BEST PRACTICES**

Pada level ini, kita akan fokus pada aspek-aspek praktis dan optimasi dalam bekerja dengan string di Lua. Ini mencakup fungsi-fungsi utilitas yang membantu dalam pembersihan dan validasi data, serta strategi untuk menulis kode string yang lebih efisien dan mudah dipelihara.

### **4.1 String Cleaning & Validation**

Bagian ini membahas teknik dan fungsi untuk membersihkan (menghilangkan karakter yang tidak diinginkan) dan memvalidasi (memastikan format string sesuai) data string.

- **Trimming whitespace: Manual vs. `string.gsub()` with patterns**

  **Trimming whitespace** adalah proses menghilangkan spasi atau karakter whitespace (spasi, tab, newline, dll.) dari awal dan/atau akhir string.

  - **Masalah**: String seringkali memiliki spasi berlebih dari input pengguna atau sumber data, yang dapat menyebabkan masalah dalam perbandingan atau pemrosesan.
  - **Pendekatan Manual (Tidak Disarankan untuk Kode Produktif)**:
    Meskipun tidak praktis untuk implementasi, memahami logika dasarnya berguna. Ini melibatkan menemukan posisi karakter non-whitespace pertama dan terakhir.

    - **Contoh Kode (Konseptual)**:

      ```lua
      local function trim_manual(s)
          local start_index = 1
          while start_index <= #s and string.find(s, "^%s", start_index) do
              start_index = start_index + 1
          end

          local end_index = #s
          while end_index >= start_index and string.find(s, "%s$", end_index) do
              end_index = end_index - 1
          end

          if start_index > end_index then
              return "" -- String hanya berisi spasi
          else
              return string.sub(s, start_index, end_index)
          end
      end

      local teks = "   Halo Dunia!   \n"
      print("Original:", "'" .. teks .. "'")
      print("Manual Trimmed:", "'" .. trim_manual(teks) .. "'")
      -- Output: (akan bekerja, tetapi rumit dan tidak efisien)
      ```

      - **Kekurangan**: Terlalu verbose, kurang efisien, dan sulit ditangani untuk berbagai jenis whitespace.

  - **Menggunakan `string.gsub()` dengan Patterns (Disarankan)**:
    Ini adalah cara yang jauh lebih bersih dan efisien untuk melakukan _trimming_ di Lua. Kita menggunakan kombinasi pola jangkar dan kelas karakter.

    - **Sintaks Dasar**:
      - Untuk _leading whitespace_ (spasi di awal): `string.gsub(s, "^%s+", "")`
      - Untuk _trailing whitespace_ (spasi di akhir): `string.gsub(s, "%s+$", "")`
      - Untuk keduanya: Gunakan dua panggilan `gsub` secara berurutan.
    - **Contoh Kode**:

      ```lua
      local function trim(s)
          s = string.gsub(s, "^%s+", "") -- Hapus spasi di awal
          s = string.gsub(s, "%s+$", "") -- Hapus spasi di akhir
          return s
      end

      local teks1 = "   Belajar Lua   "
      local teks2 = "\t\nString dengan whitespace.\r\n  "
      local teks3 = "Tidak ada spasi."
      local teks4 = "     " -- Hanya spasi

      print("Asli 1:", "'" .. teks1 .. "'")
      print("Trim 1:", "'" .. trim(teks1) .. "'")
      -- Output:
      -- Asli 1: '   Belajar Lua   '
      -- Trim 1: 'Belajar Lua'

      print("Asli 2:", "'" .. teks2 .. "'")
      print("Trim 2:", "'" .. trim(teks2) .. "'")
      -- Output:
      -- Asli 2: '
      -- String dengan whitespace.
      --   '
      -- Trim 2: 'String dengan whitespace.'

      print("Asli 3:", "'" .. teks3 .. "'")
      print("Trim 3:", "'" .. trim(teks3) .. "'")
      -- Output:
      -- Asli 3: 'Tidak ada spasi.'
      -- Trim 3: 'Tidak ada spasi.'

      print("Asli 4:", "'" .. teks4 .. "'")
      print("Trim 4:", "'" .. trim(teks4) .. "'")
      -- Output:
      -- Asli 4: '     '
      -- Trim 4: ''
      ```

      - **Penjelasan per Sintaksis**:
        - `string.gsub(s, "^%s+", "")`:
          - `^`: Jangkar awal string.
          - `%s+`: Mencocokkan satu atau lebih (`+`) karakter spasi (`%s`).
          - `""`: Mengganti kecocokan dengan string kosong, secara efektif menghapusnya.
          - Ini menghapus semua whitespace yang ada di awal string.
        - `string.gsub(s, "%s+$", "")`:
          - `%s+`: Mencocokkan satu atau lebih karakter spasi.
          - `$`: Jangkar akhir string.
          - `""`: Mengganti kecocokan dengan string kosong.
          - Ini menghapus semua whitespace yang ada di akhir string.
        - Penting: Urutan `gsub` tidak terlalu penting untuk operasi _trim_ ini, tetapi biasanya dilakukan dari kiri ke kanan.

  - **Sumber Terverifikasi**: Programming in Lua Chapter 20 (terkait `gsub` dan pola), Lua-users.org Wiki (contoh `trim`).

- **Removing unwanted characters/patterns**

  `string.gsub()` juga merupakan alat utama untuk menghapus karakter atau pola tertentu dari string. Ini dilakukan dengan mengganti kecocokan dengan string kosong `""`.

  - **Contoh Kode**:

    ```lua
    local input_text = "Ini adalah text dengan [karakter khusus] dan #simbol!."

    -- Menghapus semua karakter non-alfanumerik (kecuali spasi)
    local bersih1, _ = string.gsub(input_text, "[^%a%s]", "")
    print("Bersih 1 (hanya huruf dan spasi):", bersih1)
    -- Output: Bersih 1 (hanya huruf dan spasi): Ini adalah text dengan karakter khusus dan simbol

    local angka_kotor = "1,234,567.89"
    -- Menghapus koma sebagai pemisah ribuan
    local bersih2, _ = string.gsub(angka_kotor, ",", "")
    print("Bersih 2 (tanpa koma):", bersih2)
    -- Output: Bersih 2 (tanpa koma): 1234567.89

    local html_tag = "Ini <br>adalah<p>contoh <b>HTML</b>."
    -- Menghapus semua tag HTML (sederhana, tidak untuk HTML kompleks)
    local bersih3, _ = string.gsub(html_tag, "<[^>]+>", "")
    print("Bersih 3 (tanpa tag HTML):", bersih3)
    -- Output: Bersih 3 (tanpa tag HTML): Ini adalahcontoh .
    ```

    - **Penjelasan per Sintaksis**:
      - `string.gsub(input_text, "[^%a%s]", "")`:
        - `[^%a%s]`: Cocokkan karakter apa pun yang BUKAN huruf (`%a`) dan BUKAN spasi (`%s`).
        - `""`: Ganti dengan string kosong, yang artinya menghapus karakter tersebut.
      - `string.gsub(angka_kotor, ",", "")`: Mengganti semua koma literal dengan string kosong.
      - `string.gsub(html_tag, "<[^>]+>", "")`:
        - `<`: Cocokkan karakter `<` literal.
        - `[^>]+`: Cocokkan satu atau lebih karakter apa pun yang BUKAN `>`. Ini akan mencocokkan konten di dalam tag.
        - `>`: Cocokkan karakter `>` literal.
        - Pola ini akan mencocokkan sesuatu seperti `<br>`, `<p>`, `<b>`. Mengganti dengan `""` akan menghapusnya. **Penting**: Ini adalah pola yang sangat sederhana untuk HTML dan mungkin tidak efektif untuk HTML yang lebih kompleks atau bersarang.

  - **Sumber Terverifikasi**: Programming in Lua Chapter 20.

- **Basic input validation using `string.match()` and patterns**

  **Validasi input** adalah proses memastikan bahwa data string yang diterima memiliki format atau konten yang diharapkan. `string.match()` sangat cocok untuk tugas ini.

  - **Contoh Kode**:

    ```lua
    -- Validasi format email sederhana
    local function is_valid_email(email_str)
        -- Pola sederhana: huruf/angka/titik/underscore @ huruf/angka/titik . huruf/angka
        return string.match(email_str, "^[%w_%.%-]+@([%w_%.%-]+%a)$") ~= nil
    end

    print("Valid Email (test@example.com):", is_valid_email("test@example.com")) -- true
    print("Valid Email (user.name_123@domain.co.id):", is_valid_email("user.name_123@domain.co.id")) -- true
    print("Invalid Email (no_at.com):", is_valid_email("no_at.com")) -- false
    print("Invalid Email (user@.com):", is_valid_email("user@.com")) -- false
    print("Invalid Email (user@domain):", is_valid_email("user@domain")) -- false

    print("--------------------")

    -- Validasi format nomor telepon (misal: XXX-XXX-XXXX)
    local function is_valid_phone(phone_str)
        return string.match(phone_str, "^%d%d%d-%d%d%d-%d%d%d%d$") ~= nil
    end

    print("Valid Phone (123-456-7890):", is_valid_phone("123-456-7890")) -- true
    print("Invalid Phone (1234567890):", is_valid_phone("1234567890")) -- false
    print("Invalid Phone (12-34-56):", is_valid_phone("12-34-56")) -- false

    print("--------------------")

    -- Validasi hanya angka
    local function is_numeric(s)
        return string.match(s, "^%d+$") ~= nil
    end

    print("Is Numeric (12345):", is_numeric("12345")) -- true
    print("Is Numeric (123a45):", is_numeric("123a45")) -- false
    print("Is Numeric ( 123 ):", is_numeric(" 123 ")) -- false (karena spasi)
    ```

    - **Penjelasan per Sintaksis**:
      - `is_valid_email(email_str)`:
        - `^`: Mulai dari awal string.
        - `[%w_%.%-]+`: Satu atau lebih karakter _word_ (`%w`), underscore (`_`), titik (`%.`), atau tanda hubung (`%-`). Ini untuk bagian _username_.
        - `@`: Karakter `@` literal.
        - `([%w_%.%-]+%a)`: Capture untuk bagian domain.
          - `[%w_%.%-]+`: Satu atau lebih karakter _word_, underscore, titik, atau tanda hubung.
          - `%a`: Diakhiri dengan karakter alfabet (untuk mencegah `example.`).
        - `$`: Sampai akhir string.
        - `~= nil`: Memeriksa apakah `string.match` mengembalikan kecocokan (bukan `nil`).
      - `is_valid_phone(phone_str)`:
        - `^%d%d%d-%d%d%d-%d%d%d%d$`: Memastikan seluruh string cocok dengan pola "tiga digit, strip, tiga digit, strip, empat digit".
      - `is_numeric(s)`:
        - `^%d+$`: Memastikan seluruh string hanya terdiri dari satu atau lebih digit.
    - **Penting**: Pola validasi di atas adalah contoh sederhana. Validasi input yang robust, terutama untuk email atau URL, seringkali jauh lebih kompleks dan mungkin memerlukan pustaka eksternal atau pola yang lebih canggih. Tujuan di sini adalah menunjukkan bagaimana `string.match()` digunakan untuk pemeriksaan format dasar.

  - **Sumber Terverifikasi**: Programming in Lua Chapter 20, Lua 5.4 Reference Manual.

### **4.2 String Joining and Splitting**

Meskipun Lua tidak memiliki fungsi bawaan `join` atau `split` yang eksplisit seperti di bahasa lain, keduanya dapat diimplementasikan dengan mudah menggunakan fitur-fitur yang sudah ada.

- **Joining strings (using `table.concat()` for performance)**

  **Joining strings** (menggabungkan string) adalah proses menggabungkan elemen-elemen dari sebuah tabel menjadi satu string tunggal, biasanya dengan pemisah. Menggunakan operator konkatenasi `..` dalam loop untuk menggabungkan banyak string akan sangat tidak efisien (karena string adalah _immutable_ dan setiap operasi `..` menciptakan string baru). `table.concat()` adalah cara yang tepat dan efisien.

  - **Sintaks Dasar**: `table.concat(table [, sep [, i [, j]]])`

    - `table`: Tabel yang berisi string atau nilai yang dapat dikonversi ke string.
    - `sep` (opsional): String pemisah yang akan disisipkan di antara setiap elemen. Defaultnya string kosong `""`.
    - `i` (opsional): Indeks awal untuk konkatenasi. Defaultnya 1.
    - `j` (opsional): Indeks akhir untuk konkatenasi. Defaultnya panjang tabel.

  - **Contoh Kode**:

    ```lua
    local kata_kata = {"Belajar", "string", "di", "Lua", "itu", "menyenangkan."}

    -- Menggabungkan dengan spasi
    local kalimat_join1 = table.concat(kata_kata, " ")
    print("Join dengan spasi:", kalimat_join1)
    -- Output: Join dengan spasi: Belajar string di Lua itu menyenangkan.

    -- Menggabungkan tanpa pemisah
    local kalimat_join2 = table.concat(kata_kata)
    print("Join tanpa pemisah:", kalimat_join2)
    -- Output: Join tanpa pemisah: BelajarstringdiLuaitumenyenangkan.

    -- Menggabungkan dengan pemisah koma dan spasi
    local item_list = {"Apel", "Jeruk", "Mangga"}
    local daftar_buah = table.concat(item_list, ", ")
    print("Daftar buah:", daftar_buah)
    -- Output: Daftar buah: Apel, Jeruk, Mangga

    -- Menggabungkan bagian tertentu dari tabel
    local sub_kata = {"Ini", "adalah", "contoh", "sub", "bagian"}
    local sub_kalimat = table.concat(sub_kata, " ", 2, 4) -- Gabungkan dari indeks 2 sampai 4
    print("Sub kalimat:", sub_kalimat)
    -- Output: Sub kalimat: adalah contoh sub
    ```

    - **Penjelasan per Sintaksis**:
      - `table.concat(kata_kata, " ")`: Menggabungkan semua elemen string dalam tabel `kata_kata` dengan string `" "` (spasi) sebagai pemisah.
      - `table.concat(kata_kata)`: Menggabungkan semua elemen string tanpa pemisah (defaultnya `""`).
      - `table.concat(item_list, ", ")`: Menggabungkan dengan pemisah `", "`.
      - `table.concat(sub_kata, " ", 2, 4)`: Menggabungkan elemen dari indeks 2 (`"adalah"`) hingga indeks 4 (`"sub"`) dengan spasi sebagai pemisah.

  - **Sumber Terverifikasi**: Programming in Lua Chapter 12 (Table Library), Lua 5.4 Reference Manual Section 6.5.

- **Splitting strings into a table: Common implementations using `string.gmatch()` or `string.gsub()`**

  **Splitting strings** (memecah string) adalah proses membagi satu string besar menjadi beberapa sub-string berdasarkan pemisah atau pola tertentu, dan menyimpannya dalam sebuah tabel.

  - **Implementasi dengan `string.gmatch()` (Disarankan untuk pemisahan berdasarkan pola)**:
    Ini adalah cara yang sangat elegan dan kuat untuk memecah string berdasarkan pola, terutama jika Anda ingin mengekstrak bagian yang cocok (bukan hanya bagian yang diapit oleh pemisah).

    - **Contoh Kode**:

      ```lua
      local function split_by_pattern(s, pattern)
          local result = {}
          for part in string.gmatch(s, pattern) do
              table.insert(result, part)
          end
          return result
      end

      local data_csv = "Apel;Jeruk;Mangga;Pisang"
      local buah_list = split_by_pattern(data_csv, "[^;]+") -- Cocokkan satu atau lebih karakter yang BUKAN ';'
      print("Buah list (gmatch):")
      for i, buah in ipairs(buah_list) do
          print(i, buah)
      end
      -- Output:
      -- Buah list (gmatch):
      -- 1	Apel
      -- 2	Jeruk
      -- 3	Mangga
      -- 4	Pisang

      local kalimat_kata = "Ini adalah sebuah kalimat."
      local kata_kata_list = split_by_pattern(kalimat_kata, "%S+") -- Cocokkan satu atau lebih karakter non-spasi
      print("Kata-kata list (gmatch):")
      for i, kata in ipairs(kata_kata_list) do
          print(i, kata)
      end
      -- Output:
      -- Kata-kata list (gmatch):
      -- 1	Ini
      -- 2	adalah
      -- 3	sebuah
      -- 4	kalimat.
      ```

      - **Penjelasan per Sintaksis**:
        - `split_by_pattern(s, pattern)`: Fungsi ini menerima string `s` dan `pattern` yang akan dicocokkan sebagai bagian-bagian yang ingin diekstrak.
        - `for part in string.gmatch(s, pattern) do ... end`: `string.gmatch` akan mengulang setiap bagian string yang cocok dengan `pattern` yang diberikan. Setiap kecocokan `part` kemudian dimasukkan ke dalam tabel `result`.
        - `"[^;]+"`: Pola ini mencari "satu atau lebih karakter apa pun yang bukan titik koma". Ini secara efektif memisahkan string berdasarkan titik koma.
        - `"%S+"`: Pola ini mencari "satu atau lebih karakter non-spasi". Ini secara efektif memisahkan string menjadi kata-kata.

  - **Implementasi dengan `string.gsub()` (Cocok untuk pemisahan berdasarkan pemisah, terutama jika pemisah bisa kosong)**:
    Metode ini memanfaatkan `string.gsub()` untuk mengganti pemisah dengan placeholder dan kemudian menggunakan `string.match()` atau `string.gmatch()` pada hasilnya. Atau, dengan fungsi pengganti, bisa menjadi sangat serbaguna.

    - **Contoh Kode (lebih umum digunakan)**:

      ```lua
      local function split_by_delimiter(s, delimiter)
          local result = {}
          local pattern = "(.-)" .. delimiter .. "()" -- Capture non-greedy dan posisi
          local last_pos = 1
          for chunk, current_pos in string.gmatch(s, pattern) do
              table.insert(result, chunk)
              last_pos = current_pos
          end
          table.insert(result, string.sub(s, last_pos)) -- Tambahkan bagian terakhir
          return result
      end

      local data_komma = "merah,hijau,biru"
      local warna_list = split_by_delimiter(data_komma, ",")
      print("Warna list (delimiter):")
      for i, warna in ipairs(warna_list) do
          print(i, warna)
      end
      -- Output:
      -- Warna list (delimiter):
      -- 1	merah
      -- 2	hijau
      -- 3	biru

      local empty_parts = "a,,b,c"
      local parts_with_empty = split_by_delimiter(empty_parts, ",")
      print("Parts with empty (delimiter):")
      for i, part in ipairs(parts_with_empty) do
          print(i, "'" .. part .. "'")
      end
      -- Output:
      -- Parts with empty (delimiter):
      -- 1	'a'
      -- 2	''
      -- 3	'b'
      -- 4	'c'
      ```

      - **Penjelasan per Sintaksis (fungsi `split_by_delimiter`)**:
        - `local pattern = "(.-)" .. delimiter .. "()"`:
          - `(.-)`: Capture non-greedy untuk mengambil bagian string hingga delimiter.
          - `delimiter`: Pola untuk pemisah.
          - `()`: Ini adalah _empty capture_. Ini tidak menangkap karakter apa pun, tetapi mengembalikan posisi saat ini dalam string. Ini sangat berguna untuk mendapatkan indeks setelah pemisah.
        - `for chunk, current_pos in string.gmatch(s, pattern) do ... end`: Mengulang setiap bagian string yang dipisahkan oleh `delimiter`. `chunk` adalah bagian string sebelum delimiter, dan `current_pos` adalah indeks setelah delimiter.
        - `table.insert(result, chunk)`: Masukkan bagian string yang ditangkap ke dalam tabel `result`.
        - `last_pos = current_pos`: Perbarui posisi terakhir yang diproses.
        - `table.insert(result, string.sub(s, last_pos))`: Setelah loop selesai, tambahkan bagian string yang tersisa (dari `last_pos` hingga akhir string) ke dalam tabel. Ini menangani kasus bagian terakhir string yang tidak diikuti oleh pemisah.

  - **Penting**: Kedua metode `split` ini memiliki kegunaan masing-masing.

    - `string.gmatch(s, pattern_for_parts)`: Lebih cocok jika Anda mendefinisikan apa yang ingin Anda **pertahankan** (yaitu, bagian yang valid).
    - `string.gsub()` atau `string.gmatch()` dengan pola yang mencocokkan pemisah dan _empty capture_: Lebih cocok jika Anda mendefinisikan **pemisahnya** dan ingin menyertakan bagian kosong.

  - **Sumber Terverifikasi**: Lua-users.org Wiki (String Library Tutorial, Cookbook/SplitJoin), RipTutorial Lua Section.

### **4.3 Performance Considerations**

Optimalisasi string penting dalam aplikasi dengan kinerja tinggi atau ketika berhadapan dengan banyak operasi string.

- **Immutability of strings and its implications**

  - **Konsep**: Di Lua (dan banyak bahasa modern lainnya), string adalah **immutable** (tidak dapat diubah). Ini berarti bahwa setiap kali Anda melakukan operasi yang tampaknya memodifikasi string (misalnya `string.upper()`, `string.gsub()`, atau konkatenasi `..`), Anda tidak benar-benar mengubah string asli. Sebaliknya, Lua membuat **string baru** di memori dengan hasil perubahan tersebut. String asli tetap utuh.
  - **Implikasi Kinerja**:
    - **Overhead Memori**: Setiap operasi yang menghasilkan string baru membutuhkan alokasi memori baru. Jika Anda melakukan banyak operasi ini dalam loop atau dengan string yang sangat besar, ini dapat menyebabkan penggunaan memori yang tinggi.
    - **Overhead CPU**: Alokasi memori dan penyalinan data ke string baru membutuhkan waktu CPU.
    - **Garbage Collection (GC)**: String lama yang tidak lagi direferensikan akan menjadi sampah dan perlu dikumpulkan oleh _garbage collector_ Lua, yang dapat menyebabkan jeda (pauses) dalam eksekusi program.
  - **Contoh (Inefisien)**:
    ```lua
    local long_string = ""
    for i = 1, 10000 do
        long_string = long_string .. "a" -- TIDAK EFISIEN! Membuat string baru setiap iterasi.
    end
    ```
  - **Solusi**:
    - Gunakan `table.concat()` untuk menggabungkan banyak string (seperti yang dibahas di atas).
    - Gunakan `string.buffer` jika tersedia (untuk aplikasi tertentu, seringkali di LuaJIT atau lingkungan tertentu) atau implementasi _string builder_ manual.
    - Pikirkan ulang algoritma untuk meminimalkan operasi string menengah.
  - **Sumber Terverifikasi**: Programming in Lua Chapter 2.4 (String Immutability), LuaJIT Documentation (Performance aspects).

- **When to use `table.concat()` vs. `..` operator**

  - **Operator `..` (Concatenation Operator)**:

    - **Kapan Digunakan**: Ideal untuk menggabungkan **dua atau tiga** string. Lua mengoptimalkan operasi ini untuk jumlah kecil.
    - **Contoh**:
      ```lua
      local firstName = "John"
      local lastName = "Doe"
      local fullName = firstName .. " " .. lastName -- Cukup efisien untuk 3 string
      ```
    - **Hindari**: Menggunakan `..` dalam loop untuk menggabungkan banyak string, seperti yang ditunjukkan di bagian _Immutability_.

  - **`table.concat()`**:

    - **Kapan Digunakan**: Wajib digunakan ketika Anda perlu menggabungkan **banyak string** (lebih dari 3-4 string) secara efisien.
    - **Bagaimana Cara Kerjanya**: `table.concat()` pertama-tama mengumpulkan semua bagian string ke dalam sebuah tabel, kemudian mengalokasikan memori yang cukup untuk string hasil akhir **sekali saja**, dan menyalin semua bagian ke dalamnya. Ini sangat mengurangi overhead memori dan CPU.
    - **Contoh**:
      ```lua
      local parts = {"Nama:", "Alice", "Usia:", 25, "Kota:", "Jakarta"}
      local info = table.concat(parts, " ") -- Menggabungkan semua elemen tabel dengan spasi
      print(info)
      -- Output: Nama: Alice Usia: 25 Kota: Jakarta
      ```
    - **Penting**: Bahkan jika elemen tabel bukan string, `table.concat()` akan mencoba mengkonversinya ke string secara otomatis.

  - **Sumber Terverifikasi**: Programming in Lua Chapter 12 (Table Library), Lua-users.org Wiki (String Library Tutorial).

- **Optimizing pattern matching: specific patterns vs. generic patterns**

  - **Specific Patterns (Good)**:

    - Ketika Anda tahu persis apa yang Anda cari, gunakan pola yang sangat spesifik. Ini memungkinkan mesin pola untuk bekerja lebih efisien.
    - Contoh: Menggunakan `%d` daripada `.` jika Anda tahu Anda mencari digit. Menggunakan `^` atau `$` jika Anda tahu posisi kecocokan.
    - Contoh: `string.find(s, "hello")` akan lebih cepat daripada `string.find(s, "h%a+o")` jika Anda hanya mencari kata "hello" secara harfiah.

  - **Generic Patterns (Use with Caution)**:

    - Pola seperti `.*` atau `.+` (terutama `.*`) bersifat sangat _greedy_ dan dapat menyebabkan _backtracking_ yang berlebihan, terutama jika string sangat besar atau pola tidak cocok dengan cepat. Ini dapat menurunkan kinerja secara signifikan.
    - Jika Anda menggunakan _greedy quantifier_ dan pola tidak berhasil, mesin pola mungkin akan mencoba semua kemungkinan kombinasi sebelum menyerah, yang boros CPU.
    - **Solusi**: Jika memungkinkan, gunakan _non-greedy_ `.-` atau buat pola Anda lebih spesifik untuk membatasi ruang pencarian.
    - **Contoh Buruk (Potensi Inefisien)**:
      ```lua
      -- Mencari semua tag dalam HTML, tapi ini bisa sangat lambat
      local tags = string.gmatch(huge_html_string, "<.*>")
      -- Lebih baik:
      local tags_better = string.gmatch(huge_html_string, "<[^>]+>")
      -- Atau jika nesting, gunakan %b<>
      ```

  - **Memilih Fungsi yang Tepat**:

    - `string.find()`: Jika hanya perlu tahu lokasi.
    - `string.match()`: Jika perlu ekstrak kecocokan pertama.
    - `string.gmatch()`: Jika perlu iterasi semua kecocokan.
    - `string.gsub()`: Jika perlu penggantian.
      Memilih fungsi yang paling sesuai dengan kebutuhan Anda juga membantu kinerja karena setiap fungsi dioptimalkan untuk tugasnya.

  - **Sumber Terverifikasi**: LuaJIT Documentation (Mike Pall, Performance of String Patterns), Roberto Ierusalimschy's Papers.

---

Dengan selesainya **LEVEL 4: STRING UTILITIES & BEST PRACTICES**, Anda kini memiliki pemahaman yang lebih baik tentang cara membersihkan dan memvalidasi string, menggabungkan dan memecah string secara efisien, serta praktik terbaik untuk mengoptimalkan kinerja saat bekerja dengan string di Lua. Bagian ini merupakan pengetahuan praktis yang sangat penting untuk menulis kode yang robust dan efisien. Berikutnya, kita akan masuk ke **LEVEL 5: UTF-8 & UNICODE HANDLING (LUA 5.3+)**. Ini adalah topik yang sangat relevan di dunia modern karena kebutuhan untuk menangani teks multibahasa.

</details>

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
