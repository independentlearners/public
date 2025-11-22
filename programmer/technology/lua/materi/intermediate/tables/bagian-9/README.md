# **[BAGIAN 9: ADVANCED METATABLES][0]**

Anda telah menguasai komponen-komponen individu dari metatables. Sekarang saatnya merakitnya menjadi mekanisme yang lebih canggih dan elegan. Pada bagian ini adalah tentang bagaimana menggunakan metamethods—terutama `__index` dan `__newindex`—tidak hanya sebagai fitur tunggal, tetapi sebagai bagian dari desain yang kohesif untuk menciptakan tipe data kustom yang kuat dan intuitif.

💡 **Deskripsi Konsep**
Pada tahap ini, kita beralih dari sekadar mengetahui *apa itu* metamethods menjadi memahami *bagaimana cara menggunakannya* secara kreatif. "Advanced Metatables" adalah tentang menggabungkan beberapa metamethod untuk membangun table yang perilakunya terkontrol sepenuhnya, meniru fitur dari bahasa lain seperti *operator overloading* dan *properties*.

---

### **1. Operator Overloading dengan Tables**

💡 **Deskripsi Konsep**
**Operator Overloading** adalah praktik mendefinisikan ulang cara kerja operator standar (`+`, `*`, `==`, `..`, dll.) untuk tipe data kustom. Tujuannya adalah untuk membuat kode lebih ekspresif dan mudah dibaca. Daripada menulis `result = Money.add(m1, m2)`, Anda bisa menulis `result = m1 + m2`, yang jauh lebih alami.

Ini pada dasarnya adalah aplikasi praktis dari metamethod aritmatika dan relasional yang kita pelajari di Bagian 6, tetapi dilihat dari perspektif desain.

**Contoh Kode 26: Membuat Tipe Data `Money` dengan Operator Overloading**
Kita akan membuat "objek" `Money` yang menyimpan jumlah dan mata uang. Kita akan mendefinisikan aturan untuk operasi matematika padanya.

```lua
local Money = {}
Money.mt = {
    -- Penjumlahan: hanya bisa jika mata uang sama
    __add = function(m1, m2)
        if m1.currency ~= m2.currency then
            error("Tidak bisa menjumlahkan mata uang yang berbeda: " .. m1.currency .. " dan " .. m2.currency)
        end
        return Money.new(m1.amount + m2.amount, m1.currency)
    end,

    -- Perkalian: hanya bisa dengan angka (scalar)
    __mul = function(m, scalar)
        if type(scalar) ~= "number" then
            error("Hanya bisa mengalikan Uang dengan angka.")
        end
        return Money.new(m.amount * scalar, m.currency)
    end,

    -- Kesetaraan: jumlah dan mata uang harus sama
    __eq = function(m1, m2)
        return m1.currency == m2.currency and m1.amount == m2.amount
    end,

    -- Representasi String
    __tostring = function(m)
        return string.format("%s %.2f", m.currency, m.amount)
    end
}

function Money.new(amount, currency)
    return setmetatable({amount = amount, currency = currency}, Money.mt)
end

-- --- CONTOH PENGGUNAAN ---
local gaji = Money.new(5000, "USD")
local bonus = Money.new(1500, "USD")
local tunjangan_idr = Money.new(1000000, "IDR")

local total_usd = gaji + bonus -- Memanggil __add
print("Total Pendapatan:", total_usd) -- Memanggil __tostring. Output: Total Pendapatan: USD 6500.00

local gaji_setelah_pajak = total_usd * 0.9 -- Memanggil __mul
print("Setelah Pajak:", gaji_setelah_pajak) -- Output: Setelah Pajak: USD 5850.00

local gaji_sama = Money.new(5000, "USD")
print("Apakah gaji sama?", gaji == gaji_sama) -- Memanggil __eq. Output: Apakah gaji sama?: true

-- Ini akan menghasilkan error, seperti yang kita inginkan
-- local total_campuran = gaji + tunjangan_idr
```

---

### **2. Custom Indexing dan Property Access**

💡 **Deskripsi Konsep**
Ini adalah penggunaan `__index` dan `__newindex` yang lebih canggih. Daripada hanya menunjuk ke table lain untuk pewarisan, kita bisa membuatnya menunjuk ke **fungsi**. Ini memberi kita kontrol total atas apa yang terjadi saat seseorang mencoba membaca atau menulis properti pada objek kita.

