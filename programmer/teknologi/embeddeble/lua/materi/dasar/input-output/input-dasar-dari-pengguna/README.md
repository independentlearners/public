# **[2. Input Dasar dari Pengguna][1]**

Bagian ini akan fokus pada cara program Lua Anda dapat menerima input langsung dari pengguna, biasanya melalui ketikan keyboard di konsol.

### 2.1 Membaca Input Sederhana

**Deskripsi Konkret:**
Cara paling dasar untuk mendapatkan input dari pengguna di Lua adalah dengan menggunakan fungsi `io.read()`. Fungsi ini akan menunggu pengguna mengetikkan sesuatu di konsol dan menekan Enter. Apa yang diketik pengguna kemudian dapat disimpan dalam variabel untuk digunakan lebih lanjut oleh program.

**Menggunakan `io.read()` untuk input dasar:**

- **Konsep**: Fungsi `io.read()` adalah bagian dari pustaka `io` (Input/Output) Lua. Ketika dipanggil tanpa argumen atau dengan argumen format tertentu, ia akan membaca dari _input file default_, yang secara standar adalah `stdin` (standard input, yaitu keyboard).
- **Cara Kerja**: Program akan berhenti sejenak (pause) pada baris `io.read()`, menunggu pengguna memasukkan teks dan menekan tombol Enter. Setelah Enter ditekan, teks yang dimasukkan (sebagai string) akan menjadi nilai kembali (return value) dari fungsi `io.read()`.

**Jenis-jenis parameter untuk `io.read()`:**
Fungsi `io.read()` dapat menerima beberapa jenis argumen (disebut juga "format") yang menentukan _bagaimana_ ia harus membaca input. Jika dipanggil tanpa argumen, perilakunya sama seperti `io.read("*l")`. Berikut adalah beberapa format yang umum digunakan:

1.  `"*l"` (line - baris):

    - **Deskripsi**: Membaca satu baris teks penuh hingga pengguna menekan Enter (karakter newline `\n` juga ikut terbaca namun biasanya tidak disertakan dalam string hasil, kecuali jika file input memiliki karakter newline di akhir). Jika sudah mencapai akhir input (End-Of-File atau EOF), ia akan mengembalikan `nil`. Ini adalah format yang paling umum untuk input pengguna interaktif.
    - **Terminologi**:
      - **Newline (`\n`)**: Karakter khusus yang menandakan akhir baris.
      - **End-Of-File (EOF)**: Kondisi yang menandakan bahwa tidak ada lagi data untuk dibaca dari sumber input. Saat membaca dari keyboard, Anda biasanya bisa mengirim EOF dengan menekan `Ctrl+D` (di Linux/macOS) atau `Ctrl+Z` lalu Enter (di Windows) pada baris baru.
    - **Contoh Kode**:

      ```lua
      print("Siapa nama panggilan Anda?")
      local namaPanggilan = io.read("*l") -- Membaca satu baris input

      -- Penjelasan Sintaks:
      -- local: Kata kunci untuk mendeklarasikan variabel lokal.
      -- namaPanggilan: Nama variabel untuk menyimpan hasil input.
      -- =: Operator assignment.
      -- io.read: Fungsi dari library 'io' untuk membaca input.
      -- "*l": Argumen format yang memberitahu io.read() untuk membaca seluruh baris.

      print("Halo, " .. namaPanggilan .. "!")

      -- Penjelasan Sintaks:
      -- print: Fungsi untuk menampilkan output.
      -- "Halo, ": String literal.
      -- ..: Operator konkatenasi string.
      -- namaPanggilan: Variabel yang berisi input pengguna.
      -- "!": String literal.
      ```

