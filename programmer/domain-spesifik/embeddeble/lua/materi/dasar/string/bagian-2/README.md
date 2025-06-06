<details>
<summary>Gemini 2.5 Pro</summary>

</details>

#

<details>
<summary>Gemini 2.5 Flash</summary>

# **LEVEL 2: STRING LIBRARY FUNCTIONS**

Bagian ini kita akan mendalami fungsi-fungsi bawaan yang disediakan oleh pustaka `string` di Lua. Fungsi-fungsi ini sangat kuat dan sering digunakan untuk memanipulasi string. Pustaka `string` di Lua menyediakan banyak fungsi yang berguna untuk berbagai operasi pada string. Fungsi-fungsi ini adalah bagian dari standar Lua dan sangat penting untuk dikuasai.

### **2.1 Basic String Functions**

Bagian ini mencakup fungsi-fungsi string yang paling sering digunakan untuk manipulasi dasar seperti mendapatkan panjang, memotong, mengubah huruf, dan lainnya.

- `string.len()` vs length operator

  Kita sudah membahas ini sedikit di Level 1.3, tetapi mari kita perdalam. Baik operator panjang (`#`) maupun `string.len()` digunakan untuk mendapatkan panjang sebuah string.

  - **`string.len(s)`**: Fungsi ini mengembalikan panjang (jumlah byte) dari string `s`.

    - **Sintaks Dasar**: `string.len(myString)`
    - **Contoh Kode**:
      ```lua
      local teks = "Lua Programming"
      local panjang = string.len(teks)
      print("Panjang string dengan string.len():", panjang)
      -- Output: Panjang string dengan string.len(): 15
      ```
      - **Penjelasan per Sintaksis**:
        - `string.len(teks)`: Memanggil fungsi `len` dari pustaka `string` dengan `teks` sebagai argumen. Fungsi ini mengembalikan jumlah byte dalam string `teks`.

  - **Operator Panjang (`#s`)**: Operator ini juga mengembalikan panjang (jumlah byte) dari string `s`. Ini adalah cara yang lebih ringkas dan seringkali disukai di kalangan pengembang Lua.

    - **Sintaks Dasar**: `#myString`
    - **Contoh Kode**:
      ```lua
      local kalimat = "Belajar Lua itu asyik!"
      local panjang_kalimat = #kalimat
      print("Panjang string dengan #:", panjang_kalimat)
      -- Output: Panjang string dengan #: 22
      ```
      - **Penjelasan per Sintaksis**:
        - `#kalimat`: Operator `#` diterapkan langsung pada variabel `kalimat` untuk mendapatkan jumlah byte dalam string tersebut.

  - **Perbedaan dan Pertimbangan**:

    - Secara fungsional, keduanya melakukan hal yang sama untuk string ASCII standar.
    - Operator `#` lebih ringkas dan sering digunakan secara idiomatik di Lua.
    - Untuk string yang mengandung karakter Unicode (misalnya, `你好世界`), keduanya akan mengembalikan jumlah _byte_, bukan jumlah karakter visual. Jika Anda membutuhkan jumlah karakter visual untuk string UTF-8, Anda akan menggunakan `utf8.len()` (dibahas di Level 5).

  - **Sumber Terverifikasi**: Programming in Lua Chapter 21, Lua 5.4 Reference Manual Section 3.4.6.

- `string.sub()` dengan positive/negative indices

  Fungsi `string.sub()` digunakan untuk mengekstrak (mendapatkan sub-bagian dari) sebuah string. Anda dapat menentukan posisi awal dan akhir sub-string yang ingin Anda ambil.

  - **Terminologi**:
    - **Sub-string**: Bagian dari string yang lebih besar.
    - **Indeks (Index)**: Posisi karakter dalam string. Di Lua, string diindeks mulai dari 1 (karakter pertama).
  - **Sintaks Dasar**: `string.sub(s, i [, j])`

    - `s`: String asli tempat Anda ingin mengekstrak sub-string.
    - `i`: Indeks awal sub-string.
    - `j` (opsional): Indeks akhir sub-string. Jika dihilangkan, sub-string akan diambil sampai akhir string `s`.

  - **Penggunaan Indeks Positif**: Indeks dihitung dari awal string, dimulai dari 1.

    - **Contoh Kode**:

      ```lua
      local kata = "Programming"

      local bagian1 = string.sub(kata, 1, 4)
      -- Ambil dari indeks 1 (P) sampai indeks 4 (g)
      print("string.sub(kata, 1, 4):", bagian1)
      -- Output: string.sub(kata, 1, 4): Prog

      local bagian2 = string.sub(kata, 5, 7)
      -- Ambil dari indeks 5 (r) sampai indeks 7 (a)
      print("string.sub(kata, 5, 7):", bagian2)
      -- Output: string.sub(kata, 5, 7): ram

      local bagian3 = string.sub(kata, 8)
      -- Ambil dari indeks 8 (m) sampai akhir string
      print("string.sub(kata, 8):", bagian3)
      -- Output: string.sub(kata, 8): ming

      local bagian4 = string.sub(kata, 1, #kata)
      -- Ambil seluruh string (dari awal sampai akhir)
      print("string.sub(kata, 1, #kata):", bagian4)
      -- Output: string.sub(kata, 1, #kata): Programming
      ```

      - **Penjelasan per Sintaksis**:
        - `string.sub(kata, 1, 4)`: Memanggil `string.sub` pada string `kata`. Argumen `1` adalah indeks awal (karakter pertama), dan `4` adalah indeks akhir (karakter keempat). Ini mengembalikan sub-string dari karakter ke-1 hingga ke-4.
        - `string.sub(kata, 5, 7)`: Mengembalikan sub-string dari karakter ke-5 hingga ke-7.
        - `string.sub(kata, 8)`: Jika argumen ketiga (`j`) dihilangkan, `string.sub` akan mengekstrak sub-string mulai dari indeks `i` hingga akhir string.
        - `string.sub(kata, 1, #kata)`: Ini adalah cara untuk mengekstrak seluruh string, dari indeks pertama hingga indeks terakhir (yang didapatkan dengan `#kata`).

  - **Penggunaan Indeks Negatif**: Indeks dihitung dari akhir string.

    - `-1` adalah karakter terakhir.
    - `-2` adalah karakter kedua terakhir, dan seterusnya.
    - **Contoh Kode**:

      ```lua
      local alamat = "jakarta@example.com"

      local domain = string.sub(alamat, -11)
      -- Ambil dari indeks -11 (karakter ke-11 dari belakang, yaitu 'e') sampai akhir.
      print("Domain:", domain)
      -- Output: Domain: example.com

      local ekstensi = string.sub(alamat, -3)
      -- Ambil dari indeks -3 (karakter ke-3 dari belakang, yaitu 'c') sampai akhir.
      print("Ekstensi:", ekstensi)
      -- Output: Ekstensi: com

      local username = string.sub(alamat, 1, -13)
      -- Ambil dari indeks 1 sampai indeks -13 (karakter ke-13 dari belakang, yaitu 'a')
      print("Username:", username)
      -- Output: Username: jakarta
      ```

      - **Penjelasan per Sintaksis**:
        - `string.sub(alamat, -11)`: Menggunakan indeks negatif. `string.sub` akan mulai menghitung dari akhir string. `-11` berarti karakter ke-11 dari belakang. Karena argumen ketiga dihilangkan, string diambil hingga akhir.
        - `string.sub(alamat, -3)`: Mengambil 3 karakter terakhir dari string.
        - `string.sub(alamat, 1, -13)`: Mengambil dari indeks 1 hingga karakter ke-13 dari belakang.

  - **Penting**: Jika `i` lebih besar dari `j` (atau `j` tidak ada dan `i` lebih besar dari panjang string), `string.sub` akan mengembalikan string kosong `""`.
  - **Sumber Terverifikasi**: Programming in Lua Chapter 21, Lua 5.4 Reference Manual Section 6.4.

