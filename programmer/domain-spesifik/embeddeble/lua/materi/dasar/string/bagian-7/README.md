<details>
<summary>Gemini 2.5 Pro</summary>

</details>

#

<details>
<summary>Gemini 2.5 Flash</summary>

Oke, selamat atas pencapaian Anda dalam menguasai **KURIKULUM LENGKAP STRING LUA (REVISI 2025)**! Anda telah menyelesaikan semua level dan memiliki pemahaman mendalam tentang manipulasi string di Lua.

Sekarang, mari kita lanjutkan ke bagian penting berikutnya: **PROYEK PRAKTIK**. Ini adalah kesempatan Anda untuk menerapkan semua teori dan konsep yang telah Anda pelajari dalam skenario dunia nyata.

---

## **PROYEK PRAKTIK: APLIKASI UTILITAS TEKS & PARSER SEDERHANA**

Proyek ini akan dibagi menjadi beberapa tugas yang saling terkait, memungkinkan Anda untuk membangun sebuah aplikasi utilitas teks yang fungsional dan parser sederhana. Setiap tugas akan memanfaatkan berbagai konsep yang telah Anda pelajari dari Level 1 hingga Level 6.

### **Tujuan Proyek:**

Membangun sebuah skrip Lua yang dapat:

1.  **Membersihkan dan memvalidasi** input teks.
2.  **Menganalisis** properti teks (jumlah kata, panjang, dll.).
3.  **Memproses data terstruktur** (misalnya, entri log sederhana).
4.  (Opsional, Tingkat Lanjut) **Mem-parse** format kustom atau ekspresi sederhana menggunakan LPEG.

### **Persiapan:**

- Pastikan Anda memiliki instalasi Lua 5.3+ (disarankan Lua 5.4).
- Instal LPEG jika Anda berencana untuk mengerjakan bagian tingkat lanjut: `luarocks install lpeg`

---

### **TUGAS 1: Text Cleaner & Analyzer**

Fokus pada Level 1, 2, 4, dan 5.

**Deskripsi:** Buat fungsi-fungsi untuk membersihkan teks dari spasi berlebih, karakter tidak diinginkan, dan kemudian menganalisis properti dasarnya.

**Fungsi yang Harus Dibuat:**

1.  **`function clean_text(input_string)`**

    - Tugas: Membersihkan string dari whitespace berlebih.
    - Persyaratan:
      - Hapus _leading_ dan _trailing_ whitespace. (Gunakan `string.gsub()` dengan pola.)
      - Ganti beberapa spasi berturut-turut di tengah string dengan satu spasi tunggal. (Gunakan `string.gsub()` dengan pola.)
      - Pertimbangkan UTF-8: Pastikan fungsi bekerja dengan baik untuk string yang mengandung karakter non-ASCII (misalnya, " Halo Dunia! ").

2.  **`function remove_non_alphanumeric(input_string)`**

    - Tugas: Menghapus semua karakter yang bukan huruf, angka, atau spasi.
    - Persyaratan:
      - Gunakan `string.gsub()` dengan pola untuk menghapus karakter yang tidak termasuk `%a`, `%d`, atau `%s`.
      - Pertimbangkan UTF-8: Pola Lua standar (`%a`, `%d`) hanya mencocokkan ASCII. Untuk penanganan yang benar-benar Unicode, Anda mungkin perlu mencatat keterbatasan di sini atau mengintegrasikan logika `utf8` secara manual jika Anda ingin menghapus simbol Unicode. Untuk tugas ini, fokus pada perilaku pola standar Lua.

3.  **`function analyze_text(text_string)`**
    - Tugas: Menganalisis properti dasar dari teks yang telah dibersihkan.
    - Persyaratan:
      - Hitung jumlah karakter. Gunakan `utf8.len()` untuk panjang karakter logis.
      - Hitung jumlah kata. Asumsikan kata dipisahkan oleh satu atau lebih spasi.
      - Hitung jumlah baris. (Asumsikan baris dipisahkan oleh `\n`).
      - Konversi teks ke _uppercase_ dan _lowercase_. Catat batasan `string.upper()`/`lower()` untuk non-ASCII.
    - Return value: Sebuah tabel yang berisi statistik (misalnya `{chars = N, words = M, lines = L, upper_text = "...", lower_text = "..."}`).

