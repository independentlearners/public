# LEVEL 1

<details>
<summary>Gemini 2.5 Pro</summary>
Sebelum kita membedah kurikulum string ini, mari kita lihat gambaran besarnya. Untuk benar-benar menguasai Lua, kamu perlu memahami beberapa pilar utama:

1.  **Dasar-dasar Bahasa:** Variabel, tipe data (termasuk string), operator, kontrol alur (if, for, while), dan fungsi.
2.  **Struktur Data Inti:** **Tables**. Ini adalah satu-satunya struktur data di Lua dan bisa digunakan untuk membuat array, dictionary (hash maps), dan objek. Menguasai _tables_ adalah kunci menguasai Lua.
3.  **Paradigma Pemrograman:** Pemrograman prosedural, fungsional, dan berorientasi objek (menggunakan metatables).
4.  **Standard Libraries:** Pustaka standar seperti `string`, `table`, `math`, `io`, dan `os`. Kurikulum yang kamu berikan ini adalah pendalaman _total_ untuk `string` library.
5.  **Manajemen Modul & Lingkungan:** `require`, `modules`, dan cara kerja lingkungan (_environments_) di Lua.
6.  **Integrasi Lanjutan:** C API untuk menyematkan Lua ke dalam aplikasi lain dan LuaJIT FFI untuk berinteraksi dengan kode C dari dalam Lua.

---

## **LEVEL 1: DASAR-DASAR STRING**

Level ini adalah fondasi mutlak. Memahaminya dengan benar akan membuat semua level berikutnya jauh lebih mudah. Ini tentang bagaimana Lua "melihat" dan "memperlakukan" teks.

### **1.1 Pengenalan String di Lua**

#### **Definisi dan konsep string sebagai immutable type**

- **Deskripsi Konkret:**
  **String** adalah urutan karakter yang digunakan untuk merepresentasikan teks. Pikirkan string sebagai "wadah" untuk huruf, angka, dan simbol. Contohnya: `"Halo Dunia"`, `"harga = 1000"`, atau `"!@#$%"`.

  Konsep terpenting di sini adalah **immutable** (tidak dapat diubah). Artinya, sekali kamu membuat sebuah string di Lua, kamu _tidak bisa mengubah isi dari string itu sendiri_. Jika kamu melakukan operasi yang terlihat seperti "mengubah" string (misalnya, menggabungkannya dengan string lain), Lua sebenarnya membuat string _baru_ di memori yang berisi hasil operasi tersebut.

  **Analogi:** Bayangkan kamu menulis sesuatu di selembar kertas dengan spidol permanen. Kamu tidak bisa menghapus atau mengubah tulisan itu. Jika kamu ingin "memperbaikinya", kamu harus mengambil selembar kertas baru dan menulis ulang semuanya dengan perbaikan tersebut. String di Lua bekerja seperti itu.

- **Terminologi:**

  - **String:** Tipe data untuk menyimpan teks.
  - **Immutable:** Nilainya tidak dapat diubah setelah dibuat.
  - **Karakter:** Satu unit tunggal dari teks, seperti 'a', 'B', atau '?'.

- **Contoh Kode & Penjelasan Sintaks:**
  Mari kita lihat bagaimana sifat _immutable_ ini bekerja.

  ```lua
  -- [[ Penjelasan Sintaks ]]
  -- local: Kata kunci untuk mendeklarasikan variabel lokal. Ini praktik yang baik
  --        untuk menjaga variabel agar tidak "bocor" ke lingkup global.
  -- nama: Nama variabel yang kita buat.
  -- =: Operator penugasan (assignment), untuk memberikan nilai ke variabel.
  -- "Budi": Nilai string yang kita berikan ke variabel 'nama'.

  local nama = "Budi"

  -- Sekarang, kita akan coba "mengubah" string ini.
  -- Operasi di bawah ini TIDAK mengubah string "Budi" yang asli.
  -- Sebaliknya, ia membuat string BARU ("Budi Luhur") dan menugaskannya
  -- kembali ke variabel 'nama'. Variabel 'nama' sekarang menunjuk ke
  -- string baru ini, sementara string "Budi" yang lama akan dihapus
  -- oleh garbage collector Lua jika tidak ada variabel lain yang menggunakannya.
  nama = nama .. " Luhur" -- '..' adalah operator konkatenasi (penggabungan)

  print(nama) -- Outputnya adalah "Budi Luhur"
  ```

  _Sumber Referensi: Programming in Lua (4th ed.), Chapter 2; Lua 5.4 Reference Manual, Section 2.1 & 3.4.6_

#### **Cara mendeklarasikan: single quote, double quote, long bracket**

- **Deskripsi Konkret:**
  Lua sangat fleksibel dalam cara kamu menulis string. Kamu punya tiga pilihan utama, masing-masing dengan kegunaan spesifik.

  1.  **Single Quotes (`'...'`):** Kutip tunggal. Berguna jika string-mu mengandung kutip ganda.
  2.  **Double Quotes (`"..."`):** Kutip ganda. Berguna jika string-mu mengandung kutip tunggal.
  3.  **Long Brackets (`[[...]]`):** Kurung siku ganda. Sangat berguna untuk string multi-baris atau string yang mengandung banyak kutip tunggal dan ganda, karena tidak ada karakter yang perlu di-"escape".

- **Sintaks Dasar:**

  - `'sebuah string'`
  - `"string yang lain"`
  - `[[string panjang atau multi-baris]]`

- **Contoh Kode & Penjelasan:**

  ```lua
  -- [[ Penjelasan Sintaks ]]
  -- '...' : Mendefinisikan string menggunakan kutip tunggal.
  local kalimat1 = 'Dia berkata, "Halo!"'

  -- "..." : Mendefinisikan string menggunakan kutip ganda.
  local kalimat2 = "Ini adalah 'kutipan' penting."

  -- [[...]] : Mendefinisikan string menggunakan long brackets.
  -- Perhatikan bagaimana kita tidak perlu khawatir tentang kutip di dalamnya.
  -- Baris baru juga akan dipertahankan persis seperti yang kita tulis.
  local html_snippet = [[
  <div>
      <h1>Judul Halaman</h1>
      <p>Dia berkata, "Ini 'mudah' sekali!"</p>
  </div>
  ]]

  -- Mencetak semua variabel untuk melihat hasilnya
  print(kalimat1)
  print(kalimat2)
  print(html_snippet)
  ```

  **Output:**

  ```
  Dia berkata, "Halo!"
  Ini adalah 'kutipan' penting.

  <div>
      <h1>Judul Halaman</h1>
      <p>Dia berkata, "Ini 'mudah' sekali!"</p>
  </div>
  ```

  _Sumber Referensi: GameDev Academy - "Lua String Tutorial Complete Guide" (2023); Programming in Lua, Chapter 2.4_

#### **String sebagai first-class citizen di Lua**

- **Deskripsi Konkret:**
  Istilah **"first-class citizen"** (warga kelas satu) dalam bahasa pemrograman berarti sebuah tipe data dapat diperlakukan sama seperti tipe data lainnya (seperti angka). Kamu bisa:

  - Menyimpannya dalam variabel.
  - Mengopernya sebagai argumen ke fungsi lain.
  - Mengembalikannya sebagai hasil dari sebuah fungsi.
  - Menyimpannya dalam _table_.

  Di Lua, string memiliki semua hak istimewa ini, sama seperti angka, fungsi, dan tables. Ini membuat manipulasi string menjadi sangat kuat dan fleksibel.

- **Terminologi:**

  - **First-Class Citizen:** Entitas pemrograman yang mendukung semua operasi yang umumnya tersedia untuk entitas lain, seperti penugasan, pengiriman parameter, dan pengembalian nilai.

- **Contoh Kode & Penjelasan:**

  ```lua
  -- [[ Penjelasan Sintaks ]]

  -- 1. Menyimpan string dalam variabel (sudah kita lakukan)
  local salam = "Selamat Pagi"

  -- 2. Mengoper string sebagai argumen ke fungsi
  -- 'print' adalah fungsi, dan kita memberikan variabel 'salam' sebagai argumennya.
  print(salam)

  -- 3. Mengembalikan string dari sebuah fungsi
  -- function ... end: Mendefinisikan sebuah fungsi.
  -- getPesan: Nama fungsi.
  -- return: Kata kunci untuk mengembalikan nilai dari fungsi.
  function getPesan()
      return "Ini pesan dari dalam fungsi"
  end

  local pesanDariFungsi = getPesan()
  print(pesanDariFungsi)

  -- 4. Menyimpan string dalam sebuah table
  -- {}: Sintaks untuk membuat table.
  -- "kunci" = "nilai": Pasangan kunci-nilai dalam table.
  local dataPengguna = {
      nama = "Citra",
      email = "citra@example.com",
      level = "Admin"
  }

  print("Nama Pengguna: " .. dataPengguna.nama) -- Mengakses string dari table
  ```

  _Sumber Referensi: Programming in Lua (4th ed.), Chapter 2_

