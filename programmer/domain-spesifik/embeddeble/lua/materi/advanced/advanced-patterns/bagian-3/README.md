Setelah kita memahami cara menemukan (`match`) dan mengekstrak (`capture`) data, sekarang kita akan masuk ke inti dari manipulasi string: mengubah, mengganti, dan membersihkan teks secara dinamis menggunakan pattern. Ini adalah bagian di mana Anda benar-benar mulai "memahat" data.

---

### Daftar Isi (Bagian III)

- [**BAGIAN III: STRING MANIPULATION PATTERNS**](#bagian-iii-string-manipulation-patterns)
  - [3.1 String Substitution - Master Level](#31-string-substitution---master-level)
  - [3.2 Advanced String Parsing](#32-advanced-string-parsing)
  - [3.3 Text Processing Algorithms](#33-text-processing-algorithms)
  - [3.4 Unicode dan Internationalization](#34-unicode-dan-internationalization)

---

## **[BAGIAN III: STRING MANIPULATION PATTERNS][0]**

Fokus utama di bagian ini adalah fungsi `string.gsub`. Jika `string.match` adalah mata Anda untuk melihat data, `string.gsub` adalah tangan Anda untuk mengubahnya.

### 3.1 String Substitution - Master Level

Ini adalah tingkat tertinggi penggunaan `string.gsub`. Kita tidak hanya akan mengganti teks dengan teks lain, tetapi kita akan menggantinya dengan hasil dari sebuah fungsi.

- **`gsub` dengan Function Callbacks**

  - **Konsep**: Argumen ketiga dari `string.gsub` bisa berupa sebuah fungsi. Untuk setiap kecocokan yang ditemukan, Lua akan memanggil fungsi ini. Argumen yang dikirim ke fungsi adalah semua _captures_ dari kecocokan tersebut. Nilai yang dikembalikan (return value) oleh fungsi inilah yang akan digunakan sebagai pengganti teks yang cocok. Ini membuka kemungkinan tak terbatas untuk transformasi dinamis.
  - **Sintaks**: `string.gsub(teks, "(pattern_tangkap)", function(capture1, capture2, ...) ... return nilai_pengganti end)`

- **Conditional Replacements (Penggantian Bersyarat)**

  - **Konsep**: Di dalam fungsi callback, Anda bisa menulis logika `if-then-else` untuk memutuskan apa nilai penggantinya berdasarkan nilai yang ditangkap.

  **Contoh: Substitusi Variabel dari Tabel**

  ```lua
  local vars = {
    user = "Alex",
    item = "Buku Lua",
    price = 50000
  }

  local template = "Halo ${user}, Anda membeli ${item} seharga ${price}. Item ${item_lain} tidak ada."

  local result = string.gsub(template, "%${(.-)}", function(var_name)
    -- var_name adalah hasil capture dari '(.-)'
    if vars[var_name] then
      return vars[var_name] -- Kembalikan nilai jika ada di tabel
    else
      return "N/A" -- Kembalikan nilai default jika tidak ada
    end
  end)

  print(result)
  -- Output: Halo Alex, Anda membeli Buku Lua seharga 50000. Item N/A tidak ada.
  ```

- **Template-based Substitutions dan Multi-stage Transformations**

  - **Konsep**: Contoh di atas adalah bentuk dari _template engine_ sederhana. Fungsi callback dapat melakukan lebih dari sekadar pencarian di tabel; ia bisa melakukan perhitungan matematika, memformat tanggal, atau bahkan memanggil fungsi lain sebelum mengembalikan hasil.

  **Contoh: Perhitungan dalam String**

  ```lua
  local text = "Harga: 100, Diskon: 15%"

  -- Menghitung harga setelah diskon
  local final_text = string.gsub(text, "Harga: (%d+), Diskon: (%d+)%%", function(harga, diskon)
    harga = tonumber(harga)
    diskon = tonumber(diskon)
    local harga_final = harga - (harga * diskon / 100)
    return "Harga Final: " .. harga_final
  end)

  print(final_text) -- Output: Harga Final: 85
  ```

### 3.2 Advanced String Parsing

Di sini kita menerapkan pattern untuk memecah dan memahami format data yang kompleks dan umum ditemui.

- **Tokenization dengan Delimiters Kompleks**

  - **Konsep**: Tokenization adalah proses memecah string menjadi bagian-bagian bermakna (token). `string.gmatch` sangat cocok untuk ini, terutama ketika pemisahnya (delimiter) tidak konsisten.
  - **Contoh**: Memecah string yang dipisahkan oleh koma atau titik koma, dengan spasi yang tidak menentu.

  <!-- end list -->

  ```lua
  local text = "apple, banana ; cherry  , durian"

  -- Mencocokkan serangkaian karakter yang bukan pemisah
  for token in string.gmatch(text, "[^,;%s]+") do
      print("Token:", token)
  end
  -- Output:
  -- Token: apple
  -- Token: banana
  -- Token: cherry
  -- Token: durian
  ```

- **Log File Analysis Patterns**

  - **Konsep**: Log server seringkali memiliki format yang terstruktur dan berulang, menjadikannya kandidat sempurna untuk parsing dengan `gmatch`.

  **Contoh: Parsing Log Nginx Sederhana**

  ```lua
  local log_line = '127.0.0.1 - - [12/Jun/2025:10:30:00 +0700] "GET /index.html HTTP/1.1" 200 1234'

  -- Pattern untuk menangkap IP, metode, URL, dan status code
  local pattern = '(%S+)%s.-%s.-%s%[.-%]%s"(%S+)%s(%S+)%s.-"%s(%d+)'

  local ip, method, url, status = string.match(log_line, pattern)

  print("IP:", ip)          -- Output: IP: 127.0.0.1
  print("Method:", method)  -- Output: Method: GET
  print("URL:", url)        -- Output: URL: /index.html
  print("Status:", status)  -- Output: Status: 200
  ```

- **Parsing File Konfigurasi atau Data Terstruktur (CSV, INI)**

  - **Konsep**: Banyak format data sederhana seperti file `.ini` atau CSV dapat di-parse menggunakan pattern. Namun, untuk format yang lebih kompleks (misalnya CSV dengan kutipan dan newline di dalamnya), pattern bisa menjadi sangat rumit, dan library khusus mungkin lebih baik.

  **Contoh: Parsing File INI Sederhana**

  ```lua
  local ini_content = [[
  ; user settings
  [user]
  name = Budi
  email = budi@example.com

  [database]
  host = localhost
  ]]

  local config = {}
  local current_section
  for line in string.gmatch(ini_content, "[^\n]+") do
      -- Menangkap nama section, misal: [user]
      local section = string.match(line, "%[(.+)%]")
      -- Menangkap key = value
      local key, value = string.match(line, "(%S+)%s*=%s*(.+)")

      if section then
          current_section = section
          config[current_section] = {}
      elseif key and value and current_section then
          config[current_section][key] = value
      end
  end

  print(config.user.name) -- Output: Budi
  ```

### 3.3 Text Processing Algorithms

Ini adalah aplikasi pattern untuk tugas-tugas pengolahan teks yang umum.

- **Pattern-based Validators**

  - **Konsep**: Membuat fungsi yang memeriksa apakah sebuah string cocok dengan format tertentu, seperti email atau URL. Fungsi ini biasanya mengembalikan `true` atau `false`.

  <!-- end list -->

  ```lua
  function isValidEmail(email)
    -- Ini adalah pattern yang sangat disederhanakan, pattern email yang sebenarnya sangat kompleks
    return string.match(email, "^[%w_%.%+-]+@[%w_%.%-]+%.[%a]+$") ~= nil
  end

  print(isValidEmail("test@example.com")) -- Output: true
  print(isValidEmail("test@.com"))      -- Output: false
  ```

- **Content Extraction dan Sanitization**

  - **Konsep**: Mengekstrak informasi yang berguna dari teks atau membersihkan data dari elemen yang tidak diinginkan/berbahaya (misalnya, tag HTML dari input pengguna).
  - **Contoh**: Menghapus semua tag HTML.

  <!-- end list -->

  ```lua
  local user_input = "<p>Ini <strong>penting</strong>!</p><script>alert('xss')</script>"

  -- Menghapus semua tag yang berbentuk <...>
  local sanitized_input = string.gsub(user_input, "<.->", "")

  print(sanitized_input) -- Output: Ini penting!
  ```

### 3.4 Unicode dan Internationalization

Ini adalah topik krusial saat bekerja dengan teks dalam bahasa apa pun selain bahasa Inggris dasar.

- **Masalah dengan UTF-8**

  - **Konsep**: Fungsi-fungsi string standar Lua beroperasi pada **byte**, bukan **karakter**. Dalam encoding UTF-8, satu karakter (misalnya, `é`, `ä`, `字`) bisa terdiri dari beberapa byte. Ini menyebabkan masalah:
    - `string.len("é")` akan mengembalikan `2`, bukan `1`.
    - `string.sub("cão", 1, 1)` akan mengembalikan `c`, tapi `string.sub("cão", 2, 2)` akan merusak karakter `ã`.
    - Pattern seperti `.` mencocokkan satu byte, bukan satu karakter.

- **Solusi: Library `utf8` (Lua 5.3+)**

  - **Konsep**: Lua 5.3 dan yang lebih baru menyertakan library standar `utf8` untuk menangani masalah ini.
  - **Fungsi Kunci**:
    - `utf8.len(s)`: Mengembalikan jumlah karakter (bukan byte).
    - `utf8.charpattern`: Sebuah string pattern yang cocok dengan tepat satu karakter UTF-8. Ini adalah alat utama untuk membuat `gmatch` dan `gsub` sadar akan UTF-8.

  **Contoh Penggunaan `utf8` library**

  ```lua
  local text_utf8 = "Olá, mundo!" -- 'á' adalah karakter multi-byte

  -- Salah (menggunakan library string standar)
  print("Panjang byte:", string.len(text_utf8)) -- Output: Panjang byte: 12

  -- Benar (menggunakan library utf8)
  print("Panjang karakter:", utf8.len(text_utf8)) -- Output: Panjang karakter: 11

  -- Mengiterasi setiap karakter menggunakan utf8.charpattern
  for char in string.gmatch(text_utf8, utf8.charpattern) do
      io.write(char, " ")
  end
  -- Output: O l á ,   m u n d o !
  ```

---

Dengan menguasai manipulasi string, Anda telah melengkapi trio keterampilan inti: menemukan, mengekstrak, dan sekarang, mengubah. Anda dapat membersihkan input, mem-parse format data, dan bahkan menangani teks internasional. Namun, ada kalanya pattern bawaan Lua mencapai batasnya, terutama saat menghadapi struktur yang sangat kompleks atau rekursif. Untuk itu, kita perlu alat yang lebih kuat, yang akan kita jelajahi di bagian selanjutnya: **LPeg**.

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

[0]: ../README.md#bagian-iii-string-manipulation-patterns
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
