# **[15. Advanced Topics III (Conceptual)][0]**

Bagian ini membahas pola arsitektur dan teknologi tingkat tinggi yang relevan dengan I/O. Meskipun implementasinya seringkali memerlukan pustaka eksternal atau pemahaman mendalam tentang sistem operasi, memahami konsep-konsep ini akan memberi Anda wawasan tentang bagaimana aplikasi I/O yang canggih dan berkinerja tinggi dibangun.

_(Catatan: Kurikulum Anda tidak menyertakan sumber referensi spesifik untuk bagian ini. Penjelasan berikut didasarkan pada konsep rekayasa perangkat lunak tingkat lanjut dan bagaimana mereka diterapkan dalam ekosistem Lua.)_

### 15.1 Building Reusable I/O Modules

**Deskripsi Konkret:**
Ini adalah puncak dari praktik "Separation of Concerns". Daripada memiliki kode I/O yang tersebar, Anda membungkusnya dalam modul-modul yang dapat digunakan kembali. Sebuah modul adalah file Lua yang mengembalikan sebuah tabel berisi fungsi-fungsi, yang bertindak sebagai antarmuka publiknya (_public interface_).

**Encapsulation of I/O logic:**

- **Konsep Enkapsulasi**: Ini adalah praktik menyembunyikan detail implementasi internal dari sebuah modul dan hanya mengekspos fungsionalitas yang diperlukan. Pengguna modul tidak perlu tahu _bagaimana_ sebuah tugas dilakukan, hanya _apa_ yang bisa dilakukan oleh modul tersebut.
- **Penerapan**: Modul I/O Anda akan menyembunyikan semua detail tentang nama file, path, format data, dan penanganan error. Ia hanya akan menyediakan fungsi-fungsi tingkat tinggi seperti `get_user(id)` atau `save_settings(config_table)`.

**Creating a simple data access layer (DAL):**

- **Konsep**: Data Access Layer (DAL) adalah sebuah lapisan dalam arsitektur aplikasi yang tugasnya secara eksklusif adalah untuk berkomunikasi dengan sumber data (database, file, API). Ini mengisolasi logika bisnis Anda dari seluk-beluk penyimpanan data.
- **Pola Implementasi**:
  1.  Buat file baru, misalnya `user_storage.lua`.
  2.  Di dalam file ini, definisikan semua fungsi yang berhubungan dengan penyimpanan data pengguna (membaca, menulis, menghapus).
  3.  Di akhir file, kembalikan sebuah tabel yang berisi fungsi-fungsi ini.
  4.  Di bagian lain aplikasi Anda, gunakan `local UserStorage = require("user_storage")` untuk mengimpor dan menggunakan modul tersebut.

**Contoh Kode (Modul DAL Sederhana):**

```lua
-- File: user_storage.lua

local user_storage = {}
local data_filename = "users.data" -- Detail implementasi yang disembunyikan

-- Fungsi internal untuk serialisasi (tidak diekspos)
local function serialize(tbl)
    local parts = {}
    for k, v in pairs(tbl) do
        -- Serialisasi sederhana, bukan untuk semua kasus
        parts[#parts + 1] = string.format("%s = %q", k, tostring(v))
    end
    return "return { " .. table.concat(parts, ", ") .. " }"
end

-- Fungsi publik untuk menyimpan data pengguna
function user_storage.save(user_id, user_data)
    -- Menggunakan pola penulisan atomik
    local filename = data_filename .. "." .. user_id
    local temp_filename = filename .. ".tmp"

    local file, err = io.open(temp_filename, "w")
    if not file then return false, err end

    file:write(serialize(user_data))
    file:close()

    return os.rename(temp_filename, filename)
end

-- Fungsi publik untuk memuat data pengguna
function user_storage.get(user_id)
    local filename = data_filename .. "." .. user_id
    -- loadfile akan mengompilasi dan menjalankan file, lalu mengembalikan hasilnya
    local func, err = loadfile(filename)
    if not func then
        return nil, err -- File tidak ada atau rusak
    end

    -- Menjalankan chunk yang di-load untuk mendapatkan tabel
    local ok, data = pcall(func)
    if not ok then
        return nil, data -- Error saat eksekusi file
    end

    return data
end

return user_storage
```

