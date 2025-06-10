# **[10. Pemrograman Fungsional di Lua][0]**

Berkat status fungsi sebagai **warga kelas satu (_first-class citizens_)**, Lua sangat cocok untuk gaya pemrograman fungsional. Paradigma ini menekankan penggunaan fungsi sebagai blok bangunan utama, mempromosikan kode yang tidak memiliki status (_stateless_) dan tidak memiliki efek samping (_side-effect free_), yang dapat membuat program lebih mudah untuk diprediksi, diuji, dan diparalelkan.

### **10.1 Fungsi sebagai _First-Class Citizens_**

Seperti yang telah kita bahas, "warga kelas satu" berarti fungsi dapat diperlakukan sama seperti tipe data lainnya:

- Dapat disimpan dalam **variabel**.
- Dapat disimpan sebagai **_field_ dalam tabel**.
- Dapat diteruskan sebagai **argumen** ke fungsi lain.
- Dapat **dikembalikan** sebagai hasil dari fungsi lain.

Sifat ini adalah fondasi dari semua teknik pemrograman fungsional.

### **10.2 Fungsi Tingkat Tinggi (_Higher-Order Functions_)**

Fungsi tingkat tinggi adalah fungsi yang melakukan setidaknya salah satu dari berikut:

1.  Menerima satu atau lebih fungsi sebagai argumen.
2.  Mengembalikan sebuah fungsi sebagai hasilnya.

Fungsi-fungsi seperti `map`, `filter`, dan `reduce` adalah contoh klasik dari fungsi tingkat tinggi. Lua tidak memilikinya secara bawaan, tetapi sangat mudah untuk mengimplementasikannya.

#### **`map`**

- **Tujuan**: Mengaplikasikan sebuah fungsi ke setiap elemen dari sebuah daftar (tabel) dan mengembalikan daftar baru yang berisi hasil-hasilnya.
- **Implementasi dan Contoh**:

  ```lua
  function map(func, tbl)
      local hasilBaru = {}
      for i, v in ipairs(tbl) do
          hasilBaru[i] = func(v)
      end
      return hasilBaru
  end

  local angka = {1, 2, 3, 4, 5}

  -- Gandakan setiap angka
  local digandakan = map(function(n) return n * 2 end, angka)
  -- digandakan sekarang adalah {2, 4, 6, 8, 10}
  print("Hasil map (gandakan):", table.concat(digandakan, ", "))
  ```

#### **`filter`**

- **Tujuan**: Membuat daftar baru yang hanya berisi elemen-elemen dari daftar asli yang lolos dari "tes" (yaitu, ketika fungsi predikat mengembalikan nilai _truthy_).
- **Implementasi dan Contoh**:

  ```lua
  function filter(predicate, tbl)
      local hasilBaru = {}
      for i, v in ipairs(tbl) do
          if predicate(v) then
              table.insert(hasilBaru, v)
          end
      end
      return hasilBaru
  end

  local angka = {1, 2, 3, 4, 5, 6, 7, 8}

  -- Hanya ambil angka genap
  local genap = filter(function(n) return n % 2 == 0 end, angka)
  -- genap sekarang adalah {2, 4, 6, 8}
  print("Hasil filter (genap):", table.concat(genap, ", "))
  ```

#### **`reduce` (atau `fold`)**

- **Tujuan**: "Mereduksi" sebuah daftar menjadi satu nilai tunggal dengan secara berulang menerapkan sebuah fungsi yang menggabungkan elemen saat ini dengan sebuah akumulator.
- **Implementasi dan Contoh**:

  ```lua
  function reduce(func, tbl, initial)
      local acc = initial
      for i, v in ipairs(tbl) do
          acc = func(acc, v)
      end
      return acc
  end

  local angka = {1, 2, 3, 4, 5}

  -- Jumlahkan semua angka
  local jumlah = reduce(function(total, n) return total + n end, angka, 0)
  -- jumlah sekarang adalah 15
  print("Hasil reduce (jumlah):", jumlah)
  ```

