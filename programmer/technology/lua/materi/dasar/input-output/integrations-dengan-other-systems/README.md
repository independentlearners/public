# **[12. Integration dengan Other Systems][0]**

Salah satu kekuatan terbesar Lua adalah kemudahannya untuk diintegrasikan (_embedded_) ke dalam aplikasi lain dan kemampuannya untuk beradaptasi dengan berbagai sistem operasi. Namun, ini juga berarti bahwa cara Anda melakukan I/O bisa sedikit berbeda tergantung pada lingkungan tempat skrip Lua Anda berjalan.

#

### 12.1 Platform-specific I/O

**Deskripsi Konkret:**
Meskipun pustaka `io` Lua dirancang untuk portabel, sistem operasi yang mendasarinya (seperti Windows, Linux, dan macOS) memiliki beberapa perbedaan fundamental yang dapat memengaruhi perilaku I/O. Mengetahui perbedaan ini membantu Anda menulis kode yang lebih andal dan lintas-platform (_cross-platform_).

**Windows-specific considerations:**

- **Pemisah Path (Path Separators)**: Windows secara tradisional menggunakan backslash (`\`) sebagai pemisah direktori (misalnya, `C:\Users\User\Documents`).
- **Translasi Newline**: Seperti yang dibahas sebelumnya, mode teks (`"r"`, `"w"`) pada Windows akan mengubah `\n` menjadi `\r\n` saat menulis dan sebaliknya saat membaca. Ini adalah sumber masalah yang umum untuk file yang tidak murni teks.
- **Case Insensitivity**: Nama file di Windows umumnya tidak peka huruf besar-kecil (`File.txt` dan `file.txt` merujuk pada file yang sama).
- **Path Length Limit**: Windows memiliki batasan panjang path historis (sekitar 260 karakter), meskipun versi modern sudah lebih fleksibel.

**Linux/macOS-specific considerations (Sistem berbasis POSIX):**

- **Pemisah Path**: Sistem ini menggunakan forward slash (`/`) secara eksklusif (misalnya, `/home/user/documents`).
- **"Everything is a File"**: Filosofi di sistem mirip-Unix adalah bahwa banyak hal—termasuk perangkat keras (seperti serial port `/dev/ttyS0`), soket jaringan, dan pipe—direpresentasikan sebagai entitas mirip file dalam sistem file dan seringkali dapat dioperasikan menggunakan I/O file standar.
- **Case Sensitivity**: Nama file **peka huruf besar-kecil** (`File.txt` dan `file.txt` adalah dua file yang sama sekali berbeda). Ini adalah penyebab umum bug ketika skrip yang dikembangkan di Windows dipindahkan ke Linux/macOS.
- **Izin (Permissions)**: Model izin file (baca, tulis, eksekusi untuk pemilik, grup, dan lainnya) jauh lebih ketat dan merupakan bagian integral dari operasi sistem. Kegagalan I/O seringkali disebabkan oleh izin yang tidak memadai.

**Cross-platform strategies:**
Menulis kode yang berjalan dengan baik di semua platform adalah tujuan yang baik. Berikut adalah strategi terbaiknya:

1.  **Gunakan Forward Slash (`/`) untuk Path**: Selalu gunakan `/` sebagai pemisah path dalam string Anda. Pustaka I/O Lua di Windows cukup pintar untuk mengonversinya menjadi `\` di belakang layar.
    ```lua
    -- Baik (portabel):
    local file = io.open("data/config.txt", "r")
    -- Buruk (hanya Windows dan perlu escape):
    -- local file = io.open("data\\config.txt", "r")
    ```
2.  **Gunakan Mode Biner untuk Data Non-Teks**: Jika Anda tidak yakin atau ingin portabilitas maksimum untuk data biner, selalu tambahkan `b` ke mode file Anda (`"rb"`, `"wb"`) untuk menghindari masalah translasi newline.
3.  **Konsisten dengan Huruf Besar/Kecil**: Perlakukan semua nama file seolah-olah mereka peka huruf besar-kecil. Gunakan konvensi penamaan yang konsisten (misalnya, semua huruf kecil) untuk menghindari masalah saat berpindah dari Windows ke Linux/macOS.
4.  **Gunakan `package.config` untuk Deteksi OS**: Jika Anda benar-benar perlu menjalankan perintah yang berbeda tergantung OS, Anda dapat menggunakan `package.config:sub(1,1)` yang biasanya mengembalikan `\` untuk Windows dan `/` untuk sistem POSIX.
    ```lua
    local separator = package.config:sub(1,1)
    if separator == '\\' then
        -- Logika khusus Windows
    else
        -- Logika khusus Linux/macOS
    end
    ```
5.  **Gunakan Pustaka Abstraksi**: Untuk operasi file dan direktori yang kompleks, pustaka seperti LuaFileSystem (LFS) menyediakan fungsi-fungsi lintas-platform (misalnya, `lfs.join` untuk menggabungkan path dengan benar).

### 12.2 Embedded Systems I/O

**Deskripsi Konkret:**
Lua sangat populer di sistem tertanam (_embedded systems_) seperti mikrokontroler (misalnya, ESP32), perangkat IoT, dan firmware karena ukurannya yang kecil, konsumsi memori yang rendah, dan kinerja yang cepat. Namun, I/O di lingkungan ini sangat berbeda dari desktop.

**Constraints and limitations:**

- **Memori dan Penyimpanan Terbatas**: Anda tidak bisa membaca file besar ke memori. Semua teknik optimasi memori yang telah kita bahas menjadi wajib, bukan lagi pilihan.
- **Filesystem Terbatas (atau Tidak Ada)**: Beberapa mikrokontroler mungkin memiliki filesystem flash yang kecil (seperti SPIFFS), sementara yang lain mungkin tidak memiliki filesystem sama sekali.
- **Pustaka Standar yang Disederhanakan**: Implementasi Lua untuk sistem tertanam (seperti eLua atau NodeMCU) seringkali menyediakan versi pustaka `io` dan `os` yang "dipreteli" untuk menghemat ruang. Fungsi seperti `io.popen()` atau `os.rename()` mungkin tidak ada.
- **Siklus Tulis Terbatas**: Penyimpanan flash (seperti pada kartu SD atau chip flash internal) memiliki jumlah siklus tulis yang terbatas. Terlalu sering menulis ke file (misalnya, untuk logging) dapat memperpendek umur perangkat.

**Interfacing with hardware (conceptual):**
Di sinilah letak perbedaan terbesarnya. "I/O" di sistem tertanam seringkali berarti berkomunikasi langsung dengan perangkat keras, bukan hanya file.

- **Binding C ke Lua**: Cara kerjanya adalah fungsi-fungsi level-rendah yang ditulis dalam bahasa C (yang dapat mengakses register perangkat keras, pin GPIO, sensor I2C/SPI) "diikat" (_bound_) ke dalam environment Lua.
- **Contoh Konseptual**:

  ```lua
  -- Di dalam skrip Lua yang berjalan di mikrokontroler:

  -- 'gpio' dan 'adc' adalah modul yang diimplementasikan di C dan diekspos ke Lua.

  -- Mengatur pin 12 sebagai output dan menyalakan LED
  gpio.pin_mode(12, gpio.OUTPUT)
  gpio.write(12, gpio.HIGH)

  -- Membaca nilai analog dari sensor yang terhubung ke pin ADC 0
  local sensor_value = adc.read(0)

  -- Mengirim data melalui serial port (yang mungkin diimplementasikan sebagai file-like object)
  uart.write(0, "Nilai sensor: " .. sensor_value .. "\n")
  ```

Dalam contoh ini, `gpio.write()` dan `adc.read()` terasa seperti fungsi Lua biasa, tetapi di belakang layar mereka memanipulasi perangkat keras secara langsung. I/O file tradisional mungkin hanya digunakan untuk membaca file konfigurasi dari kartu SD atau berkomunikasi melalui port serial UART.

### 12.3 Lua in Scripting Environments

**Deskripsi Konkret:**
Ini adalah kasus penggunaan Lua yang paling umum: sebagai bahasa skrip yang disematkan di dalam aplikasi yang lebih besar untuk memungkinkan pengguna menambahkan fungsionalitas kustom. Contohnya termasuk game engine, editor teks, dan perangkat lunak jaringan.

**Penting: I/O yang Dikontrol oleh Host**
Di hampir semua lingkungan ini, Anda **tidak** menggunakan pustaka `io` standar secara langsung. Aplikasi _host_ menyediakan API I/O-nya sendiri. Ini dilakukan karena beberapa alasan penting:

- **Keamanan**: Untuk mencegah skrip jahat membaca atau menulis file sembarangan di komputer pengguna.
- **Stabilitas**: Untuk memastikan operasi I/O tidak memblokir loop utama aplikasi (misalnya, game loop).
- **Portabilitas**: Untuk menyediakan API yang konsisten di semua platform tempat aplikasi host berjalan.
- **Integrasi**: Agar I/O terintegrasi dengan baik dengan fitur lain dari aplikasi (misalnya, sistem aset game).

**I/O in game engines (e.g., Roblox, LÖVE 2D, Defold):**

- **Roblox**:
  - **Tidak ada akses filesystem langsung**.
  - **Penyimpanan Persisten**: Menggunakan `DataStoreService` untuk menyimpan data pemain di cloud Roblox. Ini adalah database key-value, bukan file.
  - **Jaringan**: Menggunakan `HttpService` untuk membuat permintaan HTTP ke API eksternal.
- **LÖVE 2D**:

  - **Filesystem Terabstraksi**: Menyediakan modul `love.filesystem`. Anda hanya dapat menulis ke "direktori save" yang aman dan khusus untuk game Anda. Anda dapat membaca aset (gambar, suara) yang dibundel dengan game Anda.
  - **Contoh LÖVE 2D**:

    ```lua
    function love.load()
        -- Menulis high score ke file di direktori save
        love.filesystem.write("hiscore.txt", "10000")
    end

    function love.draw()
        -- Membaca high score untuk ditampilkan
        if love.filesystem.exists("hiscore.txt") then
            local score = love.filesystem.read("hiscore.txt")
            love.graphics.print("High Score: " .. score, 100, 100)
        end
    end
    ```

**I/O in other applications (e.g., Redis, Neovim, Wireshark):**

- **Redis**: Skrip Lua di Redis berjalan di server untuk melakukan operasi atomik pada data. "I/O"-nya adalah membaca dan menulis kunci di dalam Redis itu sendiri. Tidak ada akses filesystem.
  - **Contoh Redis**: `return redis.call('GET', KEYS[1])`
- **Neovim**: Lua digunakan untuk konfigurasi dan plugin. Neovim menyediakan API Lua yang kaya untuk berinteraksi dengan editor.
  - **Contoh Neovim**: `vim.fn.writefile({"baris 1", "baris 2"}, "namafile.txt")` akan menulis ke file, tetapi melalui API editor yang aman. `vim.loop` menyediakan I/O asinkron.
- **Wireshark**: Lua digunakan untuk menulis "dissectors" (penganalisis protokol). Skrip Lua membaca data paket dari buffer yang diberikan oleh Wireshark, bukan dari file secara langsung.

**Kesimpulan Utama**: Ketika Lua disematkan, lupakan sejenak `io.open`. Langkah pertama Anda adalah membaca dokumentasi API dari aplikasi **host** untuk memahami bagaimana cara melakukan I/O yang aman dan didukung.

---

Ini melengkapi gambaran bagaimana Lua I/O beradaptasi di berbagai ekosistem. Selanjutnya kita akan melihat topik-topik yang lebih dalam lagi pada materi "Advanced Topics II".

**Sumber Referensi dari Kurikulum:**

- [Lua-users Wiki: Lua On The Move](https://www.google.com/search?q=http://lua-users.org/wiki/LuaOnTheMove) (Membahas portabilitas Lua di berbagai platform)
- [Embedded Use of Lua](https://www.lua.org/notes/ltn001.html) (Catatan teknis tentang penggunaan Lua di sistem tertanam)
- [Roblox Developer Hub: Filesystem](https://www.google.com/search?q=https://create.roblox.com/docs/scripting/data/filesystem) (Meskipun tidak ada filesystem langsung, ini menjelaskan cara Roblox menangani data)
- [LÖVE 2D Wiki: love.filesystem](https://love2d.org/wiki/love.filesystem) (Dokumentasi untuk API filesystem di LÖVE)

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../real-world-applications/README.md
[selanjutnya]: ../debugging-dan-trobleshooting/README.md

<!----------------------------------------------------->

[0]: ../../input-output/README.md#12-integration-dengan-other-systems
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