**Contoh Penggunaan & Pengujian:**

```lua
-- Contoh Penggunaan & Pengujian untuk Tugas 1
local input_raw = "   Ini adalah  sebuah    contoh teks   dengan  whitespace berlebih.\nBaris kedua.\n  Baris terakhir.  "
local input_unicode = "   你好世界  dari Lua!\nUTF-8 😊\n"

print("--- Tugas 1: Text Cleaner & Analyzer ---")

-- Test clean_text
local cleaned_1 = clean_text(input_raw)
print("Original Raw:", "'" .. input_raw .. "'")
print("Cleaned Raw:", "'" .. cleaned_1 .. "'")
-- Harapan: 'Ini adalah sebuah contoh teks dengan whitespace berlebih.Baris kedua.Baris terakhir.'

local cleaned_unicode = clean_text(input_unicode)
print("Original Unicode:", "'" .. input_unicode .. "'")
print("Cleaned Unicode:", "'" .. cleaned_unicode .. "'")
-- Harapan: '你好世界 dari Lua!UTF-8 😊'

print("\n--- Analisis Teks ---")
local stats_raw = analyze_text(cleaned_1)
print("Statistik Raw Teks:")
print("  Karakter:", stats_raw.chars) -- Harapan: Sesuai panjang teks setelah dibersihkan
print("  Kata:", stats_raw.words)   -- Harapan: Sesuai jumlah kata
print("  Baris:", stats_raw.lines) -- Harapan: Sesuai jumlah baris
print("  Uppercase:", stats_raw.upper_text)
print("  Lowercase:", stats_raw.lower_text)

local stats_unicode = analyze_text(cleaned_unicode)
print("\nStatistik Unicode Teks:")
print("  Karakter:", stats_unicode.chars) -- Harapan: Sesuai panjang karakter logis (utf8.len)
print("  Kata:", stats_unicode.words)
print("  Baris:", stats_unicode.lines)
print("  Uppercase (ASCII only):", stats_unicode.upper_text) -- Perhatikan batasan
print("  Lowercase (ASCII only):", stats_unicode.lower_text) -- Perhatikan batasan
```

---

### **TUGAS 2: Simple Log Parser**

Fokus pada Level 3 dan 4.

**Deskripsi:** Buat fungsi untuk mengurai baris log sederhana dan mengekstrak informasi penting.

**Format Log Contoh:**
`[YYYY-MM-DD HH:MM:SS] [LEVEL] Message text goes here.`
Contoh: `[2024-06-05 10:30:15] [INFO] User 'Alice' logged in.`
Contoh: `[2024-06-05 10:30:20] [ERROR] Database connection failed.`

**Fungsi yang Harus Dibuat:**

1.  **`function parse_log_entry(log_line)`**

    - Tugas: Mengurai satu baris log dan mengekstrak timestamp, level, dan pesan.
    - Persyaratan:
      - Gunakan `string.match()` dengan _captures_ untuk mengekstrak tiga bagian utama:
        - Timestamp (misal: "2024-06-05 10:30:15")
        - Level (misal: "INFO", "ERROR", "WARN")
        - Message (misal: "User 'Alice' logged in.")
      - Tangani jika format log tidak cocok (kembalikan `nil` atau tabel kosong).
    - Return value: Sebuah tabel seperti `{timestamp = "...", level = "...", message = "..."}` atau `nil`.

2.  **`function process_log_file(log_content)`**
    - Tugas: Memproses seluruh konten "file log" (berupa string multi-baris) dan mengurai setiap baris.
    - Persyaratan:
      - Pecah `log_content` menjadi baris-baris individual. (Gunakan `string.gmatch()` dengan pola yang tepat untuk iterasi baris).
      - Untuk setiap baris, panggil `parse_log_entry()`.
      - Kumpulkan hasil parsing ke dalam sebuah tabel.
    - Return value: Sebuah tabel yang berisi tabel-tabel hasil parsing dari setiap baris log yang valid.

