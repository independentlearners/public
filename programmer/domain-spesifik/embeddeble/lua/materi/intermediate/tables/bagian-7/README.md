# **[BAGIAN 7: GARBAGE COLLECTION DAN FINALIZERS (TOPIK PENTING)][0]**

Kita akan membahas tentang *Garbage Collection* dan bagaimana Anda bisa "turut serta" dalam proses bersih-bersih ini menggunakan metamethod `__gc`. Bagian topik sangat penting namun sering diabaikan: ini tentang bagaimana Lua mengelola memori. Memahami materi ini akan membantu Anda menulis program yang efisien dan menghindari masalah seperti kebocoran memori (*memory leaks*).

💡 **Deskripsi Konsep**
Setiap kali Anda membuat sebuah table, string, atau fungsi di Lua (`local t = {}`), Lua akan mengalokasikan sejumlah memori untuk menyimpannya. Jika Anda tidak lagi menggunakan table tersebut (misalnya, variabel yang menunjuk ke sana keluar dari lingkup atau Anda set ke `nil`), table itu menjadi "sampah" (*garbage*).

**Garbage Collection (GC)** adalah proses otomatis di Lua yang secara berkala berjalan untuk menemukan "sampah" ini dan membebaskan memori yang digunakannya. Anggap saja GC sebagai petugas kebersihan otomatis yang membersihkan objek-objek yang tidak lagi terjangkau atau tidak memiliki referensi yang menunjuk padanya.

Sebuah **Finalizer** (atau *destructor*) adalah sebuah fungsi yang Anda definisikan untuk dijalankan **tepat sebelum** GC menghancurkan sebuah objek. Di Lua, finalizer untuk table diimplementasikan melalui metamethod `__gc`.

---

### **1. `__gc` Metamethod untuk Tables (Lua 5.2+)**

💡 **Deskripsi Konsep**
Metamethod `__gc` memungkinkan Anda untuk menjalankan kode pembersihan kustom saat sebuah table akan dihancurkan oleh Garbage Collector. Ini sangat penting ketika table Anda mengelola *sumber daya eksternal* yang tidak dikelola oleh Lua, seperti file di disk, koneksi jaringan, atau memori dari library C.

**Catatan Versi Penting**: Metamethod `__gc` untuk **tables** secara resmi didukung mulai dari **Lua 5.2**. Di Lua 5.1, `__gc` hanya berfungsi untuk tipe data `userdata` (objek dari C), dan untuk menirunya pada table memerlukan trik yang rumit.

**Kapan `__gc` Dipanggil?**
`__gc` **tidak** dipanggil seketika sebuah table menjadi tidak terjangkau. Ia hanya akan dipanggil nanti, ketika proses GC berjalan dan menemukan table tersebut sebagai sampah. Waktunya tidak dapat diprediksi (*non-deterministic*).

**Sintaks**:
```lua
local mt = {
    __gc = function(table_yang_akan_dihancurkan)
        -- Kode pembersihan di sini
    end
}
```

**Contoh Kode 24: Menggunakan `__gc` untuk Membersihkan Sumber Daya**
Kita akan simulasikan sebuah table yang mengelola file. Saat table ini dibersihkan, kita ingin memastikan file tersebut "ditutup".

```lua
-- Objek 'File' kita dengan finalizer
local File = {}
File.mt = {
    __gc = function(file_obj)
        print("Finalizer dipanggil! Menutup file: " .. file_obj.path)
        -- Di aplikasi nyata, di sini Anda akan memanggil io.close(file_handle)
    end,
    __tostring = function(file_obj)
        return "FileHandle(" .. file_obj.path .. ")"
    end
}

function File.new(path)
    print("Membuka file: " .. path)
    local new_file = { path = path, data = "..." }
    return setmetatable(new_file, File.mt)
end

-- --- CONTOH PENGGUNAAN ---
print("--- Memulai blok ---")
do
    local my_report = File.new("laporan_bulanan.txt")
    print(my_report, "dibuat dan digunakan di dalam blok.")
    -- Saat 'do...end' selesai, 'my_report' keluar dari lingkup dan menjadi tidak terjangkau
end

print("--- Blok selesai, 'my_report' tidak bisa diakses lagi ---")

-- Memaksa Garbage Collector berjalan untuk tujuan demonstrasi
-- Di kode produksi, Anda biasanya tidak perlu melakukan ini
collectgarbage("collect")

print("--- Script selesai ---")
```