- `string.upper()`, `string.lower()`

  Fungsi-fungsi ini digunakan untuk mengubah huruf dalam sebuah string menjadi huruf kapital (huruf besar) atau huruf kecil.

  - **`string.upper(s)`**: Mengembalikan salinan string `s` di mana semua huruf kecil diubah menjadi huruf besar.

    - **Sintaks Dasar**: `string.upper(myString)`
    - **Contoh Kode**:
      ```lua
      local teks_asli = "halo dunia LUA!"
      local teks_upper = string.upper(teks_asli)
      print("string.upper():", teks_upper)
      -- Output: string.upper(): HALO DUNIA LUA!
      ```
      - **Penjelasan per Sintaksis**:
        - `string.upper(teks_asli)`: Mengambil string `teks_asli` dan mengembalikan versi baru dari string tersebut di mana semua huruf kecil telah dikonversi menjadi huruf besar.

  - **`string.lower(s)`**: Mengembalikan salinan string `s` di mana semua huruf besar diubah menjadi huruf kecil.

    - **Sintaks Dasar**: `string.lower(myString)`
    - **Contoh Kode**:
      ```lua
      local teks_campur = "Lua Adalah HEBAT!"
      local teks_lower = string.lower(teks_campur)
      print("string.lower():", teks_lower)
      -- Output: string.lower(): lua adalah hebat!
      ```
      - **Penjelasan per Sintaksis**:
        - `string.lower(teks_campur)`: Mengambil string `teks_campur` dan mengembalikan versi baru dari string tersebut di mana semua huruf besar telah dikonversi menjadi huruf kecil.

  - **Penting**: Fungsi-fungsi ini hanya memengaruhi karakter alfabet dasar (A-Z, a-z). Untuk penanganan kasus yang lebih kompleks dengan karakter Unicode, Anda perlu menggunakan pustaka `utf8` (dibahas di Level 5).
  - **Sumber Terverifikasi**: Programming in Lua Chapter 21, Lua 5.4 Reference Manual Section 6.4.

- `string.reverse()`

  Fungsi ini digunakan untuk membalik urutan karakter dalam sebuah string.

  - **Sintaks Dasar**: `string.reverse(s)`
    - `s`: String yang ingin Anda balik.
  - **Contoh Kode**:

    ```lua
    local kata_asli = "madam"
    local kata_balik = string.reverse(kata_asli)
    print("Asli:", kata_asli)
    print("Dibalik:", kata_balik)
    -- Output:
    -- Asli: madam
    -- Dibalik: madam (ini palindrom!)

    local pesan_rahasia = "esrever siht daer"
    local pesan_terbaca = string.reverse(pesan_rahasia)
    print("Pesan Rahasia:", pesan_rahasia)
    print("Pesan Terbaca:", pesan_terbaca)
    -- Output:
    -- Pesan Rahasia: esrever siht daer
    -- Pesan Terbaca: read this reverse
    ```

    - **Penjelasan per Sintaksis**:
      - `string.reverse(kata_asli)`: Mengambil string `kata_asli` dan mengembalikan string baru dengan urutan karakter yang terbalik.
      - `string.reverse(pesan_rahasia)`: Mengambil string `pesan_rahasia` dan mengembalikan string baru yang merupakan kebalikannya.

  - **Penting**: Seperti `string.len()`, `string.reverse()` juga beroperasi pada _byte_, bukan karakter Unicode. Membalik string Unicode dengan `string.reverse()` dapat menghasilkan karakter yang rusak jika karakter tersebut terdiri dari beberapa byte.
  - **Sumber Terverifikasi**: Lua 5.4 Reference Manual Section 6.4.

- `string.rep()` untuk repetition

  Fungsi `string.rep()` digunakan untuk mengulang sebuah string sejumlah kali yang ditentukan. Ini sangat berguna untuk membuat garis pemisah, mengisi string dengan karakter tertentu, atau membuat pola berulang.

  - **Terminologi**:
    - **Repetition (Pengulangan)**: Tindakan mengulang suatu string beberapa kali.
  - **Sintaks Dasar**: `string.rep(s, n [, sep])`

    - `s`: String yang ingin diulang.
    - `n`: Jumlah kali string `s` akan diulang. Harus berupa angka non-negatif.
    - `sep` (opsional): String pemisah yang akan disisipkan di antara setiap pengulangan `s`. Jika dihilangkan, tidak ada pemisah.

  - **Contoh Kode**:

    ```lua
    local garis_pemisah = string.rep("-", 20)
    -- Ulangi string "-" sebanyak 20 kali.
    print("Garis Pemisah:", garis_pemisah)
    -- Output: Garis Pemisah: --------------------

    local bintang_ulang = string.rep("* ", 5)
    -- Ulangi string "* " sebanyak 5 kali.
    print("Bintang Ulang:", bintang_ulang)
    -- Output: Bintang Ulang: * * * * * local daftar_item = string.rep("Item", 3, ", ")
    -- Ulangi string "Item" sebanyak 3 kali, dengan ", " sebagai pemisah.
    print("Daftar Item:", daftar_item)
    -- Output: Daftar Item: Item, Item, Item

    local kosong = string.rep("X", 0)
    -- Mengulang 0 kali menghasilkan string kosong.
    print("Kosong:", kosong)
    -- Output: Kosong:
    ```

    - **Penjelasan per Sintaksis**:
      - `string.rep("-", 20)`: Mengulang string literal `"-"` sebanyak 20 kali. Tidak ada pemisah yang ditentukan.
      - `string.rep("* ", 5)`: Mengulang string literal `"* "` (dengan spasi di akhir) sebanyak 5 kali.
      - `string.rep("Item", 3, ", ")`: Mengulang string `"Item"` sebanyak 3 kali, dan di antara setiap pengulangan, menyisipkan string pemisah `", "`.

  - **Sumber Terverifikasi**: Programming in Lua Chapter 21, Lua 5.4 Reference Manual Section 6.4.

