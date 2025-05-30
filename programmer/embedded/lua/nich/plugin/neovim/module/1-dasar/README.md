## [1. Fondasi Dasar Lua][1]

Bagian ini akan memperkenalkan Anda pada bahasa pemrograman Lua, menjelaskan karakteristik utamanya, serta sintaks dasar dan struktur kode yang digunakan dalam Lua. Pemahaman yang kuat terhadap fondasi ini sangat penting sebelum melangkah ke konsep yang lebih kompleks.

---

### 1.1 Pengenalan Lua

**Lua** adalah sebuah bahasa pemrograman skrip (scripting language) yang bersifat **ringan** (lightweight), **dinamis**, dan dirancang agar **mudah dipelajari** serta **disematkan (embeddable)** ke dalam aplikasi lain. Nama "Lua" berasal dari bahasa Portugis yang berarti "bulan". Kemampuannya untuk disematkan inilah yang menjadikannya pilihan ideal untuk Neovim, memungkinkan pengguna untuk mengkonfigurasi dan memperluas fungsionalitas editor dengan Lua.

**Terminologi Penting:**

- **Bahasa Pemrograman Skrip (Scripting Language):** Jenis bahasa pemrograman yang dirancang untuk mengotomatisasi tugas-tugas atau mengontrol perangkat lunak lain. Kode skrip seringkali diinterpretasikan daripada dikompilasi.
- **Ringan (Lightweight):** Merujuk pada ukuran interpreter Lua yang kecil dan penggunaan sumber daya sistem (memori, CPU) yang efisien, sehingga tidak memberatkan aplikasi induk (dalam hal ini Neovim).
- **Dinamis (Dynamic):** Mengacu pada beberapa aspek, termasuk pengetikan dinamis (tipe data variabel ditentukan saat runtime) dan kemampuan untuk memodifikasi struktur program saat runtime.
- **Mudah Disematkan (Embeddable):** Lua dirancang dengan C API yang sederhana, memudahkan integrasi dengan aplikasi yang ditulis dalam C/C++ seperti Neovim. Lua dapat berfungsi sebagai "lem" untuk berbagai komponen perangkat lunak.

**Karakteristik utama Lua:**

- **Interpreted language (Bahasa yang Diinterpretasi):** Kode Lua dieksekusi baris per baris secara langsung oleh interpreter Lua tanpa melalui tahap kompilasi menjadi kode mesin terlebih dahulu. Ini mempercepat siklus pengembangan karena perubahan kode dapat langsung diuji.
  - **Runtime:** Waktu ketika program sedang dieksekusi.
  - **Kompilasi:** Proses mengubah kode sumber (yang ditulis manusia) menjadi kode mesin atau bytecode yang dapat dieksekusi oleh komputer.
- **Dynamically typed (Pengetikan Dinamis):** Tipe data dari sebuah variabel tidak perlu dideklarasikan secara eksplisit dan ditentukan saat program berjalan (runtime) berdasarkan nilai yang di-assign ke variabel tersebut. Ini berbeda dengan bahasa statis (statically typed) seperti C++ atau Java dimana tipe variabel harus dideklarasikan saat kompilasi.
- **Garbage collected (Pengumpulan Sampah Otomatis):** Lua memiliki mekanisme manajemen memori otomatis yang disebut _garbage collector_. Mekanisme ini secara otomatis mendeteksi dan membebaskan memori yang sudah tidak digunakan lagi oleh program, sehingga programmer tidak perlu mengelola alokasi dan dealokasi memori secara manual. Ini mengurangi risiko kebocoran memori (memory leaks).
- **Lightweight (Ringan):** Interpreter Lua memiliki ukuran yang sangat kecil dan efisien dalam penggunaan memori, membuatnya ideal untuk aplikasi yang membutuhkan jejak memori minimal dan performa tinggi.

---

### 1.2 Sintaks Dasar dan Struktur

Sintaks dasar merujuk pada aturan penulisan kode dalam Lua, sedangkan struktur adalah bagaimana elemen-elemen kode tersebut diorganisir.

#### Komentar

Komentar adalah bagian dari kode sumber yang diabaikan oleh interpreter Lua. Komentar digunakan untuk memberikan penjelasan atau catatan dalam kode, sehingga memudahkan programmer lain (atau diri sendiri di masa depan) untuk memahami logika program.

**Jenis Komentar di Lua:**

1.  **Komentar Satu Baris (Single-line Comment):**

    - Dimulai dengan dua tanda hubung `--`.
    - Semua teks setelah `--` hingga akhir baris akan dianggap sebagai komentar.

