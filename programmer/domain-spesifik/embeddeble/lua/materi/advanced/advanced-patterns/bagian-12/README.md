Setelah memastikan kode kita benar dan andal melalui pengujian, sekarang kita harus fokus pada aspek yang paling kritis dari rekayasa perangkat lunak modern: **keamanan**. Aplikasi yang fungsional dan cepat tidak ada artinya jika rentan terhadap serangan. Bagian ini akan menunjukkan bagaimana pattern matching bukan hanya alat untuk memproses data, tetapi juga merupakan perisai penting dalam strategi pertahanan keamanan Anda.

---

### Daftar Isi (Bagian XII)

- [**BAGIAN XII: SECURITY PATTERNS**](#bagian-xii-security-patterns)
  - [12.1 Input Validation Patterns](#121-input-validation-patterns)
  - [12.2 Cryptographic Patterns](#122-cryptographic-patterns)
  - [12.3 Authentication Patterns](#123-authentication-patterns)

---

## **[BAGIAN XII: SECURITY PATTERNS][0]**

Prinsip dasar keamanan adalah: **jangan pernah mempercayai input dari luar**. Setiap data yang datang dari pengguna, jaringan, atau file harus dianggap berpotensi berbahaya sampai terbukti sebaliknya. Validasi input yang ketat adalah garis pertahanan pertama Anda, dan pattern matching adalah alat utama untuk melakukannya.

### 12.1 Input Validation Patterns

Ini adalah penggunaan pattern yang paling langsung untuk keamanan: menolak data yang tidak sesuai dengan format yang diharapkan.

- **SQL Injection Prevention**:

  - **Ancaman**: Penyerang memasukkan kode SQL ke dalam kolom input (misalnya, `admin'--`) untuk memanipulasi query database.
  - **Peran Pattern**: Meskipun pertahanan utamanya adalah menggunakan _parameterized queries_ (prepared statements) di lapisan database, validasi input adalah pertahanan pertama yang krusial. Jika sebuah field seharusnya hanya berisi nama pengguna alfanumerik, gunakan pattern `^%w+$` untuk memvalidasinya. Ini akan menolak karakter-karakter khusus (`'`, `;`, `-`) yang dibutuhkan untuk serangan injeksi bahkan sebelum input tersebut menyentuh logika database.

- **XSS (Cross-Site Scripting) Prevention**:

  - **Ancaman**: Penyerang menyuntikkan skrip berbahaya (misalnya, `<script>alert('xss')</script>`) ke dalam data yang nantinya akan ditampilkan di halaman web, yang berpotensi mencuri data pengguna lain.
  - **Peran Pattern**: Pertahanan utama adalah _output escaping_ (mengubah `<` menjadi `&lt;`, dst.) saat me-render HTML. Namun, di sisi input, Anda dapat menggunakan pattern untuk menolak data yang mengandung tag-tag berbahaya seperti `<script>`, `<iframe>`, atau atribut seperti `onclick`, mengurangi permukaan serangan.

- **Path Traversal Protection**:

  - **Ancaman**: Penyerang menggunakan urutan `../` untuk mencoba mengakses file di luar direktori yang seharusnya (misalnya, meminta gambar `../../../../etc/passwd`).
  - **Peran Pattern**: Gunakan pattern untuk memastikan nama file hanya berisi karakter yang diizinkan (misalnya, alfanumerik, titik, garis bawah) dan secara eksplisit menolak string apa pun yang mengandung `../`.

  <!-- end list -->

  ```lua
  function isSafeFilename(filename)
    -- Hanya izinkan huruf, angka, _, -, dan .
    -- Dan pastikan tidak mengandung '..'
    if string.find(filename, "%.%./") or string.find(filename, "%.%.\\") then
      return false
    end
    return string.match(filename, "^[%w%._-]+$") ~= nil
  end
  ```

- **Command Injection Prevention**:

  - **Ancaman**: Terjadi ketika input pengguna dimasukkan ke dalam perintah shell sistem (`os.execute`). Penyerang bisa menyuntikkan perintah tambahan (misalnya, `my_file; rm -rf /`).
  - **Peran Pattern**: Sama seperti validasi nama file, gunakan pattern yang sangat ketat untuk hanya mengizinkan karakter yang aman dan menolak metakarakter shell seperti `;`, `|`, `&`, `(`, `)`.

### 12.2 Cryptographic Patterns

Ini bukan tentang mengimplementasikan algoritma kriptografi, tetapi tentang memvalidasi format data dan token kriptografis.

- **Pattern-based Key Validation**: Kunci API, token, dan data terenkripsi seringkali memiliki format yang spesifik (misalnya, diawali dengan `sk_`, memiliki panjang tertentu, atau menggunakan encoding Base64). Pattern dapat digunakan untuk memvalidasi format ini dengan cepat.

  ```lua
  function isValidApiKey(key)
    -- Harus dimulai dengan 'pk_', diikuti oleh 32 karakter alfanumerik
    return string.match(key, "^pk_%w{32}$") ~= nil
  end
  ```

- **Certificate Parsing**: Meskipun parsing penuh sertifikat X.509 memerlukan library khusus, pattern dapat digunakan untuk mengekstrak informasi dasar dari sertifikat berformat PEM (teks) untuk keperluan logging atau pemeriksaan awal.

- **Cryptographic Protocol Parsing**: Dalam implementasi protokol kustom, pattern dapat membantu mem-parsing pesan-pesan text-based untuk memastikan mereka tidak cacat sebelum diproses lebih lanjut.

### 12.3 Authentication Patterns

Pattern sangat berguna dalam memvalidasi berbagai artefak yang digunakan dalam sistem otentikasi.

- **Token Validation Patterns**: Token sesi atau token JWT (JSON Web Token) memiliki struktur yang dapat divalidasi. Misalnya, JWT terdiri dari tiga bagian Base64url yang dipisahkan oleh titik. Sebuah pattern sederhana dapat memverifikasi struktur ini sebelum mencoba memverifikasi tanda tangannya.

  ```lua
  function isJwtStructureValid(token)
    -- Pattern: [base64url].[base64url].[base64url]
    local b64_pattern = "[%w%-_]+"
    return string.match(token, "^" .. b64_pattern .. "%.%." .. b64_pattern .. "%.%." .. b64_pattern .. "$") ~= nil
  end
  ```

- **Session Pattern Matching**: Data sesi yang disimpan dalam cookie bisa berupa string terstruktur (misalnya, `userid:123|role:admin`). Pattern `gmatch` dapat digunakan untuk mem-parsing data ini dengan aman.

- **OAuth Pattern Handling**: Alur kerja OAuth melibatkan pertukaran `code` dan `state` melalui parameter URL. Kode di sisi server menggunakan pattern untuk mengekstrak nilai-nilai ini dari URL request untuk melanjutkan proses otentikasi.

---

Bagian ini menegaskan kembali peran krusial pattern matching dalam "pertahanan berlapis" (defense-in-depth). Dengan memvalidasi input secara ketat di garis depan, Anda secara signifikan mengurangi risiko bahwa data berbahaya akan mencapai komponen sistem Anda yang lebih sensitif.

Selanjutnya, kita akan membahas pertimbangan yang muncul saat menerapkan pola-pola ini di berbagai platform dan lingkungan yang berbeda.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-11/README.md
[selanjutnya]: ../bagian-13/README.md

<!----------------------------------------------------->

[0]: ../README.md#bagian-xii-security-patterns
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