- `string.char()` dan `string.byte()`

  Fungsi-fungsi ini adalah kebalikan satu sama lain:

  - `string.char()` mengkonversi angka (kode numerik) menjadi karakter.
  - `string.byte()` mengkonversi karakter menjadi angka (kode numeriknya).

  Fungsi-fungsi ini beroperasi pada nilai byte. Untuk karakter ASCII, ini sesuai dengan nilai ASCII-nya.

  - **`string.char(n1, n2, ...)`**: Mengembalikan string yang dibuat dari satu atau lebih kode karakter (angka) yang diberikan. Setiap angka harus dalam rentang 0-255 (untuk representasi byte tunggal).

    - **Sintaks Dasar**: `string.char(number1, number2, ...)`
    - **Contoh Kode**:

      ```lua
      local huruf_a = string.char(97)
      -- 97 adalah kode ASCII untuk 'a'
      print("string.char(97):", huruf_a)
      -- Output: string.char(97): a

      local kata_halo = string.char(72, 97, 108, 111)
      -- 72='H', 97='a', 108='l', 111='o'
      print("string.char(72, 97, 108, 111):", kata_halo)
      -- Output: string.char(72, 97, 108, 111): Halo

      local smiley = string.char(9786) -- Ini akan menghasilkan karakter yang berbeda tergantung pada encoding terminal
      -- Untuk Unicode, ini lebih kompleks. Lua 5.3+ memiliki utf8.char().
      -- Karakter Unicode membutuhkan lebih dari satu byte untuk representasi UTF-8.
      -- Contoh karakter 😃 (U+1F603) membutuhkan 4 byte dalam UTF-8.
      -- string.char() hanya bekerja untuk byte tunggal (0-255).
      ```

      - **Penjelasan per Sintaksis**:
        - `string.char(97)`: Mengkonversi nilai numerik `97` (kode ASCII untuk 'a') menjadi karakter yang sesuai.
        - `string.char(72, 97, 108, 111)`: Mengkonversi serangkaian nilai numerik menjadi karakter yang sesuai dan menggabungkannya menjadi satu string.

  - **`string.byte(s [, i [, j]])`**: Mengembalikan kode numerik (nilai byte) dari karakter-karakter dalam string `s`.

    - `s`: String sumber.
    - `i` (opsional): Indeks awal. Defaultnya 1.
    - `j` (opsional): Indeks akhir. Defaultnya `i` (hanya mengembalikan satu byte).
    - **Sintaks Dasar**: `string.byte(myString, startIndex, endIndex)`
    - **Contoh Kode**:

      ```lua
      local karakter = "X"
      local kode_x = string.byte(karakter)
      print("string.byte(\"X\"): ", kode_x)
      -- Output: string.byte("X"):  88

      local kata_test = "TEST"
      local kode_t, kode_e, kode_s, kode_t2 = string.byte(kata_test, 1, 4)
      -- Mengembalikan beberapa nilai yang bisa disimpan di beberapa variabel.
      print("Kode 'T':", kode_t, "Kode 'E':", kode_e, "Kode 'S':", kode_s, "Kode 'T2':", kode_t2)
      -- Output: Kode 'T': 84  Kode 'E': 69  Kode 'S': 83  Kode 'T2': 84

      local kalimat_lengkap = "Hello"
      for i = 1, #kalimat_lengkap do
          io.write(string.byte(kalimat_lengkap, i), " ")
      end
      print() -- Baris baru
      -- Output: 72 101 108 108 111
      ```

      - **Penjelasan per Sintaksis**:
        - `string.byte(karakter)`: Mengambil string `karakter` dan mengembalikan kode ASCII (nilai byte) dari karakter pertamanya.
        - `string.byte(kata_test, 1, 4)`: Mengambil string `kata_test` dan mengembalikan kode ASCII dari setiap karakter dari indeks 1 hingga 4. Fungsi ini dapat mengembalikan beberapa nilai sekaligus.
        - `for i = 1, #kalimat_lengkap do ... end`: Sebuah loop yang berjalan dari indeks 1 hingga panjang string `kalimat_lengkap`.
        - `io.write(string.byte(kalimat_lengkap, i), " ")`: Di setiap iterasi, ini mengambil kode byte dari karakter pada indeks `i` dalam `kalimat_lengkap` dan mencetaknya ke konsol, diikuti dengan spasi. `io.write` digunakan untuk mencetak tanpa menambahkan baris baru otomatis seperti `print`.

  - **Penting (Unicode/UTF-8)**: Seperti yang disebutkan, `string.char()` dan `string.byte()` beroperasi pada byte tunggal. Untuk menangani karakter Unicode yang mungkin terdiri dari beberapa byte dalam pengodean UTF-8, Anda harus menggunakan fungsi-fungsi dari pustaka `utf8` yang diperkenalkan di Lua 5.3+ (misalnya `utf8.char()` dan `utf8.codepoint()`). Ini akan dibahas lebih lanjut di Level 5.
  - **Sumber Terverifikasi**: Programming in Lua Chapter 21, Lua 5.4 Reference Manual Section 6.4.

---

Ini adalah akhir dari pembahasan **LEVEL 2.1: Basic String Functions**. Anda telah belajar tentang `string.len()`, `string.sub()`, `string.upper()`, `string.lower()`, `string.rep()`, serta `string.char()` dan `string.byte()`. Pahami dengan baik cara kerja indeks positif dan negatif pada `string.sub()`, serta implikasi pada karakter multi-byte untuk `string.len()`, `string.reverse()`, `string.char()`, dan `string.byte()`.

### **2.2 String Search Functions**

Bagian ini akan membahas fungsi-fungsi penting untuk mencari sub-string, menemukan posisi, dan bekerja dengan pola di dalam string.