2.  **Komentar Multi-Baris (Multi-line Comment):**
    - Dimulai dengan `--[[` dan diakhiri dengan `]]`.
    - Semua teks di antara penanda pembuka dan penutup akan dianggap sebagai komentar, bahkan jika mencakup beberapa baris.
    - Tip: Untuk menonaktifkan sementara blok komentar multi-baris, Anda bisa menambahkan satu tanda hubung lagi di awal, menjadi `---[[`. Ini akan mengubahnya menjadi komentar satu baris biasa, dan interpreter akan membaca `[[ ... ]]` sebagai bagian dari kode (jika sintaksnya valid).

**Contoh Kode:**

```lua
-- Ini adalah komentar satu baris.
-- Semua teks di sini akan diabaikan oleh interpreter Lua.

--[[
    Ini adalah contoh
    komentar yang mencakup
    beberapa baris sekaligus.
    Berguna untuk penjelasan yang lebih panjang.
]]
```

**Penjelasan Kode:**

- `-- Ini adalah komentar satu baris.`
  - Baris ini adalah contoh komentar satu baris. Interpreter Lua akan mengabaikan seluruh teks mulai dari `--` hingga akhir baris ini.
- `--[[ ... ]]`
  - Blok ini mendemonstrasikan komentar multi-baris. Semua teks yang berada di antara `--[[` dan `]]` dianggap sebagai komentar.

#### Statement dan Expression

Dalam Lua, program terdiri dari serangkaian _statement_ dan _expression_.

- **Statement (Pernyataan):** Sebuah instruksi lengkap yang melakukan suatu aksi atau tindakan. Setiap statement dieksekusi oleh interpreter Lua. Contoh statement meliputi assignment (pemberian nilai ke variabel), pemanggilan fungsi (function call), atau struktur kontrol (seperti `if` atau `while`). Di Lua, statement tidak perlu diakhiri dengan titik koma (`;`), meskipun diperbolehkan. Beberapa statement dapat ditulis dalam satu baris jika dipisahkan oleh titik koma.

- **Expression (Ekspresi):** Sebuah potongan kode yang menghasilkan (mengevaluasi menjadi) sebuah nilai. Ekspresi dapat terdiri dari kombinasi nilai literal (angka, string), variabel, operator, dan pemanggilan fungsi yang mengembalikan nilai.

**Contoh Kode:**

```lua
-- Contoh Statement
local x = 10         -- Ini adalah statement assignment.
print("Hello")       -- Ini adalah statement pemanggilan fungsi 'print'.

-- Contoh Expression
local result = x + 5   -- 'x + 5' adalah sebuah expression.
                       -- Keseluruhan baris ini adalah statement assignment.
```

**Penjelasan Kode:**

1.  `local x = 10`

    - Ini adalah sebuah **statement assignment**.
    - `local`: Kata kunci (keyword) yang mendeklarasikan variabel `x` sebagai variabel lokal. Penggunaan variabel lokal sangat direkomendasikan dalam pengembangan plugin untuk menghindari polusi namespace global (akan dibahas lebih lanjut).
    - `x`: Nama variabel.
    - `=`: Operator assignment, digunakan untuk memberikan nilai ke variabel.
    - `10`: Nilai literal numerik yang di-assign ke variabel `x`.

2.  `print("Hello")`

    - Ini adalah sebuah **statement pemanggilan fungsi**.
    - `print`: Fungsi bawaan Lua yang digunakan untuk menampilkan output ke konsol (atau standar output).
    - `("Hello")`: Argumen yang diberikan kepada fungsi `print`. Dalam kasus ini, argumennya adalah nilai literal string `"Hello"`. `"Hello"` itu sendiri adalah sebuah ekspresi string.

3.  `local result = x + 5`
    - Ini adalah sebuah **statement assignment**.
    - `local result`: Mendeklarasikan variabel lokal bernama `result`.
    - `=`: Operator assignment.
    - `x + 5`: Ini adalah sebuah **expression**.
      - `x`: Variabel yang nilainya (dari statement sebelumnya) adalah `10`.
      - `+`: Operator aritmatika untuk penjumlahan.
      - `5`: Nilai literal numerik.
      - Ekspresi `x + 5` akan dievaluasi menjadi `10 + 5`, yang menghasilkan nilai `15`. Nilai `15` inilah yang kemudian di-assign ke variabel `result`.
    - `-- x + 5 adalah expression`: Ini adalah komentar yang menjelaskan bahwa bagian `x + 5` dari statement tersebut merupakan sebuah expression.

Dengan memahami konsep dasar ini, Anda telah memiliki landasan awal untuk mempelajari aspek-aspek lain dari Lua yang lebih mendalam.

[1]: ../../README.md/#1-fondasi-dasar-lua
