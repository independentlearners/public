# **[14. Troubleshooting I/O Issues][0]**

Tidak peduli seberapa hati-hati Anda menulis kode, masalah I/O pasti akan terjadi. Mengetahui cara mendiagnosis (_troubleshoot_) masalah ini dengan cepat dan efektif adalah keterampilan yang membedakan programmer pemula dari yang berpengalaman. Bagian ini akan membekali Anda dengan teknik untuk menemukan dan memperbaiki error I/O yang umum.

#

### 14.1 Common I/O Errors

**Deskripsi Konkret:**
Ini adalah daftar "tersangka utama" ketika skrip I/O Anda gagal. Memahami penyebab umum di balik pesan error ini akan sangat mempercepat proses debugging.

**"file not found" (`No such file or directory`):**
Ini mungkin error yang paling sering ditemui.

- **Penyebab Umum**:
  1.  **Salah Ketik (Typo)**: Kesalahan pengetikan sederhana pada nama file atau direktori.
  2.  **Path Salah**: Path yang Anda berikan tidak mengarah ke file. Perhatikan perbedaan antara path relatif dan absolut.
      - **Path Relatif** (`data/file.txt`): Dicari relatif terhadap _current working directory_ (CWD) atau direktori kerja saat ini dari skrip Anda.
      - **Path Absolut** (`/home/user/data/file.txt` atau `C:\Users\User\data.txt`): Dicari dari direktori root sistem file.
  3.  **CWD yang Salah**: Program Anda mungkin tidak berjalan dari direktori yang Anda kira. Misalnya, jika Anda menjalankan skrip dari direktori lain (`lua /path/to/my/script.lua`), CWD-nya adalah direktori tempat Anda berada, bukan direktori skrip.
- **Solusi**:
  - Periksa kembali ejaan nama file dan path.
  - Pastikan file tersebut benar-benar ada di lokasi yang Anda tuju.
  - Jika ragu, cetak CWD Anda. Anda bisa menggunakan `lfs.currentdir()` dari LuaFileSystem, atau `io.popen('cd')` (Windows) / `io.popen('pwd')` (Linux/macOS) untuk melihatnya.

**"permission denied":**

- **Penyebab Umum**:
  1.  **Izin Baca/Tulis Tidak Cukup**: Pengguna yang menjalankan skrip tidak memiliki hak untuk membaca dari file/direktori atau menulis ke file/direktori tersebut. Ini umum terjadi di direktori sistem (seperti `/etc` di Linux atau `C:\Program Files` di Windows).
  2.  **File Terkunci**: Program lain sedang membuka file tersebut dalam mode eksklusif, mencegah skrip Anda untuk mengaksesnya.
- **Solusi**:
  - Periksa izin file dan direktori (`ls -l` di Linux/macOS, atau klik kanan -\> Properties di Windows).
  - Pastikan tidak ada program lain (termasuk instance lain dari skrip Anda) yang sedang mengunci file tersebut.
  - Jalankan skrip Anda dari direktori di mana Anda memiliki hak tulis (misalnya, direktori home atau dokumen Anda). Hindari menjalankan skrip dengan hak administrator (_root_ atau _Run as Administrator_) kecuali benar-benar diperlukan dan Anda tahu apa yang Anda lakukan.

**Handling "nil" values unexpectedly:**

- **Masalah**: Seringkali, error yang sebenarnya bukan pesan "file not found" atau "permission denied", melainkan `attempt to perform arithmetic on a nil value` atau `attempt to concatenate a nil value`.
- **Penyebab Asli**: Ini biasanya merupakan **gejala**, bukan penyakit. Error ini terjadi karena operasi sebelumnya (seperti `file:read()` atau `io.open()`) gagal secara diam-diam dan mengembalikan `nil`. Variabel yang seharusnya berisi data atau file handle malah berisi `nil`, dan ketika Anda mencoba menggunakannya, program crash.
- **Solusi**: **Selalu periksa nilai kembali dari setiap fungsi I/O yang bisa gagal.** Jangan pernah berasumsi bahwa `io.open()` atau `file:read()` akan berhasil.

  ```lua
  local file = io.open("mungkin_gagal.txt", "r")
  if not file then
      -- Tangani error pembukaan di sini
      return
  end

  local data = file:read("*a")
  if not data then
      -- Tangani error pembacaan di sini (misalnya, file kosong atau error baca)
      file:close()
      return
  end

  -- Aman untuk menggunakan 'data' sekarang
  print("Jumlah byte:", #data)
  ```

**Debugging logical errors in I/O:**