- `string.find()`: Basic usage and boolean flag `plain`

  Fungsi `string.find()` digunakan untuk mencari kemunculan pertama (atau pertama dari pola) sebuah sub-string di dalam string lain. Fungsi ini sangat serbaguna karena juga mendukung _Lua Patterns_ (pola khusus Lua, bukan _regular expressions_ penuh seperti di bahasa lain) yang akan dibahas lebih lanjut di Level 3.

  - **Sintaks Dasar**: `string.find(s, pattern [, init [, plain]])`

    - `s`: String tempat pencarian akan dilakukan.
    - `pattern`: String yang ingin dicari, atau pola Lua yang ingin dicocokkan.
    - `init` (opsional): Indeks di mana pencarian dimulai. Defaultnya 1. Bisa negatif (dihitung dari akhir string).
    - `plain` (opsional): Sebuah nilai boolean (`true` atau `false`). Jika `true`, `pattern` akan diperlakukan sebagai string literal biasa, dan semua karakter khusus pola akan diabaikan. Defaultnya `false`.

  - **Return Values**:

    - Jika ditemukan: Mengembalikan dua nilai: indeks awal kemunculan pola, dan indeks akhir kemunculan pola.
    - Jika tidak ditemukan: Mengembalikan `nil`.

  - **Pencarian Dasar (tanpa pola khusus)**:

    - **Contoh Kode**:

      ```lua
      local kalimat = "Belajar pemrograman Lua itu menyenangkan."

      -- Mencari sub-string "Lua"
      local awal, akhir = string.find(kalimat, "Lua")
      print("Posisi 'Lua':", awal, akhir)
      -- Output: Posisi 'Lua': 19  21 (karena 'L' di indeks 19, 'a' di indeks 21)

      -- Mencari sub-string yang tidak ada
      local awal_tidak_ada, akhir_tidak_ada = string.find(kalimat, "Python")
      print("Posisi 'Python':", awal_tidak_ada, akhir_tidak_ada)
      -- Output: Posisi 'Python': nil  nil

      -- Mencari dengan startIndex (init)
      local awal_lagi, akhir_lagi = string.find(kalimat, "menyenangkan", 20)
      -- Mulai pencarian dari indeks 20
      print("Posisi 'menyenangkan' dari indeks 20:", awal_lagi, akhir_lagi)
      -- Output: Posisi 'menyenangkan' dari indeks 20: 27  38
      ```

      - **Penjelasan per Sintaksis**:
        - `string.find(kalimat, "Lua")`: Memanggil `string.find` pada string `kalimat` untuk mencari string `"Lua"`. Mengembalikan dua nilai: indeks awal (`awal`) dan indeks akhir (`akhir`) dari kemunculan pertama.
        - `string.find(kalimat, "Python")`: Mencari `"Python"`. Karena tidak ditemukan, `string.find` mengembalikan `nil` untuk kedua nilai.
        - `string.find(kalimat, "menyenangkan", 20)`: Pencarian dimulai dari indeks ke-20 dari `kalimat`. Ini berguna jika Anda tahu sub-string mungkin muncul lebih dari sekali dan Anda ingin menemukan kemunculan berikutnya.

  - **Menggunakan `plain` flag**:
    Ketika `plain` diatur ke `true`, `string.find()` akan memperlakukan `pattern` sebagai string literal, mengabaikan semua karakter khusus pola. Ini penting jika Anda mencari string yang secara kebetulan mengandung karakter khusus pola (misalnya `.` atau `*`).

    - **Contoh Kode**:

      ```lua
      local alamat_file = "dokumen.txt"

      -- Tanpa plain flag (ini akan memperlakukan '.' sebagai karakter khusus pola)
      local a1, e1 = string.find(alamat_file, ".txt")
      print("Find '.txt' (tanpa plain):", a1, e1)
      -- Output: Find '.txt' (tanpa plain): 1  7
      -- Mengapa 1? Karena '.' di pola berarti 'cocokkan karakter apapun'.
      -- Jadi, '.txt' cocok dengan "dokumen" (karakter apapun) + "txt".

      -- Dengan plain flag
      local a2, e2 = string.find(alamat_file, ".txt", 1, true)
      print("Find '.txt' (dengan plain):", a2, e2)
      -- Output: Find '.txt' (dengan plain): 8  11 (posisi 'd' dari '.txt' asli)
      -- 'd' dari 'dokumen' ada di indeks 1.
      -- '.' ada di indeks 8.
      ```

      - **Penjelasan per Sintaksis**:
        - `string.find(alamat_file, ".txt")`: Karena `plain` diatur ke default (`false`), `.` dalam pola `".txt"` diperlakukan sebagai karakter khusus yang berarti "cocokkan karakter apapun". Jadi, pola ini cocok dengan `"dokumen"` di awal string, dan hasilnya adalah indeks 1 dan 7.
        - `string.find(alamat_file, ".txt", 1, true)`: Dengan `true` sebagai argumen keempat (`plain`), `.` diperlakukan sebagai karakter titik literal. Jadi, `string.find` mencari urutan karakter `.txt` secara harfiah. Output `8 11` menunjukkan bahwa ia ditemukan pada indeks 8 (yaitu, karakter titik setelah "dokumen").

  - **Sumber Terverifikasi**: Programming in Lua Chapter 21, Lua 5.4 Reference Manual Section 6.4.

- `string.match()`: Extracting captured substrings

  Fungsi `string.match()` digunakan untuk mencari pola dalam string dan mengembalikan bagian string yang cocok dengan pola tersebut. Berbeda dengan `string.find()` yang mengembalikan indeks, `string.match()` mengembalikan string yang cocok.

  - **Sintaks Dasar**: `string.match(s, pattern [, init])`

    - `s`: String tempat pencarian akan dilakukan.
    - `pattern`: Pola Lua yang ingin dicocokkan (karakter khusus pola akan aktif secara default).
    - `init` (opsional): Indeks di mana pencarian dimulai. Defaultnya 1.

  - **Return Values**:

    - Jika ditemukan: Mengembalikan string yang cocok dengan pola. Jika pola memiliki _captures_ (bagian pola yang ingin "ditangkap"), maka `string.match()` akan mengembalikan nilai-nilai yang ditangkap tersebut.
    - Jika tidak ditemukan: Mengembalikan `nil`.

  - **Pencarian Pola Sederhana**:

    - **Contoh Kode**:

      ```lua
      local email = "user@example.com"

      local domain = string.match(email, "@(%a+%.%a+)")
      -- Mencari pola: '@' diikuti oleh satu atau lebih huruf (%a+),
      -- kemudian '.' (titik di-escape dengan %) diikuti satu atau lebih huruf.
      -- Bagian dalam kurung '()' adalah capture.
      print("Domain:", domain)
      -- Output: Domain: example.com

      local angka_saja = string.match("Harga: 12345", "%d+")
      -- Mencari satu atau lebih digit (%d+)
      print("Angka saja:", angka_saja)
      -- Output: Angka saja: 12345

      local tidak_ada = string.match("Ini tidak ada angka", "%d+")
      print("Tidak ada angka:", tidak_ada)
      -- Output: Tidak ada angka: nil
      ```

      - **Penjelasan per Sintaksis**:
        - `string.match(email, "@(%a+%.%a+)")`:
          - `@`: Mencocokkan karakter literal '@'.
          - `(` dan `)`: Ini adalah _capture_. Apapun yang cocok di dalam kurung ini akan dikembalikan oleh `string.match`.
          - `%a+`: Mencocokkan satu atau lebih (`+`) karakter alfabet (`%a`). Ini akan cocok dengan "example".
          - `%.`: Mencocokkan karakter titik literal. Karena `.` adalah karakter khusus pola, ia perlu di-_escape_ dengan `%`.
          - `%a+`: Mencocokkan satu atau lebih karakter alfabet lagi. Ini akan cocok dengan "com".
          - Jadi, pola ini mencari `@` diikuti oleh satu atau lebih huruf, titik, dan satu atau lebih huruf. Bagian yang ditangkap adalah `example.com`.
        - `string.match("Harga: 12345", "%d+")`:
          - `%d+`: Mencocokkan satu atau lebih (`+`) digit (`%d`). Ini akan cocok dengan "12345".

  - **Captures (Penangkapan)**:
    Bagian terpenting dari `string.match()` adalah kemampuannya untuk "menangkap" bagian-bagian dari pola yang cocok. Ini dilakukan dengan menempatkan bagian pola dalam tanda kurung `()`. `string.match()` akan mengembalikan nilai-nilai yang ditangkap ini.

    - **Contoh Kode dengan Multiple Captures**:
      ```lua
      local nama_lengkap = "Budi Hartono"
      local depan, belakang = string.match(nama_lengkap, "(%a+)%s+(%a+)")
      -- Pola: satu atau lebih huruf (%a+), diikuti satu atau lebih spasi (%s+),
      -- diikuti satu atau lebih huruf (%a+).
      -- Dua pasang kurung '()' berarti dua capture.
      print("Nama Depan:", depan)
      print("Nama Belakang:", belakang)
      -- Output:
      -- Nama Depan: Budi
      -- Nama Belakang: Hartono
      ```
      - **Penjelasan per Sintaksis**:
        - `"(%a+)%s+(%a+)"`:
          - `(%a+)`: Capture pertama. Mencocokkan satu atau lebih huruf (akan menangkap "Budi").
          - `%s+`: Mencocokkan satu atau lebih karakter spasi. Ini tidak ditangkap.
          - `(%a+)`: Capture kedua. Mencocokkan satu atau lebih huruf (akan menangkap "Hartono").
        - `local depan, belakang = ...`: Nilai yang ditangkap oleh kurung pertama (`Budi`) akan ditugaskan ke variabel `depan`, dan nilai yang ditangkap oleh kurung kedua (`Hartono`) akan ditugaskan ke variabel `belakang`.

  - **Sumber Terverifikasi**: Programming in Lua Chapter 20, Lua 5.4 Reference Manual Section 6.4.

