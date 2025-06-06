# **[Bagian II: Kompilasi dan Bytecode (Compilation)][0]**

Bagian ini akan membawa kita "turun ke ruang mesin" Lua. Jika Bagian I adalah tentang _apa_ itu chunk, Bagian II adalah tentang _bagaimana_ Lua memahami dan mempersiapkan chunk tersebut untuk eksekusi. Pemahaman ini sangat penting untuk optimasi, keamanan, dan apresiasi mendalam terhadap cara kerja bahasa ini. Jadi setiap kali Lua menerima sebuah chunk kode sumber (misalnya, dari file `.lua`), ia tidak langsung menjalankannya. Sebaliknya, ia melalui proses **kompilasi** untuk mengubah kode yang dapat dibaca manusia menjadi format perantara yang disebut **bytecode**. Proses ini terjadi secara otomatis dan transparan setiap kali Anda menjalankan skrip, kecuali jika Anda menggunakan bytecode yang sudah dikompilasi sebelumnya (`.luac`).

#### **3. Proses Kompilasi Chunk**

Ini adalah alur langkah-demi-langkah dari kode sumber mentah menjadi bytecode yang siap dieksekusi.

##### **3.1 Lexical Analysis pada Chunk (Analisis Leksikal)**

- **Deskripsi Konkret:**
  Ini adalah langkah pertama dan paling dasar dari kompilasi. Bayangkan Anda membaca sebuah kalimat. Otak Anda secara otomatis mengidentifikasi kata-kata, angka, dan tanda baca. _Lexical Analysis_ (atau _tokenization_) adalah proses di mana kompilator Lua melakukan hal yang sama: ia memindai teks kode sumber dan memecahnya menjadi potongan-potongan kecil yang bermakna yang disebut **token**.

- **Terminologi dan Konsep:**

  - **Lexer (or Scanner):** Komponen dari kompilator yang melakukan analisis leksikal.
  - **Token:** Unit leksikal terkecil dalam kode. Setiap token memiliki tipe (misalnya, `KEYWORD`, `IDENTIFIER`, `NUMBER`, `OPERATOR`) dan nilai (misalnya, `"local"`, `"x"`, `"10"`, `"="`).

- **Proses dan Contoh:**
  Mari kita ambil sebaris kode Lua:
  `local x = "halo" -- sebuah komentar`

  Lexer akan membaca ini dan menghasilkan aliran token seperti berikut, sambil mengabaikan spasi dan komentar:

  1.  `local` -> Token Tipe: **KEYWORD**, Nilai: `local`
  2.  `x` -> Token Tipe: **IDENTIFIER** (nama variabel), Nilai: `x`
  3.  `=` -> Token Tipe: **OPERATOR**, Nilai: `=`
  4.  `"halo"` -> Token Tipe: **STRING**, Nilai: `"halo"`

  Proses ini mengubah sepotong teks mentah menjadi serangkaian unit yang terstruktur yang bisa diproses oleh langkah berikutnya.

##### **3.2 Parsing dan AST Generation (Analisis Sintaksis dan Pembuatan AST)**

- **Deskripsi Konkret:**
  Setelah kode dipecah menjadi token, langkah berikutnya adalah **parsing**. Parser mengambil aliran token dari lexer dan memeriksa apakah urutannya sesuai dengan aturan tata bahasa (sintaks) Lua. Jika sintaksnya valid, parser akan membangun sebuah struktur data berbentuk pohon yang disebut **Abstract Syntax Tree (AST)**. AST merepresentasikan struktur hierarkis dari kode sumber.

- **Terminologi dan Konsep:**

  - **Parser:** Komponen kompilator yang melakukan analisis sintaksis.
  - **Syntax:** Aturan tata bahasa dari sebuah bahasa pemrograman (misalnya, sebuah `if` harus diikuti oleh `then`). Jika Anda salah ketik, seperti `local = x 10`, parser akan melaporkan _syntax error_.
  - **Abstract Syntax Tree (AST):** Representasi pohon dari struktur kode. "Abstrak" karena ia tidak memuat semua detail sintaksis (seperti tanda kurung atau koma), hanya struktur logisnya.

- **Representasi Visual (AST):**
  Untuk kode `local x = 10`, AST sederhananya akan terlihat seperti ini:

  ```
       Assignment (Penugasan)
       /          \
      /            \
  Variabel 'x'     Nilai 10
  (deklarasi lokal)
  ```

  Pohon ini menangkap esensi dari statement tersebut: sebuah variabel lokal bernama `x` diberi nilai `10`.

##### **3.3 Code Generation (Pembuatan Kode)**

- **Deskripsi Konkret:**
  Ini adalah langkah terakhir dalam kompilasi. Kompilator akan "berjalan" melintasi setiap node di AST dan menerjemahkannya menjadi serangkaian instruksi **bytecode** untuk Lua Virtual Machine (VM).

