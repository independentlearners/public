# **[7. Manajemen Memori - _Deep Dive_][0]**

Dalam materi ini kita menyelami salah satu fitur kenyamanan utama Lua, yaitu manajemen memori otomatis, serta mempelajari bagaimana cara kerjanya di balik layar.

Lua membebaskan pemrogram dari beban manajemen memori manual yang rentan terhadap _error_, seperti `malloc` dan `free` di C. Lua secara otomatis mengelola memori untuk objek-objeknya melalui sebuah proses yang disebut **_Garbage Collection_ (GC)**. Memahami cara kerja GC, bagaimana ia berinteraksi dengan tipe data, dan bagaimana cara mengoptimalkannya adalah langkah penting untuk membangun aplikasi Lua yang besar dan beperforma tinggi.

### **7.1 _Garbage Collection_ dan Tipe Data**

#### **Algoritma GC dan Koleksi Spesifik Tipe**

- **Deskripsi Algoritma**: Lua menggunakan algoritma GC yang disebut **_incremental mark-and-sweep_**. Ini adalah proses dua tahap yang berjalan secara bertahap untuk menghindari jeda panjang ("stop-the-world") pada eksekusi program.

  1.  **_Mark Phase_ (Tahap Penandaan)**: GC memulai penelusuran dari "akar" (_roots_)—objek-objek yang dijamin dapat diakses, seperti tabel global dan registri C. Ia secara rekursif mengikuti semua referensi dari akar-akar ini, menandai setiap objek yang ditemuinya sebagai "dapat dijangkau" atau "hidup".
  2.  **_Sweep Phase_ (Tahap Penyapuan)**: Setelah tahap penandaan selesai, GC akan "menyapu" seluruh memori yang dikelolanya. Setiap objek yang **tidak** ditandai sebagai "hidup" dianggap sebagai sampah karena tidak ada lagi cara bagi program untuk mengaksesnya. Memori dari objek-objek sampah ini kemudian diklaim kembali (dibebaskan) untuk dapat digunakan lagi.

- **Sifat Inkremental**: Salah satu keunggulan GC Lua adalah sifatnya yang inkremental. Ia tidak menjalankan seluruh siklus _mark-and-sweep_ sekaligus, yang bisa menyebabkan program berhenti sejenak. Sebaliknya, ia bekerja dalam langkah-langkah kecil yang disisipkan di antara eksekusi normal kode Anda. Ini membuatnya sangat cocok untuk aplikasi yang sensitif terhadap latensi seperti game.

- **Tipe Data yang Dapat Dikoleksi**: GC hanya peduli pada objek yang dialokasikan secara dinamis di _heap_. Tipe-tipe yang dikelola oleh GC adalah:

  - `string`
  - `table`
  - `function` (khususnya, _closures_)
  - `thread` (_coroutines_)
  - `full userdata`

  Tipe-tipe primitif seperti `nil`, `boolean`, dan `number` biasanya merupakan nilai langsung yang tidak memerlukan koleksi individual oleh GC (memori mereka dikelola di _stack_ atau sebagai bagian dari objek lain).

---

#### **Referensi Lemah (_Weak References_) dan Tabel Lemah (_Weak Tables_)**

- **Deskripsi**: Secara default, semua referensi dalam Lua adalah **_strong references_ (referensi kuat)**. Jika sebuah objek memiliki setidaknya satu referensi kuat yang menunjuk padanya, GC **tidak akan** mengumpulkannya. Namun, terkadang Anda ingin mengasosiasikan data dengan sebuah objek tanpa mencegah objek tersebut dikoleksi jika tidak ada lagi yang menggunakannya. Untuk ini, Lua menyediakan **_weak references_ (referensi lemah)** melalui mekanisme **_weak tables_ (tabel lemah)**.