---

### **1.2 Literal String dan Advanced Syntax**

Bagian ini memperdalam cara kita menulis string, terutama untuk kasus-kasus yang lebih rumit seperti menyertakan karakter "terlarang" atau teks yang membentang beberapa baris.

#### **String literal dengan berbagai quote styles**

- **Deskripsi Konkret:**
  Seperti yang sudah kita bahas sebelumnya, Lua memberikanmu pilihan antara kutip tunggal (`'`) dan kutip ganda (`"`). Secara fungsional, tidak ada perbedaan di antara keduanya. Pilihan ini murni untuk kenyamanan. Aturan praktisnya adalah:

  - Jika string-mu mengandung kutip tunggal (apostrof), gunakan kutip ganda untuk membungkusnya.
  - Jika string-mu mengandung kutip ganda, gunakan kutip tunggal untuk membungkusnya.
  - Ini menghindarimu dari keharusan menggunakan _escape sequences_ (yang akan kita bahas selanjutnya).

- **Contoh Kode & Penjelasan:**

  ```lua
  -- [[ Situasi 1: String berisi apostrof (kutip tunggal) ]]
  -- Menggunakan kutip ganda di luar membuat kita tidak perlu khawatir tentang ' di dalam.
  local possessive_string = "Ini adalah buku milik Budi's."
  print(possessive_string)

  -- [[ Situasi 2: String berisi kutipan (kutip ganda) ]]
  -- Menggunakan kutip tunggal di luar membuat kita tidak perlu khawatir tentang " di dalam.
  local quote_string = 'Seseorang berteriak, "Tolong!"'
  print(quote_string)

  -- [[ Situasi 3: Apa yang terjadi jika kita tidak mengikuti aturan? ]]
  -- Kode di bawah ini akan menghasilkan ERROR karena Lua mengira string selesai setelah Budi.
  -- local error_string = 'Ini adalah buku milik Budi's.' -- INI AKAN GAGAL
  ```

  _Sumber Referensi: GameDev Academy - "Lua String Tutorial Complete Guide" (2023); Programming in Lua Chapter 2.4_

#### **Escape sequences lengkap (\n, \t, \\, \", \', \a, \b, \f, \r, \v)**

