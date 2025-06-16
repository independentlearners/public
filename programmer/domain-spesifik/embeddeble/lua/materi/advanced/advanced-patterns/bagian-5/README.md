Setelah mendalami LPeg sebagai alat parsing serbaguna, sekarang kita akan mengaplikasikan pengetahuan tersebut pada beberapa format data terstruktur yang paling umum di dunia pemrograman: XML, JSON, dan format biner. Bagian ini sangat berorientasi pada praktik, menimbang antara solusi "buat sendiri dengan pattern" versus "gunakan library khusus".

---

### Peringatan Penting: Parsing Format Standar

Sebelum kita mulai, ada sebuah prinsip penting dalam rekayasa perangkat lunak: **Jangan menciptakan ulang roda, terutama jika roda tersebut harus bisa berjalan di segala medan.**

Meskipun secara teknis _mungkin_ untuk mem-parsing XML atau JSON dengan LPeg, format-format ini memiliki banyak sekali kasus tepi (edge cases), aturan-aturan rumit (seperti _namespaces_ di XML atau _character escaping_ di JSON), dan potensi celah keamanan. Untuk penggunaan di dunia nyata (aplikasi produksi), **sangat disarankan** untuk menggunakan library yang sudah teruji dan didedikasikan untuk tugas tersebut.

Bagian ini akan menunjukkan kepada Anda _bagaimana_ Anda bisa melakukannya dengan pattern (sebagai latihan akademis yang sangat baik) dan kemudian mengarahkan Anda ke solusi yang lebih kuat dan praktis.

---

### **[Daftar Isi (Bagian V)][0]**