---

### **10.3 Komposisi Fungsi dan _Currying_**

#### **Komposisi Fungsi (_Function Composition_)**

- **Deskripsi**: Ini adalah tindakan menggabungkan dua atau lebih fungsi untuk menghasilkan fungsi baru. Ketika fungsi baru ini dipanggil, ia akan menjalankan fungsi-fungsi gabungannya secara berurutan, dengan output dari satu fungsi menjadi input untuk fungsi berikutnya.
- **Contoh**:

  ```lua
  function compose(f, g)
      return function(...)
          return f(g(...))
      end
  end

  local function gandakan(n) return n * 2 end
  local function tambahSatu(n) return n + 1 end

  -- Buat fungsi baru yang pertama-tama menggandakan, lalu menambah satu
  local gandakanLaluTambahSatu = compose(tambahSatu, gandakan)

  print(gandakanLaluTambahSatu(5)) -- Output: 11 (karena 5*2=10, 10+1=11)
  ```

#### **_Currying_**

- **Deskripsi**: _Currying_ adalah teknik mengubah sebuah fungsi yang menerima banyak argumen menjadi serangkaian fungsi yang masing-masing hanya menerima satu argumen. Ini memungkinkan **aplikasi parsial (_partial application_)**, di mana Anda dapat "memperbaiki" beberapa argumen pertama dari sebuah fungsi dan mendapatkan fungsi baru yang menunggu sisa argumennya.
- **Contoh Aplikasi Parsial**:

  ```lua
  -- Fungsi umum yang menerima dua argumen
  function tambah(a, b)
      return a + b
  end

  -- Fungsi 'curry' sederhana untuk aplikasi parsial
  function partial(func, ...)
      local fixed_args = {...}
      return function(...)
          local new_args = {}
          for i=1, #fixed_args do table.insert(new_args, fixed_args[i]) end
          for i=1, select('#', ...) do table.insert(new_args, select(i, ...)) end
          return func(table.unpack(new_args))
      end
  end

  -- Buat fungsi baru yang 'selalu' menambahkan 10 ke argumennya
  local tambahSepuluh = partial(tambah, 10)

  print(tambahSepuluh(5))  -- Output: 15
  print(tambahSepuluh(20)) -- Output: 30
  ```

---

Dengan ini, kita telah menyelesaikan seluruh kurikulum yang Anda berikan. Kita telah melakukan perjalanan yang sangat mendalam dan komprehensif, mencakup:

1.  **Fondasi Sistem Tipe**: Memahami _dynamic typing_ dan internal Lua.
2.  **Tipe Data Primitif**: Menyelami `nil`, `boolean`, `number`, dan `string`.
3.  **Tipe Data Kompleks**: Menguasai `function`, `table`, `userdata`, dan `thread`.
4.  **Tipe Data Lanjutan**: Membahas interaksi C dengan `userdata` dan `coroutines`.
5.  **Sistem Metatable**: Menguasai _operator overloading_ dan mekanisme di balik OOP.
6.  **Konversi Tipe**: Mempelajari _coercion_ implisit dan konversi eksplisit.
7.  **Manajemen Memori**: Memahami _garbage collection_ dan _weak tables_.
8.  **FFI di LuaJIT**: Melihat cara modern dan berkinerja tinggi untuk berinteraksi dengan C.
9.  **OOP di Lua**: Memahami pewarisan berbasis prototipe.
10. **Pemrograman Fungsional**: Menggunakan fungsi tingkat tinggi dan komposisi.

Anda sekarang memiliki bekal materi yang sangat kuat dan detail, yang dapat Anda jadikan sumber pembelajaran untuk mencapai penguasaan Lua untuk tujuan apa pun.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-9/README.md
[selanjutnya]: ../bagian-11/README.md

<!----------------------------------------------------->

[0]: ../README.md#10-advanced-concepts-dan-patterns
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