- **Masalah**: Kode berjalan tanpa error, tetapi hasilnya salah.
- **Contoh**:
  - Anda menulis data ke file CSV, tetapi semua data muncul dalam satu baris panjang. **Penyebab**: Anda lupa menambahkan karakter newline (`\n`) di akhir setiap `file:write()`.
  - Loop pemrosesan file berhenti sebelum waktunya. **Penyebab**: Kondisi `break` di dalam loop `while` Anda salah.
  - Data biner yang dibaca menghasilkan nilai yang tidak masuk akal. **Penyebab**: Masalah _endianness_ atau Anda membaca jumlah byte yang salah.
- **Solusi**: Ini memerlukan teknik debugging yang lebih sistematis, yang akan kita bahas di bawah ini.

### 14.2 Debugging Techniques

**Deskripsi Konkret:**
Ini adalah alat dan metode yang Anda gunakan untuk "mengintip" ke dalam program Anda saat berjalan untuk memahami apa yang sebenarnya terjadi.

**Using `print` for debugging:**
Ini adalah teknik debugging yang paling sederhana, paling cepat, dan paling universal. Dikenal juga sebagai _print-debugging_ atau _printf debugging_.

- **Konsep**: Sisipkan pernyataan `print()` di titik-titik kritis dalam kode Anda untuk menampilkan status variabel, pesan kemajuan, atau untuk memastikan blok kode tertentu dieksekusi.
- **Contoh**:

  ```lua
  function prosesData(filename)
      print("DEBUG: Memulai prosesData dengan file:", filename) -- Apakah fungsi dipanggil?

      local file, err = io.open(filename, "r")
      if not file then
          print("DEBUG: Gagal membuka file! Error:", err) -- Mengapa gagal?
          return
      end

      local data = {}
      for line in file:lines() do
          print("DEBUG: Membaca baris:", line) -- Apa isi setiap baris?
          table.insert(data, line)
      end

      print("DEBUG: Selesai membaca. Total baris:", #data) -- Apakah loop berjalan benar?
      file:close()
      return data
  end
  ```

- **Tips**: Buat fungsi `debug_print` kustom yang bisa diaktifkan atau dinonaktifkan dengan satu variabel global, sehingga Anda tidak perlu menghapus semua `print` Anda saat produksi.

**Step-by-step execution (Mental Walkthrough):**

- **Konsep**: "Jalankan" program di kepala atau di atas kertas. Ambil selembar kertas, tulis nama-nama variabel penting Anda, dan telusuri kode Anda baris per baris. Setiap kali sebuah variabel berubah, coret nilai lama dan tulis nilai baru.
- **Kegunaan**: Ini sangat efektif untuk menemukan kesalahan logika dalam loop, kondisi `if`, atau perhitungan matematika. Ini memaksa Anda untuk memperhatikan setiap detail, bukan hanya berasumsi tentang apa yang seharusnya dilakukan oleh kode.

**Using a debugger (conceptual):**

- **Konsep**: Debugger adalah program yang memungkinkan Anda untuk mengontrol eksekusi program lain. Ini adalah cara debugging yang paling kuat.
- **Fitur Utama**:
  - **Breakpoints**: Anda menandai sebuah baris kode sebagai _breakpoint_. Ketika eksekusi mencapai baris itu, program akan **berhenti sementara (pause)**.
  - **Stepping**: Saat berhenti, Anda bisa menjalankan kode baris per baris (`Step Over`), masuk ke dalam pemanggilan fungsi (`Step Into`), atau keluar dari fungsi saat ini (`Step Out`).
  - **Variable Inspection**: Saat berhenti, Anda bisa melihat nilai dari semua variabel yang ada pada saat itu.
- **Debugger untuk Lua**: Lua tidak memiliki debugger bawaan, tetapi banyak lingkungan pengembangan menyediakannya:
  - **ZeroBrane Studio**: IDE Lua yang ringan dengan debugger bawaan yang sangat baik.
  - **Visual Studio Code**: Dengan ekstensi seperti `Lua Debug` oleh actboy.
  - **Debugger Baris Perintah**: Seperti `MobDebug`.

### 14.3 Analyzing Corrupted Data

**Deskripsi Konkret:**
Terkadang program berjalan, file ditulis, tetapi saat Anda membukanya, isinya rusak atau tidak seperti yang diharapkan.

**Identifying encoding issues:**

