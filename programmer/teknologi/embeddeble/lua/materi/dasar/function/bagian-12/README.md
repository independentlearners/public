# **[Bagian 12: Custom Iterators dengan Functions][0]**

Bagian ini akan membuka "kotak hitam" dari salah satu fitur Lua yang paling sering digunakan, yaitu `for ... in ... do`, dan menunjukkan bagaimana Anda bisa membuat iterator kustom Anda sendiri menggunakan function.

#

Anda sudah sering menggunakan `for k, v in ipairs(t) do`. Tapi bagaimana sebenarnya cara kerjanya? Dan bagaimana Anda bisa membuat loop `for` Anda sendiri untuk mengiterasi struktur data kustom atau menghasilkan nilai secara dinamis? Bagian ini akan menjawabnya.

**Daftar Isi Bagian 12:**

- [Mekanisme Loop `for` Generik](#121-mekanisme-loop-for-generik)
- [Membuat Iterator Stateless](#122-membuat-iterator-stateless)
- [Membuat Iterator Stateful](#123-membuat-iterator-stateful)

---

### 12.1 Mekanisme Loop `for` Generik

Loop `for` generik di Lua adalah konstruksi yang sangat kuat yang bekerja berdasarkan tiga komponen utama yang disediakan oleh _expression_ setelah keyword `in`.

#### **Anatomi Loop `for` Generik**

Sintaksnya adalah `for <var-list> in <exp-list> do ... end`.
Saat loop dimulai, Lua mengevaluasi `<exp-list>` satu kali. Ekspresi ini diharapkan mengembalikan tiga nilai yang akan mengontrol loop:

1.  **Iterator Function (Fungsi Iterator):** Ini adalah function yang akan dipanggil oleh Lua di setiap iterasi untuk mendapatkan nilai berikutnya.
2.  **Invariant State (State Invarian):** Ini adalah sebuah nilai (seringkali sebuah table) yang akan dilewatkan sebagai argumen _pertama_ ke fungsi iterator di setiap panggilan. Nilai ini tidak pernah diubah oleh loop `for` itu sendiri.
3.  **Initial Control Variable (Variabel Kontrol Awal):** Ini adalah nilai awal yang akan dilewatkan sebagai argumen _kedua_ ke fungsi iterator pada iterasi pertama.

#### **Bagaimana Loop Bekerja**

Loop `for` pada dasarnya adalah "syntactic sugar" untuk loop `while` yang lebih kompleks.
Kode:

```lua
for var_1, ..., var_n in explist do
    -- body
end
```

Secara konseptual, setara dengan:

```lua
do
    local _f, _s, _var = explist
    while true do
        local var_1, ..., var_n = _f(_s, _var)
        if var_1 == nil then
            break
        end
        _var = var_1
        -- body
    end
end
```

**Alur Eksekusi:**

1.  `explist` dievaluasi, menghasilkan fungsi iterator `_f`, state invarian `_s`, dan kontrol awal `_var`.
2.  Di setiap iterasi, fungsi iterator `_f` dipanggil dengan argumen `_s` dan `_var` saat ini.
3.  Hasil dari `_f` di-assign ke variabel loop Anda (`var_1`, ..., `var_n`).
4.  Jika variabel loop pertama (`var_1`) adalah `nil`, loop berhenti.
5.  Jika tidak, nilai dari `var_1` digunakan sebagai nilai `_var` yang baru untuk iterasi berikutnya.
6.  Blok `body` dieksekusi, dan proses berulang.

#### **Contoh: Membedah `ipairs`**

Ketika Anda menulis `for i, v in ipairs(t) do`, `ipairs(t)` mengembalikan tiga nilai:

1.  **Fungsi Iterator:** Sebuah function internal yang melakukan `i = i + 1; v = t[i]; return i, v`.
2.  **State Invarian:** Table `t` itu sendiri.
3.  **Kontrol Awal:** Angka `0`.

Jadi, pada iterasi pertama, Lua memanggil `iterator(t, 0)`. Function ini mengembalikan `1, t[1]`. Karena `1` bukan `nil`, loop berlanjut. `_var` yang baru sekarang adalah `1`. Pada iterasi kedua, Lua memanggil `iterator(t, 1)` dan seterusnya, sampai `t[i]` adalah `nil`.

---

### 12.2 Membuat Iterator Stateless

Sebuah _stateless iterator_ adalah iterator di mana fungsi iteratornya sendiri tidak menyimpan state apa pun di antara panggilan. Semua informasi yang dibutuhkan untuk mendapatkan elemen berikutnya (yaitu state) dilewatkan sebagai argumen (`_s` dan `_var`). `ipairs` adalah contoh klasik dari stateless iterator.

#### **Contoh: Iterator Kata**

Mari kita buat sebuah iterator yang akan mengembalikan setiap kata dari sebuah string.

```lua
-- Factory yang akan menghasilkan 3 nilai untuk loop for
function words(str)
    -- 1. Fungsi iterator
    local iterator = function(s, pos)
        -- string.find akan mencari kata berikutnya mulai dari posisi 'pos'
        local awal, akhir = string.find(s, "%w+", pos)
        if awal then
            return akhir + 1, string.sub(s, awal, akhir) -- Kembalikan posisi baru & katanya
        end
        -- Jika tidak ada kata lagi, kembalikan nil untuk menghentikan loop
    end

    -- 2. State Invarian (string itu sendiri)
    -- 3. Kontrol Awal (posisi awal pencarian)
    return iterator, str, 1
end

local kalimat = "Halo dunia, ini adalah Lua!"
for pos, kata in words(kalimat) do
    print("Ditemukan '" .. kata .. "' yang berakhir di posisi " .. pos)
end
```

- **Penjelasan:**
  - `words(kalimat)` dipanggil sekali, mengembalikan tiga nilai: function `iterator`, string `kalimat`, dan angka `1`.
  - Di setiap iterasi, `iterator` dipanggil dengan `kalimat` dan posisi terakhir. Ia menggunakan `string.find` untuk mencari kata berikutnya dan mengembalikan posisi baru serta kata yang ditemukan.

---

### 12.3 Membuat Iterator Stateful

Sebuah _stateful iterator_ menyimpan state-nya sendiri di dalam dirinya, biasanya menggunakan _upvalues_ dalam sebuah closure. Ini berarti factory function-nya seringkali hanya perlu mengembalikan satu nilai: fungsi iterator itu sendiri.

#### **Menggunakan Closures dan Upvalues**

Karena state (seperti indeks saat ini atau data yang perlu diproses) disimpan sebagai upvalue, fungsi iterator tidak memerlukan argumen `_s` dan `_var` dari loop `for`. Loop `for` akan memanggilnya tanpa argumen, dan closure akan "mengingat" di mana ia berhenti terakhir kali.

- **Contoh: Iterator Elemen Unik**
  Mari kita buat iterator yang mengembalikan elemen unik dari sebuah table, dalam urutan kemunculan pertama.

  ```lua
  function uniqueElements(t)
      -- Upvalues untuk menyimpan state
      local index = 0
      local seen = {} -- Table untuk melacak elemen yang sudah terlihat

      -- Hanya mengembalikan satu nilai: fungsi iterator (closure)
      return function()
          while true do
              index = index + 1
              local value = t[index]
              if value == nil then
                  -- Akhir dari table, hentikan iterasi
                  return nil
              end
              if not seen[value] then
                  -- Ini adalah elemen baru
                  seen[value] = true
                  return value -- Kembalikan nilainya
              end
              -- Jika sudah terlihat, lanjutkan ke iterasi 'while' berikutnya
          end
      end
  end

  local data = {"a", "b", "a", "c", "b", "d", "a"}
  for elem in uniqueElements(data) do
      print(elem)
  end
  -- Output:
  -- a
  -- b
  -- c
  -- d
  ```

#### **Menggunakan Coroutines**

Coroutines menawarkan cara yang seringkali lebih bersih dan lebih mudah dibaca untuk menulis iterator stateful yang kompleks. Anda bisa menggunakan `coroutine.wrap` untuk mengubah sebuah function "generator" menjadi sebuah iterator.

- **Proses:**

  1.  Tulis logika Anda di dalam sebuah function seolah-olah itu adalah proses sekuensial biasa.
  2.  Setiap kali Anda memiliki nilai untuk dikembalikan, panggil `coroutine.yield(nilai)`.
  3.  Bungkus function ini dengan `coroutine.wrap`.
  4.  Hasilnya adalah sebuah iterator yang bisa langsung digunakan dalam loop `for`.

- **Contoh: Iterator Kata dengan Coroutine**

  ```lua
  function words_co(str)
      return coroutine.wrap(function()
          for kata in string.gmatch(str, "%w+") do
              coroutine.yield(kata)
          end
      end)
  end

  local kalimat = "Iterator dengan coroutines jauh lebih mudah!"
  for kata in words_co(kalimat) do
      print(kata)
  end
  ```

  Perhatikan betapa lebih sederhananya kode ini dibandingkan dengan versi stateless. `string.gmatch` sendiri sudah merupakan iterator, tetapi contoh ini menunjukkan betapa mudahnya membungkus logika apa pun dengan `coroutine.wrap`.

---

**Sumber Referensi untuk Bagian 12:**

1.  Programming in Lua (4th Edition) - 7. Iterators and the Generic for: [https://www.lua.org/pil/7.html](https://www.lua.org/pil/7.html)
2.  Lua 5.4 Reference Manual - 3.3.5 The Generic for Statement: [https://www.lua.org/manual/5.4/manual.html\#3.3.5](https://www.lua.org/manual/5.4/manual.html#3.3.5)
3.  Lua-Users Wiki - Iterators Tutorial: [http://lua-users.org/wiki/IteratorsTutorial](http://lua-users.org/wiki/IteratorsTutorial)
4.  Programming in Lua (4th Edition) - 9.3 Coroutines as Iterators: [https://www.lua.org/pil/9.3.html](https://www.lua.org/pil/9.3.html)
5.  Lua-Users Wiki - Stateless vs. Stateful Iterators: [http://lua-users.org/wiki/StatelessIterators](https://www.google.com/search?q=http://lua-users.org/wiki/StatelessIterators)

---

Kita telah menyelesaikan Bagian 12. Anda sekarang memiliki kemampuan untuk tidak hanya menggunakan loop `for` generik tetapi juga untuk membuatnya sendiri, membuka banyak kemungkinan untuk abstraksi data.

#

Masih tersisa satu bagian terakhir dari kurikulum ini: **Bagian 13: Sandboxing dan Secure Environments**. Ini adalah topik penting tentang keamanan saat menjalankan kode yang tidak tepercaya.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../README.md
[kurikulum]: ../../../README.md
[sebelumnya]: ../bagian-11/README.md
[selanjutnya]: ../bagian-13/README.md

<!----------------------------------------------------->

[0]: ../../function/README.md#bagian-12-generic-for-loop-dan-custom-iterators
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