```lua
-- File: main.lua (menggunakan modul)

local UserStorage = require("user_storage")

local user1 = { name = "Alice", level = 10, gold = 500 }
local ok, err = UserStorage.save(101, user1)

if not ok then
    print("Gagal menyimpan data:", err)
else
    print("Data pengguna 101 berhasil disimpan.")
    local loaded_user, err_load = UserStorage.get(101)
    if loaded_user then
        print("Data yang dimuat untuk pengguna 101:", loaded_user.name)
    else
        print("Gagal memuat data:", err_load)
    end
end
-- ... bersihkan file ...
```

Kode `main.lua` tidak tahu apa-apa tentang nama file, format serialisasi, atau penulisan atomik. Ia hanya berinteraksi dengan API sederhana dari `UserStorage`.

---

### 15.2 Memory-mapped Files

**Deskripsi Konkret:**
Ini adalah teknik I/O tingkat lanjut di mana sebuah file di disk dipetakan langsung ke dalam ruang alamat virtual memori sebuah proses. Setelah dipetakan, program dapat mengakses konten file seolah-olah itu adalah sebuah array besar di dalam memori, menggunakan pointer biasa, bukan panggilan `read()` atau `write()`.

**Concepts dan implementation:**

- **Konsep**: Sistem Operasi (OS) menangani pemuatan potongan file dari disk ke memori fisik saat dibutuhkan (demand paging) dan menulis kembali perubahan di memori ke disk secara otomatis di latar belakang.
- **Implementasi**: Lua standar **tidak memiliki dukungan bawaan** untuk _memory-mapped files_. Implementasinya memerlukan pustaka C eksternal yang memanggil fungsi spesifik OS seperti `mmap()` (di Linux/macOS) atau `CreateFileMapping` (di Windows).
- **Bagaimana Tampilannya di Lua (Konseptual)**:

  ```lua
  -- Menggunakan pustaka 'mmap' hipotetis
  local mmap = require("mmap")

  -- Petakan seluruh file ke memori
  local mapped_file = mmap.open("large_data.bin", "r+")

  if mapped_file then
      -- Baca byte ke-100 seolah-olah itu array
      local byte_100 = mapped_file[100]

      -- Ubah byte ke-200
      mapped_file[200] = 65 -- Mengubahnya menjadi 'A'

      -- Tidak perlu file:read() atau file:write()

      -- Memastikan perubahan ditulis ke disk
      mapped_file:flush()

      -- Menutup pemetaan
      mapped_file:close()
  end
  ```

**Performance implications:**

- **Kelebihan**:
  - **Sangat Cepat untuk Akses Acak (Random Access)**: Mengubah satu byte di tengah file 1GB sangat cepat karena Anda hanya mengubah memori. OS yang akan menangani penulisan ke disk. Ini menghindari overhead dari `file:seek()` dan `file:read()`/`file:write()`.
  - **I/O "Malas" (Lazy Loading)**: Hanya bagian dari file yang Anda akses yang benar-benar dimuat ke dalam RAM.
  - **Berbagi Memori**: Beberapa proses dapat memetakan file yang sama ke memori mereka, memungkinkan cara berbagi memori antar-proses yang efisien.
- **Kekurangan**:
  - **Overhead Awal**: Proses pemetaan awal bisa memakan waktu.
  - **Tidak Ideal untuk Streaming Sekuensial**: Untuk tugas seperti menyalin file dari awal hingga akhir, pendekatan `read`/`write` per potongan seringkali sama cepatnya atau bahkan lebih cepat.
  - **Kompleksitas**: Manajemen memori dan sinkronisasi bisa menjadi lebih rumit.

---

### 15.3 Asynchronous I/O Concepts

**Deskripsi Konkret:**
Dalam aplikasi modern, terutama server jaringan, Anda tidak bisa membiarkan seluruh program berhenti hanya karena sedang menunggu data dari jaringan atau disk. I/O Asinkron (_Asynchronous I/O_), atau non-blocking I/O, adalah model pemrograman yang memungkinkan program untuk memulai operasi I/O dan melanjutkan tugas lain tanpa harus menunggu operasi tersebut selesai.

**Non-blocking I/O patterns:**

