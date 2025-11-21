# [Modul 4 — Math Library (`math`)][0]

Modul ini fokus pada fungsi-fungsi matematika bawaan Lua, yang sangat berguna baik untuk perhitungan sederhana maupun fondasi logika pemrograman yang lebih kompleks (misalnya algoritme, simulasi, atau grafika).

<details>
  <summary>📃 Daftar Isi</summary>

---

### Struktur Pembelajaran Internal (mini-TOC)

* **4.1 Pengenalan Math Library**

  * Konsep dasar numerik di Lua
  * Tipe number (integer & float)
  * Filosofi desain: kesederhanaan berbasis C
* **4.2 Fungsi Dasar**

  * floor, ceil, abs, sqrt, max, min
  * random, randomseed
* **4.3 Fungsi Lanjutan**

  * log, exp, pow
  * trigonometri (sin, cos, tan, atan, rad, deg)
  * konstanta `math.pi`, `math.huge`
* **4.4 Studi Kasus**

  * Kalkulator sederhana
  * Generator dadu (random)
  * Konversi koordinat sudut (deg ↔ rad)
* Latihan & kuiz
* Praktik terbaik & kesalahan umum
* Visualisasi

</details>

---

## 4.1 Pengenalan Math Library

### Deskripsi & Peran

Math library menyediakan fungsi standar untuk operasi matematika. Lua tidak punya tipe numerik terpisah seperti `int` dan `float` di banyak bahasa lain. Sebaliknya:

* **Lua 5.3+** mengenalkan **integer** dan **float** (double precision).
* **Math library** sebagian besar beroperasi pada float.

Peran: sangat penting untuk logika algoritmik, perhitungan fisika, statistik, simulasi, hingga pemrosesan grafis.

### Filosofi

* Lua membungkus fungsi C math.h → sederhana dan portabel.
* Tidak ada kelebihan fitur (mis. BigInt bawaan); untuk kebutuhan itu gunakan ekstensi.

### Sintaks dasar

```lua
print(math.sqrt(16))     -- 4
print(math.floor(3.9))   -- 3
print(math.ceil(3.1))    -- 4
print(math.abs(-5))      -- 5
```

---

## 4.2 Fungsi Dasar

### floor, ceil, abs, sqrt

```lua
print(math.floor(5.8))   -- 5
print(math.ceil(5.2))    -- 6
print(math.abs(-42))     -- 42
print(math.sqrt(81))     -- 9
```

### max, min

```lua
print(math.max(1,5,9))   -- 9
print(math.min(-3,2,7))  -- -3
```

### Random

```lua
math.randomseed(os.time())   -- set seed
print(math.random())         -- random 0..1
print(math.random(6))        -- 1..6
print(math.random(10,20))    -- 10..20
```

---

## 4.3 Fungsi Lanjutan

### Log, exp, pow

```lua
print(math.log(100, 10))     -- 2
print(math.exp(1))           -- ~2.718 (e^1)
print(math.pow(2, 8))        -- 256
```

### Trigonometri

```lua
local rad = math.rad(180)    -- konversi derajat → radian
print(rad)                   -- 3.14159 (π)

print(math.deg(math.pi/2))   -- 90

print(math.sin(math.rad(30))) -- 0.5
print(math.cos(math.rad(60))) -- 0.5
print(math.tan(math.rad(45))) -- ~1
```

### Konstanta

```lua
print(math.pi)    -- 3.14159
print(math.huge)  -- representasi ∞
```

---

## 4.4 Studi Kasus

### Kalkulator sederhana

```lua
function calculator(a, b, op)
  if op == "add" then return a+b end
  if op == "sub" then return a-b end
  if op == "mul" then return a*b end
  if op == "div" then return a/b end
  return nil, "Unknown op"
end

print(calculator(10, 5, "mul"))  -- 50
```

### Generator dadu

```lua
math.randomseed(os.time())
print("Hasil lempar dadu:", math.random(1,6))
```

### Konversi koordinat

```lua
local deg = 120
local rad = math.rad(deg)
print(string.format("%d derajat = %.2f radian", deg, rad))
```

---

## Visualisasi (ASCII Diagram)

```
┌──────────────────────────────┐
│         Math Library         │
│ ┌───────────┬──────────────┐ │
│ │ Dasar     │ Lanjutan     │ │
│ │ floor     │ log, exp     │ │
│ │ ceil      │ pow          │ │
│ │ abs       │ trig (sin..) │ │
│ │ sqrt      │ rad, deg     │ │
│ │ max, min  │ konstanta    │ │
│ │ random    │ pi, huge     │ │
│ └───────────┴──────────────┘ │
└──────────────────────────────┘
```

---

## Praktik Terbaik

