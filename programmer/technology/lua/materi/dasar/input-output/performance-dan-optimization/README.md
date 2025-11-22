# **[9. Performance dan Optimization][0]**

Menulis kode I/O yang berfungsi adalah satu hal; menulis kode I/O yang berkinerja tinggi adalah hal lain. Ketika berhadapan dengan data dalam jumlah besar atau operasi yang sering, optimasi menjadi sangat penting untuk memastikan program Anda berjalan cepat dan tidak boros sumber daya.

_(Catatan: Kurikulum Anda tidak menyertakan sumber referensi spesifik untuk bagian ini. Penjelasan berikut didasarkan pada praktik umum dan idiom performa standar di Lua.)_

### 9.1 I/O Performance Tips

**Deskripsi Konkret:**
Ini adalah serangkaian teknik dan praktik terbaik yang dapat Anda terapkan untuk mengurangi waktu eksekusi dan penggunaan memori dari operasi I/O Anda. Sebagian besar tips ini berpusat pada ide untuk mengurangi jumlah panggilan I/O yang sebenarnya dan bekerja dengan data dalam potongan yang lebih besar.

**Buffer management:**

- **Konsep**: Seperti yang dibahas sebelumnya, sistem operasi menggunakan buffer untuk mengefisienkan penulisan ke disk. Memahami ini adalah kunci performa. Setiap panggilan ke `file:write()` adalah sebuah _system call_ yang relatif "mahal" (membutuhkan waktu). Membiarkan OS mengisi buffer dan menuliskannya sesekali jauh lebih cepat daripada memaksa setiap tulisan kecil untuk langsung ke disk.
- **Tips Performa**:
  - **Hindari `file:flush()` yang tidak perlu**. Gunakan `flush()` hanya jika Anda benar-benar harus memastikan data segera tertulis (misalnya, untuk logging atau komunikasi antar-proses). Memanggil `flush()` terlalu sering akan meniadakan keuntungan dari buffering OS dan memperlambat program Anda secara signifikan.
  - **Implementasikan Buffering Manual di Lua**: Daripada memanggil `file:write()` berkali-kali dalam sebuah loop, kumpulkan data Anda dalam sebuah tabel Lua terlebih dahulu. Setelah terkumpul cukup banyak, gabungkan tabel tersebut menjadi satu string besar menggunakan `table.concat()` dan tulis string tersebut ke file dengan **satu panggilan `file:write()`**.

**Batching operations:**

- **Konsep**: Ini adalah ide yang lebih umum dari buffering manual. _Batching_ berarti mengelompokkan banyak operasi kecil menjadi satu operasi besar. Ini berlaku untuk membaca dan menulis.
- **Tips Performa**:
  - **Menulis (Write Batching)**: Jangan menulis baris per baris atau kata per kata. Bangun string besar di memori, lalu tulis sekaligus. Ini mengurangi overhead dari _system call_.
  - **Membaca (Read Batching)**: Jangan membaca byte per byte atau karakter per karakter jika Anda bisa menghindarinya. Gunakan teknik membaca per potongan (_chunked reading_) seperti yang dibahas di bagian "Large File Handling". Membaca satu blok 8KB jauh lebih cepat daripada melakukan 8192 kali pembacaan satu byte.

**Memory usage optimization:**

- **Konsep**: Mengoptimalkan penggunaan memori sangat penting, terutama untuk file besar. Tujuannya adalah untuk menjaga jejak memori (memory footprint) program tetap kecil dan stabil.
- **Tips Performa**:
  - **Streaming > Membaca Semua**: **Jangan pernah** menggunakan `file:read("*a")` untuk file yang berpotensi besar. Selalu gunakan _chunked reading_ (membaca per potongan) atau `file:lines()` untuk file teks.
  - **Gunakan Kembali Variabel**: Dalam loop pemrosesan chunk, gunakan kembali variabel yang sama untuk menampung setiap potongan data. Ini membantu _Garbage Collector_ (GC) Lua karena tidak perlu mengelola ribuan objek string kecil yang berbeda.
  - **Hindari Konkatenasi String dalam Loop**: Operasi penggabungan string (`..`) di Lua membuat string _baru_ setiap kali dipanggil. Melakukan ini berulang kali dalam loop yang ketat (misalnya, `s = s .. "x"`) sangat tidak efisien dan membebani GC.
    - **Buruk**: `local s = ""; for i=1,10000 do s = s .. data[i] end`
    - **Baik**: `local t = {}; for i=1,10000 do t[#t+1] = data[i] end; local s = table.concat(t)`
      Pola "tabel sebagai buffer" ini adalah salah satu idiom performa paling penting di Lua.

