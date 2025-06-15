Setelah membekali diri dengan fondasi, teknik lanjutan, metaprogramming, dan pertimbangan kinerja, sekarang saatnya melihat bagaimana semua itu diterapkan di dunia nyata. Bagian ini akan menunjukkan penggunaan praktis dari pattern matching dalam berbagai domain rekayasa perangkat lunak, membuktikan bahwa ini bukan hanya keterampilan akademis, tetapi alat kerja yang fundamental.

---

### Daftar Isi (Bagian IX)

- [**BAGIAN IX: REAL-WORLD APPLICATIONS**](#bagian-ix-real-world-applications)
  - [9.1 Web Development Patterns](#91-web-development-patterns)
  - [9.2 Game Development Patterns](#92-game-development-patterns)
  - [9.3 Network Programming Patterns](#93-network-programming-patterns)
  - [9.4 Data Processing Patterns](#94-data-processing-patterns)
  - [9.5 System Administration Patterns](#95-system-administration-patterns)

---

## **[BAGIAN IX: REAL-WORLD APPLICATIONS][0]**

### 9.1 Web Development Patterns

Dalam pengembangan web, terutama di backend, manipulasi string terjadi di mana-mana, mulai dari request pertama hingga response terakhir.

- **URL Routing Patterns**: Web framework perlu memetakan URL yang masuk (misalnya `/users/123/profile`) ke fungsi handler yang benar. Pattern, terutama LPeg, sangat ideal untuk ini.

  ```lua
  local lpeg = require("lpeg")

  -- Definisikan rute sebagai pattern
  local routes = {
    -- Tangkap angka sebagai 'id'
    { pattern = lpeg.P"/users/" * lpeg.Cg(lpeg.R"09"^1, "id") * lpeg.P"/profile",
      handler = function(params) print("Menampilkan profil untuk user ID:", params.id) end },
    { pattern = lpeg.P"/posts",
      handler = function(params) print("Menampilkan semua post") end },
  }

  function route_request(path)
    for _, route in ipairs(routes) do
      local captures = { route.pattern:match(path) }
      if captures[1] then
        route.handler(captures)
        return
      end
    end
    print("404 Not Found")
  end

  route_request("/users/123/profile") -- Output: Menampilkan profil untuk user ID:   123
  ```

- **Request Validation Patterns**: Memvalidasi input dari pengguna sebelum memprosesnya adalah hal yang krusial untuk keamanan dan integritas data. Pattern digunakan untuk memastikan format email, tanggal, nomor telepon, atau untuk menyaring karakter yang tidak diizinkan.

- **Template Engine Patterns**: Ini adalah inti dari rendering sisi server. Seperti yang dibahas di Bagian VI, `string.gsub` dengan fungsi callback digunakan untuk mengganti placeholder seperti `${user.name}` dalam file template HTML dengan data aktual sebelum mengirimkannya ke browser.

- **HTTP Header dan Cookie Parsing**: Header HTTP dan cookie pada dasarnya adalah string dengan format key-value. `string.gmatch` dapat digunakan untuk mengulang setiap baris header, dan `string.match` dapat mem-parsing setiap baris menjadi nama dan nilainya.

---

### 9.2 Game Development Patterns

Lua sangat dominan dalam scripting game, dan pattern matching adalah alat sehari-hari bagi para desainer dan programmer game.

- **Asset Path Pattern Matching**: Game memiliki ribuan file aset. Pattern digunakan untuk memvalidasi atau mencari aset berdasarkan jalur filenya, misalnya, menemukan semua tekstur karakter `"/characters/player/skins/.*.png"`.
- **Configuration Parsing Patterns**: Statistik karakter, properti item, dialog NPC, dan perilaku AI sering kali didefinisikan dalam file teks. Pattern digunakan untuk mem-parsing file-file ini saat game dimuat.
- **Save File Parsing**: Memuat state permainan dari file yang disimpan melibatkan parsing data yang telah diserialisasi, yang seringkali merupakan tugas bagi pattern matching.
- **Cheat Detection Patterns**: Dalam game online, pattern dapat digunakan untuk memindai lalu lintas jaringan atau memori game untuk mencari "tanda tangan" (signatures) dari program cheat yang dikenal.

---

### 9.3 Network Programming Patterns

Pemrograman jaringan pada dasarnya adalah tentang mengirim dan menerima pesan terstruktur melalui koneksi.

- **Protocol Parsing Patterns**: Ini adalah penggunaan yang paling fundamental. Protokol jaringan, baik berbasis teks (seperti HTTP, SMTP) maupun biner, memiliki aturan format yang ketat. Pattern digunakan untuk membedah aliran data mentah menjadi pesan-pesan yang dapat dipahami. Untuk protokol biner, ini melibatkan `string.unpack` (seperti dibahas di Bagian V), sementara untuk protokol teks, `string.match` atau LPeg adalah alatnya.
- **Packet Analysis**: Alat seperti Wireshark (yang menggunakan Lua secara ekstensif untuk plugin) menggunakan "dissectors" untuk menganalisis paket jaringan. Dissector ini pada dasarnya adalah parser yang menggunakan logika pattern matching untuk menafsirkan setiap byte dalam sebuah paket.
- **Stream Processing**: Saat membaca dari socket, Anda mendapatkan aliran byte yang berkelanjutan. Anda perlu menggunakan pattern untuk menemukan batas pesan (misalnya, karakter newline dalam protokol sederhana, atau header panjang-pesan dalam protokol yang lebih kompleks) sebelum Anda dapat mem-parsing pesan itu sendiri.

---

### 9.4 Data Processing Patterns

Ini adalah aplikasi skala besar dari teknik yang telah kita pelajari, seringkali dalam konteks big data atau Business Intelligence.

- **ETL Pipeline Patterns**: Dalam proses ETL (Extract, Transform, Load), pattern sangat penting.
  - **Extract**: Mem-parsing data dari sumber yang beragam, seperti file log mentah, CSV, atau teks tidak terstruktur.
  - **Transform**: Membersihkan, menormalkan, dan merestrukturisasi data yang diekstrak menggunakan `string.gsub`.
- **Data Validation Patterns**: Sebelum memuat data ke dalam database atau data warehouse, data tersebut harus divalidasi untuk memastikan kualitasnya. Pattern digunakan untuk memeriksa apakah setiap bidang data sesuai dengan format yang diharapkan (misalnya, kode pos, nomor identifikasi).
- **Report Generation Patterns**: Mengambil data mentah dan menggunakan sistem template berbasis pattern untuk menghasilkan laporan yang dapat dibaca manusia dalam format teks, CSV, atau bahkan HTML.

---

### 9.5 System Administration Patterns

Para administrator sistem (sysadmins) sering menulis skrip untuk mengotomatiskan tugas-tugas, dan sebagian besar tugas ini melibatkan pemrosesan teks.

- **Log Analysis Patterns**: Ini mungkin penggunaan \#1. Skrip menggunakan `gmatch` untuk menyisir file log sistem, web server, atau database yang berukuran besar untuk menemukan pesan kesalahan, melacak aktivitas mencurigakan, atau mengumpulkan statistik.
- **Configuration Management**: Skrip otomatisasi menggunakan `string.gsub` untuk membaca, memodifikasi, dan menulis file konfigurasi di seluruh server, memastikan konsistensi.
- **File System Patterns**: Menulis skrip untuk menemukan file berdasarkan pola nama, atau memindai konten dari ribuan file untuk mencari string atau pola tertentu.
- **Process Monitoring**: Skrip dapat menjalankan perintah sistem seperti `ps` atau `netstat` dan kemudian mem-parsing output teksnya untuk mengekstrak informasi tentang proses yang berjalan atau koneksi jaringan aktif.

---

Bagian ini telah menunjukkan betapa serbaguna dan fundamentalnya keahlian pattern matching. Ini bukan hanya tentang mem-parsing string, tetapi tentang membangun router web, mengelola aset game, mengamankan jaringan, memproses data, dan mengotomatiskan infrastruktur.

#

Selanjutnya, kita akan masuk lebih dalam lagi ke ranah teknis dengan melihat bagaimana pattern ini berinteraksi dengan C API Lua, membuka tingkat kinerja dan kemampuan baru.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-8/README.md
[selanjutnya]: ../bagian-10/README.md

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
