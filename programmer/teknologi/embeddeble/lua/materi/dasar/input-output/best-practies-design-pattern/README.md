# **[10. Best Practices dan Design Patterns][0]**

Menulis kode yang berfungsi itu baik, tetapi menulis kode yang bersih, mudah dikelola, dapat diuji, dan andal adalah tujuan dari seorang programmer profesional. Menerapkan pola desain dan praktik terbaik pada kode I/O Anda akan sangat meningkatkan kualitasnya.

_(Catatan: Kurikulum Anda tidak menyertakan sumber referensi spesifik untuk bagian ini. Penjelasan berikut didasarkan pada prinsip-prinsip rekayasa perangkat lunak standar yang diterapkan pada konteks Lua.)_

### 10.1 I/O Design Patterns

**Deskripsi Konkret:**
Pola desain (_design patterns_) adalah solusi umum yang dapat digunakan kembali untuk masalah yang sering terjadi dalam desain perangkat lunak. Dalam konteks I/O, pola-pola ini membantu mengelola file, membaca data, dan menangani sumber daya dengan cara yang elegan dan kuat.

**Factory pattern untuk file handling:**

- **Konsep Pola Pabrik (Factory Pattern)**: Pola ini menyediakan sebuah fungsi atau metode "pabrik" untuk membuat objek tanpa mengekspos logika pembuatan (instansiasi) yang rumit kepada klien. Klien hanya meminta objek yang dibutuhkannya, dan pabrik yang akan mengurus detail pembuatannya.
- **Penerapan pada I/O**: Daripada menyebar panggilan `io.open()` di seluruh kode Anda, Anda bisa membuat sebuah fungsi pabrik, misalnya `FileManager.new()`. Fungsi ini akan:
  1.  Memanggil `io.open()` di dalamnya.
  2.  Melakukan penanganan error dasar secara terpusat.
  3.  Mungkin "membungkus" file handle mentah dalam sebuah tabel (objek) yang memiliki metadata tambahan atau metode kustom.
- **Keuntungan**:
  - **Sentralisasi**: Logika pembukaan file dan penanganan error awal ada di satu tempat.
  - **Abstraksi**: Klien tidak perlu peduli dengan `io.open`. Jika Anda ingin mengubah cara file dibuka (misalnya, menambahkan logging), Anda hanya perlu mengubahnya di satu tempat: di dalam pabrik.

**Iterator pattern untuk data reading:**

- **Konsep Pola Iterator**: Pola ini menyediakan cara standar untuk mengakses elemen-elemen dari sebuah koleksi data secara berurutan, tanpa mengekspos representasi internal koleksi tersebut.
- **Penerapan pada I/O**: Anda sudah sering menggunakan pola ini!
  - **`io.lines()`** dan **`file:lines()`** adalah implementasi sempurna dari pola Iterator. Mereka memungkinkan Anda untuk mengiterasi baris-baris file dengan loop `for` yang sederhana, tanpa Anda harus pusing memikirkan bagaimana cara file dibaca per potongan, di-buffer, dan bagaimana akhir file dideteksi.
  - Anda juga bisa membuat iterator kustom Anda sendiri. Misalnya, sebuah fungsi yang membaca file CSV dan menghasilkan (yield) sebuah tabel untuk setiap baris, sudah dalam bentuk yang ter-parse.

**Resource management patterns:**

- **Konsep**: Ini adalah pola yang paling penting untuk I/O. Sumber daya seperti file handle harus **selalu** dilepaskan (ditutup) setelah selesai digunakan, bahkan jika terjadi error.
- **Pola di Lua (Emulasi RAII/`try-finally`)**: Lua tidak memiliki `finally` atau destruktor otomatis seperti bahasa lain, jadi kita harus mengelolanya secara eksplisit.
  1.  **Pola `pcall` dengan Pembersihan**: Gunakan `pcall` untuk melindungi kode Anda, dan pastikan `file:close()` dipanggil setelahnya, baik berhasil maupun gagal.
  2.  **Pola Fungsi Pangkat Tinggi (Higher-Order Function)**: Ini adalah pola yang sangat bersih dan kuat. Anda membuat sebuah fungsi "pengelola" (misalnya, `withFile`) yang menerima nama file dan sebuah fungsi lain sebagai argumen. Fungsi pengelola ini akan:
      - Membuka file.
      - Memanggil fungsi yang Anda berikan dengan file handle sebagai argumennya.
      - **Menjamin** bahwa file akan ditutup setelahnya, menggunakan `pcall` secara internal untuk menangkap error.

---

### 10.2 Code Organization

