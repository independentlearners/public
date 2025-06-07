# **[Bagian 7: Performance dan Optimization][0]**

Memahami implikasi performa dari berbagai pola function adalah kunci untuk menulis aplikasi Lua yang berskala besar dan berkinerja tinggi. Bagian ini akan membahas di mana saja potensi bottleneck (hambatan) bisa muncul dan bagaimana cara mengatasinya.

**Aturan Emas Optimasi:** Jangan melakukan optimasi prematur. Tulis kode yang bersih dan benar terlebih dahulu. Kemudian, jika performa menjadi masalah, gunakan *profiler* untuk menemukan bagian kode mana yang lambat (bottleneck) dan fokuskan usaha optimasi Anda di sana.

**Daftar Isi Bagian 7:**

  * [Performa Function](https://www.google.com/search?q=%23function-performance)
  * [Manajemen Memori](https://www.google.com/search?q=%23memory-management)

-----

### 7.1 Performa Function {https://www.google.com/search?q=%23function-performance}

#### **Function Call Overhead (Biaya Pemanggilan Function)**

Setiap kali Anda memanggil sebuah function, ada sedikit biaya (overhead) yang terkait. Untuk sebagian besar aplikasi, biaya ini dapat diabaikan. Namun, jika sebuah function yang sangat sederhana dipanggil ribuan atau jutaan kali di dalam sebuah loop yang ketat (tight loop), biaya ini bisa terakumulasi.

  * **Kapan perlu diperhatikan:** Dalam loop yang sangat kritis terhadap performa.
  * **Solusi (jika benar-benar diperlukan):** *Inlining* manual, yaitu menyalin isi dari function tersebut langsung ke dalam loop untuk menghindari biaya pemanggilan.
    ```lua
    -- Versi dengan function call
    local function tambahDua(n) return n + 2 end
    for i = 1, 1000000 do
        local x = tambahDua(i)
    end

    -- Versi inlined (bisa lebih cepat dalam kasus ekstrim)
    for i = 1, 1000000 do
        local x = i + 2
    end
    ```

#### **Local vs. Global Function Performance**

Ini adalah salah satu tips optimasi paling penting dan mudah diterapkan di Lua. **Mengakses variabel lokal jauh lebih cepat daripada mengakses variabel global.**

  * **Mengapa Lokal Lebih Cepat:**

      * **Variabel Lokal:** Diterjemahkan menjadi akses langsung ke register atau posisi di stack virtual machine Lua. Ini adalah operasi yang sangat cepat.
      * **Variabel Global:** Sebenarnya disimpan dalam sebuah table biasa bernama `_G`. Ketika Anda memanggil `print("halo")`, Lua sebenarnya melakukan `_G.print("halo")`. Ini melibatkan pencarian hash table, yang lebih lambat daripada akses stack langsung.

  * **Tips Optimasi:**
    Jika Anda perlu menggunakan function atau variabel global berulang kali di dalam loop, "lokalkan" terlebih dahulu di luar loop.

    ```lua
    -- Lambat
    for i = 1, 1000000 do
        table.insert(myTable, i) -- Setiap iterasi mencari 'table' di _G
    end

    -- Cepat
    local t_insert = table.insert -- Akses global sekali, simpan di lokal
    for i = 1, 1000000 do
        t_insert(myTable, i) -- Akses lokal yang sangat cepat
    end
    ```

    Hal yang sama berlaku untuk function yang Anda definisikan: selalu gunakan `local function` kecuali Anda punya alasan kuat untuk membuatnya global.

#### **Upvalue Access Performance**

Bagaimana dengan upvalue (variabel lokal dari scope luar yang diakses oleh closure)?

  * **Kecepatan Akses:** Akses ke upvalue berada di antara lokal dan global. Lebih lambat dari akses lokal, tetapi masih lebih cepat dari akses global. Ini karena akses upvalue memerlukan satu tingkat *indirection* (penunjuk tidak langsung) tambahan dibandingkan akses lokal.

#### **Tail Call Optimization (TCO)**

Seperti yang dibahas sebelumnya, TCO adalah fitur performa yang penting.

  * **Implikasi Performa:** Dengan menghilangkan pembuatan stack frame baru untuk *tail call*, TCO memungkinkan penggunaan gaya rekursif tanpa risiko *stack overflow* dan tanpa biaya performa yang terkait dengan alokasi dan dealokasi stack frame. Ini membuat beberapa algoritma rekursif sama efisiennya dengan versi iteratif (loop).

-----

### 7.2 Manajemen Memori {https://www.google.com/search?q=%23memory-management}

Lua menggunakan *Garbage Collector* (GC) otomatis untuk mengelola memori. Anda tidak perlu secara manual mengalokasikan atau membebaskan memori untuk objek seperti table atau function. Namun, cara Anda menggunakan function dapat memengaruhi seberapa keras GC harus bekerja.

#### **Function Memory Usage**

Setiap kali Anda mendefinisikan sebuah function, Lua membuat objek function baru yang menggunakan memori.

  * **Masalah Umum:** Membuat function di dalam loop adalah praktik yang buruk dari segi performa. Ini akan membuat objek function baru pada setiap iterasi, yang kemudian harus dibersihkan oleh GC.

    ```lua
    -- Buruk: membuat function anonim di setiap iterasi
    for i = 1, 100 do
        local btn = Button:new{
            onClick = function() print(i) end -- Membuat closure baru setiap kali
        }
    end

    -- Lebih Baik: definisikan function di luar loop
    local function cetakNilai(nilai)
        return function()
            print(nilai)
        end
    end
    for i = 1, 100 do
        local btn = Button:new{
            onClick = cetakNilai(i) -- Tetap membuat closure, tapi lebih eksplisit
        }
    end
    ```

    *Catatan: Contoh di atas masih membuat closure baru. Dalam kasus nyata, Anda mungkin akan melewatkan `i` sebagai argumen ke `onClick` jika API mengizinkannya, untuk menghindari pembuatan closure sama sekali.*

#### **Closure Memory Implications**

Ini adalah poin yang sangat penting. Sebuah closure menjaga referensi ke semua upvalue-nya tetap "hidup".

  * **Konsekuensi:** Selama sebuah closure masih dapat dijangkau oleh program Anda, semua upvalue yang dirujuknya (dan semua objek yang dirujuk oleh upvalue tersebut) **tidak dapat** di-garbage collect.
  * **Potensi Kebocoran Memori (Memory Leak):** Jika Anda secara tidak sengaja menyimpan sebuah closure yang merujuk pada upvalue besar (misalnya, table yang berisi banyak data) dalam sebuah variabel yang berumur panjang (seperti variabel global atau modul), maka data besar tersebut tidak akan pernah dibersihkan dari memori, bahkan jika sisa program tidak lagi membutuhkannya.

#### **Weak References dengan Functions**

Terkadang, Anda ingin menyimpan referensi ke sebuah objek tanpa mencegahnya di-garbage collect. Di sinilah *weak tables* berperan.

  * **Weak Table:** Sebuah table yang referensinya ke kunci atau nilainya (atau keduanya) bersifat "lemah". Jika satu-satunya referensi yang tersisa ke sebuah objek adalah dari weak table, GC bebas untuk menghapus objek tersebut.

  * **`__mode` Metamethod:** Anda membuat sebuah table menjadi weak dengan mengatur field `__mode` di metatable-nya.

      * `__mode = "k"`: Kunci (keys) bersifat lemah.
      * `__mode = "v"`: Nilai (values) bersifat lemah.
      * `__mode = "kv"`: Keduanya bersifat lemah.

  * **Penggunaan dengan Functions:**
    Anda dapat menggunakan weak table untuk mengaitkan data dengan function tanpa mencegah function tersebut di-garbage collect. Contohnya adalah membuat cache memoization di mana Anda tidak ingin cache tersebut menahan function selamanya.

    ```lua
    local cache = {}
    local mt = {__mode = "k"} -- Kunci (yaitu function) bersifat lemah
    setmetatable(cache, mt)

    function panggilDanCache(f, ...)
        local hasil = cache[f]
        if not hasil then
            hasil = f(...)
            cache[f] = hasil
        end
        return hasil
    end

    local func_A = function() return "A" end
    panggilDanCache(func_A)

    -- Setelah func_A tidak lagi direferensikan di tempat lain
    -- dan GC berjalan, entri { [func_A] = "A" } akan
    -- secara otomatis dihapus dari 'cache'.
    func_A = nil
    ```

-----

**Sumber Referensi untuk Bagian 7:**

1.  Lua-Users Wiki - Lua Performance Tips: [http://lua-users.org/wiki/OptimisationTips](http://lua-users.org/wiki/OptimisationTips)
2.  Programming in Lua (1st Edition) - 25. Performance Tips: [https://www.lua.org/pil/25.html](https://www.lua.org/pil/25.html)
3.  Programming in Lua (1st Edition) - 17. Garbage Collection: [https://www.lua.org/pil/17.html](https://www.lua.org/pil/17.html)
4.  Lua 5.4 Reference Manual - 2.5 Garbage Collection: [https://www.lua.org/manual/5.4/manual.html\#2.5](https://www.lua.org/manual/5.4/manual.html#2.5)

-----

Kita telah menyelesaikan Bagian 7 tentang performa. Ingatlah bahwa kode yang jelas biasanya lebih penting daripada optimasi mikro, tetapi memahami prinsip-prinsip ini sangat berharga ketika Anda menghadapi bottleneck. Selanjutnya, kita akan membahas **Bagian 8: Advanced Function Techniques**, di mana kita akan melihat beberapa teknik yang sangat canggih seperti komposisi function dan metaprogramming. 


#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../bagian-6/README.md
[selanjutnya]: ../bagian-8/README.md

<!----------------------------------------------------->

[0]: ../../function/README.md#bagian-7-performance-dan-optimization
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