Ini memungkinkan kita untuk membuat:
* **Computed Properties**: Properti yang nilainya dihitung saat diakses, bukan disimpan di memori.
* **Read-only Properties**: Properti yang tidak dapat diubah setelah objek dibuat.
* **Property Validation**: Memastikan nilai yang diberikan ke sebuah properti valid sebelum disimpan.
* **Logging/Debugging**: Mencatat setiap kali properti diakses atau diubah.

**Contoh Kode 27: Melengkapi Tipe `Money` dengan Properti Kustom**
Kita akan membuat properti `currency` menjadi read-only dan menambahkan properti komputasi `is_debt`.

```lua
-- Kita modifikasi metatable Money dari contoh sebelumnya
Money.mt.__index = function(m, key)
    -- Cek apakah kita mengakses 'computed property'
    if key == "is_debt" then
        return m.amount < 0
    else
        -- Jika tidak, ini mungkin metode yang diwariskan (jika ada)
        -- Untuk saat ini kita kembalikan nil saja
        return nil
    end
end

Money.mt.__newindex = function(m, key, value)
    -- Mencegah perubahan pada 'currency'
    if key == "currency" then
        error("Properti 'currency' adalah read-only.", 2)
    end

    -- Untuk properti lain, izinkan perubahan
    -- PENTING: Gunakan rawset untuk menghindari loop tak terbatas!
    rawset(m, key, value)
end

-- --- CONTOH PENGGUNAAN ---
local hutang = Money.new(-200, "EUR")
local tabungan = Money.new(1000, "EUR")

-- Mengakses computed property 'is_debt'
print("Apakah " .. tostring(hutang) .. " adalah hutang?", hutang.is_debt)   -- Output: true
print("Apakah " .. tostring(tabungan) .. " adalah hutang?", tabungan.is_debt) -- Output: false

-- Memodifikasi properti yang diizinkan ('amount')
print("\nNominal tabungan awal:", tabungan)
tabungan.amount = 1200 -- Diizinkan oleh __newindex
print("Nominal tabungan baru:", tabungan)

-- Mencoba memodifikasi properti read-only ('currency')
print("\nMencoba mengubah mata uang...")
-- Baris berikut akan menghasilkan error: "Properti 'currency' adalah read-only."
-- tabungan.currency = "JPY"
```

**Penjelasan Per-Sintaksis Penting:**
* `__index = function(m, key)`: Ketika kode mencoba mengakses `hutang.is_debt`, Lua tidak menemukan kunci `"is_debt"` di dalam table `hutang`. Lua lalu memanggil fungsi `__index` ini. Fungsi kita memeriksa apakah `key` yang diminta adalah `"is_debt"`. Jika ya, ia menghitung dan mengembalikan hasilnya.
* `__newindex = function(m, key, value)`: Ketika kode mencoba `tabungan.currency = "JPY"`, Lua tidak menemukan kunci `"currency"` (ini adalah aturan untuk `__newindex` untuk dipicu). Fungsi `__newindex` kita dipanggil. Ia memeriksa apakah `key` adalah `"currency"`, dan jika ya, ia memanggil `error()`.
* `rawset(m, key, value)`: Di dalam `__newindex`, setelah kita selesai dengan validasi, kita perlu cara untuk benar-benar menetapkan nilainya. Jika kita hanya menulis `m[key] = value`, itu akan memicu `__newindex` lagi, menyebabkan **loop tak terbatas** dan crash. `rawset` adalah fungsi "mentah" yang kita pelajari di Bagian 3; ia menetapkan nilai secara langsung, **mengabaikan** metatable, sehingga mencegah loop.

---

Dengan menggabungkan pola-pola ini, Anda dapat menciptakan abstraksi yang sangat kuat, aman, dan mudah digunakan di Lua, yang perilakunya didefinisikan dengan baik dan terlindungi dari penggunaan yang tidak disengaja. Ini adalah jembatan yang sempurna menuju topik berikutnya yaitu materi **"10. OBJECT-ORIENTED PROGRAMMING DENGAN TABLES"**. Semua yang baru saja kita lakukan—membuat "objek" dengan data, metode, dan properti yang terkontrol—adalah fondasi dari OOP di Lua.


#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-8/README.md
[selanjutnya]: ../bagian-10/README.md

<!----------------------------------------------------->

[0]: ../README.md#9-advanced-metatables
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