- **`__mode` Metamethod**: Sebuah tabel menjadi _weak_ jika metatable-nya memiliki _field_ `__mode`. Nilai dari `__mode` adalah string yang dapat berisi:

  - **`"k"` (keys)**: Kunci-kunci dalam tabel adalah referensi lemah. Jika sebuah objek hanya direferensikan sebagai kunci di tabel ini, ia dapat dikoleksi oleh GC. Ketika kunci tersebut dikoleksi, seluruh entri (pasangan kunci-nilai) akan dihapus dari tabel.
  - **`"v"` (values)**: Nilai-nilai dalam tabel adalah referensi lemah. Jika sebuah objek hanya direferensikan sebagai nilai di tabel ini, ia dapat dikoleksi oleh GC. Entri tersebut kemudian akan dihapus.
  - **`"kv"`**: Kunci dan nilai keduanya adalah referensi lemah.

- **Kasus Penggunaan Utama: _Caching_**: _Weak tables_ sangat ideal untuk mengimplementasikan _cache_. Anda dapat menyimpan hasil komputasi yang mahal di dalam sebuah _cache_. Jika objek input (kunci) tidak lagi digunakan di tempat lain dalam program, GC dapat secara otomatis menghapusnya dari _cache_, mencegah kebocoran memori.

- **Contoh _Weak Values Table_**:

  ```lua
  -- Buat sebuah tabel yang nilainya weak
  local cache = {}
  local mt = { __mode = "v" } -- 'v' untuk weak values
  setmetatable(cache, mt)

  -- Buat sebuah objek (tabel) dan simpan di cache
  local kunci = "hasil_user_123"
  local objekUser = { data = "Data penting milik user 123" }

  cache[kunci] = objekUser
  print("Objek user ada di cache:", cache[kunci] ~= nil) -- Output: true

  -- Sekarang, kita hapus satu-satunya referensi kuat ke objekUser
  objekUser = nil

  -- Paksa garbage collector berjalan (hanya untuk demonstrasi)
  -- Di aplikasi nyata, ini terjadi secara otomatis
  collectgarbage()

  -- Karena satu-satunya referensi ke objek data user ada di dalam cache yang
  -- nilainya weak, objek tersebut sekarang bebas untuk dikoleksi.
  print("Setelah GC, objek user ada di cache:", cache[kunci] ~= nil) -- Output: false
  ```

---

#### **_Finalizers_ dan `__gc` Metamethod**

- **Deskripsi**: Seperti yang telah kita bahas, _metamethod_ `__gc` berfungsi sebagai **_finalizer_** (atau _destructor_) untuk sebuah objek (`full userdata` atau `table`).
- **Peran dalam Siklus GC**:
  1.  Ketika GC menandai sebuah objek dengan `__gc` _metamethod_ sebagai sampah (tidak dapat dijangkau), ia **tidak langsung** mengumpulkannya.
  2.  Sebaliknya, objek tersebut dipindahkan ke sebuah daftar "finalisasi".
  3.  Setelah tahap penyapuan selesai, Lua akan melalui daftar ini dan memanggil fungsi `__gc` untuk setiap objek.
  4.  Baru pada **siklus GC berikutnya**, jika tidak ada referensi baru yang dibuat ke objek tersebut, memori untuk objek itu sendiri akan benar-benar dibebaskan.
- **Tujuan**: Tujuan utama `__gc` adalah untuk melepaskan **sumber daya eksternal** yang dikelola oleh objek tersebut—bukan untuk mengelola memori Lua. Contohnya termasuk:
  - Menutup _handle_ file (`file:close()`).
  - Menutup koneksi jaringan.
  - Membebaskan memori yang dialokasikan secara manual di C (`free()`).
  - Menghapus objek C++ (`delete`).

---

### **7.2 Pemrofilan (_Profiling_) dan Optimisasi Memori**

#### **Analisis Penggunaan Memori per Tipe Data**