---

### 9.2 Profiling I/O Operations

**Deskripsi Konkret:**
"Jangan mengoptimalkan secara prematur." Sebelum Anda menghabiskan waktu untuk mengoptimalkan kode, Anda harus tahu di mana letak masalahnya. _Profiling_ adalah proses mengukur kinerja program Anda untuk mengidentifikasi bagian mana yang paling lambat (disebut _bottleneck_).

**Measuring I/O performance:**

- **Konsep**: Untuk mengukur berapa lama suatu operasi berlangsung, Anda perlu mencatat waktu sebelum dan sesudah operasi tersebut, lalu hitung selisihnya.
- **`os.clock()`**: Fungsi ini adalah alat utama untuk profiling di Lua.
  - **Sintaks**: `local cpu_time = os.clock()`
  - **Return Value**: Mengembalikan perkiraan waktu CPU dalam detik yang telah digunakan oleh program. Ini berguna untuk mengukur berapa banyak "usaha" yang dilakukan oleh program Anda, terlepas dari beban sistem lain.
- **Pola Pengukuran**:
  ```lua
  local start_time = os.clock()
  -- ... lakukan operasi I/O yang ingin diukur ...
  local end_time = os.clock()
  local duration = end_time - start_time
  print("Durasi operasi: " .. duration .. " detik")
  ```

**Identifying bottlenecks:**

- **Konsep**: _Bottleneck_ (leher botol) adalah bagian dari program yang membatasi kecepatan keseluruhan. Dalam program I/O, bottleneck bisa jadi adalah kecepatan disk itu sendiri, atau bisa juga cara Anda menulis kode I/O yang tidak efisien.
- **Strategi**: Gunakan `os.clock()` untuk mengukur berbagai bagian dari program Anda.
  - Ukur waktu yang dihabiskan untuk membaca data.
  - Ukur waktu yang dihabiskan untuk memproses data.
  - Ukur waktu yang dihabiskan untuk menulis data.
    Dengan membandingkan durasi ini, Anda dapat melihat di mana sebagian besar waktu dihabiskan dan memfokuskan upaya optimasi Anda di sana.

**Contoh Kode (`performance_test.lua`):**
Contoh ini akan mendemonstrasikan perbedaan performa drastis antara cara yang naif dan cara yang dioptimalkan untuk menulis banyak baris ke sebuah file.

