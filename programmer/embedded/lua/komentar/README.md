### **1. Dasar Komentar**

Komentar digunakan untuk menjelaskan kode atau menonaktifkan bagian kode sementara.

#### **a. Komentar Satu Baris**

- Dimulai dengan `--`.
- Contoh:
  ```lua
  -- Ini adalah komentar satu baris
  print("Hello, World!")  -- Komentar di akhir baris
  ```

#### **b. Komentar Multi-Baris (Blok)**

- Menggunakan `--[[` untuk membuka dan `]]` untuk menutup.
- Contoh:
  ```lua
  --[[
    Ini adalah komentar multi-baris.
    Kode di dalamnya tidak akan dieksekusi.
  ]]
  ```

---

### **2. Komentar Multi-Baris dengan Penyesuaian Tanda Sama Dengan (`=`)**

Lua memungkinkan penggunaan tanda `=` di dalam kurung siku untuk menghindari konflik dengan teks yang mengandung `]]`.

#### **a. Sintaks Umum**

- Format: `--[===[ ... ]===]` (jumlah `=` bisa berapa saja, asalkan sama di awal dan akhir).
- Contoh:
  ```lua
  --[===[
    Komentar ini aman meskipun mengandung karakter seperti `]]` atau `[[`.
  ]===]
  ```

#### **b. Penggunaan untuk Nested Comments**

- Berguna jika komentar mengandung string yang mirip dengan penutup komentar.
- Contoh:
  ```lua
  --[==[
    print("Contoh teks dengan ]] di dalam komentar")
  ]==]
  ```

---

### **3. Perbedaan Komentar Lua vs. Terminal (Shell Script)**

#### **a. Komentar di Terminal (Bash/Shell)**

- Menggunakan `#` untuk komentar satu baris.
- Tidak ada sintaks resmi untuk komentar multi-baris (biasanya menggunakan trik seperti `: << 'COMMENT'`).
- Contoh:
  ```bash
  # Ini komentar di bash
  echo "Hello"  # Komentar di akhir baris
  ```

#### **b. Komentar di Lua**

- Menggunakan `--` untuk satu baris dan `--[[ ... ]]` untuk multi-baris.
- Lebih terstruktur dengan dukungan multi-baris resmi.
- Contoh:
  ```lua
  --[[
    Komentar multi-baris di Lua.
  ]]
  ```

---

### **4. Konsep Khusus Komentar dalam Lua**

#### **a. Toggle Komentar Blok dengan `---`**

- Teknik untuk mengaktifkan/menonaktifkan blok kode dengan menambahkan/ menghilangkan `-`.
- Contoh:
  ```lua
  ---[[
  print("Kode ini TIDAK dikomentari karena ---[[ dianggap komentar satu baris!")
  --]]
  ```
  Jika diubah menjadi `--[[`, blok akan dikomentari.

#### **b. Komentar Dokumentasi (Doc Comments)**

- Konvensi untuk dokumentasi menggunakan `---` (tiga tanda hubung).
- Digunakan oleh alat seperti **LDoc**.
- Contoh:
  ```lua
  --- Menambahkan dua angka.
  -- @param a angka pertama
  -- @param b angka kedua
  -- @return hasil penjumlahan
  function add(a, b)
      return a + b
  end
  ```

---

### **5. Best Practices Komentar**

1. **Komentar Jelas dan Singkat**:

   - Jelaskan "mengapa", bukan "apa" (kode sudah menjelaskan "apa").
   - Contoh buruk:
     ```lua
     -- Menambahkan 1 ke x
     x = x + 1
     ```
   - Contoh baik:
     ```lua
     -- Increment x untuk menghindari nilai nol
     x = x + 1
     ```

2. **Hindari Komentar Redundan**:

   - Tidak perlu menjelaskan kode yang sudah jelas.

3. **Gunakan Komentar untuk Menonaktifkan Kode Sementara**:
   ```lua
   --[[
   print("Kode ini dinonaktifkan untuk debugging")
   ]]
   ```

---

### **6. Contoh Lengkap Implementasi**

```lua
-- Program menghitung faktorial

--- Menghitung faktorial dari suatu angka.
-- @param n angka input (bilangan bulat)
-- @return hasil faktorial
function factorial(n)
    if n == 0 then
        return 1
    else
        return n * factorial(n - 1)
    end
end

--[[
  Contoh penggunaan:
  print(factorial(5))  -- Output: 120
]]

---[[
  Uncomment blok ini untuk testing:
  print(factorial(3))  -- Output: 6
]]
```

---

### **7. Kesimpulan**

- **Komentar Satu Baris**: `--`.
- **Komentar Multi-Baris**: `--[[ ... ]]` atau `--[===[ ... ]===]`.
- **Perbedaan dengan Terminal**: Lua menggunakan `--`, sedangkan shell menggunakan `#`.
- **Konsep Khusus**:
  - Toggle komentar dengan `---[[`.
  - Komentar dokumentasi dengan `---`.
- **Best Practices**: Komentar untuk klarifikasi, dokumentasi, dan debugging.
