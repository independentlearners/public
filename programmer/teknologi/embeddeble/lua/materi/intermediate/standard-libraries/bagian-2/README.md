# [Modul 2 — String Library (`string`)][0]

<details>
  <summary>📃 Daftar Isi</summary>

### Struktur Pembelajaran Internal (mini-TOC)

---

* **2.1 Pengenalan String di Lua**

  * Representasi string (immutable, memory model)
  * Operator dasar (`..`, `#`)
  * Peran penting string di Lua
* **2.2 Fungsi-Fungsi Dasar String**

  * Panjang, substring, upper/lower
  * String.format
  * Studi kasus kecil
* **2.3 String Patterns**

  * Konsep dasar pattern Lua (beda dengan regex)
  * Fungsi utama (`string.find`, `string.match`, `string.gmatch`, `string.gsub`)
  * Karakter khusus pattern (`.`, `%d`, `%a`, dll.)
  * Studi kasus parsing teks sederhana
* Latihan & kuiz singkat
* Praktik terbaik & kesalahan umum
* Diagram & visualisasi

</details>

---

## 2.1 Pengenalan String di Lua

### Deskripsi Konkret & Peran

String adalah **tipe data teks** yang digunakan untuk menyimpan urutan karakter. Dalam Lua, string bersifat **immutable** (tidak dapat diubah setelah dibuat). Setiap operasi menghasilkan string baru. Hal ini penting untuk efisiensi memory dan konsistensi.

String adalah tipe fundamental karena:

* Banyak API Lua menggunakan string untuk key table, argumen fungsi, pattern, dll.
* Konsep pattern matching di Lua menjadi pondasi untuk parsing sederhana tanpa harus memakai regex eksternal.

### Filosofi & Konsep

* **Immutable design:** menjamin keamanan (tidak ada side-effect pada string lain).
* **Lightweight concatenation:** meskipun immutable, Lua memiliki VM yang efisien untuk operasi string.
* **Pattern-based parsing:** Lua tidak mendukung regex penuh (seperti PCRE) tetapi menawarkan **string patterns** yang lebih ringan, cukup untuk banyak keperluan.

### Sintaks dasar

```lua
-- membuat string
local s = "Halo Dunia"
local t = 'Belajar Lua'  -- kutip tunggal juga valid

-- operator penggabungan
local full = s .. " - " .. t
print(full)  -- "Halo Dunia - Belajar Lua"

-- panjang string
print(#s)    -- 10
```

### Terminologi

* **Immutable:** tidak dapat diubah setelah diciptakan.
* **Concatenation:** penggabungan string dengan operator `..`.
* **Length operator `#`:** mengembalikan jumlah byte karakter (UTF-8 dihitung per byte, hati-hati untuk karakter multibyte).

---

## 2.2 Fungsi-Fungsi Dasar String

### Fungsi inti dalam modul `string`

1. **`string.len(s)`** — panjang string (sama dengan `#s`).
2. **`string.sub(s, i, j)`** — potong substring dari index `i` sampai `j`.
3. **`string.upper(s)` / `string.lower(s)`** — ubah huruf kapital / kecil.
4. **`string.rep(s, n)`** — ulang string `n` kali.
5. **`string.format(fmt, ...)`** — format seperti C `printf`.

### Contoh implementasi

```lua
local text = "Belajar Lua"

print(string.len(text))         -- 11
print(string.sub(text, 1, 7))   -- "Belajar"
print(string.upper(text))       -- "BELAJAR LUA"
print(string.lower(text))       -- "belajar lua"
print(string.rep("ha", 3))      -- "hahaha"

local name, score = "Ameer", 95
print(string.format("Nama: %s, Nilai: %d", name, score))
-- "Nama: Ameer, Nilai: 95"
```

### Studi kasus kecil

Membuat laporan sederhana:

```lua
local user = {name="Cendekiawan", level=7}
local report = string.format("User %s berada di level %d", user.name, user.level)
print(report)
```

---

## 2.3 String Patterns

### Konsep

* **Pattern Lua ≠ Regex penuh**. Pattern di Lua lebih sederhana, tetapi powerful.
* Digunakan dengan `string.find`, `string.match`, `string.gmatch`, `string.gsub`.

### Fungsi utama