**Hasil Eksekusi**:
```
--- Memulai blok ---
Membuka file: laporan_bulanan.txt
FileHandle(laporan_bulanan.txt) dibuat dan digunakan di dalam blok.
--- Blok selesai, 'my_report' tidak bisa diakses lagi ---
Finalizer dipanggil! Menutup file: laporan_bulanan.txt
--- Script selesai ---
```

**Penjelasan Per-Sintaksis**:
* `__gc = function(file_obj) ... end`: Kita mendefinisikan `__gc` di metatable. Fungsi ini akan menerima table yang akan dihancurkan (`file_obj`) sebagai argumennya.
* `do ... end`: Ini adalah cara untuk membuat lingkup (scope) baru. Variabel `local my_report` hanya ada di dalam blok ini. Begitu eksekusi keluar dari blok `end`, `my_report` tidak ada lagi, sehingga table yang ditunjuknya menjadi kandidat untuk garbage collection.
* `collectgarbage("collect")`: Ini adalah fungsi debug yang memaksa GC untuk berjalan. Kita menggunakannya di sini agar efek `__gc` bisa langsung terlihat. Tanpa ini, pesan "Finalizer dipanggil!" mungkin akan muncul nanti atau tidak sama sekali sebelum program berakhir.

---

### **2. Finalizers dan Table Cleanup**

💡 **Deskripsi Konsep**
Finalizer (`__gc`) adalah alat yang kuat, tetapi harus digunakan dengan hati-hati. Tujuan utamanya adalah untuk manajemen sumber daya yang siklus hidupnya perlu diikat ke siklus hidup objek Lua.

**Kapan Sebaiknya Menggunakan Finalizer?**
* **Melepaskan Sumber Daya Eksternal**: Ini adalah kasus penggunaan paling umum dan paling valid.
    * Menutup file handles (`io.close`).
    * Menutup koneksi jaringan atau database.
    * Membebaskan memori yang dialokasikan oleh library C melalui FFI (Foreign Function Interface).
* **Logging dan Debugging**: Mencatat kapan objek penting dihancurkan bisa sangat membantu saat mencari *memory leaks*.
* **Membatalkan Pendaftaran**: Jika sebuah objek mendaftarkan dirinya ke dalam sebuah sistem (misalnya, *event listener*), finalizer bisa digunakan untuk membatalkan pendaftaran tersebut secara otomatis.

**Peringatan dan Praktik Terbaik:**
1.  **Bukan untuk Cleanup Mendesak**: Karena waktunya tidak dapat diprediksi, jangan pernah mengandalkan `__gc` untuk operasi yang sensitif terhadap waktu. Jika Anda perlu memastikan file ditutup *segera*, selalu sediakan fungsi manual seperti `my_report:close()`. `__gc` hanyalah sebagai jaring pengaman.
2.  **Hindari Alokasi Memori Baru**: Sebisa mungkin, hindari membuat table atau data kompleks baru di dalam `__gc`. Finalizer seharusnya menjadi kode yang berjalan cepat dan sederhana.
3.  **Waspadai "Resurrection" (Kebangkitan Objek)**: Jika di dalam fungsi `__gc`, Anda membuat referensi baru ke objek yang sedang difinalisasi (misalnya menyimpannya di table global), objek tersebut akan "hidup kembali" dan tidak jadi dihapus oleh GC pada siklus itu. Lua menangani ini, tetapi bisa membingungkan.
4.  **Urutan Tidak Dijamin**: Jika beberapa objek dengan finalizer menjadi sampah pada saat yang sama, urutan eksekusi finalizer mereka tidak dijamin.

Singkatnya, `__gc` adalah jaring pengaman yang kuat untuk mencegah kebocoran sumber daya, bukan pengganti untuk praktik manajemen sumber daya yang eksplisit dan rapi.

---

Anda sekarang telah memahami siklus hidup penuh sebuah table, dari pembuatan hingga pembersihan oleh Garbage Collector.
Pada bagian berikutnya kita akan masuk pada materi dengan judul, **"8. WEAK TABLES"**, materi yang berhubungan sangat erat dengan Garbage Collection. Ini adalah mekanisme canggih yang memungkinkan Anda membuat table yang tidak mencegah isinya di-GC. Ini sangat berguna untuk membuat *cache* dan mengelola asosiasi data tanpa menyebabkan *memory leaks*.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-5/README.md
[selanjutnya]: ../bagian-8/README.md

<!----------------------------------------------------->

[0]: ../README.md#7-garbage-collection-dan-finalizers-topik-penting-yang-terlewat
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