2.  `"*n"` (number - angka):

    - **Deskripsi**: Mencoba membaca sebuah angka (bilangan numerik) dari input. Ia akan melewati spasi di awal, lalu membaca sejauh mungkin karakter yang membentuk angka. Jika berhasil membaca angka yang valid, ia akan mengembalikan nilai bertipe `number`. Jika karakter pertama setelah spasi bukan merupakan bagian dari angka yang valid (misalnya huruf), atau jika tidak ada input yang bisa diinterpretasikan sebagai angka, ia akan mengembalikan `nil`.
    - **Contoh Kode**:

      ```lua
      print("Masukkan usia Anda (angka):")
      local usia = io.read("*n") -- Mencoba membaca sebagai angka

      -- Penjelasan Sintaks:
      -- usia: Variabel untuk menyimpan hasil input (yang diharapkan berupa angka).
      -- "*n": Argumen format untuk membaca angka.

      if usia then -- Memeriksa apakah input berhasil dikonversi menjadi angka
          print("Usia Anda adalah " .. usia .. " tahun.")
          print("Tipe data usia:", type(usia)) -- Akan menampilkan 'number'
      else
          print("Input yang Anda masukkan bukan angka yang valid.")
      end

      -- Penjelasan Sintaks:
      -- if usia then: Kondisi ini bernilai true jika 'usia' bukan nil (artinya io.read("*n") berhasil).
      -- type(usia): Fungsi bawaan Lua untuk mendapatkan tipe data dari sebuah variabel.
      ```

3.  `"*a"` (all - semua):

    - **Deskripsi**: Membaca seluruh sisa input dari posisi saat ini hingga End-Of-File (EOF). Jika tidak ada lagi yang bisa dibaca (langsung EOF), ia akan mengembalikan string kosong `""`. Ini lebih sering digunakan untuk membaca isi file sekaligus daripada input interaktif dari pengguna, karena pada input interaktif, "akhir file" biasanya baru terjadi jika pengguna secara eksplisit memberi sinyal EOF.
    - **Contoh Kode (kurang umum untuk input pengguna langsung, lebih untuk file):**

      ```lua
      print("Masukkan beberapa baris teks. Tekan Ctrl+D (Linux/macOS) atau Ctrl+Z lalu Enter (Windows) untuk selesai:")
      local semuaInput = io.read("*a") -- Membaca semua input hingga EOF

      -- Penjelasan Sintaks:
      -- semuaInput: Variabel untuk menyimpan seluruh input.
      -- "*a": Argumen format untuk membaca semua sisa input.

      print("\n--- Anda memasukkan: ---")
      print(semuaInput)
      ```

4.  `angka` (sebuah angka positif, misalnya `io.read(5)`):

    - **Deskripsi**: Membaca sejumlah `angka` karakter dari input. Jika mencapai EOF sebelum sejumlah karakter tersebut terbaca, ia akan mengembalikan `nil`. Jika berhasil, ia mengembalikan string yang berisi karakter-karakter yang dibaca. Jika `angka` adalah 0, ia akan membaca string kosong dan bisa digunakan untuk menguji apakah sudah EOF.
    - **Contoh Kode**:

      ```lua
      print("Masukkan tepat 3 karakter:")
      local tigaKarakter = io.read(3) -- Membaca tepat 3 karakter

      -- Penjelasan Sintaks:
      -- tigaKarakter: Variabel untuk menyimpan 3 karakter yang dibaca.
      -- 3: Argumen format yang memberitahu io.read() untuk membaca 3 karakter.

      if tigaKarakter then
          print("Anda memasukkan: '" .. tigaKarakter .. "'")
      else
          print("Input tidak mencapai 3 karakter atau sudah EOF.")
      end
      ```

**Penting**:

- Jika `io.read()` dipanggil tanpa argumen, itu sama dengan `io.read("*l")`.
- Anda dapat meminta beberapa format sekaligus, misalnya `local nama, usia = io.read("*l", "*n")`. Lua akan mencoba membaca sesuai format pertama, lalu format kedua dari sisa input, dan seterusnya. Namun, untuk input pengguna interaktif, biasanya lebih jelas jika Anda memanggil `io.read()` secara terpisah untuk setiap bagian data yang diminta.