- [**BAGIAN V: XML DAN STRUCTURED DATA PARSING**](#bagian-v-xml-dan-structured-data-parsing)
  - [5.1 XML Parsing dengan Patterns](#51-xml-parsing-dengan-patterns)
  - [5.2 SLAXML - Advanced XML Processing](#52-slaxml---advanced-xml-processing)
  - [5.3 JSON dan Data Format Parsing](#53-json-dan-data-format-parsing)
  - [5.4 Binary Data Patterns](#54-binary-data-patterns)

---

## **[BAGIAN V: XML DAN STRUCTURED DATA PARSING][0]**

### 5.1 XML Parsing dengan Patterns

Ini adalah tantangan klasik. Mari kita lihat sejauh mana kita bisa pergi dengan pattern.

- **Basic XML Structure Parsing**: Untuk XML yang sangat sederhana dan terkontrol, kita bisa membuat pattern untuk mengekstrak tag dan konten.
- **Attribute Extraction**: Menambahkan ekstraksi atribut membuat pattern menjadi lebih rumit dengan cepat.
- **Nested Element Handling**: Di sinilah pattern `string.match` standar akan gagal total. Kita memerlukan kekuatan rekursif dari LPeg.
- **Masalah Dunia Nyata**: XML di dunia nyata mengandung _comments_ (\`\`), _CDATA sections_ (`<![CDATA[...]]>`), _processing instructions_ (\`\<?...?\>\`), _namespaces_ (\`[ns:tag](https://www.google.com/search?q=ns:tag)\`), dan berbagai aturan encoding. Mencoba menangani semua ini dengan satu pattern LPeg raksasa adalah resep untuk sakit kepala dan bug.

**Contoh: Parsing XML Sederhana dengan LPeg (Sebagai Latihan)**

```lua
local lpeg = require("lpeg")

local xml_text = '<note from="Budi" to="Ani"><heading>Pengingat</heading><body>Jangan lupa!</body></note>'

-- Grammar (sangat disederhanakan)
local grammar = lpeg.P{ "Tag",
  Tag = lpeg.P"<" * lpeg.C(lpeg.R("az")^1) * lpeg.P">" * -- Tag pembuka
        lpeg.Ct(lpeg.V("Content")) * -- Konten (bisa tag lain)
        lpeg.P"</" * lpeg.P(1) * lpeg.P">",                  -- Tag penutup
  Content = lpeg.V("Tag") + lpeg.C((lpeg.P(1) - lpeg.P"<")^1) -- Konten adalah Tag atau Teks
}

-- LPeg akan kesulitan dengan backreference dinamis seperti </%1> dari string.match.
-- Grammar ini disederhanakan untuk hanya mencocokkan </tagname>.
-- Ini menyoroti mengapa library khusus lebih baik.
-- Referensi ke Lua XML Wiki menunjukkan berbagai pendekatan untuk masalah ini.
```

### 5.2 SLAXML - Advanced XML Processing

Karena parsing XML manual sangat sulit, kita beralih ke library khusus. **SLAXML** adalah salah satu parser populer yang direkomendasikan.

- **SAX-like Streaming Parsing**: Konsep utama SLAXML adalah _streaming_. Alih-alih memuat seluruh file XML ke memori untuk membangun pohon data (seperti parser DOM), parser SAX (Simple API for XML) memproses file sebagai serangkaian _event_ atau _kejadian_: "tag pembuka ditemukan", "teks ditemukan", "tag penutup ditemukan", dst. Pendekatan ini sangat efisien dalam penggunaan memori, membuatnya ideal untuk file XML yang sangat besar.
- **Handlers**: Anda mendefinisikan fungsi-fungsi "handler" yang akan dipanggil ketika SLAXML menemukan event tertentu.

**Contoh Penggunaan SLAXML**

```lua
-- Diasumsikan SLAXML telah diinstal via luarocks
local slaxml = require("slaxml")

local xml_text = '<doc><item id="1">Satu</item><item id="2">Dua</item></doc>'

-- Buat handler
local handler = {
  -- Dipanggil saat tag pembuka ditemukan
  startElement = function(tag, attrs)
    print("Mulai Tag:", tag)
    if attrs.id then
      print("  dengan ID:", attrs.id)
    end
  end,
  -- Dipanggil saat teks di dalam tag ditemukan
  characters = function(text)
    print("  Teks:", text)
  end,
  -- Dipanggil saat tag penutup ditemukan
  endElement = function(tag)
    print("Selesai Tag:", tag)
  end
}

-- Jalankan parser
slaxml.on(handler).go(xml_text)

-- Output:
-- Mulai Tag: doc
-- Mulai Tag: item
--   dengan ID: 1
--   Teks: Satu
-- Selesai Tag: item
-- Mulai Tag: item
--   dengan ID: 2
--   Teks: Dua
-- Selesai Tag: item
-- Selesai Tag: doc
```

### 5.3 JSON dan Data Format Parsing

- **JSON Parsing dengan Patterns**: Sama seperti XML, JSON memiliki struktur rekursif (objek dapat berisi objek, array dapat berisi array) yang membuatnya cocok untuk di-parse dengan LPeg sebagai latihan. Namun, menangani semua detail seperti _string escaping_ (`\"`, `\\`, `\n`) dengan benar sangatlah rumit.
- **Gunakan Library Khusus**: Untuk JSON, aturannya bahkan lebih tegas: **selalu gunakan library khusus**. Kecepatan dan keamanan dari library yang ditulis dalam C (seperti `lua-cjson`) jauh melampaui apa pun yang bisa dicapai dengan parser LPeg murni. Kurikulum Anda dengan tepat merujuk ke halaman wiki yang mendaftar berbagai modul JSON.
- **INI dan YAML**:
  - **INI**: Format `key = value` yang sederhana seringkali cukup mudah di-parse dengan pattern standar (`string.gmatch`), seperti yang ditunjukkan di Bagian III.
  - **YAML**: Format ini sangat kompleks karena bergantung pada spasi (indentation) dan memiliki banyak fitur canggih. **Jangan pernah** mencoba mem-parse YAML dengan pattern; gunakan library khusus.

**Contoh Penggunaan Library JSON (misalnya, `dkjson`)**

```lua
-- Diasumsikan library JSON sudah tersedia
local json = require("dkjson")

local json_string = '{"name": "Budi", "age": 25, "isStudent": true}'

-- Decode: mengubah string JSON menjadi tabel Lua
local lua_table, pos, err = json.decode(json_string)

if lua_table then
  print("Nama:", lua_table.name) -- Output: Nama: Budi
  print("Umur:", lua_table.age)  -- Output: Umur: 25
else
  print("Error parsing JSON:", err)
end

-- Encode: mengubah tabel Lua menjadi string JSON
local new_table = { city = "Jakarta", active = false }
local new_json_string = json.encode(new_table)
print(new_json_string) -- Output: {"active":false,"city":"Jakarta"}
```

### 5.4 Binary Data Patterns

Ini adalah jenis parsing yang sama sekali berbeda, di mana kita tidak lagi berurusan dengan teks, melainkan dengan urutan **byte** yang mewakili angka, string dengan panjang tetap, dan struktur data biner lainnya.

- **Konsep**: Alih-alih mencari karakter, kita membaca sejumlah byte tertentu dan menafsirkannya sebagai tipe data tertentu (misalnya, 4 byte pertama adalah integer 32-bit, 16 byte berikutnya adalah string, dst.).

- **Alat**:

  - **`string.pack` / `string.unpack`**: Fungsi bawaan Lua untuk mengubah antara nilai Lua dan representasi biner dalam string, menggunakan "format string".
  - **Lua Struct Library**: Library ini menyediakan cara yang lebih canggih dan seringkali lebih mudah untuk menangani struktur data biner yang kompleks, terutama yang cocok dengan `struct` di C.

- **Aplikasi**:

  - **Network Protocols**: Banyak protokol jaringan mengirim data dalam format biner yang padat untuk efisiensi.
  - **File Formats**: Membaca atau menulis file gambar, audio, atau format file kustom apa pun yang bukan berbasis teks.

**Contoh: Menggunakan `string.unpack` untuk Parsing Header Paket**

```lua
-- Misalkan kita menerima paket biner dari jaringan.
-- Format: [ID Paket (2 byte, big-endian)] [Ukuran Payload (4 byte, big-endian)] [Payload (string)]
-- > artinya Big-Endian, I2 = integer 2 byte, I4 = integer 4 byte

-- Membuat paket biner palsu untuk demo
local packet_id = 101
local payload = "Halo Dunia"
local payload_size = #payload
local binary_packet = string.pack(">I2I4", packet_id, payload_size) .. payload

-- Sekarang, mari kita parse (unpack) header-nya
local id, size = string.unpack(">I2I4", binary_packet)

print("ID Paket:", id)         -- Output: ID Paket: 101
print("Ukuran Payload:", size) -- Output: Ukuran Payload: 10
```

---

Bagian ini telah membekali Anda dengan pendekatan praktis untuk menangani format data terstruktur yang umum. Anda tahu kapan harus menggunakan pattern sebagai latihan, dan kapan harus beralih ke library yang tangguh untuk keandalan dan performa. Selanjutnya, kita akan beralih dari parsing data ke topik yang lebih meta: menggunakan pattern untuk memprogram program lain (metaprogramming).

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

[0]: ../README.md#bagian-v-xml-dan-structured-data-parsing
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