```lua
-- Fungsi untuk menulis file dengan cara yang lambat (tidak efisien)
function tulisFileLambat(filename, jumlah_baris)
    local file, err = io.open(filename, "w")
    if not file then return nil, err end

    for i = 1, jumlah_baris do
        -- SANGAT TIDAK EFISIEN: Satu panggilan write() untuk setiap baris!
        file:write("Ini adalah baris nomor " .. i .. "\n")
    end

    file:close()
    return true
end

-- Fungsi untuk menulis file dengan cara yang cepat (dioptimalkan)
function tulisFileCepat(filename, jumlah_baris)
    local file, err = io.open(filename, "w")
    if not file then return nil, err end

    local buffer_table = {}
    local buffer_size = 1000 -- Tulis ke file setiap 1000 baris

    for i = 1, jumlah_baris do
        -- Kumpulkan string di dalam tabel (buffer manual)
        buffer_table[#buffer_table + 1] = "Ini adalah baris nomor " .. i .. "\n"

        -- Jika buffer sudah penuh, tulis ke file dan kosongkan buffer
        if i % buffer_size == 0 then
            -- EFISIEN: Gabungkan 1000 baris menjadi satu string, lalu satu panggilan write()
            file:write(table.concat(buffer_table))
            buffer_table = {} -- Kosongkan buffer
        end
    end

    -- Tulis sisa data di buffer yang mungkin belum penuh
    if #buffer_table > 0 then
        file:write(table.concat(buffer_table))
    end

    file:close()
    return true
end

-- --- Jalankan Profiling ---
local JUMLAH_BARIS_UJI = 50000

-- 1. Uji Coba Metode Lambat
print("Menguji metode lambat...")
local start_lambat = os.clock()
tulisFileLambat("lambat.txt", JUMLAH_BARIS_UJI)
local durasi_lambat = os.clock() - start_lambat
print(string.format("Metode lambat selesai dalam: %.4f detik", durasi_lambat))


-- 2. Uji Coba Metode Cepat
print("\nMenguji metode cepat (dioptimalkan)...")
local start_cepat = os.clock()
tulisFileCepat("cepat.txt", JUMLAH_BARIS_UJI)
local durasi_cepat = os.clock() - start_cepat
print(string.format("Metode cepat selesai dalam: %.4f detik", durasi_cepat))


-- 3. Perbandingan
print("\n--- Hasil Perbandingan ---")
if durasi_cepat > 0 then
    local percepatan = durasi_lambat / durasi_cepat
    print(string.format("Metode yang dioptimalkan kira-kira %.2f kali lebih cepat.", percepatan))
else
    print("Metode cepat selesai terlalu cepat untuk diukur secara akurat.")
end

-- Membersihkan file
os.remove("lambat.txt")
os.remove("cepat.txt")
```

**Penjelasan Kode**:

- **`tulisFileLambat`**: Fungsi ini mewakili pendekatan naif. Ia melakukan `file:write()` di dalam loop sebanyak 50,000 kali. Setiap panggilan adalah _system call_ yang memakan waktu.
- **`tulisFileCepat`**: Fungsi ini mengimplementasikan _batching_ dan _buffering manual_.
  - Ia membuat sebuah tabel, `buffer_table`.
  - Di dalam loop, ia hanya menambahkan string ke tabel (`buffer_table[#buffer_table + 1] = ...`), yang merupakan operasi memori yang sangat cepat.
  - Setiap 1000 baris, ia menggunakan `table.concat()` untuk menggabungkan 1000 string tersebut menjadi satu string raksasa, lalu menuliskannya ke file dengan **satu** panggilan `file:write()`.
  - Setelah loop utama, ia memeriksa apakah ada sisa data di buffer dan menuliskannya.
- **Profiling**: Bagian utama skrip memanggil kedua fungsi tersebut dan membungkusnya dengan `os.clock()`. Ia mencatat waktu mulai dan menghitung durasi untuk setiap metode.
- **Hasil**: Jika Anda menjalankan skrip ini, Anda akan melihat bahwa `durasi_cepat` secara dramatis lebih kecil daripada `durasi_lambat`. Perbedaannya bisa mencapai 10x, 50x, atau bahkan lebih, tergantung pada sistem Anda. Ini secara konkret membuktikan bahwa teknik batching/buffering adalah cara yang benar untuk I/O berkinerja tinggi di Lua. Bottleneck pada metode pertama adalah jumlah panggilan `file:write()` yang berlebihan.

Dengan memahami dan menerapkan prinsip-prinsip optimasi ini, serta tahu cara mengukur hasilnya, Anda dapat memastikan bahwa aplikasi Lua Anda yang intensif I/O berjalan secepat mungkin.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../I-O-dengan-external-systems/README.md
[selanjutnya]: ../best-practies-design-pattern/README.md

<!----------------------------------------------------->

[0]: ../../input-output/README.md#9-performance-dan-optimization
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