**Sumber Referensi dari Kurikulum:**

- [Stack Overflow: Getting input from the user in Lua](https://stackoverflow.com/questions/12069109/getting-input-from-the-user-in-lua) (Diskusi Stack Overflow ini seringkali memberikan contoh praktis dan solusi untuk masalah umum terkait `io.read()`).
- Dokumentasi Resmi Lua (misalnya, [Lua 5.4 Reference Manual - `io.read`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%23pdf-io.read%5D(https://www.lua.org/manual/5.4/manual.html%23pdf-io.read)>)): Ini adalah sumber paling otoritatif untuk detail fungsi `io.read()`.

---

### 2.2 Validasi dan Konversi Input

**Deskripsi Konkret:**
Setelah mendapatkan input dari pengguna (yang hampir selalu berupa string, kecuali jika Anda menggunakan `io.read("*n")` dan berhasil), seringkali Anda perlu memvalidasinya (memastikan input sesuai harapan) dan mengkonversinya ke tipe data lain (misalnya, dari string ke angka) sebelum digunakan dalam logika program.

**Mengkonversi string ke number:**

- **Konsep**: Input yang dibaca dengan `io.read()` (atau `io.read("*l")`, `io.read(n)`) adalah string. Jika Anda mengharapkan angka tetapi pengguna memasukkan teks yang terlihat seperti angka (misalnya, "123"), Anda perlu mengkonversinya secara eksplisit menjadi tipe data `number` agar bisa digunakan dalam operasi matematika.
- **Fungsi `tonumber()`**: Fungsi bawaan Lua `tonumber()` digunakan untuk tujuan ini.
  - **Sintaks**: `tonumber(arg)` atau `tonumber(arg, base)`
  - `arg`: String yang ingin Anda konversi.
  - `base` (opsional): Basis angka dari string tersebut (misalnya, 10 untuk desimal, 2 untuk biner, 16 untuk heksadesimal). Jika tidak disertakan, `tonumber` mencoba menginterpretasikannya sebagai desimal, tetapi juga bisa mengenali awalan `0x` untuk heksadesimal atau `0b` untuk biner (tergantung versi Lua).
  - **Return Value**: Mengembalikan angka jika konversi berhasil, atau `nil` jika string tidak dapat dikonversi menjadi angka yang valid.
- **Contoh Kode**:

  ```lua
  print("Masukkan sebuah angka:")
  local inputString = io.read("*l") -- Input selalu dibaca sebagai string

  -- Penjelasan Sintaks io.read():
  -- inputString: Variabel untuk menyimpan input mentah (string).
  -- io.read("*l"): Membaca satu baris input sebagai string.

  local angka = tonumber(inputString) -- Mencoba mengkonversi string ke angka

  -- Penjelasan Sintaks tonumber():
  -- angka: Variabel untuk menyimpan hasil konversi.
  -- tonumber: Fungsi bawaan untuk konversi ke angka.
  -- inputString: Argumen string yang akan dikonversi.

  if angka then
      print("Anda memasukkan angka: " .. angka)
      print("Angka tersebut dikali dua adalah: " .. (angka * 2))
  else
      print("'" .. inputString .. "' bukan merupakan input angka yang valid.")
  end
  ```

**Validasi input pengguna:**

- **Konsep**: Validasi adalah proses memeriksa apakah input yang diberikan pengguna memenuhi kriteria tertentu sebelum diproses lebih lanjut. Ini penting untuk mencegah error, memastikan program berjalan dengan benar, dan meningkatkan keamanan.
- **Teknik Validasi Umum**:
  - **Pengecekan Tipe**: Memastikan input adalah tipe data yang diharapkan (misalnya, angka setelah konversi).
  - **Pengecekan Rentang**: Jika input adalah angka, memastikan nilainya berada dalam rentang yang diizinkan (misalnya, usia harus antara 0 dan 120).
  - **Pengecekan Format**: Memastikan input string mengikuti pola tertentu (misalnya, format email, format tanggal). Ini sering melibatkan fungsi manipulasi string atau pattern matching.
  - **Pengecekan Keberadaan**: Memastikan input tidak kosong jika diperlukan.
- **Contoh Kode (validasi rentang):**

  ```lua
  local nilaiUjian
  repeat
      print("Masukkan nilai ujian Anda (0-100):")
      local input = io.read("*l")
      nilaiUjian = tonumber(input)

      if nilaiUjian == nil then
          print("Input tidak valid. Harap masukkan angka.")
      elseif nilaiUjian < 0 or nilaiUjian > 100 then
          print("Nilai ujian harus antara 0 dan 100. Silakan coba lagi.")
      end
  until nilaiUjian ~= nil and nilaiUjian >= 0 and nilaiUjian <= 100

  -- Penjelasan Sintaks:
  -- local nilaiUjian: Mendeklarasikan variabel di luar loop agar bisa diakses setelah loop.
  -- repeat ... until kondisi: Struktur loop yang akan menjalankan blok kode setidaknya sekali,
  --                          dan akan terus berulang SELAMA (until) kondisi bernilai false.
  --                          Loop berhenti ketika kondisi menjadi true.
  -- input = io.read("*l"): Membaca input pengguna.
  -- nilaiUjian = tonumber(input): Mengkonversi input ke angka.
  -- if nilaiUjian == nil then ...: Memeriksa apakah konversi gagal.
  -- elseif nilaiUjian < 0 or nilaiUjian > 100 then ...: Memeriksa apakah angka di luar rentang.
  --     'or' adalah operator logika.
  -- until nilaiUjian ~= nil and nilaiUjian >= 0 and nilaiUjian <= 100: Kondisi untuk keluar loop.
  --     '~=' berarti "tidak sama dengan".
  --     'and' adalah operator logika. Loop akan berhenti jika nilaiUjian BUKAN nil DAN
  --     nilaiUjian lebih besar atau sama dengan 0 DAN nilaiUjian lebih kecil atau sama dengan 100.

  print("Nilai ujian yang Anda masukkan adalah: " .. nilaiUjian)
  ```

**Error handling pada input:**

- **Konsep**: Penanganan error (error handling) pada input melibatkan bagaimana program Anda merespons ketika input tidak valid atau ketika terjadi masalah selama proses pembacaan input. Daripada program crash, Anda ingin memberikan pesan yang informatif kepada pengguna dan mungkin meminta mereka untuk mencoba lagi.
- **Strategi Dasar**:
  1.  **Periksa Nilai Kembali**: Banyak fungsi I/O (seperti `io.read("*n")`, `tonumber()`) mengembalikan `nil` ketika terjadi kegagalan atau input tidak sesuai format. Selalu periksa apakah hasilnya `nil`.
  2.  **Gunakan Loop untuk Input Ulang**: Jika input tidak valid, gunakan loop (seperti `while` atau `repeat-until`) untuk meminta pengguna memasukkan input kembali sampai valid.
  3.  **Berikan Pesan Error yang Jelas**: Informasikan kepada pengguna _mengapa_ input mereka tidak valid dan _bagaimana_ seharusnya input yang benar.
- **Contoh Kode (menggabungkan beberapa aspek):**

  ```lua
  local jumlahItem

  while true do -- Loop tak terbatas, akan dihentikan dengan 'break'
      print("Masukkan jumlah item yang ingin Anda beli (harus angka positif):")
      local inputPengguna = io.read("*l")

      -- Penjelasan Sintaks:
      -- while true do ... end: Membuat loop yang akan berjalan terus menerus kecuali ada perintah 'break'.
      -- inputPengguna = io.read("*l"): Membaca input sebagai string.

      if inputPengguna == nil then -- Jarang terjadi pada stdin kecuali EOF
          io.stderr:write("Error membaca input atau EOF tercapai.\n")
          -- Di sini Anda bisa memutuskan untuk keluar dari program jika EOF
          -- os.exit(1) -- Contoh: keluar program dengan status error
          break -- Keluar dari loop jika terjadi EOF
      end

      jumlahItem = tonumber(inputPengguna)

      -- Penjelasan Sintaks:
      -- jumlahItem = tonumber(inputPengguna): Konversi ke angka.

      if jumlahItem and jumlahItem > 0 and math.type(jumlahItem) == "integer" then
          -- Validasi: apakah angka, apakah positif, dan apakah integer (opsional, tergantung kebutuhan)
          -- math.type() (Lua 5.3+) bisa mengecek apakah float atau integer.
          -- Untuk Lua < 5.3, bisa cek jumlahItem == math.floor(jumlahItem) untuk integer.
          break -- Input valid, keluar dari loop
      else
          print("Input tidak valid. Harap masukkan angka bulat positif. Contoh: 5, 10, dst.")
      end
      -- Penjelasan Sintaks:
      -- if jumlahItem and jumlahItem > 0 and math.type(jumlahItem) == "integer" then:
      --     jumlahItem: Memastikan konversi berhasil (bukan nil).
      --     jumlahItem > 0: Memastikan angka positif.
      --     math.type(jumlahItem) == "integer": (Untuk Lua 5.3+) Memastikan adalah bilangan bulat.
      --                                         Jika Anda menggunakan Lua versi sebelumnya atau tidak
      --                                         membutuhkan pengecekan integer secara ketat,
      --                                         bagian 'and math.type(jumlahItem) == "integer"' bisa dihilangkan
      --                                         atau diganti dengan 'and jumlahItem == math.floor(jumlahItem)'.
      -- break: Perintah untuk keluar dari loop 'while' saat ini.
      -- else: Jika kondisi if tidak terpenuhi.
  end

  if jumlahItem then -- Periksa lagi untuk kasus break karena EOF
      print("Anda akan membeli " .. jumlahItem .. " item.")
  else
      print("Pembelian dibatalkan atau gagal mendapatkan jumlah item.")
  end
  ```

  _Dalam contoh di atas, `math.type(jumlahItem) == "integer"` adalah spesifik untuk Lua 5.3+. Jika Anda menggunakan versi Lua yang lebih lama, Anda bisa memeriksa apakah sebuah angka adalah integer dengan `jumlahItem == math.floor(jumlahItem)` (dimana `math.floor()` mengembalikan bilangan bulat terbesar yang tidak lebih besar dari argumennya)._

**Sumber Referensi dari Kurikulum:**

- [Dev-HQ: Variables and User Input](http://www.dev-hq.net/lua/3--variables-and-user-input) (Sumber ini kemungkinan membahas variabel bersama dengan cara mendapatkan dan memvalidasi input pengguna).
- Dokumentasi Resmi Lua untuk `tonumber()` ([Lua 5.4 Manual - `tonumber`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%23pdf-tonumber%5D(https://www.lua.org/manual/5.4/manual.html%23pdf-tonumber)>)) dan fungsi matematika seperti `math.floor()` atau `math.type()` ([Lua 5.4 Manual - `math.type`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%23pdf-math.type%5D(https://www.lua.org/manual/5.4/manual.html%23pdf-math.type)>)).

Dengan memahami cara membaca, mengkonversi, dan memvalidasi input, Anda dapat membuat program yang lebih interaktif, robust (tahan banting terhadap kesalahan input), dan ramah pengguna.

> - **[Ke Atas](#)**
> - **[Selanjutnya][2]**
> - **[Sebelumnya][3]**
> - **[Kurikulum][4]**
> - **[Domain Spesifik][5]**

[5]: ../../../../../../README.md
[4]: ../../../../README.md
[3]: ../konsep-dasar-I-O/README.md
[2]: ../simple-model-I-O/README.md
[1]: ../README.md/#2-input-dasar-dari-pengguna