- `string.find()` vs `string.match()` Use Cases

  Meskipun keduanya mencari pola, `string.find()` dan `string.match()` memiliki tujuan yang berbeda:

  - **`string.find()`**:

    - **Tujuan**: Menemukan **lokasi** (indeks awal dan akhir) kemunculan pertama dari pola atau sub-string.
    - **Kapan Digunakan**:
      - Ketika Anda hanya perlu tahu apakah suatu string mengandung pola tertentu dan di mana posisinya.
      - Ketika Anda ingin mencari string literal yang mungkin mengandung karakter khusus pola (dengan `plain=true`).
      - Sebagai langkah awal sebelum memanipulasi string di posisi tersebut.
    - **Analogi**: "Di mana kunci mobil saya?"

  - **`string.match()`**:

    - **Tujuan**: Mengekstrak **konten** (string yang cocok atau bagian yang ditangkap) dari string berdasarkan pola.
    - **Kapan Digunakan**:
      - Ketika Anda ingin mendapatkan bagian spesifik dari sebuah string (misalnya, nama pengguna dari email, angka dari teks, dll.).
      - Ketika Anda ingin memvalidasi format string dan pada saat yang sama mengambil bagian-bagiannya.
      - Untuk _parsing_ atau memecah string menjadi komponen-komponennya.
    - **Analogi**: "Ambilkan saya kunci mobil!" (dan Anda mendapatkan kunci itu sendiri).

  - **Contoh Kode Perbandingan**:

    ```lua
    local teks_data = "ID: ABC-1234, Name: Alice"

    -- Menggunakan string.find()
    local start_id, end_id = string.find(teks_data, "ABC%-%d+")
    if start_id then
        print("ID ditemukan di posisi:", start_id, end_id)
        -- Output: ID ditemukan di posisi: 5  13
        -- string.sub untuk mendapatkan nilainya
        print("Nilai ID (dengan sub):", string.sub(teks_data, start_id, end_id))
        -- Output: Nilai ID (dengan sub): ABC-1234
    else
        print("ID tidak ditemukan.")
    end

    print("--------------------")

    -- Menggunakan string.match()
    local id_value = string.match(teks_data, "ID: (%a+%-?%d+)")
    if id_value then
        print("Nilai ID (dengan match):", id_value)
        -- Output: Nilai ID (dengan match): ABC-1234
    else
        print("ID tidak ditemukan.")
    end
    ```

    - **Penjelasan per Sintaksis**:
      - **string.find()**:
        - `string.find(teks_data, "ABC%-%d+")`: Mencari pola `ABC` diikuti oleh `-` (di-_escape_) dan satu atau lebih digit (`%d+`). Jika ditemukan, ia mengembalikan indeks awal dan akhir kecocokan.
        - `string.sub(teks_data, start_id, end_id)`: Setelah mendapatkan indeks dari `string.find`, kita menggunakan `string.sub` untuk mengekstrak string yang cocok.
      - **string.match()**:
        - `string.match(teks_data, "ID: (%a+%-?%d+)")`: Mencari string literal "ID: ", diikuti oleh sebuah _capture_ `(%a+%-?%d+)`.
          - `(%a+)`: Mencocokkan satu atau lebih huruf (menangkap "ABC").
          - `%-?`: Mencocokkan karakter `-` nol atau satu kali (di-_escape_).
          - `%d+`: Mencocokkan satu atau lebih digit (menangkap "1234").
        - `string.match` langsung mengembalikan nilai yang ditangkap ("ABC-1234"), tanpa perlu langkah `string.sub` terpisah.

  - **Sumber Terverifikasi**: Lua 5.4 Reference Manual Section 6.4 (lihat dokumentasi untuk `string.find` dan `string.match`).

- `string.gmatch()`: Iterating over all matches

  Fungsi `string.gmatch()` adalah iterator yang kuat. Ini digunakan untuk mencari semua kemunculan pola dalam sebuah string dan memungkinkan Anda untuk mengulanginya satu per satu. Ini sangat berbeda dari `string.find()` atau `string.match()` yang hanya mengembalikan kemunculan pertama.

  - **Sintaks Dasar**: `string.gmatch(s, pattern)`

    - `s`: String tempat pencarian akan dilakukan.
    - `pattern`: Pola Lua yang ingin dicocokkan.

  - **Return Values**:

    - `string.gmatch()` tidak mengembalikan string atau indeks secara langsung. Sebaliknya, ia mengembalikan **iterator function**. Anda menggunakan fungsi ini dalam loop `for...in` untuk mendapatkan setiap kecocokan atau capture secara berurutan.

  - **Contoh Kode**:

    ```lua
    local kalimat_angka = "Angka: 10, nilai: 20, total: 300."

    -- Mengambil semua angka dari string
    for angka in string.gmatch(kalimat_angka, "%d+") do
        print("Ditemukan angka:", angka)
    end
    -- Output:
    -- Ditemukan angka: 10
    -- Ditemukan angka: 20
    -- Ditemukan angka: 300

    print("--------------------")

    local log_entries = "ERROR: file not found. WARNING: disk full. INFO: operation complete."
    -- Mengambil semua jenis pesan (ERROR, WARNING, INFO) dan pesannya
    for tipe, pesan in string.gmatch(log_entries, "(%u+):%s*(.-)%.") do
        print("Tipe:", tipe, "Pesan:", pesan)
    end
    -- Output:
    -- Tipe: ERROR  Pesan: file not found
    -- Tipe: WARNING  Pesan: disk full
    -- Tipe: INFO  Pesan: operation complete
    ```

    - **Penjelasan per Sintaksis**:
      - `for angka in string.gmatch(kalimat_angka, "%d+") do ... end`:
        - `string.gmatch(kalimat_angka, "%d+")`: Memanggil `string.gmatch` untuk mencari pola satu atau lebih digit (`%d+`) dalam `kalimat_angka`. Ini mengembalikan sebuah _iterator_.
        - `for ... in ... do`: Ini adalah konstruksi loop generik di Lua. Setiap kali loop berjalan, _iterator_ yang dikembalikan oleh `string.gmatch` dipanggil, dan ia akan mengembalikan kecocokan berikutnya (dalam hal ini, string `angka` yang cocok dengan `%d+`). Loop berlanjut sampai tidak ada kecocokan lagi.
      - `for tipe, pesan in string.gmatch(log_entries, "(%u+):%s*(.-)%.") do ... end`:
        - `string.gmatch(log_entries, "(%u+):%s*(.-)%.")`: Ini adalah pola yang lebih kompleks dengan dua _capture_.
          - `(%u+)`: Capture pertama. Mencocokkan satu atau lebih huruf kapital (`%u`). Ini akan menangkap "ERROR", "WARNING", "INFO".
          - `:`: Mencocokkan karakter titik dua literal.
          - `%s*`: Mencocokkan nol atau lebih spasi (`%s`).
          - `(.-)`: Capture kedua. Ini adalah _non-greedy match_. `.` berarti karakter apapun, dan `-` berarti "nol atau lebih dari karakter sebelumnya, tapi sesedikit mungkin". Ini penting untuk mencegahnya mencocokkan terlalu banyak karakter sampai ke titik terakhir dari keseluruhan string. Ini akan menangkap teks pesan hingga titik pertama (`.`).
          - `%.`: Mencocokkan karakter titik literal (di-_escape_).
        - Di setiap iterasi loop, `string.gmatch` mengembalikan dua nilai yang ditangkap (tipe pesan dan teks pesan), yang kemudian ditugaskan ke variabel `tipe` dan `pesan`.

  - **Kapan Menggunakan `string.gmatch()`**:

    - Ketika Anda perlu memproses **semua** kemunculan pola dalam sebuah string.
    - Untuk _parsing_ data berulang dari log, teks terstruktur, dll.
    - Ini adalah cara yang paling efisien untuk mengulang semua kecocokan.

  - **Sumber Terverifikasi**: Programming in Lua Chapter 20, Lua 5.4 Reference Manual Section 6.4.

