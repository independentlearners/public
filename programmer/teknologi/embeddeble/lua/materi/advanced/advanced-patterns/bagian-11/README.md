Setelah menguasai cara membuat pattern, menggunakannya dalam aplikasi, dan mengintegrasikannya dengan C, sekarang kita sampai pada salah satu bagian terpenting dalam rekayasa perangkat lunak profesional: memastikan bahwa apa yang kita bangun itu **benar, andal, dan dapat dipelihara**. Menulis pattern yang rumit itu satu hal; membuktikan bahwa ia bekerja di semua kasus dan tidak akan rusak oleh perubahan di masa depan adalah hal lain. Bagian ini berfokus pada disiplin pengujian dan debugging.

---

### Daftar Isi (Bagian XI)

- [**BAGIAN XI: TESTING DAN DEBUGGING**](#bagian-xi-testing-dan-debugging)
  - [11.1 Pattern Testing Frameworks](#111-pattern-testing-frameworks)
  - [11.2 Debugging Techniques Lanjutan](#112-debugging-techniques-lanjutan)
  - [11.3 Validation dan Verification](#113-validation-dan-verification)
  - [11.4 Continuous Integration](#114-continuous-integration)

---

## **[BAGIAN XI: TESTING DAN DEBUGGING][0]**

### 11.1 Pattern Testing Frameworks

Daripada menjalankan skrip secara manual setiap kali Anda mengubah pattern, kita menggunakan framework pengujian untuk mengotomatiskan proses ini. Framework populer di Lua termasuk Busted dan Telescope.

- **Unit Testing Pattern Matching**: Ini adalah praktik menguji setiap "unit" (bagian kecil) dari kode Anda secara terpisah. Dalam kasus kita, satu unit bisa jadi satu fungsi yang menggunakan pattern.

  **Contoh Test Case (menggunakan sintaks mirip Busted)**:

  ```lua
  -- file: test_email_validator.lua
  describe("Email Validator", function()
    -- Muat fungsi yang akan diuji
    local isValidEmail = require("my_validators").isValidEmail

    it("should accept a valid email", function()
      -- Assert: pastikan hasilnya adalah 'true'
      assert.is_true(isValidEmail("test@example.com"))
    end)

    it("should reject an email without an @ symbol", function()
      assert.is_false(isValidEmail("testexample.com"))
    end)

    it("should reject an email with invalid characters", function()
      assert.is_false(isValidEmail("test<script>@example.com"))
    end)

    it("should reject an empty string", function()
      assert.is_false(isValidEmail(""))
    end)
  end)
  ```

- **Property-Based Testing**: Pendekatan yang lebih canggih di mana Anda tidak menulis contoh spesifik, melainkan mendefinisikan "properti" atau aturan yang harus selalu benar. Framework kemudian akan menghasilkan ratusan input acak untuk mencoba mematahkan aturan tersebut.

- **Fuzzing Pattern Matchers**: Fuzzing adalah teknik di mana program Anda "dibombardir" dengan input yang sepenuhnya acak, tidak valid, dan tidak terduga untuk melihat apakah ia crash atau mengalami kebocoran memori. Ini adalah teknik penting untuk menemukan celah keamanan dalam parser.

### 11.2 Debugging Techniques Lanjutan

Ketika sebuah pattern kompleks gagal, bagaimana Anda menemukan masalahnya?

- **Pattern Tracing dan Profiling**: Untuk LPeg, Anda dapat membuat versi debug dari grammar Anda yang mencetak pesan setiap kali sebuah aturan dicoba atau berhasil. Ini memungkinkan Anda "melacak" jalur yang diambil parser melalui input Anda.
- **Step-by-step Pattern Execution**: Pecah pattern kompleks Anda menjadi bagian-bagian yang lebih kecil. Jika pattern `P1 * P2 * P3` gagal, uji `P1` terlebih dahulu. Lihat apa yang dicocokkannya. Kemudian, ambil sisa string dan uji dengan `P2`, dan seterusnya. Ini membantu mengisolasi bagian mana yang gagal.
- **Common Pitfalls dan Solutions (Jebakan Umum)**:
  - **Keserakahan (Greediness)**: Bingung antara `.` (cocok dengan apa saja) dan `%w` (hanya alfanumerik), atau antara `.+` (serakah) dan `.-` (tidak serakah).
  - **Lupa Escape**: Mencoba mencocokkan `.` literal tanpa `%.`, atau `(` tanpa `%(`, dll.
  - **Anchor `^` dan `$`**: Lupa bahwa ini berlaku untuk keseluruhan string, bukan per baris, di implementasi standar.

### 11.3 Validation dan Verification

Ini adalah tentang memastikan pattern Anda tidak hanya bekerja, tetapi juga aman.

- **Pattern Correctness Verification**: Memastikan pattern Anda secara akurat mengimplementasikan sebuah spesifikasi (misalnya, RFC untuk format email). Ini memerlukan pembuatan suite tes yang komprehensif yang mencakup semua kasus yang valid dan tidak valid yang dijelaskan dalam spesifikasi.
- **Security Considerations (Pertimbangan Keamanan)**:
  - **Input Sanitization**: Jangan pernah membangun pattern secara dinamis dari input yang tidak tepercaya tanpa membersihkannya terlebih dahulu. Seorang penyerang bisa menyuntikkan karakter khusus untuk mengubah logika pattern Anda (disebut _Pattern Injection_).
  - **ReDoS (Regular Expression Denial of Service)**: Ini adalah serangan di mana input yang dibuat dengan hati-hati dapat menyebabkan pattern dengan _backtracking_ yang berlebihan berjalan dalam waktu yang sangat lama, menghabiskan 100% CPU dan membuat layanan Anda tidak responsif.
    - **Kabar Baik**: LPeg, karena sifatnya sebagai parser PEG yang tidak ambigu, secara umum kebal terhadap serangan ReDoS berbasis backtracking, yang merupakan keunggulan keamanan yang signifikan.
  - **DoS Prevention**: Untuk parser yang sangat kompleks, terapkan batas waktu (timeout). Jika parsing memakan waktu lebih dari beberapa milidetik, batalkan operasi tersebut untuk mencegah penyalahgunaan.

### 11.4 Continuous Integration

_Continuous Integration_ (CI) adalah praktik di mana setiap perubahan kode yang dibuat oleh pengembang secara otomatis diuji.

- **Automated Pattern Testing**: Anda mengkonfigurasi sistem CI (seperti GitHub Actions atau Jenkins) untuk secara otomatis menjalankan framework pengujian Anda (misalnya, `busted`) setiap kali ada kode baru yang di-commit. Jika ada tes yang gagal, build akan ditandai "gagal", dan tim akan segera diberi tahu.
- **Performance Regression Testing**: Pipeline CI juga dapat menjalankan benchmark Anda. Jika ada perubahan yang menyebabkan kinerja parsing turun secara signifikan, sistem dapat menandainya sebagai "regresi kinerja".
- **Cross-Platform Validation**: Sistem CI dapat menjalankan tes Anda di berbagai lingkungan (Linux, Windows, macOS) dan versi Lua (5.1, 5.3, LuaJIT) untuk memastikan kode Anda bekerja secara konsisten di mana saja.

---

Bagian ini telah membekali Anda dengan disiplin untuk memastikan kualitas. Anda tidak hanya bisa menulis pattern, tetapi juga bisa membuktikan bahwa pattern tersebut benar, andal, aman, dan akan tetap seperti itu seiring waktu.

Selanjutnya, kita akan fokus secara mendalam pada satu aspek kritis yang telah disinggung: keamanan.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-10/README.md
[selanjutnya]: ../bagian-12/README.md

<!----------------------------------------------------->

[0]: ../README.md#bagian-xi-testing-dan-debugging
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
