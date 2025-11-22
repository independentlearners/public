# **[Bagian 6: Coroutines dan Functions][0]**

Berbeda dengan threading preemptif yang umum di banyak bahasa lain, di mana sistem operasi dapat menghentikan sebuah thread kapan saja, Lua menyediakan _coroutines_ untuk _konkurensi kooperatif_. Ini berarti sebuah tugas (coroutine) hanya akan berhenti dan memberikan kontrol ke tugas lain jika ia secara eksplisit mengizinkannya.

**Daftar Isi Bagian 6:**

- [Dasar-Dasar Coroutine](#61-dasar-dasar-coroutine)
- [Pola Coroutine Tingkat Lanjut dengan Functions](#62-pola-coroutine-tingkat-lanjut-dengan-functions)

---

### 6.1 Dasar-Dasar Coroutine

#### **Membuat Coroutines dengan Functions**

Sebuah coroutine di Lua pada dasarnya adalah sebuah eksekusi dari sebuah function yang dapat dijeda dan dilanjutkan. Anda membuatnya menggunakan `coroutine.create()`.

- **`coroutine.create(f)`**:

  - Menerima sebuah function `f` sebagai argumennya. Function ini akan menjadi "badan" atau "tugas utama" dari coroutine tersebut.
  - Function ini tidak langsung memulai eksekusi `f`.
  - Ia mengembalikan sebuah objek baru dengan tipe `"thread"`, yang merepresentasikan coroutine yang baru dibuat.

- **Contoh Kode:**

  ```lua
  -- Ini adalah function yang akan menjadi badan coroutine
  local function tugasSederhana()
      print("Coroutine: Tugas dimulai.")
      print("Coroutine: Melakukan sesuatu...")
      print("Coroutine: Tugas selesai.")
  end

  -- Membuat coroutine dari function tersebut
  local co = coroutine.create(tugasSederhana)

  print("Tipe dari 'co':", type(co)) -- Output: Tipe dari 'co': thread
  print("Coroutine telah dibuat, tetapi belum berjalan.")
  ```

#### **`yield` dan `resume`**

Ini adalah dua function inti yang mengontrol siklus hidup coroutine. Mereka adalah cara untuk memulai, menjeda, dan melanjutkan eksekusi.

- **`coroutine.resume(co, ...)`**:

  - Memulai atau melanjutkan eksekusi dari coroutine `co`.
  - Nilai kembalian pertamanya adalah sebuah boolean: `true` jika eksekusi berjalan tanpa error, `false` jika ada error.
  - Nilai kembalian berikutnya adalah nilai-nilai yang dilewatkan dari dalam coroutine melalui `coroutine.yield()` atau nilai yang di-_return_ oleh function utama jika coroutine selesai.

- **`coroutine.yield(...)`**:

  - Menjeda (suspends) eksekusi dari coroutine yang sedang berjalan.
  - Hanya bisa dipanggil dari dalam sebuah coroutine.
  - Nilai yang Anda lewatkan ke `yield(...)` akan menjadi nilai kembalian dari `coroutine.resume(...)`.

- **Pertukaran Data Dua Arah:**
  `resume` dan `yield` dapat saling bertukar data.

  - Argumen yang dilewatkan ke `resume` (setelah argumen coroutine itu sendiri) akan menjadi nilai kembalian dari `yield`.
  - Argumen yang dilewatkan ke `yield` akan menjadi nilai kembalian dari `resume`.

- **Contoh Kode:**

  ```lua
  local co = coroutine.create(function(a, b) -- Argumen dari resume pertama
      print("Coroutine dimulai dengan argumen:", a, b)
      local hasilYield1 = coroutine.yield("Hasil pertama") -- Menjeda, mengirim "Hasil pertama"
      print("Coroutine dilanjutkan, menerima:", hasilYield1)
      local hasilYield2 = coroutine.yield("Hasil kedua", "Hasil ketiga")
      print("Coroutine dilanjutkan, menerima:", hasilYield2)
      return "Selesai" -- Nilai return saat coroutine berakhir
  end)

  print("--- Eksekusi 1 ---")
  local sukses, res1 = coroutine.resume(co, "arg1", "arg2")
  print("Resume kembali:", sukses, res1)

  print("\n--- Eksekusi 2 ---")
  local sukses, res2 = coroutine.resume(co, "data untuk yield 1")
  print("Resume kembali:", sukses, res2)

  print("\n--- Eksekusi 3 ---")
  local sukses, res3, res4 = coroutine.resume(co, "data untuk yield 2")
  print("Resume kembali:", sukses, res3, res4)

  print("\n--- Eksekusi 4 ---")
  local sukses, resFinal = coroutine.resume(co) -- Melanjutkan hingga selesai
  print("Resume kembali:", sukses, resFinal)
  ```

#### **Status Coroutine**

Sebuah coroutine selalu berada dalam salah satu dari empat status, yang dapat diperiksa menggunakan `coroutine.status(co)`.

- **`'suspended'`**: Coroutine sedang dijeda. Ini adalah status awalnya setelah dibuat atau setelah memanggil `yield`.
- **`'running'`**: Coroutine sedang dieksekusi saat ini. Sebuah coroutine tidak bisa memeriksa statusnya sendiri karena akan selalu `'running'`.
- **`'normal'`**: Status ini jarang terjadi; ini berarti coroutine aktif tetapi tidak sedang berjalan (misalnya, ia telah me-resume coroutine lain).
- **`'dead'`**: Coroutine telah menyelesaikan tugasnya atau berhenti karena terjadi error. Coroutine yang sudah mati tidak bisa di-_resume_ lagi.

#### **Penanganan Error dalam Coroutines**

Jika terjadi error di dalam sebuah coroutine, error tersebut tidak akan "bocor" dan menghentikan seluruh program. Sebaliknya, eksekusi coroutine akan berhenti, dan `coroutine.resume` akan menangkapnya.

- Pemanggilan `coroutine.resume` yang memicu error akan mengembalikan `false` diikuti dengan pesan errornya.

- Ini membuat `coroutine.resume` sebuah _protected call_, mirip dengan `pcall`.

- **Contoh Kode:**

  ```lua
  local co_error = coroutine.create(function()
      print("Coroutine: akan melakukan pembagian dengan nol...")
      local hasil = 10 / 0
      print("Baris ini tidak akan pernah tercapai.")
  end)

  local sukses, pesanError = coroutine.resume(co_error)
  print("Hasil resume:", sukses)
  print("Pesan Error:", pesanError)
  print("Status coroutine:", coroutine.status(co_error)) -- Output: dead
  ```

---

### 6.2 Pola Coroutine Tingkat Lanjut dengan Functions 

Dengan dasar-dasar tersebut, kita bisa membangun pola-pola yang sangat kuat.

#### **Producer-Consumer**

Ini adalah pola klasik di mana satu coroutine (producer) menghasilkan data dan coroutine lain (consumer) menggunakannya.

- **Contoh Kode:**

  ```lua
  -- Producer: menghasilkan angka dari 1 sampai n
  local function producer(n)
      return coroutine.create(function()
          for i = 1, n do
              coroutine.yield(i) -- Menghasilkan angka i
          end
      end)
  end

  -- Consumer: meminta data dari producer dan mencetaknya
  local function consumer(prod_co)
      while true do
          local sukses, nilai = coroutine.resume(prod_co)
          if not sukses or nilai == nil then -- Berhenti jika coroutine mati atau tidak ada nilai lagi
              break
          end
          print("Menerima:", nilai)
      end
  end

  local p = producer(3)
  consumer(p)
  ```

#### **Generators dan Lazy Iterators**

Coroutines adalah cara yang sangat elegan untuk menulis _generators_ atau _iterator_—function yang menghasilkan serangkaian nilai satu per satu, sesuai permintaan (_on-demand_ atau _lazy_).

- **`coroutine.wrap(f)`**: Ini adalah cara yang lebih sederhana untuk membuat generator. Ia mengembalikan sebuah function yang, setiap kali dipanggil, akan me-_resume_ coroutine. Tidak seperti `resume`, ia tidak mengembalikan status boolean dan akan memunculkan error jika terjadi di dalam coroutine.

- **Contoh Kode:**

  ```lua
  -- Membuat iterator untuk semua permutasi dari sebuah table
  function permutasi(t)
      local function generate(a, n)
          if n == 0 then
              coroutine.yield(a) -- Yield salinan table saat permutasi selesai
          else
              for i = 1, n do
                  a[i], a[n] = a[n], a[i] -- Tukar
                  generate(a, n - 1)
                  a[i], a[n] = a[n], a[i] -- Kembalikan
              end
          end
      end
      return coroutine.wrap(function() generate(t, #t) end)
  end

  -- Menggunakan generator
  local p_gen = permutasi({1, 2, 3})
  for p in p_gen do
      print(table.concat(p, ", "))
  end
  ```

#### **Async Patterns**

Dalam lingkungan seperti server web (OpenResty) atau framework I/O (Luvit), coroutines adalah fondasi untuk pemrograman _asynchronous non-blocking_.

- **Pola:**
  1.  Anda memanggil sebuah function untuk operasi I/O (misalnya, membaca file atau query database).
  2.  Di dalam function tersebut, operasi I/O yang sebenarnya dimulai.
  3.  Function tersebut kemudian memanggil `coroutine.yield()`, menjeda coroutine saat ini dan mengembalikan kontrol ke _event loop_ atau _scheduler_.
  4.  Scheduler dapat menjalankan tugas lain sementara operasi I/O menunggu.
  5.  Ketika operasi I/O selesai, scheduler akan dipanggil (melalui callback), dan ia akan memanggil `coroutine.resume()` pada coroutine yang dijeda, mengirimkan hasil I/O sebagai nilai kembalian dari `yield`.
      Bagi programmer, kodenya terlihat sekuensial dan sinkron, tetapi di balik layar, ia berjalan secara non-blocking.

#### **Perbandingan dengan Python Generators**

- **Symmetric vs. Asymmetric**: Coroutine di Lua disebut _symmetric_. Tidak ada perbedaan fundamental antara `resume` dan `yield`; keduanya hanyalah operasi untuk mentransfer kontrol. Sebaliknya, generator di Python bersifat _asymmetric_: `yield` selalu mentransfer kontrol kembali ke function yang memanggilnya.
- **Yield dari Nested Call**: Di Lua, Anda bisa memanggil `yield` dari dalam function yang dipanggil oleh function utama coroutine (panggilan bersarang).

---

**Sumber Referensi untuk Bagian 6:**

1.  Programming in Lua (4th Edition) - 9. Coroutines: [https://www.lua.org/pil/9.html](https://www.lua.org/pil/9.html)
2.  Lua 5.4 Reference Manual - 2.6 Coroutines: [https://www.lua.org/manual/5.4/manual.html\#2.6](https://www.lua.org/manual/5.4/manual.html#2.6)
3.  Lua-Users Wiki - Coroutines Tutorial: [http://lua-users.org/wiki/CoroutinesTutorial](http://lua-users.org/wiki/CoroutinesTutorial)
4.  Programming in Lua (4th Edition) - 7. Iterators and the Generic for: [https://www.lua.org/pil/7.html](https://www.lua.org/pil/7.html) (Relevan untuk konteks iterator)
5.  Programming in Lua (4th Edition) - 9.3 Coroutines as Iterators: [https://www.lua.org/pil/9.3.html](https://www.lua.org/pil/9.3.html)
6.  Lua-Users Wiki - Lua Coroutines Versus Python Generators: [http://lua-users.org/wiki/LuaCoroutinesVersusPythonGenerators](http://lua-users.org/wiki/LuaCoroutinesVersusPythonGenerators)

---

Kita telah menyelesaikan pembahasan tentang coroutines. Ini adalah topik yang padat tetapi sangat mendasar untuk menulis kode Lua yang efisien dan canggih. Selanjutnya, kita akan beralih ke **Bagian 7: Performance dan Optimization**, di mana kita akan melihat bagaimana pilihan-pilihan desain terkait function dapat memengaruhi kecepatan dan penggunaan memori program Anda.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../bagian-5/README.md
[selanjutnya]: ../bagian-7/README.md

<!----------------------------------------------------->

[0]: ../../function/README.md#bagian-6-coroutines-dan-functions
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