**Contoh Penggunaan & Pengujian:**

```lua
-- Contoh Penggunaan & Pengujian untuk Tugas 2
local log_data = [[
[2024-06-05 08:00:01] [INFO] Application started.
[2024-06-05 08:00:05] [DEBUG] Loading configuration...
[2024-06-05 08:00:10] [WARN] Disk space low. (Used: 90%)
[2024-06-05 08:00:15] [ERROR] Failed to connect to server. Error code 500.
Ini adalah baris yang tidak valid.
[2024-06-05 08:00:20] [INFO] User 'Bob' logged out.
]]

print("\n--- Tugas 2: Simple Log Parser ---")

local parsed_logs = process_log_file(log_data)

if parsed_logs then
    for i, entry in ipairs(parsed_logs) do
        print(string.format("Entry %d: Timestamp=%s, Level=%s, Message='%s'",
            i, entry.timestamp, entry.level, entry.message))
    end
else
    print("Failed to parse log data.")
end
-- Harapan: Menganalisis setiap baris yang valid dan mencetak timestamp, level, dan message.
-- Baris yang tidak valid harus diabaikan.
```

---

### **TUGAS 3: Advanced LPEG Parser (Opsional, Tingkat Lanjut)**

Fokus pada Level 6. Hanya kerjakan jika Anda sudah nyaman dengan konsep dasar LPEG.

**Deskripsi:** Buat parser sederhana menggunakan LPEG untuk ekspresi aritmatika dasar (penjumlahan dan pengurangan) dengan bilangan bulat.

**Contoh Ekspresi:**
`10 + 5 - 2`
`1 + 2 + 3`
`10 - 5`

**Fungsi yang Harus Dibuat:**

1.  **`function parse_arithmetic_expression(expression_string)`**
    - Tugas: Mengurai ekspresi dan mengembalikan hasilnya.
    - Persyaratan:
      - Gunakan LPEG untuk mendefinisikan pola untuk:
        - Bilangan bulat (`number`)
        - Operator (`plus_op`, `minus_op`)
        - Spasi (`spaces`)
        - Sebuah ekspresi (`expression`) yang terdiri dari `number` diikuti oleh nol atau lebih pasangan `operator` dan `number`.
      - Gunakan _captures_ dan fungsi `lpeg.C()` atau `lpeg.Ct()` (untuk tabel jika Anda ingin melihat struktur) atau `lpeg.P(value)` untuk mengembalikan hasil perhitungan.
      - Untuk kesederhanaan, fokus pada evaluasi langsung (misalnya, 10 + 5 - 2 = 13) alih-alih membangun _parse tree_ yang kompleks. Anda bisa menggunakan `P / function` untuk melakukan perhitungan saat parsing.
    - Return value: Hasil perhitungan numerik, atau `nil` jika ekspresi tidak valid.

**Contoh Penggunaan & Pengujian:**