- **Gejala**: Anda melihat karakter aneh seperti `â€` atau `ï¿½` di tempat yang seharusnya ada karakter non-ASCII (misalnya, `€` atau `é`).
- **Penyebab**: Ada ketidakcocokan encoding di suatu tempat dalam rantai proses Anda. Paling umum: Anda menyimpan file sebagai UTF-8, tetapi membukanya atau menampilkannya di terminal yang menganggapnya sebagai encoding lain (seperti Windows-1252).
- **Solusi**:
  1.  **Standarisasi ke UTF-8**: Pastikan editor kode Anda, skrip Lua Anda, dan terminal/konsol Anda semua diatur untuk menggunakan UTF-8.
  2.  **Buka file dalam mode biner (`rb`)**: Saat membaca file teks yang Anda tahu adalah UTF-8, membukanya dalam mode biner dapat mencegah translasi newline yang tidak diinginkan, meskipun ini tidak akan memperbaiki masalah encoding inti.
  3.  **Gunakan Alat Eksternal**: Gunakan editor seperti Notepad++ atau Visual Studio Code untuk memeriksa dan mengonversi encoding file. Di Linux, perintah `file -i namafile.txt` dapat membantu mendeteksi encoding.

**Handling partially written files:**

- **Masalah**: Program Anda crash atau dihentikan paksa di tengah-tengah operasi penulisan. Hasilnya adalah file yang tidak lengkap. Jika program lain mencoba membaca file ini, ia bisa crash atau berperilaku tidak terduga.
- **Solusi Paling Andal (Atomic Write Pattern)**: Jangan pernah menulis langsung ke file tujuan akhir.
  1.  Tulis semua konten Anda ke sebuah **file sementara** dengan nama yang unik (misalnya, `laporan.txt.tmp`).
  2.  Lakukan semua pekerjaan Anda pada file sementara ini. Pastikan Anda memanggil `file:close()` pada file sementara untuk memastikan semua data di-flush ke disk.
  3.  **Hanya jika** langkah 1 dan 2 berhasil sepenuhnya, gunakan **`os.rename()`** untuk mengganti nama file sementara menjadi nama file tujuan akhir (`os.rename("laporan.txt.tmp", "laporan.txt")`).
- **Mengapa ini Berfungsi?**: `os.rename` pada sistem file yang sama biasanya merupakan operasi _atomik_. Artinya, ia dijamin berhasil sepenuhnya atau tidak sama sekali. Tidak akan ada kondisi di mana Anda memiliki file yang setengah di-rename. Ini memastikan bahwa file tujuan akhir selalu dalam keadaan yang valid dan lengkap.

**Contoh Kode (Pola Penulisan Atomik):**

```lua
-- Pola penulisan yang aman untuk mencegah file rusak
function saveReportSafely(filename, data_lines)
    local temp_filename = filename .. ".tmp"

    -- 1. Tulis ke file sementara
    local status, err = pcall(function()
        local file, open_err = io.open(temp_filename, "w")
        if not file then error(open_err) end

        for _, line in ipairs(data_lines) do
            file:write(line .. "\n")
        end

        file:close() -- Sangat penting untuk menutup file sementara
    end)

    if not status then
        -- Jika penulisan ke file sementara gagal, laporkan error dan bersihkan
        io.stderr:write("Gagal menulis ke file sementara: " .. tostring(err) .. "\n")
        os.remove(temp_filename) -- Hapus file sementara yang mungkin rusak
        return false
    end

    -- 2. Jika berhasil, rename file sementara ke nama tujuan
    local ok, rename_err = os.rename(temp_filename, filename)
    if not ok then
        io.stderr:write("Gagal me-rename file sementara: " .. (rename_err or "") .. "\n")
        return false
    end

    print("File '" .. filename .. "' berhasil disimpan dengan aman.")
    return true
end

-- --- Demo ---
local my_report_data = {
    "Laporan Penjualan Q2",
    "===================",
    "Produk A: 150 unit",
    "Produk B: 220 unit",
}

saveReportSafely("report.final.txt", my_report_data)
os.remove("report.final.txt") -- Membersihkan
```

**Sumber Referensi:**

- [Lua-users Wiki: Debugging](https://www.google.com/search?q=http://lua-users.org/wiki/Debugging)
- [Stack Overflow: Best way to handle I/O errors in Lua](https://www.google.com/search?q=https://stackoverflow.com/questions/906161/best-way-to-handle-i-o-errors-in-lua)

Dengan menguasai teknik troubleshooting ini, Anda akan lebih percaya diri dalam menangani masalah I/O dan dapat membangun aplikasi yang jauh lebih andal.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../debugging-dan-trobleshooting/README.md
[selanjutnya]: ../advanced-topics/README.md

<!----------------------------------------------------->

[0]: ../../input-output/README.md#14-platform-specific-considerations
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