- **Deskripsi**: _Profiling_ memori adalah proses menganalisis bagaimana program Anda menggunakan memori untuk menemukan area yang tidak efisien atau adanya kebocoran memori (_memory leaks_). Kebocoran memori di Lua biasanya terjadi bukan karena GC gagal, tetapi karena referensi kuat ke objek yang tidak lagi dibutuhkan masih tersimpan di suatu tempat (misalnya, dalam tabel global).
- **Alat Bawaan Lua**:
  Pustaka standar Lua menyediakan fungsi `collectgarbage()` yang dapat digunakan untuk wawasan dasar:

  - `collectgarbage("count")`: Mengembalikan total memori yang sedang digunakan oleh Lua dalam kilobita. Anda dapat memanggilnya sebelum dan sesudah suatu operasi untuk melihat dampaknya terhadap memori.

  ```lua
  local mem_awal = collectgarbage("count")
  local t = {}
  for i=1, 100000 do t[i] = i end
  local mem_akhir = collectgarbage("count")

  print(string.format("Memori yang digunakan untuk tabel besar: %.2f KB", mem_akhir - mem_awal))
  ```

- **Alat Eksternal**:
  Untuk analisis yang lebih mendalam (misalnya, melihat berapa banyak objek dari setiap tipe yang ada, atau melacak alokasi), Anda biasanya memerlukan alat _profiler_ pihak ketiga. Alat-alat ini dapat membantu Anda menjawab pertanyaan seperti:
  - "Mengapa penggunaan memori program saya terus meningkat?"
  - "Apakah ada pembuatan string yang berlebihan di dalam loop?"
  - "Objek apa yang paling banyak memakan memori?"

#### **Tata Letak Struktur Data (_Data Structure Memory Layout_)**

- **Deskripsi**: Seperti yang telah dibahas sebelumnya, cara Anda menyusun data dapat berdampak besar pada kinerja _cache_ dan penggunaan memori.
- **Optimisasi**:

  1.  **Gunakan Bagian _Array_**: Untuk daftar data, selalu prioritaskan penggunaan kunci integer berurutan mulai dari 1. Ini lebih efisien baik dari segi kecepatan (karena ramah _cache_) maupun dari segi memori (karena menghindari _overhead_ bagian _hash_).
  2.  **Struktur _Flat_ vs. _Hierarchical_**: Pertimbangkan _trade-off_ antara keterbacaan dan efisiensi.

      ```lua
      -- Struktur Hierarkis (mudah dibaca, lebih boros memori)
      -- Setiap sub-tabel memiliki overhead-nya sendiri.
      local points_hierarchical = {
          {x=10, y=20},
          {x=15, y=25},
          {x=18, y=28}
      }

      -- Struktur Flat (lebih hemat memori dan ramah cache, kurang intuitif)
      -- Hanya ada satu tabel dengan overhead minimal.
      local points_flat = {10, 20, 15, 25, 18, 28}
      -- Akses: points_flat[1] (x1), points_flat[2] (y1), dst.
      ```

      Untuk aplikasi yang memproses jutaan titik data (seperti dalam sistem partikel), struktur _flat_ bisa memberikan perbedaan kinerja yang sangat signifikan.

  3.  **Hindari Pembuatan Objek di Loop**: Hindari membuat tabel atau fungsi baru di dalam loop yang ketat. Jika memungkinkan, buat satu kali di luar loop dan gunakan kembali.

Anda telah menyelesaikan bagian penting tentang manajemen memori. Pengetahuan ini akan membantu Anda menulis aplikasi Lua yang tidak hanya benar secara fungsional, tetapi juga efisien dan andal.

Selanjutnya dalam kurikulum adalah **"8. FFI dan Tipe Data _Native_"**, yang akan membawa kita ke dunia LuaJIT dan interaksi berkecepatan tinggi dengan kode C.

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

[0]: ../README.md#7-memory-management---deep-dive
[1]: ../README.md
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