**Deskripsi Konkret:**
Bagaimana Anda menyusun kode Anda akan sangat menentukan seberapa mudah kode tersebut dipahami, dimodifikasi, dan di-debug di masa depan.

**Separating I/O logic:**

- **Konsep (Pemisahan Kepentingan / Separation of Concerns)**: Prinsip ini menyatakan bahwa program harus dipecah menjadi bagian-bagian yang berbeda, di mana setiap bagian menangani satu "kepentingan" atau tanggung jawab.
- **Penerapan**: Pisahkan kode yang berhubungan langsung dengan I/O (membaca/menulis file) dari **logika bisnis** (kode yang memproses data atau membuat keputusan berdasarkan data tersebut).
  - **Buruk**: Satu fungsi panjang yang membuka file, membaca data, melakukan perhitungan kompleks, dan menulis hasilnya.
  - **Baik**:
    - Sebuah modul `DataAccess` yang memiliki fungsi seperti `readUserData(id)` dan `saveReport(reportData)`. Modul ini yang tahu cara membuka, membaca, dan menulis file.
    - Sebuah modul `BusinessLogic` yang menggunakan `DataAccess` untuk mendapatkan data, melakukan perhitungan, lalu memberikan hasilnya kembali ke `DataAccess` untuk disimpan.
- **Keuntungan**:
  - **Keterbacaan**: Setiap bagian lebih mudah dipahami.
  - **Dapat Digunakan Kembali (Reusability)**: Modul `DataAccess` bisa digunakan oleh bagian lain dari program.
  - **Dapat Diuji (Testability)**: Jauh lebih mudah untuk menguji logika bisnis tanpa harus bergantung pada file fisik.

**Error handling strategies:**

- **Konsep**: Miliki strategi yang konsisten untuk menangani error di seluruh aplikasi Anda.
- **Strategi Bertingkat**:
  1.  **Level Terendah (Fungsi I/O)**: Gunakan `if not handle then return nil, err_msg end`. Fungsi yang berinteraksi langsung dengan I/O harus melaporkan kegagalan dengan mengembalikan `nil` dan pesan error. Jangan biarkan error "bocor" begitu saja.
  2.  **Level Menengah (Logika Bisnis)**: Fungsi di sini harus memeriksa nilai kembali dari fungsi level terendah. Jika terjadi error, ia bisa mencoba melakukan pemulihan, atau "meneruskan" error tersebut ke level yang lebih tinggi.
  3.  **Level Tertinggi (Pemanggil Utama / Main Loop)**: Di sini, gunakan `pcall` atau `xpcall` untuk membungkus panggilan ke logika bisnis. Jika error sampai ke level ini, program bisa menampilkannya dengan cara yang ramah pengguna, mencatatnya ke log, dan memutuskan apakah akan melanjutkan atau berhenti dengan aman.

**Testing I/O code:**

- **Konsep**: Menguji kode yang bergantung pada filesystem bisa lambat dan tidak andal. Solusinya adalah dengan memisahkan kode Anda dari ketergantungan langsung pada `io.open` melalui teknik yang disebut **Dependency Injection**.
- **Penerapan**:
  - Daripada sebuah fungsi memanggil `io.open` di dalamnya, rancang fungsi tersebut untuk menerima sebuah **objek file-like** (objek yang memiliki metode `read`, `write`, `close`) sebagai argumen.
  - **Dalam Aplikasi Nyata**: Anda memanggil fungsi tersebut dengan file handle asli dari `io.open`.
  - **Dalam Pengujian (Test)**: Anda membuat sebuah "objek tiruan" (_mock object_)—sebuah tabel Lua sederhana yang meniru metode `read`/`write`—dan memberikannya ke fungsi Anda. Objek tiruan ini tidak menyentuh disk sama sekali; ia mungkin hanya menyimpan data di dalam tabel lain di memori.
- **Keuntungan**: Pengujian Anda menjadi sangat cepat, dapat diandalkan, dan tidak bergantung pada kondisi sistem file.

**Contoh Kode (`best_practices.lua`):**
Contoh ini akan menggabungkan beberapa pola: pemisahan logika, pola fungsi `withFile`, dan iterator kustom.

