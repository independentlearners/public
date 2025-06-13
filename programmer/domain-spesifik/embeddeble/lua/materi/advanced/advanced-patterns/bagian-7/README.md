Kita telah menempuh perjalanan panjang, dari dasar-dasar pattern, melalui parsing kompleks dengan LPeg, hingga metaprogramming. Sekarang, kita akan melakukan pergeseran konseptual. Bagian ini tidak lagi berfokus pada _pattern of text_ (pola tekstual), melainkan pada _patterns of programming_ (pola-pola desain dalam pemrograman). Tujuannya adalah untuk melihat bagaimana kemampuan manipulasi teks yang telah kita pelajari dapat diintegrasikan secara cerdas ke dalam arsitektur program yang lebih besar dan canggih seperti coroutines, state machines, dan sistem event.

---

### Daftar Isi (Bagian VII)

- [**BAGIAN VII: ADVANCED PROGRAMMING PATTERNS**](#bagian-7)
  - [7.1 Coroutine Patterns Lanjutan](#71-coroutine-patterns-lanjutan)
  - [7.2 State Machine Patterns](#72-state-machine-patterns)
  - [7.3 Iterator Patterns Komprehensif](#73-iterator-patterns-komprehensif)
  - [7.4 Observer dan Event Patterns](#74-observer-dan-event-patterns)
  - [7.5 Memory Management Patterns](#75-memory-management-patterns)

---

## **[BAGIAN VII: ADVANCED PROGRAMMING PATTERNS][0]**

### 7.1 Coroutine Patterns Lanjutan

_Coroutines_ di Lua adalah thread eksekusi kooperatif yang dapat dijeda (`yield`) dan dilanjutkan (`resume`). Ini memungkinkan kita menulis alur kerja asinkron atau non-blokir dengan cara yang terlihat sinkron.

- **Generator Patterns dengan Coroutines**: Coroutine sangat ideal untuk membuat _generator_, yaitu fungsi yang menghasilkan serangkaian nilai satu per satu, sesuai permintaan.

  - **Integrasi Pattern**: Bayangkan mem-parsing file log berukuran gigabyte. Memuat seluruhnya ke memori adalah mustahil. Sebagai gantinya, sebuah coroutine dapat membaca file baris per baris, menggunakan `string.match` untuk menemukan entri yang relevan, dan `coroutine.yield()` setiap kali menemukan satu entri. Program utama kemudian memanggil `coroutine.resume()` berulang kali untuk mendapatkan entri berikutnya, sehingga penggunaan memori tetap minimal.

  <!-- end list -->

  ```lua
  function LogEntryGenerator(filename, pattern)
    return coroutine.create(function()
      for line in io.lines(filename) do
        local match = string.match(line, pattern)
        if match then
          coroutine.yield(match) -- Jeda dan berikan hasil
        end
      end
    end)
  end

  local my_log_gen = LogEntryGenerator("server.log", "(%S+:%d+ ERROR: .*)")

  -- Ambil 5 error pertama
  for i = 1, 5 do
    local status, value = coroutine.resume(my_log_gen)
    if not status or not value then break end
    print(value)
  end
  ```

- **Pipeline Processing Patterns**: Anda dapat merangkai beberapa coroutine menjadi sebuah _pipeline_ pemrosesan.

  - **Coroutine A**: Membaca data mentah dari jaringan dan menggunakan pattern untuk merakit paket-paket lengkap, lalu `yield` setiap paket.
  - **Coroutine B**: Menerima paket dari Coroutine A, mem-parsing headernya menggunakan `string.unpack`, dan `yield` payload-nya.
  - **Coroutine C**: Menerima payload dari Coroutine B dan melakukan pemrosesan akhir.

- **Asynchronous Pattern Matching**: Dalam lingkungan event-driven (seperti server web OpenResty atau game engine), coroutine dapat memulai operasi parsing yang kompleks. Jika ia membutuhkan lebih banyak data (misalnya, menunggu data dari socket jaringan), ia dapat `yield`. Event loop utama akan mengambil alih, dan ketika data baru tiba, ia akan me-`resume` coroutine parsing untuk melanjutkan tepat di mana ia berhenti.

### 7.2 State Machine Patterns

_Finite State Machine_ (FSM) adalah model komputasi yang terdiri dari sejumlah status, transisi antar status, dan aksi yang terkait.

- **Pattern-driven State Machines**: Di sinilah integrasi terjadi. Input yang memicu transisi antar status adalah sebuah string, dan setiap status menggunakan pattern matching untuk memutuskan aksi apa yang harus diambil atau ke status mana harus bertransisi.
- **Contoh**: Sebuah parser untuk protokol jaringan sederhana atau bot chat.
  - **State**: `WAITING_FOR_GREETING`
  - **Input**: `"HELLO client1"`
  - **Aksi**: Mesin dalam state `WAITING_FOR_GREETING` menggunakan pattern `^HELLO (%S+)$` untuk mem-parsing input. Karena cocok, ia mengekstrak nama klien (`"client1"`), melakukan aksi (misalnya, mencatat klien), dan bertransisi ke state `PROCESSING_COMMANDS`. Jika input tidak cocok, ia tetap di state yang sama atau pindah ke state `ERROR`.

<!-- end list -->

```lua
local state = "WAITING"
local fsm = {
  WAITING = function(input)
    if string.match(input, "^CONNECT") then
      print("Connection established.")
      state = "CONNECTED"
    end
  end,
  CONNECTED = function(input)
    local user = string.match(input, "^USER (%a+)")
    if user then
      print("User set to:", user)
      state = "AUTHENTICATED"
    elseif string.match(input, "^QUIT") then
      print("Disconnecting.")
      state = "END"
    end
  end,
  -- state lainnya...
}

function processInput(input)
  local handler = fsm[state]
  if handler then handler(input) end
end

processInput("CONNECT") -- Output: Connection established.
processInput("USER Budi") -- Output: User set to: Budi
```

### 7.3 Iterator Patterns Komprehensif

Iterator adalah mekanisme yang memungkinkan perulangan `for` pada koleksi data kustom.

- **Custom Iterator dengan Pattern Matching**: Fungsi `string.gmatch` pada dasarnya adalah sebuah factory yang mengembalikan iterator. Anda dapat membungkusnya dalam fungsi Anda sendiri untuk membuat iterator yang lebih canggih, yang mungkin melakukan pra-pemrosesan atau logging.
- **Lazy Evaluation Patterns**: Ini sangat terkait dengan pola Generator Coroutine. Sebuah iterator yang diimplementasikan dengan coroutine hanya akan melakukan pekerjaan untuk mencari kecocokan berikutnya saat diminta oleh loop `for`. Ini adalah bentuk _lazy evaluation_, yang sangat efisien karena tidak ada pekerjaan yang dilakukan di muka.
- **Stream Processing Patterns**: Ini adalah aplikasi dari iterator pemalas pada aliran data (stream) yang berpotensi tak terbatas. Iterator akan membaca sepotong data dari stream (misalnya, file atau koneksi jaringan), menggunakan pattern untuk menemukan satu atau lebih "rekaman" lengkap di dalamnya, mengembalikannya, dan menyimpan sisa data yang belum diproses untuk iterasi berikutnya.

### 7.4 Observer dan Event Patterns

Pola Observer (atau Publish-Subscribe) memungkinkan objek ("subscriber") untuk mendaftar dan menerima notifikasi tentang event yang dipublikasikan oleh objek lain ("publisher").

- **Event Pattern Matching**: Daripada mendaftar untuk nama event yang harfiah, subscriber bisa mendaftar menggunakan sebuah pattern.
- **Contoh**: Bayangkan sebuah sistem dengan nama event yang terstruktur seperti `user.login.success`, `user.login.failed`, `payment.creditcard.success`.
  - Sebuah modul logging mungkin berlangganan ke `*.failed` untuk mencatat semua kegagalan.
  - Sebuah modul keamanan mungkin berlangganan ke `user.login.*` untuk memantau semua aktivitas login.
  - Sebuah modul notifikasi mungkin berlangganan ke `payment.*.success`.
- **Implementasi**: Ketika sebuah event (misalnya, `"user.login.success"`) dipublikasikan, sistem event akan melalui daftar subscriber-nya, dan untuk setiap subscriber, ia akan menggunakan `string.match(eventName, subscriberPattern)` untuk melihat apakah subscriber tersebut tertarik dengan event ini.

### 7.5 Memory Management Patterns

Ini adalah tentang bagaimana hasil dan proses pattern matching memengaruhi penggunaan memori.

- **Weak References dengan Patterns**: Jika Anda meng-cache hasil parsing yang mahal (misalnya, mem-parse file konfigurasi yang kompleks menjadi tabel Lua), Anda bisa menyimpannya dalam cache global. Agar cache ini tidak menyebabkan memory leak, Anda dapat menggunakan _weak table_. Jika tidak ada bagian lain dari program Anda yang memegang referensi kuat ke tabel hasil parsing, Garbage Collector akan secara otomatis menghapusnya dari cache.
  - Anda akan menggunakan `setmetatable(cache, {__mode = "v"})` di mana nilai-nilainya (hasil parsing) bersifat lemah.
- **Resource Management**: Jika operasi pattern matching menghasilkan sumber daya yang perlu dibersihkan (seperti file handle atau koneksi database yang dibungkus dalam `userdata`), sangat penting untuk menggunakan metamethod `__gc` untuk memastikan sumber daya tersebut dilepaskan dengan benar saat tidak lagi digunakan. Ini adalah jembatan langsung ke kurikulum Metatables yang telah kita bahas sebelumnya.

---

Bagian ini telah memperluas cakrawala Anda, menunjukkan bahwa pattern matching bukan hanya alat untuk manipulasi string, tetapi juga komponen desain yang kuat dalam arsitektur perangkat lunak yang lebih besar. Selanjutnya, kita akan kembali ke ranah yang lebih teknis: menganalisis dan mengoptimalkan kinerja dari pattern matching itu sendiri.

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
