# **[BAGIAN 12: PERFORMANCE DAN OPTIMASI TABLES][0]**

Anda telah belajar cara _menggunakan_ table dalam berbagai pola. Sekarang, mari kita pelajari cara menggunakannya secara _efisien_.

Menulis kode yang berfungsi itu satu hal; menulis kode yang cepat dan hemat memori adalah langkah berikutnya menuju penguasaan. Bagian ini akan membahas teknik-teknik kunci untuk mengoptimalkan penggunaan table Anda, yang sangat penting saat bekerja dengan data dalam jumlah besar atau dalam aplikasi yang berjalan lama.

💡 **Deskripsi Konsep**
Meskipun Lua adalah bahasa yang sangat cepat, cara Anda menggunakan table dapat memiliki dampak yang signifikan pada performa. Dengan memahami sedikit tentang cara kerja table "di balik layar", Anda dapat menghindari jebakan umum yang memperlambat program Anda dan menyebabkan penggunaan memori yang tidak perlu.

### **1. Memory Management Tables**

Ini adalah tentang praktik sadar untuk membantu Garbage Collector (GC) bekerja lebih efisien.

- **Lepaskan Referensi yang Tidak Perlu**: GC hanya bisa membersihkan objek yang tidak lagi memiliki referensi kuat. Jika Anda memiliki table besar yang tidak lagi digunakan, setel variabel yang menunjuk ke sana menjadi `nil`. Ini tidak secara langsung menghapus table, tetapi membuatnya menjadi "sampah" yang bisa diklaim oleh GC pada siklus berikutnya.
- **Gunakan Weak Tables untuk Cache**: Seperti yang dibahas di Bagian 8, jika Anda membuat cache, gunakan weak tables (`__mode = "k"` atau `"v"`). Ini mencegah cache Anda secara tidak sengaja menahan objek di memori selamanya, yang merupakan penyebab umum kebocoran memori (_memory leaks_).

```lua
local function process_large_data()
    local data = {} -- Asumsikan diisi dengan jutaan elemen
    for i = 1, 1000000 do data[i] = i end

    print("Data diproses...")

    -- Setelah selesai, lepaskan referensi agar memori bisa dibebaskan
    data = nil
end

process_large_data()
-- Di sini, table besar yang dibuat di dalam fungsi sudah menjadi kandidat untuk GC
collectgarbage() -- Memaksa GC untuk demonstrasi
print("Memori yang digunakan oleh 'data' sekarang bisa dibersihkan.")
```

### **2. Best Practices untuk Large Tables**

Saat bekerja dengan table yang sangat besar, beberapa kebiasaan dapat membuat perbedaan besar.

- **Utamakan Kunci Numerik**: Bagian array dari table (dengan kunci `1, 2, 3, ...`) sangat dioptimalkan. Mengakses elemen dengan `my_table[i]` umumnya lebih cepat daripada `my_table["kunci_string"]`. Jika memungkinkan, susun data Anda sebagai daftar.
- **Hindari Membuat Table Temporer di dalam Loop**: Membuat table baru adalah operasi yang relatif mahal. Jika Anda berada dalam loop yang berjalan ribuan kali, hindari membuat table kecil di setiap iterasi. Jika memungkinkan, gunakan kembali satu table.
- **Pilih Algoritma yang Tepat**: Seperti yang kita lihat pada implementasi Queue, `table.remove(t, 1)` adalah operasi O(n), yang sangat lambat pada table besar. Memahami kompleksitas algoritmik dari operasi table sangat penting. Menghapus dari akhir (`table.remove(t)`) adalah O(1) dan jauh lebih cepat.

### **3. Table Pre-allocation dan Sizing**

**Konsep**: Saat Anda terus menambahkan elemen ke table, Lua mungkin perlu mengubah ukurannya di latar belakang. Proses ini, yang disebut **re-hashing**, melibatkan alokasi blok memori baru yang lebih besar dan menyalin semua elemen lama. Ini adalah operasi yang lambat.

**Solusi**: Jika Anda tahu (atau bisa menebak) ukuran table sebelumnya, Anda bisa **pra-alokasi** (pre-allocate) kapasitasnya. Ini menghindari re-hashing yang mahal.

Meskipun Lua standar tidak memiliki fungsi `table.create(array_size, hash_size)` yang eksplisit (fitur ini ada di beberapa lingkungan Lua khusus seperti Roblox Luau), pola pengisian table yang benar dapat membantu interpreter/JIT mengoptimalkan alokasi.

**Contoh Kode 34: Pola Pengisian Table**

```lua
local N = 1000000

-- CARA KURANG BAIK: table.insert menyebabkan beberapa kali re-alokasi
local t1 = {}
for i = 1, N do
    table.insert(t1, {x = i}) -- Setiap panggilan bisa memicu re-hash
end

-- CARA LEBIH BAIK: Interpreter Lua seringkali lebih pintar dalam mengalokasikan
-- memori untuk pola loop seperti ini.
local t2 = {}
for i = 1, N do
    t2[i] = {x = i}
end
```

Intinya adalah, jika Anda membangun table dari awal, loop `for` yang mengisi indeks secara langsung (`t[i] = ...`) umumnya memberikan performa yang lebih dapat diprediksi daripada memanggil `table.insert` berulang kali.

### **4. Cache-Friendly Table Access Patterns**

**Konsep**: Ini adalah topik optimasi tingkat rendah yang berkaitan dengan cara kerja CPU. CPU memiliki memori kecil super cepat yang disebut **cache**. Mengambil data dari cache ribuan kali lebih cepat daripada mengambilnya dari RAM utama.

**Cache-friendly code** adalah kode yang memaksimalkan kemungkinan data yang dibutuhkan berikutnya sudah ada di dalam cache.

- **Akses Sekuensial (Sangat Baik)**: Menggunakan `ipairs` untuk melintasi bagian array dari sebuah table sangat ramah cache. Elemen-elemen array cenderung disimpan berdekatan di memori. Saat CPU memuat satu elemen, ia sering kali memuat beberapa elemen berikutnya ke dalam cache secara bersamaan ("prefetching").
- **Akses Acak (Kurang Baik)**: Menggunakan `pairs` (yang urutannya tidak dijamin) atau mengakses kunci acak dalam table hash yang besar dapat menyebabkan banyak "cache misses". Setiap akses mungkin memerlukan lompatan ke lokasi memori yang sama sekali berbeda, yang memaksa CPU untuk menunggu data dari RAM yang lambat.

**Praktik Terbaik**:
Ketika performa sangat kritis (misalnya, dalam game engine atau pemrosesan data bervolume tinggi), usahakan untuk:

1.  Menyusun data Anda dalam table datar yang besar (seperti array).
2.  Proses data tersebut secara sekuensial dari awal hingga akhir.

Pola ini memastikan pemanfaatan cache CPU yang maksimal dan sering kali memberikan peningkatan kecepatan yang dramatis dibandingkan dengan struktur data yang kompleks dengan banyak pointer yang melompat-lompat di memori.

---

Anda sekarang memiliki pengetahuan untuk tidak hanya menulis kode yang benar, tetapi juga kode yang berperforma tinggi. Memahami dampak memori dan cache adalah pembeda antara programmer pemula dan ahli.

Di bagian selanjutnya, **"13. ADVANCED PATTERNS DAN TEKNIK"**, kita akan beralih dari optimasi tingkat rendah ke pola arsitektur tingkat tinggi, seperti serialisasi, factory, dan memoization.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-11/README.md
[selanjutnya]: ../bagian-13/README.md

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