* Selalu set `math.randomseed(os.time())` sekali di awal program untuk menghindari hasil pseudo-random yang sama.
* Gunakan `math.rad` dan `math.deg` agar perhitungan sudut konsisten (Lua trig memakai radian).
* Untuk presisi tinggi (big number), gunakan library eksternal seperti [Lua BigNum](https://luarocks.org/modules/fornwall/bignum).

---

## Kesalahan Umum & Solusi

* **Mengira math.random benar-benar random** → sebenarnya pseudo-random. Untuk kriptografi, gunakan library khusus.
* **Lupa set seed** → hasil random selalu sama tiap run.
* **Kesalahan radian vs derajat** → semua fungsi trig di Lua memakai radian. Gunakan `math.rad` untuk konversi.
* **Overflow integer** → integer di Lua terbatas (64-bit). Gunakan float atau library eksternal untuk beyond.

---

## Latihan & Kuiz

1. Buat fungsi `circle_area(r)` yang menghitung luas lingkaran.
2. Gunakan `math.random` untuk membuat simulasi koin (head/tail) sebanyak 10 kali.
3. Apa output dari `math.deg(math.pi)`? (jawaban: 180).

---

## Hubungan dengan Modul Lain

* **Modul 3 (Table):** hasil random sering disimpan ke table.
* **Modul 7 (Package):** library tambahan matematika dapat di-*require* untuk memperluas fungsionalitas.
* **Modul 11 (OS):** `os.time()` sering digunakan untuk seed random.

---

## Referensi

* Lua 5.4 Reference Manual — [Math Library](https://www.lua.org/manual/5.4/manual.html#6.7)
* Programming in Lua (Ierusalimschy) — Bab 3 (numbers) & Bab 8 (libraries)
* Artikel: [Lua Math Examples](https://www.tutorialspoint.com/lua/lua_math_library.htm)

---

# Mini-Project: Simulasi Statistik Lempar Dadu

**Mini-project berbasis Math + Table (simulasi statistik lempar dadu)** agar ada penguatan praktik nyata sebelum masuk ke pembahasan `io`.

---

### Tujuan

* Menggabungkan **Math Library (`math`)** untuk menghasilkan nilai acak.
* Menggunakan **Table (`table`)** untuk menyimpan dan menghitung distribusi hasil.
* Melatih pemahaman tentang iterasi, counting, dan probabilitas dasar.

---

## Deskripsi Proyek

Kita akan membuat program yang:

1. Melempar dadu sebanyak `N` kali (misalnya 1000 kali).
2. Mencatat berapa kali setiap angka (1–6) muncul.
3. Menghitung persentase distribusi hasil.
4. Menampilkan hasil dalam bentuk laporan tabel sederhana.

---

## Implementasi Kode

```lua
-- dadu.lua
-- Mini-project: simulasi lempar dadu

-- set seed random berdasarkan waktu
math.randomseed(os.time())

-- jumlah percobaan
local N = 1000

-- inisialisasi tabel hasil (setiap sisi mulai 0)
local counts = {1=0, 2=0, 3=0, 4=0, 5=0, 6=0}

-- lakukan simulasi
for i = 1, N do
  local roll = math.random(1, 6)  -- lempar dadu
  counts[roll] = counts[roll] + 1
end

-- tampilkan hasil
print("Hasil Simulasi Lempar Dadu (" .. N .. " kali):")
print("-----------------------------------------")
for face = 1, 6 do
  local freq = counts[face]
  local percent = (freq / N) * 100
  print(string.format("Angka %d: %d kali (%.2f%%)", face, freq, percent))
end
```

---

## Output Contoh

```
Hasil Simulasi Lempar Dadu (1000 kali):
-----------------------------------------
Angka 1: 173 kali (17.30%)
Angka 2: 163 kali (16.30%)
Angka 3: 168 kali (16.80%)
Angka 4: 156 kali (15.60%)
Angka 5: 172 kali (17.20%)
Angka 6: 168 kali (16.80%)
```

Distribusi akan mendekati **\~16.7%** untuk setiap sisi seiring semakin besar jumlah percobaan (N → besar).

---

## Visualisasi Konsep (ASCII Diagram)

```
┌───────────────────────────────┐
│        Math.random(1,6)       │
│ (hasil lempar dadu acak)      │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│   Table counts[1..6]          │
│   Inisialisasi: 0             │
│   Update: counts[roll] += 1   │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│   Laporan distribusi          │
│   - jumlah tiap angka         │
│   - persentase (%)            │
└───────────────────────────────┘
```

---

## Latihan Tambahan

1. Ubah program agar bisa mensimulasikan **dua dadu sekaligus**, lalu hitung distribusi jumlah total (2–12).
2. Buat fungsi untuk mencari nilai **modus** (angka yang paling sering muncul).
3. Tambahkan opsi agar jumlah percobaan (N) diminta dari input pengguna (`io.read`).

---

## Praktik Terbaik

* Gunakan **table sebagai histogram** (pola umum di statistik).
* Gunakan **string.format** untuk memastikan laporan rapi.
* Untuk percobaan besar, hindari print dalam loop → simpan hasil lalu print akhir.

---

## Kesalahan Umum

* **Lupa math.randomseed(os.time())** → hasil selalu sama tiap run.
* **Menginisialisasi counts salah** → harus angka 0, bukan `nil`.
* **Membandingkan hasil distribusi dengan ekspektasi kecil** → ingat, distribusi mendekati rata-rata hanya jika N besar.

---

# Lanjut ke Modul 5 — I/O Library (`io`)

Mini-project ini sudah selesai, dan konsepnya akan sangat cocok saat kita masuk ke **I/O**, karena kita bisa menambahkan fitur: **menyimpan hasil simulasi ke file** (misalnya `hasil.txt`). Itu akan kita lakukan di Modul 5 nanti.

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

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
