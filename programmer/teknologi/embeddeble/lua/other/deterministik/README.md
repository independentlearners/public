**Deterministik** dalam pemrograman mengacu pada sifat di mana sebuah fungsi, prosedur, atau sistem selalu menghasilkan **output yang sama** apabila diberikan **input yang sama** dalam kondisi lingkungan yang serupa. Berikut penjelasannya dalam dua konteks:

---

## 1. Deterministik dalam Pemrograman Umum

1. **Definisi**

   - Sebuah fungsi atau algoritme akan dikatakan sebagai _**deterministik**_ jika, setiap kali dipanggil dengan parameter dan kondisi dari lingkungan yang identik, maka akan selalu mengembalikan hasil yang sama
   - Sebaliknya, _non-deterministik_ dapat menghasilkan variasi output meski input-nya sama (misalnya, jika bergantung pada waktu, random tanpa seed tetap, atau operasi paralel tanpa sinkronisasi).

2. **Manfaat**

   - **Reproducibility**: Memudahkan debug dan pengujian (unit test), karena hasil dapat diprediksi
   - **Keamanan & Konsistensi**: Berguna di sistem terdistribusi (blockchain, database ter-replikasi) untuk menjaga integritas data
   - **Optimasi**: Compiler dan runtime dapat melakukan caching atau memoization untuk mempercepat eksekusi

3. **Contoh Sederhana (Pseudocode)**

   ```
   function tambah(a, b):
       return a + b
   ```

   – Pasti deterministik: `tambah(2, 3)` selalu 5

   ```
   function ambilWaktu():
       return sekarang()  // waktu sistem saat ini
   ```

   – Non-deterministik: setiap pemanggilan, meski tanpa parameter, berbeda

---

## 2. Deterministik dalam Pemrograman Lua

Lua, sebagai bahasa skrip ringan, bersifat deterministik **secara default**, kecuali Anda menggunakan elemen yang nondeterministik:

1. **Fungsi Bawaan yang Deterministik**

   - Semua operasi aritmatika (mis. `+`, `-`, `*`, `/`)
   - Manipulasi string murni (mis. `string.sub`, `string.gsub` jika polanya konsisten)
   - Struktur data tabel murni tanpa iterasi acak

2. **Elemen Non-deterministik di Lua**

   - `math.random()` tanpa `math.randomseed(seed)` dapat menghasilkan deret angka acak berbeda setiap eksekusi
   - Akses waktu nyata: `os.time()`, `os.date()`
   - I/O eksternal yang bergantung pada file-system, jaringan, atau input pengguna

3. **Menciptakan Perilaku Deterministik di Lua**

   - **Penetapan Seed**

     ```lua
     math.randomseed(12345)       -- set seed agar random() dapat diprediksi
     print(math.random())         -- selalu menghasilkan urutan yang sama
     ```

   - **Isolasi Lingkungan**

     - Jalankan kode dalam sandbox atau VM terpisah untuk menghindari efek samping global

   - **Pure Function**

     - Hindari penggunaan global state atau variabel luar fungsi yang dapat berubah

4. **Contoh Fungsi Deterministik di Lua**

   ```lua
   -- Fungsi deterministik: hanya operasi murni
   function f(x, y)
     return x * x + y * 2
   end

   print(f(3, 4))  -- selalu 17
   ```

5. **Contoh Potensi Non-Deterministik**

   ```lua
   function g()
     return os.time() + math.random()
   end

   print(g())     -- Bisa berbeda setiap kali dipanggil
   ```

---

**Kesimpulan**
Menjaga determinisme dalam kode mempermudah pengujian, debugging, dan pemeliharaan. Di Lua, Anda cukup menghindari atau mengatur elemen nondeterministik (waktu, random, I/O) untuk memastikan fungsi dan skrip Anda selalu menghasilkan output yang konsisten apabila kondisi input sama.