- **Terminologi dan Konsep:**

  - **Code Generator:** Komponen yang mengubah AST menjadi bytecode.
  - **Bytecode Instruction:** Perintah tingkat rendah untuk Lua VM. Contohnya bisa seperti `LOADK` (memuat konstanta ke register), `SETGLOBAL` (mengatur variabel global), atau `ADD` (menjumlahkan dua nilai).
  - **Symbol Table:** Struktur data yang digunakan selama kompilasi untuk melacak semua variabel (identifier) dan informasinya (misalnya, apakah mereka lokal atau global).

- **Proses:**
  Mengunjungi AST dari `local x = 10`, code generator mungkin menghasilkan instruksi bytecode yang secara konseptual berarti:

  1.  `LOADK 0, 10` -> Muat konstanta `10` ke dalam "register" virtual nomor 0.
  2.  `SETLOCAL 0, 'x'` -> Tetapkan nilai di register 0 ke variabel lokal bernama `x`.

  Hasil akhirnya adalah serangkaian instruksi ringkas yang dapat dieksekusi dengan sangat cepat oleh Lua VM.

---

#### **4. Bytecode Analysis dan Manipulation (Analisis dan Manipulasi Bytecode)**

Setelah Anda memiliki bytecode, Anda bisa melakukan hal-hal menarik dengannya. Ini adalah area yang lebih canggih.

##### **4.1 Struktur Bytecode Chunk**

- **Deskripsi Konkret:**
  Seperti yang dibahas di Bagian I, chunk bytecode bukanlah file teks. Ini adalah file biner dengan format yang sangat spesifik. Memahami format ini memungkinkan Anda untuk membaca dan bahkan memodifikasinya secara manual (meskipun ini sangat jarang diperlukan).

- **Struktur Detail:**
  - **Header:** Beberapa byte pertama adalah "magic number" (`\27Lua`) untuk mengidentifikasi file. Diikuti oleh nomor versi (misalnya, `0x54` untuk Lua 5.4), data format, dan informasi arsitektur (ukuran `int`, `size_t`, endianness). Inilah sebabnya mengapa bytecode yang dikompilasi di mesin 64-bit mungkin tidak berjalan di mesin 32-bit.
  - **Function Prototypes:** Inti dari bytecode. Setiap prototipe berisi:
    - Daftar instruksi (opcodes).
    - Daftar konstanta (angka, string).
    - Informasi debug (nomor baris kode sumber asli).
    - Informasi tentang upvalues (variabel lokal dari fungsi luar yang diakses).
    - Prototipe untuk fungsi-fungsi turunan.

##### **4.2 Disassembly dan Reverse Engineering**

- **Deskripsi Konkret:**
  **Disassembly** adalah proses mengubah bytecode biner yang sulit dibaca kembali menjadi representasi tekstual dari instruksi-instruksi tersebut. Ini sangat berguna untuk debugging performa atau untuk memahami apa yang sebenarnya dilakukan oleh sebuah skrip. **Reverse engineering** melangkah lebih jauh, mencoba untuk merekonstruksi kode sumber Lua asli dari bytecode.

