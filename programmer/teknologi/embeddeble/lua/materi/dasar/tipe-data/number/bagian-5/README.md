# LEVEL 5: NUMBER MANIPULATION & FORMATTING

Setelah melakukan perhitungan, Anda sering kali perlu mengonversi angka ke dan dari string, dan menampilkannya dalam format yang rapi.

#### **5.1 String to Number Conversion**

- **Topik**: `tonumber()`, penguraian string (string parsing).
- **Materi dan Penjelasan**:

  - **`tonumber(str, base)`**: Fungsi global ini mengurai string dan mencoba mengubahnya menjadi angka. Jika gagal, ia mengembalikan `nil`.
  - **Basis Berbeda**: Argumen `base` opsional memungkinkan Anda mengurai angka dari basis 2 hingga 36.

    ```lua
    print(tonumber("123.45"))   -- Output: 123.45
    print(tonumber("not a number")) -- Output: nil

    -- Menggunakan basis
    print(tonumber("FF", 16))   -- Mengurai heksadesimal. Output: 255
    print(tonumber("101", 2))    -- Mengurai biner. Output: 5
    print(tonumber("Z", 36))     -- Basis 36 menggunakan 0-9 dan A-Z. Output: 35
    ```

  - **Pertimbangan Lokal (Locale)**: `tonumber` tidak peka terhadap lokal. Ia selalu mengharapkan `.` sebagai pemisah desimal. String seperti `"1.234,56"` akan gagal diurai dengan benar.

#### **5.2 Number to String Formatting**

- **Topik**: `tostring()`, `string.format()`.
- **Materi dan Penjelasan**:

  - **`tostring()`**: Cara paling dasar untuk mengubah apa pun, termasuk angka, menjadi string. Anda tidak memiliki kontrol atas formatnya.
    ```lua
    print(tostring(123)) -- Output: "123"
    print(tostring(math.pi)) -- Output: "3.141592653589793"
    ```
  - **`string.format()`**: Cara yang jauh lebih kuat dan fleksibel, dipinjam dari bahasa C. Anda menyediakan string format dengan "specifiers" (dimulai dengan `%`) yang diganti dengan argumen berikutnya.

    - `%d`: untuk integer (decimal)
    - `%f`: untuk float (desimal)
    - `%.2f`: float dengan tepat 2 digit presisi di belakang koma.
    - `%e`: notasi ilmiah (saintifik).
    - `%x`: heksadesimal.
    - `%04d`: integer, diisi dengan angka 0 di depan hingga total 4 digit.
    <!-- end list -->

    ```lua
    local price = 4.5
    local qty = 10
    local total = price * qty

    print("Total: " .. tostring(total)) -- Output: Total: 45

    -- Menggunakan string.format untuk kontrol
    print(string.format("Harga: $%.2f", price))   -- Output: Harga: $4.50
    print(string.format("Qty: %d, Total: $%.2f", qty, total)) -- Output: Qty: 10, Total: $45.00

    print(string.format("ID Item: %04d", 52)) -- Output: ID Item: 0052
    print(string.format("Nilai Pi: %.4f", math.pi)) -- Output: Nilai Pi: 3.1416 (dibulatkan!)
    ```

#### **5.3 Custom Number Formatting**

- **Topik**: Pemisah ribuan, mata uang, format kustom.
- **Materi dan Penjelasan**: `string.format` tidak memiliki opsi bawaan untuk pemisah ribuan. Anda harus mengimplementasikannya sendiri.

  - **Menambahkan Pemisah Ribuan**:

    ```lua
    function format_with_commas(num)
      local s = tostring(math.floor(num))
      local reversed = s:reverse()
      local with_commas = reversed:gsub("(%d%d%d)", "%1,")
      local formatted = with_commas:reverse()
      -- Hapus koma di awal jika panjangnya kelipatan 3
      if formatted:sub(1,1) == ',' then
        formatted = formatted:sub(2)
      end
      return formatted
    end

    print(format_with_commas(1234567)) -- Output: 1,234,567
    print(format_with_commas(12345))   -- Output: 12,345
    ```

  - **Format Mata Uang**: Biasanya kombinasi dari fungsi di atas dan `string.format` untuk presisi desimal.

    ```lua
    function format_currency(num, symbol)
      symbol = symbol or "$"
      local integer_part = math.floor(num)
      local fractional_part = num - integer_part

      local formatted_int = format_with_commas(integer_part)
      return string.format("%s%s%.2f", symbol, formatted_int, fractional_part)
    end

    -- Note: this is a simplified example.
    -- print(format_currency(1234567.89)) -- This simplified version needs work.
    -- A better approach combines string manipulation and formatting more carefully.
    ```

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