* **`string.find(s, pattern)`** → posisi pertama cocok.
* **`string.match(s, pattern)`** → nilai substring yang cocok.
* **`string.gmatch(s, pattern)`** → iterator untuk semua match.
* **`string.gsub(s, pattern, repl)`** → ganti substring sesuai pola.

### Karakter khusus pattern

* `.` — sembarang karakter.
* `%a` — huruf alfabet.
* `%d` — digit angka.
* `%s` — spasi/whitespace.
* `+`, `*`, `-` — kuantifier (1+, 0+, 0-).
* `^`, `$` — anchor awal & akhir string.

### Contoh implementasi

```lua
local s = "Lua 5.4 released 2020"

-- cari angka pertama
local num = string.match(s, "%d+")
print(num)  -- "5"

-- cari semua kata
for word in string.gmatch(s, "%a+") do
  print(word)
end
-- output:
-- Lua
-- released

-- ganti angka dengan 'X'
local replaced = string.gsub(s, "%d", "X")
print(replaced)  -- "Lua X.X released XXXX"
```

### Studi kasus parsing sederhana

Ambil semua email dalam teks:

```lua
local text = "hubungi admin@mail.com atau support@domain.org"
for email in string.gmatch(text, "[%w%.]+@[%w%.]+") do
  print(email)
end
-- output:
-- admin@mail.com
-- support@domain.org
```

---

## Visualisasi (ASCII Diagram)

```
┌─────────────────────────────┐
│  String Library (string)    │
│  ┌───────────────────────┐  │
│  │ Operator Dasar        │  │
│  │ ".." (concat)         │  │
│  │ "#"  (length)         │  │
│  └──────────┬────────────┘  │
│  ┌──────────▼────────────┐  │
│  │ Fungsi Dasar          │  │
│  │ len, sub, upper, ...  │  │
│  └──────────┬────────────┘  │
│  ┌──────────▼────────────┐  │
│  │ String Patterns       │  │
│  │ find, match, gmatch   │  │
│  │ gsub                  │  │
│  └───────────────────────┘  │
└─────────────────────────────┘
```

---

## Praktik Terbaik

* Gunakan `string.format` untuk output terformat agar rapi.
* Jangan mengandalkan `#` untuk panjang karakter UTF-8 (gunakan library tambahan seperti [utf8](https://www.lua.org/manual/5.4/manual.html#6.5)).
* Hati-hati dengan `gsub`: selalu verifikasi pattern agar tidak mengganti berlebihan.
* Untuk parsing kompleks (regex full), gunakan library eksternal (misalnya [lrexlib](https://luarocks.org/modules/rrt/lrexlib)).

---

## Kesalahan Umum & Solusi

* **Salah memahami indeks**: `string.sub` mulai dari 1, bukan 0.
* **Expect regex penuh**: Lua pattern tidak mendukung lookahead/lookbehind, gunakan library eksternal jika butuh.
* **UTF-8 error**: `#` menghitung byte, bukan karakter. Solusi: gunakan modul `utf8` bawaan (Lua 5.3+).
* **Over-replace dengan `gsub`**: jika pattern terlalu umum, bisa mengganti bagian yang tidak diinginkan.

---

## Latihan & Kuiz

1. Buat fungsi `mask_email(email)` yang mengganti bagian user menjadi `***` tapi tetap menampilkan domain.
   Input: `"user123@mail.com"` → Output: `"***@mail.com"`.
2. Gunakan `string.gmatch` untuk menghitung jumlah kata dalam sebuah kalimat.
3. Apa hasil dari `string.match("abc123", "%a+")`? (jawaban: `"abc"`).

---

## Hubungan dengan Modul Lain

* **Modul 3 (Table):** sering digabung dengan string untuk manipulasi data (misalnya memecah string menjadi array).
* **Modul 6 (Coroutine):** string pattern sering digunakan pada parser ringan yang digabung dengan coroutine.
* **Modul 15 (UTF-8 Library):** mendalami representasi karakter multibyte untuk pemrosesan internasionalisasi.

---

## Referensi

* Lua Reference Manual 5.4 — [String Manipulation](https://www.lua.org/manual/5.4/manual.html#6.4)
* Lua-users wiki — [String Library Tutorial](http://lua-users.org/wiki/StringLibraryTutorial)
* Lua-users wiki — [Patterns Tutorial](http://lua-users.org/wiki/PatternsTutorial)
* Lua 5.4 Manual — [utf8 library](https://www.lua.org/manual/5.4/manual.html#6.5)

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

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