- **Alat dan Referensi:**

  - **`luac -l`:** Alat bawaan Lua. Menjalankan `luac -l namafile.lua` akan mencetak "disassembly" dari bytecode file tersebut.
  - **ChunkSpy:** Alat pihak ketiga yang menyediakan tampilan disassembly yang lebih detail dan ramah pengguna.
    - **Tautan:** [ChunkSpy - Lua 5 Disassembler](https://domoticx.com/lua-5-disassembler-chunkspy-lua-bytecode-bestanden/)
  - **LuaDecompy / unluac:** Decompiler yang mencoba merekonstruksi kode Lua dari bytecode. Keberhasilannya bervariasi tergantung pada versi Lua dan kompleksitas kode.
    - **Tautan (Contoh):** [unluac di SourceForge](https://sourceforge.net/projects/unluac/)

- **Contoh Disassembly (Konseptual):**
  Kode Lua: `local a = 1`
  Disassembly (`luac -l`):
  ```
  main <source.lua:0,0> (3 instructions)
  1    [1]    LOADK        0 -1 ; 1
  2    [1]    RETURN        0 1
  3    [1]    RETURN        0 1
  ```
  Ini menunjukkan instruksi untuk memuat konstanta (1) dan kemudian kembali.

##### **4.3 Bytecode Validation dan Security**

- **Deskripsi Konkret:**
  Karena bytecode dapat dimuat dan dieksekusi secara langsung, ada risiko keamanan. Seseorang bisa membuat file bytecode berbahaya (malformed) yang dirancang untuk merusak VM Lua atau mengeksploitasi celah keamanan. Oleh karena itu, validasi bytecode menjadi penting.

- **Isu Keamanan:**
  - **Malformed Bytecode:** Bytecode yang tidak mengikuti format yang benar bisa menyebabkan crash. Lua VM memiliki beberapa pemeriksaan, tetapi tidak 100% foolproof terhadap input yang sengaja dibuat jahat.
  - **Version Mismatch:** Mencoba memuat bytecode dari versi Lua yang berbeda (misalnya, bytecode 5.3 di VM 5.4) akan menyebabkan error. Header bytecode berisi informasi versi untuk mencegah ini.
  - **Kepercayaan:** Jangan pernah menjalankan bytecode dari sumber yang tidak tepercaya tanpa _sandboxing_ yang tepat (akan dibahas di Bagian IV).

---

#### **5. Precompilation Advanced Topics**

##### **5.1 luac Compiler Deep Dive**

- **Deskripsi Konkret:**
  `luac` adalah compiler mandiri Lua. Biasanya, Lua mengkompilasi "on-the-fly" (saat itu juga), tetapi Anda bisa menggunakan `luac` untuk melakukan kompilasi terlebih dahulu (precompilation).

- **Manfaat Precompilation:**

  - **Loading Lebih Cepat:** VM tidak perlu lagi melakukan parsing dan code generation, hanya perlu memuat bytecode ke memori. Ini mempercepat waktu startup aplikasi.
  - **Distribusi Tanpa Kode Sumber:** Anda bisa mendistribusikan file `.luac` tanpa harus menyertakan file `.lua` asli Anda, memberikan lapisan perlindungan (obfuscation) dasar untuk properti intelektual Anda.
  - **Pemeriksaan Sintaks Awal:** Menjalankan `luac` pada semua skrip Anda selama proses build dapat menangkap _syntax error_ lebih awal.

- **Opsi Penting `luac`:**
  - `luac -o output.luac input.lua`: Mengkompilasi `input.lua` dan menyimpan hasilnya sebagai `output.luac`.
  - `luac -l input.lua`: Melakukan disassembly (seperti yang dijelaskan di atas).
  - `luac -p input.lua`: Hanya mem-parsing file untuk memeriksa error sintaks tanpa menghasilkan file output.
  - **Sumber:** [Manual Resmi luac](https://www.lua.org/manual/5.4/luac.html)

##### **5.2 Bytecode Portability**

- **Deskripsi Konkret:**
  Apakah bytecode yang Anda kompilasi di Windows bisa berjalan di Linux? Jawabannya: **mungkin tidak**. Bytecode Lua secara default **tidak portabel** antar arsitektur yang berbeda.

- **Masalah Portabilitas:**

  - **Endianness:** Sistem yang berbeda menyimpan urutan byte untuk angka multi-byte secara berbeda (big-endian vs. little-endian).
  - **Ukuran Tipe Data:** Ukuran `int` atau `size_t` bisa berbeda antara sistem 32-bit dan 64-bit.
  - **Versi Lua:** Seperti yang disebutkan, bytecode terikat pada versi mayor/minor Lua.

- **Strategi:**
  - Jika portabilitas adalah suatu keharusan, distribusikan kode sumber `.lua` dan biarkan kompilasi terjadi di mesin target.
  - Untuk skenario yang lebih terkontrol (misalnya, semua server Anda menggunakan OS dan arsitektur yang sama), precompilation aman untuk digunakan.

##### **5.3 Custom Compilation Pipelines**

- **Deskripsi Konkret:**
  Bagi pengguna tingkat lanjut, proses kompilasi Lua bisa disesuaikan. Anda bisa membuat alat sendiri yang melakukan hal-hal sebelum atau sesudah kompilasi standar.

- **Contoh Implementasi:**
  - **Preprocessing dan Macro:** Anda bisa menulis skrip (misalnya, dalam Python atau Lua itu sendiri) yang memproses file `.lua` Anda terlebih dahulu untuk mengganti makro atau melakukan hal lain sebelum diserahkan ke kompilator Lua.
  - **Optimisasi Kustom:** Anda bisa mem-parsing Lua ke AST, melakukan transformasi optimasi pada AST (misalnya, _constant folding_), lalu mengubah AST yang sudah dioptimalkan itu kembali menjadi kode Lua atau langsung menjadi bytecode.
  - **Integrasi dengan Build Systems:** Dalam proyek besar (seperti game), Anda bisa mengintegrasikan `luac` ke dalam sistem build Anda (seperti Make, CMake, SCons) untuk secara otomatis mengkompilasi semua skrip Lua menjadi bytecode sebagai bagian dari proses build game.

Selamat! Anda telah menyelesaikan bagian paling teknis dan teoretis dari kurikulum ini. Jangan khawatir jika beberapa konsep terasa abstrak. Saat Anda melanjutkan ke bagian berikutnya tentang _runtime_, Anda akan melihat bagaimana bytecode ini benar-benar "hidup" dan dieksekusi oleh Lua VM.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

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