```lua
-- ======================================================
-- Modul DataAccess (bertanggung jawab untuk I/O fisik)
-- ======================================================
local DataAccess = {}

-- Pola Fungsi Pangkat Tinggi (Higher-Order Function) untuk manajemen sumber daya
function DataAccess.withFile(filename, mode, func)
    local file, err = io.open(filename, mode)
    if not file then
        return nil, err
    end

    -- Gunakan pcall untuk menjalankan fungsi pengguna dengan aman
    local status, result = pcall(func, file)

    -- JAMINAN bahwa file akan ditutup
    file:close()

    if not status then
        -- Jika ada error di dalam 'func', teruskan error tersebut
        error(result)
    end

    return result
end

-- Iterator Kustom untuk membaca data pengguna dari file
function DataAccess.readUsers(filename)
    local file, err = io.open(filename, "r")
    if not file then
        error("Gagal membuka file pengguna: " .. (err or ""), 0)
    end

    -- Mengembalikan fungsi iterator
    return function()
        for line in file:lines() do
            -- Abaikan baris kosong atau komentar
            if not line:match("^%s*$") and not line:match("^#") then
                local id, name, email = line:match("^(%d+);([^;]+);([^;]+)$")
                if id then
                    -- Iterator menghasilkan (yield) sebuah tabel untuk setiap pengguna
                    return {id = tonumber(id), name = name, email = email}
                end
            end
        end
        -- Jika loop selesai, tutup file dan return nil untuk menghentikan iterasi
        file:close()
        return nil
    end
end


-- =======================================================
-- Modul BusinessLogic (bertanggung jawab untuk pemrosesan)
-- =======================================================
local BusinessLogic = {}

function BusinessLogic.generateUserReport(userIterator)
    local report_lines = {"Laporan Pengguna Aktif:\n"}
    for user in userIterator do
        -- Logika "bisnis": format nama pengguna menjadi huruf besar
        local formatted_name = string.upper(user.name)
        report_lines[#report_lines + 1] = string.format(" - ID: %d, Nama: %s, Email: %s\n",
            user.id, formatted_name, user.email)
    end
    return table.concat(report_lines)
end


-- =======================================================
-- Bagian Utama Aplikasi (menggabungkan semuanya)
-- =======================================================
-- 1. Membuat file data dummy
DataAccess.withFile("users.txt", "w", function(f)
    f:write("101;Alice;alice@example.com\n")
    f:write("# Pengguna non-aktif\n")
    f:write("102;Bob;bob@example.com\n")
    f:write("\n") -- Baris kosong
    f:write("103;Charlie;charlie@example.com\n")
end)
print("File 'users.txt' dibuat.")

-- 2. Menjalankan alur kerja utama dengan penanganan error
local status, err = pcall(function()
    -- Mendapatkan iterator dari modul DataAccess
    local userIterator = DataAccess.readUsers("users.txt")

    -- Memberikan iterator ke modul BusinessLogic untuk diproses
    local report = BusinessLogic.generateUserReport(userIterator)

    -- Menggunakan 'withFile' untuk menyimpan laporan dengan aman
    DataAccess.withFile("report.txt", "w", function(file_report)
        file_report:write(report)
    end)
end)

if not status then
    io.stderr:write("TERJADI ERROR FATAL:\n" .. tostring(err) .. "\n")
else
    print("Laporan 'report.txt' berhasil dibuat.")
    -- Cek isi 'report.txt'
end

-- Membersihkan
os.remove("users.txt")
os.remove("report.txt")
```

**Penjelasan Kode**:

- **`DataAccess.withFile`**: Implementasi sempurna dari pola manajemen sumber daya. Ia menangani `io.open` dan `file:close`, dan menjalankan kode pengguna di antaranya dengan aman. Klien tidak perlu khawatir tentang `close()`.
- **`DataAccess.readUsers`**: Implementasi pola Iterator. Ia tidak mengembalikan data, melainkan sebuah fungsi. Setiap kali fungsi ini dipanggil (oleh loop `for`), ia membaca file sampai menemukan pengguna valid berikutnya, mengurainya, dan mengembalikannya sebagai sebuah tabel. Ia juga secara internal menangani penutupan file saat iterasi selesai.
- **`BusinessLogic.generateUserReport`**: Modul ini tidak tahu apa-apa tentang file. Ia hanya menerima sebuah `iterator` dan memproses data yang dihasilkannya. Ini adalah contoh bagus dari pemisahan kepentingan.
- **Bagian Utama**:
  - Menggunakan `DataAccess.withFile` untuk membuat file data awal.
  - Membungkus seluruh alur kerja utama dalam `pcall` untuk menangani error fatal.
  - Mengkoordinasikan alur data: `DataAccess` -> `BusinessLogic` -> `DataAccess`.

Dengan menerapkan pola-pola ini, kode Anda menjadi lebih modular, lebih aman dari kebocoran sumber daya, lebih mudah diuji, dan lebih mudah dipahami oleh Anda di masa depan atau oleh programmer lain.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../performance-dan-optimization/README.md
[selanjutnya]: ../real-world-applications/README.md

<!----------------------------------------------------->

[0]: ../../input-output/README.md#10-best-practices-dan-design-patterns
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