- **Deskripsi Konkret:**
  **Escape Sequence** adalah cara untuk memberitahu Lua bahwa karakter berikutnya memiliki makna khusus. Ini diawali dengan _backslash_ (`\`). Kamu menggunakannya untuk memasukkan karakter yang tidak bisa diketik langsung, seperti baris baru, atau karakter yang memiliki makna sintaksis bagi Lua, seperti kutip itu sendiri.

- **Terminologi:**

  - **Escape Sequence:** Urutan karakter yang dimulai dengan `\` untuk merepresentasikan karakter lain.
  - **Literal:** Nilai yang ditulis langsung di dalam kode (misalnya, `123` adalah literal angka, `"halo"` adalah literal string).

- **Daftar Escape Sequence & Penjelasannya:**

  - `\n`: **New Line** (Baris Baru). Memindahkan kursor ke awal baris berikutnya. Ini yang paling umum digunakan.
  - `\t`: **Horizontal Tab**. Menambahkan spasi tab.
  - `\\`: **Backslash**. Karena `\` digunakan untuk memulai escape sequence, kamu butuh `\\` untuk menulis karakter `\` secara harfiah.
  - `\"`: **Double Quote**. Untuk menulis karakter `"` di dalam string yang dibungkus kutip ganda.
  - `\'`: **Single Quote**. Untuk menulis karakter `'` di dalam string yang dibungkus kutip tunggal.
  - `\a`: **Alert/Bell**. Menghasilkan suara "bip" singkat di terminal (tidak semua terminal mendukungnya).
  - `\b`: **Backspace**. Memundurkan kursor satu karakter.
  - `\f`: **Form Feed**. Karakter kontrol printer kuno, jarang digunakan sekarang.
  - `\r`: **Carriage Return**. Memindahkan kursor ke awal baris _saat ini_ tanpa pindah baris. Berguna untuk membuat progress bar di terminal.
  - `\v`: **Vertical Tab**. Jarang digunakan.

- **Contoh Kode & Penjelasan Sintaks:**

  ```lua
  -- [[ Penjelasan Sintaks ]]
  -- \n: Memasukkan baris baru
  -- \t: Memasukkan tab
  -- \": Memasukkan kutip ganda literal di dalam string kutip ganda
  -- \\: Memasukkan backslash literal

  local bio = "Nama:\tAndi\nProfesi:\t\"Programmer\"\nLokasi:\tC:\\Users\\Andi"

  print(bio)
  ```

  **Output dari kode di atas akan terlihat seperti ini:**

  ```
  Nama:   Andi
  Profesi:        "Programmer"
  Lokasi: C:\Users\Andi
  ```

  _Sumber Referensi: Programming in Lua Chapter 2.4_

#### **Long strings dengan `[[]]` dan nested brackets `[=[ ]=]`**

- **Deskripsi Konkret:**
  Kita sudah melihat `[[...]]` untuk string multi-baris. Tapi, bagaimana jika string multi-baris itu sendiri kebetulan mengandung teks `]]`? Ini akan membingungkan Lua, karena ia akan menganggap string sudah berakhir.

  Untuk mengatasi ini, Lua memperbolehkan kita menempatkan satu atau lebih tanda sama dengan (`=`) di antara kurung siku pembuka dan penutup. Misalnya, `[=[...]=]` atau `[==[...]==]`. Lua akan mencari kurung siku penutup yang memiliki jumlah `=` yang _sama persis_ untuk mengakhiri string.

- **Sintaks Dasar:**

  - `[[ Konten string ]]`
  - `[=[ Konten string yang mungkin berisi ]] ]=]`
  - `[==[ Konten string yang mungkin berisi ]] dan ]=] ]==]`

- **Contoh Kode & Penjelasan:**

  ```lua
  -- [[ Situasi 1: String biasa dengan long brackets ]]
  local komentar_biasa = [[
  Ini adalah blok komentar atau string multi-baris.
  ]]

  -- [[ Situasi 2: String yang mengandung "]]" ]]
  -- Bayangkan kita sedang menulis dokumentasi tentang sintaks long brackets itu sendiri.
  -- Jika kita menggunakan [[...]], kode ini akan error.

  -- [[ Penjelasan Sintaks ]]
  -- [=[ ... ]=]: Mendefinisikan string. Lua akan mencari sekuens penutup "]=]"
  --              bukan "]]". Ini memungkinkan kita untuk memiliki "]]" di dalam string.
  local komentar_kompleks = [=[
  Untuk menutup sebuah long string, gunakan "]]".
  Contoh: local s = [[contoh]]
  Ini adalah contoh yang valid.
  ]=]

  print(komentar_kompleks)
  ```

  **Output:**

  ```
  Untuk menutup sebuah long string, gunakan "]]".
  Contoh: local s = [[contoh]]
  Ini adalah contoh yang valid.
  ```

  _Sumber Referensi: GameDev Academy - "Lua String Tutorial Complete Guide" (2023); Programming in Lua Chapter 2.4_

#### **Multiline strings dan preservasi formatting**

- **Deskripsi Konkret:**
  Fitur utama dari _long brackets_ (`[[...]]`) adalah kemampuannya untuk menjaga format teks persis seperti saat kamu mengetiknya, termasuk semua spasi, tab, dan baris baru. Ini sangat berguna untuk menyematkan potongan kode, ASCII art, atau teks terformat lainnya langsung di dalam kodemu.

- **Perilaku Penting:**
  Satu hal yang perlu diperhatikan adalah _newline_ (baris baru) tepat setelah `[[`. Jika kamu menekan Enter setelah `[[`, baris baru itu akan menjadi bagian dari stringmu.

- **Contoh Kode & Penjelasan:**

  ```lua
  -- [[ Contoh 1: ASCII Art ]]
  -- Semua spasi dan baris baru akan dipertahankan.
  local ascii_art = [[
    / \
   / _ \
  ( o.o )
   > ^ <
  ]]
  print(ascii_art)


  -- [[ Contoh 2: Perilaku newline di awal ]]
  -- Perhatikan perbedaan antara string_A dan string_B
  local string_A = [[
  Teks ini diawali dengan baris baru.]]

  local string_B = [[Teks ini tidak diawali dengan baris baru.]]

  print("--- String A ---")
  print(string_A)
  print("--- String B ---")
  print(string_B)
  ```

  **Output:**

  ```
    / \
   / _ \
  ( o.o )
   > ^ <

  --- String A ---

  Teks ini diawali dengan baris baru.
  --- String B ---
  Teks ini tidak diawali dengan baris baru.
  ```

  _Sumber Referensi: GameDev Academy - "Lua String Tutorial Complete Guide" (2023)_

### **1.3 Operasi Fundamental**

Di sini kita akan mempelajari operasi dasar yang paling sering kamu lakukan pada string: menggabungkannya, mengukur panjangnya, membandingkannya, dan bagaimana Lua secara ajaib dapat mengubahnya menjadi tipe lain.

#### **Konkatenasi dengan operator (..) dan performance implications**

- **Deskripsi Konkret:**
  **Konkatenasi** adalah istilah teknis untuk "menggabungkan dua atau lebih string menjadi satu". Di Lua, kamu melakukan ini menggunakan operator dua titik (`..`). Ini adalah salah satu operasi string yang paling umum.

  Namun, ada "implikasi performa" yang penting. Ingat, string di Lua itu _immutable_ (tidak bisa diubah). Saat kamu menggabungkan `stringA .. stringB`, Lua tidak mengubah `stringA`. Sebaliknya, ia membuat string _ketiga_ yang baru di memori, yang merupakan salinan dari `stringA` diikuti oleh salinan `stringB`.

  Jika kamu hanya menggabungkan dua atau tiga string, ini bukan masalah. Tapi jika kamu melakukannya ratusan atau ribuan kali di dalam sebuah _loop_ (perulangan), ini bisa menjadi lambat dan boros memori karena Lua harus terus-menerus membuat string-string baru. (Kurikulum ini akan membahas solusi yang lebih efisien di Level 4.3).

- **Terminologi:**

  - **Konkatenasi (Concatenation):** Proses menggabungkan string dari ujung ke ujung.
  - **Operator:** Simbol yang melakukan operasi pada satu atau lebih nilai (operan). Di sini, `..` adalah operatornya.

- **Sintaks Dasar:**

  - `string1 .. string2`

- **Contoh Kode & Penjelasan Sintaks:**

  ```lua
  -- [[ Penjelasan Sintaks ]]
  -- .. : Operator konkatenasi. Ia mengambil string di kiri dan kanannya,
  --      lalu menghasilkan string baru yang merupakan gabungan keduanya.

  local kata1 = "Selamat"
  local kata2 = "Datang"
  local spasi = " "

  -- Menggabungkan tiga string menjadi satu string baru.
  local kalimat = kata1 .. spasi .. kata2 .. " di Dunia Lua!"

  print(kalimat)

  -- Contoh di dalam loop (ilustrasi masalah performa)
  local hasil = "" -- Mulai dengan string kosong
  for i = 1, 5 do -- Lakukan perulangan 5 kali
    -- Di setiap iterasi, sebuah string BARU dibuat.
    -- Iterasi 1: "" .. "a" -> "a"
    -- Iterasi 2: "a" .. "a" -> "aa" (string "a" dibuang)
    -- Iterasi 3: "aa" .. "a" -> "aaa" (string "aa" dibuang)
    -- dan seterusnya... ini tidak efisien untuk loop besar.
    hasil = hasil .. "a"
  end
  print(hasil)
  ```

  **Output:**

  ```
  Selamat Datang di Dunia Lua!
  aaaaa
  ```

  _Sumber Referensi: Lua 5.4 Reference Manual, Section 3.4.6; LuaScripts.com - "Mastering Lua Strings" (2025)_

#### **Length operator (#) vs string.len()**

- **Deskripsi Konkret:**
  Untuk mengetahui panjang sebuah string, Lua menyediakan dua cara: operator panjang (`#`) dan fungsi dari pustaka string (`string.len()`). Keduanya melakukan hal yang sama persis: mengembalikan jumlah **byte** dalam string.

  - **Operator `#`**: Ditempatkan sebelum string atau variabel string. Ini lebih singkat dan dianggap lebih "idiomatic" (gaya yang lebih umum dan disukai) oleh para programmer Lua.
  - **Fungsi `string.len()`**: Cara yang lebih eksplisit, memanggil fungsi `len` dari _library_ `string`.

  **Poin Sangat Penting:** Untuk karakter standar (ASCII, seperti A-Z, 0-9), satu karakter sama dengan satu byte. Namun, untuk karakter non-standar (seperti 'é', 'ล', atau emoji '😀'), satu karakter bisa memakan lebih dari satu byte (ini disebut UTF-8). Jadi, `#` dan `string.len()` akan menghitung jumlah byte, bukan jumlah karakter visual. Kita akan membahas cara menangani ini dengan benar di Level 5 (UTF-8).

- **Sintaks Dasar:**

  - `#namastring`
  - `string.len(namastring)`

- **Contoh Kode & Penjelasan Sintaks:**

  ```lua
  local teks = "Halo Dunia"

  -- [[ Penjelasan Sintaks ]]
  -- #teks : Menggunakan operator panjang untuk mendapatkan jumlah byte dari string
  --         yang disimpan di variabel 'teks'.
  local panjang1 = #teks
  print("Panjang via #: " .. panjang1)

  -- [[ Penjelasan Sintaks ]]
  -- string.len(teks): Memanggil fungsi 'len' dari pustaka 'string' dan memberikan
  --                    variabel 'teks' sebagai argumennya.
  local panjang2 = string.len(teks)
  print("Panjang via string.len(): " .. panjang2)

  -- Contoh dengan karakter multi-byte (ilustrasi byte vs karakter)
  local teks_utf8 = "你好" -- "nǐ hǎo", 2 karakter visual
  print("Panjang byte dari '你好': " .. #teks_utf8) -- Outputnya akan 6, karena setiap karakter ini 3 byte.
  ```

  **Output:**

  ```
  Panjang via #: 10
  Panjang via string.len(): 10
  Panjang byte dari '你好': 6
  ```

  _Sumber Referensi: Lua 5.4 Reference Manual, Section 3.4.6 & 6.4_

#### **String comparison dan lexicographic ordering**

- **Deskripsi Konkret:**
  Kamu bisa membandingkan string menggunakan operator perbandingan standar: `==` (sama dengan), `~=` (tidak sama dengan), `<` (kurang dari), `>` (lebih dari), `<=` (kurang dari atau sama dengan), dan `>=` (lebih dari atau sama dengan).

  - `==` dan `~=`: Memeriksa apakah dua string identik secara keseluruhan.
  - `<`, `>`, `<=`, `>=`: Bekerja berdasarkan **urutan leksikografis** (lexicographical order). Ini pada dasarnya adalah urutan "kamus", tetapi berdasarkan nilai numerik dari byte setiap karakter. Dalam standar yang paling umum (ASCII/UTF-8), urutan kasarnya adalah: karakter kontrol < spasi < angka < huruf besar < huruf kecil. Ini berarti `"Zebra"` akan dianggap "kurang dari" `"apple"`.

- **Terminologi:**

  - **Lexicographical Order:** Pengurutan berdasarkan nilai numerik dari karakter, satu per satu dari kiri ke kanan.

- **Contoh Kode & Penjelasan:**

  ```lua
  -- Perbandingan kesetaraan
  print("apel" == "apel")   -- true (sama persis)
  print("apel" == "Apel")   -- false (case-sensitive, 'a' berbeda dari 'A')
  print("apel" ~= "jeruk")  -- true (memang tidak sama)

  -- Perbandingan leksikografis
  print("apple" < "banana") -- true, karena 'a' < 'b'
  print("Zebra" < "apple")  -- true, karena 'Z' (byte 90) < 'a' (byte 97)
  print("cat" > "car")      -- true, karena pada karakter ke-3, 't' > 'r'
  print("book" >= "book")   -- true, karena sama dengan
  ```

  **Output:**

  ```
  true
  false
  true
  true
  true
  true
  true
  ```

  _Sumber Referensi: Lua 5.4 Reference Manual, Section 3.4.5_

#### **Automatic type conversion (coercion)**

- **Deskripsi Konkret:**
  **Coercion** (pemaksaan/konversi otomatis) adalah fitur di Lua di mana ia secara otomatis mengubah tipe data sebuah nilai agar sesuai dengan konteks operasi.

  - Jika kamu menggunakan string yang berisi angka dalam operasi matematika (seperti `+`, `-`, `*`, `/`), Lua akan mencoba mengubah string itu menjadi angka.
  - Jika kamu menggunakan angka dalam operasi konkatenasi string (`..`), Lua akan mengubah angka itu menjadi string.

  Fitur ini membuat beberapa hal menjadi lebih nyaman, tetapi juga bisa berbahaya jika tidak hati-hati, karena dapat menyembunyikan kesalahan dalam logika programmu. Praktik yang lebih aman (terutama dalam proyek besar) adalah melakukan konversi secara manual menggunakan `tonumber()` dan `tostring()`, yang akan dibahas di Level 4.2.

- **Terminologi:**

  - **Coercion / Type Coercion:** Konversi tipe data otomatis oleh bahasa pemrograman.

- **Contoh Kode & Penjelasan:**

  ```lua
  -- [[ Coercion: String ke Angka ]]
  -- Lua melihat string "10" dan "5" digunakan dengan operator aritmatika '-'.
  -- Ia secara otomatis mengubahnya menjadi angka 10 dan 5 sebelum melakukan pengurangan.
  local hasil_angka = "10" - "5"
  print(hasil_angka) -- Outputnya adalah angka 5, bukan string "5"
  print(type(hasil_angka)) -- Outputnya akan "number"

  -- [[ Coercion: Angka ke String ]]
  -- Lua melihat angka 2025 digunakan dengan operator konkatenasi '..'.
  -- Ia secara otomatis mengubahnya menjadi string "2025" sebelum menggabungkannya.
  local kalimat = "Tahun sekarang adalah " .. 2025
  print(kalimat)
  print(type(kalimat)) -- Outputnya akan "string"

  -- [[ Contoh di mana Coercion bisa gagal ]]
  -- Baris di bawah ini akan menyebabkan error karena "sepuluh" tidak bisa diubah menjadi angka.
  -- local error = "sepuluh" + 5
  ```

  **Output:**

  ```
  5
  number
  Tahun sekarang adalah 2025
  string
  ```

  _Sumber Referensi: Lua 5.4 Reference Manual, Section 3.4.3_

---

Selamat! Kamu telah menyelesaikan **Level 1** dari kurikulum string Lua. Kamu sekarang memiliki fondasi yang kokoh tentang apa itu string, bagaimana cara membuatnya, dan operasi paling mendasar yang bisa dilakukan. Berikutnya, kita akan naik ke **Level 2: String Library Functions**, di mana kita akan mulai menjelajahi "perkakas" bawaan Lua yang sangat kuat untuk memanipulasi string secara lebih canggih.

</details>

#

<details>
<summary>Gemini 2.5 Flash</summary>

# **LEVEL 1: DASAR-DASAR STRING**

Level ini adalah fondasi penting untuk memahami bagaimana string bekerja di Lua. Kita akan membahas definisi, cara deklarasi, dan sifat dasar dari string.

### **1.1 Pengenalan String di Lua**

Bagian ini memperkenalkan apa itu string dalam konteba Lua.

- **Definisi dan Konsep String sebagai Immutable Type**

  - **Definisi String**: Dalam pemrograman, **string** adalah urutan karakter, seperti huruf, angka, simbol, atau spasi, yang diperlakukan sebagai satu kesatuan teks. Contoh string adalah "Halo Dunia!", "12345", atau "belajar Lua".
  - **Konsep Immutable Type**: Ini adalah konsep yang sangat penting di Lua. **Immutable** berarti "tidak dapat diubah". Setelah sebuah string dibuat di Lua, Anda tidak bisa mengubah karakter di dalamnya atau menambahkan/menghilangkan karakter dari string tersebut. Jika Anda ingin "mengubah" sebuah string, sebenarnya Anda membuat string baru berdasarkan string yang lama. Ini mirip dengan jika Anda punya sebuah buku, Anda tidak bisa mengubah kata-kata di halaman aslinya. Jika Anda ingin "mengubah" teks di buku tersebut, Anda harus menulis ulang bagian tersebut di halaman baru atau buku baru.
    - **Terminologi**:
      - **Tipe Data (Data Type)**: Kategori nilai yang dapat disimpan dalam program, seperti angka (number), teks (string), atau benar/salah (boolean). String adalah salah satu tipe data dasar di Lua.
      - **Immutable**: Suatu objek yang nilainya tidak dapat diubah setelah dibuat.
      - **Mutable**: Kebalikan dari immutable; suatu objek yang nilainya dapat diubah setelah dibuat. (String di Lua bersifat immutable, tapi ada tipe data lain seperti `table` yang bersifat mutable).
    - **Mengapa Penting?**: Sifat immutable ini memiliki implikasi pada performa dan bagaimana Anda akan memanipulasi string di Lua. Anda akan melihat ini lebih jelas di bagian "Operasi Fundamental" dan "Efficient String Building".
  - **Sumber Terverifikasi**: "Programming in Lua" (4th edition) - Roberto Ierusalimschy, Chapter 2.

- **Cara Mendeklarasikan: Single Quote, Double Quote, Long Bracket**

  Di Lua, ada beberapa cara untuk membuat atau mendeklarasikan sebuah string. Ini memberikan fleksibilitas tergantung pada isi string Anda.

  1.  **Menggunakan Single Quote (`'`)**: Ini adalah cara paling umum untuk mendeklarasikan string pendek yang tidak mengandung karakter _single quote_ di dalamnya.

      - **Sintaks Dasar**: `'karakter-karakter'`
      - **Contoh Kode**:

        ```lua
        local nama = 'Budi'
        -- 'local' adalah keyword di Lua untuk mendeklarasikan variabel lokal.
        -- 'nama' adalah nama variabel.
        -- '=' adalah operator penugasan (assignment operator) untuk memberikan nilai ke variabel.
        -- ''Budi'' adalah string yang dideklarasikan menggunakan single quote.

        local pesan = 'Ini adalah string dengan single quote.'
        -- 'pesan' adalah variabel baru.
        -- 'Ini adalah string dengan single quote.' adalah nilai string-nya.

        print(nama)
        -- 'print()' adalah fungsi built-in di Lua untuk menampilkan output ke konsol.
        -- Output: Budi

        print(pesan)
        -- Output: Ini adalah string dengan single quote.
        ```

        - **Penjelasan per Sintaksis**:
          - `local`: Kata kunci (keyword) yang digunakan untuk menyatakan bahwa variabel yang akan dideklarasikan hanya dapat diakses dalam blok kode tempat ia dideklarasikan (variabel lokal).
          - `nama`: Nama variabel yang akan menyimpan nilai string.
          - `'Budi'`: Sebuah literal string (nilai string yang ditulis langsung dalam kode) yang dimulai dan diakhiri dengan tanda kutip tunggal.
          - `print()`: Sebuah fungsi bawaan Lua yang digunakan untuk menampilkan nilai ke konsol.
          - `pesan`: Nama variabel lain untuk menyimpan nilai string.
          - `'Ini adalah string dengan single quote.'`: Literal string lain.

  2.  **Menggunakan Double Quote (`"`)**: Sama seperti single quote, tetapi sering digunakan untuk string yang berisi karakter _single quote_.

      - **Sintaks Dasar**: `"karakter-karakter"`
      - **Contoh Kode**:

        ```lua
        local judul = "Belajar \"String\" di Lua"
        -- 'judul' adalah variabel.
        -- "Belajar \"String\" di Lua" adalah string yang menggunakan double quote.
        -- Perhatikan penggunaan '\' sebelum '"' untuk memberitahu Lua bahwa double quote di dalam string adalah bagian dari string itu sendiri, bukan penutup string. Ini disebut 'escape sequence'.

        local kutipan = "Dia berkata, 'Ini luar biasa!'"
        -- Karena string dideklarasikan dengan double quote, single quote di dalamnya tidak perlu di-escape.

        print(judul)
        -- Output: Belajar "String" di Lua

        print(kutipan)
        -- Output: Dia berkata, 'Ini luar biasa!'
        ```

        - **Penjelasan per Sintaksis**:
          - `"Belajar \"String\" di Lua"`: Literal string yang dimulai dan diakhiri dengan tanda kutip ganda. `\"` adalah _escape sequence_ untuk menyertakan tanda kutip ganda di dalam string tanpa mengakhiri string.
          - `"Dia berkata, 'Ini luar biasa!'"`: Literal string lain. Tanda kutip tunggal di dalamnya tidak perlu di-escape karena string didefinisikan dengan tanda kutip ganda.

  3.  **Menggunakan Long Bracket (`[[]]`)**: Ini adalah cara khusus di Lua untuk mendeklarasikan string multi-baris atau string yang mengandung banyak tanda kutip. Keunggulan utamanya adalah string di dalamnya tidak memproses _escape sequences_ (kecuali `\z` atau `\x`). Ini sangat berguna untuk blok teks panjang atau kode.

      - **Sintaks Dasar**: `[[karakter-karakter]]`
      - **Contoh Kode**:

        ```lua
        local kode_lua = [[
        function greet(name)
            print("Hello, " .. name .. "!")
        end
        greet("Pengguna")
        ]]
        -- 'kode_lua' adalah variabel.
        -- [[ ... ]] adalah string literal panjang (long string).
        -- Semua spasi, baris baru, dan indentasi di dalam long bracket akan dipertahankan.

        local cerita = [[
        Ini adalah sebuah cerita.
        "Dia berkata, 'Lua itu mudah!'"
        Dan begitulah cerita berakhir.
        ]]
        -- Tanda kutip tunggal dan ganda di dalam long string tidak perlu di-escape.

        print(kode_lua)
        -- Output:
        -- function greet(name)
        --     print("Hello, " .. name .. "!")
        -- end
        -- greet("Pengguna")

        print(cerita)
        -- Output:
        -- Ini adalah sebuah cerita.
        -- "Dia berkata, 'Lua itu mudah!'"
        -- Dan begitulah cerita berakhir.
        ```

        - **Penjelasan per Sintaksis**:
          - `[[ ... ]]`: Ini adalah bentuk literal string panjang atau "long string" di Lua. Semua karakter di antara `[[` dan `]]`, termasuk baris baru, spasi, dan tanda kutip, diperlakukan sebagai bagian dari string secara harfiah tanpa perlu _escaping_.
          - `function greet(name)...end`: Ini adalah definisi fungsi Lua yang disertakan sebagai bagian dari string.
          - `print("Hello, " .. name .. "!")`: Contoh penggunaan konkatenasi string (akan dibahas nanti).

  - **Terminologi**:
    - **Literal String**: Nilai string yang ditulis langsung dalam kode sumber program.
    - **Escape Sequence**: Kombinasi karakter yang diawali dengan _backslash_ (`\`) yang mewakili karakter khusus (misalnya `\n` untuk baris baru, `\"` untuk tanda kutip ganda).
    - **Multi-baris (Multiline)**: String yang dapat membentang lebih dari satu baris dalam kode sumber.
  - **Sumber Terverifikasi**: Lua 5.4 Reference Manual Section 2.1.

- **String sebagai First-Class Citizen di Lua**

  Konsep "first-class citizen" (warga negara kelas satu) dalam pemrograman berarti bahwa string (atau elemen pemrograman lainnya seperti fungsi) diperlakukan sama seperti tipe data lainnya, seperti angka.

  - **Apa Artinya?**:
    - Anda bisa menyimpan string dalam variabel.
    - Anda bisa meneruskan string sebagai argumen ke fungsi.
    - Anda bisa mengembalikan string dari fungsi.
    - Anda bisa menyimpan string dalam struktur data (seperti tabel).
  - **Mengapa Penting?**: Ini menunjukkan fleksibilitas dan kekuatan string di Lua. Anda tidak terbatas pada penggunaan string hanya sebagai label atau output sederhana, tetapi dapat memanipulasinya secara dinamis dalam program Anda.
  - **Contoh Kode**:

    ```lua
    -- 1. Menyimpan string dalam variabel (sudah kita lihat)
    local nama_produk = "Laptop Gaming"
    print(nama_produk)

    -- 2. Meneruskan string sebagai argumen ke fungsi
    function sapa(nama_pengguna)
        print("Halo, " .. nama_pengguna .. "!")
    end
    sapa("Alice")
    -- 'sapa' adalah nama fungsi.
    -- 'nama_pengguna' adalah parameter fungsi yang akan menerima nilai string.
    -- "Alice" adalah string yang diteruskan sebagai argumen.

    -- 3. Mengembalikan string dari fungsi
    function dapatkan_pesan()
        return "Pesan penting: Hari ini cerah!"
    end
    local info = dapatkan_pesan()
    print(info)
    -- 'dapatkan_pesan' adalah nama fungsi.
    -- 'return "Pesan penting: Hari ini cerah!"' mengembalikan string dari fungsi.
    -- 'info' adalah variabel yang menyimpan string yang dikembalikan.

    -- 4. Menyimpan string dalam tabel (struktur data)
    local daftar_belanja = {
        "Apel",
        "Susu",
        "Roti",
        "Telur"
    }
    print(daftar_belanja[1]) -- Mengakses elemen pertama dari tabel. Lua array dimulai dari indeks 1.
    -- Output: Apel
    ```

    - **Penjelasan per Sintaksis**:
      - `function sapa(nama_pengguna)...end`: Mendefinisikan sebuah fungsi bernama `sapa` yang menerima satu argumen `nama_pengguna`.
      - `sapa("Alice")`: Memanggil fungsi `sapa` dan meneruskan literal string `"Alice"` sebagai argumen.
      - `return "Pesan penting: Hari ini cerah!"`: Mengembalikan nilai string dari fungsi `dapatkan_pesan`.
      - `local daftar_belanja = {...}`: Mendeklarasikan sebuah variabel `daftar_belanja` dan menginisialisasinya dengan sebuah tabel. Tabel ini berisi beberapa nilai string.
      - `daftar_belanja[1]`: Mengakses elemen pertama dari tabel `daftar_belanja`. Di Lua, indeks tabel dimulai dari 1 secara default.

  - **Sumber Terverifikasi**: "Programming in Lua" (4th edition) - Roberto Ierusalimschy, Chapter 2.

---

### **1.2 Literal String dan Advanced Syntax**

Bagian ini mendalami lebih lanjut tentang cara menulis string literal dan fitur-fitur sintaksis lanjutan yang berguna.

- **String Literal dengan Berbagai Quote Styles**

  Ini adalah ringkasan dari apa yang telah kita bahas di 1.1, menekankan fleksibilitas dalam memilih gaya kutipan:

  - **Single Quote (`'`)**: Cocok untuk string sederhana.
  - **Double Quote (`"`)**: Berguna jika string Anda perlu menyertakan single quote, atau jika Anda lebih terbiasa dengan gaya ini dari bahasa lain.
  - **Long Bracket (`[[]]`)**: Ideal untuk teks panjang, multi-baris, atau string yang mengandung banyak tanda kutip yang akan menyulitkan _escaping_.
  - **Contoh Gabungan**:

    ```lua
    local s1 = 'Hello, Lua!'
    local s2 = "Dia berkata, 'Ini menyenangkan.'"
    local s3 = [[
    Ini adalah blok teks panjang.
    Yang bisa mengandung "kutipan ganda" atau 'kutipan tunggal'.
    Dan juga karakter khusus seperti \n (baris baru) atau \t (tab) tanpa diinterpretasikan,
    karena ini adalah long string.
    ]]

    print(s1)
    print(s2)
    print(s3)
    ```

- **Escape Sequences Lengkap (\n, \t, \\, \", \', \a, \b, \f, \r, \v)**

  Ketika Anda menggunakan single atau double quote untuk mendeklarasikan string, beberapa karakter tidak dapat ditulis langsung atau memiliki makna khusus. **Escape sequences** adalah cara untuk merepresentasikan karakter-karakter khusus ini. Mereka selalu dimulai dengan _backslash_ (`\`).

  - **Terminologi**:
    - **Escape Sequence**: Sebuah urutan karakter yang dimulai dengan _backslash_ (`\`) yang digunakan untuk merepresentasikan karakter khusus yang tidak dapat langsung diketik atau memiliki makna kontrol dalam string.
  - **Daftar Escape Sequences di Lua**:

    - `\a`: Bell (alarm) - Mengeluarkan suara alarm atau "bip" (tergantung terminal).
    - `\b`: Backspace - Memindahkan kursor satu posisi ke belakang.
    - `\f`: Form feed - Memindahkan kursor ke halaman berikutnya atau awal halaman baru (jarang digunakan di era modern).
    - `\n`: Newline (baris baru) - Memulai baris baru. Ini adalah yang paling sering digunakan.
    - `\r`: Carriage return - Memindahkan kursor ke awal baris saat ini (tanpa memulai baris baru).
    - `\t`: Horizontal tab - Menyisipkan karakter tab.
    - `\v`: Vertical tab - Menyisipkan tab vertikal (jarang digunakan).
    - `\\`: Backslash - Untuk menampilkan karakter _backslash_ itu sendiri.
    - `\"`: Double quote - Untuk menampilkan tanda kutip ganda di dalam string yang dideklarasikan dengan double quote.
    - `\'`: Single quote - Untuk menampilkan tanda kutip tunggal di dalam string yang dideklarasikan dengan single quote.
    - `\DDD`: Karakter yang direpresentasikan oleh nilai desimal `DDD` (0-255).
    - `\xHH`: Karakter yang direpresentasikan oleh nilai heksadesimal `HH` (00-FF).

  - **Contoh Kode**:

    ```lua
    local baris_baru = "Ini baris pertama.\nIni baris kedua."
    -- '\n' membuat baris baru.
    print(baris_baru)
    -- Output:
    -- Ini baris pertama.
    -- Ini baris kedua.

    local tabulasi = "Kolom1\tKolom2\tKolom3"
    -- '\t' menyisipkan tabulasi.
    print(tabulasi)
    -- Output: Kolom1    Kolom2    Kolom3

    local backslash_char = "Ini sebuah backslash: \\"
    -- '\\' digunakan untuk menampilkan karakter '\' itu sendiri.
    print(backslash_char)
    -- Output: Ini sebuah backslash: \

    local kutip_ganda = "Saya suka \"Lua\" programming."
    -- '\"' digunakan untuk menyisipkan tanda kutip ganda di dalam string yang dideklarasikan dengan double quote.
    print(kutip_ganda)
    -- Output: Saya suka "Lua" programming.

    local kutip_tunggal = 'Dia berkata, \'Halo!\''
    -- '\'' digunakan untuk menyisipkan tanda kutip tunggal di dalam string yang dideklarasikan dengan single quote.
    print(kutip_tunggal)
    -- Output: Dia berkata, 'Halo!'

    local karakter_ascii = "Karakter 65 (ASCII): \65"
    -- '\65' merepresentasikan karakter dengan nilai ASCII 65, yaitu 'A'.
    print(karakter_ascii)
    -- Output: Karakter 65 (ASCII): A

    local karakter_hex = "Karakter 0x41 (Hex): \x41"
    -- '\x41' merepresentasikan karakter dengan nilai heksadesimal 41, yaitu 'A'.
    print(karakter_hex)
    -- Output: Karakter 0x41 (Hex): A
    ```

    - **Penjelasan per Sintaksis**:
      - `"Ini baris pertama.\nIni baris kedua."`: Literal string dengan _escape sequence_ `\n` yang menghasilkan karakter baris baru.
      - `"Kolom1\tKolom2\tKolom3"`: Literal string dengan _escape sequence_ `\t` yang menghasilkan karakter tab horizontal.
      - `"Ini sebuah backslash: \\"`: Literal string dengan _escape sequence_ `\\` yang menghasilkan karakter _backslash_ itu sendiri.
      - `"Saya suka \"Lua\" programming."`: Literal string dengan _escape sequence_ `\"` yang menghasilkan tanda kutip ganda di dalam string yang dibatasi oleh tanda kutip ganda.
      - `'Dia berkata, \'Halo!\''`: Literal string dengan _escape sequence_ `\'` yang menghasilkan tanda kutip tunggal di dalam string yang dibatasi oleh tanda kutip tunggal.
      - `"Karakter 65 (ASCII): \65"`: Literal string dengan _escape sequence_ `\65` yang menginterpretasikan `65` sebagai nilai desimal ASCII dan mengubahnya menjadi karakter yang sesuai (dalam hal ini, 'A').
      - `"Karakter 0x41 (Hex): \x41"`: Literal string dengan _escape sequence_ `\x41` yang menginterpretasikan `41` sebagai nilai heksadesimal dan mengubahnya menjadi karakter yang sesuai ('A').

  - **Sumber Terverifikasi**: GameDev Academy - "Lua String Tutorial Complete Guide" (2023), Programming in Lua Chapter 2.4.

- **Long Strings dengan [[]] dan Nested Brackets [=[ ]=]**

  Kita sudah melihat `[[]]` sebagai cara untuk membuat long string tanpa _escape sequences_. Namun, ada kasus di mana string Anda mungkin mengandung `]]` itu sendiri. Untuk mengatasi ini, Lua menyediakan sintaks "nested brackets".

  - **Sintaks Dasar Nested Brackets**: `[=[ ... ]=]`
    - Anda bisa menambahkan sejumlah tanda `=` di antara `[` dan `[` (atau `]` dan `]`). Jumlah tanda `=` harus sama di awal dan akhir.
    - Ini memungkinkan Anda untuk menyertakan `]]` atau `]=]` dalam string Anda.
  - **Contoh Kode**:

    ```lua
    local xml_data = [[
    <root>
        <item id="1">Ini adalah isi.</item>
    </root>
    ]]
    print(xml_data)

    local lua_code_with_brackets = [=[
    local x = [[Ini adalah string di dalam string long bracket asli]]
    print(x)
    -- Anda bahkan bisa memiliki [[more nested]] brackets di sini!
    -- Ini akan berakhir ketika menemukan ]=] yang cocok.
    ]=]
    print(lua_code_with_brackets)

    local another_example = [===[
    Ini adalah string yang memiliki ]==] di dalamnya.
    Dan juga ]=] di dalamnya.
    Kita menggunakan [=== untuk memulai dan ]===] untuk mengakhiri.
    ]===]
    print(another_example)
    ```

    - **Penjelasan per Sintaksis**:
      - `[[ ... ]]`: Seperti yang sudah dijelaskan, untuk string multi-baris dan tidak perlu _escaping_. Cocok untuk data XML sederhana.
      - `[=[ ... ]=]`: Sebuah long string yang menggunakan satu tanda `=` di antara tanda kurung siku pembuka dan penutup. Ini berarti string ini akan berakhir hanya ketika menemukan `]=]`. Ini memungkinkan string di dalamnya untuk memiliki `]]` (tanpa tanda `=` di tengah) tanpa mengakhirinya.
      - `local x = [[Ini adalah string di dalam string long bracket asli]]`: Ini adalah contoh _nested long string_ di dalam long string yang lebih besar.
      - `[===[ ... ]===]`: Sebuah long string yang menggunakan tiga tanda `=` di antara tanda kurung siku. Ini berarti string ini akan berakhir hanya ketika menemukan `]===]`. Ini sangat berguna ketika string Anda sendiri mengandung urutan seperti `]]` atau `]=]` yang akan mengganggu sintaks `[[]]` atau `[=[]=]`.

  - **Sumber Terverifikasi**: Programming in Lua Chapter 2.4.

- **Multiline Strings dan Preservasi Formatting**

  Topik ini sudah sedikit tersentuh. Long strings (`[[]]`) secara otomatis mempertahankan semua spasi, tab, dan baris baru yang Anda masukkan di antara `[[` dan `]]`. Ini sangat berbeda dengan string yang dideklarasikan dengan single atau double quote, di mana Anda harus secara eksplisit menggunakan `\n` atau `\t` untuk format.

  - **Keunggulan**:
    - **Keterbacaan**: Kode Anda menjadi lebih mudah dibaca untuk blok teks panjang.
    - **Kemudahan**: Anda tidak perlu khawatir tentang _escaping_ setiap baris baru atau karakter khusus.
    - **Format WYSIWYG (What You See Is What You Get)**: Teks dalam editor Anda akan terlihat persis seperti yang akan dihasilkan saat program dijalankan.
  - **Contoh Kode**:

    ```lua
    local puisi = [[
    Malam sunyi, bintang berkelip,
        Angin berbisik, membawa mimpi.
    Di cakrawala, rembulan memudar,
    Menyisakan jejak, di hati yang sepi.
    ]]
    -- Perhatikan indentasi dan baris baru dipertahankan persis seperti yang ditulis.
    print(puisi)
    -- Output:
    -- Malam sunyi, bintang berkelip,
    --     Angin berbisik, membawa mimpi.
    -- Di cakrawala, rembulan memudar,
    -- Menyisakan jejak, di hati yang sepi.

    -- Bandingkan dengan cara manual:
    local puisi_manual = "Malam sunyi, bintang berkelip,\n\tAngin berbisik, membawa mimpi.\nDi cakrawala, rembulan memudar,\nMenyisakan jejak, di hati yang sepi."
    print(puisi_manual)
    -- Hasilnya sama, tapi cara penulisan 'puisi' jauh lebih mudah dibaca.
    ```

    - **Penjelasan per Sintaksis**:
      - Variabel `puisi` dideklarasikan menggunakan long string `[[...]]`. Perhatikan bahwa semua baris baru dan spasi, termasuk indentasi pada baris kedua, akan dipertahankan dalam nilai string akhir.
      - Variabel `puisi_manual` menunjukkan bagaimana string yang sama akan dideklarasikan menggunakan string biasa dengan _escape sequences_ `\n` (baris baru) dan `\t` (tab). Meskipun hasilnya sama, penulisan `puisi` lebih mudah dibaca dan dikelola untuk blok teks yang besar.

  - **Sumber Terverifikasi**: GameDev Academy - "Lua String Tutorial Complete Guide" (2023).

---

### **1.3 Operasi Fundamental**

Setelah memahami bagaimana mendeklarasikan string, kita akan mempelajari operasi dasar yang bisa Anda lakukan dengan string.

- **Konkatenasi dengan Operator (..) dan Performance Implications**

  **Konkatenasi** adalah proses menggabungkan dua atau lebih string menjadi satu string baru. Di Lua, ini dilakukan dengan operator khusus `..` (dua titik).

  - **Terminologi**:
    - **Konkatenasi (Concatenation)**: Proses menggabungkan dua atau lebih string menjadi satu string tunggal.
    - **Operator**: Simbol khusus yang melakukan operasi pada satu atau lebih nilai (disebut _operand_). Dalam hal ini, `..` adalah operator konkatenasi.
  - **Sintaks Dasar**: `string1 .. string2`
  - **Contoh Kode**:

    ```lua
    local nama_depan = "John"
    local nama_belakang = "Doe"
    local nama_lengkap = nama_depan .. " " .. nama_belakang
    -- 'nama_depan' (string "John") digabungkan dengan spasi (string " ")
    -- Kemudian hasil gabungan itu digabungkan lagi dengan 'nama_belakang' (string "Doe")
    print(nama_lengkap)
    -- Output: John Doe

    local umur = 30
    local pesan_umur = "Saya berusia " .. umur .. " tahun."
    -- Lua secara otomatis mengkonversi angka 'umur' menjadi string sebelum konkatenasi.
    print(pesan_umur)
    -- Output: Saya berusia 30 tahun.
    ```

    - **Penjelasan per Sintaksis**:
      - `nama_depan .. " " .. nama_belakang`: Ini adalah ekspresi konkatenasi. Operator `..` menggabungkan string `nama_depan` dengan string literal `" "`, dan hasil dari operasi tersebut kemudian digabungkan lagi dengan string `nama_belakang`.
      - `"Saya berusia " .. umur .. " tahun."`: Di sini, nilai numerik `umur` (30) secara otomatis dikonversi menjadi representasi string ("30") oleh Lua sebelum operasi konkatenasi dilakukan. Ini disebut _automatic type conversion_ atau _coercion_.

  - **Performance Implications (Implikasi Kinerja)**:
    Mengingat string di Lua bersifat **immutable**, setiap kali Anda melakukan konkatenasi, Lua sebenarnya membuat **string baru** di memori.

    - **Masalah**: Jika Anda melakukan banyak operasi konkatenasi dalam sebuah _loop_ (pengulangan), ini bisa menjadi tidak efisien. Setiap iterasi akan membuat string baru dan membuang string lama, menyebabkan penggunaan memori dan waktu CPU yang tidak perlu.
    - **Contoh Kode (Inefisien)**:

      ```lua
      local hasil_inefisien = ""
      for i = 1, 1000 do
          hasil_inefisien = hasil_inefisien .. "item " .. i .. "\n"
          -- Setiap kali loop berjalan, string baru dibuat!
          -- 'hasil_inefisien' yang lama akan dibuang oleh garbage collector Lua.
      end
      -- print(hasil_inefisien) -- Jangan cetak jika sangat panjang
      ```

      - **Penjelasan per Sintaksis**:
        - `local hasil_inefisien = ""`: Menginisialisasi sebuah variabel string kosong.
        - `for i = 1, 1000 do ... end`: Sebuah loop yang akan berjalan 1000 kali, dengan variabel `i` mengambil nilai dari 1 hingga 1000.
        - `hasil_inefisien = hasil_inefisien .. "item " .. i .. "\n"`: Di setiap iterasi, baris ini mengambil nilai `hasil_inefisien` saat ini, menggabungkannya dengan string `"item "` dan nilai `i` (yang dikonversi ke string), dan karakter baris baru `\n`. **Penting**: Operasi ini _selalu membuat string baru_ di memori. String lama yang disimpan dalam `hasil_inefisien` di iterasi sebelumnya kemudian menjadi tidak terpakai dan akan dibersihkan oleh _garbage collector_ Lua. Jika ini dilakukan berkali-kali, ini bisa menyebabkan overhead yang signifikan.

    - **Solusi (akan dibahas lebih detail di Level 4.3: Efficient String Building)**:
      Untuk konkatenasi yang melibatkan banyak string, lebih baik menggunakan `table.concat()`. Ini melibatkan pengumpulan semua bagian string dalam sebuah tabel, lalu menggabungkannya sekali di akhir.
      ```lua
      local bagian_string = {}
      for i = 1, 1000 do
          table.insert(bagian_string, "item " .. i .. "\n")
          -- Menambahkan bagian-bagian string ke dalam tabel.
      end
      local hasil_efisien = table.concat(bagian_string)
      -- 'table.concat()' menggabungkan semua string dalam tabel menjadi satu string baru.
      -- Ini jauh lebih efisien karena hanya ada satu operasi konkatenasi besar di akhir.
      -- print(hasil_efisien)
      ```
      - **Penjelasan per Sintaksis**:
        - `local bagian_string = {}`: Mendeklarasikan sebuah tabel kosong. Tabel adalah struktur data di Lua yang bisa menyimpan banyak nilai.
        - `table.insert(bagian_string, "item " .. i .. "\n")`: Ini adalah fungsi dari pustaka `table` di Lua. Ia menambahkan elemen baru (`"item " .. i .. "\n"`) ke akhir tabel `bagian_string`. Di sini, setiap bagian string ditambahkan ke tabel, bukan langsung digabungkan menjadi satu string besar.
        - `local hasil_efisien = table.concat(bagian_string)`: Ini adalah fungsi lain dari pustaka `table`. `table.concat()` mengambil semua elemen string dalam `bagian_string` dan menggabungkannya menjadi _satu string baru_ tunggal. Ini adalah cara yang jauh lebih efisien untuk membangun string dari banyak bagian karena string baru hanya dibuat satu kali di akhir.

  - **Sumber Terverifikasi**: Lua 5.4 Reference Manual Section 3.4.6.

- **Length Operator (#) vs string.len()**

  Untuk mendapatkan panjang (jumlah karakter) sebuah string di Lua, Anda memiliki dua opsi: operator panjang (`#`) atau fungsi `string.len()`.

  - **Operator Panjang (`#`)**: Ini adalah cara yang paling umum dan idiomatis di Lua untuk mendapatkan panjang string. Ini juga dapat digunakan untuk mendapatkan jumlah elemen dalam tabel.

    - **Sintaks Dasar**: `#myString`
    - **Contoh Kode**:

      ```lua
      local teks = "Halo Dunia!"
      local panjang_teks = #teks
      print("Panjang teks:", panjang_teks)
      -- Output: Panjang teks: 11

      local string_kosong = ""
      local panjang_kosong = #string_kosong
      print("Panjang string kosong:", panjang_kosong)
      -- Output: Panjang string kosong: 0
      ```

      - **Penjelasan per Sintaksis**:
        - `#teks`: Operator `#` (operator panjang) diterapkan pada variabel `teks` untuk mendapatkan jumlah karakter dalam string tersebut.
        - `#string_kosong`: Operator `#` diterapkan pada string kosong, menghasilkan 0.

  - **Fungsi `string.len()`**: Ini adalah fungsi dari pustaka `string` standar Lua yang melakukan hal yang sama. Meskipun masih berfungsi, operator `#` lebih disukai karena lebih ringkas dan seringkali sedikit lebih cepat.

    - **Sintaks Dasar**: `string.len(myString)`
    - **Contoh Kode**:
      ```lua
      local nama = "Alice"
      local panjang_nama = string.len(nama)
      print("Panjang nama:", panjang_nama)
      -- Output: Panjang nama: 5
      ```
      - **Penjelasan per Sintaksis**:
        - `string.len(nama)`: Memanggil fungsi `len` dari pustaka `string` dan meneruskan variabel `nama` sebagai argumen untuk mendapatkan panjangnya.

  - **Perbedaan Penting (UTF-8 / Unicode)**:
    Untuk string yang mengandung karakter multi-byte (seperti karakter Unicode/UTF-8), operator `#` dan `string.len()` akan mengembalikan jumlah _byte_, bukan jumlah _karakter visual_. Ini penting untuk dipahami jika Anda bekerja dengan teks non-Latin.

    - **Contoh (untuk demonstrasi, akan dibahas lebih detail di Level 5)**:

      ```lua
      local unicode_string = "你好世界" -- "Halo Dunia" dalam bahasa Mandarin
      print("Panjang byte:", #unicode_string)
      -- Output: Panjang byte: 12 (karena setiap karakter Mandarin biasanya 3 byte dalam UTF-8)

      -- Jika Anda ingin jumlah karakter visual (akan dibahas di Level 5.1):
      -- print("Jumlah karakter (UTF-8):", utf8.len(unicode_string))
      -- Output yang diharapkan: 4
      ```

      - **Penjelasan per Sintaksis**:
        - `"你好世界"`: Ini adalah string Unicode. Di UTF-8, setiap karakter Tionghoa ini biasanya direpresentasikan oleh 3 byte.
        - `#unicode_string`: Operator `#` akan menghitung jumlah byte dalam string ini, bukan jumlah karakter visual. Oleh karena itu, hasilnya adalah 12 (4 karakter \* 3 byte/karakter).

  - **Sumber Terverifikasi**: Lua 5.4 Reference Manual Section 3.4.6.

- **String Comparison dan Lexicographic Ordering**

  Anda dapat membandingkan string di Lua menggunakan operator relasional standar: `==` (sama dengan), `~=` (tidak sama dengan), `<` (kurang dari), `>` (lebih dari), `<=` (kurang dari atau sama dengan), `>=` (lebih dari atau sama dengan).

  - **Terminologi**:
    - **Operator Relasional (Relational Operators)**: Simbol yang digunakan untuk membandingkan dua nilai dan menghasilkan `true` (benar) atau `false` (salah).
    - **Lexicographic Ordering (Urutan Leksikografis)**: Cara string diurutkan berdasarkan urutan abjad karakter-karakternya, mirip dengan urutan kata di kamus. Ini didasarkan pada nilai numerik (ASCII/UTF-8) dari setiap karakter.
  - **Bagaimana Perbandingan String Bekerja**:
    String dibandingkan karakter demi karakter dari kiri ke kanan. Perbandingan berhenti pada karakter pertama yang berbeda. Nilai numerik (biasanya ASCII) dari karakter tersebut menentukan mana yang "lebih kecil" atau "lebih besar".
    - Huruf kapital (`A` = 65) datang sebelum huruf kecil (`a` = 97).
    - Angka (`0` = 48) datang sebelum huruf (`A` = 65).
  - **Contoh Kode**:

    ```lua
    print("Apel" == "Apel")      -- Output: true (sama persis)
    print("Apel" ~= "Jeruk")     -- Output: true (tidak sama)

    print("Apel" < "Jeruk")      -- Output: true (A < J, jadi "Apel" datang sebelum "Jeruk")
    print("Buku" > "Apel")       -- Output: true (B > A, jadi "Buku" datang setelah "Apel")

    print("apel" < "Apel")       -- Output: false (ASCII 'a' (97) lebih besar dari ASCII 'A' (65))
    print("apel" > "Apel")       -- Output: true

    print("10" < "2")            -- Output: true (secara leksikografis, '1' datang sebelum '2')
                                -- Ini adalah string, bukan angka! Jika Anda ingin membandingkan sebagai angka, gunakan tonumber().
    print("zebra" > "apple")     -- Output: true

    local s1 = "hello"
    local s2 = "hello"
    print(s1 == s2)              -- Output: true (nilai stringnya sama)
    ```

    - **Penjelasan per Sintaksis**:
      - `"Apel" == "Apel"`: Menggunakan operator `==` untuk memeriksa apakah dua string sama persis. Hasilnya `true`.
      - `"Apel" ~= "Jeruk"`: Menggunakan operator `~=` untuk memeriksa apakah dua string tidak sama. Hasilnya `true`.
      - `"Apel" < "Jeruk"`: Menggunakan operator `<` untuk perbandingan leksikografis. Karena 'A' datang sebelum 'J' dalam urutan abjad, `"Apel"` dianggap "kurang dari" `"Jeruk"`. Hasilnya `true`.
      - `"Buku" > "Apel"`: Karena 'B' datang setelah 'A', `"Buku"` dianggap "lebih dari" `"Apel"`. Hasilnya `true`.
      - `"apel" < "Apel"`: Penting! Perbandingan ini peka huruf besar/kecil. Kode ASCII untuk 'a' (97) lebih besar daripada 'A' (65). Jadi, `"apel"` secara leksikografis "lebih besar" dari `"Apel"`. Hasilnya `false`.
      - `"10" < "2"`: Ini adalah jebakan umum. Karena ini adalah perbandingan string (leksikografis), ia membandingkan karakter pertama: '1' versus '2'. Karena '1' < '2', maka `"10"` dianggap "kurang dari" `"2"`. Ini **bukan** perbandingan numerik. Jika Anda ingin membandingkan nilai numerik, Anda harus mengkonversinya ke angka terlebih dahulu menggunakan `tonumber()` (akan dibahas di Level 4.2). Hasilnya `true`.

  - **Sumber Terverifikasi**: Lua 5.4 Reference Manual Section 3.4.6.

- **Automatic Type Conversion (Coercion)**

  **Coercion** (koersi) atau konversi tipe otomatis adalah fitur di Lua di mana interpreter secara otomatis mengubah tipe data satu nilai ke tipe data lain jika operasi yang melibatkan nilai tersebut memerlukannya. Dalam konteks string, ini paling sering terjadi ketika Anda mencoba menggabungkan string dengan angka.

  - **Terminologi**:
    - **Type Conversion (Konversi Tipe)**: Mengubah nilai dari satu tipe data ke tipe data lain (misalnya, angka menjadi string, atau string menjadi angka).
    - **Automatic Type Conversion / Coercion**: Konversi tipe yang dilakukan secara otomatis oleh bahasa pemrograman tanpa perlu Anda menulis kode konversi secara eksplisit.
  - **Bagaimana Ini Bekerja dengan String**:
    Ketika Anda menggunakan operator konkatenasi `..` dengan angka dan string, Lua akan secara otomatis mengubah angka tersebut menjadi string sebelum melakukan penggabungan.
  - **Contoh Kode**:

    ```lua
    local harga = 15000
    local nama_barang = "Baju"
    local total_pesan = "Harga " .. nama_barang .. " adalah Rp" .. harga .. "."
    -- Angka 'harga' (15000) secara otomatis dikonversi menjadi string "15000"
    print(total_pesan)
    -- Output: Harga Baju adalah Rp15000.

    local jumlah = 5
    local satuan = "buah"
    local deskripsi = jumlah .. " " .. satuan
    print(deskripsi)
    -- Output: 5 buah

    -- Penting: Coercion tidak terjadi pada semua operasi!
    -- Ini akan menghasilkan error karena Anda mencoba menambah string dengan angka:
    -- print("10" + 5) -- ERROR: attempt to perform arithmetic on a string value

    -- Untuk melakukan operasi aritmatika pada string yang berisi angka,
    -- Anda harus mengkonversinya secara manual menggunakan tonumber():
    print(tonumber("10") + 5) -- Output: 15
    ```

    - **Penjelasan per Sintaksis**:
      - `"Harga " .. nama_barang .. " adalah Rp" .. harga .. "."`: Operator konkatenasi `..` memicu _coercion_. Ketika operator ini bertemu dengan nilai `harga` (yang bertipe `number`), Lua secara otomatis mengkonversi `harga` menjadi representasi stringnya (`"15000"`) sebelum menggabungkannya dengan string lain.
      - `jumlah .. " " .. satuan`: Mirip dengan di atas, `jumlah` (number) secara otomatis dikonversi menjadi string (`"5"`) untuk konkatenasi.
      - `"10" + 5`: Ini menunjukkan bahwa _coercion_ **tidak** terjadi pada operator aritmatika seperti `+`. Lua tidak akan secara otomatis mengkonversi string `"10"` menjadi angka untuk penambahan. Ini akan menghasilkan error karena Anda mencoba melakukan operasi aritmatika pada tipe data yang tidak tepat.
      - `tonumber("10") + 5`: Untuk mengatasi error di atas, Anda harus secara eksplisit menggunakan fungsi `tonumber()` untuk mengkonversi string `"10"` menjadi angka `10` sebelum melakukan penambahan.

  - **Sumber Terverifikasi**: Lua 5.4 Reference Manual Section 3.4.6.

---

Ini adalah akhir dari pembahasan **LEVEL 1: DASAR-DASAR STRING**. Kita telah mendalami definisi string, sifatnya yang immutable, berbagai cara mendeklarasikannya, pentingnya string sebagai _first-class citizen_, penggunaan _escape sequences_ dan _long brackets_, serta operasi dasar seperti konkatenasi, mendapatkan panjang, perbandingan, dan _automatic type conversion_. Pastikan Anda memahami setiap konsep dan sintaks yang telah dijelaskan.

</details>

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../README.md
[sebelumnya]:../../function/bagian-13/README.md
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