- `string.format()`: Formatted output (basics)

  Fungsi `string.format()` digunakan untuk membuat string yang diformat dengan cara yang terkontrol. Ini mirip dengan fungsi `printf` di C atau format string di Python. Anda memberikan string format dan nilai-nilai yang akan disisipkan ke dalamnya.

  - **Sintaks Dasar**: `string.format(formatstring, value1, value2, ...)`

    - `formatstring`: Sebuah string yang berisi teks dan spesifier format (placeholder) yang dimulai dengan `%`.
    - `value1, value2, ...`: Nilai-nilai yang akan disisipkan ke dalam string format.

  - **Spesifier Format Umum**:

    - `%s`: String (cocok untuk string, angka, boolean).
    - `%d`: Bilangan bulat desimal (integer).
    - `%f`: Bilangan pecahan (floating-point number).
    - `%.Xf`: Bilangan pecahan dengan X digit setelah koma.
    - `%x` / `%X`: Bilangan heksadesimal (huruf kecil/besar).
    - `%c`: Karakter (dari kode ASCII/numerik).
    - `%q`: String yang diberi kutip dan di-_escape_ dengan benar (berguna untuk output debug atau string yang bisa dibaca ulang oleh Lua).
    - `%%`: Karakter `%` literal.

  - **Contoh Kode**:

    ```lua
    local nama = "Alice"
    local usia = 30
    local tinggi_badan = 1.65

    local pesan1 = string.format("Nama: %s, Usia: %d tahun.", nama, usia)
    -- %s akan diganti dengan nilai 'nama'
    -- %d akan diganti dengan nilai 'usia' (sebagai integer)
    print(pesan1)
    -- Output: Nama: Alice, Usia: 30 tahun.

    local pesan2 = string.format("Tinggi badan: %.2f meter.", tinggi_badan)
    -- %.2f akan memformat tinggi_badan menjadi float dengan 2 desimal.
    print(pesan2)
    -- Output: Tinggi badan: 1.65 meter.

    local harga_item = 12.99
    local kuantitas = 3
    local total_biaya = harga_item * kuantitas
    local faktur = string.format("Item: %s, Harga: $%.2f, Qty: %d, Total: $%.2f",
                                  "Buku", harga_item, kuantitas, total_biaya)
    print(faktur)
    -- Output: Item: Buku, Harga: $12.99, Qty: 3, Total: $38.97

    local debug_string = "Ini 'string' dengan \"kutipan\"!"
    print(string.format("Debug: %q", debug_string))
    -- Output: Debug: "Ini 'string' dengan \"kutipan\"!"
    ```

    - **Penjelasan per Sintaksis**:
      - `string.format("Nama: %s, Usia: %d tahun.", nama, usia)`: String format berisi teks biasa dan _placeholder_.
        - `%s`: Diganti dengan nilai string dari variabel `nama`.
        - `%d`: Diganti dengan nilai integer dari variabel `usia`.
      - `string.format("Tinggi badan: %.2f meter.", tinggi_badan)`:
        - `%.2f`: Diganti dengan nilai float dari `tinggi_badan`, diformat dengan dua digit desimal setelah koma.
      - `string.format("Debug: %q", debug_string)`:
        - `%q`: Diganti dengan nilai string dari `debug_string`, di mana string tersebut akan diberi kutip ganda dan karakter-karakter khusus akan di-_escape_ secara otomatis. Ini sangat berguna untuk menghasilkan representasi string yang dapat dibaca ulang oleh Lua.

  - **Penggunaan `string.format()`**:

    - Membuat pesan log atau output yang rapi dan terstruktur.
    - Menyiapkan string untuk tampilan antarmuka pengguna.
    - Mengkonversi angka ke string dengan format tertentu.

  - **Sumber Terverifikasi**: Programming in Lua Chapter 20, Lua 5.4 Reference Manual Section 6.4.

---

Ini adalah akhir dari pembahasan **2.2: String Search Functions**. Anda sekarang sudah memahami `string.find()` untuk menemukan posisi, `string.match()` untuk mengekstrak kecocokan dan _captures_, `string.gmatch()` untuk mengulang semua kecocokan, dan `string.format()` untuk membuat string yang diformat. Fungsi-fungsi ini adalah tulang punggung dari banyak operasi manipulasi string di Lua.

### **2.3 String Manipulation and Transformation Functions**

Bagian ini membahas fungsi-fungsi penting yang memungkinkan Anda untuk mengubah atau memanipulasi string, seperti penggantian, penghapusan, dan pad string.