```lua
-- Contoh Penggunaan & Pengujian untuk Tugas 3 (Opsional)
local lpeg = require("lpeg") -- Pastikan LPEG terinstal

print("\n--- Tugas 3: Advanced LPEG Parser (Opsional) ---")

local P = lpeg.P
local S = lpeg.S
local C = lpeg.C

-- Definisi pola dasar untuk LPEG parser:
local number = C(lpeg.R('09')^1) / tonumber -- Capture digit dan konversi ke angka
local spaces = lpeg.S(' \t')^0             -- Nol atau lebih spasi/tab

-- Definisi pola operator
local plus_op = P('+') * spaces
local minus_op = P('-') * spaces

-- Definisi pola ekspresi aritmatika
-- Anda harus mengisi bagian ini. Petunjuk: gunakan captures dan fungsi untuk melakukan kalkulasi
local expression = --[[ LENGKAPI DENGAN LPEG PATTERN ANDA DI SINI ]]

-- Contoh:
-- expression = number * (
--     (plus_op * number / function(val1, op_val, val2) return val1 + val2 end) -
--     (minus_op * number / function(val1, op_val, val2) return val1 - val2 end)
-- )^0
-- Catatan: Pola di atas membutuhkan penanganan accumulator, jadi mungkin lebih kompleks.
-- Alternatif sederhana untuk awal: hanya menangkap semua angka dan operator, lalu hitung manual
-- Atau, lebih baik, gunakan lpeg.Cmt() atau lpeg.Cf() untuk membangun evaluator langsung.
-- Untuk memulai, mungkin lebih mudah untuk hanya mengurai angka dan operator, lalu hitung secara terpisah.

-- Contoh sederhana untuk start: hanya parsing dan mendapatkan angka dan operator sebagai tabel
-- local op = (P'+' / '+') - (P'-' / '-')
-- local expression_capture_all = Ct(number * (spaces * op * spaces * number)^0)
-- local parsed_data_lpeg = expression_capture_all:match(expression_string)
-- Lalu hitung dari parsed_data_lpeg

-- ATAU, jika Anda ingin langsung menghitung (lebih LPEG-idiomatic tapi lebih sulit di awal):
local calculate_expression = lpeg.Ct(
    number * lpeg.Cg((plus_op * number) - (minus_op * number))^0
) / function(t)
    local result = t[1]
    for i = 2, #t do
        local op = t[i][1]
        local val = t[i][2]
        if op == "+" then
            result = result + val
        elseif op == "-" then
            result = result - val
        end
    end
    return result
end

function parse_arithmetic_expression(expression_string)
    local parser = spaces * calculate_expression * spaces * -lpeg.any
    return parser:match(expression_string)
end


print("Parse '10 + 5 - 2':", parse_arithmetic_expression("10 + 5 - 2")) -- Harapan: 13
print("Parse '1 + 2 + 3':", parse_arithmetic_expression("1 + 2 + 3"))   -- Harapan: 6
print("Parse '20 - 7':", parse_arithmetic_expression("20 - 7"))         -- Harapan: 13
print("Parse '5':", parse_arithmetic_expression("5"))                   -- Harapan: 5
print("Parse '10 + A':", parse_arithmetic_expression("10 + A"))         -- Harapan: nil (karena ada karakter non-angka 'A')
```

- **Catatan LPEG untuk Tugas 3**: Bagian LPEG ini bisa menjadi cukup kompleks. `calculate_expression` di atas adalah contoh salah satu cara untuk membangun parser yang langsung menghitung. Ini menggunakan `lpeg.Cg` untuk membuat grup capture dari operasi, dan kemudian fungsi transformasi pada `lpeg.Ct` untuk mengiterasi grup-grup tersebut dan melakukan perhitungan. Jangan ragu untuk mencari referensi LPEG lebih lanjut jika Anda menghadapi kesulitan di sini. Tujuan utamanya adalah untuk merasakan kekuatan LPEG dalam _parsing_.

---

### **Panduan Umum Proyek:**

1.  **Struktur Kode**: Organisasikan kode Anda dalam blok-blok fungsi yang jelas untuk setiap tugas.
2.  **Komentar**: Berikan komentar yang jelas di kode Anda untuk menjelaskan logika dan bagian-bagian penting dari pola Anda.
3.  **Pengujian**: Gunakan `print()` untuk mencetak hasil dan memverifikasi bahwa fungsi Anda bekerja sesuai harapan.
4.  **Iterasi**: Mulailah dari yang sederhana, uji, lalu tambahkan kompleksitas.
5.  **Refleksi**: Setelah setiap tugas, pikirkan:
    - Fungsi string Lua mana yang paling membantu?
    - Bagaimana pola Lua mempermudah pekerjaan Anda?
    - Apa batasan dari pola Lua standar yang Anda temui?
    - Bagaimana LPEG menawarkan solusi untuk batasan tersebut (jika Anda mengerjakan Tugas 3)?

Selamat mengerjakan proyek praktik Anda! Ini adalah langkah terakhir yang penting dalam perjalanan Anda menguasai string manipulation di Lua.

</details>

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-6/README.md
[selanjutnya]: ../bagian-8/README.md

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
