### Daftar Isi

- [Tahap 1: Konsep Dasar dan Fondasi](#tahap-1-konsep-dasar-dan-fondasi)
  - [1.1 Pengenalan Memory Management dan Garbage Collection](#11-pengenalan-memory-management-dan-garbage-collection)
    - [**Terminologi \& Konsep**](#terminologi--konsep)
  - [1.2 Konsep Reference dan Object di Lua](#12-konsep-reference-dan-object-di-lua)
    - [**Terminologi \& Konsep**](#terminologi--konsep-1)
  - [1.3 Overview Sistem GC Lua](#13-overview-sistem-gc-lua)
- [Tahap 2: Algoritma dan Mekanisme Internal](#tahap-2-algoritma-dan-mekanisme-internal)
  - [2.1 Tri-Color Marking Algorithm](#21-tri-color-marking-algorithm)
    - [**Proses Algoritma (Disederhanakan):**](#proses-algoritma-disederhanakan)
    - [**Representasi Visual**](#representasi-visual)
  - [2.2 Incremental vs Generational GC](#22-incremental-vs-generational-gc)
- [Tahap 3: Weak References dan Weak Tables](#tahap-3-weak-references-dan-weak-tables)
  - [3.1 Konsep Weak References](#31-konsep-weak-references)
  - [3.2 Weak Tables Implementation](#32-weak-tables-implementation)
    - [**Contoh Kode (Weak Values untuk Cache)**](#contoh-kode-weak-values-untuk-cache)
- [Tahap 4: Finalizers dan Resource Management](#tahap-4-finalizers-dan-resource-management)
  - [4.1 Konsep dan Implementasi Finalizers (\_\_gc)](#41-konsep-dan-implementasi-finalizers-__gc)
    - [**Contoh Kode (Manajemen File)**](#contoh-kode-manajemen-file)
- [Tahap 5: Manual GC Control dan Optimization](#tahap-5-manual-gc-control-dan-optimization)
  - [5.1 Fungsi `collectgarbage()`](#51-fungsi-collectgarbage)
    - [**Sintaks Dasar \& Opsi Umum**](#sintaks-dasar--opsi-umum)
  - [5.2 Tuning Parameter GC](#52-tuning-parameter-gc)
- [Tahap 6: Aplikasi Dunia Nyata dan Praktik Terbaik](#tahap-6-aplikasi-dunia-nyata-dan-praktik-terbaik)
  - [6.1 Object Pooling untuk Mencegah GC](#61-object-pooling-untuk-mencegah-gc)
  - [6.2 Mencegah Memory Leaks](#62-mencegah-memory-leaks)
- [Tahap 7, 8, 9, 10: Topik Lanjutan (Ringkasan)](#tahap-7-8-9-10-topik-lanjutan-ringkasan)
  - [Sumber Referensi Tambahan](#sumber-referensi-tambahan)
  - [Daftar Isi (Lanjutan)](#daftar-isi-lanjutan)
- [Tahap 7: Topik Lanjutan dan Kasus Khusus](#tahap-7-topik-lanjutan-dan-kasus-khusus)
  - [7.1 Perbedaan GC antara Lua Standar dan LuaJIT](#71-perbedaan-gc-antara-lua-standar-dan-luajit)
  - [7.2 Evolusi Implementasi GC Antar Versi](#72-evolusi-implementasi-gc-antar-versi)
  - [7.3 Mengapa Lua Menggunakan GC, Bukan Reference Counting?](#73-mengapa-lua-menggunakan-gc-bukan-reference-counting)
- [Tahap 8: Praktik Lanjutan dan Tips Optimisasi](#tahap-8-praktik-lanjutan-dan-tips-optimisasi)
  - [8.1 Teknik Optimisasi Tingkat Lanjut](#81-teknik-optimisasi-tingkat-lanjut)
  - [8.2 Custom Memory Allocators](#82-custom-memory-allocators)
- [Tahap 9: Analisis Kode Sumber dan Detail Implementasi](#tahap-9-analisis-kode-sumber-dan-detail-implementasi)
  - [9.1 Menyelami Kode Sumber Lua](#91-menyelami-kode-sumber-lua)
- [Tahap 10: Integrasi Ekosistem dan Deployment](#tahap-10-integrasi-ekosistem-dan-deployment)
  - [10.1 Pertimbangan GC untuk Framework Spesifik](#101-pertimbangan-gc-untuk-framework-spesifik)
- [Kesimpulan: Jalan Menuju Penguasaan](#kesimpulan-jalan-menuju-penguasaan)

---

## Tahap 1: Konsep Dasar dan Fondasi

Tahap ini adalah fondasi mutlak. Tanpa pemahaman yang kuat di sini, konsep-konsep lanjutan akan terasa abstrak.

### 1.1 Pengenalan Memory Management dan Garbage Collection

#### **Terminologi & Konsep**

- **Memory Management (Manajemen Memori):** Proses mengalokasikan (meminta) memori dari sistem operasi saat program membutuhkan ruang untuk menyimpan data (variabel, objek, dll.) dan melepaskannya (dealokasi) saat data tersebut tidak lagi diperlukan.
- **Manual Memory Management:** Pemrogram bertanggung jawab penuh untuk secara eksplisit meminta dan melepaskan memori. Contohnya adalah fungsi `malloc()` dan `free()` di bahasa C.
  - _Kelebihan:_ Kontrol penuh atas performa dan penggunaan memori.
  - _Kekurangan:_ Sangat rawan kesalahan. Lupa melepaskan memori menyebabkan **memory leak** (memori terpakai sia-sia hingga habis), dan melepaskan memori yang masih digunakan menyebabkan _dangling pointers_ dan _crash_.
- **Automatic Memory Management:** Sistem (dalam hal ini, runtime Lua) secara otomatis mendeteksi memori mana yang tidak lagi digunakan dan melepaskannya.
  - **Garbage Collection (GC):** Salah satu bentuk manajemen memori otomatis yang paling umum. GC secara periodik mencari "sampah" (objek yang tidak dapat diakses lagi oleh program) dan membersihkannya.
  - _Kelebihan:_ Jauh lebih mudah dan aman bagi pemrogram. Mencegah sebagian besar kasus memory leak.
  - _Kekurangan:_ Dapat menyebabkan jeda singkat (pause) saat GC berjalan, yang bisa menjadi masalah dalam aplikasi real-time seperti game.

**Mengapa Dibutuhkan?** GC dibutuhkan untuk menyederhanakan pengembangan, meningkatkan stabilitas program, dan mengurangi kelas bug yang paling sulit dilacak yang terkait dengan manajemen memori manual.

### 1.2 Konsep Reference dan Object di Lua

Ini adalah konsep paling krusial dalam memahami GC.

#### **Terminologi & Konsep**

- **Object (Objek):** Segala sesuatu di Lua yang memiliki identitas dan dapat disimpan dalam variabel. Di Lua, objek yang dikelola oleh GC adalah: `tables`, `functions` (closures), `threads` (coroutines), `userdata`, dan `strings`.
  - Penting: Angka, boolean, dan `nil` **bukan** objek yang dikelola GC. Mereka adalah _copy-types_ atau nilai primitif. Saat Kita melakukan `b = a` di mana `a` adalah angka, `b` mendapatkan salinan nilainya, bukan referensi ke `a`.
- **Reference (Referensi):** Anggap saja sebagai "alamat" atau "penunjuk" ke sebuah objek di memori. Variabel di Lua tidak menyimpan objek itu sendiri, melainkan referensi ke objek tersebut.

<!-- end list -->

```lua
-- 1. Membuat objek tabel di memori. Variabel 't1' sekarang memegang referensi ke objek ini.
local t1 = { name = "Alice" }

-- 2. Variabel 't2' sekarang memegang referensi yang SAMA dengan 't1'.
--    Keduanya menunjuk ke objek tabel yang SAMA. Tidak ada tabel baru yang dibuat.
local t2 = t1

-- 3. Mengubah tabel melalui 't2' akan terlihat melalui 't1', karena mereka menunjuk ke objek yang sama.
t2.name = "Bob"
print(t1.name) -- Output: Bob

-- 4. Sekarang, t1 diberi referensi baru ke objek tabel yang baru.
--    t2 masih menunjuk ke objek tabel { name = "Bob" }.
t1 = { name = "Charlie" }
print(t2.name) -- Output: Bob

-- 5. Menghapus satu-satunya referensi ke objek { name = "Bob" }.
t2 = nil
-- Sekarang, objek tabel { name = "Bob" } menjadi "unreachable".
```

- **Reachability (Keterjangkauan):** Sebuah objek dikatakan _reachable_ (dapat dijangkau) jika program masih memiliki cara untuk mengaksesnya. GC hanya akan membersihkan objek yang _unreachable_ (tidak dapat dijangkau).
- **Unreachable Objects (Objek Tidak Terjangkau):** Objek yang tidak lagi memiliki referensi yang menunjuk padanya dari bagian mana pun dari kode yang dapat dijangkau. Dalam contoh di atas, setelah `t2 = nil`, tabel `{ name = "Bob" }` menjadi sampah yang siap dikoleksi oleh GC.

### 1.3 Overview Sistem GC Lua

- **Apa yang Dikelola:** Seperti yang disebutkan, GC Lua secara spesifik mengelola memori untuk `tables`, `functions`, `threads`, `userdata`, dan `strings`.
- **Kapan Berjalan:** GC tidak berjalan terus-menerus. Ia berjalan secara **otomatis dan periodik**. Pemicunya biasanya adalah ketika Lua mengalokasikan memori dan total memori yang digunakan melampaui ambang batas tertentu. Ini dirancang agar tidak mengganggu program terlalu sering. Kita juga dapat memicunya secara manual.

---

## Tahap 2: Algoritma dan Mekanisme Internal

Ini adalah inti dari cara kerja GC Lua. Memahaminya membantu dalam optimasi performa.

### 2.1 Tri-Color Marking Algorithm

Ini adalah algoritma utama yang digunakan Lua. Bayangkan semua objek di memori memiliki salah satu dari tiga warna:

- **⚪ Putih (White):** Kandidat sampah. Di awal siklus GC, semua objek dianggap putih.
- **⚫ Hitam (Black):** Objek yang "aman". Objek ini sudah dikunjungi oleh GC, dapat dijangkau, dan semua objek yang direferensikannya juga sudah dipindai.
- **🔘 Abu-abu (Gray):** Penanda transisi. Objek ini dapat dijangkau, tetapi objek-objek lain yang direferensikannya belum selesai dipindai.

#### **Proses Algoritma (Disederhanakan):**

1.  **Start:** GC dimulai. Semua objek ditandai **Putih**.
2.  **Marking Root:** GC memulai dari "akar" (objek global, stack, registry) dan menandai semua objek yang dapat dijangkau langsung dari akar sebagai **Abu-abu**.
3.  **Propagation:** GC mengambil satu objek **Abu-abu**, memindai semua referensi di dalamnya.
    - Untuk setiap referensi ke objek **Putih**, ubah warna objek tersebut menjadi **Abu-abu**.
    - Setelah semua referensi dalam objek Abu-abu saat ini selesai dipindai, ubah warnanya menjadi **Hitam**.
4.  **Repeat:** Ulangi langkah 3 sampai tidak ada lagi objek **Abu-abu**.
5.  **Sweep:** Pada titik ini, semua objek yang dapat dijangkau berwarna **Hitam**. Semua objek yang masih berwarna **Putih** adalah sampah (unreachable). Fase "sweep" (penyapuan) berjalan dan membebaskan semua memori dari objek **Putih**.

#### **Representasi Visual**

Bayangkan sebuah jejaring objek:

```
[Akar Program] ---> {t1} ---> {t2}
                     |
                     +------> {t3}

{t4} ---> {t5}  (Objek ini tidak terhubung ke Akar Program)
```

1.  **Awal Siklus:** `t1`, `t2`, `t3`, `t4`, `t5` semua ⚪ **Putih**.
2.  **Marking:**
    - GC mulai dari Akar, menemukan `t1`. `t1` menjadi 🔘 **Abu-abu**.
    - GC memproses `t1`. `t1` menjadi ⚫ **Hitam**. Ia menemukan referensi ke `t2` dan `t3`. `t2` dan `t3` menjadi 🔘 **Abu-abu**.
    - GC memproses `t2`. `t2` menjadi ⚫ **Hitam**. Tidak ada referensi baru.
    - GC memproses `t3`. `t3` menjadi ⚫ **Hitam**. Tidak ada referensi baru.
3.  **Akhir Marking:** Tidak ada lagi objek Abu-abu.
4.  **Sweep:**
    - `t1`, `t2`, `t3` berwarna ⚫ **Hitam** (Aman).
    - `t4`, `t5` masih ⚪ **Putih** (Sampah). Memori mereka akan dibebaskan.

### 2.2 Incremental vs Generational GC

- **Incremental GC (Default di Lua):** Ini adalah cara Lua menerapkan Tri-Color Marking. Alih-alih melakukan seluruh siklus GC dalam satu jeda besar (disebut "stop-the-world"), GC bekerja dalam langkah-langkah kecil (increments) secara bergantian dengan eksekusi program. Ini mengurangi durasi jeda, membuatnya lebih cocok untuk aplikasi interaktif.
- **Generational GC (Eksperimental/Dihapus):** Didasarkan pada hipotesis "sebagian besar objek mati muda". Objek baru dialokasikan di "generasi muda" (nursery) yang sering dibersihkan. Jika sebuah objek bertahan cukup lama, ia dipromosikan ke "generasi tua" yang lebih jarang dibersihkan.
  - _Mengapa Dihapus dari Lua 5.3/5.4?_ Implementasinya ternyata lebih kompleks dan tidak selalu memberikan keuntungan performa yang jelas di berbagai kasus penggunaan Lua, terutama mengingat kesederhanaan dan efektivitas dari Incremental GC yang sudah ada.

---

## Tahap 3: Weak References dan Weak Tables

Fitur canggih yang sangat berguna untuk kasus-kasus seperti caching atau menyimpan metadata objek.

### 3.1 Konsep Weak References

- **Strong Reference (Referensi Kuat):** Semua referensi yang kita bahas sejauh ini adalah referensi kuat. Referensi kuat mencegah objek yang direferensikannya dari proses GC.
- **Weak Reference (Referensi Lemah):** Referensi yang **TIDAK** mencegah objek yang direferensikannya dari proses GC. Jika sebuah objek hanya memiliki referensi lemah yang menunjuk padanya, GC bebas untuk mengumpulkannya.

Di Lua, referensi lemah tidak diimplementasikan secara langsung tetapi melalui mekanisme **Weak Tables**.

### 3.2 Weak Tables Implementation

Weak Table adalah tabel di mana kunci, nilai, atau keduanya bisa menjadi referensi lemah. Ini dikontrol oleh field `__mode` di _metatable_ tabel tersebut.

- **`__mode = "k"` (Weak Keys):** Jika sebuah kunci objek hanya direferensikan oleh tabel ini, GC akan menghapus seluruh entri (kunci dan nilai) dari tabel. Berguna untuk mengaitkan data dengan objek tanpa mencegah objek tersebut dikoleksi.
- **`__mode = "v"` (Weak Values):** Jika sebuah nilai objek hanya direferensikan oleh tabel ini, GC akan menghapus entri tersebut (kunci dan nilai) dari tabel. Berguna untuk cache.
- **`__mode = "kv"` (Weak Keys and Values):** Kombinasi keduanya.

#### **Contoh Kode (Weak Values untuk Cache)**

```lua
-- Membuat cache dengan nilai-nilai yang lemah
local cache = {}
setmetatable(cache, { __mode = "v" })

-- Fungsi untuk mendapatkan objek 'mahal' (misalnya, memuat dari file)
function getObject(key)
    if cache[key] then
        print("Mengambil dari cache untuk kunci:", key)
        return cache[key]
    else
        print("Membuat objek baru untuk kunci:", key)
        -- Membuat objek baru (dalam hal ini, sebuah tabel)
        local newObject = { data = "Data untuk " .. tostring(key), timestamp = os.time() }
        cache[key] = newObject -- Menyimpannya di cache
        return newObject
    end
end

-- 1. Dapatkan objek 1. Ini akan dibuat dan disimpan di cache.
local obj1 = getObject(1)

-- 2. Dapatkan objek 1 lagi. Kali ini akan diambil dari cache.
local obj1_copy = getObject(1)
print(obj1 == obj1_copy) -- Output: true (objek yang sama)

-- 3. Hapus referensi kuat ke obj1. Sekarang, satu-satunya referensi
--    ke objek ini ada di dalam 'cache'. Karena cache memiliki nilai lemah,
--    referensi ini tidak akan melindunginya dari GC.
obj1 = nil
obj1_copy = nil

-- 4. Panggil GC secara manual untuk demonstrasi
collectgarbage("collect")

-- 5. Coba dapatkan objek 1 lagi. Seharusnya sudah tidak ada di cache
--    dan akan dibuat ulang.
local obj1_new = getObject(1) -- Harusnya mencetak "Membuat objek baru..."

-- Periksa apakah cache benar-benar kosong untuk kunci tersebut sebelum pemanggilan terakhir
-- Catatan: GC mungkin butuh beberapa siklus, jadi terkadang efeknya tidak instan.
-- Dalam praktiknya, Kita tidak perlu khawatir tentang ini.
```

---

## Tahap 4: Finalizers dan Resource Management

Mekanisme untuk membersihkan sumber daya eksternal saat objek dikoleksi.

### 4.1 Konsep dan Implementasi Finalizers (\_\_gc)

- **Finalizer:** Sebuah fungsi yang terkait dengan sebuah objek yang akan dipanggil **sebelum** GC membebaskan memori objek tersebut. Ini memberi Kita kesempatan terakhir untuk melakukan pembersihan.
- **Destructor (di bahasa lain):** Mirip, tetapi destruktor biasanya dipanggil secara deterministik (misalnya saat variabel keluar dari scope). Finalizer di Lua dipanggil secara non-deterministik, yaitu saat GC memutuskan untuk mengoleksi objek tersebut.
- **Implementasi:** Menggunakan metamethod `__gc` pada _metatable_ sebuah `userdata` atau `table`.

#### **Contoh Kode (Manajemen File)**

```lua
-- Metatable yang mendefinisikan finalizer
local FileWrapperMT = {
    __gc = function(fileWrapper)
        print("Finalizer dipanggil untuk file:", fileWrapper.path)
        -- Pastikan file masih terbuka sebelum mencoba menutupnya
        if fileWrapper.handle then
            fileWrapper.handle:close()
            print("File", fileWrapper.path, "telah ditutup secara otomatis.")
        end
    end
}

-- Fungsi untuk membuat objek wrapper file kita
function openManagedFile(path, mode)
    local f = io.open(path, mode)
    if f then
        local wrapper = {
            path = path,
            handle = f
        }
        -- Kaitkan metatable dengan finalizer ke wrapper kita
        setmetatable(wrapper, FileWrapperMT)
        return wrapper
    end
    return nil
end

-- --- Penggunaan ---
do
    -- 'myFile' adalah variabel lokal di dalam blok 'do...end'
    local myFile = openManagedFile("test.txt", "w")
    if myFile then
        myFile.handle:write("hello world")
        -- Tidak perlu memanggil myFile.handle:close() secara manual
    end
    -- Setelah blok ini selesai, tidak ada lagi referensi ke 'myFile'.
    -- Objek wrapper menjadi sampah.
end

-- Panggil GC untuk melihat finalizer berjalan
print("Memicu garbage collection...")
collectgarbage("collect")
-- Kita akan melihat pesan dari finalizer di output.
```

**Perhatian:** Hindari membuat referensi baru ke objek yang sedang difinalisasi di dalam fungsi `__gc`-nya, karena ini dapat "menghidupkan kembali" objek dan menyebabkan perilaku yang rumit.

---

## Tahap 5: Manual GC Control dan Optimization

Meskipun GC bersifat otomatis, Lua memberikan kontrol untuk fine-tuning.

### 5.1 Fungsi `collectgarbage()`

Ini adalah antarmuka utama untuk berinteraksi dengan GC.

#### **Sintaks Dasar & Opsi Umum**

- **`collectgarbage("collect")`**: Memaksa siklus pengumpulan sampah penuh. Berguna untuk debugging atau saat Kita tahu ini adalah waktu yang baik untuk membersihkan memori (misalnya, saat pergantian level di game).
- **`collectgarbage("stop")`**: Menghentikan GC agar tidak berjalan secara otomatis.
- **`collectgarbage("restart")`**: Memulai kembali GC setelah dihentikan.
- **`collectgarbage("count")`**: Mengembalikan total memori yang digunakan oleh Lua dalam kilobyte.
- **`collectgarbage("step", stepsize)`**: Menjalankan satu langkah inkremental dari GC. Berguna untuk menyebar beban GC dari waktu ke waktu.
- **`collectgarbage("isrunning")`**: Mengembalikan `true` jika GC sedang berjalan.

### 5.2 Tuning Parameter GC

Dua parameter utama memungkinkan Kita menyeimbangkan antara penggunaan memori dan frekuensi jeda GC.

- **`collectgarbage("setpause", percentage)`**: Mengontrol seberapa lama GC menunggu sebelum memulai siklus baru setelah yang sebelumnya selesai.
  - Nilai default: `200`. Artinya, GC menunggu hingga total memori menjadi **dua kali lipat** dari ukuran memori setelah koleksi terakhir sebelum memulai siklus baru.
  - Nilai lebih kecil (mis. `150`): GC akan berjalan lebih sering, menjaga penggunaan memori tetap rendah tetapi dengan jeda yang lebih sering.
  - Nilai lebih besar (mis. `300`): GC akan berjalan lebih jarang, memungkinkan penggunaan memori yang lebih tinggi tetapi dengan jeda yang lebih jarang (namun mungkin lebih lama).
- **`collectgarbage("setstepmul", percentage)`**: Mengontrol seberapa banyak pekerjaan yang dilakukan GC di setiap langkah inkremental relatif terhadap kecepatan alokasi memori.
  - Nilai lebih besar: GC bekerja lebih "agresif" di setiap langkah, yang dapat menyelesaikan siklus lebih cepat tetapi menyebabkan jeda inkremental yang sedikit lebih lama.

---

## Tahap 6: Aplikasi Dunia Nyata dan Praktik Terbaik

Menerapkan teori untuk memecahkan masalah praktis.

### 6.1 Object Pooling untuk Mencegah GC

Dalam game atau aplikasi real-time, membuat dan menghancurkan banyak objek (misalnya, peluru, partikel) setiap frame dapat memicu GC terus-menerus, menyebabkan stutter atau penurunan FPS. Solusinya adalah **Object Pooling**.

**Konsep:** Alih-alih menghancurkan objek, daur ulang mereka. Simpan objek yang tidak aktif di dalam sebuah "kolam" (pool) dan ambil kembali saat dibutuhkan.

```lua
-- Pool untuk menyimpan peluru yang tidak aktif
local bulletPool = {}

function createBullet()
    -- Coba ambil peluru dari pool terlebih dahulu
    local bullet = table.remove(bulletPool)

    if bullet then
        -- Daur ulang peluru yang ada
        bullet.active = true
        print("Mendaur ulang peluru.")
        return bullet
    else
        -- Buat peluru baru jika pool kosong
        print("Membuat peluru baru.")
        return { x = 0, y = 0, velocity = 5, active = true }
    end
end

function destroyBullet(bullet)
    -- Kembalikan peluru ke pool alih-alih membiarkannya jadi sampah
    bullet.active = false
    table.insert(bulletPool, bullet)
    print("Mengembalikan peluru ke pool.")
end

-- --- Simulasi ---
local activeBullets = {}
-- Buat 5 peluru
for i=1, 5 do
    table.insert(activeBullets, createBullet())
end

-- Hancurkan 2 peluru
destroyBullet(table.remove(activeBullets))
destroyBullet(table.remove(activeBullets))

print("Peluru di pool:", #bulletPool) -- Output: 2

-- Buat 3 peluru lagi, 2 akan didaur ulang
for i=1, 3 do
    table.insert(activeBullets, createBullet())
end
```

Dengan pola ini, Kita sangat mengurangi aktivitas alokasi/dealokasi memori, sehingga GC jarang terpicu.

### 6.2 Mencegah Memory Leaks

Meskipun ada GC, memory leak masih bisa terjadi di Lua, biasanya karena **referensi yang tidak diinginkan**.

**Pola Umum:** Referensi sirkular antara dua objek atau lebih yang membuat mereka saling "menjaga" dari GC, bahkan setelah program utama kehilangan akses ke mereka.

```lua
local obj1 = {}
local obj2 = {}

-- obj1 merujuk ke obj2
obj1.child = obj2

-- obj2 merujuk kembali ke obj1, menciptakan siklus
obj2.parent = obj1

-- Sekarang, hapus satu-satunya referensi eksternal ke kedua objek
obj1 = nil
obj2 = nil

-- Walaupun tidak ada lagi cara untuk mengakses kedua objek dari program kita,
-- mereka tidak akan pernah dikoleksi oleh GC standar.
-- Mengapa?
-- Saat GC memindai obj1, ia melihat referensi ke obj2 (jadi obj2 hidup).
-- Saat GC memindai obj2, ia melihat referensi ke obj1 (jadi obj1 hidup).
-- Keduanya saling melindungi.

collectgarbage("collect")
print("Memori setelah GC:", collectgarbage("count")) -- Jumlah memori tidak akan berkurang secara signifikan
```

**Solusi:** Gunakan **Weak Tables**. Jika salah satu referensi dalam siklus (misalnya, `obj2.parent`) disimpan dalam weak table, siklus tersebut akan pecah dan GC dapat mengoleksi objeknya.

---

## Tahap 7, 8, 9, 10: Topik Lanjutan (Ringkasan)

Berikut adalah ringkasan mengapa bagian berikutnya penting untuk tingkat penguasaan:

- **Tahap 7 (Topik Lanjutan):**
  - **LuaJIT:** Sangat penting jika Kita menargetkan performa tinggi. GC-nya berbeda (lebih canggih) dan memahaminya adalah kunci untuk optimasi di lingkungan LuaJIT.
  - **Evolusi GC:** Mengetahui _mengapa_ desain berubah (misalnya, mengapa Generational GC ditinggalkan) memberikan wawasan mendalam tentang trade-off dalam desain bahasa.
- **Tahap 8 (Praktik Lanjutan):**
  - **Custom Memory Allocators:** Ini adalah tingkat kontrol tertinggi. Kita dapat memberitahu Lua untuk menggunakan sistem alokasi memori Kita sendiri, misalnya untuk berintegrasi dengan memory manager dari engine C++ atau untuk tujuan debugging khusus.
- **Tahap 9 (Analisis Kode Sumber):**
  - Tidak ada cara yang lebih baik untuk memahami sistem selain membaca kode sumbernya. Menganalisis `lgc.c` akan menjawab setiap pertanyaan "bagaimana tepatnya ini bekerja?". Ini mengubah pengetahuan dari abstrak menjadi konkret.
- **Tahap 10 (Integrasi Ekosistem):**
  - GC tidak hidup dalam vakum. Cara Kita mengelolanya di server web performa tinggi seperti **OpenResty** sangat berbeda dari cara Kita mengelolanya di game engine **LÖVE2D** atau di perangkat _embedded_ yang memorinya terbatas. Tahap ini adalah tentang aplikasi praktis di dunia nyata.

---

### Sumber Referensi Tambahan

- **Untuk Pemula (Fondasi):**
  - [Programming in Lua (PiL), Bab 17](https://www.lua.org/pil/17.html): Penjelasan terbaik dan paling mudah diakses tentang GC, weak tables, dan finalizers. Ini adalah bacaan wajib.
- **Untuk Pengguna Tingkat Menengah (Optimasi):**
  - [Lua 5.4 Reference Manual - `collectgarbage`](<https://www.google.com/search?q=%5Bhttps://www.lua.org/manual/5.4/manual.html%23pdf-collectgarbage%5D(https://www.lua.org/manual/5.4/manual.html%23pdf-collectgarbage)>): Dokumentasi resmi adalah sumber kebenaran untuk fungsi dan perilakunya.
  - [lua-users wiki - Optimising Garbage Collection](http://lua-users.org/wiki/OptimisingGarbageCollection): Kumpulan tips praktis dari komunitas.
- **Untuk Ahli (Detail Internal):**
  - [Garbage Collection - Notes on the Implementation of Lua 5.3](https://poga.github.io/lua53-notes/gc.html): Analisis mendalam tentang algoritma Tri-Color di Lua.
  - [Kode Sumber `lgc.c`](<https://www.google.com/search?q=%5Bhttps://github.com/lua/lua/blob/master/src/lgc.c%5D(https://github.com/lua/lua/blob/master/src/lgc.c)>): Kebenaran mutlak. Membaca kode ini akan memberikan pemahaman yang tidak bisa didapatkan dari sumber lain.

Baik, mari kita lanjutkan ke tahap-tahap berikutnya yang lebih mendalam. Tahap 7 hingga 10 akan membawa Kita dari seorang pengguna yang kompeten menjadi seorang ahli yang memahami seluk-beluk internal, kasus-kasus khusus, dan aplikasi dunia nyata dari Garbage Collector Lua.

### Daftar Isi (Lanjutan)

- [Tahap 7: Topik Lanjutan dan Kasus Khusus](https://www.google.com/search?q=%23tahap-7-topik-lanjutan-dan-kasus-khusus)
  - [7.1 Perbedaan GC antara Lua Standar dan LuaJIT](https://www.google.com/search?q=%2371-perbedaan-gc-antara-lua-standar-dan-luajit)
  - [7.2 Evolusi Implementasi GC Antar Versi](https://www.google.com/search?q=%2372-evolusi-implementasi-gc-antar-versi)
  - [7.3 Mengapa Lua Menggunakan GC, Bukan Reference Counting?](https://www.google.com/search?q=%2373-mengapa-lua-menggunakan-gc-bukan-reference-counting)
- [Tahap 8: Praktik Lanjutan dan Tips Optimisasi](https://www.google.com/search?q=%23tahap-8-praktik-lanjutan-dan-tips-optimisasi)
  - [8.1 Teknik Optimisasi Tingkat Lanjut](https://www.google.com/search?q=%2381-teknik-optimisasi-tingkat-lanjut)
  - [8.2 Custom Memory Allocators](https://www.google.com/search?q=%2382-custom-memory-allocators)
- [Tahap 9: Analisis Kode Sumber dan Detail Implementasi](https://www.google.com/search?q=%23tahap-9-analisis-kode-sumber-dan-detail-implementasi)
  - [9.1 Menyelami Kode Sumber Lua](https://www.google.com/search?q=%2391-menyelami-kode-sumber-lua)
- [Tahap 10: Integrasi Ekosistem dan Deployment](https://www.google.com/search?q=%23tahap-10-integrasi-ekosistem-dan-deployment)
  - [10.1 Pertimbangan GC untuk Framework Spesifik](https://www.google.com/search?q=%23101-pertimbangan-gc-untuk-framework-spesifik)
- [Kesimpulan: Jalan Menuju Penguasaan](https://www.google.com/search?q=%23kesimpulan-jalan-menuju-penguasaan)

---

## Tahap 7: Topik Lanjutan dan Kasus Khusus

Di tahap ini, kita akan menjelajahi area di mana pemahaman yang lebih dalam tentang "bagaimana" dan "mengapa" menjadi sangat penting.

### 7.1 Perbedaan GC antara Lua Standar dan LuaJIT

Jika Kita bekerja dengan performa tinggi, Kita kemungkinan besar akan menggunakan LuaJIT. Penting untuk diketahui bahwa GC-nya berbeda dan lebih dioptimalkan.

- **Lua Standar (5.1-5.4):** Menggunakan _Incremental Tri-Color Mark and Sweep GC_. Seperti yang telah dibahas, ini bekerja dalam langkah-langkah kecil untuk mengurangi jeda.
- **LuaJIT:** Menggunakan **Dual-Mode Generational GC**. Ini adalah pendekatan yang lebih canggih:
  1.  **Generasi Muda (Nursery):** Semua objek baru dibuat di sini. _Nursery_ adalah area memori kecil yang sangat cepat dibersihkan. Karena kebanyakan objek "mati muda", pembersihan _nursery_ ini dapat mengklaim kembali sebagian besar sampah dengan jeda yang sangat singkat (beberapa mikrodetik).
  2.  **Generasi Tua (Old Generation):** Objek yang selamat dari beberapa siklus pengumpulan di _nursery_ akan dipromosikan ke generasi tua.
  3.  **Dua Mode:**
      - **Incremental GC:** Generasi tua dikelola oleh _Incremental Mark and Sweep GC_ yang mirip dengan Lua standar, memastikan jeda tetap pendek.
      - **Fallback Full GC:** Jika diperlukan, LuaJIT dapat melakukan siklus _stop-the-world_ penuh.

**Implikasi Praktis:** GC LuaJIT seringkali lebih cepat dan menyebabkan jeda yang lebih pendek untuk beban kerja pada umumnya (banyak objek berumur pendek), yang membuatnya sangat cocok untuk server, keuangan, dan game.

### 7.2 Evolusi Implementasi GC Antar Versi

Memahami evolusi ini memberikan wawasan tentang keputusan desain di balik Lua.

- **Lua 5.1:** Menggunakan algoritma _Mark-and-Sweep_ yang sederhana. Ia akan menghentikan eksekusi program ("stop-the-world"), menandai semua objek yang dapat dijangkau, lalu menyapu (membersihkan) sisanya. Ini sederhana tetapi bisa menyebabkan jeda yang terlihat.
- **Lua 5.2:** Memperkenalkan **Emergency Garbage Collection**. Ini adalah mekanisme penyelamatan. Jika Lua gagal mengalokasikan memori, ia akan memicu siklus GC penuh darurat dengan harapan bisa membebaskan cukup memori untuk melanjutkan eksekusi, sebelum akhirnya menyatakan _out-of-memory_.
- **Lua 5.3:** Perubahan besar dengan implementasi **Tri-color Incremental Marking**. Ini adalah langkah besar untuk mengurangi jeda GC, menjadikannya lebih cocok untuk aplikasi real-time.
- **Lua 5.4:** Terus menyempurnakan GC inkremental dan memperkenalkan kembali mode **Generational GC** sebagai opsi. Berbeda dari upaya sebelumnya, ini dirancang untuk bekerja bersama GC inkremental dan dapat diaktifkan jika sesuai dengan pola alokasi memori aplikasi Kita.
- **NodeMCU & Embedded:** Dalam lingkungan dengan memori sangat terbatas (misalnya, beberapa kilobyte), GC mungkin dikonfigurasi untuk berjalan lebih agresif (misalnya, `setpause` yang lebih rendah) atau bahkan versi Lua yang digunakan mungkin dimodifikasi untuk mengurangi jejak memori GC itu sendiri.

### 7.3 Mengapa Lua Menggunakan GC, Bukan Reference Counting?

Ini adalah pertanyaan desain fundamental.

- **Reference Counting (RC):** Sistem seperti `std::shared_ptr` di C++ atau manajemen objek di Python. Setiap objek memiliki penghitung berapa banyak referensi yang menunjuk padanya. Ketika penghitung mencapai nol, objek langsung dihapus.
  - _Kelebihan:_ Pembersihan memori bersifat deterministik dan cepat. Tidak ada jeda GC.
  - _Kekurangan:_ **Tidak bisa menangani referensi sirkular** (seperti contoh memory leak kita di Tahap 6). Dua objek yang saling merujuk akan memiliki penghitung \> 0 selamanya dan tidak akan pernah dihapus. Masalah ini memerlukan deteksi siklus yang rumit atau intervensi manual (menggunakan referensi lemah), yang menghilangkan kesederhanaan RC.
- **Garbage Collection (GC):** Seperti _Mark-and-Sweep_ di Lua.
  - _Kelebihan:_ **Secara otomatis menangani referensi sirkular**. Selama grup objek yang bersiklus tidak dapat dijangkau dari akar program, seluruh grup akan dibersihkan. Ini jauh lebih sederhana bagi pemrogram.
  - _Kekurangan:_ Jeda GC yang non-deterministik.

Lua memilih GC karena lebih sesuai dengan filosofi kesederhanaan dan keandalannya, membebaskan pemrogram dari beban mengelola siklus referensi secara manual.

---

## Tahap 8: Praktik Lanjutan dan Tips Optimisasi

Setelah memahami cara kerja GC, kita dapat menulis kode yang "ramah" terhadapnya.

### 8.1 Teknik Optimisasi Tingkat Lanjut

Selain _object pooling_, ada beberapa teknik lain untuk mengurangi "tekanan" pada GC.

- **String Optimization (Interning):** Lua secara otomatis melakukan ini untuk Kita. Ketika Kita membuat string yang sama beberapa kali, Lua cukup pintar untuk hanya menyimpannya sekali di memori dan membuat semua variabel merujuk ke string yang sama.
  ```lua
  local s1 = "hello world"
  local s2 = "hello" .. " " .. "world"
  -- Walaupun dibuat berbeda, jika isinya sama, Lua mungkin
  -- akan menggunakan objek string yang sama di memori.
  -- Ini mengurangi sampah string.
  ```
- **Table Preallocation (Pra-alokasi Tabel):** Saat Kita menambahkan item ke tabel dalam sebuah loop, Lua mungkin perlu mengubah ukuran array internal tabel beberapa kali. Setiap pengubahan ukuran dapat meninggalkan blok memori lama sebagai sampah. Jika Kita tahu berapa banyak elemen yang akan Kita masukkan, Kita bisa memberitahu Lua sebelumnya.

  ```lua
  -- Buruk: menyebabkan beberapa realokasi
  local t1 = {}
  for i = 1, 1000 do
      t1[i] = i -- Setiap beberapa iterasi, tabel mungkin perlu di-resize
  end

  -- Baik (Lua 5.2+): Hanya satu alokasi besar di awal
  local t2 = table.create(1000, 0) -- Buat tabel dengan ruang untuk 1000 elemen array
  for i = 1, 1000 do
      t2[i] = i
  end
  ```

- **Function Closure Optimization:** Membuat fungsi (closure) di dalam loop menghasilkan objek fungsi baru di setiap iterasi, yang merupakan sampah.

  ```lua
  -- Buruk: Membuat 1000 objek fungsi (closure)
  for i = 1, 1000 do
      local button = createButton({
          onClick = function() print("Clicked", i) end -- Closure baru setiap saat
      })
  end

  -- Baik: Hanya satu fungsi yang dibuat, digunakan kembali
  local function handleClick(button)
      print("Clicked", button.id)
  end

  for i = 1, 1000 do
      local button = createButton({ id = i, onClick = handleClick })
  end
  ```

### 8.2 Custom Memory Allocators

Ini adalah fitur paling canggih untuk kontrol memori. Lua memungkinkan Kita untuk mengganti fungsi alokasi memori defaultnya dengan fungsi Kita sendiri melalui C API `lua_newstate`.

**Kapan ini digunakan?**

- **Integrasi dengan Game Engine:** Jika Kita menyematkan Lua ke dalam game engine C++ yang sudah memiliki _memory manager_-nya sendiri (misalnya, untuk melacak alokasi, mendeteksi kebocoran), Kita dapat memaksa Lua untuk menggunakan manajer tersebut.
- **Debugging:** Kita bisa membuat alokator khusus yang mencatat setiap permintaan alokasi dan dealokasi untuk melacak pola penggunaan memori program Lua Kita secara mendetail.
- **Lingkungan Khusus:** Di beberapa sistem _real-time_ atau _embedded_, memori mungkin perlu dialokasikan dari pool yang sudah ditentukan sebelumnya.

Implementasinya berada di level C dan berada di luar cakupan skrip Lua murni, tetapi penting untuk diketahui bahwa tingkat kontrol ini ada.

---

## Tahap 9: Analisis Kode Sumber dan Detail Implementasi

Untuk pemahaman tertinggi, tidak ada yang mengalahkan membaca kode sumbernya langsung di [repositori GitHub Lua](https://github.com/lua/lua).

### 9.1 Menyelami Kode Sumber Lua

Kita tidak perlu memahami setiap baris, tetapi mengetahui di mana harus mencari akan memberikan pencerahan luar biasa.

- **`lgc.h` dan `lgc.c`:** Ini adalah jantung dari Garbage Collector.
  - `lgc.c` berisi fungsi-fungsi utama seperti `luaC_step` (yang menjalankan satu langkah GC inkremental) dan `luaC_fullgc` (yang menjalankan siklus penuh).
  - Kita akan menemukan implementasi _state machine_ GC di sini (fase-fase seperti `GCSpropagate`, `GCSsweep`, `GCScallfin`).
- **`lobject.h`:** Mendefinisikan struktur dari semua objek di Lua. Perhatikan `GCObject`, header umum yang dimiliki setiap objek yang dapat dikoleksi. Header ini berisi _pointer_ `next` (yang menghubungkan semua objek GC dalam satu daftar) dan `marked` (yang menyimpan warna objek dalam algoritma Tri-Color).
- **`lstate.h`:** Mendefinisikan struktur `global_State`, yang merupakan "otak" dari seluruh state Lua. Struktur ini berisi variabel-variabel yang relevan dengan GC, seperti `g->gcstate` (status GC saat ini), `g->GCthreshold` (kapan harus memulai GC berikutnya), dan `g->allgc` (kepala dari daftar semua objek yang dapat dikoleksi).

Menganalisis file-file ini akan menjawab pertanyaan-pertanyaan seperti, "Bagaimana persisnya Lua melintasi sebuah tabel?" atau "Di mana tepatnya warna objek diubah?".

---

## Tahap 10: Integrasi Ekosistem dan Deployment

GC tidak beroperasi dalam isolasi. Perilakunya dipengaruhi oleh lingkungan tempat ia berjalan.

### 10.1 Pertimbangan GC untuk Framework Spesifik

- **OpenResty / nginx-lua:** Lingkungan ini menangani ribuan permintaan per detik. Jeda GC yang lama dapat secara langsung meningkatkan latensi permintaan. Praktik terbaik di sini meliputi:
  - Sangat agresif dalam mengurangi pembuatan sampah per permintaan.
  - Menggunakan `ngx.timer.at` untuk melakukan pekerjaan pembersihan di latar belakang, di luar siklus permintaan-respons kritis.
  - Berbagi data antar-permintaan dengan hati-hati menggunakan `lua_shared_dict` untuk menghindari pembuatan ulang data yang sama.
- **LÖVE2D / Game Engines:** Masalah utamanya adalah _stutter_ atau penurunan _frame rate_ yang disebabkan oleh jeda GC.
  - _Object pooling_ adalah teknik yang wajib digunakan untuk objek yang sering dibuat/dihancurkan (peluru, partikel, musuh).
  - Secara manual memicu langkah-langkah kecil GC (`collectgarbage("step")`) selama waktu yang tidak kritis (misalnya, menu jeda, layar pemuatan) untuk menyebar beban kerja GC.
- **Redis:** Skrip Lua di Redis harus dieksekusi secepat mungkin karena Redis bersifat _single-threaded_. Skrip yang mengalokasikan banyak memori dan memicu GC dapat memblokir seluruh server Redis. Fokusnya adalah menulis skrip yang sangat efisien dan ramping.

---

## Kesimpulan: Jalan Menuju Penguasaan

Kita telah melihat kurikulum yang membawa Kita dari pertanyaan paling dasar ("Apa itu GC?") hingga analisis tingkat kode sumber dan pertimbangan penerapan di dunia nyata. Jalan menuju penguasaan sejati terletak pada sintesis semua tahapan ini:

1.  **Pahami Fondasi (Tahap 1-2):** Kita tahu _apa_ yang dilakukan GC dan _algoritma_ yang digunakannya.
2.  **Gunakan Fitur dengan Benar (Tahap 3-4):** Kita dapat secara efektif menggunakan alat canggih seperti _weak tables_ dan _finalizers_ untuk mengelola memori dan sumber daya.
3.  **Optimalkan dengan Bijak (Tahap 5-6, 8):** Kita tahu _kapan_ dan _bagaimana_ melakukan intervensi pada perilaku GC, dan yang lebih penting, kapan harus membiarkannya bekerja sendiri, dengan menggunakan pola seperti _object pooling_.
4.  **Kuasai Konteks (Tahap 7, 10):** Kita memahami _trade-off_ desain di baliknya dan bagaimana perilaku GC berubah tergantung pada versi Lua dan lingkungan tempat ia di-deploy.
5.  **Ketahui Kebenaran Mutlak (Tahap 9):** Jika ragu, Kita tahu cara menemukan jawaban pasti dengan membaca kode sumbernya.

Kurikulum ini, yang sekarang telah diisi dengan penjelasan mendetail, memberikan semua yang dibutuhkan. Langkah selanjutnya adalah praktik: tulis kode, ukur penggunaan memori dengan `collectgarbage("count")`, sengaja ciptakan memory leak dan perbaiki, dan bereksperimenlah dengan parameter GC.

**[Semoga berhasil!][semoga]**

[semoga]:../materi/saran/README.md