- `string.gsub()`: Global substitution with patterns and functions

  Fungsi `string.gsub()` adalah salah satu fungsi string paling kuat di Lua. Ini digunakan untuk mengganti semua (atau sejumlah) kemunculan pola tertentu dalam sebuah string dengan string pengganti, atau hasil dari sebuah fungsi.

  - **Sintaks Dasar**: `string.gsub(s, pattern, repl [, n])`

    - `s`: String asli yang akan dimanipulasi.
    - `pattern`: Pola Lua yang akan dicari (karakter khusus pola aktif secara default).
    - `repl`: Ini bisa berupa:
      - Sebuah **string**: Semua kemunculan pola akan diganti dengan string ini.
      - Sebuah **tabel**: Digunakan untuk pemetaan penggantian (akan dibahas lebih lanjut).
      - Sebuah **fungsi**: Fungsi ini akan dipanggil untuk setiap kecocokan, dan nilai kembaliannya akan digunakan sebagai string pengganti.
    - `n` (opsional): Jumlah maksimum penggantian yang akan dilakukan. Jika dihilangkan, semua kecocokan akan diganti.

  - **Return Values**:

    - Dua nilai: String baru setelah penggantian, dan jumlah total penggantian yang dilakukan.

  - **Penggantian dengan String Literal**:

    - **Contoh Kode**:

      ```lua
      local kalimat = "Ini adalah contoh kalimat. Ini adalah contoh."

      -- Ganti semua "contoh" dengan "teks"
      local kalimat_baru, jumlah_ganti = string.gsub(kalimat, "contoh", "teks")
      print("String baru:", kalimat_baru)
      print("Jumlah penggantian:", jumlah_ganti)
      -- Output:
      -- String baru: Ini adalah teks kalimat. Ini adalah teks.
      -- Jumlah penggantian: 2

      -- Hanya ganti kemunculan pertama
      local kalimat_pertama, jumlah_ganti_pertama = string.gsub(kalimat, "contoh", "teks", 1)
      print("Ganti pertama saja:", kalimat_pertama)
      print("Jumlah penggantian (pertama):", jumlah_ganti_pertama)
      -- Output:
      -- Ganti pertama saja: Ini adalah teks kalimat. Ini adalah contoh.
      -- Jumlah penggantian (pertama): 1
      ```

      - **Penjelasan per Sintaksis**:
        - `string.gsub(kalimat, "contoh", "teks")`: Mencari semua kemunculan string `"contoh"` dalam `kalimat` dan menggantinya dengan `"teks"`. Mengembalikan string yang dimodifikasi dan jumlah penggantian.
        - `string.gsub(kalimat, "contoh", "teks", 1)`: Parameter `1` membatasi penggantian hanya pada kemunculan pertama.

  - **Penggantian dengan Pola (Patterns)**:
    `string.gsub()` memanfaatkan _Lua Patterns_ dengan sangat efektif.

    - **Contoh Kode**:

      ```lua
      local teks_nomor = "telepon: 123-456-7890, hp: 987-654-3210"

      -- Ganti semua digit dengan '#'
      local sensor_nomor, _ = string.gsub(teks_nomor, "%d", "#")
      print("Nomor disensor:", sensor_nomor)
      -- Output: Nomor disensor: telepon: ###-###-####, hp: ###-###-####

      local url = "https://www.example.com/path/to/page.html"
      -- Ganti semua non-alphanumeric dengan '_'
      local url_bersih, _ = string.gsub(url, "[^%w_]", "_")
      -- [^%w_] berarti: karakter yang BUKAN (%^) word character (%w) dan BUKAN underscore (_)
      print("URL bersih:", url_bersih)
      -- Output: URL bersih: https___www_example_com_path_to_page_html
      ```

      - **Penjelasan per Sintaksis**:
        - `string.gsub(teks_nomor, "%d", "#")`: Menggunakan pola `%d` (setiap digit) untuk diganti dengan `#`.
        - `string.gsub(url, "[^%w_]", "_")`:
          - `[^%w_]`: Ini adalah sebuah _character class_ negasi.
            - `[` dan `]`: Mendefinisikan sebuah _character class_.
            - `^` di awal `[`: Mennegasi _character class_, artinya "cocokkan karakter APAPUN yang BUKAN karakter-karakter di dalam `[]`".
            - `%w`: Karakter _word_ (huruf, angka, atau underscore).
            - `_`: Karakter underscore literal.
          - Jadi, `[^%w_]` akan cocok dengan setiap karakter yang bukan huruf, angka, atau underscore, dan menggantinya dengan `_`.

  - **Penggantian dengan Fungsi (Transformasi Dinamis)**:
    Ini adalah fitur yang sangat canggih. Anda bisa memberikan fungsi sebagai argumen `repl`. Fungsi ini akan dipanggil untuk setiap kecocokan pola, dan apa pun yang dikembalikan oleh fungsi tersebut akan digunakan sebagai pengganti. Argumen yang diterima fungsi adalah bagian dari string yang cocok dengan pola, serta _captured values_ (jika ada).

    - **Contoh Kode**:

      ```lua
      local daftar_harga = "Apel ($1.50), Jeruk ($2.00), Mangga ($3.25)"

      -- Ubah harga menjadi format rupiah (dengan asumsi 1 USD = 15000 IDR)
      local daftar_rupiah, _ = string.gsub(daftar_harga, "%$(%d+%.%d+)", function(harga_usd_str)
          local harga_usd = tonumber(harga_usd_str)
          local harga_idr = harga_usd * 15000
          return string.format("Rp%.0f", harga_idr)
      end)
      print("Daftar Rupiah:", daftar_rupiah)
      -- Output: Daftar Rupiah: Apel (Rp22500), Jeruk (Rp30000), Mangga (Rp48750)

      print("--------------------")

      local teks_campur = "ini KECIL dan INI BESAR"
      -- Ubah setiap kata menjadi Title Case (huruf pertama kapital)
      local title_case_teks, _ = string.gsub(teks_campur, "(%a+)", function(word)
          return string.upper(string.sub(word, 1, 1)) .. string.lower(string.sub(word, 2))
      end)
      print("Title Case:", title_case_teks)
      -- Output: Title Case: Ini Kecil Dan Ini Besar
      ```

      - **Penjelasan per Sintaksis**:
        - **Contoh Harga ke Rupiah**:
          - Pola: `"%$(%d+%.%d+)"`:
            - `%$`: Mencocokkan karakter `$` literal (di-_escape_).
            - `(%d+%.%d+)`: Capture. Mencocokkan satu atau lebih digit, diikuti oleh titik (di-_escape_), diikuti oleh satu atau lebih digit. Ini akan menangkap string harga seperti "1.50".
          - Fungsi pengganti: `function(harga_usd_str)`
            - Fungsi ini menerima satu argumen: `harga_usd_str`, yang merupakan string yang ditangkap oleh pola `(%d+%.%d+)`.
            - `local harga_usd = tonumber(harga_usd_str)`: Mengkonversi string harga yang ditangkap menjadi angka.
            - `local harga_idr = harga_usd * 15000`: Melakukan perhitungan konversi.
            - `return string.format("Rp%.0f", harga_idr)`: Mengembalikan string baru yang akan digunakan sebagai pengganti, diformat sebagai Rupiah tanpa desimal.
        - **Contoh Title Case**:
          - Pola: `"(%a+)"`: Capture. Mencocokkan satu atau lebih huruf (`%a`). Ini akan menangkap setiap kata.
          - Fungsi pengganti: `function(word)`
            - Fungsi ini menerima satu argumen: `word`, yaitu kata yang cocok dengan pola.
            - `string.upper(string.sub(word, 1, 1))`: Mengambil huruf pertama dari kata (`string.sub(word, 1, 1)`) dan mengubahnya menjadi huruf kapital (`string.upper()`).
            - `string.lower(string.sub(word, 2))`: Mengambil sisa kata dari huruf kedua dan mengubahnya menjadi huruf kecil (`string.lower()`).
            - `..`: Menggabungkan huruf pertama yang dikapitalisasi dengan sisa kata yang dikecilkan.

  - **Sumber Terverifikasi**: Programming in Lua Chapter 20, Lua 5.4 Reference Manual Section 6.4.