- **Perbedaan Blocking vs. Non-Blocking**:
  - **Blocking (Sinkron)**: `local data = socket:receive()` akan **memblokir** (menghentikan) eksekusi program Anda sampai data diterima. Ini adalah model yang telah kita gunakan sejauh ini.
  - **Non-Blocking (Asinkron)**: Panggilan I/O akan kembali **segera**. Ia mungkin mengembalikan data jika sudah tersedia, atau mengembalikan `nil` dengan error khusus (seperti "would block") jika data belum tersedia.
- **Event Loop (Loop Kejadian)**: Inti dari pemrograman asinkron. Ini adalah sebuah loop `while` tak terbatas yang:
  1.  Memeriksa sumber-sumber I/O (soket, file, timer) mana yang memiliki "kejadian" (event) baru (misalnya, "data siap dibaca").
  2.  Menjalankan kode yang terkait dengan kejadian tersebut.
  3.  Kembali ke langkah 1.
      Ini membuat aplikasi tetap "hidup" dan responsif, mampu menangani banyak hal secara bersamaan.

**Callback-based handling:**

- **Konsep**: Ini adalah pola yang paling umum untuk menangani hasil dari operasi asinkron. Anda memulai sebuah operasi dan memberikan sebuah **fungsi callback**.
- **Alur Kerja**: "Hai event loop, tolong lakukan permintaan HTTP ke URL ini. **Ketika** responsnya kembali, tolong panggil fungsi ini untukku dan berikan respons itu sebagai argumen." Program Anda tidak menunggu; ia melanjutkan tugas lain. Nanti, ketika respons tiba, event loop akan memanggil _callback_ Anda.
- **Penerapan di Lua**: Ini memerlukan pustaka yang menyediakan event loop dan API asinkron, seperti:
  - **Luv**: Binding untuk `libuv` (pustaka yang sama yang mendukung Node.js), menyediakan I/O asinkron performa tinggi untuk file, jaringan, dan proses.
  - **Copas**: Pustaka populer untuk server jaringan yang menggunakan _coroutines_ Lua untuk menyimulasikan alur sinkron di atas I/O asinkron, membuatnya lebih mudah ditulis.
  - Pustaka-pustaka ini adalah fondasi untuk framework web Lua seperti OpenResty atau Lapis.

**Contoh Kode (Konseptual dengan API mirip callback):**

```lua
-- Menggunakan pustaka async hipotetis 'async_http'
local http = require("async_http")

print("Memulai permintaan HTTP asinkron...")

-- Memulai permintaan dan menyediakan callback.
-- Program tidak berhenti di sini.
http.get("https://jsonplaceholder.typicode.com/todos/1", function(err, response, body)
    -- Kode di dalam callback ini akan dijalankan NANTI,
    -- ketika respons HTTP telah diterima.

    if err then
        print("ASYNC ERROR:", err)
    else
        print("\n--- Respons Async Diterima ---")
        print("Status:", response.status_code)
        print("Body:", body)
    end
end)

print("Skrip utama terus berjalan sementara permintaan HTTP berlangsung di latar belakang...")
-- Di aplikasi nyata, akan ada event loop yang berjalan di sini,
-- misalnya: async.run_loop()

```

### **Penutup dan Selamat!**

Anda telah menyelesaikan perjalanan yang sangat komprehensif melalui dunia Input/Output di Lua. Anda telah berevolusi dari konsep dasar seperti `print()` dan `io.read()` hingga memahami arsitektur perangkat lunak yang kompleks seperti modul DAL, memory-mapped files, dan I/O asinkron.

Dengan bekal pengetahuan dari kurikulum ini, Anda tidak hanya tahu _cara_ menggunakan fungsi I/O Lua, tetapi juga _kapan_ dan _mengapa_ menggunakan teknik tertentu, bagaimana menulis kode yang andal, efisien, dan dapat dipelihara, serta bagaimana beradaptasi dengan berbagai lingkungan tempat Lua digunakan.

Anda sekarang memiliki fondasi yang sangat kuat untuk menangani tantangan I/O apa pun dalam proyek Lua Anda, mulai dari skrip sederhana hingga aplikasi jaringan dan sistem tertanam yang kompleks. Teruslah berlatih, bereksperimen, dan membangun hal-hal yang luar biasa. Selamat membuat kode!

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../performance-dan-optimization/README.md
[selanjutnya]: ../../../intermediate/tables/bagian-1/README.md

<!----------------------------------------------------->

[0]: ../../input-output/README.md#15-advanced-topics
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