- `string.format()`: Advanced formatting (padding, precision)

  Kita sudah membahas dasar `string.format()` di bagian 2.2. Sekarang mari kita lihat fitur format yang lebih canggih seperti _padding_ dan _precision_.

  - **Terminologi**:

    - **Padding**: Menambahkan spasi atau karakter lain ke sebuah string untuk mencapai lebar tertentu.
    - **Precision**: Menentukan jumlah digit setelah titik desimal untuk angka floating-point, atau jumlah karakter untuk string.

  - **Padding (`%w` atau `%0w`)**:

    - `%w`: Padding dengan spasi di sebelah kiri.
    - `%0w`: Padding dengan angka nol di sebelah kiri (khusus untuk angka).
    - `%-w`: Padding dengan spasi di sebelah kanan.
    - **Contoh Kode**:

      ```lua
      local kode_produk = 123
      local harga = 9.99

      -- Padding angka dengan spasi (lebar total 5 karakter)
      print(string.format("Kode: %5d", kode_produk))
      -- Output: Kode:   123 (3 spasi + 123)

      -- Padding angka dengan nol (lebar total 5 karakter)
      print(string.format("Kode: %05d", kode_produk))
      -- Output: Kode: 00123

      -- Padding string dengan spasi (lebar total 10 karakter, rata kanan)
      print(string.format("Nama: %10s", "Ali"))
      -- Output: Nama:        Ali

      -- Padding string dengan spasi (lebar total 10 karakter, rata kiri)
      print(string.format("Nama: %-10s", "Ali"))
      -- Output: Nama: Ali
      ```

      - **Penjelasan per Sintaksis**:
        - `%5d`: Mengformat bilangan bulat (`d`) agar memiliki lebar total 5 karakter. Jika bilangan lebih pendek dari 5, spasi akan ditambahkan di sebelah kiri.
        - `%05d`: Sama seperti `%5d`, tetapi menggunakan `0` sebagai karakter _padding_ di sebelah kiri untuk bilangan bulat.
        - `%10s`: Mengformat string (`s`) agar memiliki lebar total 10 karakter, dengan spasi ditambahkan di sebelah kiri untuk rata kanan.
        - `%-10s`: Mengformat string (`s`) agar memiliki lebar total 10 karakter, dengan spasi ditambahkan di sebelah kanan untuk rata kiri.

  - **Precision (`.p`)**:

    - Untuk `%f`: Menentukan jumlah digit setelah titik desimal.
    - Untuk `%s`: Menentukan jumlah maksimum karakter yang akan diambil dari string.
    - **Contoh Kode**:

      ```lua
      local nilai_pi = math.pi -- Nilai pi dari pustaka math

      -- Presisi float (2 desimal)
      print(string.format("Pi (2 desimal): %.2f", nilai_pi))
      -- Output: Pi (2 desimal): 3.14

      -- Presisi float (4 desimal)
      print(string.format("Pi (4 desimal): %.4f", nilai_pi))
      -- Output: Pi (4 desimal): 3.1416

      local kalimat_panjang = "Ini adalah kalimat yang sangat panjang."
      -- Memotong string ke 10 karakter pertama
      print(string.format("Potongan: %.10s", kalimat_panjang))
      -- Output: Potongan: Ini adala
      ```

      - **Penjelasan per Sintaksis**:
        - `%.2f`: Mengformat angka _floating-point_ (`f`) dengan presisi 2 digit setelah koma.
        - `%.4f`: Mengformat angka _floating-point_ (`f`) dengan presisi 4 digit setelah koma.
        - `%.10s`: Mengformat string (`s`) dengan presisi 10, yang berarti hanya 10 karakter pertama dari string yang akan digunakan.

  - **Menggabungkan Padding dan Precision**:
    Anda bisa menggabungkan lebar (padding) dan presisi.

    - **Sintaks**: `%[flags][width][.precision]type`
    - **Contoh Kode**:

      ```lua
      local data = {
          {nama = "Laptop", harga = 1200.50, stok = 10},
          {nama = "Keyboard", harga = 75.25, stok = 500},
          {nama = "Mouse", harga = 25.00, stok = 120}
      }

      print(string.format("%-15s %10s %5s", "Nama Produk", "Harga", "Stok"))
      print(string.rep("-", 33))
      for _, item in ipairs(data) do
          print(string.format("%-15s %10.2f %5d", item.nama, item.harga, item.stok))
      end
      -- Output:
      -- Nama Produk      Harga  Stok
      -- ---------------------------------
      -- Laptop           1200.50    10
      -- Keyboard           75.25   500
      -- Mouse              25.00   120
      ```

      - **Penjelasan per Sintaksis**:
        - `string.format("%-15s %10s %5s", "Nama Produk", "Harga", "Stok")`:
          - `%-15s`: String, lebar minimum 15 karakter, rata kiri.
          - `%10s`: String, lebar minimum 10 karakter, rata kanan.
          - `%5s`: String, lebar minimum 5 karakter, rata kanan.
        - `string.rep("-", 33)`: Mencetak garis pemisah sepanjang 33 karakter.
        - `for _, item in ipairs(data) do ... end`: Mengulang setiap elemen dalam tabel `data`. `ipairs` adalah iterator yang menghasilkan indeks dan nilai untuk elemen berurutan dalam tabel.
        - `string.format("%-15s %10.2f %5d", item.nama, item.harga, item.stok)`:
          - `%-15s`: Nama produk (string), lebar 15, rata kiri.
          - `%10.2f`: Harga (float), lebar 10, presisi 2 desimal, rata kanan.
          - `%5d`: Stok (integer), lebar 5, rata kanan.

  - **Sumber Terverifikasi**: Programming in Lua Chapter 20, Lua 5.4 Reference Manual Section 6.4.

- `string.gfind()` (Deprecated in 5.2+, replaced by `string.gmatch()`)

  `string.gfind()` adalah fungsi yang ada di Lua versi lama (sebelum 5.2). Fungsinya sama dengan `string.gmatch()`, yaitu untuk mengulang semua kemunculan pola. Namun, sejak Lua 5.2, `string.gmatch()` telah menggantikan `string.gfind()` dan merupakan cara yang disarankan untuk melakukan iterasi pola.

  - **Terminologi**:

    - **Deprecated**: Fitur yang masih ada dalam bahasa, tetapi tidak lagi direkomendasikan untuk digunakan di kode baru karena ada alternatif yang lebih baik atau karena akan dihapus di masa depan.

  - **Mengapa `string.gmatch()` Lebih Baik?**:
    `string.gmatch()` dirancang untuk menjadi lebih fleksibel dan efisien dalam konteks _iterators_ di Lua. Implementasinya lebih modern dan sesuai dengan filosofi Lua yang lebih baru.

  - **Kesimpulan**:
    **Jangan gunakan `string.string.gfind()` di kode baru Anda.** Selalu gunakan `string.gmatch()` untuk iterasi pola.

  - **Sumber Terverifikasi**: Lua 5.2 Release Notes (perubahan), Lua 5.4 Reference Manual (tidak lagi mencantumkan `string.gfind`).

---

Ini adalah akhir dari pembahasan **LEVEL 2.3: String Manipulation and Transformation Functions**. Anda telah belajar tentang `string.gsub()` yang sangat serbaguna untuk penggantian string (dengan string literal, pola, dan fungsi dinamis), serta penggunaan `string.format()` untuk output yang diformat dengan _padding_ dan _precision_. Anda juga memahami mengapa `string.gfind()` sebaiknya dihindari demi `string.gmatch()`.

#

Dengan selesainya Level 2, Anda kini memiliki pemahaman yang kuat tentang fungsi-fungsi inti yang disediakan oleh pustaka `string` di Lua. Ini adalah dasar yang sangat penting sebelum kita melangkah lebih jauh ke **LEVEL 3: LUA PATTERNS**. Bersiaplah, karena Lua Patterns adalah bagian yang paling menarik dan kuat dari manipulasi string di Lua!

</details>

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
